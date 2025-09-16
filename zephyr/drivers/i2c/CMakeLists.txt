# Copyright (c) 2024 tinyVision.ai Inc.
# SPDX-License-Identifier: Apache-2.0

zephyr_library()

zephyr_library_sources_ifdef(CONFIG_I2C_PCA9542A i2c_pca9542a.c)
zephyr_library_sources_ifdef(CONFIG_I2C_OPENCORES i2c_opencores.c)
