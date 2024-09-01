[bits 32]

%include "src/bootloader/boot.asm"; contains multiboot leaders

section .text

entry:
	jmp bootstrap

%include "src/include/gdt.asm"

global bootstrap; entry, calls _start
extern _start; kernel entry, defined in kernel.c

	global print_char
	global load_gdt
	global load_idt
	global ioport_in
	global ioport_out
	global keyboard_handler
	global enable_intterupts
	extern handle_keyboard_intterupts
	;      stack issues
	global __stack_chk_fail_local

load_gdt:
	lgdt [gdt_descriptor]
	ret

load_idt:
	mov  edx, [esp + 4]
	lidt [edx]
	ret

enable_intterupts:
	sti
	ret

keyboard_handler:
	pushad
	cld
	call handle_keyboard_intterupts
	popad
	iret

ioport_in:
	mov edx, [ esp + 4]
	in  al, dx
	ret

ioport_out:
	mov edx, [ esp + 4]
	mov eax, [ esp + 8]
	out dx, al
	ret

print_char:
	mov eax, [ esp + 8 ]; get row
	mov edx, 80; max cols
	mul edx; eax  = row * 80
	add eax, [ esp + 12 ]; eax = row * 80 + col
	mov edx, 2; 2 bytes per char
	mul edx
	mov edx, 0xb80000
	add edx, eax; add offset
	mov eax, [esp + 4]; char c
	mov [edx], al
	ret

bootstrap:
	lgdt [gdt_descriptor]
	jmp  CODE_SEG:.setCODE_SEG

.setCODE_SEG:
	mov  ax, DATA_SEG
	mov  ds, ax
	mov  es, ax
	mov  fs, ax
	mov  gs, ax
	mov  ss, ax
	mov  esp, stack
	cli
	mov  esp, stack
	call _start

.repeat:
	jmp .repeat

section .bss
resb    8192

stack:
