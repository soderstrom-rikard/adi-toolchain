%define _unpackaged_files_terminate_build 0
%define bfin_host_strip strip
%define bfin_targ_strip %{prefix}/bfin-elf/bin/bfin-elf-strip
%define EXEEXT %{nil}
%define x_support 0
%define extra_buildtoolchain_opts -a UCLIBC_HAS_IPV6=y -a UCLIBC_HAS_WCHAR=y -a UCLIBC_HAS_NFTW=y

%define optional_gcc 0
%define gcc_main_ver 4.3
%define gcc_main_fullver %{gcc_main_ver}.5
%define gcc_addon_ver 4.5
%define gcc_addon_fullver %{gcc_addon_ver}.3

Name:         blackfin-toolchain-uclibc-full
URL:          http://blackfin.uclinux.org
Version:      2012R1
Release:      BETA1
Requires:     blackfin-toolchain
Summary:      Wide character libraries for the GNU toolchain for the Blackfin processor
License:      GPL
Group:        Compilers
Source:       bfin-gcc-%{gcc_main_ver}.tar.bz2
%if %{optional_gcc}
Source1:      bfin-gcc-%{gcc_addon_ver}.tar.bz2
%endif
Source2:      binutils.tar.bz2
Source3:      kbuild.tar.bz2
Source4:      buildscript.tar.bz2
Source5:      elf2flt.tar.bz2
Source6:      uClibc.tar.bz2
Source7:      mpfr.tar.bz2
Source8:      gmp.tar.bz2
Source9:      cloog.tar.bz2
Source10:     ppl.tar.bz2
Source11:     libdsp.tar.bz2
Source12:     mpc.tar.bz2
prefix:       /opt/uClinux
BuildRoot:    %{_tmppath}/%{name}-%{version}-build

%description
This contains a wide character based libc and other support libraries for the
gcc-%{gcc_main_fullver} based Blackfin Linux toolchains.

%if %{optional_gcc}
%package gcc-%{gcc_addon_ver}-addon
Requires: blackfin-toolchain-uclibc-full
Requires: blackfin-toolchain-gcc-%{gcc_addon_ver}-addon
Group:        Compilers
License:      GPL
Summary: gcc-%{gcc_addon_fullver} add-on for the Blackfin toolchain

%description gcc-%{gcc_addon_ver}-addon
This contains a wide character based libc and other support libraries for the
gcc-%{gcc_addon_fullver} based Blackfin Linux toolchains.
%endif

%prep
%if %{optional_gcc}
%define extra_setup -a 1
%endif
%setup -q -c %{name}-%{version} %{extra_setup} -a 2 -a 3 -a 4 -a 5 -a 6 -a 7 -a 8 -a 9 -a 10 -a 11 -a 12

%build
%if %{optional_gcc}
%define gcc_build_opts -c %{gcc_addon_ver} -c %{gcc_main_ver}
%else
%define gcc_build_opts -c %{gcc_main_ver}
%endif
echo Building in $RPM_BUILD_ROOT
./buildscript/BuildToolChain %{extra_buildtoolchain_opts} \
	-P ADI-%{version}-%{release} \
	-s `pwd` \
	-K `pwd`/kbuild_output \
	%{gcc_build_opts} \
	-o %{prefix}/bfin \
	-S u-boot -S ldr -S jtag -S qemu -S gdbproxy -X

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
%endif
(%{bfin_host_strip} %{prefix}/bfin-elf/libexec/gcc/bfin-elf/%{gcc_main_fullver}/cc1* || true)
(%{bfin_host_strip} %{prefix}/bfin-uclinux/libexec/gcc/bfin-uclinux/%{gcc_main_fullver}/cc1* || true)
(%{bfin_host_strip} %{prefix}/bfin-linux-uclibc/libexec/gcc/bfin-linux-uclibc/%{gcc_main_fullver}/cc1* || true)
FILES=`find %{prefix}/ -name 'crt*.o'`
(%{bfin_targ_strip} --strip-debug $FILES || true)

find %{prefix}/ -name crt1.o | xargs %{bfin_targ_strip} --strip-debug
cp -a %{prefix} $RPM_BUILD_ROOT/opt/
./buildscript/find-duplicates.sh  $RPM_BUILD_ROOT%{prefix}/bfin-elf/ $RPM_BUILD_ROOT%{prefix}/bfin-uclinux/ bfin-elf bfin-uclinux
./buildscript/find-duplicates.sh  $RPM_BUILD_ROOT%{prefix}/bfin-linux-uclibc/ $RPM_BUILD_ROOT%{prefix}/bfin-uclinux/ bfin-linux-uclibc bfin-uclinux

%clean
rm -rf $RPM_BUILD_ROOT

%files
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
%files gcc-%{gcc_addon_ver}-addon
%defattr(-,root,root)
%{prefix}/bfin-linux-uclibc/lib/gcc/bfin-linux-uclibc/%{gcc_addon_fullver}/*
%{prefix}/bfin-uclinux/lib/gcc/bfin-uclinux/%{gcc_addon_fullver}/*
%endif


%changelog -n blackfin-toolchain-uclibc-wchar

