CFLAGS ?= -O2 -g
CFLAGS += -Wall

PKG_CONFIG ?= pkg-config
LIBFTDI_LIBS = $(shell $(PKG_CONFIG) libftdi --libs || libftdi-config --libs)
LDLIBS += $(LIBFTDI_LIBS)

all: gnice-reset

clean:
	rm -f *.o gnice-reset

DESTDIR ?=
prefix = /usr
bindir = $(prefix)/bin
install:
	install -D -m 755 gnice-reset $(DESTDIR)$(bindir)/gnice-reset

.PHONY: all clean install
