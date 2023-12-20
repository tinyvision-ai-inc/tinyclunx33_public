# tinyNX33U_docs
Documentation for the tinyNX33U SoM and related boards.

Schematics: Has the assembly drawings as well as schematics

RTL/Firmware: Example code that works with the tinyCLUNX SoM

Hardware: Misc stuff

# Clocking scheme

This documentation applies to the Rev 2 of the SoM and upwards.

An [Si5351A](https://www.skyworksinc.com/-/media/SkyWorks/SL/documents/public/data-sheets/Si5351-B.pdf) programmable PLL provides 2 programmable clocks to the system. The following summarizes the clock output of the PLL chip:

- Clock 0, Clock 1: These are setup to generate a 60MHz differential clock to the USB core in the FPGA. One of the clocks must be set to be inverted, passing this through a resistor network changes the levels to be compatible witht he differential inputs on the FPGA. Do not change this clock frequency unles the coresponding change has been made in the USB RTL.

- Clock 2: This is intended to be used as the clock to the FPGA. This is usually set to 24MHz and also routes to the SoM output where it can be used as a master clock to a camera for example.

The following sequence of writes to the PLL will set this up:
1. Disable all outputs: CLKx_DIS high; Register 3 = 0x7
2. Power down output drivers: Reg 16 to 18 = 0x80
3. Write new configuration: the configuration can be derived using the [Skyworks clock builder tool](https://tools.skyworksinc.com/timingfiles/latest-tools/clockbuilder-pro-installer.zip). The actual registers for the chip are located in an app note, [AN619](https://www.skyworksinc.com/-/media/SkyWorks/SL/documents/public/application-notes/AN619.pdf).
4. Apply soft reset to the PLL's: Reg 177 = 0xAC
5. Enable desired outputs (Register 3)

Now thats the official way to do it but for most applications, a far simpler way is to follow the Adafruit driver [here](https://github.com/adafruit/Adafruit_CircuitPython_SI5351/blob/main/adafruit_si5351.py)

Another way is to run the clock builder tool which then generates a sequence of I2C accesses to the PLL. More details can be found under the [Si5351 directory](Docs/Si5351).

We also provide a bit of RTL that can do the I2C initialization for you by loading the registers into a .mem file that the RTL reads at synthesis time. This scheme can be used to boot up the system and bring it to an operational state before the processor is up for example.
