/* tc-bfin.c -- Assembler for the Analog Devices bfin.
 * Copyright (c) 2000-2001 by Lineo, Inc./Lineo Canada Corp. (www.lineo.com),
 * Copyright (c) 2001-2002 by Arcturus Networks Inc.(www.arcturusnetworks.com)
 * Ported for Blackfin Architecture by 
 *	      Akbar Hussain  <akbar.hussain@arcturusnetworks.com>,
 *	      Faisal Akber <fakber@arcturusnetworks.com>,
 *            Tony Kou <tony.ko@arcturusnetworks.com>
 * Copyright (c) 2003, Metrowerks
 *
 *  04/2004 Martin Strubel <hackfin@section5.ch>
 *          Attached auxiliary section (see 'Blackfin Opcode Generation')
 *          and made minor changes for the 'new' parser.
 *  05/2004 Merged CVS code from ADI (LG/RRAP)
 *
 * TODO: source code cleanups. There are several insane
 *       ways of indenting...
 */

#include "as.h"
#include "struc-symbol.h"
#include "obj-elf.h"
#include "bfin-defs.h"
#include "obstack.h"

#include <ctype.h> // isupper(), tolower()


extern int yyparse(void);
struct yy_buffer_state;
typedef struct yy_buffer_state *YY_BUFFER_STATE;
extern YY_BUFFER_STATE yy_scan_string ( const char *yy_str );
extern void yy_delete_buffer ( YY_BUFFER_STATE b );  
static void parse(char *line);
void assembler_parser_init(void);
static void s_bss PARAMS ((int));

/* Global variables. */
struct bfin_insn *insn;
extern struct obstack mempool;
FILE *errorf;

/*
 * Registers list.
 */
struct bfin_reg_entry
{
  const char *name;
  int number;
};

static const struct bfin_reg_entry bfin_reg_info[] = 
{
  { "R0.L", REG_RL0 },
  { "R1.L", REG_RL1 },
  { "R2.L", REG_RL2 },
  { "R3.L", REG_RL3 },
  { "R4.L", REG_RL4 },
  { "R5.L", REG_RL5 },
  { "R6.L", REG_RL6 },
  { "R7.L", REG_RL7 },
  { "R0.H", REG_RH0 },
  { "R1.H", REG_RH1 },
  { "R2.H", REG_RH2 },
  { "R3.H", REG_RH3 },
  { "R4.H", REG_RH4 },
  { "R5.H", REG_RH5 },
  { "R6.H", REG_RH6 },
  { "R7.H", REG_RH7 },
  { "R0", REG_R0 },
  { "R1", REG_R1 },
  { "R2", REG_R2 },
  { "R3", REG_R3 },
  { "R4", REG_R4 },
  { "R5", REG_R5 },
  { "R6", REG_R6 },
  { "R7", REG_R7 },
  { "P0", REG_P0 },
  { "P1", REG_P1 },
  { "P2", REG_P2 },
  { "P3", REG_P3 },
  { "P4", REG_P4 },
  { "P5", REG_P5 },
  { "SP", REG_SP },
  { "FP", REG_FP },
  { "A0x", REG_A0x },
  { "A1x", REG_A1x },
  { "A0w", REG_A0w },
  { "A1w", REG_A1w },
  { "A0", REG_A0 },
  { "A1", REG_A1 },
  { "I0", REG_I0 },
  { "I1", REG_I1 },
  { "I2", REG_I2 },
  { "I3", REG_I3 },
  { "M0", REG_M0 },
  { "M1", REG_M1 },
  { "M2", REG_M2 },
  { "M3", REG_M3 },
  { "B0", REG_B0 },
  { "B1", REG_B1 },
  { "B2", REG_B2 },
  { "B3", REG_B3 },
  { "L0", REG_L0 },
  { "L1", REG_L1 },
  { "L2", REG_L2 },
  { "L3", REG_L3 },
  { "AZ", S_AZ },
  { "AN", S_AN },
  { "AC0", S_AC0 },
  { "AC1", S_AC1 },
  { "AV0", S_AV0 },
  { "AV0S", S_AV0S },
  { "AV1", S_AV1 },
  { "AV1S", S_AV1S },
  { "AQ", S_AQ },
  { "VS", S_VS },
  { "sftreset", REG_sftreset },
  { "omode", REG_omode },
  { "excause", REG_excause },
  { "emucause", REG_emucause },
  { "idle_req", REG_idle_req },
  { "hwerrcause", REG_hwerrcause },
  { "CC", REG_CC },
  { "LC0", REG_LC0 },
  { "LC1", REG_LC1 },
  { "ASTAT", REG_ASTAT },
  { "RETS", REG_RETS },
  { "LT0", REG_LT0 },
  { "LB0", REG_LB0 },
  { "LT1", REG_LT1 },
  { "LB1", REG_LB1 },
  { "CYCLES", REG_CYCLES },
  { "CYCLES2", REG_CYCLES2 },
  { "USP", REG_USP },
  { "SEQSTAT", REG_SEQSTAT },
  { "SYSCFG", REG_SYSCFG },
  { "RETI", REG_RETI },
  { "RETX", REG_RETX },
  { "RETN", REG_RETN },
  { "RETE", REG_RETE },
  { 0, 0 }  // Terminator
};


/* 
 * Declare pseudo operands table. 
 * ------------------------------
 * The table below lists the assebler directives allowed by NISA,
 * which code handles the directive, and a short description of the 
 * directive.  Even though some directives are handled by GAS, we may 
 * need to handle it, to handle its "cousin" directives.  Note that not 
 * all directives are listed.  See obj-elf.c and read.c for more details.
 *
 * PSEUDO-OP    GAS or TC    REMARKS
 * =========    =========    ===============================================
 * .align          GAS       
 * .ascii          GAS       ASCII string data.
 * .byte           GAS       8-bit data.  
 * .byte2          TC        16-bit data.  Force GAS to handle.
 * .byte4          TC        32-bit data.  Force GAS to handle.
 * .code           GAS       Denotes a section.  Default value: $code
 *                           This is the equivalent of .text, and thus we 
 *                           should let GAS handle this, in obj-elf.c.  We 
 *                           must map .code to .text, in the header file,
 *                           within the ELF_TC_SPECIAL_SECTION macro.  Also
 *                           need to map .code to .text in md_pseudo_table,
 *                           by having it call obj_elf_section(int xxx).
 * .data           GAS       GAS handles this, but it should denote a 
 *                           section, not just data.  Default value: $data
 *                           Let GAS handle this, in obj-elf.c, so that 
 *                           behaviour is proper for this section id.
 * .db             TC        8-bit data.  Force GAS to handle.
 * .dd             TC        32-bit data.  Force GAS to handle.
 * .dw             TC        16-bit data.  Force GAS to handle.
 * .file           GAS       Source filename of compiled program.
 * .global         GAS       
 * .p              TC        ??? *** Ignore for now.  ***
 * .pdata          TC        ??? *** Ignore for now.  ***
 * .section        GAS       GAS handles this, but we also have to take care
 *                           of .code and .data special cases.
 * .space          GAS       GAS handles this by placing X number of bytes,
 *                           where X is its parameter.  We should let GAS
 *                           handle this directive.
 *                           This is supposed to be the equivalent of .byte.
 * .type           GAS       Defines type of label?
 * .var            TC        Not sure what the purpose of this is for! 
 *                           ??? *** Ignore for now.  ***
 *
 */
