import argparse

from litex.soc.integration.builder import Builder
from litex_main_soc import MainSoC

Builder(
    MainSoC("som", sys_clk_freq=80e6),
    compile_software=True,
    compile_gateware=True,
    csr_json="build/csr.som.json",
).build()
