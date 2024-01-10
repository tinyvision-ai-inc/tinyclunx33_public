// =========================================================================
// Filename: pixel_monitor.v
// Copyright(c) 2017 Lattice Semiconductor Corporation. All rights reserved.
// =========================================================================
`ifndef PIXEL_MONITOR
`define PIXEL_MONITOR

`include "tb_include/tb_params.vh"
`timescale 1 ns / 1 ps

module pixel_monitor #(
        parameter RX_TYPE      = "CSI-2",
        parameter PD_BUS_WIDTH = 16,
        parameter NUM_TX_CH    = 1,
        parameter NUM_PIXELS   = 1
    )
    (
      input enable_write_log,
      input clk_pixel_i,
      input reset_pixel_n_i,
      input de_i,
      input [(PD_BUS_WIDTH*NUM_TX_CH)-1:0] pixel_data_i,
      input [1:0] p_odd_i,
      input line_valid_i,
      input frame_valid_i,
      input vsync_i,
      input hsync_i
    );


reg [PD_BUS_WIDTH-1:0] data,data1,data2,data3;

generate
    if (RX_TYPE == "DSI") 
        initial dsi_data.detect_pixel_data_in_dsi;
    else
        initial csi_data.detect_pixel_data_in_csi2;
endgenerate

    always @(posedge vsync_i) begin
      write_vsync_hsync("sync_data_in.log",1);
    end
    
    always @(posedge hsync_i) begin
      #1;
      write_vsync_hsync("sync_data_in.log",0);
    end