const pseudo_typeS md_pseudo_table[] = { 
  {"byte2", cons, 2},
  {"byte4", cons, 4},
  {"code", obj_elf_section, 0},
/*  {"data", obj_elf_section, 0}, */
  {"db", cons, 1},
  {"dd", cons, 4},
  {"dw", cons, 2},
  {"p", s_ignore, 0},
  {"pdata", s_ignore, 0},
  {"var", s_ignore, 0},
  {"bss", s_bss, 0},
  {0, 0, 0}
};

static void s_bss (int ignore ATTRIBUTE_UNUSED)
{
  register int temp;
 
  temp = get_absolute_expression ();
  subseg_set (bss_section, (subsegT) temp);
  demand_empty_rest_of_line ();
}                


/* Characters that are used to denote comments and line separators. */
const char comment_chars[]        = "";
const char line_comment_chars[]   = "#";
const char line_separator_chars[] = ";";

/* Chars that can be used to separate mant from exp in floating point nums */
const char EXP_CHARS[] = "eE";

/* Chars that mean this number is a floating point constant 
   As in 0f12.456 or  0d1.2345e12 
*/
const char FLT_CHARS[] = "fFdDxX";

/* Define bfin specific command-line options (there are none). */
const char * md_shortopts = ""; 

struct option md_longopts[] = { 
  {NULL, no_argument, NULL, 0} 
}; 
size_t md_longopts_size = sizeof(md_longopts);

/* List out all options. */
int md_parse_option (int c, char * arg)
{
  int i;
  for (i = 0; i < c; i++)
    {
      printf ("%c\n", arg[i]);
    }
  return 0;
}

void md_show_usage (FILE * stream ATTRIBUTE_UNUSED)
{
}


/* 
 * Use these definitions if and only if .word needs to be handled,
 * in different manners.  That also means that WORKING_DOT_WORD 
 * cannot be defined in the tc-bfin.h header file.
 */
/*  const int md_reloc_size = 0; */
/*  int md_long_jump_size = 0; */
/*  int md_short_jump_size = 0; */


/* 
 * Perform machine-specific initializations that may be required to 
 * be done. 
 */
void 
md_begin () 
{
  /* create any necessary hash tables here  */
  char buf[100];
  struct bfin_reg_entry *walk;
  register unsigned int j;

  /* Set the default machine type. */
  if (!bfd_set_arch_mach (stdoutput, bfd_arch_bfin, 0))
    as_warn("Could not set architecture and machine.");

  /* 
   * Ensure that lines can begin with '(', for multiple register stack pops.
   * and other such operations.
   *
   * It is better to define a macro called LEX_PAREN, and modify read.c,
   * but for now this will do.
   *

	<strubi> Notes:
	gas would try to generate a label, since it thinks, it's a name:
	(R7:4) = [SP++];

	   -> label: '(R7'   parse: '4) = [SP++]'

	So you always needed to spell:

	   ( R7 : 4) = [SP++];

	which is a pain in the so called. See gas/read.c for better fix.

	In binutils-2.9, the next command was commented out. In 2.14,
	it is put back, because starting LPARENs are evaluated
	differently once more...

   
   */
	  lex_type['('] = 3;


  /*
   * Need to add all of the registers to the symbol table, so that
   * GAS knows that these are registers, and not just any other symbol.
   *
   * May also need symbol like "REG=" added in the symbol table
   *
   * May also need to check for instruction mnemonics.
   */

	walk = (struct bfin_reg_entry *)bfin_reg_info;

	while (walk->name) {
		symbol_table_insert(symbol_new(walk->name,
					reg_section, walk->number,
					&zero_address_frag));

		for (j = 0; walk->name[j]; j++)
		{
			buf[j] = isupper(walk->name[j]) ? 
					 tolower(walk->name[j]) : 
					 walk->name[j];
		}
		buf[j]='\0';

		symbol_table_insert(symbol_new(buf, reg_section,
							walk->number, 
							&zero_address_frag));
		buf[j]='='; buf[j+1]='\0';
		symbol_table_insert(symbol_new(buf, reg_section,
							walk->number, 
							&zero_address_frag));
		walk++;
	}

	/*
	 * Who the heck started off with that horrible indenting ?
	 *
  for (i = 0; i < REG_LASTREG; i++)
    {
      symbol_table_insert(symbol_new(bfin_reg_info[i].name, reg_section, 
				     bfin_reg_info[i].number, 
				     &zero_address_frag));

      for (j = 0; bfin_reg_info[i].name[j]; j++)
	{
	  buf[j] = isupper(bfin_reg_info[i].name[j]) ? 
	    tolower(bfin_reg_info[i].name[j]) : 
	    bfin_reg_info[i].name[j];
	}
      buf[j]='\0';

      symbol_table_insert(symbol_new(buf, reg_section,
				     bfin_reg_info[i].number, 
				     &zero_address_frag));
      buf[j]='='; buf[j+1]='\0';
      symbol_table_insert(symbol_new(buf, reg_section,
				     bfin_reg_info[i].number, 
				     &zero_address_frag));
    }
	*/

#ifdef OBJ_ELF
  record_alignment (text_section, 2);
  record_alignment (data_section, 2);
  record_alignment (bss_section, 2);
#endif

  assembler_parser_init();
#ifdef DEBUG
  extern int debug_codeselection;
  debug_codeselection = 1;
#endif /* TEST : for use in notethat( char *format, ...) */

}

/*
 * Perform the main parsing, and assembly of the input here.  Also, 
 * call the required routines for alignment and fixups here.
 * This is called for every line that contains real assembly code.
 */

void 
md_assemble (char *line)
{
  char *toP = 0;
  extern char *current_inputline; 
  int size, insn_size;
  struct bfin_insn *tmp_insn;

  //char *c;
  
  current_inputline = line;
  /* Parse line here */
  parse(line); 

  for (insn_size = 0, tmp_insn = insn; tmp_insn; tmp_insn = tmp_insn->next)
    if (! tmp_insn->reloc || ! tmp_insn->exp->symbol)
      insn_size += 2;

  if (insn_size)
    toP = frag_more (insn_size);

  /* 
   * Output the opcode. 
   * Create frag, then do fixup here.  
   * Let GAS do any relaxations.
   */
#ifdef DEBUG
  printf("INS:"); // XXX DEBUG HACK
#endif
  while (insn)
    {
      if (insn->reloc && insn->exp->symbol) 
	{
	  char *prev_toP = toP - 2;
	  switch (insn->reloc)
	    {
	    case BFD_RELOC_24_PCREL_JUMP_L:
	    case BFD_RELOC_24_PCREL:
	    case BFD_RELOC_16_LOW:
	    case BFD_RELOC_16_HIGH:
	      size = 4;
	      break;
	    default:
	      size = 2;
	    }

	  /* Following if condition checks for the arithmetic relocations. 
	     If the case then it doesn't required to generate the code.
	     It has been assumed that, their ID will be contiguous*/
	  if ((BFD_ARELOC_PUSH <= insn->reloc
	       && BFD_ARELOC_COMP >= insn->reloc)
	      || insn->reloc == BFD_RELOC_16_IMM)
	    {
	      //fprintf(stderr, "generating reloc for %x at %x\n", insn->reloc, toP);
	      size = 2;
	    }
	  if (insn->reloc == BFD_ARELOC_CONST || insn->reloc == BFD_ARELOC_PUSH)
	    size = 4; // the constant in an expression can be large

	  fix_new (frag_now, (prev_toP - frag_now->fr_literal),
		   size, insn->exp->symbol, insn->exp->value, insn->pcrel, insn->reloc);
	}
      else
	{
	  md_number_to_chars (toP, insn->value, 2);
	  toP += 2;
	}
    
#ifdef DEBUG
      printf(" reloc :");
#endif

      // HACK XXX
#ifdef DEBUG
      printf(" %02x%02x", ((unsigned char *) &insn->value)[0],
	     ((unsigned char *) &insn->value)[1] );
#endif
      insn = insn->next;

#ifdef DEBUG
      printf("\n"); // DEBUG HACK
#endif
    }
  /* call frag_var for special purpose relaxation, gcc can handle this  */
}

