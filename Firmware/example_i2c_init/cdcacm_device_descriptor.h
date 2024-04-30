/*
 * Copyright 2017 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#ifndef _CDCACM_DEVICE_DESCRIPTOR_H_
#define _CDCACM_DEVICE_DESCRIPTOR_H_ 1

/*******************************************************************************
 * Definitions
 ******************************************************************************/

/* Communication Class SubClass Codes */
#define USB_CDC_DIRECT_LINE_CONTROL_MODEL (0x01)
#define USB_CDC_ABSTRACT_CONTROL_MODEL (0x02)
#define USB_CDC_TELEPHONE_CONTROL_MODEL (0x03)
#define USB_CDC_MULTI_CHANNEL_CONTROL_MODEL (0x04)
#define USB_CDC_CAPI_CONTROL_MOPDEL (0x05)
#define USB_CDC_ETHERNET_NETWORKING_CONTROL_MODEL (0x06)
#define USB_CDC_ATM_NETWORKING_CONTROL_MODEL (0x07)
#define USB_CDC_WIRELESS_HANDSET_CONTROL_MODEL (0x08)
#define USB_CDC_DEVICE_MANAGEMENT (0x09)
#define USB_CDC_MOBILE_DIRECT_LINE_MODEL (0x0A)
#define USB_CDC_OBEX (0x0B)
#define USB_CDC_ETHERNET_EMULATION_MODEL (0x0C)

/* Communication Class Protocol Codes */
#define USB_CDC_NO_CLASS_SPECIFIC_PROTOCOL (0x00) /*also for Data Class Protocol Code */
#define USB_CDC_AT_250_PROTOCOL (0x01)
#define USB_CDC_AT_PCCA_101_PROTOCOL (0x02)
#define USB_CDC_AT_PCCA_101_ANNEX_O (0x03)
#define USB_CDC_AT_GSM_7_07 (0x04)
#define USB_CDC_AT_3GPP_27_007 (0x05)
#define USB_CDC_AT_TIA_CDMA (0x06)
#define USB_CDC_ETHERNET_EMULATION_PROTOCOL (0x07)
#define USB_CDC_EXTERNAL_PROTOCOL (0xFE)
#define USB_CDC_VENDOR_SPECIFIC (0xFF) /*also for Data Class Protocol Code */

/* Data Class Protocol Codes */
#define USB_CDC_PYHSICAL_INTERFACE_PROTOCOL (0x30)
#define USB_CDC_HDLC_PROTOCOL (0x31)
#define USB_CDC_TRANSPARENT_PROTOCOL (0x32)
#define USB_CDC_MANAGEMENT_PROTOCOL (0x50)
#define USB_CDC_DATA_LINK_Q931_PROTOCOL (0x51)
#define USB_CDC_DATA_LINK_Q921_PROTOCOL (0x52)
#define USB_CDC_DATA_COMPRESSION_V42BIS (0x90)
#define USB_CDC_EURO_ISDN_PROTOCOL (0x91)
#define USB_CDC_RATE_ADAPTION_ISDN_V24 (0x92)
#define USB_CDC_CAPI_COMMANDS (0x93)
#define USB_CDC_HOST_BASED_DRIVER (0xFD)
#define USB_CDC_UNIT_FUNCTIONAL (0xFE)

