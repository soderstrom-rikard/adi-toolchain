OBJS=main.o
SRCS=$(SRCS:%.o=%.c)
CFLAGS=-g

all: blink

.c.o:
	bfin-elf-gcc -c -mcpu=bf561 $(CFLAGS) $< -o $@

blink: $(OBJS)
	bfin-elf-gcc -o $@ -mcpu=bf561 $(OBJS)

clean:
	rm -f blink *.o *.i *.s
