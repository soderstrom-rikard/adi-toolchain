/* { dg-do compile } */
/* { dg-final { scan-assembler "\[\t\]rtn" } } */
/* { dg-final { scan-assembler-not "\[\t\]rts" } } */
/* { dg-final { scan-assembler-not "\[\t\]rti" } } */
/* { dg-final { scan-assembler-not "\[\t\]rtx" } } */

__attribute__((nmi_handler)) void
evt_nmi(void) {
  /* No code */
}
