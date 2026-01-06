# --- Toolchain ---
AS = nasm
CC = gcc
LD = ld

# --- Flags ---
# -felf32: Output 32-bit ELF format
ASFLAGS = -felf32

# CFLAGS Breakdown:
# -m32: Force 32-bit mode
# -ffreestanding: No standard library
# -fno-stack-protector: Don't insert canary checks (we have no libc yet)
# -fno-pie -fno-pic: Disable Position Independent Code (we need absolute addresses)
# -mno-sse -mno-mmx: Disable FPU (prevents crashes before FPU init)
# -Wall -Wextra -Werror: Strict warnings
CFLAGS = -m32 -ffreestanding -c \
         -fno-stack-protector -fno-pie -fno-pic \
         -mno-sse -mno-sse2 -mno-80387 -mno-mmx \
         -Wall -Wextra -Werror -Wfloat-equal -Wstrict-prototypes \
         -std=gnu99 -g

# LDFLAGS Breakdown:
# -m elf_i386: Link for 32-bit x86
# -T linker.ld: Use our specific memory map
LDFLAGS = -m elf_i386 -T linker.ld

# --- Targets ---

all: sabrinaOS.bin

sabrinaOS.bin: boot.o kernel.o
	$(LD) $(LDFLAGS) -o sabrinaOS.bin boot.o kernel.o

boot.o: boot.s
	$(AS) $(ASFLAGS) boot.s -o boot.o

kernel.o: kernel.c
	$(CC) $(CFLAGS) kernel.c -o kernel.o

clean:
	rm -f *.o sabrinaOS.bin

run: sabrinaOS.bin
	qemu-system-x86 -kernel sabrinaOS.bin
