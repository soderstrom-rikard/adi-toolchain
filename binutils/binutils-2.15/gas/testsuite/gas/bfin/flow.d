#objdump: -d
#name: flow
.*: +file format .*

Disassembly of section .text:

00000000 <jump>:
   0:	55 00       	JUMP  \(P5\);
   2:	83 00       	JUMP  \(PC\+P3\);
   4:	00 20       	JUMP.S  4.*
   6:	80 e2 00 00 	JUMP.L  ff000006.*
   a:	7f e2 ff ff 	JUMP.L  1000008.*
   e:	ff 27       	JUMP.S  100c.*
  10:	7f e2 00 80 	JUMP.L  ff0010.*
  14:	f6 2f       	JUMP.S  0 <jump>;

00000016 <ccjump>:
  16:	00 1a       	IF CC JUMP fffffc16.*
  18:	ff 1d       	IF CC JUMP 416.*\(BP\);
  1a:	00 16       	IF ! CC JUMP fffffc1a.*\(BP\);
  1c:	89 10       	IF ! CC JUMP 12e.*
  1e:	f1 1b       	IF CC JUMP 0 <jump>;
  20:	f0 1f       	IF CC JUMP 0 <jump>\(BP\);
  22:	ef 17       	IF ! CC JUMP 0 <jump>\(BP\);
  24:	ee 13       	IF ! CC JUMP 0 <jump>;

00000026 <call>:
  26:	63 00       	CALL  \(P3\);
  28:	72 00       	CALL  \(PC\+P2\);
  2a:	80 e3 00 00 	CALL  ff00002a.*
  2e:	7f e3 ff ff 	CALL  100002c.*
  32:	ff e3 e7 ff 	CALL  0 <jump>;

00000036 <return>:
  36:	10 00       	RTS;
  38:	11 00       	RTI;
  3a:	12 00       	RTX;
  3c:	13 00       	RTN;
  3e:	14 00       	RTE;

00000040 <loop_lc0>:
  40:	82 e0 15 00 	LSETUP\(44 <first_loop__BEGIN>,6a <first_loop__END>\)LC0;

00000044 <first_loop__BEGIN>:
  44:	38 e4 7b fc 	R0=\[FP\+-3604\];
  48:	49 60       	R1=0x9\(x\);
  4a:	38 e4 7b fc 	R0=\[FP\+-3604\];
  4e:	00 32       	P0=R0;
  50:	42 44       	P2=P0<<2;
  52:	ba 5a       	P2=P2\+FP;
  54:	20 e1 50 fb 	R0=-1200 \(X\);
  58:	08 32       	P1=R0;
  5a:	8a 5a       	P2=P2\+P1;
  5c:	00 60       	R0=0x0\(x\);
  5e:	10 93       	\[P2\]=R0;
  60:	38 e4 7b fc 	R0=\[FP\+-3604\];
  64:	08 64       	R0\+=0x1;
  66:	38 e6 7b fc 	\[FP\+-3604\]=R0;

0000006a <first_loop__END>:
  6a:	a2 e0 02 40 	LSETUP\(6e <second_loop__BEGIN>,6e <second_loop__BEGIN>\)LC0=P4;

0000006e <second_loop__BEGIN>:
  6e:	e9 e0 c8 13 	LSETUP\(60 <first_loop__BEGIN\+0x1c>,fffffffe <another_Loop__END\+0xffffff40>\)LC0=P1>>1;
  72:	82 e0 ff 03 	LSETUP\(76 <second_loop__BEGIN\+0x8>,70 <second_loop__BEGIN\+0x2>\)LC0;
  76:	af e0 00 52 	LSETUP\(74 <second_loop__BEGIN\+0x6>,fffffc76 <another_Loop__END\+0xfffffbb8>\)LC0=P5;
  7a:	ef e0 02 00 	LSETUP\(78 <second_loop__BEGIN\+0xa>,7e <loop_lc1>\)LC0=P0>>1;

0000007e <loop_lc1>:
  7e:	91 e0 c0 03 	LSETUP\(80 <loop_lc1\+0x2>,fffffffe <another_Loop__END\+0xffffff40>\)LC1;
  82:	bf e0 be 43 	LSETUP\(80 <loop_lc1\+0x2>,fffffffe <another_Loop__END\+0xffffff40>\)LC1=P4;
  86:	f8 e0 bc 13 	LSETUP\(76 <second_loop__BEGIN\+0x8>,fffffffe <another_Loop__END\+0xffffff40>\)LC1=P1>>1;
  8a:	92 e0 ff 03 	LSETUP\(8e <loop_lc1\+0x10>,88 <loop_lc1\+0xa>\)LC1;
  8e:	bf e0 00 52 	LSETUP\(8c <loop_lc1\+0xe>,fffffc8e <another_Loop__END\+0xfffffbd0>\)LC1=P5;
  92:	ff e0 02 00 	LSETUP\(90 <loop_lc1\+0x12>,96 <another_loop__BEGIN>\)LC1=P0>>1;

00000096 <another_loop__BEGIN>:
  96:	38 e4 7a fc 	R0=\[FP\+-3608\];
  9a:	00 32       	P0=R0;
  9c:	42 44       	P2=P0<<2;
  9e:	ba 5a       	P2=P2\+FP;
  a0:	20 e1 f0 f1 	R0=-3600 \(X\);
  a4:	00 32       	P0=R0;
  a6:	42 5a       	P1=P2\+P0;
  a8:	38 e4 7a fc 	R0=\[FP\+-3608\];
  ac:	00 32       	P0=R0;
  ae:	42 44       	P2=P0<<2;
  b0:	ba 5a       	P2=P2\+FP;
  b2:	20 e1 50 fb 	R0=-1200 \(X\);
  b6:	00 32       	P0=R0;
  b8:	82 5a       	P2=P2\+P0;
  ba:	10 91       	R0=\[P2\];
  bc:	08 93       	\[P1\]=R0;

000000be <another_Loop__END>:
	...
