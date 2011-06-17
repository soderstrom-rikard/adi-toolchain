/* { dg-do compile } */
/* { dg-final { scan-assembler "\[\t\]rtx" } } */
/* { dg-final { scan-assembler-not "\[\t\]rts" } } */
/* { dg-final { scan-assembler-not "\[\t\]rti" } } */
/* { dg-final { scan-assembler-not "\[\t\]rtn" } } */

__attribute__((exception_handler)) void
evt_except(void) {
  /* No code */
}
