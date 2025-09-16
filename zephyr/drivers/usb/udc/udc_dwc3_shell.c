/*
 * SPDX-License-Identifier: MIT
 *
 * Copyright (c) 2023-2024 tinyVision.ai Inc.
 *
 * Shell commands that can be accessed through the UART shell to
 * query the internal state of the driver or hardware.
 */

#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>

#include <zephyr/kernel.h>
#include <zephyr/drivers/usb/udc.h>
#include <zephyr/sys/util.h>
#include <zephyr/shell/shell.h>

#include "udc_common.h"
#include "udc_dwc3.h"

const struct dwc3_reg {
	uint32_t addr;
	char *name;
} dwc3_regs[] = {
	/* main registers */
	{.addr = DWC3_GCTL, .name = "GCTL"},
	{.addr = DWC3_DCTL, .name = "DCTL"},
	{.addr = DWC3_DCFG, .name = "DCFG"},
	{.addr = DWC3_DEVTEN, .name = "DEVTEN"},
	{.addr = DWC3_DALEPENA, .name = "DALEPENA"},
	{.addr = DWC3_GCOREID, .name = "GCOREID"},
	{.addr = DWC3_GSTS, .name = "GSTS"},
	{.addr = DWC3_DSTS, .name = "DSTS"},
	{.addr = DWC3_GEVNTADR_LO(0), .name = "GEVNTADR_LO(0)"},
	{.addr = DWC3_GEVNTADR_HI(0), .name = "GEVNTADR_HI(0)"},
	{.addr = DWC3_GEVNTSIZ(0), .name = "GEVNTSIZ(0)"},
	{.addr = DWC3_GEVNTCOUNT(0), .name = "GEVNTCOUNT(0)"},
	{.addr = DWC3_GUSB2PHYCFG, .name = "GUSB2PHYCFG"},
	{.addr = DWC3_GUSB3PIPECTL, .name = "GUSB3PIPECTL"},
	/* debug */
	{.addr = DWC3_GBUSERRADDR_LO, .name = "GBUSERRADDR_LO"},
	{.addr = DWC3_GBUSERRADDR_HI, .name = "GBUSERRADDR_HI"},
	{.addr = DWC3_CTLDEBUG_LO, .name = "CTLDEBUG_LO"},
	{.addr = DWC3_CTLDEBUG_HI, .name = "CTLDEBUG_HI"},
	{.addr = DWC3_ANALYZERTRACE, .name = "ANALYZERTRACE"},
	{.addr = DWC3_GDBGFIFOSPACE, .name = "GDBGFIFOSPACE"},
	{.addr = DWC3_GDBGLTSSM, .name = "GDBGLTSSM"},
	{.addr = DWC3_GDBGLNMCC, .name = "GDBGLNMCC"},
	{.addr = DWC3_GDBGBMU, .name = "GDBGBMU"},
	{.addr = DWC3_GDBGLSPMUX_DEV, .name = "GDBGLSPMUX_DEV"},
	{.addr = DWC3_GDBGLSPMUX_HST, .name = "GDBGLSPMUX_HST"},
	{.addr = DWC3_GDBGLSP, .name = "GDBGLSP"},
	{.addr = DWC3_GDBGEPINFO0, .name = "GDBGEPINFO0"},
	{.addr = DWC3_GDBGEPINFO1, .name = "GDBGEPINFO1"},
	{.addr = DWC3_BU3RHBDBG0, .name = "BU3RHBDBG0"},
	/* undocumented registers from vendor datasheet */
	{.addr = DWC3_U2PHYCTRL0, .name = "U2PHYCTRL0"},
	{.addr = DWC3_U2PHYCTRL1, .name = "U2PHYCTRL1"},
	{.addr = DWC3_U2PHYCTRL2, .name = "U2PHYCTRL2"},
	{.addr = DWC3_U3PHYCTRL0, .name = "U3PHYCTRL0"},
	{.addr = DWC3_U3PHYCTRL1, .name = "U3PHYCTRL1"},
	{.addr = DWC3_U3PHYCTRL2, .name = "U3PHYCTRL2"},
	{.addr = DWC3_U3PHYCTRL3, .name = "U3PHYCTRL3"},
	{.addr = DWC3_U3PHYCTRL4, .name = "U3PHYCTRL4"},
	{.addr = DWC3_U3PHYCTRL5, .name = "U3PHYCTRL5"},
	/* physical endpoint numbers */
	{.addr = DWC3_DEPCMDPAR2(0), .name = "DEPCMDPAR2(0)"},
	{.addr = DWC3_DEPCMDPAR1(0), .name = "DEPCMDPAR1(0)"},
	{.addr = DWC3_DEPCMDPAR0(0), .name = "DEPCMDPAR0(0)"},
	{.addr = DWC3_DEPCMD(0), .name = "DEPCMD(0)"},
	{.addr = DWC3_DEPCMDPAR2(1), .name = "DEPCMDPAR2(1)"},
	{.addr = DWC3_DEPCMDPAR1(1), .name = "DEPCMDPAR1(1)"},
	{.addr = DWC3_DEPCMDPAR0(1), .name = "DEPCMDPAR0(1)"},
	{.addr = DWC3_DEPCMD(1), .name = "DEPCMD(1)"},
	{.addr = DWC3_DEPCMDPAR2(2), .name = "DEPCMDPAR2(2)"},
	{.addr = DWC3_DEPCMDPAR1(2), .name = "DEPCMDPAR1(2)"},
	{.addr = DWC3_DEPCMDPAR0(2), .name = "DEPCMDPAR0(2)"},
	{.addr = DWC3_DEPCMD(2), .name = "DEPCMD(2)"},
	{.addr = DWC3_DEPCMDPAR2(3), .name = "DEPCMDPAR2(3)"},
	{.addr = DWC3_DEPCMDPAR1(3), .name = "DEPCMDPAR1(3)"},
	{.addr = DWC3_DEPCMDPAR0(3), .name = "DEPCMDPAR0(3)"},
	{.addr = DWC3_DEPCMD(3), .name = "DEPCMD(3)"},
	{.addr = DWC3_DEPCMDPAR2(4), .name = "DEPCMDPAR2(4)"},
	{.addr = DWC3_DEPCMDPAR1(4), .name = "DEPCMDPAR1(4)"},
	{.addr = DWC3_DEPCMDPAR0(4), .name = "DEPCMDPAR0(4)"},
	{.addr = DWC3_DEPCMD(4), .name = "DEPCMD(4)"},
	{.addr = DWC3_DEPCMDPAR2(5), .name = "DEPCMDPAR2(5)"},
	{.addr = DWC3_DEPCMDPAR1(5), .name = "DEPCMDPAR1(5)"},
	{.addr = DWC3_DEPCMDPAR0(5), .name = "DEPCMDPAR0(5)"},
	{.addr = DWC3_DEPCMD(5), .name = "DEPCMD(5)"},
	{.addr = DWC3_DEPCMDPAR2(6), .name = "DEPCMDPAR2(6)"},
	{.addr = DWC3_DEPCMDPAR1(6), .name = "DEPCMDPAR1(6)"},
	{.addr = DWC3_DEPCMDPAR0(6), .name = "DEPCMDPAR0(6)"},
	{.addr = DWC3_DEPCMD(6), .name = "DEPCMD(6)"},
	{.addr = DWC3_DEPCMDPAR2(7), .name = "DEPCMDPAR2(7)"},
	{.addr = DWC3_DEPCMDPAR1(7), .name = "DEPCMDPAR1(7)"},
	{.addr = DWC3_DEPCMDPAR0(7), .name = "DEPCMDPAR0(7)"},
	{.addr = DWC3_DEPCMD(7), .name = "DEPCMD(7)"},
	/* Hardware parameters */
	{.addr = DWC3_GHWPARAMS0, .name = "GHWPARAMS0"},
	{.addr = DWC3_GHWPARAMS1, .name = "GHWPARAMS1"},
	{.addr = DWC3_GHWPARAMS2, .name = "GHWPARAMS2"},
	{.addr = DWC3_GHWPARAMS3, .name = "GHWPARAMS3"},
	{.addr = DWC3_GHWPARAMS4, .name = "GHWPARAMS4"},
	{.addr = DWC3_GHWPARAMS5, .name = "GHWPARAMS5"},
	{.addr = DWC3_GHWPARAMS6, .name = "GHWPARAMS6"},
	{.addr = DWC3_GHWPARAMS7, .name = "GHWPARAMS7"},
	{.addr = DWC3_GHWPARAMS8, .name = "GHWPARAMS8"},
};

