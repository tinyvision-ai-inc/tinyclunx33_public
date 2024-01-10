// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
//   Copyright (c) 2017 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED
// -----------------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement.
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
// -----------------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
// -----------------------------------------------------------------------------
//
// =============================================================================
//                         FILE DETAILS
// Project               : DPHY
// File                  : lscc_dphy_tx_tb.v
// Title                 :
// Dependencies          : 1.
//                       : 2.
// Description           :
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0
// Author(s)             : 
// Mod. Date             : 01/08/2018
// Changes Made          : Initial release
// =============================================================================

`timescale 1ns/1ps

`include "lscc_dphy_tx_model.v"
`include "rx_model.v"

`ifndef TB_TOP
`define TB_TOP
module tb_top();

// -----------------------------------------------------------------------------
// Local Parameters
// -----------------------------------------------------------------------------
`include "dut_params.v"
/// Global
localparam NUM_FRAMES                  = 9;
localparam NUM_LINES                   = 9;
localparam NUM_BYTES                   = 40;
localparam NUM_BYTES_INCREMENT         = "ON";
localparam DATA_TYPE                   = 6'd30;
localparam VIRTUAL_CHANNEL             = 2'd0;
// localparam FREQ_CHANGE_TEST            = "OFF"; /// For test need to set HARD DPHY and enable LMMI also set INTERNAL PLL mode CIL_BYPASSED and TX_LINE_RATE_PER_LANE != 1000
// localparam EOTP_ENABLE                 = "ON"; Now this parameter comes from GUI
localparam DRIVING_EDGE                = "posedge";
localparam DEBUG_ON                    = "OFF";
localparam D_HS_RDY_TO_D_HS_CLK_EN_DLY = 10;
/// For CSI-2
localparam HS_RDY_TO_SP_EN_DLY         = 10;
localparam HS_RDY_TO_LP_EN_DLY         = 10;
localparam LP_EN_TO_BYTE_DATA_EN_DLY   = 0;
localparam HS_RDY_NEG_TO_HS_CLK_EN_DLY = 1;
localparam LS_LE_EN                    = LINE_CNT_ENABLE;
/// For DSI
localparam HS_RDY_TO_VSYNC_START_DLY   = 10;
localparam HS_RDY_TO_HSYNC_START_DLY   = 10;
localparam HS_RDY_TO_BYTE_DATA_EN_DLY  = 10;
localparam HSYNC_PULSE_FRONT           = 1;
localparam HSYNC_PULSE_BACK            = 1;
localparam HSYNC_TO_HSYNC_DLY          = 10;
localparam VSYNC_TO_HSYNC_DLY          = 10;
/// For without packet formatter DPHY
localparam HS_RDY_TO_DPHY_PKTEN_DLY    = 0;
/// Internal
localparam CRC_CHECK                   = PKT_FORMAT;
localparam CURRENT_TESTING             = "OFF";
localparam PLL_EXT_CHECK               = "OFF";
localparam TIMIN_PARAM_CHECK           = "OFF";
localparam DATA_WIDTH                  = GEAR*NUM_TX_LANE;
localparam L_DATA_WIDTH                = 8;                                           // LMMI data width
localparam L_OFFSET_WIDTH              = 8;                                           // LMMI offset width
localparam AXI_DATA_WIDTH              = (PKT_FORMAT == "ON")? (GEAR*NUM_TX_LANE)+24:
                                                               (GEAR*NUM_TX_LANE);
///
// -----------------------------------------------------------------------------
// Generate Variables
// -----------------------------------------------------------------------------
real    BYTE_CLK_PER   = 1000 / BYTE_CLK_FREQ;
real    REF_CLK_PERIOD = (1000.0-0.1)/REF_CLOCK_FREQ; //[JAS] added -0.1
real    PLL_CLK_PERIOD = (DPHY_IP == "MIXEL")? 1000.0/(TX_LINE_RATE_PER_LANE*2) : 1000.0/(TX_LINE_RATE_PER_LANE);
integer a;
integer b;

