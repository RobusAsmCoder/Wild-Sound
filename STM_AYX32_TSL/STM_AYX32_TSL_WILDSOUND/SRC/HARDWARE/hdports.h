//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __HDPORTS_H
#define __HDPORTS_H

#include "SysType.h"


#define isDefinedSTM32FXX    ( defined (STM32F10X_LD)       ||  \
                               defined (STM32F10X_LD_VL)    ||  \
                               defined (STM32F10X_MD)       ||  \
                               defined (STM32F10X_MD_VL)    ||  \
                               defined (STM32F10X_HD)       ||  \
                               defined (STM32F10X_HD_VL)    ||  \
                               defined (STM32F10X_XL)       ||  \
                               defined (STM32F10X_CL) )

#define isDefinedSTM32LXX    ( defined (STM32L1XX_MD)       ||  \
                               defined (STM32L1XX_MDP)      ||  \
                               defined (STM32L1XX_HD)       ||  \
                               defined (STM32L1XX_XL) )

#if isDefinedSTM32FXX
 #include "stm32f10x_rcc.h"
 #include "stm32f10x_gpio.h"
#eif isDefinedSTM32LXX
 #include "stm32l1xx_rcc.h"
 #include "stm32l1xx_gpio.h"
#else 
 #include "stm32f4xx_rcc.h"
 #include "stm32f4xx_gpio.h"
#endif


#define dH_BITV(_p_, _v_)     ((u32)(_v_)<<(_p_))
#define dH_BIT(_p_)           dH_BITV((_p_), 1)
#define dH_PORT_BSSR(_p_, _v_)  dH_BITV(_p_, _v_) | dH_BIT((_p_) | 16)
#define dH_PORT_BSSRM(_p_, _v_, _m_)  dH_BITV(_p_, _v_) | ((u32)((_m_)<<(16+(_p_))))

#define dH_PORT_BSSR_R(_p_)  dH_BIT((_p_) | 16)
#define dH_PORT_BSSR_S(_p_)  dH_BIT((_p_))
#define dH_PORT_CFG_MD(_name_, _p_, _v_)  _name_ = (_name_ & (~( 0xF<<(4*(_p_) ))) ) | ((u32)(_v_)<<(4*(_p_)))

#define dH_BIT4V(_p_,_v_)           (((_p_)&0xFFFFFFF8UL)==0 ? (dH_BITV(((_p_)*4), (_v_))) : (0x0UL))
#define dH_BIT4v1(_p_,_d_,_b_,_v_)  dH_BIT4V( ((_p_)+(_b_)), ((((_d_)>>(_b_))&1)==0 ? 0UL : _v_) )
#define dH_BIT4v2(_p_,_d_,_b_,_v_)  dH_BIT4v1((_p_),(_d_),(_b_)+ 0,_v_) | dH_BIT4v1((_p_),(_d_),(_b_)+ 1,_v_)
#define dH_BIT4v4(_p_,_d_,_b_,_v_)  dH_BIT4v2((_p_),(_d_),(_b_)+ 0,_v_) | dH_BIT4v2((_p_),(_d_),(_b_)+ 2,_v_)
#define dH_BIT4v8(_p_,_d_,_b_,_v_)  dH_BIT4v4((_p_),(_d_),(_b_)+ 0,_v_) | dH_BIT4v4((_p_),(_d_),(_b_)+ 4,_v_)
#define dH_BIT4v8L(_p_,_d_,_b_,_v_) dH_BIT4v8( (_p_)   ,(_d_), (_b_)   ,_v_)
#define dH_BIT4v8H(_p_,_d_,_b_,_v_) dH_BIT4v8(((_p_)-8),(_d_),((_b_)+8),_v_)

#define dH_BIT4m8(_p_,_d_,_b_)      dH_BIT4v8((_p_),(_d_),(_b_),0xFUL)
#define dH_BIT4m8L(_p_,_d_,_b_)     dH_BIT4v8L((_p_),(_d_),(_b_),0xFUL)
#define dH_BIT4m8H(_p_,_d_,_b_)     dH_BIT4v8H((_p_),(_d_),(_b_),0xFUL)


#define hdPin_O_DefineSetup(_name, _port, _pin, _mode, _def)                                                                                                  \
hdPin_Define(_name, _port, _pin, _mode);                                                                                                                      \
static __forceinline void GpioInit_##_name(void)    { hdGPIO_Setup((GPIO_TypeDef *)_name##wp_port, _name##wp_pin, _name##wp_mode, _def); }                    \
static __forceinline void GpioAFCF_##_name(u8 val)  { GPIO_PinAFConfig((GPIO_TypeDef *)_name##wp_port, GPIO_PinSource##_pin, val); }                          \

