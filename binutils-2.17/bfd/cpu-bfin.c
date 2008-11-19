/* BFD Support for the ADI Blackfin processor.

   Copyright 2005 Free Software Foundation, Inc.

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
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1301,
   USA.  */

#include "bfd.h"
#include "sysdep.h"
#include "libbfd.h"

#define N(machine, print, default, next)			\
{								\
  16,			/* Bits in a word.  */			\
  32,			/* Bits in an address.  */		\
  8,			/* Bits in a byte.  */			\
  bfd_arch_bfin,						\
  machine,		/* Machine number.  */			\
  "bfin",		/* Arch name.  */			\
  print,		/* Arch printable name.  */		\
  4,			/* Section align power.  */		\
  default,		/* The one and only.  */		\
  bfd_default_compatible,					\
  bfd_default_scan,						\
  next,								\
}

static const bfd_arch_info_type arch_info_struct[] =
{
  N (bfd_mach_bf579, "bf579", FALSE, NULL),
};

const bfd_arch_info_type bfd_bfin_arch =
  N (bfd_mach_bf532, "bf532 compatible", TRUE, &arch_info_struct[0]);
