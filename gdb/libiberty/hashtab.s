// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "hashtab.i";
.global _htab_hash_pointer;
.data;
.align 2
_htab_hash_pointer:	.long	_hash_pointer
.global _htab_eq_pointer;
.align 2
_htab_eq_pointer:	.long	_eq_pointer
.text;
.align 2
L_primes_$0:	.long	7
	.long	13
	.long	31
	.long	61
	.long	127
	.long	251
	.long	509
	.long	1021
	.long	2039
	.long	4093
	.long	8191
	.long	16381
	.long	32749
	.long	65521
	.long	131071
	.long	262139
	.long	524287
	.long	1048573
	.long	2097143
	.long	4194301
	.long	8388593
	.long	16777213
	.long	33554393
	.long	67108859
	.long	134217689
	.long	268435399
	.long	536870909
	.long	1073741789
	.long	2147483647
	.long	-5
.align 2
L$LC$0:
.dw	0x6143;
.dw	0x6e6e;
.dw	0x746f;
.dw	0x6620;
.dw	0x6e69;
.dw	0x2064;
.dw	0x7270;
.dw	0x6d69;
.dw	0x2065;
.dw	0x6962;
.dw	0x6767;
.dw	0x7265;
.dw	0x7420;
.dw	0x6168;
.dw	0x206e;
.dw	0x6c25;
.dw	0x0a75;
.db	0x00;
.align 2
.type _higher_prime_number, STT_FUNC;
_higher_prime_number:
	LINK 0;
	[--sp] = ( r7:6 );
	R6.L  = L_primes_$0; R6.H  = L_primes_$0;
	R3.L  = L_primes_$0+120; R3.H  = L_primes_$0+120;
	cc =R6 ==R3 ;
	if !cc jump 6; jump.l L$L$10;
L$L$7:
	R1  =R3 -R6 ;
	R2  =R1 ;
	R2  >>>=2;
	R1  >>=31;
	R2 =R2 +R1 ;
	R2  >>>=1;
	P1  =R2 ;
	P2  =R6 ;
	P1  =P2 +(P1 <<2);
	R2  =P1 ;
	R1  =[P1 ];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$5;
	R6  = 4 (X);
	R6 =R6 +R2 ; //immed->Dreg 
	jump.s L$L$2;
L$L$5:
	R3  =P1 ;
L$L$2:
	cc =R6 ==R3 ;
	if cc jump 6; jump.l L$L$7;
L$L$10:
	P1  =R6 ;
	R1  =[P1 ];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$8;
	P2.L  = _stderr; P2.H  = _stderr;
	P2  =[P2 ];
	[SP +12] =P2 ;
	P2.L  = L$LC$0; P2.H  = L$LC$0;
	[SP +16] =P2 ;
	[SP +20] =R0 ;
	call _fprintf;
	call _abort;
L$L$8:
	P1  =R6 ;
	R0  =[P1 ];
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _hash_pointer, STT_FUNC;
_hash_pointer:
	LINK 0;
	R0  >>>=3;
	UNLINK;
	rts;


.align 2
.type _eq_pointer, STT_FUNC;
_eq_pointer:
	LINK 0;
	cc =R0 ==R1 ;
	R0  =CC ;
	UNLINK;
	rts;


.align 2
.global _htab_create_alloc;
.type _htab_create_alloc, STT_FUNC;
_htab_create_alloc:
	LINK 4;
	[--sp] = ( r7:4, p5:3 );
	[FP +-4] =R1 ;
	[FP +16] =R2 ;
	R4  =R2 ;
	R5  =[FP +20];
	P3  =[FP +24];
	P4  =[FP +28];
	call _higher_prime_number;
	R6  =R0 ;
	R0  = 1 (X);
	R1  = 56 (X);
	call (P3 );
	P5  =R0 ;
	R0  = 0 (X);
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$13;
	R0  =R6 ;
	R1  = 4 (X);
	call (P3 );
	[P5 +12] =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$15;
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$16;
	R0  =P5 ;
	call (P4 );
L$L$16:
	R0  = 0 (X);
	jump.s L$L$13;
