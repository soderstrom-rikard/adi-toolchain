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
	/* Need to set up standard file handles */
	/*  Parse string at r1 */

	p0.l = _main;
	p0.h = _main; 
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
