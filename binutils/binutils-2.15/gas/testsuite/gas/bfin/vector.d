#objdump: -dr
#name: vector
.*: +file format .*
Disassembly of section .text:

00000000 <add_on_sign>:
   0:	0c c4 0d 09 	r4.h = r4.l = sign \(r1.h\) \* r5.h \+ sign\(r1.l\) \* r5.l;

00000004 <vit_max>:
   4:	09 c6 15 8e 	r7.l = vit_max\(r5, r2\);
   8:	09 c6 30 c0 	r0.l = vit_max\(r0, r6\) \(asr\);
   c:	09 c6 03 0a 	r5.l = vit_max\(r3\);
  10:	09 c6 02 44 	r2.l = vit_max\(r2\) \(asr\);

00000014 <vector_abs>:
  14:	06 c4 28 8a 	r5 = abs r5 \(v\);
  18:	06 c4 00 84 	r2 = abs r0 \(v\);

0000001c <vector_add_sub>:
  1c:	00 c4 1a 0a 	r5 = r3 \+|\+ r2 \(ns\);
  20:	00 c4 1a 3a 	r5 = r3 \+|\+ r2 \(sco\);
  24:	00 c4 06 8e 	r7 = r0 -|\+ r6 \(ns\);
  28:	00 c4 0b a4 	r2 = r1 -|\+ r3 \(s\);
  2c:	00 c4 02 48 	r4 = r0 \+|- r2 \(ns\);
  30:	00 c4 0a 5a 	r5 = r1 \+|- r2 \(co\);
  34:	00 c4 1c cc 	r6 = r3 -|- r4 \(ns\);
  38:	00 c4 2e de 	r7 = r5 -|- r6 \(co\);
  3c:	01 c4 63 bf 	r5 = r4 \+|\+ r3, r7 = r4 -|- r3 \(sco, asr\);
  40:	01 c4 1e c2 	r0 = r3 \+|\+ r6, r1 = r3 -|- r6 \(s, asl\);
  44:	21 c4 ca 2d 	r7 = r1 \+|- r2, r6 = r1 -|\+ r2 \(s\);
  48:	21 c4 53 0a 	r1 = r2 \+|- r3, r5 = r2 -|\+ r3 \(s\);
  4c:	04 c4 41 8d 	r5 = r1 \+ r0, r1 - r0 \(ns\);
  50:	04 c4 39 a6 	r0 = r1 \+ r7, r1 - r7 \(s\);
  54:	11 c4 c0 0b 	r7 = a1 \+ a0, r5 = a1 - a0 \(ns\);
  58:	11 c4 c0 6c 	r3 = a0 \+ a1, r6 = a0 - a1 \(s\);

0000005c <vector_ashift>:
  5c:	81 c6 83 03 	r1 = r3 >>> 0xffffffd0 \(v\);
  60:	81 c6 e0 09 	r4 = r0 >>> 0xffffffc4 \(v\);
  64:	81 c6 00 4a 	r5 = r0 << 0x0 \(v, s\);
  68:	81 c6 62 44 	r2 = r2 << 0xc \(v, s\);
  6c:	01 c6 15 0e 	r7 = ashift r5 by r2.l \(v\);
  70:	01 c6 02 40 	r0 = ashift r2 by r0.l \(v, s\);

00000074 <vector_lshift>:
  74:	81 c6 8a 8b 	r5 = r2 >>> 0xffffffcf \(v\);
  78:	81 c6 11 00 	r0 = r1 << 0x2 \(v\);
  7c:	01 c6 11 88 	r4 = lshift r1 by r2.l \(v\);

00000080 <vector_max>:
  80:	06 c4 01 0c 	r6 = max \(r0, r1\) \(v\);

00000084 <vector_min>:
  84:	06 c4 17 40 	r0 = min \(r2, r7\) \(v\);

