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
// Project               :
// File                  : tb_top.v
// Title                 : Test bench for dphy_rx
// Dependencies          : 1.
//                       : 2.
// Description           :
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0
// Author(s)             : none
// Mod. Date             : none
// Changes Made          : Maybe initial version.
// =============================================================================
// Version               : 1.1
// Author(s)             : Davit Tamazyan(IMT)
// Mod. Date             : 06/08/18
// Changes Made          : Deleting "define statement". Checking coding style.
// =============================================================================

`timescale 1 ps / 1 ps

`include "bus_driver.v"
`include "clk_driver.v"
`include "csi2_model.v"
`include "dsi_model.v"

`ifndef tb_top
`define tb_top
module tb_top();
// -----------------------------------------------------------------------------
// Local Parameters
// -----------------------------------------------------------------------------
// Parameters from GUI
`include "dut_params.v"
// Internal parameters for TB
localparam integer DPHY_CLK                  = 2000000/(BYTECLK_MHZ*RX_GEAR);//in ps, clock period of DPHY.
localparam         CLK_PER                   = ((1000/(BYTECLK_MHZ*RX_GEAR)) * 1000);
/// CSI-2
localparam [31:0]  HEADERSP1                 = 32'h1A000100;
localparam [31:0]  HEADERLP1                 = 32'h250BB824;
localparam [31:0]  HEADERSP2                 = 32'h1D000101;
/// DSI
localparam [31:0]  VSYNCSTART_COMM           = 32'h00000001;                                                   // *** Add ECC 
localparam [31:0]  HSYNCSTART_COMM           = 32'h00000021;                                                   // *** Add ECC 
localparam [31:0]  RGB666_COMM               = 32'h250BB83E; /// Packed Pixel Stream, 24-bit RGB, 8-8-8 Format // *** Add ECC 
// Parameters that can be modified by user
localparam         DATA_TYPE                 = "RGB888";// For CSI2 "RGB666_LOOSE","RGB666","RGB888". For DSI "RAW8","RAW10","RAW12","YUV420_10","YUV420_8","YUV422_10","YUV422_8","LEGACY_YUV420_8","YUV420_10_CSPS","YUV420_8_CSPS","RGB888".
localparam         num_frames                = 1; // number of frames
localparam         num_lines                 = 4; //number of video lines
localparam         t_lpx                     = 60000;
localparam         t_clk_prepare             = 38000; //in ps, set between 38 to 95 ns
localparam         t_clk_zero                = 262000; //in ps, (clk_prepare + clk_zero minimum should be 300ns)
localparam         t_clk_pre                 = 12*(DPHY_CLK/2); // in ps
localparam         t_clk_post                = (1200000 + (52*DPHY_CLK/2)); // in ps, minimum of 60ns+52*UI
localparam         t_clk_trail               = 60000; //in ps, minimum of 60ns
localparam         t_hs_prepare              = (85000 + (6*DPHY_CLK/2)); //in ps, set between 40ns+4*UI to max of 85ns+6*UI
localparam         t_hs_zero                 = ((145000 + (10*DPHY_CLK/2)) - t_hs_prepare); //in ps, hs_prepare + hs_zero minimum should be 145ns+10*UI
localparam         t_hs_trail                = ((60000 + (4*DPHY_CLK/2)) + (105000 + (12*DPHY_CLK/2)))/2; //in ps, minimum should be 60ns+4*UI, max should be 105ns+12*UI
localparam         t_init                    = 1000; //in ps
localparam         vact_payload              = 16'd21; //VACT 2-byte word count (total number of bytes of active pixels in 1 line)
localparam         hsa_payload               = 16'h007A; //HSA 2-byte word count (number of bytes of payload, see MIPI DSI spec v1.1 figure 30), used for Non-burst sync pulse
localparam         bllp_payload              = 16'h193A; //BLLP 2-byte word count (number of bytes of payload, see MIPI DSI spec v1.1 figure 30), used for HS_ONLY mode
localparam         hbp_payload               = 16'h01AE; //HBP 2-byte word count (number of bytes of payload, see MIPI DSI spec v1.1 figure 30), used for HS_ONLY mode and HS_LP Non-burst sync pulse
localparam         hfp_payload               = 16'h0100; //HFP 2-byte word count (number of bytes of payload, see MIPI DSI spec v1.1 figure 30), used for HS_ONLY mode and HS_LP Non-burst sync pulse
localparam         lps_bllp_duration         = 2470000; // in ps, used for HS_LP mode, this pertains to the LP-11 state duration for blanking
localparam         lps_hbp_duration          = 800000; // in ps, used for HS_LP Non-burst sync events and burst mode, this pertains to the LP-11 state duration for horizontal back porch
localparam         lps_hfp_duration          = 500000; // in ps, used for HS_LP Non-burst sync events and burst mode, this pertains to the LP-11 state duration for horizontal front porch
localparam         virtual_channel           = 2'h0; // virtual channel ID. example: 2'h0
localparam         vsa_lines                 = 5; // number of VSA lines, see MIPI DSI spec v1.1 figure 30
localparam         vbp_lines                 = 36; // number of VBP lines, see MIPI DSI spec v1.1 figure 30
localparam         vfp_lines                 = 4; // number of VFP lines, see MIPI DSI spec v1.1 figure 30
localparam         eotp_enable               = 1; // to enable/disable EOTP packet
localparam         debug_on                  = 0; // for enabling/disabling DPHY data debug messages
localparam         frame_gap                 = 5000000; //delay between frames (in ps)
localparam         CSI2_NUM_PIXELS           = 1000;
localparam         FRAME_LPM_DELAY           = 5000000;
localparam         INIT_DELAY                = 5000000;
localparam         lps_gap                   = 5000000;
localparam         new_param                 = (DATA_SETTLE_CYC*RX_GEAR*DPHY_CLK > t_hs_zero)? (DATA_SETTLE_CYC*RX_GEAR*DPHY_CLK - t_hs_prepare) + t_hs_zero : t_hs_zero;
localparam         ls_le_en                  = 0;
localparam [15:0]  CIL_WORD_COUNT            = 16'h1770 * 4/NUM_RX_LANE - 1;
// Internal parameters for TB
localparam         DATA_COUNT        = 800; // count of received data
localparam integer refclk_period     = (RX_CLK_MODE == "HS_LP")? 2000000/(BYTECLK_MHZ*RX_GEAR): 1000000/BYTECLK_MHZ;
localparam         DATA_R_WIDTH      = (PARSER == "ON")? ((RX_GEAR == 16 & NUM_RX_LANE == 4)? 64 : 32) : 0;
localparam         AXI_DATA_WIDTH    = NUM_RX_LANE*RX_GEAR + DATA_R_WIDTH;
localparam         DATA_WIDTH        = NUM_RX_LANE*RX_GEAR;
localparam         ESC_CLK_PER       = 500000/SYNCCLK_MHZ;/// (BYTECLK_MHZ*RX_GEAR)*100;
localparam         VIDEO_DATA_TYPE   = (RX_TYPE == "DSI")? (
                                                             (DATA_TYPE == "RGB666_LOOSE")?     6'h2E :
                                                             (DATA_TYPE == "RGB666")?           6'h1E :
                                                           /*(DATA_TYPE == "RGB888")?*/         6'h3E
                                                           ) :
                                                           (
                                                             (DATA_TYPE == "RAW8")?             6'h2A :
                                                             (DATA_TYPE == "RAW10")?            6'h2B :
                                                             (DATA_TYPE == "RAW12")?            6'h2C :
                                                             (DATA_TYPE == "YUV420_10")?        6'h19 :
                                                             (DATA_TYPE == "YUV420_8")?         6'h18 :
                                                             (DATA_TYPE == "YUV422_10")?        6'h1F :
                                                             (DATA_TYPE == "YUV422_8")?         6'h1E :
                                                             (DATA_TYPE == "LEGACY_YUV420_8")?  6'h1A :
                                                             (DATA_TYPE == "YUV420_10_CSPS")?   6'h1D :
                                                             (DATA_TYPE == "YUV420_8_CSPS")?    6'h1C :
                                                           /*(DATA_TYPE == "RGB888")?*/         6'h24
                                                           );
