OBJS=Initialization.o ISRs.o main.o
SRCS=$(SRCS:%.o=%.c)

CROSS_COMPILE = bfin-elf-
CC = $(CROSS_COMPILE)gcc
LDR = $(CROSS_COMPILE)ldr

CPU = bf537
CFLAGS ?= -g
CFLAGS += -mcpu=$(CPU)
CFLAGS += -Wall
LDRFLAGS = --bits 16 --dma 8 --bmode para

all: blink.ldr

%.ldr: %
	$(LDR) -T $(CPU) -c $(LDRFLAGS) $@ $^

load: blink.ldr
	$(LDR) -l $< /dev/ttyS0

blink: $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)

clean:
	rm -f blink *.o *.i *.s

.PHONY: all clean load
