//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "hardware.h"
#include "ChipAY_Interrupt.h"
#include "ChipAY_Hardware.h"
#include "ChipAY_DigitalPlayer.h"
#include "ChipAY.h"
//return 0 if error
u16 chipAY_TimerRCC(TIM_TypeDef *TIMx)
{
        u16 r = 0;
        switch ((u32)TIMx)
        { default: break;
          #ifdef TIM1
          case (u32)TIM1 : RCC_APB2PeriphClockCmd(RCC_APB2Periph_TIM1 , ENABLE); r= 0x0401; break;
          #endif
          #ifdef TIM2
          case (u32)TIM2 : RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM2 , ENABLE); r= 0x0402;  break;
          #endif
          #ifdef TIM3
          case (u32)TIM3 : RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM3 , ENABLE); r= 0x0403; break;
          #endif
          #ifdef TIM4
          case (u32)TIM4 : RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM4 , ENABLE); r= 0x0404; break;
          #endif
          #ifdef TIM5
          case (u32)TIM5 : RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM5 , ENABLE); r= 0x0405; break;
          #endif
          #ifdef TIM6
          case (u32)TIM6 : RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM6 , ENABLE); r= 0x0406; break;
          #endif
          #ifdef TIM7
          case (u32)TIM7 : RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM7 , ENABLE); r= 0x0407; break;
          #endif
          #ifdef TIM8
          case (u32)TIM8 : RCC_APB2PeriphClockCmd(RCC_APB2Periph_TIM8 , ENABLE); r= 0x0408; break;
          #endif
          #ifdef TIM9
          case (u32)TIM9 : RCC_APB2PeriphClockCmd(RCC_APB2Periph_TIM9 , ENABLE); r= 0x0209; break;
          #endif
          #ifdef TIM10
          case (u32)TIM10: RCC_APB2PeriphClockCmd(RCC_APB2Periph_TIM10, ENABLE); r= 0x010A; break;
          #endif
          #ifdef TIM11
          case (u32)TIM11: RCC_APB2PeriphClockCmd(RCC_APB2Periph_TIM11, ENABLE); r= 0x010B; break;
          #endif
          #ifdef TIM12
          case (u32)TIM12: RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM12, ENABLE); r= 0x020C; break;
          #endif
          #ifdef TIM13
          case (u32)TIM13: RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM13, ENABLE); r= 0x010D; break;
          #endif
          #ifdef TIM14
          case (u32)TIM14: RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM14, ENABLE); r= 0x010E; break;
          #endif
        }
        return r;
}

u32 chipAY_TimerFreq(TIM_TypeDef *TIMx)
{
        u32 r = chipAY_TimerRCC(TIMx);
        RCC_ClocksTypeDef       RCC_Clocks;
        RCC_GetClocksFreq(&RCC_Clocks);
        switch( r & 0xF )
        {
          case 2:
          case 3:
          case 4:
          case 5:
          case 6:
          case 7:
          case 12:
          case 13:
          case 14:
            r = RCC_Clocks.PCLK1_Frequency*2;
            break;
          case 1:
          case 8:
          case 9:
          case 10:
          case 11:
            r = RCC_Clocks.PCLK2_Frequency*2;
            break;
          default:
            r=0;
            
        }
        return r;
}