L$L$15:
	[P5 +16] =R6 ;
	R0  =[FP +-4];
	[P5 ] =R0 ;
	[P5 +4] =R4 ;
	[P5 +8] =R5 ;
	[P5 +36] =P3 ;
	[P5 +40] =P4 ;
	R0  =P5 ;
L$L$13:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _htab_create_alloc_ex;
.type _htab_create_alloc_ex, STT_FUNC;
_htab_create_alloc_ex:
	LINK 8;
	[--sp] = ( r7:4, p5:3 );
	R3  =R0 ;
	[FP +-4] =R1 ;
	[FP +16] =R2 ;
	[FP +-8] =R2 ;
	R4  =[FP +20];
	R5  =[FP +24];
	P3  =[FP +28];
	P4  =[FP +32];
	R0  =R3 ;
	call _higher_prime_number;
	R6  =R0 ;
	R2  = 56 (X);
	R0  =R5 ;
	R1  = 1 (X);
	call (P3 );
	P5  =R0 ;
	R0  = 0 (X);
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$17;
	R2  = 4 (X);
	R0  =R5 ;
	R1  =R6 ;
	call (P3 );
	[P5 +12] =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$19;
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$20;
	R0  =R5 ;
	R1  =P5 ;
	call (P4 );
L$L$20:
	R0  = 0 (X);
	jump.s L$L$17;
L$L$19:
	[P5 +16] =R6 ;
	R0  =[FP +-4];
	[P5 ] =R0 ;
	R0  =[FP +-8];
	[P5 +4] =R0 ;
	[P5 +8] =R4 ;
	[P5 +44] =R5 ;
	[P5 +48] =P3 ;
	[P5 +52] =P4 ;
	R0  =P5 ;
L$L$17:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _htab_set_functions_ex;
.type _htab_set_functions_ex, STT_FUNC;
_htab_set_functions_ex:
	LINK 0;
	[--sp] = ( p5:5 );
	P0  =R2 ;
	P1  =[FP +20];
	P2  =[FP +24];
	R3  =[FP +28];
	R2  =[FP +32];
	P5  =R0 ;
	[P5 ] =R1 ;
	[P5 +4] =P0 ;
	[P5 +8] =P1 ;
	[P5 +44] =P2 ;
	[P5 +48] =R3 ;
	[P5 +52] =R2 ;
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _htab_create;
.type _htab_create, STT_FUNC;
_htab_create:
	LINK 0;
	[FP +16] =R2 ;
	R3  =[FP +20];
	[SP +12] =R3 ;
	R3.L  = _xcalloc; R3.H  = _xcalloc;
	[SP +16] =R3 ;
	R3.L  = _free; R3.H  = _free;
	[SP +20] =R3 ;
	call _htab_create_alloc;
	UNLINK;
	rts;


.align 2
.global _htab_try_create;
.type _htab_try_create, STT_FUNC;
_htab_try_create:
	LINK 0;
	[FP +16] =R2 ;
	R3  =[FP +20];
	[SP +12] =R3 ;
	R3.L  = _calloc; R3.H  = _calloc;
	[SP +16] =R3 ;
	R3.L  = _free; R3.H  = _free;
	[SP +20] =R3 ;
	call _htab_create_alloc;
	UNLINK;
	rts;


.align 2
.global _htab_delete;
.type _htab_delete, STT_FUNC;
_htab_delete:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R0  =[P5 +8];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$25;
	R6  =[P5 +16];
	R6 +=-1;
	cc =R6 <0;
	if !cc jump 6; jump.l L$L$25;
L$L$31:
	P2  =[P5 +12];
	P1  =R6 ;
	P2  =P2 +(P1 <<2);
	R0  =[P2 ];
	cc =R0 <=1 (iu);
	if !cc jump 6; jump.l L$L$28;
	P2  =[P5 +8];
	call (P2 );
L$L$28:
	R6 +=-1;
	cc =R6 <0;
	if cc jump 6; jump.l L$L$31;
L$L$25:
	P2  =[P5 +40];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$32;
	R0  =[P5 +12];
	call (P2 );
	P2  =[P5 +40];
	R0  =P5 ;
	call (P2 );
	jump.s L$L$24;