#define hdPin_A_DefineSetup(_name, _port, _pin, _mode, _modeD, _def, _mask)                                                                                   \
hdPinsDefine(_name, _port, _pin, _mask, _mode, _modeD);                                                                                                       \
static __forceinline void GpioInit_##_name(void)    { hdGPIO_Setup((GPIO_TypeDef *)_name##wp_port, _name##wp_pin, _name##wp_mode, _def); }                    \

#define hdPin_Define(_name, _port, _pin, _mode)                                                                                             \
enum { _name##wp_port         = (u32)(GPIO##_port)        ,                                                                                 \
       _name##wp_pin          = (u32)(_pin)               ,                                                                                 \
       _name##wp_bit          = (s32)(dH_BIT(_pin))       ,                                                                                 \
       _name##wp_mode         = (u16)(_mode)              ,                                                                                 \
}

#define hdPinsDefine(_name, _port, _pin, _mask, _init, _deinit)                                                                             \
enum { _name##wp_port         = (u32)(GPIO##_port)        ,                                                                                 \
       _name##wp_pin          = (u32)(_pin)               ,                                                                                 \
       _name##wp_bit8mL       = (s32)(dH_BIT4m8L(_pin, _mask, 0)) ,                                                                         \
       _name##wp_bit8mH       = (s32)(dH_BIT4m8H(_pin, _mask, 0)) ,                                                                         \
       _name##wp_bit8eL       = (s32)(dH_BIT4v8L(_pin, _mask, 0, _init)) ,                                                                  \
       _name##wp_bit8eH       = (s32)(dH_BIT4v8H(_pin, _mask, 0, _init)) ,                                                                  \
       _name##wp_bit8dL       = (s32)(dH_BIT4v8L(_pin, _mask, 0, _deinit)) ,                                                                \
       _name##wp_bit8dH       = (s32)(dH_BIT4v8H(_pin, _mask, 0, _deinit)) ,                                                                \
       _name##wp_bits         = (s32)(dH_BITV(_pin, _mask)),                                                                                \
       _name##wp_mask         = (s32)(_mask)                                                                                                \
}


#if isDefinedSTM32FXX
  #define GPIO_Port(_port)                  uu32(((GPIO_TypeDef *)(void *)_port)->BSRR)
  #define GPIO_PortWritV(_port,_pin,_v)    vuu32(((GPIO_TypeDef *)(void *)_port)->BSRR) = dH_PORT_BSSR((_pin),(_v))
#else
  #define GPIO_Port(_port)                  uu32(((GPIO_TypeDef *)(void *)_port)->BSRRL)
  #define GPIO_PortWritV(_port,_pin,_v)    vuu32(((GPIO_TypeDef *)(void *)_port)->BSRRL) = dH_PORT_BSSR((_pin),(_v))
#endif  

#define GPIO_PortWriteM(_port,_pin,_v,_m_) GPIO_Port(_port) = dH_PORT_BSSRM((_pin),(_v),(_m_))
#define GPIO_PortWrite(_port,_pin,_v)      GPIO_Port(_port) = dH_PORT_BSSR((_pin),(_v))
#define dH_PORT_WritV(_name,_v)            GPIO_PortWritV(_name##wp_port, (_name##wp_pin), (_v))
#define dH_PORT_Write(_name,_v)            GPIO_PortWrite(_name##wp_port, (_name##wp_pin), (_v))
#define dH_PORT_WriteM(_name,_v,_m)        GPIO_PortWriteM(_name##wp_port, (_name##wp_pin), (_v), (_m))

#define GPIO_PortReadP(_port)             (uu16(((GPIO_TypeDef *)(void *)_port)->IDR))
#define GPIO_PortRead(_port,_pin)         ((GPIO_PortReadP(_port)>>(_pin))&1)//((uu16(((GPIO_TypeDef *)(void *)_port)->IDR)>>(_pin))&1)
#define dH_PORT_Read(_name)               GPIO_PortRead(_name##wp_port, (_name##wp_pin))
#define dH_PORT_ReadP(_name)              GPIO_PortReadP(_name##wp_port)

//#define GPIOvPortRead(_port,_pin)         ((GPIO_TypeDef *)(void *)_port)->IDR  
#define GPIOvPortRead(_port,_pin)         ((vuu16(((GPIO_TypeDef *)(void *)_port)->IDR)>>(_pin))&1)
#define dH_PORTvRead(_name)               GPIOvPortRead(_name##wp_port, (_name##wp_pin))

#define dHmPRTN(_n, _o, _v)       dHmPRT_##_n = (u16)((u16)(_v))<<((_o)*4)
#define dHmPRT(_o, _v)            dHmPRTN(_v, _o, _v)

