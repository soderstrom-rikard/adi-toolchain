#include "sysdep.h"
#include "gdb/callback.h"
#include "gdb/remote-sim.h"
#include "sim-config.h"
#include "sim-types.h"

typedef unsigned8 bu8;
typedef unsigned16 bu16;
typedef unsigned32 bu32;
typedef unsigned64 bu64;
typedef signed8 bs8;
typedef signed16 bs16;
typedef signed32 bs32;
typedef signed64 bs64;

typedef struct
{
  bu32 dpregs[16], iregs[4], mregs[4], bregs[4], lregs[4];
  bu32 a0x, a0w, a1x, a1w;
  bu32 lt[2], lc[2], lb[2];
  int ac0, ac0_copy, ac1, an, aq;
  int av0, av0s, av1, av1s, az, cc, v, v_copy, vs;
  int v_internal;
  bu32 pc, rets;

  int ticks;
  int insts;

  int exception;

  int end_of_registers;

  int msize;
  unsigned char *memory;
  unsigned long bfd_mach;
} saved_state_type;

extern saved_state_type saved_state;

#define GREG(x,i)	DPREG ((x) | (i << 3))
#define DPREG(x)	(saved_state.dpregs[x])
#define DREG(x)		(saved_state.dpregs[x])
#define PREG(x)		(saved_state.dpregs[x + 8])
#define SPREG		PREG (6)
#define FPREG		PREG (7)
#define IREG(x)		(saved_state.iregs[x])
#define MREG(x)		(saved_state.mregs[x])
#define BREG(x)		(saved_state.bregs[x])
#define LREG(x)		(saved_state.lregs[x])
#define A0XREG		(saved_state.a0x)
#define A0WREG		(saved_state.a0w)
#define A1XREG		(saved_state.a1x)
#define A1WREG		(saved_state.a1w)
#define CCREG		(saved_state.cc)
#define LC0REG		(saved_state.lc[0])
#define LT0REG		(saved_state.lt[0])
#define LB0REG		(saved_state.lb[0])
#define LC1REG		(saved_state.lc[1])
#define LT1REG		(saved_state.lt[1])
#define LB1REG		(saved_state.lb[1])
#define RETSREG		(saved_state.rets)
#define PCREG		(saved_state.pc)

extern int did_jump;

static inline void put_byte (unsigned char *memory, bu32 addr, bu8 v)
{
  memory[addr] = v;
}

static inline void put_word (unsigned char *memory, bu32 addr, bu16 v)
{
  memory[addr] = v;
  memory[addr + 1] = v >> 8;
}

static inline void put_long (unsigned char *memory, bu32 addr, bu32 v)
{
  memory[addr] = v;
  memory[addr + 1] = v >> 8;
  memory[addr + 2] = v >> 16;
  memory[addr + 3] = v >> 24;
}

static inline bu8 get_byte (unsigned char *memory, bu32 addr)
{
  return memory[addr];
}

static inline bu16 get_word (unsigned char *memory, bu32 addr)
{
  return (memory[addr] | (memory[addr + 1] << 8));
}

static inline bu32 get_long (unsigned char *memory, bu32 addr)
{
  return (memory[addr] | (memory[addr + 1] << 8)
	  | (memory[addr + 2] << 16) | (memory[addr + 3] << 24));
}

extern void interp_insn_bfin (bu32);

