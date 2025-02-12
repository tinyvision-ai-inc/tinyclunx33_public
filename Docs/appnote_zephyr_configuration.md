# Zephyr Configuration {#appnote_zephyr_configuration}

This app note describes the particular Zephyr configuration layout of the tinyCLUNX33.

The tinyCLUNX33 platform consists of several elements stacked on each others:

* **System-on-Chip (SoC)**
  ([`soc/tinyvision/tinyclunx33`](https://github.com/tinyvision-ai-inc/tinyvision_zephyr_sdk/tree/main/soc/tinyvision/tinyclunx33)):
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


## Devicetree configuraton

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
west build --board tinyclunx33@rev2/rtl_1_0_2 --shield tinyclunx33_devkit_rev2
                   ~~~~~~~~~~~ ~~~~ ~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   |           |    |         |
                   |           |    |         The optional shield argument,
                   |           |    |         also specifying the version.
                   |           |    |
                   |           |    The RTL version, which can be /custom for
                   |           |    fully custom RTLs (see below).
                   |           |
                   |           The board revision, which depends on which moment
                   |           you acquired the SoM and Devkit.
                   |
                   The base board name which in this case is always "tinyclunx33"
```


## Firmware for custom RTL

In case a custom RTL is built, with a custom video core, it is possible to start from the
[`app_custom_rtl`](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/tree/tinyclunx33_sdk/app_custom_rtl)
example, which shows the configuration of a top-level RTL.

The build command would then feature the `/custom` SoC name instead of i.e. `/rtl011`.

In the
[`app.overlay`](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/blob/tinyclunx33_sdk/app_custom_rtl/app.overlay)
file, it is still possible to configure existing cores present in the other RTL releases if you use
them, such as the `uvcmanager`.
You can then `#include` the relevant file, which will add the complete block, then enable the core
with `status = "okay"`, and if needed, interconnect the core with a line similar to
`remote-endpoint-label = "uvcmanager0_ep_in"`.

An example of custom driver is included in the
[`tinyclunx33_zephyr_example`](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/blob/tinyclunx33_sdk/drivers/video/example.c)
repository, showing how to define a video driver in the application repository, and how to integrate
it into the rest of the firmware.

The resolutions configured in the video driver would be the resolutions configured on the USB Video
Class (UVC) device visible on the host system. That is, if you declare 3 resolutions in the driver,
the host would see 3 resolutions supported.

Unlike most Zephyr video drivers, the `video_enqueue()` and `video_dequeue()` functions are not to
be implemented, as Zephyr is not involved in the actual data movement, but only the control part.
