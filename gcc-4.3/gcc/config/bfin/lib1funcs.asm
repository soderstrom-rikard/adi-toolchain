/* libgcc functions for Blackfin.
   Copyright (C) 2005 Free Software Foundation, Inc.
   Contributed by Analog Devices.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GCC; see the file COPYING.  If not, write to
the Free Software Foundation, 51 Franklin Street, Fifth Floor,
Boston, MA 02110-1301, USA.  */

/* As a special exception, if you link this library with files
   compiled with GCC to produce an executable, this does not cause
   the resulting executable to be covered by the GNU General Public License.
   This exception does not however invalidate any other reasons why
   the executable file might be covered by the GNU General Public License.  */

#if defined(__ELF__) && defined(__linux__)
.section .note.GNU-stack,"",%progbits
#endif

.text

#ifdef L_divsi3
.align 2
.global ___divsi3;
.type ___divsi3, STT_FUNC;

___divsi3:

.Ls_main_branch:
	R3 = R0 ^ R1;
	R2 = - R0;
	R0 = MAX(R0,R2);
	R2 = -R1;
	R1 = MAX(R1,R2);
	R2 = R0 >> 1;
	CC = R2 < R1 (IU);
	IF CC JUMP .Ls_Q_has_only_one_bit;

	P1 = R3;
	R3 = R1>>1;
	R3.L = SIGNBITS R3;
	R1 = LSHIFT R1 BY R3.L;
	R2 = R1 << 15;
	CC = R2 == 0;
	IF !CC JUMP .Ls_use_sfw_D_has_16bit_or_more;

	R2.L = SIGNBITS R0;
	R0 = LSHIFT R0 BY R2.L;
	R2.L = R3.L - R2.L (NS);
	P2 = R2;
	CC = R0 == R1;
	IF CC JUMP .Ls_N_is_MIN_D_is_1_bit_set;

	R1 >>= 17;

.Ls_use_divq_main_branch:
	AQ = CC;

	LOOP(s_lp_use_divq) LC0 = P2;
	LOOP_BEGIN s_lp_use_divq;
	DIVQ(R0, R1);
	LOOP_END s_lp_use_divq;

	R0 = EXTRACT(R0, R2.L) (Z);
	R1 = -R0;
	CC = P1<0;
	IF CC R0 = R1;
	RTS;

.Ls_N_is_MIN_D_is_1_bit_set:
	R0 = 1;
	R0 = LSHIFT R0 BY R2.L;
	R1 = -R0;
	CC = P1 < 0;
	IF CC R0 = R1;
	RTS;

.Ls_use_sfw_D_has_16bit_or_more:
	R2 = R0 >> 1;
	R2.L = SIGNBITS R2;
	R3.H = R3.L - R2.L (NS);
	R3 = R3 >>16;
	P2 = R3;
	R0 = LSHIFT R0 BY R2.L;
	R0 = R0 - R1;
	CC = !BITTST(R0, 31);
	R1 >>>= 1;

	LOOP(s__use_sfw_loop) LC0 = P2;
	LOOP_BEGIN s__use_sfw_loop;
	R0 = R0 + R1, R2 = R0 - R1;
	IF CC R0 = R2;
	R0 = ROT R0 BY 1;
	LOOP_END s__use_sfw_loop;

	R0 = EXTRACT(R0, R3.L)(Z);
	R0 = ROT R0 BY 1;
	R1 = -R0;
	CC = P1<0;
	IF CC R0 = R1;
	RTS;

.Ls_Q_has_only_one_bit:
	CC = R1 <= R0 (IU);
	R0 = CC;
	R1 = -R0;
	CC = R3<0;
	IF CC R0 = R1;
	RTS;
	.size ___divsi3, .-___divsi3;
#endif

#ifdef L_modsi3	
.align 2
.global ___modsi3;
.type ___modsi3, STT_FUNC;

___modsi3:
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

.size ___modsi3, .-___modsi3
#endif

