.extern ___cmpsf2;
.text;
.global ___ltsf2;
.type ___ltsf2, STT_FUNC;
___ltsf2:
	CALL.X	___cmpsf2;
	CC = R0 < 0;
	R0 = CC;
	RTS;
	.size ___ltsf2, .-___ltsf2;
