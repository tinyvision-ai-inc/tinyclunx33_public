// =========================================================================
// Filename: tb_top.v
// Copyright(c) 2017 Lattice Semiconductor Corporation. All rights reserved.
// =========================================================================
`include "tb_include/tb_params.vh"
`include "byte_driver.v"
`include "pixel_monitor.v"
`timescale 1 ps / 1 ps


//directive for pixel width
module tb_top;
`include "dut_params.v"

    localparam POLARITY         = (CTRL_POL == "POSITIVE");
    localparam PIXCLK_PERIOD    = 1000000/PIX_CLK_FREQ;
    localparam BYTECLK_PERIOD   = 1000000/BYTE_CLK_FREQ;
    localparam NUM_OF_BYTES     = WORD_CNT;

`ifdef NUM_FRAMES
    localparam NUM_FRAMES       = `NUM_FRAMES;
`else
    localparam NUM_FRAMES       =  FRAMES_CNT;
`endif

`ifdef NUM_LINES
    localparam NUM_LINES        = `NUM_LINES;
`else
    localparam NUM_LINES        =  LINES_CNT;
`endif

`ifdef SP2_LP_SIMULTANEOUS
  parameter SP2_LP_ENABLE = 1;
  parameter SP_LP2_ENABLE = 0;
`elsif SP_LP2_SIMULTANEOUS
  parameter SP_LP2_ENABLE = 1;
  parameter SP2_LP_ENABLE = 0;
`else
  parameter SP2_LP_ENABLE = 0;
  parameter SP_LP2_ENABLE = 0;
