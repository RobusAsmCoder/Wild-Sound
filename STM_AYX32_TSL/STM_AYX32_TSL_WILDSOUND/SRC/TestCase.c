//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "TestCase.h"
#include "hdinterrupt.h"
#include "hardware.h"
#include "ChipAY_Hardware.h"
#include "ChipAY_WildSound.h"
#include <cstddef>



/*

void TIM7_IRQHandler(void) __irq
{
    __asm("CPSIE I");
    static u8 b;
    if (TIM_GetITStatus(TIM7, TIM_IT_Update))
    {
      DACTEST(b&1);
      b++;
      TIM_ClearITPendingBit(TIM7, TIM_IT_Update);
    } else {
      __nop();
    }

}

void tstcasExternatInterruptTest(void)
{
}


void chipAY_DacSetupXXX(u32 freq)
{
  TIM_TimeBaseInitTypeDef    TIM_TimeBaseStructure;
  RCC_ClocksTypeDef           RCC_Clocks;
  u32                         presc;
  
  // TIM6 Periph clock enable
  RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM7, ENABLE);


  RCC_GetClocksFreq(&RCC_Clocks);
  presc = (RCC_Clocks.SYSCLK_Frequency/freq)>>4;
  
  // Time base configuration
  TIM_TimeBaseStructInit(&TIM_TimeBaseStructure);
  
  TIM_TimeBaseStructure.TIM_Prescaler = presc - 1;
  TIM_TimeBaseStructure.TIM_Period = 8;

  TIM_TimeBaseStructure.TIM_ClockDivision = TIM_CKD_DIV1;
  TIM_TimeBaseStructure.TIM_CounterMode = TIM_CounterMode_Up;
  TIM_TimeBaseInit(TIM7, &TIM_TimeBaseStructure);

  // TIM6 TRGO selection
  //TIM_SelectOutputTrigger(TIM7, TIM_TRGOSource_Update);
  // Start TIM
  TIM_ITConfig(TIM7, TIM_IT_Update, ENABLE);
  

  // TIM enable counter
  TIM_Cmd(TIM7, ENABLE);
  

    NVIC_InitTypeDef NVIC_InitStruct;
    NVIC_InitStruct.NVIC_IRQChannel = TIM7_IRQn;
    NVIC_InitStruct.NVIC_IRQChannelPreemptionPriority = 0x0F;
    NVIC_InitStruct.NVIC_IRQChannelSubPriority = 0x0F;
    NVIC_InitStruct.NVIC_IRQChannelCmd = ENABLE;
    NVIC_Init(&NVIC_InitStruct);

}
*/

void tstcasTimerTest(void)
{
    //chipAY_TimerSetup(TIM1, AyFreq, 0);
  

    

    //*(u32 *)(AY0TONEAwp_TIM) = 0;
  
  
    //TIM1->ARR  = 200;   //PER
    //TIM1->CCR2 = 100;   //PWM CH2

    //DACTEST(0);
    
    
    
/*    
    chipAY_TimerSetup(TIM2, AyFreq*2, 1);
    chipAY_TimerSetup(TIM1, 100000,   1);
    
    TIM_Cmd(TIM1, DISABLE);
  
     TIM_SelectOutputTrigger(TIM2, TIM_TRGOSource_OC1);
     TIM_SelectMasterSlaveMode(TIM2, TIM_MasterSlaveMode_Enable);
     TIM_SelectInputTrigger(TIM1, TIM_TS_ITR1);
     TIM_SelectSlaveMode(TIM1, TIM_SlaveMode_Gated);
    
     TIM1->CNT = 0;
     TIM1->ARR = 0xFFFF;
     TIM1->CCR2 = 1;
    TIM_Cmd(TIM1, ENABLE);
*/

/*    while(1)
    {
      __nop();
    }
*/
}



