//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __HARDWARE_H
#define __HARDWARE_H


#include "SysType.h"
#include "hdtimers.h"
#include "hdports.h"
//#include "hdspi.h"
//#include "hdfsmc.h"
/////////////////////////////////////////////////////////////////////////////
// Sys Define
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
// Hard Ver 1
/////////////////////////////////////////////////////////////////////////////

#define SWOinputMode    1   // 0-PushPull, 1-OpenDrainPullUp, 2-InputPullUp
//MODE = 1
//OT = 1
//PUPDR = 1
#if SWOinputMode==0
  hdPin_O_DefineSetup(SWO,            B,  3, hd_gptp_OUT_PP,     1);
  #define SWO(_v)                     dH_PORT_Write(SWO,_v)
#elif SWOinputMode==1
  hdPin_O_DefineSetup(SWO,            B,  3, hd_gptp_OUT_PPU,     1);
  #define SWO(_v)                     dH_PORT_WritV(SWO,_v)
#else  
  hdPin_O_DefineSetup(SWO,            B,  3, hd_gptp_IN_PPU,     1);
  #define SWO(_v)                     dH_PORT_Write(SWO,_v)
#endif
  #define SWO_OFF()                   SWO(0)
  #define SWO_ON()                    SWO(1)
  #define SWO_GET()                   dH_PORTvRead(SWO)

///  hdPin_O_DefineSetup(AY_BOOT,        A,  2, hd_gptp_IN_OD,     0);
///  #define AY_RESET()                  dH_PORTvRead(AY_RESET)

//  hdPin_O_DefineSetup(TIM1CH2,        A,  9, hd_gptp_AF_PP,     1);
//  #define TIM1CH2()                   dH_PORT_Read(TIM1CH2)
  //hdPin_O_DefineSetup(TIM1CH3,        A, 10, hd_gptp_AF_PP,     1);
//  hdPin_O_DefineSetup(DACTEST,        A, 10, hd_gptp_OUT_PP,     1);
//  #define DACTEST(_v)                 dH_PORT_Write(DACTEST,_v)

/////////////////////////////////////////////////////////////////////////////

  hdPin_O_DefineSetup(USARTZXUNO_TX,      A,  9, hd_gptp_OUT_PP,     1);
  #define USARTZXUNO_TX(_v)               dH_PORT_Write(USARTZXUNO_TX,_v)
  hdPin_O_DefineSetup(USARTZXUNO_RX,      A, 10, hd_gptp_IN_OD,      1);
  #define USARTZXUNO_RX()                 dH_PORTvRead(USARTZXUNO_RX)
  
/////////////////////////////////////////////////////////////////////////////

  hdPin_O_DefineSetup(BURYAK_AY_TX,       C,  2, hd_gptp_OUT_PP,     1);
  #define BURYAK_AY_TX(_v)                dH_PORT_WritV(BURYAK_AY_TX,_v)
  hdPin_O_DefineSetup(BURYAK_AY_RX,       C,  7, hd_gptp_IN_OD,      1);
  #define BURYAK_AY_RX()                  dH_PORTvRead(BURYAK_AY_RX)
  hdPin_O_DefineSetup(BURYAK_AY_CTS,      C,  3, hd_gptp_OUT_PP,     1);
  #define BURYAK_AY_CTS(_v)               dH_PORT_WritV(BURYAK_AY_CTS,_v)

/////////////////////////////////////////////////////////////////////////////

#define IOASTART        0xF0
#define hdPinAYIOA(_p, _s)   hdPin_O_DefineSetup(AYPIOA##_p,            C,  _p, hd_gptp_OUT_PPU,     _s)
  hdPinAYIOA(0, (IOASTART>>0)&1);
  hdPinAYIOA(1, (IOASTART>>1)&1);
  hdPinAYIOA(2, (IOASTART>>2)&1);
  hdPinAYIOA(3, (IOASTART>>3)&1);
  hdPinAYIOA(4, (IOASTART>>4)&1);
  hdPinAYIOA(5, (IOASTART>>5)&1);
  hdPinAYIOA(6, (IOASTART>>6)&1);
  hdPinAYIOA(7, (IOASTART>>7)&1);
  #define hdPinAYIOA_Read()           ((u8)(dH_PORT_ReadP(AYPIOA0)))
  #define hdPinAYIOA_Write(_v)         dH_PORT_WriteM(AYPIOA0,_v,0xFF)

/////////////////////////////////////////////////////////////////////////////
  hdPin_O_DefineSetup(DAC1,           A,  4, hd_gptp_AN_OD,     1);
  hdPin_O_DefineSetup(DAC2,           A,  5, hd_gptp_AN_OD,     1);
