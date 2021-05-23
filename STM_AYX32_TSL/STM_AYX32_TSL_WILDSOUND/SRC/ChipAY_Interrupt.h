//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __CHIPAY_INTERRUPT_H
#define __CHIPAY_INTERRUPT_H


#include "SysType.h"
#include "hardware.h"





//T3CH3   T3CH4
//PB0     PB1
//BDIR    BC1
// 0       0    - Z
// 0       1    - Read from ME
// 1       0    - Write to ME data
// 1       1    - Write to ME addr
enum {
  BDIRBC_mask       = (s32)(AY_BDIRwp_bit | AY_BC1wp_bit),
  BDIRBC_TRISTATE   = (s32)(0             | 0           ),
  BDIRBC_READ       = (s32)(0             | AY_BC1wp_bit),
  BDIRBC_WRITE_DATA = (s32)(AY_BDIRwp_bit | 0           ),
  BDIRBC_WRITE_ADDR = (s32)(AY_BDIRwp_bit | AY_BC1wp_bit),
};

enum {
  TSL_AYX32_C_BREAK     = 0x00,
  TSL_AYX32_C_LOCK      = 0xE4,
  TSL_AYX32_C_UP_FW     = 0xE8,
  TSL_AYX32_C_FLASH_FW  = 0xE9,
  TSL_AYX32_C_SAVE_CFG  = 0xEA,
  TSL_AYX32_C_RESET     = 0xEB,
};

enum {
  TSL_AYX32_S_BUSY = 0x01,
  TSL_AYX32_S_DRQ  = 0x02,
  TSL_AYX32_S_BOOT = 0x80,
};

enum {
  TSL_AYX32_E_NONE    = 0x00,
  TSL_AYX32_E_DONE    = 0x01,
  TSL_AYX32_E_BREAK   = 0x02,
  TSL_AYX32_E_BUSY    = 0x03,
  TSL_AYX32_E_CMDERR  = 0x04,
  TSL_AYX32_E_MODERR  = 0x05,
  TSL_AYX32_E_PARMERR = 0x06,
  TSL_AYX32_E_DATAERR = 0x07,
  TSL_AYX32_E_SEQERR  = 0x08,
  TSL_AYX32_E_EXECERR = 0x09,
  TSL_AYX32_E_DOFLASH = 0xAA,
};

#define fwCCRMAM_ADDR   0x10000000

#define UNO_RSBIT_TX    3     //IOA3
#define UNO_RSBIT_RX    7     //IOA7

#define BUR_RSBIT_TX    3     //IOA3
#define BUR_RSBIT_RX    7     //IOA7
#define BUR_RSBIT_CTS   2     //IOA2

enum {
  IOIntPool_OFF       = 0,
  IOIntPool_PA10         ,
  IOIntPool_PC7          ,
};

//extern const u32 outDataForTslPort[256];

#define LSysTickStop()   SysTick->CTRL  =   SysTick_CTRL_CLKSOURCE_Msk |    \
                                            SysTick_CTRL_TICKINT_Msk   //|  \
//                                            SysTick_CTRL_ENABLE_Msk
#define LSysTickStart()  SysTick->CTRL  =   SysTick_CTRL_CLKSOURCE_Msk |    \
                                            SysTick_CTRL_TICKINT_Msk   |    \
                                            SysTick_CTRL_ENABLE_Msk

typedef void (*tVoidProc)(void);

extern const tVoidProc tbl_AYREGPER_proc[64];

#define EXT_DoAyReneratorUpdate(ayn, adL)     tbl_AYREGPER_proc[((adL) | ((ayn)<<5)) & 0x3F]()
//extern void EXT_DoAyReneratorUpdate(u8 ayn, u8 adL);

extern u64 WildDateVerToFirmVerConverter(void);

extern void prcAYRprcR0E(void);
extern void EXT_DoAyBusUpdate(void);
extern void chipAY_IOConfig(u8 mode);
extern void chipAY_InterruptConfig(void);



#endif
