/*
 * Copyright (c) 2000, 2001 Analog Devices Inc.,
 * Copyright (c) 2000, 2001 by Lineo, Inc./Lineo Canada Corp. (www.lineo.com),
 * Copyright (c) 2001 by Arcturus Networks Inc. (www.arcturusnetworks.com),
 * Initially ported for Blackfin Architecture by
              Akbar Hussain  <akbar.hussain@arcturusnetworks.com>,
 *            Tony Kou <tony.ko@arcturusnetworks.com>
 * Copyright (c) 2003, Metrowerks
 *
 */


#include "bfd.h"
#include "sysdep.h"
#include "libbfd.h"
#include "elf-bfd.h"

/* This does not include any relocations, but should be good enough
   for GDB to read the file.  */

#define TARGET_LITTLE_SYM		bfd_elf32_bfin_vec
#define TARGET_LITTLE_NAME		"elf32-bfin"
#define ELF_ARCH			bfd_arch_bfin
#define ELF_MACHINE_CODE		EM_BF533	
#define ELF_MAXPAGESIZE			0x1000
static int arith_reloc_val;
static bfd_boolean elf_bfin_is_local_label_name PARAMS ((bfd *, const char *));

//We are sharing the reloc_type enum with elf2flat utility. So, moving it to seperate file -JyotiK
#include "bfin-reloctype.h"

/* handling expression relocations for blackfin.
   Blackfin will generate relocations in an expression form
   with a stack.
   A relocation such as P1.H  = _typenames-4000000;
   will generate the following relocs at offset 4:
00000004 R_expst_push      _typenames
00000004 R_expst_const     .__constant
00000004 R_expst_sub       .__operator
00000006 R_huimm16         .__operator

   The .__constant and .__operator symbol names are fake.
   Special case is a single relocation
     P1.L  = _typenames; generates
00000002 R_luimm16         _typenames

   Thus, if you get a R_luimm16, R_huimm16, R_imm16,
   if the stack is not empty, pop the stack and
   put the value, else do the normal thing
We will currenly assume that the max the stack would grow to is 100
*/

#define RELOC_STACK_SIZE 100
static bfd_vma reloc_stack[RELOC_STACK_SIZE];
static unsigned int reloc_stack_tos = 0;

#define is_reloc_stack_empty() ((reloc_stack_tos > 0)?0:1)

static void
reloc_stack_push(bfd_vma value)
{
//fprintf(stderr, "pushing %d\n", (int)value);
  reloc_stack[reloc_stack_tos++] = value;
}

static bfd_vma
reloc_stack_pop()
{
//fprintf(stderr, "popping %d\n", (int)reloc_stack[reloc_stack_tos-1]);
  return reloc_stack[--reloc_stack_tos];
}

static bfd_vma
reloc_stack_operate(unsigned int oper)
{
  bfd_vma value;
  switch(oper){
    case 0xE2 :
    {
      value = reloc_stack[reloc_stack_tos - 2] + reloc_stack[reloc_stack_tos - 1];
      reloc_stack_tos -= 2;
      break;
    }
    case 0xE3 :
    {
      value = reloc_stack[reloc_stack_tos - 2] - reloc_stack[reloc_stack_tos - 1];
      reloc_stack_tos -= 2;
      break;
    }
    case 0xE4 :
    {
      value = reloc_stack[reloc_stack_tos - 2] * reloc_stack[reloc_stack_tos - 1];
      reloc_stack_tos -= 2;
      break;
    }
    case 0xE5 :
    {
      value = reloc_stack[reloc_stack_tos - 2] / reloc_stack[reloc_stack_tos - 1];
      reloc_stack_tos -= 2;
      break;
    }
    case 0xE6 :
    {
      value = reloc_stack[reloc_stack_tos - 2] % reloc_stack[reloc_stack_tos - 1];
      reloc_stack_tos -= 2;
      break;
    }
    case 0xE7 :
    {
      value = reloc_stack[reloc_stack_tos - 2] << reloc_stack[reloc_stack_tos - 1];
      reloc_stack_tos -= 2;
      break;
    }
    case 0xE8 :
    {
      value = reloc_stack[reloc_stack_tos - 2] >> reloc_stack[reloc_stack_tos - 1];
      reloc_stack_tos -= 2;
      break;
    }
    case 0xE9 :
    {
      value = reloc_stack[reloc_stack_tos - 2] & reloc_stack[reloc_stack_tos - 1];
      reloc_stack_tos -= 2;
      break;
    }
    case 0xEA :
    {
      value = reloc_stack[reloc_stack_tos - 2] | reloc_stack[reloc_stack_tos - 1];
      reloc_stack_tos -= 2;
      break;
    }
    case 0xEB :
    {
      value = reloc_stack[reloc_stack_tos - 2] ^ reloc_stack[reloc_stack_tos - 1];
      reloc_stack_tos -= 2;
      break;
    }
    case 0xEC :
    {
      value = reloc_stack[reloc_stack_tos - 2] && reloc_stack[reloc_stack_tos - 1];
      reloc_stack_tos -= 2;
      break;
    }
    case 0xED :
    {
      value = reloc_stack[reloc_stack_tos - 2] || reloc_stack[reloc_stack_tos - 1];
      reloc_stack_tos -= 2;
      break;
    }
    case 0xEF :
    {
      value = -reloc_stack[reloc_stack_tos - 1];
      reloc_stack_tos --;
      break;
    }
    case 0xF0 :
    {
      value = ~reloc_stack[reloc_stack_tos - 1];
      reloc_stack_tos -= 1;
      break;
    }
    default :
    {
       fprintf(stderr, "bfin relocation : Internal bug\n");
       return 0;
    }
  }

  // now push the new value back on stack
  reloc_stack_push(value);

  return value;
}


