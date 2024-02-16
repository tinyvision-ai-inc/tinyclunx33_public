# Copyright (c) 2023, tinyVision.ai
# SPDX-Licence-Identifier: MIT

import re
import sys

from migen import *

from litex.gen import *
from litex.build.io import *
from litex.soc.cores.clock import *
from litex.soc.cores.ram import NXLRAM
from litex_zephyr_soc import ZephyrSoC
from litex.soc.integration.soc_core import SoCCore
from litex.soc.integration.soc import SoCRegion
from litex.soc.interconnect import axi
from litex.soc.interconnect import ahb
from litex.soc.interconnect import wishbone
from litex.soc.interconnect.csr_eventmanager import *

from litex.build.generic_platform import GenericPlatform, Pins, Subsignal
from litex.tools import litex_soc_gen

from litespi.opcodes import SpiNorFlashOpCodes as Codes
from litespi.modules import W25Q128FW as Flash

kB = 1024

soc_io = [
    ("sys_clk", 0, Pins(1)),
    ("sys_rst", 0, Pins(1)),

    ("serial", 0,
        Subsignal("tx", Pins(1)),
        Subsignal("rx", Pins(1)),
    ),

    ("eth_clocks", 0,
        Subsignal("tx", Pins(1)),
        Subsignal("rx", Pins(1)),
    ),

    ("eth", 0,
        Subsignal("source_valid", Pins(1)),
        Subsignal("source_ready", Pins(1)),
        Subsignal("source_data",  Pins(8)),

        Subsignal("sink_valid",   Pins(1)),
        Subsignal("sink_ready",   Pins(1)),
        Subsignal("sink_data",    Pins(8)),
    ),

    ("xgmii_eth", 0,
        Subsignal("rx_data",      Pins(64)),
        Subsignal("rx_ctl",       Pins(8)),
        Subsignal("tx_data",      Pins(64)),
        Subsignal("tx_ctl",       Pins(8)),
    ),

    ("gmii_eth", 0,
        Subsignal("rx_data",      Pins(8)),
        Subsignal("rx_dv",        Pins(1)),
        Subsignal("rx_er",        Pins(1)),
        Subsignal("tx_data",      Pins(8)),
        Subsignal("tx_en",        Pins(1)),
        Subsignal("tx_er",        Pins(1)),
    ),

    ("i2c", 0,
        Subsignal("scl",     Pins(1)),
        Subsignal("sda",     Pins(1)),
    ),

    ("spiflash", 0,
        Subsignal("cs_n", Pins(1)),
        Subsignal("clk",  Pins(1)),
        Subsignal("mosi", Pins(1)),
        Subsignal("miso", Pins(1)),
        Subsignal("wp",   Pins(1)),
        Subsignal("hold", Pins(1)),
    ),

    ("spiflash4x", 0,
        Subsignal("cs_n", Pins(1)),
        Subsignal("clk",  Pins(1)),
        Subsignal("dq",   Pins(4)),
    ),

    ("gpio", 0,
        Subsignal("oe", Pins(32)),
        Subsignal("o",  Pins(32)),
        Subsignal("i",  Pins(32)),
    ),

    ("vga", 0,
        Subsignal("hsync", Pins(1)),
        Subsignal("vsync", Pins(1)),
        Subsignal("de",    Pins(1)),
        Subsignal("r",     Pins(8)),
        Subsignal("g",     Pins(8)),
        Subsignal("b",     Pins(8)),
    ),

    ("axi", 0,
        Subsignal("arid",      Pins(8)),
        Subsignal("araddr",    Pins(32)),
        Subsignal("arburst",   Pins(2)),
        Subsignal("arcache",   Pins(4)),
        Subsignal("arlen",     Pins(8)),
        Subsignal("arlock",    Pins(2)),
        Subsignal("arprot",    Pins(3)),
        Subsignal("arqos",     Pins(4)),
        Subsignal("arsize",    Pins(3)),
        Subsignal("arready",   Pins(1)),
        Subsignal("arregion",  Pins(4)),
        Subsignal("aruser",    Pins(1)),
        Subsignal("arvalid",   Pins(1)),
        Subsignal("awid",      Pins(8)),
        Subsignal("awaddr",    Pins(32)),
        Subsignal("awburst",   Pins(2)),
        Subsignal("awcache",   Pins(4)),
        Subsignal("awlen",     Pins(8)),
        Subsignal("awlock",    Pins(2)),
        Subsignal("awprot",    Pins(3)),
        Subsignal("awqos",     Pins(4)),
        Subsignal("awregion",  Pins(4)),
        Subsignal("awuser",    Pins(1)),
        Subsignal("awsize",    Pins(3)),
        Subsignal("awready",   Pins(1)),
        Subsignal("awvalid",   Pins(1)),
        Subsignal("bresp",     Pins(2)),
        Subsignal("bready",    Pins(1)),
        Subsignal("bvalid",    Pins(1)),
        Subsignal("bid",       Pins(8)),
        Subsignal("buser",     Pins(1)),
        Subsignal("rdata",     Pins(64)),
        Subsignal("rid",       Pins(8)),
        Subsignal("rlast",     Pins(1)),
        Subsignal("rresp",     Pins(2)),
        Subsignal("rready",    Pins(1)),
        Subsignal("ruser",     Pins(1)),
        Subsignal("rvalid",    Pins(1)),
        Subsignal("wlast",     Pins(1)),
        Subsignal("wdata",     Pins(64)),
        Subsignal("wstrb",     Pins(8)),
        Subsignal("wready",    Pins(1)),
        Subsignal("wvalid",    Pins(1)),
        Subsignal("wuser",     Pins(1)),
    ),

    ("ahb", 0,
        Subsignal("haddr",    Pins(32)),
        Subsignal("hburst",   Pins(3)),
        Subsignal("hprot",    Pins(4)),
        Subsignal("hsel",    Pins(1)),
        Subsignal("hprot",    Pins(4)),
        Subsignal("hsize",    Pins(3)),
        Subsignal("hrdata",   Pins(32)),
        Subsignal("htrans",   Pins(2)),
        Subsignal("hwdata",   Pins(32)),
        Subsignal("hwrite",   Pins(1)),
        Subsignal("hreadyout",   Pins(1)),
        Subsignal("hresp",   Pins(1)),
    ),

    ("wishbone", 0,
        Subsignal("adr",   Pins(32)),
        Subsignal("sel",   Pins(4)),
        Subsignal("cti",   Pins(3)),
        Subsignal("bte",   Pins(2)),
        Subsignal("we",    Pins(1)),
        Subsignal("dat_w", Pins(32)),
        Subsignal("cyc",   Pins(1)),
        Subsignal("stb",   Pins(1)),
        Subsignal("ack",   Pins(1)),
        Subsignal("err",   Pins(1)),
        Subsignal("dat_r", Pins(32)),
    ),

    ("usb23", 0,
        Subsignal("irq", Pins(1)),
    ),

    ("framectl", 0,
        Subsignal("irq", Pins(1)),
    ),
]

