//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "ChipAY_DigitalPlayer.h"
#include "MemoryAllocator.h"
#include "rb_util.h"
#include <string.h>
#include <math.h>

#include "hardware.h"
#include "interface.h"
#define mLogDEC(_v)           Send_RS_DEC(_v)
#define mLogHEX(_v,_d)        Send_RS_HEX(_v,_d)
#define mLogString(_s)        Send_RS_String(_s)
#define mLogEN()              mLogString("\x0D\x0A")
#define mLogStringEN(_s)      mLogString(_s); mLogEN()

tDigitalPlayer digPlayer;


u32 cayDigPlayerStreamSize(tDigitalPlayer *dpl)
{
    return (dpl->TRK.STRM_WR - dpl->TRK.STRM_RD) % chayDigPlayerCacheBufferSize;
}

u32 cayDigPlayerStreamFree(tDigitalPlayer *dpl)
{
    u32 free = chayDigPlayerCacheBufferSize - cayDigPlayerStreamSize(dpl);
    return free ? (free-1) : (0);
}

u32 cayDigPlayerStreamGet(tDigitalPlayer *dpl)
{
    u32 res = 0x00000000;
    u32 pos = dpl->TRK.STRM_RD;
    if (pos != dpl->TRK.STRM_WR)
    {
      res = dpl->TRK.STRMBUF[pos++].v;
      if ( pos == chayDigPlayerCacheBufferSize ) pos = 0;
      dpl->TRK.STRM_RD=pos;
    }
    return res;
}

void cayDigPlayerStreamWRStep(tDigitalPlayer *dpl, u32 step)
{
    dpl->TRK.STRM_WR = (dpl->TRK.STRM_WR + step) % chayDigPlayerCacheBufferSize;
}

////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////
//OUT: 0 - NO EXTRACT
//     1 - Extract Data
//     2 - Extract Last Line
u16 cayDigPlayerExtractLine(tDigitalPlayer *dpl)
{
    u16 res = 0;
    u16 pat = dpl->TRK.XMCUR.PAT;
    u16 lin = dpl->TRK.XMCUR.LINE;
    if (pat<dpl->PatNum)
    {
      if (lin < dpl->pPAT->PatREC[pat].Rows)
      {
        u32 p = digPlayer.TRK.XMCUR.PATDPOS;
        memset(digPlayer.TRK.XMCUR.PatDataLine, 0, sizeof(digPlayer.TRK.XMCUR.PatDataLine) );
        
        for (u16 n=0; n<digPlayer.pPAT->Channels; n++)
        {
          u8 b = dpl->pPAT->PatREC[pat].OFS.DTA[p++];
          if ( (b&0x80)==0 )
          {
            u32 d = *(u32 *)(&dpl->pPAT->PatREC[pat].OFS.DTA[p]);
            *(u8  *)((u32)(&digPlayer.TRK.XMCUR.PatDataLine[n])+0) = b;
            *(u32 *)((u32)(&digPlayer.TRK.XMCUR.PatDataLine[n])+1) = d;
            p+=4;
          } else {
            for (u16 nn=0; nn<5; nn++)
            {
              if (b&1)
              {
                const u8 bb = dpl->pPAT->PatREC[pat].OFS.DTA[p++];
                ((u8 *)((u32)(&digPlayer.TRK.XMCUR.PatDataLine[n])))[nn] = bb;
              }
              b>>=1;
            }
          }
        }
        digPlayer.TRK.XMCUR.PATDPOS = p;
        dpl->TRK.XMCUR.CLINE = lin;
        dpl->TRK.XMCUR.LINE++;
        res = (dpl->TRK.XMCUR.LINE == dpl->pPAT->PatREC[pat].Rows) ? 2 : 1;
      }
    }
    return res;
}

u16 cayDigPlayerExtractLineShow(tDigitalPlayer *dpl)
{
    u16 res = cayDigPlayerExtractLine(dpl);
    
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
    return res;
}


void cayDigPlayerGoToPatLine(tDigitalPlayer *dpl, u16 pat, u16 lin)
{
    if (pat<dpl->PatNum)
    {
      dpl->TRK.XMCUR.PAT = pat;
      if (lin>=dpl->pPAT->PatREC[pat].Rows) lin=dpl->pPAT->PatREC[pat].Rows-1;
      dpl->TRK.XMCUR.PATDPOS = 0;
      dpl->TRK.XMCUR.LINE = 0;
      while(lin--)
      {
        cayDigPlayerExtractLine(dpl);
      }
    }
}

void cayDigPlayerGoToPosLine(tDigitalPlayer *dpl, u16 pos, u16 lin)
{
    if (pos>=dpl->pPAT->PatLen) pos = dpl->pPAT->PatLen-1;
    u32 pat = dpl->pPAT->PatOrder[pos];
    cayDigPlayerGoToPatLine(dpl, pat, lin);
    
}

