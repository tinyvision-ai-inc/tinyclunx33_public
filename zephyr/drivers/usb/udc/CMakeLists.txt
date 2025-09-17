# Copyright (c) 2024 tinyVision.ai Inc.
# SPDX-License-Identifier: Apache-2.0

zephyr_library()

zephyr_include_directories(.)
zephyr_include_directories(${ZEPHYR_BASE}/drivers/usb/udc)
zephyr_library_sources_ifdef(CONFIG_UDC_DWC3 udc_dwc3.c)
zephyr_library_sources_ifdef(CONFIG_UDC_DWC3_SHELL udc_dwc3_shell.c)
