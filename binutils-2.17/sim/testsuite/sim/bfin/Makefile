# Simple makefile for local tests

SRCS = $(wildcard *.[sS])
SIM  = $(SRCS:=.x)
HOST = $(SRCS:=.X)

all: sim host

sim: $(SIM)
host: $(HOST)

FLAGS = -g -o $@ $<

DO_SIM = bfin-elf-gcc -msim $(FLAGS) -nostdlib
%.s.x: %.s ; $(DO_SIM)
%.S.x: %.S ; $(DO_SIM)

DO_HOST = bfin-linux-uclibc-gcc -Wa,--defsym,BFIN_HOST=1 $(FLAGS) -static
%.s.X: %.s ; $(DO_HOST)
%.S.X: %.S ; $(DO_HOST)

clean:
	rm -f *.[xX] *.o

.PHONY: all clean
