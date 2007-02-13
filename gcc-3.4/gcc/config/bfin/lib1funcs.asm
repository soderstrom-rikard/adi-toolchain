#ifdef L_divsi3
.text
.align 2
.global ___divsi3;
.type ___divsi3, STT_FUNC;

___divsi3:
	/* Attempt to use divide primitives first; these will handle
	   most cases, and they're quick - avoids stalls incurred by
	   testing for identities.  */
	R3 = R0 ^ R1;
	R0 = ABS R0;
	CC = V;
	r3 = rot r3 by -1;
	r1 = abs r1;
	/* Now both positive, r3.30 means "negate result", 
	   r3.31 means overflow, add one to result.  */
	cc = r0 < r1;
	if cc jump L$ret_zero;
	r2 = r1 >> 15;
	cc = r2;
	if cc jump L$IDENTS;
	r2 = r1 << 16;
	cc = r2 <= r0;
	if cc jump L$IDENTS;

	DIVS(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);

	R0 = R0.L (Z);
	r1 = r3 >> 31;
	r0 = r0 + r1;
	r1 = -r0;
	cc = bittst(r3, 30);
	if cc r0 = r1;
	RTS;

	/* Can't use the primitives. Test common identities. 
	   If the identity is true, return the value in R2.  */

L$IDENTS:
	/* Check for divide by zero.  */
	CC = R1 == 0;
	IF CC JUMP L$IDENT_RETURN;

	/* Check for division of zero.  */
	CC = R0 == 0;
	IF CC JUMP L$ZERO_RETURN;

	/* Check for identical operands.  */
	CC = R0 == R1;
	IF CC JUMP L$IDENT_RETURN;

	/* Check for divide by 1.  */
	CC = R1 == 1;
	IF CC JUMP L$IDENT_RETURN;

	R2.L = ONES R1;
	R2 = R2.L (Z);
	CC = R2 == 1;
	IF CC JUMP L$power_of_two;

	/* Identities haven't helped either.
	   Perform the full division process.  */

	P1 = 31;		/* Set loop counter   */

	[--SP] = (R7:5);	/* Push registers R5-R7 */
	R2 = -R1;
	[--SP] = R2;
	R2 = R0 << 1;		/* R2 lsw of dividend  */ 
	R6 = R0 ^ R1;		/* Get sign */
	R5 = R6 >> 31;		/* Shift sign to LSB */

	R0 = 0 ;		/* Clear msw partial remainder */ 
	R2 = R2 | R5;		/* Shift quotient bit */ 
	R6 = R0 ^ R1;		/* Get new quotient bit */  

	LSETUP(L$LST,L$LEND)  LC0 = P1;	/* Setup loop */
L$LST:	R7 = R2 >> 31;		/* record copy of carry from R2 */
        R2 = R2 << 1;		/* Shift 64 bit dividend up by 1 bit */
        R0 = R0 << 1 || R5 = [SP];
        R0 = R0 | R7;		/* and add carry */
        CC = R6 < 0;		/* Check quotient(AQ) */
				/* we might be subtracting divisor (AQ==0) */
        IF CC R5 = R1;		/* or we might be adding divisor  (AQ==1) */
        R0 = R0 + R5;		/* do add or subtract, as indicated by AQ */
        R6 = R0 ^ R1;		/* Generate next quotient bit */
        R5 = R6 >> 31;
				/* Assume AQ==1, shift in zero */
        BITTGL(R5,0);		/* tweak AQ to be what we want to shift in */
L$LEND:  R2 = R2 + R5;		/* and then set shifted-in value to
				   tweaked AQ.  */
	r1 = r3 >> 31;
	r2 = r2 + r1;
	cc = bittst(r3,30);
	r0 = -r2;
	if !cc r0 = r2;
	SP += 4;
	(R7:5)= [SP++];		/* Pop registers R6-R7 */
	RTS;

L$IDENT_RETURN:
	CC = R1 == 0;		/* check for divide by zero  => 0x7fffffff */
	R2 = -1 (X);
	R2 >>= 1;
	IF CC JUMP L$TRUE_IDENT_RETURN;

	CC = R0 == R1;		/* check for identical operands => 1 */
	R2 = 1 (Z);
	IF CC JUMP L$TRUE_IDENT_RETURN;

	R2 = R0;		/* assume divide by 1 => numerator */

L$TRUE_IDENT_RETURN:
	R0 = R2;		/* Return an identity value */
	R2 = -R2;
	CC = bittst(R3,30);
	IF CC R0 = R2;
L$ZERO_RETURN:
	RTS;			/* ...including zero */

