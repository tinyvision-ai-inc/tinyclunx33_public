# SoM FPGA

The tinyCLUNX33 SoM features the CrossLinkU-NX 33 FPGA, codename LIFCL-33U.

It features an integrated USB2 and USB3 MAC as well as an USB2 and USB3 PHY.

Programming the FPGA is done by writing the bitfile to the [Flash](som_flash.md)
that is attached to it. Upon power on, the FPGA will load it out of the first
512 kBytes.

The [RTL Reference Design](rtl_reference_design.md) provides the foundation of
a system, on top of which the application can be implemented.

## Parts used

- Lattice Semiconductor
  [LIFCL-33U-8CTG104CAS](https://www.latticesemi.com/Products/FPGAandCPLD/CrossLink-NX)
  FPGA (search for 33U in this page).