localparam         CMOS_DWIDTH       = (RX_TYPE == "DSI")? (
                                                             (DATA_TYPE == "RGB666_LOOSE")?     6 :
                                                             (DATA_TYPE == "RGB666")?           6 :
                                                           /*(DATA_TYPE == "RGB888")?*/         8
                                                           ) :
                                                           (
                                                             (DATA_TYPE == "RAW8")?             8 :
                                                             (DATA_TYPE == "RAW10")?           10 :
                                                             (DATA_TYPE == "RAW12")?           12 :
                                                             (DATA_TYPE == "YUV420_10")?       10 :
                                                             (DATA_TYPE == "YUV420_8")?         8 :
                                                             (DATA_TYPE == "YUV422_10")?       10 :
                                                             (DATA_TYPE == "YUV422_8")?         8 :
                                                             (DATA_TYPE == "LEGACY_YUV420_8")?  8 :
                                                             (DATA_TYPE == "YUV420_10_CSPS")?  10 :
                                                             (DATA_TYPE == "YUV420_8_CSPS")?    8 :
                                                           /*(DATA_TYPE == "RGB888")?*/        24
                                                           );
localparam         num_pixels        = (RX_TYPE == "DSI")? (
                                                            32'd0
                                                           ) :
                                                           (
                                                             (DATA_TYPE == "RAW8")?            CSI2_NUM_PIXELS        :
                                                             (DATA_TYPE == "RAW10")?           CSI2_NUM_PIXELS * 5/4  :
                                                             (DATA_TYPE == "RAW12")?           CSI2_NUM_PIXELS * 3/2  :
                                                             (DATA_TYPE == "YUV420_10")?       CSI2_NUM_PIXELS * 5/4  : // odd line
                                                             (DATA_TYPE == "YUV420_8")?        CSI2_NUM_PIXELS        : // odd line
                                                             (DATA_TYPE == "YUV422_10")?       CSI2_NUM_PIXELS * 5/2  :
                                                             (DATA_TYPE == "YUV422_8")?        CSI2_NUM_PIXELS * 2    :
                                                             (DATA_TYPE == "LEGACY_YUV420_8")? CSI2_NUM_PIXELS * 3/2  :
                                                             (DATA_TYPE == "YUV420_10_CSPS")?  CSI2_NUM_PIXELS * 5/4  : // odd line
                                                             (DATA_TYPE == "YUV420_8_CSPS")?   CSI2_NUM_PIXELS        : // odd line
                                                           /*(DATA_TYPE == "RGB888")?*/        CSI2_NUM_PIXELS * 3
                                                           );