/////////////////////////////////////////////////////////////////////////////
// Robus Config For Latches ...
  hdPin_O_DefineSetup(BOOT1CFG,       B,  2, hd_gptp_IN_PPU,    0);
  #define BOOT1CFG()                  dH_PORT_Read(BOOT1CFG)
  
  hdPin_O_DefineSetup(LASPI_CLK,      C, 10, hd_gptp_OUT_PP,     1);
  #define LASPI_CLK(_v)               dH_PORT_WritV(LASPI_CLK,_v)
  hdPin_O_DefineSetup(LASPI_MOSI,     C, 12, hd_gptp_OUT_PP,     1);
  #define LASPI_MOSI(_v)              dH_PORT_WritV(LASPI_MOSI,_v)
  hdPin_O_DefineSetup(LASPI_NSS,      A, 15, hd_gptp_OUT_PP,     1);
  #define LASPI_NSS(_v)               dH_PORT_WritV(LASPI_NSS,_v)

  hdPin_O_DefineSetup(SPI3_CLK,       C, 10, hd_gptp_AF_PP,      1);
//  #define SPI3_CLK(_v)                dH_PORT_WritV(SPI3_CLK,_v)
  hdPin_O_DefineSetup(SPI3_MISO,      C, 11, hd_gptp_AF_OD,      1);
//  #define SPI3_MISO(_v)               dH_PORT_WritV(SPI3_MISO,_v)
  hdPin_O_DefineSetup(SPI3_MOSI,      C, 12, hd_gptp_AF_PP,      1);
//  #define SPI3_MOSI(_v)               dH_PORT_WritV(SPI3_MOSI,_v)
  hdPin_O_DefineSetup(SPI3_NSS,       A, 15, hd_gptp_AF_PP,      1);
//  #define SPI3_NSS(_v)                dH_PORT_WritV(SPI3_NSS,_v)

/////////////////////////////////////////////////////////////////////////////

  hdPin_O_DefineSetup(AY_BDIR,        B,  0, hd_gptp_IN_OD,     0);
  #define AY_BDIR()                   dH_PORT_Read(AY_BDIR)
  hdPin_O_DefineSetup(AY_BC1,         B,  1, hd_gptp_IN_OD,     0);
  #define AY_BC1()                    dH_PORT_Read(AY_BC1)

  #define PRTB_DIR                    hd_gptp_IN_PPU
  #define PRTB_DIRp                   hd_gptp_IN_OD   //hd_gptp_IN_PPD //hd_gptp_OUT_OD

  hdPin_O_DefineSetup(AY_RESET,       A,  2, hd_gptp_IN_OD,     0);
  #define AY_RESET()                  dH_PORTvRead(AY_RESET)


//  hdPin_O_DefineSetup(PRTB0,          B,  0, PRTB_DIR,     0);
//  hdPin_O_DefineSetup(PRTB1,          B,  1, PRTB_DIR,     0);
  hdPin_O_DefineSetup(PRTB2,          B,  2, PRTB_DIR,     0);
  hdPin_O_DefineSetup(PRTB4,          B,  4, PRTB_DIR,     0);
  hdPin_O_DefineSetup(PRTB5,          B,  5, PRTB_DIR,     0);
  hdPin_O_DefineSetup(PRTB6,          B,  6, PRTB_DIR,     0);
  hdPin_O_DefineSetup(PRTB7,          B,  7, PRTB_DIR,     0);
  hdPin_O_DefineSetup(PRTB8,          B,  8, PRTB_DIRp,    3);
  hdPin_O_DefineSetup(PRTB9,          B,  9, PRTB_DIRp,    3);
  hdPin_O_DefineSetup(PRTB10,         B, 10, PRTB_DIRp,    3);
  hdPin_O_DefineSetup(PRTB11,         B, 11, PRTB_DIRp,    3);
  hdPin_O_DefineSetup(PRTB12,         B, 12, PRTB_DIRp,    3);
  hdPin_O_DefineSetup(PRTB13,         B, 13, PRTB_DIRp,    3);
  hdPin_O_DefineSetup(PRTB14,         B, 14, PRTB_DIRp,    3);
  hdPin_O_DefineSetup(PRTB15,         B, 15, PRTB_DIRp,    3);




/////////////////////////////////////////////////////////////////////////////
// Extern Procedures
/////////////////////////////////////////////////////////////////////////////

extern u8 isRbousCFG;
extern u16 SPI3DMAbufferTx[1];
extern u16 SPI3DMAbufferRx[1];

extern void Init(void);




#endif
