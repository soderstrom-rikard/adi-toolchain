
../uClinux-dist/user/hello/hello_debug:     file format elf32-bfin

Disassembly of section .text:

00000000 <_start>:
       0:	07 68       	FP=0;
       2:	46 32       	P0=SP;
       4:	00 90       	R0=[P0++];
       6:	48 30       	R1=P0;
       8:	10 30       	R2=R0;
       a:	12 4f       	R2<<=0x2;
       c:	22 64       	R2+=4;
       e:	91 50       	R2=R1+R2;
      10:	a6 6f       	SP+=-12;
      12:	00 e2 ff 00 	JUMP.L  210 <___uClibc_main>;
      16:	00 00       	NOP;
      18:	
00000040 <_func>:
void func()
{
      40:	00 e8 03 00 	LINK0xc;
      44:	a6 6f       	SP+=-12;
	int x, y, z;
        printf("func got called\n");
      46:	00 e1 18 00 	R0.L=24;
      4a:	40 e1 00 00 	R0.H=0;
      4e:	00 e3 ed 00 	CALL  228 <_printf>;
	x = 10;
      52:	50 60       	R0=10(x);
      54:	f0 bb       	[FP--4]=R0;
	y = 20;
      56:	a0 60       	R0=20(x);
      58:	e0 bb       	[FP--8]=R0;
	z = 30;
      5a:	f0 60       	R0=30(x);
      5c:	d0 bb       	[FP--12]=R0;
	printf("called from main");
      5e:	00 e1 2c 00 	R0.L=44;
      62:	40 e1 00 00 	R0.H=0;
      66:	00 e3 e1 00 	CALL  228 <_printf>;
}
      6a:	66 6c       	SP+=12;
      6c:	01 e8 00 00 	UNLINK;
      70:	10 00       	RTS;
      72:	00 00       	NOP;
      74:	
00000088 <_func2>:
int func2(int i)
{
      88:	00 e8 00 00 	LINK0x0;
      8c:	a6 6f       	SP+=-12;
      8e:	b8 b0       	[FP+0x8]=R0;
  printf("func2 got called\n");
      90:	00 e1 74 00 	R0.L=116;
      94:	40 e1 00 00 	R0.H=0;
      98:	00 e3 c8 00 	CALL  228 <_printf>;
  return 2*i;
      9c:	b8 a0       	R0=[FP+0x8];
      9e:	10 32       	P2=R0;
      a0:	92 5a       	P2=P2<<1;
      a2:	42 30       	R0=P2;
}
      a4:	66 6c       	SP+=12;
      a6:	01 e8 00 00 	UNLINK;
      aa:	10 00       	RTS;
      ac:	67 64       	R7+=12;
      ae:	
OFFSET = 98 
62 20       	JUMP.S  172 <___uClibc_init+0x6>;
      b0:	74 65       	R4+=46;
      b2:	
000000b8 <_main>:
int func3(int i, int j);
int func4(int i, int j);
main()
{
      b8:	00 e8 01 00 	LINK0x4;
      bc:	a6 6f       	SP+=-12;
      be:	00 e3 41 0f 	CALL  1f40 <___main>;
int ret;
printf("gdb testing");
      c2:	00 e1 ac 00 	R0.L=172;
      c6:	40 e1 00 00 	R0.H=0;
      ca:	00 e3 af 00 	CALL  228 <_printf>;
func();
      ce:	ff e3 b9 ff 	CALL  40 <_func>;
 ret = func3(1, func2(2));
      d2:	10 60       	R0=2(x);
      d4:	ff e3 da ff 	CALL  88 <_func2>;
      d8:	08 30       	R1=R0;
      da:	08 60       	R0=1(x);
      dc:	00 e3 1a 00 	CALL  110 <_func3>;
      e0:	f0 bb       	[FP--4]=R0;
 ret = func4(func2(ret), ret);
      e2:	f0 b9       	R0=[FP--4];
      e4:	ff e3 d2 ff 	CALL  88 <_func2>;
      e8:	f1 b9       	R1=[FP--4];
      ea:	00 e3 2f 00 	CALL  148 <_func4>;
      ee:	f0 bb       	[FP--4]=R0;
 

return ret;
      f0:	f0 b9       	R0=[FP--4];
}
      f2:	66 6c       	SP+=12;
      f4:	01 e8 00 00 	UNLINK;
      f8:	10 00       	RTS;
      fa:	00 00       	NOP;
      fc:	
00000110 <_func3>:

int func3(int i, int j)
{
     110:	00 e8 00 00 	LINK0x0;
     114:	a6 6f       	SP+=-12;
     116:	b8 b0       	[FP+0x8]=R0;
     118:	f9 b0       	[FP+0xc]=R1;
   printf("func3 got called\n");
     11a:	00 e1 fc 00 	R0.L=252;
     11e:	40 e1 00 00 	R0.H=0;
     122:	00 e3 83 00 	CALL  228 <_printf>;
   return i + j;
     126:	b9 a0       	R1=[FP+0x8];
     128:	f8 a0       	R0=[FP+0xc];
     12a:	01 50       	R0=R1+R0;
}
     12c:	66 6c       	SP+=12;
     12e:	01 e8 00 00 	UNLINK;
     132:	10 00       	RTS;
     134:	
00000148 <_func4>:

int func4(int i, int j)
{
     148:	00 e8 00 00 	LINK0x0;
     14c:	a6 6f       	SP+=-12;
     14e:	b8 b0       	[FP+0x8]=R0;
     150:	f9 b0       	[FP+0xc]=R1;
  printf("func4 got called\n");
     152:	00 e1 34 01 	R0.L=308;
     156:	40 e1 00 00 	R0.H=0;
     15a:	00 e3 67 00 	CALL  228 <_printf>;
  return i*j;
     15e:	b9 a0       	R1=[FP+0x8];
     160:	f8 a0       	R0=[FP+0xc];
     162:	c8 40       	R0*=R1;
}
     164:	66 6c       	SP+=12;
     166:	01 e8 00 00 	UNLINK;
     16a:	10 00       	RTS;

0000016c <___uClibc_init>:
     16c:	00 e8 00 00 	LINK0x0;
     170:	a6 6f       	SP+=-12;
     172:	0a e1 a4 3e 	P2.L=3ea4 <L_been_there_done_that_$0>;
     176:	4a e1 00 00 	P2.H=0 <_start>;
     17a:	10 91       	R0=[P2];
     17c:	00 0c       	CC=R0==0;
     17e:	0b 10       	IF!CCJUMP  194 <___uClibc_init+0x28>;
     180:	08 60       	R0=1(x);
     182:	10 93       	[P2]=R0;
     184:	00 e1 64 02 	R0.L=612;
     188:	40 e1 00 00 	R0.H=0;
     18c:	00 0c       	CC=R0==0;
     18e:	03 18       	IFCCJUMP  194 <___uClibc_init+0x28>;
     190:	00 e3 6a 00 	CALL  264 <__stdio_init>;
     194:	66 6c       	SP+=12;
     196:	01 e8 00 00 	UNLINK;
     19a:	10 00       	RTS;

0000019c <___uClibc_start_main>:
     19c:	00 e8 00 00 	LINK0x0;
     1a0:	f5 05       	[--SP] = ( R7:6, P5:5 );
     1a2:	a6 6f       	SP+=-12;
     1a4:	0a e1 9c 3e 	P2.L=3e9c <___environ>;
     1a8:	4a e1 00 00 	P2.H=0 <_start>;
     1ac:	30 30       	R6=R0;
     1ae:	10 91       	R0=[P2];
     1b0:	29 32       	P5=R1;
     1b2:	3a 30       	R7=R2;
     1b4:	00 0c       	CC=R0==0;
     1b6:	02 10       	IF!CCJUMP  1ba <___uClibc_start_main+0x1e>;
     1b8:	12 93       	[P2]=R2;
     1ba:	ff e3 d9 ff 	CALL  16c <___uClibc_init>;
     1be:	28 91       	R0=[P5];
     1c0:	0a e1 a0 3e 	P2.L=3ea0 <___progname>;
     1c4:	4a e1 00 00 	P2.H=0 <_start>;
     1c8:	10 93       	[P2]=R0;
     1ca:	00 e1 b0 02 	R0.L=688;
     1ce:	40 e1 00 00 	R0.H=0;
     1d2:	00 0c       	CC=R0==0;
     1d4:	06 18       	IFCCJUMP  1e0 <___uClibc_start_main+0x44>;
     1d6:	00 e3 6d 00 	CALL  2b0 <___errno_location>;
     1da:	10 32       	P2=R0;
     1dc:	00 60       	R0=0(x);
     1de:	10 93       	[P2]=R0;
     1e0:	00 e1 c4 02 	R0.L=708;
     1e4:	40 e1 00 00 	R0.H=0;
     1e8:	00 0c       	CC=R0==0;
     1ea:	06 18       	IFCCJUMP  1f6 <___uClibc_start_main+0x5a>;
     1ec:	00 e3 6c 00 	CALL  2c4 <___h_errno_location>;
     1f0:	10 32       	P2=R0;
     1f2:	00 60       	R0=0(x);
     1f4:	10 93       	[P2]=R0;
     1f6:	4d 30       	R1=P5;
     1f8:	17 30       	R2=R7;
     1fa:	06 30       	R0=R6;
     1fc:	ff e3 5e ff 	CALL  b8 <_main>;
     200:	00 e3 6c 00 	CALL  2d8 <_exit>;
     204:	66 6c       	SP+=12;
     206:	b5 05       	( R7:6, P5:5)  = [SP++];
     208:	01 e8 00 00 	UNLINK;
     20c:	10 00       	RTS;
	...

00000210 <___uClibc_main>:
     210:	00 e8 00 00 	LINK0x0;
     214:	66 6f       	SP+=-20;
     216:	03 60       	R3=0(x);
     218:	f3 b0       	[SP+0xc]=R3;
     21a:	33 b1       	[SP+0x10]=R3;
     21c:	ff e3 c0 ff 	CALL  19c <___uClibc_start_main>;
     220:	a6 6c       	SP+=20;
     222:	01 e8 00 00 	UNLINK;
     226:	10 00       	RTS;

00000228 <_printf>:
     228:	00 e8 00 00 	LINK0x0;
     22c:	a6 6f       	SP+=-12;
     22e:	f9 b0       	[FP+0xc]=R1;
     230:	3a b1       	[FP+0x10]=R2;
     232:	08 30       	R1=R0;
     234:	0a e1 18 3f 	P2.L=3f18 <_stdout>;
     238:	4a e1 00 00 	P2.H=0 <_start>;
     23c:	57 30       	R2=FP;
     23e:	10 91       	R0=[P2];
     240:	62 64       	R2+=12;
     242:	00 e3 23 02 	CALL  688 <_vfprintf>;
     246:	66 6c       	SP+=12;
     248:	01 e8 00 00 	UNLINK;
     24c:	10 00       	RTS;
	...

00000250 <__stdio_term>:
     250:	00 e8 00 00 	LINK0x0;
     254:	a6 6f       	SP+=-12;
     256:	00 60       	R0=0(x);
     258:	00 e3 8c 02 	CALL  770 <_fflush>;
     25c:	66 6c       	SP+=12;
     25e:	01 e8 00 00 	UNLINK;
     262:	10 00       	RTS;

00000264 <__stdio_init>:
     264:	00 e8 00 00 	LINK0x0;
     268:	f4 05       	[--SP] = ( R7:6, P5:4 );
     26a:	a6 6f       	SP+=-12;
     26c:	0c e1 28 5f 	P4.L=5f28 <__errno>;
     270:	4c e1 00 00 	P4.H=0 <_start>;
     274:	26 91       	R6=[P4];
     276:	00 60       	R0=0(x);
     278:	00 e3 c4 02 	CALL  800 <_isatty>;
     27c:	0f 60       	R7=1(x);
     27e:	0d e1 a8 3e 	P5.L=3ea8 <__stdio_streams>;
     282:	4d e1 00 00 	P5.H=0 <_start>;
     286:	07 52       	R0=R7-R0;
     288:	69 95       	R1=W[P5](X);
     28a:	40 4f       	R0<<=0x8;
     28c:	08 58       	R0=R0^R1;
     28e:	28 97       	W[P5]=R0;
     290:	08 60       	R0=1(x);
     292:	00 e3 b7 02 	CALL  800 <_isatty>;
     296:	c7 53       	R7=R7-R0;
     298:	68 e5 12 00 	R0=W[P5+36](X);
     29c:	47 4f       	R7<<=0x8;
     29e:	c7 59       	R7=R7^R0;
     2a0:	6f e6 12 00 	W[P5+36]=R7;
     2a4:	26 93       	[P4]=R6;
     2a6:	66 6c       	SP+=12;
     2a8:	b4 05       	( R7:6, P5:4)  = [SP++];
     2aa:	01 e8 00 00 	UNLINK;
     2ae:	10 00       	RTS;

000002b0 <___errno_location>:
     2b0:	00 e8 00 00 	LINK0x0;
     2b4:	00 e1 28 5f 	R0.L=24360;
     2b8:	40 e1 00 00 	R0.H=0;
     2bc:	01 e8 00 00 	UNLINK;
     2c0:	10 00       	RTS;
	...

000002c4 <___h_errno_location>:
     2c4:	00 e8 00 00 	LINK0x0;
     2c8:	00 e1 2c 5f 	R0.L=24364;
     2cc:	40 e1 00 00 	R0.H=0;
     2d0:	01 e8 00 00 	UNLINK;
     2d4:	10 00       	RTS;
	...

000002d8 <_exit>:
     2d8:	00 e8 00 00 	LINK0x0;
     2dc:	78 05       	[--SP] = ( R7:7);
     2de:	a6 6f       	SP+=-12;
     2e0:	0a e1 24 5f 	P2.L=5f24 <___exit_cleanup>;
     2e4:	4a e1 00 00 	P2.H=0 <_start>;
     2e8:	52 91       	P2=[P2];
     2ea:	38 30       	R7=R0;
     2ec:	42 0c       	CC=P2==0;
     2ee:	0c 10       	IF!CCJUMP  306 <_exit+0x2e>;
     2f0:	00 e1 50 02 	R0.L=592;
     2f4:	40 e1 00 00 	R0.H=0;
     2f8:	00 0c       	CC=R0==0;
     2fa:	03 18       	IFCCJUMP  300 <_exit+0x28>;
     2fc:	ff e3 aa ff 	CALL  250 <__stdio_term>;
     300:	07 30       	R0=R7;
     302:	00 e3 8d 02 	CALL  81c <__exit>;
     306:	62 00       	CALL  (P2);
     308:	
OFFSET = 4084 
f4 2f       	JUMP.S  2f0 <_exit+0x18>;
     30a:	66 6c       	SP+=12;
     30c:	38 05       	( R7:7) = [SP++];
     30e:	01 e8 00 00 	UNLINK;
     312:	10 00       	RTS;

00000314 <__fp_out_narrow>:
     314:	00 e8 00 00 	LINK0x0;
     318:	e5 05       	[--SP] = ( R7:4, P5:5 );
     31a:	a6 6f       	SP+=-12;
     31c:	29 30       	R5=R1;
     31e:	21 e1 80 00 	R1=128 (X);
     322:	28 32       	P5=R0;
     324:	4d 54       	R1=R5&R1;
     326:	7c a1       	R4=[FP+0x14];
     328:	3a 30       	R7=R2;
     32a:	04 30       	R0=R4;
     32c:	01 0c       	CC=R1==0;
     32e:	0f 18       	IFCCJUMP  34c <__fp_out_narrow+0x38>;
     330:	00 e3 8e 02 	CALL  84c <_strlen>;
     334:	c7 53       	R7=R7-R0;
     336:	30 30       	R6=R0;
     338:	21 e1 7f 00 	R1=127 (X);
     33c:	4d 54       	R1=R5&R1;
     33e:	17 30       	R2=R7;
     340:	45 30       	R0=P5;
     342:	07 0d       	CC=R7<=0;
     344:	03 18       	IFCCJUMP  34a <__fp_out_narrow+0x36>;
     346:	00 e3 0d 00 	CALL  360 <__charpad>;
     34a:	3e 30       	R7=R6;
     34c:	04 30       	R0=R4;
     34e:	0f 30       	R1=R7;
     350:	55 30       	R2=P5;
     352:	00 e3 b1 02 	CALL  8b4 <__stdio_fwrite>;
     356:	66 6c       	SP+=12;
     358:	a5 05       	( R7:4, P5:5)  = [SP++];
     35a:	01 e8 00 00 	UNLINK;
     35e:	10 00       	RTS;

00000360 <__charpad>:
     360:	00 e8 01 00 	LINK0x4;
     364:	70 05       	[--SP] = ( R7:6);
     366:	a6 6f       	SP+=-12;
     368:	b9 e6 ff ff 	B[FP+-1]=R1;
     36c:	30 30       	R6=R0;
     36e:	3a 30       	R7=R2;
     370:	02 0c       	CC=R2==0;
     372:	0a 18       	IFCCJUMP  386 <__charpad+0x26>;
     374:	47 30       	R0=FP;
     376:	f8 67       	R0+=-1;
     378:	09 60       	R1=1(x);
     37a:	16 30       	R2=R6;
     37c:	00 e3 9c 02 	CALL  8b4 <__stdio_fwrite>;
     380:	ff 67       	R7+=-1;
     382:	07 0c       	CC=R7==0;
     384:	f8 17       	IF!CCJUMP  374 <__charpad+0x14>(BP);
     386:	66 6c       	SP+=12;
     388:	30 05       	( R7:6) = [SP++];
     38a:	01 e8 00 00 	UNLINK;
     38e:	10 00       	RTS;

00000390 <L_spec_base_$0>:
     390:	10 10       	IF!CCJUMP  3b0 <L_prefix_$1+0x18>;
     392:	10 08       	CC=R0==R2;
     394:	0a 0a       	CC=R2<=R1(IU);
     396:	
00000398 <L_prefix_$1>:
     398:	
000003b4 <__do_one_spec>:
     3b4:	00 e8 22 00 	LINK0x88;
     3b8:	e3 05       	[--SP] = ( R7:4, P5:3 );
     3ba:	66 6f       	SP+=-20;
     3bc:	18 32       	P3=R0;
     3be:	29 32       	P5=R1;
     3c0:	3a b1       	[FP+0x10]=R2;
     3c2:	01 30       	R0=R1;
     3c4:	00 e3 ce 03 	CALL  b60 <__ppfs_parsespec>;
     3c8:	45 30       	R0=P5;
     3ca:	00 e3 5d 05 	CALL  e84 <__ppfs_setargs>;
     3ce:	ae e4 26 00 	R6=B[P5+38] (Z);
     3d2:	00 61       	R0=32(x);
     3d4:	0e 32       	P1=R6;
     3d6:	2a e1 50 00 	P2=80 (X);
     3da:	b8 e6 7b ff 	B[FP+-133]=R0;
     3de:	0d 5e       	P0=P5+(P1<<2);
     3e0:	95 5a       	P2=P5+P2;
     3e2:	a8 a1       	R0=[P5+0x18];
     3e4:	52 30       	R2=P2;
     3e6:	05 60       	R5=0(x);
     3e8:	5c 68       	P4=11;
     3ea:	20 6d       	P0+=36;
     3ec:	00 0d       	CC=R0<=0;
     3ee:	04 18       	IFCCJUMP  3f6 <__do_one_spec+0x42>;
     3f0:	1e 4f       	R6<<=0x3;
     3f2:	b2 50       	R2=R2+R6;
     3f4:	c2 67       	R2+=-8;
     3f6:	e8 a1       	R0=[P5+0x1c];
     3f8:	85 08       	CC=R5<R0;
     3fa:	09 10       	IF!CCJUMP  40c <__do_one_spec+0x58>;
     3fc:	2a e1 7c ff 	P2=-132 (X);
     400:	97 5a       	P2=FP+P2;
     402:	12 92       	[P2++]=R2;
     404:	f8 67       	R0+=-1;
     406:	42 64       	R2+=8;
     408:	00 0c       	CC=R0==0;
     40a:	fc 17       	IF!CCJUMP  402 <__do_one_spec+0x4e>(BP);
     40c:	29 ae       	P1=[P5+0x20];
     40e:	41 0c       	CC=P1==0;
     410:	26 19       	IFCCJUMP  65c <__do_one_spec+0x2a8>;
     412:	79 0e       	CC=P1<=0x7(IU);
     414:	e2 10       	IF!CCJUMP  5d8 <__do_one_spec+0x224>;
     416:	0a e1 8f 03 	P2.L=38f <__charpad+0x2f>;
     41a:	4a e1 00 00 	P2.H=0 <_start>;
     41e:	91 5a       	P2=P1+P2;
     420:	57 99       	R7=B[P2](X);
     422:	50 60       	R0=10(x);
     424:	26 e1 57 00 	R6=87 (X);
     428:	07 08       	CC=R7==R0;
     42a:	ca 18       	IFCCJUMP  5be <__do_one_spec+0x20a>;
     42c:	69 0e       	CC=P1<=0x5(IU);
     42e:	c6 10       	IF!CCJUMP  5ba <__do_one_spec+0x206>;
     430:	59 0c       	CC=P1==3;
     432:	b8 61       	R0=55(x);
     434:	30 07       	IF CC R6 = R0;
     436:	49 0c       	CC=P1==1;
     438:	bf 18       	IFCCJUMP  5b6 <__do_one_spec+0x202>;
     43a:	68 a0       	R0=[P5+0x4];
     43c:	80 0c       	CC=R0<0;
     43e:	b7 18       	IFCCJUMP  5ac <__do_one_spec+0x1f8>;
     440:	00 91       	R0=[P0];
     442:	21 e1 00 0f 	R1=3840 (X);
     446:	08 54       	R0=R0&R1;
     448:	17 30       	R2=R7;
     44a:	39 e4 df ff 	R1=[FP+-132];
     44e:	00 e3 b3 05 	CALL  fb4 <__load_inttype>;
     452:	18 30       	R3=R0;
     454:	11 30       	R2=R1;
     456:	47 30       	R0=FP;
     458:	0b 30       	R1=R3;
     45a:	f7 b0       	[SP+0xc]=R7;
     45c:	36 b1       	[SP+0x10]=R6;
     45e:	f8 67       	R0+=-1;
     460:	00 e3 de 05 	CALL  101c <__uintmaxtostr>;
     464:	2b a2       	R3=[P5+0x20];
     466:	20 30       	R4=R0;
     468:	2b 0e       	CC=R3<=0x5(IU);
     46a:	9d 18       	IFCCJUMP  5a4 <__do_one_spec+0x1f0>;
     46c:	08 32       	P1=R0;
     46e:	4f 99       	R7=B[P1](X);
     470:	38 43       	R0=R7.B(X);
     472:	69 61       	R1=45(x);
     474:	08 08       	CC=R0==R1;
     476:	8e 18       	IFCCJUMP  592 <__do_one_spec+0x1de>;
     478:	29 a1       	R1=[P5+0x10];
     47a:	10 60       	R0=2(x);
     47c:	01 54       	R0=R1&R0;
     47e:	00 0c       	CC=R0==0;
     480:	83 18       	IFCCJUMP  586 <__do_one_spec+0x1d2>;
     482:	04 68       	P4=0;
     484:	2a e1 80 ff 	P2=-128 (X);
     488:	97 5a       	P2=FP+P2;
     48a:	52 30       	R2=P2;
     48c:	20 e1 7f 00 	R0=127 (X);
     490:	a2 52       	R2=R2-R4;
     492:	6d a0       	R5=[P5+0x4];
     494:	82 51       	R6=R2+R0;
     496:	85 0c       	CC=R5<0;
     498:	0a 68       	P2=1;
     49a:	80 60       	R0=16(x);
     49c:	01 54       	R0=R1&R0;
     49e:	6a 07       	IF CC R5 = P2;
     4a0:	00 0c       	CC=R0==0;
     4a2:	0a 18       	IFCCJUMP  4b6 <__do_one_spec+0x102>;
     4a4:	13 0e       	CC=R3<=0x2(IU);
     4a6:	30 60       	R0=6(x);
     4a8:	a0 07       	IF CC P4 = R0;
     4aa:	1b 0c       	CC=R3==3;
     4ac:	48 60       	R0=9(x);
     4ae:	a0 07       	IF CC P4 = R0;
     4b0:	20 60       	R0=4(x);
     4b2:	03 08       	CC=R3==R0;
     4b4:	5f 18       	IFCCJUMP  572 <__do_one_spec+0x1be>;
     4b6:	38 43       	R0=R7.B(X);
     4b8:	81 61       	R1=48(x);
     4ba:	08 08       	CC=R0==R1;
     4bc:	4b 18       	IFCCJUMP  552 <__do_one_spec+0x19e>;
     4be:	35 52       	R0=R5-R6;
     4c0:	35 0a       	CC=R5<=R6(IU);
     4c2:	02 10       	IF!CCJUMP  4c6 <__do_one_spec+0x112>;
     4c4:	00 60       	R0=0(x);
     4c6:	28 30       	R5=R0;
     4c8:	59 68       	P1=11;
     4ca:	ee 50       	R3=R6+R5;
     4cc:	4c 08       	CC=P4==P1;
     4ce:	09 18       	IFCCJUMP  4e0 <__do_one_spec+0x12c>;
     4d0:	0b 30       	R1=R3;
     4d2:	03 30       	R0=R3;
     4d4:	2a 68       	P2=5;
     4d6:	11 64       	R1+=2;
     4d8:	08 64       	R0+=1;
     4da:	54 09       	CC=P4<=P2;
     4dc:	19 06       	IF ! CC R3 = R1;
     4de:	18 07       	IF CC R3 = R0;
     4e0:	a8 a0       	R0=[P5+0x8];
     4e2:	39 ad       	P1=[FP+0x10];
     4e4:	18 0a       	CC=R0<=R3(IU);
     4e6:	18 52       	R0=R0-R3;
     4e8:	01 60       	R1=0(x);
     4ea:	38 06       	IF ! CC R7 = R0;
     4ec:	39 07       	IF CC R7 = R1;
     4ee:	7b 50       	R1=R3+R7;
     4f0:	08 91       	R0=[P1];
     4f2:	08 50       	R0=R0+R1;
     4f4:	08 93       	[P1]=R0;
     4f6:	b8 e5 7b ff 	R0=B[FP+-133](X);
     4fa:	81 61       	R1=48(x);
     4fc:	08 08       	CC=R0==R1;
     4fe:	27 18       	IFCCJUMP  54c <__do_one_spec+0x198>;
     500:	28 a1       	R0=[P5+0x10];
     502:	41 60       	R1=8(x);
     504:	08 54       	R0=R0&R1;
     506:	00 0c       	CC=R0==0;
     508:	1b 18       	IFCCJUMP  53e <__do_one_spec+0x18a>;
     50a:	4c 30       	R1=P4;
     50c:	00 e1 98 03 	R0.L=920;
     510:	40 e1 00 00 	R0.H=0;
     514:	01 50       	R0=R1+R0;
     516:	4b 30       	R1=P3;
     518:	00 e3 fc 05 	CALL  1110 <_fputs>;
     51c:	43 30       	R0=P3;
     51e:	15 30       	R2=R5;
     520:	81 61       	R1=48(x);
     522:	ff e3 1f ff 	CALL  360 <__charpad>;
     526:	0e 30       	R1=R6;
     528:	53 30       	R2=P3;
     52a:	04 30       	R0=R4;
     52c:	00 e3 c4 01 	CALL  8b4 <__stdio_fwrite>;
     530:	43 30       	R0=P3;
     532:	17 30       	R2=R7;
     534:	01 61       	R1=32(x);
     536:	ff e3 15 ff 	CALL  360 <__charpad>;
     53a:	00 60       	R0=0(x);
     53c:	
OFFSET = 160 
a0 20       	JUMP.S  67c <__do_one_spec+0x2c8>;
     53e:	17 30       	R2=R7;
     540:	43 30       	R0=P3;
     542:	01 61       	R1=32(x);
     544:	ff e3 0e ff 	CALL  360 <__charpad>;
     548:	07 60       	R7=0(x);
     54a:	
OFFSET = 4064 
e0 2f       	JUMP.S  50a <__do_one_spec+0x156>;
     54c:	7d 51       	R5=R5+R7;
     54e:	07 60       	R7=0(x);
     550:	
OFFSET = 4056 
d8 2f       	JUMP.S  500 <__do_one_spec+0x14c>;
     552:	31 68       	P1=6;
     554:	cc 08       	CC=P4<P1;
     556:	58 60       	R0=11(x);
     558:	a0 06       	IF ! CC P4 = R0;
     55a:	0b 0c       	CC=R3==1;
     55c:	05 18       	IFCCJUMP  566 <__do_one_spec+0x1b2>;
     55e:	05 0c       	CC=R5==0;
     560:	00 60       	R0=0(x);
     562:	30 07       	IF CC R6 = R0;
     564:	
OFFSET = 4013 
ad 2f       	JUMP.S  4be <__do_one_spec+0x10a>;
     566:	04 e1 a4 03 	R4.L=932;
     56a:	44 e1 00 00 	R4.H=0;
     56e:	2e 60       	R6=5(x);
     570:	
OFFSET = 4010 
aa 2f       	JUMP.S  4c4 <__do_one_spec+0x110>;
     572:	35 0a       	CC=R5<=R6(IU);
     574:	a1 13       	IF!CCJUMP  4b6 <__do_one_spec+0x102>;
     576:	38 43       	R0=R7.B(X);
     578:	81 61       	R1=48(x);
     57a:	0e 64       	R6+=1;
     57c:	08 08       	CC=R0==R1;
     57e:	2e 06       	IF ! CC R5 = R6;
     580:	6a 07       	IF CC R5 = P2;
     582:	fe 67       	R6+=-1;
     584:	
OFFSET = 3993 
99 2f       	JUMP.S  4b6 <__do_one_spec+0x102>;
     586:	08 60       	R0=1(x);
     588:	01 54       	R0=R1&R0;
     58a:	00 0c       	CC=R0==0;
     58c:	7c 1b       	IFCCJUMP  484 <__do_one_spec+0xd0>;
     58e:	24 68       	P4=4;
     590:	
OFFSET = 3962 
7a 2f       	JUMP.S  484 <__do_one_spec+0xd0>;
     592:	28 a1       	R0=[P5+0x10];
     594:	08 4a       	BITSET (R0,0x1);
     596:	0c 64       	R4+=1;
     598:	28 b1       	[P5+0x10]=R0;
     59a:	0c 32       	P1=R4;
     59c:	08 30       	R1=R0;
     59e:	14 68       	P4=2;
     5a0:	4f 99       	R7=B[P1](X);
     5a2:	
OFFSET = 3953 
71 2f       	JUMP.S  484 <__do_one_spec+0xd0>;
     5a4:	10 32       	P2=R0;
     5a6:	29 a1       	R1=[P5+0x10];
     5a8:	57 99       	R7=B[P2](X);
     5aa:	
OFFSET = 3949 
6d 2f       	JUMP.S  484 <__do_one_spec+0xd0>;
     5ac:	a9 e5 14 00 	R1=B[P5+20](X);
     5b0:	b9 e6 7b ff 	B[FP+-133]=R1;
     5b4:	
OFFSET = 3910 
46 2f       	JUMP.S  440 <__do_one_spec+0x8c>;
     5b6:	34 68       	P4=6;
     5b8:	
OFFSET = 3905 
41 2f       	JUMP.S  43a <__do_one_spec+0x86>;
     5ba:	bf 43       	R7=-R7;
     5bc:	
OFFSET = 3903 
3f 2f       	JUMP.S  43a <__do_one_spec+0x86>;
     5be:	29 a1       	R1=[P5+0x10];
     5c0:	00 61       	R0=32(x);
     5c2:	01 54       	R0=R1&R0;
     5c4:	00 0c       	CC=R0==0;
     5c6:	60 61       	R0=44(x);
     5c8:	30 06       	IF ! CC R6 = R0;
     5ca:	a0 64       	R0+=20;
     5cc:	41 54       	R1=R1&R0;
     5ce:	06 30       	R0=R6;
     5d0:	01 0c       	CC=R1==0;
     5d2:	38 4a       	BITSET (R0,0x7);
     5d4:	30 06       	IF ! CC R6 = R0;
     5d6:	
OFFSET = 3883 
2b 2f       	JUMP.S  42c <__do_one_spec+0x78>;
     5d8:	7a 68       	P2=15;
     5da:	51 0a       	CC=P1<=P2(IU);
     5dc:	16 10       	IF!CCJUMP  608 <__do_one_spec+0x254>;
     5de:	3a e5 df ff 	P2=[FP+-132];
     5e2:	00 e1 14 03 	R0.L=788;
     5e6:	40 e1 00 00 	R0.H=0;
     5ea:	25 6c       	P5+=4;
     5ec:	50 ac       	P0=[P2+0x4];
     5ee:	17 91       	R7=[P2];
     5f0:	0f 30       	R1=R7;
     5f2:	30 b1       	[SP+0x10]=R0;
     5f4:	f5 bc       	[SP+0xc]=P5;
     5f6:	43 30       	R0=P3;
     5f8:	50 30       	R2=P0;
     5fa:	00 e3 cf 05 	CALL  1198 <__fpmaxtostr>;
     5fe:	39 ad       	P1=[FP+0x10];
     600:	09 91       	R1=[P1];
     602:	41 50       	R1=R1+R0;
     604:	09 93       	[P1]=R1;
     606:	
OFFSET = 3994 
9a 2f       	JUMP.S  53a <__do_one_spec+0x186>;
     608:	8a 68       	P2=17;
     60a:	f8 63       	R0=-1(x);
     60c:	51 0a       	CC=P1<=P2(IU);
     60e:	37 18       	IFCCJUMP  67c <__do_one_spec+0x2c8>;
     610:	9a 68       	P2=19;
     612:	51 0a       	CC=P1<=P2(IU);
     614:	34 10       	IF!CCJUMP  67c <__do_one_spec+0x2c8>;
     616:	51 08       	CC=P1==P2;
     618:	0f 18       	IFCCJUMP  636 <__do_one_spec+0x282>;
     61a:	2a e1 80 ff 	P2=-128 (X);
     61e:	97 5a       	P2=FP+P2;
     620:	62 30       	R4=P2;
     622:	3a e5 df ff 	P2=[FP+-132];
     626:	0c 32       	P1=R4;
     628:	0e 60       	R6=1(x);
     62a:	50 99       	R0=B[P2](X);
     62c:	08 9b       	B[P1]=R0;
     62e:	00 60       	R0=0(x);
     630:	b8 e6 81 ff 	B[FP+-127]=R0;
     634:	
OFFSET = 3914 
4a 2f       	JUMP.S  4c8 <__do_one_spec+0x114>;
     636:	3a e5 df ff 	P2=[FP+-132];
     63a:	14 91       	R4=[P2];
     63c:	04 0c       	CC=R4==0;
     63e:	09 18       	IFCCJUMP  650 <__do_one_spec+0x29c>;
     640:	69 a0       	R1=[P5+0x4];
     642:	81 0c       	CC=R1<0;
     644:	08 07       	IF CC R1 = R0;
     646:	04 30       	R0=R4;
     648:	00 e3 f8 08 	CALL  1838 <_strnlen>;
     64c:	30 30       	R6=R0;
     64e:	
OFFSET = 3901 
3d 2f       	JUMP.S  4c8 <__do_one_spec+0x114>;
     650:	04 e1 ac 03 	R4.L=940;
     654:	44 e1 00 00 	R4.H=0;
     658:	36 60       	R6=6(x);
     65a:	
