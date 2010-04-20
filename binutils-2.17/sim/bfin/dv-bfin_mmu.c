/* Blackfin Memory Management Unit (MMU) model.

   Copyright (C) 2010 Free Software Foundation, Inc.
   Contributed by Analog Devices, Inc.

   This file is part of simulators.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

#include "sim-main.h"
#include "devices.h"
#include "dv-bfin_mmu.h"
#include "dv-bfin_cec.h"

/* XXX: This is a stub implementation for the most part.  */
/* XXX: Should this really be two blocks of registers ?  */

struct bfin_mmu
{
  bu32 base;

  /* Order after here is important -- matches hardware MMR layout.  */
  bu32 sram_base_address;

  bu32 dmem_control, dcplb_fault_status, dcplb_fault_addr;
  char _dpad0[0x100 - 0x0 - (4 * 4)];
  bu32 dcplb_addr[16];
  char _dpad1[0x200 - 0x100 - (4 * 16)];
  bu32 dcplb_data[16];
  char _dpad2[0x300 - 0x200 - (4 * 16)];
  bu32 dtest_command;
  char _dpad3[0x400 - 0x300 - (4 * 1)];
  bu32 dtest_data[2];

  char _dpad4[0x1000 - 0x400 - (4 * 2)];

  bu32 idk;	/* Filler MMR; hardware simply ignores.  */
  bu32 imem_control, icplb_fault_status, icplb_fault_addr;
  char _ipad0[0x100 - 0x0 - (4 * 4)];
  bu32 icplb_addr[16];
  char _ipad1[0x200 - 0x100 - (4 * 16)];
  bu32 icplb_data[16];
  char _ipad2[0x300 - 0x200 - (4 * 16)];
  bu32 itest_command;
  char _ipad3[0x400 - 0x300 - (4 * 1)];
  bu32 itest_data[2];
};
#define mmr_base()      offsetof(struct bfin_mmu, sram_base_address)
#define mmr_offset(mmr) (offsetof(struct bfin_mmu, mmr) - mmr_base())
#define mmr_idx(mmr)    (mmr_offset (mmr) / 4)

static const char * const mmr_names[] = {
  "SRAM_BASE_ADDRESS", "DMEM_CONTROL", "DCPLB_FAULT_STATUS", "DCPLB_FAULT_ADDR",
  [mmr_idx (dcplb_addr[0])] = "DCPLB_ADDR0",
  "DCPLB_ADDR1", "DCPLB_ADDR2", "DCPLB_ADDR3", "DCPLB_ADDR4", "DCPLB_ADDR5",
  "DCPLB_ADDR6", "DCPLB_ADDR7", "DCPLB_ADDR8", "DCPLB_ADDR9", "DCPLB_ADDR10",
  "DCPLB_ADDR11", "DCPLB_ADDR12", "DCPLB_ADDR13", "DCPLB_ADDR14", "DCPLB_ADDR15",
  [mmr_idx (dcplb_data[0])] = "DCPLB_DATA0",
  "DCPLB_DATA1", "DCPLB_DATA2", "DCPLB_DATA3", "DCPLB_DATA4", "DCPLB_DATA5",
  "DCPLB_DATA6", "DCPLB_DATA7", "DCPLB_DATA8", "DCPLB_DATA9", "DCPLB_DATA10",
  "DCPLB_DATA11", "DCPLB_DATA12", "DCPLB_DATA13", "DCPLB_DATA14", "DCPLB_DATA15",
  [mmr_idx (dtest_command)] = "DTEST_COMMAND",
  [mmr_idx (dtest_data[0])] = "DTEST_DATA0", "DTEST_DATA1",
  [mmr_idx (imem_control)] = "IMEM_CONTROL", "ICPLB_FAULT_STATUS", "ICPLB_FAULT_ADDR",
  [mmr_idx (icplb_addr[0])] = "ICPLB_ADDR0",
  "ICPLB_ADDR1", "ICPLB_ADDR2", "ICPLB_ADDR3", "ICPLB_ADDR4", "ICPLB_ADDR5",
  "ICPLB_ADDR6", "ICPLB_ADDR7", "ICPLB_ADDR8", "ICPLB_ADDR9", "ICPLB_ADDR10",
  "ICPLB_ADDR11", "ICPLB_ADDR12", "ICPLB_ADDR13", "ICPLB_ADDR14", "ICPLB_ADDR15",
  [mmr_idx (icplb_data[0])] = "ICPLB_DATA0",
  "ICPLB_DATA1", "ICPLB_DATA2", "ICPLB_DATA3", "ICPLB_DATA4", "ICPLB_DATA5",
  "ICPLB_DATA6", "ICPLB_DATA7", "ICPLB_DATA8", "ICPLB_DATA9", "ICPLB_DATA10",
  "ICPLB_DATA11", "ICPLB_DATA12", "ICPLB_DATA13", "ICPLB_DATA14", "ICPLB_DATA15",
  [mmr_idx (itest_command)] = "ITEST_COMMAND",
  [mmr_idx (itest_data[0])] = "ITEST_DATA0", "ITEST_DATA1",
};
#define mmr_name(off) (mmr_names[(off) / 4] ? : "<INV>")

