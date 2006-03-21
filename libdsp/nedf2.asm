.extern ___cmpdf2;
.text;
.global ___nedf2;
.type ___nedf2, STT_FUNC;
___nedf2:
	CALL.X	___cmpdf2;
	CC = R0 == 0;
	CC = !CC;
	R0 = CC;
	RTS;
	.size ___nedf2, .-___nedf2;
