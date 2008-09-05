SERIAL_PORT = /dev/ttyUSB0
CROSS_COMPILE = bfin-elf-
CC = $(CROSS_COMPILE)gcc
LDR = $(CROSS_COMPILE)ldr
CPU = bf537
CFLAGS += -Wall -mcpu=$(CPU) -g
LDFLAGS += -mcpu=$(CPU) -T sdc-cplb-init.lds
LDRFLAGS += --initcode init.o

all: sdc-cplb-init.ldr

sdc-cplb-init: main.o external-memory.o cplb.o interrupts.o
	$(CC) $(LDFLAGS) $^ -o $@

sdc-cplb-init.ldr: init.o

%.ldr: %
	$(LDR) -T $(CPU) -c $(LDRFLAGS) $@ $<

sdc-cplb-init.ldr: sdc-cplb-init

load: sdc-cplb-init.ldr
	$(LDR) -l $< $(SERIAL_PORT)

clean:
	rm -f sdc-cplb-init sdc-cplb-init.ldr *.o

.PHONY: all clean load
