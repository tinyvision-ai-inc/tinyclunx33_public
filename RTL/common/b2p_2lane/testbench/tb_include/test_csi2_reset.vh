// =========================================================================
// Filename: test_csi2_reset.v
// Copyright(c) 2017 Lattice Semiconductor Corporation. All rights reserved.
// =========================================================================
`ifndef TEST_CSI2_RESET
`define TEST_CSI2_RESET

//initial begin
//   csi_default_val_check;
//end

task csi_default_val_check();
begin
  forever begin
    @(posedge reset_byte_n_i);
  
    if (CTRL_POL == "NEGATIVE") begin
        //check default value of output
        if(fv_o != 1) begin $display("ERROR : fv_o not in default value after reset!"); end
        if(lv_o != 1) begin $display("ERROR : lv_o not in default value after reset!"); end
        if(p_odd_o != 0) begin $display("ERROR : p_odd_o not in default value after reset!"); end
        if(pd_o != 0) begin $display("ERROR : pd_o not in default value after reset!"); end
    end 
    else begin
        //check default value of output
        if(fv_o != 0) begin $display("ERROR : fv_o not in default value after reset!"); end
        if(lv_o != 0) begin $display("ERROR : lv_o not in default value after reset!"); end
        if(p_odd_o != 0) begin $display("ERROR : p_odd_o not in default value after reset!"); end
        if(pd_o != 0) begin $display("ERROR : pd_o not in default value after reset!"); end
    end
  end
end
endtask


task csi_assert_reset();
begin
  reset_byte_n_i = 1;
  reset_pixel_n_i = 1;
  repeat(3) @(posedge clk_byte_i);
    reset_byte_n_i = 0 ;
    reset_pixel_n_i = 0;
  repeat(4) @(posedge clk_pixel_i);
    reset_byte_n_i = 1 ;
    reset_pixel_n_i = 1;
  $display("%0t Reset on DE is DONE!\n",$realtime);
  wait_cycles = $random;
  repeat(wait_cycles) @(posedge clk_pixel_i);
end
endtask

task csi_enable_transmission();
begin
  enable_write_log=1;
  start_video = 1;
  $display("%0t Transmitting video after reset...\n",$realtime);
  repeat(NUM_FRAMES+1) @(negedge fv_o);
  $display("%0t Transmit DONE!\n",$realtime);
  #100;
  $finish;
end
endtask

task csi_reset_fv();
begin
  start_video=1;
  enable_write_log=0;
  repeat(2)@(posedge fv_o);
  $display("%0t FV asserted! Performing reset on FV after some cycles...\n",$realtime);
  wait_cycles = $random;
  repeat(wait_cycles) begin
    @(posedge clk_pixel_i);
  end
  csi_assert_reset;
  csi_enable_transmission;
end
endtask

task csi_reset_lv();
begin
  start_video=1;
  enable_write_log=0;
  repeat(5)@(posedge lv_o);
  $display("%0t LV asserted! Performing reset on LV after some cycles...\n",$realtime);
  wait_cycles = $random;
  repeat(wait_cycles) begin
    @(posedge clk_pixel_i);
  end
  csi_assert_reset;
  csi_enable_transmission; //enable write log here
end
endtask

`endif
