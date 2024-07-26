; holds gdt info to switch to 32bits mode
; each entry is 64bits, 2 dd, 4 dw, 8 dd

gdt_start:
gdt_null:               ; first entry, null
    dd 0x0
    dd 0x0
gdt_code:               ; second entry, code segment
    dw 0xffff           ; Limit bits 0-15
    dw 0x0000           ; Base bits 0-15
    db 0x00
    db 10011010b        ; flags ( google them )
    db 11001111b        ; flags ( google them )
    db 0x0              ; base bits 24-31
gdt_data:               ; second entry, data segment
    dw 0xffff           ; Limit bits 0-15
    dw 0x0000           ; Base bits 0-15
    db 0x00
    db 10010010b        ; flags ( google them )
    db 11001111b        ; flags ( google them )
    db 0x0              ; base bits 24-31
gdt_end:                ; nothing, just a label to show end

; GDT Descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1      ; size of gdt
    dd gdt_start

; constants
CODE_SEG equ gdt_code - gdt_start
DATE_SEG equ gdt_data - gdt_start
