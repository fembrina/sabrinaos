#ifndef GDT_H
#define GDT_H

#include <stdint.h>

struct gdt_entry_struct {
    uint16_t limit_low;     // The lower 16 bits of the limit
    uint16_t base_low;      // The lower 16 bits of the base
    uint8_t  base_middle;   // The next 8 bits of the base
    uint8_t  access;        // Access flags (kernel/user, code/data, etc.)
    uint8_t  granularity;   // Granularity + High 4 bits of the limit
    uint8_t  base_high;     // The last 8 bits of the base
} __attribute__((packed));

typedef struct gdt_entry_struct gdt_entry_t;

// This struct is what we will pass to the "lgdt" assembly instruction.
struct gdt_ptr_struct {
    uint16_t limit; // Size of the GDT table in bytes minus 1
    uint32_t base;  // The linear address of the first GDT entry
} __attribute__((packed));

typedef struct gdt_ptr_struct gdt_ptr_t;

// Function prototype to be implemented in gdt.c
void init_gdt(void);

#endif