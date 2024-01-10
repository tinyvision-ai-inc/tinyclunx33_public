[Doc](https://tinyclunx33.tinyvision.ai/) |
[Hardware](https://github.com/tinyvision-ai-inc/tinyCLUNX33/tree/main/Schematics) |
[Firmware](https://docs.zephyrproject.org/latest/boards/riscv/tinyclunx33/doc/index.html) |
[Schematic](tinyCLUNX33_v2.0_Schematic.pdf) |
[Assembly](tinyCLUNX33_v2.0_Assembly.pdf) |
[Discord](https://discord.gg/yjVc6P3sCt)

# tinyCLUNX33 SoC with LiteX

The **tinyCLUNX** module features the Lattice CrossLinkU-NX (LIFCL-33U) FPGA
suitable for interfacing MIPI cmeras or other high-speed differential pairs
signals with USB3 at 5 Gbit/s.

The build uses a Makefile, and assumes a command-line environment, such
as MacOSX or Linux or BSD or WSL2/GitBash/CygWin on Windows.

If you only need to obtain a default setup, you may use a
[release](https://github.com/tinyvision-ai-inc/tinyCLUNX33/releases)
build and only modify the firmware.

## Build the SoC with LiteX

```shell
# Get the repository
git clone --depth 1 https://github.com/tinyvision-ai-inc/tinyCLUNX33
cd tinyCLUNX33/RTL

# Optional: use a python virtual environment
python3 -m venv .venv
. .venv/bin/activate

# Install the LiteX RTL generator starting with its dependencies
sudo apt install binutils-riscv64-unknown-elf
sudo apt install gcc-riscv64-unknown-elf
make setup

# Generate the SoC with LiteX
make
```

## Build the bitfile with Radiant

[Lattice Radiant](https://www.latticesemi.com/LatticeRadiant) can be downloaded
and run with the `fpga_top_som.rdf` configuration file.

A License will be required, and can be requested to Lattice
[here](https://www.latticesemi.com/Support/Licensing#requestRadiant).

## Program the bitfile into the FPGA

The produced FPGA bitfile then needs to be loaded into the FPGA.

You may install the [ecpprog](https://github.com/gregdavill/ecpprog) project
for an open-source programmer that works with the CrossLink family of devices.

```
# Load the bitfile using the FTDI chip present on the Devkit baseboard
ecpprog impl/*.bit
```

As soon as the board restarts, it will load the hardware model with a
VexRiscv-based CPU running firmware at offset 0x00100000 within the flash
(XIP, mapped to 0x20100000).

## Build and run bare metal firmware without an RTOS

LiteX can also generate firmware libraries matching the RTL, that can be used
to drive the various peripherals.

```
# Build the library matching the LiteX SoC configuration
make software

# Compile the firmware
cd ../Firmware/example_i2c_init
make

# Program it onto the board after the bitfile
ecpprog -o 0x00100000 firmware.bin
```

## Connecting over UART

You can read the Zephyr debug logs over UART by connecting to it through the
FTDI chip.

Note that `litex_term` will not work properly when using Git bash on Windows 11.
You must run this program on the Powershell command prompt.

It is also possible to use another program such as
[picocom](https://github.com/npat-efault/picocom),
[putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html),
[teraterm](http://www.teraterm.org/)...
