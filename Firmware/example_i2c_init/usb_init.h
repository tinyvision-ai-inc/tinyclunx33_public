#ifndef USB_INIT_H
#define USB_INIT_H

void usb_init(void);
void usb_reset_seq(void);
void device_poweron_soft_reset(void);
void usb_depcfg(void);

#endif
