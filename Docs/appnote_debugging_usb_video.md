# Debugging USB Video {#appnote_debugging_usb_video}

This app note presents the layers involved in the tinyCLUNX33 USB Video, and how debugging can
happen at every level.

Going through each step is not mandatory but only informative, and reaching tinyVision.ai on the
[chat server](https://discord.com/invite/3qbXujE) or by email is more than welcome.

Furthermore, help can also be found on the [Zephyr Project](https://discord.com/invite/Ck7jw53nU2)
chat server about how Zephyr works in general, as well as on the
[Zephyr documentation](https://docs.zephyrproject.org/latest/).


Physical problems
-----------------

### Bad cable

First of all, a bad USB cable is a frequent source of failure, and testing different cables, or
testing the same cable with different devices is recommended.

### Bad port

The USB ports of the host can also have differences in how it is handled. For instance, USB 3 ports
that are 20 Gbit/s capable and those only 5 Gbit/s capable can behave slightly differently.
Also, damage or misconfiguration of a particular port can also happen on the host side, and testing
a different port can sometimes reveal useful.

### Bad board

If several modules and devkits are provided, Testing a different one can also reveal a problem
specific to one particular device rather than a firmware or gateware issue.

### With/without HUB

Testing with or without the presence of an intermediate USB HUB, as well as different types of USB
HUBs can also give slightly different results in presence of some bug.

### Plug sequence

The order in which the DATA and DEBUG USB connectors of the devkit are connected can also affect the
power sequence, and in presence of some other bug, permit to show a different behavior. The actual
port to which each interface is also connected can also play a role: In case of problem, connecting
both ports to the same hub/device can be more useful.

### Under-powered

When additional hardware gets connected to the devkit, this can lead to additional current being
pulled by the USB device, up to being too much for what an USB port can supply. In which case,
disconnecting every external device from the devkit (i.e. the adapter boards) can reveal useful.


Debugging the enumeration
-------------------------

An USB Video device is fundamentally an USB device: once it is connected to the host, the host
queries its USB descriptors, arrays of bytes encoding the functions of the device. According to
these, the host selects an appropriate driver for this device. This is the *USB enumeration*.

To tell if the enumeration did succeed, the `lsusb` command (Linux), `ioreg -p IOUSB` command
(Mac OSX), or [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html) (Windows)
should show an entry for the tinyCLUNX33, named 'tinyVision.ai tinyCLUNX33" by default.

In all case, upon error preventing the device to be detected, the host-side system logs and
Zephyr-side logs will contain precious information about what happened.

### Linux ERR

If the enumeration does not work on Linux, this suggests that a low-level issue happened. The
`dmesg -w` logs from the host as well as the UART logs from the tinyCLUNX33 would be what to aim
for to understand what is going wrong. It is possible to increase the log verbosity of the USB
driver by setting `CONFIG_UDC_DRIVER_LOG_LEVEL_INF=y` in `prj.conf` and rebuilding.

### Linux OK, Windows ERR

If the enumeration works on Linux, but not on Windows, this could be a low-level issue as above,
or possibly a problem in the USB descriptors that are not specific to video, but globally
describing the device. In which case, the USB3CV can be used to test if the device is detected
using this method.

### USB OK, Video ERR

If the USB device works but the video device does not appear in the list of video devices (i.e.
`/dev/video2` on Linux, or the list of webcams in online video conferences systems), this means
that the enumeration did succeed, but some descriptor was not considered valid. Debugging the
descriptors content itself could be needed.


Debugging the Descriptors
-------------------------

If the USB descriptors are valid and correctly transmitted during enumeration, then a system video
interface should appear. Even if there is any problem with the video transfer.
If nothing appears, then something went wrong with the enumeration or descriptors content.

### USB3CV

One method to verify that the descriptors are correct is to use the official
[USB3CV](https://www.usb.org/document-library/usb3cv) validator tool from the USB-IF, which will
build a report of all USB descriptors that are incorrect. Except some rare exceptions, if the USB3CV
tool suite does not report any bug, the descriptors are should be accepted by the host.

This means that all the USB descriptor foes can be caught by this (Windows-only) tool.
However, insightful error messages can also be presented by `lsusb -v` or
[USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html) that would not be described
in the USB3CV tool.

### Manual inspection

The tinyCLUNX33 SDK uses the `1209:0001` vendorID/productID combo from
[pid.codes](https://pid.codes/1209/0001/)
(for a production device, a vendorID/productID registered at USB-IF must be obtained, or pid.codes
for open hardware projects), so the command to list the detailed descriptors would be for both
Linux and Mac OSX: `lsusb -v -d 1209:0001`.

### Descriptors origin

On the tinyCLUNX33, the USB descriptors are defined by the USB Video Class implementation part of
Zephyr (`subsys/usb/device_next/class/usbd_uvc.c`). Some part is constant, and some part is
dynamically generated based on informations contained withing the video driver, such as the IMX219
image sensor driver, or custom driver you are developing. This means that if the USB descriptors
content are wrong, it can be due to data coming from the video driver (i.e. empty list of formats)
or be a bug in the USB Video Class (i.e. wrong order for a list).


Debugging the video stream
--------------------------

For any kind of error, enabling the verbose logs for the Linux `uvcvideo` driver gives better
insights of what is going on under the hood. To enable them:

```
echo 0xffffffff | sudo dd of=/sys/module/uvcvideo/parameters/trace
```

This is expected to show a few lines for video frame received, such as this:

```
[1498690.965302] usb 2-1: Allocated 5 URB buffers of 32x1024 bytes each
[1498691.059830] usb 2-1: Frame complete (EOF found)
[1498691.063358] usb 2-1: frame 1 stats: 0/1/1 packets, 0/0/0 pts (!early !initial), 0/1 scr, last pts/stc/sof 0/4284220160/44884
[1498691.092166] usb 2-1: Frame complete (EOF found)
[1498691.095681] usb 2-1: frame 2 stats: 0/1/1 packets, 0/0/0 pts (!early !initial), 0/1 scr, last pts/stc/sof 0/643629824/51914
[1498691.124491] usb 2-1: Frame complete (EOF found)
[1498691.128022] usb 2-1: frame 3 stats: 0/1/1 packets, 0/0/0 pts (!early !initial), 0/1 scr, last pts/stc/sof 0/1314718464/58688
[1498691.156804] usb 2-1: Frame complete (EOF found)
[1498691.160317] usb 2-1: frame 4 stats: 0/1/1 packets, 0/0/0 pts (!early !initial), 0/1 scr, last pts/stc/sof 0/1969029888/1207
[1498691.189130] usb 2-1: Frame complete (EOF found)
[1498691.192676] usb 2-1: frame 5 stats: 0/1/1 packets, 0/0/0 pts (!early !initial), 0/1 scr, last pts/stc/sof 0/2640118528/7981
[1498691.221460] usb 2-1: Frame complete (EOF found)
...
```

The working of the `uvcvideo` Linux driver is that any frame shorter than the expected
`wMaxVideoFrameSize` is dropped. In order to troubleshoot, it might be useful to force the frames
out and inspect them to understand what goes wrong. To do so, reload the `uvcvideo` driver with the
`nodrop=1` flag:

```
sudo modprobe -r uvcvideo
sudo modprobe uvcvideo nodrop=1
```

### Stream negotiation failure

Once the video interface is present, it becomes possible to start the video feed from the host, i.e.
using a simple video player like `ffplay /dev/video2`. If the player does not open, this could mean
that the stream negotiation that happens before starting the transfer failed. Error messages will be
present on `dmesg` and the device UART logs.

The negotiation will involve communication with the video driver. This requires the driver to work
consistently: tuning up the video log level could help: `CONFIG_VIDEO_LOG_LEVEL_DBG=y`.

### Too few exposure

If a window opens-up with a video feed, but it is dark, it is possible that the exposure level of
your image sensor is left to the default minimum setup. Pointing a torchlight at the image sensor
permits to verify this.

### Zephyr debug commands

The Zephyr shell available on the debug UART interface or as an extra USB-serial console (depending
on configuration) will allow to run extra. Tab completion is available, which helps with avoiding
typos while entering the device names.

One command that always help screening whereabout an error might be is `device list`, giving
the return status for the `init()` function of every driver:

```
uart:~$ device list
devices:
- interrupt-controller@bc0 (READY)
  DT node labels: intc0
- cdc-acm-uart (READY)
  DT node labels: cdc_acm_uart0
- serial@e0001800 (READY)
  DT node labels: uart0
- i2c@e0005000 (READY)
  DT node labels: i2c0
- si5351@60 (READY)
  DT node labels: pll0
- pca9542a@71 (READY)
- usb@b0000000 (READY)
  DT node labels: zephyr_udc0
- ch@0 (READY)
- uvcmanager@b4000000 (READY)
  DT node labels: uvcmanager0
- imx219@10 (READY)
  DT node labels: imx219
- debayer@b1200000 (READY)
  DT node labels: debayer0
- uvc (READY)
  DT node labels: uvc
```

If anything other than `READY` is shown, then the return code of `init()` was not `0`, which can be
investigated directly on the driver C source file of the relevant driver.

### Debugging the UVC Manager

If the stream appears to be stuck and there is no I/O, then it is possible that the UVC Manager
input feed is stuck. To verify this, get the address of the FIFO, and manually read bytes from it
with for instance the `devmem` Zephyr command:

```
uart:~$ uvcmanager
uvcmanager - UVC Manager debug commands
Subcommands:
  conf  : Print the uvcmanager configuration
          Usage: conf <device>
```

The UVC Manager shows early debug information about the input video stream as well as other
low-level information. By looking at the `STREAM ADDRESS` field, the location of the data pipe can
be obtained, and read from the shell to test if data comes out of it:

```
$ uvcmanager conf uvcmanager@b4000000
...
STREAM ADDRESS  0xb1200000
...
$ devmem dump -a 0xb1200000 -s 1024
B1200000: 1d 7f 1d 80 1d 80 1d 7f  1d 80 1c 7f 1d 80 1c 7f |........ ........|
B1200010: 1d 7f 1d 80 1c 80 1c 80  1d 7f 1d 7f 1d 80 1c 7f |........ ........|
B1200020: 1c 80 1c 80 1d 7f 1c 80  1d 7f 1c 7f 1d 80 1c 7f |........ ........|
...
```

The serial console speed can be improved by reducing the USB driver log verbosity.
If data does not come out of it, this suggests that no data was provided into the feed.

### Debugging the USB transfers

In order to review the current state of the transfer, the `dwc3` command can be used for debugging
Lattice USB23, as it uses a compatible API. To review the list of buffers scheduled for transfer:

Looking at the output of `lsusb -vd 1209:0001 | grep -C10 bEndpointAddress` would give a summary
of every endpoint address, useful to know which endpoint is used for the video transfers.

Then, inspecting the state of the video transfers can be done as such:

```
uart:~$ dwc3 trb usb@b0000000
...
trb for IN endpoint 0x83 (3 IN)
0xb1000140 ep=0x83 addr=0x00000000b1200040 ctl=1 sts=0 hwo=1 lst=0 chn=1 csp=0 isp=0 ioc=0 spr=1 pcm1=0 sof=0 bufsiz=2048 <HEAD <TAIL
0xb1000150 ep=0x83 addr=0x00000000b1200050 ctl=1 sts=0 hwo=1 lst=0 chn=1 csp=0 isp=0 ioc=0 spr=1 pcm1=0 sof=0 bufsiz=2048
0xb1000160 ep=0x83 addr=0x00000000b1200060 ctl=1 sts=0 hwo=1 lst=0 chn=1 csp=0 isp=0 ioc=0 spr=1 pcm1=0 sof=0 bufsiz=2048
0xb1000170 ep=0x83 addr=0x00000000b1000140 ctl=8 sts=0 hwo=1 lst=0 chn=0 csp=0 isp=0 ioc=0 spr=0 pcm1=0 sof=0 bufsiz=0
...
```

* `0xb1000140` is the address where this list of buffers is encoded.

* `ep=0x83` confirms us that it is the endpoint 0x83.

* `addr=0x00000000b1200040` is the address of the stram to transfer, on which the `devmem` command
  from earlier can be used.

* `ctl=1` indicates that this is a BULK transfer. There are 3 BULK transfers in this case.

* `ctl=8` indicates that the list of buffers wraps over to the address specified by `addr=`, in a
  ring buffer looping over continuously.

* `hwo=1` (HardWare Owned) means that the transfers are submitted to the buffer,

* `chn=1` (CHaiN) means that the buffers are all connected together into a single transfer (does
   not apply to `ctl=8`).

* `bufsiz=2048` indicate that the buffers did not start to be transferred at all as they are still
  complete with their original size `2048` (does not apply to `ctl=8`).
