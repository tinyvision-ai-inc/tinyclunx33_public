# tinyNX33U_docs
Documentation for the tinyNX33U SoM and related boards.

Schematics: Has the assembly drawings as well as schematics

RTL: Sample designs to bring up the system

Docs: Miscellaneous stuff

# Clocking scheme
An [Si5351A](https://www.skyworksinc.com/-/media/SkyWorks/SL/documents/public/data-sheets/Si5351-B.pdf) provides 3 programmable clocks to the system.

- Clock 0: This clock output is dedicated to the FPGA. It feeds pin N8 which is also the GPLL input of the FPGA hence allowing for the highest clock quality going to the FPGA's PLL. _Note_: this input to the FPGA cannot be routed to the clock tree in the FPGA and must feed a PLL diorectly, else will result in a Map error.

- Clock 1: This is intended to be used as the clock to the USB core. The clock is routed to the baseboard where it is converted to an LVDS signal and brought back into the SoM as the REFCLK signals that are used by the USB core.

- Clock 2: This clock is available as a general purpose clock that is hooked up to both the FPGA on pin H8 as well as the SoM connector.

The following sequence of writes to the PLL will set this up:
1. Disable all outputs: CLKx_DIS high; Register 3 = 0x7
2. Power down output drivers: Reg 16 to 18 = 0x80
3. Write new configuration: the configuration can be derived using the [Skyworks clock builder tool](https://tools.skyworksinc.com/timingfiles/latest-tools/clockbuilder-pro-installer.zip). The actual registers for the chip are located in an app note, [AN619](https://www.skyworksinc.com/-/media/SkyWorks/SL/documents/public/application-notes/AN619.pdf).
4. Apply soft reset to the PLL's: Reg 177 = 0xAC
5. Enable desired outputs (Register 3)

Now thats the official way to do it but for most applications, a far simpler way is to follow the Adafruit driver [here](https://github.com/adafruit/Adafruit_CircuitPython_SI5351/blob/main/adafruit_si5351.py)

Another way is to run the clock builder tool which then generates a sequence of I2C accesses to the PLL. More details can be found under the [Si5351 directory](Docs/Si5351).