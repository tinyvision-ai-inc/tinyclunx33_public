/**
* @page fpga_top_som_no_mipi
* @brief Top level file for the FPGA
*/
`default_nettype wire

module fpga_top_som_no_mipi (
  input  wire       button_n            , // Reset button from devboard
  input  wire       clk_2               , // Clock from PLL, usually set to 24MHz as this is a common value
  input  wire       uart_rxd            ,
  output wire       uart_txd            ,
  inout  wire       scl                 ,
  inout  wire       sda                 ,
  output wire       spiflash_clk        ,
  output wire       spiflash_cs_n       ,
  inout  wire [3:0] spiflash_dq         ,
  inout  wire       mipi_rx_clk_p       ,
  inout  wire       mipi_rx_clk_m       ,
  inout  wire [1:0] mipi_rx_dat_p       ,
  inout  wire [1:0] mipi_rx_dat_m       ,
  inout  wire       mipi_tx_clk_p       ,
  inout  wire       mipi_tx_clk_m       ,
  inout  wire [1:0] mipi_tx_dat_p       ,
  inout  wire [1:0] mipi_tx_dat_m       ,
  inout  wire       VBUS_i              ,
  inout  wire       usb23_DMP           ,
  inout  wire       usb23_DP            ,
  input  wire       usb23_REFINCLKEXTM_i,
  input  wire       usb23_REFINCLKEXTP_i,
  inout  wire       usb23_RESEXTUSB2    ,
  input  wire       usb23_RXMP_i        ,
  input  wire       usb23_RXPP_i        ,
  output wire       usb23_TXMP_o        ,
  output wire       usb23_TXPP_o,
  
	input wire TCK,
	input wire TDI,
	output wire TDO,
	input wire TMS
);

  `ifdef FAST_SIM
    localparam NUM_COLS     = 40;
    localparam NUM_ROWS     = 30;
    localparam F_PORCH      = 2 ;
    localparam V_SYNCH      = 2 ;
    localparam V_BACK_PORCH = 4 ;
  `else
    localparam NUM_COLS     = 1920;
    localparam NUM_ROWS     = 1080;
    localparam F_PORCH      = 100 ;
    localparam V_SYNCH      = 100 ;
    localparam V_BACK_PORCH = 500 ;
  `endif

  localparam PIXEL_BITS = 'd10;

