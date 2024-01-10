`default_nettype none
/*
 * Top level file for the FPGA LIFCL-40
 */

module int_osc_lifcl40 (
  input                 hf_out_en_i,
  output                hf_clk_out_o,
  output                lf_clk_out_o
);
  int_osc_ipgen_lscc_osc #(
    .HF_OSC_EN          ("ENABLED"),
    .HF_CLK_DIV_DEC     (10),
    .HF_CLK_DIV         ("9"),
    .HF_CFG_EN          ("ENABLED"),
    .LF_OUTPUT_EN       ("ENABLED"),
    .SEDCLK_EN          (0),
    .HF_SED_SEC_DIV_DEC (2),
    .HF_SED_SEC_DIV     ("1"),
    .LMMI_CLK_EN        ("DISABLED"),
    .FAMILY             ("LIFCL"),
    .DEVICE             ("LIFCL-40")
  ) lscc_osc_inst(
    .hf_out_en_i        (hf_out_en_i),
    .hf_switch_i        (1'b0),
    .sedc_clk_en_i      (1'b1),
    .sedc_rst_n_i       (1'b0),
    .lmmi_clk_i         (1'b0),
    .lmmi_resetn_i      (1'b0),
    .reboot_i           (1'b0),
    .hf_clk_out_o       (hf_clk_out_o),
    .lf_clk_out_o       (lf_clk_out_o)
    //.sedc_rst_o       (),
    //.cfg_clk_o        (),
    //.smclk_rst_o      (),
    //.lmmi_clk_o       (),
    //.lmmi_resetn_o    ()
  );
endmodule

module fpga_top_evn (

  // Pmod
  output wire           pmod1_1, pmod1_2, pmod1_3, pmod1_4,
  output wire           pmod1_7, pmod1_8, pmod1_9, pmod1_10,

  // LEDs
  output wire[12:0]     led_n,

  // Buttons
  input wire            button_rst_n, button_irq_n,

  // UART
  input  wire           uart_rxd,
  output wire           uart_txd,

  // I2C
  inout  wire           i2c_scl,
  inout  wire           i2c_sda,

  // SPI flash
  output wire           spiflash_clk,
  output wire           spiflash_cs_n,
  inout  wire[3:0]      spiflash_dq
);

  wire[31:0]            mainsoc_interrupt;
  wire                  reset_n;
  wire                  pending_status;
  wire                  enable_storage;

/*------------------------------------------------------------------------------
--  Internal oscillator
------------------------------------------------------------------------------*/
  // Local oscillator for startup
  logic hf_clk_45_MHz, lf_clk_32_kHz;
  int_osc_lifcl40 u_int_osc (
    .hf_out_en_i        ('1),
    .hf_clk_out_o       (hf_clk_45_MHz),
    .lf_clk_out_o       (lf_clk_32_kHz)
  );

  // Hold design in reset under external control
  fpga_reset u_fpga_reset (
    .clk                (lf_clk_32_kHz),
    .reset_n_i          (button_rst_n),
    .reset_n_o          (reset_n)
  );

/*------------------------------------------------------------------------------
--  LiteX design
------------------------------------------------------------------------------*/
  evn i_evn (
    .sys_clk            (hf_clk_45_MHz),
    .sys_rst            (~reset_n),

    .spiflash4x_clk     (spiflash_clk),
    .spiflash4x_cs_n    (spiflash_cs_n),
    .spiflash4x_dq      (spiflash_dq),

    .serial_rx          (uart_rxd),
    .serial_tx          (uart_txd),

    .i2c0_scl           (i2c_scl),
    .i2c0_sda           (i2c_sda),

    .usb230_irq         (~button_irq_n),

    //.wishbone0_we     (1'b0),
    //.wishbone0_stb    (1'b0),
    //.wishbone0_sel    (4'b0),
    .wishbone0_err      (1'b0),
    //.wishbone0_cyc    (1'b0),
    .wishbone0_dat_r    (32'b0),
    //.wishbone0_dat_w  (32'b0),
    //.wishbone0_cti    (4'b0),
    //.wishbone0_bte    (3'b0),
    .wishbone0_ack      (1'b0),
    //.wishbone0_adr    (32'b0),

    .axi0_wvalid        (1'b0),
    .axi0_wuser         (1'b0),
    .axi0_wstrb         (8'b0),
    //.axi0_wready      (1'b0),
    .axi0_wlast         (1'b0),
    .axi0_wdata         (64'b0),
    //.axi0_rvalid      (1'b0),
    //.axi0_ruser       (1'b0),
    //.axi0_rresp       (2'b0),
    .axi0_rready        (1'b0),
    //.axi0_rlast       (1'b0),
    //.axi0_rid         (8'b0),
    //.axi0_rdata       (64'b0),
    //.axi0_bvalid      (1'b0),
    //.axi0_buser       (1'b0),
    //.axi0_bresp       (2'b0),
    .axi0_bready        (1'b0),
    //.axi0_bid         (8'b0),
    .axi0_awvalid       (1'b0),
    .axi0_awuser        (1'b0),
    .axi0_awsize        (3'b0),
    .axi0_awregion      (4'b0),
    //.axi0_awready     (1'b0),
    .axi0_awqos         (4'b0),
    .axi0_awprot        (3'b0),
    .axi0_awlock        (2'b0),
    .axi0_awlen         (8'b0),
    .axi0_awid          (8'b0),
    .axi0_awcache       (4'b0),
    .axi0_awburst       (2'b0),
    //.axi0_arvalid     (1'b0),
    //.axi0_aruser      (1'b0),
    .axi0_arsize        (3'b0),
    .axi0_arregion      (4'b0),
    //.axi0_arready     (1'b0),
    .axi0_arqos         (4'b0),
    .axi0_arprot        (3'b0),
    .axi0_arlock        (2'b0),
    .axi0_arlen         (8'b0),
    //.axi0_arid        (8'b0),
    .axi0_arcache       (4'b0),
    .axi0_arburst       (2'b0)
  );

endmodule