localparam         long_even_line_en = (RX_TYPE == "DSI")? (
                                                            32'd0
                                                           ) :
                                                           (
                                                             (DATA_TYPE == "RAW8")?            0 :
                                                             (DATA_TYPE == "RAW10")?           0 :
                                                             (DATA_TYPE == "RAW12")?           0 :
                                                             (DATA_TYPE == "YUV420_10")?       1 :
                                                             (DATA_TYPE == "YUV420_8")?        1 :
                                                             (DATA_TYPE == "YUV422_10")?       0 :
                                                             (DATA_TYPE == "YUV422_8")?        0 :
                                                             (DATA_TYPE == "LEGACY_YUV420_8")? 0 :
                                                             (DATA_TYPE == "YUV420_10_CSPS")?  1 :
                                                             (DATA_TYPE == "YUV420_8_CSPS")?   1 :
                                                           /*(DATA_TYPE == "RGB888")?*/        0
                                                           );

// -----------------------------------------------------------------------------
// Generate Variables
// -----------------------------------------------------------------------------
integer l = 0;
integer true_result  = 0;
integer false_result = 0;
real    dphy_clk;
integer D_true_res;
integer D_false_res;
integer D_file_1_value;
integer D_file_2_value;
integer D_file_1; 
integer D_file_2;
integer D_status_1;
integer D_status_2;
//
integer f;
initial f = $fopen("received_data.txt","w");
//
// -----------------------------------------------------------------------------
// Sequential Registers
// -----------------------------------------------------------------------------
  ///LMMI
    reg        lmmi_clk_r     = 1'd0;
    reg        lmmi_resetn_r  = 1'd0;
    reg [ 7:0] lmmi_wdata_r   =  'd0;
    reg        lmmi_wr_rdn_r  = 1'd0;
    reg [ 5:0] lmmi_offset_r  =  'd0;
    reg        lmmi_request_r = 1'd0;
  ///LMMI

  ///Reset
    reg        sync_rst_r = 1;
    reg        reset_lp_w;
    reg        reset_byte_fr_w;
    reg        reset_byte_w;
    reg        system_reset_w;

    reg        pd_dphy_i;
  ///Reset

  ///Clock
    reg        sync_clk_r = 0;
    reg        cont_clk; //for csi2 model, HS_ONLY mode
    reg        refclk_i;
    reg        lp_ctrl_clk=0;
    reg        clock_fr_r = 0;
  ///Clock

  ///Enable
    reg        first_byte_data_r = 1'd0;
    reg        pay_data_pass_r   = 1'd0;
    reg        diff_clk_en;
    reg        valid_data_r      = 1'd0;
  ///Enable

  ///Data
    reg [63:0] data_from_dut [DATA_COUNT-1:0]; // Memory where write DPHY_RX's received data
  ///Data

  ///Counter
    reg [15:0] disp_word_count = 16'd0;
    reg [15:0] byte_count_r = 16'd0;
  ///Counter

  /// GSR
    reg CLK_GSR = 0;
    reg USER_GSR = 1;
  /// GSR



