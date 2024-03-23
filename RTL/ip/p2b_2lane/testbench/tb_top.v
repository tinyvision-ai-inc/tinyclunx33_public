`timescale 1 ps / 1 fs
`include "tb_include/tb_params.vh"
`include "vid_timing_gen_driver.v"
`include "byte_out_monitor.v"

module tb_top();
  `include "dut_params.v"

  //below parameters are declared in tb_params.vh file
  `ifdef USER_DEFINED_PIXEL_COUNT
    parameter integer pix_per_line = `USER_PIXEL_COUNT;
    `ifdef RGB888     
      parameter integer num_bytes = pix_per_line*3;
    `elsif RGB666
      parameter integer num_bytes = pix_per_line*2.25;
    `elsif RAW8
      parameter integer num_bytes = pix_per_line;
    `elsif RAW10
      parameter integer num_bytes = pix_per_line*1.25;
    `elsif RAW12
      parameter integer num_bytes = pix_per_line*1.5;
    `elsif RAW14
      parameter integer num_bytes = pix_per_line*1.75;
    `elsif RAW16
      parameter integer num_bytes = pix_per_line*2;
    `elsif YUV420_8
      parameter integer num_bytes = pix_per_line;
    `elsif YUV420_10
      parameter integer num_bytes = pix_per_line*1.25;
    `elsif YUV422_8
      parameter integer num_bytes = pix_per_line;
    `elsif YUV422_10
      parameter integer num_bytes = pix_per_line*1.25;
    `endif
  `else
    `ifdef RGB888     
      parameter integer num_bytes = (`NUM_BYTES % 3 == 0) ? `NUM_BYTES:((`NUM_BYTES + 1) - ((`NUM_BYTES + 1)%3));
      parameter integer pix_per_line = num_bytes/3; // 3 bytes / 1 pixel
    `elsif RGB666
      parameter integer num_bytes = (`NUM_BYTES % 9 == 0) ? `NUM_BYTES:((`NUM_BYTES + 4) - ((`NUM_BYTES + 4)%9));
      parameter integer pix_per_line = num_bytes/2.25; // 9 bytes / 4 pixels
    `elsif RAW8
      parameter integer num_bytes = `NUM_BYTES;
      parameter integer pix_per_line = num_bytes; // 1 byte / 1 pixel
    `elsif RAW10
      parameter integer num_bytes = (`NUM_BYTES % 5 == 0) ? `NUM_BYTES:((`NUM_BYTES + 2) - ((`NUM_BYTES + 2)%5));
      parameter integer pix_per_line = num_bytes/1.25; // 5 bytes / 4 pixels
    `elsif RAW12
      parameter integer num_bytes = (`NUM_BYTES % 3 == 0) ? `NUM_BYTES:((`NUM_BYTES + 1) - ((`NUM_BYTES + 1)%3));
      parameter integer pix_per_line = num_bytes/1.5; // 3 bytes / 2 pixels
    `elsif RAW14
      parameter integer num_bytes = (`NUM_BYTES % 7 == 0) ? `NUM_BYTES:((`NUM_BYTES + 3) - ((`NUM_BYTES + 3)%7));
      parameter integer pix_per_line = num_bytes/1.75; // 7 bytes / 4 pixels
    `elsif RAW16
      parameter integer num_bytes = (`NUM_BYTES % 2 == 0) ? `NUM_BYTES:((`NUM_BYTES + 1) - ((`NUM_BYTES + 1)%2));
      parameter integer pix_per_line = num_bytes/2; // 2 bytes / 1 pixel
    `elsif YUV420_8
      parameter integer num_bytes = `NUM_BYTES;
      parameter integer pix_per_line = num_bytes; // 4 bytes / 2 pixels -> 1 pixel contains UY or VY pair so 4 8-bits
    `elsif YUV420_10
      parameter integer num_bytes = (`NUM_BYTES % 10 == 0) ? `NUM_BYTES:((`NUM_BYTES + 5) - ((`NUM_BYTES + 5)%10));
      parameter integer pix_per_line = num_bytes/1.25; // 10 bytes / 8 pixels -> basically 5 bytes to 4 pixels, 1 pixel contains UY or VY pair so 4 8-bits
    `elsif YUV422_8
      parameter integer num_bytes = `NUM_BYTES;
      parameter integer pix_per_line = num_bytes; // 4 bytes / 2 pixels -> 1 pixel contains UY or VY pair so 4 8-bits
    `elsif YUV422_10
      parameter integer num_bytes = (`NUM_BYTES % 5 == 0) ? `NUM_BYTES:((`NUM_BYTES + 2) - ((`NUM_BYTES + 2)%5));
      parameter integer pix_per_line = num_bytes/1.25; // 5 bytes / 2 pixels -> 1 pixel contains UY or VY pair so 4 8-bits
    `endif
  `endif
  
  parameter num_frames = `NUM_FRAMES;
  parameter num_lines = `NUM_LINES;

  parameter hfront_porch = `HFRONT;
  parameter hsync_pulse  = `HPULSE;
  parameter hback_porch  = `HBACK;
  parameter vfront_porch = `VFRONT;
  parameter vsync_pulse  = `VPULSE;
  parameter vback_porch  = `VBACK;

  parameter fv_to_lv = (`VBACK*(`HPULSE+`HFRONT+`HBACK+pix_per_line))+(`HPULSE+`HBACK);
  parameter lv_to_fv = `HFRONT+(`VFRONT*(`HPULSE+`HFRONT+`HBACK+pix_per_line));
  parameter lv_to_lv = `HPULSE+`HFRONT+`HBACK;
  parameter fv_to_fv = `VPULSE*(`HPULSE+`HFRONT+`HBACK+pix_per_line);
  
  parameter pixclk_period  = 1000000/`PIX_CLK_FREQ; //clk period is in pico seconds
  parameter byteclk_freq = (`PIX_CLK_FREQ*PIX_WIDTH*NUM_PIX_LANE)/(NUM_TX_LANE*TX_GEAR); //byte clk freq derived from pix clk freq
  parameter byteclk_period = 1000000/byteclk_freq; //clk period is in pico seconds
  
  
  `ifdef TX_GEAR_16
       parameter wc_delay = num_bytes/(2*NUM_TX_LANE);
  `else 
       parameter wc_delay = num_bytes/NUM_TX_LANE;
  `endif
  integer txfr_delay = 100000/byteclk_period;

  // Defines for a unified YUV420 data type for odd_line_o checking
  `ifdef YUV420_8
      `define YUV420
  `elsif YUV420_10
      `define YUV420
  `endif
  
  reg reset_n = 0;
  reg pix_clk  = 0; 
  reg byte_clk = 0;
  reg byte_log_en = 0;
  wire end_of_frame;
  
  // DUT signals
  //Clock and reset
  wire rst_n_i;
  wire pix_clk_i;
  wire byte_clk_i;
  //For CSI-2
  wire fv_i;
  wire lv_i;
  wire dvalid_i;    
  wire fv_start_o;
  wire fv_end_o;
  wire lv_start_o;
  wire lv_end_o;
  //For DSI
  wire vsync_i;
  wire hsync_i;
  wire de_i;    
  wire vsync_start_o;
  wire vsync_end_o;
  wire hsync_start_o;
  wire hsync_end_o;
  //Input data
  wire [PIX_WIDTH-1:0] pix_data0_i;
  wire [PIX_WIDTH-1:0] pix_data1_i;
  wire [PIX_WIDTH-1:0] pix_data2_i;
  wire [PIX_WIDTH-1:0] pix_data3_i;
  wire [PIX_WIDTH-1:0] pix_data4_i;
  wire [PIX_WIDTH-1:0] pix_data5_i;
  wire [PIX_WIDTH-1:0] pix_data6_i;
  wire [PIX_WIDTH-1:0] pix_data7_i;
  wire [PIX_WIDTH-1:0] pix_data8_i;
  wire [PIX_WIDTH-1:0] pix_data9_i;
  //Handshake/Misc signals
  reg c2d_ready_i = 1'b1;    
  wire txfr_req_o;
  reg txfr_en_i = 1'b0;
  wire odd_line_o;
  //Byte output
  wire byte_en_o;
  wire [(NUM_TX_LANE*TX_GEAR)-1:0] byte_data_o;
  wire [5:0] data_type_o;
  
  //for input and output text files
  integer fileIn;
  integer fileOut;
  reg enable_write_log = 1;
  reg [7:0] log_out [(num_bytes*num_frames*num_lines)-1:0];
  reg [7:0] log_in [(num_bytes*num_frames*num_lines)-1:0];
  //counters for checking
  integer line_cnt  = 0;
  integer frame_cnt = 0;
  integer pixel_cnt = 0;
  integer testfail_cnt = 0;
  integer warning_cnt = 0;
  
  //generating pix_clk
  initial begin
    pix_clk = 1;
    forever begin
      #(pixclk_period/2) pix_clk = ~pix_clk;
    end
  end

 //generating byte_clk
  initial begin
    byte_clk = 1;
    forever begin
      #(byteclk_period/2) byte_clk = ~byte_clk;
    end
  end

  
  GSR GSR_INST (
    .GSR_N(reset_n),
    .CLK(pix_clk)
  );
  
  assign rst_n_i = reset_n;
  assign pix_clk_i = pix_clk;
  assign byte_clk_i = byte_clk;
  
  //instantiate and assign generator and monitor modules
  vid_timing_gen_driver #(
    .PIX_WIDTH(PIX_WIDTH),
    .NUM_PIX_LANE(NUM_PIX_LANE),
    .num_frames(num_frames),
    .num_lines(num_lines),
    .pix_per_line(pix_per_line),
    .hfront_porch(hfront_porch),
    .hsync_pulse(hsync_pulse),
    .hback_porch(hback_porch),
    .vfront_porch(vfront_porch),
    .vsync_pulse(vsync_pulse),
    .vback_porch(vback_porch),
    .fv_to_lv(fv_to_lv),
    .lv_to_fv(lv_to_fv),
    .lv_to_lv(lv_to_lv),
    .fv_to_fv(fv_to_fv),
    .wc_delay(wc_delay)
  ) I_vid_timing_gen_driver (
    .rst_n_i(rst_n_i),
    .pix_clk_i(pix_clk_i),
    .byte_clk_i(byte_clk_i),
    .fv_i(fv_i),
    .lv_i(lv_i),
    .dvalid_i(dvalid_i),
    .vsync_i(vsync_i),
    .hsync_i(hsync_i),
    .de_i(de_i),
    .pix_data0_i(pix_data0_i),
    .pix_data1_i(pix_data1_i),
    .pix_data2_i(pix_data2_i),
    .pix_data3_i(pix_data3_i),
    .pix_data4_i(pix_data4_i),
    .pix_data5_i(pix_data5_i),
    .pix_data6_i(pix_data6_i),
    .pix_data7_i(pix_data7_i),
    .pix_data8_i(pix_data8_i),
    .pix_data9_i(pix_data9_i),
    .byte_log_en(byte_log_en),
    .end_of_frame(end_of_frame)
  );
  
  `include "dut_inst.v"    //dut connection to p2b rtl top module
  
  byte_out_monitor #(
    .NUM_TX_LANE(NUM_TX_LANE),
    .TX_GEAR(TX_GEAR)
  ) byte_monitor
  (
    .byte_clk_i(byte_clk_i),
    .byte_log_en(byte_log_en),
    .byte_en(byte_en_o),
    .byte_dout(byte_data_o)
  );
  
  //check to make sure that byte data transmission of previous line has finished before new line or frame input for CSI-2
  `ifdef TX_CSI2
    always@(posedge fv_i) begin
      if (byte_en_o == 1) begin
        $display($time, "ps ERROR : New fv_i assertion detected while output byte data transmission is still ongoing");
        warning_cnt = warning_cnt + 1;
      end
    end
    always@(posedge lv_i) begin
      if (byte_en_o == 1) begin
        $display($time, "ps ERROR : New lv_i assertion detected while output byte data transmission is still ongoing");
        warning_cnt = warning_cnt + 1;
      end
    end
  `endif

  // Define a test for checking odd_line_o for the YUV420 data types
  `ifdef YUV420
    always@(posedge lv_i) begin
      @(odd_line_o);
      if (line_cnt % 2 == 0 && odd_line_o) begin
        $display("ERROR: odd_line_o is asserted for an even line. At frame number: %0d, line number: %0d.", frame_cnt+1, line_cnt);
        testfail_cnt = testfail_cnt + 1;
      end
      else if (line_cnt % 2 != 0 && ~odd_line_o) begin
        $display("ERROR: odd_line_o is deasserted for an odd line. At frame number: %0d, line number: %0d.", frame_cnt+1, line_cnt);
        testfail_cnt = testfail_cnt + 1;
      end
    end
  `endif
  
  `ifdef TRANS_TEST
    initial begin 
      reset_n       = 1'b0;

      $display("%0t TEST START\n",$time);
      
      //Warning will be issued if `NUM_BYTES in tb_params.vh do not follow the following limitations:
      //1. Number of bytes must be a multiple of the required bytes needed for pixel-to-byte conversion
      //2. Number of pixels calculated from the number of bytes must be a multiple of the number of input pixel lanes.
      //   If not, expected and actual number of bytes will not match.
      //3. Number of bytes must be compatible with output byte data width.
      //   If not, expected and actual number of bytes will not match.
      if ((DATA_TYPE == "RGB888") && (num_bytes % 3 != 0)) begin
        $display("WARNING: Number of bytes must be a multiple of 3 for RGB888.\n If not, this will cause the expected and actual number of bytes to not match.");
        $display("Number of bytes in tb_params = %0d  \n", num_bytes);
        warning_cnt = warning_cnt + 1;
      end
      if ((DATA_TYPE == "RGB666") && (num_bytes % 9 != 0)) begin
        $display("WARNING: Number of bytes must be a multiple of 9 for RGB666.\n If not, this will cause the expected and actual number of bytes to not match.");
        $display("Number of bytes in tb_params = %0d  \n", num_bytes);
        warning_cnt = warning_cnt + 1;
      end
      if ((DATA_TYPE == "RAW10") && (num_bytes % 5 != 0)) begin
        $display("WARNING: Number of bytes must be a multiple of 5 for RAW10.\n If not, this will cause the expected and actual number of bytes to not match.");
        $display("Number of bytes in tb_params = %0d  \n", num_bytes);
        warning_cnt = warning_cnt + 1;
      end
      if ((DATA_TYPE == "RAW12") && (num_bytes % 3 != 0)) begin
        $display("WARNING: Number of bytes must be a multiple of 3 for RAW12.\n If not, this will cause the expected and actual number of bytes to not match.");
        $display("Number of bytes in tb_params = %0d  \n", num_bytes);
        warning_cnt = warning_cnt + 1;
      end
      if ((DATA_TYPE == "RAW14") && (num_bytes % 7 != 0)) begin
        $display("WARNING: Number of bytes must be a multiple of 7 for RAW14.\n If not, this will cause the expected and actual number of bytes to not match.");
        $display("Number of bytes in tb_params = %0d  \n", num_bytes);
        warning_cnt = warning_cnt + 1;
      end
      if ((DATA_TYPE == "RAW16") && (num_bytes % 2 != 0)) begin
        $display("WARNING: Number of bytes must be a multiple of 2 for RAW16.\n If not, this will cause the expected and actual number of bytes to not match.");
        $display("Number of bytes in tb_params = %0d  \n", num_bytes);
        warning_cnt = warning_cnt + 1;
      end
      if ((DATA_TYPE == "YUV420_8") && (num_bytes % 4 != 0)) begin
        $display("WARNING: Number of bytes must be a multiple of 4 for YUV420_8.\n If not, this will cause the expected and actual number of bytes to not match.");
        $display("Number of bytes in tb_params = %0d  \n", num_bytes);
        warning_cnt = warning_cnt + 1;
      end
      if ((DATA_TYPE == "YUV420_10") && (num_bytes % 10 != 0)) begin
        $display("WARNING: Number of bytes must be a multiple of 10 for YUV420_10.\n If not, this will cause the expected and actual number of bytes to not match.");
        $display("Number of bytes in tb_params = %0d  \n", num_bytes);
        warning_cnt = warning_cnt + 1;
      end
      if ((DATA_TYPE == "YUV422_8") && (num_bytes % 4 != 0)) begin
        $display("WARNING: Number of bytes must be a multiple of 4 for YUV422_8.\n If not, this will cause the expected and actual number of bytes to not match.");
        $display("Number of bytes in tb_params = %0d  \n", num_bytes);
        warning_cnt = warning_cnt + 1;
      end
      if ((DATA_TYPE == "YUV422_10") && (num_bytes % 5 != 0)) begin
        $display("WARNING: Number of bytes must be a multiple of 5 for YUV422_10.\n If not, this will cause the expected and actual number of bytes to not match.");
        $display("Number of bytes in tb_params = %0d  \n", num_bytes);
        warning_cnt = warning_cnt + 1;
      end
      if ((DATA_TYPE == "YUV420_8") || (DATA_TYPE == "YUV420_10")) begin
        if (pix_per_line % NUM_PIX_LANE != 0) begin
          $display("WARNING: Pixel count for even lines calculated from num_bytes is not a multiple of the number of input pixel lanes\n This will cause the expected and actual number of bytes to not match.\n");
          $display("NUM_PIX_LANE = %0d; Pixels per line = %0d  \n", NUM_PIX_LANE, pix_per_line);
          warning_cnt = warning_cnt + 1;
        end
        if ((pix_per_line/2) % NUM_PIX_LANE != 0) begin
          $display("WARNING: Pixel count for odd lines calculated from num_bytes is not a multiple of the number of input pixel lanes\n This will cause the expected and actual number of bytes to not match.\n");
          $display("NUM_PIX_LANE = %0d; Pixels per line = %0d  \n", NUM_PIX_LANE, pix_per_line/2);
          warning_cnt = warning_cnt + 1;
        end
      end
      else begin
        if (pix_per_line % NUM_PIX_LANE != 0) begin
          $display("WARNING: Pixel count calculated from num_bytes is not a multiple of the number of input pixel lanes\n This will cause the expected and actual number of bytes to not match.\n");
          $display("NUM_PIX_LANE = %0d; Pixels per line = %0d  \n", NUM_PIX_LANE, pix_per_line);
          warning_cnt = warning_cnt + 1;
        end
      end
      if (num_bytes % ((NUM_TX_LANE*TX_GEAR)/8) != 0) begin
        $display("WARNING: Number of bytes not compatible with the output data width\n This will cause the expected and actual number of bytes to not match.");
        $display("Output byte data width = %0d bytes (%0d bits); Number of bytes = %0d  \n", (NUM_TX_LANE*TX_GEAR)/8, NUM_TX_LANE*TX_GEAR, num_bytes);
        warning_cnt = warning_cnt + 1;
      end
      
      #(pixclk_period*70)  reset_n = 1'b1;

      byte_log_en = 1;      
      `ifdef TX_DSI
        $display("No. of lines : %d\n", num_lines);
        $display("Pixels per line : %d\n", pix_per_line);
        $display("HSYNC frontporch : %d\n", hfront_porch);
        $display("HSYNC pulse width : %d\n", hsync_pulse);
        $display("HSYNC backporch  : %d\n", hback_porch);
        $display("VSYNC frontporch : %d\n", vfront_porch);
        $display("VSYNC pulse width : %d\n", vsync_pulse);
        $display("VSYNC backporch  : %d\n", vback_porch);
        test_snow_pixel2byte_dsi_trans();
      `endif
      `ifdef TX_CSI2
        $display("No. of lines : %d\n", num_lines);
        $display("Pixels per line : %d\n", pix_per_line);
        $display("Frame valid to Line valid : %d\n", fv_to_lv);
        $display("Line valid to Line valid : %d\n", lv_to_lv);
        $display("Line valid to Frame valid : %d\n", lv_to_fv);
        $display("Frame valid to Frame valid : %d\n", fv_to_fv);
        test_snow_pixel2byte_csi2_trans();
      `endif
      #50000000; //#100;
      // In check_data():
      //1) Checking the actual byte count from monitor(which is counted when byte_en_o is high) and comparing with the expected byte count. When there is a mismatch, the test fail count is incremented.
      //2) They are reading input_data.log file into log_in array and checking first location of array if data is present or not. If data is x, they are incrementing the test fail count. If data is present in 1st location of log_in array, then they are starting data comparison.
      //3) They are checking each location of log_in array and comparing with the same location of log_out array(loaded from output_data.log file). If any mismatches in any location, they are incrementing the test fail count
      check_data();
      if(warning_cnt != 0) begin
        $display("Warning count : %0d   \n", warning_cnt);
      end
      else begin
        $display("NO WARNINGS");
      end
      //final check: testfail_cnt should be 0 at the end of the test.
      if(testfail_cnt == 0) begin
        $display("Test fail count : %0d   \n", testfail_cnt);
        $display("-----------------------------------------------------");
        $display("----------------- SIMULATION PASSED -----------------");
        $display("-----------------------------------------------------");
      end
      else begin
        $display("ERROR: Test fail count : %0d   \n", testfail_cnt);
        //write testfail_cnt into any one log file, so that auto file comparisons will also fail.
        write_to_file("input_data.log", testfail_cnt);
        $display("-----------------------------------------------------");
        $display("!!!!!!!!!!!!!!!!! SIMULATION FAILED !!!!!!!!!!!!!!!!!");
        $display("-----------------------------------------------------");
      end

      $display("%0t TEST END\n",$time);
      $finish;      
    end
  `endif
  
  task check_data(); //compare expected and actual byte data
    integer actual_byte_count;
    integer exp_byte_count;
    integer pix_cnt_chk;
    integer byte_cnt_chk;
    integer line_cnt_chk;
    integer frame_cnt_chk;
    integer i;
    
    begin
      actual_byte_count = byte_monitor.actual_byte_count;
      byte_cnt_chk = 0;
      pix_cnt_chk = 1;
      line_cnt_chk = 1;
      frame_cnt_chk = 1;
      i = 0;
      
      if ((DATA_TYPE == "YUV420_8") || (DATA_TYPE == "YUV420_10")) begin
        `ifdef USER_DEFINED_PIXEL_COUNT
          exp_byte_count = (num_bytes*num_frames*$floor(num_lines/2)) + ((num_bytes/2)*num_frames*(num_lines - $floor(num_lines/2)));
        `else
          exp_byte_count = (`NUM_BYTES*num_frames*$floor(num_lines/2)) + ((`NUM_BYTES/2)*num_frames*(num_lines - $floor(num_lines/2)));
        `endif
      end
      else begin
        `ifdef USER_DEFINED_PIXEL_COUNT
          exp_byte_count = num_bytes*num_frames*num_lines;
        `else
          exp_byte_count = `NUM_BYTES*num_frames*num_lines;
        `endif
      end
  
      if (actual_byte_count != exp_byte_count) begin 
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
        $readmemh("input_data.log", log_in); //chnged from hex to binary read by pavan; changed to hex by msagun
        $readmemh("output_data.log", log_out); //chnged from hex to binary read by pavan; changed to hex by msagun
        
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
          `ifdef RGB888
            repeat (exp_byte_count) begin              
              byte_cnt_chk = byte_cnt_chk + 1;
              if (log_in[i] !== log_out[i]) begin
                $display("ERROR : Expected and Received byte data are not matching for pixel #%0d and byte #%0d in line %0d frame %0d", pix_cnt_chk,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                $display("       Expected  %h", log_in[i]);
                $display("       Received  %h", log_out[i]);
                testfail_cnt = testfail_cnt + 1;
              end
              i = i + 1;
              if (byte_cnt_chk % 3 == 0) begin
                pix_cnt_chk = pix_cnt_chk + 1;
              end              
              if (byte_cnt_chk == num_bytes) begin
                line_cnt_chk = line_cnt_chk + 1;
                pix_cnt_chk = 1;
                byte_cnt_chk = 0;
                if (line_cnt_chk > num_lines) begin
                  frame_cnt_chk = frame_cnt_chk + 1;
                  line_cnt_chk = 1;
                end
              end
            end
          `endif
          `ifdef RGB666
            repeat (exp_byte_count) begin
              byte_cnt_chk = byte_cnt_chk + 1;
              if (byte_cnt_chk % 9 == 1) begin
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [7:0] and byte #%0d in line %0d frame %0d", pix_cnt_chk,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
              end
              else if (byte_cnt_chk % 9 == 2) begin
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [15:8] and byte #%0d in line %0d frame %0d", pix_cnt_chk,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
              end
              else if (byte_cnt_chk % 9 == 3) begin
                pix_cnt_chk = pix_cnt_chk + 1;
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [17:16],#%0d [5:0] and byte #%0d in line %0d frame %0d", pix_cnt_chk,pix_cnt_chk-1,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
              end
              else if (byte_cnt_chk % 9 == 4) begin
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [13:6] and byte #%0d in line %0d frame %0d", pix_cnt_chk,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
              end
              else if (byte_cnt_chk % 9 == 5) begin
                pix_cnt_chk = pix_cnt_chk + 1;
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [3:0],#%0d [17:14] and byte #%0d in line %0d frame %0d", pix_cnt_chk,pix_cnt_chk-1,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
              end
              else if (byte_cnt_chk % 9 == 6) begin //every 6th byte
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [11:4] and byte #%0d in line %0d frame %0d", pix_cnt_chk-3,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;          
              end
              else if (byte_cnt_chk % 9 == 7) begin
                pix_cnt_chk = pix_cnt_chk + 1;
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [1:0],#%0d [17:12] and byte #%0d in line %0d frame %0d", pix_cnt_chk,pix_cnt_chk-1,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;         
              end
              else if (byte_cnt_chk % 9 == 8) begin //every 6th byte
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [9:2] and byte #%0d in line %0d frame %0d", pix_cnt_chk-4,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;              
              end
              else begin //every 9th byte
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [17:10] and byte #%0d in line %0d frame %0d", pix_cnt_chk-5,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
              end
              if (byte_cnt_chk == num_bytes) begin
                line_cnt_chk = line_cnt_chk + 1;
                pix_cnt_chk = 1;
                byte_cnt_chk = 0;
                if (line_cnt_chk > num_lines) begin
                  frame_cnt_chk = frame_cnt_chk + 1;
                  line_cnt_chk = 1;
                end
              end
            end
          `endif
          `ifdef RAW8
            repeat (exp_byte_count) begin
              byte_cnt_chk = byte_cnt_chk + 1;
              pix_cnt_chk = pix_cnt_chk + 1;
              if (log_in[i] !== log_out[i]) begin
                $display("ERROR : Expected and Received byte data are not matching for pixel #%0d and byte #%0d in line %0d frame %0d", pix_cnt_chk,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                $display("       Expected  %h", log_in[i]);
                $display("       Received  %h", log_out[i]);
                testfail_cnt = testfail_cnt + 1;
              end
              i = i + 1;
              if (byte_cnt_chk == num_bytes) begin
                line_cnt_chk = line_cnt_chk + 1;
                pix_cnt_chk = 1;
                byte_cnt_chk = 0;
                if (line_cnt_chk > num_lines) begin
                  frame_cnt_chk = frame_cnt_chk + 1;
                  line_cnt_chk = 1;
                end
              end
            end
          `endif
          `ifdef RAW10
            repeat (exp_byte_count) begin
              byte_cnt_chk = byte_cnt_chk + 1;
              if (byte_cnt_chk % 5 == 0) begin //every 5th byte
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d,#%0d,#%0d,#%0d [1:0] and byte #%0d in line %0d frame %0d", pix_cnt_chk-1,pix_cnt_chk-2,pix_cnt_chk-3,pix_cnt_chk-4,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
              end
              else begin
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [9:2] and byte #%0d in line %0d frame %0d", pix_cnt_chk,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
                pix_cnt_chk = pix_cnt_chk + 1;
              end
              if (byte_cnt_chk == num_bytes) begin
                line_cnt_chk = line_cnt_chk + 1;
                pix_cnt_chk = 1;
                byte_cnt_chk = 0;
                if (line_cnt_chk > num_lines) begin
                  frame_cnt_chk = frame_cnt_chk + 1;
                  line_cnt_chk = 1;
                end
              end
            end
          `endif
          `ifdef RAW12
            repeat (exp_byte_count) begin
              byte_cnt_chk = byte_cnt_chk + 1;
              if (byte_cnt_chk % 3 == 0) begin //every 3rd byte
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d,#%0d [3:0] and byte #%0d in line %0d frame %0d", pix_cnt_chk-1,pix_cnt_chk-2,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
                pix_cnt_chk = pix_cnt_chk + 1;
              end
              else begin
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [11:4] and byte #%0d in line %0d frame %0d", pix_cnt_chk,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
                pix_cnt_chk = pix_cnt_chk + 1;
              end
              if (byte_cnt_chk == num_bytes) begin
                line_cnt_chk = line_cnt_chk + 1;
                pix_cnt_chk = 1;
                byte_cnt_chk = 0;
                if (line_cnt_chk > num_lines) begin
                  frame_cnt_chk = frame_cnt_chk + 1;
                  line_cnt_chk = 1;
                end
              end
            end
          `endif
          `ifdef RAW14
            repeat (exp_byte_count) begin
              byte_cnt_chk = byte_cnt_chk + 1;
              if ((byte_cnt_chk % 7 == 1) || (byte_cnt_chk % 7 == 2) || (byte_cnt_chk % 7 == 3) || (byte_cnt_chk % 7 == 4)) begin
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [13:6] and byte #%0d in line %0d frame %0d", pix_cnt_chk,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
                pix_cnt_chk = pix_cnt_chk + 1;
              end
              else if (byte_cnt_chk % 7 == 5) begin //every 5th byte
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [1:0],#%0d [5:0] and byte #%0d in line %0d frame %0d", pix_cnt_chk-3,pix_cnt_chk-4,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;          
              end
              else if (byte_cnt_chk % 7 == 6) begin //every 6th byte
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [3:0],#%0d [5:2] and byte #%0d in line %0d frame %0d", pix_cnt_chk-2,pix_cnt_chk-3,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;             
              end
              else begin //every 7th byte
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [5:0],#%0d [5:4] and byte #%0d in line %0d frame %0d", pix_cnt_chk-1,pix_cnt_chk-2,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;        
              end
              if (byte_cnt_chk == num_bytes) begin
                line_cnt_chk = line_cnt_chk + 1;
                pix_cnt_chk = 1;
                byte_cnt_chk = 0;
                if (line_cnt_chk > num_lines) begin
                  frame_cnt_chk = frame_cnt_chk + 1;
                  line_cnt_chk = 1;
                end
              end
            end
          `endif
          `ifdef RAW16
            repeat (exp_byte_count) begin              
              byte_cnt_chk = byte_cnt_chk + 1;              
              if (log_in[i] !== log_out[i]) begin
                $display("ERROR : Expected and Received byte data are not matching for pixel #%0d and byte #%0d in line %0d frame %0d", pix_cnt_chk,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                $display("       Expected  %h", log_in[i]);
                $display("       Received  %h", log_out[i]);
                testfail_cnt = testfail_cnt + 1;
              end
              i = i + 1;
              if (byte_cnt_chk % 2 == 0) begin
                pix_cnt_chk = pix_cnt_chk + 1;
              end              
              if (byte_cnt_chk == num_bytes) begin
                line_cnt_chk = line_cnt_chk + 1;
                pix_cnt_chk = 1;
                byte_cnt_chk = 0;
                if (line_cnt_chk > num_lines) begin
                  frame_cnt_chk = frame_cnt_chk + 1;
                  line_cnt_chk = 1;
                end
              end
            end
          `endif
          `ifdef YUV420_8
            repeat (exp_byte_count) begin              
              byte_cnt_chk = byte_cnt_chk + 1;        
              if (log_in[i] !== log_out[i]) begin
                $display("ERROR : Expected and Received byte data are not matching for pixel #%0d and byte #%0d in line %0d frame %0d", pix_cnt_chk,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                $display("       Expected  %h", log_in[i]);
                $display("       Received  %h", log_out[i]);
                testfail_cnt = testfail_cnt + 1;
              end
              i = i + 1;
              if (line_cnt_chk % 2 == 0) begin //even line
                if (byte_cnt_chk == num_bytes) begin
                  line_cnt_chk = line_cnt_chk + 1;
                  pix_cnt_chk = 1;
                  byte_cnt_chk = 0;
                  if (line_cnt_chk > num_lines) begin
                    frame_cnt_chk = frame_cnt_chk + 1;
                    line_cnt_chk = 1;
                  end
                end
              end
              else begin
                if (byte_cnt_chk == num_bytes/2) begin
                  line_cnt_chk = line_cnt_chk + 1;
                  pix_cnt_chk = 1;
                  byte_cnt_chk = 0;
                  if (line_cnt_chk > num_lines) begin
                    frame_cnt_chk = frame_cnt_chk + 1;
                    line_cnt_chk = 1;
                  end
                end
              end
            end
          `endif
          `ifdef YUV420_10
            repeat (exp_byte_count) begin
              byte_cnt_chk = byte_cnt_chk + 1;
              if (byte_cnt_chk % 5 == 0) begin //every 5th byte
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d,#%0d,#%0d,#%0d [1:0] and byte #%0d in line %0d frame %0d", pix_cnt_chk-1,pix_cnt_chk-2,pix_cnt_chk-3,pix_cnt_chk-4,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
              end
              else begin
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [9:2] and byte #%0d in line %0d frame %0d", pix_cnt_chk,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
                pix_cnt_chk = pix_cnt_chk + 1;
              end
              if (byte_cnt_chk == num_bytes) begin
                line_cnt_chk = line_cnt_chk + 1;
                pix_cnt_chk = 1;
                byte_cnt_chk = 0;
                if (line_cnt_chk > num_lines) begin
                  frame_cnt_chk = frame_cnt_chk + 1;
                  line_cnt_chk = 1;
                end
              end
            end
          `endif
          `ifdef YUV422_8
            repeat (exp_byte_count) begin              
              byte_cnt_chk = byte_cnt_chk + 1;         
              if (log_in[i] !== log_out[i]) begin
                $display("ERROR : Expected and Received byte data are not matching for pixel #%0d and byte #%0d in line %0d frame %0d", pix_cnt_chk,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                $display("       Expected  %h", log_in[i]);
                $display("       Received  %h", log_out[i]);
                testfail_cnt = testfail_cnt + 1;
              end
              i = i + 1;
              if (byte_cnt_chk == num_bytes) begin
                line_cnt_chk = line_cnt_chk + 1;
                pix_cnt_chk = 1;
                byte_cnt_chk = 0;
                if (line_cnt_chk > num_lines) begin
                  frame_cnt_chk = frame_cnt_chk + 1;
                  line_cnt_chk = 1;
                end
              end
            end
          `endif
          `ifdef YUV422_10
            repeat (exp_byte_count) begin
              byte_cnt_chk = byte_cnt_chk + 1;
              if (byte_cnt_chk % 5 == 0) begin //every 5th byte
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d,#%0d,#%0d,#%0d [1:0] and byte #%0d in line %0d frame %0d", pix_cnt_chk-1,pix_cnt_chk-2,pix_cnt_chk-3,pix_cnt_chk-4,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
              end
              else begin
                if (log_in[i] !== log_out[i]) begin
                  $display("ERROR : Expected and Received byte data are not matching for pixel #%0d [9:2] and byte #%0d in line %0d frame %0d", pix_cnt_chk,byte_cnt_chk,line_cnt_chk,frame_cnt_chk);
                  $display("       Expected  %h", log_in[i]);
                  $display("       Received  %h", log_out[i]);
                  testfail_cnt = testfail_cnt + 1;
                end
                i = i + 1;
                pix_cnt_chk = pix_cnt_chk + 1;
              end
              if (byte_cnt_chk == num_bytes) begin
                line_cnt_chk = line_cnt_chk + 1;
                pix_cnt_chk = 1;
                byte_cnt_chk = 0;
                if (line_cnt_chk > num_lines) begin
                  frame_cnt_chk = frame_cnt_chk + 1;
                  line_cnt_chk = 1;
                end
              end
            end
          `endif
        end
      end
    end
  endtask
  
  `ifdef DSI_RESET_TEST
	initial begin
		forever begin
			@(posedge byte_clk_i);
			if(reset_n==1'b0) begin
				test_snow_pixel2byte_dsi_reset;
			end
		end
	end
	`endif
	
	`ifdef CSI2_RESET_TEST
	initial begin
		forever begin
    	@(posedge byte_clk_i);
			if(reset_n==1'b0) begin
				test_snow_pixel2byte_csi2_reset;
			end
		end
	end
	`endif
	
	`ifdef DSI_RESET_TEST
	initial begin
		reset_n       = 1'b0;
		$display("%0t RESET TEST START\n",$time);
		#(pixclk_period*70)  reset_n = 1'b1; 
		#(pixclk_period*100) reset_n = 1'b0;
    #(pixclk_period*100) reset_n = 1'b1;
		$display($time, " Output ports reset value checking done. ");
		if(testfail_cnt == 0) begin
      $display(" Test fail count : %d   \n", testfail_cnt);
      $display("-----------------------------------------------------");
      $display("***************** RESET TEST PASSED *****************");
      $display("-----------------------------------------------------");
		end else begin
      $display("ERROR: Test fail count : %d   \n", testfail_cnt);
      $display("-----------------------------------------------------");
      $display("***************** RESET TEST FAILED *****************");
      $display("-----------------------------------------------------");
		end
    #50000000;
		$display("%0t RESET TEST END\n",$time);
	end
	`elsif CSI2_RESET_TEST
	initial begin
		reset_n       = 1'b0;
		$display("%0t RESET TEST START\n",$time);
		#(pixclk_period*70)  reset_n = 1'b1; 
		#(pixclk_period*270) reset_n = 1'b0;
    #(pixclk_period*100) reset_n = 1'b1;
		$display($time, " Output ports reset value checking done. ");
		if(testfail_cnt == 0) begin
      $display(" Test fail count : %d   \n", testfail_cnt);
      $display("-----------------------------------------------------");
      $display("***************** RESET TEST PASSED *****************");
      $display("-----------------------------------------------------");
		end
    else begin
      $display("ERROR: Test fail count : %d   \n", testfail_cnt);
      $display("-----------------------------------------------------");
      $display("***************** RESET TEST FAILED *****************");
      $display("-----------------------------------------------------");
		end
    #50000000;
		$display("%0t RESET TEST END\n",$time);
	end
	`endif

  //Handshake
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
        repeat (wc_delay+10) begin
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
        repeat (txfr_delay) begin
           @(posedge byte_clk_i);
        end
        txfr_en_i <= 1; 
        repeat (4) begin
           @(posedge byte_clk_i);
        end
        txfr_en_i <= 0;
      end
    end
    initial begin
      forever begin
        @(negedge lv_i);
        @(posedge txfr_req_o);
        repeat (txfr_delay) begin
           @(posedge byte_clk_i);
        end
        txfr_en_i <= 1; 
        repeat (4) begin
          @(posedge byte_clk_i);
        end
        if (byte_en_o == 0) begin
          txfr_en_i <= 0;
        end
      end
    end
    initial begin
      forever begin
        @(posedge lv_i);
        @(posedge txfr_req_o);
        repeat (txfr_delay) begin
           @(posedge byte_clk_i);
        end
        txfr_en_i <= 1; 
        if ((DATA_TYPE == "YUV420_8") || (DATA_TYPE == "YUV420_10")) begin
          if (line_cnt % 2 == 0) begin//even line
            repeat (wc_delay+10) begin
              @(posedge byte_clk_i);
            end
          end
          else begin //odd line
            repeat ((wc_delay/2)+10) begin
              @(posedge byte_clk_i);
            end
          end
        end
        else begin
          repeat (wc_delay+10) begin
            @(posedge byte_clk_i);
          end
        end
        txfr_en_i <= 0;
      end
    end
  end

  //enabling the writing of input and output log files
  initial begin
    if(enable_write_log == 1) begin
      fileOut  = $fopen("output_data.log","w");
      $fclose(fileOut);

      fileIn = $fopen("input_data.log","w");
      $fclose(fileIn);
    end
  end
  
  task write_to_file (input [1024*8-1:0] str_in, input [7:0] data);
    integer filedesc;
    if(byte_log_en == 1) begin
      begin
        filedesc = $fopen(str_in,"a");
        $fwrite(filedesc, "%d\n", data);
        $fclose(filedesc);
      end
    end
  endtask
  
  //picking the reset and tx header files based on csi or dsi
  `ifdef TX_DSI
  `include "tb_include/test_snow_pixel2byte_dsi_reset.vh"
  `include "tb_include/test_snow_pixel2byte_dsi_trans.vh"
  `endif
  `ifdef TX_CSI2
  `include "tb_include/test_snow_pixel2byte_csi2_trans.vh"
  `include "tb_include/test_snow_pixel2byte_csi2_reset.vh"
  `endif
   
endmodule