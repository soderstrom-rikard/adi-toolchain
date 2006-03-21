.extern ___cmpsf2;
.text;
.global ___gesf2;
.type ___gesf2, STT_FUNC;
___gesf2:
	R2 = R1;
	R1 = R0;
	R0 = R2;
	CALL.X	___cmpsf2;
	CC = R0 <= 0;
	R0 = CC;
	RTS;
	.size ___gesf2, .-___gesf2;