#if 0
/*defines map from constant type to bfd relocation type */
static struct { 
    char *name; 
    int nbits; 
    char reloc;
    char issigned; 
    char pcrel; 
    char scale;
    char offset; 
    char negative; 
    char positive; 
} constant_formats[] = {

  { "pcrel4", 4, 1, 0, 1, 1, 0, 0, 0 },
  { "pcrel8", 8, 1, 0, 1, 1, 0, 0, 0 },
  { "pcrel8s4", 8, 1, 1, 1, 2, 0, 0, 0 },
  { "pcrel10", 10, 1, 1, 1, 1, 0, 0, 0 },
  { "pcrel12", 12, 1, 1, 1, 1, 0, 0, 0 },
  { "rimm16", 16, 1, 1, 0, 0, 0, 0, 0 },
  { "huimm16", 16, 1, 0, 0, 0, 0, 0, 0 },
  { "luimm16", 16, 1, 0, 0, 0, 0, 0, 0 },
  { "lppcrel10", 10, 1, 0, 1, 1, 0, 0, 0 },
  { "pcrel24", 24, 1, 1, 1, 1, 0, 0, 0 },
};

#endif //0
static bfd_reloc_status_type bfin_unused_reloc(bfd* abfd ATTRIBUTE_UNUSED,
		arelent *reloc_entry ATTRIBUTE_UNUSED, asymbol *symbol ATTRIBUTE_UNUSED,
		PTR data ATTRIBUTE_UNUSED, asection *input_section ATTRIBUTE_UNUSED,
		bfd* output_bfd ATTRIBUTE_UNUSED, char** error_message ATTRIBUTE_UNUSED)
{
  fprintf(stderr, "Unknown relocation type found %s(%d)\n",__FILE__, __LINE__);
  return bfd_reloc_undefined;
}


/* FUNCTION : bfin_bfd_reloc
   ABSTRACT : Very similar to the bfd_perform_relocation in reloc.c
              It understands the blackfin arithmetic relocations
              It also handles different sizes using bfd_get_8
*/
static bfd_reloc_status_type
bfin_bfd_reloc (
     bfd *abfd,
     arelent *reloc_entry,
     asymbol *symbol,
     PTR data,
     asection *input_section,
     bfd *output_bfd,
     char **error_message) 
{
  bfd_vma relocation;
  bfd_reloc_status_type flag = bfd_reloc_ok;
  bfd_size_type addr = reloc_entry->address;
  bfd_vma output_base = 0;
  reloc_howto_type *howto = reloc_entry->howto;
  asection *reloc_target_output_section;
  int possible_addend_delta = 0;

#if 0
  flag = bfd_elf_generic_reloc (abfd, reloc_entry, 
			       symbol, data, input_section,
				     output_bfd, error_message);
  if (flag    != bfd_reloc_continue) {
      return flag;
  }
  if (flag == bfd_reloc_continue) {
#endif

      /* Is the address of the relocation really within the section?  */
      if (reloc_entry->address > input_section->_cooked_size)
	      return bfd_reloc_outofrange;
      if(is_reloc_stack_empty()){
        // check if symbol is defined
        if (bfd_is_und_section (symbol->section)
             && (symbol->flags & BSF_WEAK) == 0
             && output_bfd == (bfd *) NULL)
          return bfd_reloc_undefined;

        /* Get symbol value.  (Common symbols are special.)  */
        if (bfd_is_com_section (symbol->section)) {
           relocation = 0;
        }
        else {
           relocation = symbol->value;       
  
        }
  
        reloc_target_output_section = symbol->section->output_section;
  
        
        /* Convert input-section-relative symbol value to absolute.  */
        if (output_bfd && howto->partial_inplace == FALSE)
	    output_base = 0;
        else
	    output_base = reloc_target_output_section->vma;
        
        if (!strcmp(symbol->name, symbol->section->name) || output_bfd == NULL){
          relocation += output_base + symbol->section->output_offset;
          possible_addend_delta = symbol->section->output_offset;
	}
        if (!strcmp(symbol->name, symbol->section->name) && output_bfd == NULL){
          /* Add in supplied addend.  */
          relocation += reloc_entry->addend;
        }
        
      }
      else{
        relocation = reloc_stack_pop();
      }
      
        /* Here the variable relocation holds the final address of the
	   symbol we are relocating against, plus any addend.  */

      if (howto->pc_relative == TRUE)
	{
          relocation -=
	    input_section->output_section->vma + input_section->output_offset;

       /* if (howto->pcrel_offset == FALSE)
             relocation -= reloc_entry->address; */
 
          if (howto->pcrel_offset == TRUE && howto->partial_inplace == TRUE)
             relocation -= reloc_entry->address;
	}
    if (output_bfd != (bfd *) NULL) {
       /* this output will be relocatable ... like ld -r */
       reloc_entry->address += input_section->output_offset;
       reloc_entry->addend += possible_addend_delta; // for symbols that are section names
    }


  /* FIXME: This overflow checking is incomplete, because the value
     might have overflowed before we get here.  For a correct check we
     need to compute the value in a size larger than bitsize, but we
     can't reasonably do that for a reloc the same size as a host
     machine word.
     FIXME: We should also do overflow checking on the result after
     adding in the value contained in the object file.              */

     if (howto->complain_on_overflow != complain_overflow_dont)
        flag = bfd_check_overflow (howto->complain_on_overflow, 
                               howto->bitsize,
                               howto->rightshift, 
                               bfd_arch_bits_per_address(abfd),
                               relocation);      
      
      /* if rightshift is 1 and the number odd, return error */
      if(howto->rightshift && (relocation & 0x01)){
        fprintf(stderr, "relocation should be even number\n");
        return bfd_reloc_overflow; // the best we can!
      }

      relocation >>= (bfd_vma) howto->rightshift;

      /* Shift everything up to where it's going to be used */

      relocation <<= (bfd_vma) howto->bitpos;
#define DOIT(x) \
  x = ( (x & ~howto->dst_mask) | (relocation & howto->dst_mask))

  // handle 8 and 16 bit relocations here
  // actual relocations size are smaller and the src_mask will help
  switch (howto->size)
    {
    case 0:
      {
	char x = bfd_get_8 (abfd, (char *) data + addr);
	DOIT (x);
	bfd_put_8 (abfd, x, (unsigned char *) data + addr);
      }
      break;

    case 1:
      {
       unsigned short x = bfd_get_16 (abfd, (bfd_byte *) data + addr);
	DOIT (x);
	bfd_put_16 (abfd, (bfd_vma) x, (unsigned char *) data + addr);
      }
      break;
    default:
      return bfd_reloc_other;
    }

      return bfd_reloc_ok;
#if 0
  }
#endif
   return flag; 
}

