/*
 * Copyright (c) 2024-2025 tinyVision.ai Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define DT_DRV_COMPAT lattice_csi2rx

#include <stdlib.h>

#include <zephyr/device.h>
#include <zephyr/kernel.h>
#include <zephyr/drivers/video.h>
#include <zephyr/sys/byteorder.h>
#include <zephyr/shell/shell.h>

#include "video_device.h"

LOG_MODULE_REGISTER(csi2rx, CONFIG_VIDEO_LOG_LEVEL);

/* tinyVision.ai quirk: use 32-bit addresses: 2 lower address bits are always 0 */
#define LSCC_CSI2RX_REG(addr)			((addr) << 2)
#define LSCC_CSI2RX_WRITE(val, addr)		sys_write32((val), (addr))
#define LSCC_CSI2RX_READ(addr)			sys_read32((addr))

#define LSCC_CSI2RX_REG_LANE_SETTING		LSCC_CSI2RX_REG(0x0A)

#define LSCC_CSI2RX_REG_VC_DT			LSCC_CSI2RX_REG(0x1F)
#define LSCC_CSI2RX_REG_WCL			LSCC_CSI2RX_REG(0x20)
#define LSCC_CSI2RX_REG_WCH			LSCC_CSI2RX_REG(0x21)
#define LSCC_CSI2RX_REG_ECC			LSCC_CSI2RX_REG(0x22)

#define LSCC_CSI2RX_REG_VC_DT2			LSCC_CSI2RX_REG(0x23)
#define LSCC_CSI2RX_REG_WC2L			LSCC_CSI2RX_REG(0x24)
#define LSCC_CSI2RX_REG_WC2H			LSCC_CSI2RX_REG(0x25)
#define LSCC_CSI2RX_REG_ECC2			LSCC_CSI2RX_REG(0x26)

#define LSCC_CSI2RX_REG_REFDT			LSCC_CSI2RX_REG(0x27)
#define LSCC_CSI2RX_VAL_REFDT_RAW6		0x28
#define LSCC_CSI2RX_VAL_REFDT_RAW7		0x29
#define LSCC_CSI2RX_VAL_REFDT_RAW8		0x2A
#define LSCC_CSI2RX_VAL_REFDT_RAW10		0x2B
#define LSCC_CSI2RX_VAL_REFDT_RAW12		0x2C
#define LSCC_CSI2RX_VAL_REFDT_RAW14		0x2D

#define LSCC_CSI2RX_REG_ERROR_STATUS		LSCC_CSI2RX_REG(0x28)
#define LSCC_CSI2RX_REG_ERROR_STATUS_EN		LSCC_CSI2RX_REG(0x29)
#define LSCC_CSI2RX_REG_CRC_BYTE_LOW		LSCC_CSI2RX_REG(0x30)
#define LSCC_CSI2RX_REG_CRC_BYTE_HIGH		LSCC_CSI2RX_REG(0x31)
#define LSCC_CSI2RX_REG_ERROR_CTRL		LSCC_CSI2RX_REG(0x32)
#define LSCC_CSI2RX_REG_ERROR_HS_SOT		LSCC_CSI2RX_REG(0x33)
#define LSCC_CSI2RX_REG_ERROR_HS_SOT_SYNC	LSCC_CSI2RX_REG(0x34)
#define LSCC_CSI2RX_REG_CONTROL			LSCC_CSI2RX_REG(0x35)
#define LSCC_CSI2RX_REG_NOCIL_DSETTLE		LSCC_CSI2RX_REG(0x36)
#define LSCC_CSI2RX_REG_NOCIL_RXFIFODEL_LSB	LSCC_CSI2RX_REG(0x37)
#define LSCC_CSI2RX_REG_NOCIL_RXFIFODEL_MSB	LSCC_CSI2RX_REG(0x38)
#define LSCC_CSI2RX_REG_ERROR_SOT_SYNC_DET	LSCC_CSI2RX_REG(0x39)


struct lscc_csi2rx_config {
	const struct device *source_dev;
	uint32_t base;
};

