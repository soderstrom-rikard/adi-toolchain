// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "concat.i";
.text;
.align 2
.global _concat_length;
.type _concat_length, STT_FUNC;
_concat_length:
	LINK 4;
	[--sp] = ( r7:6, p5:5 );
	P5  = 24 (X);
	P5 =P5 +FP ; //immed->Preg 
	R6  = 0 (X);
	R0  =[FP +20];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$9;
L$L$6:
	call _strlen;
	R6 =R6 +R0 ;
	R0  =[P5 ++];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$6;
L$L$9:
	R0  =R6 ;
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _concat_copy;
.type _concat_copy, STT_FUNC;
_concat_copy:
	LINK 4;
	[--sp] = ( r7:4, p5:4 );
	R4  =[FP +20];
	P5  = 28 (X);
	P5 =P5 +FP ; //immed->Preg 
	P4  =R4 ;
	R5  =[FP +24];
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$18;
L$L$15:
	R0  =R5 ;
	call _strlen;
	R6  =R0 ;
	R2  =R0 ;
	R0  =R5 ;
	R1  =P4 ;
	call _bcopy;
	P2  =R6 ;
	P4 =P4 +P2 ;
	R5  =[P5 ++];
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$15;
L$L$18:
	R0  = 0 (X);
	B [P4 ] =R0 ;
	R0  =R4 ;
	( r7:4, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _concat_copy2;
.type _concat_copy2, STT_FUNC;
_concat_copy2:
	LINK 4;
	[--sp] = ( r7:5, p5:4 );
	P4.L  = _libiberty_concat_ptr; P4.H  = _libiberty_concat_ptr;
	P5  = 24 (X);
	P5 =P5 +FP ; //immed->Preg 
	P4  =[P4 ];
	R5  =[FP +20];
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$27;
L$L$24:
	R0  =R5 ;
	call _strlen;
	R6  =R0 ;
	R2  =R0 ;
	R0  =R5 ;
	R1  =P4 ;
	call _bcopy;
	P2  =R6 ;
	P4 =P4 +P2 ;
	R5  =[P5 ++];
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$24;
L$L$27:
	R0  = 0 (X);
	B [P4 ] =R0 ;
	P2.L  = _libiberty_concat_ptr; P2.H  = _libiberty_concat_ptr;
	R0  =[P2 ];
	( r7:5, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _concat;
.type _concat, STT_FUNC;
_concat:
	LINK 8;
	[--sp] = ( r7:4, p5:4 );
	R4  =[FP +20];
	P5  = 24 (X);
	P5 =P5 +FP ; //immed->Preg 
	R6  = 0 (X);
	R0  =R4 ;
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$42;
L$L$33:
	call _strlen;
	R6 =R6 +R0 ;
	R0  =[P5 ++];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$33;
L$L$42:
	R0  = 1 (X);
	R0 =R0 +R6 ; //immed->Dreg 
	call _xmalloc;
	R5  =R0 ;
	P4  = 24 (X);
	P4 =P4 +FP ; //immed->Preg 
	P5  =R0 ;
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$44;
L$L$39:
	R0  =R4 ;
	call _strlen;
	R6  =R0 ;
	R2  =R0 ;
	R0  =R4 ;
	R1  =P5 ;
	call _bcopy;
	P2  =R6 ;
	P5 =P5 +P2 ;
	R4  =[P4 ++];
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$39;
L$L$44:
	R0  = 0 (X);
	B [P5 ] =R0 ;
	R0  =R5 ;
	( r7:4, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _reconcat;
.type _reconcat, STT_FUNC;
_reconcat:
	LINK 8;
	[--sp] = ( r7:4, p5:3 );
	R4  =[FP +20];
	R5  =[FP +24];
	P5  = 28 (X);
	P5 =P5 +FP ; //immed->Preg 
	R6  = 0 (X);
	R0  =R5 ;
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$60;
L$L$50:
	call _strlen;
	R6 =R6 +R0 ;
	R0  =[P5 ++];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$50;
L$L$60:
	R0  = 1 (X);
	R0 =R0 +R6 ; //immed->Dreg 
	call _xmalloc;
	P3  =R0 ;
	P5  = 28 (X);
	P5 =P5 +FP ; //immed->Preg 
	P4  =R0 ;
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$62;
L$L$56:
	R0  =R5 ;
	call _strlen;
	R6  =R0 ;
	R2  =R0 ;
	R0  =R5 ;
	R1  =P4 ;
	call _bcopy;
	P2  =R6 ;
	P4 =P4 +P2 ;
	R5  =[P5 ++];
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$56;
L$L$62:
	R0  = 0 (X);
	B [P4 ] =R0 ;
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$58;
	R0  =R4 ;
	call _free;
L$L$58:
	R0  =P3 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.global _libiberty_concat_ptr;
.data;
.align 2
_libiberty_concat_ptr:.space 4;
