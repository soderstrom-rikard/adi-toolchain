/*
 * Blackfin emulation
 *
 * Copyright 2007-2011 Mike Frysinger
 * Copyright 2007-2011 Analog Devices, Inc.
 *
 * Licensed under the Lesser GPL 2 or later.
 */

#ifndef CPU_BFIN_H
#define CPU_BFIN_H

struct DisasContext;

#define TARGET_LONG_BITS 32

#include "cpu-defs.h"

#define TARGET_HAS_ICE 1

#define EXCP_SYSCALL        0
#define EXCP_SOFT_BP        1
#define EXCP_STACK_OVERFLOW 3
#define EXCP_SINGLE_STEP    0x10
#define EXCP_TRACE_FULL     0x11
#define EXCP_UNDEF_INST     0x21
#define EXCP_ILL_INST       0x22
#define EXCP_DCPLB_VIOLATE  0x23
#define EXCP_DATA_MISALGIN  0x24
#define EXCP_UNRECOVERABLE  0x25
#define EXCP_DCPLB_MISS     0x26
#define EXCP_DCPLB_MULT     0x27
#define EXCP_EMU_WATCH      0x28
#define EXCP_MISALIG_INST   0x2a
#define EXCP_ICPLB_PROT     0x2b
#define EXCP_ICPLB_MISS     0x2c
#define EXCP_ICPLB_MULT     0x2d
#define EXCP_ILL_SUPV       0x2e
#define EXCP_ABORT          0x100
#define EXCP_DBGA           0x101
#define EXCP_OUTC           0x102

#define CPU_INTERRUPT_NMI   CPU_INTERRUPT_TGT_EXT_1

#define BFIN_L1_CACHE_BYTES 32

/* Blackfin does 1K/4K/1M/4M, but for now only support 4k */
#define TARGET_PAGE_BITS    12
#define NB_MMU_MODES        2

#define TARGET_PHYS_ADDR_SPACE_BITS 32
#define TARGET_VIRT_ADDR_SPACE_BITS 32

#define CPUState struct CPUBFINState
#define cpu_init cpu_bfin_init
#define cpu_exec cpu_bfin_exec
#define cpu_gen_code cpu_bfin_gen_code
#define cpu_signal_handler cpu_bfin_signal_handler

/* Indexes into astat array; matches bitpos in hardware too */
enum {
    ASTAT_AZ = 0,
    ASTAT_AN,
    ASTAT_AC0_COPY,
    ASTAT_V_COPY,
    ASTAT_CC = 5,
    ASTAT_AQ,
    ASTAT_RND_MOD = 8,
    ASTAT_AC0 = 12,
    ASTAT_AC1,
    ASTAT_AV0 = 16,
    ASTAT_AV0S,
    ASTAT_AV1,
    ASTAT_AV1S,
    ASTAT_V = 24,
    ASTAT_VS
};

typedef struct CPUBFINState {
    CPU_COMMON
    int personality;

    uint32_t dreg[8];
    uint32_t preg[8];
    uint32_t ireg[4];
    uint32_t mreg[4];
    uint32_t breg[4];
    uint32_t lreg[4];
    uint64_t areg[2];
    uint32_t rets;
    uint32_t lcreg[2], ltreg[2], lbreg[2];
    uint32_t cycles[2];
    uint32_t uspreg;
    uint32_t seqstat;
    uint32_t syscfg;
    uint32_t reti;
    uint32_t retx;
    uint32_t retn;
    uint32_t rete;
    uint32_t emudat;
    uint32_t pc;

    /* ASTAT bits; broken up for speeeeeeeed */
    uint32_t astat[32];
    /* ASTAT delayed helpers */
    uint32_t astat_op, astat_arg[3];
} CPUBFINState;
#define spreg preg[6]
#define fpreg preg[7]

static inline uint32_t bfin_astat_read(CPUState *env)
{
    unsigned int i, ret;

    ret = 0;
    for (i = 0; i < 32; ++i)
        ret |= (env->astat[i] << i);

    return ret;
}

