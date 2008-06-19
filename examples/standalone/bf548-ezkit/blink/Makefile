CROSS = bfin-elf-
CC = $(CROSS)gcc
LDR = $(CROSS)ldr
CPU = bf548
CFLAGS ?= -g -O2
CFLAGS += -mcpu=$(CPU)
CFLAGS += -Wall

all: blink.ldr

blink.ldr: blink
	$(LDR) -f -T $(CPU) -c $@ $<

load: blink.ldr
	$(LDR) -l $< /dev/ttyS0

clean:
	rm -f *.o blink blink.ldr

.PHONY: all clean load
