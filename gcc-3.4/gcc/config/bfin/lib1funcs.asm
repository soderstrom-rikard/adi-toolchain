#ifdef L_divsi3
.text
.align 2
.global ___divsi3;
.type ___divsi3, STT_FUNC;
.global __divsi3;
.type __divsi3, STT_FUNC;

___divsi3:
__divsi3:
        R3 = RETS;
        [--SP]=R3;
        CC = R0<0;
        IF CC JUMP num_neg;
        CC = R1<0;
        IF CC JUMP den_neg;
        CALL pos_ans;
 
num_neg:
        CC = R1<0;
        IF CC JUMP both_neg;
        R0= -R0;
        CALL ___udivsi3;
        R0= -R0;
        CALL done;

 
den_neg:
        R1= -R1;
        CALL ___udivsi3;
        R0= -R0;
        CALL done;
 
both_neg:
        R0= -R0;
        R1= -R1;
 
pos_ans:
        CALL ___udivsi3;
	NOP;
	NOP;
        CALL done;
	NOP;
 
done:
        R3=[SP++];
        RETS = R3;
        RTS;
#endif

#ifdef L_modsi3	
.align 2
.global ___modsi3;
.type ___modsi3, STT_FUNC;
.global __modsi3;
.type __modsi3, STT_FUNC;

___modsi3:
__modsi3:
        LINK 0x0;
        [--SP]=(R7:6);
        R6 = R0;
        R7 = R1;
        CALL ___divsi3;
        R7 *= R0;
        R0 = R6-R7;
        ( R7:6)=[SP++];
        UNLINK;
        RTS; 
#endif

#ifdef L_udivsi3
.align 2
.global ___udivsi3;
.type ___udivsi3, STT_FUNC;
.global __udivsi3;
.type __udivsi3, STT_FUNC;

___udivsi3:
__udivsi3:
        [--SP]=RETS;
        [--SP]=R4;
        [--SP]=P4;
        P4=32;
        LSETUP (udiv_begin, udiv_end) LC0=P4;
        R3=0;
 
udiv_begin:
        CALL lshft;
        R2 = R3;
        R3 = R3-R1;
        CC = R3<0;
        IF !CC JUMP one_qb;
        R3 = R2;
        R2=-2;
        R0 = R0&R2;
        JUMP.S udiv_end;
 
one_qb:
        R2=1;
        R0 = R0|R2;
 
udiv_end:
        NOP;
return:
        R1 = R3;
        P4=[SP++];
        R4=[SP++];
        RETS=[SP++];
        RTS;
 
lshft:
        R2 = R0;
        R4=31;
        R2 >>= R4;
        R4=1;
        R2 = R2&R4;
        R3 <<= 0x1;
        R3 = R3|R2;
        R0 <<= 0x1;
        RTS;
#endif

#ifdef L_umodsi3
.align 2
.global ___umodsi3;
.type ___umodsi3, STT_FUNC;
.global __umodsi3;
.type __umodsi3, STT_FUNC;

___umodsi3:
__umodsi3:
        LINK 0x0;
        [--SP]=( R7:6);
        R6 = R0;
        R7 = R1;
        CALL ___udivsi3;
        R7 *= R0;
        R0 = R6-R7;
        ( R7:6)=[SP++];
        UNLINK ;
        RTS;
#endif

#ifdef L_addsf3
.align 2
.global ___addsf3;
.type ___addsf3, STT_FUNC;
.global __addsf3;
.type __addsf3, STT_FUNC;
___addsf3:
__addsf3:
        [--SP]=(R7:4);
        R6 = R0;
        R4=0;
        R7 = R6;
        R3 = R1;
        R2=255 (X);
        R2 <<= 0x17;
        R0 = R7&R2;
        CC = R0==R2;
        IF !CC JUMP L$_3;
        R1.L =-1;
        R1.H =127;
        R0 = R7&R1;
        CC = R0==0;
        IF !CC JUMP L$_4;
        R0 = R3&R2;
        CC = R0==R2;
        IF !CC JUMP L$_42;
        R0 = R3&R1;
        CC = R0==0;
        IF !CC JUMP L$_14;
        R1 = R7;
        R1 >>>= 0x1f;
        R1 <<= 0x1f;
        R0 = R3;
        R0 >>>= 0x1f;
        R0 <<= 0x1f;
        CC = R1==R0;
        R0.L = -1;
        R0.H =32767;
        IF !CC JUMP L$_41;
 
L$_42:
        R0 = R6;
        JUMP.S L$_41;
 
L$_4:
        R0 = R3&R2;
        R2=255 (X);
        R2 <<= 0x17;
        CC = R0==R2;
        IF !CC JUMP L$_11;
        R0 = R3&R1;
        CC = R0==0;
        IF CC JUMP L$_11;
        R0 = R3;
        BITCLR (R0,0x1f);
        R5.L =-1;
        R5.H =32767;
        CC = R0==R5;
        IF !CC JUMP L$_14;
 
L$_11:
        R0 = R7;
        BITCLR (R0,0x1f);
        R1.L =-1;
        R1.H =32767;
        CC = R0==R1;
        IF !CC JUMP L$_12;
        R0 = R3;
        BITCLR (R0,0x1f);
        CC = R0==R1;
        IF CC JUMP L$_45;
 
L$_12:
        BITSET (R7,0x16);
        JUMP.S L$_44;
 
L$_3:
        R0 = R3&R2;
        R2=255 (X);
        R2 <<= 0x17;
        CC = R0==R2;
        IF !CC JUMP L$_13;
        R0.L =-1;
        R0.H =127;
        R0 = R3&R0;
        CC = R0==0;
        IF !CC JUMP L$_14;
        R0 = R1;
        JUMP.S L$_41;
 
L$_14:
        BITSET (R3,0x16);
 
L$_45:
        R0 = R3;
        JUMP.S L$_41;
 
L$_13:
        CC = R7==0;
        IF CC JUMP L$_16;
        R5=-1;
        R5 <<= 0x1f;
        CC = R7==R5;
        IF !CC JUMP L$_15;
 
L$_16:
        CC = R3==0;
        IF CC JUMP L$_17;
        R0=-1;
        R0 <<= 0x1f;
        CC = R3==R0;
        IF !CC JUMP L$_15;
 
L$_17:
        R7 >>>= 0x1f;
        CC = !BITTST(R7,0x0);
        R0 = 0 (Z);
        IF CC JUMP L$_41;
        R3 >>>= 0x1f;
        CC = !BITTST(R3,0x0);
        IF CC JUMP L$_41;
        R0.L =0;
        R0.H =-32768;
        JUMP.S L$_41;
 