void dwc3_dump_registers(const struct device *dev, const struct shell *sh)
{
	const struct dwc3_config *cfg = dev->config;
	uint32_t reg;

	for (int i = 0; i < ARRAY_SIZE(dwc3_regs); i++) {
		const struct dwc3_reg *ureg = &dwc3_regs[i];

		reg = sys_read32(cfg->base + ureg->addr);
		shell_print(sh, "reg 0x%08x == 0x%08x %s", ureg->addr, reg, ureg->name);
	}
}

void dwc3_dump_bus_error(const struct device *dev, const struct shell *sh)
{
	const struct dwc3_config *cfg = dev->config;

	if (sys_read32(cfg->base + DWC3_GSTS) & DWC3_GSTS_BUSERRADDRVLD) {
		shell_print(sh, "BUS_ERROR addr=0x%08x%08x",
			     sys_read32(cfg->base + DWC3_GBUSERRADDR_HI),
			     sys_read32(cfg->base + DWC3_GBUSERRADDR_LO));
	} else {
		shell_print(sh, "no bus error");
	}
}

void dwc3_dump_link_state(const struct device *dev, const struct shell *sh)
{
	const struct dwc3_config *cfg = dev->config;
	uint32_t reg;

	reg = sys_read32(cfg->base + DWC3_DSTS);
	switch (reg & DWC3_DSTS_CONNECTSPD_MASK) {
	case DWC3_DSTS_CONNECTSPD_HS:
		shell_print(sh, "DWC3_DSTS_CONNECTSPD_HS");
		goto usb2;
	case DWC3_DSTS_CONNECTSPD_FS:
		shell_print(sh, "DWC3_DSTS_CONNECTSPD_FS");
		goto usb2;
	case DWC3_DSTS_CONNECTSPD_SS:
		shell_print(sh, "DWC3_DSTS_CONNECTSPD_SS");
		goto usb3;
	default:
		shell_print(sh, "unknown speed");
	}
	return;
usb2:
	switch (reg & DWC3_DSTS_USBLNKST_MASK) {
	case DWC3_DSTS_USBLNKST_USB2_ON_STATE:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB2_ON_STATE");
		break;
	case DWC3_DSTS_USBLNKST_USB2_SLEEP_STATE:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB2_SLEEP_STATE");
		break;
	case DWC3_DSTS_USBLNKST_USB2_SUSPEND_STATE:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB2_SUSPEND_STATE");
		break;
	case DWC3_DSTS_USBLNKST_USB2_DISCONNECTED:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB2_DISCONNECTED");
		break;
	case DWC3_DSTS_USBLNKST_USB2_EARLY_SUSPEND:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB2_EARLY_SUSPEND");
		break;
	case DWC3_DSTS_USBLNKST_USB2_RESET:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB2_RESET");
		break;
	case DWC3_DSTS_USBLNKST_USB2_RESUME:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB2_RESUME");
		break;
	}
	return;
usb3:
	switch (reg & DWC3_DSTS_USBLNKST_MASK) {
	case DWC3_DSTS_USBLNKST_USB3_U0:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB3_U0");
		break;
	case DWC3_DSTS_USBLNKST_USB3_U1:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB3_U1");
		break;
	case DWC3_DSTS_USBLNKST_USB3_U2:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB3_U2");
		break;
	case DWC3_DSTS_USBLNKST_USB3_U3:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB3_U3");
		break;
	case DWC3_DSTS_USBLNKST_USB3_SS_DIS:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB3_SS_DIS");
		break;
	case DWC3_DSTS_USBLNKST_USB3_RX_DET:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB3_RX_DET");
		break;
	case DWC3_DSTS_USBLNKST_USB3_SS_INACT:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB3_SS_INACT");
		break;
	case DWC3_DSTS_USBLNKST_USB3_POLL:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB3_POLL");
		break;
	case DWC3_DSTS_USBLNKST_USB3_RECOV:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB3_RECOV");
		break;
	case DWC3_DSTS_USBLNKST_USB3_HRESET:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB3_HRESET");
		break;
	case DWC3_DSTS_USBLNKST_USB3_CMPLY:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB3_CMPLY");
		break;
	case DWC3_DSTS_USBLNKST_USB3_LPBK:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB3_LPBK");
		break;
	case DWC3_DSTS_USBLNKST_USB3_RESET_RESUME:
		shell_print(sh, "DWC3_DSTS_USBLNKST_USB3_RESET_RESUME");
		break;
	}
}

