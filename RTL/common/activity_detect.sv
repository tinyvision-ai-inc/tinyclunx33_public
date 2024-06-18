/*
 * A simple widget that will edge detect an incoming signal and count.
 * This block is useful when driving say an LED to detect activity on a line.
*/

module activity_detect #(parameter COUNT_BITS = 4) (
	input  wire clk    ,
	input  wire rst    ,
	input  wire sig    ,
	output wire [COUNT_BITS-1:0] ctr_o,
	output wire act_det
);

	// Create a blinking LED when there is frame data to make it easy to see
	logic sig_d;
	logic [COUNT_BITS-1:0] ctr;
	always @(posedge clk) begin
		if (rst) begin
			ctr <= 0;
			sig_d <= 0;
		end else begin

			sig_d <= sig;

			if (sig_d & ~sig)
				ctr <= ctr + 'd1;
		end 
	end

	// Saving logic by not adding a register here, add it if needed in the future
	assign act_det = ctr[COUNT_BITS-1];
	assign ctr_o = ctr;

endmodule