L$_15:
        CC = R7==0;
        IF CC JUMP L$_45;
        R1=-1;
        R1 <<= 0x1f;
        CC = R7==R1;
        IF CC JUMP L$_45;
        CC = R3==0;
        IF CC JUMP L$_44;
        R2=-1;
        R2 <<= 0x1f;
        CC = R3==R2;
        IF CC JUMP L$_44;
        R0 = R7;
        R0 >>>= 0x17;
        R1=255 (X);
        R6 = R0&R1;
        R0 = R3;
        R0 >>>= 0x17;
        R5 = R0&R1;
        R0 = R5;
        R0 +=25;
        CC = R6<=R0;
        IF !CC JUMP L$_44;
        R0 = R6;
        R0 +=25;
        CC = R5<=R0;
        IF !CC JUMP L$_45;
        R0.L =-1;
        R0.H =127;
        R2 = R7&R0;
        BITSET (R2,0x17);
        R2 <<= 0x6;
        R1 = R3&R0;
        BITSET (R1,0x17);
        R1 <<= 0x6;
        R7 >>>= 0x1f;
        R0= -R2;
        CC = !BITTST(R7,0x0);
        IF !CC R2=R0;
        R3 >>>= 0x1f;
        R0= -R1;
        CC = !BITTST(R3,0x0);
        IF !CC R1=R0;
        CC = R6<=R5;
        IF CC JUMP L$_28;
        R0 = R6-R5;
        R1 >>>= R0;
        JUMP.S L$_29;
 
L$_28:
        R0 = R5-R6;
        R2 >>>= R0;
        R6 = R5;
 
L$_29:
        R2 = R2+R1;
        CC = R2<0;
        IF CC JUMP L$_30;
        CC = R2==0;
        IF !CC JUMP L$_46;
        R0 = 0 (Z);
        JUMP.S L$_41;
 
L$_30:
        R2= -R2;
        R4=-1;
        R4 <<= 0x1f;
        JUMP.S L$_46;
 
L$_35:
        P2 = R2;
        P2 = P2<<1;
        R2 = P2;
        R6 +=-1;
 
L$_46:
        R0 = R2;
        R0 >>>= 0x1d;
        R0 <<= 0x1d;
        CC = R0==0;
        IF CC JUMP L$_35(BP);
        R3=1;
        R3 <<= 0x1e;
        CC = !BITTST(R2,0x1e);
        IF CC JUMP L$_37;
        R2 >>>= 0x1;
        R6 +=1;
 
L$_37:
        R0 = R2;
        R0 +=31;
        R1 = R2;
        R1 +=32;
        CC = !BITTST(R2,0x6);
        IF CC R2=R0;
        IF !CC R2=R1;
        R0 = R2&R3;
        CC = R0==0;
        IF CC JUMP L$_40;
        R2 >>>= 0x1;
        R6 +=1;
 
L$_40:
        R2 >>>= 0x6;
        BITCLR (R2,0x17);
        R6 <<= 0x17;
        R0 = R4|R6;
        R7 = R0|R2;
 
L$_44:
        R0 = R7;
 
L$_41:
        ( R7:4)=[SP++];
        RTS; 
#endif

#ifdef L_subsf3
.align 2
.global ___subsf3;
.type ___subsf3, STT_FUNC;
.global __subsf3;
.type __subsf3, STT_FUNC;

___subsf3:
__subsf3:
        LINK 0x0;
        [--SP]=(R7:7);
        P2 = R0;
        R3 = P2;
        R2 = R1;
        R1=255 (X);
        R1 <<= 0x17;
        R0 = R3&R1;
        CC = R0==R1;
        IF !CC JUMP subsf_3;
        R7.L =-1;
        R7.H =127;
        R0 = R3&R7;
        CC = R0==0;
        IF !CC JUMP subsf_4;
        R0 = R2&R1;
        CC = R0==R1;
        IF !CC JUMP subsf_21;
        R0 = R2&R7;
        CC = R0==0;
        IF !CC JUMP subsf_14;
        R1 = R3;
        R1 >>>= 0x1f;
        R1 <<= 0x1f;
        R0 = R2;
        R0 >>>= 0x1f;
        R0 <<= 0x1f;
        CC = R1==R0;
        R0.L =-1;
        R0.H =32767;
        IF CC JUMP subsf_20;
 
subsf_21:
        R0 = P2;
        JUMP.S subsf_20;
 
subsf_4:
        R0 = R2&R1;
        R1=255 (X);
        R1 <<= 0x17;
        CC = R0==R1;
        IF !CC JUMP subsf_11;
        R0 = R2&R7;
        CC = R0==0;
        IF CC JUMP subsf_11;
        R0 = R2;
        BITCLR (R0,0x1f);
        R7.L =-1;
        R7.H =32767;
        CC = R0==R7;
        IF !CC JUMP subsf_14;
 
subsf_11:
        R0 = R3;
        BITCLR (R0,0x1f);
        R1.L =-1;
        R1.H =32767;
        CC = R0==R1;
        IF !CC JUMP subsf_12;
        R0 = R2;
        BITCLR (R0,0x1f);
        CC = R0==R1;
        IF !CC JUMP subsf_12;
        R0 = R2;
        JUMP.S subsf_20;
 
subsf_12:
        BITSET (R3,0x16);
        R0 = R3;
        JUMP.S subsf_20;
 
subsf_3:
        R0 = R2&R1;
        R7=255 (X);
        R7 <<= 0x17;
        CC = R0==R7;
        IF !CC JUMP subsf_13;
        R0.L =-1;
        R0.H =127;
        R0 = R2&R0;
        CC = R0==0;
        IF !CC JUMP subsf_14;
        BITTGL (R2,0x1f);
        R0 = R2;
        JUMP.S subsf_20;
 
subsf_14:
        BITSET (R2,0x16);
        R0 = R2;
        JUMP.S subsf_20;
 
subsf_13:
        CC = R3==0;
        IF CC JUMP subsf_16;
        R0=-1;
        R0 <<= 0x1f;
        CC = R3==R0;
        IF !CC JUMP subsf_15;
 
subsf_16:
        R1=-1;
        R1 <<= 0x1f;
        CC = R3==R1;
        IF !CC JUMP subsf_17;
        CC = R2==0;
        IF !CC JUMP subsf_17;
        R0.L =0;
        R0.H =-32768;
        JUMP.S subsf_20;
 
