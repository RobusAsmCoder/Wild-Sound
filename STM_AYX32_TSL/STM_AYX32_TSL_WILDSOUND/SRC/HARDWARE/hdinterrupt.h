//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __HDINTERRUPT_H
#define __HDINTERRUPT_H


#include "SysType.h"

#define VECTORTABLE_SIZE        (256)           // size Cortex-M3 vector table
#define VECTORTABLE_ALIGNMENT   (0x100ul)       // 16 Cortex + 32 ARMCM3 = 48 words
                                                // next power of 2 = 256

extern u32 vectorTable_RAM[VECTORTABLE_SIZE] __attribute__(( aligned (VECTORTABLE_ALIGNMENT) ));

typedef void(intVecPointer)(void)__irq;

extern void hdIntSwitchInterruptToRAM(void);
extern void hdIntSetVector(s16 irqn, intVecPointer *p);


#endif