static bfd_reloc_status_type
bfin_pcrel24_reloc (
     bfd *abfd,
     arelent *reloc_entry,
     asymbol *symbol,
     PTR data,
     asection *input_section,
     bfd *output_bfd,
     char **error_message) 
{
  bfd_vma relocation;
  bfd_reloc_status_type flag = bfd_reloc_ok;
  bfd_size_type addr = reloc_entry->address;
  bfd_vma output_base = 0;
  reloc_howto_type *howto = reloc_entry->howto;
  asection *reloc_target_output_section;
  int possible_addend_delta = 0;

#if 0
  flag = bfd_elf_generic_reloc (abfd, reloc_entry, 
			       symbol, data, input_section,
				     output_bfd, error_message);
  if (flag    != bfd_reloc_continue) {
      return flag;
  }

  if (flag == bfd_reloc_continue) {
#endif

      /* Is the address of the relocation really within the section?  */
      if (reloc_entry->address > input_section->_cooked_size)
	      return bfd_reloc_outofrange;
      if(is_reloc_stack_empty()){

        if (bfd_is_und_section (symbol->section)
             && (symbol->flags & BSF_WEAK) == 0
             && output_bfd == (bfd *) NULL)
          return bfd_reloc_undefined;

        /* Get symbol value.  (Common symbols are special.)  */
        if (bfd_is_com_section (symbol->section)) {
           relocation = 0;
        }
        else {
           relocation = symbol->value;       
  
        }
  
        reloc_target_output_section = symbol->section->output_section;
  
        
        /* Convert input-section-relative symbol value to absolute.  */
        if (output_bfd && howto->partial_inplace == FALSE)
	    output_base = 0;
        else
	  output_base = reloc_target_output_section->vma;
      
        if (!strcmp(symbol->name, symbol->section->name) || output_bfd == NULL){
          relocation += output_base + symbol->section->output_offset;
          possible_addend_delta = symbol->section->output_offset;
	}
        
        if (!strcmp(symbol->name, symbol->section->name) && output_bfd == NULL){
          /* Add in supplied addend.  */
          relocation += reloc_entry->addend;
        }
      }
      else{
        relocation = reloc_stack_pop();
      }
      
      /* Here the variable relocation holds the final address of the
	 symbol we are relocating against, plus any addend.  */

      if (howto->pc_relative == TRUE){
          relocation -=
	    input_section->output_section->vma + input_section->output_offset;

       /* if (howto->pcrel_offset == FALSE)
             relocation -= reloc_entry->address; */
 
          if (howto->pcrel_offset == TRUE && howto->partial_inplace == TRUE)
             relocation -= reloc_entry->address;
	}

  /* FIXME: This overflow checking is incomplete, because the value
     might have overflowed before we get here.  For a correct check we
     need to compute the value in a size larger than bitsize, but we
     can't reasonably do that for a reloc the same size as a host
     machine word.
     FIXME: We should also do overflow checking on the result after
     adding in the value contained in the object file.              */

     if (howto->complain_on_overflow != complain_overflow_dont)
        flag = bfd_check_overflow (howto->complain_on_overflow, 
                               howto->bitsize,
                               howto->rightshift, 
                               bfd_arch_bits_per_address(abfd),
                               relocation);      
      
      /* if rightshift is 1 and the number odd, return error */
      if(howto->rightshift && (relocation & 0x01)){
        fprintf(stderr, "relocation should be even number\n");
        return bfd_reloc_overflow; // the best we can!
      }

      relocation >>= (bfd_vma) howto->rightshift;
/*      relocation -= 1;  */
      /* Shift everything up to where it's going to be used */

      relocation <<= (bfd_vma) howto->bitpos;
    if (output_bfd != (bfd *) NULL) {
       /* this output will be relocatable ... like ld -r */
       reloc_entry->address += input_section->output_offset;
       reloc_entry->addend += possible_addend_delta; // for symbols that are section names
    }
      {
         short x;
	/* We are getting reloc_entry->address 2 byte off from
	 * the start of instruction. Assuming absolute postion
	 * of the reloc data. But, following code had been written assuming 
	 * reloc address is starting at begining of instruction.
	 * To compensate that I have increased the value of 
	 * relocation by 1 (effectively 2) and used the addr -2 instead of addr
	 * -JyotiK
	 */
	 
	 relocation += 1;
         x = bfd_get_16 (abfd, (bfd_byte *) data + addr-2);
         x = (x&0xff00) | ((relocation>>16)&0xff);
 	 bfd_put_16 (abfd, x, (unsigned char *) data + addr -2);
         x = bfd_get_16 (abfd, (bfd_byte *) data + addr);
         x = relocation&0xFFFF;
 	 bfd_put_16 (abfd, x, (unsigned char *) data + addr );
      }
      return bfd_reloc_ok;
#if 0
  }
#endif
   return flag; 
}

