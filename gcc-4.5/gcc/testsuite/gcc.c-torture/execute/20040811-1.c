/* Ensure that we deallocate X when branching back before its
   declaration.  */

#ifdef STACK_SIZE
#if STACK_SIZE < 5000
#define NUM (STACK_SIZE / 5)
#endif
#endif

#ifndef NUM
#define NUM 1000
#endif

void *volatile p;
                                                                                
int
main (void)
{
  int n = 0;
 lab:;
  int x[n % NUM + 1];
  x[0] = 1;
  x[n % NUM] = 2;
  p = x;
  n++;
  if (n < 1000000)
    goto lab;
  return 0;
}
