//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __CHIPAY_TEST_H
#define __CHIPAY_TEST_H


#include "SysType.h"
#include "hardware.h"

extern void MPU_RegionConfig(void);
extern void MPU_ExceptionByDMA_Test(void);

extern u8 TEST_SpiSend(u8 b);
extern void TEST_Spi(void);

#endif
