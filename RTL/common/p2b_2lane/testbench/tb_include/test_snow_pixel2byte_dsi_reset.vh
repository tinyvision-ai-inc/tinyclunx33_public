// =========================================================================
// Filename: test_snow_pixel2byte_dsi_reset.v
// Copyright(c) 2017 Lattice Semiconductor Corporation. All rights reserved.
// =========================================================================
`ifndef TEST_SNOW_PIXEL2BYTE_DSI_RESET
`define TEST_SNOW_PIXEL2BYTE_DSI_RESET

task test_snow_pixel2byte_dsi_reset;
   begin

      fork

      begin
          @(negedge reset_n);
          @(posedge reset_n);
          @(posedge byte_clk);
          @(posedge byte_clk);
          //Check for proper output values after reset
          `ifdef TX_DSI
          if(hsync_start !== 'b0) begin
              $display($time, " ERROR : hsync_start default value not correct : %h ", hsync_start);
              testfail_cnt = testfail_cnt+1;
          end
          if(hsync_end !== 'b0) begin
              $display($time, " ERROR : hsync_end default value not correct : %h ", hsync_end);
              testfail_cnt = testfail_cnt+1;
          end
          if(vsync_start !== 'b0) begin
              $display($time, " ERROR : vsync_start default value not correct : %h ", vsync_start);
              testfail_cnt = testfail_cnt+1;
          end
          if(vsync_end !== 'b0) begin
              $display($time, " ERROR : vsync_end default value not correct : %h ", vsync_end);
              testfail_cnt = testfail_cnt+1;
          end
          if(byte_en !== 'b0) begin
              $display($time, " ERROR : byte_en default value not correct : %h ", byte_en);
              testfail_cnt = testfail_cnt+1;
          end
          if(byte_data !== 'b0) begin
              $display($time, " ERROR : byte_data default value not correct : %h ", byte_data);
              testfail_cnt = testfail_cnt+1;
          end
          `ifdef TXFR_SIG
          if(txfr_req !== 'b0) begin
              $display($time, " ERROR : txfr_req default value not correct : %h ", txfr_req);
              testfail_cnt = testfail_cnt+1;
          end
          `endif
          `ifdef MISC_ON
          if(data_type === 'bx) begin
              $display($time, " ERROR : data_type default value not correct : %h ", data_type);
              testfail_cnt = testfail_cnt+1;
          end
          `endif
          `endif
          $display($time, " Output ports reset value checking done. ");
      end


      //while((frame_cnt !== num_frames)) begin

      //    @(fv_start or fv_end or lv_start or lv_end or byte_data or data_type or frame_cnt);
      //    #1;

      //    if(frame_cnt == num_frames) begin
      //        $display($time, " TEST DONE ", data_type);
      //    end
      //    else
      //    begin

      //        if(fv_start) begin
      //            if(data_type !== 6'h00) begin
      //                $display($time, " ERROR : data_type_o not matched for fv_start : %h ", data_type);
      //                testfail_cnt = testfail_cnt+1;
      //            end
      //        end
      //        else
      //        if(fv_end) begin
      //            if(data_type !== 6'h01) begin
      //               $display($time, " ERROR : data_type_o not matched for fv_end : %h ", data_type);
      //               testfail_cnt = testfail_cnt+1;
      //            end
      //        end
      //        else
      //        //if(lv_start) begin
      //        if((lv_start) | (data_type == 6'h02))  begin
      //            //if(data_type !== 6'h02)) begin
      //            //    $display($time, " ERROR : data_type_o not matched for lv_start : %h ", data_type);
      //            //    testfail_cnt = testfail_cnt+1;
      //            //end
      //        end
      //        else
      //        if((lv_end) | (data_type == 6'h02)) begin
      //            //if(data_type !== 6'h03)) begin
      //            //    $display($time, " ERROR : data_type_o not matched for lv_end : %h ", data_type);
      //            //    testfail_cnt = testfail_cnt+1;
      //            //end
      //        end
      //        else
      //        `ifdef RGB666
      //        if(data_type !== 6'h23) begin
      //        `elsif RGB888
      //        if(data_type !== 6'h24) begin
      //        `elsif RAW8
      //        if(data_type !== 6'h2A) begin
      //        `elsif RAW10
      //        if(data_type !== 6'h2B) begin
      //        `elsif RAW12
      //        if(data_type !== 6'h2C) begin
      //        `elsif YUV420_8
      //        if(data_type !== 6'h18) begin
      //        `elsif YUV420_10
      //        if(data_type !== 6'h19) begin
      //        `elsif YUV422_8
      //        if(data_type !== 6'h1E) begin
      //        `elsif YUV422_10
      //        if(data_type !== 6'h1F) begin
      //        `endif
      //            $display($time, " ERROR : data_type_o not matched for respective data_type : %h ", data_type);
      //            testfail_cnt = testfail_cnt+1;
      //        end
      //    end
      //end

      //Stop test after Frame count reached to NumFrames
      $display($time, " Num Frames: %d", num_frames);
      while((frame_cnt !== num_frames)) begin
        @(posedge  eof or negedge reset_n);
        #1;
        if(~reset_n) begin
          frame_cnt = 0;
        end
        else
        if(eof) begin
          frame_cnt = frame_cnt+1;
        end
      end

      join
   end

endtask
`endif