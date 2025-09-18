//`default_nettype none

module pixel_to_mipi #(
	parameter TX_GEAR  = 8 ,
	parameter DT = "DT_RAW10", // DT_RAW10, DT_YUV_422_8 supported
	parameter DT_WIDTH = 10  // Width of data, will depend on data format eg. 16 bits for RAW10, 16 bits for YUV
) (
	// Pixel data
	input  wire                pixel_clk    ,
	input  wire                rst_n        ,
	input  wire                pixel_fv     ,
	input  wire                pixel_lv     ,
	input  wire [DT_WIDTH-1:0] pixel_data   ,
	// Byte clock domain
	input  wire                byte_clk_i   ,
	output wire                byte_clk_o   , // Hard DPHY has a byte clock output
	input  wire                ref_clk      ,
	input  wire                tx_pll_clk   , // For soft Phy
	input  wire                tx_pll_clk_90, // For soft Phy
	input  wire                pll_lock_i   , // For soft Phy
	output wire                pll_lock_o   ,
	output wire                tx_init_done ,
	output wire                tx_rdy       ,
	input  wire [         5:0] byte_dt      ,
	input  wire [        15:0] byte_wc      ,
	//MIPI signals
	inout  wire                tx_clk_p     ,
	inout  wire                tx_clk_n     ,
	inout  wire [         1:0] tx_d_p       ,
	inout  wire [         1:0] tx_d_n
);

	// Use the byte clock from the Tx for all internal operations
	wire byte_clk= byte_clk_o;

	// Reset sync
	logic byte_rst_n;
	rst_sync u_rst_sync_byte_clk (
		.clk        (byte_clk  ),
		.async_rst_n(rst_n     ),
		.sync_rst_n (byte_rst_n)
	);


	//---------------------------------------
	// Pixel to Byte converter
	//---------------------------------------
	wire         byte_data_en;
	wire  [15:0] byte_data   ;
	wire         fv_start, fv_end, lv_start, lv_end, pix2byte_rstn;
	reg          txfr_en, txfr_en_1d;
	wire         txfr_req, tx_d_hs_en;
	logic        tx_c2d_rdy, p2b_tx_rdy;
	logic [ 5:0] dt_o        ;

generate
	
if (DT == "DT_RAW10")
	p2b_2lane i_p2b (
		.rst_n_i         (byte_rst_n & pix2byte_rstn),
		.pix_clk_i       (pixel_clk   ),
		.byte_clk_i      (byte_clk    ),
		.fv_i            (pixel_fv    ),
		.lv_i            (pixel_lv    ),
		.dvalid_i        (pixel_lv    ),
		.pix_data0_i     (pixel_data  ),
		.c2d_ready_i     (tx_c2d_rdy  ),
		.txfr_en_i       (txfr_en     ),
		.fv_start_o      (fv_start    ),
		.fv_end_o        (fv_end      ),
		.lv_start_o      (lv_start    ),
		.lv_end_o        (lv_end      ),
		.txfr_req_o      (txfr_req    ),
		.byte_en_o       (byte_data_en),
		.byte_data_o     (byte_data   ),
		.data_type_o     (dt_o        )
	);

else
	p2b_2l_yuv422_8 i_p2b (
		.rst_n_i    (byte_rst_n & pix2byte_rstn),
		.pix_clk_i  (pixel_clk                 ),
		.byte_clk_i (byte_clk                  ),
		.fv_i       (pixel_fv                  ),
		.lv_i       (pixel_lv                  ),
		.dvalid_i   (pixel_lv                  ),
		.pix_data0_i(pixel_data[7:0]           ),
		.pix_data1_i(pixel_data[15:8]          ),
		.c2d_ready_i(tx_c2d_rdy                ),
		.txfr_en_i  (txfr_en                   ),
		.fv_start_o (fv_start                  ),
		.fv_end_o   (fv_end                    ),
		.lv_start_o (lv_start                  ),
		.lv_end_o   (lv_end                    ),
		.txfr_req_o (txfr_req                  ),
		.byte_en_o  (byte_data_en              ),
		.byte_data_o(byte_data                 ),
		.data_type_o(dt_o                      )
	);

