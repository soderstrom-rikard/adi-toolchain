/* A pass to optimize addressing modes.

   WORK IN PROGRESS

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2, or (at your option) any later
version.

GCC is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License
along with GCC; see the file COPYING.  If not, write to the Free
Software Foundation, 59 Temple Place - Suite 330, Boston, MA
02111-1307, USA.  */

#include "config.h"
#include "system.h"
#include "coretypes.h"
#include "tm.h"
#include "rtl.h" /* stdio.h must precede rtl.h for FFS.  */
#include "tm_p.h"
#include "insn-config.h"
#include "recog.h"
#include "output.h"
#include "regs.h"
#include "hard-reg-set.h"
#include "flags.h"
#include "function.h"
#include "expr.h"
#include "basic-block.h"
#include "except.h"
#include "toplev.h"
#include "reload.h"
#include "obstack.h"

/* A local obstack we use to allocate our data structures.  */
static struct obstack addr_obstack;

/* Points to the beginning of the addr_obstack.  */
static char *startobj;

struct use
{
  struct use *next;
  rtx insn;
  rtx *loc;
  HOST_WIDE_INT offset;
  rtx reg;
};

struct setter
{
  struct setter *next;
  rtx insn;
};

struct chain
{
  struct chain *next;
  rtx begins_after;
  rtx basereg;
  rtx init_insn;
  HOST_WIDE_INT offset;
  struct use *first_use, **plast_use;
  struct setter *first_setter;
  int cost;
};

struct reg_state
{
  struct chain *chain;
  HOST_WIDE_INT offset;
  rtx reg;
};

struct reg_state *state;
struct chain *first_chain;

static struct chain *
get_reg_chain (rtx reg, rtx init_insn)
{
  unsigned regno = REGNO (reg);
  if (state[regno].chain == NULL)
    {
      struct chain *c = obstack_alloc (&addr_obstack, sizeof (struct chain));
      c->first_use = NULL;
      c->plast_use = &c->first_use;
      c->first_setter = NULL;
      c->basereg = reg;
      c->init_insn = init_insn;
      c->cost = 0;

      c->next = first_chain;
      first_chain = c;
      state[regno].chain = c;
      state[regno].offset = 0;
      state[regno].reg = reg;
    }
  return state[regno].chain;
}

static int
handle_move_insn (rtx insn)
{
  rtx pat = PATTERN (insn);
  rtx src, dest;
  int cost;
  struct chain *c;
  struct setter *s;

  if (GET_CODE (pat) != SET)
    return 0;

  src = SET_SRC (pat);
  dest = SET_DEST (pat);
  if (! REG_P (src) || ! REG_P (dest)
      || HARD_REGISTER_P (src)
      || HARD_REGISTER_P (dest)
      || GET_MODE (dest) != Pmode)
    return 0;

  c = get_reg_chain (src, insn);
  cost = rtx_cost (pat, SET);
  c->cost += cost;
  state[REGNO (dest)].chain = c;
  state[REGNO (dest)].reg = dest;
  state[REGNO (dest)].offset = state[REGNO (src)].offset;

  s = obstack_alloc (&addr_obstack, sizeof (struct setter));
  s->next = c->first_setter;
  c->first_setter = s;
  s->insn = insn;
  return 1;
}

static int
handle_add_insn (rtx insn)
{
  rtx pat = PATTERN (insn);
  rtx src, dest, src0, src1;
  int cost;
  struct chain *c;
  struct setter *s;

  if (GET_CODE (pat) != SET)
    return 0;

  src = SET_SRC (pat);
  dest = SET_DEST (pat);
  if (! REG_P (dest) || HARD_REGISTER_P (dest)
      || GET_CODE (src) != PLUS
      || GET_MODE (dest) != Pmode)
    return 0;

  src0 = XEXP (src, 0);
  src1 = XEXP (src, 1);
  if (! REG_P (src0) || HARD_REGISTER_P (src0)
      || GET_CODE (src1) != CONST_INT)
    return 0;
  
  c = get_reg_chain (src0, insn);
  cost = rtx_cost (pat, SET);
  c->cost += cost;
  state[REGNO (dest)].chain = c;
  state[REGNO (dest)].reg = dest;
  state[REGNO (dest)].offset = state[REGNO (src0)].offset;
  state[REGNO (dest)].offset += INTVAL (src1);

  s = obstack_alloc (&addr_obstack, sizeof (struct setter));
  s->next = c->first_setter;
  c->first_setter = s;
  s->insn = insn;
  return 1;
}

