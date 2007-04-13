CC = gcc
CFLAGS = -W -Wall -O2 -g
CPPFLAGS = -I.
LDLIBS = -lz
PROGS = mkcramfs cramfsck

ENDIAN := $(shell ./detectendian.sh)
ifeq ($(ENDIAN),)
$(error unable to detect endianness)
endif
CPPFLAGS += $(ENDIAN)

all: $(PROGS)

distclean clean:
	rm -f $(PROGS)

.PHONY: all clean
