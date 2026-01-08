#include "gdt.h"

// We need 5 entries eventually (Null, Kernel Code, Kernel Data, User Code, User Data)
// For now, let's start with 3 (Null, Kernel Code, Kernel Data)
gdt_entry_t gdt_entries[3];
gdt_ptr_t   gdt_ptr;

// Helper function to pack the nasty bits into the structure
void gdt_set_gate(int32_t num, uint32_t base, uint32_t limit, uint8_t access, uint8_t gran) {
    // 1. Set the Base Address
    gdt_entries[num].base_low    = (base & 0xFFFF);
    gdt_entries[num].base_middle = (base >> 16) & 0xFF;
    gdt_entries[num].base_high   = (base >> 24) & 0xFF;

    // 2. Set the Limit
    gdt_entries[num].limit_low   = (limit & 0xFFFF);
    
    // 3. Set Granularity and High Limit bits
    // The "granularity" byte contains the high 4 bits of the limit AND the flags.
    // We mask the limit to get the top 4 bits (0x0F) and OR it with the flags (gran).
    gdt_entries[num].granularity = (limit >> 16) & 0x0F;
    gdt_entries[num].granularity |= gran & 0xF0;

    // 4. Set Access Flags
    gdt_entries[num].access      = access;
}

// This will be defined in a new assembly file (gdt_flush.s) later
extern void gdt_flush(uint32_t);

void init_gdt(void) {
    // 1. Set the GDT limit and base
    gdt_ptr.limit = (sizeof(gdt_entry_t) * 3) - 1;
    gdt_ptr.base  = (uint32_t)&gdt_entries;

    // 2. Configure the 3 entries

    // Entry 0: NULL Descriptor (Required by CPU)
    // If we mess up memory and try to use segment 0, the CPU will throw an exception.
    gdt_set_gate(0, 0, 0, 0, 0);

    // Entry 1: Kernel Code Segment
    // Base: 0, Limit: 4GB, Access: 0x9A (Code, Ring 0), Gran: 0xCF
    gdt_set_gate(1, 0, 0xFFFFFFFF, 0x9A, 0xCF);

    // Entry 2: Kernel Data Segment
    // Base: 0, Limit: 4GB, Access: 0x92 (Data, Ring 0), Gran: 0xCF
    gdt_set_gate(2, 0, 0xFFFFFFFF, 0x92, 0xCF);

    // 3. Tell the CPU about our new table
    gdt_flush((uint32_t)&gdt_ptr);
}