OFFSET = 3895 
37 2f       	JUMP.S  4c8 <__do_one_spec+0x114>;
     65c:	39 ad       	P1=[FP+0x10];
     65e:	3a e5 df ff 	P2=[FP+-132];
     662:	29 a1       	R1=[P5+0x10];
     664:	08 91       	R0=[P1];
     666:	10 30       	R2=R0;
     668:	18 30       	R3=R0;
     66a:	fb 4d       	R3>>>=0x1f;
     66c:	20 e1 00 0f 	R0=3840 (X);
     670:	41 54       	R1=R1&R0;
     672:	f3 b0       	[SP+0xc]=R3;
     674:	10 91       	R0=[P2];
     676:	00 e3 f7 08 	CALL  1864 <__store_inttype>;
     67a:	
OFFSET = 3936 
60 2f       	JUMP.S  53a <__do_one_spec+0x186>;
     67c:	a6 6c       	SP+=20;
     67e:	a3 05       	( R7:4, P5:3)  = [SP++];
     680:	01 e8 00 00 	UNLINK;
     684:	10 00       	RTS;
	...

00000688 <_vfprintf>:
     688:	00 e8 27 00 	LINK0x9c;
     68c:	eb 05       	[--SP] = ( R7:5, P5:3 );
     68e:	a6 6f       	SP+=-12;
     690:	30 30       	R6=R0;
     692:	00 60       	R0=0(x);
     694:	2b e1 68 ff 	P3=-152 (X);
     698:	38 e6 d9 ff 	[FP+-156]=R0;
     69c:	1f 5b       	P4=FP+P3;
     69e:	29 32       	P5=R1;
     6a0:	2a 30       	R5=R2;
     6a2:	44 30       	R0=P4;
     6a4:	00 e3 fc 08 	CALL  189c <__ppfs_init>;
     6a8:	7d 30       	R7=P5;
     6aa:	80 0c       	CC=R0<0;
     6ac:	4e 18       	IFCCJUMP  748 <_vfprintf+0xc0>;
     6ae:	0d 30       	R1=R5;
     6b0:	44 30       	R0=P4;
     6b2:	00 e3 31 09 	CALL  1914 <__ppfs_prepargs>;
     6b6:	6b 30       	R5=P3;
     6b8:	68 99       	R0=B[P5](X);
     6ba:	01 43       	R1=R0.B(X);
     6bc:	01 0c       	CC=R1==0;
     6be:	0c 18       	IFCCJUMP  6d6 <_vfprintf+0x4e>;
     6c0:	2a 61       	R2=37(x);
     6c2:	11 08       	CC=R1==R2;
     6c4:	09 18       	IFCCJUMP  6d6 <_vfprintf+0x4e>;
     6c6:	0d 6c       	P5+=1;
     6c8:	68 99       	R0=B[P5](X);
     6ca:	01 43       	R1=R0.B(X);
     6cc:	01 0c       	CC=R1==0;
     6ce:	04 18       	IFCCJUMP  6d6 <_vfprintf+0x4e>;
     6d0:	2b 61       	R3=37(x);
     6d2:	19 08       	CC=R1==R3;
     6d4:	f9 17       	IF!CCJUMP  6c6 <_vfprintf+0x3e>(BP);
     6d6:	48 01       	[--SP] = P0;
     6d8:	07 32       	P0=R7;
     6da:	45 08       	CC=P5==P0;
     6dc:	70 90       	P0=[SP++];
     6de:	10 18       	IFCCJUMP  6fe <_vfprintf+0x76>;
     6e0:	45 30       	R0=P5;
     6e2:	78 52       	R1=R0-R7;
     6e4:	07 30       	R0=R7;
     6e6:	16 30       	R2=R6;
     6e8:	00 e3 e6 00 	CALL  8b4 <__stdio_fwrite>;
     6ec:	08 30       	R1=R0;
     6ee:	80 0c       	CC=R0<0;
     6f0:	28 18       	IFCCJUMP  740 <_vfprintf+0xb8>;
     6f2:	38 e4 d9 ff 	R0=[FP+-156];
     6f6:	08 50       	R0=R0+R1;
     6f8:	38 e6 d9 ff 	[FP+-156]=R0;
     6fc:	68 99       	R0=B[P5](X);
     6fe:	00 43       	R0=R0.B(X);
     700:	00 0c       	CC=R0==0;
     702:	30 18       	IFCCJUMP  762 <_vfprintf+0xda>;
     704:	a8 e5 01 00 	R0=B[P5+1](X);
     708:	29 61       	R1=37(x);
     70a:	08 08       	CC=R0==R1;
     70c:	16 18       	IFCCJUMP  738 <_vfprintf+0xb0>;
     70e:	5f 30       	R3=FP;
     710:	0d 6c       	P5+=1;
     712:	22 e1 64 ff 	R2=-156 (X);
     716:	3d e7 da ff 	[FP+-152]=P5;
     71a:	93 50       	R2=R3+R2;
     71c:	06 30       	R0=R6;
     71e:	6b 50       	R1=R3+R5;
     720:	ff e3 4a fe 	CALL  3b4 <__do_one_spec>;
     724:	80 0c       	CC=R0<0;
     726:	05 18       	IFCCJUMP  730 <_vfprintf+0xa8>;
     728:	3d e5 da ff 	P5=[FP+-152];
     72c:	7d 30       	R7=P5;
     72e:	
OFFSET = 4037 
c5 2f       	JUMP.S  6b8 <_vfprintf+0x30>;
     730:	fb 63       	R3=-1(x);
     732:	3b e6 d9 ff 	[FP+-156]=R3;
     736:	
OFFSET = 22 
16 20       	JUMP.S  762 <_vfprintf+0xda>;
     738:	0d 6c       	P5+=1;
     73a:	7d 30       	R7=P5;
     73c:	0d 6c       	P5+=1;
     73e:	
OFFSET = 4029 
bd 2f       	JUMP.S  6b8 <_vfprintf+0x30>;
     740:	fa 63       	R2=-1(x);
     742:	3a e6 d9 ff 	[FP+-156]=R2;
     746:	
OFFSET = 14 
0e 20       	JUMP.S  762 <_vfprintf+0xda>;
     748:	3f e4 da ff 	R7=[FP+-152];
     74c:	07 30       	R0=R7;
     74e:	00 e3 7f 00 	CALL  84c <_strlen>;
     752:	08 30       	R1=R0;
     754:	07 30       	R0=R7;
     756:	16 30       	R2=R6;
     758:	00 e3 ae 00 	CALL  8b4 <__stdio_fwrite>;
     75c:	f9 63       	R1=-1(x);
     75e:	39 e6 d9 ff 	[FP+-156]=R1;
     762:	38 e4 d9 ff 	R0=[FP+-156];
     766:	66 6c       	SP+=12;
     768:	ab 05       	( R7:5, P5:3)  = [SP++];
     76a:	01 e8 00 00 	UNLINK;
     76e:	10 00       	RTS;

00000770 <_fflush>:
     770:	00 e8 00 00 	LINK0x0;
     774:	ed 05       	[--SP] = ( R7:5, P5:5 );
     776:	a6 6f       	SP+=-12;
     778:	28 32       	P5=R0;
     77a:	0a e1 20 3f 	P2.L=3f20 <__stdio_openlist>;
     77e:	4a e1 00 00 	P2.H=0 <_start>;
     782:	07 60       	R7=0(x);
     784:	26 e1 00 03 	R6=768 (X);
     788:	55 08       	CC=P5==P2;
     78a:	31 18       	IFCCJUMP  7ec <_fflush+0x7c>;
     78c:	45 0c       	CC=P5==0;
     78e:	10 18       	IFCCJUMP  7ae <_fflush+0x3e>;
     790:	28 95       	R0=W[P5] (Z);
     792:	21 e1 00 20 	R1=8192 (X);
     796:	08 54       	R0=R0&R1;
     798:	00 0c       	CC=R0==0;
     79a:	2d 18       	IFCCJUMP  7f4 <_fflush+0x84>;
     79c:	55 30       	R2=P5;
     79e:	00 60       	R0=0(x);
     7a0:	01 60       	R1=0(x);
     7a2:	00 e3 89 00 	CALL  8b4 <__stdio_fwrite>;
     7a6:	00 0c       	CC=R0==0;
     7a8:	f8 63       	R0=-1(x);
     7aa:	38 06       	IF ! CC R7 = R0;
     7ac:	
OFFSET = 36 
24 20       	JUMP.S  7f4 <_fflush+0x84>;
     7ae:	0a e1 20 3f 	P2.L=3f20 <__stdio_openlist>;
     7b2:	4a e1 00 00 	P2.H=0 <_start>;
     7b6:	55 91       	P5=[P2];
     7b8:	45 0c       	CC=P5==0;
     7ba:	1d 18       	IFCCJUMP  7f4 <_fflush+0x84>;
     7bc:	25 e1 00 20 	R5=8192 (X);
     7c0:	68 95       	R0=W[P5](X);
     7c2:	08 30       	R1=R0;
     7c4:	49 4b       	BITTGL (R1,0x9);
     7c6:	4e 54       	R1=R6&R1;
     7c8:	c0 42       	R0=R0.L(Z);
     7ca:	c9 42       	R1=R1.L(Z);
     7cc:	a8 54       	R2=R0&R5;
     7ce:	01 0c       	CC=R1==0;
     7d0:	04 18       	IFCCJUMP  7d8 <_fflush+0x68>;
     7d2:	45 30       	R0=P5;
     7d4:	02 0c       	CC=R2==0;
     7d6:	05 10       	IF!CCJUMP  7e0 <_fflush+0x70>;
     7d8:	ad ac       	P5=[P5+0x8];
     7da:	45 0c       	CC=P5==0;
     7dc:	f2 13       	IF!CCJUMP  7c0 <_fflush+0x50>;
     7de:	
OFFSET = 11 
0b 20       	JUMP.S  7f4 <_fflush+0x84>;
     7e0:	ff e3 c8 ff 	CALL  770 <_fflush>;
     7e4:	00 0c       	CC=R0==0;
     7e6:	f8 63       	R0=-1(x);
     7e8:	38 06       	IF ! CC R7 = R0;
     7ea:	
OFFSET = 4087 
f7 2f       	JUMP.S  7d8 <_fflush+0x68>;
     7ec:	05 68       	P5=0;
     7ee:	26 e1 00 01 	R6=256 (X);
     7f2:	
OFFSET = 4045 
cd 2f       	JUMP.S  78c <_fflush+0x1c>;
     7f4:	07 30       	R0=R7;
     7f6:	66 6c       	SP+=12;
     7f8:	ad 05       	( R7:5, P5:5)  = [SP++];
     7fa:	01 e8 00 00 	UNLINK;
     7fe:	10 00       	RTS;

00000800 <_isatty>:
     800:	00 e8 0f 00 	LINK0x3c;
     804:	a6 6f       	SP+=-12;
     806:	4f 30       	R1=FP;
     808:	21 66       	R1+=-60;
     80a:	00 e3 9d 08 	CALL  1944 <_tcgetattr>;
     80e:	00 0c       	CC=R0==0;
     810:	00 02       	R0=CC;
     812:	66 6c       	SP+=12;
     814:	01 e8 00 00 	UNLINK;
     818:	10 00       	RTS;
	...

0000081c <__exit>:
     81c:	00 e8 00 00 	LINK0x0;
     820:	68 05       	[--SP] = ( R7:5);
     822:	10 32       	P2=R0;
     824:	45 01       	[--SP] = R5;
     826:	42 30       	R0=P2;
     828:	0d 60       	R5=1(x);
     82a:	a0 00       	EXCPT  0x0;
     82c:	08 30       	R1=R0;
     82e:	35 90       	R5=[SP++];
     830:	22 e1 82 ff 	R2=-126 (X);
     834:	88 43       	R0=-R1;
     836:	11 0a       	CC=R1<=R2(IU);
     838:	06 18       	IFCCJUMP  844 <__exit+0x28>;
     83a:	0a e1 28 5f 	P2.L=5f28 <__errno>;
     83e:	4a e1 00 00 	P2.H=0 <_start>;
     842:	10 93       	[P2]=R0;
     844:	28 05       	( R7:5) = [SP++];
     846:	01 e8 00 00 	UNLINK;
     84a:	10 00       	RTS;

0000084c <_strlen>:
     84c:	00 e8 00 00 	LINK0x0;
     850:	10 30       	R2=R0;
     852:	10 32       	P2=R0;
     854:	50 99       	R0=B[P2](X);
     856:	00 0c       	CC=R0==0;
     858:	05 18       	IFCCJUMP  862 <_strlen+0x16>;
     85a:	0a 6c       	P2+=1;
     85c:	50 99       	R0=B[P2](X);
     85e:	00 0c       	CC=R0==0;
     860:	fd 17       	IF!CCJUMP  85a <_strlen+0xe>(BP);
     862:	4a 30       	R1=P2;
     864:	11 52       	R0=R1-R2;
     866:	01 e8 00 00 	UNLINK;
     86a:	10 00       	RTS;

0000086c <__stdio_WRITE>:
     86c:	00 e8 00 00 	LINK0x0;
     870:	ed 05       	[--SP] = ( R7:5, P5:5 );
     872:	a6 6f       	SP+=-12;
     874:	2a 30       	R5=R2;
     876:	28 32       	P5=R0;
     878:	31 30       	R6=R1;
     87a:	3a 30       	R7=R2;
     87c:	02 0c       	CC=R2==0;
     87e:	15 18       	IFCCJUMP  8a8 <__stdio_WRITE+0x3c>;
     880:	87 0c       	CC=R7<0;
     882:	02 e1 ff ff 	R2.L=-1;
     886:	42 e1 ff 7f 	R2.H=32767;
     88a:	17 06       	IF ! CC R2 = R7;
     88c:	0e 30       	R1=R6;
     88e:	68 a0       	R0=[P5+0x4];
     890:	00 e3 84 08 	CALL  1998 <___libc_write>;
     894:	86 51       	R6=R6+R0;
     896:	80 0c       	CC=R0<0;
     898:	05 18       	IFCCJUMP  8a2 <__stdio_WRITE+0x36>;
     89a:	c7 53       	R7=R7-R0;
     89c:	07 0c       	CC=R7==0;
     89e:	f1 13       	IF!CCJUMP  880 <__stdio_WRITE+0x14>;
     8a0:	
OFFSET = 4 
04 20       	JUMP.S  8a8 <__stdio_WRITE+0x3c>;
     8a2:	68 95       	R0=W[P5](X);
     8a4:	18 4a       	BITSET (R0,0x3);
     8a6:	28 97       	W[P5]=R0;
     8a8:	3d 52       	R0=R5-R7;
     8aa:	66 6c       	SP+=12;
     8ac:	ad 05       	( R7:5, P5:5)  = [SP++];
     8ae:	01 e8 00 00 	UNLINK;
     8b2:	10 00       	RTS;

000008b4 <__stdio_fwrite>:
     8b4:	00 e8 01 00 	LINK0x4;
     8b8:	e3 05       	[--SP] = ( R7:4, P5:3 );
     8ba:	a6 6f       	SP+=-12;
     8bc:	1a 32       	P3=R2;
     8be:	5b 95       	R3=W[P3](X);
     8c0:	28 32       	P5=R0;
     8c2:	da 42       	R2=R3.L(Z);
     8c4:	00 61       	R0=32(x);
     8c6:	02 54       	R0=R2&R0;
     8c8:	31 30       	R6=R1;
     8ca:	00 0c       	CC=R0==0;
     8cc:	0c 18       	IFCCJUMP  8e4 <__stdio_fwrite+0x30>;
     8ce:	03 30       	R0=R3;
     8d0:	18 4a       	BITSET (R0,0x3);
     8d2:	18 97       	W[P3]=R0;
     8d4:	0a e1 28 5f 	P2.L=5f28 <__errno>;
     8d8:	4a e1 00 00 	P2.H=0 <_start>;
     8dc:	48 60       	R0=9(x);
     8de:	10 93       	[P2]=R0;
     8e0:	00 60       	R0=0(x);
     8e2:	
OFFSET = 186 
ba 20       	JUMP.S  a56 <__stdio_fwrite+0x1a2>;
     8e4:	20 e1 00 10 	R0=4096 (X);
     8e8:	02 54       	R0=R2&R0;
     8ea:	00 0c       	CC=R0==0;
     8ec:	98 18       	IFCCJUMP  a1c <__stdio_fwrite+0x168>;
     8ee:	59 a1       	R1=[P3+0x14];
     8f0:	98 a1       	R0=[P3+0x18];
     8f2:	81 09       	CC=R1<R0(IU);
     8f4:	05 18       	IFCCJUMP  8fe <__stdio_fwrite+0x4a>;
     8f6:	18 60       	R0=3(x);
     8f8:	02 54       	R0=R2&R0;
     8fa:	00 0c       	CC=R0==0;
     8fc:	0f 18       	IFCCJUMP  91a <__stdio_fwrite+0x66>;
     8fe:	20 e1 00 04 	R0=1024 (X);
     902:	02 54       	R0=R2&R0;
     904:	00 0c       	CC=R0==0;
     906:	10 60       	R0=2(x);
     908:	0a 60       	R2=1(x);
     90a:	10 06       	IF ! CC R2 = R0;
     90c:	43 30       	R0=P3;
     90e:	01 60       	R1=0(x);
     910:	00 e3 62 08 	CALL  19d4 <_fseek>;
     914:	00 0c       	CC=R0==0;
     916:	7f 10       	IF!CCJUMP  a14 <__stdio_fwrite+0x160>;
     918:	5b 95       	R3=W[P3](X);
     91a:	d9 a0       	R1=[P3+0xc];
     91c:	99 b1       	[P3+0x18]=R1;
     91e:	59 b1       	[P3+0x14]=R1;
     920:	d9 b1       	[P3+0x1c]=R1;
     922:	20 e1 ff cf 	R0=-12289 (X);
     926:	03 54       	R0=R3&R0;
     928:	18 97       	W[P3]=R0;
     92a:	19 b2       	[P3+0x20]=R1;
     92c:	6d 30       	R5=P5;
     92e:	0c 60       	R4=1(x);
     930:	45 0c       	CC=P5==0;
     932:	35 18       	IFCCJUMP  99c <__stdio_fwrite+0xe8>;
     934:	5a a1       	R2=[P3+0x14];
     936:	0a 08       	CC=R2==R1;
     938:	5f 18       	IFCCJUMP  9f6 <__stdio_fwrite+0x142>;
     93a:	19 a1       	R1=[P3+0x10];
     93c:	11 52       	R0=R1-R2;
     93e:	30 0a       	CC=R0<=R6(IU);
     940:	06 06       	IF ! CC R0 = R6;
     942:	65 32       	P4=P5;
     944:	86 53       	R6=R6-R0;
     946:	00 0c       	CC=R0==0;
     948:	0a 18       	IFCCJUMP  95c <__stdio_fwrite+0xa8>;
     94a:	4b 32       	P1=P3;
     94c:	a1 6c       	P1+=20;
     94e:	4a 91       	P2=[P1];
     950:	69 98       	R1=B[P5++](X);
     952:	f8 67       	R0+=-1;
     954:	00 0c       	CC=R0==0;
     956:	11 9a       	B[P2++]=R1;
     958:	4a 93       	[P1]=P2;
     95a:	fa 17       	IF!CCJUMP  94e <__stdio_fwrite+0x9a>(BP);
     95c:	04 0c       	CC=R4==0;
     95e:	4a 18       	IFCCJUMP  9f2 <__stdio_fwrite+0x13e>;
     960:	06 0c       	CC=R6==0;
     962:	1c 10       	IF!CCJUMP  99a <__stdio_fwrite+0xe6>;
     964:	5b 95       	R3=W[P3](X);
     966:	20 e1 00 01 	R0=256 (X);
     96a:	03 54       	R0=R3&R0;
     96c:	00 0c       	CC=R0==0;
     96e:	09 18       	IFCCJUMP  980 <__stdio_fwrite+0xcc>;
     970:	ec 09       	CC=P4<P5(IU);
     972:	07 10       	IF!CCJUMP  980 <__stdio_fwrite+0xcc>;
     974:	20 98       	R0=B[P4++] (Z);
     976:	51 60       	R1=10(x);
     978:	08 08       	CC=R0==R1;
     97a:	10 18       	IFCCJUMP  99a <__stdio_fwrite+0xe6>;
     97c:	ec 09       	CC=P4<P5(IU);
     97e:	fb 1f       	IFCCJUMP  974 <__stdio_fwrite+0xc0>(BP);
     980:	20 e1 08 0b 	R0=2824 (X);
     984:	03 54       	R0=R3&R0;
     986:	00 0c       	CC=R0==0;
     988:	03 10       	IF!CCJUMP  98e <__stdio_fwrite+0xda>;
     98a:	1a ad       	P2=[P3+0x10];
     98c:	1a be       	[P3+0x20]=P2;
     98e:	03 30       	R0=R3;
     990:	68 4a       	BITSET (R0,0xd);
     992:	18 97       	W[P3]=R0;
     994:	4d 30       	R1=P5;
     996:	29 52       	R0=R1-R5;
     998:	
OFFSET = 95 
5f 20       	JUMP.S  a56 <__stdio_fwrite+0x1a2>;
     99a:	d9 a0       	R1=[P3+0xc];
     99c:	58 a1       	R0=[P3+0x14];
     99e:	c8 53       	R7=R0-R1;
     9a0:	58 a0       	R0=[P3+0x4];
     9a2:	21 32       	P4=R1;
     9a4:	30 0c       	CC=R0==-2;
     9a6:	1c 18       	IFCCJUMP  9de <__stdio_fwrite+0x12a>;
     9a8:	17 30       	R2=R7;
     9aa:	43 30       	R0=P3;
     9ac:	ff e3 60 ff 	CALL  86c <__stdio_WRITE>;
     9b0:	d9 a0       	R1=[P3+0xc];
     9b2:	10 32       	P2=R0;
     9b4:	c7 53       	R7=R7-R0;
     9b6:	20 30       	R4=R0;
     9b8:	59 b1       	[P3+0x14]=R1;
     9ba:	14 5b       	P4=P4+P2;
     9bc:	07 0c       	CC=R7==0;
     9be:	0b 18       	IFCCJUMP  9d4 <__stdio_fwrite+0x120>;
     9c0:	4b 32       	P1=P3;
     9c2:	a1 6c       	P1+=20;
     9c4:	4a 91       	P2=[P1];
     9c6:	60 98       	R0=B[P4++](X);
     9c8:	ff 67       	R7+=-1;
     9ca:	07 0c       	CC=R7==0;
     9cc:	10 9a       	B[P2++]=R0;
     9ce:	4a 93       	[P1]=P2;
     9d0:	fa 17       	IF!CCJUMP  9c4 <__stdio_fwrite+0x110>(BP);
     9d2:	d9 a0       	R1=[P3+0xc];
     9d4:	45 0c       	CC=P5==0;
     9d6:	af 13       	IF!CCJUMP  934 <__stdio_fwrite+0x80>;
     9d8:	58 a1       	R0=[P3+0x14];
     9da:	08 52       	R0=R0-R1;
     9dc:	
OFFSET = 61 
3d 20       	JUMP.S  a56 <__stdio_fwrite+0x1a2>;
     9de:	58 95       	R0=W[P3](X);
     9e0:	68 4a       	BITSET (R0,0xd);
     9e2:	18 97       	W[P3]=R0;
     9e4:	00 60       	R0=0(x);
     9e6:	45 0c       	CC=P5==0;
     9e8:	37 18       	IFCCJUMP  a56 <__stdio_fwrite+0x1a2>;
     9ea:	4d 30       	R1=P5;
     9ec:	29 52       	R0=R1-R5;
     9ee:	30 50       	R0=R0+R6;
     9f0:	
OFFSET = 51 
33 20       	JUMP.S  a56 <__stdio_fwrite+0x1a2>;
     9f2:	5b 95       	R3=W[P3](X);
     9f4:	
OFFSET = 4038 
c6 2f       	JUMP.S  980 <__stdio_fwrite+0xcc>;
     9f6:	19 a1       	R1=[P3+0x10];
     9f8:	11 52       	R0=R1-R2;
     9fa:	30 0a       	CC=R0<=R6(IU);
     9fc:	a0 13       	IF!CCJUMP  93c <__stdio_fwrite+0x88>;
     9fe:	58 a0       	R0=[P3+0x4];
     a00:	30 0c       	CC=R0==-2;
     a02:	9d 1b       	IFCCJUMP  93c <__stdio_fwrite+0x88>;
     a04:	4d 30       	R1=P5;
     a06:	16 30       	R2=R6;
     a08:	43 30       	R0=P3;
     a0a:	ff e3 31 ff 	CALL  86c <__stdio_WRITE>;
     a0e:	10 32       	P2=R0;
     a10:	55 5b       	P5=P5+P2;
     a12:	
OFFSET = 4080 
f0 2f       	JUMP.S  9f2 <__stdio_fwrite+0x13e>;
     a14:	58 95       	R0=W[P3](X);
     a16:	18 4a       	BITSET (R0,0x3);
     a18:	18 97       	W[P3]=R0;
     a1a:	
OFFSET = 3939 
63 2f       	JUMP.S  8e0 <__stdio_fwrite+0x2c>;
     a1c:	20 e1 00 24 	R0=9216 (X);
     a20:	02 54       	R0=R2&R0;
     a22:	21 e1 00 04 	R1=1024 (X);
     a26:	08 08       	CC=R0==R1;
     a28:	03 18       	IFCCJUMP  a2e <__stdio_fwrite+0x17a>;
     a2a:	d9 a0       	R1=[P3+0xc];
     a2c:	
OFFSET = 3963 
7b 2f       	JUMP.S  922 <__stdio_fwrite+0x6e>;
     a2e:	02 68       	P2=0;
     a30:	4f 30       	R1=FP;
     a32:	fa bb       	[FP--4]=P2;
     a34:	43 30       	R0=P3;
     a36:	e1 67       	R1+=-4;
     a38:	12 60       	R2=2(x);
     a3a:	00 e3 0d 08 	CALL  1a54 <__stdio_lseek>;
     a3e:	00 0c       	CC=R0==0;
     a40:	09 18       	IFCCJUMP  a52 <__stdio_fwrite+0x19e>;
     a42:	0a e1 28 5f 	P2.L=5f28 <__errno>;
     a46:	4a e1 00 00 	P2.H=0 <_start>;
     a4a:	10 91       	R0=[P2];
     a4c:	01 61       	R1=32(x);
     a4e:	08 08       	CC=R0==R1;
     a50:	e2 13       	IF!CCJUMP  a14 <__stdio_fwrite+0x160>;
     a52:	5b 95       	R3=W[P3](X);
     a54:	
OFFSET = 4075 
eb 2f       	JUMP.S  a2a <__stdio_fwrite+0x176>;
     a56:	66 6c       	SP+=12;
     a58:	a3 05       	( R7:4, P5:3)  = [SP++];
     a5a:	01 e8 00 00 	UNLINK;
     a5e:	10 00       	RTS;

00000a60 <_type_codes>:
     a60:	
00000a78 <_type_sizes>:
     a78:	00 01       	R0 = [SP++];
     a7a:	01 01       	R1 = [SP++];
     a7c:	04 02       	R4=CC;
     a7e:	01 01       	R1 = [SP++];
     a80:	01 01       	R1 = [SP++];
     a82:	01 01       	R1 = [SP++];

00000a84 <__promoted_size>:
     a84:	00 e8 00 00 	LINK0x0;
     a88:	08 30       	R1=R0;
     a8a:	0a e1 78 0a 	P2.L=a78 <_type_sizes>;
     a8e:	4a e1 00 00 	P2.H=0 <_start>;
     a92:	f2 6f       	P2+=-2;
     a94:	50 95       	R0=W[P2](X);
     a96:	08 08       	CC=R0==R1;
     a98:	07 18       	IFCCJUMP  aa6 <__promoted_size+0x22>;
     a9a:	09 e1 60 0a 	P1.L=a60 <_type_codes>;
     a9e:	49 e1 00 00 	P1.H=0 <_start>;
     aa2:	4a 0a       	CC=P2<=P1(IU);
     aa4:	f7 17       	IF!CCJUMP  a92 <__promoted_size+0xe>(BP);
     aa6:	4a 30       	R1=P2;
     aa8:	02 e1 60 0a 	R2.L=2656;
     aac:	42 e1 00 00 	R2.H=0;
     ab0:	11 52       	R0=R1-R2;
     ab2:	08 4d       	R0>>>=0x1;
     ab4:	08 32       	P1=R0;
     ab6:	0a e1 78 0a 	P2.L=a78 <_type_sizes>;
     aba:	4a e1 00 00 	P2.H=0 <_start>;
     abe:	91 5a       	P2=P1+P2;
     ac0:	10 99       	R0=B[P2] (Z);
     ac2:	01 e8 00 00 	UNLINK;
     ac6:	10 00       	RTS;

00000ac8 <__is_equal_or_bigger_arg>:
     ac8:	00 e8 00 00 	LINK0x0;
     acc:	70 05       	[--SP] = ( R7:6);
     ace:	a6 6f       	SP+=-12;
     ad0:	10 30       	R2=R0;
     ad2:	31 30       	R6=R1;
     ad4:	40 60       	R0=8(x);
     ad6:	01 60       	R1=0(x);
     ad8:	06 08       	CC=R6==R0;
     ada:	0f 18       	IFCCJUMP  af8 <__is_equal_or_bigger_arg+0x30>;
     adc:	02 08       	CC=R2==R0;
     ade:	09 60       	R1=1(x);
     ae0:	0c 18       	IFCCJUMP  af8 <__is_equal_or_bigger_arg+0x30>;
     ae2:	02 30       	R0=R2;
     ae4:	32 08       	CC=R2==R6;
     ae6:	09 18       	IFCCJUMP  af8 <__is_equal_or_bigger_arg+0x30>;
     ae8:	ff e3 ce ff 	CALL  a84 <__promoted_size>;
     aec:	38 30       	R7=R0;
     aee:	06 30       	R0=R6;
     af0:	ff e3 ca ff 	CALL  a84 <__promoted_size>;
     af4:	07 09       	CC=R7<=R0;
     af6:	01 02       	R1=CC;
     af8:	01 30       	R0=R1;
     afa:	66 6c       	SP+=12;
     afc:	30 05       	( R7:6) = [SP++];
     afe:	01 e8 00 00 	UNLINK;
     b02:	10 00       	RTS;

00000b04 <L_spec_flags_$0>:
     b04:	
OFFSET = 2848 
20 2b       	JUMP.S  144 <_func3+0x34>;
     b06:	
OFFSET = 3376 
30 2d       	JUMP.S  566 <__do_one_spec+0x1b2>;
     b08:	
OFFSET = 1827 
23 27       	JUMP.S  194e <_tcgetattr+0xa>;
     b0a:	49 00       	STIR1;

00000b0c <L_spec_chars_$1>:
     b0c:	
00000b21 <L_spec_ranges_$2>:
     b21:	00 01       	NOP;
     b23:	07 0f       	IF CC R0 = R1;
     b25:	10 11       	IF!CCJUMP  b43 <L_spec_and_mask_$4+0x9>;
     b27:	12 13       	IF!CCJUMP  749 <_vfprintf+0xc1>;
     b29:	14 00       	IF!CCJUMP  b4f <L_qual_chars_$5+0x5>(BP);

00000b2a <L_spec_or_mask_$3>:
     b2a:	00 10       	IF!CCJUMP  b2a <L_spec_or_mask_$3>;
     b2c:	
00000b3a <L_spec_and_mask_$4>:
     b3a:	00 1f       	IFCCJUMP  93a <__stdio_fwrite+0x86>(BP);
     b3c:	
00000b4a <L_qual_chars_$5>:
     b4a:	68 6c       	P0+=13;
     b4c:	4c 6a       	P4=-55;
     b4e:	
00000b60 <__ppfs_parsespec>:
     b60:	00 e8 09 00 	LINK0x24;
     b64:	e3 05       	[--SP] = ( R7:4, P5:3 );
     b66:	a6 6f       	SP+=-12;
     b68:	20 30       	R4=R0;
     b6a:	00 60       	R0=0(x);
     b6c:	41 60       	R1=8(x);
     b6e:	a0 bb       	[FP--24]=R0;
     b70:	b0 bb       	[FP--20]=R0;
     b72:	d1 bb       	[FP--12]=R1;
     b74:	e1 bb       	[FP--8]=R1;
     b76:	04 32       	P0=R4;
     b78:	44 91       	P4=[P0];
     b7a:	f9 6b       	P1=-1;
     b7c:	05 60       	R5=0(x);
     b7e:	07 60       	R7=0(x);
     b80:	99 bb       	[FP--28]=P1;
     b82:	86 a1       	R6=[P0+0x18];
     b84:	85 bb       	[FP--32]=R5;
     b86:	63 99       	R3=B[P4](X);
     b88:	18 43       	R0=R3.B(X);
     b8a:	51 61       	R1=42(x);
     b8c:	44 32       	P0=P4;
     b8e:	08 08       	CC=R0==R1;
     b90:	6b 19       	IFCCJUMP  e66 <__ppfs_parsespec+0x306>;
     b92:	0d e1 34 5f 	P5.L=5f34 <___ctype_b>;
     b96:	4d e1 00 00 	P5.H=0 <_start>;
     b9a:	69 91       	P1=[P5];
     b9c:	18 43       	R0=R3.B(X);
     b9e:	18 32       	P3=R0;
     ba0:	40 60       	R0=8(x);
     ba2:	99 5c       	P2=P1+(P3<<1);
     ba4:	11 95       	R1=W[P2] (Z);
     ba6:	41 54       	R1=R1&R0;
     ba8:	05 68       	P5=0;
     baa:	13 30       	R2=R3;
     bac:	01 0c       	CC=R1==0;
     bae:	15 18       	IFCCJUMP  bd8 <__ppfs_parsespec+0x78>;
     bb0:	41 60       	R1=8(x);
     bb2:	2b e1 fe 0f 	P3=4094 (X);
     bb6:	0c 6c       	P4+=1;
     bb8:	10 43       	R0=R2.B(X);
     bba:	ad 5e       	P2=P5+(P5<<2);
     bbc:	5d 09       	CC=P5<=P3;
     bbe:	04 10       	IF!CCJUMP  bc6 <__ppfs_parsespec+0x66>;
     bc0:	18 32       	P3=R0;
     bc2:	53 5d       	P5=P3+(P2<<1);
     bc4:	85 6e       	P5+=-48;
     bc6:	63 99       	R3=B[P4](X);
     bc8:	18 43       	R0=R3.B(X);
     bca:	18 32       	P3=R0;
     bcc:	99 5c       	P2=P1+(P3<<1);
     bce:	10 95       	R0=W[P2] (Z);
     bd0:	08 54       	R0=R0&R1;
     bd2:	13 30       	R2=R3;
     bd4:	00 0c       	CC=R0==0;
     bd6:	ee 17       	IF!CCJUMP  bb2 <__ppfs_parsespec+0x52>(BP);
     bd8:	80 e5 ff ff 	R0=B[P0+-1](X);
     bdc:	29 61       	R1=37(x);
     bde:	08 08       	CC=R0==R1;
     be0:	fc 18       	IFCCJUMP  dd8 <__ppfs_parsespec+0x278>;
     be2:	41 99       	R1=B[P0](X);
     be4:	08 43       	R0=R1.B(X);
     be6:	51 61       	R1=42(x);
     be8:	08 08       	CC=R0==R1;
     bea:	dc 18       	IFCCJUMP  da2 <__ppfs_parsespec+0x242>;
     bec:	07 0c       	CC=R7==0;
     bee:	d8 10       	IF!CCJUMP  d9e <__ppfs_parsespec+0x23e>;
     bf0:	18 43       	R0=R3.B(X);
     bf2:	71 61       	R1=46(x);
     bf4:	8d bb       	[FP--32]=P5;
     bf6:	08 08       	CC=R0==R1;
     bf8:	04 10       	IF!CCJUMP  c00 <__ppfs_parsespec+0xa0>;
     bfa:	0c 6c       	P4+=1;
     bfc:	ff 63       	R7=-1(x);
     bfe:	
