#objdump: -dr
#name: vector2
.*: +file format .*

Disassembly of section .text:

00000000 <.text>:
   0:	0c c4 13 0e 	R7.H=R7.L=SIGN\(R2.H\)\*R3.H\+SIGN\(R2.L\)\*R3.L\);
   4:	0c c4 0a 00 	R0.H=R0.L=SIGN\(R1.H\)\*R2.H\+SIGN\(R1.L\)\*R2.L\);
   8:	0c c4 25 06 	R3.H=R3.L=SIGN\(R4.H\)\*R5.H\+SIGN\(R4.L\)\*R5.L\);
   c:	0c c4 38 0c 	R6.H=R6.L=SIGN\(R7.H\)\*R0.H\+SIGN\(R7.L\)\*R0.L\);
  10:	0c c4 13 02 	R1.H=R1.L=SIGN\(R2.H\)\*R3.H\+SIGN\(R2.L\)\*R3.L\);
  14:	0c c4 2e 08 	R4.H=R4.L=SIGN\(R5.H\)\*R6.H\+SIGN\(R5.L\)\*R6.L\);
  18:	0c c4 01 0e 	R7.H=R7.L=SIGN\(R0.H\)\*R1.H\+SIGN\(R0.L\)\*R1.L\);
  1c:	0c c4 1c 04 	R2.H=R2.L=SIGN\(R3.H\)\*R4.H\+SIGN\(R3.L\)\*R4.L\);
  20:	09 c6 13 8a 	R5=VIT_MAX\(R3,R2\)\(ASL\);
  24:	09 c6 01 ce 	R7=VIT_MAX\(R1,R0\)\(ASR\);
  28:	09 c6 11 80 	R0=VIT_MAX\(R1,R2\)\(ASL\);
  2c:	09 c6 2c c6 	R3=VIT_MAX\(R4,R5\)\(ASR\);
  30:	09 c6 07 8c 	R6=VIT_MAX\(R7,R0\)\(ASL\);
  34:	09 c6 1a c2 	R1=VIT_MAX\(R2,R3\)\(ASR\);
  38:	09 c6 35 88 	R4=VIT_MAX\(R5,R6\)\(ASL\);
  3c:	09 c6 08 ce 	R7=VIT_MAX\(R0,R1\)\(ASR\);
  40:	09 c6 23 84 	R2=VIT_MAX\(R3,R4\)\(ASL\);
  44:	09 c6 3e ca 	R5=VIT_MAX\(R6,R7\)\(ASR\);
  48:	09 c6 01 06 	R3.L=VIT_MAX \(R1\) \(ASL\);
  4c:	09 c6 01 46 	R3.L=VIT_MAX \(R1\) \(ASR\);
  50:	09 c6 01 00 	R0.L=VIT_MAX \(R1\) \(ASL\);
  54:	09 c6 03 44 	R2.L=VIT_MAX \(R3\) \(ASR\);
  58:	09 c6 05 08 	R4.L=VIT_MAX \(R5\) \(ASL\);
  5c:	09 c6 07 4c 	R6.L=VIT_MAX \(R7\) \(ASR\);
  60:	09 c6 02 02 	R1.L=VIT_MAX \(R2\) \(ASL\);
  64:	09 c6 04 46 	R3.L=VIT_MAX \(R4\) \(ASR\);
  68:	09 c6 06 0a 	R5.L=VIT_MAX \(R6\) \(ASL\);
  6c:	09 c6 00 4e 	R7.L=VIT_MAX \(R0\) \(ASR\);
  70:	06 c4 08 86 	R3= ABS R1\(V\);
  74:	06 c4 00 80 	R0= ABS R0\(V\);
  78:	06 c4 08 80 	R0= ABS R1\(V\);
  7c:	06 c4 18 84 	R2= ABS R3\(V\);
  80:	06 c4 28 88 	R4= ABS R5\(V\);
  84:	06 c4 38 8c 	R6= ABS R7\(V\);
  88:	06 c4 00 82 	R1= ABS R0\(V\);
  8c:	06 c4 10 86 	R3= ABS R2\(V\);
  90:	06 c4 20 8a 	R5= ABS R4\(V\);
  94:	06 c4 30 8e 	R7= ABS R6\(V\);
  98:	00 c4 1c 0a 	R5=R3\+\|\+R4 ;
  9c:	00 c4 0a 00 	R0=R1\+\|\+R2 ;
  a0:	00 c4 25 06 	R3=R4\+\|\+R5 ;
  a4:	00 c4 38 0c 	R6=R7\+\|\+R0 ;
  a8:	00 c4 13 02 	R1=R2\+\|\+R3 ;
  ac:	00 c4 1d 08 	R4=R3\+\|\+R5 ;
  b0:	00 c4 1f 0c 	R6=R3\+\|\+R7 ;
  b4:	00 c4 0a 20 	R0=R1\+\|\+R2 \(S\);
  b8:	00 c4 25 26 	R3=R4\+\|\+R5 \(S\);
  bc:	00 c4 38 2c 	R6=R7\+\|\+R0 \(S\);
  c0:	00 c4 13 22 	R1=R2\+\|\+R3 \(S\);
  c4:	00 c4 1d 28 	R4=R3\+\|\+R5 \(S\);
  c8:	00 c4 1f 2c 	R6=R3\+\|\+R7 \(S\);
  cc:	00 c4 0a 10 	R0=R1\+\|\+R2 \(CO\);
  d0:	00 c4 25 16 	R3=R4\+\|\+R5 \(CO\);
  d4:	00 c4 38 1c 	R6=R7\+\|\+R0 \(CO\);
  d8:	00 c4 13 12 	R1=R2\+\|\+R3 \(CO\);
  dc:	00 c4 1d 18 	R4=R3\+\|\+R5 \(CO\);
  e0:	00 c4 1f 1c 	R6=R3\+\|\+R7 \(CO\);
  e4:	00 c4 0a 30 	R0=R1\+\|\+R2 \(SCO\);
  e8:	00 c4 25 36 	R3=R4\+\|\+R5 \(SCO\);
  ec:	00 c4 38 3c 	R6=R7\+\|\+R0 \(SCO\);
  f0:	00 c4 13 32 	R1=R2\+\|\+R3 \(SCO\);
  f4:	00 c4 1d 38 	R4=R3\+\|\+R5 \(SCO\);
  f8:	00 c4 1f 3c 	R6=R3\+\|\+R7 \(SCO\);
  fc:	00 c4 01 ac 	R6=R0-\|\+R1 \(S\);
 100:	00 c4 0a 80 	R0=R1-\|\+R2 ;
 104:	00 c4 25 86 	R3=R4-\|\+R5 ;
 108:	00 c4 38 8c 	R6=R7-\|\+R0 ;
 10c:	00 c4 13 82 	R1=R2-\|\+R3 ;
 110:	00 c4 1d 88 	R4=R3-\|\+R5 ;
 114:	00 c4 1f 8c 	R6=R3-\|\+R7 ;
 118:	00 c4 0a a0 	R0=R1-\|\+R2 \(S\);
 11c:	00 c4 25 a6 	R3=R4-\|\+R5 \(S\);
 120:	00 c4 38 ac 	R6=R7-\|\+R0 \(S\);
 124:	00 c4 13 a2 	R1=R2-\|\+R3 \(S\);
 128:	00 c4 1d a8 	R4=R3-\|\+R5 \(S\);
 12c:	00 c4 1f ac 	R6=R3-\|\+R7 \(S\);
 130:	00 c4 0a 90 	R0=R1-\|\+R2 \(CO\);
 134:	00 c4 25 96 	R3=R4-\|\+R5 \(CO\);
 138:	00 c4 38 9c 	R6=R7-\|\+R0 \(CO\);
 13c:	00 c4 13 92 	R1=R2-\|\+R3 \(CO\);
 140:	00 c4 1d 98 	R4=R3-\|\+R5 \(CO\);
 144:	00 c4 1f 9c 	R6=R3-\|\+R7 \(CO\);
 148:	00 c4 0a b0 	R0=R1-\|\+R2 \(SCO\);
 14c:	00 c4 25 b6 	R3=R4-\|\+R5 \(SCO\);
 150:	00 c4 38 bc 	R6=R7-\|\+R0 \(SCO\);
 154:	00 c4 13 b2 	R1=R2-\|\+R3 \(SCO\);
 158:	00 c4 1d b8 	R4=R3-\|\+R5 \(SCO\);
 15c:	00 c4 1f bc 	R6=R3-\|\+R7 \(SCO\);
 160:	00 c4 11 50 	R0=R2\+\|-R1 \(CO\);
 164:	00 c4 0a 40 	R0=R1\+\|-R2 ;
 168:	00 c4 25 46 	R3=R4\+\|-R5 ;
 16c:	00 c4 38 4c 	R6=R7\+\|-R0 ;
 170:	00 c4 13 42 	R1=R2\+\|-R3 ;
 174:	00 c4 1d 48 	R4=R3\+\|-R5 ;
 178:	00 c4 1f 4c 	R6=R3\+\|-R7 ;
 17c:	00 c4 0a 60 	R0=R1\+\|-R2 \(S\);
 180:	00 c4 25 66 	R3=R4\+\|-R5 \(S\);
 184:	00 c4 38 6c 	R6=R7\+\|-R0 \(S\);
 188:	00 c4 13 62 	R1=R2\+\|-R3 \(S\);
 18c:	00 c4 1d 68 	R4=R3\+\|-R5 \(S\);
 190:	00 c4 1f 6c 	R6=R3\+\|-R7 \(S\);
 194:	00 c4 0a 50 	R0=R1\+\|-R2 \(CO\);
 198:	00 c4 25 56 	R3=R4\+\|-R5 \(CO\);
 19c:	00 c4 38 5c 	R6=R7\+\|-R0 \(CO\);
 1a0:	00 c4 13 52 	R1=R2\+\|-R3 \(CO\);
 1a4:	00 c4 1d 58 	R4=R3\+\|-R5 \(CO\);
 1a8:	00 c4 1f 5c 	R6=R3\+\|-R7 \(CO\);
 1ac:	00 c4 0a 70 	R0=R1\+\|-R2 \(SCO\);
 1b0:	00 c4 25 76 	R3=R4\+\|-R5 \(SCO\);
 1b4:	00 c4 38 7c 	R6=R7\+\|-R0 \(SCO\);
 1b8:	00 c4 13 72 	R1=R2\+\|-R3 \(SCO\);
 1bc:	00 c4 1d 78 	R4=R3\+\|-R5 \(SCO\);
 1c0:	00 c4 1f 7c 	R6=R3\+\|-R7 \(SCO\);
 1c4:	00 c4 1e fe 	R7=R3-\|-R6 \(SCO\);
 1c8:	00 c4 0a c0 	R0=R1-\|-R2 ;
 1cc:	00 c4 25 c6 	R3=R4-\|-R5 ;
 1d0:	00 c4 38 cc 	R6=R7-\|-R0 ;
 1d4:	00 c4 13 c2 	R1=R2-\|-R3 ;
 1d8:	00 c4 1d c8 	R4=R3-\|-R5 ;
 1dc:	00 c4 1f cc 	R6=R3-\|-R7 ;
 1e0:	00 c4 0a e0 	R0=R1-\|-R2 \(S\);
 1e4:	00 c4 25 e6 	R3=R4-\|-R5 \(S\);
 1e8:	00 c4 38 ec 	R6=R7-\|-R0 \(S\);
 1ec:	00 c4 13 e2 	R1=R2-\|-R3 \(S\);
 1f0:	00 c4 1d e8 	R4=R3-\|-R5 \(S\);
 1f4:	00 c4 1f ec 	R6=R3-\|-R7 \(S\);
 1f8:	00 c4 0a d0 	R0=R1-\|-R2 \(CO\);
 1fc:	00 c4 25 d6 	R3=R4-\|-R5 \(CO\);
 200:	00 c4 38 dc 	R6=R7-\|-R0 \(CO\);
 204:	00 c4 13 d2 	R1=R2-\|-R3 \(CO\);
 208:	00 c4 1d d8 	R4=R3-\|-R5 \(CO\);
 20c:	00 c4 1f dc 	R6=R3-\|-R7 \(CO\);
 210:	00 c4 0a f0 	R0=R1-\|-R2 \(SCO\);
 214:	00 c4 25 f6 	R3=R4-\|-R5 \(SCO\);
 218:	00 c4 38 fc 	R6=R7-\|-R0 \(SCO\);
 21c:	00 c4 13 f2 	R1=R2-\|-R3 \(SCO\);
 220:	00 c4 1d f8 	R4=R3-\|-R5 \(SCO\);
 224:	00 c4 1f fc 	R6=R3-\|-R7 \(SCO\);
 228:	01 c4 5c 0f 	R5=R3\+\|\+R4,R7=R3-\|-R4;
 22c:	01 c4 0a 0e 	R0=R1\+\|\+R2,R7=R1-\|-R2;
 230:	01 c4 e5 0c 	R3=R4\+\|\+R5,R6=R4-\|-R5;
 234:	01 c4 b8 0b 	R6=R7\+\|\+R0,R5=R7-\|-R0;
 238:	01 c4 53 08 	R1=R2\+\|\+R3,R4=R2-\|-R3;
 23c:	01 c4 1d 07 	R4=R3\+\|\+R5,R3=R3-\|-R5;
 240:	01 c4 9f 05 	R6=R3\+\|\+R7,R2=R3-\|-R7;
 244:	01 c4 0a 2e 	R0=R1\+\|\+R2,R7=R1-\|-R2\(S\);
 248:	01 c4 e5 2c 	R3=R4\+\|\+R5,R6=R4-\|-R5\(S\);
 24c:	01 c4 b8 2b 	R6=R7\+\|\+R0,R5=R7-\|-R0\(S\);
 250:	01 c4 53 28 	R1=R2\+\|\+R3,R4=R2-\|-R3\(S\);
 254:	01 c4 1d 27 	R4=R3\+\|\+R5,R3=R3-\|-R5\(S\);
 258:	01 c4 9f 25 	R6=R3\+\|\+R7,R2=R3-\|-R7\(S\);
 25c:	01 c4 0a 1e 	R0=R1\+\|\+R2,R7=R1-\|-R2\(CO\);
 260:	01 c4 e5 1c 	R3=R4\+\|\+R5,R6=R4-\|-R5\(CO\);
 264:	01 c4 b8 1b 	R6=R7\+\|\+R0,R5=R7-\|-R0\(CO\);
 268:	01 c4 53 18 	R1=R2\+\|\+R3,R4=R2-\|-R3\(CO\);
 26c:	01 c4 1d 17 	R4=R3\+\|\+R5,R3=R3-\|-R5\(CO\);
 270:	01 c4 9f 15 	R6=R3\+\|\+R7,R2=R3-\|-R7\(CO\);
 274:	01 c4 0a 3e 	R0=R1\+\|\+R2,R7=R1-\|-R2\(SCO\);
 278:	01 c4 e5 3c 	R3=R4\+\|\+R5,R6=R4-\|-R5\(SCO\);
 27c:	01 c4 b8 3b 	R6=R7\+\|\+R0,R5=R7-\|-R0\(SCO\);
 280:	01 c4 53 38 	R1=R2\+\|\+R3,R4=R2-\|-R3\(SCO\);
 284:	01 c4 1d 37 	R4=R3\+\|\+R5,R3=R3-\|-R5\(SCO\);
 288:	01 c4 9f 35 	R6=R3\+\|\+R7,R2=R3-\|-R7\(SCO\);
 28c:	01 c4 0a 8e 	R0=R1\+\|\+R2,R7=R1-\|-R2\(ASR\);
 290:	01 c4 e5 8c 	R3=R4\+\|\+R5,R6=R4-\|-R5\(ASR\);
 294:	01 c4 b8 8b 	R6=R7\+\|\+R0,R5=R7-\|-R0\(ASR\);
 298:	01 c4 53 88 	R1=R2\+\|\+R3,R4=R2-\|-R3\(ASR\);
 29c:	01 c4 1d 87 	R4=R3\+\|\+R5,R3=R3-\|-R5\(ASR\);
 2a0:	01 c4 9f 85 	R6=R3\+\|\+R7,R2=R3-\|-R7\(ASR\);
 2a4:	01 c4 0a ce 	R0=R1\+\|\+R2,R7=R1-\|-R2\(ASL\);
 2a8:	01 c4 e5 cc 	R3=R4\+\|\+R5,R6=R4-\|-R5\(ASL\);
 2ac:	01 c4 b8 cb 	R6=R7\+\|\+R0,R5=R7-\|-R0\(ASL\);
 2b0:	01 c4 53 c8 	R1=R2\+\|\+R3,R4=R2-\|-R3\(ASL\);
 2b4:	01 c4 1d c7 	R4=R3\+\|\+R5,R3=R3-\|-R5\(ASL\);
 2b8:	01 c4 9f c5 	R6=R3\+\|\+R7,R2=R3-\|-R7\(ASL\);
 2bc:	01 c4 0a ae 	R0=R1\+\|\+R2,R7=R1-\|-R2\(S,ASR\);
 2c0:	01 c4 e5 ac 	R3=R4\+\|\+R5,R6=R4-\|-R5\(S,ASR\);
 2c4:	01 c4 b8 ab 	R6=R7\+\|\+R0,R5=R7-\|-R0\(S,ASR\);
 2c8:	01 c4 53 a8 	R1=R2\+\|\+R3,R4=R2-\|-R3\(S,ASR\);
 2cc:	01 c4 1d a7 	R4=R3\+\|\+R5,R3=R3-\|-R5\(S,ASR\);
 2d0:	01 c4 9f a5 	R6=R3\+\|\+R7,R2=R3-\|-R7\(S,ASR\);
 2d4:	01 c4 0a 9e 	R0=R1\+\|\+R2,R7=R1-\|-R2\(CO,ASR\);
 2d8:	01 c4 e5 9c 	R3=R4\+\|\+R5,R6=R4-\|-R5\(CO,ASR\);
 2dc:	01 c4 b8 9b 	R6=R7\+\|\+R0,R5=R7-\|-R0\(CO,ASR\);
 2e0:	01 c4 53 98 	R1=R2\+\|\+R3,R4=R2-\|-R3\(CO,ASR\);
 2e4:	01 c4 1d 97 	R4=R3\+\|\+R5,R3=R3-\|-R5\(CO,ASR\);
 2e8:	01 c4 9f 95 	R6=R3\+\|\+R7,R2=R3-\|-R7\(CO,ASR\);
 2ec:	01 c4 0a be 	R0=R1\+\|\+R2,R7=R1-\|-R2\(SCO,ASR\);
 2f0:	01 c4 e5 bc 	R3=R4\+\|\+R5,R6=R4-\|-R5\(SCO,ASR\);
 2f4:	01 c4 b8 bb 	R6=R7\+\|\+R0,R5=R7-\|-R0\(SCO,ASR\);
 2f8:	01 c4 53 b8 	R1=R2\+\|\+R3,R4=R2-\|-R3\(SCO,ASR\);
 2fc:	01 c4 1d b7 	R4=R3\+\|\+R5,R3=R3-\|-R5\(SCO,ASR\);
 300:	01 c4 9f b5 	R6=R3\+\|\+R7,R2=R3-\|-R7\(SCO,ASR\);
 304:	01 c4 0a ee 	R0=R1\+\|\+R2,R7=R1-\|-R2\(S,ASL\);
 308:	01 c4 e5 ec 	R3=R4\+\|\+R5,R6=R4-\|-R5\(S,ASL\);
 30c:	01 c4 b8 eb 	R6=R7\+\|\+R0,R5=R7-\|-R0\(S,ASL\);
 310:	01 c4 53 e8 	R1=R2\+\|\+R3,R4=R2-\|-R3\(S,ASL\);
 314:	01 c4 1d e7 	R4=R3\+\|\+R5,R3=R3-\|-R5\(S,ASL\);
 318:	01 c4 9f e5 	R6=R3\+\|\+R7,R2=R3-\|-R7\(S,ASL\);
 31c:	01 c4 0a de 	R0=R1\+\|\+R2,R7=R1-\|-R2\(CO,ASL\);
 320:	01 c4 e5 dc 	R3=R4\+\|\+R5,R6=R4-\|-R5\(CO,ASL\);
 324:	01 c4 b8 db 	R6=R7\+\|\+R0,R5=R7-\|-R0\(CO,ASL\);
 328:	01 c4 53 d8 	R1=R2\+\|\+R3,R4=R2-\|-R3\(CO,ASL\);
 32c:	01 c4 1d d7 	R4=R3\+\|\+R5,R3=R3-\|-R5\(CO,ASL\);
 330:	01 c4 9f d5 	R6=R3\+\|\+R7,R2=R3-\|-R7\(CO,ASL\);
 334:	01 c4 0a fe 	R0=R1\+\|\+R2,R7=R1-\|-R2\(SCO,ASL\);
 338:	01 c4 e5 fc 	R3=R4\+\|\+R5,R6=R4-\|-R5\(SCO,ASL\);
 33c:	01 c4 b8 fb 	R6=R7\+\|\+R0,R5=R7-\|-R0\(SCO,ASL\);
 340:	01 c4 53 f8 	R1=R2\+\|\+R3,R4=R2-\|-R3\(SCO,ASL\);
 344:	01 c4 1d f7 	R4=R3\+\|\+R5,R3=R3-\|-R5\(SCO,ASL\);
 348:	01 c4 9f f5 	R6=R3\+\|\+R7,R2=R3-\|-R7\(SCO,ASL\);
 34c:	21 c4 5c 0f 	R5=R3\+\|-R4,R7=R3-\|\+R4;
 350:	21 c4 0a 0e 	R0=R1\+\|-R2,R7=R1-\|\+R2;
 354:	21 c4 e5 0c 	R3=R4\+\|-R5,R6=R4-\|\+R5;
 358:	21 c4 b8 0b 	R6=R7\+\|-R0,R5=R7-\|\+R0;
 35c:	21 c4 53 08 	R1=R2\+\|-R3,R4=R2-\|\+R3;
 360:	21 c4 1d 07 	R4=R3\+\|-R5,R3=R3-\|\+R5;
 364:	21 c4 9f 05 	R6=R3\+\|-R7,R2=R3-\|\+R7;
 368:	21 c4 0a 2e 	R0=R1\+\|-R2,R7=R1-\|\+R2\(S\);
 36c:	21 c4 e5 2c 	R3=R4\+\|-R5,R6=R4-\|\+R5\(S\);
 370:	21 c4 b8 2b 	R6=R7\+\|-R0,R5=R7-\|\+R0\(S\);
 374:	21 c4 53 28 	R1=R2\+\|-R3,R4=R2-\|\+R3\(S\);
 378:	21 c4 1d 27 	R4=R3\+\|-R5,R3=R3-\|\+R5\(S\);
 37c:	21 c4 9f 25 	R6=R3\+\|-R7,R2=R3-\|\+R7\(S\);
 380:	21 c4 0a 1e 	R0=R1\+\|-R2,R7=R1-\|\+R2\(CO\);
 384:	21 c4 e5 1c 	R3=R4\+\|-R5,R6=R4-\|\+R5\(CO\);
 388:	21 c4 b8 1b 	R6=R7\+\|-R0,R5=R7-\|\+R0\(CO\);
 38c:	21 c4 53 18 	R1=R2\+\|-R3,R4=R2-\|\+R3\(CO\);
 390:	21 c4 1d 17 	R4=R3\+\|-R5,R3=R3-\|\+R5\(CO\);
 394:	21 c4 9f 15 	R6=R3\+\|-R7,R2=R3-\|\+R7\(CO\);
 398:	21 c4 0a 3e 	R0=R1\+\|-R2,R7=R1-\|\+R2\(SCO\);
 39c:	21 c4 e5 3c 	R3=R4\+\|-R5,R6=R4-\|\+R5\(SCO\);
 3a0:	21 c4 b8 3b 	R6=R7\+\|-R0,R5=R7-\|\+R0\(SCO\);
 3a4:	21 c4 53 38 	R1=R2\+\|-R3,R4=R2-\|\+R3\(SCO\);
 3a8:	21 c4 1d 37 	R4=R3\+\|-R5,R3=R3-\|\+R5\(SCO\);
 3ac:	21 c4 9f 35 	R6=R3\+\|-R7,R2=R3-\|\+R7\(SCO\);
 3b0:	21 c4 0a 8e 	R0=R1\+\|-R2,R7=R1-\|\+R2\(ASR\);
 3b4:	21 c4 e5 8c 	R3=R4\+\|-R5,R6=R4-\|\+R5\(ASR\);
 3b8:	21 c4 b8 8b 	R6=R7\+\|-R0,R5=R7-\|\+R0\(ASR\);
 3bc:	21 c4 53 88 	R1=R2\+\|-R3,R4=R2-\|\+R3\(ASR\);
 3c0:	21 c4 1d 87 	R4=R3\+\|-R5,R3=R3-\|\+R5\(ASR\);
 3c4:	21 c4 9f 85 	R6=R3\+\|-R7,R2=R3-\|\+R7\(ASR\);
 3c8:	21 c4 0a ce 	R0=R1\+\|-R2,R7=R1-\|\+R2\(ASL\);
 3cc:	21 c4 e5 cc 	R3=R4\+\|-R5,R6=R4-\|\+R5\(ASL\);
 3d0:	21 c4 b8 cb 	R6=R7\+\|-R0,R5=R7-\|\+R0\(ASL\);
 3d4:	21 c4 53 c8 	R1=R2\+\|-R3,R4=R2-\|\+R3\(ASL\);
 3d8:	21 c4 1d c7 	R4=R3\+\|-R5,R3=R3-\|\+R5\(ASL\);
 3dc:	21 c4 9f c5 	R6=R3\+\|-R7,R2=R3-\|\+R7\(ASL\);
 3e0:	21 c4 0a ae 	R0=R1\+\|-R2,R7=R1-\|\+R2\(S,ASR\);
 3e4:	21 c4 e5 ac 	R3=R4\+\|-R5,R6=R4-\|\+R5\(S,ASR\);
 3e8:	21 c4 b8 ab 	R6=R7\+\|-R0,R5=R7-\|\+R0\(S,ASR\);
 3ec:	21 c4 53 a8 	R1=R2\+\|-R3,R4=R2-\|\+R3\(S,ASR\);
 3f0:	21 c4 1d a7 	R4=R3\+\|-R5,R3=R3-\|\+R5\(S,ASR\);
 3f4:	21 c4 9f a5 	R6=R3\+\|-R7,R2=R3-\|\+R7\(S,ASR\);
 3f8:	21 c4 0a 9e 	R0=R1\+\|-R2,R7=R1-\|\+R2\(CO,ASR\);
 3fc:	21 c4 e5 9c 	R3=R4\+\|-R5,R6=R4-\|\+R5\(CO,ASR\);
 400:	21 c4 b8 9b 	R6=R7\+\|-R0,R5=R7-\|\+R0\(CO,ASR\);
 404:	21 c4 53 98 	R1=R2\+\|-R3,R4=R2-\|\+R3\(CO,ASR\);
 408:	21 c4 1d 97 	R4=R3\+\|-R5,R3=R3-\|\+R5\(CO,ASR\);
 40c:	21 c4 9f 95 	R6=R3\+\|-R7,R2=R3-\|\+R7\(CO,ASR\);
 410:	21 c4 0a be 	R0=R1\+\|-R2,R7=R1-\|\+R2\(SCO,ASR\);
 414:	21 c4 e5 bc 	R3=R4\+\|-R5,R6=R4-\|\+R5\(SCO,ASR\);
 418:	21 c4 b8 bb 	R6=R7\+\|-R0,R5=R7-\|\+R0\(SCO,ASR\);
 41c:	21 c4 53 b8 	R1=R2\+\|-R3,R4=R2-\|\+R3\(SCO,ASR\);
 420:	21 c4 1d b7 	R4=R3\+\|-R5,R3=R3-\|\+R5\(SCO,ASR\);
 424:	21 c4 9f b5 	R6=R3\+\|-R7,R2=R3-\|\+R7\(SCO,ASR\);
 428:	21 c4 0a ee 	R0=R1\+\|-R2,R7=R1-\|\+R2\(S,ASL\);
 42c:	21 c4 e5 ec 	R3=R4\+\|-R5,R6=R4-\|\+R5\(S,ASL\);
 430:	21 c4 b8 eb 	R6=R7\+\|-R0,R5=R7-\|\+R0\(S,ASL\);
 434:	21 c4 53 e8 	R1=R2\+\|-R3,R4=R2-\|\+R3\(S,ASL\);
 438:	21 c4 1d e7 	R4=R3\+\|-R5,R3=R3-\|\+R5\(S,ASL\);
 43c:	21 c4 9f e5 	R6=R3\+\|-R7,R2=R3-\|\+R7\(S,ASL\);
 440:	21 c4 0a de 	R0=R1\+\|-R2,R7=R1-\|\+R2\(CO,ASL\);
 444:	21 c4 e5 dc 	R3=R4\+\|-R5,R6=R4-\|\+R5\(CO,ASL\);
 448:	21 c4 b8 db 	R6=R7\+\|-R0,R5=R7-\|\+R0\(CO,ASL\);
 44c:	21 c4 53 d8 	R1=R2\+\|-R3,R4=R2-\|\+R3\(CO,ASL\);
 450:	21 c4 1d d7 	R4=R3\+\|-R5,R3=R3-\|\+R5\(CO,ASL\);
 454:	21 c4 9f d5 	R6=R3\+\|-R7,R2=R3-\|\+R7\(CO,ASL\);
 458:	21 c4 0a fe 	R0=R1\+\|-R2,R7=R1-\|\+R2\(SCO,ASL\);
 45c:	21 c4 e5 fc 	R3=R4\+\|-R5,R6=R4-\|\+R5\(SCO,ASL\);
 460:	21 c4 b8 fb 	R6=R7\+\|-R0,R5=R7-\|\+R0\(SCO,ASL\);
 464:	21 c4 53 f8 	R1=R2\+\|-R3,R4=R2-\|\+R3\(SCO,ASL\);
 468:	21 c4 1d f7 	R4=R3\+\|-R5,R3=R3-\|\+R5\(SCO,ASL\);
 46c:	21 c4 9f f5 	R6=R3\+\|-R7,R2=R3-\|\+R7\(SCO,ASL\);
 470:	04 c4 81 86 	R2=R0\+R1,R3=R0-R1 \(NS\);
 474:	04 c4 c1 81 	R7=R0\+R1,R0=R0-R1 \(NS\);
 478:	04 c4 8a 83 	R6=R1\+R2,R1=R1-R2 \(NS\);
 47c:	04 c4 53 85 	R5=R2\+R3,R2=R2-R3 \(NS\);
 480:	04 c4 1c 87 	R4=R3\+R4,R3=R3-R4 \(NS\);
 484:	04 c4 e5 88 	R3=R4\+R5,R4=R4-R5 \(NS\);
 488:	04 c4 ae 8a 	R2=R5\+R6,R5=R5-R6 \(NS\);
 48c:	04 c4 77 8c 	R1=R6\+R7,R6=R6-R7 \(NS\);
 490:	04 c4 38 8e 	R0=R7\+R0,R7=R7-R0 \(NS\);
 494:	04 c4 81 a6 	R2=R0\+R1,R3=R0-R1 \(S\);
 498:	04 c4 c1 a1 	R7=R0\+R1,R0=R0-R1 \(S\);
 49c:	04 c4 8a a3 	R6=R1\+R2,R1=R1-R2 \(S\);
 4a0:	04 c4 53 a5 	R5=R2\+R3,R2=R2-R3 \(S\);
 4a4:	04 c4 1c a7 	R4=R3\+R4,R3=R3-R4 \(S\);
 4a8:	04 c4 e5 a8 	R3=R4\+R5,R4=R4-R5 \(S\);
 4ac:	04 c4 ae aa 	R2=R5\+R6,R5=R5-R6 \(S\);
 4b0:	04 c4 77 ac 	R1=R6\+R7,R6=R6-R7 \(S\);
 4b4:	04 c4 38 ae 	R0=R7\+R0,R7=R7-R0 \(S\);
 4b8:	11 c4 [0-3][[:xdigit:]] 02 	R0=A1\+A0,R1=A1-A0 \(NS\);
 4bc:	11 c4 [8|9|a|b][[:xdigit:]] 06 	R2=A1\+A0,R3=A1-A0 \(NS\);
 4c0:	11 c4 [0-3][[:xdigit:]] 0b 	R4=A1\+A0,R5=A1-A0 \(NS\);
 4c4:	11 c4 [8|9|a|b][[:xdigit:]] 0f 	R6=A1\+A0,R7=A1-A0 \(NS\);
 4c8:	11 c4 [4-7][[:xdigit:]] 00 	R1=A1\+A0,R0=A1-A0 \(NS\);
 4cc:	11 c4 [c-f][[:xdigit:]] 04 	R3=A1\+A0,R2=A1-A0 \(NS\);
 4d0:	11 c4 [4-7][[:xdigit:]] 09 	R5=A1\+A0,R4=A1-A0 \(NS\);
 4d4:	11 c4 [0-3][[:xdigit:]] 22 	R0=A1\+A0,R1=A1-A0 \(S\);
 4d8:	11 c4 [8|9|a|b][[:xdigit:]] 26 	R2=A1\+A0,R3=A1-A0 \(S\);
 4dc:	11 c4 [0-3][[:xdigit:]] 2b 	R4=A1\+A0,R5=A1-A0 \(S\);
 4e0:	11 c4 [8|9|a|b][[:xdigit:]] 2f 	R6=A1\+A0,R7=A1-A0 \(S\);
 4e4:	11 c4 [4-7][[:xdigit:]] 20 	R1=A1\+A0,R0=A1-A0 \(S\);
 4e8:	11 c4 [c-f][[:xdigit:]] 24 	R3=A1\+A0,R2=A1-A0 \(S\);
 4ec:	11 c4 [4-7][[:xdigit:]] 29 	R5=A1\+A0,R4=A1-A0 \(S\);
 4f0:	11 c4 [0-3][[:xdigit:]] 6d 	R4=A0\+A1,R6=A0-A1 \(S\);
 4f4:	11 c4 [0-3][[:xdigit:]] 42 	R0=A0\+A1,R1=A0-A1 \(NS\);
 4f8:	11 c4 [8|9|a|b][[:xdigit:]] 46 	R2=A0\+A1,R3=A0-A1 \(NS\);
 4fc:	11 c4 [0-3][[:xdigit:]] 4b 	R4=A0\+A1,R5=A0-A1 \(NS\);
 500:	11 c4 [8|9|a|b][[:xdigit:]] 4f 	R6=A0\+A1,R7=A0-A1 \(NS\);
 504:	11 c4 [4-7][[:xdigit:]] 40 	R1=A0\+A1,R0=A0-A1 \(NS\);
 508:	11 c4 [c-f][[:xdigit:]] 44 	R3=A0\+A1,R2=A0-A1 \(NS\);
 50c:	11 c4 [4-7][[:xdigit:]] 49 	R5=A0\+A1,R4=A0-A1 \(NS\);
 510:	11 c4 [0-3][[:xdigit:]] 62 	R0=A0\+A1,R1=A0-A1 \(S\);
 514:	11 c4 [8|9|a|b][[:xdigit:]] 66 	R2=A0\+A1,R3=A0-A1 \(S\);
 518:	11 c4 [0-3][[:xdigit:]] 6b 	R4=A0\+A1,R5=A0-A1 \(S\);
 51c:	11 c4 [8|9|a|b][[:xdigit:]] 6f 	R6=A0\+A1,R7=A0-A1 \(S\);
 520:	11 c4 [4-7][[:xdigit:]] 60 	R1=A0\+A1,R0=A0-A1 \(S\);
 524:	11 c4 [c-f][[:xdigit:]] 64 	R3=A0\+A1,R2=A0-A1 \(S\);
 528:	11 c4 [4-7][[:xdigit:]] 69 	R5=A0\+A1,R4=A0-A1 \(S\);
 52c:	81 c6 d8 01 	R0=R0>>>0x5 \(V\);
 530:	81 c6 d9 01 	R0=R1>>>0x5 \(V\);
 534:	81 c6 db 05 	R2=R3>>>0x5 \(V\);
 538:	81 c6 dd 09 	R4=R5>>>0x5 \(V\);
 53c:	81 c6 df 0d 	R6=R7>>>0x5 \(V\);
 540:	81 c6 d8 03 	R1=R0>>>0x5 \(V\);
 544:	81 c6 da 07 	R3=R2>>>0x5 \(V\);
 548:	81 c6 dc 0b 	R5=R4>>>0x5 \(V\);
 54c:	81 c6 de 0f 	R7=R6>>>0x5 \(V\);
 550:	81 c6 29 40 	R0=R1<<0x5 \(V, S\);
 554:	81 c6 2b 44 	R2=R3<<0x5 \(V, S\);
 558:	81 c6 2d 48 	R4=R5<<0x5 \(V, S\);
 55c:	81 c6 2f 4c 	R6=R7<<0x5 \(V, S\);
 560:	81 c6 28 42 	R1=R0<<0x5 \(V, S\);
 564:	81 c6 2a 46 	R3=R2<<0x5 \(V, S\);
 568:	81 c6 2c 4a 	R5=R4<<0x5 \(V, S\);
 56c:	81 c6 2e 4e 	R7=R6<<0x5 \(V, S\);
 570:	01 c6 2f 04 	R2= ASHIFT R7 BY R5.L\(V\);
 574:	01 c6 11 00 	R0= ASHIFT R1 BY R2.L\(V\);
 578:	01 c6 2c 06 	R3= ASHIFT R4 BY R5.L\(V\);
 57c:	01 c6 07 0c 	R6= ASHIFT R7 BY R0.L\(V\);
 580:	01 c6 1a 02 	R1= ASHIFT R2 BY R3.L\(V\);
 584:	01 c6 35 08 	R4= ASHIFT R5 BY R6.L\(V\);
 588:	01 c6 08 0e 	R7= ASHIFT R0 BY R1.L\(V\);
 58c:	01 c6 23 04 	R2= ASHIFT R3 BY R4.L\(V\);
 590:	01 c6 3e 0a 	R5= ASHIFT R6 BY R7.L\(V\);
 594:	01 c6 11 40 	R0= ASHIFT R1 BY R2.L\(V,S\);
 598:	01 c6 2c 46 	R3= ASHIFT R4 BY R5.L\(V,S\);
 59c:	01 c6 07 4c 	R6= ASHIFT R7 BY R0.L\(V,S\);
 5a0:	01 c6 1a 42 	R1= ASHIFT R2 BY R3.L\(V,S\);
 5a4:	01 c6 35 48 	R4= ASHIFT R5 BY R6.L\(V,S\);
 5a8:	01 c6 08 4e 	R7= ASHIFT R0 BY R1.L\(V,S\);
 5ac:	01 c6 23 44 	R2= ASHIFT R3 BY R4.L\(V,S\);
 5b0:	01 c6 3e 4a 	R5= ASHIFT R6 BY R7.L\(V,S\);
 5b4:	81 c6 d9 81 	R0=R1 >> 0x5 \(V\);
 5b8:	81 c6 db 85 	R2=R3 >> 0x5 \(V\);
 5bc:	81 c6 dd 89 	R4=R5 >> 0x5 \(V\);
 5c0:	81 c6 df 8d 	R6=R7 >> 0x5 \(V\);
 5c4:	81 c6 d8 83 	R1=R0 >> 0x5 \(V\);
 5c8:	81 c6 da 87 	R3=R2 >> 0x5 \(V\);
 5cc:	81 c6 dc 8b 	R5=R4 >> 0x5 \(V\);
 5d0:	81 c6 de 8f 	R7=R6 >> 0x5 \(V\);
 5d4:	81 c6 29 80 	R0=R1<<0x5 \(V\);
 5d8:	81 c6 2b 84 	R2=R3<<0x5 \(V\);
 5dc:	81 c6 2d 88 	R4=R5<<0x5 \(V\);
 5e0:	81 c6 2f 8c 	R6=R7<<0x5 \(V\);
 5e4:	81 c6 28 82 	R1=R0<<0x5 \(V\);
 5e8:	81 c6 2a 86 	R3=R2<<0x5 \(V\);
 5ec:	81 c6 2c 8a 	R5=R4<<0x5 \(V\);
 5f0:	81 c6 2e 8e 	R7=R6<<0x5 \(V\);
 5f4:	01 c6 11 80 	R0=SHIFT R1 BY R2.L\(V\);
 5f8:	01 c6 2c 86 	R3=SHIFT R4 BY R5.L\(V\);
 5fc:	01 c6 07 8c 	R6=SHIFT R7 BY R0.L\(V\);
 600:	01 c6 1a 82 	R1=SHIFT R2 BY R3.L\(V\);
 604:	01 c6 35 88 	R4=SHIFT R5 BY R6.L\(V\);
 608:	01 c6 08 8e 	R7=SHIFT R0 BY R1.L\(V\);
 60c:	01 c6 23 84 	R2=SHIFT R3 BY R4.L\(V\);
 610:	01 c6 3e 8a 	R5=SHIFT R6 BY R7.L\(V\);
 614:	06 c4 08 0e 	R7=MAX\(R1,R0\)\(V\);
 618:	06 c4 0a 00 	R0=MAX\(R1,R2\)\(V\);
 61c:	06 c4 25 06 	R3=MAX\(R4,R5\)\(V\);
 620:	06 c4 38 0c 	R6=MAX\(R7,R0\)\(V\);
 624:	06 c4 13 02 	R1=MAX\(R2,R3\)\(V\);
 628:	06 c4 2e 08 	R4=MAX\(R5,R6\)\(V\);
 62c:	06 c4 01 0e 	R7=MAX\(R0,R1\)\(V\);
 630:	06 c4 1c 04 	R2=MAX\(R3,R4\)\(V\);
 634:	06 c4 37 0a 	R5=MAX\(R6,R7\)\(V\);
 638:	06 c4 0a 40 	R0=MIN\(R1,R2\)\(V\);
 63c:	06 c4 25 46 	R3=MIN\(R4,R5\)\(V\);
 640:	06 c4 38 4c 	R6=MIN\(R7,R0\)\(V\);
 644:	06 c4 13 42 	R1=MIN\(R2,R3\)\(V\);
 648:	06 c4 2e 48 	R4=MIN\(R5,R6\)\(V\);
 64c:	06 c4 01 4e 	R7=MIN\(R0,R1\)\(V\);
 650:	06 c4 1c 44 	R2=MIN\(R3,R4\)\(V\);
 654:	06 c4 37 4a 	R5=MIN\(R6,R7\)\(V\);
 658:	04 c2 be 66 	R2.H = R7.L \* R6.H, R2 = R7.H \* R6.H;
 65c:	04 c2 08 e1 	R4.H = R1.H \* R0.H, R4 = R1.L \* R0.L;
 660:	14 c2 1a a0 	R0.H = R3.H \* R2.L \(M\), R0 = R3.L \* R2.L;
 664:	00 c0 13 46 	a1 = R2.L \* R3.H, a0 = R2.H \* R3.H;
 668:	01 c0 08 c0 	a1 \+= R1.H \* R0.H, a0 = R1.L \* R0.L;
 66c:	01 c0 1b 96 	a1 \+= R3.H \* R3.L, a0 -= R3.H \* R3.H;
 670:	10 c0 1a 88 	a1 = R3.H \* R2.L \(M\), a0 \+= R3.L \* R2.L;
 674:	90 c0 3c c8 	a1 = R7.H \* R4.H \(M\), a0 \+= R7.L \* R4.L \(FU\);
 678:	01 c1 1a c0 	a1 \+= R3.H \* R2.H, a0 = R3.L \* R2.L \(IS\);
 67c:	60 c0 37 c8 	a1 = R6.H \* R7.H, a0 \+= R6.L \* R7.L \(W32\);
 680:	04 c0 be 66 	R2.H = \(a1 = R7.L \* R6.H\), R2.L = \(a0 = R7.H \* R6.H\);
 684:	05 c0 08 e1 	R4.H = \(a1 \+= R1.H \* R0.H\), R4.L = \(a0 = R1.L \* R0.L\);
 688:	05 c0 f5 a7 	R7.H = \(a1 \+= R6.H \* R5.L\), R7.L = \(a0 = R6.H \* R5.H\);
 68c:	14 c0 3c a8 	R0.H = \(a1 = R7.H \* R4.L\) \(M\), R0.L = \(a0 \+= R7.L \* R4.L\);
 690:	94 c0 5a e9 	R5.H = \(a1 = R3.H \* R2.H\) \(M\), R5.L = \(a0 \+= R3.L \* R2.L\) \(FU\);
 694:	05 c1 1a e0 	R0.H = \(a1 \+= R3.H \* R2.H\), R0.L = \(a0 = R3.L \* R2.L\) \(IS\);
 698:	04 c0 51 c9 	R5.H = \(a1 = R2.H \* R1.H\), a0 \+= R2.L \* R1.L;
 69c:	14 c0 d1 c0 	R3.H = \(a1 = R2.H \* R1.H\) \(M\), a0 = R2.L \* R1.L;
 6a0:	27 c0 c1 28 	R3.H = A1, R3.L = \(a0 \+= R0.L \* R1.L\) \(S2RND\);
 6a4:	25 c1 3e e8 	R0.H = \(a1 \+= R7.H \* R6.H\), R0.L = \(a0 \+= R7.L \* R6.L\) \(ISS2\);
 6a8:	0c c0 b7 e0 	R3 = \(a1 = R6.H \* R7.H\), R2 = \(a0 = R6.L \* R7.L\);
 6ac:	0d c0 37 e1 	R5 = \(a1 \+= R6.H \* R7.H\), R4 = \(a0 = R6.L \* R7.L\);
 6b0:	0d c0 9d f1 	R7 = \(a1 \+= R3.H \* R5.H\), R6 = \(a0 -= R3.L \* R5.L\);
 6b4:	1c c0 3c 2e 	R1 = \(a1 = R7.L \* R4.L\) \(M\), R0 = \(a0 \+= R7.H \* R4.H\);
 6b8:	9c c0 1f e9 	R5 = \(a1 = R3.H \* R7.H\) \(M\), R4 = \(a0 \+= R3.L \* R7.L\) \(FU\);
 6bc:	0d c1 1a e0 	R1 = \(a1 \+= R3.H \* R2.H\), R0 = \(a0 = R3.L \* R2.L\) \(IS\);
 6c0:	0e c0 37 c9 	R5 = \(a1 -= R6.H \* R7.H\), a0 \+= R6.L \* R7.L;
 6c4:	1c c0 b7 d0 	R3 = \(a1 = R6.H \* R7.H\) \(M\), a0 -= R6.L \* R7.L;
 6c8:	2f c0 81 28 	R3 = A1, R2 = \(a0 \+= R0.L \* R1.L\) \(S2RND\);
 6cc:	2d c1 3e e8 	R1 = \(a1 \+= R7.H \* R6.H\), R0 = \(a0 \+= R7.L \* R6.L\) \(ISS2\);
 6d0:	0f c4 18 ca 	R5=-R3\(V\);
 6d4:	04 c6 2c 06 	R3=PACK\(R4.L,R5.L\);
 6d8:	04 c6 26 42 	R1=PACK\(R6.L,R4.H\);
 6dc:	04 c6 22 80 	R0=PACK\(R2.H,R4.L\);
 6e0:	04 c6 17 ca 	R5=PACK\(R7.H,R2.H\);
 6e4:	0d cc 50 c0 	\(R1,R0\) = SEARCH R2\(LE\) \|\| R2=\[P0\+\+\] \|\| NOP;
 6e8:	02 90 00 00 
 6ec:	0d c4 50 c0 	\(R1,R0\) = SEARCH R2\(LE\);
 6f0:	12 cc 02 00 	SAA\(R1:0x0,R3:0x2\)  \|\| R0=\[I0\+\+\] \|\| R2=\[I1\+\+\];
 6f4:	00 9c 0a 9c 
 6f8:	12 cc 02 20 	SAA\(R1:0x0,R3:0x2\) \(R\) \|\| R1=\[I0\+\+\] \|\| R3=\[I1\+\+\];
 6fc:	01 9c 0b 9c 
 700:	03 c8 00 18 	mnop \|\| R1=\[I0\+\+\] \|\| R3=\[I1\+\+\];
 704:	01 9c 0b 9c 
 708:	0c cc 13 0e 	R7.H=R7.L=SIGN\(R2.H\)\*R3.H\+SIGN\(R2.L\)\*R3.L\) \|\| I0\+=M3 \|\| R0=\[I0\];
 70c:	6c 9e 00 9d 
 710:	01 cc 94 88 	R2=R2\+\|\+R4,R4=R2-\|-R4\(ASR\) \|\| I0\+=M0\(BREV\) \|\| R1=\[I0\];
 714:	e0 9e 01 9d 
 718:	00 c8 11 06 	a1 = R2.L \* R1.L, a0 = R2.H \* R1.H \|\| R2.H=W\[I2\+\+\] \|\| \[I3\+\+\]=R3;
 71c:	52 9c 1b 9e 
 720:	01 c8 02 48 	a1 \+= R0.L \* R2.H, a0 \+= R0.L \* R2.L \|\| R2.L=W\[I2\+\+\] \|\| R0=\[I1--\];
 724:	32 9c 88 9c 
 728:	05 c8 c1 68 	R3.H = \(a1 \+= R0.L \* R1.H\), R3.L = \(a0 \+= R0.L \* R1.L\) \|\| R0=\[P0\+\+\] \|\| R1=\[I0\];
 72c:	00 90 01 9d 
 730:	04 ce 01 c2 	R1=PACK\(R1.H,R0.H\) \|\| \[I0\+\+\]=R0 \|\| R2.L=W\[I2\+\+\];
 734:	00 9e 32 9c 
 738:	8b c8 9a 2f 	R6 = \(a0 \+= R3.H \* R2.H\) \(FU\) \|\| I2-=M0 \|\| NOP;
 73c:	72 9e 00 00 
 740:	14 c2 1a a0 	R0.H = R3.H \* R2.L \(M\), R0 = R3.L \* R2.L;
 744:	1c c2 b8 60 	R3 = R7.L \* R0.H \(M\), R2 = R7.L \* R0.L;
 748:	1c c0 b8 60 	R3 = \(a1 = R7.L \* R0.H\) \(M\), R2 = \(a0 = R7.L \* R0.L\);
 74c:	44 c0 23 04 	R0.H = \(a1 = R4.L \* R3.L\), a0 = R4.H \* R3.L \(T\);
 750:	54 c0 23 04 	R0.H = \(a1 = R4.L \* R3.L\) \(M\), a0 = R4.H \* R3.L \(T\);
 754:	44 c0 23 04 	R0.H = \(a1 = R4.L \* R3.L\), a0 = R4.H \* R3.L \(T\);
 758:	54 c0 23 04 	R0.H = \(a1 = R4.L \* R3.L\) \(M\), a0 = R4.H \* R3.L \(T\);

