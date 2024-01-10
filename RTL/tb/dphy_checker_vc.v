
module dphy_checker_vc #(
   parameter name = "DPHY_CHK",
   parameter lane_width  = 4
)(
   input clk_p_i,
//   input clk_n_i,
   input [lane_width-1:0] do_p_i,
   output reg [31:0]	ch0_hs_cnt,
   output reg [31:0]	ch1_hs_cnt,
   output reg [31:0]	ch2_hs_cnt,
   output reg [31:0]	ch3_hs_cnt,
   output reg [31:0]	ch4_hs_cnt,
   output reg [31:0]	ch5_hs_cnt,
   output reg [31:0]	ch6_hs_cnt,
   output reg [31:0]	ch7_hs_cnt
//   input [3:0] do_n_i,
//   output reg dvalid,
//   output reg [(lane_width*8-1):0] data_out,
//   output reg pkt_end
);

localparam BUF_SIZE = 8192;

reg	dvalid;
reg [(lane_width*8-1):0] data_out;
reg pkt_end;

reg [12:0] ptr0, ptr1, ptr2, ptr3, ptr4, ptr5, ptr6, ptr7;
reg [7:0]	ph0_out, ph1_out, ph2_out, ph3_out;
reg [2:0]	ref_ch;

reg [7:0] data_type;
reg [15:0] word_count;
reg [7:0] data0_r ;
reg [7:0] data1_r ;
reg [7:0] data2_r ;
reg [7:0] data3_r ;
reg sync_det;
integer i, n, data_cycle, data_ctr, data_mod;
reg active_data;
reg [7:0] data0_out;
reg [7:0] data1_out;
reg [7:0] data2_out;
reg [7:0] data3_out;
reg [7:0] ecc;
reg [7:0] exp_ecc;
reg [15:0] chksum;
reg [15:0] cur_crc;
reg [15:0] crc;
reg [15:0] exp_crc;
reg short_pkt;
reg [7:0] header0;
reg [7:0] header1;
wire [(lane_width*8-1):0] data_out_w;

initial begin
   i = 0;
   data0_r = 0;
   data1_r = 0;
   data2_r = 0;
   data3_r = 0;
   data0_out = 0;
   data1_out = 0;
   data2_out = 0;
   data3_out = 0;
   sync_det = 0;
   active_data = 0;
   ptr0 = 0;
   ptr1 = 0;
   ptr2 = 0;
   ptr3 = 0;
   ptr4 = 0;
   ptr5 = 0;
   ptr6 = 0;
   ptr7 = 0;
   ch0_hs_cnt = 0;
   ch1_hs_cnt = 0;
   ch2_hs_cnt = 0;
   ch3_hs_cnt = 0;
   ch4_hs_cnt = 0;
   ch5_hs_cnt = 0;
   ch6_hs_cnt = 0;
   ch7_hs_cnt = 0;
   data_ctr = 0;
   ecc = 0;
   exp_ecc = 0;
   chksum = 16'hffff;
   cur_crc = 0;
   crc     = 0;
   exp_crc = 16'hffff;
   data_type = 0;
   word_count = 0;
   data_mod = 0;
   data_cycle = -1;
   short_pkt = 0;
   header0 = 0;
   header1 = 0;
   dvalid = 0;
   data_out = 0;
   pkt_end = 0;

   fork
      begin
        detect_sync;
      end
      begin
        collect_data;
      end
   join
end

///// Single HS transmission always stays in a single CH data, so checking the
///// 1st packet is enough to pick the exected data from the right CH

task detect_sync;
begin
   forever begin
      @ (clk_p_i);
      #1;
      data0_r = data0_r >> 1;
      data0_r[7:7] = do_p_i[0];
      data1_r = data1_r >> 1;
      data1_r[7:7] = do_p_i[1];
      data2_r = data2_r >> 1;
      data2_r[7:7] = do_p_i[2];
      data3_r = data3_r >> 1;
      data3_r[7:7] = do_p_i[3];
      