// -----------------------------------------------------------------------------
// Wire Declarations
// -----------------------------------------------------------------------------
  ///LMMI
    wire                      lmmi_clk_i;
    wire                      lmmi_resetn_i;
    wire [8:0]                lmmi_wdata_i;
    wire [3:0]                lmmi_rdata_o;
    wire                      lmmi_rdata_valid_o;
    wire                      lmmi_wr_rdn_i;
    wire [5:0]                lmmi_offset_i;
    wire                      lmmi_request_i;
    wire                      lmmi_ready_o;
  ///LMMI

  ///AXI
    wire                      axis_mtvalid_o;
    wire [AXI_DATA_WIDTH-1:0] axis_mtdata_o;
    wire                      axis_stready_i;
    wire                      axis_mtvalid_w;
  ///AXI

  ///Reset
    wire                      pll_lock_i;
    wire                      sync_rst_i;
    wire                      reset_n_i;
    wire                      reset_lp_n_i;
    wire                      reset_byte_n_i;
    wire                      reset_byte_fr_n_i;
  ///Reset

  ///Clock
    wire                      sync_clk_i;
    wire                      clk_lp_ctrl_i;
    wire                      clk_byte_fr_i;
    wire                      clk_byte_o;
    wire                      clk_byte_hs_o;
    wire                      clk_byte_fr;     //used to connect clk_byte_fr_i to clk_byte_hs_o
  ///Clock

  ///Enable
    wire 			  						  ready_o;
    wire                      payload_en_o;
    wire                      capture_en_o;
    wire                      sp_en_o;
    wire                      lp_en_o;
    wire                      lp_av_en_o;
    wire                      sp2_en_o;
    wire                      lp2_en_o;
    wire                      lp2_av_en_o;
    wire                      tx_rdy_i;
  ///Enable

  ///Header
    wire [5:0]                dt_o;
    wire [1:0]                vc_o;
    wire [15:0]               wc_o;
    wire [7:0]                ecc_o;
    wire [5:0]                dt2_o;
    wire [1:0]                vc2_o;
    wire [15:0]               wc2_o;
    wire [7:0]                ecc2_o;
    wire [5:0]                ref_dt_i;
  ///Header

  ///Data
    wire [NUM_RX_LANE*8-1:0]  bd_o;
    wire [DATA_WIDTH-1:0]     payload_o;
    wire [RX_GEAR-1:0]        bd0_o ;
    wire [RX_GEAR-1:0]        bd1_o ;
    wire [RX_GEAR-1:0]        bd2_o ;
    wire [RX_GEAR-1:0]        bd3_o ;
  ///Data

  ///Datachacker
    wire                      valid_w;          // used for chacker
    wire                      pars_off_en_w;    // used for chacker 
    wire                      payload_en_w;     // used for chacker 
    wire                      data_en_w;        // used for chacker 
    wire [DATA_WIDTH-1:0]     byte_data_temp_w; // used for chacker
    wire [15:0]               wc_w;             // used for chacker
  ///Datachacker

  ///High speed p/n
    wire                      clk_p_io;
    wire                      clk_n_io;
    wire [NUM_RX_LANE-1:0]    d_p_io;
    wire [NUM_RX_LANE-1:0]    d_n_io;
    
    wire                      clk_p_w;
    wire                      clk_n_w;
    wire [3:0]                d_p_io_w;
    wire [3:0]                d_n_io_w;
  ///High speed p/n

  // outputs
    wire                      hs_d_en_o;
    wire                      hs_sync_o;
    wire                      term_clk_en_o;
    wire [1:0]                lp_hs_state_clk_o;
    wire [1:0]                lp_hs_state_d_o;
    wire                      lintr_int_o;
    wire                      cd_clk_o;
    wire                      cd_d0_o;
    wire [NUM_RX_LANE-1:0]    term_d_en_o;
  // outputs

  ///Constantin 
    wire                      lp_d0_tx_en_i;   ///not supported  
    wire                      lp_d0_tx_p_i;    ///not supported 
    wire                      lp_d0_tx_n_i;    ///not supported 

    wire [NUM_RX_LANE-1:0]    lp_d_rx_p_o;
    wire [NUM_RX_LANE-1:0]    lp_d_rx_n_o;
  ///Constantin 

  ///GSR
    wire GSROUT;
  ///GSR

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
initial begin
  pd_dphy_i = 1;
  #700000;
  pd_dphy_i = 0;
end
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// -----------------------------------------------------------------------------
// Assign Statements
// -----------------------------------------------------------------------------
  ///LMMI
    assign lmmi_clk_i        = lmmi_clk_r;
    assign lmmi_resetn_i     = lmmi_resetn_r;
    assign lmmi_wdata_i      = lmmi_wdata_r;
    assign lmmi_wr_rdn_i     = lmmi_wr_rdn_r;
    assign lmmi_offset_i     = lmmi_offset_r;
    assign lmmi_request_i    = lmmi_request_r;
  ///LMMI

  ///AXI
    assign axis_stready_i    = (AXI4 == "ON")? 1'd1 : 1'd0;
  ///AXI

  ///Clock
    assign sync_clk_i        = sync_clk_r;
    assign clk_byte_fr_i     = (RX_CLK_MODE == "HS_ONLY")? clk_byte_fr : clock_fr_r;
    assign clk_lp_ctrl_i     = lp_ctrl_clk;
    assign clk_byte_fr       = (RX_CLK_MODE == "HS_ONLY")? clk_byte_hs_o : 1'd0;
  ///Clock

  ///Reset
    assign sync_rst_i        = sync_rst_r;
    assign reset_lp_n_i      = reset_lp_w;
    assign reset_byte_fr_n_i = reset_byte_fr_w;
    assign reset_byte_n_i    = reset_byte_w;
    assign reset_n_i         = system_reset_w;
  ///Reset

  ///High speed p/n
    assign clk_p_io          = clk_p_w;
    assign clk_n_io          = clk_n_w;
    assign d_p_io            = d_p_io_w[NUM_RX_LANE-1:0];
    assign d_n_io            = d_n_io_w[NUM_RX_LANE-1:0];
  ///High speed p/n

  ///Header
    assign ref_dt_i          = VIDEO_DATA_TYPE;
  ///Header
  
  /// Data Chacker
    assign byte_data_temp_w  = (AXI4 == "ON")? axis_mtdata_o[DATA_WIDTH-1:0] : (PARSER == "ON")? payload_o : {bd3_o,bd2_o,bd1_o,bd0_o};
    assign wc_w              = (RX_TYPE == "DSI")? vact_payload : num_pixels;
    assign valid_w           = data_en_w;
    assign payload_en_w      = (AXI4 == "ON")? ((PARSER == "ON")?axis_mtvalid_o : valid_data_r) : (PARSER == "ON")? payload_en_o  : valid_data_r;  
    assign pars_off_en_w     = (AXI4 == "ON")? axis_mtvalid_o : capture_en_o; 
  /// Data Chacker

  ///Constantin  
    assign pll_lock_i        = 1'd1;
    assign tx_rdy_i          = 1;    
    assign lp_d0_tx_en_i     = 1'd0;//don't supported for now
    assign lp_d0_tx_p_i      = 1'd0;//don't supported for now
    assign lp_d0_tx_n_i      = 1'd0;//don't supported for now
  ///Constantin

