/*
 * Copyright (c) 2005 by Analog Devices, Inc. All Rights Reserved.
 */

/* The GNU C++ standard library requires that these macros be defined.  */
#undef  STARTFILE_SPEC
#define STARTFILE_SPEC \
  "%{!shared: %{pie:Scrt1%O%s;:crt1%O%s}} crti%O%s crtbegin%O%s crtlibid%O%s"

#define TARGET_OS_CPP_BUILTINS() LINUX_TARGET_OS_CPP_BUILTINS()

#undef LINK_GCC_C_SEQUENCE_SPEC
#define LINK_GCC_C_SEQUENCE_SPEC "\
  %{mfast-fp:-lbffastfp} %G %L %{mfast-fp:-lbffastfp} %G \
"

#define SUBTARGET_FDPIC_NOT_SUPPORTED
