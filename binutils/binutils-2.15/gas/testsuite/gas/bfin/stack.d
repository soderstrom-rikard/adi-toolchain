#objdump: -dr
#name:stack
.*: +file format .*

Disassembly of section .text:

00000000 <push>:
   0:	7a 01       	\[--sp\] = syscfg;
   2:	70 01       	\[--sp\] = lc0;
   4:	47 01       	\[--sp\] = r7;
   6:	61 01       	\[--sp\] = a0.w;
   8:	76 01       	\[--sp\] = cycles;
   a:	5a 01       	\[--sp\] = b2;
   c:	55 01       	\[--sp\] = m1;
   e:	48 01       	\[--sp\] = p0;

00000010 <push_multiple>:
  10:	d0 05       	\[--sp\] = \(r7:2, p5:0\);
  12:	70 05       	\[--sp\] = \(r7:6\);
  14:	c2 04       	\[--sp\] = \(p5:2\);

00000016 <pop>:
  16:	38 01       	usp = \[sp\+\+\];
  18:	3b 01       	reti = \[sp\+\+\];
  1a:	10 01       	i0 = \[sp\+\+\];
  1c:	39 01       	seqstat = \[sp\+\+\];
  1e:	1e 01       	l2 = \[sp\+\+\];
  20:	35 90       	r5 = \[sp\+\+\];
  22:	77 90       	fp = \[sp\+\+\];

00000024 <pop_multiple>:
  24:	a8 05       	\(r7:5, p5:0\) = \[sp\+\+\];
  26:	30 05       	\(r7:6\) = \[sp\+\+\];
  28:	84 04       	\(p5:4\) = \[sp\+\+\];

0000002a <link>:
  2a:	00 e8 02 00 	link 0x8;
  2e:	00 e8 ff ff 	link 0x3fffc;
  32:	00 e8 01 80 	link 0x20004;

00000036 <unlink>:
  36:	01 e8 00 00 	unlink;
	...
