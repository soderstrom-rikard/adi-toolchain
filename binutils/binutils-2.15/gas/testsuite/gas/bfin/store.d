#objdump: -dr
#name: store
.*: +file format .*

Disassembly of section .text:

00000000 <store_pointer_register>:
   0:	78 93       	\[fp\] = p0;
   2:	71 92       	\[sp\+\+\] = p1;
   4:	fd 92       	\[fp--\] = p5;
   6:	d6 bf       	\[p2 \+ 0x3c\] = sp;
   8:	28 e7 ff 7f 	\[p5 \+ 0x1fffc\] = p0;
   c:	3a bc       	\[fp \+ 0x0\] = p2;
   e:	19 ba       	\[fp \+ -124\] = p1;
  10:	08 ba       	\[fp \+ -128\] = p0;

00000012 <store_data_register>:
  12:	10 93       	\[p2\] = r0;
  14:	2a 92       	\[p5\+\+\] = r2;
  16:	bf 92       	\[fp--\] = r7;
  18:	b5 b3       	\[sp \+ 0x38\] = r5;
  1a:	33 e6 fc 3b 	\[sp \+ 0xeff0\] = r3;
  1e:	38 e6 01 c0 	\[fp \+ -65532\] = r0;
  22:	4f 88       	\[fp \+\+ p1\] = r1;
  24:	86 bb       	\[fp \+ -32\] = r6;
  26:	01 9f       	\[i0\] = r1;
  28:	12 9e       	\[i2\+\+\] = r2;
  2a:	9c 9e       	\[i3--\] = r4;
  2c:	8f 9f       	\[i1\+\+m0\] = r7;

0000002e <store_data_register_half>:
  2e:	5c 9f       	w \[i3\] = r4.h;
  30:	40 9e       	w \[i0\+\+\] = r0.h;
  32:	d7 9e       	w \[i2--\] = r7.h;
  34:	b6 8d       	w \[sp\] = r6.h;
  36:	07 8d       	w \[fp \+\+ p0\] = r4.h;

00000038 <store_low_data_register_half>:
  38:	20 9f       	w \[i0\] = r0.l;
  3a:	2f 9e       	w \[i1\+\+\] = r7.l;
  3c:	b1 9e       	w \[i2--\] = r1.l;
  3e:	b6 8a       	w \[sp\] = r2.l;
  40:	13 97       	w \[p2\] = r3;
  42:	1d 96       	w \[p3\+\+\] = r5;
  44:	bc 96       	w \[fp--\] = r4;
  46:	cf b7       	w \[p1 \+ 0x1e\] = r7;
  48:	56 e6 ff 7f 	w \[p2 \+ 0xfffe\] = r6;
  4c:	79 e6 98 a1 	w \[fp \+ -48336\] = r1;
  50:	56 8b       	w \[sp \+\+ p2\] = r5.l;

00000052 <store_byte>:
  52:	39 9b       	b \[fp\] = r1;
  54:	00 9a       	b \[p0\+\+\] = r0;
  56:	ba 9a       	b \[fp--\] = r2;
  58:	97 e6 19 00 	b \[p2 \+ 0x19\] = r7;
  5c:	be e6 01 80 	b \[fp \+ -32767\] = r6;
