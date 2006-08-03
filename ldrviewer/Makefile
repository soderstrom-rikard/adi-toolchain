#
# Makefile for ldrviewer
#
# Licensed under the GPL-2, see the file COPYING in this dir
#

CFLAGS  += -Wall -Wextra
LDFLAGS += $(CFLAGS)

DESTDIR :=
PREFIX  := /usr
BINDIR  := $(PREFIX)/bin

all: ldrviewer

ldrviewer: ldrviewer.o ldr.o helpers.o

.depend: $(wildcard *.c *.h)
	$(CC) $(CPPFLAGS) -MM *.c > .depend

INSTALL := install -g 0 -o 0
install:
	$(INSTALL) -m 755 -d $(DESTDIR)$(BINDIR)
	$(INSTALL) -m 755 ldrviewer $(DESTDIR)$(BINDIR)

clean:
	rm -f *.o *.gdb *.elf ldrviewer

-include .depend

.PHONY: all clean install