#if isDefinedSTM32FXX
  enum{

    
    GPIO_OType_PP     = 0,
    GPIO_OType_OD     = 1,
    
    GPIO_Mode_AN      = 0,
    GPIO_Mode_IN      = 2,
    GPIO_Mode_OUT     = 0,
    GPIO_Mode_AF      = 2,
    
    GPIO_PuPd_NOPULL  = 0,
    GPIO_PuPd_UP      = 3,
    GPIO_PuPd_DOWN    = 2,

    dHmPRT(0, GPIO_Mode_IN),
    dHmPRT(0, GPIO_Mode_OUT),     //+speed mhz
    dHmPRT(0, GPIO_Mode_AF),      //+speed mhz
    dHmPRT(0, GPIO_Mode_AN),
  //CNF0
    dHmPRT(0, GPIO_OType_PP),
    dHmPRT(0, GPIO_OType_OD),
    
    dHmPRT(1, GPIO_Speed_2MHz),
    dHmPRT(1, GPIO_Speed_10MHz),
    dHmPRT(1, GPIO_Speed_50MHz),
    
    dHmPRT(2, GPIO_PuPd_NOPULL),
    dHmPRT(2, GPIO_PuPd_UP),
    dHmPRT(2, GPIO_PuPd_DOWN),
  };
  enum {
    hd_gptp_IN_OD     = dHmPRT_GPIO_Mode_AN  | dHmPRT_GPIO_OType_OD | dHmPRT_GPIO_PuPd_NOPULL                               ,
    hd_gptp_IN_PPU    = dHmPRT_GPIO_Mode_IN  | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_UP                                   ,
    hd_gptp_IN_PPD    = dHmPRT_GPIO_Mode_IN  | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_DOWN                                 ,
    hd_gptp_OUT_OD    = dHmPRT_GPIO_Mode_OUT | dHmPRT_GPIO_OType_OD | dHmPRT_GPIO_PuPd_NOPULL   | dHmPRT_GPIO_Speed_50MHz   ,
    hd_gptp_OUT_PP    = dHmPRT_GPIO_Mode_OUT | dHmPRT_GPIO_OType_PP                             | dHmPRT_GPIO_Speed_50MHz   ,
    hd_gptp_OUT_PPU   = dHmPRT_GPIO_Mode_OUT | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_UP       | dHmPRT_GPIO_Speed_50MHz   ,
    hd_gptp_OUT_PPD   = dHmPRT_GPIO_Mode_OUT | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_DOWN     | dHmPRT_GPIO_Speed_50MHz   ,
    hd_gptp_AF_OD     = dHmPRT_GPIO_Mode_AF  | dHmPRT_GPIO_OType_OD | dHmPRT_GPIO_PuPd_NOPULL   | dHmPRT_GPIO_Speed_50MHz   ,
    hd_gptp_AF_PPU    = dHmPRT_GPIO_Mode_AF  | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_UP       | dHmPRT_GPIO_Speed_50MHz   ,
    hd_gptp_AF_PPD    = dHmPRT_GPIO_Mode_AF  | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_DOWN     | dHmPRT_GPIO_Speed_50MHz   ,
    hd_gptp_FFFFFFFF  = (u16)0xFFFF,
  };
#eif isDefinedSTM32LXX
  enum{
    dHmPRT(0, GPIO_Mode_IN),
    dHmPRT(0, GPIO_Mode_OUT),
    dHmPRT(0, GPIO_Mode_AF),
    dHmPRT(0, GPIO_Mode_AN),

    dHmPRT(1, GPIO_OType_PP),
    dHmPRT(1, GPIO_OType_OD),

    dHmPRT(2, GPIO_Speed_400KHz),
    dHmPRT(2, GPIO_Speed_2MHz),
    dHmPRT(2, GPIO_Speed_10MHz),
    dHmPRT(2, GPIO_Speed_40MHz),

    dHmPRT(3, GPIO_PuPd_NOPULL),
    dHmPRT(3, GPIO_PuPd_UP),
    dHmPRT(3, GPIO_PuPd_DOWN),
  };
  enum {
    hd_gptp_IN_OD     = dHmPRT_GPIO_Mode_IN  | dHmPRT_GPIO_OType_OD | dHmPRT_GPIO_PuPd_NOPULL                               ,
    hd_gptp_IN_PPU    = dHmPRT_GPIO_Mode_IN  | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_UP                                   ,
    hd_gptp_IN_PPD    = dHmPRT_GPIO_Mode_IN  | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_DOWN                                 ,
    hd_gptp_OUT_OD    = dHmPRT_GPIO_Mode_OUT | dHmPRT_GPIO_OType_OD | dHmPRT_GPIO_PuPd_NOPULL                               ,
    hd_gptp_OUT_PP    = dHmPRT_GPIO_Mode_OUT | dHmPRT_GPIO_OType_PP                             | dHmPRT_GPIO_Speed_40MHz   ,
    hd_gptp_OUT_PPU   = dHmPRT_GPIO_Mode_OUT | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_UP                                   ,
    hd_gptp_OUT_PPD   = dHmPRT_GPIO_Mode_OUT | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_DOWN                                 ,
    hd_gptp_AF_OD     = dHmPRT_GPIO_Mode_AF  | dHmPRT_GPIO_OType_OD | dHmPRT_GPIO_PuPd_NOPULL   | dHmPRT_GPIO_Speed_40MHz   ,
    hd_gptp_AF_PPU    = dHmPRT_GPIO_Mode_AF  | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_UP       | dHmPRT_GPIO_Speed_40MHz   ,
    hd_gptp_AF_PPD    = dHmPRT_GPIO_Mode_AF  | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_DOWN     | dHmPRT_GPIO_Speed_40MHz   ,
    hd_gptp_FFFFFFFF  = (u16)0xFFFF,
  };
