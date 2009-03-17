#!/bin/sh -x

bfin-uclinux-gcc -S -mcsync-anomaly -O0 csynctc.c

mv  csynctc.s  csynctc.s.O0.$1 

bfin-uclinux-gcc -S -mcsync-anomaly -O1 csynctc.c

mv  csynctc.s  csynctc.s.O1.$1

bfin-uclinux-gcc -S -mcsync-anomaly -O2 csynctc.c

mv  csynctc.s  csynctc.s.O2.$1

bfin-uclinux-gcc -S -mcsync-anomaly -Os csynctc.c

mv  csynctc.s  csynctc.s.Os.$1


bfin-linux-uclibc-gcc -S -mcsync-anomaly -O0 csynctc.c

mv  csynctc.s  csynctc.s.O0.elf$1

bfin-linux-uclibc-gcc -S -mcsync-anomaly -O1 csynctc.c

mv  csynctc.s  csynctc.s.O1.elf$1

bfin-linux-uclibc-gcc -S -mcsync-anomaly -O2 csynctc.c

mv  csynctc.s  csynctc.s.O2.elf$1

bfin-linux-uclibc-gcc -S -mcsync-anomaly -Os csynctc.c

mv  csynctc.s  csynctc.s.Os.elf$1



