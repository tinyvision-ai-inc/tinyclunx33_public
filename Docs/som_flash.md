# SoM Flash

A 16 MByte (128 Mbit) QSPI flash with Dual Transmission Rate (DTR) can store the
FPGA bitfile as well as a storing the firmware that the soft CPU core can
execute in-place (XIP).

![](images/som_flash_architecture.drawio.png)

In the default RTL, the flash is mapped at address `0x2000_0000`.

```
0x2000_0000 -- First address of FPGA bitfile
0x2010_0000 -- First address of Zephyr firmware (optional)
0x20*0_0000 -- Free area at the end of the flash for custom
```

The command [ecpprog](https://github.com/gregdavill/ecpprog) permits to send
a bitfile to the SoM by using the FTDI present on the
[BaseBoard](carrier_baseboard.md).

It can be installed as part of
[OSS Cad Suite](https://github.com/YosysHQ/oss-cad-suite-build#installation)
then called this way:

```
ecpprog -o 0x000000 file_to_program.bin
```

The `-o 0x000000` can be adapted to any local offset *within* the flash,
to allow multiple binary images to cohabitate.

The regular Radiant programmer can also be used as usual for Lattice parts.


## Hardware integration

The flash is already integrated internally in the SoM hardware.

In addition, its qSPI interface may be accessed from the outside, for debugging
or other purpose: 4 SPI data lines in half-duplex for 4x the
throughput.

It further provides Double Transmission Rate (DTR, also known as DDR) to send
twice the amount of data per clock.


## RTL integration

TODO: add the new QSPI DDR flash controller and map it to AXI for XIP

TODO: hook the QSPI bus as a regular SPI peripheral


## Zephyr integration

Inside the flash, the Zephyr firmware is written at offset `0x0010_0000`.

So the final start address of the Zephyr firmware is `0x2010_0000`.

This is integrated into the Zephyr DeviceTree as a flash controller entry:

```
flash0: flash@20100000 {
	reg = <0x20100000 0x100000>;
	compatible = "soc-nv-flash";
	status = "okay";
};
```


## Troubleshooting

The `ecpprog` tool might show error messages about the `IDCODE` not being recognized.
The LIFCL-33U FPGA part [not yet integrated](https://github.com/gregdavill/ecpprog/pull/20) into ecpprog.
This is not a problem, the tool should still work besides this.
If it does not, there is likely an unrelated error happening.

It is possible to test that the ecpprog tool can access the FPGA part:

```
$ ecpprog -t
init..
IDCODE: 0x010fb043 does not match :(
flash ID: 0xEF 0x70 0x18
Bye.
$
```

If you observe something different for the flash ID, then there could be a transmission problem, or a faulty Flash part.
You can test to run the tool slower:

```
$ ecpprog -s -t
init..
IDCODE: 0x010fb043 does not match :(
flash ID: 0xEF 0x70 0x18
Bye.
$
```

If you see something different than earlier, then the problem is likely that the FTDI has some difficulty to reach the FPGA.
You could check that the module is corectly fitted, or if you have any jumper wires connected to the Flash pins.


## Parts featured

- Winbond
  [W25Q128JW_DTR](https://www.winbond.com/hq/support/documentation/downloadV2022.jsp?__locale=en&xmlPath=/support/resources/.content/item/DA00-W25Q128JW_1.html&level=1)
  QSPI DTR flash

![](images/som_flash_schematic.png)
