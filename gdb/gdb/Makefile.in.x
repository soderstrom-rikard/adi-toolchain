# Copyright 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998,
# 1999, 2000, 2001, 2002, 2003 Free Software Foundation, Inc.

# This file is part of GDB.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

prefix = @prefix@
exec_prefix = @exec_prefix@

host_alias = @host_alias@
target_alias = @target_alias@
program_transform_name = @program_transform_name@
bindir = @bindir@
libdir = @libdir@
tooldir = $(libdir)/$(target_alias)

datadir = @datadir@
mandir = @mandir@
man1dir = $(mandir)/man1
man2dir = $(mandir)/man2
man3dir = $(mandir)/man3
man4dir = $(mandir)/man4
man5dir = $(mandir)/man5
man6dir = $(mandir)/man6
man7dir = $(mandir)/man7
man8dir = $(mandir)/man8
man9dir = $(mandir)/man9
infodir = @infodir@
htmldir = $(prefix)/html
includedir = @includedir@

# This can be referenced by `INTLDEPS' as computed by CY_GNU_GETTEXT.
top_builddir = .

SHELL = @SHELL@
EXEEXT = @EXEEXT@

AWK = @AWK@
LN_S = @LN_S@

INSTALL = @INSTALL@
INSTALL_PROGRAM = @INSTALL_PROGRAM@
INSTALL_DATA = @INSTALL_DATA@

DESTDIR =

AR = @AR@
AR_FLAGS = qv
RANLIB = @RANLIB@
DLLTOOL = @DLLTOOL@
WINDRES = @WINDRES@
MIG = @MIG@

# If you are compiling with GCC, make sure that either 1) You have the
# fixed include files where GCC can reach them, or 2) You use the
# -traditional flag.  Otherwise the ioctl calls in inflow.c
# will be incorrectly compiled.  The "fixincludes" script in the gcc
# distribution will fix your include files up.
CC=@CC@

# Directory containing source files.
srcdir = @srcdir@
VPATH = @srcdir@

YACC=@YACC@

# This is used to rebuild ada-lex.c from ada-lex.l.  If the program is 
# not defined, but ada-lex.c is present, compilation will continue,
# possibly with a warning.
FLEX = flex

YLWRAP = $(srcdir)/../ylwrap

# where to find makeinfo, preferably one designed for texinfo-2
MAKEINFO=makeinfo

MAKEHTML = texi2html

MAKEHTMLFLAGS = -glossary -menu -split_chapter

# Set this up with gcc if you have gnu ld and the loader will print out
# line numbers for undefined references.
#CC_LD=gcc -static
CC_LD=$(CC)

# Where is our "include" directory?  Typically $(srcdir)/../include.
# This is essentially the header file directory for the library
# routines in libiberty.
INCLUDE_DIR =  $(srcdir)/../include
INCLUDE_CFLAGS = -I$(INCLUDE_DIR)

# Where is the "-liberty" library?  Typically in ../libiberty.
LIBIBERTY = ../libiberty/libiberty.a

# Configured by the --with-mmalloc option to configure.
MMALLOC = @MMALLOC@
MMALLOC_CFLAGS = @MMALLOC_CFLAGS@

# Where is the BFD library?  Typically in ../bfd.
BFD_DIR = ../bfd
BFD = $(BFD_DIR)/libbfd.a
BFD_SRC = $(srcdir)/$(BFD_DIR)
BFD_CFLAGS = -I$(BFD_DIR) -I$(BFD_SRC)

# Where is the READLINE library?  Typically in ../readline.
READLINE_DIR = ../readline
READLINE = $(READLINE_DIR)/libreadline.a
READLINE_SRC = $(srcdir)/$(READLINE_DIR)
READLINE_CFLAGS = -I$(READLINE_SRC)/..

WARN_CFLAGS = @WARN_CFLAGS@
WERROR_CFLAGS = @WERROR_CFLAGS@
GDB_WARN_CFLAGS = $(WARN_CFLAGS)
GDB_WERROR_CFLAGS = $(WERROR_CFLAGS)

# Where is the INTL library?  Typically in ../intl.
INTL_DIR = ../intl
INTL = @INTLLIBS@
INTL_DEPS = @INTLDEPS@
INTL_SRC = $(srcdir)/$(INTL_DIR)
INTL_CFLAGS = -I$(INTL_DIR) -I$(INTL_SRC)

# Where is the ICONV library?  This can be empty if libc has iconv.
LIBICONV = @LIBICONV@

# Did the user give us a --with-sysroot option?
TARGET_SYSTEM_ROOT = @TARGET_SYSTEM_ROOT@
TARGET_SYSTEM_ROOT_DEFINE = @TARGET_SYSTEM_ROOT_DEFINE@

#
# CLI sub directory definitons
#
SUBDIR_CLI_OBS = \
	cli-dump.o \
	cli-decode.o cli-script.o cli-cmds.o cli-setshow.o cli-utils.o \
	cli-logging.o \
	cli-interp.o
SUBDIR_CLI_SRCS = \
	cli/cli-dump.c \
	cli/cli-decode.c cli/cli-script.c cli/cli-cmds.c cli/cli-setshow.c \
	cli/cli-logging.c \
	cli/cli-interp.c \
	cli/cli-utils.c
SUBDIR_CLI_DEPS =
SUBDIR_CLI_INITS = \
	$(SUBDIR_CLI_SRCS)
SUBDIR_CLI_LDFLAGS=
SUBDIR_CLI_CFLAGS=
SUBDIR_CLI_ALL=
SUBDIR_CLI_CLEAN=
SUBDIR_CLI_INSTALL=
SUBDIR_CLI_UNINSTALL=

#
# MI sub directory definitons
#
SUBDIR_MI_OBS = \
	mi-out.o mi-console.o \
	mi-cmds.o mi-cmd-env.o mi-cmd-var.o mi-cmd-break.o mi-cmd-stack.o \
	mi-cmd-file.o mi-cmd-disas.o mi-symbol-cmds.o \
	mi-interp.o \
	mi-main.o mi-parse.o mi-getopt.o
SUBDIR_MI_SRCS = \
	mi/mi-out.c mi/mi-console.c \
	mi/mi-cmds.c mi/mi-cmd-env.c \
	mi/mi-cmd-var.c mi/mi-cmd-break.c mi/mi-cmd-stack.c \
	mi/mi-cmd-file.c mi/mi-cmd-disas.c mi/mi-symbol-cmds.c \
	mi/mi-interp.c \
	mi/mi-main.c mi/mi-parse.c mi/mi-getopt.c
SUBDIR_MI_DEPS =
SUBDIR_MI_INITS = \
	$(SUBDIR_MI_SRCS)
SUBDIR_MI_LDFLAGS=
SUBDIR_MI_CFLAGS= \
	-DMI_OUT=1
SUBDIR_MI_ALL=
SUBDIR_MI_CLEAN=
SUBDIR_MI_INSTALL=
SUBDIR_MI_UNINSTALL=

#
# TUI sub directory definitions
#
SUBDIR_TUI_OBS = \
	tui-file.o tui.o tuiData.o tuiSource.o tuiStack.o tuiIO.o \
	tui-interp.o \
	tuiGeneralWin.o tuiLayout.o tuiWin.o tuiCommand.o \
	tuiDisassem.o tuiSourceWin.o tuiRegs.o tuiDataWin.o \
	tui-out.o tui-hooks.o
SUBDIR_TUI_SRCS = \
	tui/tui-file.c tui/tui.c tui/tuiData.c tui/tuiSource.c \
	tui/tui-interp.c \
	tui/tuiStack.c tui/tuiIO.c \
	tui/tuiGeneralWin.c tui/tuiLayout.c \
	tui/tuiWin.c tui/tuiCommand.c \
	tui/tuiDisassem.c tui/tuiSourceWin.c \
	tui/tuiRegs.c tui/tuiDataWin.c tui/tui-out.c tui/tui-hooks.c
SUBDIR_TUI_DEPS =
SUBDIR_TUI_INITS = \
	$(SUBDIR_TUI_SRCS)
SUBDIR_TUI_LDFLAGS=
SUBDIR_TUI_CFLAGS= \
	-DTUI=1 -I${srcdir}/tui
SUBDIR_TUI_ALL=
SUBDIR_TUI_CLEAN=
SUBDIR_TUI_INSTALL=
SUBDIR_TUI_UNINSTALL=



# Opcodes currently live in one of two places.  Either they are in the
# opcode library, typically ../opcodes, or they are in a header file
# in INCLUDE_DIR.
# Where is the "-lopcodes" library, with (some of) the opcode tables and
# disassemblers?
OPCODES_DIR = ../opcodes
OPCODES_SRC = $(srcdir)/$(OPCODES_DIR)
OPCODES = $(OPCODES_DIR)/libopcodes.a
# Where are the other opcode tables which only have header file
# versions?
OP_INCLUDE = $(INCLUDE_DIR)/opcode
OPCODES_CFLAGS = -I$(OP_INCLUDE)

# The simulator is usually nonexistent; targets that include one
# should set this to list all the .o or .a files to be linked in.
SIM =

WIN32LIBS = @WIN32LIBS@

# Where is the TCL library?  Typically in ../tcl.
LIB_INSTALL_DIR = $(libdir)
# This variable is needed when doing dynamic linking.
LIB_RUNTIME_DIR = $(libdir)
TCL = @TCL_CC_SEARCH_FLAGS@ @TCL_BUILD_LIB_SPEC@
TCL_CFLAGS = @TCLHDIR@
GDBTKLIBS = @GDBTKLIBS@
# Extra flags that the GDBTK files need:
GDBTK_CFLAGS = @GDBTK_CFLAGS@

# Where is the TK library?  Typically in ../tk.
TK = @TK_BUILD_LIB_SPEC@
TK_CFLAGS = @TKHDIR@ @TK_BUILD_INCLUDES@

# Where is Itcl?  Typically in ../itcl/itcl.
ITCL_CFLAGS = @ITCLHDIR@
ITCL = @ITCLLIB@

# Where is Itk?  Typically in ../itcl/itk.
ITK_CFLAGS = @ITKHDIR@
ITK = @ITKLIB@

X11_CFLAGS = @TK_XINCLUDES@
X11_LDFLAGS =
X11_LIBS =

WIN32LDAPP = @WIN32LDAPP@

LIBGUI = @LIBGUI@
GUI_CFLAGS_X = @GUI_CFLAGS_X@
IDE_CFLAGS=$(GUI_CFLAGS_X) $(IDE_CFLAGS_X)

# The version of gdbtk we're building. This should be kept
# in sync with GDBTK_VERSION and friends in gdbtk.h.
GDBTK_VERSION = 1.0
GDBTK_LIBRARY = $(datadir)/insight$(GDBTK_VERSION)

# Gdbtk requires an absolute path to the source directory or
# the testsuite won't run properly.
GDBTK_SRC_DIR = @GDBTK_SRC_DIR@

SUBDIR_GDBTK_OBS = \
	gdbtk.o gdbtk-bp.o gdbtk-cmds.o gdbtk-hooks.o gdbtk-interp.o \
	gdbtk-register.o gdbtk-stack.o gdbtk-varobj.o gdbtk-wrapper.o
SUBDIR_GDBTK_SRCS = \
	gdbtk/generic/gdbtk.c gdbtk/generic/gdbtk-bp.c \
	gdbtk/generic/gdbtk-cmds.c gdbtk/generic/gdbtk-hooks.c gdbtk-interp.c \
	gdbtk/generic/gdbtk-register.c gdbtk/generic/gdbtk-stack.c \
	gdbtk/generic/gdbtk-varobj.c gdbtk/generic/gdbtk-wrapper.c \
	gdbtk/generic/gdbtk-main.c
SUBDIR_GDBTK_DEPS = \
	$(LIBGUI) $(ITCL_DEPS) $(ITK_DEPS) $(TK_DEPS) $(TCL_DEPS)
SUBDIR_GDBTK_INITS = gdbtk/generic/gdbtk.c gdbtk/generic/gdbtk-interp.c
SUBDIR_GDBTK_LDFLAGS=
SUBDIR_GDBTK_CFLAGS= -DGDBTK
SUBDIR_GDBTK_ALL= all-gdbtk
SUBDIR_GDBTK_CLEAN= clean-gdbtk
SUBDIR_GDBTK_INSTALL= install-gdbtk
SUBDIR_GDBTK_UNINSTALL= uninstall-gdbtk

CONFIG_OBS= @CONFIG_OBS@
CONFIG_LIB_OBS= @CONFIG_LIB_OBS@
CONFIG_SRCS= @CONFIG_SRCS@
CONFIG_DEPS= @CONFIG_DEPS@
CONFIG_INITS= @CONFIG_INITS@
CONFIG_LDFLAGS = @CONFIG_LDFLAGS@
ENABLE_CFLAGS= @ENABLE_CFLAGS@
CONFIG_ALL= @CONFIG_ALL@
CONFIG_CLEAN= @CONFIG_CLEAN@
CONFIG_CLEAN= @CONFIG_CLEAN@
CONFIG_INSTALL = @CONFIG_INSTALL@
CONFIG_UNINSTALL = @CONFIG_UNINSTALL@

# -I. for config files.
# -I$(srcdir) for gdb internal headers.
# -I$(srcdir)/config for more generic config files.

# It is also possible that you will need to add -I/usr/include/sys if
# your system doesn't have fcntl.h in /usr/include (which is where it
# should be according to Posix).
DEFS = @DEFS@
GDB_CFLAGS = -I. -I$(srcdir) -I$(srcdir)/config -DLOCALEDIR="\"$(prefix)/share/locale\"" $(DEFS)

# M{H,T}_CFLAGS, if defined, have host- and target-dependent CFLAGS
# from the config directory.
GLOBAL_CFLAGS = $(MT_CFLAGS) $(MH_CFLAGS)

PROFILE_CFLAGS = @PROFILE_CFLAGS@

# CFLAGS is specifically reserved for setting from the command line
# when running make.  I.E.  "make CFLAGS=-Wmissing-prototypes".
CFLAGS = @CFLAGS@

# Need to pass this to testsuite for "make check".  Probably should be
# consistent with top-level Makefile.in and gdb/testsuite/Makefile.in
# so "make check" has the same result no matter where it is run.
CXXFLAGS = -g -O

# INTERNAL_CFLAGS is the aggregate of all other *CFLAGS macros.
INTERNAL_WARN_CFLAGS = \
	$(CFLAGS) $(GLOBAL_CFLAGS) $(PROFILE_CFLAGS) \
	$(GDB_CFLAGS) $(OPCODES_CFLAGS) $(READLINE_CFLAGS) \
	$(BFD_CFLAGS) $(MMALLOC_CFLAGS) $(INCLUDE_CFLAGS) \
	$(INTL_CFLAGS) $(ENABLE_CFLAGS) \
	$(GDB_WARN_CFLAGS)
INTERNAL_CFLAGS = $(INTERNAL_WARN_CFLAGS) $(GDB_WERROR_CFLAGS)

# LDFLAGS is specifically reserved for setting from the command line
# when running make.
LDFLAGS = @LDFLAGS@

# Profiling options need to go here to work.
# I think it's perfectly reasonable for a user to set -pg in CFLAGS
# and have it work; that's why CFLAGS is here.
# PROFILE_CFLAGS is _not_ included, however, because we use monstartup.
INTERNAL_LDFLAGS = $(CFLAGS) $(GLOBAL_CFLAGS) $(MH_LDFLAGS) $(LDFLAGS) $(CONFIG_LDFLAGS)

# If your system is missing alloca(), or, more likely, it's there but
# it doesn't work, then refer to libiberty.

# Libraries and corresponding dependencies for compiling gdb.
# {X,T}M_CLIBS, defined in *config files, have host- and target-dependent libs.
# MMALLOC comes after anything else that might want an allocation function.
# LIBIBERTY appears twice on purpose.
# If you have the Cygnus libraries installed,
# you can use 'CLIBS=$(INSTALLED_LIBS)' 'CDEPS='
INSTALLED_LIBS=-lbfd -lreadline -lopcodes -liberty \
	$(XM_CLIBS) $(TM_CLIBS) $(NAT_CLIBS) $(GDBTKLIBS) @LIBS@ \
	-lmmalloc -lintl -liberty
CLIBS = $(SIM) $(BFD) $(READLINE) $(OPCODES) $(INTL) $(LIBIBERTY) \
	$(XM_CLIBS) $(TM_CLIBS) $(NAT_CLIBS) $(GDBTKLIBS) @LIBS@ \
	$(LIBICONV) \
	$(MMALLOC) $(LIBIBERTY) $(WIN32LIBS)
CDEPS = $(XM_CDEPS) $(TM_CDEPS) $(NAT_CDEPS) $(SIM) $(BFD) $(READLINE) \
	$(OPCODES) $(MMALLOC) $(INTL_DEPS) $(LIBIBERTY) $(CONFIG_DEPS)

ADD_FILES = $(XM_ADD_FILES) $(TM_ADD_FILES) $(NAT_ADD_FILES)
ADD_DEPS = $(XM_ADD_FILES) $(TM_ADD_FILES) $(NAT_ADD_FILES)

DIST=gdb

LINT=/usr/5bin/lint
LINTFLAGS= $(GDB_CFLAGS) $(OPCODES_CFLAGS) $(READLINE_CFLAGS) \
	$(BFD_CFLAGS) $(MMALLOC_CFLAGS) $(INCLUDE_CFLAGS) \
	$(INTL_CFLAGS)

RUNTEST = `if [ -f $${rootsrc}/../dejagnu/runtest ] ; then \
		echo $${rootsrc}/../dejagnu/runtest ; else echo runtest; \
	   fi`

RUNTESTFLAGS=

# This is ser-unix.o for any system which supports a v7/BSD/SYSV/POSIX
# interface to the serial port.  Hopefully if get ported to OS/2, VMS,
# etc., then there will be (as part of the C library or perhaps as
# part of libiberty) a POSIX interface.  But at least for now the
# host-dependent makefile fragment might need to use something else
# besides ser-unix.o
SER_HARDWIRE = @SER_HARDWIRE@

# The `remote' debugging target is supported for most architectures,
# but not all (e.g. 960)
REMOTE_OBS = remote.o dcache.o remote-utils.o tracepoint.o ax-general.o ax-gdb.o remote-fileio.o

# This is remote-sim.o if a simulator is to be linked in.
SIM_OBS =

ANNOTATE_OBS = annotate.o

# Host and target-dependent makefile fragments come in here.
@host_makefile_frag@
@target_makefile_frag@
# End of host and target-dependent makefile fragments

# Possibly ignore the simulator.  If the simulator is being ignored, 
# these expand into SIM= and SIM_OBJ=, overriding the entries from 
# target_makefile_frag
#
@IGNORE_SIM@
@IGNORE_SIM_OBS@

FLAGS_TO_PASS = \
	"prefix=$(prefix)" \
	"exec_prefix=$(exec_prefix)" \
	"infodir=$(infodir)" \
	"libdir=$(libdir)" \
	"mandir=$(mandir)" \
	"datadir=$(datadir)" \
	"includedir=$(includedir)" \
	"against=$(against)" \
	"DESTDIR=$(DESTDIR)" \
	"AR=$(AR)" \
	"AR_FLAGS=$(AR_FLAGS)" \
	"CC=$(CC)" \
	"CFLAGS=$(CFLAGS)" \
	"CXX=$(CXX)" \
	"CXXFLAGS=$(CXXFLAGS)" \
	"DLLTOOL=$(DLLTOOL)" \
	"LDFLAGS=$(LDFLAGS)" \
	"RANLIB=$(RANLIB)" \
	"MAKEINFO=$(MAKEINFO)" \
	"MAKEHTML=$(MAKEHTML)" \
	"MAKEHTMLFLAGS=$(MAKEHTMLFLAGS)" \
	"INSTALL=$(INSTALL)" \
	"INSTALL_PROGRAM=$(INSTALL_PROGRAM)" \
	"INSTALL_DATA=$(INSTALL_DATA)" \
	"RUNTEST=$(RUNTEST)" \
	"RUNTESTFLAGS=$(RUNTESTFLAGS)"

# Flags that we pass when building the testsuite.

# empty for native, $(target_alias)/ for cross
target_subdir = @target_subdir@

CC_FOR_TARGET = ` \
  if [ -f $${rootme}/../gcc/xgcc ] ; then \
    if [ -f $${rootme}/../$(target_subdir)newlib/Makefile ] ; then \
      echo $${rootme}/../gcc/xgcc -B$${rootme}/../gcc/ -idirafter $${rootme}/$(target_subdir)newlib/targ-include -idirafter $${rootsrc}/../$(target_subdir)newlib/libc/include -nostdinc -B$${rootme}/../$(target_subdir)newlib/; \
    else \
      echo $${rootme}/../gcc/xgcc -B$${rootme}/../gcc/; \
    fi; \
  else \
    if [ "$(host_canonical)" = "$(target_canonical)" ] ; then \
      echo $(CC); \
    else \
      t='$(program_transform_name)'; echo gcc | sed -e '' $$t; \
    fi; \
  fi`

CXX = gcc
CXX_FOR_TARGET = ` \
  if [ -f $${rootme}/../gcc/xgcc ] ; then \
    if [ -f $${rootme}/../$(target_subdir)newlib/Makefile ] ; then \
      echo $${rootme}/../gcc/xgcc -B$${rootme}/../gcc/ -idirafter $${rootme}/$(target_subdir)newlib/targ-include -idirafter $${rootsrc}/../$(target_subdir)newlib/libc/include -nostdinc -B$${rootme}/../$(target_subdir)newlib/; \
    else \
      echo $${rootme}/../gcc/xgcc -B$${rootme}/../gcc/; \
    fi; \
  else \
    if [ "$(host_canonical)" = "$(target_canonical)" ] ; then \
      echo $(CXX); \
    else \
      t='$(program_transform_name)'; echo gcc | sed -e '' $$t; \
    fi; \
  fi`

# The use of $$(x_FOR_TARGET) reduces the command line length by not
# duplicating the lengthy definition.
TARGET_FLAGS_TO_PASS = \
	"prefix=$(prefix)" \
	"exec_prefix=$(exec_prefix)" \
	"against=$(against)" \
	'CC=$$(CC_FOR_TARGET)' \
	"CC_FOR_TARGET=$(CC_FOR_TARGET)" \
	"CFLAGS=$(CFLAGS)" \
	'CXX=$$(CXX_FOR_TARGET)' \
	"CXX_FOR_TARGET=$(CXX_FOR_TARGET)" \
	"CXXFLAGS=$(CXXFLAGS)" \
	"INSTALL=$(INSTALL)" \
	"INSTALL_PROGRAM=$(INSTALL_PROGRAM)" \
	"INSTALL_DATA=$(INSTALL_DATA)" \
	"MAKEINFO=$(MAKEINFO)" \
	"MAKEHTML=$(MAKEHTML)" \
	"RUNTEST=$(RUNTEST)" \
	"RUNTESTFLAGS=$(RUNTESTFLAGS)"

# All source files that go into linking GDB.
# Links made at configuration time should not be specified here, since
# SFILES is used in building the distribution archive.