/* 
 * Parse one line of instructions, and generate opcode for it. 
 * To parse the line, YACC and LEX are used, because the instruction set
 * syntax doesn't confirm to the AT&T assembly syntax.
 * 
 * To call a YACC & LEX generated parser, we must provide the input via
 * a FILE stream, otherwise stdin is used by default.  Below the input
 * to the function will be put into a temporary file, then the generated
 * parser uses the temporary file for parsing.
 */

void
parse (char *line)
{
  YY_BUFFER_STATE buffstate; 

  buffstate = yy_scan_string(line);

  /* our lex requires setting the start state to keyword
     every line as the first word may be a keyword.
     Fixes a bug where we could not have keywords as labels
  */
  set_start_state();

     /* Call yyparse here.  */
     if (yyparse() == 0)
     {
     as_bad("Parse failed.");
	  insn = 0;
     }

  yy_delete_buffer(buffstate);
}

/*
 * This will be called at the end of the assembly process, for 
 * clean-up purposes. Now we don't need this. 
 */
/* void md_cleanup() */


/* We need to handle various expressions properly.
 * Such as, [SP--] = 34, concerned by md_assemble()
 */
void 
md_operand (expressionS *expressionP)
{
  if (*input_line_pointer == '[')
    {
      as_tsktsk("We found a '['!");
      input_line_pointer ++;
      expression (expressionP);
    }
}

/* Handle undefined symbols. */
symbolS *
md_undefined_symbol (char* name ATTRIBUTE_UNUSED)
{
  /*  symbolS *newsym, *symbolP;
  symbolP = symbol_find(name);
  if (symbolP == NULL)
    {
      if (strcmp(name,"X"))
	{
	  newsym = symbol_new(name, reg_section, (valueT) 0, &zero_address_frag);
	}
    }
  else
    {
      newsym = NULL;
    }

  if (!newsym)
  {                     ** */
      return (symbolS *) 0;
      /*    }
  else
    {
      return newsym;
      } * */
}

/* Write a value out to the object file, using the appropriate endianness.  */
void
md_number_to_chars (char *buf, valueT val, int n)
{
	number_to_chars_littleendian (buf, val, n);
}


int md_estimate_size_before_relax (fragS *fragP ATTRIBUTE_UNUSED, segT segment ATTRIBUTE_UNUSED)
{
	return 0;
}

/* void md_convert_frag (bfd * abfd, segT sec, fragS * fragP)  */

/*
int 
md_apply_fix3 (fixP, valp)
     fixS *fixP;
     valueT *valp; 
	 */
	
#if 0
void 
md_apply_fix3 (fixS *fixP, valueT *valP, segT seg)
{
  char *buf = fixP->fx_where + fixP->fx_frag->fr_literal;

  int lowbyte = target_big_endian ? 1 : 0;
  int highbyte = target_big_endian ? 0 : 1; 
  long val = *valP;
  int shift;


  /*
	printf("called md_apply_fix3(val = %lx, %lx)\n", val, fixP->fx_addsy);
	if (fixP->fx_addsy) 
		printf(" used in reloc %d\n", fixP->fx_addsy->sy_used_in_reloc);
  */

  shift = 0;
  switch (fixP->fx_r_type)
    {
     case BFD_RELOC_10_PCREL:
	if (! val) 
	{   fixP->fx_addnumber = 0; break;	}
	fixP->fx_addnumber = 1;
	val /=2; val++;  /*  Add into the length of "BRF/T label"   --- Tony */
	shift = 1;
        /* as_tsktsk ("Value of val = %x \n", val); */
	if (val < -0x200 || val >= 0x1ff)
	  as_bad_where (fixP->fx_file, fixP->fx_line, "pcrel too far BFD_RELOC_10");
	buf[lowbyte] = val & 0xff;
	buf[highbyte] |= (val >> 8) & 0x3;
	break;

     case BFD_RELOC_12_PCREL:

	/*
	 * If fixP->fx_offset is non-zero, it's a zero offset pc-relative
	 * relocation. We need to check it in other pc-relative relocations
	 * also - amit
	 */

	if (! val && !fixP->fx_offset) 
	{   fixP->fx_addnumber = 0; break;      }
	fixP->fx_addnumber = 1;
	val /= 2; val++; /*  Add into the length of "jump label"   --- Tony */ 
	shift = 1;
	if (val < -0x800 || val >= 0x7ff)
	  as_bad_where (fixP->fx_file, fixP->fx_line, "pcrel too far BFD_RELOC_12");
	buf[lowbyte] = val & 0xff;
	buf[highbyte] |= (val >> 8) & 0xf;
	break;

     case BFD_RELOC_16_LOW:

/*      leave to linker to resolve this reloc
	if (val) fixP->fx_addnumber = 1;
	buf[lowbyte] = val & 0xff;
	buf[highbyte] = (val >> 8) & 0xff;
*/
	fixP->fx_addnumber = 0;

/* Note:to make sure value correct, clear any original resolved by bfin parser
        and leave to linker.
	buf[0] = buf[1] = 0;
	as_tsktsk("modified value = %x %x \n", buf[0], buf[1]);
*/
	break;

     case BFD_RELOC_16_HIGH:
/*	leave to linker to resolve this reloc
	if (val) fixP->fx_addnumber = 1;
	buf[lowbyte] = (val >> 16) & 0xff;
	buf[highbyte] = (val >> 24) & 0xff;
	buf[0] = buf[1] = 0;
*/
	fixP->fx_addnumber = 0;
	break;

     case BFD_RELOC_24_PCREL:
	if (! val) 
	{   fixP->fx_addnumber = 0; break;	}
	fixP->fx_addnumber = 1;
	val = (val + 4)/2; /*  Add into the length of "call/ljump label"   --- Tony */ 
	shift = 1;
	if (val < -0x800000 || val >= 0x7fffff)
	  as_bad_where (fixP->fx_file, fixP->fx_line, "pcrel too far BFD_RELOC_24");
	buf[0] = val >> 16;
	buf[2] = val >> 0;
	buf[3] = val >> 8;
	break;

     case BFD_RELOC_4_PCREL:
	if (! val) 
	{   fixP->fx_addnumber = 0; break;	}
	fixP->fx_addnumber = 1;
	val /=2; val++; /* Add into opcode length   ---Tony */
	shift = 1;
	if (val < -0x8 || val >= 0x7)
	  as_bad_where (fixP->fx_file, fixP->fx_line, "pcrel too far BFD_RELOC_4");
	*buf = (*buf & 0xf0) | (val & 0xf);
	break;

     case BFD_RELOC_10_LPPCREL:
	if (! val) 
	{   fixP->fx_addnumber = 0; break;	}
	fixP->fx_addnumber = 1;
	val =(val+4)/2;
	shift = 1;
        if (val < -0x200 || val >= 0x1ff)
          as_bad_where (fixP->fx_file, fixP->fx_line, "pcrel too far BFD_RELOC_10_LPP");
        buf[lowbyte] = val & 0xff;
        buf[highbyte] |= (val >> 8) & 0x3;
        break;

     case BFD_RELOC_8:
	if (val < -0x80 || val >= 0x7f)
	  as_bad_where (fixP->fx_file, fixP->fx_line, "rel too far BFD_RELOC_8");
	*buf++ = val;
	break;

     case BFD_RELOC_32:
	break;
        if (! target_big_endian)
          {
            *buf++ = val >> 0;
            *buf++ = val >> 8;
            *buf++ = val >> 16;
            *buf++ = val >> 24;
          }
        else
          {
            *buf++ = val >> 24;
            *buf++ = val >> 16;
            *buf++ = val >> 8;
            *buf++ = val >> 0;
          }
        break;

     case BFD_RELOC_16:
        if (! target_big_endian)
          {
            *buf++ = val >> 0;
            *buf++ = val >> 8;
          }
        else
          {
            *buf++ = val >> 8;
            *buf++ = val >> 0;
          }
        break;

     default:
	abort ();
   }

  // XXX
  // <strubi>
  // This might be a dirty hack. I don't know if it's appropriate,
  // but once we have done the fixing, we don't want to have LD
  // relocating anymore on these entries. We mark them as 'done'
  // to not emit them to the relocation table.
  if (!fixP->fx_addsy) {
	  fixP->fx_done = TRUE;
  }


   if (shift != 0)
   {
     val = *valP;
     if ((val & ((1 << shift) - 1)) != 0)
	as_bad_where (fixP->fx_file, fixP->fx_line, "misaligned offset"); 
   }

}

