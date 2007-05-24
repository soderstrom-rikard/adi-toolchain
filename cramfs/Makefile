CC ?= gcc
CFLAGS ?= -O2 -g
CFLAGS += -W -Wall
CPPFLAGS += -I.
CPPFLAGS += -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE
LDLIBS = -lz
PROGS = mkcramfs cramfsck

ENDIAN := $(shell ./detectendian.sh)
ifeq ($(ENDIAN),)
$(error unable to detect endianness)
endif
CPPFLAGS += $(ENDIAN)

all: $(PROGS)

distclean clean:
	rm -f $(PROGS) *.o */*.o

.PHONY: all clean

GNULIB = $(patsubst %.c,%.o,$(wildcard gnulib/*.c))
gnulib/%.o: CPPFLAGS += -Ignulib
mkcramfs: $(GNULIB)
