# SoM FAQ's


## Toolchain
Q: Is there a requirement to be on Windows, or can I use the Radiant tool with linux?
: You can use linux, Radiant has a linux installation available.

Q: Can the FPGA be programmed with the free licence version of the tool, or do I need the paid one?
: RISCV firmware and FPGA bitfiles can be programmed using either Radiant or `ecpprog` which is included with the [FOSS toolchain](https://github.com/FPGAwars/toolchain-icestorm/releases/). For any changes to the FPGA or to recompile the FPGA or to use it for debug, you will need the Radiant tool license which is free and available from [here](https://www.latticesemi.com/Support/Licensing#requestRadiant). Note that you may require additional licenses to complete your work for example, MIPI related components. For more details on how to flash the firmware, please refer to [SoM Flash](som_flash.md) for details.