SFILES = ada-exp.y ada-lang.c ada-typeprint.c ada-valprint.c ada-tasks.c \
	ax-general.c ax-gdb.c \
	bcache.c block.c blockframe.c breakpoint.c buildsym.c builtin-regs.c \
	c-exp.y c-lang.c c-typeprint.c c-valprint.c \
	charset.c cli-out.c coffread.c coff-pe-read.c \
	complaints.c completer.c corefile.c \
	cp-abi.c cp-support.c cp-namespace.c cp-valprint.c \
	dbxread.c demangle.c dictionary.c disasm.c doublest.c dummy-frame.c \
	dwarfread.c dwarf2expr.c dwarf2loc.c dwarf2read.c dwarf2-frame.c \
	elfread.c environ.c eval.c event-loop.c event-top.c expprint.c \
	f-exp.y f-lang.c f-typeprint.c f-valprint.c findvar.c frame.c \
	frame-base.c \
	frame-unwind.c \
	gdbarch.c arch-utils.c gdbtypes.c gnu-v2-abi.c gnu-v3-abi.c \
	hpacc-abi.c \
	inf-loop.c \
	infcall.c \
	infcmd.c inflow.c infrun.c \
	interps.c \
	jv-exp.y jv-lang.c jv-valprint.c jv-typeprint.c \
	kod.c kod-cisco.c \
	language.c linespec.c \
	m2-exp.y m2-lang.c m2-typeprint.c m2-valprint.c \
	macrotab.c macroexp.c macrocmd.c macroscope.c main.c maint.c \
	mdebugread.c memattr.c mem-break.c minsyms.c mipsread.c \
	nlmread.c \
	objc-exp.y objc-lang.c \
	objfiles.c osabi.c observer.c \
	p-exp.y p-lang.c p-typeprint.c p-valprint.c parse.c printcmd.c \
	regcache.c reggroups.c remote.c remote-fileio.c \
	scm-exp.c scm-lang.c scm-valprint.c \
	sentinel-frame.c \
	serial.c ser-unix.c source.c \
	stabsread.c stack.c std-regs.c symfile.c symmisc.c symtab.c \
	target.c thread.c top.c tracepoint.c \
	trad-frame.c \
	typeprint.c \
	tui/tui.c tui/tui.h tui/tuiCommand.c tui/tuiCommand.h \
	tui/tuiData.c tui/tuiData.h tui/tuiDataWin.c tui/tuiDataWin.h \
	tui/tuiDisassem.c tui/tuiDisassem.h tui/tuiGeneralWin.c \
	tui/tuiGeneralWin.h tui/tuiIO.c tui/tuiIO.h tui/tuiLayout.c \
	tui/tuiLayout.h tui/tuiRegs.c tui/tuiRegs.h tui/tuiSource.c \
	tui/tuiSource.h tui/tuiSourceWin.c tui/tuiSourceWin.h \
	tui/tuiStack.c tui/tuiStack.h tui/tuiWin.c tui/tuiWin.h \
	tui/tui-file.h tui/tui-file.c tui/tui-out.c tui/tui-hooks.c \
	ui-out.c utils.c ui-file.h ui-file.c \
	valarith.c valops.c valprint.c values.c varobj.c \
	wrapper.c

LINTFILES = $(SFILES) $(YYFILES) $(CONFIG_SRCS) init.c

# "system" headers.  Using these in dependencies is a rather personal
# choice. (-rich, summer 1993)
# (Why would we not want to depend on them?  If one of these changes in a 
# non-binary-compatible way, it is a real pain to remake the right stuff
# without these dependencies -kingdon, 13 Mar 1994)
aout_aout64_h =	$(INCLUDE_DIR)/aout/aout64.h
aout_stabs_gnu_h =	$(INCLUDE_DIR)/aout/stabs_gnu.h
getopt_h =	$(INCLUDE_DIR)/getopt.h
floatformat_h =	$(INCLUDE_DIR)/floatformat.h
bfd_h =		$(BFD_DIR)/bfd.h
callback_h =	$(INCLUDE_DIR)/gdb/callback.h
coff_sym_h =	$(INCLUDE_DIR)/coff/sym.h
coff_symconst_h =	$(INCLUDE_DIR)/coff/symconst.h
coff_ecoff_h =	$(INCLUDE_DIR)/coff/ecoff.h
coff_internal_h =	$(INCLUDE_DIR)/coff/internal.h
dis_asm_h =	$(INCLUDE_DIR)/dis-asm.h 
elf_reloc_macros_h =	$(INCLUDE_DIR)/elf/reloc-macros.h
elf_sh_h =	$(INCLUDE_DIR)/elf/sh.h
elf_arm_h =	$(INCLUDE_DIR)/elf/arm.h $(elf_reloc_macros_h)
elf_bfd_h =	$(BFD_SRC)/elf-bfd.h
libaout_h =	$(BFD_SRC)/libaout.h
libbfd_h =	$(BFD_SRC)/libbfd.h
remote_sim_h =	$(INCLUDE_DIR)/gdb/remote-sim.h
demangle_h =    $(INCLUDE_DIR)/demangle.h
obstack_h =     $(INCLUDE_DIR)/obstack.h
opcode_m68hc11_h = $(INCLUDE_DIR)/opcode/m68hc11.h
readline_h = 	$(READLINE_SRC)/readline.h
sh_opc_h = 	$(OPCODES_SRC)/sh-opc.h
gdb_sim_arm_h =	$(INCLUDE_DIR)/gdb/sim-arm.h
gdb_sim_d10v_h = $(INCLUDE_DIR)/gdb/sim-d10v.h
gdb_sim_sh_h =	$(INCLUDE_DIR)/gdb/sim-sh.h
splay_tree_h =  $(INCLUDE_DIR)/splay-tree.h

readline_headers = \
	$(READLINE_SRC)/chardefs.h \
	$(READLINE_SRC)/history.h \
	$(READLINE_SRC)/keymaps.h \
	$(READLINE_SRC)/readline.h

#
# $BUILD/ headers
#

config_h = config.h
exc_request_U_h = exc_request_U.h
exc_request_S_h = exc_request_S.h
msg_reply_S_h = msg_reply_S.h
msg_U_h = msg_U.h
notify_S_h = notify_S.h
process_reply_S_h = process_reply_S.h

#
# config/ headers
#

xm_h =		@xm_h@
tm_h =		@tm_h@
nm_h =		@nm_h@

#
# gdb/ headers
#

ada_lang_h = ada-lang.h $(value_h) $(gdbtypes_h)
alphabsd_tdep_h = alphabsd-tdep.h
alpha_tdep_h = alpha-tdep.h
annotate_h = annotate.h $(symtab_h) $(gdbtypes_h)
arch_utils_h = arch-utils.h
arm_tdep_h = arm-tdep.h
ax_gdb_h = ax-gdb.h
ax_h = ax.h $(doublest_h)
bcache_h = bcache.h
block_h = block.h
breakpoint_h = breakpoint.h $(frame_h) $(value_h) $(gdb_events_h)
buildsym_h = buildsym.h
builtin_regs_h = builtin-regs.h
call_cmds_h = call-cmds.h
charset_h = charset.h
c_lang_h = c-lang.h $(value_h) $(macroexp_h)
cli_out_h = cli-out.h
coff_pe_read_h = coff-pe-read.h
coff_solib_h = coff-solib.h
command_h = command.h
complaints_h = complaints.h
completer_h = completer.h
cp_abi_h = cp-abi.h
cp_support_h = cp-support.h $(symtab_h)
dcache_h = dcache.h
defs_h = defs.h $(config_h) $(ansidecl_h) $(gdb_locale_h) $(gdb_signals_h) \
	$(libiberty_h) $(progress_h) $(bfd_h) $(tui_h) $(ui_file_h) $(xm_h) \
	$(nm_h) $(tm_h) $(fopen_same_h) $(gdbarch_h) $(arch_utils_h)
dictionary_h = dictionary.h
disasm_h = disasm.h
doublest_h = doublest.h $(floatformat_h)
dummy_frame_h = dummy-frame.h
dwarf2expr_h = dwarf2expr.h
dwarf2_frame_h = dwarf2-frame.h
dwarf2loc_h = dwarf2loc.h
environ_h = environ.h
event_loop_h = event-loop.h
event_top_h = event-top.h
expression_h = expression.h $(symtab_h) $(doublest_h)
f_lang_h = f-lang.h
frame_base_h = frame-base.h
frame_h = frame.h
frame_unwind_h = frame-unwind.h $(frame_h)
gdbarch_h = gdbarch.h $(dis_asm_h) $(inferior_h) $(symfile_h)
gdb_assert_h = gdb_assert.h
gdbcmd_h = gdbcmd.h $(command_h) $(ui_out_h)
gdbcore_h = gdbcore.h $(bfd_h)
gdb_dirent_h = gdb_dirent.h
gdb_events_h = gdb-events.h
gdb_h = gdb.h
gdb_locale_h = gdb_locale.h
gdb_obstack_h = gdb_obstack.h $(obstack_h)
gdb_proc_service_h = gdb_proc_service.h $(gregset_h)
gdb_regex_h = gdb_regex.h $(xregex_h)
gdb_stabs_h = gdb-stabs.h
gdb_stat_h = gdb_stat.h
gdb_string_h = gdb_string.h
gdb_thread_db_h = gdb_thread_db.h
gdbthread_h = gdbthread.h $(breakpoint_h) $(frame_h)
gdbtypes_h = gdbtypes.h
gdb_vfork_h = gdb_vfork.h
gdb_wait_h = gdb_wait.h
gnu_nat_h = gnu-nat.h
gregset_h = gregset.h
i386_linux_tdep_h = i386-linux-tdep.h
i386_tdep_h = i386-tdep.h
i387_tdep_h = i387-tdep.h
infcall_h = infcall.h
inferior_h = inferior.h $(breakpoint_h) $(target_h) $(frame_h)
inf_loop_h = inf-loop.h
inflow_h = inflow.h $(terminal_h)
infttrace_h = infttrace.h
interps_h = interps.h
jv_lang_h = jv-lang.h
kod_h = kod.h
language_h = language.h
linespec_h = linespec.h
linux_nat_h = linux-nat.h
m2_lang_h = m2-lang.h
m68k_tdep_h = m68k-tdep.h
macroexp_h = macroexp.h
macroscope_h = macroscope.h $(macrotab_h) $(symtab_h)
macrotab_h = macrotab.h
main_h = main.h
memattr_h = memattr.h
minimon_h = minimon.h
mipsnbsd_tdep_h = mipsnbsd-tdep.h
mips_tdep_h = mips-tdep.h
monitor_h = monitor.h
nbsd_tdep_h = nbsd-tdep.h
ns32k_tdep_h = ns32k-tdep.h
nto_tdep_h = nto-tdep.h $(defs_h) $(solist_h)
objc_lang_h = objc-lang.h
objfiles_h = objfiles.h $(gdb_obstack_h) $(symfile_h)
observer_h = observer.h
ocd_h = ocd.h
osabi_h = osabi.h
pa64solib_h = pa64solib.h
parser_defs_h = parser-defs.h $(doublest_h)
p_lang_h = p-lang.h
ppcnbsd_tdep_h = ppcnbsd-tdep.h
ppc_tdep_h = ppc-tdep.h
proc_utils_h = proc-utils.h
regcache_h = regcache.h
reggroups_h = reggroups.h
remote_fileio_h = remote-fileio.h
remote_h = remote.h
remote_utils_h = remote-utils.h $(target_h)
scm_lang_h = scm-lang.h $(scm_tags_h)
scm_tags_h = scm-tags.h
sentinel_frame_h = sentinel-frame.h
serial_h = serial.h
ser_unix_h = ser-unix.h
shnbsd_tdep_h = shnbsd-tdep.h
sh_tdep_h = sh-tdep.h
sim_regno_h = sim-regno.h
solib_h = solib.h
solib_svr4_h = solib-svr4.h
solist_h = solist.h
somsolib_h = somsolib.h
source_h = source.h
sparcnbsd_tdep_h = sparcnbsd-tdep.h
sparc_tdep_h = sparc-tdep.h
srec_h = srec.h
stabsread_h = stabsread.h
stack_h = stack.h
symfile_h = symfile.h
symtab_h = symtab.h
target_h = target.h $(bfd_h) $(symtab_h) $(dcache_h) $(memattr_h)
terminal_h = terminal.h
top_h = top.h
tracepoint_h = tracepoint.h
trad_frame_h = trad-frame.h
typeprint_h = typeprint.h
ui_file_h = ui-file.h
ui_out_h = ui-out.h
valprint_h = valprint.h
value_h = value.h $(doublest_h) $(frame_h) $(symtab_h) $(gdbtypes_h) \
	$(expression_h)
varobj_h = varobj.h $(symtab_h) $(gdbtypes_h)
vax_tdep_h = vax-tdep.h
version_h = version.h
wince_stub_h = wince-stub.h
wrapper_h = wrapper.h $(gdb_h)
x86_64_linux_tdep_h = x86-64-linux-tdep.h
x86_64_tdep_h = x86-64-tdep.h $(i386_tdep_h)
xcoffsolib_h = xcoffsolib.h
xmodem_h = xmodem.h

#
# gdb/cli/ headers
#

cli_cmds_h = $(srcdir)/cli/cli-cmds.h
cli_decode_h = $(srcdir)/cli/cli-decode.h $(command_h)
cli_dump_h = $(srcdir)/cli/cli-dump.h
cli_script_h = $(srcdir)/cli/cli-script.h
cli_setshow_h = $(srcdir)/cli/cli-setshow.h
cli_utils_h = $(srcdir)/cli/cli-utils.h

#
# gdb/mi/ headers
#

mi_cmds_h = $(srcdir)/mi/mi-cmds.h
mi_console_h = $(srcdir)/mi/mi-console.h
mi_getopt_h = $(srcdir)/mi/mi-getopt.h
mi_main_h = $(srcdir)/mi/mi-main.h
mi_out_h = $(srcdir)/mi/mi-out.h
mi_parse_h = $(srcdir)/mi/mi-parse.h

#
# gdb/tui/ headers
#

tuiCommand_h = $(srcdir)/tui/tuiCommand.h
tuiDataWin_h = $(srcdir)/tui/tuiDataWin.h
tuiData_h = $(srcdir)/tui/tuiData.h
tuiDisassem_h = $(srcdir)/tui/tuiDisassem.h
tuiGeneralWin_h = $(srcdir)/tui/tuiGeneralWin.h
tuiIO_h = $(srcdir)/tui/tuiIO.h
tuiLayout_h = $(srcdir)/tui/tuiLayout.h
tuiRegs_h = $(srcdir)/tui/tuiRegs.h
tuiSourceWin_h = $(srcdir)/tui/tuiSourceWin.h
tuiSource_h = $(srcdir)/tui/tuiSource.h $(defs_h)
tuiStack_h = $(srcdir)/tui/tuiStack.h
tuiWin_h = $(srcdir)/tui/tuiWin.h
tui_file_h = $(srcdir)/tui/tui-file.h
tui_h = $(srcdir)/tui/tui.h $(ansidecl_h)

# Header files that need to have srcdir added.  Note that in the cases
# where we use a macro like $(gdbcmd_h), things are carefully arranged
# so that each .h file is listed exactly once (M-x tags-search works
# wrong if TAGS has files twice).  Because this is tricky to get
# right, it is probably easiest just to list .h files here directly.

HFILES_NO_SRCDIR = bcache.h buildsym.h call-cmds.h coff-solib.h defs.h \
	environ.h $(gdbcmd_h) gdb.h gdbcore.h \
	gdb-stabs.h $(inferior_h) language.h minimon.h monitor.h \
	objfiles.h parser-defs.h serial.h solib.h \
	symfile.h stabsread.h target.h terminal.h typeprint.h xcoffsolib.h \
	macrotab.h macroexp.h macroscope.h \
	c-lang.h f-lang.h \
	jv-lang.h \
	m2-lang.h  p-lang.h \
	complaints.h valprint.h \
	vx-share/dbgRpcLib.h vx-share/ptrace.h vx-share/vxTypes.h \
	vx-share/vxWorks.h vx-share/wait.h vx-share/xdr_ld.h \
	vx-share/xdr_ptrace.h vx-share/xdr_rdb.h gdbthread.h \
	dcache.h remote-utils.h top.h somsolib.h

# Header files that already have srcdir in them, or which are in objdir.

HFILES_WITH_SRCDIR = ../bfd/bfd.h


# GDB "info" files, which should be included in their entirety
INFOFILES = gdb.info*

REMOTE_EXAMPLES = m68k-stub.c i386-stub.c sparc-stub.c rem-multi.shar

# {X,T,NAT}DEPFILES are something of a pain in that it's hard to
# default their values the way we do for SER_HARDWIRE; in the future
# maybe much of the stuff now in {X,T,NAT}DEPFILES will go into other
# variables analogous to SER_HARDWIRE which get defaulted in this
# Makefile.in

DEPFILES = $(TDEPFILES) $(SER_HARDWIRE) $(NATDEPFILES) \
	   $(REMOTE_OBS) $(SIM_OBS) $(CONFIG_LIB_OBS)

SOURCES = $(SFILES) $(ALLDEPFILES) $(YYFILES) $(CONFIG_SRCS)
# Don't include YYFILES (*.tab.c) because we already include *.y in SFILES,
# and it's more useful to see it in the .y file.
TAGFILES_NO_SRCDIR = $(SFILES) $(HFILES_NO_SRCDIR) $(ALLDEPFILES) \
	$(SUBDIR_CLI_SRCS)
TAGFILES_WITH_SRCDIR = $(HFILES_WITH_SRCDIR)

COMMON_OBS = version.o blockframe.o breakpoint.o findvar.o regcache.o \
	charset.o disasm.o dummy-frame.o \
	source.o values.o eval.o valops.o valarith.o valprint.o printcmd.o \
	block.o symtab.o symfile.o symmisc.o linespec.o dictionary.o \
	infcall.o \
	infcmd.o infrun.o \
	expprint.o environ.o stack.o thread.o \
	interps.o \
	macrotab.o macrocmd.o macroexp.o macroscope.o \
	event-loop.o event-top.o inf-loop.o completer.o \
	gdbarch.o arch-utils.o gdbtypes.o osabi.o copying.o $(DEPFILES) \
	memattr.o mem-break.o target.o parse.o language.o $(YYOBJ) buildsym.o \
	builtin-regs.o std-regs.o \
	signals.o \
	kod.o kod-cisco.o \
	gdb-events.o \
	exec.o bcache.o objfiles.o observer.o minsyms.o maint.o demangle.o \
	dbxread.o coffread.o coff-pe-read.o elfread.o \
	dwarfread.o dwarf2read.o mipsread.o stabsread.o corefile.o \
	dwarf2expr.o dwarf2loc.o dwarf2-frame.o \
	c-lang.o f-lang.o objc-lang.o \
	ui-out.o cli-out.o \
	varobj.o wrapper.o \
	jv-lang.o jv-valprint.o jv-typeprint.o \
	m2-lang.o p-lang.o p-typeprint.o p-valprint.o \
	scm-exp.o scm-lang.o scm-valprint.o \
	sentinel-frame.o \
	complaints.o typeprint.o \
	c-typeprint.o f-typeprint.o m2-typeprint.o \
	c-valprint.o cp-valprint.o f-valprint.o m2-valprint.o \
	nlmread.o serial.o mdebugread.o top.o utils.o \
	ui-file.o \
	frame.o frame-unwind.o doublest.o \
	frame-base.o \
	gnu-v2-abi.o gnu-v3-abi.o hpacc-abi.o cp-abi.o cp-support.o \
	cp-namespace.o \
	reggroups.o \
	trad-frame.o

OBS = $(COMMON_OBS) $(ANNOTATE_OBS)

TSOBS = inflow.o

SUBDIRS = @subdirs@

# For now, shortcut the "configure GDB for fewer languages" stuff.
YYFILES = c-exp.tab.c \
	objc-exp.tab.c \
	ada-exp.tab.c \
	jv-exp.tab.c \
	f-exp.tab.c m2-exp.tab.c p-exp.tab.c
YYOBJ = c-exp.tab.o \
	objc-exp.tab.o \
	jv-exp.tab.o \
	f-exp.tab.o m2-exp.tab.o p-exp.tab.o

# Things which need to be built when making a distribution.

DISTSTUFF = $(YYFILES)

# Prevent Sun make from putting in the machine type.  Setting
# TARGET_ARCH to nothing works for SunOS 3, 4.0, but not for 4.1.
.c.o:
	$(CC) -c $(INTERNAL_CFLAGS) $<

all: gdb$(EXEEXT) $(CONFIG_ALL)
	@$(MAKE) $(FLAGS_TO_PASS) DO=all "DODIRS=`echo $(SUBDIRS) | sed 's/testsuite//'`" subdir_do

installcheck:

# The check target can not use subdir_do, because subdir_do does not
# use TARGET_FLAGS_TO_PASS.
check: force
	@if [ -f testsuite/Makefile ]; then \
	  rootme=`pwd`; export rootme; \
	  rootsrc=`cd $(srcdir); pwd`; export rootsrc; \
	  cd testsuite; \
	  $(MAKE) $(TARGET_FLAGS_TO_PASS) check; \
	else true; fi

info dvi install-info clean-info html install-html: force
	@$(MAKE) $(FLAGS_TO_PASS) DO=$@ "DODIRS=$(SUBDIRS)" subdir_do

gdb.z:gdb.1
	nroff -man $(srcdir)/gdb.1 | col -b > gdb.t 
	pack gdb.t ; rm -f gdb.t
	mv gdb.t.z gdb.z

# Traditionally "install" depends on "all".  But it may be useful
# not to; for example, if the user has made some trivial change to a 
# source file and doesn't care about rebuilding or just wants to save the
# time it takes for make to check that all is up to date.
# install-only is intended to address that need.
install: all install-only
install-only: $(CONFIG_INSTALL)
	transformed_name=`t='$(program_transform_name)'; \
			  echo gdb | sed -e "$$t"` ; \
		if test "x$$transformed_name" = x; then \
		  transformed_name=gdb ; \
		else \
		  true ; \
		fi ; \
		$(SHELL) $(srcdir)/../mkinstalldirs $(DESTDIR)$(bindir) ; \
		$(INSTALL_PROGRAM) gdb$(EXEEXT) \
			$(DESTDIR)$(bindir)/$$transformed_name$(EXEEXT) ; \
		$(SHELL) $(srcdir)/../mkinstalldirs \
			$(DESTDIR)$(man1dir) ; \
		$(INSTALL_DATA) $(srcdir)/gdb.1 \
			$(DESTDIR)$(man1dir)/$$transformed_name.1
	@$(MAKE) DO=install "DODIRS=$(SUBDIRS)" $(FLAGS_TO_PASS) subdir_do 

uninstall: force $(CONFIG_UNINSTALL)
	transformed_name=`t='$(program_transform_name)'; \
			  echo gdb | sed -e $$t` ; \
		if test "x$$transformed_name" = x; then \
		  transformed_name=gdb ; \
		else \
		  true ; \
		fi ; \
		rm -f $(DESTDIR)$(bindir)/$$transformed_name$(EXEEXT) \
		      $(DESTDIR)$(man1dir)/$$transformed_name.1
	@$(MAKE) DO=uninstall "DODIRS=$(SUBDIRS)" $(FLAGS_TO_PASS) subdir_do 

# We do this by grepping through sources.  If that turns out to be too slow,
# maybe we could just require every .o file to have an initialization routine
# of a given name (top.o -> _initialize_top, etc.).
#
# Formatting conventions:  The name of the _initialize_* routines must start
# in column zero, and must not be inside #if.
#
# Note that the set of files with init functions might change, or the names
# of the functions might change, so this files needs to depend on all the
# object files that will be linked into gdb.
#
# FIXME: There are 2 problems with this approach. First, if the INIT_FILES
# list includes a file twice (because of some mistake somewhere else) 
# the _initialize_* function will be included twice in init.c. Second, 
# init.c may force unnecessary files to be linked in.