subsf_17:
        CC = R2==0;
        IF CC JUMP subsf_19;
        R7=-1;
        R7 <<= 0x1f;
        CC = R2==R7;
        IF !CC JUMP subsf_18;
 
subsf_19:
        R0 = 0 (Z);
        JUMP.S subsf_20;
 
subsf_18:
        R0 = R2;
        CALL ___negsf2;
 
subsf_15:
        BITTGL (R2,0x1f);
        R1 = R2;
        R0 = P2;
        CALL ___addsf3;
 
subsf_20:
        ( R7:7)=[SP++];
        UNLINK ;
        RTS; 
#endif

#ifdef L_mulsf3
.align 2
.global ___mulsf3;
.type ___mulsf3, STT_FUNC;
.global __mulsf3;
.type __mulsf3, STT_FUNC;

___mulsf3:
__mulsf3:
        LINK 0x4;
        [--SP]=( R7:4);
        R5 = R0;
        R6 = R1;
        R1=255 (X);
        R1 <<= 0x17;
        R0 = R5&R1;
        CC = R0==R1;
        IF !CC JUMP mulsf_3;
        R2.L =-1;
        R2.H =127;
        R0 = R5&R2;
        CC = R0==0;
        IF !CC JUMP mulsf_4;
        CC = R6==0;
        IF CC JUMP mulsf_16;
        R0=-1;
        R0 <<= 0x1f;
        CC = R6==R0;
        IF CC JUMP mulsf_16;
        R0 = R6&R1;
        R1=255 (X);
        R1 <<= 0x17;
        CC = R0==R1;
        IF !CC JUMP mulsf_7;
        R0 = R6&R2;
        CC = R0==0;
        IF !CC JUMP mulsf_14;
        R0 = R6;
        R0 >>>= 0x1f;
        R0 <<= 0x1f;
        R5 = R5^R0;
        JUMP.S mulsf_23;
 
mulsf_7:
        R0 = R6;
        R0 >>>= 0x1f;
        R0 <<= 0x1f;
        R5 = R5^R0;
        JUMP.S mulsf_23;
 
mulsf_4:
        R0 = R6&R1;
        R1=255 (X);
        R1 <<= 0x17;
        CC = R0==R1;
        IF !CC JUMP mulsf_11;
        R0 = R6&R2;
        CC = R0==0;
        IF CC JUMP mulsf_11;
        R0 = R6;
        BITCLR (R0,0x1f);
        R2.L =-1;
        R2.H =32767;
        CC = R0==R2;
        IF !CC JUMP mulsf_14;
 
mulsf_11:
        R0 = R5;
        BITCLR (R0,0x1f);
        R1.L =-1;
        R1.H =32767;
        CC = R0==R1;
        IF !CC JUMP mulsf_12;
        R0 = R6;
        BITCLR (R0,0x1f);
        CC = R0==R1;
        IF !CC JUMP mulsf_12;
        R0 = R6;
        JUMP.S mulsf_22;
 
mulsf_12:
        BITSET (R5,0x16);
        JUMP.S mulsf_23;
 
mulsf_3:
        R0 = R6&R1;
        R2=255 (X);
        R2 <<= 0x17;
        CC = R0==R2;
        IF !CC JUMP mulsf_13;
        R0.L =-1;
        R0.H =127;
        R0 = R6&R0;
        CC = R0==0;
        IF !CC JUMP mulsf_14;
        CC = R5==0;
        IF CC JUMP mulsf_16;
        R0=-1;
        R0 <<= 0x1f;
        CC = R5==R0;
        IF !CC JUMP mulsf_15;
 
mulsf_16:
        R0.L =-1;
        R0.L =32767;
        JUMP.S mulsf_22;
 
mulsf_15:
        R0 = R5;
        R0 >>>= 0x1f;
        R0 <<= 0x1f;
        R6 = R6^R0;
        R0 = R6;
        JUMP.S mulsf_22;
 
mulsf_14:
        BITSET (R6,0x16);
        R0 = R6;
        JUMP.S mulsf_22;
 
mulsf_13:
        CC = R5==0;
        IF CC JUMP mulsf_18;
        R1=-1;
        R1 <<= 0x1f;
        CC = R5==R1;
        IF CC JUMP mulsf_18;
        CC = R6==0;
        IF CC JUMP mulsf_18;
        CC = R6==R1;
        IF !CC JUMP mulsf_17;
 
mulsf_18:
        R1 = R5;
        R1 >>>= 0x1f;
        R1 <<= 0x1f;
        R0 = R6;
        R0 >>>= 0x1f;
        R0 <<= 0x1f;
        CC = R1==R0;
        R0 = 0(Z);
        IF CC JUMP mulsf_22;
        R0.L =0;
        R0.H =-32768;
        JUMP.S mulsf_22;
 
mulsf_17:
        R1 = R5;
        R1 >>>= 0x1f;
        R1 <<= 0x1f;
        R0 = R6;
        R0 >>>= 0x1f;
        R0 <<= 0x1f;
        R1 = R1^R0;
        [FP+-4]=R1;
        R0 = R5;
        R0 >>>= 0x17;
        R2=255 (X);
        R4 = R0&R2;
        R0=-126 (X);
        R4 = R4+R0;
        R0 = R6;
        R0 >>>= 0x17;
        R0 = R0&R2;
        R4 = R4+R0;
        R0.L =-1;
        R0.H =127;
        R5 = R5&R0;
        BITSET (R5,0x17);
        R6 = R6&R0;
        BITSET (R6,0x17);
        R3 = R5;
        R3 >>>= 0x8;
        R1 = R6;
        R1 >>>= 0x8;
        R7 = R3;
        R7 *= R1;
        R0 = R5&R2;
        R0 *= R1;
        R0 >>>= 0x8;
        R7 = R7+R0;
        R2 = R6&R2;
        R2 *= R3;
        R2 >>>= 0x8;
        R7 = R7+R2;
        R0 = R7;
        R0 >>>= 0x1f;
        CC = !BITTST(R0,0x0);
        IF CC JUMP mulsf_20;
        R1=128 (X);
        R7 = R7+R1;
        R7 >>= 0x8;
        JUMP.S mulsf_21;
 
mulsf_20:
        R2=64 (X);
        R7 = R7+R2;
        R7 >>= 0x7;
        R4 +=-1;
 
mulsf_21:
        BITCLR (R7,0x17);
        R4 <<= 0x17;
        R1=[FP+-4];
        R0 = R1|R4;
        R5 = R0|R7;
 
mulsf_23:
        R0 = R5;
 
