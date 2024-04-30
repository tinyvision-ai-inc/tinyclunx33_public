/*
 * Copyright (c) 2015, Freescale Semiconductor, Inc.
 * Copyright 2017 NXP
 * All rights reserved.
 *
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#ifndef __USB_DEVICE_DESCRIPTOR_H__
#define __USB_DEVICE_DESCRIPTOR_H__

/*******************************************************************************
 * Definitions
 ******************************************************************************/

#define USB_DESCRIPTOR_LENGTH_FUNCTINAL (9U)

//#define USB_DESCRIPTOR_LENGTH_STRING3 (sizeof(g_UsbDeviceString7))
#define USB_DESCRIPTOR_LENGTH_OSExended (sizeof(g_UsbDeviceOSExendedDescriptor))
#define USB_DESCRIPTOR_LENGTH_COMPAT (sizeof(g_UsbDeviceCompatibleIDDescriptor))

#define USB_DFU_INTERFACE_INDEX (6U)
#define USB_DESCRIPTOR_TYPE_DFU_FUNCTIONAL (0x21)
#define USB_DFU_DETACH_TIMEOUT (5000)	/* 5Sec */
#define USB_DFU_BIT_WILL_DETACH (1U)
#define USB_DFU_BIT_MANIFESTATION_TOLERANT (0U)
#define USB_DFU_BIT_CAN_UPLOAD (0U)
#define USB_DFU_BIT_CAN_DNLOAD (0U)
#define MAX_TRANSFER_SIZE (0x200)

#define USB_DFU_INTERFACE_COUNT (1U)

#define USB_DFU_CLASS (0xFEU)
#define USB_DFU_SUBCLASS (0x01U)

#define USB_DFURUNTIME_MODE_PROTOCOL (0x01U)
#define USB_DFU_MODE_PROTOCOL (0x02U)

#define USB_MICROSOFT_EXTENDED_COMPAT_ID (0x0004U)
#define USB_MICROSOFT_EXTENDED_PROPERTIES_ID (0x0005U)

#define TOTAL_DFU_DESCRIPTOR_LENGTH	(USB_DESCRIPTOR_LENGTH_INTERFACE +	\
                      	  	  	  	 USB_DESCRIPTOR_LENGTH_FUNCTINAL)

/* DFU Descriptor */
#define DFU_DESCRIPTOR_DATA	\
    USB_DESCRIPTOR_LENGTH_INTERFACE, /* Size of this descriptor in bytes */	\
    USB_DESCRIPTOR_TYPE_INTERFACE,   /* INTERFACE Descriptor Type */	\
    USB_DFU_INTERFACE_INDEX,         /* Number of this interface. */	\
    0x00U,                           /* Value used to select this alternate setting	for the interface identified in the prior field */	\
    0x00,                            /* Only the control endpoint is used */	\
    USB_DFU_CLASS,                   /* Class code (assigned by the USB-IF). */	\
    USB_DFU_SUBCLASS,                /* Subclass code (assigned by the USB-IF). */	\
    USB_DFURUNTIME_MODE_PROTOCOL,    /* Protocol code (assigned by the USB). */	\
    0x0FU,                           /* Index of string descriptor describing this interface */	\
	\
    USB_DESCRIPTOR_LENGTH_FUNCTINAL,    /* size of DFU functional descriptor in bytes */	\
    USB_DESCRIPTOR_TYPE_DFU_FUNCTIONAL, /* DFU functional descriptor type */	\
    (USB_DFU_BIT_WILL_DETACH << 3U) | (USB_DFU_BIT_MANIFESTATION_TOLERANT << 2U) | (USB_DFU_BIT_CAN_UPLOAD << 1U) |	\
        USB_DFU_BIT_CAN_DNLOAD,                                                            /* DFU attributes */	\
    USB_SHORT_GET_LOW(USB_DFU_DETACH_TIMEOUT), USB_SHORT_GET_HIGH(USB_DFU_DETACH_TIMEOUT), /* wDetachTimeout */	\
    USB_SHORT_GET_LOW(MAX_TRANSFER_SIZE), USB_SHORT_GET_HIGH(MAX_TRANSFER_SIZE),           /* Max transfer size */	\
    USB_SHORT_GET_LOW(USB_DEVICE_DEMO_BCD_VERSION), USB_SHORT_GET_HIGH(USB_DEVICE_DEMO_BCD_VERSION), /* bcdDFUVersion */

#endif /* __USB_DEVICE_DESCRIPTOR_H__ */