// -----------------------------------------------------------------------------
// Wire Declarations
// -----------------------------------------------------------------------------
wire                      lmmi_clk_i;
wire                      lmmi_resetn_i;
wire [L_DATA_WIDTH-1:0]   lmmi_wdata_i;
wire                      lmmi_wr_rdn_i;
wire [L_OFFSET_WIDTH-1:0] lmmi_offset_i;
wire                      lmmi_request_i;
wire                      lmmi_ready_o;
wire [L_DATA_WIDTH-1:0]   lmmi_rdata_o;
wire                      lmmi_rdata_valid_o;
wire                      axis_aclk_i;
wire                      axis_aresetn_i;
wire                      axis_tvalid_i;
wire [AXI_DATA_WIDTH-1:0] axis_tdata_i;
wire                      axis_tready_o;
wire                      ref_clk_i;
wire                      reset_n_i;
wire                      clk_hs_en_i;
wire                      d_hs_en_i;
wire                      d_hs_rdy_o;
wire                      c2d_ready_o;
wire                      pd_dphy_i;
wire                      byte_clk_o;
wire [DATA_WIDTH-1:0]     byte_or_pkt_data_i;
wire [DATA_WIDTH-1:0]     byte_or_pkt_data_w;
wire                      byte_or_pkt_data_en_i;
wire                      usrstdby_i;
wire                      pll_lock_o;
wire [ 1:0]               vcx_i;
wire [ 1:0]               vc_i;
wire [ 5:0]               dt_i;
wire [15:0]               wc_i;
wire                      sp_en_i;
wire                      lp_en_i;
wire                      phdr_xfr_done_o;
wire                      ld_pyld_o;
wire                      pkt_format_ready_o;
wire                      pix2byte_rstn_o;
wire                      eotp_i;
wire                      vsync_start_i;
wire                      hsync_start_i;
wire                      tinit_done_o;
wire                      clk_p_io;
wire                      clk_n_io;
wire                      lp_rx_data_p_o;
wire                      lp_rx_data_n_o;
wire [NUM_TX_LANE-1:0]    d_p_io;
wire [NUM_TX_LANE-1:0]    d_n_io;
wire                      ready_o;
wire [NUM_TX_LANE-1:0]    cil_hs_tx_ready_o;
wire [NUM_TX_LANE-1:0]    cil_data_lane_ss_o;
wire [3:0]                tx_cil_word_valid_lane0_i;
wire [3:0]                tx_cil_word_valid_lane1_i;
wire [3:0]                tx_cil_word_valid_lane2_i;
wire [3:0]                tx_cil_word_valid_lane3_i;
wire [NUM_TX_LANE-1:0]    line_disable_i;
wire                      hs_clk_cil_ready_o;
wire                      tx_model_usrstdby_w;

// -----------------------------------------------------------------------------
// Sequential Registers
// -----------------------------------------------------------------------------
reg                      lmmi_clk_r;
reg                      lmmi_resetn_r;
reg [L_DATA_WIDTH-1:0]   lmmi_wdata_r;
reg                      lmmi_wr_rdn_r;
reg [L_OFFSET_WIDTH-1:0] lmmi_offset_r;
reg                      lmmi_request_r;
reg                      axis_mclk_r;
reg                      axis_mresetn_r;
reg                      ref_clk_r;
reg                      ref_clk_100MHz;
reg                      reset_n_r;
reg                      pd_dphy_r;
reg                      usrstdby_r;
reg                      pll_clkop_i;
reg                      pll_clkos_i;
reg                      pll_lock_i;
reg [3:0]                lmmi_data_r;
reg                      lp_rx_en_i;
reg [15:0]               count = 16'd0;
reg                      EoT   = 0;
reg                      sim_failed = 0;
reg                      test_100MHZ_clk_on = 0;

// -----------------------------------------------------------------------------
// Assign Statement
// -----------------------------------------------------------------------------
assign ref_clk_i      = (test_100MHZ_clk_on)? ref_clk_100MHz : ref_clk_r;
assign reset_n_i      = reset_n_r;
assign pd_dphy_i      = pd_dphy_r;
assign usrstdby_i     = usrstdby_r | tx_model_usrstdby_w;
assign lmmi_clk_i     = lmmi_clk_r;
assign lmmi_resetn_i  = lmmi_resetn_r;
assign axis_aclk_i    = (AXI4 == "OFF")? 0 : axis_mclk_r;
assign axis_aresetn_i = (AXI4 == "OFF")? 0 : axis_mresetn_r;
assign axis_tvalid_i  = (AXI4 == "OFF")? 0 : byte_or_pkt_data_en_i;
assign axis_tdata_i   = (AXI4 == "OFF")? 0 :
//                       (PKT_FORMAT == "ON")? {vc_i,dt_i,wc_i,byte_or_pkt_data_w} :
                         (PKT_FORMAT == "ON")? {wc_i,dt_i,vc_i,byte_or_pkt_data_w} :
                                                byte_or_pkt_data_w;

