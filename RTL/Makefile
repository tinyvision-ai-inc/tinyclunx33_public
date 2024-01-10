# You might want to configure a virtual environment
PYTHON = python3

BIN_DIR = bin/$$(date +%Y%m%d)

# LiteX init script cloning the repos and installing them as python packages
LITEX_SETUP_URL = https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py

# Scripts invoked for generating the RTL: top level of LiteX
LITEX_SOC_PY += python/litex_main_soc.py 
LITEX_SOC_PY += python/litex_zephyr_soc.py
LITEX_SOC_PY += python/litex_top_som.py

all: litex.overlay litex.conf

software:
	cd litex && $(PYTHON) ../python/litex_top_software.py

setup: litex/litex_setup.py
	$(PYTHON) -m pip install meson ninja
	mkdir -p litex
	cd litex && $(PYTHON) litex_setup.py --init --install

clean:
	rm -rf litex/build abc.history *.bit

release:
	@echo "Creating release under: $(BIN_DIR)"
	mkdir -p $(BIN_DIR)
	cp impl/fpga_top_som_impl.bit *.sty *.rvs *.rvl *.rdf $(BIN_DIR)

litex/litex_setup.py:
	mkdir -p litex
	wget -O $@ $(LITEX_SETUP_URL)

litex/build/csr.som.json litex/build/som/gateware/som.v: $(LITEX_SOC_PY)
	cd litex && $(PYTHON) ../python/litex_top_som.py
	touch litex/build/csr.som.json

litex.overlay litex.conf: python/litex_json2dts_zephyr.py litex/build/csr.som.json
	$(PYTHON) python/litex_json2dts_zephyr.py --dts=litex.overlay --config=litex.conf litex/build/csr.som.json
