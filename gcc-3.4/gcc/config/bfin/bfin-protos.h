/* Prototypes for v850.c functions used in the md file & elsewhere.
   Copyright (C) 2004 Free Software Foundation, Inc.

   This file is part of GNU CC.

   GNU CC is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   GNU CC is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with GNU CC; see the file COPYING.  If not, write to
   the Free Software Foundation, 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

/* Function prototypes that cannot exist in bfin.h due to dependency
   complications.  */
#ifndef GCC_BFIN_PROTOS_H
#define GCC_BFIN_PROTOS_H

#define Mmode enum machine_mode

extern rtx function_arg (CUMULATIVE_ARGS *, Mmode, tree, int);
extern void function_arg_advance (CUMULATIVE_ARGS *, Mmode, tree, int);
extern int  function_arg_regno_p (int);

extern const char *output_load_immediate (rtx *);
extern const char *output_casesi_internal (rtx *);
extern char *bfin_asm_long (void);
extern char *bfin_asm_short (void);
extern int log2constp (unsigned HOST_WIDE_INT);
extern int highbits_operand (rtx, Mmode);

extern rtx legitimize_address (rtx, rtx, Mmode);
extern int hard_regno_mode_ok (int, Mmode);
extern int bfin_address_cost  (rtx);
extern int function_arg_partial_nregs (CUMULATIVE_ARGS *, Mmode, tree, int);
extern void init_cumulative_args (CUMULATIVE_ARGS *, tree, rtx);	  
extern int bfin_frame_pointer_required (void);
extern HOST_WIDE_INT bfin_initial_elimination_offset (int, int);

extern int effective_address_32bit_p (rtx, Mmode);
extern int symbolic_reference_mentioned_p (rtx);
extern rtx bfin_gen_compare (rtx, Mmode);
extern void expand_move (rtx *, Mmode);

extern int symbolic_operand (rtx, Mmode);
extern int symbolic_or_const_operand (rtx , enum machine_mode);
extern int imm16bit_operand_p (rtx, Mmode);
extern int reg_or_7bit_operand (rtx op, Mmode);
extern int scale_by_operand (rtx, Mmode);
extern int valid_reg_operand (rtx, Mmode);
extern int pos_scale_operand (rtx, Mmode);
extern int regorlog2_operand (rtx, Mmode);
extern int cc_operand (rtx, Mmode);
extern int fp_plus_const_operand (rtx, Mmode);
extern int rhs_andsi3_operand (rtx, Mmode);
extern int signed_comparison_operator (rtx, Mmode);
extern int bfin_cbranch_operator (rtx, Mmode);

extern void conditional_register_usage (void);
extern int register_move_cost (enum reg_class, enum reg_class);
extern enum reg_class secondary_input_reload_class (enum reg_class, Mmode,
						    rtx);
extern enum reg_class secondary_output_reload_class (enum reg_class, Mmode,
						     rtx);
extern char *section_asm_op_1 (SECT_ENUM_T);
extern char *section_asm_op (SECT_ENUM_T);
extern void output_file_start (void);
extern void override_options (void);
extern void print_operand (FILE *,  rtx, char);
extern void print_address_operand (FILE *, rtx);
extern void split_di (rtx [], int, rtx [], rtx []);
extern int split_load_immediate (rtx []);
extern rtx legitimize_pic_address (rtx, rtx);
extern void emit_pic_move (rtx *, Mmode);
extern void override_options (void);
extern void asm_conditional_branch (rtx, rtx *, int, int);
extern rtx bfin_gen_compare (rtx, Mmode);

extern int bfin_return_in_memory (tree);
extern void bfin_internal_label (FILE *, const char *, unsigned long);
extern bool bfin_rtx_costs (rtx, int, int, int*);
extern void initialize_trampoline (rtx, rtx, rtx);
extern int  bfin_valid_add (Mmode, HOST_WIDE_INT);
extern rtx bfin_va_arg (tree, tree);
extern void setup_incoming_varargs (CUMULATIVE_ARGS *, enum machine_mode, tree,
				    int *, int);

extern void bfin_expand_prologue (void);
extern void bfin_expand_epilogue (void);
extern int push_multiple_operation (rtx, Mmode);
extern int pop_multiple_operation (rtx, Mmode);
extern int bfin_hard_regno_rename_ok (unsigned int, unsigned int);

#undef  Mmode 

#endif /* ! GCC_V850_PROTOS_H */

