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

#define TARGET_LITTLE_SYM		bfd_elf32_little_nisa_vec
#define TARGET_LITTLE_NAME		"elf32-little-nisa"
#define ELF_ARCH			bfd_arch_nisa
#define ELF_MACHINE_CODE		EM_NONE
#define ELF_MAXPAGESIZE			0x1000

static bfd_boolean elf_nisa_is_local_label_name PARAMS ((bfd *, const char *));

enum reloc_type {
  R_pcrel4,
  R_pcrel8,
  R_pcrel8s4,
  R_pcrel10,
  R_pcrel12,
  R_rimm16,
  R_huimm16,
  R_luimm16,
  R_lppcrel10,
  R_pcrel24,

  R_abs16,
  R_abs32,
  R_max
};


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


bfd_reloc_status_type
nisa_pcrel24_reloc (
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

  flag = bfd_elf_generic_reloc (abfd, reloc_entry, 
			       symbol, data, input_section,
				     output_bfd, error_message);
  if (flag    != bfd_reloc_continue) {
      return flag;
  }

 if (bfd_is_und_section (symbol->section)
      && (symbol->flags & BSF_WEAK) == 0
      && output_bfd == (bfd *) NULL)
	      return bfd_reloc_continue;

  if (flag == bfd_reloc_continue) {

      /* Is the address of the relocation really within the section?  */
      if (reloc_entry->address > input_section->_cooked_size)
	      return bfd_reloc_outofrange;

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
      
      relocation += output_base + symbol->section->output_offset;
      
      /* Add in supplied addend.  */
      relocation += reloc_entry->addend;
      
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
      
      relocation >>= (bfd_vma) howto->rightshift;
/*      relocation -= 1;  */
      /* Shift everything up to where it's going to be used */

      relocation <<= (bfd_vma) howto->bitpos;
      {
         short x;
         x = bfd_get_16 (abfd, (bfd_byte *) data + addr);
         x = (x&0xff00) | ((relocation>>16)&0xff);
 	 bfd_put_16 (abfd, x, (unsigned char *) data + addr);
         x = bfd_get_16 (abfd, (bfd_byte *) data + addr +2);
         x = relocation&0xFFFF;
 	 bfd_put_16 (abfd, x, (unsigned char *) data + addr +2);
      }
      return bfd_reloc_ok;
  }
   return flag; 
}

bfd_reloc_status_type
nisa_h_l_uimm16_reloc (
     bfd *abfd,
     arelent *reloc_entry,
     asymbol *symbol,
     PTR data,
     asection *input_section,
     bfd *output_bfd,
     char **error_message) 
{
  bfd_vma relocation, x;
  bfd_reloc_status_type flag = bfd_reloc_ok;
  bfd_size_type addr = reloc_entry->address;
  bfd_vma output_base = 0;
  reloc_howto_type *howto = reloc_entry->howto;
  asection *reloc_target_output_section;

  if ( bfd_elf_generic_reloc (abfd, reloc_entry,
		  symbol, data, input_section, 
		  output_bfd, error_message) == bfd_reloc_continue)
  {

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

      if (!strcmp(symbol->name, symbol->section->name) || output_bfd == NULL)
      	relocation += output_base + symbol->section->output_offset;

      /* Add in supplied addend.  */
      relocation += reloc_entry->addend;
      
      if (output_bfd != (bfd *) NULL)
      {	              
	      reloc_entry->address += input_section->output_offset;
	      reloc_entry->addend = relocation;
      }
      else
      {
	      reloc_entry->addend = 0;
      }

      /* Here the variable relocation holds the final address of the
	 symbol we are relocating against, plus any addend.  */

      x = bfd_get_16 (abfd, (bfd_byte *) data + addr);
      relocation >>= (bfd_vma) howto->rightshift;
      x = relocation;
      bfd_put_16 (abfd, x, (unsigned char *) data + addr);
    }

    return bfd_reloc_ok;
}



