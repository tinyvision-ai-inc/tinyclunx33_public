/* usb_cdc_raw.h - USB CDC-RAW public header */

/*
 * Copyright (c) 2024 tinyVision.ai Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/**
 * @file
 * @brief USB Communications Device Class (CDC) alternate RAW API
 *
 * The difference with usb_cdc.h is that this exposes a read()/write() API
 * that immediately turns the buffers passed to the driver, allowing an
 * application to work with USB at a lower level, without buffering involved.
 */

#ifndef ZEPHYR_INCLUDE_USB_CLASS_USB_CDC_RAW_H_
#define ZEPHYR_INCLUDE_USB_CLASS_USB_CDC_RAW_H_

/**
 * Callback invoked when a read or write operation completes
 */
typedef int cdc_raw_callback_t(const struct device *dev, struct net_buf *buf, int err);

/**
 * @brief Setup a callback called after an OUT USB transfer is done.
 *
 * The data goes from the host to device.
 * 
 * @param callback Function pointer called
 */
void cdc_raw_set_read_callback(const struct device *dev, cdc_raw_callback_t *callback);

/**
 * @brief Setup a callback called after an IN USB transfer is done.
 *
 * The data goes from device to the host.
 *
 * @param dev Pointer to the USB CDC RAW DeviceTree instance.
 * @param callback Function pointer that is called after every write is complete.
 */
void cdc_raw_set_write_callback(const struct device *dev, cdc_raw_callback_t *callback);

/**
 * @brief Initiate a read request to receive data from the host.
 *
 * The data will actually be transferred whenever the host requests for it.
 * After the transfer, a callback will be called with the buffer as argument,
 * allowing to handle the data transferred, then free it.
 *
 * @param dev Pointer to the USB CDC RAW DeviceTree instance.
 * @param buf Pointer to a net_buf structure, that can be freed from the callback.
 * @return 0 on success
 */
int cdc_raw_read(const struct device *dev, struct net_buf *buf);

/**
 * @brief Initiate a write request to send data to the host.
 *
 * The data will actually be transferred whenever the host requests for it.
 * After the transfer, a callback will be called with the buffer as argument,
 * allowing to free it.
 *
 * @param dev Pointer to the USB CDC RAW DeviceTree instance.
 * @param buf Pointer to a net_buf structure, that can be freed from the callback.
 * @param zlp Whether to flush the transfer or not.
 * @return 0 on success
 */
int cdc_raw_write(const struct device *dev, struct net_buf *buf, bool zlp);

/**
 * @brief Checks that the CDC ACM "DTR" control command was set by the host.
 *
 * @param dev Pointer to the USB CDC RAW DeviceTree instance.
 * @return true when the command was received any time in the past
 */
bool cdc_raw_is_ready(const struct device *dev);

#endif /* ZEPHYR_INCLUDE_USB_CLASS_USB_CDC_RAW_H_ */
