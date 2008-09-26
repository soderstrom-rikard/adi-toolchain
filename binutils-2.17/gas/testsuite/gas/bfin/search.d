#objdump: -d
#name: load
.*: +file format .*

Disassembly of section .text:

00000000 <_search>:
   0:	0d c4 50 c0 	\(R1, R0\) = SEARCH R2 \(LE\);
   4:	13 c4 9c 8b 	\(R6, R5\) = SEARCH \(R4, R3\) \(LT\);
