.extern ___cmpsf2;
.text;
.global ___eqsf2;
.type ___eqsf2, STT_FUNC;
___eqsf2:
	CALL.X	___cmpsf2;
	CC = R0 == 0;
	R0 = CC;
	RTS;
	.size ___eqsf2, .-___eqsf2;