static unsigned
bfin_mmu_io_write_buffer (struct hw *me, const void *source,
			  int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_mmu *mmu = hw_data (me);
  bu32 mmr_off;
  bu32 value;
  bu32 *valuep;

  value = dv_load_4 (source);

  mmr_off = addr - mmu->base;
  valuep = (void *)((unsigned long)mmu + mmr_base() + mmr_off);

  HW_TRACE_WRITE ();

  switch (mmr_off)
    {
    case mmr_offset(dmem_control):
    case mmr_offset(imem_control):
      /* XXX: IMC/DMC bit should add/remove L1 cache regions ...  */
    case mmr_offset(dtest_command):
    case mmr_offset(dtest_data[0]) ... mmr_offset(dtest_data[2]):
      /* XXX: should do something here.  */
    case mmr_offset(itest_command):
    case mmr_offset(itest_data[0]) ... mmr_offset(itest_data[2]):
      /* XXX: should do something here.  */
    case mmr_offset(dcplb_addr[0]) ... mmr_offset(dcplb_addr[15]):
    case mmr_offset(dcplb_data[0]) ... mmr_offset(dcplb_data[15]):
    case mmr_offset(icplb_addr[0]) ... mmr_offset(icplb_addr[15]):
    case mmr_offset(icplb_data[0]) ... mmr_offset(icplb_data[15]):
      *valuep = value;
      break;
    case mmr_offset(sram_base_address):
    case mmr_offset(dcplb_fault_status):
    case mmr_offset(dcplb_fault_addr):
    case mmr_offset(idk):
    case mmr_offset(icplb_fault_status):
    case mmr_offset(icplb_fault_addr):
      /* Discard writes to these.  */
      break;
    default:
      dv_bfin_mmr_invalid (me, addr, nr_bytes);
      break;
    }

  return nr_bytes;
}

static unsigned
bfin_mmu_io_read_buffer (struct hw *me, void *dest,
			 int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_mmu *mmu = hw_data (me);
  bu32 mmr_off;
  bu32 *valuep;

  mmr_off = addr - mmu->base;
  valuep = (void *)((unsigned long)mmu + mmr_base() + mmr_off);

  HW_TRACE_READ ();

  switch (mmr_off)
    {
    case mmr_offset(dmem_control):
    case mmr_offset(imem_control):
    case mmr_offset(dtest_command):
    case mmr_offset(dtest_data[0]) ... mmr_offset(dtest_data[2]):
      /* XXX: should do something here.  */
    case mmr_offset(itest_command):
    case mmr_offset(itest_data[0]) ... mmr_offset(itest_data[2]):
      /* XXX: should do something here.  */
    case mmr_offset(dcplb_addr[0]) ... mmr_offset(dcplb_addr[15]):
    case mmr_offset(dcplb_data[0]) ... mmr_offset(dcplb_data[15]):
    case mmr_offset(icplb_addr[0]) ... mmr_offset(icplb_addr[15]):
    case mmr_offset(icplb_data[0]) ... mmr_offset(icplb_data[15]):
    case mmr_offset(sram_base_address):
    case mmr_offset(dcplb_fault_status):
    case mmr_offset(dcplb_fault_addr):
    case mmr_offset(idk):
    case mmr_offset(icplb_fault_status):
    case mmr_offset(icplb_fault_addr):
      dv_store_4 (dest, *valuep);
      break;
    default:
      dv_bfin_mmr_invalid (me, addr, nr_bytes);
      break;
    }

  return nr_bytes;
}