static regset_head regs_to_terminate;
static regset_head regs_to_use;

static void scan_rtx (rtx, rtx *, int, int);

static void
mark_mem (rtx insn, rtx *loc)
{
  rtx x = *loc;
  rtx op0, op1;

  switch (GET_CODE (x))
    {
    case REG:
      break;
    case POST_INC:
    case POST_DEC:
    case PRE_INC:
    case PRE_DEC:
      x = XEXP (x, 0);
      if (! REG_P (x))
	scan_rtx (insn, &XEXP (x, 0), 0, 1);
      break;

    case PRE_MODIFY:
    case POST_MODIFY:
    case PLUS:
      op0 = XEXP (x, 0);
      op1 = XEXP (x, 1);
      if (! REG_P (op0) || GET_CODE (op1) != CONST_INT)
	{
	  scan_rtx (insn, &XEXP (op0, 0), 0, 1);
	  scan_rtx (insn, &XEXP (op0, 1), 0, 1);
	}
      break;
    default:
      scan_rtx (insn, loc, 0, 1);
      break;
    }
}

static void
new_use (struct chain *c, rtx insn, rtx *loc, rtx reg, HOST_WIDE_INT offset)
{
  struct use *u = obstack_alloc (&addr_obstack, sizeof (struct use));
  u->next = NULL;
  *c->plast_use = u;
  c->plast_use = &u->next;

  u->offset = offset;
  u->loc = loc;
  u->insn = insn;
  u->reg = reg;
}

static void
scan_mem (rtx insn, enum machine_mode mode, rtx *loc)
{
  rtx x = *loc;
  rtx op0, op1;
  unsigned regno;
  struct chain *c;
  HOST_WIDE_INT postinc = 0, preinc = 0;

  if (GET_MODE (x) != Pmode)
    {
      scan_rtx (insn, loc, 0, 0);
      return;
    }

  switch (GET_CODE (x))
    {
    case REG:
      regno = REGNO (x);
      if (REGNO_REG_SET_P (&regs_to_terminate, regno))
	return;
      c = get_reg_chain (x, PREV_INSN (insn));
      new_use (c, insn, loc, NULL_RTX, state[regno].offset);
      break;

    case POST_INC:
      postinc = GET_MODE_SIZE (mode);
      goto mod_common;
    case POST_DEC:
      postinc = -GET_MODE_SIZE (mode);
      goto mod_common;
    case PRE_INC:
      preinc = GET_MODE_SIZE (mode);
      goto mod_common;
    case PRE_DEC:
      preinc = -GET_MODE_SIZE (mode);
      goto mod_common;

    case PRE_MODIFY:
      op1 = XEXP (x, 1);
      if (GET_CODE (op1) != CONST_INT)
	{
	  scan_rtx (insn, loc, 0, 0);
	  break;
	}
      preinc = INTVAL (op1);
      goto mod_common;

    case POST_MODIFY:
      op1 = XEXP (x, 1);
      if (GET_CODE (op1) != CONST_INT)
	{
	  scan_rtx (insn, loc, 0, 0);
	  break;
	}
      postinc = INTVAL (op1);
      goto mod_common;

    mod_common:
      op0 = XEXP (x, 0);
      if (! REG_P (op0))
	scan_rtx (insn, loc, 0, 0);
      else
	{
	  regno = REGNO (op0);
	  if (REGNO_REG_SET_P (&regs_to_terminate, regno))
	    return;
	  c = get_reg_chain (op0, PREV_INSN (insn));
	  state[regno].offset += preinc;
	  new_use (c, insn, loc, NULL_RTX, state[regno].offset);
	  state[regno].offset += postinc;
	  c->cost += address_cost (x, mode);
	}
      break;

    case PLUS:
      op0 = XEXP (x, 0);
      op1 = XEXP (x, 1);
      if (! REG_P (op0) || GET_CODE (op1) != CONST_INT)
	{
	  scan_rtx (insn, loc, 0, 0);
	}
      else
	{
	  regno = REGNO (op0);
	  if (REGNO_REG_SET_P (&regs_to_terminate, regno))
	    return;
	  c = get_reg_chain (op0, PREV_INSN (insn));
	  c->cost += address_cost (x, mode);
	  new_use (c, insn, loc, NULL_RTX, state[regno].offset + INTVAL (op1));
	}
      break;
    default:
      break;
    }
}

static void
add_unhandled_use (rtx insn, rtx reg)
{
  unsigned regno = REGNO (reg);
  struct chain *c = state[regno].chain;
  if (REGNO_REG_SET_P (&regs_to_use, regno))
    return;
  SET_REGNO_REG_SET (&regs_to_use, regno);
  if (c)
    new_use (c, insn, NULL, reg, state[regno].offset);
}

static void
scan_rtx (rtx insn, rtx *loc, int is_output, int just_mark)
{
  const char *fmt;
  rtx x = *loc;
  enum rtx_code code = GET_CODE (x);
  enum machine_mode mode = GET_MODE (x);
  int i, j;

  code = GET_CODE (x);
  fmt = GET_RTX_FORMAT (code);
  switch (code)
    {
    case SUBREG:
      if (GET_CODE (SUBREG_REG (x)) != REG)
	break;
      x = SUBREG_REG (x);

    case REG:
      if (! HARD_REGISTER_P (x))
	{
	  if (just_mark)
	    {
	      if (is_output)
		SET_REGNO_REG_SET (&regs_to_terminate, REGNO (x));
	      else
		add_unhandled_use (insn, x);
	    }
	}
      return;

    case MEM:
      if (just_mark)
	mark_mem (insn, &XEXP (x, 0));
      else
	scan_mem (insn, mode, &XEXP (x, 0));
      return;

    case SET:
      scan_rtx (insn, &SET_SRC (x), 0, just_mark);
      scan_rtx (insn, &SET_DEST (x), 1, just_mark);
      return;

    case STRICT_LOW_PART:
      scan_rtx (insn, &XEXP (x, 0), is_output, just_mark);
      return;

    case ZERO_EXTRACT:
    case SIGN_EXTRACT: 
      scan_rtx (insn, &XEXP (x, 0), is_output, just_mark);
      scan_rtx (insn, &XEXP (x, 1), 0, just_mark);
      scan_rtx (insn, &XEXP (x, 2), 0, just_mark);
      return;

    case PRE_MODIFY:
    case POST_MODIFY:
      scan_rtx (insn, &XEXP (x, 1), 0, just_mark);
      /* fall through */

    case POST_INC:
    case PRE_INC:
    case POST_DEC:
    case PRE_DEC:
      scan_rtx (insn, &XEXP (x, 0), 1, just_mark);
      return;

    case CLOBBER:
      scan_rtx (insn, &SET_DEST (x), 2, just_mark);
      return;

    default:
      break;
    }

  for (i = GET_RTX_LENGTH (code) - 1; i >= 0; i--)
    {
      if (fmt[i] == 'e')
	scan_rtx (insn, &XEXP (x, i), is_output, just_mark);
      else if (fmt[i] == 'E')
	for (j = XVECLEN (x, i) - 1; j >= 0; j--)
	  scan_rtx (insn, &XVECEXP (x, i, j), is_output, just_mark);
    }
}