/* Descriptor SubType in Communications Class Functional Descriptors */
#define USB_CDC_HEADER_FUNC_DESC (0x00)
#define USB_CDC_CALL_MANAGEMENT_FUNC_DESC (0x01)
#define USB_CDC_ABSTRACT_CONTROL_FUNC_DESC (0x02)
#define USB_CDC_DIRECT_LINE_FUNC_DESC (0x03)
#define USB_CDC_TELEPHONE_RINGER_FUNC_DESC (0x04)
#define USB_CDC_TELEPHONE_REPORT_FUNC_DESC (0x05)
#define USB_CDC_UNION_FUNC_DESC (0x06)
#define USB_CDC_COUNTRY_SELECT_FUNC_DESC (0x07)
#define USB_CDC_TELEPHONE_MODES_FUNC_DESC (0x08)
#define USB_CDC_TERMINAL_FUNC_DESC (0x09)
#define USB_CDC_NETWORK_CHANNEL_FUNC_DESC (0x0A)
#define USB_CDC_PROTOCOL_UNIT_FUNC_DESC (0x0B)
#define USB_CDC_EXTENSION_UNIT_FUNC_DESC (0x0C)
#define USB_CDC_MULTI_CHANNEL_FUNC_DESC (0x0D)
#define USB_CDC_CAPI_CONTROL_FUNC_DESC (0x0E)
#define USB_CDC_ETHERNET_NETWORKING_FUNC_DESC (0x0F)
#define USB_CDC_ATM_NETWORKING_FUNC_DESC (0x10)
#define USB_CDC_WIRELESS_CONTROL_FUNC_DESC (0x11)
#define USB_CDC_MOBILE_DIRECT_LINE_FUNC_DESC (0x12)
#define USB_CDC_MDLM_DETAIL_FUNC_DESC (0x13)
#define USB_CDC_DEVICE_MANAGEMENT_FUNC_DESC (0x14)
#define USB_CDC_OBEX_FUNC_DESC (0x15)
#define USB_CDC_COMMAND_SET_FUNC_DESC (0x16)
#define USB_CDC_COMMAND_SET_DETAIL_FUNC_DESC (0x17)
#define USB_CDC_TELEPHONE_CONTROL_FUNC_DESC (0x18)
#define USB_CDC_OBEX_SERVICE_ID_FUNC_DESC (0x19)

/* usb descriptor length */
#define USB_CDC_VCOM_REPORT_DESCRIPTOR_LENGTH (33)
#define USB_IAD_DESC_SIZE (8)
#define USB_DESCRIPTOR_LENGTH_CDC_HEADER_FUNC (5)
#define USB_DESCRIPTOR_LENGTH_CDC_CALL_MANAG (5)
#define USB_DESCRIPTOR_LENGTH_CDC_ABSTRACT (4)
#define USB_DESCRIPTOR_LENGTH_CDC_UNION_FUNC (5)

//#define USB_DEVICE_STRING_COUNT (8)
//#define USB_DEVICE_LANGUAGE_COUNT (1)

#define CDCACM_USB_INTERFACE_COUNT (4)

#define USB_COMPOSITE_CONFIGURE_INDEX (1)

#define USB_MSC_DISK_CLASS (0x08)
/* scsi command set */
#define USB_MSC_DISK_SUBCLASS (0x06)
/* bulk only transport protocol */
#define USB_MSC_DISK_PROTOCOL (0x50)

/* Configuration, interface and endpoint. */
#define USB_CDC_VCOM_CIC_CLASS (0x02)
#define USB_CDC_VCOM_CIC_SUBCLASS (0x02)
#define USB_CDC_VCOM_CIC_PROTOCOL (0x00)
#define USB_CDC_VCOM_DIC_CLASS (0x0A)
#define USB_CDC_VCOM_DIC_SUBCLASS (0x00)
#define USB_CDC_VCOM_DIC_PROTOCOL (0x00)

