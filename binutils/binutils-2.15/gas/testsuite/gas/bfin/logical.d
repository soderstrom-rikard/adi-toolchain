#objdump: -dr
#name: logical
.*: +file format .*

Disassembly of section .text:

00000000 <and>:
   0:	c8 55       	r7 = r0 & r1;
   2:	9b 54       	r2 = r3 & r3;
   4:	91 55       	r6 = r1 & r2;

00000006 <not>:
   6:	c8 43       	r0 = ~r1;
   8:	d1 43       	r1 = ~r2;
   a:	e3 43       	r3 = ~r4;
   c:	ec 43       	r4 = ~r5;

0000000e <or>:
   e:	08 56       	r0 = r0 | r1;
  10:	a3 56       	r2 = r3 | r4;
  12:	7e 57       	r5 = r6 | r7;

00000014 <xor>:
  14:	5d 59       	r5 = r5 \^ r3;
  16:	02 59       	r4 = r2 \^ r0;
  18:	01 58       	r0 = r1 \^ r0;

0000001a <bxor>:
  1a:	0b c6 00 4e 	r7.l = cc = bxor\(a0, r0\);
  1e:	0b c6 08 4e 	r7.l = cc = bxor\(a0, r1\);
  22:	0c c6 00 4a 	r5.l = cc = bxor\(a0, a1, cc\);
  26:	0c c6 00 48 	r4.l = cc = bxor\(a0, a1, cc\);

0000002a <bxorshift>:
  2a:	0b c6 38 06 	r3.l = cc = bxorshift\(a0, r7\);
  2e:	0b c6 10 04 	r2.l = cc = bxorshift\(a0, r2\);
  32:	0c c6 00 00 	r0.l = cc = bxorshift\(a0, a1, cc\);
  36:	0c c6 00 00 	r0.l = cc = bxorshift\(a0, a1, cc\);
	...