OFFSET = 4036 
c4 2f       	JUMP.S  b86 <__ppfs_parsespec+0x26>;
     c00:	08 e1 4a 0b 	P0.L=b4a <L_qual_chars_$5>;
     c04:	48 e1 00 00 	P0.H=0 <_start>;
     c08:	41 99       	R1=B[P0](X);
     c0a:	1a 43       	R2=R3.B(X);
     c0c:	08 43       	R0=R1.B(X);
     c0e:	02 08       	CC=R2==R0;
     c10:	c4 18       	IFCCJUMP  d98 <__ppfs_parsespec+0x238>;
     c12:	08 6c       	P0+=1;
     c14:	41 99       	R1=B[P0](X);
     c16:	08 43       	R0=R1.B(X);
     c18:	00 0c       	CC=R0==0;
     c1a:	f9 17       	IF!CCJUMP  c0c <__ppfs_parsespec+0xac>(BP);
     c1c:	50 30       	R2=P0;
     c1e:	07 e1 4a 0b 	R7.L=2890;
     c22:	47 e1 00 00 	R7.H=0;
     c26:	3a 52       	R0=R2-R7;
     c28:	08 0d       	CC=R0<=1;
     c2a:	af 18       	IFCCJUMP  d88 <__ppfs_parsespec+0x228>;
     c2c:	87 e5 09 00 	R7=B[P0+9](X);
     c30:	18 43       	R0=R3.B(X);
     c32:	47 4f       	R7<<=0x8;
     c34:	f9 63       	R1=-1(x);
     c36:	00 0c       	CC=R0==0;
     c38:	20 19       	IFCCJUMP  e78 <__ppfs_parsespec+0x318>;
     c3a:	08 e1 0c 0b 	P0.L=b0c <L_spec_chars_$1>;
     c3e:	48 e1 00 00 	P0.H=0 <_start>;
     c42:	20 e1 00 04 	R0=1024 (X);
     c46:	87 54       	R2=R7&R0;
     c48:	41 99       	R1=B[P0](X);
     c4a:	09 43       	R1=R1.B(X);
     c4c:	18 43       	R0=R3.B(X);
     c4e:	08 08       	CC=R0==R1;
     c50:	68 18       	IFCCJUMP  d20 <__ppfs_parsespec+0x1c0>;
     c52:	08 6c       	P0+=1;
     c54:	40 99       	R0=B[P0](X);
     c56:	08 30       	R1=R0;
     c58:	00 43       	R0=R0.B(X);
     c5a:	00 0c       	CC=R0==0;
     c5c:	f7 17       	IF!CCJUMP  c4a <__ppfs_parsespec+0xea>(BP);
     c5e:	20 60       	R0=4(x);
     c60:	05 54       	R0=R5&R0;
     c62:	00 0c       	CC=R0==0;
     c64:	80 61       	R0=48(x);
     c66:	01 61       	R1=32(x);
     c68:	08 06       	IF ! CC R1 = R0;
     c6a:	0c 32       	P1=R4;
     c6c:	18 43       	R0=R3.B(X);
     c6e:	c8 b0       	[P1+0xc]=R0;
     c70:	9a b9       	P2=[FP--28];
     c72:	22 e1 00 0f 	R2=3840 (X);
     c76:	97 54       	R2=R7&R2;
     c78:	15 4c       	BITCLR (R5,0x2);
     c7a:	4a bc       	[P1+0x4]=P2;
     c7c:	8b b9       	P3=[FP--32];
     c7e:	95 56       	R2=R5|R2;
     c80:	0d 68       	P5=1;
     c82:	49 b1       	[P1+0x14]=R1;
     c84:	8b bc       	[P1+0x8]=P3;
     c86:	0a b1       	[P1+0x10]=R2;
     c88:	cd bd       	[P1+0x1c]=P5;
     c8a:	40 99       	R0=B[P0](X);
     c8c:	f9 63       	R1=-1(x);
     c8e:	00 0c       	CC=R0==0;
     c90:	f4 18       	IFCCJUMP  e78 <__ppfs_parsespec+0x318>;
     c92:	06 0d       	CC=R6<=0;
     c94:	39 18       	IFCCJUMP  d06 <__ppfs_parsespec+0x1a6>;
     c96:	4f 32       	P1=FP;
     c98:	3c 30       	R7=R4;
     c9a:	05 68       	P5=0;
     c9c:	a1 6f       	P1+=-12;
     c9e:	27 65       	R7+=36;
     ca0:	55 0d       	CC=P5<=2;
     ca2:	2e 10       	IF!CCJUMP  cfe <__ppfs_parsespec+0x19e>;
     ca4:	88 e4 f4 ff 	R0=B[P1+-12] (Z);
     ca8:	07 32       	P0=R7;
     caa:	10 32       	P2=R0;
     cac:	00 9b       	B[P0]=R0;
     cae:	0d 6c       	P5+=1;
     cb0:	0f 64       	R7+=1;
     cb2:	f9 63       	R1=-1(x);
     cb4:	48 01       	[--SP] = P0;
     cb6:	06 32       	P0=R6;
     cb8:	42 09       	CC=P2<=P0;
     cba:	70 90       	P0=[SP++];
     cbc:	05 18       	IFCCJUMP  cc6 <__ppfs_parsespec+0x166>;
     cbe:	72 30       	R6=P2;
     cc0:	48 60       	R0=9(x);
     cc2:	06 09       	CC=R6<=R0;
     cc4:	da 10       	IF!CCJUMP  e78 <__ppfs_parsespec+0x318>;
     cc6:	fa 6f       	P2+=-1;
     cc8:	04 32       	P0=R4;
     cca:	d0 5e       	P3=P0+(P2<<2);
     ccc:	43 6d       	P3+=40;
     cce:	09 91       	R1=[P1];
     cd0:	18 91       	R0=[P3];
     cd2:	79 bb       	[FP--36]=P1;
     cd4:	ff e3 fa fe 	CALL  ac8 <__is_equal_or_bigger_arg>;
     cd8:	79 b9       	P1=[FP--36];
     cda:	00 0c       	CC=R0==0;
     cdc:	03 18       	IFCCJUMP  ce2 <__ppfs_parsespec+0x182>;
     cde:	4a 91       	P2=[P1];
     ce0:	5a 93       	[P3]=P2;
     ce2:	1c 32       	P3=R4;
     ce4:	d8 a1       	R0=[P3+0x1c];
     ce6:	10 32       	P2=R0;
     ce8:	12 6c       	P2+=2;
     cea:	21 6c       	P1+=4;
     cec:	d5 08       	CC=P5<P2;
     cee:	d9 1f       	IFCCJUMP  ca0 <__ppfs_parsespec+0x140>(BP);
     cf0:	14 32       	P2=R4;
     cf2:	0c 6c       	P4+=1;
     cf4:	08 30       	R1=R0;
     cf6:	54 93       	[P2]=P4;
     cf8:	96 b1       	[P2+0x18]=R6;
     cfa:	11 64       	R1+=2;
     cfc:	
OFFSET = 190 
be 20       	JUMP.S  e78 <__ppfs_parsespec+0x318>;
     cfe:	ca b9       	P2=[FP--16];
     d00:	aa 5a       	P2=P2+P5;
     d02:	f2 6f       	P2+=-2;
     d04:	
OFFSET = 4053 
d5 2f       	JUMP.S  cae <__ppfs_parsespec+0x14e>;
     d06:	09 60       	R1=1(x);
     d08:	89 e6 26 00 	B[P1+38]=R1;
     d0c:	04 30       	R0=R4;
     d0e:	4f 30       	R1=FP;
     d10:	40 65       	R0+=40;
     d12:	e1 67       	R1+=-4;
     d14:	22 60       	R2=4(x);
     d16:	00 e3 35 08 	CALL  1d80 <_memcpy>;
     d1a:	0c 32       	P1=R4;
     d1c:	c8 a1       	R0=[P1+0x1c];
     d1e:	
OFFSET = 4073 
e9 2f       	JUMP.S  cf0 <__ppfs_parsespec+0x190>;
     d20:	40 30       	R0=P0;
     d22:	03 e1 0c 0b 	R3.L=2828;
     d26:	43 e1 00 00 	R3.H=0;
     d2a:	58 52       	R1=R0-R3;
     d2c:	88 60       	R0=17(x);
     d2e:	01 09       	CC=R1<=R0;
     d30:	05 18       	IFCCJUMP  d3a <__ppfs_parsespec+0x1da>;
     d32:	01 30       	R0=R1;
     d34:	02 0c       	CC=R2==0;
     d36:	f0 67       	R0+=-2;
     d38:	08 06       	IF ! CC R1 = R0;
     d3a:	04 32       	P0=R4;
     d3c:	01 b2       	[P0+0x20]=R1;
     d3e:	08 e1 20 0b 	P0.L=b20 <L_spec_chars_$1+0x14>;
     d42:	48 e1 00 00 	P0.H=0 <_start>;
     d46:	08 6c       	P0+=1;
     d48:	40 99       	R0=B[P0](X);
     d4a:	01 09       	CC=R1<=R0;
     d4c:	fd 17       	IF!CCJUMP  d46 <__ppfs_parsespec+0x1e6>(BP);
     d4e:	40 30       	R0=P0;
     d50:	01 e1 21 0b 	R1.L=2849;
     d54:	41 e1 00 00 	R1.H=0;
     d58:	08 52       	R0=R0-R1;
     d5a:	28 32       	P5=R0;
     d5c:	2d 5a       	P0=P5<<1;
     d5e:	09 e1 2a 0b 	P1.L=b2a <L_spec_or_mask_$3>;
     d62:	49 e1 00 00 	P1.H=0 <_start>;
     d66:	48 5a       	P1=P0+P1;
     d68:	0a e1 3a 0b 	P2.L=b3a <L_spec_and_mask_$4>;
     d6c:	4a e1 00 00 	P2.H=0 <_start>;
     d70:	10 5a       	P0=P0+P2;
     d72:	48 95       	R0=W[P1](X);
     d74:	41 95       	R1=W[P0](X);
     d76:	07 56       	R0=R7|R0;
     d78:	08 54       	R0=R0&R1;
     d7a:	f0 bb       	[FP--4]=R0;
     d7c:	08 e1 0c 0b 	P0.L=b0c <L_spec_chars_$1>;
     d80:	48 e1 00 00 	P0.H=0 <_start>;
     d84:	63 99       	R3=B[P4](X);
     d86:	
OFFSET = 3948 
6c 2f       	JUMP.S  c5e <__ppfs_parsespec+0xfe>;
     d88:	09 43       	R1=R1.B(X);
     d8a:	18 43       	R0=R3.B(X);
     d8c:	08 08       	CC=R0==R1;
     d8e:	4f 13       	IF!CCJUMP  c2c <__ppfs_parsespec+0xcc>;
     d90:	0c 6c       	P4+=1;
     d92:	48 6c       	P0+=9;
     d94:	63 99       	R3=B[P4](X);
     d96:	
OFFSET = 3915 
4b 2f       	JUMP.S  c2c <__ppfs_parsespec+0xcc>;
     d98:	0c 6c       	P4+=1;
     d9a:	63 99       	R3=B[P4](X);
     d9c:	
OFFSET = 3904 
40 2f       	JUMP.S  c1c <__ppfs_parsespec+0xbc>;
     d9e:	9d bb       	[FP--28]=P5;
     da0:	
OFFSET = 3888 
30 2f       	JUMP.S  c00 <__ppfs_parsespec+0xa0>;
     da2:	06 0c       	CC=R6==0;
     da4:	15 18       	IFCCJUMP  dce <__ppfs_parsespec+0x26e>;
     da6:	18 43       	R0=R3.B(X);
     da8:	22 61       	R2=36(x);
     daa:	0c 6c       	P4+=1;
     dac:	10 08       	CC=R0==R2;
     dae:	0e 10       	IF!CCJUMP  dca <__ppfs_parsespec+0x26a>;
     db0:	45 0d       	CC=P5<=0;
     db2:	0c 18       	IFCCJUMP  dca <__ppfs_parsespec+0x26a>;
     db4:	b8 43       	R0=-R7;
     db6:	00 32       	P0=R0;
     db8:	87 5e       	P2=FP+(P0<<2);
     dba:	15 e7 fa ff 	[P2+-24]=P5;
     dbe:	63 99       	R3=B[P4](X);
     dc0:	0d e1 00 00 	P5.L=0 <_start>;
     dc4:	4d e1 00 80 	P5.H=8000 <__bss_start+0x20a0>;
     dc8:	
OFFSET = 3858 
12 2f       	JUMP.S  bec <__ppfs_parsespec+0x8c>;
     dca:	f9 63       	R1=-1(x);
     dcc:	
OFFSET = 86 
56 20       	JUMP.S  e78 <__ppfs_parsespec+0x318>;
     dce:	08 6c       	P0+=1;
     dd0:	f9 63       	R1=-1(x);
     dd2:	60 08       	CC=P0==P4;
     dd4:	f6 1b       	IFCCJUMP  dc0 <__ppfs_parsespec+0x260>;
     dd6:	
OFFSET = 81 
51 20       	JUMP.S  e78 <__ppfs_parsespec+0x318>;
     dd8:	18 43       	R0=R3.B(X);
     dda:	22 61       	R2=36(x);
     ddc:	10 08       	CC=R0==R2;
     dde:	32 18       	IFCCJUMP  e42 <__ppfs_parsespec+0x2e2>;
     de0:	f9 63       	R1=-1(x);
     de2:	06 0d       	CC=R6<=0;
     de4:	4a 10       	IF!CCJUMP  e78 <__ppfs_parsespec+0x318>;
     de6:	06 60       	R6=0(x);
     de8:	44 0a       	CC=P4<=P0(IU);
     dea:	06 18       	IFCCJUMP  df6 <__ppfs_parsespec+0x296>;
     dec:	41 99       	R1=B[P0](X);
     dee:	08 43       	R0=R1.B(X);
     df0:	82 61       	R2=48(x);
     df2:	10 08       	CC=R0==R2;
     df4:	f8 12       	IF!CCJUMP  be4 <__ppfs_parsespec+0x84>;
     df6:	60 32       	P4=P0;
     df8:	0a e1 04 0b 	P2.L=b04 <L_spec_flags_$0>;
     dfc:	4a e1 00 00 	P2.H=0 <_start>;
     e00:	63 99       	R3=B[P4](X);
     e02:	0d 68       	P5=1;
     e04:	08 e1 04 0b 	P0.L=b04 <L_spec_flags_$0>;
     e08:	48 e1 00 00 	P0.H=0 <_start>;
     e0c:	51 99       	R1=B[P2](X);
     e0e:	1a 43       	R2=R3.B(X);
     e10:	08 43       	R0=R1.B(X);
     e12:	08 6c       	P0+=1;
     e14:	02 08       	CC=R2==R0;
     e16:	12 18       	IFCCJUMP  e3a <__ppfs_parsespec+0x2da>;
     e18:	41 99       	R1=B[P0](X);
     e1a:	08 43       	R0=R1.B(X);
     e1c:	6d 5b       	P5=P5<<1;
     e1e:	00 0c       	CC=R0==0;
     e20:	f8 17       	IF!CCJUMP  e10 <__ppfs_parsespec+0x2b0>(BP);
     e22:	50 60       	R0=10(x);
     e24:	05 54       	R0=R5&R0;
     e26:	08 4d       	R0>>>=0x1;
     e28:	c0 43       	R0=~R0;
     e2a:	45 55       	R5=R5&R0;
     e2c:	a0 e5 ff ff 	R0=B[P4+-1](X);
     e30:	2a 61       	R2=37(x);
     e32:	05 68       	P5=0;
     e34:	10 08       	CC=R0==R2;
     e36:	a9 12       	IF!CCJUMP  b88 <__ppfs_parsespec+0x28>;
     e38:	
OFFSET = 3798 
d6 2e       	JUMP.S  be4 <__ppfs_parsespec+0x84>;
     e3a:	5d 30       	R3=P5;
     e3c:	5d 57       	R5=R5|R3;
     e3e:	0c 6c       	P4+=1;
     e40:	
OFFSET = 4064 
e0 2f       	JUMP.S  e00 <__ppfs_parsespec+0x2a0>;
     e42:	45 0d       	CC=P5<=0;
     e44:	ce 1b       	IFCCJUMP  de0 <__ppfs_parsespec+0x280>;
     e46:	0c 6c       	P4+=1;
     e48:	f9 63       	R1=-1(x);
     e4a:	06 0c       	CC=R6==0;
     e4c:	16 18       	IFCCJUMP  e78 <__ppfs_parsespec+0x318>;
     e4e:	cd bb       	[FP--16]=P5;
     e50:	0a e1 04 0b 	P2.L=b04 <L_spec_flags_$0>;
     e54:	4a e1 00 00 	P2.H=0 <_start>;
     e58:	48 01       	[--SP] = P0;
     e5a:	06 32       	P0=R6;
     e5c:	45 09       	CC=P5<=P0;
     e5e:	70 90       	P0=[SP++];
     e60:	d0 1b       	IFCCJUMP  e00 <__ppfs_parsespec+0x2a0>;
     e62:	75 30       	R6=P5;
     e64:	
OFFSET = 4046 
ce 2f       	JUMP.S  e00 <__ppfs_parsespec+0x2a0>;
     e66:	b8 43       	R0=-R7;
     e68:	08 32       	P1=R0;
     e6a:	8f 5e       	P2=FP+(P1<<2);
     e6c:	03 68       	P3=0;
     e6e:	13 e7 fd ff 	[P2+-12]=P3;
     e72:	0c 6c       	P4+=1;
     e74:	63 99       	R3=B[P4](X);
     e76:	
OFFSET = 3726 
8e 2e       	JUMP.S  b92 <__ppfs_parsespec+0x32>;
     e78:	01 30       	R0=R1;
     e7a:	66 6c       	SP+=12;
     e7c:	a3 05       	( R7:4, P5:3)  = [SP++];
     e7e:	01 e8 00 00 	UNLINK;
     e82:	10 00       	RTS;

00000e84 <__ppfs_setargs>:
     e84:	00 e8 00 00 	LINK0x0;
     e88:	c5 04       	[--SP] = ( P5:5);
     e8a:	00 32       	P0=R0;
     e8c:	2a e1 50 00 	P2=80 (X);
     e90:	80 a1       	R0=[P0+0x18];
     e92:	50 5a       	P1=P0+P2;
     e94:	00 0c       	CC=R0==0;
     e96:	6e 10       	IF!CCJUMP  f72 <__ppfs_setargs+0xee>;
     e98:	81 a0       	R1=[P0+0x8];
     e9a:	f8 63       	R0=-1(x);
     e9c:	f8 4f       	R0<<=0x1f;
     e9e:	01 08       	CC=R1==R0;
     ea0:	5f 18       	IFCCJUMP  f5e <__ppfs_setargs+0xda>;
     ea2:	40 a0       	R0=[P0+0x4];
     ea4:	f9 63       	R1=-1(x);
     ea6:	f9 4f       	R1<<=0x1f;
     ea8:	08 08       	CC=R0==R1;
     eaa:	50 18       	IFCCJUMP  f4a <__ppfs_setargs+0xc6>;
     eac:	03 60       	R3=0(x);
     eae:	c1 a1       	R1=[P0+0x1c];
     eb0:	8b 08       	CC=R3<R1;
     eb2:	20 10       	IF!CCJUMP  ef2 <__ppfs_setargs+0x6e>;
     eb4:	68 32       	P5=P0;
     eb6:	25 6d       	P5+=36;
     eb8:	25 6c       	P5+=4;
     eba:	28 91       	R0=[P5];
     ebc:	3a 60       	R2=7(x);
     ebe:	0b 64       	R3+=1;
     ec0:	10 08       	CC=R0==R2;
     ec2:	2e 18       	IFCCJUMP  f1e <__ppfs_setargs+0x9a>;
     ec4:	10 09       	CC=R0<=R2;
     ec6:	0a 18       	IFCCJUMP  eda <__ppfs_setargs+0x56>;
     ec8:	22 e1 00 02 	R2=512 (X);
     ecc:	10 08       	CC=R0==R2;
     ece:	06 18       	IFCCJUMP  eda <__ppfs_setargs+0x56>;
     ed0:	10 09       	CC=R0<=R2;
     ed2:	1c 10       	IF!CCJUMP  f0a <__ppfs_setargs+0x86>;
     ed4:	42 60       	R2=8(x);
     ed6:	10 08       	CC=R0==R2;
     ed8:	0b 18       	IFCCJUMP  eee <__ppfs_setargs+0x6a>;
     eda:	02 e5 13 00 	P2=[P0+76];
     ede:	22 6c       	P2+=4;
     ee0:	02 e7 13 00 	[P0+76]=P2;
     ee4:	e2 6f       	P2+=-4;
     ee6:	52 91       	P2=[P2];
     ee8:	4a 93       	[P1]=P2;
     eea:	41 6c       	P1+=8;
     eec:	c1 a1       	R1=[P0+0x1c];
     eee:	8b 08       	CC=R3<R1;
     ef0:	e4 1f       	IFCCJUMP  eb8 <__ppfs_setargs+0x34>(BP);
     ef2:	81 a0       	R1=[P0+0x8];
     ef4:	81 0c       	CC=R1<0;
     ef6:	5b 10       	IF!CCJUMP  fac <__ppfs_setargs+0x128>;
     ef8:	00 a1       	R0=[P0+0x10];
     efa:	18 4a       	BITSET (R0,0x3);
     efc:	00 4c       	BITCLR (R0,0x0);
     efe:	00 b1       	[P0+0x10]=R0;
     f00:	89 43       	R1=-R1;
     f02:	00 61       	R0=32(x);
     f04:	81 b0       	[P0+0x8]=R1;
     f06:	40 b1       	[P0+0x14]=R0;
     f08:	
OFFSET = 82 
52 20       	JUMP.S  fac <__ppfs_setargs+0x128>;
     f0a:	22 e1 00 08 	R2=2048 (X);
     f0e:	10 08       	CC=R0==R2;
     f10:	12 18       	IFCCJUMP  f34 <__ppfs_setargs+0xb0>;
     f12:	10 09       	CC=R0<=R2;
     f14:	e3 1b       	IFCCJUMP  eda <__ppfs_setargs+0x56>;
     f16:	22 e1 07 08 	R2=2055 (X);
     f1a:	10 08       	CC=R0==R2;
     f1c:	df 13       	IF!CCJUMP  eda <__ppfs_setargs+0x56>;
     f1e:	02 e5 13 00 	P2=[P0+76];
     f22:	42 6c       	P2+=8;
     f24:	02 e7 13 00 	[P0+76]=P2;
     f28:	c2 6f       	P2+=-8;
     f2a:	10 91       	R0=[P2];
     f2c:	51 a0       	R1=[P2+0x4];
     f2e:	08 93       	[P1]=R0;
     f30:	49 b0       	[P1+0x4]=R1;
     f32:	
OFFSET = 4060 
dc 2f       	JUMP.S  eea <__ppfs_setargs+0x66>;
     f34:	02 e5 13 00 	P2=[P0+76];
     f38:	42 6c       	P2+=8;
     f3a:	02 e7 13 00 	[P0+76]=P2;
     f3e:	c2 6f       	P2+=-8;
     f40:	10 91       	R0=[P2];
     f42:	51 a0       	R1=[P2+0x4];
     f44:	49 b0       	[P1+0x4]=R1;
     f46:	08 93       	[P1]=R0;
     f48:	
OFFSET = 4049 
d1 2f       	JUMP.S  eea <__ppfs_setargs+0x66>;
     f4a:	02 e5 13 00 	P2=[P0+76];
     f4e:	22 6c       	P2+=4;
     f50:	02 e7 13 00 	[P0+76]=P2;
     f54:	e2 6f       	P2+=-4;
     f56:	10 91       	R0=[P2];
     f58:	08 93       	[P1]=R0;
     f5a:	40 b0       	[P0+0x4]=R0;
     f5c:	
OFFSET = 4008 
a8 2f       	JUMP.S  eac <__ppfs_setargs+0x28>;
     f5e:	02 e5 13 00 	P2=[P0+76];
     f62:	22 6c       	P2+=4;
     f64:	02 e7 13 00 	[P0+76]=P2;
     f68:	e2 6f       	P2+=-4;
     f6a:	10 91       	R0=[P2];
     f6c:	08 93       	[P1]=R0;
     f6e:	80 b0       	[P0+0x8]=R0;
     f70:	
OFFSET = 3993 
99 2f       	JUMP.S  ea2 <__ppfs_setargs+0x1e>;
     f72:	81 a0       	R1=[P0+0x8];
     f74:	f8 63       	R0=-1(x);
     f76:	f8 4f       	R0<<=0x1f;
     f78:	01 08       	CC=R1==R0;
     f7a:	0f 18       	IFCCJUMP  f98 <__ppfs_setargs+0x114>;
     f7c:	40 a0       	R0=[P0+0x4];
     f7e:	fa 63       	R2=-1(x);
     f80:	fa 4f       	R2<<=0x1f;
     f82:	10 08       	CC=R0==R2;
     f84:	b8 13       	IF!CCJUMP  ef4 <__ppfs_setargs+0x70>;
     f86:	80 e4 25 00 	R0=B[P0+37] (Z);
     f8a:	18 4f       	R0<<=0x3;
     f8c:	28 32       	P5=R0;
     f8e:	8d 5a       	P2=P5+P1;
     f90:	12 e5 fe ff 	P2=[P2+-8];
     f94:	42 bc       	[P0+0x4]=P2;
     f96:	
OFFSET = 4015 
af 2f       	JUMP.S  ef4 <__ppfs_setargs+0x70>;
     f98:	80 e4 24 00 	R0=B[P0+36] (Z);
     f9c:	18 4f       	R0<<=0x3;
     f9e:	28 32       	P5=R0;
     fa0:	8d 5a       	P2=P5+P1;
     fa2:	10 e4 fe ff 	R0=[P2+-8];
     fa6:	80 b0       	[P0+0x8]=R0;
     fa8:	08 30       	R1=R0;
     faa:	
OFFSET = 4073 
e9 2f       	JUMP.S  f7c <__ppfs_setargs+0xf8>;
     fac:	85 04       	( P5:5) = [SP++];
     fae:	01 e8 00 00 	UNLINK;
     fb2:	10 00       	RTS;

00000fb4 <__load_inttype>:
     fb4:	00 e8 00 00 	LINK0x0;
     fb8:	68 05       	[--SP] = ( R7:5);
     fba:	30 30       	R6=R0;
     fbc:	20 e1 00 08 	R0=2048 (X);
     fc0:	11 32       	P2=R1;
     fc2:	c6 55       	R7=R6&R0;
     fc4:	82 0c       	CC=R2<0;
     fc6:	13 18       	IFCCJUMP  fec <__load_inttype+0x38>;
     fc8:	07 0c       	CC=R7==0;
     fca:	0e 10       	IF!CCJUMP  fe6 <__load_inttype+0x32>;
     fcc:	21 e1 00 01 	R1=256 (X);
     fd0:	0e 08       	CC=R6==R1;
     fd2:	10 91       	R0=[P2];
     fd4:	41 43       	R1=R0.B(Z);
     fd6:	01 07       	IF CC R0 = R1;
     fd8:	21 e1 00 02 	R1=512 (X);
     fdc:	0e 08       	CC=R6==R1;
     fde:	c1 42       	R1=R0.L(Z);
     fe0:	01 07       	IF CC R0 = R1;
     fe2:	01 60       	R1=0(x);
     fe4:	
OFFSET = 19 
13 20       	JUMP.S  100a <__load_inttype+0x56>;
     fe6:	10 91       	R0=[P2];
     fe8:	51 a0       	R1=[P2+0x4];
     fea:	
OFFSET = 16 
10 20       	JUMP.S  100a <__load_inttype+0x56>;
     fec:	07 0c       	CC=R7==0;
     fee:	fc 13       	IF!CCJUMP  fe6 <__load_inttype+0x32>;
     ff0:	21 e1 00 01 	R1=256 (X);
     ff4:	0e 08       	CC=R6==R1;
     ff6:	10 91       	R0=[P2];
     ff8:	01 43       	R1=R0.B(X);
     ffa:	01 07       	IF CC R0 = R1;
     ffc:	21 e1 00 02 	R1=512 (X);
    1000:	0e 08       	CC=R6==R1;
    1002:	81 42       	R1=R0.L(X);
    1004:	01 07       	IF CC R0 = R1;
    1006:	08 30       	R1=R0;
    1008:	f9 4d       	R1>>>=0x1f;
    100a:	10 30       	R2=R0;
    100c:	19 30       	R3=R1;
    100e:	02 30       	R0=R2;
    1010:	0b 30       	R1=R3;
    1012:	28 05       	( R7:5) = [SP++];
    1014:	01 e8 00 00 	UNLINK;
    1018:	10 00       	RTS;
	...

0000101c <__uintmaxtostr>:
    101c:	00 e8 02 00 	LINK0x8;
    1020:	e3 05       	[--SP] = ( R7:4, P5:3 );
    1022:	a6 6f       	SP+=-12;
    1024:	28 32       	P5=R0;
    1026:	7c a1       	R4=[FP+0x14];
    1028:	00 60       	R0=0(x);
    102a:	29 30       	R5=R1;
    102c:	32 30       	R6=R2;
    102e:	f0 bb       	[FP--4]=R0;
    1030:	84 0c       	CC=R4<0;
    1032:	5c 18       	IFCCJUMP  10ea <__uintmaxtostr+0xce>;
    1034:	00 60       	R0=0(x);
    1036:	28 9b       	B[P5]=R0;
    1038:	0c 30       	R1=R4;
    103a:	f8 63       	R0=-1(x);
    103c:	00 e3 94 07 	CALL  1f64 <___udivsi3>;
    1040:	e0 bb       	[FP--8]=R0;
    1042:	f8 63       	R0=-1(x);
    1044:	0c 30       	R1=R4;
    1046:	00 e3 b1 07 	CALL  1fa8 <___umodsi3>;
    104a:	18 32       	P3=R0;
    104c:	0b 6c       	P3+=1;
    104e:	48 01       	[--SP] = P0;
    1050:	04 32       	P0=R4;
    1052:	43 08       	CC=P3==P0;
    1054:	70 90       	P0=[SP++];
    1056:	45 18       	IFCCJUMP  10e0 <__uintmaxtostr+0xc4>;
    1058:	3d 30       	R7=R5;
    105a:	26 32       	P4=R6;
    105c:	44 30       	R0=P4;
    105e:	0c 30       	R1=R4;
    1060:	44 0c       	CC=P4==0;
    1062:	1e 10       	IF!CCJUMP  109e <__uintmaxtostr+0x82>;
    1064:	07 30       	R0=R7;
    1066:	0c 30       	R1=R4;
    1068:	00 e3 a0 07 	CALL  1fa8 <___umodsi3>;
    106c:	28 30       	R5=R0;
    106e:	07 30       	R0=R7;
    1070:	0c 30       	R1=R4;
    1072:	00 e3 79 07 	CALL  1f64 <___udivsi3>;
    1076:	38 30       	R7=R0;
    1078:	b9 a1       	R1=[FP+0x18];
    107a:	4a 60       	R2=9(x);
    107c:	15 0a       	CC=R5<=R2(IU);
    107e:	0d 50       	R0=R5+R1;
    1080:	54 30       	R2=P4;
    1082:	85 65       	R5+=48;
    1084:	05 07       	IF CC R0 = R5;
    1086:	fd 6f       	P5+=-1;
    1088:	57 56       	R1=R7|R2;
    108a:	28 9b       	B[P5]=R0;
    108c:	01 0c       	CC=R1==0;
    108e:	e7 17       	IF!CCJUMP  105c <__uintmaxtostr+0x40>(BP);
    1090:	f0 b9       	R0=[FP--4];
    1092:	00 0c       	CC=R0==0;
    1094:	37 18       	IFCCJUMP  1102 <__uintmaxtostr+0xe6>;
    1096:	fd 6f       	P5+=-1;
    1098:	69 61       	R1=45(x);
    109a:	29 9b       	B[P5]=R1;
    109c:	
OFFSET = 51 
33 20       	JUMP.S  1102 <__uintmaxtostr+0xe6>;
    109e:	00 e3 85 07 	CALL  1fa8 <___umodsi3>;
    10a2:	30 30       	R6=R0;
    10a4:	44 30       	R0=P4;
    10a6:	0c 30       	R1=R4;
    10a8:	00 e3 5e 07 	CALL  1f64 <___udivsi3>;
    10ac:	20 32       	P4=R0;
    10ae:	07 30       	R0=R7;
    10b0:	0c 30       	R1=R4;
    10b2:	00 e3 7b 07 	CALL  1fa8 <___umodsi3>;
    10b6:	4b 30       	R1=P3;
    10b8:	f1 40       	R1*=R6;
    10ba:	48 51       	R5=R0+R1;
    10bc:	07 30       	R0=R7;
    10be:	0c 30       	R1=R4;
    10c0:	00 e3 52 07 	CALL  1f64 <___udivsi3>;
    10c4:	e2 b9       	R2=[FP--8];
    10c6:	d6 40       	R6*=R2;
    10c8:	f0 51       	R7=R0+R6;
    10ca:	05 30       	R0=R5;
    10cc:	0c 30       	R1=R4;
    10ce:	00 e3 4b 07 	CALL  1f64 <___udivsi3>;
    10d2:	c7 51       	R7=R7+R0;
    10d4:	05 30       	R0=R5;
    10d6:	0c 30       	R1=R4;
    10d8:	00 e3 68 07 	CALL  1fa8 <___umodsi3>;
    10dc:	28 30       	R5=R0;
    10de:	
OFFSET = 4045 
cd 2f       	JUMP.S  1078 <__uintmaxtostr+0x5c>;
    10e0:	e1 b9       	R1=[FP--8];
    10e2:	09 64       	R1+=1;
    10e4:	e1 bb       	[FP--8]=R1;
    10e6:	03 68       	P3=0;
    10e8:	
OFFSET = 4024 
b8 2f       	JUMP.S  1058 <__uintmaxtostr+0x3c>;
    10ea:	01 e1 ff ff 	R1.L=-1;
    10ee:	41 e1 ff 7f 	R1.H=32767;
    10f2:	a4 43       	R4=-R4;
    10f4:	0a 0a       	CC=R2<=R1(IU);
    10f6:	9f 1b       	IFCCJUMP  1034 <__uintmaxtostr+0x18>;
    10f8:	0a 60       	R2=1(x);
    10fa:	ad 43       	R5=-R5;
    10fc:	b6 43       	R6=-R6;
    10fe:	f2 bb       	[FP--4]=R2;
    1100:	
