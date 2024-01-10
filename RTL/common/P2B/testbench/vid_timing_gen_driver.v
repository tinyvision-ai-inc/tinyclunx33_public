// =========================================================================
// Filename: vid_timing_gen_driver.v
// Copyright(c) 2017 Lattice Semiconductor Corporation. All rights reserved.
// =========================================================================
`ifndef VID_TIMING_GEN_DRIVER
`define VID_TIMING_GEN_DRIVER

`include "dut_defines.v"   

module vid_timing_gen_driver (
                        clk,
                        reset,

                        vid_cntl_tgen_active,                  // active high - indicate vid is st_active
                        byte_log_en,

                        `ifdef TX_DSI
                        tgen_vid_hsync,
                        tgen_vid_vsync,
                        tgen_vid_de,
                        `endif
                        `ifdef TX_CSI2
                        tgen_vid_fv,
                        tgen_vid_lv,
                        `endif
                        tgen_vid_data0,
                        tgen_vid_data1,
                        tgen_vid_data2,
                        tgen_vid_data3,
                        tgen_vid_data4,
                        tgen_vid_data5,
                        tgen_vid_data6,
                        tgen_vid_data7,
                        tgen_vid_data8,
                        tgen_vid_data9,
                        tgen_end_of_line,
                        tgen_end_of_frame
                  );
// **************************************************************
parameter WORD_WIDTH                   =  24;
input           clk,
                reset;

input           vid_cntl_tgen_active;
input           byte_log_en;

output [WORD_WIDTH-1:0]   tgen_vid_data0,
                         tgen_vid_data1,
                         tgen_vid_data2,
                         tgen_vid_data3,
                         tgen_vid_data4,
                         tgen_vid_data5,
                         tgen_vid_data6,
                         tgen_vid_data7,
                         tgen_vid_data8,
                         tgen_vid_data9;

`ifdef TX_DSI
output          tgen_vid_hsync,
                tgen_vid_vsync,
                tgen_vid_de;
`endif
`ifdef TX_CSI2
output          tgen_vid_fv,
                tgen_vid_lv;
