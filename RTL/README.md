[Doc](https://tinyclunx33.tinyvision.ai/) |
[Hardware](https://github.com/tinyvision-ai-inc/tinyCLUNX33/tree/main/Schematics) |
[Firmware](https://docs.zephyrproject.org/latest/boards/riscv/tinyclunx33/doc/index.html) |
[Schematic](tinyCLUNX33_v2.0_Schematic.pdf) |
[Assembly](tinyCLUNX33_v2.0_Assembly.pdf) |
[Discord](https://discord.gg/yjVc6P3sCt)


# Building the tinyCLUNX33 Reference Design

The **tinyCLUNX** module features the Lattice CrossLinkU-NX (LIFCL-33U) FPGA
suitable for interfacing MIPI cmeras or other high-speed differential pairs
signals with USB3 at 5 Gbit/s.

The build uses a Makefile, and assumes a command-line environment, such
as MacOSX or Linux or BSD or WSL2/GitBash/CygWin on Windows.

If you only need to obtain a default setup, you may use a
[release](https://github.com/tinyvision-ai-inc/tinyCLUNX33/releases)
build and only modify the firmware.


## Rebuild the RISC-V CPU and SoC with LiteX (optional)

This is only required if you wish to modify the Verilog sources of the CPU.

`git`, `make`, `sh`, `mkdir`, `echo`, `rm`, `python3`... are required.
Windows requires [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install)
as [Git Bash](https://git-scm.com/download/win) lacks Python3.

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

This will have built the Verilog sources of a RISC-V CPU system.
You can now use these updated sources in the next step.


## Build the bitfile with Radiant

[Lattice Radiant](https://www.latticesemi.com/LatticeRadiant) can be downloaded
and installed for building the final bitfile out of the Verilog sources.

A License will be required, and can be requested to Lattice via an
[online form](https://www.latticesemi.com/Support/Licensing#requestRadiant).

From Git Bash or WSL, make sure to have all RTL submodule and dependencies:

```
git submodule update --init
```

Then:

1. Open Radiant and from the startup page, select "Open Project"

2. Browse to this `RTL` directory and open the file named `fpga_top_som.rdf`.

3. Run the project with the `►` icon on the top bar, which will trigger all the
   steps.

At this step, a `impl/fpga_top_som.bit` file should be created, which can be
loaded onto the very beginning of the FPGA flash.

If you have errors such as `2120405 ERROR - Invalid project file`
(Message tab on bottom bar), you could be missing files.
Are on the latest commit with all the submodules fetched?


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


## Build a bare metal firmware

LiteX can generate firmware libraries matching the RTL, that can be used
to drive the various peripherals (UART, I2C...).

The USB driver is only implemented on top of
[Zephyr](https://tinyclunx33.tinyvision.ai/md_zephyr.html).

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
