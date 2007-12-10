#include <cdefBF561.h>

#define BLINK_FAST      2000
#define BLINK_SLOW      (BLINK_FAST * 2)

typedef enum LEDS_tag
{
  /*
  LED1 = 0x0001,
  LED2 = 0x0002,
  LED3 = 0x0004,
  LED4 = 0x0008,
  LED5 = 0x0010,
  LED6 = 0x0020,
  LED7 = 0x0040,
  LED8 = 0x0080,
  LAST_LED = 0x0100
  */
  LED1 = 0x0100,
  LED2 = 0x0200,
  LED3 = 0x0400,
  LED4 = 0x0800,
  LED5 = 0x1000,
  LED6 = 0x2000,
  LED7 = 0x4000,
  LED8 = 0x8000,
  LAST_LED = 0x10000
} enLED;

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

void LED_Bar (const int iSpeed)
{
  enLED n;

  for (n = LED1; n < LAST_LED; (n <<= 1))
    {
      ClearSet_LED (n, 3);
      Delay (iSpeed);
    }
}

int main(void)
{
  Init_LEDs ();
  ClearSet_LED_Bank (-1, 0x0000);
  while (1)
    LED_Bar (BLINK_SLOW);
  return 0;
}
