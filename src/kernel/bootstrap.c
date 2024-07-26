/*
 * Kernel bootstrap
 * loaction in memory: 0x1000
 * function : calls kernel_entry
 */

/* this will start executing by default
 * [FAIL] this causes a bootloop?
void kernel_bootstrap() {
    __asm__ inline(
        "jmp kernel_entry;"
        "hlt;");
}
*/

__asm__(
    "kenrel_bootstrap:;"
    "jmp kernel_entry;");

/* include kernel files here */
#include "entry.c"
