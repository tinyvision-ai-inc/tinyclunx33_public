# Carrier tinyCamera

[Schematics](tinyCamera_v1.0_Schematic.pdf) |
[Assembly](tinyCamera_v1.0_Assembly.pdf)

The **tinyCamera** is a carrier for the tinyCLUNX33 SoM implementing an
USB camera device out of the SoM with an inexpensive 4-layer board:
A minimal yet complete example of hardware turning the SoM into a product.

![](images/carrier_tinycamera.png)

Connectors:
- 1 × USB Type-C connectors for the FPGA 5 Gbit/s interfaces
- 1 × MIPI Raspberry Pi Camera FPC connector with 
- 1 × MIPI Hirose connector
- 2 × IDC 1.27mm connector for JTAG, SPI flash, I2C, GPIO
- Extra headers for EN signals and power rails

Features:
- USB 5 Gbit/s integrated with a Type-C port controller
- GPIO LED and push button

Mechanical:
- Compact form factor fitting a small device
- No-tool setup of the SoM helping factory programming
- Mounting holes matching the Raspberry Pi Camera HQ layout


## Pinout

TODO: switch to v2 and document the pinout as tables


## Parts featured

- Hirose
  [DF37NC-30DS-0.4V](https://www.hirose.com/product/p/CL0684-3313-5-51)
  30-pin connector

- Molex
  [0545482271](https://www.molex.com/en-us/products/part-detail/545482271)
  0.50mm Pitch FFC/FPC Connector

- Diodes
  [PI5USB30213A](https://www.diodes.com/assets/Databriefs/PI5USB30213A-Product-Brief.pdf)
  Type-C Dual Role Port Controller

![](images/carrier_tinycamera_schematic.png)
