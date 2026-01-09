#ifndef IDT_H
#define IDT_H

#include <stdint.h>

struct idt_entry_struct {
	uint16_t    isr_low;      // The lower 16 bits of the ISR's address
	uint16_t    kernel_cs;    // The GDT segment selector that the CPU will load into CS before calling the ISR
	uint8_t     reserved;     // Set to zero
	uint8_t     attributes;   // Type and attributes; see the IDT page
	uint16_t    isr_high;     // The higher 16 bits of the ISR's address
} __attribute__((packed));

typedef struct idt_entry_struct idt_entry_t;

__attribute__((aligned(0x10))) 
extern idt_entry_t idt[256]; // Create an array of IDT entries; aligned for performance

struct idtr {
    uint16_t limit;      // One less than the size of the IDT in bytes
    uint32_t base;
} __attribute__((packed));

typedef struct idtr idtr_t;

#endif