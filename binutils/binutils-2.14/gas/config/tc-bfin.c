/* tc-bfin.c -- Assembler for the Analog Devices Blackfin.
 * Copyright (c) 2000-2001 by Lineo, Inc./Lineo Canada Corp. (www.lineo.com),
 * Copyright (c) 2001-2002 by Arcturus Networks Inc.(www.arcturusnetworks.com)
 * Ported for Blackfin Architecture by 
 *	      Akbar Hussain  <akbar.hussain@arcturusnetworks.com>,
 *	      Faisal Akber <fakber@arcturusnetworks.com>,
 *            Tony Kou <tony.ko@arcturusnetworks.com>
 * Copyright (c) 2003, Metrowerks
 */


#include "as.h"
#include "obj-elf.h"
#include "bfin-defs.h"
#include "obstack.h"

extern int yyparse();
struct yy_buffer_state;
typedef struct yy_buffer_state *YY_BUFFER_STATE;
extern YY_BUFFER_STATE yy_scan_string ( const char *yy_str );
extern void yy_delete_buffer ( YY_BUFFER_STATE b );  
static void parse(char *line);
void assembler_parser_init ();
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
  { "R1:0", REG_R1_0 },
  { "R3:2", REG_R3_2 },
  { "R5:4", REG_R5_4 },
  { "R7:6", REG_R7_6 },
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
  { "AZ", REG_AZ },
  { "AN", REG_AN },
  { "AC", REG_AC },
  { "AV0", REG_AV0 },
  { "AV1", REG_AV1 },
  { "AQ", REG_AQ },
  { "sftreset", REG_sftreset },
  { "omode", REG_omode },
  { "excause", REG_excause },
  { "emucause", REG_emucause },
  { "idle_req", REG_idle_req },
  { "hwerrcause", REG_hwerrcause },
  { "CC", REG_CC },
  { "LC0", REG_LC0 },
  { "LC1", REG_LC1 },
  { "GP", REG_GP },
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
  { "LASTREG", REG_LASTREG }
};


/* 
 * Declare pseudo operands table. 
 * ------------------------------
 * The table below lists the assebler directives allowed by BFIN,
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

static void
s_bss (ignore)
     int ignore;
{
  register int temp;
 
  temp = get_absolute_expression ();
  subseg_set (bss_section, (subsegT) temp);
  demand_empty_rest_of_line ();
}                


/* Characters that are used to denote comments and line separators. */
const char comment_chars[]        = "//";
const char line_comment_chars[]   = "//#";
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

