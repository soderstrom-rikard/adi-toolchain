/*
 * Blackfin helpers
 *
 * Copyright 2007-2011 Mike Frysinger
 * Copyright 2007-2011 Analog Devices, Inc.
 *
 * Licensed under the Lesser GPL 2 or later.
 */

#include "cpu.h"
#include "dyngen-exec.h"
#include "helper.h"

void helper_raise_exception(uint32_t excp, uint32_t pc)
{
    env->exception_index = excp;
    if (pc != -1)
        env->pc = pc;
    cpu_loop_exit(env);
}

void helper_memalign(uint32_t excp, uint32_t pc, uint32_t addr, uint32_t len)
{
    if ((addr & (len - 1)) == 0)
        return;

    helper_raise_exception(excp, pc);
}

void helper_dbga_l(uint32_t pc, uint32_t actual, uint32_t expected)
{
    if ((actual & 0xffff) != expected)
        helper_raise_exception(EXCP_DBGA, pc);
}

void helper_dbga_h(uint32_t pc, uint32_t actual, uint32_t expected)
{
    if ((actual >> 16) != expected)
        helper_raise_exception(EXCP_DBGA, pc);
}

void helper_outc(uint32_t ch)
{
    putc(ch, stdout);
    if (ch == '\n')
        fflush(stdout);
}

void helper_dbg(uint32_t val, uint32_t grp, uint32_t reg)
{
    printf("DBG : %s = 0x%08x\n", get_allreg_name(grp, reg), val);
}

void helper_dbg_areg(uint64_t val, uint32_t areg)
{
    printf("DBG : A%u = 0x%010"PRIx64"\n", areg, (val << 24) >> 24);
}

uint32_t helper_astat_load(void)
{
    return bfin_astat_read(env);
}

void helper_astat_store(uint32_t astat)
{
    bfin_astat_write(env, astat);
}

/* Count the number of bits set to 1 in the 32bit value */
uint32_t helper_ones(uint32_t val)
{
    uint32_t i;
    uint32_t ret;

    ret = 0;
    for (i = 0; i < 32; ++i)
        ret += !!(val & (1 << i));

    return ret;
}

/* Count number of leading bits that match the sign bit */
uint32_t helper_signbits(uint32_t val, uint32_t size)
{
    uint32_t mask = 1 << (size - 1);
    uint32_t bit = val & mask;
    uint32_t count = 0;

    for (;;) {
        mask >>= 1;
        bit >>= 1;
        if (mask == 0)
            break;
        if ((val & mask) != bit)
            break;
        ++count;
    }

    return count;
}

/* Count number of leading bits that match the sign bit */
uint32_t helper_signbits_64(uint64_t val, uint32_t size)
{
    uint64_t mask = (uint64_t)1 << (size - 1);
    uint64_t bit = val & mask;
    uint32_t count = 0;

    for (;;) {
        mask >>= 1;
        bit >>= 1;
        if (mask == 0)
            break;
        if ((val & mask) != bit)
            break;
        ++count;
    }

    if (size == 40)
        count -= 8;

    return count;
}

/* This is a bit crazy, but we want to simulate the hardware behavior exactly
   rather than worry about the circular buffers being used correctly.  Which
   isn't to say there isn't room for improvement here, just that we want to
   be conservative.  See also dagsub().  */
uint32_t helper_dagadd(uint32_t I, uint32_t L, uint32_t B, uint32_t M)
{
    uint64_t i = I;
    uint64_t l = L;
    uint64_t b = B;
    uint64_t m = M;

    uint64_t LB, IM, IML;
    uint32_t im32, iml32, lb32, res;
    uint64_t msb, car;

    msb = (uint64_t)1 << 31;
    car = (uint64_t)1 << 32;

    IM = i + m;
    im32 = IM;
    LB = l + b;
    lb32 = LB;

    if ((int32_t)M < 0) {
        IML = i + m + l;
        iml32 = IML;
        if ((i & msb) || (IM & car))
            res = (im32 < b) ? iml32 : im32;
        else
            res = (im32 < b) ? im32 : iml32;
    } else {
        IML = i + m - l;
        iml32 = IML;
        if ((IM & car) == (LB & car))
            res = (im32 < lb32) ? im32 : iml32;
        else
            res = (im32 < lb32) ? iml32 : im32;
    }

    return res;
}

/* See dagadd() notes above.  */
uint32_t helper_dagsub(uint32_t I, uint32_t L, uint32_t B, uint32_t M)
{
    uint64_t i = I;
    uint64_t l = L;
    uint64_t b = B;
    uint64_t m = M;

    uint64_t mbar = (uint32_t)(~m + 1);
    uint64_t LB, IM, IML;
    uint32_t b32, im32, iml32, lb32, res;
    uint64_t msb, car;

    msb = (uint64_t)1 << 31;
    car = (uint64_t)1 << 32;

    IM = i + mbar;
    im32 = IM;
    LB = l + b;
    lb32 = LB;

    if ((int32_t)M < 0) {
        IML = i + mbar - l;
        iml32 = IML;
        if (!!((i & msb) && (IM & car)) == !!(LB & car))
            res = (im32 < lb32) ? im32 : iml32;
        else
            res = (im32 < lb32) ? iml32 : im32;
    } else {
        IML = i + mbar + l;
        iml32 = IML;
        b32 = b;
        if (M == 0 || IM & car)
            res = (im32 < b32) ? iml32 : im32;
        else
            res = (im32 < b32) ? im32 : iml32;
    }

    return res;
}

uint32_t helper_add_brev(uint32_t addend1, uint32_t addend2)
{
    uint32_t mask, b, r;
    int i, cy;

    mask = 0x80000000;
    r = 0;
    cy = 0;

    for (i = 31; i >= 0; --i) {
        b = ((addend1 & mask) >> i) + ((addend2 & mask) >> i);
        b += cy;
        cy = b >> 1;
        b &= 1;
        r |= b << i;
        mask >>= 1;
    }

    return r;
}
