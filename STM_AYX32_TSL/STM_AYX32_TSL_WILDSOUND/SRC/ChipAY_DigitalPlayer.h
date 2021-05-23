//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __CHIPAY_DIGITALPLAYER_H
#define __CHIPAY_DIGITALPLAYER_H

#include "SysType.h"
#include "ChipAY_DigitalSample.h"

#define chayDigPlayerChannelMAX             32
#define chayDigPlayerCacheBufferSize        (1024*2)      //Total Cache Buffer For Streamin Sample
#define chayDigPlayerCacheBufferUpDateFree  (256) //(chayDigPlayerCacheBufferSize-256) //768*4       //Wait For Free Data For Generate New Cacheing Process

#pragma push
#pragma pack(1)

typedef union {
  u32     OFS;
  u8     *DTA;
}tOFSPTR;

typedef struct {
   tOFSPTR        OFS;            //Offset To Data
   u32            SIZE;           //Packed Size
   u16            Rows;
}tPatternRec;

typedef struct {
   u32            Size;           //Whole Size Of Packed Data
   char           TrackName[20];
   u16            Channels;
   u16            TMP;
   u16            BPM;
   u16            FreqTable;
   u16            PatLen;
   u16            PatRes;
   u8             PatOrder[256];
   tPatternRec    PatREC[];    //tPatternRec    PatREC[256];
   //u8             PatDATA[];
}tPatternsPacked;

typedef struct {
   u8             Note;
   u8             Ins;
   u8             VolEFF;
   u8             EFF;
   u8             EFV;
}tPatData;

typedef tPatData tPatDataLine[chayDigPlayerChannelMAX];

#pragma pop

typedef struct {
   u8       Note;
   u8       RelativeTone;
   u8       Ins;
   u8       InsA;
   long     Vol;
   u8       EnvelopeVol;
   u8       FinalVol;
   u8       FinalVol_L;
   u8       FinalVol_R;
   u16      FinalVol_LR;
   u8       FinalPan;
   u8       EFF;
   u8       EFV;
   s8       FineTune;
   float    Period;
   float    Frequency;
}tPatLast;

typedef struct {
  u32             PATDPOS;    //Offest To Pattern Packed Data
  float           Period;
  float           Frequency;
  u32             LINE;
  u32             LINE_LOOP;
  u32             LINE_LOOPC;
  u32             CLINE;
  u32             POS;        //Curretn Position In PatternOrder
  u32             POSC;
  u32             PAT;        //Curretn Pattern
  u32             BPM;
  u32             TMP;
  long            TIK;
  long            TIKI;
  u8              SongEND;
  u8              PAT_PLAYED[256];
  u8              GlobalVol;
  tPatLast        PatLPREV[chayDigPlayerChannelMAX];
//     PatDPREV   :ARRAY[0..63] OF TPatData;
  struct {
    u8              Note;
    long            NoteArpeggio;
    u8              NoteO;
    u8              NoteOO;
    double          PeriodO;
    double          FrequencyO;
    long            Vol;
    u8              Ins;
    u8              InsA;
    u8              EnvelopeVol;
    u8              EFF;
    u8              EFV;
    double          Period;
    double          Frequency;
    double          PeriodR;
    double          FrequencyR;
    long            RelativeTone;
    long            PeriodPortamento;
    long            PeriodPortamentoO;
    long            FineTune;
    long            RelativeToneO;
    long            FineTuneO;
    long            RelativeToneOO;
    long            FineTuneOO;
    long            RelativePRES;
    u16             FinalVol;
    u8              FinalVol_L;
    u8              FinalVol_R;
    u16             FinalVol_LR;
    u32             SmpOfs;
  }               LineCUR[chayDigPlayerChannelMAX];
  tPatDataLine    PatDataLine;
}tXMCUR;

typedef struct {
  tInstrumentFreqency   InsFreq;
}tChannelPlayer;


typedef struct {
  tChannelPlayer  CHNL[chayDigPlayerChannelMAX];
  u32             STRM_WR;
  u32             STRM_RD;
  u32             DevFreq;
  u32             DevTacts;   //Current TACTS for generate sample data
  tXMCUR          XMCUR;
  tU8U16U32       STRMBUF[chayDigPlayerCacheBufferSize];
}tTrackPlayer;

typedef struct {
    struct {
      u8 TRK;      //Track Data
      u8 INH;      //Instruments Header
      u8 ARR[126]; //Array For Instruments
    }DSC;
    tInstrumentRec       *pINS;
    tPatternsPacked      *pPAT;
    u16                   PatNum;
    u16                   InsNum;
    u32                   SmpsPTR;     //Global Loader Samples Pointer
    tTrackPlayer          TRK;
}tDigitalPlayer;



extern tDigitalPlayer digPlayer;

extern u32 cayDigPlayerStreamSize(tDigitalPlayer *dpl);
extern u32 cayDigPlayerStreamFree(tDigitalPlayer *dpl);
extern u32 cayDigPlayerStreamGet(tDigitalPlayer *dpl);
extern void cayDigPlayerStreamWRStep(tDigitalPlayer *dpl, u32 step);
extern u16 cayDigPlayerExtractLine(tDigitalPlayer *dpl);
extern void cayDigPlayerGoToPatLine(tDigitalPlayer *dpl, u16 pat, u16 lin);
extern void cayDigPlayerGoToPosLine(tDigitalPlayer *dpl, u16 pos, u16 lin);
extern void cayDigPlayerGetPatDataSTR(tPatData *pdt, char *s);
//////////////////////////////////////////////////////////////
extern float PerFrCalc(tDigitalPlayer *dpl, u8 PatternNote, long RelativeTone, long FineTune, long PeriodPortamento);
extern u8 XM_ChekSongEND(tDigitalPlayer *dpl);
extern u8 XM_Player_STEP(tDigitalPlayer *dpl, float DEV_FREQ);
//////////////////////////////////////////////////////////////
extern u16 cayDigPlayerPool(tDigitalPlayer *dpl);
extern void cayDigPlayerInit(tDigitalPlayer *dpl, u32 FreqOut);


#endif
