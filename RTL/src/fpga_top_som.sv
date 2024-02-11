/**
* @page fpga_top_som
* @brief Top level file for the FPGA
*/
`default_nettype wire

module fpga_top_som (
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
  output wire       usb23_TXPP_o
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
  wire pll_lock, clk_60m, sync_clk, pixel_clk, camera_mclk, tx_clk, tx_clk_90, byte_clk;
  main_pll u_main_pll (
    .clki_i  (clk_2    ),
    .rstn_i  (reset_n  ),
    .clkop_o (clk_60m  ), // 60 MHz
    .clkos_o (pixel_clk), // 100 MHz
    .clkos2_o(sync_clk ), // 100 MHz
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
  logic usb_clk;
  defparam i_dcs.DCSMODE = "DCS";
  DCS i_dcs (
    .CLK0    (hf_clk  ),
    .CLK1    (clk_60m ),
    .SEL     (pll_lock),
    .SELFORCE('0      ),
    .DCSOUT  (usb_clk )
  );


  logic usb_rst_n, usb_rst;
  rst_sync usb_rst_sync (.clk(usb_clk), .async_rst_n(button_n), .sync_rst_n(usb_rst_n));
  assign usb_rst = ~usb_rst_n;

/*------------------------------------------------------------------------------
--  Wishbone interconnect: connects the processor to the USB as well as the CSR
-- and other peripherals.
------------------------------------------------------------------------------*/
  wire wb_clk = usb_clk;
  wire wb_rst = usb_rst;
  `include "wb_intercon.vh"