L$L$32:
	P2  =[P5 +52];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$24;
	R0  =[P5 +44];
	R1  =[P5 +12];
	call (P2 );
	R0  =[P5 +44];
	P2  =[P5 +52];
	R1  =P5 ;
	call (P2 );
L$L$24:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _htab_empty;
.type _htab_empty, STT_FUNC;
_htab_empty:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R0  =[P5 +8];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$37;
	R6  =[P5 +16];
	R6 +=-1;
	cc =R6 <0;
	if !cc jump 6; jump.l L$L$37;
L$L$43:
	P2  =[P5 +12];
	P1  =R6 ;
	P2  =P2 +(P1 <<2);
	R0  =[P2 ];
	cc =R0 <=1 (iu);
	if !cc jump 6; jump.l L$L$40;
	P2  =[P5 +8];
	call (P2 );
L$L$40:
	R6 +=-1;
	cc =R6 <0;
	if cc jump 6; jump.l L$L$43;
L$L$37:
	P2  =[P5 +16];
	P2  =P2 <<2;
	R1  =P2 ;
	R0  =[P5 +12];
	call _bzero;
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _find_empty_slot_for_expand, STT_FUNC;
_find_empty_slot_for_expand:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	P5  =R0 ;
	R4  =R1 ;
	R5  =[P5 +16];
	R0  =R1 ;
	R1  =R5 ;
	call ___umodsi3;
	R6  =R0 ;
	P2  =[P5 +12];
	P1  =R0 ;
	P1  =P2 +(P1 <<2);
	R0  =P1 ;
	R1  =[P1 ];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$45;
	cc =R1 ==1;
	if !cc jump 6; jump.l L$L$57;
	R1  = -2 (X);
	R1 =R1 +R5 ; //immed->Dreg 
	R0  =R4 ;
	call ___umodsi3;
	R2  = 1 (X);
	R2 =R2 +R0 ; //immed->Dreg 
L$L$49:
	R6 =R6 +R2 ;
	R0  =R6 -R5 ;
	cc =R6 <R5  (iu);
	if !cc R6  =R0 ; /* movsicc-1a */
	P2  =[P5 +12];
	P1  =R6 ;
	P1  =P2 +(P1 <<2);
	R0  =P1 ;
	R1  =[P1 ];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$45;
	cc =R1 ==1;
	if cc jump 6; jump.l L$L$49;
L$L$57:
	call _abort;
L$L$45:
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _htab_expand, STT_FUNC;
_htab_expand:
	LINK 0;
	[--sp] = ( r7:5, p5:3 );
	P3  =R0 ;
	P4  =[P3 +12];
	P1  =[P3 +16];
	P5  =P4 +(P1 <<2);
	R1  =[P3 +20];
	R0  =[P3 +24];
	R0  =R1 -R0 ;
	P0  =R0 ;
	P2  =P0 +P0 ;
	cc =P2 <=P1  (iu);
	if cc jump 6; jump.l L$L$60;
	R0  <<=3;
	R1  =P1 ;
	cc =R0 <R1  (iu);
	if cc jump 6; jump.l L$L$59;
	P0  = 32 (X);
	cc =P1 <=P0  (iu);
	if !cc jump 6; jump.l L$L$59;
L$L$60:
	R1  =[P3 +20];
	R0  =[P3 +24];
	R0  =R1 -R0 ;
	P2  =R0 ;
	P2  =P2 +P2 ;
	R0  =P2 ;
	call _higher_prime_number;
	R6  =R0 ;
	jump.s L$L$61;
L$L$59:
	R6  =[P3 +16];
L$L$61:
	P2  =[P3 +48];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$62;
	R0  =[P3 +44];
	R2  = 4 (X);
	R1  =R6 ;
	call (P2 );
	jump.s L$L$73;
L$L$62:
	P2  =[P3 +36];
	R0  =R6 ;
	R1  = 4 (X);
	call (P2 );
L$L$73:
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$58;
	[P3 +12] =R1 ;
	[P3 +16] =R6 ;
	R1  =[P3 +20];
	R0  =[P3 +24];
	R0  =R1 -R0 ;
	[P3 +20] =R0 ;
	R0  = 0 (X);
	[P3 +24] =R0 ;
	R5  =P4 ;
