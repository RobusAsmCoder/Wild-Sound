//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __CHIPAY_DIGITALSAMPLE_H
#define __CHIPAY_DIGITALSAMPLE_H

#include "SysType.h"

#define chypAySampleZerroBuffer     8


/*
typedef struct {
  u32 mOfs;
  u8  mDesc;     //Secriptor Of Memory Allocator
}t_cDigSmpRec;

typedef struct {
  t_cDigSmpRec rec[8];
}t_cDigPlaySample;
*/

#pragma push
#pragma pack(1)

typedef struct {
  u32     OFS;      //Offset Data For Loading
  u16     DES;      //Decriptor Of Allocated Memory
  u8     *SMPDATA;
  u16     ID16;       //Special ID for Understand data in flash
  u32     ID32;       //Special ID for Understand data in flash
}tInstrumentInfo;

typedef struct {
   tInstrumentInfo       *InsInfo;  //u32            DESOFS;    //u32            OFS;        //u8            *DTA;   //OFS;
   u32                    Length;
   u32                    Loop;
   u32                    LoopEnd;
   u8                     Volume;
   s8                     FineTune;
   u8                     SType;
   u8                     Panning;
   s8                     RelativeNote;
}tInstrumentRec;


typedef union {
  u8  aru8[4];
  u16 aru16[2];
  u32 v;
}tU8U16U32;

typedef union {
  u8  aru8[8];
  u16 aru16[4];
  u32 aru32[2];
  u64 v;
}tU8U16U32U64;

typedef union {
  u8  aru8[8];
  u16 aru16[4];
  u32 aru32[2];
  u64 v;
}tS8S16S32S64;

#pragma pop

//Instrument structure for Player
typedef struct {
   u32                  freq;     //Frequency mulled by 0x00000100
   tS8S16S32S64         step64;   //Step addition sample mulled by 0x0000000100000000   
   tU8U16U32U64         pos64;    //Position in sample  mulled by 0x0000000100000000
   tInstrumentRec      *InsRec;   //Pointer For Work Instrument
   u8                   FinalVol_L;
   u8                   FinalVol_R;
}tInstrumentFreqency;

extern u32 cayDigSmpAllocateInstrument(tInstrumentRec *InsRec);
extern void cayDigSmpInstrumentAddByte(tInstrumentRec *InsRec, u32 ofs, u8 b);
extern u32 cayDigSmpAllocateInstrumentCreatBlank(tInstrumentRec *InsRec, u32 Size, u8 b);
////////////////////////////////////////////////////////////////////
extern void cayDigSmpCalcFreq(tInstrumentFreqency *InsFreq, double Freq, u32 DevFreq);
extern void cayDigSmpSetPos(tInstrumentFreqency *InsFreq, u32 ofs);
extern void cayDigSmpGenerateBUF(tInstrumentFreqency *InsFreq, s16 *buf, u32 bufSize, u16 divFactor);

#endif
