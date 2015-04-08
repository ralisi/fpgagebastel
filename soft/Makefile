CC      := lm32-elf-gcc
CFLAGS  := -Wall -mmultiply-enabled -mbarrel-shift-enabled -Os -ggdb -ffreestanding

run: programmed.bit
	djtgcfg prog -d Basys2 -i 0 -f programmed.bit

programmed.bit: blink.elf ../config/memory.bmm ../build/Basys2UserDemo.bit
	data2mem -bm ../config/memory.bmm -bd blink.elf -bt ../build/Basys2UserDemo.bit -o b programmed.bit

blink.coe: blink.bin
	python bin2coe.py > $@

blink.bin: blink.elf
	lm32-elf-objcopy -O binary $< $@

blink.elf: crt0.o main.o
	$(CC) $(CFLAGS) -o $@ -nostdlib -T linker.ld $^

clean:
	rm -f *.o *.elf *.bin *.coe