L$L$65:
	P0  =R5 ;
	R6  =[P0 ];
	cc =R6 <=1 (iu);
	if !cc jump 6; jump.l L$L$68;
	P2  =[P3 ];
	R0  =R6 ;
	call (P2 );
	R1  =R0 ;
	R0  =P3 ;
	call _find_empty_slot_for_expand;
	P2  =R0 ;
	[P2 ] =R6 ;
L$L$68:
	R5 +=4;
	R0  =P5 ;
	cc =R5 <R0  (iu);
	if !cc jump 6; jump.l L$L$65;
	P2  =[P3 +40];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$70;
	R0  =P4 ;
	call (P2 );
	jump.s L$L$71;
L$L$70:
	P2  =[P3 +52];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$71;
	R0  =[P3 +44];
	R1  =P4 ;
	call (P2 );
L$L$71:
	R0  = 1 (X);
L$L$58:
	( r7:5, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _htab_find_with_hash;
.type _htab_find_with_hash, STT_FUNC;
_htab_find_with_hash:
	LINK 0;
	[--sp] = ( r7:4, p5:3 );
	P4  =R0 ;
	R4  =R1 ;
	[FP +16] =R2 ;
	P3  =R2 ;
	R0  =[P4 +28];
	R0 +=1;
	[P4 +28] =R0 ;
	R5  =[P4 +16];
	R0  =R2 ;
	R1  =R5 ;
	call ___umodsi3;
	R6  =R0 ;
	P5  =[P4 +12];
	P2  =R0 ;
	P5  =P5 +(P2 <<2);
	P5  =[P5 ];
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$82;
	cc =P5 ==1;
	if !cc jump 6; jump.l L$L$75;
	P2  =[P4 +4];
	R0  =P5 ;
	R1  =R4 ;
	call (P2 );
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$82;
L$L$75:
	R1  = -2 (X);
	R1 =R1 +R5 ; //immed->Dreg 
	R0  =P3 ;
	call ___umodsi3;
	P3  =R0 ;
	P3 +=1;
L$L$83:
	R0  =[P4 +32];
	R0 +=1;
	[P4 +32] =R0 ;
	R0  =P3 ;
	R6 =R6 +R0 ;
	R0  =R6 -R5 ;
	cc =R6 <R5  (iu);
	if !cc R6  =R0 ; /* movsicc-1a */
	P5  =[P4 +12];
	P2  =R6 ;
	P5  =P5 +(P2 <<2);
	P5  =[P5 ];
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$82;
	cc =P5 ==1;
	if !cc jump 6; jump.l L$L$83;
	P2  =[P4 +4];
	R0  =P5 ;
	R1  =R4 ;
	call (P2 );
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$83;
L$L$82:
	R0  =P5 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _htab_find;
.type _htab_find, STT_FUNC;
_htab_find:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R6  =R1 ;
	P2  =[P5 ];
	R0  =R1 ;
	call (P2 );
	R2  =R0 ;
	R0  =P5 ;
	R1  =R6 ;
	call _htab_find_with_hash;
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _htab_find_slot_with_hash;
.type _htab_find_slot_with_hash, STT_FUNC;
_htab_find_slot_with_hash:
	LINK 4;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R0  =[FP +20];
	[FP +-4] =R0 ;
	cc =R0 ==1;
	if cc jump 6; jump.l L$L$86;
	P1  =[P3 +16];
	P1  =P1 +(P1 <<1);
	P2  =[P3 +20];
	P2  =P2 <<2;
	cc =P1 <=P2  (iu);
	if cc jump 6; jump.l L$L$86;
	R0  =P3 ;
	call _htab_expand;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$85;
L$L$86:
	R5  =[P3 +16];
	R0  =R6 ;
	R1  =R5 ;
	call ___umodsi3;
	R4  =R0 ;
	R0  =[P3 +28];
	R0 +=1;
	[P3 +28] =R0 ;
	P5  = 0 (X);
	P2  =[P3 +12];
	P1  =R4 ;
	P2  =P2 +(P1 <<2);
	R0  =[P2 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$88;
	cc =R0 ==1;
	if cc jump 6; jump.l L$L$90;
	P5  =P2 ;
	jump.s L$L$89;
L$L$90:
	P2  =[P3 +4];
	R1  =P4 ;
	call (P2 );
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$106;
L$L$89:
	R1  = -2 (X);
	R1 =R1 +R5 ; //immed->Dreg 
	R0  =R6 ;
	call ___umodsi3;
	R6  = 1 (X);
	R6 =R6 +R0 ; //immed->Dreg 
L$L$105:
	R0  =[P3 +32];
	R0 +=1;
	[P3 +32] =R0 ;
	R4 =R4 +R6 ;
	R0  =R4 -R5 ;
	cc =R4 <R5  (iu);
	if !cc R4  =R0 ; /* movsicc-1a */
	P2  =[P3 +12];
	P1  =R4 ;
	P2  =P2 +(P1 <<2);
	R0  =[P2 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$88;
	cc =R0 ==1;
	if cc jump 6; jump.l L$L$99;
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$105;
	P5  =P2 ;
	jump.s L$L$105;
L$L$99:
	P2  =[P3 +4];
	R1  =P4 ;
	call (P2 );
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$105;
L$L$106:
	P3  =[P3 +12];
	P2  =R4 ;
	P2  =P3 +(P2 <<2);
	R0  =P2 ;
	jump.s L$L$85;
L$L$88:
	R0  = 0 (X);
	R1  =[FP +-4];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$85;
	R0  =[P3 +20];
	R0 +=1;
	[P3 +20] =R0 ;
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$104;
	R0  = 0 (X);
	[P5 ] =R0 ;
	R0  =P5 ;
	jump.s L$L$85;
L$L$104:
	P3  =[P3 +12];
	P1  =R4 ;
	P1  =P3 +(P1 <<2);
	R0  =P1 ;
L$L$85:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _htab_find_slot;
.type _htab_find_slot, STT_FUNC;
_htab_find_slot:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	P5  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	P2  =[P5 ];
	R0  =R1 ;
	call (P2 );
	R2  =R0 ;
	[SP +12] =R6 ;
	R0  =P5 ;
	R1  =R5 ;
	call _htab_find_slot_with_hash;
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _htab_remove_elt;
.type _htab_remove_elt, STT_FUNC;
_htab_remove_elt:
	LINK 0;
	[--sp] = ( p5:4 );
	P4  =R0 ;
	R2  = 0 (X);
	call _htab_find_slot;
	P5  =R0 ;
	R0  =[P5 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$108;
	P2  =[P4 +8];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$110;
	call (P2 );
L$L$110:
	R0  = 1 (X);
	[P5 ] =R0 ;
	R0  =[P4 +24];
	R0 +=1;
	[P4 +24] =R0 ;
L$L$108:
	( p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _htab_clear_slot;
.type _htab_clear_slot, STT_FUNC;
_htab_clear_slot:
	LINK 0;
	[--sp] = ( p5:4 );
	P5  =R0 ;
	P4  =R1 ;
	P1  =[P5 +12];
	cc =P4 <P1  (iu);
	if !cc jump 6; jump.l L$L$113;
	P2  =[P5 +16];
	P1  =P1 +(P2 <<2);
	cc =P4 <P1  (iu);
	if cc jump 6; jump.l L$L$113;
	R0  =[P4 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$113;
	cc =R0 ==1;
	if cc jump 6; jump.l L$L$112;
L$L$113:
	call _abort;
L$L$112:
	P2  =[P5 +8];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$114;
	R0  =[P4 ];
	call (P2 );
L$L$114:
	R0  = 1 (X);
	[P4 ] =R0 ;
	R0  =[P5 +24];
	R0 +=1;
	[P5 +24] =R0 ;
	( p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _htab_traverse_noresize;
.type _htab_traverse_noresize, STT_FUNC;
_htab_traverse_noresize:
	LINK 0;
	[--sp] = ( r7:6, p5:3 );
	P3  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	P2  =R0 ;
	P4  =[P2 +12];
	P5  =[P2 +16];
	P5  =P4 +(P5 <<2);
L$L$116:
	R0  =[P4 ];
	cc =R0 <=1 (iu);
	if !cc jump 6; jump.l L$L$118;
	R0  =P4 ;
	R1  =R6 ;
	call (P3 );
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$117;
L$L$118:
	P4 +=4;
	cc =P4 <P5  (iu);
	if !cc jump 6; jump.l L$L$116;
L$L$117:
	( r7:6, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _htab_traverse;
.type _htab_traverse, STT_FUNC;
_htab_traverse:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	P5  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R0  =[P5 +20];
	R1  =[P5 +24];
	R1  =R0 -R1 ;
	R1  <<=3;
	R0  =[P5 +16];
	cc =R1 <R0  (iu);
	if cc jump 6; jump.l L$L$123;
	R0  =P5 ;
	call _htab_expand;
L$L$123:
	R2  =R6 ;
	R0  =P5 ;
	R1  =R5 ;
	call _htab_traverse_noresize;
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _htab_size;
.type _htab_size, STT_FUNC;
_htab_size:
	LINK 0;
	P2  =R0 ;
	R0  =[P2 +16];
	UNLINK;
	rts;


.align 2
.global _htab_elements;
.type _htab_elements, STT_FUNC;
_htab_elements:
	LINK 0;
	P2  =R0 ;
	R1  =[P2 +20];
	R0  =[P2 +24];
	R0  =R1 -R0 ;
	UNLINK;
	rts;


.align 2
.global _htab_collisions;
.type _htab_collisions, STT_FUNC;
_htab_collisions:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	R0  =[P5 +28];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$127;
	R2  = 0 (X);
	R3  = 0 (X);
	jump.s L$L$126;
L$L$127:
	R0  =[P5 +32];
	call ___floatsidf;
	R2  =R0 ;
	R3  =R1 ;
	P5  =[P5 +32];
	cc =P5 <0;
	if cc jump 6; jump.l L$L$128;
	R1  =R0 ;
	[SP +12] =R1 ;
	[SP +16] =R3 ;
	call ___adddf3;
	R2  =R0 ;
	R3  =R1 ;
L$L$128:
	[SP +12] =R2 ;
	[SP +16] =R3 ;
	call ___divdf3;
	R2  =R0 ;
	R3  =R1 ;
L$L$126:
	R0  =R2 ;
	R1  =R3 ;
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _htab_hash_string;
.type _htab_hash_string, STT_FUNC;
_htab_hash_string:
	LINK 4;
	R1  =R0 ;
	R2  = 0 (X);
	P2  =R0 ;
	R1 +=1;
	R3  = B [P2 ++] (X);
	R0  = R3.B  (Z);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$136;
L$L$134:
	R0  =R2 ;
	R0  <<=4;
	R0  = (R0  + R2 ) << 2;
	R2  =R0 -R2 ;
	R0  = R3.B  (Z);
	R2 =R2 +R0 ;
	R0  = -113 (X);
	R0 =R0 +R2 ; //immed->Dreg 
	R2  =R0 ;
	P2  =R1 ;
	R1 +=1;
	R3  = B [P2 ++] (X);
	R0  = R3.B  (Z);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$134;
L$L$136:
	R0  =R2 ;
	UNLINK;
	rts;


.align 2
.global _iterative_hash;
.type _iterative_hash, STT_FUNC;
_iterative_hash:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P2  =R0 ;
	P1  =R1 ;
	[FP +16] =R2 ;
	P0  =R1 ;
	R1.L  = 31161; R1.H  = -25033;
	R3  =R1 ;
	R0  = 3 (X);
	R6  =P2 ;
	R0  =R6 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$138;
	P5  = 11 (X);
	cc =P1 <=P5  (iu);
	if !cc jump 6; jump.l L$L$143;
L$L$142:
	R0  =[P2 ];
	R3 =R3 +R0 ;
	R0  =[P2 +4];
	R1 =R1 +R0 ;
	R0  =[P2 +8];
	R2 =R2 +R0 ;
	R3  =R3 -R1 ;
	R3  =R3 -R2 ;
	R0  =R2 ;
	R0  >>=13;
	R3  =R3 ^R0 ;
	R1  =R1 -R2 ;
	R1  =R1 -R3 ;
	R0  =R3 ;
	R0  <<=8;
	R1  =R1 ^R0 ;
	R2  =R2 -R3 ;
	R2  =R2 -R1 ;
	R0  =R1 ;
	R0  >>=13;
	R2  =R2 ^R0 ;
	R3  =R3 -R1 ;
	R3  =R3 -R2 ;
	R0  =R2 ;
	R0  >>=12;
	R3  =R3 ^R0 ;
	R1  =R1 -R2 ;
	R1  =R1 -R3 ;
	R0  =R3 ;
	R0  <<=16;
	R1  =R1 ^R0 ;
	R2  =R2 -R3 ;
	R2  =R2 -R1 ;
	R0  =R1 ;
	R0  >>=5;
	R2  =R2 ^R0 ;
	R3  =R3 -R1 ;
	R3  =R3 -R2 ;
	R0  =R2 ;
	R0  >>=3;
	R3  =R3 ^R0 ;
	R1  =R1 -R2 ;
	R1  =R1 -R3 ;
	R0  =R3 ;
	R0  <<=10;
	R1  =R1 ^R0 ;
	R2  =R2 -R3 ;
	R2  =R2 -R1 ;
	R0  =R1 ;
	R0  >>=15;
	R2  =R2 ^R0 ;
	P2 +=12;
	P0 +=-12;
	P5  = 11 (X);
	cc =P0 <=P5  (iu);
	if cc jump 6; jump.l L$L$142;
	jump.s L$L$143;
L$L$138:
	P5  = 11 (X);
	cc =P1 <=P5  (iu);
	if !cc jump 6; jump.l L$L$143;
L$L$147:
	R6  = B [P2 ] (Z);
	R0  = B [P2 +1] (Z);
	R0  <<=8;
	R6 =R6 +R0 ;
	R0  = B [P2 +2] (Z);
	R0  <<=16;
	R6 =R6 +R0 ;
	R0  = B [P2 +3] (X);
	R0  <<=24;
	R0 =R6 +R0 ;
	R3 =R3 +R0 ;
	R6  = B [P2 +4] (Z);
	R0  = B [P2 +5] (Z);
	R0  <<=8;
	R6 =R6 +R0 ;
	R0  = B [P2 +6] (Z);
	R0  <<=16;
	R6 =R6 +R0 ;
	R0  = B [P2 +7] (X);
	R0  <<=24;
	R0 =R6 +R0 ;
	R1 =R1 +R0 ;
	R6  = B [P2 +8] (Z);
	R0  = B [P2 +9] (Z);
	R0  <<=8;
	R6 =R6 +R0 ;
	R0  = B [P2 +10] (Z);
	R0  <<=16;
	R6 =R6 +R0 ;
	R0  = B [P2 +11] (X);
	R0  <<=24;
	R0 =R6 +R0 ;
	R2 =R2 +R0 ;
	R3  =R3 -R1 ;
	R3  =R3 -R2 ;
	R0  =R2 ;
	R0  >>=13;
	R3  =R3 ^R0 ;
	R1  =R1 -R2 ;
	R1  =R1 -R3 ;
	R0  =R3 ;
	R0  <<=8;
	R1  =R1 ^R0 ;
	R2  =R2 -R3 ;
	R2  =R2 -R1 ;
	R0  =R1 ;
	R0  >>=13;
	R2  =R2 ^R0 ;
	R3  =R3 -R1 ;
	R3  =R3 -R2 ;
	R0  =R2 ;
	R0  >>=12;
	R3  =R3 ^R0 ;
	R1  =R1 -R2 ;
	R1  =R1 -R3 ;
	R0  =R3 ;
	R0  <<=16;
	R1  =R1 ^R0 ;
	R2  =R2 -R3 ;
	R2  =R2 -R1 ;
	R0  =R1 ;
	R0  >>=5;
	R2  =R2 ^R0 ;
	R3  =R3 -R1 ;
	R3  =R3 -R2 ;
	R0  =R2 ;
	R0  >>=3;
	R3  =R3 ^R0 ;
	R1  =R1 -R2 ;
	R1  =R1 -R3 ;
	R0  =R3 ;
	R0  <<=10;
	R1  =R1 ^R0 ;
	R2  =R2 -R3 ;
	R2  =R2 -R1 ;
	R0  =R1 ;
	R0  >>=15;
	R2  =R2 ^R0 ;
	P2 +=12;
	P0 +=-12;
	P5  = 11 (X);
	cc =P0 <=P5  (iu);
	if cc jump 6; jump.l L$L$147;
L$L$143:
	R0  =P1 ;
	R2 =R2 +R0 ;
	P0 +=-1;
	P1  = 10 (X);
	cc = P0 <=P1  (iu);
if cc jump 6;
jump.l L$L$148;
P1.L =L$L$160;
P1.H =L$L$160;
P0  = P0 <<2;
P0  = P0 +P1 ;
P0  = [P0 ];
jump (P0 );

.align 2
.align 2
.align 2
L$L$160:
	.dd		L$L$159;
	.dd		L$L$158;
	.dd		L$L$157;
	.dd		L$L$156;
	.dd		L$L$155;
	.dd		L$L$154;
	.dd		L$L$153;
	.dd		L$L$152;
	.dd		L$L$151;
	.dd		L$L$150;
	.dd		L$L$149;
L$L$149:
	R0  = B [P2 +10] (X);
	R0  <<=24;
	R2 =R2 +R0 ;
L$L$150:
	R0  = B [P2 +9] (Z);
	R0  <<=16;
	R2 =R2 +R0 ;
L$L$151:
	R0  = B [P2 +8] (Z);
	R0  <<=8;
	R2 =R2 +R0 ;
L$L$152:
	R0  = B [P2 +7] (X);
	R0  <<=24;
	R1 =R1 +R0 ;
L$L$153:
	R0  = B [P2 +6] (Z);
	R0  <<=16;
	R1 =R1 +R0 ;
L$L$154:
	R0  = B [P2 +5] (Z);
	R0  <<=8;
	R1 =R1 +R0 ;
L$L$155:
	R0  = B [P2 +4] (Z);
	R1 =R1 +R0 ;
L$L$156:
	R0  = B [P2 +3] (X);
	R0  <<=24;
	R3 =R3 +R0 ;
L$L$157:
	R0  = B [P2 +2] (Z);
	R0  <<=16;
	R3 =R3 +R0 ;
L$L$158:
	R0  = B [P2 +1] (Z);
	R0  <<=8;
	R3 =R3 +R0 ;
L$L$159:
	R6  = B [P2 ] (Z);
	R3 =R3 +R6 ;
L$L$148:
	R3  =R3 -R1 ;
	R3  =R3 -R2 ;
	R0  =R2 ;
	R0  >>=13;
	R3  =R3 ^R0 ;
	R1  =R1 -R2 ;
	R1  =R1 -R3 ;
	R0  =R3 ;
	R0  <<=8;
	R1  =R1 ^R0 ;
	R2  =R2 -R3 ;
	R2  =R2 -R1 ;
	R0  =R1 ;
	R0  >>=13;
	R2  =R2 ^R0 ;
	R3  =R3 -R1 ;
	R3  =R3 -R2 ;
	R0  =R2 ;
	R0  >>=12;
	R3  =R3 ^R0 ;
	R1  =R1 -R2 ;
	R1  =R1 -R3 ;
	R0  =R3 ;
	R0  <<=16;
	R1  =R1 ^R0 ;
	R2  =R2 -R3 ;
	R2  =R2 -R1 ;
	R0  =R1 ;
	R0  >>=5;
	R2  =R2 ^R0 ;
	R3  =R3 -R1 ;
	R3  =R3 -R2 ;
	R0  =R2 ;
	R0  >>=3;
	R3  =R3 ^R0 ;
	R1  =R1 -R2 ;
	R1  =R1 -R3 ;
	R0  =R3 ;
	R0  <<=10;
	R1  =R1 ^R0 ;
	R2  =R2 -R3 ;
	R2  =R2 -R1 ;
	R1  >>=15;
	R2  =R2 ^R1 ;
	R0  =R2 ;
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