void cayDigPlayerGetPatDataSTR(tPatData *pdt, char *s)
{   //23936
    const char efStr[]="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if (pdt->Note)
    {
      if (pdt->Note<(12*8+1))
      {
        const char noStr[]="C-C#D-D#E-F-F#G-G#A-A#B-";
        u16 octa = (pdt->Note-1) / 12;
        u16 note = (pdt->Note-1) % 12;
        memcpy(s, &noStr[note*2], 2);
        s[2] = '0'+octa;
      } else {
        if ( pdt->Note==(12*8+1) )
        {
          memcpy(s, " X ", 3);
        } else {
          memcpy(s, "???", 3);
        }
      }
    } else {
      memcpy(s, "---", 3);
    }
    s+=3;
    //*s++=' ';
    if (pdt->Ins)
    {
      rb_IntToHEX(pdt->Ins, 2 | rb_istr_mode_STR, s);
    } else {
      memcpy(s, "..", 2);
    }
    s+=2;
    //*s++=' ';
    if (pdt->VolEFF)
    {
      rb_IntToHEX(pdt->VolEFF, 2 | rb_istr_mode_STR, s);
    } else {
      memcpy(s, "--", 2);
    }
    s+=2;
    //*s++=' ';
    *s++=efStr[pdt->EFF];
    rb_IntToHEX(pdt->EFV, 2 | rb_istr_mode_STR, s);
    s+=2;
    *s=0;
}

////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////
/*
double DeFuzz(double x)
{
    if ( SysABS(x) < (1.0E-12) )
    {
      return 0.0;
    } else {
      return x;
    }
}

double Pwr(double x, double y)        //Pwr = x^y
{
    double r=0.0;
    if ( DeFuzz(x) == 0.0 )
    {
      if (DeFuzz(y) == 0.0 )
      {
        r = 1.0;    //0^0 = 1 (i.e., lim x^x = 1 as x -> 0)
      } else {
        r = 0.0;
      }
    } else {
      r = exp( log(x)*y );
    }
    return r;
}
*/
float PerFrCalc(tDigitalPlayer *dpl, u8 PatternNote, long RelativeTone, long FineTune, long PeriodPortamento)
{
      s32 Note;
      const u16 PeriodTab[12*8] = {
        907,900,894,887,881,875,868,862,856,850,844,838,832,826,820,814,
        808,802,796,791,785,779,774,768,762,757,752,746,741,736,730,725,
        720,715,709,704,699,694,689,684,678,675,670,665,660,655,651,646,
        640,636,632,628,623,619,614,610,604,601,597,592,588,584,580,59075,
        570,567,563,559,555,551,547,543,538,535,532,528,524,520,516,513,
        508,505,502,498,494,491,487,484,480,477,474,470,467,463,460,457 };
      double A,B;
      double Fract;
//   ////////////////////////////////
//   //  Periods and frequencies:  //
//   ////////////////////////////////
//   PatternNote = 0..95 (0 = C-0, 95 = B-7)
//   FineTune = -128..+127 (-128 = -1 halftone, +127 = +127/128 halftones)
//   RelativeTone = -96..95 (0 => C-4 = C-4)
//   RealNote = PatternNote + RelativeTone; (0..118, 0 = C-0, 118 = A#9)
     Note = PatternNote + RelativeTone;
     
      if ( dpl->pPAT->FreqTable==10 )
      {
//      Linear frequence table:
//      -----------------------
        //Note+=11; !!!
       dpl->TRK.XMCUR.Period = 10*12*16*4 - Note*16*4 - FineTune/2 - PeriodPortamento*4;
       if ( dpl->TRK.XMCUR.Period < 1 ) dpl->TRK.XMCUR.Period=1;
       if ( dpl->TRK.XMCUR.Period > 65535) dpl->TRK.XMCUR.Period=65535;
       A = ((6*12*16*4 - dpl->TRK.XMCUR.Period) / (12*16*4));
       B = pow( 2,A );
       dpl->TRK.XMCUR.Frequency = 8363*B;// *($92cb / $4db3);
      } else {
//      Amiga frequence table:
//      ----------------------
       Note -= 12;
       Fract = SysFrac(FineTune/16);
       u16 octa = (Note) / 12;
       u16 note = (Note) % 12;
       s16 tofs = note*8 + FineTune/16;
       if (tofs<0) tofs = 0;
       if (tofs>=(sizeof(PeriodTab)/sizeof(PeriodTab[0]))) tofs = (sizeof(PeriodTab)/sizeof(PeriodTab[0]))-1;
       double ppo = (u32)(1<<octa);//Pwr( 2,octa );
       dpl->TRK.XMCUR.Period  = (PeriodTab[tofs]*(1-Fract) +
                                 PeriodTab[tofs]*(  Fract))
                                 *16/ppo;
//      (The period is interpolated for finer finetune values)
       dpl->TRK.XMCUR.Period = dpl->TRK.XMCUR.Period - PeriodPortamento*2;
       if ( dpl->TRK.XMCUR.Period < 1     ) dpl->TRK.XMCUR.Period=1;
       if ( dpl->TRK.XMCUR.Period > 65535 ) dpl->TRK.XMCUR.Period=65535;
       dpl->TRK.XMCUR.Frequency = 8363*1712/dpl->TRK.XMCUR.Period;
      }
      return dpl->TRK.XMCUR.Frequency;
}