//Init Timer For Generator
u16 chipAY_TimerSetupX(TIM_TypeDef *TIMx, u32 freq, u32 per, u8 enMask)  //u8 CHNNum,
{
  //TIM_OCInitTypeDef  TIM_OCInitStructure;
  //void(*TIM_OCxInit)(TIM_TypeDef*, TIM_OCInitTypeDef*);
        u16 rs=chipAY_TimerRCC(TIMx);
        if (rs)
        {
          /*
          switch (CHNNum)
          { default:
              return 0;
            case 1: TIM_OCxInit=TIM_OC1Init; break;
            case 2: TIM_OCxInit=TIM_OC2Init; break;
            case 3: TIM_OCxInit=TIM_OC3Init; break;
            case 4: TIM_OCxInit=TIM_OC4Init; break;
          }
          */
          //RCC_ClocksTypeDef       RCC_Clocks;
          u32                     presc;
          u32                     pwmper;
        
          //RCC_GetClocksFreq(&RCC_Clocks);
          presc = chipAY_TimerFreq(TIMx)/freq; //presc = (RCC_Clocks.PCLK1_Frequency/freq);    //Warning Configure DIVISION for ALL timer it same !!!
          TIM_TimeBaseInitTypeDef TIM_BaseStruct;
          TIM_TimeBaseStructInit(&TIM_BaseStruct);

          TIM_BaseStruct.TIM_Prescaler = per-1;
          TIM_BaseStruct.TIM_Period = presc;//-1;//+2;// TIM_PeriodValue
          pwmper = presc;
          
          TIM_BaseStruct.TIM_CounterMode = TIM_CounterMode_Up;
          TIM_BaseStruct.TIM_ClockDivision = TIM_CKD_DIV1;
          TIM_BaseStruct.TIM_RepetitionCounter = 0;
          TIM_TimeBaseInit(TIMx, &TIM_BaseStruct);

          //TIM_SelectInputTrigger(TIMx, TIM_TS_ITR1);
          //TIM_SelectSlaveMode(TIMx, TIM_SlaveMode_Trigger);
          TIM_SelectMasterSlaveMode(TIMx, TIM_MasterSlaveMode_Disable);

  /////////////////////////////////

          TIM_OCInitTypeDef TIM_OCStruct;
          // PWM mode 2 = Clear on compare match
          // PWM mode 1 = Set on compare match
          TIM_OCStruct.TIM_OCMode = TIM_OCMode_PWM1;//TIM_OCMode_PWM1;
          TIM_OCStruct.TIM_OutputState = TIM_OutputState_Enable;
          TIM_OCStruct.TIM_OCPolarity = TIM_OCPolarity_High;
          
          
          TIM_OCStruct.TIM_Pulse = (pwmper*50)/100; // 50%
          switch ((rs>>8) & 0x0F)
          {
            case 4:
              if (enMask & (1<<3)) TIM_OC4Init(TIMx, &TIM_OCStruct);
              TIM_OC4PreloadConfig(TIMx, TIM_OCPreload_Enable);
            case 3:
              if (enMask & (1<<2)) TIM_OC3Init(TIMx, &TIM_OCStruct);
              TIM_OC3PreloadConfig(TIMx, TIM_OCPreload_Enable);
            case 2:
              if (enMask & (1<<1)) TIM_OC2Init(TIMx, &TIM_OCStruct);
              TIM_OC2PreloadConfig(TIMx, TIM_OCPreload_Enable);
            case 1:
              if (enMask & (1<<0)) TIM_OC1Init(TIMx, &TIM_OCStruct);
              TIM_OC1PreloadConfig(TIMx, TIM_OCPreload_Enable);
            default:
              break;
          }

/////////////////////////////////

            TIM_BDTRInitTypeDef timer_bdtr;
            TIM_BDTRStructInit(&timer_bdtr);
            timer_bdtr.TIM_AutomaticOutput = TIM_AutomaticOutput_Enable;
            TIM_BDTRConfig(TIMx, &timer_bdtr);
          // Start count on TIMx
            TIM_Cmd(TIMx, ENABLE);
          }
          return rs;
}

