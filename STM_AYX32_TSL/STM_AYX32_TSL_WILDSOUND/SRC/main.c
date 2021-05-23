//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

//#include <string.h>
#include "SysType.h"
#include "hardware.h"
#include "hdinterrupt.h"
#include "TestCase.h"
#include "ChipAY_Main.h"
#include "ChipAY_Hardware.h"
#include "ChipAY_Interrupt.h"
#include "ChipAY_WildSound.h"
#include "process.h"
#include "interface.h"
#include "ChipAY_Test.h"
#include "core_UID.h"
#include "BootFlasherF4.h"
#include "ChipAY.h"
#include "MemoryAllocator.h"
#include "stdio.h"

//#include "interface.h"



void RNG_Config(void)
{  
 // Enable RNG clock source
  RCC_AHB2PeriphClockCmd(RCC_AHB2Periph_RNG, ENABLE);
  // RNG Peripheral enable
  RNG_Cmd(ENABLE);
}
///////////////////////////////////////////////////
///////////////////////////////////////////////////


void ShowStartInfo(void)
{
    Send_RS_String("\x0D\x0A");
    Send_RS_String("Boot Flasher ...\x0D\x0A");
    Send_RS_String("Enture Group\x0D\x0A");
    {
      Send_RS_String("Flash Size: ");
      Send_RS_DEC(CORE_UID->FlashSizeK*1024);
      Send_RS_String("\x0D\x0A");
      
      Send_RS_String("Device ");
      Send_RS_HEX(CORE_UID->U_ID[0],8);
      Send_RS_Byte(' ');
      Send_RS_HEX(CORE_UID->U_ID[1],8);
      Send_RS_Byte(' ');
      Send_RS_HEX(CORE_UID->U_ID[2],8);
      //05DF2D34 34335746 43033515
      Send_RS_String("\x0D\x0A");
    }
}


int main(void)
{
    if (bflBootCheckNeedFlashing())
    {
      bflBootExtremalExecuteBlockType(BLOCK_TYPES_BOOT_STATIC);
      __nop();
    }
//    MPU_RegionConfig();
//    MPU_ExceptionByDMA_Test();
  
    hdIntSwitchInterruptToRAM();
    Init();
    
    
    Uart_RS_Init(115200,0x01);
    
    ShowStartInfo();
    FLASH_OB_Unlock();
    memalInit(mema_FLAG_ROMRAM, 64);
    //mallocTets();
  
    __disable_irq();

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
    ChipAY_ArmInit();
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
    
  
//    InterfaceInit();

    RNG_Config();
  
    
    chipAY_HardwareInit();
    //tstcasTimerTest();
    //tstcasExternatInterruptTest();
  
  
  //Reset Config
    ChipAY_Init(&ayStr.ay[0]);
    ChipAY_Init(&ayStr.ay[1]);

    chipAY_InterruptConfig();
    
    //TEST_Spi();
    __enable_irq();

    chMain();

}



