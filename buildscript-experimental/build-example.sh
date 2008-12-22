#!/bin/sh

./toolchain-build -s /home/jie/blackfin-sources/toolchain/trunk/ -O /home/jie/installs/bfin-41-elf -b /home/jie/blackfin-sources/build41-elf -u /home/jie/blackfin-sources/u-boot/trunk/u-boot-2008.10/ -c 4.1 -t elf

./toolchain-build -s /home/jie/blackfin-sources/toolchain/trunk/ -O /home/jie/installs/bfin-43-elf -b /home/jie/blackfin-sources/build43-elf -u /home/jie/blackfin-sources/u-boot/trunk/u-boot-2008.10/ -c 4.3 -t elf