#define USB_CDC_VCOM_INTERFACE_COUNT (2)
#define USB_CDC_VCOM_INTERFACE_COUNT_2 (2)
#define USB_CDC_VCOM_CIC_INTERFACE_INDEX (0)
#define USB_CDC_VCOM_DIC_INTERFACE_INDEX (1)
#define USB_CDC_VCOM_CIC_INTERFACE_INDEX_2 (2)
#define USB_CDC_VCOM_DIC_INTERFACE_INDEX_2 (3)
#define USB_CDC_VCOM_CIC_ENDPOINT_COUNT (1)
#define USB_CDC_VCOM_CIC_ENDPOINT_COUNT_2 (1)
#define USB_CDC_VCOM_CIC_INTERRUPT_IN_ENDPOINT (1)
#define USB_CDC_VCOM_CIC_INTERRUPT_IN_ENDPOINT_2 (2)
#define USB_CDC_VCOM_DIC_ENDPOINT_COUNT (2)
#define USB_CDC_VCOM_DIC_ENDPOINT_COUNT_2 (2)
#define USB_CDC_VCOM_DIC_BULK_IN_ENDPOINT (3)
#define USB_CDC_VCOM_DIC_BULK_OUT_ENDPOINT (3)
#define USB_CDC_VCOM_DIC_BULK_IN_ENDPOINT_2 (6)
#define USB_CDC_VCOM_DIC_BULK_OUT_ENDPOINT_2 (6)
/* Packet size. */
#define HS_CDC_VCOM_INTERRUPT_IN_PACKET_SIZE (16)
#define FS_CDC_VCOM_INTERRUPT_IN_PACKET_SIZE (16)
#define HS_CDC_VCOM_INTERRUPT_IN_INTERVAL (0x07) /* 2^(7-1) = 8ms */
#define FS_CDC_VCOM_INTERRUPT_IN_INTERVAL (0x08)
/* Packet size. */
#define HS_CDC_VCOM_INTERRUPT_IN_PACKET_SIZE_2 (16)
#define FS_CDC_VCOM_INTERRUPT_IN_PACKET_SIZE_2 (16)
#define HS_CDC_VCOM_INTERRUPT_IN_INTERVAL_2 (0x07) /* 2^(7-1) = 8ms */
#define FS_CDC_VCOM_INTERRUPT_IN_INTERVAL_2 (0x08)

#define HS_CDC_VCOM_BULK_IN_PACKET_SIZE     (64)
#define FS_CDC_VCOM_BULK_IN_PACKET_SIZE     (64)
#define HS_CDC_VCOM_BULK_OUT_PACKET_SIZE    (64)
#define FS_CDC_VCOM_BULK_OUT_PACKET_SIZE    (64)

#define HS_CDC_VCOM_BULK_IN_PACKET_SIZE_2   (64)
#define FS_CDC_VCOM_BULK_IN_PACKET_SIZE_2   (64)
#define HS_CDC_VCOM_BULK_OUT_PACKET_SIZE_2  (64)
#define FS_CDC_VCOM_BULK_OUT_PACKET_SIZE_2  (64)

#define USB_DESCRIPTOR_TYPE_CDC_CS_INTERFACE (0x24)
#define USB_DESCRIPTOR_TYPE_CDC_CS_ENDPOINT (0x25)


#define TOTAL_CDCACM_DESCRIPTOR_LENGTH  ((USB_IAD_DESC_SIZE + USB_DESCRIPTOR_LENGTH_INTERFACE + USB_DESCRIPTOR_LENGTH_CDC_HEADER_FUNC +  \
                                          USB_DESCRIPTOR_LENGTH_CDC_CALL_MANAG + USB_DESCRIPTOR_LENGTH_CDC_ABSTRACT +    \
                                          USB_DESCRIPTOR_LENGTH_CDC_UNION_FUNC + USB_DESCRIPTOR_LENGTH_ENDPOINT +    \
                                          USB_DESCRIPTOR_LENGTH_INTERFACE + USB_DESCRIPTOR_LENGTH_ENDPOINT + \
                                          USB_DESCRIPTOR_LENGTH_ENDPOINT) * USB_DEVICE_CONFIG_CDC_ACM)