/*------------------------------------------------------------------------------
--  LiteX design
------------------------------------------------------------------------------*/
  // AXI slave
  logic [31:0] axi0_araddr  ;
  logic [ 1:0] axi0_arburst ;
  logic [ 3:0] axi0_arcache ;
  logic [ 7:0] axi0_arid    ;
  logic [ 7:0] axi0_arlen   ;
  logic [ 1:0] axi0_arlock  ;
  logic [ 2:0] axi0_arprot  ;
  logic [ 3:0] axi0_arqos   ;
  logic        axi0_arready ;
  logic [ 3:0] axi0_arregion;
  logic [ 2:0] axi0_arsize  ;
  logic        axi0_aruser  ;
  logic        axi0_arvalid ;
  logic [31:0] axi0_awaddr  ;
  logic [ 1:0] axi0_awburst ;
  logic [ 3:0] axi0_awcache ;
  logic [ 7:0] axi0_awid    ;
  logic [ 7:0] axi0_awlen   ;
  logic [ 1:0] axi0_awlock  ;
  logic [ 2:0] axi0_awprot  ;
  logic [ 3:0] axi0_awqos   ;
  logic        axi0_awready ;
  logic [ 3:0] axi0_awregion;
  logic [ 2:0] axi0_awsize  ;
  logic        axi0_awuser  ;
  logic        axi0_awvalid ;
  logic [ 7:0] axi0_bid     ;
  logic        axi0_bready  ;
  logic [ 1:0] axi0_bresp   ;
  logic        axi0_buser   ;
  logic        axi0_bvalid  ;
  logic [63:0] axi0_rdata   ;
  logic [ 7:0] axi0_rid     ;
  logic        axi0_rlast   ;
  logic        axi0_rready  ;
  logic [ 1:0] axi0_rresp   ;
  logic        axi0_ruser   ;
  logic        axi0_rvalid  ;
  logic [63:0] axi0_wdata   ;
  logic [ 7:0] axi0_wid     ;
  logic        axi0_wlast   ;
  logic        axi0_wready  ;
  logic [ 7:0] axi0_wstrb   ;
  logic        axi0_wuser   ;
  logic        axi0_wvalid  ;
  logic        irq_usb23    ;
  logic        irq_frame    ;
  logic [31:0] wb_adr       ;
  som i_litex_soc_gen (
    .i2c0_scl       (scl           ),
    .i2c0_sda       (sda           ),
    .serial_rx      (uart_rxd      ),
    .serial_tx      (uart_txd      ),
    .spiflash4x_clk (spiflash_clk  ),
    .spiflash4x_cs_n(spiflash_cs_n ),
    .spiflash4x_dq  (spiflash_dq   ),
    .sys_clk        (usb_clk       ),
    .sys_rst        (usb_rst       ),
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
    .*
  );

  // Wishbone is 32 bit aligned
  assign wb_m2s_wb0_adr = {wb_adr[29:0], 2'b0};

/*------------------------------------------------------------------------------
--  Wishbone Scratch RAM for testing: this will eventually turn into the access port
--  to communicate with teh AXI side of the design.
------------------------------------------------------------------------------*/
  wb_ram #(.depth(32)) i_wb_scratch_ram (
    .wb_clk_i(wb_clk                     ),
    .wb_rst_i(wb_rst                     ),
    .wb_adr_i(wb_m2s_scratch_ram_adr[4:0]),
    .wb_dat_i(wb_m2s_scratch_ram_dat     ),
    .wb_sel_i(wb_m2s_scratch_ram_sel     ),
    .wb_we_i (wb_m2s_scratch_ram_we      ),
    .wb_bte_i(wb_m2s_scratch_ram_bte     ),
    .wb_cti_i(wb_m2s_scratch_ram_cti     ),
    .wb_cyc_i(wb_m2s_scratch_ram_cyc     ),
    .wb_stb_i(wb_m2s_scratch_ram_stb     ),
    .wb_ack_o(wb_s2m_scratch_ram_ack     ),
    .wb_err_o(wb_s2m_scratch_ram_err     ),
    .wb_dat_o(wb_s2m_scratch_ram_dat     )
  );

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
    .clk     (usb_clk             ),
    .rst     (usb_rst             ),
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
    .USB3_MCUCLK       (usb_clk             ), // Input
    .USB_SUSPENDCLK    (usb_clk             ), // Input
    // *********************************************************************
    // Reset Signals
    // *********************************************************************
    .USB3_SYSRSTN      (usb_rst_n           ), // Input
    .USB_RESETN        (usb_rst_n           ), // Input
    .USB2_RESET        ((usb_rst)           ), // Input
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
    .LMMICLK           (usb_clk             ), // Input
    .LMMIRESETN        (usb_rst_n           ), // Input
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
    .XMAWADDR          (axi0_awaddr         ),
    .XMAWVALID         (axi0_awvalid        ),
    .XMAWSIZE          (axi0_awsize         ),
    .XMAWLEN           (axi0_awlen          ),
    .XMAWBURST         (axi0_awburst        ),
    .XMAWID            (axi0_awid           ),
    .XMAWLOCK          (axi0_awlock         ),
    .XMAWCACHE         (axi0_awcache        ),
    .XMAWPROT          (axi0_awprot         ),
    .XMAWMISC_INFO     (                    ),
    .XMAWREADY         (axi0_awready        ),
    // AXI Master Write Data Channel Signals
    .XMWDATA           (axi0_wdata          ),
    .XMWSTRB           (axi0_wstrb          ),
    .XMWVALID          (axi0_wvalid         ),
    .XMWLAST           (axi0_wlast          ),
    .XMWID             (axi0_wid            ),
    .XMWREADY          (axi0_wready         ),
    // AXI Master Read Data Channel Signals
    .XMBID             (axi0_bid            ),
    .XMBVALID          (axi0_bvalid         ),
    .XMBRESP           (axi0_bresp          ),
    .XMBREADY          (axi0_bready         ),
    .XMBMISC_INFO      (                    ),
    // AXI Master Read Address Channel Signals
    .XMARADDR          (axi0_araddr         ),
    .XMARVALID         (axi0_arvalid        ),
    .XMARLEN           (axi0_arlen          ),
    .XMARSIZE          (axi0_arsize         ),
    .XMARBURST         (axi0_arburst        ),
    .XMARID            (axi0_arid           ),
    .XMARLOCK          (axi0_arlock         ),
    .XMARCACHE         (axi0_arcache        ),
    .XMARPROT          (axi0_arprot         ),
    .XMARMISC_INFO     (                    ),
    .XMARREADY         (axi0_arready        ),
    // AXI Master Write Response Channel Signals
    .XMRID             (axi0_rid            ),
    .XMRVALID          (axi0_rvalid         ),
    .XMRLAST           (axi0_rlast          ),
    .XMRDATA           (axi0_rdata          ),
    .XMRMISC_INFO      (                    ),
    .XMRRESP           (axi0_rresp          ),
    .XMRREADY          (axi0_rready         ),
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

