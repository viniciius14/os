[bits 32]

[global _stage2_32]

[extern _load_kernel]
[extern print_string_32]

%ifdef BITS64
[extern _stage2_64]
%endif

%include "macros.S"

section _stage2_32.text

_stage2_32:
    mov esp, kernel_stack + KERNEL_STACK_SIZE

    mov	ax, 0x10            ; set data segments to data selector (0x10)
	mov	ds, ax
	mov	ss, ax
	mov	es, ax

    mov esi, stage2msg2     ; Point ESI to the string
    mov ebx, 160            ; Start at the top-left corner of the screen

    call print_string_32

%ifdef BITS64
;     jmp/call _stage2_64        ; switch to long mode
%endif

    jmp _load_kernel

    unreachable

section .data

stage2msg2: db "Got to stage 2 of the bootloader. (32 bits)", 0

section .bss

KERNEL_STACK_SIZE equ 4096                  ; size of stack in bytes

section .bss
align 16                                    ; align at 16 bytes
kernel_stack:                               ; label points to beginning of memory
    resb KERNEL_STACK_SIZE                  ; reserve stack for the kernel