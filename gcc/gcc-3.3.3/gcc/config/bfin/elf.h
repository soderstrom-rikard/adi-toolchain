/*
 * Copyright (c) 2001 by Arcturus Networks Inc. (www.arcturusnetworks.com),
 * Ported for Blackfin/Frio Architecture by S. Faisal Akber <fakber@arcturusnetworks.com>
 */


#define OBJECT_FORMAT_ELF

#ifndef CPP_PREDEFINES
#define CPP_PREDEFINES "-Dbfin -DBFIN -DFRIO -Dfrio -Acpu(bfin) -Amachine(bfin) -D__ELF__"
#endif

#define ASM_SPEC " %{I*} "
#define CC1_SPEC " -O0 "
#define LINK_SPEC " -N "
#define STARTFILE_SPEC " {crt0%O%s} "

