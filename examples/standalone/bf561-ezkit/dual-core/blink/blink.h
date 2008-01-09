#define BLINK_FAST      200
#define BLINK_SLOW      (BLINK_FAST * 2)

typedef enum LEDS_tag
{
  LED1 = 0x0001,
  LED2 = 0x0002,
  LED3 = 0x0004,
  LED4 = 0x0008,
  LED5 = 0x0010,
  LED6 = 0x0020,
  LED7 = 0x0040,
  LED8 = 0x0080,
  LED9 = 0x0100,
  LED10 = 0x0200,
  LED11 = 0x0400,
  LED12 = 0x0800,
  LED13 = 0x1000,
  LED14 = 0x2000,
  LED15 = 0x4000,
  LED16 = 0x8000,
  LAST_LED = 0x10000
} enLED;

typedef volatile unsigned int testset_t;

extern void Delay (unsigned long ulMs) __attribute__ ((section (".l2.text")));
extern void ClearSet_LED (const enLED led, const int bState) __attribute__ ((section (".l2.text")));
extern void ClearSet_LED_Bank (const int enleds, const int iState) __attribute__ ((section (".l2.text")));
extern void lock (testset_t *t) __attribute__ ((section (".l2.text")));
extern void unlock (testset_t *t) __attribute__ ((section (".l2.text")));

extern testset_t pfio2_lock __attribute__ ((section (".l2.data")));
