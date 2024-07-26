bits 16
[org 0x7c00]

	mov  si, MSG_REAL_MODE
	call print
	hlt
	;    Load the kernel into mem
	mov  al, 0x1; number of sectors to read
	mov  bx, 0x0; read memory es:bx
	mov  es, bx; 0x0:0x0
	mov  bx, KERNEL_OFFSET; 0x0:KERNEL_OFFSET
	call disk_read

	mov  si, MSG_PROTECTED_MODE
	call print

	;    we jump to CODE_SEG:pm_start
	call enter_protected

	jmp $

%include "src/bootloader/include/disk_read.asm"
%include "src/bootloader/include/print.asm"
%include "src/bootloader/include/gdt.asm"
%include "src/bootloader/include/enter_protected.asm"

MSG_PROTECTED_MODE: db 0x0d,0x0a,"Moving into protected Mode",0x0d,0x0a,0
MSG_REAL_MODE: db "Real Mode: Welcome to potatOs",0x0d,0x0a,0
KERNEL_OFFSET equ 0x1000 ; we put .text code in there

[bits 32]

pm_start:
	;print ok
	;mov   dword [0xb8000], 0x2f4b2f4f

	;Jump to kernel code by calling memory location
	call  KERNEL_OFFSET
	jmp   $

times 510-($-$$) db 0
dw    0xaa55