static bfd_reloc_status_type
bfin_push_reloc (
     bfd *abfd,
     arelent *reloc_entry,
     asymbol *symbol,
     PTR data,
     asection *input_section,
     bfd *output_bfd,
     char **error_message) 
{
  bfd_vma relocation;
  //bfd_reloc_status_type flag = bfd_reloc_ok;
  bfd_vma output_base = 0;
  asection *reloc_target_output_section;
  bfd_reloc_status_type flag = bfd_reloc_ok;
  int possible_addend_delta = 0;

  if (bfd_is_und_section (symbol->section)
      && (symbol->flags & BSF_WEAK) == 0
      && output_bfd == (bfd *) NULL)
    flag = bfd_reloc_undefined;


  /* Is the address of the relocation really within the section?  */
  if (reloc_entry->address > input_section->_cooked_size)
     return bfd_reloc_outofrange;
      
  reloc_target_output_section = symbol->section->output_section;
  relocation = symbol->value;      
  /* Convert input-section-relative symbol value to absolute.  */
  if (output_bfd)
	  output_base = 0;
      else
	  output_base = reloc_target_output_section->vma;

  if (!strcmp(symbol->name, symbol->section->name) || output_bfd == NULL){
      	relocation += output_base + symbol->section->output_offset;
        possible_addend_delta = symbol->section->output_offset;
   }

  /* Add in supplied addend.  */
  relocation += reloc_entry->addend;

  if (output_bfd != (bfd *) NULL) {
     /* this output will be relocatable ... like ld -r */
     reloc_entry->address += input_section->output_offset;
     reloc_entry->addend += possible_addend_delta; // for symbols that are section names
  }



  /* now that we have the value, push it */
  reloc_stack_push(relocation);
  
  return flag;
}

static bfd_reloc_status_type
bfin_oper_reloc (
     bfd *abfd,
     arelent *reloc_entry,
     asymbol *symbol,
     PTR data,
     asection *input_section,
     bfd *output_bfd,
     char **error_message) 
{
  /* just call the operation based on the reloc_type */
  reloc_stack_operate(reloc_entry->howto->type);
  
  if (output_bfd != (bfd *) NULL) {
    /* this output will be relocatable ... like ld -r */
    /* Actually it would not matter as we ignore the address */
    reloc_entry->address += input_section->output_offset;
  }
  return bfd_reloc_ok;
}

static bfd_reloc_status_type
bfin_const_reloc (
     bfd *abfd,
     arelent *reloc_entry,
     asymbol *symbol,
     PTR data,
     asection *input_section,
     bfd *output_bfd,
     char **error_message) 
{
  /* push the addend portion of the relocation */
  reloc_stack_push(reloc_entry->addend);
  if (output_bfd != (bfd *) NULL) {
     /* this output will be relocatable ... like ld -r */
     /* Actually it would not matter as we ignore the address */
     reloc_entry->address += input_section->output_offset;
  }
  
  return bfd_reloc_ok;
}



static bfd_reloc_status_type
bfin_h_l_uimm16_reloc (
     bfd *abfd,
     arelent *reloc_entry,
     asymbol *symbol,
     PTR data,
     asection *input_section,
     bfd *output_bfd,
     char **error_message) 
{
  bfd_vma relocation, x;
  //bfd_reloc_status_type flag = bfd_reloc_ok;
  bfd_size_type addr = reloc_entry->address;
  bfd_vma output_base = 0;
  reloc_howto_type *howto = reloc_entry->howto;
  asection *reloc_target_output_section;
  int  possible_addend_delta = 0; // to be added to addend if output_bfd is 0

  // if the reloc stack is not empty, use that as the relocation value
#if 0
  if ( bfd_elf_generic_reloc (abfd, reloc_entry,
		  symbol, data, input_section, 
		  output_bfd, error_message) == bfd_reloc_continue)
  {
#endif

      /* Is the address of the relocation really within the section?  */
      if (reloc_entry->address > input_section->_cooked_size)
	      return bfd_reloc_outofrange;
      if(is_reloc_stack_empty()){
        reloc_target_output_section = symbol->section->output_section;
        relocation = symbol->value;      
        /* Convert input-section-relative symbol value to absolute.  */
        if (output_bfd){
	    output_base = 0;
        }
        else
	    output_base = reloc_target_output_section->vma;
  
        if (!strcmp(symbol->name, symbol->section->name) || output_bfd == NULL){
      	  relocation += output_base + symbol->section->output_offset;
          // if the symbol is the section name we need this delta to offset into
          // the symbol's output section in a relocatable output
          possible_addend_delta = symbol->section->output_offset;
        }

	if(symbol->flags & BSF_SECTION_SYM){
          /* Add in supplied addend.  */
          /* we do not generate addends any more, but section
	   * symbols (local symbols) have addends that has been added by the
	   * system
	   */
          relocation += reloc_entry->addend;
	}
      }
      else{
        relocation = reloc_stack_pop();
        //relocation += reloc_entry->addend;
        // assert(is_reloc_stack_empty());
      }
      if (output_bfd != (bfd *) NULL) {	              
	 /* this output will be relocatable ... like ld -r */
	 reloc_entry->address += input_section->output_offset;
	 // reloc_entry->addend = relocation;
	 reloc_entry->addend += possible_addend_delta;
      }
      else {
        reloc_entry->addend = 0;
      }
        /* Here the variable relocation holds the final address of the
	   symbol we are relocating against, plus any addend.  */

      x = bfd_get_16 (abfd, (bfd_byte *) data + addr);
      relocation >>= (bfd_vma) howto->rightshift;
      x = relocation;
      bfd_put_16 (abfd, x, (unsigned char *) data + addr);
#if 0
    }
#endif

    return bfd_reloc_ok;
}