#endif
void
md_apply_fix3 (fixP, valp, seg)
     fixS *fixP;
     valueT *valp;
     segT seg ATTRIBUTE_UNUSED;
{
  char *buf = fixP->fx_where + fixP->fx_frag->fr_literal;

  int lowbyte = 0; // bfin is little endian
  int highbyte = 1; // bfin is little endian
  long val = *valp;
  int shift;
  int not_yet_resolved = 0;

#if 0
  if (fixP->fx_r_type == BFD_RELOC_32)
     {
        as_tsktsk("value = %x addsy's value = %x\n", *valp, S_GET_VALUE (fixP->fx_addsy));
        if ( fixP->fx_addsy != NULL
      && OUTPUT_FLAVOR == bfd_target_elf_flavour)
        as_tsktsk("result is true!\n");
     }
#endif

  shift = 0;
  switch (fixP->fx_r_type)
    {
    case BFD_RELOC_10_PCREL:
        if (! val)
       	{   
	  /* val = 0 is special */
	  fixP->fx_addnumber = 0; 
	  break;      
	}
       fixP->fx_addnumber = 1;
       if (val < -1024 || val > 1022 )
         as_bad_where (fixP->fx_file, fixP->fx_line, "pcrel too far BFD_RELOC_10");

       val /= 2;	// 11 bit offset even numbered, so we remove right bit
       shift = 1;
       buf[lowbyte] = val & 0xff;
       buf[highbyte] |= (val >> 8) & 0x3;
        break;
     case BFD_RELOC_12_PCREL_JUMP :
     case BFD_RELOC_12_PCREL_JUMP_S :
     case BFD_RELOC_12_PCREL:

        /*
         * If fixP->fx_offset is non-zero, it's a zero offset pc-relative
         * relocation. We need to check it in other pc-relative relocations
         * also - amit
         */

        if (! val && !fixP->fx_offset) {
           fixP->fx_addnumber = 0;
           break;
        }
        if (val < -4096 || val > 4094)
          as_bad_where (fixP->fx_file, fixP->fx_line, "pcrel too far BFD_RELOC_12");
        fixP->fx_addnumber = 1;
        val /= 2;	// 13 bit offset even numbered, so we remove right bit
        shift = 1;
        buf[lowbyte] = val & 0xff;
        buf[highbyte] |= (val >> 8) & 0xf;
        break;

     case BFD_RELOC_16_LOW:

/*      leave to linker to resolve this reloc
        if (val) fixP->fx_addnumber = 1;
        buf[lowbyte] = val & 0xff;
        buf[highbyte] = (val >> 8) & 0xff;
*/
        fixP->fx_addnumber = 0;
        not_yet_resolved = 1; // absolute values not be resolved here

        break;

     case BFD_RELOC_16_HIGH:
/*      leave to linker to resolve this reloc
        if (val) fixP->fx_addnumber = 1;
	buf[lowbyte] = (val >> 16) & 0xff;
        buf[highbyte] = (val >> 24) & 0xff;
        buf[0] = buf[1] = 0;
*/
        fixP->fx_addnumber = 0;
        not_yet_resolved = 1; // absolute values not be resolved here
        break;
     case BFD_RELOC_24_PCREL_JUMP_L :
     case BFD_RELOC_24_PCREL_CALL_X:
     case BFD_RELOC_24_PCREL:
        if (! val) {
           fixP->fx_addnumber = 0;
           break;
        }
        fixP->fx_addnumber = 1;
        if (val < -16777216 || val > 16777214)
          as_bad_where (fixP->fx_file, fixP->fx_line, "pcrel too far BFD_RELOC_24");
        val /= 2; 		// 25 bit offset even numbered, so we remove right bit
        shift = 1;
	val++;			// 
        buf -= 2; // we want to go back and fix.
        buf[0] = val >> 16;
        buf[2] = val >> 0;
        buf[3] = val >> 8;
        break;
     case BFD_RELOC_5_PCREL: /* LSETUP (a, b) : "a" */
        if (! val) {
           fixP->fx_addnumber = 0;
           break;
        }
        fixP->fx_addnumber = 1;
	if (val < 4 || val > 30)
          as_bad_where (fixP->fx_file, fixP->fx_line, "pcrel too far BFD_RELOC_5");
        val /= 2;		// 5 bit unsigned even, so we remove right bit
        shift = 1;

        *buf = (*buf & 0xf0) | (val & 0xf);
        break;
     case BFD_RELOC_11_PCREL :  /* LSETUP (a, b) : "b" */
        if (! val) {
           fixP->fx_addnumber = 0;
           break;
        }
        fixP->fx_addnumber = 1;
	val += 2; 
        if (val < 4 || val > 2046)
          as_bad_where (fixP->fx_file, fixP->fx_line, "pcrel too far BFD_RELOC_11_PCREL");
        val /=2; 		// 11 bit unsigned even, so we remove right bit
        shift = 1;

        buf[lowbyte] = val & 0xff;
        buf[highbyte] |= (val >> 8) & 0x3;
        break;

     case BFD_RELOC_8:
        if (val < -0x80 || val >= 0x7f)
          as_bad_where (fixP->fx_file, fixP->fx_line, "rel too far BFD_RELOC_8");
        *buf++ = val;
        break;

     case BFD_RELOC_32:
            *buf++ = val >> 0;
            *buf++ = val >> 8;
            *buf++ = val >> 16;
            *buf++ = val >> 24;
            not_yet_resolved = 1; // absolute values not be resolved here
        break;
     case BFD_RELOC_16_IMM:
     case BFD_RELOC_16:
            *buf++ = val >> 0;
            *buf++ = val >> 8;
            not_yet_resolved = 1; // absolute values not be resolved here
        break;
                //added following line for arithmetic reloc check -Jyotik
     default: if((BFD_ARELOC_PUSH > fixP->fx_r_type) || (BFD_ARELOC_COMP < fixP->fx_r_type))
                      {
                fprintf(stderr, "Relocation %d not handled in gas."
                               " Contact support.\n", fixP->fx_r_type);
                        return;
//              abort ();
                      }
              not_yet_resolved = 1;
   }
  // XXX
  // <strubi>
  // This might be a dirty hack. I don't know if it's appropriate,
  // but once we have done the fixing, we don't want to have LD
  // relocating anymore on these entries. We mark them as 'done'
  // to not emit them to the relocation table.
   if (!fixP->fx_addsy && !not_yet_resolved)
   {
       fixP->fx_done = TRUE;
   }
   if (shift != 0)
   {
     val = *valp;
     if ((val & ((1 << shift) - 1)) != 0)
        as_bad_where (fixP->fx_file, fixP->fx_line, "misaligned offset");
   }

}



