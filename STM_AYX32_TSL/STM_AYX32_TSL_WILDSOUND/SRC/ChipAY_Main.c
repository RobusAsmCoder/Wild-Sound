//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "hardware.h"
#include "ChipAY_Main.h"
#include "ChipAY_Test.h"
#include "ChipAY_WildSound.h"
#include "ChipAY_Interrupt.h"
#include "ChipAY_Hardware.h"
#include "process.h"

//__attribute__((section("ROMCODE")))
//__attribute__((section("RAMCODE")))
//__attribute__((section("ccmram")))
#pragma push
#pragma arm section rwdata = "RAMCODE", rodata = "RAMCODE", zidata = "RAMCODE", code = "RAMCODE"




// Function to perform jump to system memory boot from user application
//
// Call function when you want to jump to system memory
//
void JumpToBootloader(void) {
  void (*SysMemBootJump)(void);
  
  //
  // Step: Set system memory address. 
  //       
  //       For STM32F429, system memory is on 0x1FFF 0000
  //       For other families, check AN2606 document table 110 with descriptions of memory addresses 
  //
  vu32 addr = 0x1FFF0000;
  
  //
  // Step: Disable RCC, set it to default (after reset) settings
  //       Internal clock, no PLL, etc.
  //
  RCC_DeInit();
  
  //
  // Step: Disable systick timer and reset it to default values
  //
  SysTick->CTRL = 0;
  SysTick->LOAD = 0;
  SysTick->VAL = 0;

  //
  // Step: Disable all interrupts
  //
  __disable_irq();
  
  //
  // Step: Remap system memory to address 0x0000 0000 in address space
  //       For each family registers may be different. 
  //       Check reference manual for each family.
  //
  //       For STM32F4xx, MEMRMP register in SYSCFG is used (bits[1:0])
  //       For STM32F0xx, CFGR1 register in SYSCFG is used (bits[1:0])
  //       For others, check family reference manual
  //
  //Remap by hand... {
#if defined(STM32F4)
  SYSCFG->MEMRMP = 0x01;
#endif
#if defined(STM32F0)
  SYSCFG->CFGR1 = 0x01;
#endif
  //} ...or if you use HAL drivers
  //__HAL_SYSCFG_REMAPMEMORY_SYSTEMFLASH();	//Call HAL macro to do this for you
  
  //
  // Step: Set jump memory location for system memory
  //       Use address with 4 bytes offset which specifies jump location where program starts
  //
  SysMemBootJump = (void (*)(void)) (*((u32 *)(addr + 4)));
  
  //
  // Step: Set main stack pointer.
  //       This step must be done last otherwise local variables in this function
  //       don't have proper value since stack pointer is located on different position
  //
  //       Set direct address location which specifies stack pointer in SRAM location
  //
  __set_MSP(*(u32 *)addr);
  
  //
  // Step: Actually call our function to jump to set location
  //       This will start system memory execution
  //
  SysMemBootJump();
  
  //
  // Step: Connect USB<->UART converter to dedicated USART pins and test
  //       and test with bootloader works with STM32 Flash Loader Demonstrator software
  //
}







process_alloc(process_main,        1, 4, 1);
process_alloc(process_aydac,       1, 4, 1);


void chMain(void)
{
    ListProcADD(&process_main,        proc_LNG_Main       | ProcSys_LOOP_INFINITE);
    ListProcADD(&process_aydac,       proc_LNG_AYDAC      | ProcSys_LOOP_INFINITE);  
    
    ayStr.WORK_STATUS |= 0x80;
  
    u32 tmr=0;
    u32 cnt=0;
    while(1)
    {
      DoProc(&process_aydac,  proc_NOP);
      DoProc(&process_main,   proc_NOP);
      if (WaitMS_CheckContinue(&tmr, 100))
      {
        //Send_RS_Byte(0xFF);
//        Send_RS_HEX(cnt,8);
//        Send_RS_String("\x0D\x0A");
        //TEST_SpiSend(cnt);
        cnt++;
      }
      
    }
}


#pragma pop

