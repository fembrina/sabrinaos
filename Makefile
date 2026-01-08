# --- Toolchain ---
AS = nasm
CC = gcc
LD = ld

# --- Directories ---
SRC_DIR = src
BUILD_DIR = build

# --- Flags ---
ASFLAGS = -felf32
CFLAGS = -m32 -ffreestanding -c \
         -fno-stack-protector -fno-pie -fno-pic \
         -mno-sse -mno-sse2 -mno-80387 -mno-mmx \
         -Wall -Wextra -Werror -Wfloat-equal -Wstrict-prototypes \
         -std=gnu99 -g
LDFLAGS = -m elf_i386 -T linker.ld

# --- Targets ---

# Default target
all: $(BUILD_DIR)/sabrinaOS.bin

# Linker Rule
# $^ = All dependencies (boot.o and kernel.o)
# $@ = The target file (sabrinaOS.bin)
$(BUILD_DIR)/sabrinaOS.bin: $(BUILD_DIR)/boot.o $(BUILD_DIR)/kernel.o $(BUILD_DIR)/gdt.o $(BUILD_DIR)/gdt_flush.o
	$(LD) $(LDFLAGS) -o $@ $^

# Assembly Rule
# $< = The first dependency (boot.s)
# @mkdir -p $(BUILD_DIR) = Create the build folder if it doesn't exist
$(BUILD_DIR)/boot.o: $(SRC_DIR)/boot/boot.s
	@mkdir -p $(BUILD_DIR)
	$(AS) $(ASFLAGS) $< -o $@

# Rule for GDT C file
$(BUILD_DIR)/gdt.o: $(SRC_DIR)/kernel/gdt.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $< -o $@

# Rule for GDT Assembly file
$(BUILD_DIR)/gdt_flush.o: $(SRC_DIR)/kernel/gdt_flush.s
	@mkdir -p $(BUILD_DIR)
	$(AS) $(ASFLAGS) $< -o $@

# C Compilation Rule
$(BUILD_DIR)/kernel.o: $(SRC_DIR)/kernel/kernel.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $< -o $@

# Clean Rule
# Just nuke the whole build directory
clean:
	rm -rf $(BUILD_DIR)

# Run Rule
run: $(BUILD_DIR)/sabrinaOS.bin
	qemu-system-i386 -kernel $(BUILD_DIR)/sabrinaOS.bin