#objdump: -dr
#name: arithmetic
.*: +file format .*

Disassembly of section .text:

00000000 <abs>:
   0:	10 c4 00 00 	a0 = abs a0;
   4:	10 c4 00 40 	a0 = abs a1;
   8:	30 c4 00 00 	a1 = abs a0;
   c:	30 c4 00 40 	a1 = abs a1;
  10:	10 c4 00 c0 	a1 = abs a1, a0 = abs a0;
  14:	07 c4 10 80 	r0 = abs r2;

00000018 <add>:
  18:	86 5b       	sp = sp \+ p0;
  1a:	96 5b       	sp = sp \+ p2;
  1c:	f9 5b       	fp = p1 \+ fp;
  1e:	d7 51       	r7 = r7 \+ r2;
  20:	86 51       	r6 = r6 \+ r0;
  22:	02 c4 10 a8 	r4.l = r2.h \+ r0.l \(s\);
  26:	22 c4 09 aa 	r5.h = r1.h \+ r1.l \(s\);
  2a:	02 c4 35 0c 	r6.l = r6.l \+ r5.l \(ns\);

0000002e <add_sub_prescale_down>:
  2e:	05 c4 01 98 	r4.l = r0 \+ r1 \(rnd20\);
  32:	25 c4 28 96 	r3.h = r5 \+ r0 \(rnd20\);
  36:	05 c4 3d d2 	r1.l = r7 - r5 \(rnd20\);

0000003a <add_sub_prescale_up>:
  3a:	05 c4 01 04 	r2.l = r0 \+ r1 \(rnd12\);
  3e:	25 c4 3e 0e 	r7.h = r7 \+ r6 \(rnd12\);
  42:	05 c4 1a 4a 	r5.l = r3 - r2 \(rnd12\);
  46:	25 c4 0a 44 	r2.h = r1 - r2 \(rnd12\);

0000004a <add_immediate>:
  4a:	05 66       	r5 \+= -64;
  4c:	fa 65       	r2 \+= 0x3f;
  4e:	60 9f       	i0 \+= 2;
  50:	63 9f       	i3 \+= 2;
  52:	6a 9f       	i2 \+= 4;
  54:	69 9f       	i1 \+= 4;
  56:	20 6c       	p0 \+= 0x4;
  58:	86 6c       	sp \+= 0x10;
  5a:	07 6f       	fp \+= -32;

0000005c <divide_primitive>:
  5c:	6b 42       	divs \(r3, r5\);
  5e:	2b 42       	divq \(r3, r5\);

00000060 <expadj>:
  60:	07 c6 25 0c 	r6.l = expadj\(r5, r4.l\);
  64:	07 c6 08 ca 	r5.l = expadj\(r0.h, r1.l\);
  68:	07 c6 2b 48 	r4.l = expadj\(r3, r5.l\) \(v\);

0000006c <max>:
  6c:	07 c4 2a 0c 	r6 = max \(r5, r2\);
  70:	07 c4 0b 00 	r0 = max \(r1, r3\);

00000074 <min>:
  74:	07 c4 13 4a 	r5 = min \(r2, r3\);
  78:	07 c4 38 48 	r4 = min \(r7, r0\);

0000007c <modify_decrement>:
  7c:	0b c4 00 c0 	a0 -= a1;
  80:	0b c4 00 e0 	a0 -= a1 \(w32\);
  84:	17 44       	fp -= p2;
  86:	06 44       	sp -= p0;
  88:	73 9e       	i3 -= m0;
  8a:	75 9e       	i1 -= m1;

0000008c <modify_increment>:
  8c:	0b c4 00 80 	a0 \+= a1;
  90:	0b c4 00 a0 	a0 \+= a1 \(w32\);
  94:	4e 45       	sp \+= p1 \(brev\);
  96:	7d 45       	p5 \+= fp \(brev\);
  98:	6a 9e       	i2 \+= m2;
  9a:	e0 9e       	i0 \+= m0 \(brev\);
  9c:	0b c4 00 0e 	r7 = \(a0 \+= a1\);
  a0:	0b c4 00 4c 	r6.l = \(a0 \+= a1\);
  a4:	2b c4 00 40 	r0.h = \(a0 \+= a1\);

000000a8 <multiply16>:
  a8:	00 c2 0a 24 	, r0.l = r1.h \* r2.l;
  ac:	20 c2 68 26 	, r1.l = r5.h \* r0.h \(s2rnd\);
  b0:	80 c2 db 23 	, r7.l = r3.l \* r3.h \(fu\);
  b4:	28 c3 15 27 	, r4 = r2.h \* r5.h \(iss2\);
  b8:	08 c3 0b 20 	, r0 = r1.l \* r3.l \(is\);
  bc:	08 c2 a8 25 	, r6 = r5.h \* r0.l;
  c0:	94 c3 be 40 	r2.h = r7.l \* r6.h \(m\),  \(iu\);
  c4:	04 c2 e8 80 	r3.h = r5.h \* r0.l, ;
  c8:	14 c2 09 40 	r0.h = r1.l \* r1.h \(m\), ;
  cc:	1c c3 3e 80 	r1 = r7.h \* r6.l \(m\),  \(is\);
  d0:	0c c2 02 41 	r5 = r0.l \* r2.h, ;
  d4:	1c c2 b0 c0 	r3 = r6.h \* r0.h \(m\), ;

000000d8 <multiply32>:
  d8:	c4 40       	r4 \*= r0;
  da:	d7 40       	r7 \*= r2;

