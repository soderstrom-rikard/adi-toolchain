#objdump: -dr
#name: bit
.*: +file format .*

Disassembly of section .text:

00000000 <bitclr>:
   0:	fc 4c       	bitclr\(r4, 0x1f\);
   2:	00 4c       	bitclr\(r0, 0x0\);

00000004 <bitset>:
   4:	f2 4a       	bitset\(r2, 0x1e\);
   6:	eb 4a       	bitset\(r3, 0x1d\);

00000008 <bittgl>:
   8:	b7 4b       	bittgl\(r7, 0x16\);
   a:	86 4b       	bittgl\(r6, 0x10\);

0000000c <bittst>:
   c:	f8 49       	cc = bittst\(r0, 0x1f\);
   e:	01 49       	cc = bittst\(r1, 0x0\);
  10:	7f 49       	cc = bittst\(r7, 0xf\);

00000012 <deposit>:
  12:	0a c6 13 8a 	r5 = deposit\(r3, r2\);
  16:	0a c6 37 c0 	r0 = deposit\(r7, r6\) \(x\);

0000001a <extract>:
  1a:	0a c6 0a 08 	r4 = extract\(r2, r1.l\);
  1e:	0a c6 10 04 	r2 = extract\(r0, r2.l\);
  22:	0a c6 23 4e 	r7 = extract\(r3, r4.l\) \(x\);
  26:	0a c6 0e 4a 	r5 = extract\(r6, r1.l\) \(x\);

0000002a <bitmux>:
  2a:	08 c6 08 00 	bitmux \(r1, r0, a0\) \(asr\);
  2e:	08 c6 13 00 	bitmux \(r2, r3, a0\) \(asr\);
  32:	08 c6 25 40 	bitmux \(r4, r5, a0\) \(asl\);
  36:	08 c6 3e 40 	bitmux \(r7, r6, a0\) \(asl\);

0000003a <ones>:
  3a:	06 c6 00 ca 	r5.l = ones r0;
  3e:	06 c6 02 ce 	r7.l = ones r2;
	...