// -----------------------------------------------------------------------------
// Sequential Blocks
// -----------------------------------------------------------------------------


generate
  if (RX_CLK_MODE == "HS_LP") begin
    always #(refclk_period/2)   refclk_i = ~refclk_i;
  end
  else if (RX_TYPE == "CSI2") begin
    always #(DPHY_CLK/2) cont_clk = ~cont_clk;
  end
endgenerate

// generates LMMI clock when LMMI is on.
generate
  if (LMMI == "ON") begin
    always begin
      #(refclk_period/2) lmmi_clk_r <= ~lmmi_clk_r;
    end
  end
endgenerate


generate
  if (CIL_BYPASS == "CIL_ENABLED") begin
    always #(ESC_CLK_PER) sync_clk_r <= ~ sync_clk_r;
  end
  else begin
    always #(9*refclk_period/2) sync_clk_r <= ~ sync_clk_r;
  end
endgenerate

generate 
  if (PARSER == "OFF") begin
    always @(posedge valid_w) begin
      @(posedge pars_off_en_w);
      while (byte_data_temp_w[DATA_WIDTH-1:DATA_WIDTH-8] != 8'hb8) begin
        @(negedge clk_byte_fr_i);
      end
      repeat(1 + 4*8/(NUM_RX_LANE*RX_GEAR)) begin
        @(posedge clk_byte_fr_i);
      end    
      valid_data_r = 1'd1;
      @(negedge pars_off_en_w);
        valid_data_r = 1'd0;
    end
  end
endgenerate

// Invoking datachacker
always begin
  @(posedge payload_en_w)
    datachack(wc_w);    
end

//generate clk for clk_lp_ctrl_i  = 50MHz
always #(10000) lp_ctrl_clk = ~lp_ctrl_clk;

always #(500000/(BYTECLK_MHZ)) clock_fr_r  <= ~clock_fr_r;

// -----------------------------------------------------------------------------
// Submodule Instantiations and Sequential Blocks (generates compiles note together)
// -----------------------------------------------------------------------------
`include "dut_inst.v"

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
///        
generate
  if (DPHY_RX_IP != "LATTICE") begin
    initial begin
      #200000;
      sync_rst_r = 1'd0;
    end
  end
endgenerate

generate
  if (RX_TYPE == "DSI") begin
    dsi_model #(
      .dphy_num_lane     (NUM_RX_LANE),
      .dphy_clk_period   (DPHY_CLK  ),
      .CLK_MODE          (RX_CLK_MODE),
      .num_frames        (num_frames       ),
      .num_lines         (num_lines        ),
      .t_lpx             (t_lpx            ),
      .t_clk_prepare     (t_clk_prepare    ),
      .t_clk_zero        (t_clk_zero       ),
      .t_clk_pre         (t_clk_pre        ),
      .t_clk_post        (t_clk_post       ),
      .t_clk_trail       (t_clk_trail      ),
      .t_hs_prepare      (t_hs_prepare     ),
      .t_hs_zero         (new_param        ),
      .t_hs_trail        (t_hs_trail       ),
      .t_init            (t_init           ),
      .hsa_payload       (hsa_payload      ),
      .bllp_payload      (bllp_payload     ),
      .hbp_payload       (hbp_payload      ),
      .hfp_payload       (hfp_payload      ),
      .lps_bllp_duration (lps_bllp_duration),
      .lps_hfp_duration  (lps_hfp_duration ),
      .lps_hbp_duration  (lps_hbp_duration ),
      .vact_payload      (vact_payload     ),
      .virtual_channel   (virtual_channel  ),
      .video_data_type   (VIDEO_DATA_TYPE  ),
      .vsa_lines         (vsa_lines        ),
      .vbp_lines         (vbp_lines        ),
      .vfp_lines         (vfp_lines        ),
      .eotp_enable       (eotp_enable      ),
      .frame_gap         (frame_gap        ),
      .debug_on          (debug_on         )
    )
    dsi_ch0 (
      .resetn        (system_reset_w), //resetn
      .clk_p_i       (clk_p_w),
      .clk_n_i       (clk_n_w),
      .d_p_i         (d_p_io_w),
      .d_n_i         (d_n_io_w),
      .dsi_valid_o   (data_en_w)
    );

    initial begin
      $timeformat(-12,0,"",10);
      refclk_i = 0;
      cont_clk = 0;
      fork
        begin
          reset_byte;
        end
        begin
          drive_reset;
          if(DPHY_CLK%2 > 0) begin
              dphy_clk = DPHY_CLK - 1;
          end
          else begin
              dphy_clk = DPHY_CLK;
          end

          $display("%0t TEST START\n",$realtime);
          #(DPHY_CLK*12*3);

          #(INIT_DELAY); //wait initialization delay
          dsi_ch0.dphy_active = 1;
          $display("%t Activating DSI model\n", $time);
          @(negedge dsi_ch0.dphy_active);
          #10;
          $fclose(f);
          #100000;
          text_comp_t;
          #10
          if (pay_data_pass_r == 1) begin
            $display("**SIMULATION PASSED**");
          end 
          else begin
            $display("**SIMULATION FAILED**");
          end 		      
        end
      join
      test_end;
      $finish;
    end
  end

  else begin
      csi2_model #(
        .active_dphy_lanes (NUM_RX_LANE),
        .RX_CLK_MODE       (RX_CLK_MODE),
        .DATA_COUNT        (DATA_COUNT),
        .num_frames        (num_frames),
        .num_lines         (num_lines),
        .num_pixels        (num_pixels),
        .data_type         (VIDEO_DATA_TYPE),
        .dphy_clk_period   (DPHY_CLK),
        .t_lpx             (t_lpx),
        .t_clk_prepare     (t_clk_prepare),
        .t_clk_zero        (t_clk_zero),
        .t_clk_pre         (t_clk_pre),
        .t_clk_post        (t_clk_post),
        .t_clk_trail       (t_clk_trail),
        .t_hs_prepare      (t_hs_prepare),
        .t_hs_zero         (new_param),
        .t_hs_trail        (t_hs_trail),
        .lps_gap           (lps_gap),
        .frame_gap         (frame_gap),
        .t_init            (t_init ),
        .dphy_ch           (0),
        .dphy_vc           (virtual_channel),
        .long_even_line_en (long_even_line_en),
        .ls_le_en          (ls_le_en),
        .debug             (debug_on)
      )
      u_csi2_model (
        .resetn            (system_reset_w), //resetn
        .refclk_i          ((RX_CLK_MODE == "HS_ONLY")? cont_clk : refclk_i),
        .pll_lock          (1'd1),
        .clk_p_i           (clk_p_w),
        .clk_n_i           (clk_n_w),
        .do_p_i            (d_p_io_w),
        .do_n_i            (d_n_io_w),
        .csi_valid_o       (data_en_w)
      );


    initial begin
        $timeformat(-12,0,"",10);
        refclk_i = 0;
        cont_clk = 0;
        fork
          begin
            reset_byte;
          end
          begin
            drive_reset;
            if(DPHY_CLK%2 > 0) begin
                dphy_clk = DPHY_CLK - 1;
            end
            else begin
                dphy_clk = DPHY_CLK;
            end
            $display("%0t TEST START\n",$realtime);
            #(DPHY_CLK*12*3);
            #(INIT_DELAY); //wait initialization delay
            u_csi2_model.dphy_active = 1;
            $display("%t Activating CSI2 model\n", $time);
            @(negedge u_csi2_model.dphy_active);
            #10;
            $fclose(f);
            #100000;
        text_comp_t;
          #10
        if (pay_data_pass_r == 1) begin
            $display("**SIMULATION PASSED**");
          end 
          else begin
            $display("**SIMULATION FAILED**");
          end 
        end
      join
        test_end;
        $finish;
    end
  end 
endgenerate

// -----------------------------------------------------------------------------
// Task Declarations
// -----------------------------------------------------------------------------

// Global task which includes all reset tasks
task drive_reset();
  begin
     reset_lp_w       = 1;
     reset_byte_fr_w  = 0;
     // reset_byte_w     = 0;
     system_reset_w   = 1;
     if (DPHY_RX_IP == "LATTICE") begin
      gddr_reset;
      @(posedge ready_o);
    end
    fork
      begin reset_lp;      end
      begin reset_byte_fr; end
      begin system_reset;  end
      begin if (LMMI == "ON") lmmi_reset;    end
    join
  end
endtask

task reset_lp();
  begin
    reset_lp_w = 0;
    @(posedge lp_ctrl_clk);
    #1;
    reset_lp_w = 1;
  end
endtask

task reset_byte_fr();
  begin
    reset_byte_fr_w = 0;
    #10;
    @(posedge clk_byte_fr_i);
    #1;
    reset_byte_fr_w = 1;
  end
endtask

// Byte clock's reset
task reset_byte();
  begin
  reset_byte_w = 0;
    #10;
    if (RX_CLK_MODE == "HS_ONLY") begin
      @(posedge clk_byte_hs_o);
    end
    else begin
      @(posedge clk_byte_fr_i);
    end
    #1;
    reset_byte_w = 1;
  end
endtask

// system reset
task system_reset();
  begin
    system_reset_w = 0;
    #(2*refclk_period);
    system_reset_w = 1;
  end
endtask

// task which gives initial values to LMMI ports and resets LMMI
task lmmi_reset();
  begin
    lmmi_clk_r     = 1'd0;
    lmmi_resetn_r  = 1'd0;
    lmmi_wdata_r   = 9'd0;
    lmmi_wr_rdn_r  = 1'd0;
    lmmi_offset_r  = 6'd0;
    lmmi_request_r = 1'd0;
    #10;
    @(posedge lmmi_clk_i)
    #1;
    lmmi_resetn_r  = 1'd1;
  end
endtask

// task which reset lscc_gddr_sync in SOFT_RX which reset other modules
task gddr_reset();
  begin
    repeat (10) begin
      @(posedge sync_clk_r);
    end
    #1;
    sync_rst_r     = 1'd0;
  end
endtask

// task which writes in LMMI registers
task lmmi_write(
  input [5:0] offset,
  input [7:0] data
  );begin
    @(posedge lmmi_clk_i);
    lmmi_offset_r  <= offset;
    lmmi_wdata_r   <= data;
    lmmi_wr_rdn_r  <= 1'd1;
    lmmi_request_r <= 1'd1;
    @(posedge lmmi_clk_i);
    $display("Write %b",lmmi_wdata_r," in register %b", lmmi_offset_r);
    lmmi_offset_r  <= 6'd0;
    lmmi_wdata_r   <= 9'd0;
    lmmi_wr_rdn_r  <= 1'd0;
    lmmi_request_r <= 1'd0;
  end
endtask

// Task which writing incoming data in text document
task datachack( 
  input            [15: 0] num_bytes
  );begin    
    first_byte_data_r  = 1;
    byte_count_r       = 0;
    while(byte_count_r < num_bytes) begin
      @(negedge clk_byte_fr_i);      
      if (num_bytes - byte_count_r < (RX_GEAR*NUM_RX_LANE)/8) begin
        case(num_bytes - byte_count_r)
          16'd1 : begin
            $fwrite(f,"%0x\n",byte_data_temp_w[ 7: 0]);
          end
          16'd2 : begin
            if (PARSER == "ON" || RX_GEAR == 8) begin
              $fwrite(f,"%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[15: 8]);              
            end
            else begin
              $fwrite(f,"%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[23:16]);              
            end
          end
          16'd3 : begin
            if (PARSER == "ON" || RX_GEAR == 8) begin
              $fwrite(f,"%0x\n%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[15:8],byte_data_temp_w[23:16]);
            end
            else begin
              if (NUM_RX_LANE == 2) begin
                $fwrite(f,"%0x\n%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[23:16],byte_data_temp_w[15: 8]);                
              end
              else begin
                $fwrite(f,"%0x\n%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[23:16],byte_data_temp_w[39:32]);
              end
            end
          end
          16'd4 : begin
            if (PARSER == "ON") begin
              $fwrite(f,"%0x\n%0x\n%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[15: 8],byte_data_temp_w[23:16],byte_data_temp_w[31:24]);
            end
            else begin
              if (NUM_RX_LANE == 3 ) begin
                $fwrite(f,"%0x\n%0x\n%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[23:16],byte_data_temp_w[39:32],byte_data_temp_w[15: 8]);
              end
              else begin
                $fwrite(f,"%0x\n%0x\n%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[23:16],byte_data_temp_w[39:32],byte_data_temp_w[55:48]);
              end
            end
          end
          16'd5 : begin
            if (PARSER == "ON") begin
              $fwrite(f,"%0x\n%0x\n%0x\n%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[15: 8],byte_data_temp_w[23:16],byte_data_temp_w[31:24],byte_data_temp_w[39:32]);
            end
            else begin
              if (NUM_RX_LANE == 3) begin
                $fwrite(f,"%0x\n%0x\n%0x\n%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[23:16],byte_data_temp_w[39:32],byte_data_temp_w[15:8],byte_data_temp_w[31:24]);
              end
              else begin
                $fwrite(f,"%0x\n%0x\n%0x\n%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[23:16],byte_data_temp_w[39:32],byte_data_temp_w[55:48],byte_data_temp_w[15: 8]);
              end
            end
          end
          16'd6 : begin
            if (PARSER == "ON") begin
              $fwrite(f,"%0x\n%0x\n%0x\n%0x\n%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[15: 8],byte_data_temp_w[23:16],byte_data_temp_w[31:24],byte_data_temp_w[39:32],byte_data_temp_w[47:40]);
            end
            else begin
              $fwrite(f,"%0x\n%0x\n%0x\n%0x\n%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[23:16],byte_data_temp_w[39:32],byte_data_temp_w[55:48],byte_data_temp_w[15: 8],byte_data_temp_w[31:24]);
            end
          end
          16'd7 : begin
            if (PARSER == "ON") begin
              $fwrite(f,"%0x\n%0x\n%0x\n%0x\n%0x\n%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[15: 8],byte_data_temp_w[23:16],byte_data_temp_w[31:24],byte_data_temp_w[39:32],byte_data_temp_w[47:40],byte_data_temp_w[55:48]);
            end
            else begin
              $fwrite(f,"%0x\n%0x\n%0x\n%0x\n%0x\n%0x\n%0x\n",byte_data_temp_w[ 7: 0],byte_data_temp_w[23:16],byte_data_temp_w[39:32],byte_data_temp_w[55:48],byte_data_temp_w[15: 8],byte_data_temp_w[31:24],byte_data_temp_w[47:40]);
            end
          end
        endcase
      end
      else begin
        if (DATA_WIDTH ==  8) begin
          $fwrite(f,"%0x\n",byte_data_temp_w[7:0]);
        end 
        else if (DATA_WIDTH == 16) begin
          $fwrite(f,"%0x\n%0x\n",byte_data_temp_w[7:0],byte_data_temp_w[15:8]);
        end
        else if (DATA_WIDTH == 24) begin
          if (first_byte_data_r) begin
            $fwrite(f,"%0x\n%0x\n",byte_data_temp_w[15:8],byte_data_temp_w[23:16]);
          end
          else begin
            $fwrite(f,"%0x\n%0x\n%0x\n",byte_data_temp_w[7:0],byte_data_temp_w[15:8],byte_data_temp_w[23:16]);
          end
        end 
        else if (DATA_WIDTH == 32) begin
          if (PARSER == "ON" || RX_GEAR == 8) begin
            $fwrite(f,"%0x\n%0x\n%0x\n%0x\n",byte_data_temp_w[7:0],byte_data_temp_w[15:8],byte_data_temp_w[23:16],byte_data_temp_w[31:24]);
          end
          else begin
            $fwrite(f,"%0x\n%0x\n%0x\n%0x\n",byte_data_temp_w[7:0],byte_data_temp_w[23:16],byte_data_temp_w[15:8],byte_data_temp_w[31:24]);
          end
        end
        else if (DATA_WIDTH == 48) begin
            if (first_byte_data_r) begin
              $fwrite(f,"%0x\n%0x\n",                               byte_data_temp_w[31:24],
                                                                    byte_data_temp_w[47:40]);
            end
            else begin
              $fwrite(f,"%0x\n%0x\n%0x\n%0x\n%0x\n%0x\n",           byte_data_temp_w[ 7: 0],
                                                                    byte_data_temp_w[23:16],
                                                                    byte_data_temp_w[39:32],
                                                                    byte_data_temp_w[15: 8],
                                                                    byte_data_temp_w[31:24],
                                                                    byte_data_temp_w[47:40]);
            end
        end 
        else if (DATA_WIDTH == 64) begin
          if (PARSER == "ON") begin            
            $fwrite(f,"%0x\n%0x\n%0x\n%0x\n%0x\n%0x\n%0x\n%0x\n", byte_data_temp_w[ 7: 0],
                                                                  byte_data_temp_w[15: 8],
                                                                  byte_data_temp_w[23:16],
                                                                  byte_data_temp_w[31:24],
                                                                  byte_data_temp_w[39:32],
                                                                  byte_data_temp_w[47:40],
                                                                  byte_data_temp_w[55:48],
                                                                  byte_data_temp_w[63:56]);
          end
          else begin
            if (first_byte_data_r) begin
              $fwrite(f,"%0x\n%0x\n%0x\n%0x\n",                     byte_data_temp_w[15: 8],
                                                                    byte_data_temp_w[31:24],
                                                                    byte_data_temp_w[47:40],
                                                                    byte_data_temp_w[63:56]);
            end
            else begin
              $fwrite(f,"%0x\n%0x\n%0x\n%0x\n%0x\n%0x\n%0x\n%0x\n", byte_data_temp_w[ 7: 0],
                                                                    byte_data_temp_w[23:16],
                                                                    byte_data_temp_w[39:32],
                                                                    byte_data_temp_w[55:48],
                                                                    byte_data_temp_w[15: 8],
                                                                    byte_data_temp_w[31:24],
                                                                    byte_data_temp_w[47:40],
                                                                    byte_data_temp_w[63:56]);
            end            
          end
        end
      end
      if ((first_byte_data_r && DATA_WIDTH == 64 && PARSER == "OFF") || ((NUM_RX_LANE == 3) && first_byte_data_r)) begin
        byte_count_r       = byte_count_r + NUM_RX_LANE - (NUM_RX_LANE == 3);
        first_byte_data_r = 0;
      end
      else begin
        byte_count_r       = byte_count_r + (RX_GEAR*NUM_RX_LANE)/8;
      end      
    end
    $display("%0t Reaciving video data DONE!",$realtime);
  end
endtask


// Task which compare two text files
task text_comp_t;
  begin  
    D_status_1       = 0;
    D_status_2       = 0;
    D_true_res       = 32'd0;
    D_false_res      = 32'd0;
    D_file_1_value   = 32'd0;
    D_file_2_value   = 32'd0;
    D_file_1         = $fopen("DRIVEN_DATA.txt","r");
    D_file_2         = $fopen("received_data.txt","r");
    pay_data_pass_r  = 1'd0;
    #1;
    $display("Start of data comparing");
    while (!$feof(D_file_1) | !$feof(D_file_2)) begin
      #1;
      D_status_1 = $fscanf(D_file_1,"%h\n",D_file_1_value);
      D_status_2 = $fscanf(D_file_2,"%h\n",D_file_2_value);
      #1;
      if (D_file_1_value == D_file_2_value) begin
        D_true_res   = D_true_res + 1;
      end
      else begin
        D_false_res  = D_false_res + 1;
        $display("Time : %0t ps Error %h from test not equal to %h from DUT",$realtime,D_file_1_value,D_file_2_value);
      end
    end
    $fclose(D_file_1);
    $fclose(D_file_2);
    $display("End of data comparing");
    ///////////////////////////////////////////////////
    /// Payload Data Check
    ///////////////////////////////////////////////////
    if (D_false_res == 0 && D_true_res != 0) begin
      if (D_status_1 == 1) begin
        $display("***PAYLOAD DATA PASS***");
        pay_data_pass_r = 1'd1;
      end
      else begin
         $display("***CURRENT CONFIGURATION NOT SUPPORTED***");
         pay_data_pass_r = 1'd0;
      end      
    end
    else begin
      $display("***PAYLOAD DATA FAIL***");
      $display("Errors` ",D_false_res,"/",D_false_res + D_true_res);
      pay_data_pass_r = 1'd0;
    end
  end
endtask

task test_end;
  begin
    $display("Test end");
    $stop;
  end
endtask

endmodule
//==============================================================================
// tb_top.v
//==============================================================================
`endif