mulsf_22:
        ( R7:4)=[SP++];
        UNLINK ;
        RTS;
#endif

#ifdef L_divsf3
.align 2
.global ___divsf3;
.type ___divsf3, STT_FUNC;
.global __divsf3;
.type __divsf3, STT_FUNC;

___divsf3:
__divsf3:
        [--SP]=(R7:5);
        R6 = R0;
        R3 = R1;
        R1=255 (X);
        R1 <<= 0x17;
        R0 = R6&R1;
        CC = R0==R1;
        IF !CC JUMP divsf_3;
        R2.L =-1;
        R2.H =127;
        R0 = R6&R2;
        CC = R0==0;
        IF !CC JUMP divsf_4;
        R0 = R3&R1;
        CC = R0==R1;
        IF !CC JUMP divsf_5;
        R0 = R3&R2;
        CC = R0==0;
        IF CC JUMP divsf_25;
        JUMP.S divsf_35;
 
divsf_5:
        R0 = R3;
        R0 >>>= 0x1f;
        R0 <<= 0x1f;
        R6 = R6^R0;
        JUMP.S divsf_36;
 
divsf_4:
        R0 = R3&R1;
        R1=255 (X);
        R1 <<= 0x17;
        CC = R0==R1;
        IF !CC JUMP divsf_9;
        R0 = R3&R2;
        CC = R0==0;
        IF CC JUMP divsf_9;
        R0 = R3;
        BITCLR (R0,0x1f);
        R2.L =-1;
        R2.H =32767;
        CC = R0==R2;
        IF !CC JUMP divsf_35;
 
divsf_9:
        R0 = R6;
        BITCLR (R0,0x1f);
        R1.L =-1;
        R1.H =32767;
        CC = R0==R1;
        IF !CC JUMP divsf_10;
        R0 = R3;
        BITCLR (R0,0x1f);
        CC = R0==R1;
        IF !CC JUMP divsf_10;
        R0 = R3;
        JUMP.S divsf_34;
 
divsf_10:
        BITSET (R6,0x16);
        JUMP.S divsf_36;
 
divsf_3:
        R0 = R3&R1;
        R2=255 (X);
        R2 <<= 0x17;
        CC = R0==R2;
        IF !CC JUMP divsf_11;
        R0.L =-1;
        R0.H =127;
        R0 = R3&R0;
        CC = R0==0;
        IF CC JUMP divsf_12;
 
divsf_35:
        BITSET (R3,0x16);
        R0 = R3;
        JUMP.S divsf_34;
 
divsf_12:
        R1 = R3;
        R1 >>>= 0x1f;
        R1 <<= 0x1f;
        R0 = R6;
 
divsf_37:
        R0 >>>= 0x1f;
        R0 <<= 0x1f;
        CC = R1==R0;
        R0.L =0;
        R0.H =-32768;
        IF !CC JUMP divsf_34;
        R0 = 0(Z);
        JUMP.S divsf_34; 
 
divsf_11:
        CC = R3==0;
        IF CC JUMP divsf_17;
        R0=-1;
        R0 <<= 0x1f;
        CC = R3==R0;
        IF !CC JUMP divsf_16;
 
divsf_17:
        CC = R6==0;
        IF CC JUMP divsf_16;
        R1=-1;
        R1 <<= 0x1f;
        CC = R6==R1;
        IF CC JUMP divsf_16;
        CC = R6==0;
        IF CC JUMP divsf_25;
        R1 = R6;
        R1 >>>= 0x1f;
        R1 <<= 0x1f;
        R0 = R3;
        R0 >>>= 0x1f;
        R0 <<= 0x1f;
        CC = R1==R0;
        R0.L =0;
        R0.H =-128;
        IF !CC JUMP divsf_34;
        R0.L =0;
        R0.H =32640;
        JUMP.S divsf_34;
 
divsf_16:
        CC = R6==0;
        IF CC JUMP divsf_23;
        R2=-1;
        R2 <<= 0x1f;
        CC = R6==R2;
        IF !CC JUMP divsf_22;
 
divsf_23:
        CC = R3==0;
        IF CC JUMP divsf_25;
        R0=-1;
        R0 <<= 0x1f;
        CC = R3==R0;
        IF !CC JUMP divsf_24;
 
divsf_25:
        R0.L =-1;
        R0.H =32767;
        JUMP.S divsf_34;
 
divsf_24:
        R1 = R6;
        R1 >>>= 0x1f;
        R1 <<= 0x1f;
        R0 = R3;
        JUMP.S divsf_37;
 
divsf_22:
        R1 = R6;
        R1 >>>= 0x17;
        R2=255 (X);
        R1 = R1&R2;
        R0 = R3;
        R0 >>>= 0x17;
        R0 = R0&R2;
        R7 = R1-R0;
        R1=126 (X);
        R7 = R7+R1;
        R1 = R6;
        R1 >>>= 0x1f;
        R1 <<= 0x1f;
        R0 = R3;
        R0 >>>= 0x1f;
        R0 <<= 0x1f;
        R5 = R1^R0;
        R0.L =-1;
        R0.H =127;
        R6 = R6&R0;
        BITSET (R6,0x17);
        R3 = R3&R0;
        BITSET (R3,0x17);
        CC = R6<R3;
        IF !CC JUMP divsf_28;
        P2 = R6;
        P2 = P2<<1;
        R6 = P2;
        R7 +=-1;
 
divsf_28:
        R0=1;
        R0 <<= 0x18;
        R2=0;
        R1 = R7;
        R1 +=1;
 
divsf_31:
        CC = R6<R3;
        IF CC JUMP divsf_32;
        R2 = R2|R0;
        R6 = R6-R3;
 
divsf_32:
        P2 = R6;
        P2 = P2<<1;
        R6 = P2;
        R0 >>>= 0x1;
        CC = R0==0;
        IF !CC JUMP divsf_31(BP);
        R2 +=1;
        R2 >>>= 0x1;
        BITCLR (R2,0x17);
        R1 <<= 0x17;
        R0 = R5|R1;
        R6 = R0|R2;
 
divsf_36:
        R0 = R6;
 
divsf_34:
        ( R7:5)=[SP++];
        RTS; 
#endif

#ifdef L_cmpsf2
.align 2
.global ___cmpsf2;
.type ___cmpsf2, STT_FUNC;
.global __cmpsf2;
.type __cmpsf2, STT_FUNC;

___cmpsf2:
__cmpsf2:
        R3 = R0;
        R2 = R1;
        R1 = R3;
        BITCLR (R1,0x1f);
        R0 = R2;
        BITCLR (R0,0x1f);
        CC = R1==R0;
        IF !CC JUMP cmpsf_3;
        CC = R1==0;
        R0=0;
        IF CC JUMP cmpsf_11;
 
