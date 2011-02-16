-------------------------------------------------------------------------------
             Open Source Blackfin Toolchain from Analog Devices, Inc.
-------------------------------------------------------------------------------

This is the unofficial official repository for binary Blackfin toolchains from
Analog Devices, Inc for Debian based systems.  The "unofficial" means we are
not recognized by any Debian distribution.  The "official" means this .deb's
are fully supported by the Blackfin team at the http://blackfin.uclinux.org/
website.

This README.txt is a "quick start" for Debian users.  For more install info
in general, please visit:
	http://docs.blackfin.uclinux.org/doku.php?id=toolchain:installing

To use this repository, you need to place the appropriate lines in your
/etc/apt/sources.list file or a file in /etc/apt/sources.list.d/.

If you wish to install released toolchains, then use:
	deb http://blackfin.uclinux.org/debian stable main

If you wish to install nightly builds of SVN trunk, then use:
	deb http://blackfin.uclinux.org/debian unstable main

You can have both packages installed at the same time without conflicts.  The
release will install into:
	/opt/uClinux/
while the nightly builds will install into:
	/opt/uClinux-SVN/

You will also probably want to grab our signing key and add it to your apt:
	# wget http://blackfin.uclinux.org/debian/apt.key
	# apt-key add apt.key

Note that while we label them "nightly builds", we obviously do not rebuild
the toolchain on nights were the toolchain SVN repository was not updated.
That would just be silly.

Once you've updated your apt configuration files, you should be able to do:
	# apt-get update
	# : For releases
	# apt-get install blackfin-toolchain-{elf,uclinux,linux-uclibc}
	# : For nightly builds:
	# apt-get install blackfin-toolchain-{elf,uclinux,linux-uclibc}-svn

If you have any problems, please seek help on the Toolchain forums:
	http://blackfin.uclinux.org/gf/project/toolchain/forum/?action=browseRedirect

At the moment, we only provide binaries for amd64 and i386.  Everyone else, you
have to build it yourself, sorry.
