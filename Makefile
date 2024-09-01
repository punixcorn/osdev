BOOTSTRAP = src/kernel/kernel.asm
KERNEL_SRC = src/kernel/kernel.c
BIN :=
linker = linker.ld
KERNEL_OUT = build/kernel.bin
ISO = build/osdev.iso


all: build

# build elf32 binary for multiboot
build: clean
	mkdir -p build
	nasm -f elf32 ${BOOTSTRAP} -o build/bootstrap.o
	gcc -m32 -ffreestanding -c ${KERNEL_SRC} -o build/kernel.o -w
	ld -m elf_i386 -T${linker} -o ${KERNEL_OUT} build/kernel.o build/bootstrap.o

build-debug: clean
	mkdir -p build
	nasm -f elf32 ${BOOTSTRAP}  -o build/bootstrap.o
	gcc -m32 -ffreestanding -c ${KERNEL_SRC} -o build/kernel.o -ggdb
	ld -m elf_i386 -T${linker} -o ${KERNEL_OUT} build/kernel.o build/bootstrap.o

debug:
	qemu-system-i386 -kernel ${KERNEL_OUT} -s -S &
	gdb -x .gdbinit

iso: build
	mkdir -p build/target/iso/boot/grub
	cp src/target/grub.cfg build/target/iso/boot/grub
	cp ${KERNEL_OUT} build/target/iso/boot/
	grub-mkrescue build/target/iso -o ${ISO}

# #dd if=/dev/zero of=build/iso/osdev.img bs=1024 count=1440
# dd if=${BIN} of=build/iso/osdev.img seek=0 count=1 conv=notrunc
# genisoimage -quiet -V "OSDEV" -input-charset iso8859-1 -o build/osdev.iso -b osdev.img -hide build/iso/osdev.img build/iso
# rm -rf build/iso

run-iso: iso
	qemu-system-i386 -cdrom ${ISO}

run: build
	qemu-system-i386 -kernel ${KERNEL_OUT}

clean:
	rm -rf build
