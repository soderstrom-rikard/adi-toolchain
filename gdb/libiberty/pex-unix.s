// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "pex-unix.i";
.data;
.align 2
L_last_pipe_input_$0:.space 4;
.text;
.align 2
L$LC$0:
.dw	0x6970;
.dw	0x6570;
.db	0x00;
.align 2
L$LC$1:
.dw	0x6f66;
.dw	0x6b72;
.db	0x00;
.align 2
L$LC$2:
.dw	0x7325;
.dw	0x203a;
.db	0x00;
.align 2
L$LC$3:
.dw	0x6e69;
.dw	0x7473;
.dw	0x6c61;
.dw	0x616c;
.dw	0x6974;
.dw	0x6e6f;
.dw	0x7020;
.dw	0x6f72;
.dw	0x6c62;
.dw	0x6d65;
.dw	0x202c;
.dw	0x6163;
.dw	0x6e6e;
.dw	0x746f;
.dw	0x6520;
.dw	0x6578;
.dw	0x2063;
.dw	0x2560;
.dw	0x2773;
.db	0x00;
.align 2
L$LC$4:
.dw	0x203a;
.dw	0x7325;
.db	0x0a;
.db	0x00;
.align 2
.global _pexecute;
.type _pexecute, STT_FUNC;
_pexecute:
	LINK 28;
	[--sp] = ( r7:4, p5:3 );
	[FP +-12] =R0 ;
	[FP +-16] =R1 ;
	[FP +16] =R2 ;
	[FP +-20] =R2 ;
	P2  =[FP +24];
	[FP +-24] =P2 ;
	P2  =[FP +28];
	[FP +-28] =P2 ;
	R1  =[FP +32];
	R0  = 4 (X);
	R0  =R1 &R0 ;
	R2.L  = _execv; R2.H  = _execv;
	P3.L  = _execvp; P3.H  = _execvp;
	cc =R0 ==0;
	if cc P3  =R2 ; /* movsicc-2a */
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$4;
	P2.L  = L_last_pipe_input_$0; P2.H  = L_last_pipe_input_$0;
	R0  = 0 (X);
	[P2 ] =R0 ;
L$L$4:
	P4.L  = L_last_pipe_input_$0; P4.H  = L_last_pipe_input_$0;
	P4  =[P4 ];
	R0  = 2 (X);
	R1  =R1 &R0 ;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$5;
	R0  =FP ;
	R0 +=-8;
	call _pipe;
	cc =R0 <0;
	if cc jump 6; jump.l L$L$6;
	P2  =[FP +-24];
	R2.L  = L$LC$0; R2.H  = L$LC$0;
	jump.s L$L$25;
L$L$6:
	R4  =[FP +-4];
	P2.L  = L_last_pipe_input_$0; P2.H  = L_last_pipe_input_$0;
	R2  =[FP +-8];
	[P2 ] =R2 ;
	jump.s L$L$7;
L$L$5:
	R4  = 1 (X);
	P2.L  = L_last_pipe_input_$0; P2.H  = L_last_pipe_input_$0;
	R0  = 0 (X);
	[P2 ] =R0 ;
L$L$7:
	P5  = 1 (X);
	R5  = -1 (X);
	R6  = 0 (X);
	cc =R6 <=3;
	if cc jump 6; jump.l L$L$9;
L$L$13:
	call _fork;
	R5  =R0 ;
	cc =R0 <0;
	if cc jump 6; jump.l L$L$9;
	R0  =P5 ;
	call _sleep;
	P5  =P5 +P5 ;
	R6 +=1;
	cc =R6 <=3;
	if !cc jump 6; jump.l L$L$13;
L$L$9:
	cc =R5 ==-1;
	if !cc jump 6; jump.l L$L$15;
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$16;
	jump.s L$L$20;
L$L$15:
	P2  =[FP +-24];
	R2.L  = L$LC$1; R2.H  = L$LC$1;
L$L$25:
	[P2 ] =R2 ;
	P2  =[FP +-28];
	R0  = 0 (X);
	[P2 ] =R0 ;
	R0  = -1 (X);
	jump.s L$L$1;
L$L$16:
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$17;
	R0  = 0 (X);
	call _close;
	R0  =P4 ;
	call _dup;
	R0  =P4 ;
	call _close;
L$L$17:
	cc =R4 ==1;
	if !cc jump 6; jump.l L$L$18;
	R0  = 1 (X);
	call _close;
	R0  =R4 ;
	call _dup;
	R0  =R4 ;
	call _close;
L$L$18:
	P2.L  = L_last_pipe_input_$0; P2.H  = L_last_pipe_input_$0;
	R0  =[P2 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$19;
	call _close;
L$L$19:
	R0  =[FP +-12];
	R1  =[FP +-16];
	call (P3 );
	P5.L  = _stderr; P5.H  = _stderr;
	R2  =[P5 ];
	[SP +12] =R2 ;
	P2.L  = L$LC$2; P2.H  = L$LC$2;
	[SP +16] =P2 ;
	R0  =[FP +-20];
	[SP +20] =R0 ;
	call _fprintf;
	R2  =[P5 ];
	[SP +12] =R2 ;
	P2.L  = L$LC$3; P2.H  = L$LC$3;
	[SP +16] =P2 ;
	R0  =[FP +-12];
	[SP +20] =R0 ;
	call _fprintf;
	call ___errno_location;
	P2  =R0 ;
	R0  =[P2 ];
	call _xstrerror;
	P5  =[P5 ];
	[SP +12] =P5 ;
	R2.L  = L$LC$4; R2.H  = L$LC$4;
	[SP +16] =R2 ;
	[SP +20] =R0 ;
	call _fprintf;
	R0  = -1 (X);
	call _exit;
L$L$20:
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$21;
	R0  =P4 ;
	call _close;
L$L$21:
	cc =R4 ==1;
	if !cc jump 6; jump.l L$L$22;
	R0  =R4 ;
	call _close;
L$L$22:
	R0  =R5 ;
L$L$1:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _pwait;
.type _pwait, STT_FUNC;
_pwait:
	LINK 0;
	[FP +16] =R2 ;
	R2  = 0 (X);
	call _waitpid;
	UNLINK;
	rts;