# FIXME: cagney/2002-06-09: gdb/564: gdb/563: Force the order so that
# the first call is to _initialize_gdbtypes.  This is a hack to ensure
# that all the architecture dependant global builtin_type_* variables
# are initialized before anything else (per-architecture code is
# called in the same order that it is registered).  The ``correct
# fix'' is to have all the builtin types made part of the architecture
# and initialize them on-demand (using gdbarch_data) just like
# everything else.  The catch is that other modules still take the
# address of these builtin types forcing them to be variables, sigh!

# NOTE: cagney/2003-03-18: The sed pattern ``s|^\([^ /]...'' is
# anchored on the first column and excludes the ``/'' character so
# that it doesn't add the $(srcdir) prefix to any file that already
# has an absolute path.  It turns out that $(DEC)'s True64 make
# automatically adds the $(srcdir) prefixes when it encounters files
# in sub-directories such as cli/ and mi/.

INIT_FILES = $(OBS) $(TSOBS) $(CONFIG_OBS) $(CONFIG_INITS)
init.c: $(INIT_FILES)
	@echo Making init.c
	@rm -f init.c-tmp init.l-tmp
	@-echo $(INIT_FILES) | \
	tr ' ' '\012' | \
	sed \
	    -e '/^init.o/d' \
	    -e '/xdr_ld.o/d' \
	    -e '/xdr_ptrace.o/d' \
	    -e '/xdr_rdb.o/d' \
	    -e '/udr.o/d' \
	    -e '/udip2soc.o/d' \
	    -e '/udi2go32.o/d' \
	    -e '/version.o/d' \
	    -e '/^[a-z0-9A-Z_]*_[SU].o/d' \
	    -e '/[a-z0-9A-Z_]*-exp.tab.o/d' \
	    -e 's/\.o/.c/' \
	    -e 's,signals\.c,signals/signals\.c,' \
	    -e 's|^\([^  /][^     ]*\)|$(srcdir)/\1|g' | \
	while read f; do grep '^_initialize_[a-z_0-9A-Z]* *(' $$f 2>/dev/null; done | \
	sed -e 's/^.*://' -e 's/^\([a-z_0-9A-Z]*\).*/\1/' | \
	( echo _initialize_gdbtypes ; grep -v '^_initialize_gdbtypes$$' ) > init.l-tmp
	@echo '/* Do not modify this file.  */' >>init.c-tmp
	@echo '/* It is created automatically by the Makefile.  */'>>init.c-tmp
	@echo '#include "defs.h"' >>init.c-tmp
	@echo '#include "call-cmds.h"' >>init.c-tmp
	@sed -e 's/\(.*\)/extern initialize_file_ftype \1;/' <init.l-tmp >>init.c-tmp
	@echo 'void' >>init.c-tmp
	@echo 'initialize_all_files (void)' >>init.c-tmp
	@echo '{' >>init.c-tmp
	@sed -e 's/\(.*\)/  \1 ();/' <init.l-tmp >>init.c-tmp
	@echo '}' >>init.c-tmp
	@rm init.l-tmp
	@mv init.c-tmp init.c

.PRECIOUS: init.c

init.o: init.c $(defs_h) $(call_cmds_h)

# Removing the old gdb first works better if it is running, at least on SunOS.
gdb$(EXEEXT): gdb.o main.o libgdb.a $(CONFIG_OBS) $(ADD_DEPS) $(CDEPS) $(TDEPLIBS)
	rm -f gdb$(EXEEXT)
	$(CC_LD) $(INTERNAL_LDFLAGS) $(WIN32LDAPP) \
		-o gdb$(EXEEXT) gdb.o main.o $(CONFIG_OBS) libgdb.a \
		$(TDEPLIBS) $(TUI_LIBRARY) $(CLIBS) $(LOADLIBES)

nlm:	force
	rootme=`pwd`; export rootme; $(MAKE) $(TARGET_FLAGS_TO_PASS) DO=all DODIRS=nlm subdir_do

# Create a library of the gdb object files and build GDB by linking
# against that.
#
# init.o is very important.  It pulls in the rest of GDB.
LIBGDB_OBS= $(OBS) $(TSOBS) $(ADD_FILES) init.o
libgdb.a: $(LIBGDB_OBS)
	-rm -f libgdb.a
	$(AR) q libgdb.a $(LIBGDB_OBS)
	$(RANLIB) libgdb.a

# A Mach 3.0 program to force gdb back to command level

stop-gdb: stop-gdb.o
	${CC_LD} $(GLOBAL_CFLAGS) $(LDFLAGS) -o stop-gdb \
	stop-gdb.o $(CLIBS) $(LOADLIBES)

# This is useful when debugging GDB, because some Unix's don't let you run GDB
# on itself without copying the executable.  So "make gdb1" will make
# gdb and put a copy in gdb1, and you can run it with "gdb gdb1".
# Removing gdb1 before the copy is the right thing if gdb1 is open
# in another process.
gdb1$(EXEEXT): gdb$(EXEEXT)
	rm -f gdb1$(EXEEXT)
	cp gdb$(EXEEXT) gdb1$(EXEEXT)

# FIXME. These are not generated by "make depend" because they only are there
# for some machines.
# But these rules don't do what we want; we want to hack the foo.o: tm.h
# dependency to do the right thing.
tm-sun3.h tm-hp300bsd.h tm-altos.h: tm-m68k.h
tm-hp300hpux.h tm-sun2.h tm-3b1.h: tm-m68k.h
xm-i386-sv32.h: xm-i386.h
tm-i386gas.h: tm-i386.h
tm-sun4os4.h: tm-sparc.h
xm-vaxult.h: xm-vax.h
xm-vaxbsd.h: xm-vax.h

# Put the proper machine-specific files first, so M-. on a machine
# specific routine gets the one for the correct machine.  (FIXME: those
# files go in twice; we should be removing them from the main list).

# TAGS depends on all the files that go into it so you can rebuild TAGS
# with `make TAGS' and not have to say `rm TAGS' first.

TAGS: $(TAGFILES_NO_SRCDIR) $(TAGFILES_WITH_SRCDIR)
	@echo Making TAGS
	@etags $(srcdir)/$(TM_FILE) \
	  $(srcdir)/$(XM_FILE) \
	  $(srcdir)/$(NAT_FILE) \
	`(for i in $(DEPFILES) $(TAGFILES_NO_SRCDIR); do \
		echo $(srcdir)/$$i ; \
	done ; for i in $(TAGFILES_WITH_SRCDIR); do \
		echo $$i ; \
	done) | sed -e 's/\.o$$/\.c/'` \
	`find $(srcdir)/config -name '*.h' -print`

tags: TAGS

clean mostlyclean: $(CONFIG_CLEAN)
	@$(MAKE) $(FLAGS_TO_PASS) DO=clean "DODIRS=$(SUBDIRS)" subdir_do 
	rm -f *.o *.a $(ADD_FILES) *~ init.c-tmp init.l-tmp version.c-tmp
	rm -f init.c version.c
	rm -f gdb$(EXEEXT) core make.log
	rm -f gdb[0-9]$(EXEEXT)

# This used to depend on c-exp.tab.c m2-exp.tab.c TAGS
# I believe this is wrong; the makefile standards for distclean just
# describe removing files; the only sort of "re-create a distribution"
# functionality described is if the distributed files are unmodified.
# NB: While GDBSERVER might be configured on native systems, it isn't
# always included in SUBDIRS.  Remove the gdbserver files explictly.
distclean: clean
	@$(MAKE) $(FLAGS_TO_PASS) DO=distclean "DODIRS=$(SUBDIRS)" subdir_do 
	rm -f gdbserver/config.status gdbserver/config.log
	rm -f gdbserver/tm.h gdbserver/xm.h gdbserver/nm.h
	rm -f gdbserver/Makefile gdbserver/config.cache
	rm -f nm.h tm.h xm.h config.status config.h stamp-h .gdbinit
	rm -f y.output yacc.acts yacc.tmp y.tab.h
	rm -f config.log config.cache
	rm -f Makefile

maintainer-clean: local-maintainer-clean do-maintainer-clean distclean
realclean: maintainer-clean

local-maintainer-clean:
	@echo "This command is intended for maintainers to use;"
	@echo "it deletes files that may require special tools to rebuild."
	rm -f c-exp.tab.c \
		ada-lex.c ada-exp.tab.c \
	        objc-exp.tab.c \
		jv-exp.tab \
		f-exp.tab.c m2-exp.tab.c p-exp.tab.c
	rm -f TAGS $(INFOFILES)
	rm -f $(YYFILES)
	rm -f nm.h tm.h xm.h config.status

do-maintainer-clean:
	@$(MAKE) $(FLAGS_TO_PASS) DO=maintainer-clean "DODIRS=$(SUBDIRS)" \
		subdir_do

diststuff: $(DISTSTUFF)
	cd doc; $(MAKE) $(MFLAGS) diststuff

subdir_do: force
	@for i in $(DODIRS); do \
		if [ -f ./$$i/Makefile ] ; then \
			if (cd ./$$i; \
				$(MAKE) $(FLAGS_TO_PASS) $(DO)) ; then true ; \
			else exit 1 ; fi ; \
		else true ; fi ; \
	done

Makefile: Makefile.in config.status @frags@
	$(SHELL) config.status

config.h: stamp-h ; @true
stamp-h: config.in config.status
	CONFIG_HEADERS=config.h:config.in $(SHELL) config.status

config.status: configure configure.tgt configure.host
	$(SHELL) config.status --recheck

force:

# Documentation!
# GDB QUICK REFERENCE (TeX dvi file, CM fonts)
doc/refcard.dvi:
	cd doc; $(MAKE) refcard.dvi $(FLAGS_TO_PASS)

# GDB QUICK REFERENCE (PostScript output, common PS fonts)
doc/refcard.ps:
	cd doc; $(MAKE) refcard.ps $(FLAGS_TO_PASS)

# GDB MANUAL: TeX dvi file
doc/gdb.dvi:
	cd doc; $(MAKE) gdb.dvi $(FLAGS_TO_PASS)

# GDB MANUAL: info file
doc/gdb.info:
	cd doc; $(MAKE) gdb.info $(FLAGS_TO_PASS)

# Make copying.c from COPYING
$(srcdir)/copying.c: @MAINTAINER_MODE_TRUE@ \
		$(srcdir)/COPYING $(srcdir)/copying.awk
	awk -f $(srcdir)/copying.awk \
		< $(srcdir)/COPYING > $(srcdir)/copying.tmp
	mv $(srcdir)/copying.tmp $(srcdir)/copying.c

version.c: Makefile version.in
	rm -f version.c-tmp version.c
	echo '#include "version.h"' >> version.c-tmp
	echo 'const char version[] = "'"`sed q ${srcdir}/version.in`"'";' >> version.c-tmp
	echo 'const char host_name[] = "$(host_alias)";' >> version.c-tmp
	echo 'const char target_name[] = "$(target_alias)";' >> version.c-tmp
	mv version.c-tmp version.c
version.o: version.c $(version_h)


lint: $(LINTFILES)
	$(LINT) $(INCLUDE_CFLAGS) $(LINTFLAGS) $(LINTFILES) \
	   `echo $(DEPFILES) | sed 's/\.o /\.c /g'`

gdb.cxref: $(SFILES)
	cxref -I. $(SFILES) >gdb.cxref

force_update:

# GNU Make has an annoying habit of putting *all* the Makefile variables
# into the environment, unless you include this target as a circumvention.
# Rumor is that this will be fixed (and this target can be removed)
# in GNU Make 4.0.
.NOEXPORT:

# GNU Make 3.63 has a different problem: it keeps tacking command line
# overrides onto the definition of $(MAKE).  This variable setting
# will remove them.
MAKEOVERRIDES=

## This is ugly, but I don't want GNU make to put these variables in
## the environment.  Older makes will see this as a set of targets
## with no dependencies and no actions.
unexport CHILLFLAGS CHILL_LIB CHILL_FOR_TARGET :

ALLDEPFILES = \
	aix-thread.c \
	alpha-nat.c alphabsd-nat.c \
	alpha-tdep.c alpha-linux-tdep.c alphabsd-tdep.c alphanbsd-tdep.c \
	alpha-osf1-tdep.c alphafbsd-tdep.c alpha-mdebug-tdep.c \
	arm-linux-nat.c arm-linux-tdep.c arm-tdep.c \
	armnbsd-nat.c armnbsd-tdep.c \
	avr-tdep.c \
        bfin-tdep.c \
	coff-solib.c \
	core-sol2.c core-regset.c core-aout.c corelow.c \
	dcache.c delta68-nat.c dpx2-nat.c exec.c fork-child.c \
	go32-nat.c h8300-tdep.c h8500-tdep.c \
	hppa-tdep.c hppa-hpux-tdep.c \
	hppab-nat.c hppah-nat.c hpread.c \
	i386-tdep.c i386b-nat.c i386v-nat.c i386-linux-nat.c \
	i386v4-nat.c i386ly-tdep.c i386-cygwin-tdep.c \
	i386bsd-nat.c i386bsd-tdep.c i386fbsd-nat.c \
	i387-tdep.c \
	i386-linux-tdep.c i386-nat.c \
	i386gnu-nat.c i386gnu-tdep.c \
	ia64-linux-nat.c ia64-linux-tdep.c ia64-tdep.c \
	infptrace.c inftarg.c irix4-nat.c irix5-nat.c \
	lynx-nat.c m3-nat.c \
	m68hc11-tdep.c \
	m68k-tdep.c \
	mcore-tdep.c \
	mips-linux-nat.c mips-linux-tdep.c \
	mips-nat.c \
	mips-irix-tdep.c \
	mips-tdep.c mipsm3-nat.c mipsv4-nat.c \
	mipsnbsd-nat.c mipsnbsd-tdep.c \
	nbsd-tdep.c \
	ns32k-tdep.c solib-osf.c \
	somread.c somsolib.c $(HPREAD_SOURCE) \
	ppc-sysv-tdep.o ppc-linux-nat.c ppc-linux-tdep.c \
	ppcnbsd-nat.o ppcnbsd-tdep.o \
	procfs.c \
	remote-e7000.c \
	remote-hms.c remote-mips.c \
	remote-rdp.c remote-sim.c \
	remote-st.c remote-utils.c dcache.c \
	remote-vx.c \
	rs6000-nat.c rs6000-tdep.c \
	s390-tdep.c s390-nat.c \
	ser-go32.c ser-pipe.c ser-tcp.c \
	sh-tdep.c shnbsd-tdep.c shnbsd-nat.c \
	solib.c solib-irix.c solib-svr4.c solib-sunos.c sparc-linux-nat.c \
	sparc-nat.c \
	sparc64nbsd-nat.c sparcnbsd-nat.c sparcnbsd-tdep.c \
	sparc-tdep.c sparcl-tdep.c sun3-nat.c \
	symm-tdep.c symm-nat.c \
	vax-tdep.c \
	vx-share/xdr_ld.c vx-share/xdr_ptrace.c vx-share/xdr_rdb.c \
	win32-nat.c \
	xcoffread.c xcoffsolib.c \
	xstormy16-tdep.c \
	z8k-tdep.c

# OBSOLETE altos-xdep.o: altos-xdep.c $(defs_h) $(gdbcore_h) $(inferior_h)

annotate.o: annotate.c $(defs_h) annotate.h $(value_h) target.h $(gdbtypes_h)

arm-linux-nat.o: arm-linux-nat.c $(defs_h) $(inferior_h) $(gdbcore_h) \
	gdb_string.h

arm-linux-tdep.o: arm-linux-tdep.c $(defs_h) target.h $(value_h) \
		  $(gdbtypes_h) $(floatformat_h)

arm-tdep.o: arm-tdep.c $(gdbcmd_h) $(gdbcore_h) $(inferior_h) $(defs_h) \
	$(gdbcore_h)

bfin-tdep.o: bfin-tdep.c $(gdbcmd_h) $(gdbcore_h) $(inferior_h) $(defs_h) \
	$(gdbcore_h)

bcache.o: bcache.c bcache.h $(defs_h)

blockframe.o: blockframe.c $(defs_h) $(gdbcore_h) $(inferior_h) \
	objfiles.h symfile.h target.h

breakpoint.o: breakpoint.c $(defs_h) $(gdbcmd_h) $(gdbcore_h) \
	$(inferior_h) language.h target.h gdbthread.h gdb_string.h \
	gdb-events.h

buildsym.o: buildsym.c $(bfd_h) buildsym.h complaints.h $(defs_h) \
	objfiles.h symfile.h $(symtab_h) gdb_string.h

c-lang.o: c-lang.c c-lang.h $(defs_h) $(expression_h) $(gdbtypes_h) \
	language.h parser-defs.h $(symtab_h)

c-typeprint.o: c-typeprint.c c-lang.h $(defs_h) $(expression_h) \
	$(gdbcmd_h) $(gdbcore_h) $(gdbtypes_h) language.h $(symtab_h) \
	target.h typeprint.h $(value_h) gdb_string.h

c-valprint.o: c-valprint.c $(defs_h) $(expression_h) $(gdbtypes_h) \
	language.h $(symtab_h) valprint.h $(value_h)

f-lang.o: f-lang.c f-lang.h $(defs_h) $(expression_h) $(gdbtypes_h) \
	language.h parser-defs.h $(symtab_h) gdb_string.h

f-typeprint.o: f-typeprint.c f-lang.h $(defs_h) $(expression_h) \
	$(gdbcmd_h) $(gdbcore_h) $(gdbtypes_h) language.h $(symtab_h) \
	target.h typeprint.h $(value_h) gdb_string.h

f-valprint.o: f-valprint.c $(defs_h) $(expression_h) $(gdbtypes_h) \
	language.h $(symtab_h) valprint.h $(value_h) gdb_string.h

ch-exp.o: ch-exp.c ch-lang.h $(defs_h) language.h parser-defs.h $(bfd_h) symfile.h objfiles.h $(value_h)

ch-lang.o: ch-lang.c ch-lang.h $(defs_h) $(expression_h) $(gdbtypes_h) \
	language.h parser-defs.h $(symtab_h)

ch-typeprint.o: ch-typeprint.c ch-lang.h $(defs_h) $(expression_h) \
	$(gdbcmd_h) $(gdbcore_h) $(gdbtypes_h) language.h $(symtab_h) \
	target.h $(value_h) typeprint.h gdb_string.h

ch-valprint.o: ch-valprint.c $(defs_h) $(expression_h) $(gdbtypes_h) \
	language.h $(symtab_h) valprint.h $(value_h) c-lang.h

coff-solib.o: coff-solib.c $(defs_h)

coffread.o: coffread.c $(bfd_h) $(breakpoint_h) buildsym.h \
	complaints.h $(defs_h) $(expression_h) $(gdbtypes_h) objfiles.h \
	symfile.h $(symtab_h) gdb-stabs.h stabsread.h target.h \
	gdb_string.h

command.o: command.c $(defs_h) $(expression_h) $(gdbcmd_h) \
	$(gdbtypes_h) $(symtab_h) $(value_h) gdb_string.h gdb_wait.h

complaints.o: complaints.c complaints.h $(defs_h) $(gdbcmd_h)

# OBSOLETE convex-tdep.o: convex-tdep.c gdb_wait.h $(defs_h) $(gdbcmd_h) \
# OBSOLETE	$(gdbcore_h) $(inferior_h)

# OBSOLETE convex-xdep.o: convex-xdep.c $(defs_h) $(gdbcmd_h) $(gdbcore_h) \
# OBSOLETE	$(inferior_h)

# Provide explicit rule/dependency - works for more makes.
copying.o: $(srcdir)/copying.c
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/copying.c

hpux-thread.o: $(srcdir)/hpux-thread.c
	$(CC) -c $(INTERNAL_CFLAGS) -I$(srcdir)/osf-share \
		-I$(srcdir)/osf-share/HP800 -I/usr/include/dce \
		$(srcdir)/hpux-thread.c

# main.o needs an explicit build rule to get TARGET_SYSTEM_ROOT and BINDIR.
main.o: main.c
	$(CC) -c $(INTERNAL_CFLAGS) $(TARGET_SYSTEM_ROOT_DEFINE) \
		-DBINDIR=\"$(bindir)\" $(srcdir)/main.c

# FIXME: Procfs.o gets -Wformat errors because things like pid_t don't
# match output format strings.
procfs.o: $(srcdir)/procfs.c
	$(CC) -c $(INTERNAL_WARN_CFLAGS) $(NO_WERROR_CFLAGS) $(srcdir)/procfs.c

# FIXME: Thread-db.o gets warnings because the definitions of the register
# sets are different from kernel to kernel.
thread-db.o: $(srcdir)/thread-db.c
	$(CC) -c $(INTERNAL_WARN_CFLAGS) $(NO_WERROR_CFLAGS) \
		$(srcdir)/thread-db.c

v850ice.o: $(srcdir)/v850ice.c
	$(CC) -c $(INTERNAL_CFLAGS) $(IDE_CFLAGS) $(ITCL_CFLAGS) \
		$(TCL_CFLAGS) $(TK_CFLAGS) $(X11_CFLAGS) \
		$(GDBTK_CFLAGS) \
		$(srcdir)/v850ice.c

# FIXME: z8k-tdep.c calls _initialize_gdbtypes().  Since that isn't
# declared -Wimplicit fails. It should be using the GDBARCH framework.
# cagney 1999-09-02.
z8k-tdep.o: $(srcdir)/z8k-tdep.c
	$(CC) -c $(INTERNAL_WARN_CFLAGS) $(NO_WERROR_CFLAGS) \
		$(srcdir)/z8k-tdep.c

#
# YACC/LEX dependencies
#
# LANG-exp.tab.c is generated in objdir from LANG-exp.y if it doesn't
# exist in srcdir, then compiled in objdir to LANG-exp.tab.o.  If we
# said LANG-exp.tab.c rather than ./c-exp.tab.c some makes would
# sometimes re-write it into $(srcdir)/c-exp.tab.c.  Remove bogus
# decls for malloc/realloc/free which conflict with everything else.
# Strictly speaking c-exp.tab.c should therefore depend on
# Makefile.in, but that was a pretty big annoyance.

.PRECIOUS: ada-exp.tab.c
ada-exp.tab.o: ada-exp.tab.c $(defs_h) $(expression_h) $(value_h) \
	$(parser_defs_h) $(language_h) $(ada_lang_h) $(bfd_h) $(symfile_h) \
	$(objfiles_h) $(frame_h) $(block_h) $(ada_lex_c)
ada-exp.tab.c: ada-exp.y
	$(SHELL) $(YLWRAP) "$(YACC)" \
	    $(srcdir)/ada-exp.y  y.tab.c ada-exp.tmp -- $(YFLAGS) 
	-sed -e '/extern.*malloc/d' \
	     -e '/extern.*realloc/d' \
	     -e '/extern.*free/d' \
	     -e '/include.*malloc.h/d' \
	     -e 's/malloc/xmalloc/g' \
	     -e 's/realloc/xrealloc/g' \
	     -e '/^#line.*y.tab.c/d' \
	  < ada-exp.tmp > ada-exp.new
	-rm ada-exp.tmp
	mv ada-exp.new ./ada-exp.tab.c
.PRECIOUS: ada-lex.c
ada-lex.o: ada-lex.c
ada-lex.c: ada-lex.l
	@if [ "$(FLEX)" ] && $(FLEX) --version >/dev/null 2>&1; then \
	    echo $(FLEX) -Isit $(srcdir)/ada-lex.l ">" ada-lex.c; \
	    $(FLEX) -Isit $(srcdir)/ada-lex.l > ada-lex.c; \
	elif [ ! -f ada-lex.c -a ! -f $(srcdir)/ada-lex.c ]; then \
	    echo "ada-lex.c missing and flex not available."; \
	    false; \
	elif [ ! -f ada-lex.c ]; then \
	    echo "Warning: ada-lex.c older than ada-lex.l and flex not available."; \
	fi
