# Simple makefile for local tests

SRCS      = $(wildcard *.[csS])
SIM_SRCS  = $(SRCS)
SIM       = $(SIM_SRCS:=.x)
HOST_SRCS = $(shell grep -L -e sim:.*operating $(SRCS))
HOST      = $(HOST_SRCS:=.X)

all: sim host

sim: $(SIM)
host: $(HOST)

FLAGS = -g -o $@ $<

DO_SIM = bfin-elf-gcc -msim $(FLAGS) -nostdlib
%.c.x: %.c ; $(DO_SIM) $(shell sed -n '/^\# cc:/s|.*cc:||p' $<)
%.s.x: %.s ; $(DO_SIM)
%.S.x: %.S ; $(DO_SIM)

DO_HOST = bfin-linux-uclibc-gcc -Wa,--defsym,BFIN_HOST=1 $(FLAGS) -static
%.c.X: %.c ; $(DO_HOST)
%.s.X: %.s ; $(DO_HOST)
%.S.X: %.S ; $(DO_HOST)

clean:
	rm -f *.[xX] *.o

.PHONY: all clean
