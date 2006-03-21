.extern ___cmpdf2;
.text;
.global ___ltdf2;
.type ___ltdf2, STT_FUNC;
___ltdf2:
	CALL.X	___cmpdf2;
	CC = R0 < 0;
	R0 = CC;
	RTS;
	.size ___ltdf2, .-___ltdf2;
