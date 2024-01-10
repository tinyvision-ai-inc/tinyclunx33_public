import argparse

from litex.soc.integration.builder import Builder
from litex_main_soc import MainSoC

Builder(
    MainSoC("som", sys_clk_freq=60e6, rom_size=0xfa00, sram_size=0x1000),
    compile_software=True,
    compile_gateware=False,
    csr_json="build/csr.som.json",
).build()
