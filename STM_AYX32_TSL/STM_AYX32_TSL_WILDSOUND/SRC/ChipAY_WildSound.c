//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "hardware.h"
#include "ChipAY_WildSound.h"
#include "ChipAY_Interrupt.h"
#include "ChipAY_Hardware.h"
#include <cstddef>

//__attribute__((section("ROMCODE")))
//__attribute__((section("RAMCODE")))
//__attribute__((section("ccmram")))
#pragma push
#pragma arm section code = "RAMCODE"
#pragma arm section rwdata = "RAMCODE"
#pragma arm section rodata = "RAMCODE"
#pragma arm section zidata = "RAMCODE"


tAY_Struct ayStr={
  .bus              = 0,      //if xxxx78xx then LVD=dibiloid send last Z80 instruction 078EDH="IN A,(C)" to AY ... LVD you was DEBIL and wilbe DEBIL continue
  .dta              = 0xFF,
  .ayn              = 0,
  .ay[0].adr        = 0,
  .ay[1].adr        = 0,
  .WORK_LOCK_BIT    = 0xFF,
  .WORK_MODE        = 0xFF,
  .WORK_CMD         = 0xFF,
  .WORK_STATUS      = 0x00,
  .WORK_POS         = 0x0000,
  .WORK_ERROR       = TSL_AYX32_E_NONE,
  .WORK_FW_SIZE     = 0x0000,
  .WORK_TRANS_TYPE  = TRANS_MODE_USART_SET_ZXIOA, //TRANS_MODE_USART_SET_ZXBURYAK, //TRANS_MODE_USART_SET_115200,//*0 + TRANS_MODE_USART_SET_ZXUNO,
  .WORK_EMUL_HARDMD = work_hrdEmul_mode_AY_HARDWARE_TIMER,    //0 - Hardware 1-Software 2-SoftwareODD
};

volatile tAdrHL ad={
  .ad = 0,
};

#define volMax            ((u16)1024*8)    //256//768
#define volType           1    //0-Lin 1-Log 2-Sin 3-SinLin

#define VBAL_AL           100
#define VBAL_AR            20
#define VBAL_BL            68
#define VBAL_BR            68
#define VBAL_CL            20
#define VBAL_CR           100


