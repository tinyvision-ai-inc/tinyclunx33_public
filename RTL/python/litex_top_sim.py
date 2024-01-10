import argparse

from litex.soc.integration.builder import Builder
from litex_main_soc import MainSoC

Builder(
    MainSoC("sim", sys_clk_freq=1e6),
    compile_software=False,
    compile_gateware=True,
    csr_json="build/csr.sim.json",
).build()
