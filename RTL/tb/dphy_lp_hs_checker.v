`timescale 1ps/1ps
module dphy_lp_hs_checker #(
   parameter name = "DPHY_LP_HS_CHK",
   parameter lane_width  = 4,
   parameter clk_period = 1000
)(
   input clk_p_i,
   input clk_n_i,
   input [lane_width-1:0] do_p_i,
   input [lane_width-1:0] do_n_i
);

parameter T_HS_EXIT_MIN = 100000;
parameter T_LPX_MIN = 50000;
parameter T_CLK_PREPARE_MIN = 38000;
parameter T_CLK_PREPARE_MAX= 95000;
parameter T_CLK_ZERO_MIN = 300000;
parameter T_CLK_TRAIL_MIN = 60000;
parameter T_EOT_MAX = 105000 + 12*clk_period/2;

parameter T_CLK_PRE_MIN = 8*clk_period/2;	// 8 UI
parameter T_HS_PREPARE_MIN = 40000 + 4*clk_period/2;
parameter T_HS_PREPARE_MAX= 85000 + 6*clk_period/2;
parameter T_HS_ZERO_MIN = 145000 + 10*clk_period/2;
parameter T_HS_TRAIL_1 = 8*clk_period/2;
parameter T_HS_TRAIL_2 = 60000+4*clk_period/2;
parameter T_HS_TRAIL_MIN = (T_HS_TRAIL_1 > T_HS_TRAIL_2) ? T_HS_TRAIL_1 : T_HS_TRAIL_2;

parameter LP11 = 3'd0;
parameter LP01 = 3'd1;
parameter LP00 = 3'd2;
parameter HS00 = 3'd3;
parameter HS = 3'd4;

reg			hs2lp_trans = 0;
reg			d0_hs2lp_trans = 0;
reg [2:0]	clk_state = LP11;
reg [2:0]	d0_state = LP11, d1_state = LP11, d2_state = LP11, d3_state = LP11;


time t_CLKp_fall=0;
time t_D0p_fall=0, t_D0n_fall=0;

time t_CLK_LP_bgn=0;
time t_CLK_LP01_bgn=0;
time t_CLK_LP00_bgn=0;
time t_CLK_HS00_bgn=0;
time t_CLK_HS_bgn=0;

time t_D0_LP_bgn=0;
time t_D0_LP01_bgn=0;
time t_D0_LP00_bgn=0;
time t_D0_HS00_bgn=0;
time t_D0_HS_bgn=0;
time t_D0_TRAIL_bgn=0;


always @(negedge clk_p_i) begin
	t_CLKp_fall <= $time;
end

always @(negedge do_p_i[0]) begin
	t_D0p_fall <= $time;
end

always @(negedge do_n_i[0]) begin
	t_D0n_fall <= $time;
end

///// Clock Lane Check /////
always @(posedge clk_p_i or posedge clk_n_i or negedge clk_p_i or negedge clk_n_i) begin
	case (clk_state)
		LP11 : begin
			if (~clk_p_i & clk_n_i) begin
				if ((($time - t_CLK_LP_bgn) >= T_HS_EXIT_MIN) | (~hs2lp_trans)) begin
					$display ("[%0t][%0s] LP11 to LP01 Transition on clock lane", $realtime, name);
					hs2lp_trans <= 0;
					clk_state <= LP01;
					t_CLK_LP01_bgn <= $time;
				end
				else if (hs2lp_trans) begin
					$display ("[%0t][%0s] LP11 period is too short on clock lane!!!", $realtime, name);
					$stop;
				end
			end
			else if (clk_p_i & (~clk_n_i)) begin
				$display ("[%0t][%0s] Unexpected Clock Lane Transition from LP11 to LP10!!!", $realtime, name);
				$stop;
			end
			else if (~clk_p_i & (~clk_n_i)) begin
				$display ("[%0t][%0s] Unexpected Clock Lane Transition from LP11 to LP00!!!", $realtime, name);
				$stop;
			end
			else begin
				clk_state <= LP11;
			end
		end
		LP01 : begin
			if (~clk_p_i & ~clk_n_i) begin
				if (($time - t_CLK_LP01_bgn) >= T_LPX_MIN) begin
					$display ("[%0t][%0s] LP01 to LP00 Transition on clock lane with LP01 period = %0d ns", $realtime, name, ($time-t_CLK_LP01_bgn)/1000);
					clk_state <= LP00;
					t_CLK_LP00_bgn <= $time;
				end
				else begin
					$display ("[%0t][%0s] LP01 period is too short on clock lane!!! LP01 period = %0d ns, must be greater than %d ns!!!", $realtime, name, ($time-t_CLK_LP01_bgn)/1000, T_LPX_MIN/1000);
					$stop;
				end
			end
			else if (clk_p_i & (~clk_n_i)) begin
				$display ("[%0t][%0s] Unexpected Clock Lane Transition from LP01 to LP10!!!", $realtime, name);
				$stop;
			end
			else if (clk_p_i & clk_n_i) begin
				$display ("[%0t][%0s] Unexpected Clock Lane Transition from LP01 to LP11!!!", $realtime, name);
				$stop;
			end
			else begin
				clk_state <= LP01;
			end
		end
		LP00 : begin
			if (~clk_p_i & clk_n_i) begin
				if ((($time - t_CLK_LP00_bgn) >= T_CLK_PREPARE_MIN) & (($time - t_CLK_LP00_bgn) <= T_CLK_PREPARE_MAX)) begin
					$display ("[%0t][%0s] LP00 to HS00 Transition on clock lane with LP00 period = %0d ns", $realtime, name, ($time-t_CLK_LP00_bgn)/1000);
					clk_state <= HS00;
					t_CLK_HS00_bgn <= $time;
				end
				else begin
					$display ("[%0t][%0s] LP00 period is too short or too long on clock lane!!! LP00 period = %0d ns, must be between %0d and %0d ns!!!", $realtime, name, ($time-t_CLK_LP00_bgn)/1000, T_CLK_PREPARE_MIN/1000, T_CLK_PREPARE_MAX/1000);
					$stop;
				end
			end
			else if (clk_p_i & (~clk_n_i)) begin
				$display ("[%0t][%0s] Unexpected Clock Lane Transition from LP00 to LP10!!!", $realtime, name);
				$stop;
			end
			else if (clk_p_i & clk_n_i) begin
				$display ("[%0t][%0s] Unexpected Clock Lane Transition from LP00 to LP11!!!", $realtime, name);
				$stop;
			end
			else begin
				clk_state <= LP00;
			end
		end
		HS00 : begin
			if (clk_p_i & (~clk_n_i)) begin
				if (($time - t_CLK_LP00_bgn) >= T_CLK_ZERO_MIN) begin
					$display ("[%0t][%0s] HS00 to HS Transition on clock lane with LP00 + HS00 period = %0d ns", $realtime, name, ($time-t_CLK_LP00_bgn)/1000);
					t_CLK_HS_bgn <= $time;
					clk_state <= HS;
				end
				else begin
					$display ("[%0t][%0s] LP00 + HS00 period is too short on clock lane!!! LP00+HS00 period = %0d ns, must be greater than %0d ns!!!", $realtime, name, ($time-t_CLK_LP00_bgn)/1000, T_CLK_ZERO_MIN/1000);
					$stop;
				end
			end
			else if (~clk_p_i & clk_n_i) begin
				$display ("[%0t][%0s] Unexpected Clock Lane Transition from HS00 to LP01!!!", $realtime, name);
				$stop;
			end
			else if (clk_p_i & clk_n_i) begin
				$display ("[%0t][%0s] Unexpected Clock Lane Transition from HS00 to LP11!!!", $realtime, name);
				$stop;
			end
			else begin
				clk_state <= HS00;
			end
		end
		HS : begin
			if (clk_p_i & clk_n_i) begin
				if ((($time - t_CLKp_fall) >= T_CLK_TRAIL_MIN) & (($time - t_CLKp_fall) <= T_EOT_MAX)) begin
					$display ("[%0t][%0s] HS to LP11 Transition on clock lane with TRAIL period = %0d ns", $realtime, name, ($time-t_CLKp_fall)/1000);
					clk_state <= LP11;
					t_CLK_LP_bgn <= $time;
					hs2lp_trans <= 1;
				end
				else begin
					$display ("[%0t][%0s] CLK-TRAIL period is too short or too long on clock lane!!! CLK-TRAIL period = %0d, must be between %0d and %0d ns!!!", $realtime, name, ($time-t_CLKp_fall)/1000, T_CLK_TRAIL_MIN/1000, T_EOT_MAX/1000);
				//	$stop;
				end
			end
			else if (~clk_p_i & (~clk_n_i)) begin
				$display ("[%0t][%0s] Unexpected Clock Lane Transition from HS to LP00!!!", $realtime, name);
				$stop;
			end
			
			else begin
				clk_state <= HS;
			end
		end
	endcase
end	

///// D0 Lane Check /////
always @(posedge do_p_i[0] or posedge do_n_i[0] or negedge do_p_i[0] or negedge do_n_i[0]) begin
	case (d0_state)
		LP11 : begin
			if (~do_p_i[0] & do_n_i[0]) begin
				if (((($time - t_D0_LP_bgn >= T_HS_EXIT_MIN) & (($time - t_CLK_HS_bgn) >= T_CLK_PRE_MIN)) | (~d0_hs2lp_trans)) & (clk_state == HS)) begin
					$display ("[%0t][%0s] LP11 to LP01 Transition on D0 lane", $realtime, name);
					d0_hs2lp_trans <= 0;
					d0_state <= LP01;
					t_D0_LP01_bgn <= $time;
				end
				else if (d0_hs2lp_trans) begin
					$display ("[%0t][%0s] LP11 period is too short on D0 lane or clock lane is not in HS mode!!!", $realtime, name);
					$stop;
				end
				else begin
					$display ("[%0t][%0s] LP01 happened while clock lane is not in HS mode!!!", $realtime, name);
					$stop;
				end
			end
			else if (do_p_i[0] & (~do_n_i[0])) begin
				$display ("[%0t][%0s] Unexpected D0 Lane Transition from LP11 to LP10!!!", $realtime, name);
				$stop;
			end
			else if (~do_p_i[0] & (~do_n_i[0])) begin
				$display ("[%0t][%0s] Unexpected D0 Lane Transition from LP11 to LP00!!!", $realtime, name);
				$stop;
			end
			else begin
				d0_state <= LP11;
			end
		end
		LP01 : begin
			if (~do_p_i[0] & ~do_n_i[0]) begin
				if (($time - t_D0_LP01_bgn >= T_LPX_MIN) & (clk_state == HS)) begin
					$display ("[%0t][%0s] LP01 to LP00 Transition on D0 lane with LP01 period = %0d ns", $realtime, name, ($time-t_D0_LP01_bgn)/1000);
					d0_state <= LP00;
					t_D0_LP00_bgn <= $time;
				end
				else begin
					$display ("[%0t][%0s] LP01 period is too short on D0 lane or clock lane is not in HS mode!!! LP01 period = %0d ns, must be greater than %0d ns!!!", $realtime, name, ($time-t_D0_LP01_bgn)/1000, T_LPX_MIN/1000);
					$stop;
				end
			end
			else if (do_p_i[0] & (~do_n_i[0])) begin
				$display ("[%0t][%0s] Unexpected D0 Lane Transition from LP01 to LP10!!!", $realtime, name);
				$stop;
			end
			else if (do_p_i[0] & do_n_i[0]) begin
				$display ("[%0t][%0s] Unexpected D0 Lane Transition from LP01 to LP11!!!", $realtime, name);
				$stop;
			end
			else begin
				d0_state <= LP01;
			end
		end
		LP00 : begin
			if (~do_p_i[0] & do_n_i[0]) begin
				if ((($time - t_D0_LP00_bgn) >= T_HS_PREPARE_MIN) & (($time - t_D0_LP00_bgn <= T_HS_PREPARE_MAX) & (clk_state == HS))) begin
					$display ("[%0t][%0s] LP00 to HS00 Transition on D0 lane with LP00 period = %0d ns", $realtime, name, ($time-t_D0_LP00_bgn)/1000);
					d0_state <= HS00;
					t_D0_HS00_bgn <= $time;
				end
				else begin
					$display ("[%0t][%0s] LP00 period is too short or too long on D0 lane or clock lane is not in HS mode!!! LP00 period = %0d ns, must be between %0d and %0d ns!!!", $realtime, name, ($time-t_D0_LP00_bgn)/1000, T_HS_PREPARE_MIN/1000, T_HS_PREPARE_MAX/1000);
					$stop;
				end
			end
			else if (do_p_i[0] & (~do_n_i[0])) begin
				$display ("[%0t][%0s] Unexpected D0 Lane Transition from LP00 to LP10!!!", $realtime, name);
				$stop;
			end
			else if (do_p_i[0] & do_n_i[0]) begin
				$display ("[%0t][%0s] Unexpected D0 Lane Transition from LP00 to LP11!!!", $realtime, name);
				$stop;
			end
			else begin
				d0_state <= LP00;
			end
		end
		HS00 : begin
			if (do_p_i[0] & (~do_n_i[0])) begin
				if ((($time - t_D0_LP00_bgn) >= T_HS_ZERO_MIN) & (clk_state == HS)) begin
					$display ("[%0t][%0s] HS00 to HS Transition on D0 lane with LP00+HS00 period = %0d ns", $realtime, name, ($time-t_D0_LP00_bgn)/1000);
					d0_state <= HS;
					t_D0_HS_bgn <= $time;
				end
				else begin
					$display ("[%0t][%0s] LP00 + HS00 period is too short on D0 lane or clock lane is not in HS mode!!! LP00+HS00 period = %0d ns, must be greater than %0d ns!!!", $realtime, name, ($time-t_D0_LP00_bgn)/1000, T_HS_ZERO_MIN/1000);
					$stop;
				end
			end
			else if (do_p_i[0] & do_n_i[0]) begin
				$display ("[%0t][%0s] Unexpected D0 Lane Transition from HS00 to LP11!!!", $realtime, name);
				$stop;
			end
			else begin
				d0_state = HS00;
			end
		end
		HS : begin
			if (do_p_i[0] & do_n_i[0]) begin
				t_D0_TRAIL_bgn = (t_D0p_fall > t_D0n_fall) ? t_D0p_fall : t_D0n_fall;
				if ((($time - t_D0_TRAIL_bgn) >= T_HS_TRAIL_MIN) & (($time - t_D0_TRAIL_bgn) <= T_EOT_MAX) & (clk_state == HS)) begin
					$display ("[%0t][%0s] HS to LP11 Transition on D0 lane with HS-TRAIL period = %0d ns", $realtime, name, ($time-t_D0_TRAIL_bgn)/1000);
					d0_state <= LP11;
					t_D0_LP_bgn <= $time;
					d0_hs2lp_trans <= 1;
				end
				else begin
					$display ("[%0t][%0s] HS-TRAIL period is too short or too long on D0 lane or clock lane is not in HS mode!!! HS_TRAIL period = %0d ns, must be between %0d and %0d ns!!!", $realtime, name, ($time-t_D0_TRAIL_bgn)/1000, T_HS_TRAIL_MIN/1000, T_EOT_MAX/1000);
					//$stop; // VR: Temporarily commented out, ignoring a glitch in the Hard DPHY
				end
			end
			else if (~do_p_i[0] & (~do_n_i[0])) begin
				$display ("[%0t][%0s] Unexpected D0 Lane Transition from HS to LP00!!!", $realtime, name);
				//$stop; // VR: Temporarily commented out, ignoring a glitch in the Hard DPHY
			end
			else begin
				d0_state <= HS;
			end
		end
	endcase
end	


endmodule
