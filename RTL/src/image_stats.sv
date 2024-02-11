/*
 * The accumulator block does what it says! Just accumulate any incoming data and double buffer
 * it on the output when the stream ends.
 */
`default_nettype none

module chan_accum #(parameter ACCUM_BITS = 22, PIXEL_BITS = 10) (
	input  wire                  clk    ,
	input  wire                  reset  ,
	input  wire [PIXEL_BITS-1:0] i_data ,
	input  wire                  i_eof  ,
	input  wire                  i_valid,
	// Readout data is double bufferred and updated at the EoF
	output reg  [ACCUM_BITS-1:0] o_accum
);


	logic [ACCUM_BITS-1:0] accum;

	always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
			accum   <= '0;
			o_accum <= '0;

		end else if (i_eof) begin
			// Update the output buffer
			if (i_valid) o_accum <= accum + i_data;
			else 		 o_accum <= accum;

			// Start with a zero accumulator
			accum <= '0;

		end else if (i_valid)
			accum <= accum + i_data;

	end

endmodule


module image_stats #(
	// # of bits per pixel:
	parameter PIXEL_BITS     = 10  ,
	// Maximum # of rows/columns to be processed
	parameter MAX_COLS       = 1920,
	parameter MAX_ROWS       = 1080,
	// # of MSB's of the accumulators to output
	parameter ACCUM_OUT_BITS = 10
) (
	// The core operates in a single clock domain with an active high reset.
	input  wire                            clk       ,
	input  wire                            reset     ,
	// Following are used to remove bordering pixels
	input  wire     [$clog2(MAX_COLS)-1:0] trim_left ,
	input  wire     [$clog2(MAX_COLS)-1:0] width     ,
	input  wire     [$clog2(MAX_ROWS)-1:0] trim_top  ,
	input  wire     [$clog2(MAX_ROWS)-1:0] height    ,
	// Image data stream
	input  wire                            i_fv      ,
	input  wire                            i_lv      ,
	input  wire     [      PIXEL_BITS-1:0] i_data    ,
	// Accumulator & other outputs
	output      reg                        avg_valid ,
	output      reg [  $clog2(MAX_COLS):0] num_cols  ,
	output      reg [  $clog2(MAX_COLS):0] num_rows  ,
	output      reg [                31:0] num_frames,
	output wire     [  ACCUM_OUT_BITS-1:0] ch0_avg     ,
	output wire     [  ACCUM_OUT_BITS-1:0] ch1_avg    ,
	output wire     [  ACCUM_OUT_BITS-1:0] ch2_avg    ,
	output wire     [  ACCUM_OUT_BITS-1:0] ch3_avg
);

	// Figure out start and end of the data streams
	logic                      fv_d, lv_d, valid_row, valid_col;
	logic [$clog2(MAX_COLS):0] col_counter;
	logic [$clog2(MAX_ROWS):0] row_counter;
	logic [    PIXEL_BITS-1:0] i_data_d;

	wire sof = i_fv  & ~fv_d;
	wire eof = ~i_fv &  fv_d;
	wire sol = i_lv  & ~lv_d;
	wire eol = ~i_lv &  lv_d;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			fv_d        <= '0;
			lv_d        <= '0;
			valid_row   <= '0;
			valid_col   <= '0;
			row_counter <= '0;
			col_counter <= '0;
			num_cols    <= '0;
			num_rows    <= '0;
			num_frames  <= '0;
		end else begin

			fv_d <= i_fv;
			lv_d <= i_lv;

			// Update outputs
			if (eof) num_rows <= row_counter;
			if (eol) num_cols <= col_counter;
			if (eof) num_frames <= num_frames + 'd1;

			// Update internal counts
			if (~i_fv) row_counter <= '0;
			else if (eol) row_counter <= row_counter + 'd1;

			if (~i_lv) col_counter <= '0;
			else col_counter <= col_counter + 'd1;

			// Trim the ROI out from the image.
			if (~i_lv) valid_col <= '0;
			else if (col_counter == trim_left) valid_col <= '1;
			else if (col_counter == trim_left + width) valid_col <= '0;

			if (~i_fv) valid_row <= '0;
			else if (row_counter == trim_top) valid_row <= '1;
			else if (row_counter == trim_top + height) valid_row <= '0;

			// Add pipeline to make up for decoding delays above
			i_data_d <= i_data;

		end
	end

	logic                  row_gb, row_rg, col_bg, col_gr;
	logic                  ch0_valid, ch1_valid, ch2_valid, ch3_valid;
	logic [PIXEL_BITS-1:0] ch0_data, ch1_data, ch2_data, ch3_data;

	// ROI is obtained when both the row and column flags are valid
	wire valid_pxl = lv_d & valid_col & valid_row;

	// The RGB pixels come in as a bayer pattern. We need to split them out into separate channels:
	always @* begin
		row_rg = valid_pxl & (row_counter[0] == 'b0);
		row_gb = valid_pxl & (row_counter[0] == 'b1);

		// Split out the RGB pixels from the incoming stream: assume an GRBG pattern
		ch0_valid  = col_counter[0] & row_rg;
		ch1_valid = ~col_counter[0] & row_rg;
		ch2_valid = col_counter[0] & row_gb;
		ch3_valid  = ~col_counter[0] & row_gb;

	end

	// RGB channel accumulators have to be the full size less 1 bit each for decimation on rows/cols
	// Note that due to the bayer pattern, we end up losing another bit as the color channels get
	// decimated automatically.
	localparam ACCUM_BITS = PIXEL_BITS + $clog2(MAX_ROWS)-2 + $clog2(MAX_COLS)-2 -1;

	logic [ACCUM_BITS-1:0] ch0_accum, ch3_accum, ch1_accum , ch2_accum;
	chan_accum #(.ACCUM_BITS($size(ch0_accum)), .PIXEL_BITS(PIXEL_BITS)) i_ch0_accum (.clk(clk), .reset(reset), .i_data(i_data_d), .i_eof(eof), .i_valid(ch0_valid), .o_accum(ch0_accum));
	chan_accum #(.ACCUM_BITS($size(ch1_accum)), .PIXEL_BITS(PIXEL_BITS)) i_ch1_accum (.clk(clk), .reset(reset), .i_data(i_data_d), .i_eof(eof), .i_valid(ch1_valid), .o_accum(ch1_accum));
	chan_accum #(.ACCUM_BITS($size(ch2_accum)), .PIXEL_BITS(PIXEL_BITS)) i_ch2_accum (.clk(clk), .reset(reset), .i_data(i_data_d), .i_eof(eof), .i_valid(ch2_valid), .o_accum(ch2_accum));
	chan_accum #(.ACCUM_BITS($size(ch3_accum)), .PIXEL_BITS(PIXEL_BITS)) i_ch3_accum (.clk(clk), .reset(reset), .i_data(i_data_d), .i_eof(eof), .i_valid(ch3_valid), .o_accum(ch3_accum));

	// Select the MSB from the accumulator to send out of the block.
	assign ch0_avg = ch0_accum[$left(ch0_accum) -: ACCUM_OUT_BITS];
	assign ch1_avg = ch1_accum[$left(ch1_accum) -: ACCUM_OUT_BITS];
	assign ch2_avg = ch2_accum[$left(ch2_accum) -: ACCUM_OUT_BITS];
	assign ch3_avg = ch3_accum[$left(ch3_accum) -: ACCUM_OUT_BITS];

	always @(posedge clk) avg_valid <= eof;

endmodule
`default_nettype wire