//////////////////////////////////////////////////////////////////////////////////////
// 
// Low level for STM32F100
// 
// By Rob F. / Entire Group
// 
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "hdports.h"

void hdGPIO_Active(GPIO_TypeDef* GPIOx)
{
    switch ((uint32_t)GPIOx) 
    {
#if isDefinedSTM32FXX
      case GPIOA_BASE: RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE); break;
      case GPIOB_BASE: RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE); break;
      case GPIOC_BASE: RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE); break;
      case GPIOD_BASE: RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOD, ENABLE); break;
      case GPIOE_BASE: RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOE, ENABLE); break;
      case GPIOF_BASE: RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOF, ENABLE); break;
      case GPIOG_BASE: RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOG, ENABLE); break;
#eif isDefinedSTM32LXX
      case GPIOA_BASE: RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOA, ENABLE); break;
      case GPIOB_BASE: RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOB, ENABLE); break;
      case GPIOC_BASE: RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOC, ENABLE); break;
      case GPIOD_BASE: RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOD, ENABLE); break;
      case GPIOE_BASE: RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOE, ENABLE); break;
      case GPIOF_BASE: RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOF, ENABLE); break;
      case GPIOG_BASE: RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOG, ENABLE); break;
      case GPIOH_BASE: RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOH, ENABLE); break;
#else
      case GPIOA_BASE: RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOA, ENABLE); break;
      case GPIOB_BASE: RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE); break;
      case GPIOC_BASE: RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOC, ENABLE); break;
      case GPIOD_BASE: RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD, ENABLE); break;
      case GPIOE_BASE: RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOE, ENABLE); break;
      case GPIOF_BASE: RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOF, ENABLE); break;
      case GPIOG_BASE: RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOG, ENABLE); break;
      case GPIOH_BASE: RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOH, ENABLE); break;
#endif
    }
}
// IS_GPIO_MODE(_v) ? (((_v)+1)<< 0)
//IS_GPIO_OTYPE(_v) ? (((_v)+1)<< 4)
//IS_GPIO_SPEED(_v) ? (((_v)+1)<< 8)
// IS_GPIO_PUPD(_v) ? (((_v)+1)<<12)
u8 hdGPIO_SetGetMode(GPIO_InitTypeDef *inSt, u16 mode, u8 num)
{
      u8 res;
      res = (mode>>(4*num)) & 0xF;
      //if (res)
      {
        const u8 md = res;
        switch(num)
        {
          case 0: inSt->GPIO_Mode  =  (GPIOMode_TypeDef)md; break;
          case 2: inSt->GPIO_Speed = (GPIOSpeed_TypeDef)md; break;
#ifdef isDefinedSTM32FXX
#else
          case 1: inSt->GPIO_OType = (GPIOOType_TypeDef)md; break;
          case 3: inSt->GPIO_PuPd  =  (GPIOPuPd_TypeDef)md; break;
#endif
        }
        res = res | 0x80;
      }
      return res;
}

  

GPIOMode_TypeDef hdGPIO_Init(GPIO_TypeDef* GPIOx, u8 pinpos, u16 mode)// GPIOMode_TypeDef GPIO_Mode, GPIOSpeed_TypeDef GPIO_Speed, GPIOOType_TypeDef GPIO_OType, GPIOPuPd_TypeDef GPIO_PuPd)
{
      #define mac_Step_md(_des,_type)             \
        _des=(_type)(mode&0xF);                   \
        mode>>=4
  u32 tmpreg = 0x00;
//  u8 md;
  GPIOMode_TypeDef  GPIO_Mode;
  GPIOSpeed_TypeDef GPIO_Speed;
  
#if isDefinedSTM32FXX
  mac_Step_md(GPIO_Mode,  GPIOMode_TypeDef  );
  mac_Step_md(GPIO_Speed, GPIOSpeed_TypeDef );
  
  tmpreg = (GPIO_Mode<<2) | (GPIO_Speed);
  uu64(GPIOx->CRL) = (uu64(GPIOx->CRL) & ~((u64)(0xFULL<<(4*pinpos)))) | ((u64)tmpreg)<<(4*pinpos);

  GPIOx->ODR = (GPIOx->ODR & ~(1<<pinpos)) | ((mode&1)<<pinpos);
  
#else
  GPIOOType_TypeDef GPIO_OType;
  GPIOPuPd_TypeDef  GPIO_PuPd;
  
  mac_Step_md(GPIO_Mode,  GPIOMode_TypeDef  );
  mac_Step_md(GPIO_OType, GPIOOType_TypeDef );
  mac_Step_md(GPIO_Speed, GPIOSpeed_TypeDef );
  mac_Step_md(GPIO_PuPd,  GPIOPuPd_TypeDef  );

      // Use temporary variable to update MODER register configuration, to avoid 
      // unexpected transition in the GPIO pin configuration.
      tmpreg = GPIOx->MODER;
      tmpreg &= ~(GPIO_MODER_MODER0 << (pinpos * 2));
      tmpreg |= (((u32)GPIO_Mode) << (pinpos * 2));
      GPIOx->MODER = tmpreg;

      if ((GPIO_Mode == GPIO_Mode_OUT) || (GPIO_Mode == GPIO_Mode_AF))
      {
        // Use temporary variable to update OSPEEDR register configuration, to avoid 
        // unexpected transition in the GPIO pin configuration.
        tmpreg = GPIOx->OSPEEDR;
        tmpreg &= ~(GPIO_OSPEEDER_OSPEEDR0 << (pinpos * 2));
        tmpreg |= ((u32)(GPIO_Speed) << (pinpos * 2));
        GPIOx->OSPEEDR = tmpreg;

        // Use temporary variable to update OTYPER register configuration, to avoid 
        // unexpected transition in the GPIO pin configuration.
        tmpreg = GPIOx->OTYPER;
        tmpreg &= ~((GPIO_OTYPER_OT_0) << ((u16)pinpos));
        tmpreg |= (u16)(((u16)GPIO_OType) << ((u16)pinpos));
        GPIOx->OTYPER = tmpreg;
      }

      // Use temporary variable to update PUPDR register configuration, to avoid 
      // unexpected transition in the GPIO pin configuration.
      tmpreg = GPIOx->PUPDR;
      tmpreg &= ~(GPIO_PUPDR_PUPDR0 << ((u16)pinpos * 2));
      tmpreg |= (((u32)GPIO_PuPd) << (pinpos * 2));
      GPIOx->PUPDR = tmpreg;
#endif
      return GPIO_Mode;
}



void hdGPIO_Setup(GPIO_TypeDef* GPIOx, u8 pin, u16 mode, u8 def)
{
      hdGPIO_Active(GPIOx);
      if ( (hdGPIO_Init(GPIOx, pin, mode)==GPIO_Mode_OUT) || (def & 2) )
      {
        GPIO_PortWrite(GPIOx, pin, (def&1)?1:0);
      }
  
}



