// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "splay-tree.i";
.text;
.align 2
.type _splay_tree_delete_helper, STT_FUNC;
_splay_tree_delete_helper:
	LINK 0;
	[--sp] = ( p5:4 );
	P5  =R0 ;
	P4  =R1 ;
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$1;
	R1  =[P4 +8];
	call _splay_tree_delete_helper;
	R1  =[P4 +12];
	R0  =P5 ;
	call _splay_tree_delete_helper;
	P2  =[P5 +8];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$3;
	R0  =[P4 ];
	call (P2 );
L$L$3:
	P2  =[P5 +12];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$4;
	R0  =[P4 +4];
	call (P2 );
L$L$4:
	R1  =[P5 +24];
	P5  =[P5 +20];
	R0  =P4 ;
	call (P5 );
L$L$1:
	( p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _splay_tree_splay_helper, STT_FUNC;
_splay_tree_splay_helper:
	LINK 0;
	[--sp] = ( r7:4, p5:3 );
	R4  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	P3  =R2 ;
	P4  =[FP +20];
	P5  =[FP +24];
	R6  =[P3 ];
	cc =R6 ==0;
	if cc jump 6; jump.l L$L$6;
	R6  =[P4 ];
	jump.s L$L$5;
L$L$6:
	P1  =R0 ;
	P2  =[P1 +4];
	R0  =R1 ;
	P1  =R6 ;
	R1  =[P1 ];
	call (P2 );
	R1  =R0 ;
	R2  = 0 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$8;
	R2  = 8 (X);
	R2 =R2 +R6 ; //immed->Dreg 
	R0  = 12 (X);
	R0 =R0 +R6 ; //immed->Dreg 
	cc =R1 <0;
	if !cc R2  =R0 ; /* movsicc-1a */
L$L$8:
	cc =R2 ==0;
	if !cc jump 6; jump.l L$L$11;
	[SP +12] =P3 ;
	[SP +16] =P4 ;
	R0  =R4 ;
	R1  =R5 ;
	call _splay_tree_splay_helper;
	R6  =R0 ;
	R0  =[P3 ];
	cc =R0 ==R6 ;
	if cc jump 6; jump.l L$L$5;
L$L$11:
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$5;
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$14;
	P2  =[P4 ];
	P2  =[P2 +8];
	R0  =P2 ;
	cc =R6 ==R0 ;
	if cc jump 6; jump.l L$L$15;
	P1  =R6 ;
	P1  =[P1 +12];
	[P3 ] =P1 ;
	R0  =[P4 ];
	P2  =R6 ;
	[P2 +12] =R0 ;
	jump.s L$L$16;
L$L$15:
	P1  =R6 ;
	P1  =[P1 +8];
	[P3 ] =P1 ;
	R0  =[P4 ];
	P2  =R6 ;
	[P2 +8] =R0 ;
L$L$16:
	[P4 ] =R6 ;
	jump.s L$L$5;
L$L$14:
	P1  =[P4 ];
	R0  =[P1 +8];
	cc =R6 ==R0 ;
	if cc jump 6; jump.l L$L$17;
	P2  =[P5 ];
	R0  =[P2 +8];
	R1  =P1 ;
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$17;
	R0  =[P1 +12];
	[P2 +8] =R0 ;
	R1  =[P5 ];
	[P1 +12] =R1 ;
	P2  =R6 ;
	P2  =[P2 +12];
	[P1 +8] =P2 ;
	P2  =R6 ;
	[P2 +12] =P1 ;
	jump.s L$L$22;
L$L$17:
	P1  =[P4 ];
	R0  =[P1 +12];
	cc =R6 ==R0 ;
	if cc jump 6; jump.l L$L$18;
	P2  =[P5 ];
	R0  =[P2 +12];
	R1  =P1 ;
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$18;
	R0  =[P1 +8];
	[P2 +12] =R0 ;
	R1  =[P5 ];
	[P1 +8] =R1 ;
	P2  =R6 ;
	P2  =[P2 +8];
	[P1 +12] =P2 ;
	P2  =R6 ;
	[P2 +8] =P1 ;
	jump.s L$L$22;
L$L$18:
	P2  =[P4 ];
	R0  =[P2 +8];
	cc =R6 ==R0 ;
	if cc jump 6; jump.l L$L$20;
	P1  =R6 ;
	P1  =[P1 +12];
	[P2 +8] =P1 ;
	P4  =[P4 ];
	P2  =R6 ;
	[P2 +12] =P4 ;
	P2  =[P5 ];
	P1  =R6 ;
	P1  =[P1 +8];
	[P2 +12] =P1 ;
	R0  =[P5 ];
	P2  =R6 ;
	[P2 +8] =R0 ;
	jump.s L$L$22;
L$L$20:
	P2  =[P4 ];
	P1  =R6 ;
	P1  =[P1 +8];
	[P2 +12] =P1 ;
	P4  =[P4 ];
	P2  =R6 ;
	[P2 +8] =P4 ;
	P2  =[P5 ];
	P1  =R6 ;
	P1  =[P1 +12];
	[P2 +8] =P1 ;
	R0  =[P5 ];
	P2  =R6 ;
	[P2 +12] =R0 ;
L$L$22:
	[P5 ] =R6 ;
L$L$5:
	R0  =R6 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _splay_tree_splay, STT_FUNC;
_splay_tree_splay:
	LINK 0;
	P2  =R0 ;
	R2  =[P2 ];
	cc =R2 ==0;
	if !cc jump 6; jump.l L$L$23;
	R2  = 0 (X);
	[SP +12] =R2 ;
	[SP +16] =R2 ;
	R2  =R0 ;
	call _splay_tree_splay_helper;
L$L$23:
	UNLINK;
	rts;


.align 2
.type _splay_tree_foreach_helper, STT_FUNC;
_splay_tree_foreach_helper:
	LINK 0;
	[--sp] = ( r7:5, p5:4 );
	R5  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	P5  =R2 ;
	R6  =[FP +20];
	R0  = 0 (X);
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$25;
	R1  =[P4 +8];
	[SP +12] =R6 ;
	R0  =R5 ;
	call _splay_tree_foreach_helper;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$25;
	R0  =P4 ;
	R1  =R6 ;
	call (P5 );
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$25;
	P4  =[P4 +12];
	[SP +12] =R6 ;
	R2  =P5 ;
	R0  =R5 ;
	R1  =P4 ;
	call _splay_tree_foreach_helper;
L$L$25:
	( r7:5, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _splay_tree_xmalloc_allocate, STT_FUNC;
_splay_tree_xmalloc_allocate:
	LINK 0;
	call _xmalloc;
	UNLINK;
	rts;


.align 2
.type _splay_tree_xmalloc_deallocate, STT_FUNC;
_splay_tree_xmalloc_deallocate:
	LINK 0;
	call _free;
	UNLINK;
	rts;


.align 2
.global _splay_tree_new;
.type _splay_tree_new, STT_FUNC;
_splay_tree_new:
	LINK 0;
	[FP +16] =R2 ;
	R3.L  = _splay_tree_xmalloc_allocate; R3.H  = _splay_tree_xmalloc_allocate;
	[SP +12] =R3 ;
	R3.L  = _splay_tree_xmalloc_deallocate; R3.H  = _splay_tree_xmalloc_deallocate;
	[SP +16] =R3 ;
	R3  = 0 (X);
	[SP +20] =R3 ;
	call _splay_tree_new_with_allocator;
	UNLINK;
	rts;


.align 2
.global _splay_tree_new_with_allocator;
.type _splay_tree_new_with_allocator, STT_FUNC;
_splay_tree_new_with_allocator:
	LINK 0;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	R4  =R2 ;
	P5  =[FP +20];
	R5  =[FP +24];
	R6  =[FP +28];
	R0  = 28 (X);
	R1  =R6 ;
	call (P5 );
	P2  =R0 ;
	R0  = 0 (X);
	[P2 ] =R0 ;
	[P2 +4] =P3 ;
	[P2 +8] =P4 ;
	[P2 +12] =R4 ;
	[P2 +16] =P5 ;
	[P2 +20] =R5 ;
	[P2 +24] =R6 ;
	R0  =P2 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _splay_tree_delete;
.type _splay_tree_delete, STT_FUNC;
_splay_tree_delete:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	R1  =[P5 ];
	call _splay_tree_delete_helper;
	R1  =[P5 +24];
	P2  =[P5 +20];
	R0  =P5 ;
	call (P2 );
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _splay_tree_insert;
.type _splay_tree_insert, STT_FUNC;
_splay_tree_insert:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	P5  =R0 ;
	R4  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R5  = 0 (X);
	call _splay_tree_splay;
	P1  =[P5 ];
	cc =P1 ==0;
	if !cc jump 6; jump.l L$L$35;
	P2  =[P5 +4];
	R0  =[P1 ];
	R1  =R4 ;
	call (P2 );
	R5  =R0 ;
L$L$35:
	P1  =[P5 ];
	cc =P1 ==0;
	if !cc jump 6; jump.l L$L$36;
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$36;
	P2  =[P5 +12];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$37;
	R0  =[P1 +4];
	call (P2 );
L$L$37:
	P2  =[P5 ];
	[P2 +4] =R6 ;
	jump.s L$L$38;
L$L$36:
	R1  =[P5 +24];
	P2  =[P5 +16];
	R0  = 16 (X);
	call (P2 );
	P1  =R0 ;
	[P1 ] =R4 ;
	[P1 +4] =R6 ;
	R1  =[P5 ];
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$39;
	P2  = 0 (X);
	[P1 +12] =P2 ;
	[P1 +8] =P2 ;
	jump.s L$L$40;
L$L$39:
	cc =R5 <0;
	if cc jump 6; jump.l L$L$41;
	P2  =[P5 ];
	P1  =R0 ;
	[P1 +8] =P2 ;
	R1  =[P2 +12];
	[P1 +12] =R1 ;
	P1  = 0 (X);
	[P2 +12] =P1 ;
	jump.s L$L$40;
L$L$41:
	P2  =[P5 ];
	P1  =R0 ;
	[P1 +12] =P2 ;
	R1  =[P2 +8];
	[P1 +8] =R1 ;
	P1  = 0 (X);
	[P2 +8] =P1 ;
L$L$40:
	[P5 ] =R0 ;
L$L$38:
	R0  =[P5 ];
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _splay_tree_remove;
.type _splay_tree_remove, STT_FUNC;
_splay_tree_remove:
	LINK 0;
	[--sp] = ( r7:6, p5:4 );
	P4  =R0 ;
	R6  =R1 ;
	call _splay_tree_splay;
	P1  =[P4 ];
	cc =P1 ==0;
	if !cc jump 6; jump.l L$L$43;
	P2  =[P4 +4];
	R0  =[P1 ];
	R1  =R6 ;
	call (P2 );
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$43;
	P1  =[P4 ];
	P5  =[P1 +8];
	R6  =[P1 +12];
	P2  =[P4 +12];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$45;
	R0  =[P1 +4];
	call (P2 );
L$L$45:
	R1  =[P4 +24];
	P2  =[P4 +20];
	R0  =[P4 ];
	call (P2 );
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$46;
	[P4 ] =P5 ;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$43;
	R0  =[P5 +12];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$54;
L$L$51:
	P5  =[P5 +12];
	R0  =[P5 +12];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$51;
L$L$54:
	[P5 +12] =R6 ;
	jump.s L$L$43;
L$L$46:
	[P4 ] =R6 ;
L$L$43:
	( r7:6, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _splay_tree_lookup;
.type _splay_tree_lookup, STT_FUNC;
_splay_tree_lookup:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R6  =R1 ;
	call _splay_tree_splay;
	P1  =[P5 ];
	cc =P1 ==0;
	if !cc jump 6; jump.l L$L$56;
	P2  =[P5 +4];
	R0  =[P1 ];
	R1  =R6 ;
	call (P2 );
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$56;
	R0  =[P5 ];
	jump.s L$L$55;
L$L$56:
	R0  = 0 (X);
L$L$55:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _splay_tree_max;
.type _splay_tree_max, STT_FUNC;
_splay_tree_max:
	LINK 0;
	P1  =R0 ;
	P2  =[P1 ];
	R0  = 0 (X);
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$58;
	R0  =[P2 +12];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$65;
L$L$63:
	P2  =[P2 +12];
	R0  =[P2 +12];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$63;
L$L$65:
	R0  =P2 ;
L$L$58:
	UNLINK;
	rts;


.align 2
.global _splay_tree_min;
.type _splay_tree_min, STT_FUNC;
_splay_tree_min:
	LINK 0;
	P1  =R0 ;
	P2  =[P1 ];
	R0  = 0 (X);
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$66;
	R0  =[P2 +8];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$73;
L$L$71:
	P2  =[P2 +8];
	R0  =[P2 +8];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$71;
L$L$73:
	R0  =P2 ;
L$L$66:
	UNLINK;
	rts;


.align 2
.global _splay_tree_predecessor;
.type _splay_tree_predecessor, STT_FUNC;
_splay_tree_predecessor:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R6  =R1 ;
	R1  =[P5 ];
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$74;
	R0  =P5 ;
	R1  =R6 ;
	call _splay_tree_splay;
	P1  =[P5 ];
	P2  =[P5 +4];
	R0  =[P1 ];
	R1  =R6 ;
	call (P2 );
	cc =R0 <0;
	if cc jump 6; jump.l L$L$76;
	R0  =[P5 ];
	jump.s L$L$74;
L$L$76:
	P5  =[P5 ];
	R0  =[P5 +8];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$74;
	P2  =R0 ;
	R1  =[P2 +12];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$74;
L$L$81:
	P2  =R0 ;
	R0  =[P2 +12];
	P2  =R0 ;
	R1  =[P2 +12];
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$81;
L$L$74:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _splay_tree_successor;
.type _splay_tree_successor, STT_FUNC;
_splay_tree_successor:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R6  =R1 ;
	R1  =[P5 ];
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$83;
	R0  =P5 ;
	R1  =R6 ;
	call _splay_tree_splay;
	P1  =[P5 ];
	P2  =[P5 +4];
	R0  =[P1 ];
	R1  =R6 ;
	call (P2 );
	cc =R0 <=0;
	if !cc jump 6; jump.l L$L$85;
	R0  =[P5 ];
	jump.s L$L$83;
L$L$85:
	P5  =[P5 ];
	R0  =[P5 +12];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$83;
	P2  =R0 ;
	R1  =[P2 +8];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$83;
L$L$90:
	P2  =R0 ;
	R0  =[P2 +8];
	P2  =R0 ;
	R1  =[P2 +8];
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$90;
L$L$83:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _splay_tree_foreach;
.type _splay_tree_foreach, STT_FUNC;
_splay_tree_foreach:
	LINK 0;
	[FP +16] =R2 ;
	[SP +12] =R2 ;
	R2  =R1 ;
	P2  =R0 ;
	R1  =[P2 ];
	call _splay_tree_foreach_helper;
	UNLINK;
	rts;


.align 2
.global _splay_tree_compare_ints;
.type _splay_tree_compare_ints, STT_FUNC;
_splay_tree_compare_ints:
	LINK 0;
	R3  =R0 ;
	R0  = -1 (X);
	cc =R3 <R1 ;
	if !cc jump 6; jump.l L$L$93;
	R2  = 0 (X);
	R0  = 1 (X);
	cc =R3 <=R1 ;
	if cc R0  =R2 ; /* movsicc-2a */
L$L$93:
	UNLINK;
	rts;


.align 2
.global _splay_tree_compare_pointers;
.type _splay_tree_compare_pointers, STT_FUNC;
_splay_tree_compare_pointers:
	LINK 0;
	R3  =R0 ;
	R0  = -1 (X);
	cc =R3 <R1  (iu);
	if !cc jump 6; jump.l L$L$98;
	R2  = 0 (X);
	R0  = 1 (X);
	cc =R3 <=R1  (iu);
	if cc R0  =R2 ; /* movsicc-2a */
L$L$98:
	UNLINK;
	rts;


