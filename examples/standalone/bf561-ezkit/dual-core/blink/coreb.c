#include <cdefBF561.h>
#include "blink.h"

int count_b __attribute__ ((section (".b.data"))) = 0;

void core_b_LED_Bar (const int iSpeed) __attribute__ ((section (".b.text")));
void core_b_LED_Bar (const int iSpeed)
{
  enLED n;

  lock (&pfio2_lock);
  for (n = LED1; n < LED9; (n <<= 1))
    {
      ClearSet_LED (n, 3);
      count_b++;
      Delay (iSpeed);
    }
  unlock (&pfio2_lock);
}

int coreb_main (void) __attribute__ ((section (".b.text")));
int coreb_main (void)
{
  while (1)
    core_b_LED_Bar (BLINK_FAST);
  return 0;
}
