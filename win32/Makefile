VERSION ?= SVN-$(SVN_REV)

NSIS_FLAGS += \
	-DPRODUCT_VERSION="$(VERSION)" \
	`test -d eclipse || echo -DSKIP_ECLIPSE`

all: gnICE-drivers.zip
	makensis $(NSIS_FLAGS) toolchain.nsi

gnICE-drivers.zip: Prerequisites/CDM*.zip Prerequisites/gnICE/*
	set -e ; \
	rm -rf gnICE-drivers ; \
	mkdir gnICE-drivers ; \
	cp Prerequisites/gnICE/* gnICE-drivers/ ; \
	cd gnICE-drivers ; \
	unzip -q ../Prerequisites/CDM*.zip ; \
	cd CDM*/ ; \
	mv amd64 i386 *.inf *.cat ../ ; \
	cd .. ; \
	rm -rf CDM*/ ; \
	patch -s -p0 < ftdi.patch ; \
	rm -f ftdi.patch ; \
	cd .. ; \
	zip -r -q gnICE-drivers.zip gnICE-drivers ; \
	rm -rf gnICE-drivers
