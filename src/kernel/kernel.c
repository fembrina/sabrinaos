/*
 * kernel.c - SabrinaOS Kernel
 * Copyright (C) 2026 fembrina
 * License: GPLv2
 */
#include <stdint.h>

volatile uint16_t* vga_buffer = (uint16_t*)0xB8000;

enum vga_color {
    VGA_COLOR_BLACK = 0,
    VGA_COLOR_BLUE = 1,
    VGA_COLOR_WHITE = 15,
};

uint16_t vga_entry(unsigned char uc, uint8_t color) {
    return (uint16_t) uc | (uint16_t) color << 8;
}

void kmain(void) {
    uint8_t color = 0;

    // Clear screen
    for(int i = 0; i < 80 * 25; i++) {
        vga_buffer[i] = vga_entry(' ', VGA_COLOR_WHITE | VGA_COLOR_BLUE << 4);
    }

    // Write "SabrinaOS"
    const char* str = "Welcome to SabrinaOS v0.1";
    int j = 0;
    while(str[j] != '\0') {
        vga_buffer[j] = vga_entry(str[j], VGA_COLOR_WHITE | color << 4);
        color++;
        j++;
    }
}
