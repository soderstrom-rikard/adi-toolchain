all: Packages.gz Packages.bz2 Packages

Packages: $(wildcard *.deb)
	dpkg-scanpackages -m . /dev/null dists/$(B)/main/binary-$(A)/ | sed 's:/\./:/:' > $@

Packages.gz: Packages
	gzip -9c < $< > $@

Packages.bz2: Packages
	bzip2 -9c < $< > $@
