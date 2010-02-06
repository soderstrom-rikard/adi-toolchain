Name:         blackfin-toolchain-snapshot
URL:          http://blackfin.uclinux.org
Version:      SVN
Release:      %{STAMP}
Summary:      The GNU toolchain for Blackfin processors
License:      GPL
Group:        Compilers

prefix:       /opt/uClinux-SVN
%define _rpmdir %(pwd)
BuildRoot:    %{_rpmdir}/BUILD

%define __check_files %{nil}
%define _build_name_fmt %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm

%description
Nightly builds from SVN trunk.  This was created on %{STAMP}.

%package elf
Group: Compilers
Summary: snapshot of the bfin-elf toolchain (bare metal ELF)
%description elf
Nightly builds from SVN trunk.  This was created on %{STAMP}.
This toolchain is used to build up Blackfin ELFs that will run with no
operating system (on the bare metal).
%files elf -f %(pwd)/.filelist-rpm.elf
%defattr(-,root,root)

%package uclinux
Group: Compilers
Summary: snapshot of the bfin-uclinux toolchain (FLAT under Linux)
%description uclinux
Nightly builds from SVN trunk.  This was created on %{STAMP}.
This toolchain is used to build up Blackfin FLAT files that will run
under the Linux operating system.
%files uclinux -f %(pwd)/.filelist-rpm.uclinux
%defattr(-,root,root)

%package linux-uclibc
Group: Compilers
Summary: snapshot of the bfin-linux-uclibc toolchain (FDPIC ELF under Linux)
%description linux-uclibc
Nightly builds from SVN trunk.  This was created on %{STAMP}.
This toolchain is used to build up Blackfin FDPIC ELFs that will run
under the Linux operating system.
%files linux-uclibc -f %(pwd)/.filelist-rpm.linux-uclibc
%defattr(-,root,root)
