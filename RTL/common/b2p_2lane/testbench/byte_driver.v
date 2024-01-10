// =========================================================================
// Filename: byte_driver.v
// Copyright(c) 2017 Lattice Semiconductor Corporation. All rights reserved.
// =========================================================================
`ifndef BYTE_DRIVER
`define BYTE_DRIVER

`include "tb_include/tb_params.vh"
`timescale 1 ps / 1 ps

module byte_driver #(
      parameter DATA_TYPE     = 6'h2B, //RAW10
      parameter RX_TYPE       = "CSI-2", 
      parameter DSI_MODE      = "BURST", 
      parameter GEAR          = 8,
      parameter RX_CH         = 1,
      parameter POLARITY      = 1,
      parameter NUM_FRAMES    = 5,
      parameter NUM_LINES     = 10,
      parameter PD_BUS_WIDTH  = 24,
      parameter NUM_TX_CH     = 1,
      parameter SP2_LP_ENABLE = 0,
      parameter SP_LP2_ENABLE = 0,
      parameter NUM_OF_BYTES  = 3840
    )
    
    (
      input enable_write_log,
      input hsync_i,
      input clk,
      input reset ,
      input vid_cntl_tgen_active,
      output reg sp_o ,
      output reg lp_o ,
      output reg [15:0]wc_o ,
      output reg [5:0] dt_o,
      output reg sp2_o ,
      output reg lp2_o ,
      output reg [15:0]wc2_o ,
      output reg [5:0] dt2_o,
      output reg payload_en ,
      output reg [(GEAR*RX_CH)-1:0] byte_data 
    );

reg          sp2_high = 0;
reg          sp_high  = 0;
reg [5:0]    vid_hsync;
wire[5:0]    vid_vsync;
wire         tgen_vid_hsync,
             tgen_vid_vsync,
             tgen_vid_de;
wire         tgen_end_of_line,
             tgen_end_of_frame;
wire         end_of_line,
             end_of_frame;
reg[15:0]    next_h_value,
             h_counter;
wire [15:0]  h_reload_count,
             hsync_high_to_low_count,
             hde_start,
             hde_end,
             hsync_low_to_high_count;
             
reg[10:0]    next_v_value,
             v_counter;
wire [11:0]  v_reload_count,
             vsync_high_to_low_count,
             vde_start,
             vde_end,
             vsync_low_to_high_count;

wire         h_match,
             v_match;

reg[2:0]     h_state,
             v_state;
wire         vid_cntl_tgen_start_of_frame = 'b0;
reg          vsync_start ; 
integer frame_counter,line_counter ;
//reg [GEAR-1:0] b[0:100];
reg [7:0] b[0:100]; //much easier for byte to pixel conversion if byte data is used for gear16



integer i;

event reset_ev ;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_0_buf ;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_1_buf ;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_2_buf ;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_3_buf ;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_4_buf ;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_5_buf ;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_6_buf ;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_7_buf ;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_8_buf ;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_9_buf ;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_10_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_11_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_12_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_13_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_14_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_15_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_16_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_17_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_18_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_19_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_20_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_21_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_22_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_23_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_24_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_25_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_26_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_27_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_28_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_29_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_30_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_31_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_32_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_33_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_34_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_35_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_36_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_37_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_38_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_39_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_40_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_41_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_42_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_43_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_44_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_45_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_46_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_47_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_48_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_49_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_50_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_51_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_52_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_53_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_54_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_55_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_56_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_57_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_58_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_59_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_60_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_61_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_62_buf;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pix_data_63_buf;


integer num_bytes ;
wire [15:0] test_h_width;

//variable used on csi2_tasks.vh -lorenz
// last remaining bytes per task call
wire	[15:0]	 last_byte_remainder;
assign 		 last_byte_remainder = NUM_OF_BYTES%(RX_CH*num_bytes*(GEAR/8));
wire	[15:0]	 last_byte_remainder_even; // remainder for even lines
assign 		 last_byte_remainder_even = (NUM_OF_BYTES*2)%(RX_CH*num_bytes*(GEAR/8));

