#objdump: -dr
#name: cache
.*: +file format .*

Disassembly of section .text:

00000000 <prefetch>:
   0:	45 02       	prefetch \[p5\];
   2:	67 02       	prefetch \[fp\+\+\];
   4:	46 02       	prefetch \[sp\];

00000006 <flush>:
   6:	52 02       	flush \[p2\];
   8:	76 02       	flush \[sp\+\+\];

0000000a <flushinv>:
   a:	6c 02       	flushinv \[p4\+\+\];
   c:	4f 02       	flushinv \[fp\];

0000000e <iflush>:
   e:	5b 02       	iflush \[p3\];
  10:	7f 02       	iflush \[fp\+\+\];
	...
