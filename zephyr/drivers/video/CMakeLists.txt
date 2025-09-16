# Copyright (c) 2024 tinyVision.ai Inc.
# SPDX-License-Identifier: Apache-2.0

zephyr_library()

if (NOT DEFINED UVCMANAGER)
  set(UVCMANAGER ${ZEPHYR_BASE}/../zephyr_private/uvcmanager.6.o)
endif()

zephyr_include_directories(.)
zephyr_include_directories(${ZEPHYR_BASE}/drivers/video)
zephyr_library_sources_ifdef(CONFIG_VIDEO_IMX219 imx219.c)
zephyr_library_sources_ifdef(CONFIG_VIDEO_LATTICE_CSI2RX lscc_csi2rx.c)
zephyr_library_sources_ifdef(CONFIG_VIDEO_TINYVISION_DEBAYER tvai_debayer.c)
zephyr_library_sources_ifdef(CONFIG_VIDEO_TINYVISION_STACKER tvai_stacker.c)
zephyr_library_sources_ifdef(CONFIG_VIDEO_TINYVISION_STATS tvai_stats.c)
zephyr_library_sources_ifdef(CONFIG_VIDEO_TINYVISION_TESTPATTERN tvai_testpattern.c)
zephyr_library_sources_ifdef(CONFIG_VIDEO_TINYVISION_UNPACKER tvai_unpacker.c)
zephyr_library_sources_ifdef(CONFIG_VIDEO_TINYVISION_UVCMANAGER tvai_uvcmanager.c ${UVCMANAGER})
