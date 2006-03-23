/*
 * Copyright (c) 2005 by Analog Devices, Inc. All Rights Reserved.
 */

#undef  STARTFILE_SPEC
#define STARTFILE_SPEC \
  "%{!shared: crt1%O%s} crti%O%s crtbegin%O%s crtlibid%O%s"

#undef  ENDFILE_SPEC
#define ENDFILE_SPEC \
  "crtend%O%s crtn%O%s"

#undef  LIB_SPEC
#define LIB_SPEC "%{pthread:-lpthread} -lc"

#ifdef __BFIN_FDPIC__
#define CRT_CALL_STATIC_FUNCTION(SECTION_OP, FUNC)	\
asm (SECTION_OP); \
asm ("P3 = [SP + 20];\n\tcall " USER_LABEL_PREFIX #FUNC ";"); \
asm (TEXT_SECTION_ASM_OP);
#endif

#define NO_IMPLICIT_EXTERN_C
