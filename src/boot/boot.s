; boot.s - The Entry Point for SabrinaOS

; --- 1. Multiboot Header ---
MAGIC    equ 0x1BADB002
FLAGS    equ (1 << 0) | (1 << 1)
CHECKSUM equ -(MAGIC + FLAGS)

section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

; --- 2. Stack Reservation ---
section .bss
align 16
stack_bottom:
    resb 16384 ; 16KB
stack_top:

; --- 3. Entry Point ---
section .text
global _start
extern kmain

_start:
    ; Set up the stack
    mov esp, stack_top

    ; Enter the Kernel
    call kmain

    ; Safety Hang (if kmain returns)
    cli
.hang:
    hlt
    jmp .hang