wire [15:0] wc_mod_byteperclk;
assign wc_mod_byteperclk               = NUM_OF_BYTES%(RX_CH*(GEAR/8));
//downcounter.
reg [15:0] 	 rem_byte_cnt;

parameter test_h_total                 = NUM_OF_BYTES + `HFP_PAYLOAD + `HSA_PAYLOAD + `HBP_PAYLOAD;
parameter test_hsync_front_porch       =`HFP_PAYLOAD;
parameter test_hsync_width             =`HSA_PAYLOAD;
parameter test_hsync_back_porch        =`HBP_PAYLOAD;

// turn this to wire
//parameter test_h_width                 = NUM_OF_BYTES/(RX_CH*GEAR/8);
assign test_h_width = (last_byte_remainder == 0) ? NUM_OF_BYTES/(RX_CH*GEAR/8) :   /// last_byte_remainder == 0?
                                                   (NUM_OF_BYTES/(RX_CH*GEAR/8)) +1;
                                                       
parameter test_v_total                 = NUM_LINES + `VFP_LINES + `VSA_LINES + `VBP_LINES;
parameter test_v_height                = NUM_LINES;
parameter test_vsync_front_porch       =`VFP_LINES;
parameter test_vsync_width             =`VSA_LINES; 
parameter test_vsync_back_porch        =`VBP_LINES;

//parameter test_h_total                 =  12'd80;
//parameter test_hsync_front_porch       =  HFP_PAYLOAD;
//parameter test_hsync_width             =  HSA_PAYLOAD;
//parameter test_hsync_back_porch        =  HBP_PAYLOAD;
//parameter test_h_width                 =  12'd64;
//
//parameter test_v_total                 =  11'd55;
//parameter test_v_height                =  11'd48;
//parameter test_vsync_front_porch       =  VFP_LINES;
//parameter test_vsync_width             =  VSA_LINES;
//parameter test_vsync_back_porch        =  VBP_LINES;


parameter hsync_high_state             =  3'b1_0_0; 
parameter hsync_back_porch             =  3'b0_0_0;
parameter h_de                         =  3'b0_1_0;
parameter hsync_front_porch            =  3'b0_0_1;
                                       
parameter vsync_high_state             =  3'b1_0_0; 
parameter vsync_back_porch             =  3'b0_0_0;
parameter v_de                         =  3'b0_1_0;
parameter vsync_front_porch            =  3'b0_0_1;


parameter VSYNC_ST         = 8'h01;
parameter VSYNC_END        = 8'h11; 
parameter HSYNC_ST         = 8'h21; 
parameter HSYNC_END        = 8'h31;
parameter FRAME_ST         = 8'h00;
parameter FRAME_END        = 8'h01;
parameter LINE_ST          = 8'h02;
parameter LINE_END         = 8'h03;

localparam RAW8            = 6'h2A;
localparam RAW10           = 6'h2B;
localparam RAW12           = 6'h2C;
localparam RAW14           = 6'h2D;
localparam RAW16           = 6'h2E;
localparam YUV420_8        = 6'h18;
localparam LEGACY_YUV420_8 = 6'h1A;
localparam YUV420_8_CSPS   = 6'h1C;
localparam YUV422_8        = 6'h1E;
localparam YUV420_10       = 8'h19;
localparam YUV420_10_CSPS  = 8'h1D;
localparam YUV422_10       = 8'h1F;

localparam RGB888          = (RX_TYPE=="DSI") ? 6'h3E : 6'h24; 
localparam RGB565          = (RX_TYPE=="DSI") ? 6'h0E : 6'h22;
localparam RGB666          = 6'h1E;
localparam RGB666_LP       = 6'h2E;
localparam YCbCr422_20     = 6'h0C;
localparam YCbCr422_24     = 6'h1C;
localparam YCbCr422_16     = 6'h2C;

    assign tgen_vid_hsync =  h_state[2] ;
    assign tgen_vid_vsync =  v_state[2] ;
    assign tgen_vid_de = h_state[1] & v_state[1] ;
    
    // time multiplexed comparator, at least 1 period wide durations are a must
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
                default:           next_v_value = vsync_high_to_low_count;
        endcase
    end
