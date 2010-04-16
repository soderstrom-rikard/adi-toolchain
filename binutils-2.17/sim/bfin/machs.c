/* Simulator for Analog Devices Blackfin processers.

   Copyright (C) 2005-2010 Free Software Foundation, Inc.
   Contributed by Analog Devices, Inc.

   This file is part of simulators.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

#include "sim-main.h"
#include "gdb/sim-bfin.h"
#include "bfd.h"

#include "sim-hw.h"
#include "devices.h"
#include "dv-bfin_cec.h"
#include "dv-bfin_ctimer.h"
#include "dv-bfin_dma.h"
#include "dv-bfin_ebiu_amc.h"
#include "dv-bfin_ebiu_sdc.h"
#include "dv-bfin_evt.h"
#include "dv-bfin_mmu.h"
#include "dv-bfin_pll.h"
#include "dv-bfin_rtc.h"
#include "dv-bfin_sic.h"
#include "dv-bfin_trace.h"
#include "dv-bfin_uart.h"
#include "dv-bfin_wdog.h"

struct bfin_memory_layout {
  address_word addr, len;
  unsigned mask;	/* see mapmask in sim_core_attach() */
};
struct bfin_dev_layout {
  address_word base, len;
  const char *dev;
};
struct bfin_model_data {
  bu32 chipid;
  const struct bfin_memory_layout *mem;
  size_t mem_count;
  const struct bfin_dev_layout *dev;
  size_t dev_count;
};

static const MACH bfin_mach;

const MACH *sim_machs[] =
{
  & bfin_mach,
  NULL
};

#define LAYOUT(_addr, _len, _mask) { .addr = _addr, .len = _len, .mask = access_##_mask, }
#define DEVICE(_base, _len, _dev) { .base = _base, .len = _len, .dev = _dev, }

/* [1] Common sim code can't model exec-only memory.
   http://sourceware.org/ml/gdb/2010-02/msg00047.html */

#define bfin_chipid 0
static const struct bfin_memory_layout bfin_mem[] = {};
static const struct bfin_dev_layout bfin_dev[] = {};

#define bf50x_chipid 0x2800
#define bf504_chipid bf50x_chipid
#define bf506_chipid bf50x_chipid
static const struct bfin_memory_layout bf50x_mem[] = {
  LAYOUT (0xFF800000, 0x4000, read_write),	/* Data A */
  LAYOUT (0xFF804000, 0x8000, read_write),	/* Data A Cache */
  LAYOUT (0xFFA00000, 0x4000, read_write_exec),	/* Inst A [1] */
  LAYOUT (0xFFA04000, 0x4000, read_write_exec),	/* Inst Cache [1] */
};
#define bf504_mem bf50x_mem
#define bf506_mem bf50x_mem
static const struct bfin_dev_layout bf50x_dev[] = {
  DEVICE (0xFFC00400, BFIN_MMR_UART_SIZE, "bfin_uart"),
};
#define bf504_dev bf50x_dev
#define bf506_dev bf50x_dev

#define bf51x_chipid 0x27e8
#define bf512_chipid bf51x_chipid
#define bf514_chipid bf51x_chipid
#define bf516_chipid bf51x_chipid
#define bf518_chipid bf51x_chipid
static const struct bfin_memory_layout bf51x_mem[] = {
  LAYOUT (0xFF800000, 0x4000, read_write),	/* Data A */
  LAYOUT (0xFF804000, 0x4000, read_write),	/* Data A Cache */
  LAYOUT (0xFF900000, 0x4000, read_write),	/* Data B */
  LAYOUT (0xFF904000, 0x4000, read_write),	/* Data B Cache */
  LAYOUT (0xFFA00000, 0x8000, read_write_exec),	/* Inst A [1] */
  LAYOUT (0xFFA10000, 0x4000, read_write_exec),	/* Inst Cache [1] */
};
#define bf512_mem bf51x_mem
#define bf514_mem bf51x_mem
#define bf516_mem bf51x_mem
#define bf518_mem bf51x_mem
static const struct bfin_dev_layout bf51x_dev[] = {
  DEVICE (0xFFC00400, BFIN_MMR_UART_SIZE, "bfin_uart@0"),
  DEVICE (0xFFC02000, BFIN_MMR_UART_SIZE, "bfin_uart@1"),
};
#define bf512_dev bf51x_dev
#define bf514_dev bf51x_dev
#define bf516_dev bf51x_dev
#define bf518_dev bf51x_dev

