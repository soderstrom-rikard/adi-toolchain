	 .data
foodata:	.word 42
	.text
footext:
	.text
	.global jump
jump:
	jump (P5);
	Jump (pc + p3);
	jUMp (0);
	JumP.l (-16777216);
	jumP.L (0x00fffffe);
	JUMP.s (4094);
	JUMP.L (0X00FF0000);
	jump (footext);

	.text
	.global ccjump
ccjump:
	if cc jump (-1024);
	IF CC JUMP (1022) (BP);
	if !cc jump (0xffffFc00) (Bp);
	if !cc jumP (0x0112);
	if cC JuMp (footext);
	if CC jUmP (footext) (bp);
	if !cc jump (FOOTEXT) (bP);
	if !Cc JUMP (FooText);

	.text
	.global call
call:
	call (P3);
	Call (PC+p2);
	cALL (0xff000000);
	CalL (0x00FFFFFe);
	CAll call_test;


	.text
	.global return
return:
	rts;
	rTi;
	rtX;
	Rtn;
	RTE;

	.text
	
	.text
	.global loop0
loop0:
//  FIXME:
//  flow.d will need to be modified to reflect the actual output once
//  the parser accepts the loop construct.
	loop loop0 lc0;
	Loop_Begin loop0;
	LOOP_END Loop0;
	lOOP LOOP1 Lc0 = P4;
	Loop_Begin Loop1;
	Loop_End loop1;
	LooP Loop2 LC0 = P0;
	LOOP LOOP3 lC0 = P1 >> 1;

	Lsetup (4, 2046) Lc0;
	LSETUP (30, 1024) LC0 = P5;
	LSeTuP (30, 4) lc0 = p0 >> 1;

	
	.text
	.global loop1
loop1:
	loop loop0 lc1;
	lOOP LOOP0 Lc1 = P4;
	LooP Loop0 LC1 = P0;
	LOOP LOOP0 lC1 = P1 >> 1;
	Loop_Begin Loop0;
	LOOP_END Loop0;

	Lsetup (4, 2046) Lc1;
	LSETUP (30, 1024) LC1 = P5;
	LSeTuP (30, 4) lc1 = p0 >> 1;