//`ifdef RX_TYPE_DSI
generate
    if(RX_TYPE == "DSI") begin : DSI_sync
        assign   h_reload_count = test_h_total-1'b1; 
        assign   v_reload_count = test_v_total-1'b1; 
        assign   hsync_high_to_low_count = test_h_total - test_hsync_width ;
        assign   hde_start = test_h_total - (test_hsync_back_porch+test_hsync_width) ;
        assign   hde_end = test_h_total - (test_hsync_width+test_hsync_back_porch+test_h_width);
        assign   hsync_low_to_high_count = 12'h000 ;
         
        assign   vde_start = (test_v_total - test_vsync_back_porch);
        assign   vde_end = test_v_total - (test_vsync_back_porch + test_v_height);
        assign   vsync_low_to_high_count = test_v_total - (test_vsync_back_porch + test_v_height + test_vsync_front_porch );
        assign   vsync_high_to_low_count = 11'b000_0000_0000 ;
    end
endgenerate	
//`endif
    // ******************************************************************
    always @ ( posedge clk or posedge reset )
    begin
        if ( reset )
        begin
//             h_counter <= 12'h000 ;
             h_counter <= 16'h1000 ;
             //v_counter <= 11'b000_1111_1111 ;
             v_counter <= vde_start + 10 ;
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

