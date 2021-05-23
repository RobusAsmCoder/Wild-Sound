//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __CHIPAY_WILDSOUND_H
#define __CHIPAY_WILDSOUND_H

#include "SysType.h"

//#define AyFreqCLK         ((u32)(1750000))      //HZ clocking for AY chip
#define AyFreqCLK         ((u32)(1774400))      //HZ clocking for AY chip
#define AyFreqSND         ((u32)(AyFreqCLK/32))        //HZ frquency for DAC
#define AyFreqRealTiks    ((u32)(AyFreqCLK/16) / (u32)(AyFreqSND))

#define AyFreq            ((u32)(AyFreqCLK/1))  //HZ real clock for AY div 8

#pragma push
#pragma pack(1)


typedef struct {
  u8   TA:1;
  u8   TB:1;
  u8   TC:1;
  u8   NA:1;
  u8   NB:1;
  u8   NC:1;
  u8  FRE:2;
}tStructMIXER;

typedef struct {
            u32 R4;
            u32 R5;
            u32 R6;
            u32 R7;
            u32 R8;
            u32 R9;
            u32 R10;
            u32 R11;
            u32 R12;
            u32 R13;
            u32 R14;
            u32 R15;
}tAY_ARM_REG;

typedef struct {
          u16 TONE[3];        //Tone A,B,C [0..4095]
           u8 NOISE;          //Noise Value [0..31]
 tStructMIXER MIXER;          //Mixer BIT(00NNNTTT)
           u8 VOL[3];         //Vol A,B,C
          u16 ENV;            //Enveloupment Value
           u8 ENVEFF;         //Enveloupment Effect
           u8 IO[2];          //Bidirectional Data X,Y
  
          u16 PHASE[3];       //Phase A,B,C [0..4095]
           u8  :8;
           u8  :8;
           u8 PWM[3];
          u16  :16;
           u8 ENVFLG;
           u8  :8;
           u8  :8;
  
  tAY_ARM_REG ARM;            //ADDRES MUST BE ALIGNED BY 4 !!!
}tStructAY;


typedef union {
      tStructAY   ST;
             u8   R[64];
}tRegAY;

typedef struct {
        u8  R000_127[128];
}tStructWS;


typedef union {
      tStructWS   ST;
             u8   R[256];     //Update Data Reg From #64
}tRegWS;

typedef struct {
  u8  L:4;
  u8  H:4;
}tStructHL;

typedef union {
      tStructHL   ad;
             u8   adHL;
}tAdrHL;

#pragma push
#pragma pack(4)
typedef struct {
 tRegAY REG;
    u32 Freq;
    u16 adr;
}tChipAY;
#pragma pop

enum {
  work_hrdEmul_mode_AY_HARDWARE_TIMER   = 0,
  work_hrdEmul_mode_AY_SOFT             = 1,
  work_hrdEmul_mode_AY_SOFTODD          = 2,
  work_hrdEmul_mode_AY_DIGITAL          = 3,
};

typedef struct{
  u16      bus;       //Bus in latch (GPIOB)
  u16      dta;       //Bus out data
  u16      ayn;       //Selected AY
  tChipAY  ay[4];     //AY Chips Regs
  tRegWS   ws;        //Wild Sound Regs
  u8       WORK_LOCK_BIT;
  u8       WORK_CMD;
  u8       WORK_STATUS;
  u8       WORK_ERROR;
  u16      WORK_MODE;
//  u16      WORK_MODEO;
  u16      WORK_POS;
  u16      WORK_FW_SIZE;
  u16      WORK_TRANS_TYPE;
  u8       WORK_DATA[32];
  u16      WORK_EMUL_HARDMD;
//  u16      WORK_EMUL_ODD;
//  u16      WORK_03;
} tAY_Struct ;

enum {
    TRANS_MODE_USART_DO_MODE          = (0x0<<4),
    TRANS_MODE_USART_DO_ZXUNO         = (0x1<<4),
    TRANS_MODE_USART_DO_IOA           = (0x2<<4),
    TRANS_MODE_USART_MASK             = 0xF0,
    TRANS_MODE_USART_READY            = 0x8000,
    TRANS_MODE_USART_SET_115200       = 0 | TRANS_MODE_USART_DO_MODE,
    TRANS_MODE_USART_SET_57600        = 1 | TRANS_MODE_USART_DO_MODE,
    TRANS_MODE_USART_SET_38400        = 2 | TRANS_MODE_USART_DO_MODE,
    TRANS_MODE_USART_SET_19200        = 3 | TRANS_MODE_USART_DO_MODE,
    TRANS_MODE_USART_SET_14400        = 4 | TRANS_MODE_USART_DO_MODE,
    TRANS_MODE_USART_SET_9600         = 5 | TRANS_MODE_USART_DO_MODE,
    TRANS_MODE_USART_SET_4800         = 6 | TRANS_MODE_USART_DO_MODE,
    TRANS_MODE_USART_SET_ZXUNO        = 0 | TRANS_MODE_USART_DO_ZXUNO,
    TRANS_MODE_USART_SET_ZXBURYAK     = 1 | TRANS_MODE_USART_DO_ZXUNO,
    TRANS_MODE_USART_SET_ZXIOA        = 0 | TRANS_MODE_USART_DO_IOA,
};
#pragma pop


extern const u8 EnvRndTAB[768];

#define extVolTblGenerator(_cn)          \
extern const s16 VolTB##_cn[16];
extVolTblGenerator(AL);
extVolTblGenerator(AR);
extVolTblGenerator(BL);
extVolTblGenerator(BR);
extVolTblGenerator(CL);
extVolTblGenerator(CR);


extern tAY_Struct ayStr;
extern volatile tAdrHL ad;

extern void ChipAY_Init(tChipAY *AY);
extern u32 ChipAY_Mixer(tAY_Struct *ays);


#endif
