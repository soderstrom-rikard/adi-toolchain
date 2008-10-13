%define    enable_async_mode 0
Summary:   Library to program and control the FTDI USB controller
Name:      libftdi
Version:   0.14
Release:   1
License:   LGPL
Group:     System Environment/Libraries
Vendor:    Intra2net AG
Source:    %{name}-%{version}.tar.gz
Buildroot: /tmp/%{name}-%{version}-root
Requires:  libusb
BuildRequires: libusb, libusb-devel, pkgconfig, doxygen
Prefix:    /usr

%package   devel
Summary:   Header files and static libraries for libftdi
Group:     Development/Libraries
Requires:  libftdi = %{version}, libusb-devel

%description 
Library to program and control the FTDI USB controller

%description devel
Header files and static libraries for libftdi

%prep
%setup -q

%build

PARAMS=""
./configure --prefix=%{prefix} \
    --libdir=%{_libdir} \
%if %{enable_async_mode}
    --with-async-mode \
%endif

make

%install
make DESTDIR=$RPM_BUILD_ROOT install

# Cleanup
rm -f $RPM_BUILD_ROOT/usr/bin/simple
rm -f $RPM_BUILD_ROOT/usr/bin/bitbang
rm -f $RPM_BUILD_ROOT/usr/bin/bitbang2
rm -f $RPM_BUILD_ROOT/usr/bin/bitbang_ft2232
rm -f $RPM_BUILD_ROOT/usr/bin/bitbang_cbus
rm -f $RPM_BUILD_ROOT/usr/bin/find_all

%clean
rm -fr $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc COPYING.LIB
%{_libdir}/libftdi.so*

%files devel
%defattr(-,root,root)
%doc doc/html doc/man
%{_bindir}/libftdi-config
%{prefix}/include/*.h
%{_libdir}/libftdi.*a
%{_libdir}/pkgconfig/*.pc
