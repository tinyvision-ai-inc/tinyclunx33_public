/*
 * Copyright (c) 2024 tinyVision.ai Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define DT_DRV_COMPAT tinyvision_testpattern

#include <zephyr/device.h>
#include <zephyr/drivers/i2c.h>
#include <zephyr/drivers/video.h>
#include <zephyr/drivers/video-controls.h>
#include <zephyr/kernel.h>
#include <zephyr/sys/byteorder.h>
#include <zephyr/logging/log.h>

#include "video_device.h"

LOG_MODULE_REGISTER(testpattern, CONFIG_VIDEO_LOG_LEVEL);

struct testpattern_data {
	struct video_format fmt;
};

#define TESTPATTERN_VIDEO_FORMAT_CAP(width, height)                                                \
	{                                                                                          \
		.pixelformat = VIDEO_PIX_FMT_YUYV, .width_min = (width), .width_max = (width),     \
		.height_min = (height), .height_max = (height)                                     \
	}

struct video_format_cap fmts[] = {
	TESTPATTERN_VIDEO_FORMAT_CAP(64, 64),
	TESTPATTERN_VIDEO_FORMAT_CAP(160, 120),   /* QQVGA */
	TESTPATTERN_VIDEO_FORMAT_CAP(320, 240),   /* QVGA */
	TESTPATTERN_VIDEO_FORMAT_CAP(640, 480),   /* VGA */
	TESTPATTERN_VIDEO_FORMAT_CAP(1280, 720),  /* HD */
	TESTPATTERN_VIDEO_FORMAT_CAP(1920, 1080), /* FHD */
	TESTPATTERN_VIDEO_FORMAT_CAP(3840, 2160), /* 4K */
	TESTPATTERN_VIDEO_FORMAT_CAP(7680, 4320), /* 8K */
	{0},
};

static int testpattern_set_fmt(const struct device *dev, enum video_endpoint_id ep,
			  struct video_format *fmt)
{
	struct testpattern_data *data = dev->data;
	int i;

	if (ep != VIDEO_EP_OUT && ep != VIDEO_EP_ALL) {
		return -EINVAL;
	}

	for (i = 0; i < ARRAY_SIZE(fmts); ++i) {
		if (fmt->pixelformat == fmts[i].pixelformat && fmt->width >= fmts[i].width_min &&
		    fmt->width <= fmts[i].width_max && fmt->height >= fmts[i].height_min &&
		    fmt->height <= fmts[i].height_max) {
			break;
		}
	}
	if (i == ARRAY_SIZE(fmts)) {
		LOG_ERR("Format %08x %ux%u not supported",
			fmt->pixelformat, fmt->width, fmt->height);
		return -EINVAL;
	}

	data->fmt = *fmt;
	return 0;
}

static int testpattern_get_fmt(const struct device *dev, enum video_endpoint_id ep,
			  struct video_format *fmt)
{
	struct testpattern_data *data = dev->data;

	*fmt = data->fmt;
	return 0;
}

static int testpattern_get_caps(const struct device *dev, enum video_endpoint_id ep,
			   struct video_caps *caps)
{
	caps->format_caps = fmts;
	return 0;
}

static int testpattern_get_frmival(const struct device *dev, enum video_endpoint_id ep,
			       struct video_frmival *frmival)
{
	if (ep != VIDEO_EP_OUT && ep != VIDEO_EP_ALL) {
		return -EINVAL;
	}

	/* TODO: compute the frame intrval after the current format */

	frmival->numerator = 1;
	frmival->denominator = 60;
	return 0;
}

static int testpattern_enum_frmival(const struct device *dev, enum video_endpoint_id ep,
				struct video_frmival_enum *fie)
{
	if (fie->index >= 1) {
		return 1;
	}

	/* TODO: compute the frame intrval after the format capabilities */

	fie->type = VIDEO_FRMIVAL_TYPE_DISCRETE;
	fie->discrete.numerator = 1;
	fie->discrete.denominator = 60;
	fie->index++;
	return 0;
}

static int testpattern_set_stream(const struct device *dev, bool on)
{
	return 0;
}

static const DEVICE_API(video, testpattern_driver_api) = {
	.set_format = testpattern_set_fmt,
	.get_format = testpattern_get_fmt,
	.get_caps = testpattern_get_caps,
	.get_frmival = testpattern_get_frmival,
	.enum_frmival = testpattern_enum_frmival,
	.set_stream = testpattern_set_stream,
};

static int testpattern_init(const struct device *dev)
{
	struct video_format fmt;

	fmt.pixelformat = VIDEO_PIX_FMT_YUYV;
	fmt.width = 1920;
	fmt.height = 1080;
	fmt.pitch = fmt.width * 2;
	return testpattern_set_fmt(dev, VIDEO_EP_OUT, &fmt);
}

#define TESTPATTERN_INIT(n)                                                                        \
	struct testpattern_data testpattern_data_##n;                                              \
	DEVICE_DT_INST_DEFINE(n, &testpattern_init, NULL, &testpattern_data_##n, NULL,             \
			      POST_KERNEL, CONFIG_VIDEO_INIT_PRIORITY, &testpattern_driver_api);   \
                                                                                                   \
	VIDEO_DEVICE_DEFINE(tvai_uvcmanager##n, DEVICE_DT_INST_GET(n), NULL);

DT_INST_FOREACH_STATUS_OKAY(TESTPATTERN_INIT)
