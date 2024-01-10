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
// Project               : I2CFIFO
// File                  : tb_top.v
// Title                 :
// Dependencies          :
//                       :
// Description           :
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0
// Author(s)             : HAM
// Mod. Date             : 8/20/2019
// Changes Made          : Initial version
// =============================================================================


`timescale 1 ps / 1fs
`include "dut_defines.v"
`include "tb_include/tb_params.vh"
`include "vid_timing_gen_driver.v"
`include "byte_out_monitor.v"



module tb_top();	 
`include "dut_params.v"   

   parameter num_frames    = `NUM_FRAMES;
   
   parameter hfront_porch  = `HFRONT;
   parameter hsync_pulse   = `HPULSE;
   parameter hback_porch   = `HBACK;
   parameter vfront_porch  = `VFRONT;
   parameter vsync_pulse   = `VPULSE;
   parameter vback_porch   = `VBACK;
   
    `ifdef  TX_GEAR_16
         parameter GEAR_16 = 1;
    `else 
         parameter GEAR_16 = 0;
    `endif
   `ifndef MISC_ON
//      parameter init_drive_delay = `INIT_DRIVE_DELAY;
   `endif


   parameter output_width_in_bytes = (DATA_WIDTH*NUM_TX_LANE*TX_GEAR)/128;
   parameter input_width_in_bits = PIX_WIDTH*NUM_PIX_LANE;
   parameter input_width_in_bytes = input_width_in_bits[0] ? input_width_in_bits : 
                                    input_width_in_bits[1] ? input_width_in_bits/2 :
                                    input_width_in_bits[2] ? input_width_in_bits/4 :
                                                             input_width_in_bits/8;
   parameter multiple_bytes = input_width_in_bytes*output_width_in_bytes;
   parameter least_common_multiple_bytes = multiple_bytes[0] ? multiple_bytes*4 : multiple_bytes[1] ? multiple_bytes*2 : multiple_bytes;
   parameter number_of_bytes = (1 + `NUM_BYTES/least_common_multiple_bytes)*least_common_multiple_bytes;
   parameter total_pix = number_of_bytes*8/PIX_WIDTH;
   parameter act_pix = total_pix/NUM_PIX_LANE;

   parameter total_line     = `NUM_LINES;
   parameter pixclk_period  = `SIP_PCLK/2;
   parameter byteclk_period = (pixclk_period*DATA_WIDTH*NUM_TX_LANE*TX_GEAR)/(PIX_WIDTH*NUM_PIX_LANE*16);
   localparam exp_byte_count = `NUM_FRAMES * `NUM_LINES * number_of_bytes;

   reg        reset_n;
   wire       rst_n_i = reset_n;
   reg        pix_clk_i  = 0; 
   reg        byte_clk_i = 0;
   wire       byte_clk = byte_clk_i;
   reg        mon_en = 0;
   reg        start_vid = 0;
   reg        byte_log_en = 0;

   integer line_cnt  = 0;
   integer frame_cnt = 0;
   integer pixel_cnt = 0;
   integer testfail_cnt = 0;

   integer txfr_delay = 100000/byteclk_period;
   integer wc_delay = number_of_bytes/((GEAR_16+1)*NUM_TX_LANE);

//   `ifdef TX_DSI
      wire de_i ;
      wire hsync_i ;
      wire vsync_i ;
//   `endif
//   `ifdef TX_CSI2
      wire fv_i;
      wire lv_i;
      reg dvalid_i;
//   `endif

   wire eof;

   wire [PIX_WIDTH-1:0] pix_data9_i;
   wire [PIX_WIDTH-1:0] pix_data8_i;
   wire [PIX_WIDTH-1:0] pix_data7_i;
   wire [PIX_WIDTH-1:0] pix_data6_i;
   wire [PIX_WIDTH-1:0] pix_data5_i;
   wire [PIX_WIDTH-1:0] pix_data4_i;
   wire [PIX_WIDTH-1:0] pix_data3_i;
   wire [PIX_WIDTH-1:0] pix_data2_i;
   wire [PIX_WIDTH-1:0] pix_data1_i;
   wire [PIX_WIDTH-1:0] pix_data0_i;

   reg [PIX_WIDTH-1:0] pix_data_9_buf;
   reg [PIX_WIDTH-1:0] pix_data_8_buf;
   reg [PIX_WIDTH-1:0] pix_data_7_buf;
   reg [PIX_WIDTH-1:0] pix_data_6_buf;
   reg [PIX_WIDTH-1:0] pix_data_5_buf;
   reg [PIX_WIDTH-1:0] pix_data_4_buf;
   reg [PIX_WIDTH-1:0] pix_data_3_buf;
   reg [PIX_WIDTH-1:0] pix_data_2_buf;
   reg [PIX_WIDTH-1:0] pix_data_1_buf;
   reg [PIX_WIDTH-1:0] pix_data_0_buf;

   reg [7:0] byte0;
   reg [7:0] byte1;
   reg [7:0] byte2;
   reg [7:0] byte3;
   reg [7:0] byte4;
   reg [7:0] byte5;
   reg [7:0] byte6;
   reg [7:0] byte7;
   reg [7:0] byte8;
   reg [7:0] byte9;
   reg [7:0] byte10;
   reg [7:0] byte11;

