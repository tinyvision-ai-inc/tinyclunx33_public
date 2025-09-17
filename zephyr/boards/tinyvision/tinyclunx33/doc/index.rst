.. _tinyclunx33:

tinyCLUNX33 SoM
###############


Overview
********

A production ready System-on-Module with the Lattice CrossLinkU-NX33 FPGA on-board.
RISC-V Zephyr OS, MIPI, USB2/3 PHY for Robotics, Smart cameras, Machine vision and other USB3 applications.

.. figure:: tinyclunx33.png
   :width: 800px
   :align: center
   :alt: tinyVision.ai tinyCLUNX33 module top view

   tinyVision.ai tinyCLUNX33 (Credit: <sales@tinyvision.ai>)


Hardware
********

25.4mm x 25.4mm x 4.5mm module, commercial temperature grade: 0°C to 85°C

Connector:

* 2x Hirose high density DF40C 60 pin connectors
* proven on thousands of SoM's in the field in high vibration environments
* Spare pins for future proofing

2 flavors:

* Connectivity: 14 diff pairs, no SSRAM
* Compute: 8 diff pairs, 32 MB [oSPI/HyperRAM](som_memory.md) @ <0.5GBps

I/O interfaces:

* 3x fully programmable clocks
* GPIO, I2C, field updates through FPGA or direct flash programming
* GPIO voltage is programmable

Firmware/RTL:

* Zephyr for control path on RISCv
* No code, graphical RTL generator with large # of IP blocks (under development)

Development boards:

* devkit for programming/debug
* tinyCamera board as a basis of a compact camera device
* extra adapter boards for various camera connectors and expansion


Supported Features
==================

[TODO: List of supported features and level of support in Zephyr]


Connections and IOs
===================

See the `Pinout <https://tinyclunx33.tinyvision.ai/md_som_pinout.html>`_
section of the documentation.


Programming and Debugging
*************************


Flashing
========

See the `Flash <https://tinyclunx33.tinyvision.ai/md_som_flash.html>`_
section of the documentation.


Debugging
=========

See the multiple "troubleshooting" sections of the documentation, such as
for the `Flash <https://tinyclunx33.tinyvision.ai/md_som_flash.html#autotoc_md29>`_ or
for the `FPGA <https://tinyclunx33.tinyvision.ai/md_som_fpga.html#autotoc_md40>`_.
`JTAG support <https://tinyclunx33.tinyvision.ai/md_som_jtag.html>`_ is on the roadmap.


References
**********

`tinyCLUNX33 documentation website <https://tinyclunx33.tinyvision.ai/>`_
