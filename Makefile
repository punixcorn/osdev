bootloader=src/boot.asm
kernel=src/call_kernel.c
#kernel_files := $(shell find src/kernel/ -name *.c)
kernel_files :=
bin=temp.bin
iso=potatOs.iso
build_dir=build
Linker=src/linker.ld

all: build

build: bootloader kernel 

kernel:
	# create and empty file
	dd if=/dev/zero of=${build_dir}/os.bin bs=512 count=10
	# build kernel
	i386-elf-gcc -m32 -g -ffreestanding -c ${kernel} ${kernel_files} -o ${build_dir}/kernel.o
	i386-elf-ld -o ${build_dir}/kernel.bin -T${Linker} ${build_dir}/kernel.o --oformat binary
	# add bootloader to kernel
	cat ${build_dir}/bootloader.bin  ${build_dir}/kernel.bin > ${build_dir}/${bin}
	# move them into the empty file
	dd if=${build_dir}/${bin} of=${build_dir}/os.bin conv=notrunc bs=512
	

bootloader: ${bootloader}
	mkdir -p build/
	nasm -fbin ${bootloader} -o ${build_dir}/bootloader.bin

dev:
	i386-elf-gcc -m32 -g -ffreestanding -c ${kernel} ${kernel_files} -o ${build_dir}/kernel.o
	i386-elf-ld -o ${build_dir}/kernel.oo -T${Linker} ${build_dir}/kernel.o
	objdump -d -h -M intel ${build_dir}/kernel.o


run: all 
	qemu-system-i386 ${build_dir}/os.bin

clean:
	rm -rf build/