OFFSET = 3994 
9a 2f       	JUMP.S  1034 <__uintmaxtostr+0x18>;
    1102:	45 30       	R0=P5;
    1104:	66 6c       	SP+=12;
    1106:	a3 05       	( R7:4, P5:3)  = [SP++];
    1108:	01 e8 00 00 	UNLINK;
    110c:	10 00       	RTS;
	...

00001110 <_fputs>:
    1110:	00 e8 00 00 	LINK0x0;
    1114:	68 05       	[--SP] = ( R7:5);
    1116:	a6 6f       	SP+=-12;
    1118:	29 30       	R5=R1;
    111a:	38 30       	R7=R0;
    111c:	ff e3 98 fb 	CALL  84c <_strlen>;
    1120:	30 30       	R6=R0;
    1122:	0e 30       	R1=R6;
    1124:	07 30       	R0=R7;
    1126:	15 30       	R2=R5;
    1128:	ff e3 c6 fb 	CALL  8b4 <__stdio_fwrite>;
    112c:	30 08       	CC=R0==R6;
    112e:	f9 63       	R1=-1(x);
    1130:	01 06       	IF ! CC R0 = R1;
    1132:	66 6c       	SP+=12;
    1134:	28 05       	( R7:5) = [SP++];
    1136:	01 e8 00 00 	UNLINK;
    113a:	10 00       	RTS;

0000113c <_fmt>:
    113c:	69 6e       	P1+=-51;
    113e:	66 00       	CALL  (SP);
    1140:	49 4e       	R1>>=0x9;
    1142:	46 00       	STIR6;
    1144:	6e 61       	R6=45(x);
    1146:	6e 00       	CALL  (SP);
    1148:	4e 41       	R6=(R6+R1)<<2;
    114a:	4e 00       	STIR6;
    114c:	
00001150 <_exp10_table>:
    1150:	00 00       	NOP;
    1152:	00 00       	NOP;
    1154:	00 00       	NOP;
    1156:	24 40       	R4>>>=R4;
    1158:	00 00       	NOP;
    115a:	00 00       	NOP;
    115c:	00 00       	NOP;
    115e:	59 40       	R1>>=R3;
    1160:	00 00       	NOP;
    1162:	00 00       	NOP;
    1164:	00 88       	[P0++P0]=R0;
    1166:	c3 40       	R3*=R0;
    1168:	00 00       	NOP;
    116a:	00 00       	NOP;
    116c:	
00001198 <__fpmaxtostr>:
    1198:	00 e8 2b 00 	LINK0xac;
    119c:	e3 05       	[--SP] = ( R7:4, P5:3 );
    119e:	86 6f       	SP+=-16;
    11a0:	78 ad       	P0=[FP+0x14];
    11a2:	21 32       	P4=R1;
    11a4:	21 e1 65 00 	R1=101 (X);
    11a8:	2a 32       	P5=R2;
    11aa:	86 e5 08 00 	R6=B[P0+8](X);
    11ae:	be e6 54 ff 	B[FP+-172]=R6;
    11b2:	b9 e6 7c ff 	B[FP+-132]=R1;
    11b6:	b8 b0       	[FP+0x8]=R0;
    11b8:	43 ac       	P3=[P0+0x4];
    11ba:	3e 30       	R7=R6;
    11bc:	2f 4a       	BITSET (R7,0x5);
    11be:	3f 43       	R7=R7.B(X);
    11c0:	02 91       	R2=[P0];
    11c2:	26 e1 61 00 	R6=97 (X);
    11c6:	3a e6 d6 ff 	[FP+-168]=R2;
    11ca:	37 08       	CC=R7==R6;
    11cc:	02 10       	IF!CCJUMP  11d0 <__fpmaxtostr+0x38>;
    11ce:	
OFFSET = 808 
28 23       	JUMP.S  181e <__fpmaxtostr+0x686>;
    11d0:	38 e4 d6 ff 	R0=[FP+-168];
    11d4:	78 ad       	P0=[FP+0x14];
    11d6:	80 0c       	CC=R0<0;
    11d8:	30 60       	R0=6(x);
    11da:	3a e4 d6 ff 	R2=[FP+-168];
    11de:	10 07       	IF CC R2 = R0;
    11e0:	c1 a0       	R1=[P0+0xc];
    11e2:	10 60       	R0=2(x);
    11e4:	06 60       	R6=0(x);
    11e6:	01 54       	R0=R1&R0;
    11e8:	3a e6 d6 ff 	[FP+-168]=R2;
    11ec:	be e6 5c ff 	B[FP+-164]=R6;
    11f0:	00 0c       	CC=R0==0;
    11f2:	02 10       	IF!CCJUMP  11f6 <__fpmaxtostr+0x5e>;
    11f4:	
OFFSET = 780 
0c 23       	JUMP.S  180c <__fpmaxtostr+0x674>;
    11f6:	5f 61       	R7=43(x);
    11f8:	bf e6 5c ff 	B[FP+-164]=R7;
    11fc:	01 60       	R1=0(x);
    11fe:	02 60       	R2=0(x);
    1200:	b9 e6 5d ff 	B[FP+-163]=R1;
    1204:	82 ba       	[FP--96]=R2;
    1206:	f5 bc       	[SP+0xc]=P5;
    1208:	54 30       	R2=P4;
    120a:	44 30       	R0=P4;
    120c:	4d 30       	R1=P5;
    120e:	00 e3 db 06 	CALL  1fc4 <___nedf2>;
    1212:	00 0c       	CC=R0==0;
    1214:	02 18       	IFCCJUMP  1218 <__fpmaxtostr+0x80>;
    1216:	
OFFSET = 760 
f8 22       	JUMP.S  1806 <__fpmaxtostr+0x66e>;
    1218:	00 68       	P0=0;
    121a:	f0 bc       	[SP+0xc]=P0;
    121c:	02 60       	R2=0(x);
    121e:	44 30       	R0=P4;
    1220:	4d 30       	R1=P5;
    1222:	00 e3 e9 06 	CALL  1ff4 <___eqdf2>;
    1226:	00 0c       	CC=R0==0;
    1228:	02 10       	IF!CCJUMP  122c <__fpmaxtostr+0x94>;
    122a:	
OFFSET = 727 
d7 22       	JUMP.S  17d8 <__fpmaxtostr+0x640>;
    122c:	02 60       	R2=0(x);
    122e:	f2 b0       	[SP+0xc]=R2;
    1230:	44 30       	R0=P4;
    1232:	4d 30       	R1=P5;
    1234:	00 e3 f8 06 	CALL  2024 <___ltdf2>;
    1238:	80 0c       	CC=R0<0;
    123a:	02 10       	IF!CCJUMP  123e <__fpmaxtostr+0xa6>;
    123c:	
OFFSET = 707 
c3 22       	JUMP.S  17c2 <__fpmaxtostr+0x62a>;
    123e:	27 e1 fd 03 	R7=1021 (X);
    1242:	a7 4f       	R7<<=0x14;
    1244:	02 60       	R2=0(x);
    1246:	f7 b0       	[SP+0xc]=R7;
    1248:	44 30       	R0=P4;
    124a:	4d 30       	R1=P5;
    124c:	00 e3 04 07 	CALL  2054 <___muldf3>;
    1250:	10 30       	R2=R0;
    1252:	19 30       	R3=R1;
    1254:	f1 b0       	[SP+0xc]=R1;
    1256:	44 30       	R0=P4;
    1258:	4d 30       	R1=P5;
    125a:	00 e3 cd 06 	CALL  1ff4 <___eqdf2>;
    125e:	00 0c       	CC=R0==0;
    1260:	66 10       	IF!CCJUMP  132c <__fpmaxtostr+0x194>;
    1262:	78 ad       	P0=[FP+0x14];
    1264:	01 69       	P1=32;
    1266:	2a e1 70 00 	P2=112 (X);
    126a:	1d 68       	P5=3;
    126c:	01 bd       	[P0+0x10]=P1;
    126e:	6a ba       	[FP--104]=P2;
    1270:	7d ba       	[FP--100]=P5;
    1272:	2a e1 a4 ff 	P2=-92 (X);
    1276:	b8 e5 54 ff 	R0=B[FP+-172](X);
    127a:	21 e1 60 00 	R1=96 (X);
    127e:	57 5b       	P5=FP+P2;
    1280:	08 09       	CC=R0<=R1;
    1282:	04 10       	IF!CCJUMP  128a <__fpmaxtostr+0xf2>;
    1284:	80 b8       	R0=[FP--96];
    1286:	20 64       	R0+=4;
    1288:	80 ba       	[FP--96]=R0;
    128a:	80 b8       	R0=[FP--96];
    128c:	01 e1 3c 11 	R1.L=4412;
    1290:	41 e1 00 00 	R1.H=0;
    1294:	08 50       	R0=R0+R1;
    1296:	80 ba       	[FP--96]=R0;
    1298:	65 32       	P4=P5;
    129a:	2a e1 9c ff 	P2=-100 (X);
    129e:	57 5b       	P5=FP+P2;
    12a0:	28 91       	R0=[P5];
    12a2:	7b 30       	R7=P3;
    12a4:	c7 53       	R7=R7-R0;
    12a6:	65 6c       	P5+=12;
    12a8:	1f 32       	P3=R7;
    12aa:	e5 09       	CC=P5<P4(IU);
    12ac:	fa 1f       	IFCCJUMP  12a0 <__fpmaxtostr+0x108>(BP);
    12ae:	2a e1 8c ff 	P2=-116 (X);
    12b2:	57 5b       	P5=FP+P2;
    12b4:	28 e1 a0 00 	P0=160 (X);
    12b8:	68 93       	[P5]=P0;
    12ba:	b8 e5 5c ff 	R0=B[FP+-164](X);
    12be:	00 0c       	CC=R0==0;
    12c0:	00 60       	R0=0(x);
    12c2:	09 60       	R1=1(x);
    12c4:	01 06       	IF ! CC R0 = R1;
    12c6:	e0 bb       	[FP--8]=R0;
    12c8:	e2 b9       	R2=[FP--8];
    12ca:	e0 b9       	R0=[FP--8];
    12cc:	82 6e       	P2+=-48;
    12ce:	c7 53       	R7=R7-R0;
    12d0:	97 5a       	P2=FP+P2;
    12d2:	1f 32       	P3=R7;
    12d4:	5a ba       	[FP--108]=P2;
    12d6:	42 ba       	[FP--112]=R2;
    12d8:	43 0d       	CC=P3<=0;
    12da:	0f 18       	IFCCJUMP  12f8 <__fpmaxtostr+0x160>;
    12dc:	79 ad       	P1=[FP+0x14];
    12de:	41 60       	R1=8(x);
    12e0:	c8 a0       	R0=[P1+0xc];
    12e2:	08 54       	R0=R0&R1;
    12e4:	00 0c       	CC=R0==0;
    12e6:	17 18       	IFCCJUMP  1314 <__fpmaxtostr+0x17c>;
    12e8:	0a e1 3f 11 	P2.L=113f <_fmt+0x3>;
    12ec:	4a e1 00 00 	P2.H=0 <_start>;
    12f0:	67 b0       	[P4+0x4]=R7;
    12f2:	60 93       	[P4]=P0;
    12f4:	a2 bc       	[P4+0x8]=P2;
    12f6:	64 6c       	P4+=12;
    12f8:	07 60       	R7=0(x);
    12fa:	a8 ac       	P0=[P5+0x8];
    12fc:	b9 ad       	P1=[FP+0x18];
    12fe:	6a a0       	R2=[P5+0x4];
    1300:	b8 a0       	R0=[FP+0x8];
    1302:	f0 bc       	[SP+0xc]=P0;
    1304:	29 91       	R1=[P5];
    1306:	61 00       	CALL  (P1);
    1308:	68 a0       	R0=[P5+0x4];
    130a:	65 6c       	P5+=12;
    130c:	c7 51       	R7=R7+R0;
    130e:	e5 09       	CC=P5<P4(IU);
    1310:	f5 1b       	IFCCJUMP  12fa <__fpmaxtostr+0x162>;
    1312:	
OFFSET = 653 
8d 22       	JUMP.S  182c <__fpmaxtostr+0x694>;
    1314:	78 ad       	P0=[FP+0x14];
    1316:	81 61       	R1=48(x);
    1318:	00 a1       	R0=[P0+0x10];
    131a:	08 08       	CC=R0==R1;
    131c:	04 18       	IFCCJUMP  1324 <__fpmaxtostr+0x18c>;
    131e:	3a 50       	R0=R2+R7;
    1320:	40 ba       	[FP--112]=R0;
    1322:	
OFFSET = 4075 
eb 2f       	JUMP.S  12f8 <__fpmaxtostr+0x160>;
    1324:	70 b8       	R0=[FP--100];
    1326:	38 50       	R0=R0+R7;
    1328:	70 ba       	[FP--100]=R0;
    132a:	
OFFSET = 4071 
e7 2f       	JUMP.S  12f8 <__fpmaxtostr+0x160>;
    132c:	42 60       	R2=8(x);
    132e:	c2 bb       	[FP--16]=R2;
    1330:	4e 60       	R6=9(x);
    1332:	e6 bb       	[FP--8]=R6;
    1334:	27 e1 00 01 	R7=256 (X);
    1338:	d7 bb       	[FP--12]=R7;
    133a:	00 68       	P0=0;
    133c:	09 e1 84 d7 	P1.L=d784 <__bss_start+0x7824>;
    1340:	49 e1 97 41 	P1.H=4197 <__fixed_buffers+0x273>;
    1344:	b8 bb       	[FP--20]=P0;
    1346:	f1 bc       	[SP+0xc]=P1;
    1348:	02 60       	R2=0(x);
    134a:	44 30       	R0=P4;
    134c:	4d 30       	R1=P5;
    134e:	00 e3 6b 06 	CALL  2024 <___ltdf2>;
    1352:	80 0c       	CC=R0<0;
    1354:	02 10       	IF!CCJUMP  1358 <__fpmaxtostr+0x1c0>;
    1356:	
OFFSET = 563 
33 22       	JUMP.S  17bc <__fpmaxtostr+0x624>;
    1358:	e2 b9       	R2=[FP--8];
    135a:	fa 67       	R2+=-1;
    135c:	e2 bb       	[FP--8]=R2;
    135e:	b2 b9       	R2=[FP--20];
    1360:	44 30       	R0=P4;
    1362:	4d 30       	R1=P5;
    1364:	02 0c       	CC=R2==0;
    1366:	02 10       	IF!CCJUMP  136a <__fpmaxtostr+0x1d2>;
    1368:	
OFFSET = 500 
f4 21       	JUMP.S  1750 <__fpmaxtostr+0x5b8>;
    136a:	e2 b9       	R2=[FP--8];
    136c:	1a 4f       	R2<<=0x3;
    136e:	06 e1 50 11 	R6.L=4432;
    1372:	46 e1 00 00 	R6.H=0;
    1376:	b2 50       	R2=R2+R6;
    1378:	0a 32       	P1=R2;
    137a:	48 ac       	P0=[P1+0x4];
    137c:	0f 91       	R7=[P1];
    137e:	17 30       	R2=R7;
    1380:	f0 bc       	[SP+0xc]=P0;
    1382:	00 e3 69 06 	CALL  2054 <___muldf3>;
    1386:	0a e1 65 cd 	P2.L=cd65 <__bss_start+0x6e05>;
    138a:	4a e1 cd 41 	P2.H=41cd <__fixed_buffers+0x2a9>;
    138e:	02 60       	R2=0(x);
    1390:	f2 bc       	[SP+0xc]=P2;
    1392:	18 30       	R3=R0;
    1394:	00 e3 48 06 	CALL  2024 <___ltdf2>;
    1398:	10 30       	R2=R0;
    139a:	4d 30       	R1=P5;
    139c:	44 30       	R0=P4;
    139e:	82 0c       	CC=R2<0;
    13a0:	02 10       	IF!CCJUMP  13a4 <__fpmaxtostr+0x20c>;
    13a2:	
OFFSET = 452 
c4 21       	JUMP.S  172a <__fpmaxtostr+0x592>;
    13a4:	d0 b9       	R0=[FP--12];
    13a6:	08 4d       	R0>>>=0x1;
    13a8:	d0 bb       	[FP--12]=R0;
    13aa:	e0 b9       	R0=[FP--8];
    13ac:	00 0c       	CC=R0==0;
    13ae:	d5 17       	IF!CCJUMP  1358 <__fpmaxtostr+0x1c0>(BP);
    13b0:	00 e1 65 cd 	R0.L=-12955;
    13b4:	40 e1 cd 41 	R0.H=16845;
    13b8:	f0 b0       	[SP+0xc]=R0;
    13ba:	02 60       	R2=0(x);
    13bc:	44 30       	R0=P4;
    13be:	4d 30       	R1=P5;
    13c0:	00 e3 64 06 	CALL  2088 <___gedf2>;
    13c4:	80 0c       	CC=R0<0;
    13c6:	0f 18       	IFCCJUMP  13e4 <__fpmaxtostr+0x24c>;
    13c8:	22 e1 09 10 	R2=4105 (X);
    13cc:	92 4f       	R2<<=0x12;
    13ce:	f2 b0       	[SP+0xc]=R2;
    13d0:	4d 30       	R1=P5;
    13d2:	44 30       	R0=P4;
    13d4:	02 60       	R2=0(x);
    13d6:	00 e3 71 06 	CALL  20b8 <___divdf3>;
    13da:	c7 b9       	R7=[FP--16];
    13dc:	0f 64       	R7+=1;
    13de:	20 32       	P4=R0;
    13e0:	c7 bb       	[FP--16]=R7;
    13e2:	29 32       	P5=R1;
    13e4:	2a e1 66 ff 	P2=-154 (X);
    13e8:	97 5a       	P2=FP+P2;
    13ea:	06 60       	R6=0(x);
    13ec:	6a 30       	R5=P2;
    13ee:	e6 bb       	[FP--8]=R6;
    13f0:	4d 30       	R1=P5;
    13f2:	44 30       	R0=P4;
    13f4:	00 e3 7c 06 	CALL  20ec <___fixunsdfsi>;
    13f8:	f0 bb       	[FP--4]=R0;
    13fa:	f7 b9       	R7=[FP--4];
    13fc:	07 30       	R0=R7;
    13fe:	00 e3 9b 06 	CALL  2134 <___floatsidf>;
    1402:	08 32       	P1=R0;
    1404:	11 32       	P2=R1;
    1406:	87 0c       	CC=R7<0;
    1408:	02 10       	IF!CCJUMP  140c <__fpmaxtostr+0x274>;
    140a:	
OFFSET = 389 
85 21       	JUMP.S  1714 <__fpmaxtostr+0x57c>;
    140c:	51 30       	R2=P1;
    140e:	f2 bc       	[SP+0xc]=P2;
    1410:	4d 30       	R1=P5;
    1412:	44 30       	R0=P4;
    1414:	00 e3 9a 06 	CALL  2148 <___subdf3>;
    1418:	08 e1 65 cd 	P0.L=cd65 <__bss_start+0x6e05>;
    141c:	48 e1 cd 41 	P0.H=41cd <__fixed_buffers+0x2a9>;
    1420:	f0 bc       	[SP+0xc]=P0;
    1422:	18 30       	R3=R0;
    1424:	02 60       	R2=0(x);
    1426:	00 e3 17 06 	CALL  2054 <___muldf3>;
    142a:	01 68       	P1=0;
    142c:	d9 bb       	[FP--12]=P1;
    142e:	20 32       	P4=R0;
    1430:	29 32       	P5=R1;
    1432:	4d 64       	R5+=9;
    1434:	d0 b9       	R0=[FP--12];
    1436:	08 64       	R0+=1;
    1438:	d0 bb       	[FP--12]=R0;
    143a:	d6 b9       	R6=[FP--12];
    143c:	f0 b9       	R0=[FP--4];
    143e:	51 60       	R1=10(x);
    1440:	00 e3 b4 05 	CALL  1fa8 <___umodsi3>;
    1444:	b5 53       	R6=R5-R6;
    1446:	80 65       	R0+=48;
    1448:	16 32       	P2=R6;
    144a:	10 9b       	B[P2]=R0;
    144c:	f0 b9       	R0=[FP--4];
    144e:	51 60       	R1=10(x);
    1450:	00 e3 8a 05 	CALL  1f64 <___udivsi3>;
    1454:	f0 bb       	[FP--4]=R0;
    1456:	d0 b9       	R0=[FP--12];
    1458:	41 60       	R1=8(x);
    145a:	08 09       	CC=R0<=R1;
    145c:	ec 1f       	IFCCJUMP  1434 <__fpmaxtostr+0x29c>(BP);
    145e:	e0 b9       	R0=[FP--8];
    1460:	08 64       	R0+=1;
    1462:	e0 bb       	[FP--8]=R0;
    1464:	e0 b9       	R0=[FP--8];
    1466:	08 0d       	CC=R0<=1;
    1468:	c4 1f       	IFCCJUMP  13f0 <__fpmaxtostr+0x258>(BP);
    146a:	be e5 54 ff 	R6=B[FP+-172](X);
    146e:	22 e1 60 00 	R2=96 (X);
    1472:	16 09       	CC=R6<=R2;
    1474:	0f 10       	IF!CCJUMP  1492 <__fpmaxtostr+0x2fa>;
    1476:	b8 e5 7c ff 	R0=B[FP+-132](X);
    147a:	be e5 54 ff 	R6=B[FP+-172](X);
    147e:	08 30       	R1=R0;
    1480:	06 30       	R0=R6;
    1482:	00 65       	R0+=32;
    1484:	b8 e6 54 ff 	B[FP+-172]=R0;
    1488:	01 67       	R1+=-32;
    148a:	b9 e6 7c ff 	B[FP+-132]=R1;
    148e:	be e5 54 ff 	R6=B[FP+-172](X);
    1492:	20 e1 67 00 	R0=103 (X);
    1496:	bf e5 54 ff 	R7=B[FP+-172](X);
    149a:	06 08       	CC=R6==R0;
    149c:	32 19       	IFCCJUMP  1700 <__fpmaxtostr+0x568>;
    149e:	22 e1 66 00 	R2=102 (X);
    14a2:	3b e4 d6 ff 	R3=[FP+-168];
    14a6:	16 08       	CC=R6==R2;
    14a8:	1c 19       	IFCCJUMP  16e0 <__fpmaxtostr+0x548>;
    14aa:	2a e1 64 ff 	P2=-156 (X);
    14ae:	97 5a       	P2=FP+P2;
    14b0:	00 60       	R0=0(x);
    14b2:	42 32       	P0=P2;
    14b4:	00 9a       	B[P0++]=R0;
    14b6:	6a 30       	R5=P2;
    14b8:	0d 64       	R5+=1;
    14ba:	80 61       	R0=48(x);
    14bc:	00 9b       	B[P0]=R0;
    14be:	01 60       	R1=0(x);
    14c0:	0d 32       	P1=R5;
    14c2:	82 60       	R2=16(x);
    14c4:	e1 bb       	[FP--8]=R1;
    14c6:	91 6c       	P1+=18;
    14c8:	13 09       	CC=R3<=R2;
    14ca:	0a 10       	IF!CCJUMP  14de <__fpmaxtostr+0x346>;
    14cc:	1d 50       	R0=R5+R3;
    14ce:	08 32       	P1=R0;
    14d0:	11 6c       	P1+=2;
    14d2:	48 99       	R0=B[P1](X);
    14d4:	a1 61       	R1=52(x);
    14d6:	08 09       	CC=R0<=R1;
    14d8:	03 18       	IFCCJUMP  14de <__fpmaxtostr+0x346>;
    14da:	0a 60       	R2=1(x);
    14dc:	e2 bb       	[FP--8]=R2;
    14de:	f9 6f       	P1+=-1;
    14e0:	e1 b9       	R1=[FP--8];
    14e2:	48 99       	R0=B[P1](X);
    14e4:	08 50       	R0=R0+R1;
    14e6:	01 43       	R1=R0.B(X);
    14e8:	08 9b       	B[P1]=R0;
    14ea:	80 61       	R0=48(x);
    14ec:	01 08       	CC=R1==R0;
    14ee:	f8 1b       	IFCCJUMP  14de <__fpmaxtostr+0x346>;
    14f0:	ca 61       	R2=57(x);
    14f2:	11 09       	CC=R1<=R2;
    14f4:	f5 17       	IF!CCJUMP  14de <__fpmaxtostr+0x346>(BP);
    14f6:	41 30       	R0=P1;
    14f8:	c2 b9       	R2=[FP--16];
    14fa:	28 0a       	CC=R0<=R5(IU);
    14fc:	f0 10       	IF!CCJUMP  16dc <__fpmaxtostr+0x544>;
    14fe:	0a 64       	R2+=1;
    1500:	0d 32       	P1=R5;
    1502:	09 6c       	P1+=1;
    1504:	01 60       	R1=0(x);
    1506:	20 e1 67 00 	R0=103 (X);
    150a:	09 9b       	B[P1]=R1;
    150c:	06 08       	CC=R6==R0;
    150e:	dd 18       	IFCCJUMP  16c8 <__fpmaxtostr+0x530>;
    1510:	21 e1 66 00 	R1=102 (X);
    1514:	0e 08       	CC=R6==R1;
    1516:	c2 bb       	[FP--16]=R2;
    1518:	00 60       	R0=0(x);
    151a:	10 06       	IF ! CC R2 = R0;
    151c:	82 0c       	CC=R2<0;
    151e:	d0 18       	IFCCJUMP  16be <__fpmaxtostr+0x526>;
    1520:	2a e1 60 ff 	P2=-160 (X);
    1524:	97 5a       	P2=FP+P2;
    1526:	8a ba       	[FP--96]=P2;
    1528:	2a e1 b0 00 	P2=176 (X);
    152c:	0d 68       	P5=1;
    152e:	6a ba       	[FP--104]=P2;
    1530:	7d ba       	[FP--100]=P5;
    1532:	05 32       	P0=R5;
    1534:	40 98       	R0=B[P0++](X);
    1536:	0d 64       	R5+=1;
    1538:	b8 e6 60 ff 	B[FP+-160]=R0;
    153c:	49 30       	R1=P1;
    153e:	29 52       	R0=R1-R5;
    1540:	2a e1 8c ff 	P2=-116 (X);
    1544:	97 5a       	P2=FP+P2;
    1546:	e0 bb       	[FP--8]=R0;
    1548:	00 60       	R0=0(x);
    154a:	6a 32       	P5=P2;
    154c:	b8 e6 61 ff 	B[FP+-159]=R0;
    1550:	c5 6c       	P5+=24;
    1552:	82 0c       	CC=R2<0;
    1554:	1c 18       	IFCCJUMP  158c <__fpmaxtostr+0x3f4>;
    1556:	21 e1 70 00 	R1=112 (X);
    155a:	29 93       	[P5]=R1;
    155c:	ad b0       	[P5+0x8]=R5;
    155e:	e0 b9       	R0=[FP--8];
    1560:	82 08       	CC=R2<R0;
    1562:	a4 18       	IFCCJUMP  16aa <__fpmaxtostr+0x512>;
    1564:	e0 b9       	R0=[FP--8];
    1566:	68 b0       	[P5+0x4]=R0;
    1568:	e0 b9       	R0=[FP--8];
    156a:	00 68       	P0=0;
    156c:	82 52       	R2=R2-R0;
    156e:	e8 bb       	[FP--8]=P0;
    1570:	65 6c       	P5+=12;
    1572:	02 0d       	CC=R2<=0;
    1574:	0b 18       	IFCCJUMP  158a <__fpmaxtostr+0x3f2>;
    1576:	09 e1 3f 11 	P1.L=113f <_fmt+0x3>;
    157a:	49 e1 00 00 	P1.H=0 <_start>;
    157e:	20 e1 b0 00 	R0=176 (X);
    1582:	6a b0       	[P5+0x4]=R2;
    1584:	a9 bc       	[P5+0x8]=P1;
    1586:	28 93       	[P5]=R0;
    1588:	65 6c       	P5+=12;
    158a:	fa 63       	R2=-1(x);
    158c:	78 ad       	P0=[FP+0x14];
    158e:	81 60       	R1=16(x);
    1590:	c0 a0       	R0=[P0+0xc];
    1592:	08 54       	R0=R0&R1;
    1594:	39 43       	R1=R7.B(X);
    1596:	00 0c       	CC=R0==0;
    1598:	0c 10       	IF!CCJUMP  15b0 <__fpmaxtostr+0x418>;
    159a:	e0 b9       	R0=[FP--8];
    159c:	00 0c       	CC=R0==0;
    159e:	09 10       	IF!CCJUMP  15b0 <__fpmaxtostr+0x418>;
    15a0:	20 e1 67 00 	R0=103 (X);
    15a4:	01 08       	CC=R1==R0;
    15a6:	10 18       	IFCCJUMP  15c6 <__fpmaxtostr+0x42e>;
    15a8:	3f e4 d6 ff 	R7=[FP+-168];
    15ac:	07 0d       	CC=R7<=0;
    15ae:	0c 18       	IFCCJUMP  15c6 <__fpmaxtostr+0x42e>;
    15b0:	28 e1 70 00 	P0=112 (X);
    15b4:	09 68       	P1=1;
    15b6:	0a e1 4c 11 	P2.L=114c <_fmt+0x10>;
    15ba:	4a e1 00 00 	P2.H=0 <_start>;
    15be:	68 93       	[P5]=P0;
    15c0:	69 bc       	[P5+0x4]=P1;
    15c2:	aa bc       	[P5+0x8]=P2;
    15c4:	65 6c       	P5+=12;
    15c6:	0a 64       	R2+=1;
    15c8:	82 0c       	CC=R2<0;
    15ca:	64 18       	IFCCJUMP  1692 <__fpmaxtostr+0x4fa>;
    15cc:	e0 b9       	R0=[FP--8];
    15ce:	00 0c       	CC=R0==0;
    15d0:	08 18       	IFCCJUMP  15e0 <__fpmaxtostr+0x448>;
    15d2:	28 e1 70 00 	P0=112 (X);
    15d6:	68 93       	[P5]=P0;
    15d8:	e0 b9       	R0=[FP--8];
    15da:	68 b0       	[P5+0x4]=R0;
    15dc:	ad b0       	[P5+0x8]=R5;
    15de:	65 6c       	P5+=12;
    15e0:	20 e1 67 00 	R0=103 (X);
    15e4:	01 08       	CC=R1==R0;
    15e6:	4f 18       	IFCCJUMP  1684 <__fpmaxtostr+0x4ec>;
    15e8:	e0 b9       	R0=[FP--8];
    15ea:	10 52       	R0=R0-R2;
    15ec:	e0 bb       	[FP--8]=R0;
    15ee:	e0 b9       	R0=[FP--8];
    15f0:	39 e4 d6 ff 	R1=[FP+-168];
    15f4:	88 08       	CC=R0<R1;
    15f6:	0f 10       	IF!CCJUMP  1614 <__fpmaxtostr+0x47c>;
    15f8:	e0 b9       	R0=[FP--8];
    15fa:	01 52       	R0=R1-R0;
    15fc:	e0 bb       	[FP--8]=R0;
    15fe:	22 e1 b0 00 	R2=176 (X);
    1602:	2a 93       	[P5]=R2;
    1604:	e0 b9       	R0=[FP--8];
    1606:	07 e1 3f 11 	R7.L=4415;
    160a:	47 e1 00 00 	R7.H=0;
    160e:	68 b0       	[P5+0x4]=R0;
    1610:	af b0       	[P5+0x8]=R7;
    1612:	65 6c       	P5+=12;
    1614:	20 e1 66 00 	R0=102 (X);
    1618:	06 08       	CC=R6==R0;
    161a:	02 10       	IF!CCJUMP  161e <__fpmaxtostr+0x486>;
    161c:	
OFFSET = 3646 
3e 2e       	JUMP.S  1298 <__fpmaxtostr+0x100>;
    161e:	c0 b9       	R0=[FP--16];
    1620:	bf e5 7c ff 	R7=B[FP+-132](X);
    1624:	5e 61       	R6=43(x);
    1626:	80 0c       	CC=R0<0;
    1628:	29 18       	IFCCJUMP  167a <__fpmaxtostr+0x4e2>;
    162a:	2a e1 7c ff 	P2=-132 (X);
    162e:	17 5b       	P4=FP+P2;
    1630:	7c 6c       	P4+=15;
    1632:	01 60       	R1=0(x);
    1634:	21 9b       	B[P4]=R1;
    1636:	12 60       	R2=2(x);
    1638:	d2 bb       	[FP--12]=R2;
    163a:	c0 b9       	R0=[FP--16];
    163c:	51 60       	R1=10(x);
    163e:	00 e3 9f 05 	CALL  217c <___modsi3>;
    1642:	80 65       	R0+=48;
    1644:	fc 6f       	P4+=-1;
    1646:	20 9b       	B[P4]=R0;
    1648:	c0 b9       	R0=[FP--16];
    164a:	51 60       	R1=10(x);
    164c:	00 e3 a6 05 	CALL  2198 <___divsi3>;
    1650:	c0 bb       	[FP--16]=R0;
    1652:	d0 b9       	R0=[FP--12];
    1654:	08 64       	R0+=1;
    1656:	d0 bb       	[FP--12]=R0;
    1658:	d0 b9       	R0=[FP--12];
    165a:	18 0d       	CC=R0<=3;
    165c:	ef 1b       	IFCCJUMP  163a <__fpmaxtostr+0x4a2>;
    165e:	c0 b9       	R0=[FP--16];
    1660:	00 0c       	CC=R0==0;
    1662:	ec 17       	IF!CCJUMP  163a <__fpmaxtostr+0x4a2>(BP);
    1664:	fc 6f       	P4+=-1;
    1666:	a6 9a       	B[P4--]=R6;
    1668:	27 9b       	B[P4]=R7;
    166a:	26 e1 70 00 	R6=112 (X);
    166e:	2e 93       	[P5]=R6;
    1670:	d0 b9       	R0=[FP--12];
    1672:	68 b0       	[P5+0x4]=R0;
    1674:	ac bc       	[P5+0x8]=P4;
    1676:	65 6c       	P5+=12;
    1678:	
OFFSET = 3600 
10 2e       	JUMP.S  1298 <__fpmaxtostr+0x100>;
    167a:	c0 b9       	R0=[FP--16];
    167c:	80 43       	R0=-R0;
    167e:	c0 bb       	[FP--16]=R0;
    1680:	6e 61       	R6=45(x);
    1682:	
OFFSET = 4052 
d4 2f       	JUMP.S  162a <__fpmaxtostr+0x492>;
    1684:	78 ad       	P0=[FP+0x14];
    1686:	81 60       	R1=16(x);
    1688:	c0 a0       	R0=[P0+0xc];
    168a:	08 54       	R0=R0&R1;
    168c:	00 0c       	CC=R0==0;
    168e:	c3 1b       	IFCCJUMP  1614 <__fpmaxtostr+0x47c>;
    1690:	
OFFSET = 4012 
ac 2f       	JUMP.S  15e8 <__fpmaxtostr+0x450>;
    1692:	90 43       	R0=-R2;
    1694:	68 b0       	[P5+0x4]=R0;
    1696:	20 e1 b0 00 	R0=176 (X);
    169a:	07 e1 3f 11 	R7.L=4415;
    169e:	47 e1 00 00 	R7.H=0;
    16a2:	28 93       	[P5]=R0;
    16a4:	af b0       	[P5+0x8]=R7;
    16a6:	65 6c       	P5+=12;
    16a8:	