//    TIM1          TIM5_TRGO       TIM2_TRGO       TIM3_TRGO       TIM4_TRGO
//    TIM2          TIM1_TRGO       TIM8_TRGO       TIM3_TRGO       TIM4_TRGO
//    TIM3          TIM1_TRGO       TIM2_TRGO       TIM5_TRGO       TIM4_TRGO
//    TIM4          TIM1_TRGO       TIM2_TRGO       TIM3_TRGO       TIM8_TRGO
//    TIM5          TIM2_TRGO       TIM3_TRGO       TIM4_TRGO       TIM8_TRGO
//    TIM6             ---             ---             ---             ---
//    TIM7             ---             ---             ---             ---
//    TIM8          TIM1_TRGO       TIM2_TRGO       TIM4_TRGO       TIM5_TRGO
//    TIM9          TIM2_TRGO       TIM3_TRGO       TIM10_OC        TIM11_OC
//    TIM10            ---             ---             ---             ---
//    TIM11            ---             ---             ---             ---
//    TIM12         TIM4_TRGO       TIM5_TRGO       TIM13_OC        TIM14_OC
//    TIM13            ---             ---             ---             ---
//    TIM14            ---             ---             ---             ---

u8 chipAY_TimerSetup(TIM_TypeDef *TIMxM, TIM_TypeDef *TIMxS, u32 freq, u32 per, u8 enMask)
{
    const u16 tmlTS[16]={
      0x0000,
      0x5234,
      0x1834,
      0x1254,
      0x1238,
      0x2348,
      0x0000,
      0x0000,
      0x1245,
      0x23AB,
      0x0000,
      0x0000,
      0x45DE,
      0x0000,
      0x0000,
      0x0000,
    };
      
    u8 rs=0;
    if (TIMxM==0)
    {
      rs = chipAY_TimerSetupX(TIMxS, freq, per, 0x01);
    } else {
      u8 rm = chipAY_TimerSetupX(TIMxM, freq*2, 5*0+0x34+1, 0x01);
         rs = chipAY_TimerSetupX(TIMxS, 100000,   1, 0x01);
      

      u16 w = tmlTS[rs];
      for (u8 n=0; n<4; n++)
      {
        u8 b=(w>>(12-n*4)) & 0x0F;
        if (b==rm)
        {
          TIM_Cmd(TIMxS, DISABLE);
        
          TIM_SelectOutputTrigger(TIMxM, TIM_TRGOSource_OC1);
          TIM_SelectMasterSlaveMode(TIMxM, TIM_MasterSlaveMode_Enable);
          switch (n) 
          {
            case 0: TIM_SelectInputTrigger(TIMxS, TIM_TS_ITR0); break;
            case 1: TIM_SelectInputTrigger(TIMxS, TIM_TS_ITR1); break;
            case 2: TIM_SelectInputTrigger(TIMxS, TIM_TS_ITR2); break;
            case 3: TIM_SelectInputTrigger(TIMxS, TIM_TS_ITR3); break;
          }
          TIM_SelectSlaveMode(TIMxS, TIM_SlaveMode_Gated);
          
          TIMxS->CNT = 0x0000;
          TIMxS->ARR = 0xFFFF;
          TIMxS->CCR2 = per;
          
          TIM_Cmd(TIMxS, ENABLE);
          break;
        }
      }
      
      
      
    }
    return rs;
}

//__attribute__((section("ROMCODE")))
//__attribute__((section("RAMCODE")))
//__attribute__((section("ccmram")))
#pragma push
#pragma arm section code = "RAMCODE"
#pragma arm section rwdata = "RAMCODE"
#pragma arm section rodata = "RAMCODE"
#pragma arm section zidata = "RAMCODE"


u32 ayDacVAL0 = 0x8000;
u32 ayDacVAL1 = 0x0000;
u32 ayDacVAL2 = 0x0000;
#define dacBufSize        4
#define dacBufSizeMask    (dacBufSize-1)
u16 DAC_CHL[dacBufSize+1];
u16 DAC_CHR[dacBufSize+1];
u8  DAC_CHP = 0;