//   `ifdef TX_DSI
      wire vsync_start_o;
      wire vsync_end_o;
      wire hsync_start_o;
      wire hsync_end_o;
      wire vsync_start = vsync_start_o;
      wire vsync_end   = vsync_end_o;
      wire hsync_start = hsync_start_o;
      wire hsync_end   = hsync_end_o;
//   `endif
//   `ifdef TX_CSI2
      wire fv_start_o;
      wire fv_end_o;
      wire lv_start_o;
      wire lv_end_o;
      wire [5:0] data_type_o;    // Output data type
      wire fv_start = fv_start_o;
      wire fv_end   = fv_end_o;
      wire lv_start = lv_start_o;
      wire lv_end   = lv_end_o;
//   `endif

//   `ifdef MISC_ON
//     `ifdef YUV420_8
//        wire odd_line;
//     `elsif YUV420_10
        wire odd_line;
//     `endif
     wire [5:0] data_type = data_type_o;    // Output data type
//   `endif

//   `ifdef TXFR_SIG
      wire c2d_ready_i = 1'b1;
      reg  txfr_en_i;     
      wire txfr_req_o;   
      wire txfr_req = txfr_req_o;   
//   `endif

   wire byte_en_o;
   wire [NUM_TX_LANE*TX_GEAR-1:0] byte_data_o;
   wire byte_en = byte_en_o;
   wire [63:0] byte_data = byte_data_o;
   integer fileIn;
   integer fileOut;
   reg enable_write_log =1;
   reg [7:0] log_out [exp_byte_count:1];
   reg [7:0] log_in  [exp_byte_count:1];

  
if (DSI_FORMAT == 1) begin

   initial begin                       
      reset_n       = 1'b1;
      start_vid     = 1'b0;
//      `ifdef TXFR_SIG
        txfr_en_i       = 0;
//      `endif

      $display("%0t TEST START\n",$time);

      #(pixclk_period*70)  reset_n = 1'b0; 
      #(pixclk_period*100) reset_n = 1'b1;

      #100;

      @(posedge pix_clk_i);


         byte_log_en = 1;
         start_vid = 1;
         $display(" test_hsync_front_porch : %d \n", hfront_porch);
         $display(" test_hsync_width       : %d \n", hsync_pulse);
         $display(" test_hsync_back_porch  : %d \n", hback_porch);
         $display(" test_h_width           : %d \n", act_pix);
         $display(" test_v_height          : %d \n", total_line);
         $display(" test_vsync_front_porch : %d \n", vfront_porch);
         $display(" test_vsync_width       : %d \n", vsync_pulse);
         $display(" test_vsync_back_porch  : %d \n", vback_porch);
         mon_en = 1;
         test_snow_pixel2byte_dsi_trans;

       `ifdef DSI_RESET_TEST1
         byte_log_en = 0;
         start_vid = 1;
         mon_en = 1;
         test_snow_pixel2byte_dsi_reset;
      `endif

      `ifdef DSI_RESET_TEST2
         byte_log_en = 0;
         start_vid = 1;
         mon_en = 1;
         test_snow_pixel2byte_dsi_reset;
      `endif

      `ifdef DSI_RESET_TEST3
         byte_log_en = 0;
         start_vid = 1;
         mon_en = 1;
         test_snow_pixel2byte_dsi_reset;
      `endif


      `ifdef CSI2_RESET_TEST1
         byte_log_en = 0;
         start_vid = 1;
         mon_en = 1;
         test_snow_pixel2byte_csi2_reset;
      `endif

      `ifdef CSI2_RESET_TEST2
         byte_log_en = 0;
         start_vid = 1;
         mon_en = 1;
         test_snow_pixel2byte_csi2_reset;
      `endif

      `ifdef CSI2_RESET_TEST3
         byte_log_en = 0;
         start_vid = 1;
         mon_en = 1;
         test_snow_pixel2byte_csi2_reset;
      `endif
      
      #100;

      check_data;
      //testfail_cnt should be 0 at the end of the test.
      if(testfail_cnt == 0) begin
        $display(" Test fail count : %d   \n", testfail_cnt);
        $display("-----------------------------------------------------");
        $display("----------------- SIMULATION PASSED -----------------");
        $display("-----------------------------------------------------");
      end else begin
        $display(" ERROR: Test fail count : %d   \n", testfail_cnt);
        //write testfail_cnt into any one log file, so that auto file comparisons will also fail.
        write_to_file("input_data.log", testfail_cnt);
        //write_to_file("output_data.log", testfail_cnt);
        $display("-----------------------------------------------------");
        $display("!!!!!!!!!!!!!!!!! SIMULATION FAILED !!!!!!!!!!!!!!!!!");
        $display("-----------------------------------------------------");
      end

      $display("%0t TEST END\n",$time);
      $finish;
        
   end

  end else begin
  
   initial begin                       
      reset_n       = 1'b1;
      start_vid     = 1'b0;