static void
handle_complex_insn (rtx insn)
{
  int i;

  CLEAR_REG_SET (&regs_to_terminate);
  CLEAR_REG_SET (&regs_to_use);

  scan_rtx (insn, &PATTERN (insn), 0, 1);
  EXECUTE_IF_SET_IN_REG_SET
    (&regs_to_terminate, FIRST_PSEUDO_REGISTER, i,
     {
       state[i].chain = NULL;
     });

  scan_rtx (insn, &PATTERN (insn), 0, 0);
}

static rtx
scan_block (basic_block bb, int nregs)
{
  int i;
  rtx insn, last = NULL_RTX;

  for (i = 0; i < nregs; i++)
    state[i].chain = NULL;
  first_chain = 0;

  for (insn = BB_HEAD (bb); ; insn = NEXT_INSN (insn))
    {
      rtx note;

      if (JUMP_P (insn))
	break;

      if (INSN_P (insn))
	{
	  if (! handle_move_insn (insn)
	      && ! handle_add_insn (insn))
	    handle_complex_insn (insn);

	  for (note = REG_NOTES (insn); note; note = XEXP (note, 1))
	    {
	      if (REG_NOTE_KIND (note) == REG_DEAD)
		{
		  rtx x = XEXP (note, 0);
		  if (REG_P (x) && ! HARD_REGISTER_P (x))
		    state[REGNO (x)].chain = NULL;
		}
	    }
	}
      last = insn;
      if (insn == BB_END (bb))
	break;
    }

  for (i = FIRST_PSEUDO_REGISTER; i < nregs; i++)
    {
      struct chain *c = state[i].chain;
      if (c)
	new_use (c, NULL_RTX, NULL, state[i].reg, state[i].offset);
    }
  return last;
}

static void
optimize_block (basic_block bb, rtx last_insn)
{
  struct chain *c;

  for (c = first_chain; c; c = c->next)
    {
      HOST_WIDE_INT prev_offset = 0;
      int cost = 0;
      struct use *u;
      rtx new_base = gen_reg_rtx (Pmode);
      rtx insn;
      start_sequence ();
      emit_move_insn (new_base, c->basereg);
      insn = get_insns ();
      end_sequence ();

      if (c->init_insn)
	{
	  emit_insn_after (insn, c->init_insn);
	}
      else
	{
	  /* BB_HEAD is supposed to be a NOTE or a CODE_LABEL.  */
	  emit_insn_after (insn, BB_HEAD (bb));
	}

      for (u = c->first_use; u; u = u->next)
	{
	  HOST_WIDE_INT this_offset = u->offset;
	  HOST_WIDE_INT next_offset = u->next ? u->next->offset : this_offset;

	  if (u->loc)
	    {
	      rtx newreg = gen_reg_rtx (Pmode);
	      rtx insn = gen_add3_insn (newreg, new_base,
					GEN_INT (this_offset));
	      emit_insn_before (insn, u->insn);
	      *u->loc = newreg;
	    }
	  else
	    {
	      rtx insn = gen_add3_insn (u->reg, new_base,
					GEN_INT (this_offset));
	      if (u->insn)
		emit_insn_before (insn, u->insn);
	      else
		emit_insn_after (insn, last_insn);
	    }
	}
    }
}

void
optimize_addressing_modes (void)
{
  int nregs = max_reg_num ();
  basic_block bb;

  no_new_pseudos = 0;

  INIT_REG_SET (&regs_to_terminate);
  gcc_obstack_init (&addr_obstack);
  startobj = obstack_alloc (&addr_obstack, 0);

  state = xmalloc (nregs * sizeof (struct reg_state));

  clear_bb_flags ();

  FOR_EACH_BB (bb)
    {
      rtx last_insn = scan_block (bb, nregs);
      optimize_block (bb, last_insn);
      obstack_free (&addr_obstack, startobj);
    }

  max_regno = max_reg_num ();
  allocate_reg_info (max_regno, FALSE, FALSE);
  update_life_info_in_dirty_blocks (UPDATE_LIFE_GLOBAL_RM_NOTES,
				    (PROP_DEATH_NOTES | PROP_KILL_DEAD_CODE
				     | PROP_SCAN_DEAD_CODE));
  no_new_pseudos = 1;
}