//      if (data0_r == 8'hb8) begin
      if (~active_data & (~pkt_end) & (data0_r == 8'hb8)) begin	// modified by MT
        sync_det = 1;
        active_data = 1;
      end else
      begin
        sync_det = 0;
      end
   end
end 
endtask


task channel_check (
	input [7:0] ph0, 
	input [7:0] ph1,
	input [7:0] ph2,
	input [7:0] ph3
);
begin
	$write ("Check the Packet Header to identify incoming RX channel --- ");
	if ({ph0, ph1, ph2, ph3} === {dphy_ch0.exp_data[ptr0], dphy_ch0.exp_data[(ptr0+1)%BUF_SIZE], dphy_ch0.exp_data[(ptr0+2)%BUF_SIZE], dphy_ch0.exp_data[(ptr0+3)%BUF_SIZE]}) begin
		$display ("%2h %2h %2h %2h matches CH #0 Data", ph0, ph1, ph2, ph3);
		ptr0 = (ptr0 + 4)%BUF_SIZE;
		ref_ch = 0;
		ch0_hs_cnt = ch0_hs_cnt + 1;
	end
	else if ({ph0, ph1, ph2, ph3} === {dphy_ch1.exp_data[ptr1], dphy_ch1.exp_data[(ptr1+1)%BUF_SIZE], dphy_ch1.exp_data[(ptr1+2)%BUF_SIZE], dphy_ch1.exp_data[(ptr1+3)%BUF_SIZE]}) begin
		$display ("%2h %2h %2h %2h matches CH #1 Data", ph0, ph1, ph2, ph3);
		ptr1 = (ptr1 + 4)%BUF_SIZE;
		ref_ch = 1;
		ch1_hs_cnt = ch1_hs_cnt + 1;
	end
`ifndef NUM_RX_CH_2
	else if ({ph0, ph1, ph2, ph3} === {dphy_ch2.exp_data[ptr2], dphy_ch2.exp_data[(ptr2+1)%BUF_SIZE], dphy_ch2.exp_data[(ptr2+2)%BUF_SIZE], dphy_ch2.exp_data[(ptr2+3)%BUF_SIZE]}) begin
		$display ("%2h %2h %2h %2h matches CH #2 Data", ph0, ph1, ph2, ph3);
		ptr2 = (ptr2 + 4)%BUF_SIZE;
		ref_ch = 2;
		ch2_hs_cnt = ch2_hs_cnt + 1;
	end
	`ifndef NUM_RX_CH_3
	else if ({ph0, ph1, ph2, ph3} === {dphy_ch3.exp_data[ptr3], dphy_ch3.exp_data[(ptr3+1)%BUF_SIZE], dphy_ch3.exp_data[(ptr3+2)%BUF_SIZE], dphy_ch3.exp_data[(ptr3+3)%BUF_SIZE]}) begin
		$display ("%2h %2h %2h %2h matches CH #3 Data", ph0, ph1, ph2, ph3);
		ptr3 = (ptr3 + 4)%BUF_SIZE;
		ref_ch = 3;
		ch3_hs_cnt = ch3_hs_cnt + 1;
	end
		`ifndef NUM_RX_CH_4
	else if ({ph0, ph1, ph2, ph3} === {dphy_ch4.exp_data[ptr4], dphy_ch4.exp_data[(ptr4+1)%BUF_SIZE], dphy_ch4.exp_data[(ptr4+2)%BUF_SIZE], dphy_ch4.exp_data[(ptr4+3)%BUF_SIZE]}) begin
		$display ("%2h %2h %2h %2h matches CH #4 Data", ph0, ph1, ph2, ph3);
		ptr4 = (ptr4 + 4)%BUF_SIZE;
		ref_ch = 4;
		ch4_hs_cnt = ch4_hs_cnt + 1;
	end
			`ifndef NUM_RX_CH_5
	else if ({ph0, ph1, ph2, ph3} === {dphy_ch5.exp_data[ptr5], dphy_ch5.exp_data[(ptr5+1)%BUF_SIZE], dphy_ch5.exp_data[(ptr5+2)%BUF_SIZE], dphy_ch5.exp_data[(ptr5+3)%BUF_SIZE]}) begin
		$display ("%2h %2h %2h %2h matches CH #5 Data", ph0, ph1, ph2, ph3);
		ptr5 = (ptr5 + 4)%BUF_SIZE;
		ref_ch = 5;
		ch5_hs_cnt = ch5_hs_cnt + 1;
	end
				`ifndef NUM_RX_CH_6
	else if ({ph0, ph1, ph2, ph3} === {dphy_ch6.exp_data[ptr6], dphy_ch6.exp_data[(ptr6+1)%BUF_SIZE], dphy_ch6.exp_data[(ptr6+2)%BUF_SIZE], dphy_ch6.exp_data[(ptr6+3)%BUF_SIZE]}) begin
		$display ("%2h %2h %2h %2h matches CH #6 Data", ph0, ph1, ph2, ph3);
		ptr6 = (ptr6 + 4)%BUF_SIZE;
		ref_ch = 6;
		ch6_hs_cnt = ch6_hs_cnt + 1;
	end
					`ifndef NUM_RX_CH_7
	else if ({ph0, ph1, ph2, ph3} === {dphy_ch7.exp_data[ptr7], dphy_ch7.exp_data[(ptr7+1)%BUF_SIZE], dphy_ch7.exp_data[(ptr7+2)%BUF_SIZE], dphy_ch7.exp_data[(ptr7+3)%BUF_SIZE]}) begin
		$display ("%2h %2h %2h %2h matches CH #7 Data", ph0, ph1, ph2, ph3);
		ptr7 = (ptr7 + 4)%BUF_SIZE;
		ref_ch = 7;
		ch7_hs_cnt = ch7_hs_cnt + 1;
	end
					`endif
				`endif
			`endif
		`endif
	`endif
`endif
	else begin
		$display ("%t ERROR!!! No matching Data found for this PH : %2h %2h %2h %2h", $realtime, ph0, ph1, ph2, ph3);
		$display ("(potential) Next CH 0 Data is %2h %2h %2h %2h", dphy_ch0.exp_data[ptr0], dphy_ch0.exp_data[(ptr0+1)%BUF_SIZE], dphy_ch0.exp_data[(ptr0+2)%BUF_SIZE], dphy_ch0.exp_data[(ptr0+3)%BUF_SIZE]);
		$display ("(potential) Next CH 1 Data is %2h %2h %2h %2h", dphy_ch1.exp_data[ptr1], dphy_ch1.exp_data[(ptr1+1)%BUF_SIZE], dphy_ch1.exp_data[(ptr1+2)%BUF_SIZE], dphy_ch1.exp_data[(ptr1+3)%BUF_SIZE]);
`ifndef NUM_RX_CH_2
		$display ("(potential) Next CH 2 Data is %2h %2h %2h %2h", dphy_ch2.exp_data[ptr2], dphy_ch2.exp_data[(ptr2+1)%BUF_SIZE], dphy_ch2.exp_data[(ptr2+2)%BUF_SIZE], dphy_ch2.exp_data[(ptr2+3)%BUF_SIZE]);
	`ifndef NUM_RX_CH_3
		$display ("(potential) Next CH 3 Data is %2h %2h %2h %2h", dphy_ch3.exp_data[ptr3], dphy_ch3.exp_data[(ptr3+1)%BUF_SIZE], dphy_ch3.exp_data[(ptr3+2)%BUF_SIZE], dphy_ch3.exp_data[(ptr3+3)%BUF_SIZE]);
		`ifndef NUM_RX_CH_4
		$display ("(potential) Next CH 4 Data is %2h %2h %2h %2h", dphy_ch4.exp_data[ptr4], dphy_ch4.exp_data[(ptr4+1)%BUF_SIZE], dphy_ch4.exp_data[(ptr4+2)%BUF_SIZE], dphy_ch4.exp_data[(ptr4+3)%BUF_SIZE]);
			`ifndef NUM_RX_CH_5
		$display ("(potential) Next CH 5 Data is %2h %2h %2h %2h", dphy_ch5.exp_data[ptr5], dphy_ch5.exp_data[(ptr5+1)%BUF_SIZE], dphy_ch5.exp_data[(ptr5+2)%BUF_SIZE], dphy_ch5.exp_data[(ptr5+3)%BUF_SIZE]);
				`ifndef NUM_RX_CH_6
		$display ("(potential) Next CH 6 Data is %2h %2h %2h %2h", dphy_ch6.exp_data[ptr6], dphy_ch6.exp_data[(ptr6+1)%BUF_SIZE], dphy_ch6.exp_data[(ptr6+2)%BUF_SIZE], dphy_ch6.exp_data[(ptr6+3)%BUF_SIZE]);
					`ifndef NUM_RX_CH_7
		$display ("(potential) Next CH 7 Data is %2h %2h %2h %2h", dphy_ch7.exp_data[ptr7], dphy_ch7.exp_data[(ptr7+1)%BUF_SIZE], dphy_ch7.exp_data[(ptr7+2)%BUF_SIZE], dphy_ch7.exp_data[(ptr7+3)%BUF_SIZE]);
					`endif
				`endif
			`endif
		`endif
	`endif
`endif
		#100 $stop;
	end
end
endtask

task data_check1;
begin
	case (ref_ch)
		3'd0 : begin
			if (data0_r === dphy_ch0.exp_data[ptr0]) 
				$display ("Data matches ch0 : %2h", data0_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h, expected %2h from ch0", 
					data0_r, dphy_ch0.exp_data[ptr0]); #100 $stop; end
			ptr0 = (ptr0 + 1)%BUF_SIZE;
		end
		3'd1 : begin
			if (data0_r === dphy_ch1.exp_data[ptr1]) 
				$display ("Data matches ch1 : %2h", data0_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h, expected %2h from ch1", 
					data0_r, dphy_ch1.exp_data[ptr1]); #100 $stop; end
			ptr1 = (ptr1 + 1)%BUF_SIZE;
		end
`ifndef NUM_RX_CH_2
		3'd2 : begin
			if (data0_r === dphy_ch2.exp_data[ptr2]) 
				$display ("Data matches ch2 : %2h", data0_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h, expected %2h from ch2", 
					data0_r, dphy_ch2.exp_data[ptr2]); #100 $stop; end
			ptr2 = (ptr2 + 1)%BUF_SIZE;
		end
	`ifndef NUM_RX_CH_3
		3'd3 : begin
			if (data0_r === dphy_ch3.exp_data[ptr3]) 
				$display ("Data matches ch3 : %2h", data0_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h, expected %2h from ch3", 
					data0_r, dphy_ch3.exp_data[ptr3]); #100 $stop; end
			ptr3 = (ptr3 + 1)%BUF_SIZE;
		end
		`ifndef NUM_RX_CH_4
		3'd4 : begin
			if (data0_r === dphy_ch4.exp_data[ptr4]) 
				$display ("Data matches ch4 : %2h", data0_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h, expected %2h from ch4", 
					data0_r, dphy_ch4.exp_data[ptr4]); #100 $stop; end
			ptr4 = (ptr4 + 1)%BUF_SIZE;
		end
			`ifndef NUM_RX_CH_5
		3'd5 : begin
			if (data0_r === dphy_ch5.exp_data[ptr5]) 
				$display ("Data matches ch5 : %2h", data0_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h, expected %2h from ch5", 
					data0_r, dphy_ch5.exp_data[ptr5]); #100 $stop; end
			ptr5 = (ptr5 + 1)%BUF_SIZE;
		end
				`ifndef NUM_RX_CH_6
		3'd6 : begin
			if (data0_r === dphy_ch6.exp_data[ptr6]) 
				$display ("Data matches ch6 : %2h", data0_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h, expected %2h from ch6", 
					data0_r, dphy_ch6.exp_data[ptr6]); #100 $stop; end
			ptr6 = (ptr6 + 1)%BUF_SIZE;
		end
					`ifndef NUM_RX_CH_7
		3'd7 : begin
			if (data0_r === dphy_ch7.exp_data[ptr7]) 
				$display ("Data matches ch7 : %2h", data0_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h, expected %2h from ch7", 
					data0_r, dphy_ch7.exp_data[ptr7]); #100 $stop; end
			ptr7 = (ptr7 + 1)%BUF_SIZE;
		end
					`endif
				`endif
			`endif
		`endif
	`endif
`endif
	endcase
end
endtask


task data_check2;
begin
	case (ref_ch)
		3'd0 : begin
			if ({data0_r, data1_r} === {dphy_ch0.exp_data[ptr0], dphy_ch0.exp_data[(ptr0+1)%BUF_SIZE]}) 
				$display ("Data matches ch0 : %2h %2h", data0_r, data1_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch0", 
					data0_r, data1_r, dphy_ch0.exp_data[ptr0], dphy_ch0.exp_data[(ptr0+1)%BUF_SIZE]); #100 $stop; end
			ptr0 = (ptr0 + 2)%BUF_SIZE;
		end
		3'd1 : begin
			if ({data0_r, data1_r} === {dphy_ch1.exp_data[ptr1], dphy_ch1.exp_data[(ptr1+1)%BUF_SIZE]}) 
				$display ("Data matches ch1 : %2h %2h", data0_r, data1_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch1", 
					data0_r, data1_r, dphy_ch1.exp_data[ptr1], dphy_ch1.exp_data[(ptr1+1)%BUF_SIZE]); #100 $stop; end
			ptr1 = (ptr1 + 2)%BUF_SIZE;
		end
`ifndef NUM_RX_CH_2
		3'd2 : begin
			if ({data0_r, data1_r} === {dphy_ch2.exp_data[ptr2], dphy_ch2.exp_data[(ptr2+1)%BUF_SIZE]}) 
				$display ("Data matches ch2 : %2h %2h", data0_r, data1_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch2", 
					data0_r, data1_r, dphy_ch2.exp_data[ptr2], dphy_ch2.exp_data[(ptr2+1)%BUF_SIZE]); #100 $stop; end
			ptr2 = (ptr2 + 2)%BUF_SIZE;
		end
	`ifndef NUM_RX_CH_3
		3'd3 : begin
			if ({data0_r, data1_r} === {dphy_ch3.exp_data[ptr3], dphy_ch3.exp_data[(ptr3+1)%BUF_SIZE]}) 
				$display ("Data matches ch3 : %2h %2h", data0_r, data1_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch3", 
					data0_r, data1_r, dphy_ch3.exp_data[ptr3], dphy_ch3.exp_data[(ptr3+1)%BUF_SIZE]); #100 $stop; end
			ptr3 = (ptr3 + 2)%BUF_SIZE;
		end
		`ifndef NUM_RX_CH_4
		3'd4 : begin
			if ({data0_r, data1_r} === {dphy_ch4.exp_data[ptr4], dphy_ch4.exp_data[(ptr4+1)%BUF_SIZE]}) 
				$display ("Data matches ch4 : %2h %2h", data0_r, data1_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch4", 
					data0_r, data1_r, dphy_ch4.exp_data[ptr4], dphy_ch4.exp_data[(ptr4+1)%BUF_SIZE]); #100 $stop; end
			ptr4 = (ptr4 + 2)%BUF_SIZE;
		end
			`ifndef NUM_RX_CH_5
		3'd5 : begin
			if ({data0_r, data1_r} === {dphy_ch5.exp_data[ptr5], dphy_ch5.exp_data[(ptr5+1)%BUF_SIZE]}) 
				$display ("Data matches ch5 : %2h %2h", data0_r, data1_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch5", 
					data0_r, data1_r, dphy_ch5.exp_data[ptr5], dphy_ch5.exp_data[(ptr5+1)%BUF_SIZE]); #100 $stop; end
			ptr5 = (ptr5 + 2)%BUF_SIZE;
		end
				`ifndef NUM_RX_CH_6
		3'd6 : begin
			if ({data0_r, data1_r} === {dphy_ch6.exp_data[ptr6], dphy_ch6.exp_data[(ptr6+1)%BUF_SIZE]}) 
				$display ("Data matches ch6 : %2h %2h", data0_r, data1_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch6", 
					data0_r, data1_r, dphy_ch6.exp_data[ptr6], dphy_ch6.exp_data[(ptr6+1)%BUF_SIZE]); #100 $stop; end
			ptr6 = (ptr6 + 2)%BUF_SIZE;
		end
					`ifndef NUM_RX_CH_7
		3'd7 : begin
			if ({data0_r, data1_r} === {dphy_ch7.exp_data[ptr7], dphy_ch7.exp_data[(ptr7+1)%BUF_SIZE]}) 
				$display ("Data matches ch7 : %2h %2h", data0_r, data1_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch7", 
					data0_r, data1_r, dphy_ch7.exp_data[ptr7], dphy_ch7.exp_data[(ptr7+1)%BUF_SIZE]); #100 $stop; end
			ptr7 = (ptr7 + 2)%BUF_SIZE;
		end
					`endif
				`endif
			`endif
		`endif
	`endif
`endif
	endcase
end
endtask


task data_check4;
begin
	case (ref_ch)
		3'd0 : begin
			if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch0.exp_data[ptr0], dphy_ch0.exp_data[(ptr0+1)%BUF_SIZE], dphy_ch0.exp_data[(ptr0+2)%BUF_SIZE], dphy_ch0.exp_data[(ptr0+3)%BUF_SIZE]}) 
				$display ("Data matches ch0 : %2h %2h %2h %2h", data0_r, data1_r, data2_r, data3_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch0", 
					data0_r, data1_r, data2_r, data3_r, dphy_ch0.exp_data[ptr0], dphy_ch0.exp_data[(ptr0+1)%BUF_SIZE], dphy_ch0.exp_data[(ptr0+2)%BUF_SIZE], dphy_ch0.exp_data[(ptr0+3)%BUF_SIZE]); #100 $stop; end
			ptr0 = (ptr0 + 4)%BUF_SIZE;
		end
		3'd1 : begin
			if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch1.exp_data[ptr1], dphy_ch1.exp_data[(ptr1+1)%BUF_SIZE], dphy_ch1.exp_data[(ptr1+2)%BUF_SIZE], dphy_ch1.exp_data[(ptr1+3)%BUF_SIZE]}) 
				$display ("Data matches ch1 : %2h %2h %2h %2h", data0_r, data1_r, data2_r, data3_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch1", 
					data0_r, data1_r, data2_r, data3_r, dphy_ch1.exp_data[ptr1], dphy_ch1.exp_data[(ptr1+1)%BUF_SIZE], dphy_ch1.exp_data[(ptr1+2)%BUF_SIZE], dphy_ch1.exp_data[(ptr1+3)%BUF_SIZE]); #100 $stop; end
			ptr1 = (ptr1 + 4)%BUF_SIZE;
		end
