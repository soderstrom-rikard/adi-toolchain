/* This file is tc-bfin.h and defines the Analog Devices Blackfin (FRIO) cpu.
 * Copyright (c) 2000-2001 by Lineo, Inc./Lineo Canada Corp. (www.lineo.com),
 * Copyright (c) 2001-2002 by Arcturus Networks Inc.(www.arcturusnetworks.com)
 * Ported for Blackfin Architecture by 
 *	      Akbar Hussain  <akbar.hussain@arcturusnetworks.com>,
 *            Faisal Akber  <fakber@arcturusnetworks.com>,
 *            Tony Kou <tony.ko@arcturusnetworks.com>
 */

#define TC_BFIN 1
#define TC_ADI_BFIN 1

#define TARGET_BYTES_BIG_ENDIAN 0

#define TARGET_ARCH		bfd_arch_bfin

/*
 * Define the target format macro here.   The value for this should be
 * "elf32-bfin", not "elf32-little-bfin".  Since the BFD source file 
 * elf32-bfin.c defines TARGET_LITTLE_NAME to be "elf32-little-bfin",
 * we must use this value, until this is corrected and BFD is rebuilt.
 */
#ifdef OBJ_ELF
#define TARGET_FORMAT		"elf32-bfin" 
// #define TARGET_FORMAT           "elf32-little-bfin"
#endif

#define LISTING_HEADER "BFIN GAS "

#define WORKING_DOT_WORD

extern void bfin_start_line_hook PARAMS ((void));
/* #define md_start_line_hook()    bfin_start_line_hook() */


/* 
 * Allow for [, ], etc...
 */
#define LEX_BR 3

/* The instruction is permitted to contain an = character.  */
#define TC_EQUAL_IN_INSN(C, PTR) 1

#define NOP_OPCODE 0x0000 

#define LOCAL_LABELS_FB 1

#define DOUBLESLASH_LINE_COMMENTS

#define tc_fix_adjustable(FIX) bfin_fix_adjustable (FIX)
extern bfd_boolean bfin_fix_adjustable PARAMS ((struct fix *));
/* end of tc-bfin.h */
