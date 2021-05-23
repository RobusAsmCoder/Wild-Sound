//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "ChipAY_DigitalSample.h"
#include "MemoryAllocator.h"
#include <string.h>



//Return Addres Of tInstrumentInfo
u32 cayDigSmpAllocateInstrument(tInstrumentRec *InsRec)
{
    const u32 SmpLength = InsRec->Length;
    const u32 alSize = sizeof(tInstrumentInfo) + chypAySampleZerroBuffer + SmpLength + chypAySampleZerroBuffer*3;
    u32 p=0;
    tInstrumentInfo insinfo;
    insinfo.DES = memalMemDescAllocate(mema_FLAG_ROM, alSize);
  
    insinfo.SMPDATA = (u8 *)(memalDescGetAddr(insinfo.DES) + sizeof(tInstrumentInfo) + chypAySampleZerroBuffer);
    insinfo.OFS = (u32)(InsRec->InsInfo);
    insinfo.ID16 = 0xAAAA;
    insinfo.ID32 = 0xFFFF5555;
    switch (InsRec->SType)
    {
      default:
      case 0: //No Loop
        InsRec->Loop = InsRec->LoopEnd;
      case 1: //Forward Loop
      case 2: //PingPong Loop
        break;
    }
    p=0;
    memalWriteBLK(insinfo.DES, p, (u8 *)(&insinfo), sizeof(insinfo));
    p+=sizeof(insinfo);
    memalFillBLK(insinfo.DES, p, 0, chypAySampleZerroBuffer);
    p+=chypAySampleZerroBuffer +  InsRec->Loop;
    memalFillBLK(insinfo.DES, p, 0, chypAySampleZerroBuffer);
    p+=chypAySampleZerroBuffer +  InsRec->LoopEnd - InsRec->Loop;
    memalFillBLK(insinfo.DES, p, 0, chypAySampleZerroBuffer);
    p+=chypAySampleZerroBuffer +  InsRec->Length - InsRec->LoopEnd;
    memalFillBLK(insinfo.DES, p, 0, chypAySampleZerroBuffer);
    //p+=chypAySampleZerroBuffer;
  
    return memalDescGetAddr(insinfo.DES);
}

void cayDigSmpInstrumentAddByte(tInstrumentRec *InsRec, u32 ofs, u8 b)
{
    const u32 dofs = sizeof(tInstrumentInfo)+chypAySampleZerroBuffer;  //memalDescGetAddr(des) - ((u32)(&InsRec->InsInfo->SMPDATA));
    if (ofs<InsRec->Length)
    {
      const u16 des = InsRec->InsInfo->DES;
      u32 ofss = ofs;
      b^=0x80;
      if (b==0) b=1;
      if (ofs>=InsRec->Loop) ofss += chypAySampleZerroBuffer;
      if (ofs>=InsRec->LoopEnd) ofss += chypAySampleZerroBuffer;
      memalWriteBLK(des, dofs+ofss, (u8 *)(&b), 1);
    }
}