u8 XM_ChekSongEND(tDigitalPlayer *dpl)
{
    u16 m=dpl->pPAT->PatLen-1;
    for ( u16 n=0; n<dpl->pPAT->PatLen; n++ )
    {
     if ( dpl->TRK.XMCUR.PAT_PLAYED[n]!=0) m--;
    }
    if (m==0) dpl->TRK.XMCUR.SongEND=1;
    return dpl->TRK.XMCUR.SongEND;
}

u8 XM_Player_STEP(tDigitalPlayer *dpl, float DEV_FREQ)
{
    //long N;
    long I; //,M,A,B,C;
    //JPatData: ^ARRAY[0..65535] OF TPatData;
    //u32 EFF;
    u8 Vol;
    u32 FadeOutVol;
    u8 EnvelopeVol;
    u8 Scale;
    //u8 Note;
    //u8 Ins;
  
      FadeOutVol=65536;
      EnvelopeVol=64;
      Scale=255;

      dpl->TRK.XMCUR.TIKI++;
      dpl->TRK.XMCUR.TIK--;
      if ( dpl->TRK.XMCUR.TIK<1 )
      {
       //Get New Line
       if ( dpl->pPAT->PatREC[dpl->TRK.XMCUR.PAT].Rows <= dpl->TRK.XMCUR.LINE)
       {
        //Read Next PAT
        dpl->TRK.XMCUR.POS++;
        if ( dpl->TRK.XMCUR.POS >= dpl->pPAT->PatLen )
        {
         dpl->TRK.XMCUR.POS = dpl->pPAT->PatRes;
        }
        dpl->TRK.XMCUR.POSC=dpl->TRK.XMCUR.POS;
        XM_ChekSongEND(dpl);
        dpl->TRK.XMCUR.PAT_PLAYED[dpl->TRK.XMCUR.POSC]=1;
        if ( (dpl->TRK.XMCUR.LINE & 0xFFFF0000)==0 )
        {
          dpl->TRK.XMCUR.LINE = 0;
        }
        cayDigPlayerGoToPatLine(dpl, dpl->pPAT->PatOrder[dpl->TRK.XMCUR.POS], (u16)(dpl->TRK.XMCUR.LINE));//dpl->TRK.XMCUR.PAT = dpl->pPAT->PatOrder[dpl->TRK.XMCUR.POS]; dpl->TRK.XMCUR.LINE = 0;
       }
       cayDigPlayerExtractLineShow(dpl);//JPatData:=PatternER[XMCUR.PAT].MemPtr;
       for ( u16 N=0;  N<(dpl->pPAT->Channels); N++)
       {
        //////////////dpl->TRK.XMCUR.PatDataLine[N].
        //dpl->TRK.XMCUR.PatDataLine[N] := JPatData^[XMCUR.LINE * XM.Header.NumChannels + N];
        switch ( dpl->TRK.XMCUR.PatDataLine[N].EFF)
        {
         case 0x0E:
           dpl->TRK.XMCUR.PatDataLine[N].EFF = (dpl->TRK.XMCUR.PatDataLine[N].EFF << 4) | (dpl->TRK.XMCUR.PatDataLine[N].EFV >> 4);
           dpl->TRK.XMCUR.PatDataLine[N].EFV =  dpl->TRK.XMCUR.PatDataLine[N].EFV & 0x0F;
          break;
         case 0x0F:
          if ( dpl->TRK.XMCUR.PatDataLine[N].EFV<0x20 )
          {
           dpl->TRK.XMCUR.TMP=dpl->TRK.XMCUR.PatDataLine[N].EFV;
          } else {
           dpl->TRK.XMCUR.BPM=dpl->TRK.XMCUR.PatDataLine[N].EFV;
          }
          break;
         case 0x17:
          switch ( dpl->TRK.XMCUR.PatDataLine[N].EFV & 0xF0 )
          {
           case 0x00:
            break;
           case 0x10:
            dpl->TRK.XMCUR.PatDataLine[N].EFF++;
            break;
           default:
            dpl->TRK.XMCUR.PatDataLine[N].EFF=0;
            break;
          }
          dpl->TRK.XMCUR.PatDataLine[N].EFV = dpl->TRK.XMCUR.PatDataLine[N].EFV & 0x0F;
          break;
        }

        dpl->TRK.XMCUR.LineCUR[N].RelativePRES=1;
        if ( dpl->TRK.XMCUR.PatDataLine[N].EFF == 0xED ) // Note Delay
        {
         dpl->TRK.XMCUR.LineCUR[N].RelativePRES=(dpl->TRK.XMCUR.PatDataLine[N].EFV & 15);
         if ( dpl->TRK.XMCUR.LineCUR[N].RelativePRES!=0 ) dpl->TRK.XMCUR.LineCUR[N].RelativePRES++;
        }
       }
       dpl->TRK.XMCUR.TIK = dpl->TRK.XMCUR.TMP;
       dpl->TRK.XMCUR.TIKI = 0;
       //dpl->TRK.XMCUR.CLINE = dpl->TRK.XMCUR.LINE;
       //dpl->TRK.XMCUR.LINE++;
      }

      //Do EFFECTS
      for ( u16 N=0; N<(dpl->pPAT->Channels-0); N++)
      {
       dpl->TRK.XMCUR.LineCUR[N].InsA = 0;
       dpl->TRK.XMCUR.LineCUR[N].RelativePRES--;
       dpl->TRK.XMCUR.LineCUR[N].SmpOfs=0;
       if ( dpl->TRK.XMCUR.LineCUR[N].RelativePRES==0 )
       {
//        XMCUR.LineCUR[N].NoteO:=XMCUR.LineCUR[N].Note;
//        XMCUR.LineCUR[N].RelativeToneO:=XMCUR.LineCUR[N].RelativeTone;
//        XMCUR.LineCUR[N].FineTuneO:=XMCUR.LineCUR[N].FineTune;

        if ( dpl->TRK.XMCUR.PatDataLine[N].Ins!=0 ) //) && (N!=3)
        {
         dpl->TRK.XMCUR.LineCUR[N].Vol = dpl->pINS[dpl->TRK.XMCUR.PatDataLine[N].Ins].Volume;
         switch (dpl->TRK.XMCUR.PatDataLine[N].EFF)
         {
          case 0x03:
           break;
          default:
           if ( dpl->TRK.XMCUR.PatDataLine[N].Note!=0 )
           {
            dpl->TRK.XMCUR.LineCUR[N].PeriodPortamento = 0;
            dpl->TRK.XMCUR.LineCUR[N].FineTune         = dpl->pINS[dpl->TRK.XMCUR.PatDataLine[N].Ins].FineTune;
            dpl->TRK.XMCUR.LineCUR[N].RelativeTone     = dpl->pINS[dpl->TRK.XMCUR.PatDataLine[N].Ins].RelativeNote;
            dpl->TRK.XMCUR.LineCUR[N].Ins              = dpl->TRK.XMCUR.PatDataLine[N].Ins;
            dpl->TRK.XMCUR.LineCUR[N].InsA             = dpl->TRK.XMCUR.PatDataLine[N].Ins;
           } else {
           }
           break;
         }
        } else {
         if ( dpl->TRK.XMCUR.PatDataLine[N].Note!=0 )
         {
          dpl->TRK.XMCUR.LineCUR[N].PeriodPortamento = 0;
          dpl->TRK.XMCUR.LineCUR[N].InsA             = dpl->TRK.XMCUR.LineCUR[N].Ins;
         }
        }

        if ( dpl->TRK.XMCUR.PatDataLine[N].Note!=0 )
        {
         switch ( dpl->TRK.XMCUR.PatDataLine[N].EFF)
         {
          case 0x03:
           dpl->TRK.XMCUR.LineCUR[N].PeriodPortamentoO = 0; // !!!!!!!!!!!!!
           dpl->TRK.XMCUR.LineCUR[N].NoteO             = dpl->TRK.XMCUR.PatDataLine[N].Note;
           dpl->TRK.XMCUR.LineCUR[N].FineTuneO         = dpl->pINS[dpl->TRK.XMCUR.LineCUR[N].Ins].FineTune;
           dpl->TRK.XMCUR.LineCUR[N].RelativeToneO     = dpl->pINS[dpl->TRK.XMCUR.LineCUR[N].Ins].RelativeNote;
           break;
          default:
           dpl->TRK.XMCUR.LineCUR[N].Note = dpl->TRK.XMCUR.PatDataLine[N].Note;
           break;
         }
        }

        if ( (dpl->TRK.XMCUR.PatDataLine[N].VolEFF>=0x10) && (dpl->TRK.XMCUR.PatDataLine[N].VolEFF<=0x50) )
        {
         dpl->TRK.XMCUR.LineCUR[N].Vol = dpl->TRK.XMCUR.PatDataLine[N].VolEFF-0x10;
        }
       }

       dpl->TRK.XMCUR.LineCUR[N].NoteArpeggio = 0;
       //DO EFFECT
       switch ( dpl->TRK.XMCUR.PatDataLine[N].EFF )
       {
        //1      Arpeggio
        case 0x00:
         switch ( dpl->TRK.XMCUR.TIKI % 3 )
         {
          case 0: dpl->TRK.XMCUR.LineCUR[N].NoteArpeggio = 0;                                       break;
          case 1: dpl->TRK.XMCUR.LineCUR[N].NoteArpeggio = dpl->TRK.XMCUR.PatDataLine[N].EFV >> 4;  break;
          case 2: dpl->TRK.XMCUR.LineCUR[N].NoteArpeggio = dpl->TRK.XMCUR.PatDataLine[N].EFV & 15;  break;
         }
         break;

        //1  (*) Porta up
        case 0x01:
         if ( dpl->TRK.XMCUR.LineCUR[N].RelativePRES!=0 ) dpl->TRK.XMCUR.LineCUR[N].PeriodPortamento += dpl->TRK.XMCUR.PatDataLine[N].EFV;
         break;
        //2  (*) Porta down
        case 0x02:
         if ( dpl->TRK.XMCUR.LineCUR[N].RelativePRES!=0)  dpl->TRK.XMCUR.LineCUR[N].PeriodPortamento -= dpl->TRK.XMCUR.PatDataLine[N].EFV;
         break;

        //3  (*) Slide
        case 0x03:
         if ( dpl->TRK.XMCUR.LineCUR[N].RelativePRES!=0 )
         {
           if ( dpl->TRK.XMCUR.CLINE==8 )
           {
            I=0;
           }
           I=0;
           PerFrCalc(dpl, dpl->TRK.XMCUR.LineCUR[N].NoteO, dpl->TRK.XMCUR.LineCUR[N].RelativeToneO, dpl->TRK.XMCUR.LineCUR[N].FineTuneO, dpl->TRK.XMCUR.LineCUR[N].PeriodPortamentoO);
           dpl->TRK.XMCUR.LineCUR[N].PeriodO = dpl->TRK.XMCUR.Period;
           dpl->TRK.XMCUR.LineCUR[N].FrequencyO = dpl->TRK.XMCUR.Frequency;
           if ( dpl->TRK.XMCUR.LineCUR[N].FrequencyR < dpl->TRK.XMCUR.LineCUR[N].FrequencyO )
           {
            dpl->TRK.XMCUR.LineCUR[N].PeriodPortamento += dpl->TRK.XMCUR.PatDataLine[N].EFV;
            PerFrCalc(dpl, dpl->TRK.XMCUR.LineCUR[N].Note, dpl->TRK.XMCUR.LineCUR[N].RelativeTone, dpl->TRK.XMCUR.LineCUR[N].FineTune, dpl->TRK.XMCUR.LineCUR[N].PeriodPortamento);
            if ( dpl->TRK.XMCUR.Frequency > dpl->TRK.XMCUR.LineCUR[N].FrequencyO ) I=1;
           } else {
            dpl->TRK.XMCUR.LineCUR[N].PeriodPortamento -= dpl->TRK.XMCUR.PatDataLine[N].EFV;
            PerFrCalc(dpl, dpl->TRK.XMCUR.LineCUR[N].Note, dpl->TRK.XMCUR.LineCUR[N].RelativeTone, dpl->TRK.XMCUR.LineCUR[N].FineTune, dpl->TRK.XMCUR.LineCUR[N].PeriodPortamento);
            if ( dpl->TRK.XMCUR.Frequency < dpl->TRK.XMCUR.LineCUR[N].FrequencyO ) I=1;
           }
           if (I==1)
           {
            dpl->TRK.XMCUR.LineCUR[N].Note             = dpl->TRK.XMCUR.LineCUR[N].NoteO;
            dpl->TRK.XMCUR.LineCUR[N].RelativeTone     = dpl->TRK.XMCUR.LineCUR[N].RelativeToneO;
            dpl->TRK.XMCUR.LineCUR[N].FineTune         = dpl->TRK.XMCUR.LineCUR[N].FineTuneO;
            dpl->TRK.XMCUR.LineCUR[N].PeriodPortamento = dpl->TRK.XMCUR.LineCUR[N].PeriodPortamentoO;
           }
         }
         break;

        //9      Samplr Offset
        case 0x09:
         if ( dpl->TRK.XMCUR.PatDataLine[N].Note!=0)
         {
          dpl->TRK.XMCUR.LineCUR[N].SmpOfs = dpl->TRK.XMCUR.PatDataLine[N].EFV;
         }
         break;
        //C      Set volume
        case 0x0C:
         dpl->TRK.XMCUR.LineCUR[N].Vol = dpl->TRK.XMCUR.PatDataLine[N].EFV;
         break;

        //      A  (*) Volume slide
        case 0x0A:
         if ( dpl->TRK.XMCUR.LineCUR[N].RelativePRES!=0 )
         {
          if ( (dpl->TRK.XMCUR.PatDataLine[N].EFV & 0xF0) != 0 )
          {
           dpl->TRK.XMCUR.LineCUR[N].Vol += dpl->TRK.XMCUR.PatDataLine[N].EFV >> 4;
          } else {
           dpl->TRK.XMCUR.LineCUR[N].Vol -= dpl->TRK.XMCUR.PatDataLine[N].EFV;
          }
         }
         break;

        //      B  (*) Pos Jump
        case 0x0B:
         if ( dpl->TRK.XMCUR.LineCUR[N].RelativePRES==0 )
         {
          dpl->TRK.XMCUR.LINE = 0x08000000;
          dpl->TRK.XMCUR.POS = dpl->TRK.XMCUR.PatDataLine[N].EFV;
          if ( dpl->TRK.XMCUR.POS >= dpl->pPAT->PatLen )
          {
           dpl->TRK.XMCUR.POS = dpl->pPAT->PatRes;
          }
         }
         break;

        //      D  (*) PATTERN BREAK
        case 0x0D:
         if ( dpl->TRK.XMCUR.LineCUR[N].RelativePRES==0 )
         {
          dpl->TRK.XMCUR.LINE = (dpl->TRK.XMCUR.PatDataLine[N].EFV & 15) | ((dpl->TRK.XMCUR.PatDataLine[N].EFV >> 4)*10);
          dpl->TRK.XMCUR.LINE = dpl->TRK.XMCUR.LINE | 0x08000000;
          dpl->TRK.XMCUR.POS = dpl->TRK.XMCUR.POSC;//+1;
          if ( dpl->TRK.XMCUR.POS >= dpl->pPAT->PatLen )
          {
           dpl->TRK.XMCUR.POS = dpl->pPAT->PatRes;
          }
         }
         break;

        //E1 (*) Fine porta up
        case 0xE1:
         if ( dpl->TRK.XMCUR.LineCUR[N].RelativePRES==0 ) dpl->TRK.XMCUR.LineCUR[N].PeriodPortamento += dpl->TRK.XMCUR.PatDataLine[N].EFV;
         break;
        //E2 (*) Fine porta down
        case 0xE2:
         if ( dpl->TRK.XMCUR.LineCUR[N].RelativePRES==0 ) dpl->TRK.XMCUR.LineCUR[N].PeriodPortamento -= dpl->TRK.XMCUR.PatDataLine[N].EFV;
         break;

        case 0xE6:
         if ( dpl->TRK.XMCUR.LineCUR[N].RelativePRES==0 )
         {
          if ( dpl->TRK.XMCUR.PatDataLine[N].EFV==0 )
          {
           dpl->TRK.XMCUR.LINE_LOOP = dpl->TRK.XMCUR.CLINE;
          } else {
           if ( dpl->TRK.XMCUR.LINE_LOOPC < dpl->TRK.XMCUR.PatDataLine[N].EFV )
           {
            dpl->TRK.XMCUR.LINE = dpl->TRK.XMCUR.LINE_LOOP | 0x08000000;
            dpl->TRK.XMCUR.LINE_LOOPC++;
            dpl->TRK.XMCUR.POS = dpl->TRK.XMCUR.POSC-1;
           } else {
            dpl->TRK.XMCUR.LINE_LOOPC = 0;
           }
          }
         }
         break;

        //EA (*) Fine volume slide up
        case 0xEA:
         if ( dpl->TRK.XMCUR.LineCUR[N].RelativePRES==0 ) dpl->TRK.XMCUR.LineCUR[N].Vol += dpl->TRK.XMCUR.PatDataLine[N].EFV;
         break;
        //EB (*) Fine volume slide down
        case 0xEB:
         if ( dpl->TRK.XMCUR.LineCUR[N].RelativePRES==0 ) dpl->TRK.XMCUR.LineCUR[N].Vol -= dpl->TRK.XMCUR.PatDataLine[N].EFV;
         break;
       }

       if ( dpl->TRK.XMCUR.LineCUR[N].Vol>64 ) dpl->TRK.XMCUR.LineCUR[N].Vol = 64;
       if ( dpl->TRK.XMCUR.LineCUR[N].Vol<0  ) dpl->TRK.XMCUR.LineCUR[N].Vol = 0;

       PerFrCalc(dpl, dpl->TRK.XMCUR.LineCUR[N].Note+dpl->TRK.XMCUR.LineCUR[N].NoteArpeggio, dpl->TRK.XMCUR.LineCUR[N].RelativeTone, dpl->TRK.XMCUR.LineCUR[N].FineTune, dpl->TRK.XMCUR.LineCUR[N].PeriodPortamento);
       dpl->TRK.XMCUR.LineCUR[N].PeriodR = dpl->TRK.XMCUR.Period;
       dpl->TRK.XMCUR.LineCUR[N].FrequencyR = dpl->TRK.XMCUR.Frequency;
       dpl->TRK.XMCUR.LineCUR[N].Period = dpl->TRK.XMCUR.Period;
       dpl->TRK.XMCUR.LineCUR[N].Frequency = dpl->TRK.XMCUR.Frequency;// * (DEV_FREQ);//(DEV_FREQ/45000);
       //(FadeOutVol/65536)*(EnvelopeVol/64)*(GlobalVol/64)*(Vol/64)*Scale;
       Vol = dpl->TRK.XMCUR.LineCUR[N].Vol;
       EnvelopeVol = dpl->TRK.XMCUR.LineCUR[N].EnvelopeVol;
       //dpl->TRK.XMCUR.LineCUR[N].FinalVol = ( (FadeOutVol/65536)*(EnvelopeVol/64)*(dpl->TRK.XMCUR.GlobalVol/64)*(Vol/64)*Scale );
       u32 fvol = ( (FadeOutVol>>8) * EnvelopeVol * dpl->TRK.XMCUR.GlobalVol * Vol);
           fvol = (fvol / (256*64)) *  Scale;
           fvol = (fvol / (64*64));
       dpl->TRK.XMCUR.LineCUR[N].FinalVol = ( fvol );
       dpl->TRK.XMCUR.LineCUR[N].FinalVol_L = dpl->TRK.XMCUR.LineCUR[N].FinalVol;
       dpl->TRK.XMCUR.LineCUR[N].FinalVol_R = dpl->TRK.XMCUR.LineCUR[N].FinalVol;

       if ( dpl->pPAT->FreqTable!=1 )
       {
        //Amiga
        switch(N)
        {
         case 0: //L
          dpl->TRK.XMCUR.LineCUR[N].FinalVol_L = (dpl->TRK.XMCUR.LineCUR[N].FinalVol*1.0);
          dpl->TRK.XMCUR.LineCUR[N].FinalVol_R = (dpl->TRK.XMCUR.LineCUR[N].FinalVol*0.4);
          break;
         case 1: //L
          dpl->TRK.XMCUR.LineCUR[N].FinalVol_L = (dpl->TRK.XMCUR.LineCUR[N].FinalVol*1.0);
          dpl->TRK.XMCUR.LineCUR[N].FinalVol_R = (dpl->TRK.XMCUR.LineCUR[N].FinalVol*0.9);
          break;
         case 2: //R
          dpl->TRK.XMCUR.LineCUR[N].FinalVol_L = (dpl->TRK.XMCUR.LineCUR[N].FinalVol*0.9);
          dpl->TRK.XMCUR.LineCUR[N].FinalVol_R = (dpl->TRK.XMCUR.LineCUR[N].FinalVol*1.0);
          break;
         case 3: //R
          dpl->TRK.XMCUR.LineCUR[N].FinalVol_L = (dpl->TRK.XMCUR.LineCUR[N].FinalVol*0.4);
          dpl->TRK.XMCUR.LineCUR[N].FinalVol_R = (dpl->TRK.XMCUR.LineCUR[N].FinalVol*1.0);
          break;
        }
       }
       dpl->TRK.XMCUR.LineCUR[N].FinalVol_LR = dpl->TRK.XMCUR.LineCUR[N].FinalVol_L | (dpl->TRK.XMCUR.LineCUR[N].FinalVol_R << 8);
      }
      
      return dpl->TRK.XMCUR.SongEND;
}
////////////////////////////////////////////////////////////////