OFFSET = 3986 
92 2f       	JUMP.S  15cc <__fpmaxtostr+0x434>;
    16aa:	02 0d       	CC=R2<=0;
    16ac:	6f 1b       	IFCCJUMP  158a <__fpmaxtostr+0x3f2>;
    16ae:	6a b0       	[P5+0x4]=R2;
    16b0:	e0 b9       	R0=[FP--8];
    16b2:	10 52       	R0=R0-R2;
    16b4:	6a 32       	P5=P2;
    16b6:	e0 bb       	[FP--8]=R0;
    16b8:	25 6d       	P5+=36;
    16ba:	55 51       	R5=R5+R2;
    16bc:	
OFFSET = 3943 
67 2f       	JUMP.S  158a <__fpmaxtostr+0x3f2>;
    16be:	fd 67       	R5+=-1;
    16c0:	80 61       	R0=48(x);
    16c2:	05 32       	P0=R5;
    16c4:	00 9b       	B[P0]=R0;
    16c6:	
OFFSET = 3885 
2d 2f       	JUMP.S  1520 <__fpmaxtostr+0x388>;
    16c8:	a2 0c       	CC=R2<-4;
    16ca:	23 1b       	IFCCJUMP  1510 <__fpmaxtostr+0x378>;
    16cc:	1a 09       	CC=R2<=R3;
    16ce:	21 13       	IF!CCJUMP  1510 <__fpmaxtostr+0x378>;
    16d0:	d3 52       	R3=R3-R2;
    16d2:	3b e6 d6 ff 	[FP+-168]=R3;
    16d6:	26 e1 66 00 	R6=102 (X);
    16da:	
OFFSET = 3867 
1b 2f       	JUMP.S  1510 <__fpmaxtostr+0x378>;
    16dc:	0d 64       	R5+=1;
    16de:	
OFFSET = 3858 
12 2f       	JUMP.S  1502 <__fpmaxtostr+0x36a>;
    16e0:	c0 b9       	R0=[FP--16];
    16e2:	c3 50       	R3=R3+R0;
    16e4:	bb 0c       	CC=R3<-1;
    16e6:	e2 12       	IF!CCJUMP  14aa <__fpmaxtostr+0x312>;
    16e8:	2a e1 64 ff 	P2=-156 (X);
    16ec:	97 5a       	P2=FP+P2;
    16ee:	42 30       	R0=P2;
    16f0:	81 61       	R1=48(x);
    16f2:	8a 60       	R2=17(x);
    16f4:	00 e3 56 03 	CALL  1da0 <_memset>;
    16f8:	f8 6b       	P0=-1;
    16fa:	c8 bb       	[FP--16]=P0;
    16fc:	fb 63       	R3=-1(x);
    16fe:	
OFFSET = 3798 
d6 2e       	JUMP.S  14aa <__fpmaxtostr+0x312>;
    1700:	39 e4 d6 ff 	R1=[FP+-168];
    1704:	38 e4 d6 ff 	R0=[FP+-168];
    1708:	f8 67       	R0+=-1;
    170a:	89 0c       	CC=R1<1;
    170c:	08 06       	IF ! CC R1 = R0;
    170e:	39 e6 d6 ff 	[FP+-168]=R1;
    1712:	
OFFSET = 3782 
c6 2e       	JUMP.S  149e <__fpmaxtostr+0x306>;
    1714:	27 e1 1f 04 	R7=1055 (X);
    1718:	a7 4f       	R7<<=0x14;
    171a:	f7 b0       	[SP+0xc]=R7;
    171c:	02 60       	R2=0(x);
    171e:	00 e3 5f 05 	CALL  21dc <___adddf3>;
    1722:	19 30       	R3=R1;
    1724:	08 32       	P1=R0;
    1726:	11 32       	P2=R1;
    1728:	
OFFSET = 3698 
72 2e       	JUMP.S  140c <__fpmaxtostr+0x274>;
    172a:	e2 b9       	R2=[FP--8];
    172c:	1a 4f       	R2<<=0x3;
    172e:	2a 32       	P5=R2;
    1730:	0e 32       	P1=R6;
    1732:	8d 5a       	P2=P5+P1;
    1734:	55 ac       	P5=[P2+0x4];
    1736:	17 91       	R7=[P2];
    1738:	17 30       	R2=R7;
    173a:	f5 bc       	[SP+0xc]=P5;
    173c:	00 e3 8c 04 	CALL  2054 <___muldf3>;
    1740:	c7 b9       	R7=[FP--16];
    1742:	d6 b9       	R6=[FP--12];
    1744:	f7 53       	R7=R7-R6;
    1746:	19 30       	R3=R1;
    1748:	c7 bb       	[FP--16]=R7;
    174a:	20 32       	P4=R0;
    174c:	29 32       	P5=R1;
    174e:	
OFFSET = 3627 
2b 2e       	JUMP.S  13a4 <__fpmaxtostr+0x20c>;
    1750:	e0 b9       	R0=[FP--8];
    1752:	18 4f       	R0<<=0x3;
    1754:	00 32       	P0=R0;
    1756:	09 e1 50 11 	P1.L=1150 <_exp10_table>;
    175a:	49 e1 00 00 	P1.H=0 <_start>;
    175e:	88 5a       	P2=P0+P1;
    1760:	15 91       	R5=[P2];
    1762:	56 a0       	R6=[P2+0x4];
    1764:	15 30       	R2=R5;
    1766:	44 30       	R0=P4;
    1768:	4d 30       	R1=P5;
    176a:	f6 b0       	[SP+0xc]=R6;
    176c:	00 e3 a6 04 	CALL  20b8 <___divdf3>;
    1770:	0a e1 84 d7 	P2.L=d784 <__bss_start+0x7824>;
    1774:	4a e1 97 41 	P2.H=4197 <__fixed_buffers+0x273>;
    1778:	02 60       	R2=0(x);
    177a:	f2 bc       	[SP+0xc]=P2;
    177c:	18 30       	R3=R0;
    177e:	00 e3 85 04 	CALL  2088 <___gedf2>;
    1782:	10 30       	R2=R0;
    1784:	4d 30       	R1=P5;
    1786:	44 30       	R0=P4;
    1788:	82 0c       	CC=R2<0;
    178a:	02 10       	IF!CCJUMP  178e <__fpmaxtostr+0x5f6>;
    178c:	
OFFSET = 3596 
0c 2e       	JUMP.S  13a4 <__fpmaxtostr+0x20c>;
    178e:	e2 b9       	R2=[FP--8];
    1790:	1a 4f       	R2<<=0x3;
    1792:	2a 32       	P5=R2;
    1794:	09 e1 50 11 	P1.L=1150 <_exp10_table>;
    1798:	49 e1 00 00 	P1.H=0 <_start>;
    179c:	8d 5a       	P2=P5+P1;
    179e:	55 ac       	P5=[P2+0x4];
    17a0:	17 91       	R7=[P2];
    17a2:	17 30       	R2=R7;
    17a4:	f5 bc       	[SP+0xc]=P5;
    17a6:	00 e3 89 04 	CALL  20b8 <___divdf3>;
    17aa:	c7 b9       	R7=[FP--16];
    17ac:	10 30       	R2=R0;
    17ae:	d0 b9       	R0=[FP--12];
    17b0:	c7 51       	R7=R7+R0;
    17b2:	19 30       	R3=R1;
    17b4:	22 32       	P4=R2;
    17b6:	29 32       	P5=R1;
    17b8:	c7 bb       	[FP--16]=R7;
    17ba:	
OFFSET = 3573 
f5 2d       	JUMP.S  13a4 <__fpmaxtostr+0x20c>;
    17bc:	0a 68       	P2=1;
    17be:	ba bb       	[FP--20]=P2;
    17c0:	
OFFSET = 3532 
cc 2d       	JUMP.S  1358 <__fpmaxtostr+0x1c0>;
    17c2:	6e 61       	R6=45(x);
    17c4:	44 30       	R0=P4;
    17c6:	4d 30       	R1=P5;
    17c8:	be e6 5c ff 	B[FP+-164]=R6;
    17cc:	00 e3 22 05 	CALL  2210 <___negdf2>;
    17d0:	19 30       	R3=R1;
    17d2:	20 32       	P4=R0;
    17d4:	29 32       	P5=R1;
    17d6:	
OFFSET = 3380 
34 2d       	JUMP.S  123e <__fpmaxtostr+0xa6>;
    17d8:	54 30       	R2=P4;
    17da:	f5 bc       	[SP+0xc]=P5;
    17dc:	00 60       	R0=0(x);
    17de:	21 e1 ff 03 	R1=1023 (X);
    17e2:	a1 4f       	R1<<=0x14;
    17e4:	00 e3 6a 04 	CALL  20b8 <___divdf3>;
    17e8:	01 68       	P1=0;
    17ea:	f1 bc       	[SP+0xc]=P1;
    17ec:	18 30       	R3=R0;
    17ee:	02 60       	R2=0(x);
    17f0:	00 e3 1a 04 	CALL  2024 <___ltdf2>;
    17f4:	80 0c       	CC=R0<0;
    17f6:	04 18       	IFCCJUMP  17fe <__fpmaxtostr+0x666>;
    17f8:	f9 63       	R1=-1(x);
    17fa:	c1 bb       	[FP--16]=R1;
    17fc:	
OFFSET = 3572 
f4 2d       	JUMP.S  13e4 <__fpmaxtostr+0x24c>;
    17fe:	68 61       	R0=45(x);
    1800:	b8 e6 5c ff 	B[FP+-164]=R0;
    1804:	
OFFSET = 4090 
fa 2f       	JUMP.S  17f8 <__fpmaxtostr+0x660>;
    1806:	46 60       	R6=8(x);
    1808:	86 ba       	[FP--96]=R6;
    180a:	
OFFSET = 3372 
2c 2d       	JUMP.S  1262 <__fpmaxtostr+0xca>;
    180c:	08 60       	R0=1(x);
    180e:	01 54       	R0=R1&R0;
    1810:	00 0c       	CC=R0==0;
    1812:	02 10       	IF!CCJUMP  1816 <__fpmaxtostr+0x67e>;
    1814:	
OFFSET = 3316 
f4 2c       	JUMP.S  11fc <__fpmaxtostr+0x64>;
    1816:	00 61       	R0=32(x);
    1818:	b8 e6 5c ff 	B[FP+-164]=R0;
    181c:	
OFFSET = 3312 
f0 2c       	JUMP.S  11fc <__fpmaxtostr+0x64>;
    181e:	bf e5 54 ff 	R7=B[FP+-172](X);
    1822:	07 30       	R0=R7;
    1824:	30 64       	R0+=6;
    1826:	b8 e6 54 ff 	B[FP+-172]=R0;
    182a:	
OFFSET = 3283 
d3 2c       	JUMP.S  11d0 <__fpmaxtostr+0x38>;
    182c:	07 30       	R0=R7;
    182e:	86 6c       	SP+=16;
    1830:	a3 05       	( R7:4, P5:3)  = [SP++];
    1832:	01 e8 00 00 	UNLINK;
    1836:	10 00       	RTS;

00001838 <_strnlen>:
    1838:	00 e8 00 00 	LINK0x0;
    183c:	10 30       	R2=R0;
    183e:	10 32       	P2=R0;
    1840:	01 0c       	CC=R1==0;
    1842:	0b 18       	IFCCJUMP  1858 <_strnlen+0x20>;
    1844:	50 99       	R0=B[P2](X);
    1846:	00 0c       	CC=R0==0;
    1848:	08 18       	IFCCJUMP  1858 <_strnlen+0x20>;
    184a:	f9 67       	R1+=-1;
    184c:	0a 6c       	P2+=1;
    184e:	01 0c       	CC=R1==0;
    1850:	04 18       	IFCCJUMP  1858 <_strnlen+0x20>;
    1852:	50 99       	R0=B[P2](X);
    1854:	00 0c       	CC=R0==0;
    1856:	fa 17       	IF!CCJUMP  184a <_strnlen+0x12>(BP);
    1858:	4a 30       	R1=P2;
    185a:	11 52       	R0=R1-R2;
    185c:	01 e8 00 00 	UNLINK;
    1860:	10 00       	RTS;
	...

00001864 <__store_inttype>:
    1864:	00 e8 00 00 	LINK0x0;
    1868:	10 32       	P2=R0;
    186a:	20 e1 00 01 	R0=256 (X);
    186e:	3a b1       	[FP+0x10]=R2;
    1870:	01 08       	CC=R1==R0;
    1872:	11 18       	IFCCJUMP  1894 <__store_inttype+0x30>;
    1874:	20 e1 00 08 	R0=2048 (X);
    1878:	01 08       	CC=R1==R0;
    187a:	09 18       	IFCCJUMP  188c <__store_inttype+0x28>;
    187c:	20 e1 00 02 	R0=512 (X);
    1880:	01 08       	CC=R1==R0;
    1882:	03 18       	IFCCJUMP  1888 <__store_inttype+0x24>;
    1884:	12 93       	[P2]=R2;
    1886:	
OFFSET = 8 
08 20       	JUMP.S  1896 <__store_inttype+0x32>;
    1888:	12 97       	W[P2]=R2;
    188a:	
OFFSET = 6 
06 20       	JUMP.S  1896 <__store_inttype+0x32>;
    188c:	12 93       	[P2]=R2;
    188e:	78 a1       	R0=[FP+0x14];
    1890:	50 b0       	[P2+0x4]=R0;
    1892:	
OFFSET = 2 
02 20       	JUMP.S  1896 <__store_inttype+0x32>;
    1894:	12 9b       	B[P2]=R2;
    1896:	01 e8 00 00 	UNLINK;
    189a:	10 00       	RTS;

0000189c <__ppfs_init>:
    189c:	00 e8 00 00 	LINK0x0;
    18a0:	c4 04       	[--SP] = ( P5:4);
    18a2:	a6 6f       	SP+=-12;
    18a4:	21 32       	P4=R1;
    18a6:	28 32       	P5=R0;
    18a8:	01 60       	R1=0(x);
    18aa:	22 e1 98 00 	R2=152 (X);
    18ae:	00 e3 79 02 	CALL  1da0 <_memset>;
    18b2:	a8 a1       	R0=[P5+0x18];
    18b4:	f8 67       	R0+=-1;
    18b6:	a8 b1       	[P5+0x18]=R0;
    18b8:	55 32       	P2=P5;
    18ba:	6c 93       	[P5]=P4;
    18bc:	42 6d       	P2+=40;
    18be:	48 60       	R0=9(x);
    18c0:	41 60       	R1=8(x);
    18c2:	f8 67       	R0+=-1;
    18c4:	11 92       	[P2++]=R1;
    18c6:	00 0c       	CC=R0==0;
    18c8:	fc 17       	IF!CCJUMP  18c0 <__ppfs_init+0x24>(BP);
    18ca:	61 99       	R1=B[P4](X);
    18cc:	08 43       	R0=R1.B(X);
    18ce:	54 32       	P2=P4;
    18d0:	00 0c       	CC=R0==0;
    18d2:	0b 18       	IFCCJUMP  18e8 <__ppfs_init+0x4c>;
    18d4:	08 43       	R0=R1.B(X);
    18d6:	2a 61       	R2=37(x);
    18d8:	10 08       	CC=R0==R2;
    18da:	0a 18       	IFCCJUMP  18ee <__ppfs_init+0x52>;
    18dc:	0a 6c       	P2+=1;
    18de:	50 99       	R0=B[P2](X);
    18e0:	08 30       	R1=R0;
    18e2:	00 43       	R0=R0.B(X);
    18e4:	00 0c       	CC=R0==0;
    18e6:	f7 17       	IF!CCJUMP  18d4 <__ppfs_init+0x38>(BP);
    18e8:	6c 93       	[P5]=P4;
    18ea:	01 60       	R1=0(x);
    18ec:	
OFFSET = 14 
0e 20       	JUMP.S  1908 <__ppfs_init+0x6c>;
    18ee:	0a 6c       	P2+=1;
    18f0:	51 99       	R1=B[P2](X);
    18f2:	45 30       	R0=P5;
    18f4:	11 08       	CC=R1==R2;
    18f6:	f3 1b       	IFCCJUMP  18dc <__ppfs_init+0x40>;
    18f8:	6a 93       	[P5]=P2;
    18fa:	ff e3 33 f9 	CALL  b60 <__ppfs_parsespec>;
    18fe:	f9 63       	R1=-1(x);
    1900:	80 0c       	CC=R0<0;
    1902:	03 18       	IFCCJUMP  1908 <__ppfs_init+0x6c>;
    1904:	6a 91       	P2=[P5];
    1906:	
OFFSET = 4076 
ec 2f       	JUMP.S  18de <__ppfs_init+0x42>;
    1908:	01 30       	R0=R1;
    190a:	66 6c       	SP+=12;
    190c:	84 04       	( P5:4) = [SP++];
    190e:	01 e8 00 00 	UNLINK;
    1912:	10 00       	RTS;

00001914 <__ppfs_prepargs>:
    1914:	00 e8 00 00 	LINK0x0;
    1918:	fd 05       	[--SP] = ( R7:7, P5:5 );
    191a:	a6 6f       	SP+=-12;
    191c:	28 32       	P5=R0;
    191e:	af a1       	R7=[P5+0x18];
    1920:	29 e6 13 00 	[P5+76]=R1;
    1924:	07 0d       	CC=R7<=0;
    1926:	09 18       	IFCCJUMP  1938 <__ppfs_prepargs+0x24>;
    1928:	01 60       	R1=0(x);
    192a:	ef b1       	[P5+0x1c]=R7;
    192c:	a9 b1       	[P5+0x18]=R1;
    192e:	69 b0       	[P5+0x4]=R1;
    1930:	a9 b0       	[P5+0x8]=R1;
    1932:	ff e3 a9 fa 	CALL  e84 <__ppfs_setargs>;
    1936:	af b1       	[P5+0x18]=R7;
    1938:	66 6c       	SP+=12;
    193a:	bd 05       	( R7:7, P5:5)  = [SP++];
    193c:	01 e8 00 00 	UNLINK;
    1940:	10 00       	RTS;
	...

00001944 <_tcgetattr>:
    1944:	00 e8 09 00 	LINK0x24;
    1948:	fd 05       	[--SP] = ( R7:7, P5:5 );
    194a:	a6 6f       	SP+=-12;
    194c:	29 32       	P5=R1;
    194e:	57 30       	R2=FP;
    1950:	e2 66       	R2+=-36;
    1952:	21 e1 01 54 	R1=21505 (X);
    1956:	00 e3 4f 02 	CALL  1df4 <_ioctl>;
    195a:	38 30       	R7=R0;
    195c:	70 b9       	R0=[FP--36];
    195e:	28 93       	[P5]=R0;
    1960:	80 b9       	R0=[FP--32];
    1962:	68 b0       	[P5+0x4]=R0;
    1964:	90 b9       	R0=[FP--28];
    1966:	a8 b0       	[P5+0x8]=R0;
    1968:	a0 b9       	R0=[FP--24];
    196a:	e8 b0       	[P5+0xc]=R0;
    196c:	b8 e5 ec ff 	R0=B[FP+-20](X);
    1970:	a8 e6 10 00 	B[P5+16]=R0;
    1974:	8d 6c       	P5+=17;
    1976:	4f 30       	R1=FP;
    1978:	69 67       	R1+=-19;
    197a:	45 30       	R0=P5;
    197c:	9a 60       	R2=19(x);
    197e:	00 e3 45 02 	CALL  1e08 <_mempcpy>;
    1982:	01 60       	R1=0(x);
    1984:	6a 60       	R2=13(x);
    1986:	00 e3 0d 02 	CALL  1da0 <_memset>;
    198a:	07 30       	R0=R7;
    198c:	66 6c       	SP+=12;
    198e:	bd 05       	( R7:7, P5:5)  = [SP++];
    1990:	01 e8 00 00 	UNLINK;
    1994:	10 00       	RTS;
	...

00001998 <___libc_write>:
    1998:	00 e8 00 00 	LINK0x0;
    199c:	68 05       	[--SP] = ( R7:5);
    199e:	00 32       	P0=R0;
    19a0:	09 32       	P1=R1;
    19a2:	12 32       	P2=R2;
    19a4:	45 01       	[--SP] = R5;
    19a6:	52 30       	R2=P2;
    19a8:	49 30       	R1=P1;
    19aa:	40 30       	R0=P0;
    19ac:	25 60       	R5=4(x);
    19ae:	a0 00       	EXCPT  0x0;
    19b0:	18 30       	R3=R0;
    19b2:	35 90       	R5=[SP++];
    19b4:	21 e1 82 ff 	R1=-126 (X);
    19b8:	98 43       	R0=-R3;
    19ba:	0b 0a       	CC=R3<=R1(IU);
    19bc:	07 18       	IFCCJUMP  19ca <___libc_write+0x32>;
    19be:	0a e1 28 5f 	P2.L=5f28 <__errno>;
    19c2:	4a e1 00 00 	P2.H=0 <_start>;
    19c6:	10 93       	[P2]=R0;
    19c8:	fb 63       	R3=-1(x);
    19ca:	03 30       	R0=R3;
    19cc:	28 05       	( R7:5) = [SP++];
    19ce:	01 e8 00 00 	UNLINK;
    19d2:	10 00       	RTS;

000019d4 <_fseek>:
    19d4:	00 e8 01 00 	LINK0x4;
    19d8:	f5 05       	[--SP] = ( R7:6, P5:5 );
    19da:	a6 6f       	SP+=-12;
    19dc:	28 32       	P5=R0;
    19de:	3a 30       	R7=R2;
    19e0:	fe 63       	R6=-1(x);
    19e2:	12 0e       	CC=R2<=0x2(IU);
    19e4:	f8 63       	R0=-1(x);
    19e6:	2c 10       	IF!CCJUMP  1a3e <_fseek+0x6a>;
    19e8:	2a 95       	R2=W[P5] (Z);
    19ea:	f1 bb       	[FP--4]=R1;
    19ec:	21 e1 00 20 	R1=8192 (X);
    19f0:	8a 54       	R2=R2&R1;
    19f2:	45 30       	R0=P5;
    19f4:	02 0c       	CC=R2==0;
    19f6:	1f 10       	IF!CCJUMP  1a34 <_fseek+0x60>;
    19f8:	4f 30       	R1=FP;
    19fa:	e1 67       	R1+=-4;
    19fc:	45 30       	R0=P5;
    19fe:	0f 0c       	CC=R7==1;
    1a00:	15 18       	IFCCJUMP  1a2a <_fseek+0x56>;
    1a02:	4f 30       	R1=FP;
    1a04:	17 30       	R2=R7;
    1a06:	45 30       	R0=P5;
    1a08:	e1 67       	R1+=-4;
    1a0a:	00 e3 25 00 	CALL  1a54 <__stdio_lseek>;
    1a0e:	80 0c       	CC=R0<0;
    1a10:	0b 18       	IFCCJUMP  1a26 <_fseek+0x52>;
    1a12:	6a 95       	R2=W[P5](X);
    1a14:	20 e1 f8 cf 	R0=-12296 (X);
    1a18:	e9 a0       	R1=[P5+0xc];
    1a1a:	02 54       	R0=R2&R0;
    1a1c:	06 60       	R6=0(x);
    1a1e:	28 97       	W[P5]=R0;
    1a20:	e9 b1       	[P5+0x1c]=R1;
    1a22:	a9 b1       	[P5+0x18]=R1;
    1a24:	69 b1       	[P5+0x14]=R1;
    1a26:	06 30       	R0=R6;
    1a28:	
OFFSET = 17 
11 20       	JUMP.S  1a4a <_fseek+0x76>;
    1a2a:	00 e3 ff 01 	CALL  1e28 <__stdio_adjpos>;
    1a2e:	80 0c       	CC=R0<0;
    1a30:	e9 13       	IF!CCJUMP  1a02 <_fseek+0x2e>;
    1a32:	
OFFSET = 4090 
fa 2f       	JUMP.S  1a26 <_fseek+0x52>;
    1a34:	ff e3 9e f6 	CALL  770 <_fflush>;
    1a38:	00 0c       	CC=R0==0;
    1a3a:	f6 13       	IF!CCJUMP  1a26 <_fseek+0x52>;
    1a3c:	
OFFSET = 4062 
de 2f       	JUMP.S  19f8 <_fseek+0x24>;
    1a3e:	0a e1 28 5f 	P2.L=5f28 <__errno>;
    1a42:	4a e1 00 00 	P2.H=0 <_start>;
    1a46:	b1 60       	R1=22(x);
    1a48:	11 93       	[P2]=R1;
    1a4a:	66 6c       	SP+=12;
    1a4c:	b5 05       	( R7:6, P5:5)  = [SP++];
    1a4e:	01 e8 00 00 	UNLINK;
    1a52:	10 00       	RTS;

00001a54 <__stdio_lseek>:
    1a54:	00 e8 00 00 	LINK0x0;
    1a58:	c5 04       	[--SP] = ( P5:5);
    1a5a:	a6 6f       	SP+=-12;
    1a5c:	10 32       	P2=R0;
    1a5e:	29 32       	P5=R1;
    1a60:	29 91       	R1=[P5];
    1a62:	50 a0       	R0=[P2+0x4];
    1a64:	00 e3 06 02 	CALL  1e70 <___libc_lseek>;
    1a68:	f9 63       	R1=-1(x);
    1a6a:	80 0c       	CC=R0<0;
    1a6c:	03 18       	IFCCJUMP  1a72 <__stdio_lseek+0x1e>;
    1a6e:	28 93       	[P5]=R0;
    1a70:	01 60       	R1=0(x);
    1a72:	01 30       	R0=R1;
    1a74:	66 6c       	SP+=12;
    1a76:	85 04       	( P5:5) = [SP++];
    1a78:	01 e8 00 00 	UNLINK;
    1a7c:	10 00       	RTS;
	...

00001a80 <___C_ctype_b_data>:
	...
    1b80:	00 02       	R0=CC;
    1b82:	00 02       	R0=CC;
    1b84:	00 02       	R0=CC;
    1b86:	00 02       	R0=CC;
    1b88:	00 02       	R0=CC;
    1b8a:	00 02       	R0=CC;
    1b8c:	00 02       	R0=CC;
    1b8e:	00 02       	R0=CC;
    1b90:	00 02       	R0=CC;
    1b92:	20 03       	CC|=AZ;
    1b94:	
00001d80 <_memcpy>:
    1d80:	00 e8 00 00 	LINK0x0;
    1d84:	18 30       	R3=R0;
    1d86:	09 32       	P1=R1;
    1d88:	13 32       	P2=R3;
    1d8a:	02 0c       	CC=R2==0;
    1d8c:	06 18       	IFCCJUMP  1d98 <_memcpy+0x18>;
    1d8e:	48 98       	R0=B[P1++](X);
    1d90:	fa 67       	R2+=-1;
    1d92:	10 9a       	B[P2++]=R0;
    1d94:	02 0c       	CC=R2==0;
    1d96:	fc 17       	IF!CCJUMP  1d8e <_memcpy+0xe>(BP);
    1d98:	03 30       	R0=R3;
    1d9a:	01 e8 00 00 	UNLINK;
    1d9e:	10 00       	RTS;

00001da0 <_memset>:
    1da0:	00 e8 00 00 	LINK0x0;
    1da4:	10 32       	P2=R0;
    1da6:	02 0c       	CC=R2==0;
    1da8:	05 18       	IFCCJUMP  1db2 <_memset+0x12>;
    1daa:	fa 67       	R2+=-1;
    1dac:	11 9a       	B[P2++]=R1;
    1dae:	02 0c       	CC=R2==0;
    1db0:	fd 17       	IF!CCJUMP  1daa <_memset+0xa>(BP);
    1db2:	01 e8 00 00 	UNLINK;
    1db6:	10 00       	RTS;

00001db8 <___syscall_ioctl>:
    1db8:	00 e8 00 00 	LINK0x0;
    1dbc:	68 05       	[--SP] = ( R7:5);
    1dbe:	00 32       	P0=R0;
    1dc0:	09 32       	P1=R1;
    1dc2:	12 32       	P2=R2;
    1dc4:	45 01       	[--SP] = R5;
    1dc6:	52 30       	R2=P2;
    1dc8:	49 30       	R1=P1;
    1dca:	40 30       	R0=P0;
    1dcc:	b5 61       	R5=54(x);
    1dce:	a0 00       	EXCPT  0x0;
    1dd0:	18 30       	R3=R0;
    1dd2:	35 90       	R5=[SP++];
    1dd4:	21 e1 82 ff 	R1=-126 (X);
    1dd8:	98 43       	R0=-R3;
    1dda:	0b 0a       	CC=R3<=R1(IU);
    1ddc:	07 18       	IFCCJUMP  1dea <___syscall_ioctl+0x32>;
    1dde:	0a e1 28 5f 	P2.L=5f28 <__errno>;
    1de2:	4a e1 00 00 	P2.H=0 <_start>;
    1de6:	10 93       	[P2]=R0;
    1de8:	fb 63       	R3=-1(x);
    1dea:	03 30       	R0=R3;
    1dec:	28 05       	( R7:5) = [SP++];
    1dee:	01 e8 00 00 	UNLINK;
    1df2:	10 00       	RTS;

00001df4 <_ioctl>:
    1df4:	00 e8 00 00 	LINK0x0;
    1df8:	a6 6f       	SP+=-12;
    1dfa:	3a b1       	[FP+0x10]=R2;
    1dfc:	ff e3 de ff 	CALL  1db8 <___syscall_ioctl>;
    1e00:	66 6c       	SP+=12;
    1e02:	01 e8 00 00 	UNLINK;
    1e06:	10 00       	RTS;

00001e08 <_mempcpy>:
    1e08:	00 e8 00 00 	LINK0x0;
    1e0c:	10 32       	P2=R0;
    1e0e:	09 32       	P1=R1;
    1e10:	02 0c       	CC=R2==0;
    1e12:	06 18       	IFCCJUMP  1e1e <_mempcpy+0x16>;
    1e14:	48 98       	R0=B[P1++](X);
    1e16:	fa 67       	R2+=-1;
    1e18:	10 9a       	B[P2++]=R0;
    1e1a:	02 0c       	CC=R2==0;
    1e1c:	fc 17       	IF!CCJUMP  1e14 <_mempcpy+0xc>(BP);
    1e1e:	42 30       	R0=P2;
    1e20:	01 e8 00 00 	UNLINK;
    1e24:	10 00       	RTS;
	...

00001e28 <__stdio_adjpos>:
    1e28:	00 e8 00 00 	LINK0x0;
    1e2c:	78 05       	[--SP] = ( R7:7);
    1e2e:	10 32       	P2=R0;
    1e30:	12 95       	R2=W[P2] (Z);
    1e32:	20 e1 00 10 	R0=4096 (X);
    1e36:	c2 55       	R7=R2&R0;
    1e38:	18 60       	R0=3(x);
    1e3a:	c2 54       	R3=R2&R0;
    1e3c:	20 e1 00 20 	R0=8192 (X);
    1e40:	82 54       	R2=R2&R0;
    1e42:	09 32       	P1=R1;
    1e44:	02 0c       	CC=R2==0;
    1e46:	05 18       	IFCCJUMP  1e50 <__stdio_adjpos+0x28>;
    1e48:	50 a1       	R0=[P2+0x14];
    1e4a:	d1 a0       	R1=[P2+0xc];
    1e4c:	08 52       	R0=R0-R1;
    1e4e:	c3 52       	R3=R3-R0;
    1e50:	07 0c       	CC=R7==0;
    1e52:	05 18       	IFCCJUMP  1e5c <__stdio_adjpos+0x34>;
    1e54:	51 a1       	R1=[P2+0x14];
    1e56:	90 a1       	R0=[P2+0x18];
    1e58:	08 52       	R0=R0-R1;
    1e5a:	c3 50       	R3=R3+R0;
    1e5c:	0a 91       	R2=[P1];
    1e5e:	5a 52       	R1=R2-R3;
    1e60:	98 43       	R0=-R3;
    1e62:	11 09       	CC=R1<=R2;
    1e64:	09 93       	[P1]=R1;
    1e66:	03 07       	IF CC R0 = R3;
    1e68:	38 05       	( R7:7) = [SP++];
    1e6a:	01 e8 00 00 	UNLINK;
    1e6e:	10 00       	RTS;

00001e70 <___libc_lseek>:
    1e70:	00 e8 00 00 	LINK0x0;
    1e74:	68 05       	[--SP] = ( R7:5);
    1e76:	00 32       	P0=R0;
    1e78:	09 32       	P1=R1;
    1e7a:	12 32       	P2=R2;
    1e7c:	45 01       	[--SP] = R5;
    1e7e:	52 30       	R2=P2;
    1e80:	49 30       	R1=P1;
    1e82:	40 30       	R0=P0;
    1e84:	9d 60       	R5=19(x);
    1e86:	a0 00       	EXCPT  0x0;
    1e88:	18 30       	R3=R0;
    1e8a:	35 90       	R5=[SP++];
    1e8c:	21 e1 82 ff 	R1=-126 (X);
    1e90:	98 43       	R0=-R3;
    1e92:	0b 0a       	CC=R3<=R1(IU);
    1e94:	07 18       	IFCCJUMP  1ea2 <___libc_lseek+0x32>;
    1e96:	0a e1 28 5f 	P2.L=5f28 <__errno>;
    1e9a:	4a e1 00 00 	P2.H=0 <_start>;
    1e9e:	10 93       	[P2]=R0;
    1ea0:	fb 63       	R3=-1(x);
    1ea2:	03 30       	R0=R3;
    1ea4:	28 05       	( R7:5) = [SP++];
    1ea6:	01 e8 00 00 	UNLINK;
    1eaa:	10 00       	RTS;

00001eac <___do_global_dtors>:
/* Run all the global destructors on exit from the program.  */

void
__do_global_dtors (void)
{
    1eac:	00 e8 00 00 	LINK0x0;
    1eb0:	c5 04       	[--SP] = ( P5:5);
    1eb2:	a6 6f       	SP+=-12;
#ifdef DO_GLOBAL_DTORS_BODY
  DO_GLOBAL_DTORS_BODY;
#else
  static func_ptr *p = __DTOR_LIST__ + 1;
  while (*p)
    1eb4:	0d e1 38 5f 	P5.L=5f38 <L_p_$0>;
    1eb8:	4d e1 00 00 	P5.H=0 <_start>;
    1ebc:	6a 91       	P2=[P5];
    1ebe:	10 91       	R0=[P2];
    1ec0:	00 0c       	CC=R0==0;
    1ec2:	0b 18       	IFCCJUMP  1ed8 <___do_global_dtors+0x2c>;
    {
      p++;
    1ec4:	6a 91       	P2=[P5];
    1ec6:	22 6c       	P2+=4;
    1ec8:	6a 93       	[P5]=P2;
    1eca:	e2 6f       	P2+=-4;
      (*(p-1)) ();
    1ecc:	52 91       	P2=[P2];
    1ece:	62 00       	CALL  (P2);
    1ed0:	6a 91       	P2=[P5];
    1ed2:	10 91       	R0=[P2];
    1ed4:	00 0c       	CC=R0==0;
    1ed6:	f7 17       	IF!CCJUMP  1ec4 <___do_global_dtors+0x18>(BP);
    1ed8:	66 6c       	SP+=12;
    1eda:	85 04       	( P5:5) = [SP++];
    1edc:	01 e8 00 00 	UNLINK;
    1ee0:	10 00       	RTS;
	...

00001ee4 <___do_global_ctors>:
    }
#endif
#if defined (EH_FRAME_SECTION_NAME) && !defined (HAS_INIT_SECTION)
  {
    static int completed = 0;
    if (! completed)
      {
	completed = 1;
	__deregister_frame_info (__EH_FRAME_BEGIN__);
      }
  }
#endif
}
#endif

