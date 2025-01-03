`default_nettype wire
module wb_intercon
   (input  wire        wb_clk_i,
    input  wire        wb_rst_i,
    input  wire [31:0] wb_wb0_adr_i,
    input  wire [31:0] wb_wb0_dat_i,
    input  wire  [3:0] wb_wb0_sel_i,
    input  wire        wb_wb0_we_i,
    input  wire        wb_wb0_cyc_i,
    input  wire        wb_wb0_stb_i,
    input  wire  [2:0] wb_wb0_cti_i,
    input  wire  [1:0] wb_wb0_bte_i,
    output wire [31:0] wb_wb0_dat_o,
    output wire        wb_wb0_ack_o,
    output wire        wb_wb0_err_o,
    output wire        wb_wb0_rty_o,
    output wire [31:0] wb_usb_adr_o,
    output wire [31:0] wb_usb_dat_o,
    output wire  [3:0] wb_usb_sel_o,
    output wire        wb_usb_we_o,
    output wire        wb_usb_cyc_o,
    output wire        wb_usb_stb_o,
    output wire  [2:0] wb_usb_cti_o,
    output wire  [1:0] wb_usb_bte_o,
    input  wire [31:0] wb_usb_dat_i,
    input  wire        wb_usb_ack_i,
    input  wire        wb_usb_err_i,
    input  wire        wb_usb_rty_i,
    output wire [31:0] wb_scratch_ram_adr_o,
    output wire [31:0] wb_scratch_ram_dat_o,
    output wire  [3:0] wb_scratch_ram_sel_o,
    output wire        wb_scratch_ram_we_o,
    output wire        wb_scratch_ram_cyc_o,
    output wire        wb_scratch_ram_stb_o,
    output wire  [2:0] wb_scratch_ram_cti_o,
    output wire  [1:0] wb_scratch_ram_bte_o,
    input  wire [31:0] wb_scratch_ram_dat_i,
    input  wire        wb_scratch_ram_ack_i,
    input  wire        wb_scratch_ram_err_i,
    input  wire        wb_scratch_ram_rty_i);

wb_mux
  #(.num_slaves (2),
    .MATCH_ADDR ({32'hb0000000, 32'hb1000000}),
    .MATCH_MASK ({32'hff000000, 32'hff000000}))
 wb_mux_wb0
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i (wb_wb0_adr_i),
    .wbm_dat_i (wb_wb0_dat_i),
    .wbm_sel_i (wb_wb0_sel_i),
    .wbm_we_i  (wb_wb0_we_i),
    .wbm_cyc_i (wb_wb0_cyc_i),
    .wbm_stb_i (wb_wb0_stb_i),
    .wbm_cti_i (wb_wb0_cti_i),
    .wbm_bte_i (wb_wb0_bte_i),
    .wbm_dat_o (wb_wb0_dat_o),
    .wbm_ack_o (wb_wb0_ack_o),
    .wbm_err_o (wb_wb0_err_o),
    .wbm_rty_o (wb_wb0_rty_o),
    .wbs_adr_o ({wb_usb_adr_o, wb_scratch_ram_adr_o}),
    .wbs_dat_o ({wb_usb_dat_o, wb_scratch_ram_dat_o}),
    .wbs_sel_o ({wb_usb_sel_o, wb_scratch_ram_sel_o}),
    .wbs_we_o  ({wb_usb_we_o, wb_scratch_ram_we_o}),
    .wbs_cyc_o ({wb_usb_cyc_o, wb_scratch_ram_cyc_o}),
    .wbs_stb_o ({wb_usb_stb_o, wb_scratch_ram_stb_o}),
    .wbs_cti_o ({wb_usb_cti_o, wb_scratch_ram_cti_o}),
    .wbs_bte_o ({wb_usb_bte_o, wb_scratch_ram_bte_o}),
    .wbs_dat_i ({wb_usb_dat_i, wb_scratch_ram_dat_i}),
    .wbs_ack_i ({wb_usb_ack_i, wb_scratch_ram_ack_i}),
    .wbs_err_i ({wb_usb_err_i, wb_scratch_ram_err_i}),
    .wbs_rty_i ({wb_usb_rty_i, wb_scratch_ram_rty_i}));

endmodule
