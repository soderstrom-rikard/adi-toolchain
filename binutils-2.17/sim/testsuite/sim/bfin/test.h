/* AZ AN AC0_COPY V_COPY CC AQ RND_MOD AC0 AC1 AV0 AV0S AV1 AV1S V VS */

#define _AZ		(1 << 0)
#define _AN		(1 << 1)
#define _AC0_COPY	(1 << 2)
#define _V_COPY		(1 << 3)
#define _CC		(1 << 5)
#define _AQ		(1 << 6)
#define _RND_MOD	(1 << 8)
#define _AC0		(1 << 12)
#define _AC1		(1 << 13)
#define _AV0		(1 << 16)
#define _AV0S		(1 << 17)
#define _AV1		(1 << 18)
#define _AV1S		(1 << 19)
#define _V		(1 << 24)
#define _VS		(1 << 25)

#define _SET		1
#define _UNSET		0

#define HI(x) (((x) >> 16) & 0xffff)
#define LO(x) ((x) & 0xffff)

#define INIT_R_REGS(val) init_r_regs val
#define INIT_P_REGS(val) init_p_regs val
#define INIT_B_REGS(val) init_b_regs val
#define INIT_I_REGS(val) init_i_regs val
#define INIT_L_REGS(val) init_l_regs val
#define INIT_M_REGS(val) init_m_regs val
#define include(...)
#define CHECK_INIT_DEF(...) nop;
#define CHECK_INIT(...) nop;
#define CHECKMEM32(...)
#define GEN_INT_INIT(...) nop;

#define LD32_LABEL(reg, sym) loadsym reg, sym
#define LD32(reg, val) imm32 reg, val
#define CHECKREG(reg, val) CHECKREG reg, val
#define CHECKREG_SYM_JUMPLESS(reg, sym, scratch_reg) \
	loadsym scratch_reg, sym; \
	cc = reg == scratch_reg; \
	/* Need to avoid jumping for trace buffer.  */ \
	if !cc jump fail_lvl;
#define CHECKREG_SYM(reg, sym, scratch_reg) \
	loadsym scratch_reg, sym; \
	cc = reg == scratch_reg; \
	if cc jump 9f; \
	dbg_fail; \
9:

#define WR_MMR(mmr, val, mmr_reg, val_reg) \
	imm32 mmr_reg, mmr; \
	imm32 val_reg, val; \
	[mmr_reg] = val_reg;
#define WR_MMR_LABEL(mmr, sym, mmr_reg, sym_reg) \
	loadsym sym_reg, sym; \
	imm32 mmr_reg, mmr; \
	[mmr_reg] = sym_reg;
#define RD_MMR(mmr, mmr_reg, val_reg) \
	imm32 mmr_reg, mmr; \
	val_reg = [mmr_reg];

/* Legacy CPLB bits */
#define CPLB_L1_CACHABLE CPLB_L1_CHBL
#define CPLB_USER_RO CPLB_USER_RD

#define DATA_ADDR_1 0xff800000
#define DATA_ADDR_2 0xff900000
#define DATA_ADDR_3 (DATA_ADDR_1 + 0x2000)

#define SRAM_BASE_ADDRESS 0xFFE00000

#define DMEM_BASE        0xFFE00000
#define DMEM_CONTROL     (DMEM_BASE + 4 * 1)
#define DCPLB_STATUS     (DMEM_BASE + 4 * 2)
#define DCPLB_FAULT_ADDR (DMEM_BASE + 4 * 3)
#define DCPLB_ADDR0  (DMEM_BASE + 0x100 + 4 * 0)
#define DCPLB_ADDR1  (DMEM_BASE + 0x100 + 4 * 1)
#define DCPLB_ADDR2  (DMEM_BASE + 0x100 + 4 * 2)
#define DCPLB_ADDR3  (DMEM_BASE + 0x100 + 4 * 3)
#define DCPLB_ADDR4  (DMEM_BASE + 0x100 + 4 * 4)
#define DCPLB_ADDR5  (DMEM_BASE + 0x100 + 4 * 5)
#define DCPLB_ADDR6  (DMEM_BASE + 0x100 + 4 * 6)
#define DCPLB_ADDR7  (DMEM_BASE + 0x100 + 4 * 7)
#define DCPLB_ADDR8  (DMEM_BASE + 0x100 + 4 * 8)
#define DCPLB_ADDR9  (DMEM_BASE + 0x100 + 4 * 9)
#define DCPLB_ADDR10 (DMEM_BASE + 0x100 + 4 * 10)
#define DCPLB_ADDR11 (DMEM_BASE + 0x100 + 4 * 11)
#define DCPLB_ADDR12 (DMEM_BASE + 0x100 + 4 * 12)
#define DCPLB_ADDR13 (DMEM_BASE + 0x100 + 4 * 13)
#define DCPLB_ADDR14 (DMEM_BASE + 0x100 + 4 * 14)
#define DCPLB_ADDR15 (DMEM_BASE + 0x100 + 4 * 15)
#define DCPLB_DATA0  (DMEM_BASE + 0x200 + 4 * 0)
#define DCPLB_DATA1  (DMEM_BASE + 0x200 + 4 * 1)
#define DCPLB_DATA2  (DMEM_BASE + 0x200 + 4 * 2)
#define DCPLB_DATA3  (DMEM_BASE + 0x200 + 4 * 3)
#define DCPLB_DATA4  (DMEM_BASE + 0x200 + 4 * 4)
#define DCPLB_DATA5  (DMEM_BASE + 0x200 + 4 * 5)
#define DCPLB_DATA6  (DMEM_BASE + 0x200 + 4 * 6)
#define DCPLB_DATA7  (DMEM_BASE + 0x200 + 4 * 7)
#define DCPLB_DATA8  (DMEM_BASE + 0x200 + 4 * 8)
#define DCPLB_DATA9  (DMEM_BASE + 0x200 + 4 * 9)
#define DCPLB_DATA10 (DMEM_BASE + 0x200 + 4 * 10)
#define DCPLB_DATA11 (DMEM_BASE + 0x200 + 4 * 11)
#define DCPLB_DATA12 (DMEM_BASE + 0x200 + 4 * 12)
#define DCPLB_DATA13 (DMEM_BASE + 0x200 + 4 * 13)
#define DCPLB_DATA14 (DMEM_BASE + 0x200 + 4 * 14)
#define DCPLB_DATA15 (DMEM_BASE + 0x200 + 4 * 15)

