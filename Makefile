NGC := ipcores/generated/framebuffer.ngc
VHDFILES := $(shell find . -type f -name '*.vhd')
VFILES := $(shell find . -type f -name '*.v')
HDLFILES := $(VHDFILES) $(VFILES)

program: build/Basys2UserDemo.bit
	djtgcfg prog -d Basys2 -i 0 -f $<

build/Basys2UserDemo.ngc: config/Basys2UserDemo.prj $(HDLFILES) config/Basys2UserDemo.xst
	mkdir -p build/xst/projnav.tmp/
	cd build; xst -intstyle ise -ifn "../config/Basys2UserDemo.xst" -ofn "Basys2UserDemo.syr"

.PHONY: %.ngc
%.ngc:
	make -C soft
	make -C ipcores

build/Basys2UserDemo.ngd: build/Basys2UserDemo.ngc $(NGC) config/Basys2UserDemo.ucf
	cd build; ngdbuild -uc ../config/Basys2UserDemo.ucf -p xc3s250e-cp132-5 -sd ../ipcores/generated $(notdir $<) $(notdir $@)

build/Basys2UserDemo.pcf: build/Basys2UserDemo.ngd
	cd build; map -detail -pr b $(notdir $<)

build/parout.ncd: build/Basys2UserDemo.pcf
	cd build; par -w Basys2UserDemo.ncd -pl std -rl std parout.ncd Basys2UserDemo.pcf

build/timing.check: build/parout.par
	@grep  'All constraints were met' build/parout.par > /dev/null || (grep constraint build/parout.par; false )
	touch build/timing.check

build/Basys2UserDemo.bit: build/parout.ncd build/timing.check
	cd build; bitgen -w -g StartUpClk:JtagClk -g CRC:Enable parout.ncd $(notdir $@) Basys2UserDemo.pcf

clean:
	rm -rf build
