#objdump: -dr
#name: shift
.*: +file format .*

Disassembly of section .text:

00000000 <add_with_shift>:
   0:	88 45       	P0=\(P0\+P1\)<<1;
   2:	ea 45       	P2=\(P2\+P5\)<<2;
   4:	4f 41       	R7=\(R7\+R1\)<<2;
   6:	03 41       	R3=\(R3\+R0\)<<1;

00000008 <shift_with_add>:
   8:	44 5f       	P5=P4\+\(P0<<2\);
   a:	0a 5c       	P0=P2\+\(P1<<1\);

0000000c <arithmetic_shift>:
   c:	83 c6 08 41 	A0=A0>>0x1f;
  10:	83 c6 f8 00 	A0=A0<<0x1f;
  14:	83 c6 00 50 	A1=A1>>0x0;
  18:	83 c6 00 10 	A1=A1<<0x0;
  1c:	82 c6 fd 4e 	R7=R5<<0x1f\(S\);
  20:	82 c6 52 07 	R3=R2 >>> 0x16;
  24:	80 c6 7a 52 	R1.L=R2.H << 0xf\(S\);
  28:	80 c6 f2 2b 	R5.H=R2.L<<0x3e;
  2c:	00 4f       	R0<<=0x0;
  2e:	f9 4d       	R1>>>=0x1f;
  30:	08 40       	R0>>>=R1;
  32:	8a 40       	R2<<=R1;
  34:	00 c6 14 16 	R3.L= ASHIFT R4.HBYR2.L;
  38:	00 c6 07 6e 	R7.H= ASHIFT R7.LBYR0.L\(S\);
  3c:	00 c6 07 6e 	R7.H= ASHIFT R7.LBYR0.L\(S\);
  40:	02 c6 15 0c 	R6= ASHIFT R5BYR2.L;
  44:	02 c6 0c 40 	R0= ASHIFT R4BYR1.L\(S\);
  48:	02 c6 1e 44 	R2= ASHIFT R6BYR3.L\(S\);
  4c:	03 c6 08 00 	A0= ASHIFT A0BYR1.L;
  50:	03 c6 00 10 	A1= ASHIFT A1BYR0.L;

00000054 <logical_shift>:
  54:	00 45       	P0=P0>>1;
  56:	d1 44       	P1=P2>>2;
  58:	c9 5a       	P3=P1<<1;
  5a:	6c 44       	P4=P5<<2;
  5c:	f8 4e       	R0>>=0x1f;
  5e:	ff 4f       	R7<<=0x1f;
  60:	80 c6 8a a3 	R1.H=R2.L>>0xf;
  64:	80 c6 00 8e 	R7.L=R0.L<<0x0;
  68:	82 c6 0d 8b 	R5=R5>>0x1f;
  6c:	82 c6 60 80 	R0=R0>>-12;
  70:	83 c6 f8 41 	A0=A0>>0x1;
  74:	83 c6 00 00 	A0=A0<<0x0;
  78:	83 c6 f8 10 	A1=A1<<0x1f;
  7c:	83 c6 80 51 	A1=A1>>0x10;
  80:	7d 40       	R5>>=R7;
  82:	86 40       	R6<<=R0;
  84:	00 c6 02 b2 	R1.H= LSHIFT R2.HBYR0.L;
  88:	00 c6 08 90 	R0.L= LSHIFT R0.HBYR1.L;
  8c:	00 c6 16 8e 	R7.L= LSHIFT R6.LBYR2.L;
  90:	02 c6 1c 8a 	R5=SHIFTR4BYR3.L;
  94:	03 c6 30 40 	A0= LSHIFT A0BYR6.L;
  98:	03 c6 28 50 	A1= LSHIFT A1BYR5.L;

0000009c <rotate>:
  9c:	82 c6 07 cf 	R7= ROT R7BY-32;
  a0:	82 c6 0f cd 	R6= ROT R7BY-31;
  a4:	82 c6 ff ca 	R5= ROT R7BY0x1f;
  a8:	82 c6 f7 c8 	R4= ROT R7BY0x1e;
  ac:	83 c6 00 80 	A0= ROT A0BY0x0;
  b0:	83 c6 50 80 	A0= ROT A0BY0xa;
  b4:	83 c6 60 91 	A1= ROT A1BY-20;
  b8:	83 c6 00 91 	A1= ROT A1BY-32;
  bc:	02 c6 11 c0	R0= ROT R1BYR2.L;
  c0:	02 c6 1c c0	R0= ROT R4BYR3.L;
  c4:	03 c6 38 80	A0= ROT A0BYR7.L;
  c8:	03 c6 30 90 	A1= ROT A1BYR6.L;
