// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "fibheap.i";
.text;
.align 2
.global _fibheap_new;
.type _fibheap_new, STT_FUNC;
_fibheap_new:
	LINK 0;
	R0  = 1 (X);
	R1  = 12 (X);
	call _xcalloc;
	UNLINK;
	rts;


.align 2
.type _fibnode_new, STT_FUNC;
_fibnode_new:
	LINK 0;
	R0  = 1 (X);
	R1  = 28 (X);
	call _xcalloc;
	P2  =R0 ;
	[P2 +8] =R0 ;
	[P2 +12] =R0 ;
	UNLINK;
	rts;


.align 2
.global _fibheap_insert;
.type _fibheap_insert, STT_FUNC;
_fibheap_insert:
	LINK 0;
	[--sp] = ( r7:5, p5:4 );
	P4  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	call _fibnode_new;
	P5  =R0 ;
	[P5 +20] =R6 ;
	[P5 +16] =R5 ;
	R0  =P4 ;
	R1  =P5 ;
	call _fibheap_ins_root;
	P2  =[P4 +4];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$5;
	R0  =[P5 +16];
	P2  =[P2 +16];
	R1  =P2 ;
	cc =R0 <R1 ;
	if cc jump 6; jump.l L$L$4;
L$L$5:
	[P4 +4] =P5 ;
