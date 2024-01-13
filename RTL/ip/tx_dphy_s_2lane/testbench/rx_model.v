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
// File                  : rx_model.v
// Title                 :
// Dependencies          : 1.
//                       : 2.
// Description           :
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0
// Author(s)             : 
// Mod. Date             : 03/19/2019
// Changes Made          : Initial version
// -----------------------------------------------------------------------------
// Version               : 1.1
// Author(s)             : 
// Mod. Date             : 04/09/2019
// Changes Made          : Now model will write timing parameters values in file.
//                       : Also will check timing values.
// =============================================================================

`timescale 1ns/1ps

`ifndef RX_MODEL
`define RX_MODEL
module rx_model #
// -----------------------------------------------------------------------------
// Module Parameters
// -----------------------------------------------------------------------------
(
parameter            NUM_LANE     = 4,
parameter            CLK_MODE     = "CONTINUOUS",
parameter            HEADER_CHECK = "ON",
parameter            EOTP_CHECK   = "ON",
parameter            CRC_CHECK    = "ON",
parameter            INTF_TYPE    = "CSI2",
parameter            FRAME_CNT_EN = "ON",
parameter            NUM_FRAMES   = 3,
parameter            HS0_TIMEOUT  = 999999999,/// test
parameter            DPHY_IP      = "MIXEL",
parameter            GEAR         = 8,
parameter            CIL_BYPASS   = "CIL_BYPASSED"
)
// -----------------------------------------------------------------------------
// Input/Output Ports
// -----------------------------------------------------------------------------
(
input                reset_i,         // Reset
input                c_p_i,           // Positive part of clock.
input                c_n_i,           // Negative part of clock.
input [NUM_LANE-1:0] d_p_i,           // Positive part of data.
input [NUM_LANE-1:0] d_n_i            // Negative part of data.
);

// -----------------------------------------------------------------------------
// Local Parameters
// -----------------------------------------------------------------------------
localparam [31:0] EOTP_VAL   = 32'h010F0F08;
// -----------------------------------------------------------------------------
// Generate Variables
// -----------------------------------------------------------------------------
integer tx_output_data_file;
integer write_file_timing;
integer i;
/// Global variables for timing parameters
time global_T_LPX;
time global_HS_prepare;
time global_HS_zero;
time global_HS_trail;
time global_UI;
///
integer global_failed_cases = 0;
integer global_passed_cases = 0;
///
integer global_EoTp_SP_failed_cases = 0;
integer global_EoTp_SP_passed_cases = 0;
///
integer global_EoTp_LP_failed_cases = 0;
integer global_EoTp_LP_passed_cases = 0;
///
integer global_CRC_failed_cases = 0;
integer global_CRC_passed_cases = 0;
///
integer global_SOT_failed_cases = 0;
integer global_SOT_passed_cases = 0;
///
integer global_EOT_bit_failed_cases = 0;
integer global_EOT_bit_passed_cases = 0;
///
integer global_ECC_failed_cases = 0;
integer global_ECC_passed_cases = 0;
///
integer global_FRAME_NUMBER_failed_cases = 0;
integer global_FRAME_NUMBER_passed_cases = 0;
///
///
integer timing_param_fail = 0;

// -----------------------------------------------------------------------------
// Combinatorial Registers
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Sequential Registers
// -----------------------------------------------------------------------------
reg                short_packet           =  1'd0;
reg                eotb                   =  1'd0;            /// Register used to close a file after TB top module request
reg         [31:0] header_r               = 32'd0;
reg         [ 1:0] virtual_chanel_r       =  2'd0;
reg         [ 5:0] data_type_r            =  6'd0;
reg         [15:0] word_count_r           = 16'd0;
reg         [ 5:0] ecc_calc               =  6'd0;
reg         [ 7:0] ecc_r                  =  8'd0;
reg [NUM_LANE-1:0] data_register_p_r      = {NUM_LANE{1'd0}}; /// Register used to check trail bits
reg [NUM_LANE-1:0] data_register_n_r      = {NUM_LANE{1'd0}}; /// Register used to check trail bits
reg         [15:0] frame_count_r          = 16'd0;
reg         [15:0] line_count_r           = 16'd0;
reg         [15:0] exp_frame_count_r      = 16'd0;
reg         [15:0] exp_line_count_r       = 16'd0;
reg         [15:0] packet_count_r         = 16'd1;
/// For CRC check
reg         [15:0] calculated_crc_r       = 16'd0;
reg                calculated_crc_valid_r =  1'd0;
reg         [15:0] received_crc_r         = 16'd0;
reg                received_crc_valid_r   =  1'd0;
///
reg                clk_state_hs_lpn;
/// for eot bit check
reg [         7:0] byte_data0_r,byte_data0_r1,byte_data0_r2;
reg [         7:0] byte_data1_r,byte_data1_r1,byte_data1_r2;
reg [         7:0] byte_data2_r,byte_data2_r1,byte_data2_r2;
reg [         7:0] byte_data3_r,byte_data3_r1,byte_data3_r2;
reg [        15:0] cil_bytes_header_0 = 16'd0;
reg [        15:0] cil_bytes_header_1 = 16'd0;
reg [        15:0] tmp_r;
reg                eotp_check_start;
reg                eotp_check_start1;
reg                eotp_check_start2;
reg                eotp_check_start3;
reg                eotp_check_start4;
reg                eotp_check_start5;
reg [NUM_LANE-1:0] toggle_datap;
reg [NUM_LANE-1:0] toggle_datan;
reg                pass_fail_r;

// -----------------------------------------------------------------------------
// Wire Declarations
// -----------------------------------------------------------------------------
   
// -----------------------------------------------------------------------------
// Assign Statements
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Generate Assign Statements
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Submodule Instantiations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Combinatorial Blocks
// -----------------------------------------------------------------------------
always begin
  ///
  reset;                            /// Reset
  ///
  wait4LPstart;                     /// Check Timing parameters in data lines
  ///
  wait4B8;                          /// Shifted data to detect B8 sync char
  ///
  if (!wait4B8.sync_error) begin
  readheader;                       /// Reads header
  ///
  if (short_packet == 1'd0) begin   /// For Long packet EoT checks in task below
    readbyte;                       /// Reads payload data , footer and EoTp
  end
    else if (EOTP_CHECK == "ON") begin
      eotpcheck;                    /// Checks EoTp after short packet
    end
  end
  ///
  wait4LP11;                       /// Check trail time in data line and wait for LP-11
  ///
end

always begin
  crc_calc;
end

always @(posedge calculated_crc_valid_r or posedge received_crc_valid_r) begin
  if (calculated_crc_valid_r && received_crc_valid_r) begin
    #1;
    if (CRC_CHECK == "ON") begin
      if (calculated_crc_r == received_crc_r) begin
        global_CRC_passed_cases = global_CRC_passed_cases + 1;
      end
      else begin
        global_CRC_failed_cases = global_CRC_failed_cases + 1;
      end
    end
    #1;
    calculated_crc_valid_r = 1'd0;
    received_crc_valid_r   = 1'd0;
  end
end

always begin
    data_register_p_r <= d_p_i;
    data_register_n_r <= d_n_i;
    wait4clk(1);
end
// always begin
//     data_register_p_r_1 <= d_p_i;
//     data_register_n_r_1 <= d_n_i;
//     wait4clk();
// end


//////////////////////////////////////////////////////////////////////////////////
/// • 
/// • DPHY Tx Changes
/// • Date June 2, 2019
/// • 
/// • clk_state_hs_lpn 1 indicates that clock is in high speed mode.
///   Checker from tb (line 146) give error if clk_hs_en_i is 1 but clock in LP mode.
//////////////////////////////////////////////////////////////////////////////////

// initial begin
  // clk_state_hs_lpn = 1'dx;
  // #100;
  // if (CLK_MODE == "CONTINUOUS") begin
    // clk_state_hs_lpn = 1'd1;
  // end
  // else begin
      // clk_state_hs_lpn = 1'd0;
      // while (!(c_p_i & c_n_i)) begin
        // #1;
      // end
    // forever begin
      // clk_state_hs_lpn = 1'd0;
      // while (!(!c_p_i & c_n_i)) begin
        // #1;
      // end
      // while (!(!c_p_i & !c_n_i)) begin
        // #1;
      // end
      // while (!(!c_p_i & c_n_i)) begin
        // #1;
      // end
      // while (!(c_p_i & !c_n_i)) begin
        // #1;
      // end
      // clk_state_hs_lpn = 1'd1;
      // while (!(c_p_i & c_n_i)) begin
        // #1;
      // end
        // #1;
    // end
  // end
// end

// -----------------------------------------------------------------------------
// Generate Combinatorial Blocks
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Sequential Blocks
// -----------------------------------------------------------------------------
initial begin
  tx_output_data_file   = $fopen("rx_model_data.txt","w"); // file where writes DPHY_TX's output data
  write_file_timing     = $fopen("rx_model_timing.txt","w"); // file where writes DPHY_TX's output data
  $fwrite(write_file_timing,"TIMING VALUES OF DATA LINES\n");
  $fwrite(write_file_timing,"START\n");
  @(posedge eotb);
  // $fwrite(tx_output_data_file,"END\n");
  $fclose(tx_output_data_file);
  if (timing_param_fail == 0) begin
    $fwrite(write_file_timing,"ALL TIMING PARAMETERS PASS\n");
  end
  else begin
    $fwrite(write_file_timing,"%d PARAMETERS FAILED \n",timing_param_fail);
  end
  $fclose(write_file_timing);
end

initial begin
  eotpcheck_after_lp.in_process = 0; // Added to fix Modelsim issue
  readbyte.in_process = 0;
  readbyte.byte_count = 16'd0;
  readbyte.data       = {8*NUM_LANE{1'd0}};
  readbyte.byte1      = 0; 
  readbyte.byte2      = 0; 
  readbyte.byte3      = 0; 
  readbyte.byte4      = 0;
  readbyte.byte1r     = 0; 
  readbyte.byte2r     = 0; 
  readbyte.byte3r     = 0; 
  readbyte.byte4r     = 0; 
  readbyte.crc_en     = 0;
  byte_data0_r        = 8'd0;
  byte_data1_r        = 8'd0;
  byte_data2_r        = 8'd0;
  byte_data3_r        = 8'd0;
  byte_data0_r1       = 8'd0;
  byte_data1_r1       = 8'd0;
  byte_data2_r1       = 8'd0;
  byte_data3_r1       = 8'd0;
  byte_data0_r2       = 8'd0;
  byte_data1_r2       = 8'd0;
  byte_data2_r2       = 8'd0;
  byte_data3_r2       = 8'd0;
  eotp_check_start    = 1'd0;
  eotp_check_start1   = 1'd0;
  eotp_check_start2   = 1'd0;
  eotp_check_start3   = 1'd0;
  eotp_check_start4   = 1'd0;
  eotp_check_start5   = 1'd0;
  pass_fail_r         = 1'd0;
  toggle_datap        = 'dz;
  toggle_datan        = 'dz;
end

 
always begin
  while (!reset_i) begin
    #1;
  end
  @(posedge readbyte.in_process);
    wait4byteclk(((word_count_r)/NUM_LANE) + ((4/NUM_LANE)*(EOTP_CHECK == "ON")));
    eotp_check_start  = 1'd1;
    wait4byteclk(1);
    eotp_check_start1 = 1'd1;
    wait4byteclk(1);
    eotp_check_start2 = 1'd1; 
    @(negedge wait4LP11.start);
    eotp_check_start  = 1'd0;
    eotp_check_start1 = 1'd0;
    eotp_check_start2 = 1'd0;
end


always begin
  @(posedge eotp_check_start);
  if (NUM_LANE == 4) begin
    if (word_count_r[1:0] == 2'd0) begin
      toggle_datap = {~data_register_p_r[3:2],2'bzz};
      toggle_datan = {~data_register_n_r[3:2],2'bzz};
      while (!eotp_check_start1 && !pass_fail_r) begin
        if (d_p_i[3:2] == toggle_datap[3:2]) begin
          // pass_fail_r = 0;
        end
        else begin
          pass_fail_r = 1;
        end
          wait4clk(1);
      end
      toggle_datap = { data_register_p_r[3:2],~data_register_p_r[1:0]};
      toggle_datan = { data_register_n_r[3:2],~data_register_n_r[1:0]};
      while (!(d_p_i &  d_n_i)) begin
        if (d_p_i[3:0] == toggle_datap[3:0] && !pass_fail_r) begin
          // pass_fail_r = 0;
        end
        else begin
          pass_fail_r = 1;
        end 
          wait4clk(1);
      end
    end
    else if (word_count_r[1:0] == 2'd1) begin
      toggle_datap = {~data_register_p_r[3],3'bzzz};
      toggle_datan = {~data_register_n_r[3],3'bzzz};
      while (!eotp_check_start1 && !pass_fail_r) begin
        if (d_p_i[3] == toggle_datap[3]) begin
          // pass_fail_r = 0;
        end
        else begin
          pass_fail_r = 1;
        end
          wait4clk(1);
      end
      toggle_datap = { data_register_p_r[3],~data_register_p_r[2:0]};
      toggle_datan = { data_register_n_r[3],~data_register_n_r[2:0]};
      while (!(d_p_i &  d_n_i) && !pass_fail_r) begin
        if (d_p_i[3:0] == toggle_datap[3:0]) begin
          // pass_fail_r = 0;
        end
        else begin
          pass_fail_r = 1;
        end 
          wait4clk(1);
      end
    end
    else if (word_count_r[1:0] == 2'd2) begin
      // toggle_datap = {~data_register_p_r[3],3'b000};
      // toggle_datan = {~data_register_n_r[3],3'b111};
      while (!eotp_check_start1) begin
        // if (d_p_i[3] == toggle_datap[3]) begin
          // pass_fail_r = 0;
        // end
        // else begin
          // pass_fail_r = 1;
        // end
          wait4clk(1);
      end
      toggle_datap = { ~data_register_p_r[3:0]};
      toggle_datan = { ~data_register_n_r[3:0]};
      while (!(d_p_i &  d_n_i) && !pass_fail_r) begin
        if (d_p_i[3:0] == toggle_datap[3:0]) begin
          // pass_fail_r = 0;
        end
        else begin
          pass_fail_r = 1;
        end 
          wait4clk(1);
      end
    end
    else if (word_count_r[1:0] == 2'd3) begin
      @(posedge eotp_check_start1);
      toggle_datap = {~data_register_p_r[3:1],1'bz};
      toggle_datan = {~data_register_n_r[3:1],1'bz};
      while (!eotp_check_start2 && !pass_fail_r) begin
        if (d_p_i[3:1] == toggle_datap[3:1]) begin
          pass_fail_r = 0;
        end
        else begin
          pass_fail_r = 1;
        end
          wait4clk(1);
      end
      toggle_datap = { data_register_p_r[3:1],~data_register_p_r[0]};
      toggle_datan = { data_register_n_r[3:1],~data_register_n_r[0]};
      while (!(d_p_i &  d_n_i) && !pass_fail_r) begin
        if (d_p_i[3:0] == toggle_datap[3:0]) begin
          pass_fail_r = 0;
        end
        else begin
          pass_fail_r = 1;
        end 
          wait4clk(1);
      end
    end
  end
  else if (NUM_LANE == 2) begin
    if (word_count_r[0] == 2'd0) begin
      @(posedge eotp_check_start1);
      // toggle_datap = {~data_register_p_r[1:0]};
      // toggle_datan = {~data_register_n_r[1:0]};
      // while (!eotp_check_start2 && !pass_fail_r) begin
        // if (d_p_i[1:0] == toggle_datap[1:0]) begin
          // pass_fail_r = 0;
        // end
        // else begin
          // pass_fail_r = 1;
        // end
          // wait4clk(1);
      // end
      toggle_datap = {~data_register_p_r[1:0]};
      toggle_datan = {~data_register_n_r[1:0]};
      while (!(d_p_i &  d_n_i) && !pass_fail_r) begin
        if (d_p_i[1:0] == toggle_datap[1:0]) begin
          // pass_fail_r = 0;
        end
        else begin
          pass_fail_r = 1;
        end 
          wait4clk(1);
      end
    end
    else if (word_count_r[0] == 2'd1) begin
      @(posedge eotp_check_start1);
      toggle_datap = {~data_register_p_r[1],1'bx};
      toggle_datan = {~data_register_n_r[1],1'bx};
      while (!eotp_check_start2 && !pass_fail_r) begin
        if (d_p_i[1] == toggle_datap[1]) begin
          pass_fail_r = 0;
        end
        else begin
          pass_fail_r = 1;
        end
        wait4clk(1);
      end
      toggle_datap = {data_register_p_r[1],~data_register_p_r[0]};
      toggle_datan = {data_register_n_r[1],~data_register_n_r[0]};
      while (!(d_p_i &  d_n_i) && !pass_fail_r) begin
        if (d_p_i[1:0] == toggle_datap[1:0]) begin
          pass_fail_r = 0;
        end
        else begin
          pass_fail_r = 1;
        end 
        wait4clk(1);
      end
    end
  end
  else if (NUM_LANE == 1) begin
    @(posedge eotp_check_start2);
    // while (!eotp_check_start1) begin
      // if (d_p_i[1:0] == toggle_datap[1:0]) begin
        // pass_fail_r = 0;
      // end
      // else begin
        // pass_fail_r = 1;
      // end
    //     wait4clk(1);
    // end
    toggle_datap = {~data_register_p_r[0]};
    toggle_datan = {~data_register_n_r[0]};
    while (!(d_p_i &  d_n_i) && !pass_fail_r) begin
      if (d_p_i[0] == toggle_datap[0]) begin
        // pass_fail_r = 0;
      end
      else begin
        pass_fail_r = 1;
      end 
        wait4clk(1);
    end
  end
  #1000;
  global_EOT_bit_passed_cases = global_EOT_bit_passed_cases + !pass_fail_r;
  global_EOT_bit_failed_cases = global_EOT_bit_failed_cases +  pass_fail_r;
  pass_fail_r                 = 1'd0;
  #1000;
end

// -----------------------------------------------------------------------------
// Generate Sequential Blocks
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Submodule Instantiations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

// Task Declarations
// -----------------------------------------------------------------------------
task wait4clk(
  input [15:0] cycle
  );
  begin
    repeat (cycle) begin
      @(c_p_i);
    end
  end
endtask

task wait4byteclk(
  input [15:0] cycle
  );
  begin
    repeat (cycle) begin
      wait4clk(8);
    end
  end
endtask

task wait4LPstart_Clock();
  reg LP11;
  reg LP01;
  reg LP00;
  reg HS0;
  begin
    ///
    LP11  = 0;
    LP01  = 0;
    LP00  = 0;
    HS0   = 0;
    ///
    while (!LP11) begin
      LP11 = c_p_i & c_n_i;
    #1;
    end
    while (!LP01) begin
      LP01 = !c_p_i & c_n_i;
    #1;
    end
    while (!LP00) begin
      LP00 = !c_p_i & !c_n_i;
    #1;
    end
    while (!HS0) begin
      HS0  = !c_p_i & c_n_i;
    #1;
    end
  end
endtask

task wait4LPstart();
  reg  start; /// For debug
  reg  ZZZ;   /// For debug
  time start_time;
  time time_start;
  time time_end;
  reg  LP11;  ///
  reg  LP01;  ///
  reg  LP00;  ///
  reg  HS0;   ///
  reg  tinit;
  reg  timout;
  reg  init;
  integer hs0_time;
  begin
    /////////Wait ~ for Tinit
    // if (tinit === 1'dx) begin
      // #1000000;
      // tinit     = 0;
    // end
    /////////END
    /////////INITIAL ASSIGN
    start       = 1;
    #1; /// For test
    start_time  = $realtime;
    ZZZ         = 0;
    LP11        = 0;
    LP01        = 0;
    LP00        = 0;
    HS0         = 0;
    timout      = 0;
    hs0_time    = 0;
    init        = 0;
    /////////END
    /////////Wait while Data lines in HI-impedance state
    // while (d_p_i === {NUM_LANE{1'dz}} & d_n_i === {NUM_LANE{1'dz}}) begin
      // ZZZ = 1;
      // #1000;
    // end
    ZZZ = 0;
    /////////END
    $fwrite(write_file_timing,"Wait for new packet\n");
    $fwrite(write_file_timing,"☺________________________________________☺\n");
    $fwrite(write_file_timing,"TIME ` %t\n",$realtime);
    /////////LP 11
    time_start  = $realtime;
    LP11        = 1;
    
    if (CLK_MODE == "NON_CONTINUOUS" && CIL_BYPASS == "CIL_BYPASSED") begin
      wait4LPstart_Clock();
    end
    
    
    while (!init) begin
      init = (d_p_i === {NUM_LANE{1'd1}} & d_n_i === {NUM_LANE{1'd1}});
      #1;
    end
    
    while ((d_p_i === {NUM_LANE{1'd1}} & d_n_i === {NUM_LANE{1'd1}}) || (d_p_i === {NUM_LANE{1'dz}} & d_n_i === {NUM_LANE{1'dz}})) begin
      #1;
    end
    LP11 = 0;
    time_end  = $realtime;
    $fwrite(write_file_timing,"LP-11      = %t \n",(time_end-time_start));
    /////////END
    /////////LP 01
    time_start  = $realtime;
    LP01 = 1;
    while (d_p_i === {NUM_LANE{1'd0}} & d_n_i === {NUM_LANE{1'd1}}) begin
      #1;
    end
    LP01          = 0;
    time_end      = $realtime;
    global_T_LPX  = time_end-time_start;
    $fwrite(write_file_timing,"TLPX       = %t \n",global_T_LPX);
    /////////END
    /////////LP 00
    time_start  = $realtime;
    LP00 = 1;
    while (d_p_i === {NUM_LANE{1'd0}} & d_n_i === {NUM_LANE{1'd0}}) begin
      #1;
    end
    LP00              = 0;
    time_end          = $realtime;
    global_HS_prepare = time_end-time_start;
    $fwrite(write_file_timing,"HS-prepare = %t \n",global_HS_prepare);
    /////////END
    /////////HS 0
    time_start  = $realtime;
    HS0 = 1;
    while (d_p_i === {NUM_LANE{1'd0}} & d_n_i === {NUM_LANE{1'd1}} & !timout) begin
      #0.1;
      hs0_time = hs0_time + 0.1;
      timout=  (hs0_time > HS0_TIMEOUT);
    end
    HS0             = 0;
    time_end        = $realtime;
    global_HS_zero  = time_end-time_start;
    $fwrite(write_file_timing,"HS-0       = %t \n",global_HS_zero);
    /////////END
    start = 0;
  end