struct lscc_csi2rx_reg {
	uint32_t addr;
	const char *name;
	const char *description;
};

static int lscc_csi2rx_init(const struct device *dev)
{
	const struct lscc_csi2rx_config *cfg = dev->config;

	/* Setup the default Reference Data Type to RAW10 to only allow RAW10 data in by default */
	LSCC_CSI2RX_WRITE(LSCC_CSI2RX_VAL_REFDT_RAW10, cfg->base + LSCC_CSI2RX_REG_REFDT);

	/* Set the default settle time */
	LSCC_CSI2RX_WRITE(0x05, cfg->base + LSCC_CSI2RX_REG_NOCIL_DSETTLE);

	return 0;
}

static int lscc_csi2rx_set_format(const struct device *dev, struct video_format *fmt)
{
	const struct lscc_csi2rx_config *cfg = dev->config;
	int ret;

	ret = video_set_format(cfg->source_dev, fmt);
	fmt->pitch = fmt->width * video_bits_per_pixel(fmt->pixelformat) / BITS_PER_BYTE;
	return ret;
}

static int lscc_csi2rx_get_format(const struct device *dev, struct video_format *fmt)
{
	const struct lscc_csi2rx_config *cfg = dev->config;

	return video_get_format(cfg->source_dev, fmt);
}

static int lscc_csi2rx_get_caps(const struct device *dev, struct video_caps *caps)
{
	const struct lscc_csi2rx_config *cfg = dev->config;

	return video_get_caps(cfg->source_dev, caps);
}

static int lscc_csi2rx_set_frmival(const struct device *dev, struct video_frmival *frmival)
{
	const struct lscc_csi2rx_config *cfg = dev->config;

	return video_set_frmival(cfg->source_dev, frmival);
}

static int lscc_csi2rx_get_frmival(const struct device *dev, struct video_frmival *frmival)
{
	const struct lscc_csi2rx_config *cfg = dev->config;

	return video_get_frmival(cfg->source_dev, frmival);
}

static int lscc_csi2rx_enum_frmival(const struct device *dev, struct video_frmival_enum *fie)
{
	const struct lscc_csi2rx_config *cfg = dev->config;

	return video_enum_frmival(cfg->source_dev, fie);
}

static int lscc_csi2rx_set_stream(const struct device *dev, bool on, enum video_buf_type type)
{
	const struct lscc_csi2rx_config *cfg = dev->config;

	return on ? video_stream_start(cfg->source_dev, VIDEO_BUF_TYPE_OUTPUT)
		  : video_stream_stop(cfg->source_dev, VIDEO_BUF_TYPE_OUTPUT);
}

static const DEVICE_API(video, lscc_csi2rx_driver_api) = {
	.set_format = lscc_csi2rx_set_format,
	.get_format = lscc_csi2rx_get_format,
	.get_caps = lscc_csi2rx_get_caps,
	.set_frmival = lscc_csi2rx_set_frmival,
	.get_frmival = lscc_csi2rx_get_frmival,
	.enum_frmival = lscc_csi2rx_enum_frmival,
	.set_stream = lscc_csi2rx_set_stream,
};

#define SOURCE_DEV(n) DEVICE_DT_GET(DT_NODE_REMOTE_DEVICE(DT_INST_ENDPOINT_BY_ID(n, 0, 0)))

