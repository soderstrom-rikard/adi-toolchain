# uClinux blackfin bfin-elf binutils, bfin-elf elf2flt, bfin-elf gcc

Summary: bfin-elf binary utilities (as, ld, nm, etc), bfin-elf gcc, bfin-elf elf2flt
Name: bfin-elf
Version: 3.4
Release: beta
Copyright: GPL
Group: uClinux
URL: http://www.blackfin.uclinux.org/
Distribution: uClinux/bfin-elf
Vendor: Rrap Software
Packager: http://www.rrap-software.com/

%define _unpackaged_files_terminate_build       0
%define _missing_doc_files_terminate_build      0
%define __os_install_post /usr/lib/rpm/brp-compress /usr/lib/rpm/redhat/brp-strip %{__strip} /usr/lib/rpm/redhat/brp-strip-comment-note %{__strip} %{__objdump} %{nil}

Source0: binutils-2.15-bf533-beta3.tar.gz
Source1: elf2flt-bf533-beta3.tar.gz
Source2: gcc-3.4-bf533-beta3.tar.gz

prefix: /opt/uClinux/bfin

BuildRoot: /var/tmp/%{name}-%{version}-root

%define DIR_BINUTILS_SOURCE $RPM_BUILD_DIR/%{name}-%{version}/binutils/binutils-2.15
%define DIR_ELF2FLT_SOURCE $RPM_BUILD_DIR/%{name}-%{version}/elf2flt
%define DIR_GCC_SOURCE  $RPM_BUILD_DIR/%{name}-%{version}/gcc-3.4
%define DIR_BINUTILS_BUILD $RPM_BUILD_DIR/%{name}-%{version}/binutils_build
%define DIR_ELF2FLT_BUILD  $RPM_BUILD_DIR/%{name}-%{version}/elf2flt_build

%description
The bfin-elf-gcc is a C cross compiler for Blackfin targets using the 
ELF file format. 
The bfin-elf-binutils is a collection of utilities required for the 
assembly, linking, symbol dumping, object dumping, object copying and 
other operations for position independant code on Blackfin targets
using the ELF file format. 

If you are using uClinux and will be building a kernel and user 
programs for a supported platform/architecture you will need to 
install this package.  Additional information may be found at 
www.blackfin.uclinux.org

%prep
%setup -c %{name}-%{version}
%setup -D -c %{name}-%{version} -T -a 1
%setup -D -c %{name}-%{version} -T -a 2

# set up link for gcc inside binutils
ln -snf %{DIR_GCC_SOURCE}/gcc %{DIR_BINUTILS_SOURCE}/
ln -snf %{DIR_GCC_SOURCE}/libstdc++-v3 %{DIR_BINUTILS_SOURCE}/
# need bfd.h from binutils for elf2flt build
cd %{DIR_BINUTILS_SOURCE}/include
ln -s %{DIR_BINUTILS_BUILD}/bfd/bfd.h .

%build
mkdir -p %{DIR_BINUTILS_BUILD}
cd %{DIR_BINUTILS_BUILD}

%{DIR_BINUTILS_SOURCE}/configure --prefix=%{prefix} --target=bfin-elf
make

# now build elf2flt
mkdir -p %{DIR_ELF2FLT_BUILD}
cd %{DIR_ELF2FLT_BUILD}

%{DIR_ELF2FLT_SOURCE}/configure  --target=bfin-elf --with-binutils-include-dir=%{DIR_BINUTILS_SOURCE}/include --with-bfd-include-dir=%{DIR_BINUTILS_BUILD}/bfd --with-libbfd=%{DIR_BINUTILS_BUILD}/bfd/libbfd.a --with-libiberty=%{prefix}/lib/libiberty.a --prefix=%{prefix} --program-suffix= 
make

%install
rm -rf $RPM_BUILD_ROOT

cd %{DIR_BINUTILS_BUILD}
make prefix=$RPM_BUILD_ROOT%{prefix} bindir=$RPM_BUILD_ROOT%{prefix}/bin libdir=$RPM_BUILD_ROOT%{prefix}/lib mandir=$RPM_BUILD_ROOT%{prefix}/man includedir=$RPM_BUILD_ROOT%{prefix}/include install

cd %{DIR_ELF2FLT_BUILD}
make prefix=$RPM_BUILD_ROOT%{prefix} bindir=$RPM_BUILD_ROOT%{prefix}/bin libdir=$RPM_BUILD_ROOT%{prefix}/lib mandir=$RPM_BUILD_ROOT%{prefix}/man includedir=$RPM_BUILD_ROOT%{prefix}/include install

%files
%attr(-,root,root) %{prefix}/bfin-elf/*
%attr(-,root,root) %{prefix}/bin/*
%doc %attr(-,root,root) %{prefix}/info/*
%attr(-,root,root) %{prefix}/lib/*
%doc %attr(-,root,root) %{prefix}/man/*
%attr(-,root,root) %{prefix}/share/*
%attr(-,root,root) %{prefix}/include/*
%attr(-,root,root) %{prefix}/libexec/*

%clean
rm -rf $RPM_BUILD_ROOT
