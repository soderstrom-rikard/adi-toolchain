#undef  STARTFILE_SPEC
#define STARTFILE_SPEC \
  "%{!shared: %{pie:Scrt1%O%s;:crt1%O%s}} crti%O%s crtbegin%O%s crtlibid%O%s"

#define TARGET_OS_CPP_BUILTINS() LINUX_TARGET_OS_CPP_BUILTINS()

#define SUBTARGET_FDPIC_NOT_SUPPORTED

#define MD_UNWIND_SUPPORT "config/bfin/linux-unwind.h"