static reloc_howto_type nisa_elf_howto_table[] =
{
  /* R4  */
  HOWTO (R_pcrel4,		/* type */
	 1,		/* rightshift */
	 1,			/* size (0 = byte, 1 = short, 2 = long) */
	 4,		/* bitsize */
	 TRUE,		/* pc_relative */
	 0,		/* bitpos */
	 complain_overflow_unsigned,             /* complain_on_overflow */
	 bfd_elf_generic_reloc,           /* special_function */
	 "R_pcrel4",		/* name */
	 TRUE,      /* partial_inplace */
	 0x0000000F,		/* src_mask */
	 0x0000000F,		/* dst_mask */
	 TRUE),		/* pcrel_offset */
  /* R8  */
  HOWTO (R_pcrel8,		/* type */
	 1,		/* rightshift */
	 1,			/* size (0 = byte, 1 = short, 2 = long) */
	 8,		/* bitsize */
	 TRUE,		/* pc_relative */
	 0,		/* bitpos */
	 complain_overflow_unsigned,             /* complain_on_overflow */
	 bfd_elf_generic_reloc,           /* special_function */
	 "R_pcrel8",		/* name */
	 TRUE,      /* partial_inplace */
	 0x000000FF,		/* src_mask */
	 0x000000FF,		/* dst_mask */
	 TRUE),		/* pcrel_offset */
  /* Rx8  */
  HOWTO (R_pcrel8s4,		/* type */
	 2,		/* rightshift */
	 1,			/* size (0 = byte, 1 = short, 2 = long) */
	 8,		/* bitsize */
	 TRUE,		/* pc_relative */
	 0,		/* bitpos */
	 complain_overflow_signed,             /* complain_on_overflow */
	 bfd_elf_generic_reloc,           /* special_function */
	 "R_pcrel8s4",		/* name */
	 TRUE,      /* partial_inplace */
	 0x000000FF,		/* src_mask */
	 0x000000FF,		/* dst_mask */
	 TRUE),		/* pcrel_offset */
  /* R10  */
  HOWTO (R_pcrel10,		/* type */
	 1,		/* rightshift */
	 1,			/* size (0 = byte, 1 = short, 2 = long) */
	 10,		/* bitsize */
	 TRUE,		/* pc_relative */
	 0,		/* bitpos */
	 complain_overflow_signed,             /* complain_on_overflow */
	 bfd_elf_generic_reloc,           /* special_function */
	 "R_pcrel10",		/* name */
	 TRUE,      /* partial_inplace */
	 0x000003FF,		/* src_mask */
	 0x000003FF,		/* dst_mask */
	 TRUE),		/* pcrel_offset */
  /* R12  */
  HOWTO (R_pcrel12,		/* type */
	 1,		/* rightshift */
	 1,			/* size (0 = byte, 1 = short, 2 = long) */
	 12,		/* bitsize */
	 TRUE,		/* pc_relative */
	 0,		/* bitpos */
	 complain_overflow_signed,             /* complain_on_overflow */
	 bfd_elf_generic_reloc,           /* special_function */
	 "R_pcrel12",		/* name */
	 TRUE,      /* partial_inplace */
	 0x00000FFF,		/* src_mask */
	 0x00000FFF,		/* dst_mask */
	 TRUE),		/* pcrel_offset */
  /* R16  */
  HOWTO (R_rimm16,		/* type */
	 0,		/* rightshift */
	 1,			/* size (0 = byte, 1 = short, 2 = long) */
	 16,		/* bitsize */
	 FALSE,		/* pc_relative */
	 0,		/* bitpos */
	 complain_overflow_signed,             /* complain_on_overflow */
	 bfd_elf_generic_reloc,           /* special_function */
	 "R_rimm16",		/* name */
	 TRUE,      /* partial_inplace */
	 0x0000FFFF,		/* src_mask */
	 0x0000FFFF,		/* dst_mask */
	 TRUE),		/* pcrel_offset */
  /* RH16  */
  HOWTO (R_huimm16,		/* type */
	 16,		/* rightshift */
	 1,			/* size (0 = byte, 1 = short, 2 = long) */
	 16,		/* bitsize */
	 FALSE,		/* pc_relative */
	 0,		/* bitpos */
	 complain_overflow_unsigned,             /* complain_on_overflow */
	 nisa_h_l_uimm16_reloc,		/* special_function */
	 "R_huimm16",		/* name */
	 TRUE,      /* partial_inplace */
	 0x0000FFFF,		/* src_mask */
	 0x0000FFFF,		/* dst_mask */
	 TRUE),		/* pcrel_offset */
  /* RL16  */
  HOWTO (R_luimm16,		/* type */
	 0,		/* rightshift */
	 1,			/* size (0 = byte, 1 = short, 2 = long) */
	 16,		/* bitsize */
	 FALSE,		/* pc_relative */
	 0,		/* bitpos */
	 complain_overflow_dont,             /* complain_on_overflow */
	 nisa_h_l_uimm16_reloc,		/* special_function */
	 "R_luimm16",		/* name */
	 TRUE,      /* partial_inplace */
	 0x0000FFFF,		/* src_mask */
	 0x0000FFFF,		/* dst_mask */
	 TRUE),		/* pcrel_offset */
  /* Rlp10  */
  HOWTO (R_lppcrel10,		/* type */
	 1,		/* rightshift */
	 1,			/* size (0 = byte, 1 = short, 2 = long) */
	 10,		/* bitsize */
	 TRUE,		/* pc_relative */
	 0,		/* bitpos */
	 complain_overflow_unsigned,             /* complain_on_overflow */
	 bfd_elf_generic_reloc,           /* special_function */
	 "R_lppcrel10",		/* name */
	 TRUE,      /* partial_inplace */
	 0x000003FF,		/* src_mask */
	 0x000003FF,		/* dst_mask */
	 TRUE),		/* pcrel_offset */
  /* Rrm8,Rrl16  */
  HOWTO (R_pcrel24,		/* type */
	 1,		/* rightshift */
	 2,			/* size (0 = byte, 1 = short, 2 = long) */
	 24,		/* bitsize */
	 TRUE,		/* pc_relative */
	 0,		/* bitpos */
	 complain_overflow_signed,             /* complain_on_overflow */
	 /*bfd_elf_generic_reloc, */ /*         special_function */
       	 nisa_pcrel24_reloc,            /* special_function */
	 "R_pcrel24",		/* name */
	 TRUE,      /* partial_inplace */
	 0x00FFFFFF,		/* src_mask */
	 0x00FFFFFF,		/* dst_mask */
	 TRUE),		/* pcrel_offset */


  /* A standard 32 bit relocation.  */
  HOWTO (R_abs16,		/* type */
	 0,	                /* rightshift */
	 2,	                /* size (0 = byte, 1 = short, 2 = long) */
	 16,	                /* bitsize */
	 FALSE,	                /* pc_relative */
	 0,	                /* bitpos */
	 complain_overflow_bitfield, /* complain_on_overflow */
	 bfd_elf_generic_reloc, /* special_function */
	 "R_abs16",		/* name */
	 FALSE,	                /* partial_inplace */
	 0x0000ffff,	        /* src_mask */
	 0x0000ffff,   		/* dst_mask */
	 FALSE),                /* pcrel_offset */

  /* A standard 32 bit relocation.  */
  HOWTO (R_abs32,		/* type */
	 0,	                /* rightshift */
	 2,	                /* size (0 = byte, 1 = short, 2 = long) */
	 32,	                /* bitsize */
	 FALSE,	                /* pc_relative */
	 0,	                /* bitpos */
	 complain_overflow_bitfield, /* complain_on_overflow */
	 bfd_elf_generic_reloc, /* special_function */
	 "R_abs32",		/* name */
	 FALSE,	                /* partial_inplace */
	 0xffffffff,	        /* src_mask */
	 0xffffffff,   		/* dst_mask */
	 FALSE),                /* pcrel_offset */


};


static const struct nisa_reloc_map 
{
  unsigned char bfd_reloc_val;
  unsigned char elf_reloc_val;
} nisa_reloc_map[] =
{
    { BFD_RELOC_4_PCREL , R_pcrel4},
    { BFD_RELOC_8_PCREL , R_pcrel8},
    { BFD_RELOC_8_PCREL , R_pcrel8s4},
    { BFD_RELOC_10_PCREL , R_pcrel10},
    { BFD_RELOC_12_PCREL , R_pcrel12},
    { BFD_RELOC_16 , R_rimm16},
    { BFD_RELOC_16_HIGH , R_huimm16},
    { BFD_RELOC_16_LOW , R_luimm16},
    { BFD_RELOC_10_LPPCREL , R_lppcrel10},
    { BFD_RELOC_24_PCREL , R_pcrel24},

    { BFD_RELOC_16, R_abs16 },
    { BFD_RELOC_32, R_abs32 },
};

static reloc_howto_type *
bfd_elf32_bfd_reloc_type_lookup (bfd *abfd,
     bfd_reloc_code_real_type code)
{
  unsigned int i;

  for (i = 0;
       i < sizeof (nisa_reloc_map) / sizeof (struct nisa_reloc_map);
       i++)
    {
      if (nisa_reloc_map[i].bfd_reloc_val == code)
	return &nisa_elf_howto_table[nisa_reloc_map[i].elf_reloc_val];
    }

  return (reloc_howto_type *) NULL;
}

/* Set the howto pointer for an ELF reloc.  */

static void
bfd_info_to_howto_rel (bfd *abfd,
     arelent *cache_ptr,
     Elf_Internal_Rela *dst)
{
  unsigned int r_type;

  r_type = ELF32_R_TYPE (dst->r_info);
  BFD_ASSERT (r_type < (unsigned int) R_max);
  cache_ptr->howto = &nisa_elf_howto_table[r_type];
}

/* Return whether a symbol name implies a local label.
 * The local symbol of nisa start with 'L$'
 */
static bfd_boolean
elf_nisa_is_local_label_name ( bfd *abfd,
     const char *name)
{
  if (name[0] == 'L' && name[1] == '$' )
    return TRUE;

  return _bfd_elf_is_local_label_name (abfd, name);
}

#define elf_info_to_howto		bfd_info_to_howto_rel
#define bfd_elf32_bfd_is_local_label_name \
                                        elf_nisa_is_local_label_name

#include "elf32-target.h"
