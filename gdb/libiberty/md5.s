// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "md5.i";
.text;
_fillbuf:	.byte	-128
	.byte	0
	.space	62
.align 2
.global _md5_init_ctx;
.type _md5_init_ctx, STT_FUNC;
_md5_init_ctx:
	LINK 0;
	R1.L  = 8961; R1.H  = 26437;
	P2  =R0 ;
	[P2 ] =R1 ;
	R1.L  = -21623; R1.H  = -4147;
	[P2 +4] =R1 ;
	R1.L  = -8962; R1.H  = -26438;
	[P2 +8] =R1 ;
	R1.L  = 21622; R1.H  = 4146;
	[P2 +12] =R1 ;
	R1  = 0 (X);
	[P2 +20] =R1 ;
	[P2 +16] =R1 ;
	[P2 +24] =R1 ;
	UNLINK;
	rts;


.align 2
.global _md5_read_ctx;
.type _md5_read_ctx, STT_FUNC;
_md5_read_ctx:
	LINK 0;
	P2  =R0 ;
	R0  =R1 ;
	R1  =[P2 ];
	P1  =R0 ;
	[P1 ] =R1 ;
	R1  =[P2 +4];
	[P1 +4] =R1 ;
	R1  =[P2 +8];
	[P1 +8] =R1 ;
	P2  =[P2 +12];
	[P1 +12] =P2 ;
	UNLINK;
	rts;


.align 2
.global _md5_finish_ctx;
.type _md5_finish_ctx, STT_FUNC;
_md5_finish_ctx:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	P5  =R0 ;
	R5  =R1 ;
	R6  =[P5 +24];
	R0  =[P5 +16];
	R0 =R6 +R0 ;
	[P5 +16] =R0 ;
	cc =R0 <R6  (iu);
	if cc jump 6; jump.l L$L$4;
	R0  =[P5 +20];
	R0 +=1;
	[P5 +20] =R0 ;
L$L$4:
	R0  = 55 (X);
	R4  = 120 (X);
	cc =R6 <=R0  (iu);
	if cc jump 6; jump.l L$L$7;
	R4  = 56 (X);
L$L$7:
	R4  =R4 -R6 ;
	R1  =P5 ;
	R0 =R1 +R6 ;
	R1  = 28 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R0.L  = _fillbuf; R0.H  = _fillbuf;
	R2  =R4 ;
	call _bcopy;
	R6 =R6 +R4 ;
	P1  =R6 ;
	P2 =P5 +P1 ;
	R0  =[P5 +16];
	R0  <<=3;
	[P2 +28] =R0 ;
	R1  =[P5 +20];
	R1  <<=3;
	R0  =[P5 +16];
	R0  >>=29;
	R1  =R1 |R0 ;
	[P2 +32] =R1 ;
	R0  =P5 ;
	R0 +=28;
	R1  = 8 (X);
	R1 =R1 +R6 ; //immed->Dreg 
	R2  =P5 ;
	call _md5_process_block;
	R0  =P5 ;
	R1  =R5 ;
	call _md5_read_ctx;
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _md5_stream;
.type _md5_stream, STT_FUNC;
_md5_stream:
	LINK 4324;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	P4  =R1 ;
	R1  =FP ;
	R0  = -156 (X);
	R0 =R0 +R1 ; //immed->Dreg 
	call _md5_init_ctx;
	P5  = -4324 (X);
	P5 =P5 +FP ; //immed->Preg 
	R4  = 4096 (X);
L$L$19:
	R5  = 0 (X);
L$L$12:
	R1  =P5 ;
	R0 =R1 +R5 ;
	R2  =R4 -R5 ;
	[SP +12] =P3 ;
	R1  = 1 (X);
	call _fread;
	R6  =R0 ;
	R5 =R5 +R0 ;
	R1  = 4095 (X);
	cc =R5 <=R1  (iu);
	if cc jump 6; jump.l L$L$13;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$12;
	jump.s L$L$21;
L$L$13:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$18;
L$L$21:
	R0  =P3 ;
	call _ferror;
	R1  = 1 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$8;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$10;
L$L$18:
	R0  =FP ;
	R2  = -156 (X);
	R2 =R2 +R0 ; //immed->Dreg 
	R1  =FP ;
	R0  = -4324 (X);
	R0 =R0 +R1 ; //immed->Dreg 
	R1  = 4096 (X);
	call _md5_process_block;
	jump.s L$L$19;
L$L$10:
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$20;
	R1  =FP ;
	R0  = -4324 (X);
	R0 =R0 +R1 ; //immed->Dreg 
	R2  = -156 (X);
	R2 =R2 +R1 ; //immed->Dreg 
	R1  =R5 ;
	call _md5_process_bytes;
L$L$20:
	R1  =FP ;
	R0  = -156 (X);
	R0 =R0 +R1 ; //immed->Dreg 
	R1  =P4 ;
	call _md5_finish_ctx;
	R1  = 0 (X);
L$L$8:
	R0  =R1 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _md5_buffer;
