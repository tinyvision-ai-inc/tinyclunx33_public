# SoM FPGA

The tinyCLUNX33 SoM features the CrossLinkU-NX FPGA with 33k LUT, codename LIFCL-33U.

It features an integrated USB2 and USB3 MAC as well as an USB2 and USB3 PHY.

Programming the FPGA is done by writing the bitfile to the [Flash](som_flash.md)
that is attached to it. Upon power on, the FPGA will load it out of the first
512 kBytes, and operate the custom hardware described on that flash.


## Hardware integration

As seen in the [SoM Power](som_power.md) page, the I/O voltage levels of the
FPGA can be adapted through the PVDD pins, which are connected to the VCCIO
pins of the FPGA, controlling the banks voltage level.


## RTL integration

The [RTL Reference Design](rtl_reference_design.md) provides the foundation of
a system, on top of which the application can be implemented.

| Resource                 | Num or Size (total)   |
|--------------------------|-----------------------|
| Logic Cells              | 33k                   |
| 18*18 Multipliers        | 64                    |
| Embedded Block RAM (EBR) | 1152 kbit / 144 kByte |
| Distributed RAM          | 220 kbit / 27.5 kByte |
| Large RAM (LRAM)         | 2560 kbit / 320 kByte |
| 450 MHz Oscillator       | 1                     |
| 128 kHz Oscillator       | 1                     |
| GPLL                     | 1                     |
| USB2/USB3 MAC+PHY        | 1                     |


## Parts featured

- Lattice Semiconductor
  [LIFCL-33U-8CTG104CAS](https://www.latticesemi.com/Products/FPGAandCPLD/CrossLink-NX)
  FPGA (search for 33U in this page).
