/*
 * Copyright (c) 2015 - 2016, Freescale Semiconductor, Inc.
 * Copyright 2016 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#ifndef __USB_DEVICE_H__
#define __USB_DEVICE_H__

#include <stdint.h>

/*! @brief Defines Get/Set status Types */
typedef enum _usb_device_status
{
    kUSB_DeviceStatusTestMode = 1U,  /*!< Test mode */
    kUSB_DeviceStatusSpeed,          /*!< Current speed */
    kUSB_DeviceStatusOtg,            /*!< OTG status */
    kUSB_DeviceStatusDevice,         /*!< Device status */
    kUSB_DeviceStatusEndpoint,       /*!< Endpoint state usb_device_endpoint_status_t */
    kUSB_DeviceStatusDeviceState,    /*!< Device state */
    kUSB_DeviceStatusAddress,        /*!< Device address */
    kUSB_DeviceStatusSynchFrame,     /*!< Current frame */
    kUSB_DeviceStatusBus,            /*!< Bus status */
    kUSB_DeviceStatusBusSuspend,     /*!< Bus suspend */
    kUSB_DeviceStatusBusSleep,       /*!< Bus suspend */
    kUSB_DeviceStatusBusResume,      /*!< Bus resume */
    kUSB_DeviceStatusRemoteWakeup,   /*!< Remote wakeup state */
    kUSB_DeviceStatusBusSleepResume, /*!< Bus resume */
#if defined(USB_DEVICE_CONFIG_GET_SOF_COUNT) && (USB_DEVICE_CONFIG_GET_SOF_COUNT > 0U)
    kUSB_DeviceStatusGetCurrentFrameCount, /*!< Get current frame count */
#endif
} usb_device_status_t;

/*! @brief Defines USB 2.0 device state */
typedef enum _usb_device_state
{
    kUSB_DeviceStateConfigured = 0U, /*!< Device state, Configured*/
    kUSB_DeviceStateAddress,         /*!< Device state, Address*/
    kUSB_DeviceStateDefault,         /*!< Device state, Default*/
    kUSB_DeviceStateAddressing,      /*!< Device state, Address setting*/
    kUSB_DeviceStateTestMode,        /*!< Device state, Test mode*/
} usb_device_state_t;

/*! @brief Defines endpoint state */
typedef enum _usb_endpoint_status
{
    kUSB_DeviceEndpointStateIdle = 0U, /*!< Endpoint state, idle*/
    kUSB_DeviceEndpointStateStalled,   /*!< Endpoint state, stalled*/
} usb_device_endpoint_status_t;

/*! @brief Control endpoint index */
#define USB_CONTROL_ENDPOINT (0U)
/*! @brief Control endpoint maxPacketSize */
#define USB_CONTROL_MAX_PACKET_SIZE (64U)

#if (USB_DEVICE_CONFIG_EHCI && (USB_CONTROL_MAX_PACKET_SIZE != (64U)))
#error For high speed, USB_CONTROL_MAX_PACKET_SIZE must be 64!!!
#endif

/*! @brief The setup packet size of USB control transfer. */
#define USB_SETUP_PACKET_SIZE (8U)
/*! @brief  USB endpoint mask */
#define USB_ENDPOINT_NUMBER_MASK (0x0FU)

/*! @brief uninitialized value */
#define USB_UNINITIALIZED_VAL_32 (0xFFFFFFFFU)

/*! @brief the endpoint callback length of cancelled transfer */
#define USB_CANCELLED_TRANSFER_LENGTH (0xFFFFFFFFU)

/*! @brief invalid tranfer buffer addresss */
#define USB_INVALID_TRANSFER_BUFFER (0xFFFFFFFEU)

#if defined(USB_DEVICE_CONFIG_GET_SOF_COUNT) && (USB_DEVICE_CONFIG_GET_SOF_COUNT > 0U)
/* USB device IP3511 max frame count */
#define USB_DEVICE_IP3511_MAX_FRAME_COUNT (0x000007FFU)
/* USB device EHCI max frame count */
#define USB_DEVICE_EHCI_MAX_FRAME_COUNT (0x00003FFFU)
/* USB device EHCI max frame count */
#define USB_DEVICE_KHCI_MAX_FRAME_COUNT (0x000007FFU)
#endif

#endif /* __USB_DEVICE_H__ */