`endif

            
localparam BYTE_DATA_WIDTH = (RX_GEAR*NUM_RX_LANE < 64) ? (RX_GEAR*NUM_RX_LANE+22): // 22 = dt+wc=6+16
                                                          (RX_GEAR*NUM_RX_LANE+44); // 44 = dt+wc+dt2+wc2

// DSI data types
localparam YCbCr422_20     = 6'h0C;
localparam YCbCr422_24     = 6'h1C;
localparam YCbCr422_16     = 6'h2C;
localparam RGB666          = 6'h1E;
localparam RGB666_LOOSE    = 6'h2E;

// CSI-2 data types
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

 ////YEL hwii-666..................
localparam RGB888          = (RX_TYPE=="DSI") ? 6'h3E : 6'h24;
 ////YEL hwii-666..................
 
 ////ARM ..................
localparam RGB565          = (RX_TYPE=="DSI") ? 6'h0E : 6'h22;
                                                          
localparam pd_bits_num = (RX_TYPE=="DSI") ? (
                          (DT == RGB565)          ? 16 :
                          (DT == RGB666_LOOSE)    ? 24 :
                          (DT == RGB666)          ? 18 :
                          (DT == RGB888)          ? 24 :
                          (DT == YCbCr422_20)     ? 24 :
                          (DT == YCbCr422_24)     ? 24 :
                          (DT == YCbCr422_16)     ? 16 : 16) :
                         //(RX_TYPE=="CSI") 
                         (DT == RGB565)          ? 16 :
                         (DT == RGB888)          ? 24 :
                         (DT == RAW8)            ? 8 :
                         (DT == RAW10)           ? 10 :
                         (DT == RAW12)           ? 12 :
						 (DT == RAW14)           ? 14 :
						 (DT == RAW16)           ? 16 :
                         (DT == YUV420_8)        ? 8 :
                         (DT == LEGACY_YUV420_8) ? 8 :
                         (DT == YUV420_8_CSPS)   ? 8 :
                         (DT == YUV422_8)        ? 8 :
                         (DT == YUV420_10)       ? 10 :
                         (DT == YUV420_10_CSPS)  ? 10:
                         (DT == YUV422_10)       ? 10 : 8;




//localparam exp_pixel_count = (NUM_FRAMES * NUM_LINES * NUM_OF_BYTES*8)/pd_bits_num;

localparam exp_pixel_count = ((DT == YUV420_8) || (DT == YUV420_10)) ? 
        (NUM_FRAMES * (NUM_LINES + (NUM_LINES >> 1)) * NUM_OF_BYTES*8)/pd_bits_num :
        (NUM_FRAMES * NUM_LINES * NUM_OF_BYTES*8)/pd_bits_num;
integer actual_pixel_counter;

//localparam pixel_count = (NUM_FRAMES * NUM_LINES * NUM_OF_BYTES)/bytes_num;
//localparam pixel_count = (NUM_FRAMES * NUM_LINES * NUM_OF_BYTES)/bytes_num*NUM_TX_CH_INPUT;
//localparam pixel_count = (NUM_FRAMES * NUM_LINES * NUM_OF_BYTES*8)/(PD_BUS_WIDTH * NUM_TX_CH);
//localparam pixel_count = (NUM_FRAMES * NUM_LINES * NUM_OF_BYTES*8)/(PD_BUS_WIDTH);

wire axis_mready_i;
wire axis_mvalid_o;     
wire [(PD_BUS_WIDTH*NUM_TX_CH+2-1):0] axis_mdata_o;


wire axis_sclk_i;
wire axis_sresetn_i;
wire axis_svalid_i;
wire axis_sready_i;
wire [BYTE_DATA_WIDTH-1:0] axis_sdata_i;

wire axis_mclk_i;
wire axis_mresetn_i;

wire axis_sready_o;
wire mem_we_o;  
wire mem_re_o;  
wire fifo_empty_o; 
wire fifo_full_o; 
wire [1:0] read_cycle_o; 
wire [3:0] write_cycle_o;

// -- for multicycle path constraint
wire [18:0]                       pixcnt_c_o;
wire [15:0]                       pix_out_cntr_o;
wire [15:0]                       wc_pix_sync_o;



reg                               reset_byte_n_i;
reg                               clk_byte_i;
wire                              sp_en_i;
wire                              sp2_en_i;
wire [1:0]                        vc_i;
wire [1:0]                        vc2_i;
wire [5:0]                        dt_i;
wire [5:0]                        dt2_i;
wire                              lp_av_en_i;
wire                              lp2_av_en_i;
wire                              payload_en_i;
wire [NUM_RX_LANE*RX_GEAR-1:0]    payload_i;
wire [15:0]                       wc_i;
wire [15:0]                       wc2_i;
wire [7:0]                        ecc_i;
wire [7:0]                        ecc2_i;
wire                              sp_i;
wire                              lp_i;
wire                              sp2_i;
wire                              lp2_i;

//              PIXEL Side         
reg                               reset_pixel_n_i;
reg                               clk_pixel_i;
wire                              vsync_o;
wire                              hsync_o;
wire                              fv_o;
wire                              lv_o;
wire                              de_o;
wire [PD_BUS_WIDTH*NUM_TX_CH-1:0] pd_o;
wire [1:0]                        p_odd_o;

wire vsync_i;      
wire hsync_i;      
wire de_i;         
wire frame_valid_i;
wire line_valid_i; 

integer i=1;
integer frame_cnt = 0, line_cnt = 0, pixel_cnt = 0;
integer filedesc1;
integer filedesc;
integer error_count;
reg error_en;
reg error_cnt = 0;
reg enable_write_log =1;
reg start_video = 0;
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] log_out [exp_pixel_count:1];
reg [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] log_in  [exp_pixel_count:1];
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
///

PUR
PUR_INST_BYTE(
         reset_byte_n_i
        );

PUR
PUR_INST_PIXEL(
         reset_pixel_n_i 
        );

    initial begin
        clk_pixel_i = 1;
        forever begin
            #(PIXCLK_PERIOD/2) clk_pixel_i= ~clk_pixel_i;
        end
    end
    
    initial begin
        clk_byte_i = 0;
        forever begin
            #(BYTECLK_PERIOD/2) clk_byte_i = ~clk_byte_i;
        end
    end
// RESET LOGIC
    initial begin
        reset_byte_n_i = 1;
        reset_pixel_n_i = 1;
        repeat(3) @(posedge clk_byte_i)
        reset_byte_n_i = 0 ;
        reset_pixel_n_i = 0;
        repeat(4) @(posedge clk_pixel_i)
        reset_byte_n_i = 1 ;
        reset_pixel_n_i = 1;
    end
 

`include "dut_inst.v"

generate 
    if(AXI_SLAVE == "ON") begin : AXI_MASTER_byte_driver_ON  
        assign axis_sclk_i        = clk_byte_i;
        assign axis_sresetn_i     = reset_byte_n_i;
        
        if (RX_GEAR*NUM_RX_LANE < 64) begin
            assign axis_svalid_i = payload_en_i | sp_en_i;
            assign axis_sdata_i  = {payload_i, wc_i, dt_i};
        end
        else begin
            assign axis_svalid_i = payload_en_i | sp_en_i | sp2_en_i;
            assign axis_sdata_i  = {wc2_i, dt2_i, payload_i, wc_i, dt_i};
        end
    end