static bfd_reloc_status_type
bfin_byte4_reloc (
     bfd *abfd,
     arelent *reloc_entry,
     asymbol *symbol,
     PTR data,
     asection *input_section,
     bfd *output_bfd,
     char **error_message) 
{
  bfd_vma relocation, x;
  //bfd_reloc_status_type flag = bfd_reloc_ok;
  bfd_size_type addr = reloc_entry->address;
  bfd_vma output_base = 0;
  reloc_howto_type *howto = reloc_entry->howto;
  asection *reloc_target_output_section;
  int  possible_addend_delta = 0; // to be added to addend if output_bfd is 0
    /* Is the address of the relocation really within the section?  */
      if (reloc_entry->address > input_section->_cooked_size)
	      return bfd_reloc_outofrange;
      if(is_reloc_stack_empty()){
        reloc_target_output_section = symbol->section->output_section;
        relocation = symbol->value;      
        /* Convert input-section-relative symbol value to absolute.  */
        if (output_bfd)
	    output_base = 0;
        else
	    output_base = reloc_target_output_section->vma;
  
        if (!strcmp(symbol->name, symbol->section->name) || output_bfd == NULL){
      	  relocation += output_base + symbol->section->output_offset;
          possible_addend_delta = symbol->section->output_offset;
	}

        relocation += reloc_entry->addend;
      }
      else{
        relocation = reloc_stack_pop();
        relocation += reloc_entry->addend;
        // assert(is_reloc_stack_empty());
      }
      if (output_bfd != (bfd *) NULL) {	              
	 /* this output will be relocatable ... like ld -r */
	 reloc_entry->address += input_section->output_offset;
	 reloc_entry->addend += possible_addend_delta;
       }
      else {
        reloc_entry->addend = 0;
      }
        /* Here the variable relocation holds the final address of the
	   symbol we are relocating against, plus any addend.  */

      x = relocation & 0xFFFF0000;
      x >>=16;
      bfd_put_16 (abfd, x, (unsigned char *) data + addr + 2);
            
      x = relocation & 0x0000FFFF;
      bfd_put_16 (abfd, x, (unsigned char *) data + addr);
    return bfd_reloc_ok;
}

/* HOWTO Table for blackfin.
   Blackfin relocations are fairly complicated. Some of the salient features are
   a. Even numbered offsets. A number of (not all) relocations are
      even numbered. This means that the rightmost bit is not stored.
      Needs to right shift by 1 and check to see if value is not odd
   b. A relocation can be an expression. An expression takes on
      a variety of relocations arranged in a stack.
   As a result, we cannot use the standard generic function as special
   function. We will have our own, which is very similar to the standard
   generic function except that it understands how to get the value from
   the relocation stack.
*/

