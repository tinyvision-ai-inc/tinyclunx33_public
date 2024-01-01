# Carrier BaseBoard

[Schematics](NXU_baseboard_v1.0_Schematic.pdf) |
[Assembly](NXU_baseboard_v1.0_Assembly.pdf)

The **baseboard** is a carrier for the tinyCLUNX33 SoM that brings all the pins
out to headers and connectors for ease of debugging.

![](images/carrier_baseboard.png)

Connectors:
- 2 × USB Type-C connectors for the FPGA 5 Gbit/s interfaces and FTDI debug
- 2 × QSE expansion connectors for adapter boards (RPi FPC Camera, custom...)
- 1 × SMA connector for the high-speed clock export
- 4 × headers for JTAG, SPI flash, I2C, GPIO
- Extra headers for EN signals and power rails

Features:
- USB 5 Gbit/s integrated with a Type-C port controller
- GPIO LED and push button
- FTDI chip for JTAG, Flash SPI, UART access over USB USB

Mechanical:
- Components on one side with fewer exposed traces at the bottom
- No-tool setup of the SoM helping factory programming
- Mounting holes for securing the board in a rig or enclosure


## Pinout

TODO: switch to v2 and document the pinout as tables


## Parts featured

- FTDI
  [FT2232HL](https://ftdichip.com/wp-content/uploads/2020/07/DS_FT2232H.pdf)
  USB to Multipurpose UART/FIFO IC

- Diodes
  [PI5USB30213A](https://www.diodes.com/assets/Databriefs/PI5USB30213A-Product-Brief.pdf)
  Type-C Dual Role Port Controller

- Samtec
  [QSE-020-01-F-D-A-K](https://suddendocs.samtec.com/productspecs/qse-qte.pdf)
  High-Speed Socket connector
  
![](images/carrier_baseboard_schematic.png)
