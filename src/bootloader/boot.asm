section .multiboot
    dd 0x1BADB002 ; magic
    dd 0x0 ; flags
    dd - (  0x1BADB002 + 0x0 ) ; Checksum