static reloc_howto_type bfin_elf_howto_table[] =
{
  /* R4  #0x00*/
  HOWTO (R_unused0,              /* type */
         1,             /* rightshift */
         1,                     /* size (0 = byte, 1 = short, 2 = long) */
         4,             /* bitsize */
         TRUE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_unsigned,             /* complain_on_overflow */
         bfin_unused_reloc,           /* special_function */
         "R_unused0",            /* name */
         TRUE,      /* partial_inplace */
         0x0000000F,            /* src_mask */
         0x0000000F,            /* dst_mask */
         TRUE),         /* pcrel_offset */
   /* R5  #0x01*/
  HOWTO (R_pcrel5m2,              /* type */
         1,             /* rightshift */
         1,                     /* size (0 = byte, 1 = short, 2 = long) */
         4,             /* bitsize */
         TRUE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_unsigned,             /* complain_on_overflow */
         bfin_bfd_reloc,           /* special_function */
         "R_pcrel5m2",            /* name */
         TRUE,      /* partial_inplace */
         0x0000000F,            /* src_mask */
         0x0000000F,            /* dst_mask */
         TRUE),         /* pcrel_offset */
   /* R_unused1 #0x02 */
  HOWTO (R_unused1,             /* type */
         1,             /* rightshift */
         1,                     /* size (0 = byte, 1 = short, 2 = long) */
         4,             /* bitsize */
         TRUE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_unsigned,             /* complain_on_overflow */
	 bfin_unused_reloc,           /* special_function */
         "R_unused1",           /* name */
         TRUE,      /* partial_inplace */
         0x0000000F,            /* src_mask */
         0x0000000F,            /* dst_mask */
         TRUE),         /* pcrel_offset */
   /* R10  #0x03*/
  HOWTO (R_pcrel10,             /* type */
         1,             /* rightshift */
         1,                     /* size (0 = byte, 1 = short, 2 = long) */
         10,            /* bitsize */
         TRUE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_signed,             /* complain_on_overflow */
         bfin_bfd_reloc,           /* special_function */
         "R_pcrel10",           /* name */
         TRUE,      /* partial_inplace */
         0x000003FF,            /* src_mask */
         0x000003FF,            /* dst_mask */
         TRUE),         /* pcrel_offset */
  /* R12_jump #0x04 */
  HOWTO (R_pcrel12_jump,                /* type */
         1,             /* rightshift, the offset is actually 13 bit alligned on a word boundary so only 12 bits have to be used. Right shift the rightmost bit */
         1,                     /* size (0 = byte, 1 = short, 2 = long) */
         12,            /* bitsize */
         TRUE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_signed,             /* complain_on_overflow */
         bfin_bfd_reloc,           /* special_function */
         "R_pcrel12_jump",              /* name */
         TRUE,      /* partial_inplace */
         0x0FFF,            /* src_mask */
         0x0FFF,            /* dst_mask */
         TRUE),         /* pcrel_offset */
   /* R16 #0x05 */
  HOWTO (R_rimm16,              /* type */
         0,             /* rightshift */
         1,                     /* size (0 = byte, 1 = short, 2 = long) */
         16,            /* bitsize */
         FALSE,         /* pc_relative */
         0,             /* bitpos */
         complain_overflow_signed,             /* complain_on_overflow */
         bfin_h_l_uimm16_reloc,           /* special_function */
         "R_rimm16",            /* name */
         TRUE,      /* partial_inplace */
         0x0000FFFF,            /* src_mask */
         0x0000FFFF,            /* dst_mask */
         TRUE),         /* pcrel_offset */
  /* RL16  #0x06*/
  HOWTO (R_luimm16,             /* type */
         0,             /* rightshift */
         1,                     /* size (0 = byte, 1 = short, 2 = long) */
         16,            /* bitsize */
         FALSE,         /* pc_relative */
         0,             /* bitpos */
         complain_overflow_dont,             /* complain_on_overflow */
	 bfin_h_l_uimm16_reloc,         /* special_function */
         "R_luimm16",           /* name */
         TRUE,      /* partial_inplace */
         0x0000FFFF,            /* src_mask */
         0x0000FFFF,            /* dst_mask */
         TRUE),         /* pcrel_offset */
  /* RH16  #0x07*/
  HOWTO (R_huimm16,             /* type */
         16,            /* rightshift */
         1,                     /* size (0 = byte, 1 = short, 2 = long) */
         16,            /* bitsize */
         FALSE,         /* pc_relative */
         0,             /* bitpos */
         complain_overflow_unsigned,             /* complain_on_overflow */
	 bfin_h_l_uimm16_reloc,         /* special_function */
         "R_huimm16",           /* name */
         TRUE,      /* partial_inplace */
         0x0000FFFF,            /* src_mask */
         0x0000FFFF,            /* dst_mask */
         TRUE),         /* pcrel_offset */
  /* R12_jump_s #0x08 */
  HOWTO (R_pcrel12_jump_s,              /* type */
         1,             /* rightshift */
         1,                     /* size (0 = byte, 1 = short, 2 = long) */
         12,            /* bitsize */
         TRUE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_signed,             /* complain_on_overflow */
         bfin_bfd_reloc,           /* special_function */
         "R_pcrel12_jump_s",            /* name */
         TRUE,      /* partial_inplace */
         0x00000FFF,            /* src_mask */
         0x00000FFF,            /* dst_mask */
         TRUE),         /* pcrel_offset */
  /*R24_jump_x #0x09*/
    HOWTO (R_pcrel24_jump_x,     /*type*/
         1,
         2,
         24,
         TRUE,
         0,
         complain_overflow_signed,
	 bfin_pcrel24_reloc,
         "R_pcrel24_jump_x",
         TRUE,
         0x00FFFFFF,
         0x00FFFFFF,
         TRUE),
   /* Rrm8,Rrl16  #0x0a*/
  HOWTO (R_pcrel24,             /* type */
         1,             /* rightshift */
         2,                     /* size (0 = byte, 1 = short, 2 = long) */
         24,            /* bitsize */
         TRUE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_signed,             /* complain_on_overflow */
         bfin_pcrel24_reloc,            /* special_function */
         "R_pcrel24",           /* name */
         TRUE,      /* partial_inplace */
         0x00FFFFFF,            /* src_mask */
         0x00FFFFFF,            /* dst_mask */
         TRUE),         /* pcrel_offset */
 /* R8  #0x0b*/
  HOWTO (R_unusedb,              /* type */
         1,             /* rightshift */
         1,                     /* size (0 = byte, 1 = short, 2 = long) */
         8,             /* bitsize */
         TRUE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_unsigned,             /* complain_on_overflow */
         bfin_unused_reloc,           /* special_function */
         "R_pcrel8",            /* name */
         TRUE,      /* partial_inplace */
         0x000000FF,            /* src_mask */
         0x000000FF,            /* dst_mask */
         TRUE),         /* pcrel_offset */
  /* Rx8  #0x0c*/
    HOWTO (R_unusedc,            /* type */
         2,             /* rightshift */
         1,                     /* size (0 = byte, 1 = short, 2 = long) */
         8,             /* bitsize */
         TRUE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_signed,             /* complain_on_overflow */
         bfin_unused_reloc,           /* special_function */
         "R_pcrel8s4",          /* name */
         TRUE,      /* partial_inplace */
         0x000000FF,            /* src_mask */
         0x000000FF,            /* dst_mask */
         TRUE),         /* pcrel_offset */
  /* Rrm8,Rrl16 #0x0d */
  HOWTO (R_pcrel24_jump_l,              /* type */
         1,             /* rightshift */
         2,                     /* size (0 = byte, 1 = short, 2 = long) */
         24,            /* bitsize */
         TRUE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_signed,             /* complain_on_overflow */
         /*bfd_elf_generic_reloc, */ /*         special_function */
         bfin_pcrel24_reloc,            /* special_function */
         "R_pcrel24_jump_l",            /* name */
         TRUE,      /* partial_inplace */
         0x00FFFFFF,            /* src_mask */
         0x00FFFFFF,            /* dst_mask */
         TRUE),         /* pcrel_offset */
   /*Adding for aspecial case CALL.X in ADSP #0x0e*/
  HOWTO (R_pcrel24_call_x,     /*type*/
         1,
         2,
         24,
         TRUE,
         0,
         complain_overflow_signed,
         bfin_pcrel24_reloc,
         "R_pcrel24_call_x",
         TRUE,
         0x00FFFFFF,
         0x00FFFFFF,
         TRUE),
  /* R12 #0x0f */
    HOWTO (R_var_eq_symb,             /* type */
         1,             /* rightshift */
         1,                     /* size (0 = byte, 1 = short, 2 = long) */
         12,            /* bitsize */
         TRUE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_signed,             /* complain_on_overflow */
         bfin_unused_reloc,
	 //bfd_elf_generic_reloc,           /* special_function */
         "R_pcrel12",           /* name */
         TRUE,      /* partial_inplace */
         0x00000FFF,            /* src_mask */
         0x00000FFF,            /* dst_mask */
         TRUE),         /* pcrel_offset */

  /* Rlp10  #0x10*/
  HOWTO (R_byte_data,           /* type */
         0,             /* rightshift */
         0,                     /* size (0 = byte, 1 = short, 2 = long) */
         8,            /* bitsize */
         FALSE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_unsigned,             /* complain_on_overflow */
         bfd_elf_generic_reloc,           /* special_function */
         "R_byte_data",         /* name */
         FALSE,      /* partial_inplace */
         0xFF,            /* src_mask */
         0xFF,            /* dst_mask */
         TRUE),         /* pcrel_offset */

  /* R_unused2  #0x11*/
  HOWTO (R_byte2_data,             /* type */
         0,             /* rightshift */
         1,                     /* size (0 = byte, 1 = short, 2 = long) */
         16,            /* bitsize */
         FALSE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_signed,             /* complain_on_overflow */
         bfd_elf_generic_reloc,           /* special_function */
         "R_byte2_data",           /* name */
         TRUE,      /* partial_inplace */
         0xFFFF,            /* src_mask */
         0xFFFF,            /* dst_mask */
         TRUE),         /* pcrel_offset */

  /* R_unused7  #0x12*/
    HOWTO (R_byte4_data,             /* type */
         0,             /* rightshift */
         2,                     /* size (0 = byte, 1 = short, 2 = long) */
         32,            /* bitsize */
         FALSE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_unsigned,             /* complain_on_overflow */
         bfin_byte4_reloc,           /* special_function */
         "R_byte4_data",           /* name */
         TRUE,      /* partial_inplace */
         0xFFFFFFFF,            /* src_mask */
         0xFFFFFFFF,            /* dst_mask */
         TRUE),         /* pcrel_offset */
  /* Rlp11  #0x13*/
  HOWTO (R_pcrel11,             /* type */
         1,             /* rightshift */
         1,                     /* size (0 = byte, 1 = short, 2 = long) */
         10,            /* bitsize */
         TRUE,          /* pc_relative */
         0,             /* bitpos */
         complain_overflow_unsigned,             /* complain_on_overflow */
         bfin_bfd_reloc,           /* special_function */
         "R_pcrel11",           /* name */
         TRUE,      /* partial_inplace */
         0x000003FF,            /* src_mask */
         0x000003FF,            /* dst_mask */
         TRUE),         /* pcrel_offset */


  /* A standard 32 bit relocation.  */
  HOWTO (R_unused14,               /* type */
         0,                     /* rightshift */
         2,                     /* size (0 = byte, 1 = short, 2 = long) */
         16,                    /* bitsize */
         FALSE,                 /* pc_relative */
         0,                     /* bitpos */
         complain_overflow_bitfield, /* complain_on_overflow */
         bfin_unused_reloc, /* special_function */
         "R_abs16",             /* name */
         FALSE,                 /* partial_inplace */
         0x0000ffff,            /* src_mask */
         0x0000ffff,            /* dst_mask */
         FALSE),                /* pcrel_offset */
  /* A standard 32 bit relocation.  */
     HOWTO (R_unused15,               /* type */
             0,                     /* rightshift */
             2,                     /* size (0 = byte, 1 = short, 2 = long) */
             32,                    /* bitsize */
             FALSE,                 /* pc_relative */
             0,                     /* bitpos */
             complain_overflow_bitfield, /* complain_on_overflow */
             bfin_unused_reloc, /* special_function */
             "R_abs32",             /* name */
             FALSE,                 /* partial_inplace */
             0xffffffff,            /* src_mask */
             0xffffffff,            /* dst_mask */
             FALSE),                /* pcrel_offset */
     
  //Arithmetic relocations entries
  HOWTO(0xE0, 
        0,2,0,FALSE, 0, complain_overflow_dont, bfin_push_reloc, 
        "R_expst_push", FALSE, 0, 0, FALSE),
  HOWTO(0xE1, 
        0,2,0,FALSE, 0, complain_overflow_dont, bfin_const_reloc, 
        "R_expst_const", FALSE, 0, 0, FALSE),
  HOWTO(0xE2, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_add", FALSE, 0, 0, FALSE),
  HOWTO(0xE3, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_sub", FALSE, 0, 0, FALSE),
  HOWTO(0xE4, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_mult", FALSE, 0, 0, FALSE),
  HOWTO(0xE5, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_div", FALSE, 0, 0, FALSE),
  HOWTO(0xE6, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_mod", FALSE, 0, 0, FALSE),
  HOWTO(0xE7, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_lshift", FALSE, 0, 0, FALSE),
  HOWTO(0xE8, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_rshift", FALSE, 0, 0, FALSE),
  HOWTO(0xE9, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_and", FALSE, 0, 0, FALSE), 
  HOWTO(0xEA, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_or", FALSE, 0, 0, FALSE),
  HOWTO(0xEB, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_xor", FALSE, 0, 0, FALSE),
  HOWTO(0xEC, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_land", FALSE, 0, 0, FALSE),
  HOWTO(0xED, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_lor", FALSE, 0, 0, FALSE),
  HOWTO(0xEE, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_len", FALSE, 0, 0, FALSE),
  HOWTO(0xEF, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_neg", FALSE, 0, 0, FALSE),
  HOWTO(0xF0, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_ocomp", FALSE, 0, 0, FALSE),
  HOWTO(0xF1, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_page", FALSE, 0, 0, FALSE),
  HOWTO(0xF2, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_hwpage", FALSE, 0, 0, FALSE),
  HOWTO(0xF3, 
        0,0,0,FALSE, 0, complain_overflow_dont, bfin_oper_reloc, 
        "R_expst_addr", FALSE, 0, 0, FALSE), 

};


static const struct bfin_reloc_map {
  int bfd_reloc_val;
  int elf_reloc_val;
} bfin_reloc_map[] =
{
	{ BFD_RELOC_5_PCREL, R_pcrel5m2},
	{ BFD_RELOC_10_PCREL , R_pcrel10},
	{ BFD_RELOC_12_PCREL_JUMP, R_pcrel12_jump},
	{ BFD_RELOC_16_IMM , R_rimm16},
	{ BFD_RELOC_16_LOW , R_luimm16},
	{ BFD_RELOC_16_HIGH , R_huimm16},
	{ BFD_RELOC_12_PCREL_JUMP_S, R_pcrel12_jump_s},
	{ BFD_RELOC_24_PCREL_JUMP_X, R_pcrel24_jump_x},
	{ BFD_RELOC_24_PCREL , R_pcrel24},
	{ BFD_RELOC_24_PCREL_JUMP_L, R_pcrel24_jump_l},
	{ BFD_RELOC_24_PCREL_CALL_X, R_pcrel24_call_x},
	{ BFD_RELOC_8, R_byte_data},
	{ BFD_RELOC_16, R_byte2_data},
	{ BFD_RELOC_32, R_byte4_data},
	{ BFD_RELOC_11_PCREL, R_pcrel11},

	{ BFD_ARELOC_PUSH, R_push},
	{ BFD_ARELOC_CONST, R_const},
	{ BFD_ARELOC_ADD, R_add},
	{ BFD_ARELOC_SUB, R_sub},
	{ BFD_ARELOC_MULT, R_mult},
	{ BFD_ARELOC_DIV, R_div},
	{ BFD_ARELOC_MOD, R_mod},
	{ BFD_ARELOC_LSHIFT, R_lshift},
	{ BFD_ARELOC_RSHIFT, R_rshift},
	{ BFD_ARELOC_AND, R_and},
	{ BFD_ARELOC_OR, R_or},
	{ BFD_ARELOC_XOR, R_xor},
	{ BFD_ARELOC_LAND, R_land},
	{ BFD_ARELOC_LOR, R_lor},
	{ BFD_ARELOC_LEN, R_len},
	{ BFD_ARELOC_NEG, R_neg},
	{ BFD_ARELOC_COMP, R_comp},
	{ BFD_ARELOC_PAGE, R_page},
	{ BFD_ARELOC_HWPAGE, R_hwpage},
	{ BFD_ARELOC_ADDR, R_addr}
};


static reloc_howto_type *
bfd_elf32_bfd_reloc_type_lookup (bfd *abfd ATTRIBUTE_UNUSED,
     bfd_reloc_code_real_type code)
{
  int i;
  const int MAX = sizeof (bfin_reloc_map)/ sizeof (struct bfin_reloc_map);
  for (i = 0;
       i < MAX;
       i++)
    {
      if (bfin_reloc_map[i].bfd_reloc_val == (int)code){
	return &bfin_elf_howto_table[bfin_reloc_map[i].elf_reloc_val];
      }
    }

  return (reloc_howto_type *) NULL;
}

/* Set the howto pointer for an ELF reloc.  */

static void
bfd_info_to_howto_rel (bfd *abfd ATTRIBUTE_UNUSED,
     arelent *cache_ptr,
     Elf_Internal_Rela *dst)
{
  unsigned int r_type;
  r_type = ELF32_R_TYPE (dst->r_info);
  /* relocation numbers are now not in range.
   * FIXME : Change the entire approach to this code
   */
  if(r_type >= 0xe0 && r_type <= 0xf3)
	  r_type = r_type - 0xe0 + R_push;
  BFD_ASSERT (r_type < (unsigned int) R_max);
  cache_ptr->howto = &bfin_elf_howto_table[r_type];
}

/* Return whether a symbol name implies a local label.
 * The local symbol of bfin start with 'L$'
 */
static bfd_boolean
elf_bfin_is_local_label_name ( bfd *abfd,
     const char *name)
{
  if (name[0] == 'L' && name[1] == '$' )
    return TRUE;

  return _bfd_elf_is_local_label_name (abfd, name);
}

#define elf_info_to_howto		bfd_info_to_howto_rel
#define bfd_elf32_bfd_is_local_label_name \
                                        elf_bfin_is_local_label_name

#include "elf32-target.h"