generate 
    if(RX_TYPE == "DSI") begin : RX_TYPE_is_DSI
        always@(posedge clk or posedge reset) begin
            if(reset) begin
                dt_o <= 0;
                dt2_o <= 0;
            end
            else if(v_state[0] & h_state[0] & h_match & v_match & vsync_start )
                dt_o <= VSYNC_ST ;
            else if(v_state[2] & h_state[0] & h_match & v_match & vsync_start)
                if (DSI_MODE == "NONBURST_PULSES") begin
                    dt_o <= VSYNC_END;
                end else begin
                    dt_o <= HSYNC_ST;
                end
            else if(h_state[0] & h_match & vsync_start)
                dt_o <= HSYNC_ST;
            else if(h_state[2] & h_match & vsync_start)
                dt_o <= HSYNC_END;
            else if(h_state ==0 && (h_counter == next_h_value+1 ) && vid_cntl_tgen_active && v_state[1] && vsync_start) begin //TODO UDAY Need to add dt_o for complete de enable
               if(SP_LP2_ENABLE == 1) begin
                dt2_o <= DATA_TYPE;   
               end
               else begin
                dt_o <= DATA_TYPE;   
               end
                
            end
            else if(((h_state ==0 && h_match && vid_cntl_tgen_active && !tgen_vid_de && v_state[1]) || (h_state[1] && !h_match && vid_cntl_tgen_active && tgen_vid_de)) && vsync_start  ) begin //Condition for dt_i to be enabled till payload_en is HIGH
              if(SP_LP2_ENABLE == 1) begin
                dt2_o <= DATA_TYPE;
               end
               else begin
                dt_o <= DATA_TYPE;
               end
            end
            else begin 
                dt_o <= 0;
                dt2_o <= 0;
            end
            
        end
        
        always@(posedge vsync_start) 
	    begin
           #1;
           sp_o <= 1;
           dt_o <= VSYNC_ST;
           wc_o <= 0;
           write_vsync_hsync("sync_data_out.log",1);
           write_vsync_hsync("sync_data_out.log",0);
           repeat(test_vsync_width-1) begin
             @(posedge hsync_i);
           end
           #1;
           sp_o <= 0;
           dt_o <= 0;
        end
        
        always@(posedge clk or posedge reset)
        begin
            if(reset) begin
                sp_o <= 0;
                sp2_o <= 0;
            end
            else if(((v_state[0] & h_state[0] & h_match & v_match) || ( v_state[2] & h_state[0] & h_match & v_match) ||
                    (h_state[0] & h_match ) || (h_state[2] & h_match ))  && vsync_start) begin
                sp_o <= 1 ;
                if(v_state[0] & h_state[0] & h_match & v_match) begin
                    write_vsync_hsync("sync_data_out.log",1);
                    write_vsync_hsync("sync_data_out.log",0);
                end
                else if(h_state[0] & h_match) 
                    write_vsync_hsync("sync_data_out.log",0); 
            end
            else begin
                sp_o <= 0;
                sp2_o <= 0;
            end
            
        end
        
        always@(posedge clk or posedge reset)
        begin
            if(reset) begin
                lp_o <= 0;
                lp2_o <= 0;
            end
            else if( h_state ==0 && (h_counter == next_h_value+1 ) && vid_cntl_tgen_active && v_state[1] && vsync_start) begin
              if(SP_LP2_ENABLE == 1) begin
                lp2_o <= 1 ;
                sp_o <= 1;
                dt_o <= HSYNC_ST;
                wc_o <= 0;
                write_vsync_hsync("sync_data_out.log",0); 
                sp_high <= 1;
              end
              else begin
                lp_o <= 1 ;
                if(SP2_LP_ENABLE == 1) begin //drive hsync start in sp2
                  sp2_o <= 1;
                  dt2_o <= HSYNC_ST;
                  wc2_o <= 0;
                  write_vsync_hsync("sync_data_out.log",0); 
                  sp2_high <= 1;
                end
              end
            end
            else begin
                lp_o <= 0;
                lp2_o <= 0;
            end
            
        end
        
        always@(posedge sp2_high) begin
          @(posedge clk);
          sp2_o <= 0;
          dt2_o <= 0;
          sp2_high <= 0;
        
          repeat(test_hsync_width-1) begin
            @(posedge clk);
          end
          #1;
          sp2_o <= 1;
          dt2_o <= HSYNC_END;
          @(posedge clk);
          #1;
          sp2_o <= 0;
          dt2_o <= 0;
        end
        
        always@(posedge sp_high) begin
          @(posedge clk);
          sp_o <= 0;
          dt_o <= 0;
          sp_high <= 0;
        
          repeat(test_hsync_width-1) begin
            @(posedge clk);
          end
          #1;
          sp_o <= 1;
          dt_o <= HSYNC_END;
          @(posedge clk);
          #1;
          sp_o <= 0;
          dt_o <= 0;
        end
        
        always@(posedge clk or posedge reset)
        begin
            if(reset) begin
                payload_en <=0;
              rem_byte_cnt <= NUM_OF_BYTES; 
            end
            else begin
                if(((h_state ==0 && h_match && vid_cntl_tgen_active && !tgen_vid_de && v_state[1]) || (h_state[1] && !h_match && vid_cntl_tgen_active && tgen_vid_de)) && vsync_start  ) begin
                  payload_en   <= (rem_byte_cnt == 0) ? 1'b0 : 1'b1;
                  rem_byte_cnt <= (rem_byte_cnt >=(RX_CH*GEAR/8)) ?  rem_byte_cnt - (RX_CH*GEAR/8) :
                                                                     (rem_byte_cnt == 0) ? 0       :    // stop decrementing when 0 is reached   
                                                                                          (rem_byte_cnt - wc_mod_byteperclk);
                end
                else begin
                  payload_en   <= 1'b0;
                  rem_byte_cnt <= NUM_OF_BYTES;
                end     
            end 
        end // always@ (posedge clk or posedge reset)

        always@(posedge clk or posedge reset)
        begin
            if(reset) begin
                wc_o <= 0;
                wc2_o <= 0;
            end
            else if( h_state ==0 && (h_counter == next_h_value+1 ) && vid_cntl_tgen_active &&  v_state[1] && vsync_start) begin
              if(SP_LP2_ENABLE==1) begin
                wc2_o <= NUM_OF_BYTES; // test_h_width*RX_CH*GEAR/8  ;
              end
              else begin
                wc_o <=  NUM_OF_BYTES; // test_h_width*RX_CH*GEAR/8  ;
              end
            end
            else if(((h_state ==0 && h_match && vid_cntl_tgen_active && !tgen_vid_de && v_state[1]) || (h_state[1] && !h_match && vid_cntl_tgen_active && tgen_vid_de)) && vsync_start  ) begin
              if(SP_LP2_ENABLE==1) begin
                wc2_o <= NUM_OF_BYTES; // test_h_width*RX_CH*GEAR/8  ;
              end
              else begin
                wc_o <=  NUM_OF_BYTES; // test_h_width*RX_CH*GEAR/8  ;
              end
            end
            else begin 
                wc_o <= 0;
                wc2_o <= 0;
            end
            
        end
    end
