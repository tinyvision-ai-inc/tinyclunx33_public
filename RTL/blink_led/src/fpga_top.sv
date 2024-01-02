/**
 * @page fpga_top
 * @brief Top level module for a led blink test
 * @param[out] gpio_b1 Signal slowly toggling between 0 and 1.
 *
 * There is no clock signal to pass, as it instanciates its own clock.
 */
module fpga_top (
  output wire gpio_b1
);
  logic clk_osc;
  int_osc u_osc (
    .hf_out_en_i (1      ),
    .hf_clk_out_o(clk_osc)
  );

  logic [27:0] counter_0, counter_2, counter_osc;

  initial begin 
    counter_osc <= '0;
  end

  always @(posedge clk_osc)
      counter_osc <= counter_osc + 'd1;

  assign gpio_b1 = clk_osc;

endmodule
