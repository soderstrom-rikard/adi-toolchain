// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "objalloc.i";
.text;
.align 2
.global _objalloc_create;
.type _objalloc_create, STT_FUNC;
_objalloc_create:
	LINK 0;
	[--sp] = ( p5:5 );
	R0  = 12 (X);
	call _malloc;
	P5  =R0 ;
	R0  = 0 (X);
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$1;
	R0  = 4064 (X);
	call _malloc;
	[P5 +8] =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$3;
	R0  =P5 ;
	call _free;
	R0  = 0 (X);
	jump.s L$L$1;
L$L$3:
	P2  =[P5 +8];
	R0  = 0 (X);
	[P2 ] =R0 ;
	[P2 +4] =R0 ;
	P2 +=8;
	[P5 ] =P2 ;
	R0  = 4056 (X);
	[P5 +4] =R0 ;
	R0  =P5 ;
L$L$1:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global __objalloc_alloc;
.type __objalloc_alloc, STT_FUNC;
__objalloc_alloc:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R6  =R1 ;
	R0  = 1 (X);
	cc =R1 ==0;
	if cc R6  =R0 ; /* movsicc-1b */
	R6 +=3;
	R0  = -4 (X);
	R6  =R6 &R0 ;
	R1  =[P5 +4];
	cc =R6 <=R1  (iu);
	if cc jump 6; jump.l L$L$6;
	R0  =[P5 ];
	R0 =R6 +R0 ;
	[P5 ] =R0 ;
	R1  =R1 -R6 ;
	[P5 +4] =R1 ;
	R0  =R0 -R6 ;
	jump.s L$L$4;
L$L$6:
	R0  = 511 (X);
	cc =R6 <=R0  (iu);
	if !cc jump 6; jump.l L$L$7;
	R0  = 8 (X);
	R0 =R0 +R6 ; //immed->Dreg 
	call _malloc;
	P2  =R0 ;
	R0  = 0 (X);
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$4;
	R0  =[P5 +8];
	[P2 ] =R0 ;
	R0  =[P5 ];
	[P2 +4] =R0 ;
	[P5 +8] =P2 ;
	R0  =P2 ;
	R0 +=8;
	jump.s L$L$4;
L$L$7:
	R0  = 4064 (X);
	call _malloc;
	P2  =R0 ;
	R0  = 0 (X);
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$4;
	R0  =[P5 +8];
	[P2 ] =R0 ;
	R0  = 0 (X);
	[P2 +4] =R0 ;
	R0  =P2 ;
	R0 +=8;
	[P5 ] =R0 ;
	R0  = 4056 (X);
	[P5 +4] =R0 ;
	[P5 +8] =P2 ;
	R0  = 1 (X);
	cc =R6 ==0;
	if !cc R1  =R6 ; if cc R1 =R0 ; /* movsicc-1 */
	R1 +=3;
	R0  = -4 (X);
	R1  =R1 &R0 ;
	R2  = 4056 (X);
	cc =R1 <=R2  (iu);
	if cc jump 6; jump.l L$L$12;
	R0  =[P5 ];
	R0 =R1 +R0 ;
	[P5 ] =R0 ;
	R2  =R2 -R1 ;
	[P5 +4] =R2 ;
	R0  =R0 -R1 ;
	jump.s L$L$4;
L$L$12:
	R0  =P5 ;
	call __objalloc_alloc;
L$L$4:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _objalloc_free;
.type _objalloc_free, STT_FUNC;
_objalloc_free:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R0  =[P5 +8];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$20;
L$L$18:
	P2  =R0 ;
	R6  =[P2 ];
	call _free;
	R0  =R6 ;
	cc =R6 ==0;
	if cc jump 6; jump.l L$L$18;
L$L$20:
	R0  =P5 ;
	call _free;
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _objalloc_free_block;
.type _objalloc_free_block, STT_FUNC;
_objalloc_free_block:
	LINK 0;
	[--sp] = ( r7:4, p5:3 );
	P4  =R0 ;
	R6  =R1 ;
	P3  = 0 (X);
	P5  =[P4 +8];
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$60;
L$L$30:
	R0  =[P5 +4];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$26;
	R0  =P5 ;
	cc =R6 <=R0  (iu);
	if !cc jump 6; jump.l L$L$27;
	R1  =P5 ;
	R0  = 4064 (X);
	R0 =R0 +R1 ; //immed->Dreg 
	cc =R6 <R0  (iu);
	if !cc jump 6; jump.l L$L$23;
L$L$27:
	P3  =P5 ;
	jump.s L$L$24;
L$L$26:
	R0  =P5 ;
	R0 +=8;
	cc =R6 ==R0 ;
	if !cc jump 6; jump.l L$L$23;
L$L$24:
	P5  =[P5 ];
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$30;
	jump.s L$L$60;
L$L$23:
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$31;
L$L$60:
	call _abort;
L$L$31:
	R0  =[P5 +4];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$32;
	R4  = 0 (X);
	R0  =[P4 +8];
	R2  =P5 ;
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$55;
L$L$42:
	P2  =R0 ;
	R5  =[P2 ];
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$36;
	R1  = 0 (X);
	R2  =P3 ;
	cc =R2 ==R0 ;
	if cc P3  =R1 ; /* movsicc-1b */
	jump.s L$L$61;
L$L$36:
	P2  =R0 ;
	R1  =[P2 +4];
	cc =R1 <=R6  (iu);
	if !cc jump 6; jump.l L$L$39;
L$L$61:
	call _free;
	jump.s L$L$38;
L$L$39:
	cc =R4 ==0;
	if cc R4  =R0 ; /* movsicc-1b */
L$L$38:
	R0  =R5 ;
	R1  =P5 ;
	cc =R5 ==R1 ;
	if cc jump 6; jump.l L$L$42;
L$L$55:
	cc =R4 ==0;
	if cc R4  =P5 ; /* movsicc-1b */
	[P4 +8] =R4 ;
	[P4 ] =R6 ;
	R2  =P5 ;
	R2  =R2 -R6 ;
	jump.s L$L$62;
L$L$32:
	R5  =[P5 +4];
	P5  =[P5 ];
	R0  =[P4 +8];
	R1  =P5 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$57;
L$L$48:
	P2  =R0 ;
	R6  =[P2 ];
	call _free;
	R0  =R6 ;
	R1  =P5 ;
	cc =R6 ==R1 ;
	if cc jump 6; jump.l L$L$48;
L$L$57:
	[P4 +8] =P5 ;
	R0  =[P5 +4];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$59;
L$L$52:
	P5  =[P5 ];
	R0  =[P5 +4];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$52;
L$L$59:
	[P4 ] =R5 ;
	R2  =P5 ;
	R2  =R2 -R5 ;
L$L$62:
	P5  =R2 ;
	P2  = 4064 (X);
	P2 =P2 +P5 ; //immed->Preg 
	[P4 +4] =P2 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