if (GEAR == 8 || NUM_TX_LANE == 1 || (DAT_INTLVD =="ON")) begin
    assign byte_or_pkt_data_i = byte_or_pkt_data_w;
end
//......gear16 and data bytes are in ordinal arrangement......//
else if (NUM_TX_LANE == 2) begin
    assign byte_or_pkt_data_i = {byte_or_pkt_data_w[31:24],byte_or_pkt_data_w[15:8],byte_or_pkt_data_w[23:16],byte_or_pkt_data_w[7:0]};
end
else if (NUM_TX_LANE == 3) begin
    assign byte_or_pkt_data_i = {byte_or_pkt_data_w[47:40], byte_or_pkt_data_w[31:24], byte_or_pkt_data_w[15:8],
                                 byte_or_pkt_data_w[39:32], byte_or_pkt_data_w[23:16], byte_or_pkt_data_w[ 7:0]};
end
else begin
    assign byte_or_pkt_data_i = {byte_or_pkt_data_w[63:56], byte_or_pkt_data_w[47:40], byte_or_pkt_data_w[31:24], byte_or_pkt_data_w[15:8],
                                 byte_or_pkt_data_w[55:48], byte_or_pkt_data_w[39:32], byte_or_pkt_data_w[23:16], byte_or_pkt_data_w[ 7:0]};
end

// -----------------------------------------------------------------------------
// Sequential Blocks
// -----------------------------------------------------------------------------
always begin : REF_CLK_GEN
  #(REF_CLK_PERIOD/2) ref_clk_r <= ~ref_clk_r;
end

always begin : REF_CLK_100MHz_GEN
  #(10/2) ref_clk_100MHz <= ~ref_clk_100MHz;
end

always begin
  #(BYTE_CLK_PER/2)lmmi_clk_r <= ~lmmi_clk_r;
end

generate
  if (PLL_MODE == "EXTERNAL") begin : EXTERNAL_PLL_IMPL
    initial begin
      fork
        begin
          pll_lock_i = 1'd0;
          #(10000);
          pll_lock_i = 1'd1;
        end
        begin
          fork
            begin
              forever begin
                pll_clkop_i = 1'd1;
                #(PLL_CLK_PERIOD);
                pll_clkop_i = 1'd0;
                #(PLL_CLK_PERIOD);
              end
            end
            begin
              #(PLL_CLK_PERIOD/2);
              forever begin
                pll_clkos_i = 1'd1;
                #(PLL_CLK_PERIOD);
                pll_clkos_i = 1'd0;
                #(PLL_CLK_PERIOD);
              end
            end
          join
        end
      join
    end
  end
endgenerate

generate
  if (AXI4 == "ON") begin : AXI_CLK
    always begin : AXI_CLK_GEN
      #((PLL_CLK_PERIOD*GEAR/2)/2) axis_mclk_r <= ~axis_mclk_r;
    end
  end
endgenerate

/// [In process] 
generate
  if (PLL_MODE == "INTERNAL" & PLL_EXT_CHECK == "ON") begin
    reg pll_timeout    = 1'd0;
    reg pll_lock_error = 1'd0;
    reg pll_work       = 1'd0;

    initial begin : PLL_CHECKING
      fork
        begin
          @(posedge ready_o);   /// Wait for PLL lock
          @(posedge byte_clk_o);
          @(posedge byte_clk_o);
          @(posedge byte_clk_o);
          pll_work    = 1'd1;
        end
        begin
          @(posedge ready_o);   /// Wait for PLL lock
          #(6*BYTE_CLK_PER);
          pll_lock_error = 1'd1;
        end
        begin
          #(200000);
          pll_timeout = 1'd1;
        end
        begin
          @(posedge pll_work or posedge pll_lock_error or posedge pll_timeout);
          if (pll_work) begin
            $display("PLL work normal");
          end
          else if (pll_lock_error) begin
            $display("PLL lock work abnormal");
            $display (" ERROR☻ : PLL won't work!");
            $stop;
          end
          else if (pll_timeout) begin
            $display("PLL timeout");
            $display (" ERROR☻ : PLL won't work!");
            $stop;
          end
        end
      join
    end
  end
endgenerate

///