//#pragma push
//#pragma O3
void ChipAY_DacStep(void)
{
      u32 daL0=0;
      u32 daR0=0;
      u16 isODD=0;
      u32 p=0;
  
      switch (ayStr.WORK_EMUL_HARDMD)
      {
        case work_hrdEmul_mode_AY_HARDWARE_TIMER:
          ayDacVAL0 = ChipAY_Mixer(&ayStr);
          daL0 = ((u16)(ayDacVAL0 >>  0));
          daR0 = ((u16)(ayDacVAL0 >> 16));
          break;
        case work_hrdEmul_mode_AY_SOFTODD:
          isODD=1;
        case work_hrdEmul_mode_AY_SOFT:
          p=AyFreqRealTiks*2;
          if (isODD==0)
          {
            u32 pp=p>>1;
            ayDacVAL1 = ChipAY_TiksARM(&ayStr.ay[0], pp);
            ayDacVAL2 = ChipAY_TiksARM(&ayStr.ay[1], pp);
          } else {
            static u8 od=0;
            u32 pp=p;
            if (od)
            {
              ayDacVAL1 = ChipAY_TiksARM(&ayStr.ay[0], pp);
            } else {
              ayDacVAL2 = ChipAY_TiksARM(&ayStr.ay[1], pp);
            }
            od ^= 1;
          }
          daL0 = ((u16)((ayDacVAL1 - ayDacVAL2) >>  0));
          daR0 = ((u16)((ayDacVAL1 - ayDacVAL2) >> 16));
          break;
        case work_hrdEmul_mode_AY_DIGITAL:
          daL0 = cayDigPlayerStreamGet(&digPlayer);
          daR0 = (u16)(daL0 >> 16);
          daL0 = (u16)(daL0);
          break;
      }
      
      DAC_CHL[(DAC_CHP) & dacBufSizeMask] = daL0 ^ 0x8000;// DAC->DHR12L1 = daL0;
      DAC_CHR[(DAC_CHP) & dacBufSizeMask] = daR0 ^ 0x8000;// DAC->DHR12L2 = daR0;
      DAC_CHP++;

    
}
//#pragma pop

//#define dacTimer(_tm)      _tm

#define bootCeckMax   100;

void SchekBootMode(void)
{
    static u8 cnt=bootCeckMax;
    if (SWO_GET()==0)
    {
      if (cnt)
      {
        cnt--;
      } else {
        ayStr.WORK_STATUS |= TSL_AYX32_S_BOOT;
      }
    } else {
      cnt=bootCeckMax;
    }
}

void TIM4_IRQHandler(void) __irq
{
      //SWO(0);
      TIM_ClearITPendingBit(TIM4, TIM_IT_Update);
      ChipAY_DacStep();
      SchekBootMode();
      //SWO(1);
}

#pragma pop