cmpsf_3:
        R0=-1;
        R0 <<= 0x17;
        CC = R3==R0;
        IF !CC JUMP cmpsf_4;
        CC = R2==R0;
        R0=-1;
        IF !CC JUMP cmpsf_11;
 
cmpsf_4:
        R0=-1;
        R0 <<= 0x17;
        CC = R3==R0;
        IF CC JUMP cmpsf_5;
        CC = R2==R0;
        R0=1;
        IF CC JUMP cmpsf_11;
 
cmpsf_5:
        R0 = R3;
        R0 >>>= 0x1f;
        CC = !BITTST(R0,0x0);
        IF CC JUMP cmpsf_6;
        R0 = R2;
        R0 >>>= 0x1f;
        CC = !BITTST(R0,0x0);
        IF CC JUMP cmpsf_6;
        BITTGL (R3,0x1f);
        BITTGL (R2,0x1f);
        CC = R3<R2;
        IF !CC JUMP cmpsf_7;
        R0=1;
        JUMP.S cmpsf_11;
 
cmpsf_7:
        R1=-1;
        JUMP.S cmpsf_12;
 
cmpsf_6:
        CC = R3<R2;
        IF CC JUMP cmpsf_9;
        R1=1;
 
cmpsf_12:
        R0=0;
        CC = R3<=R2;
        IF !CC R0=R1;
        JUMP.S cmpsf_11;
 
cmpsf_9:
        R0=-1;
 
cmpsf_11:
        RTS; 
#endif

#ifdef L_eqsf2
.align 2
.global ___eqsf2;
.type ___eqsf2, STT_FUNC;
.global __eqsf2;
.type __eqsf2, STT_FUNC;

___eqsf2:
__eqsf2:
        LINK 0x0;
        [--SP]=(R7:7);
        P2 = R0;
        R2 = P2;
        R3 = R1;
        R0=255 (X);
        R0 <<= 0x17;
        R0 = R2&R0;
        R7=255 (X);
        R7 <<= 0x17;
        CC = R0==R7;
        IF !CC JUMP eqsf_3;
        R0.L =-1;
        R0.H =127;
        R0 = R2&R0;
        CC = R0<=0;
        R0=2;
        IF !CC JUMP eqsf_5;
 
eqsf_3:
        R0=255 (X);
        R0 <<= 0x17;
        R0 = R3&R0;
        R2=255 (X);
        R2 <<= 0x17;
        CC = R0==R2;
        IF !CC JUMP eqsf_4;
        R0.L =-1;
        R0.H =127;
        R0 = R3&R0;
        CC = R0<=0;
        IF CC JUMP eqsf_4;
        R0=2;
        JUMP.S eqsf_5;
 
eqsf_4:
        R0 = P2;
        CALL ___cmpsf2;
 
eqsf_5:
        ( R7:7)=[SP++];
        UNLINK ;
        RTS;
#endif

#ifdef L_nesf2
.global ___nesf2;
.type ___nesf2, STT_FUNC;
.global __nesf2;
.type __nesf2, STT_FUNC;

___nesf2:
__nesf2:
        LINK 0x0;
        [--SP]=(R7:7);
        P2 = R0;
        R2 = P2;
        R3 = R1;
        R0=255 (X);
        R0 <<= 0x17;
        R0 = R2&R0;
        R7=255 (X);
        R7 <<= 0x17;
        CC = R0==R7;
        IF !CC JUMP nesf_7;
        R0.L =-1;
        R0.H =127;
        R0 = R2&R0;
        CC = R0<=0;
        R0=2;
        IF !CC JUMP nesf_9;
 
nesf_7:
        R0=255 (X);
        R0 <<= 0x17;
        R0 = R3&R0;
        R2=255 (X);
        R2 <<= 0x17;
        CC = R0==R2;
        IF !CC JUMP nesf_8;
        R0.L =-1;
        R0.H =127;
        R0 = R3&R0;
        CC = R0<=0;
        IF CC JUMP nesf_8;
        R0=2;
        JUMP.S nesf_9;
 
nesf_8:
        R0 = P2;
        CALL ___cmpsf2;
 
nesf_9:
        ( R7:7)=[SP++];
        UNLINK ;
        RTS; 
#endif

#ifdef L_ltsf2
.align 2
.global ___ltsf2;
.type ___ltsf2, STT_FUNC;
.global __ltsf2;
.type __ltsf2, STT_FUNC;

___ltsf2:
__ltsf2:
        LINK 0x0;
        [--SP]=(R7:7);
        P2 = R0;
        R2 = P2;
        R3 = R1;
        R0=255 (X);
        R0 <<= 0x17;
        R0 = R2&R0;
        R7=255 (X);
        R7 <<= 0x17;
        CC = R0==R7;
        IF !CC JUMP ltsf_3;
        R0.L =-1;
        R0.H =127;
        R0 = R2&R0;
        CC = R0<=0;
        R0=2;
        IF !CC JUMP ltsf_5;
 
ltsf_3:
        R0=255 (X);
        R0 <<= 0x17;
        R0 = R3&R0;
        R2=255 (X);
        R2 <<= 0x17;
        CC = R0==R2;
        IF !CC JUMP ltsf_4;
        R0.L =-1;
        R0.H =127;
        R0 = R3&R0;
        CC = R0<=0;
        IF CC JUMP ltsf_4;
        R0=2;
        JUMP.S ltsf_5;
 
ltsf_4:
        R0 = P2;
        CALL ___cmpsf2;
 
ltsf_5:
        ( R7:7)=[SP++];
        UNLINK ;
        RTS; 
#endif

#ifdef L_lesf2
.align 2
.global ___lesf2;
.type ___lesf2, STT_FUNC;
.global __lesf2;
.type __lesf2, STT_FUNC;

___lesf2:
__lesf2:
        LINK 0x0;
        [--SP]=( R7:7);
        P2 = R0;
        R2 = P2;
        R3 = R1;
        R0=255 (X);
        R0 <<= 0x17;
        R0 = R2&R0;
        R7=255 (X);
        R7 <<= 0x17;
        CC = R0==R7;
        IF !CC JUMP lesf_3;
        R0.L =-1;
        R0.H =127;
        R0 = R2&R0;
        CC = R0<=0;
        R0=2;
        IF !CC JUMP lesf_5;
 