`ifndef NUM_RX_CH_2
		3'd2 : begin
			if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch2.exp_data[ptr2], dphy_ch2.exp_data[(ptr2+1)%BUF_SIZE], dphy_ch2.exp_data[(ptr2+2)%BUF_SIZE], dphy_ch2.exp_data[(ptr2+3)%BUF_SIZE]}) 
				$display ("Data matches ch2 : %2h %2h %2h %2h", data0_r, data1_r, data2_r, data3_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch2", 
					data0_r, data1_r, data2_r, data3_r, dphy_ch2.exp_data[ptr2], dphy_ch2.exp_data[(ptr2+1)%BUF_SIZE], dphy_ch2.exp_data[(ptr2+2)%BUF_SIZE], dphy_ch2.exp_data[(ptr2+3)%BUF_SIZE]); #100 $stop; end
			ptr2 = (ptr2 + 4)%BUF_SIZE;
		end
	`ifndef NUM_RX_CH_3
		3'd3 : begin
			if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch3.exp_data[ptr3], dphy_ch3.exp_data[(ptr3+1)%BUF_SIZE], dphy_ch3.exp_data[(ptr3+2)%BUF_SIZE], dphy_ch3.exp_data[(ptr3+3)%BUF_SIZE]}) 
				$display ("Data matches ch3 : %2h %2h %2h %2h", data0_r, data1_r, data2_r, data3_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch3", 
					data0_r, data1_r, data2_r, data3_r, dphy_ch3.exp_data[ptr3], dphy_ch3.exp_data[(ptr3+1)%BUF_SIZE], dphy_ch3.exp_data[(ptr3+2)%BUF_SIZE], dphy_ch3.exp_data[(ptr3+3)%BUF_SIZE]); #100 $stop; end
			ptr3 = (ptr3 + 4)%BUF_SIZE;
		end
		`ifndef NUM_RX_CH_4
		3'd4 : begin
			if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch4.exp_data[ptr4], dphy_ch4.exp_data[(ptr4+1)%BUF_SIZE], dphy_ch4.exp_data[(ptr4+2)%BUF_SIZE], dphy_ch4.exp_data[(ptr4+3)%BUF_SIZE]}) 
				$display ("Data matches ch4 : %2h %2h %2h %2h", data0_r, data1_r, data2_r, data3_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch4", 
					data0_r, data1_r, data2_r, data3_r, dphy_ch4.exp_data[ptr4], dphy_ch4.exp_data[(ptr4+1)%BUF_SIZE], dphy_ch4.exp_data[(ptr4+2)%BUF_SIZE], dphy_ch4.exp_data[(ptr4+3)%BUF_SIZE]); #100 $stop; end
			ptr4 = (ptr4 + 4)%BUF_SIZE;
		end
			`ifndef NUM_RX_CH_5
		3'd5 : begin
			if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch5.exp_data[ptr5], dphy_ch5.exp_data[(ptr5+1)%BUF_SIZE], dphy_ch5.exp_data[(ptr5+2)%BUF_SIZE], dphy_ch5.exp_data[(ptr5+3)%BUF_SIZE]}) 
				$display ("Data matches ch5 : %2h %2h %2h %2h", data0_r, data1_r, data2_r, data3_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch5", 
					data0_r, data1_r, data2_r, data3_r, dphy_ch5.exp_data[ptr5], dphy_ch5.exp_data[(ptr5+1)%BUF_SIZE], dphy_ch5.exp_data[(ptr5+2)%BUF_SIZE], dphy_ch5.exp_data[(ptr5+3)%BUF_SIZE]); #100 $stop; end
			ptr5 = (ptr5 + 4)%BUF_SIZE;
		end
				`ifndef NUM_RX_CH_6
		3'd6 : begin
			if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch6.exp_data[ptr6], dphy_ch6.exp_data[(ptr6+1)%BUF_SIZE], dphy_ch6.exp_data[(ptr6+2)%BUF_SIZE], dphy_ch6.exp_data[(ptr6+3)%BUF_SIZE]}) 
				$display ("Data matches ch6 : %2h %2h %2h %2h", data0_r, data1_r, data2_r, data3_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch6", 
					data0_r, data1_r, data2_r, data3_r, dphy_ch6.exp_data[ptr6], dphy_ch6.exp_data[(ptr6+1)%BUF_SIZE], dphy_ch6.exp_data[(ptr6+2)%BUF_SIZE], dphy_ch6.exp_data[(ptr6+3)%BUF_SIZE]); #100 $stop; end
			ptr6 = (ptr6 + 4)%BUF_SIZE;
		end
					`ifndef NUM_RX_CH_7
		3'd7 : begin
			if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch7.exp_data[ptr7], dphy_ch7.exp_data[(ptr7+1)%BUF_SIZE], dphy_ch7.exp_data[(ptr7+2)%BUF_SIZE], dphy_ch7.exp_data[(ptr7+3)%BUF_SIZE]}) 
				$display ("Data matches ch7 : %2h %2h %2h %2h", data0_r, data1_r, data2_r, data3_r);
			else begin $display ("ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch7", 
					data0_r, data1_r, data2_r, data3_r, dphy_ch7.exp_data[ptr7], dphy_ch7.exp_data[(ptr7+1)%BUF_SIZE], dphy_ch7.exp_data[(ptr7+2)%BUF_SIZE], dphy_ch7.exp_data[(ptr7+3)%BUF_SIZE]); #100 $stop; end
			ptr7 = (ptr7 + 4)%BUF_SIZE;
		end
					`endif
				`endif
			`endif
		`endif
	`endif
`endif
	endcase
end
endtask

