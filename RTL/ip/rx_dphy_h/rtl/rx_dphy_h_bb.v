/*******************************************************************************
    Verilog netlist generated by IPGEN Lattice Radiant Software (64-bit)
    3.2.1.217.3
    Soft IP Version: 1.3.0
    2022 11 01 14:30:01
*******************************************************************************/
/*******************************************************************************
    Wrapper Module generated per user settings.
*******************************************************************************/
module rx_dphy_h (clk_byte_o, clk_byte_hs_o, clk_byte_fr_i, reset_n_i,
    reset_byte_n_i, reset_byte_fr_n_i, clk_p_io, clk_n_io, d_p_io, d_n_io,
    lp_d_rx_p_o, lp_d_rx_n_o, bd_o, cd_clk_o, cd_d0_o, hs_d_en_o, hs_sync_o,
    lp_hs_state_clk_o, lp_hs_state_d_o, term_clk_en_o, term_d_en_o,
    payload_en_o, payload_o, dt_o, vc_o, wc_o, ecc_o, ref_dt_i, tx_rdy_i,
    pd_dphy_i, sp_en_o, lp_en_o, lp_av_en_o, rxdatsyncfr_state_o, rxemptyfr0_o,
    rxemptyfr1_o, rxfullfr0_o, rxfullfr1_o, rxque_curstate_o, rxque_empty_o,
    rxque_full_o)/* synthesis syn_black_box syn_declare_black_box=1 */;
    output  clk_byte_o;
    output  clk_byte_hs_o;
    input  clk_byte_fr_i;
    input  reset_n_i;
    input  reset_byte_n_i;
    input  reset_byte_fr_n_i;
    inout  clk_p_io;
    inout  clk_n_io;
    inout  [1:0]  d_p_io;
    inout  [1:0]  d_n_io;
    output  [1:0]  lp_d_rx_p_o;
    output  [1:0]  lp_d_rx_n_o;
    output  [15:0]  bd_o;
    output  cd_clk_o;
    output  cd_d0_o;
    output  hs_d_en_o;
    output  hs_sync_o;
    output  [1:0]  lp_hs_state_clk_o;
    output  [1:0]  lp_hs_state_d_o;
    output  term_clk_en_o;
    output  [1:0]  term_d_en_o;
    output  payload_en_o;
    output  [15:0]  payload_o;
    output  [5:0]  dt_o;
    output  [1:0]  vc_o;
    output  [15:0]  wc_o;
    output  [7:0]  ecc_o;
    input  [5:0]  ref_dt_i;
    input  tx_rdy_i;
    input  pd_dphy_i;
    output  sp_en_o;
    output  lp_en_o;
    output  lp_av_en_o;
    output  [1:0]  rxdatsyncfr_state_o;
    output  rxemptyfr0_o;
    output  rxemptyfr1_o;
    output  rxfullfr0_o;
    output  rxfullfr1_o;
    output  [1:0]  rxque_curstate_o;
    output  rxque_empty_o;
    output  rxque_full_o;
endmodule