lesf_3:
        R0=255 (X);
        R0 <<= 0x17;
        R0 = R3&R0;
        R2=255 (X);
        R2 <<= 0x17;
        CC = R0==R2;
        IF !CC JUMP lesf_4;
        R0.L =-1;
        R0.H =127;
        R0 = R3&R0;
        CC = R0<=0;
        IF CC JUMP lesf_4;
        R0=2;
        JUMP.S lesf_5;
 
lesf_4:
        R0 = P2;
        CALL ___cmpsf2;
 
lesf_5:
        ( R7:7)=[SP++];
        UNLINK ;
        RTS;
#endif

#ifdef L_gtsf2
.align 2
.global ___gtsf2;
.type ___gtsf2, STT_FUNC;
.global __gtsf2;
.type __gtsf2, STT_FUNC;

___gtsf2:
__gtsf2:
        LINK 0x0;
        [--SP]=( R7:7);
        P2 = R0;
        R2 = P2;
        R3 = R1;
        R0=255 (X);
        R0 <<= 0x17;
        R0 = R2&R0;
        R7=255 (X);
        R7 <<= 0x17;
        CC = R0==R7;
        IF !CC JUMP gtsf_3;
        R0.L =-1;
        R0.H =127;
        R0 = R2&R0;
        CC = R0<=0;
        R0=-2;
        IF !CC JUMP gtsf_5;
 
gtsf_3:
        R0=255 (X);
        R0 <<= 0x17;
        R0 = R3&R0;
        R2=255 (X);
        R2 <<= 0x17;
        CC = R0==R2;
        IF !CC JUMP gtsf_4;
        R0.L =-1;
        R0.H =127;
        R0 = R3&R0;
        CC = R0<=0;
        IF CC JUMP gtsf_4;
        R0=-2;
        JUMP.S gtsf_5;
 
gtsf_4:
        R0 = P2;
        CALL ___cmpsf2;
 
gtsf_5:
        ( R7:7)=[SP++];
        UNLINK ;
        RTS;
#endif

#ifdef L_gesf2
.align 2
.global ___gesf2;
.type ___gesf2, STT_FUNC;
.global __gesf2;
.type __gesf2, STT_FUNC;

___gesf2:
__gesf2:
        LINK 0x0;
        [--SP]=( R7:7);
        P2 = R0;
        R2 = P2;
        R3 = R1;
        R0=255 (X);
        R0 <<= 0x17;
        R0 = R2&R0;
        R7=255 (X);
        R7 <<= 0x17;
        CC = R0==R7;
        IF !CC JUMP gesf_3;
        R0.L =-1;
        R0.H =127;
        R0 = R2&R0;
        CC = R0<=0;
        R0=-2;
        IF !CC JUMP gesf_5;
 
gesf_3:
        R0=255 (X);
        R0 <<= 0x17;
        R0 = R3&R0;
        R2=255 (X);
        R2 <<= 0x17;
        CC = R0==R2;
        IF !CC JUMP gesf_4;
        R0.L =-1;
        R0.H =127;
        R0 = R3&R0;
        CC = R0<=0;
        IF CC JUMP gesf_4;
        R0=-2;
        JUMP.S gesf_5;
 
gesf_4:
        R0 = P2;
        CALL ___cmpsf2;
 
gesf_5:
        ( R7:7)=[SP++];
        UNLINK ;
        RTS; 
#endif

#ifdef L_negsf2
.align 2
.global ___negsf2;
.type ___negsf2, STT_FUNC;
.global __negsf2;
.type __negsf2, STT_FUNC;

___negsf2:
__negsf2:
    	BITTGL (R0,0x1f);
	RTS;
#endif

#ifdef L_floatsisf
.align 2
.global ___floatsisf;
.type ___floatsisf, STT_FUNC;
.global __floatsisf;
.type __floatsisf, STT_FUNC;

___floatsisf:
__floatsisf:
        [--SP]=( R7:6);
        R2 = R0;
        R7=0;
        R1=0;
        CC = R2==0;
        IF !CC JUMP floatsisf_3;
        R0 = 0 (Z);
        JUMP.S floatsisf_11;
 
floatsisf_3:
        CC = R2<0;
        IF !CC JUMP floatsisf_12;
        R7=-1;
        R7 <<= 0x1f;
        R2= -R2;
        JUMP.S floatsisf_12;
 
floatsisf_7:
        P2 = R2;
        P2 = P2<<1;
        R2 = P2;
        R1 +=1;
 
floatsisf_12:
        R0 = R2;
        R0 >>>= 0x1f;
        CC = !BITTST(R0,0x0);
        IF CC JUMP floatsisf_7(BP);
        R0=158 (X);
        R1 = R0-R1;
        R0= R2.B (Z);
        R2 >>>= 0x8;
        R3.L =-1;
        R3.H =127;
        R2 = R2&R3;
        R6=128 (X);
        CC = R0<=R6(IU);
        IF CC JUMP floatsisf_9;
        R2 +=1;
        CC = !BITTST(R2,0x17);
        IF CC JUMP floatsisf_9;
        R2 = R2&R3;
        R1 +=1;
 
floatsisf_9:
        R1 <<= 0x17;
        R0=255 (X);
        R0 <<= 0x17;
        R1 = R1&R0;
        R0 = R7|R1;
        R0 = R0|R2;
 
floatsisf_11:
        ( R7:6)=[SP++];
        RTS;
#endif

#ifdef L_floatdisf
.align 2
.global ___floatdisf;
.type ___floatdisf, STT_FUNC;
.global __floatdisf;
.type __floatdisf, STT_FUNC;

___floatdisf:
__floatdisf:
        LINK 0x0;
        [--SP]=(R7:5);
        P1=[FP+0x8];
        P2=[FP+0xc];
        R6=0;
        R7=0;
        R0 = P1;
        R1 = P2;
        R0 = R0|R1;
        CC = R0==0;
        IF !CC JUMP floatdisf_3;
        R0 = 0 (Z);
        JUMP.S floatdisf_12;
 
floatdisf_3:
        CC=P2<0;
        IF !CC JUMP floatdisf_6;
        R6=-1;
        R6 <<= 0x1f;
        SP +=-8;
        [SP]=P1;
        R5=[FP+0xc];
        [SP+0x4]=R5;
        CALL ___negdi2;
        SP +=8;
        R2 = R0;
        R3 = R1;
        P1 = R2;
        P2 = R3;
        JUMP.S floatdisf_6;
 
floatdisf_8:
        R3 = P1;
        R3 >>= 0x1f;
        P0 = P2<<1;
        R2 = P0;
        R1 = R3|R2;
        P1 = P1<<1;
        R0 = P1;
        P2 = R1;
        R7 +=1;
 