.type _md5_buffer, STT_FUNC;
_md5_buffer:
	LINK 156;
	[--sp] = ( r7:4, p5:5 );
	R4  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	P5  = -156 (X);
	P5 =P5 +FP ; //immed->Preg 
	R0  =P5 ;
	call _md5_init_ctx;
	R2  =P5 ;
	R0  =R4 ;
	R1  =R5 ;
	call _md5_process_bytes;
	R0  =P5 ;
	R1  =R6 ;
	call _md5_finish_ctx;
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _md5_process_bytes;
.type _md5_process_bytes, STT_FUNC;
_md5_process_bytes:
	LINK 4;
	[--sp] = ( r7:4, p5:3 );
	R4  =R0 ;
	P5  =R1 ;
	[FP +16] =R2 ;
	P4  =R2 ;
	R5  =[P4 +24];
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$24;
	P3  = 128 (X);
	R0  =P3 ;
	R0  =R0 -R5 ;
	P3  =R0 ;
	cc =P3 <=P5  (iu);
	if !cc P3  =R1 ; /* movsicc-2b */
	R0 =R2 +R5 ;
	R1  = 28 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R2  =P3 ;
	R0  =R4 ;
	call _bcopy;
	R0  =[P4 +24];
	R2  =P3 ;
	R0 =R2 +R0 ;
	[P4 +24] =R0 ;
	R5 =R5 +R2 ;
	R0  = 64 (X);
	cc =R5 <=R0  (iu);
	if !cc jump 6; jump.l L$L$26;
	R0  =P4 ;
	R0 +=28;
	[FP +-4] =R0 ;
	R6  = -64 (X);
	R6  =R5 &R6 ;
	R2  =P4 ;
	R1  =R6 ;
	call _md5_process_block;
	R0  = 63 (X);
	R5  =R5 &R0 ;
	R1  =P4 ;
	R6 =R1 +R6 ;
	R0  = 28 (X);
	R0 =R0 +R6 ; //immed->Dreg 
	R2  =R5 ;
	R1  =[FP +-4];
	call _bcopy;
	[P4 +24] =R5 ;
L$L$26:
	R2  =P3 ;
	R4 =R4 +R2 ;
	R0  =P5 ;
	R0  =R0 -R2 ;
	P5  =R0 ;
L$L$24:
	P2  = 64 (X);
	cc =P5 <=P2  (iu);
	if !cc jump 6; jump.l L$L$27;
	R6  = -64 (X);
	R0  =P5 ;
	R6  =R0 &R6 ;
	R2  =P4 ;
	R0  =R4 ;
	R1  =R6 ;
	call _md5_process_block;
	R4 =R4 +R6 ;
	R0  = 63 (X);
	R1  =P5 ;
	R1  =R1 &R0 ;
	P5  =R1 ;
L$L$27:
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$23;
	R1  =P4 ;
	R1 +=28;
	R2  =P5 ;
	R0  =R4 ;
	call _bcopy;
	[P4 +24] =P5 ;
L$L$23:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _md5_process_block;
.type _md5_process_block, STT_FUNC;
_md5_process_block:
	LINK 136;
	[--sp] = ( r7:4, p5:3 );
	P2  =R0 ;
	P5  =R1 ;
	[FP +16] =R2 ;
	P0  =R2 ;
	[FP +-68] =R2 ;
	P1  =P5 >>2;
	P1  =P2 +(P1 <<2);
	[FP +-72] =P1 ;
	R2  =[P0 ];
	R3  =[P0 +4];
	R0  =[P0 +8];
	R5  =[P0 +12];
	P1  =[P0 +16];
	P1 =P5 +P1 ;
	[P0 +16] =P1 ;
	cc =P1 <P5  (iu);
	if cc jump 6; jump.l L$L$30;
	R1  =[P0 +20];
	R1 +=1;
	[P0 +20] =R1 ;
L$L$30:
	P1  =[FP +-72];
	cc =P2 <P1  (iu);
	if cc jump 6; jump.l L$L$100;
