# Carrier BaseBoard

[Schematics](NXU_baseboard_v1.0_Schematic.pdf) |
[Assembly](NXU_baseboard_v1.0_Assembly.pdf)

The **baseboard** is a carrier for the tinyCLUNX33 SoM that brings all the pins
out to headers and connectors for ease of debugging.

![](images/carrier_baseboard.png)

Connectors:
- 2 \* expansion connectors for adapters boards (RPi FPC Camera, custom...)
- USB Type-C connector for the FTDI debug interface
- USB Type-C connector for the FPGA interface at 5 Gbit/s
- Pin headers for JTAG, SPI flash, I2C, GPIO, power
- SMA connector for the high-speed clock export
- Testpoints for probing and debugging

Features:
- USB integrated with a Type-C port controller
- 1 \* LED and 1 \* push button
- FTDI chip for JTAG, Flash SPI, UART access over USB USB
- No-tool insertion for plugging the SoM across a project and this baseboard
- Suitable for factory programming


## Pinout

TODO: switch to v2 and document the pinout as tables


## Parts featured

- FTDI
  [FT2232HL](https://ftdichip.com/wp-content/uploads/2020/07/DS_FT2232H.pdf)
  USB to Multipurpose UART/FIFO IC

- Diodes
  [PI5USB30213A](https://www.diodes.com/assets/Databriefs/PI5USB30213A-Product-Brief.pdf)
  Type-C Dual Role Port Controller

![](images/carrier_baseboard_schematic.png)