/*------------------------------------------------------------------------------
--  MIPI Rx
------------------------------------------------------------------------------*/
  wire           byte_clk_rx         ;
  wire           tx_rdy              ;
  wire [    5:0] ref_dt        = 'h2B;
  wire           pixel_fv            ;
  wire           pixel_lv            ;
  wire [    9:0] pixel_data          ;
  wire [   15:0] rx_wc               ;
  wire           hs_sync             ;
  wire           hs_d_en             ;
  wire           rx_lp_en            ;
  wire           rx_lp_av_en         ;
  wire [2*8-1:0] rx_payload          ;
  wire           rx_payload_en       ;
  wire [    5:0] rx_dt               ;

  mipi_to_pixel #(
    .NUM_RX_LANE(2         ),
    .RX_GEAR    (8         ),
    .DT_WIDTH   (PIXEL_BITS)
  ) i_mipi_to_pixel (
    .rx_clk_p     (mipi_rx_clk_p),
    .rx_clk_n     (mipi_rx_clk_m),
    .rx_d_p       (mipi_rx_dat_p),
    .rx_d_n       (mipi_rx_dat_m),
    .sync_clk     (sync_clk     ),
    .rst_n        (usb_rst_n    ),
    .pll_lock     (pll_lock     ),
    .byte_clk_i   (byte_clk     ),
    .byte_clk_o   (byte_clk_rx  ),
    .tx_rdy_i     (tx_rdy       ),
    .ref_dt       (ref_dt       ),
    .pixel_clk    (pixel_clk    ),
    .pixel_rst_n  (pixel_rst_n  ),
    .pixel_fv     (pixel_fv     ),
    .pixel_lv     (pixel_lv     ),
    .pixel_data   (pixel_data   ),
    .rx_wc        (rx_wc        ),
    .hs_sync      (hs_sync      ),
    .hs_d_en      (hs_d_en      ),
    .rx_lp_en     (rx_lp_en     ),
    .rx_lp_av_en  (rx_lp_av_en  ),
    .rx_payload   (rx_payload   ),
    .rx_payload_en(rx_payload_en),
    .rx_dt        (rx_dt        )
  );

  // Accumulate the RGB pixels for AWB
  wire [$clog2(NUM_COLS)-1:0] trim_left = 0       ;
  wire [$clog2(NUM_COLS)-1:0] width     = NUM_COLS;
  wire [$clog2(NUM_ROWS)-1:0] trim_top  = 0       ;
  wire [$clog2(NUM_ROWS)-1:0] height    = NUM_ROWS;

  logic avg_valid;
  image_stats #(
    .PIXEL_BITS    (PIXEL_BITS    ),
    .ACCUM_OUT_BITS(ACCUM_OUT_BITS),
    .MAX_ROWS      (NUM_ROWS      ),
    .MAX_COLS      (NUM_COLS      )
  ) i_als_top (
    .clk       (pixel_clk                     ),
    .reset     (~pixel_rst_n                  ),
    .trim_left (trim_left                     ),
    .width     (width                         ),
    .trim_top  (trim_top                      ),
    .height    (height                        ),
    .i_fv      (pixel_fv                      ),
    .i_lv      (pixel_lv                      ),
    .i_data    (pixel_data                    ),
    .avg_valid (avg_valid                     ),
    .num_cols  (num_cols                      ),
    .num_rows  (num_rows                      ),
    .num_frames(num_frames                    ),
    .ch0_avg   (avg_chan_0[ACCUM_OUT_BITS-1:0]),
    .ch1_avg   (avg_chan_1[ACCUM_OUT_BITS-1:0]),
    .ch2_avg   (avg_chan_2[ACCUM_OUT_BITS-1:0]),
    .ch3_avg   (avg_chan_3[ACCUM_OUT_BITS-1:0])
  );

  assign irq_frame = avg_valid;