floatdisf_6:
        R0=0;
        R1=-1;
        R1 <<= 0x1f;
        R5 = P2;
        R3 = R5&R1;
        R0 = R0|R3;
        CC = R0==0;
        IF CC JUMP floatdisf_8(BP);
        R0=190 (X);
        R3 = R0-R7;
        R1 = P2;
        R2= R1.B (Z);
        R0 = R1;
        R0 >>>= 0x8;
        R7.L =-1;
        R7.H =127;
        R1 = R0&R7;
        R0=128 (X);
        CC = R2<=R0(IU);
        IF CC JUMP floatdisf_10;
        R1 +=1;
        CC = !BITTST(R1,0x17);
        IF CC JUMP floatdisf_10;
        R1 = R1&R7;
        R3 +=1;
 
floatdisf_10:
        R3 <<= 0x17;
        R0=255 (X);
        R0 <<= 0x17;
        R3 = R3&R0;
        R0 = R6|R3;
        R0 = R0|R1;
 
floatdisf_12:
        ( R7:5)=[SP++];
        UNLINK ;
        RTS; 
#endif


#ifdef L_dcmp
.align 2
.global ___dcmp;
.type ___dcmp, STT_FUNC;
.global __dcmp;
.type __dcmp, STT_FUNC;
___dcmp:
__dcmp:
	LINK 0x0;
	R3=[FP+0x8];
	CC = R0<=R2;
	IF !CC JUMP dcmp_8;
	CC = R0<R2;
	IF CC JUMP dcmp_6;
	CC = R1<=R3;
	IF CC JUMP dcmp_5;
dcmp_8:
	R0 = 1(x);
	JUMP.S dcmp_7;
dcmp_5:
	CC = R1<R3;
	IF CC JUMP dcmp_6;
	R0 = 0(x);
	JUMP.S dcmp_7;
dcmp_6:
	R0 = -1(x);
dcmp_7:
	UNLINK;
	RTS;
#endif

#ifdef L_cmpdi2
.align 2
.global dbg;
.type dbg, STT_FUNC;

dbg:
    	DBG R0;
      	RTS;

.global ___cmpdi2;
.type ___cmpdi2, STT_FUNC;
.global __cmpdi2;
.type __cmpdi2, STT_FUNC;
___cmpdi2:
__cmpdi2:
        LINK 0x0;
        [--SP] = ( R7:6);
        R2=[FP+0x8];
        R3=[FP+0xc];
        R7=[FP+0x10];
        P0=[FP+0x14];
        R0 = R2;
        R1 = R3;
        P1 = R7;
        P2 = P0;
        R6 = P2;
        CC = R1<R6;
        IF CC JUMP cmpdi_10;
        R6 = P2;
        CC = R1<=R6;
        IF CC JUMP cmpdi_5;
        R0=1;
        JUMP.S cmpdi_3;
 
cmpdi_5:
        R6 = P2;
        CC = R1==R6;
        IF !CC JUMP cmpdi_3;
        R6 = P1;
        CC = R0<R6(IU);
        IF !CC JUMP cmpdi_7;
 
cmpdi_10:
        R0=-1;
        JUMP.S cmpdi_3;
 
cmpdi_7:
        R3 = R2;
        R1 = R7;
        R2=0;
        R0=1;
        CC = R3<=R1(IU);
        IF CC R0=R2;
 
cmpdi_3:
        ( R7:6)=[SP++];
        UNLINK ;
        RTS; 
#endif

#ifdef L_eqdi2
.align 2
.global dbg;
.type dbg, STT_FUNC;

dbg:
    	DBG R0;
   	RTS;

.global ___eqdi2;
.type ___eqdi2, STT_FUNC;
.global __eqdi2;
.type __eqdi2, STT_FUNC;
___eqdi2:
__eqdi2:
        LINK 0x0;
        R2=[FP+0x8];
        R3=[FP+0xc];
        R0=[FP+0x10];
        R1=[FP+0x14];
        SP +=-8;
        [SP]=R0;
        R0 = R1;
        [SP+0x4]=R0;
        SP +=-8;
        [SP]=R2;
        R0 = R3;
        [SP+0x4]=R0;
        CALL ___cmpdi2;
        SP +=16;
        UNLINK ;
        RTS;
#endif

#ifdef L_nedi2
.align 2
.global ___nedi2;
.type ___nedi2, STT_FUNC;
.global __nedi2;
.type __nedi2, STT_FUNC;

dbg:
    	DBG R0;
    	RTS;

___nedi2:
__nedi2:
        LINK 0x0;
        R2=[FP+0x8];
        R3=[FP+0xc];
        R0=[FP+0x10];
        R1=[FP+0x14];
        SP +=-8;
        [SP]=R0;
        R0 = R1;
        [SP+0x4]=R0;
        SP +=-8;
        [SP]=R2;
        R0 = R3;
        [SP+0x4]=R0;
        CALL ___cmpdi2;
        SP +=16;
        UNLINK ;
        RTS;
#endif

#ifdef L_ltdi2
.align 2
.global ___ltdi2;
.type ___ltdi2, STT_FUNC;
.global __ltdi2;
.type __ltdi2, STT_FUNC;

dbg:
      	DBG R0;
      	RTS;

___ltdi2:
__ltdi2:
        LINK 0x0;
        R2=[FP+0x8];
        R3=[FP+0xc];
        R0=[FP+0x10];
        R1=[FP+0x14];
        SP +=-8;
        [SP]=R0;
        R0 = R1;
        [SP+0x4]=R0;
        SP +=-8;
        [SP]=R2;
        R0 = R3;
        [SP+0x4]=R0;
        CALL ___cmpdi2;
        SP +=16;
        UNLINK ;
        RTS; 
#endif

#ifdef L_ledi2
.align 2
.global ___ledi2;
.type ___ledi2, STT_FUNC;
.global __ledi2;
.type __ledi2, STT_FUNC;

dbg:
  	DBG R0;
    	RTS;

___ledi2:
__ledi2:
        LINK 0x0;
        R2=[FP+0x8];
        R3=[FP+0xc];
        R0=[FP+0x10];
        R1=[FP+0x14];
        SP +=-8;
        [SP]=R0;
        R0 = R1;
        [SP+0x4]=R0;
        SP +=-8;
        [SP]=R2;
        R0 = R3;
        [SP+0x4]=R0;
        CALL ___cmpdi2;
        SP +=16;
        UNLINK ;
        RTS; 