L$power_of_two:
	/* Y has a single bit set, which means it's a power of two.
	   That means we can perform the division just by shifting
	   X to the right the appropriate number of bits.  */

	/* signbits returns the number of sign bits, minus one.
	   1=>30, 2=>29, ..., 0x40000000=>0. Which means we need
	   to shift right n-signbits spaces. It also means 0x80000000
	   is a special case, because that *also* gives a signbits of 0.  */

	R2 = R0 >> 31;
	CC = R1 < 0;
	IF CC JUMP L$TRUE_IDENT_RETURN;
	
	R1.l = SIGNBITS R1;
	R1 = R1.L (Z);
	R1 += -30;
	R0 = LSHIFT R0 by R1.L;
	r1 = r3 >> 31;
	r0 = r0 + r1;
	R2 = -R0;		/* negate result if necessary */
	CC = bittst(R3,30);
	IF CC R0 = R2;
	RTS; 

L$ret_zero:
	R0 = 0;
	RTS;
	.size ___divsi3, .-___divsi3;
#endif

#ifdef L_modsi3	
.align 2
.global ___modsi3;
.type ___modsi3, STT_FUNC;

___modsi3:
	CC=R0==0;
	IF CC JUMP L$RET_R0;	/* Return 0, if numerator  == 0 */
	CC=R1==0;
	IF CC JUMP L$RET_ZERO;	/* Return 0, if denominator == 0 */
	CC=R0==R1;
	IF CC JUMP L$RET_ZERO;	/* Return 0, if numerator == denominator */
	CC = R1 == 1;
	IF CC JUMP L$RET_ZERO;	/* Return 0, if denominator ==  1 */
	CC = R1 == -1;
	IF CC JUMP L$RET_ZERO;	/* Return 0, if denominator == -1 */

	/* Valid input. Use ___divsi3 () to compute the quotient, and then
	   derive the remainder from that.  */

	[--SP] = (R7:6);	/* Push  R7 and R6 */
	[--SP] = RETS;		/* and return address */
	R7 = R0;		/* Copy of R0 */   
	R6 = R1;		/* Save for later */
	SP += -12;		/* Should always provide this space */
	CALL.X ___divsi3;	/* Compute signed quotient using __divsi3 ()*/
	SP += 12;
	R0 *= R6;		/* Quotient * divisor */
	R0 = R7 - R0;		/* Dividend - ( quotient *divisor) */
	RETS = [SP++];		/* Get back return address */
	(R7:6) = [SP++];	/* Pop registers R7 and R4 */
	RTS;			/* Store remainder    */

L$RET_ZERO:
	R0 = 0;
L$RET_R0:
	RTS;
	.size ___modsi3, .-___modsi3;
#endif

#ifdef L_udivsi3
.align 2
.global ___udivsi3;
.type ___udivsi3, STT_FUNC;

___udivsi3:
	CC = R0 < R1 (IU);	/* If X < Y, always return 0 */
	IF CC JUMP L$RETURN_IDENT;

	R2 = R1 << 16;		
	CC = R2 <= R0 (IU);
	IF CC JUMP L$IDENTS;

	R2 = R0 >> 31;		/* if X is a 31-bit number */
	R3 = R1 >> 15;		/* and Y is a 15-bit number */
	R2 = R2 | R3;		/* then it's okay to use the DIVQ builtins */
	CC = R2;
	IF CC JUMP L$y_16bit;

	/* METHOD 1: FAST DIVQ
	   We know we have a 31-bit dividend, and 15-bit divisor
	   so we can use the simple divq approach (first setting
	   AQ to 0 - implying unsigned division, then 16 DIVQ's).  */

	AQ = CC;		/* Clear AQ (CC==0) */

	/* ISR States: When dividing two integers (32.0/16.0)
	   using divide primitives, we need to shift the dividend
	   one bit to the left. We have already checked that
	   we have a 31-bit number so we are safe to do that.  */
	R0 <<= 1;
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	DIVQ(R0, R1);
	R0 = R0.L (Z);
	RTS;

L$y_16bit:
	/* We know that the upper 17 bits of Y might have bits set,
	   or that the sign bit of X might have a bit. If Y is a
	   16-bit number, but not bigger, then we can use the builtins
	   with a post-divide correction.
	   R3 currently holds Y>>15, which means R3's LSB is the
	   bit we're interested in.  */

	/* According to the ISR, to use the Divide primitives for
	   unsigned integer divide, the useable range is 31 bits.  */
	CC = ! BITTST(R0, 31);

	/* If condition is true we can scale our inputs and use
	   the divide primitives, with some post-adjustment.  */
	R3 += -1;		/* if so, Y is 0x00008nnn */
	CC &= AZ;

	/* If condition is true we can scale our inputs and use
	   the divide primitives, with some post-adjustment.  */
	R3 = R1 >> 1;		/* Pre-scaled divisor for primitive case */
	R2 = R0 >> 16 ;  			

	R2 = R3 - R2;		/* shifted divisor < upper 16 bits of dividend */
	CC &= AC0;
	IF CC JUMP L$shift_and_correct;

	/* Fall through to the identities */

	/* METHOD 2: identities and manual calculation
	   We are not able to use the divide primites,
	   but may still catch some special cases.  */
