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

extern rtx function_arg PARAMS ((CUMULATIVE_ARGS *, Mmode, tree, int));

extern void function_arg_advance PARAMS ((CUMULATIVE_ARGS *, Mmode,
                                        tree, int));
extern int  function_arg_regno_p PARAMS ((int));

extern char *asm_conditional_branch PARAMS ((rtx, int));
extern const char *output_load_immediate PARAMS ((rtx *));
extern const char *output_casesi_internal PARAMS ((rtx *));
extern char *bfin_asm_long PARAMS ((void));
extern char *bfin_asm_short PARAMS ((void));
extern int log2constp PARAMS ((unsigned HOST_WIDE_INT));
extern int highbits_operand PARAMS ((rtx, Mmode));

extern rtx legitimize_address PARAMS ((rtx, rtx, Mmode));
extern int hard_regno_mode_ok PARAMS ((int, Mmode));
extern int bfin_address_cost  PARAMS ((rtx));
extern void asm_output_ascii  PARAMS ((FILE *, const char *, int));
extern int function_arg_partial_nregs PARAMS ((CUMULATIVE_ARGS *, Mmode, tree, int));	
extern void init_cumulative_args PARAMS ((CUMULATIVE_ARGS *, tree, rtx));	  
extern int frame_pointer_required PARAMS ((void));

extern int effective_address_32bit_p PARAMS ((rtx, Mmode));
extern int symbolic_operand_p PARAMS ((rtx, Mmode));
extern int imm7bit_operand_p PARAMS ((rtx, Mmode));
extern int imm16bit_operand_p PARAMS ((rtx, Mmode));
extern rtx bfin_gen_compare PARAMS ((rtx, Mmode));
extern void expand_move PARAMS ((rtx *, Mmode));
extern int extract_const_double PARAMS ((rtx));
extern void output_symbolic_address PARAMS ((rtx *));
extern int reg_or_7bit_operand PARAMS ((rtx op, Mmode));
extern int scale_by_operand PARAMS ((rtx, Mmode));
extern int valid_reg_operand PARAMS ((rtx, Mmode));
extern int pos_scale_operand PARAMS ((rtx, Mmode));
extern int regorbitclr_operand PARAMS ((rtx, Mmode));
extern int regorlog2_operand PARAMS ((rtx, Mmode));
extern int cc_operand PARAMS ((rtx, Mmode));
extern int symbolic_reference_mentioned_p PARAMS ((rtx));
	
extern void conditional_register_usage PARAMS ((void));
extern int register_move_cost PARAMS ((enum reg_class, enum reg_class));
extern enum reg_class secondary_input_reload_class PARAMS ((enum reg_class , Mmode, rtx));
extern enum reg_class secondary_output_reload_class PARAMS ((enum reg_class , Mmode, rtx));
extern char *section_asm_op_1 PARAMS ((SECT_ENUM_T));
extern char *section_asm_op PARAMS ((SECT_ENUM_T));
extern void output_file_start PARAMS ((void));
extern void override_options PARAMS ((void));
extern void asm_output_skip PARAMS ((FILE *, int));
extern void print_operand PARAMS ((FILE *,  rtx, char));
extern void print_address_operand PARAMS ((FILE *, rtx));

extern rtx legitimize_pic_address PARAMS ((rtx, rtx));
extern void emit_pic_move PARAMS ((rtx *, Mmode));
extern int register_move_cost PARAMS ((enum reg_class, enum reg_class));
extern enum reg_class secondary_input_reload_class PARAMS ((enum reg_class, Mmode, rtx));
extern enum reg_class secondary_output_reload_class PARAMS ((enum reg_class, Mmode, rtx));
extern void output_symbolic_address PARAMS ((rtx *));
extern void override_options PARAMS ((void));
extern char *asm_conditional_branch PARAMS ((rtx, int));
extern rtx bfin_gen_compare PARAMS ((rtx, Mmode));
extern int signed_comparison_operator PARAMS ((rtx, Mmode));
extern int ccregister_p PARAMS ((rtx, Mmode));
extern int loop_end PARAMS ((rtx));
extern int fp_plus_const_operand PARAMS ((rtx, Mmode));
extern int scale_operand PARAMS ((rtx, Mmode));
extern int reg_or_scale_operand PARAMS ((rtx, Mmode));
extern int log2_operand PARAMS ((rtx, Mmode));
extern int rhs_andsi3_operand PARAMS ((rtx, Mmode));
extern int positive_immediate_operand PARAMS ((rtx, Mmode));
extern int reg_or_0_operand PARAMS ((rtx, Mmode));
extern int signed_comparison_operator PARAMS ((rtx, Mmode));
extern int bfin_cbranch_operator PARAMS ((rtx, Mmode));

extern int bfin_return_in_memory PARAMS ((tree));
extern void bfin_internal_label PARAMS ((FILE *, const char *, unsigned long));
extern bool bfin_rtx_costs PARAMS ((rtx, int, int, int*));
extern void initialize_trampoline PARAMS ((rtx, rtx, rtx));
extern int  bfin_valid_add PARAMS ((Mmode, HOST_WIDE_INT));
extern rtx bfin_va_arg PARAMS ((tree, tree));
extern void setup_incoming_varargs PARAMS ((CUMULATIVE_ARGS *, enum machine_mode, tree , int *, int));
extern int  symbolic_or_const_operand_p PARAMS ((rtx , enum machine_mode));
extern int  reg_or_16bit_operand PARAMS ((rtx, enum machine_mode));
extern rtx  bfin_force_reg PARAMS ((enum machine_mode, rtx));

extern void bfin_expand_prologue PARAMS ((void));
extern void bfin_expand_epilogue PARAMS ((void));
extern int push_multiple_operation PARAMS ((rtx, Mmode));
extern int pop_multiple_operation PARAMS ((rtx, Mmode));

#undef  Mmode 

#endif /* ! GCC_V850_PROTOS_H */

