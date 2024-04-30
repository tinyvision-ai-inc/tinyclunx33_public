/*
 * Copyright 2017 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#ifndef _USB_DEVICE_DESCRIPTOR_H_
#define _USB_DEVICE_DESCRIPTOR_H_ 1

#include "cdcacm_device_descriptor.h"
#include "video_device_descriptor.h"
#include "dfu_device_descriptor.h"

/*******************************************************************************
 * Definitions
 ******************************************************************************/
#define USB_DEVICE_SPECIFIC_BCD_VERSION (0x0200)
#define USB_DEVICE_DEMO_BCD_VERSION (0x0101U)

#define USB_DEVICE_VID (0x1FC9U)
#define USB_DEVICE_PID (0x00A3U)


/* usb descriptor length */
#define USB_DESCRIPTOR_LENGTH_CONFIGURATION_ALL (sizeof(g_UsbDeviceConfigurationDescriptor))

#define USB_DEVICE_CONFIGURATION_COUNT (1)
#define USB_DEVICE_STRING_COUNT (17)
#define USB_DEVICE_LANGUAGE_COUNT (1)

#define USB_COMPOSITE_CONFIGURE_INDEX (1)

/* String descriptor length. */
#define USB_DESCRIPTOR_LENGTH_STRING0 (sizeof(g_UsbDeviceString0))
#define USB_DESCRIPTOR_LENGTH_STRING1 (sizeof(g_UsbDeviceString1))
#define USB_DESCRIPTOR_LENGTH_STRING2 (sizeof(g_UsbDeviceString2))
#define USB_DESCRIPTOR_LENGTH_STRING3 (sizeof(g_UsbDeviceString3))
#define USB_DESCRIPTOR_LENGTH_STRING4 (sizeof(g_UsbDeviceString4))

/* Class code. */
#define USB_DEVICE_CLASS        (0xEF)  /* Multi-interface Function Class 0xEF */
#define USB_DEVICE_SUBCLASS     (0x02)  /* USB Common Sub Class 2 when IADa are used */
#define USB_DEVICE_PROTOCOL     (0x01)  /* USB IAD Protocol 1 when IADs are used */
#define USB_DEVICE_MAX_POWER    (250u)  /* 500 mA */

#define TOTAL_INTERFACE_COUNT   (USB_VIDEO_VIRTUAL_CAMERA_INTERFACE_COUNT + \
                                 CDCACM_USB_INTERFACE_COUNT +	\
								 USB_DFU_INTERFACE_COUNT)

#define TOTAL_CONFIGURATION_DESCRIPTOR_LENGTH   (USB_DESCRIPTOR_LENGTH_CONFIGURE +	\
                                                TOTAL_VIDEO_DESCRIPTOR_LENGTH + \
                                                TOTAL_CDCACM_DESCRIPTOR_LENGTH + \
												TOTAL_DFU_DESCRIPTOR_LENGTH)

#endif /* _USB_DEVICE_DESCRIPTOR_H_ */
