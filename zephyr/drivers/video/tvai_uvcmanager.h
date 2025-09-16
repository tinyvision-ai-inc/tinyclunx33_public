/*
 * Copyright (c) 2025 tinyVision.ai Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef ZEPHYR_DRIVERS_VIDEO_TVAI_UVCMANAGER_H
#define ZEPHYR_DRIVERS_VIDEO_TVAI_UVCMANAGER_H

void uvcmanager_lib_init(uint32_t base, uint32_t fifo);
void uvcmanager_lib_start(uint32_t base, uint32_t trb_addr, uint32_t depupdxfer, uint32_t depcmd);
void uvcmanager_lib_stop(uint32_t base);
void uvcmanager_lib_set_test_pattern(uint32_t base, uint32_t w, uint32_t h, uint32_t inc);
void uvcmanager_lib_set_format(uint32_t base, uint32_t pitch, uint32_t height);
void uvcmanager_lib_read(uint32_t base, uint8_t *buf_data, size_t buf_size);
void uvcmanager_lib_cmd_show(uint32_t base, const struct shell *sh);

#endif /* ZEPHYR_DRIVERS_VIDEO_TVAI_UVCMANAGER_H */
