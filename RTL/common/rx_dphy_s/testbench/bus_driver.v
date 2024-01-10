//===========================================================================
// Filename: bus_driver.v
// Copyright(c) 2016 Lattice Semiconductor Corporation. All rights reserved. 
//===========================================================================
`ifndef BUS_DRIVER
`define BUS_DRIVER

`timescale 1 ps / 1 ps

module bus_driver#(
   parameter ch = 0,
   parameter dphy_clk = 2244
  )
  (
   input clk_p_i
   );
//  input clk_p_i;
  reg do_p_i, do_n_i;

integer i;

initial begin
  i = 0;
  do_p_i = 1;
  do_n_i = 1;
end


task drive_datax(input [7:0] data);
begin
   $display("%t Data[%0d] : Driving with data = %0x\n", $time, ch, data);
   for (i = 0; i < 8; i = i + 1) begin
      @(clk_p_i);
      #(dphy_clk/4);
      do_p_i = data[i];
      do_n_i = ~data[i];     
   end
end
endtask

task drv_dat_st(input dp, input dn);
begin
   do_p_i = dp;
   do_n_i = dn;
end
endtask

task drv_trail;
begin
   $display("%t Data[%0d] : Driving trail bytes", $time, ch);
   @(clk_p_i);
   #(dphy_clk/4);
   do_p_i = ~do_p_i;
   do_n_i = ~do_n_i;
end
endtask

task drv_stop;
begin
   $display("%t Data[%0d] : Driving stop", $time, ch);
   @(clk_p_i);
   #(dphy_clk/4);
   do_p_i = 1;
   do_n_i = 1;
end
endtask

endmodule
`endif