//      `ifdef TXFR_SIG
        txfr_en_i       = 0;
//      `endif
      dvalid_i       = 1'b1;

      $display("%0t TEST START\n",$time);
      #(pixclk_period*70)  reset_n = 1'b0; 
      #(pixclk_period*100) reset_n = 1'b1;
      #100;
      @(posedge pix_clk_i);

         
         byte_log_en = 1;
         start_vid = 1;
         $display(" test_hsync_front_porch : %d \n", hfront_porch);
         $display(" test_hsync_width       : %d \n", hsync_pulse);
         $display(" test_hsync_back_porch  : %d \n", hback_porch);
         $display(" test_h_width           : %d \n", act_pix);
         $display(" test_v_height          : %d \n", total_line);
         $display(" test_vsync_front_porch : %d \n", vfront_porch);
         $display(" test_vsync_width       : %d \n", vsync_pulse);
         $display(" test_vsync_back_porch  : %d \n", vback_porch);
         mon_en = 1;
         test_snow_pixel2byte_csi2_trans;
         
      `ifdef DSI_RESET_TEST1
         byte_log_en = 0;
         start_vid = 1;
         mon_en = 1;
         test_snow_pixel2byte_dsi_reset;
      `endif

      `ifdef DSI_RESET_TEST2
         byte_log_en = 0;
         start_vid = 1;
         mon_en = 1;
         test_snow_pixel2byte_dsi_reset;
      `endif

      `ifdef DSI_RESET_TEST3
         byte_log_en = 0;
         start_vid = 1;
         mon_en = 1;
         test_snow_pixel2byte_dsi_reset;
      `endif


      `ifdef CSI2_RESET_TEST1
         byte_log_en = 0;
         start_vid = 1;
         mon_en = 1;
         test_snow_pixel2byte_csi2_reset;
      `endif

      `ifdef CSI2_RESET_TEST2
         byte_log_en = 0;
         start_vid = 1;
         mon_en = 1;
         test_snow_pixel2byte_csi2_reset;
      `endif

      `ifdef CSI2_RESET_TEST3
         byte_log_en = 0;
         start_vid = 1;
         mon_en = 1;
         test_snow_pixel2byte_csi2_reset;
      `endif
      
      #100;
      
      check_data;
      //testfail_cnt should be 0 at the end of the test.
      if(testfail_cnt == 0) begin
        $display(" Test fail count : %d   \n", testfail_cnt);
        $display("-----------------------------------------------------");
        $display("----------------- SIMULATION PASSED -----------------");
        $display("-----------------------------------------------------");
      end else begin
        $display(" ERROR: Test fail count : %d   \n", testfail_cnt);
        $display("-----------------------------------------------------");
        $display("!!!!!!!!!!!!!!!!! SIMULATION FAILED !!!!!!!!!!!!!!!!!");
        $display("-----------------------------------------------------");
      end

      $display("%0t TEST END\n",$time);
      $finish;
        
   end
  end

  task check_data;
    integer actual_byte_count, i;
  begin
    actual_byte_count = byte_monitor.actual_byte_count;
  
    if ( exp_byte_count!= actual_byte_count) begin 
      $display("---------------------------------------------");
      $display("*** E R R O R: Actual and Expected byte counts are not equal***");
      $display("**** I N F O : Actual byte Count is %0d", actual_byte_count);
      $display("**** I N F O : Expected byte Count is %0d", exp_byte_count);
      $display("-----------------------------------------------------");
      $display("!!!!!!!!!!!!!!!!! SIMULATION FAILED !!!!!!!!!!!!!!!!!");
      $display("-----------------------------------------------------");
      testfail_cnt = testfail_cnt + 1;
    end
    else begin
      $readmemh("input_data.log", log_in);
      $readmemh("output_data.log", log_out);
      
      if (log_in[1] === {8{1'bx}}) begin
        $display("---------------------------------------------");
        $display("---------------------------------------------");
        $display("##### received_data.log FILE IS EMPTY ##### ");
        $display("---------------------------------------------");
        $display("---------------------------------------------");
        testfail_cnt = testfail_cnt + 1;
      end
      else begin
        $display("---------------------------------------------");
        $display("---------------------------------------------");
        $display("##### DATA COMPARISON IS STARTED ##### ");
        $display("---------------------------------------------");
        $display("---------------------------------------------");
      end
      i = 1;
      repeat (actual_byte_count) begin
        if (log_in[i] !== log_out[i]) begin
          $display("%0dns ERROR : Expected and Received datas are not matching. Line%0d",$time, i);
          $display("       Expected  %h", log_in  [i]);
          $display("       Received  %h", log_out [i]);
          testfail_cnt = testfail_cnt + 1;
        end  
        i = i+1;
      end
    end 
  end
  endtask


   `ifdef DSI_RESET_TEST1
   //Reset while data
   initial begin
      repeat (10) @(posedge byte_en_o);
      repeat (10) @(posedge byte_clk_i);
      #(pixclk_period*70)  reset_n = 1'b0; 
      #(pixclk_period*100) reset_n = 1'b1;
      byte_log_en = 1;
   end
   `endif

   `ifdef DSI_RESET_TEST2
   //Reset while hsync
   initial begin
      repeat (30) @(posedge hsync_i);
      @(posedge pix_clk_i);
      #(pixclk_period*70)  reset_n = 1'b0; 
      #(pixclk_period*100) reset_n = 1'b1;
      byte_log_en = 1;
   end
   `endif

   `ifdef DSI_RESET_TEST3
   //Reset while data
   initial begin
      @(posedge vsync_i);
      repeat (5) @(posedge pix_clk_i);
      #(pixclk_period*70)  reset_n = 1'b0; 
      #(pixclk_period*100) reset_n = 1'b1;
      byte_log_en = 1;
   end
   `endif


   `ifdef CSI2_RESET_TEST1
   //Reset while data
   initial begin
      repeat (10) @(posedge byte_en_o);
      repeat (10) @(posedge byte_clk_i);
      #(pixclk_period*70)  reset_n = 1'b0; 
      #(pixclk_period*100) reset_n = 1'b1;
      byte_log_en = 1;
   end
   `endif

   `ifdef CSI2_RESET_TEST2
   //Reset while data
   initial begin
      repeat (2) @(posedge fv_i);
      @(posedge pix_clk_i);
      #(pixclk_period*70)  reset_n = 1'b0; 
      #(pixclk_period*100) reset_n = 1'b1;
      byte_log_en = 1;
   end
   `endif

   `ifdef CSI2_RESET_TEST3
   //Reset while data
   initial begin
      repeat (10) @(posedge lv_i);
      @(posedge pix_clk_i);
      #(pixclk_period*70)  reset_n = 1'b0; 
      #(pixclk_period*100) reset_n = 1'b1;
      byte_log_en = 1;
   end
   `endif

   // Stop video generation after frame cnt reached num_frames
   initial begin
      wait(frame_cnt == num_frames)
      `ifdef TX_DSI
      @(negedge vsync_i);
      `endif
      start_vid = 0;
      $display($time," Video generation stopped \n");
   end

   task write_to_file (input [1024*8-1:0] str_in, input [7:0] data);
      integer filedesc;
      if(byte_log_en == 1)
      begin
         filedesc = $fopen(str_in,"a");
         $fwrite(filedesc, "%h\n", data);
         $fclose(filedesc);
      end
   endtask

   task write_vh (input [1024*8-1:0] str_in, input vsyn, input hsyn);
      integer filedesc;
      if(byte_log_en == 1)
      begin
         filedesc = $fopen(str_in,"a");
         $fwrite(filedesc, "VSYNC: %1d | HSYNC: %1d\n", vsyn, hsyn);
         $fclose(filedesc);
      end
   endtask

  if (DSI_FORMAT == 1) begin
 
    initial begin
       forever begin
          @(posedge hsync_i);
          @(posedge txfr_req_o);
          repeat (txfr_delay) begin
             @(posedge byte_clk_i);
          end
          @(posedge byte_clk_i);
          txfr_en_i <= 1;     
          repeat (4) begin
             @(posedge byte_clk_i);
          end  
          txfr_en_i <= 0;
       end
    end
    
    initial begin
       forever begin
          @(posedge de_i);
          @(posedge txfr_req_o);
          repeat (txfr_delay) begin
             @(posedge byte_clk_i);
          end
          txfr_en_i <= 1; 
          repeat (wc_delay+4) begin
             @(posedge byte_clk_i);
          end  
          txfr_en_i <= 0;
       end
    end
  
  end else begin

    initial begin
       forever begin
          @(fv_i);
          @(posedge txfr_req_o);
          @(negedge txfr_req_o);
          txfr_en_i <= 1; 
          repeat (4) begin
             @(posedge byte_clk_i);
          end  
          txfr_en_i <= 0;
       end
    end
    initial begin
       forever begin
          @(posedge lv_i);
          @(posedge txfr_req_o);
//          @(negedge txfr_req_o);
          repeat (txfr_delay) begin
             @(posedge byte_clk_i);
          end
          txfr_en_i <= 1; 
          `ifdef NUM_PIX_LANE_2
          repeat (wc_delay+5) begin
          `else
          repeat (wc_delay+4) begin
          `endif
             @(posedge byte_clk_i);
          end
          txfr_en_i <= 0;
       end
    end
  end

   initial begin
      pix_clk_i = 1;
      forever begin
         #pixclk_period pix_clk_i = ~pix_clk_i;
      end
   end

   initial begin
      byte_clk_i = 1;
      forever begin
         #byteclk_period byte_clk_i = ~byte_clk_i;
      end
   end

    initial begin
        if(enable_write_log == 1) begin
            fileOut  = $fopen("output_data.log","w");
            $fclose(fileOut);

            fileIn = $fopen("input_data.log","w");
            $fclose(fileIn);
        end
    end
   //This is to generate and drive the pixel data
   //Common driver for both DSI and CSI2
   vid_timing_gen_driver #(
      .WORD_WIDTH             (PIX_WIDTH),
      .test_hsync_front_porch (hfront_porch),
      .test_hsync_width       (hsync_pulse),
      .test_hsync_back_porch  (hback_porch),
      .test_h_width           (act_pix),
      .test_v_height          (total_line),
      .test_vsync_front_porch (vfront_porch),
      .test_vsync_width       (vsync_pulse),
      .test_vsync_back_porch  (vback_porch)
   ) I_vid_timing_gen_driver (
      .clk                  (pix_clk_i),
      .reset                (~reset_n),
      .vid_cntl_tgen_active (start_vid),
      .byte_log_en          (byte_log_en),
      `ifdef TX_DSI
      .tgen_vid_hsync       (hsync_i),
      .tgen_vid_vsync       (vsync_i),
      .tgen_vid_de          (de_i),
      `endif
      `ifdef TX_CSI2
      .tgen_vid_fv          (fv_i),
      .tgen_vid_lv          (lv_i),
      `endif
      .tgen_vid_data0       (pix_data0_i),
      .tgen_vid_data1       (pix_data1_i),
      .tgen_vid_data2       (pix_data2_i),
      .tgen_vid_data3       (pix_data3_i),
      .tgen_vid_data4       (pix_data4_i),
      .tgen_vid_data5       (pix_data5_i),
      .tgen_vid_data6       (pix_data6_i),
      .tgen_vid_data7       (pix_data7_i),
      .tgen_vid_data8       (pix_data8_i),
      .tgen_vid_data9       (pix_data9_i),
      .tgen_end_of_line     (),
      .tgen_end_of_frame    (eof)
   );

`include "dut_inst.v"

   byte_out_monitor #(
   .NUM_TX_LANE (NUM_TX_LANE),
   .TX_GEAR		(TX_GEAR)
   )
   byte_monitor
   (
      .byte_clk (byte_clk_i),
      .byte_en (byte_en_o),
      .byte_log_en (byte_log_en),
      .byte_dout (byte_data_o)
   );

   initial begin
      $shm_open("./dump.shm");
      $shm_probe(tb_top, ("AC"));
   end

reg CLK_GSR = 0;
reg USER_GSR = 1;

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

`ifdef TX_DSI
  `include "tb_include/test_snow_pixel2byte_dsi_reset.vh"
  `include "tb_include/test_snow_pixel2byte_dsi_trans.vh"
`else
  `include "tb_include/test_snow_pixel2byte_csi2_trans.vh"
  `include "tb_include/test_snow_pixel2byte_csi2_reset.vh"
`endif

endmodule                                  
