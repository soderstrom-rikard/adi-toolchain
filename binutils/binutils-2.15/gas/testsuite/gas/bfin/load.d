#objdump: -dr
#name: load
.*: +file format .*

Disassembly of section .text:

00000000 <load_immediate>:
   0:	17 e1 ff ff 	m3.l = ffff <load_data\+0xff29>;
   4:	1a e1 fe ff 	b2.l = fffe <load_data\+0xff28>;
   8:	0e e1 00 00 	sp.l = 0 <load_immediate>;
   c:	0f e1 dc fe 	fp.l = fedc <load_data\+0xfe06>;
  10:	40 e1 02 00 	r0.h = 2 <load_immediate\+0x2>;
  14:	4d e1 20 00 	p5.h = 20 <load_immediate\+0x20>;
  18:	52 e1 04 f2 	i2.h = f204 <load_data\+0xf12e>;
  1c:	59 e1 40 00 	b1.h = 40 <load_immediate\+0x40>;
  20:	5c e1 ff ff 	l0.h = ffff <load_data\+0xff29>;
  24:	8f e1 20 ff 	fp = ff20 <load_data\+0xfe4a> \(z\);
  28:	9e e1 20 00 	l2 = 20 <load_immediate\+0x20> \(z\);
  2c:	08 c4 00 00 	a0 = 0;
  30:	08 c4 00 40 	a1 = 0;
  34:	08 c4 00 80 	a1 = a0 = 0;
  38:	02 62       	r2 = -64 \(x\);
  3a:	20 e1 7f 00 	r0 = 0x7f \(x\);
  3e:	02 68       	p2 = 0x0 \(x\);
  40:	06 6b       	sp = -32 \(x\);
  42:	67 69       	fp = 0x2c \(x\);
  44:	3f e1 00 80 	l3 = -32768 \(x\);
  48:	36 e1 ff 7f 	m2 = 0x7fff \(x\);
  4c:	81 60       	r1 = 0x10 \(x\);

0000004e <load_pointer_register>:
  4e:	7e 91       	sp = \[fp\];
  50:	47 90       	fp = \[p0\+\+\];
  52:	f1 90       	p1 = \[sp--\];
  54:	96 af       	sp = \[p2 \+ 0x38\];
  56:	3b ac       	p3 = \[fp \+ 0x0\];
  58:	3c e5 ff 7f 	p4 = \[fp \+ 0x1fffc\];
  5c:	3e e5 01 80 	sp = \[fp \+ -131068\];
  60:	26 ac       	sp = \[p4 \+ 0x0\];
  62:	0d b8       	p5 = \[fp \+ -128\];

00000064 <load_data_register>:
  64:	07 91       	r7 = \[p0\];
  66:	2e 90       	r6 = \[p5\+\+\];
  68:	a5 90       	r5 = \[p4--\];
  6a:	bc a2       	r4 = \[fp \+ 0x28\];
  6c:	33 e4 ff 7f 	r3 = \[sp \+ 0x1fffc\];
  70:	32 a0       	r2 = \[sp \+ 0x0\];
  72:	39 e4 01 80 	r1 = \[fp \+ -131068\];
  76:	06 80       	r0 = \[sp \+\+ p0\];
  78:	05 b8       	r5 = \[fp \+ -128\];
  7a:	02 9d       	r2 = \[i0\];
  7c:	09 9c       	r1 = \[i1\+\+\];
  7e:	93 9c       	r3 = \[i2--\];
  80:	9c 9d       	r4 = \[i3\+\+m0\];

00000082 <load_half_word_zero_extend>:
  82:	37 95       	r7 = w \[sp\] \(z\);
  84:	3e 94       	r6 = w \[fp\+\+\] \(z\);
  86:	85 94       	r5 = w \[p0--\] \(z\);
  88:	cc a7       	r4 = w \[p1 \+ 0x1e\] \(z\);
  8a:	73 e4 fe 7f 	r3 = w \[sp \+ 0xfffc\] \(z\);
  8e:	7a e4 02 80 	r2 = w \[fp \+ -65532\] \(z\);
  92:	28 86       	r0 = w \[p0 \+\+ p5\] \(z\);

00000094 <load_half_word_sign_extend>:
  94:	77 95       	r7 = w \[sp\] \(x\);
  96:	7e 94       	r6 = w \[fp\+\+\] \(x\);
  98:	c5 94       	r5 = w \[p0--\] \(x\);
  9a:	0d ab       	p5 = w \[p1 \+ 0x18\] \(x\);
  9c:	73 e5 fe 7f 	r3 = w \[sp \+ 0xfffc\] \(x\);
  a0:	7f e5 02 80 	r7 = w \[fp \+ -65532\] \(x\);
  a4:	51 8e       	r1 = w \[p1 \+\+ p2\] \(x\);

000000a6 <load_high_data_register_half>:
  a6:	40 9d       	r0.h = w \[i0\];
  a8:	49 9c       	r1.h = w \[i1\+\+\];
  aa:	d2 9c       	r2.h = w \[i2--\];
  ac:	b3 85       	r6.h = w \[p3 \+\+ sp\];
  ae:	c4 85       	r7.h = w \[p4 \+\+ p0\];

000000b0 <load_low_data_register_half>:
  b0:	3f 9d       	r7.l = w \[i3\];
  b2:	36 9c       	r6.l = w \[i2\+\+\];
  b4:	ad 9c       	r5.l = w \[i1--\];
  b6:	04 82       	r0.l = w \[p4 \+\+ p0\];
  b8:	9b 82       	r2.l = w \[p3\];

000000ba <load_byte_zero_extend>:
  ba:	05 99       	r5 = b \[p0\] \(z\);
  bc:	0c 98       	r4 = b \[p1\+\+\] \(z\);
  be:	90 98       	r0 = b \[p2--\] \(z\);
  c0:	b3 e4 ff 7f 	r3 = b \[sp \+ 0x7fff\] \(z\);
  c4:	b7 e4 01 80 	r7 = b \[sp \+ -32767\] \(z\);

000000c8 <load_byte_sign_extend>:
  c8:	45 99       	r5 = b \[p0\] \(x\);
  ca:	4a 98       	r2 = b \[p1\+\+\] \(x\);
  cc:	fb 98       	r3 = b \[fp--\] \(x\);
  ce:	b7 e5 00 00 	r7 = b \[sp \+ 0x0\] \(x\);
  d2:	be e5 01 80 	r6 = b \[fp \+ -32767\] \(x\);

000000d6 <load_data>:
	...
