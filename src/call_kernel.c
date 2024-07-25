/*
 * Kernel bootstrap
 * loaction: 0x1000
 * the code below calls kernel_entry
 * which calls everything else in the kernel
 */

__asm__(
    "kenrel_bootstrap:;"
    "jmp kernel_entry;");

/* include kernel files here */
#include "kernel/init.c"