/* Round up a section size to the appropriate boundary. */
valueT
md_section_align (segment, size)
     segT segment;
     valueT size;
{
  int align = bfd_get_section_alignment (stdoutput, segment);

  return ((size + (1 << align) - 1) & (-1 << align));
}

/* define md_relax_frag OR TC_GENERIC_RELAX_TABLE  */

/* Convert an ASCII string to FP number. */
char *
md_atof (type ,litP , sizeP )
   char type ATTRIBUTE_UNUSED;
   char* litP ATTRIBUTE_UNUSED;
   int* sizeP ATTRIBUTE_UNUSED;
{
	as_tsktsk("Generally we don't need md_atof.\n");
}

/* Convert a machine dependent frag.  We never generate these.  */
void
md_convert_frag (bfd* abfd ATTRIBUTE_UNUSED,
	       asection * sec ATTRIBUTE_UNUSED,
	      fragS*  fragp ATTRIBUTE_UNUSED)
{
  abort ();
}

/* Translate internal representation of relocation info to BFD target format.  */
arelent *
tc_gen_reloc (asection *section ATTRIBUTE_UNUSED, fixS* fixp)
{
  arelent *reloc;
  
  // generate relocation for long section, eg .text.init -- STChen
#if 0	
  if (fixp->fx_addnumber) 
    {
	fixp->fx_addnumber = 0;
	return NULL;
    }
#endif

  
  reloc = (arelent *) xmalloc (sizeof (arelent));
  reloc->sym_ptr_ptr = (asymbol **) xmalloc (sizeof (asymbol *));
  *reloc->sym_ptr_ptr = symbol_get_bfdsym (fixp->fx_addsy);
  reloc->address = fixp->fx_frag->fr_address + fixp->fx_where;

  /*
  printf("gen reloc addr:%08lx type:%d sym:%s\n", 
		  reloc->address, fixp->fx_r_type, fixp->fx_addsy->bsym->name); 
  printf("   offset: %x\n", fixp->fx_offset);
  */

/*  if (fixp->fx_r_type == BFD_RELOC_16_LOW)
	reloc->address = fixp->fx_frag->fr_address;
 */

#if 0
  if (fixp->fx_pcrel == 0)
    reloc->addend = fixp->fx_offset;
  else
    reloc->addend = fixp->fx_offset = reloc->address;
#endif

  reloc->addend = fixp->fx_offset;
  
  reloc->howto = bfd_reloc_type_lookup (stdoutput, fixp->fx_r_type);

  if (reloc->howto == NULL)
    {
      as_bad_where (fixp->fx_file, fixp->fx_line,
                    "Can not represent relocation in this object file format");
      return NULL;
    }
  return reloc;
}              


/*
 * This should return the offset betweenthe address of a PC relative
 * fixup and the position from which the PC relative adjustment should
 * be made.  This should return the length of an instruction.
 *
 * The location from which a PC relative jump should be calculated,
 * given a PC relative reloc.  
*/
long 
md_pcrel_from (fixP)
     fixS *fixP;
{
  if (fixP->fx_addsy != (symbolS *) NULL
      && ! S_IS_DEFINED (fixP->fx_addsy))
    {
      /* The symbol is undefined.  Let the linker figure it out.  */
      return 0;
    }

  /* Return the address of the delay slot.  */
  return fixP->fx_frag->fr_address + fixP->fx_where ;
}

/*
 * Need to check the begining of each new line, to see if '[', ']' characters
 * are used.  This is used primarily for stack-pointers, and this notation 
 * isn't handled by the GNU Assembler.
 */
void
bfin_start_line_hook()
{
}

/*   sub routines   */
void assembler_parser_init () 
{
    errorf = stderr;
    obstack_init (&mempool);
}

/* Maybe we need these for relax the brf/brt pcrel_10 instruction  */
// const relax_typeS md_relax_table[] =
// {
//   {0, 0, 0, 0},                 /* State 0 => no more relaxation possible */
//   {4088, -4096, 0, 2},          /* State 1: conditional branch (brt/brf) */
//   {0x800000 - 8, -0x800000, 4, 0},      /* State 2: (brt/brf 6) & (ljump) */
// }; 
#define tc_unrecognized_line {		\
   as_tsktsk("Now an unrecognized line found.\n"); }


/* 
 * Special extra functions that help bfin-parse.y perform its job.
 *
 * YYY Code merge from ADI cvs
 */

#include <stdio.h>
#include <assert.h>
#include <obstack.h>
#include <bfd.h>
#include "bfin-defs.h"

struct obstack mempool;

INSTR_T conscode(INSTR_T head, INSTR_T tail) 
{
	if (!head)
		return tail;
	head->next = tail;
	return head;
}

INSTR_T conctcode(INSTR_T head, INSTR_T tail)
{
	INSTR_T temp = (head);
	if (!head)
		return tail;
	while (temp->next)
		temp = temp->next;
	temp->next = tail;
	  
	return head;
}

INSTR_T notereloc(INSTR_T code, ExprNode *symbol, int reloc, int pcrel)
{
	/* assert that the symbol is not an operator */
	assert(symbol->type == ExprNodeReloc);

	return notereloc1(code, symbol->value.s_value, reloc, pcrel);

}

INSTR_T notereloc1(INSTR_T code, const char *symbol, int reloc, int pcrel)
{
	code->reloc = reloc;
	code->exp = mkexpr(0, symbol_find_or_make(symbol));
	code->pcrel = pcrel;
	return code;
}

INSTR_T notereloc2(INSTR_T code,
		const char *symbol, int reloc, int value, int pcrel)
{
	code->reloc = reloc;
	code->exp = mkexpr(value, symbol_find_or_make(symbol));
	code->pcrel = pcrel;
	return code;
}

INSTR_T gencode(unsigned long x)
{
	INSTR_T cell = (INSTR_T) obstack_alloc(&mempool, sizeof(struct bfin_insn));
	memset(cell, 0, sizeof (struct bfin_insn));
	cell->value = (x); 
	return cell;
}

int  reloc;

int ninsns;

int count_insns;

static void *allocate(int n)
{
  return (void *)obstack_alloc (&mempool, n);
}

ExprNode *ExprNodeCreate(ExprNodeType type, ExprNodeValue value, 
		ExprNode *LeftChild, ExprNode *RightChild)
{


	ExprNode *node = (ExprNode*)allocate(sizeof(ExprNode));
	node->type = type;
	node->value = value;
	node->LeftChild = LeftChild;
	node->RightChild = RightChild;
	 return node;
}

