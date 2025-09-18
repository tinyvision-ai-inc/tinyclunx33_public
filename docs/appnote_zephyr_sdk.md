# Zephyr SDK {#appnote_zephyr_sdk}

![](images/zephyr.png)


## Repositories

The tinyCLUNX33 has an open-core model:

- [`tinyclunx33`](https://github.com/tinyvision-ai-inc/tinyclunx33)
  The **open-source part**: the base of the zephyr support: SoC and board definition and associated drivers and sample code.

- [`priv-tvai-usb`](https://github.com/tinyvision-ai-inc/priv-tvai-usb):
  The **private-access part** with extra resources for using the tinyCLUNX33 as a high-bandwidth video system.

The dependencies are managed with [West](https://docs.zephyrproject.org/latest/develop/west/index.html) like any Zephyr project.


## CI builds

The CI is rebuilding the firmware on every commit:

- `tinyclunx33` CI builds images are accessible here

- `priv-tvai-usb` CI builds images are accessible here


## Building the firmware

This guide uses the
[`tinyclunx33`](https://github.com/tinyvision-ai-inc/tinyclunx33)
sample application named `zephyr_shell`.

There are several targets for building the firmware, depending on what platform you wish to build on:

* **Board:** `tinyclunx33@rev1`, `tinyclunx33@rev2`
* **SoC:** `rtl_1_0`, `rtl_1_1`

Assuming a Board Rev2, a Devkit Rev2, and SoC RTLv1.0.3 being used:

1. Follow the general Zephyr to setup the build environment for your platform:
   <https://docs.zephyrproject.org/latest/develop/getting_started/index.html>

2. Reset the workspace directory you created from Zephyr's Getting Started Guide
   ```
   cd ~/zephyrproject
   rm -rf .west
   ```

3. Download the tinyCLUNX33 Zephyr example repository.
   This will also download the tinyVision Zephyr SDK as a dependency:
   ```
   west init -m https://github.com/tinyvision-ai-inc/tinyclunx33
   west update
   ```

4. Build a sample application from this example repository, for instance `zephyr_cdc_raw` for
   [RTLv1.0.3](https://github.com/tinyvision-ai-inc/tinyclunx33/releases/tag/rtl_1_0_3).
   ```
   cd tinyclunx33/firmware/zephyr_cdc_raw
   west build --board tinyclunx33@rev2/rtl_1_0
   ```

5. Then, program the firmware into the devkit, with the DEBUG interface connected.
   ```
   west flash
   ```

6. Disconnect and reconnect the USB ports to power cycle the board, then you can see
   logs by connecting the DEBUG interface and use the 2nd serial console that shows-up,
   such as `/dev/ttyUSB1` in Linux, at baud rate `156200`. Once connected, press the reset
   switch (`SW2` on the Devkit Rev 2) to see the early boot logs appear.

See also [SoM Flash](som_flash.md) for other flash programming options.

You should now be able to see messages through the UART interface,
a new USB Video Class (UVC) interface showing-up on your operating system,
and if an IMX219 image sensor is connected, a video stream coming out of it.


## Zephyr Configuration

This app note describes the particular Zephyr configuration layout of the tinyCLUNX33.

The tinyCLUNX33 platform consists of several elements stacked on each others:

* **System-on-Chip (SoC)**
  ([`soc/tinyvision/tinyclunx33`](https://github.com/tinyvision-ai-inc/tinyclunx33/tree/zephyr/main/soc/tinyvision/tinyclunx33)):
  describing the peripherals implemented by the FPGA. There is one SoC version for each FPGA system
  image version. Defined at the Zephyr level as an
  [SoC](https://docs.zephyrproject.org/latest/hardware/porting/soc_porting.html).

* **System-on-Module (SoM):**
  ([`boards/tinyvision/tinyclunx33`](https://github.com/tinyvision-ai-inc/tinyvision_zephyr_sdk/tree/main/boards/tinyvision/tinyclunx33))
  describing the elements present on the tinyCLUNX33 module, defined at the Zephyr level as a
  [board](https://docs.zephyrproject.org/latest/hardware/porting/board_porting.html).

* **Devkit:**
  ([`boards/shields/tinyclunx33_devkit`](https://github.com/tinyvision-ai-inc/tinyvision_zephyr_sdk/tree/main/boards/shields/tinyclunx33_devkit))
  describing the devkit carrier board on which the tinyCLUNX33 module plugs into, defined at the
  Zephyr level as a [shield](https://docs.zephyrproject.org/latest/hardware/porting/shields.html).


## Zephyr Devicetree Configuraton

Most of the configuration boils down to
[devicetrees](https://docs.zephyrproject.org/latest/build/dts/index.html),
which describe the topology of the hardware, and permit the build system to know what driver to
select, and how to interconnect them.

The SoC, board and shield level all have variants according to the different versions of the
hardware or RTL. The `west build` command allow to specify which version exactly to select.

The top level definition of the devicetree happens in the board directory, but these are only
1-line wrappers over the full configuration, located in the
[`dts/riscv/tinyvision`](https://github.com/tinyvision-ai-inc/tinyvision_zephyr_sdk/tree/main/dts/riscv/tinyvision)
directory where all the content is:

* **`tinyclunx33_add_...`:** These files can be included to add an extra block of ready-made
  configuration to a design. For instance, the
  [`tinyclunx33_add_opencores_i2c.dtsi`](https://github.com/tinyvision-ai-inc/tinyvision_zephyr_sdk/blob/main/dts/riscv/tinyvision/tinyclunx33_add_opencores_i2c.dtsi)
  file *or* the
  [`tinyclunx33_add_litex_i2c.dtsi`](https://github.com/tinyvision-ai-inc/tinyvision_zephyr_sdk/blob/main/dts/riscv/tinyvision/tinyclunx33_add_litex_i2c.dtsi)
  file can be included to configure which I2C peripheral is present.

* **`tinyclunx33_rtl...`:** These files contain the top-level configuration for the various SoCs,
  describing all their content, and including the other `tinyclunx33_add_...` files to fill their
  configuration.

* **`tinyclunx33_custom.dtsi`:** This file serves as a minimal starting point for implementing a
  custom SoC. This allows application `app.overlay` configuration to define their own custom
  pipeline from the base SoC provided by tinyVision.ai, only selecting the drivers for which a
  peripheral is actually present.


## Building a firmware for a particular SoC

These devicetree variants permit the firmware developer to swap the version of any part of the
design at a firmware level:

For instance, one might be interested in testing a different RTL version, and for this, need to
adapt the firmware to be built for the appropriate RTL version.

Or for instance, one might be building a same firmware going into the devkit, or a firmware going
into a prototype, with different hardware on each case, which would need adaptation.

In order to adapt the firmware to all these different situations it is possible to pass flags to the
`west build` command that will select the correct panaché:

```
west build --board tinyclunx33@rev2/rtl_1_0
                   ~~~~~~~~~~~ ~~~~ ~~~~~~~
                   |           |    |
                   |           |    |
                   |           |    |
                   |           |    |
                   |           |    The RTL version, which can be /custom for
                   |           |    fully custom RTLs (see below).
                   |           |
                   |           The board revision, which depends on which moment
                   |           you acquired the SoM and Devkit.
                   |
                   The base board name which in this case is always "tinyclunx33"
```


## Troubleshooting

The first sign of life from the Zephyr RTOS comes the UART interface, available by plugging the DEBUG USB cable.

In order to get early boot logs, you can hit the SW2 button which will reset the board but keep the serial console attached.

The Zephyr shell will be available over that same UART interface as the debug logs (except for the `zephyr_shell` sample code).
For the Shell example, this goes through the DATA USB port, `/dev/ttyACM0`.

These debug commands permit to review the internal state of the various peripherals.

If nothing comes through the UART, see the
[FPGA troubleshooting](https://tinyclunx33.tinyvision.ai/som_fpga.html#autotoc_md67)
section.
