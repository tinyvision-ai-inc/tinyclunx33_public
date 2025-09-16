/*
 * Copyright (c) 2024-2025 tinyVision.ai Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define DT_DRV_COMPAT tinyvision_stacker

#include <zephyr/device.h>
#include <zephyr/drivers/i2c.h>
#include <zephyr/drivers/video.h>
#include <zephyr/drivers/video-controls.h>
#include <zephyr/kernel.h>
#include <zephyr/sys/byteorder.h>
#include <zephyr/shell/shell.h>
#include <zephyr/logging/log.h>

#include "video_ctrls.h"
#include "video_device.h"
#include "video_common.h"

LOG_MODULE_REGISTER(tvai_stacker, CONFIG_VIDEO_LOG_LEVEL);

struct tvai_stacker_config {
	const struct device *source0_dev;
	const struct device *source1_dev;
};

struct tvai_stacker_ctrls {
	struct video_ctrl start_delay_us;
};

struct tvai_stacker_data {
	struct video_format fmt;
	struct tvai_stacker_ctrls ctrls;;
	k_timeout_t start_delay;
};

/* Used to tune the video format caps from the source at runtime */
static struct video_format_cap fmts[10];

#define TVAI_STACKER_CID_START_DELAY_US (VIDEO_CID_PRIVATE_BASE + 0)

static int tvai_stacker_set_ctrl(const struct device *dev, unsigned int cid)
{
	struct tvai_stacker_data *drv_data = dev->data;
	struct tvai_stacker_ctrls *ctrls = &drv_data->ctrls;

	switch (cid) {
	case TVAI_STACKER_CID_START_DELAY_US:
		drv_data->start_delay = K_USEC(ctrls->start_delay_us.val);
		return 0;
	default:
		return -ENOTSUP;
	}
}

static int tvai_stacker_get_caps(const struct device *dev, struct video_caps *caps)
{
	const struct tvai_stacker_config *cfg = dev->config;
	const struct video_format_cap *fmts0;
	const struct video_format_cap *fmts1;
	struct video_caps caps0 = {.type = VIDEO_BUF_TYPE_OUTPUT};
	struct video_caps caps1 = {.type = VIDEO_BUF_TYPE_OUTPUT};
	int ret;

	LOG_DBG("%s: %s", dev->name, __func__);

	ret = video_get_caps(cfg->source0_dev, &caps0);
	if (ret < 0) {
		return ret;
	}

	ret = video_get_caps(cfg->source1_dev, &caps1);
	if (ret < 0) {
		return ret;
	}

	fmts0 = caps0.format_caps;
	fmts1 = caps1.format_caps;

	/* Adjust the formats according to the conversion done in hardware */

	for (size_t i = 0; fmts0[i].pixelformat != 0 && fmts1[i].pixelformat != 0; i++) {
		if (i + 1 >= ARRAY_SIZE(fmts)) {
			LOG_WRN("not enough format capabilities");
			break;
		}

		if (memcmp(&fmts0[i], &fmts1[i], sizeof(fmts0[i])) != 0) {
			LOG_ERR("Stacking of image sensors with different formats not supported");
			return -ENOTSUP;
		}

		LOG_DBG("Adding format '%s' %ux%u to %ux%u to caps",
			VIDEO_FOURCC_TO_STR(fmts0[i].pixelformat),
			fmts0[i].width_min, fmts0[i].height_min,
			fmts0[i].width_max, fmts0[i].height_max);

		memcpy(&fmts[i], &fmts0[i].pixelformat, sizeof(fmts[i]));
		fmts[i].height_min *= 2;
		fmts[i].height_max *= 2;
	}

	caps->format_caps = fmts;

	return 0;
}

static int tvai_stacker_set_format(const struct device *dev, struct video_format *fmt)
{
	const struct tvai_stacker_config *cfg = dev->config;
	struct tvai_stacker_data *drv_data = dev->data;
	const struct device *source0_dev = cfg->source0_dev;
	const struct device *source1_dev = cfg->source1_dev;
	struct video_format source_fmt = *fmt;
	int ret;

	/* Apply the conversion done by hardware to the format */
	source_fmt.height /= 2;

	LOG_DBG("setting %s and %s to '%s' %ux%u",
		source0_dev->name, source1_dev->name, VIDEO_FOURCC_TO_STR(source_fmt.pixelformat),
		source_fmt.width, source_fmt.height);

	ret = video_set_format(source0_dev, &source_fmt);
	if (ret < 0) {
		LOG_ERR("failed to set %s format", source0_dev->name);
		return ret;
	}

	ret = video_set_format(source1_dev, &source_fmt);
	if (ret < 0) {
		LOG_ERR("failed to set %s format", source1_dev->name);
		return ret;
	}

	drv_data->fmt = *fmt;

	return 0;
}

static int tvai_stacker_get_format(const struct device *dev, struct video_format *fmt)
{
	struct tvai_stacker_data *drv_data = dev->data;

	*fmt = drv_data->fmt;

	return 0;
}

