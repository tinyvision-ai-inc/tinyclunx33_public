# Carrier tinyCamera

[Schematics](tinyCamera_v1.0_Schematic.pdf) |
[Assembly](tinyCamera_v1.0_Assembly.pdf)

The **tinyCamera** is a carrier for the tinyCLUNX33 SoM implementing an
USB camera device out of the SoM with an inexpensive 4-layer board:
A minimal yet complete example of hardware turning the SoM into a product.

![](images/carrier_tinycamera.png)

Connectors:
- USB-C connector for the FPGA 5 Gbit/s interface
- 1 \* Raspberry Pi Camera FPC connector with 
- 1 \* Hirose connector

Features:
- Allows implementing a compact USB3 camera with custom sensor
- No tool swapping of the SoM with the BaseBoard for reprogramming


## Pinout

TODO: switch to v2 and document the pinout as tables


## Parts featured

- Hirose
  [DF37NC-30DS-0.4V](https://www.hirose.com/product/p/CL0684-3313-5-51)
  30-pin connector

- Molex
  [0545482271](https://www.molex.com/en-us/products/part-detail/545482271?display=pdf)
  0.50mm Pitch FFC/FPC Connector