static void
attach_bfin_mmu_regs (struct hw *me, struct bfin_mmu *mmu)
{
  address_word attach_address;
  int attach_space;
  unsigned attach_size;
  reg_property_spec reg;

  if (hw_find_property (me, "reg") == NULL)
    hw_abort (me, "Missing \"reg\" property");

  if (!hw_find_reg_array_property (me, "reg", 0, &reg))
    hw_abort (me, "\"reg\" property must contain three addr/size entries");

  hw_unit_address_to_attach_address (hw_parent (me),
				     &reg.address,
				     &attach_space, &attach_address, me);
  hw_unit_size_to_attach_size (hw_parent (me), &reg.size, &attach_size, me);

  if (attach_size != BFIN_COREMMR_MMU_SIZE)
    hw_abort (me, "\"reg\" size must be %#x", BFIN_COREMMR_MMU_SIZE);

  hw_attach_address (hw_parent (me),
		     0, attach_space, attach_address, attach_size, me);

  mmu->base = attach_address;
}

static void
bfin_mmu_finish (struct hw *me)
{
  struct bfin_mmu *mmu;

  mmu = HW_ZALLOC (me, struct bfin_mmu);

  set_hw_data (me, mmu);
  set_hw_io_read_buffer (me, bfin_mmu_io_read_buffer);
  set_hw_io_write_buffer (me, bfin_mmu_io_write_buffer);

  attach_bfin_mmu_regs (me, mmu);

  /* Initialize the MMU.  */
  mmu->sram_base_address = 0xff800000 - 0;
			   /*(4 * 1024 * 1024 * CPU_INDEX (hw_system_cpu (me)));*/
  mmu->dmem_control = 0x00000001;
  mmu->imem_control = 0x00000001;
}

const struct hw_descriptor dv_bfin_mmu_descriptor[] = {
  {"bfin_mmu", bfin_mmu_finish,},
  {NULL, NULL},
};

#define MMU_STATE(cpu) ((struct bfin_mmu *) dv_get_state (cpu, "/core/bfin_mmu"))

void
mmu_log_ifault (SIM_CPU *cpu)
{
  struct bfin_mmu *mmu = MMU_STATE (cpu);
  mmu->icplb_fault_addr = PCREG;
  mmu->icplb_fault_status = (cec_get_ivg (cpu) >= 0) << 17;
}

static void
_mmu_process_fault (SIM_CPU *cpu, struct bfin_mmu *mmu, bu32 addr, bool write,
		    bool inst, bool unaligned, bool miss)
{
  bool supv = cec_is_supervisor_mode (cpu);
  bu32 *fault_status, *fault_addr;

  fault_status = inst ? &mmu->icplb_fault_status : &mmu->dcplb_fault_status;
  fault_addr = inst ? &mmu->icplb_fault_addr : &mmu->dcplb_fault_addr;
  /* ICPLB regs always get updated.  */
  if (!inst)
    {
      mmu->icplb_fault_addr = PCREG;
      mmu->icplb_fault_status = supv << 17;
    }

  *fault_addr = addr;
  /* XXX: should handle FAULT_DAG.  */
  *fault_status =
	(miss << 19) |
	(supv << 17) |
	(write << 16);

  /* XXX: correct precedence order ?  Multiple exceptions ?  */
  if (addr >= BFIN_SYSTEM_MMR_BASE)
    cec_exception (cpu, VEC_ILL_RES);
  else if (unaligned)
    cec_exception (cpu, inst ? VEC_MISALI_I : VEC_MISALI_D);
  else
    cec_exception (cpu, inst ? VEC_CPLB_I_M : VEC_CPLB_M);
}

