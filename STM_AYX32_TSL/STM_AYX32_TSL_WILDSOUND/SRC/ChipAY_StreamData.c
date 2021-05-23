//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "hardware.h"
#include "interface.h"
#include "ChipAY_StreamData.h"
#include "ChipAY_WildSound.h"
#include "MemoryAllocator.h"
#include <string.h>

//#pragma push
//#pragma arm section code = "RAMCODE"
//#pragma arm section rwdata = "RAMCODE"
//#pragma arm section rodata = "RAMCODE"
//#pragma arm section zidata = "RAMCODE"

#define mLogDEC(_v)           Send_RS_DEC(_v)
#define mLogHEX(_v,_d)        Send_RS_HEX(_v,_d)
#define mLogString(_s)        Send_RS_String(_s)
#define mLogEN()              mLogString("\x0D\x0A")
#define mLogStringEN(_s)      mLogString(_s); mLogEN()

#define macChipAyStreamConfig(_name, _fisize)                                         \
  rb_fifo_alloc(_name##FifoIN,    _fisize);                                           \
  rb_fifo_alloc(_name##FifoOUT,   _fisize);                                           \
  t_chypAyStream _name = {                                                            \
    .fifIN            = &_name##FifoIN,                                               \
    .fifOUT           = &_name##FifoOUT,                                              \
    .flag             = 0,                                                            \
    .CMD              = cays_CMD_NOP,                                                 \
    .DigPlayer        = &digPlayer,                                                   \
    .CacheParser      = (tStrmParsProc *)(&cayStrmCacheDescMemParsingNOP),            \
  }

  
  
macChipAyStreamConfig(chipAY_Stream, chipAY_StreamFifoSize);

void cayStrmCmdSet(t_chypAyStream *cstm, u16 cmd)
{
      cstm->CMD = cmd;
      cstm->STP = 0;
}

u32 cayStrmFlagGet(t_chypAyStream *cstm)
{
    return cstm->flag;
}
void cayStrmFlagSet(t_chypAyStream *cstm, u32 fl)
{
    cstm->flag |= fl;
}
void cayStrmFlagClr(t_chypAyStream *cstm, u32 fl)
{
    cstm->flag &=~fl;
}

void cayStrmClear(t_chypAyStream *cstm)
{
    cayStrmFifoINwrClear(cstm);
    cayStrmFifoOUwrClear(cstm);
    cstm->CMD = cays_CMD_NOP;
    cstm->flag = 0;
}
////////////////////////
u16 cayStrmFifoINwrFree(t_chypAyStream *cstm)
{
    return rb_fifo_free(cstm->fifIN);
}
u16 cayStrmFifoINwrSize(t_chypAyStream *cstm)
{
    return rb_fifo_size(cstm->fifIN);
}
void cayStrmFifoINwrClear(t_chypAyStream *cstm)
{
    rb_fifo_clear(cstm->fifIN);
}
void cayStrmFifoINwrB(t_chypAyStream *cstm, u8 b)
{
    if (cayStrmFifoINwrFree(cstm)) rb_fifo_wr(cstm->fifIN, b);
}
u8 cayStrmFifoINrdB(t_chypAyStream *cstm)
{
    u8 res=0;
    if (cayStrmFifoINwrSize(cstm)) res = rb_fifo_rd(cstm->fifIN);
    return res;
}
////////////////////////
u16 cayStrmFifoOUwrFree(t_chypAyStream *cstm)
{
    return rb_fifo_free(cstm->fifOUT);
}
u16 cayStrmFifoOUwrSize(t_chypAyStream *cstm)
{
    return rb_fifo_size(cstm->fifOUT);
}
void cayStrmFifoOUwrClear(t_chypAyStream *cstm)
{
    rb_fifo_clear(cstm->fifOUT);
}
void cayStrmFifoOUwrB(t_chypAyStream *cstm, u8 b)
{
    if (cayStrmFifoOUwrFree(cstm)) rb_fifo_wr(cstm->fifOUT, b);
}
u8 cayStrmFifoOUrdB(t_chypAyStream *cstm)
{
    u8 res=0;
    if (cayStrmFifoOUwrSize(cstm)) res = rb_fifo_rd(cstm->fifOUT);
    return res;
}
////////////////////////
void cayStrmCacheClear(t_chypAyStream *cstm)
{
    cstm->cPOS=0;
    cstm->DESCp=0;
    cstm->CacheParser=0;
}
u16 cayStrmCacheDescMemFlush(t_chypAyStream *cstm)
{
    u16 r = cstm->cPOS;
    if (r)
    {
      memalWriteBLK(cstm->DESC, cstm->DESCp, (u8 *)cstm->cBUF, r);
      cstm->DESCp += r;
      cstm->cPOS=0;
    }
    return r;
}
u16 cayStrmCacheDescMemAddPOS(t_chypAyStream *cstm, u8 b)
{
    u16 r=0;
    u16 isFlush=0;
    if (cstm->CacheParser)
    {
      isFlush = cstm->CacheParser(cstm, 0, 0);
      if (isFlush)
      {
        r+=cayStrmCacheDescMemFlush(cstm);
      }
    }
    cstm->cBUF[cstm->cPOS++]=b;
    cstm->POS++;
    if (cstm->cPOS==sizeof(cstm->cBUF))
    {
      r+=cayStrmCacheDescMemFlush(cstm);
    }
    return r;
}
////////////////////////
u32 cayStrmCacheDescMemParsingNOP(t_chypAyStream *cstm, u32 parA, u32 flag)
{
    return 0;
}

u32 cayStrmCacheDescMemParsingTRACK(t_chypAyStream *cstm, u32 parA, u32 flag)
{
    u32 r=0;
    const u32 p = cstm->POS; //cstm->DESCp + cstm->cPOS;   //Position Of Save Data
    const u32 pPatrec = structof(tPatternsPacked,PatREC);
    const u32 addr = malDesc->des[cstm->DESC].Addr;
    if ( p<pPatrec )
    {
      cstm->DigPlayer->PatNum=255;
      switch(p)
      {
        case 0:
          cstm->DigPlayer->pPAT = (tPatternsPacked *)(addr);
          break;
        case 2:
          r = 1;
          break;
        case 4:
          *(u16 *)(&cstm->cBUF) |= 0x8000;     //cstm->cBUF[cstm->cPOS-2]
          break;
      }
    } else {
      u32 p0=p-pPatrec;
      u32 p1=p0%sizeof(tPatternRec);
      u32 dd = *(u32 *)(&cstm->cBUF);
      u16 pn = p0/sizeof(tPatternRec);
      if (pn<cstm->DigPlayer->PatNum)
      {
        switch (p1)
        {
          case 0:
            r = 1;
            break;
          case 4:
            if (p==(pPatrec+4))
            {
              cstm->DigPlayer->PatNum = (dd-pPatrec)/sizeof(tPatternRec);
            }
            *(u32 *)(&cstm->cBUF) = dd+addr;
            break;
        }
      }
    }
    return r;
}

u32 cayStrmCacheDescMemParsingINSH(t_chypAyStream *cstm, u32 parA, u32 flag)
{
    u32 r=0;
    const u32 p = cstm->POS;//Position Of Save Data
    const u32 addr = malDesc->des[cstm->DESC].Addr;
    const u16 insRecSize = sizeof(tInstrumentRec);
    tInstrumentRec *insre = (tInstrumentRec *)(&cstm->cBUF);
    if (p==0)
    {
      cstm->DigPlayer->InsNum = (malDesc->des[cstm->DESC].Size / insRecSize);
      cstm->DigPlayer->pINS = (tInstrumentRec *)(addr);
      cstm->DigPlayer->SmpsPTR = 0;
      cstm->cPOS = insRecSize;    //Flush
      *(u32 *)(insre) = cayDigSmpAllocateInstrumentCreatBlank(insre, 16, 0x80);
      if (1)  //Show Descriptor
      {
        mLogDEC(insre->InsInfo->DES);
        mLogString(":");
      }
      r=1;
    }
    switch (p%insRecSize)
    {
      case 0:
        r=1;
        break;
      case insRecSize-1:
        //if (insre->LoopEnd)
        //{
        //  insre->Loop = 0;
        //  insre->SType = 2;
        //}
        *(u32 *)(insre)-= (cstm->DigPlayer->InsNum-1) * insRecSize;     //Offset Correct
        *(u32 *)(insre) = cayDigSmpAllocateInstrument(insre);
        if (1)  //Show Descriptor
        {
          mLogDEC(insre->InsInfo->DES);
          mLogString(".");
        }
        break;
    }
    return r;
}

u32 cayStrmCacheDescMemParsingINSDATA(t_chypAyStream *cstm, u32 parA, u32 flag)
{
    u32 r=0;
    if (cstm->DigPlayer)
    {
      const u32 p=cstm->DigPlayer->SmpsPTR;
      u32 i=cstm->DigPlayer->InsNum;
      while(i)
      {
        i--;
        const u32 ofs = cstm->DigPlayer->pINS[i].InsInfo->OFS;
        if (p>=ofs)
        {
          const u32 spos=p-ofs;
          if (spos==0) mLogDEC(i);
          cayDigSmpInstrumentAddByte(&cstm->DigPlayer->pINS[i], spos, parA);
          break;
        }
      }
      cstm->DigPlayer->SmpsPTR++;
    }
    return r;
}

////////////////////////

#define _mSwitchCmd(_cmd)   if (cstm->CMD==(_cmd))              \
                            {                                   \
                              switch (cstm->STP)                \
                              {                                 \
                                default:                        \
                                  cstm->STP = 0;                \
                                  mStepStop();                  \
                                  break;
#define _mEndCmd              }                                 \
                            }
#define _mElseCmd(_cmd)     _mEndCmd else _mSwitchCmd(_cmd)

#define mStepBack()      cstm->STP--
#define mStepNext()      cstm->STP++
#define mStepStop()      cayStrmFlagClr(cstm, cays_FLAG_DODONE)
#define mStepError()     cayStrmFlagSet(cstm, cays_FLAG_ERROR)

void cayStrmPool(t_chypAyStream *cstm)
{
    u16 siz;
    //static u32 tmr=0;
    if (cayStrmFlagGet(cstm) & cays_FLAG_DODONE)
    {
        _mSwitchCmd(cays_CMD_NOP)
          case 0:
            mLogString("NOP");
            mLogEN();
            mStepStop();
            break;
        _mElseCmd(cays_CMD_CLEAR)
          case 0:
            ayStr.WORK_EMUL_HARDMD = work_hrdEmul_mode_AY_HARDWARE_TIMER;
            mLogString("CLEAR ...");
            cayStrmClear(cstm);
            mLogString(" DONE");
            mLogEN();
            mStepStop();
            break;
        _mElseCmd(cays_CMD_ERASE)
          case 0:
            ayStr.WORK_EMUL_HARDMD = work_hrdEmul_mode_AY_HARDWARE_TIMER;
            mLogString("ERASE ...");
            memalEraseAllData();
            //WaitMS_Start(&tmr, 100);
            mStepNext();
            break;
          case 1:
            //if (WaitMS_Check(&tmr))
            {
              mStepNext();
            }
            break;
          case 2:
            mStepNext();
            break;
          case 3:
            mLogString(" DONE");
            mLogEN();
            mStepStop();
            break;
       ////////////////////////////////
       //Track DATA
       ////////////////////////////////
        _mElseCmd(cays_CMD_XMAST)
          case 0:
            mLogString("XMST .");
            cstm->DESC = cstm->DigPlayer->DSC.TRK  = memalMemDescAllocate(mema_FLAG_ROM, cstm->SIZE);
             mLogDEC(cstm->DESC);
             mLogString(":");
             mLogDEC(cstm->SIZE);
             mLogString(".");
            cayStrmCacheClear(cstm);
            cstm->CacheParser = (tStrmParsProc *)(&cayStrmCacheDescMemParsingTRACK);
            mStepNext();
            break;
          case 1:
            siz = cayStrmFifoOUwrSize(cstm);
            if ( siz )
            {
              //mLogDEC(siz);
              mLogString(".");  //cayStrmFifoOUwrClear(cstm);
              mStepNext();
            } else {
              cayStrmCacheDescMemFlush(cstm);
              if (cstm->POS == cstm->SIZE)
              {
                mLogString("TR Done");
              } else {
                mLogString("TR Error");
              }
              mLogEN();
              mStepStop();
            }
            break;
          case 2:
            siz = cayStrmFifoOUwrSize(cstm);
            while (siz)
            {
              u8 b=cayStrmFifoOUrdB(cstm);
              siz--;
              cayStrmCacheDescMemAddPOS(cstm, b);
            }
            mStepBack();
            mStepStop();
            break;
       ////////////////////////////////
        _mElseCmd(cays_CMD_XMADO)
       ////////////////////////////////
       //Instruments Header
       ////////////////////////////////
        _mElseCmd(cays_CMD_XMBST)
          case 0:
            mLogString("XINH .");
            //cstm->SIZE+=sizeof(tInstrumentRec);
            cstm->DESC = cstm->DigPlayer->DSC.INH = memalMemDescAllocate(mema_FLAG_ROM, cstm->SIZE+sizeof(tInstrumentRec));
             mLogDEC(cstm->DESC);
             mLogString(":");
             mLogDEC(cstm->SIZE);
             mLogString(".");
            cayStrmCacheClear(cstm);
            cstm->CacheParser = (tStrmParsProc *)(&cayStrmCacheDescMemParsingINSH);
            mStepNext();
            break;
          case 1:
            siz = cayStrmFifoOUwrSize(cstm);
            if ( siz )
            {
              //mLogDEC(siz);
              mLogString(".");  //cayStrmFifoOUwrClear(cstm);
              mStepNext();
            } else {
              cayStrmCacheDescMemFlush(cstm);
              if (cstm->POS == cstm->SIZE)
              {
                mLogString("INH Done");
              } else {
                mLogString("INH Error");
              }
              mLogEN();
              mStepStop();
            }
            break;
          case 2:
            siz = cayStrmFifoOUwrSize(cstm);
            while (siz)
            {
              u8 b=cayStrmFifoOUrdB(cstm);
              siz--;
              cayStrmCacheDescMemAddPOS(cstm, b);
            }
            mStepBack();
            mStepStop();
            break;
       ////////////////////////////////
       //Instruments Data
       ////////////////////////////////
        _mElseCmd(cays_CMD_XMBDO)
          case 0:
            mLogString("XINS .");
            //cstm->DESC = memalMemDescAllocate(mema_FLAG_ROM, cstm->SIZE);
             //mLogDEC(cstm->DESC);
             //mLogString(":");
             mLogDEC(cstm->SIZE);
             mLogString(".");
            cayStrmCacheClear(cstm);
            //cstm->CacheParser = (tStrmParsProc *)(&cayStrmCacheDescMemParsingINSDATA);
            mStepNext();
            break;
          case 1:
            siz = cayStrmFifoOUwrSize(cstm);
            if ( siz )
            {
              //mLogDEC(siz);
              mLogString(".");  //cayStrmFifoOUwrClear(cstm);
              mStepNext();
            } else {
              //cayStrmCacheDescMemFlush(cstm);
              if (cstm->POS == cstm->SIZE)
              {
                mLogString("INS Done");
                __nop();
              } else {
                mLogString("INS Error");
                __nop();
              }
              mLogEN();
              mStepStop();
            }
            break;
          case 2:
            siz = cayStrmFifoOUwrSize(cstm);
            while (siz)
            {
              u8 b=cayStrmFifoOUrdB(cstm);
              siz--;
              cayStrmCacheDescMemParsingINSDATA(cstm, b, 0);//cayStrmCacheDescMemAddPOS(cstm, b);
              cstm->POS++;
            }
            mStepBack();
            mStepStop();
            break;
            
       ////////////////////////////////
       //Instruments Data
       ////////////////////////////////
        _mElseCmd(cays_CMD_DIGPLAY)
          case 0:
            cayDigPlayerInit(&digPlayer, AyFreqSND);
            mLogString("Player Init:");
            mLogEN();
            mLogString(" Name ......... "); mLogString(digPlayer.pPAT->TrackName); mLogEN();
            mLogString(" Channels ..... "); mLogDEC(digPlayer.pPAT->Channels    ); mLogEN();
            mLogString(" Patterns ..... "); mLogDEC(digPlayer.PatNum            ); mLogEN();
            mLogString(" Instruments .. "); mLogDEC(digPlayer.InsNum            ); mLogEN();
            mLogString(" BPM .......... "); mLogDEC(digPlayer.pPAT->BPM         ); mLogEN();
            mLogString(" TMP .......... "); mLogDEC(digPlayer.pPAT->TMP         ); mLogEN();
            mLogString(" FreqTable .... "); if (digPlayer.pPAT->FreqTable==1) mLogString("Linear"); else mLogString("Amiga"); mLogEN();
            mLogString(" PatLen ....... "); mLogDEC(digPlayer.pPAT->PatLen      ); mLogEN();
            mLogString(" PatRes ....... "); mLogDEC(digPlayer.pPAT->PatRes      ); mLogEN();
            mLogString(" PatOrder ..... ");
            for (u16 n=0; n<digPlayer.pPAT->PatLen; n++)
            {
              if (n) mLogString(",");
              mLogHEX(digPlayer.pPAT->PatOrder[n],2);
            }
            mLogEN();

            /*cayDigPlayerGoToPatLine(&digPlayer, 0x15, 0);
            while( cayDigPlayerExtractLine(&digPlayer) )
            {
              //cayDigPlayerExtractLine(&digPlayer);
              mLogHEX(digPlayer.TRK.XMCUR.CLINE, 2);
              mLogString("|");
              for (u16 ch=0; ch<digPlayer.pPAT->Channels; ch++)
              {
                char s[16];
                if (ch) mLogString(" ");
                cayDigPlayerGetPatDataSTR(&digPlayer.TRK.XMCUR.PatDataLine[ch], s);
                mLogString(s);
              }
              mLogString("|");
              mLogEN();
            }*/
            
            //mLogDEC(sizeof( digPlayer.TRK.XMCUR.PatDataLine ));
            //mLogEN();
            
            mStepNext();
            break;
          case 1:
            cayDigPlayerPool(&digPlayer);
            ayStr.WORK_EMUL_HARDMD = work_hrdEmul_mode_AY_DIGITAL;
            mStepStop();
            break;
       ////////////////////////////////
        _mEndCmd else {
          mStepStop();
        }
      
    }
}
  
//#pragma pop
