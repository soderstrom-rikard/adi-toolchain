/******************************************************************************
  Copyright(c) 2000-2005 Analog Devices Inc. IPDC BANGALORE, India.
  All rights reserved
******************************************************************************
  File Name      : vvadd.asm
  Module Name    : vector vector addition
  Label name     :  __vecvadd_fr16
  Description    : This function computes the addition of two vectors
  Operand        : R0 - Address of input vector A,
                   R1 - Address of input vector B,
                   R2 - Address of output vector
  Registers Used : R0,R1,R2,R3,I0,P0,P1,P2

  Notes          : Input vectors should be in different banks to achieve
                   the cycle count given below.

  CYCLE COUNT    : 13            N == 0
                 : 10 + 2*N      for other N
  'N' - NUMBER OF ELEMENTS

  CODE SIZE      : 40 BYTES

  DATE           : 21-02-01
******************************************************************************/

.file_attr libGroup      = vector.h;
.file_attr libGroup      = matrix.h;             // called from matrix.h
.file_attr libFunc       = vecvadd_fr16;
.file_attr libFunc       = __vecvadd_fr16;
.file_attr libFunc       = matmadd_fr16;        // called from matrix.h
.file_attr libName = libdsp;
.file_attr prefersMem    = internal;
.file_attr prefersMemNum = "30";
.file_attr FuncName      = __vecvadd_fr16;

#if defined(__ADSPLPBLACKFIN__) && defined(__WORKAROUND_SPECULATIVE_LOADS)
#define __WORKAROUND_BF532_ANOMALY_050000245
#endif

.section program;
.global __vecvadd_fr16;
.align 2;

__vecvadd_fr16:
        P1 = [SP+12];              // NO. OF ELEMENTS IN INPUT VECTOR
        P0 = R0;                   // ADDRESS OF INPUT VECTOR1
        I0 = R1;                   // ADDRESS OF INPUT VECTOR2
        CC = P1 <= 0;              // CHECK IF NO. ELEMENTS(N) <= 0
        IF CC JUMP RET_ZERO;

#if defined(__WORKAROUND_BF532_ANOMALY_050000245)
        NOP;
        NOP;
#endif
        P2 = R2;                   // ADDRESS OF OUTPUT VECTOR
        R1 = W[P0++] (Z);          // GET INPUTS FROM VECTOR1 AND VECTOR2
        R2.L = W[I0++];

        LSETUP(ST_VVADD,END_VVADD) LC0 = P1;
ST_VVADD:   R3.L = R1.L + R2.L(S) || R1 = W[P0++] (Z);
                                   // DO ADDITION, FETCH NEXT INPUT FROM VEC.1

END_VVADD:  W[P2++] = R3 || R2.L = W[I0++];
                                   // STORE RESULT IN OUTPUT VECTOR
                                   // AND FETCH NEXT INPUT FROM VECTOR2
RET_ZERO:
        RTS;

.__vecvadd_fr16.end:
