# RTL Reference Design

The RTL Reference Design is a set of Verilog sources (sometimes generated from
another HDL) providing common design elements for building an application on
top of the SoM hardware.

Once completed, it will usable as a stand-alone design for implementing a
product, or as a base to build upon.

![](images/rtl_reference_design.drawio.png)

To build this component, refer to the
[RTL build instructions](https://github.com/tinyvision-ai-inc/tinyCLUNX33/blob/main/RTL/README.md).


## Data Pipeline (AXI64)

The user does not need to customize this part, although it is possible.

External ports:

- **Wishbone port** for a CPU to access the internal AXI64 crossbar.

- **AXI64 port** for connecting custom RTL producing/consuming the USB data,
  integrated as an AXI slave, with FIFO/Stream adapters available.

Internal AXI64 cores:

- **USB23 bus master** performing AXI bus requests for transferring data to the
  USB host, from the address indicated by the CPU.

- **Small block of RAM** for the CPU to store small buffers for use by the
  USB23 core.


## CPU SoC (Wishbone)

The user does not need to customize this part, although it is possible.

External ports:

- **Wishbone port** so that the CPU can control an external bus, for use with
  the Data Pipeline's Wishbone port seen above.

- **Hardware interfaces** such as I2C, UART, qSPI, GPIO.

Internal Wishbone cores:

- **[VexRiscv](https://github.com/SpinalHDL/VexRiscv)** CPU, controlling the
  peripherals, configuring their configuration registers over Wishbone.

- **Main CPU RAM** controller, memory-mapped to the Wishbone bus for use by the CPU and its firmware.

- **qSPI DTR Flash** controller, memory-mapped to the wishbone bus so that the CPU
  can execute its firmware from flash (XIP). See [SoC Flash](soc_flash.md).

- **Timer** controller, used as systick by the Zephyr RTOS.

- **I2C** controller, used to program the external [Si5351 PLL](som_clocks.md),
  MIPI image sensors, USB-C port controller, or anything else connected to I2C.

- **UART** controller, used for printing debug logs or configuration shell.

- **Extra peripherals** can be integrated to support external SoCs.


## User RTL

The interface for moving large amounts of data from custom RTL to the USB core
is a standard AXI64 slave.
Specific configuration and addresses for AXI access are controlled by the corresponding USB endpoint configuration in the Zephyr driver.

Helper cores available MIPI/USB/RAM:

- **Wrappers around the AXI64 port** offering a FIFO or Stream based interface
  rather than an AXI one.

- **OctalSPI and HyperRAM** controllers for facilitating the access to this
  external chip on the *Compute* variant.

- TODO: pixel, MIPI and image data processing utilities.
