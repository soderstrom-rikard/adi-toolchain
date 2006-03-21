.extern ___cmpsf2;
.text;
.global ___lesf2;
.type ___lesf2, STT_FUNC;
___lesf2:
	CALL.X	___cmpsf2;
	CC = R0 <= 0;
	R0 = CC;
	RTS;
	.size ___lesf2, .-___lesf2;
