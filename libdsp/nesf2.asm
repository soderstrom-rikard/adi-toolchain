.extern ___cmpsf2;
.text;
.global ___nesf2;
.type ___nesf2, STT_FUNC;
___nesf2:
	CALL.X	___cmpsf2;
	CC = R0 == 0;
	CC = !CC;
	R0 = CC;
	RTS;
	.size ___nesf2, .-___nesf2;
