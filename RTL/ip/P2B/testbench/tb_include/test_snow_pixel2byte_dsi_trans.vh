// =========================================================================
// Filename: test_snow_pixel2byte_dsi_trans.v
// Copyright(c) 2017 Lattice Semiconductor Corporation. All rights reserved.
// =========================================================================

// `ifdef DSI_TEST1
`ifndef TEST_SNOW_PIXEL2BYTE_DSI_TRANS
`define TEST_SNOW_PIXEL2BYTE_DSI_TRANS

task test_snow_pixel2byte_dsi_trans;
   begin

      fork

`ifdef MISC_ON
      while((frame_cnt !== num_frames)) begin
      
          @(vsync_start or vsync_end or hsync_start or hsync_end or byte_data or data_type or frame_cnt);
          #1;
      
          if(frame_cnt == num_frames) begin
              $display($time, " TEST DONE ", data_type);
          end
          else
          begin
      
              if(vsync_start) begin
                  if(data_type !== 6'h01) begin
                      $display($time, " ERROR : data_type_o not matched for vsync_start : %h ", data_type);
                      testfail_cnt = testfail_cnt+1;
                  end
              end
              else
              if(vsync_end) begin
                  if(data_type !== 6'h11) begin
                     $display($time, " ERROR : data_type_o not matched for vsync_end : %h ", data_type);
                     testfail_cnt = testfail_cnt+1;
                  end
              end
              else
              //if(hsync_start) begin
              if((hsync_start) | (data_type == 6'h02))  begin
                  //if(data_type !== 6'h02)) begin
                  //    $display($time, " ERROR : data_type_o not matched for hsync_start : %h ", data_type);
                  //    testfail_cnt = testfail_cnt+1;
                  //end
              end
              else
              if((hsync_end) | (data_type == 6'h02)) begin
                  //if(data_type !== 6'h03)) begin
                  //    $display($time, " ERROR : data_type_o not matched for hsync_end : %h ", data_type);
                  //    testfail_cnt = testfail_cnt+1;
                  //end
              end
              else
              `ifdef RGB666
              if(data_type !== 6'h1E) begin
              `elsif RGB888
              if(data_type !== 6'h3E) begin
              `endif
                  $display($time, " ERROR : data_type_o not matched for respective data_type : %h ", data_type);
                  testfail_cnt = testfail_cnt+1;
              end
          end
      end
`endif
      //Stop test after Frame count reached to NumFrames
      $display($time, " Num Frames: %d", num_frames);
      while((frame_cnt !== num_frames)) begin
        @(posedge  eof);
        #1;
        if(eof) begin
          frame_cnt = frame_cnt+1;
        end
      end

      join
   end

endtask

`endif
// `endif
