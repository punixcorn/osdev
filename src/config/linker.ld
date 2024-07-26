ENTRY(kernel_entry)

SECTIONS
{
    .text 0x1000:
    {
        *(.text)
    }
}
