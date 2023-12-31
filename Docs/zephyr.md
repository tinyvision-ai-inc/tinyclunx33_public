# Zephyr integration

Including a soft CPU inside the hard USB23 core permits to control the register
interface with RTL

[VexRiscv](https://github.com/SpinalHDL/VexRiscv#area-usage-and-maximal-frequency)
CPU integrated into the [RTL Reference Design](rtl_reference_design.md) is
necessary

The Zephyr firmware image can be build using the
[official process](https://docs.zephyrproject.org/latest/develop/getting_started/index.html)
from Zephyr Project.

A [public fork](https://github.com/tinyvision-ai-inc/zephyr/tree/tinyclunx33)
is being worked on for it to get submitted upstream.

An [example project](https://github.com/josuah/tinyclunx33_zephyr_example)
with build instructions is provided as a starting point.
