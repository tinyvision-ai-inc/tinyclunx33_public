# Zephyr integration

[Source](https://github.com/tinyvision-ai-inc/zephyr_private/) |
[Example](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/) |
[Release](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/releases/)

On the [RTL Reference Design](rtl_reference_design.md) of the FPGA, there is the a RISC-V soft-CPU integrated.
This allows to run a firmware, and an RTOS such as [Zephyr](https://docs.zephyrproject.org/) with an USB stack and USB drivers.
The firmware is loaded into the flash after the FPGA image, and the RISC-V soft CPU starts it.


## Features

- A Driver for Lattice USB23
- The Zephyr USB stack
- An UVC device class
- UART for debug logs over the FTDI (on the devkit)
- I2C control for sensors
- Any other driver alrelady present on Zephyr
- etc. (about anything Zephyr can do)


## Getting started

Follow the Zephyr guide up to the point to build the "blinky" example:
<https://docs.zephyrproject.org/latest/develop/getting_started/index.html>

Follow the extra steps for any tinyCLUNX33 example:
<https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/>

Or follow this longer step-by-step guide including both the install of Zephyr tools and the build process.
<https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/blob/main/README.ubuntu.md>


## Repositories organization

Fork of Zephyr: how our development is organized

- [`zephyr_internal`](https://github.com/tinyvision-ai-inc/zephyr_internal):
  where the development happens, the `zephyr_internal` branch acts as a `dev` branch

- [`zephyr_private`](https://github.com/tinyvision-ai-inc/zephyr_private):
  releases of the `zephyr_internal` repo, the `zephyr_private` branch acts as a `main` branch.
  You can ask the access to it to tinyVision.ai Inc.

- [`zephyr_public`](https://github.com/tinyvision-ai-inc/zephyr):
  only used for public contributions to Zephyr, and not relevant for using the tinyCLUNX33 at this time.

Example repository: all you need to get started.

- [`tinyclunx33_zephyr_example`](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example):
  the top-level repository that contains the example, and points at the `zephyr_private` repo, downloaded in chain by the
  [`west`](https://docs.zephyrproject.org/latest/develop/west/index.html) build tool.