initial begin : INITIAL_ASSSIGNING
  lmmi_clk_r            = 1'd0;
  lmmi_resetn_r         = 1'd0;
  lmmi_wdata_r          =  'd0;
  lmmi_wr_rdn_r         = 1'd0;
  lmmi_offset_r         =  'd0;
  lmmi_request_r        =  'd0;
  lmmi_data_r           = 4'd0;
  axis_mclk_r           = 1'd0;
  axis_mresetn_r        = 1'd0;
  ref_clk_r             = 1'd0;
  ref_clk_100MHz        = 1'd0;
  reset_n_r             = 1'd0;
  pd_dphy_r             = 1'd1;
  usrstdby_r            = 1'd1;
  lp_rx_en_i            = 1'd0;
end

initial begin : INITIAL_SIM
  $timeformat(-12,0,"",10);
  $display("%0t TEST START\n",$realtime);
  #10000;
  lmmi_resetn_r  = 1;
  axis_mresetn_r = 1;
  reset_n_r      = 1;
  usrstdby_r     = 0;
  pd_dphy_r      = 0;
  $display("%0t Wait for ready_o signal \n",$realtime);
  @(posedge ready_o);
  if (TINIT_COUNT == "ON" & tinit_done_o == 1'd0) begin
    $display("%0t Wait for tinit_done_o signal \n",$realtime);
    @(posedge tinit_done_o);
    $display("%0t TINIT DONE !",$realtime);
  end
  #10;
  u_lscc_dphy_tx_model.drive_video_data;
  #100;
  $display("%0t TEST END\n",$realtime);
  #10000;
  if (FREQ_CHANGE_TEST == "ON" && LMMI == "ON" && DPHY_IP == "MIXEL" && PLL_MODE == "INTERNAL") begin
    $display("%0t ADDITIONAL TEST START\n",$realtime);
    test_100MHZ_clk_on = 1;
    u_lscc_dphy_tx_model.change_PLL_freq;
    @(posedge ready_o);   /// Wait for PLL lock
    u_lscc_dphy_tx_model.drive_video_data;
    $display("%0t ADDITIONAL TEST END\n",$realtime);
  end

  EoT                      = 1;
  u_rx_model.eotb          = 1;
  u_lscc_dphy_tx_model.EoT = 1;
  data_check_t;
end

// -----------------------------------------------------------------------------
// Submodule Instantiations
// -----------------------------------------------------------------------------
lscc_dphy_tx_model # (
  .NUM_FRAMES                 (NUM_FRAMES),
  .NUM_LINES                  (NUM_LINES),
  .NUM_BYTES                  (NUM_BYTES),
  .NUM_BYTES_INCREMENT        (NUM_BYTES_INCREMENT),
  .DATA_TYPE                  (DATA_TYPE),
  .VIRTUAL_CHANNEL            (VIRTUAL_CHANNEL),
  .EOTP_ENABLE                (EOTP_ENABLE),
  .NUM_TX_LANE                (NUM_TX_LANE),
  .GEAR                       (GEAR),
  .DRIVING_EDGE               (DRIVING_EDGE),
  .DEVICE_TYPE                (TX_INTF),
  .PACKET_FORMATTER           (PKT_FORMAT),
  .D_HS_RDY_TO_D_HS_CLK_EN_DLY(D_HS_RDY_TO_D_HS_CLK_EN_DLY),
  .TX_LINE_RATE_PER_LANE      (TX_LINE_RATE_PER_LANE),
  .HS_RDY_TO_SP_EN_DLY        (HS_RDY_TO_SP_EN_DLY),
  .HS_RDY_TO_LP_EN_DLY        (HS_RDY_TO_LP_EN_DLY),
  .LP_EN_TO_BYTE_DATA_EN_DLY  (LP_EN_TO_BYTE_DATA_EN_DLY),
  .HS_RDY_NEG_TO_HS_CLK_EN_DLY(HS_RDY_NEG_TO_HS_CLK_EN_DLY),
  .LS_LE_EN                   (LS_LE_EN),
  .GEN_FR_NUM                 (FRAME_CNT_ENABLE),
  .GEN_LN_NUM                 (LINE_CNT_ENABLE),
  .HS_RDY_TO_VSYNC_START_DLY  (HS_RDY_TO_VSYNC_START_DLY),
  .HS_RDY_TO_HSYNC_START_DLY  (HS_RDY_TO_HSYNC_START_DLY),
  .HS_RDY_TO_BYTE_DATA_EN_DLY (HS_RDY_TO_BYTE_DATA_EN_DLY),
  .HSYNC_PULSE_FRONT          (HSYNC_PULSE_FRONT),
  .HSYNC_PULSE_BACK           (HSYNC_PULSE_BACK),
  .HSYNC_TO_HSYNC_DLY         (HSYNC_TO_HSYNC_DLY),
  .VSYNC_TO_HSYNC_DLY         (VSYNC_TO_HSYNC_DLY),
  .HS_RDY_TO_DPHY_PKTEN_DLY   (HS_RDY_TO_DPHY_PKTEN_DLY),
  .DEBUG_ON                   (DEBUG_ON),
  .CIL_BYPASS                 (CIL_BYPASS),
  .LMMI                       (LMMI),
  .LMMI_DATA_WIDTH            (L_DATA_WIDTH),
  .LMMI_OFFSET_WIDTH          (L_OFFSET_WIDTH)
)
u_lscc_dphy_tx_model
(
  .reset_i                    (reset_n_r),
  .ref_clk_i                  (byte_clk_o),
  .d_hs_rdy_i                 (d_hs_rdy_o),
  .c2d_ready_i                (c2d_ready_o),
  .hs_tx_cil_ready_i          (cil_hs_tx_ready_o),
  .ld_pyld_i                  (ld_pyld_o),
  .usrstdby_o                 (tx_model_usrstdby_w),
  .clk_hs_en_o                (clk_hs_en_i),
  .d_hs_en_o                  (d_hs_en_i),
  .byte_or_pkt_data_o         (byte_or_pkt_data_w),
  .byte_or_pkt_data_en_o      (byte_or_pkt_data_en_i),
  .vcx_o                      (vcx_i),
  .vc_o                       (vc_i),
  .dt_o                       (dt_i),
  .wc_o                       (wc_i),
  .eotp_o                     (eotp_i),
  .sp_en_o                    (sp_en_i),
  .lp_en_o                    (lp_en_i),
  .vsync_start_o              (vsync_start_i),
  .hsync_start_o              (hsync_start_i),
  .tx_cil_word_valid_lane0_o      (tx_cil_word_valid_lane0_i),
  .tx_cil_word_valid_lane1_o      (tx_cil_word_valid_lane1_i),
  .tx_cil_word_valid_lane2_o      (tx_cil_word_valid_lane2_i),
  .tx_cil_word_valid_lane3_o      (tx_cil_word_valid_lane3_i),
  .line_disable_o                 (line_disable_i),
  .hs_clk_cil_ready_i             (hs_clk_cil_ready_o),
  .lmmi_clk_i                 (lmmi_clk_i),
  .lmmi_offset_o              (lmmi_offset_i),
  .lmmi_wdata_o               (lmmi_wdata_i),
  .lmmi_wr_rdn_o              (lmmi_wr_rdn_i),
  .lmmi_request_o             (lmmi_request_i),
  .lmmi_rdata_i               (lmmi_rdata_o)

);