//`ifdef RX_TYPE_DSI   
integer actual_pixel_count = 0;
generate 
if (RX_TYPE == "DSI") begin: dsi_data
    task detect_pixel_data_in_dsi;
    begin
     
        forever begin
         @(posedge clk_pixel_i);
            if(de_i ==1 && NUM_PIXELS==1) begin
                data = pixel_data_i[PD_BUS_WIDTH-1:0] ; 
                write_to_file("received_data.log", data);
                actual_pixel_count = actual_pixel_count + 1;
            end
            else if(de_i ==1 && NUM_PIXELS==2) begin
               if(NUM_TX_CH==1) begin
                data = pixel_data_i[(PD_BUS_WIDTH/2)-1:0] ; 
                data1 = pixel_data_i[PD_BUS_WIDTH-1:(PD_BUS_WIDTH/2)] ;
                write_to_file("received_data.log", data);
                if (p_odd_i == 0) begin
                  write_to_file("received_data.log", data1);
                end
                actual_pixel_count = actual_pixel_count + 2 - p_odd_i;
              end
              else if(NUM_TX_CH==2) begin
                data = pixel_data_i[PD_BUS_WIDTH-1:0] ; 
                data1 = pixel_data_i[(2*PD_BUS_WIDTH)-1:PD_BUS_WIDTH] ;
                write_to_file("received_data.log", data);
                if (p_odd_i == 0) begin
                  write_to_file("received_data.log", data1);
                end
                actual_pixel_count = actual_pixel_count + 2 - p_odd_i;
              end
            end
            else if(de_i ==1 && NUM_PIXELS==4) begin
              data   = pixel_data_i[(PD_BUS_WIDTH*NUM_TX_CH/4)-1:0] ;
              data1  = pixel_data_i[PD_BUS_WIDTH*NUM_TX_CH/2-1:PD_BUS_WIDTH*NUM_TX_CH/4] ;
              data2  = pixel_data_i[PD_BUS_WIDTH*NUM_TX_CH*3/4-1:PD_BUS_WIDTH*NUM_TX_CH/2] ;
              data3  = pixel_data_i[PD_BUS_WIDTH*NUM_TX_CH-1:PD_BUS_WIDTH*NUM_TX_CH*3/4] ;
               //p_odd: 00- all pix valid.   01- only pix0 valid
	           //       10- only pix0&1 vld  11- only pix0,1 &2 are valid
                write_to_file("received_data.log", data);
               if (p_odd_i !== 2'b01)
                  write_to_file("received_data.log", data1);
               if ((p_odd_i == 2'b00) || (p_odd_i == 2'b11))
                  write_to_file("received_data.log", data2);
               if (p_odd_i == 2'b00)
                  write_to_file("received_data.log", data3);
                actual_pixel_count = actual_pixel_count + 4 - p_odd_i;
            end
        end
    end
    endtask
end
else begin: csi_data
    task detect_pixel_data_in_csi2;
    begin
        forever begin
            @(posedge clk_pixel_i);
           
        
            if(line_valid_i ==1 && frame_valid_i==1 && NUM_PIXELS==1) begin
                data = pixel_data_i[PD_BUS_WIDTH-1:0] ; 
                write_to_file("received_data.log", data);
                actual_pixel_count = actual_pixel_count + 1;
            end
        
            else if(line_valid_i ==1 && frame_valid_i==1 && NUM_PIXELS==2) begin
              if(NUM_TX_CH==2) begin
                data = pixel_data_i[PD_BUS_WIDTH-1:0] ; 
                data1 = pixel_data_i[(2*PD_BUS_WIDTH)-1:PD_BUS_WIDTH] ; 
                write_to_file("received_data.log", data);
                if (p_odd_i == 0) begin
                  write_to_file("received_data.log", data1);
                end
                actual_pixel_count = actual_pixel_count + 2 - p_odd_i;
              end
              else if(NUM_TX_CH==1) begin
                data = pixel_data_i[(PD_BUS_WIDTH/2)-1:0] ; 
                data1 = pixel_data_i[PD_BUS_WIDTH-1:(PD_BUS_WIDTH/2)] ; 
                write_to_file("received_data.log", data);
                if (p_odd_i == 0) begin
                  write_to_file("received_data.log", data1);
                end
                actual_pixel_count = actual_pixel_count + 2 - p_odd_i;
              end
            end
            
            else if(line_valid_i ==1 && frame_valid_i==1 && NUM_PIXELS==4) begin
                data = pixel_data_i[(PD_BUS_WIDTH/2)-1:0] ; 
                data1 = pixel_data_i[PD_BUS_WIDTH-1:(PD_BUS_WIDTH/2)] ; 
                data2 = pixel_data_i[(PD_BUS_WIDTH+(PD_BUS_WIDTH/2))-1:PD_BUS_WIDTH] ; 
                data3 = pixel_data_i[(2*PD_BUS_WIDTH)-1:(PD_BUS_WIDTH+(PD_BUS_WIDTH/2))] ; 
                //p_odd: 00- all pix valid.   01- only pix0 valid
	           //        10- only pix0&1 vld  11- only pix0,1 &2 are valid
                write_to_file("received_data.log", data);
                if (p_odd_i !== 2'b01)
                  write_to_file("received_data.log", data1);
                if ((p_odd_i == 2'b00) || (p_odd_i == 2'b11))
                  write_to_file("received_data.log", data2);
                if (p_odd_i == 2'b00)
                  write_to_file("received_data.log", data3);
                actual_pixel_count = actual_pixel_count + 4 - p_odd_i; 
            end
        end
    end
    endtask
end
endgenerate

//    task write_to_file ( input [1024*4-1:0]str_in,input [(PD_BUS_WIDTH*NUM_TX_CH)-1:0]data);
task write_to_file ( input [1024*4-1:0]str_in, input [PD_BUS_WIDTH-1:0] data);
     integer filedesc;
 begin
    if(enable_write_log == 1) begin
     filedesc = $fopen(str_in,"a");
     $fwrite(filedesc, "%h\n", data);
     $fclose(filedesc);
    end
 end
endtask

task write_vsync_hsync ( input [1024*4-1:0]str_in,input vsync_i);
     integer filedesc;
   begin
   if(enable_write_log == 1) begin
     filedesc = $fopen(str_in,"a");
     if(vsync_i == 1) begin
        $fwrite(filedesc, "VSYNC\n");
     end
     else begin
        $fwrite(filedesc, "HSYNC\n");
     end
     $fclose(filedesc);
    end
   end
endtask

endmodule

`endif
