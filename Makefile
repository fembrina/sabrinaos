AS = nasm
CC = gcc
LD = ld

ASFLAGS = -felf32
CFLAGS = -m32 -ffreestanding -c -fno-stack-protector -fno-pie -fno-pic -mno-sse -mno-sse2 -mno-80387 -mno-mmx -Wall -Wextra -Werror -Wfloat-equal -Wstrict-prototypes -std=gnu99
LDFLAGS = -m elf_i386 -T linker.ld

all: sabrinaOS.bin

sabrinaOS.bin: boot.o kernel.o
	$(LD) $(LDFLAGS) -o sabrinaOS.bin boot.o kernel.o

# TELL MAKE TO LOOK IN src/boot/
boot.o: src/boot/boot.s
	$(AS) $(ASFLAGS) src/boot/boot.s -o boot.o

# TELL MAKE TO LOOK IN src/kernel/
kernel.o: src/kernel/kernel.c
	$(CC) $(CFLAGS) src/kernel/kernel.c -o kernel.o

clean:
	rm -f *.o sabrinaOS.bin
