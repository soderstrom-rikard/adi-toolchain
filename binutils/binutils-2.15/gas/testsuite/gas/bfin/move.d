#objdump: -dr
#name: move
.*: +file format .*
Disassembly of section .text:

00000000 <move_register>:
   0:	38 31       	r7 = a0.x;
   2:	fb 32       	fp = b3;
   4:	35 36       	l2 = r5;
   6:	b2 34       	m2 = i2;
   8:	d8 39       	a1.w = usp;
   a:	06 31       	r0 = astat;
   c:	c9 31       	r1 = seqstat;
   e:	d2 31       	r2 = syscfg;
  10:	db 31       	r3 = reti;
  12:	e4 31       	r4 = retx;
  14:	ed 31       	r5 = retn;
  16:	f6 31       	r6 = rete;
  18:	3f 31       	r7 = rets;
  1a:	a8 33       	p5 = lc0;
  1c:	a3 33       	p4 = lc1;
  1e:	99 33       	p3 = lt0;
  20:	94 33       	p2 = lt1;
  22:	8a 33       	p1 = lb0;
  24:	85 33       	p0 = lb1;
  26:	b6 33       	sp = cycles;
  28:	bf 33       	fp = cycles2;
  2a:	20 e1 00 00 	r0 = 0x0 \(x\);
  2e:	31 3d       	cycles = a0.w;
  30:	7f 38       	rets = fp;
  32:	e0 3d       	lt1 = usp;
  34:	08 c4 00 c0 	a0 = a1;
  38:	08 c4 00 e0 	a1 = a0;
  3c:	09 c4 00 20 	a0 = r0;
  40:	09 c4 08 a0 	a1 = r1;

00000044 <move_conditional>:
  44:	6a 07       	if cc r5 = p2;
  46:	b0 06       	if !cc sp = r0;

00000048 <move_half_to_full_zero_extend>:
  48:	fa 42       	r2 = r7.l \(z\);
  4a:	c8 42       	r0 = r1.l \(z\);

0000004c <move_half_to_full_sign_extend>:
  4c:	8d 42       	r5 = r1.l \(x\);
  4e:	93 42       	r3 = r2.l \(x\);

00000050 <move_register_half>:
  50:	09 c4 28 40 	a0.x = r5.l;
  54:	09 c4 10 c0 	a1.x = r2.l;
  58:	0a c4 00 00 	r0.l = a0.x;
  5c:	0a c4 00 4e 	r7.l = a1.x;
  60:	09 c4 18 00 	a0.l = r3.l;
  64:	09 c4 20 80 	a1.l = r4.l;
  68:	29 c4 30 00 	a0.h = r6.h;
  6c:	29 c4 28 80 	a1.h = r5.h;
  70:	83 c1 00 38 	, r0.l = a0 \(iu\);
  74:	27 c0 40 18 	r1.h = a1,  \(s2rnd\);
  78:	07 c0 40 18 	r1.h = a1, ;
  7c:	67 c1 80 38 	r2.h = a1, r2.l = a0 \(ih\);
  80:	07 c0 80 38 	r2.h = a1, r2.l = a0;
  84:	47 c0 00 38 	r0.h = a1, r0.l = a0 \(iu\);
  88:	87 c0 00 38 	r0.h = a1, r0.l = a0 \(fu\);
  8c:	07 c1 00 38 	r0.h = a1, r0.l = a0 \(is\);
  90:	07 c0 00 38 	r0.h = a1, r0.l = a0;

00000094 <move_byte_zero_extend>:
  94:	57 43       	r7 = r2.b \(z\);
  96:	48 43       	r0 = r1.b \(z\);

00000098 <move_byte_sign_extend>:
  98:	4e 43       	r6 = r1.b \(z\);
  9a:	65 43       	r5 = r4.b \(z\);
  9c:	8b c0 00 39 	, r4 = a0 \(fu\);
  a0:	2f c1 00 19 	r5 = a1,  \(iss2\);
  a4:	0b c0 80 39 	, r6 = a0;
  a8:	0f c0 80 19 	r7 = a1, ;
  ac:	0f c0 80 39 	r7 = a1, r6 = a0;
  b0:	8f c0 00 38 	r1 = a1, r0 = a0 \(fu\);
