#objdump: -dr
#name: shift
.*: +file format .*

Disassembly of section .text:

00000000 <add_with_shift>:
   0:	88 45       	p0 = \(p0 \+ p1\) << 1;
   2:	ea 45       	p2 = \(p2 \+ p5\) << 2;
   4:	4f 41       	r7 = \(r7 \+ r1\) << 2;
   6:	03 41       	r3 = \(r3 \+ r0\) << 1;

00000008 <shift_with_add>:
   8:	44 5f       	p5 = p4 \+ \(p0 << 2\);
   a:	0a 5c       	p0 = p2 \+ \(p1 << 1\);

0000000c <arithmetic_shift>:
   c:	83 c6 08 01 	a0 = a0 >>> 0x1f;
  10:	83 c6 f8 00 	a0 = a0 << 0x1f;
  14:	83 c6 00 10 	a1 = a1 << 0x0;
  18:	83 c6 00 12 	a1 = a1 << 0x0;
  1c:	82 c6 fd 4e 	r7 = r5 << 0x1f \(s\);
  20:	82 c6 52 07 	r3 = r2 >>> 0x16;
  24:	80 c6 7a 52 	r1.l = r2.h << 0xf \(s\);
  28:	80 c6 f2 2b 	r5.h = r2.l >>> 0x2;
  2c:	00 4f       	r0 <<= 0x0;
  2e:	f9 4d       	r1 >>>= 0x1f;
  30:	08 40       	r0 >>>= r1;
  32:	8a 40       	r2 <<= r1;
  34:	00 c6 14 16 	r3.l = ashift r4.l by r2.l;
  38:	00 c6 07 6e 	r7.h = ashift r7.h by r0.l \(s\);
  3c:	00 c6 07 6e 	r7.h = ashift r7.h by r0.l \(s\);
  40:	02 c6 15 0c 	r6 = ashift r5 by r2.l;
  44:	02 c6 0c 40 	r0 = ashift r4 by r1.l \(s\);
  48:	02 c6 1e 44 	r2 = ashift r6 by r3.l \(s\);
  4c:	03 c6 08 00 	a0 = ashift a0 by r1.l;
  50:	03 c6 00 10 	a1 = ashift a1 by r0.l;

00000054 <logical_shift>:
  54:	00 45       	p0 = p0 >> 1;
  56:	d1 44       	p1 = p2 >> 2;
  58:	c9 5a       	p3 = p1 \+ p1;
  5a:	6c 44       	p4 = p5 << 2;
  5c:	f8 4e       	r0 >>= 0x1f;
  5e:	ff 4f       	r7 <<= 0x1f;
  60:	80 c6 8a a3 	r1.h = r2.l >> 0xf;
  64:	80 c6 00 0e 	r7.l = r0.l << 0x0;
  68:	82 c6 0d 8b 	r5 = r5 >>> 0x1f;
  6c:	82 c6 60 80 	r0 = r0 << 0xc;
  70:	83 c6 f8 41 	a0 = a0 >> -1;
  74:	83 c6 00 00 	a0 = a0 << 0x0;
  78:	83 c6 f8 12 	a1 = a1 << 0x1f;
  7c:	83 c6 80 51 	a1 = a1 >> -16;
  80:	7d 40       	r5 >>= r7;
  82:	86 40       	r6 <<= r0;
  84:	00 c6 02 b2 	r1.h = lshift r2.h by r0.l;
  88:	00 c6 08 90 	r0.l = lshift r0.l by r1.l;
  8c:	00 c6 16 8e 	r7.l = lshift r6.l by r2.l;
  90:	02 c6 1c 8a 	r5 = lshift r4 by r3.l;
  94:	03 c6 30 40 	a0 = lshift a0 by r6.l;
  98:	03 c6 28 50 	a1 = lshift a1 by r5.l;

0000009c <rotate>:
  9c:	82 c6 07 cf 	r7 = rot r7 by -32;
  a0:	82 c6 0f cd 	r6 = rot r7 by -31;
  a4:	82 c6 ff ca 	r5 = rot r7 by 0x1f;
  a8:	82 c6 f7 c8 	r4 = rot r7 by 0x1e;
  ac:	83 c6 00 80 	a0 = rot a0 by 0x0;
  b0:	83 c6 50 80 	a0 = rot a0 by 0xa;
  b4:	83 c6 60 93 	a1 = rot a1 by -20;
  b8:	83 c6 00 93 	a1 = rot a1 by -32;
  bc:	03 c6 11 c0 	r0 = rot r1 by r2.l;
  c0:	03 c6 1c c0 	r0 = rot r4 by r3.l;
  c4:	03 c6 38 80 	a0 = rot a0 by r7.l;
  c8:	03 c6 30 90 	a1 = rot a1 by r6.l;
