# Simple makefile for local tests

SRCS      = $(wildcard *.[csS])
SIM_SRCS  = $(SRCS)
SIM       = $(SIM_SRCS:=.x)
JTAG_SRCS = $(SIM_SRCS)
JTAG      = $(JTAG_SRCS:=.j)
HOST_SRCS = $(shell grep -L -e sim:.*operating $(SRCS))
HOST      = $(HOST_SRCS:=.X)

all: sim jtag host

sim: $(SIM)
jtag: $(JTAG)
host: $(HOST)

FLAGS = -g -o $@ $<

DO_SIM = bfin-elf-gcc -msim $(FLAGS) -nostdlib
SIM_C_ARGS = $(shell sed -n '/^\# cc:/s|.*cc:||p' $<)
%.c.x: %.c ; $(DO_SIM) $(SIM_C_ARGS)
%.s.x: %.s ; $(DO_SIM)
%.S.x: %.S ; $(DO_SIM)

DO_JTAG = $(DO_SIM) -Wa,--defsym,BFIN_JTAG=1
%.c.j: %.c ; $(DO_JTAG) $(SIM_C_ARGS)
%.s.j: %.s ; $(DO_JTAG)
%.S.j: %.S ; $(DO_JTAG)

DO_HOST = bfin-linux-uclibc-gcc -Wa,--defsym,BFIN_HOST=1 $(FLAGS) -static
%.c.X: %.c ; $(DO_HOST)
%.s.X: %.s ; $(DO_HOST)
%.S.X: %.S ; $(DO_HOST)

clean:
	rm -f *.[jxX] *.o

.PHONY: all clean
