# Carrier BaseBoard

[Schematics](NXU_baseboard_v1.0_Schematic.pdf) |
[Assembly](NXU_baseboard_v1.0_Assembly.pdf)

The **baseboard** is a carrier for the tinyCLUNX33 SoM that brings all the pins
out to headers and connectors for ease of debugging.

![](images/carrier_baseboard.png)

- Adapter boards for various camera connectors, easy to make custom ones
- FTDI chip for JTAG, Flash SPI, UART access over USB USB
- All other signals broken out to pin headers
- No-tool insertion of the SoM, suitable for factory programming
- Numerous testpoints for probing and debugging


## Parts featured

- FTDI
  [FT2232HL](https://ftdichip.com/wp-content/uploads/2020/07/DS_FT2232H.pdf)
  USB to Multipurpose UART/FIFO IC