L$IDENTS:
	/* Test for common identities. Value to be returned is placed in R2. */
	CC = R0 == 0;		/* 0/Y => 0 */
	IF CC JUMP L$RETURN_R0;
	CC = R0 == R1;		/* X==Y => 1 */
	IF CC JUMP L$RETURN_IDENT;
	CC = R1 == 1;		/* X/1 => X */
	IF CC JUMP L$RETURN_IDENT;

	R2.L = ONES R1;
	R2 = R2.L (Z);
	CC = R2 == 1;
	IF CC JUMP L$power_of_two;

	[--SP] = (R7:5);	/* Push registers R5-R7 */

	/* Idents don't match. Go for the full operation.  */

	R6 = 2;			/* assume we'll shift two */
	R3 = 1;

	P2 = R1;
	/* If either R0 or R1 have sign set, divide them by two,
	   and note it's been done. */
	CC = R1 < 0;
	R2 = R1 >> 1;
	IF CC R1 = R2;		/* Possibly-shifted R1 */
	IF !CC R6 = R3;		/* R1 doesn't, so at most 1 shifted */

	P0 = 0;
	R3 = -R1;
	[--SP] = R3;
	R2 = R0 >> 1;
	R2 = R0 >> 1;
	CC = R0 < 0;
	IF CC P0 = R6;		/* Number of values divided */
	IF !CC R2 = R0;		/* Shifted R0 */

	/* P0 is 0, 1 (NR/=2) or 2 (NR/=2, DR/=2) */
	/* r2 holds Copy dividend  */
	R3 = 0;			/* Clear partial remainder */
	R7 = 0;			/* Initialise quotient bit */

	P1 = 32;		/* Set loop counter */
	LSETUP(L$ULST, L$ULEND) LC0 = P1; /* Set loop counter */
L$ULST:	R6 = R2 >> 31;		/* R6 = sign bit of R2, for carry */
	R2 = R2 << 1;		/* Shift 64 bit dividend up by 1 bit */
	R3 = R3 << 1 || R5 = [SP];
	R3 = R3 | R6;		/* Include any carry */
	CC = R7 < 0;		/* Check quotient(AQ) */
				/* If AQ==0, we'll sub divisor */
	IF CC R5 = R1;		/* and if AQ==1, we'll add it. */
	R3 = R3 + R5;		/* Add/sub divsor to partial remainder */
	R7 = R3 ^ R1;		/* Generate next quotient bit */

	R5 = R7 >> 31;		/* Get AQ */
	BITTGL(R5, 0);		/* Invert it, to get what we'll shift */
L$ULEND:
	R2 = R2 + R5;		/* and "shift" it in. */

	CC = P0 == 0;		/* Check how many inputs we shifted */
	IF CC JUMP L$NO_MULT;	/* if none... */
	R6 = R2 << 1;
	CC = P0 == 1;
	IF CC R2 = R6;		/* if 1, Q = Q*2 */
	IF !CC R1 = P2;		/* if 2, restore stored divisor */

	R3 = R2;		/* Copy of R2 */
	R3 *= R1;		/* Q * divisor */
	R5 = R0 - R3;		/* Z = (dividend - Q * divisor) */
	CC = R1 <= R5 (IU);	/* Check if divisor <= Z? */
	R6 = CC;		/* if yes, R6 = 1 */
	R2 = R2 + R6;		/* if yes, add one to quotient(Q) */
L$NO_MULT:
	SP += 4;
	(R7:5) = [SP++];	/* Pop registers R5-R7 */
	R0 = R2;		/* Store quotient */
	RTS;

L$RETURN_IDENT:
	CC = R0 < R1 (IU);	/* If X < Y, always return 0 */
	R2 = 0;
	IF CC JUMP L$TRUE_RETURN_IDENT;
	R2 = -1 (X);		/* X/0 => 0xFFFFFFFF */
	CC = R1 == 0;
	IF CC JUMP L$TRUE_RETURN_IDENT;
	R2 = -R2;		/* R2 now 1 */
	CC = R0 == R1;		/* X==Y => 1 */
	IF CC JUMP L$TRUE_RETURN_IDENT;
	R2 = R0;		/* X/1 => X */

