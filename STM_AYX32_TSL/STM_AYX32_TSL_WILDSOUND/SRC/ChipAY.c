//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "hardware.h"
//#include "SoundBlaster.h"
#include "ChipAY.h"
#include <cstddef>


#pragma push
#pragma arm section code = "RAMCODE"
#pragma arm section rwdata = "RAMCODE"
#pragma arm section rodata = "RAMCODE"
#pragma arm section zidata = "RAMCODE"



void ChipAY_ArmInit(void)
{

}



// 0xPP000000     PP = Pos AT Table
//   AY->REG.ST.ARM.R4  - CNT TONE-A
//   AY->REG.ST.ARM.R5  - CNT TONE-B
//   AY->REG.ST.ARM.R6  - CNT TONE-C
//
//   AY->REG.ST.ARM.R10  - STP TONE-A
//   AY->REG.ST.ARM.R11  - STP TONE-B
//   AY->REG.ST.ARM.R12  - STP TONE-C
//
#define ayARM_STEP_SHIFT  24
#define ayARM_STEP_CONST  (u32)(1<<ayARM_STEP_SHIFT)
#define ayARMbSTEP_SHIFT  (ayARM_STEP_SHIFT-7)

#define ayARM_CNTA        AY->REG.ST.ARM.R4
#define ayARM_CNTB        AY->REG.ST.ARM.R5
#define ayARM_CNTC        AY->REG.ST.ARM.R6
#define ayARM_CNTE        AY->REG.ST.ARM.R7
#define ayARM_CNTN        AY->REG.ST.ARM.R8

#define ayARM_STEPA       AY->REG.ST.ARM.R11
#define ayARM_STEPB       AY->REG.ST.ARM.R12
#define ayARM_STEPC       AY->REG.ST.ARM.R13
#define ayARM_STEPE       AY->REG.ST.ARM.R14
#define ayARM_STEPN       AY->REG.ST.ARM.R15

#define ayGET_TONEA       (AY->REG.ST.TONE[0] & 0x0FFF ? AY->REG.ST.TONE[0] & 0x0FFF : 1)
#define ayGET_TONEB       (AY->REG.ST.TONE[1] & 0x0FFF ? AY->REG.ST.TONE[1] & 0x0FFF : 1)
#define ayGET_TONEC       (AY->REG.ST.TONE[2] & 0x0FFF ? AY->REG.ST.TONE[2] & 0x0FFF : 1)
#define ayGET_TONEN       (AY->REG.ST.NOISE   & 0x001F ? AY->REG.ST.NOISE   & 0x001F : 1)
#define ayGET_TONEE       (AY->REG.ST.ENV              ? AY->REG.ST.ENV              : 1)

#define ayGET_CNTA        (u8)(ayARM_CNTA>>ayARM_STEP_SHIFT)
#define ayGET_CNTB        (u8)(ayARM_CNTB>>ayARM_STEP_SHIFT)
#define ayGET_CNTC        (u8)(ayARM_CNTC>>ayARM_STEP_SHIFT)
#define ayGETbCNTA        (u8)(ayARM_CNTA>>ayARMbSTEP_SHIFT)
#define ayGETbCNTB        (u8)(ayARM_CNTB>>ayARMbSTEP_SHIFT)
#define ayGETbCNTC        (u8)(ayARM_CNTC>>ayARMbSTEP_SHIFT)


#define ayGET_CNTN        (u8)(ayARM_CNTN>>ayARM_STEP_SHIFT)
#define ayGET_CNTE        (u8)(ayARM_CNTE>>ayARM_STEP_SHIFT)

#define ayGETbPSGA        (ayGETbCNTA < AY->REG.ST.PWM[0]) ? 1 : 0
#define ayGETbPSGB        (ayGETbCNTB < AY->REG.ST.PWM[1]) ? 1 : 0
#define ayGETbPSGC        (ayGETbCNTC < AY->REG.ST.PWM[2]) ? 1 : 0


#define ayGET_PSGA        (u8)(ayGET_CNTA & 1)
#define ayGET_PSGB        (u8)(ayGET_CNTB & 1)
#define ayGET_PSGC        (u8)(ayGET_CNTC & 1)

#define ayStepMix(_n, _abc, _v, _vp)                                                                                                                      \
      if ( (ayGETbPSG##_abc | AY->REG.ST.MIXER.T##_abc) & (((ayARM_CNTN>>31)&1) | AY->REG.ST.MIXER.N##_abc) )                                             \
      {                                                                                                                                                   \
        _v=AY->REG.ST.VOL[_n];                                                                                                                            \
        if (_v&0x10)                                                                                                                                      \
        {                                                                                                                                                 \
          _v=_vp;                                                                                                                                         \
        }                                                                                                                                                 \
        _v&=0x0F;                                                                                                                                         \
      } else {                                                                                                                                            \
        _v=0;                                                                                                                                             \
      }



u32 ChipAY_TiksARM(tChipAY *AY, u16 tiks)
{
    
      ayARM_STEPA = ayARM_STEP_CONST / ayGET_TONEA;
      ayARM_STEPB = ayARM_STEP_CONST / ayGET_TONEB;
      ayARM_STEPC = ayARM_STEP_CONST / ayGET_TONEC;
      ayARM_STEPN = ayARM_STEP_CONST / ayGET_TONEN;
      ayARM_STEPE = ayARM_STEP_CONST / ayGET_TONEE;
      
      u16 vl,vr;
      u8 v=0;
      u8 vp;
  
      ayARM_CNTA += ayARM_STEPA*2*tiks;
      ayARM_CNTB += ayARM_STEPB*2*tiks;
      ayARM_CNTC += ayARM_STEPC*2*tiks;
      vu32 armNOL = ayARM_CNTN;
      ayARM_CNTN += ayARM_STEPN  *tiks;
      if (AY->REG.ST.ENVFLG*0+1)
      {
        ayARM_CNTE += ayARM_STEPE  *tiks;
      } else {
        AY->REG.ST.ENVFLG = 1;
        ayARM_CNTE = 0;
      }
    
     //NOISE
      if ( (ayARM_CNTN ^ armNOL) & 0x3F000000 )
      {
        ayARM_CNTN = (ayARM_CNTN & (~0x80000000)) | ((RNG->DR & 1)<<31);
      }
      
     //ENVELOUPMENT
     //0VccCCCC SSSSSSSS SSSSSSSS SSSSSSSS
      u8 ex = AY->REG.ST.ENVEFF;
      u8 ey;
      if ( (ayARM_CNTE & 0x70000000)==0 ) //if ( (cnteOLD ^ ayARM_CNTE) & 0x20000000 )
      {
        ey = (ayGET_CNTE) & 0x0F;
      } else {
        ayARM_CNTE = (ayARM_CNTE & (~0x40000000)) | 0x20000000;
        ey = ((ayGET_CNTE ^ 0x10) & 0x1F)+0x10;
      }
      vp = EnvRndTAB[ (ey*16) + ex ];
     //MIXER
      ayStepMix(0,A,v,vp);
      vl =VolTBAL[v];
      vr =VolTBAR[v];
      ayStepMix(1,B,v,vp);
      vl+=VolTBBL[v];
      vr+=VolTBBR[v];
      ayStepMix(2,C,v,vp);
      vl+=VolTBCL[v];
      vr+=VolTBCR[v];
      
    
      return vl | (vr<<16);
}



#pragma pop

