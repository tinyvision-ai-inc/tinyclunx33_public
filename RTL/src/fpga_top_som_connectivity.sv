/**
* @page fpga_top_som_no_mipi
* @brief Top level file for the FPGA
*/
`default_nettype wire

module fpga_top_som_connectivity (
  input  wire       sw2                 , // Reset button from devboard
  input  wire       clk_in              , // Clock from PLL, usually set to 60MHz as this is a common value
  input  wire       uart_rxd            ,
  output wire       uart_txd            ,
  inout  wire       scl                 ,
  inout  wire       sda                 ,
  output wire       spiflash_clk        ,
  output wire       spiflash_cs_n       ,
  inout  wire [3:0] spiflash_dq         ,
/*
  inout  wire       mipi_rx_clk_p       ,
  inout  wire       mipi_rx_clk_m       ,
  inout  wire [1:0] mipi_rx_dat_p       ,
  inout  wire [1:0] mipi_rx_dat_m       ,
  inout  wire       mipi_tx_clk_p       ,
  inout  wire       mipi_tx_clk_m       ,
  inout  wire [1:0] mipi_tx_dat_p       ,
  inout  wire [1:0] mipi_tx_dat_m       ,
*/
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
  fpga_reset u_fpga_reset (.clk(lf_clk), .reset_n_i(sw2), .reset_n_o(reset_n));
  assign reset = ~reset_n;

  // A PLL generates various frequencies for the design:
  wire pll_lock, clk_60m, clk_os2, pixel_clk, camera_mclk, tx_clk, tx_clk_90, byte_clk;
  main_pll_60 u_main_pll (
    .clki_i  (clk_in   ), // 60MHz
    .rstn_i  (reset_n  ),
    .clkop_o (         ),
    .clkos_o (pixel_clk), // 100 MHz
    .clkos2_o(clk_os2  ), // 80 MHz
    .clkos3_o(byte_clk ), // 50 MHz
    .clkos4_o(tx_clk   ), // 200 MHz
    .clkos5_o(tx_clk_90), // 200 MHz
    .lock_o  (pll_lock )
  );

  // No need to waste a PLL output when the clock is the right frequency. Do wer need to pass this through the
  // PLL to clean it up perhaps?
  assign clk_60m = clk_in;

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
rst_sync proc_rst_sync (.clk(proc_clk), .async_rst_n(sw2), .sync_rst_n(proc_rst_n));
assign proc_rst = ~proc_rst_n;

  wire usb_clk = clk_60m;
  logic usb_rst_n, usb_rst;
  rst_sync usb_rst_sync (.clk(usb_clk), .async_rst_n(sw2), .sync_rst_n(usb_rst_n));
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
--  LiteX design
------------------------------------------------------------------------------*/
  logic [31:0] wb_m2s_cpu_adr;
  logic [31:0] wb_m2s_cpu_dat;
  logic  [3:0] wb_m2s_cpu_sel;
  logic        wb_m2s_cpu_we;
  logic        wb_m2s_cpu_cyc;
  logic        wb_m2s_cpu_stb;
  logic  [2:0] wb_m2s_cpu_cti;
  logic  [1:0] wb_m2s_cpu_bte;
  logic [31:0] wb_s2m_cpu_dat;
  logic        wb_s2m_cpu_ack;
  logic        wb_s2m_cpu_err;
  logic        wb_s2m_cpu_rty;
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
    .wishbone0_bte  (wb_m2s_cpu_bte),
    .wishbone0_cti  (wb_m2s_cpu_cti),
    .wishbone0_cyc  (wb_m2s_cpu_cyc),
    .wishbone0_dat_w(wb_m2s_cpu_dat),
    .wishbone0_sel  (wb_m2s_cpu_sel),
    .wishbone0_stb  (wb_m2s_cpu_stb),
    .wishbone0_we   (wb_m2s_cpu_we ),
    .wishbone0_ack  (wb_s2m_cpu_ack),
    .wishbone0_dat_r(wb_s2m_cpu_dat),
    .wishbone0_err  (wb_s2m_cpu_err),
    .usb230_irq     (irq_usb23     ),
    .framectl0_irq  (irq_frame     )
  );
  

  // Wishbone is 32 bit aligned
  assign wb_m2s_cpu_adr = {wb_adr[29:0], 2'b0};

  /*------------------------------------------------------------------------------
    --  Register to improve timing
    ------------------------------------------------------------------------------*/
  wb_reg #(
    .DATA_WIDTH(32),
    .ADDR_WIDTH(32),
    .SELECT_WIDTH(4)
  ) i_wb_reg (
    .clk(wb_clk),
    .rst(wb_rst),
    // Slave:
    .wbm_cyc_i(wb_m2s_cpu_cyc),
    .wbm_stb_i(wb_m2s_cpu_stb),
    .wbm_adr_i(wb_m2s_cpu_adr),
    .wbm_dat_i(wb_m2s_cpu_dat),
    .wbm_sel_i(wb_m2s_cpu_sel),
    .wbm_we_i (wb_m2s_cpu_we),
    .wbm_dat_o(wb_s2m_cpu_dat),
    .wbm_ack_o(wb_s2m_cpu_ack),
    .wbm_err_o(wb_s2m_cpu_err),
    .wbm_rty_o(wb_s2m_cpu_rty),
    // Master:
    .wbs_cyc_o(wb_m2s_wb0_cyc),
    .wbs_stb_o(wb_m2s_wb0_stb),
    .wbs_adr_o(wb_m2s_wb0_adr),
    .wbs_dat_o(wb_m2s_wb0_dat),
    .wbs_we_o (wb_m2s_wb0_we),
    .wbs_sel_o(wb_m2s_wb0_sel),
    .wbs_dat_i(wb_s2m_wb0_dat),
    .wbs_ack_i(wb_s2m_wb0_ack),
    .wbs_err_i(wb_s2m_wb0_err),
    .wbs_rty_i(wb_s2m_wb0_rty)
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

  //------------------------------------------------------------------------------------------------------------
  // USB23 core
  //------------------------------------------------------------------------------------------------------------
  TinyClunx i_tinyclunx (
    .clk               (wb_clk              ),
    .reset             (wb_rst              ),
    .usb_irq           (irq_usb23           ),
    .usb23_VBUS        (VBUS_i              ),
    .usb23_REFINCLKEXTP(usb23_REFINCLKEXTP_i),
    .usb23_REFINCLKEXTM(usb23_REFINCLKEXTM_i),
    .usb23_RESEXTUSB2  (usb23_RESEXTUSB2    ),
    .usb23_DP          (usb23_DP           ),
    .usb23_DM          (usb23_DMP            ),
    .usb23_RXM         (usb23_RXMP_i        ),
    .usb23_RXP         (usb23_RXPP_i        ),
    .usb23_TXM         (usb23_TXMP_o        ),
    .usb23_TXP         (usb23_TXPP_o        ),
    .clk_60m           (clk_60m             ),
    .wb_CYC            (wb_m2s_usb_cyc      ),
    .wb_STB            (wb_m2s_usb_stb      ),
    .wb_SEL            (wb_m2s_usb_sel      ),
    .wb_WE             (wb_m2s_usb_we       ),
    .wb_ADR            (wb_m2s_usb_adr[27:0]),
    .wb_DAT_MOSI       (wb_m2s_usb_dat      ),
    .wb_ACK            (wb_s2m_usb_ack      ),
    .wb_DAT_MISO       (wb_s2m_usb_dat      )
  );
  assign wb_s2m_usb_err = 0;
  assign wb_s2m_usb_rty = 0;

endmodule
`define nettype wire
