bits 16
[org 0x7c00]


start:              ;start
    call enter_protected
    jmp  $

%include "./lib/gdt.asm"
%include "./lib/enter_protected.asm"

[bits 32]

pm_start:
	;   print a charater
	mov ah, 0x0F
	mov al, 'P'
	mov [0xb8000], ax
	mov al, 'O'
	mov [0xb8000], ax
	jmp $

times 510-($-$$) db 0
dw    0xaa55
