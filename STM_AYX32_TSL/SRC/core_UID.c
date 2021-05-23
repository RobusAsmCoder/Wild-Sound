//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "rb_fifo.h"
#include "core_UID.h"


  //void (*SendByte)(u8)

/*
mpu32 ProcA(void)
{
  return (u32 *)(SCB->CPUID);
}
mpu32 ProcB(void)
{
  return 2;
}

mpu32 ProcC(void)
{
  return 3;
}
*/

/*
tcore_UID CORE_UIDv={
   .U_ID = {(u32 *)&SCB->CPUID,
            (u32 *)&SCB->MMFR[0],
            (u32 *)&SCB->MMFR[1]}
};

tcore_UID *CORE_UID=&CORE_UIDv;
*/