.PRECIOUS: c-exp.tab.c
c-exp.tab.o: c-exp.tab.c $(defs_h) $(gdb_string_h) $(expression_h) \
	$(value_h) $(parser_defs_h) $(language_h) $(c_lang_h) $(bfd_h) \
	$(symfile_h) $(objfiles_h) $(charset_h) $(block_h)
c-exp.tab.c: c-exp.y
	$(SHELL) $(YLWRAP) "$(YACC)" \
	    $(srcdir)/c-exp.y  y.tab.c c-exp.tmp -- $(YFLAGS) 
	-sed -e '/extern.*malloc/d' \
	     -e '/extern.*realloc/d' \
	     -e '/extern.*free/d' \
	     -e '/include.*malloc.h/d' \
	     -e 's/malloc/xmalloc/g' \
	     -e 's/realloc/xrealloc/g' \
	     -e '/^#line.*y.tab.c/d' \
	  < c-exp.tmp > c-exp.new
	-rm c-exp.tmp
	mv c-exp.new ./c-exp.tab.c
.PRECIOUS: f-exp.tab.c
f-exp.tab.o: f-exp.tab.c $(defs_h) $(gdb_string_h) $(expression_h) \
	$(value_h) $(parser_defs_h) $(language_h) $(f_lang_h) $(bfd_h) \
	$(symfile_h) $(objfiles_h) $(block_h)
f-exp.tab.c: f-exp.y
	$(SHELL) $(YLWRAP) "$(YACC)" \
	    $(srcdir)/f-exp.y  y.tab.c f-exp.tmp -- $(YFLAGS) 
	-sed -e '/extern.*malloc/d' \
	     -e '/extern.*realloc/d' \
	     -e '/extern.*free/d' \
	     -e '/include.*malloc.h/d' \
	     -e 's/malloc/xmalloc/g' \
	     -e 's/realloc/xrealloc/g' \
	     -e '/^#line.*y.tab.c/d' \
	  < f-exp.tmp > f-exp.new
	-rm f-exp.tmp
	mv f-exp.new ./f-exp.tab.c
.PRECIOUS: jv-exp.tab.c
jv-exp.tab.o: jv-exp.tab.c $(defs_h) $(gdb_string_h) $(expression_h) \
	$(value_h) $(parser_defs_h) $(language_h) $(jv_lang_h) $(bfd_h) \
	$(symfile_h) $(objfiles_h) $(block_h)
jv-exp.tab.c: jv-exp.y
	$(SHELL) $(YLWRAP) "$(YACC)" \
	    $(srcdir)/jv-exp.y  y.tab.c jv-exp.tmp -- $(YFLAGS) 
	-sed -e '/extern.*malloc/d' \
	     -e '/extern.*realloc/d' \
	     -e '/extern.*free/d' \
	     -e '/include.*malloc.h/d' \
	     -e 's/malloc/xmalloc/g' \
	     -e 's/realloc/xrealloc/g' \
	     -e '/^#line.*y.tab.c/d' \
	  < jv-exp.tmp > jv-exp.new
	-rm jv-exp.tmp
	mv jv-exp.new ./jv-exp.tab.c
.PRECIOUS: m2-exp.tab.c
m2-exp.tab.o: m2-exp.tab.c $(defs_h) $(gdb_string_h) $(expression_h) \
	$(language_h) $(value_h) $(parser_defs_h) $(m2_lang_h) $(bfd_h) \
	$(symfile_h) $(objfiles_h) $(block_h)
m2-exp.tab.c: m2-exp.y
	$(SHELL) $(YLWRAP) "$(YACC)" \
	    $(srcdir)/m2-exp.y  y.tab.c m2-exp.tmp -- $(YFLAGS) 
	-sed -e '/extern.*malloc/d' \
	     -e '/extern.*realloc/d' \
	     -e '/extern.*free/d' \
	     -e '/include.*malloc.h/d' \
	     -e 's/malloc/xmalloc/g' \
	     -e 's/realloc/xrealloc/g' \
	     -e '/^#line.*y.tab.c/d' \
	  < m2-exp.tmp > m2-exp.new
	-rm m2-exp.tmp
	mv m2-exp.new ./m2-exp.tab.c
.PRECIOUS: objc-exp.tab.c
objc-exp.tab.o: objc-exp.tab.c $(defs_h) $(gdb_string_h) $(expression_h) \
	$(objc_lang_h) $(value_h) $(parser_defs_h) $(language_h) $(c_lang_h) \
	$(bfd_h) $(symfile_h) $(objfiles_h) $(top_h) $(completer_h) \
	$(block_h)
objc-exp.tab.c: objc-exp.y
	$(SHELL) $(YLWRAP) "$(YACC)" \
	    $(srcdir)/objc-exp.y  y.tab.c objc-exp.tmp -- $(YFLAGS) 
	-sed -e '/extern.*malloc/d' \
	     -e '/extern.*realloc/d' \
	     -e '/extern.*free/d' \
	     -e '/include.*malloc.h/d' \
	     -e 's/malloc/xmalloc/g' \
	     -e 's/realloc/xrealloc/g' \
	     -e '/^#line.*y.tab.c/d' \
	  < objc-exp.tmp > objc-exp.new
	-rm objc-exp.tmp
	mv objc-exp.new ./objc-exp.tab.c
.PRECIOUS: p-exp.tab.c
p-exp.tab.o: p-exp.tab.c $(defs_h) $(gdb_string_h) $(expression_h) \
	$(value_h) $(parser_defs_h) $(language_h) $(p_lang_h) $(bfd_h) \
	$(symfile_h) $(objfiles_h) $(block_h)
p-exp.tab.c: p-exp.y
	$(SHELL) $(YLWRAP) "$(YACC)" \
	    $(srcdir)/p-exp.y  y.tab.c p-exp.tmp -- $(YFLAGS) 
	-sed -e '/extern.*malloc/d' \
	     -e '/extern.*realloc/d' \
	     -e '/extern.*free/d' \
	     -e '/include.*malloc.h/d' \
	     -e 's/malloc/xmalloc/g' \
	     -e 's/realloc/xrealloc/g' \
	     -e '/^#line.*y.tab.c/d' \
	  < p-exp.tmp > p-exp.new
	-rm p-exp.tmp
	mv p-exp.new ./p-exp.tab.c

#
# gdb/ dependencies
#

abug-rom.o: abug-rom.c $(defs_h) $(gdbcore_h) $(target_h) $(monitor_h) \
	$(serial_h) $(regcache_h) $(m68k_tdep_h)
ada-lang.o: ada-lang.c $(gdb_string_h) $(demangle_h) $(defs_h) $(symtab_h) \
	$(gdbtypes_h) $(gdbcmd_h) $(expression_h) $(parser_defs_h) \
	$(language_h) $(c_lang_h) $(inferior_h) $(symfile_h) $(objfiles_h) \
	$(breakpoint_h) $(gdbcore_h) $(ada_lang_h) $(ui_out_h) $(block_h) \
	$(infcall_h) $(dictionary_h)
ada-tasks.o: ada-tasks.c $(defs_h) $(command_h) $(value_h) $(language_h) \
	$(inferior_h) $(symtab_h) $(target_h) $(regcache_h) $(gdbcore_h) \
	$(gregset_h) $(ada_lang_h)
ada-typeprint.o: ada-typeprint.c $(defs_h) $(gdb_obstack_h) $(bfd_h) \
	$(symtab_h) $(gdbtypes_h) $(expression_h) $(value_h) $(gdbcore_h) \
	$(target_h) $(command_h) $(gdbcmd_h) $(language_h) $(demangle_h) \
	$(c_lang_h) $(typeprint_h) $(ada_lang_h) $(gdb_string_h)
ada-valprint.o: ada-valprint.c $(defs_h) $(symtab_h) $(gdbtypes_h) \
	$(expression_h) $(value_h) $(demangle_h) $(valprint_h) $(language_h) \
	$(annotate_h) $(ada_lang_h) $(c_lang_h) $(infcall_h)
aix-thread.o: aix-thread.c $(defs_h) $(gdb_assert_h) $(gdbthread_h) \
	$(target_h) $(inferior_h) $(regcache_h) $(gdbcmd_h) $(language_h) \
	$(ppc_tdep_h)
alphabsd-nat.o: alphabsd-nat.c $(defs_h) $(inferior_h) $(regcache_h) \
	$(alpha_tdep_h) $(alphabsd_tdep_h) $(gregset_h)
alphabsd-tdep.o: alphabsd-tdep.c $(defs_h) $(alpha_tdep_h) \
	$(alphabsd_tdep_h)
alphafbsd-tdep.o: alphafbsd-tdep.c $(defs_h) $(value_h) $(osabi_h) \
	$(alpha_tdep_h)
alpha-linux-tdep.o: alpha-linux-tdep.c $(defs_h) $(frame_h) $(gdb_assert_h) \
	$(osabi_h) $(alpha_tdep_h)
alpha-mdebug-tdep.o: alpha-mdebug-tdep.c $(defs_h) $(frame_h) \
	$(frame_unwind_h) $(frame_base_h) $(symtab_h) $(gdbcore_h) \
	$(block_h) $(gdb_assert_h) $(alpha_tdep_h)
alpha-nat.o: alpha-nat.c $(defs_h) $(gdb_string_h) $(inferior_h) \
	$(gdbcore_h) $(target_h) $(regcache_h) $(alpha_tdep_h) $(gregset_h)
alphanbsd-tdep.o: alphanbsd-tdep.c $(defs_h) $(gdbcore_h) $(frame_h) \
	$(regcache_h) $(value_h) $(osabi_h) $(solib_svr4_h) $(alpha_tdep_h) \
	$(alphabsd_tdep_h) $(nbsd_tdep_h)
alpha-osf1-tdep.o: alpha-osf1-tdep.c $(defs_h) $(frame_h) $(gdbcore_h) \
	$(value_h) $(osabi_h) $(gdb_string_h) $(objfiles_h) $(alpha_tdep_h)
alpha-tdep.o: alpha-tdep.c $(defs_h) $(doublest_h) $(frame_h) \
	$(frame_unwind_h) $(frame_base_h) $(dwarf2_frame_h) $(inferior_h) \
	$(symtab_h) $(value_h) $(gdbcmd_h) $(gdbcore_h) $(dis_asm_h) \
	$(symfile_h) $(objfiles_h) $(gdb_string_h) $(linespec_h) \
	$(regcache_h) $(reggroups_h) $(arch_utils_h) $(osabi_h) $(block_h) \
	$(elf_bfd_h) $(alpha_tdep_h)
amd64fbsd-nat.o: amd64fbsd-nat.o $(defs_h) $(inferior_h) $(regcache_h) \
	$(gdb_assert_h) $(gregset_h) $(x86_64_tdep_h)
amd64fbsd-tdep.o: amd64fbsd-tdep.o $(defs_h) $(arch_utils_h) $(frame_h) \
	$(gdbcore_h) $(regcache_h) $(osabi_h) $(gdb_string_h) \
	$(x86_64_tdep_h)
annotate.o: annotate.c $(defs_h) $(annotate_h) $(value_h) $(target_h) \
	$(gdbtypes_h) $(breakpoint_h)
arch-utils.o: arch-utils.c $(defs_h) $(arch_utils_h) $(gdbcmd_h) \
	$(inferior_h) $(symtab_h) $(frame_h) $(inferior_h) $(breakpoint_h) \
	$(gdb_wait_h) $(gdbcore_h) $(gdbcmd_h) $(target_h) $(annotate_h) \
	$(gdb_string_h) $(regcache_h) $(gdb_assert_h) $(sim_regno_h) \
	$(version_h) $(floatformat_h)
arm-linux-nat.o: arm-linux-nat.c $(defs_h) $(inferior_h) $(gdbcore_h) \
	$(gdb_string_h) $(regcache_h) $(arm_tdep_h) $(gregset_h)
arm-linux-tdep.o: arm-linux-tdep.c $(defs_h) $(target_h) $(value_h) \
	$(gdbtypes_h) $(floatformat_h) $(gdbcore_h) $(frame_h) $(regcache_h) \
	$(doublest_h) $(solib_svr4_h) $(osabi_h) $(arm_tdep_h) $(symtab_h) \
	$(symfile_h) $(objfiles_h)
armnbsd-nat.o: armnbsd-nat.c $(defs_h) $(arm_tdep_h) $(inferior_h) \
	$(regcache_h) $(gdbcore_h)
armnbsd-tdep.o: armnbsd-tdep.c $(defs_h) $(osabi_h) $(arm_tdep_h) \
	$(nbsd_tdep_h) $(solib_svr4_h)
arm-tdep.o: arm-tdep.c $(defs_h) $(frame_h) $(inferior_h) $(gdbcmd_h) \
	$(gdbcore_h) $(symfile_h) $(gdb_string_h) $(dis_asm_h) $(regcache_h) \
	$(doublest_h) $(value_h) $(arch_utils_h) $(osabi_h) $(arm_tdep_h) \
	$(gdb_sim_arm_h) $(elf_bfd_h) $(coff_internal_h) $(elf_arm_h) \
	$(gdb_assert_h) $(bfd_in2_h) $(libcoff_h)
avr-tdep.o: avr-tdep.c $(defs_h) $(frame_h) $(frame_unwind_h) \
	$(frame_base_h) $(trad_frame_h) $(gdbcmd_h) $(gdbcore_h) \
	$(inferior_h) $(symfile_h) $(arch_utils_h) $(regcache_h) \
	$(gdb_string_h)
ax-gdb.o: ax-gdb.c $(defs_h) $(symtab_h) $(symfile_h) $(gdbtypes_h) \
	$(value_h) $(expression_h) $(command_h) $(gdbcmd_h) $(frame_h) \
	$(target_h) $(ax_h) $(ax_gdb_h) $(gdb_string_h) $(block_h) \
	$(regcache_h)
ax-general.o: ax-general.c $(defs_h) $(ax_h) $(value_h) $(gdb_string_h)
bcache.o: bcache.c $(defs_h) $(gdb_obstack_h) $(bcache_h) $(gdb_string_h)
block.o: block.c $(defs_h) $(block_h) $(symtab_h) $(symfile_h) \
	$(gdb_obstack_h) $(cp_support_h)
blockframe.o: blockframe.c $(defs_h) $(symtab_h) $(bfd_h) $(symfile_h) \
	$(objfiles_h) $(frame_h) $(gdbcore_h) $(value_h) $(target_h) \
	$(inferior_h) $(annotate_h) $(regcache_h) $(gdb_assert_h) \
	$(dummy_frame_h) $(command_h) $(gdbcmd_h) $(block_h)
breakpoint.o: breakpoint.c $(defs_h) $(symtab_h) $(frame_h) $(breakpoint_h) \
	$(gdbtypes_h) $(expression_h) $(gdbcore_h) $(gdbcmd_h) $(value_h) \
	$(command_h) $(inferior_h) $(gdbthread_h) $(target_h) $(language_h) \
	$(gdb_string_h) $(demangle_h) $(annotate_h) $(symfile_h) \
	$(objfiles_h) $(source_h) $(linespec_h) $(completer_h) $(gdb_h) \
	$(ui_out_h) $(cli_script_h) $(gdb_assert_h) $(block_h) \
	$(gdb_events_h)
buildsym.o: buildsym.c $(defs_h) $(bfd_h) $(gdb_obstack_h) $(symtab_h) \
	$(symfile_h) $(objfiles_h) $(gdbtypes_h) $(gdb_assert_h) \
	$(complaints_h) $(gdb_string_h) $(expression_h) $(language_h) \
	$(bcache_h) $(filenames_h) $(macrotab_h) $(demangle_h) $(block_h) \
	$(cp_support_h) $(dictionary_h) $(buildsym_h) $(stabsread_h)
builtin-regs.o: builtin-regs.c $(defs_h) $(builtin_regs_h) $(gdbtypes_h) \
	$(gdb_string_h) $(gdb_assert_h)
charset.o: charset.c $(defs_h) $(charset_h) $(gdbcmd_h) $(gdb_assert_h) \
	$(gdb_string_h)
c-lang.o: c-lang.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(expression_h) \
	$(parser_defs_h) $(language_h) $(c_lang_h) $(valprint_h) \
	$(macroscope_h) $(gdb_assert_h) $(charset_h) $(gdb_string_h) \
	$(demangle_h) $(cp_support_h)
cli-out.o: cli-out.c $(defs_h) $(ui_out_h) $(cli_out_h) $(gdb_string_h) \
	$(gdb_assert_h)
coff-pe-read.o: coff-pe-read.c $(coff_pe_read_h) $(bfd_h) $(defs_h) \
	$(gdbtypes_h) $(symtab_h) $(symfile_h) $(objfiles_h)
coffread.o: coffread.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(demangle_h) \
	$(breakpoint_h) $(bfd_h) $(gdb_obstack_h) $(gdb_string_h) \
	$(coff_internal_h) $(libcoff_h) $(symfile_h) $(objfiles_h) \
	$(buildsym_h) $(gdb_stabs_h) $(stabsread_h) $(complaints_h) \
	$(target_h) $(gdb_assert_h) $(block_h) $(dictionary_h) \
	$(coff_pe_read_h)
coff-solib.o: coff-solib.c $(defs_h) $(frame_h) $(bfd_h) $(gdbcore_h) \
	$(symtab_h) $(symfile_h) $(objfiles_h)
complaints.o: complaints.c $(defs_h) $(complaints_h) $(gdb_assert_h) \
	$(command_h) $(gdbcmd_h)
completer.o: completer.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(expression_h) \
	$(filenames_h) $(cli_decode_h) $(gdbcmd_h) $(completer_h)
copying.o: copying.c $(defs_h) $(command_h) $(gdbcmd_h)
core-aout.o: core-aout.c $(defs_h) $(gdbcore_h) $(value_h) $(regcache_h) \
	$(gdb_dirent_h) $(gdb_stat_h)
corefile.o: corefile.c $(defs_h) $(gdb_string_h) $(inferior_h) $(symtab_h) \
	$(command_h) $(gdbcmd_h) $(bfd_h) $(target_h) $(gdbcore_h) \
	$(dis_asm_h) $(gdb_stat_h) $(completer_h)
corelow.o: corelow.c $(defs_h) $(gdb_string_h) $(frame_h) $(inferior_h) \
	$(symtab_h) $(command_h) $(bfd_h) $(target_h) $(gdbcore_h) \
	$(gdbthread_h) $(regcache_h) $(symfile_h)
core-regset.o: core-regset.c $(defs_h) $(command_h) $(gdbcore_h) \
	$(inferior_h) $(target_h) $(gdb_string_h) $(gregset_h)
core-sol2.o: core-sol2.c $(defs_h) $(gdb_string_h) $(regcache_h) \
	$(inferior_h) $(target_h) $(command_h) $(gdbcore_h) $(gregset_h)
cp-abi.o: cp-abi.c $(defs_h) $(value_h) $(cp_abi_h) $(command_h) $(gdbcmd_h) \
	$(ui_out_h) $(gdb_string_h)
cp-namespace.o: cp-namespace.c $(defs_h) $(cp_support_h) $(gdb_obstack_h) \
	$(symtab_h) $(symfile_h) $(gdb_assert_h) $(block_h)
cp-support.o: cp-support.c $(defs_h) $(cp_support_h) $(gdb_string_h) \
	$(demangle_h) $(gdb_assert_h) $(gdbcmd_h) $(dictionary_h) \
	$(objfiles_h) $(frame_h) $(symtab_h) $(block_h) $(complaints_h)
cpu32bug-rom.o: cpu32bug-rom.c $(defs_h) $(gdbcore_h) $(target_h) \
	$(monitor_h) $(serial_h) $(regcache_h) $(m68k_tdep_h)
cp-valprint.o: cp-valprint.c $(defs_h) $(gdb_obstack_h) $(symtab_h) \
	$(gdbtypes_h) $(expression_h) $(value_h) $(command_h) $(gdbcmd_h) \
	$(demangle_h) $(annotate_h) $(gdb_string_h) $(c_lang_h) $(target_h) \
	$(cp_abi_h) $(valprint_h)
cris-tdep.o: cris-tdep.c $(defs_h) $(frame_h) $(symtab_h) $(inferior_h) \
	$(gdbtypes_h) $(gdbcore_h) $(gdbcmd_h) $(target_h) $(value_h) \
	$(opcode_cris_h) $(arch_utils_h) $(regcache_h) $(symfile_h) \
	$(solib_h) $(solib_svr4_h) $(gdb_string_h)
c-typeprint.o: c-typeprint.c $(defs_h) $(gdb_obstack_h) $(bfd_h) $(symtab_h) \
	$(gdbtypes_h) $(expression_h) $(value_h) $(gdbcore_h) $(target_h) \
	$(language_h) $(demangle_h) $(c_lang_h) $(typeprint_h) $(cp_abi_h) \
	$(gdb_string_h)
c-valprint.o: c-valprint.c $(defs_h) $(gdb_string_h) $(symtab_h) \
	$(gdbtypes_h) $(expression_h) $(value_h) $(valprint_h) $(language_h) \
	$(c_lang_h) $(cp_abi_h)
d10v-tdep.o: d10v-tdep.c $(defs_h) $(frame_h) $(frame_unwind_h) \
	$(frame_base_h) $(symtab_h) $(gdbtypes_h) $(gdbcmd_h) $(gdbcore_h) \
	$(gdb_string_h) $(value_h) $(inferior_h) $(dis_asm_h) $(symfile_h) \
	$(objfiles_h) $(language_h) $(arch_utils_h) $(regcache_h) \
	$(remote_h) $(floatformat_h) $(gdb_sim_d10v_h) $(sim_regno_h) \
	$(disasm_h) $(trad_frame_h) $(gdb_assert_h)
dbug-rom.o: dbug-rom.c $(defs_h) $(gdbcore_h) $(target_h) $(monitor_h) \
	$(serial_h) $(regcache_h) $(m68k_tdep_h)
dbxread.o: dbxread.c $(defs_h) $(gdb_string_h) $(gdb_obstack_h) \
	$(gdb_stat_h) $(symtab_h) $(breakpoint_h) $(target_h) $(gdbcore_h) \
	$(libaout_h) $(symfile_h) $(objfiles_h) $(buildsym_h) $(stabsread_h) \
	$(gdb_stabs_h) $(demangle_h) $(language_h) $(complaints_h) \
	$(cp_abi_h) $(aout_aout64_h) $(aout_stab_gnu_h)
dcache.o: dcache.c $(defs_h) $(dcache_h) $(gdbcmd_h) $(gdb_string_h) \
	$(gdbcore_h) $(target_h)
delta68-nat.o: delta68-nat.c $(defs_h)
demangle.o: demangle.c $(defs_h) $(command_h) $(gdbcmd_h) $(demangle_h) \
	$(gdb_string_h)
dictionary.o: dictionary.c $(defs_h) $(gdb_obstack_h) $(symtab_h) \
	$(buildsym_h) $(gdb_assert_h) $(dictionary_h)
dink32-rom.o: dink32-rom.c $(defs_h) $(gdbcore_h) $(target_h) $(monitor_h) \
	$(serial_h) $(symfile_h) $(inferior_h) $(regcache_h)
disasm.o: disasm.c $(defs_h) $(target_h) $(value_h) $(ui_out_h) \
	$(gdb_string_h) $(disasm_h) $(gdbcore_h)
doublest.o: doublest.c $(defs_h) $(doublest_h) $(floatformat_h) \
	$(gdb_assert_h) $(gdb_string_h) $(gdbtypes_h)
