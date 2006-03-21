.extern ___cmpdf2;
.text;
.global ___ledf2;
.type ___ledf2, STT_FUNC;
___ledf2:
	CALL.X	___cmpdf2;
	CC = R0 <= 0;
	R0 = CC;
	RTS;
	.size ___ledf2, .-___ledf2;
