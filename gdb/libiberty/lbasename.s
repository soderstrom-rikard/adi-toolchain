// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "lbasename.i";
.text;
.align 2
.global _lbasename;
.type _lbasename, STT_FUNC;
_lbasename:
	LINK 4;
	P1  =R0 ;
	R1  = B [P1 ] (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$9;
L$L$7:
	P2  =P1 ;
	R1  = B [P2 ++] (X);
	R2  = 47 (X);
	cc =R1 ==R2 ;
	if cc R0  =P2 ; /* movsicc-2a */
	P1 +=1;
	R1  = B [P1 ] (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$7;
L$L$9:
	UNLINK;
	rts;