void dwc3_dump_events(const struct device *dev, const struct shell *sh)
{
	const struct dwc3_config *cfg = dev->config;
	struct dwc3_data *priv = udc_get_private(dev);

	for (int i = 0; i < CONFIG_UDC_DWC3_EVENTS_NUM; i++) {
		uint32_t evt = cfg->evt_buf[i];
		char *s = (i == priv->evt_next) ? " <-" : "";

		shell_print(sh, "evt 0x%02x: 0x%08x%s", i, evt, s);
	}
}

void dwc3_dump_trb(const struct device *dev, struct dwc3_ep_data *ep_data,
		     const struct shell *sh)
{
	for (int i = 0; i < CONFIG_UDC_DWC3_TRB_NUM; i++) {
		struct dwc3_trb trb = ep_data->trb_buf[i];
		bool hwo = !!(trb.ctrl & DWC3_TRB_CTRL_HWO);
		bool lst = !!(trb.ctrl & DWC3_TRB_CTRL_LST);
		bool chn = !!(trb.ctrl & DWC3_TRB_CTRL_CHN);
		bool csp = !!(trb.ctrl & DWC3_TRB_CTRL_CSP);
		bool isp = !!(trb.ctrl & DWC3_TRB_CTRL_ISP_IMI);
		bool ioc = !!(trb.ctrl & DWC3_TRB_CTRL_IOC);
		bool spr = !!(trb.ctrl & DWC3_TRB_CTRL_SPR);
		uint32_t trbctl = FIELD_GET(DWC3_TRB_CTRL_TRBCTL_MASK, trb.ctrl);
		uint32_t trbsts = FIELD_GET(DWC3_TRB_STATUS_TRBSTS_MASK, trb.status);
		uint32_t pcm1 = FIELD_GET(DWC3_TRB_CTRL_PCM1_MASK, trb.ctrl);
		uint32_t sidsofn = FIELD_GET(DWC3_TRB_CTRL_SIDSOFN_MASK, trb.ctrl);
		uint32_t bufsiz = FIELD_GET(DWC3_TRB_STATUS_BUFSIZ_MASK, trb.status);
		char *head = (i == ep_data->head) ? " <HEAD" : "";
		char *tail = (i == ep_data->tail) ? " <TAIL" : "";
		char *full = (i == ep_data->head && ep_data->full) ? " <FULL" : "";

		shell_print(sh, "%p ep=0x%02x addr=0x%08x%08x ctl=%u sts=%u hwo=%u lst=%u chn=%u"
			  " csp=%u isp=%u ioc=%u spr=%u pcm1=%u sof=%u bufsiz=%u%s%s%s",
			  &ep_data->trb_buf[i], ep_data->cfg.addr, trb.addr_hi, trb.addr_lo, trbctl,
			  trbsts, hwo, lst, chn, csp, isp, ioc, spr, pcm1, sidsofn, bufsiz, head,
			  tail, full);
	}
}