void
mmu_process_fault (SIM_CPU *cpu, bu32 addr, bool write, bool inst,
		   bool unaligned, bool miss)
{
  struct bfin_mmu *mmu = MMU_STATE (cpu);
  _mmu_process_fault (cpu, mmu, addr, write, inst, unaligned, miss);
}

void
mmu_check_addr (SIM_CPU *cpu, bu32 addr, bool write, bool inst, int size)
{
  struct bfin_mmu *mmu = MMU_STATE (cpu);
  bu32 *fault_status, *fault_addr, *mem_control, *cplb_addr, *cplb_data;
  bu32 faults;
  bool supv;
  int i, hits;

  if (addr & (size - 1))
    _mmu_process_fault (cpu, mmu, addr, write, inst, true, false);

  fault_status = inst ? &mmu->icplb_fault_status : &mmu->dcplb_fault_status;
  fault_addr = inst ? &mmu->icplb_fault_addr : &mmu->dcplb_fault_addr;
  mem_control = inst ? &mmu->imem_control : &mmu->dmem_control;
  cplb_addr = inst ? &mmu->icplb_addr[0] : &mmu->dcplb_addr[0];
  cplb_data = inst ? &mmu->icplb_data[0] : &mmu->dcplb_data[0];

  /* CPLBs disabled -> nothing to do.  */
  if (!(*mem_control & ENCPLB))
    return;

  supv = cec_is_supervisor_mode (cpu);
  faults = 0;
  hits = 0;
  for (i = 0; i < 16; ++i)
    {
      const bu32 pages[4] = { 0x400, 0x1000, 0x100000, 0x400000 };
      bu32 addr_lo, addr_hi;

      /* Skip invalid entries.  */
      if (!(cplb_data[i] & CPLB_VALID))
	continue;

      /* See if this entry covers this address.  */
      addr_lo = cplb_addr[i];
      addr_hi = cplb_addr[i] + pages[(cplb_data[i] & PAGE_SIZE) >> 16];
      if (addr < addr_lo || addr >= addr_hi)
	continue;

      ++hits;
      if (write)
	{
	  if (!supv && !(cplb_data[i] & CPLB_USER_WR))
	    faults |= (1 << i);
	  if (supv && !(cplb_data[i] & CPLB_SUPV_WR))
	    faults |= (1 << i);
	}
      else
	{
	  if (!supv && !(cplb_data[i] & CPLB_USER_RD))
	    faults |= (1 << i);
	}
    }


  /* MMRs have an implicit CPLB.  */
  if (hits == 0 && addr >= BFIN_SYSTEM_MMR_BASE)
    return;

  /* XXX: Should handle implicit set of CPLBs on L1.  */

  /* No faults and one match -> good to go.  */
  if (faults == 0 && hits == 1)
    return;

  /* ICPLB regs always get updated.  */
  if (!inst)
    {
      mmu->icplb_fault_addr = PCREG;
      mmu->icplb_fault_status = supv << 17;
    }

  *fault_status =
	(1 /*miss*/ << 19) |
	(supv << 17) |
	(write << 16) |
	faults;
  *fault_addr = addr;

  switch (hits)
    {
    case 0:
      cec_exception (cpu, inst ? VEC_CPLB_I_M : VEC_CPLB_M);
      break;
    case 1:
      cec_exception (cpu, inst ? VEC_CPLB_I_VL : VEC_CPLB_VL);
      break;
    default:
      cec_exception (cpu, inst ? VEC_CPLB_I_MHIT : VEC_CPLB_MHIT);
      break;
    }
}