reg                   clk_p_io_test; /// Without glitches
reg                   clk_n_io_test; /// Without glitches
reg [NUM_TX_LANE-1:0] d_p_io_test;   /// Without glitches
reg [NUM_TX_LANE-1:0] d_n_io_test;   /// Without glitches

always begin
  #(0.1);
  clk_p_io_test = clk_p_io;
  clk_n_io_test = clk_n_io;
  d_p_io_test   = d_p_io;  
  d_n_io_test   = d_n_io;  
end


rx_model # (
  .NUM_LANE     (NUM_TX_LANE),
  .CLK_MODE     ((CLK_MODE == "HS_ONLY")? "CONTINUOUS" : "NON_CONTINUOUS"),
  .HEADER_CHECK ("OFF"), /// :) change
  .EOTP_CHECK   ((TX_INTF == "DSI" & EOTP_ENABLE == "ON")? "ON" : "OFF"),
  .CRC_CHECK    (CRC_CHECK),
  .INTF_TYPE    (TX_INTF),
  .FRAME_CNT_EN (FRAME_CNT_ENABLE),
  .NUM_FRAMES   (FRAME_CNT_VAL),
  .GEAR         (GEAR),
  .DPHY_IP      (DPHY_IP),
  .CIL_BYPASS   (CIL_BYPASS)
)
u_rx_model (
  .reset_i      (ready_o),
  .c_p_i        ((DPHY_IP == "MIXEL")? clk_p_io : clk_p_io_test),
  .c_n_i        ((DPHY_IP == "MIXEL")? clk_n_io : clk_n_io_test),
  .d_p_i        ((DPHY_IP == "MIXEL")? d_p_io   : d_p_io_test  ),
  .d_n_i        ((DPHY_IP == "MIXEL")? d_n_io   : d_n_io_test  )
);