#ifndef HAS_INIT_SECTION
/* Run all the global constructors on entry to the program.  */

void
__do_global_ctors (void)
{
    1ee4:	00 e8 00 00 	LINK0x0;
    1ee8:	c4 04       	[--SP] = ( P5:4);
    1eea:	a6 6f       	SP+=-12;
#ifdef EH_FRAME_SECTION_NAME
  {
    static struct object object;
    __register_frame_info (__EH_FRAME_BEGIN__, &object);
  }
#endif
  DO_GLOBAL_CTORS_BODY;
    1eec:	09 e1 40 5f 	P1.L=5f40 <___CTOR_LIST__>;
    1ef0:	49 e1 00 00 	P1.H=0 <_start>;
    1ef4:	09 91       	R1=[P1];
    1ef6:	39 0c       	CC=R1==-1;
    1ef8:	0b 18       	IFCCJUMP  1f0e <___do_global_ctors+0x2a>;
    1efa:	29 32       	P5=R1;
    1efc:	45 0c       	CC=P5==0;
    1efe:	16 18       	IFCCJUMP  1f2a <___do_global_ctors+0x46>;
    1f00:	29 5f       	P4=P1+(P5<<2);
    1f02:	e2 90       	P2=[P4--];
    1f04:	fd 6f       	P5+=-1;
    1f06:	62 00       	CALL  (P2);
    1f08:	45 0c       	CC=P5==0;
    1f0a:	fc 13       	IF!CCJUMP  1f02 <___do_global_ctors+0x1e>;
    1f0c:	
OFFSET = 15 
0f 20       	JUMP.S  1f2a <___do_global_ctors+0x46>;
    1f0e:	0a e1 44 5f 	P2.L=5f44 <___CTOR_LIST__+0x4>;
    1f12:	4a e1 00 00 	P2.H=0 <_start>;
    1f16:	10 91       	R0=[P2];
    1f18:	01 60       	R1=0(x);
    1f1a:	00 0c       	CC=R0==0;
    1f1c:	ef 1b       	IFCCJUMP  1efa <___do_global_ctors+0x16>;
    1f1e:	22 6c       	P2+=4;
    1f20:	10 91       	R0=[P2];
    1f22:	09 64       	R1+=1;
    1f24:	00 0c       	CC=R0==0;
    1f26:	fc 13       	IF!CCJUMP  1f1e <___do_global_ctors+0x3a>;
    1f28:	
OFFSET = 4073 
e9 2f       	JUMP.S  1efa <___do_global_ctors+0x16>;
  atexit (__do_global_dtors);
    1f2a:	00 e1 ac 1e 	R0.L=7852;
    1f2e:	40 e1 00 00 	R0.H=0;
    1f32:	00 e3 25 06 	CALL  2b7c <_atexit>;
    1f36:	66 6c       	SP+=12;
    1f38:	84 04       	( P5:4) = [SP++];
    1f3a:	01 e8 00 00 	UNLINK;
    1f3e:	10 00       	RTS;

00001f40 <___main>:
}
#endif /* no HAS_INIT_SECTION */

#if !defined (HAS_INIT_SECTION) || defined (INVOKE__main)
/* Subroutine called automatically by `main'.
   Compiling a global function named `main'
   produces an automatic call to this function at the beginning.

   For many systems, this routine calls __do_global_ctors.
   For systems which support a .init section we use the .init section
   to run __do_global_ctors, so we need not do anything here.  */

void
SYMBOL__MAIN ()
{
    1f40:	00 e8 00 00 	LINK0x0;
    1f44:	a6 6f       	SP+=-12;
  /* Support recursive calls to `main': run initializers just once.  */
  static int initialized;
  if (! initialized)
    1f46:	0a e1 3c 5f 	P2.L=5f3c <L_initialized_$1>;
    1f4a:	4a e1 00 00 	P2.H=0 <_start>;
    1f4e:	10 91       	R0=[P2];
    1f50:	00 0c       	CC=R0==0;
    1f52:	05 10       	IF!CCJUMP  1f5c <___main+0x1c>;
    {
      initialized = 1;
    1f54:	08 60       	R0=1(x);
    1f56:	10 93       	[P2]=R0;
      __do_global_ctors ();
    1f58:	ff e3 c6 ff 	CALL  1ee4 <___do_global_ctors>;
    }
}
    1f5c:	66 6c       	SP+=12;
    1f5e:	01 e8 00 00 	UNLINK;
    1f62:	10 00       	RTS;

00001f64 <___udivsi3>:
    1f64:	67 01       	[--SP] = RETS;
    1f66:	44 01       	[--SP] = R4;
    1f68:	4c 01       	[--SP] = P4;
    1f6a:	04 69       	P4=32;
    1f6c:	a3 e0 0f 40 	LSETUP(1f72 <udiv_begin>,1f8a <udiv_end>)LC0=P4;
    1f70:	03 60       	R3=0(x);

00001f72 <udiv_begin>:
    1f72:	00 e3 12 00 	CALL  1f96 <lshft>;
    1f76:	13 30       	R2=R3;
    1f78:	cb 52       	R3=R3-R1;
    1f7a:	83 0c       	CC=R3<0;
    1f7c:	05 10       	IF!CCJUMP  1f86 <one_qb>;
    1f7e:	1a 30       	R3=R2;
    1f80:	f2 63       	R2=-2(x);
    1f82:	10 54       	R0=R0&R2;
    1f84:	
OFFSET = 3 
03 20       	JUMP.S  1f8a <udiv_end>;

00001f86 <one_qb>:
    1f86:	0a 60       	R2=1(x);
    1f88:	10 56       	R0=R0|R2;

00001f8a <udiv_end>:
	...

00001f8c <return>:
    1f8c:	0b 30       	R1=R3;
    1f8e:	74 90       	P4=[SP++];
    1f90:	34 90       	R4=[SP++];
    1f92:	27 01       	RETS = [SP++];
    1f94:	10 00       	RTS;

00001f96 <lshft>:
    1f96:	10 30       	R2=R0;
    1f98:	fc 60       	R4=31(x);
    1f9a:	62 40       	R2>>=R4;
    1f9c:	0c 60       	R4=1(x);
    1f9e:	a2 54       	R2=R2&R4;
    1fa0:	0b 4f       	R3<<=0x1;
    1fa2:	d3 56       	R3=R3|R2;
    1fa4:	08 4f       	R0<<=0x1;
    1fa6:	10 00       	RTS;

00001fa8 <___umodsi3>:
    1fa8:	00 e8 00 00 	LINK0x0;
    1fac:	70 05       	[--SP] = ( R7:6);
    1fae:	30 30       	R6=R0;
    1fb0:	39 30       	R7=R1;
    1fb2:	ff e3 d9 ff 	CALL  1f64 <___udivsi3>;
    1fb6:	c7 40       	R7*=R0;
    1fb8:	3e 52       	R0=R6-R7;
    1fba:	30 05       	( R7:6) = [SP++];
    1fbc:	01 e8 00 00 	UNLINK;
    1fc0:	10 00       	RTS;
	...

00001fc4 <___nedf2>:
    1fc4:	00 e8 00 00 	LINK0x0;
    1fc8:	a6 6f       	SP+=-12;
    1fca:	b8 b0       	[FP+0x8]=R0;
    1fcc:	f9 b0       	[FP+0xc]=R1;
    1fce:	3a b1       	[FP+0x10]=R2;
    1fd0:	b8 a0       	R0=[FP+0x8];
    1fd2:	f9 a0       	R1=[FP+0xc];
    1fd4:	00 e3 32 01 	CALL  2238 <___truncdfsf2>;
    1fd8:	10 30       	R2=R0;
    1fda:	38 a1       	R0=[FP+0x10];
    1fdc:	79 a1       	R1=[FP+0x14];
    1fde:	00 e3 2d 01 	CALL  2238 <___truncdfsf2>;
    1fe2:	08 30       	R1=R0;
    1fe4:	b0 a0       	R0=[SP+0x8];
    1fe6:	66 6c       	SP+=12;
    1fe8:	00 e3 5a 01 	CALL  229c <___nesf2>;
    1fec:	01 e8 00 00 	UNLINK;
    1ff0:	10 00       	RTS;
	...

00001ff4 <___eqdf2>:
    1ff4:	00 e8 00 00 	LINK0x0;
    1ff8:	a6 6f       	SP+=-12;
    1ffa:	b8 b0       	[FP+0x8]=R0;
    1ffc:	f9 b0       	[FP+0xc]=R1;
    1ffe:	3a b1       	[FP+0x10]=R2;
    2000:	b8 a0       	R0=[FP+0x8];
    2002:	f9 a0       	R1=[FP+0xc];
    2004:	00 e3 1a 01 	CALL  2238 <___truncdfsf2>;
    2008:	10 30       	R2=R0;
    200a:	38 a1       	R0=[FP+0x10];
    200c:	79 a1       	R1=[FP+0x14];
    200e:	00 e3 15 01 	CALL  2238 <___truncdfsf2>;
    2012:	08 30       	R1=R0;
    2014:	b0 a0       	R0=[SP+0x8];
    2016:	66 6c       	SP+=12;
    2018:	00 e3 72 01 	CALL  22fc <___eqsf2>;
    201c:	01 e8 00 00 	UNLINK;
    2020:	10 00       	RTS;
	...

00002024 <___ltdf2>:
    2024:	00 e8 00 00 	LINK0x0;
    2028:	a6 6f       	SP+=-12;
    202a:	b8 b0       	[FP+0x8]=R0;
    202c:	f9 b0       	[FP+0xc]=R1;
    202e:	3a b1       	[FP+0x10]=R2;
    2030:	b8 a0       	R0=[FP+0x8];
    2032:	f9 a0       	R1=[FP+0xc];
    2034:	00 e3 02 01 	CALL  2238 <___truncdfsf2>;
    2038:	10 30       	R2=R0;
    203a:	38 a1       	R0=[FP+0x10];
    203c:	79 a1       	R1=[FP+0x14];
    203e:	00 e3 fd 00 	CALL  2238 <___truncdfsf2>;
    2042:	08 30       	R1=R0;
    2044:	b0 a0       	R0=[SP+0x8];
    2046:	66 6c       	SP+=12;
    2048:	00 e3 8a 01 	CALL  235c <___ltsf2>;
    204c:	01 e8 00 00 	UNLINK;
    2050:	10 00       	RTS;
	...

00002054 <___muldf3>:
    2054:	00 e8 00 00 	LINK0x0;
    2058:	a6 6f       	SP+=-12;
    205a:	b8 b0       	[FP+0x8]=R0;
    205c:	f9 b0       	[FP+0xc]=R1;
    205e:	3a b1       	[FP+0x10]=R2;
    2060:	b8 a0       	R0=[FP+0x8];
    2062:	f9 a0       	R1=[FP+0xc];
    2064:	00 e3 ea 00 	CALL  2238 <___truncdfsf2>;
    2068:	10 30       	R2=R0;
    206a:	38 a1       	R0=[FP+0x10];
    206c:	79 a1       	R1=[FP+0x14];
    206e:	00 e3 e5 00 	CALL  2238 <___truncdfsf2>;
    2072:	08 30       	R1=R0;
    2074:	b0 a0       	R0=[SP+0x8];
    2076:	66 6c       	SP+=12;
    2078:	00 e3 a2 01 	CALL  23bc <___mulsf3>;
    207c:	00 e3 68 02 	CALL  254c <___extendsfdf2>;
    2080:	01 e8 00 00 	UNLINK;
    2084:	10 00       	RTS;
	...

00002088 <___gedf2>:
    2088:	00 e8 00 00 	LINK0x0;
    208c:	a6 6f       	SP+=-12;
    208e:	b8 b0       	[FP+0x8]=R0;
    2090:	f9 b0       	[FP+0xc]=R1;
    2092:	3a b1       	[FP+0x10]=R2;
    2094:	b8 a0       	R0=[FP+0x8];
    2096:	f9 a0       	R1=[FP+0xc];
    2098:	00 e3 d0 00 	CALL  2238 <___truncdfsf2>;
    209c:	10 30       	R2=R0;
    209e:	38 a1       	R0=[FP+0x10];
    20a0:	79 a1       	R1=[FP+0x14];
    20a2:	00 e3 cb 00 	CALL  2238 <___truncdfsf2>;
    20a6:	08 30       	R1=R0;
    20a8:	b0 a0       	R0=[SP+0x8];
    20aa:	66 6c       	SP+=12;
    20ac:	00 e3 72 02 	CALL  2590 <___gesf2>;
    20b0:	01 e8 00 00 	UNLINK;
    20b4:	10 00       	RTS;
	...

000020b8 <___divdf3>:
    20b8:	00 e8 00 00 	LINK0x0;
    20bc:	a6 6f       	SP+=-12;
    20be:	b8 b0       	[FP+0x8]=R0;
    20c0:	f9 b0       	[FP+0xc]=R1;
    20c2:	3a b1       	[FP+0x10]=R2;
    20c4:	b8 a0       	R0=[FP+0x8];
    20c6:	f9 a0       	R1=[FP+0xc];
    20c8:	00 e3 b8 00 	CALL  2238 <___truncdfsf2>;
    20cc:	10 30       	R2=R0;
    20ce:	38 a1       	R0=[FP+0x10];
    20d0:	79 a1       	R1=[FP+0x14];
    20d2:	00 e3 b3 00 	CALL  2238 <___truncdfsf2>;
    20d6:	08 30       	R1=R0;
    20d8:	b0 a0       	R0=[SP+0x8];
    20da:	66 6c       	SP+=12;
    20dc:	00 e3 8a 02 	CALL  25f0 <___divsf3>;
    20e0:	00 e3 36 02 	CALL  254c <___extendsfdf2>;
    20e4:	01 e8 00 00 	UNLINK;
    20e8:	10 00       	RTS;
	...

000020ec <___fixunsdfsi>:
    20ec:	00 e8 00 00 	LINK0x0;
    20f0:	78 05       	[--SP] = ( R7:7);
    20f2:	a6 6f       	SP+=-12;
    20f4:	38 30       	R7=R0;
    20f6:	01 e1 00 00 	R1.L=0;
    20fa:	41 e1 00 4f 	R1.H=20224;
    20fe:	00 e3 49 02 	CALL  2590 <___gesf2>;
    2102:	10 30       	R2=R0;
    2104:	07 30       	R0=R7;
    2106:	01 e1 00 00 	R1.L=0;
    210a:	41 e1 00 cf 	R1.H=-12544;
    210e:	82 0c       	CC=R2<0;
    2110:	09 18       	IFCCJUMP  2122 <___fixunsdfsi+0x36>;
    2112:	00 e3 39 03 	CALL  2784 <___addsf3>;
    2116:	00 e3 0d 04 	CALL  2930 <___fixsfsi>;
    211a:	f9 63       	R1=-1(x);
    211c:	f9 4f       	R1<<=0x1f;
    211e:	08 50       	R0=R0+R1;
    2120:	
OFFSET = 4 
04 20       	JUMP.S  2128 <___fixunsdfsi+0x3c>;
    2122:	07 30       	R0=R7;
    2124:	00 e3 06 04 	CALL  2930 <___fixsfsi>;
    2128:	66 6c       	SP+=12;
    212a:	38 05       	( R7:7) = [SP++];
    212c:	01 e8 00 00 	UNLINK;
    2130:	10 00       	RTS;
	...

00002134 <___floatsidf>:
    2134:	00 e8 00 00 	LINK0x0;
    2138:	00 e3 38 04 	CALL  29a8 <___floatsisf>;
    213c:	00 e3 08 02 	CALL  254c <___extendsfdf2>;
    2140:	01 e8 00 00 	UNLINK;
    2144:	10 00       	RTS;
	...

00002148 <___subdf3>:
    2148:	00 e8 00 00 	LINK0x0;
    214c:	a6 6f       	SP+=-12;
    214e:	b8 b0       	[FP+0x8]=R0;
    2150:	f9 b0       	[FP+0xc]=R1;
    2152:	3a b1       	[FP+0x10]=R2;
    2154:	b8 a0       	R0=[FP+0x8];
    2156:	f9 a0       	R1=[FP+0xc];
    2158:	00 e3 70 00 	CALL  2238 <___truncdfsf2>;
    215c:	10 30       	R2=R0;
    215e:	38 a1       	R0=[FP+0x10];
    2160:	79 a1       	R1=[FP+0x14];
    2162:	00 e3 6b 00 	CALL  2238 <___truncdfsf2>;
    2166:	08 30       	R1=R0;
    2168:	b0 a0       	R0=[SP+0x8];
    216a:	66 6c       	SP+=12;
    216c:	00 e3 52 04 	CALL  2a10 <___subsf3>;
    2170:	00 e3 ee 01 	CALL  254c <___extendsfdf2>;
    2174:	01 e8 00 00 	UNLINK;
    2178:	10 00       	RTS;
	...

0000217c <___modsi3>:
    217c:	00 e8 00 00 	LINK0x0;
    2180:	70 05       	[--SP] = ( R7:6);
    2182:	30 30       	R6=R0;
    2184:	39 30       	R7=R1;
    2186:	00 e3 09 00 	CALL  2198 <___divsi3>;
    218a:	c7 40       	R7*=R0;
    218c:	3e 52       	R0=R6-R7;
    218e:	30 05       	( R7:6) = [SP++];
    2190:	01 e8 00 00 	UNLINK;
    2194:	10 00       	RTS;
	...

00002198 <___divsi3>:
    2198:	1f 31       	R3=RETS;
    219a:	43 01       	[--SP] = R3;
    219c:	80 0c       	CC=R0<0;
    219e:	05 18       	IFCCJUMP  21a8 <num_neg>;
    21a0:	81 0c       	CC=R1<0;
    21a2:	0b 18       	IFCCJUMP  21b8 <den_neg>;
    21a4:	00 e3 12 00 	CALL  21c8 <pos_ans>;

000021a8 <num_neg>:
    21a8:	81 0c       	CC=R1<0;
    21aa:	0d 18       	IFCCJUMP  21c4 <both_neg>;
    21ac:	80 43       	R0=-R0;
    21ae:	ff e3 db fe 	CALL  1f64 <___udivsi3>;
    21b2:	80 43       	R0=-R0;
    21b4:	00 e3 11 00 	CALL  21d6 <done>;

000021b8 <den_neg>:
    21b8:	89 43       	R1=-R1;
    21ba:	ff e3 d5 fe 	CALL  1f64 <___udivsi3>;
    21be:	80 43       	R0=-R0;
    21c0:	00 e3 0b 00 	CALL  21d6 <done>;

000021c4 <both_neg>:
    21c4:	80 43       	R0=-R0;
    21c6:	89 43       	R1=-R1;

000021c8 <pos_ans>:
    21c8:	ff e3 ce fe 	CALL  1f64 <___udivsi3>;
    21cc:	00 00       	NOP;
    21ce:	00 00       	NOP;
    21d0:	00 e3 03 00 	CALL  21d6 <done>;
	...

000021d6 <done>:
    21d6:	33 90       	R3=[SP++];
    21d8:	3b 38       	RETS=R3;
    21da:	10 00       	RTS;

000021dc <___adddf3>:
    21dc:	00 e8 00 00 	LINK0x0;
    21e0:	a6 6f       	SP+=-12;
    21e2:	b8 b0       	[FP+0x8]=R0;
    21e4:	f9 b0       	[FP+0xc]=R1;
    21e6:	3a b1       	[FP+0x10]=R2;
    21e8:	b8 a0       	R0=[FP+0x8];
    21ea:	f9 a0       	R1=[FP+0xc];
    21ec:	00 e3 26 00 	CALL  2238 <___truncdfsf2>;
    21f0:	10 30       	R2=R0;
    21f2:	38 a1       	R0=[FP+0x10];
    21f4:	79 a1       	R1=[FP+0x14];
    21f6:	00 e3 21 00 	CALL  2238 <___truncdfsf2>;
    21fa:	08 30       	R1=R0;
    21fc:	b0 a0       	R0=[SP+0x8];
    21fe:	66 6c       	SP+=12;
    2200:	00 e3 c2 02 	CALL  2784 <___addsf3>;
    2204:	00 e3 a4 01 	CALL  254c <___extendsfdf2>;
    2208:	01 e8 00 00 	UNLINK;
    220c:	10 00       	RTS;
	...

00002210 <___negdf2>:
    2210:	00 e8 00 00 	LINK0x0;
    2214:	a6 6f       	SP+=-12;
    2216:	b8 b0       	[FP+0x8]=R0;
    2218:	f9 b0       	[FP+0xc]=R1;
    221a:	3a b1       	[FP+0x10]=R2;
    221c:	b8 a0       	R0=[FP+0x8];
    221e:	f9 a0       	R1=[FP+0xc];
    2220:	00 e3 0c 00 	CALL  2238 <___truncdfsf2>;
    2224:	66 6c       	SP+=12;
    2226:	00 0c       	CC=R0==0;
    2228:	02 18       	IFCCJUMP  222c <negdf2_4>;
    222a:	f8 4b       	BITTGL (R0,0x1f);

0000222c <negdf2_4>:
    222c:	00 e3 90 01 	CALL  254c <___extendsfdf2>;
    2230:	01 e8 00 00 	UNLINK;
    2234:	10 00       	RTS;
	...

00002238 <___truncdfsf2>:
    2238:	00 e8 00 00 	LINK0x0;
    223c:	78 05       	[--SP] = ( R7:7);
    223e:	b8 b0       	[FP+0x8]=R0;
    2240:	f9 b0       	[FP+0xc]=R1;
    2242:	3a b1       	[FP+0x10]=R2;
    2244:	bb a0       	R3=[FP+0x8];
    2246:	fa a0       	R2=[FP+0xc];
    2248:	02 0c       	CC=R2==0;
    224a:	06 10       	IF!CCJUMP  2256 <___truncdfsf2+0x1e>;
    224c:	03 0c       	CC=R3==0;
    224e:	04 10       	IF!CCJUMP  2256 <___truncdfsf2+0x1e>;
    2250:	80 e1 00 00 	R0=0 <_start>(Z);
    2254:	
OFFSET = 32 
20 20       	JUMP.S  2294 <___truncdfsf2+0x5c>;
    2256:	0a 32       	P1=R2;
    2258:	89 5a       	P2=P1<<1;
    225a:	42 30       	R0=P2;
    225c:	a8 4e       	R0>>=0x15;
    225e:	27 e1 80 fc 	R7=-896 (X);
    2262:	c7 51       	R7=R7+R0;
    2264:	00 e1 ff ff 	R0.L=-1;
    2268:	40 e1 0f 00 	R0.H=15;
    226c:	02 54       	R0=R2&R0;
    226e:	a0 4a       	BITSET (R0,0x14);
    2270:	50 4f       	R0<<=0xa;
    2272:	0b 30       	R1=R3;
    2274:	b1 4e       	R1>>=0x16;
    2276:	48 56       	R1=R0|R1;
    2278:	31 4e       	R1>>=0x6;
    227a:	09 64       	R1+=1;
    227c:	09 4d       	R1>>>=0x1;
    227e:	c1 48       	CC = ! BITTST (R1,0x18);
    2280:	03 18       	IFCCJUMP  2286 <___truncdfsf2+0x4e>;
    2282:	09 4d       	R1>>>=0x1;
    2284:	0f 64       	R7+=1;
    2286:	b9 4c       	BITCLR (R1,0x17);
    2288:	02 30       	R0=R2;
    228a:	f8 4d       	R0>>>=0x1f;
    228c:	f8 4f       	R0<<=0x1f;
    228e:	bf 4f       	R7<<=0x17;
    2290:	38 56       	R0=R0|R7;
    2292:	08 56       	R0=R0|R1;
    2294:	38 05       	( R7:7) = [SP++];
    2296:	01 e8 00 00 	UNLINK;
    229a:	10 00       	RTS;

0000229c <___nesf2>:
    229c:	00 e8 00 00 	LINK0x0;
    22a0:	78 05       	[--SP] = ( R7:7);
    22a2:	10 32       	P2=R0;
    22a4:	52 30       	R2=P2;
    22a6:	19 30       	R3=R1;
    22a8:	20 e1 ff 00 	R0=255 (X);
    22ac:	b8 4f       	R0<<=0x17;
    22ae:	02 54       	R0=R2&R0;
    22b0:	27 e1 ff 00 	R7=255 (X);
    22b4:	bf 4f       	R7<<=0x17;
    22b6:	38 08       	CC=R0==R7;
    22b8:	09 10       	IF!CCJUMP  22ca <nesf_7>;
    22ba:	00 e1 ff ff 	R0.L=-1;
    22be:	40 e1 7f 00 	R0.H=127;
    22c2:	02 54       	R0=R2&R0;
    22c4:	00 0d       	CC=R0<=0;
    22c6:	10 60       	R0=2(x);
    22c8:	16 10       	IF!CCJUMP  22f4 <nesf_9>;

000022ca <nesf_7>:
    22ca:	20 e1 ff 00 	R0=255 (X);
    22ce:	b8 4f       	R0<<=0x17;
    22d0:	03 54       	R0=R3&R0;
    22d2:	22 e1 ff 00 	R2=255 (X);
    22d6:	ba 4f       	R2<<=0x17;
    22d8:	10 08       	CC=R0==R2;
    22da:	0a 10       	IF!CCJUMP  22ee <nesf_8>;
    22dc:	00 e1 ff ff 	R0.L=-1;
    22e0:	40 e1 7f 00 	R0.H=127;
    22e4:	03 54       	R0=R3&R0;
    22e6:	00 0d       	CC=R0<=0;
    22e8:	03 18       	IFCCJUMP  22ee <nesf_8>;
    22ea:	10 60       	R0=2(x);
    22ec:	
OFFSET = 4 
04 20       	JUMP.S  22f4 <nesf_9>;

000022ee <nesf_8>:
    22ee:	42 30       	R0=P2;
    22f0:	00 e3 12 04 	CALL  2b14 <___cmpsf2>;

000022f4 <nesf_9>:
    22f4:	38 05       	( R7:7) = [SP++];
    22f6:	01 e8 00 00 	UNLINK;
    22fa:	10 00       	RTS;

000022fc <___eqsf2>:
    22fc:	00 e8 00 00 	LINK0x0;
    2300:	78 05       	[--SP] = ( R7:7);
    2302:	10 32       	P2=R0;
    2304:	52 30       	R2=P2;
    2306:	19 30       	R3=R1;
    2308:	20 e1 ff 00 	R0=255 (X);
    230c:	b8 4f       	R0<<=0x17;
    230e:	02 54       	R0=R2&R0;
    2310:	27 e1 ff 00 	R7=255 (X);
    2314:	bf 4f       	R7<<=0x17;
    2316:	38 08       	CC=R0==R7;
    2318:	09 10       	IF!CCJUMP  232a <eqsf_3>;
    231a:	00 e1 ff ff 	R0.L=-1;
    231e:	40 e1 7f 00 	R0.H=127;
    2322:	02 54       	R0=R2&R0;
    2324:	00 0d       	CC=R0<=0;
    2326:	10 60       	R0=2(x);
    2328:	16 10       	IF!CCJUMP  2354 <eqsf_5>;

0000232a <eqsf_3>:
    232a:	20 e1 ff 00 	R0=255 (X);
    232e:	b8 4f       	R0<<=0x17;
    2330:	03 54       	R0=R3&R0;
    2332:	22 e1 ff 00 	R2=255 (X);
    2336:	ba 4f       	R2<<=0x17;
    2338:	10 08       	CC=R0==R2;
    233a:	0a 10       	IF!CCJUMP  234e <eqsf_4>;
    233c:	00 e1 ff ff 	R0.L=-1;
    2340:	40 e1 7f 00 	R0.H=127;
    2344:	03 54       	R0=R3&R0;
    2346:	00 0d       	CC=R0<=0;
    2348:	03 18       	IFCCJUMP  234e <eqsf_4>;
    234a:	10 60       	R0=2(x);
    234c:	
OFFSET = 4 
04 20       	JUMP.S  2354 <eqsf_5>;

0000234e <eqsf_4>:
    234e:	42 30       	R0=P2;
    2350:	00 e3 e2 03 	CALL  2b14 <___cmpsf2>;

00002354 <eqsf_5>:
    2354:	38 05       	( R7:7) = [SP++];
    2356:	01 e8 00 00 	UNLINK;
    235a:	10 00       	RTS;

0000235c <___ltsf2>:
    235c:	00 e8 00 00 	LINK0x0;
    2360:	78 05       	[--SP] = ( R7:7);
    2362:	10 32       	P2=R0;
    2364:	52 30       	R2=P2;
    2366:	19 30       	R3=R1;
    2368:	20 e1 ff 00 	R0=255 (X);
    236c:	b8 4f       	R0<<=0x17;
    236e:	02 54       	R0=R2&R0;
    2370:	27 e1 ff 00 	R7=255 (X);
    2374:	bf 4f       	R7<<=0x17;
    2376:	38 08       	CC=R0==R7;
    2378:	09 10       	IF!CCJUMP  238a <ltsf_3>;
    237a:	00 e1 ff ff 	R0.L=-1;
    237e:	40 e1 7f 00 	R0.H=127;
    2382:	02 54       	R0=R2&R0;
    2384:	00 0d       	CC=R0<=0;
    2386:	10 60       	R0=2(x);
    2388:	16 10       	IF!CCJUMP  23b4 <ltsf_5>;

0000238a <ltsf_3>:
    238a:	20 e1 ff 00 	R0=255 (X);
    238e:	b8 4f       	R0<<=0x17;
    2390:	03 54       	R0=R3&R0;
    2392:	22 e1 ff 00 	R2=255 (X);
    2396:	ba 4f       	R2<<=0x17;
    2398:	10 08       	CC=R0==R2;
    239a:	0a 10       	IF!CCJUMP  23ae <ltsf_4>;
    239c:	00 e1 ff ff 	R0.L=-1;
    23a0:	40 e1 7f 00 	R0.H=127;
    23a4:	03 54       	R0=R3&R0;
    23a6:	00 0d       	CC=R0<=0;
    23a8:	03 18       	IFCCJUMP  23ae <ltsf_4>;
    23aa:	10 60       	R0=2(x);
    23ac:	
OFFSET = 4 
04 20       	JUMP.S  23b4 <ltsf_5>;

000023ae <ltsf_4>:
    23ae:	42 30       	R0=P2;
    23b0:	00 e3 b2 03 	CALL  2b14 <___cmpsf2>;

000023b4 <ltsf_5>:
    23b4:	38 05       	( R7:7) = [SP++];
    23b6:	01 e8 00 00 	UNLINK;
    23ba:	10 00       	RTS;

000023bc <___mulsf3>:
    23bc:	00 e8 01 00 	LINK0x4;
    23c0:	60 05       	[--SP] = ( R7:4);
    23c2:	28 30       	R5=R0;
    23c4:	31 30       	R6=R1;
    23c6:	21 e1 ff 00 	R1=255 (X);
    23ca:	b9 4f       	R1<<=0x17;
    23cc:	0d 54       	R0=R5&R1;
    23ce:	08 08       	CC=R0==R1;
    23d0:	42 10       	IF!CCJUMP  2454 <mulsf_3>;
    23d2:	02 e1 ff ff 	R2.L=-1;
    23d6:	42 e1 7f 00 	R2.H=127;
    23da:	15 54       	R0=R5&R2;
    23dc:	00 0c       	CC=R0==0;
    23de:	1a 10       	IF!CCJUMP  2412 <mulsf_4>;
    23e0:	06 0c       	CC=R6==0;
    23e2:	4c 18       	IFCCJUMP  247a <mulsf_16>;
    23e4:	f8 63       	R0=-1(x);
    23e6:	f8 4f       	R0<<=0x1f;
    23e8:	06 08       	CC=R6==R0;
    23ea:	48 18       	IFCCJUMP  247a <mulsf_16>;
    23ec:	0e 54       	R0=R6&R1;
    23ee:	21 e1 ff 00 	R1=255 (X);
    23f2:	b9 4f       	R1<<=0x17;
    23f4:	08 08       	CC=R0==R1;
    23f6:	09 10       	IF!CCJUMP  2408 <mulsf_7>;
    23f8:	16 54       	R0=R6&R2;
    23fa:	00 0c       	CC=R0==0;
    23fc:	4a 10       	IF!CCJUMP  2490 <mulsf_14>;
    23fe:	06 30       	R0=R6;
    2400:	f8 4d       	R0>>>=0x1f;
    2402:	f8 4f       	R0<<=0x1f;
    2404:	45 59       	R5=R5^R0;
    2406:	
OFFSET = 158 
9e 20       	JUMP.S  2542 <mulsf_23>;

00002408 <mulsf_7>:
    2408:	06 30       	R0=R6;
    240a:	f8 4d       	R0>>>=0x1f;
    240c:	f8 4f       	R0<<=0x1f;
    240e:	45 59       	R5=R5^R0;
    2410:	
OFFSET = 153 
99 20       	JUMP.S  2542 <mulsf_23>;

00002412 <mulsf_4>:
    2412:	0e 54       	R0=R6&R1;
    2414:	21 e1 ff 00 	R1=255 (X);
    2418:	b9 4f       	R1<<=0x17;
    241a:	08 08       	CC=R0==R1;
    241c:	0c 10       	IF!CCJUMP  2434 <mulsf_11>;
    241e:	16 54       	R0=R6&R2;
    2420:	00 0c       	CC=R0==0;
    2422:	09 18       	IFCCJUMP  2434 <mulsf_11>;
    2424:	06 30       	R0=R6;
    2426:	f8 4c       	BITCLR (R0,0x1f);
    2428:	02 e1 ff ff 	R2.L=-1;
    242c:	42 e1 ff 7f 	R2.H=32767;
    2430:	10 08       	CC=R0==R2;
    2432:	2f 10       	IF!CCJUMP  2490 <mulsf_14>;

00002434 <mulsf_11>:
    2434:	05 30       	R0=R5;
    2436:	f8 4c       	BITCLR (R0,0x1f);
    2438:	01 e1 ff ff 	R1.L=-1;
    243c:	41 e1 ff 7f 	R1.H=32767;
    2440:	08 08       	CC=R0==R1;
    2442:	07 10       	IF!CCJUMP  2450 <mulsf_12>;
    2444:	06 30       	R0=R6;
    2446:	f8 4c       	BITCLR (R0,0x1f);
    2448:	08 08       	CC=R0==R1;
    244a:	03 10       	IF!CCJUMP  2450 <mulsf_12>;
    244c:	06 30       	R0=R6;
    244e:	
OFFSET = 123 
7b 20       	JUMP.S  2544 <mulsf_22>;

00002450 <mulsf_12>:
    2450:	b5 4a       	BITSET (R5,0x16);
    2452:	
OFFSET = 120 
78 20       	JUMP.S  2542 <mulsf_23>;

00002454 <mulsf_3>:
    2454:	0e 54       	R0=R6&R1;
    2456:	22 e1 ff 00 	R2=255 (X);
    245a:	ba 4f       	R2<<=0x17;
    245c:	10 08       	CC=R0==R2;
    245e:	1c 10       	IF!CCJUMP  2496 <mulsf_13>;
    2460:	00 e1 ff ff 	R0.L=-1;
    2464:	40 e1 7f 00 	R0.H=127;
    2468:	06 54       	R0=R6&R0;
    246a:	00 0c       	CC=R0==0;
    246c:	12 10       	IF!CCJUMP  2490 <mulsf_14>;
    246e:	05 0c       	CC=R5==0;
    2470:	05 18       	IFCCJUMP  247a <mulsf_16>;
    2472:	f8 63       	R0=-1(x);
    2474:	f8 4f       	R0<<=0x1f;
    2476:	05 08       	CC=R5==R0;
    2478:	06 10       	IF!CCJUMP  2484 <mulsf_15>;

0000247a <mulsf_16>:
    247a:	00 e1 ff ff 	R0.L=-1;
    247e:	00 e1 ff 7f 	R0.L=32767;
    2482:	
OFFSET = 97 
61 20       	JUMP.S  2544 <mulsf_22>;

00002484 <mulsf_15>:
    2484:	05 30       	R0=R5;
    2486:	f8 4d       	R0>>>=0x1f;
    2488:	f8 4f       	R0<<=0x1f;
    248a:	86 59       	R6=R6^R0;
    248c:	06 30       	R0=R6;
    248e:	
OFFSET = 91 
5b 20       	JUMP.S  2544 <mulsf_22>;

00002490 <mulsf_14>:
    2490:	b6 4a       	BITSET (R6,0x16);
    2492:	06 30       	R0=R6;
    2494:	
OFFSET = 88 
58 20       	JUMP.S  2544 <mulsf_22>;

00002496 <mulsf_13>:
    2496:	05 0c       	CC=R5==0;
    2498:	09 18       	IFCCJUMP  24aa <mulsf_18>;
    249a:	f9 63       	R1=-1(x);
    249c:	f9 4f       	R1<<=0x1f;
    249e:	0d 08       	CC=R5==R1;
    24a0:	05 18       	IFCCJUMP  24aa <mulsf_18>;
    24a2:	06 0c       	CC=R6==0;
    24a4:	03 18       	IFCCJUMP  24aa <mulsf_18>;
    24a6:	0e 08       	CC=R6==R1;
    24a8:	10 10       	IF!CCJUMP  24c8 <mulsf_17>;

000024aa <mulsf_18>:
    24aa:	0d 30       	R1=R5;
    24ac:	f9 4d       	R1>>>=0x1f;
    24ae:	f9 4f       	R1<<=0x1f;
    24b0:	06 30       	R0=R6;
    24b2:	f8 4d       	R0>>>=0x1f;
    24b4:	f8 4f       	R0<<=0x1f;
    24b6:	01 08       	CC=R1==R0;
    24b8:	80 e1 00 00 	R0=0 <_start>(Z);
    24bc:	44 18       	IFCCJUMP  2544 <mulsf_22>;
    24be:	00 e1 00 00 	R0.L=0;
    24c2:	40 e1 00 80 	R0.H=-32768;
    24c6:	
OFFSET = 63 
3f 20       	JUMP.S  2544 <mulsf_22>;

000024c8 <mulsf_17>:
    24c8:	0d 30       	R1=R5;
    24ca:	f9 4d       	R1>>>=0x1f;
    24cc:	f9 4f       	R1<<=0x1f;
    24ce:	06 30       	R0=R6;
    24d0:	f8 4d       	R0>>>=0x1f;
    24d2:	f8 4f       	R0<<=0x1f;
    24d4:	41 58       	R1=R1^R0;
    24d6:	f1 bb       	[FP--4]=R1;
    24d8:	05 30       	R0=R5;
    24da:	b8 4d       	R0>>>=0x17;
    24dc:	22 e1 ff 00 	R2=255 (X);
    24e0:	10 55       	R4=R0&R2;
    24e2:	20 e1 82 ff 	R0=-126 (X);
    24e6:	04 51       	R4=R4+R0;
    24e8:	06 30       	R0=R6;
    24ea:	b8 4d       	R0>>>=0x17;
    24ec:	10 54       	R0=R0&R2;
    24ee:	04 51       	R4=R4+R0;
    24f0:	00 e1 ff ff 	R0.L=-1;
    24f4:	40 e1 7f 00 	R0.H=127;
    24f8:	45 55       	R5=R5&R0;
    24fa:	bd 4a       	BITSET (R5,0x17);
    24fc:	86 55       	R6=R6&R0;
    24fe:	be 4a       	BITSET (R6,0x17);
    2500:	1d 30       	R3=R5;
    2502:	43 4d       	R3>>>=0x8;
    2504:	0e 30       	R1=R6;
    2506:	41 4d       	R1>>>=0x8;
    2508:	3b 30       	R7=R3;
    250a:	cf 40       	R7*=R1;
    250c:	15 54       	R0=R5&R2;
    250e:	c8 40       	R0*=R1;
    2510:	40 4d       	R0>>>=0x8;
    2512:	c7 51       	R7=R7+R0;
    2514:	96 54       	R2=R6&R2;
    2516:	da 40       	R2*=R3;
    2518:	42 4d       	R2>>>=0x8;
    251a:	d7 51       	R7=R7+R2;
    251c:	07 30       	R0=R7;
    251e:	f8 4d       	R0>>>=0x1f;
    2520:	00 48       	CC = ! BITTST (R0,0x0);
    2522:	06 18       	IFCCJUMP  252e <mulsf_20>;
    2524:	21 e1 80 00 	R1=128 (X);
    2528:	cf 51       	R7=R7+R1;
    252a:	47 4e       	R7>>=0x8;
    252c:	
OFFSET = 6 
06 20       	JUMP.S  2538 <mulsf_21>;

0000252e <mulsf_20>:
    252e:	22 e1 40 00 	R2=64 (X);
    2532:	d7 51       	R7=R7+R2;
    2534:	3f 4e       	R7>>=0x7;
    2536:	fc 67       	R4+=-1;

00002538 <mulsf_21>:
    2538:	bf 4c       	BITCLR (R7,0x17);
    253a:	bc 4f       	R4<<=0x17;
    253c:	f1 b9       	R1=[FP--4];
    253e:	21 56       	R0=R1|R4;
    2540:	78 57       	R5=R0|R7;

00002542 <mulsf_23>:
    2542:	05 30       	R0=R5;

00002544 <mulsf_22>:
    2544:	20 05       	( R7:4) = [SP++];
    2546:	01 e8 00 00 	UNLINK;
    254a:	10 00       	RTS;

0000254c <___extendsfdf2>:
    254c:	70 05       	[--SP] = ( R7:6);
    254e:	08 30       	R1=R0;
    2550:	01 0c       	CC=R1==0;
    2552:	1a 18       	IFCCJUMP  2586 <___extendsfdf2+0x3a>;
    2554:	01 30       	R0=R1;
    2556:	f8 4d       	R0>>>=0x1f;
    2558:	30 30       	R6=R0;
    255a:	fe 4f       	R6<<=0x1f;
    255c:	01 30       	R0=R1;
    255e:	b8 4d       	R0>>>=0x17;
    2560:	40 43       	R0=R0.B(Z);
    2562:	22 e1 80 03 	R2=896 (X);
    2566:	82 50       	R2=R2+R0;
    2568:	02 30       	R0=R2;
    256a:	a0 4f       	R0<<=0x14;
    256c:	86 57       	R6=R6|R0;
    256e:	03 e1 ff ff 	R3.L=-1;
    2572:	43 e1 7f 00 	R3.H=127;
    2576:	d9 54       	R3=R1&R3;
    2578:	13 30       	R2=R3;
    257a:	1a 4e       	R2>>=0x3;
    257c:	b2 56       	R2=R2|R6;
    257e:	eb 4f       	R3<<=0x1d;
    2580:	0a 30       	R1=R2;
    2582:	03 30       	R0=R3;
    2584:	
OFFSET = 3 
03 20       	JUMP.S  258a <___extendsfdf2+0x3e>;
    2586:	00 60       	R0=0(x);
    2588:	01 60       	R1=0(x);
    258a:	30 05       	( R7:6) = [SP++];
    258c:	10 00       	RTS;
	...

00002590 <___gesf2>:
    2590:	00 e8 00 00 	LINK0x0;
    2594:	78 05       	[--SP] = ( R7:7);
    2596:	10 32       	P2=R0;
    2598:	52 30       	R2=P2;
    259a:	19 30       	R3=R1;
    259c:	20 e1 ff 00 	R0=255 (X);
    25a0:	b8 4f       	R0<<=0x17;
    25a2:	02 54       	R0=R2&R0;
    25a4:	27 e1 ff 00 	R7=255 (X);
    25a8:	bf 4f       	R7<<=0x17;
    25aa:	38 08       	CC=R0==R7;
    25ac:	09 10       	IF!CCJUMP  25be <gesf_3>;
    25ae:	00 e1 ff ff 	R0.L=-1;
    25b2:	40 e1 7f 00 	R0.H=127;
    25b6:	02 54       	R0=R2&R0;
    25b8:	00 0d       	CC=R0<=0;
    25ba:	f0 63       	R0=-2(x);
    25bc:	16 10       	IF!CCJUMP  25e8 <gesf_5>;

000025be <gesf_3>:
    25be:	20 e1 ff 00 	R0=255 (X);
    25c2:	b8 4f       	R0<<=0x17;
    25c4:	03 54       	R0=R3&R0;
    25c6:	22 e1 ff 00 	R2=255 (X);
    25ca:	ba 4f       	R2<<=0x17;
    25cc:	10 08       	CC=R0==R2;
    25ce:	0a 10       	IF!CCJUMP  25e2 <gesf_4>;
    25d0:	00 e1 ff ff 	R0.L=-1;
    25d4:	40 e1 7f 00 	R0.H=127;
    25d8:	03 54       	R0=R3&R0;
    25da:	00 0d       	CC=R0<=0;
    25dc:	03 18       	IFCCJUMP  25e2 <gesf_4>;
    25de:	f0 63       	R0=-2(x);
    25e0:	
OFFSET = 4 
04 20       	JUMP.S  25e8 <gesf_5>;

000025e2 <gesf_4>:
    25e2:	42 30       	R0=P2;
    25e4:	00 e3 98 02 	CALL  2b14 <___cmpsf2>;

000025e8 <gesf_5>:
    25e8:	38 05       	( R7:7) = [SP++];
    25ea:	01 e8 00 00 	UNLINK;
    25ee:	10 00       	RTS;

000025f0 <___divsf3>:
    25f0:	68 05       	[--SP] = ( R7:5);
    25f2:	30 30       	R6=R0;
    25f4:	19 30       	R3=R1;
    25f6:	21 e1 ff 00 	R1=255 (X);
    25fa:	b9 4f       	R1<<=0x17;
    25fc:	0e 54       	R0=R6&R1;
    25fe:	08 08       	CC=R0==R1;
    2600:	35 10       	IF!CCJUMP  266a <divsf_3>;
    2602:	02 e1 ff ff 	R2.L=-1;
    2606:	42 e1 7f 00 	R2.H=127;
    260a:	16 54       	R0=R6&R2;
    260c:	00 0c       	CC=R0==0;
    260e:	0d 10       	IF!CCJUMP  2628 <divsf_4>;
    2610:	0b 54       	R0=R3&R1;
    2612:	08 08       	CC=R0==R1;
    2614:	05 10       	IF!CCJUMP  261e <divsf_5>;
    2616:	13 54       	R0=R3&R2;
    2618:	00 0c       	CC=R0==0;
    261a:	72 18       	IFCCJUMP  26fe <divsf_25>;
    261c:	
OFFSET = 52 
34 20       	JUMP.S  2684 <divsf_35>;

0000261e <divsf_5>:
    261e:	03 30       	R0=R3;
    2620:	f8 4d       	R0>>>=0x1f;
    2622:	f8 4f       	R0<<=0x1f;
    2624:	86 59       	R6=R6^R0;
    2626:	
OFFSET = 172 
ac 20       	JUMP.S  277e <divsf_36>;

00002628 <divsf_4>:
    2628:	0b 54       	R0=R3&R1;
    262a:	21 e1 ff 00 	R1=255 (X);
    262e:	b9 4f       	R1<<=0x17;
    2630:	08 08       	CC=R0==R1;
    2632:	0c 10       	IF!CCJUMP  264a <divsf_9>;
    2634:	13 54       	R0=R3&R2;
    2636:	00 0c       	CC=R0==0;
    2638:	09 18       	IFCCJUMP  264a <divsf_9>;
    263a:	03 30       	R0=R3;
    263c:	f8 4c       	BITCLR (R0,0x1f);
    263e:	02 e1 ff ff 	R2.L=-1;
    2642:	42 e1 ff 7f 	R2.H=32767;
    2646:	10 08       	CC=R0==R2;
    2648:	1e 10       	IF!CCJUMP  2684 <divsf_35>;

0000264a <divsf_9>:
    264a:	06 30       	R0=R6;
    264c:	f8 4c       	BITCLR (R0,0x1f);
    264e:	01 e1 ff ff 	R1.L=-1;
    2652:	41 e1 ff 7f 	R1.H=32767;
    2656:	08 08       	CC=R0==R1;
    2658:	07 10       	IF!CCJUMP  2666 <divsf_10>;
    265a:	03 30       	R0=R3;
    265c:	f8 4c       	BITCLR (R0,0x1f);
    265e:	08 08       	CC=R0==R1;
    2660:	03 10       	IF!CCJUMP  2666 <divsf_10>;
    2662:	03 30       	R0=R3;
    2664:	
OFFSET = 142 
8e 20       	JUMP.S  2780 <divsf_34>;

00002666 <divsf_10>:
    2666:	b6 4a       	BITSET (R6,0x16);
    2668:	
OFFSET = 139 
8b 20       	JUMP.S  277e <divsf_36>;

0000266a <divsf_3>:
    266a:	0b 54       	R0=R3&R1;
    266c:	22 e1 ff 00 	R2=255 (X);
    2670:	ba 4f       	R2<<=0x17;
    2672:	10 08       	CC=R0==R2;
    2674:	1a 10       	IF!CCJUMP  26a8 <divsf_11>;
    2676:	00 e1 ff ff 	R0.L=-1;
    267a:	40 e1 7f 00 	R0.H=127;
    267e:	03 54       	R0=R3&R0;
    2680:	00 0c       	CC=R0==0;
    2682:	04 18       	IFCCJUMP  268a <divsf_12>;

00002684 <divsf_35>:
    2684:	b3 4a       	BITSET (R3,0x16);
    2686:	03 30       	R0=R3;
    2688:	
OFFSET = 124 
7c 20       	JUMP.S  2780 <divsf_34>;

0000268a <divsf_12>:
    268a:	0b 30       	R1=R3;
    268c:	f9 4d       	R1>>>=0x1f;
    268e:	f9 4f       	R1<<=0x1f;
    2690:	06 30       	R0=R6;

00002692 <divsf_37>:
    2692:	f8 4d       	R0>>>=0x1f;
    2694:	f8 4f       	R0<<=0x1f;
    2696:	01 08       	CC=R1==R0;
    2698:	00 e1 00 00 	R0.L=0;
    269c:	40 e1 00 80 	R0.H=-32768;
    26a0:	70 10       	IF!CCJUMP  2780 <divsf_34>;
    26a2:	80 e1 00 00 	R0=0 <_start>(Z);
    26a6:	
OFFSET = 109 
6d 20       	JUMP.S  2780 <divsf_34>;

000026a8 <divsf_11>:
    26a8:	03 0c       	CC=R3==0;
    26aa:	05 18       	IFCCJUMP  26b4 <divsf_17>;
    26ac:	f8 63       	R0=-1(x);
    26ae:	f8 4f       	R0<<=0x1f;
    26b0:	03 08       	CC=R3==R0;
    26b2:	1a 10       	IF!CCJUMP  26e6 <divsf_16>;

000026b4 <divsf_17>:
    26b4:	06 0c       	CC=R6==0;
    26b6:	18 18       	IFCCJUMP  26e6 <divsf_16>;
    26b8:	f9 63       	R1=-1(x);
    26ba:	f9 4f       	R1<<=0x1f;
    26bc:	0e 08       	CC=R6==R1;
    26be:	14 18       	IFCCJUMP  26e6 <divsf_16>;
    26c0:	06 0c       	CC=R6==0;
    26c2:	1e 18       	IFCCJUMP  26fe <divsf_25>;
    26c4:	0e 30       	R1=R6;
    26c6:	f9 4d       	R1>>>=0x1f;
    26c8:	f9 4f       	R1<<=0x1f;
    26ca:	03 30       	R0=R3;
    26cc:	f8 4d       	R0>>>=0x1f;
    26ce:	f8 4f       	R0<<=0x1f;
    26d0:	01 08       	CC=R1==R0;
    26d2:	00 e1 00 00 	R0.L=0;
    26d6:	40 e1 80 ff 	R0.H=-128;
    26da:	53 10       	IF!CCJUMP  2780 <divsf_34>;
    26dc:	00 e1 00 00 	R0.L=0;
    26e0:	40 e1 80 7f 	R0.H=32640;
    26e4:	
OFFSET = 78 
4e 20       	JUMP.S  2780 <divsf_34>;

000026e6 <divsf_16>:
    26e6:	06 0c       	CC=R6==0;
    26e8:	05 18       	IFCCJUMP  26f2 <divsf_23>;
    26ea:	fa 63       	R2=-1(x);
    26ec:	fa 4f       	R2<<=0x1f;
    26ee:	16 08       	CC=R6==R2;
    26f0:	11 10       	IF!CCJUMP  2712 <divsf_22>;

000026f2 <divsf_23>:
    26f2:	03 0c       	CC=R3==0;
    26f4:	05 18       	IFCCJUMP  26fe <divsf_25>;
    26f6:	f8 63       	R0=-1(x);
    26f8:	f8 4f       	R0<<=0x1f;
    26fa:	03 08       	CC=R3==R0;
    26fc:	06 10       	IF!CCJUMP  2708 <divsf_24>;

000026fe <divsf_25>:
    26fe:	00 e1 ff ff 	R0.L=-1;
    2702:	40 e1 ff 7f 	R0.H=32767;
    2706:	
OFFSET = 61 
3d 20       	JUMP.S  2780 <divsf_34>;

00002708 <divsf_24>:
    2708:	0e 30       	R1=R6;
    270a:	f9 4d       	R1>>>=0x1f;
    270c:	f9 4f       	R1<<=0x1f;
    270e:	03 30       	R0=R3;
    2710:	
OFFSET = 4033 
c1 2f       	JUMP.S  2692 <divsf_37>;

00002712 <divsf_22>:
    2712:	0e 30       	R1=R6;
    2714:	b9 4d       	R1>>>=0x17;
    2716:	22 e1 ff 00 	R2=255 (X);
    271a:	51 54       	R1=R1&R2;
    271c:	03 30       	R0=R3;
    271e:	b8 4d       	R0>>>=0x17;
    2720:	10 54       	R0=R0&R2;
    2722:	c1 53       	R7=R1-R0;
    2724:	21 e1 7e 00 	R1=126 (X);
    2728:	cf 51       	R7=R7+R1;
    272a:	0e 30       	R1=R6;
    272c:	f9 4d       	R1>>>=0x1f;
    272e:	f9 4f       	R1<<=0x1f;
    2730:	03 30       	R0=R3;
    2732:	f8 4d       	R0>>>=0x1f;
    2734:	f8 4f       	R0<<=0x1f;
    2736:	41 59       	R5=R1^R0;
    2738:	00 e1 ff ff 	R0.L=-1;
    273c:	40 e1 7f 00 	R0.H=127;
    2740:	86 55       	R6=R6&R0;
    2742:	be 4a       	BITSET (R6,0x17);
    2744:	c3 54       	R3=R3&R0;
    2746:	bb 4a       	BITSET (R3,0x17);
    2748:	9e 08       	CC=R6<R3;
    274a:	05 10       	IF!CCJUMP  2754 <divsf_28>;
    274c:	16 32       	P2=R6;
    274e:	92 5a       	P2=P2<<1;
    2750:	72 30       	R6=P2;
    2752:	ff 67       	R7+=-1;

00002754 <divsf_28>:
    2754:	08 60       	R0=1(x);
    2756:	c0 4f       	R0<<=0x18;
    2758:	02 60       	R2=0(x);
    275a:	0f 30       	R1=R7;
    275c:	09 64       	R1+=1;

0000275e <divsf_31>:
    275e:	9e 08       	CC=R6<R3;
    2760:	03 18       	IFCCJUMP  2766 <divsf_32>;
    2762:	82 56       	R2=R2|R0;
    2764:	9e 53       	R6=R6-R3;

00002766 <divsf_32>:
    2766:	16 32       	P2=R6;
    2768:	92 5a       	P2=P2<<1;
    276a:	72 30       	R6=P2;
    276c:	08 4d       	R0>>>=0x1;
    276e:	00 0c       	CC=R0==0;
    2770:	f7 17       	IF!CCJUMP  275e <divsf_31>(BP);
    2772:	0a 64       	R2+=1;
    2774:	0a 4d       	R2>>>=0x1;
    2776:	ba 4c       	BITCLR (R2,0x17);
    2778:	b9 4f       	R1<<=0x17;
    277a:	0d 56       	R0=R5|R1;
    277c:	90 57       	R6=R0|R2;

0000277e <divsf_36>:
    277e:	06 30       	R0=R6;

00002780 <divsf_34>:
    2780:	28 05       	( R7:5) = [SP++];
    2782:	10 00       	RTS;

00002784 <___addsf3>:
    2784:	60 05       	[--SP] = ( R7:4);
    2786:	30 30       	R6=R0;
    2788:	04 60       	R4=0(x);
    278a:	3e 30       	R7=R6;
    278c:	19 30       	R3=R1;
    278e:	22 e1 ff 00 	R2=255 (X);
    2792:	ba 4f       	R2<<=0x17;
    2794:	17 54       	R0=R7&R2;
    2796:	10 08       	CC=R0==R2;
    2798:	3b 10       	IF!CCJUMP  280e <___addsf3+0x8a>;
    279a:	01 e1 ff ff 	R1.L=-1;
    279e:	41 e1 7f 00 	R1.H=127;
    27a2:	0f 54       	R0=R7&R1;
    27a4:	00 0c       	CC=R0==0;
    27a6:	15 10       	IF!CCJUMP  27d0 <___addsf3+0x4c>;
    27a8:	13 54       	R0=R3&R2;
    27aa:	10 08       	CC=R0==R2;
    27ac:	10 10       	IF!CCJUMP  27cc <___addsf3+0x48>;
    27ae:	0b 54       	R0=R3&R1;
    27b0:	00 0c       	CC=R0==0;
    27b2:	3d 10       	IF!CCJUMP  282c <___addsf3+0xa8>;
    27b4:	0f 30       	R1=R7;
    27b6:	f9 4d       	R1>>>=0x1f;
    27b8:	f9 4f       	R1<<=0x1f;
    27ba:	03 30       	R0=R3;
    27bc:	f8 4d       	R0>>>=0x1f;
    27be:	f8 4f       	R0<<=0x1f;
    27c0:	01 08       	CC=R1==R0;
    27c2:	00 e1 ff ff 	R0.L=-1;
    27c6:	40 e1 ff 7f 	R0.H=32767;
    27ca:	b0 10       	IF!CCJUMP  292a <___addsf3+0x1a6>;
    27cc:	06 30       	R0=R6;
    27ce:	
OFFSET = 174 
ae 20       	JUMP.S  292a <___addsf3+0x1a6>;
    27d0:	13 54       	R0=R3&R2;
    27d2:	22 e1 ff 00 	R2=255 (X);
    27d6:	ba 4f       	R2<<=0x17;
    27d8:	10 08       	CC=R0==R2;
    27da:	0c 10       	IF!CCJUMP  27f2 <___addsf3+0x6e>;
    27dc:	0b 54       	R0=R3&R1;
    27de:	00 0c       	CC=R0==0;
    27e0:	09 18       	IFCCJUMP  27f2 <___addsf3+0x6e>;
    27e2:	03 30       	R0=R3;
    27e4:	f8 4c       	BITCLR (R0,0x1f);
    27e6:	05 e1 ff ff 	R5.L=-1;
    27ea:	45 e1 ff 7f 	R5.H=32767;
    27ee:	28 08       	CC=R0==R5;
    27f0:	1e 10       	IF!CCJUMP  282c <___addsf3+0xa8>;
    27f2:	07 30       	R0=R7;
    27f4:	f8 4c       	BITCLR (R0,0x1f);
    27f6:	01 e1 ff ff 	R1.L=-1;
    27fa:	41 e1 ff 7f 	R1.H=32767;
    27fe:	08 08       	CC=R0==R1;
    2800:	05 10       	IF!CCJUMP  280a <___addsf3+0x86>;
    2802:	03 30       	R0=R3;
    2804:	f8 4c       	BITCLR (R0,0x1f);
    2806:	08 08       	CC=R0==R1;
    2808:	13 18       	IFCCJUMP  282e <___addsf3+0xaa>;
    280a:	b7 4a       	BITSET (R7,0x16);
    280c:	
OFFSET = 142 
8e 20       	JUMP.S  2928 <___addsf3+0x1a4>;
    280e:	13 54       	R0=R3&R2;
    2810:	22 e1 ff 00 	R2=255 (X);
    2814:	ba 4f       	R2<<=0x17;
    2816:	10 08       	CC=R0==R2;
    2818:	0d 10       	IF!CCJUMP  2832 <___addsf3+0xae>;
    281a:	00 e1 ff ff 	R0.L=-1;
    281e:	40 e1 7f 00 	R0.H=127;
    2822:	03 54       	R0=R3&R0;
    2824:	00 0c       	CC=R0==0;
    2826:	03 10       	IF!CCJUMP  282c <___addsf3+0xa8>;
    2828:	01 30       	R0=R1;
    282a:	
OFFSET = 128 
80 20       	JUMP.S  292a <___addsf3+0x1a6>;
    282c:	b3 4a       	BITSET (R3,0x16);
    282e:	03 30       	R0=R3;
    2830:	
OFFSET = 125 
7d 20       	JUMP.S  292a <___addsf3+0x1a6>;
    2832:	07 0c       	CC=R7==0;
    2834:	05 18       	IFCCJUMP  283e <___addsf3+0xba>;
    2836:	fd 63       	R5=-1(x);
    2838:	fd 4f       	R5<<=0x1f;
    283a:	2f 08       	CC=R7==R5;
    283c:	14 10       	IF!CCJUMP  2864 <___addsf3+0xe0>;
    283e:	03 0c       	CC=R3==0;
    2840:	05 18       	IFCCJUMP  284a <___addsf3+0xc6>;
    2842:	f8 63       	R0=-1(x);
    2844:	f8 4f       	R0<<=0x1f;
    2846:	03 08       	CC=R3==R0;
    2848:	0e 10       	IF!CCJUMP  2864 <___addsf3+0xe0>;
    284a:	ff 4d       	R7>>>=0x1f;
    284c:	07 48       	CC = ! BITTST (R7,0x0);
    284e:	80 e1 00 00 	R0=0 <_start>(Z);
    2852:	6c 18       	IFCCJUMP  292a <___addsf3+0x1a6>;
    2854:	fb 4d       	R3>>>=0x1f;
    2856:	03 48       	CC = ! BITTST (R3,0x0);
    2858:	69 18       	IFCCJUMP  292a <___addsf3+0x1a6>;
    285a:	00 e1 00 00 	R0.L=0;
    285e:	40 e1 00 80 	R0.H=-32768;
    2862:	
OFFSET = 100 
64 20       	JUMP.S  292a <___addsf3+0x1a6>;
    2864:	07 0c       	CC=R7==0;
    2866:	e4 1b       	IFCCJUMP  282e <___addsf3+0xaa>;
    2868:	f9 63       	R1=-1(x);
    286a:	f9 4f       	R1<<=0x1f;
    286c:	0f 08       	CC=R7==R1;
    286e:	e0 1b       	IFCCJUMP  282e <___addsf3+0xaa>;
    2870:	03 0c       	CC=R3==0;
    2872:	5b 18       	IFCCJUMP  2928 <___addsf3+0x1a4>;
    2874:	fa 63       	R2=-1(x);
    2876:	fa 4f       	R2<<=0x1f;
    2878:	13 08       	CC=R3==R2;
    287a:	57 18       	IFCCJUMP  2928 <___addsf3+0x1a4>;
    287c:	07 30       	R0=R7;
    287e:	b8 4d       	R0>>>=0x17;
    2880:	21 e1 ff 00 	R1=255 (X);
    2884:	88 55       	R6=R0&R1;
    2886:	03 30       	R0=R3;
    2888:	b8 4d       	R0>>>=0x17;
    288a:	48 55       	R5=R0&R1;
    288c:	05 30       	R0=R5;
    288e:	c8 64       	R0+=25;
    2890:	06 09       	CC=R6<=R0;
    2892:	4b 10       	IF!CCJUMP  2928 <___addsf3+0x1a4>;
    2894:	06 30       	R0=R6;
    2896:	c8 64       	R0+=25;
    2898:	05 09       	CC=R5<=R0;
    289a:	ca 13       	IF!CCJUMP  282e <___addsf3+0xaa>;
    289c:	00 e1 ff ff 	R0.L=-1;
    28a0:	40 e1 7f 00 	R0.H=127;
    28a4:	87 54       	R2=R7&R0;
    28a6:	ba 4a       	BITSET (R2,0x17);
    28a8:	32 4f       	R2<<=0x6;
    28aa:	43 54       	R1=R3&R0;
    28ac:	b9 4a       	BITSET (R1,0x17);
    28ae:	31 4f       	R1<<=0x6;
    28b0:	ff 4d       	R7>>>=0x1f;
    28b2:	90 43       	R0=-R2;
    28b4:	07 48       	CC = ! BITTST (R7,0x0);
    28b6:	10 06       	IF ! CC R2 = R0;
    28b8:	fb 4d       	R3>>>=0x1f;
    28ba:	88 43       	R0=-R1;
    28bc:	03 48       	CC = ! BITTST (R3,0x0);
    28be:	08 06       	IF ! CC R1 = R0;
    28c0:	2e 09       	CC=R6<=R5;
    28c2:	04 18       	IFCCJUMP  28ca <___addsf3+0x146>;
    28c4:	2e 52       	R0=R6-R5;
    28c6:	01 40       	R1>>>=R0;
    28c8:	
OFFSET = 4 
04 20       	JUMP.S  28d0 <___addsf3+0x14c>;
    28ca:	35 52       	R0=R5-R6;
    28cc:	02 40       	R2>>>=R0;
    28ce:	35 30       	R6=R5;
    28d0:	8a 50       	R2=R2+R1;
    28d2:	82 0c       	CC=R2<0;
    28d4:	06 18       	IFCCJUMP  28e0 <___addsf3+0x15c>;
    28d6:	02 0c       	CC=R2==0;
    28d8:	0c 10       	IF!CCJUMP  28f0 <___addsf3+0x16c>;
    28da:	80 e1 00 00 	R0=0 <_start>(Z);
    28de:	
OFFSET = 38 
26 20       	JUMP.S  292a <___addsf3+0x1a6>;
    28e0:	92 43       	R2=-R2;
    28e2:	fc 63       	R4=-1(x);
    28e4:	fc 4f       	R4<<=0x1f;
    28e6:	
OFFSET = 5 
05 20       	JUMP.S  28f0 <___addsf3+0x16c>;
    28e8:	12 32       	P2=R2;
    28ea:	92 5a       	P2=P2<<1;
    28ec:	52 30       	R2=P2;
    28ee:	fe 67       	R6+=-1;
    28f0:	02 30       	R0=R2;
    28f2:	e8 4d       	R0>>>=0x1d;
    28f4:	e8 4f       	R0<<=0x1d;
    28f6:	00 0c       	CC=R0==0;
    28f8:	f8 1f       	IFCCJUMP  28e8 <___addsf3+0x164>(BP);
    28fa:	0b 60       	R3=1(x);
    28fc:	f3 4f       	R3<<=0x1e;
    28fe:	f2 48       	CC = ! BITTST (R2,0x1e);
    2900:	03 18       	IFCCJUMP  2906 <___addsf3+0x182>;
    2902:	0a 4d       	R2>>>=0x1;
    2904:	0e 64       	R6+=1;
    2906:	02 30       	R0=R2;
    2908:	f8 64       	R0+=31;
    290a:	0a 30       	R1=R2;
    290c:	01 65       	R1+=32;
    290e:	32 48       	CC = ! BITTST (R2,0x6);
    2910:	10 07       	IF CC R2 = R0;
    2912:	11 06       	IF ! CC R2 = R1;
    2914:	1a 54       	R0=R2&R3;
    2916:	00 0c       	CC=R0==0;
    2918:	03 18       	IFCCJUMP  291e <___addsf3+0x19a>;
    291a:	0a 4d       	R2>>>=0x1;
    291c:	0e 64       	R6+=1;
    291e:	32 4d       	R2>>>=0x6;
    2920:	ba 4c       	BITCLR (R2,0x17);
    2922:	be 4f       	R6<<=0x17;
    2924:	34 56       	R0=R4|R6;
    2926:	d0 57       	R7=R0|R2;
    2928:	07 30       	R0=R7;
    292a:	20 05       	( R7:4) = [SP++];
    292c:	10 00       	RTS;
	...

00002930 <___fixsfsi>:
    2930:	78 05       	[--SP] = ( R7:7);
    2932:	38 30       	R7=R0;
    2934:	ff 4d       	R7>>>=0x1f;
    2936:	08 30       	R1=R0;
    2938:	b9 4d       	R1>>>=0x17;
    293a:	4b 43       	R3=R1.B(Z);
    293c:	13 30       	R2=R3;
    293e:	21 e1 81 ff 	R1=-127 (X);
    2942:	8a 50       	R2=R2+R1;
    2944:	01 e1 ff ff 	R1.L=-1;
    2948:	41 e1 7f 00 	R1.H=127;
    294c:	48 54       	R1=R0&R1;
    294e:	b9 4a       	BITSET (R1,0x17);
    2950:	20 e1 ff 00 	R0=255 (X);
    2954:	03 08       	CC=R3==R0;
    2956:	0a 10       	IF!CCJUMP  296a <fixsfsi_3>;
    2958:	07 0c       	CC=R7==0;
    295a:	f8 63       	R0=-1(x);
    295c:	f8 4f       	R0<<=0x1f;
    295e:	22 10       	IF!CCJUMP  29a2 <fixsfsi_19>;
    2960:	00 e1 ff ff 	R0.L=-1;
    2964:	40 e1 ff 7f 	R0.H=32767;
    2968:	
OFFSET = 29 
1d 20       	JUMP.S  29a2 <fixsfsi_19>;

0000296a <fixsfsi_3>:
    296a:	03 0c       	CC=R3==0;
    296c:	03 18       	IFCCJUMP  2972 <fixsfsi_11>;
    296e:	82 0c       	CC=R2<0;
    2970:	03 10       	IF!CCJUMP  2976 <fixsfsi_10>;

00002972 <fixsfsi_11>:
    2972:	00 60       	R0=0(x);
    2974:	
OFFSET = 23 
17 20       	JUMP.S  29a2 <fixsfsi_19>;

00002976 <fixsfsi_10>:
    2976:	b8 60       	R0=23(x);
    2978:	02 09       	CC=R2<=R0;
    297a:	05 10       	IF!CCJUMP  2984 <fixsfsi_12>;
    297c:	10 52       	R0=R0-R2;
    297e:	01 40       	R1>>>=R0;
    2980:	88 43       	R0=-R1;
    2982:	
OFFSET = 14 
0e 20       	JUMP.S  299e <fixsfsi_20>;