#endif

#ifdef L_gedi2
.align 2
.global ___gedi2;
.type ___gedi2, STT_FUNC;
.global __gedi2;
.type __gedi2, STT_FUNC;

dbg:
     	DBG R0;
   	RTS;

___gedi2:
__gedi2:
        LINK 0x0;
        R2=[FP+0x8];
        R3=[FP+0xc];
        R0=[FP+0x10];
        R1=[FP+0x14];
        SP +=-8;
        [SP]=R0;
        R0 = R1;
        [SP+0x4]=R0;
        SP +=-8;
        [SP]=R2;
        R0 = R3;
        [SP+0x4]=R0;
        CALL ___cmpdi2;
        SP +=16;
        UNLINK ;
        RTS;
#endif

#ifdef L_gtdi2
.align 2
.global ___gtdi2;
.type ___gtdi2, STT_FUNC;
.global __gtdi2;
.type __gtdi2, STT_FUNC;

dbg:
    	DBG R0;
  	RTS;

___gtdi2:
__gtdi2:
        LINK 0x0;
        R2=[FP+0x8];
        R3=[FP+0xc];
        R0=[FP+0x10];
        R1=[FP+0x14];
        SP +=-8;
        [SP]=R0;
        R0 = R1;
        [SP+0x4]=R0;
        SP +=-8;
        [SP]=R2;
        R0 = R3;
        [SP+0x4]=R0;
        CALL ___cmpdi2;
        SP +=16;
        UNLINK ;
        RTS;
#endif

#ifdef L_negdi2
.align 2
.global ___negdi2;
.type ___negdi2, STT_FUNC;
.global __negdi2;
.type __negdi2, STT_FUNC;

dbg:
    	DBG R0;
    	RTS;

___negdi2:
__negdi2:
        LINK 0x0;
        [--SP]=( R7:4);
        R0=[FP+0x8];
        R1=[FP+0xc];
        R3 = R0;
        R4 = R1;
        CC = R3==0;
        IF CC JUMP negdi_4;
        R2= ~R4;
        R0= -R3;
        R1 = R2;
        JUMP.S negdi_6;
 
negdi_4:
        R0=0;
        R1= -R4;
 
negdi_6:
        ( R7:4)=[SP++];
        UNLINK ;
        RTS;
#endif

#ifdef L_ashldi3
.align 2
.global ___ashldi3;
.type ___ashldi3, STT_FUNC;
.global __ashldi3;
.type __ashldi3, STT_FUNC;

___ashldi3:
__ashldi3:
        LINK 0x0;
        [--SP]=( R7:6);
        R6=[FP+0x8];
        R7=[FP+0xc];
        R3= -R1;
        R2=32;
        R2 = R2+R3;
        R3 = R6;
        R3 >>= R2;
        R7 <<= R1;
        R7 = R7|R3;
        R6 <<= R1;
        R0 = R6;
        R1 = R7;
        ( R7:6)=[SP++];
        UNLINK ;
        RTS;
#endif

#ifdef L_ashrdi3
.align 2
.global ___ashrdi3;
.type ___ashrdi3, STT_FUNC;
.global __ashrdi3;
.type __ashrdi3, STT_FUNC;

___ashrdi3:
__ashrdi3:
        LINK 0x0;
        [--SP]=( R7:6);
        R6=[FP+0x8];
        R7=[FP+0xc];
        R3= -R1;
        R2=32;
        R2 = R2+R3;
        R3 = R7;
        R3 <<= R2;
        R6 >>= R1;
        R6 = R6|R3;
        R7 >>>= R1;
        R0 = R6;
        R1 = R7;
        ( R7:6)=[SP++];
        UNLINK ;
        RTS; 
#endif


#ifdef L_extendsfdf2
.align 2
.global ___extendsfdf2;
.type ___extendsfdf2, STT_FUNC;
.global __extendsfdf2;
.type __extendsfdf2, STT_FUNC;

___extendsfdf2:
__extendsfdf2:
        [--sp] = ( r7:6 );
        R1  =R0 ;
        cc =R1 ==0;
        if cc jump L$20;
        R0  =R1 ;
        R0  >>>=31;
        R6  =R0 ;
        R6  <<=31;
        R0  =R1 ;
        R0  >>>=23;
        R0  = R0.B  (Z);
        R2  = 896 (x);
        R2 =R2 +R0 ; //immed->Dreg
        R0  =R2 ;
        R0  <<=20;
        R6  =R6 |R0 ;
        R3.L  = -1; R3.H  = 127;
        R3  =R1 &R3 ;
        R2  =R3 ;
        R2  >>=3;
        R2  =R2 |R6 ;
        R3  <<=29;
        R1  =R2 ;
        R0  =R3 ;
        jump.s L$21;
L$20:
        R0  = 0 (x);
        R1  = 0 (x);
L$21:
        ( r7:6 ) = [sp++];
        rts;
#endif


#ifdef L_truncdfsf2
.align 2
.global ___truncdfsf2;
.type ___truncdfsf2, STT_FUNC;
.global __truncdfsf2;
.type __truncdfsf2, STT_FUNC;

___truncdfsf2:
__truncdfsf2:
        LINK 0;
        [--sp] = ( r7:7 );
        [FP +8] =R0 ;
        [FP +12] =R1 ;
        [FP +16] =R2 ;
        R3  =[FP +8];
        R2  =[FP +12];
        cc =R2 ==0;
        if !cc jump L$23;
        cc =R3 ==0;
        if !cc jump L$23;
        R0  = 0 (Z);
        jump.s L$25;
L$23:
        P1  =R2 ;
        P2  =P1 +P1 ;
        R0  =P2 ;
        R0  >>=21;
        R7  = -896 (x);
        R7 =R7 +R0 ; //immed->Dreg
        R0.L  = -1; R0.H  = 15;
        R0  =R2 &R0 ;
        BITSET (R0 ,20);
        R0  <<=10;
        R1  =R3 ;
        R1  >>=22;
        R1  =R0 |R1 ;
        R1  >>=6;
        R1 +=1;
        R1  >>>=1;
        cc =!BITTST (R1 ,24);
        if cc jump L$24;
        R1  >>>=1;
        R7 +=1;
L$24:
        BITCLR (R1 ,23);
        R0  =R2 ;
        R0  >>>=31;
        R0  <<=31;
        R7  <<=23;
        R0  =R0 |R7 ;
        R0  =R0 |R1 ;
L$25:
        ( r7:7 ) = [sp++];
        UNLINK;
        rts;

#endif






