# RTL Reference Design

To facilitate the development of RTL projects, a Verilog implementation of a
working System-on-Chip (SoC) is provided.

TODO: Publish a block diagram of the various parts cores

These cores are integrated around an AXI bus:

- The hard USB23 core LMMI interface, used for controlling the core.

- The hard USB23 core AXI Master interface, issuing DMA requests to the memory.

- The two Crosslink-NX Large RAM (LRAM) blocks of 64 kBytes each.

- The external Octal SPI or HyperRAM chip.

- A [VexRiscv](https://github.com/SpinalHDL/VexRiscv#area-usage-and-maximal-frequency)
  CPU implementing the RISC-V RV32I specification.

- An QSPI, DDR, memory-mapped flash controller.

- An I2C controller used to program the [external Si5351 PLL](som_clocks.md).

- An UART for debug logs and bringup of software on the CPU.

The cores documented are:

- \subpage fpga_top

TODO: Publish a relatively recent estimation of the LUT usage.