#define IMEM_BASE        0xFFE01000
#define IMEM_CONTROL     (IMEM_BASE + 4 * 1)
#define ICPLB_STATUS     (IMEM_BASE + 4 * 2)
#define ICPLB_FAULT_ADDR (IMEM_BASE + 4 * 3)
#define ICPLB_ADDR0  (IMEM_BASE + 0x100 + 4 * 0)
#define ICPLB_ADDR1  (IMEM_BASE + 0x100 + 4 * 1)
#define ICPLB_ADDR2  (IMEM_BASE + 0x100 + 4 * 2)
#define ICPLB_ADDR3  (IMEM_BASE + 0x100 + 4 * 3)
#define ICPLB_ADDR4  (IMEM_BASE + 0x100 + 4 * 4)
#define ICPLB_ADDR5  (IMEM_BASE + 0x100 + 4 * 5)
#define ICPLB_ADDR6  (IMEM_BASE + 0x100 + 4 * 6)
#define ICPLB_ADDR7  (IMEM_BASE + 0x100 + 4 * 7)
#define ICPLB_ADDR8  (IMEM_BASE + 0x100 + 4 * 8)
#define ICPLB_ADDR9  (IMEM_BASE + 0x100 + 4 * 9)
#define ICPLB_ADDR10 (IMEM_BASE + 0x100 + 4 * 10)
#define ICPLB_ADDR11 (IMEM_BASE + 0x100 + 4 * 11)
#define ICPLB_ADDR12 (IMEM_BASE + 0x100 + 4 * 12)
#define ICPLB_ADDR13 (IMEM_BASE + 0x100 + 4 * 13)
#define ICPLB_ADDR14 (IMEM_BASE + 0x100 + 4 * 14)
#define ICPLB_ADDR15 (IMEM_BASE + 0x100 + 4 * 15)
#define ICPLB_DATA0  (IMEM_BASE + 0x200 + 4 * 0)
#define ICPLB_DATA1  (IMEM_BASE + 0x200 + 4 * 1)
#define ICPLB_DATA2  (IMEM_BASE + 0x200 + 4 * 2)
#define ICPLB_DATA3  (IMEM_BASE + 0x200 + 4 * 3)
#define ICPLB_DATA4  (IMEM_BASE + 0x200 + 4 * 4)
#define ICPLB_DATA5  (IMEM_BASE + 0x200 + 4 * 5)
#define ICPLB_DATA6  (IMEM_BASE + 0x200 + 4 * 6)
#define ICPLB_DATA7  (IMEM_BASE + 0x200 + 4 * 7)
#define ICPLB_DATA8  (IMEM_BASE + 0x200 + 4 * 8)
#define ICPLB_DATA9  (IMEM_BASE + 0x200 + 4 * 9)
#define ICPLB_DATA10 (IMEM_BASE + 0x200 + 4 * 10)
#define ICPLB_DATA11 (IMEM_BASE + 0x200 + 4 * 11)
#define ICPLB_DATA12 (IMEM_BASE + 0x200 + 4 * 12)
#define ICPLB_DATA13 (IMEM_BASE + 0x200 + 4 * 13)
#define ICPLB_DATA14 (IMEM_BASE + 0x200 + 4 * 14)
#define ICPLB_DATA15 (IMEM_BASE + 0x200 + 4 * 15)

#define EVT0         0xFFE02000
#define EVT1         (EVT0 + 4 * 1)
#define EVT2         (EVT0 + 4 * 2)
#define EVT3         (EVT0 + 4 * 3)
#define EVT4         (EVT0 + 4 * 4)
#define EVT5         (EVT0 + 4 * 5)
#define EVT6         (EVT0 + 4 * 6)
#define EVT7         (EVT0 + 4 * 7)
#define EVT8         (EVT0 + 4 * 8)
#define EVT9         (EVT0 + 4 * 9)
#define EVT10        (EVT0 + 4 * 10)
#define EVT11        (EVT0 + 4 * 11)
#define EVT12        (EVT0 + 4 * 12)
#define EVT13        (EVT0 + 4 * 13)
#define EVT14        (EVT0 + 4 * 14)
#define EVT15        (EVT0 + 4 * 15)

#define EVT_OVERRIDE 0xFFE02100
#define IMASK        (EVT_OVERRIDE + 4 * 1)
#define IPEND        (EVT_OVERRIDE + 4 * 2)
#define ILAT         (EVT_OVERRIDE + 4 * 3)
#define EVT_IMASK    IMASK

#define TBUFCTL      0xFFE06000
#define TBUFSTAT     (TBUFCTL + 4)
#define TBUF         0xFFE06100

#include "../../../bfin/dv-bfin_mmu.h"
