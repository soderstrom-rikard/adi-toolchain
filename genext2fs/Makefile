all: build/Makefile
	$(MAKE) -C build

configure:
	./autogen.sh

build/Makefile: configure
	find . -type f -print0 | xargs -0 touch -r configure
	set -e; \
	rm -rf build; \
	mkdir build; \
	cd build; \
	../configure

clean:
	rm -rf build

.PHONY: all clean