#else
  enum{
    dHmPRT(0, GPIO_Mode_IN),
    dHmPRT(0, GPIO_Mode_OUT),
    dHmPRT(0, GPIO_Mode_AF),
    dHmPRT(0, GPIO_Mode_AN),

    dHmPRT(1, GPIO_OType_PP),
    dHmPRT(1, GPIO_OType_OD),

    dHmPRT(2, GPIO_Speed_2MHz),
    dHmPRT(2, GPIO_Speed_25MHz),
    dHmPRT(2, GPIO_Speed_50MHz),
    dHmPRT(2, GPIO_Speed_100MHz),

    dHmPRT(3, GPIO_PuPd_NOPULL),
    dHmPRT(3, GPIO_PuPd_UP),
    dHmPRT(3, GPIO_PuPd_DOWN),
  };
  enum {
    hd_gptp_IN_OD     = dHmPRT_GPIO_Mode_IN  | dHmPRT_GPIO_OType_OD | dHmPRT_GPIO_PuPd_NOPULL                               ,
    hd_gptp_IN_PPU    = dHmPRT_GPIO_Mode_IN  | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_UP                                   ,
    hd_gptp_IN_PPD    = dHmPRT_GPIO_Mode_IN  | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_DOWN                                 ,
    hd_gptp_OUT_OD    = dHmPRT_GPIO_Mode_OUT | dHmPRT_GPIO_OType_OD | dHmPRT_GPIO_PuPd_NOPULL                               ,
    hd_gptp_OUT_PP    = dHmPRT_GPIO_Mode_OUT | dHmPRT_GPIO_OType_PP                             | dHmPRT_GPIO_Speed_100MHz  ,
    hd_gptp_OUT_PPU   = dHmPRT_GPIO_Mode_OUT | dHmPRT_GPIO_OType_OD | dHmPRT_GPIO_PuPd_UP                                   ,
    hd_gptp_OUT_PPD   = dHmPRT_GPIO_Mode_OUT | dHmPRT_GPIO_OType_OD | dHmPRT_GPIO_PuPd_DOWN                                 ,
    hd_gptp_AF_OD     = dHmPRT_GPIO_Mode_AF  | dHmPRT_GPIO_OType_OD | dHmPRT_GPIO_PuPd_NOPULL   | dHmPRT_GPIO_Speed_100MHz  ,
    hd_gptp_AF_PP     = dHmPRT_GPIO_Mode_AF  | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_NOPULL   | dHmPRT_GPIO_Speed_100MHz  ,
    hd_gptp_AF_PPU    = dHmPRT_GPIO_Mode_AF  | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_UP       | dHmPRT_GPIO_Speed_100MHz  ,
    hd_gptp_AF_PPD    = dHmPRT_GPIO_Mode_AF  | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_DOWN     | dHmPRT_GPIO_Speed_100MHz  ,
    hd_gptp_AN_OD     = dHmPRT_GPIO_Mode_AN  | dHmPRT_GPIO_OType_PP | dHmPRT_GPIO_PuPd_NOPULL   | dHmPRT_GPIO_Speed_100MHz  ,
    hd_gptp_FFFFFFFF  = (u16)0xFFFF,
 };
#endif


//////////////////////////////////////////////////////////////////////
extern void hdGPIO_Setup(GPIO_TypeDef* GPIOx, u8 pin, u16 mode, u8 def);
//////////////////////////////////////////////////////////////////////


#endif
