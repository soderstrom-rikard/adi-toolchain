/* { dg-do compile } */

struct x {
  int selector;
};

void f()
{
  struct x* addr;
  __asm__("mov %%gs,%0":"=r" ((unsigned short)addr->selector)); /* { dg-error "lvalue" "casts make rvalues" } */
}