dpx2-nat.o: dpx2-nat.c $(defs_h) $(gdbcore_h) $(gdb_string_h)
dsrec.o: dsrec.c $(defs_h) $(serial_h) $(srec_h)
dummy-frame.o: dummy-frame.c $(defs_h) $(dummy_frame_h) $(regcache_h) \
	$(frame_h) $(inferior_h) $(gdb_assert_h) $(frame_unwind_h) \
	$(command_h) $(gdbcmd_h)
dve3900-rom.o: dve3900-rom.c $(defs_h) $(gdbcore_h) $(target_h) $(monitor_h) \
	$(serial_h) $(inferior_h) $(command_h) $(gdb_string_h) $(regcache_h)
dwarf2expr.o: dwarf2expr.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(value_h) \
	$(gdbcore_h) $(elf_dwarf2_h) $(dwarf2expr_h)
dwarf2-frame.o: dwarf2-frame.c $(defs_h) $(dwarf2expr_h) $(elf_dwarf2_h) \
	$(frame_h) $(frame_base_h) $(frame_unwind_h) $(gdbcore_h) \
	$(gdbtypes_h) $(symtab_h) $(objfiles_h) $(regcache_h) \
	$(gdb_assert_h) $(gdb_string_h) $(complaints_h) $(dwarf2_frame_h)
dwarf2loc.o: dwarf2loc.c $(defs_h) $(ui_out_h) $(value_h) $(frame_h) \
	$(gdbcore_h) $(target_h) $(inferior_h) $(ax_h) $(ax_gdb_h) \
	$(regcache_h) $(objfiles_h) $(elf_dwarf2_h) $(dwarf2expr_h) \
	$(dwarf2loc_h) $(gdb_string_h)
dwarf2read.o: dwarf2read.c $(defs_h) $(bfd_h) $(symtab_h) $(gdbtypes_h) \
	$(symfile_h) $(objfiles_h) $(elf_dwarf2_h) $(buildsym_h) \
	$(demangle_h) $(expression_h) $(filenames_h) $(macrotab_h) \
	$(language_h) $(complaints_h) $(bcache_h) $(dwarf2expr_h) \
	$(dwarf2loc_h) $(cp_support_h) $(gdb_string_h) $(gdb_assert_h)
dwarfread.o: dwarfread.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(symfile_h) \
	$(objfiles_h) $(elf_dwarf_h) $(buildsym_h) $(demangle_h) \
	$(expression_h) $(language_h) $(complaints_h) $(gdb_string_h)
elfread.o: elfread.c $(defs_h) $(bfd_h) $(gdb_string_h) $(elf_bfd_h) \
	$(elf_mips_h) $(symtab_h) $(symfile_h) $(objfiles_h) $(buildsym_h) \
	$(stabsread_h) $(gdb_stabs_h) $(complaints_h) $(demangle_h)
environ.o: environ.c $(defs_h) $(environ_h) $(gdb_string_h)
eval.o: eval.c $(defs_h) $(gdb_string_h) $(symtab_h) $(gdbtypes_h) \
	$(value_h) $(expression_h) $(target_h) $(frame_h) $(language_h) \
	$(f_lang_h) $(cp_abi_h) $(infcall_h) $(objc_lang_h) $(block_h)
event-loop.o: event-loop.c $(defs_h) $(event_loop_h) $(event_top_h) \
	$(gdb_string_h)
event-top.o: event-top.c $(defs_h) $(top_h) $(inferior_h) $(target_h) \
	$(terminal_h) $(event_loop_h) $(event_top_h) $(interps_h) \
	$(gdbcmd_h)
exec.o: exec.c $(defs_h) $(frame_h) $(inferior_h) $(target_h) $(gdbcmd_h) \
	$(language_h) $(symfile_h) $(objfiles_h) $(completer_h) $(value_h) \
	$(gdb_string_h) $(gdbcore_h) $(gdb_stat_h) $(xcoffsolib_h)
expprint.o: expprint.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(expression_h) \
	$(value_h) $(language_h) $(parser_defs_h) $(frame_h) $(target_h) \
	$(gdb_string_h) $(block_h)
fbsd-proc.o: fbsd-proc.c $(defs_h) $(gdbcore_h) $(inferior_h) \
	$(gdb_string_h) $(elf_bfd_h) $(gregset_h)
findvar.o: findvar.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(frame_h) \
	$(value_h) $(gdbcore_h) $(inferior_h) $(target_h) $(gdb_string_h) \
	$(gdb_assert_h) $(floatformat_h) $(symfile_h) $(regcache_h) \
	$(builtin_regs_h) $(block_h)
f-lang.o: f-lang.c $(defs_h) $(gdb_string_h) $(symtab_h) $(gdbtypes_h) \
	$(expression_h) $(parser_defs_h) $(language_h) $(f_lang_h) \
	$(valprint_h) $(value_h)
fork-child.o: fork-child.c $(defs_h) $(gdb_string_h) $(frame_h) \
	$(inferior_h) $(target_h) $(gdb_wait_h) $(gdb_vfork_h) $(gdbcore_h) \
	$(terminal_h) $(gdbthread_h) $(command_h)
frame-base.o: frame-base.c $(defs_h) $(frame_base_h) $(frame_h)
frame.o: frame.c $(defs_h) $(frame_h) $(target_h) $(value_h) $(inferior_h) \
	$(regcache_h) $(gdb_assert_h) $(gdb_string_h) $(builtin_regs_h) \
	$(gdb_obstack_h) $(dummy_frame_h) $(sentinel_frame_h) $(gdbcore_h) \
	$(annotate_h) $(language_h) $(frame_unwind_h) $(frame_base_h) \
	$(command_h) $(gdbcmd_h)
frame-unwind.o: frame-unwind.c $(defs_h) $(frame_h) $(frame_unwind_h) \
	$(gdb_assert_h) $(dummy_frame_h)
frv-tdep.o: frv-tdep.c $(defs_h) $(inferior_h) $(symfile_h) $(gdbcore_h) \
	$(arch_utils_h) $(regcache_h)
f-typeprint.o: f-typeprint.c $(defs_h) $(gdb_obstack_h) $(bfd_h) $(symtab_h) \
	$(gdbtypes_h) $(expression_h) $(value_h) $(gdbcore_h) $(target_h) \
	$(f_lang_h) $(gdb_string_h)
f-valprint.o: f-valprint.c $(defs_h) $(gdb_string_h) $(symtab_h) \
	$(gdbtypes_h) $(expression_h) $(value_h) $(valprint_h) $(language_h) \
	$(f_lang_h) $(frame_h) $(gdbcore_h) $(command_h) $(block_h)
gcore.o: gcore.c $(defs_h) $(cli_decode_h) $(inferior_h) $(gdbcore_h) \
	$(elf_bfd_h) $(symfile_h) $(objfiles_h) $(infcall_h)
gdbarch.o: gdbarch.c $(defs_h) $(arch_utils_h) $(gdbcmd_h) $(inferior_h) \
	$(gdb_string_h) $(symtab_h) $(frame_h) $(inferior_h) $(breakpoint_h) \
	$(gdb_wait_h) $(gdbcore_h) $(gdbcmd_h) $(target_h) $(gdbthread_h) \
	$(annotate_h) $(symfile_h) $(value_h) $(symcat_h) $(floatformat_h) \
	$(gdb_assert_h) $(gdb_string_h) $(gdb_events_h) $(reggroups_h) \
	$(osabi_h) $(symfile_h)
gdb.o: gdb.c $(defs_h) $(main_h) $(gdb_string_h) $(interps_h)
gdb-events.o: gdb-events.c $(defs_h) $(gdb_events_h) $(gdbcmd_h)
gdbtypes.o: gdbtypes.c $(defs_h) $(gdb_string_h) $(bfd_h) $(symtab_h) \
	$(symfile_h) $(objfiles_h) $(gdbtypes_h) $(expression_h) \
	$(language_h) $(target_h) $(value_h) $(demangle_h) $(complaints_h) \
	$(gdbcmd_h) $(wrapper_h) $(cp_abi_h) $(gdb_assert_h)
gnu-nat.o: gnu-nat.c $(gdb_string_h) $(defs_h) $(inferior_h) $(symtab_h) \
	$(value_h) $(language_h) $(target_h) $(gdb_wait_h) $(gdbcmd_h) \
	$(gdbcore_h) $(gdbthread_h) $(gdb_assert_h) $(gdb_obstack_h) \
	$(gnu_nat_h) $(exc_request_S_h) $(notify_S_h) $(process_reply_S_h) \
	$(msg_reply_S_h) $(exc_request_U_h) $(msg_U_h)
gnu-v2-abi.o: gnu-v2-abi.c $(defs_h) $(gdb_string_h) $(symtab_h) \
	$(gdbtypes_h) $(value_h) $(demangle_h) $(cp_abi_h)
gnu-v3-abi.o: gnu-v3-abi.c $(defs_h) $(value_h) $(cp_abi_h) $(demangle_h) \
	$(gdb_assert_h) $(gdb_string_h)
go32-nat.o: go32-nat.c $(defs_h) $(inferior_h) $(gdb_wait_h) $(gdbcore_h) \
	$(command_h) $(gdbcmd_h) $(floatformat_h) $(buildsym_h) \
	$(i387_tdep_h) $(i386_tdep_h) $(value_h) $(regcache_h) \
	$(gdb_string_h)
h8300-tdep.o: h8300-tdep.c $(defs_h) $(value_h) $(inferior_h) $(symfile_h) \
	$(arch_utils_h) $(regcache_h) $(gdbcore_h) $(objfiles_h) $(gdbcmd_h) \
	$(gdb_assert_h)
# OBSOLETE h8500-tdep.o: h8500-tdep.c
hpacc-abi.o: hpacc-abi.c $(defs_h) $(value_h) $(gdb_regex_h) $(gdb_string_h) \
	$(gdbtypes_h) $(gdbcore_h) $(cp_abi_h)
hppab-nat.o: hppab-nat.c $(defs_h) $(inferior_h) $(target_h) $(regcache_h)
hppah-nat.o: hppah-nat.c $(defs_h) $(inferior_h) $(target_h) $(gdbcore_h) \
	$(gdb_wait_h) $(regcache_h) $(gdb_string_h)
hppa-hpux-tdep.o: hppa-hpux-tdep.c $(defs_h) $(arch_utils_h) $(gdbcore_h) \
	$(osabi_h) $(gdb_string_h) $(frame_h)
hppam3-nat.o: hppam3-nat.c $(defs_h) $(inferior_h) $(floatformat_h) \
	$(regcache_h)
hppa-tdep.o: hppa-tdep.c $(defs_h) $(frame_h) $(bfd_h) $(inferior_h) \
	$(value_h) $(regcache_h) $(completer_h) $(language_h) $(osabi_h) \
	$(gdb_assert_h) $(infttrace_h) $(symtab_h) $(infcall_h) \
	$(a_out_encap_h) $(gdb_stat_h) $(gdb_wait_h) $(gdbcore_h) \
	$(gdbcmd_h) $(target_h) $(symfile_h) $(objfiles_h)
hpread.o: hpread.c $(defs_h) $(bfd_h) $(gdb_string_h) $(hp_symtab_h) \
	$(syms_h) $(symtab_h) $(symfile_h) $(objfiles_h) $(buildsym_h) \
	$(complaints_h) $(gdb_stabs_h) $(gdbtypes_h) $(demangle_h) \
	$(somsolib_h) $(gdb_assert_h) $(gdb_string_h)
hpux-thread.o: hpux-thread.c $(defs_h) $(gdbthread_h) $(target_h) \
	$(inferior_h) $(regcache_h) $(gdb_stat_h) $(gdbcore_h)
i386b-nat.o: i386b-nat.c $(defs_h)
i386bsd-nat.o: i386bsd-nat.c $(defs_h) $(inferior_h) $(regcache_h) \
	$(gdb_assert_h) $(gregset_h) $(i386_tdep_h) $(i387_tdep_h)
i386bsd-tdep.o: i386bsd-tdep.c $(defs_h) $(arch_utils_h) $(frame_h) \
	$(gdbcore_h) $(regcache_h) $(osabi_h) $(gdb_string_h) $(i386_tdep_h)
i386-cygwin-tdep.o: i386-cygwin-tdep.c $(defs_h) $(osabi_h) $(gdb_string_h) \
	$(i386_tdep_h)
i386fbsd-nat.o: i386fbsd-nat.c $(defs_h) $(inferior_h) $(regcache_h)
i386gnu-nat.o: i386gnu-nat.c $(defs_h) $(inferior_h) $(floatformat_h) \
	$(regcache_h) $(gdb_assert_h) $(i386_tdep_h) $(gnu_nat_h) \
	$(i387_tdep_h) $(gregset_h)
i386gnu-tdep.o: i386gnu-tdep.c $(defs_h) $(osabi_h) $(i386_tdep_h)
i386-interix-nat.o: i386-interix-nat.c $(defs_h) $(gdb_string_h) \
	$(gdbcore_h) $(gregset_h) $(regcache_h)
i386-interix-tdep.o: i386-interix-tdep.c $(defs_h) $(arch_utils_h) \
	$(frame_h) $(gdb_string_h) $(gdb_stabs_h) $(gdbcore_h) $(gdbtypes_h) \
	$(i386_tdep_h) $(inferior_h) $(libbfd_h) $(objfiles_h) $(osabi_h) \
	$(regcache_h)
i386-linux-nat.o: i386-linux-nat.c $(defs_h) $(inferior_h) $(gdbcore_h) \
	$(regcache_h) $(gdb_assert_h) $(gdb_string_h) $(gregset_h) \
	$(i387_tdep_h) $(i386_tdep_h) $(i386_linux_tdep_h) \
	$(gdb_proc_service_h) $(linux_nat_h)
i386-linux-tdep.o: i386-linux-tdep.c $(defs_h) $(gdbcore_h) $(frame_h) \
	$(value_h) $(regcache_h) $(inferior_h) $(reggroups_h) $(symtab_h) \
	$(symfile_h) $(objfiles_h) $(solib_svr4_h) $(osabi_h) $(i386_tdep_h) \
	$(i386_linux_tdep_h)
i386ly-tdep.o: i386ly-tdep.c $(defs_h) $(gdbcore_h) $(inferior_h) \
	$(regcache_h) $(target_h) $(osabi_h) $(i386_tdep_h)
i386-nat.o: i386-nat.c $(defs_h) $(breakpoint_h) $(command_h) $(gdbcmd_h)
i386nbsd-tdep.o: i386nbsd-tdep.c $(defs_h) $(gdbtypes_h) $(gdbcore_h) \
	$(regcache_h) $(arch_utils_h) $(osabi_h) $(i386_tdep_h) \
	$(i387_tdep_h) $(nbsd_tdep_h) $(solib_svr4_h)
i386-nto-tdep.o: i386-nto-tdep.c $(gdb_string_h) $(gdb_assert_h) $(defs_h) \
	$(frame_h) $(target_h) $(regcache_h) $(solib_svr4_h) $(i386_tdep_h) \
	$(nto_tdep_h) $(osabi_h) $(i387_tdep_h)
i386obsd-nat.o: i386obsd-nat.c $(defs_h)
i386obsd-tdep.o: i386obsd-tdep.c $(defs_h) $(arch_utils_h) $(gdbcore_h) \
	$(regcache_h) $(osabi_h) $(i386_tdep_h) $(i387_tdep_h)
i386-sol2-tdep.o: i386-sol2-tdep.c $(defs_h) $(value_h) $(osabi_h) \
	$(i386_tdep_h)
i386-stub.o: i386-stub.c
i386-tdep.o: i386-tdep.c $(defs_h) $(arch_utils_h) $(command_h) \
	$(dummy_frame_h) $(dwarf2_frame_h) $(doublest_h) $(floatformat_h) \
	$(frame_h) $(frame_base_h) $(frame_unwind_h) $(inferior_h) \
	$(gdbcmd_h) $(gdbcore_h) $(objfiles_h) $(osabi_h) $(regcache_h) \
	$(reggroups_h) $(symfile_h) $(symtab_h) $(target_h) $(value_h) \
	$(gdb_assert_h) $(gdb_string_h) $(i386_tdep_h) $(i387_tdep_h)
i386v4-nat.o: i386v4-nat.c $(defs_h) $(value_h) $(inferior_h) $(regcache_h) \
	$(i386_tdep_h) $(i387_tdep_h) $(gregset_h)
i386v-nat.o: i386v-nat.c $(defs_h) $(frame_h) $(inferior_h) $(language_h) \
	$(gdbcore_h) $(gdb_stat_h) $(floatformat_h) $(target_h) \
	$(i386_tdep_h)
i387-tdep.o: i387-tdep.c $(defs_h) $(doublest_h) $(floatformat_h) $(frame_h) \
	$(gdbcore_h) $(inferior_h) $(language_h) $(regcache_h) $(value_h) \
	$(gdb_assert_h) $(gdb_string_h) $(i386_tdep_h) $(i387_tdep_h)
ia64-aix-nat.o: ia64-aix-nat.c $(defs_h) $(inferior_h) $(target_h) \
	$(gdbcore_h) $(regcache_h) $(symtab_h) $(bfd_h) $(symfile_h) \
	$(objfiles_h) $(gdb_stat_h)
ia64-aix-tdep.o: ia64-aix-tdep.c $(defs_h)
ia64-linux-nat.o: ia64-linux-nat.c $(defs_h) $(gdb_string_h) $(inferior_h) \
	$(target_h) $(gdbcore_h) $(regcache_h) $(gdb_wait_h) $(gregset_h)
ia64-linux-tdep.o: ia64-linux-tdep.c $(defs_h) $(arch_utils_h)
ia64-tdep.o: ia64-tdep.c $(defs_h) $(inferior_h) $(symfile_h) $(gdbcore_h) \
	$(arch_utils_h) $(floatformat_h) $(regcache_h) $(doublest_h) \
	$(value_h) $(gdb_assert_h) $(objfiles_h) $(elf_common_h) \
	$(elf_bfd_h)
infcall.o: infcall.c $(defs_h) $(breakpoint_h) $(target_h) $(regcache_h) \
	$(inferior_h) $(gdb_assert_h) $(block_h) $(gdbcore_h) $(language_h) \
	$(symfile_h) $(gdbcmd_h) $(command_h) $(gdb_string_h) $(infcall_h)
infcmd.o: infcmd.c $(defs_h) $(gdb_string_h) $(symtab_h) $(gdbtypes_h) \
	$(frame_h) $(inferior_h) $(environ_h) $(value_h) $(gdbcmd_h) \
	$(symfile_h) $(gdbcore_h) $(target_h) $(language_h) $(symfile_h) \
	$(objfiles_h) $(completer_h) $(ui_out_h) $(event_top_h) \
	$(parser_defs_h) $(regcache_h) $(reggroups_h) $(block_h)
inf-loop.o: inf-loop.c $(defs_h) $(inferior_h) $(target_h) $(event_loop_h) \
	$(event_top_h) $(inf_loop_h) $(remote_h)
inflow.o: inflow.c $(defs_h) $(frame_h) $(inferior_h) $(command_h) \
	$(serial_h) $(terminal_h) $(target_h) $(gdbthread_h) $(gdb_string_h) \
	$(inflow_h)
infptrace.o: infptrace.c $(defs_h) $(frame_h) $(inferior_h) $(target_h) \
	$(gdb_string_h) $(regcache_h) $(gdb_wait_h) $(command_h) \
	$(gdb_dirent_h) $(gdbcore_h) $(gdb_stat_h)
infrun.o: infrun.c $(defs_h) $(gdb_string_h) $(symtab_h) $(frame_h) \
	$(inferior_h) $(breakpoint_h) $(gdb_wait_h) $(gdbcore_h) $(gdbcmd_h) \
	$(cli_script_h) $(target_h) $(gdbthread_h) $(annotate_h) \
	$(symfile_h) $(top_h) $(inf_loop_h) $(regcache_h) $(value_h) \
	$(observer_h) $(language_h)
inftarg.o: inftarg.c $(defs_h) $(frame_h) $(inferior_h) $(target_h) \
	$(gdbcore_h) $(command_h) $(gdb_stat_h) $(gdb_wait_h) $(inflow_h)
infttrace.o: infttrace.c $(defs_h) $(frame_h) $(inferior_h) $(target_h) \
	$(gdb_string_h) $(gdb_wait_h) $(command_h) $(gdbthread_h) \
	$(gdbcore_h)
interps.o: interps.c $(defs_h) $(gdbcmd_h) $(ui_out_h) $(event_loop_h) \
	$(event_top_h) $(interps_h) $(completer_h) $(gdb_string_h) \
	$(gdb_events_h) $(gdb_assert_h) $(top_h)
irix4-nat.o: irix4-nat.c $(defs_h) $(inferior_h) $(gdbcore_h) $(regcache_h) \
	$(gregset_h)
irix5-nat.o: irix5-nat.c $(defs_h) $(inferior_h) $(gdbcore_h) $(target_h) \
	$(regcache_h) $(gdb_string_h) $(gregset_h)
jv-lang.o: jv-lang.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(expression_h) \
	$(parser_defs_h) $(language_h) $(gdbtypes_h) $(symtab_h) \
	$(symfile_h) $(objfiles_h) $(gdb_string_h) $(value_h) $(c_lang_h) \
	$(jv_lang_h) $(gdbcore_h) $(block_h) $(demangle_h) $(dictionary_h)
jv-typeprint.o: jv-typeprint.c $(defs_h) $(symtab_h) $(gdbtypes_h) \
	$(value_h) $(demangle_h) $(jv_lang_h) $(gdb_string_h) $(typeprint_h) \
	$(c_lang_h) $(cp_abi_h)
jv-valprint.o: jv-valprint.c $(defs_h) $(symtab_h) $(gdbtypes_h) \
	$(gdbcore_h) $(expression_h) $(value_h) $(demangle_h) $(valprint_h) \
	$(language_h) $(jv_lang_h) $(c_lang_h) $(annotate_h) $(gdb_string_h)
kod.o: kod.c $(defs_h) $(command_h) $(gdbcmd_h) $(target_h) $(gdb_string_h) \
	$(kod_h)
kod-cisco.o: kod-cisco.c $(defs_h) $(gdb_string_h) $(kod_h)
language.o: language.c $(defs_h) $(gdb_string_h) $(symtab_h) $(gdbtypes_h) \
	$(value_h) $(gdbcmd_h) $(expression_h) $(language_h) $(target_h) \
	$(parser_defs_h) $(jv_lang_h) $(demangle_h)
linespec.o: linespec.c $(defs_h) $(symtab_h) $(frame_h) $(command_h) \
	$(symfile_h) $(objfiles_h) $(source_h) $(demangle_h) $(value_h) \
	$(completer_h) $(cp_abi_h) $(parser_defs_h) $(block_h) \
	$(objc_lang_h) $(linespec_h)
lin-lwp.o: lin-lwp.c $(defs_h) $(gdb_assert_h) $(gdb_string_h) $(gdb_wait_h) \
	$(gdbthread_h) $(inferior_h) $(target_h) $(regcache_h) $(gdbcmd_h) \
	$(linux_nat_h)
linux-nat.o: linux-nat.c $(defs_h) $(inferior_h) $(target_h) $(gdb_wait_h) \
	$(linux_nat_h)
linux-proc.o: linux-proc.c $(defs_h) $(inferior_h) $(gdb_stat_h) \
	$(regcache_h) $(gregset_h) $(gdbcore_h) $(gdbthread_h) $(elf_bfd_h) \
	$(cli_decode_h) $(gdb_string_h) $(linux_nat_h)
