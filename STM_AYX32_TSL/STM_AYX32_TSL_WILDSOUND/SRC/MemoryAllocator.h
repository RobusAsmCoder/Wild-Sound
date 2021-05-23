//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __MEMORYALLOCATOR_H
#define __MEMORYALLOCATOR_H

#include "SysType.h"

typedef struct {
  u32 BaseAddr;
  u32 BaseSize;
  u32 FreeAddr;
  u32 FreeSize;
  u32 WorkSize;
  u16 Flag;   // Memory Type
  const char *NameS;
  const char *NameE;
}t_malBaseRec;

typedef struct {
  u32 Addr;
  u32 Size;
  u16 Flag;   // Memory Type
}t_malDescRec;

typedef struct {
  u16           desCount;
  u16           desNum;
  t_malDescRec  des[];
}t_malDescriptor;

enum {
  mema_FLAG_ROM         = (u16)(1<< 0),
  mema_FLAG_RAM         = (u16)(1<< 1),
  mema_FLAG_ROMRAM      = mema_FLAG_ROM | mema_FLAG_RAM,
  mema_FLAG_STATIC      = (u16)(1<< 2),
  mema_FLAG_LOCK        = (u16)(1<< 3),
  mema_FLAG_ALLOCATED   = (u16)(1<<15),
  
};

#define mema_ERROR_SIZE               (u32)(0xFFFFFFFF)
#define mema_ERROR_DESCRIPTOR         (u32)(0xFFFFFFFE)
#define mema_ERROR_ADDR               (u32)(0xFFFFFFFD)

#define memalIsError(_var)  ((u8)((_var)>>24)==0xFF)


#define malBaseListMax    4       //#define malBaseListMax    (sizeof(malBaseList)/sizeof(t_malBaseRec))
extern t_malBaseRec malBaseList[malBaseListMax];
extern t_malDescriptor *malDesc;


extern void memalEraseAllData(void);
extern void memalInit(u16 memType, u16 desNum);
extern u32 memalDescGetAddr(u16 desn);
extern u32 memalDescGetSize(u16 desn);
extern u32 memalDescGetFlag(u16 desn);
extern u32 memalTotalSize(u16 memType);

extern u32 memalMemDescAllocate(u16 memType, u32 size);
extern void memalMemDescFree(u32 desn);
extern void memalWriteBLK(u32 desn, u32 aofs, u8 *buf, u32 size);
extern void memalFillBLK(u32 desn, u32 aofs, u8 val, u32 size);


extern void mallocTets(void);


#endif
