/*
 * Copyright (c) 2024-2025 tinyVision.ai Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define DT_DRV_COMPAT tinyvision_unpacker

#include <stdlib.h>

#include <zephyr/device.h>
#include <zephyr/kernel.h>
#include <zephyr/drivers/video.h>
#include <zephyr/sys/byteorder.h>
#include <zephyr/shell/shell.h>

#include "video_device.h"

LOG_MODULE_REGISTER(unpacker, CONFIG_VIDEO_LOG_LEVEL);

struct tvai_unpacker_config {
	const struct device *source_dev;
};

#define TVAI_UNPACKER_MAP_10P_12P_14P(fmt)                                                         \
	{                                                                                          \
		.src_fmt = VIDEO_PIX_FMT_##fmt##10P,                                               \
		.dst_fmt = VIDEO_PIX_FMT_##fmt##16,                                                \
	},                                                                                         \
	{                                                                                          \
		.src_fmt = VIDEO_PIX_FMT_##fmt##12P,                                               \
		.dst_fmt = VIDEO_PIX_FMT_##fmt##16,                                                \
	},                                                                                         \
	{                                                                                          \
		.src_fmt = VIDEO_PIX_FMT_##fmt##14P,                                               \
		.dst_fmt = VIDEO_PIX_FMT_##fmt##16,                                                \
	}

const struct {
	uint32_t src_fmt;
	uint32_t dst_fmt;
} tvai_unpacker_map[] = {
	TVAI_UNPACKER_MAP_10P_12P_14P(SRGGB),
	TVAI_UNPACKER_MAP_10P_12P_14P(SBGGR),
	TVAI_UNPACKER_MAP_10P_12P_14P(SGBRG),
	TVAI_UNPACKER_MAP_10P_12P_14P(SGRBG),
	TVAI_UNPACKER_MAP_10P_12P_14P(Y),
};

static struct video_format_cap tvai_unpacker_fmts[10];

static uint32_t tvai_unpacker_get_dst_pixfmt(uint32_t src_fmt)
{
	for (size_t i = 0; i < ARRAY_SIZE(tvai_unpacker_map); i++) {
		if (src_fmt == tvai_unpacker_map[i].src_fmt) {
			return tvai_unpacker_map[i].dst_fmt;
		}
	}

	LOG_ERR("Source pixel format %s is not supported", VIDEO_FOURCC_TO_STR(src_fmt));

	return 0x00;
}

static uint32_t tvai_unpacker_get_src_pixfmt(uint32_t dst_fmt)
{
	for (size_t i = 0; i < ARRAY_SIZE(tvai_unpacker_map); i++) {
		if (dst_fmt == tvai_unpacker_map[i].dst_fmt) {
			return tvai_unpacker_map[i].src_fmt;
		}
	}

	LOG_ERR("Destination pixel format %s is not supported", VIDEO_FOURCC_TO_STR(dst_fmt));

	return 0x00;
}

static int tvai_unpacker_set_format(const struct device *dev, struct video_format *fmt)
{
	const struct tvai_unpacker_config *cfg = dev->config;
	struct video_format source_fmt = *fmt;
	int ret;

	source_fmt.pixelformat = tvai_unpacker_get_src_pixfmt(fmt->pixelformat);
	if (source_fmt.pixelformat == 0) {
		return -ENOTSUP;
	}

	ret = video_set_format(cfg->source_dev, &source_fmt);
	fmt->pitch = fmt->width * video_bits_per_pixel(fmt->pixelformat) / BITS_PER_BYTE;
	return ret;
}

static int tvai_unpacker_get_format(const struct device *dev, struct video_format *fmt)
{
	const struct tvai_unpacker_config *cfg = dev->config;
	int ret;

	ret = video_get_format(cfg->source_dev, fmt);
	if (ret < 0) {
		return ret;
	}

	fmt->pixelformat = tvai_unpacker_get_dst_pixfmt(fmt->pixelformat);
	if (fmt->pixelformat == 0) {
		return -EINVAL;
	}

	return 0;
}

static int tvai_unpacker_get_caps(const struct device *dev, struct video_caps *caps)
{
	const struct tvai_unpacker_config *cfg = dev->config;
	int ret;

	ret = video_get_caps(cfg->source_dev, caps);
	if (ret < 0) {
		return ret;
	}

	for (size_t i = 0, o = 0; caps->format_caps[i].pixelformat != 0; i++) {
		if (o + 1 >= ARRAY_SIZE(tvai_unpacker_fmts)) {
			LOG_WRN("Too many source formats, some will be missing from the list");
			break;
		}

		tvai_unpacker_fmts[o] = caps->format_caps[i];
		tvai_unpacker_fmts[o].pixelformat =
			tvai_unpacker_get_dst_pixfmt(caps->format_caps[i].pixelformat);
		if (tvai_unpacker_fmts[i].pixelformat == 0) {
			LOG_WRN("Invalid source pixel format, skipping");
		} else {
			o++;
		}
	}

	caps->format_caps = tvai_unpacker_fmts;

	return 0;
}

static int tvai_unpacker_set_frmival(const struct device *dev, struct video_frmival *frmival)
{
	const struct tvai_unpacker_config *cfg = dev->config;

	return video_set_frmival(cfg->source_dev, frmival);
}

static int tvai_unpacker_get_frmival(const struct device *dev, struct video_frmival *frmival)
{
	const struct tvai_unpacker_config *cfg = dev->config;

	return video_get_frmival(cfg->source_dev, frmival);
}

static int tvai_unpacker_enum_frmival(const struct device *dev, struct video_frmival_enum *fie)
{
	const struct tvai_unpacker_config *cfg = dev->config;

	return video_enum_frmival(cfg->source_dev, fie);
}

static int tvai_unpacker_set_stream(const struct device *dev, bool on, enum video_buf_type type)
{
	const struct tvai_unpacker_config *cfg = dev->config;

	return on ? video_stream_start(cfg->source_dev, VIDEO_BUF_TYPE_OUTPUT)
		  : video_stream_stop(cfg->source_dev, VIDEO_BUF_TYPE_OUTPUT);
}

static const DEVICE_API(video, tvai_unpacker_driver_api) = {
	.set_format = tvai_unpacker_set_format,
	.get_format = tvai_unpacker_get_format,
	.get_caps = tvai_unpacker_get_caps,
	.set_frmival = tvai_unpacker_set_frmival,
	.get_frmival = tvai_unpacker_get_frmival,
	.enum_frmival = tvai_unpacker_enum_frmival,
	.set_stream = tvai_unpacker_set_stream,
};

#define SOURCE_DEV(n) DEVICE_DT_GET(DT_NODE_REMOTE_DEVICE(DT_INST_ENDPOINT_BY_ID(n, 0, 0)))

#define TVAI_UNPACKER_DEVICE_DEFINE(n)                                                             \
	const struct tvai_unpacker_config tvai_unpacker_cfg_##n = {                                \
		.source_dev = SOURCE_DEV(n),                                                       \
	};                                                                                         \
                                                                                                   \
	DEVICE_DT_INST_DEFINE(n, NULL, NULL, NULL, &tvai_unpacker_cfg_##n,                         \
			      POST_KERNEL, CONFIG_VIDEO_INIT_PRIORITY, &tvai_unpacker_driver_api); \
                                                                                                   \
	VIDEO_DEVICE_DEFINE(lcss_unpacker##n, DEVICE_DT_INST_GET(n), SOURCE_DEV(n));

DT_INST_FOREACH_STATUS_OKAY(TVAI_UNPACKER_DEVICE_DEFINE)