static  const char *con=".__constant";
static  const char *op = ".__operator";
static INSTR_T ExprNodeGenRelocR(ExprNode *head);
INSTR_T ExprNodeGenReloc(ExprNode *head, int parent_reloc)
{
  /* top level reloction expression generator VDSP style
   * if the relocation is just by itself, generate one item
   * else generate this convoluted expression
   */
  INSTR_T note = NULL_CODE;
  INSTR_T note1 = NULL_CODE;
  int pcrel = 1; /* is the parent reloc pcrelative?
                 This calculation here and HOWTO should match
                 */
  
  if(parent_reloc)
  {
    //If it's 32 bit quantity then extra 16bit code needed to be add
    int value = 0;

    if(head->type == ExprNodeConstant){
      /* if note1 is not null code, we have to generate a right aligned
       * value for the constant. Otherwise the reloc is a part of the
       * basic command and the yacc file generates this
       */
       value = head->value.i_value;
    }
    switch(parent_reloc)
    {
      // some reloctions will need to allocate extra words
      case BFD_RELOC_16_IMM:
      case BFD_RELOC_16_LOW :
      case BFD_RELOC_16_HIGH :
        note1 = CONSCODE(GENCODE(value), NULL_CODE);
	pcrel = 0; // only these are not pc relative
        break;
      case BFD_RELOC_24_PCREL :
      case BFD_RELOC_24_PCREL_JUMP_L :
      case BFD_RELOC_24_PCREL_CALL_X :  
//      case BFD_RELOC_11_PCREL : // bug fix : the high part also has some opcode
	/* these offsets are even numbered, mostly pcrel */
        note1 = CONSCODE(GENCODE(value>>1), NULL_CODE);
        break;
      default :
	note1 = NULL_CODE;
    }
  }
  if(head->type == ExprNodeConstant){
     // this has been handled.
     note = note1;
  }
  else if(head->type == ExprNodeReloc){
    note =  NOTERELOC1(pcrel, parent_reloc, head->value.s_value, GENCODE(0x0));
    if(note1 != NULL_CODE)
      note =  CONSCODE(note1, note);
  }
  else{
    /* call the recursive function */
    note = NOTERELOC1(pcrel, parent_reloc, op, GENCODE(0x0));
    if(note1 != NULL_CODE)
      note =  CONSCODE(note1, note);
    note =  conctcode(ExprNodeGenRelocR(head), note);
  }
  return note;
}