lynx-nat.o: lynx-nat.c $(defs_h) $(frame_h) $(inferior_h) $(target_h) \
	$(gdbcore_h) $(regcache_h)
m2-lang.o: m2-lang.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(expression_h) \
	$(parser_defs_h) $(language_h) $(m2_lang_h) $(c_lang_h) \
	$(valprint_h)
m2-typeprint.o: m2-typeprint.c $(defs_h) $(bfd_h) $(symtab_h) $(gdbtypes_h) \
	$(expression_h) $(value_h) $(gdbcore_h) $(target_h) $(m2_lang_h)
m2-valprint.o: m2-valprint.c $(defs_h) $(symtab_h) $(gdbtypes_h) \
	$(m2_lang_h)
m32r-rom.o: m32r-rom.c $(defs_h) $(gdbcore_h) $(target_h) $(monitor_h) \
	$(serial_h) $(symtab_h) $(command_h) $(gdbcmd_h) $(symfile_h) \
	$(gdb_string_h) $(objfiles_h) $(inferior_h) $(regcache_h)
m32r-stub.o: m32r-stub.c $(syscall_h)
m32r-tdep.o: m32r-tdep.c $(defs_h) $(frame_h) $(frame_unwind_h) \
	$(frame_base_h) $(symtab_h) $(gdbtypes_h) $(gdbcmd_h) $(gdbcore_h) \
	$(gdb_string_h) $(value_h) $(inferior_h) $(symfile_h) $(objfiles_h) \
	$(language_h) $(arch_utils_h) $(regcache_h) $(trad_frame_h) \
	$(gdb_assert_h)
# OBSOLETE m3-nat.o: m3-nat.c
m68hc11-tdep.o: m68hc11-tdep.c $(defs_h) $(frame_h) $(frame_unwind_h) \
	$(frame_base_h) $(dwarf2_frame_h) $(trad_frame_h) $(symtab_h) \
	$(gdbtypes_h) $(gdbcmd_h) $(gdbcore_h) $(gdb_string_h) $(value_h) \
	$(inferior_h) $(dis_asm_h) $(symfile_h) $(objfiles_h) \
	$(arch_utils_h) $(regcache_h) $(reggroups_h) $(target_h) \
	$(opcode_m68hc11_h) $(elf_m68hc11_h) $(elf_bfd_h)
m68klinux-nat.o: m68klinux-nat.c $(defs_h) $(frame_h) $(inferior_h) \
	$(language_h) $(gdbcore_h) $(gdb_string_h) $(regcache_h) \
	$(m68k_tdep_h) $(gdb_stat_h) $(floatformat_h) $(target_h) \
	$(gregset_h)
m68klinux-tdep.o: m68klinux-tdep.c $(defs_h) $(gdbcore_h) $(doublest_h) \
	$(floatformat_h) $(frame_h) $(target_h) $(gdb_string_h) \
	$(gdbtypes_h) $(osabi_h) $(regcache_h) $(objfiles_h) $(symtab_h) \
	$(m68k_tdep_h)
m68knbsd-nat.o: m68knbsd-nat.c $(defs_h) $(inferior_h) $(gdbcore_h) \
	$(regcache_h)
m68knbsd-tdep.o: m68knbsd-tdep.c $(defs_h) $(gdbtypes_h) $(regcache_h)
m68k-stub.o: m68k-stub.c
m68k-tdep.o: m68k-tdep.c $(defs_h) $(frame_h) $(frame_base_h) \
	$(frame_unwind_h) $(symtab_h) $(gdbcore_h) $(value_h) \
	$(gdb_string_h) $(gdb_assert_h) $(inferior_h) $(regcache_h) \
	$(arch_utils_h) $(osabi_h) $(m68k_tdep_h) $(gregset_h)
macrocmd.o: macrocmd.c $(defs_h) $(macrotab_h) $(macroexp_h) $(macroscope_h) \
	$(command_h) $(gdbcmd_h)
macroexp.o: macroexp.c $(defs_h) $(gdb_obstack_h) $(bcache_h) $(macrotab_h) \
	$(macroexp_h) $(gdb_assert_h)
macroscope.o: macroscope.c $(defs_h) $(macroscope_h) $(symtab_h) $(source_h) \
	$(target_h) $(frame_h) $(inferior_h) $(complaints_h)
macrotab.o: macrotab.c $(defs_h) $(gdb_obstack_h) $(splay_tree_h) \
	$(symtab_h) $(symfile_h) $(objfiles_h) $(macrotab_h) $(gdb_assert_h) \
	$(bcache_h) $(complaints_h)
main.o: main.c $(defs_h) $(top_h) $(target_h) $(inferior_h) $(symfile_h) \
	$(gdbcore_h) $(getopt_h) $(gdb_stat_h) $(gdb_string_h) \
	$(event_loop_h) $(ui_out_h) $(interps_h) $(main_h)
maint.o: maint.c $(defs_h) $(command_h) $(gdbcmd_h) $(symtab_h) \
	$(gdbtypes_h) $(demangle_h) $(gdbcore_h) $(expression_h) \
	$(language_h) $(symfile_h) $(objfiles_h) $(value_h) $(cli_decode_h)
mcore-rom.o: mcore-rom.c $(defs_h) $(gdbcore_h) $(target_h) $(monitor_h) \
	$(gdb_string_h) $(regcache_h) $(serial_h)
mcore-tdep.o: mcore-tdep.c $(defs_h) $(frame_h) $(symtab_h) $(value_h) \
	$(gdbcmd_h) $(regcache_h) $(symfile_h) $(gdbcore_h) $(inferior_h) \
	$(arch_utils_h) $(gdb_string_h) $(disasm_h)
mdebugread.o: mdebugread.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(gdbcore_h) \
	$(symfile_h) $(objfiles_h) $(gdb_obstack_h) $(buildsym_h) \
	$(stabsread_h) $(complaints_h) $(demangle_h) $(gdb_assert_h) \
	$(block_h) $(dictionary_h) $(coff_sym_h) $(coff_symconst_h) \
	$(gdb_stat_h) $(gdb_string_h) $(bfd_h) $(coff_ecoff_h) $(libaout_h) \
	$(aout_aout64_h) $(aout_stab_gnu_h) $(expression_h) $(language_h)
memattr.o: memattr.c $(defs_h) $(command_h) $(gdbcmd_h) $(memattr_h) \
	$(target_h) $(value_h) $(language_h) $(gdb_string_h)
mem-break.o: mem-break.c $(defs_h) $(symtab_h) $(breakpoint_h) $(inferior_h) \
	$(target_h)
minsyms.o: minsyms.c $(defs_h) $(gdb_string_h) $(symtab_h) $(bfd_h) \
	$(symfile_h) $(objfiles_h) $(demangle_h) $(value_h) $(cp_abi_h)
mips-irix-tdep.o: mips-irix-tdep.c $(defs_h) $(osabi_h) $(elf_bfd_h)
mips-linux-nat.o: mips-linux-nat.c $(defs_h)
mips-linux-tdep.o: mips-linux-tdep.c $(defs_h) $(gdbcore_h) $(target_h) \
	$(solib_svr4_h) $(osabi_h) $(mips_tdep_h) $(gdb_string_h) \
	$(gdb_assert_h)
# OBSOLETE mipsm3-nat.o: mipsm3-nat.c
mips-nat.o: mips-nat.c $(defs_h) $(inferior_h) $(gdbcore_h) $(regcache_h)
mipsnbsd-nat.o: mipsnbsd-nat.c $(defs_h) $(inferior_h) $(regcache_h) \
	$(mipsnbsd_tdep_h)
mipsnbsd-tdep.o: mipsnbsd-tdep.c $(defs_h) $(gdbcore_h) $(regcache_h) \
	$(target_h) $(value_h) $(osabi_h) $(nbsd_tdep_h) $(mipsnbsd_tdep_h) \
	$(solib_svr4_h)
mipsread.o: mipsread.c $(defs_h) $(gdb_string_h) $(bfd_h) $(symtab_h) \
	$(symfile_h) $(objfiles_h) $(buildsym_h) $(stabsread_h) \
	$(coff_sym_h) $(coff_internal_h) $(coff_ecoff_h) $(libcoff_h) \
	$(libecoff_h) $(elf_common_h) $(elf_mips_h)
mips-tdep.o: mips-tdep.c $(defs_h) $(gdb_string_h) $(gdb_assert_h) \
	$(frame_h) $(inferior_h) $(symtab_h) $(value_h) $(gdbcmd_h) \
	$(language_h) $(gdbcore_h) $(symfile_h) $(objfiles_h) $(gdbtypes_h) \
	$(target_h) $(arch_utils_h) $(regcache_h) $(osabi_h) $(mips_tdep_h) \
	$(block_h) $(reggroups_h) $(opcode_mips_h) $(elf_mips_h) \
	$(elf_bfd_h) $(symcat_h) $(sim_regno_h)
mipsv4-nat.o: mipsv4-nat.c $(defs_h) $(inferior_h) $(gdbcore_h) $(target_h) \
	$(regcache_h) $(gregset_h)
# OBSOLETE mn10200-tdep.o: mn10200-tdep.c
mn10300-tdep.o: mn10300-tdep.c $(defs_h) $(frame_h) $(inferior_h) \
	$(target_h) $(value_h) $(bfd_h) $(gdb_string_h) $(gdbcore_h) \
	$(symfile_h) $(regcache_h) $(arch_utils_h) $(gdb_assert_h)
monitor.o: monitor.c $(defs_h) $(gdbcore_h) $(target_h) $(gdb_string_h) \
	$(command_h) $(serial_h) $(monitor_h) $(gdbcmd_h) $(inferior_h) \
	$(gdb_regex_h) $(srec_h) $(regcache_h)
nbsd-tdep.o: nbsd-tdep.c $(defs_h) $(gdb_string_h) $(solib_svr4_h)
nlmread.o: nlmread.c $(defs_h) $(bfd_h) $(symtab_h) $(symfile_h) \
	$(objfiles_h) $(buildsym_h) $(stabsread_h) $(block_h)
ns32knbsd-nat.o: ns32knbsd-nat.c $(defs_h) $(inferior_h) $(target_h) \
	$(gdbcore_h) $(regcache_h)
ns32knbsd-tdep.o: ns32knbsd-tdep.c $(defs_h) $(osabi_h) $(ns32k_tdep_h) \
	$(gdb_string_h)
ns32k-tdep.o: ns32k-tdep.c $(defs_h) $(frame_h) $(gdbtypes_h) $(gdbcore_h) \
	$(inferior_h) $(regcache_h) $(target_h) $(arch_utils_h) $(osabi_h) \
	$(ns32k_tdep_h) $(gdb_string_h)
nto-tdep.o: nto-tdep.c $(gdb_stat_h) $(gdb_string_h) $(nto_tdep_h) $(top_h) \
	$(cli_decode_h) $(cli_cmds_h) $(inferior_h) $(gdbarch_h) $(bfd_h) \
	$(elf_bfd_h) $(solib_svr4_h) $(gdbcore_h)
objc-lang.o: objc-lang.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(expression_h) \
	$(parser_defs_h) $(language_h) $(c_lang_h) $(objc_lang_h) \
	$(complaints_h) $(value_h) $(symfile_h) $(objfiles_h) \
	$(gdb_string_h) $(target_h) $(gdbcore_h) $(gdbcmd_h) $(frame_h) \
	$(gdb_regex_h) $(regcache_h) $(block_h) $(infcall_h) $(valprint_h) \
	$(gdb_assert_h)
objfiles.o: objfiles.c $(defs_h) $(bfd_h) $(symtab_h) $(symfile_h) \
	$(objfiles_h) $(gdb_stabs_h) $(target_h) $(bcache_h) $(gdb_stat_h) \
	$(gdb_obstack_h) $(gdb_string_h) $(hashtab_h) $(breakpoint_h) \
	$(block_h) $(dictionary_h) $(mmalloc_h)
observer.o: observer.c $(defs_h) $(observer_h)
ocd.o: ocd.c $(defs_h) $(gdbcore_h) $(gdb_string_h) $(frame_h) $(inferior_h) \
	$(bfd_h) $(symfile_h) $(target_h) $(gdbcmd_h) $(objfiles_h) \
	$(gdb_stabs_h) $(serial_h) $(ocd_h) $(regcache_h)
op50-rom.o: op50-rom.c $(defs_h) $(gdbcore_h) $(target_h) $(monitor_h) \
	$(serial_h)
osabi.o: osabi.c $(defs_h) $(gdb_assert_h) $(gdb_string_h) $(osabi_h) \
	$(arch_utils_h) $(gdbcmd_h) $(command_h) $(elf_bfd_h)
pa64solib.o: pa64solib.c $(defs_h) $(frame_h) $(bfd_h) $(libhppa_h) \
	$(gdbcore_h) $(symtab_h) $(breakpoint_h) $(symfile_h) $(objfiles_h) \
	$(inferior_h) $(gdb_stabs_h) $(gdb_stat_h) $(gdbcmd_h) $(language_h) \
	$(regcache_h)
parse.o: parse.c $(defs_h) $(gdb_string_h) $(symtab_h) $(gdbtypes_h) \
	$(frame_h) $(expression_h) $(value_h) $(command_h) $(language_h) \
	$(parser_defs_h) $(gdbcmd_h) $(symfile_h) $(inferior_h) \
	$(doublest_h) $(gdb_assert_h) $(block_h)
p-lang.o: p-lang.c $(defs_h) $(gdb_string_h) $(symtab_h) $(gdbtypes_h) \
	$(expression_h) $(parser_defs_h) $(language_h) $(p_lang_h) \
	$(valprint_h) $(value_h)
ppc-bdm.o: ppc-bdm.c $(defs_h) $(gdbcore_h) $(gdb_string_h) $(frame_h) \
	$(inferior_h) $(bfd_h) $(symfile_h) $(target_h) $(gdbcmd_h) \
	$(objfiles_h) $(gdb_stabs_h) $(serial_h) $(ocd_h) $(ppc_tdep_h) \
	$(regcache_h)
ppcbug-rom.o: ppcbug-rom.c $(defs_h) $(gdbcore_h) $(target_h) $(monitor_h) \
	$(serial_h) $(regcache_h)
ppc-linux-nat.o: ppc-linux-nat.c $(defs_h) $(gdb_string_h) $(frame_h) \
	$(inferior_h) $(gdbcore_h) $(regcache_h) $(gdb_wait_h) $(gregset_h) \
	$(ppc_tdep_h)
ppc-linux-tdep.o: ppc-linux-tdep.c $(defs_h) $(frame_h) $(inferior_h) \
	$(symtab_h) $(target_h) $(gdbcore_h) $(gdbcmd_h) $(symfile_h) \
	$(objfiles_h) $(regcache_h) $(value_h) $(osabi_h) $(solib_svr4_h) \
	$(ppc_tdep_h)
ppcnbsd-nat.o: ppcnbsd-nat.c $(defs_h) $(inferior_h) $(ppc_tdep_h) \
	$(ppcnbsd_tdep_h)
ppcnbsd-tdep.o: ppcnbsd-tdep.c $(defs_h) $(gdbcore_h) $(regcache_h) \
	$(target_h) $(breakpoint_h) $(value_h) $(osabi_h) $(ppc_tdep_h) \
	$(ppcnbsd_tdep_h) $(nbsd_tdep_h) $(solib_svr4_h)
ppc-sysv-tdep.o: ppc-sysv-tdep.c $(defs_h) $(gdbcore_h) $(inferior_h) \
	$(regcache_h) $(value_h) $(gdb_string_h) $(ppc_tdep_h)
printcmd.o: printcmd.c $(defs_h) $(gdb_string_h) $(frame_h) $(symtab_h) \
	$(gdbtypes_h) $(value_h) $(language_h) $(expression_h) $(gdbcore_h) \
	$(gdbcmd_h) $(target_h) $(breakpoint_h) $(demangle_h) $(valprint_h) \
	$(annotate_h) $(symfile_h) $(objfiles_h) $(completer_h) $(ui_out_h) \
	$(gdb_assert_h) $(block_h) $(disasm_h)
proc-api.o: proc-api.c $(defs_h) $(gdbcmd_h) $(completer_h) $(gdb_wait_h) \
	$(proc_utils_h)
proc-events.o: proc-events.c $(defs_h)
proc-flags.o: proc-flags.c $(defs_h)
procfs.o: procfs.c $(defs_h) $(inferior_h) $(target_h) $(gdbcore_h) \
	$(elf_bfd_h) $(gdbcmd_h) $(gdbthread_h) $(gdb_wait_h) \
	$(gdb_assert_h) $(inflow_h) $(gdb_dirent_h) $(X_OK) $(gdb_stat_h) \
	$(proc_utils_h) $(gregset_h)
proc-service.o: proc-service.c $(defs_h) $(gdb_proc_service_h) $(inferior_h) \
	$(symtab_h) $(target_h) $(gregset_h)
proc-why.o: proc-why.c $(defs_h) $(proc_utils_h)
p-typeprint.o: p-typeprint.c $(defs_h) $(gdb_obstack_h) $(bfd_h) $(symtab_h) \
	$(gdbtypes_h) $(expression_h) $(value_h) $(gdbcore_h) $(target_h) \
	$(language_h) $(p_lang_h) $(typeprint_h) $(gdb_string_h)
p-valprint.o: p-valprint.c $(defs_h) $(gdb_obstack_h) $(symtab_h) \
	$(gdbtypes_h) $(expression_h) $(value_h) $(command_h) $(gdbcmd_h) \
	$(gdbcore_h) $(demangle_h) $(valprint_h) $(typeprint_h) \
	$(language_h) $(target_h) $(annotate_h) $(p_lang_h) $(cp_abi_h)
regcache.o: regcache.c $(defs_h) $(inferior_h) $(target_h) $(gdbarch_h) \
	$(gdbcmd_h) $(regcache_h) $(reggroups_h) $(gdb_assert_h) \
	$(gdb_string_h) $(gdbcmd_h)
reggroups.o: reggroups.c $(defs_h) $(reggroups_h) $(gdbtypes_h) \
	$(gdb_assert_h) $(regcache_h) $(command_h) $(gdbcmd_h)
remote.o: remote.c $(defs_h) $(gdb_string_h) $(inferior_h) $(bfd_h) \
	$(symfile_h) $(target_h) $(gdbcmd_h) $(objfiles_h) $(gdb_stabs_h) \
	$(gdbthread_h) $(remote_h) $(regcache_h) $(value_h) $(gdb_assert_h) \
	$(event_loop_h) $(event_top_h) $(inf_loop_h) $(serial_h) \
	$(gdbcore_h) $(remote_fileio_h)
remote-e7000.o: remote-e7000.c $(defs_h) $(gdbcore_h) $(gdbarch_h) \
	$(inferior_h) $(target_h) $(value_h) $(command_h) $(gdb_string_h) \
	$(gdbcmd_h) $(serial_h) $(remote_utils_h) $(symfile_h) $(regcache_h)
remote-est.o: remote-est.c $(defs_h) $(gdbcore_h) $(target_h) $(monitor_h) \
	$(serial_h) $(regcache_h) $(m68k_tdep_h)
remote-fileio.o: remote-fileio.c $(defs_h) $(gdb_string_h) $(gdbcmd_h) \
	$(remote_h) $(gdb_fileio_h) $(gdb_wait_h) $(gdb_stat_h) \
	$(remote_fileio_h)
remote-hms.o: remote-hms.c $(defs_h) $(gdbcore_h) $(target_h) $(monitor_h) \
	$(serial_h) $(regcache_h)
remote-mips.o: remote-mips.c $(defs_h) $(inferior_h) $(bfd_h) $(symfile_h) \
	$(gdbcmd_h) $(gdbcore_h) $(serial_h) $(target_h) $(remote_utils_h) \
	$(gdb_string_h) $(gdb_stat_h) $(regcache_h)
remote-rdi.o: remote-rdi.c $(defs_h) $(gdb_string_h) $(frame_h) \
	$(inferior_h) $(bfd_h) $(symfile_h) $(target_h) $(gdbcmd_h) \
	$(objfiles_h) $(gdb_stabs_h) $(gdbthread_h) $(gdbcore_h) \
	$(breakpoint_h) $(completer_h) $(regcache_h) $(arm_tdep_h) \
	$(rdi_share_ardi_h) $(rdi_share_adp_h) $(rdi_share_hsys_h)
remote-rdp.o: remote-rdp.c $(defs_h) $(inferior_h) $(value_h) \
	$(gdb_callback_h) $(command_h) $(symfile_h) $(remote_utils_h) \
	$(gdb_string_h) $(gdbcore_h) $(regcache_h) $(serial_h) $(arm_tdep_h)
remote-sds.o: remote-sds.c $(defs_h) $(gdb_string_h) $(frame_h) \
	$(inferior_h) $(bfd_h) $(symfile_h) $(target_h) $(gdbcmd_h) \
	$(objfiles_h) $(gdb_stabs_h) $(gdbthread_h) $(gdbcore_h) \
	$(regcache_h) $(serial_h)
remote-sim.o: remote-sim.c $(defs_h) $(inferior_h) $(value_h) \
	$(gdb_string_h) $(terminal_h) $(target_h) $(gdbcore_h) \
	$(gdb_callback_h) $(gdb_remote_sim_h) $(remote_utils_h) $(command_h) \
	$(regcache_h) $(gdb_assert_h) $(sim_regno_h)
remote-st.o: remote-st.c $(defs_h) $(gdbcore_h) $(target_h) $(gdb_string_h) \
	$(serial_h) $(regcache_h)
remote-utils.o: remote-utils.c $(defs_h) $(gdb_string_h) $(gdbcmd_h) \
	$(target_h) $(serial_h) $(gdbcore_h) $(inferior_h) $(remote_utils_h) \
	$(regcache_h)
remote-vx68.o: remote-vx68.c $(defs_h) $(vx_share_regPacket_h) $(frame_h) \
	$(inferior_h) $(target_h) $(gdbcore_h) $(command_h) $(symtab_h) \
	$(symfile_h) $(regcache_h) $(gdb_string_h) $(vx_share_ptrace_h) \
	$(vx_share_xdr_ptrace_h) $(vx_share_xdr_ld_h) $(vx_share_xdr_rdb_h) \
	$(vx_share_dbgRpcLib_h)
remote-vx.o: remote-vx.c $(defs_h) $(frame_h) $(inferior_h) $(target_h) \
	$(gdbcore_h) $(command_h) $(symtab_h) $(complaints_h) $(gdbcmd_h) \
	$(bfd_h) $(symfile_h) $(objfiles_h) $(gdb_stabs_h) $(regcache_h) \
	$(gdb_string_h) $(vx_share_ptrace_h) $(vx_share_xdr_ptrace_h) \
	$(vx_share_xdr_ld_h) $(vx_share_xdr_rdb_h) $(vx_share_dbgRpcLib_h)
remote-vxmips.o: remote-vxmips.c $(defs_h) $(vx_share_regPacket_h) \
	$(frame_h) $(inferior_h) $(target_h) $(gdbcore_h) $(command_h) \
	$(symtab_h) $(symfile_h) $(regcache_h) $(gdb_string_h) \
	$(vx_share_ptrace_h) $(vx_share_xdr_ptrace_h) $(vx_share_xdr_ld_h) \
	$(vx_share_xdr_rdb_h) $(vx_share_dbgRpcLib_h)
