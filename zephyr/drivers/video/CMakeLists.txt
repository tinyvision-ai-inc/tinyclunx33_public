# Copyright (c) 2025 tinyVision.ai Inc.
# SPDX-License-Identifier: Apache-2.0

zephyr_library()

zephyr_include_directories(.)
zephyr_include_directories(${ZEPHYR_BASE}/drivers/video)
zephyr_library_sources_ifdef(CONFIG_VIDEO_IMX219 imx219.c)
