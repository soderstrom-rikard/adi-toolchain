; Copyright (c) 2000, 2001 Analog Devices Inc.,
; Copyright (c) 2000, 2001 by Lineo, Inc./Lineo Canada Corp. (www.lineo.com),
; Copyright (c) 2001 by Arcturus Networks Inc. (www.arcturusnetworks.com),
; Ported for Blackfin/Frio Architecture by Akbar Hussain  <akbar.hussain@arcturusnetworks.com>,
;                                          Tony Kou <tony.ko@arcturusnetworks.com>
;


;
; Because of the nature of the bfin architecture 
; it almost seems more natural to
; define the compiler machine modes like this:
;
;  QImode  -- 8bit  integers.
;  HImode  -- 16bit integers.
;  SImode  -- 32bit integers.
;  DImode  -- Double Integer (eight bytes)
;  SFmode  -- single-precision (four bytes) floating point
;  DFmode  -- Double-precision (eight bytes) floating point
;
; operand punctuation marks:
;
;     X -- integer value printed as log2
;     Y -- integer value printed as log2(~value) - for bitclear
;     h -- print half word register, low part
;     d -- print half word register, high part
;     D -- print operand as dregs pairs
;     w -- print operand as accumulator register word (a0w, a1w)
;     H -- high part of double mode operand 
;     T -- byte register representation Oct. 02 2001

