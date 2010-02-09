# Simple makefile for local tests

SRCS = $(wildcard *.[sS])
SIM  = $(SRCS:=.x)
HOST = $(SRCS:=.X)

all: $(SIM) $(HOST)

FLAGS = -nostdlib -g -o $@ $<

DO_SIM = bfin-elf-gcc -msim $(FLAGS)
%.s.x: %.s ; $(DO_SIM)
%.S.x: %.S ; $(DO_SIM)

DO_HOST = bfin-linux-uclibc-gcc -Wa,--defsym,BFIN_HOST=1 $(FLAGS)
%.s.X: %.s ; $(DO_HOST)
%.S.X: %.S ; $(DO_HOST)

clean:
	rm -f *.[xX] *.o

.PHONY: all clean
