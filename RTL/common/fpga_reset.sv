/*
 * Module: fpga_reset
 * 
 * Generate a reset on boot without an external source. 
 * Uses the fact that registers in an FPGA can be initialized to zero
 * by the bitstream.
 */

module fpga_reset (
   input  wire clk      ,
   input  wire reset_n_i,
   output reg  reset_n_o
);


   logic [11:0] reset_cnt;

   `ifdef SIM
      initial reset_cnt = '1 - 'd4; // Shorter reset time during sims

   `else
      initial reset_cnt = '0;
   `endif

   wire term_count = &reset_cnt;

   always @(posedge clk or negedge reset_n_i)
      if (~reset_n_i)
         `ifdef SIM
            reset_cnt <= '1 - 'd4;
         `else
            reset_cnt <= '0;
         `endif
      else if (~term_count)
         reset_cnt <= reset_cnt + 1'b1;

   initial reset_n_o = '0;
   
// Register for better timing
   always @(posedge clk or negedge reset_n_i)
      if (~reset_n_i)
         reset_n_o <= '0;
      else
         reset_n_o <= term_count;

endmodule