void cayDigPlayerSetSamplePos(tDigitalPlayer *dpl, tInstrumentFreqency *insfrq, u8 ins, u32 ofs)
{
    if (ins<dpl->InsNum)
    {
        insfrq->InsRec = &dpl->pINS[ins];
        cayDigSmpSetPos(insfrq, ofs);
    }
}

u16 cayDigPlayerSTEP(tDigitalPlayer *dpl)
{
    u16 res;
    //
    res = XM_Player_STEP(dpl, dpl->TRK.DevFreq);
    dpl->TRK.DevTacts = (dpl->TRK.DevFreq*60) / (dpl->TRK.XMCUR.BPM*24);      //TimeInSec = 1 / ( (BPM*24/60) / (SPEED==1) )  // Tiks = (DevFreq*60) / (BPM*24)
    
    for (u16 n=0; n<(dpl->pPAT->Channels); n++)
    {
      const u8 InsA = dpl->TRK.XMCUR.LineCUR[n].InsA;
      //mLogDEC(InsA);
      if (InsA)
      {
        //dpl->TRK.CHNL[n].InsFreq.InsRec = &dpl->pINS[InsA];
        //cayDigSmpSetPos(&dpl->TRK.CHNL[n].InsFreq, dpl->TRK.XMCUR.LineCUR[n].SmpOfs<<8);
        cayDigPlayerSetSamplePos(dpl, &dpl->TRK.CHNL[n].InsFreq, InsA, dpl->TRK.XMCUR.LineCUR[n].SmpOfs<<8);
      }
      cayDigSmpCalcFreq(&dpl->TRK.CHNL[n].InsFreq, dpl->TRK.XMCUR.LineCUR[n].Frequency ,dpl->TRK.DevFreq);
      dpl->TRK.CHNL[n].InsFreq.FinalVol_L = dpl->TRK.XMCUR.LineCUR[n].FinalVol_L;
      dpl->TRK.CHNL[n].InsFreq.FinalVol_R = dpl->TRK.XMCUR.LineCUR[n].FinalVol_R;
    }
  
    return res;
}

