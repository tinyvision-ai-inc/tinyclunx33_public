# Zephyr SDK {#appnote_zephyr_sdk}

<div class="grid">
[Source](https://github.com/tinyvision-ai-inc/tinyvision_zephyr_sdk/)
[Example project](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/)
[Example binaries](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/releases/)
</div>

![](images/zephyr.png)


## Repositories

- [`zephyr`](https://github.com/tinyvision-ai-inc/zephyr):
  A public **fork of Zephyr** is maintained for contributing patches to the Zephyr Project: the
  `usb3` branch contains modifications that are required for the tinyCLUNX33 to work with USB3,
  and are in the process of being upstreamed.
  For everything else, the upstream Zephyr repository is used unchanged.

- [`tinyvision_zephyr_sdk`](https://github.com/tinyvision-ai-inc/tinyvision_zephyr_sdk)
  The **tinyVision Zephyr SDK** contains additional drivers implemented by tinyVision.ai
  that are compatible with upstream Zephyr, which will also be upstreamed in the long term.
  This allows shipping features long before, without forking the entire Zephyr project.

- [`tinyclunx33_zephyr_example`](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example):
  The **tinyCLUNX33 Zephyr Example** repository is a starting point for new applications,
  and  makes use of the tinyVision Zephyr SDK.

The dependencies are managed the
[`west.yml`](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/blob/main/west.yml)
file.
The example repository contains a
[`west.yml`](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/blob/main/west.yml)
that has all the dependencies correctly setup already,
and more can be added for integrating 3rd-party code, or splitting a larger codebase in modules.


## Nightly builds

One way to be sure to reproduce the results would be the
[nightly builds](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/actions/workflows/getting_started_on_linux.yml),
which runs the
[`getting_started_on_linux.sh`](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/blob/main/getting_started_on_linux.sh)
script every night.

The build status can be seen on the
[tinyclunx33_zephyr_example](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/tree/main?tab=readme-ov-file#tinyclunx33-zephyr-example)
README.


## Building the firmware

This guide uses the
[`tinyclunx33_zephyr_example`](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example)
sample application named `app_shell`.

There are several targets for building the firmware, depending on what platform you wish to build on:

* **Shield:** `tinyclunx33_devkit_rev1`, `tinyclunx33_devkit_rev2`, `custom`
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
   west init -m https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example
   west update
   ```

4. Build a sample application from this example repository, for instance `app_shell` for
   [RTLv1.0.3](https://github.com/tinyvision-ai-inc/tinyclunx33_public/releases/tag/rtl_1_0_3).
   ```
   cd tinyclunx33_zephyr_example/app_shell
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


## Including the SDK into your existing project

In case your application was started without using the SDK, you may be interested in adding it as a dependency in
[`west.yml`](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/blob/main/west.yml),
by adding the following snippet at the bottom of the file:

```
...

    - name: tinyclunx33_sdk
      url: https://github.com/tinyvision-ai-inc/zephyr_internal
```


## Troubleshooting

The first sign of life from the Zephyr RTOS comes the UART interface, available by plugging the DEBUG USB cable.

In order to get early boot logs, you can hit the SW2 button which will reset the board but keep the serial console attached.

Depending on firmware configuration (see `chosen { zephyr,shell-uart = ...; }` property of `build/zephyr/zephyr.dts`),
the Zephyr shell will be available over that same UART interface.
For the Shell example, this goes through the DATA USB port, `/dev/ttyACM0`.

These debug commands permit to review the internal state of the USB peripheral, using subcommands of `dwc3`.

Interactive help is given by entering the `help dwc3` comand.

If nothing comes through the UART, see the
[FPGA troubleshooting](https://tinyclunx33.tinyvision.ai/som_fpga.html#autotoc_md67)
section.