#define bf522_chipid 0x27e4
#define bf523_chipid 0x27e0
#define bf524_chipid bf522_chipid
#define bf525_chipid bf523_chipid
#define bf526_chipid bf522_chipid
#define bf527_chipid bf523_chipid
static const struct bfin_memory_layout bf52x_mem[] = {
  LAYOUT (0xFF800000, 0x4000, read_write),	/* Data A */
  LAYOUT (0xFF804000, 0x4000, read_write),	/* Data A Cache */
  LAYOUT (0xFF900000, 0x4000, read_write),	/* Data B */
  LAYOUT (0xFF904000, 0x4000, read_write),	/* Data B Cache */
  LAYOUT (0xFFA00000, 0x8000, read_write_exec),	/* Inst A [1] */
  LAYOUT (0xFFA08000, 0x4000, read_write_exec),	/* Inst B [1] */
  LAYOUT (0xFFA10000, 0x4000, read_write_exec),	/* Inst Cache [1] */
};
#define bf522_mem bf52x_mem
#define bf523_mem bf52x_mem
#define bf524_mem bf52x_mem
#define bf525_mem bf52x_mem
#define bf526_mem bf52x_mem
#define bf527_mem bf52x_mem
static const struct bfin_dev_layout bf52x_dev[] = {
  DEVICE (0xFFC00400, BFIN_MMR_UART_SIZE, "bfin_uart@0"),
  DEVICE (0xFFC02000, BFIN_MMR_UART_SIZE, "bfin_uart@1"),
};
#define bf522_dev bf52x_dev
#define bf523_dev bf52x_dev
#define bf524_dev bf52x_dev
#define bf525_dev bf52x_dev
#define bf526_dev bf52x_dev
#define bf527_dev bf52x_dev

#define bf531_chipid 0x27a5
#define bf532_chipid bf531_chipid
#define bf533_chipid bf531_chipid
static const struct bfin_memory_layout bf531_mem[] = {
  LAYOUT (0xFF804000, 0x4000, read_write),	/* Data A Cache */
  LAYOUT (0xFFA08000, 0x4000, read_write_exec),	/* Inst B [1] */
  LAYOUT (0xFFA10000, 0x4000, read_write_exec),	/* Inst Cache [1] */
};
static const struct bfin_memory_layout bf532_mem[] = {
  LAYOUT (0xFF804000, 0x4000, read_write),	/* Data A Cache */
  LAYOUT (0xFF904000, 0x4000, read_write),	/* Data B Cache */
  LAYOUT (0xFFA08000, 0x4000, read_write_exec),	/* Inst B [1] */
  LAYOUT (0xFFA0C000, 0x4000, read_write_exec),	/* Inst C [1] */
  LAYOUT (0xFFA10000, 0x4000, read_write_exec),	/* Inst Cache [1] */
};
static const struct bfin_memory_layout bf533_mem[] = {
  LAYOUT (0xFF800000, 0x4000, read_write),	/* Data A */
  LAYOUT (0xFF804000, 0x4000, read_write),	/* Data A Cache */
  LAYOUT (0xFF900000, 0x4000, read_write),	/* Data B */
  LAYOUT (0xFF904000, 0x4000, read_write),	/* Data B Cache */
  LAYOUT (0xFFA00000, 0x8000, read_write_exec),	/* Inst A [1] */
  LAYOUT (0xFFA08000, 0x4000, read_write_exec),	/* Inst B [1] */
  LAYOUT (0xFFA0C000, 0x4000, read_write_exec),	/* Inst C [1] */
  LAYOUT (0xFFA10000, 0x4000, read_write_exec),	/* Inst Cache [1] */
};
static const struct bfin_dev_layout bf533_dev[] = {
  DEVICE (0xFFC00400, BFIN_MMR_UART_SIZE, "bfin_uart"),
};
#define bf531_dev bf533_dev
#define bf532_dev bf533_dev

