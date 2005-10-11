	.text
	.align 	2

	.global	_mainCRTStartup
	.global	_start
	.global	start
start:
_start:
_mainCRTStartup:

	/* Start by setting up a stack */
	/* Zero the memory in the .bss section.  */

	p0.l = _edata;
	p0.h = _edata;
	p1.l = _end;
	p1.h = _end;
	p1 -= p0;
	r0 = 0;
	lsetup (clear_bss, clear_bss) lc0 = p1;
clear_bss:
	B [p0++] = r0;

	/* Need to set up standard file handles */
	/*  Parse string at r1 */

	p0.l = __init;
	p0.h = __init; 
	call	(p0)

	p0.l = _atexit;
	p0.h = _atexit;
	r0.l = __fini;
	r0.h = __fini; 
	call	(p0)

	p0.l = _initialise_monitor_handles;
	p0.h = _initialise_monitor_handles;
	call	(p0)

	p0.l = ___setup_argv_and_call_main;
	p0.h = ___setup_argv_and_call_main; 
	call	(p0)

	p0.l = _exit;
	p0.h = _exit; 
	jump	(p0)		/* Should not return.  */

	.data
/*  Data returned by monitor SWI.  */
.global	__stack_base__
HeapBase:	.dd	0
HeapLimit:	.dd	0
__stack_base__:	.dd	0
StackLimit:	.dd	0
CommandLine:	.space	256,0	/*  Maximum length of 255 chars handled.  */