`endif
output          tgen_end_of_line,
                tgen_end_of_frame;
// *************************************************************
reg [WORD_WIDTH-1:0]      tgen_vid_data0,
                         tgen_vid_data1,
                         tgen_vid_data2,
                         tgen_vid_data3,
                         tgen_vid_data4,
                         tgen_vid_data5,
                         tgen_vid_data6,
                         tgen_vid_data7,
                         tgen_vid_data8,
                         tgen_vid_data9;
wire            tgen_vid_hsync,
                tgen_vid_vsync,
                tgen_vid_de,
                tgen_vid_lv;
reg             tgen_vid_fv;
reg             fv_cnt;

wire            end_of_line,
                end_of_frame;

wire            vid_cntl_tgen_start_of_frame = 'b0;            
reg[11:0]       next_h_value,
                h_counter;
wire [11:0]     h_reload_count,
                hsync_high_to_low_count,
                hde_start,
                hde_end,
                hsync_low_to_high_count;
                
reg[10:0]       next_v_value,
                v_counter;
wire[10:0]      v_reload_count,
                vsync_high_to_low_count,
                vde_start,
                vde_end,
                vsync_low_to_high_count;

wire            h_match,
                v_match;

reg[2:0]        h_state,
                v_state;

// ******************************************************************
//  Drive data variables
// *******************************************************************
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
            
   reg [WORD_WIDTH-1:0] pix_data_19_buf;
   reg [WORD_WIDTH-1:0] pix_data_18_buf;
   reg [WORD_WIDTH-1:0] pix_data_17_buf;
   reg [WORD_WIDTH-1:0] pix_data_16_buf;
   reg [WORD_WIDTH-1:0] pix_data_15_buf;
   reg [WORD_WIDTH-1:0] pix_data_14_buf;
   reg [WORD_WIDTH-1:0] pix_data_13_buf;
   reg [WORD_WIDTH-1:0] pix_data_12_buf;
   reg [WORD_WIDTH-1:0] pix_data_11_buf;
   reg [WORD_WIDTH-1:0] pix_data_10_buf;

   reg [WORD_WIDTH-1:0] pix_data_9_buf;
   reg [WORD_WIDTH-1:0] pix_data_8_buf;
   reg [WORD_WIDTH-1:0] pix_data_7_buf;
   reg [WORD_WIDTH-1:0] pix_data_6_buf;
   reg [WORD_WIDTH-1:0] pix_data_5_buf;
   reg [WORD_WIDTH-1:0] pix_data_4_buf;
   reg [WORD_WIDTH-1:0] pix_data_3_buf;
   reg [WORD_WIDTH-1:0] pix_data_2_buf;
   reg [WORD_WIDTH-1:0] pix_data_1_buf;
   reg [WORD_WIDTH-1:0] pix_data_0_buf;

// ***************************************************************

parameter test_hsync_front_porch       =  7'd2;
parameter test_hsync_width             =  12'd10;
parameter test_hsync_back_porch        =  12'd04;
parameter test_h_width                 =  12'd64;
//parameter test_h_total                 =  12'd80;
parameter test_h_total                 =  test_hsync_front_porch + test_hsync_width + test_hsync_back_porch + test_h_width;

parameter test_v_height                =  11'd48;
parameter test_vsync_front_porch       =  11'd2;
parameter test_vsync_width             =  3'd2;
parameter test_vsync_back_porch        =  11'd3;
//parameter test_v_total                 =  11'd55;
parameter test_v_total                 =  test_v_height + test_vsync_front_porch + test_vsync_width + test_vsync_back_porch;



parameter hsync_high_state             =  3'b1_0_0; 
parameter hsync_back_porch             =  3'b0_0_0;
parameter h_de                         =  3'b0_1_0;
parameter hsync_front_porch            =  3'b0_0_1;
                                       
parameter vsync_high_state             =  3'b1_0_0; 
parameter vsync_back_porch             =  3'b0_0_0;
parameter v_de                         =  3'b0_1_0;
parameter vsync_front_porch            =  3'b0_0_1;

// ******************************************************************
// [20200805] Enhancement: Added for SYNC checker
//assign tgen_vid_hsync = h_state[2] ;
//assign tgen_vid_vsync =  v_state[2] ;
assign tgen_vid_hsync =  (reset) ? 0 : h_state[2] ;
assign tgen_vid_vsync =  (reset) ? 0 : v_state[2] ;
assign tgen_vid_de = h_state[1] & v_state[1] ;
assign tgen_vid_lv = h_state[1] & v_state[1] ;
always @(tgen_vid_vsync or v_match or reset) begin
   if(reset) begin
      tgen_vid_fv = 1'b0;
      fv_cnt = 0;
   end
   else if(~fv_cnt & v_match) begin
      tgen_vid_fv = 1'b1;
      fv_cnt = fv_cnt+1;
   end
   else if(fv_cnt & tgen_vid_vsync)
      tgen_vid_fv = 1'b0;
   else if(fv_cnt & ~tgen_vid_vsync)
      tgen_vid_fv = 1'b1;
end

// time multiplexed comparator, atleast 1 period wide durations are a must
assign h_match = (h_counter == next_h_value); 
assign v_match = (v_counter == next_v_value); 

//++++++++++++++++++ generate 1 clock wide pulses+++++++++++++++++
assign end_of_line = h_match & (h_state == hsync_front_porch); 
assign end_of_frame = v_match & end_of_line & (v_state == vsync_high_state);
assign tgen_end_of_frame = end_of_frame;
assign tgen_end_of_line = end_of_line;

// mux to generate next_h_value
always @ ( h_state or hsync_high_to_low_count or hde_start or hde_end or hsync_low_to_high_count)
begin
case (h_state)
        hsync_high_state: next_h_value = hsync_high_to_low_count;
        hsync_back_porch: next_h_value = hde_start;
        h_de: next_h_value = hde_end;
        hsync_front_porch: next_h_value = hsync_low_to_high_count;
        default: next_h_value = hsync_high_to_low_count; 
endcase
end

// mux to generate next_v_value
always @ ( v_state or vsync_high_to_low_count or vde_start or vde_end or vsync_low_to_high_count )
begin
case (v_state)
        vsync_back_porch : next_v_value = vde_start;
        v_de :             next_v_value = vde_end;
        vsync_front_porch: next_v_value = vsync_low_to_high_count;
        vsync_high_state : next_v_value = vsync_high_to_low_count;
        default:            next_v_value = vsync_high_to_low_count;
endcase
end


assign           h_reload_count = test_h_total-1'b1; 
assign           v_reload_count = test_v_total-1'b1; 

assign           hsync_high_to_low_count = test_h_total - test_hsync_width ;
assign           hde_start = test_h_total - (test_hsync_back_porch+test_hsync_width) ;
assign           hde_end = test_h_total - (test_hsync_width+test_hsync_back_porch+test_h_width);
assign           hsync_low_to_high_count = 12'h000 ;

assign           vde_start = (test_v_total - test_vsync_back_porch);
assign           vde_end = test_v_total - (test_vsync_back_porch + test_v_height);
assign           vsync_low_to_high_count = test_v_total - (test_vsync_back_porch + test_v_height + test_vsync_front_porch );
assign           vsync_high_to_low_count = 11'b000_0000_0000 ;

// ******************************************************************
always @ ( negedge clk or posedge reset )
begin
if ( reset )
        begin
        h_counter <= 12'h000 ;
        //v_counter <= 11'b000_0000_0000 ;
        v_counter <= test_vsync_back_porch + next_v_value;
        h_state <= hsync_high_state;
        v_state <= vsync_back_porch;
        end
else
        begin

        // horizontal state machine
        case (h_state)
        hsync_high_state : begin
                        if (h_match & vid_cntl_tgen_active )
                                h_state <= hsync_back_porch;
                        else
                                h_state <= h_state;
                        end
        hsync_back_porch : begin
                        if (h_match & vid_cntl_tgen_active )
                                h_state <= h_de;
                        else
                                h_state <= h_state;
                        end
        h_de:          begin
                        if (h_match & vid_cntl_tgen_active )
                                h_state <= hsync_front_porch;
                        else
                                h_state <= h_state;
                        end
        hsync_front_porch: begin
                        if (h_match & vid_cntl_tgen_active )
                                h_state <= hsync_high_state;
                        else
                                h_state <= h_state;
                        end
        default: h_state <= hsync_high_state;
        endcase

        // vertical state machine
        case (v_state)
        vsync_back_porch : begin
                        if (v_match & vid_cntl_tgen_active & end_of_line )
                                v_state <= v_de;
                        else
                                v_state <= v_state;
                        end
        v_de:          begin
                        if (v_match & vid_cntl_tgen_active &  end_of_line)
                                v_state <= vsync_front_porch;
                        else
                                v_state <= v_state;
                        end
        vsync_front_porch: begin
                        if (v_match & vid_cntl_tgen_active & end_of_line)
                                v_state <= vsync_high_state;
                        else
                                v_state <= v_state;
                        end
        vsync_high_state: begin
                           if ( v_match & vid_cntl_tgen_active & end_of_line)
                                v_state <= vsync_back_porch;
                           else
                                v_state <= v_state;
                           end
        default: v_state <= vsync_back_porch;
        endcase


        // h_counter load or decrementing
        case ({vid_cntl_tgen_start_of_frame,end_of_line,vid_cntl_tgen_active})
        3'b 1_0_0 : h_counter <= h_reload_count;
        3'b 0_1_1 : h_counter <= h_reload_count;
        3'b 0_0_1 : h_counter <= h_counter - 1'b1 ;
        default:    h_counter <= h_reload_count;
        endcase

        // v_counter load or decrementing 
        case ({vid_cntl_tgen_start_of_frame,end_of_frame,end_of_line})
        3'b 1_0_0 : v_counter <= v_reload_count;
        3'b 0_1_1 : v_counter <= v_reload_count;
        3'b 0_0_1 : v_counter <= v_counter - 1'b1 ;
        3'b 0_0_0 : v_counter <= v_counter ;
        default:    v_counter <= 11'h 2da;
        endcase

        end
end
// ******************************************************************
//  Drive data
// *******************************************************************

   task drive_pixel;

     `ifdef NUM_PIX_LANE_10
         input [WORD_WIDTH-1:0] pix_data9_i;
         input [WORD_WIDTH-1:0] pix_data8_i;
         input [WORD_WIDTH-1:0] pix_data7_i;
         input [WORD_WIDTH-1:0] pix_data6_i;
         input [WORD_WIDTH-1:0] pix_data5_i;
         input [WORD_WIDTH-1:0] pix_data4_i;
         input [WORD_WIDTH-1:0] pix_data3_i;
         input [WORD_WIDTH-1:0] pix_data2_i;
         input [WORD_WIDTH-1:0] pix_data1_i;
     `elsif NUM_PIX_LANE_8
         input [WORD_WIDTH-1:0] pix_data7_i;
         input [WORD_WIDTH-1:0] pix_data6_i;
         input [WORD_WIDTH-1:0] pix_data5_i;
         input [WORD_WIDTH-1:0] pix_data4_i;
         input [WORD_WIDTH-1:0] pix_data3_i;
         input [WORD_WIDTH-1:0] pix_data2_i;
         input [WORD_WIDTH-1:0] pix_data1_i;
     `elsif NUM_PIX_LANE_6
         input [WORD_WIDTH-1:0] pix_data5_i;
         input [WORD_WIDTH-1:0] pix_data4_i;
         input [WORD_WIDTH-1:0] pix_data3_i;
         input [WORD_WIDTH-1:0] pix_data2_i;
         input [WORD_WIDTH-1:0] pix_data1_i;
     `elsif NUM_PIX_LANE_4
         input [WORD_WIDTH-1:0] pix_data3_i;
         input [WORD_WIDTH-1:0] pix_data2_i;
         input [WORD_WIDTH-1:0] pix_data1_i;
     `elsif NUM_PIX_LANE_2
         input [WORD_WIDTH-1:0] pix_data1_i;
     `endif
         input [WORD_WIDTH-1:0] pix_data0_i;

      begin
        //Drive data at negedge, to make data centre aligned with pixel clock  
        //@ (negedge clk); 

        `ifdef NUM_PIX_LANE_10
            tgen_vid_data9 = pix_data9_i;
            tgen_vid_data8 = pix_data8_i;
            tgen_vid_data7 = pix_data7_i;
            tgen_vid_data6 = pix_data6_i;
            tgen_vid_data5 = pix_data5_i;
            tgen_vid_data4 = pix_data4_i;
            tgen_vid_data3 = pix_data3_i;
            tgen_vid_data2 = pix_data2_i;
            tgen_vid_data1 = pix_data1_i;
        `endif 
        `ifdef NUM_PIX_LANE_8
            tgen_vid_data7 = pix_data7_i;
            tgen_vid_data6 = pix_data6_i;
            tgen_vid_data5 = pix_data5_i;
            tgen_vid_data4 = pix_data4_i;
            tgen_vid_data3 = pix_data3_i;
            tgen_vid_data2 = pix_data2_i;
            tgen_vid_data1 = pix_data1_i;
        `endif 
        `ifdef NUM_PIX_LANE_6
            tgen_vid_data5 = pix_data5_i;
            tgen_vid_data4 = pix_data4_i;
            tgen_vid_data3 = pix_data3_i;
            tgen_vid_data2 = pix_data2_i;
            tgen_vid_data1 = pix_data1_i;
        `endif 
        `ifdef NUM_PIX_LANE_4
            tgen_vid_data3 = pix_data3_i;
            tgen_vid_data2 = pix_data2_i;
            tgen_vid_data1 = pix_data1_i;
        `endif 
        `ifdef NUM_PIX_LANE_2
            tgen_vid_data1 = pix_data1_i;
        `endif
            tgen_vid_data0 = pix_data0_i;

        @ (negedge clk); 

        //Check for de to drive further data
        check_for_de;

      end
   endtask

   task check_for_de;
      begin
        if(~tgen_vid_de) begin
            @(posedge tgen_vid_de);
        end
      end
   endtask

   initial begin
     forever begin
       @(clk);
       fork
         begin : data_gen_loop
           @(clk or reset or vid_cntl_tgen_active);
           if(reset)
           begin
               tgen_vid_data0 = 'h0;
               tgen_vid_data1 = 'h0;
               tgen_vid_data2 = 'h0;
               tgen_vid_data3 = 'h0;
               tgen_vid_data4 = 'h0;
               tgen_vid_data5 = 'h0;
               tgen_vid_data6 = 'h0;
               tgen_vid_data7 = 'h0;
               tgen_vid_data8 = 'h0;
               tgen_vid_data9 = 'h0;
               pix_data_0_buf = 'h0;
               pix_data_1_buf = 'h0;
               pix_data_2_buf = 'h0;
               pix_data_3_buf = 'h0;
               pix_data_4_buf = 'h0;
               pix_data_5_buf = 'h0;
               pix_data_6_buf = 'h0;
               pix_data_7_buf = 'h0;
               pix_data_8_buf = 'h0;
               pix_data_9_buf = 'h0;
               pix_data_10_buf = 'h0;
               pix_data_11_buf = 'h0;
               pix_data_12_buf = 'h0;
               pix_data_13_buf = 'h0;
               pix_data_14_buf = 'h0;
               pix_data_15_buf = 'h0;
               pix_data_16_buf = 'h0;
               pix_data_17_buf = 'h0;
               pix_data_18_buf = 'h0;
               pix_data_19_buf = 'h0;
               byte0 = 'h0;
               byte1 = 'h0;
               byte2 = 'h0;
               byte3 = 'h0;
               byte4 = 'h0;
               byte5 = 'h0;
               byte6 = 'h0;
               byte7 = 'h0;
               byte8 = 'h0;
               byte9 = 'h0;
               byte10 = 'h0;
               byte11 = 'h0;
               byte12 = 'h0;
               byte13 = 'h0;
               byte14 = 'h0;
               byte15 = 'h0;
               byte16 = 'h0;
               byte17 = 'h0;
               byte18 = 'h0;
               byte19 = 'h0;
               byte20 = 'h0;
               byte21 = 'h0;
               byte22 = 'h0;
               byte23 = 'h0;
               byte24 = 'h0;
           end    

           if(~vid_cntl_tgen_active)
             @(posedge vid_cntl_tgen_active);

           while(vid_cntl_tgen_active) begin
             if(v_state[1] && ((h_state == 'h2 && (h_match & vid_cntl_tgen_active )))) begin
                 @ (negedge clk);
             end
             else
             if(v_state[1] && (h_state[1] || (h_state == 'h0 && (h_match & vid_cntl_tgen_active )))) begin
                        `ifdef RGB666
                           drive_rgb666_data;
                        `elsif RGB888
                           drive_rgb888_data;
                        `elsif RAW8 //CSI, 1 /2 lanes
                           drive_raw8_csi_data;
                        `elsif YUV420_8 // CSI 1/2 lanes
                           drive_yuv420_8_csi_data;
                        `elsif YUV422_8 // CSI 1/2 lanes
                           drive_yuv422_8_csi_data;
                        `elsif YUV420_10 // CSI 1/2 lanes
                           drive_yuv420_10_csi_data;
                        `elsif YUV422_10 // CSI 1/2 lanes
                           drive_yuv422_10_csi_data;
                        `elsif RAW14 // CSI 1/2 lanes
                           drive_raw14_csi_data;
                        `elsif RAW16 // CSI 1/2 lanes
                           drive_raw16_csi_data;
                        `elsif RAW10 // CSI 1/2/3/6/8/10lanes
                           `ifdef NUM_PIX_LANE_10
                              drive_raw10_10lane_csi_data;
                           `elsif NUM_PIX_LANE_8
                              drive_raw10_8lane_csi_data;
                           `elsif NUM_PIX_LANE_6
                              drive_raw10_6lane_csi_data;
                           `elsif NUM_PIX_LANE_4
                              drive_raw10_4lane_csi_data;
                           `elsif NUM_PIX_LANE_2
                              drive_raw10_2lane_csi_data;
                           `else   
                              drive_raw10_1lane_csi_data;
                           `endif
                        `elsif RAW12 // CSI 1/2/3/6/8/10lanes
                           `ifdef NUM_PIX_LANE_10
                              drive_raw12_10lane_csi_data;
                           `elsif NUM_PIX_LANE_8
                              drive_raw12_8lane_csi_data;
                           `elsif NUM_PIX_LANE_6
                              drive_raw12_6lane_csi_data;
                           `elsif NUM_PIX_LANE_4
                              drive_raw12_4lane_csi_data;
                           `elsif NUM_PIX_LANE_2
                              drive_raw12_2lane_csi_data;
                           `else   
                              drive_raw12_1lane_csi_data;
                           `endif
                        `endif
             end    
             else begin
                 @ (negedge clk);
             end
           end
         end
         @(posedge reset) disable data_gen_loop;
       join
     end
   end

   task drive_rgb666_data;
       begin
           byte0 = $random;
           byte1 = $random;
           byte2 = $random;
           byte3 = $random;
           byte4 = $random;
           byte5 = $random;
           byte6 = $random;
           byte7 = $random;
           byte8 = $random;

           pix_data_0_buf = {byte2[1:0], byte1[7:0], byte0[7:0]};
           pix_data_1_buf = {byte4[3:0], byte3[7:0], byte2[7:2]};
           pix_data_2_buf = {byte6[5:0], byte5[7:0], byte4[7:4]};
           pix_data_3_buf = {byte8[7:0], byte7[7:0], byte6[7:6]};

           write_to_file("input_data.log", byte0);
           write_to_file("input_data.log", byte1);
           write_to_file("input_data.log", byte2);
           write_to_file("input_data.log", byte3);
           write_to_file("input_data.log", byte4);
           write_to_file("input_data.log", byte5);
           write_to_file("input_data.log", byte6);
           write_to_file("input_data.log", byte7);
           write_to_file("input_data.log", byte8);

           `ifdef NUM_PIX_LANE_4
             drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
           `elsif NUM_PIX_LANE_2
             drive_pixel(pix_data_1_buf, pix_data_0_buf);
             drive_pixel(pix_data_3_buf, pix_data_2_buf);
           `elsif NUM_PIX_LANE_1
             drive_pixel(pix_data_0_buf);
             drive_pixel(pix_data_1_buf);
             drive_pixel(pix_data_2_buf);
             drive_pixel(pix_data_3_buf);
           `endif
       end
   endtask

   task drive_rgb888_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;
            byte4 = $random;
            byte5 = $random;
            byte6 = $random;
            byte7 = $random;
            byte8 = $random;
            byte9 = $random;
            byte10= $random;
            byte11= $random;

            pix_data_0_buf = {byte2, byte1, byte0};
            pix_data_1_buf = {byte5, byte4, byte3};
            pix_data_2_buf = {byte8, byte7, byte6};
            pix_data_3_buf = {byte11, byte10, byte9};

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

            `ifdef NUM_PIX_LANE_4
              drive_pixel(pix_data_3_buf, pix_data_2_buf, pix_data_1_buf, pix_data_0_buf);
            `elsif NUM_PIX_LANE_2
              drive_pixel(pix_data_1_buf, pix_data_0_buf);
              drive_pixel(pix_data_3_buf, pix_data_2_buf);
            `elsif NUM_PIX_LANE_1
              drive_pixel(pix_data_0_buf);
              drive_pixel(pix_data_1_buf);
              drive_pixel(pix_data_2_buf);
              drive_pixel(pix_data_3_buf);
            `endif
       end
   endtask

   task drive_raw12_1lane_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;

            pix_data_0_buf = {byte0[7:0], byte2[3:0]};
            pix_data_1_buf = {byte1[7:0], byte2[7:4]};

            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);

            `ifdef NUM_PIX_LANE_1
            drive_pixel(pix_data_0_buf);
            drive_pixel(pix_data_1_buf);
            `endif
      end
   endtask

   task drive_raw12_2lane_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;

            pix_data_0_buf = {byte0[7:0], byte2[3:0]};
            pix_data_1_buf = {byte1[7:0], byte2[7:4]};

            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);

            `ifdef NUM_PIX_LANE_2
            drive_pixel(pix_data_1_buf, pix_data_0_buf);
            `endif
      end
   endtask

   task drive_raw12_4lane_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;
            byte4 = $random;
            byte5 = $random;

            pix_data_0_buf = {byte0[7:0], byte2[3:0]};
            pix_data_1_buf = {byte1[7:0], byte2[7:4]};
            pix_data_2_buf = {byte3[7:0], byte5[3:0]};
            pix_data_3_buf = {byte4[7:0], byte5[7:4]};

            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
            write_to_file("input_data.log", byte5);

            `ifdef NUM_PIX_LANE_4
            drive_pixel(pix_data_3_buf, pix_data_2_buf,
                        pix_data_1_buf, pix_data_0_buf);
            `endif
      end
   endtask

   task drive_raw12_6lane_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;
            byte4 = $random;
            byte5 = $random;
            byte6 = $random;
            byte7 = $random;
            byte8 = $random;

            pix_data_0_buf = {byte0[7:0], byte2[3:0]};
            pix_data_1_buf = {byte1[7:0], byte2[7:4]};
            pix_data_2_buf = {byte3[7:0], byte5[3:0]};
            pix_data_3_buf = {byte4[7:0], byte5[7:4]};
            pix_data_4_buf = {byte6[7:0], byte8[3:0]};
            pix_data_5_buf = {byte7[7:0], byte8[7:4]};

            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
            write_to_file("input_data.log", byte5);
            write_to_file("input_data.log", byte6);
            write_to_file("input_data.log", byte7);
            write_to_file("input_data.log", byte8);

            `ifdef NUM_PIX_LANE_6
            drive_pixel(pix_data_5_buf, pix_data_4_buf,
                        pix_data_3_buf, pix_data_2_buf,
                        pix_data_1_buf, pix_data_0_buf);
            `endif
      end
   endtask

   task drive_raw12_8lane_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;
            byte4 = $random;
            byte5 = $random;
            byte6 = $random;
            byte7 = $random;
            byte8 = $random;
            byte9 = $random;
            byte10 = $random;
            byte11 = $random;

            pix_data_0_buf = {byte0[7:0], byte2[3:0]};
            pix_data_1_buf = {byte1[7:0], byte2[7:4]};
            pix_data_2_buf = {byte3[7:0], byte5[3:0]};
            pix_data_3_buf = {byte4[7:0], byte5[7:4]};
            pix_data_4_buf = {byte6[7:0], byte8[3:0]};
            pix_data_5_buf = {byte7[7:0], byte8[7:4]};
            pix_data_6_buf = {byte9[7:0], byte11[3:0]};
            pix_data_7_buf = {byte10[7:0], byte11[7:4]};

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

            `ifdef NUM_PIX_LANE_8
            drive_pixel(pix_data_7_buf, pix_data_6_buf,
                        pix_data_5_buf, pix_data_4_buf,
                        pix_data_3_buf, pix_data_2_buf,
                        pix_data_1_buf, pix_data_0_buf);
            `endif
      end
   endtask   

   task drive_raw12_10lane_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;
            byte4 = $random;
            byte5 = $random;
            byte6 = $random;
            byte7 = $random;
            byte8 = $random;
            byte9 = $random;
            byte10 = $random;
            byte11 = $random;
            byte12 = $random;
            byte13 = $random;
            byte14 = $random;

            pix_data_0_buf = {byte0[7:0], byte2[3:0]};
            pix_data_1_buf = {byte1[7:0], byte2[7:4]};
            pix_data_2_buf = {byte3[7:0], byte5[3:0]};
            pix_data_3_buf = {byte4[7:0], byte5[7:4]};
            pix_data_4_buf = {byte6[7:0], byte8[3:0]};
            pix_data_5_buf = {byte7[7:0], byte8[7:4]};
            pix_data_6_buf = {byte9[7:0], byte11[3:0]};
            pix_data_7_buf = {byte10[7:0], byte11[7:4]};
            pix_data_8_buf = {byte12[7:0], byte14[3:0]};
            pix_data_9_buf = {byte13[7:0], byte14[7:4]};

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

            `ifdef NUM_PIX_LANE_10
               drive_pixel(pix_data_9_buf, pix_data_8_buf,
                           pix_data_7_buf, pix_data_6_buf,
                           pix_data_5_buf, pix_data_4_buf,
                           pix_data_3_buf, pix_data_2_buf,
                           pix_data_1_buf, pix_data_0_buf);
            `endif
      end
   endtask

   task drive_raw8_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;

            pix_data_0_buf = byte0;
            pix_data_1_buf = byte1;

            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);

            `ifdef NUM_PIX_LANE_2
              drive_pixel(pix_data_1_buf, pix_data_0_buf);
            `elsif NUM_PIX_LANE_1
              drive_pixel(pix_data_0_buf);
              drive_pixel(pix_data_1_buf);
            `endif
      end
   endtask

   task drive_raw10_1lane_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;
            byte4 = $random;

            pix_data_0_buf = {byte0[7:0],byte4[1:0]};
            pix_data_1_buf = {byte1[7:0],byte4[3:2]};
            pix_data_2_buf = {byte2[7:0],byte4[5:4]};
            pix_data_3_buf = {byte3[7:0],byte4[7:6]};

            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);

            `ifdef NUM_PIX_LANE_1
            drive_pixel(pix_data_0_buf);
            drive_pixel(pix_data_1_buf);
            drive_pixel(pix_data_2_buf);
            drive_pixel(pix_data_3_buf);
            `endif
      end
   endtask

   task drive_raw10_2lane_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;
            byte4 = $random;

            pix_data_0_buf = {byte0[7:0],byte4[1:0]};
            pix_data_1_buf = {byte1[7:0],byte4[3:2]};
            pix_data_2_buf = {byte2[7:0],byte4[5:4]};
            pix_data_3_buf = {byte3[7:0],byte4[7:6]};

            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);

            `ifdef NUM_PIX_LANE_2
            drive_pixel(pix_data_1_buf, pix_data_0_buf);
            drive_pixel(pix_data_3_buf, pix_data_2_buf);
            `endif
      end
   endtask

   task drive_raw10_4lane_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;
            byte4 = $random;

            pix_data_0_buf = {byte0[7:0],byte4[1:0]};
            pix_data_1_buf = {byte1[7:0],byte4[3:2]};
            pix_data_2_buf = {byte2[7:0],byte4[5:4]};
            pix_data_3_buf = {byte3[7:0],byte4[7:6]};

            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);

            `ifdef NUM_PIX_LANE_4
            drive_pixel(pix_data_3_buf, pix_data_2_buf,
                        pix_data_1_buf, pix_data_0_buf);
            `endif
      end
   endtask

   task drive_raw10_6lane_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;
            byte4 = $random;
            byte5 = $random;
            byte6 = $random;
            byte7 = $random;
            byte8 = $random;
            byte9 = $random;
            byte10 = $random;
            byte11 = $random;
            byte12 = $random;
            byte13 = $random;
            byte14 = $random;

            pix_data_0_buf = {byte0[7:0],byte4[1:0]};
            pix_data_1_buf = {byte1[7:0],byte4[3:2]};
            pix_data_2_buf = {byte2[7:0],byte4[5:4]};
            pix_data_3_buf = {byte3[7:0],byte4[7:6]};
            pix_data_4_buf = {byte5[7:0],byte9[1:0]};
            pix_data_5_buf = {byte6[7:0],byte9[3:2]};
            pix_data_6_buf = {byte7[7:0],byte9[5:4]};
            pix_data_7_buf = {byte8[7:0],byte9[7:6]};
            pix_data_8_buf = {byte10[7:0],byte14[1:0]};
            pix_data_9_buf = {byte11[7:0],byte14[3:2]};
            pix_data_10_buf = {byte12[7:0],byte14[5:4]};
            pix_data_11_buf = {byte13[7:0],byte14[7:6]};

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

            `ifdef NUM_PIX_LANE_6
            drive_pixel(pix_data_5_buf, pix_data_4_buf,
                        pix_data_3_buf, pix_data_2_buf,
                        pix_data_1_buf, pix_data_0_buf);
            drive_pixel(pix_data_11_buf, pix_data_10_buf,
                        pix_data_9_buf, pix_data_8_buf,
                        pix_data_7_buf, pix_data_6_buf);
            `endif
      end
   endtask

   task drive_raw10_8lane_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;
            byte4 = $random;
            byte5 = $random;
            byte6 = $random;
            byte7 = $random;
            byte8 = $random;
            byte9 = $random;

            pix_data_0_buf = {byte0[7:0],byte4[1:0]};
            pix_data_1_buf = {byte1[7:0],byte4[3:2]};
            pix_data_2_buf = {byte2[7:0],byte4[5:4]};
            pix_data_3_buf = {byte3[7:0],byte4[7:6]};
            pix_data_4_buf = {byte5[7:0],byte9[1:0]};
            pix_data_5_buf = {byte6[7:0],byte9[3:2]};
            pix_data_6_buf = {byte7[7:0],byte9[5:4]};
            pix_data_7_buf = {byte8[7:0],byte9[7:6]};

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

            `ifdef NUM_PIX_LANE_8
            drive_pixel(pix_data_7_buf, pix_data_6_buf,
                        pix_data_5_buf, pix_data_4_buf,
                        pix_data_3_buf, pix_data_2_buf,
                        pix_data_1_buf, pix_data_0_buf);
            `endif
      end
   endtask

   task drive_raw10_10lane_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;
            byte4 = $random;
            byte5 = $random;
            byte6 = $random;
            byte7 = $random;
            byte8 = $random;
            byte9 = $random;
            byte10 = $random;
            byte11 = $random;
            byte12 = $random;
            byte13 = $random;
            byte14 = $random;
            byte15 = $random;
            byte16 = $random;
            byte17 = $random;
            byte18 = $random;
            byte19 = $random;
            byte20 = $random;
            byte21 = $random;
            byte22 = $random;
            byte23 = $random;
            byte24 = $random;

            pix_data_0_buf = {byte0[7:0],byte4[1:0]};
            pix_data_1_buf = {byte1[7:0],byte4[3:2]};
            pix_data_2_buf = {byte2[7:0],byte4[5:4]};
            pix_data_3_buf = {byte3[7:0],byte4[7:6]};
            pix_data_4_buf = {byte5[7:0],byte9[1:0]};
            pix_data_5_buf = {byte6[7:0],byte9[3:2]};
            pix_data_6_buf = {byte7[7:0],byte9[5:4]};
            pix_data_7_buf = {byte8[7:0],byte9[7:6]};
            pix_data_8_buf = {byte10[7:0],byte14[1:0]};
            pix_data_9_buf = {byte11[7:0],byte14[3:2]};
            pix_data_10_buf = {byte12[7:0],byte14[5:4]};
            pix_data_11_buf = {byte13[7:0],byte14[7:6]};
            pix_data_12_buf = {byte15[7:0],byte19[1:0]};
            pix_data_13_buf = {byte16[7:0],byte19[3:2]};
            pix_data_14_buf = {byte17[7:0],byte19[5:4]};
            pix_data_15_buf = {byte18[7:0],byte19[7:6]};
            pix_data_16_buf = {byte20[7:0],byte24[1:0]};
            pix_data_17_buf = {byte21[7:0],byte24[3:2]};
            pix_data_18_buf = {byte22[7:0],byte24[5:4]};
            pix_data_19_buf = {byte23[7:0],byte24[7:6]};

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

            `ifdef NUM_PIX_LANE_10
            drive_pixel(pix_data_9_buf, pix_data_8_buf,
                        pix_data_7_buf, pix_data_6_buf,
                        pix_data_5_buf, pix_data_4_buf,
                        pix_data_3_buf, pix_data_2_buf,
                        pix_data_1_buf, pix_data_0_buf);
            drive_pixel(pix_data_19_buf, pix_data_18_buf,
                        pix_data_17_buf, pix_data_16_buf,
                        pix_data_15_buf, pix_data_14_buf,
                        pix_data_13_buf, pix_data_12_buf,
                        pix_data_11_buf, pix_data_10_buf);
            `endif
      end
   endtask

   task drive_yuv422_8_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;

            pix_data_0_buf = byte0;
            pix_data_1_buf = byte1;
            pix_data_2_buf = byte2;
            pix_data_3_buf = byte3;

            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);

            `ifdef NUM_PIX_LANE_2
              drive_pixel(pix_data_1_buf, pix_data_0_buf);
              drive_pixel(pix_data_3_buf, pix_data_2_buf);
            `elsif NUM_PIX_LANE_1
              drive_pixel(pix_data_0_buf);
              drive_pixel(pix_data_1_buf);
              drive_pixel(pix_data_2_buf);
              drive_pixel(pix_data_3_buf);
            `endif
      end
   endtask

   task drive_yuv422_10_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;
            byte4 = $random;

            pix_data_0_buf = {byte0[7:0],byte4[1:0]};
            pix_data_1_buf = {byte1[7:0],byte4[3:2]};
            pix_data_2_buf = {byte2[7:0],byte4[5:4]};
            pix_data_3_buf = {byte3[7:0],byte4[7:6]};

            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);

            `ifdef NUM_PIX_LANE_2
            drive_pixel(pix_data_1_buf, pix_data_0_buf);
            drive_pixel(pix_data_3_buf, pix_data_2_buf);
            `elsif NUM_PIX_LANE_1
            drive_pixel(pix_data_0_buf);
            drive_pixel(pix_data_1_buf);
            drive_pixel(pix_data_2_buf);
            drive_pixel(pix_data_3_buf);
            `endif
      end
   endtask

