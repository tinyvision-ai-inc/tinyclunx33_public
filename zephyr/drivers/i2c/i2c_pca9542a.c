/*
 * Copyright (c) 2020 Innoseis BV
 * Copyright (c) 2024 tinyVision.ai Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define DT_DRV_COMPAT nxp_pca9542a

#include <zephyr/kernel.h>
#include <zephyr/device.h>
#include <zephyr/devicetree.h>
#include <zephyr/drivers/i2c.h>
#include <zephyr/logging/log.h>
#include <stdint.h>
#include <stdio.h>

LOG_MODULE_REGISTER(pca9542a, CONFIG_I2C_LOG_LEVEL);

#define PCA9542A_NUM_CHANNELS 2

struct pca9542a_root_config {
	struct i2c_dt_spec i2c;
};

struct pca9542a_root_data {
	struct k_mutex lock;
	uint8_t chan_selected;
};

struct pca9542a_channel_config {
	const struct device *root_dev;
	uint8_t chan_num;
};

static int pca9542a_configure(const struct device *dev, uint32_t dev_config)
{
	const struct pca9542a_channel_config *chan_cfg = dev->config;
	const struct pca9542a_root_config *cfg = chan_cfg->root_dev->config;

	return i2c_configure(cfg->i2c.bus, dev_config);
}

static int pca9542a_set_channel(const struct device *dev, uint8_t chan_num)
{
	struct pca9542a_root_data *data = dev->data;
	const struct pca9542a_root_config *cfg = dev->config;
	uint8_t reg;
	int ret = 0;

	if (data->chan_selected == chan_num) {
		/* No change needed */
		return 0;
	}

	LOG_DBG("Changing the channel from %d to %d", data->chan_selected, chan_num);

	/* As defined in the datasheet */
	reg = chan_num + 4;

	ret = i2c_write_dt(&cfg->i2c, &reg, sizeof(reg));
#ifndef CONFIG_I2C_PCA9542A_IGNORE_FAILURE
	if (ret < 0) {
		LOG_ERR("Failed to set channel to %u", chan_num);
		return ret;
	}
#endif

	data->chan_selected = chan_num;

	return 0;
}

static int pca9542a_transfer(const struct device *dev, struct i2c_msg *msgs, uint8_t num_msgs,
			     uint16_t addr)
{
	const struct pca9542a_channel_config *chan_cfg = dev->config;
	struct pca9542a_root_data *root_data = chan_cfg->root_dev->data;
	const struct pca9542a_root_config *root_cfg = chan_cfg->root_dev->config;
	int ret;

	ret = k_mutex_lock(&root_data->lock, K_MSEC(5000));
	if (ret != 0) {
		return ret;
	}

	ret = pca9542a_set_channel(chan_cfg->root_dev, chan_cfg->chan_num);
	if (ret < 0) {
		goto end;
	}

	ret = i2c_transfer(root_cfg->i2c.bus, msgs, num_msgs, addr);
end:
	k_mutex_unlock(&root_data->lock);
	return ret;
}

static int pca9542a_root_init(const struct device *dev)
{
	const struct pca9542a_root_config *cfg = dev->config;

	if (!device_is_ready(cfg->i2c.bus)) {
		LOG_ERR("I2C bus %s not ready", cfg->i2c.bus->name);
		return -ENODEV;
	}

	return 0;
}

static int pca9542a_channel_init(const struct device *dev)
{
	const struct pca9542a_channel_config *chan_cfg = dev->config;

	if (!device_is_ready(chan_cfg->root_dev)) {
		LOG_ERR("I2C mux root %s not ready", chan_cfg->root_dev->name);
		return -ENODEV;
	}

	if (chan_cfg->chan_num >= PCA9542A_NUM_CHANNELS) {
		LOG_ERR("Wrong devicetree address provided for %s", dev->name);
		return -EINVAL;
	}

	return 0;
}

static const struct i2c_driver_api pca9542a_api_funcs = {
	.configure = pca9542a_configure,
	.transfer = pca9542a_transfer,
};

BUILD_ASSERT(CONFIG_I2C_PCA9542A_CHANNEL_INIT_PRIO > CONFIG_I2C_PCA9542A_ROOT_INIT_PRIO,
	     "I2C multiplexer channels must be initialized after their root");

#define PCA9542A_CHAN_DEFINE(node_id)                                                              \
	static const struct pca9542a_channel_config pca9542a_down_config_##node_id = {             \
		.chan_num = DT_REG_ADDR(node_id),                                                  \
		.root_dev = DEVICE_DT_GET(DT_PARENT(node_id)),                                     \
	};                                                                                         \
	DEVICE_DT_DEFINE(node_id, pca9542a_channel_init, NULL, NULL,                               \
			 &pca9542a_down_config_##node_id, POST_KERNEL,                             \
			 CONFIG_I2C_PCA9542A_CHANNEL_INIT_PRIO, &pca9542a_api_funcs);

#define PCA9542A_ROOT_INIT(n)                                                                      \
	static const struct pca9542a_root_config pca9542a_cfg_##n = {                              \
		.i2c = I2C_DT_SPEC_INST_GET(n),                                                    \
	};                                                                                         \
	static struct pca9542a_root_data pca9542a_data_##n = {                                     \
		.lock = Z_MUTEX_INITIALIZER(pca9542a_data_##n.lock),                               \
		.chan_selected = 0xff,                                                             \
	};                                                                                         \
	I2C_DEVICE_DT_DEFINE(DT_DRV_INST(n), pca9542a_root_init, NULL,                             \
			     &pca9542a_data_##n, &pca9542a_cfg_##n, POST_KERNEL,                   \
			     CONFIG_I2C_PCA9542A_ROOT_INIT_PRIO, NULL);                            \
	DT_FOREACH_CHILD(DT_DRV_INST(n), PCA9542A_CHAN_DEFINE);

DT_INST_FOREACH_STATUS_OKAY(PCA9542A_ROOT_INIT)