; constant operand classes
;   
;     I  -8 .. 7      4bit imm
;     J  2**N         5bit imm scaled
;     K  1, 2         scale by 2 or 4
;     L  0..31
;     M  -64 .. 63  7bit imm
;     N  0 .. 7     3bit uimm
;     O  -4 .. 3    3bit imm
;     P  0          constant zero
;     Q  ~(2**N)    bitclear constant
;     R  -32768 .. 32767    16bit imm
;     S  0 .. 63   7bit posimm
;  
; register operands
;     d  (r0..r7)
;     a  (p0..p5,fp,sp)
;     e  (a0, a1)
;     b  (i0..i3)
;     f  (m0..m3)
;     B
;     c (i0..i3,m0..m3) CIRCREGS 
;     C (CC)            CCREGS
;
; `unspec' values used in bfin.md:
; Number       	Use
; 2		mini constant pool, 4 byte entries (consttable_4)
; 3		mini constant pool, 8 byte entries (consttable_8) For future use
; 4		end of mini constant pool (consttable_end)
; 5		align instruction on 4 byte boundary (align_4) For future use 

/* Define constants for hard registers.  */

(define_constants
  [(REG_R0 0)
   (REG_R1 1)
   (REG_R2 2)
   (REG_R3 3)
   (REG_R4 4)
   (REG_R5 5)
   (REG_R6 6)
   (REG_R7 7)

   (REG_P0 8)
   (REG_P1 9)
   (REG_P2 10)
   (REG_P3 11)
   (REG_P4 12)
   (REG_P5 13)
   (REG_P6 14)
   (REG_P7 15)

   (REG_I0 16)
   (REG_B0 17)
   (REG_L0 18)
   (REG_I1 19)
   (REG_B1 20)
   (REG_L1 21)
   (REG_I2 22)
   (REG_B2 23)
   (REG_L2 24)
   (REG_I3 25)
   (REG_B3 26)
   (REG_L3 27)

   (REG_M0 28)
   (REG_M1 29)
   (REG_M2 30)
   (REG_M3 31)

   (REG_A0 32)
   (REG_A1 33)

   (REG_CC 34)])

(define_attr "type"
  "move,mvi,mcld,mcldp,mcst,dsp32,mult,alu0,shft,brcc,br,call,misc,compare"
  (const_string "misc"))


;;; FRIO branches have been optimized for code density
;;; this comes at a slight cost of complexity when
;;; a compiler needs to generate branches in the general
;;; case.  In order to generate the correct branching 
;;; mechanisms the compiler needs keep track of instruction
;;; lengths.  The follow table describes how to count instructions
;;; for the FRIO architecture.
;;;
;;; unconditional br are 12-bit imm pcrelative branches *2
;;; conditional   br are 10-bit imm pcrelative branches *2
;;; brcc 10-bit:
;;;   1024 10-bit imm *2 is 2048 (-1024..1022)
;;; br 12-bit  :
;;;   4096 12-bit imm *2 is 8192 (-4096..4094)
;;;
;;; The way the (pc) rtx works in these calculations is somewhat odd;
;;; for backward branches it's the address of the current instruction,
;;; for forward branches it's the previously known address of the following
;;; instruction - we have to take this into account by reducing the range
;;; for a forward branch.
(define_attr "length" ""
  (cond [(eq_attr "type" "mcld")
         (if_then_else (match_operand 1 "effective_address_32bit_p" "")
                       (const_int 4) (const_int 2))

	 (eq_attr "type" "mcst")
	 (if_then_else (match_operand 0 "effective_address_32bit_p" "")
		       (const_int 4) (const_int 2))

	 (eq_attr "type" "move") (const_int 2)

	 (eq_attr "type" "mvi")
	  (if_then_else (match_operand 1 "imm7bit_operand_p" "")
	   (const_int 2)
	   (if_then_else (match_operand 1 "imm16bit_operand_p" "")
            (const_int 4)
	    (const_int 8)))

	 (eq_attr "type" "dsp32") (const_int 4)
	 (eq_attr "type" "call")  (const_int 4)

         (eq_attr "type" "br")
  	 (if_then_else (and
	                  (le (minus (match_dup 0) (pc)) (const_int 4092))
	                  (ge (minus (match_dup 0) (pc)) (const_int -4096)))
        	  (const_int 2)
                  (const_int 4))

         (eq_attr "type" "brcc")
	 (cond [(and
	            (le (minus (match_dup 1) (pc)) (const_int 1020))
	            (ge (minus (match_dup 1) (pc)) (const_int -1024)))
		  (const_int 2)
		(and
	            (le (minus (match_dup 1) (pc)) (const_int 4090))
	            (ge (minus (match_dup 1) (pc)) (const_int -4096)))
		  (const_int 4)]
	       (const_int 6))
        ]

	(const_int 2)))

(define_attr "sets_preg" "no,yes"
	(cond 
	 [(eq_attr "type" "move,mcld")
	  (symbol_ref "REG_P (SET_DEST (PATTERN (insn))) && PREG_P (SET_DEST (PATTERN (insn)))")]
	  (const_string "no")))
	  
;;; Default 2-bytes INSN: load, store, push, alu0, shft, compare, misc, mult


;; Syntax : (define_function_unit {name} {num-units} {n-users} {test}
;;                                {ready-delay} {issue-delay} [{conflict-list}])
;;(define_function_unit "dag" 1 0 (eq_attr "type" "move") 1 2)

(define_function_unit "dag" 1 1 (eq_attr "sets_preg" "yes") 4 0)

;;; WORD conversion patterns

(define_insn ""
  [(set (match_operand:SI 0 "register_operand" "=d")
    (sign_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d")0)))]
  ""
  "%0 = %h1 (X);" /* "%0 =XH %1;"*/
  [(set_attr "type" "alu0")])

(define_insn ""
  [(set (match_operand:SI 0 "register_operand" "=d")
    (zero_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d")0)))]
  ""
  "%0 = %h1 (Z);" /* "%0 = H %1;"*/
  [(set_attr "type" "alu0")])

(define_insn "extendhisi2"
  [(set (match_operand:SI 0 "register_operand" "=d, d")
	(sign_extend:SI (match_operand:HI 1 "nonimmediate_operand" "d, m")))]
  ""
  "@
   %0 = %h1 (X);
   %0 = W %h1 (X);"
  [(set_attr "type" "alu0,mcld")])

(define_insn "zero_extendhisi2"
  [(set (match_operand:SI 0 "register_operand" "=d, d")
	(zero_extend:SI (match_operand:HI 1 "nonimmediate_operand" "d, m")))]
  ""
  "@
   %0 = %h1 (Z);
   %0 = W%h1 (Z);"
  [(set_attr "type" "alu0,mcld")])


;;;
;;; #    #   ####   #    #  ######   ####
;;; ##  ##  #    #  #    #  #       #
;;; # ## #  #    #  #    #  #####    ####
;;; #    #  #    #  #    #  #            #
;;; #    #  #    #   #  #   #       #    #
;;; #    #   ####     ##    ######   ####
;;;

(define_expand "movsicc"
  [(set (match_operand:SI 0 "register_operand" "")
        (if_then_else:SI (match_operand 1 "comparison_operator" "")
                         (match_operand:SI 2 "register_operand" "")
                         (match_operand:SI 3 "register_operand" "")))]
  "TARGET_MOVSICC"
  "
{
  operands[1] = bfin_gen_compare (operands[1], SImode);
}
")

(define_insn "*movsicc_insn1"
  [(set (match_operand:SI 0 "register_operand" "=da,da,da")
        (if_then_else:SI 
	    (eq:BI (match_operand:BI 3 "cc_operand" "C,C,C") 
		(const_int 0))
	    (match_operand:SI 1 "register_operand" "da,0,da")
	    (match_operand:SI 2 "register_operand" "0,da,da")))]
  ""
  "@
    if !cc %0 =%1; /* movsicc-1a */
    if cc %0 =%2; /* movsicc-1b */
    if !cc %0 =%1; if cc %0=%2; /* movsicc-1 */"
  [(set_attr "length" "2,2,4")
   (set_attr "type" "move")])
 
(define_insn "*movsicc_insn2"
  [(set (match_operand:SI 0 "register_operand" "=da,da,da")
        (if_then_else:SI 
	    (ne:BI (match_operand:BI 3 "cc_operand" "C,C,C") 
		(const_int 0))
	    (match_operand:SI 1 "register_operand" "0,da,da")
	    (match_operand:SI 2 "register_operand" "da,0,da")))]
  ""
  "@
    if !cc %0 =%2; /* movsicc-2b */
    if cc %0 =%1; /* movsicc-2a */
    if cc %0 =%1; if !cc %0=%2; /* movsicc-1 */"
  [(set_attr "length" "2,2,4")
   (set_attr "type" "move")])

;;; Future work: split constants in expand

(define_insn "*movsi_insn"
  [(set (match_operand:SI 0 "nonimmediate_operand" "=da,da,*cf,*cf,da,mr,!*e,!*e,!d,!d,!C")
        (match_operand:SI 1 "general_operand"      "  x,ix,  x, ix,mr,da,  d, eP,*e, C,d"))]

  ""
  "*
   output_load_immediate (operands);
   return \"\";
  "
  [(set_attr "type" "move,mvi,move,mvi,mcld,mcst,move,move,move,compare,compare")])

(define_insn "*movhi_insn"
  [(set (match_operand:HI 0 "nonimmediate_operand" "=da,da,*cf,*cf,d,mr,!*e,!*e,!d,!d,!C")
        (match_operand:HI 1 "general_operand"      "  x,ix,  x, ix,mr,d,  d, eP,*e, C,d"))]
  ""
  "*
   output_load_immediate (operands);
   return \"\";
  "
  [(set_attr "type" "move,mvi,move,mvi,mcld,mcst,move,move,move,compare,compare")])

(define_insn "*movqi_insn"
  [(set (match_operand:QI 0 "nonimmediate_operand" "=da,da,*cf,*cf,d,mr,!*e,!*e,!d,!d,!C")
        (match_operand:QI 1 "general_operand"      "  x,ix,  x, ix,mr,d,  d, eP,*e, C,d"))]
  ""
  "*
   output_load_immediate (operands);
   return \"\";
  "
  [(set_attr "type" "move,mvi,move,mvi,mcld,mcst,move,move,move,compare,compare")])

(define_insn "*movsf_insn"
  [(set (match_operand:SF 0 "nonimmediate_operand" "=da,da,*cf,*cf,da,mr,!*e,!*e,!d,!d,!C")
        (match_operand:SF 1 "general_operand"      "  x,ix,  x, ix,mr,da,  d, eP,*e, C,d"))]
  ""
  "*
  {
    if (GET_CODE (operands[1]) == CONST_DOUBLE) {
	  int val = extract_const_double (operands[1]);
          short hi = (val >> 16) & 0xffff;
          short lo = val & 0xffff;
          operands[2] = GEN_INT (lo);
          operands[3] = GEN_INT (hi);
          if (hi)
            {/* output_asm_insn (\"l(%0) = %2; h(%0) = %3;\", operands);*/
            output_asm_insn (\"%h0 = %2; %d0 = %3;\", operands);
            }
          else
            {/* output_asm_insn (\"lz(%0) = %2;\", operands); */
            output_asm_insn (\"%0 = %2 (Z);\", operands);
            }
        return \"\";
     }
   output_load_immediate (operands);
   return \"\";
  }"
  [(set_attr "type" "move,mvi,move,mvi,mcld,mcst,move,move,move,compare,compare")])

(define_expand "movsi"
  [(set (match_operand:SI 0 "nonimmediate_operand" "")
	(match_operand:SI 1 "general_operand" ""))]
  ""
  "expand_move (operands, SImode);")


(define_expand "movsf"
 [(set (match_operand:SF 0 "nonimmediate_operand" "")
       (match_operand:SF 1 "general_operand" ""))]
  ""
  "expand_move (operands, SFmode);")

(define_expand "movhi"
  [(set (match_operand:HI 0 "nonimmediate_operand" "")
	(match_operand:HI 1 "general_operand" ""))]
  ""
  "expand_move (operands, HImode);")

(define_expand "movqi"
  [(set (match_operand:QI 0 "nonimmediate_operand" "")
	(match_operand:QI 1 "general_operand" ""))]
  ""
  " expand_move (operands, QImode); ")

;;;;;;;;;;;;;;;;;; BYTE conversion patterns ;;;;;;;;;;;;;;;;;;;;;;
(define_insn "extendqihi2"
  [(set (match_operand:HI 0 "register_operand" "=d, d")
	(sign_extend:HI (match_operand:QI 1 "nonimmediate_operand" "m, d")))]
  ""
  "@
   %0 = B %1 (X);
   %0 = %T1 (X);"
  [(set_attr "type" "mcld,alu0")])

(define_insn "extendqisi2"
  [(set (match_operand:SI 0 "register_operand" "=d, d")
	(sign_extend:SI (match_operand:QI 1 "nonimmediate_operand" "m, d")))]
  ""
  "@
   %0 = B %1 (X);
   %0 = %T1 (X);"
  [(set_attr "type" "mcld,alu0")])


(define_insn "zero_extendqihi2"
  [(set (match_operand:HI 0 "register_operand" "=d, d")
	(zero_extend:HI (match_operand:QI 1 "nonimmediate_operand" "m, d")))]
  ""
  "@
   %0 = B %1 (Z);
   %0 = %T1 (Z);"
  [(set_attr "type" "mcld,alu0")])


(define_insn "zero_extendqisi2"
  [(set (match_operand:SI 0 "register_operand" "=d, d")
	(zero_extend:SI (match_operand:QI 1 "nonimmediate_operand" "m, d")))]
  ""
  "@
   %0 = B %1 (Z);
   %0 = %T1 (Z);"
  [(set_attr "type" "mcld,alu0")])
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;                INSN related with DI mode              ;;;;;;;;;;;
;;;;;;;;;;      DI == two consecutive data regs (r0-7)           ;;;;;;;;;;;
;;;;;;;;;;         == %0 (low word) & %H0 (high word)           ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;<<<<<  binary operation:  >>>>>;
;;;<<<  Logical-and        >>>;;;
(define_insn "anddi3"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (and:DI (match_operand:DI 1 "register_operand" "0")
                (match_operand:DI 2 "register_operand" "d")))]
  ""
  "%0 = %1 & %2;\\n\\t%H0 = %H1 & %H2;"
[(set_attr "length" "4")]) 

(define_insn "*anddi_zesidi_di"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (and:DI (zero_extend:DI
                 (match_operand:SI 2 "register_operand" "d"))
                 (match_operand:DI 1 "register_operand" "d")))]
  ""
  "%0 = %1 & %2;\\n\\t%H0 = 0;"
[(set_attr "length" "4")])

(define_insn "*anddi_sesdi_di"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (and:DI (sign_extend:DI
                 (match_operand:SI 2 "register_operand" "d"))
                 (match_operand:DI 1 "register_operand" "0")))
   (clobber (match_scratch:SI 3 "=&d"))]
  ""
  "%0 = %1 & %2;\\n\\t%3 = %2;\\n\\t%3 >>>= 31;\\n\\t%H0 = %H1 & %3;"
[(set_attr "length" "8")])

;;;<<<  Logical-or         >>>;;;
(define_insn "iordi3"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (ior:DI (match_operand:DI 1 "register_operand" "0")
                (match_operand:DI 2 "register_operand" "d")))]
  ""
  "%0 = %1 | %2;\\n\\t%H0 = %H1 | %H2;"
[(set_attr "length" "4")]) 

(define_insn "*iordi_zesidi_di"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (ior:DI (zero_extend:DI
                 (match_operand:SI 2 "register_operand" "d"))
                 (match_operand:DI 1 "register_operand" "d")))]
  ""
  "%0 = %1 | %2;\\n\\t%H0 = %H1;"
[(set_attr "length" "4")])

(define_insn "*iordi_sesdi_di"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (ior:DI (sign_extend:DI
                 (match_operand:SI 2 "register_operand" "d"))
                 (match_operand:DI 1 "register_operand" "0")))
   (clobber (match_scratch:SI 3 "=&d"))]
  ""
  "%0 = %1 | %2;\\n\\t%3 = %2;\\n\\t%3 >>>= 31;\\n\\t%H0 = %H1 | %3;"
[(set_attr "length" "8")])

;;;<<<  Logical-xor        >>>;;;
(define_insn "xordi3"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (xor:DI (match_operand:DI 1 "register_operand" "0")
                (match_operand:DI 2 "register_operand" "d")))]
  ""
  "%0 = %1 ^ %2;\\n\\t%H0 = %H1 ^ %H2;"
[(set_attr "length" "4")])
 
(define_insn "*xordi_zesidi_di"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (xor:DI (zero_extend:DI
                 (match_operand:SI 2 "register_operand" "d"))
                 (match_operand:DI 1 "register_operand" "d")))]
  ""
  "%0 = %1 ^ %2;\\n\\t%H0 = %H1;"
[(set_attr "length" "4")])
 
(define_insn "*xordi_sesdi_di"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (xor:DI (sign_extend:DI
                 (match_operand:SI 2 "register_operand" "d"))
                 (match_operand:DI 1 "register_operand" "0")))
   (clobber (match_scratch:SI 3 "=&d"))]
  ""
  "%0 = %1 ^ %2;\\n\\t%3 = %2;\\n\\t%3 >>>= 31;\\n\\t%H0 = %H1 ^ %3;"
[(set_attr "length" "8")]) 

(define_insn "negdi2"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (neg:DI (match_operand:DI 1 "register_operand" "d")))
   (clobber (match_scratch:SI 2 "=&d"))]
  ""
  "%2 = 0; %2 = %2 - %1; cc = ac0; %2 = cc;\\n\\t%0 = -%1; %H0 = -%H1; %H0 = %H0 - %2;"
[(set_attr "length" "14")]) 

;;;<<<  Logical-one-cmpl    >>>;;;
(define_insn "one_cmpldi2"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (not:DI (match_operand:DI 1 "register_operand" "d")))]
  ""
  "%0 = ~%1;\\n\\t%H0 = ~%H1;"
[(set_attr "length" "4")]) 

;;;<<<  zero_extendsii & hi & qi ==> di2    >>>;;;
(define_insn "zero_extendsidi2"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (zero_extend:DI (match_operand:SI 1 "register_operand" "d")))]
  ""
  "*
  if (REGNO (operands[1]) != REGNO (operands[0]))
    output_asm_insn (\"%0 = %1 (Z);\", operands);
  return \"%H0 = 0;\";
"
[(set_attr "length" "2")]) 

(define_insn "zero_extendqidi2"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (zero_extend:DI (match_operand:QI 1 "register_operand" "d")))]
  ""
  "%0 = %T1 (Z);\\n\\t%H0 = 0;"
[(set_attr "length" "4")]) 

(define_insn "zero_extendhidi2"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (zero_extend:DI (match_operand:HI 1 "register_operand" "d")))]
  ""
  "%0 = %h1 (Z);\\n\\t%H0 = 0;"
[(set_attr "length" "4")])

;;;<<<  sign_extendsii & hi & qi ==> di2    >>>;;;

(define_insn "extendsidi2"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (sign_extend:DI (match_operand:SI 1 "register_operand" "d")))]
  ""
  "*
  if (REGNO (operands[1]) != REGNO (operands[0]))
    output_asm_insn (\"%0 = %1 (X);\", operands);
  return \"%H0 = %1 (X);\\n\\t%H0 >>>= 31;\";
"
[(set_attr "length" "4")])
 
(define_insn "extendqidi2"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (sign_extend:DI (match_operand:QI 1 "register_operand" "d")))]
  ""
  "%0 = %T1 (X);\\n\\t%H0 = %T1 (X);\\n\\t%H0 >>>= 31;"
[(set_attr "length" "6")])
 
(define_insn "extendhidi2"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (sign_extend:DI (match_operand:HI 1 "register_operand" "d")))]
  ""
  "%0 = %h1 (X);\\n\\t%H0 = %h1 (X);\\n\\t%H0 >>>= 31;"
[(set_attr "length" "6")]) 

;;;<<<  adddi3-mode    >>>;;;
(define_insn "adddi3"
  [(set (match_operand:DI 0 "register_operand"           "=&d,&d")
        (plus:DI (match_operand:DI 1 "register_operand"  "%0,0")
                 (match_operand:DI 2 "nonmemory_operand" "M,d")))
   (clobber (match_scratch:SI 3 "=&d,&d"))
   (clobber (reg:CC 34))]
  ""
  "@
    %0 += %2; cc = ac0; %3 = cc; %H0 = %H0 + %3;
    %0 = %0 + %2; cc = ac0; %3 = cc; %H0 = %H0 + %H2; %H0 = %H0 + %3;"
  [(set_attr "type" "alu0")
   (set_attr "length" "8,10")])


;;;<<<  subdi3-mode    >>>;;;
(define_insn "subdi3"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (minus:DI (match_operand:DI 1 "register_operand" "d")
                  (match_operand:DI 2 "register_operand" "d")))
   (clobber (reg:CC 34))]
  ""
  "%0 = %1-%2;\\n\\tcc = ac0;\\n\\t%H0 = %H1-%H2;\\n\\tif ! cc jump 1f;\\n\\t%H0 += -1;\\n\\t1:"
[(set_attr "length" "10")]) 

(define_insn "*subdi_di_zesidi"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (minus:DI (match_operand:DI 1 "register_operand" "d")
                  (zero_extend:DI
                  (match_operand:SI 2 "register_operand" "d"))))
   (clobber (reg:CC 34))]
  ""
  "%0 = %1 + %2;\\n\\tcc = ac0;\\n\\t%H0 = cc;\\n\\t%H0 = %H1 - %H0;"
[(set_attr "length" "8")])

(define_insn "*subdi_zesidi_di"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (minus:DI (zero_extend:DI
                  (match_operand:SI 2 "register_operand" "d"))
                  (match_operand:DI 1 "register_operand" "d")))
   (clobber (reg:CC 34))]
  ""
  "%0 = %2 - %1;\\n\\tcc = ac0;\\n\\t%H0 = cc;\\n\\t%H0 = -%H0;\\n\\t%H0 = %H0 - %H1"
[(set_attr "length" "10")]) 

(define_insn "*subdi_di_sesidi"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (minus:DI (match_operand:DI 1 "register_operand" "d")
                  (sign_extend:DI
                  (match_operand:SI 2 "register_operand" "d"))))
   (clobber (reg:CC 34))]
  ""
  "%0 = %1 - %2;\\n\\tcc = ac0;\\n\\t%H0 = %2;\\n\\t%H0 >>>= 31;\\n\\t%H0 = %H1 - %H0;\\n\\tif ! cc jump 1f;\\n\\t%H0 += -1;\\n\\t1:"
[(set_attr "length" "14")])

(define_insn "*subdi_sesidi_di"
  [(set (match_operand:DI 0 "register_operand" "=d")
        (minus:DI (sign_extend:DI
                  (match_operand:SI 2 "register_operand" "d"))
                  (match_operand:DI 1 "register_operand" "d")))
   (clobber (reg:CC 34))]
  ""
  "%0 = %2 - %1;\\n\\tcc = ac0;\\n\\t%H0 = %2;\\n\\t%H0 >>>= 31;\\n\\t%H0 = %H0 -%H1;\\n\\tif ! cc jump 1f;\\n\\t%H0 += -1;\\n\\t1:"
[(set_attr "length" "14")])


;;;                           #     #####    ###
;;;   ##    #       #    #   ###   #     #    #
;;;  #  #   #       #    #    #    #          #
;;; #    #  #       #    #          #####     #
;;; ######  #       #    #    #          #    #
;;; #    #  #       #    #   ###   #     #    #
;;; #    #  ######   ####     #     #####    ###
;;;

(define_insn ""
  [(set (match_operand:SI 0 "register_operand"                      "=a,d")
	(ashift:SI (plus:SI (match_operand:SI 1 "register_operand"  "%0,0")
		            (match_operand:SI 2 "register_operand"  " a,d"))
		    (match_operand:SI 3 "pos_scale_operand"         " K,K")))]
   ""
   "%0 = (%0 + %2) << %3;" /* "shadd %0,%2,%3;" */
  [(set_attr "type" "alu0")])

(define_insn ""
  [(set (match_operand:SI 0 "register_operand"           "=a")
	(plus:SI (match_operand:SI 1 "register_operand"  "a")
		 (mult:SI (match_operand:SI 2 "register_operand"  "a")
			(match_operand:SI 3 "scale_by_operand" "i"))))]
   ""
   "%0 =%1+(%2<<%X3);"
  [(set_attr "type" "alu0")])

(define_insn ""
  [(set (match_operand:SI 0 "register_operand"           "=a")
	(plus:SI (match_operand:SI 1 "register_operand"  "a")
		 (ashift:SI (match_operand:SI 2 "register_operand"  "a")
			(match_operand:SI 3 "pos_scale_operand" "i"))))]
   ""
   "%0 =%1+(%2<<%3);"
  [(set_attr "type" "alu0")])

(define_insn ""
  [(set (match_operand:SI 0 "register_operand"           "=a")
	(plus:SI (mult:SI (match_operand:SI 1 "register_operand"  "a")
			    (match_operand:SI 2 "scale_by_operand" "i"))
		 (match_operand:SI 3 "simple_reg_operand"  "a")))]
;; For now, to avoid abort in reload
   "(!(GET_CODE(operands[3])==SUBREG && GET_CODE(XEXP(operands[3],0))==MEM
   && (GET_MODE(XEXP(operands[3],0))==HImode
	|| GET_MODE(XEXP(operands[3],0))==QImode)))
   "
   "%0 =%3+(%1<<%X2);"
  [(set_attr "type" "alu0")])

(define_insn ""
  [(set (match_operand:SI 0 "register_operand"           "=a")
	(plus:SI (ashift:SI (match_operand:SI 1 "register_operand"  "a")
			    (match_operand:SI 2 "pos_scale_operand" "i"))
		 (match_operand:SI 3 "register_operand"  "a")))]
;; For now, to avoid abort in reload
   "(!(GET_CODE(operands[3])==SUBREG && GET_CODE(XEXP(operands[3],0))==MEM
   && (GET_MODE(XEXP(operands[3],0))==HImode
	|| GET_MODE(XEXP(operands[3],0))==QImode)))
   "

   "%0 =%3+(%1<<%2);"
  [(set_attr "type" "alu0")])

;;;------------------------------------------------------------
; a = ((long)x*y + 0x8000) >> 15; // fract multiply with rounding

(define_insn ""
  [(set (match_operand:SI 0 "register_operand" "=D")
        (ashiftrt:SI
           (plus:SI (mult:SI
                        (sign_extend:SI
                                (match_operand:HI 1 "register_operand" "%d"))
                        (sign_extend:SI
                                (match_operand:HI 2 "register_operand" "d")))
                   (const_int 32768))
                   (const_int 15)))
        (clobber (reg:SI 32))] ; clobber A0
  "0"
  "%0 = (A0 = %h1 + %h2);"   /* %D0 mnop, =(A0=L*L) (%1,%2);  1.15x1.15->1.31"*/
  [(set_attr "type" "dsp32")])
 
; a = (long)x*y >> 15; // fract multiply with truncation
(define_insn ""
  [(set (match_operand:SI 0 "register_operand" "=D")
	(ashiftrt:SI (mult:SI 
	                (zero_extend:SI 
			        (match_operand:HI 1 "register_operand" "%d"))
			(zero_extend:SI 
			        (match_operand:HI 2 "register_operand" "d")))
		   (const_int 15)))
			(clobber (reg:SI 32))]
;			(clobber (match_scratch:SI 3 "=e"))]
  ""
  "%0 = (A0 = %h1 + %h2);"   /* %D0 mnop, =(A0=L*L) (%1,%2);  1.15x1.15->1.31"*/
  [(set_attr "type" "dsp32")])

(define_insn "umulhisi3"
  [(set (match_operand:SI 0 "register_operand" "=D")
	(mult:SI 
	                (zero_extend:SI 
			        (match_operand:HI 1 "register_operand" "%d"))
			(zero_extend:SI 
			        (match_operand:HI 2 "register_operand" "d")))
		)(clobber (reg:SI 32))]
  "0"
  "%0 = (A0 = %h1 + %h2) IU;"   /* %D0 mnop, =(A0=L*L) (%1,%2) IU; */
  [(set_attr "type" "dsp32")])

(define_insn ""
  [(set (match_operand:SI 0 "register_operand" "=D")
	(ashiftrt:SI (mult:SI 
	                (sign_extend:SI 
			        (match_operand:HI 1 "register_operand" "%d"))
			(sign_extend:SI 
			        (match_operand:HI 2 "register_operand" "d")))
		   (const_int 15)))
			(clobber (reg:SI 32))]
  ""
  "%0 = (A0 = %h1 + %h2);"  /* %D0 mnop, =(A0=L*L) (%1,%2);  1.15x1.15->1.31"*/
  [(set_attr "type" "dsp32")])

(define_insn "mulhisi3"
      [(set (match_operand:SI 0 "register_operand" "=D")
	(mult:SI 
	                (sign_extend:SI 
			        (match_operand:HI 1 "register_operand" "%d"))
			(sign_extend:SI 
			        (match_operand:HI 2 "register_operand" "d")))
	) (clobber (reg:SI 32))]
  "0"
  "%0 = (A0 = %h1 + %h2) IS;"   /* %D0 mnop, =(A0=L*L) (%1,%2) I;" */
  [(set_attr "type" "dsp32")])

;;;
;;;------------------------------------------------------------
;;;

;; A pattern to reload the equivalent of
;;   (set (Dreg) (plus (FP) (large_constant)))
;; using a scratch register
(define_expand "reload_insi"
  [(parallel [(set (match_operand:SI 0 "register_operand" "=x")
                   (match_operand:SI 1 "fp_plus_const_operand" ""))
              (clobber (match_operand:SI 2 "register_operand"    "=&a"))])]
  ""
  "
{
  rtx fp_op = XEXP (operands[1], 0);
  rtx const_op = XEXP (operands[1], 1);
  rtx primary = operands[0];
  rtx scratch = operands[2];

  emit_move_insn (scratch, const_op);
  emit_insn (gen_addsi3 (scratch, scratch, fp_op));
  emit_move_insn (primary, scratch);
  DONE;
}")    

;; The processor also supports ireg += mreg or ireg -= mreg, but these
;; are unusable if we don't ensure that the corresponding lreg is zero.
;; The same applies to the add/subtract constant versions involving
;; iregs

(define_expand "addsi3"
  [(set (match_operand:SI 0 "register_operand"           "")
	(plus:SI (match_operand:SI 1 "simple_reg_operand" "")
		 (match_operand:SI 2 "reg_or_7bit_operand" "")))]
  ""
  "")

(define_insn ""
  [(set (match_operand:SI 0 "register_operand"           "=ad,a,d")
	(plus:SI (match_operand:SI 1 "register_operand"  "%0, a,d")
		 (match_operand:SI 2 "reg_or_7bit_operand" " M, a,d")))]
  ""
  "@
   %0 += %2;
   %0 = %1 + %2;
   %0 = %1 + %2;"
  [(set_attr "type" "alu0")
   (set_attr "length" "2,2,2")])

(define_expand "subsi3"
  [(set (match_operand:SI 0 "register_operand"            "")
	(minus:SI (match_operand:SI 1 "register_operand"  "")
		  (match_operand:SI 2 "nonmemory_operand" "")))]
  ""
  "")

(define_insn ""
  [(set (match_operand:SI 0 "register_operand"           "=da,d,a")
	(minus:SI (match_operand:SI 1 "register_operand"  "0,d,0")
		  (match_operand:SI 2 "nonmemory_operand" "M,d,a")))]
  "GET_CODE (operands[2]) != CONST_INT || INTVAL (operands[2]) != -64"
  "*
{
  static const char *const strings_subsi3[] = {
    \"%0 += -%2;\",
    \"%0 = %1 - %2;\",
    \"%0 -= %2;\",
  };

  if (CONSTANT_P (operands[2]) && INTVAL (operands[2]) < 0) {
     rtx tmp_op = operands[2];
     operands[2] = GEN_INT (-INTVAL (operands[2]));
     output_asm_insn (\"%0 += %2;\", operands);
     operands[2] = tmp_op;
     return \"\";
  }

  return strings_subsi3[which_alternative];
}"
  [(set_attr "type" "alu0")])
;;
; ZERO_EXTRACT PATTERNS 
; produced by combiner when matching the following insn's:
;
;   (set (match_operand:SI 0 "register_operand" "d")
;	(and:SI (match_operand:SI 1 "register_operand" "d")
;	    (match_operand:SI 2 "immediate_operand" "L")))
;   (set (match_operand:CC 3 "cc_operand" "=C") 
;       (eq:CC (match_dup 0)
;	       (const_int 0)))
; NOTE: if there is an insn between these two insn's, zero_extract is not
; produced. E.g., "int foo (int y) { if (y & 1<<5) return 1; return 0;}"
; 04/23/99 --lev

(define_insn ""
 [(set (match_operand:BI 0 "cc_operand" "=C")
       (eq:BI (zero_extract:SI (match_operand:SI 1 "register_operand" "d")
			       (const_int 1)
			       (match_operand:SI 2 "immediate_operand" "L"))
	      (const_int 0)))]
 ""
 "cc =!BITTST (%1,%2);"
  [(set_attr "type" "alu0")])

(define_insn ""
 [(set (match_operand:BI 0 "cc_operand" "=C")
       (eq:BI (zero_extract:SI (match_operand:SI 1 "register_operand" "d")
			       (const_int 1)
			       (match_operand:SI 2 "immediate_operand" "L"))
		(const_int 1)))]
 ""
 "cc =BITTST (%1,%2);"
  [(set_attr "type" "alu0")])


;(define_insn "andsi3"
;  [(set (match_operand:SI 0 "register_operand"          "=d")
;	(and:SI (match_operand:SI 1 "register_operand"  "%d")
;		(match_operand:SI 2 "register_operand"  "d")))]
;  ""
;  "%0 =%1&%2;"
;  [(set_attr "type" "alu0")])

;; 
(define_insn ""
  [(set (match_operand:SI 0 "register_operand"     	"=d")
	(and:SI (match_operand:SI 1 "register_operand"  " d")
		   (const_int 255)))]
  ""
  "%0 = %T1 (Z);"     /* %0 =B %1;"*/
  [(set_attr "type" "alu0")])

(define_insn ""
  [(set (match_operand:SI 0 "register_operand"     	"=d")
	(and:SI (match_operand:SI 1 "register_operand"  " d")
		   (const_int 65535)))]
  ""
  "%0 = %h1 (Z);"   /* %0 =H %1;"*/ 
  [(set_attr "type" "alu0")])


; To combine into extract_zero, disallow combining with memory operands
(define_insn ""
  [(set (match_operand:SI 0 "register_operand"          "=d,d")
	(and:SI (match_operand:SI 1 "register_operand"  "%0,d")
		(match_operand:SI 2 "regorbitclr_operand"  "Q,?d")))]
  "(!(GET_CODE (operands[1]) == MEM || (GET_CODE (operands[1]) == SUBREG
	&& GET_CODE (XEXP (operands[1], 0)) == MEM)))"
  "*
{
   if ((GET_CODE (operands[2]) == CONST_INT) 
	&& (log2constp (~(INTVAL (operands[2])))))
	output_asm_insn (\"BITCLR (%0,%Y2);\", operands);
   else 
	output_asm_insn (\"%0 =%1&%2;\", operands);

   RET;
}"
  [(set_attr "type" "alu0")])

(define_expand "andsi3"
  [(set (match_operand:SI 0 "register_operand"          "")
	(and:SI (match_operand:SI 1 "register_operand"  "")
		(match_operand:SI 2 "rhs_andsi3_operand"  "")))]
  ""
  "
{
    if (highbits_operand(operands[2], SImode)) {
	operands[2] = GEN_INT (exact_log2 (-INTVAL (operands[2])));
	emit_insn (gen_ashrsi3 (operands[0], operands[1], operands[2]));
	emit_insn (gen_ashlsi3 (operands[0], operands[0], operands[2]));
	DONE;
    }
}
  "
)

(define_insn "iorsi3"
  [(set (match_operand:SI 0 "register_operand"          "=d,d")
	(ior:SI (match_operand:SI 1 "register_operand"  "%0,d")
		(match_operand:SI 2 "regorlog2_operand" "J,d")))]
  ""
  "*
{
   if (GET_CODE (operands[2]) == CONST_INT) {
	operands[2] = GEN_INT (exact_log2 (INTVAL (operands[2])));
	output_asm_insn (\"BITSET (%0,%2);\", operands);
   }
   else output_asm_insn (\"%0 =%1|%2;\", operands);

   RET;
}"
  [(set_attr "type" "alu0")])

(define_insn "xorsi3"
  [(set (match_operand:SI 0 "register_operand"            "=d,d")
	(xor:SI (match_operand:SI 1 "register_operand"    "%0,d")
		  (match_operand:SI 2 "regorlog2_operand" "J,d")))]
  ""
  "*
{
   if (GET_CODE (operands[2]) == CONST_INT) {
	operands[2] = GEN_INT (exact_log2 (INTVAL (operands[2])));
	output_asm_insn (\"BITTGL(%0,%2);\", operands);
   }
   else output_asm_insn (\"%0 =%1^%2;\", operands);
   RET;
}"
  [(set_attr "type" "alu0")])


(define_insn "smaxsi3"
  [(set (match_operand:SI 0 "register_operand" "=d")
	(smax:SI (match_operand:SI 1 "register_operand" "d")
		 (match_operand:SI 2 "register_operand" "d")))]
  ""
  "%0 =max(%1,%2);"
  [(set_attr "type" "dsp32")])

(define_insn "sminsi3"
  [(set (match_operand:SI 0 "register_operand" "=d")
	(smin:SI (match_operand:SI 1 "register_operand" "d")
		 (match_operand:SI 2 "register_operand" "d")))]
  ""
  "%0 =min(%1,%2);"
  [(set_attr "type" "dsp32")])

(define_insn "abssi2"
  [(set (match_operand:SI 0 "register_operand"         "=d")
	(abs:SI (match_operand:SI 1 "register_operand" " d")))]
  ""
  "%0 =abs %1;"
  [(set_attr "type" "dsp32")])


(define_insn "negsi2"
  [(set (match_operand:SI 0 "register_operand"         "=d")
	(neg:SI (match_operand:SI 1 "register_operand" " d")))]
  ""
  "%0 =-%1;"
  [(set_attr "type" "alu0")])

(define_insn ""
  [(set (match_operand:BI 0 "cc_operand"         "=C")
	(not:BI (match_operand:BI 1 "cc_operand" " 0")))]
  ""
  "%0 = ! %0;"    /*  NOT CC;"  */
  [(set_attr "type" "compare")])

(define_insn "one_cmplsi2"
  [(set (match_operand:SI 0 "register_operand"         "=d")
	(not:SI (match_operand:SI 1 "register_operand" " d")))]
  ""
  "%0 =~%1;"
  [(set_attr "type" "alu0")])

(define_insn "mulsi3"
  [(set (match_operand:SI 0 "register_operand"     "=d")
        (mult:SI 
	   (match_operand:SI 1 "register_operand"  "%0")
           (match_operand:SI 2 "register_operand" "d")))]
  ""
  "%0 *=%2;"
  [(set_attr "type" "mult")])

(define_expand "ashlsi3"
  [(set (match_operand:SI 0 "register_operand"             "")
        (ashift:SI (match_operand:SI 1 "register_operand"  "")
                   (match_operand:SI 2 "nonmemory_operand" "")))]
  ""
  "
  if (GET_CODE (operands[2]) == CONST_INT
      && ((unsigned HOST_WIDE_INT) INTVAL (operands[2])) > 31) {
      emit_insn (gen_movsi (operands[0], const0_rtx));
      DONE;
    }
 ")

(define_insn ""
  [(set (match_operand:SI 0 "simple_reg_operand"             "=a")
	(ashift:SI (match_operand:SI 1 "simple_reg_operand"  "a")
		   (match_operand:SI 2 "pos_scale_operand"   "K")))]
  ""
  "*
  if (INTVAL (operands[2]) == 1) return \"%0 =%1+%1;\";
  else                           return \"%0 =%1<<%2;\";
  "
  [(set_attr "type" "shft")])

(define_insn ""
  [(set (match_operand:SI 0 "register_operand"                "=d")
	(ashift:SI (match_operand:SI 1 "register_operand"     " 0")
		   (match_operand:SI 2 "nonmemory_operand" "dL")))]
  ""
  "%0 <<=%2;"
  [(set_attr "type" "shft")])


(define_insn "ashrsi3"
  [(set (match_operand:SI 0 "register_operand" "=d")
	(ashiftrt:SI (match_operand:SI 1 "register_operand" "0")
		     (match_operand:SI 2 "nonmemory_operand" "dL")))]
  ""
  "%0 >>>=%2;"
  [(set_attr "type" "shft")])

(define_expand "lshrsi3"
  [(set (match_operand:SI 0 "register_operand"               "=d,a")
	(lshiftrt:SI (match_operand:SI 1 "register_operand" "0,a")
		     (match_operand:SI 2 "nonmemory_operand" "dL,K")))]
  ""
  ""
) 

(define_insn ""
  [(set (match_operand:SI 0 "simple_reg_operand"               "=a")
	(lshiftrt:SI (match_operand:SI 1 "simple_reg_operand"  "a")
		     (match_operand:SI 2 "pos_scale_operand" "K")))]
  ""
  "%0 =%1>>%2;"
  [(set_attr "type" "shft")])

(define_insn ""
  [(set (match_operand:SI 0 "register_operand"                   "=d")
	(lshiftrt:SI (match_operand:SI 1 "register_operand"      " 0")
		     (match_operand:SI 2 "nonmemory_operand" "dL")))]
  ""
  "%0 >>=%2;"
  [(set_attr "type" "shft")])
	


;;;
;;;  ####   ######   ####
;;; #       #       #    #
;;;  ####   #####   #    #
;;;      #  #       #  # #
;;; #    #  #       #   #
;;;  ####   ######   ### #
;;;

;;;;;;;;;;;;;;; Addtion: casesi insn    -- Tonyko   ;;;;;;;;;;;;;;;;;;;;;
(define_expand "casesi"
  [(match_operand:SI 0 "register_operand" "")   ; index to jump on
   (match_operand:SI 1 "immediate_operand" "")  ; lower bound
   (match_operand:SI 2 "immediate_operand" "")  ; total range
   (match_operand:SI 3 "" "")                   ; table label
   (match_operand:SI 4 "" "")]                  ; Out of range label
  ""
  "
{
  rtx reg;
  if (operands[1] != const0_rtx)
    {
      rtx tmp_const = GEN_INT (-INTVAL (operands[1]));
      if (! imm7bit_operand_p (tmp_const, SImode))
	tmp_const = force_reg (SImode, tmp_const);
      reg = gen_reg_rtx (SImode);
      emit_insn (gen_addsi3 (reg, operands[0], tmp_const));
      operands[0] = reg;
    }                                               

  operands[2] = bfin_force_reg (SImode, operands[2]);
  emit_jump_insn (gen_casesi_internal (operands[0], operands[2], operands[3],
                                       operands[4]));
  DONE;
}") 

;; The USE in this pattern is needed to tell flow analysis that this is
;; a CASESI insn.  It has no other purpose. 

(define_insn "casesi_internal"
  [(parallel [(set (pc)
               (if_then_else
                (leu (match_operand:SI 0 "register_operand" "a")
                     (match_operand:SI 1 "register_operand" "a"))
                (mem:SI (plus:SI (mult:SI (match_dup 0) (const_int 4))
                                 (label_ref (match_operand 2 "" ""))))
                (label_ref (match_operand 3 "" ""))))
              (use (label_ref (match_dup 2)))
	      (clobber (match_scratch:SI 4 "=&a"))])]
  ""
  "*output_casesi_internal(operands);
    return \"\";
  "
  [(set_attr "length" "24")])

(define_insn "jump"
  [(set (pc)
	(label_ref (match_operand 0 "" "")))]
  ""
  "*
   {
	if (get_attr_length (insn) == 2)
	   return \"jump.s %0;\";
	else
	   return \"jump.l %0;\";
   }"
  [(set_attr "type" "br")])


(define_insn "indirect_jump"
  [(set (pc) 
	(match_operand:SI 0 "register_operand" "a"))]
  ""
  "jump (%0);"
  [(set_attr "type" "misc")])

(define_expand "tablejump"
  [(parallel [(use (match_operand 0 "register_operand" "a"))
              (use (label_ref (match_operand 1 "" "")))])]
  ""
  "
{
if (CASE_VECTOR_MODE == HImode)
    emit_jump_insn (gen_tablejump_short (operands[0], operands[1]));
else
    emit_jump_insn (gen_tablejump_long (operands[0], operands[1]));
}
")


(define_expand "tablejump_long"
  [(parallel [(set (pc) (match_operand:SI 0 "register_operand" "a"))
              (use (label_ref (match_operand 1 "" "")))])]
  ""
  "")

(define_expand "tablejump_short"
  [(set (match_dup 2) (zero_extend:SI
              (match_operand:HI 0 "register_operand" "a")))
  (parallel [(set (pc) (match_dup 2))
              (use (label_ref (match_operand 1 "" "")))])]
  ""
  "
{ operands[2] = gen_reg_rtx (SImode); }")

(define_insn ""
  [(parallel [(set (pc) (match_operand:SI 0 "register_operand" "a"))
              (use (label_ref (match_operand 1 "" "")))])]
  "CASE_VECTOR_MODE==SImode"
  "jump (%0);"
  [(set_attr "type" "misc")])

(define_insn ""
  [(parallel [(set (pc) (match_operand:SI 0 "register_operand" "a"))
              (use (label_ref (match_operand 1 "" "")))])]
  "CASE_VECTOR_MODE==HImode"
  "jump (PC+%0);"
  [(set_attr "type" "misc")])

(define_insn ""
  [(call (mem:SI (match_operand:SI 0 "register_operand" "a"))
	 (match_operand:SI 1 "general_operand" "g"))]
  ""
  "call (%0);"
  [(set_attr "type" "misc")])
(define_insn ""
  [(set (match_operand 0 "register_operand" "=d")
	(call (mem:SI (match_operand:SI 1 "register_operand" "a"))
	      (match_operand:SI 2 "general_operand" "g")))]
  ""
  "call (%1);"
  [(set_attr "type" "misc")])

;;;;
;;;;
;;;;  Call instructions....
;;;;
(define_expand "call"
  [(call (match_operand:SI 0 "general_operand" "a,i")
	 (match_operand 1 "general_operand" "g,g"))]
  ""
  "")
;; Call subroutine, returning value in operand 0
;; (which must be a hard register).
(define_expand "call_value"
  [(set (match_operand 0 "register_operand" "=d,d")
         (call (match_operand:SI 1 "general_operand" "a,i")
	       (match_operand 2 "general_operand" "g,g")))]
  ""
  "")

(define_insn ""
  [(call (mem:SI (match_operand:SI 0 "nonmemory_or_sym_operand" "a,i"))
	 (match_operand 1 "general_operand" "g,g"))]
  "GET_CODE (operands[0]) == SYMBOL_REF || GET_CODE (operands[0]) == REG"
  "@
  call (%0);
  call %0;"
  [(set_attr "type" "misc,call")])

(define_insn ""
  [(set (match_operand 0 "register_operand" "=d,d")
         (call (mem:SI (match_operand:SI 1 "nonmemory_or_sym_operand" "a,i"))
	       (match_operand 2 "general_operand" "g,g")))]
  "GET_CODE (operands[0]) == SYMBOL_REF || GET_CODE (operands[0]) == REG"
  "@
  call (%1);
  call %1;"
  [(set_attr "type" "misc,call")])


/*****************************************************************
 * Conditional branch patterns
 * BFIN has only few condition codes: eq, lt, lte, ltu, leu
 *****************************************************************/


/* The only outcome of this pattern is that global variables
 * bfin_compare_op[01] are set for use in bcond patterns.
 */
(define_expand "cmpsi"
 [(set (cc0) (compare (match_operand:SI 0 "register_operand" "")
                      (match_operand:SI 1 "nonmemory_operand" "")))]
 ""
 "
{
  bfin_compare_op0 = operands[0];
  bfin_compare_op1 = operands[1];
  DONE;
}");


;(define_insn ""
;  [(set (match_operand:CC 0 "cc_operand" "=C,C")
;	(and (match_dup 0)
;             (eq:CC (match_operand:SI 1 "register_operand"  "d, a")
;                    (match_operand:SI 2 "nonmemory_operand" "dO,aO"))))]
;  ""
;  "cc &=%1==%2;"
;  [(set_attr "type" "compare")])

(define_insn ""
  [(set (match_operand:BI 0 "cc_operand" "=C,C")
        (eq:BI (match_operand:SI 1 "register_operand"  "d, a")
               (match_operand:SI 2 "nonmemory_operand" "dO,aO")))]
  ""
  "cc =%1==%2;"
  [(set_attr "type" "compare")])

(define_insn ""
  [(set (match_operand:BI 0 "cc_operand" "=C,C")
        (ne:BI (match_operand:SI 1 "register_operand"  "d, a")
               (match_operand:SI 2 "nonmemory_operand" "dO,aO")))]
  "0"
  "cc =%1!=%2;"
  [(set_attr "type" "compare")])


(define_insn ""
  [(set (match_operand:BI 0 "cc_operand" "=C,C")
        (lt:BI (match_operand:SI 1 "register_operand"  "d, a")
               (match_operand:SI 2 "nonmemory_operand" "dO,aO")))]
  ""
  "cc =%1<%2;"
  [(set_attr "type" "compare")])

(define_insn ""
  [(set (match_operand:BI 0 "cc_operand" "=C,C")
        (le:BI (match_operand:SI 1 "register_operand"  "d, a")
               (match_operand:SI 2 "nonmemory_operand" "dO,aO")))]
  ""
  "cc =%1<=%2;"
  [(set_attr "type" "compare")])

(define_insn ""
  [(set (match_operand:BI 0 "cc_operand" "=C,C")
        (leu:BI (match_operand:SI 1 "register_operand"  "d, a")
                (match_operand:SI 2 "nonmemory_operand" "dN,aN")))]
  ""
  "cc =%1<=%2 (iu);"
  [(set_attr "type" "compare")])

(define_insn ""
  [(set (match_operand:BI 0 "cc_operand" "=C,C")
        (ltu:BI (match_operand:SI 1 "register_operand"  "d, a")
                (match_operand:SI 2 "nonmemory_operand" "dN,aN")))]
  ""
  "cc =%1<%2 (iu);"
  [(set_attr "type" "compare")])

(define_expand "beq"
  [(set (match_dup 1) (match_dup 2))
   (set (pc)
	(if_then_else (match_dup 3)
		   (label_ref (match_operand 0 "" ""))
		   (pc)))
  ]
  "" 
  "
{
  operands[1] = bfin_cc_rtx;	/* hard register: CC */
  operands[2] = gen_rtx (EQ, BImode,
			 bfin_compare_op0, bfin_compare_op1);
  operands[3] = gen_rtx (NE, BImode,
			 operands[1], const0_rtx);
}")

(define_expand "bne"
  [(set (match_dup 1) (match_dup 2))
   (set (pc)
	(if_then_else (match_dup 3)
		      (label_ref (match_operand 0 "" ""))
		    (pc)))
  ]
  "" 
  "
{
  operands[1] = bfin_cc_rtx;
  operands[2] = gen_rtx (EQ, BImode,
			 bfin_compare_op0, bfin_compare_op1);
  operands[3] = gen_rtx (EQ, BImode,
			 operands[1], const0_rtx);
}")

(define_expand "bgt"
  [(set (match_dup 1) (match_dup 2))
   (set (pc)
	(if_then_else (match_dup 3) 
		      (label_ref (match_operand 0 "" ""))
		    (pc)))
  ]
  "" 
  "
{
  operands[1] = bfin_cc_rtx;
  operands[2] = gen_rtx (LE, BImode,
			 bfin_compare_op0, bfin_compare_op1);
  operands[3] = gen_rtx (EQ, BImode,
			 operands[1], const0_rtx);
}")

(define_expand "bgtu"
  [(set (match_dup 1) (match_dup 2))
   (set (pc)
	(if_then_else (match_dup 3)
		      (label_ref (match_operand 0 "" ""))
		    (pc)))
  ]
  "" 
  "
{
  operands[1] = bfin_cc_rtx;
  operands[2] = gen_rtx (LEU, BImode,
			 bfin_compare_op0, bfin_compare_op1);
  operands[3] = gen_rtx (EQ, BImode,
			 operands[1], const0_rtx);
}")

(define_expand "blt"
  [(set (match_dup 1) (match_dup 2))
   (set (pc)
	(if_then_else (match_dup 3)
		      (label_ref (match_operand 0 "" ""))
		    (pc)))
  ]
  "" 
  "
{
  operands[1] = bfin_cc_rtx;
  operands[2] = gen_rtx (LT, BImode,
			 bfin_compare_op0, bfin_compare_op1);
  operands[3] = gen_rtx (NE, BImode,
			 operands[1], const0_rtx);
}")

(define_expand "bltu"
  [(set (match_dup 1) (match_dup 2))
   (set (pc)
	(if_then_else (match_dup 3)
		      (label_ref (match_operand 0 "" ""))
		    (pc)))
  ]
  "" 
  "
{
  operands[1] = bfin_cc_rtx;
  operands[2] = gen_rtx (LTU, BImode,
			 bfin_compare_op0, bfin_compare_op1);
  operands[3] = gen_rtx (NE, BImode,
			 operands[1], const0_rtx);
}")


(define_expand "bge"
  [(set (match_dup 1) (match_dup 2))
   (set (pc)
	(if_then_else (match_dup 3)
		      (label_ref (match_operand 0 "" ""))
		    (pc)))
  ]
  ""
  "
{
  operands[1] = bfin_cc_rtx;
  operands[2] = gen_rtx (LT, BImode,
			 bfin_compare_op0, bfin_compare_op1);
  operands[3] = gen_rtx (EQ, BImode,
			 operands[1], const0_rtx);
}")

(define_expand "bgeu"
  [(set (match_dup 1) (match_dup 2))
   (set (pc)
	(if_then_else (match_dup 3)
		      (label_ref (match_operand 0 "" ""))
		    (pc)))
  ]
  ""
  "
{
  operands[1] = bfin_cc_rtx;
  operands[2] = gen_rtx (LTU, BImode,
			 bfin_compare_op0, bfin_compare_op1);
  operands[3] = gen_rtx (EQ, BImode,
			 operands[1], const0_rtx);
}")

(define_expand "ble"
  [(set (match_dup 1) (match_dup 2))
   (set (pc)
	(if_then_else (match_dup 3)
		      (label_ref (match_operand 0 "" ""))
		    (pc)))
  ]
  ""
  "
{
  operands[1] = bfin_cc_rtx;
  operands[2] = gen_rtx (LE, BImode,
			 bfin_compare_op0, bfin_compare_op1);
  operands[3] = gen_rtx (NE, BImode,
			 operands[1], const0_rtx);
}")


(define_expand "bleu"
  [(set (match_dup 1) (match_dup 2))
   (set (pc)
	(if_then_else (match_dup 3)
		      (label_ref (match_operand 0 "" ""))
		    (pc)))
  ]
  ""
  "
{
  operands[1] = bfin_cc_rtx;
  operands[2] = gen_rtx (LEU, BImode,
			 bfin_compare_op0, bfin_compare_op1);
  operands[3] = gen_rtx (NE, BImode,
			 operands[1], const0_rtx);
}")


(define_insn ""
  [(set (pc)
	(if_then_else (eq:BI (match_operand:BI 0 "cc_operand" "C") (const_int 0))
		(label_ref (match_operand 1 "" ""))
		(pc)))]
  ""
  "* return asm_conditional_branch (insn, BRF);"
  [(set_attr "type" "brcc")
  ])

(define_insn ""
  [(set (pc)
	(if_then_else (ne:BI (match_operand:BI 0 "cc_operand" "C") (const_int 0))
		      (label_ref (match_operand 1 "" ""))
		      (pc)))]
  ""
  "* return asm_conditional_branch (insn, BRT);"

  [(set_attr "type" "brcc")
  ])


(define_insn ""
  [(set (pc)
	(if_then_else (eq:BI (match_operand:BI 0 "cc_operand" "C") (const_int 0))
		      (pc)
		      (label_ref (match_operand 1 "" ""))))]
  ""
  "* return asm_conditional_branch (insn, BRF);"
  [(set_attr "type" "brcc")
  ])

(define_insn ""
  [(set (pc)
	(if_then_else (ne:BI (match_operand:BI 0 "cc_operand" "C") (const_int 0))
		      (pc)
		      (label_ref (match_operand 1 "" ""))))]
  ""
  "* return asm_conditional_branch (insn, BRT);"
  [(set_attr "type" "brcc")
  ])

(define_expand "seq"
  [(set (match_dup 1) (eq:BI (match_dup 2) (match_dup 3)))
   (set (match_operand:SI 0 "register_operand" "")
	(subreg:SI (match_dup 1) 0))]
  ""
  "
{
   operands[2] = bfin_compare_op0;
   operands[3] = bfin_compare_op1;
   operands[1] = bfin_cc_rtx;
}")

(define_expand "slt"
  [(set (match_dup 1) (lt:BI (match_dup 2) (match_dup 3)))
   (set (match_operand:SI 0 "register_operand" "")
	(subreg:SI (match_dup 1) 0))]
  ""
  "
{
   operands[2] = bfin_compare_op0;
   operands[3] = bfin_compare_op1;
   operands[1] = bfin_cc_rtx;
}")

(define_expand "sle"
  [(set (match_dup 1) (le:BI (match_dup 2) (match_dup 3)))
   (set (match_operand:SI 0 "register_operand" "")
	(subreg:SI (match_dup 1) 0))]
  ""
  "
{
   operands[2] = bfin_compare_op0;
   operands[3] = bfin_compare_op1;
   operands[1] = bfin_cc_rtx;
}")

(define_expand "sltu"
  [(set (match_dup 1) (ltu:BI (match_dup 2) (match_dup 3)))
   (set (match_operand:SI 0 "register_operand" "") 
	(subreg:SI (match_dup 1) 0))]
  ""
  "
{
   operands[2] = bfin_compare_op0;
   operands[3] = bfin_compare_op1;
   operands[1] = bfin_cc_rtx;
}")

(define_expand "sleu"
  [(set (match_dup 1) (leu:BI (match_dup 2) (match_dup 3)))
   (set (match_operand:SI 0 "register_operand" "") 
	(subreg:SI (match_dup 1) 0))]
  ""
  "
{
   operands[2] = bfin_compare_op0;
   operands[3] = bfin_compare_op1;
   operands[1] = bfin_cc_rtx;
}")

(define_insn "nop"
  [(const_int 0)]
  ""
  "nop;")

;;;;;;;;;;;;;;;;;;;;   CC2dreg   ;;;;;;;;;;;;;;;;;;;;;;;;;
(define_insn ""
        [(set (match_operand:BI 0 "cc_operand"         "=C")
              (if_then_else
                 (eq:BI (match_operand:SI 1 "register_operand" "d") (const_int 0))
                 (const_int 0) (const_int 1)))]
        ""
        "CC = %1;"
  [(set_attr "length" "2")])
 
(define_insn ""
        [(set (match_operand:SI 0 "register_operand" "=d")
              (if_then_else:SI
                  (eq:BI (match_operand:BI 1 "cc_operand" "C")
                      (const_int 0))
              (const_int 0)
              (const_int 1)))]
        ""
        "%0 = CC;"
  [(set_attr "length" "2")]) 

;;;;;;;;;;;;;;;   COMPI2opD & COMPI2opP   ;;;;;;;;;;;;;;;;
 
(define_insn ""
        [(set (match_operand:SI 0 "register_operand" "=d, a")
              (sign_extend:SI (match_operand 1 "immediate_operand" "M ,M")))]
        ""
        "%0 = %1 (X);"
  [(set_attr "length" "2")])
 
;(define_insn ""
;        [(set (match_operand:SI 0 "register_operand" "=d, a")
;              (plus:SI (match_dup 0)
;                       (sign_extend:SI (match_operand 1 "immediate_operand" "M ,M"))))]
;        ""
;        "%0 += %1;"
;  [(set_attr "length" "2")])  

;; Since the combiner will not produce zero_extract if operand3 is not dead,
;; we generate bittst instruction here.
;;(define_peephole
;;  [(set (match_operand 0 "register_operand" "=d")
;;        (match_operand 1 "log2_operand" "J"))
;;   (set (match_operand 2 "register_operand" "=d")
;;     (and:SI (match_operand 3 "register_operand" "d")
;;         (match_dup 0)))
;;   (set (match_operand 4 "cc_operand" "C")
;;       (eq:CC (match_dup 2) (const_int 0)))]
;;  "dead_or_set_p (prev_nonnote_insn (insn), operands[0])"
;;   "cc =!BITTST (%3,%X1);\/* peep-1 *\/"
;;)

;;(define_peephole
;;  [(set (match_operand 0 "register_operand" "=d")
;;        (match_operand 1 "log2_operand" ""))
;;  (set (match_operand 2 "register_operand" "=d")
;;        (match_operand 3 "general_operand" ""))
;;   (set (match_dup 0)
;;     (and:SI (match_dup 2)
;;         (match_dup 0)))
;;   (set (match_operand 5 "cc_operand" "C")
;;       (eq:CC (match_dup 0) (const_int 0)))]
;;  ""
;;   "cc =!BITTST (%0,%X1);\/* peep-1 *\/"
;;)


(define_peephole
  [(set (match_operand 0 "register_operand" "=d")
        (match_operand 1 "register_operand" "a"))
   (set (match_dup 0)
	    (ashift:SI (match_dup 0)
		    (const_int 4)))
   (set (match_dup 1) (match_dup 0))
   (set (match_operand 2 "register_operand" "a")
	    (plus:SI (match_dup 2)
		    (match_dup 1)))]
  "dead_or_set_p (prev_nonnote_insn (insn), operands[0])"
  "%1 =%1<<2; %2 =%2+(%1<<2); /* peep-3 */"
  [(set_attr "type" "shft")
   (set_attr "length" "4")]
)

(define_peephole
  [(set (match_operand 0 "register_operand" "")
        (match_operand 1 "register_operand" ""))
   (set (match_dup 0)
	    (ashift:SI (match_dup 0)
		    (const_int 4)))
   (set (match_dup 1) (match_dup 0))]
  "dead_or_set_p (insn, operands[0])"
  "%1 =%1<<2; %1 =%1<<2; /* peep-2 */"
  [(set_attr "type" "shft")
   (set_attr "length" "4")]
)

(define_peephole
  [(set (match_operand 0 "register_operand" "")
        (match_operand 1 "register_operand" ""))
   (set (match_dup 0)
	    (ashift:SI (match_dup 0)
		    (const_int 3)))
   (set (match_dup 1) (match_dup 0))]
  "dead_or_set_p (insn, operands[0])"
  "%1 =%1<<2; %1 =%1+%1; /* peep-2a */"
  [(set_attr "type" "shft")
   (set_attr "length" "4")]
)

;; it is left out because of combiner-reload limitation for addsi3
;(define_peephole
;  [(set (match_operand:SI 0 "register_operand" "")
;        (match_operand:SI 1 "register_operand" ""))
;   (set (match_dup 1) (plus:SI (match_dup 1)
;			(match_operand 2 "reg_or_7bit_operand" "")))
;   (set (match_dup 0) (sign_extend:SI
;			(match_operand:HI 3 "register_operand" "")))
;
;  ]
;  "REGNO (operands[1]) == REGNO (operands[3])"
;  "%1 +=%2;\\n\\t%0 =XH %3; \/* peep-4 *\/"
;)

(define_peephole
  [(set (match_operand:SI 0 "register_operand" "d")
        (subreg:SI (match_operand:HI 1 "register_operand" "d")0))
   (set (match_operand:SI 4 "register_operand" "d") (plus:SI (match_dup 4)
			(match_operand 2 "reg_or_7bit_operand" "Md")))
   (set (match_dup 0) (sign_extend:SI
			(match_operand:HI 3 "register_operand" "d")))

  ]
  "(REGNO (operands[1]) == REGNO (operands[3])
   && REGNO (operands[1]) == REGNO (operands[4]))"
  "%1 +=%2;\\n\\t%0 = %3 (X); /* peep-4a */"
)

;; Special patterns for dealing with the constant pool

(define_insn "consttable_4"
[(unspec_volatile [(match_operand 0 "" "")] 2)]
"TARGET_MINI_CONST_POOL"
"*
{
enum machine_mode mode;
REAL_VALUE_TYPE r;
unsigned int align;

mode = GET_MODE (operands[0]);

/* Align the location counter as required by EXP's data type.  */
align = GET_MODE_ALIGNMENT (mode == VOIDmode ? word_mode : mode);

switch (GET_MODE_CLASS (mode))
{
case MODE_FLOAT:
{
memcpy ((char *) &CONST_DOUBLE_LOW (operands[0]), (char *) &r, sizeof r);
assemble_real (r, mode, align);
break;
}
default:
assemble_integer (operands[0], 4, align, 1);
break;
}
return \"\";
}"
[(set_attr "length" "4")])


(define_insn "consttable_8"
[(unspec_volatile [(match_operand 0 "" "")] 3)]
"TARGET_MINI_CONST_POOL"
"*
{
enum machine_mode mode;
REAL_VALUE_TYPE r;
unsigned int align;

mode = GET_MODE (operands[0]);

  /* Align the location counter as required by EXP's data type.  */
  align = GET_MODE_ALIGNMENT (mode == VOIDmode ? word_mode : mode);

switch (GET_MODE_CLASS (mode))
{
case MODE_FLOAT:
{
memcpy ((char *) &CONST_DOUBLE_LOW (operands[0]), (char *) &r, sizeof r);
assemble_real (r, mode, align);
break;
}
default:
assemble_integer (operands[0], 8, align, 1);
break;
}
return \"\";
}"
[(set_attr "length" "8")])

(define_insn "consttable_end"
[(unspec_volatile [(const_int 0)] 4)]
"TARGET_MINI_CONST_POOL"
"*
/* Nothing to do (currently).  */
return \"\";
")

(define_insn "align_4"
[(unspec_volatile [(const_int 0)] 5)]
"TARGET_MINI_CONST_POOL"
"*
assemble_align (32);
return \"\";
")



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Feb 19,2001 trial version with addition of DSP partial......Tony Kou;;
;; Oct 03 2001 New Syntax                                 Akbar Hussain;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;               dsp32alu                     ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;      dregs=+(dregs, dregs) amod1           ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;      amod1: S or [none]                    ;;;;;;;;;;;;;;;;
;(define_insn ""
;       [(set (match_operand:SI 0 "register_operand" "=d")
;             (plus:SI (match_operand:SI 1 "register_operand" "d")
;                      (match_operand:SI 2 "register_operand" "d")))]
;       ""
;       "%0 =+(%1,%2);"
;       [(set_attr "type" "dsp32")])

;(define_insn ""
;       [(set (match_operand:SI 0 "register_operand" "=d")
;             (and:SI (plus:SI (match_operand:SI 1 "register_operand" "d")
;                              (match_operand:SI 2 "register_operand" "d"))
;                     (const_int 4294967296)))]
;       ""
;       "%0 =+(%1,%2) S;"
;       [(set_attr "type" "dsp32")])

;;;;;;;;;;;;;      dregs=-(dregs, dregs) amod1           ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;      amod1: S or [none]                    ;;;;;;;;;;;;;;;;
;(define_insn ""
;       [(set (match_operand:SI 0 "register_operand" "=d")
;             (minus:SI (match_operand:SI 1 "register_operand" "d")
;                       (match_operand:SI 2 "register_operand" "d")))]
;       ""
;       "%0 =-(%1,%2);"
;       [(set_attr "type" "dsp32")])
 
;(define_insn ""
;       [(set (match_operand:SI 0 "register_operand" "=d")
;             (and:SI (minus:SI (match_operand:SI 1 "register_operand" "d")
;                              (match_operand:SI 2 "register_operand" "d"))
;                     (const_int 4294967296))]
;       ""
;       "%0 =-(%1,%2) S;"
;       [(set_attr "type" "dsp32")]) 


;;;;;;;;;;;;;;      dregs = +/+ (dregs, dregs) amod0     ;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;      amod0: S  X  SX                      ;;;;;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                          (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))
	            (set (subreg:HI (match_dup 0) 1)
	                 (plus:HI (subreg:HI (match_dup 1) 1)
	                          (subreg:HI (match_dup 2) 1)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 +|+ %2;"   /* "%0 = +/+ (%1, %2);" */
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	                 (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                          (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))
	            (set (subreg:HI (match_dup 0) 0)
	                 (plus:HI (subreg:HI (match_dup 1) 1)
	                          (subreg:HI (match_dup 2) 1)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 +|+ %2 (CO);"  /* "%0 = +/+ (%1, %2) X;" */
	[(set_attr "type" "dsp32")])	
	
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (and:HI (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                                  (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	                         (const_int 65535)))
	            (set (subreg:HI (match_dup 0) 1)
	                 (and:HI (plus:HI (subreg:HI (match_dup 1) 1)
	                                  (subreg:HI (match_dup 2) 1))
	                         (const_int 65535)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 +|+ %2 (S);"   /* "%0 = +/+ (%1, %2) S;" */
	[(set_attr "type" "dsp32")])	

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	                 (and:HI (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                                  (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	                         (const_int 65535)))
	            (set (subreg:HI (match_dup 0) 0)
	                 (and:HI (plus:HI (subreg:HI (match_dup 1) 1)
	                                  (subreg:HI (match_dup 2) 1))
	                         (const_int 65535)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 +|+ %2 (SCO);"   /* "%0 = +/+ (%1, %2) SX;" */
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;      dregs = -/- (dregs, dregs) amod0     ;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;      amod0: S  X  SX                      ;;;;;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                          (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))
	            (set (subreg:HI (match_dup 0) 1)
	                 (minus:HI (subreg:HI (match_dup 1) 1)
	                          (subreg:HI (match_dup 2) 1)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 -|- %2;"   /* "%0 = -/- (%1, %2);" */
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	                 (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                          (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))
	            (set (subreg:HI (match_dup 0) 0)
	                 (minus:HI (subreg:HI (match_dup 1) 1)
	                          (subreg:HI (match_dup 2) 1)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 -|- %2 (CO);"   /* "%0 = -/- (%1, %2) X;" */
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (and:HI (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                                  (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	                         (const_int 65535)))
	            (set (subreg:HI (match_dup 0) 1)
	                 (and:HI (minus:HI (subreg:HI (match_dup 1) 1)
	                                  (subreg:HI (match_dup 2) 1))
	                         (const_int 65535)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 -|- %2 (S);"  /* "%0 = -/- (%1, %2) S;" */
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	                 (and:HI (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                                  (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	                         (const_int 65535)))
	            (set (subreg:HI (match_dup 0) 0)
	                 (and:HI (minus:HI (subreg:HI (match_dup 1) 1)
	                                  (subreg:HI (match_dup 2) 1))
	                         (const_int 65535)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 -|- %2 (SCO);"   /* "%0 = -/- (%1, %2) SX;" */
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;      dregs = +/- (dregs, dregs) amod0     ;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;      amod0: S  X  SX                      ;;;;;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                          (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))
	            (set (subreg:HI (match_dup 0) 1)
	                 (plus:HI (subreg:HI (match_dup 1) 1)
	                          (subreg:HI (match_dup 2) 1)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 +|- %2;"    /* "%0 = +/- (%1, %2);" */
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	                 (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                          (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))
	            (set (subreg:HI (match_dup 0) 0)
	                 (plus:HI (subreg:HI (match_dup 1) 1)
	                          (subreg:HI (match_dup 2) 1)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 +|- %2 (CO);"   /* "%0 = +/- (%1, %2) X;" */
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (and:HI (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                                  (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	                         (const_int 65535)))
	            (set (subreg:HI (match_dup 0) 1)
	                 (and:HI (plus:HI (subreg:HI (match_dup 1) 1)
	                                  (subreg:HI (match_dup 2) 1))
	                         (const_int 65535)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 +|- %2 (S);"     /* "%0 = +/- (%1, %2) S;" */
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	                 (and:HI (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                                  (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	                         (const_int 65535)))
	            (set (subreg:HI (match_dup 0) 0)
	                 (and:HI (plus:HI (subreg:HI (match_dup 1) 1)
	                                  (subreg:HI (match_dup 2) 1))
	                         (const_int 65535)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 +|- %2 (SCO);"    /* "%0 = +/- (%1, %2) SX;" */
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;      dregs = -/+ (dregs, dregs) amon0     ;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;      amod0: S  X  SX                      ;;;;;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                          (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))
	            (set (subreg:HI (match_dup 0) 1)
	                 (minus:HI (subreg:HI (match_dup 1) 1)
	                          (subreg:HI (match_dup 2) 1)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 -|+ %2;"   /* "%0 = -/+ (%1, %2);" */
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	                 (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                          (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))
	            (set (subreg:HI (match_dup 0) 0)
	                 (minus:HI (subreg:HI (match_dup 1) 1)
	                          (subreg:HI (match_dup 2) 1)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 -|+ %2 (CO);"    /* "%0 = -/+ (%1, %2) X;" */
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (and:HI (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                                  (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	                         (const_int 65535)))
	            (set (subreg:HI (match_dup 0) 1)
	                 (and:HI (minus:HI (subreg:HI (match_dup 1) 1)
	                                  (subreg:HI (match_dup 2) 1))
	                         (const_int 65535)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 -|+ %2 (S);"   /* "%0 = -/+ (%1, %2) S;" */
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	                 (and:HI (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                                  (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	                         (const_int 65535)))
	            (set (subreg:HI (match_dup 0) 0)
	                 (and:HI (minus:HI (subreg:HI (match_dup 1) 1)
	                                  (subreg:HI (match_dup 2) 1))
	                         (const_int 65535)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %1 -|+ %2 (SCO);"   /* "%0 = -/+ (%1, %2) SX;" */
	[(set_attr "type" "dsp32")])
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;    (dregs, dregs) = +/+, -/- (dregs, dregs) amod2 amod0     ;;;;;;;
;;;;;;;;    Adding :  >> ,  >> and X, << , << and X                  ;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (plus:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                          (subreg:HI (match_operand:SI 3 "register_operand" "d") 0)))
	            (set (subreg:HI (match_dup 0) 1)
	                 (plus:HI (subreg:HI (match_dup 2) 1)
	                          (subreg:HI (match_dup 3) 1)))
	            (set (subreg:HI (match_operand:SI 1 "register_operand" "=d") 0)
	                 (minus:HI (subreg:HI (match_dup 2) 0)
	                           (subreg:HI (match_dup 3) 0)))
	            (set (subreg:HI (match_dup 1) 1)
	                 (minus:HI (subreg:HI (match_dup 2) 1)
	                           (subreg:HI (match_dup 3) 1)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %2 +|+ %3, %1 = %2 -|- %3;"  /* "(%0, %1) = +/+, -/- (%2, %3);" */
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	                 (plus:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                          (subreg:HI (match_operand:SI 3 "register_operand" "d") 0)))
	            (set (subreg:HI (match_dup 0) 0)
	                 (plus:HI (subreg:HI (match_dup 2) 1)
	                          (subreg:HI (match_dup 3) 1)))
	            (set (subreg:HI (match_operand:SI 1 "register_operand" "=d") 1)
	                 (minus:HI (subreg:HI (match_dup 2) 0)
	                           (subreg:HI (match_dup 3) 0)))
	            (set (subreg:HI (match_dup 1) 0)
	                 (minus:HI (subreg:HI (match_dup 2) 1)
	                           (subreg:HI (match_dup 3) 1)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %2 +|+ %3, %1 = %2 -|- %3 (CO);"  /* "(%0, %1) = +/+, -/- (%2, %3) X;" */
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (minus:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                           (subreg:HI (match_operand:SI 3 "register_operand" "d") 0)))
	            (set (subreg:HI (match_dup 0) 1)
	                 (plus:HI (subreg:HI (match_dup 2) 1)
	                          (subreg:HI (match_dup 3) 1)))
	            (set (subreg:HI (match_operand:SI 1 "register_operand" "=d") 0)
	                 (plus:HI (subreg:HI (match_dup 2) 0)
	                          (subreg:HI (match_dup 3) 0)))
	            (set (subreg:HI (match_dup 1) 1)
	                 (minus:HI (subreg:HI (match_dup 2) 1)
	                           (subreg:HI (match_dup 3) 1)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %2 +|- %3, %1 = %2 -|+ %3;"  /* "(%0, %1) = +/-, -/+ (%2, %3);"*/
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	                 (minus:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                           (subreg:HI (match_operand:SI 3 "register_operand" "d") 0)))
	            (set (subreg:HI (match_dup 0) 0)
	                 (plus:HI (subreg:HI (match_dup 2) 1)
	                          (subreg:HI (match_dup 3) 1)))
	            (set (subreg:HI (match_operand:SI 1 "register_operand" "=d") 1)
	                 (plus:HI (subreg:HI (match_dup 2) 0)
	                          (subreg:HI (match_dup 3) 0)))
	            (set (subreg:HI (match_dup 1) 0)
	                 (minus:HI (subreg:HI (match_dup 2) 1)
	                           (subreg:HI (match_dup 3) 1)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	""
	"%0 = %2 +|- %3, %1 = %2 -|+ %3 (CO);"  /* "(%0, %1) = +/-, -/+ (%2, %3) X;"*/
	[(set_attr "type" "dsp32")])
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     dregs_lo = L + L (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	               (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))]
	""
	"%h0 = %h1 + %h2 (NS);"  /* "%h0 = L + L (%1, %2);" */
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (and:HI (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                       (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	              (const_int 65535)))]
	""
	"%h0 = %h1 + %h2 (S);"  /* "%h0 = L + L (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;     dregs_lo = L + H (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	               (subreg:HI (match_operand:SI 2 "register_operand" "d") 1)))]
	""
	"%h0 = %h1 + %d2 (NS);" /* "%h0 = L + H (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (and:HI (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                       (subreg:HI (match_operand:SI 2 "register_operand" "d") 1))
	              (const_int 65535)))]
	""
	"%h0 = %h1 + %d2 (S);"  /* "%h0 = L + H (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])
	
;;;;;;;;;;;;;;;     dregs_lo = H + L (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	               (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))]
	""
	"%h0 = %d1 + %h2 (NS);"  /*"%h0 = H + L (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (and:HI (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                       (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	              (const_int 65535)))]
	""
	"%h0 = %d1 + %h2 (S);"  /*"%h0 = H + L (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])
	
;;;;;;;;;;;;;;;     dregs_lo = H + H (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	               (subreg:HI (match_operand:SI 2 "register_operand" "d") 1)))]
	""
	"%h0 = %d1 + %d2 (NS);" /*"%h0 = H + H (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (and:HI (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                       (subreg:HI (match_operand:SI 2 "register_operand" "d") 1))
	              (const_int 65535)))]
	""
	"%h0 = %d1 + %d2 (S);" /*"%h0 = H + H (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])
	
;;;;;;;;;;;;;;;     dregs_hi = L + L (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	               (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))]
	""
	"%d0 = %h1 + %h2 (NS);"  /*"%d0 = L + L (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (and:HI (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                       (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	              (const_int 65535)))]
	""
	"%d0 = %h1 + %h2 (S);"  /*"%d0 = L + L (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])
	

;;;;;;;;;;;;;;;     dregs_hi = L + H (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	               (subreg:HI (match_operand:SI 2 "register_operand" "d") 1)))]
	""
	"%d0 = %h1 + %d2 (NS);"  /* "%d0 = L + H (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (and:HI (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                       (subreg:HI (match_operand:SI 2 "register_operand" "d") 1))
	              (const_int 65535)))]
	""
	"%d0 = %h1 + %d2 (S);"  /* "%d0 = L + H (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])
	
;;;;;;;;;;;;;;;     dregs_hi = H + L (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	               (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))]
	""
	"%d0 = %d1 + %h2 (NS);"  /* "%d0 = H + L (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (and:HI (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                       (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	              (const_int 65535)))]
	""
	"%d0 = %d1 + %h2 (S);"  /* "%d0 = H + L (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])
	
;;;;;;;;;;;;;;;     dregs_hi = H + H (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	               (subreg:HI (match_operand:SI 2 "register_operand" "d") 1)))]
	""
	"%d0 = %d1 + %d2 (NS);"  /*"%d0 = H + H (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (and:HI (plus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                       (subreg:HI (match_operand:SI 2 "register_operand" "d") 1))
	              (const_int 65535)))]
	""
	"%d0 = %d1 + %d2 (S);"  /* "%d0 = H + H (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])
	
;;;;;;;;;;;;;;;     dregs_lo = L - L (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))]
	""
	"%h0 = %h1 - %h2 (NS);"  /*"%h0 = L - L (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (and:HI (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                        (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	              (const_int 65535)))]
	""
	"%h0 = %h1 - %h2 (S);"  /*"%h0 = L - L (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])	
	
;;;;;;;;;;;;;;;     dregs_lo = L - H (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                (subreg:HI (match_operand:SI 2 "register_operand" "d") 1)))]
	""
	"%h0 = %h1 - %d2 (NS);"  /*"%h0 = L - H (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (and:HI (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                        (subreg:HI (match_operand:SI 2 "register_operand" "d") 1))
	              (const_int 65535)))]
	""
	"%h0 = %h1 - %d2 (S);"  /*"%h0 = L - H (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])
	
;;;;;;;;;;;;;;;     dregs_lo = H - L (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))]
	""
	"%h0 = %d1 - %h2 (NS);"  /*"%h0 = H - L (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (and:HI (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                        (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	              (const_int 65535)))]
	""
	"%h0 = %d1 - %h2 (S);"  /*"%h0 = H - L (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])	
	
;;;;;;;;;;;;;;;     dregs_lo = H - H (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                (subreg:HI (match_operand:SI 2 "register_operand" "d") 1)))]
	""
	"%h0 = %d1 - %d2 (NS);"  /*"%h0 = H - H (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (and:HI (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                        (subreg:HI (match_operand:SI 2 "register_operand" "d") 1))
	              (const_int 65535)))]
	""
	"%h0 = %d1 - %d2 (S);"  /*"%h0 = H - H (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])	
	
;;;;;;;;;;;;;;;     dregs_hi = L - L (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))]
	""
	"%d0 = %h1 - %h2 (NS);"  /*"%d0 = L - L (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (and:HI (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                        (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	              (const_int 65535)))]
	""
	"%d0 = %h1 - %h2 (S);"  /*"%d0 = L - L (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])
	
;;;;;;;;;;;;;;;     dregs_hi = L - H (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                (subreg:HI (match_operand:SI 2 "register_operand" "d") 1)))]
	""
	"%d0 = %h1 - %d2 (NS);"  /*"%d0 = L - H (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (and:HI (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                        (subreg:HI (match_operand:SI 2 "register_operand" "d") 1))
	              (const_int 65535)))]
	""
	"%d0 = %h1 - %d2 (S);"  /*"%d0 = L - H (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])	
	
;;;;;;;;;;;;;;;     dregs_hi = H - L (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))]
	""
	"%d0 = %d1 - %h2 (NS);"  /*"%d0 = H - L (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (and:HI (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                        (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))
	              (const_int 65535)))]
	""
	"%d0 = %d1 - %h2 (S);"  /*"%d0 = H - L (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])	
	
;;;;;;;;;;;;;;;     dregs_hi = H - H (dregs, dregs) amod1  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     amod1: S  [none]                       ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                (subreg:HI (match_operand:SI 2 "register_operand" "d") 1)))]
	""
	"%d0 = %d1 - %d2 (NS);"  /*"%d0 = H - H (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (and:HI (minus:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                        (subreg:HI (match_operand:SI 2 "register_operand" "d") 1))
	              (const_int 65535)))]
	""
	"%d0 = %d1 - %d2 (S);"  /*"%d0 = H - H (%1, %2) S;"*/
	[(set_attr "type" "dsp32")])	
	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;    (dregs, dregs) = +/- (dregs, dregs)     ;;;;;;;;;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (match_operand:SI 0 "register_operand" "=d")
	                 (minus:SI (match_operand:SI 2 "register_operand" "d")
	                           (match_operand:SI 3 "register_operand" "d")))
	            (set (match_operand:SI 1 "register_operand" "=d")
	                 (plus:SI (match_dup 2)
	                          (match_dup 3)))
	            (clobber (reg:SI 32))
	            (clobber (reg:SI 33))])]
	"(REGNO(operands[0]) != REGNO(operands[1]))"
	"%0 = %2 + %3, %1 = %2 - %3;"   /* "(%0, %1) = +/- (%2, %3);" */
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;      dregs_lo = RND12 + (dregs, dregs)        ;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (truncate:HI (lshiftrt:SI
	                   (plus:SI (plus:SI (match_operand:SI 1 "register_operand" "d")
	                                     (match_operand:SI 2 "register_operand" "d"))
		                    (const_int 2048))
		           (const_int 12))))]
	""
	"%h0 = %1 + %2 (RND12);"  /*"%h0 = RND12 + (%1, %2);" */
	[(set_attr "type" "dsp32")])


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;      dregs_lo = RND12 - (dregs, dregs)        ;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (truncate:HI (lshiftrt:SI
	                   (plus:SI (minus:SI (match_operand:SI 1 "register_operand" "d")
	                                      (match_operand:SI 2 "register_operand" "d"))
		                    (const_int 2048))
		           (const_int 12))))]
	""
	"%h0 = %1 - %2 (RND12);"  /*"%h0 = RND12 - (%1, %2);"*/
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;      dregs_lo = RND20 + (dregs, dregs)        ;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (truncate:HI (lshiftrt:SI
	                   (plus:SI (plus:SI (match_operand:SI 1 "register_operand" "d")
	                                     (match_operand:SI 2 "register_operand" "d"))
		                    (const_int 524288))
		           (const_int 20))))]
	""
	"%h0 = %1 + %2 (RND20);"  /*"%h0 = RND20 + (%1, %2);"*/
	[(set_attr "type" "dsp32")])	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;      dregs_lo = RND20 - (dregs, dregs)        ;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (truncate:HI (lshiftrt:SI
	                   (plus:SI (minus:SI (match_operand:SI 1 "register_operand" "d")
	                                      (match_operand:SI 2 "register_operand" "d"))
		                    (const_int 524288))
		           (const_int 20))))]
	""
	"%h0 = %1 - %2 (RND20);"  /*"%h0 = RND20 - (%1, %2);"*/
	[(set_attr "type" "dsp32")])		
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;      dregs_hi = RND12 + (dregs, dregs)        ;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (truncate:HI (lshiftrt:SI
	                   (plus:SI (plus:SI (match_operand:SI 1 "register_operand" "d")
	                                     (match_operand:SI 2 "register_operand" "d"))
		                    (const_int 2048))
		           (const_int 12))))]
	""
	"%d0 = %1 + %2 (RND12);"  /*"%d0 = RND12 + (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;      dregs_hi = RND12 - (dregs, dregs)        ;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (truncate:HI (lshiftrt:SI
	                   (plus:SI (minus:SI (match_operand:SI 1 "register_operand" "d")
	                                      (match_operand:SI 2 "register_operand" "d"))
		                    (const_int 2048))
		           (const_int 12))))]
	""
	"%d0 = %1 - %2 (RND12);"  /*"%d0 = RND12 - (%1, %2);"*/
	[(set_attr "type" "dsp32")])	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;      dregs_hi = RND20 + (dregs, dregs)        ;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (truncate:HI (lshiftrt:SI
	                   (plus:SI (plus:SI (match_operand:SI 1 "register_operand" "d")
	                                     (match_operand:SI 2 "register_operand" "d"))
		                    (const_int 524288))
		           (const_int 20))))]
	""
	"%d0 = %1 + %2 (RND20);"  /*"%d0 = RND20 + (%1, %2);"*/
	[(set_attr "type" "dsp32")])	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;      dregs_hi = RND20 - (dregs, dregs)        ;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (truncate:HI (lshiftrt:SI
	                   (plus:SI (minus:SI (match_operand:SI 1 "register_operand" "d")
	                                      (match_operand:SI 2 "register_operand" "d"))
		                    (const_int 524288))
		           (const_int 20))))]
	""
	"%d0 = %1 - %2 (RND20);"  /*"%d0 = RND20 - (%1, %2);"*/
	[(set_attr "type" "dsp32")])				
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;      dregs = MAX / MAX (dregs, dregs)          ;;;;;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (smax:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
                                  (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))
                    (set (subreg:HI (match_dup 0) 1)
                         (smax:HI (subreg:HI (match_dup 1) 1)
                                  (subreg:HI (match_dup 2) 1)))])]
	""
	"%0 = MAX (%1, %2) (V);"   /* "%0 = MAX / MAX (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;      dregs = MIN / MIN (dregs, dregs)          ;;;;;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (smin:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
                                  (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))
                    (set (subreg:HI (match_dup 0) 1)
                         (smin:HI (subreg:HI (match_dup 1) 1)
                                  (subreg:HI (match_dup 2) 1)))])]
	""
	"%0 = MIN (%1, %2) (V);"   /*"%0 = MIN / MIN (%1, %2);"*/
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;      dregs = ABS / ABS dregs          ;;;;;;;;;;;;;;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (abs:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)))
                    (set (subreg:HI (match_dup 0) 1)
                         (abs:HI (subreg:HI (match_dup 1) 1)))])]
	"" 	
 	"%0 = ABS %1 (V);"  /* "%0 = ABS / ABS %1;"*/
 	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;        dregs_lo = RND dregs                 ;;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (truncate:HI (lshiftrt:SI
	                   (plus:SI (match_operand:SI 1 "register_operand" "d")
	                            (const_int 32768))
	                   (const_int 16))))]
	""
	"%h0 = %1 (RND);"  /* "%h0 = RND %1;" */
	[(set_attr "type" "dsp32")])
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;        dregs_hi = RND dregs                 ;;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (truncate:HI (lshiftrt:SI
	                   (plus:SI (match_operand:SI 1 "register_operand" "d")
	                            (const_int 32768))
	                   (const_int 16))))]
	""
	"%d0 = %1 (RND);"  /* "%d0 = RND %1;" */
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;        dregs = NEG / NEG dregs              ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (neg:HI (subreg:HI (match_operand:SI 1 "register_operand" "=d") 0)))
	            (set (subreg:HI (match_dup 0) 1)
	                 (neg:HI (subreg:HI (match_dup 1) 1)))])]
	""
	"%0 = - %1 (V);"   /* "%0 = NEG / NEG %1;"*/
	[(set_attr "type" "dsp32")])





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;         dsp32shift              ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;    dregs_lo = ASHIFT (dregs_lo BY dregs_lo )    ;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (ashift:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                 (sign_extract:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                                  (const_int 6) (const_int 0))))]
	""
	"%h0 = ASHIFT %h1 BY %h2;"  /*"%h0 = ASHIFT (%h1 BY %h2);"*/
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;    dregs_lo = ASHIFT (dregs_hi BY dregs_lo )    ;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (ashift:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                 (sign_extract:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                                  (const_int 6) (const_int 0))))]
	""
	"%h0 = ASHIFT %d1 BY %h2;"  /*"%h0 = ASHIFT (%d1 BY %h2);"*/
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;    dregs_hi = ASHIFT (dregs_lo BY dregs_lo )    ;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (ashift:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                 (sign_extract:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                                  (const_int 6) (const_int 0))))]
	""
	"%d0 = ASHIFT %h1 BY %h2;"   /*"%d0 = ASHIFT (%h1 BY %h2);"*/
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;    dregs_hi = ASHIFT (dregs_hi BY dregs_lo )    ;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (ashift:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                 (sign_extract:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                                  (const_int 6) (const_int 0))))]
	""
	"%d0 = ASHIFT %d1 BY %h2;"    /*"%d0 = ASHIFT (%d1 BY %h2);"*/
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;    dregs_lo = LSHIFT (dregs_lo BY dregs_lo )    ;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (lshiftrt:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                   (sign_extract:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                                    (const_int 6) (const_int 0))))]
	""
	"%h0 = LSHIFT %h1 BY %h2;"  /*"%h0 = LSHIFT (%h1 BY %h2);"*/
	[(set_attr "type" "dsp32")])
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;    dregs_lo = LSHIFT (dregs_hi BY dregs_lo )    ;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (lshiftrt:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                   (sign_extract:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                                    (const_int 6) (const_int 0))))]
	""
	"%h0 = LSHIFT %d1 BY %h2;"   /*"%h0 = LSHIFT (%d1 BY %h2);"*/
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;    dregs_hi = LSHIFT (dregs_lo BY dregs_lo )    ;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (lshiftrt:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                   (sign_extract:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                                    (const_int 6) (const_int 0))))]
	""
	"%d0 = LSHIFT %h1 BY %h2;"  /*"%d0 = LSHIFT (%h1 BY %h2);"*/
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;    dregs_hi = LSHIFT (dregs_hi BY dregs_lo )    ;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (lshiftrt:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                   (sign_extract:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                                    (const_int 6) (const_int 0))))]
	""
	"%d0 = LSHIFT (%d1 BY %h2);"   /*"%d0 = LSHIFT (%d1 BY %h2);" */
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;    dregs = ASHIFT / ASHIFT (dregs BY dregs_lo )    ;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (ashift:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                   (sign_extract:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                                    (const_int 6) (const_int 0))))
	            (set (subreg:HI (match_dup 0) 1)
	                 (ashift:HI (subreg:HI (match_dup 1) 1)
	                   (sign_extract:HI (subreg:HI (match_dup 2) 0)
	                                    (const_int 6) (const_int 0))))])]
	""
	"%0 = ASHIFT %1 BY %h2 (V);"  /*"%0 = ASHIFT / ASHIFT (%1 BY %h2);"*/
	[(set_attr "type" "dsp32")])	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;    dregs = LSHIFT / LSHIFT (dregs BY dregs_lo )    ;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (lshiftrt:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                      (sign_extract:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                                       (const_int 6) (const_int 0))))
	            (set (subreg:HI (match_dup 0) 1)
	                 (lshiftrt:HI (subreg:HI (match_dup 1) 1)
	                      (sign_extract:HI (subreg:HI (match_dup 2) 0)
	                                       (const_int 6) (const_int 0))))])]
	""
	"%0 = SHIFT %1 BY %h2 (V);"  /*"%0 = LSHIFT / LSHIFT (%1 BY %h2);"*/
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;    dregs = ASHIFT (dregs BY dregs_lo )    ;;;;;;;;;;;
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (ashift:SI (match_operand:SI 1 "register_operand" "d")
	                 (sign_extract:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                                  (const_int 7) (const_int 0))))]
	""
	"%0 = ASHIFT %1 BY %h2;"   /*"%0 = ASHIFT (%1 BY %h2);"*/
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;    dregs = LSHIFT (dregs BY dregs_lo )    ;;;;;;;;;;;
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (lshiftrt:SI (match_operand:SI 1 "register_operand" "d")
	                   (sign_extract:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                                    (const_int 7) (const_int 0))))]
	""
	"%0 = SHIFT %1 BY %h2;"  /*"%0 = LSHIFT (%1 BY %h2);"*/
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;    dregs = ROT (dregs BY dregs_lo )    ;;;;;;;;;;;
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (rotate:SI (match_operand:SI 1 "register_operand" "d")
	                 (sign_extract:HI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)
	                                  (const_int 6) (const_int 0))))]
	""
	"%0 = ROT %1 BY %h2;"   /*"%0 = ROT (%1 BY %h2);"*/
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     dregs = PACK L L (dregs, dregs)       ;;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (ior:SI (ashift:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                         (const_int 16))
	              (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))]
	""
	"%0 = PACK (%h1, %h2);"  /*"%0 = PACK L L (%1, %2);"*/
	[(set_attr "type" "dsp32")])


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     dregs = PACK L H (dregs, dregs)       ;;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (ior:SI (ashift:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                         (const_int 16))
	              (subreg:HI (match_operand:SI 2 "register_operand" "d") 1)))]
	""
	"%0 = PACK (%h1, %d2);"   /*"%0 = PACK L H (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     dregs = PACK H L (dregs, dregs)       ;;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (ior:SI (ashift:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                         (const_int 16))
	              (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))]
	""
	"%0 = PACK (%d1, %h2);"   /*"%0 = PACK H L (%1, %2);"*/
	[(set_attr "type" "dsp32")])	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;     dregs = PACK H H (dregs, dregs)       ;;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (ior:SI (ashift:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                         (const_int 16))
	              (subreg:HI (match_operand:SI 2 "register_operand" "d") 1)))]
	""
	"%0 = PACK (%d1, %d2);"   /*"%0 = PACK H H (%1, %2);"*/
	[(set_attr "type" "dsp32")])
	
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (ior:SI (ashift:SI (match_operand:SI 1 "register_operand" "d")
	                         (const_int 24))
	              (lshiftrt:SI (match_operand:SI 2 "register_operand" "d")
	                           (const_int 8))))]
	""
	"%0 = ALIGN8(%1, %2);"
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (ior:SI (ashift:SI (match_operand:SI 1 "register_operand" "d")
	                         (const_int 16))
	              (lshiftrt:SI (match_operand:SI 2 "register_operand" "d")
	                           (const_int 16))))]
	""
	"%0 = ALIGN16(%1, %2);"
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (ior:SI (ashift:SI (match_operand:SI 1 "register_operand" "d")
	                         (const_int 8))
	              (lshiftrt:SI (match_operand:SI 2 "register_operand" "d")
	                           (const_int 24))))]
	""
	"%0 = ALIGN24(%1, %2);"
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;             dsp32shiftimm              ;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;   dregs_lo = ASHIFT (dregs_lo BY imm5)    ;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (ashift:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                 (sign_extend:HI (match_operand 2 "immediate_operand" "i"))))]
	/*"((int) INTVAL (operands[2]) >= -16 && (int) INTVAL (operands[2]) <= 15)"
	"%h0 = ASHIFT (%h1 BY %2);"*/
	""
        "*
      {
          if ((int) INTVAL (operands[2]) >= 0 && (int) INTVAL (operands[2]) <= 15)
                {
                  output_asm_insn (\"%h0 = %h1 << %2;\", operands);
                }
          else if ((int) INTVAL (operands[2]) < 0 && (int) INTVAL (operands[2]) >= -16)
                {
                  output_asm_insn (\"%h0 = %h1 >>> %2;\", operands);
                }
         RET;
      }"
	[(set_attr "type" "dsp32")])


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;   dregs_lo = ASHIFT (dregs_hi BY imm5)    ;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (ashift:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                 (sign_extend:HI (match_operand 2 "immediate_operand" "i"))))]
	""
	"*
      {
          if ((int) INTVAL (operands[2]) >= 0 && (int) INTVAL (operands[2]) <= 15)
                {
                  output_asm_insn (\"%h0 = %d1 << %2;\", operands);
                }
          else if ((int) INTVAL (operands[2]) < 0 && (int) INTVAL (operands[2]) >= -16)
                {
                  output_asm_insn (\"%h0 = %d1 >>> %2;\", operands);
                }
         RET;
      }"
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;   dregs_hi = ASHIFT (dregs_lo BY imm5)    ;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (ashift:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                 (sign_extend:HI (match_operand 2 "immediate_operand" "i"))))]
	/*"((int) INTVAL (operands[2]) >= -16 && (int) INTVAL (operands[2]) <= 15)"
	"%d0 = ASHIFT (%h1 BY %2);"*/
	""
        "*
      {
          if ((int) INTVAL (operands[2]) >= 0 && (int) INTVAL (operands[2]) <= 15)
                {
                  output_asm_insn (\"%d0 = %h1 << %2;\", operands);
                }
          else if ((int) INTVAL (operands[2]) < 0 && (int) INTVAL (operands[2]) >= -16)
                {
                  output_asm_insn (\"%d0 = %h1 >>> %2;\", operands);
                }
         RET;
      }"
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;   dregs_hi = ASHIFT (dregs_hi BY imm5)    ;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (ashift:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                 (sign_extend:HI (match_operand 2 "immediate_operand" "i"))))]
	/*"((int) INTVAL (operands[2]) >= -16 && (int) INTVAL (operands[2]) <= 15)"
	"%d0 = ASHIFT (%d1 BY %2);"*/
	""
        "*
      {
          if ((int) INTVAL (operands[2]) >= 0 && (int) INTVAL (operands[2]) <= 15)
                {
                  output_asm_insn (\"%d0 = %d1 << %2;\", operands);
                }
          else if ((int) INTVAL (operands[2]) < 0 && (int) INTVAL (operands[2]) >= -16)
                {
                  output_asm_insn (\"%d0 = %d1 >>> %2;\", operands);
                }
         RET;
      }"
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;   dregs_lo = LSHIFT (dregs_lo BY imm5)    ;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (lshiftrt:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                 (sign_extend:HI (match_operand 2 "immediate_operand" "i"))))]
	/*"((int) INTVAL (operands[2]) >= -16 && (int) INTVAL (operands[2]) <= 15)"
	"%h0 = LSHIFT (%h1 BY %2);"*/
	""
        "*
      {
          if ((int) INTVAL (operands[2]) >= 0 && (int) INTVAL (operands[2]) <= 15)
                {
                  output_asm_insn (\"%h0 = %h1 << %2;\", operands);
                }
          else if ((int) INTVAL (operands[2]) < 0 && (int) INTVAL (operands[2]) >= -16)
                {
                  output_asm_insn (\"%h0 = %h1 >> %2;\", operands);
                }
         RET;
      }"
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;   dregs_lo = LSHIFT (dregs_hi BY imm5)    ;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	      (lshiftrt:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                 (sign_extend:HI (match_operand 2 "immediate_operand" "i"))))]
	/*"((int) INTVAL (operands[2]) >= -16 && (int) INTVAL (operands[2]) <= 15)"
	"%h0 = LSHIFT (%d1 BY %2);"*/
	""
        "*
      {
          if ((int) INTVAL (operands[2]) >= 0 && (int) INTVAL (operands[2]) <= 15)
                {
                  output_asm_insn (\"%h0 = %d1 << %2;\", operands);
                }
          else if ((int) INTVAL (operands[2]) < 0 && (int) INTVAL (operands[2]) >= -16)
                {
                  output_asm_insn (\"%h0 = %d1 >> %2;\", operands);
                }
         RET;
      }"
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;   dregs_hi = LSHIFT (dregs_lo BY imm5)    ;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (lshiftrt:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                 (sign_extend:HI (match_operand 2 "immediate_operand" "i"))))]
	/*"((int) INTVAL (operands[2]) >= -16 && (int) INTVAL (operands[2]) <= 15)"
	"%d0 = LSHIFT (%h1 BY %2);"*/
	""
        "*
      {
          if ((int) INTVAL (operands[2]) >= 0 && (int) INTVAL (operands[2]) <= 15)
                {
                  output_asm_insn (\"%d0 = %h1 << %2;\", operands);
                }
          else if ((int) INTVAL (operands[2]) < 0 && (int) INTVAL (operands[2]) >= -16)
                {
                  output_asm_insn (\"%d0 = %h1 >> %2;\", operands);
                }
         RET;
      }"
	[(set_attr "type" "dsp32")])	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;   dregs_hi = LSHIFT (dregs_hi BY imm5)    ;;;;;;;;;;;;;;;
(define_insn ""
	[(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 1)
	      (lshiftrt:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1)
	                 (sign_extend:HI (match_operand 2 "immediate_operand" "i"))))]
	/*"((int) INTVAL (operands[2]) >= -16 && (int) INTVAL (operands[2]) <= 15)"
	"%d0 = LSHIFT (%d1 BY %2);"*/
	""
        "*
      {
          if ((int) INTVAL (operands[2]) >= 0 && (int) INTVAL (operands[2]) <= 15)
                {
                  output_asm_insn (\"%d0 = %d1 << %2;\", operands);
                }
          else if ((int) INTVAL (operands[2]) < 0 && (int) INTVAL (operands[2]) >= -16)
                {
                  output_asm_insn (\"%d0 = %d1 >> %2;\", operands);
                }
         RET;
      }"
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;   dregs = LSHIFT / LSHIFT (dregs BY imm5)    ;;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (lshiftrt:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                              (zero_extend:HI (match_operand 2 "immediate_operand" "i"))))
	            (set (subreg:HI (match_dup 0) 1)
	                 (lshiftrt:HI (subreg:HI (match_dup 1) 1)
	                              (zero_extend:HI (match_dup  2))))])]
	/*"((int) INTVAL (operands[2]) >= -16 && (int) INTVAL (operands[2]) <= 15)"
	"%0 = LSHIFT / LSHIFT (%1 BY %2);"*/
        "((int) INTVAL (operands[2]) >= 0 && (int) INTVAL (operands[2]) < 16)"
	"%0 = %1 >> %2 (V);"
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;   dregs = ASHIFT / ASHIFT (dregs BY imm5)    ;;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (ashift:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                            (zero_extend:HI (match_operand 2 "immediate_operand" "i"))))
	            (set (subreg:HI (match_dup 0) 1)
	                 (ashift:HI (subreg:HI (match_dup 1) 1)
	                            (zero_extend:HI (match_dup  2))))])]
	/*"((int) INTVAL (operands[2]) >= -16 && (int) INTVAL (operands[2]) <= 15)"
	"%0 = ASHIFT / ASHIFT (%1 BY %2);"*/
        "((int) INTVAL (operands[2]) >= 0 && (int) INTVAL (operands[2]) < 16)"
	"%0 = %1 << %2 (V);"
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;   dregs = dregs >>> uimm4 (V)                ;;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (ashiftrt:HI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0)
	                            (sign_extend:HI (match_operand 2 "immediate_operand" "i"))))
	            (set (subreg:HI (match_dup 0) 1)
	                 (ashiftrt:HI (subreg:HI (match_dup 1) 1)
	                            (sign_extend:HI (match_dup  2))))])]
	"((int) INTVAL (operands[2]) >= 0 && (int) INTVAL (operands[2]) < 16)"
	"%0 = %1 >>> %2 (V);"
	[(set_attr "type" "dsp32")])


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;   dregs = ASHIFT (dregs BY imm6)    ;;;;;;;;;;;;;;;
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (ashiftrt:SI (match_operand:SI 1 "register_operand" "d")
	                 (sign_extend:SI (match_operand 2 "immediate_operand" "i"))))]
	/*"((int) INTVAL (operands[2]) >= -32 && (int) INTVAL (operands[2]) <= 31)"
	"%0 = ASHIFT (%1 BY %2);"*/
        "((int) INTVAL (operands[2]) >= 0 && (int) INTVAL (operands[2]) < 16)"
	"%0 = %1 >>> %2;"
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;   dregs = LSHIFT (dregs BY imm6)    ;;;;;;;;;;;;;;;
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (ashift:SI (match_operand:SI 1 "register_operand" "d")
	                   (zero_extend:SI (match_operand 2 "immediate_operand" "i"))))]
	/*"((int) INTVAL (operands[2]) >= -32 && (int) INTVAL (operands[2]) <= 31)"
	"%0 = LSHIFT (%1 BY %2);"*/
        "((int) INTVAL (operands[2]) >= 0 && (int) INTVAL (operands[2]) < 16)"
	"%0 = %1 << %2;"
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;   dregs = ROT (dregs BY imm6)    ;;;;;;;;;;;;;;;
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (rotate:SI (match_operand:SI 1 "register_operand" "d")
	                   (sign_extend:SI (match_operand 2 "immediate_operand" "i"))))]
	"((int) INTVAL (operands[2]) >= -32 && (int) INTVAL (operands[2]) <= 31)"
	"%0 = ROT %1 BY %2;"    /*"%0 = ROT (%1 BY %2);"*/
	[(set_attr "type" "dsp32")])


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;        dsp32mult :: don't involve accumulator  ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;     dregs = (multfunc), MUNOP (dregs, dregs) macmod_hmove	   ;;;;;;
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (mult:SI (sign_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0))
	               (sign_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))))]
	""
	"%0 = %h1 * %h2;"   /* "%0 = (L * L), MUNOP (%1, %2);"*/
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (mult:SI (zero_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0))
	               (zero_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))))]
	""
	"%0 = %h1 * %h2 (FU);"  /* "%0 = (L * L), MUNOP (%1, %2) U;"*/
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (ashift:SI (mult:SI (sign_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0))
	                          (sign_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))
	                 (const_int 1)))]
	""
	"%0 = %h1 * %h2  (ISS2);"   /* "%0 = (L * L), MUNOP (%1, %2) IS;"*/
	[(set_attr "type" "dsp32")])

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (mult:SI (sign_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0))
	               (sign_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 1))))]
	""
	"%0 = %h1 * %d2;"   /*"%0 = (L * H), MUNOP (%1, %2);"*/
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (mult:SI (zero_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0))
	               (zero_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 1))))]
	""
	"%0 = %h1 * %d2 (FU);"    /*"%0 = (L * H), MUNOP (%1, %2) U;"*/
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (ashift:SI (mult:SI (sign_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0))
	                          (sign_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 1)))
	                 (const_int 1)))]
	""
	"%0 = %h1 * %d2 (ISS2);" /*"%0 = (L * H), MUNOP (%1, %2) IS;"*/
	[(set_attr "type" "dsp32")])

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (mult:SI (sign_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1))
	               (sign_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))))]
	""
	"%0 = %d1 * %h2;"  /*"%0 = (H * L), MUNOP (%1, %2);"*/
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (mult:SI (zero_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1))
	               (zero_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0))))]
	""
	"%0 = %d1 * %h2 (FU);"  /*"%0 = (H * L), MUNOP (%1, %2) U;"*/
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (ashift:SI (mult:SI (sign_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1))
	                          (sign_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))
	                 (const_int 1)))]
	""
	"%0 = %d1 * %h2 (ISS2);"   /*"%0 = (H * L), MUNOP (%1, %2) IS;"*/
	[(set_attr "type" "dsp32")])


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (mult:SI (sign_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1))
	               (sign_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 1))))]
	""
	"%0 = %d1 * %d2;"  /*"%0 = (H * H), MUNOP (%1, %2);"*/
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (mult:SI (zero_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1))
	               (zero_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 1))))]
	""
	"%0 = %d1 * %d2 (FU);"   /*"%0 = (H * H), MUNOP (%1, %2) U;"*/
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(set (match_operand:SI 0 "register_operand" "=d")
	      (ashift:SI (mult:SI (sign_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 1))
	                          (sign_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 1)))
	                 (const_int 1)))]
	""
	"%0 = %d1 * %d2 (ISS2);"  /*"%0 = (H * H), MUNOP (%1, %2) IS;"*/
	[(set_attr "type" "dsp32")])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;    dregs = (multfunc mxd_mod, multfunc) (dregs, dregs) macmod_hmove  ;;;;;;;;;;;;
;;;;;;;;;;    dregs = (H * H, L * L) (dregs, dregs) normal or IS                ;;;;;;;;;;;;
;;;;;;;;;;    don't clobber accumulator registers                               ;;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (truncate:HI (mult:SI
	                     (sign_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0))
                             (sign_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))))
                    (set (subreg:HI (match_dup 0) 1)
                         (truncate:HI (mult:SI
	                     (sign_extend:SI (subreg:HI (match_dup 1) 1))
                             (sign_extend:SI (subreg:HI (match_dup 2) 1)))))])]
	""
	"%d0 = %d1 * %d2, %h0 = %h1 * %h2 (T);"  /*"%0 = (H * H, L * L) (%1, %2) T;"*/
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (truncate:HI (ashift:SI (mult:SI
	                                (sign_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0))
                                        (sign_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))
                                       (const_int 1))))
                    (set (subreg:HI (match_dup 0) 1)
                         (truncate:HI (ashift:SI (mult:SI
	                                              (sign_extend:SI (subreg:HI (match_dup 1) 1))
                                                      (sign_extend:SI (subreg:HI (match_dup 2) 1)))
                                       (const_int 1))))])]
	""
	"%d0 = %d1 * %d2, %h0 = %h1 * %h2 (ISS2);"  /*"%0 = (H * H, L * L) (%1, %2) IS;"*/
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (truncate:HI (mult:SI
	                     (zero_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0))
                             (zero_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))))
                    (set (subreg:HI (match_dup 0) 1)
                         (truncate:HI (mult:SI
	                     (zero_extend:SI (subreg:HI (match_dup 1) 1))
                             (zero_extend:SI (subreg:HI (match_dup 2) 1)))))])]
	""
	"%d0 = %d1 * %d2, %h0 = %h1 * %h2 (TFU);"  /*"%0 = (H * H, L * L) (%1, %2) TU;"*/
	[(set_attr "type" "dsp32")])

	;;;;;;;;;;;;;;;;    mxd_mod=1    ;;;;;;;;;;;;;;;;;
(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (truncate:HI (mult:SI
	                     (sign_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0))
                             (zero_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))))
                    (set (subreg:HI (match_dup 0) 1)
                         (truncate:HI (mult:SI
	                     (sign_extend:SI (subreg:HI (match_dup 1) 1))
                             (zero_extend:SI (subreg:HI (match_dup 2) 1)))))])]
	""
	"%d0 = %d1 * %d2, %h0 = %h1 * %h2 (M, T);"  /*"%0 = (H * H M, L * L) (%1, %2) T;"*/
	[(set_attr "type" "dsp32")])

(define_insn ""
	[(parallel [(set (subreg:HI (match_operand:SI 0 "register_operand" "=d") 0)
	                 (truncate:HI (ashift:SI (mult:SI
	                                (sign_extend:SI (subreg:HI (match_operand:SI 1 "register_operand" "d") 0))
                                        (zero_extend:SI (subreg:HI (match_operand:SI 2 "register_operand" "d") 0)))
                                       (const_int 1))))
                    (set (subreg:HI (match_dup 0) 1)
                         (truncate:HI (ashift:SI (mult:SI
	                                              (sign_extend:SI (subreg:HI (match_dup 1) 1))
                                                      (zero_extend:SI (subreg:HI (match_dup 2) 1)))
                                       (const_int 1))))])]
	""
	"%d0 = %d1 * %d2, %h0 = %h1 * %h2 (M, ISS2);"  /*"%0 = (H * H M, L * L) (%1, %2) IS;"*/
	[(set_attr "type" "dsp32")])

