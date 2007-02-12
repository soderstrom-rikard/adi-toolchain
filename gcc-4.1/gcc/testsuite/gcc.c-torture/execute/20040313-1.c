/* PR middle-end/14470 */
/* Origin: Lodewijk Voge <lvoge@cs.vu.nl> */

#ifdef STACK_SIZE
#if STACK_SIZE < 5000
#define NUM (STACK_SIZE / 5)
#endif
#endif

#ifndef NUM
#define NUM 1024
#endif

extern void abort(void);

int main()
{
  int t[NUM + 1] = { NUM }, d;

  d = 0;
  d = t[d]++;
  if (t[0] != NUM + 1)
    abort();
  if (d != NUM)
    abort();
  return 0;
}
