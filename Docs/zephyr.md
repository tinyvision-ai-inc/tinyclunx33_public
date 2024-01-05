# Zephyr integration

The [Zephyr RTOS](https://docs.zephyrproject.org/) has been ported the SoM on
top of the [RTL Reference Design](rtl_reference_design.md).

![](images/zephyr_architecture.drawio.png)

Including a soft CPU inside the hard USB23 core permits to control the register
interface with RTL.
A Zephyr firmware is provided for running on this CPU, with a
[driver](https://github.com/tinyvision-ai-inc/zephyr/blob/tinyclunx33/drivers/usb/udc/udc_usb23.c)
for this USB23 core.

Ultimately, the Zephyr firmware image will be possible to build using the
[regular process](https://docs.zephyrproject.org/latest/develop/getting_started/index.html)
from the Zephyr Project.

Until then, these repositories are requied:

- [Zephyr fork](https://github.com/tinyvision-ai-inc/zephyr/tree/tinyclunx33) -
  in progress until it gets submitted upstream.

- [Example project](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example) -
  with build instructions. The starting point for building Zephyr for the
  tinyCLUNX33.
