
Name:         blackfin-toolchain-uclibc-full
URL:          http://blackfin.uclinux.org
Version:      09r1.1
Release:      2
Requires:     blackfin-toolchain
Summary:      Wide character libraries for the GNU toolchain for Blackfin
License:      GPL
Group:        Compilers
Source:       bfin-gcc-4.3.tar.bz2
Source1:      bfin-gcc-4.1.tar.bz2
Source2:      binutils.tar.bz2
Source3:      kbuild.tar.bz2
Source4:      full-buildscript.tar.bz2
Source5:      elf2flt.tar.bz2
Source6:      genext2fs.tar.bz2
Source7:      uboot.tar.bz2
Source8:      libdsp.tar.bz2
Source9:      cramfs-tools.tar.bz2
Source10:     uClibc.tar.bz2
Source11:     ldr-utils.tar.bz2
Source12:     fdpichdr.tar.bz2
Source13:     full-config
#Patch:        mkuboot.diff
prefix: /opt/uClinux
BuildRoot:    %{_tmppath}/%{name}-%{version}-build

%description
This contains a wide character based libc and other support libraries for the
gcc-4.1 based Blackfin toolchain.

%package gcc-4.3-addon
Requires: blackfin-toolchain-uclibc-full
Requires: blackfin-toolchain-gcc-4.3-addon
Group:        Compilers
License:      GPL
Summary: gcc-4.3 add-on for the Blackfin toolchain

%description gcc-4.3-addon
This contains a wide character based libc and other support libraries for the
gcc-4.3 based Blackfin toolchain.

%prep
%setup -b 1 -b 2 -b 3 -b 4 -b 5 -b 6 -b 7 -b 8 -b 9 -b 10 -b 11 -b 12
#%patch -p1
cd ..

%build
echo $RPM_BUILD_ROOT
./BuildToolChain -s `pwd`/.. -K `pwd`/../kbuild_output -u `pwd`/../u-boot-2008.10 -c 4.3 -c 4.1 -o %{prefix}/bfin -C %{SOURCE13}

%install
echo Installing in $RPM_BUILD_ROOT
rm -rf $RPM_BUILD_ROOT/opt
mkdir -p $RPM_BUILD_ROOT%{prefix}
(strip %{prefix}/bfin-elf/bin/* || true)
(strip %{prefix}/bfin-uclinux/bin/* || true)
(strip %{prefix}/bfin-linux-uclibc/bin/* || true)
(strip %{prefix}/bfin-elf/libexec/gcc/bfin-elf/4.3.3/cc1* || true)
(strip %{prefix}/bfin-uclinux/libexec/gcc/bfin-uclinux/4.3.3/cc1* || true)
(strip %{prefix}/bfin-linux-uclibc/libexec/gcc/bfin-linux-uclibc/4.3.3/cc1* || true)
(strip %{prefix}/bfin-elf/libexec/gcc/bfin-elf/4.1.2/cc1* || true)
(strip %{prefix}/bfin-uclinux/libexec/gcc/bfin-uclinux/4.1.2/cc1* || true)
(strip %{prefix}/bfin-linux-uclibc/libexec/gcc/bfin-linux-uclibc/4.1.2/cc1* || true)
FILES=`find %{prefix}/ -name 'crt*.o'`
(%{prefix}/bfin-elf/bin/bfin-elf-strip --strip-debug $FILES || true)

find %{prefix}/ -name crt1.o |xargs %{prefix}/bfin-elf/bin/bfin-elf-strip --strip-debug
cp -a %{prefix} $RPM_BUILD_ROOT/opt/
./find-duplicates.sh  $RPM_BUILD_ROOT%{prefix}/bfin-elf/ $RPM_BUILD_ROOT%{prefix}/bfin-uclinux/ bfin-elf bfin-uclinux
./find-duplicates.sh  $RPM_BUILD_ROOT%{prefix}/bfin-linux-uclibc/ $RPM_BUILD_ROOT%{prefix}/bfin-uclinux/ bfin-linux-uclibc bfin-uclinux

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/include/*
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/lib/*
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/runtime/*
%{prefix}/bfin-linux-uclibc/lib/gcc/bfin-linux-uclibc/4.1.2/*
%{prefix}/bfin-uclinux/bfin-uclinux/include/*
%{prefix}/bfin-uclinux/bfin-uclinux/lib/*
%{prefix}/bfin-uclinux/bfin-uclinux/runtime/*
%{prefix}/bfin-uclinux/lib/gcc/bfin-uclinux/4.1.2/*

%files gcc-4.3-addon
%{prefix}/bfin-linux-uclibc/lib/gcc/bfin-linux-uclibc/4.3.3/*
%{prefix}/bfin-uclinux/lib/gcc/bfin-uclinux/4.3.3/*


%changelog -n blackfin-toolchain-uclibc-wchar

