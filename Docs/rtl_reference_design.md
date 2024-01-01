# RTL Reference Design

To facilitate the development of RTL projects, a Verilog implementation of a
working System-on-Chip (SoC) is provided.

TODO: Publish a block diagram of the various parts cores

TODO: Publish a relatively recent estimation of the LUT usage.

The former SoC was built on LiteX.

The new SoC is based on SpinalHDL Briey, and integrates the minimum required
for USB operation and integrating the fixed hardware


## External connection interface

A FIFO stream for piping data in/out USB3.
- \subpage TODO


## Internal fast AXI bus

The hard USB23 core AXI Master interface, issuing DMA requests to the memory:
- \subpage TODO

The Crosslink-NX Large RAM (LRAM) blocks of 64 kBytes each:
- \subpage TODO

A [VexRiscv](https://github.com/SpinalHDL/VexRiscv#area-usage-and-maximal-frequency)
CPU implementing the RISC-V RV32I specification:
- \subpage TODO

The external Octal SPI or HyperRAM chip.
- \subpage TODO


## Internal lower-speed peripheral bus

The hard USB23 core LMMI interface, used for controlling the core.

An QSPI, DDR, memory-mapped flash controller:
- \subpage TODO

An I2C controller used to program the [external Si5351 PLL](som_clocks.md):
- \subpage TODO

An UART for debug logs and bringup of software on the CPU:
- \subpage TODO
