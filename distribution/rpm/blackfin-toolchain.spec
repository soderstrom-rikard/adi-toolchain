%define windows_build 0
%if %{windows_build}
%define mingw_prefix mingw32
%define __os_install_post %{nil}
%define bfin_host_strip %{mingw_prefix}-strip
%define bfin_targ_strip bfin-elf-strip
%define EXEEXT .exe
%define x_support 0
%define extra_buildtoolchain_opts -H %{mingw_prefix} -X
%else
%define bfin_host_strip strip
%define bfin_targ_strip %{prefix}/bfin-elf/bin/bfin-elf-strip
%define EXEEXT %{nil}
%define x_support 1
%define extra_buildtoolchain_opts %{nil}
%endif
%define skip_qemu 1

%define optional_gcc 0
%define gcc_main_ver 4.3
%define gcc_main_fullver %{gcc_main_ver}.5
%define gcc_addon_ver 4.5
%define gcc_addon_fullver %{gcc_addon_ver}.3

Name:         blackfin-toolchain
URL:          http://blackfin.uclinux.org
Version:      2013R1
Release:      RC1
Obsoletes:    bfin-gcc
Summary:      The GNU toolchain for the Blackfin processor
License:      GPL
Group:        Compilers
Source:       bfin-gcc-%{gcc_main_ver}.tar.bz2
Source1:      bfin-gcc-%{gcc_addon_ver}.tar.bz2
Source2:      binutils.tar.bz2
Source3:      kbuild.tar.bz2
Source4:      buildscript.tar.bz2
Source5:      elf2flt.tar.bz2
Source6:      uboot.tar.bz2
Source7:      libdsp.tar.bz2
Source8:      uClibc.tar.bz2
Source9:      ldr-utils.tar.bz2
Source10:     mpfr.tar.bz2
Source11:     gmp.tar.bz2
Source12:     libftdi.tar.bz2
Source13:     libusb.tar.bz2
Source14:     urjtag.tar.bz2
Source15:     gdbproxy.tar.bz2
Source16:     qemu.tar.bz2
Source17:     mpc.tar.bz2
Source18:     readline.tar.bz2
Source19:     cloog.tar.bz2
Source20:     ppl.tar.bz2
%if %{windows_build}
Source21:     expat-2.0.1.tar.bz2
Source22:     PDCurses-3.4.tar.gz
Source23:     pthreads-windows.tar.bz2
%endif
Patch:        jtag.diff
prefix:       /opt/uClinux
BuildRoot:    %{_tmppath}/%{name}-%{version}-build

%description
This contains the bfin-uclinux- (FLAT) and bfin-linux-uclibc- (FDPIC)
toolchains for the Blackfin processor, based around gcc-%{gcc_main_fullver}.
It also contains programs for working with JTAG.

%if %{optional_gcc}
%package gcc-%{gcc_addon_ver}-addon
Requires: blackfin-toolchain
Group:        Compilers
License:      GPL
Summary: gcc-%{gcc_addon_fullver} add-on for the Blackfin toolchain
%endif

%package elf-gcc-%{gcc_main_ver}
#Requires:
Group:        Compilers
License:      GPL
Summary: A bfin-elf toolchain based on gcc-%{gcc_main_fullver}.

%if %{optional_gcc}
%package elf-gcc-%{gcc_addon_ver}-addon
Requires: blackfin-toolchain blackfin-toolchain-elf-gcc-%{gcc_main_ver}
Group:        Compilers
License:      GPL
Summary: An add-on for the bfin-elf toolchain based on gcc-%{gcc_addon_fullver}.
%endif

%package uclibc-default
Requires: blackfin-toolchain
Group:        Compilers
License:      GPL
Summary: An add-on for the bfin-elf toolchain based on gcc-%{gcc_main_fullver}.

%if %{optional_gcc}
%package uclibc-default-gcc-%{gcc_addon_ver}-addon
Requires: blackfin-toolchain blackfin-toolchain-gcc-%{gcc_addon_ver}-addon
Group:        Compilers
License:      GPL
Summary: An add-on for the bfin-elf toolchain based on gcc-%{gcc_addon_fullver}.

%description gcc-%{gcc_addon_ver}-addon
This contains an additional gcc-%{gcc_addon_fullver} compiler for the Blackfin
processor.
%endif

%description elf-gcc-%{gcc_main_ver}
This contains a bfin-elf toolchain which is sometimes useful for simulator
testing and building standalone applications.  It is not necessary for
Linux development.  This package is based around gcc-%{gcc_main_fullver}.

%if %{optional_gcc}
%description elf-gcc-%{gcc_addon_ver}-addon
This contains an additional gcc-%{gcc_addon_fullver} compiler for the bfin-elf
toolchain package.
%endif

%description uclibc-default
This contains the default libraries for use with the Blackfin gcc-%{gcc_main_ver}
based toolchain.

%if %{optional_gcc}
%description uclibc-default-gcc-%{gcc_addon_ver}-addon
This contains additional default libraries for use with the Blackfin
gcc-%{gcc_addon_fullver} based toolchain.
%endif

%prep
%if %{windows_build}
%define windows_setup -a 21 -a 22 -a 23
%endif
%setup -q -c %{name}-%{version} -a 1 -a 2 -a 3 -a 4 -a 5 -a 6 -a 7 -a 8 -a 9 -a 10 -a 11 -a 12 -a 13 -a 14 -a 15 -a 16 -a 17 -a 18 -a 19 -a 20 %{windows_setup}
%patch -p0

%build
%if %{optional_gcc}
%define gcc_opts -c %{gcc_addon_ver} -c %{gcc_main_ver}
%else
%define gcc_opts -c %{gcc_main_ver}
%endif
%if %{skip_qemu}
%define gcc_build_opts %{gcc_opts} -S qemu
%else
%define gcc_build_opts %{gcc_opts}
%endif
%if %{windows_build}
%define gcc_build_opts %{gcc_build_opts} -S u-boot
%endif
echo Building in $RPM_BUILD_ROOT
./buildscript/BuildToolChain %{extra_buildtoolchain_opts} \
	-P ADI-%{version}-%{release} \
	-s `pwd` \
	-K `pwd`/kbuild_output \
	-u `pwd`/u-boot \
	%{gcc_build_opts} \
	-o %{prefix}/bfin