class VerilogAXIPort(LiteXModule):
    def __init__(self, pads, width=32, mode="slave"):
        assert width in [32, 64]
        self.bus = axi.AXIInterface(data_width=width)
        self.width = width
        self.comb += self.bus.connect_to_pads(pads, mode=mode)

class VerilogAHBPort(LiteXModule):
    def __init__(self, pads, width=32, mode="slave"):
        self.bus = ahb.Interface(data_width=width)
        assert width in [32, 64]
        self.width = width
        self.comb += self.bus.connect_to_pads(pads, mode=mode)

class VerilogWBPort(LiteXModule):
    def __init__(self, pads, width=32, mode="slave"):
        assert width in [32, 64]
        self.bus = wishbone.Interface(data_width=width)
        self.width = width
        self.comb += self.bus.connect_to_pads(pads, mode=mode)

class USB23(LiteXModule):
    def __init__(self, pads):
        self.ev = EventManager()
        self.ev.usb = EventSourceProcess(edge="rising")
        self.ev.finalize()
        self.comb += self.ev.usb.trigger.eq(pads.irq)

class FrameCtl(LiteXModule):
    def __init__(self, pads):
        self.ev = EventManager()
        self.ev.frame = EventSourceProcess(edge="rising")
        self.ev.finalize()
        self.comb += self.ev.frame.trigger.eq(pads.irq)

class MainSoC(ZephyrSoC, SoCCore):
    soc_kwargs = {
        #"cpu_variant": "lite",
        #"bus_interconnect":"crossbar",
        "bus_bursting": True,
        "integrated_sram_size": 0x0, # Replaced with the NXLRAM
        "cpu_reset_address": 0x2010_0000,
        "irq_n_irqs": 16,
    }

    def __init__(self, name, sys_clk_freq=None, rom_size=0, sram_size=0, **kwargs):
        self.platform = litex_soc_gen.Platform("build", soc_io, name=name)
        self.crg = CRG(self.platform.request("sys_clk"), self.platform.request("sys_rst"))

        ZephyrSoC.__init__(self, **self.soc_kwargs)
        self.soc_kwargs["integrated_rom_size"] = rom_size
        self.soc_kwargs["integrated_sram_size"] = sram_size
        SoCCore.__init__(self, self.platform, sys_clk_freq, **self.soc_kwargs)
        ZephyrSoC.__init__(self, **self.soc_kwargs)

        self.add_i2c()
        # Note: can change to DDR by setting rate="1:2", will need some changes to suport this."
        self.add_spi_flash(mode="4x", module=Flash(default_read_cmd=Codes.READ_1_1_4), clk_freq=sys_clk_freq, rate="1:1", with_master=False)
        self.add_main_ram()
        self.add_wb_slave_port(origin=0xb0000000, size=0x0f000000)
        self.add_usb23()
        self.add_framectl()

    def add_usb23(self):
        pads = self.platform.request("usb23", 0)
        self.submodules.usb23 = USB23(pads)
        self.irq.add("usb23", use_loc_if_exists=True)

    def add_framectl(self):
        pads = self.platform.request("framectl", 0)
        self.submodules.framectl = FrameCtl(pads)
        self.irq.add("framectl", use_loc_if_exists=True)

    def add_main_ram(self):
        self.main_ram = NXLRAM(32, 64*kB)
        region = SoCRegion(origin=self.mem_map["main_ram"], size=64*kB)
        self.bus.add_slave("main_ram", self.main_ram.bus, region)

    # In the naming below:
    # - "master" for when the external (slave) port drives the LiteX bus
    # - "slave" for when the external (master) port is driven by the LiteX bus

    def add_ahb_master_port(self, id=0, width=32):
        pads = platform.request("ahb", id)
        port = VerilogAHBPort(self.pads, width=width, mode="master")
        self.submodules += port
        self.bus.add_master(name=f"ahb{id}", master=port.bus)

    def add_ahb_slave_port(self, origin, size=0x10000, id=0, width=32):
        self.mem_map[f"axi{id}"] = origin
        pads = self.platform.request("ahb", id)
        port = VerilogAHBPort(pads, width=width, mode="slave")
        region = SoCRegion(origin=origin, size=size, cached=False)
        self.submodules += port
        self.bus.add_slave(name=f"ahb{id}", slave=port.bus, region=region)

    def add_wb_master_port(self, id=0, width=32):
        pads = self.platform.request("wishbone", id)
        port = VerilogWBPort(pads, width=width, mode="slave")
        self.submodules += port
        self.bus.add_master(name=f"wb{id}", master=port.bus)

    def add_wb_slave_port(self, origin, size=0xf000000, id=0, width=32):
        self.mem_map[f"wb{id}"] = origin
        pads = self.platform.request("wishbone", id)
        port = VerilogWBPort(pads, width=width, mode="master")
        region = SoCRegion(origin=origin, size=size, cached=False)
        self.submodules += port
        self.bus.add_slave(name=f"wb{id}", slave=port.bus, region=region)

    def add_axi_master_port(self, id=0, width=32):
        pads = self.platform.request("axi", id)
        port = VerilogAXIPort(pads, width=width, mode="slave")
        self.submodules += port
        self.bus.add_master(name=f"axi{id}", master=port.bus)

    def add_axi_slave_port(self, origin, size=0x10000, id=0, width=32):
        self.mem_map[f"axi{id}"] = origin
        pads = self.platform.request("axi", id)
        port = VerilogAXIPort(pads, width=width, mode="master")
        region = SoCRegion(origin=origin, size=size, cached=False)
        self.submodules += port
        self.bus.add_slave(name=f"axi{id}", slave=port.bus, region=region)