// [20201009] Added for new data type
   task drive_raw14_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;
            byte4 = $random;
            byte5 = $random;
            byte6 = $random;

            pix_data_0_buf = {byte0[7:0],byte4[5:0]};
            pix_data_1_buf = {byte1[7:0],byte5[3:0],byte4[7:6]};
            pix_data_2_buf = {byte2[7:0],byte6[1:0],byte5[7:4]};
            pix_data_3_buf = {byte3[7:0],byte6[7:2]};

            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);
            write_to_file("input_data.log", byte5);
            write_to_file("input_data.log", byte6);

            `ifdef NUM_PIX_LANE_2
            drive_pixel(pix_data_1_buf, pix_data_0_buf);
            drive_pixel(pix_data_3_buf, pix_data_2_buf);
            `elsif NUM_PIX_LANE_1
            drive_pixel(pix_data_0_buf);
            drive_pixel(pix_data_1_buf);
            drive_pixel(pix_data_2_buf);
            drive_pixel(pix_data_3_buf);
            `endif
      end
   endtask

   task drive_raw16_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;

            pix_data_0_buf = {byte0,byte1};
            pix_data_1_buf = {byte2,byte3};

            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);

            `ifdef NUM_PIX_LANE_2
            drive_pixel(pix_data_1_buf,pix_data_0_buf);
            `elsif NUM_PIX_LANE_1
            drive_pixel(pix_data_0_buf);
            drive_pixel(pix_data_1_buf);
            `endif

      end
   endtask