remote-vxsparc.o: remote-vxsparc.c $(defs_h) $(vx_share_regPacket_h) \
	$(frame_h) $(inferior_h) $(target_h) $(gdbcore_h) $(command_h) \
	$(symtab_h) $(symfile_h) $(regcache_h) $(gdb_string_h) \
	$(vx_share_ptrace_h) $(vx_share_xdr_ptrace_h) $(vx_share_xdr_ld_h) \
	$(vx_share_xdr_rdb_h) $(vx_share_dbgRpcLib_h)
rom68k-rom.o: rom68k-rom.c $(defs_h) $(gdbcore_h) $(target_h) $(monitor_h) \
	$(serial_h) $(regcache_h) $(value_h) $(m68k_tdep_h)
rs6000-nat.o: rs6000-nat.c $(defs_h) $(inferior_h) $(target_h) $(gdbcore_h) \
	$(xcoffsolib_h) $(symfile_h) $(objfiles_h) $(libbfd_h) $(bfd_h) \
	$(gdb_stabs_h) $(regcache_h) $(arch_utils_h) $(language_h) \
	$(ppc_tdep_h) $(gdb_stat_h)
rs6000-tdep.o: rs6000-tdep.c $(defs_h) $(frame_h) $(inferior_h) $(symtab_h) \
	$(target_h) $(gdbcore_h) $(gdbcmd_h) $(symfile_h) $(objfiles_h) \
	$(arch_utils_h) $(regcache_h) $(doublest_h) $(value_h) \
	$(parser_defs_h) $(osabi_h) $(libbfd_h) $(coff_internal_h) \
	$(libcoff_h) $(coff_xcoff_h) $(libxcoff_h) $(elf_bfd_h) \
	$(solib_svr4_h) $(ppc_tdep_h) $(gdb_assert_h)
s390-nat.o: s390-nat.c $(defs_h) $(tm_h) $(regcache_h)
s390-tdep.o: s390-tdep.c $(arch_utils_h) $(frame_h) $(inferior_h) \
	$(symtab_h) $(target_h) $(gdbcore_h) $(gdbcmd_h) $(symfile_h) \
	$(objfiles_h) $(tm_h) $(__bfd_bfd_h) $(floatformat_h) $(regcache_h) \
	$(value_h) $(gdb_assert_h)
scm-exp.o: scm-exp.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(expression_h) \
	$(parser_defs_h) $(language_h) $(value_h) $(c_lang_h) $(scm_lang_h) \
	$(scm_tags_h)
scm-lang.o: scm-lang.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(expression_h) \
	$(parser_defs_h) $(language_h) $(value_h) $(c_lang_h) $(scm_lang_h) \
	$(scm_tags_h) $(source_h) $(gdb_string_h) $(gdbcore_h) $(infcall_h)
scm-valprint.o: scm-valprint.c $(defs_h) $(symtab_h) $(gdbtypes_h) \
	$(expression_h) $(parser_defs_h) $(language_h) $(value_h) \
	$(scm_lang_h) $(valprint_h) $(gdbcore_h)
sentinel-frame.o: sentinel-frame.c $(defs_h) $(regcache_h) \
	$(sentinel_frame_h) $(inferior_h) $(frame_unwind_h)
ser-e7kpc.o: ser-e7kpc.c $(defs_h) $(serial_h) $(gdb_string_h)
ser-go32.o: ser-go32.c $(defs_h) $(gdbcmd_h) $(serial_h) $(gdb_string_h)
serial.o: serial.c $(defs_h) $(serial_h) $(gdb_string_h) $(gdbcmd_h)
ser-pipe.o: ser-pipe.c $(defs_h) $(serial_h) $(ser_unix_h) $(gdb_vfork_h) \
	$(gdb_string_h)
ser-tcp.o: ser-tcp.c $(defs_h) $(serial_h) $(ser_unix_h) $(gdb_string_h)
ser-unix.o: ser-unix.c $(defs_h) $(serial_h) $(ser_unix_h) $(terminal_h) \
	$(gdb_string_h) $(event_loop_h)
sh3-rom.o: sh3-rom.c $(defs_h) $(gdbcore_h) $(target_h) $(monitor_h) \
	$(serial_h) $(srec_h) $(arch_utils_h) $(regcache_h) $(gdb_string_h) \
	$(sh_tdep_h)
shnbsd-nat.o: shnbsd-nat.c $(defs_h) $(inferior_h) $(sh_tdep_h) \
	$(shnbsd_tdep_h)
shnbsd-tdep.o: shnbsd-tdep.c $(defs_h) $(gdbcore_h) $(regcache_h) $(value_h) \
	$(osabi_h) $(solib_svr4_h) $(nbsd_tdep_h) $(sh_tdep_h) \
	$(shnbsd_tdep_h)
sh-stub.o: sh-stub.c
sh-tdep.o: sh-tdep.c $(defs_h) $(frame_h) $(symtab_h) $(symfile_h) \
	$(gdbtypes_h) $(gdbcmd_h) $(gdbcore_h) $(value_h) $(dis_asm_h) \
	$(inferior_h) $(gdb_string_h) $(arch_utils_h) $(floatformat_h) \
	$(regcache_h) $(doublest_h) $(osabi_h) $(sh_tdep_h) $(elf_bfd_h) \
	$(solib_svr4_h) $(elf_sh_h) $(gdb_sim_sh_h)
solib-aix5.o: solib-aix5.c $(defs_h) $(gdb_string_h) $(elf_external_h) \
	$(symtab_h) $(bfd_h) $(symfile_h) $(objfiles_h) $(gdbcore_h) \
	$(command_h) $(target_h) $(frame_h) $(gdb_regex_h) $(inferior_h) \
	$(environ_h) $(language_h) $(gdbcmd_h) $(solist_h)
solib.o: solib.c $(defs_h) $(gdb_string_h) $(symtab_h) $(bfd_h) $(symfile_h) \
	$(objfiles_h) $(gdbcore_h) $(command_h) $(target_h) $(frame_h) \
	$(gdb_regex_h) $(inferior_h) $(environ_h) $(language_h) $(gdbcmd_h) \
	$(completer_h) $(filenames_h) $(solist_h)
solib-irix.o: solib-irix.c $(defs_h) $(symtab_h) $(bfd_h) $(symfile_h) \
	$(objfiles_h) $(gdbcore_h) $(target_h) $(inferior_h) $(solist_h)
solib-legacy.o: solib-legacy.c $(defs_h) $(gdbcore_h) $(solib_svr4_h)
solib-osf.o: solib-osf.c $(defs_h) $(gdb_string_h) $(bfd_h) $(symtab_h) \
	$(symfile_h) $(objfiles_h) $(target_h) $(inferior_h) $(solist_h)
solib-sunos.o: solib-sunos.c $(defs_h) $(gdb_string_h) $(symtab_h) $(bfd_h) \
	$(symfile_h) $(objfiles_h) $(gdbcore_h) $(inferior_h) $(solist_h) \
	$(bcache_h) $(regcache_h)
solib-svr4.o: solib-svr4.c $(defs_h) $(elf_external_h) $(elf_common_h) \
	$(elf_mips_h) $(symtab_h) $(bfd_h) $(symfile_h) $(objfiles_h) \
	$(gdbcore_h) $(target_h) $(inferior_h) $(solist_h) $(solib_svr4_h)
sol-thread.o: sol-thread.c $(defs_h) $(gdbthread_h) $(target_h) \
	$(inferior_h) $(gdb_stat_h) $(gdbcmd_h) $(gdbcore_h) $(regcache_h) \
	$(symfile_h) $(gregset_h)
somread.o: somread.c $(defs_h) $(bfd_h) $(symtab_h) $(symfile_h) \
	$(objfiles_h) $(buildsym_h) $(stabsread_h) $(gdb_stabs_h) \
	$(complaints_h) $(gdb_string_h) $(demangle_h) $(som_h) $(libhppa_h)
somsolib.o: somsolib.c $(defs_h) $(frame_h) $(bfd_h) $(som_h) $(libhppa_h) \
	$(gdbcore_h) $(symtab_h) $(breakpoint_h) $(symfile_h) $(objfiles_h) \
	$(inferior_h) $(gdb_stabs_h) $(gdb_stat_h) $(gdbcmd_h) $(language_h) \
	$(regcache_h) $(gdb_assert_h)
source.o: source.c $(defs_h) $(symtab_h) $(expression_h) $(language_h) \
	$(command_h) $(source_h) $(gdbcmd_h) $(frame_h) $(value_h) \
	$(gdb_string_h) $(gdb_stat_h) $(gdbcore_h) $(gdb_regex_h) \
	$(symfile_h) $(objfiles_h) $(annotate_h) $(gdbtypes_h) $(linespec_h) \
	$(filenames_h) $(completer_h) $(ui_out_h)
sparc64nbsd-nat.o: sparc64nbsd-nat.c $(defs_h) $(inferior_h) $(regcache_h) \
	$(sparc_tdep_h) $(sparcnbsd_tdep_h)
# OBSOLETE sparclet-rom.o: sparclet-rom.c
# OBSOLETE sparclet-stub.o: sparclet-stub.c
sparc-linux-nat.o: sparc-linux-nat.c $(defs_h) $(regcache_h) $(sparc_tdep_h) \
	$(gregset_h)
# OBSOLETE sparcl-stub.o: sparcl-stub.c
# OBSOLETE sparcl-tdep.o: sparcl-tdep.c
sparc-nat.o: sparc-nat.c $(defs_h) $(inferior_h) $(target_h) $(gdbcore_h) \
	$(regcache_h) $(sparc_tdep_h) $(gdb_wait_h)
sparcnbsd-nat.o: sparcnbsd-nat.c $(defs_h) $(inferior_h) $(regcache_h) \
	$(sparc_tdep_h) $(sparcnbsd_tdep_h)
sparcnbsd-tdep.o: sparcnbsd-tdep.c $(defs_h) $(gdbcore_h) $(regcache_h) \
	$(target_h) $(value_h) $(osabi_h) $(gdb_string_h) $(sparc_tdep_h) \
	$(sparcnbsd_tdep_h) $(nbsd_tdep_h) $(solib_svr4_h)
sparc-stub.o: sparc-stub.c
sparc-tdep.o: sparc-tdep.c $(defs_h) $(arch_utils_h) $(frame_h) \
	$(inferior_h) $(target_h) $(value_h) $(bfd_h) $(gdb_string_h) \
	$(regcache_h) $(osabi_h) $(sparc_tdep_h) $(gregset_h) $(gdbcore_h) \
	$(gdb_assert_h) $(symfile_h)
stabsread.o: stabsread.c $(defs_h) $(gdb_string_h) $(bfd_h) $(gdb_obstack_h) \
	$(symtab_h) $(gdbtypes_h) $(expression_h) $(symfile_h) $(objfiles_h) \
	$(aout_stab_gnu_h) $(libaout_h) $(aout_aout64_h) $(gdb_stabs_h) \
	$(buildsym_h) $(complaints_h) $(demangle_h) $(language_h) \
	$(doublest_h) $(cp_abi_h) $(cp_support_h) $(stabsread_h)
stack.o: stack.c $(defs_h) $(gdb_string_h) $(value_h) $(symtab_h) \
	$(gdbtypes_h) $(expression_h) $(language_h) $(frame_h) $(gdbcmd_h) \
	$(gdbcore_h) $(target_h) $(source_h) $(breakpoint_h) $(demangle_h) \
	$(inferior_h) $(annotate_h) $(ui_out_h) $(block_h) $(stack_h) \
	$(gdb_assert_h) $(dictionary_h)
standalone.o: standalone.c $(gdb_stat_h) $(defs_h) $(symtab_h) $(frame_h) \
	$(inferior_h) $(gdb_wait_h)
std-regs.o: std-regs.c $(defs_h) $(builtin_regs_h) $(frame_h) $(gdbtypes_h) \
	$(value_h) $(gdb_string_h)
stop-gdb.o: stop-gdb.c $(defs_h)
sun3-nat.o: sun3-nat.c $(defs_h) $(inferior_h) $(gdbcore_h) $(regcache_h)
symfile.o: symfile.c $(defs_h) $(bfdlink_h) $(symtab_h) $(gdbtypes_h) \
	$(gdbcore_h) $(frame_h) $(target_h) $(value_h) $(symfile_h) \
	$(objfiles_h) $(source_h) $(gdbcmd_h) $(breakpoint_h) $(language_h) \
	$(complaints_h) $(demangle_h) $(inferior_h) $(filenames_h) \
	$(gdb_stabs_h) $(gdb_obstack_h) $(completer_h) $(bcache_h) \
	$(hashtab_h) $(gdb_assert_h) $(block_h) $(gdb_string_h) \
	$(gdb_stat_h)
symmisc.o: symmisc.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(bfd_h) \
	$(symfile_h) $(objfiles_h) $(breakpoint_h) $(command_h) \
	$(gdb_obstack_h) $(language_h) $(bcache_h) $(block_h) $(gdb_regex_h) \
	$(dictionary_h) $(gdb_string_h)
# OBSOLETE symm-nat.o: symm-nat.c
# OBSOLETE symm-tdep.o: symm-tdep.c
symtab.o: symtab.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(gdbcore_h) \
	$(frame_h) $(target_h) $(value_h) $(symfile_h) $(objfiles_h) \
	$(gdbcmd_h) $(call_cmds_h) $(gdb_regex_h) $(expression_h) \
	$(language_h) $(demangle_h) $(inferior_h) $(linespec_h) $(source_h) \
	$(filenames_h) $(objc_lang_h) $(hashtab_h) $(gdb_obstack_h) \
	$(block_h) $(dictionary_h) $(gdb_string_h) $(gdb_stat_h) $(cp_abi_h)
target.o: target.c $(defs_h) $(gdb_string_h) $(target_h) $(gdbcmd_h) \
	$(symtab_h) $(inferior_h) $(bfd_h) $(symfile_h) $(objfiles_h) \
	$(gdb_wait_h) $(dcache_h) $(regcache_h)
thread.o: thread.c $(defs_h) $(symtab_h) $(frame_h) $(inferior_h) \
	$(environ_h) $(value_h) $(target_h) $(gdbthread_h) $(command_h) \
	$(gdbcmd_h) $(regcache_h) $(gdb_h) $(gdb_string_h) $(ui_out_h)
thread-db.o: thread-db.c $(defs_h) $(gdb_assert_h) $(gdb_proc_service_h) \
	$(gdb_thread_db_h) $(bfd_h) $(gdbthread_h) $(inferior_h) \
	$(symfile_h) $(objfiles_h) $(target_h) $(regcache_h) $(solib_svr4_h)
top.o: top.c $(defs_h) $(gdbcmd_h) $(call_cmds_h) $(cli_cmds_h) \
	$(cli_script_h) $(cli_setshow_h) $(cli_decode_h) $(symtab_h) \
	$(inferior_h) $(target_h) $(breakpoint_h) $(gdbtypes_h) \
	$(expression_h) $(value_h) $(language_h) $(terminal_h) $(annotate_h) \
	$(completer_h) $(top_h) $(version_h) $(serial_h) $(doublest_h) \
	$(gdb_assert_h) $(event_top_h) $(gdb_string_h) $(gdb_stat_h) \
	$(ui_out_h) $(cli_out_h)
tracepoint.o: tracepoint.c $(defs_h) $(symtab_h) $(frame_h) $(gdbtypes_h) \
	$(expression_h) $(gdbcmd_h) $(value_h) $(target_h) $(language_h) \
	$(gdb_string_h) $(inferior_h) $(tracepoint_h) $(remote_h) \
	$(linespec_h) $(regcache_h) $(completer_h) $(gdb_events_h) \
	$(block_h) $(dictionary_h) $(ax_h) $(ax_gdb_h)
trad-frame.o: trad-frame.c $(defs_h) $(frame_h) $(trad_frame_h) \
	$(regcache_h)
typeprint.o: typeprint.c $(defs_h) $(gdb_obstack_h) $(bfd_h) $(symtab_h) \
	$(gdbtypes_h) $(expression_h) $(value_h) $(gdbcore_h) $(command_h) \
	$(gdbcmd_h) $(target_h) $(language_h) $(cp_abi_h) $(typeprint_h) \
	$(gdb_string_h)
ui-file.o: ui-file.c $(defs_h) $(ui_file_h) $(gdb_string_h)
ui-out.o: ui-out.c $(defs_h) $(gdb_string_h) $(expression_h) $(language_h) \
	$(ui_out_h) $(gdb_assert_h)
utils.o: utils.c $(defs_h) $(gdb_assert_h) $(gdb_string_h) $(event_top_h) \
	$(gdbcmd_h) $(serial_h) $(bfd_h) $(target_h) $(demangle_h) \
	$(expression_h) $(language_h) $(charset_h) $(annotate_h) \
	$(filenames_h) $(inferior_h) $(mmalloc_h)
uw-thread.o: uw-thread.c $(defs_h) $(gdbthread_h) $(target_h) $(inferior_h) \
	$(regcache_h) $(gregset_h)
v850ice.o: v850ice.c $(defs_h) $(gdb_string_h) $(frame_h) $(symtab_h) \
	$(inferior_h) $(breakpoint_h) $(symfile_h) $(target_h) $(objfiles_h) \
	$(gdbcore_h) $(value_h) $(command_h) $(regcache_h)
v850-tdep.o: v850-tdep.c $(defs_h) $(frame_h) $(inferior_h) $(target_h) \
	$(value_h) $(bfd_h) $(gdb_string_h) $(gdbcore_h) $(symfile_h) \
	$(arch_utils_h) $(regcache_h) $(symtab_h)
valarith.o: valarith.c $(defs_h) $(value_h) $(symtab_h) $(gdbtypes_h) \
	$(expression_h) $(target_h) $(language_h) $(gdb_string_h) \
	$(doublest_h) $(infcall_h)
valops.o: valops.c $(defs_h) $(symtab_h) $(gdbtypes_h) $(value_h) $(frame_h) \
	$(inferior_h) $(gdbcore_h) $(target_h) $(demangle_h) $(language_h) \
	$(gdbcmd_h) $(regcache_h) $(cp_abi_h) $(block_h) $(infcall_h) \
	$(dictionary_h) $(cp_support_h) $(gdb_string_h) $(gdb_assert_h)
valprint.o: valprint.c $(defs_h) $(gdb_string_h) $(symtab_h) $(gdbtypes_h) \
	$(value_h) $(gdbcore_h) $(gdbcmd_h) $(target_h) $(language_h) \
	$(annotate_h) $(valprint_h) $(floatformat_h) $(doublest_h)
values.o: values.c $(defs_h) $(gdb_string_h) $(symtab_h) $(gdbtypes_h) \
	$(value_h) $(gdbcore_h) $(command_h) $(gdbcmd_h) $(target_h) \
	$(language_h) $(scm_lang_h) $(demangle_h) $(doublest_h) \
	$(gdb_assert_h) $(regcache_h) $(block_h)
varobj.o: varobj.c $(defs_h) $(value_h) $(expression_h) $(frame_h) \
	$(language_h) $(wrapper_h) $(gdbcmd_h) $(gdb_string_h) $(varobj_h)
vax-tdep.o: vax-tdep.c $(defs_h) $(symtab_h) $(opcode_vax_h) $(gdbcore_h) \
	$(inferior_h) $(regcache_h) $(frame_h) $(value_h) $(arch_utils_h) \
	$(gdb_string_h) $(osabi_h) $(vax_tdep_h)
w89k-rom.o: w89k-rom.c $(defs_h) $(gdbcore_h) $(target_h) $(monitor_h) \
	$(serial_h) $(xmodem_h) $(regcache_h)
win32-nat.o: win32-nat.c $(defs_h) $(tm_h) $(frame_h) $(inferior_h) \
	$(target_h) $(gdbcore_h) $(command_h) $(completer_h) $(regcache_h) \
	$(top_h) $(i386_tdep_h) $(buildsym_h) $(symfile_h) $(objfiles_h) \
	$(gdb_string_h) $(gdbthread_h) $(gdbcmd_h)
wince.o: wince.c $(defs_h) $(frame_h) $(inferior_h) $(target_h) $(gdbcore_h) \
	$(command_h) $(buildsym_h) $(symfile_h) $(objfiles_h) \
	$(gdb_string_h) $(gdbthread_h) $(gdbcmd_h) $(wince_stub_h) \
	$(regcache_h) $(mips_tdep_h)
wince-stub.o: wince-stub.c $(wince_stub_h)
wrapper.o: wrapper.c $(defs_h) $(value_h) $(wrapper_h)
x86-64-linux-nat.o: x86-64-linux-nat.c $(defs_h) $(inferior_h) $(gdbcore_h) \
	$(regcache_h) $(gdb_assert_h) $(gdb_string_h) $(gdb_proc_service_h) \
	$(gregset_h) $(x86_64_tdep_h) $(x86_64_linux_tdep_h)
x86-64-linux-tdep.o: x86-64-linux-tdep.c $(defs_h) $(inferior_h) \
	$(gdbcore_h) $(regcache_h) $(osabi_h) $(gdb_string_h) \
	$(x86_64_tdep_h) $(x86_64_linux_tdep_h)
x86-64-tdep.o: x86-64-tdep.c $(defs_h) $(arch_utils_h) $(block_h) \
	$(dummy_frame_h) $(frame_h) $(frame_base_h) $(frame_unwind_h) \
	$(inferior_h) $(gdbcmd_h) $(gdbcore_h) $(objfiles_h) $(regcache_h) \
	$(symfile_h) $(gdb_assert_h) $(x86_64_tdep_h) $(i387_tdep_h)
xcoffread.o: xcoffread.c $(defs_h) $(bfd_h) $(gdb_string_h) $(gdb_stat_h) \
	$(coff_internal_h) $(libcoff_h) $(coff_xcoff_h) $(libxcoff_h) \
	$(coff_rs6000_h) $(symtab_h) $(gdbtypes_h) $(symfile_h) \
	$(objfiles_h) $(buildsym_h) $(stabsread_h) $(expression_h) \
	$(complaints_h) $(gdb_stabs_h) $(aout_stab_gnu_h)
xcoffsolib.o: xcoffsolib.c $(defs_h) $(bfd_h) $(xcoffsolib_h) $(inferior_h) \
	$(gdbcmd_h) $(symfile_h) $(frame_h) $(gdb_regex_h)
xmodem.o: xmodem.c $(defs_h) $(serial_h) $(target_h) $(xmodem_h)
xstormy16-tdep.o: xstormy16-tdep.c $(defs_h) $(value_h) $(inferior_h) \
	$(symfile_h) $(arch_utils_h) $(regcache_h) $(gdbcore_h) \
	$(objfiles_h)
# OBSOLETE z8k-tdep.o: z8k-tdep.c

#
# gdb/cli/ dependencies
#
# Need to explicitly specify the compile rule as make will do nothing
# or try to compile the object file into the sub-directory.

