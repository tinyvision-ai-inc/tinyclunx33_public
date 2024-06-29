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
- 2 × USB-C connectors for the FPGA 5 Gbit/s interfaces and FTDI debug
- 2 × QSE expansion connectors for adapter boards (RPi FPC Camera, custom...)
- 1 × SMA connector for the high-speed clock export
- 4 × headers for JTAG, SPI flash, I2C, GPIO
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

```bash
# Latest number from https://github.com/tinyvision-ai-inc/tinyCLUNX33/releases
gw=v1.2.3

# Latest number from https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/releases
fw=v1.2.3

# check that the QE mode is "enabled"
ecpprog -tv 2>&1 | grep QE:

# Download both releases
curl -LO https://github.com/tinyvision-ai-inc/tinyCLUNX33/releases/download/$gw/tinyclunx33_rtl_reference_design.$gw.bit
curl -LO https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/releases/download/v0.0/tinyclunx33_zephyr_example_v0.0.bin

# Program both releases to the FPGA Flash
ecpprog -o 0x000000 tinyclunx33_rtl_reference_design.v0.1.bit
ecpprog -o 0x100000 tinyclunx33_zephyr_example_v0.0.bin
```

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

| Rev | Distributed  | Debug Plug | Label on Board                | SYZYGY        | Sch       | Asm       |
|-----|--------------|------------|-------------------------------|---------------|-----------|-----------|
| v1  | never        | micro USB  | none                          | incompatible  | [pdf][s1] | [pdf][a1] |
| v2  | early users  | USB-C      | "tiny SoM Developer Kit"      | incompatible  | [pdf][s2] | [pdf][a2] |
| v3  | early users  | USB-C      | "tiny SoM Developer Kit v2.0" | STD v1.1.1    | [pdf][s3] | [pdf][a3] |

[s1]: NXU_devkit_v1.0_Schematic.pdf
[a1]: NXU_devkit_v1.0_Assembly.pdf
[s2]: NXU_devkit_v2.0_Schematic.pdf
[a2]: NXU_devkit_v2.0_Assembly.pdf
[s3]: NXU_devkit_v3.0_Schematic.pdf
[a3]: NXU_devkit_v3.0_Assembly.pdf


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
