# R0 and P0 are used as tmps, consider them call clobbered by these macros.

# To build for hardware, use:
# bfin-linux-uclibc-gcc -nostdlib -g -Wa,--defsym,BFIN_HOST=1 foo.s

	.macro start
.ifndef BFIN_HOST
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
.endif
	.text
	.global __start
__start:
	.endm

	.macro system_call nr:req
	P0 = \nr (X);
	EXCPT 0;
	.endm

	.macro exit rc:req
	R0 = \rc (X);
.ifndef BFIN_HOST
	P0.H = _params;
	P0.L = _params;
	[P0] = R0;
	R0 = P0;
.endif
	system_call 1
	.endm

	.macro pass
	CALL __pass;
	.endm

	.macro fail
	CALL __fail;
	.endm

	.macro write fd:req, buf:req, count:req
.ifndef BFIN_HOST
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
.endif
	.endm

__pass:
	write 1, _passmsg, 5
	exit 0

__fail:
	write 1, _failmsg, 5
	exit 1

	.macro imm32 reg:req, val:req
	\reg\().L = ((\val) & 0xffff);
	\reg\().H = (((\val) >> 16) & 0xffff);
	.endm

	.macro dmm32 reg:req, val:req
	[--SP] = R0;
	imm32 R0, \val
	\reg = R0;
	R0 = [SP++];
	.endm