task extra_data_check2;
begin
	if (word_count%2 == 0) begin
		case (ref_ch)
			3'd0 : begin
				if ({data0_r, data1_r} === {dphy_ch0.exp_data[ptr0], dphy_ch0.exp_data[(ptr0+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch0 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch0", $time, 
						data0_r, data1_r, dphy_ch0.exp_data[ptr0], dphy_ch0.exp_data[(ptr0+1)%BUF_SIZE]); #100 $stop; end
				ptr0 = (ptr0 + 2)%BUF_SIZE;
			end
			3'd1 : begin
				if ({data0_r, data1_r} === {dphy_ch1.exp_data[ptr1], dphy_ch1.exp_data[(ptr1+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch1 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch1", $time, 
						data0_r, data1_r, dphy_ch1.exp_data[ptr1], dphy_ch1.exp_data[(ptr1+1)%BUF_SIZE]); #100 $stop; end
				ptr1 = (ptr1 + 2)%BUF_SIZE;
			end
`ifndef NUM_RX_CH_2
			3'd2 : begin
				if ({data0_r, data1_r} === {dphy_ch2.exp_data[ptr2], dphy_ch2.exp_data[(ptr2+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch2 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch2", $time, 
						data0_r, data1_r, dphy_ch2.exp_data[ptr2], dphy_ch2.exp_data[(ptr2+1)%BUF_SIZE]); #100 $stop; end
				ptr2 = (ptr2 + 2)%BUF_SIZE;
			end
	`ifndef NUM_RX_CH_3
			3'd3 : begin
				if ({data0_r, data1_r} === {dphy_ch3.exp_data[ptr3], dphy_ch3.exp_data[(ptr3+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch3 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch3", $time, 
						data0_r, data1_r, dphy_ch3.exp_data[ptr3], dphy_ch3.exp_data[(ptr3+1)%BUF_SIZE]); #100 $stop; end
				ptr3 = (ptr3 + 2)%BUF_SIZE;
			end
		`ifndef NUM_RX_CH_4
			3'd4 : begin
				if ({data0_r, data1_r} === {dphy_ch4.exp_data[ptr4], dphy_ch4.exp_data[(ptr4+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch4 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch4", $time, 
						data0_r, data1_r, dphy_ch4.exp_data[ptr4], dphy_ch4.exp_data[(ptr4+1)%BUF_SIZE]); #100 $stop; end
				ptr4 = (ptr4 + 2)%BUF_SIZE;
			end
			`ifndef NUM_RX_CH_5
			3'd5 : begin
				if ({data0_r, data1_r} === {dphy_ch5.exp_data[ptr5], dphy_ch5.exp_data[(ptr5+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch5 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch5", $time, 
						data0_r, data1_r, dphy_ch5.exp_data[ptr5], dphy_ch5.exp_data[(ptr5+1)%BUF_SIZE]); #100 $stop; end
				ptr5 = (ptr5 + 2)%BUF_SIZE;
			end
				`ifndef NUM_RX_CH_6
			3'd6 : begin
				if ({data0_r, data1_r} === {dphy_ch6.exp_data[ptr6], dphy_ch6.exp_data[(ptr6+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch6 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch6", $time, 
						data0_r, data1_r, dphy_ch6.exp_data[ptr6], dphy_ch6.exp_data[(ptr6+1)%BUF_SIZE]); #100 $stop; end
				ptr6 = (ptr6 + 2)%BUF_SIZE;
			end
					`ifndef NUM_RX_CH_7
			3'd7 : begin
				if ({data0_r, data1_r} === {dphy_ch7.exp_data[ptr7], dphy_ch7.exp_data[(ptr7+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch7 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch7", $time, 
						data0_r, data1_r, dphy_ch7.exp_data[ptr7], dphy_ch7.exp_data[(ptr7+1)%BUF_SIZE]); #100 $stop; end
				ptr7 = (ptr7 + 2)%BUF_SIZE;
			end
					`endif
				`endif
			`endif
		`endif
	`endif
`endif
		endcase
	end
	else if (word_count%2 == 1) begin
		case (ref_ch)
			3'd0 : begin
				if (data0_r === dphy_ch0.exp_data[ptr0]) 
					$display ("%t Data matches ch0 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch0", $time, data0_r, dphy_ch0.exp_data[ptr0]); #100 $stop; end
				ptr0 = (ptr0 + 1)%BUF_SIZE;
			end
			3'd1 : begin
				if (data0_r === dphy_ch1.exp_data[ptr1]) 
					$display ("%t Data matches ch1 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch1", $time, data0_r, dphy_ch1.exp_data[ptr1]); #100 $stop; end
				ptr1 = (ptr1 + 1)%BUF_SIZE;
			end
`ifndef NUM_RX_CH_2
			3'd2 : begin
				if (data0_r === dphy_ch2.exp_data[ptr2]) 
					$display ("%t Data matches ch2 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch2", $time, data0_r, dphy_ch2.exp_data[ptr2]); #100 $stop; end
				ptr2 = (ptr2 + 1)%BUF_SIZE;
			end
	`ifndef NUM_RX_CH_3
			3'd3 : begin
				if (data0_r === dphy_ch3.exp_data[ptr3]) 
					$display ("%t Data matches ch3 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch3", $time, data0_r, dphy_ch3.exp_data[ptr3]); #100 $stop; end
				ptr3 = (ptr3 + 1)%BUF_SIZE;
			end
		`ifndef NUM_RX_CH_4
			3'd4 : begin
				if (data0_r === dphy_ch4.exp_data[ptr4]) 
					$display ("%t Data matches ch4 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch4", $time, data0_r, dphy_ch4.exp_data[ptr4]); #100 $stop; end
				ptr4 = (ptr4 + 1)%BUF_SIZE;
			end
			`ifndef NUM_RX_CH_5
			3'd5 : begin
				if (data0_r === dphy_ch5.exp_data[ptr5]) 
					$display ("%t Data matches ch5 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch5", $time, data0_r, dphy_ch5.exp_data[ptr5]); #100 $stop; end
				ptr5 = (ptr5 + 1)%BUF_SIZE;
			end
				`ifndef NUM_RX_CH_6
			3'd6 : begin
				if (data0_r === dphy_ch6.exp_data[ptr6]) 
					$display ("%t Data matches ch6 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch6", $time, data0_r, dphy_ch6.exp_data[ptr6]); #100 $stop; end
				ptr6 = (ptr6 + 1)%BUF_SIZE;
			end
					`ifndef NUM_RX_CH_7
			3'd7 : begin
				if (data0_r === dphy_ch7.exp_data[ptr7]) 
					$display ("%t Data matches ch7 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch7", $time, data0_r, dphy_ch7.exp_data[ptr7]); #100 $stop; end
				ptr7 = (ptr7 + 1)%BUF_SIZE;
			end
					`endif
				`endif
			`endif
		`endif
	`endif
`endif
		endcase
	end
end
endtask


task extra_data_check4;
begin
	if (word_count%4 == 0) begin
		case (ref_ch)
			3'd0 : begin
				if ({data0_r, data1_r} === {dphy_ch0.exp_data[ptr0], dphy_ch0.exp_data[(ptr0+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch0 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch0", $time, 
						data0_r, data1_r, dphy_ch0.exp_data[ptr0], dphy_ch0.exp_data[(ptr0+1)%BUF_SIZE]); #100 $stop; end
				ptr0 = (ptr0 + 2)%BUF_SIZE;
			end
			3'd1 : begin
				if ({data0_r, data1_r} === {dphy_ch1.exp_data[ptr1], dphy_ch1.exp_data[(ptr1+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch1 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch1", $time, 
						data0_r, data1_r, dphy_ch1.exp_data[ptr1], dphy_ch1.exp_data[(ptr1+1)%BUF_SIZE]); #100 $stop; end
				ptr1 = (ptr1 + 2)%BUF_SIZE;
			end
`ifndef NUM_RX_CH_2
			3'd2 : begin
				if ({data0_r, data1_r} === {dphy_ch2.exp_data[ptr2], dphy_ch2.exp_data[(ptr2+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch2 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch2", $time, 
						data0_r, data1_r, dphy_ch2.exp_data[ptr2], dphy_ch2.exp_data[(ptr2+1)%BUF_SIZE]); #100 $stop; end
				ptr2 = (ptr2 + 2)%BUF_SIZE;
			end
	`ifndef NUM_RX_CH_3
			3'd3 : begin
				if ({data0_r, data1_r} === {dphy_ch3.exp_data[ptr3], dphy_ch3.exp_data[(ptr3+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch3 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch3", $time, 
						data0_r, data1_r, dphy_ch3.exp_data[ptr3], dphy_ch3.exp_data[(ptr3+1)%BUF_SIZE]); #100 $stop; end
				ptr3 = (ptr3 + 2)%BUF_SIZE;
			end
		`ifndef NUM_RX_CH_4
			3'd4 : begin
				if ({data0_r, data1_r} === {dphy_ch4.exp_data[ptr4], dphy_ch4.exp_data[(ptr4+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch4 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch4", $time, 
						data0_r, data1_r, dphy_ch4.exp_data[ptr4], dphy_ch4.exp_data[(ptr4+1)%BUF_SIZE]); #100 $stop; end
				ptr4 = (ptr4 + 2)%BUF_SIZE;
			end
			`ifndef NUM_RX_CH_5
			3'd5 : begin
				if ({data0_r, data1_r} === {dphy_ch5.exp_data[ptr5], dphy_ch5.exp_data[(ptr5+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch5 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch5", $time, 
						data0_r, data1_r, dphy_ch5.exp_data[ptr5], dphy_ch5.exp_data[(ptr5+1)%BUF_SIZE]); #100 $stop; end
				ptr5 = (ptr5 + 2)%BUF_SIZE;
			end
				`ifndef NUM_RX_CH_6
			3'd6 : begin
				if ({data0_r, data1_r} === {dphy_ch6.exp_data[ptr6], dphy_ch6.exp_data[(ptr6+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch6 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch6", $time, 
						data0_r, data1_r, dphy_ch6.exp_data[ptr6], dphy_ch6.exp_data[(ptr6+1)%BUF_SIZE]); #100 $stop; end
				ptr6 = (ptr6 + 2)%BUF_SIZE;
			end
					`ifndef NUM_RX_CH_7
			3'd7 : begin
				if ({data0_r, data1_r} === {dphy_ch7.exp_data[ptr7], dphy_ch7.exp_data[(ptr7+1)%BUF_SIZE]}) 
					$display ("%t Data matches ch7 : %2h %2h", $time, data0_r, data1_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h, expected %2h %2h from ch7", $time, 
						data0_r, data1_r, dphy_ch7.exp_data[ptr7], dphy_ch7.exp_data[(ptr7+1)%BUF_SIZE]); #100 $stop; end
				ptr7 = (ptr7 + 2)%BUF_SIZE;
			end
					`endif
				`endif
			`endif
		`endif
	`endif
`endif
		endcase
	end
	else if (word_count%4 == 1) begin
		case (ref_ch)
			3'd0 : begin
				if ({data0_r, data1_r, data2_r} === {dphy_ch0.exp_data[ptr0], dphy_ch0.exp_data[(ptr0+1)%BUF_SIZE], dphy_ch0.exp_data[(ptr0+2)%BUF_SIZE]}) 
					$display ("%t Data matches ch0 : %2h %2h %2h", $time, data0_r, data1_r, data2_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h, expected %2h %2h %2h from ch0", $time, 
						data0_r, data1_r, data2_r, dphy_ch0.exp_data[ptr0], dphy_ch0.exp_data[(ptr0+1)%BUF_SIZE], dphy_ch0.exp_data[(ptr0+2)%BUF_SIZE]); #100 $stop; end
				ptr0 = (ptr0 + 3)%BUF_SIZE;
			end
			3'd1 : begin
				if ({data0_r, data1_r, data2_r} === {dphy_ch1.exp_data[ptr1], dphy_ch1.exp_data[(ptr1+1)%BUF_SIZE], dphy_ch1.exp_data[(ptr1+2)%BUF_SIZE]}) 
					$display ("%t Data matches ch1 : %2h %2h %2h", $time, data0_r, data1_r, data2_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h, expected %2h %2h %2h from ch1", $time, 
						data0_r, data1_r, data2_r, dphy_ch1.exp_data[ptr1], dphy_ch1.exp_data[(ptr1+1)%BUF_SIZE], dphy_ch1.exp_data[(ptr1+2)%BUF_SIZE]); #100 $stop; end
				ptr1 = (ptr1 + 3)%BUF_SIZE;
			end
`ifndef NUM_RX_CH_2
			3'd2 : begin
				if ({data0_r, data1_r, data2_r} === {dphy_ch2.exp_data[ptr2], dphy_ch2.exp_data[(ptr2+1)%BUF_SIZE], dphy_ch2.exp_data[(ptr2+2)%BUF_SIZE]}) 
					$display ("%t Data matches ch2 : %2h %2h %2h", $time, data0_r, data1_r, data2_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h, expected %2h %2h %2h from ch2", $time, 
						data0_r, data1_r, data2_r, dphy_ch2.exp_data[ptr2], dphy_ch2.exp_data[(ptr2+1)%BUF_SIZE], dphy_ch2.exp_data[(ptr2+2)%BUF_SIZE]); #100 $stop; end
				ptr2 = (ptr2 + 3)%BUF_SIZE;
			end
	`ifndef NUM_RX_CH_3
			3'd3 : begin
				if ({data0_r, data1_r, data2_r} === {dphy_ch3.exp_data[ptr3], dphy_ch3.exp_data[(ptr3+1)%BUF_SIZE], dphy_ch3.exp_data[(ptr3+2)%BUF_SIZE]}) 
					$display ("%t Data matches ch3 : %2h %2h %2h", $time, data0_r, data1_r, data2_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h, expected %2h %2h %2h from ch3", $time, 
						data0_r, data1_r, data2_r, dphy_ch3.exp_data[ptr3], dphy_ch3.exp_data[(ptr3+1)%BUF_SIZE], dphy_ch3.exp_data[(ptr3+2)%BUF_SIZE]); #100 $stop; end
				ptr3 = (ptr3 + 3)%BUF_SIZE;
			end
		`ifndef NUM_RX_CH_4
			3'd4 : begin
				if ({data0_r, data1_r, data2_r} === {dphy_ch4.exp_data[ptr4], dphy_ch4.exp_data[(ptr4+1)%BUF_SIZE], dphy_ch4.exp_data[(ptr4+2)%BUF_SIZE]}) 
					$display ("%t Data matches ch4 : %2h %2h %2h", $time, data0_r, data1_r, data2_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h, expected %2h %2h %2h from ch4", $time, 
						data0_r, data1_r, data2_r, dphy_ch4.exp_data[ptr4], dphy_ch4.exp_data[(ptr4+1)%BUF_SIZE], dphy_ch4.exp_data[(ptr4+2)%BUF_SIZE]); #100 $stop; end
				ptr4 = (ptr4 + 3)%BUF_SIZE;
			end
			`ifndef NUM_RX_CH_5
			3'd5 : begin
				if ({data0_r, data1_r, data2_r} === {dphy_ch5.exp_data[ptr5], dphy_ch5.exp_data[(ptr5+1)%BUF_SIZE], dphy_ch5.exp_data[(ptr5+2)%BUF_SIZE]}) 
					$display ("%t Data matches ch5 : %2h %2h %2h", $time, data0_r, data1_r, data2_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h, expected %2h %2h %2h from ch5", $time, 
						data0_r, data1_r, data2_r, dphy_ch5.exp_data[ptr5], dphy_ch5.exp_data[(ptr5+1)%BUF_SIZE], dphy_ch5.exp_data[(ptr5+2)%BUF_SIZE]); #100 $stop; end
				ptr5 = (ptr5 + 3)%BUF_SIZE;
			end
				`ifndef NUM_RX_CH_6
			3'd6 : begin
				if ({data0_r, data1_r, data2_r} === {dphy_ch6.exp_data[ptr6], dphy_ch6.exp_data[(ptr6+1)%BUF_SIZE], dphy_ch6.exp_data[(ptr6+2)%BUF_SIZE]}) 
					$display ("%t Data matches ch6 : %2h %2h %2h", $time, data0_r, data1_r, data2_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h, expected %2h %2h %2h from ch6", $time, 
						data0_r, data1_r, data2_r, dphy_ch6.exp_data[ptr6], dphy_ch6.exp_data[(ptr6+1)%BUF_SIZE], dphy_ch6.exp_data[(ptr6+2)%BUF_SIZE]); #100 $stop; end
				ptr6 = (ptr6 + 3)%BUF_SIZE;
			end
					`ifndef NUM_RX_CH_7
			3'd7 : begin
				if ({data0_r, data1_r, data2_r} === {dphy_ch7.exp_data[ptr7], dphy_ch7.exp_data[(ptr7+1)%BUF_SIZE], dphy_ch7.exp_data[(ptr7+2)%BUF_SIZE]}) 
					$display ("%t Data matches ch7 : %2h %2h %2h", $time, data0_r, data1_r, data2_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h, expected %2h %2h %2h from ch7", $time, 
						data0_r, data1_r, data2_r, dphy_ch7.exp_data[ptr7], dphy_ch7.exp_data[(ptr7+1)%BUF_SIZE], dphy_ch7.exp_data[(ptr7+2)%BUF_SIZE]); #100 $stop; end
				ptr7 = (ptr7 + 3)%BUF_SIZE;
			end
					`endif
				`endif
			`endif
		`endif
	`endif
`endif
		endcase
	end
	else if (word_count%4 == 2) begin
		case (ref_ch)
			3'd0 : begin
				if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch0.exp_data[ptr0], dphy_ch0.exp_data[(ptr0+1)%BUF_SIZE], dphy_ch0.exp_data[(ptr0+2)%BUF_SIZE], dphy_ch0.exp_data[(ptr0+3)%BUF_SIZE]}) 
					$display ("%t Data matches ch0 : %2h %2h %2h %2h", $time, data0_r, data1_r, data2_r, data3_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch0", $time, 
						data0_r, data1_r, data2_r, data3_r, dphy_ch0.exp_data[ptr0], dphy_ch0.exp_data[(ptr0+1)%BUF_SIZE], dphy_ch0.exp_data[(ptr0+2)%BUF_SIZE], dphy_ch0.exp_data[(ptr0+3)%BUF_SIZE]); #100 $stop; end
				ptr0 = (ptr0 + 4)%BUF_SIZE;
			end
			3'd1 : begin
				if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch1.exp_data[ptr1], dphy_ch1.exp_data[(ptr1+1)%BUF_SIZE], dphy_ch1.exp_data[(ptr1+2)%BUF_SIZE], dphy_ch1.exp_data[(ptr1+3)%BUF_SIZE]}) 
					$display ("%t Data matches ch1 : %2h %2h %2h %2h", $time, data0_r, data1_r, data2_r, data3_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch1", $time, 
						data0_r, data1_r, data2_r, data3_r, dphy_ch1.exp_data[ptr1], dphy_ch1.exp_data[(ptr1+1)%BUF_SIZE], dphy_ch1.exp_data[(ptr1+2)%BUF_SIZE], dphy_ch1.exp_data[(ptr1+3)%BUF_SIZE]); #100 $stop; end
				ptr1 = (ptr1 + 4)%BUF_SIZE;
			end
`ifndef NUM_RX_CH_2
			3'd2 : begin
				if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch2.exp_data[ptr2], dphy_ch2.exp_data[(ptr2+1)%BUF_SIZE], dphy_ch2.exp_data[(ptr2+2)%BUF_SIZE], dphy_ch2.exp_data[(ptr2+3)%BUF_SIZE]}) 
					$display ("%t Data matches ch2 : %2h %2h %2h %2h", $time, data0_r, data1_r, data2_r, data3_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch2", $time, 
						data0_r, data1_r, data2_r, data3_r, dphy_ch2.exp_data[ptr2], dphy_ch2.exp_data[(ptr2+1)%BUF_SIZE], dphy_ch2.exp_data[(ptr2+2)%BUF_SIZE], dphy_ch2.exp_data[(ptr2+3)%BUF_SIZE]); #100 $stop; end
				ptr2 = (ptr2 + 4)%BUF_SIZE;
			end
	`ifndef NUM_RX_CH_3
			3'd3 : begin
				if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch3.exp_data[ptr3], dphy_ch3.exp_data[(ptr3+1)%BUF_SIZE], dphy_ch3.exp_data[(ptr3+2)%BUF_SIZE], dphy_ch3.exp_data[(ptr3+3)%BUF_SIZE]}) 
					$display ("%t Data matches ch3 : %2h %2h %2h %2h", $time, data0_r, data1_r, data2_r, data3_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch3", $time, 
						data0_r, data1_r, data2_r, data3_r, dphy_ch3.exp_data[ptr3], dphy_ch3.exp_data[(ptr3+1)%BUF_SIZE], dphy_ch3.exp_data[(ptr3+2)%BUF_SIZE], dphy_ch3.exp_data[(ptr3+3)%BUF_SIZE]); #100 $stop; end
				ptr3 = (ptr3 + 4)%BUF_SIZE;
			end
		`ifndef NUM_RX_CH_4
			3'd4 : begin
				if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch4.exp_data[ptr4], dphy_ch4.exp_data[(ptr4+1)%BUF_SIZE], dphy_ch4.exp_data[(ptr4+2)%BUF_SIZE], dphy_ch4.exp_data[(ptr4+3)%BUF_SIZE]}) 
					$display ("%t Data matches ch4 : %2h %2h %2h %2h", $time, data0_r, data1_r, data2_r, data3_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch4", $time, 
						data0_r, data1_r, data2_r, data3_r, dphy_ch4.exp_data[ptr4], dphy_ch4.exp_data[(ptr4+1)%BUF_SIZE], dphy_ch4.exp_data[(ptr4+2)%BUF_SIZE], dphy_ch4.exp_data[(ptr4+3)%BUF_SIZE]); #100 $stop; end
				ptr4 = (ptr4 + 4)%BUF_SIZE;
			end
			`ifndef NUM_RX_CH_5
			3'd5 : begin
				if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch5.exp_data[ptr5], dphy_ch5.exp_data[(ptr5+1)%BUF_SIZE], dphy_ch5.exp_data[(ptr5+2)%BUF_SIZE], dphy_ch5.exp_data[(ptr5+3)%BUF_SIZE]}) 
					$display ("%t Data matches ch5 : %2h %2h %2h %2h", $time, data0_r, data1_r, data2_r, data3_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch5", $time, 
						data0_r, data1_r, data2_r, data3_r, dphy_ch5.exp_data[ptr5], dphy_ch5.exp_data[(ptr5+1)%BUF_SIZE], dphy_ch5.exp_data[(ptr5+2)%BUF_SIZE], dphy_ch5.exp_data[(ptr5+3)%BUF_SIZE]); #100 $stop; end
				ptr5 = (ptr5 + 4)%BUF_SIZE;
			end
				`ifndef NUM_RX_CH_6
			3'd6 : begin
				if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch6.exp_data[ptr6], dphy_ch6.exp_data[(ptr6+1)%BUF_SIZE], dphy_ch6.exp_data[(ptr6+2)%BUF_SIZE], dphy_ch6.exp_data[(ptr6+3)%BUF_SIZE]}) 
					$display ("%t Data matches ch6 : %2h %2h %2h %2h", $time, data0_r, data1_r, data2_r, data3_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch6", $time, 
						data0_r, data1_r, data2_r, data3_r, dphy_ch6.exp_data[ptr6], dphy_ch6.exp_data[(ptr6+1)%BUF_SIZE], dphy_ch6.exp_data[(ptr6+2)%BUF_SIZE], dphy_ch6.exp_data[(ptr6+3)%BUF_SIZE]); #100 $stop; end
				ptr6 = (ptr6 + 4)%BUF_SIZE;
			end
					`ifndef NUM_RX_CH_7
			3'd7 : begin
				if ({data0_r, data1_r, data2_r, data3_r} === {dphy_ch7.exp_data[ptr7], dphy_ch7.exp_data[(ptr7+1)%BUF_SIZE], dphy_ch7.exp_data[(ptr7+2)%BUF_SIZE], dphy_ch7.exp_data[(ptr7+3)%BUF_SIZE]}) 
					$display ("%t Data matches ch7 : %2h %2h %2h %2h", $time, data0_r, data1_r, data2_r, data3_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h %2h %2h %2h, expected %2h %2h %2h %2h from ch7", $time, 
						data0_r, data1_r, data2_r, data3_r, dphy_ch7.exp_data[ptr7], dphy_ch7.exp_data[(ptr7+1)%BUF_SIZE], dphy_ch7.exp_data[(ptr7+2)%BUF_SIZE], dphy_ch7.exp_data[(ptr7+3)%BUF_SIZE]); #100 $stop; end
				ptr7 = (ptr7 + 4)%BUF_SIZE;
			end
					`endif
				`endif
			`endif
		`endif
	`endif
`endif
		endcase
	end
	else if (word_count%4 == 3) begin
		case (ref_ch)
			3'd0 : begin
				if (data0_r === dphy_ch0.exp_data[ptr0]) 
					$display ("%t Data matches ch0 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch0", $time, data0_r, dphy_ch0.exp_data[ptr0]); #100 $stop; end
				ptr0 = (ptr0 + 1)%BUF_SIZE;
			end
			3'd1 : begin
				if (data0_r === dphy_ch1.exp_data[ptr1]) 
					$display ("%t Data matches ch1 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch1", $time, data0_r, dphy_ch1.exp_data[ptr1]); #100 $stop; end
				ptr1 = (ptr1 + 1)%BUF_SIZE;
			end
`ifndef NUM_RX_CH_2
			3'd2 : begin
				if (data0_r === dphy_ch2.exp_data[ptr2]) 
					$display ("%t Data matches ch2 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch2", $time, data0_r, dphy_ch2.exp_data[ptr2]); #100 $stop; end
				ptr2 = (ptr2 + 1)%BUF_SIZE;
			end
	`ifndef NUM_RX_CH_3
			3'd3 : begin
				if (data0_r === dphy_ch3.exp_data[ptr3]) 
					$display ("%t Data matches ch3 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch3", $time, data0_r, dphy_ch3.exp_data[ptr3]); #100 $stop; end
				ptr3 = (ptr3 + 1)%BUF_SIZE;
			end
		`ifndef NUM_RX_CH_4
			3'd4 : begin
				if (data0_r === dphy_ch4.exp_data[ptr4]) 
					$display ("%t Data matches ch4 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch4", $time, data0_r, dphy_ch4.exp_data[ptr4]); #100 $stop; end
				ptr4 = (ptr4 + 1)%BUF_SIZE;
			end
			`ifndef NUM_RX_CH_5
			3'd5 : begin
				if (data0_r === dphy_ch5.exp_data[ptr5]) 
					$display ("%t Data matches ch5 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch5", $time, data0_r, dphy_ch5.exp_data[ptr5]); #100 $stop; end
				ptr5 = (ptr5 + 1)%BUF_SIZE;
			end
				`ifndef NUM_RX_CH_6
			3'd6 : begin
				if (data0_r === dphy_ch6.exp_data[ptr6]) 
					$display ("%t Data matches ch6 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch6", $time, data0_r, dphy_ch6.exp_data[ptr6]); #100 $stop; end
				ptr6 = (ptr6 + 1)%BUF_SIZE;
			end
					`ifndef NUM_RX_CH_7
			3'd7 : begin
				if (data0_r === dphy_ch7.exp_data[ptr7]) 
					$display ("%t Data matches ch7 : %2h", $time, data0_r);
				else begin $display ("%t ERROR!!! Data mis-matches, got %2h, expected %2h from ch7", $time, data0_r, dphy_ch7.exp_data[ptr7]); #100 $stop; end
				ptr7 = (ptr7 + 1)%BUF_SIZE;
			end
					`endif
				`endif
			`endif
		`endif
	`endif
`endif
		endcase
	end
end
endtask



task collect_data;
begin
   forever begin
      if (active_data == 1) begin
          if (lane_width == 1) begin
              if (data_ctr == 0) begin // B8
                  data_ctr = data_ctr + 1;
                  repeat (8) @ (clk_p_i);
              end else
              if (data_ctr == 1) begin // DT
                 data_ctr   = data_ctr + 1;
                 data_type  = data0_r;
                 data0_out  = data0_r;
                 write_str("#####Header#####");

				 if (data_type[5:0] >= 6'h00 && data_type[5:0] <= 6'h0F) begin //short packet
                    $display ("[%0t][%0s] Short Packet detected : Data type = %2h", $realtime, name, data_type[5:0]);
                    short_pkt  = 1;
                    data_cycle = 5;
                    write_str("Short Packet");
                 end else
                 if (data_type[5:0] >= 6'h10 && data_type[5:0] <= 6'h2F) begin //long packet
                    $display ("[%0t][%0s] Long Packet detected : Data type = %2h", $realtime, name, data_type[5:0]);
                    short_pkt = 0;
                    write_str("Long Packet");
                 end

                 write_to_file(data0_out);

                 repeat (8) @ (clk_p_i);
              end else
              if (data_ctr == 2) begin // WC[7:0]
                 data_ctr = data_ctr + 1;
                 if (short_pkt == 0) begin // get WC for long packet
                    word_count[ 7:0] = data0_r;
                    $display ("[%0t][%0s] Word Count [7:0] = %2h", $realtime, name, word_count[7:0]);
                 end else
                 begin                       // get header 0 
                    header0 = data0_r;
                    $display ("[%0t][%0s] Header0 = %2h", $realtime, name, header0);
                 end
                 word_count[ 7:0] = data0_r;
                 data0_out  = data0_r;
                 write_to_file(data0_out);
                 repeat (8) @ (clk_p_i);
              end else
              if (data_ctr == 3) begin // WC[15:8]
                 data_ctr = data_ctr + 1;
                 if (short_pkt == 0) begin // get WC for long packet
                    word_count[15:8] = data0_r;
                    $display ("[%0t][%0s] Word Count [15:8] = %2h", $realtime, name, word_count[15:8]);
                 end else
                 begin                       // get header 1
                    header1 = data0_r;
                    $display ("[%0t][%0s] Header1 = %2h", $realtime, name, header1);
                 end
                 word_count[15:8] = data0_r;
                 data0_out  = data0_r;
                 write_to_file(data0_out);
                 repeat (8) @ (clk_p_i);
              end else
              if (data_ctr == 4) begin
                 data_ctr = data_ctr + 1;
                 ecc = data0_r;
                 data0_out  = data0_r;
                 write_to_file(data0_out);
                 if (short_pkt == 0) begin // update WC if long packet
                    get_data_ctr (word_count, data_cycle);
                  end

				 channel_check (data_type, word_count[7:0], word_count[15:8], data0_out);	// MT

                 // resetting checksum
                 chksum = 16'hFFFF;
                  repeat (8) @ (clk_p_i);
                 // reset ecc
                 ecc     = 8'h00;
                 exp_ecc = 8'h00;
              end else
              if (data_ctr == 5 && short_pkt == 1) begin
                 active_data = 0;
              end else
              if (data_ctr == data_cycle - 2) begin // get computed crc
                  data_ctr  = data_ctr + 1;
                  exp_crc   = chksum;

                  data0_out = data0_r;

				  	data_check1; // MT
                  repeat (8) @ (clk_p_i);
              end else
              if (data_ctr == data_cycle - 1) begin // get actual crc
                  data_ctr  = data_ctr + 1;
                  crc[7:0] = data0_out;
                  write_str("#####CRC######");
                  write_to_file(data0_out);

                  data0_out = data0_r;
				  	data_check1; // MT

                  repeat (8) @ (clk_p_i);
              end else
              if (data_ctr == data_cycle) begin
                  active_data = 0;
                  pkt_end = 1;
                  crc[15:8] = data0_out;
                  write_to_file(data0_out);
                  data0_out = data0_r;

                  if (crc != exp_crc) begin
                    $display ("[%0t][%0s]ERROR!!! Incorrect CRC: Actual = %4h; Expected = %4h", $realtime, name, crc, exp_crc);
                  end else
                  begin
                    $display ("[%0t][%0s]CRC = %4h", $realtime, name, crc);
                  end
              end else
              begin
                  data_ctr  = data_ctr + 1;
//                  $display ("[%0t][%0s]byte data = %2h", $realtime, name, data0_r);
                  $write ("[%0t][%0s]payload data = %2h --- ", $realtime, name, data0_r);
				  	data_check1; // MT
                  data0_out = data0_r;
                  write_to_file(data0_out);
                  compute_crc16(data0_r);

                  data_out [7:0] = data0_out;
                  repeat (2) @ (clk_p_i);
                  dvalid = 1;
                  repeat (2) @ (clk_p_i);
                  dvalid = 0;
                  repeat (4) @ (clk_p_i);
              end
          end else 
          if (lane_width == 2) begin
              if (data_ctr == 0) begin // B8
                  data_ctr = data_ctr + 1;
                  write_str("");
                  repeat (8) @ (clk_p_i);
              end else
              if (data_ctr == 1) begin // DT
                 data_ctr   = data_ctr + 1;
                 data_type  = data0_r;
                 data0_out  = data0_r;
                 data1_out  = data1_r;
                 write_str("#####Header#####");

                 if (data_type[5:0] >= 6'h00 && data_type[5:0] <= 6'h0F) begin //short packet
                    $display ("[%0t][%0s] Short Packet detected : Data type = %2h", $realtime, name, data_type[5:0]);
                    short_pkt  = 1;
                    data_cycle = 3;
                    header0    = data1_r;
                    write_str("Short Packet");
                 end else
                 if (data_type[5:0] >= 6'h10 && data_type[5:0] <= 6'h2F) begin //long packet
                    $display ("[%0t][%0s] Long Packet detected : Data type = %2h", $realtime, name, data_type[5:0]);
                    short_pkt = 0;
                    word_count[7:0] = data1_r;
                    write_str("Long Packet");
                 end
                 word_count[7:0] = data1_r;

                 write_to_file(data0_out);
                 write_to_file(data1_out);

                 repeat (8) @ (clk_p_i);
              end else
              if (data_ctr == 2) begin
                 data_ctr   = data_ctr + 1;
                 data0_out  = data0_r;
                 data1_out  = data1_r;
                 write_to_file(data0_out);
                 write_to_file(data1_out);

                 if (short_pkt == 0) begin // get WC for long packet
                    word_count[15:8] = data0_r;
                    $display ("[%0t][%0s] Word Count = %4h", $realtime, name, word_count[15:0]);
                    get_data_ctr (word_count, data_cycle);
                    write_str("#####DATA######"); //
                 end else
                 begin                       // get header 1
                    header1 = data0_r;
                    $display ("[%0t][%0s] Header1 = %2h", $realtime, name, header1);
                 end

				 channel_check (data_type, word_count[7:0], data0_out, data1_out);	// MT

                 // reset checksum
                 chksum = 16'hFFFF;
                 repeat (8) @ (clk_p_i);
                 ecc     = 8'h00;
                 exp_ecc = 8'h00;

                 end else
               if (data_ctr == 3 && short_pkt == 1) begin
                    active_data = 0;
               end else
               if ((data_ctr > 3) && (data_ctr == data_cycle - 2) && (word_count%2 == 1)) begin // get computed crc
					data0_out = data0_r;
					data1_out = data1_r;
					data_ctr  = data_ctr + 1;
					compute_crc16(data0_out);
					crc[7:0] = data1_out;
				  	data_check2; // MT
               		repeat (8) @ (clk_p_i);
               end else
               if (data_ctr == data_cycle - 1) begin // get computed crc
					data0_out = data0_r;
					data1_out = data1_r;
					data_ctr  = data_ctr + 1;
					if (word_count%2 == 1) begin
						crc[15:8] = data0_r;
				  		extra_data_check2; // MT
					end
				end else
              if (data_ctr == data_cycle) begin
                 active_data = 0;
                 pkt_end = 1;
					case (word_count%2)
						1'd0 : begin crc[15:8] = data1_out; crc[ 7:0] = data0_out; exp_crc = chksum; end
						1'd1 : begin crc[15:8] = data0_out; exp_crc = chksum; end
					endcase

                 write_str("#####CRC######");
                 write_to_file(data0_out);
                 write_to_file(data1_out);

                 if (crc != exp_crc) begin
                   $display ("[%0t][%0s]ERROR!!! Incorrect CRC: Actual = %4h; Expected = %4h", $realtime, name, crc, exp_crc);
                 end else
                 begin
                   $display ("[%0t][%0s]CRC = %4h", $realtime, name, crc);
                 end
				if (word_count%2 != 1) begin
					extra_data_check2; // MT
				end
              end else
              begin
                  data_ctr  = data_ctr + 1;
//                  $display ("[%0t][%0s]byte data = %2h %2h", $realtime, name, data0_r, data1_r);
                  $write ("[%0t][%0s]payload data = %2h %2h --- ", $realtime, name, data0_r, data1_r);

				  data_check2; // MT

                  data0_out = data0_r;
                  data1_out = data1_r;
                  write_to_file(data0_out);
                  write_to_file(data1_out);
                  compute_crc16(data0_r);
                  compute_crc16(data1_r);

                  data_out[ 7:0] = data0_out;
                  data_out[15:8] = data1_out;

                  repeat (2) @ (clk_p_i);
                  dvalid = 1;
                  repeat (2) @ (clk_p_i);
                  dvalid = 2;
                  repeat (4) @ (clk_p_i);
              end
          end else
          if (lane_width == 3) begin	// not in use !!!!!
               if (data_ctr == 0) begin // B8
                  data_ctr = data_ctr + 1;
                  repeat (8) @ (clk_p_i);
               end else
               if (data_ctr == 1) begin // data type
                  data_ctr  = data_ctr + 1;
                  data_type = data0_r;
                  data0_out = data0_r;
                  data1_out = data1_r;
                  data2_out = data2_r;
                  word_count[ 7:0] = data1_r;
                  word_count[15:8] = data2_r;
                  header0 = data1_r;
                  header1 = data2_r;
                  write_str("#####Header#####"); 

                 if (data_type[5:0] >= 6'h00 && data_type[5:0] <= 6'h0F) begin //short packet
                    $display ("[%0t][%0s] Short Packet detected : Data type = %2h", $realtime, name, data_type[5:0]);
                    short_pkt  = 1;
                    data_cycle = 3;
                    write_str("Short Packet");
                    write_to_file(data0_out);
                    write_to_file(data1_out);
                    write_to_file(data2_out);
                 end else
                 if (data_type[5:0] >= 6'h10 && data_type[5:0] <= 6'h2F) begin //long packet
                    $display ("[%0t][%0s] Long Packet detected : Data type = %2h", $realtime, name, data_type[5:0]);
                    short_pkt = 0;
                    get_data_ctr (word_count, data_cycle);
                    write_str("Long Packet");
                    write_to_file(data0_out);
                    write_to_file(data1_out);
                    write_to_file(data2_out);
                    //write_str("#####Data#####"); 
                 end
                 repeat (8) @ (clk_p_i);
              end else 
              if (data_ctr == 2) begin 
                  data_ctr = data_ctr + 1;
                  ecc = data0_r;
                  data0_out = data0_r;
                  data1_out = data1_r;
                  data2_out = data2_r;
                  write_to_file(data0_out);
                  //reset checksum
                  chksum = 16'hFFFF;
                  if(short_pkt == 0) begin // long packet
//                    get_ecc({word_count, data_type}, exp_ecc);
/*                    
					case (ref_ch)
						3'd0 : get_ecc ({new_vc0[3:2], word_count, new_vc0[1:0], data_type[5:0]}, exp_ecc);
						3'd1 : get_ecc ({new_vc1[3:2], word_count, new_vc1[1:0], data_type[5:0]}, exp_ecc);
						3'd2 : get_ecc ({new_vc2[3:2], word_count, new_vc2[1:0], data_type[5:0]}, exp_ecc);
						3'd3 : get_ecc ({new_vc3[3:2], word_count, new_vc3[1:0], data_type[5:0]}, exp_ecc);
						3'd4 : get_ecc ({new_vc4[3:2], word_count, new_vc4[1:0], data_type[5:0]}, exp_ecc);
					endcase
*/					
                    write_str("#####Data#####"); 
                    write_to_file(data1_out);
                    write_to_file(data2_out);
                    compute_crc16(data1_r);
                    compute_crc16(data2_r);
                  end
                  else begin
//                    get_ecc({header1, header0, data_type}, exp_ecc);
/*                    
					case (ref_ch)
						3'd0 : get_ecc ({new_vc0[3:2], header1, header0, new_vc0[1:0], data_type[5:0]}, exp_ecc);
						3'd1 : get_ecc ({new_vc1[3:2], header1, header0, new_vc1[1:0], data_type[5:0]}, exp_ecc);
						3'd2 : get_ecc ({new_vc2[3:2], header1, header0, new_vc2[1:0], data_type[5:0]}, exp_ecc);
						3'd3 : get_ecc ({new_vc3[3:2], header1, header0, new_vc3[1:0], data_type[5:0]}, exp_ecc);
						3'd4 : get_ecc ({new_vc4[3:2], header1, header0, new_vc4[1:0], data_type[5:0]}, exp_ecc);
					endcase
*/					
                  end 
                  if (ecc != exp_ecc) begin
                    $display ("[%0t][%0s] ERROR!!! Incorrect ECC: Actual = %0x; Expected = %0x", $realtime, name, ecc, exp_ecc);
                  end else
                  begin
                    $display ("[%0t][%0s]ECC = %0x", $realtime, name, ecc);
                  end
                  //reset ecc 
                  repeat (8) @ (clk_p_i);
                  ecc     = 8'h00;
                  exp_ecc = 8'h00;
              end else
              if (data_ctr == 3 && short_pkt == 1) begin 
                  active_data = 0;
              end else
              if ((data_ctr == data_cycle - 1) && data_mod == 0) begin // get computed crc
                  data_ctr  = data_ctr + 1;
                  exp_crc   = chksum;

                  data0_out = data0_r;
                  data1_out = data1_r;
                  data2_out = data2_r;
            
                  repeat (8) @ (clk_p_i);
              end else
              if ((data_ctr == data_cycle) && data_mod == 0) begin 
                   active_data = 0;
                   crc[15:8] = data1_out;
                   crc[ 7:0] = data0_out;

                  write_str("#####CRC#####"); 
                  write_to_file(data0_out);
                  write_to_file(data1_out);

                   if (crc != exp_crc) begin
                     $display ("[%0t][%0s] ERROR Incorrect CRC: Actual = %4h; Expected = %4h", $realtime, name, crc, exp_crc);
                   end else
                   begin
                     $display ("[%0t][%0s]CRC = %4h", $realtime, name, crc);
                   end
              end else
              if ((data_ctr == data_cycle - 1) && data_mod != 0) begin 
                  if(data_mod == 1) begin
//                    $display ("[%0t][%0s]byte data = %2h %2h %2h", $realtime, name, data0_r, data1_r, data2_r);
                    $write ("[%0t][%0s]payload data = %2h %2h %2h --- ", $realtime, name, data0_r, data1_r, data2_r);
                    data0_out = data0_r;
                    data1_out = data1_r;
                    data2_out = data2_r;
                    compute_crc16(data0_r);
                    exp_crc   = chksum;
                    crc[15:8] = data1_out;
                    crc[ 7:0] = data2_out;
                    write_str("#####CRC#####"); 
                    write_to_file(data1_out);
                    write_to_file(data2_out);
                  end
                  else if (data_mod == 2) begin 
                    data0_out = data0_r;
                    crc[7:0] = data0_out;
                    write_to_file(data0_out);
                  end 
                  active_data = 0;

                  if (crc != exp_crc) begin
                     $display ("[%0t][%0s] ERROR Incorrect CRC: Actual = %0x; Expected = %0x", $realtime, name, crc, exp_crc);
                  end else
                  begin
                    $display ("[%0t][%0s]CRC = %0x", $realtime, name, crc);
                  end
              end else
              if ((data_ctr == data_cycle - 2) && data_mod == 2) begin 
                  $write ("[%0t][%0s]payload data = %2h %2h --- ", $realtime, name, data0_r, data1_r);
                  data0_out = data0_r;
                  data1_out = data1_r;
                  data2_out = data2_r;
                  compute_crc16(data0_r);
                  compute_crc16(data1_r);
                  exp_crc = chksum;
                  crc[15:8] = data2_out;
                  data_ctr = data_ctr + 1;

                  write_to_file(data0_out);
                  write_to_file(data1_out);
                  write_str("#####CRC#####"); 
                  write_to_file(data2_out);
      
                  repeat (8) @ (clk_p_i);
               end
          end else
          if (lane_width == 4) begin
               if (data_ctr == 0) begin // B8
                  data_ctr = data_ctr + 1;
                  repeat (8) @ (clk_p_i);
               end else
               if (data_ctr == 1) begin // data type
                  data_ctr  = data_ctr + 1;
                  data_type = data0_r;
                  data0_out = data0_r;
                  data1_out = data1_r;
                  data2_out = data2_r;
                  data3_out = data3_r;
                  word_count[ 7:0] = data1_r;
                  word_count[15:8] = data2_r;
                  ecc              = data3_r;
					
                  write_str("#####Header#####"); 

                 if (data_type[5:0] >= 6'h00 && data_type[5:0] <= 6'h0F) begin //short packet
                    $display ("[%0t][%0s] Short Packet detected : Data type = %2h", $realtime, name, data_type[5:0]);
                    short_pkt  = 1;
                    data_cycle = 2;
                    write_str("Short Packet");
                    write_to_file(data0_out);
                    write_to_file(data1_out);
                    write_to_file(data2_out);
                    write_to_file(data3_out);
                 end else
                 if (data_type[5:0] >= 6'h10 && data_type[5:0] <= 6'h2F) begin //long packet
                    $display ("[%0t][%0s] Long Packet detected : Data type = %2h", $realtime, name, data_type[5:0]);
                    short_pkt = 0;
                    get_data_ctr (word_count, data_cycle);
                    write_str("Long Packet");
                    write_to_file(data0_out);
                    write_to_file(data1_out);
                    write_to_file(data2_out);
                    write_to_file(data3_out);
                    write_str("#####Data#####"); 
                 end

				 channel_check (data0_out, data1_out, data2_out, data3_out);	// MT

                  repeat (8) @ (clk_p_i);
                  chksum = 16'hFFFF;
               end else
               if (data_ctr == 2 && short_pkt == 1) begin 
                  active_data = 0;
               end else
					   
               if ((data_ctr > 2) && (data_ctr == data_cycle - 2) && (word_count%4 == 3)) begin // get computed crc
					data0_out = data0_r;
					data1_out = data1_r;
					data2_out = data2_r;
					data3_out = data3_r;
					data_ctr  = data_ctr + 1;
					compute_crc16(data0_out); compute_crc16(data1_out); compute_crc16(data2_out);
					crc[7:0] = data3_out;
				  	data_check4; // MT
               		repeat (8) @ (clk_p_i);
               end else
					   
               if (data_ctr == data_cycle - 1) begin // get computed crc
					data0_out = data0_r;
					data1_out = data1_r;
					data2_out = data2_r;
					data3_out = data3_r;
					data_ctr  = data_ctr + 1;
					if (word_count%4 == 3) begin
						crc[15:8] = data0_r;
						extra_data_check4; // MT
					end
				end else

				if (data_ctr == data_cycle) begin
					active_data = 0;
					pkt_end = 1;
					case (word_count%4)
						2'd0 : begin crc[15:8] = data1_out; crc[ 7:0] = data0_out; exp_crc = chksum; end
						2'd1 : begin crc[15:8] = data2_out; crc[ 7:0] = data1_out; compute_crc16(data0_out); exp_crc = chksum; end
						2'd2 : begin crc[15:8] = data3_out; crc[ 7:0] = data2_out; compute_crc16(data0_out); compute_crc16(data1_out); exp_crc = chksum; end
						2'd3 : begin exp_crc = chksum; end
					endcase

                  write_str("#####CRC#####"); 
                  write_to_file(data0_out);
                  write_to_file(data1_out);

                   if (crc != exp_crc) begin
                     $display ("[%0t][%0s]ERROR!!! Incorrect CRC: Actual = %4h; Expected = %4h", $realtime, name, crc, exp_crc);
                   end else
                   begin
                     $display ("[%0t][%0s]CRC = %4h", $realtime, name, crc);
                   end
					if (word_count%4 != 3) begin
						extra_data_check4; // MT
					end

               end
               else begin
//                  $display ("[%0t][%0s]byte data = %2h %2h %2h %2h", $realtime, name, data0_r, data1_r, data2_r, data3_r);
                  $write ("[%0t][%0s] payload data = %2h %2h %2h %2h --- ", $realtime, name, data0_r, data1_r, data2_r, data3_r);

				  data_check4; // MT

                  data0_out = data0_r;
                  data1_out = data1_r;
                  data2_out = data2_r;
                  data3_out = data3_r;
                  compute_crc16(data0_r);
                  compute_crc16(data1_r);
                  compute_crc16(data2_r);
                  compute_crc16(data3_r);
                  data_ctr = data_ctr + 1;

                  write_to_file(data0_out);
                  write_to_file(data1_out);
                  write_to_file(data2_out);
                  write_to_file(data3_out);
      
                  data_out[  7:0] = data0_out;
                  data_out[ 15:8] = data1_out;
                  data_out[23:16] = data2_out;
                  data_out[31:24] = data3_out;
                  repeat (2) @ (clk_p_i);
                  dvalid = 1;
                  repeat (2) @ (clk_p_i);
                  dvalid = 0;
                  repeat (4) @ (clk_p_i);
               end
          end
      end else
      begin
         data_ctr = 0;
         @ (clk_p_i);
         pkt_end = 0;
      end
   end
end
endtask

/*
task get_ecc (input [23:0] d, output [5:0] ecc_val);
begin
  ecc_val[0] = d[0]^d[1]^d[2]^d[4]^d[5]^d[7]^d[10]^d[11]^d[13]^d[16]^d[20]^d[21]^d[22]^d[23];
  ecc_val[1] = d[0]^d[1]^d[3]^d[4]^d[6]^d[8]^d[10]^d[12]^d[14]^d[17]^d[20]^d[21]^d[22]^d[23];
  ecc_val[2] = d[0]^d[2]^d[3]^d[5]^d[6]^d[9]^d[11]^d[12]^d[15]^d[18]^d[20]^d[21]^d[22];
  ecc_val[3] = d[1]^d[2]^d[3]^d[7]^d[8]^d[9]^d[13]^d[14]^d[15]^d[19]^d[20]^d[21]^d[23];
  ecc_val[4] = d[4]^d[5]^d[6]^d[7]^d[8]^d[9]^d[16]^d[17]^d[18]^d[19]^d[20]^d[22]^d[23];
  ecc_val[5] = d[10]^d[11]^d[12]^d[13]^d[14]^d[15]^d[16]^d[17]^d[18]^d[19]^d[21]^d[22]^d[23];
end
endtask
*/
task get_ecc (input [25:0] d, output [7:0] ecc_val);
begin
  ecc_val[0] = d[0]^d[1]^d[2]^d[4]^d[5]^d[7]^d[10]^d[11]^d[13]^d[16]^d[20]^d[21]^d[22]^d[23]^d[24];
  ecc_val[1] = d[0]^d[1]^d[3]^d[4]^d[6]^d[8]^d[10]^d[12]^d[14]^d[17]^d[20]^d[21]^d[22]^d[23]^d[25];
  ecc_val[2] = d[0]^d[2]^d[3]^d[5]^d[6]^d[9]^d[11]^d[12]^d[15]^d[18]^d[20]^d[21]^d[22]^d[24]^d[25];
  ecc_val[3] = d[1]^d[2]^d[3]^d[7]^d[8]^d[9]^d[13]^d[14]^d[15]^d[19]^d[20]^d[21]^d[23]^d[24]^d[25];
  ecc_val[4] = d[4]^d[5]^d[6]^d[7]^d[8]^d[9]^d[16]^d[17]^d[18]^d[19]^d[20]^d[22]^d[23]^d[24]^d[25];
  ecc_val[5] = d[10]^d[11]^d[12]^d[13]^d[14]^d[15]^d[16]^d[17]^d[18]^d[19]^d[21]^d[22]^d[23]^d[24]^d[25];
  ecc_val[6] = d[24];
  ecc_val[7] = d[25];
end
endtask


task compute_crc16(input [7:0] data);
begin
   for (n = 0; n < 8; n = n + 1) begin
     cur_crc = chksum;
     cur_crc[15] = data[n]^cur_crc[0];
     cur_crc[10] = cur_crc[11]^cur_crc[15];
     cur_crc[3]  = cur_crc[4]^cur_crc[15];
     chksum = chksum >> 1;
     chksum[15] = cur_crc[15];
     chksum[10] = cur_crc[10];
     chksum[3] = cur_crc[3];
   end
end
endtask

task get_data_ctr(input [15:0] wc, output [15:0] data_cnt);
begin
     if (lane_width == 1) begin
        data_cnt = 7 + wc; // 1 : sync, 4 : header, 2 : CRC
     end else
     if (lane_width == 2) begin
        data_cnt = wc/lane_width;
        if (wc%lane_width > 0) begin
           data_cnt = data_cnt + 1;
        end
        data_cnt = data_cnt + 4; // 1 : sync, 2 : header, 1 : CRC
     end else
     if (lane_width == 3) begin
        data_cnt = ((wc-2)/lane_width) + 1 + 2 + 1; // 1 : sync, 2 : header, 1 : CRC
        data_mod = (wc-2)%lane_width;
        if(data_mod == 2) begin
          data_cnt = ((wc-2)/lane_width) + 1 + 1 + 2 + 1; // 1: last 2 data, 1 : sync, 2 : header, 1 : CRC
        end
     end else
     if (lane_width == 4) begin
        data_cnt = wc/lane_width;
        if (wc%lane_width < 3) begin
           data_cnt = data_cnt + 1; // CRC included
        end else
        if (wc%lane_width > 2) begin
           data_cnt = data_cnt + 2; // additional for CRC
        end
        data_cnt = data_cnt + 2; // 1 : sync, 1 : header
     end
end
endtask

task write_to_file (input [7:0] data);
  integer filedesc;
begin
  filedesc = $fopen(name,"a");
  $fwrite(filedesc, "%2h\n", data);
  $fclose(filedesc);
end
endtask

task write_str (input [20*8-1:0] str);
  integer filedesc;
begin
  filedesc = $fopen(name,"a");
  $fwrite(filedesc, "%0s\n", str);
  $fclose(filedesc);
end
endtask
endmodule