`define SEL_DT_RAW10

  `ifdef SEL_DT_RAW10

    localparam          DT_SEL     = "DT_RAW10";
    localparam          DT_RAW10   = 6'h2B          ;
    localparam          DT_WIDTH   = 10             ;
    wire [        15:0] tx_byte_wc = (NUM_COLS*10)/8; // 1920*10/8
    wire [         5:0] tx_byte_dt = DT_RAW10       ;
    wire [DT_WIDTH-1:0] patt_data                   ;
    //wire [DT_WIDTH-1:0] tx_data    = patt_data      ;

  `else

    localparam          DT_SEL       = "DT_YUV_422_8";
    localparam          DT_YUV_422_8 = 6'h1E                  ;
    localparam          DT_WIDTH     = 16                     ;
    wire [        15:0] tx_byte_wc   = NUM_COLS*2             ; // YUV_8 has 16 bits per pixel
    wire [         5:0] tx_byte_dt   = DT_YUV_422_8           ;
    wire [DT_WIDTH-1:0] patt_data                             ;
    //wire [DT_WIDTH-1:0] tx_data      = {patt_data[9:2], 8'ha0};

  `endif

  // Pattern generator
  logic patt_fv, patt_lv;
  wire  tx_fv, tx_lv;
  wire  tx_init_done;

  colorbar_gen_alt #(
    .h_active     (NUM_COLS),
    .v_active     (NUM_ROWS),
    .V_FRONT_PORCH('d1     ),
    .V_SYNCH      ('d1     ),
    .V_BACK_PORCH ('d5     )
  ) i_colorbar_gen (
    .rstn(tx_init_done),
    .clk (pixel_clk   ),
    .data(patt_data   ),
    .fv  (patt_fv     ),
    .lv  (patt_lv     )
  );

/*
  // Pattern generator
  assign tx_fv = patt_fv;
  assign tx_lv = patt_lv;

*/
  // Passthrough:
  assign tx_fv = pixel_fv;
  assign tx_lv = pixel_lv;
  assign tx_data = pixel_data;
 
  // One shot to increase the FV length: this appears to be required to enable the Tx P2B block to work properly.
  logic tx_fv_ext;
  one_shot #(.PERIOD(100)) i_one_shot (
    .clk       (sync_clk   ),
    .rst       (~byte_rst_n),
    .start     (tx_fv      ),
    .pulse_o   (           ),
    .one_shot_o(tx_fv_ext  )
  );

  pixel_to_mipi #(.DT(DT_SEL), .DT_WIDTH(DT_WIDTH)) i_pixel_to_mipi (
    .rst_n        (byte_rst_n       ),
    .pixel_clk    (pixel_clk        ),
    .pixel_fv     (tx_fv | tx_fv_ext),
    .pixel_lv     (tx_lv            ),
    .pixel_data   (tx_data          ),
    .byte_clk_i   (byte_clk         ),
    .byte_clk_o   (                 ),
    .ref_clk      (sync_clk         ),
    .tx_pll_clk   (tx_clk           ),
    .tx_pll_clk_90(tx_clk_90        ),
    .pll_lock_i   (pll_lock         ),
    .pll_lock_o   (                 ),
    .tx_init_done (tx_init_done     ),
    .tx_rdy       (tx_rdy           ),
    .byte_dt      (tx_byte_dt       ),
    .byte_wc      (tx_byte_wc       ),
    .tx_clk_p     (mipi_tx_clk_p    ),
    .tx_clk_n     (mipi_tx_clk_m    ),
    .tx_d_p       (mipi_tx_dat_p    ),
    .tx_d_n       (mipi_tx_dat_m    )
  );

/*------------------------------------------------------------------------------
--  Other assignments
------------------------------------------------------------------------------*/
  //assign gpio_b1 = tx_fv;
  //assign gpio_g1 = tx_lv;

endmodule
`define nettype wire