#define PutDiver(_t,_v,_w,_x)   ( (u16)( (volType==0) ? ((_t##.0F/15.0F)*volMax) :    \
                                         (volType==1) ? (_v##F*volMax)           :    \
                                         (volType==2) ? (_w##F*volMax)           :    \
                                                        (_x##F*volMax) ) )
//#define PutDiverX(_v)     PutDiver(_v),
#define volT_0            PutDiver( 0, 0.0000, 0.0000, 0.0000)   //00 =.0055
#define volT_1            PutDiver( 1, 0.0078, 0.0055, 0.0004)   //01
#define volT_2            PutDiver( 2, 0.0110, 0.0219, 0.0029)   //02
#define volT_3            PutDiver( 3, 0.0156, 0.0489, 0.0098)   //03
#define volT_4            PutDiver( 4, 0.0220, 0.0865, 0.0231)   //04
#define volT_5            PutDiver( 5, 0.0312, 0.1340, 0.0447)   //05
#define volT_6            PutDiver( 6, 0.0441, 0.1910, 0.0764)   //06
#define volT_7            PutDiver( 7, 0.0624, 0.2569, 0.1199)   //07
#define volT_8            PutDiver( 8, 0.0883, 0.3309, 0.1765)   //08
#define volT_9            PutDiver( 9, 0.1250, 0.4122, 0.2473)   //09
#define volT_A            PutDiver(10, 0.1515, 0.5000, 0.3333)   //10
#define volT_B            PutDiver(11, 0.2500, 0.5933, 0.4351)   //11
#define volT_C            PutDiver(12, 0.3030, 0.6910, 0.5528)   //12
#define volT_D            PutDiver(13, 0.5000, 0.7921, 0.6865)   //13
#define volT_E            PutDiver(14, 0.7070, 0.8955, 0.8358)   //14
#define volT_F            PutDiver(15, 1.0000, 1.0000, 1.0)   //15
#define PutVol(_n,_per)   ((u16)((volT_##_n)*_per/100))




#define VolTblGenerator(_cn)      \
const s16 VolTB##_cn[]={          \
  PutVol(0,VBAL_##_cn),           \
  PutVol(1,VBAL_##_cn),           \
  PutVol(2,VBAL_##_cn),           \
  PutVol(3,VBAL_##_cn),           \
  PutVol(4,VBAL_##_cn),           \
  PutVol(5,VBAL_##_cn),           \
  PutVol(6,VBAL_##_cn),           \
  PutVol(7,VBAL_##_cn),           \
  PutVol(8,VBAL_##_cn),           \
  PutVol(9,VBAL_##_cn),           \
  PutVol(A,VBAL_##_cn),           \
  PutVol(B,VBAL_##_cn),           \
  PutVol(C,VBAL_##_cn),           \
  PutVol(D,VBAL_##_cn),           \
  PutVol(E,VBAL_##_cn),           \
  PutVol(F,VBAL_##_cn)            \
}

VolTblGenerator(AL);
VolTblGenerator(AR);
VolTblGenerator(BL);
VolTblGenerator(BR);
VolTblGenerator(CL);
VolTblGenerator(CR);

#define TBLsetAT(_p,_v)    [(_p)]=_v
#define TBLsetARR_F(p,v0,v1,v2,v3,v4,v5,v6,v7,v8,v9,vA,vB,vC,vD,vE,vF)   \
                              TBLsetAT(p+ 0*16,0x##v0), \
                              TBLsetAT(p+ 1*16,0x##v1), \
                              TBLsetAT(p+ 2*16,0x##v2), \
                              TBLsetAT(p+ 3*16,0x##v3), \
                              TBLsetAT(p+ 4*16,0x##v4), \
                              TBLsetAT(p+ 5*16,0x##v5), \
                              TBLsetAT(p+ 6*16,0x##v6), \
                              TBLsetAT(p+ 7*16,0x##v7), \
                              TBLsetAT(p+ 8*16,0x##v8), \
                              TBLsetAT(p+ 9*16,0x##v9), \
                              TBLsetAT(p+10*16,0x##vA), \
                              TBLsetAT(p+11*16,0x##vB), \
                              TBLsetAT(p+12*16,0x##vC), \
                              TBLsetAT(p+13*16,0x##vD), \
                              TBLsetAT(p+14*16,0x##vE), \
                              TBLsetAT(p+15*16,0x##vF)
#define _D(p,pp)    TBLsetARR_F((p)*256+pp, F,E,D,C,B,A,9,8,7,6,5,4,3,2,1,0)
#define _U(p,pp)    TBLsetARR_F((p)*256+pp, 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F)
#define _L(p,pp)    TBLsetARR_F((p)*256+pp, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
#define _H(p,pp)    TBLsetARR_F((p)*256+pp, F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F)
#define _TBL(p, v0,v1,v2)    _##v0(0,0x##p), _##v1(1,0x##p), _##v2(2,0x##p)

const u8 EnvRndTAB[768]={
_TBL(0,D,L,L),// 0 { \_____ }
_TBL(1,D,L,L),// 1 { \_____ }
_TBL(2,D,L,L),// 2 { \_____ }
_TBL(3,D,L,L),// 3 { \_____ }
_TBL(4,U,L,L),// 4 { /_____ }
_TBL(5,U,L,L),// 5 { /_____ }
_TBL(6,U,L,L),// 6 { /_____ }
_TBL(7,U,L,L),// 7 { /_____ }
_TBL(8,D,D,D),// 8 { \\\\\\ }
_TBL(9,D,L,L),// 9 { \_____ }
_TBL(A,D,U,D),// A { \/\/\/ }
_TBL(B,D,H,H),// B { \----- }
_TBL(C,U,U,U),// C { ////// }
_TBL(D,U,H,H),// D { /----- } 
_TBL(E,U,D,U),// E { /\/\/\ }
_TBL(F,U,L,L),// F { /_____ }
};




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ChipAY_WriteReg(tChipAY *AY, u8 r, u8 v)
{
    if (r<sizeof(AY->REG.R))
    {
      AY->REG.R[r] = v;
      if (r<32)
      {
        if ( ((u32)AY) == (u32)&ayStr.ay[0] ) EXT_DoAyReneratorUpdate(0, (r & 0x1F));
        if ( ((u32)AY) == (u32)&ayStr.ay[1] ) EXT_DoAyReneratorUpdate(1, (r & 0x1F));
      }
    }
}
//Synthesizer_Stereo16_P
void ChipAY_Init(tChipAY *AY)
{
    ChipAY_WriteReg(AY,  0, 0x00);
    ChipAY_WriteReg(AY,  1, 0x00);
    ChipAY_WriteReg(AY,  2, 0x00);
    ChipAY_WriteReg(AY,  3, 0x00);
    ChipAY_WriteReg(AY,  4, 0x00);
    ChipAY_WriteReg(AY,  5, 0x00);
    ChipAY_WriteReg(AY,  6, 0x01);
    ChipAY_WriteReg(AY,  7, 0x3F);
    ChipAY_WriteReg(AY,  8, 0x00);
    ChipAY_WriteReg(AY,  9, 0x00);
    ChipAY_WriteReg(AY, 10, 0x00);
    ChipAY_WriteReg(AY, 11, 0x00);
    ChipAY_WriteReg(AY, 12, 0x00);
    ChipAY_WriteReg(AY, 13, 0x00);
    ChipAY_WriteReg(AY, 14, IOASTART);
    ChipAY_WriteReg(AY, 15, 0xFF);
    
    ChipAY_WriteReg(AY, 24, 0x80);
    ChipAY_WriteReg(AY, 25, 0x80);
    ChipAY_WriteReg(AY, 26, 0x80);
}

#define isUseProcedureCall    0

#define ayStepMix(AY, _n, _abc, _v, _vp, _TNE, _NOI)                                                                  \
      if ( (_TNE | AY.REG.ST.MIXER.T##_abc) & (_NOI | AY.REG.ST.MIXER.N##_abc) )                                      \
      {                                                                                                               \
        _v=AY.REG.ST.VOL[_n];                                                                                         \
        if (_v&0x10)                                                                                                  \
        {                                                                                                             \
          _v=_vp;                                                                                                     \
        }                                                                                                             \
        _v&=0x0F;                                                                                                                                         \
      } else {                                                                                                        \
        _v=0;                                                                                                         \
      }

//OUT:0xRRRRLLLL - R,L - 16-bit DAC value
//__attribute__((section("RAMCODE")))
u32 ChipAY_Mixer(tAY_Struct *ays)
{
      u32 dacv=0x80008000;
    
      u16 vl0,vr0;
      u16 vl1,vr1;
    
      static u16 ay0no=0;
      static u16 ay1no=0;
      static u8 no0i=1;
      static u8 no1i=1;
    #if isUseProcedureCall
      const u8  t0a= AY0TONEA_PWMcur();
      const u8  t0b= AY0TONEB_PWMcur();
      const u8  t0c= AY0TONEC_PWMcur();
      const u8  t1a= AY1TONEA_PWMcur();
      const u8  t1b= AY1TONEB_PWMcur();
      const u8  t1c= AY1TONEC_PWMcur();
      const u16 e0e=(AY0ENV_CNMcur(32)) & 0x1F;
      const u16 e1e=(AY1ENV_CNMcur(32)) & 0x1F;
      const u16 n0n= AY0NOI_CNTcur();
      const u16 n1n= AY1NOI_CNTcur();
     #else
      const u8  t0a= AYxPWMcur(AY0TONEA);
      const u8  t0b= AYxPWMcur(AY0TONEB);
      const u8  t0c= AYxPWMcur(AY0TONEC);
      const u8  t1a= AYxPWMcur(AY1TONEA);
      const u8  t1b= AYxPWMcur(AY1TONEB);
      const u8  t1c= AYxPWMcur(AY1TONEC);
      //const u16 e0e=(AYxCNTcur(AY0ENV)) & 0x1F; 
      //const u16 e1e=(AYxCNTcur(AY1ENV)) & 0x1F; 
      const u16 e0e=(AYxCNMcur(AY0ENV,32)) & 0x1F;
      const u16 e1e=(AYxCNMcur(AY1ENV,32)) & 0x1F;
      //const u16 n0n= AYxCNTcur(AY0NOI) & 2047; // AYxCNMcur(AY0NOI,2048);
      //const u16 n1n= AYxCNTcur(AY1NOI) & 2047; // AYxCNMcur(AY1NOI,2048);
      //const u16 n0n= AYxCNMcur(AY0NOI,256);
      //const u16 n1n= AYxCNMcur(AY1NOI,256);
      const u16 n0n= AYxPWMcur(AY0NOI);
      const u16 n1n= AYxPWMcur(AY1NOI);
     #endif

      u8 v;     //tmp for calc 0..15
      u8 vp;    //current Volume of ENV
      //u8 noi;
      u8 ex;
      u8 ey;
      
      if (ay0no != n0n) { no0i = RNG->DR & 1; ay0no = n0n; }
      if (ay1no != n1n) { no1i = RNG->DR & 1; ay1no = n1n; }
      //if (ay0no ^ n0n) { no0i = RNG->DR & 1; } ay0no = n0n;
      //if (ay1no ^ n1n) { no1i = RNG->DR & 1; } ay0no = n1n;
      
      ex = ays->ay[0].REG.ST.ENVEFF;
      ey = e0e;
      vp = EnvRndTAB[ 16*16 + ey*16 + ex ];
      ayStepMix( ays->ay[0], 0,A,v,vp, t0a, no0i);
      vl0 = VolTBAL[v];
      vr0 = VolTBAR[v];
      ayStepMix( ays->ay[0], 1,B,v,vp, t0b, no0i);
      vl0+= VolTBBL[v];
      vr0+= VolTBBR[v];
      ayStepMix( ays->ay[0], 2,C,v,vp, t0c, no0i);
      vl0+= VolTBCL[v];
      vr0+= VolTBCR[v];

      //noi = NoiseTAB[(u8)(n1n>>3)] >> ((n0n) & 7) & 1;
      ex = ays->ay[1].REG.ST.ENVEFF;
      ey = e1e;
      vp = EnvRndTAB[ 16*16 + ey*16 + ex ];
      ayStepMix( ays->ay[1], 0,A,v,vp, t1a, no1i);
      vl1 = VolTBAL[v];
      vr1 = VolTBAR[v];
      ayStepMix( ays->ay[1], 1,B,v,vp, t1b, no1i);
      vl1+= VolTBBL[v];
      vr1+= VolTBBR[v];
      ayStepMix( ays->ay[1], 2,C,v,vp, t1c, no1i);
      vl1+= VolTBCL[v];
      vr1+= VolTBCR[v];


      u16 vl;
      u16 vr;
#define bufsize 10*0
#if bufsize
      static u16 bufl[bufsize];
      static u16 bufr[bufsize];
      static u16 buP=0;
#endif      
      switch (1)
      {
//        case 0:
//          vl=((u16)(0x8000+vl0+vl1));
//          vr=((u16)(0x8000+vr0+vr1));
//          break;
        case 1:
          vl=((u16)((0x0000-vl0)+vl1));
          vr=((u16)((0x0000-vr0)+vr1));
          break;
      }
#if bufsize
      bufl[buP]=vl;
      bufr[buP]=vr;
      buP = (buP + 1) % bufsize;
      const u16 buPP = (buP + bufsize/4) % bufsize;
      vl = vl + (bufl[buP] / 2) - (bufl[buPP] / 4);
      vr = vr + (bufr[buP] / 2) - (bufl[buPP] / 4);
#endif      
      
      dacv = vl | (vr<<16);
      return dacv;
}

#pragma pop

