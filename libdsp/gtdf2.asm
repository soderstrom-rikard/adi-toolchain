.extern ___cmpdf2;
.text;
.global ___gtdf2;
.type ___gtdf2, STT_FUNC;
___gtdf2:
	LINK 16;
	[FP + 16] = R2;
	[SP + 12] = R1;
	R2 = R0;
	R1 = [FP + 20];
	R0 = [FP + 16];
	CALL.X	___cmpdf2;
	CC = R0 < 0;
	R0 = CC;
	UNLINK;
	RTS;
	.size ___gtdf2, .-___gtdf2;
