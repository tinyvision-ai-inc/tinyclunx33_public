/*
 * Copyright (c) 2025 tinyVision.ai Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define DT_DRV_COMPAT tinyvision_uvcmanager

#include <stdint.h>
#include <zephyr/drivers/video.h>
#include <zephyr/drivers/video-controls.h>
#include <zephyr/drivers/i2c.h>
#include <zephyr/kernel.h>
#include <zephyr/sys/util.h>
#include <zephyr/shell/shell.h>
#include <zephyr/logging/log.h>

#include "video_ctrls.h"
#include "video_device.h"
#include "udc_dwc3.h"
#include "udc_common.h"
#include "tvai_uvcmanager.h"

LOG_MODULE_REGISTER(uvcmanager, CONFIG_VIDEO_LOG_LEVEL);

struct uvcmanager_config {
	const struct device *source_dev;
	const struct device *dwc3_dev;
	uintptr_t base;
	uintptr_t fifo;
	uint8_t usb_endpoint;
};

struct uvcmanager_ctrls {
	struct video_ctrl test_pattern;
};

struct uvcmanager_data {
	const struct device *dev;
	struct video_format fmt;
	size_t id;
	struct k_work work;
	struct k_fifo fifo_in;
	struct k_fifo fifo_out;
	struct uvcmanager_ctrls ctrls;
};

/*
 * Direct connection APIs with DWC3 register information.
 */

uint32_t dwc3_get_trb_addr(const struct device *dev, uint8_t ep_addr)
{
	struct dwc3_ep_data *ep_data = (void *)udc_get_ep_cfg(dev, ep_addr);

	return (uint32_t)ep_data->trb_buf;
}

uint32_t dwc3_get_depcmd(const struct device *dev, uint8_t ep_addr)
{
	const struct dwc3_config *cfg = dev->config;

	return cfg->base + DWC3_DEPCMD(EP_PHYS_NUMBER(ep_addr));
}

uint32_t dwc3_get_depupdxfer(const struct device *dev, uint8_t ep_addr)
{
	struct dwc3_ep_data *ep_data = (void *)udc_get_ep_cfg(dev, ep_addr);

	return DWC3_DEPCMD_DEPUPDXFER |
		FIELD_PREP(DWC3_DEPCMD_XFERRSCIDX_MASK, ep_data->xferrscidx);
}

static int uvcmanager_set_stream(const struct device *dev, bool on, enum video_buf_type type)
{
	const struct uvcmanager_config *cfg = dev->config;
	uint32_t trb_addr = dwc3_get_trb_addr(cfg->dwc3_dev, cfg->usb_endpoint);
	uint32_t depupdxfer = dwc3_get_depupdxfer(cfg->dwc3_dev, cfg->usb_endpoint);
	uint32_t depcmd = dwc3_get_depcmd(cfg->dwc3_dev, cfg->usb_endpoint);
	int ret;

	if (on) {
		LOG_DBG("Starting %s, then %s", cfg->source_dev->name, dev->name);
		LOG_DBG("trb addr 0x%08x, depupdxfer 0x%02x, depcmd 0x%08x",
			trb_addr, depupdxfer, depcmd);

		ret = video_stream_start(cfg->source_dev, VIDEO_BUF_TYPE_OUTPUT);
		if (ret < 0) {
			LOG_ERR("%s: failed to start %s", dev->name, cfg->source_dev->name);
			return ret;
		}

		uvcmanager_lib_start(cfg->base, trb_addr, depupdxfer, depcmd);
	} else {
		LOG_DBG("Stopping %s, then %s", dev->name, cfg->source_dev->name);

		uvcmanager_lib_stop(cfg->base);

		ret = video_stream_stop(cfg->source_dev, VIDEO_BUF_TYPE_OUTPUT);
		if (ret < 0) {
			LOG_ERR("%s: failed to stop %s", dev->name, cfg->source_dev->name);
			return ret;
		}
	}

	return 0;
}

static int uvcmanager_get_caps(const struct device *dev, struct video_caps *caps)
{
	const struct uvcmanager_config *cfg = dev->config;

	return video_get_caps(cfg->source_dev, caps);
}

