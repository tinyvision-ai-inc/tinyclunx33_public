# SoM USB

The LIFCL-33U FPGA part of the CrosslinkU-NX series contains a hard USB3 core
capable of 5 Gbit/s transfers.

## Hardware integration

An external PHY is not required as the LIFCL-33U provides an integrated
USB2 and USB3 PHY.

For USB2 FullSpeed (1.5 Mbit/s) and USB2 HighSpeed (12 Mbit/s) operation,
the two USB D+/- pins can be routed to a connector,
with proper ESD protection.

For USB3 SuperSpeed (5 Gbit/s) operation, the two USB SS TX+/- and two
USB SS RX+/- pins all need to be routed to a connector,
with proper ESD protection.

In the case of Type-C, an intermediate Type-C management chip can optionally be
used to offer extended power capability of the device, but is not required if
ignoring the extra Type-C functions.

## RTL integration

A CPU core is required to manage the complexity of the hard USB core.

TODO: Complete the integration of the new RTL VexRiscv core

## Zephyr integration

A Zephyr driver for the tinyCLUNX33 hard USB core "USB23" was written.

It can be selected at build-time like any other USB driver in Zephyr.

It implements the new
[Zephyr USB Device API](https://zephyrproject.org/zephyr-rtos-usb/)
known as
[`device_next`](https://docs.zephyrproject.org/latest/connectivity/usb/device_next/usb_device.html).

It complies to the Zephyr driver API, and the general documentation can be used
for configuring USB.

TODO: Send a merge request for the Zephyr driver and link it there

TODO: Provide a sample repository with a complete Zephyr firmware, along with
binaries, and publish a link here.

## Parts used

- Lattice Semiconductor
  [LIFCL-33U](https://www.latticesemi.com/Products/FPGAandCPLD/CrossLink-NX)
  FPGA

![](images/som_usb.png)