endtask

task wait4LP11();
  reg                start; /// For debug
  reg                LP11;
  reg                print_1_time;
  reg [NUM_LANE-1:0] toggled_bit_p;
  reg [NUM_LANE-1:0] toggled_bit_n;
  time trail_start;
  time trail_end;
  begin
    start         = 1'd1;
    LP11          = 0;
    print_1_time  = 0;
    trail_start   = $realtime;
    while (!(d_p_i &  d_n_i)) begin
      #1;
    end
    trail_end                   = $realtime;
    global_HS_trail             = trail_end - trail_start;
    $fwrite(write_file_timing,"HS-Trail   = %t \n",global_HS_trail);
    start = 1'd0;
    check_tim_par();
  end
endtask

task check_tim_par();
  integer pass;
  integer fail;
  begin
    pass = 0;
    fail = 0;
    ///
    if (global_T_LPX >= 50) begin
      pass = pass + 1;
    end
    else begin
      fail = fail + 1;
      $fwrite(write_file_timing,"***ERROR*** TLPX is %t but must be maximum 50 \n",global_T_LPX);
    end
    ///
    if (global_HS_prepare >= (40 + 4*global_UI)) begin
      if (global_HS_prepare <= (85 + 6*global_UI)) begin
        pass = pass + 1;
      end
      else begin
        $fwrite(write_file_timing,"***ERROR*** HS_prepare is %t but must be maximum %t \n",global_HS_prepare,(85 + 6*global_UI));
        fail = fail + 1;
      end
    end
    else begin
      $fwrite(write_file_timing,"***ERROR*** HS_prepare is %t but must be minimum %t \n",global_HS_prepare,(40 + 4*global_UI));
      fail   = fail + 1;
    end
    ///
    if ((global_HS_zero + global_HS_prepare) >= (145 + 10*global_UI)) begin
      pass   = pass + 1;
    end
    else begin
      fail = fail + 1;
      $fwrite(write_file_timing,"***ERROR*** HS_prepare + HS_zero is %t but must be minimum %t \n",(global_HS_zero + global_HS_prepare),(145 + 10*global_UI));
    end
    ///
    if (global_HS_trail > (60 + 4*global_UI)) begin
      pass   = pass + 1;
    end
    else begin
      fail   = fail + 1;
      $fwrite(write_file_timing,"***ERROR*** HS_trail is %t but must be minimum %t \n",global_HS_trail,(60 + 4*global_UI));
    end
    ///
    timing_param_fail = timing_param_fail + fail;
    global_passed_cases = global_passed_cases + pass;
    global_failed_cases = global_failed_cases + fail;
    $fwrite(write_file_timing,"TIME ` %t\n",$realtime);
    $fwrite(write_file_timing,"☺________________________________________☺\n");
    $fwrite(write_file_timing,"Packet received \n");
  end
