`ifndef VID_TIMING_GEN_DRIVER
`define VID_TIMING_GEN_DRIVER

`timescale 1 ps / 1 fs
`include "dut_defines.v"
`include "tb_include/tb_params.vh"

module vid_timing_gen_driver #(
                        parameter PIX_WIDTH = 24,
                        parameter integer NUM_PIX_LANE = 1,
                        parameter num_frames = 2,
                        parameter num_lines = 5,
                        parameter integer pix_per_line = 100,
                        parameter hfront_porch = 100,
                        parameter hsync_pulse = 20,
                        parameter hback_porch = 100,
                        parameter vfront_porch = 5,
                        parameter vsync_pulse = 5,
                        parameter vback_porch = 30,
                        parameter fv_to_lv = 80,
                        parameter lv_to_fv = 80,
                        parameter lv_to_lv = 20,
                        parameter fv_to_fv = 60,
                        parameter wc_delay = 100
                        )
                        (
                        input rst_n_i,
                        input pix_clk_i,
                        input byte_clk_i,
                        output reg fv_i,
                        output reg lv_i,
                        output reg dvalid_i,
                        output reg vsync_i,
                        output reg hsync_i,
                        output reg de_i,
                        output reg [PIX_WIDTH-1:0] pix_data0_i,
                        output reg [PIX_WIDTH-1:0] pix_data1_i,
                        output reg [PIX_WIDTH-1:0] pix_data2_i,
                        output reg [PIX_WIDTH-1:0] pix_data3_i,
                        output reg [PIX_WIDTH-1:0] pix_data4_i,
                        output reg [PIX_WIDTH-1:0] pix_data5_i,
                        output reg [PIX_WIDTH-1:0] pix_data6_i,
                        output reg [PIX_WIDTH-1:0] pix_data7_i,
                        output reg [PIX_WIDTH-1:0] pix_data8_i,
                        output reg [PIX_WIDTH-1:0] pix_data9_i,
                        input byte_log_en,
                        output reg end_of_frame
                        );
    
  integer frame_cnt = 0;
  integer line_cnt = 0;
  integer pixel_cnt = 0;
  
  // For creation of pixels to be sent
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
  reg [7:0] byte12;
  reg [7:0] byte13;
  reg [7:0] byte14;
  reg [7:0] byte15;
  reg [7:0] byte16;
  reg [7:0] byte17;
  reg [7:0] byte18;
  reg [7:0] byte19;
  reg [7:0] byte20;
  reg [7:0] byte21;
  reg [7:0] byte22;
  reg [7:0] byte23;
  reg [7:0] byte24;
          
  reg [PIX_WIDTH-1:0] pix_data_19_buf;
  reg [PIX_WIDTH-1:0] pix_data_18_buf;
  reg [PIX_WIDTH-1:0] pix_data_17_buf;
  reg [PIX_WIDTH-1:0] pix_data_16_buf;
  reg [PIX_WIDTH-1:0] pix_data_15_buf;
  reg [PIX_WIDTH-1:0] pix_data_14_buf;
  reg [PIX_WIDTH-1:0] pix_data_13_buf;
  reg [PIX_WIDTH-1:0] pix_data_12_buf;
  reg [PIX_WIDTH-1:0] pix_data_11_buf;
  reg [PIX_WIDTH-1:0] pix_data_10_buf;
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
  
  initial begin
    fork
      drive_reset();
      `ifdef TX_DSI
        drive_DSI();
      `endif
      `ifdef TX_CSI2
        drive_CSI2();
      `endif
    join
  end
  
  task drive_reset();
    forever begin
      wait (rst_n_i == 0);
      while (rst_n_i == 0) begin
        `ifdef TX_DSI
          vsync_i = 0;
          hsync_i = 0;
          de_i = 0;
        `endif
        `ifdef TX_CSI2
          fv_i = 0;
          lv_i = 0;
          dvalid_i = 0;
        `endif
        pix_data0_i = 0;
        pix_data1_i = 0;
        pix_data2_i = 0;
        pix_data3_i = 0;
        pix_data4_i = 0;
        pix_data5_i = 0;
        pix_data6_i = 0;
        pix_data7_i = 0;
        pix_data8_i = 0;
        pix_data9_i = 0;
        frame_cnt = 0;
        line_cnt = 0;
        pixel_cnt = 0;
        end_of_frame = 0;
        @(posedge pix_clk_i);
      end
    end
  endtask
  
  task drive_fv_lv (input fv, input lv);  
    begin
      fv_i = fv;
      lv_i = lv;
      dvalid_i = 0;
    end
  endtask

  task drive_pixel (
    `ifdef NUM_PIX_LANE_10
      input [PIX_WIDTH-1:0] pix_data9,
      input [PIX_WIDTH-1:0] pix_data8,
      input [PIX_WIDTH-1:0] pix_data7,
      input [PIX_WIDTH-1:0] pix_data6,
      input [PIX_WIDTH-1:0] pix_data5,
      input [PIX_WIDTH-1:0] pix_data4,
      input [PIX_WIDTH-1:0] pix_data3,
      input [PIX_WIDTH-1:0] pix_data2,
      input [PIX_WIDTH-1:0] pix_data1,
      input [PIX_WIDTH-1:0] pix_data0
    `elsif NUM_PIX_LANE_8
      input [PIX_WIDTH-1:0] pix_data7,
      input [PIX_WIDTH-1:0] pix_data6,
      input [PIX_WIDTH-1:0] pix_data5,
      input [PIX_WIDTH-1:0] pix_data4,
      input [PIX_WIDTH-1:0] pix_data3,
      input [PIX_WIDTH-1:0] pix_data2,
      input [PIX_WIDTH-1:0] pix_data1,
      input [PIX_WIDTH-1:0] pix_data0
    `elsif NUM_PIX_LANE_6
      input [PIX_WIDTH-1:0] pix_data5,
      input [PIX_WIDTH-1:0] pix_data4,
      input [PIX_WIDTH-1:0] pix_data3,
      input [PIX_WIDTH-1:0] pix_data2,
      input [PIX_WIDTH-1:0] pix_data1,
      input [PIX_WIDTH-1:0] pix_data0
    `elsif NUM_PIX_LANE_4
      input [PIX_WIDTH-1:0] pix_data3,
      input [PIX_WIDTH-1:0] pix_data2,
      input [PIX_WIDTH-1:0] pix_data1,
      input [PIX_WIDTH-1:0] pix_data0
    `elsif NUM_PIX_LANE_2
      input [PIX_WIDTH-1:0] pix_data1,
      input [PIX_WIDTH-1:0] pix_data0
    `else
      input [PIX_WIDTH-1:0] pix_data0
    `endif
    );
    
    begin
      `ifdef TX_DSI
        de_i = 1;
      `endif
      `ifdef TX_CSI2
        dvalid_i = 1;
        fv_i = 1;
        lv_i = 1;
      `endif
      // add input pixel lanes as needed      
      `ifdef NUM_PIX_LANE_10
        pix_data0_i = pix_data0;
        pix_data1_i = pix_data1;
        pix_data2_i = pix_data2;
        pix_data3_i = pix_data3;
        pix_data4_i = pix_data4;
        pix_data5_i = pix_data5;
        pix_data6_i = pix_data6;
        pix_data7_i = pix_data7;
        pix_data8_i = pix_data8;
        pix_data9_i = pix_data9;
      `elsif NUM_PIX_LANE_8
        pix_data0_i = pix_data0;
        pix_data1_i = pix_data1;
        pix_data2_i = pix_data2;
        pix_data3_i = pix_data3;
        pix_data4_i = pix_data4;
        pix_data5_i = pix_data5;
        pix_data6_i = pix_data6;
        pix_data7_i = pix_data7;
      `elsif NUM_PIX_LANE_6
        pix_data0_i = pix_data0;
        pix_data1_i = pix_data1;
        pix_data2_i = pix_data2;
        pix_data3_i = pix_data3;
        pix_data4_i = pix_data4;
        pix_data5_i = pix_data5;
      `elsif NUM_PIX_LANE_4
        pix_data0_i = pix_data0;
        pix_data1_i = pix_data1;
        pix_data2_i = pix_data2;
        pix_data3_i = pix_data3;
      `elsif NUM_PIX_LANE_2
        pix_data0_i = pix_data0;
        pix_data1_i = pix_data1;
      `else
        pix_data0_i = pix_data0;
      `endif
      @(posedge pix_clk_i);
    end
  endtask
  
  // Generate and drive CSI2 frame
  task drive_CSI2();
    begin
      wait(rst_n_i == 1);
      @(posedge pix_clk_i);
      while (frame_cnt < num_frames) begin
        wait(rst_n_i == 1);
        $display("Starting CSI2 drive task");
        end_of_frame = 0;
        repeat (fv_to_lv) begin
          if (rst_n_i == 1) begin
            drive_fv_lv(1,0); //fv=1, lv=0, dvalid=0            
            @(posedge pix_clk_i);
          end
        end
        if (rst_n_i == 1) begin
          drive_pixel_data_CSI2();
        end
        repeat (lv_to_fv) begin
          if (rst_n_i == 1) begin
            drive_fv_lv(1,0); //fv=1, lv=0, dvalid=0
            @(posedge pix_clk_i);
          end
        end
        if (rst_n_i == 1) begin
          end_of_frame = 1;
          frame_cnt = frame_cnt + 1;
        end
        repeat (fv_to_fv) begin
          if (rst_n_i == 1) begin
            drive_fv_lv(0,0); //fv=0, lv=0, dvalid=0
            @(posedge pix_clk_i);
          end
        end
      end
    end
  endtask

  // Drive CSI2 pixel data
  task drive_pixel_data_CSI2();
    begin
      line_cnt = 0;
      $display("Starting drive_pixel_data...");
    
      repeat (num_lines) begin
        line_cnt  = line_cnt + 1;
        pixel_cnt = 0;
        $display("Sending line #: %d", line_cnt);        
        
        `ifdef RGB888
          drive_rgb888_data();
        `endif
        `ifdef RAW8
          drive_raw8_data();
        `endif
        `ifdef RAW10
          drive_raw10_data();
        `endif
        `ifdef RAW12
          drive_raw12_data();
        `endif
        `ifdef RAW14
          drive_raw14_data();
        `endif
        `ifdef RAW16
          drive_raw16_data();
        `endif
        `ifdef YUV420_8
          drive_yuv420_8_data();
        `endif
        `ifdef YUV420_10
          drive_yuv420_10_data();
        `endif
        `ifdef YUV422_8
          drive_yuv422_8_data();
        `endif
        `ifdef YUV422_10
          drive_yuv422_10_data();
        `endif
        
        if (line_cnt < num_lines) begin
          repeat (lv_to_lv) begin
            if (rst_n_i == 1) begin
              drive_fv_lv(1,0); //fv=1, lv=0, dvalid=0
              @(posedge pix_clk_i);
            end
          end
        end
      end
    end
  endtask
  
  task drive_vsync_hsync (input vsync, input hsync);
    begin
      vsync_i = vsync;
      hsync_i = hsync;
      de_i = 0;
    end
  endtask
  
  // Generate and drive DSI frame
  task drive_DSI();
    begin
      wait(rst_n_i == 1);      
      @(posedge pix_clk_i);
      while (frame_cnt < num_frames) begin
        wait(rst_n_i == 1);
        $display("Starting DSI drive task");  
        drive_vsync_pulse_hsync();
        drive_vbackporch_hsync();
        drive_pixel_data_DSI();
        drive_vfrontporch_hsync();     
        frame_cnt = frame_cnt + 1;
      end
    end
  endtask

  task drive_vsync_pulse_hsync();
    begin
      $display("Starting drive_vsync_pulse_hsync...");
      repeat (vsync_pulse) begin
        repeat (hsync_pulse) begin
          if (rst_n_i == 1) begin
            drive_vsync_hsync(1,1); //vsync = 1'b1, hsync = 1'b1
            @(posedge pix_clk_i);
          end
        end // hsync
        
        repeat (hback_porch+hfront_porch+pix_per_line) begin
          if (rst_n_i == 1) begin
            drive_vsync_hsync(1,0); //vsync = 1'b1,hsync = 1'b0
            @(posedge pix_clk_i);
          end
        end
      end // repeat
      $display("Done with drive_vsync_pulse_hsync...");
    end
  endtask

  task drive_vbackporch_hsync();
    begin
      $display("Starting drive_vbackporch_hsync...");
      repeat (vback_porch) begin
        repeat (hsync_pulse) begin
          if (rst_n_i == 1) begin
            drive_vsync_hsync(0,1); //vsync = 1'b0, hsync = 1'b1
            @(posedge pix_clk_i);
          end
        end

        repeat (hback_porch+hfront_porch+pix_per_line) begin
          if (rst_n_i == 1) begin
            drive_vsync_hsync(0,0); //vsync = 1'b0, hsync = 1'b0
            @(posedge pix_clk_i);
          end
        end
      end   // vback
      $display("Done with drive_vbackporch_hsync...");
    end
  endtask

  task drive_vfrontporch_hsync();
    begin
      $display("Starting drive_vfrontporch_hsync...");
      repeat (vfront_porch) begin
        repeat (hsync_pulse) begin
          if (rst_n_i == 1) begin
            drive_vsync_hsync(0,1); //vsync = 1'b0, hsync = 1'b1
            @(posedge pix_clk_i);
          end
        end
        
        repeat (hback_porch+hfront_porch+pix_per_line) begin
          if (rst_n_i == 1) begin
            drive_vsync_hsync(0,0); //vsync = 1'b0,hsync = 1'b0
            @(posedge pix_clk_i);
          end
        end
      end
      $display("Done with drive_vfrontporch_hsync...");
      end_of_frame = 1;
      #1
      end_of_frame = 0;
    end
  endtask

  // Drive DSI pixel data
  task drive_pixel_data_DSI();
    begin
      $display("Starting drive_pixel_data...");
      
      repeat (num_lines) begin
      
        line_cnt  = line_cnt + 1; 
        pixel_cnt = 0;
        $display("Sending line #: %d",line_cnt);
        repeat (hsync_pulse) begin
          if (rst_n_i == 1) begin
            drive_vsync_hsync(0,1); //vsync = 1'b0, hsync = 1'b1
            @(posedge pix_clk_i);
          end
        end // hsync
            
        repeat (hback_porch) begin
          if (rst_n_i == 1) begin
            drive_vsync_hsync(0,0); //vsync = 1'b0, hsync = 1'b0;
            @(posedge pix_clk_i);
          end
        end
        
        `ifdef RGB888
          drive_rgb888_data();
        `endif
        `ifdef RGB666
          drive_rgb666_data();
        `endif

        repeat (hfront_porch) begin
          if (rst_n_i == 1) begin
            drive_vsync_hsync(0,0); //vsync = 1'b0, hsync = 1'b0
            @(posedge pix_clk_i);
          end
        end
      end
      $display("Done drive_pixel_data...");
      line_cnt = 0;
    end
  endtask

  task drive_rgb888_data();
    begin
      while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
        //1 pixels 3 bytes
        pix_data_0_buf = $random;
        pix_data_1_buf = $random;
        pix_data_2_buf = $random;
        pix_data_3_buf = $random;
        
        byte0 = pix_data_0_buf[7:0];
        byte1 = pix_data_0_buf[15:8];
        byte2 = pix_data_0_buf[23:16];
        byte3 = pix_data_1_buf[7:0];
        byte4 = pix_data_1_buf[15:8];
        byte5 = pix_data_1_buf[23:16];
        byte6 = pix_data_2_buf[7:0];
        byte7 = pix_data_2_buf[15:8];
        byte8 = pix_data_2_buf[23:16];
        byte9 = pix_data_3_buf[7:0];
        byte10 = pix_data_3_buf[15:8];
        byte11 = pix_data_3_buf[23:16];
        
        if (rst_n_i == 1) begin
          `ifdef NUM_PIX_LANE_4
            drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 4;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
            write_to_file("input_data.log", byte5);
            write_to_file("input_data.log", byte6);
            write_to_file("input_data.log", byte7);
            write_to_file("input_data.log", byte8);
            write_to_file("input_data.log", byte9);
            write_to_file("input_data.log", byte10);
            write_to_file("input_data.log", byte11);
          `elsif NUM_PIX_LANE_2
            drive_pixel(pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 2;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
            write_to_file("input_data.log", byte5);
          `elsif NUM_PIX_LANE_1
            drive_pixel(pix_data_0_buf);
            pixel_cnt = pixel_cnt + 1;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
          `endif
        end
      end
    end
  endtask
  
  task drive_rgb666_data;
    begin
      while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
        //4 pixels 9 bytes
        pix_data_0_buf = $random;
        pix_data_1_buf = $random;
        pix_data_2_buf = $random;
        pix_data_3_buf = $random;
        
        byte0 = pix_data_0_buf[7:0];
        byte1 = pix_data_0_buf[15:8];
        byte2 = {pix_data_1_buf[5:0], pix_data_0_buf[17:16]};
        byte3 = pix_data_1_buf[13:6];
        byte4 = {pix_data_2_buf[3:0], pix_data_1_buf[17:14]};
        byte5 = pix_data_2_buf[11:4];
        byte6 = {pix_data_3_buf[1:0], pix_data_2_buf[17:12]};
        byte7 = pix_data_3_buf[9:2];
        byte8 = pix_data_3_buf[17:10];

        
        if (rst_n_i == 1) begin
          `ifdef NUM_PIX_LANE_4
            drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 4;
          `elsif NUM_PIX_LANE_2
            drive_pixel(pix_data_1_buf, pix_data_0_buf);
            drive_pixel(pix_data_3_buf, pix_data_2_buf);
            pixel_cnt = pixel_cnt + 4;
          `elsif NUM_PIX_LANE_1
            drive_pixel(pix_data_0_buf);
            drive_pixel(pix_data_1_buf);
            drive_pixel(pix_data_2_buf);
            drive_pixel(pix_data_3_buf);
            pixel_cnt = pixel_cnt + 4;
          `endif
          write_to_file("input_data.log", byte0);		
          write_to_file("input_data.log", byte1);      
          write_to_file("input_data.log", byte2);
          write_to_file("input_data.log", byte3);      
          write_to_file("input_data.log", byte4); 
          write_to_file("input_data.log", byte5);      
          write_to_file("input_data.log", byte6); 
          write_to_file("input_data.log", byte7);      
          write_to_file("input_data.log", byte8);
        end
      end
    end
  endtask
  
  task drive_raw8_data;
    begin
      while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
        //1 pixel 1 byte
        pix_data_0_buf = $random;
        pix_data_1_buf = $random;
        pix_data_2_buf = $random;
        pix_data_3_buf = $random;
        
        byte0 = pix_data_0_buf;
        byte1 = pix_data_1_buf;
        byte2 = pix_data_2_buf;
        byte3 = pix_data_3_buf;

        if (rst_n_i == 1) begin
          `ifdef NUM_PIX_LANE_4
            drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 4;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
          `elsif NUM_PIX_LANE_2
            drive_pixel(pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 2;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
          `elsif NUM_PIX_LANE_1
            drive_pixel(pix_data_0_buf);
            pixel_cnt = pixel_cnt + 1;
            write_to_file("input_data.log", byte0);
          `endif
        end
      end
    end
  endtask
  
  task drive_raw10_data;
    begin
      `ifdef NUM_PIX_LANE_10
        //4 pixels 5 bytes
        while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
          pix_data_0_buf = $random;
          pix_data_1_buf = $random;
          pix_data_2_buf = $random;
          pix_data_3_buf = $random;
          pix_data_4_buf = $random;
          pix_data_5_buf = $random;
          pix_data_6_buf = $random;
          pix_data_7_buf = $random;
          pix_data_8_buf = $random;
          pix_data_9_buf = $random;
          pix_data_10_buf = $random;
          pix_data_11_buf = $random;
          pix_data_12_buf = $random;
          pix_data_13_buf = $random;
          pix_data_14_buf = $random;
          pix_data_15_buf = $random;
          pix_data_16_buf = $random;
          pix_data_17_buf = $random;
          pix_data_18_buf = $random;
          pix_data_19_buf = $random;
          
          byte0 = pix_data_0_buf[9:2];
          byte1 = pix_data_1_buf[9:2];
          byte2 = pix_data_2_buf[9:2];
          byte3 = pix_data_3_buf[9:2];
          byte4 = {pix_data_3_buf[1:0], pix_data_2_buf[1:0], pix_data_1_buf[1:0], pix_data_0_buf[1:0]};
          byte5 = pix_data_4_buf[9:2];
          byte6 = pix_data_5_buf[9:2];
          byte7 = pix_data_6_buf[9:2];
          byte8 = pix_data_7_buf[9:2];
          byte9 = {pix_data_7_buf[1:0], pix_data_6_buf[1:0], pix_data_5_buf[1:0], pix_data_4_buf[1:0]};
          byte10 = pix_data_8_buf[9:2];
          byte11 = pix_data_9_buf[9:2];
          byte12 = pix_data_10_buf[9:2];
          byte13 = pix_data_11_buf[9:2];
          byte14 = {pix_data_11_buf[1:0], pix_data_10_buf[1:0], pix_data_9_buf[1:0], pix_data_8_buf[1:0]};
          byte15 = pix_data_12_buf[9:2];
          byte16 = pix_data_13_buf[9:2];
          byte17 = pix_data_14_buf[9:2];
          byte18 = pix_data_15_buf[9:2];
          byte19 = {pix_data_15_buf[1:0], pix_data_14_buf[1:0], pix_data_13_buf[1:0], pix_data_12_buf[1:0]};
          byte20 = pix_data_16_buf[9:2];
          byte21 = pix_data_17_buf[9:2];
          byte22 = pix_data_18_buf[9:2];
          byte23 = pix_data_19_buf[9:2];
          byte24 = {pix_data_19_buf[1:0], pix_data_18_buf[1:0], pix_data_17_buf[1:0], pix_data_16_buf[1:0]};
          
          if (rst_n_i == 1) begin
            drive_pixel(pix_data_9_buf, pix_data_8_buf, pix_data_7_buf, pix_data_6_buf, pix_data_5_buf, pix_data_4_buf, pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            drive_pixel(pix_data_19_buf, pix_data_18_buf, pix_data_17_buf, pix_data_16_buf, pix_data_15_buf, pix_data_14_buf, pix_data_13_buf, pix_data_12_buf, pix_data_11_buf, pix_data_10_buf);
            pixel_cnt = pixel_cnt + 20;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
            write_to_file("input_data.log", byte5);
            write_to_file("input_data.log", byte6);
            write_to_file("input_data.log", byte7);
            write_to_file("input_data.log", byte8);
            write_to_file("input_data.log", byte9);
            write_to_file("input_data.log", byte10);
            write_to_file("input_data.log", byte11);
            write_to_file("input_data.log", byte12);
            write_to_file("input_data.log", byte13);
            write_to_file("input_data.log", byte14);
            write_to_file("input_data.log", byte15);
            write_to_file("input_data.log", byte16);
            write_to_file("input_data.log", byte17);
            write_to_file("input_data.log", byte18);
            write_to_file("input_data.log", byte19);
            write_to_file("input_data.log", byte20);
            write_to_file("input_data.log", byte21);
            write_to_file("input_data.log", byte22);
            write_to_file("input_data.log", byte23);
            write_to_file("input_data.log", byte24);
          end
        end
      `elsif NUM_PIX_LANE_8
        while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
          //4 pixels 5 bytes
          pix_data_0_buf = $random;
          pix_data_1_buf = $random;
          pix_data_2_buf = $random;
          pix_data_3_buf = $random;
          pix_data_4_buf = $random;
          pix_data_5_buf = $random;
          pix_data_6_buf = $random;
          pix_data_7_buf = $random;
          
          byte0 = pix_data_0_buf[9:2];
          byte1 = pix_data_1_buf[9:2];
          byte2 = pix_data_2_buf[9:2];
          byte3 = pix_data_3_buf[9:2];
          byte4 = {pix_data_3_buf[1:0], pix_data_2_buf[1:0], pix_data_1_buf[1:0], pix_data_0_buf[1:0]};
          byte5 = pix_data_4_buf[9:2];
          byte6 = pix_data_5_buf[9:2];
          byte7 = pix_data_6_buf[9:2];
          byte8 = pix_data_7_buf[9:2];
          byte9 = {pix_data_7_buf[1:0], pix_data_6_buf[1:0], pix_data_5_buf[1:0], pix_data_4_buf[1:0]};
          
          if (rst_n_i == 1) begin
            drive_pixel(pix_data_7_buf, pix_data_6_buf, pix_data_5_buf, pix_data_4_buf, pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 8;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
            write_to_file("input_data.log", byte5);
            write_to_file("input_data.log", byte6);
            write_to_file("input_data.log", byte7);
            write_to_file("input_data.log", byte8);
            write_to_file("input_data.log", byte9);
          end
        end
      `elsif NUM_PIX_LANE_6
        while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
          //4 pixels 5 bytes
          pix_data_0_buf = $random;
          pix_data_1_buf = $random;
          pix_data_2_buf = $random;
          pix_data_3_buf = $random;
          pix_data_4_buf = $random;
          pix_data_5_buf = $random;
          pix_data_6_buf = $random;
          pix_data_7_buf = $random;
          pix_data_8_buf = $random;
          pix_data_9_buf = $random;
          pix_data_10_buf = $random;
          pix_data_11_buf = $random;
          
          byte0 = pix_data_0_buf[9:2];
          byte1 = pix_data_1_buf[9:2];
          byte2 = pix_data_2_buf[9:2];
          byte3 = pix_data_3_buf[9:2];
          byte4 = {pix_data_3_buf[1:0], pix_data_2_buf[1:0], pix_data_1_buf[1:0], pix_data_0_buf[1:0]};
          byte5 = pix_data_4_buf[9:2];
          byte6 = pix_data_5_buf[9:2];
          byte7 = pix_data_6_buf[9:2];
          byte8 = pix_data_7_buf[9:2];
          byte9 = {pix_data_7_buf[1:0], pix_data_6_buf[1:0], pix_data_5_buf[1:0], pix_data_4_buf[1:0]};
          byte10 = pix_data_8_buf[9:2];
          byte11 = pix_data_9_buf[9:2];
          byte12 = pix_data_10_buf[9:2];
          byte13 = pix_data_11_buf[9:2];
          byte14 = {pix_data_11_buf[1:0], pix_data_10_buf[1:0], pix_data_9_buf[1:0], pix_data_8_buf[1:0]};
          
          if (rst_n_i == 1) begin
            drive_pixel(pix_data_5_buf, pix_data_4_buf, pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            drive_pixel(pix_data_11_buf, pix_data_10_buf, pix_data_9_buf, pix_data_8_buf, pix_data_7_buf, pix_data_6_buf);
            pixel_cnt = pixel_cnt + 12;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
            write_to_file("input_data.log", byte5);
            write_to_file("input_data.log", byte6);
            write_to_file("input_data.log", byte7);
            write_to_file("input_data.log", byte8);
            write_to_file("input_data.log", byte9);
            write_to_file("input_data.log", byte10);
            write_to_file("input_data.log", byte11);
            write_to_file("input_data.log", byte12);
            write_to_file("input_data.log", byte13);
            write_to_file("input_data.log", byte14);
          end
        end
      `elsif NUM_PIX_LANE_4
        while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
          //4 pixels 5 bytes
          pix_data_0_buf = $random;
          pix_data_1_buf = $random;
          pix_data_2_buf = $random;
          pix_data_3_buf = $random;
          
          byte0 = pix_data_0_buf[9:2];
          byte1 = pix_data_1_buf[9:2];
          byte2 = pix_data_2_buf[9:2];
          byte3 = pix_data_3_buf[9:2];
          byte4 = {pix_data_3_buf[1:0], pix_data_2_buf[1:0], pix_data_1_buf[1:0], pix_data_0_buf[1:0]};
          
          if (rst_n_i == 1) begin
            drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 4;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
          end
        end
      `elsif NUM_PIX_LANE_2
        while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
          //4 pixels 5 bytes
          pix_data_0_buf = $random;
          pix_data_1_buf = $random;
          pix_data_2_buf = $random;
          pix_data_3_buf = $random;
          
          byte0 = pix_data_0_buf[9:2];
          byte1 = pix_data_1_buf[9:2];
          byte2 = pix_data_2_buf[9:2];
          byte3 = pix_data_3_buf[9:2];
          byte4 = {pix_data_3_buf[1:0], pix_data_2_buf[1:0], pix_data_1_buf[1:0], pix_data_0_buf[1:0]};
          
          if (rst_n_i == 1) begin
            drive_pixel(pix_data_1_buf, pix_data_0_buf);
            drive_pixel(pix_data_3_buf, pix_data_2_buf);
            pixel_cnt = pixel_cnt + 4;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
          end
        end
      `elsif NUM_PIX_LANE_1
        while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
          //4 pixels 5 bytes
          pix_data_0_buf = $random;
          pix_data_1_buf = $random;
          pix_data_2_buf = $random;
          pix_data_3_buf = $random;
          
          byte0 = pix_data_0_buf[9:2];
          byte1 = pix_data_1_buf[9:2];
          byte2 = pix_data_2_buf[9:2];
          byte3 = pix_data_3_buf[9:2];
          byte4 = {pix_data_3_buf[1:0], pix_data_2_buf[1:0], pix_data_1_buf[1:0], pix_data_0_buf[1:0]};
          
          if (rst_n_i == 1) begin
            drive_pixel(pix_data_0_buf);
            drive_pixel(pix_data_1_buf);
            drive_pixel(pix_data_2_buf);
            drive_pixel(pix_data_3_buf);
            pixel_cnt = pixel_cnt + 4;          
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
          end
        end
      `endif
    end
  endtask
  
  task drive_raw12_data;
    begin
      while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
        //2 pixels 3 bytes
        pix_data_0_buf = $random;
        pix_data_1_buf = $random;
        pix_data_2_buf = $random;
        pix_data_3_buf = $random;
        pix_data_4_buf = $random;
        pix_data_5_buf = $random;
        pix_data_6_buf = $random;
        pix_data_7_buf = $random;
        pix_data_8_buf = $random;
        pix_data_9_buf = $random;
        
        byte0 = pix_data_0_buf[11:4];
        byte1 = pix_data_1_buf[11:4];
        byte2 = {pix_data_1_buf[3:0], pix_data_0_buf[3:0]};
        byte3 = pix_data_2_buf[11:4];
        byte4 = pix_data_3_buf[11:4];
        byte5 = {pix_data_3_buf[3:0], pix_data_2_buf[3:0]};
        byte6 = pix_data_4_buf[11:4];
        byte7 = pix_data_5_buf[11:4];
        byte8 = {pix_data_5_buf[3:0], pix_data_4_buf[3:0]};
        byte9 = pix_data_6_buf[11:4];
        byte10 = pix_data_7_buf[11:4];
        byte11 = {pix_data_7_buf[3:0], pix_data_6_buf[3:0]};
        byte12 = pix_data_8_buf[11:4];
        byte13 = pix_data_9_buf[11:4];
        byte14 = {pix_data_9_buf[3:0], pix_data_8_buf[3:0]};
        
        if (rst_n_i == 1) begin
          `ifdef NUM_PIX_LANE_10
            drive_pixel(pix_data_9_buf, pix_data_8_buf, pix_data_7_buf, pix_data_6_buf, pix_data_5_buf, pix_data_4_buf, pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 10;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
            write_to_file("input_data.log", byte5);
            write_to_file("input_data.log", byte6);
            write_to_file("input_data.log", byte7);
            write_to_file("input_data.log", byte8);
            write_to_file("input_data.log", byte9);
            write_to_file("input_data.log", byte10);
            write_to_file("input_data.log", byte11);
            write_to_file("input_data.log", byte12);
            write_to_file("input_data.log", byte13);
            write_to_file("input_data.log", byte14);
          `elsif NUM_PIX_LANE_8
            drive_pixel(pix_data_7_buf, pix_data_6_buf, pix_data_5_buf, pix_data_4_buf, pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 8;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
            write_to_file("input_data.log", byte5);
            write_to_file("input_data.log", byte6);
            write_to_file("input_data.log", byte7);
            write_to_file("input_data.log", byte8);
            write_to_file("input_data.log", byte9);
            write_to_file("input_data.log", byte10);
            write_to_file("input_data.log", byte11);
          `elsif NUM_PIX_LANE_6
            drive_pixel(pix_data_5_buf, pix_data_4_buf, pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 6;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
            write_to_file("input_data.log", byte5);
            write_to_file("input_data.log", byte6);
            write_to_file("input_data.log", byte7);
            write_to_file("input_data.log", byte8);
          `elsif NUM_PIX_LANE_4
            drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 4;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
            write_to_file("input_data.log", byte5);
          `elsif NUM_PIX_LANE_2
            drive_pixel(pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 2;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
          `elsif NUM_PIX_LANE_1
            drive_pixel(pix_data_0_buf);
            drive_pixel(pix_data_1_buf);
            pixel_cnt = pixel_cnt + 2;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
          `endif
        end
      end
    end
  endtask
  
  task drive_raw14_data;
    begin
      while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
        //4 pixels 7 bytes
        pix_data_0_buf = $random;
        pix_data_1_buf = $random;
        pix_data_2_buf = $random;
        pix_data_3_buf = $random;
        
        byte0 = pix_data_0_buf[13:6];
        byte1 = pix_data_1_buf[13:6];
        byte2 = pix_data_2_buf[13:6];
        byte3 = pix_data_3_buf[13:6];
        byte4 = {pix_data_1_buf[1:0], pix_data_0_buf[5:0]};
        byte5 = {pix_data_2_buf[3:0], pix_data_1_buf[5:2]};
        byte6 = {pix_data_3_buf[5:0], pix_data_2_buf[5:4]};
        
        if (rst_n_i == 1) begin
          `ifdef NUM_PIX_LANE_4
            drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 4;
          `elsif NUM_PIX_LANE_2
            drive_pixel(pix_data_1_buf, pix_data_0_buf);
            drive_pixel(pix_data_3_buf, pix_data_2_buf);
            pixel_cnt = pixel_cnt + 4;
          `elsif NUM_PIX_LANE_1
            drive_pixel(pix_data_0_buf);
            drive_pixel(pix_data_1_buf);
            drive_pixel(pix_data_2_buf);
            drive_pixel(pix_data_3_buf);
            pixel_cnt = pixel_cnt + 4;
          `endif
          write_to_file("input_data.log", byte0);
          write_to_file("input_data.log", byte1);
          write_to_file("input_data.log", byte2);
          write_to_file("input_data.log", byte3);
          write_to_file("input_data.log", byte4);
          write_to_file("input_data.log", byte5);
          write_to_file("input_data.log", byte6);
        end
      end
    end
  endtask
  
  task drive_raw16_data;
    begin
      while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
        //1 pixel 2 bytes
        pix_data_0_buf = $random;
        pix_data_1_buf = $random;
        pix_data_2_buf = $random;
        pix_data_3_buf = $random;
        
        byte0 = pix_data_0_buf[15:8];
        byte1 = pix_data_0_buf[7:0];
        byte2 = pix_data_1_buf[15:8];
        byte3 = pix_data_1_buf[7:0];
        byte4 = pix_data_2_buf[15:8];
        byte5 = pix_data_2_buf[7:0];
        byte6 = pix_data_3_buf[15:8];
        byte7 = pix_data_3_buf[7:0];

        if (rst_n_i == 1) begin
          `ifdef NUM_PIX_LANE_4
            drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 4;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
            write_to_file("input_data.log", byte5);
            write_to_file("input_data.log", byte6);
            write_to_file("input_data.log", byte7);
          `elsif NUM_PIX_LANE_2
            drive_pixel(pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 2;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
          `elsif NUM_PIX_LANE_1
            drive_pixel(pix_data_0_buf);
            pixel_cnt = pixel_cnt + 1;
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
          `endif
        end
      end
    end
  endtask
  
  task drive_yuv422_8_data;
    begin
      while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
        //8 bits per "pixel"
        pix_data_0_buf = $random; //U
        pix_data_1_buf = $random; //Y1
        pix_data_2_buf = $random; //V
        pix_data_3_buf = $random; //Y2
        
        byte0 = pix_data_0_buf;
        byte1 = pix_data_1_buf;
        byte2 = pix_data_2_buf;
        byte3 = pix_data_3_buf;

        if (rst_n_i == 1) begin
          `ifdef NUM_PIX_LANE_4
            drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 4;
          `elsif NUM_PIX_LANE_2
            drive_pixel(pix_data_1_buf, pix_data_0_buf);
            drive_pixel(pix_data_3_buf, pix_data_2_buf);
            pixel_cnt = pixel_cnt + 4;
          `elsif NUM_PIX_LANE_1
            drive_pixel(pix_data_0_buf);
            drive_pixel(pix_data_1_buf);
            drive_pixel(pix_data_2_buf);
            drive_pixel(pix_data_3_buf);
            pixel_cnt = pixel_cnt + 4;
          `endif
          write_to_file("input_data.log", byte0);
          write_to_file("input_data.log", byte1);
          write_to_file("input_data.log", byte2);
          write_to_file("input_data.log", byte3);
        end
      end
    end
  endtask
  
  task drive_yuv422_10_data;
    begin
      while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
        //4 pixels 5 bytes
        pix_data_0_buf = $random;
        pix_data_1_buf = $random;
        pix_data_2_buf = $random;
        pix_data_3_buf = $random;
        
        byte0 = pix_data_0_buf[9:2];
        byte1 = pix_data_1_buf[9:2];
        byte2 = pix_data_2_buf[9:2];
        byte3 = pix_data_3_buf[9:2];
        byte4 = {pix_data_3_buf[1:0], pix_data_2_buf[1:0], pix_data_1_buf[1:0], pix_data_0_buf[1:0]};
        
        if (rst_n_i == 1) begin
          `ifdef NUM_PIX_LANE_4
            drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            pixel_cnt = pixel_cnt + 4;
          `elsif NUM_PIX_LANE_2
            drive_pixel(pix_data_1_buf, pix_data_0_buf);
            drive_pixel(pix_data_3_buf, pix_data_2_buf);
            pixel_cnt = pixel_cnt + 4;
          `elsif NUM_PIX_LANE_1
            drive_pixel(pix_data_0_buf);
            drive_pixel(pix_data_1_buf);
            drive_pixel(pix_data_2_buf);
            drive_pixel(pix_data_3_buf);
            pixel_cnt = pixel_cnt + 4;
          `endif
          write_to_file("input_data.log", byte0);
          write_to_file("input_data.log", byte1);
          write_to_file("input_data.log", byte2);
          write_to_file("input_data.log", byte3);
          write_to_file("input_data.log", byte4);
        end
      end
    end
  endtask

  task drive_yuv420_8_data;
    begin
      if (line_cnt % 2 == 0) begin //even line 
        while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
          //8 bits per "pixel"
          pix_data_0_buf = $random; //U(even)
          pix_data_1_buf = $random; //Y1(even)
          pix_data_2_buf = $random; //V(even)
          pix_data_3_buf = $random; //Y2(even)
          
          byte0 = pix_data_0_buf;
          byte1 = pix_data_1_buf;
          byte2 = pix_data_2_buf;
          byte3 = pix_data_3_buf;
          
          if (rst_n_i == 1) begin
            `ifdef NUM_PIX_LANE_4
              drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
              pixel_cnt = pixel_cnt + 4;
            `elsif NUM_PIX_LANE_2
              drive_pixel(pix_data_1_buf, pix_data_0_buf);
              drive_pixel(pix_data_3_buf, pix_data_2_buf);
              pixel_cnt = pixel_cnt + 4;
            `elsif NUM_PIX_LANE_1
              drive_pixel(pix_data_0_buf);
              drive_pixel(pix_data_1_buf);
              drive_pixel(pix_data_2_buf);
              drive_pixel(pix_data_3_buf);
              pixel_cnt = pixel_cnt + 4;
            `endif
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
          end
        end
      end
      else begin //odd line
        while ((pixel_cnt < pix_per_line/2) && (rst_n_i != 0)) begin
          //8 bits per "pixel"
          pix_data_0_buf = $random; //Y1(odd)
          pix_data_1_buf = $random; //Y2(odd)
          pix_data_2_buf = $random; //Y1(odd)
          pix_data_3_buf = $random; //Y2(odd)
          
          byte0 = pix_data_0_buf;
          byte1 = pix_data_1_buf;
          byte2 = pix_data_2_buf;
          byte3 = pix_data_3_buf;
          
          if (rst_n_i == 1) begin
            `ifdef NUM_PIX_LANE_4
              drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
              pixel_cnt = pixel_cnt + 4;
              write_to_file("input_data.log", byte0);
              write_to_file("input_data.log", byte1);
              write_to_file("input_data.log", byte2);
              write_to_file("input_data.log", byte3);
            `elsif NUM_PIX_LANE_2
              drive_pixel(pix_data_1_buf, pix_data_0_buf);
              pixel_cnt = pixel_cnt + 2;
              write_to_file("input_data.log", byte0);
              write_to_file("input_data.log", byte1);
            `elsif NUM_PIX_LANE_1
              drive_pixel(pix_data_0_buf);              
              drive_pixel(pix_data_1_buf);
              pixel_cnt = pixel_cnt + 2;
              write_to_file("input_data.log", byte0);
              write_to_file("input_data.log", byte1);
            `endif
          end
        end
      end
    end
  endtask
  
  task drive_yuv420_10_data;
    begin
      if (line_cnt % 2 == 0) begin //even line
        while ((pixel_cnt < pix_per_line) && (rst_n_i != 0)) begin
          //10 bits per "pixel"
          pix_data_0_buf = $random; //U(even)
          pix_data_1_buf = $random; //Y1(even)
          pix_data_2_buf = $random; //V(even)
          pix_data_3_buf = $random; //Y2(even)
          
          byte0 = pix_data_0_buf[9:2];
          byte1 = pix_data_1_buf[9:2];
          byte2 = pix_data_2_buf[9:2];
          byte3 = pix_data_3_buf[9:2];
          byte4 = {pix_data_3_buf[1:0], pix_data_2_buf[1:0], pix_data_1_buf[1:0], pix_data_0_buf[1:0]};

          if (rst_n_i == 1) begin
            `ifdef NUM_PIX_LANE_4
              drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
              pixel_cnt = pixel_cnt + 4;
            `elsif NUM_PIX_LANE_2
              drive_pixel(pix_data_1_buf, pix_data_0_buf);
              drive_pixel(pix_data_3_buf, pix_data_2_buf);
              pixel_cnt = pixel_cnt + 4;
            `elsif NUM_PIX_LANE_1
              drive_pixel(pix_data_0_buf);
              drive_pixel(pix_data_1_buf);
              drive_pixel(pix_data_2_buf);
              drive_pixel(pix_data_3_buf);
              pixel_cnt = pixel_cnt + 4;
            `endif
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
          end
        end
      end
      else begin //odd line
        while ((pixel_cnt < (pix_per_line/2)) && (rst_n_i != 0)) begin
          //10 bits per "pixel"
          pix_data_0_buf = $random; //Y1(odd)
          pix_data_1_buf = $random; //Y2(odd)
          pix_data_2_buf = $random; //Y1(odd)
          pix_data_3_buf = $random; //Y2(odd)
          
          byte0 = pix_data_0_buf[9:2];
          byte1 = pix_data_1_buf[9:2];
          byte2 = pix_data_2_buf[9:2];
          byte3 = pix_data_3_buf[9:2];
          byte4 = {pix_data_3_buf[1:0], pix_data_2_buf[1:0], pix_data_1_buf[1:0], pix_data_0_buf[1:0]};
          
          if (rst_n_i == 1) begin
            `ifdef NUM_PIX_LANE_4
              drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
              pixel_cnt = pixel_cnt + 4;
            `elsif NUM_PIX_LANE_2
              drive_pixel(pix_data_1_buf, pix_data_0_buf);
              drive_pixel(pix_data_3_buf, pix_data_2_buf);
              pixel_cnt = pixel_cnt + 4;
            `elsif NUM_PIX_LANE_1
              drive_pixel(pix_data_0_buf);
              drive_pixel(pix_data_1_buf);
              drive_pixel(pix_data_2_buf);
              drive_pixel(pix_data_3_buf);
              pixel_cnt = pixel_cnt + 4;
            `endif
            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
          end
        end
      end
    end
  endtask

  task write_to_file (input [1024*8-1:0] str_in, input [7:0] data);
    integer filedesc;
    if(byte_log_en == 1) begin
      begin
        filedesc = $fopen(str_in,"a");
        $fwrite(filedesc, "%h\n", data);
        $fclose(filedesc);
      end
    end
  endtask
endmodule
`endif