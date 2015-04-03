COREGENPROJECT:=coregen.cgp


all: generated/memory.v generated/memory.ngc generated/framebuffer.vhd generated/framebuffer.ngc

clean:
	rm -rf coregen_tmp generated

generated/%.v generated/%.vhd generated/%.ngc: %.xco ${COREGENPROJECT}
	mkdir -p coregen_tmp
	cp ${COREGENPROJECT} coregen_tmp/
	cd coregen_tmp ; coregen -b ../$< -p coregen.cgp
	mkdir -p generated
	-cp coregen_tmp/$*.v coregen_tmp/$*.vhd coregen_tmp/$*.ngc generated
	rm -rf coregen_tmp