L$L$4:
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	R0  =P5 ;
	( r7:5, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _fibheap_min;
.type _fibheap_min, STT_FUNC;
_fibheap_min:
	LINK 0;
	P2  =R0 ;
	R1  =[P2 +4];
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$6;
	P2  =R1 ;
	R0  =[P2 +20];
L$L$6:
	UNLINK;
	rts;


.align 2
.global _fibheap_min_key;
.type _fibheap_min_key, STT_FUNC;
_fibheap_min_key:
	LINK 0;
	P2  =R0 ;
	R1  =[P2 +4];
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$8;
	P2  =R1 ;
	R0  =[P2 +16];
L$L$8:
	UNLINK;
	rts;


.align 2
.global _fibheap_union;
.type _fibheap_union, STT_FUNC;
_fibheap_union:
	LINK 0;
	[--sp] = ( p5:3 );
	P4  =R0 ;
	P5  =R1 ;
	P3  =[P4 +8];
	cc =P3 ==0;
	if cc jump 6; jump.l L$L$11;
	call _free;
	R0  =P5 ;
	jump.s L$L$10;
L$L$11:
	P0  =[P5 +8];
	cc =P0 ==0;
	if !cc jump 6; jump.l L$L$13;
	P1  =[P3 +8];
	[P1 +12] =P0 ;
	P2  =[P0 +8];
	[P2 +12] =P3 ;
	[P3 +8] =P2 ;
	[P0 +8] =P1 ;
	R1  =[P4 ];
	R0  =[P5 ];
	R0 =R1 +R0 ;
	[P4 ] =R0 ;
	P1  =[P5 +4];
	P2  =[P4 +4];
	R2  =[P1 +16];
	R0  =[P2 +16];
	R1  = -1 (X);
	cc =R2 <R0 ;
	if !cc jump 6; jump.l L$L$15;
	P1  =R2 ;
	P2  =R0 ;
	R0  = 0 (X);
	R1  = 1 (X);
	cc =P1 <=P2 ;
	if cc R1  =R0 ; /* movsicc-2a */
L$L$15:
	cc =R1 <0;
	if cc jump 6; jump.l L$L$13;
	R0  =[P5 +4];
	[P4 +4] =R0 ;
L$L$13:
	R0  =P5 ;
	call _free;
	R0  =P4 ;
L$L$10:
	( p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _fibheap_extract_min;
.type _fibheap_extract_min, STT_FUNC;
_fibheap_extract_min:
	LINK 0;
	[--sp] = ( r7:6 );
	R6  = 0 (X);
	P2  =R0 ;
	R1  =[P2 +4];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$18;
	call _fibheap_extr_min_node;
	P2  =R0 ;
	R6  =[P2 +20];
	call _free;
L$L$18:
	R0  =R6 ;
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _fibheap_replace_key_data;
.type _fibheap_replace_key_data, STT_FUNC;
_fibheap_replace_key_data:
	LINK 28;
	[--sp] = ( r7:6, p5:3 );
	P4  =R0 ;
	P5  =R1 ;
	[FP +16] =R2 ;
	P1  =R2 ;
	R3  =[FP +20];
	[FP +-12] =R2 ;
	[FP +-8] =R3 ;
	P2  = -28 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =[P5 +16];
	R2  = -1 (X);
	R1  =P1 ;
	cc =R1 <R0 ;
	if !cc jump 6; jump.l L$L$22;
	P2  =[P2 +16];
	R1  =R0 ;
	R0  = 0 (X);
	R2  = 1 (X);
	R6  =P2 ;
	cc =R6 <=R1 ;
	if cc R2  =R0 ; /* movsicc-2a */
L$L$22:
	R6  = 0 (X);
	cc =R2 <=0;
	if cc jump 6; jump.l L$L$19;
	R6  =[P5 +20];
	R0  =[P5 +16];
	[P5 +20] =R3 ;
	[P5 +16] =P1 ;
	P3  =[P5 ];
	R1  =P1 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$19;
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$26;
	R0  =[P3 +16];
	R3  = -1 (X);
	cc =R1 <R0 ;
	if !cc jump 6; jump.l L$L$28;
	R2  =P1 ;
	R1  =R0 ;
	R0  = 0 (X);
	R3  = 1 (X);
	cc =R2 <=R1 ;
	if cc R3  =R0 ; /* movsicc-2a */
L$L$28:
	cc =R3 <=0;
	if cc jump 6; jump.l L$L$26;
	R2  =P3 ;
	R0  =P4 ;
	R1  =P5 ;
	call _fibheap_cut;
	R0  =P4 ;
	R1  =P3 ;
	call _fibheap_cascading_cut;
L$L$26:
	P2  =[P4 +4];
	R1  =[P5 +16];
	R0  =[P2 +16];
	R2  = -1 (X);
	cc =R1 <R0 ;
	if !cc jump 6; jump.l L$L$32;
	P2  =R0 ;
	R0  = 0 (X);
	R2  = 1 (X);
	R3  =P2 ;
	cc =R1 <=R3 ;
	if cc R2  =R0 ; /* movsicc-2a */
L$L$32:
	cc =R2 <=0;
	if cc jump 6; jump.l L$L$19;
	[P4 +4] =P5 ;
L$L$19:
	R0  =R6 ;
	( r7:6, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _fibheap_replace_data;
.type _fibheap_replace_data, STT_FUNC;
_fibheap_replace_data:
	LINK 0;
	[FP +16] =R2 ;
	P2  =R1 ;
	R2  =[P2 +16];
	R3  =[FP +16];
	[SP +12] =R3 ;
	call _fibheap_replace_key_data;
	UNLINK;
	rts;


.align 2
.global _fibheap_replace_key;
.type _fibheap_replace_key, STT_FUNC;
_fibheap_replace_key:
	LINK 0;
	[--sp] = ( r7:6 );
	[FP +16] =R2 ;
	P2  =R1 ;
	R6  =[P2 +16];
	R3  =[P2 +20];
	[SP +12] =R3 ;
	call _fibheap_replace_key_data;
	R0  =R6 ;
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _fibheap_delete_node;
.type _fibheap_delete_node, STT_FUNC;
_fibheap_delete_node:
	LINK 0;
	[--sp] = ( r7:5 );
	R5  =R0 ;
	P2  =R1 ;
	R6  =[P2 +20];
	R2  = -1 (X); R2  <<= 31; // zeros
	call _fibheap_replace_key;
	R0  =R5 ;
	call _fibheap_extract_min;
	R0  =R6 ;
	( r7:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _fibheap_delete;
.type _fibheap_delete, STT_FUNC;
_fibheap_delete:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	R0  =[P5 +4];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$43;
L$L$41:
	R0  =P5 ;
	call _fibheap_extr_min_node;
	call _free;
	R0  =[P5 +4];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
L$L$43:
	R0  =P5 ;
	call _free;
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _fibheap_empty;
.type _fibheap_empty, STT_FUNC;
_fibheap_empty:
	LINK 0;
	P2  =R0 ;
	R0  =[P2 ];
	cc =R0 ==0;
	R0  =CC ;
	UNLINK;
	rts;


.align 2
.type _fibheap_extr_min_node, STT_FUNC;
_fibheap_extr_min_node:
	LINK 0;
	[--sp] = ( r7:5, p5:4 );
	P4  =R0 ;
	P5  =[P4 +4];
	R1  =[P5 +4];
	R5  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$47;
L$L$52:
	cc =R5 ==0;
	if cc R5  =R1 ; /* movsicc-1b */
	P2  =R1 ;
	R6  =[P2 +12];
	R0  = 0 (X);
	[P2 ] =R0 ;
	R0  =P4 ;
	call _fibheap_ins_root;
	R1  =R6 ;
	cc =R6 ==R5 ;
	if !cc jump 6; jump.l L$L$47;
	cc =R6 ==0;
	if cc jump 6; jump.l L$L$52;
L$L$47:
	R0  =P4 ;
	R1  =P5 ;
	call _fibheap_rem_root;
	R0  =[P4 ];
	R0 +=-1;
	[P4 ] =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$53;
	P2  = 0 (X);
	[P4 +4] =P2 ;
	jump.s L$L$54;
L$L$53:
	R0  =[P5 +12];
	[P4 +4] =R0 ;
	R0  =P4 ;
	call _fibheap_consolidate;
L$L$54:
	R0  =P5 ;
	( r7:5, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _fibheap_ins_root, STT_FUNC;
_fibheap_ins_root:
	LINK 0;
	P2  =R0 ;
	R2  =[P2 +8];
	cc =R2 ==0;
	if cc jump 6; jump.l L$L$57;
	[P2 +8] =R1 ;
	P2  =R1 ;
	[P2 +8] =R1 ;
	[P2 +12] =R1 ;
	jump.s L$L$56;
L$L$57:
	P2  =R0 ;
	R0  =[P2 +8];
	call _fibnode_insert_after;
L$L$56:
	UNLINK;
	rts;


.align 2
.type _fibheap_rem_root, STT_FUNC;
_fibheap_rem_root:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	P2  =R1 ;
	R0  =[P2 +8];
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$59;
	R0  = 0 (X);
	jump.s L$L$61;
L$L$59:
	R0  =R1 ;
	call _fibnode_remove;
L$L$61:
	[P5 +8] =R0 ;
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _fibheap_consolidate, STT_FUNC;
_fibheap_consolidate:
	LINK 132;
	[--sp] = ( r7:6, p5:3 );
	P4  =R0 ;
	R6  = 33 (X);
	R1  = 132 (X);
	R2  =FP ;
	R0  = -132 (X);
	R0 =R0 +R2 ; //immed->Dreg 
	call _bzero;
	P3  =[P4 +8];
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$87;
L$L$74:
	R0  =P4 ;
	R1  =P3 ;
	call _fibheap_rem_root;
	P5  =[P3 +24];
	R0  =P5 ;
	BITCLR (R0 ,31);
	P5  =R0 ;
	P1  =P5 <<2;
	P2 =P1 +FP ;
	P2  =[P2 +-132];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$89;
L$L$73:
	P1 =P1 +FP ;
	R1  =[P1 +-132];
	R2  =[P3 +16];
	P2  =R1 ;
	R0  =[P2 +16];
	P2  = -1 (X);
	cc =R2 <R0 ;
	if !cc jump 6; jump.l L$L$71;
	R3  =R2 ;
	R2  =R0 ;
	R0  = 0 (X);
	P2  = 1 (X);
	cc =R3 <=R2 ;
	if cc P2  =R0 ; /* movsicc-2a */
L$L$71:
	cc =P2 <=0;
	if !cc jump 6; jump.l L$L$69;
	R0  =P3 ;
	P3  =R1 ;
	R1  =R0 ;
L$L$69:
	R2  =P3 ;
	R0  =P4 ;
	call _fibheap_link;
	P2  =FP +(P5 <<2);
	R0  = 0 (X);
	[P2 +-132] =R0 ;
	P5 +=1;
	P1  =P5 <<2;
	P2 =P1 +FP ;
	P2  =[P2 +-132];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$73;
L$L$89:
	P5  =FP +(P5 <<2);
	[P5 +-132] =P3 ;
	P3  =[P4 +8];
	cc =P3 ==0;
	if cc jump 6; jump.l L$L$74;
L$L$87:
	R2  = 0 (X);
	[P4 +4] =R2 ;
	P5  = 0 (X);
	R0  =P5 ;
	cc =R0 <R6 ;
	if cc jump 6; jump.l L$L$91;
L$L$85:
	P3  =FP +(P5 <<2);
	P2  = -132 (X);
	P2 =P2 +P3 ; //immed->Preg 
	P3  =P2 ;
	R1  =[P2 ];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$77;
	R0  =P4 ;
	call _fibheap_ins_root;
	R3  =[P4 +4];
	cc =R3 ==0;
	if !cc jump 6; jump.l L$L$81;
	P3  =[P3 ];
	R2  =[P3 +16];
	P2  =R3 ;
	R0  =[P2 +16];
	R1  = -1 (X);
	cc =R2 <R0 ;
	if !cc jump 6; jump.l L$L$83;
	R3  =R0 ;
	R0  = 0 (X);
	R1  = 1 (X);
	cc =R2 <=R3 ;
	if cc R1  =R0 ; /* movsicc-2a */
L$L$83:
	cc =R1 <0;
	if cc jump 6; jump.l L$L$77;
L$L$81:
	P2  =FP +(P5 <<2);
	P2  =[P2 +-132];
	[P4 +4] =P2 ;
L$L$77:
	P5 +=1;
	R0  =P5 ;
	cc =R0 <R6 ;
	if !cc jump 6; jump.l L$L$85;
L$L$91:
	( r7:6, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _fibheap_link, STT_FUNC;
_fibheap_link:
	LINK 0;
	[--sp] = ( p5:4 );
	P4  =R1 ;
	[FP +16] =R2 ;
	P5  =R2 ;
	R0  =[P5 +4];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$93;
	[P5 +4] =R1 ;
	jump.s L$L$94;
L$L$93:
	P2  =[P5 +4];
	P2  =[P2 +8];
	R0  =P2 ;
	call _fibnode_insert_after;
L$L$94:
	[P4 ] =P5 ;
	R1  =[P5 +24];
	R0  =R1 ;
	BITCLR (R0 ,31);
	R0 +=1;
	BITCLR (R0 ,31);
	R1  >>>=31;
	R1  <<=31;
	R1  =R1 |R0 ;
	[P5 +24] =R1 ;
	R0  = 127 (X);
	R1  = B [P4 +27] (X);
	R0  =R0 &R1 ;
	B [P4 +27] =R0 ;
	( p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _fibheap_cut, STT_FUNC;
_fibheap_cut:
	LINK 0;
	[--sp] = ( r7:6, p5:4 );
	R6  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	P5  =R2 ;
	R0  =R1 ;
	call _fibnode_remove;
	R1  =[P5 +24];
	R0  =R1 ;
	BITCLR (R0 ,31);
	R0 +=-1;
	BITCLR (R0 ,31);
	R1  >>>=31;
	R1  <<=31;
	R1  =R1 |R0 ;
	[P5 +24] =R1 ;
	R0  =R6 ;
	R1  =P4 ;
	call _fibheap_ins_root;
	R0  = 0 (X);
	[P4 ] =R0 ;
	R0  = 127 (X);
	R1  = B [P4 +27] (X);
	R0  =R0 &R1 ;
	B [P4 +27] =R0 ;
	( r7:6, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _fibheap_cascading_cut, STT_FUNC;
_fibheap_cascading_cut:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	R5  =R0 ;
	P2  =R1 ;
	P5  =[P2 ];
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$96;
	R6  = -128 (X);
L$L$102:
	P2  =R1 ;
	R0  = B [P2 +27] (Z);
	R0  >>=7;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$100;
	R0  = B [P2 +27] (X);
	R6  =R6 |R0 ;
	B [P2 +27] =R6 ;
	jump.s L$L$96;
L$L$100:
	R2  =P5 ;
	R0  =R5 ;
	call _fibheap_cut;
	R1  =P5 ;
	P5  =[P5 ];
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$102;
L$L$96:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _fibnode_insert_after, STT_FUNC;
_fibnode_insert_after:
	LINK 0;
	P1  =R0 ;
	R2  =[P1 +12];
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$105;
	[P1 +12] =R1 ;
	[P1 +8] =R1 ;
	P2  =R1 ;
	[P2 +12] =R0 ;
	jump.s L$L$107;
L$L$105:
	P1  =R0 ;
	P2  =[P1 +12];
	P1  =R1 ;
	[P1 +12] =P2 ;
	P1  =R0 ;
	P2  =[P1 +12];
	[P2 +8] =R1 ;
	[P1 +12] =R1 ;
	P2  =R1 ;
L$L$107:
	[P2 +8] =R0 ;
	UNLINK;
	rts;


.align 2
.type _fibnode_remove, STT_FUNC;
_fibnode_remove:
	LINK 0;
	P0  =R0 ;
	R1  =[P0 +8];
	R0  = 0 (X);
	R2  =P0 ;
	cc =R2 ==R1 ;
	if !cc jump 6; jump.l L$L$110;
	R0  =R1 ;
L$L$110:
	P2  =[P0 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$111;
	R1  =[P2 +4];
	R2  =P0 ;
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$111;
	[P2 +4] =R0 ;
L$L$111:
	P1  =[P0 +12];
	R1  =[P0 +8];
	[P1 +8] =R1 ;
	P2  =[P0 +8];
	[P2 +12] =P1 ;
	R2  = 0 (X);
	[P0 ] =R2 ;
	[P0 +8] =P0 ;
	[P0 +12] =P0 ;
	UNLINK;
	rts;


