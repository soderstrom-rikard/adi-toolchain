// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "spaces.i";
.data;
.align 2
L_buf_$0:.space 4;
.align 2
L_maxsize_$1:.space 4;
.text;
.align 2
.global _spaces;
.type _spaces, STT_FUNC;
_spaces:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	R6  =R0 ;
	P2.L  = L_maxsize_$1; P2.H  = L_maxsize_$1;
	P2  =[P2 ];
	R0  =P2 ;
	cc =R6 <=R0 ;
	if !cc jump 6; jump.l L$L$2;
	P2.L  = L_buf_$0; P2.H  = L_buf_$0;
	R0  =[P2 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$3;
	call _free;
L$L$3:
	P5.L  = L_buf_$0; P5.H  = L_buf_$0;
	R0  = 1 (X);
	R0 =R0 +R6 ; //immed->Dreg 
	call _malloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1;
	P1  =P5 ;
	R0  =R1 ;
	R1 =R6 +R1 ;
	P2  =R1 ;
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$11;
L$L$9:
	P2 +=-1;
	R0  = 32 (X);
	B [P2 ] =R0 ;
	R0  =[P1 ];
	R1  =P2 ;
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$9;
L$L$11:
	P2.L  = L_maxsize_$1; P2.H  = L_maxsize_$1;
	[P2 ] =R6 ;
	P2.L  = L_buf_$0; P2.H  = L_buf_$0;
	P2  =[P2 ];
	P1  =R6 ;
	P2 =P2 +P1 ;
	R0  = 0 (X);
	B [P2 ] =R0 ;
L$L$2:
	P1.L  = L_buf_$0; P1.H  = L_buf_$0;
	P2.L  = L_maxsize_$1; P2.H  = L_maxsize_$1;
	P1  =[P1 ];
	P2  =[P2 ];
	P1 =P1 +P2 ;
	R1  =P1 ;
	R0  =R1 -R6 ;
L$L$1:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


