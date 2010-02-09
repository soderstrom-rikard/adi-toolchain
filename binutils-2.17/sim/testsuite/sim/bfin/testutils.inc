# R0 and P0 are used as tmps, consider them call clobbered by these macros.

	.macro start
	.data
_failmsg:
	.ascii "fail\n"
_passmsg:
	.ascii "pass\n"
	.align 4
_params:
	.long 0
	.long 0
	.long 0
	.text
	.global __start
__start:
	.endm

	.macro exit rc
	P0.H = _params;
	P0.L = _params;
	R0 = \rc (X);
	[P0] = R0;
	R0 = P0;
	P0 = 1 (X);
	EXCPT 0;
	.endm

	.macro pass
	CALL __pass;
	.endm

	.macro fail
	CALL __fail;
	.endm

__pass:
	P0.H = _params;
	P0.L = _params;
	R0 = 1 (X);
	[P0] = R0;
	R0.H = _passmsg;
	R0.L = _passmsg;
	[P0 + 4] = R0;
	R0 = 5 (X);
	[P0 + 8] = R0;
	R0 = P0;
	P0 = 5 (X);
	EXCPT 0;
	exit 0

__fail:
	P0.H = _params;
	P0.L = _params;
	R0 = 1 (X);
	[P0] = R0;
	R0.H = _failmsg;
	R0.L = _failmsg;
	[P0 + 4] = R0;
	R0 = 5 (X);
	[P0 + 8] = R0;
	R0 = P0;
	P0 = 5 (X);
	EXCPT 0;
	exit 1
