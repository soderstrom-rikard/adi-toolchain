#include <cdefBF561.h>
#include "blink.h"

testset_t pfio2_lock = 0;

int count_a = 0;

void Delay (unsigned long ulMs)
{
  unsigned long sleep = ulMs * 5000;
  while (sleep--)
    asm("nop");
}

void Init_LEDs(void)
{
  *pFIO2_DIR = 0xffff;
  *pFIO2_FLAG_S = 0xffff;
  *pFIO2_FLAG_C = 0xffff;
}

void ClearSet_LED (const enLED led, const int bState)
{
  if (0 == bState)
    *pFIO2_FLAG_C = led;
  else if (1 == bState)
    *pFIO2_FLAG_S = led;
  else
    *pFIO2_FLAG_T = led;
}

void ClearSet_LED_Bank (const int enleds, const int iState)
{
  enLED n;
  int nTempState = iState;

  for (n = LED1; n < LAST_LED; (n <<= 1))
    {
      if (n & enleds)
	ClearSet_LED (n, (nTempState & 0x3));
      nTempState >>= 2;
    }
}

void lock (testset_t *t)
{
  int tVal;

  __builtin_bfin_csync ();
  asm ("testset (%2); %0 = CC;" : "=d"(tVal), "+m" (*t) : "a" (t));
  while (tVal == 0)
    {
      __builtin_bfin_csync ();
      asm ("testset (%2); %0 = CC;" : "=d"(tVal), "+m" (*t) : "a" (t));
    }
}

void unlock (testset_t *t)
{
  * (char *) t = 0;
  __builtin_bfin_csync ();
}

static void LED_Bar (const int iSpeed)
{
  enLED n;

  for (n = LED9; n < LAST_LED; (n <<= 1))
    {
      lock (&pfio2_lock);
      ClearSet_LED (n, 3);
      count_a++;
      unlock (&pfio2_lock);
    }
}

static void core_b_enable ()
{
  *pSICA_SYSCR &= 0xffdf;
}

int main(void)
{
  Init_LEDs ();
  ClearSet_LED_Bank (-1, 0x0000);
  core_b_enable ();
  while (1)
    LED_Bar (BLINK_FAST);
  return 0;
}
