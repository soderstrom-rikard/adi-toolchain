/*
 * Copyright (c) 2001 by Arcturus Networks Inc. (www.arcturusnetworks.com),
 * Ported for Blackfin/Frio Architecture by S. Faisal Akber <fakber@arcturusnetworks.com>
 */


#define OBJECT_FORMAT_ELF

/* Run-time target specifications */
#ifndef TARGET_CPU_CPP_BUILTINS
#define TARGET_CPU_CPP_BUILTINS()               \
  do                                            \
    {                                           \
      builtin_define ("bfin");                  \
      builtin_define ("BFIN");                  \
      builtin_define ("FRIO");                  \
      builtin_define ("frio");                  \
      builtin_assert ("machine=bfin");          \
      builtin_assert ("cpu=bfin");              \
      builtin_define ("__ELF__");               \
    }                                           \
  while (0)
#endif


#define ASM_SPEC " %{I*} "
#define CC1_SPEC " -O0 "
#define LINK_SPEC " -N "
#define STARTFILE_SPEC " {crt0%O%s} "

