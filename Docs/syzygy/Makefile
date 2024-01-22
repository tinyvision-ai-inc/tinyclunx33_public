SZG += szg_std.tsv
POD += szg_camera.tsv
POD += szg_mipi_8320.tsv
POD += szg_dac_ad911x.tsv
POD += szg_adc_ltc226x.tsv
POD += szg_enet1g.tsv

all: syzygy.txt

syzygy.tsv: $(SZG) $(POD)
	python3 summary.py $(SZG) $(POD) >$@

syzygy.txt: syzygy.tsv
	column -t -s '	' $< >$@