L$TRUE_RETURN_IDENT:
	R0 = R2;
L$RETURN_R0:
	RTS;

L$power_of_two:
	/* Y has a single bit set, which means it's a power of two.
	   That means we can perform the division just by shifting
	   X to the right the appropriate number of bits.  */

	/* signbits returns the number of sign bits, minus one.
	   1=>30, 2=>29, ..., 0x40000000=>0. Which means we need
	   to shift right n-signbits spaces. It also means 0x80000000
	   is a special case, because that *also* gives a signbits of 0.  */

	R2 = R0 >> 31;
	CC = R1 < 0;
	IF CC JUMP L$TRUE_RETURN_IDENT;

	R1.l = SIGNBITS R1;
	R1 = R1.L (Z);
	R1 += -30;
	R0 = LSHIFT R0 by R1.L;
	RTS;

	/* METHOD 3: PRESCALE AND USE THE DIVIDE PRIMITIVES
		     WITH SOME POST-CORRECTION
	   Two scaling operations are required to use the divide
	   primitives with a divisor > 0x7FFFF.
	   Firstly (as in method 1) we need to shift the dividend 1
	   to the left for integer division.
	   Secondly we need to shift both the divisor and dividend 1
	   to the right so both are in range for the primitives.
	   The left/right shift of the dividend does nothing
	   so we can skip it.  */
L$shift_and_correct:
	R2 = R0;
	/* R3 is already R1 >> 1 */
	CC=!CC;
	AQ = CC;		/* Clear AQ, got here with CC = 0 */   
	DIVQ(R2, R3);
	DIVQ(R2, R3);
	DIVQ(R2, R3);
	DIVQ(R2, R3);
	DIVQ(R2, R3);
	DIVQ(R2, R3);
	DIVQ(R2, R3);
	DIVQ(R2, R3);
	DIVQ(R2, R3);
	DIVQ(R2, R3);
	DIVQ(R2, R3);
	DIVQ(R2, R3);
	DIVQ(R2, R3);
	DIVQ(R2, R3);
	DIVQ(R2, R3);
	DIVQ(R2, R3);
  
	/* According to the Instruction Set Reference:
	   To divide by a divisor > 0x7FFF,
	   1. prescale and perform divide to obtain quotient (Q) (done above),
	   2. multiply quotient by unscaled divisor (result M)
	   3. subtract the product from the divident to get an error (E = X - M)
	   4. if E < divisor (Y) subtract 1, if E > divisor (Y) add 1,
	      else return quotient (Q)  */
	R3 = R2.L (Z);		/* Q = X' / Y' */
	R2 = R3;		/* Preserve Q */
	R2 *= R1;		/* M = Q * Y */
	R2 = R0 - R2;		/* E = X - M */
	R0 = R3;		/* Copy Q into result reg */
  
	/* Correction: If result of the multiply is negative, we overflowed
	   and need to correct the result by subtracting 1 from the result.  */
	R3 = 0xFFFF (Z);
	R2 = R2 >> 16;		/* E >> 16 */
	CC = R2 == R3;
	R3 = 1 ;
	R1 = R0 - R3;
	IF CC R0 = R1;	 
	RTS;
	.size ___udivsi3, .-___udivsi3;
#endif

#ifdef L_umodsi3
.align 2
.global ___umodsi3;
.type ___umodsi3, STT_FUNC;

___umodsi3:
	CC=R0==0;
	IF CC JUMP L$RET_R0;	/* Return 0, if NR == 0 */
	CC= R1==0;
	IF CC JUMP L$RET_ZERO;	/* Return 0, if DR == 0 */
	CC=R0==R1;             
	IF CC JUMP L$RET_ZERO;	/* Return 0, if NR == DR */
	CC = R1 == 1;
	IF CC JUMP L$RET_ZERO;	/* Return 0, if  DR == 1 */
	CC = R0<R1 (IU);
	IF CC JUMP L$RET_R0;	/* Return dividend (R0),IF NR<DR */

	[--SP] = (R7:6);	/* Push registers and */
	[--SP] = RETS;		/* Return address */
	R7 = R0;		/* Copy of R0 */   
	R6 = R1;
	SP += -12;		/* Should always provide this space */
	CALL.X ___udivsi3;	/* Compute unsigned quotient */
	SP += 12;
	R0 *= R6;		/* Quotient * divisor */
	R0 = R7 - R0;		/* Dividend - ( quotient *divisor) */
	RETS = [SP++];		/* Pop return address */
	(R7:6) = [SP++];	/* And registers */
	RTS;			/* Return remainder */
L$RET_ZERO:
	R0 = 0;
L$RET_R0:
	RTS;
	.size ___umodsi3, .-___umodsi3;
#endif

