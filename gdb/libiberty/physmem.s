// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "physmem.i";
.text;
.align 2
.global _physmem_total;
.type _physmem_total, STT_FUNC;
_physmem_total:
	LINK 0;
	[--sp] = ( r7:4, p5:3 );
	R0  = 85 (X);
	call _sysconf;
	call ___floatsidf;
	R4  =R0 ;
	R5  =R1 ;
	R0  = 30 (X);
	call _sysconf;
	call ___floatsidf;
	P4  =R0 ;
	P3  =R1 ;
	[SP +12] =R4 ;
	[SP +16] =R5 ;
	call ___gedf2;
	cc =R0 <0;
	if !cc jump 6; jump.l L$L$2;
	[SP +12] =P4 ;
	[SP +16] =P3 ;
	call ___gedf2;
	cc =R0 <0;
	if !cc jump 6; jump.l L$L$2;
	[SP +12] =R4 ;
	[SP +16] =R5 ;
	call ___muldf3;
	R2  =R0 ;
	R3  =R1 ;
	jump.s L$L$1;
L$L$2:
	R2  = 0 (X);
	R3  = 0 (X);
L$L$1:
	R0  =R2 ;
	R1  =R3 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _physmem_available;
.type _physmem_available, STT_FUNC;
_physmem_available:
	LINK 0;
	[--sp] = ( r7:4, p5:3 );
	R0  = 86 (X);
	call _sysconf;
	call ___floatsidf;
	R4  =R0 ;
	R5  =R1 ;
	R0  = 30 (X);
	call _sysconf;
	call ___floatsidf;
	P4  =R0 ;
	P3  =R1 ;
	[SP +12] =R4 ;
	[SP +16] =R5 ;
	call ___gedf2;
	cc =R0 <0;
	if !cc jump 6; jump.l L$L$6;
	[SP +12] =P4 ;
	[SP +16] =P3 ;
	call ___gedf2;
	cc =R0 <0;
	if !cc jump 6; jump.l L$L$6;
	[SP +12] =R4 ;
	[SP +16] =R5 ;
	jump.s L$L$9;
L$L$6:
	call _physmem_total;
	R3  =R1 ;
	R1  =R0 ;
	[SP +12] =R1 ;
	[SP +16] =R3 ;
L$L$9:
	call ___muldf3;
	R2  =R0 ;
	R3  =R1 ;
	R0  =R2 ;
	R1  =R3 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


