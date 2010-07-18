VERSION ?= SVN-$(SVN_REV)
SVN_REV = `svn info | awk '$$1 == "Revision:" { print $$NF }'`

NSIS_FLAGS += \
	-DPRODUCT_VERSION="$(VERSION)" \
	`test -d eclipse || echo -DSKIP_ECLIPSE`

all: gnICE-drivers.zip
	makensis $(NSIS_FLAGS) toolchain.nsi

gnICE-drivers.zip: Prerequisites/CDM*.zip Prerequisites/gnICE/*
	set -ex ; \
	rm -rf gnICE-drivers ; \
	mkdir gnICE-drivers ; \
	cp Prerequisites/gnICE/* gnICE-drivers/ ; \
	cp Prerequisites/DPInst-*.exe gnICE-drivers/DPInst.exe ; \
	cd gnICE-drivers ; \
	unzip -q ../Prerequisites/CDM*.zip -d CDM ; \
	cd CDM*/ ; \
	rm -f */*.lib ; \
	mv amd64 i386 *.inf ../ ; \
	cd .. ; \
	rm -rf CDM*/ ; \
	cp ../Prerequisites/winusb/amd64/*.dll amd64/ ; \
	cp ../Prerequisites/winusb/x86/*.dll i386/ ; \
	patch --no-backup-if-mismatch -s -p0 < ftdi.patch ; \
	rm -f ftdi.patch ; \
	sed -r -i '/(^|[^\r])$$/s:$$:\r:' *.inf *.xml ; \
	cd .. ; \
	rm -f gnICE-drivers.zip ; \
	zip -r -q gnICE-drivers.zip gnICE-drivers
