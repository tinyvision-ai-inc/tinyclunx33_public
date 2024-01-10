component int_gpll is
    port(
        clki_i: in std_logic;
        rstn_i: in std_logic;
        clkop_o: out std_logic;
        lock_o: out std_logic
    );
end component;

__: int_gpll port map(
    clki_i=>,
    rstn_i=>,
    clkop_o=>,
    lock_o=>
);
