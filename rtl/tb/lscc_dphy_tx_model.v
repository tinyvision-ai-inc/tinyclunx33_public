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
// File                  : lscc_dphy_tx_model.v
// Title                 : This is the DPHY_TX testbench model.
// Dependencies          : 1.
//                       : 2.
// Description           :
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0
// Author(s)             :
// Mod. Date             :
// Changes Made          : Initial version.
// -----------------------------------------------------------------------------
// Version               : 1.1
// Author(s)             : 
// Mod. Date             : 01/08/2018
// Changes Made          : Checking coding style and name changing.
// -----------------------------------------------------------------------------
// Version               : 1.1
// Author(s)             : 
// Mod. Date             : 01/08/2018
// Changes Made          : Minor fixes added data comparing part.
// =============================================================================

`timescale 1ns/1ps

`ifndef lscc_dphy_tx_model
`define lscc_dphy_tx_model
module lscc_dphy_tx_model #
// -----------------------------------------------------------------------------
// Module Parameters
// -----------------------------------------------------------------------------
(
/// Global
parameter                           NUM_FRAMES                  = 10,
parameter                           NUM_LINES                   = 1080,
parameter                           NUM_BYTES                   = 5760,
parameter                           NUM_BYTES_INCREMENT         = "ON",
parameter [5:0]                     DATA_TYPE                   = 6'h3E,
parameter [1:0]                     EXTVIRTUAL_CHANNEL          = 2'h0,
parameter [1:0]                     VIRTUAL_CHANNEL             = 2'h0,
parameter                           EOTP_ENABLE                 = "ON",
parameter                           NUM_TX_LANE                 = 4,         //number of dphy data lanes.
parameter                           GEAR                        = 16,
parameter                           DRIVING_EDGE                = "posedge", //byte data driving edge: 0 => negedge , 1 => posedge
parameter                           DEVICE_TYPE                 = "CSI2",    //device type: 0 => DSI , 1 => CSI2
parameter                           PACKET_FORMATTER            = "ON",         //0 => without formatter, 1 => with formatter
parameter                           CIL_BYPASS                  = "CIL_BYPASSED",
parameter                           D_HS_RDY_TO_D_HS_CLK_EN_DLY = 10,
parameter                           TX_LINE_RATE_PER_LANE       = 1000,
//for CSI2
parameter                           HS_RDY_TO_SP_EN_DLY         = 10,
parameter                           HS_RDY_TO_LP_EN_DLY         = 10,
parameter                           LP_EN_TO_BYTE_DATA_EN_DLY   = 0,
parameter                           HS_RDY_NEG_TO_HS_CLK_EN_DLY = 200,
parameter                           LS_LE_EN                    = "ON",
parameter                           GEN_FR_NUM                  = "ON",      //0 : to generate frame number for CSI2 packet
parameter                           GEN_LN_NUM                  = "ON",      //0 : to generate line number for CSI2 packet
//for DSI
parameter                           HS_RDY_TO_VSYNC_START_DLY   = 10,
parameter                           HS_RDY_TO_HSYNC_START_DLY   = 10,
parameter                           HS_RDY_TO_BYTE_DATA_EN_DLY  = 10,
parameter                           HSYNC_PULSE_FRONT           = 10,
parameter                           HSYNC_PULSE_BACK            = 10,
parameter                           HSYNC_TO_HSYNC_DLY          = 10,
parameter                           VSYNC_TO_HSYNC_DLY          = 10,
//for packet without formatter
parameter                           HS_RDY_TO_DPHY_PKTEN_DLY    = 10,
//for debug purposes
parameter                           DEBUG_ON                    = "ON",      // for enabling/disabling DPHY data debug messages
/// Internal
parameter                           LMMI                        = "OFF",
parameter                           LMMI_DATA_WIDTH             = 8,
parameter                           LMMI_OFFSET_WIDTH           = 7
)
// -----------------------------------------------------------------------------
// Input/Output Ports
// -----------------------------------------------------------------------------
(
input  wire                         ref_clk_i, //connect to byte_clk_o of DUT
input  wire                         reset_i,
input  wire                         d_hs_rdy_i,
input  wire                         c2d_ready_i,
input  wire [NUM_TX_LANE-1:0]       hs_tx_cil_ready_i,
input  wire                         ld_pyld_i,
output wire                         usrstdby_o,
output wire                         clk_hs_en_o,
output wire                         d_hs_en_o,
output wire [GEAR*NUM_TX_LANE-1:0]  byte_or_pkt_data_o,
output wire                         byte_or_pkt_data_en_o,
output wire [15:0]                  wc_o,
output wire [5:0]                   dt_o,
output wire [1:0]                   vcx_o,
output wire [1:0]                   vc_o,
output wire                         eotp_o,
output wire                         sp_en_o,
output wire                         lp_en_o,
output wire                         vsync_start_o,
output wire                         hsync_start_o,
output wire [3:0]                   tx_cil_word_valid_lane0_o,
output wire [3:0]                   tx_cil_word_valid_lane1_o,
output wire [3:0]                   tx_cil_word_valid_lane2_o,
output wire [3:0]                   tx_cil_word_valid_lane3_o,
output wire [NUM_TX_LANE-1:0]       line_disable_o,
output wire                         hs_clk_cil_ready_i,
input  wire                         lmmi_clk_i,
output wire [LMMI_OFFSET_WIDTH-1:0] lmmi_offset_o,
output wire [LMMI_DATA_WIDTH-1:0]   lmmi_wdata_o,
output wire                         lmmi_wr_rdn_o,
output wire                         lmmi_request_o,
input  wire [LMMI_DATA_WIDTH-1:0]   lmmi_rdata_i
);

// -----------------------------------------------------------------------------
// Local Parameters
// -----------------------------------------------------------------------------
localparam DATA_WIDTH = GEAR*NUM_TX_LANE;
localparam VC_DT_ADDR = 6'd42;
localparam WCL_ADDR   = 6'd43;
localparam WCH_ADDR   = 6'd44;
localparam eotp       = 32'h010F0F08 ;
/// PLL
localparam [4:0] CN_INT =    5'b11000;
localparam [2:0] CO_INT =      3'b010;
localparam [7:0] CM_INT = 8'b10000000;

// -----------------------------------------------------------------------------
// Generate Variables
// -----------------------------------------------------------------------------
integer frame_count;
integer line_count;
integer byte_count;
integer k;
integer f;                             // file where writes DPHY_TX's input data

// -----------------------------------------------------------------------------
// Sequential Registers
// -----------------------------------------------------------------------------
reg [DATA_WIDTH-1:0]        byte_data_temp_r;
reg [1:0]                   fs_num_r;
reg [15:0]                  ls_num_r;
reg [15:0]                  crc_r;
reg [5:0]                   ecc_r;
reg [31:0]                  pkt_hdr_tmp_r; /// Changet to 31 from 23 CHECK
reg [23:0]                  hdr_tmp_r;
reg [15:0]                  crc_tmp_r;
reg [15:0]                  cur_crc_r;
reg [15:0]                  word_count_r;
reg                         clk_hs_en_r;
reg                         d_hs_en_r;
reg                         byte_data_en_r;
reg [DATA_WIDTH-1:0]        byte_data_r;
reg [15:0]                  wc_r;
reg [5:0]                   dt_r;
reg [1:0]                   vcx_r;
reg [1:0]                   vc_r;
reg                         eotp_r;
reg                         sp_en_r;
reg                         lp_en_r;
reg                         vsync_start_r;
reg                         hsync_start_r;
reg                         dphy_pkten_r;
reg [DATA_WIDTH-1:0]        dphy_pkt_r;
reg [LMMI_OFFSET_WIDTH-1:0] lmmi_offset_r;
reg [LMMI_DATA_WIDTH-1:0]   lmmi_wdata_r;
reg                         lmmi_wr_rdn_r;
reg                         lmmi_request_r;
reg                         EoT;
reg [31:0]                  tril_data_r      = 'd0;
reg [63:0]                  capet_data       = 'd0;
reg [15:0]                  num_bytes        = NUM_BYTES;
reg [7:0]                   lmmi_rdata_tmp_r = 0;
reg                         usrstdby_r       = 0;
reg                         footer_sant_r    = 0;
reg [3:0]                   tx_cil_word_valid_lane0_r;
reg [3:0]                   tx_cil_word_valid_lane1_r;
reg [3:0]                   tx_cil_word_valid_lane2_r;
reg [3:0]                   tx_cil_word_valid_lane3_r;
reg [NUM_TX_LANE-1:0]       line_disable_r;

// -----------------------------------------------------------------------------
// Assign Statements
// -----------------------------------------------------------------------------
assign clk_hs_en_o    = clk_hs_en_r;
assign d_hs_en_o      = d_hs_en_r;
assign wc_o           = wc_r;
assign dt_o           = dt_r;
assign vcx_o          = vcx_r;
assign vc_o           = vc_r;
assign eotp_o         = eotp_r;
assign sp_en_o        = sp_en_r;
assign lp_en_o        = lp_en_r;
assign vsync_start_o  = vsync_start_r;
assign hsync_start_o  = hsync_start_r;
assign lmmi_offset_o  = lmmi_offset_r;
assign lmmi_wdata_o   = lmmi_wdata_r;
assign lmmi_wr_rdn_o  = lmmi_wr_rdn_r;
assign lmmi_request_o = lmmi_request_r;
assign usrstdby_o     = usrstdby_r;
assign tx_cil_word_valid_lane0_o     = tx_cil_word_valid_lane0_r;
assign tx_cil_word_valid_lane1_o     = tx_cil_word_valid_lane1_r;
assign tx_cil_word_valid_lane2_o     = tx_cil_word_valid_lane2_r;
assign tx_cil_word_valid_lane3_o     = tx_cil_word_valid_lane3_r;
assign line_disable_o                = line_disable_r;



// -----------------------------------------------------------------------------
// Generate Assign Statements
// -----------------------------------------------------------------------------
generate
  if (PACKET_FORMATTER == "OFF") begin
    assign byte_or_pkt_data_o    = dphy_pkt_r;
    assign byte_or_pkt_data_en_o = dphy_pkten_r;
  end
  else begin
    assign byte_or_pkt_data_o    = byte_data_r;
    assign byte_or_pkt_data_en_o = byte_data_en_r;
  end
endgenerate

// -----------------------------------------------------------------------------
// Sequential Blocks
// -----------------------------------------------------------------------------
initial begin
  EoT = 0;
  f   = $fopen("tx_model_data.txt","w"); // file where writes DPHY_TX's input data
  @(posedge EoT);
  $fclose(f);
end

initial begin : INITIAL_ASSSIGNING
   ecc_r                     =  6'd0;
   crc_r                     = 16'hFFFF;
   fs_num_r                  =  2'd1;
   ls_num_r                  = 16'd1;
   frame_count               = 32'd0;
   line_count                = 32'd0;
   byte_count                = 32'd0;
   clk_hs_en_r               =  1'd0;
   d_hs_en_r                 =  1'd0;
   byte_data_en_r            =  1'd0;
   byte_data_r               = 64'd0;
   byte_data_temp_r          = 64'd0;
   vcx_r                     =  2'd0;
   vc_r                      =  2'd0;
   dt_r                      =  6'd0;
   wc_r                      = 16'd0;
   sp_en_r                   =  1'd0;
   lp_en_r                   =  1'd0;
   footer_sant_r             =     0;
   vsync_start_r             =  1'd0;
   hsync_start_r             =  1'd0;
   dphy_pkten_r              =  1'd0;
   dphy_pkt_r                = 64'd0;
   eotp_r                    =  1'd0;
   lmmi_offset_r             = {LMMI_OFFSET_WIDTH{1'd0}};
   lmmi_wdata_r              = {LMMI_DATA_WIDTH{1'd0}};
   lmmi_wr_rdn_r             = 1'd0;
   lmmi_request_r            = 1'd0;
   tx_cil_word_valid_lane0_r = (GEAR == 16)? 4'b0011 : 4'b0001;
   tx_cil_word_valid_lane1_r = (GEAR == 16)? 4'b0011 : 4'b0001;
   tx_cil_word_valid_lane2_r = (GEAR == 16)? 4'b0011 : 4'b0001;
   tx_cil_word_valid_lane3_r = (GEAR == 16)? 4'b0011 : 4'b0001;
   line_disable_r            = {NUM_TX_LANE{1'b0}};
end

// -----------------------------------------------------------------------------
// Tasks Declarations
// -----------------------------------------------------------------------------
task drive_video_data();
begin
if(PACKET_FORMATTER == "ON") begin
  if(DEVICE_TYPE == "DSI") begin //DSI format
    if (CIL_BYPASS == "CIL_BYPASSED") begin /// CIL_BYPASSED
      $display("%0t DSI TX, Packet formatter is enabled",$realtime);
      for(frame_count=0;frame_count<NUM_FRAMES;frame_count=frame_count+1) begin
        $display("%0t FRAME #%0d START",$realtime,frame_count+1);
        //drive vsync
        ///
        if (NUM_BYTES_INCREMENT == "ON") begin
        num_bytes = num_bytes + 1;
        end
        ///
		wait4ready;
        drive_vsync_st; wait4ready;
  
        //drive hsync
        repeat(HSYNC_PULSE_FRONT-1) begin
          drive_hsync_st; wait4ready;
        end
  
        for(line_count=0;line_count<NUM_LINES;line_count=line_count+1) begin
          drive_hsync_st; wait4ready;
  
          repeat(HS_RDY_TO_BYTE_DATA_EN_DLY) begin
            wait_clock_edge;
          end
  
          drive_hs_req;
  
          ///
          while (!d_hs_rdy_i) begin
            @(posedge ref_clk_i);
          end
          ///
  
          repeat(HS_RDY_TO_BYTE_DATA_EN_DLY) begin
            wait_clock_edge;
          end
          
          dt_r <= DATA_TYPE;
          wc_r <= num_bytes;
          drive_byte; wait4ready;
        end
  
        //drive hsync
        repeat(HSYNC_PULSE_BACK-1) begin
          drive_hsync_st; wait4ready;
        end
        $display("%0t FRAME #%0d END",$realtime,frame_count+1);
      end
    end
    else if (CIL_BYPASS == "CIL_ENABLED") begin /// CIL_ENABLED
      $display("%0t DSI TX, Packet formatter is enabled",$realtime);
      for(frame_count=0;frame_count<NUM_FRAMES;frame_count=frame_count+1) begin
        $display("%0t FRAME #%0d START",$realtime,frame_count+1);
        ///
        if (NUM_BYTES_INCREMENT == "ON") begin
        num_bytes = num_bytes + 1;
        end
        ///
        ///
		wait4ready; 
        drive_vsync_st_cil; wait4ready;
        ///
        repeat(HSYNC_PULSE_FRONT-1) begin
          drive_hsync_st_cil; wait4ready;
        end
        ///
        for(line_count=0;line_count<NUM_LINES;line_count=line_count+1) begin
          drive_hsync_st_cil; wait4ready;
          ///
          if(DEBUG_ON == "ON") $display("%0t drive_hs_req START",$realtime);
          ///
          // #2000;
          drive_byte_cil; wait4ready;
        end
        ///
        repeat(HSYNC_PULSE_BACK-1) begin
          drive_hsync_st_cil; wait4ready;
        end
        $display("%0t FRAME #%0d END",$realtime,frame_count+1);
      end
    end
  end
  else begin //CSI2 format
    if (CIL_BYPASS == "CIL_BYPASSED") begin
      $display("%0t CSI2 TX, Packet formatter is enabled",$realtime);
      for(frame_count=0;frame_count<NUM_FRAMES;frame_count=frame_count+1) begin
        $display("%0t FRAME #%0d START",$realtime,frame_count+1);
        ///
        if (NUM_BYTES_INCREMENT == "ON") begin
        num_bytes = num_bytes + 1;
        end
        ///
        //drive FS
		wait4ready; 
        drive_sp(6'h00); wait4ready;
  
        for(line_count=0;line_count<NUM_LINES;line_count=line_count+1) begin
          if(LS_LE_EN == "ON") begin//drive LS
            drive_sp(6'h02); wait4ready;
          end
          drive_lp;
          repeat(LP_EN_TO_BYTE_DATA_EN_DLY) begin
            wait_clock_edge;
          end
          drive_byte; wait4ready;
          if(LS_LE_EN == "ON") begin//drive LE
            drive_sp(6'h03); wait4ready;
          end
        end
        drive_sp(6'h01);  wait4ready;//drive FE
        $display("%0t FRAME #%0d END",$realtime,frame_count+1);
      end
    end
    else if (CIL_BYPASS == "CIL_ENABLED") begin
      $display("%0t CSI2 TX, Packet formatter is enabled",$realtime);
      for(frame_count=0;frame_count<NUM_FRAMES;frame_count=frame_count+1) begin
        $display("%0t FRAME #%0d START",$realtime,frame_count+1);
        //drive FS
        //
        if (NUM_BYTES_INCREMENT == "ON") begin
        num_bytes = num_bytes + 1;
        end
        //
		wait4ready; 
        drive_sp_cil(6'h00); wait4ready;
  
        for(line_count=0;line_count<NUM_LINES;line_count=line_count+1) begin
          if(LS_LE_EN == "ON") begin//drive LS
            drive_sp_cil(6'h02);  wait4ready;
          end
          ///
          drive_byte_cil;  wait4ready;
          ///
          if(LS_LE_EN == "ON") begin//drive LE
            drive_sp_cil(6'h03);  wait4ready;
          end
        end
        drive_sp_cil(6'h01); wait4ready; //drive FE
        $display("%0t FRAME #%0d END",$realtime,frame_count+1);
      end
    end
  end
end
else begin //without packet formatter
  if(DEVICE_TYPE == "DSI") begin //DSI
    if (CIL_BYPASS == "CIL_BYPASSED") begin
      $display("%0t DSI TX, Packet formatter is disabled",$realtime);
      for(frame_count=0;frame_count<NUM_FRAMES;frame_count=frame_count+1) begin
        $display("%0t FRAME #%0d START",$realtime,frame_count+1);
        ///
        if (NUM_BYTES_INCREMENT == "ON") begin
        num_bytes = num_bytes + 1;
        end
        ///
        //drive vsync
        drive_spkt(6'h01); wait4ready;
  
        //drive hsync
        repeat(HSYNC_PULSE_FRONT-1) begin
          drive_spkt(6'h21); wait4ready;
        end
  
        for(line_count=0;line_count<NUM_LINES;line_count=line_count+1) begin
          drive_spkt(6'h21); wait4ready;
  
          repeat(HS_RDY_TO_DPHY_PKTEN_DLY) begin
            wait_clock_edge; wait4ready;
          end
  
          drive_lpkt;
        end
  
        //drive hsync
        repeat(HSYNC_PULSE_BACK-1) begin
          drive_spkt(6'h21); wait4ready;
        end
        $display("%0t FRAME #%0d END",$realtime,frame_count+1);
      end
    end
    else begin
      $display("%0t DSI TX, Packet formatter is disabled",$realtime);
      for(frame_count=0;frame_count<NUM_FRAMES;frame_count=frame_count+1) begin
        $display("%0t FRAME #%0d START",$realtime,frame_count+1);
        ///
        if (NUM_BYTES_INCREMENT == "ON") begin
        num_bytes = num_bytes + 1;
        end
        ///
        //drive vsync
        drive_spkt_CIL_t(6'h01); wait4ready;
  
        //drive hsync
        repeat(HSYNC_PULSE_FRONT-1) begin
          drive_spkt_CIL_t(6'h21); wait4ready;
        end
  
        for(line_count=0;line_count<NUM_LINES;line_count=line_count+1) begin
          drive_spkt_CIL_t(6'h21); wait4ready;
  
          repeat(HS_RDY_TO_DPHY_PKTEN_DLY) begin
            wait_clock_edge;
          end
  
          drive_lpkt_CIL_t; wait4ready;
          wait4ready_cil;
        end
  
        //drive hsync
        repeat(HSYNC_PULSE_BACK-1) begin
          drive_spkt_CIL_t(6'h21); wait4ready;
        end
        $display("%0t FRAME #%0d END",$realtime,frame_count+1);
      end
    
    end
  end
  else begin //CSI2
    if (CIL_BYPASS == "CIL_BYPASSED") begin
      $display("%0t CSI2 TX, Packet formatter is disabled",$realtime);
      for(frame_count=0;frame_count<NUM_FRAMES;frame_count=frame_count+1) begin
        $display("%0t FRAME #%0d START",$realtime,frame_count+1);
        ///
        if (NUM_BYTES_INCREMENT == "ON") begin
        num_bytes = num_bytes + 1;
        end
        ///
        //drive FS
        drive_spkt(6'h00); wait4ready;

        crc_r=16'hFFFF; //reset_i crc_r
        for(line_count=0;line_count<NUM_LINES;line_count=line_count+1) begin
          if(LS_LE_EN == "ON") begin//drive LS
            drive_spkt(6'h02); wait4ready;
          end
          repeat(HS_RDY_TO_DPHY_PKTEN_DLY) begin
            wait_clock_edge;
          end
          drive_lpkt; wait4ready;
          if(LS_LE_EN == "ON") begin//drive LE
            drive_spkt(6'h03); wait4ready;
          end
        end
        drive_spkt(6'h01); wait4ready; //drive FE
        $display("%0t FRAME #%0d END",$realtime,frame_count+1);
      end
    end
    else begin :CIL_CSI2_CONTROL
      $display("%0t CSI2 TX with CIL, Packet formatter is disabled",$realtime);
      for(frame_count=0;frame_count<NUM_FRAMES;frame_count=frame_count+1) begin
        $display("%0t FRAME #%0d START",$realtime,frame_count+1);
        ///
        if (NUM_BYTES_INCREMENT == "ON") begin
        num_bytes = num_bytes + 1;
        end
        ///
        //drive FS
        drive_spkt_CIL_t(6'h00); wait4ready;

        crc_r=16'hFFFF; //reset_i crc_r
        for(line_count=0;line_count<NUM_LINES;line_count=line_count+1) begin
          if(LS_LE_EN == "ON") begin//drive LS
            drive_spkt_CIL_t(6'h02); wait4ready;
          end
          repeat(HS_RDY_TO_DPHY_PKTEN_DLY) begin
            wait_clock_edge;
          end
          drive_lpkt_CIL_t;  wait4ready;
          wait4ready_cil;
          if(LS_LE_EN == "ON") begin//drive LE
            drive_spkt_CIL_t(6'h03); wait4ready;
          end
        end
        drive_spkt_CIL_t(6'h01); wait4ready;//drive FE
        $display("%0t FRAME #%0d END",$realtime,frame_count+1);
      end
    end
  end
end
end
endtask

task change_PLL_freq();
  begin
    usrstdby_r         = 1;
    #1000;
    lmmi_read(8'd4);
    @(posedge lmmi_clk_i);
    lmmi_write(8'd4,{4'd0,CN_INT[0],lmmi_rdata_tmp_r[2:0]});
    lmmi_write(8'd5,{4'd0,CN_INT[4:1]});
    lmmi_write(8'd6,{4'd0,CM_INT[3:0]});
    lmmi_write(8'd7,{4'd0,CM_INT[7:4]});
    lmmi_read(8'd8);
    @(posedge lmmi_clk_i);
    lmmi_write(8'd8,{4'd0,lmmi_rdata_tmp_r[3],CO_INT[2:0]});
    usrstdby_r         = 0;
  end
endtask

task drive_hs_req();
begin
  if(DEBUG_ON == "ON")
    $display("%0t drive_hs_req START",$realtime);
  repeat(D_HS_RDY_TO_D_HS_CLK_EN_DLY) begin
    wait_clock_edge;
  end
  if (CIL_BYPASS == "CIL_ENABLED") begin
    while(d_hs_rdy_i == 1'd0) begin
      #1;
    end
  end
  // HEADER-short packet
  // dt_r <= DATA_TYPE;
  // wc_r <= num_bytes; 
  // HEADER-short packet
  d_hs_en_r   <= 1;
  clk_hs_en_r <= 1;
  repeat(5) begin
    wait_clock_edge;
  end
  d_hs_en_r   <= 0;
  clk_hs_en_r <= 0;
  if(DEBUG_ON == "ON")
    $display("%0t drive_hs_req END",$realtime);
end
endtask

task display_data(input [DATA_WIDTH-1:0] disp);
begin
  if(DEBUG_ON == "ON")
    $display("%0t data = %0h",$realtime,disp);
end
endtask

// localparam SYNC_CHAR = (GEAR == 16)? 16'h00B8 : 8'hB8
task drive_lpkt(); /// 
begin
  $display("%0t Transmitting video data data type : %0h , word count = %0d ...",$realtime,DATA_TYPE,num_bytes);
    if(DEBUG_ON == "ON") $display("%0t drive_lpkt START",$realtime);
    ///////////////////////////////////////////////////////////////////////////
    /// Init
    ///////////////////////////////////////////////////////////////////////////
  crc_tmp_r            =0;
  word_count_r         = num_bytes;
  pkt_hdr_tmp_r[5:0]   = DATA_TYPE;
  pkt_hdr_tmp_r[7:6]   = VIRTUAL_CHANNEL;
  pkt_hdr_tmp_r[15:8]  = word_count_r[7:0];
  pkt_hdr_tmp_r[23:16] = word_count_r[15:8];
  compute_ecc(pkt_hdr_tmp_r,ecc_r);
    pkt_hdr_tmp_r[31:24] = ecc_r;
    ///////////////////////////////////////////////////////////////////////////
    /// Request and Wait
    ///////////////////////////////////////////////////////////////////////////
  drive_hs_req;
    if (CIL_BYPASS == "CIL_BYPASSED") begin @(posedge d_hs_rdy_i); end

    repeat(HS_RDY_TO_LP_EN_DLY) begin wait_clock_edge; end

  if (GEAR == 16) begin
      ///////////////////////////////////////////////////////////////////////////
      /// GEAR 16
      ///////////////////////////////////////////////////////////////////////////
      ///////////////////////////////////////////////////////////////////////////
      /// Sync char and header
      ///////////////////////////////////////////////////////////////////////////
      dphy_pkten_r         = 1;

      if (NUM_TX_LANE == 4) begin
      dphy_pkt_r           = {
                              pkt_hdr_tmp_r[31:24],8'hB8,
                              pkt_hdr_tmp_r[23:16],8'hB8,
                              pkt_hdr_tmp_r[15: 8],8'hB8,
                              pkt_hdr_tmp_r[ 7: 0],8'hB8
                               }; wait_clock_edge;
      end else
      if (NUM_TX_LANE == 3) begin
      dphy_pkt_r           = {
                              pkt_hdr_tmp_r[23:16],8'hB8,
                              pkt_hdr_tmp_r[15: 8],8'hB8,
                              pkt_hdr_tmp_r[ 7: 0],8'hB8
                               }; wait_clock_edge;
      dphy_pkt_r           = { 
                              8'h00,8'h00,
                              8'h00,8'h00,
                              8'h00,pkt_hdr_tmp_r[31:24]
                              }; wait_clock_edge;
      end else
      if (NUM_TX_LANE == 2) begin
      dphy_pkt_r           = {
                              16'hB800,
                              16'hB800
                               }; wait_clock_edge;
      dphy_pkt_r           = { pkt_hdr_tmp_r[31:24], pkt_hdr_tmp_r[15: 8],
                               pkt_hdr_tmp_r[23:16], pkt_hdr_tmp_r[ 7: 0]
                              }; wait_clock_edge;
      end else
      if (NUM_TX_LANE == 1) begin
      dphy_pkt_r           = {
                              16'hB800
                               }; wait_clock_edge;
      dphy_pkt_r           = { pkt_hdr_tmp_r[15: 0]
                              }; wait_clock_edge;
      dphy_pkt_r           = { pkt_hdr_tmp_r[31:16]
                              }; wait_clock_edge;
  end
      ///////////////////////////////////////////////////////////////////////////
      /// Payload
      ///////////////////////////////////////////////////////////////////////////
  byte_count=0;
      while((byte_count < num_bytes) && (num_bytes - byte_count >= 2*NUM_TX_LANE)) begin
        //////////////////////////
        /// Creating random data
        //////////////////////////
    byte_data_temp_r = $random;
        //////////////////////////
        /// Writing data into file
        //////////////////////////
        if (NUM_TX_LANE == 4) begin
          $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],
                                                               byte_data_temp_r[23:16],
                                                               byte_data_temp_r[39:32],
                                                               byte_data_temp_r[55:48],
                                                               byte_data_temp_r[15: 8],
                                                               byte_data_temp_r[31:24],
                                                               byte_data_temp_r[47:40],
                                                               byte_data_temp_r[63:56]);
        end else
        if (NUM_TX_LANE == 3) begin
          $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],
                                                     byte_data_temp_r[23:16],
                                                     byte_data_temp_r[39:32],
                                                     byte_data_temp_r[15: 8],
                                                     byte_data_temp_r[31:24],
                                                     byte_data_temp_r[47:40]);
        end else
        if (NUM_TX_LANE == 2) begin
          $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],
                                           byte_data_temp_r[23:16],
                                           byte_data_temp_r[15:8],
                                           byte_data_temp_r[31:24]);
        end else
        if (NUM_TX_LANE == 1) begin
          $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],
                                 byte_data_temp_r[15:8]);
        end
        //////////////////////////
        /// Sending data
        //////////////////////////
        display_data(dphy_pkt_r);
        byte_count         = byte_count + 2*NUM_TX_LANE;
        dphy_pkt_r         = byte_data_temp_r;       wait_clock_edge;
        //////////////////////////
        /// CRC calculation
        //////////////////////////
          compute_crc(dphy_pkt_r[7:0]);
          compute_crc(dphy_pkt_r[15:8]);
        if (NUM_TX_LANE > 1) begin
          compute_crc(dphy_pkt_r[23:16]);
          compute_crc(dphy_pkt_r[31:24]);
        end
        if (NUM_TX_LANE > 2) begin
          compute_crc(dphy_pkt_r[39:32]);
          compute_crc(dphy_pkt_r[47:40]);
          compute_crc(dphy_pkt_r[55:48]);
          compute_crc(dphy_pkt_r[63:56]);
        end
      end
      ///////////////////////////////////////////////////////////////////////////
      /// Additional bytes of Payload, CRC and EOTp(if needed)
      ///////////////////////////////////////////////////////////////////////////
      if ((num_bytes - byte_count) < 2*NUM_TX_LANE && (num_bytes - byte_count) != 0) begin
        //////////////////////////
        /// Creating random data
        //////////////////////////
        byte_data_temp_r   = $random;
        //////////////////////////
        /// Payload, crc and EOTp
        //////////////////////////
        if (NUM_TX_LANE == 4) begin
          if (num_bytes - byte_count == 7) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {crc_r[7:0],byte_data_temp_r[55:0]};                                                                         wait_clock_edge;
              dphy_pkt_r   = {{8{!eotp[23]}},eotp[23:16],{8{!eotp[15]}},eotp[15:8],{8{!eotp[7]}},eotp[7:0],eotp[31:24],crc_r[15:8]};                                       wait_clock_edge;
              dphy_pkt_r   = {{16{!eotp[23]}},{16{!eotp[15]}},{16{!eotp[7]}},{16{!eotp[31]}}};                                                                                wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = { crc_r[ 7:0],                 byte_data_temp_r[55:48],
                               byte_data_temp_r[47:40],     byte_data_temp_r[39:32],
                               byte_data_temp_r[31:24],     byte_data_temp_r[23:16],
                               byte_data_temp_r[15: 8],     byte_data_temp_r[ 7: 0]};wait_clock_edge;
              dphy_pkt_r   = {{16{!dphy_pkt_r[63]}},
                              {16{!dphy_pkt_r[47]}},
                              {16{!dphy_pkt_r[31]}},
                              {8{!crc_r[15]}},crc_r[15:8]};      wait_clock_edge;
              dphy_pkt_r   = {{16{ dphy_pkt_r[63]}},
                              {16{ dphy_pkt_r[47]}},
                              {16{ dphy_pkt_r[31]}},
                              {16{ dphy_pkt_r[15]}}};             wait_clock_edge;
            end
            $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n%h\n", byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],
                                                  byte_data_temp_r[39:32],byte_data_temp_r[55:48],
                                                  byte_data_temp_r[15: 8],byte_data_temp_r[31:24],
                                                  byte_data_temp_r[47:40]);
          end else
          if (num_bytes - byte_count == 6) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {crc_r[15:8],byte_data_temp_r[55:48],crc_r[7:0],byte_data_temp_r[39:0]};                                                                         wait_clock_edge;
              dphy_pkt_r   = {{8{!eotp[31]}},eotp[31:24],{8{!eotp[23]}},eotp[23:16],{8{!eotp[15]}},eotp[15:8],{8{!eotp[7]}},eotp[7:0]};                                       wait_clock_edge;
              dphy_pkt_r   = {{16{!eotp[31]}},{16{!eotp[23]}},{16{!eotp[15]}},{16{!eotp[7]}}};                                                                                wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = { crc_r[15:8],                 byte_data_temp_r[55:48],
                               crc_r[ 7:0],                 byte_data_temp_r[39:32],
                               byte_data_temp_r[31:24],     byte_data_temp_r[23:16],
                               byte_data_temp_r[15:8],      byte_data_temp_r[ 7: 0]};wait_clock_edge;
              dphy_pkt_r   = {{16{!dphy_pkt_r[63]}},
                              {16{!dphy_pkt_r[47]}},
                              {16{!dphy_pkt_r[31]}},
                              {16{!dphy_pkt_r[15]}}};      wait_clock_edge;
            end
            $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n", byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],
                                                        byte_data_temp_r[39:32],byte_data_temp_r[55:48],
                                                        byte_data_temp_r[15: 8],byte_data_temp_r[31:24]);
          end else
          if (num_bytes - byte_count == 5) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {eotp[7:0],byte_data_temp_r[55:48],crc_r[15:8],byte_data_temp_r[39:32],crc_r[7:0],byte_data_temp_r[23:0]};                                       wait_clock_edge;
              dphy_pkt_r   = {{16{!eotp[7]}},{8{!eotp[31]}},eotp[31:24],{8{!eotp[23]}},eotp[23:16],{8{!eotp[15]}},eotp[15:8]};                                                wait_clock_edge;
              dphy_pkt_r   = {{16{!eotp[7]}},{16{!eotp[31]}},{16{!eotp[23]}},{16{!eotp[15]}}};                                                                                wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = { {8{!byte_data_temp_r[55]}},  byte_data_temp_r[55:48],
                               crc_r[15:8],                 byte_data_temp_r[39:32],
                               crc_r[ 7:0],                 byte_data_temp_r[23:16],
                               byte_data_temp_r[15:8],      byte_data_temp_r[7:0]};wait_clock_edge;
              dphy_pkt_r   = {{16{ dphy_pkt_r[63]}},
                              {16{!dphy_pkt_r[47]}},
                              {16{!dphy_pkt_r[31]}},
                              {16{!dphy_pkt_r[15]}}};      wait_clock_edge;
            end
            $fwrite(f,"%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],
                                      byte_data_temp_r[39:32],byte_data_temp_r[55:48],
                                      byte_data_temp_r[15: 8]);
          end else
          if (num_bytes - byte_count == 4) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {eotp[15:8],byte_data_temp_r[55:48],eotp[7:0],byte_data_temp_r[39:32],crc_r[15:8],byte_data_temp_r[23:16],crc_r[7:0],byte_data_temp_r[7:0]};     wait_clock_edge;
              dphy_pkt_r   = {{16{!eotp[15]}},{16{!eotp[7]}},{8{!eotp[31]}},eotp[31:24],{8{!eotp[23]}},eotp[23:16]};                                                          wait_clock_edge;
              dphy_pkt_r   = {{16{!eotp[15]}},{16{!eotp[7]}},{16{!eotp[31]}},{16{!eotp[23]}}};                                                                                wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = { {8{!byte_data_temp_r[55]}},  byte_data_temp_r[55:48],
                               {8{!byte_data_temp_r[39]}},  byte_data_temp_r[39:32],
                               crc_r[15:8],                 byte_data_temp_r[23:16],
                               crc_r[7:0],                  byte_data_temp_r[7:0]};wait_clock_edge;
              dphy_pkt_r   = {{16{ dphy_pkt_r[63]}},
                              {16{ dphy_pkt_r[47]}},
                              {16{!dphy_pkt_r[31]}},
                              {16{!dphy_pkt_r[15]}}};      wait_clock_edge;
            end
            $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[55:48]);
          end else
          if (num_bytes - byte_count == 3) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              compute_crc(dphy_pkt_r[7:0]);
              dphy_pkt_r   = {eotp[23:16],crc_r[7:0],eotp[15:8],byte_data_temp_r[39:32],eotp[7:0],byte_data_temp_r[23:16],crc_r[15:8],byte_data_temp_r[7:0]};     wait_clock_edge;
              dphy_pkt_r   = {{16{!eotp[23]}},{16{!eotp[15]}},{16{!eotp[7]}},{8{!eotp[31]}},eotp[31:24]};                                                         wait_clock_edge;
              dphy_pkt_r   = {{16{!eotp[23]}},{16{!eotp[15]}},{16{!eotp[7]}},{16{!eotp[31]}}};                                                                    wait_clock_edge;
              // dphy_pkt_r   = {{8{ dphy_pkt_r[31]}},{8{ dphy_pkt_r[23]}},{8{ dphy_pkt_r[15]}},{8{!dphy_pkt_r[7]}}};                                                wait_clock_edge;
            end
            else begin        
              dphy_pkt_r   = { {8{!crc_r[7]}},            crc_r[7:0],
                               {8{!byte_data_temp_r[39]}},byte_data_temp_r[39:32],
                               {8{!byte_data_temp_r[23]}},byte_data_temp_r[23:16],
                               crc_r[15:8],               byte_data_temp_r[7:0]};wait_clock_edge;
              dphy_pkt_r   = {{16{ dphy_pkt_r[63]}},
                              {16{ dphy_pkt_r[47]}},
                              {16{ dphy_pkt_r[31]}},
                              {16{!crc_r[15]}}};      wait_clock_edge;
            end
            $fwrite(f,"%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[39:32]);
          end else
          if (num_bytes - byte_count == 2) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {eotp[31:24],crc_r[15:8],eotp[23:16],crc_r[7:0],eotp[15:8],byte_data_temp_r[23:16],eotp[7:0],byte_data_temp_r[7:0]};       wait_clock_edge;
              dphy_pkt_r   = {{16{!eotp[31]}},{16{!eotp[23]}},{16{!eotp[15]}},{16{!eotp[7]}}};                                                         wait_clock_edge;
              // dphy_pkt_r   = {{8{!dphy_pkt_r[31]}},{8{!dphy_pkt_r[23]}},{8{!dphy_pkt_r[15]}},{8{!dphy_pkt_r[7]}}};                                      wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = { {8{!crc_r[15]}},crc_r[15:8],
                               {8{!crc_r[7]}},crc_r[7:0],
                               {8{!byte_data_temp_r[23]}},byte_data_temp_r[23:16],
                               {8{!byte_data_temp_r[7]}},byte_data_temp_r[7:0]}; wait_clock_edge;
              dphy_pkt_r   = {{16{ dphy_pkt_r[63]}},
                              {16{ dphy_pkt_r[47]}},
                              {16{ dphy_pkt_r[31]}},
                              {16{ dphy_pkt_r[15]}}};      wait_clock_edge;
            end
            $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16]);
          end else
          if (num_bytes - byte_count == 1) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {{8{!eotp[7]}},eotp[7:0],eotp[31:24],crc_r[15:8],eotp[23:16],crc_r[7:0],eotp[15:8],byte_data_temp_r[7:0]};    wait_clock_edge;
              dphy_pkt_r   = {{16{!eotp[7]}},{16{!eotp[31]}},{16{!eotp[23]}},{16{!eotp[15]}}};                                                   wait_clock_edge;
              // dphy_pkt_r   = {{8{ dphy_pkt_r[31]}},{8{!dphy_pkt_r[23]}},{8{!dphy_pkt_r[15]}},{8{!dphy_pkt_r[7]}}};                      wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = {{16{!dphy_pkt_r[53]}},
                               {8{!crc_r[15]}},crc_r[15:8],
                               {8{!crc_r[7]}},crc_r[7:0],
                               {8{!byte_data_temp_r[7]}},byte_data_temp_r[7:0]};wait_clock_edge;
              dphy_pkt_r   = {{16{ dphy_pkt_r[53]}},
                              {16{ dphy_pkt_r[47]}},
                              {16{ dphy_pkt_r[31]}},
                              {16{ dphy_pkt_r[15]}}};      wait_clock_edge;
            end
            $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
          end
        end else
        if (NUM_TX_LANE == 3) begin
          if (num_bytes - byte_count == 5) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {
                                crc_r[7:0]             ,byte_data_temp_r[39:32]
                               ,byte_data_temp_r[31:24],byte_data_temp_r[23:16]
                               ,byte_data_temp_r[15: 8],byte_data_temp_r[7:0]};  wait_clock_edge;
              dphy_pkt_r   = {
                                {8{!eotp[15]}},eotp[15:8]
                               ,eotp[31:24]   ,eotp[7:0]
                               ,eotp[23:16]   ,crc_r[15:8]};                     wait_clock_edge;
              dphy_pkt_r   = {{16{!eotp[15]}},{16{!eotp[31]}},{16{!eotp[23]}}};  wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = {
                                crc_r[7:0]             ,byte_data_temp_r[39:32]
                               ,byte_data_temp_r[31:24],byte_data_temp_r[23:16]
                               ,byte_data_temp_r[15: 8],byte_data_temp_r[7:0]};  wait_clock_edge;
              dphy_pkt_r   = {
                                {16{!crc_r[7]}}
                               ,{16{!byte_data_temp_r[39]}}
                               ,{8{!crc_r[15]}},crc_r[15:8]};                     wait_clock_edge;
            end
            $fwrite(f,"%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],
                                      byte_data_temp_r[39:32],byte_data_temp_r[15: 8],byte_data_temp_r[31:24]);
          end else
          if (num_bytes - byte_count == 4) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {
                                crc_r[15:8]            ,byte_data_temp_r[39:32]
                               ,crc_r[7:0]             ,byte_data_temp_r[23:16]
                               ,byte_data_temp_r[15: 8],byte_data_temp_r[7:0]};  wait_clock_edge;
              dphy_pkt_r   = {
                                {8{!eotp[23]}},eotp[23:16]
                               ,{8{!eotp[15]}},eotp[15:8]
                               ,eotp[31:24]   ,eotp[7:0]};                     wait_clock_edge;
              dphy_pkt_r   = {{16{!eotp[23]}},{16{!eotp[15]}},{16{!eotp[31]}}};  wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = {
                                crc_r[15:8]            ,byte_data_temp_r[39:32]
                               ,crc_r[7:0]             ,byte_data_temp_r[23:16]
                               ,byte_data_temp_r[15: 8],byte_data_temp_r[7:0]};  wait_clock_edge;
              dphy_pkt_r   = {{16{!crc_r[15]}}
                              ,{16{!crc_r[7]}}
                              ,{16{!byte_data_temp_r[15]}}};      wait_clock_edge;
            end
            $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[15:8]);
          end else
          if (num_bytes - byte_count == 3) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {
                                eotp[7:0]  ,byte_data_temp_r[39:32]
                               ,crc_r[15:8],byte_data_temp_r[23:16]
                               ,crc_r[7:0] ,byte_data_temp_r[7:0]};  wait_clock_edge;
              dphy_pkt_r   = {
                                {8{!eotp[31]}},eotp[31:24]
                               ,{8{!eotp[23]}},eotp[23:16]
                               ,{8{!eotp[15]}},eotp[15:8]};          wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = {
                                {8{!byte_data_temp_r[39]}},byte_data_temp_r[39:32]
                               ,crc_r[15:8]               ,byte_data_temp_r[23:16]
                               ,crc_r[7:0]                ,byte_data_temp_r[7:0]};  wait_clock_edge;
              dphy_pkt_r   = {{16{!byte_data_temp_r[39]}}
                             ,{16{!crc_r[15]}}
                             ,{16{!crc_r[7]}}};      wait_clock_edge;
            end
            $fwrite(f,"%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[39:32]);
          end else
          if (num_bytes - byte_count == 2) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {
                                eotp[15:8] ,crc_r[7:0] 
                               ,eotp[7:0]  ,byte_data_temp_r[23:16]
                               ,crc_r[15:8],byte_data_temp_r[7:0]};  wait_clock_edge;
              dphy_pkt_r   = {
                                {16{!eotp[15]}}
                               ,{8{!eotp[31]}},eotp[31:24]
                               ,{8{!eotp[23]}},eotp[23:16]};          wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = {
                                {8{!crc_r[7]}}            ,crc_r[7:0] 
                               ,{8{!byte_data_temp_r[23]}},byte_data_temp_r[23:16]
                               ,crc_r[15:8]               ,byte_data_temp_r[7:0]};  wait_clock_edge;
              dphy_pkt_r   = {{16{!crc_r[7]}},
                              {16{!byte_data_temp_r[23]}},
                              {16{!crc_r[15]}}};      wait_clock_edge;
            end
            $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16]);
          end else
          if (num_bytes - byte_count == 1) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {
                                eotp[23:16],crc_r[15:8] 
                               ,eotp[15:8] ,crc_r[7:0]
                               ,eotp[7:0]  ,byte_data_temp_r[7:0]};  wait_clock_edge;
              dphy_pkt_r   = {
                                {16{!eotp[23]}}
                               ,{16{!eotp[15]}}
                               ,{8{!eotp[31]}},eotp[31:24]};         wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = {
                                {8{!crc_r[15]}}          ,crc_r[15:8] 
                               ,{8{!crc_r[7]}}           ,crc_r[7:0]
                               ,{8{!byte_data_temp_r[7]}},byte_data_temp_r[7:0]};  wait_clock_edge;
            end
            $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
          end
        end else
        if (NUM_TX_LANE == 2) begin
          if (num_bytes - byte_count == 3) begin
          compute_crc(dphy_pkt_r[7:0]);
          compute_crc(dphy_pkt_r[23:16]);
            compute_crc(dphy_pkt_r[15: 8]);
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
             dphy_pkt_r     = { crc_r[7:0],             byte_data_temp_r[23:16],
                                byte_data_temp_r[15:8], byte_data_temp_r[7:0]
                               };                                                                                       wait_clock_edge;      
              dphy_pkt_r   = {eotp[23:16],eotp[7:0],
                              eotp[15:8],crc_r[15:8]};                                                                  wait_clock_edge;
              dphy_pkt_r   = {{8{!dphy_pkt_r[31]}},{8{!dphy_pkt_r[31]}},
                                {8{!eotp[31]}},     eotp[31:24]};                                                      wait_clock_edge;
              dphy_pkt_r   = {{8{ dphy_pkt_r[31]}},{8{ dphy_pkt_r[23]}},
                              {8{ dphy_pkt_r[31]}},{8{ dphy_pkt_r[31]}}};                                                wait_clock_edge;
        end
            else begin        
             dphy_pkt_r     = { crc_r[7:0],             byte_data_temp_r[23:16],
                                byte_data_temp_r[15:8], byte_data_temp_r[7:0]
                               }; wait_clock_edge;      
            dphy_pkt_r     = {{8{ dphy_pkt_r[63]}},{8{ dphy_pkt_r[63]}},
                              {8{ dphy_pkt_r[47]}},{8{ dphy_pkt_r[47]}},
                              {8{!dphy_pkt_r[31]}},{8{!dphy_pkt_r[31]}},
                              {8{!dphy_pkt_r[47]}},{8{!dphy_pkt_r[15]}}
                              }; wait_clock_edge;     
          compute_crc(dphy_pkt_r[7:0]);
              dphy_pkt_r   = {crc_r[7:0],byte_data_temp_r[23:0]};                                                       wait_clock_edge;
              dphy_pkt_r   = {{8{!dphy_pkt_r[31]}},{8{!dphy_pkt_r[23]}},{8{!dphy_pkt_r[15]}},crc_r[15:8]};              wait_clock_edge;
              dphy_pkt_r   = {{8{ dphy_pkt_r[31]}},{8{ dphy_pkt_r[23]}},{8{ dphy_pkt_r[15]}},{8{!crc_r[15]}}};          wait_clock_edge;
            end
            $fwrite(f,"%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[15:8]);
          end else
          if (num_bytes - byte_count == 2) begin
            compute_crc(dphy_pkt_r[7:0]);
          compute_crc(dphy_pkt_r[23:16]);
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {crc_r[15:8],byte_data_temp_r[23:16],crc_r[7:0],byte_data_temp_r[7:0]};                    wait_clock_edge;
              dphy_pkt_r   = {eotp[31:24],eotp[15:8],eotp[23:16],eotp[7:0]};                                                        wait_clock_edge;
              dphy_pkt_r   = {{16{!eotp[31]}},{16{!eotp[23]}}};                                                        wait_clock_edge;
        end
            else begin
              dphy_pkt_r   = {crc_r[15:8],byte_data_temp_r[23:16],crc_r[7:0],byte_data_temp_r[7:0]};                    wait_clock_edge;
              dphy_pkt_r   = {{16{!crc_r[15]}},{16{!crc_r[7]}}};                                                        wait_clock_edge;
      end
            $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16]);
          end else
          if (num_bytes - byte_count == 1) begin
            compute_crc(dphy_pkt_r[7:0]);
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {eotp[7:0],            crc_r[7:0],
                              crc_r[15:8],          byte_data_temp_r[7:0]};                                             wait_clock_edge;
              dphy_pkt_r   = {{8{!eotp[23]}},       eotp[23:16],
                                  eotp[31:24],      eotp[15:8]};                                                         wait_clock_edge;
              dphy_pkt_r   = {{16{ dphy_pkt_r[31]}},
                              {16{!dphy_pkt_r[15]}}};      wait_clock_edge;
  end
            else begin
              dphy_pkt_r   = {{8{!crc_r[7]}},crc_r[7:0],
                                  crc_r[15:8],byte_data_temp_r[7:0]};                                                   wait_clock_edge;
              dphy_pkt_r   = {{16{ dphy_pkt_r[31]}},
                              {16{!crc_r[15]}}};      wait_clock_edge;
            end
        $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
      end
        end else
        if (NUM_TX_LANE == 1) begin
          compute_crc(dphy_pkt_r[7:0]);
          if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
            dphy_pkt_r     = {crc_r[7:0],byte_data_temp_r[7:0]};                                                        wait_clock_edge;
            dphy_pkt_r     = {eotp[7:0],     crc_r[15:8]};                                                              wait_clock_edge;
            dphy_pkt_r     = {eotp[23:16],   eotp[15:8]};                                                               wait_clock_edge;
            dphy_pkt_r     = {{8{!eotp[31]}},eotp[31:24]};                                                              wait_clock_edge;
            dphy_pkt_r     = {{8{!eotp[31]}},{8{!eotp[31]}}};                                                           wait_clock_edge;
        end
          else begin
            dphy_pkt_r     = {crc_r[7:0],byte_data_temp_r[7:0]};                                                        wait_clock_edge;
            dphy_pkt_r     = {{8{!crc_r[15]}},crc_r[15:8]};                                                             wait_clock_edge;
            dphy_pkt_r     =  {16{!crc_r[15]}};                                                                         wait_clock_edge;
          end
          $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
        end
      end
      ///////////////////////////////////////////////////////////////////////////
      /// If no Additional bytes of Payload then CRC and EOTp(if needed)
      ///////////////////////////////////////////////////////////////////////////
      else begin
        if (NUM_TX_LANE == 4) begin
          if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
            dphy_pkt_r     = {{8{~eotp[15]}}, eotp[15: 8],
                              {8{~eotp[ 7]}}, eotp[ 7: 0],
                              eotp[31:24],    crc_r[15: 8],
                              eotp[23:16],    crc_r[ 7: 0]
                              }; wait_clock_edge;                    
            dphy_pkt_r     = {{8{ dphy_pkt_r[63]}},{8{ dphy_pkt_r[63]}},
                              {8{ dphy_pkt_r[47]}},{8{ dphy_pkt_r[47]}},
                              {8{!dphy_pkt_r[31]}},{8{!dphy_pkt_r[31]}},
                              {8{!dphy_pkt_r[15]}},{8{!dphy_pkt_r[15]}}
                              }; wait_clock_edge;                    
        end
          else begin
            dphy_pkt_r     = {{8{~dphy_pkt_r[63]}},{8{~dphy_pkt_r[63]}},
                              {8{~dphy_pkt_r[47]}},{8{~dphy_pkt_r[47]}},
                              {8{~crc_r[15]}},      crc_r[15:8],
                              {8{~crc_r[ 7]}},      crc_r[7:0]
                              }; wait_clock_edge;                    
            dphy_pkt_r     = {{8{ dphy_pkt_r[63]}},{8{ dphy_pkt_r[63]}},
                              {8{ dphy_pkt_r[47]}},{8{ dphy_pkt_r[47]}},
                              {8{ dphy_pkt_r[31]}},{8{ dphy_pkt_r[31]}},
                              {8{ dphy_pkt_r[15]}},{8{ dphy_pkt_r[15]}}
                              }; wait_clock_edge;                    
          end
        end else
        if (NUM_TX_LANE == 3) begin
          if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
            dphy_pkt_r     = {eotp[31:24],eotp[7:0],
                              eotp[23:16],crc_r[15:8],
                              eotp[15:8], crc_r[7:0]
                              }; wait_clock_edge;                    
          end
          else begin
            dphy_pkt_r     = {{16{~dphy_pkt_r[47]}},
                              {8{~crc_r[15]}},crc_r[15:8],
                              {8{~crc_r[ 7]}},crc_r[7:0]
                              }; wait_clock_edge;                    
          end
        end else
          if (NUM_TX_LANE == 2) begin
          if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
            dphy_pkt_r     = {eotp[15: 8],    crc_r[15: 8],
                              eotp[ 7: 0],    crc_r[ 7: 0]
                              }; wait_clock_edge;
            dphy_pkt_r     = {{8{!eotp[31]}},    eotp[31:24],
                              {8{!eotp[23]}},    eotp[23:16]
                              }; wait_clock_edge;
            dphy_pkt_r     = {{8{!eotp[31]}},    {8{!eotp[31]}},
                              {8{!eotp[23]}},    {8{!eotp[23]}}
                              }; wait_clock_edge;       
          end
          else begin
            dphy_pkt_r     = {{8{!crc_r[15]}},    crc_r[15:8],
                              {8{!crc_r[ 7]}},    crc_r[7:0]
                              }; wait_clock_edge;
            dphy_pkt_r     = {{8{!crc_r[15]}},    {8{!crc_r[15]}},
                              {8{!crc_r[ 7]}},    {8{!crc_r[ 7]}}
                              }; wait_clock_edge;
          end
        end else
        if (NUM_TX_LANE == 1) begin
          if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
            dphy_pkt_r     = {crc_r[15:8],crc_r[7:0]};  wait_clock_edge;
            dphy_pkt_r     = {eotp[15: 8],eotp[ 7: 0]}; wait_clock_edge;
            dphy_pkt_r     = {eotp[31:24],eotp[23:16]}; wait_clock_edge;
            dphy_pkt_r     = {16{!eotp[31]}};           wait_clock_edge;
          end
          else begin
            dphy_pkt_r     = {crc_r[15:8],crc_r[7:0]};  wait_clock_edge;
            dphy_pkt_r     = {{16{!crc_r[15]}}};        wait_clock_edge;
        end
      end
      end
  end
    else begin
      ///////////////////////////////////////////////////////////////////////////
      /// GEAR 8
      ///////////////////////////////////////////////////////////////////////////
      ///////////////////////////////////////////////////////////////////////////
      /// Sync char
      ///////////////////////////////////////////////////////////////////////////
      dphy_pkten_r         = 1;
      dphy_pkt_r           = {NUM_TX_LANE{8'hB8}};    wait_clock_edge;
      ///////////////////////////////////////////////////////////////////////////
      /// Header
      ///////////////////////////////////////////////////////////////////////////
      if (NUM_TX_LANE == 4) begin
        dphy_pkt_r         = pkt_hdr_tmp_r[31: 0];        wait_clock_edge;
      end else      
      if (NUM_TX_LANE == 3) begin     
        dphy_pkt_r         = pkt_hdr_tmp_r[24: 0];        wait_clock_edge;
        dphy_pkt_r         = {16'd0, pkt_hdr_tmp_r[31:16]};        wait_clock_edge;
      end else      
      if (NUM_TX_LANE == 2) begin     
        dphy_pkt_r         = pkt_hdr_tmp_r[15: 0];        wait_clock_edge;
        dphy_pkt_r         = pkt_hdr_tmp_r[31:16];        wait_clock_edge;
      end else      
      if(NUM_TX_LANE == 1) begin
        dphy_pkt_r         = pkt_hdr_tmp_r[ 7: 0];        wait_clock_edge;
        dphy_pkt_r         = pkt_hdr_tmp_r[15: 8];        wait_clock_edge;
        dphy_pkt_r         = pkt_hdr_tmp_r[23:16];        wait_clock_edge;
        dphy_pkt_r         = pkt_hdr_tmp_r[31:24];        wait_clock_edge;
      end
      ///////////////////////////////////////////////////////////////////////////
      /// Payload
      ///////////////////////////////////////////////////////////////////////////
      byte_count           = 0;
      while((byte_count < num_bytes) && (num_bytes - byte_count >= NUM_TX_LANE)) begin
        //////////////////////////
        /// Creating random data
        //////////////////////////
        byte_data_temp_r   = $random;
        //////////////////////////
        /// Writing data into file
        //////////////////////////
        if (NUM_TX_LANE == 4) begin
            $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[23:16],byte_data_temp_r[31:24]);
        end else
        if (NUM_TX_LANE == 3) begin
            $fwrite(f,"%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[23:16]);
        end else
        if (NUM_TX_LANE == 2) begin
          $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
        end else
        if (NUM_TX_LANE == 1) begin
          $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
        end
        //////////////////////////
        /// Sending data
        //////////////////////////
        display_data(dphy_pkt_r);
        byte_count         = byte_count + NUM_TX_LANE;
        dphy_pkt_r         = byte_data_temp_r;       wait_clock_edge;
        //////////////////////////
        /// CRC calculation
        //////////////////////////
          compute_crc(dphy_pkt_r[7:0]);
        if (NUM_TX_LANE > 1) begin
          compute_crc(dphy_pkt_r[15:8]);
        end
        if (NUM_TX_LANE > 2) begin
          compute_crc(dphy_pkt_r[23:16]);
        end
        if (NUM_TX_LANE > 3) begin
          compute_crc(dphy_pkt_r[31:24]);
        end
    end
      ///////////////////////////////////////////////////////////////////////////
      /// Additional bytes of Payload, CRC and EOTp(if needed)
      ///////////////////////////////////////////////////////////////////////////
      if ((num_bytes - byte_count) < NUM_TX_LANE && (num_bytes - byte_count) != 0) begin
        //////////////////////////
        /// Creating random data
        //////////////////////////
        byte_data_temp_r   = $random;
        //////////////////////////
        /// Paldoad, crc and EOTp
        //////////////////////////
        if (NUM_TX_LANE == 4) begin
          if (num_bytes - byte_count == 3) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              compute_crc(dphy_pkt_r[7:0]);
              dphy_pkt_r   = {crc_r[7:0],byte_data_temp_r[23:0]};                                                       wait_clock_edge;
              dphy_pkt_r   = {eotp[23:0],crc_r[15:8]};                                                                  wait_clock_edge;
              dphy_pkt_r   = {{8{!dphy_pkt_r[31]}},{8{!dphy_pkt_r[23]}},{8{!dphy_pkt_r[15]}},eotp[31:24]};              wait_clock_edge;
              dphy_pkt_r   = {{8{ dphy_pkt_r[31]}},{8{ dphy_pkt_r[23]}},{8{ dphy_pkt_r[15]}},{8{!dphy_pkt_r[7]}}};      wait_clock_edge;
            end
            else begin
              compute_crc(dphy_pkt_r[7:0]);
              dphy_pkt_r   = {crc_r[7:0],byte_data_temp_r[23:0]};                                                       wait_clock_edge;
              dphy_pkt_r   = {{8{!dphy_pkt_r[31]}},{8{!dphy_pkt_r[23]}},{8{!dphy_pkt_r[15]}},crc_r[15:8]};              wait_clock_edge;
              dphy_pkt_r   = {{8{ dphy_pkt_r[31]}},{8{ dphy_pkt_r[23]}},{8{ dphy_pkt_r[15]}},{8{!crc_r[15]}}};          wait_clock_edge;
            end
            $fwrite(f,"%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[23:16]);
          end else
          if (num_bytes - byte_count == 2) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {crc_r[15:0],byte_data_temp_r[15:0]};                                                      wait_clock_edge;
              dphy_pkt_r   = {eotp[31:0]};                                                                              wait_clock_edge;
              dphy_pkt_r   = {{8{!dphy_pkt_r[31]}},{8{!dphy_pkt_r[23]}},{8{!dphy_pkt_r[15]}},{8{!dphy_pkt_r[7]}}};      wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = {crc_r[15:0],byte_data_temp_r[15:0]};                                                      wait_clock_edge;
              dphy_pkt_r   = {{8{!dphy_pkt_r[31]}},{8{!dphy_pkt_r[23]}},{8{!dphy_pkt_r[15]}},{8{!dphy_pkt_r[7]}}};      wait_clock_edge;
            end
            $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
          end else
          if (num_bytes - byte_count == 1) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {eotp[7:0],crc_r[15:0],byte_data_temp_r[7:0]};                                             wait_clock_edge;
              dphy_pkt_r   = {{8{!dphy_pkt_r[31]}},eotp[31:8]};                                                         wait_clock_edge;
              dphy_pkt_r   = {{8{ dphy_pkt_r[31]}},{8{!dphy_pkt_r[23]}},{8{!dphy_pkt_r[15]}},{8{!dphy_pkt_r[7]}}};      wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = {{8{!dphy_pkt_r[31]}},crc_r[15:0],byte_data_temp_r[7:0]};                                  wait_clock_edge;
              dphy_pkt_r   = {{8{ dphy_pkt_r[31]}},{8{!dphy_pkt_r[23]}},{8{!dphy_pkt_r[15]}},{8{!dphy_pkt_r[7]}}};      wait_clock_edge;
            end
            $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
          end
        end else
        if (NUM_TX_LANE == 3) begin
          if (num_bytes - byte_count == 2) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {crc_r[7:0],byte_data_temp_r[15:0]};  wait_clock_edge;
              dphy_pkt_r   = {eotp[15:0],crc_r[15:8]};             wait_clock_edge;
              dphy_pkt_r   = {{8{!eotp[15]}},eotp[31:16]};         wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = {crc_r[7:0],byte_data_temp_r[15:0]};                     wait_clock_edge;
              dphy_pkt_r   = {{8{!crc_r[7]}},{8{!byte_data_temp_r[15]}},crc_r[15:8]}; wait_clock_edge;
            end
            $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
          end else
          if (num_bytes - byte_count == 1) begin
            if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
              dphy_pkt_r   = {crc_r[15:0],byte_data_temp_r[7:0]};         wait_clock_edge;
              dphy_pkt_r   = {eotp[24:0]};                                wait_clock_edge;
              dphy_pkt_r   = {{8{!eotp[24]}},{8{!eotp[16]}},eotp[31:24]}; wait_clock_edge;
            end
            else begin
              dphy_pkt_r   = {crc_r[15:0],byte_data_temp_r[7:0]};                         wait_clock_edge;
              dphy_pkt_r   = {{8{!crc_r[15]}},{8{!crc_r[7]}},{8{!byte_data_temp_r[15]}}}; wait_clock_edge;
            end
            $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
          end
        end else
        if (NUM_TX_LANE == 2) begin
          compute_crc(dphy_pkt_r[7:0]);
          if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
            dphy_pkt_r     = {crc_r[7:0],byte_data_temp_r[7:0]};                                                        wait_clock_edge;
            dphy_pkt_r     = {eotp[7:0],     crc_r[15:8]};                                                              wait_clock_edge;
            dphy_pkt_r     = {eotp[23:16],   eotp[15:8]};                                                               wait_clock_edge;
            dphy_pkt_r     = {{8{!eotp[23]}},eotp[31:24]};                                                              wait_clock_edge;
            dphy_pkt_r     = {{8{!eotp[23]}},{8{!eotp[31]}}};                                                           wait_clock_edge;
          end
          else begin
            dphy_pkt_r     = {crc_r[7:0],byte_data_temp_r[7:0]};                                                        wait_clock_edge;
            dphy_pkt_r     = {{8{!crc_r[7]}},crc_r[15:8]};                                                              wait_clock_edge;
            dphy_pkt_r     = {{8{!crc_r[7]}},{8{!crc_r[15]}}};                                                          wait_clock_edge;
          end
          $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
       end
     end
      ///////////////////////////////////////////////////////////////////////////
      /// If no Additional bytes of Payload then CRC and EOTp(if needed)
      ///////////////////////////////////////////////////////////////////////////
      else begin
        if (NUM_TX_LANE == 4) begin
          if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
            dphy_pkt_r     = {eotp[15:0],crc_r[15:0]};                                                                  wait_clock_edge;
            dphy_pkt_r     = {{8{!dphy_pkt_r[31]}},{8{!dphy_pkt_r[23]}},eotp[31:16]};                                   wait_clock_edge;
            dphy_pkt_r     = {{8{ dphy_pkt_r[31]}},{8{ dphy_pkt_r[23]}},{8{!dphy_pkt_r[15]}},{8{!dphy_pkt_r[7]}}};      wait_clock_edge;
          end
          else begin
            dphy_pkt_r     = {{8{!dphy_pkt_r[31]}},{8{!dphy_pkt_r[23]}},crc_r[15:0]};                                   wait_clock_edge;
            dphy_pkt_r     = {{8{ dphy_pkt_r[31]}},{8{ dphy_pkt_r[23]}},{8{!dphy_pkt_r[15]}},{8{!dphy_pkt_r[7]}}};      wait_clock_edge;
          end
        end else
        if (NUM_TX_LANE == 3) begin
          if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
            dphy_pkt_r     = {eotp[7:0],crc_r[15:0]};  wait_clock_edge;
            dphy_pkt_r     = {eotp[31:8]};             wait_clock_edge;
          end
          else begin
            dphy_pkt_r     = {{8{!dphy_pkt_r[23]}},crc_r[15:0]};  wait_clock_edge;
            dphy_pkt_r     = {{8{ dphy_pkt_r[23]}},{8{!crc_r[15]}},{8{!crc_r[7]}}};  wait_clock_edge;
          end
        end else
        if (NUM_TX_LANE == 2) begin
          if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
            dphy_pkt_r     = {crc_r[15:0]};                                                                             wait_clock_edge;
            dphy_pkt_r     = {eotp[15: 0]};                                                                             wait_clock_edge;
            dphy_pkt_r     = {eotp[31:16]};                                                                             wait_clock_edge;
            dphy_pkt_r     = {{8{!eotp[31]}},{8{!eotp[23]}}};                                                                           wait_clock_edge;
        end
          else begin
            dphy_pkt_r     = {crc_r[15:0]};                                                                             wait_clock_edge;
            dphy_pkt_r     = {{8{!crc_r[15]}},{8{!crc_r[7]}}};                                                          wait_clock_edge;
        end
        end else
        if (NUM_TX_LANE == 1) begin
            dphy_pkt_r     = {crc_r[7:0]};                                                                              wait_clock_edge;
            dphy_pkt_r     = {crc_r[15:8]};                                                                             wait_clock_edge;
          if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
            dphy_pkt_r     = {eotp[ 7: 0]};                                                                             wait_clock_edge;
            dphy_pkt_r     = {eotp[15: 8]};                                                                             wait_clock_edge;
            dphy_pkt_r     = {eotp[23:16]};                                                                             wait_clock_edge;
            dphy_pkt_r     = {eotp[31:24]};                                                                             wait_clock_edge;
            dphy_pkt_r     = {8{!eotp[31]}};                                                                            wait_clock_edge;
          end
          else begin
            dphy_pkt_r     = {8{!crc_r[15]}};                                                                           wait_clock_edge;
          end
        end

      end
  end
    dphy_pkt_r            <= 0;
    dphy_pkten_r          <= 0;
end
endtask

task compute_ecc(input [23:0] d, output [5:0] ecc_val);
begin
  ecc_val[0] = d[ 0]^d[ 1]^d[ 2]^d[ 4]^d[ 5]^d[ 7]^d[10]^d[11]^d[13]^d[16]^d[20]^d[21]^d[22]^d[23];
  ecc_val[1] = d[ 0]^d[ 1]^d[ 3]^d[ 4]^d[ 6]^d[ 8]^d[10]^d[12]^d[14]^d[17]^d[20]^d[21]^d[22]^d[23];
  ecc_val[2] = d[ 0]^d[ 2]^d[ 3]^d[ 5]^d[ 6]^d[ 9]^d[11]^d[12]^d[15]^d[18]^d[20]^d[21]^d[22];
  ecc_val[3] = d[ 1]^d[ 2]^d[ 3]^d[ 7]^d[ 8]^d[ 9]^d[13]^d[14]^d[15]^d[19]^d[20]^d[21]^d[23];
  ecc_val[4] = d[ 4]^d[ 5]^d[ 6]^d[ 7]^d[ 8]^d[ 9]^d[16]^d[17]^d[18]^d[19]^d[20]^d[22]^d[23];
  ecc_val[5] = d[10]^d[11]^d[12]^d[13]^d[14]^d[15]^d[16]^d[17]^d[18]^d[19]^d[21]^d[22]^d[23];
end
endtask

task drive_spkt(input [5:0] dtype);
begin
  $display("%0t Transmitting short packet: %0h",$realtime,dtype);
  if(DEBUG_ON == "ON")
    $display("%0t drive_spkt START",$realtime);
  hdr_tmp_r = {VIRTUAL_CHANNEL,dtype,8'h00,fs_num_r};
  repeat(HS_RDY_TO_DPHY_PKTEN_DLY) begin
    wait_clock_edge;
  end
  drive_hs_req();
  if (CIL_BYPASS == "CIL_BYPASSED") begin
    @(posedge d_hs_rdy_i);
  end
  repeat(HS_RDY_TO_DPHY_PKTEN_DLY) begin
    wait_clock_edge;
  end

  //sync code
  if (GEAR == 16) begin
    // dphy_pkt_r[64:0]         <= 64'h00B800B800B800B8;
    // dphy_pkten_r             <= 1;
  end
  else if (GEAR == 8) begin
    dphy_pkt_r[31:0]         <= 32'hB8B8B8B8;
    dphy_pkten_r             <= 1;
  end
  wait_clock_edge;
  compute_ecc(hdr_tmp_r,ecc_r);
  case(NUM_TX_LANE)
    1 : begin
      if (GEAR == 16)begin
        dphy_pkten_r       <= 1;
        dphy_pkt_r[7: 0]   <= 8'h00;
        dphy_pkt_r[15:8]   <= 8'hB8;
        wait_clock_edge;
        dphy_pkt_r[7:0]    <= {VIRTUAL_CHANNEL,dtype};
        dphy_pkt_r[15:8]   <= 8'h00;
        wait_clock_edge;
        dphy_pkt_r[7:0]    <= fs_num_r;
        dphy_pkt_r[15:0]   <= {2'h0,ecc_r};
        wait_clock_edge;
        if(DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
          dphy_pkt_r[7:0]  <= 8'h08;
          dphy_pkt_r[15:8] <= 8'h0F;
          wait_clock_edge;
          dphy_pkt_r[7:0]  <= 8'h0F;
          dphy_pkt_r[15:8] <= 8'h01;
          wait_clock_edge;
        end
      end
      else if (GEAR == 8) begin
        dphy_pkt_r[7:0]    <= {VIRTUAL_CHANNEL,dtype};
        wait_clock_edge;
        dphy_pkt_r[7:0]    <= 8'h00;
        wait_clock_edge;
        dphy_pkt_r[7:0]    <= fs_num_r;
        wait_clock_edge;
        dphy_pkt_r[7:0]    <= {2'h0,ecc_r};
        wait_clock_edge;
        if(DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
          dphy_pkt_r[7:0]  <= 8'h08;
          wait_clock_edge;
          dphy_pkt_r[7:0]  <= 8'h0F;
          wait_clock_edge;
          dphy_pkt_r[7:0]  <= 8'h0F;
          wait_clock_edge;
          dphy_pkt_r[7:0]  <= 8'h01;
          wait_clock_edge;
        end
      end
    end
    2 : begin
      if (GEAR == 16)begin
        dphy_pkten_r        <= 1;
        dphy_pkt_r[ 7: 0]   <= 8'h00;
        dphy_pkt_r[15: 8]   <= 8'hB8;
        dphy_pkt_r[23:16]   <= 8'h00;
        dphy_pkt_r[31:24]   <= 8'hB8;
        wait_clock_edge;
        dphy_pkt_r[7:0]     <= {VIRTUAL_CHANNEL,dtype};
        dphy_pkt_r[15:8]    <= 8'h00;
        dphy_pkt_r[23:16]   <= fs_num_r;
        dphy_pkt_r[31:24]   <= {2'h0,ecc_r};
        wait_clock_edge;
        if(DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
          dphy_pkt_r[7:0]   <= 8'h08;
          dphy_pkt_r[15:8]  <= 8'h0F;
          dphy_pkt_r[23:16] <= 8'h0F;
          dphy_pkt_r[31:24] <= 8'h01;
          wait_clock_edge;
        end
      end
      else if (GEAR == 8) begin
        dphy_pkt_r[7:0]     <= {VIRTUAL_CHANNEL,dtype};
        dphy_pkt_r[15:8]    <= 8'h00;
        wait_clock_edge;
        dphy_pkt_r[7:0]     <= fs_num_r;
        dphy_pkt_r[15:0]    <= {2'h0,ecc_r};
        wait_clock_edge;
        if(DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
          dphy_pkt_r[7:0]   <= 8'h08;
          dphy_pkt_r[15:8]  <= 8'h0F;
          wait_clock_edge;
          dphy_pkt_r[7:0]   <= 8'h0F;
          dphy_pkt_r[15:8]  <= 8'h01;
          wait_clock_edge;
        end
      end
    end
    3 : begin
      if (GEAR == 16) begin
        dphy_pkten_r        <= 1;
        dphy_pkt_r[ 7: 0]   <= 8'h00;
        dphy_pkt_r[15: 8]   <= 8'hB8;
        dphy_pkt_r[23:16]   <= 8'h00;
        dphy_pkt_r[31:24]   <= 8'hB8;
        dphy_pkt_r[39:32]   <= 8'h00;
        dphy_pkt_r[47:40]   <= 8'hB8;
        wait_clock_edge;
      end
    end
    4 : begin
      if (GEAR == 16) begin
        dphy_pkten_r        <= 1;
        dphy_pkt_r[ 7: 0]   <= 8'hB8;
        dphy_pkt_r[15: 8]   <= {VIRTUAL_CHANNEL,dtype};
        dphy_pkt_r[23:16]   <= 8'hB8;
        dphy_pkt_r[31:24]   <= 8'h00;
        dphy_pkt_r[39:32]   <= 8'hB8;
        dphy_pkt_r[47:40]   <= fs_num_r;
        dphy_pkt_r[55:48]   <= 8'hB8;
        dphy_pkt_r[63:56]   <= {2'h0,ecc_r};
        wait_clock_edge;
        if(DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
          dphy_pkt_r[ 7: 0] <= 8'h08;
          dphy_pkt_r[23:16] <= 8'h0F;
          dphy_pkt_r[39:32] <= 8'h0F;
          dphy_pkt_r[55:48] <= 8'h01;
          wait_clock_edge;
        end
      end
      else if (GEAR == 8) begin
        dphy_pkt_r[7:0]     <= {VIRTUAL_CHANNEL,dtype};
        dphy_pkt_r[15:8]    <= 8'h00;
        dphy_pkt_r[23:16]   <= fs_num_r;
        dphy_pkt_r[31:24]   <= {2'h0,ecc_r};
        wait_clock_edge;
        if(DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
          dphy_pkt_r[7:0]   <= 8'h08;
          dphy_pkt_r[15:8]  <= 8'h0F;
          dphy_pkt_r[23:16] <= 8'h0F;
          dphy_pkt_r[31:24] <= 8'h01;
          wait_clock_edge;
        end
      end
    end
  endcase
  if (NUM_TX_LANE == 4) begin
    dphy_pkt_r    <= {
                      {GEAR{!dphy_pkt_r[1*GEAR-1]}},
                      {GEAR{!dphy_pkt_r[2*GEAR-1]}},
                      {GEAR{!dphy_pkt_r[3*GEAR-1]}},
                      {GEAR{!dphy_pkt_r[4*GEAR-1]}}
                       };
  end else 
  if (NUM_TX_LANE == 3) begin
    dphy_pkt_r    <= {
                      {GEAR{!dphy_pkt_r[1*GEAR-1]}},
                      {GEAR{!dphy_pkt_r[2*GEAR-1]}},
                      {GEAR{!dphy_pkt_r[3*GEAR-1]}}
                       };
  end else 
  if (NUM_TX_LANE == 2) begin
    dphy_pkt_r    <= {
                      {GEAR{!dphy_pkt_r[1*GEAR-1]}}, 
                      {GEAR{!dphy_pkt_r[2*GEAR-1]}}  
                       };
  end else 
  if (NUM_TX_LANE == 1) begin
    dphy_pkt_r    <= {
                      {GEAR{!dphy_pkt_r[1*GEAR-1]}}
                      };
  end
  wait_clock_edge;
  dphy_pkten_r  <= 0;
  dphy_pkt_r    <= 0;

  if(dtype == 6'h01) begin
    fs_num_r = fs_num_r^2'b11;
    ls_num_r=1;
  end
  if(dtype == 6'h03) begin
    ls_num_r=ls_num_r+1;
  end
  if(DEBUG_ON == "ON")
    $display("%0t drive_spkt END",$realtime);
end
endtask

task drive_byte();
begin
  $display("%0t Transmitting video data, data type : %0h , word count = %0d ...",$realtime,DATA_TYPE,num_bytes);
  if (DEVICE_TYPE == "CSI2") begin
    @(negedge ld_pyld_i);    
    wait_clock_edge;    
    wait_clock_edge;    
  end 
  byte_data_en_r <= 1;
  byte_count=0;
  while(byte_count<(num_bytes)) begin
    byte_data_temp_r = $random;
    compute_crc(byte_data_temp_r[7:0]);
    if (num_bytes - byte_count < (GEAR*NUM_TX_LANE)/8) begin
      case(num_bytes - byte_count)
        16'd1 : begin
          $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
        end
        16'd2 : begin
          if (GEAR == 8) begin
            $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
          end
          else if (GEAR == 16) begin
            $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16]);
          end
        end
        16'd3 : begin
          if (GEAR == 16) begin
            if (NUM_TX_LANE == 2) begin
              $fwrite(f,"%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[15:8]);
            end
            else begin// 3 or 4
//              if (NUM_TX_LANE  == 4) begin
                $fwrite(f,"%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[39:32]);
//              end
            end
          end
          else begin
            if (GEAR == 8) begin
              $fwrite(f,"%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[23:16]);
            end
          end
        end
        16'd4 : begin
          if (NUM_TX_LANE == 3) begin
            $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[15:8]);
          end else begin
            $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[55:48]);
          end
        end
        16'd5 : begin
          if (NUM_TX_LANE == 3) begin
            $fwrite(f,"%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[15:8],byte_data_temp_r[31:24]);
          end else begin
            $fwrite(f,"%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[55:48],byte_data_temp_r[15: 8]);
          end
        end
        16'd6 : begin
          $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[55:48],byte_data_temp_r[15: 8],byte_data_temp_r[31:24]);
        end
        16'd7 : begin
          $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[55:48],byte_data_temp_r[15: 8],byte_data_temp_r[31:24],byte_data_temp_r[47:40]);
        end
      endcase
    end
    else begin
      if (DATA_WIDTH ==  8) begin
        $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
      end else
      if (DATA_WIDTH == 16) begin
        $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
      end else
      if (DATA_WIDTH == 32) begin
        if (GEAR == 8) begin
          $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[23:16],byte_data_temp_r[31:24]);
        end
        else if (GEAR == 16) begin
          $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[15:8],byte_data_temp_r[31:24]);
        end
      end else
      if (DATA_WIDTH == 64) begin
        $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n%h\n%h\n", byte_data_temp_r[ 7: 0],
                                                              byte_data_temp_r[23:16],
                                                              byte_data_temp_r[39:32],
                                                              byte_data_temp_r[55:48],
                                                              byte_data_temp_r[15: 8],
                                                              byte_data_temp_r[31:24],
                                                              byte_data_temp_r[47:40],
                                                              byte_data_temp_r[63:56]);
      end
    end
    byte_data_r     <= byte_data_temp_r;
    display_data(byte_data_r);
    wait_clock_edge;
    byte_count       = byte_count + (GEAR*NUM_TX_LANE)/8;
  end
  
  repeat($urandom%4) begin
  //repeat(1) begin
    wait_clock_edge;
  end
  byte_data_en_r    <= 0;
  byte_data_r       <= 0;
  $display("%0t Transmitting video data DONE!",$realtime);
end
endtask

task drive_lp();
begin
  if(DEBUG_ON == "ON")
    $display("%0t drive_lp START",$realtime);
  repeat(HS_RDY_NEG_TO_HS_CLK_EN_DLY) begin
    wait_clock_edge;
  end
  drive_hs_req;
  if (CIL_BYPASS == "CIL_BYPASSED") begin
    @(posedge d_hs_rdy_i);
  end

  repeat(HS_RDY_TO_LP_EN_DLY) begin
    wait_clock_edge;
  end

// HEADER-long packet
  dt_r    <= DATA_TYPE;
  vcx_r   <= EXTVIRTUAL_CHANNEL;
  vc_r    <= VIRTUAL_CHANNEL;
  wc_r    <= num_bytes;
// HEADER-long packet
  lp_en_r <= 1;
  wait_clock_edge;
  lp_en_r <= 0;

  if(DEBUG_ON == "ON")
    $display("%0t drive_lp END",$realtime);
end
endtask

task drive_sp(input [5:0] dtype);
begin
  $display("%0t Transmitting short packet : %0h",$realtime,dtype);
  if(DEBUG_ON == "ON")
    $display("%0t drive_sp START",$realtime);
  repeat(HS_RDY_NEG_TO_HS_CLK_EN_DLY) begin
    wait_clock_edge;
  end
  drive_hs_req;
  if (CIL_BYPASS == "CIL_BYPASSED") begin
    @(posedge d_hs_rdy_i);
  end

  repeat(HS_RDY_TO_SP_EN_DLY) begin
    wait_clock_edge;
  end

  dt_r  <= dtype;
  vcx_r <= EXTVIRTUAL_CHANNEL;
  vc_r  <= VIRTUAL_CHANNEL;
  wc_r  <= 0;


  if(GEN_FR_NUM == "ON") begin
    if(dtype == 6'h00) begin
      wc_r[1:0] <= fs_num_r;
    end
    else if(dtype == 6'h01) begin
      wc_r[1:0] <= fs_num_r;
      fs_num_r = fs_num_r^2'b11;
      ls_num_r=1;
    end
  end
  if(GEN_LN_NUM == "ON") begin
    if(dtype == 6'h02) begin
      wc_r <= ls_num_r;
    end
    else if(dtype == 6'h03) begin
      wc_r <= ls_num_r;
      ls_num_r=ls_num_r+1;
    end
  end
  sp_en_r <= 1;
  
  wait_clock_edge; /////////////*******************Check

  sp_en_r <= 0;
  if (CIL_BYPASS == "CIL_BYPASSED") begin
    @(negedge d_hs_rdy_i);
  end
  if(DEBUG_ON == "ON")
    $display("%0t drive_sp END",$realtime);
end
endtask

task drive_vsync_st();
begin
  $display("%0t Transmitting vsync start",$realtime);
  if(DEBUG_ON == "ON")
    $display("%0t drive_vsync_st START",$realtime);
  repeat(HS_RDY_TO_LP_EN_DLY) begin
    wait_clock_edge;
  end
  drive_hs_req;
  if (CIL_BYPASS == "CIL_ENABLED") begin
    while(d_hs_rdy_i == 1'd0) begin
      #1;
    end
  end
  else begin
    @(posedge d_hs_rdy_i);
  end

  repeat(HS_RDY_TO_VSYNC_START_DLY) begin
    wait_clock_edge;
  end

  vsync_start_r <= 1;

  dt_r          <= 6'h01;
  vc_r          <= VIRTUAL_CHANNEL;
  wc_r          <= 0;

  if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
    eotp_r <= 1'd1;
  end
  else begin
    eotp_r <= 1'd0;
  end

  wait_clock_edge;
  vsync_start_r <= 0;

  if (CIL_BYPASS == "CIL_BYPASSED") begin
    @(negedge d_hs_rdy_i);
  end
  repeat(VSYNC_TO_HSYNC_DLY) begin
    wait_clock_edge;
  end
  if(DEBUG_ON == "ON")
    $display("%0t drive_vsync_st END",$realtime);
end
endtask

task drive_hsync_st();
begin
  $display("%0t Transmitting hsync start",$realtime);
  if(DEBUG_ON == "ON") begin
    $display("%0t drive_hsync_st START",$realtime);
  end   

  repeat(HS_RDY_TO_LP_EN_DLY) begin
    wait_clock_edge;
  end
  drive_hs_req;
  if (CIL_BYPASS == "CIL_ENABLED") begin
    while(d_hs_rdy_i == 1'd0) begin
      #1;
    end
  end
  else begin
    @(posedge d_hs_rdy_i);
  end

  repeat(HS_RDY_TO_HSYNC_START_DLY) begin
    wait_clock_edge;
  end
  hsync_start_r <= 1;
  
  dt_r          <= 6'h21;
  vc_r          <= VIRTUAL_CHANNEL;
  wc_r          <= 0;

  if (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI") begin
    eotp_r <= 1'd1;
  end
  else begin
    eotp_r <= 1'd0;
  end
  wait_clock_edge;
  hsync_start_r <= 0;

  if (CIL_BYPASS == "CIL_BYPASSED") begin
    @(negedge d_hs_rdy_i);
  end
  repeat(HSYNC_TO_HSYNC_DLY) begin
    wait_clock_edge;
  end
  if(DEBUG_ON == "ON")
    $display("%0t drive_hsync_st END",$realtime);
end
endtask

task wait_clock_edge();
begin
  if(DRIVING_EDGE == "posedge") begin
    @(posedge ref_clk_i);
  end
  else begin
    @(negedge ref_clk_i);
  end
end
endtask

task lmmi_write(
  input [LMMI_OFFSET_WIDTH-1:0] offset,
  input [LMMI_DATA_WIDTH-1:0]   data
  );begin
  lmmi_offset_r  <= offset;
  lmmi_wdata_r   <= data;
  lmmi_wr_rdn_r  <= 1'd1;
  lmmi_request_r <= 1'd1;
  @(posedge lmmi_clk_i);
  #1;
  $display("%0t",$realtime," LMMI : Write %h",lmmi_wdata_r," in register %h", lmmi_offset_r);
  lmmi_offset_r  <= {LMMI_OFFSET_WIDTH{1'd0}};
  lmmi_wdata_r   <= {LMMI_DATA_WIDTH{1'd0}};
  lmmi_wr_rdn_r  <= 1'd0;
  lmmi_request_r <= 1'd0;
  end
endtask

task lmmi_read(
  input  [LMMI_OFFSET_WIDTH-1:0] offset
  );
  begin
    @(negedge lmmi_clk_i);
    lmmi_offset_r     <= {1'd1,offset};
    lmmi_wr_rdn_r     <= 1'd0;
    lmmi_request_r    <= 1'd1;
    @(negedge lmmi_clk_i);
    lmmi_wr_rdn_r     <= 1'd0;
    lmmi_request_r    <= 1'd0;
    @(posedge lmmi_clk_i);
    lmmi_rdata_tmp_r  <= lmmi_rdata_i;
  end
endtask


task wait4ready;
  begin
    while (!c2d_ready_i) begin
      @(posedge ref_clk_i);
    end
  end
endtask

task compute_crc(input [7:0] pkt_val);
begin
  for(k=0;k<8;k=k+1) begin
    cur_crc_r = crc_r;
    cur_crc_r[15] = pkt_val[k]   ^cur_crc_r[0];
    cur_crc_r[10] = cur_crc_r[11]^cur_crc_r[15];
    cur_crc_r[3]  = cur_crc_r[4] ^cur_crc_r[15];
    crc_r = crc_r >> 1;
    crc_r[15] = cur_crc_r[15];
    crc_r[10] = cur_crc_r[10];
    crc_r[3]  = cur_crc_r[3]; 
  end
end
endtask
// `include "cil_tasks.v"
/////////////////////////////////////////////////////////////
/// CIL tasks Start
/////////////////////////////////////////////////////////////
task drive_spkt_CIL_t(input [5:0] dtype);
  begin
    tx_cil_word_valid_lane0_r = (GEAR == 16)? 4'b0011 : 4'b0001;
    tx_cil_word_valid_lane1_r = (GEAR == 16)? 4'b0011 : 4'b0001;
    tx_cil_word_valid_lane2_r = (GEAR == 16)? 4'b0011 : 4'b0001;
    tx_cil_word_valid_lane3_r = (GEAR == 16)? 4'b0011 : 4'b0001;
    line_disable_r            = {NUM_TX_LANE{1'b0}};
    $display("%0t Transmitting short packet: %0h",$realtime,dtype);
    if(DEBUG_ON == "ON") begin
      $display("%0t drive_spkt START",$realtime);
    end

    hdr_tmp_r = {VIRTUAL_CHANNEL,dtype,8'h00,fs_num_r};

    repeat(HS_RDY_TO_DPHY_PKTEN_DLY) begin
      wait_clock_edge;
    end

    /// drive_hs_req ///////////////////////////////////////////////
      if(DEBUG_ON == "ON") begin
        $display("%0t drive_hs_req START",$realtime);
      end

      repeat(D_HS_RDY_TO_D_HS_CLK_EN_DLY) wait_clock_edge;

      clk_hs_en_r <= 1;
      while (!hs_clk_cil_ready_i) begin
        wait_clock_edge;
      end
      d_hs_en_r   <= 1;

      // repeat(5) wait_clock_edge;

      

      if(DEBUG_ON == "ON") begin
        $display("%0t drive_hs_req END",$realtime);
      end
    ////////////////////////////////////////////////////////////////

    compute_ecc(hdr_tmp_r,ecc_r);
    dphy_pkten_r                = 0;
    @(posedge &(hs_tx_cil_ready_i));
    dphy_pkten_r                = 1;

    case(NUM_TX_LANE)
    /// 1-LINE /////////////////////////////////////////////////////
      1 : begin
        if (GEAR == 16)begin
          dphy_pkt_r[7:0]    <= {VIRTUAL_CHANNEL,dtype};
          dphy_pkt_r[15:8]   <= 8'h00;
          wait_clock_edge;
          dphy_pkt_r[7:0]    <= fs_num_r;
          dphy_pkt_r[15:0]   <= {2'h0,ecc_r};
          wait_clock_edge;
          if(DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
            dphy_pkt_r[7:0]  <= 8'h08;
            dphy_pkt_r[15:8] <= 8'h0F;
            wait_clock_edge;
            dphy_pkt_r[7:0]  <= 8'h0F;
            dphy_pkt_r[15:8] <= 8'h01;
            wait_clock_edge;
          end
        end
        else if (GEAR == 8) begin
          dphy_pkt_r[7:0]    <= {VIRTUAL_CHANNEL,dtype};
          wait_clock_edge;
          dphy_pkt_r[7:0]    <= 8'h00;
          wait_clock_edge;
          dphy_pkt_r[7:0]    <= fs_num_r;
          wait_clock_edge;
          dphy_pkt_r[7:0]    <= {2'h0,ecc_r};
          wait_clock_edge;
          if(DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
            dphy_pkt_r[7:0]  <= 8'h08;
            wait_clock_edge;
            dphy_pkt_r[7:0]  <= 8'h0F;
            wait_clock_edge;
            dphy_pkt_r[7:0]  <= 8'h0F;
            wait_clock_edge;
            dphy_pkt_r[7:0]  <= 8'h01;
            wait_clock_edge;
          end
        end
      end
    /// 2-LINE /////////////////////////////////////////////////////
      2 : begin
        if (GEAR == 16)begin
          dphy_pkten_r        <= 1;
          dphy_pkt_r[7:0]     <= {VIRTUAL_CHANNEL,dtype};
          dphy_pkt_r[15:8]    <= 8'h00;
          dphy_pkt_r[23:16]   <= fs_num_r;
          dphy_pkt_r[31:24]   <= {2'h0,ecc_r};
          wait_clock_edge;
          if(DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
            dphy_pkt_r[7:0]   <= 8'h08;
            dphy_pkt_r[15:8]  <= 8'h0F;
            dphy_pkt_r[23:16] <= 8'h0F;
            dphy_pkt_r[31:24] <= 8'h01;
            wait_clock_edge;
          end
        end
        else if (GEAR == 8) begin
          dphy_pkt_r[7:0]     <= {VIRTUAL_CHANNEL,dtype};
          dphy_pkt_r[15:8]    <= 8'h00;
          wait_clock_edge;
          dphy_pkt_r[7:0]     <= fs_num_r;
          dphy_pkt_r[15:0]    <= {2'h0,ecc_r};
          wait_clock_edge;
          if(DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
            dphy_pkt_r[7:0]   <= 8'h08;
            dphy_pkt_r[15:8]  <= 8'h0F;
            wait_clock_edge;
            dphy_pkt_r[7:0]   <= 8'h0F;
            dphy_pkt_r[15:8]  <= 8'h01;
            wait_clock_edge;
          end
        end
      end
    /// 3-LINE /////////////////////////////////////////////////////
      3 : begin
        if (GEAR == 16) begin
          dphy_pkten_r        <= 1;
          dphy_pkt_r[7:0]     <= {VIRTUAL_CHANNEL,dtype};
          dphy_pkt_r[23:16]   <= fs_num_r;
          dphy_pkt_r[39:32]   <= {2'h0,ecc_r};
          dphy_pkt_r[15:8]    <= 8'hff;
          dphy_pkt_r[23:16]   <= 8'hff;
          dphy_pkt_r[31:24]   <= 8'hff;
          wait_clock_edge;
        end
        else if (GEAR == 8) begin
          dphy_pkten_r        <= 1;
          dphy_pkt_r[7:0]     <= {VIRTUAL_CHANNEL,dtype};
          dphy_pkt_r[15:8]    <= fs_num_r;
          dphy_pkt_r[23:16]   <= {2'h0,ecc_r};
          wait_clock_edge;
        end
      end   
    /// 4-LINE /////////////////////////////////////////////////////
      4 : begin
        if (GEAR == 16) begin
          if(DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
            dphy_pkten_r        <= 1;
            dphy_pkt_r[ 7: 0]   <= {VIRTUAL_CHANNEL,dtype};
            dphy_pkt_r[15: 8]   <= 8'h08;
            dphy_pkt_r[23:16]   <= 8'h00;
            dphy_pkt_r[31:24]   <= 8'h0F;
            dphy_pkt_r[39:32]   <= fs_num_r;
            dphy_pkt_r[47:40]   <= 8'h0F;
            dphy_pkt_r[55:48]   <= {2'h0,ecc_r};
            dphy_pkt_r[63:56]   <= 8'h01;
            wait_clock_edge;
          end
          else begin
            dphy_pkten_r        <= 1;
            dphy_pkt_r[ 7: 0]   <= {VIRTUAL_CHANNEL,dtype};
            dphy_pkt_r[15: 8]   <= 8'h00;
            dphy_pkt_r[23:16]   <= 8'h00;
            dphy_pkt_r[31:24]   <= 8'h00;
            dphy_pkt_r[39:32]   <= fs_num_r;
            dphy_pkt_r[47:40]   <= 8'h00;
            dphy_pkt_r[55:48]   <= {2'h0,ecc_r};
            dphy_pkt_r[63:56]   <= 8'h00;
            wait_clock_edge;
          end
        end
        else if (GEAR == 8) begin
          dphy_pkt_r[7:0]     <= {VIRTUAL_CHANNEL,dtype};
          dphy_pkt_r[15:8]    <= 8'h00;
          dphy_pkt_r[23:16]   <= fs_num_r;
          dphy_pkt_r[31:24]   <= {2'h0,ecc_r};
          wait_clock_edge;
          if(DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
            dphy_pkt_r[7:0]   <= 8'h08;
            dphy_pkt_r[15:8]  <= 8'h0F;
            dphy_pkt_r[23:16] <= 8'h0F;
            dphy_pkt_r[31:24] <= 8'h01;
            wait_clock_edge;
          end
        end
      end
    endcase

    d_hs_en_r     <= 0;
    dphy_pkten_r  <= 0;
    dphy_pkt_r    <= 0;
    repeat(15) wait_clock_edge;
    clk_hs_en_r   <= 0;

    if(dtype == 6'h01) begin
      fs_num_r = fs_num_r^2'b11;
      ls_num_r=1;
    end

    if(dtype == 6'h03) begin
      ls_num_r=ls_num_r+1;
    end

    if(DEBUG_ON == "ON") begin
      $display("%0t drive_spkt END",$realtime);
    end

  end
endtask

task drive_lpkt_CIL_t();
  begin
    $display("%0t Transmitting video data data type : %0h , word count = %0d ...",$realtime,DATA_TYPE,num_bytes);
    tx_cil_word_valid_lane0_r   = (GEAR == 16)? 4'b0011 : 4'b0001;
    tx_cil_word_valid_lane1_r   = (GEAR == 16)? 4'b0011 : 4'b0001;
    tx_cil_word_valid_lane2_r   = (GEAR == 16)? 4'b0011 : 4'b0001;
    tx_cil_word_valid_lane3_r   = (GEAR == 16)? 4'b0011 : 4'b0001;
    line_disable_r              = {NUM_TX_LANE{1'b0}};
    if(DEBUG_ON == "ON") begin
      $display("%0t drive_lpkt START",$realtime);
    end
    
    crc_tmp_r                   = 0;
    word_count_r                = num_bytes;
    pkt_hdr_tmp_r[5:0]          = DATA_TYPE;
    pkt_hdr_tmp_r[7:6]          = VIRTUAL_CHANNEL;
    pkt_hdr_tmp_r[15:8]         = word_count_r[7:0];
    pkt_hdr_tmp_r[23:16]        = word_count_r[15:8];
    compute_ecc(pkt_hdr_tmp_r,ecc_r);
  
    /// drive_hs_req ////////////////////////////////////////////////////
    if (DEBUG_ON == "ON") begin
      $display("%0t drive_hs_req START",$realtime);
    end
    
    repeat(D_HS_RDY_TO_D_HS_CLK_EN_DLY) wait_clock_edge;
    
    clk_hs_en_r                <= 1;
    while (!hs_clk_cil_ready_i) begin
        wait_clock_edge;
    end
    d_hs_en_r                  <= 1;
    
    
    // clk_hs_en_r                <= 0;
    
    if(DEBUG_ON == "ON") begin
      $display("%0t drive_hs_req END",$realtime);
    end
    /////////////////////////////////////////////////////////////////////
    // pkt_hdr_tmp_r[31:24]        = ecc_r[7:0]; /// Update Header when ecc is calculated maybe it is bug ***
    /////////////////////////////////////////////////////////////////////
    dphy_pkten_r                = 0;
    @(posedge &(hs_tx_cil_ready_i));
    dphy_pkten_r                = 1;
    
    ///////////////////////////////////////////////////////////////////// 
    ///////////////////////////////////////////////////////////////////// Header
    case (NUM_TX_LANE)
      1 : begin
        case (GEAR)
          8  : begin      
            dphy_pkt_r[ 7: 0]  <= pkt_hdr_tmp_r[ 7: 0];
            dphy_pkten_r       <= 1;
            wait_clock_edge;
            dphy_pkt_r[ 7: 0]  <= pkt_hdr_tmp_r[15: 8];
            dphy_pkten_r       <= 1;
            wait_clock_edge;
            dphy_pkt_r[ 7: 0]  <= pkt_hdr_tmp_r[23:16];
            dphy_pkten_r       <= 1;
            wait_clock_edge;
            dphy_pkt_r[ 7: 0]  <= {2'd0,ecc_r};
            dphy_pkten_r       <= 1;
            wait_clock_edge;
          end
          16 : begin
            dphy_pkt_r[15: 0]  <= pkt_hdr_tmp_r[15:0];
            dphy_pkten_r       <= 1;
            wait_clock_edge;
            dphy_pkt_r[15: 0]  <= {2'd0,ecc_r,pkt_hdr_tmp_r[23:16]};
            dphy_pkten_r       <= 1;
            wait_clock_edge;
          end
        endcase
      end
      2 : begin
        case (GEAR)
          8  : begin      
            dphy_pkt_r[ 7: 0]  <= pkt_hdr_tmp_r[ 7: 0];
            dphy_pkt_r[15: 8]  <= pkt_hdr_tmp_r[15: 8];
            dphy_pkten_r       <= 1;
            wait_clock_edge;
            dphy_pkt_r[ 7: 0]  <= pkt_hdr_tmp_r[23:16];
            dphy_pkt_r[15: 8]  <= {2'd0,ecc_r};
            dphy_pkten_r       <= 1;
            wait_clock_edge;
          end
          16 : begin
            dphy_pkt_r[ 7: 0]  <= pkt_hdr_tmp_r[ 7: 0];
            dphy_pkt_r[15: 8]  <= pkt_hdr_tmp_r[23:16]; /// Maybe will be toggle this 2 lines [15: 8]  <=> [23:16]
            dphy_pkt_r[23:16]  <= pkt_hdr_tmp_r[15: 8]; /// Maybe will be toggle this 2 lines
            dphy_pkt_r[31:24]  <= {2'd0,ecc_r};
            dphy_pkten_r       <= 1;
            wait_clock_edge;
          end 
        endcase
      end
      3 : begin
        case (GEAR)
          8  : begin
            dphy_pkt_r[ 7: 0]  <= pkt_hdr_tmp_r[ 7: 0];
            dphy_pkt_r[15: 8]  <= pkt_hdr_tmp_r[15: 8];
            dphy_pkt_r[23:16]  <= pkt_hdr_tmp_r[23:16];
            dphy_pkten_r       <= 1;
            wait_clock_edge;
            dphy_pkt_r[ 7: 0]  <= {2'd0,ecc_r};
            dphy_pkt_r[15: 8]  <= byte_data_temp_r[ 7: 0];
            dphy_pkt_r[23:16]  <= byte_data_temp_r[15: 8];
            dphy_pkten_r       <= 1;
            byte_count         <= 2;
 //           $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
            $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
            wait_clock_edge;
          end 
          16 : begin
            dphy_pkt_r[15: 0]   <= {{2'd0,ecc_r}           ,pkt_hdr_tmp_r[ 7: 0]};
            dphy_pkt_r[31:16]   <= {byte_data_temp_r[ 7: 0],pkt_hdr_tmp_r[15: 8]};
            dphy_pkt_r[47:32]   <= {byte_data_temp_r[15: 8],pkt_hdr_tmp_r[23:16]};
            dphy_pkten_r        <= 1;
            byte_count          <= 2;
//             $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
            $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
            wait_clock_edge;
          end 
        endcase
      end
      4 : begin
        case (GEAR)
          8  : begin
            dphy_pkt_r[ 7: 0]  <= pkt_hdr_tmp_r[ 7: 0];
            dphy_pkt_r[15: 8]  <= pkt_hdr_tmp_r[15: 8];
            dphy_pkt_r[23:16]  <= pkt_hdr_tmp_r[23:16];
            dphy_pkt_r[31:24]  <= {2'd0,ecc_r};
            dphy_pkten_r       <= 1;
            wait_clock_edge;
          end
          16 : begin /// In this case must to group header(32 bit) + data(32 bit) and give to tx 
            byte_data_temp_r    = $random;          /*|*/ /// $fwrite(f,"%h esiya\n",byte_data_temp_r);
            dphy_pkt_r[15: 0]   = {byte_data_temp_r[ 7: 0],pkt_hdr_tmp_r[ 7: 0]};
            dphy_pkt_r[31:16]   = {byte_data_temp_r[15: 8],pkt_hdr_tmp_r[15: 8]};
            dphy_pkt_r[47:32]   = {byte_data_temp_r[23:16],pkt_hdr_tmp_r[23:16]};
            dphy_pkt_r[63:48]   = {byte_data_temp_r[31:24],{2'd0,ecc_r}};
            dphy_pkten_r        = 1;
            $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[23:16],byte_data_temp_r[31:24]);
            byte_count = 4;
            wait_clock_edge;
          end
        endcase
      end
    endcase
    ///////////////////////////////////////////////////////////////////// Byte data
    while(byte_count<num_bytes) begin
        byte_data_temp_r = $random;
        compute_crc(byte_data_temp_r[7:0]);
        tx_cil_word_valid_lane0_r        = (GEAR == 16)? 4'b0011 : 4'b0001;
        tx_cil_word_valid_lane1_r        = (GEAR == 16)? 4'b0011 : 4'b0001;
        tx_cil_word_valid_lane2_r        = (GEAR == 16)? 4'b0011 : 4'b0001;
        tx_cil_word_valid_lane3_r        = (GEAR == 16)? 4'b0011 : 4'b0001;
        line_disable_r                   = {NUM_TX_LANE{1'b0}};
     if (num_bytes - byte_count < (GEAR*NUM_TX_LANE)/8) begin
          footer_sant_r                   <= 1;
          dphy_pkten_r                    <= 1;
          if (DATA_WIDTH ==  8) begin
            ///////WRITING DATA TXT
            $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
            ///////WRITING DATA TXT
            ///////DATA TRANS            
            dphy_pkt_r     <= byte_data_temp_r;            
            wait_clock_edge;
            dphy_pkt_r     <= crc_r[7:0];           
            wait_clock_edge;
            dphy_pkt_r     <= crc_r[15:8];
            if (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
              wait_clock_edge;
              dphy_pkt_r   <=eotp[7:0];
              wait_clock_edge;
              dphy_pkt_r   <=eotp[15:8];
              wait_clock_edge;
              dphy_pkt_r   <=eotp[23:16];
              wait_clock_edge;
              dphy_pkt_r   <=eotp[31:24];
            end
            ///////DATA TRANS
          end else
          if (DATA_WIDTH == 16) begin
            //////WRITING DATA TXT
//             $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0]);            
            $fwrite(f,"%h\n",byte_data_temp_r[7:0]);            
            //////WRITING DATA TXT
            ///////DATA TRANS
            dphy_pkt_r                  <= {crc_r[7:0],byte_data_temp_r[7:0]};
            wait_clock_edge;
            dphy_pkt_r                  <= (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON")? {eotp[7:0],crc_r[15:8]} : {8'hFF,crc_r[15:8]};
            tx_cil_word_valid_lane0_r   <= 4'b0001;
            line_disable_r              <= (NUM_TX_LANE == 2)? 4'b0010 : 4'b0000;//TBD
            if (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
              wait_clock_edge;
              dphy_pkt_r   <= {eotp[23:16],eotp[15:8]};
              wait_clock_edge;
              dphy_pkt_r   <= {8'hFF,eotp[31:24]};
            end
            ///////DATA TRANS
          end 
          else if (DATA_WIDTH == 24) begin
            case (num_bytes - byte_count)
              1 : begin
                $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
                dphy_pkt_r        <= {crc_r[15:8],crc_r[7:0],byte_data_temp_r[7:0]};
                if (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
                  wait_clock_edge;
                  dphy_pkt_r      <= {eotp[23:16],eotp[15:8],eotp[7:0]};
                  wait_clock_edge;
                  dphy_pkt_r      <= {8'hFF,8'hFF,eotp[31:24]};
                  line_disable_r  <= 4'b1110;
                end
              end 
              2 : begin
                $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
                dphy_pkt_r        <= {crc_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[7:0]};
                wait_clock_edge;
                dphy_pkt_r        <= (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON")? {eotp[15:8],eotp[7:0],crc_r[15:8]}:
                                                                                    {8'hFF,8'hFF,crc_r[15:8]};
                line_disable_r    <= (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON")? 4'b1000 : 4'b1110;
                if (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
                  wait_clock_edge;
                  dphy_pkt_r      <= {8'hFF,eotp[31:24],eotp[23:16]};
                  line_disable_r  <= 4'b1100;
                end
              end 
            endcase
          end
          else if (DATA_WIDTH == 32) begin
            if (GEAR == 8) begin
              case (num_bytes - byte_count)
                1: begin
//                   $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0]);
                  $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
                  dphy_pkt_r      <= (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON")? {eotp[7:0],crc_r[15:8],crc_r[7:0],byte_data_temp_r[7:0]} :
                                                                                 {8'hFF,crc_r[15:8],crc_r[7:0],byte_data_temp_r[7:0]};
                  line_disable_r  <= 4'b1000;
                end  
                2: begin
//                   $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
                  $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
                  dphy_pkt_r  <= {crc_r[15:8],crc_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[7:0]};
                  if (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
                    wait_clock_edge;
                    dphy_pkt_r <= eotp;
                  end
                end  
                3: begin
//                   $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[23:16]);
                  $fwrite(f,"%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[23:16]);
                  dphy_pkt_r      <= {crc_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[15:8],byte_data_temp_r[7:0]};
                  wait_clock_edge;
                  dphy_pkt_r      <= (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON")? {eotp[23:0],crc_r[15:8]} : {24'hFF,crc_r[15:8]} ;
                  line_disable_r  <= 4'b1110;
                  if (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
                    wait_clock_edge;
                    dphy_pkt_r <= {24'hFF,eotp[31:24]};
                  end
                end  
              endcase
            end
            else if (GEAR == 16) begin
              case (num_bytes - byte_count)
                1: begin
//                   $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0]);
                  $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
                  dphy_pkt_r  <= (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON")? {eotp[7:0],crc_r[7:0],crc_r[15:8],byte_data_temp_r[7:0]} : {8'hFF,crc_r[7:0],crc_r[15:8],byte_data_temp_r[7:0]};
                  tx_cil_word_valid_lane1_r   <= 4'b0001;
                  if (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
                    wait_clock_edge;
                    dphy_pkt_r   <= {8'hFF,eotp[23:16],eotp[31:16],eotp[15:8]};
                  end
                end  
                2: begin
//                  $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16]);
                  $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16]);
                  dphy_pkt_r  <= {crc_r[15:0],byte_data_temp_r[23:16],crc_r[7:0],byte_data_temp_r[7:0]};
                  if (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
                    wait_clock_edge;
                    dphy_pkt_r   <= {eotp[31:24],eotp[15:8],eotp[23:16],eotp[7:0]};
                  end              
                end  
                3: begin
//                   $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[15:8]);
                  $fwrite(f,"%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[15:8]);
                  dphy_pkt_r     <= {crc_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[15:8],byte_data_temp_r[7:0]};
                  wait_clock_edge;
                  line_disable_r <= 4'b0010;
                  tx_cil_word_valid_lane0_r   <= 4'b0001;
                  dphy_pkt_r     <= (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON")? {eotp[23:16],eotp[7:0],eotp[15:8],crc_r[15:8]} : {24'hFF,crc_r[15:8]};
                  if (DEVICE_TYPE == "DSI" && EOTP_ENABLE == "ON") begin
                    wait_clock_edge;
                    dphy_pkt_r  <= {24'hFF,eotp[31:24]};
                  end
                end  
              endcase
            end
          end
          else if (DATA_WIDTH == 48) begin
            case (num_bytes - byte_count)
              1 : begin
                $fwrite(f,"%h\n",byte_data_temp_r[ 7: 0]);
                dphy_pkt_r  <=  {
                  8'hFF,                           crc_r[15: 8],
                  8'hFF,                           crc_r[7 : 0],
                  8'hFF,                byte_data_temp_r[7 : 0]
                  };
                  line_disable_r              <= 4'b1000;
                  tx_cil_word_valid_lane0_r   <= 4'b0001;
                  tx_cil_word_valid_lane1_r   <= 4'b0001;
                  tx_cil_word_valid_lane2_r   <= 4'b0001;
              end 
              2 : begin
                $fwrite(f,"%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16]);
                dphy_pkt_r  <=  {
                  8'hFF,                           crc_r[ 7: 0],
                  8'hFF,                byte_data_temp_r[23:16],
                  crc_r[15: 8],         byte_data_temp_r[7 : 0]
                  };
                tx_cil_word_valid_lane1_r   <= 4'b0001;
                tx_cil_word_valid_lane2_r   <= 4'b0001;
              end 
              3 : begin
                $fwrite(f,"%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],byte_data_temp_r[39:32]);
                dphy_pkt_r  <=  {
                  8'hFF,                byte_data_temp_r[39:32],
                  crc_r[15: 8],         byte_data_temp_r[23:16],
                  crc_r[7 : 0],         byte_data_temp_r[7 : 0]
                  };
                  tx_cil_word_valid_lane2_r   <= 4'b0001;
              end 
              4 : begin
                $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[15:8]);
                dphy_pkt_r  <=  {
                  crc_r[15: 8],          byte_data_temp_r[39:32],
                  crc_r[7 : 0],          byte_data_temp_r[23:16],
                  byte_data_temp_r[15:8],byte_data_temp_r[7 : 0]
                  };
              end 
              5 : begin
                $fwrite(f,"%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[15:8],byte_data_temp_r[31:24]);
                dphy_pkt_r  <=  {
                  crc_r[7 : 0],           byte_data_temp_r[39:32],
                  byte_data_temp_r[31:24],byte_data_temp_r[23:16],
                  byte_data_temp_r[15: 8],byte_data_temp_r[7 : 0]
                  };
                wait_clock_edge;
                dphy_pkt_r  <=  {
                  8'hFF,                           8'hFF,
                  8'hFF,                           8'hFF,
                  8'hFF,                     crc_r[15: 8]
                  };
                line_disable_r              <= 4'b1110;
                tx_cil_word_valid_lane0_r   <= 4'b0001;
              end 
            endcase
          end
          else if (DATA_WIDTH == 64) begin
            case (num_bytes - byte_count)
              1:begin
                $fwrite(f,"%h\n",byte_data_temp_r[ 7: 0]);
                dphy_pkt_r  <=  {
                  8'hFF,                                  8'hFF,
                  8'hFF,                           crc_r[15: 8],
                  8'hFF,                           crc_r[7 : 0],
                  8'hFF,                byte_data_temp_r[7 : 0]
                  };
                  line_disable_r              <= 4'b1000;
                  tx_cil_word_valid_lane0_r   <= 4'b0001;
                  tx_cil_word_valid_lane1_r   <= 4'b0001;
                  tx_cil_word_valid_lane2_r   <= 4'b0001;
              end  
              2:begin
                $fwrite(f,"%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16]);
                dphy_pkt_r  <=  {
                  8'hFF,                            crc_r[15:8 ],
                  8'hFF,                            crc_r[7 :0 ],
                  8'hFF,                 byte_data_temp_r[23:16],
                  8'hFF,                 byte_data_temp_r[ 7: 0]
                  };
                  tx_cil_word_valid_lane0_r   <= 4'b0001;
                  tx_cil_word_valid_lane1_r   <= 4'b0001;
                  tx_cil_word_valid_lane2_r   <= 4'b0001;
                  tx_cil_word_valid_lane3_r   <= 4'b0001;
              end  
              3:begin
                $fwrite(f,"%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],byte_data_temp_r[39:32]);
                dphy_pkt_r  <=  {
                  8'hFF,                             crc_r[7 : 0],
                  8'hFF,                  byte_data_temp_r[39:32],
                  8'hFF,                  byte_data_temp_r[23:16],
                  crc_r[15: 8],           byte_data_temp_r[ 7: 0]
                  };
                  tx_cil_word_valid_lane0_r   <= 4'b0011;
                  tx_cil_word_valid_lane1_r   <= 4'b0001;
                  tx_cil_word_valid_lane2_r   <= 4'b0001;
                  tx_cil_word_valid_lane3_r   <= 4'b0001;
              end  
              4:begin
                $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[55:48]);
                dphy_pkt_r  <=  {
                  8'hFF,                  byte_data_temp_r[55:48],
                  8'hFF,                  byte_data_temp_r[39:32],
                  crc_r[15: 8],           byte_data_temp_r[23:16],
                  crc_r[7 : 0],           byte_data_temp_r[ 7: 0]
                  };
                  tx_cil_word_valid_lane0_r   <= 4'b0011;
                  tx_cil_word_valid_lane1_r   <= 4'b0011;
                  tx_cil_word_valid_lane2_r   <= 4'b0001;
                  tx_cil_word_valid_lane3_r   <= 4'b0001;
              end  
              5:begin
                $fwrite(f,"%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[55:48],byte_data_temp_r[15: 8]);
                dphy_pkt_r  <=  {
                  8'hFF,                   byte_data_temp_r[55:48],
                  crc_r[15: 8],            byte_data_temp_r[39:32],
                  crc_r[7 : 0],            byte_data_temp_r[23:16],
                  byte_data_temp_r[15:8],  byte_data_temp_r[ 7: 0]
                  };
                  tx_cil_word_valid_lane0_r   <= 4'b0011;
                  tx_cil_word_valid_lane1_r   <= 4'b0011;
                  tx_cil_word_valid_lane2_r   <= 4'b0011;
                  tx_cil_word_valid_lane3_r   <= 4'b0001;
              end  
              6:begin
                $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[55:48],byte_data_temp_r[15: 8],byte_data_temp_r[31:24]);
                dphy_pkt_r  <=  {
                  crc_r[15: 8],             byte_data_temp_r[55:48],
                  crc_r[7 : 0],             byte_data_temp_r[39:32],
                  byte_data_temp_r[31:24],  byte_data_temp_r[23:16],
                  byte_data_temp_r[15: 8],  byte_data_temp_r[ 7: 0]
                  };
              end  
              7:begin
                $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[55:48],byte_data_temp_r[15: 8],byte_data_temp_r[31:24],byte_data_temp_r[47:40]);
                dphy_pkt_r  <=  {
                  crc_r[ 7: 0],             byte_data_temp_r[55:48],
                  byte_data_temp_r[47:40],  byte_data_temp_r[39:32],
                  byte_data_temp_r[31:24],  byte_data_temp_r[23:16],
                  byte_data_temp_r[15: 8],  byte_data_temp_r[ 7: 0]
                  };
                wait_clock_edge;
                dphy_pkt_r  <=  {
                  8'hFF,                                  8'hFF,
                  8'hFF,                                  8'hFF,
                  8'hFF,                                  8'hFF,
                  8'hFF,                            crc_r[ 7: 0]
                  };
                  tx_cil_word_valid_lane0_r   <= 4'b0001;
                  line_disable_r              <= 4'b1110;
              end  
            endcase
          end
        end
     else begin
          dphy_pkten_r    <= 1;
          dphy_pkt_r     <= byte_data_temp_r;
          if (DATA_WIDTH ==  8) begin
            $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
            if ((byte_count + (DATA_WIDTH)/8) == num_bytes) begin
              wait_clock_edge;
              dphy_pkt_r   <= crc_r[7:0];
              wait_clock_edge;
              dphy_pkt_r   <= crc_r[15:8];
            end
          end 
          else if (DATA_WIDTH == 16) begin
            $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
            if ((byte_count + (DATA_WIDTH)/8) == num_bytes) begin
              wait_clock_edge;
              dphy_pkt_r   <= crc_r;
            end
          end
          else if (DATA_WIDTH == 24) begin
 //            $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[23:16]);
            $fwrite(f,"%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[23:16]);
            if ((byte_count + (DATA_WIDTH)/8) == num_bytes) begin
                wait_clock_edge;
                dphy_pkt_r      <= {8'hFF,crc_r};
                line_disable_r  <= 4'b1100;
              end
          end 
          else if (DATA_WIDTH == 32) begin
            if (GEAR == 8) begin
              $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[23:16],byte_data_temp_r[31:24]);
              if ((byte_count + (DATA_WIDTH)/8) == num_bytes) begin
                wait_clock_edge;
                dphy_pkt_r      <= {16'hFF,crc_r};
                line_disable_r  <= 4'b1100;
              end
            end
            else if (GEAR == 16) begin
              $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[15:8],byte_data_temp_r[31:24]);
              if ((byte_count + (DATA_WIDTH)/8) == num_bytes) begin
                wait_clock_edge;
                dphy_pkt_r                    <= {8'hFF,crc_r[15:8],8'hFF,crc_r[7:0]};
                tx_cil_word_valid_lane0_r     <= 4'b0001;
                tx_cil_word_valid_lane1_r     <= 4'b0001;
              end
            end
          end 
          else if (DATA_WIDTH == 48) begin
 //            $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[15:8],byte_data_temp_r[31:24],byte_data_temp_r[47:40]);
            $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[23:16],byte_data_temp_r[39:32],byte_data_temp_r[15:8],byte_data_temp_r[31:24],byte_data_temp_r[47:40]);
              if ((byte_count + (DATA_WIDTH)/8) == num_bytes) begin
                wait_clock_edge;
                dphy_pkt_r      <= {8'hFF,crc_r};
                line_disable_r  <= 4'b1100;
                tx_cil_word_valid_lane0_r     <= 4'b0001;
                tx_cil_word_valid_lane1_r     <= 4'b0001;
              end
          end
          else if (DATA_WIDTH == 64) begin
            $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n%h\n%h\n", byte_data_temp_r[ 7: 0],
                                                                  byte_data_temp_r[23:16],
                                                                  byte_data_temp_r[39:32],
                                                                  byte_data_temp_r[55:48],
                                                                  byte_data_temp_r[15: 8],
                                                                  byte_data_temp_r[31:24],
                                                                  byte_data_temp_r[47:40],
                                                                  byte_data_temp_r[63:56]);
            if ((byte_count + (DATA_WIDTH)/8) == num_bytes) begin
              wait_clock_edge;
              dphy_pkt_r                    <= {32'hFF,8'hFF,crc_r[15:8],8'hFF,crc_r[7:0]};
              tx_cil_word_valid_lane0_r     <= 4'b0001;
              tx_cil_word_valid_lane1_r     <= 4'b0001;
              line_disable_r                <= 4'b1100;
            end
          end
     end
     display_data(dphy_pkt_r);
     wait_clock_edge;
     byte_count       = byte_count + (DATA_WIDTH)/8;
    end
    // wait_clock_edge;
    // if (!footer_sant_r) begin
    //   dphy_pkten_r    <= 1;
    //   if (DATA_WIDTH == 8) begin
    //     wait_clock_edge;
    //     dphy_pkt_r   <= crc_r[7:0]; 
    //     wait_clock_edge;
    //     dphy_pkt_r   <= crc_r[15:8]; 
    //   end
    //   else if (DATA_WIDTH == 16) begin
    //     wait_clock_edge;
    //     dphy_pkt_r   <= {crc_r};
    //   end
    //   else if (DATA_WIDTH == 32) begin
    //     if (GEAR == 8) begin
    //       dphy_pkt_r      <= {16'hFF,crc_r};
    //       line_disable_r  <= 4'b1100;
    //     end
    //     else begin
    //       wait_clock_edge;
    //       dphy_pkt_r   <= {8'hFF,crc_r[15:8],8'hFF,crc_r[7:0]};
    //     end
    //   end
    //   else if (DATA_WIDTH == 64) begin
    //     wait_clock_edge;
    //     dphy_pkt_r   <= {32'hFF,8'hFF,crc_r[15:8],8'hFF,crc_r[7:0]};
    //   end
    // end
    footer_sant_r              <= 0;
    byte_count                  = 0;
    d_hs_en_r                  <= 0;
    dphy_pkten_r               <= 0;
    dphy_pkt_r                 <= 0;
    repeat(15) wait_clock_edge;
    clk_hs_en_r                <= 0;
    
    $display("%0t Transmit video data DONE!",$realtime);
    
    if (DEBUG_ON == "ON") begin
      $display("%0t drive_lpkt END",$realtime);
    end
  end
endtask

task drive_vsync_st_cil();
  begin
    ///
    if(DEBUG_ON == "ON") $display("%0t drive_vsync_st START",$realtime);
    ///
    wait4ready_cil;
    $display("%0t Transmitting vsync start",$realtime);
    ///
    dt_r        <= 6'h01;
    vc_r        <= VIRTUAL_CHANNEL;
    ///
    wait_clock_edge;
    eotp_r        <= (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI")? 1'd1 : 1'd0;
    vsync_start_r <= 1;
    wait_clock_edge;
    vsync_start_r <= 0;
    ///
    if(DEBUG_ON == "ON") $display("%0t drive_vsync_st END",$realtime);
    ///
    // while(d_hs_rdy_i == 1'd1) begin
      // wait_clock_edge;
    // end
    ///
  end
endtask

task drive_hsync_st_cil();
  begin
    $display("%0t Transmitting hsync start",$realtime);
    if(DEBUG_ON == "ON") $display("%0t drive_hsync_st START",$realtime);
    ///
    wait4ready_cil;
    ///
    dt_r          <= 6'h21;
    vc_r          <= VIRTUAL_CHANNEL;
    ///
    wait_clock_edge;
    eotp_r          <= (EOTP_ENABLE == "ON" && DEVICE_TYPE == "DSI")? 1'd1 : 1'd0;
    hsync_start_r   <= 1;
    wait_clock_edge;
    hsync_start_r   <= 0;
    ///
    if(DEBUG_ON == "ON") $display("%0t drive_hsync_st END",$realtime);
    ///
    // while(d_hs_rdy_i == 1'd1) begin
      // wait_clock_edge;
    // end
    ///
  end
endtask

task drive_byte_cil();
  begin
    ///
    $display("%0t Transmitting video data, data type : %0h , word count = %0d ...",$realtime,DATA_TYPE,num_bytes);
    ///
    wait4ready_cil;
    ///
    dt_r            <= DATA_TYPE;
    wc_r            <= num_bytes;
    ///
    lp_en_r           <= 1'd1;
    byte_data_en_r    <= 1'd1;
    byte_count        <= 1'd0;
    ///
    while(byte_count < num_bytes) begin
      byte_data_temp_r = $random;
      if (num_bytes - byte_count < (GEAR*NUM_TX_LANE)/8) begin
        case(num_bytes - byte_count)
          16'd1 : $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
          16'd2 : $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
          16'd3 : $fwrite(f,"%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[23:16]);
          16'd4 : $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[23:16],byte_data_temp_r[31:24]);
          16'd5 : $fwrite(f,"%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[15: 8],byte_data_temp_r[23:16],byte_data_temp_r[31:24],byte_data_temp_r[39:32]);
          16'd6 : $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[15: 8],byte_data_temp_r[23:16],byte_data_temp_r[31:24],byte_data_temp_r[39:32],byte_data_temp_r[47:40]);
          16'd7 : $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[15: 8],byte_data_temp_r[23:16],byte_data_temp_r[31:24],byte_data_temp_r[39:32],byte_data_temp_r[47:40],byte_data_temp_r[55:48]);
        endcase
      end
      else begin
        if (DATA_WIDTH ==  8) begin
          $fwrite(f,"%h\n",byte_data_temp_r[7:0]);
        end else
        if (DATA_WIDTH == 16) begin
          $fwrite(f,"%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8]);
        end else
        if (DATA_WIDTH == 32) begin
          $fwrite(f,"%h\n%h\n%h\n%h\n",byte_data_temp_r[7:0],byte_data_temp_r[15:8],byte_data_temp_r[23:16],byte_data_temp_r[31:24]);
        end else
        if (DATA_WIDTH == 64) begin
          $fwrite(f,"%h\n%h\n%h\n%h\n%h\n%h\n%h\n%h\n",byte_data_temp_r[ 7: 0],byte_data_temp_r[15: 8],byte_data_temp_r[23:16],byte_data_temp_r[31:24],
                                                               byte_data_temp_r[39:32],byte_data_temp_r[47:40],byte_data_temp_r[55:48],byte_data_temp_r[63:56]);
        end
      end
      byte_data_r     <= byte_data_temp_r;
      display_data(byte_data_r);
      wait_clock_edge;
        byte_count     = byte_count + (GEAR*NUM_TX_LANE)/8;
    end
    ///
    byte_count        <= 1'd0;
    byte_data_en_r    <= 1'd0;
    byte_data_r       <= 1'd0;
    lp_en_r           <= 1'd0;
    $display("%0t Transmitting video data DONE!",$realtime);
  end
endtask

task wait4ready_cil();
  begin
    wait_clock_edge;
    while(d_hs_rdy_i == 1'd0) begin
      wait_clock_edge;
    end
    repeat (16) wait_clock_edge;
  end
endtask

task drive_sp_cil(input [5:0] dtype);
  begin
    ///
    $display("%0t Transmitting short packet : %0h",$realtime,dtype);
    ///
    if(DEBUG_ON == "ON") $display("%0t drive_sp START",$realtime);
    ///
    wait4ready_cil;
    ///
    dt_r          <= dtype;
    vcx_r         <= EXTVIRTUAL_CHANNEL;
	vc_r          <= VIRTUAL_CHANNEL;
    ///
    if (GEN_FR_NUM == "ON") begin
      if (dtype == 6'h00) begin
        wc_r[1:0] <= fs_num_r;
      end
      else if(dtype == 6'h01) begin
        wc_r[1:0] <= fs_num_r;
        fs_num_r     = fs_num_r^2'b11;
        ls_num_r     = 1;
      end
    end
    if(GEN_LN_NUM == "ON") begin
      if(dtype == 6'h02) begin
        wc_r      <= ls_num_r;
      end
      else if(dtype == 6'h03) begin
        wc_r      <= ls_num_r;
        ls_num_r     = ls_num_r+1;
      end
    end
    wait_clock_edge; 
    sp_en_r         <= 1;
    wait_clock_edge; 
    sp_en_r         <= 0;
    ///
    if(DEBUG_ON == "ON")$display("%0t drive_sp END",$realtime);
    ///
  end
endtask

task drive_lp_cil();
  begin
    ///
    if(DEBUG_ON == "ON") $display("%0t drive_lp START",$realtime);
    ///
    wait4ready_cil;
    ///
    dt_r    <= DATA_TYPE;
    vcx_r   <= EXTVIRTUAL_CHANNEL;
    vc_r    <= VIRTUAL_CHANNEL;
    wc_r    <= num_bytes;
    ///
    wait_clock_edge;
    lp_en_r   <= 1;
    wait_clock_edge;
    lp_en_r   <= 0;
    ///
    if(DEBUG_ON == "ON") $display("%0t drive_lp END",$realtime);
  end
endtask
/////////////////////////////////////////////////////////////
/// CIL tasks End
/////////////////////////////////////////////////////////////

endmodule
//==============================================================================
// lscc_dphy_tx_model.v
//==============================================================================
`endif
