# Makefile for Hello World

EXEC = hello hello_debug

OBJS = hello.o 
CFLAGS += -O0 -dp -save-temps -g
LDLIBS += -lm

all: $(EXEC)

$(EXEC): $(OBJS)
	bfin-elf-gcc  $(LDFLAGS) -o hello hello.o $(LDLIBS)
	bfin-elf-gcc  $(LDFLAGS_ELF) -o hello_debug hello.o $(LDLIBS)
romfs:
	$(ROMFSINST) /bin/hello

clean:
	rm -f $(EXEC) *.gdb *.elf *.o