void dwc3_dump_each(const struct device *dev,
			     void (*fn)(const struct device *, struct dwc3_ep_data *,
					const struct shell *),
			     char *label, const struct shell *sh)
{
	const struct dwc3_config *cfg = dev->config;

	for (int i = 0; i < cfg->num_in_eps; i++) {
		struct dwc3_ep_data *ep_data = &cfg->ep_data_in[i];
		uint8_t addr = ep_data->cfg.addr;

		if (ep_data->trb_buf == NULL) {
			continue;
		}

		shell_print(sh, "%s for IN endpoint 0x%02x (%u %s)",
			  label, addr, addr & 0x7f, (addr & 0x80) ? "IN" : "OUT");
		(*fn)(dev, ep_data, sh);
	}

	for (int i = 0; i < cfg->num_out_eps; i++) {
		struct dwc3_ep_data *ep_data = &cfg->ep_data_out[i];
		uint8_t addr = ep_data->cfg.addr;

		if (ep_data->trb_buf == NULL) {
			continue;
		}

		shell_print(sh, "%s for OUT endpoint 0x%02x (%u %s)",
			  label, addr, addr & 0x7f, (addr & 0x80) ? "IN" : "OUT");
		(*fn)(dev, ep_data, sh);
	}
}

void dwc3_dump_each_trb(const struct device *dev, const struct shell *sh)
{
	dwc3_dump_each(dev, dwc3_dump_trb, "trb", sh);
}

