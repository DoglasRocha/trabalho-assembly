trabalho: $(wildcard *.asm)
	nasm -f elf64 trabalho.asm
	ld -o trabalho trabalho.o -lc
	rm *.o