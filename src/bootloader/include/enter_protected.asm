	; gdt_descriptor and CODE_SEG and pm_start are defined in protected.asm and in gdt.asm:w

enter_protected:
	;   clear screen
	mov ah, 0x0
	mov al, 0x3
	int 0x10

	;Disable interrupts
	cli

	;Load GDT
	lgdt  [gdt_descriptor]

	;Switch to 32 bits, set cr0
	mov     eax, cr0
	or      eax, 0x1
	mov     cr0, eax

	;do a far jump to flush CPU pipeline
	jmp CODE_SEG:pm_start