////////////////////////////////////////////
reg CLK_GSR = 0;
reg USER_GSR = 1;

wire GSROUT;

initial begin
    forever begin
        #5;
        CLK_GSR = ~CLK_GSR;
    end
end

GSR GSR_INST (
    .GSR_N(USER_GSR),
    .CLK(CLK_GSR)
);
////////////////////////////////////////////

`include "dut_inst.v"

// -----------------------------------------------------------------------------
// Tasks Declarations
// -----------------------------------------------------------------------------
task lmmi_read_t(
  input  [L_OFFSET_WIDTH-1:0] offset,
  output [  L_DATA_WIDTH-1:0] data
  );
  begin
    lmmi_offset_r  <= {1'd1,offset};
    lmmi_wr_rdn_r  <= 1'd0;
    lmmi_request_r <= 1'd1;
    @(posedge lmmi_clk_i);
    lmmi_wr_rdn_r  <= 1'd0;
    lmmi_request_r <= 1'd0;
    data           <= lmmi_rdata_o;
  end
endtask

task data_check_t();// Task which compare two text files
  reg [31:0] D_true_res;
  reg [31:0] D_false_res;
  reg [31:0] D_file_1_value;
  reg [31:0] D_file_2_value;
  reg [31:0] D_file_1;
  reg [31:0] D_file_2;
  begin
    D_true_res       = 32'd0;
    D_false_res      = 32'd0;
    D_file_1_value   = 32'd0;
    D_file_2_value   = 32'd0;
    D_file_1         = $fopen("tx_model_data.txt","r");
    D_file_2         = $fopen("rx_model_data.txt","r");
    #1;
    // $display("Start of data comparing");
    while ((!$feof(D_file_1) | !$feof(D_file_2))) begin
      #1;
      $fscanf(D_file_1,"%h\n",D_file_1_value);
      $fscanf(D_file_2,"%h\n",D_file_2_value);
      #1;
      if (D_file_1_value == D_file_2_value) begin
        D_true_res   = D_true_res + 1;
      end
      else begin
        D_false_res  = D_false_res + 1;
        // $display("Time : %0t ps Error %h from test not equal to %h from DUT",$realtime,D_file_1_value,D_file_2_value);
      end
    end
    $fclose(D_file_1);
    $fclose(D_file_2);
    // $display("End of data comparing");

    if (u_rx_model.global_EOT_bit_failed_cases == 0 && u_rx_model.global_EOT_bit_passed_cases != 0) begin
      $display("   ***EOT PACKET CHECK PASS***   ");
    end
    else begin
      $display("   ***EOT PACKET CHECK FAIL***   ");
      $display("Errors` ",u_rx_model.global_EOT_bit_failed_cases,"/",u_rx_model.global_EOT_bit_failed_cases + u_rx_model.global_EOT_bit_passed_cases);
        sim_failed = 1'd1;
    end

    if (TX_INTF == "DSI" && EOTP_ENABLE == "ON" && PKT_FORMAT == "ON") begin
      ///////////////////////////////////////////////////
      /// EOTp Parameters Check after LP(if available)
      ///////////////////////////////////////////////////
      if (u_rx_model.global_EoTp_LP_failed_cases == 0 && u_rx_model.global_EoTp_LP_passed_cases != 0) begin
        $display("   ***EoTp PACKET CHECK AFTER LP PASS***   ");
      end
      else begin
        $display("   ***EoTp PACKET CHECK AFTER LP FAIL***   ");
        $display("Errors` ",u_rx_model.global_EoTp_LP_failed_cases,"/",u_rx_model.global_EoTp_LP_failed_cases + u_rx_model.global_EoTp_LP_passed_cases);
        sim_failed = 1'd1;
      end
  
      ///////////////////////////////////////////////////
      /// EOTp Parameters Check after SP(if available)
      ///////////////////////////////////////////////////
      if (u_rx_model.global_EoTp_SP_failed_cases == 0 && u_rx_model.global_EoTp_SP_passed_cases != 0) begin
        $display("   ***EoTp PACKET CHECK AFTER SP PASS***   ");
      end
      else begin
        $display("   ***EoTp PACKET CHECK AFTER SP FAIL***   ");
        $display("Errors` ",u_rx_model.global_EoTp_SP_failed_cases,"/",u_rx_model.global_EoTp_SP_failed_cases + u_rx_model.global_EoTp_SP_passed_cases);
        sim_failed = 1'd1;
      end
    end

    ///////////////////////////////////////////////////
    /// Timing Parameters Check
    ///////////////////////////////////////////////////
    if (TIMIN_PARAM_CHECK == "ON") begin
      if (u_rx_model.global_failed_cases == 0 && u_rx_model.global_passed_cases != 0) begin
        $display("   ***TIMING PARAMETERS PASS***   ");
      end
      else begin
        $display("   ***TIMING PARAMETERS FAIL***   ");
        $display("Errors` ",u_rx_model.global_failed_cases,"/",u_rx_model.global_failed_cases + u_rx_model.global_passed_cases);
        sim_failed = 1'd1;
      end
    end

    ///////////////////////////////////////////////////
    /// Frame number Check
    ///////////////////////////////////////////////////
    if (FRAME_CNT_ENABLE == "ON") begin
      if (u_rx_model.global_FRAME_NUMBER_failed_cases == 0 && u_rx_model.global_FRAME_NUMBER_passed_cases != 0) begin
        $display("   ***FRAME NUMPER INCREMENT PASS***   ");
      end
      else begin
        $display("   ***FRAME NUMPER INCREMENT FAIL***   ");
        $display("Errors` ",u_rx_model.global_FRAME_NUMBER_failed_cases,"/",u_rx_model.global_FRAME_NUMBER_failed_cases + u_rx_model.global_FRAME_NUMBER_passed_cases);
        sim_failed = 1'd1;
      end
    end
    
    ///////////////////////////////////////////////////
    /// Payload Data Check
    ///////////////////////////////////////////////////
    if (D_false_res == 0 && D_true_res != 0) begin
      $display("   ***PAYLOAD DATA PASS***   ");
    end
    else begin
      $display("   ***PAYLOAD DATA FAIL***   ");
      $display("Errors` ",D_false_res,"/",D_false_res + D_true_res);
        sim_failed = 1'd1;
    end
    
    ///////////////////////////////////////////////////
    /// CRC Check
    ///////////////////////////////////////////////////
    if (CRC_CHECK == "ON") begin
      if (u_rx_model.global_CRC_failed_cases == 0 && u_rx_model.global_CRC_passed_cases !=0) begin
        $display("   ***CRC PASS***   ");
      end
      else begin
        $display("   ***CRC FAIL***   ");
        $display("Errors` ",u_rx_model.global_CRC_failed_cases,"/",u_rx_model.global_CRC_failed_cases + u_rx_model.global_CRC_passed_cases);
        sim_failed = 1'd1;
      end
    end
    ///////////////////////////////////////////////////
    /// DSI lp_rx
    ///////////////////////////////////////////////////
    if (TX_INTF == "DSI" & CIL_BYPASS == "CIL_BYPASSED") begin
      lp_rx_test;
      if (lp_rx_test.error != 0) begin
        $display("   ***LP_RX FAIL***   ");
        sim_failed = 1'd1;
      end
      else begin
        $display("   ***LP_RX PASS***   ");
      end
    end
    /// test
      if(sim_failed) begin
        $display("***SIMULATION FAILED***");
      end
      else begin
        $display("***SIMULATION PASSED***");
      end
    /// 
    $stop;
  end
endtask

task lp_rx_test();
  reg error;
  begin
    // $display("Additional test start Low Power RX");
    lp_rx_en_i = 1;
    #1000;
    fork
      begin
        repeat (1000) begin /// check
          error = (lp_rx_data_p_o != d_p_io[0] && lp_rx_data_n_o != d_n_io[0]);
          #5;
        end
      end
      begin
        repeat (100) begin /// Drive
          force d_p_io[0] = $random;
          force d_n_io[0] = $random;
          #50;
        end
      end
    join
    lp_rx_en_i = 0;
    release d_p_io[0];
    release d_n_io[0];
    #1000;
    // $display("Additional test end Low Power RX");
  end
endtask

endmodule
//==============================================================================
// lscc_dphy_tx_core.v
//==============================================================================
`endif