u16 cayDigPlayerPool(tDigitalPlayer *dpl)
{
    u16 res=0;
    u32 free=cayDigPlayerStreamFree(dpl);
    if (free>chayDigPlayerCacheBufferUpDateFree)
    {
      SWO(0);
      free = chayDigPlayerCacheBufferUpDateFree;
      while(free)
      {
        if (dpl->TRK.DevTacts==0)
        {
          cayDigPlayerSTEP(dpl);
        }
        
        u32 siz = free;
        const u32 frblck = chayDigPlayerCacheBufferSize - dpl->TRK.STRM_WR;
        if (siz>frblck) siz=frblck;
        if (siz>dpl->TRK.DevTacts) siz=dpl->TRK.DevTacts;
        u32 elsize = sizeof(dpl->TRK.STRMBUF[0]);
        memset(&dpl->TRK.STRMBUF[dpl->TRK.STRM_WR], 0, siz*elsize);

        
        //XM_Player_STEP(dpl, dpl->TRK.DevFreq*0+1);
        //const u32 straddr = (u32)(&dpl->TRK.STRMBUF[dpl->TRK.STRM_WR]);//(s16 *)(&dpl->TRK.STRMBUF[dpl->TRK.STRM_WR]);
        for (u16 chnl=0; chnl<(dpl->pPAT->Channels); chnl++)
        {
          cayDigSmpGenerateBUF(&dpl->TRK.CHNL[chnl].InsFreq, (s16 *)(&dpl->TRK.STRMBUF[dpl->TRK.STRM_WR]), siz, dpl->pPAT->Channels);
        }

        cayDigPlayerStreamWRStep(dpl, siz);
        free-=siz;
        dpl->TRK.DevTacts-=siz;
        
      }
      SWO(1);
    }
    return res;
}