%install
echo Installing in $RPM_BUILD_ROOT
rm -rf $RPM_BUILD_ROOT/opt
mkdir -p $RPM_BUILD_ROOT%{prefix}
(%{bfin_host_strip} %{prefix}/bfin-elf/bin/* || true)
(%{bfin_host_strip} %{prefix}/bfin-uclinux/bin/* || true)
(%{bfin_host_strip} %{prefix}/bfin-linux-uclibc/bin/* || true)
%if %{optional_gcc}
(%{bfin_host_strip} %{prefix}/bfin-elf/libexec/gcc/bfin-elf/%{gcc_addon_fullver}/cc1* || true)
(%{bfin_host_strip} %{prefix}/bfin-uclinux/libexec/gcc/bfin-uclinux/%{gcc_addon_fullver}/cc1* || true)
(%{bfin_host_strip} %{prefix}/bfin-linux-uclibc/libexec/gcc/bfin-linux-uclibc/%{gcc_addon_fullver}/cc1* || true)
(%{bfin_host_strip} %{prefix}/bfin-elf/libexec/gcc/bfin-elf/%{gcc_addon_fullver}/f951* || true)
(%{bfin_host_strip} %{prefix}/bfin-uclinux/libexec/gcc/bfin-uclinux/%{gcc_addon_fullver}/f951* || true)
(%{bfin_host_strip} %{prefix}/bfin-linux-uclibc/libexec/gcc/bfin-linux-uclibc/%{gcc_addon_fullver}/f951* || true)
%endif
(%{bfin_host_strip} %{prefix}/bfin-elf/libexec/gcc/bfin-elf/%{gcc_main_fullver}/cc1* || true)
(%{bfin_host_strip} %{prefix}/bfin-uclinux/libexec/gcc/bfin-uclinux/%{gcc_main_fullver}/cc1* || true)
(%{bfin_host_strip} %{prefix}/bfin-linux-uclibc/libexec/gcc/bfin-linux-uclibc/%{gcc_main_fullver}/cc1* || true)
(%{bfin_host_strip} %{prefix}/bfin-elf/libexec/gcc/bfin-elf/%{gcc_main_fullver}/f951* || true)
(%{bfin_host_strip} %{prefix}/bfin-uclinux/libexec/gcc/bfin-uclinux/%{gcc_main_fullver}/f951* || true)
(%{bfin_host_strip} %{prefix}/bfin-linux-uclibc/libexec/gcc/bfin-linux-uclibc/%{gcc_main_fullver}/f951* || true)
FILES=`find %{prefix}/ -name 'crt*.o'`
(%{bfin_targ_strip} --strip-debug $FILES || true)

find %{prefix}/ -name crt1.o | xargs %{bfin_targ_strip} --strip-debug
cp -a %{prefix} $RPM_BUILD_ROOT/opt/
./buildscript/find-duplicates.sh  $RPM_BUILD_ROOT%{prefix}/bfin-elf/ $RPM_BUILD_ROOT%{prefix}/bfin-uclinux/ bfin-elf bfin-uclinux
./buildscript/find-duplicates.sh  $RPM_BUILD_ROOT%{prefix}/bfin-linux-uclibc/ $RPM_BUILD_ROOT%{prefix}/bfin-uclinux/ bfin-linux-uclibc bfin-uclinux

#for x in bf532-none/ bf532-0.3/ bf561-none/ bf561-0.2/; do
#  ./buildscript/find-duplicates.sh \
#     $RPM_BUILD_ROOT%{prefix}/bfin-uclinux/bfin-uclinux/runtime/usr/lib/$x \
#     $RPM_BUILD_ROOT%{prefix}/bfin-uclinux/bfin-uclinux/runtime/usr/lib/ \
#     $x ""
#  ./buildscript/find-duplicates.sh \
#     $RPM_BUILD_ROOT%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/runtime/usr/lib/$x \
#     $RPM_BUILD_ROOT%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/runtime/usr/lib/ \
#     $x ""
#done

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc %{prefix}/bfin-uclinux/info/*
%doc %{prefix}/bfin-uclinux/man/*
%doc %{prefix}/bfin-linux-uclibc/info/*
%doc %{prefix}/bfin-linux-uclibc/man/*
%{prefix}/bfin-uclinux/share/*
%{prefix}/bfin-uclinux/bin/bfin-bsdl2jtag%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-gdbproxy%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-jtag%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-addr2line%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-ar%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-as%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-c++%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-c++filt%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-cpp%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-elf2flt%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-flthdr%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-g++%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-gcc%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-*-%{gcc_main_fullver}%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-gccbug
%{prefix}/bfin-uclinux/bin/bfin-uclinux-gcov%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-gdb%{EXEEXT}
%if ! %{windows_build}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-gen_eth_addr%{EXEEXT}
%endif
%{prefix}/bfin-uclinux/bin/bfin-uclinux-gfortran%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-gdbtui%{EXEEXT}
%if %{x_support}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-insight%{EXEEXT}
%endif
%{prefix}/bfin-uclinux/bin/bfin-uclinux-ldr%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-ld%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-ld.real%{EXEEXT}
%if ! %{windows_build}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-mkimage%{EXEEXT}
%endif
%{prefix}/bfin-uclinux/bin/bfin-uclinux-nm%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-objcopy%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-objdump%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-ranlib%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-readelf%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-run%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-size%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-strings%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-strip%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-ldr%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-elfedit%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-ld.bfd%{EXEEXT}
%if ! %{skip_qemu}
%{prefix}/bfin-uclinux/bin/bfin-qemu%{EXEEXT}
%{prefix}/bfin-uclinux/bin/bfin-uclinux-qemu%{EXEEXT}
%{prefix}/bfin-uclinux/etc/qemu/target-x86_64.conf%{EXEEXT}
%endif

%{prefix}/bfin-uclinux/bfin-uclinux/bin/ar%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/as%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/c++%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/g++%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/elf2flt%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/flthdr%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/gcc%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/gfortran%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/objdump%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/ld%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/ld.real%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/nm%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/ranlib%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/strip%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/ld.bfd%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/bin/objcopy%{EXEEXT}
%{prefix}/bfin-uclinux/bfin-uclinux/share/info/bfd.info
%{prefix}/bfin-uclinux/bfin-uclinux/share/info/dir

#%{prefix}/bfin-uclinux/lib/*.a
%{prefix}/bfin-uclinux/libexec/gcc/bfin-uclinux/%{gcc_main_fullver}/*
%if %{x_support}
%{prefix}/bfin-uclinux/lib/*.sh
%{prefix}/bfin-uclinux/lib/insight1.0/*
%{prefix}/bfin-uclinux/lib/itcl3.2/*
%{prefix}/bfin-uclinux/lib/itk3.2/*
%endif

%{prefix}/bfin-linux-uclibc/share/*
%{prefix}/bfin-linux-uclibc/bin/bfin-bsdl2jtag%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-gdbproxy%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-jtag%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-addr2line%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-ar%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-as%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-c++%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-c++filt%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-cpp%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-g++%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-gcc%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-*-%{gcc_main_fullver}%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-gccbug
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-gcov%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-gdb%{EXEEXT}
%if ! %{windows_build}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-gen_eth_addr%{EXEEXT}
%endif
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-gfortran%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-gdbtui%{EXEEXT}
%if %{x_support}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-insight%{EXEEXT}
%endif
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-ld%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-ldconfig
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-ldr%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-ldd
%if ! %{windows_build}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-mkimage%{EXEEXT}
%endif
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-nm%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-objcopy%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-objdump%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-ranlib%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-readelf%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-run%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-size%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-strings%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-strip%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-ldr%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-elfedit%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-ld.bfd%{EXEEXT}
%if ! %{skip_qemu}
%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-qemu%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bin/bfin-qemu%{EXEEXT}
%{prefix}/bfin-linux-uclibc/etc/qemu/target-x86_64.conf%{EXEEXT}
%endif

%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/bin/ar%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/bin/as%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/bin/c++%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/bin/g++%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/bin/gcc%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/bin/gfortran%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/bin/objdump%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/bin/ld%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/bin/nm%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/bin/ranlib%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/bin/strip%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/bin/ld.bfd%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/bin/objcopy%{EXEEXT}
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/share/info/bfd.info
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/share/info/dir

#%{prefix}/bfin-linux-uclibc/lib/*.a
%{prefix}/bfin-linux-uclibc/libexec/gcc/bfin-linux-uclibc/%{gcc_main_fullver}/*
%if %{x_support}
%{prefix}/bfin-linux-uclibc/lib/*.sh
%{prefix}/bfin-linux-uclibc/lib/insight1.0/*
%{prefix}/bfin-linux-uclibc/lib/itcl3.2/*
%{prefix}/bfin-linux-uclibc/lib/itk3.2/*
%endif

%files elf-gcc-%{gcc_main_ver}
%defattr(-,root,root)
%doc %{prefix}/bfin-elf/info/*
%doc %{prefix}/bfin-elf/man/*
%{prefix}/bfin-elf/share/*
%{prefix}/bfin-elf/bin/bfin-bsdl2jtag%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-gdbproxy%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-jtag%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-addr2line%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-ar%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-as%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-c++%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-c++filt%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-cpp%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-elf2flt%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-flthdr%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-g++%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-gcc%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-*-%{gcc_main_fullver}%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-gccbug
%{prefix}/bfin-elf/bin/bfin-elf-gcov%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-gdb%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-gdbtui%{EXEEXT}
%if %{x_support}
%{prefix}/bfin-elf/bin/bfin-elf-insight%{EXEEXT}
%endif
%{prefix}/bfin-elf/bin/bfin-elf-ld%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-ld.real%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-ldr%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-nm%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-objcopy%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-objdump%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-ranlib%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-readelf%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-run%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-size%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-strings%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-strip%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-elfedit%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-elf-ld.bfd%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-ldr%{EXEEXT}
%if ! %{skip_qemu}
%{prefix}/bfin-elf/bin/bfin-elf-qemu%{EXEEXT}
%{prefix}/bfin-elf/bin/bfin-qemu%{EXEEXT}
%{prefix}/bfin-elf/etc/qemu/target-*
%endif

%{prefix}/bfin-elf/bfin-elf/lib/*
%{prefix}/bfin-elf/bfin-elf/include/*
%{prefix}/bfin-elf/bfin-elf/bin/ar%{EXEEXT}
%{prefix}/bfin-elf/bfin-elf/bin/as%{EXEEXT}
%{prefix}/bfin-elf/bfin-elf/bin/c++%{EXEEXT}
%{prefix}/bfin-elf/bfin-elf/bin/g++%{EXEEXT}
%{prefix}/bfin-elf/bfin-elf/bin/elf2flt%{EXEEXT}
%{prefix}/bfin-elf/bfin-elf/bin/flthdr%{EXEEXT}
%{prefix}/bfin-elf/bfin-elf/bin/gcc%{EXEEXT}
%{prefix}/bfin-elf/bfin-elf/bin/objdump%{EXEEXT}
%{prefix}/bfin-elf/bfin-elf/bin/ld%{EXEEXT}
%{prefix}/bfin-elf/bfin-elf/bin/ld.real%{EXEEXT}
%{prefix}/bfin-elf/bfin-elf/bin/nm%{EXEEXT}
%{prefix}/bfin-elf/bfin-elf/bin/ranlib%{EXEEXT}
%{prefix}/bfin-elf/bfin-elf/bin/strip%{EXEEXT}
%{prefix}/bfin-elf/bfin-elf/bin/ld.bfd%{EXEEXT}
%{prefix}/bfin-elf/bfin-elf/bin/objcopy%{EXEEXT}

#%{prefix}/bfin-elf/lib/*.a
%{prefix}/bfin-elf/lib/gcc/bfin-elf/%{gcc_main_fullver}
%{prefix}/bfin-elf/libexec/gcc/bfin-elf/%{gcc_main_fullver}
%if %{x_support}
%{prefix}/bfin-elf/lib/*.sh
%{prefix}/bfin-elf/lib/insight1.0/*
%{prefix}/bfin-elf/lib/itcl3.2/*
%{prefix}/bfin-elf/lib/itk3.2/*
%endif

%if %{optional_gcc}
%files gcc-%{gcc_addon_ver}-addon
%defattr(-,root,root)
%{prefix}/bfin-uclinux/bin/bfin-uclinux-*-%{gcc_addon_fullver}%{EXEEXT}
%{prefix}/bfin-uclinux/libexec/gcc/bfin-uclinux/%{gcc_addon_fullver}/*

%{prefix}/bfin-linux-uclibc/bin/bfin-linux-uclibc-*-%{gcc_addon_fullver}%{EXEEXT}
%{prefix}/bfin-linux-uclibc/libexec/gcc/bfin-linux-uclibc/%{gcc_addon_fullver}/*

%files elf-gcc-%{gcc_addon_ver}-addon
%defattr(-,root,root)
%{prefix}/bfin-elf/bin/bfin-elf-*-%{gcc_addon_fullver}%{EXEEXT}
%{prefix}/bfin-elf/lib/gcc/bfin-elf/%{gcc_addon_fullver}/*
%{prefix}/bfin-elf/libexec/gcc/bfin-elf/%{gcc_addon_fullver}/*
%endif

%files uclibc-default
%defattr(-,root,root)
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/include/*
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/lib/*
%{prefix}/bfin-linux-uclibc/bfin-linux-uclibc/runtime/*
%{prefix}/bfin-linux-uclibc/lib/gcc/bfin-linux-uclibc/%{gcc_main_fullver}/*
%{prefix}/bfin-uclinux/bfin-uclinux/include/*
%{prefix}/bfin-uclinux/bfin-uclinux/lib/*
%{prefix}/bfin-uclinux/bfin-uclinux/runtime/*
%{prefix}/bfin-uclinux/lib/gcc/bfin-uclinux/%{gcc_main_fullver}/*

%if %{optional_gcc}
%files uclibc-default-gcc-%{gcc_addon_ver}-addon
%defattr(-,root,root)
%{prefix}/bfin-linux-uclibc/lib/gcc/bfin-linux-uclibc/%{gcc_addon_fullver}/*
%{prefix}/bfin-uclinux/lib/gcc/bfin-uclinux/%{gcc_addon_fullver}/*
%endif


%changelog -n blackfin-toolchain

