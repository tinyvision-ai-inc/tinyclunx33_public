/*
 * Copyright (c) 2024-2025 tinyVision.ai Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define DT_DRV_COMPAT tinyvision_debayer

#include <zephyr/device.h>
#include <zephyr/drivers/i2c.h>
#include <zephyr/drivers/video.h>
#include <zephyr/drivers/video-controls.h>
#include <zephyr/kernel.h>
#include <zephyr/sys/byteorder.h>
#include <zephyr/shell/shell.h>
#include <zephyr/logging/log.h>

#include "video_device.h"

LOG_MODULE_REGISTER(tvai_debayer, CONFIG_VIDEO_LOG_LEVEL);

#define TVAI_DEBAYER_PIX_FMT VIDEO_PIX_FMT_SBGGR10P

#define TVAI_DEBAYER_MAX_SOURCE_WIDTH 1920
#define TVAI_DEBAYER_MAX_SOURCE_HEIGHT 1080
#define TVAI_DEBAYER_MIN_SOURCE_WIDTH 640
#define TVAI_DEBAYER_MIN_SOURCE_HEIGHT 480

struct tvai_debayer_config {
	const struct device *source_dev;
};

/* Used to tune the video format caps from the source at runtime */
static struct video_format_cap fmts[10];

static int tvai_debayer_get_caps(const struct device *dev, struct video_caps *caps)
{
	const struct tvai_debayer_config *cfg = dev->config;
	int ind = 0;
	int ret;

	ret = video_get_caps(cfg->source_dev, caps);
	if (ret < 0) {
		return ret;
	}

	/* Adjust the formats according to the conversion done in hardware */
	for (int i = 0; caps->format_caps[i].pixelformat != 0; i++) {
		const struct video_format_cap *source_fmt = &caps->format_caps[i];
		struct video_format_cap *self_fmt = &fmts[ind];

		if (ind + 1 >= ARRAY_SIZE(fmts)) {
			LOG_WRN("not enough format capabilities");
			break;
		}

		/* Filter away the widht and heights with no overlapping value */
		if (source_fmt->height_max < TVAI_DEBAYER_MIN_SOURCE_HEIGHT ||
		    source_fmt->height_min > TVAI_DEBAYER_MAX_SOURCE_HEIGHT ||
		    source_fmt->width_max < TVAI_DEBAYER_MIN_SOURCE_WIDTH ||
		    source_fmt->width_min > TVAI_DEBAYER_MAX_SOURCE_WIDTH) {
			LOG_INF("Skipping format [%ux%u, %ux%u] outside of range [%ux%u, %ux%u]",
				source_fmt->width_max, source_fmt->height_max,
				source_fmt->width_min,  source_fmt->height_min,
				TVAI_DEBAYER_MIN_SOURCE_WIDTH, TVAI_DEBAYER_MIN_SOURCE_HEIGHT,
				TVAI_DEBAYER_MAX_SOURCE_WIDTH, TVAI_DEBAYER_MAX_SOURCE_HEIGHT);
			continue;
		}

		/* Filter away the incompatible pixel formats */
		if (source_fmt->pixelformat != VIDEO_PIX_FMT_SBGGR10P &&
		    source_fmt->pixelformat != VIDEO_PIX_FMT_SGRBG10P &&
		    source_fmt->pixelformat != VIDEO_PIX_FMT_SRGGB10P &&
		    source_fmt->pixelformat != VIDEO_PIX_FMT_SGBRG10P) {
			LOG_INF("Skipping format '%s': only 10-bit packed bayer supported",
				VIDEO_FOURCC_TO_STR(source_fmt->pixelformat));
			continue;
		}

		self_fmt->pixelformat = VIDEO_PIX_FMT_YUYV;

		/* Limit the source format and remove 2 pixels from it */
		self_fmt->width_min = CLAMP(source_fmt->width_min, TVAI_DEBAYER_MIN_SOURCE_WIDTH,
					    TVAI_DEBAYER_MAX_SOURCE_WIDTH) - 2;
		self_fmt->width_max = CLAMP(source_fmt->width_max, TVAI_DEBAYER_MIN_SOURCE_WIDTH,
					    TVAI_DEBAYER_MAX_SOURCE_WIDTH) - 2;
		self_fmt->height_min = CLAMP(source_fmt->height_min, TVAI_DEBAYER_MIN_SOURCE_HEIGHT,
					     TVAI_DEBAYER_MAX_SOURCE_HEIGHT) - 2;
		self_fmt->height_max = CLAMP(source_fmt->height_max, TVAI_DEBAYER_MIN_SOURCE_HEIGHT,
					     TVAI_DEBAYER_MAX_SOURCE_HEIGHT) - 2;

		ind++;
	}

	caps->format_caps = fmts;
	return 0;
}

