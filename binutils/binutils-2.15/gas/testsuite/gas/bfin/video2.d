#objdump: -dr
#name: video2
.*: +file format .*

Disassembly of section .text:

00000000 <.text>:
   0:	0d c6 00 00 	R0=ALIGN8\(R0,R0\);
   4:	0d c6 08 00 	R0=ALIGN8\(R0,R1\);
   8:	0d c6 01 00 	R0=ALIGN8\(R1,R0\);
   c:	0d c6 09 00 	R0=ALIGN8\(R1,R1\);
  10:	0d c6 11 00 	R0=ALIGN8\(R1,R2\);
  14:	0d c6 2c 06 	R3=ALIGN8\(R4,R5\);
  18:	0d c6 07 0c 	R6=ALIGN8\(R7,R0\);
  1c:	0d c6 1a 02 	R1=ALIGN8\(R2,R3\);
  20:	0d c6 35 08 	R4=ALIGN8\(R5,R6\);
  24:	0d c6 08 0e 	R7=ALIGN8\(R0,R1\);
  28:	0d c6 23 04 	R2=ALIGN8\(R3,R4\);
  2c:	0d c6 3e 0a 	R5=ALIGN8\(R6,R7\);
  30:	0d c6 00 40 	R0=ALIGN16\(R0,R0\);
  34:	0d c6 08 40 	R0=ALIGN16\(R0,R1\);
  38:	0d c6 01 40 	R0=ALIGN16\(R1,R0\);
  3c:	0d c6 09 40 	R0=ALIGN16\(R1,R1\);
  40:	0d c6 11 40 	R0=ALIGN16\(R1,R2\);
  44:	0d c6 2c 46 	R3=ALIGN16\(R4,R5\);
  48:	0d c6 07 4c 	R6=ALIGN16\(R7,R0\);
  4c:	0d c6 1a 42 	R1=ALIGN16\(R2,R3\);
  50:	0d c6 35 48 	R4=ALIGN16\(R5,R6\);
  54:	0d c6 08 4e 	R7=ALIGN16\(R0,R1\);
  58:	0d c6 23 44 	R2=ALIGN16\(R3,R4\);
  5c:	0d c6 3e 4a 	R5=ALIGN16\(R6,R7\);
  60:	0d c6 00 80 	R0=ALIGN24\(R0,R0\);
  64:	0d c6 08 80 	R0=ALIGN24\(R0,R1\);
  68:	0d c6 01 80 	R0=ALIGN24\(R1,R0\);
  6c:	0d c6 09 80 	R0=ALIGN24\(R1,R1\);
  70:	0d c6 11 80 	R0=ALIGN24\(R1,R2\);
  74:	0d c6 2c 86 	R3=ALIGN24\(R4,R5\);
  78:	0d c6 07 8c 	R6=ALIGN24\(R7,R0\);
  7c:	0d c6 1a 82 	R1=ALIGN24\(R2,R3\);
  80:	0d c6 35 88 	R4=ALIGN24\(R5,R6\);
  84:	0d c6 08 8e 	R7=ALIGN24\(R0,R1\);
  88:	0d c6 23 84 	R2=ALIGN24\(R3,R4\);
  8c:	0d c6 3e 8a 	R5=ALIGN24\(R6,R7\);
  90:	12 c4 00 c0 	DISALGNEXCPT;
  94:	17 c4 02 00 	R0=BYTEOP3P\(R1:0x0,R3:0x2\)\(LO\);
  98:	37 c4 02 02 	R1=BYTEOP3P\(R1:0x0,R3:0x2\)\(HI\);
  9c:	17 c4 02 24 	R2=BYTEOP3P\(R1:0x0,R3:0x2\)\(LO, R\);
  a0:	37 c4 02 26 	R3=BYTEOP3P\(R1:0x0,R3:0x2\)\(HI, R\);
  a4:	17 c4 10 08 	R4=BYTEOP3P\(R3:0x2,R1:0x0\)\(LO\);
  a8:	37 c4 10 0a 	R5=BYTEOP3P\(R3:0x2,R1:0x0\)\(HI\);
  ac:	17 c4 10 2c 	R6=BYTEOP3P\(R3:0x2,R1:0x0\)\(LO, R\);
  b0:	37 c4 10 2e 	R7=BYTEOP3P\(R3:0x2,R1:0x0\)\(HI, R\);
  b4:	0c c4 36 40 	R0=A1.L\+A1.H,R0=A0.L\+A0.H;
  b8:	0c c4 36 42 	R0=A1.L\+A1.H,R1=A0.L\+A0.H;
  bc:	0c c4 b6 46 	R2=A1.L\+A1.H,R3=A0.L\+A0.H;
  c0:	0c c4 36 4b 	R4=A1.L\+A1.H,R5=A0.L\+A0.H;
  c4:	0c c4 b6 4f 	R6=A1.L\+A1.H,R7=A0.L\+A0.H;
  c8:	15 c4 d0 01 	\(R7,R0\)=BYTEOP16P\(R3:0x2,R1:0x0\) ;
  cc:	15 c4 50 04 	\(R1,R2\)=BYTEOP16P\(R3:0x2,R1:0x0\) ;
  d0:	15 c4 10 02 	\(R0,R1\)=BYTEOP16P\(R3:0x2,R1:0x0\) ;
  d4:	15 c4 90 06 	\(R2,R3\)=BYTEOP16P\(R3:0x2,R1:0x0\) ;
  d8:	15 c4 c2 01 	\(R7,R0\)=BYTEOP16P\(R1:0x0,R3:0x2\) ;
  dc:	15 c4 42 04 	\(R1,R2\)=BYTEOP16P\(R1:0x0,R3:0x2\) ;
  e0:	15 c4 02 02 	\(R0,R1\)=BYTEOP16P\(R1:0x0,R3:0x2\) ;
  e4:	15 c4 82 06 	\(R2,R3\)=BYTEOP16P\(R1:0x0,R3:0x2\) ;
  e8:	15 c4 d0 21 	\(R7,R0\)=BYTEOP16P\(R3:0x2,R1:0x0\) \(R\);
  ec:	15 c4 50 24 	\(R1,R2\)=BYTEOP16P\(R3:0x2,R1:0x0\) \(R\);
  f0:	15 c4 10 22 	\(R0,R1\)=BYTEOP16P\(R3:0x2,R1:0x0\) \(R\);
  f4:	15 c4 90 26 	\(R2,R3\)=BYTEOP16P\(R3:0x2,R1:0x0\) \(R\);
  f8:	15 c4 c2 21 	\(R7,R0\)=BYTEOP16P\(R1:0x0,R3:0x2\) \(R\);
  fc:	15 c4 42 24 	\(R1,R2\)=BYTEOP16P\(R1:0x0,R3:0x2\) \(R\);
 100:	15 c4 02 22 	\(R0,R1\)=BYTEOP16P\(R1:0x0,R3:0x2\) \(R\);
 104:	15 c4 82 26 	\(R2,R3\)=BYTEOP16P\(R1:0x0,R3:0x2\) \(R\);
 108:	14 c4 02 06 	R3=BYTEOP1P\(R1:0x0,R3:0x2\);
 10c:	14 c4 02 26 	R3=BYTEOP1P\(R1:0x0,R3:0x2\)\(R\);
 110:	14 c4 02 46 	R3=BYTEOP1P\(R1:0x0,R3:0x2\)\(T\);
 114:	14 c4 02 66 	R3=BYTEOP1P\(R1:0x0,R3:0x2\)\(T, R\);
 118:	14 c4 10 00 	R0=BYTEOP1P\(R3:0x2,R1:0x0\);
 11c:	14 c4 10 22 	R1=BYTEOP1P\(R3:0x2,R1:0x0\)\(R\);
 120:	14 c4 10 44 	R2=BYTEOP1P\(R3:0x2,R1:0x0\)\(T\);
 124:	14 c4 10 66 	R3=BYTEOP1P\(R3:0x2,R1:0x0\)\(T, R\);
 128:	16 c4 02 06 	R3=BYTEOP2P\(R1:0x0,R3:0x2\)\(RNDL\);
 12c:	36 c4 02 06 	R3=BYTEOP2P\(R1:0x0,R3:0x2\)\(RNDH\);
 130:	16 c4 02 46 	R3=BYTEOP2P\(R1:0x0,R3:0x2\)\(TL\);
 134:	36 c4 02 46 	R3=BYTEOP2P\(R1:0x0,R3:0x2\)\(TH\);
 138:	16 c4 02 26 	R3=BYTEOP2P\(R1:0x0,R3:0x2\)\(RNDL, R\);
 13c:	36 c4 02 26 	R3=BYTEOP2P\(R1:0x0,R3:0x2\)\(RNDH, R\);
 140:	16 c4 02 66 	R3=BYTEOP2P\(R1:0x0,R3:0x2\)\(TL, R\);
 144:	36 c4 02 66 	R3=BYTEOP2P\(R1:0x0,R3:0x2\)\(TH, R\);
 148:	16 c4 02 00 	R0=BYTEOP2P\(R1:0x0,R3:0x2\)\(RNDL\);
 14c:	36 c4 02 02 	R1=BYTEOP2P\(R1:0x0,R3:0x2\)\(RNDH\);
 150:	16 c4 02 44 	R2=BYTEOP2P\(R1:0x0,R3:0x2\)\(TL\);
 154:	36 c4 02 46 	R3=BYTEOP2P\(R1:0x0,R3:0x2\)\(TH\);
 158:	16 c4 02 28 	R4=BYTEOP2P\(R1:0x0,R3:0x2\)\(RNDL, R\);
 15c:	16 c4 02 2a 	R5=BYTEOP2P\(R1:0x0,R3:0x2\)\(RNDH, R\);
 160:	16 c4 02 6c 	R6=BYTEOP2P\(R1:0x0,R3:0x2\)\(TL, R\);
 164:	36 c4 02 6e 	R7=BYTEOP2P\(R1:0x0,R3:0x2\)\(TH, R\);
 168:	16 c4 12 00 	R0=BYTEOP2P\(R3:0x2,R3:0x2\)\(RNDL\);
 16c:	36 c4 12 02 	R1=BYTEOP2P\(R3:0x2,R3:0x2\)\(RNDH\);
 170:	16 c4 12 44 	R2=BYTEOP2P\(R3:0x2,R3:0x2\)\(TL\);
 174:	36 c4 12 46 	R3=BYTEOP2P\(R3:0x2,R3:0x2\)\(TH\);
 178:	16 c4 12 28 	R4=BYTEOP2P\(R3:0x2,R3:0x2\)\(RNDL, R\);
 17c:	16 c4 12 2a 	R5=BYTEOP2P\(R3:0x2,R3:0x2\)\(TL, R\);
 180:	16 c4 12 6c 	R6=BYTEOP2P\(R3:0x2,R3:0x2\)\(TL, R\);
 184:	36 c4 12 6e 	R7=BYTEOP2P\(R3:0x2,R3:0x2\)\(TH, R\);
 188:	18 c4 00 00 	R0=BYTEPACK\(R0,R0\);
 18c:	18 c4 13 02 	R1=BYTEPACK\(R2,R3\);
 190:	18 c4 2e 08 	R4=BYTEPACK\(R5,R6\);
 194:	18 c4 01 0e 	R7=BYTEPACK\(R0,R1\);
 198:	18 c4 1c 04 	R2=BYTEPACK\(R3,R4\);
 19c:	18 c4 37 0a 	R5=BYTEPACK\(R6,R7\);
 1a0:	15 c4 50 44 	\(R1,R2\)=BYTEOP16M\(R3:0x2,R1:0x0\) ;
 1a4:	15 c4 50 64 	\(R1,R2\)=BYTEOP16M\(R3:0x2,R1:0x0\) \(R\);
 1a8:	15 c4 10 42 	\(R0,R1\)=BYTEOP16M\(R3:0x2,R1:0x0\) ;
 1ac:	15 c4 90 66 	\(R2,R3\)=BYTEOP16M\(R3:0x2,R1:0x0\) \(R\);
 1b0:	15 c4 d0 4a 	\(R3,R5\)=BYTEOP16M\(R3:0x2,R1:0x0\) ;
 1b4:	15 c4 90 6f 	\(R6,R7\)=BYTEOP16M\(R3:0x2,R1:0x0\) \(R\);
 1b8:	15 c4 40 44 	\(R1,R2\)=BYTEOP16M\(R1:0x0,R1:0x0\) ;
 1bc:	15 c4 40 64 	\(R1,R2\)=BYTEOP16M\(R1:0x0,R1:0x0\) \(R\);
 1c0:	15 c4 00 42 	\(R0,R1\)=BYTEOP16M\(R1:0x0,R1:0x0\) ;
 1c4:	15 c4 80 66 	\(R2,R3\)=BYTEOP16M\(R1:0x0,R1:0x0\) \(R\);
 1c8:	15 c4 c0 4a 	\(R3,R5\)=BYTEOP16M\(R1:0x0,R1:0x0\) ;
 1cc:	15 c4 80 6f 	\(R6,R7\)=BYTEOP16M\(R1:0x0,R1:0x0\) \(R\);
 1d0:	15 c4 42 44 	\(R1,R2\)=BYTEOP16M\(R1:0x0,R3:0x2\) ;
 1d4:	15 c4 42 64 	\(R1,R2\)=BYTEOP16M\(R1:0x0,R3:0x2\) \(R\);
 1d8:	15 c4 02 42 	\(R0,R1\)=BYTEOP16M\(R1:0x0,R3:0x2\) ;
 1dc:	15 c4 82 66 	\(R2,R3\)=BYTEOP16M\(R1:0x0,R3:0x2\) \(R\);
 1e0:	15 c4 c2 4a 	\(R3,R5\)=BYTEOP16M\(R1:0x0,R3:0x2\) ;
 1e4:	15 c4 82 6f 	\(R6,R7\)=BYTEOP16M\(R1:0x0,R3:0x2\) \(R\);
 1e8:	15 c4 52 44 	\(R1,R2\)=BYTEOP16M\(R3:0x2,R3:0x2\) ;
 1ec:	15 c4 52 64 	\(R1,R2\)=BYTEOP16M\(R3:0x2,R3:0x2\) \(R\);
 1f0:	15 c4 12 42 	\(R0,R1\)=BYTEOP16M\(R3:0x2,R3:0x2\) ;
 1f4:	15 c4 92 66 	\(R2,R3\)=BYTEOP16M\(R3:0x2,R3:0x2\) \(R\);
 1f8:	15 c4 d2 4a 	\(R3,R5\)=BYTEOP16M\(R3:0x2,R3:0x2\) ;
 1fc:	15 c4 92 6f 	\(R6,R7\)=BYTEOP16M\(R3:0x2,R3:0x2\) \(R\);
 200:	12 cc 02 00 	SAA\(R1:0x0,R3:0x2\)  || R0=\[I0\+\+\] || R2=\[I1\+\+\];
 204:	00 9c 0a 9c 
 208:	12 cc 02 20 	SAA\(R1:0x0,R3:0x2\) \(R\) || R1=\[I0\+\+\] || R3=\[I1\+\+\];
 20c:	01 9c 0b 9c 
 210:	12 c4 02 00 	SAA\(R1:0x0,R3:0x2\) ;
 214:	18 c4 80 4b 	\(R6,R5\) = BYTEUNPACK R1:0x0 ;
 218:	18 c4 80 6b 	\(R6,R5\) = BYTEUNPACK R1:0x0 \(R\);
 21c:	18 c4 90 4b 	\(R6,R5\) = BYTEUNPACK R3:0x2 ;
 220:	18 c4 90 6b 	\(R6,R5\) = BYTEUNPACK R3:0x2 \(R\);
 224:	18 c4 00 42 	\(R0,R1\) = BYTEUNPACK R1:0x0 ;
 228:	18 c4 80 66 	\(R2,R3\) = BYTEUNPACK R1:0x0 \(R\);
 22c:	18 c4 10 4b 	\(R4,R5\) = BYTEUNPACK R3:0x2 ;
 230:	18 c4 90 6f 	\(R6,R7\) = BYTEUNPACK R3:0x2 \(R\);
