// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "make-relative-prefix.i";
.text;
.align 2
.type _save_string, STT_FUNC;
_save_string:
	LINK 0;
	[--sp] = ( r7:4 );
	R4  =R0 ;
	R5  =R1 ;
	R0  = 1 (X);
	R0 =R0 +R1 ; //immed->Dreg 
	call _malloc;
	R6  =R0 ;
	R2  =R5 ;
	R0  =R4 ;
	R1  =R6 ;
	call _bcopy;
	R5 =R6 +R5 ;
	R1  = 0 (X);
	P2  =R5 ;
	B [P2 ] =R1 ;
	R0  =R6 ;
	( r7:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _split_directories, STT_FUNC;
_split_directories:
	LINK 8;
	[--sp] = ( r7:6, p5:3 );
	R6  =R0 ;
	P3  =R1 ;
	P1  = 0 (X);
	P2  =R0 ;
	R0  = B [P2 ++] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$27;
L$L$11:
	R1  = 47 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$3;
	P1 +=1;
	R0  = B [P2 ] (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$3;
L$L$10:
	P2 +=1;
	R0  = B [P2 ] (X);
	R2  = 47 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$10;
L$L$3:
	R0  = B [P2 ++] (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$11;
L$L$27:
	P1  =P1 <<2;
	R0  =P1 ;
	R0 +=8;
	call _malloc;
	P4  =R0 ;
	R0  = 0 (X);
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$2;
	P5  = 0 (X);
	R0  =R6 ;
	P2  =R6 ;
	R6 +=1;
	R1  = B [P2 ++] (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$30;
L$L$22:
	R2  = 47 (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$13;
	P2  =R6 ;
	R1  = B [P2 ] (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$32;
L$L$20:
	R6 +=1;
	P2  =R6 ;
	R1  = B [P2 ] (X);
	R2  = 47 (X);
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$20;
L$L$32:
	R1  =R6 -R0 ;
	call _save_string;
	P2  =P4 +(P5 <<2);
	[P2 ] =R0 ;
	P5 +=1;
	P2  =P4 +(P5 <<2);
	R0  =[P2 +-4];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$33;
	R0  =R6 ;
L$L$13:
	P2  =R6 ;
	R6 +=1;
	R1  = B [P2 ++] (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$22;
L$L$30:
	R6  =R6 -R0 ;
	R1  = -1 (X);
	R1 =R1 +R6 ; //immed->Dreg 
	cc =R1 <=0;
	if !cc jump 6; jump.l L$L$23;
	call _save_string;
	P2  =P4 +(P5 <<2);
	[P2 ] =R0 ;
	P5 +=1;
L$L$23:
	P2  =P4 +(P5 <<2);
	R0  = 0 (X);
	[P2 --] =R0 ;
	P2  =[P2 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$24;
	jump.s L$L$34;
L$L$33:
	R1  = 0 (X);
	[P2 ] =R1 ;
L$L$34:
	R0  =P4 ;
	call _free_split_directories;
	R0  = 0 (X);
	jump.s L$L$2;
L$L$24:
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$25;
	[P3 ] =P5 ;
L$L$25:
	R0  =P4 ;
L$L$2:
	( r7:6, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _free_split_directories, STT_FUNC;
_free_split_directories:
	LINK 0;
	[--sp] = ( p5:4 );
	P4  =R0 ;
	P5  = 0 (X);
	R0  =[P4 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$41;
L$L$39:
	P2  =P4 +(P5 <<2);
	P5 +=1;
	R0  =[P2 ];
	call _free;
	P2  =P4 +(P5 <<2);
	P2  =[P2 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$39;
L$L$41:
	R0  =P4 ;
	call _free;
	( p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$0:
.dw	0x4150;
.dw	0x4854;
.db	0x00;
.align 2
.global _make_relative_prefix;
.type _make_relative_prefix, STT_FUNC;
_make_relative_prefix:
	LINK 32;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	R4  =R1 ;
	[FP +16] =R2 ;
	P4  =R2 ;
	[FP +-16] =SP ;
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$122;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$122;
	cc =P4 ==0;
	if cc jump 6; jump.l L$L$43;
	jump.s L$L$122;
L$L$119:
	P3  =R6 ;
	jump.s L$L$45;
L$L$43:
	R0  =P3 ;
	call _lbasename;
	R1  =P3 ;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$45;
	R0.L  = L$LC$0; R0.H  = L$LC$0;
	call _getenv;
	R5  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$45;
	call _strlen;
	P5  =R0 ;
	P5 +=1;
	R0  = 2 (X);
	cc =P5 <=1 (iu);
	if cc P5  =R0 ; /* movsicc-1b */
	R0  =P3 ;
	call _strlen;
	P0  =R0 ;
	P5 =P5 +P0 ;
	P5 +=4;
	P5  =P5 >>2;
	P5  =P5 <<2;
	R1  =SP ;
	R2  =P5 ;
	R1  =R1 -R2 ;
	SP  =R1 ;
	R6  =SP ;
	R6 +=12;
	P5  =R5 ;
L$L$120:
	P0  =R5 ;
	R0  = B [P0 ] (X);
	R1  = 58 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$52;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$51;
L$L$52:
	R2  =P5 ;
	cc =R5 ==R2 ;
	if cc jump 6; jump.l L$L$53;
	R0  = 46 (X);
	P0  =R6 ;
	B [P0 ] =R0 ;
	R0  = 47 (X);
	B [P0 +1] =R0 ;
	R1  = 0 (X);
	B [P0 +2] =R1 ;
	jump.s L$L$54;
L$L$53:
	R2  =R5 -R2 ;
	[FP +-20] =R2 ;
	R0  =R6 ;
	R1  =P5 ;
	call _strncpy;
	P0  =R5 ;
	R0  = B [P0 +-1] (X);
	R1  = 47 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$55;
	P2  =[FP +-20];
	P0  =R6 ;
	P2 =P0 +P2 ;
	R0  = 47 (X);
	B [P2 ++] =R0 ;
	R1  = 0 (X);
	B [P2 ] =R1 ;
	jump.s L$L$54;
L$L$55:
	R2  =P5 ;
	R2  =R5 -R2 ;
	P5  =R2 ;
	P0  =R6 ;
	P5 =P0 +P5 ;
	R0  = 0 (X);
	B [P5 ] =R0 ;
L$L$54:
	R0  =R6 ;
	R1  =P3 ;
	call _strcat;
	R0  =R6 ;
	R1  = 1 (X);
	call _access;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$119;
	P0  =R5 ;
	R0  = B [P0 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$45;
	P5  =R5 ;
	P5 +=1;
	R5  =P5 ;
	jump.s L$L$120;
L$L$51:
	R5 +=1;
	jump.s L$L$120;
L$L$45:
	R0  =P3 ;
	call _lrealpath;
	R6  =R0 ;
	R0  = 0 (X);
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$42;
	R0  =R6 ;
	R1  =FP ;
	R1 +=-4;
	call _split_directories;
	P3  =R0 ;
	R0  =R4 ;
	R1  =FP ;
	R1 +=-8;
	call _split_directories;
	R4  =R0 ;
	R0  =R6 ;
	call _free;
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$122;
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$122;
	R0  =[FP +-4];
	R0 +=-1;
	[FP +-4] =R0 ;
	P2  =R0 ;
	R0  =[FP +-8];
	R1  =P2 ;
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$64;
	P5  = 0 (X);
	cc =P5 <P2 ;
	if cc jump 6; jump.l L$L$66;
L$L$70:
	P1  =P5 <<2;
	P2 =P1 +P3 ;
	P0  =R4 ;
	P1 =P1 +P0 ;
	R0  =[P2 ];
	R1  =[P1 ];
	call _strcmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$66;
	P5 +=1;
	P2  =[FP +-8];
	cc =P5 <P2 ;
	if !cc jump 6; jump.l L$L$70;
L$L$66:
	R0  =[FP +-4];
	cc =R0 <=0;
	if !cc jump 6; jump.l L$L$123;
	P2  =[FP +-8];
	cc =P5 ==P2 ;
	if !cc jump 6; jump.l L$L$123;
L$L$64:
	R0  =P4 ;
	R1  =FP ;
	R1 +=-12;
	call _split_directories;
	P4  =R0 ;
	cc =P4 ==0;
	if cc jump 6; jump.l L$L$73;
L$L$123:
	R0  =P3 ;
	call _free_split_directories;
	R0  =R4 ;
	jump.s L$L$121;
L$L$73:
	R0  =[FP +-8];
	R6  =[FP +-12];
	R6  =min(R0 ,R6 );
	P5  = 0 (X);
	R0  =P5 ;
	cc =R0 <R6 ;
	if cc jump 6; jump.l L$L$75;
L$L$79:
	P1  =P5 <<2;
	P0  =R4 ;
	P2 =P1 +P0 ;
	P1 =P1 +P4 ;
	R0  =[P2 ];
	R1  =[P1 ];
	call _strcmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$75;
	P5 +=1;
	R0  =P5 ;
	cc =R0 <R6 ;
	if !cc jump 6; jump.l L$L$79;
L$L$75:
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$80;
	R0  =P3 ;
	call _free_split_directories;
	R0  =R4 ;
	call _free_split_directories;
	R0  =P4 ;
L$L$121:
	call _free_split_directories;
L$L$122:
	R0  = 0 (X);
	jump.s L$L$42;
L$L$80:
	R6  = 0 (X);
	R5  = 0 (X);
	P2  =[FP +-4];
	R1  =P2 ;
	cc =R5 <R1 ;
	if cc jump 6; jump.l L$L$110;
L$L$85:
	P0  =R5 ;
	P2  =P3 +(P0 <<2);
	R0  =[P2 ];
	call _strlen;
	R6 =R6 +R0 ;
	R5 +=1;
	P2  =[FP +-4];
	R1  =P2 ;
	cc =R5 <R1 ;
	if !cc jump 6; jump.l L$L$85;
L$L$110:
	P2  =[FP +-8];
	R2  =P2 ;
	R0  =P5 ;
	R2  =R2 -R0 ;
	P2  =R2 ;
	P2  =P2 +(P2 <<1);
	R1  =P2 ;
	R6 =R6 +R1 ;
	R5  =P5 ;
	P2  =[FP +-12];
	R2  =P2 ;
	cc =R0 <R2 ;
	if cc jump 6; jump.l L$L$112;
L$L$90:
	P0  =R5 ;
	P2  =P4 +(P0 <<2);
	R0  =[P2 ];
	call _strlen;
	R6 =R6 +R0 ;
	R5 +=1;
	P2  =[FP +-12];
	R1  =P2 ;
	cc =R5 <R1 ;
	if !cc jump 6; jump.l L$L$90;
L$L$112:
	R6 +=1;
	R0  =R6 ;
	call _malloc;
	R5  =R0 ;
	R0  = 0 (X);
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$42;
	R2  = 0 (X);
	P0  =R5 ;
	B [P0 ] =R2 ;
	R6  = 0 (X);
	P2  =[FP +-4];
	R0  =P2 ;
	cc =R6 <R0 ;
	if cc jump 6; jump.l L$L$114;
L$L$96:
	P0  =R6 ;
	P2  =P3 +(P0 <<2);
	R0  =R5 ;
	R1  =[P2 ];
	call _strcat;
	R6 +=1;
	P2  =[FP +-4];
	R0  =P2 ;
	cc =R6 <R0 ;
	if !cc jump 6; jump.l L$L$96;
L$L$114:
	R0  =R5 ;
	call _strlen;
	R0 =R5 +R0 ;
	P0  =P5 ;
	P1  =[FP +-8];
	cc =P5 <P1 ;
	if cc jump 6; jump.l L$L$116;
L$L$101:
	P2  =R0 ;
	R1  = 46 (X);
	B [P2 ++] =R1 ;
	B [P2 ++] =R1 ;
	R2  = 0 (X);
	B [P2 ] =R2 ;
	R0 +=2;
	R1  = 47 (X);
	P2  =R0 ;
	R0 +=1;
	B [P2 ++] =R1 ;
	P0 +=1;
	cc =P0 <P1 ;
	if !cc jump 6; jump.l L$L$101;
L$L$116:
	R1  = 0 (X);
	P0  =R0 ;
	B [P0 ] =R1 ;
	P2  =[FP +-12];
	cc =P5 <P2 ;
	if cc jump 6; jump.l L$L$118;
L$L$106:
	P2  =P4 +(P5 <<2);
	R0  =R5 ;
	R1  =[P2 ];
	call _strcat;
	P5 +=1;
	P2  =[FP +-12];
	cc =P5 <P2 ;
	if !cc jump 6; jump.l L$L$106;
L$L$118:
	R0  =P3 ;
	call _free_split_directories;
	R0  =R4 ;
	call _free_split_directories;
	R0  =P4 ;
	call _free_split_directories;
	R0  =R5 ;
L$L$42:
	R1  =[FP +-16];
	SP  =R1 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