void chipAY_DacSetup(void)
{

      DAC_CHP = (s32)(dacBufSize>>1);
      for (u16 n=0; n<dacBufSize;n++)
      {
        DAC_CHL[n]=0x8000;
        DAC_CHR[n]=0x8000;
      }
      DAC_InitTypeDef DAC_InitStructure;
      // DAC Periph clock enable
      RCC_APB1PeriphClockCmd(RCC_APB1Periph_DAC, ENABLE);
      // DAC Structure
      DAC_InitStructure.DAC_LFSRUnmask_TriangleAmplitude = 0;
      DAC_InitStructure.DAC_Trigger = isDoDacByTimer ? DAC_Trigger_T4_TRGO : DAC_Trigger_None;
      DAC_InitStructure.DAC_WaveGeneration = DAC_WaveGeneration_None;
      DAC_InitStructure.DAC_OutputBuffer = DAC_OutputBuffer_Enable;
      DAC_Init(DAC_Channel_1, &DAC_InitStructure);
      DAC_Init(DAC_Channel_2, &DAC_InitStructure);

      DAC_DMACmd(DAC_Channel_1, ENABLE);
      DAC_DMACmd(DAC_Channel_2, ENABLE);
      DAC_Cmd(DAC_Channel_1, ENABLE);
      DAC_Cmd(DAC_Channel_2, ENABLE);
  
      DMA_InitTypeDef        DMA_InitStructureTIM;
      RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_DMA1, ENABLE);
  
      DMA_InitStructureTIM.DMA_BufferSize = dacBufSize;
      DMA_InitStructureTIM.DMA_FIFOMode = DMA_FIFOMode_Disable;
      DMA_InitStructureTIM.DMA_FIFOThreshold = DMA_FIFOThreshold_1QuarterFull;
      DMA_InitStructureTIM.DMA_MemoryBurst = DMA_MemoryDataSize_HalfWord;
      DMA_InitStructureTIM.DMA_MemoryDataSize = DMA_MemoryDataSize_HalfWord;
      DMA_InitStructureTIM.DMA_MemoryInc = DMA_MemoryInc_Enable;
      DMA_InitStructureTIM.DMA_Mode = DMA_Mode_Circular;
      DMA_InitStructureTIM.DMA_PeripheralBurst = DMA_PeripheralBurst_Single;
      DMA_InitStructureTIM.DMA_PeripheralDataSize = DMA_PeripheralDataSize_HalfWord;
      DMA_InitStructureTIM.DMA_PeripheralInc = DMA_PeripheralInc_Disable;
      DMA_InitStructureTIM.DMA_Priority = DMA_Priority_Low;
      // Configure TX DMA
      DMA_InitStructureTIM.DMA_DIR = DMA_DIR_MemoryToPeripheral;
      
      DMA_InitStructureTIM.DMA_Channel = DMA_Channel_7;
      
      DMA_InitStructureTIM.DMA_PeripheralBaseAddr = (u32)&DAC->DHR12L1;
      DMA_InitStructureTIM.DMA_Memory0BaseAddr = (u32)&DAC_CHL;
      DMA_Init(DMA1_Stream5, &DMA_InitStructureTIM);
      DMA_Cmd(DMA1_Stream5, ENABLE);
      DMA_InitStructureTIM.DMA_PeripheralBaseAddr = (u32)&DAC->DHR12L2;
      DMA_InitStructureTIM.DMA_Memory0BaseAddr = (u32)&DAC_CHR;
      DMA_Init(DMA1_Stream6, &DMA_InitStructureTIM);
      DMA_Cmd(DMA1_Stream6, ENABLE);
  
  
  
  
      
/*   TIM_TimeBaseInitTypeDef base_timer;
   TIM_TimeBaseStructInit(&base_timer);
   base_timer.TIM_Prescaler = chipAY_TimerFreq(TIM4) / 1000 - 1;
   base_timer.TIM_Period = 2000;
   base_timer.TIM_ClockDivision = TIM_CKD_DIV1;
   base_timer.TIM_CounterMode = TIM_CounterMode_Up;
   TIM_TimeBaseInit(TIM4, &base_timer);*/
   
   chipAY_TimerSetupX(TIM4, AyFreqSND, 1, 0);
   

   TIM_ITConfig(TIM4, TIM_IT_Update, ENABLE);
   TIM_SelectOutputTrigger(TIM4, TIM_TRGOSource_Update);

   NVIC_InitTypeDef NVIC_InitStructure;
   NVIC_InitStructure.NVIC_IRQChannel = TIM4_IRQn;
   NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
   NVIC_InitStructure.NVIC_IRQChannelSubPriority = 1;
   NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
   NVIC_Init(&NVIC_InitStructure);
   NVIC_SetPriority(TIM4_IRQn, 255);

  
  
  
}

void chipAY_HardwareInit(void)
{
      chipAY_DacSetup();
  
      AY0TONEA_Init();
      AY0TONEB_Init();
      AY0TONEC_Init();
      AY0ENV_Init();
      AY0NOI_Init();

      AY1TONEA_Init();
      AY1TONEB_Init();
      AY1TONEC_Init();
      AY1ENV_Init();
      AY1NOI_Init();

//      chipAY_TimerSetupX(TIM1, 1000, 1);
  
}







/////////////////////////////////////////



