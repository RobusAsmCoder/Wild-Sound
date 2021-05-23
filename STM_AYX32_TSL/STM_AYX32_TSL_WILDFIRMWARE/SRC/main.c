//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "rb_base64m.h"
#include "BootFlasherF4.h"

//const u8 base64mSTR[] = {BASE64_T_DEF};


#define fwBootStaticADDR    0x20000000
#define fwBootStaticTYPE    BLOCK_TYPES_BOOT_STATIC
const u8 fwBootStatic[]={
  #include "..\..\BootFlasherMemoryStatic\OBJ\STM_BootFlasherMemoryStatic.inc"
};
#define fwBootFlashADDR     0x08000000
#define fwBootFlashTYPE     BLOCK_TYPES_BOOT_FLASH
const u8 fwBootFlash[]={
  #include "..\..\BootFlasherMemoryFlash\OBJ\STM_BootFlasherMemoryFlash.inc"
};

#define fwFirmWareWildSoundAYXADDR     0x08000000
#define fwFirmWareWildSoundAYXTYPE     BLOCK_TYPES_DATA_FLASH
const u8 fwFirmWareWildSoundAYX[]={
  #include "..\..\STM_AYX32_TSL_WILDSOUND\OBJ\STM_AYX32_TSL_WILDSOUND.inc"
};


void SystemInit(void)
{
}

void StupidDelay(u32 del)
{
    while(del)
    {
      del--;
      __nop();__nop();__nop();__nop();__nop();__nop();__nop();__nop();__nop();
      __nop();__nop();__nop();__nop();__nop();__nop();__nop();__nop();__nop();
    }
}

void SWO(u8 b)
{
      if (b)
      {
        GPIO_SetBits(GPIOB, GPIO_Pin_3);
      } else {
        GPIO_ResetBits(GPIOB, GPIO_Pin_3);
      }
}

void GpioTest(void)
{
      RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE);

      GPIO_InitTypeDef gpioStruct;
      gpioStruct.GPIO_Mode = GPIO_Mode_OUT;
      gpioStruct.GPIO_PuPd = GPIO_PuPd_UP;
      gpioStruct.GPIO_Speed = GPIO_Speed_50MHz;
      gpioStruct.GPIO_Pin = GPIO_Pin_3;
      GPIO_Init(GPIOB, &gpioStruct);
}

void SWO_Step(void)
{
        SWO(0);
        StupidDelay(100);   //__nop();
        SWO(1);
        StupidDelay(100);
}


void PrepareFirmWare(void)
{
          bflImageStart();
          bflImageAddBlock(fwBootStaticADDR, (void *)&fwBootStatic, sizeof(fwBootStatic), fwBootStaticTYPE);
          bflImageAddBlock(fwBootFlashADDR, (void *)&fwBootFlash, sizeof(fwBootFlash), fwBootFlashTYPE);
          bflImageAddBlock(fwFirmWareWildSoundAYXADDR, (void *)&fwFirmWareWildSoundAYX, sizeof(fwFirmWareWildSoundAYX), fwFirmWareWildSoundAYXTYPE);
          bflImageFinish();
          if (bflBootCheckNeedFlashing())
          {
            NVIC_SystemReset(); //bflBootExtremalExecuteBlockType(BLOCK_TYPES_BOOT_STATIC);
          }
}

int main(void)
{
  
      StupidDelay(100);
      GpioTest();
      for (u32 n=0; n<10; n++)
      {
        SWO_Step();
      }
      
      
      //BASE64m_Init(&bas64m, base64mSTR);
  
      if (bflBootCheckNeedFlashing())
      {
        bflBootExtremalExecuteBlockType(BLOCK_TYPES_BOOT_STATIC);
      }
      
      PrepareFirmWare();
      while(1)
      {
        SWO_Step();   //__nop();
      }
}