endgenerate

            byte_driver #(
                               .DATA_TYPE (DT),
                               .RX_TYPE (RX_TYPE), 
                               .DSI_MODE (DSI_MODE),
                               .GEAR (RX_GEAR),
                               .RX_CH (NUM_RX_LANE),
                               .POLARITY (POLARITY),
                               .PD_BUS_WIDTH (PD_BUS_WIDTH),
                               .NUM_TX_CH (NUM_TX_CH),
                               .NUM_OF_BYTES (NUM_OF_BYTES),
                               .NUM_LINES (NUM_LINES),
                               .SP_LP2_ENABLE (SP_LP2_ENABLE),
                               .SP2_LP_ENABLE (SP2_LP_ENABLE),
                               .NUM_FRAMES (NUM_FRAMES)
                      )
             
            byte_driver (
                               .enable_write_log    (enable_write_log),
                               .hsync_i             (hsync_o),
                               .clk                 (clk_byte_i),
                               .reset               (~reset_byte_n_i),
                               .vid_cntl_tgen_active(start_video),
                               .sp_o                (sp_en_i),
                               .lp_o                (lp_av_en_i),
                               .dt_o                (dt_i),
                               .wc_o                (wc_i),
                               .sp2_o               (sp2_en_i),
                               .lp2_o               (lp2_av_en_i),
                               .dt2_o               (dt2_i),
                               .wc2_o               (wc2_i),
                               .payload_en          (payload_en_i),
                               .byte_data           (payload_i)
                             );
             
             
            pixel_monitor #(
                            .RX_TYPE (RX_TYPE), 
                            .PD_BUS_WIDTH(PD_BUS_WIDTH),
                            .NUM_TX_CH (NUM_TX_CH),
                            .NUM_PIXELS(NUM_PIXELS)
                        )
            pixel_monitor (
                            .enable_write_log (enable_write_log),
                            .clk_pixel_i      (clk_pixel_i),
                            .reset_pixel_n_i  (reset_pixel_n_i),
                            .vsync_i          (vsync_i),
                            .hsync_i          (hsync_i),
                            .de_i             (de_i),
                            .frame_valid_i    (frame_valid_i),
                            .line_valid_i     (line_valid_i),
                            .pixel_data_i     (pd_o),
                            .p_odd_i          (p_odd_o)
                             );
    
generate
    if(CTRL_POL == "POSITIVE") begin: PM_positive
        assign vsync_i       = vsync_o;
        assign hsync_i       = hsync_o;
        assign de_i          = de_o;                   
        assign frame_valid_i = fv_o;
        assign line_valid_i  = lv_o;

    end                      
    else begin: PM_negative                       
        assign vsync_i       = ~vsync_o;
        assign hsync_i       = ~hsync_o;
        assign frame_valid_i = ~fv_o;
        if(AXI_MASTER == "ON") begin   
 	        assign de_i         = de_o;                   
            assign line_valid_i = lv_o;
        end
	    else begin
 	        assign de_i         = ~de_o;                   
            assign line_valid_i = ~lv_o;
        end
    end
endgenerate 

generate
    if(AXI_MASTER == "ON") begin : AXI_SLAVE_pixel_monitor_ON   
        assign axis_mclk_i    = clk_pixel_i;
        assign axis_mresetn_i = reset_pixel_n_i;
                
        assign axis_mready_i   = 1'b1;
        assign lv_o            = axis_mvalid_o;
        assign de_o            = axis_mvalid_o;
        assign p_odd_o         = axis_mdata_o[PD_BUS_WIDTH*NUM_TX_CH+1:PD_BUS_WIDTH*NUM_TX_CH];
        assign pd_o            = axis_mdata_o[PD_BUS_WIDTH*NUM_TX_CH-1:0];
    end
	else begin
	    initial begin
          csi_default_val_check;
          dsi_default_val_check;
		end 
	end	
endgenerate

 //add reset tests
reg [4:0] wait_cycles;
`include "tb_include/test_dsi_reset.vh"
`include "tb_include/test_csi2_reset.vh"

`ifdef DSI_RESET_DE
    initial begin
        dsi_reset_de; //call the task
    end
`elsif DSI_RESET_HSYNC
    initial begin
        dsi_reset_hsync; //call the task
    end
`elsif DSI_RESET_VSYNC
    initial begin
        dsi_reset_vsync; //call the task
    end
`elsif DSI_RESET_DE_NEG
    initial begin
        dsi_reset_de_neg; //call the task
    end
`elsif DSI_RESET_HSYNC_NEG
    initial begin
        dsi_reset_hsync_neg; //call the task
    end
`elsif DSI_RESET_VSYNC_NEG
    initial begin
        dsi_reset_vsync_neg; //call the task
    end
`elsif CSI2_RESET_FV
    initial begin
        csi_reset_fv ;
    end
`elsif CSI2_RESET_LV
    initial begin
        csi_reset_lv ;
    end