#define LSCC_CSI2RX_DEVICE_DEFINE(n)                                                               \
	const struct lscc_csi2rx_config lscc_csi2rx_cfg_##n = {                                    \
		.source_dev = SOURCE_DEV(n),                                                       \
		.base = DT_INST_REG_ADDR(n),                                                       \
	};                                                                                         \
                                                                                                   \
	DEVICE_DT_INST_DEFINE(n, lscc_csi2rx_init, NULL, NULL, &lscc_csi2rx_cfg_##n,               \
			      POST_KERNEL, CONFIG_VIDEO_INIT_PRIORITY, &lscc_csi2rx_driver_api);   \
                                                                                                   \
	VIDEO_DEVICE_DEFINE(lcss_csi2rx##n, DEVICE_DT_INST_GET(n), SOURCE_DEV(n));

DT_INST_FOREACH_STATUS_OKAY(LSCC_CSI2RX_DEVICE_DEFINE)

/* Shell commands */

static bool device_is_video_and_ready(const struct device *dev)
{
	return device_is_ready(dev) && DEVICE_API_IS(video, dev);
}

static int cmd_tvai_csi2rx_show(const struct shell *sh, size_t argc, char **argv)
{
	const struct device *dev;
	const struct lscc_csi2rx_config *cfg;

	__ASSERT_NO_MSG(argc == 2);

	dev = device_get_binding(argv[1]);
	if (dev == NULL || !device_is_video_and_ready(dev)) {
		shell_error(sh, "could not find a video device ready with that name");
		return -ENODEV;
	}

	cfg = dev->config;

	shell_print(sh, "--------------------------------");
	shell_print(sh, "CSI2RX Configuration Registers:");

	shell_print(sh, "config.refdt     : 0x%02x   # Reference data type filtering packets",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_REFDT));
	shell_print(sh, "config.dsettle   : 0x%02x   # Data settle time",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_NOCIL_DSETTLE));
	shell_print(sh, "config.rxfifodel : 0x%02x   # RX FIFO delay",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_NOCIL_RXFIFODEL_LSB) << 0 |
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_NOCIL_RXFIFODEL_MSB) << 8);
	shell_print(sh, "config.control   : 0x%02x   # Control register",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_CONTROL));

	shell_print(sh, "--------------------------------");
	shell_print(sh, "MIPI Status Registers:");

	shell_print(sh, "mipi.crc         : 0x%04x # Received payload CRC value",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_CRC_BYTE_LOW) << 0 |
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_CRC_BYTE_HIGH) << 8);
	shell_print(sh, "packet1.words    : %-6u # Packet word count field",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_WCL) << 0 |
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_WCH) << 8);
	shell_print(sh, "packet1.checksum : 0x%02x   # Packet checksum field",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_ECC));
	shell_print(sh, "packet1.datatype : 0x%02x   # packet data-type/virtual-channel field",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_VC_DT));
	shell_print(sh, "packet2.words    : %-6u # Packet word count field",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_WC2L) << 0 |
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_WC2H) << 8);
	shell_print(sh, "packet2.checksum : 0x%02x   # Packet checksum field",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_ECC2));
	shell_print(sh, "packet2.datatype : 0x%02x   # packet data-type/virtual-channel field",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_VC_DT2));

	shell_print(sh, "--------------------------------");
	shell_print(sh, "MIPI Rx Errors:");

	shell_print(sh, "mipi.ecccrc      : 0x%02x   # ECC and CRC errors",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_ERROR_STATUS));
	shell_print(sh, "mipi.dphyctl     : 0x%02x   # D-PHY errors",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_ERROR_CTRL));
	shell_print(sh, "mipi.sot         : 0x%02x   # Start-of-transmission errors",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_ERROR_HS_SOT));
	shell_print(sh, "mipi.sotsync     : 0x%02x   # Start-of-transmission synchronization errs",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_ERROR_HS_SOT_SYNC));
	shell_print(sh, "mipi.sotsyncdet  : 0x%02x   # Start-of-transmission synch detection errs",
		    LSCC_CSI2RX_READ(cfg->base + LSCC_CSI2RX_REG_ERROR_HS_SOT_SYNC));

	return 0;
}

