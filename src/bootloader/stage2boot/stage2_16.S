[bits 16]
[org 0x7E00]
; [global _stage2_16]
; [extern _stage2_32]

section .text

_stage2_16:
    cli

    xor ax, ax                  ; null segments
    mov ds, ax
    mov es, ax

    mov si, stage2msg1
    call puts

    pusha                       ; save registers
    lgdt [GDT_Descriptor]       ; load GDT
    popa                        ; restore registers

    mov eax, cr0                ; set bit 0 in cr0
    or  eax, 1
    mov cr0, eax

    in al, 0x92                 ; Enable A20 gate
    or al, 0x02
    out 0x92, al

    CODE_SEG equ code_descriptor - GDT_Start
    DATA_SEG equ data_descriptor - GDT_Start

    jmp CODE_SEG:EOF

    unreachable

%include "macros.S"
%include "print_string.S"

section .data

stage2msg1: db "Got to stage 2 of the bootloader. (16 bits)", ENDL

GDT_Start:
    null_descriptor:
        dd  0
        dd  0
    code_descriptor:
        dw 0xffff
        dw 0                    ; 16 bits +
        db 0                    ; 8 bits = 24
        db 0b10011010           ; type flags
        db 0b11001111           ; other flags
        db 0                    ; last 8 bits of base
    data_descriptor:
        dw 0xffff
        dw 0
        db 0
        db 0b10010010
        db 0b11001111
        db 0
GDT_End:

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1  ; size
    dd GDT_Start                ; start

EOF:
