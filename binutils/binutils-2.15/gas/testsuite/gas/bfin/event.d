#objdump: -dr
#name: event
.*: +file format .*

Disassembly of section .text:

00000000 <idle>:
   0:	20 00       	idle;

00000002 <csync>:
   2:	23 00       	csync;

00000004 <ssync>:
   4:	24 00       	ssync;

00000006 <emuexcpt>:
   6:	25 00       	emuexcpt;

00000008 <cli>:
   8:	37 00       	cli r7;
   a:	30 00       	cli r0;

0000000c <sti>:
   c:	41 00       	sti r1;
   e:	42 00       	sti r2;

00000010 <raise>:
  10:	9f 00       	raise 0xf;
  12:	90 00       	raise 0x0;

00000014 <excpt>:
  14:	af 00       	excpt 0xf;
  16:	a0 00       	excpt 0x0;

00000018 <testset>:
  18:	b5 00       	testset p5;
  1a:	b0 00       	testset p0;

0000001c <nop>:
  1c:	00 00       	nop;
  1e:	03 c8 00 18 	mnop || nop || nop;
  22:	00 00 00 00 
	...