#define CDCACM_DESCRIPTOR_DATA    \
    /* Interface Association Descriptor */  \
    /* Size of this descriptor in bytes */  \
    USB_IAD_DESC_SIZE,  \
    /* INTERFACE_ASSOCIATION Descriptor Type  */    \
    USB_DESCRIPTOR_TYPE_INTERFACE_ASSOCIATION,  \
    /* The first interface number associated with this function */  \
    0x00,   \
    /* The number of contiguous interfaces associated with this function */ \
    0x02,   \
    /* The function belongs to the Communication Device/Interface Class  */ \
    USB_CDC_VCOM_CIC_CLASS, USB_CDC_VCOM_CIC_SUBCLASS,  \
    /* The function uses the No class specific protocol required Protocol  */   \
    0x00,   \
    /* The Function string descriptor index */  \
    4,   \
    \
    /* Interface Descriptor */  \
    USB_DESCRIPTOR_LENGTH_INTERFACE, USB_DESCRIPTOR_TYPE_INTERFACE, USB_CDC_VCOM_CIC_INTERFACE_INDEX, 0x00, \
    USB_CDC_VCOM_CIC_ENDPOINT_COUNT, USB_CDC_VCOM_CIC_CLASS, USB_CDC_VCOM_CIC_SUBCLASS, USB_CDC_VCOM_CIC_PROTOCOL, \
    0x08,    \
    \
    /* CDC Class-Specific descriptor */ \
    USB_DESCRIPTOR_LENGTH_CDC_HEADER_FUNC, /* Size of this descriptor in bytes */   \
    USB_DESCRIPTOR_TYPE_CDC_CS_INTERFACE,  /* CS_INTERFACE Descriptor Type */   \
    USB_CDC_HEADER_FUNC_DESC, 0x20, \
    0x01, /* USB Class Definitions for Communications the Communication specification version 1.10 */   \
    \
    USB_DESCRIPTOR_LENGTH_CDC_CALL_MANAG, /* Size of this descriptor in bytes */    \
    USB_DESCRIPTOR_TYPE_CDC_CS_INTERFACE, /* CS_INTERFACE Descriptor Type */    \
    USB_CDC_CALL_MANAGEMENT_FUNC_DESC,  \
    0x00, /*Bit 0: Whether device handle call management itself 1, Bit 1: Whether device can send/receive call  \
             management information over a Data Class Interface 0 */    \
    0x01, /* Indicates multiplexed commands are handled via data interface */   \
    \
    USB_DESCRIPTOR_LENGTH_CDC_ABSTRACT,   /* Size of this descriptor in bytes */    \
    USB_DESCRIPTOR_TYPE_CDC_CS_INTERFACE, /* CS_INTERFACE Descriptor Type */    \
    USB_CDC_ABSTRACT_CONTROL_FUNC_DESC, \
    0x02, /* Bit 0: Whether device supports the request combination of Set_Comm_Feature, Clear_Comm_Feature, and    \
             Get_Comm_Feature 0, Bit 1: Whether device supports the request combination of Set_Line_Coding, \
             Set_Control_Line_State, Get_Line_Coding, and the notification Serial_State 1, Bit ...  */  \
    \
    USB_DESCRIPTOR_LENGTH_CDC_UNION_FUNC, /* Size of this descriptor in bytes */    \
    USB_DESCRIPTOR_TYPE_CDC_CS_INTERFACE, /* CS_INTERFACE Descriptor Type */    \
    USB_CDC_UNION_FUNC_DESC,    \
    USB_CDC_VCOM_CIC_INTERFACE_INDEX, /* The interface number of the Communications or Data Class interface  */ \
    USB_CDC_VCOM_DIC_INTERFACE_INDEX, /* Interface number of subordinate interface in the Union  */ \
    \
    /*Notification Endpoint descriptor */   \
    USB_DESCRIPTOR_LENGTH_ENDPOINT, USB_DESCRIPTOR_TYPE_ENDPOINT,   \
    USB_CDC_VCOM_CIC_INTERRUPT_IN_ENDPOINT | (USB_IN << 7U), USB_ENDPOINT_INTERRUPT,    \
    USB_SHORT_GET_LOW(HS_CDC_VCOM_INTERRUPT_IN_PACKET_SIZE), USB_SHORT_GET_HIGH(HS_CDC_VCOM_INTERRUPT_IN_PACKET_SIZE),  \
    HS_CDC_VCOM_INTERRUPT_IN_INTERVAL,  \
    \
    /* Data Interface Descriptor */ \
    USB_DESCRIPTOR_LENGTH_INTERFACE, USB_DESCRIPTOR_TYPE_INTERFACE, USB_CDC_VCOM_DIC_INTERFACE_INDEX, 0x00, \
    USB_CDC_VCOM_DIC_ENDPOINT_COUNT, USB_CDC_VCOM_DIC_CLASS, USB_CDC_VCOM_DIC_SUBCLASS, USB_CDC_VCOM_DIC_PROTOCOL,  \
    0x09, /* Interface Description String Index*/   \
    \
    /*Bulk IN Endpoint descriptor */    \
    USB_DESCRIPTOR_LENGTH_ENDPOINT, USB_DESCRIPTOR_TYPE_ENDPOINT, USB_CDC_VCOM_DIC_BULK_IN_ENDPOINT | (USB_IN << 7U),   \
    USB_ENDPOINT_BULK, USB_SHORT_GET_LOW(HS_CDC_VCOM_BULK_IN_PACKET_SIZE),  \
    USB_SHORT_GET_HIGH(HS_CDC_VCOM_BULK_IN_PACKET_SIZE), 0x00, /* The polling interval value is every 0 Frames */   \
    \
    /*Bulk OUT Endpoint descriptor */   \
    USB_DESCRIPTOR_LENGTH_ENDPOINT, USB_DESCRIPTOR_TYPE_ENDPOINT, USB_CDC_VCOM_DIC_BULK_OUT_ENDPOINT | (USB_OUT << 7U), \
    USB_ENDPOINT_BULK, USB_SHORT_GET_LOW(HS_CDC_VCOM_BULK_OUT_PACKET_SIZE), \
    USB_SHORT_GET_HIGH(HS_CDC_VCOM_BULK_OUT_PACKET_SIZE), 0x00, /* The polling interval value is every 0 Frames */  \
    \
    /*****VCOM_2 descriptor*****/   \
    /* Interface Association Descriptor */  \
    /* Size of this descriptor in bytes */  \
    USB_IAD_DESC_SIZE,  \
    /* INTERFACE_ASSOCIATION Descriptor Type  */    \
    USB_DESCRIPTOR_TYPE_INTERFACE_ASSOCIATION,  \
    /* The first interface number associated with this function */  \
    0x02,   \
    /* The number of contiguous interfaces associated with this function */ \
    0x02,   \
    /* The function belongs to the Communication Device/Interface Class  */ \
    USB_CDC_VCOM_CIC_CLASS, USB_CDC_VCOM_CIC_SUBCLASS,  \
    /* The function uses the No class specific protocol required Protocol  */   \
    0x00,   \
    /* The Function string descriptor index */  \
    5,   \
	\
    /* CDC Interface Descriptor */  \
    USB_DESCRIPTOR_LENGTH_INTERFACE, USB_DESCRIPTOR_TYPE_INTERFACE, USB_CDC_VCOM_CIC_INTERFACE_INDEX_2, 0x00,   \
    USB_CDC_VCOM_CIC_ENDPOINT_COUNT_2, USB_CDC_VCOM_CIC_CLASS, USB_CDC_VCOM_CIC_SUBCLASS, USB_CDC_VCOM_CIC_PROTOCOL,    \
    0x0A,   \
    \
    /* CDC Class-Specific descriptor */ \
    USB_DESCRIPTOR_LENGTH_CDC_HEADER_FUNC, /* Size of this descriptor in bytes */   \
    USB_DESCRIPTOR_TYPE_CDC_CS_INTERFACE,  /* CS_INTERFACE Descriptor Type */   \
    USB_CDC_HEADER_FUNC_DESC, 0x20, \
    0x01, /* USB Class Definitions for Communications the Communication specification version 1.10 */   \
    \
    USB_DESCRIPTOR_LENGTH_CDC_CALL_MANAG, /* Size of this descriptor in bytes */    \
    USB_DESCRIPTOR_TYPE_CDC_CS_INTERFACE, /* CS_INTERFACE Descriptor Type */    \
    USB_CDC_CALL_MANAGEMENT_FUNC_DESC,  \
    0x00, /*Bit 0: Whether device handle call management itself 1, Bit 1: Whether device can send/receive call  \
             management information over a Data Class Interface 0 */    \
    0x01, /* Indicates multiplexed commands are handled via data interface */   \
    \
    USB_DESCRIPTOR_LENGTH_CDC_ABSTRACT,   /* Size of this descriptor in bytes */    \
    USB_DESCRIPTOR_TYPE_CDC_CS_INTERFACE, /* CS_INTERFACE Descriptor Type */    \
    USB_CDC_ABSTRACT_CONTROL_FUNC_DESC, \
    0x02, /* Bit 0: Whether device supports the request combination of Set_Comm_Feature, Clear_Comm_Feature, and    \
             Get_Comm_Feature 0, Bit 1: Whether device supports the request combination of Set_Line_Coding, \
             Set_Control_Line_State, Get_Line_Coding, and the notification Serial_State 1, Bit ...  */  \
    \
    USB_DESCRIPTOR_LENGTH_CDC_UNION_FUNC, /* Size of this descriptor in bytes */    \
    USB_DESCRIPTOR_TYPE_CDC_CS_INTERFACE, /* CS_INTERFACE Descriptor Type */    \
    USB_CDC_UNION_FUNC_DESC,    \
    USB_CDC_VCOM_CIC_INTERFACE_INDEX_2, /* The interface number of the Communications or Data Class interface  */   \
    USB_CDC_VCOM_DIC_INTERFACE_INDEX_2, /* Interface number of subordinate interface in the Union  */   \
    \
    /*Notification Endpoint descriptor */   \
    USB_DESCRIPTOR_LENGTH_ENDPOINT, USB_DESCRIPTOR_TYPE_ENDPOINT,   \
    USB_CDC_VCOM_CIC_INTERRUPT_IN_ENDPOINT_2 | (USB_IN << 7U), USB_ENDPOINT_INTERRUPT,  \
    USB_SHORT_GET_LOW(HS_CDC_VCOM_INTERRUPT_IN_PACKET_SIZE_2),  \
    USB_SHORT_GET_HIGH(HS_CDC_VCOM_INTERRUPT_IN_PACKET_SIZE_2), HS_CDC_VCOM_INTERRUPT_IN_INTERVAL_2,    \
    \
    /* Data Interface Descriptor */ \
    USB_DESCRIPTOR_LENGTH_INTERFACE, USB_DESCRIPTOR_TYPE_INTERFACE, USB_CDC_VCOM_DIC_INTERFACE_INDEX_2, 0x00,   \
    USB_CDC_VCOM_DIC_ENDPOINT_COUNT_2, USB_CDC_VCOM_DIC_CLASS, USB_CDC_VCOM_DIC_SUBCLASS, USB_CDC_VCOM_DIC_PROTOCOL,    \
    0x0B, /* Interface Description String Index*/   \
    \
    /*Bulk IN Endpoint descriptor */    \
    USB_DESCRIPTOR_LENGTH_ENDPOINT, USB_DESCRIPTOR_TYPE_ENDPOINT, USB_CDC_VCOM_DIC_BULK_IN_ENDPOINT_2 | (USB_IN << 7U), \
    USB_ENDPOINT_BULK, USB_SHORT_GET_LOW(HS_CDC_VCOM_BULK_IN_PACKET_SIZE_2),    \
    USB_SHORT_GET_HIGH(HS_CDC_VCOM_BULK_IN_PACKET_SIZE_2), 0x00, /* The polling interval value is every 0 Frames */ \
    \
    /*Bulk OUT Endpoint descriptor */   \
    USB_DESCRIPTOR_LENGTH_ENDPOINT, USB_DESCRIPTOR_TYPE_ENDPOINT,   \
    USB_CDC_VCOM_DIC_BULK_OUT_ENDPOINT_2 | (USB_OUT << 7U), USB_ENDPOINT_BULK,  \
    USB_SHORT_GET_LOW(HS_CDC_VCOM_BULK_OUT_PACKET_SIZE_2), USB_SHORT_GET_HIGH(HS_CDC_VCOM_BULK_OUT_PACKET_SIZE_2),  \
    0x00 /* The polling interval value is every 0 Frames */

#endif /* _CDCACM_DEVICE_DESCRIPTOR_H_ */
