/*
 * Misc Debug Masks
 */

#ifndef __BFIN_PERIPHERAL_DEBUG__
#define __BFIN_PERIPHERAL_DEBUG__

/* WPIACTL Masks */
#define WPAND     (1 << 25)
#define EMUSW5    (1 << 24)
#define EMUSW4    (1 << 23)
#define WPICNTEN5 (1 << 22)
#define WPICNTEN4 (1 << 21)
#define WPIAEN5   (1 << 20)
#define WPIAEN4   (1 << 19)
#define WPIRINV45 (1 << 18)
#define WPIREN45  (1 << 17)
#define EMUSW3    (1 << 16)
#define EMUSW2    (1 << 15)
#define WPICNTEN3 (1 << 14)
#define WPICNTEN2 (1 << 13)
#define WPIAEN3   (1 << 12)
#define WPIAEN2   (1 << 11)
#define WPIRINV23 (1 << 10)
#define WPIREN23  (1 << 9)
#define EMUSW1    (1 << 8)
#define EMUSW0    (1 << 7)
#define WPICNTEN1 (1 << 6)
#define WPICNTEN0 (1 << 5)
#define WPIAEN1   (1 << 4)
#define WPIAEN0   (1 << 3)
#define WPIRINV01 (1 << 2)
#define WPIREN01  (1 << 1)
#define WPPWR     (1 << 0)

/* WPDACTL Masks */
#define WPDCNTEN1 (1 << 5)
#define WPDCNTEN0 (1 << 4)
#define WPDAEN1   (1 << 3)
#define WPDAEN0   (1 << 2)
#define WPDRINV01 (1 << 1)
#define WPDREN01  (1 << 0)

/* WPSTAT Masks */
#define STATDA1 (1 << 7)
#define STATDA0 (1 << 6)
#define STATIA5 (1 << 5)
#define STATIA4 (1 << 4)
#define STATIA3 (1 << 3)
#define STATIA2 (1 << 2)
#define STATIA1 (1 << 1)
#define STATIA0 (1 << 0)

#endif