endtask

task wait4B8();
  reg       in_process;
  ///
  reg       UI;
  real      UI_start;
  real      UI_end;
  ///
  reg [7:0] B8_r;
  reg       data_1_bit;
  reg       sync_error;
  begin
    in_process   = 1;
    sync_error   = 0;
    B8_r         = 8'h00;
    fork
      begin /// B8 detecting
        while (B8_r != 8'hB8 & !sync_error) begin
          wait4clk(1);
          /// 
          data_1_bit = d_p_i; /// Fixed for Lattice(d_p_i ^ d_n_i)? d_p_i & !d_n_i : 1'dx;
          B8_r       = {data_1_bit,B8_r[7:1]};
          if (!(B8_r == 8'h00 |
                B8_r == 8'h80 |
                B8_r == 8'hC0 |
                B8_r == 8'hE0 |
                B8_r == 8'h70 |
                B8_r == 8'hB8
            )) begin
          sync_error = 1;
          global_SOT_failed_cases = global_SOT_failed_cases + 1;
        end
        end
        if (!sync_error) begin
          global_SOT_passed_cases = global_SOT_passed_cases + 1;
        end
        wait4clk(1);
      end
      ///
      begin /// UIalculating UI 
        wait4clk(2);
        UI_start  = $realtime;
        wait4clk(1);
        UI_end    = $realtime;
        global_UI = UI_end-UI_start;
        $fwrite(write_file_timing,"UI         = %t \n",global_UI);
      end
    join
    B8_r         = 8'd0;
    in_process   = 0;
  end
endtask

task readheader();
  reg in_process;
  begin
    in_process = 1;
    if (NUM_LANE == 3) begin
      for (i = 0; i <= 15; i = i + 1) begin
        if (i <= 7) begin
          header_r[ 0 + i] = d_p_i[0];
          header_r[ 8 + i] = d_p_i[1];
          header_r[16 + i] = d_p_i[2];
        end
        else begin
          header_r[16 + i] = d_p_i[0];
          cil_bytes_header_0[0 + i] = d_p_i[1];
          cil_bytes_header_1[0 + i] = d_p_i[2];
        end
        wait4clk(1);
      end  
    end else begin
      for (i = 0; i <= (32/NUM_LANE)-1; i = i + 1) begin
        if (NUM_LANE == 4) begin
          header_r[ 0 + i]   = d_p_i[0];
          header_r[ 8 + i]   = d_p_i[1];
          header_r[16 + i]   = d_p_i[2];
          header_r[24 + i]   = d_p_i[3];
          wait4clk(1);
        end else
        if (NUM_LANE == 2) begin
          if (i <= 7) begin
            header_r[ 0 + i] = d_p_i[0];
            header_r[ 8 + i] = d_p_i[1];
          end
          else begin
            header_r[ 8 + i] = d_p_i[0];
            header_r[16 + i] = d_p_i[1];
          end
          wait4clk(1);
        end else
        if (NUM_LANE == 1) begin
          header_r[ 0 + i]   = d_p_i[0];
          wait4clk(1);
        end
      end
    end
    if (HEADER_CHECK == "ON") begin
      $fwrite(tx_output_data_file,"VC  = %h\nDT  = %h\nWC  = %h\nECC = %h\n",header_r[1:0],header_r[7:2],header_r[23:8],header_r[31:24]);
    end
    data_type_r            = header_r[ 5: 0];
    virtual_chanel_r       = header_r[ 7: 6];
    word_count_r           = header_r[23: 8];
    ecc_r                  = header_r[31:24];
    ///
    compute_ecc(header_r[23:0],ecc_calc);
    if (ecc_r == ecc_calc) begin
      global_ECC_passed_cases = global_ECC_passed_cases + 1;
    end
    else begin
      global_ECC_failed_cases = global_ECC_failed_cases + 1;
    end
    ///
    short_packet           = (
                              data_type_r == 6'h00 |
                              data_type_r == 6'h01 |
                              data_type_r == 6'h02 |
                              data_type_r == 6'h03 |
                              data_type_r == 6'h11 |
                              data_type_r == 6'h21 |
                              data_type_r == 6'h31
                              );
    /// Received frame/line number
    if (INTF_TYPE == "CSI2") begin
      if (data_type_r == 6'h00 | data_type_r == 6'h01) begin
        frame_count_r = word_count_r;
      end else 
      if (data_type_r == 6'h02 | data_type_r == 6'h03) begin
        line_count_r = word_count_r;
      end
    end else
    if (INTF_TYPE == "DSI") begin
      if (data_type_r == 6'h01 | data_type_r == 6'h11) begin
        frame_count_r = word_count_r;
      end else 
      if (data_type_r == 6'h21 | data_type_r == 6'h31) begin
        line_count_r = word_count_r;
      end
    end
    /// END
    
    /// Expected frame/line number
    if (data_type_r == 6'h00) begin
      exp_frame_count_r = (exp_frame_count_r == NUM_FRAMES)? 16'h01 : exp_frame_count_r + 1;
    end else 
    if (data_type_r == 6'h02) begin
      exp_line_count_r = (exp_line_count_r ==   NUM_FRAMES)? 16'h01 : exp_line_count_r  + 1;
    end
    /// END
    
    //////////////////////////////////////////////////////////////////////////////////
    /// • 
    /// • DPHY Tx Changes
    /// • Date June 2, 2019
    /// • 
    /// • Added new checker for Frame number.
    //////////////////////////////////////////////////////////////////////////////////
    if (FRAME_CNT_EN == "ON") begin
      if (exp_frame_count_r == frame_count_r) begin
        $display(" Frame number PASS");
        global_FRAME_NUMBER_passed_cases = global_FRAME_NUMBER_passed_cases + 1;
      end
      else begin
        $display(" Frame number FAIL");
        global_FRAME_NUMBER_failed_cases = global_FRAME_NUMBER_failed_cases + 1;
      end
    end
    in_process = 0;
  end
endtask

task readbyte();
  reg                  in_process;
  reg           [15:0] byte_count;
  reg [8*NUM_LANE-1:0] data;
  reg           [ 7:0] byte1, byte1r;
  reg           [ 7:0] byte2, byte2r;
  reg           [ 7:0] byte3, byte3r;
  reg           [ 7:0] byte4, byte4r;
  reg           [ 3:0] crc_en;
  begin
    in_process = 1;
    byte_count = 16'd0;
    data       = {8*NUM_LANE{1'd0}};
    byte1      = 0; byte1r     = 0;
    byte2      = 0; byte2r     = 0;
    byte3      = 0; byte3r     = 0;
    byte4      = 0; byte4r     = 0;
    crc_en     = 0;
    byte_count = 16'd0;
    if (NUM_LANE == 4) begin
      while ((byte_count != word_count_r) && ((word_count_r - byte_count) >= 4)) begin
        for (i = 0; i <= 7; i = i + 1) begin
          data[ 0 + i] = d_p_i[0];
          data[ 8 + i] = d_p_i[1];
          data[16 + i] = d_p_i[2];
          data[24 + i] = d_p_i[3];
          wait4clk(1);
          crc_en = (i == 7)? 4'b1111 : crc_en;
          crc_en = (i == 1)? 4'b0000 : crc_en;
        end
        $fwrite(tx_output_data_file,"%h\n%h\n%h\n%h\n",data[7:0],data[15:8],data[23:16],data[31:24]);
        byte_count     = byte_count + 4;
        byte1r         = byte1;
        byte2r         = byte2;
        byte3r         = byte3;
        byte4r         = byte4;
        byte1          = data[ 7: 0];
        byte2          = data[15: 8];
        byte3          = data[23:16];
        byte4          = data[31:24];
      end
      if (((word_count_r - byte_count) < 4)) begin
        if ((word_count_r - byte_count) == 0) begin
          if (EOTP_CHECK == "ON" | CRC_CHECK == "ON") begin
            eotpcheck_after_lp(8'd0,8'd0,8'd0,3'b000);
          end
        end
        else begin
          for (i = 0; i <= 7; i = i + 1) begin
            data[ 0 + i] = d_p_i[0];
            data[ 8 + i] = d_p_i[1];
            data[16 + i] = d_p_i[2];
            data[24 + i] = d_p_i[3];
            wait4clk(1);
            crc_en = (i == 7)? (((word_count_r - byte_count) == 1)? 4'b0001 : ((word_count_r - byte_count) == 2)? 4'b0011 : 4'b0111) : crc_en;
            crc_en = (i == 1)? 4'b0000 : crc_en;
          end
          byte1          = data[ 7: 0];
          byte2          = data[15: 8];
          byte3          = data[23:16];
          byte4          = data[31:24];
          case(word_count_r - byte_count)
            16'd1: begin
              $fwrite(tx_output_data_file,"%h\n",data[7:0]);
              if (EOTP_CHECK == "ON" | CRC_CHECK == "ON") begin
                eotpcheck_after_lp(data[15:8],data[23:16],data[31:24],3'b111);
              end
            end
            16'd2: begin
              $fwrite(tx_output_data_file,"%h\n%h\n",data[7:0],data[15:8]);
              if (EOTP_CHECK == "ON" | CRC_CHECK == "ON") begin
                eotpcheck_after_lp(data[23:16],data[31:24],8'd0,3'b110);
              end
            end
            16'd3: begin
              $fwrite(tx_output_data_file,"%h\n%h\n%h\n",data[7:0],data[15:8],data[23:16]);
              if (EOTP_CHECK == "ON" | CRC_CHECK == "ON") begin
                eotpcheck_after_lp(data[31:24],8'd0,8'd0,3'b100);
              end
            end
          endcase
          byte_count     = byte_count + word_count_r - byte_count;
          byte1          = data[ 7: 0];
          byte2          = data[15: 8];
          byte3          = data[23:16];
          byte4          = data[31:24];
        end
      end
    end else
    if (NUM_LANE == 3) begin
      if (CIL_BYPASS  != "CIL_BYPASSED") begin
        $fwrite(tx_output_data_file,"%h\n%h\n",cil_bytes_header_0[15:8],cil_bytes_header_1[15:8]);
        byte_count = 16'd2;
      end
      else if (GEAR == 16 && CIL_BYPASS  == "CIL_BYPASSED") begin
        wait4byteclk(1);
      end
      while ((byte_count != word_count_r) && ((word_count_r - byte_count) >= 3)) begin
        for (i = 0; i <= 7; i = i + 1) begin
          data[ 0 + i] = d_p_i[0];
          data[ 8 + i] = d_p_i[1];
          data[16 + i] = d_p_i[2];
          wait4clk(1);
          crc_en = (i == 7)? 4'b0111 : crc_en;
          crc_en = (i == 1)? 4'b0000 : crc_en;
        end
        $fwrite(tx_output_data_file,"%h\n%h\n%h\n",data[7:0],data[15:8],data[23:16]);
        byte_count     = byte_count + 3;
        byte1          = data[ 7: 0];
        byte2          = data[15: 8];
        byte3          = data[23:16];
      end
      if (((word_count_r - byte_count) < 3)) begin
        if ((word_count_r - byte_count) == 0) begin
          if (EOTP_CHECK == "ON" | CRC_CHECK == "ON") begin
            eotpcheck_after_lp(8'd0,8'd0,8'd0,3'b000);
          end
        end
        else begin
          for (i = 0; i <= 7; i = i + 1) begin
            data[ 0 + i] = d_p_i[0];
            data[ 8 + i] = d_p_i[1];
            data[16 + i] = d_p_i[2];
            wait4clk(1);
            crc_en = (i == 7)? (((word_count_r - byte_count) == 1)? 4'b0001 : 4'b0011) : crc_en;
            crc_en = (i == 1)? 4'b0000 : crc_en;
          end
          byte1          = data[ 7: 0];
          byte2          = data[15: 8];
          byte3          = data[23:16];
          case(word_count_r - byte_count)
            16'd1: begin
              $fwrite(tx_output_data_file,"%h\n",data[7:0]);
              if (EOTP_CHECK == "ON" | CRC_CHECK == "ON") begin
                eotpcheck_after_lp(data[15:8],data[23:16],8'd0,3'b110);
              end
            end
            16'd2: begin
              $fwrite(tx_output_data_file,"%h\n%h\n",data[7:0],data[15:8]);
              if (EOTP_CHECK == "ON" | CRC_CHECK == "ON") begin
                eotpcheck_after_lp(data[23:16],8'd0,8'd0,3'b100);
              end
            end
          endcase
          byte_count     = byte_count + word_count_r - byte_count;
          byte1          = data[ 7: 0];
          byte2          = data[15: 8];
          byte3          = data[23:16];
        end
      end
    end else
    if (NUM_LANE == 2) begin
      byte3          = 8'hFF;
      byte4          = 8'hFF;
      /////////  
      while ((byte_count != word_count_r) && ((word_count_r - byte_count) >= 2)) begin
        for (i = 0; i <= 7; i = i + 1) begin
          data[ 0 + i] = d_p_i[0];
          data[ 8 + i] = d_p_i[1];
          wait4clk(1);
          crc_en = (i == 7)? 4'b0011 : crc_en;
          crc_en = (i == 1)? 4'b0000 : crc_en;
        end
        $fwrite(tx_output_data_file,"%h\n%h\n",data[7:0],data[15:8]);
        byte_count     = byte_count + 2;
        byte1          = data[ 7: 0];
        byte2          = data[15: 8];
      end
      /////////  
      /////////  
      if (((word_count_r - byte_count) == 1)) begin
        for (i = 0; i <= 7; i = i + 1) begin
          data[ 0 + i] = d_p_i[0];
          data[ 8 + i] = d_p_i[1];
          wait4clk(1);
          crc_en = (i == 7)? 4'b0001 : crc_en;
          crc_en = (i == 1)? 4'b0000 : crc_en;
        end
        case(word_count_r - byte_count)
          16'd1: $fwrite(tx_output_data_file,"%h\n",data[7:0]);
        endcase
        byte_count     = byte_count + word_count_r - byte_count;
        byte1          = data[ 7: 0];
        byte2          = data[15: 8];
        
        if (EOTP_CHECK == "ON" | CRC_CHECK == "ON") begin
          eotpcheck_after_lp(byte2,8'd0,8'd0,3'b100);
        end
      end
      /////////
      else begin
        if (EOTP_CHECK == "ON" | CRC_CHECK == "ON") begin
          eotpcheck_after_lp(8'd0,8'd0,8'd0,3'b000);
        end
      end
      /////////
    end else
    if (NUM_LANE == 1) begin
      while ((byte_count != word_count_r)) begin
        for (i = 0; i <= 7; i = i + 1) begin
          data[ 0 + i] = d_p_i[0];
          wait4clk(1);
          crc_en = (i == 7)? 4'b0001 : crc_en;
          crc_en = (i == 1)? 4'b0000 : crc_en;
        end
        $fwrite(tx_output_data_file,"%h\n",data[7:0]);
        byte_count     = byte_count + 1;
        byte1          = data[ 7: 0];
        byte2          = 8'hFF;
        byte3          = 8'hFF;
        byte4          = 8'hFF;
      end
      if (EOTP_CHECK == "ON" | CRC_CHECK == "ON") begin
        eotpcheck_after_lp(8'd0,8'd0,8'd0,3'b000);
      end
    end
    in_process = 0;
  end
endtask

task eotpcheck();
  reg        in_process;
  integer    k;
  reg [31:0] EoTp;
  begin
    in_process = 1;
    EoTp       = 32'd0;
    if (NUM_LANE == 3) begin
      for (i = 0; i <= 15; i = i + 1) begin
        if (i <= 7) begin
          EoTp[ 0 + i] = d_p_i[0];
          EoTp[ 8 + i] = d_p_i[1];
          EoTp[16 + i] = d_p_i[2];
        end
        else begin
          EoTp[16 + i] = d_p_i[0];
        end
        wait4clk(1);
      end  
    end else begin
      for (i = 0; i <= (32/NUM_LANE)-1; i = i + 1) begin
        if (NUM_LANE == 4) begin
          EoTp[ 0 + i]   = d_p_i[0];
          EoTp[ 8 + i]   = d_p_i[1];
          EoTp[16 + i]   = d_p_i[2];
          EoTp[24 + i]   = d_p_i[3];
          wait4clk(1);
        end else
        if (NUM_LANE == 2) begin
          if (i <= 7) begin
            EoTp[ 0 + i] = d_p_i[0];
            EoTp[ 8 + i] = d_p_i[1];
          end
          else begin
            EoTp[ 8 + i] = d_p_i[0];
            EoTp[16 + i] = d_p_i[1];
          end
          wait4clk(1);
        end else
        if (NUM_LANE == 1) begin
          EoTp[ 0 + i]   = d_p_i[0];
          wait4clk(1);
        end
      end
    end
    if (EoTp == EOTP_VAL) begin
      $display("EoTp received");
      global_EoTp_SP_passed_cases = global_EoTp_SP_passed_cases + 1;
    end
    else begin
      global_EoTp_SP_failed_cases = global_EoTp_SP_failed_cases + 1;
      for (k = 0; k < 32; k = k + 1) begin
        if (EoTp[i] != EOTP_VAL[i]) begin
          $display("EoTp bit %d is invalid",i);
          #100;
        end
      end
    end
    EoTp       = 32'd0;
    in_process = 0;
  end
endtask

/// This task is additional task for task readbyte
/// Reads CRC and EoTp from data lines and check
/// Inputs is used for cases when payload and CRC and/or EoTp
/// received at the same time
task eotpcheck_after_lp(
  input [7:0] crc_low,
  input [7:0] crc_high,
  input [7:0] eotp_low,
  input [2:0] valid
  );
// reg in_process = 1'd0; // Fix for Modelsim issue
  reg in_process;
  reg [15:0] crc; /// <=> direction
  reg [31:0] EoTp;
  begin
    in_process = 1'd1;
    crc  = 16'd0;
    EoTp = 32'd0;
    if (NUM_LANE == 4) begin
      if (valid == 3'b000) begin /// if word count is 4, 8,12 ...
        for (i = 0; i <= 7; i = i + 1) begin
          crc[ 0 + i]  = d_p_i[0];
          crc[ 8 + i]  = d_p_i[1];
          EoTp[ 0 + i] = d_p_i[2];
          EoTp[ 8 + i] = d_p_i[3];
          wait4clk(1);
        end
        if (EOTP_CHECK == "ON") begin
          for (i = 0; i <= 7; i = i + 1) begin
            EoTp[16 + i] = d_p_i[0];
            EoTp[24 + i] = d_p_i[1];
            wait4clk(1);
          end
        end
      end
      if (valid == 3'b100) begin /// if word count is 7,11,15 ...
        crc = crc_low;
        for (i = 0; i <= 7; i = i + 1) begin
          crc[ 8 + i]  = d_p_i[0];
          EoTp[ 0 + i] = d_p_i[1];
          EoTp[ 8 + i] = d_p_i[2];
          EoTp[16 + i] = d_p_i[3];
          wait4clk(1);
        end
        if (EOTP_CHECK == "ON") begin
          for (i = 0; i <= 7; i = i + 1) begin
            EoTp[24 + i] = d_p_i[0];
            wait4clk(1);
          end
        end
      end else
      if (valid == 3'b110) begin /// if word count is 6,10,14 ...
        crc = {crc_high,crc_low};
        received_crc_r = {crc_high,crc_low};
        if (EOTP_CHECK == "ON") begin
          for (i = 0; i <= 7; i = i + 1) begin
            EoTp[ 0 + i] = d_p_i[0];
            EoTp[ 8 + i] = d_p_i[1];
            EoTp[16 + i] = d_p_i[2];
            EoTp[24 + i] = d_p_i[3];
            wait4clk(1);
          end
        end
      end else
      if (valid == 3'b111) begin /// if word count is 5, 9,13 ...
        crc  = {crc_high,crc_low};
        EoTp = eotp_low;
        if (EOTP_CHECK == "ON") begin
          for (i = 0; i <= 7; i = i + 1) begin
            EoTp[ 8 + i] = d_p_i[0];
            EoTp[16 + i] = d_p_i[1];
            EoTp[24 + i] = d_p_i[2];
            wait4clk(1);
          end
        end
      end
    end
    ///
    if (NUM_LANE == 3) begin
      if (valid == 3'b000) begin /// if word count is 3, 6, 9 ...
        for (i = 0; i <= 7; i = i + 1) begin
          crc[ 0 + i]  = d_p_i[0];
          crc[ 8 + i]  = d_p_i[1];
          EoTp[ 0 + i] = d_p_i[2];
          wait4clk(1);
        end
        if (EOTP_CHECK == "ON") begin
          for (i = 0; i <= 7; i = i + 1) begin
            EoTp[ 8 + i] = d_p_i[0];
            EoTp[16 + i] = d_p_i[1];
            EoTp[24 + i] = d_p_i[2];
            wait4clk(1);
          end
        end
      end
      if (valid == 3'b100) begin /// if word count is 4, 7, 10 ...
        crc = crc_low;
        for (i = 0; i <= 7; i = i + 1) begin
          crc[ 8 + i]  = d_p_i[0];
          EoTp[ 0 + i] = d_p_i[1];
          EoTp[ 8 + i] = d_p_i[2];
          wait4clk(1);
        end
        if (EOTP_CHECK == "ON") begin
          for (i = 0; i <= 7; i = i + 1) begin
            EoTp[16 + i] = d_p_i[0];
            EoTp[24 + i] = d_p_i[1];
            wait4clk(1);
          end
        end
      end else
      if (valid == 3'b110) begin /// if word count is 5, 8, 11 ...
        crc = {crc_high,crc_low};
        if (EOTP_CHECK == "ON") begin
          for (i = 0; i <= 7; i = i + 1) begin
            EoTp[ 0 + i] = d_p_i[0];
            EoTp[ 8 + i] = d_p_i[1];
            EoTp[16 + i] = d_p_i[2];
            wait4clk(1);
          end
          for (i = 0; i <= 7; i = i + 1) begin
            EoTp[24 + i] = d_p_i[0];
            wait4clk(1);
          end
        end
      end
    end
    ///
    if (NUM_LANE == 2) begin
      if (valid == 3'b100) begin /// Case when readbyte is already read crc[7:0] with last byte case when word count 1,3,5 ...
        crc[7:0] = crc_low;
        for (i = 0; i <= 7; i = i + 1) begin
          crc[ 8 + i]  = d_p_i[0];
          EoTp[ 0 + i] = d_p_i[1];
          wait4clk(1);
        end
        if (EOTP_CHECK == "ON") begin
          for (i = 0; i <= 7; i = i + 1) begin
            EoTp[ 8 + i] = d_p_i[0];
            EoTp[16 + i] = d_p_i[1];
            wait4clk(1);
          end
          for (i = 0; i <= 7; i = i + 1) begin
            EoTp[24 + i] = d_p_i[0];
            wait4clk(1);
          end
        end
      end
      else begin
        for (i = 0; i <= 7; i = i + 1) begin
          crc[ 0 + i] = d_p_i[0];
          crc[ 8 + i] = d_p_i[1];
          wait4clk(1);
        end
        if (EOTP_CHECK == "ON") begin
          for (i = 0; i <= 7; i = i + 1) begin
            EoTp[ 0 + i] = d_p_i[0];
            EoTp[ 8 + i] = d_p_i[1];
            wait4clk(1);
          end
          for (i = 0; i <= 7; i = i + 1) begin
            EoTp[16 + i] = d_p_i[0];
            EoTp[24 + i] = d_p_i[1];
            wait4clk(1);
          end
        end
      end
    end else
    ///
    if (NUM_LANE == 1) begin
      for (i = 0; i <= 15; i = i + 1) begin
        crc[ 0 + i] = d_p_i[0];
        wait4clk(1);
      end
      if (EOTP_CHECK == "ON") begin
        for (i = 0; i <= 31; i = i + 1) begin
          EoTp[ 0 + i] = d_p_i[0];
          wait4clk(1);
        end
      end
    end
    ///
    received_crc_r       = crc;
    received_crc_valid_r = 1'd1;
    ///
    if (EOTP_CHECK == "ON") begin
      if (EoTp == EOTP_VAL) begin
        global_EoTp_LP_passed_cases = global_EoTp_LP_passed_cases + 1;
      end
      else begin
        global_EoTp_LP_failed_cases = global_EoTp_LP_failed_cases + 1;
      end
    end
    // #1000;
    crc  = 16'd0;
    EoTp = 32'd0;
    in_process = 1'd0;
  end
endtask

task reset();
  reg wait4reset;
  begin
    #1;
    wait4reset = 1;
    while(!reset_i) begin
      #1;
    end
    wait4reset = 0;
  end
endtask
task crc_calc();
    reg                  in_process;
    reg [NUM_LANE*8-1:0] reverse_data;
    reg           [15:0] reverse_crc;
    reg           [15:0] rx_crc;
    ///
    integer              cycle_count;
    begin
        @(posedge readbyte.in_process);
        in_process            = 1;
        reverse_data          = {(NUM_LANE*8){1'd0}};
        reverse_crc           = 16'hFFFF;
        ///
        if (NUM_LANE == 1) begin
          cycle_count           = word_count_r/NUM_LANE;
        end else 
        if (NUM_LANE == 2) begin
          cycle_count           = word_count_r/NUM_LANE + word_count_r[0];
        end else
        if (NUM_LANE == 3) begin
          cycle_count           = word_count_r/NUM_LANE + ((word_count_r % NUM_LANE) == 0) ? 0 : 1;
        end else
        if (NUM_LANE == 4) begin
          cycle_count           = word_count_r/NUM_LANE + |word_count_r[1:0];
        end
        ///
        repeat (cycle_count) begin
            @(posedge readbyte.crc_en[0]);
            if (NUM_LANE == 1) begin
                reverse_data  = {
                                  readbyte.byte1[0],
                                  readbyte.byte1[1],
                                  readbyte.byte1[2],
                                  readbyte.byte1[3],
                                  readbyte.byte1[4],
                                  readbyte.byte1[5],
                                  readbyte.byte1[6],
                                  readbyte.byte1[7]
                                };
                reverse_crc   = nextCRC16_D8(reverse_data,reverse_crc);
            end else
            if (NUM_LANE == 2) begin
                  reverse_data  = {
                                    readbyte.byte1[0],readbyte.byte1[1],
                                    readbyte.byte1[2],readbyte.byte1[3],
                                    readbyte.byte1[4],readbyte.byte1[5],
                                    readbyte.byte1[6],readbyte.byte1[7],
                                    readbyte.byte2[0],readbyte.byte2[1],
                                    readbyte.byte2[2],readbyte.byte2[3],
                                    readbyte.byte2[4],readbyte.byte2[5],
                                    readbyte.byte2[6],readbyte.byte2[7]
                                  };
                if (readbyte.crc_en == 4'b0011) begin
                  reverse_crc   = nextCRC16_D16(reverse_data,reverse_crc);
                end
                else if (readbyte.crc_en == 4'b0001) begin
                  reverse_crc   = nextCRC16_D8(reverse_data[15:8],reverse_crc);
                end
            end else
            if (NUM_LANE == 3) begin
                reverse_data  = {
                                  readbyte.byte1[0],readbyte.byte1[1],readbyte.byte1[2],readbyte.byte1[3],
                                  readbyte.byte1[4],readbyte.byte1[5],readbyte.byte1[6],readbyte.byte1[7],
                                  readbyte.byte2[0],readbyte.byte2[1],readbyte.byte2[2],readbyte.byte2[3],
                                  readbyte.byte2[4],readbyte.byte2[5],readbyte.byte2[6],readbyte.byte2[7],
                                  readbyte.byte3[0],readbyte.byte3[1],readbyte.byte3[2],readbyte.byte3[3],
                                  readbyte.byte3[4],readbyte.byte3[5],readbyte.byte3[6],readbyte.byte3[7]
                                };
                if (readbyte.crc_en == 4'b0111) begin
                  reverse_crc   = nextCRC16_D24(reverse_data,reverse_crc);
                end else 
                if (readbyte.crc_en == 4'b0011) begin
                  reverse_crc   = nextCRC16_D16(reverse_data[23:8],reverse_crc);
                end else 
                if (readbyte.crc_en == 4'b0001) begin
                  reverse_crc   = nextCRC16_D8(reverse_data[23:16],reverse_crc);
                end
            end
            if (NUM_LANE == 4) begin
                reverse_data  = {
                                  readbyte.byte1[0],readbyte.byte1[1],readbyte.byte1[2],readbyte.byte1[3],
                                  readbyte.byte1[4],readbyte.byte1[5],readbyte.byte1[6],readbyte.byte1[7],
                                  readbyte.byte2[0],readbyte.byte2[1],readbyte.byte2[2],readbyte.byte2[3],
                                  readbyte.byte2[4],readbyte.byte2[5],readbyte.byte2[6],readbyte.byte2[7],
                                  readbyte.byte3[0],readbyte.byte3[1],readbyte.byte3[2],readbyte.byte3[3],
                                  readbyte.byte3[4],readbyte.byte3[5],readbyte.byte3[6],readbyte.byte3[7],
                                  readbyte.byte4[0],readbyte.byte4[1],readbyte.byte4[2],readbyte.byte4[3],
                                  readbyte.byte4[4],readbyte.byte4[5],readbyte.byte4[6],readbyte.byte4[7]
                                };
                if (readbyte.crc_en == 4'b1111) begin
                  reverse_crc   = nextCRC16_D32(reverse_data,reverse_crc);
                end else 
                if (readbyte.crc_en == 4'b0111) begin
                  reverse_crc   = nextCRC16_D24(reverse_data[31:8],reverse_crc);
                end else 
                if (readbyte.crc_en == 4'b0011) begin
                  reverse_crc   = nextCRC16_D16(reverse_data[31:16],reverse_crc);
                end else 
                if (readbyte.crc_en == 4'b0001) begin
                  reverse_crc   = nextCRC16_D8(reverse_data[31:24],reverse_crc);
                end
            end
            /// Curenc CRC
            rx_crc                = {
                                  reverse_crc[ 0],
                                  reverse_crc[ 1],
                                  reverse_crc[ 2],
                                  reverse_crc[ 3],
                                  reverse_crc[ 4],
                                  reverse_crc[ 5],
                                  reverse_crc[ 6],
                                  reverse_crc[ 7],
                                  reverse_crc[ 8],
                                  reverse_crc[ 9],
                                  reverse_crc[10],
                                  reverse_crc[11],
                                  reverse_crc[12],
                                  reverse_crc[13],
                                  reverse_crc[14],
                                  reverse_crc[15]
                                };
        end
        calculated_crc_r       = rx_crc;
        calculated_crc_valid_r = 1'd1;
        in_process            = 0;
    end
endtask

task compute_ecc(input [23:0] d, output [5:0] ecc_val);
begin
  ecc_val[0] =d[0]^d[1]^d[2]^d[4]^d[5]^d[7]^d[10]^d[11]^d[13]^d[16]^d[20]^d[21]^d[22]^d[23];
  ecc_val[1] = d[0]^d[1]^d[3]^d[4]^d[6]^d[8]^d[10]^d[12]^d[14]^d[17]^d[20]^d[21]^d[22]^d[23];
  ecc_val[2] = d[0]^d[2]^d[3]^d[5]^d[6]^d[9]^d[11]^d[12]^d[15]^d[18]^d[20]^d[21]^d[22];
  ecc_val[3] = d[1]^d[2]^d[3]^d[7]^d[8]^d[9]^d[13]^d[14]^d[15]^d[19]^d[20]^d[21]^d[23];
  ecc_val[4] = d[4]^d[5]^d[6]^d[7]^d[8]^d[9]^d[16]^d[17]^d[18]^d[19]^d[20]^d[22]^d[23];
  ecc_val[5] = d[10]^d[11]^d[12]^d[13]^d[14]^d[15]^d[16]^d[17]^d[18]^d[19]^d[21]^d[22]^d[23];
end
endtask
//------------------------------------------------------------------------------
// Function Definition
//------------------------------------------------------------------------------
function [15:0] nextCRC16_D32;
  input [31:0] Data;
  input [15:0] crc_o;
  reg   [31:0] d;
  reg   [15:0] c;
  reg   [15:0] newcrc;
begin
  d          = Data;
  c          = crc_o;

  newcrc[0]  = d[28] ^ d[27] ^ d[26] ^ d[22] ^ d[20] ^ d[19] ^ d[12] ^ d[11] ^
               d[ 8] ^ d[ 4] ^ d[ 0] ^ c[ 3] ^ c[ 4] ^ c[ 6] ^ c[10] ^ c[11] ^
               c[12];
  newcrc[1]  = d[29] ^ d[28] ^ d[27] ^ d[23] ^ d[21] ^ d[20] ^ d[13] ^ d[12] ^
               d[ 9] ^ d[ 5] ^ d[ 1] ^ c[ 4] ^ c[ 5] ^ c[ 7] ^ c[11] ^ c[12] ^
               c[13];
  newcrc[2]  = d[30] ^ d[29] ^ d[28] ^ d[24] ^ d[22] ^ d[21] ^ d[14] ^ d[13] ^
               d[10] ^ d[ 6] ^ d[ 2] ^ c[ 5] ^ c[ 6] ^ c[ 8] ^ c[12] ^ c[13] ^
               c[14];
  newcrc[3]  = d[31] ^ d[30] ^ d[29] ^ d[25] ^ d[23] ^ d[22] ^ d[15] ^ d[14] ^
               d[11] ^ d[ 7] ^ d[ 3] ^ c[ 6] ^ c[ 7] ^ c[ 9] ^ c[13] ^ c[14] ^
               c[15];
  newcrc[4]  = d[31] ^ d[30] ^ d[26] ^ d[24] ^ d[23] ^ d[16] ^ d[15] ^ d[12] ^
               d[ 8] ^ d[ 4] ^ c[ 0] ^ c[ 7] ^ c[ 8] ^ c[10] ^ c[14] ^ c[15];
  newcrc[5]  = d[31] ^ d[28] ^ d[26] ^ d[25] ^ d[24] ^ d[22] ^ d[20] ^ d[19] ^
               d[17] ^ d[16] ^ d[13] ^ d[12] ^ d[11] ^ d[ 9] ^ d[ 8] ^ d[ 5] ^
               d[ 4] ^ d[ 0] ^ c[ 0] ^ c[ 1] ^ c[ 3] ^ c[ 4] ^ c[ 6] ^ c[ 8] ^
               c[ 9] ^ c[10] ^ c[12] ^ c[15];
  newcrc[6]  = d[29] ^ d[27] ^ d[26] ^ d[25] ^ d[23] ^ d[21] ^ d[20] ^ d[18] ^
               d[17] ^ d[14] ^ d[13] ^ d[12] ^ d[10] ^ d[ 9] ^ d[ 6] ^ d[ 5] ^
               d[ 1] ^ c[ 1] ^ c[ 2] ^ c[ 4] ^ c[ 5] ^ c[ 7] ^ c[ 9] ^ c[10] ^
               c[11] ^ c[13];
  newcrc[7]  = d[30] ^ d[28] ^ d[27] ^ d[26] ^ d[24] ^ d[22] ^ d[21] ^ d[19] ^
               d[18] ^ d[15] ^ d[14] ^ d[13] ^ d[11] ^ d[10] ^ d[ 7] ^ d[ 6] ^
               d[ 2] ^ c[ 2] ^ c[ 3] ^ c[ 5] ^ c[ 6] ^ c[ 8] ^ c[10] ^ c[11] ^
               c[12] ^ c[14];
  newcrc[8]  = d[31] ^ d[29] ^ d[28] ^ d[27] ^ d[25] ^ d[23] ^ d[22] ^ d[20] ^
               d[19] ^ d[16] ^ d[15] ^ d[14] ^ d[12] ^ d[11] ^ d[ 8] ^ d[ 7] ^
               d[ 3] ^ c[ 0] ^ c[ 3] ^ c[ 4] ^ c[ 6] ^ c[ 7] ^ c[ 9] ^ c[11] ^
               c[12] ^ c[13] ^ c[15];
  newcrc[9]  = d[30] ^ d[29] ^ d[28] ^ d[26] ^ d[24] ^ d[23] ^ d[21] ^ d[20] ^
               d[17] ^ d[16] ^ d[15] ^ d[13] ^ d[12] ^ d[ 9] ^ d[ 8] ^ d[ 4] ^
               c[ 0] ^ c[ 1] ^ c[ 4] ^ c[ 5] ^ c[ 7] ^ c[ 8] ^ c[10] ^ c[12] ^
               c[13] ^ c[14];
  newcrc[10] = d[31] ^ d[30] ^ d[29] ^ d[27] ^ d[25] ^ d[24] ^ d[22] ^ d[21] ^
               d[18] ^ d[17] ^ d[16] ^ d[14] ^ d[13] ^ d[10] ^ d[ 9] ^ d[ 5] ^
               c[ 0] ^ c[ 1] ^ c[ 2] ^ c[ 5] ^ c[ 6] ^ c[ 8] ^ c[ 9] ^ c[11] ^
               c[13] ^ c[14] ^ c[15];
  newcrc[11] = d[31] ^ d[30] ^ d[28] ^ d[26] ^ d[25] ^ d[23] ^ d[22] ^ d[19] ^
               d[18] ^ d[17] ^ d[15] ^ d[14] ^ d[11] ^ d[10] ^ d[ 6] ^ c[ 1] ^
               c[ 2] ^ c[ 3] ^ c[ 6] ^ c[ 7] ^ c[ 9] ^ c[10] ^ c[12] ^ c[14] ^
               c[15];
  newcrc[12] = d[31] ^ d[29] ^ d[28] ^ d[24] ^ d[23] ^ d[22] ^ d[18] ^ d[16] ^
               d[15] ^ d[ 8] ^ d[ 7] ^ d[ 4] ^ d[ 0] ^ c[ 0] ^ c[ 2] ^ c[ 6] ^
               c[ 7] ^ c[ 8] ^ c[12] ^ c[13] ^ c[15];
  newcrc[13] = d[30] ^ d[29] ^ d[25] ^ d[24] ^ d[23] ^ d[19] ^ d[17] ^ d[16] ^
               d[ 9] ^ d[ 8] ^ d[ 5] ^ d[ 1] ^ c[ 0] ^ c[ 1] ^ c[ 3] ^ c[ 7] ^
               c[ 8] ^ c[ 9] ^ c[13] ^ c[14];
  newcrc[14] = d[31] ^ d[30] ^ d[26] ^ d[25] ^ d[24] ^ d[20] ^ d[18] ^ d[17] ^
               d[10] ^ d[ 9] ^ d[ 6] ^ d[ 2] ^ c[ 1] ^ c[ 2] ^ c[ 4] ^ c[ 8] ^
               c[ 9] ^ c[10] ^ c[14] ^ c[15];
  newcrc[15] = d[31] ^ d[27] ^ d[26] ^ d[25] ^ d[21] ^ d[19] ^ d[18] ^ d[11] ^
               d[10] ^ d[ 7] ^ d[ 3] ^ c[ 2] ^ c[ 3] ^ c[ 5] ^ c[ 9] ^ c[10] ^
               c[11] ^ c[15];
  nextCRC16_D32 = newcrc;
end
endfunction

function [15:0] nextCRC16_D24;
  input [23:0] Data;
  input [15:0] crc;
  reg   [23:0] d;
  reg   [15:0] c;
  reg   [15:0] newcrc;
begin
  d             = Data;
  c             = crc;

  newcrc[ 0]    = d[22] ^ d[20] ^ d[19] ^ d[12] ^ d[11] ^ d[ 8] ^ d[ 4] ^
                  d[ 0] ^ c[ 0] ^ c[ 3] ^ c[ 4] ^ c[11] ^ c[12] ^ c[14];
  newcrc[ 1]    = d[23] ^ d[21] ^ d[20] ^ d[13] ^ d[12] ^ d[ 9] ^ d[ 5] ^
                  d[ 1] ^ c[ 1] ^ c[ 4] ^ c[ 5] ^ c[12] ^ c[13] ^ c[15];
  newcrc[ 2]    = d[22] ^ d[21] ^ d[14] ^ d[13] ^ d[10] ^ d[ 6] ^ d[ 2] ^
                  c[ 2] ^ c[ 5] ^ c[ 6] ^ c[13] ^ c[14];
  newcrc[ 3]    = d[23] ^ d[22] ^ d[15] ^ d[14] ^ d[11] ^ d[ 7] ^ d[ 3] ^
                  c[ 3] ^ c[ 6] ^ c[ 7] ^ c[14] ^ c[15];
  newcrc[ 4]    = d[23] ^ d[16] ^ d[15] ^ d[12] ^ d[ 8] ^ d[ 4] ^ c[ 0] ^
                  c[ 4] ^ c[ 7] ^ c[ 8] ^ c[15];
  newcrc[ 5]    = d[22] ^ d[20] ^ d[19] ^ d[17] ^ d[16] ^ d[13] ^ d[12] ^
                  d[11] ^ d[ 9] ^ d[ 8] ^ d[ 5] ^ d[ 4] ^ d[ 0] ^ c[ 0] ^
                  c[ 1] ^ c[ 3] ^ c[ 4] ^ c[ 5] ^ c[ 8] ^ c[ 9] ^ c[11] ^
                  c[12] ^ c[14];
  newcrc[ 6]    = d[23] ^ d[21] ^ d[20] ^ d[18] ^ d[17] ^ d[14] ^ d[13] ^
                  d[12] ^ d[10] ^ d[ 9] ^ d[ 6] ^ d[ 5] ^ d[ 1] ^ c[ 1] ^
                  c[ 2] ^ c[ 4] ^ c[ 5] ^ c[ 6] ^ c[ 9] ^ c[10] ^ c[12] ^
                  c[13] ^ c[15];
  newcrc[ 7]    = d[22] ^ d[21] ^ d[19] ^ d[18] ^ d[15] ^ d[14] ^ d[13] ^
                  d[11] ^ d[10] ^ d[ 7] ^ d[ 6] ^ d[ 2] ^ c[ 2] ^ c[ 3] ^
                  c[ 5] ^ c[ 6] ^ c[ 7] ^ c[10] ^ c[11] ^ c[13] ^ c[14];
  newcrc[ 8]    = d[23] ^ d[22] ^ d[20] ^ d[19] ^ d[16] ^ d[15] ^ d[14] ^
                  d[12] ^ d[11] ^ d[ 8] ^ d[ 7] ^ d[ 3] ^ c[ 0] ^ c[ 3] ^
                  c[ 4] ^ c[ 6] ^ c[ 7] ^ c[ 8] ^ c[11] ^ c[12] ^ c[14] ^
                  c[15];
  newcrc[ 9]    = d[23] ^ d[21] ^ d[20] ^ d[17] ^ d[16] ^ d[15] ^ d[13] ^
                  d[12] ^ d[ 9] ^ d[ 8] ^ d[ 4] ^ c[ 0] ^ c[ 1] ^ c[ 4] ^
                  c[ 5] ^ c[ 7] ^ c[ 8] ^ c[ 9] ^ c[12] ^ c[13] ^ c[15];
  newcrc[10]    = d[22] ^ d[21] ^ d[18] ^ d[17] ^ d[16] ^ d[14] ^ d[13] ^
                  d[10] ^ d[ 9] ^ d[ 5] ^ c[ 1] ^ c[ 2] ^ c[ 5] ^ c[ 6] ^
                  c[ 8] ^ c[ 9] ^ c[10] ^ c[13] ^ c[14];
  newcrc[11]    = d[23] ^ d[22] ^ d[19] ^ d[18] ^ d[17] ^ d[15] ^ d[14] ^
                  d[11] ^ d[10] ^ d[ 6] ^ c[ 2] ^ c[ 3] ^ c[ 6] ^ c[ 7] ^
                  c[ 9] ^ c[10] ^ c[11] ^ c[14] ^ c[15];
  newcrc[12]    = d[23] ^ d[22] ^ d[18] ^ d[16] ^ d[15] ^ d[ 8] ^ d[ 7] ^
                  d[ 4] ^ d[ 0] ^ c[ 0] ^ c[ 7] ^ c[ 8] ^ c[10] ^ c[14] ^
                  c[15];
  newcrc[13]    = d[23] ^ d[19] ^ d[17] ^ d[16] ^ d[ 9] ^ d[ 8] ^ d[ 5] ^
                  d[ 1] ^ c[ 0] ^ c[ 1] ^ c[ 8] ^ c[ 9] ^ c[11] ^ c[15];
  newcrc[14]    = d[20] ^ d[18] ^ d[17] ^ d[10] ^ d[ 9] ^ d[ 6] ^ d[ 2] ^
                  c[ 1] ^ c[ 2] ^ c[ 9] ^ c[10] ^ c[12];
  newcrc[15]    = d[21] ^ d[19] ^ d[18] ^ d[11] ^ d[10] ^ d[ 7] ^ d[ 3] ^
                  c[ 2] ^ c[ 3] ^ c[10] ^ c[11] ^ c[13];
  nextCRC16_D24 = newcrc;
end
endfunction

function [15:0] nextCRC16_D16;
  input [15:0] Data;
  input [15:0] crc_o;
  reg   [15:0] d;
  reg   [15:0] c;
  reg   [15:0] newcrc;
begin
  d             = Data;
  c             = crc_o;

  newcrc[0]     = d[12] ^ d[11] ^ d[ 8] ^ d[ 4] ^ d[ 0] ^ c[ 0] ^ c[ 4] ^
                  c[ 8] ^ c[11] ^ c[12];
  newcrc[1]     = d[13] ^ d[12] ^ d[ 9] ^ d[ 5] ^ d[ 1] ^ c[ 1] ^ c[ 5] ^
                  c[ 9] ^ c[12] ^ c[13];
  newcrc[2]     = d[14] ^ d[13] ^ d[10] ^ d[ 6] ^ d[ 2] ^ c[ 2] ^ c[ 6] ^
                  c[10] ^ c[13] ^ c[14];
  newcrc[3]     = d[15] ^ d[14] ^ d[11] ^ d[ 7] ^ d[ 3] ^ c[ 3] ^ c[ 7] ^
                  c[11] ^ c[14] ^ c[15];
  newcrc[4]     = d[15] ^ d[12] ^ d[ 8] ^ d[ 4] ^ c[ 4] ^ c[ 8] ^ c[12] ^
                  c[15];
  newcrc[5]     = d[13] ^ d[12] ^ d[11] ^ d[ 9] ^ d[ 8] ^ d[ 5] ^ d[ 4] ^
                  d[ 0] ^ c[ 0] ^ c[ 4] ^ c[ 5] ^ c[ 8] ^ c[ 9] ^ c[11] ^
                  c[12] ^ c[13];
  newcrc[6]     = d[14] ^ d[13] ^ d[12] ^ d[10] ^ d[ 9] ^ d[ 6] ^ d[ 5] ^
                  d[ 1] ^ c[ 1] ^ c[ 5] ^ c[ 6] ^ c[ 9] ^ c[10] ^ c[12] ^
                  c[13] ^ c[14];
  newcrc[7]     = d[15] ^ d[14] ^ d[13] ^ d[11] ^ d[10] ^ d[ 7] ^ d[ 6] ^
                  d[ 2] ^ c[ 2] ^ c[ 6] ^ c[ 7] ^ c[10] ^ c[11] ^ c[13] ^
                  c[14] ^ c[15];
  newcrc[8]     = d[15] ^ d[14] ^ d[12] ^ d[11] ^ d[ 8] ^ d[ 7] ^ d[ 3] ^
                  c[ 3] ^ c[ 7] ^ c[ 8] ^ c[11] ^ c[12] ^ c[14] ^ c[15];
  newcrc[9]     = d[15] ^ d[13] ^ d[12] ^ d[ 9] ^ d[ 8] ^ d[ 4] ^ c[ 4] ^
                  c[ 8] ^ c[ 9] ^ c[12] ^ c[13] ^ c[15];
  newcrc[10]    = d[14] ^ d[13] ^ d[10] ^ d[ 9] ^ d[ 5] ^ c[ 5] ^ c[ 9] ^
                  c[10] ^ c[13] ^ c[14];
  newcrc[11]    = d[15] ^ d[14] ^ d[11] ^ d[10] ^ d[ 6] ^ c[ 6] ^ c[10] ^
                  c[11] ^ c[14] ^ c[15];
  newcrc[12]    = d[15] ^ d[ 8] ^ d[ 7] ^ d[ 4] ^ d[ 0] ^ c[ 0] ^ c[ 4] ^
                  c[ 7] ^ c[ 8] ^ c[15];
  newcrc[13]    = d[ 9] ^ d[ 8] ^ d[ 5] ^ d[ 1] ^ c[ 1] ^ c[ 5] ^ c[ 8] ^
                  c[ 9];
  newcrc[14]    = d[10] ^ d[ 9] ^ d[ 6] ^ d[ 2] ^ c[ 2] ^ c[ 6] ^ c[ 9] ^
                  c[10];
  newcrc[15]    = d[11] ^ d[10] ^ d[ 7] ^ d[ 3] ^ c[ 3] ^ c[ 7] ^ c[10] ^
                  c[11];
  nextCRC16_D16 = newcrc;
end
endfunction

function [15:0] nextCRC16_D8;
  input [7:0]  Data;
  input [15:0] crc_o;
  reg   [7:0]  d;
  reg   [15:0] c;
  reg   [15:0] newcrc;
begin
  d            = Data;
  c            = crc_o;
  newcrc[ 0]   = d[ 4] ^ d[ 0] ^ c[ 8] ^ c[12];
  newcrc[ 1]   = d[ 5] ^ d[ 1] ^ c[ 9] ^ c[13];
  newcrc[ 2]   = d[ 6] ^ d[ 2] ^ c[10] ^ c[14];
  newcrc[ 3]   = d[ 7] ^ d[ 3] ^ c[11] ^ c[15];
  newcrc[ 4]   = d[ 4] ^ c[12];
  newcrc[ 5]   = d[ 5] ^ d[ 4] ^ d[ 0] ^ c[ 8] ^ c[12] ^ c[13];
  newcrc[ 6]   = d[ 6] ^ d[ 5] ^ d[ 1] ^ c[ 9] ^ c[13] ^ c[14];
  newcrc[ 7]   = d[ 7] ^ d[ 6] ^ d[ 2] ^ c[10] ^ c[14] ^ c[15];
  newcrc[ 8]   = d[ 7] ^ d[ 3] ^ c[ 0] ^ c[11] ^ c[15];
  newcrc[ 9]   = d[ 4] ^ c[ 1] ^ c[12];
  newcrc[10]   = d[ 5] ^ c[ 2] ^ c[13];
  newcrc[11]   = d[ 6] ^ c[ 3] ^ c[14];
  newcrc[12]   = d[ 7] ^ d[ 4] ^ d[ 0] ^ c[ 4] ^ c[ 8] ^ c[12] ^ c[15];
  newcrc[13]   = d[ 5] ^ d[ 1] ^ c[ 5] ^ c[ 9] ^ c[13];
  newcrc[14]   = d[ 6] ^ d[ 2] ^ c[ 6] ^ c[10] ^ c[14];
  newcrc[15]   = d[ 7] ^ d[ 3] ^ c[ 7] ^ c[11] ^ c[15];
  nextCRC16_D8 = newcrc;
end
endfunction

endmodule
//==============================================================================
// rx_model.v
//==============================================================================
`endif
