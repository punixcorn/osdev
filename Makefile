# directories
bootdir := src/bootloader
kerneldir := src/kernel
build := build
configdir := src/config

kernel_files := 

all: build

build: bootloader kernel 
	
kernel:
	# create and empty file
	dd if=/dev/zero of=${build}/os.bin bs=512 count=10
	# build kernel
	i386-elf-gcc -m32 -g -ffreestanding -c ${kerneldir}/bootstrap.c ${kernel_files} -o ${build}/kernel.o
	i386-elf-ld -o ${build}/kernel.bin -T${configdir}/linker.ld ${build}/kernel.o --oformat binary
	# add bootloader to kernel
	cat ${build}/bootloader.bin  ${build}/kernel.bin > ${build}/dev.bin
	# move them into the empty file
	dd if=${build}/dev.bin of=${build}/os.bin conv=notrunc bs=512

bootloader: ${bootdir}/boot.asm
	mkdir -p build/
	nasm -fbin ${bootdir}/boot.asm -o ${build}/bootloader.bin

dev:

	i386-elf-gcc -m32 -g -ffreestanding -c ${kerneldir}/bootstrap.c ${kernel_files} -o ${build}/kernel.dev.o
	i386-elf-ld -o ${build}/kernel.dev.final.o -T${configdir}/linker.ld ${build}/kernel.dev.o 
	objdump -d -h -M intel ${build}/kernel.dev.final.o

run: all 
	qemu-system-i386 ${build}/os.bin

clean:
	rm -rf build/
