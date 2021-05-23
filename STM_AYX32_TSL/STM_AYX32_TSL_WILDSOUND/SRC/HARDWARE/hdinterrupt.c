//////////////////////////////////////////////////////////////////////////////////////
// 
// Low level for STM32
// 
// By Rob F. / Entire Group
// 
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "hdinterrupt.h"

//#include "ARMCM3.h"                     // Device header
extern uint32_t __Vectors[];                             /* vector table ROM  */
  

 
// new vector table in RAM
__attribute__((section("ccmram")))
u32 vectorTable_RAM[VECTORTABLE_SIZE] __attribute__(( aligned (VECTORTABLE_ALIGNMENT) ));
 
void hdIntSwitchInterruptToRAM(void)
{

  u32 i;
   
  for (i = 0; i < VECTORTABLE_SIZE; i++) {
    vectorTable_RAM[i] = __Vectors[i];            // copy vector table to RAM
  }
                                                  // replace SysTick Handler
  //vectorTable_RAM[SysTick_IRQn + 16] = (u32)SysTick_Handler_RAM;
  
  // relocate vector table
  __disable_irq();
    SCB->VTOR = (u32)&vectorTable_RAM;
  __DSB();
  __enable_irq();
 
}

//In System Vector
void hdIntSetVector(s16 irqn, intVecPointer *p)
{
    vectorTable_RAM[(irqn + 16)&0xFF] = (u32)(*p);
}