static int uvcmanager_set_format(const struct device *dev, struct video_format *fmt)
{
	const struct uvcmanager_config *cfg = dev->config;
	struct uvcmanager_data *drv_data = dev->data;
	const struct device *source_dev = cfg->source_dev;
	struct video_format source_fmt = *fmt;
	int ret;

	LOG_INF("setting %s to %ux%u", source_dev->name, source_fmt.width, source_fmt.height);

	/* This call will update fmt->pitch */
	ret = video_set_format(source_dev, &source_fmt);
	if (ret < 0) {
		LOG_ERR("failed to set %s format", source_dev->name);
		return ret;
	}

	/* Now, the pitch is set correctly, we use it to configure the frame size */
	uvcmanager_lib_set_format(cfg->base, fmt->pitch, fmt->height);

	drv_data->fmt = *fmt;

	return 0;
}

static int uvcmanager_get_format(const struct device *dev, struct video_format *fmt)
{
	const struct uvcmanager_config *cfg = dev->config;

	return video_get_format(cfg->source_dev, fmt);
}

static int uvcmanager_set_ctrl(const struct device *dev, unsigned int cid)
{
	const struct uvcmanager_config *cfg = dev->config;
	struct uvcmanager_data *data = dev->data;
	struct uvcmanager_ctrls *ctrls = &data->ctrls;
	int ret;

	if (cid == VIDEO_CID_TEST_PATTERN) {
		if (ctrls->test_pattern.val == 0) {
			LOG_DBG("Disabling the test pattern");
			uvcmanager_lib_set_test_pattern(cfg->base, 0, 0, 0);
		} else {
			struct video_format fmt;

			ret = uvcmanager_get_format(dev, &fmt);
			if (ret < 0) {
				return ret;
			}

			LOG_DBG("Setting test pattern to %ux%u with value %u",
				fmt.width, fmt.height, ctrls->test_pattern.val);

			uvcmanager_lib_set_test_pattern(cfg->base, fmt.width, fmt.height,
							ctrls->test_pattern.val);
		}
		return 0;
	}

	return -ENOTSUP;
}

static int uvcmanager_set_frmival(const struct device *dev, struct video_frmival *frmival)
{
	const struct uvcmanager_config *cfg = dev->config;

	return video_set_frmival(cfg->source_dev, frmival);
}

static int uvcmanager_get_frmival(const struct device *dev, struct video_frmival *frmival)
{
	const struct uvcmanager_config *cfg = dev->config;

	return video_get_frmival(cfg->source_dev, frmival);
}

static int uvcmanager_enum_frmival(const struct device *dev, struct video_frmival_enum *fie)
{
	const struct uvcmanager_config *cfg = dev->config;

	return video_enum_frmival(cfg->source_dev, fie);
}

static void uvcmanager_worker(struct k_work *work)
{
	struct uvcmanager_data *data = CONTAINER_OF(work, struct uvcmanager_data, work);
	const struct device *dev = data->dev;
	const struct uvcmanager_config *cfg = dev->config;
	struct video_buffer *vbuf;

	while ((vbuf = k_fifo_get(&data->fifo_in, K_NO_WAIT)) != NULL) {
		vbuf->bytesused = vbuf->size;
		vbuf->line_offset = 0;

		LOG_DBG("Inserting %u bytes into buffer %p", vbuf->size, vbuf->buffer);
		uvcmanager_lib_read(cfg->base, vbuf->buffer, vbuf->size);
		k_fifo_put(&data->fifo_out, vbuf);
	}
}

static const char *uvcmanager_menu_test_pattern[] = {
	"None",
	"Incrementing Number",
	NULL,
};

static int uvcmanager_init(const struct device *dev)
{
	const struct uvcmanager_config *cfg = dev->config;
	struct uvcmanager_data *drv_data = dev->data;
	struct uvcmanager_ctrls *ctrls = &drv_data->ctrls;

	k_fifo_init(&drv_data->fifo_in);
	k_fifo_init(&drv_data->fifo_out);
	k_work_init(&drv_data->work, &uvcmanager_worker);

	uvcmanager_lib_init(cfg->base, cfg->fifo);

	return video_init_menu_ctrl(&ctrls->test_pattern, dev, VIDEO_CID_TEST_PATTERN, 0,
				    uvcmanager_menu_test_pattern);
}

