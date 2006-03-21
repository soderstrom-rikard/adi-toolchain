.extern ___cmpsf2;
.text;
.global ___gtsf2;
.type ___gtsf2, STT_FUNC;
___gtsf2:
	R2 = R1;
	R1 = R0;
	R0 = R2
	CALL.X	___cmpsf2;
	CC = R0 < 0;
	R0 = CC;
	RTS;
	.size ___gtsf2, .-___gtsf2;
