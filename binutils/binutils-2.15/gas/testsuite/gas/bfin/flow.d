#objdump: -dr
#name: flow
.*: +file format .*

Disassembly of section .text:

00000000 <jump>:
   0:	55 00       	JUMP  \(P5\);
   2:	83 00       	JUMP  \(PC\+P3\);
   4:	00 20       	JUMP.S  4 <jump\+0x4>;
   6:	80 e2 00 00	JUMP.L  ff000006
   a:	7f e2 ff ff 	JUMP.L  1000008 <loop1\+0xffffbc>;
   e:	ff 27       	JUMP.S  100c <loop1\+0xfc0>;
  10:	7f e2 00 80 	JUMP.L  ff0010 <loop1\+0xfeffc4>;
  14:	f6 2f       	JUMP.S  0 <jump>;

00000016 <ccjump>:
  16:	00 1a       	IF CC JUMP fffffc16 <loop1\+0xfffffbca>;
  18:	ff 1d       	IF CC JUMP 416 <loop1\+0x3ca>\(BP\);
  1a:	00 16       	IF ! CC JUMP fffffc1a <loop1\+0xfffffbce>\(BP\);
  1c:	89 10       	IF ! CC JUMP 12e <loop1\+0xe2>;
  1e:	f1 1b       	IF CC JUMP 0 <jump>;
  20:	f0 1f       	IF CC JUMP 0 <jump>\(BP\);
  22:	ef 17       	IF ! CC JUMP 0 <jump>\(BP\);
  24:	ee 13       	IF ! CC JUMP 0 <jump>;

00000026 <call>:
  26:	63 00       	CALL  \(P3\);
  28:	72 00       	CALL  \(PC\+P2\);
  2a:	80 ff 00 00     CALL ff00002a
  2e:	7f e3 ff ff 	CALL  100002c <loop1\+0xffffe0>;
  32:	ff e3 e7 ff 	CALL  0 <jump>;

00000036 <return>:
  36:	10 00       	RTS;
  38:	11 00       	RTI;
  3a:	12 00       	RTX;
  3c:	13 00       	RTN;
  3e:	14 00       	RTE;

00000040 <loop0>:
  40:	82 e0 ff 03 	LSETUP\(44 <loop0\+0x4>,3e <return\+0x8>\)LC0;
  44:	af e0 00 52 	LSETUP\(42 <loop0\+0x2>,fffffc44 <loop1\+0xfffffbf8>\)LC0=P5;
  48:	ef e0 02 00 	LSETUP\(46 <loop0\+0x6>,4c <loop1>\)LC0=P0>>1;

0000004c <loop1>:
  4c:	92 e0 ff 03 	LSETUP\(50 <loop1\+0x4>,4a <loop0\+0xa>\)LC1;
  50:	bf e0 00 52 	LSETUP\(4e <loop1\+0x2>,fffffc50 <loop1\+0xfffffc04>\)LC1=P5;
  54:	ff e0 02 00 	LSETUP\(52 <loop1\+0x6>,58 <loop1\+0xc>\)LC1=P0>>1;
  58:	ef e0 02 00	LSETUP\(30, 1024\) LC0=P5;
  5c:	90 e0 00 00 	LSETUP\(0, 0\) LC1;
  60:	b0 e0 00 40	LSETUP\(0, 0\) LC1=P4;
  64:	b0 e0 00 00	LSETUP\(0, 0\) LC1=P1;
  68:	f0 e0 00 10	LSETUP\(0, 0\) LC1=P>>1;
  6c:	92 e0 ff 03	LSETUP\(4, 2046\) LC1;
  70:	bf e0 00 52	LSETUP\(30, 1024\) LC1=P5;
  74:	ff e0 02 00	LSETUP\(30, 4\) LC1=P0>>1;