#define bf534_chipid 0x27c6
#define bf536_chipid 0x27c8
#define bf537_chipid bf536_chipid
static const struct bfin_memory_layout bf534_mem[] = {
  LAYOUT (0xFF800000, 0x4000, read_write),	/* Data A */
  LAYOUT (0xFF804000, 0x4000, read_write),	/* Data A Cache */
  LAYOUT (0xFF900000, 0x4000, read_write),	/* Data B */
  LAYOUT (0xFF904000, 0x4000, read_write),	/* Data B Cache */
  LAYOUT (0xFFA00000, 0x8000, read_write_exec),	/* Inst A [1] */
  LAYOUT (0xFFA08000, 0x4000, read_write_exec),	/* Inst B [1] */
  LAYOUT (0xFFA10000, 0x4000, read_write_exec),	/* Inst Cache [1] */
};
static const struct bfin_memory_layout bf536_mem[] = {
  LAYOUT (0xFF804000, 0x4000, read_write),	/* Data A Cache */
  LAYOUT (0xFF904000, 0x4000, read_write),	/* Data B Cache */
  LAYOUT (0xFFA00000, 0x8000, read_write_exec),	/* Inst A [1] */
  LAYOUT (0xFFA08000, 0x4000, read_write_exec),	/* Inst B [1] */
  LAYOUT (0xFFA10000, 0x4000, read_write_exec),	/* Inst Cache [1] */
};
static const struct bfin_memory_layout bf537_mem[] = {
  LAYOUT (0xFF800000, 0x4000, read_write),	/* Data A */
  LAYOUT (0xFF804000, 0x4000, read_write),	/* Data A Cache */
  LAYOUT (0xFF900000, 0x4000, read_write),	/* Data B */
  LAYOUT (0xFF904000, 0x4000, read_write),	/* Data B Cache */
  LAYOUT (0xFFA00000, 0x8000, read_write_exec),	/* Inst A [1] */
  LAYOUT (0xFFA08000, 0x4000, read_write_exec),	/* Inst B [1] */
  LAYOUT (0xFFA10000, 0x4000, read_write_exec),	/* Inst Cache [1] */
};
static const struct bfin_dev_layout bf537_dev[] = {
  DEVICE (0xFFC00400, BFIN_MMR_UART_SIZE, "bfin_uart@0"),
  DEVICE (0xFFC02000, BFIN_MMR_UART_SIZE, "bfin_uart@1"),
};
#define bf534_dev bf537_dev
#define bf536_dev bf537_dev

#define bf538_chipid 0x27c4
#define bf539_chipid bf538_chipid
static const struct bfin_memory_layout bf538_mem[] = {
  LAYOUT (0xFF800000, 0x4000, read_write),	/* Data A */
  LAYOUT (0xFF804000, 0x4000, read_write),	/* Data A Cache */
  LAYOUT (0xFF900000, 0x4000, read_write),	/* Data B */
  LAYOUT (0xFF904000, 0x4000, read_write),	/* Data B Cache */
  LAYOUT (0xFFA00000, 0x8000, read_write_exec),	/* Inst A [1] */
  LAYOUT (0xFFA08000, 0x4000, read_write_exec),	/* Inst B [1] */
  LAYOUT (0xFFA0C000, 0x4000, read_write_exec),	/* Inst C [1] */
  LAYOUT (0xFFA10000, 0x4000, read_write_exec),	/* Inst Cache [1] */
};
#define bf539_mem bf538_mem
static const struct bfin_dev_layout bf538_dev[] = {
  DEVICE (0xFFC00400, BFIN_MMR_UART_SIZE, "bfin_uart@0"),
  DEVICE (0xFFC02000, BFIN_MMR_UART_SIZE, "bfin_uart@1"),
  DEVICE (0xFFC02100, BFIN_MMR_UART_SIZE, "bfin_uart@2"),
};
#define bf539_dev bf538_dev

