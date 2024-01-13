create_clock -name {clk_2} -period 41.6666666666667 [get_ports clk_2]
create_clock -name {byte_clk} -period 20 [get_nets byte_clk]
create_clock -name {hf_clk} -period 20 [get_nets hf_clk]
create_clock -name {pixel_clk} -period 12.5 [get_nets pixel_clk]
create_clock -name {tx_clk} -period 5 [get_nets {tx_clk tx_clk_90}]
create_clock -name {sync_clk} -period 10 [get_nets sync_clk]
#DISABLED# ldc_define_attribute -attr syn_preserve -value 1 -object_type net -object {byte_clk}
