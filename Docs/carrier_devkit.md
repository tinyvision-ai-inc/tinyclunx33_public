# Carrier Devkit

[Schematics](NXU_devkit_v2.0_Schematic.pdf) |
[Assembly](NXU_devkit_v2.0_Assembly.pdf)

The **Devkit** is a carrier for the tinyCLUNX33 SoM that eases product
development and debugging:
A development kit usable as factory programming/test rig.

![](images/carrier_devkit.png)

Features:
- All SoM pins exposed, additional probing and voltage pins
- Inexpensive 4-layer board, compact form-factor
- USB3 at 5 Gbit/s integrated with a Type-C port controller
- GPIO LED and push button
- FTDI chip for JTAG, Flash SPI, UART access over USB

Connectors:
- 2 - USB-C connectors for the FPGA 5 Gbit/s interfaces and FTDI debug
- 2 - QSE expansion connectors for adapter boards (RPi FPC Camera, custom...)
- 1 - SMA connector for the high-speed clock export
- 4 - headers for JTAG, SPI flash, I2C, GPIO
- Extra headers for EN signals and power rails

Mechanical:
- Components on one side with fewer exposed traces at the bottom
- No-tool setup of the SoM helping factory programming
- Mounting holes for securing the board in a rig or enclosure


## Quick Start

> **This only applies to the latest version of the [Devkit](carrier_devkit.md) and SoM**

These are the instructions to be able to quickly test the
hardware, gateware, and firmware.

This assumes a command line environment:
Linux terminal, Mac OSX terminal, Windows with
[WSL](https://learn.microsoft.com/en-us/windows/wsl/install) or
[Git Bash](https://git-scm.com/download/win) or
[OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build)'s MinGW.

Or alternatively, using the [Radiant Programmer](https://tinyclunx33.tinyvision.ai/md_som_flash.html#autotoc_md25) is also possible.

Follow the install instructions from the [latest release page](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/releases/latest).

Then, unplug all USB cables to completely power off the board.
Then, connect to the board using a serial console viewer, such as minicom, picocom,
[PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html),
[teraterm](https://sourceforge.net/projects/tera-term/),
or other tool of your preference.

The baud rate is `115200`, and all other parameters might be left to default:

The serial interface is the 2nd of the FTDI, for instance, on Linux, instead of `/dev/ttyUSB0`, it would be `/dev/ttyUSB1`:

```
picocom -b 115200 /dev/ttyUSB1
```

Then, pressing "Enter" should give an access to the Zephyr shell, displaying only `uart:$`.


## Revisions

| Name                | Label on Board               | SoM  | Adapter | Sch       | Asm       | Img       |
|---------------------|------------------------------|------|---------|-----------|-----------|-----------|
| DevkitRev0 (EOL)    | none                         | Rev0 | Custom  | [pdf][s0] | [pdf][a0] | [png][i0] |
| DevkitRev1 (EOL)    | tiny SoM Developer Kit       | Rev1 | Custom  | [pdf][s1] | [pdf][a1] | [png][i1] |
| DevkitRev2 (Active) | tiny SoM Developer Kit Rev 2 | Rev2 | SYZYGY  | [pdf][s2] | [pdf][a2] | [png][i2] |

[s0]: tinyCLUNX33_DevkitRev0_Schematic.pdf
[a0]: tinyCLUNX33_DevkitRev0_Assembly.pdf
[i0]: tinyCLUNX33_DevkitRev0_Preview.png
[s1]: tinyCLUNX33_DevkitRev1_Schematic.pdf
[a1]: tinyCLUNX33_DevkitRev1_Assembly.pdf
[i1]: tinyCLUNX33_DevkitRev1_Preview.png
[s2]: tinyCLUNX33_DevkitRev2_Schematic.pdf
[a2]: tinyCLUNX33_DevkitRev2_Assembly.pdf
[i2]: tinyCLUNX33_DevkitRev2_Preview.png


## Parts featured

- FTDI
  [FT2232HL](https://ftdichip.com/wp-content/uploads/2020/07/DS_FT2232H.pdf)
  USB to Multipurpose UART/FIFO IC

- Diodes
  [PI5USB30213A](https://www.diodes.com/assets/Databriefs/PI5USB30213A-Product-Brief.pdf)
  Type-C Dual Role Port Controller

- Samtec
  [QSE-020-01-F-D-A-K](https://suddendocs.samtec.com/productspecs/qse-qte.pdf)
  High-Speed Socket connector
  
![](images/carrier_devkit_schematic.png)