void md_show_usage (FILE * stream)
{
  printf("");
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
  register unsigned int i, j;

  /* Set the default machine type. */
  if (!bfd_set_arch_mach (stdoutput, bfd_arch_bfin, 0))
    as_warn("Could not set architecture and machine.");

  /* 
   * Ensure that lines can begin with '(', for multiple register stack pops.
   * and other such operations.
   *
   * It is better to define a macro called LEX_PAREN, and modify read.c,
   * but for now this will do.
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

#ifdef OBJ_ELF
  record_alignment (text_section, 2);
  record_alignment (data_section, 2);
  record_alignment (bss_section, 2);
#endif

  assembler_parser_init();
#ifdef TEST
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
  char *toP;
  extern char *current_inputline; 
  int size;
  int gen_insn = 1; // some relocations do not generate instructions
  
  current_inputline = line;
  /* Parse line here.  */
  parse(line); 

  /* 
   * Output the opcode. 
   * Create frag, then do fixup here.  
   * Let GAS do any relaxations.
   */
  while (insn)
  {

    if (insn->reloc != 0 && insn->exp->symbol) 
    {
	switch (insn->reloc)
	  {
	   case BFD_RELOC_24_PCREL_CALL_X:
	   case BFD_RELOC_24_PCREL:
	   case BFD_RELOC_16_LOW:
	   case BFD_RELOC_16_HIGH:
		size = 4;
		break;
	   default:
		size = 2;
	  }
	gen_insn = 0;
	/*Following if condition checks for the arithmetic relocations. 
	 * If the case then it doesn't required to generate the code.
	 * It has been assumed that, their ID will be contiguous*/
	if(((BFD_ARELOC_E0 <= insn->reloc) && (BFD_ARELOC_F3 >= insn->reloc)) ||
		insn->reloc == BFD_RELOC_16_IMM)
	{
//fprintf(stderr, "generating reloc for %x at %x\n", insn->reloc, toP);
		gen_insn = 0;
		size = 2;
	}
	if(gen_insn){
          toP = frag_more(2);
          md_number_to_chars(toP, insn->value, 2);
	}

        fix_new(frag_now, (toP - frag_now->fr_literal),
		  size, insn->exp->symbol, insn->exp->value, insn->pcrel, insn->reloc);
    }
    else{
      toP = frag_more(2);
      md_number_to_chars(toP, insn->value, 2);
    }
    
    insn = insn->next;
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
  INSTR_T temp_insn;

  buffstate = yy_scan_string(line);

     /* Call yyparse here.  */
     if (yyparse() == 0)
     {
     as_bad("Parse failed.");
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
md_undefined_symbol (name)
     char * name;
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
md_number_to_chars (buf, val, n)
     char * buf;
     valueT val;
     int    n;
{
//fprintf(stderr, "generating %x at %x\n", val, buf);
     	number_to_chars_littleendian (buf, val, n);
}

int md_estimate_size_before_relax (fragS * fragP, segT segment)
{

}

/* void md_convert_frag (bfd * abfd, segT sec, fragS * fragP)  */

void 
md_apply_fix3 (fixP, valp, seg)
     fixS *fixP;
     valueT *valp; 
     segT seg ATTRIBUTE_UNUSED;
{
  char *buf = fixP->fx_where + fixP->fx_frag->fr_literal;

  int lowbyte = target_big_endian ? 1 : 0;
  int highbyte = target_big_endian ? 0 : 1; 
  long val = *valp;
  int shift;
//fprintf(stderr, "calling fix3 with %x\n", fixP->fx_r_type);
return; // currently let us not fix local relocations.

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
     case BFD_RELOC_12_PCREL_JUMP : //TODO Jyotik
     case BFD_RELOC_12_PCREL_JUMP_S : //TODO Jyotik
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
     case BFD_RELOC_24_PCREL_JUMP :  //TODO Jyotik
     case BFD_RELOC_24_PCREL_JUMP_X : //TODO Jyotik
     case BFD_RELOC_24_PCREL_JUMP_L:  //TODO Jyotik
     case BFD_RELOC_24_PCREL_CALL_X:   //TODO -Jyotik
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
     case BFD_RELOC_5_PCREL: //TODO -Jyotik
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
     case BFD_RELOC_11_PCREL : //TODO Jyotik
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

     case BFD_RELOC_16_IMM: //Jyotik
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
		//added following line for arithmetic reloc check -Jyotik
     default: if((BFD_ARELOC_E0 > fixP->fx_r_type) || (BFD_ARELOC_F3 < fixP->fx_r_type))
		      {

		abort ();
		      }
   }

   if (shift != 0)
   {
     val = *valp;
     if ((val & ((1 << shift) - 1)) != 0)
	as_bad_where (fixP->fx_file, fixP->fx_line, "misaligned offset"); 
   }

}

/* Round up a section size to the appropriate bou.dary. */
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
md_atof (type, litP, sizeP)
     char type;
     char *litP;
     int *sizeP;
{

as_tsktsk("Generally we don't need md_atof.\n");
}

/* Convert a machine dependent frag.  We never generate these.  */
void
md_convert_frag (abfd, sec, fragp)
     bfd *abfd;
     asection *sec;
     fragS *fragp;
{
  abort ();
}

/* Translate internal representation of relocation info to BFD target format.  */
arelent *
tc_gen_reloc (section, fixp)
     asection *section;
     fixS *fixp;
{
  arelent *reloc;
  bfd_reloc_code_real_type code;   
  
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
                    "Can not represent %s relocation in this object file format",
                    bfd_get_reloc_code_name (code));
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
  return fixP->fx_frag->fr_address + fixP->fx_where + fixP->fx_size;
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
 */

#include <stdio.h>
#include <assert.h>
#include <obstack.h>
#include <bfd.h>
#include "bfin-defs.h"

struct obstack mempool;

INSTR_T conscode(INSTR_T head, INSTR_T tail) 
{
	if(!head)
		return tail;
  (head)->next = (tail);
  return (head);
}

INSTR_T conctcode(INSTR_T head, INSTR_T tail)
{
	INSTR_T temp = (head);
	if(!head)
		return tail;
	while(temp->next)
		temp = temp->next;
	temp->next = (tail);
	  
	return (head);
}
INSTR_T notereloc(INSTR_T code, ExprNode *symbol, int reloc, int pcrel)
{
	/* assert that the symbol is not an operator */
	assert(symbol->type == ExprNodeReloc);

	return notereloc1(code, symbol->value.s_value, reloc, pcrel);

}
INSTR_T notereloc1(INSTR_T code, const char *symbol, int reloc, int pcrel)
{
  (code)->reloc = reloc;
  (code)->exp = mkexpr(0,symbol_find_or_make(symbol));
  (code)->pcrel = pcrel;
  return (code);
}

INSTR_T gencode(unsigned long x)
{
  INSTR_T cell = (INSTR_T)obstack_alloc (&mempool, sizeof (struct bfin_insn));
  memset (cell, 0, sizeof (struct bfin_insn));
  cell->value = (x); 
  return cell;
}

int  reloc;

int ninsns;

int count_insns;

void *allocate(int n)
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
        break;
      case BFD_RELOC_24_PCREL_JUMP_X :
      case BFD_RELOC_24_PCREL :
      case BFD_RELOC_24_PCREL_JUMP_L :
      case BFD_RELOC_24_PCREL_CALL_X :  
      case BFD_RELOC_11_PCREL :
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
    note =  NOTERELOC1(0, parent_reloc, head->value.s_value, GENCODE(0x0));
    if(note1 != NULL_CODE)
      note =  CONSCODE(note1, note);
  }
  else{
    /* call the recursive function */
    note = NOTERELOC1(0, parent_reloc, op, GENCODE(0x0));
    if(note1 != NULL_CODE)
      note =  CONSCODE(note1, note);
    note =  CONCTCODE(ExprNodeGenRelocR(head), note);
  }
  return note;
}

