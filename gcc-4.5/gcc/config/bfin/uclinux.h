/* Copyright (C) 2005, 2006, 2007 Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 3, or (at your option) any later
version.

GCC is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

#undef  STARTFILE_SPEC
#define STARTFILE_SPEC \
  "%{mshared-library-id=0|!mshared-library-id=*: crt1.o%s ;: Scrt1.o%s} \
     crti%O%s crtbegin%O%s crtlibid%O%s"

#undef LIB_SPEC
#define LIB_SPEC \
  "%{pthread:-lpthread} \
   %{mid-shared-library:%{!static-libc:-R libc.gdb%s}} -lc"

/* Default to using -elf2flt with no options.  */
#undef LINK_SPEC
#define LINK_SPEC \
  "%{!no-elf2flt:%{!elf2flt*:-elf2flt}} \
   %{mid-shared-library: \
     %{mshared-library-id=*:-shared-lib-id %*;:-shared-lib-id 0}}"

#define TARGET_OS_CPP_BUILTINS() LINUX_TARGET_OS_CPP_BUILTINS()

#undef LINK_GCC_C_SEQUENCE_SPEC
#define LINK_GCC_C_SEQUENCE_SPEC "\
  %{mfast-fp:-lbffastfp} %G %L %{mfast-fp:-lbffastfp} %G \
"

#define MD_UNWIND_SUPPORT "config/bfin/linux-unwind.h"

/* Like the definition in gcc.c, but for purposes of uClinux, every link is
   static.  */
#define MFWRAP_SPEC " %{fmudflap|fmudflapth: \
 --wrap=malloc --wrap=free --wrap=calloc --wrap=realloc\
 --wrap=mmap --wrap=munmap --wrap=alloca\
 %{fmudflapth: --wrap=pthread_create\
}} %{fmudflap|fmudflapth: --wrap=main}"

#undef TARGET_SUPPORTS_SYNC_CALLS
#define TARGET_SUPPORTS_SYNC_CALLS 1

#define SUBTARGET_FDPIC_NOT_SUPPORTED

#undef TARGET_ASM_FILE_END
#define TARGET_ASM_FILE_END file_end_indicate_exec_stack
