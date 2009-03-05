CFLAGS ?= -O2 -g
CFLAGS += -Wall

PKG_CONFIG ?= pkg-config
LIBFTDI_LIBS = $(shell $(PKG_CONFIG) libftdi --libs || libftdi-config --libs)
LDLIBS += $(LIBFTDI_LIBS)

FLAGS_TO_PASS = CC="$(CC)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

SFX := $(shell env $(FLAGS_TO_PASS) ./get-sfx.sh)

all: gnice-reset$(SFX)

gnice-reset$(SFX): gnice-reset.o
	$(LINK.o) -o $@ $^ $(LDLIBS)

clean:
	rm -f *.o gnice-reset$(SFX)

DESTDIR ?=
prefix = /usr
bindir = $(prefix)/bin
install:
	install -D -m 755 gnice-reset $(DESTDIR)$(bindir)/gnice-reset

.PHONY: all clean install