00000088 <vector_mul>:
  88:	04 c2 be 66 	r2.h = r7.l \* r6.h, r2.l = r7.h \* r6.h;
  8c:	04 c2 08 e1 	r4.h = r1.h \* r0.h, r4.l = r1.l \* r0.l;
  90:	04 c2 1a a0 	r0.h = r3.h \* r2.l, r0.l = r3.l \* r2.l;
  94:	94 c2 5a e1 	r5.h = r3.h \* r2.h \(m\), r5.l = r3.l \* r2.l \(fu\);
  98:	2c c2 27 e0 	r1 = r4.h \* r7.h, r0 = r4.l \* r7.l \(s2rnd\);
  9c:	0c c2 95 27 	r7 = r2.l \* r5.l, r6 = r2.h \* r5.h;
  a0:	24 c3 3e e0 	r0.h = r7.h \* r6.h, r0.l = r7.l \* r6.l \(iss2\);
  a4:	04 c3 c1 e0 	r3.h = r0.h \* r1.h, r3.l = r0.l \* r1.l \(is\);
  a8:	00 c0 13 46 	\(a1 = r2.l \* r3.h\), \(a0 = r2.h \* r3.h\);
  ac:	01 c0 08 c0 	\(a1 \+= r1.h \* r0.h\), \(a0 = r1.l \* r0.l\);
  b0:	60 c0 2f c8 	\(a1 = r5.h \* r7.h\), \(a0 \+= r5.l \* r7.l\) \(w32\);
  b4:	01 c1 01 c0 	\(a1 \+= r0.h \* r1.h\), \(a0 = r0.l \* r1.l\) \(is\);
  b8:	90 c0 1c c8 	\(a1 = r3.h \* r4.h\) \(m\), \(a0 \+= r3.l \* r4.l\) \(fu\);
  bc:	01 c0 24 96 	\(a1 \+= r4.h \* r4.l\), \(a0 -= r4.h \* r4.h\);
  c0:	25 c1 3e e8 	r0.h = \(a1 \+= r7.h \* r6.h\), r0.l = \(a0 \+= r7.l \* r6.l\) \(iss2\);
  c4:	27 c0 81 28 	r2.h = a1, r2.l = \(a0 \+= r0.l \* r1.l\) \(s2rnd\);
  c8:	04 c0 d1 c9 	r7.h = \(a1 = r2.h \* r1.h\), \(a0 \+= r2.l \* r1.l\);
  cc:	04 c0 be 66 	r2.h = \(a1 = r7.l \* r6.h\), r2.l = \(a0 = r7.h \* r6.h\);
  d0:	05 c0 9b e1 	r6.h = \(a1 \+= r3.h \* r3.h\), r6.l = \(a0 = r3.l \* r3.l\);
  d4:	05 c0 f5 a7 	r7.h = \(a1 \+= r6.h \* r5.l\), r7.l = \(a0 = r6.h \* r5.h\);
  d8:	14 c0 3c a8 	r0.h = \(a1 = r7.h \* r4.l\) \(m\), r0.l = \(a0 \+= r7.l \* r4.l\);
  dc:	94 c0 5a e9 	r5.h = \(a1 = r3.h \* r2.h\) \(m\), r5.l = \(a0 \+= r3.l \* r2.l\) \(fu\);
  e0:	05 c1 1a e0 	r0.h = \(a1 \+= r3.h \* r2.h\), r0.l = \(a0 = r3.l \* r2.l\) \(is\);
  e4:	1c c0 b7 d0 	r3 = \(a1 = r6.h \* r7.h\) \(m\), \(a0 -= r6.l \* r7.l\);
  e8:	1c c0 3c 2e 	r1 = \(a1 = r7.l \* r4.l\) \(m\), r0 = \(a0 \+= r7.h \* r4.h\);
  ec:	2d c1 3e e8 	r1 = \(a1 \+= r7.h \* r6.h\), r0 = \(a0 \+= r7.l \* r6.l\) \(iss2\);
  f0:	0d c0 37 e1 	r5 = \(a1 \+= r6.h \* r7.h\), r4 = \(a0 = r6.l \* r7.l\);
  f4:	0d c0 9d f1 	r7 = \(a1 \+= r3.h \* r5.h\), r6 = \(a0 -= r3.l \* r5.l\);
  f8:	0e c0 37 c9 	r5 = \(a1 -= r6.h \* r7.h\), \(a0 \+= r6.l \* r7.l\);
  fc:	0c c0 b7 e0 	r3 = \(a1 = r6.h \* r7.h\), r2 = \(a0 = r6.l \* r7.l\);
 100:	9c c0 1f e9 	r5 = \(a1 = r3.h \* r7.h\) \(m\), r4 = \(a0 \+= r3.l \* r7.l\) \(fu\);
 104:	2f c0 81 28 	r3 = a1, r2 = \(a0 \+= r0.l \* r1.l\) \(s2rnd\);
 108:	0d c1 1a e0 	r1 = \(a1 \+= r3.h \* r2.h\), r0 = \(a0 = r3.l \* r2.l\) \(is\);

0000010c <vector_negate>:
 10c:	0f c4 08 c0 	r0 = -r1 \(v\);
 110:	0f c4 10 ce 	r7 = -r2 \(v\);

00000114 <vector_pack>:
 114:	04 c6 08 8e 	r7 = pack\(r0.h, r1.l\);
 118:	04 c6 31 cc 	r6 = pack\(r1.h, r6.h\);
 11c:	04 c6 12 4a 	r5 = pack\(r2.l, r2.h\);

00000120 <vector_search>:
 120:	0d c4 10 82 	\(r0, r1\) = search r2 \(lt\);
 124:	0d c4 80 cf 	\(r6, r7\) = search r0 \(le\);
 128:	0d c4 c8 0c 	\(r3, r6\) = search r1 \(gt\);
 12c:	0d c4 18 4b 	\(r4, r5\) = search r3 \(ge\);