static int tvai_stacker_set_frmival(const struct device *dev, struct video_frmival *frmival)
{
	const struct tvai_stacker_config *cfg = dev->config;
	int ret;

	ret = video_set_frmival(cfg->source0_dev, frmival);
	if (ret < 0) {
		return ret;
	}

	ret = video_set_frmival(cfg->source1_dev, frmival);
	if (ret < 0) {
		return ret;
	}

	return 0;
}

static int tvai_stacker_get_frmival(const struct device *dev, struct video_frmival *frmival)
{
	const struct tvai_stacker_config *cfg = dev->config;

	return video_get_frmival(cfg->source0_dev, frmival);
}

static int tvai_stacker_enum_frmival(const struct device *dev, struct video_frmival_enum *fie)
{
	const struct tvai_stacker_config *cfg = dev->config;
	const struct video_format *prev_fmt = fie->format;
	struct video_format fmt = *fie->format;
	int ret;

	fmt.height /= 2;

	fie->format = &fmt;
	ret = video_enum_frmival(cfg->source0_dev, fie);
	fie->format = prev_fmt;

	return ret;
}

static int tvai_stacker_set_stream(const struct device *dev, bool on, enum video_buf_type type)
{
	const struct tvai_stacker_config *cfg = dev->config;
	struct tvai_stacker_data *drv_data = dev->data;
	int ret;

	if (on) {
		ret = video_stream_start(cfg->source0_dev, VIDEO_BUF_TYPE_OUTPUT);
		if (ret != 0) {
			LOG_ERR("Failed to start %s", cfg->source0_dev->name);
			return ret;
		}

		k_sleep(drv_data->start_delay);

		ret = video_stream_start(cfg->source1_dev, VIDEO_BUF_TYPE_OUTPUT);
		if (ret != 0) {
			LOG_ERR("Failed to start %s", cfg->source1_dev->name);
			return ret;
		}
	} else {
		ret = video_stream_stop(cfg->source0_dev, VIDEO_BUF_TYPE_OUTPUT);
		if (ret != 0) {
			LOG_ERR("Failed to stop %s", cfg->source0_dev->name);
			return ret;
		}

		ret = video_stream_stop(cfg->source1_dev, VIDEO_BUF_TYPE_OUTPUT);
		if (ret != 0) {
			LOG_ERR("Failed to stop %s", cfg->source1_dev->name);
			return ret;
		}
	}

	return 0;
}

static const DEVICE_API(video, tvai_stacker_driver_api) = {
	.set_format = tvai_stacker_set_format,
	.set_ctrl = tvai_stacker_set_ctrl,
	.get_format = tvai_stacker_get_format,
	.get_caps = tvai_stacker_get_caps,
	.set_frmival = tvai_stacker_set_frmival,
	.get_frmival = tvai_stacker_get_frmival,
	.enum_frmival = tvai_stacker_enum_frmival,
	.set_stream = tvai_stacker_set_stream,
};

static int tvai_stacker_init(const struct device *dev)
{
	struct tvai_stacker_data *drv_data = dev->data;
	struct tvai_stacker_ctrls *ctrls = &drv_data->ctrls;
	int ret;

	LOG_DBG("Initializing %s", dev->name);

	ret = video_init_ctrl(
		&ctrls->start_delay_us, dev, TVAI_STACKER_CID_START_DELAY_US,
		(struct video_ctrl_range){
			.min = 0,
			.max = 0xFFFFFF,
			.step = 1,
			.def = 0x70});
	if (ret < 0) {
		LOG_ERR("Failed to initialize start delay (custom control)");
		return ret;
	}

	return 0;
}

#define SOURCE_DEV(n, e) DEVICE_DT_GET(DT_NODE_REMOTE_DEVICE(DT_INST_ENDPOINT_BY_ID(n, 0, e)))

#define TVAI_STACKER_INIT(n)                                                                       \
	static struct tvai_stacker_data tvai_stacker_data_##n = {                                  \
		.start_delay = K_USEC(DT_INST_PROP(n, start_delay_us)),                            \
	};                                                                                         \
                                                                                                   \
	const static struct tvai_stacker_config tvai_stacker_cfg_##n = {                           \
		.source0_dev = SOURCE_DEV(n, 0),                                                   \
		.source1_dev = SOURCE_DEV(n, 1),                                                   \
	};                                                                                         \
                                                                                                   \
	DEVICE_DT_INST_DEFINE(n, &tvai_stacker_init, NULL, &tvai_stacker_data_##n,                 \
			      &tvai_stacker_cfg_##n, POST_KERNEL, CONFIG_VIDEO_INIT_PRIORITY,      \
			      &tvai_stacker_driver_api);                                           \
                                                                                                   \
	VIDEO_DEVICE_DEFINE(tvai_stacker##n##_src0, DEVICE_DT_INST_GET(n), SOURCE_DEV(n, 0));      \
	VIDEO_DEVICE_DEFINE(tvai_stacker##n##_src1, DEVICE_DT_INST_GET(n), SOURCE_DEV(n, 1));

DT_INST_FOREACH_STATUS_OKAY(TVAI_STACKER_INIT)
