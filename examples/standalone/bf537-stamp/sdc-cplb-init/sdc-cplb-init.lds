MEMORY
{
	MEM_L1_CODE    : ORIGIN = 0xFFA00000, LENGTH = 0xC000
	MEM_L1_SCRATCH : ORIGIN = 0xFFB00000, LENGTH = 0x1000
	MEM_L1_DATA_B  : ORIGIN = 0xFF900000, LENGTH = 0x8000
	MEM_L1_DATA_A  : ORIGIN = 0xFF800000, LENGTH = 0x8000

	MEM_SDRAM      : ORIGIN = 0x00000000, LENGTH = 64 * 1024 * 1024
}

SECTIONS
{
	.sdram.text :
	{
		external-memory.o(.text)
	} >MEM_SDRAM =0
	.sdram.data :
	{
		external-memory.o(.data .rodata .rodata.*)
	} >MEM_SDRAM =0
	/* Just lump it into the standard .bss so the default crt
	 * will initialize the region for us.
	.sdram.bss :
	{
		external-memory.o(.bss)
	} >MEM_SDRAM =0
	*/

	.text :
	{
		*(.text)
	} >MEM_L1_CODE =0
	.init :
	{
		KEEP (*(.init))
	} >MEM_L1_CODE =0
	.fini :
	{
		KEEP (*(.fini))
	} >MEM_L1_CODE =0

	PROVIDE (__etext = .);
	PROVIDE (_etext = .);
	PROVIDE (etext = .);
	.rodata   : { *(.rodata .rodata.*) } >MEM_L1_DATA_A
	.eh_frame : ONLY_IF_RO { KEEP (*(.eh_frame)) } >MEM_L1_DATA_A

	/* Adjust the address for the data segment.  We want to adjust up to
		 the same address within the page on the next page up.  */
	. = ALIGN(0x1000) + (. & (0x1000 - 1));
	/* Exception handling  */
	.eh_frame       : ONLY_IF_RW { KEEP (*(.eh_frame)) } >MEM_L1_DATA_A
	.gcc_except_table   : ONLY_IF_RW { *(.gcc_except_table .gcc_except_table.*) } >MEM_L1_DATA_A
	.ctors          :
	{
		/* gcc uses crtbegin.o to find the start of
		   the constructors, so we make sure it is
		   first.  Because this is a wildcard, it
		   doesn't matter if the user does not
		   actually link against crtbegin.o; the
		   linker won't look for a file to match a
		   wildcard.  The wildcard also means that it
		   doesn't matter which directory crtbegin.o
		   is in.  */
		KEEP (*crtbegin*.o(.ctors))
		/* We don't want to include the .ctor section from
		   the crtend.o file until after the sorted ctors.
		   The .ctor section from the crtend file contains the
		   end of ctors marker and it must be last */
		KEEP (*(EXCLUDE_FILE (*crtend*.o ) .ctors))
		KEEP (*(SORT(.ctors.*)))
		KEEP (*(.ctors))
	} >MEM_L1_DATA_A
	.dtors          :
	{
		KEEP (*crtbegin*.o(.dtors))
		KEEP (*(EXCLUDE_FILE (*crtend*.o ) .dtors))
		KEEP (*(SORT(.dtors.*)))
		KEEP (*(.dtors))
	} >MEM_L1_DATA_A
	.jcr : { KEEP (*(.jcr)) } >MEM_L1_DATA_A
	.data :
	{
		*(.data)
		SORT(CONSTRUCTORS)
	} >MEM_L1_DATA_A
	__edata = .; PROVIDE (_edata = .);
	.bss :
	{
		__bss_start = .;
		*(.bss)
		*(COMMON)
		/* Align here to ensure that the .bss section occupies space up to
		   _end.  Align after .bss to ensure correct alignment even if the
		   .bss section disappears because there are no input sections.
		   FIXME: Why do we need it? When there is no .bss section, we don't
		   pad the .data section.  */
		. = ALIGN(. != 0 ? 32 / 8 : 1);
		__bss_end = .;
	} >MEM_L1_DATA_A
	. = ALIGN(32 / 8);
	__end = .; PROVIDE (_end = .);

	/* The default initcode will use this symbol to initialize the stack */
	__stack_end = ORIGIN(MEM_L1_SCRATCH) + LENGTH(MEM_L1_SCRATCH);

	/DISCARD/ : { *(.note.GNU-stack) }
}
