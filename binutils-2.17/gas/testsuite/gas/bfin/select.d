#objdump: -d
#name: load
.*: +file format .*

Disassembly of section .text:

00000000 <_select>:
   0:	0d c4 50 86 	\(R1, R3\) = SEARCH R2 \(LT\);
   4:	19 c4 19 84 	\(R0, R2\) = SELECT \(R1, R3\) \(LT\);
   8:	13 c4 62 46 	\(R1, R3\) = SEARCH \(R2, R4\) \(GE\);
   c:	19 c4 19 44 	\(R0, R2\) = SELECT \(R1, R3\) \(GE\);
