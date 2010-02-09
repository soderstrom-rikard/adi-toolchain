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
	.long 0
	.text
	.global __start
__start:
	.endm

	.macro system_call nr:req
	P0 = \nr (X);
	EXCPT 0;
	.endm

	.macro exit rc
	P0.H = _params;
	P0.L = _params;
	R0 = \rc (X);
	[P0] = R0;
	R0 = P0;
	system_call 1
	.endm

	.macro pass
	CALL __pass;
	.endm

	.macro fail
	CALL __fail;
	.endm

	.macro write fd:req, buf:req, count:req
	P0.H = _params;
	P0.L = _params;
	R0 = \fd (X);
	[P0] = R0;
	R0.H = \buf;
	R0.L = \buf;
	[P0 + 4] = R0;
	R0 = \count (X);
	[P0 + 8] = R0;
	R0 = P0;
	system_call 5
	.endm

__pass:
	write 1, _passmsg, 5
	exit 0

__fail:
	write 1, _failmsg, 5
	exit 1