`else
    initial begin
        start_video = 1;
    end

    initial begin
        if(enable_write_log == 1) begin
            filedesc  = $fopen("expected_data.log","w");
//            $fwrite(filedesc, "%h\n", "");
            $fclose(filedesc);

            filedesc1 = $fopen("received_data.log","w");
//            $fwrite(filedesc1, "%h\n", "");
            $fclose(filedesc1);
        end
    end

    initial begin
        @(posedge reset_pixel_n_i) 
        $display("..... Transmitting Data .....");
        if (RX_TYPE == "DSI") begin
            repeat(NUM_FRAMES+1) @(posedge vsync_i);
//            if(CTRL_POL == "NEGATIVE")
//                repeat(NUM_FRAMES+1) @(negedge vsync_o);
//            else
//                repeat(NUM_FRAMES+1) @(posedge vsync_o);
           
            #100;
        end 
        else begin
             repeat(NUM_FRAMES) @(negedge frame_valid_i);
            #100;
        end                 
  
        $display("..... Transmit DONE! .....");

        actual_pixel_counter = pixel_monitor.actual_pixel_count;

//        actual_pixel_counter = PM_positive.pixel_monitor.actual_pixel_count;
//    if(CTRL_POL == "POSITIVE") begin 
//        actual_pixel_counter = PM_positive.pixel_monitor.actual_pixel_count;
//    end
//	else begin
//        actual_pixel_counter = PM_negative.pixel_monitor.actual_pixel_count;
//	end	

        if ( exp_pixel_count!= actual_pixel_counter) begin 
            $display("---------------------------------------------");
            $display("*** E R R O R: Actual and Expected pixel counts are not equal***");
            $display("**** I N F O : Actual Pixel Count is %0d", actual_pixel_counter);
            $display("**** I N F O : Expected Pixel Count is %0d", exp_pixel_count);
            $display("---------------------------------------------");
            $display("********** SIMULATION FAILED **********");
            $display("---------------------------------------------");
            $finish;
        end
        else begin
            $readmemh("expected_data.log", log_in);
            $readmemh("received_data.log", log_out);

            if (log_in[1] === {(PD_BUS_WIDTH*NUM_TX_CH){1'bx}}) begin
                $display("---------------------------------------------");
                $display("---------------------------------------------");
                $display("##### received_data.log FILE IS EMPTY ##### ");
                $display("---------------------------------------------");
                $display("---------------------------------------------");
                $finish;
            end
            else begin
                $display("---------------------------------------------");
                $display("---------------------------------------------");
                $display("##### DATA COMPARING IS STARTED ##### ");
                $display("---------------------------------------------");
                $display("---------------------------------------------");
            end
            i = 1;
//          error_en = 0;
            error_count = 0;
            repeat (actual_pixel_counter) begin
                if (log_in[i] !== log_out[i]) begin
                    $display("%0dns ERROR : Expected and Received datas are not matching. Line%0d",$time, i);
                    $display("       Expected  %h", log_in  [i]);
                    $display("       Received  %h", log_out [i]);
//                  error_en = 1;
                    error_count = error_count + 1;
                end  
                i = i+1;
            end
            
                if (error_count > 0) begin
                    $display("---------------------------------------------");
                    $display("**** I N F O : Actual Pixel Count is %0d", actual_pixel_counter);
                    $display("**** I N F O : Expected Pixel Count is %0d", exp_pixel_count);
                    $display("**** I N F O : Error Count is %0d", error_count);
                    $display("---------------------------------------------");
                    $display("**** I N F O : NUM_FRAMES=%0d, NUM_LINES=%0d, Word Count=%0d", NUM_FRAMES, NUM_LINES, NUM_OF_BYTES);
                    $display("---------------------------------------------");
                    $display("-----------------------------------------------------");
                    $display("!!!!!!!!!!!!!!!!! SIMULATION FAILED !!!!!!!!!!!!!!!!!");
                    $display("-----------------------------------------------------");
                end
                else begin
                    $display("---------------------------------------------");
                    $display("**** I N F O : Pixel Count is %0d", actual_pixel_counter);
                    $display("**** I N F O : NUM_FRAMES=%0d, NUM_LINES=%0d, Word Count=%0d", NUM_FRAMES, NUM_LINES, NUM_OF_BYTES);
                    $display("---------------------------------------------");
                    $display("-----------------------------------------------------");
                    $display("----------------- SIMULATION PASSED -----------------");
                    $display("-----------------------------------------------------");
                end
                $finish;
            end
        end 
`endif

    initial begin
        forever begin
            @(posedge reset_byte_n_i);
            #1;
            if( |p_odd_o === 1'bx || |p_odd_o === 1'bz) begin
                $display("ERROR p_odd_o signal is x/z");
                //#1000 $finish;
            end
        end
    end
endmodule
