# SoM Hardware {#som}

25.4mm x 25.4mm x 4.5mm module, commercial temperature grade: 0°C to 85°C

<div class="grid">
@subpage som_flash
@subpage som_clocks
@subpage som_flash
@subpage som_fpga
@subpage som_gpio
@subpage som_i2c
@subpage som_jtag
@subpage som_memory
@subpage som_mipi
@subpage som_pinout
@subpage som_power
@subpage som_usb
</div>

Connector:
- 2x Hirose high density DF40C 60 pin connectors
- proven on thousands of SoM's in the field in high vibration environments
- Spare pins for future proofing

2 flavors:
- Connectivity: 14 diff pairs, no SSRAM
- Compute: 8 diff pairs, 32 MB [oSPI/HyperRAM](som_memory.md) @ <0.5GBps

I/O interfaces:
- 3x fully programmable clocks
- GPIO, I2C, field updates through FPGA or direct flash programming
- GPIO voltage is programmable

Firmware/RTL:
- Zephyr for control path on RISCv
- No-code graphical RTL generator with large # of IP blocks (under development)

Development boards:
- [devkit] for programming/debug
- extra adapter boards for various camera connectors and expansion
- reference designs such as a basis of a compact camera device

![](images/tinyclunx33_block_diagram.drawio.png)