static INSTR_T ExprNodeGenRelocR(ExprNode *head)
{
  
  INSTR_T note = 0;
  INSTR_T note1 = 0;

  switch(head->type)
  {
  case ExprNodeConstant : 
    note =  CONSCODE(NOTERELOC2(0, BFD_ARELOC_CONST, con, head->value.i_value, GENCODE(0x0)), 
                     NULL_CODE);
    break;
  case ExprNodeReloc :  
    note = CONSCODE(NOTERELOC(0, BFD_ARELOC_PUSH, head, GENCODE(0x0)), 
                    NULL_CODE); 
    break;    
  case ExprNodeBinop :   
    note1 = conctcode(ExprNodeGenRelocR(head->LeftChild),
                          ExprNodeGenRelocR (head->RightChild));     
    switch(head->value.op_value)
    {
      case  ExprOpTypeAdd  :  
        note = conctcode(note1, 
                  CONSCODE(NOTERELOC1(0, BFD_ARELOC_ADD, op, GENCODE(0x0)), 
                           NULL_CODE));
        break;
      case  ExprOpTypeSub   :  
        note = conctcode(note1, 
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_SUB, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeMult   :  
         note = conctcode(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_MULT, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeDiv  :   
					note = conctcode(note1,  
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_DIV, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeMod  :   
					note = conctcode(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_MOD, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeLsft  :   
					note = conctcode(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_LSHIFT, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeRsft  :   
					note = conctcode(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_RSHIFT, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeBAND  :   
					note = conctcode(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_AND, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeBOR  :   
					note = conctcode(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_OR, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeBXOR  :    
					note = conctcode(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_XOR, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeLAND  :     
					note = conctcode(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_LAND, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeLOR  :   
					note = conctcode(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_LOR, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      default      : fprintf(stderr, 
                  "%s:%d:Unkonwn operator found for arithmetic"
                    " relocation", __FILE__, __LINE__);


   }
   break;
  case ExprNodeUnop :
    note1 = CONSCODE(ExprNodeGenRelocR(head->LeftChild),
                          NULL_CODE);
    switch(head->value.op_value)
    {
      case  ExprOpTypeNEG  :   
					note = conctcode(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_NEG, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeCOMP  :    
					note = conctcode(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_COMP, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      default      : fprintf(stderr, 
                  "%s:%d:Unkonwn operator found for arithmetic"
                    " relocation", __FILE__, __LINE__);


   }
   break;
    default : fprintf(stderr, "%s:%d:Unknown node expression found during "
            "arithmetic relocation generation", __FILE__, __LINE__);
  }
  return note;
}


////////////////////////////////////////////////////////////////////////////

/* Blackfin opcode generation
 *
 * 03/2004 (c) Martin Strubel <hackfin@section5.ch>
 *
 * These functions might look inefficient from the hardware programmer's
 * point of view, but they make generating the Blackfin opcodes
 * much easier...
 *
 * These functions are called by the generated parser (from bfin-parse.y),
 * the register type classification happens in bfin-lex.l
 *
 */

#include "bfin-aux.h"
#include "../opcodes/bfin-opcodes.h"

#define INIT(t)  t c_code; c_code.opcode = init_##t;

#define _BF c_code.bits

#define ASSIGN(x) _BF.x = x
#define ASSIGN_R(x) _BF.x = x ? (x->regno & CODE_MASK) : 0

#define HI(x) ((x >> 16) & 0xffff)
#define LO(x) ((x      ) & 0xffff)

// See bfin-lex.l
#define GROUP(x) ((x->regno & CLASS_MASK) >> 4)

#define GEN_OPCODE32()  \
	CONSCODE(            GENCODE(HI(c_code.opcode)), \
				CONSCODE(GENCODE(LO(c_code.opcode)), NULL_CODE) ) 

#define GEN_OPCODE16()  \
	CONSCODE(GENCODE(c_code.opcode), NULL_CODE)

////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////
//  32 BIT INSTRUCTIONS
// {

////////////////////////////////////////////////////////////////////////////
// DSP32 instruction generation

INSTR_T
gen_dsp32mac(int op1, int MM, int mmod, int w1, int P,
             int h01, int h11, int h00, int h10,
			 int op0, REG_T dst, REG_T src0, REG_T src1, int w0)
{
	INIT(DSP32Mac);

	ASSIGN(op0);     ASSIGN(op1);
	ASSIGN(MM);      ASSIGN(mmod);
	ASSIGN(w0);      ASSIGN(w1);
	ASSIGN(h01);     ASSIGN(h11);     ASSIGN(h00);     ASSIGN(h10);
	ASSIGN(P);      
	
	// If we have full reg assignments, mask out LSB to encode 
	// single or simultaneous even/odd register moves
	if (P) {
		dst->regno &= 0x06;
	}

	ASSIGN_R(dst);
	ASSIGN_R(src0);  ASSIGN_R(src1);

	return GEN_OPCODE32();
}

INSTR_T
gen_dsp32mult(int op1, int MM, int mmod, int w1, int P,
              int h01, int h11, int h00, int h10,
			  int op0, REG_T dst, REG_T src0, REG_T src1, int w0)
{
	INIT(DSP32Mult);

	ASSIGN(op0);     ASSIGN(op1);
	ASSIGN(MM);      ASSIGN(mmod);
	ASSIGN(w0);      ASSIGN(w1);
	ASSIGN(h01);     ASSIGN(h11);     ASSIGN(h00);     ASSIGN(h10);
	ASSIGN(P);      

	// see above
	if (P) {
		dst->regno &= 0x06;
	}

	ASSIGN_R(dst);
	ASSIGN_R(src0);  ASSIGN_R(src1);

	return GEN_OPCODE32();
}
	
INSTR_T
gen_dsp32alu(int HL, int aopcde, int aop, int s, int x,
             REG_T dst0, REG_T dst1, REG_T src0, REG_T src1)
{
	INIT(DSP32Alu);

	ASSIGN(HL);
	ASSIGN(aopcde);
	ASSIGN(aop);
	ASSIGN(s);           ASSIGN(x);
	ASSIGN_R(dst0);      ASSIGN_R(dst1);
	ASSIGN_R(src0);      ASSIGN_R(src1);

	return GEN_OPCODE32();
}

INSTR_T
gen_dsp32shift(int sopcde, REG_T dst0, REG_T src0, REG_T src1,
               int sop, int HLs)
{
	INIT(DSP32Shift);

	ASSIGN(sopcde);
	ASSIGN(sop);
	ASSIGN(HLs);

	ASSIGN_R(dst0);
	ASSIGN_R(src0);      ASSIGN_R(src1);

	return GEN_OPCODE32();
}

INSTR_T
gen_dsp32shiftimm(int sopcde, REG_T dst0, int immag, REG_T src1,
                  int sop, int HLs)
{
	INIT(DSP32ShiftImm);

	ASSIGN(sopcde);
	ASSIGN(sop);
	ASSIGN(HLs);

	ASSIGN_R(dst0);
	ASSIGN(immag);
	ASSIGN_R(src1);

	return GEN_OPCODE32();
}

///////////////////////////////////////////////////////////////////////////
// LOOP SETUP

INSTR_T
gen_loopsetup(ExprNode *soffset, REG_T c, int rop, ExprNode *eoffset, REG_T reg)
{
	INIT(LoopSetup);

	_BF.soffset = EXPR_VALUE(soffset) >> 1;
	_BF.eoffset = EXPR_VALUE(eoffset) >> 1;
	ASSIGN(rop);
	ASSIGN_R(c);
	ASSIGN_R(reg);

	return
		CONSCODE(GENCODE(HI(c_code.opcode)),
		conctcode(ExprNodeGenReloc(soffset, BFD_RELOC_5_PCREL),
			  conctcode(GENCODE(LO(c_code.opcode)),
		          ExprNodeGenReloc(eoffset, BFD_RELOC_11_PCREL))));

}

///////////////////////////////////////////////////////////////////////////
// CALL, LINK

INSTR_T
gen_calla(ExprNode *addr, int S)
{
	int val;
	int high_val;

	INIT(CALLa);
	//int val;
	ASSIGN(S);
	val = EXPR_VALUE(addr) >> 1;
	high_val = val >> 16;
	//printf("call %x\n", val << 1);
	// _BF.addr = val;

	return CONSCODE(GENCODE(HI(c_code.opcode) | LO(high_val)),
		ExprNodeGenReloc(addr, 
			S?BFD_RELOC_24_PCREL: BFD_RELOC_24_PCREL_JUMP_L));
}

INSTR_T
gen_linkage(int R, int framesize)
{
	INIT(Linkage);

	ASSIGN(R);
	ASSIGN(framesize);

	return GEN_OPCODE32();
}


////////////////////////////////////////////////////////////////////////////
// LOAD / STORE

INSTR_T
gen_ldimmhalf(REG_T reg, int H, int S, int Z, ExprNode *hword, int reloc)
{
	unsigned val = EXPR_VALUE(hword);
	INIT(LDIMMhalf);

	ASSIGN(H);
	ASSIGN(S);
	ASSIGN(Z);

	ASSIGN_R(reg);
	// determine group:
	_BF.grp = GROUP(reg);
        
	if(reloc == 2) { //Relocation 5 , rN = <preg>
		return CONSCODE(GENCODE(HI(c_code.opcode)),
			ExprNodeGenReloc(hword, BFD_RELOC_16_IMM));
	}
	else if (reloc == 1) {
		return CONSCODE(GENCODE(HI(c_code.opcode)),
				ExprNodeGenReloc(hword,
					IS_H(*reg) ? BFD_RELOC_16_HIGH : BFD_RELOC_16_LOW));
	} else {
		_BF.hword = val;
	}
	return GEN_OPCODE32();
}

INSTR_T
gen_ldstidxi(REG_T ptr, REG_T reg, int W, int sz, int Z,
             ExprNode *offset)
{
	int value = 0;
	INIT(LDSTidxI);


	if (!IS_PREG(*ptr) || (!IS_DREG(*reg) && !Z)) {
		fprintf(stderr, "Warning: possible mixup of Preg/Dreg\n");
		return 0;
	}

	ASSIGN_R(ptr);
	ASSIGN_R(reg);
	ASSIGN(W);
	ASSIGN(sz);
	switch (sz) { // load/store access size
		case 0: // 32 bit
			value = EXPR_VALUE(offset) >> 2;
			break;
		case 1: // 16 bit
			value = EXPR_VALUE(offset) >> 1;
			break;
		case 2: // 8 bit
			value = EXPR_VALUE(offset);
			break;
	}


	ASSIGN(Z);
	_BF.offset = value & 0xffff;
	
	return GEN_OPCODE32();
}

// } END 32 BIT INSTRUCTIONS
////////////////////////////////////////////////////////////////////////////

INSTR_T
gen_ldst(REG_T ptr, REG_T reg, int aop, int sz, int Z, int W)
{
	INIT(LDST);

	if (!IS_PREG(*ptr) || (!IS_DREG(*reg) && !Z)) {
		fprintf(stderr, "Warning: possible mixup of Preg/Dreg\n");
		return 0;
	}

	ASSIGN_R(ptr);
	ASSIGN_R(reg);
	ASSIGN(aop);
	ASSIGN(sz);
	ASSIGN(Z);
	ASSIGN(W);

	return GEN_OPCODE16();
}

INSTR_T
gen_ldstii(REG_T ptr, REG_T reg, ExprNode *offset, int W, int op)
{
	int value = 0;
	INIT(LDSTii);


	if (!IS_PREG(*ptr)) {
		fprintf(stderr, "Warning: possible mixup of Preg/Dreg\n");
		return 0;
	}

	switch (op) {
		case 1:  // W [ ]
		case 2:
			value = EXPR_VALUE(offset) >> 1;
			break;
		case 0:
		case 3:
			value = EXPR_VALUE(offset) >> 2;
			break;
	}


	ASSIGN_R(ptr);
	ASSIGN_R(reg);

	_BF.offset = value;
	ASSIGN(W);
	ASSIGN(op);

	return GEN_OPCODE16();
}

INSTR_T
gen_ldstiifp(REG_T reg, ExprNode *offset, int W)
{
	INIT(LDSTiiFP);

	// set bit 4 if it's a Preg:
	_BF.reg = (reg->regno & CODE_MASK) | (IS_PREG(*reg) ? 0x8 : 0x0);
	_BF.offset = -EXPR_VALUE(offset) >> 2;
	ASSIGN(W);

	return GEN_OPCODE16();
}

INSTR_T
gen_ldstpmod(REG_T ptr, REG_T reg, int aop, int W, REG_T idx)
{
	INIT(LDSTpmod);

	ASSIGN_R(ptr);
	ASSIGN_R(reg);
	ASSIGN(aop);
	ASSIGN(W);
	ASSIGN_R(idx);

	return GEN_OPCODE16();
}

INSTR_T
gen_dspldst(REG_T i, REG_T reg, int aop, int W, int m)
{
	INIT(DspLDST);

	ASSIGN_R(i);
	ASSIGN_R(reg);
	ASSIGN(aop);
	ASSIGN(W);
	ASSIGN(m);

	return GEN_OPCODE16();
}

INSTR_T
gen_logi2op(int opc, int src, int dst)
{
	INIT(LOGI2op);

	ASSIGN(opc);
	ASSIGN(src);
	ASSIGN(dst);

	return GEN_OPCODE16();
}

INSTR_T
gen_brcc(int T, int B, ExprNode *offset)
{
	INIT(BRCC);

	ASSIGN(T);
	ASSIGN(B);
	_BF.offset = (EXPR_VALUE(offset) >> 1);

	return CONSCODE(GENCODE(c_code.opcode), 
		ExprNodeGenReloc(offset, BFD_RELOC_10_PCREL));
}

INSTR_T
gen_ujump(ExprNode *offset)
{
	INIT(UJump);

	_BF.offset = (EXPR_VALUE(offset) >> 1);

	return CONSCODE(GENCODE(c_code.opcode),
		ExprNodeGenReloc(offset, BFD_RELOC_12_PCREL_JUMP_S));
}

INSTR_T
gen_alu2op(REG_T dst, REG_T src, int opc)
{
	INIT(ALU2op);

	ASSIGN_R(dst);
	ASSIGN_R(src);
	ASSIGN(opc);

	return GEN_OPCODE16();
}

INSTR_T
gen_compi2opd(REG_T dst, int src, int op)
{
	INIT(COMPI2opD);

	ASSIGN_R(dst);
	ASSIGN(src);
	ASSIGN(op);

	return GEN_OPCODE16();
}

INSTR_T
gen_compi2opp(REG_T dst, int src, int op)
{
	INIT(COMPI2opP);

	ASSIGN_R(dst);
	//printf("Regiter ID: %d\n", dst->regno);
	ASSIGN(src);
	ASSIGN(op);

	return GEN_OPCODE16();
}

INSTR_T
gen_dagmodik(REG_T i, int op)
{
	INIT(DagMODik);

	ASSIGN_R(i);
	ASSIGN(op);

	return GEN_OPCODE16();
}
	
INSTR_T
gen_dagmodim(REG_T i, REG_T m, int op, int br)
{
	INIT(DagMODim);

	ASSIGN_R(i);
	ASSIGN_R(m);
	ASSIGN(op);
	ASSIGN(br);

	return GEN_OPCODE16();
}

INSTR_T
gen_ptr2op(REG_T dst, REG_T src, int opc)
{
	INIT(PTR2op);

	ASSIGN_R(dst);
	ASSIGN_R(src);
	ASSIGN(opc);

	return GEN_OPCODE16();
}

INSTR_T
gen_comp3op(REG_T src0, REG_T src1, REG_T dst, int opc)
{
	INIT(COMP3op);

	ASSIGN_R(src0);
	ASSIGN_R(src1);
	ASSIGN_R(dst);
	ASSIGN(opc);

	return GEN_OPCODE16();
}

INSTR_T
gen_ccflag(REG_T x, int y, int opc, int I, int G)
{
	INIT(CCflag);

	ASSIGN_R(x);
	ASSIGN(y);
	ASSIGN(opc);
	ASSIGN(I);
	ASSIGN(G);

	return GEN_OPCODE16();
}

INSTR_T
gen_ccmv(REG_T src, REG_T dst, int T)
{
	INIT(CCmv);

	ASSIGN_R(src);
	ASSIGN_R(dst);
	_BF.s = GROUP(src);
	_BF.d = GROUP(dst);
	ASSIGN(T);

	return GEN_OPCODE16();
}

INSTR_T
gen_cc2stat(int cbit, int op, int D)
{
	INIT(CC2stat);

	ASSIGN(cbit);
	ASSIGN(op);
	ASSIGN(D);

	return GEN_OPCODE16();
}

INSTR_T
gen_regmv(REG_T src, REG_T dst)
{
	INIT(RegMv);

	ASSIGN_R(src);
	ASSIGN_R(dst);

	_BF.gs = GROUP(src);
	_BF.gd = GROUP(dst);

	return GEN_OPCODE16();
}

INSTR_T
gen_cc2dreg(int op, REG_T reg)
{
	INIT(CC2dreg);

	ASSIGN(op);
	ASSIGN_R(reg);

	return GEN_OPCODE16();
}

INSTR_T
gen_progctrl(int prgfunc, int poprnd)
{
	INIT(ProgCtrl);

	ASSIGN(prgfunc);
	ASSIGN(poprnd);

	return GEN_OPCODE16();
}

INSTR_T
gen_cactrl(REG_T reg, int a, int op)
{
	INIT(CaCTRL);

	ASSIGN_R(reg);
	ASSIGN(a);
	ASSIGN(op);

	return GEN_OPCODE16();
}

INSTR_T
gen_pushpopmultiple(int dr, int pr, int d, int p, int W)
{
	INIT(PushPopMultiple);

	ASSIGN(dr);
	ASSIGN(pr);
	ASSIGN(d);
	ASSIGN(p);
	ASSIGN(W);

	return GEN_OPCODE16();
}

INSTR_T
gen_pushpopreg(REG_T reg, int W)
{
	INIT(PushPopReg);

	ASSIGN_R(reg);
	_BF.grp = GROUP(reg);
	ASSIGN(W);

	return GEN_OPCODE16();
}

////////////////////////////////////////////////////////////////////////////
// PSEUDO DEBUGGING SUPPORT

INSTR_T
gen_pseudodbg(int fn, int reg, int grp)
{
	INIT(PseudoDbg);

	ASSIGN(fn);
	ASSIGN(reg);
	ASSIGN(grp);

	return GEN_OPCODE16();
}

INSTR_T
gen_pseudodbg_assert(int dbgop, REG_T regtest, int expected)
{
	INIT(PseudoDbg_Assert);

	ASSIGN(dbgop);
	ASSIGN_R(regtest);
	ASSIGN(expected);

	return GEN_OPCODE32();
}

////////////////////////////////////////////////////////////////////////////
//
// Multiple instruction generation
//

INSTR_T
gen_multi_instr(INSTR_T dsp32, INSTR_T dsp16_grp1, INSTR_T dsp16_grp2)
{
	INSTR_T walk;

	// If it's a 0, convert into MNOP
	if (dsp32) {
		walk = dsp32->next;
		SET_MULTI_INSTRUCTION_BIT(dsp32);
	} else {
		dsp32 = GENCODE(0xc803);
		walk = GENCODE(0x1800);
		dsp32->next = walk;
	}

	if (!dsp16_grp1) {
		dsp16_grp1 = GENCODE(0x0000);
	}

	if (!dsp16_grp2) {
		dsp16_grp2 = GENCODE(0x0000);
	}

	walk->next = dsp16_grp1;
	dsp16_grp1->next = dsp16_grp2;
	dsp16_grp2->next = NULL_CODE; // terminate

	return dsp32;
}