// EndOfEdit

   task drive_yuv420_8_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;

            pix_data_0_buf = byte0;
            pix_data_1_buf = byte1;

            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);

            `ifdef NUM_PIX_LANE_2
              drive_pixel(pix_data_1_buf, pix_data_0_buf);
            `elsif NUM_PIX_LANE_1
              drive_pixel(pix_data_0_buf);
              drive_pixel(pix_data_1_buf);
            `endif
      end
   endtask

   task drive_yuv420_10_csi_data;
       begin
            byte0 = $random;
            byte1 = $random;
            byte2 = $random;
            byte3 = $random;
            byte4 = $random;

            pix_data_0_buf = {byte0[7:0],byte4[1:0]};
            pix_data_1_buf = {byte1[7:0],byte4[3:2]};
            pix_data_2_buf = {byte2[7:0],byte4[5:4]};
            pix_data_3_buf = {byte3[7:0],byte4[7:6]};

            write_to_file("input_data.log", byte0);
            write_to_file("input_data.log", byte1);
            write_to_file("input_data.log", byte2);
            write_to_file("input_data.log", byte3);
            write_to_file("input_data.log", byte4);

            `ifdef NUM_PIX_LANE_2
            drive_pixel(pix_data_1_buf, pix_data_0_buf);
            drive_pixel(pix_data_3_buf, pix_data_2_buf);
            `elsif NUM_PIX_LANE_1
            drive_pixel(pix_data_0_buf);
            drive_pixel(pix_data_1_buf);
            drive_pixel(pix_data_2_buf);
            drive_pixel(pix_data_3_buf);
            `endif
      end
   endtask

   task write_to_file (input [1024*8-1:0] str_in, input [7:0] data);
      integer filedesc;
      if(byte_log_en == 1)
      begin
         filedesc = $fopen(str_in,"a");
         $fwrite(filedesc, "%h\n", data);
         $fclose(filedesc);
      end
   endtask

endmodule
`endif