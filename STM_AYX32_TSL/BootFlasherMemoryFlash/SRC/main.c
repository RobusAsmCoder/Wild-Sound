//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "rb_base64m.h"
#include "BootFlasherF4.h"

//const u8 base64mSTR[] = {BASE64_T_DEF};



void SystemInit(void)
{
    
}

int main(void)
{
  
      //BASE64m_Init(&bas64m, base64mSTR);
  
      if (bflBootCheckNeedFlashing())
      {
        bflBootExtremalExecuteBlockType(BLOCK_TYPES_BOOT_STATIC);
      }
      NVIC_SystemReset(); //bflBootExtremalExecFlash();
      while(1)
      {
      }
}

