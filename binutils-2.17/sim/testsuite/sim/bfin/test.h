/* AZ AN AC0_COPY V_COPY CC AQ RND_MOD AC0 AC1 AV0 AV0S AV1 AV1S V VS */

#define _AZ		(1 << 0)
#define _AN		(1 << 1)
#define _AC0_COPY	(1 << 2)
#define _V_COPY		(1 << 3)
#define _CC		(1 << 5)
#define _AQ		(1 << 6)
#define _RND_MOD	(1 << 8)
#define _AC0		(1 << 12)
#define _AC1		(1 << 13)
#define _AV0		(1 << 16)
#define _AV0S		(1 << 17)
#define _AV1		(1 << 18)
#define _AV1S		(1 << 19)
#define _V		(1 << 24)
#define _VS		(1 << 25)

#define _SET		1
#define _UNSET		0

#define HI(x) (((x) >> 16) & 0xffff)
#define LO(x) ((x) & 0xffff)

#define LD32_LABEL(reg, sym) loadsym reg sym
#define LD32(reg, val) imm32 reg, val
#define CHECKREG(reg, val) CHECKREG reg, val

#define EVT0         0xFFE02000
#define EVT1         (EVT0 + 4 * 1)
#define EVT2         (EVT0 + 4 * 2)
#define EVT3         (EVT0 + 4 * 3)
#define EVT4         (EVT0 + 4 * 4)
#define EVT5         (EVT0 + 4 * 5)
#define EVT6         (EVT0 + 4 * 6)
#define EVT7         (EVT0 + 4 * 7)
#define EVT8         (EVT0 + 4 * 8)
#define EVT9         (EVT0 + 4 * 9)
#define EVT10        (EVT0 + 4 * 10)
#define EVT11        (EVT0 + 4 * 11)
#define EVT12        (EVT0 + 4 * 12)
#define EVT13        (EVT0 + 4 * 13)
#define EVT14        (EVT0 + 4 * 14)
#define EVT15        (EVT0 + 4 * 15)

#define EVT_OVERRIDE 0xFFE02100
#define IMASK        (EVT_OVERRIDE + 4 * 1)
#define IPEND        (EVT_OVERRIDE + 4 * 2)
#define ILAT         (EVT_OVERRIDE + 4 * 3)
