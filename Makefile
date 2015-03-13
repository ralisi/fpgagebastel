program: build/Basys2UserDemo.bit
	djtgcfg prog -d Basys2 -i 0 -f $<

build/Basys2UserDemo.ngc: config/Basys2UserDemo.prj
	mkdir -p build/xst/projnav.tmp/
	cd build; xst -intstyle ise -ifn "../config/Basys2UserDemo.xst" -ofn "Basys2UserDemo.syr"

build/Basys2UserDemo.ngd: build/Basys2UserDemo.ngc
	cd build; ngdbuild -uc ../config/Basys2UserDemo.ucf -p xc3s250e-cp132-5 -sd ../ipcores/generated $(notdir $<) $(notdir $@)

build/Basys2UserDemo.pcf: build/Basys2UserDemo.ngd
	cd build; map -detail -pr b $(notdir $<)

build/parout.ncd: build/Basys2UserDemo.pcf
	cd build; par -w Basys2UserDemo.ncd parout.ncd Basys2UserDemo.pcf


build/Basys2UserDemo.bit: build/parout.ncd
	cd build; bitgen -w -g StartUpClk:JtagClk -g CRC:Enable parout.ncd $(notdir $@) Basys2UserDemo.pcf