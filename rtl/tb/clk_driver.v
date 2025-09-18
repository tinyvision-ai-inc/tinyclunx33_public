module clk_driver (
	input ref_clk_i,
	input lp11,
	input lp01,
	input lp00,
	input hs0,
	input hs,
	output clk_p,
	output clk_n
);

///// updated 20191217 MT

wire clk_p_lp11 = 1'b1;
wire clk_n_lp11 = 1'b1;

wire clk_p_lp01 = 1'b0;
wire clk_n_lp01 = 1'b1;

wire clk_p_lp00 = 1'b0;
wire clk_n_lp00 = 1'b0;

wire clk_p_hs0, clk_n_hs0;
wire clk_p_hs, clk_n_hs;

bufif1 (pull0, pull1) hs0_p (clk_p_hs0, 0, hs0);
bufif1 (pull0, pull1) hs0_n (clk_n_hs0, 1, hs0);

bufif1 (pull0, pull1) hs_p (clk_p_hs, ref_clk_i, hs);
bufif1 (pull0, pull1) hs_n (clk_n_hs, ~ref_clk_i, hs);

assign clk_p = lp11 ? clk_p_lp11 :
				lp01 ? clk_p_lp01 :
				lp00 ? clk_p_lp00 :
				hs0 ? clk_p_hs0 :
				hs ? clk_p_hs : 1'bz;

assign clk_n = lp11 ? clk_n_lp11 :
				lp01 ? clk_n_lp01 :
				lp00 ? clk_n_lp00 :
				hs0 ? clk_n_hs0 :
				hs ? clk_n_hs : 1'bz;

endmodule
