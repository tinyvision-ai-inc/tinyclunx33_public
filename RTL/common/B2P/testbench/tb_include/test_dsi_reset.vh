// =========================================================================
// Filename: test_dsi_reset.v
// Copyright(c) 2017 Lattice Semiconductor Corporation. All rights reserved.
// =========================================================================
`ifndef TEST_DSI_RESET
`define TEST_DSI_RESET

initial begin
//  dsi_default_val_check;
end

task dsi_default_val_check();
begin
  forever begin
    @(posedge reset_byte_n_i);
  if (CTRL_POL == "POSITIVE") begin
   //check default value of output
   if(vsync_o != 0) begin $display("ERROR : vsync_o not in default value after reset!"); end
   if(hsync_o != 0) begin $display("ERROR : hsync_o not in default value after reset!"); end
   if(de_o != 0) begin $display("ERROR : de_o not in default value after reset!"); end
   if(pd_o != 0) begin $display("ERROR : pd_o not in default value after reset!"); end
  end
   //check default value of output
  else begin
   if(vsync_o != 1) begin $display("ERROR : vsync_o not in default value after reset!"); end
   if(hsync_o != 1) begin $display("ERROR : hsync_o not in default value after reset!"); end
   if(de_o != 1) begin $display("ERROR : de_o not in default value after reset!"); end
   if(pd_o != 0) begin $display("ERROR : pd_o not in default value after reset!"); end
   end
  end
end
endtask


task dsi_assert_reset();
begin
  reset_byte_n_i = 1;
  reset_pixel_n_i = 1;
  repeat(3) @(posedge clk_byte_i);
    reset_byte_n_i = 0 ;
    reset_pixel_n_i = 0;
  repeat(4) @(posedge clk_pixel_i);
    reset_byte_n_i = 1 ;
    reset_pixel_n_i = 1;
  $display("%0t Reset DONE!\n",$realtime);
  wait_cycles = $random;

  repeat(wait_cycles) @(posedge clk_pixel_i);
end
endtask

task dsi_enable_transmission();
begin
  enable_write_log=1;
  start_video = 1;
  $display("%0t Transmitting video after reset...\n",$realtime);
  repeat(NUM_FRAMES+1) @(posedge vsync_o);
  $display("%0t Transmit DONE!\n",$realtime);
  #100; 
  $finish;
end
endtask

task dsi_reset_de();
begin
  start_video=1;
  enable_write_log=0;
  if (CTRL_POL == "NEGATIVE")
    @(posedge de_o);
  else
    @(negedge de_o);
  $display("%0t DE asserted! Performing reset on DE after some cycles...\n",$realtime);
  wait_cycles = $random;
  repeat(wait_cycles) begin
    @(posedge clk_pixel_i);
  end
  dsi_assert_reset;
  dsi_enable_transmission;
end
endtask

task dsi_reset_de_neg();
begin
  start_video=1;
  enable_write_log=0;
  if (CTRL_POL == "NEGATIVE")
    @(negedge de_o);
  else
    @(posedge de_o);
  $display("%0t DE asserted!\n",$realtime);
  if (CTRL_POL == "NEGATIVE")
    @(posedge de_o);
  else
    @(negedge de_o);
  $display("%0t DE negated! Performing reset while DE is negated...\n",$realtime);
  repeat(1) begin
    @(posedge clk_pixel_i);
  end
  dsi_assert_reset;
  dsi_enable_transmission;
end
endtask

task dsi_reset_hsync();
begin
  start_video=1;
  enable_write_log=0;
  if (CTRL_POL == "NEGATIVE")
    @(negedge hsync_o);
  else
    @(posedge hsync_o);
  $display("%0t HSYNC asserted! Performing reset on HSYNC...\n",$realtime);
  repeat(1) begin
    @(posedge clk_pixel_i);
  end
  dsi_assert_reset;
  dsi_enable_transmission; //enable write log here
end
endtask

task dsi_reset_vsync();
begin
  start_video=1;
  enable_write_log=0;
  if (CTRL_POL == "NEGATIVE")
    @(negedge vsync_o);
  else
    @(posedge vsync_o);
  $display("%0t VSYNC asserted! Performing reset on VSYNC...\n",$realtime);
  repeat(1) begin
    @(posedge clk_pixel_i);
  end
  dsi_assert_reset;
  dsi_enable_transmission; //enable write log here
end
endtask

task dsi_reset_hsync_neg();
begin
  start_video=1;
  enable_write_log=0;
  if (CTRL_POL == "NEGATIVE")
    @(negedge hsync_o);
  else
    @(posedge hsync_o);
  $display("%0t HSYNC asserted!\n",$realtime);
  if (CTRL_POL == "NEGATIVE")
    @(posedge hsync_o);
  else
    @(negedge hsync_o);
  $display("%0t HSYNC negated! Performing reset while HSYNC is negated\n",$realtime);
  repeat(1) begin
    @(posedge clk_pixel_i);
  end
  dsi_assert_reset;
  dsi_enable_transmission; //enable write log here
end
endtask

task dsi_reset_vsync_neg();
begin
  start_video=1;
  enable_write_log=0;
  if (CTRL_POL == "NEGATIVE")
    @(negedge vsync_o);
  else
    @(posedge vsync_o);
  $display("%0t VSYNC asserted!\n",$realtime);
  if (CTRL_POL == "NEGATIVE")
    @(posedge vsync_o);
  else
    @(negedge vsync_o);
  $display("%0t VSYNC negated! Performing while VSYNC is negated\n",$realtime);
  repeat(1) begin
    @(posedge clk_pixel_i);
  end
  dsi_assert_reset;
  dsi_enable_transmission; //enable write log here
end
endtask

`endif