typedef unsigned char bu8;
typedef unsigned short bu16;
typedef unsigned int bu32;
typedef unsigned long long bu64;
typedef signed char bs8;
typedef short bs16;
typedef int bs32;
typedef long long bs64;

typedef struct
{
  bu32 dpregs[16], iregs[4], mregs[4], bregs[4], lregs[4];
  bu64 a0, a1;
  bu32 lt[2], lc[2], lb[2];
  int ac0, ac0_copy, ac1, an, aq;
  int av0, av0s, av1, av1s, az, cc, v, v_copy, vs;
  int v_internal;
  bu32 pc, rets;

  unsigned char *insn_end;

  int ticks;
  int stalls;
  int memstalls;
  int cycles;
  int insts;

  int prevlock;
  int thislock;
  int exception;

  int end_of_registers;

  int msize;
#define PROFILE_FREQ 1
#define PROFILE_SHIFT 2
  int profile;
  unsigned short *profile_hist;
  unsigned char *memory;
  int xyram_select, xram_start, yram_start;
  unsigned char *xmem;
  unsigned char *ymem;
  unsigned char *xmem_offset;
  unsigned char *ymem_offset;
  unsigned long bfd_mach;
} saved_state_type;

extern saved_state_type saved_state;

#define DREG(x) saved_state.dpregs[x]
#define DPREG(x) saved_state.dpregs[x]
#define GREG(x,i) DPREG ((x) | (i << 3))
#define PREG(x) saved_state.dpregs[x + 8]
#define SPREG 	(PREG(6))
#define FPREG 	(PREG(7))
#define IREG(x) saved_state.iregs[x]
#define LREG(x) saved_state.lregs[x]
#define MREG(x) saved_state.mregs[x]
#define BREG(x) saved_state.bregs[x]
#define A0REG   saved_state.a0
#define A1REG   saved_state.a1
#define CCREG saved_state.cc
#define PCREG saved_state.pc
#define LC0REG saved_state.lc[0]
#define LT0REG saved_state.lt[0]
#define LB0REG saved_state.lb[0]
#define LC1REG saved_state.lc[1]
#define LT1REG saved_state.lt[1]
#define LB1REG saved_state.lb[1]
#define RETSREG saved_state.rets
#define PCREG saved_state.pc

extern int did_jump;

typedef struct
{
  
} bfin_sim_info;

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
  return memory[addr] | (memory[addr + 1] << 8);
}

static inline bu32 get_long (unsigned char *memory, bu32 addr)
{
  return (memory[addr] | (memory[addr + 1] << 8)
	  | (memory[addr + 2] << 16) | (memory[addr + 3] << 24));
}