u32 cayDigSmpAllocateInstrumentCreatBlank(tInstrumentRec *InsRec, u32 Size, u8 b)
{
      memset(&InsRec[0], 0xFF, sizeof(tInstrumentRec));
      InsRec->Length = Size;
      InsRec->Loop = 0;
      InsRec->LoopEnd = Size;
      InsRec->Volume = 0x40;
      InsRec->FineTune = 0x00;
      InsRec->SType = 1;
      InsRec->Panning = 0x80;
      InsRec->RelativeNote = 0x00;
      u32 addr=cayDigSmpAllocateInstrument(InsRec);
      *(u32 *)(InsRec) = addr;
      for (u32 n=0; n<Size; n++) cayDigSmpInstrumentAddByte(InsRec, n, b);
      return addr;
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
void cayDigSmpCalcFreq(tInstrumentFreqency *InsFreq, double Freq, u32 DevFreq)
{
    InsFreq->freq = Freq*256;
    u64 dd = ((u64)((Freq  * (65536.0*256.0))/DevFreq));    //((u64)((Freq/DevFreq) *65536.0));
    InsFreq->step64.v = dd<<8;
    
}
//////////////////////////////////////////////////////////////////////////////////////
void cayDigSmpSetPos(tInstrumentFreqency *InsFreq, u32 ofs)
{
      u32 ofss = (ofs<InsFreq->InsRec->Length) ? (ofs) : (InsFreq->InsRec->Length-1);
      if (ofs>=InsFreq->InsRec->Loop) ofss += chypAySampleZerroBuffer;
      if (ofs>=InsFreq->InsRec->LoopEnd) ofss += chypAySampleZerroBuffer;
      InsFreq->pos64.v = (u64)(ofss)<<32;
}
//InsFreq - Instrument Freqency (RAM) accumulate data
//buf     - dual buffer 
void cayDigSmpGenerateBUF(tInstrumentFreqency *InsFreq, s16 *buf, u32 bufSize, u16 divFactor)
{
    const tInstrumentRec *InsRec = InsFreq->InsRec;
    const u32 MulFactor = 0x0100 / divFactor;
//      dpl->TRK.CHNL[n].InsFreq.FinalVol_L = dpl->TRK.XMCUR.LineCUR[n].FinalVol_L;
          u32 VoL =  ((InsFreq->FinalVol_L) * MulFactor)>>8;  //u32 VoL = ((InsRec->Volume*4) * MulFactor)>>8;//InsRec->Panning;
          u32 VoR =  ((InsFreq->FinalVol_R) * MulFactor)>>8;  //u32 VoR = ((InsRec->Volume*4) * MulFactor)>>8;//InsRec->Panning;
          u32 RepLen = InsRec->LoopEnd - InsRec->Loop;
    const u32 RepPos = (InsRec->Loop + chypAySampleZerroBuffer);
    //const u32 RepEnd = (InsRec->LoopEnd + chypAySampleZerroBuffer);
    if (InsRec->Panning<0x80)
    {
      VoR = (VoR * ((     InsRec->Panning)*2))>>8;
    } else {
      VoL = (VoL * ((0xFF-InsRec->Panning)*2))>>8;
    }
    
    if (RepLen==0) RepLen=1;
    while(bufSize)
    {
      u8 b;
      s32 pos;
      //const u32 posa = InsFreq->pos64.aru32[1];
      InsFreq->pos64.v += InsFreq->step64.v;
      pos = (s32)(InsFreq->pos64.aru32[1]);
      b=InsRec->InsInfo->SMPDATA[pos];
      if (b==0)
      {
        s32 of = 0;
        s16 dir= (InsFreq->step64.aru16[3] & 0x8000) ? -1:1; 
        if ( SysIsPOS(dir) )
        {
          if ( pos<RepPos )
          {
            pos += chypAySampleZerroBuffer;
            dir = -dir;
          }
        }
        
        of = (s32)(pos-RepPos);
        of = SysABS(of) % (RepLen);
        if ( SysIsPOS(dir) )
        {
          if ( InsRec->SType==2 )
          { //PingPong
            of = RepLen-1 - of;
          }
        } else {
          if ( InsRec->SType!=2 )
          { //NOT PingPong
            of = RepLen-1 - of;
          }
        }
        
        if ( InsRec->SType==2 ) InsFreq->step64.v = -InsFreq->step64.v; //Change Dir
        
        pos = RepPos + of;
        InsFreq->pos64.aru32[1] = pos;
        
        b=InsRec->InsInfo->SMPDATA[pos];
      }
      s16 bbl = (s32)((s8)(b)*VoL);
      s16 bbr = (s32)((s8)(b)*VoR);
      buf[0] += bbr;
      buf[1] += bbl;
      buf+=2;
      bufSize--;
    }
}




