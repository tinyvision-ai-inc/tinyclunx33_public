# Use make TOP=<top name> to run a simulation

SHELL=/bin/bash

WORKDIR = work

RTL = ../src
TB = ../tb
#RISCV = ../litex/pythondata-cpu-vexriscv/pythondata_cpu_vexriscv/verilog
COMMON = ../common
COMMON_IP = ../ip
IP = ../ip
LITEX = ../litex/build/som/gateware

TOP = fpga_top_lifcl33u_som
#SIM_SRCS = $(IP)/wb2axip/rtl/afifo.v $(IP)/wb2axip/rtl/wbxclk.v
SIM_SRCS += $(RTL)/VexRiscv.v
SIM_SRCS += $(TB)/tb_$(TOP).sv


SRCH_PATH = -y $(TB) -y $(RTL) -y $(COMMON) -y $(LITEX) \
 -y $(COMMON_IP)/main_pll/rtl -y $(COMMON_IP)/int_osc/rtl \
 -y $(COMMON_IP)/dpram1024x8/rtl -y $(COMMON_IP)/dpram2048x8/rtl -y $(COMMON_IP)/dpram4096x8/rtl \
 -y $(COMMON_IP)/rx_dphy_2l/rtl -y $(COMMON_IP)/rx_dphy_s_2lane/rtl -y $(COMMON_IP)/b2p_2lane/rtl\
 -y $(COMMON_IP)/p2b_2lane/rtl -y $(COMMON_IP)/tx_dphy_s_2lane/rtl \
 -y $(COMMON_IP)/p2b_2l_yuv422_8/rtl \
 -y ../python/i2c \
 -y $(IP)/wb_intercon/rtl/verilog -y $(IP)/cdc_utils/rtl/verilog -y $(IP)/wb_ram/rtl/verilog

 INC_DIR = +incdir+$(IP)/wb_common

VLOG_OPTS = -93 -sv -warning vlog-2388 -suppress 2388 -lint=full -pedanticerrors -fsmverbose w +libext+.v+.vl+.sv +libext+.sv \
 +define+FAST_SIM +define+SIM $(SRCH_PATH) $(INC_DIR)

VSIM_OPTS = -warning vsim-3009 -t 100fs -voptargs="+acc" -L lifcl -L ovi_lifcl -L pmi_work -suppress vsim-7033,vsim-8630,3009,3389 +define+FAST_SIM +define+SIM

.PHONY: compile sim lib clean

compile: $(WORKDIR) $(SIM_SRCS)
	vlog $(VLOG_OPTS) $(SIM_SRCS)

sim:
	vsim -c $(VSIM_OPTS) -do "run -all; quit" work.tb_$(TOP)

sim_gui:
	vsim -gui $(VSIM_OPTS) work.tb_$(TOP)

$(WORKDIR):
	vlib work

clean:
	rm -rf transcript $(WORKDIR) *.wlf wlf* *.tap *.hex