00002984 <fixsfsi_12>:
    2984:	f8 60       	R0=31(x);
    2986:	02 09       	CC=R2<=R0;
    2988:	05 10       	IF!CCJUMP  2992 <fixsfsi_14>;
    298a:	4a 67       	R2+=-23;
    298c:	91 40       	R1<<=R2;
    298e:	88 43       	R0=-R1;
    2990:	
OFFSET = 7 
07 20       	JUMP.S  299e <fixsfsi_20>;

00002992 <fixsfsi_14>:
    2992:	01 e1 ff ff 	R1.L=-1;
    2996:	41 e1 ff 7f 	R1.H=32767;
    299a:	f8 63       	R0=-1(x);
    299c:	f8 4f       	R0<<=0x1f;

0000299e <fixsfsi_20>:
    299e:	07 0c       	CC=R7==0;
    29a0:	01 07       	IF CC R0 = R1;

000029a2 <fixsfsi_19>:
    29a2:	38 05       	( R7:7) = [SP++];
    29a4:	10 00       	RTS;
	...

000029a8 <___floatsisf>:
    29a8:	70 05       	[--SP] = ( R7:6);
    29aa:	10 30       	R2=R0;
    29ac:	07 60       	R7=0(x);
    29ae:	01 60       	R1=0(x);
    29b0:	02 0c       	CC=R2==0;
    29b2:	04 10       	IF!CCJUMP  29ba <floatsisf_3>;
    29b4:	80 e1 00 00 	R0=0 <_start>(Z);
    29b8:	
OFFSET = 41 
29 20       	JUMP.S  2a0a <floatsisf_11>;

000029ba <floatsisf_3>:
    29ba:	82 0c       	CC=R2<0;
    29bc:	09 10       	IF!CCJUMP  29ce <floatsisf_12>;
    29be:	ff 63       	R7=-1(x);
    29c0:	ff 4f       	R7<<=0x1f;
    29c2:	92 43       	R2=-R2;
    29c4:	
OFFSET = 5 
05 20       	JUMP.S  29ce <floatsisf_12>;

000029c6 <floatsisf_7>:
    29c6:	12 32       	P2=R2;
    29c8:	92 5a       	P2=P2<<1;
    29ca:	52 30       	R2=P2;
    29cc:	09 64       	R1+=1;

000029ce <floatsisf_12>:
    29ce:	02 30       	R0=R2;
    29d0:	f8 4d       	R0>>>=0x1f;
    29d2:	00 48       	CC = ! BITTST (R0,0x0);
    29d4:	f9 1f       	IFCCJUMP  29c6 <floatsisf_7>(BP);
    29d6:	20 e1 9e 00 	R0=158 (X);
    29da:	48 52       	R1=R0-R1;
    29dc:	50 43       	R0=R2.B(Z);
    29de:	42 4d       	R2>>>=0x8;
    29e0:	03 e1 ff ff 	R3.L=-1;
    29e4:	43 e1 7f 00 	R3.H=127;
    29e8:	9a 54       	R2=R2&R3;
    29ea:	26 e1 80 00 	R6=128 (X);
    29ee:	30 0a       	CC=R0<=R6(IU);
    29f0:	06 18       	IFCCJUMP  29fc <floatsisf_9>;
    29f2:	0a 64       	R2+=1;
    29f4:	ba 48       	CC = ! BITTST (R2,0x17);
    29f6:	03 18       	IFCCJUMP  29fc <floatsisf_9>;
    29f8:	9a 54       	R2=R2&R3;
    29fa:	09 64       	R1+=1;

000029fc <floatsisf_9>:
    29fc:	b9 4f       	R1<<=0x17;
    29fe:	20 e1 ff 00 	R0=255 (X);
    2a02:	b8 4f       	R0<<=0x17;
    2a04:	41 54       	R1=R1&R0;
    2a06:	0f 56       	R0=R7|R1;
    2a08:	10 56       	R0=R0|R2;

00002a0a <floatsisf_11>:
    2a0a:	30 05       	( R7:6) = [SP++];
    2a0c:	10 00       	RTS;
	...

00002a10 <___subsf3>:
    2a10:	00 e8 00 00 	LINK0x0;
    2a14:	78 05       	[--SP] = ( R7:7);
    2a16:	10 32       	P2=R0;
    2a18:	5a 30       	R3=P2;
    2a1a:	11 30       	R2=R1;
    2a1c:	21 e1 ff 00 	R1=255 (X);
    2a20:	b9 4f       	R1<<=0x17;
    2a22:	0b 54       	R0=R3&R1;
    2a24:	08 08       	CC=R0==R1;
    2a26:	3e 10       	IF!CCJUMP  2aa2 <subsf_3>;
    2a28:	07 e1 ff ff 	R7.L=-1;
    2a2c:	47 e1 7f 00 	R7.H=127;
    2a30:	3b 54       	R0=R3&R7;
    2a32:	00 0c       	CC=R0==0;
    2a34:	15 10       	IF!CCJUMP  2a5e <subsf_4>;
    2a36:	0a 54       	R0=R2&R1;
    2a38:	08 08       	CC=R0==R1;
    2a3a:	10 10       	IF!CCJUMP  2a5a <subsf_21>;
    2a3c:	3a 54       	R0=R2&R7;
    2a3e:	00 0c       	CC=R0==0;
    2a40:	41 10       	IF!CCJUMP  2ac2 <subsf_14>;
    2a42:	0b 30       	R1=R3;
    2a44:	f9 4d       	R1>>>=0x1f;
    2a46:	f9 4f       	R1<<=0x1f;
    2a48:	02 30       	R0=R2;
    2a4a:	f8 4d       	R0>>>=0x1f;
    2a4c:	f8 4f       	R0<<=0x1f;
    2a4e:	01 08       	CC=R1==R0;
    2a50:	00 e1 ff ff 	R0.L=-1;
    2a54:	40 e1 ff 7f 	R0.H=32767;
    2a58:	5a 18       	IFCCJUMP  2b0c <subsf_20>;

00002a5a <subsf_21>:
    2a5a:	42 30       	R0=P2;
    2a5c:	
OFFSET = 88 
58 20       	JUMP.S  2b0c <subsf_20>;

00002a5e <subsf_4>:
    2a5e:	0a 54       	R0=R2&R1;
    2a60:	21 e1 ff 00 	R1=255 (X);
    2a64:	b9 4f       	R1<<=0x17;
    2a66:	08 08       	CC=R0==R1;
    2a68:	0c 10       	IF!CCJUMP  2a80 <subsf_11>;
    2a6a:	3a 54       	R0=R2&R7;
    2a6c:	00 0c       	CC=R0==0;
    2a6e:	09 18       	IFCCJUMP  2a80 <subsf_11>;
    2a70:	02 30       	R0=R2;
    2a72:	f8 4c       	BITCLR (R0,0x1f);
    2a74:	07 e1 ff ff 	R7.L=-1;
    2a78:	47 e1 ff 7f 	R7.H=32767;
    2a7c:	38 08       	CC=R0==R7;
    2a7e:	22 10       	IF!CCJUMP  2ac2 <subsf_14>;

00002a80 <subsf_11>:
    2a80:	03 30       	R0=R3;
    2a82:	f8 4c       	BITCLR (R0,0x1f);
    2a84:	01 e1 ff ff 	R1.L=-1;
    2a88:	41 e1 ff 7f 	R1.H=32767;
    2a8c:	08 08       	CC=R0==R1;
    2a8e:	07 10       	IF!CCJUMP  2a9c <subsf_12>;
    2a90:	02 30       	R0=R2;
    2a92:	f8 4c       	BITCLR (R0,0x1f);
    2a94:	08 08       	CC=R0==R1;
    2a96:	03 10       	IF!CCJUMP  2a9c <subsf_12>;
    2a98:	02 30       	R0=R2;
    2a9a:	
OFFSET = 57 
39 20       	JUMP.S  2b0c <subsf_20>;

00002a9c <subsf_12>:
    2a9c:	b3 4a       	BITSET (R3,0x16);
    2a9e:	03 30       	R0=R3;
    2aa0:	
OFFSET = 54 
36 20       	JUMP.S  2b0c <subsf_20>;

00002aa2 <subsf_3>:
    2aa2:	0a 54       	R0=R2&R1;
    2aa4:	27 e1 ff 00 	R7=255 (X);
    2aa8:	bf 4f       	R7<<=0x17;
    2aaa:	38 08       	CC=R0==R7;
    2aac:	0e 10       	IF!CCJUMP  2ac8 <subsf_13>;
    2aae:	00 e1 ff ff 	R0.L=-1;
    2ab2:	40 e1 7f 00 	R0.H=127;
    2ab6:	02 54       	R0=R2&R0;
    2ab8:	00 0c       	CC=R0==0;
    2aba:	04 10       	IF!CCJUMP  2ac2 <subsf_14>;
    2abc:	fa 4b       	BITTGL (R2,0x1f);
    2abe:	02 30       	R0=R2;
    2ac0:	
OFFSET = 38 
26 20       	JUMP.S  2b0c <subsf_20>;

00002ac2 <subsf_14>:
    2ac2:	b2 4a       	BITSET (R2,0x16);
    2ac4:	02 30       	R0=R2;
    2ac6:	
OFFSET = 35 
23 20       	JUMP.S  2b0c <subsf_20>;

00002ac8 <subsf_13>:
    2ac8:	03 0c       	CC=R3==0;
    2aca:	05 18       	IFCCJUMP  2ad4 <subsf_16>;
    2acc:	f8 63       	R0=-1(x);
    2ace:	f8 4f       	R0<<=0x1f;
    2ad0:	03 08       	CC=R3==R0;
    2ad2:	18 10       	IF!CCJUMP  2b02 <subsf_15>;

00002ad4 <subsf_16>:
    2ad4:	f9 63       	R1=-1(x);
    2ad6:	f9 4f       	R1<<=0x1f;
    2ad8:	0b 08       	CC=R3==R1;
    2ada:	08 10       	IF!CCJUMP  2aea <subsf_17>;
    2adc:	02 0c       	CC=R2==0;
    2ade:	06 10       	IF!CCJUMP  2aea <subsf_17>;
    2ae0:	00 e1 00 00 	R0.L=0;
    2ae4:	40 e1 00 80 	R0.H=-32768;
    2ae8:	
OFFSET = 18 
12 20       	JUMP.S  2b0c <subsf_20>;

00002aea <subsf_17>:
    2aea:	02 0c       	CC=R2==0;
    2aec:	05 18       	IFCCJUMP  2af6 <subsf_19>;
    2aee:	ff 63       	R7=-1(x);
    2af0:	ff 4f       	R7<<=0x1f;
    2af2:	3a 08       	CC=R2==R7;
    2af4:	04 10       	IF!CCJUMP  2afc <subsf_18>;

00002af6 <subsf_19>:
    2af6:	80 e1 00 00 	R0=0 <_start>(Z);
    2afa:	
OFFSET = 9 
09 20       	JUMP.S  2b0c <subsf_20>;

00002afc <subsf_18>:
    2afc:	02 30       	R0=R2;
    2afe:	00 e3 3d 00 	CALL  2b78 <___negsf2>;

00002b02 <subsf_15>:
    2b02:	fa 4b       	BITTGL (R2,0x1f);
    2b04:	0a 30       	R1=R2;
    2b06:	42 30       	R0=P2;
    2b08:	ff e3 3e fe 	CALL  2784 <___addsf3>;

00002b0c <subsf_20>:
    2b0c:	38 05       	( R7:7) = [SP++];
    2b0e:	01 e8 00 00 	UNLINK;
    2b12:	10 00       	RTS;

00002b14 <___cmpsf2>:
    2b14:	18 30       	R3=R0;
    2b16:	11 30       	R2=R1;
    2b18:	0b 30       	R1=R3;
    2b1a:	f9 4c       	BITCLR (R1,0x1f);
    2b1c:	02 30       	R0=R2;
    2b1e:	f8 4c       	BITCLR (R0,0x1f);
    2b20:	01 08       	CC=R1==R0;
    2b22:	04 10       	IF!CCJUMP  2b2a <cmpsf_3>;
    2b24:	01 0c       	CC=R1==0;
    2b26:	00 60       	R0=0(x);
    2b28:	27 18       	IFCCJUMP  2b76 <cmpsf_11>;

00002b2a <cmpsf_3>:
    2b2a:	f8 63       	R0=-1(x);
    2b2c:	b8 4f       	R0<<=0x17;
    2b2e:	03 08       	CC=R3==R0;
    2b30:	04 10       	IF!CCJUMP  2b38 <cmpsf_4>;
    2b32:	02 08       	CC=R2==R0;
    2b34:	f8 63       	R0=-1(x);
    2b36:	20 10       	IF!CCJUMP  2b76 <cmpsf_11>;

00002b38 <cmpsf_4>:
    2b38:	f8 63       	R0=-1(x);
    2b3a:	b8 4f       	R0<<=0x17;
    2b3c:	03 08       	CC=R3==R0;
    2b3e:	04 18       	IFCCJUMP  2b46 <cmpsf_5>;
    2b40:	02 08       	CC=R2==R0;
    2b42:	08 60       	R0=1(x);
    2b44:	19 18       	IFCCJUMP  2b76 <cmpsf_11>;

00002b46 <cmpsf_5>:
    2b46:	03 30       	R0=R3;
    2b48:	f8 4d       	R0>>>=0x1f;
    2b4a:	00 48       	CC = ! BITTST (R0,0x0);
    2b4c:	0d 18       	IFCCJUMP  2b66 <cmpsf_6>;
    2b4e:	02 30       	R0=R2;
    2b50:	f8 4d       	R0>>>=0x1f;
    2b52:	00 48       	CC = ! BITTST (R0,0x0);
    2b54:	09 18       	IFCCJUMP  2b66 <cmpsf_6>;
    2b56:	fb 4b       	BITTGL (R3,0x1f);
    2b58:	fa 4b       	BITTGL (R2,0x1f);
    2b5a:	93 08       	CC=R3<R2;
    2b5c:	03 10       	IF!CCJUMP  2b62 <cmpsf_7>;
    2b5e:	08 60       	R0=1(x);
    2b60:	
OFFSET = 11 
0b 20       	JUMP.S  2b76 <cmpsf_11>;

00002b62 <cmpsf_7>:
    2b62:	f9 63       	R1=-1(x);
    2b64:	
OFFSET = 4 
04 20       	JUMP.S  2b6c <cmpsf_12>;

00002b66 <cmpsf_6>:
    2b66:	93 08       	CC=R3<R2;
    2b68:	06 18       	IFCCJUMP  2b74 <cmpsf_9>;
    2b6a:	09 60       	R1=1(x);

00002b6c <cmpsf_12>:
    2b6c:	00 60       	R0=0(x);
    2b6e:	13 09       	CC=R3<=R2;
    2b70:	01 06       	IF ! CC R0 = R1;
    2b72:	
OFFSET = 2 
02 20       	JUMP.S  2b76 <cmpsf_11>;

00002b74 <cmpsf_9>:
    2b74:	f8 63       	R0=-1(x);

00002b76 <cmpsf_11>:
    2b76:	10 00       	RTS;

00002b78 <___negsf2>:
    2b78:	f8 4b       	BITTGL (R0,0x1f);
    2b7a:	10 00       	RTS;

00002b7c <_atexit>:
    2b7c:	00 e8 00 00 	LINK0x0;
    2b80:	f3 05       	[--SP] = ( R7:6, P5:3 );
    2b82:	a6 6f       	SP+=-12;
    2b84:	0c e1 50 5f 	P4.L=5f50 <___exit_count>;
    2b88:	4c e1 00 00 	P4.H=0 <_start>;
    2b8c:	0b e1 58 5f 	P3.L=5f58 <___exit_slots>;
    2b90:	4b e1 00 00 	P3.H=0 <_start>;
    2b94:	30 30       	R6=R0;
    2b96:	07 e1 54 5f 	R7.L=24404;
    2b9a:	47 e1 00 00 	R7.H=0;
    2b9e:	00 0c       	CC=R0==0;
    2ba0:	1e 18       	IFCCJUMP  2bdc <_atexit+0x60>;
    2ba2:	58 91       	P0=[P3];
    2ba4:	65 91       	P5=[P4];
    2ba6:	29 e1 f0 00 	P1=240 (X);
    2baa:	80 5c       	P2=P0+(P0<<1);
    2bac:	91 5e       	P2=P1+(P2<<2);
    2bae:	0d 6c       	P5+=1;
    2bb0:	4a 30       	R1=P2;
    2bb2:	e8 08       	CC=P0<P5;
    2bb4:	16 18       	IFCCJUMP  2be0 <_atexit+0x64>;
    2bb6:	17 32       	P2=R7;
    2bb8:	61 91       	P1=[P4];
    2bba:	50 91       	P0=[P2];
    2bbc:	00 e1 14 2c 	R0.L=11284;
    2bc0:	40 e1 00 00 	R0.H=0;
    2bc4:	01 60       	R1=0(x);
    2bc6:	89 5c       	P2=P1+(P1<<1);
    2bc8:	10 5e       	P0=P0+(P2<<2);
    2bca:	0a e1 24 5f 	P2.L=5f24 <___exit_cleanup>;
    2bce:	4a e1 00 00 	P2.H=0 <_start>;
    2bd2:	09 6c       	P1+=1;
    2bd4:	10 93       	[P2]=R0;
    2bd6:	61 93       	[P4]=P1;
    2bd8:	46 b0       	[P0+0x4]=R6;
    2bda:	01 93       	[P0]=R1;
    2bdc:	00 60       	R0=0(x);
    2bde:	
OFFSET = 21 
15 20       	JUMP.S  2c08 <_atexit+0x8c>;
    2be0:	17 32       	P2=R7;
    2be2:	10 91       	R0=[P2];
    2be4:	00 e3 52 00 	CALL  2c88 <_realloc>;
    2be8:	00 32       	P0=R0;
    2bea:	40 0c       	CC=P0==0;
    2bec:	f8 63       	R0=-1(x);
    2bee:	07 18       	IFCCJUMP  2bfc <_atexit+0x80>;
    2bf0:	18 91       	R0=[P3];
    2bf2:	17 32       	P2=R7;
    2bf4:	a0 64       	R0+=20;
    2bf6:	50 93       	[P2]=P0;
    2bf8:	18 93       	[P3]=R0;
    2bfa:	
OFFSET = 4062 
de 2f       	JUMP.S  2bb6 <_atexit+0x3a>;
    2bfc:	0a e1 28 5f 	P2.L=5f28 <__errno>;
    2c00:	4a e1 00 00 	P2.H=0 <_start>;
    2c04:	61 60       	R1=12(x);
    2c06:	11 93       	[P2]=R1;
    2c08:	66 6c       	SP+=12;
    2c0a:	b3 05       	( R7:6, P5:3)  = [SP++];
    2c0c:	01 e8 00 00 	UNLINK;
    2c10:	10 00       	RTS;
	...

00002c14 <___exit_handler>:
    2c14:	00 e8 00 00 	LINK0x0;
    2c18:	fb 05       	[--SP] = ( R7:7, P5:3 );
    2c1a:	a6 6f       	SP+=-12;
    2c1c:	0d e1 50 5f 	P5.L=5f50 <___exit_count>;
    2c20:	4d e1 00 00 	P5.H=0 <_start>;
    2c24:	38 30       	R7=R0;
    2c26:	28 91       	R0=[P5];
    2c28:	65 32       	P4=P5;
    2c2a:	0b e1 54 5f 	P3.L=5f54 <___exit_function_table>;
    2c2e:	4b e1 00 00 	P3.H=0 <_start>;
    2c32:	00 0c       	CC=R0==0;
    2c34:	13 18       	IFCCJUMP  2c5a <___exit_handler+0x46>;
    2c36:	59 91       	P1=[P3];
    2c38:	10 32       	P2=R0;
    2c3a:	fa 6f       	P2+=-1;
    2c3c:	62 93       	[P4]=P2;
    2c3e:	12 5c       	P0=P2+(P2<<1);
    2c40:	81 5e       	P2=P1+(P0<<2);
    2c42:	10 91       	R0=[P2];
    2c44:	00 0c       	CC=R0==0;
    2c46:	17 18       	IFCCJUMP  2c74 <___exit_handler+0x60>;
    2c48:	08 0c       	CC=R0==1;
    2c4a:	0e 18       	IFCCJUMP  2c66 <___exit_handler+0x52>;
    2c4c:	28 91       	R0=[P5];
    2c4e:	0c e1 50 5f 	P4.L=5f50 <___exit_count>;
    2c52:	4c e1 00 00 	P4.H=0 <_start>;
    2c56:	00 0c       	CC=R0==0;
    2c58:	ef 17       	IF!CCJUMP  2c36 <___exit_handler+0x22>(BP);
    2c5a:	18 91       	R0=[P3];
    2c5c:	00 0c       	CC=R0==0;
    2c5e:	10 18       	IFCCJUMP  2c7e <___exit_handler+0x6a>;
    2c60:	00 e3 3a 00 	CALL  2cd4 <_free>;
    2c64:	
OFFSET = 13 
0d 20       	JUMP.S  2c7e <___exit_handler+0x6a>;
    2c66:	51 ac       	P1=[P2+0x4];
    2c68:	07 30       	R0=R7;
    2c6a:	41 0c       	CC=P1==0;
    2c6c:	f0 1b       	IFCCJUMP  2c4c <___exit_handler+0x38>;
    2c6e:	91 a0       	R1=[P2+0x8];
    2c70:	61 00       	CALL  (P1);
    2c72:	
OFFSET = 4077 
ed 2f       	JUMP.S  2c4c <___exit_handler+0x38>;
    2c74:	52 ac       	P2=[P2+0x4];
    2c76:	42 0c       	CC=P2==0;
    2c78:	ea 1b       	IFCCJUMP  2c4c <___exit_handler+0x38>;
    2c7a:	62 00       	CALL  (P2);
    2c7c:	
OFFSET = 4072 
e8 2f       	JUMP.S  2c4c <___exit_handler+0x38>;
    2c7e:	66 6c       	SP+=12;
    2c80:	bb 05       	( R7:7, P5:3)  = [SP++];
    2c82:	01 e8 00 00 	UNLINK;
    2c86:	10 00       	RTS;

00002c88 <_realloc>:
    2c88:	00 e8 00 00 	LINK0x0;
    2c8c:	68 05       	[--SP] = ( R7:5);
    2c8e:	a6 6f       	SP+=-12;
    2c90:	28 30       	R5=R0;
    2c92:	31 30       	R6=R1;
    2c94:	01 30       	R0=R1;
    2c96:	05 0c       	CC=R5==0;
    2c98:	07 18       	IFCCJUMP  2ca6 <_realloc+0x1e>;
    2c9a:	05 30       	R0=R5;
    2c9c:	01 0c       	CC=R1==0;
    2c9e:	07 10       	IF!CCJUMP  2cac <_realloc+0x24>;
    2ca0:	00 e3 1a 00 	CALL  2cd4 <_free>;
    2ca4:	00 60       	R0=0(x);
    2ca6:	00 e3 33 00 	CALL  2d0c <_malloc>;
    2caa:	
OFFSET = 15 
0f 20       	JUMP.S  2cc8 <_realloc+0x40>;
    2cac:	01 30       	R0=R1;
    2cae:	00 e3 2f 00 	CALL  2d0c <_malloc>;
    2cb2:	38 30       	R7=R0;
    2cb4:	16 30       	R2=R6;
    2cb6:	0d 30       	R1=R5;
    2cb8:	00 0c       	CC=R0==0;
    2cba:	06 18       	IFCCJUMP  2cc6 <_realloc+0x3e>;
    2cbc:	ff e3 62 f8 	CALL  1d80 <_memcpy>;
    2cc0:	05 30       	R0=R5;
    2cc2:	00 e3 09 00 	CALL  2cd4 <_free>;
    2cc6:	07 30       	R0=R7;
    2cc8:	66 6c       	SP+=12;
    2cca:	28 05       	( R7:5) = [SP++];
    2ccc:	01 e8 00 00 	UNLINK;
    2cd0:	10 00       	RTS;
	...

00002cd4 <_free>:
    2cd4:	00 e8 00 00 	LINK0x0;
    2cd8:	78 05       	[--SP] = ( R7:7);
    2cda:	a6 6f       	SP+=-12;
    2cdc:	38 30       	R7=R0;
    2cde:	00 0c       	CC=R0==0;
    2ce0:	10 18       	IFCCJUMP  2d00 <_free+0x2c>;
    2ce2:	01 e1 40 2d 	R1.L=11584;
    2ce6:	41 e1 00 00 	R1.H=0;
    2cea:	01 0c       	CC=R1==0;
    2cec:	06 10       	IF!CCJUMP  2cf8 <_free+0x24>;
    2cee:	07 30       	R0=R7;
    2cf0:	01 60       	R1=0(x);
    2cf2:	00 e3 87 00 	CALL  2e00 <_munmap>;
    2cf6:	
OFFSET = 5 
05 20       	JUMP.S  2d00 <_free+0x2c>;
    2cf8:	00 e3 24 00 	CALL  2d40 <___libc_free_aligned>;
    2cfc:	00 0c       	CC=R0==0;
    2cfe:	f8 1b       	IFCCJUMP  2cee <_free+0x1a>;
    2d00:	66 6c       	SP+=12;
    2d02:	38 05       	( R7:7) = [SP++];
    2d04:	01 e8 00 00 	UNLINK;
    2d08:	10 00       	RTS;
	...

00002d0c <_malloc>:
    2d0c:	00 e8 00 00 	LINK0x0;
    2d10:	46 6f       	SP+=-24;
    2d12:	18 30       	R3=R0;
    2d14:	08 30       	R1=R0;
    2d16:	1a 60       	R2=3(x);
    2d18:	00 60       	R0=0(x);
    2d1a:	02 68       	P2=0;
    2d1c:	03 0c       	CC=R3==0;
    2d1e:	0c 18       	IFCCJUMP  2d36 <_malloc+0x2a>;
    2d20:	0b 61       	R3=33(x);
    2d22:	f3 b0       	[SP+0xc]=R3;
    2d24:	fb 63       	R3=-1(x);
    2d26:	72 bd       	[SP+0x14]=P2;
    2d28:	33 b1       	[SP+0x10]=R3;
    2d2a:	00 e3 a5 00 	CALL  2e74 <_mmap>;
    2d2e:	38 0c       	CC=R0==-1;
    2d30:	01 60       	R1=0(x);
    2d32:	90 06       	IF ! CC P2 = R0;
    2d34:	91 07       	IF CC P2 = R1;
    2d36:	42 30       	R0=P2;
    2d38:	c6 6c       	SP+=24;
    2d3a:	01 e8 00 00 	UNLINK;
    2d3e:	10 00       	RTS;

00002d40 <___libc_free_aligned>:
    2d40:	00 e8 00 00 	LINK0x0;
    2d44:	a6 6f       	SP+=-12;
    2d46:	08 30       	R1=R0;
    2d48:	00 60       	R0=0(x);
    2d4a:	01 0c       	CC=R1==0;
    2d4c:	18 18       	IFCCJUMP  2d7c <___libc_free_aligned+0x3c>;
    2d4e:	0a e1 5c 5f 	P2.L=5f5c <__aligned_blocks>;
    2d52:	4a e1 00 00 	P2.H=0 <_start>;
    2d56:	52 91       	P2=[P2];
    2d58:	42 0c       	CC=P2==0;
    2d5a:	07 18       	IFCCJUMP  2d68 <___libc_free_aligned+0x28>;
    2d5c:	50 a0       	R0=[P2+0x4];
    2d5e:	08 08       	CC=R0==R1;
    2d60:	06 18       	IFCCJUMP  2d6c <___libc_free_aligned+0x2c>;
    2d62:	52 91       	P2=[P2];
    2d64:	42 0c       	CC=P2==0;
    2d66:	fb 17       	IF!CCJUMP  2d5c <___libc_free_aligned+0x1c>(BP);
    2d68:	00 60       	R0=0(x);
    2d6a:	
OFFSET = 9 
09 20       	JUMP.S  2d7c <___libc_free_aligned+0x3c>;
    2d6c:	00 60       	R0=0(x);
    2d6e:	91 a0       	R1=[P2+0x8];
    2d70:	50 b0       	[P2+0x4]=R0;
    2d72:	01 30       	R0=R1;
    2d74:	01 60       	R1=0(x);
    2d76:	00 e3 45 00 	CALL  2e00 <_munmap>;
    2d7a:	08 60       	R0=1(x);
    2d7c:	66 6c       	SP+=12;
    2d7e:	01 e8 00 00 	UNLINK;
    2d82:	10 00       	RTS;

00002d84 <_memalign>:
    2d84:	00 e8 00 00 	LINK0x0;
    2d88:	ed 05       	[--SP] = ( R7:5, P5:5 );
    2d8a:	a6 6f       	SP+=-12;
    2d8c:	28 30       	R5=R0;
    2d8e:	29 50       	R0=R1+R5;
    2d90:	f8 67       	R0+=-1;
    2d92:	ff e3 bd ff 	CALL  2d0c <_malloc>;
    2d96:	38 30       	R7=R0;
    2d98:	00 60       	R0=0(x);
    2d9a:	07 0c       	CC=R7==0;
    2d9c:	2d 18       	IFCCJUMP  2df6 <_memalign+0x72>;
    2d9e:	07 30       	R0=R7;
    2da0:	0d 30       	R1=R5;
    2da2:	ff e3 03 f9 	CALL  1fa8 <___umodsi3>;
    2da6:	30 30       	R6=R0;
    2da8:	00 0c       	CC=R0==0;
    2daa:	1c 18       	IFCCJUMP  2de2 <_memalign+0x5e>;
    2dac:	0d e1 5c 5f 	P5.L=5f5c <__aligned_blocks>;
    2db0:	4d e1 00 00 	P5.H=0 <_start>;
    2db4:	6a 91       	P2=[P5];
    2db6:	42 0c       	CC=P2==0;
    2db8:	07 18       	IFCCJUMP  2dc6 <_memalign+0x42>;
    2dba:	50 a0       	R0=[P2+0x4];
    2dbc:	00 0c       	CC=R0==0;
    2dbe:	19 18       	IFCCJUMP  2df0 <_memalign+0x6c>;
    2dc0:	52 91       	P2=[P2];
    2dc2:	42 0c       	CC=P2==0;
    2dc4:	fb 17       	IF!CCJUMP  2dba <_memalign+0x36>(BP);
    2dc6:	60 60       	R0=12(x);
    2dc8:	ff e3 a2 ff 	CALL  2d0c <_malloc>;
    2dcc:	10 32       	P2=R0;
    2dce:	42 0c       	CC=P2==0;
    2dd0:	0b 18       	IFCCJUMP  2de6 <_memalign+0x62>;
    2dd2:	28 91       	R0=[P5];
    2dd4:	10 93       	[P2]=R0;
    2dd6:	6a 93       	[P5]=P2;
    2dd8:	2f 50       	R0=R7+R5;
    2dda:	30 52       	R0=R0-R6;
    2ddc:	97 b0       	[P2+0x8]=R7;
    2dde:	50 b0       	[P2+0x4]=R0;
    2de0:	38 30       	R7=R0;
    2de2:	07 30       	R0=R7;
    2de4:	
OFFSET = 9 
09 20       	JUMP.S  2df6 <_memalign+0x72>;
    2de6:	07 30       	R0=R7;
    2de8:	ff e3 76 ff 	CALL  2cd4 <_free>;
    2dec:	00 60       	R0=0(x);
    2dee:	
OFFSET = 4 
04 20       	JUMP.S  2df6 <_memalign+0x72>;
    2df0:	42 0c       	CC=P2==0;
    2df2:	f3 13       	IF!CCJUMP  2dd8 <_memalign+0x54>;
    2df4:	
OFFSET = 4073 
e9 2f       	JUMP.S  2dc6 <_memalign+0x42>;
    2df6:	66 6c       	SP+=12;
    2df8:	ad 05       	( R7:5, P5:5)  = [SP++];
    2dfa:	01 e8 00 00 	UNLINK;
    2dfe:	10 00       	RTS;

00002e00 <_munmap>:
    2e00:	00 e8 00 00 	LINK0x0;
    2e04:	68 05       	[--SP] = ( R7:5);
    2e06:	08 32       	P1=R0;
    2e08:	11 32       	P2=R1;
    2e0a:	45 01       	[--SP] = R5;
    2e0c:	4a 30       	R1=P2;
    2e0e:	41 30       	R0=P1;
    2e10:	85 e1 5b 00 	R5=5b <_func+0x1b>(Z);
    2e14:	a0 00       	EXCPT  0x0;
    2e16:	10 30       	R2=R0;
    2e18:	35 90       	R5=[SP++];
    2e1a:	21 e1 82 ff 	R1=-126 (X);
    2e1e:	90 43       	R0=-R2;
    2e20:	0a 0a       	CC=R2<=R1(IU);
    2e22:	07 18       	IFCCJUMP  2e30 <_munmap+0x30>;
    2e24:	0a e1 28 5f 	P2.L=5f28 <__errno>;
    2e28:	4a e1 00 00 	P2.H=0 <_start>;
    2e2c:	10 93       	[P2]=R0;
    2e2e:	fa 63       	R2=-1(x);
    2e30:	02 30       	R0=R2;
    2e32:	28 05       	( R7:5) = [SP++];
    2e34:	01 e8 00 00 	UNLINK;
    2e38:	10 00       	RTS;
	...

00002e3c <__mmap>:
    2e3c:	00 e8 00 00 	LINK0x0;
    2e40:	68 05       	[--SP] = ( R7:5);
    2e42:	10 32       	P2=R0;
    2e44:	45 01       	[--SP] = R5;
    2e46:	42 30       	R0=P2;
    2e48:	85 e1 5a 00 	R5=5a <_func+0x1a>(Z);
    2e4c:	a0 00       	EXCPT  0x0;
    2e4e:	08 30       	R1=R0;
    2e50:	35 90       	R5=[SP++];
    2e52:	22 e1 82 ff 	R2=-126 (X);
    2e56:	88 43       	R0=-R1;
    2e58:	11 0a       	CC=R1<=R2(IU);
    2e5a:	07 18       	IFCCJUMP  2e68 <__mmap+0x2c>;
    2e5c:	0a e1 28 5f 	P2.L=5f28 <__errno>;
    2e60:	4a e1 00 00 	P2.H=0 <_start>;
    2e64:	10 93       	[P2]=R0;
    2e66:	f9 63       	R1=-1(x);
    2e68:	01 30       	R0=R1;
    2e6a:	28 05       	( R7:5) = [SP++];
    2e6c:	01 e8 00 00 	UNLINK;
    2e70:	10 00       	RTS;
	...

00002e74 <_mmap>:
    2e74:	00 e8 06 00 	LINK0x18;
    2e78:	a6 6f       	SP+=-12;
    2e7a:	a0 bb       	[FP--24]=R0;
    2e7c:	78 a1       	R0=[FP+0x14];
    2e7e:	d0 bb       	[FP--12]=R0;
    2e80:	b8 a1       	R0=[FP+0x18];
    2e82:	e0 bb       	[FP--8]=R0;
    2e84:	f8 a1       	R0=[FP+0x1c];
    2e86:	f0 bb       	[FP--4]=R0;
    2e88:	47 30       	R0=FP;
    2e8a:	b1 bb       	[FP--20]=R1;
    2e8c:	c2 bb       	[FP--16]=R2;
    2e8e:	40 67       	R0+=-24;
    2e90:	ff e3 d6 ff 	CALL  2e3c <__mmap>;
    2e94:	66 6c       	SP+=12;
    2e96:	01 e8 00 00 	UNLINK;
    2e9a:	