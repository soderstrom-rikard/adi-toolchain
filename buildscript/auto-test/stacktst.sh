#!/bin/sh -x
# The two built binary can run on the kernel built by build_manual_kernel.exp fdpic, which also includes flat support.

#export PATH=/opt/uClinux/bfin-uclinux/bin:/opt/uClinux/bfin-elf/bin:/opt/uClinux/bfin-linux-uclibc/bin:$PATH
echo $PATH

bfin-uclinux-gcc -o stacktst.flat -mstack-check-l1 stacktst.c -Wl,-elf2flt

bfin-linux-uclibc-gcc -o stacktst.fdpic -mstack-check-l1 stacktst.c

rcp stacktst.flat root@10.100.4.50:/

rcp stacktst.fdpic root@10.100.4.50:/