#ifdef L_udivsi3
.align 2
.global ___udivsi3;
.type ___udivsi3, STT_FUNC;

___udivsi3:
.Lu_main_branch:
	R2 = R0 >> 1;
	CC = R2 < R1 (IU);
	IF CC JUMP .Lu_Q_has_only_one_bit;

	R3 = R1 >> 1;
	R3.L = SIGNBITS R3;
	R1 = LSHIFT R1 BY R3.L;
	R2 = R1 << 15;
	CC = R2 == 0;
	IF !CC JUMP .Lu_use_sfw_D_has_16bit_or_more;

	CC = R0 < 0;
	IF CC JUMP .Lu_MSB_of_N_is_1;

	R1.L = SIGNBITS R0;
	R2.L = R3.L - R1.L (NS);
	P2 = R2;
	R0 = LSHIFT R0 BY R1.L;
	R1 >>= 17;

.Lu_use_divq_main_branch:
	AQ = CC;

	LOOP(u_lp_use_divq_when_MSB_of_N_is_0) LC0 = P2;
	LOOP_BEGIN u_lp_use_divq_when_MSB_of_N_is_0;
	DIVQ(R0, R1);
	LOOP_END u_lp_use_divq_when_MSB_of_N_is_0;

	R0 = EXTRACT(R0, R2.L) (Z);
	RTS;

.Lu_MSB_of_N_is_1: 
	R3 = R3.L (Z);
	P2 = R3;
	R0 = R0 - R1;
	R1 >>= 17;

.Lu_use_divq_when_MSB_of_N_is_1:
	R2 = ~R0;
	R2 = R2 >> 31;
	CC = BITTST(R0, 31);
	AQ = CC;

	LOOP(u_lp_use_divq_MSB_of_N_is_1) LC0 = P2;
	LOOP_BEGIN u_lp_use_divq_MSB_of_N_is_1;
	DIVQ(R0, R1);
	LOOP_END u_lp_use_divq_MSB_of_N_is_1;

	R2 = LSHIFT R2 BY R3.L;
	R0 = EXTRACT(R0, R3.L) (Z);
	R0 = R0+R2;
	RTS;

.Lu_use_sfw_D_has_16bit_or_more:
	R2 = R0>>1;
	R2.L = SIGNBITS R2;
	R3.H = R3.L - R2.L (NS);
	R3 = R3 >> 16;
	P2 = R3;
	R0 = LSHIFT R0 BY R2.L;
	R0 = R0 - R1;
	CC = !BITTST(R0, 31);
	R1 >>>= 1;

	LOOP(u__use_sfw_loop) LC0 = P2;
	LOOP_BEGIN u__use_sfw_loop;
	R0 = R0 + R1, R2 = R0 - R1;
	IF CC R0 = R2;
	R0 = ROT R0 BY 1;
	LOOP_END u__use_sfw_loop;

	R0 = EXTRACT(R0, R3.L)(Z);
	R0 = ROT R0 BY 1;
	RTS;

.Lu_Q_has_only_one_bit:
	CC = R1 <= R0 (IU);
	R0 = CC;
	RTS;
	.size ___udivsi3, .-___udivsi3;
#endif

#ifdef L_umodsi3
.align 2
.global ___umodsi3;
.type ___umodsi3, STT_FUNC;

___umodsi3:
	[--SP] = RETS;
	[--SP] = R0;
	[--SP] = R1;
	CALL ___udivsi3;
	R2 = [SP++];
	R1 = [SP++];
	R2 *= R0;
	R0 = R1 - R2;
	RETS = [SP++];
	RTS; 

.size ___umodsi3, .-___umodsi3
#endif

#ifdef L_umulsi3_highpart
.align 2
.global ___umulsi3_highpart;
.type ___umulsi3_highpart, STT_FUNC;

___umulsi3_highpart:
	A1 = R1.L * R0.L (FU);
	A1 = A1 >> 16;
	A0 = R1.H * R0.H, A1 += R1.L * R0.H (FU);
	A1 += R0.L * R1.H (FU);
	A1 = A1 >> 16;
	A0 += A1;
	R0 = A0 (FU);
	RTS;