static INSTR_T ExprNodeGenRelocR(ExprNode *head)
{
  
  INSTR_T note;
  INSTR_T note1;

  switch(head->type)
  {
  case ExprNodeConstant : 
    note =  CONSCODE(NOTERELOC1(0, BFD_ARELOC_E1, con, GENCODE(0x0)), 
                     NULL_CODE);
    break;
  case ExprNodeReloc :  
    note = CONSCODE(NOTERELOC(0, BFD_ARELOC_E0, head, GENCODE(0x0)), 
                    NULL_CODE); 
    break;    
  case ExprNodeBinop :   
    note1 = CONCTCODE(ExprNodeGenRelocR(head->LeftChild),
                          ExprNodeGenRelocR (head->RightChild));     
    switch(head->value.op_value)
    {
      case  ExprOpTypeAdd  :  
        note = CONCTCODE(note1, 
                  CONSCODE(NOTERELOC1(0, BFD_ARELOC_E2, op, GENCODE(0x0)), 
                           NULL_CODE));
        break;
      case  ExprOpTypeSub   :  
        note = CONCTCODE(note1, 
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_E3, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeMult   :  
         note = CONCTCODE(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_E4, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeDiv  :   
					note = CONCTCODE(note1,  
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_E5, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeMod  :   
					note = CONCTCODE(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_E6, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeLsft  :   
					note = CONCTCODE(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_E7, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeRsft  :   
					note = CONCTCODE(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_E8, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeBAND  :   
					note = CONCTCODE(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_E9, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeBOR  :   
					note = CONCTCODE(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_EA, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeBXOR  :    
					note = CONCTCODE(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_EB, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeLAND  :     
					note = CONCTCODE(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_EC, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeLOR  :   
					note = CONCTCODE(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_ED, op, GENCODE(0x0)), 
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
					note = CONCTCODE(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_EF, op, GENCODE(0x0)), 
														NULL_CODE));
          break;
      case  ExprOpTypeCOMP  :    
					note = CONCTCODE(note1,
                    CONSCODE(NOTERELOC1(0, BFD_ARELOC_F0, op, GENCODE(0x0)), 
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

