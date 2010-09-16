#undef SUBTARGET_DRIVER_SELF_SPECS
#define SUBTARGET_DRIVER_SELF_SPECS \
  "-mlinux",

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

#define SUBTARGET_FDPIC_NOT_SUPPORTED

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

#undef TARGET_ASM_FILE_END
#define TARGET_ASM_FILE_END file_end_indicate_exec_stack
