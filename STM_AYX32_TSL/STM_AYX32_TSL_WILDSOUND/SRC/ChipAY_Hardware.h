//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __CHIPAY_HARDWARE_H
#define __CHIPAY_HARDWARE_H


#include "SysType.h"
#include "ChipAY_WildSound.h"

#define AyFreqCPU     (u32)(AyFreq*100/100)

//static __forceinline u8 _name##_PWMcur(void)    { return (*(u32 *)(_name##wp_CNT)<*(u32 *)(_name##wp_PWM)) ? 1:0;                       }   \

extern u8 chipAY_TimerSetup(TIM_TypeDef *TIMxM, TIM_TypeDef *TIMxS, u32 freq, u32 per, u8 enMask);

#define AYxPERupd(_name,_val) { const u32 val = _val;                                   \
                                u32 tmp = (*(vu32 *)(_name##wp_CNT));                   \
                                          (*( u16 *)(_name##wp_PSC)) = val;             \
                                          (*( u16 *)(_name##wp_EGR)) = TIM_EGR_UG;      \
                                          (*(vu32 *)(_name##wp_CNT)) = tmp; }
#define AYxPERupD(_name,_val) {           (*( u16 *)(_name##wp_PSC)) = _val;}
#define AYxPERcur(_name)      (*(u32 *)(_name##wp_PSC))
#define AYxCNTcur(_name)      (*(u32 *)(_name##wp_CNT))
#define AYxPWMcur(_name)      (*(u32 *)(_name##wp_PWM)!=0) ? ((*(u32 *)(_name##wp_CNT)<*(u32 *)(_name##wp_PWM)) ? 1:0) : 1
#define AYxCNMcur(_name,_mu)  ((AYxCNTcur(_name) * (_mu))/(*(u32 *)(_name##wp_PER)))
#define AYxPWMupd(_name,_val) (*(u32 *)(_name##wp_PWM))=((*(u32 *)(_name##wp_PER))*(u8)(_val))>>8

#define hdAYGEX(_name, _timm, _tims, _chn, _div)                                                                                                              \
enum { _name##wp_TIM          = (u32)(_tims)               ,                                                                                                  \
       _name##wp_TIMM         = (u32)(_timm)               ,                                                                                                  \
       _name##wp_CHN          = (u16)(_chn)                ,                                                                                                  \
       _name##wp_EGR          = (u32)(&_tims->EGR)         ,                                                                                                  \
       _name##wp_PSC          = (u32)(&_tims->PSC)         ,                                                                                                  \
       _name##wp_PER          = (u32)(&_tims->ARR)         ,                                                                                                  \
       _name##wp_PWM          = (u32)(&_tims->CCR##_chn)   ,                                                                                                  \
       _name##wp_CNT          = (u32)(&_tims->CNT)         ,                                                                                                  \
};                                                                                                                                                            \
static __forceinline void _name##_Init(void) { chipAY_TimerSetup((TIM_TypeDef *)(_name##wp_TIMM), (TIM_TypeDef *)(_name##wp_TIM), AyFreqCPU/(_div), 1000, 1<<((_chn)-1)); }  \
static __forceinline void _name##_PER(u16 _val) { *(u32 *)(_name##wp_PSC)=(u32)(_val);                                                  }                     \
static __forceinline void _name##_PWM(u8 _val)  { *(u32 *)(_name##wp_PWM)=(u32)( (*(u32 *)(_name##wp_PER)*_val)>>8 );                   }                     \
static __forceinline u8 _name##_PWMcur(void)    { return AYxPWMcur(_name);                                                              }                     \
static __forceinline u16 _name##_CNTcur(void)   { return AYxCNTcur(_name);                                                              }                     \
static __forceinline u16 _name##_CNMcur(u16 d)  { return AYxCNMcur(_name, d);                                                           }                     \

#define hdAYGEN(_name, _tim, _chn)              hdAYGEX(_name, 0, _tim, _chn, TNE_DIVER)
#define hdAYGER(_name, _tim, _chn, _div)        hdAYGEX(_name, 0, _tim, _chn, _div)


////////////////////////////////////////////////////////////////////////////////
// AY_CLK -> TIM5CH2 or TIM2CH2 - input clock for AY
//
//  slave TIM      ITR0(TS=000)    ITR1(TS=001)    ITR2(TS=010)    ITR3(TS=011)
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

////////////////////////////////////////////////////////////////////////////////
// We have Timers ...
//   tim  pwm
//+ TIM1  x4 - FOR MY TESTING I SEE ON THE PA9+PA10 !!!
//+ TIM2  x4 - +OPORA
//! TIM3  x4 - ++
//  TIM4  x4 - ++
//+ TIM5  x4 - ++

//+ TIM8  x4 - ++

//+ TIM9  x2 - +
//+ TIM10 x1 - +
//+ TIM11 x1 - +
//  TIM12 x2 - +
//+ TIM13 x1 - +
//+ TIM14 x1 - +

//+ TIM6  x0 - for DAC !!!
//  TIM7  x0 - for DAC !!!
//
////////////////////////////////////////////////////////////////////////////////
//  AYgen      timA --> timB         NOTE
//  0_TNE_A             TIM10   internal PRESCALLER
//  0_TNE_B             TIM9    internal PRESCALLER
//  0_TNE_C             TIM11   internal PRESCALLER
//  1_TNE_A             TIM13   internal PRESCALLER
//  1_TNE_B             TIM12   internal PRESCALLER
//  1_TNE_C             TIM14   internal PRESCALLER
//  0_ENV      TIM2     TIM5         TS=000
//  1_ENV      TIM2     TIM3         TS=001
//  0_NOISE    TIM2     TIM4         TS=001
//  1_NOISE    TIM2     TIM8         TS=001
//
//
////////////////////////////////////////////////////////////////////////////////
//
// fT = fM / ( 16*TP)
// fE = fM / (256*EP)
//
////////////////////////////////////////////////////////////////////////////////


  #define TNE_DIVER       16

    //TIM1->ARR  = 200;   //PER
    //TIM1->CCR2 = 100;   //PWM CH2
  
  hdAYGER(AY0TONEA,       TIM1 , 1, TNE_DIVER);     //10
  hdAYGER(AY0TONEB,       TIM8 , 1, TNE_DIVER);     //9
  hdAYGER(AY0TONEC,       TIM9 , 1, TNE_DIVER);     //11
  hdAYGER(AY1TONEA,       TIM10, 1, TNE_DIVER);     //13
  hdAYGER(AY1TONEB,       TIM11, 1, TNE_DIVER);     //12
  hdAYGER(AY1TONEC,       TIM2 , 1, TNE_DIVER);     //14
  
  hdAYGER(AY0ENV  ,       TIM6 , 1, 32*TNE_DIVER);  //5  //hdAYGEX(AY0ENV  , TIM2 ,TIM1 , 1);
  hdAYGER(AY1ENV  ,       TIM5 , 1, 32*TNE_DIVER);  //3  //hdAYGEX(AY1ENV  , TIM2 ,TIM3 , 1);
  
  hdAYGER(AY0NOI  ,       TIM13, 1, 2*TNE_DIVER);          //4  4096//hdAYGEX(AY0NOI  , TIM2 ,TIM4 , 1);
  hdAYGER(AY1NOI  ,       TIM14, 1, 2*TNE_DIVER);          //8  4096//hdAYGEX(AY1NOI  , TIM2 ,TIM8 , 1);
  
//#define AY0TONEBxPER(_val)      *(u32 *)(AY0TONEBwp_PSC)=(u32)(_val)
  
#define isDoDacByTimer    4     //use TIMR4 for dac
extern vu32 ayDacVAL;

extern u32 chipAY_TimerFreq(TIM_TypeDef *TIMx);
extern void chipAY_DacSetup(void);
extern void chipAY_HardwareInit(void);
extern void ChipAY_DacStep(void);



#endif
