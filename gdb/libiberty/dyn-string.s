// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "dyn-string.i";
.text;
.align 2
.global _dyn_string_init;
.type _dyn_string_init, STT_FUNC;
_dyn_string_init:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R6  =R1 ;
	R0  = 1 (X);
	cc =R1 ==0;
	if cc R6  =R0 ; /* movsicc-1b */
	R0  =R6 ;
	call _xmalloc;
	[P5 +8] =R0 ;
	[P5 ] =R6 ;
	R1  = 0 (X);
	[P5 +4] =R1 ;
	P2  =R0 ;
	B [P2 ] =R1 ;
	R0  = 1 (X);
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _dyn_string_new;
.type _dyn_string_new, STT_FUNC;
_dyn_string_new:
	LINK 0;
	[--sp] = ( r7:5 );
	R5  =R0 ;
	R0  = 12 (X);
	call _xmalloc;
	R6  =R0 ;
	R1  =R5 ;
	call _dyn_string_init;
	R0  =R6 ;
	( r7:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _dyn_string_delete;
.type _dyn_string_delete, STT_FUNC;
_dyn_string_delete:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	R0  =[P5 +8];
	call _free;
	R0  =P5 ;
	call _free;
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _dyn_string_release;
.type _dyn_string_release, STT_FUNC;
_dyn_string_release:
	LINK 0;
	[--sp] = ( r7:6 );
	P2  =R0 ;
	R6  =[P2 +8];
	R1  = 0 (X);
	[P2 +8] =R1 ;
	call _free;
	R0  =R6 ;
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _dyn_string_resize;
.type _dyn_string_resize, STT_FUNC;
_dyn_string_resize:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	P2  =[P5 ];
	R1 +=1;
	R0  =P2 ;
	cc =R1 <=R0 ;
	if !cc jump 6; jump.l L$L$13;
L$L$10:
	P2  =P2 +P2 ;
	R0  =P2 ;
	cc =R1 <=R0 ;
	if cc jump 6; jump.l L$L$10;
L$L$13:
	R0  =[P5 ];
	R1  =P2 ;
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$11;
	[P5 ] =P2 ;
	R0  =[P5 +8];
	call _xrealloc;
	[P5 +8] =R0 ;
L$L$11:
	R0  =P5 ;
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _dyn_string_clear;
.type _dyn_string_clear, STT_FUNC;
_dyn_string_clear:
	LINK 0;
	P1  =R0 ;
	P2  =[P1 +8];
	R1  = 0 (X);
	B [P2 ] =R1 ;
	P2  = 0 (X);
	[P1 +4] =P2 ;
	UNLINK;
	rts;


.align 2
.global _dyn_string_copy;
.type _dyn_string_copy, STT_FUNC;
_dyn_string_copy:
	LINK 0;
	[--sp] = ( p5:4 );
	P4  =R0 ;
	P5  =R1 ;
	cc =P4 ==P5 ;
	if cc jump 6; jump.l L$L$16;
	call _abort;
L$L$16:
	R1  =[P5 +4];
	call _dyn_string_resize;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$15;
	R0  =[P4 +8];
	R1  =[P5 +8];
	call _strcpy;
	P5  =[P5 +4];
	[P4 +4] =P5 ;
	R0  = 1 (X);
L$L$15:
	( p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _dyn_string_copy_cstr;
.type _dyn_string_copy_cstr, STT_FUNC;
_dyn_string_copy_cstr:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	P5  =R0 ;
	R5  =R1 ;
	R0  =R1 ;
	call _strlen;
	R6  =R0 ;
	R0  =P5 ;
	R1  =R6 ;
	call _dyn_string_resize;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$18;
	R0  =[P5 +8];
	R1  =R5 ;
	call _strcpy;
	[P5 +4] =R6 ;
	R0  = 1 (X);
L$L$18:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _dyn_string_prepend;
.type _dyn_string_prepend, STT_FUNC;
_dyn_string_prepend:
	LINK 0;
	R2  =R1 ;
	R1  = 0 (X);
	call _dyn_string_insert;
	UNLINK;
	rts;


.align 2
.global _dyn_string_prepend_cstr;
.type _dyn_string_prepend_cstr, STT_FUNC;
_dyn_string_prepend_cstr:
	LINK 0;
	R2  =R1 ;
	R1  = 0 (X);
	call _dyn_string_insert_cstr;
	UNLINK;
	rts;


.align 2
.global _dyn_string_insert;
.type _dyn_string_insert, STT_FUNC;
_dyn_string_insert:
	LINK 0;
	[--sp] = ( r7:6, p5:4 );
	P4  =R0 ;
	R6  =R1 ;
	[FP +16] =R2 ;
	P5  =R2 ;
	cc =P5 ==P4 ;
	if cc jump 6; jump.l L$L$23;
	call _abort;
L$L$23:
	R0  =[P4 +4];
	R1  =[P5 +4];
	R1 =R0 +R1 ;
	R0  =P4 ;
	call _dyn_string_resize;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$22;
	R2  =[P4 +4];
	cc =R2 <R6 ;
	if !cc jump 6; jump.l L$L$31;
L$L$29:
	R1  =[P4 +8];
	R0  =[P5 +4];
	R0 =R2 +R0 ;
	R0 =R1 +R0 ;
	R1 =R1 +R2 ;
	P2  =R1 ;
	R1  = B [P2 ] (X);
	P2  =R0 ;
	B [P2 ] =R1 ;
	R2 +=-1;
	cc =R2 <R6 ;
	if cc jump 6; jump.l L$L$29;
L$L$31:
	R0  =[P4 +8];
	R6 =R6 +R0 ;
	R1  =[P5 +8];
	R2  =[P5 +4];
	R0  =R6 ;
	call _strncpy;
	R0  =[P4 +4];
	P5  =[P5 +4];
	R1  =P5 ;
	R0 =R0 +R1 ;
	[P4 +4] =R0 ;
	R0  = 1 (X);
L$L$22:
	( r7:6, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _dyn_string_insert_cstr;
.type _dyn_string_insert_cstr, STT_FUNC;
_dyn_string_insert_cstr:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	P5  =R0 ;
	R4  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R0  =R2 ;
	call _strlen;
	R5  =R0 ;
	R0  =[P5 +4];
	R1 =R5 +R0 ;
	R0  =P5 ;
	call _dyn_string_resize;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$32;
	R2  =[P5 +4];
	cc =R2 <R4 ;
	if !cc jump 6; jump.l L$L$40;
L$L$38:
	R1  =[P5 +8];
	R0 =R2 +R5 ;
	R0 =R1 +R0 ;
	R1 =R1 +R2 ;
	P2  =R1 ;
	R1  = B [P2 ] (X);
	P2  =R0 ;
	B [P2 ] =R1 ;
	R2 +=-1;
	cc =R2 <R4 ;
	if cc jump 6; jump.l L$L$38;
L$L$40:
	R0  =[P5 +8];
	R0 =R4 +R0 ;
	R2  =R5 ;
	R1  =R6 ;
	call _strncpy;
	R0  =[P5 +4];
	R5 =R5 +R0 ;
	[P5 +4] =R5 ;
	R0  = 1 (X);
L$L$32:
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _dyn_string_insert_char;
.type _dyn_string_insert_char, STT_FUNC;
_dyn_string_insert_char:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	P5  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R0  =[P5 +4];
	R1  = 1 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R0  =P5 ;
	call _dyn_string_resize;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$41;
	R1  =[P5 +4];
	cc =R1 <R5 ;
	if !cc jump 6; jump.l L$L$49;
L$L$47:
	R0  =[P5 +8];
	R0 =R0 +R1 ;
	P2  =R0 ;
	R2  = B [P2 ] (X);
	B [P2 +1] =R2 ;
	R1 +=-1;
	cc =R1 <R5 ;
	if cc jump 6; jump.l L$L$47;
L$L$49:
	R0  =[P5 +8];
	R5 =R0 +R5 ;
	P2  =R5 ;
	B [P2 ] =R6 ;
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  = 1 (X);
L$L$41:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _dyn_string_append;
.type _dyn_string_append, STT_FUNC;
_dyn_string_append:
	LINK 0;
	[--sp] = ( p5:4 );
	P4  =R0 ;
	P5  =R1 ;
	R1  =[P4 +4];
	R0  =[P5 +4];
	R1 =R1 +R0 ;
	R0  =P4 ;
	call _dyn_string_resize;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$50;
	R1  =[P4 +8];
	R0  =[P4 +4];
	R0 =R1 +R0 ;
	R1  =[P5 +8];
	call _strcpy;
	R0  =[P4 +4];
	P5  =[P5 +4];
	R2  =P5 ;
	R0 =R0 +R2 ;
	[P4 +4] =R0 ;
	R0  = 1 (X);
L$L$50:
	( p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _dyn_string_append_cstr;
.type _dyn_string_append_cstr, STT_FUNC;
_dyn_string_append_cstr:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	P5  =R0 ;
	R5  =R1 ;
	R0  =R1 ;
	call _strlen;
	R6  =R0 ;
	R0  =[P5 +4];
	R1 =R6 +R0 ;
	R0  =P5 ;
	call _dyn_string_resize;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$52;
	R1  =[P5 +8];
	R0  =[P5 +4];
	R0 =R1 +R0 ;
	R1  =R5 ;
	call _strcpy;
	R0  =[P5 +4];
	R6 =R6 +R0 ;
	[P5 +4] =R6 ;
	R0  = 1 (X);
L$L$52:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _dyn_string_append_char;
.type _dyn_string_append_char, STT_FUNC;
_dyn_string_append_char:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R6  =R1 ;
	R0  =[P5 +4];
	R1  = 1 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R0  =P5 ;
	call _dyn_string_resize;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$54;
	R1  =[P5 +8];
	R0  =[P5 +4];
	R0 =R1 +R0 ;
	P2  =R0 ;
	B [P2 ] =R6 ;
	R1  =[P5 +8];
	R0  =[P5 +4];
	R0 =R1 +R0 ;
	R1  = 0 (X);
	P2  =R0 ;
	B [P2 +1] =R1 ;
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  = 1 (X);
L$L$54:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _dyn_string_substring;
.type _dyn_string_substring, STT_FUNC;
_dyn_string_substring:
	LINK 0;
	[--sp] = ( r7:5, p5:4 );
	P5  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R1  =[FP +20];
	R5  =R1 -R2 ;
	cc =R2 <=R1 ;
	if cc jump 6; jump.l L$L$58;
	R0  =[P4 +4];
	cc =R2 <=R0 ;
	if cc jump 6; jump.l L$L$58;
	cc =R1 <=R0 ;
	if !cc jump 6; jump.l L$L$57;
L$L$58:
	call _abort;
L$L$57:
	R0  =P5 ;
	R1  =R5 ;
	call _dyn_string_resize;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$56;
	R3  = -1 (X);
	R3 =R3 +R5 ; //immed->Dreg 
	cc =R3 <0;
	if !cc jump 6; jump.l L$L$66;
L$L$64:
	R1  =[P5 +8];
	R1 =R1 +R3 ;
	R2  =[P4 +8];
	R0 =R6 +R3 ;
	R0 =R2 +R0 ;
	P2  =R0 ;
	R0  = B [P2 ] (X);
	P2  =R1 ;
	B [P2 ] =R0 ;
	R3 +=-1;
	cc =R3 <0;
	if cc jump 6; jump.l L$L$64;
L$L$66:
	R0  =[P5 +8];
	R0 =R0 +R5 ;
	R1  = 0 (X);
	P2  =R0 ;
	B [P2 ] =R1 ;
	[P5 +4] =R5 ;
	R0  = 1 (X);
L$L$56:
	( r7:5, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _dyn_string_eq;
.type _dyn_string_eq, STT_FUNC;
_dyn_string_eq:
	LINK 0;
	P2  =R0 ;
	R3  =[P2 +4];
	P1  =R1 ;
	R2  =[P1 +4];
	R0  = 0 (X);
	cc =R3 ==R2 ;
	if cc jump 6; jump.l L$L$67;
	R0  =[P2 +8];
	R1  =[P1 +8];
	call _strcmp;
	cc =R0 ==0;
	R0  =CC ;
L$L$67:
	UNLINK;
	rts;