static inline void bfin_astat_write(CPUState *env, uint32_t astat)
{
    unsigned int i;
    for (i = 0; i < 32; ++i)
        env->astat[i] = !!(astat & (1 << i));
}

enum astat_ops {
    ASTAT_OP_NONE,
    ASTAT_OP_DYNAMIC,
    ASTAT_OP_ABS,
    ASTAT_OP_ABS_VECTOR,
    ASTAT_OP_ADD16,
    ASTAT_OP_ADD32,
    ASTAT_OP_ASHIFT16,
    ASTAT_OP_ASHIFT32,
    ASTAT_OP_COMPARE_SIGNED,
    ASTAT_OP_COMPARE_UNSIGNED,
    ASTAT_OP_LOGICAL,
    ASTAT_OP_LSHIFT16,
    ASTAT_OP_LSHIFT32,
    ASTAT_OP_LSHIFT_RT16,
    ASTAT_OP_LSHIFT_RT32,
    ASTAT_OP_MIN_MAX,
    ASTAT_OP_MIN_MAX_VECTOR,
    ASTAT_OP_NEGATE,
    ASTAT_OP_SUB16,
    ASTAT_OP_SUB32,
    ASTAT_OP_VECTOR_ADD_ADD,    /* +|+ */
    ASTAT_OP_VECTOR_ADD_SUB,    /* +|- */
    ASTAT_OP_VECTOR_SUB_SUB,    /* -|- */
    ASTAT_OP_VECTOR_SUB_ADD,    /* -|+ */
};

typedef void (*hwloop_callback)(struct DisasContext *dc, int loop);

typedef struct DisasContext {
    CPUState *env;
    struct TranslationBlock *tb;
    /* The current PC we're decoding (could be middle of parallel insn) */
    target_ulong pc;
    /* Length of current insn (2/4/8) */
    target_ulong insn_len;

    /* For delayed ASTAT handling */
    enum astat_ops astat_op;

    /* For hardware loop processing */
    hwloop_callback hwloop_callback;
    void *hwloop_data;

    /* Was a DISALGNEXCPT used in this parallel insn ? */
    int disalgnexcpt;

    int is_jmp;
    int mem_idx;
} DisasContext;

void do_interrupt(CPUState *env);
CPUState *cpu_init(const char *cpu_model);
int cpu_exec(CPUState *s);
int cpu_bfin_signal_handler(int host_signum, void *pinfo, void *puc);

extern const char * const greg_names[];
extern const char *get_allreg_name(int grp, int reg);

#define MMU_KERNEL_IDX 0
#define MMU_USER_IDX   1

int cpu_bfin_handle_mmu_fault(CPUState *env, target_ulong address, int rw,
                              int mmu_idx);
#define cpu_handle_mmu_fault cpu_bfin_handle_mmu_fault

#if defined(CONFIG_USER_ONLY)
static inline void cpu_clone_regs(CPUState *env, target_ulong newsp)
{
    if (newsp)
        env->spreg = newsp;
}
#endif

#include "cpu-all.h"

static inline int cpu_has_work(CPUState *env)
{
    return (env->interrupt_request & (CPU_INTERRUPT_HARD | CPU_INTERRUPT_NMI));
}

static inline int cpu_halted(CPUState *env)
{
    if (!env->halted)
        return 0;
    if (env->interrupt_request & CPU_INTERRUPT_HARD) {
        env->halted = 0;
        return 0;
    }
    return EXCP_HALTED;
}

#include "exec-all.h"

static inline void cpu_pc_from_tb(CPUState *env, TranslationBlock *tb)
{
    env->pc = tb->pc;
}

static inline target_ulong cpu_get_pc(CPUState *env)
{
    return env->pc;
}

static inline void cpu_get_tb_cpu_state(CPUState *env, target_ulong *pc,
                                        target_ulong *cs_base, int *flags)
{
    *pc = cpu_get_pc(env);
    *cs_base = 0;
    *flags = env->astat[ASTAT_RND_MOD];
}

#endif