static const DEVICE_API(video, uvcmanager_driver_api) = {
	.set_format = uvcmanager_set_format,
	.get_format = uvcmanager_get_format,
	.get_caps = uvcmanager_get_caps,
	.set_frmival = uvcmanager_set_frmival,
	.get_frmival = uvcmanager_get_frmival,
	.enum_frmival = uvcmanager_enum_frmival,
	.set_stream = uvcmanager_set_stream,
	.set_ctrl = uvcmanager_set_ctrl,
};

#define SOURCE_DEV(n) DEVICE_DT_GET(DT_NODE_REMOTE_DEVICE(DT_INST_ENDPOINT_BY_ID(n, 0, 0)))

#define UVCMANAGER_DEVICE_DEFINE(n)                                                                \
	const struct uvcmanager_config uvcmanager_cfg_##n = {                                      \
		.source_dev = SOURCE_DEV(n),                                                       \
		.dwc3_dev = DEVICE_DT_GET(DT_INST_PHANDLE(n, usb_controller)),                     \
		.usb_endpoint = DT_INST_PROP(n, usb_endpoint),                                     \
		.base = DT_INST_REG_ADDR_BY_NAME(n, base),                                         \
		.fifo = DT_INST_REG_ADDR_BY_NAME(n, fifo),                                         \
	};                                                                                         \
                                                                                                   \
	struct uvcmanager_data uvcmanager_data_##n = {                                             \
		.dev = DEVICE_DT_INST_GET(n),                                                      \
	};                                                                                         \
                                                                                                   \
	DEVICE_DT_INST_DEFINE(n, uvcmanager_init, NULL, &uvcmanager_data_##n, &uvcmanager_cfg_##n, \
			      POST_KERNEL, CONFIG_VIDEO_INIT_PRIORITY, &uvcmanager_driver_api);    \
                                                                                                   \
	VIDEO_DEVICE_DEFINE(tvai_uvcmanager##n, DEVICE_DT_INST_GET(n), SOURCE_DEV(n));

DT_INST_FOREACH_STATUS_OKAY(UVCMANAGER_DEVICE_DEFINE)

#ifdef CONFIG_SHELL

int cmd_tvai_uvcmanager_show(const struct shell *sh, size_t argc, char **argv)
{
	const struct device *dev;
	const struct uvcmanager_config *cfg;

	dev = device_get_binding(argv[1]);
	if (dev == NULL) {
		shell_error(sh, "Device %s not found", argv[1]);
		return -ENODEV;
	}

	cfg = dev->config;
	uvcmanager_lib_cmd_show(cfg->base, sh);

	return 0;
}

static bool device_is_video_and_ready(const struct device *dev)
{
	return device_is_ready(dev) && DEVICE_API_IS(video, dev);
}

static void complete_video_device(size_t idx, struct shell_static_entry *entry)
{
	const struct device *dev = shell_device_filter(idx, device_is_video_and_ready);

	entry->syntax = (dev != NULL) ? dev->name : NULL;
	entry->handler = NULL;
	entry->help = NULL;
	entry->subcmd = NULL;
}
SHELL_DYNAMIC_CMD_CREATE(dsub_video_device, complete_video_device);

SHELL_STATIC_SUBCMD_SET_CREATE(sub_tvai_uvcmanager,
	SHELL_CMD_ARG(show, &dsub_video_device,
		     "Show statistics about the uvcmanager core\n" "Usage: show <device>",
		     cmd_tvai_uvcmanager_show, 2, 0),
	SHELL_SUBCMD_SET_END);
SHELL_CMD_REGISTER(tvai_uvcmanager, &sub_tvai_uvcmanager, "UVC Manager debug commands", NULL);

#endif /* CONFIG_SHELL */