L$L$98:
	[FP +-76] =R2 ;
	[FP +-80] =R3 ;
	[FP +-84] =R0 ;
	[FP +-88] =R5 ;
	R1  =R0 ^R5 ;
	R1  =R3 &R1 ;
	R1  =R5 ^R1 ;
	R6  =[P2 ++];
	[FP +-64] =R6 ;
	R6 =R1 +R6 ;
	R2 =R2 +R6 ;
	R1.L  = -23432; R1.H  = -10390;
	R1 =R1 +R2 ; //immed->Dreg 
	R2  =R1 ;
	R6  =R1 ;
	R6  <<=7;
	R2  >>=25;
	R6  =R6 |R2 ;
	R6 =R6 +R3 ;
	R1  =R3 ^R0 ;
	R1  =R6 &R1 ;
	R1  =R0 ^R1 ;
	R2  =[P2 ++];
	[FP +-60] =R2 ;
	R2 =R1 +R2 ;
	R5 =R5 +R2 ;
	R2.L  = -18602; R2.H  = -5945;
	R2 =R2 +R5 ; //immed->Dreg 
	R5  =R2 ;
	R1  =R2 ;
	R1  <<=12;
	R5  >>=20;
	R1  =R1 |R5 ;
	R1 =R1 +R6 ;
	R2  =R6 ^R3 ;
	R2  =R1 &R2 ;
	R2  =R3 ^R2 ;
	R5  =[P2 ++];
	[FP +-56] =R5 ;
	R5 =R2 +R5 ;
	R0 =R0 +R5 ;
	R5.L  = 28891; R5.H  = 9248;
	R5 =R5 +R0 ; //immed->Dreg 
	R0  =R5 ;
	R2  =R5 ;
	R2  <<=17;
	R0  >>=15;
	R2  =R2 |R0 ;
	R2 =R2 +R1 ;
	R0  =R1 ^R6 ;
	R0  =R2 &R0 ;
	R0  =R6 ^R0 ;
	R5  =[P2 ++];
	[FP +-52] =R5 ;
	R5 =R0 +R5 ;
	R3 =R3 +R5 ;
	R0.L  = -12562; R0.H  = -15939;
	R0 =R0 +R3 ; //immed->Dreg 
	R3  =R0 ;
	R5  =R0 ;
	R5  <<=22;
	R3  >>=10;
	R5  =R5 |R3 ;
	R5 =R5 +R2 ;
	R0  =R2 ^R1 ;
	R0  =R5 &R0 ;
	R0  =R1 ^R0 ;
	R3  =[P2 ++];
	[FP +-48] =R3 ;
	R3 =R0 +R3 ;
	R6 =R6 +R3 ;
	R3.L  = 4015; R3.H  = -2692;
	R3 =R3 +R6 ; //immed->Dreg 
	R6  =R3 ;
	R3  <<=7;
	R6  >>=25;
	R3  =R3 |R6 ;
	R3 =R3 +R5 ;
	R0  =R5 ^R2 ;
	R0  =R3 &R0 ;
	R0  =R2 ^R0 ;
	R6  =[P2 ++];
	[FP +-44] =R6 ;
	R6 =R0 +R6 ;
	R1 =R1 +R6 ;
	R6.L  = -14806; R6.H  = 18311;
	R6 =R6 +R1 ; //immed->Dreg 
	R1  =R6 ;
	R0  =R6 ;
	R0  <<=12;
	R1  >>=20;
	R0  =R0 |R1 ;
	R0 =R0 +R3 ;
	R1  =R3 ^R5 ;
	R1  =R0 &R1 ;
	R1  =R5 ^R1 ;
	R6  =[P2 ++];
	[FP +-40] =R6 ;
	R6 =R1 +R6 ;
	R2 =R2 +R6 ;
	R1.L  = 17939; R1.H  = -22480;
	R1 =R1 +R2 ; //immed->Dreg 
	R2  =R1 ;
	R1  <<=17;
	R2  >>=15;
	R1  =R1 |R2 ;
	R1 =R1 +R0 ;
	R2  =R0 ^R3 ;
	R2  =R1 &R2 ;
	R2  =R3 ^R2 ;
	R6  =[P2 ++];
	[FP +-36] =R6 ;
	R6 =R2 +R6 ;
	R5 =R5 +R6 ;
	R2.L  = -27391; R2.H  = -698;
	R2 =R2 +R5 ; //immed->Dreg 
	R5  =R2 ;
	R6  =R2 ;
	R6  <<=22;
	R5  >>=10;
	R6  =R6 |R5 ;
	R6 =R6 +R1 ;
	R2  =R1 ^R0 ;
	R2  =R6 &R2 ;
	R2  =R0 ^R2 ;
	R5  =[P2 ++];
	[FP +-32] =R5 ;
	R5 =R2 +R5 ;
	R3 =R3 +R5 ;
	R5.L  = -26408; R5.H  = 27008;
	R5 =R5 +R3 ; //immed->Dreg 
	R3  =R5 ;
	R2  =R5 ;
	R2  <<=7;
	R3  >>=25;
	R2  =R2 |R3 ;
	R2 =R2 +R6 ;
	R3  =R6 ^R1 ;
	R3  =R2 &R3 ;
	R3  =R1 ^R3 ;
	R5  =[P2 ++];
	[FP +-28] =R5 ;
	R5 =R3 +R5 ;
	R0 =R0 +R5 ;
	R3.L  = -2129; R3.H  = -29884;
	R3 =R3 +R0 ; //immed->Dreg 
	R0  =R3 ;
	R3  <<=12;
	R0  >>=20;
	R3  =R3 |R0 ;
	R3 =R3 +R2 ;
	R0  =R2 ^R6 ;
	R0  =R3 &R0 ;
	R0  =R6 ^R0 ;
	R5  =[P2 ++];
	[FP +-24] =R5 ;
	R5 =R0 +R5 ;
	R1 =R1 +R5 ;
	R5.L  = 23473; R5.H  = -1;
	R5 =R5 +R1 ; //immed->Dreg 
	R1  =R5 ;
	R5  <<=17;
	R1  >>=15;
	R5  =R5 |R1 ;
	R5 =R5 +R3 ;
	R0  =R3 ^R2 ;
	R0  =R5 &R0 ;
	R0  =R2 ^R0 ;
	R1  =[P2 ++];
	[FP +-20] =R1 ;
	R1 =R0 +R1 ;
	R6 =R6 +R1 ;
	R0.L  = -10306; R0.H  = -30372;
	R0 =R0 +R6 ; //immed->Dreg 
	R6  =R0 ;
	R0  <<=22;
	R6  >>=10;
	R0  =R0 |R6 ;
	R0 =R0 +R5 ;
	R1  =R5 ^R3 ;
	R1  =R0 &R1 ;
	R1  =R3 ^R1 ;
	R6  =[P2 ++];
	[FP +-16] =R6 ;
	R6 =R1 +R6 ;
	R2 =R2 +R6 ;
	R1.L  = 4386; R1.H  = 27536;
	R1 =R1 +R2 ; //immed->Dreg 
	R2  =R1 ;
	R6  =R1 ;
	R6  <<=7;
	R2  >>=25;
	R6  =R6 |R2 ;
	R6 =R6 +R0 ;
	R1  =R0 ^R5 ;
	R1  =R6 &R1 ;
	R1  =R5 ^R1 ;
	R2  =[P2 ++];
	[FP +-12] =R2 ;
	R2 =R1 +R2 ;
	R3 =R3 +R2 ;
	R2.L  = 29075; R2.H  = -616;
	R2 =R2 +R3 ; //immed->Dreg 
	R3  =R2 ;
	R2  <<=12;
	R3  >>=20;
	R2  =R2 |R3 ;
	R2 =R2 +R6 ;
	R1  =R6 ^R0 ;
	R1  =R2 &R1 ;
	R1  =R0 ^R1 ;
	R3  =[P2 ++];
	[FP +-8] =R3 ;
	R3 =R1 +R3 ;
	R5 =R5 +R3 ;
	R3.L  = 17294; R3.H  = -22919;
	R3 =R3 +R5 ; //immed->Dreg 
	R5  =R3 ;
	R1  =R3 ;
	R1  <<=17;
	R5  >>=15;
	R1  =R1 |R5 ;
	R1 =R1 +R2 ;
	R3  =R2 ^R6 ;
	R3  =R1 &R3 ;
	R3  =R6 ^R3 ;
	R5  =[P2 ++];
	[FP +-4] =R5 ;
	R5 =R3 +R5 ;
	R0 =R0 +R5 ;
	R5.L  = 2081; R5.H  = 18868;
	R5 =R5 +R0 ; //immed->Dreg 
	R0  =R5 ;
	R5  <<=22;
	R0  >>=10;
	R5  =R5 |R0 ;
	R5 =R5 +R1 ;
	R0  =R5 ^R1 ;
	R0  =R2 &R0 ;
	R0  =R1 ^R0 ;
	P4  =[FP +-60];
	R3  =P4 ;
	R0 =R0 +R3 ;
	R6 =R6 +R0 ;
	R0.L  = 9570; R0.H  = -2530;
	R0 =R0 +R6 ; //immed->Dreg 
	R6  =R0 ;
	R0  <<=5;
	R6  >>=27;
	R0  =R0 |R6 ;
	R0 =R0 +R5 ;
	R3  =R0 ^R5 ;
	R3  =R1 &R3 ;
	R3  =R5 ^R3 ;
	P3  =[FP +-40];
	R6  =P3 ;
	R3 =R3 +R6 ;
	R2 =R2 +R3 ;
	R3.L  = -19648; R3.H  = -16320;
	R3 =R3 +R2 ; //immed->Dreg 
	R2  =R3 ;
	R6  =R3 ;
	R6  <<=9;
	R2  >>=23;
	R6  =R6 |R2 ;
	R6 =R6 +R0 ;
	R3  =R6 ^R0 ;
	R3  =R5 &R3 ;
	R3  =R0 ^R3 ;
	R2  =[FP +-20];
	[FP +-92] =R2 ;
	R2 =R3 +R2 ;
	R1 =R1 +R2 ;
	R2.L  = 23121; R2.H  = 9822;
	R2 =R2 +R1 ; //immed->Dreg 
	R1  =R2 ;
	R2  <<=14;
	R1  >>=18;
	R2  =R2 |R1 ;
	R2 =R2 +R6 ;
	R3  =R2 ^R6 ;
	R3  =R0 &R3 ;
	R3  =R6 ^R3 ;
	R1  =[FP +-64];
	[FP +-96] =R1 ;
	R1 =R3 +R1 ;
	R5 =R5 +R1 ;
	R3.L  = -14422; R3.H  = -5706;
	R3 =R3 +R5 ; //immed->Dreg 
	R5  =R3 ;
	R3  <<=20;
	R5  >>=12;
	R3  =R3 |R5 ;
	R3 =R3 +R2 ;
	R5  =R3 ^R2 ;
	R5  =R6 &R5 ;
	R5  =R2 ^R5 ;
	R1  =[FP +-44];
	[FP +-100] =R1 ;
	R1 =R5 +R1 ;
	R0 =R0 +R1 ;
	R5.L  = 4189; R5.H  = -10705;
	R5 =R5 +R0 ; //immed->Dreg 
	R0  =R5 ;
	R1  =R5 ;
	R1  <<=5;
	R0  >>=27;
	R1  =R1 |R0 ;
	R1 =R1 +R3 ;
	R5  =R1 ^R3 ;
	R5  =R2 &R5 ;
	R5  =R3 ^R5 ;
	R0  =[FP +-24];
	[FP +-104] =R0 ;
	R0 =R5 +R0 ;
	R6 =R6 +R0 ;
	R0.L  = 5203; R0.H  = 580;
	R0 =R0 +R6 ; //immed->Dreg 
	R6  =R0 ;
	R5  =R0 ;
	R5  <<=9;
	R6  >>=23;
	R5  =R5 |R6 ;
	R5 =R5 +R1 ;
	R6  =R5 ^R1 ;
	R6  =R3 &R6 ;
	R6  =R1 ^R6 ;
	R0  =[FP +-4];
	[FP +-108] =R0 ;
	R0 =R6 +R0 ;
	R2 =R2 +R0 ;
	R6.L  = -6527; R6.H  = -10079;
	R6 =R6 +R2 ; //immed->Dreg 
	R2  =R6 ;
	R0  =R6 ;
	R0  <<=14;
	R2  >>=18;
	R0  =R0 |R2 ;
	R0 =R0 +R5 ;
	R6  =R0 ^R5 ;
	R6  =R1 &R6 ;
	R6  =R5 ^R6 ;
	R2  =[FP +-48];
	[FP +-112] =R2 ;
	R2 =R6 +R2 ;
	R3 =R3 +R2 ;
	R2.L  = -1080; R2.H  = -6189;
	R2 =R2 +R3 ; //immed->Dreg 
	R3  =R2 ;
	R6  =R2 ;
	R6  <<=20;
	R3  >>=12;
	R6  =R6 |R3 ;
	R6 =R6 +R0 ;
	R3  =R6 ^R0 ;
	R3  =R5 &R3 ;
	R3  =R0 ^R3 ;
	R2  =[FP +-28];
	[FP +-116] =R2 ;
	R2 =R3 +R2 ;
	R1 =R1 +R2 ;
	R3.L  = -12826; R3.H  = 8673;
	R3 =R3 +R1 ; //immed->Dreg 
	R1  =R3 ;
	R2  =R3 ;
	R2  <<=5;
	R1  >>=27;
	R2  =R2 |R1 ;
	R2 =R2 +R6 ;
	R1  =R2 ^R6 ;
	R1  =R0 &R1 ;
	R1  =R6 ^R1 ;
	P5  =[FP +-8];
	R3  =P5 ;
	R1 =R1 +R3 ;
	R5 =R5 +R1 ;
	R1.L  = 2006; R1.H  = -15561;
	R1 =R1 +R5 ; //immed->Dreg 
	R5  =R1 ;
	R3  =R1 ;
	R3  <<=9;
	R5  >>=23;
	R3  =R3 |R5 ;
	R3 =R3 +R2 ;
	R5  =R3 ^R2 ;
	R5  =R6 &R5 ;
	R5  =R2 ^R5 ;
	R1  =[FP +-52];
	[FP +-120] =R1 ;
	R1 =R5 +R1 ;
	R0 =R0 +R1 ;
	R5.L  = 3463; R5.H  = -2859;
	R5 =R5 +R0 ; //immed->Dreg 
	R0  =R5 ;
	R4  =R5 ;
	R4  <<=14;
	R0  >>=18;
	R4  =R4 |R0 ;
	R4 =R4 +R3 ;
	R1  =R4 ^R3 ;
	R1  =R2 &R1 ;
	R1  =R3 ^R1 ;
	R0  =[FP +-32];
	[FP +-124] =R0 ;
	R0 =R1 +R0 ;
	R6 =R6 +R0 ;
	R0.L  = 5357; R0.H  = 17754;
	R0 =R0 +R6 ; //immed->Dreg 
	R6  =R0 ;
	R1  =R0 ;
	R1  <<=20;
	R6  >>=12;
	R1  =R1 |R6 ;
	R1 =R1 +R4 ;
	R6  =R1 ^R4 ;
	R6  =R3 &R6 ;
	R6  =R4 ^R6 ;
	R0  =[FP +-12];
	[FP +-128] =R0 ;
	R0 =R6 +R0 ;
	R2 =R2 +R0 ;
	R5.L  = -5883; R5.H  = -22045;
	R5 =R5 +R2 ; //immed->Dreg 
	R2  =R5 ;
	R6  =R5 ;
	R6  <<=5;
	R2  >>=27;
	R6  =R6 |R2 ;
	R6 =R6 +R1 ;
	R2  =R6 ^R1 ;
	R2  =R4 &R2 ;
	R2  =R1 ^R2 ;
	R0  =[FP +-56];
	[FP +-132] =R0 ;
	R0 =R2 +R0 ;
	R3 =R3 +R0 ;
	R0.L  = -23560; R0.H  = -785;
	R0 =R0 +R3 ; //immed->Dreg 
	R3  =R0 ;
	R5  =R0 ;
	R5  <<=9;
	R3  >>=23;
	R5  =R5 |R3 ;
	R5 =R5 +R6 ;
	R0  =R5 ^R6 ;
	R0  =R1 &R0 ;
	R0  =R6 ^R0 ;
	P1  =[FP +-36];
	R2  =P1 ;
	R0 =R0 +R2 ;
	R4 =R4 +R0 ;
	R3.L  = 729; R3.H  = 26479;
	R3 =R3 +R4 ; //immed->Dreg 
	R4  =R3 ;
	R3  <<=14;
	R4  >>=18;
	R3  =R3 |R4 ;
	R3 =R3 +R5 ;
	R0  =R3 ^R5 ;
	R0  =R6 &R0 ;
	R0  =R5 ^R0 ;
	P0  =[FP +-16];
	R2  =P0 ;
	R0 =R0 +R2 ;
	R1 =R1 +R0 ;
	R0.L  = 19594; R0.H  = -29398;
	R0 =R0 +R1 ; //immed->Dreg 
	R1  =R0 ;
	R0  <<=20;
	R1  >>=12;
	R0  =R0 |R1 ;
	R0 =R0 +R3 ;
	R1  =R0 ^R3 ;
	R1  =R1 ^R5 ;
	R2  =[FP +-100];
	R2 =R1 +R2 ;
	R6 =R6 +R2 ;
	R1.L  = 14658; R1.H  = -6;
	R1 =R1 +R6 ; //immed->Dreg 
	R6  =R1 ;
	R1  <<=4;
	R6  >>=28;
	R1  =R1 |R6 ;
	R1 =R1 +R0 ;
	R2  =R1 ^R0 ;
	R2  =R2 ^R3 ;
	R6  =[FP +-124];
	R6 =R2 +R6 ;
	R5 =R5 +R6 ;
	R2.L  = -2431; R2.H  = -30863;
	R2 =R2 +R5 ; //immed->Dreg 
	R5  =R2 ;
	R2  <<=11;
	R5  >>=21;
	R2  =R2 |R5 ;
	R2 =R2 +R1 ;
	R6  =R2 ^R1 ;
	R6  =R6 ^R0 ;
	R5  =[FP +-92];
	R5 =R6 +R5 ;
	R3 =R3 +R5 ;
	R5.L  = 24866; R5.H  = 28061;
	R5 =R5 +R3 ; //immed->Dreg 
	R3  =R5 ;
	R6  =R5 ;
	R6  <<=16;
	R3  >>=16;
	R6  =R6 |R3 ;
	R6 =R6 +R2 ;
	R3  =R6 ^R2 ;
	R3  =R3 ^R1 ;
	R5  =P5 ;
	R3 =R3 +R5 ;
	R0 =R0 +R3 ;
	R3.L  = 14348; R3.H  = -539;
	R3 =R3 +R0 ; //immed->Dreg 
	R0  =R3 ;
	R3  <<=23;
	R0  >>=9;
	R4  =R3 |R0 ;
	R4 =R4 +R6 ;
	R0  =R4 ^R6 ;
	R0  =R0 ^R2 ;
	R5  =P4 ;
	R0 =R0 +R5 ;
	R1 =R1 +R0 ;
	R0.L  = -5564; R0.H  = -23362;
	R0 =R0 +R1 ; //immed->Dreg 
	R1  =R0 ;
	R3  =R0 ;
	R3  <<=4;
	R1  >>=28;
	R3  =R3 |R1 ;
	R3 =R3 +R4 ;
	R0  =R3 ^R4 ;
	R0  =R0 ^R6 ;
	R1  =[FP +-112];
	R1 =R0 +R1 ;
	R2 =R2 +R1 ;
	R1.L  = -12375; R1.H  = 19422;
	R1 =R1 +R2 ; //immed->Dreg 
	R2  =R1 ;
	R5  =R1 ;
	R5  <<=11;
	R2  >>=21;
	R5  =R5 |R2 ;
	R5 =R5 +R3 ;
	R0  =R5 ^R3 ;
	R0  =R0 ^R4 ;
	R2  =P1 ;
	R0 =R0 +R2 ;
	R6 =R6 +R0 ;
	R0.L  = 19296; R0.H  = -2373;
	R0 =R0 +R6 ; //immed->Dreg 
	R6  =R0 ;
	R0  <<=16;
	R6  >>=16;
	R0  =R0 |R6 ;
	R0 =R0 +R5 ;
	R1  =R0 ^R5 ;
	R1  =R1 ^R3 ;
	R2  =[FP +-104];
	R2 =R1 +R2 ;
	R1 =R4 +R2 ;
	R2.L  = -17296; R2.H  = -16705;
	R2 =R2 +R1 ; //immed->Dreg 
	R1  =R2 ;
	R4  =R2 ;
	R4  <<=23;
	R1  >>=9;
	R4  =R4 |R1 ;
	R4 =R4 +R0 ;
	R1  =R4 ^R0 ;
	R1  =R1 ^R5 ;
	R2  =[FP +-128];
	R2 =R1 +R2 ;
	R3 =R3 +R2 ;
	R6.L  = 32454; R6.H  = 10395;
	R6 =R6 +R3 ; //immed->Dreg 
	R3  =R6 ;
	R1  =R6 ;
	R1  <<=4;
	R3  >>=28;
	R1  =R1 |R3 ;
	R1 =R1 +R4 ;
	R2  =R1 ^R4 ;
	R2  =R2 ^R0 ;
	R3  =[FP +-96];
	R3 =R2 +R3 ;
	R5 =R5 +R3 ;
	R2.L  = 10234; R2.H  = -5471;
	R2 =R2 +R5 ; //immed->Dreg 
	R5  =R2 ;
	R6  =R2 ;
	R6  <<=11;
	R5  >>=21;
	R6  =R6 |R5 ;
	R6 =R6 +R1 ;
	R2  =R6 ^R1 ;
	R2  =R2 ^R4 ;
	R3  =[FP +-120];
	R3 =R2 +R3 ;
	R0 =R0 +R3 ;
	R3.L  = 12421; R3.H  = -11025;
	R3 =R3 +R0 ; //immed->Dreg 
	R0  =R3 ;
	R2  =R3 ;
	R2  <<=16;
	R0  >>=16;
	R2  =R2 |R0 ;
	R2 =R2 +R6 ;
	R0  =R2 ^R6 ;
	R0  =R0 ^R1 ;
	R5  =P3 ;
	R0 =R0 +R5 ;
	R4 =R4 +R0 ;
	R0.L  = 7429; R0.H  = 1160;
	R0 =R0 +R4 ; //immed->Dreg 
	R4  =R0 ;
	R5  =R0 ;
	R5  <<=23;
	R4  >>=9;
	R5  =R5 |R4 ;
	R5 =R5 +R2 ;
	R0  =R5 ^R2 ;
	R0  =R0 ^R6 ;
	R3  =[FP +-116];
	R3 =R0 +R3 ;
	R1 =R1 +R3 ;
	R3.L  = -12231; R3.H  = -9772;
	R3 =R3 +R1 ; //immed->Dreg 
	R1  =R3 ;
	R0  =R3 ;
	R0  <<=4;
	R1  >>=28;
	R0  =R0 |R1 ;
	R0 =R0 +R5 ;
	R1  =R0 ^R5 ;
	R1  =R1 ^R2 ;
	R3  =P0 ;
	R1 =R1 +R3 ;
	R6 =R6 +R1 ;
	R1.L  = -26139; R1.H  = -6437;
	R1 =R1 +R6 ; //immed->Dreg 
	R6  =R1 ;
	R3  =R1 ;
	R3  <<=11;
	R6  >>=21;
	R3  =R3 |R6 ;
	R3 =R3 +R0 ;
	R1  =R3 ^R0 ;
	R1  =R1 ^R5 ;
	R6  =[FP +-108];
	R6 =R1 +R6 ;
	R2 =R2 +R6 ;
	R6.L  = 31992; R6.H  = 8098;
	R6 =R6 +R2 ; //immed->Dreg 
	R2  =R6 ;
	R1  =R6 ;
	R1  <<=16;
	R2  >>=16;
	R1  =R1 |R2 ;
	R1 =R1 +R3 ;
	R2  =R1 ^R3 ;
	R2  =R2 ^R0 ;
	R6  =[FP +-132];
	R6 =R2 +R6 ;
	R5 =R5 +R6 ;
	R2.L  = 22117; R2.H  = -15188;
	R2 =R2 +R5 ; //immed->Dreg 
	R5  =R2 ;
	R6  =R2 ;
	R6  <<=23;
	R5  >>=9;
	R6  =R6 |R5 ;
	R6 =R6 +R1 ;
	R2  =~R3 ;
	R2  =R6 |R2 ;
	R2  =R1 ^R2 ;
	R5  =[FP +-96];
	R5 =R2 +R5 ;
	R0 =R0 +R5 ;
	R5.L  = 8772; R5.H  = -3031;
	R5 =R5 +R0 ; //immed->Dreg 
	R0  =R5 ;
	R2  =R5 ;
	R2  <<=6;
	R0  >>=26;
	R2  =R2 |R0 ;
	R2 =R2 +R6 ;
	R0  =~R1 ;
	R0  =R2 |R0 ;
	R0  =R6 ^R0 ;
	R5  =P1 ;
	R0 =R0 +R5 ;
	R3 =R3 +R0 ;
	R0.L  = -105; R0.H  = 17194;
	R0 =R0 +R3 ; //immed->Dreg 
	R3  =R0 ;
	R5  =R0 ;
	R5  <<=10;
	R3  >>=22;
	R5  =R5 |R3 ;
	R5 =R5 +R2 ;
	R0  =~R6 ;
	R0  =R5 |R0 ;
	R0  =R2 ^R0 ;
	R3  =P5 ;
	R0 =R0 +R3 ;
	R1 =R1 +R0 ;
	R0.L  = 9127; R0.H  = -21612;
	R0 =R0 +R1 ; //immed->Dreg 
	R1  =R0 ;
	R0  <<=15;
	R1  >>=17;
	R0  =R0 |R1 ;
	R0 =R0 +R5 ;
	R1  =~R2 ;
	R1  =R0 |R1 ;
	R1  =R5 ^R1 ;
	R3  =[FP +-100];
	R3 =R1 +R3 ;
	R6 =R6 +R3 ;
	R1.L  = -24519; R1.H  = -877;
	R1 =R1 +R6 ; //immed->Dreg 
	R6  =R1 ;
	R3  =R1 ;
	R3  <<=21;
	R6  >>=11;
	R3  =R3 |R6 ;
	R3 =R3 +R0 ;
	R1  =~R5 ;
	R1  =R3 |R1 ;
	R1  =R0 ^R1 ;
	R6  =P0 ;
	R1 =R1 +R6 ;
	R2 =R2 +R1 ;
	R1.L  = 22979; R1.H  = 25947;
	R1 =R1 +R2 ; //immed->Dreg 
	R2  =R1 ;
	R1  <<=6;
	R2  >>=26;
	R1  =R1 |R2 ;
	R1 =R1 +R3 ;
	R2  =~R0 ;
	R2  =R1 |R2 ;
	R2  =R3 ^R2 ;
	R6  =[FP +-120];
	R6 =R2 +R6 ;
	R5 =R5 +R6 ;
	R2.L  = -13166; R2.H  = -28916;
	R2 =R2 +R5 ; //immed->Dreg 
	R5  =R2 ;
	R6  =R2 ;
	R6  <<=10;
	R5  >>=22;
	R6  =R6 |R5 ;
	R6 =R6 +R1 ;
	R2  =~R3 ;
	R2  =R6 |R2 ;
	R2  =R1 ^R2 ;
	R5  =[FP +-104];
	R5 =R2 +R5 ;
	R0 =R0 +R5 ;
	R5.L  = -2947; R5.H  = -17;
	R5 =R5 +R0 ; //immed->Dreg 
	R0  =R5 ;
	R2  =R5 ;
	R2  <<=15;
	R0  >>=17;
	R2  =R2 |R0 ;
	R2 =R2 +R6 ;
	R0  =~R1 ;
	R0  =R2 |R0 ;
	R0  =R6 ^R0 ;
	R5  =P4 ;
	R0 =R0 +R5 ;
	R3 =R3 +R0 ;
	R0.L  = 24017; R0.H  = -31356;
	R0 =R0 +R3 ; //immed->Dreg 
	R3  =R0 ;
	R5  =R0 ;
	R5  <<=21;
	R3  >>=11;
	R5  =R5 |R3 ;
	R5 =R5 +R2 ;
	R0  =~R6 ;
	R0  =R5 |R0 ;
	R0  =R2 ^R0 ;
	R3  =[FP +-124];
	R3 =R0 +R3 ;
	R1 =R1 +R3 ;
	R3.L  = 32335; R3.H  = 28584;
	R3 =R3 +R1 ; //immed->Dreg 
	R1  =R3 ;
	R0  =R3 ;
	R0  <<=6;
	R1  >>=26;
	R0  =R0 |R1 ;
	R0 =R0 +R5 ;
	R1  =~R2 ;
	R1  =R0 |R1 ;
	R1  =R5 ^R1 ;
	R3  =[FP +-108];
	R3 =R1 +R3 ;
	R6 =R6 +R3 ;
	R1.L  = -6432; R1.H  = -468;
	R1 =R1 +R6 ; //immed->Dreg 
	R6  =R1 ;
	R3  =R1 ;
	R3  <<=10;
	R6  >>=22;
	R3  =R3 |R6 ;
	R3 =R3 +R0 ;
	R1  =~R5 ;
	R1  =R3 |R1 ;
	R1  =R0 ^R1 ;
	R6  =P3 ;
	R1 =R1 +R6 ;
	R2 =R2 +R1 ;
	R1.L  = 17172; R1.H  = -23807;
	R1 =R1 +R2 ; //immed->Dreg 
	R2  =R1 ;
	R1  <<=15;
	R2  >>=17;
	R1  =R1 |R2 ;
	R1 =R1 +R3 ;
	R2  =~R0 ;
	R2  =R1 |R2 ;
	R2  =R3 ^R2 ;
	R6  =[FP +-128];
	R6 =R2 +R6 ;
	R5 =R5 +R6 ;
	R2.L  = 4513; R2.H  = 19976;
	R2 =R2 +R5 ; //immed->Dreg 
	R5  =R2 ;
	R6  =R2 ;
	R6  <<=21;
	R5  >>=11;
	R6  =R6 |R5 ;
	R6 =R6 +R1 ;
	R2  =~R3 ;
	R2  =R6 |R2 ;
	R2  =R1 ^R2 ;
	R5  =[FP +-112];
	R5 =R2 +R5 ;
	R0 =R0 +R5 ;
	R5.L  = 32386; R5.H  = -2221;
	R5 =R5 +R0 ; //immed->Dreg 
	R0  =R5 ;
	R2  =R5 ;
	R2  <<=6;
	R0  >>=26;
	R2  =R2 |R0 ;
	R2 =R2 +R6 ;
	R0  =~R1 ;
	R0  =R2 |R0 ;
	R0  =R6 ^R0 ;
	R5  =[FP +-92];
	R5 =R0 +R5 ;
	R3 =R3 +R5 ;
	R0.L  = -3531; R0.H  = -17094;
	R0 =R0 +R3 ; //immed->Dreg 
	R3  =R0 ;
	R5  =R0 ;
	R5  <<=10;
	R3  >>=22;
	R5  =R5 |R3 ;
	R5 =R5 +R2 ;
	R0  =~R6 ;
	R0  =R5 |R0 ;
	R0  =R2 ^R0 ;
	R3  =[FP +-132];
	R3 =R0 +R3 ;
	R1 =R1 +R3 ;
	R3.L  = -11589; R3.H  = 10967;
	R3 =R3 +R1 ; //immed->Dreg 
	R1  =R3 ;
	R0  =R3 ;
	R0  <<=15;
	R1  >>=17;
	R0  =R0 |R1 ;
	R0 =R0 +R5 ;
	R1  =~R2 ;
	R1  =R0 |R1 ;
	R1  =R5 ^R1 ;
	R3  =[FP +-116];
	R3 =R1 +R3 ;
	R6 =R6 +R3 ;
	R1.L  = -11375; R1.H  = -5242;
	R1 =R1 +R6 ; //immed->Dreg 
	R6  =R1 ;
	R3  =R1 ;
	R3  <<=21;
	R6  >>=11;
	R3  =R3 |R6 ;
	R3 =R3 +R0 ;
	R1  =[FP +-76];
	R2 =R2 +R1 ;
	R1  =[FP +-80];
	R3 =R3 +R1 ;
	R1  =[FP +-84];
	R0 =R0 +R1 ;
	R1  =[FP +-88];
	R5 =R5 +R1 ;
	P1  =[FP +-72];
	cc =P2 <P1  (iu);
	if !cc jump 6; jump.l L$L$98;
L$L$100:
	P2  =[FP +-68];
	[P2 ] =R2 ;
	[P2 +4] =R3 ;
	[P2 +8] =R0 ;
	[P2 +12] =R5 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


