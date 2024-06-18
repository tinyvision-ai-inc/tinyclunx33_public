//`default_nettype none

module mipi_to_pixel #(
	parameter NUM_RX_LANE = 2 ,
	parameter RX_GEAR     = 8 ,
	parameter DT_WIDTH    = 10  // Width of data coming out, will depend on data format
) (
	// MIPI pins
	inout  wire                           rx_clk_p     ,
	inout  wire                           rx_clk_n     ,
	inout  wire [        NUM_RX_LANE-1:0] rx_d_p       ,
	inout  wire [        NUM_RX_LANE-1:0] rx_d_n       ,
	// Clocks and reset
	input  wire                           sync_clk     ,
	input  wire                           rst_n        ,
	input  wire                           pll_lock     ,
	input  wire                           byte_clk_i   , // Needed for a soft DPHY
	output wire                           byte_clk_o   ,
	input  wire                           tx_rdy_i     ,
	input  wire [                    5:0] ref_dt       ,
	// Pixel stream
	input  wire                           pixel_clk    ,
	input  wire                           pixel_rst_n  ,
	output wire                           pixel_fv     ,
	output wire                           pixel_lv     ,
	output wire [           DT_WIDTH-1:0] pixel_data   ,
	output wire [                   15:0] rx_wc        ,
	output wire                           hs_sync      ,
	output wire                           hs_d_en      ,
	output wire                           rx_lp_en     ,
	output wire                           rx_lp_av_en  ,
	output wire [NUM_RX_LANE*RX_GEAR-1:0] rx_payload   ,
	output wire                           rx_payload_en,
	output wire [                    5:0] rx_dt
);

	wire byte_clk = byte_clk_i;

	// Create reset's sync'ed up to the local domains
	wire pixel_clk_rst_n, byte_clk_rst_n;

	rst_sync u_rst_sync_byte_clk (
		.clk        (byte_clk         ),
		.async_rst_n(rst_n  & pll_lock),
		.sync_rst_n (byte_clk_rst_n   )
	);

	logic sync_rst_n;
	rst_sync u_rst_sync_sync_clk (
		.clk        (sync_clk         ),
		.async_rst_n(rst_n  & pll_lock),
		.sync_rst_n (sync_rst_n       )
	);


	wire [1:0] rx_lp_hs_state_d, rx_lp_hs_state_clk;
	wire    #1 rx_sp_en;
	wire       rx_hs_d_en, rx_hs_sync, rx_term_clk_en;
	wire [1:0] rx_term_d_en;

	rx_dphy_s_2lane rx_ch (
		.pll_lock_i       (pll_lock          ),
		.sync_clk_i       (sync_clk          ),
		.sync_rst_i       (~sync_rst_n       ),
//		.pd_dphy_i        ('0                 ),
		.clk_byte_o       (byte_clk_o        ),
		.clk_byte_hs_o    (                  ),
		.clk_byte_fr_i    (byte_clk_i        ),
		.clk_lp_ctrl_i    (byte_clk_i        ),
		.reset_lp_n_i     (byte_clk_rst_n    ),
		.reset_n_i        (rst_n             ),
		.reset_byte_n_i   (byte_clk_rst_n    ),
		.reset_byte_fr_n_i(byte_clk_rst_n    ),
		.clk_p_io         (rx_clk_p          ),
		.clk_n_io         (rx_clk_n          ),
		.d_p_io           (rx_d_p            ),
		.d_n_io           (rx_d_n            ),
		.lp_d_rx_p_o      (                  ),
		.lp_d_rx_n_o      (                  ),
		.bd_o             (                  ),
		.cd_clk_o         (                  ),
		.cd_d0_o          (                  ),
		.hs_d_en_o        (rx_hs_d_en        ),
		.hs_sync_o        (rx_hs_sync        ),
		.lp_hs_state_clk_o(rx_lp_hs_state_clk),
		.lp_hs_state_d_o  (rx_lp_hs_state_d  ),
		.term_clk_en_o    (rx_term_clk_en    ),
		.term_d_en_o      (rx_term_d_en      ),
		.ready_o          (                  ),
		.payload_en_o     (rx_payload_en     ),
		.payload_o        (rx_payload        ),
		.dt_o             (rx_dt             ),
		.vc_o             (                  ),
		.wc_o             (rx_wc             ),
		.ecc_o            (                  ),
		.ref_dt_i         (ref_dt            ),
		.tx_rdy_i         (tx_rdy_i          ),
		.sp_en_o          (rx_sp_en          ),
		.lp_en_o          (rx_lp_en          ),
		.lp_av_en_o       (rx_lp_av_en       ),
		.rxdatsyncfr_state_o(),
		.rxemptyfr0_o(),
		.rxemptyfr1_o(),
		.rxfullfr0_o(),
		.rxfullfr1_o(),
		.rxque_curstate_o(),
		.rxque_empty_o(),
		.rxque_full_o()
//		.fifo_dly_err_o(),
//		.fifo_undflw_err_o(),
//		.fifo_ovflw_err_o()
	);

// Convert bytes to pixels
	b2p_2lane b2p (
		.reset_byte_n_i (byte_clk_rst_n),
		.clk_byte_i     (byte_clk      ),
		.sp_en_i        (rx_sp_en      ),
		.dt_i           (rx_dt         ),
		.lp_av_en_i     (rx_lp_av_en   ),
		.payload_en_i   (rx_payload_en ),
		.payload_i      (rx_payload    ),
		.wc_i           (rx_wc         ),
		.reset_pixel_n_i(pixel_rst_n   ),
		.clk_pixel_i    (pixel_clk     ),
		.fv_o           (pixel_fv      ),
		.lv_o           (pixel_lv      ),
		.pd_o           (pixel_data    ),
		.p_odd_o        (              ),
		.pixcnt_c_o     (              ),
		.pix_out_cntr_o (              ),
		.wc_pix_sync_o  (              ),
		.write_cycle_o  (              )
		//.mem_we_o()
	);

	///// rx_payload_en mask logic to ignore non-video LP /////
	reg rx_active_payload, rx_lp_av_en_d;

	always @(posedge byte_clk or negedge byte_clk_rst_n) begin
		if (~byte_clk_rst_n)
			rx_lp_av_en_d <= 0;
		else
			rx_lp_av_en_d <= rx_lp_av_en;
	end

	always @(posedge byte_clk or negedge byte_clk_rst_n) begin
		if (~byte_clk_rst_n) begin
			rx_active_payload <= 0;
		end
		else if (rx_lp_av_en_d) begin
			rx_active_payload <= 1;
		end
		else if ( rx_active_payload & (~rx_payload_en)) begin
			rx_active_payload <= 0;
		end
	end


	// Debug outputs:
	assign hs_sync = rx_hs_sync;
	assign hs_d_en = rx_hs_d_en;

endmodule

`default_nettype wire