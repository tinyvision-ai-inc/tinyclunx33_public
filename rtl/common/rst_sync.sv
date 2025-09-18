/* Synchronize an async active low reset into a clock domain */

module rst_sync (
	input  wire clk        ,
	input  wire async_rst_n,
	output reg sync_rst_n
);

	logic rst_n_meta;
	always @(posedge clk or negedge async_rst_n) begin
		if (~async_rst_n) begin
			sync_rst_n <= 0;
			rst_n_meta <= 0;
		end else begin
			rst_n_meta <= async_rst_n;
			sync_rst_n <= rst_n_meta;
		end
	end

endmodule