-------------------------------------------------------------------------------
             Open Source Blackfin Toolchain from Analog Devices, Inc.
-------------------------------------------------------------------------------

This README is designed to give you directions as to where to find more
information related to using the Open Source Blackfin Toolchain in Windows.

Please note that this toolchain is not meant to be used to compile the
uClinux-dist and/or the Linux kernel.  Windows has a wide variety of issues
which makes it unsuitable for building of such large projects:
    - incompetent case handling of filenames
    - not POSIX compliant
    - no native shells (and no, the DOS shell does not count)

If you wish to compile uClinux-dist and/or the Linux kernel while running
Windows, please use the CoLinux system that we provide:
    http://blackfin.uclinux.org/gf/project/bfin-colinux

Also, please keep in mind that this is just a toolchain for compiling code.  It
is certainly not an IDE, so do not expect some GUI system to help you edit code
or manage your projects.  If you want something like that, there are plenty of
options out there to satisfy you:
    - Eclipse: http://docs.blackfin.uclinux.org/doku.php?id=using_eclipse
    - Visual DSP++: http://www.analog.com/en/epProd/0,2878,VISUALDSPBF,00.html
    - Visual Studio: http://msdn.microsoft.com/vstudio/

For some examples on how to use this toolchain, please see this wiki page:
    http://docs.blackfin.uclinux.org/doku.php?id=toolchain:windows

For help using this toolchain, please use our toolchain forums:
    http://blackfin.uclinux.org/gf/project/toolchain/forum

You can find the release notes for our toolchain on our documentation wiki:
    http://docs.blackfin.uclinux.org/doku.php?id=toolchain_release_notes

For the source code used to build this Windows hosted toolchain, please visit
the toolchain project hosted on our website:
    http://blackfin.uclinux.org/gf/project/toolchain