# You might want to configure a virtual environment
PYTHON = python3

# LiteX init script cloning the repos and installing them as python packages
LITEX_SETUP_URL = https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py

# Scripts invoked for generating the RTL: top level of LiteX
LITEX_SOC_PY += python/litex_main_soc.py 
LITEX_SOC_PY += python/litex_zephyr_soc.py
LITEX_SOC_PY += python/litex_top_som.py

all: litex.overlay litex.conf

-include config.mk

setup: litex/litex_setup.py
	$(PYTHON) -m pip install meson ninja
	mkdir -p litex
	cd litex && $(PYTHON) litex_setup.py --init --install

clean:
	rm -rf litex/build/ *.history
	rm -rf impl/ *.bit *.html *.xml

release:
	mkdir -p release
	cp impl/*.bit *.sty *.rvs *.rvl *.rdf release

litex/litex_setup.py:
	mkdir -p litex
	wget -O $@ $(LITEX_SETUP_URL)

spinal src/TinyClunx.v: spinal/TinyClunx.scala
	sbt run

software: $(LITEX_SOC_PY)
	cd litex && $(PYTHON) ../python/litex_top_software.py

gateware: $(LITEX_SOC_PY)
	cd litex && $(PYTHON) ../python/litex_top_som.py
	cp litex/build/som/gateware/som.v src

wishbone src/wb_intercon.v: src/wb_intercon.cfg
	python ip/wb_intercon/sw/wb_intercon_gen src/wb_intercon.cfg src/wb_intercon.v

litex litex.overlay litex.conf: gateware
	$(PYTHON) python/litex_json2dts_zephyr.py --dts=litex.overlay --config=litex.conf litex/build/csr.som.json

.PHONY: spinal litex
