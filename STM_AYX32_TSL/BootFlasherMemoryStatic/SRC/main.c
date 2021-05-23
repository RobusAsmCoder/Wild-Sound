//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "rb_base64m.h"
#include "BootFlasherF4.h"


void SystemInit(void)
{
    
}

int main(void)
{
      if (bflBootCheckNeedFlashing())
      {
        bflBootProgramBlockType(BLOCK_TYPES_BOOT_FLASH);
        bflBootProgramBlockType(BLOCK_TYPES_DATA_FLASH);
        bflBootFlashDisable();
      }
      NVIC_SystemReset(); //bflBootExtremalExecFlash();
  
      while(1)
      {
        __asm {
          NOP
          NOP
          NOP
          NOP
          NOP
          NOP
          NOP
          NOP
          NOP
          NOP
          NOP
          NOP
        }
      }
}

