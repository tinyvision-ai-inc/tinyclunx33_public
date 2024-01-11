FAQ
===

## RTL


### Q: My bitfile does not work!

There are many possibilites! Here are a few:

Check for the DONE LED being lit. 

If it is not lit, you probably did not program the FPGA properly.
Please program the FPGA using the [instructions provided](som_flash.md).

If it is lit, check the following:

- Have you simulated your design successfully?
  If not, you go to Jail: miss a turn, go back to start, pay a penalty, simulate and come back here.
- Have you provided the right pin constraints?
  Incorrect pin constraints can cause the board to lock up (but not brick!).
- Are your clocks properly constrained?
- Do you have any timing violations?
  If so, resolve them.

### Q: I loaded a bad bitfile on my board and now the programmer refuses to program now!

Yes, this happens. Do not do it again! Here is the process to unlock your board:

1. Power off immediately, a bad bitfile may have bad pin allocations which can damage the SoM.
2. Short the `PROGn` pin on the `J14` header to Ground with a wire.
3. Power up the board. 
4. Check that the DONE LED is not lit up.
5. Your board should now be ready to get programmed.


## Toolchain


### Q: Is there a requirement to be on Windows, or can I use the Radiant tool with Mac OS or Linux?

You can use Linux, Radiant has a Linux installation available.

Lattice Radiant does not currently support Mac OS.
It is possible to use a Windows or Linux virtual machine and run Radiant inside.

### Q: Can the FPGA be programmed with the free licence version of the tool, or do I need the paid one?

RISCV firmware and FPGA bitfiles can be programmed using either Radiant or
[`ecpprog`](https://github.com/gregdavill/ecpprog)
which is included with the
[OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build)
toolchain.

For any changes to the FPGA or to recompile the FPGA or to use it for debug, you will need the Radiant tool license which is free and available from the
[Lattice website](https://www.latticesemi.com/Support/Licensing#requestRadiant).

Note that you may require additional licenses to complete your work.
For example, MIPI related components, which you can request from Lattice.

For more details on how to flash the firmware, please refer to [SoM Flash](som_flash.md).