endgenerate

always@(posedge clk or posedge reset)
begin
    if(reset)
        vsync_start <= 0;
    else if(tgen_vid_vsync)
        vsync_start <= 1;
end


initial begin
    wait(reset == 1);
#1;
    if (reset) begin
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
        for(i=0;i<100;i=i+1)begin
            b[i]  = 'h0;
        end
        byte_data = 0;
    end
    

    if (RX_TYPE == "DSI") begin
        case(DATA_TYPE)
            RGB888            : num_bytes = 3;
            RGB666            : num_bytes = 9;
            RGB666_LP         : num_bytes = 3;
            RGB565            : num_bytes = 2;
            YCbCr422_16       : num_bytes = 2; 
            YCbCr422_20       : num_bytes = 3;    
            YCbCr422_24       : num_bytes = 3;
            default           : num_bytes = 1;
        endcase
    end
    else begin
        case(DATA_TYPE)
            RGB888            : num_bytes = 3;
            RGB565            : num_bytes = 2;
            RAW8              : num_bytes = 1;
            RAW10             : num_bytes = 5;
            RAW12             : num_bytes = 3;
			RAW14             : num_bytes = 7;
			RAW16             : num_bytes = 2;
            YUV420_8          : num_bytes = 2;//TODO
            YUV420_8_CSPS     : num_bytes = 4;//TODO
            LEGACY_YUV420_8   : num_bytes = 3;
            YUV422_8          : num_bytes = 4;
            YUV420_10         : num_bytes = 5;//TODO
            YUV420_10_CSPS    : num_bytes = 10;//TODO
            YUV422_10         : num_bytes = 5;
            default           : num_bytes = 1;
         endcase
    end

    wait(vsync_start==1);
    
    while(vid_cntl_tgen_active)begin
        if(((h_state ==0 & h_match & vid_cntl_tgen_active & !tgen_vid_de & v_state[1]) || (h_state[1] & !h_match & vid_cntl_tgen_active & tgen_vid_de))  && vsync_start && (rem_byte_cnt !== 0) )begin
        //wait(tgen_vid_de)
	  
          if(RX_TYPE == "DSI") begin
             if (rem_byte_cnt >= RX_CH*num_bytes*GEAR/8) begin
                if (DATA_TYPE == RGB666) 
                        gen_dsi_rgb666_pixel_data(RX_CH*GEAR/8);
                if (DATA_TYPE == RGB666_LP) 
                        gen_dsi_rgb666_lp_pixel_data(RX_CH*GEAR/8);
                if (DATA_TYPE == RGB888) 
                         gen_dsi_rgb888_pixel_data(RX_CH*GEAR/8);
                if (DATA_TYPE == RGB565) 
                         gen_dsi_rgb565_pixel_data(RX_CH*GEAR/8);
                if (DATA_TYPE == YCbCr422_16) 
                         gen_dsi_ycbcr422_16_pixel_data(RX_CH*GEAR/8);
                if (DATA_TYPE == YCbCr422_20) 
                         gen_dsi_ycbcr422_20_pixel_data(RX_CH*GEAR/8);
                if (DATA_TYPE == YCbCr422_24) 
                         gen_dsi_ycbcr422_24_pixel_data(RX_CH*GEAR/8);
              end
              else if (rem_byte_cnt !== 0)  begin
                $display("last_byte_remainder : %d", last_byte_remainder);
                if (DATA_TYPE == RGB666) 
                        gen_dsi_rgb666_pixel_data(last_byte_remainder/num_bytes);
                if (DATA_TYPE == RGB666_LP) 
                        gen_dsi_rgb666_lp_pixel_data(last_byte_remainder/num_bytes);
                if (DATA_TYPE == RGB888) 
                         gen_dsi_rgb888_pixel_data(last_byte_remainder/num_bytes);
                if (DATA_TYPE == RGB565) 
                         gen_dsi_rgb565_pixel_data(last_byte_remainder/num_bytes);
                if (DATA_TYPE == YCbCr422_16) 
                         gen_dsi_ycbcr422_16_pixel_data(last_byte_remainder/num_bytes);
                if (DATA_TYPE == YCbCr422_20) 
                         gen_dsi_ycbcr422_20_pixel_data(last_byte_remainder/num_bytes);
                if (DATA_TYPE == YCbCr422_24) 
                         gen_dsi_ycbcr422_24_pixel_data(last_byte_remainder/num_bytes);   
              end 
              //else begin
              //  $display("no byte remaining : %d", rem_byte_cnt);
              //  @(posedge clk);
              //end
	  end // end "DSI"


        end
        else
            @(posedge clk);
    end
