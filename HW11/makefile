# Makefile for hw11translate2Ascii

all: hw11translate2Ascii

hw11translate2Ascii: hw11translate2Ascii.o
	ld -m elf_i386 -o hw11translate2Ascii hw11translate2Ascii.o

hw11translate2Ascii.o: hw11translate2Ascii.asm
	nasm -f elf32 -o hw11translate2Ascii.o hw11translate2Ascii.asm

clean:
	rm -f hw11translate2Ascii hw11translate2Ascii.o