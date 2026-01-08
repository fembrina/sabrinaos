global gdt_flush    ; Make this function visible to C

gdt_flush:
    ; 1. Get the pointer from the stack
    ; When C calls a function, it pushes arguments onto the stack.
    ; [esp] is the return address. [esp+4] is the first argument (our gdt_ptr).
    mov eax, [esp + 4]

    ; 2. Load the GDT
    ; This instruction tells the CPU: "Here is the new table."
    lgdt [eax]

    ; 3. Reload Data Segment Registers
    ; We set them to 0x10 (Offset of our Kernel Data Segment).
    mov ax, 0x10
    mov ds, ax      ; Data Segment
    mov es, ax      ; Extra Segment
    mov fs, ax      ; General Purpose Segment
    mov gs, ax      ; General Purpose Segment
    mov ss, ax      ; Stack Segment

    ; 4. Reload Code Segment (CS)
    ; We cannot simply "mov cs, 0x08". The CPU forbids it.
    ; We must perform a "Far Jump". This jumps to a new segment AND new address.
    ; Syntax: jmp <segment_selector>:<label>
    jmp 0x08:.flush

.flush:
    ret