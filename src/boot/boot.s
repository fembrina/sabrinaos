; SabrinaOS - A Hobby Kernel
; Copyright (C) 2026 fembrina
;
; This program is free software; you can redistribute it and/or
; modify it under the terms of the GNU General Public License
; as published by the Free Software Foundation; either version 2
; of the License, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
 
MAGIC    equ 0x1BADB002
FLAGS    equ (1 << 0) | (1 << 1)
CHECKSUM equ -(MAGIC + FLAGS)

section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

section .bss
align 16
stack_bottom:
    resb 16384 ; 16KB
stack_top:

section .text
global _start
extern kmain

_start:
    mov esp, stack_top
    call kmain

    cli
.hang:
    hlt
    jmp .hang