#define bf54x_chipid 0x27de
#define bf542_chipid bf54x_chipid
#define bf544_chipid bf54x_chipid
#define bf547_chipid bf54x_chipid
#define bf548_chipid bf54x_chipid
#define bf549_chipid bf54x_chipid
static const struct bfin_memory_layout bf54x_mem[] = {
  LAYOUT (0xFEB00000, 0x20000, read_write_exec),	/* L2 */
  LAYOUT (0xFF800000, 0x4000, read_write),	/* Data A */
  LAYOUT (0xFF804000, 0x4000, read_write),	/* Data A Cache */
  LAYOUT (0xFF900000, 0x4000, read_write),	/* Data B */
  LAYOUT (0xFF904000, 0x4000, read_write),	/* Data B Cache */
  LAYOUT (0xFFA00000, 0x8000, read_write_exec),	/* Inst A [1] */
  LAYOUT (0xFFA08000, 0x4000, read_write_exec),	/* Inst B [1] */
  LAYOUT (0xFFA10000, 0x4000, read_write_exec),	/* Inst Cache [1] */
};
#define bf542_mem bf54x_mem
#define bf544_mem bf54x_mem
#define bf547_mem bf54x_mem
#define bf548_mem bf54x_mem
#define bf549_mem bf54x_mem
static const struct bfin_dev_layout bf54x_dev[] = {
  DEVICE (0xFFC00400, BFIN_MMR_UART_SIZE, "bfin_uart@0"),
  DEVICE (0xFFC02000, BFIN_MMR_UART_SIZE, "bfin_uart@1"),
  DEVICE (0xFFC02100, BFIN_MMR_UART_SIZE, "bfin_uart@2"),
  DEVICE (0xFFC03100, BFIN_MMR_UART_SIZE, "bfin_uart@3"),
};
#define bf542_dev bf54x_dev
#define bf544_dev bf54x_dev
#define bf547_dev bf54x_dev
#define bf548_dev bf54x_dev
#define bf549_dev bf54x_dev

/* This is only Core A of course ...  */
#define bf561_chipid 0x27bb
static const struct bfin_memory_layout bf561_mem[] = {
  LAYOUT (0xFEB00000, 0x20000, read_write_exec),	/* L2 */
  LAYOUT (0xFF800000, 0x4000, read_write),	/* Data A */
  LAYOUT (0xFF804000, 0x4000, read_write),	/* Data A Cache */
  LAYOUT (0xFF900000, 0x4000, read_write),	/* Data B */
  LAYOUT (0xFF904000, 0x4000, read_write),	/* Data B Cache */
  LAYOUT (0xFFA00000, 0x4000, read_write_exec),	/* Inst A [1] */
  LAYOUT (0xFFA10000, 0x4000, read_write_exec),	/* Inst Cache [1] */
};
static const struct bfin_dev_layout bf561_dev[] = {
  DEVICE (0xFFC00400, BFIN_MMR_UART_SIZE, "bfin_uart"),
};

#define ASYNC_1_MEG (1 * 1024 * 1024)
#define ASYNC_4_MEG (4 * 1024 * 1024)

static const struct bfin_model_data bfin_model_data[] =
{
#define P(n) \
  [MODEL_BF##n] = { \
    bf##n##_chipid, \
    bf##n##_mem, ARRAY_SIZE (bf##n##_mem), \
    bf##n##_dev, ARRAY_SIZE (bf##n##_dev), \
  },
#include "_proc_list.h"
#undef P
};