endgenerate
	

	// Edge detect the Tx request to make it a pulse
	reg tx_req_d;
	always_ff @(posedge byte_clk) tx_req_d <= txfr_req;
	wire tx_req = txfr_req & ~tx_req_d;


	// Send a short packet for SoF, EoF and a long packet for SoL.
	// Nothing is sent on EoL.
	reg sp_en;
	reg lp_en;
	always @(posedge byte_clk or negedge byte_rst_n) begin
		if (~byte_rst_n) begin
			sp_en <= 0;
			lp_en <= 0;
		end
		else begin
			sp_en <= fv_start | fv_end;
			lp_en <= lv_start;
		end
	end

	// Setup the data type and WC depending on the Tx transaction
	reg [ 5:0] dt;
	reg [15:0] wc;
	always @(posedge byte_clk or negedge byte_rst_n) begin
		if (~byte_rst_n) begin
			dt <= 0;
			wc <= 0;
		end
		else if (fv_start) begin
			dt <= 6'h00;
			wc <= 0;
		end
		else if (fv_end) begin
			dt <= 6'h01;
			wc <= 0;
		end
		else if (lv_start) begin
			dt <= byte_dt;
			wc <= byte_wc;
		end
	end


	reg        r_byte_data_en_1d, r_byte_data_en_2d, r_byte_data_en_3d;
	reg [15:0] r_byte_data_1d, r_byte_data_2d, r_byte_data_3d;
	always @(posedge byte_clk or negedge byte_rst_n) begin
		if (~byte_rst_n) begin
			r_byte_data_en_1d <= 0;
			r_byte_data_en_2d <= 0;
			r_byte_data_en_3d <= 0;

			r_byte_data_1d <= 0;
			r_byte_data_2d <= 0;
			r_byte_data_3d <= 0;
			txfr_en_1d     <= 0;
		end
		else begin
			r_byte_data_en_1d <= byte_data_en;
			r_byte_data_en_2d <= r_byte_data_en_1d;
			r_byte_data_en_3d <= r_byte_data_en_2d;

			r_byte_data_1d <= byte_data;
			r_byte_data_2d <= r_byte_data_1d;
			r_byte_data_3d <= r_byte_data_2d;
			txfr_en_1d     <= txfr_en;
		end
	end


	logic pkt_format_ready_o, phdr_xfr_done_o, ld_pyld_o;
	wire [1:0] vc = 2'b00;

	tx_dphy_s_2lane i_tx_dphy_s_2lane (
		.clk_p_io             (tx_clk_p          ),
		.clk_n_io             (tx_clk_n          ),
		.d_p_io               (tx_d_p            ),
		.d_n_io               (tx_d_n            ),
		
		.ref_clk_i            (ref_clk           ),
		.reset_n_i            (rst_n & pll_lock_i),
		.pd_dphy_i            (~rst_n            ),
		.byte_or_pkt_data_i   (r_byte_data_3d    ),
		.byte_or_pkt_data_en_i(r_byte_data_en_3d ),
		.ready_o              (tx_rdy            ),
		.vc_i                 (vc                ),
		.dt_i                 (dt                ),
		.wc_i                 (wc                ),
		.clk_hs_en_i          ('1                ), // TBD: does this need a +ve going pulse to turn on the clock?
		.d_hs_en_i            (tx_req            ),
		.tinit_done_o         (tx_init_done      ),
		.pll_lock_o           (pll_lock_o        ),
		.pix2byte_rstn_o      (pix2byte_rstn     ),
		.pkt_format_ready_o   (pkt_format_ready_o),
		.d_hs_rdy_o           (txfr_en           ),
		.byte_clk_o           (byte_clk_o        ),
		.c2d_ready_o          (tx_c2d_rdy        ),
		.phdr_xfr_done_o      (phdr_xfr_done_o   ),
		.ld_pyld_o            (ld_pyld_o         ),
		.pll_clkop_i          (tx_pll_clk        ),
		.pll_clkos_i          (tx_pll_clk_90     ),
		.pll_lock_i           (pll_lock_i        ),
		.sp_en_i              (sp_en             ),
		.lp_en_i              (lp_en             )
	);

endmodule
`default_nettype wire
