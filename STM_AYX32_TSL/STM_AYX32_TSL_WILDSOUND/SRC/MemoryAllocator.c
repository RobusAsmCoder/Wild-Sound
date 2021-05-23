//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "MemoryAllocator.h"
#include "BootFlasherF4.h"
#include "hardware.h"
#include "interface.h"
#include "string.h"





///////////////////////////////////////////////////

t_malBaseRec malBaseList[malBaseListMax];
t_malDescriptor *malDesc;

#define DEF_malRegNameBase(_reg)    _reg##$$Base
#define DEF_malRegNameLength(_reg)  _reg##$$Length
#define DEF_malRegNameLimit(_reg)   _reg##$$Limit

#define DEF_malRegExt(_reg)                                                     \
  extern u32 DEF_malRegNameBase(_reg);                                          \
  extern u32 DEF_malRegNameLength(_reg);                                        \
  extern u32 DEF_malRegNameLimit(_reg);

#define DEF_malInitBaseRec(_str, _regS, _regL, _regE, _flag)                              \
  DEF_malRegExt(_regS);                                                                   \
  DEF_malRegExt(_regL);                                                                   \
  DEF_malRegExt(_regE);                                                                   \
  _str.BaseAddr = (u32)(&DEF_malRegNameBase(_regS));                                      \
  _str.BaseSize = (u32)(&DEF_malRegNameBase(_regE))-(u32)(&DEF_malRegNameBase(_regS));    \
  _str.FreeAddr = (u32)(&DEF_malRegNameLimit(_regL));                                     \
  _str.FreeSize = (u32)(&DEF_malRegNameBase(_regE))-(u32)(&DEF_malRegNameLimit(_regL));   \
  _str.Flag     = _flag;                                                                  \
  _str.WorkSize = 0;                                                                      \
  _str.NameS = (const char *)(#_regS);                                                    \
  _str.NameE = (const char *)(#_regE)
  
#define DEF_malInitBaseRecShow(_str, _regS, _regL, _regE, _flag)                          \
  DEF_malInitBaseRec(_str, _regS, _regL, _regE, _flag);                                   \
  ShowMalBaseRec(&_str)


///////////////////////////////////////////////////
#include "stdlib.h"


void ShowGroup(char *s, u32 *grp)
{
    char ss[]="......................... ";
    u32 len=strlen(s);
    memcpy(ss, s, len);
    Send_RS_String(ss);
    Send_RS_HEX(grp[0],8);
    Send_RS_String(" ");
    Send_RS_HEX(grp[1],8);
    Send_RS_String(" ");
    Send_RS_HEX(grp[2],8);
    Send_RS_String("\x0D\x0A");
}

void ShowMalBaseRec(t_malBaseRec *rec)
{
    char ss[]="......................... ";
    memcpy(ss, rec->NameS, strlen(rec->NameS));
    Send_RS_String(ss);
    Send_RS_HEX(rec->BaseAddr,8);
    Send_RS_String(".");
    Send_RS_HEX(rec->BaseSize,8);
    Send_RS_String(" ");
    Send_RS_HEX(rec->FreeAddr,8);
    Send_RS_String(".");
    Send_RS_HEX(rec->FreeSize,8);
    Send_RS_String("\x0D\x0A");
}

////////////////////////////////

void memalDescInit(u16 desNum)
{
    u32 descSize = sizeof(t_malDescriptor) + sizeof(t_malDescRec) * desNum;
    memset(malDesc, 0, descSize);
    malDesc->desNum = desNum;
    for (u16 n=0; n<desNum; n++)
    {
      malDesc->des[n].Addr = 0xFFFFFFFF;
    }
}

u32 memalDescFreeSize(void)
{
    return malDesc->desNum-malDesc->desCount;
}

void memalDescSetFlag(u32 desn, u16 flag)
{
    if (desn<malDesc->desNum)
    {
      malDesc->des[desn].Flag |= flag;
    }
}

void memalDescClrFlag(u32 desn, u16 flag)
{
    if (desn<malDesc->desNum)
    {
      malDesc->des[desn].Flag &= ~flag;
    }
}


u32 memalDescAllocate(void)
{
    u32 desn=mema_ERROR_DESCRIPTOR;
    if (memalDescFreeSize())
    {
      for (u16 n=0; n<malDesc->desNum; n++)
      {
        if (malDesc->des[n].Flag == 0)
        {
          memalDescSetFlag(n, mema_FLAG_ALLOCATED);
          desn = n;
          malDesc->desCount++;
          break;
        }
      }
    }
    return desn;
}

void memalDescFree(u32 desn)
{
    if (malDesc->desCount)
    {
      if (desn<malDesc->desNum)
      {
        if (malDesc->des[desn].Flag)
        {
          memset(&malDesc->des[desn], 0, sizeof(malDesc->des[desn]));
          malDesc->desCount--;
        }
      }
    }
}

u32 memalDescFindByAddr(u32 addr)
{
    u32 desn=mema_ERROR_DESCRIPTOR;
    for (u16 n=0; n<malDesc->desNum; n++)
    {
      if ( (malDesc->des[n].Flag) && (malDesc->des[n].Addr == addr) )
      {
        desn = n;
        break;
      }
    }
    return desn;
}

u32 memalDescGetAddr(u16 desn)
{
    u32 addr=mema_ERROR_DESCRIPTOR;
    if (desn<malDesc->desNum)
    {
      if (malDesc->des[desn].Flag)
      {
        addr = malDesc->des[desn].Addr;
      }
    }
    return addr;
}

u32 memalDescGetSize(u16 desn)
{
    u32 size=mema_ERROR_DESCRIPTOR;
    if (desn<malDesc->desNum)
    {
      if (malDesc->des[desn].Flag)
      {
        size = malDesc->des[desn].Size;
      }
    }
    return size;
}

u32 memalDescGetFlag(u16 desn)
{
    u32 flag=mema_ERROR_DESCRIPTOR;
    if (desn<malDesc->desNum)
    {
      flag = malDesc->des[desn].Flag;
    }
    return flag;
}

////////////////////////////////

u32 memalTotalSize(u16 memType)
{
    u32 siz=0;
    for (u16 n=0; n<malBaseListMax; n++)
    {
      if ( malBaseList[n].Flag & memType )
      {
        siz += malBaseList[n].FreeSize;
      }
    }
    return siz;
}

u32 memalBaseListByAddr(u32 addr)
{
    u32 ban=mema_ERROR_ADDR;
    for (u16 n=0; n<malBaseListMax; n++)
    {
      u32 adr0 =  malBaseList[n].BaseAddr;
      u32 adr1 =  adr0 + malBaseList[n].BaseSize - 1;
      if ( (adr0<=addr) && (addr<=adr1) )
      {
        ban = n;
      }
    }
    return ban;
}

//Return Base List number
u32 memalFindBaseListSize(u16 memType, u32 size)
{
    u32 ban=mema_ERROR_SIZE;
    u32 siz=0x7FFFFFFF; //MAX !!!
    for (u16 n=0; n<malBaseListMax; n++)
    {
      if ( malBaseList[n].Flag & memType )
      {
        u32 sz = malBaseList[n].FreeSize;
        if ( (siz>sz) && (size<=sz) )
        {
          siz = malBaseList[n].FreeSize;
          ban = n;
        }
      }
    }
    return ban;
}

//Return Addres of allocated memory 
u32 memalAllocateBaseListSize(u32 ban, u32 size)
{
    u32 adr = mema_ERROR_SIZE;
    if (ban<malBaseListMax)
    {
      if (size<=malBaseList[ban].FreeSize)
      {
        adr = malBaseList[ban].FreeAddr;
        malBaseList[ban].FreeSize -= size;
        malBaseList[ban].FreeAddr += size;
        malBaseList[ban].WorkSize += size;
      }
    }
    return adr;
}   

//Return Descriptor Number/ERROR
u32 memalMemDescAllocate(u16 memType, u32 size)
{
    u32 desn=memalDescAllocate();
    if ( !memalIsError(desn) )
    {
      u32 ban = memalFindBaseListSize(memType, size);
      if ( !memalIsError(ban) )
      {
        u32 adr=memalAllocateBaseListSize(ban, size);
        malDesc->des[desn].Addr = adr;
        malDesc->des[desn].Size = size;
        memalDescSetFlag(desn, malBaseList[ban].Flag & memType);
        if ( !(malBaseList[ban].Flag & mema_FLAG_ROM) )
        {
          memset(((u8 *)(adr)), 0, size);
        }
      } else {
        memalDescFree(desn);
        desn=ban;
      }
      
    }
    return desn;
}


//Release Only Out Of Range BLOCKs work only with RAM !!!
//Return Released Memory Block
u32 memalMemPackCut(void)
{
    u32 rel=0;
  
  
    for (u16 n=0; n<malBaseListMax; n++)
    {
      if (malBaseList[n].Flag & mema_FLAG_RAM)
      {
        u32 topaddr=malBaseList[n].FreeAddr - malBaseList[n].WorkSize;
        for (u16 m=0; m<malDesc->desNum; m++)
        {
          if (malDesc->des[m].Flag)
          {
            u32 bdr = malDesc->des[m].Addr;
            u32 ban = memalBaseListByAddr(bdr);
            if (ban==n)
            {
              u32 tadr=bdr + malDesc->des[m].Size;
              if (topaddr<tadr)
              {
                topaddr=tadr;
              }
            }
          }
        }
        if ( malBaseList[n].FreeAddr>topaddr )
        {
          u32 subsize=malBaseList[n].FreeAddr - topaddr;
          malBaseList[n].FreeAddr -= subsize;
          malBaseList[n].FreeSize += subsize;
          malBaseList[n].WorkSize -= subsize;
          rel += subsize;
        }
      }
    }
    return rel;
}

void memalMemDescFree(u32 desn)
{
    memalDescFree(desn);
    memalMemPackCut();
}

////////////////////////////////////////////////////
void memalWriteBLK(u32 desn, u32 aofs, u8 *buf, u32 size)
{
    if (desn<malDesc->desNum)
    {
      if (malDesc->des[desn].Flag)
      {
        if ( aofs < malDesc->des[desn].Size )
        {
          if ( (aofs+size) > malDesc->des[desn].Size ) size = malDesc->des[desn].Size - aofs;
          if (size)
          {
            u32 adr = malDesc->des[desn].Addr + aofs;
            if (malDesc->des[desn].Flag & mema_FLAG_RAM)
            {
              memcpy((u8 *)(adr), buf, size); //memcpy((u8 *)(&malDesc->des[desn].Addr)[adrofs], buf, size);
            } else {
              if (malDesc->des[desn].Flag & mema_FLAG_ROM)
              {
                bflFlashWriteBlock(adr, buf, size);
              }
            }
          }
        }
      }
    }
}

void memalFillBLK(u32 desn, u32 aofs, u8 val, u32 size)
{
    u8 buf[16];
    memset(buf, val, sizeof(buf));
    while (size)
    {
      u16 siz=sizeof(buf);
      if (siz>size) siz=size;
      memalWriteBLK(desn, aofs, buf, siz);
      aofs+=siz;
      size-=siz;
    }
}

////////////////////////////////////////////////////


void memalEraseAllData(void)
{
    for (u16 m=0; m<malDesc->desNum; m++)
    {
      memalDescFree(m);
    }
    memalMemPackCut();
    for (u16 n=0; n<malBaseListMax; n++)
    {
      if (malBaseList[n].Flag & mema_FLAG_ROM)
      {
        malBaseList[n].FreeSize += malBaseList[n].WorkSize;
        malBaseList[n].FreeAddr -= malBaseList[n].WorkSize;
        malBaseList[n].WorkSize  = 0;
        bflFlashEraseAlignBLK(malBaseList[n].FreeAddr, malBaseList[n].FreeSize);
      }
    }
}


//desNum = Number Of Descriptors
void memalInit(u16 memType, u16 desNum)
{
    u32 descSize = sizeof(t_malDescriptor) + sizeof(t_malDescRec) * desNum;
    memset(malBaseList, 0, sizeof(malBaseList));
    if (memType & mema_FLAG_ROM)
    {
      t_bfl_FlashSecAddr fsad;
      u32 skipsiz=0;
      DEF_malInitBaseRecShow(malBaseList[3], Load$$LR$$LR_IROM , Load$$LR$$LR_IROM     , Image$$EReIROM0, mema_FLAG_ROM);
      fsad.Addr = malBaseList[3].FreeAddr;
      bflFlashSectorCfg(fsad.Addr, &fsad);
      if (fsad.Addr!=fsad.SecAddr) fsad.Addr = fsad.SecAddr + fsad.SecSize;
      skipsiz = fsad.Addr - malBaseList[3].FreeAddr;
      malBaseList[3].FreeAddr += skipsiz;
      malBaseList[3].FreeSize -= skipsiz;
      ShowMalBaseRec(&malBaseList[3]);
    }
    if (memType & mema_FLAG_RAM)
    {
      DEF_malInitBaseRecShow(malBaseList[2],    Image$$RW_IRAM0,    Image$$RW_IRAM0$$ZI, Image$$RWeIRAM0, mema_FLAG_RAM);
      DEF_malInitBaseRecShow(malBaseList[1],    Image$$RW_IRAM1,    Image$$RW_IRAM1$$ZI, Image$$RWeIRAM1, mema_FLAG_RAM);
      DEF_malInitBaseRec    (malBaseList[0],    Image$$RW_IRAM2,    Image$$RW_IRAM2$$ZI, Image$$RWeIRAM2, mema_FLAG_RAM);
      // Need To Allocate Memory For Descriptors by staticMemory
      malDesc = (t_malDescriptor *)(malBaseList[0].FreeAddr);
      malBaseList[0].FreeAddr += descSize;
      malBaseList[0].FreeSize -= descSize;
      ShowMalBaseRec(&malBaseList[0]);
    } else {
      // Need To Allocate Memory For Descriptors by microLib
      malDesc = malloc(descSize);
    }
    memalDescInit(desNum);
}

void mallocShowDesc(u32 desn)
{
    if (desn<malDesc->desNum)
    {
      u32 adr = malDesc->des[desn].Addr;
      u32 siz = malDesc->des[desn].Size;
      Send_RS_HEX(desn,2);
      if (malDesc->des[desn].Flag)
      {
        Send_RS_String(":");
        Send_RS_HEX(adr,8);
        Send_RS_String(",");
        Send_RS_DEC(siz);
        Send_RS_String("\x0D\x0A");
        u32 ma=32;
        for (u32 n=0; n<siz; n++)
        {
          u8 b=*((u8 *)(adr));
          if ( (n%ma)==0 )
          {
            if (n)
            {
              Send_RS_String("\x0D\x0A");
            }
            Send_RS_HEX(adr,8);
            Send_RS_String(" ");
          }
          Send_RS_HEX(b,2);
          adr++;
        }
      } else {
        Send_RS_String(" NOT FOUND");
      }
      Send_RS_String("\x0D\x0A");
    }
}

////////////////////////////////////////////////////
void mallocTets(void)
{
    u32 de[32];
    Send_RS_String("---Allocator RAM----\x0D\x0A");
  
      ShowMalBaseRec(&malBaseList[1]);
    de[0] = memalMemDescAllocate(mema_FLAG_RAM, 30);
      ShowMalBaseRec(&malBaseList[1]);
    de[1] = memalMemDescAllocate(mema_FLAG_RAM, 30);
      ShowMalBaseRec(&malBaseList[1]);
  
    Send_RS_HEX(de[0],8); Send_RS_String("\x0D\x0A");
    Send_RS_HEX(de[1],8); Send_RS_String("\x0D\x0A");

/*    memalMemDescFree(de[1]);
      ShowMalBaseRec(&malBaseList[1]);
    memalMemDescFree(de[0]);
      ShowMalBaseRec(&malBaseList[1]);
*/
  
    Send_RS_String("---Allocator ROM----\x0D\x0A");
    ShowMalBaseRec(&malBaseList[3]);
//    {
//      t_bfl_FlashSecAddr fsad;
//      bflFlashSectorCfg(malBaseList[3].FreeAddr, &fsad);
//      bflFlashEraseAlignBLK(fsad.SecAddr, fsad.SecSize); //bflFlashErase(malBaseList[3].FreeAddr);
//    }

    de[2] = memalMemDescAllocate(mema_FLAG_ROM, 50);
    mallocShowDesc(de[2]);
    
    memalEraseAllData();
    
    de[2] = memalMemDescAllocate(mema_FLAG_ROM, 50);
    de[3] = memalMemDescAllocate(mema_FLAG_ROM, 50);
    mallocShowDesc(de[2]);
    mallocShowDesc(de[3]);
    
    char s[]="Super Puper Ofiget";
    memalWriteBLK(de[2], 40, (u8 *)s, sizeof(s));
    
    mallocShowDesc(de[2]);
    mallocShowDesc(de[3]);

      ShowMalBaseRec(&malBaseList[1]);


  
    /*Send_RS_String("---Flash Info ------\x0D\x0A");
    {
      //u32 adr = flashaddr();
      t_bfl_FlashSecAddr fsad={
        .Addr = flashaddr(),
      };
      u32 gsiz = 0;
      
      while (gsiz<flashsize())
      {
        bflFlashSectorCfg(fsad.Addr, &fsad);
        Send_RS_HEX(fsad.SecNum,2);
        Send_RS_String(" ");
        Send_RS_HEX(fsad.SecAddr,8);
        Send_RS_String(" ");
        Send_RS_DEC(fsad.SecSize/1024);
        Send_RS_String("K");
        Send_RS_String("\x0D\x0A");
        fsad.Addr += fsad.SecSize;
        gsiz += fsad.SecSize;
      }
    }*/
    
    Send_RS_String("--------------------\x0D\x0A");
  
  
}



