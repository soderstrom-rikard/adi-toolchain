#!/bin/sh -x
user=/home/test
uclinux_path=$user/work/cruise/checkouts/uclinux-dist
test_path=$user/toolchain

cd $test_path
cp $uclinux_path/romfs/bin/ping .
ls -l ping
bfin-uclinux-flthdr -p ping
bfin-uclinux-flthdr -z ping
ls -l ping 
#Copy to the kernel that is built by build_manul_kernel.exp flat_shared.
rcp ping root@10.100.4.50:/

#run /ping 10.100.4.174
#run ls -l /ping
# ls -l /bin/ping
# ping 10.100.4.174
# rm /bin/ping
# /ping 10.100.4.174
