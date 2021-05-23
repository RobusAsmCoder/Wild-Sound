//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __CORE_UID_H
#define __CORE_UID_H

#include "SysType.h"

typedef struct
{
  vu32 U_ID[3];
  vu16 Free[3];
  vu16 FlashSizeK;
} tcore_UID;
#define CORE_UID               ((tcore_UID *) ((u32)0x1FFF7A10))
//extern tcore_UID *CORE_UID;


#endif
