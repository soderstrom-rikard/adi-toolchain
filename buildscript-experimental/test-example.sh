#!/bin/sh

./toolchain-regtest -s /home/jie/blackfin-sources/toolchain/trunk -O /home/jie/installs/bfin-41-elf -b /home/jie/blackfin-sources/build41-elf-test-jtag -t elf-jtag -v -a

./toolchain-regtest -s /home/jie/blackfin-sources/toolchain/trunk -O /home/jie/installs/bfin-43-elf -b /home/jie/blackfin-sources/build43-elf-test-jtag -t elf-jtag -v -a
