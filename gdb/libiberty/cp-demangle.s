// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "cp-demangle.i";
.text;
.align 2
L$LC$0:
.dw	0x6c41;
.dw	0x6f6c;
.dw	0x6163;
.dw	0x6974;
.dw	0x6e6f;
.dw	0x6620;
.dw	0x6961;
.dw	0x656c;
.dw	0x2e64;
.db	0x00;
.align 2
_status_allocation_failed:	.long	L$LC$0
.align 2
.type _int_to_dyn_string, STT_FUNC;
_int_to_dyn_string:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	R4  =R0 ;
	R5  =R1 ;
	P5  = 1 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$2;
	R0  =R1 ;
	R1  = 48 (X);
	call _dyn_string_append_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1;
	jump.s L$L$19;
L$L$2:
	cc =R0 <0;
	if cc jump 6; jump.l L$L$4;
	R0  =R1 ;
	R1  = 45 (X);
	call _dyn_string_append_char;
	R4  =-R4 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$4;
L$L$19:
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$1;
L$L$4:
	R0  =R4 ;
	R1  = 9 (X);
	cc =R4 <=R1 ;
	if !cc jump 6; jump.l L$L$16;
L$L$9:
	P5  =P5 +(P5 <<2);
	P5  =P5 +P5 ;
	R1  = 10 (X);
	call ___divsi3;
	R1  = 9 (X);
	cc =R0 <=R1 ;
	if cc jump 6; jump.l L$L$9;
L$L$16:
	cc =P5 <=0;
	if !cc jump 6; jump.l L$L$18;
L$L$14:
	R0  =R4 ;
	R1  =P5 ;
	call ___divsi3;
	R6  =R0 ;
	R1  = 48 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R0  =R5 ;
	call _dyn_string_append_char;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$19;
	R0  =P5 ;
	R6  *=R0 ;
	R4  =R4 -R6 ;
	R1  = 10 (X);
	call ___divsi3;
	P5  =R0 ;
	cc =P5 <=0;
	if cc jump 6; jump.l L$L$14;
L$L$18:
	R0  = 0 (X);
L$L$1:
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _string_list_new, STT_FUNC;
_string_list_new:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	R6  =R0 ;
	R0  = 20 (X);
	call _malloc;
	P5  =R0 ;
	R0  = 0 (X);
	[P5 +12] =R0 ;
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$20;
	R0  =P5 ;
	R1  =R6 ;
	call _dyn_string_init;
	R1  = 0 (X);
	cc =R0 ==0;
	if !cc R0  =P5 ; if cc R0 =R1 ; /* movsicc-1 */
L$L$20:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _string_list_delete, STT_FUNC;
_string_list_delete:
	LINK 0;
	[--sp] = ( r7:6 );
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$29;
L$L$27:
	P2  =R0 ;
	R6  =[P2 +16];
	call _dyn_string_delete;
	R0  =R6 ;
	cc =R6 ==0;
	if cc jump 6; jump.l L$L$27;
L$L$29:
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _result_add_separated_char, STT_FUNC;
_result_add_separated_char:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R6  =R1 ;
	R0  =[P5 +8];
	P2  =R0 ;
	R3  =[P2 +8];
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	cc =R1 <=0;
	if !cc jump 6; jump.l L$L$31;
	R3 =R3 +R1 ;
	P2  =R3 ;
	R3  = B [P2 +-1] (X);
	cc =R3 ==R6 ;
	if cc jump 6; jump.l L$L$31;
	R2  = 32 (X);
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$34;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$34:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$30;
L$L$31:
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  =R6 ;
	call _dyn_string_insert_char;
	R1  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$38;
	R1.L  = _status_allocation_failed; R1.H  = _status_allocation_failed;
	P2  =R1 ;
	R1  =[P2 ];
L$L$38:
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc R0  =R1 ; /* movsicc-1a */
L$L$30:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _result_push, STT_FUNC;
_result_push:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	R0  = 0 (X);
	call _string_list_new;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$40;
L$L$41:
	R1  =[P5 +8];
	P2  =R0 ;
	[P2 +16] =R1 ;
	[P5 +8] =R0 ;
	R0  = 0 (X);
L$L$40:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _result_pop, STT_FUNC;
_result_pop:
	LINK 0;
	P2  =R0 ;
	R0  =[P2 +8];
	P1  =R0 ;
	P1  =[P1 +16];
	[P2 +8] =P1 ;
	UNLINK;
	rts;


.align 2
.type _result_get_caret, STT_FUNC;
_result_get_caret:
	LINK 0;
	P1  =R0 ;
	P2  =[P1 +8];
	R0  =[P2 +12];
	UNLINK;
	rts;


.align 2
.type _result_set_caret, STT_FUNC;
_result_set_caret:
	LINK 0;
	P1  =R0 ;
	P2  =[P1 +8];
	[P2 +12] =R1 ;
	UNLINK;
	rts;


.align 2
.type _result_shift_caret, STT_FUNC;
_result_shift_caret:
	LINK 0;
	P1  =R0 ;
	P2  =[P1 +8];
	R0  =[P2 +12];
	R0 =R1 +R0 ;
	[P2 +12] =R0 ;
	UNLINK;
	rts;


.align 2
.type _result_previous_char_is_space, STT_FUNC;
_result_previous_char_is_space:
	LINK 0;
	P1  =R0 ;
	P2  =[P1 +8];
	R2  =[P2 +8];
	R1  =[P2 +4];
	P2  =[P2 +12];
	R3  =P2 ;
	R1 =R1 +R3 ;
	R0  = 0 (X);
	cc =R1 <=0;
	if !cc jump 6; jump.l L$L$47;
	R2 =R2 +R1 ;
	P1  =R2 ;
	R2  = B [P1 +-1] (X);
	R1  = 1 (X);
	R3  = 32 (X);
	cc =R2 ==R3 ;
	if cc R0  =R1 ; /* movsicc-1b */
L$L$47:
	UNLINK;
	rts;


.align 2
.type _substitution_start, STT_FUNC;
_substitution_start:
	LINK 0;
	P1  =R0 ;
	P2  =[P1 +8];
	R0  =[P2 +4];
	P2  =[P2 +12];
	R1  =P2 ;
	R0 =R0 +R1 ;
	UNLINK;
	rts;


.align 2
.type _substitution_add, STT_FUNC;
_substitution_add:
	LINK 0;
	[--sp] = ( r7:4, p5:4 );
	P5  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R4  =[P5 +8];
	R0  = 0 (X);
	call _dyn_string_new;
	R5  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$58;
	P2  =[P5 +8];
	R0  =[P2 +4];
	P2  =[P2 +12];
	R1  =P2 ;
	R0 =R0 +R1 ;
	[SP +12] =R0 ;
	R2  =P4 ;
	R0  =R5 ;
	R1  =R4 ;
	call _dyn_string_substring;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$57;
	P2  =[P5 +16];
	R0  =[P5 +12];
	R1  =P2 ;
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$52;
	cc =P2 <=0;
	if !cc jump 6; jump.l L$L$53;
	P2  =P2 +P2 ;
	jump.s L$L$56;
L$L$53:
	P2  = 2 (X);
L$L$56:
	[P5 +16] =P2 ;
	R0  =[P5 +16];
	R1  =R0 ;
	R1  <<=3;
	R0  =[P5 +20];
	call _realloc;
	[P5 +20] =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$52;
L$L$57:
	R0  =R5 ;
	call _dyn_string_delete;
L$L$58:
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$49;
L$L$52:
	P2  = 12 (X);
	P2 =P2 +P5 ; //immed->Preg 
	R0  =[P2 ];
	R1  =R0 ;
	R0 +=1;
	[P2 ] =R0 ;
	R0  =[P5 +20];
	R1  <<=3;
	R0 =R1 +R0 ;
	P2  =R0 ;
	[P2 ] =R5 ;
	P5  =[P5 +20];
	R0  =P5 ;
	R1 =R1 +R0 ;
	R0  = 1 (X);
	R6  =R6 &R0 ;
	P2  =R1 ;
	R0  = B [P2 +4] (X);
	BITCLR (R0 ,0);
	R6  =R0 |R6 ;
	B [P2 +4] =R6 ;
	R0  = 0 (X);
