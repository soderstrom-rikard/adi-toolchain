// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "xstrerror.i";
.text;
.align 2
L$LC$0:
.dw	0x6e75;
.dw	0x6f64;
.dw	0x7563;
.dw	0x656d;
.dw	0x746e;
.dw	0x6465;
.dw	0x6520;
.dw	0x7272;
.dw	0x726f;
.dw	0x2320;
.dw	0x6425;
.db	0x00;
.align 2
.global _xstrerror;
.type _xstrerror, STT_FUNC;
_xstrerror:
	LINK 0;
	[--sp] = ( r7:5 );
	R5  =R0 ;
	call _strerror;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$2;
	R6.L  = _xstrerror_buf; R6.H  = _xstrerror_buf;
	[SP +12] =R6 ;
	R0.L  = L$LC$0; R0.H  = L$LC$0;
	[SP +16] =R0 ;
	[SP +20] =R5 ;
	call _sprintf;
	R0  =R6 ;
L$L$2:
	( r7:5 ) = [sp++];
	UNLINK;
	rts;


.data;
.align 2
_xstrerror_buf:.space 44;