cli-cmds.o: $(srcdir)/cli/cli-cmds.c $(defs_h) $(completer_h) $(target_h) \
	$(gdb_wait_h) $(gdb_regex_h) $(gdb_string_h) $(gdb_vfork_h) \
	$(linespec_h) $(expression_h) $(frame_h) $(value_h) $(language_h) \
	$(filenames_h) $(objfiles_h) $(source_h) $(disasm_h) $(ui_out_h) \
	$(top_h) $(cli_decode_h) $(cli_script_h) $(cli_setshow_h) \
	$(cli_cmds_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/cli/cli-cmds.c
cli-decode.o: $(srcdir)/cli/cli-decode.c $(defs_h) $(symtab_h) \
	$(gdb_regex_h) $(gdb_string_h) $(ui_out_h) $(cli_cmds_h) \
	$(cli_decode_h) $(gdb_assert_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/cli/cli-decode.c
cli-dump.o: $(srcdir)/cli/cli-dump.c $(defs_h) $(gdb_string_h) \
	$(cli_decode_h) $(cli_cmds_h) $(value_h) $(completer_h) \
	$(cli_dump_h) $(gdb_assert_h) $(target_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/cli/cli-dump.c
cli-interp.o: $(srcdir)/cli/cli-interp.c $(defs_h) $(interps_h) $(wrapper_h) \
	$(event_top_h) $(ui_out_h) $(cli_out_h) $(top_h) $(gdb_string_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/cli/cli-interp.c
cli-logging.o: $(srcdir)/cli/cli-logging.c $(defs_h) $(gdbcmd_h) $(ui_out_h) \
	$(gdb_string_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/cli/cli-logging.c
cli-script.o: $(srcdir)/cli/cli-script.c $(defs_h) $(value_h) $(language_h) \
	$(ui_out_h) $(gdb_string_h) $(top_h) $(cli_cmds_h) $(cli_decode_h) \
	$(cli_script_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/cli/cli-script.c
cli-setshow.o: $(srcdir)/cli/cli-setshow.c $(defs_h) $(value_h) \
	$(gdb_string_h) $(ui_out_h) $(cli_decode_h) $(cli_cmds_h) \
	$(cli_setshow_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/cli/cli-setshow.c
cli-utils.o: $(srcdir)/cli/cli-utils.c $(defs_h) $(cli_utils_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/cli/cli-utils.c

#
# GDBTK sub-directory
#
# Need to explicitly specify the compile rule as make will do nothing
# or try to compile the object file into the mi directory.

all-gdbtk: insight$(EXEEXT)

install-gdbtk:
	transformed_name=`t='$(program_transform_name)'; \
		  echo insight | sed -e $$t` ; \
	if test "x$$transformed_name" = x; then \
	  transformed_name=insight ; \
	else \
	  true ; \
	fi ; \
	$(SHELL) $(srcdir)/../mkinstalldirs $(DESTDIR)$(bindir); \
	$(INSTALL_PROGRAM) insight$(EXEEXT) \
		$(DESTDIR)$(bindir)/$$transformed_name$(EXEEXT) ; \
	$(SHELL) $(srcdir)/../mkinstalldirs \
		$(DESTDIR)$(GDBTK_LIBRARY) ; \
	$(SHELL) $(srcdir)/../mkinstalldirs \
		$(DESTDIR)$(libdir)/insight$(GDBTK_VERSION) ; \
	$(INSTALL_DATA) $(srcdir)/gdbtk/plugins/plugins.tcl \
		$(DESTDIR)$(libdir)/insight$(GDBTK_VERSION)/plugins.tcl ; \
	$(SHELL) $(srcdir)/../mkinstalldirs \
		$(DESTDIR)$(GDBTK_LIBRARY)/images \
		$(DESTDIR)$(GDBTK_LIBRARY)/images2 ; \
	$(SHELL) $(srcdir)/../mkinstalldirs \
		$(DESTDIR)$(GDBTK_LIBRARY)/help \
		$(DESTDIR)$(GDBTK_LIBRARY)/help/images \
		$(DESTDIR)$(GDBTK_LIBRARY)/help/trace ; \
	cd $(srcdir)/gdbtk/library ; \
	for i in *.tcl *.itcl *.ith *.itb images/*.gif images2/*.gif images/icons.txt images2/icons.txt tclIndex help/*.html  help/trace/*.html help/trace/index.toc help/images/*.gif help/images/*.png; \
	  do \
		$(INSTALL_DATA) $$i $(DESTDIR)$(GDBTK_LIBRARY)/$$i ; \
	  done ;

uninstall-gdbtk:
	transformed_name=`t='$(program_transform_name)'; \
		  echo insight | sed -e $$t` ; \
	if test "x$$transformed_name" = x; then \
		transformed_name=insight ; \
	else \
		true ; \
	fi ; \
	rm -f $(DESTDIR)$(bindir)/$$transformed_name$(EXEEXT) ; \
	rm -rf $(DESTDIR)$(GDBTK_LIBRARY)

clean-gdbtk:
	rm -f insight$(EXEEXT)

# Removing the old gdb first works better if it is running, at least on SunOS.
insight$(EXEEXT): gdbtk-main.o main.o libgdb.a $(CONFIG_OBS) $(ADD_DEPS) \
		$(CDEPS) $(TDEPLIBS)
	rm -f insight$(EXEEXT)
	$(CC_LD) $(INTERNAL_LDFLAGS) $(WIN32LDAPP) \
		-o insight$(EXEEXT) gdbtk-main.o main.o $(CONFIG_OBS) libgdb.a \
		$(TDEPLIBS) $(TUI_LIBRARY) $(CLIBS) $(LOADLIBES)

gdbres.o: $(srcdir)/gdbtk/gdb.rc $(srcdir)/gdbtk/gdbtool.ico
	$(WINDRES) --include $(srcdir)/gdbtk $(srcdir)/gdbtk/gdb.rc gdbres.o

gdbtk.o: $(srcdir)/gdbtk/generic/gdbtk.c \
	$(srcdir)/gdbtk/generic/gdbtk.h $(defs_h) \
	$(symtab_h) $(inferior_h) $(command_h) \
	$(bfd_h) $(symfile_h) $(objfiles_h) $(target_h) $(gdb_string_h) \
	$(tracepoint_h) $(top_h) 
	$(CC) -c $(INTERNAL_CFLAGS) $(IDE_CFLAGS) $(ITCL_CFLAGS) \
        $(ITK_CFLAGS)  \
	$(TCL_CFLAGS) $(TK_CFLAGS) $(X11_CFLAGS) $(GDBTK_CFLAGS)\
		$(srcdir)/gdbtk/generic/gdbtk.c \
		-DGDBTK_LIBRARY=\"$(GDBTK_LIBRARY)\" -DSRC_DIR=\"$(GDBTK_SRC_DIR)\"

gdbtk-bp.o: $(srcdir)/gdbtk/generic/gdbtk-bp.c \
		$(srcdir)/gdbtk/generic/gdbtk.h \
		$(srcdir)/gdbtk/generic/gdbtk-cmds.h \
		$(defs_h) $(breakpoint_h) $(tracepoint_h) \
		$(symfile_h) $(symtab_h) $(gdb_string_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(IDE_CFLAGS) $(ITCL_CFLAGS) \
	 $(TCL_CFLAGS) $(TK_CFLAGS) $(X11_CFLAGS)   \
	$(GDBTK_CFLAGS) $(srcdir)/gdbtk/generic/gdbtk-bp.c \
	-DGDBTK_LIBRARY=\"$(GDBTK_LIBRARY)\"

gdbtk-cmds.o: $(srcdir)/gdbtk/generic/gdbtk-cmds.c \
	$(srcdir)/gdbtk/generic/gdbtk.h $(srcdir)/gdbtk/generic/gdbtk-cmds.h \
	$(defs_h) $(inferior_h)	$(source_h) $(symfile_h) $(objfiles_h) \
	$(gdbcore_h) $(demangle_h) $(linespec_h) $(tui_file_h) $(top_h) \
	$(annotate_h) $(block_h) $(dictionary_h) $(gdb_string_h) \
	$(dis_asm_h) $(gdbcmd_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(IDE_CFLAGS) $(ITCL_CFLAGS)	\
	 $(TCL_CFLAGS) $(TK_CFLAGS) $(X11_CFLAGS)		\
	$(GDBTK_CFLAGS) $(srcdir)/gdbtk/generic/gdbtk-cmds.c		\
	-DGDBTK_LIBRARY=\"$(GDBTK_LIBRARY)\"

gdbtk-hooks.o: $(srcdir)/gdbtk/generic/gdbtk-hooks.c \
	$(srcdir)/gdbtk/generic/gdbtk.h $(defs_h) \
	$(symtab_h) $(inferior_h) $(command_h) \
	$(bfd_h) $(symfile_h) $(objfiles_h) $(target_h) $(gdb_string_h) \
	$(tracepoint_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(IDE_CFLAGS) $(ITCL_CFLAGS)  \
	$(TCL_CFLAGS) $(TK_CFLAGS) $(X11_CFLAGS) $(GDBTK_CFLAGS)\
		$(srcdir)/gdbtk/generic/gdbtk-hooks.c -DGDBTK_LIBRARY=\"$(GDBTK_LIBRARY)\"

gdbtk-interp.o: $(srcdir)/gdbtk/generic/gdbtk-interp.c \
	$(defs_h) $(interps_h) $(ui_out_h) $(ui_file_h) \
	$(cli_out_h) $(gdb_string_h) $(cli_cmds_h) $(cli_decode_h) \
	$(srcdir)/gdbtk/generic/gdbtk.h
	$(CC) -c $(INTERNAL_CFLAGS) $(IDE_CFLAGS) $(ITCL_CFLAGS) \
	$(TCL_CFLAGS) $(TK_CFLAGS) $(X11_CFLAGS) $(GDBTK_CFLAGS) \
		$(srcdir)/gdbtk/generic/gdbtk-interp.c

gdbtk-main.o: $(srcdir)/gdbtk/generic/gdbtk-main.c $(defs_h) $(main_h) \
	$(gdb_string_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(IDE_CFLAGS) $(ITCL_CFLAGS)  \
	$(TCL_CFLAGS) $(TK_CFLAGS) $(X11_CFLAGS) $(GDBTK_CFLAGS)\
		$(srcdir)/gdbtk/generic/gdbtk-main.c -DGDBTK_LIBRARY=\"$(GDBTK_LIBRARY)\"

gdbtk-register.o: $(srcdir)/gdbtk/generic/gdbtk-register.c \
		$(srcdir)/gdbtk/generic/gdbtk.h \
		$(srcdir)/gdbtk/generic/gdbtk-cmds.h \
		$(defs_h) $(frame_h) $(value_h) $(gdb_string_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(IDE_CFLAGS) $(ITCL_CFLAGS) \
	 $(TCL_CFLAGS) $(TK_CFLAGS) $(X11_CFLAGS)   \
	$(GDBTK_CFLAGS) $(srcdir)/gdbtk/generic/gdbtk-register.c \
	-DGDBTK_LIBRARY=\"$(GDBTK_LIBRARY)\"

gdbtk-stack.o: $(srcdir)/gdbtk/generic/gdbtk-stack.c \
	$(srcdir)/gdbtk/generic/gdbtk.h $(srcdir)/gdbtk/generic/gdbtk-cmds.h \
	$(srcdir)/gdbtk/generic/gdbtk-wrapper.h \
	$(defs_h) $(target_h) $(breakpoint_h) $(linespec_h) \
	$(block_h) $(dictionary_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(IDE_CFLAGS) $(ITCL_CFLAGS) \
	 $(TCL_CFLAGS) $(TK_CFLAGS) $(X11_CFLAGS)   \
	$(GDBTK_CFLAGS) $(srcdir)/gdbtk/generic/gdbtk-stack.c \
	-DGDBTK_LIBRARY=\"$(GDBTK_LIBRARY)\"

gdbtk-varobj.o: $(srcdir)/gdbtk/generic/gdbtk-varobj.c \
		$(srcdir)/gdbtk/generic/gdbtk.h \
		$(defs_h) $(value_h) $(varobj_h) $(gdb_string_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(IDE_CFLAGS) $(ITCL_CFLAGS)  \
	$(TCL_CFLAGS) $(TK_CFLAGS) $(X11_CFLAGS) $(GDBTK_CFLAGS)\
		$(srcdir)/gdbtk/generic/gdbtk-varobj.c

gdbtk-wrapper.o: $(srcdir)/gdbtk/generic/gdbtk-wrapper.c \
	$(srcdir)/gdbtk/generic/gdbtk-wrapper.h \
	$(defs_h) $(frame_h) $(value_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(IDE_CFLAGS) $(GDBTK_CFLAGS)\
		$(srcdir)/gdbtk/generic/gdbtk-wrapper.c

#
# gdb/mi/ dependencies
#
# Need to explicitly specify the compile rule as make will do nothing
# or try to compile the object file into the sub-directory.

mi-cmd-break.o: $(srcdir)/mi/mi-cmd-break.c $(defs_h) $(mi_cmds_h) \
	$(ui_out_h) $(mi_out_h) $(breakpoint_h) $(gdb_string_h) \
	$(mi_getopt_h) $(gdb_events_h) $(gdb_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/mi/mi-cmd-break.c
mi-cmd-disas.o: $(srcdir)/mi/mi-cmd-disas.c $(defs_h) $(target_h) $(value_h) \
	$(mi_cmds_h) $(mi_getopt_h) $(gdb_string_h) $(ui_out_h) $(disasm_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/mi/mi-cmd-disas.c
mi-cmd-env.o: $(srcdir)/mi/mi-cmd-env.c $(defs_h) $(inferior_h) $(value_h) \
	$(mi_out_h) $(mi_cmds_h) $(mi_getopt_h) $(symtab_h) $(target_h) \
	$(environ_h) $(command_h) $(ui_out_h) $(top_h) $(gdb_string_h) \
	$(gdb_stat_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/mi/mi-cmd-env.c
mi-cmd-file.o: $(srcdir)/mi/mi-cmd-file.c $(defs_h) $(mi_cmds_h) \
	$(mi_getopt_h) $(ui_out_h) $(symtab_h) $(source_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/mi/mi-cmd-file.c
mi-cmds.o: $(srcdir)/mi/mi-cmds.c $(defs_h) $(top_h) $(mi_cmds_h) \
	$(gdb_string_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/mi/mi-cmds.c
mi-cmd-stack.o: $(srcdir)/mi/mi-cmd-stack.c $(defs_h) $(target_h) $(frame_h) \
	$(value_h) $(mi_cmds_h) $(ui_out_h) $(symtab_h) $(block_h) \
	$(stack_h) $(dictionary_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/mi/mi-cmd-stack.c
mi-cmd-var.o: $(srcdir)/mi/mi-cmd-var.c $(defs_h) $(mi_cmds_h) $(ui_out_h) \
	$(mi_out_h) $(varobj_h) $(value_h) $(gdb_string_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/mi/mi-cmd-var.c
mi-console.o: $(srcdir)/mi/mi-console.c $(defs_h) $(mi_console_h) \
	$(gdb_string_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/mi/mi-console.c
mi-getopt.o: $(srcdir)/mi/mi-getopt.c $(defs_h) $(mi_getopt_h) \
	$(gdb_string_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/mi/mi-getopt.c
mi-interp.o: $(srcdir)/mi/mi-interp.c $(defs_h) $(gdb_string_h) $(interps_h) \
	$(event_top_h) $(event_loop_h) $(inferior_h) $(ui_out_h) $(top_h) \
	$(mi_main_h) $(mi_cmds_h) $(mi_out_h) $(mi_console_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/mi/mi-interp.c
mi-main.o: $(srcdir)/mi/mi-main.c $(defs_h) $(target_h) $(inferior_h) \
	$(gdb_string_h) $(top_h) $(gdbthread_h) $(mi_cmds_h) $(mi_parse_h) \
	$(mi_getopt_h) $(mi_console_h) $(ui_out_h) $(mi_out_h) $(interps_h) \
	$(event_loop_h) $(event_top_h) $(gdbcore_h) $(value_h) $(regcache_h) \
	$(gdb_h) $(frame_h) $(mi_main_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/mi/mi-main.c
mi-out.o: $(srcdir)/mi/mi-out.c $(defs_h) $(ui_out_h) $(mi_out_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/mi/mi-out.c
mi-parse.o: $(srcdir)/mi/mi-parse.c $(defs_h) $(mi_cmds_h) $(mi_parse_h) \
	$(gdb_string_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/mi/mi-parse.c
mi-symbol-cmds.o: $(srcdir)/mi/mi-symbol-cmds.c $(defs_h) $(mi_cmds_h) \
	$(symtab_h) $(ui_out_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/mi/mi-symbol-cmds.c

#
# rdi-share sub-directory
#
# Need to explicitly specify the compile rule as make will do nothing
# or try to compile the object file into the mi directory.

rdi-share/libangsd.a:	force
	@dir=rdi-share; \
	if [ -f ./$${dir}/Makefile ] ; then \
	  r=`pwd`; export r; \
	  srcroot=`cd $(srcdir); pwd`; export srcroot; \
	  (cd $${dir}; $(MAKE) $(FLAGS_TO_PASS) all); \
	else \
	  true; \
	fi

#
# gdb/signals/ dependencies
#
# Need to explicitly specify the compile rule as make will do nothing
# or try to compile the object file into the sub-directory.

signals.o: $(srcdir)/signals/signals.c $(server_h) $(defs_h) $(target_h) \
	$(gdb_string_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/signals/signals.c

#
# gdb/tui/ dependencies
#
# Need to explicitly specify the compile rule as make will do nothing
# or try to compile the object file into the sub-directory.

tuiCommand.o: $(srcdir)/tui/tuiCommand.c $(defs_h) $(tui_h) $(tuiData_h) \
	$(tuiWin_h) $(tuiIO_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tuiCommand.c
tuiDataWin.o: $(srcdir)/tui/tuiDataWin.c $(defs_h) $(tui_h) $(tuiData_h) \
	$(tuiGeneralWin_h) $(tuiRegs_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tuiDataWin.c
tuiData.o: $(srcdir)/tui/tuiData.c $(defs_h) $(symtab_h) $(tui_h) \
	$(tuiData_h) $(tuiGeneralWin_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tuiData.c
tuiDisassem.o: $(srcdir)/tui/tuiDisassem.c $(defs_h) $(symtab_h) \
	$(breakpoint_h) $(frame_h) $(value_h) $(source_h) $(disasm_h) \
	$(tui_h) $(tuiData_h) $(tuiWin_h) $(tuiLayout_h) $(tuiSourceWin_h) \
	$(tuiStack_h) $(tui_file_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tuiDisassem.c
tuiGeneralWin.o: $(srcdir)/tui/tuiGeneralWin.c $(defs_h) $(tui_h) \
	$(tuiData_h) $(tuiGeneralWin_h) $(tuiWin_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tuiGeneralWin.c
tuiIO.o: $(srcdir)/tui/tuiIO.c $(defs_h) $(terminal_h) $(target_h) \
	$(event_loop_h) $(event_top_h) $(command_h) $(top_h) $(readline_h) \
	$(tui_h) $(tuiData_h) $(tuiIO_h) $(tuiCommand_h) $(tuiWin_h) \
	$(tuiGeneralWin_h) $(tui_file_h) $(ui_out_h) $(cli_out_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tuiIO.c
tuiLayout.o: $(srcdir)/tui/tuiLayout.c $(defs_h) $(command_h) $(symtab_h) \
	$(frame_h) $(source_h) $(tui_h) $(tuiData_h) $(tuiDataWin_h) \
	$(tuiGeneralWin_h) $(tuiStack_h) $(tuiRegs_h) $(tuiWin_h) \
	$(tuiSourceWin_h) $(tuiDisassem_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tuiLayout.c
tuiRegs.o: $(srcdir)/tui/tuiRegs.c $(defs_h) $(tui_h) $(tuiData_h) \
	$(symtab_h) $(gdbtypes_h) $(gdbcmd_h) $(frame_h) $(regcache_h) \
	$(inferior_h) $(target_h) $(tuiLayout_h) $(tuiWin_h) $(tuiDataWin_h) \
	$(tuiGeneralWin_h) $(tui_file_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tuiRegs.c
tuiSourceWin.o: $(srcdir)/tui/tuiSourceWin.c $(defs_h) $(symtab_h) \
	$(frame_h) $(breakpoint_h) $(value_h) $(source_h) $(tui_h) \
	$(tuiData_h) $(tuiStack_h) $(tuiWin_h) $(tuiGeneralWin_h) \
	$(tuiSourceWin_h) $(tuiSource_h) $(tuiDisassem_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tuiSourceWin.c
tuiSource.o: $(srcdir)/tui/tuiSource.c $(defs_h) $(symtab_h) $(frame_h) \
	$(breakpoint_h) $(source_h) $(symtab_h) $(tui_h) $(tuiData_h) \
	$(tuiStack_h) $(tuiSourceWin_h) $(tuiSource_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tuiSource.c
tuiStack.o: $(srcdir)/tui/tuiStack.c $(defs_h) $(symtab_h) $(breakpoint_h) \
	$(frame_h) $(command_h) $(inferior_h) $(target_h) $(top_h) $(tui_h) \
	$(tuiData_h) $(tuiStack_h) $(tuiGeneralWin_h) $(tuiSource_h) \
	$(tuiSourceWin_h) $(tui_file_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tuiStack.c
tuiWin.o: $(srcdir)/tui/tuiWin.c $(defs_h) $(command_h) $(symtab_h) \
	$(breakpoint_h) $(frame_h) $(cli_cmds_h) $(top_h) $(source_h) \
	$(tui_h) $(tuiData_h) $(tuiGeneralWin_h) $(tuiStack_h) $(tuiRegs_h) \
	$(tuiDisassem_h) $(tuiSource_h) $(tuiSourceWin_h) $(tuiDataWin_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tuiWin.c
tui.o: $(srcdir)/tui/tui.c $(defs_h) $(gdbcmd_h) $(tui_h) $(tuiData_h) \
	$(tuiLayout_h) $(tuiIO_h) $(tuiRegs_h) $(tuiStack_h) $(tuiWin_h) \
	$(tuiSourceWin_h) $(tuiDataWin_h) $(readline_h) $(target_h) \
	$(frame_h) $(breakpoint_h) $(inferior_h) $(symtab_h) $(source_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tui.c
tui-file.o: $(srcdir)/tui/tui-file.c $(defs_h) $(ui_file_h) $(tui_file_h) \
	$(tui_tuiIO_h) $(tui_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tui-file.c
tui-hooks.o: $(srcdir)/tui/tui-hooks.c $(defs_h) $(symtab_h) $(inferior_h) \
	$(command_h) $(bfd_h) $(symfile_h) $(objfiles_h) $(target_h) \
	$(gdbcore_h) $(event_loop_h) $(event_top_h) $(frame_h) \
	$(breakpoint_h) $(gdb_events_h) $(ui_out_h) $(top_h) $(tui_h) \
	$(tuiData_h) $(tuiLayout_h) $(tuiIO_h) $(tuiRegs_h) $(tuiWin_h) \
	$(tuiStack_h) $(tuiDataWin_h) $(tuiSourceWin_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tui-hooks.c
tui-interp.o: $(srcdir)/tui/tui-interp.c $(defs_h) $(interps_h) $(top_h) \
	$(event_top_h) $(event_loop_h) $(ui_out_h) $(tui_tuiData_h) \
	$(readline_h) $(tui_tuiWin_h) $(tui_h) $(tui_tuiIO_h) $(cli_out_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tui-interp.c
tui-out.o: $(srcdir)/tui/tui-out.c $(defs_h) $(ui_out_h) $(tui_h) \
	$(gdb_string_h) $(gdb_assert_h)
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/tui/tui-out.c

#
# vx-share sub-directory
#

xdr_ld.o: vx-share/xdr_ld.c $(defs_h) vx-share/vxTypes.h \
	vx-share/vxWorks.h vx-share/xdr_ld.h
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/vx-share/xdr_ld.c

xdr_ptrace.o: vx-share/xdr_ptrace.c $(defs_h) vx-share/vxTypes.h \
	vx-share/vxWorks.h vx-share/xdr_ptrace.h
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/vx-share/xdr_ptrace.c

xdr_rdb.o: vx-share/xdr_rdb.c $(defs_h) vx-share/vxTypes.h \
	vx-share/vxWorks.h vx-share/xdr_rdb.h
	$(CC) -c $(INTERNAL_CFLAGS) $(srcdir)/vx-share/xdr_rdb.c

### end of the gdb Makefile.in.