000000dc <multiply_accumulate>:
  dc:	63 c0 2f 02 	, \(a0 = r5.l \* r7.h\) \(w32\);
  e0:	03 c0 00 04 	, \(a0 = r0.h \* r0.l\);
  e4:	83 c0 13 0a 	, \(a0 \+= r2.l \* r3.h\) \(fu\);
  e8:	03 c0 21 0c 	, \(a0 \+= r4.h \* r1.l\);
  ec:	03 c1 3e 12 	, \(a0 -= r7.l \* r6.h\) \(is\);
  f0:	03 c0 2a 16 	, \(a0 -= r5.h \* r2.h\);
  f4:	10 c0 08 58 	\(a1 = r1.l \* r0.h\) \(m\), ;
  f8:	00 c0 10 98 	\(a1 = r2.h \* r0.l\), ;
  fc:	70 c0 3e 98 	\(a1 = r7.h \* r6.l\) \(m\),  \(w32\);
 100:	81 c0 1a 18 	\(a1 \+= r3.l \* r2.l\),  \(fu\);
 104:	01 c0 31 98 	\(a1 \+= r6.h \* r1.l\), ;
 108:	02 c1 03 58 	\(a1 -= r0.l \* r3.h\),  \(is\);
 10c:	02 c0 17 58 	\(a1 -= r2.l \* r7.h\), ;

00000110 <multiply_accumulate_half>:
 110:	03 c0 f5 25 	, r7.l = \(a0 = r6.h \* r5.l\);
 114:	c3 c0 0a 24 	, r0.l = \(a0 = r1.h \* r2.l\) \(tfu\);
 118:	03 c0 ac 28 	, r2.l = \(a0 \+= r5.l \* r4.l\);
 11c:	43 c0 fe 2e 	, r3.l = \(a0 \+= r7.h \* r6.h\) \(iu\);
 120:	03 c0 1a 36 	, r0.l = \(a0 -= r3.h \* r2.h\);
 124:	63 c1 6c 30 	, r1.l = \(a0 -= r5.l \* r4.l\) \(ih\);
 128:	04 c0 48 58 	r1.h = \(a1 = r1.l \* r0.h\), ;
 12c:	34 c1 83 98 	r2.h = \(a1 = r0.h \* r3.l\) \(m\),  \(iss2\);
 130:	05 c0 bf 59 	r6.h = \(a1 \+= r7.l \* r7.h\), ;
 134:	25 c0 d3 19 	r7.h = \(a1 \+= r2.l \* r3.l\),  \(s2rnd\);
 138:	06 c0 a2 d9 	r6.h = \(a1 -= r4.h \* r2.h\), ;
 13c:	d6 c0 5f 99 	r5.h = \(a1 -= r3.h \* r7.l\) \(m\),  \(tfu\);

00000140 <multiply_accumulate_data_reg>:
 140:	0b c0 0a 20 	, r0 = \(a0 = r1.l \* r2.l\);
 144:	0b c1 8a 20 	, r2 = \(a0 = r1.l \* r2.l\) \(is\);
 148:	0b c0 3e 2d 	, r4 = \(a0 \+= r7.h \* r6.l\);
 14c:	2b c0 ab 2b 	, r6 = \(a0 \+= r5.l \* r3.h\) \(s2rnd\);
 150:	0b c0 97 35 	, r6 = \(a0 -= r2.h \* r7.l\);
 154:	8b c0 06 33 	, r4 = \(a0 -= r0.l \* r6.h\) \(fu\);
 158:	0c c0 81 99 	r7 = \(a1 = r0.h \* r1.l\), ;
 15c:	9c c0 13 d9 	r5 = \(a1 = r2.h \* r3.h\) \(m\),  \(fu\);
 160:	0d c0 bd 18 	r3 = \(a1 \+= r7.l \* r5.l\), ;
 164:	2d c1 17 d8 	r1 = \(a1 \+= r2.h \* r7.h\),  \(iss2\);
 168:	0e c0 80 58 	r3 = \(a1 -= r0.l \* r0.h\), ;
 16c:	1e c1 17 59 	r5 = \(a1 -= r2.l \* r7.h\) \(m\),  \(is\);

00000170 <negate>:
 170:	85 43       	r5 = -r0;
 172:	0f c4 10 ee 	r7 = -r2 \(s\);
 176:	97 43       	r7 = -r2;
 178:	0e c4 00 00 	a0 = -a0;
 17c:	0e c4 00 40 	a1 = -a1;
 180:	2e c4 00 00 	a0 = -a0;
 184:	2e c4 00 40 	a1 = -a1;
 188:	0e c4 00 c0 	a1 = -a1;

0000018c <round_half>:
 18c:	0c c4 18 ca 	r5.l = r3 \(rnd\);
 190:	2c c4 00 cc 	r6.h = r0 \(rnd\);

00000194 <saturate>:
 194:	08 c4 00 20 	a0 = a0 \(s\);
 198:	08 c4 00 60 	a1 = a1 \(s\);
 19c:	08 c4 00 a0 	a1 = a1 \(s\), a0 = a0 \(s\);

000001a0 <signbits>:
 1a0:	05 c6 00 0a 	r0.l = signbits r0;
 1a4:	05 c6 07 80 	r7.l = signbits r7.h;
 1a8:	06 c6 00 06 	r0.l = signbits a0;
 1ac:	06 c6 00 4e 	r0.l = signbits a1;

000001b0 <subtract>:
 1b0:	43 53       	r5 = r3 - r0;
 1b2:	c7 53       	r7 = r7 - r0;
 1b4:	ca 52       	r3 = r2 - r1;
 1b6:	03 c4 37 ea 	r5.l = r6.h - r7.h \(s\);
 1ba:	23 c4 1b 40 	r0.h = r3.l - r3.h \(ns\);

000001be <subtract_immediate>:
 1be:	66 9f       	i2 -= 2;
 1c0:	6c 9f       	i0 -= 4;
	...