#define CORE_DEVICE(dev, DEV) \
  DEVICE (BFIN_COREMMR_##DEV##_BASE, BFIN_COREMMR_##DEV##_SIZE, "bfin_"#dev)
static const struct bfin_dev_layout bfin_core_dev[] = {
  CORE_DEVICE (cec, CEC),
  CORE_DEVICE (ctimer, CTIMER),
  CORE_DEVICE (evt, EVT),
  CORE_DEVICE (mmu, MMU),
  CORE_DEVICE (trace, TRACE),
};

#define dv_bfin_hw_parse(sd, dv, DV) \
  do { \
    bu32 base = BFIN_MMR_##DV##_BASE; \
    bu32 size = BFIN_MMR_##DV##_SIZE; \
    sim_hw_parse (sd, "/core/bfin_"#dv"/reg %#x %i", base, size); \
  } while (0)

static void
bfin_model_hw_tree_init (SIM_DESC sd, SIM_CPU *cpu)
{
  const MODEL *model = CPU_MODEL (cpu);
  const struct bfin_model_data *mdata = CPU_MODEL_DATA (cpu);
  int mnum = MODEL_NUM (model);
  unsigned i;

  /* Map the core devices.  */
  for (i = 0; i < ARRAY_SIZE (bfin_core_dev); ++i)
    {
      const struct bfin_dev_layout *dev = &bfin_core_dev[i];
      sim_hw_parse (sd, "/core/%s/reg %#x %i", dev->dev, dev->base, dev->len);
    }
  sim_hw_parse (sd, "/core/bfin_ctimer > ivtmr ivtmr /core/bfin_cec");

  /* Map the common system devices.  */
  dv_bfin_hw_parse (sd, ebiu_amc, EBIU_AMC);
  dv_bfin_hw_parse (sd, ebiu_sdc, EBIU_SDC);
  dv_bfin_hw_parse (sd, pll, PLL);

  dv_bfin_hw_parse (sd, sic, SIC);
  for (i = 7; i < 16; ++i)
    sim_hw_parse (sd, "/core/bfin_sic > ivg%i ivg%i /core/bfin_cec", i, i);
  sim_hw_parse (sd, "/core/bfin_sic/model %s", MODEL_NAME (model));

  dv_bfin_hw_parse (sd, wdog, WDOG);
  sim_hw_parse (sd, "/core/bfin_wdog > reset rst      /core/bfin_cec");
  sim_hw_parse (sd, "/core/bfin_wdog > nmi   nmi      /core/bfin_cec");
  sim_hw_parse (sd, "/core/bfin_wdog > gpi   watchdog /core/bfin_sic");

  if (mnum != MODEL_BF561)
    dv_bfin_hw_parse (sd, rtc, RTC);

#if 0
  /* XXX: How to handle datafiles with sim ?  */
  sim_do_commandf (sd, "memory-mapfile %s", MODEL_NAME (model));
  sim_do_commandf (sd, "memory region 0xEF000000,0x100000,0x800");
#endif

  for (i = 0; i < mdata->dev_count; ++i)
    {
      const struct bfin_dev_layout *dev = &mdata->dev[i];
      sim_hw_parse (sd, "/core/%s/reg %#x %i", dev->dev, dev->base, dev->len);
    }

  /* XXX: Should be pushed to per-model structs.  */
  for (i = 0; i < 16; ++i)
    sim_hw_parse (sd, "/core/bfin_dma@%i/reg %#x %i", i,
		  0xFFC00C00 + i * BFIN_MMR_DMA_SIZE, BFIN_MMR_DMA_SIZE);
  sim_hw_parse (sd, "/core/bfin_dma@12/peer /core/bfin_dma@13"); /* MDMA0 D->S */
  sim_hw_parse (sd, "/core/bfin_dma@13/peer /core/bfin_dma@12"); /* MDMA0 S->D */
  sim_hw_parse (sd, "/core/bfin_dma@14/peer /core/bfin_dma@15"); /* MDMA1 D->S */
  sim_hw_parse (sd, "/core/bfin_dma@15/peer /core/bfin_dma@14"); /* MDMA1 S->D */

  /* Trigger all the new devices' finish func.  */
  hw_tree_finish (dv_get_device (cpu, "/"));
}

void
bfin_model_cpu_init (SIM_DESC sd, SIM_CPU *cpu)
{
  const MODEL *model = CPU_MODEL (cpu);
  const struct bfin_model_data *mdata = CPU_MODEL_DATA (cpu);
  int mnum = MODEL_NUM (model);
  size_t idx;

  if (mnum == MODEL_BFin)
    return;

  mdata = &bfin_model_data[MODEL_NUM (model)];

  /* These memory maps are supposed to be cpu-specific, but the common sim
     code does not yet allow that (2nd arg is "cpu" rather than "NULL".  */
  sim_core_attach (sd, NULL, 0, access_read_write, 0, BFIN_L1_SRAM_SCRATCH,
		   BFIN_L1_SRAM_SCRATCH_SIZE, 0, NULL, NULL);

  /* Map in the on-chip memory (bootrom/sram/etc...).  */
  for (idx = 0; idx < mdata->mem_count; ++idx)
    {
      const struct bfin_memory_layout *mem = &mdata->mem[idx];
      sim_core_attach (sd, NULL, 0, mem->mask, 0, mem->addr,
		       mem->len, 0, NULL, NULL);
    }

  /* Finally, build up the tree for this cpu model.  */
  bfin_model_hw_tree_init (sd, cpu);
}

bu32
bfin_model_get_chipid (SIM_DESC sd)
{
  SIM_CPU *cpu = STATE_CPU (sd, 0);
  const struct bfin_model_data *mdata = CPU_MODEL_DATA (cpu);
  return
	 (0x3 << 28) /* XXX: silicon rev */ |
	 (mdata->chipid << 12) |
	 (((0xE5 << 1) | 1) & 0xFF);
}

bu32
bfin_model_get_dspid (SIM_DESC sd)
{
  SIM_CPU *cpu = STATE_CPU (sd, 0);
  const struct bfin_model_data *mdata = CPU_MODEL_DATA (cpu);
  return
	 (0xE5 << 24) |
	 (0x04 << 16) |
	 (0x3) /* XXX: silicon rev */;
}

static void
bfin_model_init (SIM_CPU *cpu)
{
  CPU_MODEL_DATA (cpu) = (void *) &bfin_model_data[MODEL_NUM (CPU_MODEL (cpu))];
}

static bu32
bfin_extract_unsigned_integer (unsigned char *addr, int len)
{
  bu32 retval;
  unsigned char * p;
  unsigned char * startaddr = (unsigned char *)addr;
  unsigned char * endaddr = startaddr + len;

  retval = 0;

  for (p = endaddr; p > startaddr;)
    retval = (retval << 8) | *--p;

  return retval;
}

static void
bfin_store_unsigned_integer (unsigned char *addr, int len, bu32 val)
{
  unsigned char *p;
  unsigned char *startaddr = addr;
  unsigned char *endaddr = startaddr + len;

  for (p = startaddr; p < endaddr;)
    {
      *p++ = val & 0xff;
      val >>= 8;
    }
}

static bu32 *
bfin_get_reg (SIM_CPU *cpu, int rn)
{
  switch (rn)
    {
    case SIM_BFIN_R0_REGNUM: return &DREG (0);
    case SIM_BFIN_R1_REGNUM: return &DREG (1);
    case SIM_BFIN_R2_REGNUM: return &DREG (2);
    case SIM_BFIN_R3_REGNUM: return &DREG (3);
    case SIM_BFIN_R4_REGNUM: return &DREG (4);
    case SIM_BFIN_R5_REGNUM: return &DREG (5);
    case SIM_BFIN_R6_REGNUM: return &DREG (6);
    case SIM_BFIN_R7_REGNUM: return &DREG (7);
    case SIM_BFIN_P0_REGNUM: return &PREG (0);
    case SIM_BFIN_P1_REGNUM: return &PREG (1);
    case SIM_BFIN_P2_REGNUM: return &PREG (2);
    case SIM_BFIN_P3_REGNUM: return &PREG (3);
    case SIM_BFIN_P4_REGNUM: return &PREG (4);
    case SIM_BFIN_P5_REGNUM: return &PREG (5);
    case SIM_BFIN_SP_REGNUM: return &SPREG;
    case SIM_BFIN_FP_REGNUM: return &FPREG;
    case SIM_BFIN_I0_REGNUM: return &IREG (0);
    case SIM_BFIN_I1_REGNUM: return &IREG (1);
    case SIM_BFIN_I2_REGNUM: return &IREG (2);
    case SIM_BFIN_I3_REGNUM: return &IREG (3);
    case SIM_BFIN_M0_REGNUM: return &MREG (0);
    case SIM_BFIN_M1_REGNUM: return &MREG (1);
    case SIM_BFIN_M2_REGNUM: return &MREG (2);
    case SIM_BFIN_M3_REGNUM: return &MREG (3);
    case SIM_BFIN_B0_REGNUM: return &BREG (0);
    case SIM_BFIN_B1_REGNUM: return &BREG (1);
    case SIM_BFIN_B2_REGNUM: return &BREG (2);
    case SIM_BFIN_B3_REGNUM: return &BREG (3);
    case SIM_BFIN_L0_REGNUM: return &LREG (0);
    case SIM_BFIN_L1_REGNUM: return &LREG (1);
    case SIM_BFIN_L2_REGNUM: return &LREG (2);
    case SIM_BFIN_L3_REGNUM: return &LREG (3);
    case SIM_BFIN_RETS_REGNUM: return &RETSREG;
    case SIM_BFIN_A0_DOT_X_REGNUM: return &AXREG (0);
    case SIM_BFIN_AO_DOT_W_REGNUM: return &AWREG (0);
    case SIM_BFIN_A1_DOT_X_REGNUM: return &AXREG (1);
    case SIM_BFIN_A1_DOT_W_REGNUM: return &AWREG (1);
    case SIM_BFIN_LC0_REGNUM: return &LCREG (0);
    case SIM_BFIN_LT0_REGNUM: return &LTREG (0);
    case SIM_BFIN_LB0_REGNUM: return &LBREG (0);
    case SIM_BFIN_LC1_REGNUM: return &LCREG (1);
    case SIM_BFIN_LT1_REGNUM: return &LTREG (1);
    case SIM_BFIN_LB1_REGNUM: return &LBREG (1);
    case SIM_BFIN_CYCLES_REGNUM: return &CYCLESREG;
    case SIM_BFIN_CYCLES2_REGNUM: return &CYCLES2REG;
    case SIM_BFIN_USP_REGNUM: return &USPREG;
    case SIM_BFIN_SEQSTAT_REGNUM: return &SEQSTATREG;
    case SIM_BFIN_SYSCFG_REGNUM: return &SYSCFGREG;
    case SIM_BFIN_RETI_REGNUM: return &RETIREG;
    case SIM_BFIN_RETX_REGNUM: return &RETXREG;
    case SIM_BFIN_RETN_REGNUM: return &RETNREG;
    case SIM_BFIN_RETE_REGNUM: return &RETEREG;
    case SIM_BFIN_PC_REGNUM: return &PCREG;
    default: return NULL;
  }
}

static int
bfin_reg_fetch (SIM_CPU *cpu, int rn, unsigned char *buf, int len)
{
  bu32 value, *reg;

  reg = bfin_get_reg (cpu, rn);
  if (reg)
    value = *reg;
  else if (rn == SIM_BFIN_ASTAT_REGNUM)
    value = ASTAT;
  else if (rn == SIM_BFIN_CC_REGNUM)
    value = CCREG;
  else
    return 0; // will be an error in gdb

  /* Handle our KSP/USP shadowing in SP.  While in supervisor mode, we
     have the normal SP/USP behavior.  User mode is tricky though.  */
  if (STATE_ENVIRONMENT (CPU_STATE (cpu)) == OPERATING_ENVIRONMENT
      && cec_is_user_mode (cpu))
    {
      if (rn == SIM_BFIN_SP_REGNUM)
	value = KSPREG;
      else if (rn == SIM_BFIN_USP_REGNUM)
	value = SPREG;
    }

  bfin_store_unsigned_integer (buf, 4, value);

  return -1; // disables size checking in gdb
}

static int
bfin_reg_store (SIM_CPU *cpu, int rn, unsigned char *buf, int len)
{
  bu32 value, *reg;

  value = bfin_extract_unsigned_integer (buf, 4);
  reg = bfin_get_reg (cpu, rn);

  if (reg)
    /* XXX: Need register trace ?  */
    *reg = value;
  else if (rn == SIM_BFIN_ASTAT_REGNUM)
    SET_ASTAT (value);
  else if (rn == SIM_BFIN_CC_REGNUM)
    SET_CCREG (value);
  else
    return 0; // will be an error in gdb

  return -1; // disables size checking in gdb
}

static sim_cia
bfin_pc_get (SIM_CPU *cpu)
{
  return PCREG;
}

static void
bfin_pc_set (SIM_CPU *cpu, sim_cia newpc)
{
  SET_PCREG (newpc);
}


static void
bfin_init_cpu (SIM_CPU *cpu)
{
  CPU_REG_FETCH (cpu) = bfin_reg_fetch;
  CPU_REG_STORE (cpu) = bfin_reg_store;
  CPU_PC_FETCH (cpu) = bfin_pc_get;
  CPU_PC_STORE (cpu) = bfin_pc_set;
}

static void
bfin_prepare_run (SIM_CPU *cpu)
{
}

static const MODEL bfin_models[] =
{
#define P(n) { "bf"#n, & bfin_mach, MODEL_BF##n, NULL, bfin_model_init },
#include "_proc_list.h"
#undef P
  { 0, NULL, 0, NULL, NULL, }
};

static const MACH_IMP_PROPERTIES bfin_imp_properties =
{
  sizeof (SIM_CPU),
  0,
};

static const MACH bfin_mach =
{
  "bfin", "bfin", MACH_BFIN,
  32, 32, & bfin_models[0], & bfin_imp_properties,
  bfin_init_cpu,
  bfin_prepare_run
};
