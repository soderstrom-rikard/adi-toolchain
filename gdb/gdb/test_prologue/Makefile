main: main.o func.o
	bfin-elf-gcc -o main main.o func.o
main.o : main.c
	bfin-elf-gcc -O0 -o main.o main.c
func.o : func.s
	bfin-elf-as func.s -o func.o
clean:
	rm -rf main main.o func.o
asm:
	bfin-elf-gcc -S -O0 -o func.s func.c
