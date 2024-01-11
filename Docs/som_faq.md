# SoM FAQ's

## RTL
**Q: My bitfile doesnt work!**
There are many possibilites! Here are a few:
1. Check for the DONE LED being lit. 
  - If it isnt lit, you probably didnt program the FPGA properly. Please program the FPGA using the instructions provided.
  - If it is lit, check the following:
    - Have you simulated your design successfully? If not, you go to Jail: miss a turn, go back to start, pay a penalty, simulate and come back here.
    - Have you provided the right pin constraints? Incorrect pin constraints can cause the board to lock up (but not brick!).
    - Are your clocks properly constrained?
    - Do you have any timing violations? If so, resolve them.

**Q: I loaded a bad bitfile on my board and now the programmer refuses to program now!**
Yes, this happens. Dont do it again! Heres the process to unlock your board:
1. Power off immediately, a bad bitfile may have bad pin allocations which can damage the SoM.
2. Short the PROGn pin on the J14 header to ground with a wire.
3. Power up the board. 
4. Check thatt the DONE LED isnt lit up.
5. Your board should now be ready to get programmed.

## Toolchain
**Q: Is there a requirement to be on Windows, or can I use the Radiant tool with linux?**
You can use linux, Radiant has a linux installation available.

**Q: Can the FPGA be programmed with the free licence version of the tool, or do I need the paid one?** RISCV firmware and FPGA bitfiles can be programmed using either Radiant or `ecpprog` which is included with the [FOSS toolchain](https://github.com/FPGAwars/toolchain-icestorm/releases/). For any changes to the FPGA or to recompile the FPGA or to use it for debug, you will need the Radiant tool license which is free and available from [here](https://www.latticesemi.com/Support/Licensing#requestRadiant). Note that you may require additional licenses to complete your work for example, MIPI related components. For more details on how to flash the firmware, please refer to [SoM Flash](som_flash.md) for details.