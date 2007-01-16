all: build/Makefile
	$(MAKE) -C build

build/Makefile:
	touch *
	set -e; \
	rm -rf build; \
	mkdir build; \
	cd build; \
	../configure

clean:
	rm -rf build

.PHONY: all clean