////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////




////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////

void cayDigPlayerInit(tDigitalPlayer *dpl, u32 FreqOut)
{
    memset(&dpl->TRK, 0, sizeof(dpl->TRK));
    dpl->TRK.DevFreq = FreqOut;
    dpl->TRK.XMCUR.BPM = dpl->pPAT->BPM;
    dpl->TRK.XMCUR.TMP = dpl->pPAT->TMP;
    dpl->TRK.XMCUR.PAT = dpl->pPAT->PatOrder[dpl->TRK.XMCUR.POS];
    for (u16 n=0; n</*dpl->pPAT->Channels*/ chayDigPlayerChannelMAX; n++)
    {
      dpl->TRK.XMCUR.LineCUR[n].Vol=64;
      dpl->TRK.XMCUR.LineCUR[n].EnvelopeVol=64;
      dpl->TRK.XMCUR.LineCUR[n].Note=12*4;
      dpl->TRK.CHNL[n].InsFreq.InsRec = &dpl->pINS[0];  //Zerro Mute Instrument
      dpl->TRK.CHNL[n].InsFreq.step64.v = 0x0000000000000000;
      cayDigSmpSetPos(&dpl->TRK.CHNL[n].InsFreq,  0);
    }
    //cayDigPlayerGoToPatLine(dpl, dpl->TRK.XMCUR.PAT, 0);
    cayDigPlayerGoToPosLine(dpl, dpl->TRK.XMCUR.POSC, 0);
    dpl->TRK.XMCUR.PAT_PLAYED[dpl->TRK.XMCUR.POSC] = 1;
    dpl->TRK.XMCUR.GlobalVol = 64;
    dpl->TRK.XMCUR.TIKI = -1;
    dpl->TRK.XMCUR.PAT_PLAYED[dpl->pPAT->PatLen] = 0xFF;
/*    
    dpl->TRK.CHNL[0].InsFreq.InsRec = &dpl->pINS[7];
    dpl->TRK.CHNL[0].InsFreq.step64.v = 0x0000000100000000>>3;
    dpl->TRK.CHNL[1].InsFreq.InsRec = &dpl->pINS[7];
    dpl->TRK.CHNL[1].InsFreq.step64.v = 0x0000000100000000>>3;
    dpl->TRK.CHNL[2].InsFreq.InsRec = &dpl->pINS[7];
    dpl->TRK.CHNL[2].InsFreq.step64.v = 0x0000000100000000>>3;
    dpl->TRK.CHNL[3].InsFreq.InsRec = &dpl->pINS[7];
    dpl->TRK.CHNL[3].InsFreq.step64.v = 0x0000000100000000>>3;
    
    cayDigSmpSetPos(&dpl->TRK.CHNL[0].InsFreq,  0);
    cayDigSmpSetPos(&dpl->TRK.CHNL[1].InsFreq, 10);
    cayDigSmpSetPos(&dpl->TRK.CHNL[2].InsFreq, 20);
    cayDigSmpSetPos(&dpl->TRK.CHNL[3].InsFreq, 30);
*/
    
}



