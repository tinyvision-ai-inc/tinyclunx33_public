component tx_dphy_h is
    port(
        ref_clk_i: in std_logic;
        reset_n_i: in std_logic;
        usrstdby_i: in std_logic;
        pd_dphy_i: in std_logic;
        byte_or_pkt_data_i: in std_logic_vector(15 downto 0);
        byte_or_pkt_data_en_i: in std_logic;
        ready_o: out std_logic;
        vc_i: in std_logic_vector(1 downto 0);
        dt_i: in std_logic_vector(5 downto 0);
        wc_i: in std_logic_vector(15 downto 0);
        clk_hs_en_i: in std_logic;
        d_hs_en_i: in std_logic;
        tinit_done_o: out std_logic;
        pll_lock_o: out std_logic;
        pix2byte_rstn_o: out std_logic;
        pkt_format_ready_o: out std_logic;
        d_hs_rdy_o: out std_logic;
        byte_clk_o: out std_logic;
        c2d_ready_o: out std_logic;
        phdr_xfr_done_o: out std_logic;
        ld_pyld_o: out std_logic;
        clk_p_io: inout std_logic;
        clk_n_io: inout std_logic;
        d_p_io: inout std_logic_vector(1 downto 0);
        d_n_io: inout std_logic_vector(1 downto 0);
        sp_en_i: in std_logic;
        lp_en_i: in std_logic
    );
end component;

__: tx_dphy_h port map(
    ref_clk_i=>,
    reset_n_i=>,
    usrstdby_i=>,
    pd_dphy_i=>,
    byte_or_pkt_data_i=>,
    byte_or_pkt_data_en_i=>,
    ready_o=>,
    vc_i=>,
    dt_i=>,
    wc_i=>,
    clk_hs_en_i=>,
    d_hs_en_i=>,
    tinit_done_o=>,
    pll_lock_o=>,
    pix2byte_rstn_o=>,
    pkt_format_ready_o=>,
    d_hs_rdy_o=>,
    byte_clk_o=>,
    c2d_ready_o=>,
    phdr_xfr_done_o=>,
    ld_pyld_o=>,
    clk_p_io=>,
    clk_n_io=>,
    d_p_io=>,
    d_n_io=>,
    sp_en_i=>,
    lp_en_i=>
);