L$L$49:
	( r7:4, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _substitution_get, STT_FUNC;
_substitution_get:
	LINK 0;
	P2  =R0 ;
	[FP +16] =R2 ;
	P1  =R2 ;
	cc =R1 <0;
	if !cc jump 6; jump.l L$L$61;
	R0  =[P2 +12];
	cc =R1 <R0 ;
	if !cc jump 6; jump.l L$L$60;
L$L$61:
	R0  = 0 (X);
	jump.s L$L$59;
L$L$60:
	R1  <<=3;
	P2  =[P2 +20];
	R0  =P2 ;
	R1 =R1 +R0 ;
	P2  =R1 ;
	R0  = B [P2 +4] (X);
	R0  <<=7;
	R0  = R0.B  (X);
	R0  >>>=7;
	R0  = R0.B  (X);
	[P1 ] =R0 ;
	R0  =[P2 ];
L$L$59:
	UNLINK;
	rts;


.align 2
.type _template_arg_list_new, STT_FUNC;
_template_arg_list_new:
	LINK 0;
	R0  = 12 (X);
	call _malloc;
	P2  =R0 ;
	R0  = 0 (X);
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$62;
	[P2 +4] =R0 ;
	[P2 +8] =R0 ;
	R0  =P2 ;
L$L$62:
	UNLINK;
	rts;


.align 2
.type _template_arg_list_delete, STT_FUNC;
_template_arg_list_delete:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	R0  =[P5 +4];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$65;
	call _string_list_delete;
L$L$65:
	R0  =P5 ;
	call _free;
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _template_arg_list_add_arg, STT_FUNC;
_template_arg_list_add_arg:
	LINK 0;
	P1  =R0 ;
	R2  =[P1 +4];
	cc =R2 ==0;
	if cc jump 6; jump.l L$L$67;
	[P1 +4] =R1 ;
	jump.s L$L$68;
L$L$67:
	P1  =R0 ;
	P2  =[P1 +8];
	[P2 +16] =R1 ;
L$L$68:
	P2  =R0 ;
	[P2 +8] =R1 ;
	P2  = 0 (X);
	P1  =R1 ;
	[P1 +16] =P2 ;
	UNLINK;
	rts;


.align 2
.type _template_arg_list_get_arg, STT_FUNC;
_template_arg_list_get_arg:
	LINK 0;
	P1  =R0 ;
	P2  =[P1 +4];
	R1 +=-1;
	cc =R1 ==-1;
	if !cc jump 6; jump.l L$L$76;
L$L$74:
	P2  =[P2 +16];
	R0  = 0 (X);
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$69;
	R1 +=-1;
	cc =R1 ==-1;
	if cc jump 6; jump.l L$L$74;
L$L$76:
	R0  =P2 ;
L$L$69:
	UNLINK;
	rts;


.align 2
.type _push_template_arg_list, STT_FUNC;
_push_template_arg_list:
	LINK 0;
	P2  =R0 ;
	R2  =[P2 +24];
	P2  =R1 ;
	[P2 ] =R2 ;
	P2  =R0 ;
	[P2 +24] =R1 ;
	UNLINK;
	rts;


.align 2
.type _pop_to_template_arg_list, STT_FUNC;
_pop_to_template_arg_list:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R6  =R1 ;
	R0  =[P5 +24];
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$84;
L$L$82:
	R0  =[P5 +24];
	P2  =R0 ;
	P2  =[P2 ];
	[P5 +24] =P2 ;
	call _template_arg_list_delete;
	R0  =[P5 +24];
	cc =R0 ==R6 ;
	if cc jump 6; jump.l L$L$82;
L$L$84:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _current_template_arg_list, STT_FUNC;
_current_template_arg_list:
	LINK 0;
	P2  =R0 ;
	R0  =[P2 +24];
	UNLINK;
	rts;


.align 2
.type _demangling_new, STT_FUNC;
_demangling_new:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	R6  =R0 ;
	R5  =R1 ;
	R0  = 44 (X);
	call _malloc;
	P5  =R0 ;
	R0  = 0 (X);
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$86;
	[P5 ] =R6 ;
	[P5 +4] =R6 ;
	[P5 +8] =R0 ;
	[P5 +12] =R0 ;
	R0  = 10 (X);
	[P5 +16] =R0 ;
	R0  = 0 (X);
	[P5 +24] =R0 ;
	call _dyn_string_new;
	R1  =R0 ;
	[P5 +28] =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$86;
	R0  =[P5 +16];
	R0  <<=3;
	call _malloc;
	[P5 +20] =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$89;
	R0  =[P5 +28];
	call _dyn_string_delete;
	R0  = 0 (X);
	jump.s L$L$86;
L$L$89:
	[P5 +32] =R5 ;
	R0  = 0 (X);
	[P5 +36] =R0 ;
	[P5 +40] =R0 ;
	R0  =P5 ;
L$L$86:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _demangling_delete, STT_FUNC;
_demangling_delete:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R0  =[P5 +24];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$101;
L$L$94:
	P2  =R0 ;
	R6  =[P2 ];
	call _template_arg_list_delete;
	R0  =R6 ;
	cc =R6 ==0;
	if cc jump 6; jump.l L$L$94;
L$L$101:
	R6  =[P5 +12];
	R6 +=-1;
	cc =R6 <0;
	if !cc jump 6; jump.l L$L$103;
L$L$99:
	R1  =[P5 +20];
	R0  =R6 ;
	R0  <<=3;
	R1 =R0 +R1 ;
	P2  =R1 ;
	R0  =[P2 ];
	call _dyn_string_delete;
	R6 +=-1;
	cc =R6 <0;
	if cc jump 6; jump.l L$L$99;
L$L$103:
	R0  =[P5 +20];
	call _free;
	R0  =[P5 +8];
	call _string_list_delete;
	R0  =[P5 +28];
	call _dyn_string_delete;
	R0  =P5 ;
	call _free;
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.data;
.align 2
L_error_message_$0:.space 4;
.text;
.align 2
L$LC$1:
.dw	0x7845;
.dw	0x6570;
.dw	0x7463;
.dw	0x6465;
.dw	0x3f20;
.db	0x00;
.align 2
.type _demangle_char, STT_FUNC;
_demangle_char:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	R6  =R1 ;
	P1  =R0 ;
	P2  =[P1 +4];
	R1  = B [P2 ] (X);
	cc =R1 ==R6 ;
	if cc jump 6; jump.l L$L$105;
	P2 +=1;
	[P1 +4] =P2 ;
	R0  = 0 (X);
	jump.s L$L$104;
L$L$105:
	P5.L  = L_error_message_$0; P5.H  = L_error_message_$0;
	R0  =[P5 ];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$107;
	R0.L  = L$LC$1; R0.H  = L$LC$1;
	call _strdup;
	[P5 ] =R0 ;
L$L$107:
	P1.L  = L_error_message_$0; P1.H  = L_error_message_$0;
	P2  =[P1 ];
	B [P2 +9] =R6 ;
	R0  =[P1 ];
L$L$104:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _demangle_mangled_name, STT_FUNC;
_demangle_mangled_name:
	LINK 0;
	[--sp] = ( r7:6 );
	R6  =R0 ;
	R1  = 95 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$108;
	R0  =R6 ;
	R1  = 90 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$108;
	R0  =R6 ;
	call _demangle_encoding;
	R1  = 0 (X);
	cc =R0 ==0;
	if cc R0  =R1 ; /* movsicc-1b */
L$L$108:
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _demangle_encoding, STT_FUNC;
_demangle_encoding:
	LINK 8;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	call _current_template_arg_list;
	R6  =R0 ;
	P2  =[P5 +4];
	R1  = B [P2 ] (X);
	P2  =[P5 +8];
	R0  =[P2 +4];
	P2  =[P2 +12];
	R2  =P2 ;
	R0 =R0 +R2 ;
	[FP +-8] =R0 ;
	R0  = R1.B  (X);
	R1  = 71 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$117;
	R2  = 84 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$116;
L$L$117:
	R0  =P5 ;
	call _demangle_special_name;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$115;
	jump.s L$L$120;
L$L$116:
	R0  =P5 ;
	R1  =FP ;
	R1 +=-4;
	call _demangle_name;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$115;
	P2  =[P5 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$120;
	P1  = 69 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$120;
	R0  =[FP +-4];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$124;
	R0  =P5 ;
	R1  =FP ;
	R1 +=-8;
	call _demangle_bare_function_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$115;
	jump.s L$L$120;
L$L$124:
	R0  =P5 ;
	R1  = 0 (X);
	call _demangle_bare_function_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$115;
L$L$120:
	R0  =P5 ;
	R1  =R6 ;
	call _pop_to_template_arg_list;
	R0  = 0 (X);
L$L$115:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$2:
.dw	0x7473;
.dw	0x3a64;
.db	0x3a;
.db	0x00;
.align 2
.type _demangle_name, STT_FUNC;
_demangle_name:
	LINK 4;
	[--sp] = ( r7:5, p5:4 );
	P4  =R0 ;
	P5  =R1 ;
	call _substitution_start;
	R6  =R0 ;
	P2  =[P4 +4];
	R0  = B [P2 ] (X);
	R5  = 0 (X);
	[FP +-4] =R5 ;
	R0  = R0.B  (X);
	R1  = 83 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$138;
	cc =R0 <=R1 ;
	if cc jump 6; jump.l L$L$166;
	R1 +=-5;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$132;
	jump.s L$L$156;
L$L$166:
	R1  = 90 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$135;
	jump.s L$L$156;
L$L$132:
	R0  =P4 ;
	R1  =P5 ;
	call _demangle_nested_name;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$130;
	jump.s L$L$131;
L$L$135:
	R0  =P4 ;
	call _demangle_local_name;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$130;
	P1  = 0 (X);
	[P5 ] =P1 ;
	jump.s L$L$131;
L$L$138:
	P2  =[P4 +4];
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$139;
	R0  = B [P2 +1] (X);
	R1  = 116 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$139;
	P2 +=2;
	[P4 +4] =P2 ;
	R0  =[P4 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$2; R2.H  = L$LC$2;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$142;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$142:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$130;
	R0  =P4 ;
	R1  =FP ;
	R1 +=-4;
	call _demangle_unqualified_name;
	R5  = 1 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$146;
	jump.s L$L$130;
L$L$139:
	R0  =P4 ;
	R1  =P5 ;
	call _demangle_substitution;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$130;
L$L$146:
	P2  =[P4 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 73 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$159;
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$150;
	R2  = 0 (X);
	R0  =P4 ;
	R1  =R6 ;
	call _substitution_add;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$130;
L$L$150:
	R0  =P4 ;
	call _demangle_template_args;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$130;
	jump.s L$L$167;
L$L$156:
	R0  =P4 ;
	R1  =FP ;
	R1 +=-4;
	call _demangle_unqualified_name;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$130;
	P2  =[P4 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 73 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$159;
	R2  = 0 (X);
	R0  =P4 ;
	R1  =R6 ;
	call _substitution_add;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$130;
	R0  =P4 ;
	call _demangle_template_args;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$130;
L$L$167:
	R0  =[FP +-4];
	cc =R0 ==0;
	R0  =CC ;
	[P5 ] =R0 ;
	jump.s L$L$131;
L$L$159:
	P2  = 0 (X);
	[P5 ] =P2 ;
L$L$131:
	R0  = 0 (X);
L$L$130:
	( r7:5, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _demangle_nested_name, STT_FUNC;
_demangle_nested_name:
	LINK 0;
	[--sp] = ( r7:5, p5:4 );
	P5  =R0 ;
	R6  =R1 ;
	R1  = 78 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$168;
	P2  =[P5 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 114 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$172;
	P1 +=-28;
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$172;
	P1 +=-11;
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$171;
L$L$172:
	R0  = 24 (X);
	call _dyn_string_new;
	P4  =R0 ;
	cc =P4 ==0;
	if cc jump 6; jump.l L$L$173;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$168;
L$L$173:
	R0  =P5 ;
	R1  =P4 ;
	call _demangle_CV_qualifiers;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 32 (X);
	call _dyn_string_insert_char;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$175;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P1  =R5 ;
	R5  =[P1 ];
L$L$175:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$176;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  =P4 ;
	call _dyn_string_insert;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$176;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P1  =R5 ;
	R5  =[P1 ];
L$L$176:
	R0  =[P4 +4];
	R1  =~R0 ;
	R0  =P5 ;
	call _result_shift_caret;
	R0  =P4 ;
	call _dyn_string_delete;
	R0  =R5 ;
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$168;
L$L$171:
	R0  =P5 ;
	R1  =R6 ;
	call _demangle_prefix;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$168;
	R0  =P5 ;
	R1  = 69 (X);
	call _demangle_char;
	R1  = 0 (X);
	cc =R0 ==0;
	if cc R0  =R1 ; /* movsicc-1b */
L$L$168:
	( r7:5, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$3:
.dw	0x6e55;
.dw	0x7865;
.dw	0x6570;
.dw	0x7463;
.dw	0x6465;
.dw	0x6520;
.dw	0x646e;
.dw	0x6f20;
.dw	0x2066;
.dw	0x616e;
.dw	0x656d;
.dw	0x6920;
.dw	0x206e;
.dw	0x633c;
.dw	0x6d6f;
.dw	0x6f70;
.dw	0x6e75;
.dw	0x2d64;
.dw	0x616e;
.dw	0x656d;
.dw	0x2e3e;
.db	0x00;
.align 2
L$LC$5:
.dw	0x3a3a;
.db	0x00;
.align 2
L$LC$4:
.db	0x2e;
.db	0x00;
.align 2
L$LC$6:
.dw	0x6e55;
.dw	0x7865;
.dw	0x6570;
.dw	0x7463;
.dw	0x6465;
.dw	0x6320;
.dw	0x6168;
.dw	0x6172;
.dw	0x7463;
.dw	0x7265;
.dw	0x6920;
.dw	0x206e;
.dw	0x633c;
.dw	0x6d6f;
.dw	0x6f70;
.dw	0x6e75;
.dw	0x2d64;
.dw	0x616e;
.dw	0x656d;
.dw	0x2e3e;
.db	0x00;
.align 2
.type _demangle_prefix, STT_FUNC;
_demangle_prefix:
	LINK 4;
	[--sp] = ( r7:4, p5:4 );
	P4  =R0 ;
	P5  =R1 ;
	call _substitution_start;
	R5  =R0 ;
	R6  = 0 (X);
	[FP +-4] =R6 ;
L$L$222:
	P2  =[P4 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	R0.L  = L$LC$3; R0.H  = L$LC$3;
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$185;
	P2  =[P4 +4];
	R4  = B [P2 ] (X);
	R2  = R4.B  (X);
	R1  =[FP +-4];
	R0  = 0 (X);
	R3  = 73 (X);
	cc =R2 ==R3 ;
	if cc R0  =R1 ; /* movsicc-2a */
	[FP +-4] =R0 ;
	R1  =R4 ;
	R0  = -48 (X);
	R0 =R0 +R1 ; //immed->Dreg 
	R0  = R0.B  (Z);
	R2  = 9 (X);
	cc =R0 <=R2  (iu);
	if !cc jump 6; jump.l L$L$192;
	R3  = -97 (X);
	R3 =R3 +R1 ; //immed->Dreg 
	R1  = R3.B  (Z);
	R0  = 25 (X);
	cc =R1 <=R0  (iu);
	if !cc jump 6; jump.l L$L$192;
	R0  = R4.B  (X);
	R1  = 67 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$192;
	R2 +=59;
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$192;
	R3  = 83 (X);
	cc =R0 ==R3 ;
	if cc jump 6; jump.l L$L$191;
L$L$192:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$193;
	R0  =[P4 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	P2  =[P4 +32];
	R3.L  = L$LC$5; R3.H  = L$LC$5;
	R2.L  = L$LC$4; R2.H  = L$LC$4;
	P1  = 4 (X);
	cc =P2 ==P1 ;
	if !cc R2  =R3 ; /* movsicc-1a */
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$196;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$196:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$185;
	jump.s L$L$200;
L$L$193:
	R6  = 1 (X);
L$L$200:
	R0  = R4.B  (X);
	R1  = 83 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$201;
	R0  =P4 ;
	R1  =P5 ;
	call _demangle_substitution;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$185;
	jump.s L$L$207;
L$L$201:
	R0  =P4 ;
	R1  =FP ;
	R1 +=-4;
	call _demangle_unqualified_name;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$185;
	R2  = 0 (X);
	[P5 ] =R2 ;
	jump.s L$L$207;
L$L$191:
	R0  = R4.B  (X);
	R3  = 90 (X);
	cc =R0 ==R3 ;
	if cc jump 6; jump.l L$L$208;
	R0  =P4 ;
	call _demangle_local_name;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$185;
	jump.s L$L$207;
L$L$208:
	R0  = R4.B  (X);
	R1  = 73 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$212;
	R0  =P4 ;
	call _demangle_template_args;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$185;
	R0  =[FP +-4];
	cc =R0 ==0;
	R0  =CC ;
	[P5 ] =R0 ;
	jump.s L$L$207;
L$L$212:
	R2  = R4.B  (X);
	R1.L  = L$LC$6; R1.H  = L$LC$6;
	R0  = 0 (X);
	R3  = 69 (X);
	cc =R2 ==R3 ;
	if !cc R0  =R1 ; /* movsicc-1a */
	jump.s L$L$185;
L$L$207:
	R0  = R4.B  (X);
	R1  = 83 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$222;
	P2  =[P4 +4];
	R2  = B [P2 ] (X);
	P2  =R2 ;
	P1  = 69 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$222;
	R2  =[P5 ];
	R0  =P4 ;
	R1  =R5 ;
	call _substitution_add;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$222;
L$L$185:
	( r7:4, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$7:
.dw	0x6e55;
.dw	0x7865;
.dw	0x6570;
.dw	0x7463;
.dw	0x6465;
.dw	0x6320;
.dw	0x6168;
.dw	0x6172;
.dw	0x7463;
.dw	0x7265;
.dw	0x6920;
.dw	0x206e;
.dw	0x753c;
.dw	0x716e;
.dw	0x6175;
.dw	0x696c;
.dw	0x6966;
.dw	0x6465;
.dw	0x6e2d;
.dw	0x6d61;
.dw	0x3e65;
.db	0x2e;
.db	0x00;
.align 2
.type _demangle_unqualified_name, STT_FUNC;
_demangle_unqualified_name:
	LINK 4;
	[--sp] = ( p5:5 );
	P1  =R0 ;
	P0  =R1 ;
	P2  =[P1 +4];
	R2  = B [P2 ] (X);
	R0  = 0 (X);
	[P0 ] =R0 ;
	R0  =R2 ;
	R0 +=-48;
	R0  = R0.B  (Z);
	R1  = 9 (X);
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$224;
	R0  =P1 ;
	call _demangle_source_name;
	jump.s L$L$238;
L$L$224:
	R0  =R2 ;
	R1  = -97 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R0  = R1.B  (Z);
	R1  = 25 (X);
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$228;
	R0  = R2.B  (X);
	R1  = 99 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$229;
	P2  =[P1 +4];
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$229;
	R0  = B [P2 +1] (X);
	P2  =R0 ;
	P5  = 118 (X);
	cc =P2 ==P5 ;
	if cc jump 6; jump.l L$L$229;
	R0  = 1 (X);
	[P0 ] =R0 ;
L$L$229:
	R1  = 0 (X);
	[SP +12] =R1 ;
	R2  =FP ;
	R2 +=-4;
	R0  =P1 ;
	call _demangle_operator_name;
	jump.s L$L$238;
L$L$228:
	R0  =R2 ;
	R1  = -67 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R0  = R1.B  (Z);
	R1.L  = L$LC$7; R1.H  = L$LC$7;
	cc =R0 <=1 (iu);
	if cc jump 6; jump.l L$L$223;
	R0  = R2.B  (X);
	R1  = 67 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$234;
	P2  = 1 (X);
	[P0 ] =P2 ;
L$L$234:
	R0  =P1 ;
	call _demangle_ctor_dtor_name;
L$L$238:
	R1  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$223;
	R1  = 0 (X);
L$L$223:
	R0  =R1 ;
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$8:
.dw	0x655a;
.dw	0x6f72;
.dw	0x6c20;
.dw	0x6e65;
.dw	0x7467;
.dw	0x2068;
.dw	0x6e69;
.dw	0x3c20;
.dw	0x6f73;
.dw	0x7275;
.dw	0x6563;
.dw	0x6e2d;
.dw	0x6d61;
.dw	0x3e65;
.db	0x2e;
.db	0x00;
.align 2
.type _demangle_source_name, STT_FUNC;
_demangle_source_name:
	LINK 4;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	R0  = 0 (X);
	[SP +12] =R0 ;
	R2  = 10 (X);
	R0  =P5 ;
	R1  =FP ;
	R1 +=-4;
	call _demangle_number;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$239;
	R1  =[FP +-4];
	R0.L  = L$LC$8; R0.H  = L$LC$8;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$239;
	R2  =[P5 +28];
	R0  =P5 ;
	call _demangle_identifier;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$239;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  =[P5 +28];
	call _dyn_string_insert;
	R1  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$247;
	R1.L  = _status_allocation_failed; R1.H  = _status_allocation_failed;
	P2  =R1 ;
	R1  =[P2 ];
L$L$247:
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc R0  =R1 ; /* movsicc-1a */
L$L$239:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _demangle_number, STT_FUNC;
_demangle_number:
	LINK 0;
	[--sp] = ( r7:4, p5:4 );
	R4  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	R5  =R2 ;
	R6  =[FP +20];
	R0  = 10 (X);
	call _dyn_string_new;
	P5  =R0 ;
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$250;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$249;
L$L$250:
	[SP +12] =R6 ;
	R2  =R5 ;
	R0  =R4 ;
	R1  =P5 ;
	call _demangle_number_literally;
	R0  =[P5 +8];
	R2  =R5 ;
	R1  = 0 (X);
	call _strtol;
	[P4 ] =R0 ;
	R0  =P5 ;
	call _dyn_string_delete;
	R0  = 0 (X);
L$L$249:
	( r7:4, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$9:
.dw	0x6e49;
.dw	0x6574;
.dw	0x6e72;
.dw	0x6c61;
.dw	0x6520;
.dw	0x7272;
.dw	0x726f;
.db	0x2e;
.db	0x00;
.align 2
.type _demangle_number_literally, STT_FUNC;
_demangle_number_literally:
	LINK 4;
	[--sp] = ( r7:5, p5:3 );
	P3  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R1  =[FP +20];
	R0  = 10 (X);
	cc =R2 ==R0 ;
	if !cc jump 6; jump.l L$L$252;
	R0.L  = L$LC$9; R0.H  = L$LC$9;
	R2  = 36 (X);
	cc =R6 ==R2 ;
	if cc jump 6; jump.l L$L$251;
L$L$252:
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$253;
	P2  =[P3 +4];
	R0  = B [P2 ] (X);
	R1  = 110 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$253;
	P2 +=1;
	[P3 +4] =P2 ;
	R0  =R5 ;
	R1  = 45 (X);
	call _dyn_string_append_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$253;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$251;
L$L$253:
	P4  = 4 (X);
	P4 =P4 +P3 ; //immed->Preg 
	P5.L  = _status_allocation_failed; P5.H  = _status_allocation_failed;
L$L$262:
	P2  =[P3 +4];
	R1  = B [P2 ] (X);
	R0  =R1 ;
	R0 +=-48;
	R0  = R0.B  (Z);
	R2  = 9 (X);
	cc =R0 <=R2  (iu);
	if !cc jump 6; jump.l L$L$259;
	R0  = 36 (X);
	cc =R6 ==R0 ;
	if cc jump 6; jump.l L$L$256;
	R0  = R1.B  (X);
	R1  = 64 (X);
	cc =R0 <=R1 ;
	if !cc jump 6; jump.l L$L$256;
	R2  = 90 (X);
	cc =R0 <=R2 ;
	if cc jump 6; jump.l L$L$256;
L$L$259:
	P2  =[P4 ];
	R1  = B [P2 ++] (X);
	[P4 ] =P2 ;
	R0  =R5 ;
	call _dyn_string_append_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$262;
	R0  =[P5 ];
	jump.s L$L$251;
L$L$256:
	R0  = 0 (X);
L$L$251:
	( r7:5, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$10:
.dw	0x6e55;
.dw	0x7865;
.dw	0x6570;
.dw	0x7463;
.dw	0x6465;
.dw	0x6520;
.dw	0x646e;
.dw	0x6f20;
.dw	0x2066;
.dw	0x616e;
.dw	0x656d;
.dw	0x6920;
.dw	0x206e;
.dw	0x693c;
.dw	0x6564;
.dw	0x746e;
.dw	0x6669;
.dw	0x6569;
.dw	0x3e72;
.db	0x2e;
.db	0x00;
.align 2
L$LC$11:
.dw	0x7245;
.dw	0x6f72;
.dw	0x2e72;
.db	0x00;
.align 2
L$LC$12:
.dw	0x5f5f;
.db	0x55;
.db	0x00;
.align 2
L$LC$13:
.dw	0x475f;
.dw	0x4f4c;
.dw	0x4142;
.dw	0x5f4c;
.db	0x00;
.align 2
L$LC$14:
.dw	0x6128;
.dw	0x6f6e;
.dw	0x796e;
.dw	0x6f6d;
.dw	0x7375;
.dw	0x6e20;
.dw	0x6d61;
.dw	0x7365;
.dw	0x6170;
.dw	0x6563;
.db	0x29;
.db	0x00;
.align 2
.type _demangle_identifier, STT_FUNC;
_demangle_identifier:
	LINK 20;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	P4  =R2 ;
	R0  =R2 ;
	call _dyn_string_clear;
	R0  =P4 ;
	R1  =R5 ;
	call _dyn_string_resize;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$291;
	R0  =R5 ;
	R5 +=-1;
	cc =R0 <=0;
	if !cc jump 6; jump.l L$L$287;
L$L$281:
	R1  =[P3 +4];
	P1  =R1 ;
	R1  = B [P1 ] (X);
	R0.L  = L$LC$10; R0.H  = L$LC$10;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$263;
	P1  = 4 (X);
	P1 =P1 +P3 ; //immed->Preg 
	P2  =[P1 ];
	R6  = B [P2 ++] (X);
	[P1 ] =P2 ;
	R0  = 95 (X);
	cc =R6 ==R0 ;
	if cc jump 6; jump.l L$L$269;
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$269;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$269;
	R0  = B [P2 +1] (X);
	R1 +=-10;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$269;
	P5  = 0 (X);
	P2 +=2;
	[P1 ] =P2 ;
	R5 +=-2;
	R0  =R5 ;
	R5 +=-1;
	cc =R0 <=0;
	if !cc jump 6; jump.l L$L$271;
	R4  =P1 ;
L$L$274:
	P1  =R4 ;
	P2  =[P1 ];
	R6  = B [P2 ++] (X);
	[P1 ] =P2 ;
	R0  =R6 ;
	call _isxdigit;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$271;
	P2 =P5 +FP ;
	B [P2 +-12] =R6 ;
	P5 +=1;
	R0  =R5 ;
	R5 +=-1;
	cc =R0 <=0;
	if cc jump 6; jump.l L$L$274;
L$L$271:
	R0  = 95 (X);
	cc =R6 ==R0 ;
	if cc jump 6; jump.l L$L$276;
	cc =R5 <0;
	if cc jump 6; jump.l L$L$275;
L$L$276:
	R0.L  = L$LC$11; R0.H  = L$LC$11;
	jump.s L$L$263;
L$L$275:
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$277;
	R0  =P4 ;
	R1.L  = L$LC$12; R1.H  = L$LC$12;
	call _dyn_string_append_cstr;
	jump.s L$L$292;
L$L$291:
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$263;
L$L$277:
	R0  =FP ;
	R0 +=-12;
	P1  =R0 ;
	P5 =P1 +P5 ;
	R1  = 0 (X);
	B [P5 ] =R1 ;
	R2  = 16 (X);
	R1  = 0 (X);
	call _strtol;
	R6  =R0 ;
L$L$269:
	R0  =P4 ;
	R1  =R6 ;
	call _dyn_string_append_char;
L$L$292:
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$291;
	R0  =R5 ;
	R5 +=-1;
	cc =R0 <=0;
	if cc jump 6; jump.l L$L$281;
L$L$287:
	P2.L  = _flag_strict; P2.H  = _flag_strict;
	P2  =[P2 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$282;
	R6  =[P4 +8];
	R2  = 8 (X);
	R0  =R6 ;
	R1.L  = L$LC$13; R1.H  = L$LC$13;
	call _strncmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$282;
	R6 +=8;
	P1  =R6 ;
	R0  = B [P1 ] (X);
	R1  = 46 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$285;
	R1 +=49;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$285;
	R1  = 36 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$282;
L$L$285:
	P1  =R6 ;
	R6  = B [P1 +1] (X);
	R0  = 78 (X);
	cc =R6 ==R0 ;
	if cc jump 6; jump.l L$L$282;
	R0  =P4 ;
	R1.L  = L$LC$14; R1.H  = L$LC$14;
	call _dyn_string_copy_cstr;
L$L$282:
	R0  = 0 (X);
L$L$263:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$15:
.dw	0x4e61;
.db	0x00;
.align 2
L$LC$16:
.dw	0x3d26;
.db	0x00;
.align 2
L$LC$17:
.dw	0x5361;
.db	0x00;
.align 2
L$LC$18:
.db	0x3d;
.db	0x00;
.align 2
L$LC$19:
.dw	0x6161;
.db	0x00;
.align 2
L$LC$20:
.dw	0x2626;
.db	0x00;
.align 2
L$LC$21:
.dw	0x6461;
.db	0x00;
.align 2
L$LC$22:
.db	0x26;
.db	0x00;
.align 2
L$LC$23:
.dw	0x6e61;
.db	0x00;
.align 2
L$LC$24:
.dw	0x6c63;
.db	0x00;
.align 2
L$LC$25:
.dw	0x2928;
.db	0x00;
.align 2
L$LC$26:
.dw	0x6d63;
.db	0x00;
.align 2
L$LC$27:
.db	0x2c;
.db	0x00;
.align 2
L$LC$28:
.dw	0x6f63;
.db	0x00;
.align 2
L$LC$29:
.db	0x7e;
.db	0x00;
.align 2
L$LC$30:
.dw	0x5664;
.db	0x00;
.align 2
L$LC$31:
.dw	0x3d2f;
.db	0x00;
.align 2
L$LC$32:
.dw	0x6164;
.db	0x00;
.align 2
L$LC$33:
.dw	0x6420;
.dw	0x6c65;
.dw	0x7465;
.dw	0x5b65;
.db	0x5d;
.db	0x00;
.align 2
L$LC$34:
.dw	0x6564;
.db	0x00;
.align 2
L$LC$35:
.db	0x2a;
.db	0x00;
.align 2
L$LC$36:
.dw	0x6c64;
.db	0x00;
.align 2
L$LC$37:
.dw	0x6420;
.dw	0x6c65;
.dw	0x7465;
.db	0x65;
.db	0x00;
.align 2
L$LC$38:
.dw	0x7664;
.db	0x00;
.align 2
L$LC$39:
.db	0x2f;
.db	0x00;
.align 2
L$LC$40:
.dw	0x4f65;
.db	0x00;
.align 2
L$LC$41:
.dw	0x3d5e;
.db	0x00;
.align 2
L$LC$42:
.dw	0x6f65;
.db	0x00;
.align 2
L$LC$43:
.db	0x5e;
.db	0x00;
.align 2
L$LC$44:
.dw	0x7165;
.db	0x00;
.align 2
L$LC$45:
.dw	0x3d3d;
.db	0x00;
.align 2
L$LC$46:
.dw	0x6567;
.db	0x00;
.align 2
L$LC$47:
.dw	0x3d3e;
.db	0x00;
.align 2
L$LC$48:
.dw	0x7467;
.db	0x00;
.align 2
L$LC$49:
.db	0x3e;
.db	0x00;
.align 2
L$LC$50:
.dw	0x7869;
.db	0x00;
.align 2
L$LC$51:
.dw	0x5d5b;
.db	0x00;
.align 2
L$LC$52:
.dw	0x536c;
.db	0x00;
.align 2
L$LC$53:
.dw	0x3c3c;
.db	0x3d;
.db	0x00;
.align 2
L$LC$54:
.dw	0x656c;
.db	0x00;
.align 2
L$LC$55:
.dw	0x3d3c;
.db	0x00;
.align 2
L$LC$56:
.dw	0x736c;
.db	0x00;
.align 2
L$LC$57:
.dw	0x3c3c;
.db	0x00;
.align 2
L$LC$58:
.dw	0x746c;
.db	0x00;
.align 2
L$LC$59:
.db	0x3c;
.db	0x00;
.align 2
L$LC$60:
.dw	0x496d;
.db	0x00;
.align 2
L$LC$61:
.dw	0x3d2d;
.db	0x00;
.align 2
L$LC$62:
.dw	0x4c6d;
.db	0x00;
.align 2
L$LC$63:
.dw	0x3d2a;
.db	0x00;
.align 2
L$LC$64:
.dw	0x696d;
.db	0x00;
.align 2
L$LC$65:
.db	0x2d;
.db	0x00;
.align 2
L$LC$66:
.dw	0x6c6d;
.db	0x00;
.align 2
L$LC$67:
.dw	0x6d6d;
.db	0x00;
.align 2
L$LC$68:
.dw	0x2d2d;
.db	0x00;
.align 2
L$LC$69:
.dw	0x616e;
.db	0x00;
.align 2
L$LC$70:
.dw	0x6e20;
.dw	0x7765;
.dw	0x5d5b;
.db	0x00;
.align 2
L$LC$71:
.dw	0x656e;
.db	0x00;
.align 2
L$LC$72:
.dw	0x3d21;
.db	0x00;
.align 2
L$LC$73:
.dw	0x676e;
.db	0x00;
.align 2
L$LC$74:
.dw	0x746e;
.db	0x00;
.align 2
L$LC$75:
.db	0x21;
.db	0x00;
.align 2
L$LC$76:
.dw	0x776e;
.db	0x00;
.align 2
L$LC$77:
.dw	0x6e20;
.dw	0x7765;
.db	0x00;
.align 2
L$LC$78:
.dw	0x526f;
.db	0x00;
.align 2
L$LC$79:
.dw	0x3d7c;
.db	0x00;
.align 2
L$LC$80:
.dw	0x6f6f;
.db	0x00;
.align 2
L$LC$81:
.dw	0x7c7c;
.db	0x00;
.align 2
L$LC$82:
.dw	0x726f;
.db	0x00;
.align 2
L$LC$83:
.db	0x7c;
.db	0x00;
.align 2
L$LC$84:
.dw	0x4c70;
.db	0x00;
.align 2
L$LC$85:
.dw	0x3d2b;
.db	0x00;
.align 2
L$LC$86:
.dw	0x6c70;
.db	0x00;
.align 2
L$LC$87:
.db	0x2b;
.db	0x00;
.align 2
L$LC$88:
.dw	0x6d70;
.db	0x00;
.align 2
L$LC$89:
.dw	0x3e2d;
.db	0x2a;
.db	0x00;
.align 2
L$LC$90:
.dw	0x7070;
.db	0x00;
.align 2
L$LC$91:
.dw	0x2b2b;
.db	0x00;
.align 2
L$LC$92:
.dw	0x7370;
.db	0x00;
.align 2
L$LC$93:
.dw	0x7470;
.db	0x00;
.align 2
L$LC$94:
.dw	0x3e2d;
.db	0x00;
.align 2
L$LC$95:
.dw	0x7571;
.db	0x00;
.align 2
L$LC$96:
.db	0x3f;
.db	0x00;
.align 2
L$LC$97:
.dw	0x4d72;
.db	0x00;
.align 2
L$LC$98:
.dw	0x3d25;
.db	0x00;
.align 2
L$LC$99:
.dw	0x5372;
.db	0x00;
.align 2
L$LC$100:
.dw	0x3e3e;
.db	0x3d;
.db	0x00;
.align 2
L$LC$101:
.dw	0x6d72;
.db	0x00;
.align 2
L$LC$102:
.db	0x25;
.db	0x00;
.align 2
L$LC$103:
.dw	0x7372;
.db	0x00;
.align 2
L$LC$104:
.dw	0x3e3e;
.db	0x00;
.align 2
L$LC$105:
.dw	0x7a73;
.db	0x00;
.align 2
L$LC$106:
.dw	0x7320;
.dw	0x7a69;
.dw	0x6f65;
.db	0x66;
.db	0x00;
.align 2
L_operators_$1:	.long	L$LC$15
	.long	L$LC$16
	.long	2
	.long	L$LC$17
	.long	L$LC$18
	.long	2
	.long	L$LC$19
	.long	L$LC$20
	.long	2
	.long	L$LC$21
	.long	L$LC$22
	.long	1
	.long	L$LC$23
	.long	L$LC$22
	.long	2
	.long	L$LC$24
	.long	L$LC$25
	.long	0
	.long	L$LC$26
	.long	L$LC$27
	.long	2
	.long	L$LC$28
	.long	L$LC$29
	.long	1
	.long	L$LC$30
	.long	L$LC$31
	.long	2
	.long	L$LC$32
	.long	L$LC$33
	.long	1
	.long	L$LC$34
	.long	L$LC$35
	.long	1
	.long	L$LC$36
	.long	L$LC$37
	.long	1
	.long	L$LC$38
	.long	L$LC$39
	.long	2
	.long	L$LC$40
	.long	L$LC$41
	.long	2
	.long	L$LC$42
	.long	L$LC$43
	.long	2
	.long	L$LC$44
	.long	L$LC$45
	.long	2
	.long	L$LC$46
	.long	L$LC$47
	.long	2
	.long	L$LC$48
	.long	L$LC$49
	.long	2
	.long	L$LC$50
	.long	L$LC$51
	.long	2
	.long	L$LC$52
	.long	L$LC$53
	.long	2
	.long	L$LC$54
	.long	L$LC$55
	.long	2
	.long	L$LC$56
	.long	L$LC$57
	.long	2
	.long	L$LC$58
	.long	L$LC$59
	.long	2
	.long	L$LC$60
	.long	L$LC$61
	.long	2
	.long	L$LC$62
	.long	L$LC$63
	.long	2
	.long	L$LC$64
	.long	L$LC$65
	.long	2
	.long	L$LC$66
	.long	L$LC$35
	.long	2
	.long	L$LC$67
	.long	L$LC$68
	.long	1
	.long	L$LC$69
	.long	L$LC$70
	.long	1
	.long	L$LC$71
	.long	L$LC$72
	.long	2
	.long	L$LC$73
	.long	L$LC$65
	.long	1
	.long	L$LC$74
	.long	L$LC$75
	.long	1
	.long	L$LC$76
	.long	L$LC$77
	.long	1
	.long	L$LC$78
	.long	L$LC$79
	.long	2
	.long	L$LC$80
	.long	L$LC$81
	.long	2
	.long	L$LC$82
	.long	L$LC$83
	.long	2
	.long	L$LC$84
	.long	L$LC$85
	.long	2
	.long	L$LC$86
	.long	L$LC$87
	.long	2
	.long	L$LC$88
	.long	L$LC$89
	.long	2
	.long	L$LC$90
	.long	L$LC$91
	.long	1
	.long	L$LC$92
	.long	L$LC$87
	.long	1
	.long	L$LC$93
	.long	L$LC$94
	.long	2
	.long	L$LC$95
	.long	L$LC$96
	.long	3
	.long	L$LC$97
	.long	L$LC$98
	.long	2
	.long	L$LC$99
	.long	L$LC$100
	.long	2
	.long	L$LC$101
	.long	L$LC$102
	.long	2
	.long	L$LC$103
	.long	L$LC$104
	.long	2
	.long	L$LC$105
	.long	L$LC$106
	.long	1
.align 2
L$LC$107:
.dw	0x706f;
.dw	0x7265;
.dw	0x7461;
.dw	0x726f;
.db	0x20;
.db	0x00;
.align 2
L$LC$108:
.dw	0x706f;
.dw	0x7265;
.dw	0x7461;
.dw	0x726f;
.db	0x00;
.align 2
L$LC$109:
.dw	0x6e55;
.dw	0x6e6b;
.dw	0x776f;
.dw	0x206e;
.dw	0x6f63;
.dw	0x6564;
.dw	0x6920;
.dw	0x206e;
.dw	0x6f3c;
.dw	0x6570;
.dw	0x6172;
.dw	0x6f74;
.dw	0x2d72;
.dw	0x616e;
.dw	0x656d;
.dw	0x2e3e;
.db	0x00;
.align 2
.type _demangle_operator_name, STT_FUNC;
_demangle_operator_name:
	LINK 4;
	[--sp] = ( r7:4, p5:3 );
	[FP +8] =R0 ;
	P2  =R1 ;
	[FP +16] =R2 ;
	P4  =R2 ;
	P5  =[FP +20];
	P0  =R0 ;
	P0 +=4;
	P1  =[P0 ];
	R4  = B [P1 ++] (X);
	[P0 ] =P1 ;
	R1  = B [P1 ++] (X);
	[P0 ] =P1 ;
	R2.L  = L_operators_$1; R2.H  = L_operators_$1;
	R0.L  = L_operators_$1+576; R0.H  = L_operators_$1+576;
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$294;
	R3  = 0 (X);
	[P5 ] =R3 ;
L$L$294:
	R5  = 118 (X);
	cc =R4 ==R5 ;
	if cc jump 6; jump.l L$L$295;
	R3  = -48 (X);
	R3 =R3 +R1 ; //immed->Dreg 
	R6  = 9 (X);
	cc =R3 <=R6  (iu);
	if cc jump 6; jump.l L$L$295;
	P1  =[FP +8];
	P2  =[P1 +8];
	R0  =[P2 +4];
	R1  =[P2 +12];
	R1 =R0 +R1 ;
	R2.L  = L$LC$107; R2.H  = L$LC$107;
	R0  =P2 ;
	call _dyn_string_insert_cstr;
	P1  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$298;
	P1.L  = _status_allocation_failed; P1.H  = _status_allocation_failed;
	P1  =[P1 ];
L$L$298:
	cc =P1 ==0;
	if cc jump 6; jump.l L$L$293;
	R0  =[FP +8];
	call _demangle_source_name;
	jump.s L$L$339;
L$L$295:
	R3  = 99 (X);
	cc =R4 ==R3 ;
	if cc jump 6; jump.l L$L$302;
	R5  = 118 (X);
	cc =R1 ==R5 ;
	if cc jump 6; jump.l L$L$302;
	P1  =[FP +8];
	P2  =[P1 +8];
	R0  =[P2 +4];
	R1  =[P2 +12];
	R1 =R0 +R1 ;
	R2.L  = L$LC$107; R2.H  = L$LC$107;
	R0  =P2 ;
	call _dyn_string_insert_cstr;
	P1  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$305;
	P1.L  = _status_allocation_failed; P1.H  = _status_allocation_failed;
	P1  =[P1 ];
L$L$305:
	cc =P1 ==0;
	if cc jump 6; jump.l L$L$293;
	R0  =[FP +8];
	call _demangle_type;
L$L$339:
	P1  =R0 ;
	cc =P1 ==0;
	if cc jump 6; jump.l L$L$293;
	P2  = 0 (X);
	[P4 ] =P2 ;
	jump.s L$L$337;
L$L$302:
	R3  = 115 (X);
	cc =R4 ==R3 ;
	if cc jump 6; jump.l L$L$309;
	R5  = 116 (X);
	cc =R1 ==R5 ;
	if cc jump 6; jump.l L$L$309;
	P1  =[FP +8];
	P1  =[P1 +8];
	[FP +8] =P1 ;
	R0  =[P1 +4];
	R1  =[P1 +12];
	R1 =R0 +R1 ;
	R2.L  = L$LC$106; R2.H  = L$LC$106;
	R0  =P1 ;
	call _dyn_string_insert_cstr;
	P1  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$312;
	P1.L  = _status_allocation_failed; P1.H  = _status_allocation_failed;
	P1  =[P1 ];
L$L$312:
	cc =P1 ==0;
	if cc jump 6; jump.l L$L$293;
	P2  = 1 (X);
	[P4 ] =P2 ;
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$337;
	[P5 ] =P2 ;
	jump.s L$L$337;
L$L$309:
	P3.L  = _status_allocation_failed; P3.H  = _status_allocation_failed;
L$L$336:
	R3  =R0 -R2 ;
	R3  >>>=2;
	R5.L  = -21845; R5.H  = -21846;
	R5  *=R3 ;
	R3  =R5 ;
	R3  >>=31;
	P5  =R3 ;
	P1  =R5 ;
	P5 =P1 +P5 ;
	R3  =P5 ;
	R3  >>>=1;
	P5  =R3 ;
	P5  =P5 +(P5 <<1);
	P1  =R2 ;
	P5  =P1 +(P5 <<2);
	P1  =[P5 ];
	R5  = B [P1 ] (X);
	R3  = B [P1 +1] (X);
	R6  = R5.B  (X);
	cc =R4 ==R6 ;
	if cc jump 6; jump.l L$L$318;
	R6  = R3.B  (X);
	cc =R1 ==R6 ;
	if cc jump 6; jump.l L$L$318;
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$319;
	P1  =[FP +8];
	P2  =[P1 +8];
	R0  =[P2 +4];
	R1  =[P2 +12];
	R1 =R0 +R1 ;
	R2.L  = L$LC$108; R2.H  = L$LC$108;
	R0  =P2 ;
	call _dyn_string_insert_cstr;
	P1  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$322;
	P1  =[P3 ];
L$L$322:
	cc =P1 ==0;
	if cc jump 6; jump.l L$L$293;
L$L$319:
	P2  =[FP +8];
	P2  =[P2 +8];
	[FP +8] =P2 ;
	R0  =[P2 +4];
	R1  =[P2 +12];
	R1 =R0 +R1 ;
	R2  =[P5 +4];
	R0  =P2 ;
	call _dyn_string_insert_cstr;
	P1  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$326;
	P1  =[P3 ];
L$L$326:
	cc =P1 ==0;
	if cc jump 6; jump.l L$L$293;
	P5  =[P5 +8];
	[P4 ] =P5 ;
L$L$337:
	P1  = 0 (X);
	jump.s L$L$293;
L$L$318:
	P1.L  = L$LC$109; P1.H  = L$LC$109;
	R6  =P5 ;
	cc =R6 ==R2 ;
	if !cc jump 6; jump.l L$L$293;
	R5  = R5.B  (X);
	cc =R4 <R5 ;
	if !cc jump 6; jump.l L$L$330;
	cc =R4 ==R5 ;
	if cc jump 6; jump.l L$L$329;
	R3  = R3.B  (X);
	cc =R1 <R3 ;
	if cc jump 6; jump.l L$L$329;
L$L$330:
	R0  =P5 ;
	jump.s L$L$336;
L$L$329:
	R2  =P5 ;
	jump.s L$L$336;
L$L$293:
	R0  =P1 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$110:
.dw	0x5b20;
.dw	0x766e;
.db	0x3a;
.db	0x00;
.align 2
.type _demangle_nv_offset, STT_FUNC;
_demangle_nv_offset:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	P5  =R0 ;
	R5  = 0 (X);
	R0  = 4 (X);
	call _dyn_string_new;
	R6  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$341;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$340;
L$L$341:
	R0  = 1 (X);
	[SP +12] =R0 ;
	R2  = 10 (X);
	R0  =P5 ;
	R1  =R6 ;
	call _demangle_number_literally;
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$342;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$110; R2.H  = L$LC$110;
	call _dyn_string_insert_cstr;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$344;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P2  =R5 ;
	R5  =[P2 ];
L$L$344:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$342;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  =R6 ;
	call _dyn_string_insert;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$345;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P2  =R5 ;
	R5  =[P2 ];
L$L$345:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$342;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 93 (X);
	call _dyn_string_insert_char;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$342;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P2  =R5 ;
	R5  =[P2 ];
L$L$342:
	R0  =R6 ;
	call _dyn_string_delete;
	R0  = 0 (X);
	cc =R5 ==0;
	if !cc R0  =R5 ; /* movsicc-1a */
L$L$340:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$111:
.dw	0x5b20;
.dw	0x3a76;
.db	0x00;
.align 2
.type _demangle_v_offset, STT_FUNC;
_demangle_v_offset:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	P5  =R0 ;
	R5  = 0 (X);
	R0  = 4 (X);
	call _dyn_string_new;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$377;
	R0  = 1 (X);
	[SP +12] =R0 ;
	R2  = 10 (X);
	R0  =P5 ;
	R1  =R6 ;
	call _demangle_number_literally;
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$355;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$111; R2.H  = L$LC$111;
	call _dyn_string_insert_cstr;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$357;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P2  =R5 ;
	R5  =[P2 ];
L$L$357:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$355;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  =R6 ;
	call _dyn_string_insert;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$358;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P2  =R5 ;
	R5  =[P2 ];
L$L$358:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$355;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 44 (X);
	call _dyn_string_insert_char;
L$L$355:
	R0  =R6 ;
	call _dyn_string_delete;
	R0  =R5 ;
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$353;
	R0  =P5 ;
	R1  = 95 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$353;
	R0  = 4 (X);
	call _dyn_string_new;
	R6  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$368;
L$L$377:
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$353;
L$L$368:
	R0  = 1 (X);
	[SP +12] =R0 ;
	R2  = 10 (X);
	R0  =P5 ;
	R1  =R6 ;
	call _demangle_number_literally;
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$369;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  =R6 ;
	call _dyn_string_insert;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$371;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P2  =R5 ;
	R5  =[P2 ];
L$L$371:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$369;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 93 (X);
	call _dyn_string_insert_char;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$369;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P2  =R5 ;
	R5  =[P2 ];
L$L$369:
	R0  =R6 ;
	call _dyn_string_delete;
	R0  = 0 (X);
	cc =R5 ==0;
	if !cc R0  =R5 ; /* movsicc-1a */
L$L$353:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$112:
.dw	0x6e55;
.dw	0x6572;
.dw	0x6f63;
.dw	0x6e67;
.dw	0x7a69;
.dw	0x6465;
.dw	0x3c20;
.dw	0x6163;
.dw	0x6c6c;
.dw	0x6f2d;
.dw	0x6666;
.dw	0x6573;
.dw	0x3e74;
.db	0x2e;
.db	0x00;
.align 2
.type _demangle_call_offset, STT_FUNC;
_demangle_call_offset:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	P2  =[P5 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 104 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$380;
	P1 +=14;
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$385;
	jump.s L$L$390;
L$L$380:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =P5 ;
	call _demangle_nv_offset;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$378;
	R0  =P5 ;
	R1  = 95 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$378;
	jump.s L$L$379;
L$L$385:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =P5 ;
	call _demangle_v_offset;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$378;
	R0  =P5 ;
	R1  = 95 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$378;
	jump.s L$L$379;
L$L$390:
	R0.L  = L$LC$112; R0.H  = L$LC$112;
	jump.s L$L$378;
L$L$379:
	R0  = 0 (X);
L$L$378:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$115:
.dw	0x6e55;
.dw	0x6572;
.dw	0x6f63;
.dw	0x6e67;
.dw	0x7a69;
.dw	0x6465;
.dw	0x3c20;
.dw	0x7073;
.dw	0x6365;
.dw	0x6169;
.dw	0x2d6c;
.dw	0x616e;
.dw	0x656d;
.dw	0x2e3e;
.db	0x00;
.align 2
L$LC$113:
.dw	0x7567;
.dw	0x7261;
.dw	0x2064;
.dw	0x6176;
.dw	0x6972;
.dw	0x6261;
.dw	0x656c;
.dw	0x6620;
.dw	0x726f;
.db	0x20;
.db	0x00;
.align 2
L$LC$114:
.dw	0x6572;
.dw	0x6566;
.dw	0x6572;
.dw	0x636e;
.dw	0x2065;
.dw	0x6574;
.dw	0x706d;
.dw	0x726f;
.dw	0x7261;
.dw	0x2079;
.dw	0x6f66;
.dw	0x2072;
.db	0x00;
.align 2
L$LC$116:
.dw	0x7476;
.dw	0x6261;
.dw	0x656c;
.dw	0x6620;
.dw	0x726f;
.db	0x20;
.db	0x00;
.align 2
L$LC$117:
.dw	0x5456;
.dw	0x2054;
.dw	0x6f66;
.dw	0x2072;
.db	0x00;
.align 2
L$LC$118:
.dw	0x7974;
.dw	0x6570;
.dw	0x6e69;
.dw	0x6f66;
.dw	0x6620;
.dw	0x726f;
.db	0x20;
.db	0x00;
.align 2
L$LC$119:
.dw	0x7974;
.dw	0x6570;
.dw	0x6e69;
.dw	0x6f66;
.dw	0x6620;
.dw	0x206e;
.dw	0x6f66;
.dw	0x2072;
.db	0x00;
.align 2
L$LC$120:
.dw	0x7974;
.dw	0x6570;
.dw	0x6e69;
.dw	0x6f66;
.dw	0x6e20;
.dw	0x6d61;
.dw	0x2065;
.dw	0x6f66;
.dw	0x2072;
.db	0x00;
.align 2
L$LC$121:
.dw	0x616a;
.dw	0x6176;
.dw	0x4320;
.dw	0x616c;
.dw	0x7373;
.dw	0x6620;
.dw	0x726f;
.db	0x20;
.db	0x00;
.align 2
L$LC$122:
.dw	0x6f6e;
.dw	0x2d6e;
.dw	0x6976;
.dw	0x7472;
.dw	0x6175;
.dw	0x206c;
.dw	0x6874;
.dw	0x6e75;
.db	0x6b;
.db	0x00;
.align 2
L$LC$123:
.dw	0x7420;
.dw	0x206f;
.db	0x00;
.align 2
L$LC$124:
.dw	0x6976;
.dw	0x7472;
.dw	0x6175;
.dw	0x206c;
.dw	0x6874;
.dw	0x6e75;
.db	0x6b;
.db	0x00;
.align 2
L$LC$125:
.dw	0x6f63;
.dw	0x6176;
.dw	0x6972;
.dw	0x6e61;
.dw	0x2074;
.dw	0x6572;
.dw	0x7574;
.dw	0x6e72;
.dw	0x7420;
.dw	0x7568;
.dw	0x6b6e;
.db	0x00;
.align 2
L$LC$126:
.dw	0x6f63;
.dw	0x736e;
.dw	0x7274;
.dw	0x6375;
.dw	0x6974;
.dw	0x6e6f;
.dw	0x7620;
.dw	0x6174;
.dw	0x6c62;
.dw	0x2065;
.dw	0x6f66;
.dw	0x2072;
.db	0x00;
.align 2
L$LC$127:
.dw	0x692d;
.dw	0x2d6e;
.db	0x00;
.align 2
.type _demangle_special_name, STT_FUNC;
_demangle_special_name:
	LINK 4;
	[--sp] = ( r7:4, p5:5 );
	P5  =R0 ;
	P2  =[P5 +4];
	R1  = B [P2 ] (X);
	R0  = R1.B  (X);
	R2  = 71 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$393;
	P2 +=1;
	[P5 +4] =P2 ;
	R1  = B [P2 ] (X);
	R0  = 82 (X);
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$402;
	R0.L  = L$LC$115; R0.H  = L$LC$115;
	R2 +=15;
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$392;
	P2 +=1;
	[P5 +4] =P2 ;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$113; R2.H  = L$LC$113;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$398;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$398:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	R1  =FP ;
	R1 +=-4;
	call _demangle_name;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	jump.s L$L$411;
L$L$402:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$114; R2.H  = L$LC$114;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$405;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$405:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	R1  =FP ;
	R1 +=-4;
	call _demangle_name;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	jump.s L$L$411;
L$L$393:
	R1  = R1.B  (X);
	R0.L  = L$LC$11; R0.H  = L$LC$11;
	R2  = 84 (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$392;
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	P1  =R0 ;
	R0  = B [P1 ] (X);
	R1  = -67 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	P2  = 51 (X);
	P1  =R1 ;
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$527;
P2.L =L$L$528;
P2.H =L$L$528;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$528:
	.dd		L$L$501;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$435;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$428;
	.dd		L$L$449;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$442;
	.dd		L$L$421;
	.dd		L$L$527;
	.dd		L$L$414;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$486;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$456;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$527;
	.dd		L$L$471;
L$L$414:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$116; R2.H  = L$LC$116;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$417;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$417:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	jump.s L$L$411;
L$L$421:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$117; R2.H  = L$LC$117;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$424;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$424:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	jump.s L$L$411;
L$L$428:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$118; R2.H  = L$LC$118;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$431;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$431:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	jump.s L$L$411;
L$L$435:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$119; R2.H  = L$LC$119;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$438;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$438:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	jump.s L$L$411;
L$L$442:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$120; R2.H  = L$LC$120;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$445;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$445:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	jump.s L$L$411;
L$L$449:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$121; R2.H  = L$LC$121;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$452;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$452:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	jump.s L$L$411;
L$L$456:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$122; R2.H  = L$LC$122;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$459;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$459:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _demangle_nv_offset;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	R1  = 95 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$123; R2.H  = L$LC$123;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$467;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$467:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _demangle_encoding;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	jump.s L$L$411;
L$L$471:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$124; R2.H  = L$LC$124;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$474;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$474:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _demangle_v_offset;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	R1  = 95 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$123; R2.H  = L$LC$123;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$482;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$482:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _demangle_encoding;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	jump.s L$L$411;
L$L$486:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$125; R2.H  = L$LC$125;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$489;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$489:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _demangle_call_offset;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _demangle_call_offset;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$123; R2.H  = L$LC$123;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$497;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$497:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _demangle_encoding;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	jump.s L$L$411;
L$L$501:
	P2.L  = _flag_strict; P2.H  = _flag_strict;
	P2  =[P2 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$527;
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$126; R2.H  = L$LC$126;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$505;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$505:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _result_push;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$392;
	R0  =P5 ;
	call _result_pop;
	R4  =R0 ;
	R0  = 4 (X);
	call _dyn_string_new;
	R6  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$511;
	R0  =R4 ;
	call _dyn_string_delete;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$392;
L$L$511:
	R0  = 1 (X);
	[SP +12] =R0 ;
	R2  = 10 (X);
	R0  =P5 ;
	R1  =R6 ;
	call _demangle_number_literally;
	R0  =P5 ;
	R1  = 95 (X);
	call _demangle_char;
	R5  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$516;
	R0  =P5 ;
	call _demangle_type;
	R5  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$516;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$127; R2.H  = L$LC$127;
	call _dyn_string_insert_cstr;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$513;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P2  =R5 ;
	R5  =[P2 ];
L$L$513:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$516;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2  =R4 ;
	call _dyn_string_insert;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$516;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P2  =R5 ;
	R5  =[P2 ];
L$L$516:
	R0  =R4 ;
	call _dyn_string_delete;
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$519;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2  = 32 (X);
	call _dyn_string_insert_char;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$521;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P2  =R5 ;
	R5  =[P2 ];
L$L$521:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$519;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2  =R6 ;
	call _dyn_string_insert;
L$L$519:
	R0  =R6 ;
	call _dyn_string_delete;
	R0  =R5 ;
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$392;
	jump.s L$L$411;
L$L$527:
	R0.L  = L$LC$115; R0.H  = L$LC$115;
	jump.s L$L$392;
L$L$411:
	R0  = 0 (X);
L$L$392:
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$128:
.dw	0x6e69;
.dw	0x632d;
.dw	0x6168;
.dw	0x6772;
.db	0x65;
.db	0x00;
.align 2
L$LC$129:
.dw	0x6f6e;
.dw	0x2d74;
.dw	0x6e69;
.dw	0x632d;
.dw	0x6168;
.dw	0x6772;
.db	0x65;
.db	0x00;
.align 2
L$LC$130:
.dw	0x6c61;
.dw	0x6f6c;
.dw	0x6163;
.dw	0x6974;
.dw	0x676e;
.db	0x00;
.align 2
L_ctor_flavors_$2:	.long	L$LC$128
	.long	L$LC$129
	.long	L$LC$130
.align 2
L$LC$131:
.dw	0x6e69;
.dw	0x632d;
.dw	0x6168;
.dw	0x6772;
.dw	0x2065;
.dw	0x6564;
.dw	0x656c;
.dw	0x6974;
.dw	0x676e;
.db	0x00;
.align 2
L_dtor_flavors_$3:	.long	L$LC$131
	.long	L$LC$128
	.long	L$LC$129
.align 2
L$LC$132:
.dw	0x6e55;
.dw	0x6572;
.dw	0x6f63;
.dw	0x6e67;
.dw	0x7a69;
.dw	0x6465;
.dw	0x6320;
.dw	0x6e6f;
.dw	0x7473;
.dw	0x7572;
.dw	0x7463;
.dw	0x726f;
.db	0x2e;
.db	0x00;
.align 2
L$LC$133:
.db	0x5b;
.db	0x00;
.align 2
L$LC$134:
.dw	0x6e55;
.dw	0x6572;
.dw	0x6f63;
.dw	0x6e67;
.dw	0x7a69;
.dw	0x6465;
.dw	0x6420;
.dw	0x7365;
.dw	0x7274;
.dw	0x6375;
.dw	0x6f74;
.dw	0x2e72;
.db	0x00;
.align 2
L$LC$135:
.dw	0x5b20;
.db	0x00;
.align 2
.type _demangle_ctor_dtor_name, STT_FUNC;
_demangle_ctor_dtor_name:
	LINK 8;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	P2  =[P5 +4];
	R1  = B [P2 ] (X);
	R0  = R1.B  (X);
	R2  = 67 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$531;
	P2 +=1;
	[P5 +4] =P2 ;
	P1  = 4 (X);
	P1 =P1 +P5 ; //immed->Preg 
	R6  = B [P2 ++] (X);
	[P1 ] =P2 ;
	R1  = -49 (X);
	R1 =R1 +R6 ; //immed->Dreg 
	R0.L  = L$LC$132; R0.H  = L$LC$132;
	cc =R1 <=2 (iu);
	if cc jump 6; jump.l L$L$530;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  =[P5 +28];
	call _dyn_string_insert;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$535;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$535:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$530;
	R0  = 50 (X);
	cc =R6 ==R0 ;
	if !cc jump 6; jump.l L$L$539;
	cc =R6 <=R0 ;
	if cc jump 6; jump.l L$L$543;
	R2  = 49 (X);
	cc =R6 ==R2 ;
	if !cc jump 6; jump.l L$L$538;
	jump.s L$L$537;
L$L$543:
	R0  = 51 (X);
	cc =R6 ==R0 ;
	if !cc jump 6; jump.l L$L$540;
	jump.s L$L$537;
L$L$538:
	R2  = 1 (X);
	[P5 +36] =R2 ;
	jump.s L$L$537;
L$L$539:
	P2  = 2 (X);
	[P5 +36] =P2 ;
	jump.s L$L$537;
L$L$540:
	R0  = 3 (X);
	[P5 +36] =R0 ;
L$L$537:
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$557;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$133; R2.H  = L$LC$133;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$547;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$547:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$530;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	P2  =R6 ;
	P2  =P2 <<2;
	R6  =P2 ;
	R2.L  = L_ctor_flavors_$2-196; R2.H  = L_ctor_flavors_$2-196;
	R2 =R2 +R6 ; //immed->Dreg 
	P2  =R2 ;
	R2  =[P2 ];
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$551;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$551:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$530;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 93 (X);
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$555;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$555:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$530;
	jump.s L$L$557;
L$L$531:
	R1  = R1.B  (X);
	R0.L  = L$LC$11; R0.H  = L$LC$11;
	R2  = 68 (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$530;
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	P1  = 4 (X);
	P1 =P1 +P5 ; //immed->Preg 
	P2  =R0 ;
	R6  = B [P2 ++] (X);
	[P1 ] =P2 ;
	R1  = -48 (X);
	R1 =R1 +R6 ; //immed->Dreg 
	R0.L  = L$LC$134; R0.H  = L$LC$134;
	cc =R1 <=2 (iu);
	if cc jump 6; jump.l L$L$530;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 126 (X);
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$562;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$562:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$530;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  =[P5 +28];
	call _dyn_string_insert;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$566;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$566:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$530;
	R0  = 49 (X);
	cc =R6 ==R0 ;
	if !cc jump 6; jump.l L$L$570;
	cc =R6 <=R0 ;
	if cc jump 6; jump.l L$L$574;
	R2  = 48 (X);
	cc =R6 ==R2 ;
	if !cc jump 6; jump.l L$L$569;
	jump.s L$L$568;
L$L$574:
	R0  = 50 (X);
	cc =R6 ==R0 ;
	if !cc jump 6; jump.l L$L$571;
	jump.s L$L$568;
L$L$569:
	R2  = 1 (X);
	[P5 +40] =R2 ;
	jump.s L$L$568;
L$L$570:
	P2  = 2 (X);
	[P5 +40] =P2 ;
	jump.s L$L$568;
L$L$571:
	R0  = 3 (X);
	[P5 +40] =R0 ;
L$L$568:
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$557;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$135; R2.H  = L$LC$135;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$578;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$578:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$530;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	P2  =R6 ;
	P2  =P2 <<2;
	R6  =P2 ;
	R2.L  = L_dtor_flavors_$3-192; R2.H  = L_dtor_flavors_$3-192;
	R2 =R2 +R6 ; //immed->Dreg 
	P2  =R2 ;
	R2  =[P2 ];
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$582;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$582:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$530;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 93 (X);
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$586;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$586:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$530;
L$L$557:
	R0  = 0 (X);
L$L$530:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$136:
.dw	0x3a3a;
.db	0x2a;
.db	0x00;
.align 2
.type _demangle_type_ptr, STT_FUNC;
_demangle_type_ptr:
	LINK 0;
	[--sp] = ( r7:4, p5:3 );
	P4  =R0 ;
	P5  =R1 ;
	[FP +16] =R2 ;
	R5  =R2 ;
	R6  = 1 (X);
	P1  =[P4 +4];
	R0  = B [P1 ] (X);
	P1  =R0 ;
	P2  = -65 (X);
	P2 =P2 +P1 ; //immed->Preg 
	P1  =P2 ;
	P2  = 17 (X);
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$636;
P2.L =L$L$639;
P2.H =L$L$639;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$639:
	.dd		L$L$633;
	.dd		L$L$636;
	.dd		L$L$636;
	.dd		L$L$636;
	.dd		L$L$636;
	.dd		L$L$626;
	.dd		L$L$636;
	.dd		L$L$636;
	.dd		L$L$636;
	.dd		L$L$636;
	.dd		L$L$636;
	.dd		L$L$636;
	.dd		L$L$606;
	.dd		L$L$636;
	.dd		L$L$636;
	.dd		L$L$591;
	.dd		L$L$636;
	.dd		L$L$599;
L$L$591:
	R0  =[P4 +4];
	R0 +=1;
	[P4 +4] =R0 ;
	R0  =P4 ;
	call _demangle_type_ptr;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$589;
	R0  =[P4 +32];
	R1  = 4 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$644;
	R0  =[P4 +8];
	R2  = 42 (X);
	R1  =[P5 ];
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$597;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$597:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$589;
	jump.s L$L$644;
L$L$599:
	R0  =[P4 +4];
	R0 +=1;
	[P4 +4] =R0 ;
	R0  =P4 ;
	call _demangle_type_ptr;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$589;
	R0  =[P4 +8];
	R2  = 38 (X);
	R1  =[P5 ];
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$604;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$604:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$589;
	jump.s L$L$644;
L$L$606:
	R0  =[P4 +4];
	R0 +=1;
	[P4 +4] =R0 ;
	R0  =P4 ;
	call _result_push;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$589;
	R0  =P4 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$589;
	R0  =P4 ;
	call _result_pop;
	P3  =R0 ;
	P2  =[P4 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 70 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$611;
	R2  =R5 ;
	R0  =P4 ;
	R1  =P5 ;
	call _demangle_type_ptr;
	jump.s L$L$643;
L$L$611:
	P2  =[P4 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 65 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$613;
	R0  =P4 ;
	R1  =P5 ;
	call _demangle_array_type;
L$L$643:
	R4  =R0 ;
	jump.s L$L$612;
L$L$613:
	R0  =P4 ;
	call _demangle_type;
	R4  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$615;
	R0  =P4 ;
	call _result_previous_char_is_space;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$615;
	R0  =[P4 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 32 (X);
	call _dyn_string_insert_char;
	R4  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$615;
	R4.L  = _status_allocation_failed; R4.H  = _status_allocation_failed;
	P1  =R4 ;
	R4  =[P1 ];
L$L$615:
	P2  =[P4 +8];
	R0  =[P2 +4];
	P2  =[P2 +12];
	R1  =P2 ;
	R0 =R0 +R1 ;
	[P5 ] =R0 ;
L$L$612:
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$621;
	R0  =[P4 +8];
	R2.L  = L$LC$136; R2.H  = L$LC$136;
	R1  =[P5 ];
	call _dyn_string_insert_cstr;
	R4  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$618;
	R4.L  = _status_allocation_failed; R4.H  = _status_allocation_failed;
	P1  =R4 ;
	R4  =[P1 ];
L$L$618:
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$621;
	R0  =[P4 +8];
	R2  =P3 ;
	R1  =[P5 ];
	call _dyn_string_insert;
	R4  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$621;
	R4.L  = _status_allocation_failed; R4.H  = _status_allocation_failed;
	P2  =R4 ;
	R4  =[P2 ];
L$L$621:
	R1  =[P5 ];
	R0  =[P3 +4];
	R0 =R1 +R0 ;
	R0 +=3;
	[P5 ] =R0 ;
	R0  =P3 ;
	call _dyn_string_delete;
	R0  =R4 ;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$589;
	jump.s L$L$590;
L$L$626:
	P2  =[P4 +8];
	R0  =[P2 +4];
	P2  =[P2 +12];
	R1  =P2 ;
	R0 =R0 +R1 ;
	[P5 ] =R0 ;
	R0  =[P4 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$25; R2.H  = L$LC$25;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$629;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$629:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$589;
	R0  =P4 ;
	R1  =P5 ;
	call _demangle_function_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$589;
L$L$644:
	R0  =[P5 ];
	R0 +=1;
	[P5 ] =R0 ;
	jump.s L$L$590;
L$L$633:
	R0  =P4 ;
	call _demangle_array_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$589;
	jump.s L$L$590;
L$L$636:
	R0  =P4 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$589;
	P2  =[P4 +8];
	R0  =[P2 +4];
	P2  =[P2 +12];
	R1  =P2 ;
	R0 =R0 +R1 ;
	[P5 ] =R0 ;
	R6  = 0 (X);
L$L$590:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$640;
	R2  = 0 (X);
	R0  =P4 ;
	R1  =R5 ;
	call _substitution_add;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$589;
L$L$640:
	R0  = 0 (X);
L$L$589:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$137:
.dw	0x6f4e;
.dw	0x2d6e;
.dw	0x6f70;
.dw	0x6e69;
.dw	0x6574;
.dw	0x2072;
.dw	0x726f;
.dw	0x2d20;
.dw	0x6572;
.dw	0x6566;
.dw	0x6572;
.dw	0x636e;
.dw	0x2065;
.dw	0x7566;
.dw	0x636e;
.dw	0x6974;
.dw	0x6e6f;
.dw	0x7420;
.dw	0x7079;
.dw	0x2e65;
.db	0x00;
.align 2
L$LC$138:
.dw	0x6f63;
.dw	0x706d;
.dw	0x656c;
.dw	0x2078;
.db	0x00;
.align 2
L$LC$139:
.dw	0x6d69;
.dw	0x6761;
.dw	0x6e69;
.dw	0x7261;
.dw	0x2079;
.db	0x00;
.align 2
L$LC$140:
.dw	0x6e55;
.dw	0x7865;
.dw	0x6570;
.dw	0x7463;
.dw	0x6465;
.dw	0x6320;
.dw	0x6168;
.dw	0x6172;
.dw	0x7463;
.dw	0x7265;
.dw	0x6920;
.dw	0x206e;
.dw	0x743c;
.dw	0x7079;
.dw	0x3e65;
.db	0x2e;
.db	0x00;
.align 2
.type _demangle_type, STT_FUNC;
_demangle_type:
	LINK 12;
	[--sp] = ( r7:4, p5:3 );
	P4  =R0 ;
	call _substitution_start;
	P5  =R0 ;
	P2  =[P4 +4];
	R6  = B [P2 ] (X);
	R0  = 0 (X);
	[FP +-4] =R0 ;
	R0  =P4 ;
	call _current_template_arg_list;
	R4  =R0 ;
	R5  = 1 (X);
	R0  =R6 ;
	R0 +=-48;
	R0  = R0.B  (Z);
	R1  = 9 (X);
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$647;
	R0  = R6.B  (X);
	R2  = 78 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$647;
	R1  = 90 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$646;
L$L$647:
	R0  =P4 ;
	R1  =FP ;
	R1 +=-4;
	call _demangle_class_enum_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	jump.s L$L$650;
L$L$646:
	R0  =R6 ;
	R2  = -97 (X);
	R2 =R2 +R0 ; //immed->Dreg 
	R0  = R2.B  (Z);
	R1  = 25 (X);
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$651;
	R0  = R6.B  (X);
	R1  = 114 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$651;
	R0  =P4 ;
	call _demangle_builtin_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	jump.s L$L$730;
L$L$651:
	R0  = R6.B  (X);
	R2  = -65 (X);
	R2 =R2 +R0 ; //immed->Dreg 
	P2  = 49 (X);
	P1  =R2 ;
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$725;
P2.L =L$L$726;
P2.H =L$L$726;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$726:
	.dd		L$L$671;
	.dd		L$L$725;
	.dd		L$L$702;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$670;
	.dd		L$L$709;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$658;
	.dd		L$L$725;
	.dd		L$L$699;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$699;
	.dd		L$L$725;
	.dd		L$L$699;
	.dd		L$L$682;
	.dd		L$L$674;
	.dd		L$L$716;
	.dd		L$L$658;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$725;
	.dd		L$L$658;
L$L$658:
	R0  = 24 (X);
	call _dyn_string_new;
	P3  =R0 ;
	R0  =P4 ;
	call _result_get_caret;
	[FP +-12] =R0 ;
	cc =P3 ==0;
	if cc jump 6; jump.l L$L$659;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$645;
L$L$659:
	R0  =P4 ;
	R1  =P3 ;
	call _demangle_CV_qualifiers;
	R0  =[P4 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  =P3 ;
	call _dyn_string_insert;
	R6  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$661;
	R6.L  = _status_allocation_failed; R6.H  = _status_allocation_failed;
	P1  =R6 ;
	R6  =[P1 ];
L$L$661:
	R0  =[P3 +4];
	R1  =-R0 ;
	R0  =P4 ;
	call _result_shift_caret;
	R0  =P3 ;
	call _dyn_string_delete;
	R0  =R6 ;
	cc =R6 ==0;
	if cc jump 6; jump.l L$L$645;
	R0  =[P4 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 32 (X);
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$666;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$666:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	R0  =P4 ;
	R1  = -1 (X);
	call _result_shift_caret;
	R0  =P4 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	R0  =P4 ;
	R1  =[FP +-12];
	call _result_set_caret;
	jump.s L$L$650;
L$L$670:
	R0.L  = L$LC$137; R0.H  = L$LC$137;
	jump.s L$L$645;
L$L$671:
	R0  =P4 ;
	R1  = 0 (X);
	call _demangle_array_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	jump.s L$L$650;
L$L$674:
	R0  =P4 ;
	call _demangle_template_param;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	R0  =[P4 +4];
	P1  =R0 ;
	R0  = B [P1 ] (X);
	R1  = 73 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$650;
	R2  =[FP +-4];
	R0  =P4 ;
	R1  =P5 ;
	call _substitution_add;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	R0  =P4 ;
	call _demangle_template_args;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	jump.s L$L$650;
L$L$682:
	P2  =[P4 +4];
	R0  = B [P2 ] (X);
	R1  = 0 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$684;
	R1  = B [P2 +1] (X);
L$L$684:
	R0  =R1 ;
	R0 +=-48;
	R0  = R0.B  (Z);
	R2  = 9 (X);
	cc =R0 <=R2  (iu);
	if !cc jump 6; jump.l L$L$686;
	R0  = R1.B  (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$685;
L$L$686:
	R0  =P4 ;
	R1  =FP ;
	R1 +=-4;
	call _demangle_substitution;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	R0  =[P4 +4];
	P1  =R0 ;
	R0  = B [P1 ] (X);
	R1  = 73 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$730;
	R0  =P4 ;
	call _demangle_template_args;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	jump.s L$L$650;
L$L$685:
	R6  =[P4 +4];
	R0  =P4 ;
	R1  =FP ;
	R1 +=-4;
	call _demangle_class_enum_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	R6 +=2;
	R0  =[P4 +4];
	cc =R0 ==R6 ;
	if cc jump 6; jump.l L$L$650;
	jump.s L$L$730;
L$L$699:
	R2  =P5 ;
	R0  =P4 ;
	R1  =FP ;
	R1 +=-8;
	call _demangle_type_ptr;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
L$L$730:
	R5  = 0 (X);
	jump.s L$L$650;
L$L$702:
	R0  =[P4 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$138; R2.H  = L$LC$138;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$705;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$705:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	R0  =[P4 +4];
	R0 +=1;
	[P4 +4] =R0 ;
	R0  =P4 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	jump.s L$L$650;
L$L$709:
	R0  =[P4 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$139; R2.H  = L$LC$139;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$712;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$712:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	R0  =[P4 +4];
	R0 +=1;
	[P4 +4] =R0 ;
	R0  =P4 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	jump.s L$L$650;
L$L$716:
	R0  =[P4 +4];
	R0 +=1;
	[P4 +4] =R0 ;
	R0  =P4 ;
	call _demangle_source_name;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	R0  =[P4 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2  = 32 (X);
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$721;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$721:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	R0  =P4 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
	jump.s L$L$650;
L$L$725:
	R0.L  = L$LC$140; R0.H  = L$LC$140;
	jump.s L$L$645;
L$L$650:
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$727;
	R2  =[FP +-4];
	R0  =P4 ;
	R1  =P5 ;
	call _substitution_add;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$645;
L$L$727:
	R0  =P4 ;
	R1  =R4 ;
	call _pop_to_template_arg_list;
	R0  = 0 (X);
L$L$645:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$141:
.dw	0x6973;
.dw	0x6e67;
.dw	0x6465;
.dw	0x6320;
.dw	0x6168;
.db	0x72;
.db	0x00;
.align 2
L$LC$142:
.dw	0x6f62;
.dw	0x6c6f;
.db	0x00;
.align 2
L$LC$143:
.dw	0x6863;
.dw	0x7261;
.db	0x00;
.align 2
L$LC$144:
.dw	0x6f64;
.dw	0x6275;
.dw	0x656c;
.db	0x00;
.align 2
L$LC$145:
.dw	0x6f6c;
.dw	0x676e;
.dw	0x6420;
.dw	0x756f;
.dw	0x6c62;
.db	0x65;
.db	0x00;
.align 2
L$LC$146:
.dw	0x6c66;
.dw	0x616f;
.db	0x74;
.db	0x00;
.align 2
L$LC$147:
.dw	0x5f5f;
.dw	0x6c66;
.dw	0x616f;
.dw	0x3174;
.dw	0x3832;
.db	0x00;
.align 2
L$LC$148:
.dw	0x6e75;
.dw	0x6973;
.dw	0x6e67;
.dw	0x6465;
.dw	0x6320;
.dw	0x6168;
.db	0x72;
.db	0x00;
.align 2
L$LC$149:
.dw	0x6e69;
.db	0x74;
.db	0x00;
.align 2
L$LC$150:
.dw	0x6e75;
.dw	0x6973;
.dw	0x6e67;
.dw	0x6465;
.db	0x00;
.align 2
L$LC$151:
.dw	0x6f6c;
.dw	0x676e;
.db	0x00;
.align 2
L$LC$152:
.dw	0x6e75;
.dw	0x6973;
.dw	0x6e67;
.dw	0x6465;
.dw	0x6c20;
.dw	0x6e6f;
.db	0x67;
.db	0x00;
.align 2
L$LC$153:
.dw	0x5f5f;
.dw	0x6e69;
.dw	0x3174;
.dw	0x3832;
.db	0x00;
.align 2
L$LC$154:
.dw	0x6e75;
.dw	0x6973;
.dw	0x6e67;
.dw	0x6465;
.dw	0x5f20;
.dw	0x695f;
.dw	0x746e;
.dw	0x3231;
.db	0x38;
.db	0x00;
.align 2
L$LC$155:
.dw	0x6873;
.dw	0x726f;
.db	0x74;
.db	0x00;
.align 2
L$LC$156:
.dw	0x6e75;
.dw	0x6973;
.dw	0x6e67;
.dw	0x6465;
.dw	0x7320;
.dw	0x6f68;
.dw	0x7472;
.db	0x00;
.align 2
L$LC$157:
.dw	0x6f76;
.dw	0x6469;
.db	0x00;
.align 2
L$LC$158:
.dw	0x6377;
.dw	0x6168;
.dw	0x5f72;
.db	0x74;
.db	0x00;
.align 2
L$LC$159:
.dw	0x6f6c;
.dw	0x676e;
.dw	0x6c20;
.dw	0x6e6f;
.db	0x67;
.db	0x00;
.align 2
L$LC$160:
.dw	0x6e75;
.dw	0x6973;
.dw	0x6e67;
.dw	0x6465;
.dw	0x6c20;
.dw	0x6e6f;
.dw	0x2067;
.dw	0x6f6c;
.dw	0x676e;
.db	0x00;
.align 2
L$LC$161:
.dw	0x2e2e;
.db	0x2e;
.db	0x00;
.align 2
_builtin_type_names:	.long	L$LC$141
	.long	L$LC$142
	.long	L$LC$143
	.long	L$LC$144
	.long	L$LC$145
	.long	L$LC$146
	.long	L$LC$147
	.long	L$LC$148
	.long	L$LC$149
	.long	L$LC$150
	.long	0
	.long	L$LC$151
	.long	L$LC$152
	.long	L$LC$153
	.long	L$LC$154
	.long	0
	.long	0
	.long	0
	.long	L$LC$155
	.long	L$LC$156
	.long	0
	.long	L$LC$157
	.long	L$LC$158
	.long	L$LC$159
	.long	L$LC$160
	.long	L$LC$161
.align 2
L$LC$162:
.dw	0x6f62;
.dw	0x6c6f;
.dw	0x6165;
.db	0x6e;
.db	0x00;
.align 2
L$LC$163:
.dw	0x7962;
.dw	0x6574;
.db	0x00;
.align 2
_java_builtin_type_names:	.long	L$LC$141
	.long	L$LC$162
	.long	L$LC$163
	.long	L$LC$144
	.long	L$LC$145
	.long	L$LC$146
	.long	L$LC$147
	.long	L$LC$148
	.long	L$LC$149
	.long	L$LC$150
	.long	0
	.long	L$LC$151
	.long	L$LC$152
	.long	L$LC$153
	.long	L$LC$154
	.long	0
	.long	0
	.long	0
	.long	L$LC$155
	.long	L$LC$156
	.long	0
	.long	L$LC$157
	.long	L$LC$143
	.long	L$LC$151
	.long	L$LC$160
	.long	L$LC$161
.align 2
L$LC$165:
.dw	0x6f4e;
.dw	0x2d6e;
.dw	0x6c61;
.dw	0x6870;
.dw	0x6261;
.dw	0x7465;
.dw	0x6369;
.dw	0x3c20;
.dw	0x7562;
.dw	0x6c69;
.dw	0x6974;
.dw	0x2d6e;
.dw	0x7974;
.dw	0x6570;
.dw	0x203e;
.dw	0x6f63;
.dw	0x6564;
.db	0x2e;
.db	0x00;
.align 2
L$LC$164:
.dw	0x6e55;
.dw	0x6572;
.dw	0x6f63;
.dw	0x6e67;
.dw	0x7a69;
.dw	0x6465;
.dw	0x3c20;
.dw	0x7562;
.dw	0x6c69;
.dw	0x6974;
.dw	0x2d6e;
.dw	0x7974;
.dw	0x6570;
.dw	0x203e;
.dw	0x6f63;
.dw	0x6564;
.db	0x2e;
.db	0x00;
.align 2
.type _demangle_builtin_type, STT_FUNC;
_demangle_builtin_type:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	P2  =[P5 +4];
	R2  = B [P2 ] (X);
	R0  = R2.B  (X);
	R1  = 117 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$732;
	P2 +=1;
	[P5 +4] =P2 ;
	R0  =P5 ;
	call _demangle_source_name;
	R1  = 0 (X);
	cc =R0 ==0;
	if !cc R1  =R0 ; /* movsicc-1a */
	jump.s L$L$731;
L$L$732:
	R0  =R2 ;
	R3  = -97 (X);
	R3 =R3 +R0 ; //immed->Dreg 
	R0  = R3.B  (Z);
	R1.L  = L$LC$165; R1.H  = L$LC$165;
	R3  = 25 (X);
	cc =R0 <=R3  (iu);
	if cc jump 6; jump.l L$L$731;
	R0  =[P5 +32];
	R1  = 4 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$737;
	R0  = R2.B  (X);
	P2  =R0 ;
	P2  =P2 <<2;
	R0  =P2 ;
	R1.L  = _java_builtin_type_names-388; R1.H  = _java_builtin_type_names-388;
	R1 =R1 +R0 ; //immed->Dreg 
	jump.s L$L$745;
L$L$737:
	R0  = R2.B  (X);
	P2  =R0 ;
	P2  =P2 <<2;
	R0  =P2 ;
	R1.L  = _builtin_type_names-388; R1.H  = _builtin_type_names-388;
	R1 =R1 +R0 ; //immed->Dreg 
L$L$745:
	P2  =R1 ;
	R2  =[P2 ];
	R1.L  = L$LC$164; R1.H  = L$LC$164;
	cc =R2 ==0;
	if !cc jump 6; jump.l L$L$731;
	R0  =[P5 +8];
	P2  =R0 ;
	R3  =[P2 +4];
	R1  =[P2 +12];
	R1 =R3 +R1 ;
	call _dyn_string_insert_cstr;
	R1  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$742;
	R1.L  = _status_allocation_failed; R1.H  = _status_allocation_failed;
	P2  =R1 ;
	R1  =[P2 ];
L$L$742:
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$731;
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R1  = 0 (X);
L$L$731:
	R0  =R1 ;
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$166:
.dw	0x6572;
.dw	0x7473;
.dw	0x6972;
.dw	0x7463;
.db	0x00;
.align 2
L$LC$167:
.dw	0x6f76;
.dw	0x616c;
.dw	0x6974;
.dw	0x656c;
.db	0x00;
.align 2
L$LC$168:
.dw	0x6f63;
.dw	0x736e;
.db	0x74;
.db	0x00;
.align 2
.type _demangle_CV_qualifiers, STT_FUNC;
_demangle_CV_qualifiers:
	LINK 0;
	[--sp] = ( p5:3 );
	P3  =R0 ;
	P4  =R1 ;
	P5.L  = _status_allocation_failed; P5.H  = _status_allocation_failed;
L$L$763:
	P2  =[P3 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 86 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$754;
	cc =P2 <=P1 ;
	if cc jump 6; jump.l L$L$762;
	P1 +=-11;
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$757;
	jump.s L$L$760;
L$L$762:
	P1  = 114 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$760;
	R1  =[P4 +4];
	cc =R1 <=0;
	if !cc jump 6; jump.l L$L$752;
	R0  =[P4 +8];
	R1 =R0 +R1 ;
	P2  =R1 ;
	R1  = B [P2 +-1] (X);
	R0  = 32 (X);
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$752;
	R0  =P4 ;
	R1  = 32 (X);
	call _dyn_string_append_char;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$764;
L$L$752:
	R0  =P4 ;
	R1.L  = L$LC$166; R1.H  = L$LC$166;
	jump.s L$L$765;
L$L$754:
	R1  =[P4 +4];
	cc =R1 <=0;
	if !cc jump 6; jump.l L$L$755;
	R0  =[P4 +8];
	R1 =R0 +R1 ;
	P1  =R1 ;
	R1  = B [P1 +-1] (X);
	R0  = 32 (X);
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$755;
	R0  =P4 ;
	R1  = 32 (X);
	call _dyn_string_append_char;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$764;
L$L$755:
	R0  =P4 ;
	R1.L  = L$LC$167; R1.H  = L$LC$167;
	jump.s L$L$765;
L$L$757:
	R1  =[P4 +4];
	cc =R1 <=0;
	if !cc jump 6; jump.l L$L$758;
	R0  =[P4 +8];
	R1 =R0 +R1 ;
	P1  =R1 ;
	R1  = B [P1 +-1] (X);
	R0  = 32 (X);
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$758;
	R0  =P4 ;
	R1  = 32 (X);
	call _dyn_string_append_char;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$764;
L$L$758:
	R0  =P4 ;
	R1.L  = L$LC$168; R1.H  = L$LC$168;
L$L$765:
	call _dyn_string_append_cstr;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$750;
L$L$764:
	R0  =[P5 ];
	jump.s L$L$746;
L$L$760:
	R0  = 0 (X);
	jump.s L$L$746;
L$L$750:
	R0  =[P3 +4];
	R0 +=1;
	[P3 +4] =R0 ;
	jump.s L$L$763;
L$L$746:
	( p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$169:
.dw	0x5b20;
.dw	0x7865;
.dw	0x6574;
.dw	0x6e72;
.dw	0x2220;
.dw	0x2243;
.dw	0x205d;
.db	0x00;
.align 2
.type _demangle_function_type, STT_FUNC;
_demangle_function_type:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R6  =R1 ;
	R1  = 70 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$766;
	P2  =[P5 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 89 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$769;
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$770;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$169; R2.H  = L$LC$169;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$773;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$773:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$766;
L$L$770:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
L$L$769:
	R0  =P5 ;
	R1  =R6 ;
	call _demangle_bare_function_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$766;
	R0  =P5 ;
	R1  = 69 (X);
	call _demangle_char;
	R1  = 0 (X);
	cc =R0 ==0;
	if cc R0  =R1 ; /* movsicc-1b */
L$L$766:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$170:
.dw	0x202c;
.db	0x00;
.align 2
L$LC$171:
.dw	0x694d;
.dw	0x7373;
.dw	0x6e69;
.dw	0x2067;
.dw	0x7566;
.dw	0x636e;
.dw	0x6974;
.dw	0x6e6f;
.dw	0x7220;
.dw	0x7465;
.dw	0x7275;
.dw	0x206e;
.dw	0x7974;
.dw	0x6570;
.db	0x2e;
.db	0x00;
.align 2
L$LC$172:
.dw	0x694d;
.dw	0x7373;
.dw	0x6e69;
.dw	0x2067;
.dw	0x7566;
.dw	0x636e;
.dw	0x6974;
.dw	0x6e6f;
.dw	0x7020;
.dw	0x7261;
.dw	0x6d61;
.dw	0x7465;
.dw	0x7265;
.db	0x2e;
.db	0x00;
.align 2
.type _demangle_bare_function_type, STT_FUNC;
_demangle_bare_function_type:
	LINK 0;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	P4  =R1 ;
	R0  = 0 (X);
	R6  = -1 (X);
	cc =P4 ==0;
	if cc R6  =R0 ; /* movsicc-2a */
	R0  =[P3 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2  = 40 (X);
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$784;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$784:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$779;
	P2  =[P3 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$787;
	P1  = 69 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$787;
	P5.L  = _status_allocation_failed; P5.H  = _status_allocation_failed;
L$L$811:
	cc =R6 ==-1;
	if cc jump 6; jump.l L$L$790;
	R4  = 0 (X);
	R0  =P3 ;
	call _result_push;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$779;
	R0  =P3 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$779;
	R0  =P3 ;
	call _result_pop;
	R5  =R0 ;
	P2  =R0 ;
	R1  =[P2 +4];
	cc =R1 <=0;
	if !cc jump 6; jump.l L$L$795;
	R0  =[P2 +8];
	R1 =R0 +R1 ;
	P1  =R1 ;
	R1  = B [P1 +-1] (X);
	R0  = 32 (X);
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$795;
	R0  =R5 ;
	R1  = 32 (X);
	call _dyn_string_append_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$795;
	R4  =[P5 ];
L$L$795:
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$796;
	R0  =[P3 +8];
	R2  =R5 ;
	R1  =[P4 ];
	call _dyn_string_insert;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$797;
	R4  =[P5 ];
	jump.s L$L$796;
L$L$797:
	R1  =[P4 ];
	P1  =R5 ;
	R0  =[P1 +4];
	R0 =R1 +R0 ;
	[P4 ] =R0 ;
L$L$796:
	R0  =R5 ;
	call _dyn_string_delete;
	R0  =R4 ;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$779;
	jump.s L$L$801;
L$L$790:
	P2  =[P3 +4];
	R0  = B [P2 ] (X);
	R1  = 118 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$802;
	P2 +=1;
	[P3 +4] =P2 ;
	jump.s L$L$801;
L$L$802:
	cc =R6 <=0;
	if !cc jump 6; jump.l L$L$804;
	R0  =[P3 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$170; R2.H  = L$LC$170;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$807;
	R0  =[P5 ];
L$L$807:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$779;
L$L$804:
	R0  =P3 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$779;
L$L$801:
	R6 +=1;
	P2  =[P3 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$787;
	P1  = 69 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$811;
L$L$787:
	R0  =[P3 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 41 (X);
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$814;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$814:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$779;
	R0.L  = L$LC$171; R0.H  = L$LC$171;
	cc =R6 ==-1;
	if !cc jump 6; jump.l L$L$779;
	R1.L  = L$LC$172; R1.H  = L$LC$172;
	R0  = 0 (X);
	cc =R6 ==0;
	if cc R0  =R1 ; /* movsicc-2a */
L$L$779:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _demangle_class_enum_type, STT_FUNC;
_demangle_class_enum_type:
	LINK 0;
	call _demangle_name;
	R1  = 0 (X);
	cc =R0 ==0;
	if cc R0  =R1 ; /* movsicc-1b */
	UNLINK;
	rts;


.align 2
L$LC$173:
.dw	0x2820;
.dw	0x2029;
.db	0x00;
.align 2
.type _demangle_array_type, STT_FUNC;
_demangle_array_type:
	LINK 0;
	[--sp] = ( r7:5, p5:4 );
	P5  =R0 ;
	P4  =R1 ;
	R5  = 0 (X);
	R6  = 0 (X);
	R1  = 65 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$827;
	P2  =[P5 +4];
	R1  = B [P2 ] (X);
	R0  = R1.B  (X);
	R2  = 95 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$831;
	R0  =R1 ;
	R0 +=-48;
	R0  = R0.B  (Z);
	R1  = 9 (X);
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$832;
	R0  = 10 (X);
	call _dyn_string_new;
	R6  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$833;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$827;
L$L$833:
	R2  = 0 (X);
	[SP +12] =R2 ;
	R2  = 10 (X);
	R0  =P5 ;
	R1  =R6 ;
	call _demangle_number_literally;
	R5  =R0 ;
	jump.s L$L$831;
L$L$832:
	R0  =P5 ;
	call _result_push;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$827;
	R0  =P5 ;
	call _demangle_expression;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$827;
	R0  =P5 ;
	call _result_pop;
	R6  =R0 ;
L$L$831:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$840;
	R0  =P5 ;
	R1  = 95 (X);
	call _demangle_char;
	R5  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$840;
	R0  =P5 ;
	call _demangle_type;
	R5  =R0 ;
L$L$840:
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$841;
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$842;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$173; R2.H  = L$LC$173;
	call _dyn_string_insert_cstr;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$842;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P2  =R5 ;
	R5  =[P2 ];
L$L$842:
	P2  =[P5 +8];
	R0  =[P2 +4];
	P2  =[P2 +12];
	R1  =P2 ;
	R0 =R0 +R1 ;
	R0 +=-2;
	[P4 ] =R0 ;
L$L$841:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$851;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 91 (X);
	call _dyn_string_insert_char;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$845;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P2  =R5 ;
	R5  =[P2 ];
L$L$845:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$851;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$848;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  =R6 ;
	call _dyn_string_insert;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$848;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P2  =R5 ;
	R5  =[P2 ];
L$L$848:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$851;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 93 (X);
	call _dyn_string_insert_char;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$851;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P2  =R5 ;
	R5  =[P2 ];
L$L$851:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$854;
	R0  =R6 ;
	call _dyn_string_delete;
L$L$854:
	R0  = 0 (X);
	cc =R5 ==0;
	if !cc R0  =R5 ; /* movsicc-1a */
L$L$827:
	( r7:5, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$174:
.dw	0x6554;
.dw	0x706d;
.dw	0x616c;
.dw	0x6574;
.dw	0x7020;
.dw	0x7261;
.dw	0x6d61;
.dw	0x7465;
.dw	0x7265;
.dw	0x6f20;
.dw	0x7475;
.dw	0x6973;
.dw	0x6564;
.dw	0x6f20;
.dw	0x2066;
.dw	0x6574;
.dw	0x706d;
.dw	0x616c;
.dw	0x6574;
.db	0x2e;
.db	0x00;
.align 2
L$LC$175:
.dw	0x6554;
.dw	0x706d;
.dw	0x616c;
.dw	0x6574;
.dw	0x7020;
.dw	0x7261;
.dw	0x6d61;
.dw	0x7465;
.dw	0x7265;
.dw	0x6e20;
.dw	0x6d75;
.dw	0x6562;
.dw	0x2072;
.dw	0x756f;
.dw	0x2074;
.dw	0x666f;
.dw	0x6220;
.dw	0x756f;
.dw	0x646e;
.dw	0x2e73;
.db	0x00;
.align 2
.type _demangle_template_param, STT_FUNC;
_demangle_template_param:
	LINK 4;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	call _current_template_arg_list;
	R6  =R0 ;
	R0.L  = L$LC$174; R0.H  = L$LC$174;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$857;
	R0  =P5 ;
	R1  = 84 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$857;
	P2  =[P5 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 95 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$861;
	P2  = 0 (X);
	[FP +-4] =P2 ;
	jump.s L$L$862;
L$L$861:
	R0  = 0 (X);
	[SP +12] =R0 ;
	R2  = 10 (X);
	R0  =P5 ;
	R1  =FP ;
	R1 +=-4;
	call _demangle_number;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$857;
	R0  =[FP +-4];
	R0 +=1;
	[FP +-4] =R0 ;
L$L$862:
	R0  =P5 ;
	R1  = 95 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$857;
	R1  =[FP +-4];
	R0  =R6 ;
	call _template_arg_list_get_arg;
	R2  =R0 ;
	R0.L  = L$LC$175; R0.H  = L$LC$175;
	cc =R2 ==0;
	if !cc jump 6; jump.l L$L$857;
	R0  =[P5 +8];
	P1  =R0 ;
	R3  =[P1 +4];
	R1  =[P1 +12];
	R1 =R3 +R1 ;
	call _dyn_string_insert;
	R1  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$870;
	R1.L  = _status_allocation_failed; R1.H  = _status_allocation_failed;
	P2  =R1 ;
	R1  =[P2 ];
L$L$870:
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc R0  =R1 ; /* movsicc-1a */
L$L$857:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _demangle_template_args, STT_FUNC;
_demangle_template_args:
	LINK 0;
	[--sp] = ( r7:4, p5:3 );
	P4  =R0 ;
	R4  = 1 (X);
	call _template_arg_list_new;
	R5  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$903;
	R6  =[P4 +28];
	R0  = 0 (X);
	call _dyn_string_new;
	[P4 +28] =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$874;
L$L$903:
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$872;
L$L$874:
	R0  =P4 ;
	R1  = 73 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$872;
	R0  =P4 ;
	R1  = 60 (X);
	call _result_add_separated_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$872;
	P5.L  = _status_allocation_failed; P5.H  = _status_allocation_failed;
L$L$879:
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$882;
	R4  = 0 (X);
	jump.s L$L$883;
L$L$882:
	R0  =[P4 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$170; R2.H  = L$LC$170;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$886;
	R0  =[P5 ];
L$L$886:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$872;
L$L$883:
	R0  =P4 ;
	call _result_push;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$872;
	R0  =P4 ;
	call _demangle_template_arg;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$872;
	R0  =P4 ;
	call _result_pop;
	P3  =R0 ;
	R0  =[P4 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  =P3 ;
	call _dyn_string_insert;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$894;
	R0  =[P5 ];
L$L$894:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$872;
	R0  =R5 ;
	R1  =P3 ;
	call _template_arg_list_add_arg;
	P2  =[P4 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 69 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$879;
	R0  =P4 ;
	R1  = 62 (X);
	call _result_add_separated_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$872;
	R0  =[P4 +4];
	R0 +=1;
	[P4 +4] =R0 ;
	R0  =[P4 +28];
	call _dyn_string_delete;
	[P4 +28] =R6 ;
	R0  =P4 ;
	R1  =R5 ;
	call _push_template_arg_list;
	R0  = 0 (X);
L$L$872:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$176:
.dw	0x6269;
.dw	0x2069;
.dw	0x2020;
.dw	0x6920;
.dw	0x6969;
.dw	0x6c20;
.dw	0x206c;
.dw	0x2020;
.dw	0x2020;
.dw	0x6969;
.dw	0x2020;
.dw	0x2069;
.db	0x20;
.db	0x00;
.align 2
L_code_map_$4:	.long	L$LC$176
.align 2
L$LC$177:
.dw	0x6e55;
.dw	0x6d69;
.dw	0x6c70;
.dw	0x6d65;
.dw	0x6e65;
.dw	0x6574;
.dw	0x2e64;
.db	0x00;
.align 2
L$LC$178:
.dw	0x6166;
.dw	0x736c;
.db	0x65;
.db	0x00;
.align 2
L$LC$180:
.dw	0x6e55;
.dw	0x6572;
.dw	0x6f63;
.dw	0x6e67;
.dw	0x7a69;
.dw	0x6465;
.dw	0x6220;
.dw	0x6f6f;
.dw	0x206c;
.dw	0x6f63;
.dw	0x736e;
.dw	0x6174;
.dw	0x746e;
.db	0x2e;
.db	0x00;
.align 2
L$LC$179:
.dw	0x7274;
.dw	0x6575;
.db	0x00;
.align 2
.type _demangle_literal, STT_FUNC;
_demangle_literal:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	P5  =R0 ;
	P2  =[P5 +4];
	R0  = B [P2 ] (X);
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$905;
	R0  = R0.B  (X);
	R1  = 96 (X);
	cc =R0 <=R1 ;
	if !cc jump 6; jump.l L$L$905;
	R2  = 122 (X);
	cc =R0 <=R2 ;
	if cc jump 6; jump.l L$L$905;
	P2.L  = L_code_map_$4; P2.H  = L_code_map_$4;
	P2  =[P2 ];
	R1  =P2 ;
	R0 =R1 +R0 ;
	P2  =R0 ;
	R6  = B [P2 +-97] (X);
	R1  = R6.B  (X);
	R0.L  = L$LC$177; R0.H  = L$LC$177;
	R2 +=-5;
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$904;
	R0  =R1 ;
	R1  = 98 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$907;
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	P2  =R0 ;
	R1  = B [P2 ] (X);
	R0  = R1.B  (X);
	R2  = 48 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$908;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$178; R2.H  = L$LC$178;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$911;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$911:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$904;
	jump.s L$L$913;
L$L$908:
	R1  = R1.B  (X);
	R0.L  = L$LC$180; R0.H  = L$LC$180;
	R2  = 49 (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$904;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$179; R2.H  = L$LC$179;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$917;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$917:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$904;
L$L$913:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  = 0 (X);
	jump.s L$L$904;
L$L$907:
	R0  = R6.B  (X);
	R1  = 105 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$922;
	R2  = 108 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$905;
L$L$922:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  = 0 (X);
	call _dyn_string_new;
	R5  =R0 ;
	P2  = 1 (X);
	[SP +12] =P2 ;
	R2  = 10 (X);
	R0  =P5 ;
	R1  =R5 ;
	call _demangle_number_literally;
	R4  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$923;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  =R5 ;
	call _dyn_string_insert;
	R4  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$923;
	R4.L  = _status_allocation_failed; R4.H  = _status_allocation_failed;
	P2  =R4 ;
	R4  =[P2 ];
L$L$923:
	R2  = R6.B  (X);
	R0  = 108 (X);
	cc =R2 ==R0 ;
	if cc jump 6; jump.l L$L$926;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$926;
	R0  =[P5 +8];
	P2  =R0 ;
	R3  =[P2 +4];
	R1  =[P2 +12];
	R1 =R3 +R1 ;
	call _dyn_string_insert_char;
	R4  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$926;
	R4.L  = _status_allocation_failed; R4.H  = _status_allocation_failed;
	P2  =R4 ;
	R4  =[P2 ];
L$L$926:
	R0  =R5 ;
	call _dyn_string_delete;
	R0  = 0 (X);
	cc =R4 ==0;
	if !cc R0  =R4 ; /* movsicc-1a */
	jump.s L$L$904;
L$L$905:
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 40 (X);
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$933;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$933:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$904;
	R0  =P5 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$904;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 41 (X);
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$939;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$939:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$904;
	R0  = 0 (X);
	call _dyn_string_new;
	R5  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$941;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$904;
L$L$941:
	R0  = 1 (X);
	[SP +12] =R0 ;
	R2  = 10 (X);
	R0  =P5 ;
	R1  =R5 ;
	call _demangle_number_literally;
	R6  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$942;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  =R5 ;
	call _dyn_string_insert;
	R6  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$942;
	R6.L  = _status_allocation_failed; R6.H  = _status_allocation_failed;
	P2  =R6 ;
	R6  =[P2 ];
L$L$942:
	R0  =R5 ;
	call _dyn_string_delete;
	R0  = 0 (X);
	cc =R6 ==0;
	if !cc R0  =R6 ; /* movsicc-1a */
L$L$904:
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _demangle_template_arg, STT_FUNC;
_demangle_template_arg:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	P2  =[P5 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 76 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$949;
	P1 +=12;
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$958;
	jump.s L$L$963;
L$L$949:
	R1  =[P5 +4];
	R1 +=1;
	[P5 +4] =R1 ;
	P2  =R1 ;
	R0  = B [P2 ] (X);
	R2  = 90 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$950;
	R1 +=1;
	[P5 +4] =R1 ;
	R0  =P5 ;
	call _demangle_encoding;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$947;
	jump.s L$L$953;
L$L$950:
	R0  =P5 ;
	call _demangle_literal;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$947;
L$L$953:
	R0  =P5 ;
	R1  = 69 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$947;
	jump.s L$L$948;
L$L$958:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =P5 ;
	call _demangle_expression;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$947;
	R0  =P5 ;
	R1  = 69 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$947;
	jump.s L$L$948;
L$L$963:
	R0  =P5 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$947;
L$L$948:
	R0  = 0 (X);
L$L$947:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$181:
.dw	0x283a;
.db	0x00;
.align 2
.type _demangle_expression, STT_FUNC;
_demangle_expression:
	LINK 8;
	[--sp] = ( r7:5, p5:5 );
	P5  =R0 ;
	P2  =[P5 +4];
	R1  = B [P2 ] (X);
	R0  = R1.B  (X);
	R2  = 76 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$969;
	R2 +=8;
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$968;
L$L$969:
	R0  =P5 ;
	call _demangle_expr_primary;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$967;
	jump.s L$L$972;
L$L$968:
	R0  = R1.B  (X);
	R1  = 115 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$973;
	P2  =[P5 +4];
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$973;
	R2  = B [P2 +1] (X);
	P2  =R2 ;
	P1  = 114 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$973;
	R0  =P5 ;
	call _demangle_scope_expression;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$967;
	jump.s L$L$972;
L$L$973:
	R5  = 0 (X);
	R0  =P5 ;
	call _result_push;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$967;
	P2  = -4 (X);
	P2 =P2 +FP ; //immed->Preg 
	[SP +12] =P2 ;
	R2  =FP ;
	R2 +=-8;
	R0  =P5 ;
	R1  = 1 (X);
	call _demangle_operator_name;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$967;
	R0  =P5 ;
	call _result_pop;
	R6  =R0 ;
	R0  =[FP +-8];
	cc =R0 <=1;
	if !cc jump 6; jump.l L$L$981;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 40 (X);
	call _dyn_string_insert_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$983;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P1  =R5 ;
	R5  =[P1 ];
L$L$983:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$988;
	R0  =P5 ;
	call _demangle_expression;
	R5  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$988;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 41 (X);
	call _dyn_string_insert_char;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$981;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P1  =R5 ;
	R5  =[P1 ];
L$L$981:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$988;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  =R6 ;
	call _dyn_string_insert;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$988;
	R5.L  = _status_allocation_failed; R5.H  = _status_allocation_failed;
	P1  =R5 ;
	R5  =[P1 ];
L$L$988:
	R0  =R6 ;
	call _dyn_string_delete;
	R0  =R5 ;
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$967;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2  = 40 (X);
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$995;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$995:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$967;
	R0  =[FP +-4];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$997;
	R0  =P5 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$967;
	jump.s L$L$1000;
L$L$997:
	R0  =P5 ;
	call _demangle_expression;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$967;
L$L$1000:
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2  = 41 (X);
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1005;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1005:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$967;
	R0  =[FP +-8];
	cc =R0 ==3;
	if cc jump 6; jump.l L$L$972;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$181; R2.H  = L$LC$181;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1010;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1010:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$967;
	R0  =P5 ;
	call _demangle_expression;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$967;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2  = 41 (X);
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1016;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1016:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$967;
L$L$972:
	R0  = 0 (X);
L$L$967:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _demangle_scope_expression, STT_FUNC;
_demangle_scope_expression:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	R1  = 115 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1018;
	R0  =P5 ;
	R1  = 114 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1018;
	R0  =P5 ;
	call _demangle_type;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1018;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$5; R2.H  = L$LC$5;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1027;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1027:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1018;
	R0  =P5 ;
	call _demangle_encoding;
	R1  = 0 (X);
	cc =R0 ==0;
	if cc R0  =R1 ; /* movsicc-1b */
L$L$1018:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _demangle_expr_primary, STT_FUNC;
_demangle_expr_primary:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	P2  =[P5 +4];
	R1  = B [P2 ] (X);
	R0  = R1.B  (X);
	R2  = 84 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1032;
	R0  =P5 ;
	call _demangle_template_param;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1031;
	jump.s L$L$1035;
L$L$1032:
	R1  = R1.B  (X);
	R0.L  = L$LC$11; R0.H  = L$LC$11;
	R2  = 76 (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$1031;
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	P2  =R0 ;
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1037;
	R0  =P5 ;
	call _demangle_mangled_name;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1031;
	jump.s L$L$1040;
L$L$1037:
	R0  =P5 ;
	call _demangle_literal;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1031;
L$L$1040:
	R0  =P5 ;
	R1  = 69 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1031;
L$L$1035:
	R0  = 0 (X);
L$L$1031:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$182:
.dw	0x7473;
.db	0x64;
.db	0x00;
.align 2
L$LC$183:
.dw	0x7473;
.dw	0x3a64;
.dw	0x613a;
.dw	0x6c6c;
.dw	0x636f;
.dw	0x7461;
.dw	0x726f;
.db	0x00;
.align 2
L$LC$184:
.dw	0x6c61;
.dw	0x6f6c;
.dw	0x6163;
.dw	0x6f74;
.db	0x72;
.db	0x00;
.align 2
L$LC$185:
.dw	0x7473;
.dw	0x3a64;
.dw	0x623a;
.dw	0x7361;
.dw	0x6369;
.dw	0x735f;
.dw	0x7274;
.dw	0x6e69;
.db	0x67;
.db	0x00;
.align 2
L$LC$186:
.dw	0x6162;
.dw	0x6973;
.dw	0x5f63;
.dw	0x7473;
.dw	0x6972;
.dw	0x676e;
.db	0x00;
.align 2
L$LC$187:
.dw	0x7473;
.dw	0x3a64;
.dw	0x733a;
.dw	0x7274;
.dw	0x6e69;
.db	0x67;
.db	0x00;
.align 2
L$LC$188:
.dw	0x7473;
.dw	0x6972;
.dw	0x676e;
.db	0x00;
.align 2
L$LC$189:
.dw	0x7473;
.dw	0x3a64;
.dw	0x623a;
.dw	0x7361;
.dw	0x6369;
.dw	0x735f;
.dw	0x7274;
.dw	0x6e69;
.dw	0x3c67;
.dw	0x6863;
.dw	0x7261;
.dw	0x202c;
.dw	0x7473;
.dw	0x3a64;
.dw	0x633a;
.dw	0x6168;
.dw	0x5f72;
.dw	0x7274;
.dw	0x6961;
.dw	0x7374;
.dw	0x633c;
.dw	0x6168;
.dw	0x3e72;
.dw	0x202c;
.dw	0x7473;
.dw	0x3a64;
.dw	0x613a;
.dw	0x6c6c;
.dw	0x636f;
.dw	0x7461;
.dw	0x726f;
.dw	0x633c;
.dw	0x6168;
.dw	0x3e72;
.dw	0x3e20;
.db	0x00;
.align 2
L$LC$190:
.dw	0x7473;
.dw	0x3a64;
.dw	0x693a;
.dw	0x7473;
.dw	0x6572;
.dw	0x6d61;
.db	0x00;
.align 2
L$LC$191:
.dw	0x7369;
.dw	0x7274;
.dw	0x6165;
.db	0x6d;
.db	0x00;
.align 2
L$LC$192:
.dw	0x7473;
.dw	0x3a64;
.dw	0x623a;
.dw	0x7361;
.dw	0x6369;
.dw	0x695f;
.dw	0x7473;
.dw	0x6572;
.dw	0x6d61;
.dw	0x633c;
.dw	0x6168;
.dw	0x2c72;
.dw	0x7320;
.dw	0x6474;
.dw	0x3a3a;
.dw	0x6863;
.dw	0x7261;
.dw	0x745f;
.dw	0x6172;
.dw	0x7469;
.dw	0x3c73;
.dw	0x6863;
.dw	0x7261;
.dw	0x203e;
.db	0x3e;
.db	0x00;
.align 2
L$LC$193:
.dw	0x6162;
.dw	0x6973;
.dw	0x5f63;
.dw	0x7369;
.dw	0x7274;
.dw	0x6165;
.db	0x6d;
.db	0x00;
.align 2
L$LC$194:
.dw	0x7473;
.dw	0x3a64;
.dw	0x6f3a;
.dw	0x7473;
.dw	0x6572;
.dw	0x6d61;
.db	0x00;
.align 2
L$LC$195:
.dw	0x736f;
.dw	0x7274;
.dw	0x6165;
.db	0x6d;
.db	0x00;
.align 2
L$LC$196:
.dw	0x7473;
.dw	0x3a64;
.dw	0x623a;
.dw	0x7361;
.dw	0x6369;
.dw	0x6f5f;
.dw	0x7473;
.dw	0x6572;
.dw	0x6d61;
.dw	0x633c;
.dw	0x6168;
.dw	0x2c72;
.dw	0x7320;
.dw	0x6474;
.dw	0x3a3a;
.dw	0x6863;
.dw	0x7261;
.dw	0x745f;
.dw	0x6172;
.dw	0x7469;
.dw	0x3c73;
.dw	0x6863;
.dw	0x7261;
.dw	0x203e;
.db	0x3e;
.db	0x00;
.align 2
L$LC$197:
.dw	0x6162;
.dw	0x6973;
.dw	0x5f63;
.dw	0x736f;
.dw	0x7274;
.dw	0x6165;
.db	0x6d;
.db	0x00;
.align 2
L$LC$198:
.dw	0x7473;
.dw	0x3a64;
.dw	0x693a;
.dw	0x736f;
.dw	0x7274;
.dw	0x6165;
.db	0x6d;
.db	0x00;
.align 2
L$LC$199:
.dw	0x6f69;
.dw	0x7473;
.dw	0x6572;
.dw	0x6d61;
.db	0x00;
.align 2
L$LC$200:
.dw	0x7473;
.dw	0x3a64;
.dw	0x623a;
.dw	0x7361;
.dw	0x6369;
.dw	0x695f;
.dw	0x736f;
.dw	0x7274;
.dw	0x6165;
.dw	0x3c6d;
.dw	0x6863;
.dw	0x7261;
.dw	0x202c;
.dw	0x7473;
.dw	0x3a64;
.dw	0x633a;
.dw	0x6168;
.dw	0x5f72;
.dw	0x7274;
.dw	0x6961;
.dw	0x7374;
.dw	0x633c;
.dw	0x6168;
.dw	0x3e72;
.dw	0x3e20;
.db	0x00;
.align 2
L$LC$201:
.dw	0x6162;
.dw	0x6973;
.dw	0x5f63;
.dw	0x6f69;
.dw	0x7473;
.dw	0x6572;
.dw	0x6d61;
.db	0x00;
.align 2
L$LC$202:
.dw	0x6e55;
.dw	0x6572;
.dw	0x6f63;
.dw	0x6e67;
.dw	0x7a69;
.dw	0x6465;
.dw	0x3c20;
.dw	0x7573;
.dw	0x7362;
.dw	0x6974;
.dw	0x7574;
.dw	0x6974;
.dw	0x6e6f;
.dw	0x2e3e;
.db	0x00;
.align 2
L$LC$203:
.dw	0x7553;
.dw	0x7362;
.dw	0x6974;
.dw	0x7574;
.dw	0x6974;
.dw	0x6e6f;
.dw	0x6e20;
.dw	0x6d75;
.dw	0x6562;
.dw	0x2072;
.dw	0x756f;
.dw	0x2074;
.dw	0x666f;
.dw	0x7220;
.dw	0x6e61;
.dw	0x6567;
.db	0x2e;
.db	0x00;
.align 2
.type _demangle_substitution, STT_FUNC;
_demangle_substitution:
	LINK 4;
	[--sp] = ( r7:6, p5:4 );
	P5  =R0 ;
	P4  =R1 ;
	R1  = 83 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1046;
	P1  =[P5 +4];
	R0  = B [P1 ] (X);
	P1  =R0 ;
	P2  = 95 (X);
	cc =P1 ==P2 ;
	if cc jump 6; jump.l L$L$1049;
	R0  = -1 (X);
	[FP +-4] =R0 ;
	jump.s L$L$1050;
L$L$1049:
	R0 +=-48;
	R0  = R0.B  (Z);
	R1  = 9 (X);
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$1052;
	R1  =P1 ;
	R0  = -65 (X);
	R0 =R0 +R1 ; //immed->Dreg 
	R1  = 25 (X);
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$1051;
L$L$1052:
	R0  = 0 (X);
	[SP +12] =R0 ;
	R2  = 36 (X);
	R0  =P5 ;
	R1  =FP ;
	R1 +=-4;
	call _demangle_number;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1046;
	jump.s L$L$1050;
L$L$1051:
	R6  = 0 (X);
	P2  = -97 (X);
	P2 =P2 +P1 ; //immed->Preg 
	P1  =P2 ;
	P2  = 19 (X);
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$1116;
P2.L =L$L$1117;
P2.H =L$L$1117;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$1117:
	.dd		L$L$1062;
	.dd		L$L$1067;
	.dd		L$L$1116;
	.dd		L$L$1105;
	.dd		L$L$1116;
	.dd		L$L$1116;
	.dd		L$L$1116;
	.dd		L$L$1116;
	.dd		L$L$1083;
	.dd		L$L$1116;
	.dd		L$L$1116;
	.dd		L$L$1116;
	.dd		L$L$1116;
	.dd		L$L$1116;
	.dd		L$L$1094;
	.dd		L$L$1116;
	.dd		L$L$1116;
	.dd		L$L$1116;
	.dd		L$L$1072;
	.dd		L$L$1057;
L$L$1057:
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$182; R2.H  = L$LC$182;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1060;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1060:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1046;
	jump.s L$L$1056;
L$L$1062:
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$183; R2.H  = L$LC$183;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1065;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1065:
	R6.L  = L$LC$184; R6.H  = L$LC$184;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1128;
	jump.s L$L$1046;
L$L$1067:
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$185; R2.H  = L$LC$185;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1070;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1070:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1046;
	R6.L  = L$LC$186; R6.H  = L$LC$186;
L$L$1128:
	R0  = 1 (X);
	jump.s L$L$1127;
L$L$1072:
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$1073;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$187; R2.H  = L$LC$187;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1076;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1076:
	R6.L  = L$LC$188; R6.H  = L$LC$188;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1111;
	jump.s L$L$1046;
L$L$1073:
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$189; R2.H  = L$LC$189;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1081;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1081:
	R6.L  = L$LC$186; R6.H  = L$LC$186;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1111;
	jump.s L$L$1046;
L$L$1083:
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$1084;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$190; R2.H  = L$LC$190;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1087;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1087:
	R6.L  = L$LC$191; R6.H  = L$LC$191;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1111;
	jump.s L$L$1046;
L$L$1084:
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$192; R2.H  = L$LC$192;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1092;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1092:
	R6.L  = L$LC$193; R6.H  = L$LC$193;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1111;
	jump.s L$L$1046;
L$L$1094:
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$1095;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$194; R2.H  = L$LC$194;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1098;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1098:
	R6.L  = L$LC$195; R6.H  = L$LC$195;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1111;
	jump.s L$L$1046;
L$L$1095:
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$196; R2.H  = L$LC$196;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1103;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1103:
	R6.L  = L$LC$197; R6.H  = L$LC$197;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1111;
	jump.s L$L$1046;
L$L$1105:
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$1106;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$198; R2.H  = L$LC$198;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1109;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1109:
	R6.L  = L$LC$199; R6.H  = L$LC$199;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1111;
	jump.s L$L$1046;
L$L$1106:
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$200; R2.H  = L$LC$200;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1114;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1114:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1046;
	R6.L  = L$LC$201; R6.H  = L$LC$201;
L$L$1111:
	R0  = 0 (X);
L$L$1127:
	[P4 ] =R0 ;
	jump.s L$L$1056;
L$L$1116:
	R0.L  = L$LC$202; R0.H  = L$LC$202;
	jump.s L$L$1046;
L$L$1056:
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$1118;
	R0  =[P5 +28];
	R1  =R6 ;
	call _dyn_string_copy_cstr;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1118;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$1046;
L$L$1118:
	R0  = 0 (X);
	jump.s L$L$1046;
L$L$1050:
	R0  =[FP +-4];
	R1  = 1 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R2  =P4 ;
	R0  =P5 ;
	call _substitution_get;
	R2  =R0 ;
	R0.L  = L$LC$203; R0.H  = L$LC$203;
	cc =R2 ==0;
	if !cc jump 6; jump.l L$L$1046;
	R0  =[P5 +8];
	P2  =R0 ;
	R3  =[P2 +4];
	R1  =[P2 +12];
	R1 =R3 +R1 ;
	call _dyn_string_insert;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1123;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1123:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1046;
	R0  =P5 ;
	R1  = 95 (X);
	call _demangle_char;
	R1  = 0 (X);
	cc =R0 ==0;
	if cc R0  =R1 ; /* movsicc-1b */
L$L$1046:
	( r7:6, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$204:
.dw	0x7473;
.dw	0x6972;
.dw	0x676e;
.dw	0x6c20;
.dw	0x7469;
.dw	0x7265;
.dw	0x6c61;
.db	0x00;
.align 2
.type _demangle_local_name, STT_FUNC;
_demangle_local_name:
	LINK 4;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	R1  = 90 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1129;
	R0  =P5 ;
	call _demangle_encoding;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1129;
	R0  =P5 ;
	R1  = 69 (X);
	call _demangle_char;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1129;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$5; R2.H  = L$LC$5;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1138;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1138:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1129;
	P2  =[P5 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 115 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$1140;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$204; R2.H  = L$LC$204;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1143;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1143:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1129;
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	R0  =P5 ;
	R1  = 0 (X);
	call _demangle_discriminator;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1129;
	jump.s L$L$1147;
L$L$1140:
	R0  =P5 ;
	R1  =FP ;
	R1 +=-4;
	call _demangle_name;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1129;
	R0  =P5 ;
	R1  = 1 (X);
	call _demangle_discriminator;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1129;
L$L$1147:
	R0  = 0 (X);
L$L$1129:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$205:
.dw	0x5b20;
.db	0x23;
.db	0x00;
.align 2
L$LC$206:
.dw	0x5b20;
.dw	0x3023;
.db	0x5d;
.db	0x00;
.align 2
.type _demangle_discriminator, STT_FUNC;
_demangle_discriminator:
	LINK 4;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	P2  =[P5 +4];
	R0  = B [P2 ] (X);
	R2  = 95 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1153;
	P2 +=1;
	[P5 +4] =P2 ;
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1154;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$205; R2.H  = L$LC$205;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1157;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1157:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1152;
L$L$1154:
	P2  =[P5 +4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P2 +=-48;
	R2  =P2 ;
	R2  = R2.B  (Z);
	P2  =R2 ;
	R0.L  = L$LC$11; R0.H  = L$LC$11;
	P1  = 9 (X);
	cc =P2 <=P1  (iu);
	if cc jump 6; jump.l L$L$1152;
	P2  = 0 (X);
	[SP +12] =P2 ;
	R2  = 10 (X);
	R0  =P5 ;
	R1  =FP ;
	R1 +=-4;
	call _demangle_number;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1152;
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1171;
	R0  =[FP +-4];
	R0 +=1;
	R1  =[P5 +8];
	call _int_to_dyn_string;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1152;
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1171;
	R0  =[P5 +8];
	P1  =R0 ;
	R2  =[P1 +4];
	R1  =[P1 +12];
	R1 =R2 +R1 ;
	R2  = 93 (X);
	call _dyn_string_insert_char;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1169;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1169:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1152;
	jump.s L$L$1171;
L$L$1153:
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1171;
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	P2  =[P2 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1171;
	R0  =[P5 +8];
	P2  =R0 ;
	R2  =[P2 +4];
	R1  =[P2 +12];
	R1 =R2 +R1 ;
	R2.L  = L$LC$206; R2.H  = L$LC$206;
	call _dyn_string_insert_cstr;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1176;
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
L$L$1176:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1152;
L$L$1171:
	R0  = 0 (X);
L$L$1152:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _cp_demangle, STT_FUNC;
_cp_demangle:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	P5  =R0 ;
	R4  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	call _strlen;
	cc =R0 <=2;
	if !cc jump 6; jump.l L$L$1179;
	R0  = B [P5 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1179;
	R0  = B [P5 +1] (X);
	R1 +=-5;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1179;
	R0  =P5 ;
	R1  =R6 ;
	call _demangling_new;
	P5  =R0 ;
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$1186;
	call _result_push;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1181;
	R0  =P5 ;
	call _demangling_delete;
	R0  =R6 ;
	jump.s L$L$1178;
L$L$1181:
	R0  =P5 ;
	call _demangle_mangled_name;
	R5  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1182;
	R0  =P5 ;
	call _result_pop;
	R6  =R0 ;
	R0  =R4 ;
	R1  =R6 ;
	call _dyn_string_copy;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1186;
	R0  =R6 ;
	call _dyn_string_delete;
L$L$1182:
	R0  =P5 ;
	call _demangling_delete;
	jump.s L$L$1184;
L$L$1179:
	R0  =R4 ;
	R1  =P5 ;
	call _dyn_string_copy_cstr;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1184;
L$L$1186:
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$1178;
L$L$1184:
	R0  =R5 ;
L$L$1178:
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _cp_demangle_type, STT_FUNC;
_cp_demangle_type:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	P5  =R1 ;
	R1  = 16384 (X);
	call _demangling_new;
	R4  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1192;
	call _result_push;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1189;
	R0  =R4 ;
	call _demangling_delete;
	R0  =R6 ;
	jump.s L$L$1187;
L$L$1189:
	R0  =R4 ;
	call _demangle_type;
	R5  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1190;
	R0  =R4 ;
	call _result_pop;
	R6  =R0 ;
	R0  =P5 ;
	R1  =R6 ;
	call _dyn_string_copy;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1191;
L$L$1192:
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	R0  =[P2 ];
	jump.s L$L$1187;
L$L$1191:
	R0  =R6 ;
	call _dyn_string_delete;
L$L$1190:
	R0  =R4 ;
	call _demangling_delete;
	R0  =R5 ;
L$L$1187:
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$207:
.dw	0x654d;
.dw	0x6f6d;
.dw	0x7972;
.dw	0x6120;
.dw	0x6c6c;
.dw	0x636f;
.dw	0x7461;
.dw	0x6f69;
.dw	0x206e;
.dw	0x6166;
.dw	0x6c69;
.dw	0x6465;
.dw	0x0a2e;
.db	0x00;
.align 2
.global _cplus_demangle_v3;
.type _cplus_demangle_v3, STT_FUNC;
_cplus_demangle_v3:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	P5  =R0 ;
	R6  =R1 ;
	R6  >>=4;
	R0  = 1 (X);
	R6  =R6 &R0 ;
	R0  = B [P5 ] (X);
	R2  = 95 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1194;
	R0  = B [P5 +1] (X);
	R2 +=-5;
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1194;
	R6  = 0 (X);
	jump.s L$L$1195;
L$L$1194:
	R0  = 0 (X);
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$1193;
L$L$1195:
	P2.L  = _flag_verbose; P2.H  = _flag_verbose;
	R1  >>=3;
	R0  = 1 (X);
	R0  =R1 &R0 ;
	[P2 ] =R0 ;
	R0  = 0 (X);
	call _dyn_string_new;
	R5  =R0 ;
	cc =R6 ==0;
	if cc jump 6; jump.l L$L$1197;
	R2  = 0 (X);
	R0  =P5 ;
	R1  =R5 ;
	call _cp_demangle;
	jump.s L$L$1198;
L$L$1197:
	R0  =P5 ;
	R1  =R5 ;
	call _cp_demangle_type;
L$L$1198:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1199;
	R0  =R5 ;
	call _dyn_string_release;
	jump.s L$L$1193;
L$L$1199:
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	P2  =[P2 ];
	R1  =P2 ;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1201;
	P2.L  = _stderr; P2.H  = _stderr;
	P2  =[P2 ];
	[SP +12] =P2 ;
	R2  = 26 (X);
	R0.L  = L$LC$207; R0.H  = L$LC$207;
	R1  = 1 (X);
	call _fwrite;
	call _abort;
L$L$1201:
	R0  =R5 ;
	call _dyn_string_delete;
	R0  = 0 (X);
L$L$1193:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$208:
.dw	0x414a;
.dw	0x7272;
.dw	0x7961;
.db	0x3c;
.db	0x00;
.align 2
.global _java_demangle_v3;
.type _java_demangle_v3, STT_FUNC;
_java_demangle_v3:
	LINK 8;
	[--sp] = ( r7:4, p5:3 );
	R5  =R0 ;
	R4  = 0 (X);
	R0  = 0 (X);
	call _dyn_string_new;
	R6  =R0 ;
	R2  = 4 (X);
	R0  =R5 ;
	R1  =R6 ;
	call _cp_demangle;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1204;
	R0  =R6 ;
	call _dyn_string_release;
	[FP +-4] =R0 ;
	call _strlen;
	[FP +-8] =R0 ;
	P3  =[FP +-4];
	P2  =R0 ;
	P5 =P3 +P2 ;
	R6  = 0 (X);
	jump.s L$L$1225;
L$L$1204:
	P2.L  = _status_allocation_failed; P2.H  = _status_allocation_failed;
	P2  =[P2 ];
	R1  =P2 ;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1206;
	P2.L  = _stderr; P2.H  = _stderr;
	P2  =[P2 ];
	[SP +12] =P2 ;
	R2  = 26 (X);
	R0.L  = L$LC$207; R0.H  = L$LC$207;
	R1  = 1 (X);
	call _fwrite;
	call _abort;
L$L$1206:
	R0  =R6 ;
	call _dyn_string_delete;
	R0  = 0 (X);
	jump.s L$L$1203;
L$L$1221:
	R0  =P3 ;
	R1.L  = L$LC$208; R1.H  = L$LC$208;
	call _strstr;
	R5  =R0 ;
	P4  = 0 (X);
	cc =R4 <=0;
	if !cc jump 6; jump.l L$L$1211;
	R0  =P3 ;
	R1  = 62 (X);
	call _strchr;
	P4  =R0 ;
L$L$1211:
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$1212;
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$1213;
	R0  =P4 ;
	cc =R0 <=R5  (iu);
	if !cc jump 6; jump.l L$L$1212;
L$L$1213:
	R4 +=1;
	cc =R6 ==0;
	if cc jump 6; jump.l L$L$1214;
	R0  =[FP +-8];
	call _dyn_string_new;
	R6  =R0 ;
L$L$1214:
	R1  =P3 ;
	cc =R5 <=R1  (iu);
	if !cc jump 6; jump.l L$L$1215;
	R0  = 0 (X);
	P2  =R5 ;
	B [P2 ] =R0 ;
	R0  =R6 ;
	call _dyn_string_append_cstr;
L$L$1215:
	P3  =R5 ;
	P3 +=7;
	jump.s L$L$1225;
L$L$1212:
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$1217;
	R4 +=-1;
	cc =P4 <=P3  (iu);
	if !cc jump 6; jump.l L$L$1218;
	R0  = B [P3 ] (X);
	R1  = 32 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1218;
	R0  = 0 (X);
	B [P4 ] =R0 ;
	R0  =R6 ;
	R1  =P3 ;
	call _dyn_string_append_cstr;
L$L$1218:
	R0  =R6 ;
	R1.L  = L$LC$51; R1.H  = L$LC$51;
	call _dyn_string_append_cstr;
	P3  = 1 (X);
	P3 =P3 +P4 ; //immed->Preg 
	jump.s L$L$1225;
L$L$1217:
	R0  =[FP +-4];
	R1  =P3 ;
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$1203;
	R0  =R6 ;
	call _dyn_string_append_cstr;
	P3  =P5 ;
L$L$1225:
	cc =P3 <P5  (iu);
	if !cc jump 6; jump.l L$L$1221;
	R0  =[FP +-4];
	call _free;
	R0  = 0 (X);
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$1203;
	R0  =R6 ;
	call _dyn_string_release;
L$L$1203:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$209:
.dw	0x5a5f;
.db	0x00;
.align 2
L$LC$210:
.dw	0x7325;
.db	0x0a;
.db	0x00;
.align 2
.type _demangle_v3_with_details, STT_FUNC;
_demangle_v3_with_details:
	LINK 0;
	[--sp] = ( r7:5 );
	R6  =R0 ;
	R2  = 2 (X);
	R1.L  = L$LC$209; R1.H  = L$LC$209;
	call _strncmp;
	R5  = 0 (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1226;
	R0  =R6 ;
	R1  = 16384 (X);
	call _demangling_new;
	R5  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1228;
	P2.L  = _stderr; P2.H  = _stderr;
	P2  =[P2 ];
	[SP +12] =P2 ;
	R2  = 26 (X);
	R0.L  = L$LC$207; R0.H  = L$LC$207;
	R1  = 1 (X);
	call _fwrite;
	jump.s L$L$1231;
L$L$1228:
	call _result_push;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1229;
	R0  =R5 ;
	call _demangling_delete;
	P2.L  = _stderr; P2.H  = _stderr;
	P2  =[P2 ];
	[SP +12] =P2 ;
	R0.L  = L$LC$210; R0.H  = L$LC$210;
	[SP +16] =R0 ;
	[SP +20] =R6 ;
	call _fprintf;
L$L$1231:
	call _abort;
L$L$1229:
	R0  =R5 ;
	call _demangle_mangled_name;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1226;
	R0  =R5 ;
	call _demangling_delete;
	R5  = 0 (X);
L$L$1226:
	R0  =R5 ;
	( r7:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _is_gnu_v3_mangled_ctor;
.type _is_gnu_v3_mangled_ctor, STT_FUNC;
_is_gnu_v3_mangled_ctor:
	LINK 0;
	[--sp] = ( r7:6 );
	call _demangle_v3_with_details;
	R6  = 0 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1232;
	P2  =R0 ;
	R6  =[P2 +36];
	call _demangling_delete;
L$L$1232:
	R0  =R6 ;
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _is_gnu_v3_mangled_dtor;
.type _is_gnu_v3_mangled_dtor, STT_FUNC;
_is_gnu_v3_mangled_dtor:
	LINK 0;
	[--sp] = ( r7:6 );
	call _demangle_v3_with_details;
	R6  = 0 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1235;
	P2  =R0 ;
	R6  =[P2 +40];
	call _demangling_delete;
L$L$1235:
	R0  =R6 ;
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.data;
.align 2
_flag_verbose:.space 4;
.align 2
_flag_strict:.space 4;