end

`include "tb_include/dsi_tasks.vh"
`include "tb_include/csi2_tasks.vh"

// count     - multiplicity. number of times the "num_bytes" is generated.
// num_bytes - minimum allowable bytes for the data type
task gen_byte (input [15:0] count);
begin
              `ifndef COUNTER
                for(i=0;i<num_bytes*count;i=i+1)begin // for(i=0;i<num_bytes*RX_CH*GEAR/8;i=i+1)begin
                   b[i] = $random;
                end
               `else 
                 if(RX_CH ==1)begin
                    for(i=1;i<num_bytes*RX_CH*GEAR/8;i=i+1)begin
                        b[i] = b[i-1]+1;
                    end
                 end
                 if(RX_CH ==2) begin
                    for(i=2;i<num_bytes*RX_CH*GEAR/8;i=i+2)begin
                        b[i]    = b[i-1]+1;
                        b[i+1]  = b[i-1]+1;
                    end
                 end
                 if(RX_CH ==4) begin
                    for(i=4;i<num_bytes*RX_CH*GEAR/8;i=i+4)begin
                        b[i]    = b[i-1]+1;
                        b[i+1]  = b[i-1]+1;
                        b[i+2]  = b[i-1]+1;
                        b[i+3]  = b[i-1]+1;
                    end
                 end
                `endif
end
endtask

task drive_csi_byte_data (input [15:0] count);
begin
//yel//  odd_cycle  = (num_bytes*count) < (RX_CH*GEAR/8);

                        if(RX_CH ==1 && GEAR == 8)begin
                          for(i=0;i<num_bytes;i=i+1)begin
                              byte_data <= b[i];
                              @(posedge clk);
                          end 
                        end
                        // 2 bytes per byteclk cycle...................................
                        if((RX_CH ==2 && GEAR == 8) || (RX_CH ==1 && GEAR == 16)) begin
                          for(i=0;i<num_bytes*count;i=i+2)begin
                              byte_data <= {b[i+1],b[i]};     
                              //$display ("byte count : %d",i);
                              @(posedge clk);
                            end
                        end 
                       // 4 bytes per byteclk cycle....................................
                       if((RX_CH ==4 && GEAR==8) || (RX_CH ==2 && GEAR==16)) begin
                          for(i=0;i<num_bytes*count;i=i+4)begin
                              byte_data <= {b[i+3],b[i+2],b[i+1],b[i]};
                              //$display ("byte count : %d",i);
                              @(posedge clk);
                          end
                       end
                       // 8 bytes per byteclock cycle..................................
                       if(RX_CH ==4 && GEAR==16) begin
                          for(i=0;i<num_bytes*count;i=i+8)begin
                            byte_data <= {b[i+7],b[i+6],b[i+5],b[i+4],b[i+3],b[i+2],b[i+1],b[i]};
                            //$display ("byte count : %d",i);
                              @(posedge clk);
                          end
                       end

                   end
endtask

//task write_to_file ( input [1024*4-1:0]str_in,input [(PD_BUS_WIDTH*NUM_TX_CH)-1:0]data);
task write_to_file ( input [1024*4-1:0]str_in,input [(PD_BUS_WIDTH)-1:0]data);
     integer filedesc;
   begin
    if(enable_write_log == 1) begin
     filedesc = $fopen(str_in,"a");
     $fwrite(filedesc, "%h\n", data);
     $fclose(filedesc);
    end
   end
endtask

task write_vsync_hsync ( input [1024*4-1:0]str_in,input vsync);
     integer filedesc;
   begin
    if(enable_write_log == 1) begin
     filedesc = $fopen(str_in,"a");
     if(vsync == 1) begin
        $fwrite(filedesc, "VSYNC\n");
     end
     else begin
        $fwrite(filedesc, "HSYNC\n");
     end
     $fclose(filedesc);
    end
   end
endtask

generate
    if (RX_TYPE == "CSI-2") begin :RX_TYPE_is_CSI2
    
        always@(posedge reset)
        begin
            -> reset_ev ;
        end

		//changes from PR_R_07
        integer YUV_even_line_cor;
        
        initial begin
        #1;
        fork
            forever begin :datagen_block
                if(reset)begin
                       dt_o = 0 ;
                       sp_o = 0;
                       lp_o = 0;
                       payload_en=0;
                       byte_data = 0;
                       wc_o      = 0;
                       frame_counter = 1;
                       line_counter = 1;
                       dt2_o = 0;
                       lp2_o = 0;
                       sp2_o = 0;
                       wc2_o = 0;
                end
            
                wait(reset ==0);
               
                repeat(500)@(posedge clk)
                wait(vid_cntl_tgen_active);
                while(vid_cntl_tgen_active)begin : total_frames
                   
                    @(posedge clk);
                     dt_o <= FRAME_ST ;
                     sp_o <= 1;
                     wc_o <= frame_counter;
                     repeat(15)begin
                            @(posedge clk) ;
                            dt_o <= 0 ;
                            sp_o <= 0;
                            wc_o <= 0;
                     end
            
                     repeat(NUM_LINES)begin
                        @(posedge clk);
                          dt_o <= LINE_ST ;
                          sp_o <= 1;
                          wc_o <= line_counter;
                        if(GEAR ==16 && RX_CH ==4)begin 
                          dt2_o <= LINE_ST ;
                          sp2_o <= 1;
                          wc2_o <= line_counter;
                        end
                         repeat(5)begin
                             @(posedge clk) ;
                            dt_o <= 0 ;
                            sp_o <= 0;
                            wc_o <= 0;
                            if(GEAR ==16 && RX_CH ==4)begin 
                              dt2_o <= 0 ;
                              sp2_o <= 0;
                              wc2_o <= 0;
                            end
                         end
            
                        @(posedge clk)
                            dt_o <= DATA_TYPE;
                            lp_o <= 1;
							//----- changes from PR_R_07 -------------------------
                            if (DATA_TYPE == YUV420_8 || DATA_TYPE == YUV420_10)
                                YUV_even_line_cor = (2 - (line_counter%2));
                            else    
                                YUV_even_line_cor = 1;
                            wc_o <= NUM_OF_BYTES*YUV_even_line_cor;
							//----------------------------------------------------
                        if(GEAR ==16 && RX_CH ==4)begin 
                            dt2_o <= DATA_TYPE ;
                            lp2_o <= 1;
                            wc2_o <= NUM_OF_BYTES;
                        end
                        @(posedge clk)
                            lp_o <= 0;
                        if(GEAR ==16 && RX_CH ==4)begin 
                            lp2_o <= 0;
                        end
                         payload_en<=1;
                         //yel/// repeat until the valid pixel data byte ends in the last lane
                         repeat ((NUM_OF_BYTES*YUV_even_line_cor)/(RX_CH*num_bytes*(GEAR/8)))begin
                            gen_csi_byte2pixel_data(RX_CH*(GEAR/8));  
                         end
                         //yel/// last pixels that will end in an odd lane
                         if ((last_byte_remainder !==0) && (YUV_even_line_cor == 1)) begin           
                           gen_csi_byte2pixel_data(last_byte_remainder/num_bytes); //
                         end
                         if ((last_byte_remainder_even !==0) && (YUV_even_line_cor == 2)) begin           
                           gen_csi_byte2pixel_data(last_byte_remainder_even/num_bytes); //
						 end
                         //yel///
                         repeat(5)begin
                            payload_en<=0;
                            dt_o <= 0 ;
                            sp_o <= 0;
                            if(GEAR ==16 && RX_CH ==4)begin 
                                dt2_o <= DATA_TYPE ;
                                sp2_o <= 0;
                            end
                             @(posedge clk) ;
                         end
                            dt_o <= LINE_END ;
                            sp_o <= 1;
                            wc_o <= line_counter;
                            if(GEAR ==16 && RX_CH ==4)begin 
                                dt2_o <= LINE_END ;
                                sp2_o <= 1;
                                wc2_o <= line_counter;
                            end
                        @(posedge clk)    
                       
                        repeat(15)begin
                            dt_o <= 0;
                            sp_o <= 0;
                            wc_o <= 0;
                            if(GEAR ==16 && RX_CH ==4)begin 
                                dt2_o <= 0;
                                sp2_o <= 0;
                                wc2_o <= 0;
                            end
                             @(posedge clk) ;
                         end
                       line_counter = line_counter+1; 
                     end
            
                     dt_o <= FRAME_END ;
                     sp_o <= 1;
                     wc_o <= frame_counter;
            
                        repeat(15)begin
                            @(posedge clk);
                            dt_o <= 0 ;
                            sp_o <= 0;
                            wc_o <= 0;
                         end
                    frame_counter <= frame_counter+1;
                    line_counter = 1; 
                end
            
            end
                @(posedge reset) disable datagen_block;
        join
        end
        
	task gen_csi_byte2pixel_data (input [15:0] count);
        begin
            if (DATA_TYPE == RAW8) 
                     gen_csi2_raw8_pixel_data(count);
            else if (DATA_TYPE == RAW10) 
                     gen_csi2_raw10_pixel_data(count);
            else if (DATA_TYPE == RAW12) 
                     gen_csi2_raw12_pixel_data(count);
			else if (DATA_TYPE == RAW14) 
                     gen_csi2_raw14_pixel_data(count);
			else if (DATA_TYPE == RAW16) 
                     gen_csi2_raw16_pixel_data(count);
            else if (DATA_TYPE == RGB565) 
                     gen_csi2_rgb565_pixel_data(count);
            else if (DATA_TYPE == RGB888) 
                     gen_csi2_rgb888_pixel_data(count);
            else if (DATA_TYPE == YUV420_8) 
                     gen_csi2_yuv420_8_pixel_data(count);
            else if (DATA_TYPE == YUV420_8_CSPS) 
                     gen_csi2_yuv420_8_csps_pixel_data(count);
            else if (DATA_TYPE == LEGACY_YUV420_8) 
                     gen_csi2_leg_yuv420_8_pixel_data(count);
            else if (DATA_TYPE == YUV422_8) 
                     gen_csi2_yuv422_8_pixel_data(count);
            else if (DATA_TYPE == YUV422_10) 
                     gen_csi2_yuv422_10_pixel_data(count);
            else if (DATA_TYPE == YUV420_10) 
                     gen_csi2_yuv420_10_pixel_data(count);
            else if (DATA_TYPE == YUV420_10_CSPS) 
                     gen_csi2_yuv420_10_csps_pixel_data(count);
        end
        endtask
end
endgenerate

endmodule

`endif
