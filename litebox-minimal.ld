/* Simplified LiteBox Linker Script for Newlib */
/* Minimal environment - no dynamic linking, no complex glibc features */

OUTPUT_FORMAT("elf64-x86-64")
OUTPUT_ARCH(i386:x86-64)
ENTRY(_do_start)

/*
 * Page Size (4 KB)
 */
PAGE_SIZE = 0x1000;


/* Program headers with proper permissions */
PHDRS
{
    text PT_LOAD FLAGS(5);    /* Read + Execute (no Write) */
    data PT_LOAD FLAGS(6);    /* Read + Write (no Execute) */
    stack PT_GNU_STACK FLAGS(6); /* Non-executable stack */
}

SECTIONS
{
    . = 0x400000;  /* Base address */
    
    /* Code section - read/execute only */
    .text : ALIGN(PAGE_SIZE) {
        /* Your crt0.o must be first */
        *crt0.o(.text .crt0)
        
        /* Then everything else */
        *(.text .text.*)
        *(.init)
        *(.fini)
        
        . = ALIGN(PAGE_SIZE);
        __text_end = .;
    } : text
    
    /* Read-only data section - separate from executable code */
    .rodata : ALIGN(PAGE_SIZE) {
        *(.rodata .rodata.*)
        *(.rodata1)
        /* String literals */
        *(.rodata.str1.1) *(.rodata.str1.8) *(.rodata.str1.4)
        *(.rodata.str2.1) *(.rodata.str2.2) *(.rodata.str2.4) *(.rodata.str2.8)
        *(.rodata.str4.1) *(.rodata.str4.4) *(.rodata.str4.8)
        *(.rodata.str8.1) *(.rodata.str8.2) *(.rodata.str8.4) *(.rodata.str8.8)
        . = ALIGN(PAGE_SIZE);
    } : data
    
    /* Newlib constructor support (minimal) */
    .init_array : ALIGN(PAGE_SIZE) {
        __init_array_start = .;
        KEEP(*(.init_array*))
        __init_array_end = .;
    } : data
    
    .fini_array : {
        __fini_array_start = .;
        KEEP(*(.fini_array*))
        __fini_array_end = .;
    } : data
    
    /* Initialized data */
    .data : ALIGN(PAGE_SIZE) {
        *(.data .data.*)
        *(.data1)
        . = ALIGN(8);
        _edata = .;
    } : data
    
    /* Uninitialized data */
    .bss : ALIGN(PAGE_SIZE) {
        __bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        . = ALIGN(8);
        __bss_end = .;
        . = ALIGN(PAGE_SIZE);
        . += PAGE_SIZE;
        _end = .;
    } : data

    /* Debug info (not loaded) */
    .debug_info 0 : { *(.debug_info) }
    .debug_line 0 : { *(.debug_line) }
    
    /* Discard unnecessary sections */
    /DISCARD/ : {
        *(.note.GNU-stack)
        *(.comment)
        *(.eh_frame*)      /* No exception handling needed */
        *(.gnu.hash)       /* No dynamic linking */
        *(.dynsym)         /* No dynamic symbols */
        *(.dynstr)         /* No dynamic strings */
    }
}
