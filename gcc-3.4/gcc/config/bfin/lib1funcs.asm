#ifdef L_divsi3
.text
.align 2
.global ___divsi3;
.type ___divsi3, STT_FUNC;
.global __divsi3;
.type __divsi3, STT_FUNC;

___divsi3:
__divsi3:
        [--SP]= RETS;
	[--SP] = R7;

	R2 = -R0;
        CC = R0 < 0;
	IF CC R0 = R2;
	R7 = CC;

	R2 = -R1;
        CC = R1 < 0;
	IF CC R1 = R2;
	R2 = CC;
	R7 = R7 ^ R2;

        CALL ___udivsi3;

	CC = R7;
	R1 = -R0;
	IF CC R0 = R1;

	R7 = [SP++];
        RETS = [SP++];
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
        [--SP] = RETS;
	[--SP] = R0;
	[--SP] = R1;
        CALL ___divsi3;
	R2 = [SP++];
	R1 = [SP++];
	R2 *= R0;
	R0 = R1 - R2;
	RETS = [SP++];
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
        P0 = 32;
        LSETUP (0f, 1f) LC0 = P0;
	/* upper half of dividend */
        R3 = 0;
0:
	/* The first time round in the loop we shift in garbage, but since we
	   perform 33 shifts, it doesn't matter.  */
	R0 = ROT R0 BY 1;
	R3 = ROT R3 BY 1;
	R2 = R3 - R1;
        CC = R3 < R1 (IU);
1:
	/* Last instruction of the loop.  */
	IF ! CC R3 = R2;

	/* Shift in the last bit.  */
	R0 = ROT R0 BY 1;
	/* R0 is the result, R3 contains the remainder.  */
	R0 = ~ R0;
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
	[--SP] = RETS;
	CALL ___udivsi3;
	R0 = R3;
	RETS = [SP++]; 
	RTS;
#endif

