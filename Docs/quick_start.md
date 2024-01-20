# Quick Start

These are the instructions to be able to quickly test the
hardware, gateware, and firmware.

This assumes a command line environment:
Linux terminal, Mac OSX terminal, Windows with
[WSL](https://learn.microsoft.com/en-us/windows/wsl/install) or
[Git Bash](https://git-scm.com/download/win) or
[OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build)'s MinGW.

```bash
# Get the correct version number from https://github.com/tinyvision-ai-inc/tinyCLUNX33/releases
gw=v1.2.3

# Get the correct version number from https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/releases
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
