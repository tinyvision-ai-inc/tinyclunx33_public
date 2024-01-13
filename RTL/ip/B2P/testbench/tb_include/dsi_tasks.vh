// =========================================================================
// Filename: dsi_tasks.v
// Copyright(c) 2017 Lattice Semiconductor Corporation. All rights reserved.
// =========================================================================
`ifndef DSI_TASKS
`define DSI_TASKS

`include "tb_params.vh"

task gen_dsi_ycbcr422_16_pixel_data(input [15:0] count);
begin
               $display("remaining bytes to  transfer: %d   count in this transfer: %d", rem_byte_cnt,count );
                gen_byte(count);
               if (count > 0) begin
                 pix_data_0_buf = {b[0],b[1]};
                 write_to_file("expected_data.log", pix_data_0_buf);
               end	
               if (count > 1) begin
                 pix_data_1_buf = {b[2],b[3]};
                 write_to_file("expected_data.log", pix_data_1_buf);
               end	
               if (count > 2) begin
                 pix_data_2_buf = {b[4],b[5]};
                 write_to_file("expected_data.log", pix_data_2_buf);
               end	
               if (count > 3) begin
                 pix_data_3_buf = {b[6],b[7]};
                 write_to_file("expected_data.log", pix_data_3_buf);
               end	
               if (count > 4) begin
                 pix_data_4_buf = {b[8],b[9]};
                 write_to_file("expected_data.log", pix_data_4_buf);
               end	
               if (count > 5) begin
                 pix_data_5_buf = {b[10],b[11]};
                 write_to_file("expected_data.log", pix_data_5_buf);
               end	
               if (count > 6) begin
                 pix_data_6_buf = {b[12],b[13]};
                 write_to_file("expected_data.log", pix_data_6_buf);
               end	
               if (count > 7) begin
                 pix_data_7_buf = {b[14],b[15]};
                 write_to_file("expected_data.log", pix_data_7_buf);
               end	

                drive_dsi_byte_data(count);
end
endtask

task gen_dsi_ycbcr422_20_pixel_data(input [15:0] count);
begin
               $display("remaining bytes to  transfer: %d   count in this transfer: %d", rem_byte_cnt,count );
                gen_byte(count);
               if (count > 0) begin
                 pix_data_0_buf = {b[1][3:0],b[0][7:2],b[2],b[1][7:6]};
                 write_to_file("expected_data.log", pix_data_0_buf);
               end	
               if (count > 1) begin
			    //was: pix_data_1_buf = {b[ 7][3:0],b[6][7:2],b[ 8],b[ 7][7:6]};
                 pix_data_1_buf = {b[ 4][3:0],b[ 3][7:2],b[ 5],b[ 4][7:6]};	 
                 write_to_file("expected_data.log", pix_data_1_buf);
               end	
               if (count > 2) begin
                 pix_data_2_buf = {b[ 7][3:0],b[6][7:2],b[ 8],b[ 7][7:6]};
                 write_to_file("expected_data.log", pix_data_2_buf);
               end	
               if (count > 3) begin
                 pix_data_3_buf = {b[10][3:0],b[9][7:2],b[11],b[10][7:6]};
                 write_to_file("expected_data.log", pix_data_3_buf);
               end	
               if (count > 4) begin
                 pix_data_4_buf = {b[13][3:0],b[12][7:2],b[14],b[13][7:6]};
                 write_to_file("expected_data.log", pix_data_4_buf);
               end	
               if (count > 5) begin
                 pix_data_5_buf = {b[16][3:0],b[15][7:2],b[17],b[16][7:6]};
                 write_to_file("expected_data.log", pix_data_5_buf);
               end	
               if (count > 6) begin
                 pix_data_6_buf = {b[19][3:0],b[18][7:2],b[20],b[19][7:6]};
                 write_to_file("expected_data.log", pix_data_6_buf);
               end	
               if (count > 7) begin
                 pix_data_7_buf = {b[22][3:0],b[21][7:2],b[23],b[22][7:6]};
                 write_to_file("expected_data.log", pix_data_7_buf);
               end	

                drive_dsi_byte_data(count);
end
endtask

task gen_dsi_ycbcr422_24_pixel_data(input [15:0] count);
begin
               $display("remaining bytes to  transfer: %d   count in this transfer: %d", rem_byte_cnt,count );
                gen_byte(count);
               if (count > 0) begin
                 pix_data_0_buf = {b[1][3:0],b[0],b[2],b[1][7:4]};
                 write_to_file("expected_data.log", pix_data_0_buf);
               end	
               if (count > 1) begin
                 pix_data_1_buf = {b[4][3:0],b[3],b[5],b[4][7:4]};
                 write_to_file("expected_data.log", pix_data_1_buf);
               end	
               if (count > 2) begin
                 pix_data_2_buf = {b[7][3:0],b[6],b[8],b[7][7:4]};
                 write_to_file("expected_data.log", pix_data_2_buf);
               end	
               if (count > 3) begin
                 pix_data_3_buf = {b[10][3:0],b[9],b[11],b[10][7:4]};
                 write_to_file("expected_data.log", pix_data_3_buf);
               end	
               if (count > 4) begin
                 pix_data_4_buf = {b[13][3:0],b[12],b[14],b[13][7:4]};
                 write_to_file("expected_data.log", pix_data_4_buf);
               end	
               if (count > 5) begin
                 pix_data_5_buf = {b[16][3:0],b[15],b[17],b[16][7:4]};
                 write_to_file("expected_data.log", pix_data_5_buf);
               end	
               if (count > 6) begin
                 pix_data_6_buf = {b[19][3:0],b[18],b[20],b[19][7:4]};
                 write_to_file("expected_data.log", pix_data_6_buf);
               end	
               if (count > 7) begin
                 pix_data_7_buf = {b[22][3:0],b[21],b[23],b[22][7:4]};
                 write_to_file("expected_data.log", pix_data_7_buf);
               end	

                drive_dsi_byte_data(count);
end
endtask

task gen_dsi_rgb565_pixel_data(input [15:0] count); 
  begin
               $display("remaining bytes to  transfer: %d   count in this transfer: %d", rem_byte_cnt,count );
                gen_byte(count); // (RX_CH*GEAR/8);
				
               if (count > 0) begin
                 pix_data_0_buf = {b[0][4:0],b[1][2:0],b[0][7:5],b[1][7:3]};
                 write_to_file("expected_data.log", pix_data_0_buf);
               end				
				
               if (count > 1) begin
                  pix_data_1_buf = {b[2][4:0],b[3][2:0],b[2][7:5],b[3][7:3]};
                  write_to_file("expected_data.log", pix_data_1_buf);
               end					
            
               if (count > 2) begin
                  pix_data_2_buf = {b[4][4:0],b[5][2:0],b[4][7:5],b[5][7:3]};
                  write_to_file("expected_data.log", pix_data_2_buf);
               end
			   
               if (count > 3) begin
                  pix_data_3_buf = {b[6][4:0],b[7][2:0],b[6][7:5],b[7][7:3]};
                  write_to_file("expected_data.log", pix_data_3_buf);
               end		

               if (count > 4) begin
                    pix_data_4_buf = {b[ 8][4:0],b[ 9][2:0],b[ 8][7:5],b[ 9][7:3]};
                  write_to_file("expected_data.log", pix_data_4_buf);
               end	
			   
               if (count > 5) begin
                  pix_data_5_buf = {b[10][4:0],b[11][2:0],b[10][7:5],b[11][7:3]};
                  write_to_file("expected_data.log", pix_data_5_buf);
               end	
			   
               if (count > 6) begin
                    pix_data_6_buf = {b[12][4:0],b[13][2:0],b[12][7:5],b[13][7:3]};
                  write_to_file("expected_data.log", pix_data_6_buf);
               end			   
			   
               if (count > 7) begin
                    pix_data_7_buf = {b[14][4:0],b[15][2:0],b[14][7:5],b[15][7:3]};
                  write_to_file("expected_data.log", pix_data_7_buf);
               end				      
			  
                drive_dsi_byte_data(count); // (RX_CH*GEAR/8);
  end
endtask

task gen_dsi_rgb888_pixel_data(input [15:0] count);
begin
  $display("bytes transferred in this task call: %d", count );
                gen_byte(count);  //RX_CH*GEAR/8

               if (count > 0) begin
                 pix_data_0_buf  = {b[0],b[1],b[2]};
                 write_to_file("expected_data.log", pix_data_0_buf);
               end
			   
               if (count > 1) begin
                 pix_data_1_buf  = {b[3],b[4],b[5]};
                 write_to_file("expected_data.log", pix_data_1_buf);
               end

               if (count > 2) begin
                 pix_data_2_buf  = {b[6],b[7],b[8]};
                 write_to_file("expected_data.log", pix_data_2_buf);
               end
               if (count > 3) begin
                 pix_data_3_buf  = {b[9],b[10],b[11]};
                 write_to_file("expected_data.log", pix_data_3_buf);
               end
               if (count > 4) begin
                 pix_data_4_buf  = {b[12],b[13],b[14]};
                 write_to_file("expected_data.log", pix_data_4_buf);
               end
               if (count > 5) begin
                 pix_data_5_buf  = {b[15],b[16],b[17]};
                 write_to_file("expected_data.log", pix_data_5_buf);
               end
               if (count > 6) begin
                 pix_data_6_buf  = {b[18],b[19],b[20]};
                 write_to_file("expected_data.log", pix_data_6_buf);
               end
               if (count > 7) begin
                 pix_data_7_buf  = {b[21],b[22],b[23]};
                 write_to_file("expected_data.log", pix_data_7_buf);
               end
 
                drive_dsi_byte_data(count);
end
endtask


task gen_dsi_rgb666_lp_pixel_data(input [15:0] count);
  begin
                $display("remaining bytes for transfer: %d", rem_byte_cnt );
                gen_byte(count);  //RX_CH*GEAR/8

                if (count > 0) begin
                 pix_data_0_buf = {b[0][7:2],b[1][7:2],b[2][7:2]};
                 write_to_file("expected_data.log", pix_data_0_buf);
               end
			   
               if (count > 1) begin
                 pix_data_1_buf = {b[3][7:2],b[4][7:2],b[5][7:2]};
                 write_to_file("expected_data.log", pix_data_1_buf);
               end

               if (count > 2) begin
                 pix_data_2_buf = {b[6][7:2],b[7][7:2],b[8][7:2]};
                 write_to_file("expected_data.log", pix_data_2_buf);
               end
               if (count > 3) begin
                 pix_data_3_buf = {b[9][7:2],b[10][7:2],b[11][7:2]};
                 write_to_file("expected_data.log", pix_data_3_buf);
               end
               if (count > 4) begin
                 pix_data_4_buf = {b[12][7:2],b[13][7:2],b[14][7:2]};
                 write_to_file("expected_data.log", pix_data_4_buf);
               end
               if (count > 5) begin
                 pix_data_5_buf = {b[15][7:2],b[16][7:2],b[17][7:2]};
                 write_to_file("expected_data.log", pix_data_5_buf);
               end
               if (count > 6) begin
                 pix_data_6_buf = {b[18][7:2],b[19][7:2],b[20][7:2]};
                 write_to_file("expected_data.log", pix_data_6_buf);
               end
               if (count > 7) begin
                 pix_data_7_buf = {b[21][7:2],b[22][7:2],b[23][7:2]};
                 write_to_file("expected_data.log", pix_data_7_buf);
               end

                drive_dsi_byte_data(count);  //(RX_CH*(GEAR/8));
end
endtask

/// rgb666 num_bytes = 9 (4pixels)
task gen_dsi_rgb666_pixel_data(input [15:0] count);
begin
              gen_byte(count);  //(RX_CH*(GEAR/8));
			  
               if (count > 0) begin
                 pix_data_0_buf = {b[0][5:0],b[1][3:0],b[0][7:6],b[2][1:0],b[1][7:4]};
                 pix_data_1_buf = {b[2][7:2],b[3][5:0],b[4][3:0],b[3][7:6]};
                 pix_data_2_buf = {b[5][1:0],b[4][7:4],b[5][7:2],b[6][5:0]};
                 pix_data_3_buf = {b[7][3:0],b[6][7:6],b[8][1:0],b[7][7:4],b[8][7:2]};
                 write_to_file("expected_data.log", pix_data_0_buf);
				 write_to_file("expected_data.log", pix_data_1_buf);
				 write_to_file("expected_data.log", pix_data_2_buf);
				 write_to_file("expected_data.log", pix_data_3_buf);
               end
			   
               if (count > 1) begin
                 pix_data_4_buf = {b[9][5:0],b[10][3:0],b[9][7:6],b[11][1:0],b[10][7:4]};
                 pix_data_5_buf = {b[11][7:2],b[12][5:0],b[13][3:0],b[12][7:6]};
                 pix_data_6_buf = {b[14][1:0],b[13][7:4],b[14][7:2],b[15][5:0]};
                 pix_data_7_buf = {b[16][3:0],b[15][7:6],b[17][1:0],b[16][7:4],b[17][7:2]};
                 write_to_file("expected_data.log", pix_data_4_buf);
				 write_to_file("expected_data.log", pix_data_5_buf);
				 write_to_file("expected_data.log", pix_data_6_buf);
				 write_to_file("expected_data.log", pix_data_7_buf);
               end

               if (count > 2) begin
                 pix_data_8_buf  = {b[18][5:0],b[19][3:0],b[18][7:6],b[20][1:0],b[19][7:4]};
                 pix_data_9_buf  = {b[20][7:2],b[21][5:0],b[22][3:0],b[21][7:6]};
                 pix_data_10_buf = {b[23][1:0],b[22][7:4],b[23][7:2],b[24][5:0]};
                 pix_data_11_buf = {b[25][3:0],b[24][7:6],b[26][1:0],b[25][7:4],b[26][7:2]};
                 write_to_file("expected_data.log", pix_data_8_buf);
                 write_to_file("expected_data.log", pix_data_9_buf);
                 write_to_file("expected_data.log", pix_data_10_buf);
                 write_to_file("expected_data.log", pix_data_11_buf);
               end
               if (count > 3) begin
                 pix_data_12_buf = {b[27][5:0],b[28][3:0],b[27][7:6],b[29][1:0],b[28][7:4]};
                 pix_data_13_buf = {b[29][7:2],b[30][5:0],b[31][3:0],b[30][7:6]};
                 pix_data_14_buf = {b[32][1:0],b[31][7:4],b[32][7:2],b[33][5:0]};
                 pix_data_15_buf = {b[34][3:0],b[33][7:6],b[35][1:0],b[34][7:4],b[35][7:2]};
                 write_to_file("expected_data.log", pix_data_12_buf);
                 write_to_file("expected_data.log", pix_data_13_buf);
                 write_to_file("expected_data.log", pix_data_14_buf);
                 write_to_file("expected_data.log", pix_data_15_buf);
               end
               if (count > 4) begin
                 pix_data_16_buf = {b[36][5:0],b[37][3:0],b[36][7:6],b[38][1:0],b[37][7:4]};
                 pix_data_17_buf = {b[38][7:2],b[39][5:0],b[40][3:0],b[39][7:6]};
                 pix_data_18_buf = {b[41][1:0],b[40][7:4],b[41][7:2],b[42][5:0]};
                 pix_data_19_buf = {b[43][3:0],b[42][7:6],b[44][1:0],b[43][7:4],b[44][7:2]};
                 write_to_file("expected_data.log", pix_data_16_buf);
                 write_to_file("expected_data.log", pix_data_17_buf);
                 write_to_file("expected_data.log", pix_data_18_buf);
                 write_to_file("expected_data.log", pix_data_19_buf);
               end
               if (count > 5) begin
                 pix_data_20_buf = {b[45][5:0],b[46][3:0],b[45][7:6],b[47][1:0],b[46][7:4]};
                 pix_data_21_buf = {b[47][7:2],b[48][5:0],b[49][3:0],b[48][7:6]};
                 pix_data_22_buf = {b[50][1:0],b[49][7:4],b[50][7:2],b[51][5:0]};
                 pix_data_23_buf = {b[52][3:0],b[51][7:6],b[53][1:0],b[52][7:4],b[53][7:2]};
                 write_to_file("expected_data.log", pix_data_20_buf);
                 write_to_file("expected_data.log", pix_data_21_buf);
                 write_to_file("expected_data.log", pix_data_22_buf);
                 write_to_file("expected_data.log", pix_data_23_buf);
               end
               if (count > 6) begin
                 pix_data_24_buf = {b[54][5:0],b[55][3:0],b[54][7:6],b[56][1:0],b[55][7:4]};
                 pix_data_25_buf = {b[56][7:2],b[57][5:0],b[58][3:0],b[57][7:6]};
                 pix_data_26_buf = {b[59][1:0],b[58][7:4],b[59][7:2],b[60][5:0]};
                 pix_data_27_buf = {b[61][3:0],b[60][7:6],b[62][1:0],b[61][7:4],b[62][7:2]};
                 write_to_file("expected_data.log", pix_data_24_buf);
                 write_to_file("expected_data.log", pix_data_25_buf);
                 write_to_file("expected_data.log", pix_data_26_buf);
                 write_to_file("expected_data.log", pix_data_27_buf);
               end
               if (count > 7) begin
                 pix_data_28_buf = {b[63][5:0],b[64][3:0],b[63][7:6],b[65][1:0],b[64][7:4]};
                 pix_data_29_buf = {b[65][7:2],b[66][5:0],b[67][3:0],b[66][7:6]};
                 pix_data_30_buf = {b[68][1:0],b[67][7:4],b[68][7:2],b[69][5:0]};
                 pix_data_31_buf = {b[70][3:0],b[69][7:6],b[71][1:0],b[70][7:4],b[71][7:2]};
                 write_to_file("expected_data.log", pix_data_28_buf);
                 write_to_file("expected_data.log", pix_data_29_buf);
                 write_to_file("expected_data.log", pix_data_30_buf);
                 write_to_file("expected_data.log", pix_data_31_buf);
               end  

                drive_dsi_byte_data(count);  //(RX_CH*(GEAR/8));
end   
endtask
task drive_dsi_byte_data (input [15:0] count) ;
begin
                    //    $display("remaining bytes for transfer: %d", rem_byte_cnt );
                        if(RX_CH ==1 && GEAR == 8)begin
                          for(i=0;i<num_bytes;i=i+1)begin
                              byte_data <= b[i];
                              @(posedge clk);
                          end
                        end
                       if((RX_CH ==2 && GEAR == 8) || (RX_CH ==1 && GEAR == 16)) begin
                          for(i=0;i<num_bytes*count;i=i+2)begin
                              byte_data <= {b[i+1],b[i]};
                              @(posedge clk);
                          end
                        end
                       if((RX_CH ==4 && GEAR==8) || (RX_CH ==2 && GEAR==16)) begin
                          for(i=0;i<num_bytes*count;i=i+4)begin
                              byte_data <= {b[i+3],b[i+2],b[i+1],b[i]};
                              @(posedge clk);
                          end
                       end
                       if(RX_CH ==4 && GEAR==16) begin
                          for(i=0;i<num_bytes*count;i=i+8)begin
                              byte_data <= {b[i+7],b[i+6],b[i+5],b[i+4],b[i+3],b[i+2],b[i+1],b[i]};
                              @(posedge clk);
                          end
                       end

                   end
endtask

`endif
