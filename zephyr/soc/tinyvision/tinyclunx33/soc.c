/*
 * Copyright (c) 2024 Vogl Electronic GmbH
 * Copyright (c) 2024 tinyVision.ai Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define DT_DRV_COMPAT tinyvision_soc_controller

#include <zephyr/kernel.h>
#include <zephyr/devicetree.h>
#include <zephyr/sys/reboot.h>
#include <zephyr/sys/util.h>

void sys_arch_reboot(int type)
{
	ARG_UNUSED(type);
	sys_write8(BIT(0), DT_INST_REG_ADDR_BY_NAME(0, reset));
}
