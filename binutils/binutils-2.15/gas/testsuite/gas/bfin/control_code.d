#objdump: -dr
#name: control_code
.*: +file format .*

Disassembly of section .text:

00000000 <compare_data_register>:
   0:	06 08       	cc = r6 == r0;
   2:	17 08       	cc = r7 == r2;
   4:	33 0c       	cc = r3 == -2;
   6:	88 08       	cc = r0 < r1;
   8:	a4 0c       	cc = r4 < -4;
   a:	2c 09       	cc = r4 <= r5;
   c:	1d 0d       	cc = r5 <= 0x3;
   e:	be 09       	cc = r6 < r7\(iu\);
  10:	a7 0d       	cc = r7 < 0x4\(iu\);
  12:	1d 0a       	cc = r5 <= r3\(iu\);
  14:	2a 0e       	cc = r2 <= 0x5\(iu\);

00000016 <compare_pointer>:
  16:	46 08       	cc = sp == p0;
  18:	47 0c       	cc = fp == 0x0;
  1a:	f7 08       	cc = fp < sp;
  1c:	a1 0c       	cc = r1 < -4;
  1e:	11 09       	cc = r1 <= r2;
  20:	1b 0d       	cc = r3 <= 0x3;
  22:	b5 09       	cc = r5 < r6\(iu\);
  24:	bf 0d       	cc = r7 < 0x7\(iu\);
  26:	08 0a       	cc = r0 <= r1\(iu\);
  28:	02 0e       	cc = r2 <= 0x0\(iu\);

0000002a <compare_accumulator>:
  2a:	80 0a       	cc = a0 == a1;
  2c:	00 0b       	cc = a0 < a1;
  2e:	80 0b       	cc = a0 <= a1;

00000030 <move_cc>:
  30:	00 02       	r0 = cc;
  32:	ac 03       	ac0 |= cc;
  34:	80 03       	az = cc;
  36:	81 03       	an = cc;
  38:	cd 03       	ac1 &= cc;
  3a:	f8 03       	v \^= cc;
  3c:	b9 03       	vs |= cc;
  3e:	90 03       	av0 = cc;
  40:	d2 03       	av1 &= cc;
  42:	93 03       	av1s = cc;
  44:	a6 03       	aq |= cc;
  46:	0c 02       	cc = r4;
  48:	00 03       	cc = az;
  4a:	21 03       	cc |= an;
  4c:	4c 03       	cc &= ac0;
  4e:	6d 03       	cc \^= ac1;
  50:	18 03       	cc = v;
  52:	39 03       	cc |= vs;
  54:	50 03       	cc &= av0;
  56:	72 03       	cc \^= av1;
  58:	13 03       	cc = av1s;
  5a:	26 03       	cc |= aq;

0000005c <negate_cc>:
  5c:	<807> Illegal opcode
18 02       	cc = !cc;
	...
