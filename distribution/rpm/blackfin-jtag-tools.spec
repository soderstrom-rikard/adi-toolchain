#%define __os_install_post %{nil}
%define extra_buildtoolchain_opts %{nil}

Name:         blackfin-jtag-tools
URL:          http://blackfin.uclinux.org
Version:      09r1.1
Release:      2
Summary:      gdbproxy for the Blackfin
License:      GPL
Group:        Compilers
Source:       buildscript-jtag.tar.bz2
Source1:      gdbproxy.tar.bz2
Source2:      jtag.tar.bz2
Source3:      libftdi.tar.bz2
Patch:		jtag.diff
prefix: /opt/uClinux
BuildRoot:    %{_tmppath}/%{name}-%{version}-build

%description
This contains gdbproxy binaries to go with the Blackfin toolchains.

%prep
%setup -b 1 -b 2 -b 3
cd ..
%patch -p0

%build
echo $RPM_BUILD_ROOT
./BuildToolChain %{extra_buildtoolchain_opts} -s `pwd`/.. -o %{prefix}/bfin

%install
echo Installing in $RPM_BUILD_ROOT
rm -rf $RPM_BUILD_ROOT/opt
mkdir -p $RPM_BUILD_ROOT%{prefix}

cp -a %{prefix} $RPM_BUILD_ROOT/opt/
./find-duplicates.sh  $RPM_BUILD_ROOT%{prefix}/bfin-elf/ $RPM_BUILD_ROOT%{prefix}/bfin-uclinux/ bfin-elf bfin-uclinux
./find-duplicates.sh  $RPM_BUILD_ROOT%{prefix}/bfin-linux-uclibc/ $RPM_BUILD_ROOT%{prefix}/bfin-uclinux/ bfin-linux-uclibc bfin-uclinux

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{prefix}/bfin-uclinux/share/
%{prefix}/bfin-uclinux/bin/

%{prefix}/bfin-linux-uclibc/share/
%{prefix}/bfin-linux-uclibc/bin/

%{prefix}/bfin-elf/share/
%{prefix}/bfin-elf/bin/

%changelog -n blackfin-jtag-tools

