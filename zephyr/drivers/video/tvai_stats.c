/*
 * Copyright (c) 2024-2025 tinyVision.ai Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define DT_DRV_COMPAT tinyvision_stats

#include <zephyr/device.h>
#include <zephyr/drivers/i2c.h>
#include <zephyr/drivers/video.h>
#include <zephyr/drivers/video-controls.h>
#include <zephyr/kernel.h>
#include <zephyr/sys/byteorder.h>
#include <zephyr/shell/shell.h>
#include <zephyr/logging/log.h>

#include "video_device.h"

LOG_MODULE_REGISTER(tvai_stats, CONFIG_VIDEO_LOG_LEVEL);

#define TVAI_STATS_SCRATCH    		0x0000
#define TVAI_STATS_CONTROL    		0x0004
#define TVAI_STATS_STATUS     		0x0008
#define TVAI_STATS_CONFIG     		0x000C
#define TVAI_STATS_NUM_FRAMES 		0x0010
#define TVAI_STATS_HEIGHT     		0x0014
#define TVAI_STATS_WIDTH      		0x0016
#define TVAI_STATS_IMAGE_GAIN 		0x0018
#define TVAI_STATS_CHAN_AVG_0 		0x001C
#define TVAI_STATS_CHAN_AVG_1 		0x0020
#define TVAI_STATS_CHAN_AVG_2 		0x0024
#define TVAI_STATS_CHAN_AVG_3 		0x0028
#define TVAI_STATS_NUM_PIXELS 		0x002C
#define TVAI_STATS_ECC_ERROR_CMD 	0x0030
#define TVAI_STATS_ECC_BYTE_ERROR 	0x0034
#define TVAI_STATS_ECC_1BIT_ERROR 	0x0038
#define TVAI_STATS_ECC_2BIT_ERROR 	0x003C
#define TVAI_STATS_DELAY_ERROR 		0x0040
#define TVAI_STATS_UNDERFLOW_ERROR 	0x0044
#define TVAI_STATS_OVERFLOW_ERROR 	0x0048
#define TVAI_STATS_OVERFLOW_CMD   	0x004C
#define TVAI_STATS_OVERFLOW_F2S   	0x0050
#define TVAI_STATS_OVERFLOW_S2USB 	0x0054
#define TVAI_STATS_DROPPED_FRAMES 	0x0058

struct tvai_stats_config {
	uintptr_t base;
	const struct device *source_dev;
};

static int tvai_stats_get_caps(const struct device *dev, struct video_caps *caps)
{
	const struct tvai_stats_config *cfg = dev->config;

	return video_get_caps(cfg->source_dev, caps);
}

static int tvai_stats_set_format(const struct device *dev, struct video_format *fmt)
{
	const struct tvai_stats_config *cfg = dev->config;

	return video_set_format(cfg->source_dev, fmt);
}

static int tvai_stats_get_format(const struct device *dev, struct video_format *fmt)
{
	const struct tvai_stats_config *cfg = dev->config;

	return video_get_format(cfg->source_dev, fmt);
}

static int tvai_stats_set_frmival(const struct device *dev, struct video_frmival *frmival)
{
	const struct tvai_stats_config *cfg = dev->config;

	return video_set_frmival(cfg->source_dev, frmival);
}

static int tvai_stats_get_frmival(const struct device *dev, struct video_frmival *frmival)
{
	const struct tvai_stats_config *cfg = dev->config;

	return video_get_frmival(cfg->source_dev, frmival);
}

static int tvai_stats_enum_frmival(const struct device *dev, struct video_frmival_enum *fie)
{
	const struct tvai_stats_config *cfg = dev->config;

	return video_enum_frmival(cfg->source_dev, fie);
}

#if 0
static int tvai_stats_get_tvai_stats(const struct device *dev, uint16_t type_flags,
				     struct video_tvai_stats *tvai_stats_in)
{
	const struct tvai_stats_config *cfg = dev->config;
	uint8_t ch0 = sys_read32(cfg->base + TVAI_STATS_CHAN_AVG_0);
	uint8_t ch1 = sys_read32(cfg->base + TVAI_STATS_CHAN_AVG_1);
	uint8_t ch2 = sys_read32(cfg->base + TVAI_STATS_CHAN_AVG_2);
	uint8_t ch3 = sys_read32(cfg->base + TVAI_STATS_CHAN_AVG_3);
	struct video_channel_tvai_stats *tvai_stats = (void *)tvai_stats_in;
	struct video_format fmt;
	int ret;

	/* Unconditionally set the frame counter */
	tvai_stats->base.frame_counter = sys_read32(cfg->base + TVAI_STATS_NUM_FRAMES);

	if (type_flags == 0) {
		return 0;
	}

	if ((type_flags & VIDEO_TVAI_STATS_ASK_CHANNELS) == 0) {
		return -ENOTSUP;
	}

	ret = video_get_format(cfg->source_dev, VIDEO_EP_OUT, &fmt);
	if (ret < 0) {
		return ret;
	}

	/* Depending on the order of the bayer pattern, the channels will be positioned at a
	 * different location on the image sensor. i.e. for RGGB, CH0=R, CH1=G , CH2=G, CH3=B.
	 * [CH0, CH1, CH0, CH1, CH0, CH1, CH0, CH1, CH0, CH1...],
	 * [CH2, CH3, CH2, CH3, CH2, CH3, CH2, CH3, CH2, CH3...],
	 * [...]
	 */
	switch (fmt.pixelformat) {
	case VIDEO_PIX_FMT_BGGR8:
		tvai_stats->ch1 = ch3; /* red */
		tvai_stats->ch2 = (ch1 + ch2) / 2; /* green */
		tvai_stats->ch3 = ch0; /* blue */
		break;
	case VIDEO_PIX_FMT_GBRG8:
		tvai_stats->ch1 = ch2; /* red */
		tvai_stats->ch2 = (ch0 + ch3) / 2; /* green */
		tvai_stats->ch3 = ch1; /* blue */
		break;
	case VIDEO_PIX_FMT_GRBG8:
		tvai_stats->ch1 = ch1; /* red */
		tvai_stats->ch2 = (ch0 + ch3) / 2; /* green */
		tvai_stats->ch3 = ch2; /* blue */
		break;
	case VIDEO_PIX_FMT_RGGB8:
		tvai_stats->ch1 = ch0; /* red */
		tvai_stats->ch2 = (ch1 + ch2) / 2; /* green */
		tvai_stats->ch3 = ch3; /* blue */
		break;
	default:
		LOG_WRN("Unknown input pixel format, cannot decode the statistics");
	}

	/* Hardware bug */
	tvai_stats->ch1 = tvai_stats->ch1 == 255 ? 0 : tvai_stats->ch1;
	tvai_stats->ch2 = tvai_stats->ch2 == 255 ? 0 : tvai_stats->ch2;
	tvai_stats->ch3 = tvai_stats->ch3 == 255 ? 0 : tvai_stats->ch3;

	tvai_stats->base.type_flags = VIDEO_TVAI_STATS_CHANNELS_RGB;

	return 0;
}
#endif