void dwc3_dump_fifo_space(const struct device *dev, const struct shell *sh)
{
	struct {
		char *name;
		uint32_t addr, num;
	} fifo[] = {
#define R(r, n) {.name = #r, .addr = DWC3_GDBGFIFOSPACE_QUEUETYPE_##r, .num = n}
		R(TX, 0),        R(RX, 0),        R(TXREQ, 0),    R(RXREQ, 0), R(RXINFO, 0),
		R(DESCFETCH, 0), R(TX, 1),        R(RX, 1),       R(TXREQ, 1), R(RXREQ, 1),
		R(RXINFO, 1),    R(DESCFETCH, 1), R(PROTOCOL, 2),
#undef R
	};
	const struct dwc3_config *cfg = dev->config;
	uint32_t reg;

	for (size_t i = 0; i < sizeof(fifo) / sizeof(*fifo); i++) {
		reg = fifo[i].addr;
		reg |= FIELD_PREP(DWC3_GDBGFIFOSPACE_QUEUENUM_MASK, fifo[i].num);
		sys_write32(reg, cfg->base + DWC3_GDBGFIFOSPACE);

		reg = sys_read32(cfg->base + DWC3_GDBGFIFOSPACE);
		reg = FIELD_GET(DWC3_GDBGFIFOSPACE_AVAILABLE_MASK, reg);

		shell_print(sh, "%-15s [%u] = %u", fifo[i].name, fifo[i].num, reg);
	}
}

void dwc3_dump_all(const struct device *dev, const struct shell *sh)
{
	dwc3_dump_registers(dev, sh);
	dwc3_dump_bus_error(dev, sh);
	dwc3_dump_link_state(dev, sh);
	dwc3_dump_events(dev, sh);
	dwc3_dump_fifo_space(dev, sh);
	dwc3_dump_each_trb(dev, sh);
}

