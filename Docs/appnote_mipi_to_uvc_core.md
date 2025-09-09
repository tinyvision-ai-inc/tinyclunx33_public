# The MIPI to UVC Core {#appnote_mipi_to_uvc_core}

This app note presents the details of the tinyVision.ai MIPI2UVC core.

## Overview

![RTL Reference Design](images/rtl_reference_design.drawio.png)

The `usb_uvc_x_streams` module is a Verilog IP core that facilitates the transfer of video data from an FPGA to a host system via USB, presenting the data as a USB Video Class (UVC) stream. This module provides multiple independent video streams and interfaces with various subsystems including USB, Wishbone for configuration and control, interrupt outputs, and AXI Stream interfaces for data transmission.

## Functional Description

The MIPI2UVC core accepts video data through one or more independent AXI Stream interfaces and converts them into UVC-compliant USB streams.

The core is designed as a data mover and any data pushed into the internal FIFOs appears at the host as a UVC stream. 

The core includes:

- Multiple independent video stream processing
- USB 2.0/3.0 physical layer interface
- Wishbone configuration and control interface
- Interrupt generation for system events
- Integration with Zephyr RTOS drivers

**NOTE:** An external processor is required to handle the complex USB enumeration process and negotiation during UVC initiation. The actual data never touches the processor itself and flows directly from the input FIFO's to the USB hard IP in the FPGA. As a result, the processor is idle after the USB negotiations are complete and fully available to the user.

## Interface Signals

### Clock and Reset

| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `clk` | Input | 1 | System clock signal |
| `reset` | Input | 1 | System reset signal (active high, sync'ed to `clk`) |
| `usb_clk` | Input | 1 | USB clock signal, should be set to 60MHz |
| `usb_reset` | Input | 1 | USB reset signal (active high, sync'ed to `usb_clk`) |

### Wishbone Configuration Interface

The core provides multiple Wishbone interfaces for configuration and control:

#### CSR Wishbone Slave Interface (Primary control/configuration)

The core requires configuration and control to function properly. The core consumes a 28-bit address space and is designed to map into the `0xb000_0000 to 0xbfff_fffc` space in a processor. Note that we do not implement byte level access to registers within the USB core and all registers are assumed to be accessed as 32 bit data words. An implication is that the lower 2 bits of the Wishbone are not used.

| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `wb_m2s_wb0_cyc` | Input | 1 | Cycle signal for CSR Wishbone master |
| `wb_m2s_wb0_stb` | Input | 1 | Strobe signal for CSR Wishbone master |
| `wb_m2s_wb0_we`  | Input | 1 | Write enable signal for CSR Wishbone master |
| `wb_m2s_wb0_adr` | Input | 32 | Address bus for CSR Wishbone master |
| `wb_m2s_wb0_dat` | Input | 32 | Data bus for CSR Wishbone master |
| `wb_m2s_wb0_sel` | Input | 4 | Byte select signals for CSR Wishbone master |
| `wb_s2m_wb0_ack` | Output | 1 | Acknowledge signal from CSR Wishbone slave |
| `wb_s2m_wb0_dat` | Output | 32 | Data bus from CSR Wishbone slave |

#### CSR Wishbone Master Interface (Stream related)

Each stream core also provides a subset of the Wishbone address space which can be used to map registers from the user logic that is related to the stream. Typical example of such usage is the ISP associated with the particular streeam. This mapping makes the driver development modular especially when the different streams are similar in their characteristics eg. multiple RGB cameras.

| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `wb_m2s_csr[0,1]_cyc` | Output | 1 | Cycle signal for secondary CSR Wishbone master |
| `wb_m2s_csr[0,1]_stb` | Output | 1 | Strobe signal for secondary CSR Wishbone master |
| `wb_m2s_csr[0,1]_we`  | Output | 1 | Write enable signal for secondary CSR Wishbone master |
| `wb_m2s_csr[0,1]_adr` | Output | 32 | Address bus for secondary CSR Wishbone master |
| `wb_m2s_csr[0,1]_dat` | Output | 32 | Data bus for secondary CSR Wishbone master |
| `wb_m2s_csr[0,1]_sel` | Output | 4 | Byte select signals for secondary CSR Wishbone master |
| `wb_s2m_csr[0,1]_ack` | Input  | 1 | Acknowledge signal from secondary CSR Wishbone slave |
| `wb_s2m_csr[0,1]_dat` | Input  | 32 | Data bus from secondary CSR Wishbone slave |

### AXI Stream Data Interfaces

The core provides multiple independent AXI Stream interfaces for video data input. Each interface follows the standard AXI stream protocol.

#### Stream Interface
| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `streamIns_0_valid` | Input | 1 | Valid signal for AXI Stream input 0 |
| `streamIns_0_ready` | Output | 1 | Ready signal for AXI Stream input 0 |
| `streamIns_0_last` | Input | 1 | Last signal for AXI Stream input 0 (end of frame) |
| `streamIns_0_data` | Input | 64 | Data bus for AXI Stream input 0 |
| `numBytes_0` | Output | 24 | Number of bytes processed in stream 0 |


### USB Physical Interface

The core requires a set of pins to be connected directly to the FPGA IO. Please place these pins on the right pads for the FPGA. Not doing this correctly will cause Map errors.

| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `usbIO_VBUS` | Inout | 1 | USB VBUS line (power detection) |
| `usbIO_REFINCLKEXTP` | Input | 1 | USB reference clock input (60MHz) |
| `usbIO_REFINCLKEXTM` | Input | 1 | USB reference clock input () |
| `usbIO_RESEXTUSB2` | Inout | 1 | USB external reset line |
| `usbIO_DP` | Inout | 1 | USB 2 data plus line (D+) |
| `usbIO_DM` | Inout | 1 | USB 2 data minus line (D-) |
| `usbIO_RXM` | Input | 1 | USB 3 receive minus line (USB 3.0) |
| `usbIO_RXP` | Input | 1 | USB 3 receive plus line (USB 3.0) |
| `usbIO_TXM` | Output | 1 | USB 3 transmit minus line (USB 3.0) |
| `usbIO_TXP` | Output | 1 | USB 3 transmit plus line (USB 3.0) |

### Interrupt Outputs

The interrupt outputs from the core should be connected to the interrupt controller of the SoC. Interrupts are active high, level sensitive and held high until the interrupt source is cleared by the processor.

| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `irq` | Output | 1 | Interrupt from the RTL sorrounding the USB hard IP|
| `usb23_irq` | Output | 1 | USB hard IP interrupt output |

## Integration Guidelines

### Zephyr RTOS Integration

The Wishbone interface is designed to be connected to a processor hosting Zephyr RTOS with a dedicated driver for the RTL. The driver provides:

- Configuration/Control register access
- USB enumeration and UVC descriptor management
- Stream control and status monitoring
- Interrupt handling

Please refer to the the [Zephyr application note](appnote_zephyr_sdk.md) for more details.

### System Integration FAQ's

1. **Clock Domain Crossing**: The core operates in multiple clock domains (system clock, USB clock)
2. **Reset Synchronization**: Ensure resets are externally synchronized to the respective clock domain
3. **Stream Management**: Each stream operates independently with its own FIFO and control logic. There is no dependency between multiple streams.
4. **Timing**: The core has been designed with a maximum of 100MHz `clk`.
5. **Unused ports**: You can use a dual stream IP with a single stream by tying off the unused ports to idle values (`valid`, `data`, `last` are set to `0` and `ready` is left open). Wishbone ports shall have `ack`, `data` set low. This allows synthesis to optimize away most of the unused logic. For even smaller designs, you can use the single stream version of the core.

#### Memory Maps

The MIPI2UVC core provides several memory-mapped regions accessible through the Wishbone interfaces:

| Region | Base Address | Mask | Size | Access | Description |
|--------|--------------|------|------|--------|-------------|
| **USB Core** | `0xb0000000` | `0xff000000` | 16MB | CPU, USB | USB hard IP core configuration and control registers |
| **AXI RAM** | `0xb1000000` | `0xff000000` | 16MB | CPU, Data | Memory-mapped interface to the AXI shared RAM |
| **USB Manager: First stream** | `0xb4000000` | `0xfffffc00` | 1KB | CPU, Regs | USB manager configuration registers |
| **USB Manager Regs: Second stream** | `0xb4000400` | `0xfffffc00` | 1KB | CPU, Regs | USB manager configuration registers |
| **Data Mover Core** | `0xb4009000` | `0xfffffc00` | 1KB | CPU | Data mover control registers |
| **CSR: First stream** | `0xb2000000` | `0xfff00000` | 1MB | CPU | Control and Status Registers for primary stream |
| **CSR: Second stream** | `0xb2100000` | `0xfff00000` | 1MB | CPU | Control and Status Registers for secondary stream |
| **IRQ** | `0xbf000000` | `0xfffffc00` | 1KB | CPU | Interrupt controller registers |

**Notes:**
- All regions support 32-bit word access only (byte-level access not implemented)
- Lower 2 bits of Wishbone address are ignored
- CSR regions provide stream-specific configuration and status
- USB Manager regions handle USB enumeration and UVC descriptor management



### Performance Considerations

- Maximum throughput depends on USB speed (USB 2.0/3.0)
- Stream bandwidth is shared between the video streams
- FIFO depth affects latency and throughput characteristics.

## References

### Technical Standards and Documentation

- **Wishbone Bus Specification**: [Wishbone B4 Specification](https://cdn.opencores.org/downloads/wbspec_b4.pdf) - OpenCores Foundation
- **ARM AMBA Specifications**: [ARM AMBA Documentation](https://developer.arm.com/documentation/ihi0024/latest/) - ARM Limited
- **USB Video Class Specification**: [UVC 1.5 Specification](https://www.usb.org/sites/default/files/documents/uvc_1_5_20121220.zip) - USB Implementers Forum
- **AXI4-Stream Protocol**: [AMBA 4 AXI4-Stream Protocol Specification](https://developer.arm.com/documentation/ihi0051/latest/) - ARM Limited

### Related Documentation

- **Zephyr RTOS**: [Zephyr Project Documentation](https://docs.zephyrproject.org/) - Linux Foundation
- **FPGA Integration Guidelines**: See [RTL Reference Design](rtl_reference_design.md) for FPGA-specific integration details
