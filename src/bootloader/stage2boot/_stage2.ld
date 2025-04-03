ENTRY(_stage2_32)
OUTPUT_FORMAT(elf32-i386)

SECTIONS {
    . = START_ADDRESS;

    .text : {
        *(_stage2_32.text)
        *(.text)
    } : text

    .data : {
        *(.data)
    } : data

    .rodata : {
        *(.rodata)
    } : rodata

    .bss : {
        *(.bss)
    } : bss
}

PHDRS {
    text   PT_LOAD FLAGS(5);  /* R-X (Read + Execute) */
    data   PT_LOAD FLAGS(6);  /* RW- (Read + Write)   */
    rodata PT_LOAD FLAGS(4);  /* R-- (Read)           */
    bss    PT_LOAD FLAGS(6);  /* RW- (Read + Write)   */
}
