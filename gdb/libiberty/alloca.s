// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "alloca.i";
.data;
.align 2
L_addr_$0:.space 4;
.text;
.align 2
.type _find_stack_direction, STT_FUNC;
_find_stack_direction:
	LINK 4;
	P1.L  = L_addr_$0; P1.H  = L_addr_$0;
	R0  =[P1 ];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$2;
	P2  = -1 (X);
	P2 =P2 +FP ; //immed->Preg 
	[P1 ] =P2 ;
	call _find_stack_direction;
	jump.s L$L$1;
L$L$2:
	P1.L  = L_addr_$0; P1.H  = L_addr_$0;
	P1  =[P1 ];
	P2  = -1 (X);
	P2 =P2 +FP ; //immed->Preg 
	cc =P2 <=P1  (iu);
	if !cc jump 6; jump.l L$L$4;
	P2.L  = _stack_dir; P2.H  = _stack_dir;
	R0  = 1 (X);
	jump.s L$L$6;
L$L$4:
	P2.L  = _stack_dir; P2.H  = _stack_dir;
	R0  = -1 (X);
L$L$6:
	[P2 ] =R0 ;
L$L$1:
	UNLINK;
	rts;


.data;
.align 2
_last_alloca_header:.space 4;
.text;
.align 2
.global _C_alloca;
.type _C_alloca, STT_FUNC;
_C_alloca:
	LINK 4;
	[--sp] = ( r7:5, p5:4 );
	R6  =R0 ;
	P5  = -1 (X);
	P5 =P5 +FP ; //immed->Preg 
	P2.L  = _stack_dir; P2.H  = _stack_dir;
	P2  =[P2 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$8;
	call _find_stack_direction;
L$L$8:
	P2.L  = _last_alloca_header; P2.H  = _last_alloca_header;
	R0  =[P2 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$10;
	P4.L  = _stack_dir; P4.H  = _stack_dir;
L$L$17:
	R1  =[P4 ];
	cc =R1 <=0;
	if !cc jump 6; jump.l L$L$15;
	P1  =R0 ;
	R1  =[P1 +4];
	R2  =P5 ;
	cc =R1 <=R2  (iu);
	if cc jump 6; jump.l L$L$14;
L$L$15:
	R1  =[P4 ];
	cc =R1 <0;
	if cc jump 6; jump.l L$L$10;
	P1  =R0 ;
	R1  =[P1 +4];
	R2  =P5 ;
	cc =R1 <R2  (iu);
	if cc jump 6; jump.l L$L$10;
L$L$14:
	P1  =R0 ;
	R5  =[P1 ];
	call _free;
	R0  =R5 ;
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$17;
L$L$10:
	P2.L  = _last_alloca_header; P2.H  = _last_alloca_header;
	[P2 ] =R0 ;
	R0  = 0 (X);
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$7;
	R0  = 8 (X);
	R0 =R0 +R6 ; //immed->Dreg 
	call _xmalloc;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$19;
	call _abort;
L$L$19:
	P2.L  = _last_alloca_header; P2.H  = _last_alloca_header;
	R1  =[P2 ];
	P1  =R0 ;
	[P1 ] =R1 ;
	[P1 +4] =P5 ;
	[P2 ] =R0 ;
	R0 +=8;
L$L$7:
	( r7:5, p5:4 ) = [sp++];
	UNLINK;
	rts;


.global _libiberty_optr;
.data;
.align 2
_libiberty_optr:.space 4;
.global _libiberty_nptr;
.align 2
_libiberty_nptr:.space 4;
.global _libiberty_len;
.align 2
_libiberty_len:.space 4;
.align 2
_stack_dir:.space 4;
