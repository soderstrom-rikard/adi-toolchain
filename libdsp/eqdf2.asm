.extern ___cmpdf2;
.text;
.global ___eqdf2;
.type ___eqdf2, STT_FUNC;
___eqdf2:
	CALL.X	___cmpdf2;
	CC = R0 == 0;
	R0 = CC;
	RTS;
	.size ___eqdf2, .-___eqdf2;
