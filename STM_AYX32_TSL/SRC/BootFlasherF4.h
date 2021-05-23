//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __BOOTFLASHERF4_H
#define __BOOTFLASHERF4_H

#include "SysType.h"
//#include "cortex_rb_sys.h"
//#include "core_UID.h"
//#include "rb_base64m.h"
//#include "rb_crc16.h"

#pragma push
#pragma pack(1)


typedef struct {
  u32 recsize;
  u32 blkadr;
  u32 blksiz;
  u16 blktyp;
  u32 dsize;
  u8 data[];
}t_bfl_BlockRec;

#define bfl_BlocksMax         8             // maximum blocks

typedef struct {
  u32 imgPos[bfl_BlocksMax+1];
  u16 imgCnt;
  u32 imgAddr;
}t_bfl_ImageRec;

#pragma pop


typedef struct {
  u32 Addr;           //
  u32 SecAddr;        //
  u32 SecSize;        //
  u32 SecNum;         //
}t_bfl_FlashSecAddr;

#define FlashBlockSize        (u32)(16*1024)          // Flash Memory Block Size for Align Erase

#define BLOCK_TYPES_BOOT_STATIC       0
#define BLOCK_TYPES_BOOT_FLASH        1
#define BLOCK_TYPES_DATA_FLASH        2
#define BLOCK_TYPES_UNCNOWN           0xAA

extern u32 flashsize(void);
extern u32 flashaddr(void); 
extern u32 flashtop(void);
extern u32 bflFlashSectorCfg(u32 adr, t_bfl_FlashSecAddr *flsad);
extern void bflFlashErase(u32 adr);
extern void bflFlashEraseAlignBLK(u32 adr, u32 siz);
extern void bflFlashWriteBlock(u32 addr, void *s, u32 siz);

extern void bflDataStart(void);
extern void bflDataAddByte(char c);
extern void bflDataAddBuffer(char *buf, u16 size);

extern u8 bflFlashCompareBlock(u32 addr, void *s, u32 siz);


extern u32 bflBootBlockAddr(u16 bnum);
extern u8 *bflBootBlockPBUF(u16 bnum);
extern t_bfl_BlockRec *bflBootBlockPTR(u16 bnum);
extern u8 bflBootCheckNeedFlashing(void);
extern u16 bflBootBlocksGetCRC(void);
extern u16 bflBootBlocks(void);

//extern __asm void bflBootExtremalExec(u8 *dest);
//extern __asm void bflBootExtremalCopyExec(u8 *dest, u8 *src, u32 size);
extern void bflBootExtremalExecFlash(void);

extern u16 bflBootFindByType(u16 typ);

extern void bflBootExtremalExecuteBlock(u16 bnum);
extern void bflBootExtremalExecuteBlockType(u16 typ);
extern void bflBootProgramBlock(u16 bnum);
extern void bflBootProgramBlockType(u16 typ);

extern void bflBootFlashDisable(void);

extern void bflImageStart(void);
extern u8 bflImageAddBlockA(u32 addr, void *sA, u32 sizA, void *sB, u32 sizB, u16 typ);
extern u8 bflImageAddBlock(u32 addr, void *s, u32 siz, u16 typ);
extern void bflImageFinish(void);



#endif