static int tvai_debayer_set_format(const struct device *dev, struct video_format *fmt)
{
	const struct tvai_debayer_config *cfg = dev->config;
	const struct device *source_dev = cfg->source_dev;
	struct video_format source_fmt = *fmt;
	int ret;

	if (fmt->pixelformat != VIDEO_PIX_FMT_YUYV) {
		LOG_ERR("Only YUYV is supported as output format");
		return -ENOTSUP;
	}

	/* Apply the conversion done by hardware to the format */
	source_fmt.width += 2;
	source_fmt.height += 2;
	source_fmt.pixelformat = TVAI_DEBAYER_PIX_FMT;

	LOG_DBG("setting %s to %ux%u", source_dev->name, source_fmt.width, source_fmt.height);

	ret = video_set_format(source_dev, &source_fmt);
	if (ret < 0) {
		LOG_ERR("failed to set %s format", source_dev->name);
		return ret;
	}

	return 0;
}

static int tvai_debayer_get_format(const struct device *dev, struct video_format *fmt)
{
	const struct tvai_debayer_config *cfg = dev->config;
	int ret;

	ret = video_get_format(cfg->source_dev, fmt);
	if (ret < 0) {
		LOG_ERR("failed to get %s format", cfg->source_dev->name);
		return ret;
	}

	LOG_DBG("%s format is %ux%u, stripping 2 pixels vertically and horizontally",
		cfg->source_dev->name, fmt->width, fmt->height);

	/* Apply the conversion done by hardware to the format */
	fmt->width -= 2;
	fmt->height -= 2;
	fmt->pixelformat = VIDEO_PIX_FMT_YUYV;

	return 0;
}

static int tvai_debayer_set_frmival(const struct device *dev, struct video_frmival *frmival)
{
	const struct tvai_debayer_config *cfg = dev->config;

	return video_set_frmival(cfg->source_dev, frmival);
}

static int tvai_debayer_get_frmival(const struct device *dev, struct video_frmival *frmival)
{
	const struct tvai_debayer_config *cfg = dev->config;

	return video_get_frmival(cfg->source_dev, frmival);
}

static int tvai_debayer_enum_frmival(const struct device *dev, struct video_frmival_enum *fie)
{
	const struct tvai_debayer_config *cfg = dev->config;
	const struct video_format *prev_fmt = fie->format;
	struct video_format fmt = *fie->format;
	int ret;

	if (fie->format->pixelformat != VIDEO_PIX_FMT_YUYV) {
		LOG_ERR("Only YUYV is supported");
		return -ENOTSUP;
	}

	fmt.width += 2;
	fmt.height += 2;
	fmt.pixelformat = TVAI_DEBAYER_PIX_FMT,

	fie->format = &fmt;
	ret = video_enum_frmival(cfg->source_dev, fie);
	fie->format = prev_fmt;

	return ret;
}

static int tvai_debayer_set_stream(const struct device *dev, bool on, enum video_buf_type type)
{
	const struct tvai_debayer_config *cfg = dev->config;

	return on ? video_stream_start(cfg->source_dev, type)
		  : video_stream_stop(cfg->source_dev, type);
}

static const DEVICE_API(video, tvai_debayer_driver_api) = {
	.set_format = tvai_debayer_set_format,
	.get_format = tvai_debayer_get_format,
	.get_caps = tvai_debayer_get_caps,
	.set_frmival = tvai_debayer_set_frmival,
	.get_frmival = tvai_debayer_get_frmival,
	.enum_frmival = tvai_debayer_enum_frmival,
	.set_stream = tvai_debayer_set_stream,
};

#define SOURCE_DEV(n) DEVICE_DT_GET(DT_NODE_REMOTE_DEVICE(DT_INST_ENDPOINT_BY_ID(n, 0, 0)))

#define TVAI_DEBAYER_INIT(n)                                                                       \
	const static struct tvai_debayer_config tvai_debayer_cfg_##n = {                           \
		.source_dev = SOURCE_DEV(n),                                                       \
	};                                                                                         \
                                                                                                   \
	DEVICE_DT_INST_DEFINE(n, NULL, NULL, NULL, &tvai_debayer_cfg_##n, POST_KERNEL,             \
			      CONFIG_VIDEO_INIT_PRIORITY, &tvai_debayer_driver_api);               \
                                                                                                   \
	VIDEO_DEVICE_DEFINE(tvai_debayer##n, DEVICE_DT_INST_GET(n), SOURCE_DEV(n));

DT_INST_FOREACH_STATUS_OKAY(TVAI_DEBAYER_INIT)