/*------------------------------------------------------------------------------
--  Internal oscillator
------------------------------------------------------------------------------*/
  // Local oscillator for startup
  logic hf_clk, lf_clk;
  int_osc u_int_osc (
    .hf_out_en_i ('1    ),
    .hf_clk_out_o(hf_clk), // 45 MHz
    .lf_clk_out_o(lf_clk)  // 32 kHz
  );

  // Hold design in reset under external control
  logic reset, reset_n;
  fpga_reset u_fpga_reset (.clk(lf_clk), .reset_n_i(button_n), .reset_n_o(reset_n));
  assign reset = ~reset_n;

  // A PLL generates various frequencies for the design:
  wire pll_lock, clk_60m, clk_os2, pixel_clk, camera_mclk, tx_clk, tx_clk_90, byte_clk;
  main_pll u_main_pll (
    .clki_i  (clk_2    ),
    .rstn_i  (reset_n  ),
    .clkop_o (clk_60m  ), // 60 MHz
    .clkos_o (pixel_clk), // 100 MHz
    .clkos2_o(clk_os2 ), // 80 MHz
    .clkos3_o(byte_clk ), // 50 MHz
    .clkos4_o(tx_clk   ), // 200 MHz
    .clkos5_o(tx_clk_90), // 200 MHz
    .lock_o  (pll_lock )
  );

  logic pixel_rst_n;
  fpga_reset pix_rst_sync (.clk(pixel_clk), .reset_n_i(pll_lock), .reset_n_o(pixel_rst_n)); 
  logic byte_rst_n;
  fpga_reset byte_rst_sync (.clk(byte_clk), .reset_n_i(pll_lock), .reset_n_o(byte_rst_n));

  // Switch the USB clock to the PLL output once the PLL locks. This is a stopgap measure for now.
  // @TBD: Currently, the USB reference clock and processor clock are the same. Ideally, we will want
  // the USB reference clock to come from the external source while the processor runs on a different clock.
  // The DCS block will then be used to switch only the processor clock as the processor has to be
  // clocked to initialize the external PLL to produce a clock.
  logic proc_clk;
  defparam i_dcs.DCSMODE = "DCS";
  DCS i_dcs (
    .CLK0    (hf_clk  ),
    .CLK1    (clk_os2 ),
    .SEL     (pll_lock),
    .SELFORCE('0      ),
    .DCSOUT  (proc_clk )
  );

logic proc_rst, proc_rst_n;
rst_sync proc_rst_sync (.clk(proc_clk), .async_rst_n(reset_n), .sync_rst_n(proc_rst_n));
assign proc_rst = ~proc_rst_n;

  wire usb_clk = clk_60m;
  logic usb_rst_n, usb_rst;
  rst_sync usb_rst_sync (.clk(usb_clk), .async_rst_n(reset_n), .sync_rst_n(usb_rst_n));
  assign usb_rst = ~usb_rst_n;

/*------------------------------------------------------------------------------
--  Wishbone interconnect: connects the processor to the USB as well as the CSR
-- and other peripherals.
------------------------------------------------------------------------------*/
  wire wb_clk = proc_clk;
  wire wb_rst = proc_rst;
  wire wb_rst_n = ~wb_rst;
  `include "wb_intercon.vh"

/*------------------------------------------------------------------------------
--  AXI infrastructure to communicate with the USB and other stuff
------------------------------------------------------------------------------*/
`include "axi_infrastructure.sv"
assign axiReset = proc_rst;
assign axiClk = proc_clk;

// Having a WDT present is necessary to have access to the jtag pins as IO; dont know why exactly.
WDT wdt(
	.WDTRELOAD(0),
	.WDT_CLK(0),
	.WDT_RST(0)
);

wire          jtag_tms;
wire          jtag_tck;
wire          jtag_capture;
wire		  jtag_reset;

wire jtag_tdi_som;
wire jtag_tdo_som;

assign jtag_tms = TMS;
assign jtag_tdi_som = TDI;
assign TDO = jtag_tdo_som;
assign jtag_tck = TCK;

assign jtag_reset = wb_rst;


/*------------------------------------------------------------------------------
--  LiteX design
------------------------------------------------------------------------------*/
  logic        irq_usb23    ;
  logic        irq_frame    ;
  logic [31:0] wb_adr       ;
  logic [3:0]  spi_dq;
  som i_litex_soc_gen (
    .i2c0_scl       (scl           ),
    .i2c0_sda       (sda           ),
    .serial_rx      (uart_rxd      ),
    .serial_tx      (uart_txd      ),
    .spiflash4x_clk (spiflash_clk  ),
    .spiflash4x_cs_n(spiflash_cs_n ),
    .spiflash4x_dq  (spiflash_dq   ),
    .sys_clk        (wb_clk        ),
    .sys_rst        (wb_rst        ),
    // Wishbone master
    .wishbone0_adr  (wb_adr        ),
    .wishbone0_bte  (wb_m2s_wb0_bte),
    .wishbone0_cti  (wb_m2s_wb0_cti),
    .wishbone0_cyc  (wb_m2s_wb0_cyc),
    .wishbone0_dat_w(wb_m2s_wb0_dat),
    .wishbone0_sel  (wb_m2s_wb0_sel),
    .wishbone0_stb  (wb_m2s_wb0_stb),
    .wishbone0_we   (wb_m2s_wb0_we ),
    .wishbone0_ack  (wb_s2m_wb0_ack),
    .wishbone0_dat_r(wb_s2m_wb0_dat),
    .wishbone0_err  (wb_s2m_wb0_err),
    .usb230_irq     (irq_usb23     ),
    .framectl0_irq  (irq_frame     ),
	.jtag_tdo(jtag_tdo_som),
	.jtag_tdi(jtag_tdi_som),
	.*
  );
  

  // Wishbone is 32 bit aligned
  assign wb_m2s_wb0_adr = {wb_adr[29:0], 2'b0};


/*------------------------------------------------------------------------------
--  CSR bank
------------------------------------------------------------------------------*/
  // WB never has errors :)
  assign wb_s2m_csr_err = 0;
  assign wb_s2m_csr_rty = 0;

  wire                      rx_en                 ;
  wire                      tx_en                 ;
  wire                      buffer_full_err   = '0;
  wire                      test_pattern_en       ;
  wire                      test_pattern_type     ;
  wire [$clog2(NUM_COLS):0] num_cols              ;
  wire [$clog2(NUM_ROWS):0] num_rows              ;
  wire [              31:0] num_frames            ;
  wire [              31:0] avg_chan_0            ;
  wire [              31:0] avg_chan_1            ;
  wire [              31:0] avg_chan_2            ;
  wire [              31:0] avg_chan_3            ;
  wire [               7:0] gain_chan_0           ;
  wire [               7:0] gain_chan_1           ;
  wire [               7:0] gain_chan_2           ;
  wire [               7:0] gain_chan_3           ;
  parameter                 ACCUM_OUT_BITS    = 10;

  wb_csr #(
    .MAX_COL_PIXELS(NUM_COLS),
    .MAX_ROW_PIXELS(NUM_ROWS),
    .PIXEL_BITS    (10      )
  ) i_wb_csr (
    // Wishbone clock domain:
    .wb_clk           (wb_clk           ),
    .wb_rst           (wb_rst           ),
    .wb_adr_i         (wb_m2s_csr_adr   ),
    .wb_dat_i         (wb_m2s_csr_dat   ),
    .wb_sel_i         (wb_m2s_csr_sel   ),
    .wb_we_i          (wb_m2s_csr_we    ),
    .wb_cyc_i         (wb_m2s_csr_cyc   ),
    .wb_stb_i         (wb_m2s_csr_stb   ),
    .wb_dat_o         (wb_s2m_csr_dat   ),
    .wb_ack_o         (wb_s2m_csr_ack   ),
    .wb_err_o         (                 ),
    // Following operates in its own clock domain:
    .clk              (pixel_clk        ),
    .rst              (~pixel_rst_n     ),
    .buffer_full_err  (buffer_full_err  ),
    .pll_locked       (pll_lock         ),
    .rx_en            (rx_en            ),
    .tx_en            (tx_en            ),
    .test_pattern_en  (test_pattern_en  ),
    .test_pattern_type(test_pattern_type),
    .num_cols         (num_cols         ),
    .num_rows         (num_rows         ),
    .num_frames       (num_frames       ),
    .avg_chan_0       (avg_chan_0       ),
    .avg_chan_1       (avg_chan_1       ),
    .avg_chan_2       (avg_chan_2       ),
    .avg_chan_3       (avg_chan_3       ),
    .gain_chan_0      (gain_chan_0      ),
    .gain_chan_1      (gain_chan_1      ),
    .gain_chan_2      (gain_chan_2      ),
    .gain_chan_3      (gain_chan_3      )
  );


/*------------------------------------------------------------------------------
--  Image processing core can operate in a different clock domain:
------------------------------------------------------------------------------*/
  wire [31:0] wb_m2s_sl_pxl_adr;
  wire [31:0] wb_m2s_sl_pxl_dat;
  wire [ 3:0] wb_m2s_sl_pxl_sel;
  wire        wb_m2s_sl_pxl_we ;
  wire        wb_m2s_sl_pxl_cyc;
  wire        wb_m2s_sl_pxl_stb;
  wire [31:0] wb_s2m_sl_pxl_dat;
  wire        wb_s2m_sl_pxl_ack;
  wb_cdc_mod i_wb_sl_cdc (
    .wbm_clk  (wb_clk           ),
    .wbm_rst  (wb_rst           ),
    .wbm_adr_i(wb_m2s_sl_adr    ),
    .wbm_dat_i(wb_m2s_sl_dat    ),
    .wbm_sel_i(wb_m2s_sl_sel    ),
    .wbm_we_i (wb_m2s_sl_we     ),
    .wbm_cyc_i(wb_m2s_sl_cyc    ),
    .wbm_stb_i(wb_m2s_sl_stb    ),
    .wbm_dat_o(wb_s2m_sl_dat    ),
    .wbm_ack_o(wb_s2m_sl_ack    ),
    .wbs_clk  (pixel_clk        ),
    .wbs_rst  (~pixel_rst_n     ),
    .wbs_adr_o(wb_m2s_sl_pxl_adr),
    .wbs_dat_o(wb_m2s_sl_pxl_dat),
    .wbs_sel_o(wb_m2s_sl_pxl_sel),
    .wbs_we_o (wb_m2s_sl_pxl_we ),
    .wbs_cyc_o(wb_m2s_sl_pxl_cyc),
    .wbs_stb_o(wb_m2s_sl_pxl_stb),
    .wbs_dat_i(wb_s2m_sl_pxl_dat),
    .wbs_ack_i(wb_s2m_sl_pxl_ack)
  );

  // WB never has errors :)
  assign wb_s2m_sl_err = 0;
  assign wb_s2m_sl_rty = 0;

  // Tie off lines for now: there should eventually be a Wishbone CSR here
  assign wb_s2m_sl_pxl_dat = 'hfeedf00d;
  assign wb_s2m_sl_pxl_ack = wb_m2s_sl_pxl_cyc & wb_m2s_sl_pxl_stb;

/*------------------------------------------------------------------------------
--  Wishbone to AXI bridge allows the processor to talk to the scratch RAM in
-- dedicated to the USB.
------------------------------------------------------------------------------*/
  wb2axi4 #(
    .AW              (24),
    .C_AXI_ADDR_WIDTH(24)
  ) i_wbm2axi4 (
    .i_clk        (wb_clk                      ),
    .i_reset      (wb_rst                      ),
    // Wishbone Slave
    .wb_cyc_i     (wb_m2s_scratch_ram_cyc      ),
    .wb_stb_i     (wb_m2s_scratch_ram_stb      ),
    .wb_cti_i     (wb_m2s_scratch_ram_cti      ),
    .wb_bte_i     (wb_m2s_scratch_ram_bte      ),
    .wb_we_i      (wb_m2s_scratch_ram_we       ),
    .wb_adr_i     (wb_m2s_scratch_ram_adr[23:0]),
    .wb_data_i    (wb_m2s_scratch_ram_dat      ),
    .wb_sel_i     (wb_m2s_scratch_ram_sel      ),
    .wb_ack_o     (wb_s2m_scratch_ram_ack      ),
    .wb_data_o    (wb_s2m_scratch_ram_dat      ),
    .wb_err_o     (wb_s2m_scratch_ram_err      ),
    // AXI Master  
    .o_axi_awvalid(axi0_awvalid                ),
    .i_axi_awready(axi0_awready                ),
    .o_axi_awid   (axi0_awid[0]                ),
    .o_axi_awaddr (axi0_awaddr                 ),
    .o_axi_awlen  (axi0_awlen                  ),
    .o_axi_awsize (axi0_awsize                 ),
    .o_axi_awburst(axi0_awburst                ),
    .o_axi_awlock (axi0_awlock                 ),
    .o_axi_awcache(axi0_awcache                ),
    .o_axi_awprot (axi0_awprot                 ),
    .o_axi_awqos  (                            ),
    .o_axi_wvalid (axi0_wvalid                 ),
    .i_axi_wready (axi0_wready                 ),
    .o_axi_wdata  (axi0_wdata                  ),
    .o_axi_wstrb  (axi0_wstrb                  ),
    .o_axi_wlast  (axi0_wlast                  ),
    .i_axi_bvalid (axi0_bvalid                 ),
    .o_axi_bready (axi0_bready                 ),
    .i_axi_bid    (axi0_bid[0]                 ),
    .i_axi_bresp  ('0                          ),
    .o_axi_arvalid(axi0_arvalid                ),
    .i_axi_arready(axi0_arready                ),
    .o_axi_arid   (axi0_arid[0]                ),
    .o_axi_araddr (axi0_araddr                 ),
    .o_axi_arlen  (axi0_arlen                  ),
    .o_axi_arsize (axi0_arsize                 ),
    .o_axi_arburst(axi0_arburst                ),
    .o_axi_arlock (axi0_arlock                 ),
    .o_axi_arcache(axi0_arcache                ),
    .o_axi_arprot (axi0_arprot                 ),
    .o_axi_arqos  (                            ),
    .i_axi_rvalid (axi0_rvalid                 ),
    .o_axi_rready (axi0_rready                 ),
    .i_axi_rid    (axi0_rid[0]                 ),
    .i_axi_rdata  (axi0_rdata                  ),
    .i_axi_rresp  ('0                          ),
    .i_axi_rlast  (axi0_rlast                  )
  );

/*------------------------------------------------------------------------------
--  Convert WB to LMMI to talk to the USB core
------------------------------------------------------------------------------*/
  logic [31:0] lmmi_rdata      ;
  logic        lmmi_rdata_valid;
  logic        lmmi_ready      ;
  logic        lmmi_request    ;
  logic        lmmi_wr_rdn     ;
  logic [15:0] lmmi_offset     ;
  logic [31:0] lmmi_wdata      ;
  wb2lmmi i_wb2lmmi (
    .clk     (wb_clk             ),
    .rst     (wb_rst             ),
    .wb_cyc  (wb_m2s_usb_cyc      ),
    .wb_stb  (wb_m2s_usb_stb      ),
    .wb_adr  (wb_m2s_usb_adr[17:0]),
    .wb_we   (wb_m2s_usb_we       ),
    .wb_dat_w(wb_m2s_usb_dat      ),
    .wb_ack  (wb_s2m_usb_ack      ),
    .wb_err  (wb_s2m_usb_err      ),
    .wb_dat_r(wb_s2m_usb_dat      ),
    .*
  );

  //------------------------------------------------------------------------------------------------------------
  // USB23 Primitive
  //------------------------------------------------------------------------------------------------------------
  USB23 #(
    .USB_MODE("USB23"  ),
    .GSR     ("ENABLED")
  ) USB23_primitive_inst (
    // USB Mode of operation
    // Global Set Reset
    // *********************************************************************
    // Clock Signals
    // *********************************************************************
    // USB 2.0 & 3.0 Internal Clock
    .USBPHY_REFCLK_ALT (usb_clk             ), // Input @TBD VR: check this out!
    // USB 2.0 PHY External Clock
    .XOIN18            (1'b0                ), // Input
    .XOOUT18           (                    ), // Output
    // USB 3.0 PHY External Differential Clock
    .REFINCLKEXTP      (usb23_REFINCLKEXTP_i), // Input
    .REFINCLKEXTM      (usb23_REFINCLKEXTM_i), // Input
    // Other Clocks
    .USB3_MCUCLK       (wb_clk              ), // Input
    .USB_SUSPENDCLK    (usb_clk             ), // Input
    // *********************************************************************
    // Reset Signals
    // *********************************************************************
    .USB3_SYSRSTN      (usb_rst_n           ), // Input
    .USB_RESETN        (usb_rst_n           ), // Input
    .USB2_RESET        (usb_rst             ), // Input
    // *********************************************************************
    // USB23 High Speed Lines
    // *********************************************************************
    // USB 2.0 Lines
    .DP                (usb23_DP            ), // IO
    .DM                (usb23_DMP           ), // IO
    // USB 3.0 Lines
    .RXM               (usb23_RXMP_i        ), // Input
    .RXP               (usb23_RXPP_i        ), // Input
    .TXM               (usb23_TXMP_o        ), // Output
    .TXP               (usb23_TXPP_o        ), // Output
    // *********************************************************************
    // Configuration Path
    // *********************************************************************
    // LMMI Configuration path Signals
    .LMMICLK           (wb_clk             ), // Input
    .LMMIRESETN        (wb_rst_n           ), // Input
    .LMMIREQUEST       (lmmi_request        ), // Input
    .LMMIWRRD_N        (lmmi_wr_rdn         ), // Input
    .LMMIOFFSET        (lmmi_offset[14:0]   ), // Input
    .LMMIWDATA         (lmmi_wdata          ), // Input
    .LMMIRDATAVALID    (lmmi_rdata_valid    ), // Output
    .LMMIREADY         (lmmi_ready          ), // Output
    .LMMIRDATA         (lmmi_rdata          ), // Output
    // *********************************************************************
    // Data Path
    // *********************************************************************
    // AXI Master Write Address Channel Signals
    .XMAWADDR          (usbM_awaddr         ),
    .XMAWVALID         (usbM_awvalid        ),
    .XMAWSIZE          (usbM_awsize         ),
    .XMAWLEN           (usbM_awlen          ),
    .XMAWBURST         (usbM_awburst        ),
    .XMAWID            (usbM_awid           ),
    .XMAWLOCK          (), // @TBD:  usbM_awlock         ),
    .XMAWCACHE         (usbM_awcache        ),
    .XMAWPROT          (usbM_awprot         ),
    .XMAWREADY         (usbM_awready        ),
    .XMAWMISC_INFO     (                    ),
    // AXI Master Write Data Channel Signals
    .XMWDATA           (usbM_wdata          ),
    .XMWSTRB           (usbM_wstrb          ),
    .XMWVALID          (usbM_wvalid         ),
    .XMWLAST           (usbM_wlast          ),
    .XMWID             (), // @TBD: usbM_wid            ),
    .XMWREADY          (usbM_wready         ),
    // AXI Master Read Data Channel Signals
    .XMBID             (usbM_bid            ),
    .XMBVALID          (usbM_bvalid         ),
    .XMBRESP           (), // @TBD: usbM_bresp          ),
    .XMBREADY          (usbM_bready         ),
    .XMBMISC_INFO      (                    ),
    // AXI Master Read Address Channel Signals
    .XMARADDR          (usbM_araddr         ),
    .XMARVALID         (usbM_arvalid        ),
    .XMARLEN           (usbM_arlen          ),
    .XMARSIZE          (usbM_arsize         ),
    .XMARBURST         (usbM_arburst        ),
    .XMARID            (usbM_arid           ),
    .XMARLOCK          (), // @TBD: usbM_arlock         ),
    .XMARCACHE         (usbM_arcache        ),
    .XMARPROT          (usbM_arprot         ),
    .XMARMISC_INFO     (                    ),
    .XMARREADY         (usbM_arready        ),
    // AXI Master Write Response Channel Signals
    .XMRID             (usbM_rid            ),
    .XMRVALID          (usbM_rvalid         ),
    .XMRLAST           (usbM_rlast          ),
    .XMRDATA           (usbM_rdata          ),
    .XMRMISC_INFO      (                    ),
    .XMRRESP           (), // @TBD: usbM_rresp          ),
    .XMRREADY          (usbM_rready         ),
    // AXI bus for Lower Power
    .XMCSYSREQ         (1'b0                ), // Input
    .XMCSYSACK         (                    ), // Output
    .XMCACTIVE         (                    ), // Output
    // *********************************************************************
    // Power and Pad Signal
    // *********************************************************************
    .VBUS              (VBUS_i              ), // IO
    .ID                (1'b1                ), // Input
    // *********************************************************************
    // Interrupt Signal
    // *********************************************************************
    .INTERRUPT         (irq_usb23           ), // Output
    // *********************************************************************
    // Other Signal
    // *********************************************************************
    // Type C Support signals Controller
    .STARTRXDETU3RXDET (1'b0                ), // I
    .DISRXDETU3RXDET   (1'b0                ), // I
    .SS_RX_ACJT_EN     (1'b0                ), // I
    .SS_RX_ACJT_ININ   (1'b0                ), // I
    .SS_RX_ACJT_INIP   (1'b0                ), // I
    .SS_RX_ACJT_INIT_EN(1'b0                ), // I
    .SS_RX_ACJT_MODE   (1'b0                ), // I
    .SS_TX_ACJT_DRVEN  (1'b0                ), // I
    .SS_TX_ACJT_DATAIN (1'b0                ), // I
    .SS_TX_ACJT_HIGHZ  (1'b0                ), // I
    .SCANEN_CTRL       (1'b0                ), // I
    .SCANEN_USB3PHY    (1'b0                ), // I
    .SCANEN_CGUSB3PHY  (1'b0                ), // I
    .SCANEN_USB2PHY    (1'b0                ), // I
    .RESEXTUSB3        (                    ), // IO
    .RESEXTUSB2        (usb23_RESEXTUSB2    ), // IO
    .DISRXDETU3RXDETACK(                    ), // O
    .SS_RX_ACJT_OUTN   (                    ), // O
    .SS_RX_ACJT_OUTP   (                    )  // O
  );

endmodule
`define nettype wire