static int cmd_tvai_csi2rx_clear(const struct shell *sh, size_t argc, char **argv)
{
	const struct device *dev;
	const struct lscc_csi2rx_config *cfg;

	__ASSERT_NO_MSG(argc == 2);

	dev = device_get_binding(argv[1]);
	if (dev == NULL || !device_is_video_and_ready(dev)) {
		shell_error(sh, "could not find a video device ready with that name");
		return -ENODEV;
	}

	cfg = dev->config;

	/* Clear error registers by writing 1 to them */
	LSCC_CSI2RX_WRITE(0xFF, cfg->base + LSCC_CSI2RX_REG_ERROR_STATUS);
	LSCC_CSI2RX_WRITE(0xFF, cfg->base + LSCC_CSI2RX_REG_ERROR_CTRL);
	LSCC_CSI2RX_WRITE(0xFF, cfg->base + LSCC_CSI2RX_REG_ERROR_HS_SOT);
	LSCC_CSI2RX_WRITE(0xFF, cfg->base + LSCC_CSI2RX_REG_ERROR_HS_SOT_SYNC);
	LSCC_CSI2RX_WRITE(0xFF, cfg->base + LSCC_CSI2RX_REG_ERROR_SOT_SYNC_DET);

	shell_print(sh, "MIPI error registers cleared");

	return 0;
}

static int cmd_tvai_csi2rx_set(const struct shell *sh, size_t argc, char **argv, uint32_t reg)
{
	const struct device *dev;
	const struct lscc_csi2rx_config *cfg;
	int cur_value;
	int new_value;
	char *end = NULL;

	__ASSERT_NO_MSG(argc == 2 || argc == 3);

	dev = device_get_binding(argv[1]);
	if (dev == NULL || !device_is_video_and_ready(dev)) {
		shell_error(sh, "could not find a video device ready with that name");
		return -ENODEV;
	}

	cfg = dev->config;

	cur_value = LSCC_CSI2RX_READ(cfg->base + reg);

	if (argc == 2) {
		shell_print(sh, "Current value: %u", cur_value);
		return 0;
	}

	if (strchr("+-", argv[2][0]) != NULL) {
		new_value = CLAMP(cur_value + strtol(argv[2], &end, 10), 0x00, 0xff);
	} else {
		new_value = strtoll(argv[2], &end, 10);
	}

	if (*end != '\0') {
		shell_error(sh, "Invalid number %s", argv[2]);
		shell_error(sh, "+<n> to increment, -<n> to decrement, <n> to set absolute value");
		return -EINVAL;
	}

	LSCC_CSI2RX_WRITE(new_value, cfg->base + reg);

	shell_print(sh, "Register changed from %u to %u", cur_value, new_value);

	return 0;
}

static int cmd_tvai_csi2rx_settle(const struct shell *sh, size_t argc, char **argv)
{
	return cmd_tvai_csi2rx_set(sh, argc, argv, LSCC_CSI2RX_REG_NOCIL_DSETTLE);
}

static int cmd_tvai_csi2rx_delay(const struct shell *sh, size_t argc, char **argv)
{
	return cmd_tvai_csi2rx_set(sh, argc, argv, LSCC_CSI2RX_REG_NOCIL_RXFIFODEL_LSB);
}

static void device_name_get(size_t idx, struct shell_static_entry *entry)
{
	const struct device *dev = shell_device_filter(idx, device_is_video_and_ready);

	entry->syntax = (dev != NULL) ? dev->name : NULL;
	entry->handler = NULL;
	entry->help = NULL;
	entry->subcmd = NULL;
}
SHELL_DYNAMIC_CMD_CREATE(dsub_device_name, device_name_get);

SHELL_STATIC_SUBCMD_SET_CREATE(
	sub_tvai_csi2rx,

	SHELL_CMD_ARG(clear, &dsub_device_name, "Clear MIPI CSI-2 error registers",
		      cmd_tvai_csi2rx_clear, 2, 0),
	SHELL_CMD_ARG(show, &dsub_device_name, "Display MIPI CSI-2 registers",
		      cmd_tvai_csi2rx_show, 2, 0),
	SHELL_CMD_ARG(settle, &dsub_device_name, "Adjust the settle cycle register",
		      cmd_tvai_csi2rx_settle, 2, 1),
	SHELL_CMD_ARG(delay, &dsub_device_name, "Adjust the RX fifo delay register",
		      cmd_tvai_csi2rx_delay, 2, 1),

	SHELL_SUBCMD_SET_END);

SHELL_CMD_REGISTER(tvai_csi2rx, &sub_tvai_csi2rx, "Lattice DPHY RX commands", NULL);
