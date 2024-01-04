# SoM Memory

The FPGA fabric features several Distributed RAM and Embedded Block RAM (EBR)
that can be used through the RTL.

It also has two Large RAM (LRAM) blocks that provide can be used for storing
larger memory buffers, such as entire frames, or as CPU main memory.

![](images/som_memory_architecture.png)

The "compute" variant of the SoM additionally has an external Octal SPI or
HyperRAM memory installed and interconnected with the FPGA.

| Name                          | Num | Size (each) | Size (total)          |
|-------------------------------|-----|-------------|-----------------------|
| Embedded Block RAM (EBR)      | 64  | 18 kbit     | 1153 kbit / 144 kByte |
| Distributed RAM               | -   | 1 bit       | 220 kbit / 27.5 kByte |
| Large RAM (LRAM)              | 5   | 512 kbit    | 2560 kbit / 320 kByte |
| External OctalRAM or HyperRAM | 1   | 64 Mbit     | 64 Mbit / 8 MByte     |

## Hardware integration

TODO: Can the memory be directly accessed from the outside to communicate with
the FPGA through shared memory pages the ring the bell to notify new memory
is available? Some "letterbox" model.

## RTL Integration

RTL synthesis tools such as
[Lattice Radiant](https://www.latticesemi.com/Products/DesignSoftwareAndIP/FPGAandLDS/Radiant)
offer to place the Embedded Block RAM (EBR) and Distributed RAM as part of the
RTL language.

The LRAM has a blackbox-type module called NXLRAM that can be instancicated to
allocate a given NXLRAM block.

The [RTL Reference Design](rtl_reference_design.md) shows a possible
integration of the NXLRAM as well as a controller for the external RAM chip.

## Parts featured

- Lattice Semiconductor
  [LIFCL-33U-8CTG104CAS](https://www.latticesemi.com/Products/FPGAandCPLD/CrossLink-NX)
  FPGA (search for 33U in this page).

- Infineon
  [S27KS0641DPBHI020](https://www.infineon.com/dgdl/?fileId=8ac78c8c7d0d8da4017d0ed18c684db5)
  HyperRAM

- AP Memory Octal SPI RAM (alternative)

![](images/som_ram_schematic.png)