.size ___umulsi3_highpart, .-___umulsi3_highpart
#endif

#ifdef L_smulsi3_highpart
.align 2
.global ___smulsi3_highpart;
.type ___smulsi3_highpart, STT_FUNC;

___smulsi3_highpart:
	A1 = R1.L * R0.L (FU);
	A1 = A1 >> 16;
	A0 = R0.H * R1.H, A1 += R0.H * R1.L (IS,M);
	A1 += R1.H * R0.L (IS,M);
	A1 = A1 >>> 16;
	R0 = (A0 += A1);
	RTS;

.size ___smulsi3_highpart, .-___smulsi3_highpart
#endif

#ifdef L_muldi3
.align 2
.global ___muldi3;
.type ___muldi3, STT_FUNC;

/*
	   R1:R0 * R3:R2
	 = R1.h:R1.l:R0.h:R0.l * R3.h:R3.l:R2.h:R2.l
[X]	 = (R1.h * R3.h) * 2^96
[X]	   + (R1.h * R3.l + R1.l * R3.h) * 2^80
[X]	   + (R1.h * R2.h + R1.l * R3.l + R3.h * R0.h) * 2^64
[T1]	   + (R1.h * R2.l + R3.h * R0.l + R1.l * R2.h + R3.l * R0.h) * 2^48
[T2]	   + (R1.l * R2.l + R3.l * R0.l + R0.h * R2.h) * 2^32
[T3]	   + (R0.l * R2.h + R2.l * R0.h) * 2^16
[T4]	   + (R0.l * R2.l)

	We can discard the first three lines marked "X" since we produce
	only a 64 bit result.  So, we need ten 16-bit multiplies.

	Individual mul-acc results:
[E1]	 =  R1.h * R2.l + R3.h * R0.l + R1.l * R2.h + R3.l * R0.h
[E2]	 =  R1.l * R2.l + R3.l * R0.l + R0.h * R2.h
[E3]	 =  R0.l * R2.h + R2.l * R0.h
[E4]	 =  R0.l * R2.l

	We also need to add high parts from lower-level results to higher ones:
	E[n]c = E[n] + (E[n+1]c >> 16), where E4c := E4

	One interesting property is that all parts of the result that depend
	on the sign of the multiplication are discarded.  Those would be the
	multiplications involving R1.h and R3.h, but only the top 16 bit of
	the 32 bit result depend on the sign, and since R1.h and R3.h only
	occur in E1, the top half of these results is cut off.
	So, we can just use FU mode for all of the 16-bit multiplies, and
	ignore questions of when to use mixed mode.  */

___muldi3:
	/* [SP] technically is part of the caller's frame, but we can
	   use it as scratch space.  */
	A0 = R2.H * R1.L, A1 = R2.L * R1.H (FU) || R3 = [SP + 12];	/* E1 */
	A0 += R3.H * R0.L, A1 += R3.L * R0.H (FU) || [SP] = R4;		/* E1 */
	A0 += A1;							/* E1 */
	R4 = A0.w;
	A0 = R0.l * R3.l (FU);						/* E2 */
	A0 += R2.l * R1.l (FU);						/* E2 */

	A1 = R2.L * R0.L (FU);						/* E4 */
	R3 = A1.w;
	A1 = A1 >> 16;							/* E3c */
	A0 += R2.H * R0.H, A1 += R2.L * R0.H (FU);			/* E2, E3c */
	A1 += R0.L * R2.H (FU);						/* E3c */
	R0 = A1.w;
	A1 = A1 >> 16;							/* E2c */
	A0 += A1;							/* E2c */
	R1 = A0.w;

	/* low(result) = low(E3c):low(E4) */
	R0 = PACK (R0.l, R3.l);
	/* high(result) = E2c + (E1 << 16) */
	R1.h = R1.h + R4.l (NS) || R4 = [SP];
	RTS;

.size ___muldi3, .-___muldi3
#endif
