//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __CHIPAY_STREAMDATA_H
#define __CHIPAY_STREAMDATA_H

#include "SysType.h"
#include "rb_fifo.h"
#include "ChipAY_DigitalPlayer.h"

#define chipAY_StreamFifoSize     128



enum {
  cays_FLAG_DODONE  = (s32)(1<<0),
  cays_FLAG_ERROR   = (s32)(1<<1),
  cays_CMD_NOP      = 0x0000,
  cays_CMD_CLEAR    = 0x0001,
  cays_CMD_ERASE    = 0x0002,
  cays_CMD_XMAST    = 0x0010,
  cays_CMD_XMADO    = 0x0011,
  cays_CMD_XMBST    = 0x0020,
  cays_CMD_XMBDO    = 0x0021,
  cays_CMD_DIGPLAY  = 0x0030,
};

#define chypAyStreamBufferSize    32      //For Cache Data  minimum size must be sizeof(tInstrumentRec) = 21 !!! need for parser

typedef u32 (tStrmParsProc)(void *, u32, u32);

typedef struct {
  Trb_fifo           *fifIN;
  Trb_fifo           *fifOUT;
  u16                 CMD;
  u16                 STP;
  u32                 SIZE;
  u32                 POS;
  u32                 flag;
  tDigitalPlayer     *DigPlayer;
  u16                 DESC;
  u32                 DESCp;
  tStrmParsProc      *CacheParser;
  u16                 cPOS;
  u8                  cBUF[chypAyStreamBufferSize];
}t_chypAyStream;

extern u32 cayStrmCacheDescMemParsingNOP(t_chypAyStream *cstm, u32 parA, u32 flag);


extern t_chypAyStream chipAY_Stream;

extern u16 cayStrmFifoINwrFree(t_chypAyStream *cstm);
extern u16 cayStrmFifoINwrSize(t_chypAyStream *cstm);
extern void cayStrmFifoINwrClear(t_chypAyStream *cstm);
extern void cayStrmFifoINwrB(t_chypAyStream *cstm, u8 b);
extern u8 cayStrmFifoINrdB(t_chypAyStream *cstm);
extern u16 cayStrmFifoOUwrFree(t_chypAyStream *cstm);
extern u16 cayStrmFifoOUwrSize(t_chypAyStream *cstm);
extern void cayStrmFifoOUwrClear(t_chypAyStream *cstm);
extern void cayStrmFifoOUwrB(t_chypAyStream *cstm, u8 b);
extern u8 cayStrmFifoOUrdB(t_chypAyStream *cstm);

extern u32 cayStrmFlagGet(t_chypAyStream *cstm);
extern void cayStrmFlagSet(t_chypAyStream *cstm, u32 fl);
extern void cayStrmFlagClr(t_chypAyStream *cstm, u32 fl);
extern void cayStrmCmdSet(t_chypAyStream *cstm, u16 cmd);
extern void cayStrmClear(t_chypAyStream *cstm);
extern void cayStrmPool(t_chypAyStream *cstm);


#endif
