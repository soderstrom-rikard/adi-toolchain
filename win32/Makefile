VERSION ?= SVN-$(SVN_REV)
SVN_REV = `svn info | awk '$$1 == "Revision:" { print $$NF }'`

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
	cp Prerequisites/DPInst-*.exe gnICE-drivers/DPInst.exe ; \
	cd gnICE-drivers ; \
	unzip -q ../Prerequisites/CDM*.zip ; \
	cd CDM*/ ; \
	rm -f */*.lib ; \
	mv amd64 i386 *.inf ../ ; \
	cd .. ; \
	rm -rf CDM*/ ; \
	tar xf ../Prerequisites/libusb-win32-device-bin-*.tar.gz ; \
	cd libusb-win32-device-bin-*/bin/ ; \
	chmod a-x *.dll *.sys ; \
	mv libusb0.dll libusb0.sys ../../i386/ ; \
	mv libusb0_x64.dll libusb0_x64.sys ../../amd64/ ; \
	cd ../.. ; \
	rm -rf libusb-win32-device-bin-* ; \
	patch --no-backup-if-mismatch -s -p0 < ftdi.patch ; \
	rm -f ftdi.patch ; \
	sed -r -i '/(^|[^\r])$$/s:$$:\r:' *.inf *.xml ; \
	cd .. ; \
	Prerequisites/driver-signing/sign.sh >/dev/null || : ; \
	zip -r -q gnICE-drivers.zip gnICE-drivers
