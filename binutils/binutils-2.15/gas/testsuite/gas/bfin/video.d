#objdump: -dr
#name: video
.*: +file format .*

Disassembly of section .text:

00000000 <align>:
   0:	0d c6 15 0e 	r7 = align8 \(r5, r2\);
   4:	0d c6 08 4a 	r5 = align8 \(r0, r1\);
   8:	0d c6 05 84 	r2 = align8 \(r5, r0\);

0000000c <disalgnexcpt>:
   c:	12 c4 00 c0 	disalignexcpt;

00000010 <byteop3p>:
  10:	17 c4 0b 0a 	r5 = byteop3p\(r1:0x0, r3:0x2\) \(hi\);
  14:	37 c4 0b 00 	r0 = byteop3p\(r1:0x0, r3:0x2\) \(lo\);
  18:	17 c4 0b 22 	r1 = byteop3p\(r1:0x0, r3:0x2\) \(hi, r\);
  1c:	37 c4 0b 24 	r2 = byteop3p\(r1:0x0, r3:0x2\) \(lo, r\);

00000020 <dual16>:
  20:	<2020> Illegal opcode
0c c4 40 45 	;

00000024 <byteop16p>:
  24:	15 c4 8b 06 	\(r2, r3\) = byteop16p\(r1:0x0, r3:0x2\);
  28:	15 c4 8b 21 	\(r6, r0\) = byteop16p\(r1:0x0, r3:0x2\) \(r\);

0000002c <byteop1p>:
  2c:	14 c4 0b 44 	r2 = byteop1p\(r1:0x0, r3:0x2\) \(t\);
  30:	14 c4 0b 26 	r3 = byteop1p\(r1:0x0, r3:0x2\) \(r\);
  34:	14 c4 0b 6e 	r7 = byteop1p\(r1:0x0, r3:0x2\) \(t, r\);

00000038 <byteop2p>:
  38:	16 c4 0b 00 	r0 = byteop2m\(r1:0x0, r3:0x2\) \(rndl\);
  3c:	36 c4 0b 02 	r1 = byteop2m\(r1:0x0, r3:0x2\) \(rndh\);
  40:	16 c4 0b 44 	r2 = byteop2m\(r1:0x0, r3:0x2\) \(tl\);
  44:	36 c4 0b 46 	r3 = byteop2m\(r1:0x0, r3:0x2\) \(th\);
  48:	16 c4 0b 28 	r4 = byteop2m\(r1:0x0, r3:0x2\) \(rndl, r\);
  4c:	16 c4 0b 6a 	r5 = byteop2m\(r1:0x0, r3:0x2\) \(tl, r\);
  50:	16 c4 0b 6c 	r6 = byteop2m\(r1:0x0, r3:0x2\) \(tl, r\);
  54:	36 c4 0b 6e 	r7 = byteop2m\(r1:0x0, r3:0x2\) \(th, r\);

00000058 <bytepack>:
  58:	18 c4 03 0a 	;

0000005c <byteop16m>:
  5c:	15 c4 8b 45 	\(r6, r2\) = byteop16m\(r1:0x0, r3:0x2\);
  60:	15 c4 0b 6a 	\(r0, r5\) = byteop16m\(r1:0x0, r3:0x2\) \(r\);

00000064 <saa>:
  64:	12 c4 0b 00 	saa \(r1:0x0, r3:0x2\);
  68:	12 c4 0b 20 	saa \(r1:0x0, r3:0x2\) \(r\);

0000006c <byteunpack>:
  6c:	18 c4 c8 45 	\(r7, r2\) = byteunpackr1:0x0;
  70:	18 c4 98 69 	\(r6, r4\) = byteunpackr3:0x2 \(r\);
