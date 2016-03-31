NGC := ipcores/generated/framebuffer.ngc
VHDFILES := $(shell find . -type f -name '*.vhd')
VFILES := $(shell find . -type f -name '*.v')
HDLFILES := $(VHDFILES) $(VFILES)

program: build/Nexys2.bit
	make -C soft

build/Basys2UserDemo.ngc: config/MyProject.prj $(HDLFILES) config/Basys2UserDemo.xst
	mkdir -p build/xst/projnav.tmp/
	cd build; xst -intstyle ise -ifn "../config/Basys2UserDemo.xst" -ofn "Basys2UserDemo.syr"

build/Nexys2.ngc: config/MyProject.prj $(HDLFILES) config/Nexys2.xst
	mkdir -p build/xst/projnav.tmp/
	cd build; xst -intstyle ise -ifn "../config/Nexys2.xst" -ofn "Nexys2.syr"

.PHONY: %.ngc
%.ngc:
	make -C soft
	make -C ipcores

build/Basys2UserDemo.ngd: build/Basys2UserDemo.ngc $(NGC) config/Basys2UserDemo.ucf
	cd build; ngdbuild -uc ../config/Basys2UserDemo.ucf -sd ../ipcores/generated $(notdir $<) $(notdir $@)

build/Nexys2.ngd: build/Nexys2.ngc $(NGC) config/Nexys2.ucf
	cd build; ngdbuild -uc ../config/Nexys2.ucf -sd ../ipcores/generated $(notdir $<) $(notdir $@)

build/Basys2UserDemo.pcf: build/Basys2UserDemo.ngd
	cd build; map -detail -pr b $(notdir $<)

build/Nexys2.pcf: build/Nexys2.ngd
	cd build; map -detail -pr b $(notdir $<)

build/parout.ncd: build/Nexys2.pcf
	cd build; par -w Nexys2.ncd -pl std -rl std parout.ncd Nexys2.pcf

build/timing.check: build/parout.par
	@grep  'All constraints were met' build/parout.par > /dev/null || (grep constraint build/parout.par; false )
	touch build/timing.check

build/Nexys2.bit: build/parout.ncd build/timing.check
	cd build; bitgen -w -g StartUpClk:JtagClk -g CRC:Enable parout.ncd $(notdir $@) Nexys2.pcf

clean:
	rm -rf build
