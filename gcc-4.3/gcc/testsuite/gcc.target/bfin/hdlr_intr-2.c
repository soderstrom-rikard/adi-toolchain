/* { dg-do compile } */
/* { dg-final { scan-assembler "\[\t\]rti" } } */
/* { dg-final { scan-assembler-times "\[\t\]RETI" 2 } } */
/* { dg-final { scan-assembler-not "\[\t\]rts" } } */
/* { dg-final { scan-assembler-not "\[\t\]rtn" } } */
/* { dg-final { scan-assembler-not "\[\t\]rtx" } } */

__attribute__((interrupt_handler, nesting)) void
evt_intr(void) {
  /* No code */
}
