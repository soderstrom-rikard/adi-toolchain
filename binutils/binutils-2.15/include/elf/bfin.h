/* Blackfin ELF support for BFD.
   Copyright 2004 Free Software Foundation, Inc.

This file is part of BFD, the Binary File Descriptor library.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation, Inc.,
59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */

#ifndef _ELF_BFIN_H
#define _ELF_BFIN_H
			     
#include "elf/reloc-macros.h"

START_RELOC_NUMBERS (elf_bfin_reloc_type)
  RELOC_NUMBER (R_unused0, 0x00) /* relocation type 0 is not defined*/
  RELOC_NUMBER (R_pcrel5m2, 0x01) /*LSETUP part a*/
  RELOC_NUMBER (R_unused1, 0x02) /* relocation type 2 is not defined*/
  RELOC_NUMBER (R_pcrel10, 0x03) /* type 3, 0x00) if cc jump <target>  */
  RELOC_NUMBER (R_pcrel12_jump, 0x04) /* type 4, 0x00) jump <target> */
  RELOC_NUMBER (R_rimm16, 0x05)    /* type 0x5, 0x00) rN = <target> */
  RELOC_NUMBER (R_luimm16, 0x06)  /* # 0x6, 0x00) preg.l=<target> Load imm 16 to lower half */
  RELOC_NUMBER (R_huimm16, 0x07)  /* # 0x7, 0x00) preg.h=<target> Load imm 16 to upper half*/
  RELOC_NUMBER (R_pcrel12_jump_s, 0x08) /* # 0x8 jump.s <target> */
  RELOC_NUMBER (R_pcrel24_jump_x, 0x09) /* # 0x9 jump.x <target> */
  RELOC_NUMBER (R_pcrel24, 0x0a)        /* # 0xa call <target> , 0x00) not expandable*/
  RELOC_NUMBER (R_unusedb, 0x0b)         /* # 0xb not generated */
  RELOC_NUMBER (R_unusedc, 0x0c)       /* # 0xc  not used */
  RELOC_NUMBER (R_pcrel24_jump_l, 0x0d) /*0xd jump.l <target>*/
  RELOC_NUMBER (R_pcrel24_call_x, 0x0e) /* 0xE, 0x00) call.x <target> if <target> is above 24 bit limit call through P1 */
  RELOC_NUMBER (R_var_eq_symb, 0x0f)    /* 0xf, 0x00) linker should treat it same as 0x12 */
  RELOC_NUMBER (R_byte_data, 0x10)      /* 0x10, 0x00) .byte var = symbol */
  RELOC_NUMBER (R_byte2_data, 0x11)     /* 0x11, 0x00) .byte2 var = symbol */
  RELOC_NUMBER (R_byte4_data, 0x12)     /* 0x12, 0x00) .byte4 var = symbol and .var var=symbol */
  RELOC_NUMBER (R_pcrel11, 0x13)        /* 0x13, 0x00) lsetup part b */
  RELOC_NUMBER (R_pltpc, 0x14)            /* 0x14, PLT gnu only relocation */
  RELOC_NUMBER (R_got, 0x15)            /* 0x15, GOT gnu only relocation */
  RELOC_NUMBER (R_push, 0x16)
  RELOC_NUMBER (R_const, 0x17)
  RELOC_NUMBER (R_add, 0x18)
  RELOC_NUMBER (R_sub, 0x19)
  RELOC_NUMBER (R_mult, 0x1a)
  RELOC_NUMBER (R_div, 0x1b)
  RELOC_NUMBER (R_mod, 0x1c)
  RELOC_NUMBER (R_lshift, 0x1d)
  RELOC_NUMBER (R_rshift, 0x1e)
  RELOC_NUMBER (R_and, 0x1f)
  RELOC_NUMBER (R_or, 0x20)
  RELOC_NUMBER (R_xor, 0x21)
  RELOC_NUMBER (R_land, 0x22)
  RELOC_NUMBER (R_lor, 0x23)
  RELOC_NUMBER (R_len, 0x24)
  RELOC_NUMBER (R_neg, 0x25)
  RELOC_NUMBER (R_comp, 0x26)
  RELOC_NUMBER (R_page, 0x27)
  RELOC_NUMBER (R_hwpage, 0x28)
  RELOC_NUMBER (R_addr, 0x29)
  RELOC_NUMBER (R_max, 0x2a)
};

#endif