static int tvai_stats_set_stream(const struct device *dev, bool on, enum video_buf_type type)
{
	const struct tvai_stats_config *cfg = dev->config;

	return on ? video_stream_start(cfg->source_dev, VIDEO_BUF_TYPE_OUTPUT)
		  : video_stream_stop(cfg->source_dev, VIDEO_BUF_TYPE_OUTPUT);
}

static const DEVICE_API(video, tvai_stats_driver_api) = {
	.set_format = tvai_stats_set_format,
	.get_format = tvai_stats_get_format,
	.get_caps = tvai_stats_get_caps,
	.set_frmival = tvai_stats_set_frmival,
	.get_frmival = tvai_stats_get_frmival,
	.enum_frmival = tvai_stats_enum_frmival,
	.set_stream = tvai_stats_set_stream,
#if 0 /* New API not upstreamed */
	.get_tvai_stats = tvai_stats_get_tvai_stats,
#endif
};

#define TVAI_STATS_INIT(n)                                                                         \
	const static struct tvai_stats_config tvai_stats_cfg_##n = {                               \
		.source_dev =                                                                      \
			DEVICE_DT_GET(DT_NODE_REMOTE_DEVICE(DT_INST_ENDPOINT_BY_ID(n, 0, 0))),     \
		.base = DT_INST_REG_ADDR(n),                                                       \
	};                                                                                         \
                                                                                                   \
	DEVICE_DT_INST_DEFINE(n, NULL, NULL, NULL, &tvai_stats_cfg_##n, POST_KERNEL,               \
			      CONFIG_VIDEO_INIT_PRIORITY, &tvai_stats_driver_api);                 \
                                                                                                   \
	VIDEO_DEVICE_DEFINE(tvai_stats##n, DEVICE_DT_INST_GET(n), NULL);

DT_INST_FOREACH_STATUS_OKAY(TVAI_STATS_INIT)

static bool device_is_video_and_ready(const struct device *dev)
{
	return device_is_ready(dev) && DEVICE_API_IS(video, dev);
}

static int cmd_tvai_stats_show(const struct shell *sh, size_t argc, char **argv)
{
	const struct device *dev;
	const struct tvai_stats_config *cfg;

	__ASSERT_NO_MSG(argc == 2);

	dev = device_get_binding(argv[1]);
	if (dev == NULL || !device_is_video_and_ready(dev)) {
		shell_error(sh, "could not find a video device ready with that name");
		return -ENODEV;
	}

	cfg = dev->config;

	shell_print(sh, "--------------------------------");
	shell_print(sh, "Frame stats:");
	shell_print(sh, "frame.count    : %u", sys_read32(cfg->base + TVAI_STATS_NUM_FRAMES));
	shell_print(sh, "frame.width    : %u", sys_read16(cfg->base + TVAI_STATS_WIDTH));
	shell_print(sh, "frame.height   : %u", sys_read16(cfg->base + TVAI_STATS_HEIGHT));
	uint32_t pixels = sys_read32(cfg->base + TVAI_STATS_NUM_PIXELS);
	shell_print(sh, "frame.pixels   : %u", pixels & 0xFFFFFF);
	shell_print(sh, "frame.pxl_lock : %s", (pixels & BIT(24)) ? "LOCKED" : "UNLOCKED");
	shell_print(sh, "frame.chan0    : 0x%02x", sys_read32(cfg->base + TVAI_STATS_CHAN_AVG_0));
	shell_print(sh, "frame.chan1    : 0x%02x", sys_read32(cfg->base + TVAI_STATS_CHAN_AVG_1));
	shell_print(sh, "frame.chan2    : 0x%02x", sys_read32(cfg->base + TVAI_STATS_CHAN_AVG_2));
	shell_print(sh, "frame.chan3    : 0x%02x", sys_read32(cfg->base + TVAI_STATS_CHAN_AVG_3));
	shell_print(sh, "frame.dropped  : %u", sys_read32(cfg->base + TVAI_STATS_DROPPED_FRAMES));
	shell_print(sh, "--------------------------------");
	shell_print(sh, "ISP Errors:");
	shell_print(sh, "overflow.f2s   : 0x%02x", sys_read32(cfg->base + TVAI_STATS_OVERFLOW_F2S));
	shell_print(sh, "overflow.s2usb : 0x%02x", sys_read32(cfg->base + TVAI_STATS_OVERFLOW_S2USB));
	shell_print(sh, "--------------------------------");
	shell_print(sh, "MIPI Rx Errors:");
	shell_print(sh, "mipi.eccbyte   : 0x%02x", sys_read32(cfg->base + TVAI_STATS_ECC_BYTE_ERROR));
	shell_print(sh, "mipi.ecc1bit   : 0x%02x", sys_read32(cfg->base + TVAI_STATS_ECC_1BIT_ERROR));
	shell_print(sh, "mipi.ecc2bit   : 0x%02x", sys_read32(cfg->base + TVAI_STATS_ECC_2BIT_ERROR));
	shell_print(sh, "mipi.delay     : 0x%02x", sys_read32(cfg->base + TVAI_STATS_DELAY_ERROR));
	shell_print(sh, "mipi.underflow : 0x%02x", sys_read32(cfg->base + TVAI_STATS_UNDERFLOW_ERROR));
	shell_print(sh, "mipi.overflow  : 0x%02x", sys_read32(cfg->base + TVAI_STATS_OVERFLOW_ERROR));
	return 0;
}

static int cmd_tvai_stats_clear(const struct shell *sh, size_t argc, char **argv)
{
	const struct device *dev;
	const struct tvai_stats_config *cfg;

	__ASSERT_NO_MSG(argc == 2);

	dev = device_get_binding(argv[1]);
	if (dev == NULL || !device_is_video_and_ready(dev)) {
		shell_error(sh, "could not find a stats device ready with that name");
		return -ENODEV;
	}

	cfg = dev->config;

	/* Clear error registers by writing 1 to them */
	sys_write32(0xFF, cfg->base + TVAI_STATS_ECC_ERROR_CMD);
	sys_write32(0xFF, cfg->base + TVAI_STATS_OVERFLOW_CMD);

	shell_print(sh, "Stats error registers cleared");

	return 0;
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
	sub_tvai_stats,

	SHELL_CMD_ARG(show, &dsub_device_name, "Show a dump of the hardware registers",
		      cmd_tvai_stats_show, 2, 0),
	SHELL_CMD_ARG(clear, &dsub_device_name, "Clear the stats error registers",
		      cmd_tvai_stats_clear, 2, 0),

	SHELL_SUBCMD_SET_END);

SHELL_CMD_REGISTER(tvai_stats, &sub_tvai_stats, "tinyVision.ai tvai_stats and statistics", NULL);
