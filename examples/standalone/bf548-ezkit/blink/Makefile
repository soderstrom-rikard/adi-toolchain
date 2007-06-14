CROSS = bfin-elf-
CC = $(CROSS)gcc
LDR = $(CROSS)ldr
CFLAGS ?= -g -O2
CFLAGS += -Wall
CPPFLAGS += -D__ADSPBF548__

all: blink.ldr

blink.ldr: blink
	$(LDR) -f -T BF548 -c $@ $<

load: blink.ldr
	$(LDR) -l $< /dev/ttyS0

clean:
	rm -f *.o blink blink.ldr

.PHONY: all clean load
