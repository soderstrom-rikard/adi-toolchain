#objdump: -d
#name: load
.*: +file format .*

Disassembly of section .text:

00000000 <_cmul>:
   0:	00 c7 01 e0 	R0 = CMUL \(R0, R1\);
   4:	00 c7 01 e4 	R0 = CMUL \(R0, R1\*\);
   8:	00 c7 81 ec 	R2 = CMUL \(R0\*, R1\*\);
   c:	02 c7 0a e0 	R0 = CMUL \(R1, R2\) \(T\);
  10:	00 c7 81 f0 	R3:2 = CMUL \(R0, R1\);
  14:	00 c7 01 00 	\(A0, A1\) = CMUL \(R0, R1\);
  18:	00 c7 01 04 	\(A0, A1\) = CMUL \(R0, R1\*\);
  1c:	00 c7 01 40 	\(A0, A1\) \+= CMUL \(R0, R1\);
  20:	00 c7 81 20 	R2 = \(\(A0, A1\) = CMUL \(R0, R1\)\);
  24:	00 c7 81 60 	R2 = \(\(A0, A1\) \+= CMUL \(R0, R1\)\);
  28:	02 c7 81 60 	R2 = \(\(A0, A1\) \+= CMUL \(R0, R1\)\) \(T\);
  2c:	00 c7 81 70 	R3:2 = \(\(A0, A1\) \+= CMUL \(R0, R1\)\);