static int dump_cmd2_handler(const struct shell *sh, size_t argc, char **argv,
			     void (*fn)(const struct device *, const struct shell *sh))
{
	const struct device *dev;

	__ASSERT_NO_MSG(argc == 2);

	dev = device_get_binding(argv[1]);
	if (!dev) {
		shell_error(sh, "Device %s not found", argv[1]);
		return -ENODEV;
	}

	(*fn)(dev, sh);
	return 0;
}

static void device_name_get(size_t idx, struct shell_static_entry *entry)
{
	const struct device *dev = shell_device_lookup(idx, NULL);

	entry->syntax = (dev == NULL) ? NULL : dev->name;
	entry->handler = NULL;
	entry->help = NULL;
	entry->subcmd = NULL;
}
SHELL_DYNAMIC_CMD_CREATE(dsub_device_name, device_name_get);

static int cmd_tvai_dwc3_trb(const struct shell *sh, size_t argc, char **argv)
{
	return dump_cmd2_handler(sh, argc, argv, dwc3_dump_each_trb);
}

static int cmd_tvai_dwc3_evt(const struct shell *sh, size_t argc, char **argv)
{
	return dump_cmd2_handler(sh, argc, argv, dwc3_dump_events);
}

static int cmd_tvai_dwc3_reg(const struct shell *sh, size_t argc, char **argv)
{
	return dump_cmd2_handler(sh, argc, argv, dwc3_dump_registers);
}

static int cmd_tvai_dwc3_buserr(const struct shell *sh, size_t argc, char **argv)
{
	return dump_cmd2_handler(sh, argc, argv, dwc3_dump_bus_error);
}

static int cmd_tvai_dwc3_link(const struct shell *sh, size_t argc, char **argv)
{
	return dump_cmd2_handler(sh, argc, argv, dwc3_dump_link_state);
}

static int cmd_tvai_dwc3_fifo(const struct shell *sh, size_t argc, char **argv)
{
	return dump_cmd2_handler(sh, argc, argv, dwc3_dump_fifo_space);
}

static int cmd_tvai_dwc3_all(const struct shell *sh, size_t argc, char **argv)
{
	return dump_cmd2_handler(sh, argc, argv, dwc3_dump_all);
}

SHELL_STATIC_SUBCMD_SET_CREATE(sub_tvai_dwc3,
	SHELL_CMD_ARG(trb, &dsub_device_name,
		      "Dump an endpoint's TRB buffer\n" "Usage: trb <device>",
		      cmd_tvai_dwc3_trb, 2, 0),
	SHELL_CMD_ARG(evt, &dsub_device_name,
		      "Dump the device event buffer\n" "Usage: evt <device>",
		      cmd_tvai_dwc3_evt, 2, 0),
	SHELL_CMD_ARG(reg, &dsub_device_name,
		      "Dump the device status registers\n" "Usage: reg <device>",
		      cmd_tvai_dwc3_reg, 2, 0),
	SHELL_CMD_ARG(buserr, &dsub_device_name,
		      "Dump the AXI64 bus I/O errors\n" "Usage: buserr <device>",
		      cmd_tvai_dwc3_buserr, 2, 0),
	SHELL_CMD_ARG(link, &dsub_device_name,
		      "Dump the USB link state\n" "Usage: link <device>",
		      cmd_tvai_dwc3_link, 2, 0),
	SHELL_CMD_ARG(fifo, &dsub_device_name,
		      "Dump the FIFO available space\n" "Usage: fifo <device>",
		      cmd_tvai_dwc3_fifo, 2, 0),
	SHELL_CMD_ARG(all, &dsub_device_name,
		      "Dump everything\n" "Usage: all <device>",
		      cmd_tvai_dwc3_all, 2, 0),
	SHELL_SUBCMD_SET_END);

SHELL_CMD_REGISTER(tvai_dwc3, &sub_tvai_dwc3, "Synopsys DWC3 controller commands", NULL);
