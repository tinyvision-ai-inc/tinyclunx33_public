# Zephyr SDK {#appnote_zephyr_sdk}

> The following document describe the current organization with forks
> of Zephyr used by tinyCLUNX33 users.
> This approach has flaws, and is being replaced by the `tinyclunx33_sdk`
> as introduced on @ref appnote_firmware..

[Source](https://github.com/tinyvision-ai-inc/zephyr_private/) |
[Example](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/) |
[Release](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/releases/)

On the [RTL Reference Design](rtl_reference_design.md) of the FPGA, there is the a RISC-V soft-CPU integrated.
This allows to run a firmware, and an RTOS such as [Zephyr](https://docs.zephyrproject.org/) with an USB stack and USB drivers.
The firmware is loaded into the flash after the FPGA image, and the RISC-V soft CPU starts it.

![](images/tinyclunx33_zephyr_architecture.drawio.png)


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


## Release process

For transparency, here is how tinyVision.ai performs a new [release](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/releases/) internally:

1. Build and test every example using the `zephyr_internal` repo and `zephyr_internal` branch,
   and commit as needed to fix the exapmles.

2. Once all the examples work, run [`blobify.sh`](https://github.com/tinyvision-ai-inc/zephyr_private/blob/zephyr_private/drivers/usb/udc/blobify.sh)
   to obfuscate the function names from [`udc_usb23blob.c`](https://github.com/tinyvision-ai-inc/zephyr_internal/blob/zephyr_internal/drivers/usb/udc/udc_usb23blob.c).

3. Build any example another time to generate [`udc_usb23blob.c.obj`](https://github.com/tinyvision-ai-inc/zephyr_private/blob/zephyr_private/drivers/usb/udc/udc_usb23blob.c.obj)
   and commit it on the `zephyr_internal_blob` branch.

4. Import the content of the `zephyr_internal_blob` branch onto `zephyr_private` with `git checkout zephyr_private` then `git checkout --no-overlay zephyr_internal_blob`.

5. Remove the `udc_usb23blob.c` file and commit the result into the `zephyr_private` branch,
   with a message indicating which commit of `zephyr_internal` this came from.

6. Re-test and re-build each example using the `zephyr_private` branch, and publish the generated files.


## Troubleshooting

The first sign of life from the Zephyr RTOS coming from the board will happen over the FTDI UART interface, available by plugging the DEBUG USB cable.

Once a serial console viewer is connected to the second interface (often numbered #1, such as `/dev/ttyUSB1`), logs will be available to review what is going on.

In order to get early boot logs, you can hit the SW2 button which will reset the board but keep the serial console attached.

On the logging interface directly, the Zephyr shell is available with debug commands, except for the Shell example for which it goes over a separate `/dev/ttyACM0`.

These debug commands permit to review the internal state of the driver using subcommands of `usb23`.

Their usage is described with tab completion.
