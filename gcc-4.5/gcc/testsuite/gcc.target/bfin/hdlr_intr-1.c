/* { dg-do compile } */
/* { dg-final { scan-assembler "\[\t\]rti" } } */
/* { dg-final { scan-assembler-not "\[\t\]RETI" } } */
/* { dg-final { scan-assembler-not "\[\t\]rts" } } */
/* { dg-final { scan-assembler-not "\[\t\]rtn" } } */
/* { dg-final { scan-assembler-not "\[\t\]rtx" } } */

__attribute__((interrupt_handler)) void
evt_intr(void) {
  /* No code */
}
