#define ROWS 25
#define COLS 80
#define IDT_SIZE 256
#define KERNEL_CODE_SEGMENT_OFFSET (0x8)
#define IDT_INTERRUPT_GATE_32BIT (0x8e)
#define PIC1_COMMAND_PORT (0x20)
#define PIC1_DATA_PORT (0x21)
#define PIC2_COMMAND_PORT (0xa0)
#define PIC2_DATA_PORT (0xa1)
#define KEYBOARD_DATA_PORT (0x60)
#define KEYBOARD_STATUS_PORT (0x64)

#include "keyboard_map.h"

struct IDT_pointer {
    unsigned short limit;
    unsigned int base;
} __attribute__((packed));

struct IDT_entry {
    unsigned short offset_lowerbits;
    unsigned short selector;
    unsigned char zero;
    unsigned char type_attr;
    unsigned short offset_upperbits;
} __attribute__((packed));

extern void print_char(char c, int row, int col);
extern void keyboard_handler();
extern void load_gdt();
// extern void load_idt(struct IDT_pointer *idt_add);
extern void load_idt(unsigned int *idt_add);
extern int ioport_in(unsigned short port);
extern int ioport_out(unsigned short port, unsigned char data);
extern void enable_intterupts();

int __stack_chk_fail_local() { return 1; };

/*CREATE IDT HERE */
struct IDT_entry IDT[IDT_SIZE];
int cursor_pos = 0;

void init_idt() {
    unsigned int offset = (unsigned int)keyboard_handler;
    IDT[0x21].offset_lowerbits =
        offset & 0x0000ffff;  // leave first 33 idt for cpu
    IDT[0x21].selector = KERNEL_CODE_SEGMENT_OFFSET;
    IDT[0x21].zero = 0;
    IDT[0x21].type_attr = IDT_INTERRUPT_GATE_32BIT;
    IDT[0x21].offset_upperbits = (offset & 0xffff0000) >> 16;

    // icw1
    ioport_out(PIC1_COMMAND_PORT, 0x11);
    ioport_out(PIC2_COMMAND_PORT, 0x11);
    // icw2
    ioport_out(PIC1_COMMAND_PORT, 0x28);
    ioport_out(PIC2_COMMAND_PORT, 0x28);
    // icw3
    ioport_out(PIC1_COMMAND_PORT, 0x0);
    ioport_out(PIC1_COMMAND_PORT, 0x0);
    // icw4
    ioport_out(PIC1_COMMAND_PORT, 0xff);
    ioport_out(PIC1_COMMAND_PORT, 0xff);

    struct IDT_pointer idt_ptr;
    idt_ptr.limit = (sizeof(struct IDT_entry) * IDT_SIZE) - 1;
    idt_ptr.base = (unsigned int)&IDT;
    load_idt((unsigned int *)&idt_ptr);
}

void kb_init() {
    // 0xfd = 1111 1101
    ioport_out(PIC1_DATA_PORT, 0xfd);
}

void handle_keyboard_intterupts() {
    ioport_out(PIC1_COMMAND_PORT, 0x20);
    unsigned char staus = ioport_in(KEYBOARD_DATA_PORT);
    if (staus & 0x1) {
        char keycode = ioport_in(KEYBOARD_DATA_PORT);
        if (keycode < 0 || keycode > 128) return;
        print_char(keyboard_map[keycode], 0, cursor_pos);
        cursor_pos++;
    }
}

void print() {
    char *mem = (char *)0xb8000;

    *(char *)0xb8000 = 'x';
    *(char *)0xb8002 = 'x';

    char *string = "Kernel Loaded in osdev ............";
    volatile char *video = (volatile char *)0xB8000;
    while (*string != 0) {
        *video++ = *string++;
        *video++ = 0x07;
    }

    /*
    for (int i = 0; i < COLS; i++) {
        for (int j = 0; j < ROWS; j++) {
            print_char('*', j, i);
        }
    }
    */
}

void enable_intterupts2() {
    char *string = "start ====================================\n";
    volatile char *video = (volatile char *)0xB8000;
    while (*string != 0) {
        *video++ = *string++;
        *video++ = 0x07;
    }

    __asm__("sti");

    char *string3 = "sti ====================================\n";
    volatile char *video2 = (volatile char *)0xB8000;
    while (*string != 0) {
        *video++ = *string++;
        *video++ = 0x07;
    }
};

/* entry into Kernel */
void _start() {
    print();
    init_idt();
    kb_init();
    enable_intterupts();
    while (1);
}
