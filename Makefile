build_dir=build

all: boot.bin

run: all 
	qemu-system-i386 boot.bin 

build: boot.bin | $(builddir)

boot.bin: protected.asm
	nasm -fbin protected.asm -o $(build_dir)/boot.bin

$(build_dir):
	mkdir -p build/

clean:
	rm *.bin

