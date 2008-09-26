#objdump: -d
#name: load
.*: +file format .*

Disassembly of section .text:

00000000 <_csqu>:
   0:	20 c7 40 f0 	R1.L = CSQU \(R0\);
   4:	20 c7 40 f0 	R1.L = CSQU \(R0\);
   8:	22 c7 40 f0 	R1.L = CSQU \(R0\) \(T\);
   c:	20 c7 40 f6 	R1 = CSQU \(R0\);
  10:	20 c7 00 30 	A0 = CSQU \(R0\);
  14:	20 c7 00 70 	A0 \+= CSQU \(R0\);
  18:	28 c7 00 70 	A0 \+= CSQU \(R0\) \(IS\);
  1c:	20 c7 40 c6 	R1 = \(A1 = CSQU \(R0\)\);
  20:	20 c7 08 ba 	R0 = \(A0 -= CSQU \(R1\)\);
  24:	22 c7 40 78 	R1.L = \(A0 \+= CSQU \(R0\)\) \(T\);
