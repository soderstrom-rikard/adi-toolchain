/*
 * Copyright (c) 2001 by Arcturus Networks Inc. (www.arcturusnetworks.com),
 * Ported for Blackfin/Frio Architecture by S. Faisal Akber <fakber@arcturusnetworks.com>
 */


#define OBJECT_FORMAT_ELF

#define LOCAL_LABEL_PREFIX "L$"

#undef ASM_GENERATE_INTERNAL_LABEL
#define ASM_GENERATE_INTERNAL_LABEL(LABEL, PREFIX, NUM)		\
     sprintf (LABEL, "*%s%s$%d", LOCAL_LABEL_PREFIX, PREFIX, (int) NUM)

