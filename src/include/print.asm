
print:
    pusha
    mov ah,0x0e
.chars:
    mov al, [si]
    cmp al, 0x0
    je .print_exit
    int 0x10
    inc si
    jmp .chars
.print_exit:
    popa
    ret
        
