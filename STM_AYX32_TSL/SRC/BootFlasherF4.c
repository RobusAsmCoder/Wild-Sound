//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "BootFlasherF4.h"
#include "core_UID.h"
#include "rb_base64m.h"
#include "rb_crc16.h"
#include "string.h"

//#pragma push
//#pragma arm section code = "RAMCODE"
//#pragma arm section rwdata = "RAMCODE"
//#pragma arm section rodata = "RAMCODE"
//#pragma arm section zidata = "RAMCODE"


//////////////////////////////////
// Block Format:
//  + 0  x4 - Rec Size = 10
//  + 4 x10 - Rec
//            +0 x4 - addr Flashing
//            +4 x4 - size
//            +8 x2 - type
//  +14  x4 - Data Size
//  +18 x?? - Data
//
//////////////////////////////////


#if (BOOTFLASHER_LOG==1)
#include "interface.h"
#define SendLogSTR(_val_)           Send_DC0_String(_val_)
#define SendLogEN()                 SendLogSTR("\x0D\x0A")
#define SendLogHEX(_val_,_si_)      Send_DC0_HEX(_val_,_si_)
#define SendLogDEC(_val_)           Send_DC0_DEC(_val_)
#else
#define SendLogSTR(_val_)           
#define SendLogEN()                 
#define SendLogHEX(_val_,_si_)      
#define SendLogDEC(_val_)           
#endif


const u8 BFbase64mSTR[] = {BASE64_T_DEF};


#define fbuf_size         80
char fbuf[fbuf_size+1];
u16 fbufp=0;
u32 faddr=0;

t_bfl_ImageRec bflImgRec;

u8 *bflRecBlocksStart;
u32 bflRecBlocksSize;
u32 bflRecBlocksNum;
#define readMemRegB(_adr_)    ((u8 *)(_adr_))[0]
#define readMemRegW(_adr_)    ((u16 *)(_adr_))[0]
#define readMemRegD(_adr_)    ((u32 *)(_adr_))[0]

u32 flashsize(void)
{
    return CORE_UID->FlashSizeK*1024;
}

u32 flashaddr(void) 
{
    return 0x08000000;
}

u32 flashtop(void) 
{
    return flashaddr() + flashsize();
}


u32 bflFlashSectorCfg(u32 adr, t_bfl_FlashSecAddr *flsad)
{
    u32 sec=0;
    u32 ssiz = 16*1024;
    if ( (adr & 0x000F0000)==0 )
    { //16K ...
      sec = ((adr)>>11) & 0x78;
    } else {
      sec = (((adr)>>13)&0x78);
      if (sec!=0x08)
      {//128K ...
        sec=((sec>>1)&0x78) + 0x20;
        ssiz = 128*1024;
      } else {//64K ...
        sec+=0x18;
        ssiz = 64*1024;
      }
    }
    flsad->Addr = adr;
    flsad->SecNum = sec>>3;
    flsad->SecSize = ssiz;
    flsad->SecAddr = flashaddr() + ((adr & 0x000FFFFF) & (~(ssiz-1)));
    return sec;
}

void FLASH_ErasePage(u32 adr)
{
    t_bfl_FlashSecAddr flsad;
    u32 sec = bflFlashSectorCfg(adr, &flsad);
    FLASH_EraseSector(sec, VoltageRange_3);
}


void bflFlashErase(u32 adr)
{
    FLASH_Unlock();//unlock flash writing
    FLASH_ClearFlag(FLASH_FLAG_EOP | FLASH_FLAG_OPERR | FLASH_FLAG_WRPERR | FLASH_FLAG_PGAERR | FLASH_FLAG_PGSERR ); //FLASH_ClearFlag(FLASH_FLAG_EOP|FLASH_FLAG_PGERR|FLASH_FLAG_WRPRTERR);
    FLASH_ErasePage(adr);//erase the entire page before you can write as I //mentioned
    FLASH_Lock();//lock the flash for writing
    FLASH_InstructionCacheReset();
    FLASH_DataCacheReset();
}



void bflFlashEraseAlignBLK(u32 adr, u32 siz)
{
  
    u32 addr = adr & (~(FlashBlockSize-1));
    s32 size = siz + (adr-addr);
  
    while(size>0)
    {
      u32 d=0xFFFFFFFF;
      u32 sz=FlashBlockSize>>2;
      u32 a=addr;
      while(sz)
      {
        d &= readMemRegD(a);//((u32 *)a)[0];
        a+=4;
        sz--;
      }
      if (d!=0xFFFFFFFF)
      {
        bflFlashErase(addr);
      }
      addr += FlashBlockSize;
      size -= FlashBlockSize;
    }
  
  
}

//return true if blocks compared
u8 bflFlashCompareBlock(u32 addr, void *s, u32 siz)
{
    u8 *fadr = &((u8 *)(addr))[0];
    u8 *padr = s;
    u32 n;
    for (n=0; n<siz; n++)
    {
      if (fadr[n]!=padr[n]) return 0;
    }
    return 1;
  
}
//addr = TO flash
//  *s = FROM addr
//size = size
void bflFlashWriteBlock(u32 addr, void *s, u32 siz)
{
    if (siz)
    {
      u32 adr=addr;
      u8 *ss=s;
      u16 w=0xFF00;
      FLASH_Unlock();//unlock flash writing
      FLASH_ClearFlag(FLASH_FLAG_EOP | FLASH_FLAG_OPERR | FLASH_FLAG_WRPERR | FLASH_FLAG_PGAERR | FLASH_FLAG_PGSERR );  //FLASH_ClearFlag(FLASH_FLAG_EOP|FLASH_FLAG_PGERR|FLASH_FLAG_WRPRTERR);
      //FLASH_ErasePage(adr);//erase the entire page before you can write as I //mentioned
      //FLASH_ProgramHalfWord(adr,d);
      if (adr&1)
      {
        //adr--;
        
      }
      while (siz)
      {
        w = (w>>8)|(ss[0]<<8);
        adr++;
        ss++;
        siz--;
        if ((adr&1)==0)
        {
          FLASH_ProgramHalfWord(adr-2,w);
        }
      }
      if (adr&1)
      {
        w = (w>>8) | 0xFF00;
        FLASH_ProgramHalfWord(adr-1,w);
      }
      FLASH_Lock();//lock the flash for writing
      FLASH_InstructionCacheReset();
      FLASH_DataCacheReset();
    }
}


void bflDataStart(void)
{
    fbufp=0;
    faddr=0;
    BASE64m_Init(&bas64m, BFbase64mSTR);
}

void bflDataAddByte(char c)
{
    u8 isEnter = (c==0x0D) || (c==0x0A);
    u16 si;
    u32 d;
  
    char cmd;
    if (fbufp<fbuf_size)
    {
      if ( !isEnter )
      {
        fbuf[fbufp++]=c;
      }
    }
    if ( isEnter )
    {
      if ( fbufp )
      {
        cmd = fbuf[0];
        fbuf[fbufp]=0;
        si = BASE64m_DeCode(&bas64m, &fbuf[1], (u8 *)&fbuf[0]);
        
        switch(cmd)
        {
          case '*': //Size
            d = uu32(fbuf[0]);
            if ( (si>=4) && (d<(flashsize()<<1)) )
            {
              faddr =  flashtop() - d;
              bflFlashEraseAlignBLK(faddr, d);
              SendLogSTR("E ");
              SendLogHEX(faddr,8);
              SendLogSTR(",");
              SendLogHEX(d,8);
              SendLogSTR(" ");
              SendLogEN();
              
            } else {
              faddr=0;
            }
            break;
          case '+': //Data
            if (faddr)
            {
              bflFlashWriteBlock(faddr, &fbuf[0], si);
              SendLogSTR("W ");
              SendLogHEX(faddr,8);
              SendLogSTR(" ");
              for (u32 n=0; n<si; n++)
              {
                //SendLogHEX(fbuf[n],2);
              }
              //SendLogSTR(" ");
              SendLogDEC(si);
              SendLogSTR(" ");
              SendLogEN();
              
              faddr += si;
            }
            break;
          case '$': //Finish
            SendLogSTR("F ");
            SendLogHEX(faddr,8);
            SendLogSTR(" ");
            SendLogEN();
            bflDataStart();
            break;
        }
        fbufp=0;
      }
    }
}

void bflDataAddBuffer(char *buf, u16 size)
{
    u16 n=0;
    while(size)
    {
      bflDataAddByte(buf[n++]);
      size--;
    }
}

//////////////////////////////////////////////

u16 bflBootBlocks(void)
{
        u32 a=flashtop()-4;
        u32 n=0;
        u32 d;
        //bflRecBlocksStart = &((u8 *)(flashaddr()))[0];//&readMemRegB(flashaddr());
        bflRecBlocksSize=0;
        while ( ((d=readMemRegD(a)) != 0xFFFFFFFF) && (n<bfl_BlocksMax) )
        {
          if (bflRecBlocksSize<d)
          {
            bflRecBlocksSize=d+(n+1)*4;
          }
          a-=4;
          n++;
        }
        if ( d!=0xFFFFFFFF )
        {
          bflRecBlocksSize=0;
          n=0;
        }
        bflRecBlocksStart = &((u8 *)(flashtop()-bflRecBlocksSize))[0];
        bflRecBlocksNum = n;
        return n;
}

u16 bflBootBlocksGetCRC(void)
{
        u16 crc16=0x0000;
        u16 blks=bflBootBlocks();
        if (blks)
        {
          crc16 = crc16_blk_CCITT(bflRecBlocksStart, bflRecBlocksSize);
        }
        return crc16;
}

u32 bflBootBlockAddr(u16 bnum)
{
      u32 a=0;
      if ( bnum<bflRecBlocksNum )
      {
        a=flashtop()-4*(bnum+1);
        u32 d=readMemRegD(a);
        a = a-d;
      }
      return a;
}

u8 *bflBootBlockPBUF(u16 bnum)
{
      return &((u8 *)(bflBootBlockAddr(bnum)))[0];
}

t_bfl_BlockRec *bflBootBlockPTR(u16 bnum)
{
      return &((t_bfl_BlockRec *)(bflBootBlockAddr(bnum)))[0];
}


u8 bflBootCheckNeedFlashing(void)
{
        //flashtop();
  
        u16 blks=bflBootBlocks();
        if (blks)
        {
          u16 crc16 = bflBootBlocksGetCRC();
          u16 w = uu16(bflRecBlocksStart[-2]);
          if ( crc16 == w )
          {
            return 1;
          }
        }
        return 0;
}

__asm void bflBootExtremalExec(u8 *dest)
{
                //CPSID   I
                LDR     SP,[R0, #0]
                LDR     R0,[R0, #4]
                BX      R0
}

//R0 = *dest
//R1 = *src
//R2 = size
__asm void bflBootExtremalCopyExec(u8 *dest, u8 *src, u32 size)
{
                CPSID   I
                MOV     R3,R0
mLoop
                LDRB    R10,[R1]
                STRB    R10,[R3]
                ADD     R1,R1,#1
                ADD     R3,R3,#1
                SUBS    R2,R2,#1
                BCS     mLoop
                LDR     SP,[R0, #0]
                LDR     R0,[R0, #4]
                BX      R0
}

void bflBootExtremalExecFlash(void)
{
//   NVIC_SCBDeInit();
   __asm{
     CPSIE   I
   }
   NVIC_SystemReset(); //bflBootExtremalExec((u8 *)(flashaddr()));
}

void bflBootExtremalExecuteBlock(u16 bnum)
{
      t_bfl_BlockRec *blk = bflBootBlockPTR(bnum);
//      __disable_irq();
      bflBootExtremalCopyExec( (u8 *)(blk->blkadr), blk->data, blk->blksiz);
}

//return number of block if find
//       else return 0xFFFF
u16 bflBootFindByType(u16 typ)
{
        u32 n;
        u16 blks=bflBootBlocks();
        if (blks)
        {
          for (n=0; n<blks; n++)
          {
            t_bfl_BlockRec *blk = bflBootBlockPTR(n);
            if (blk->blktyp == typ)
            {
              return n;
            }
          }
        }
        return 0xFFFF;
}

void bflBootExtremalExecuteBlockType(u16 typ)
{
//BLOCK_TYPES_BOOT_STATIC
    u16 w=bflBootFindByType(typ);
    if (w!=0xFFFF)
    {
      bflBootExtremalExecuteBlock(w);
    }
}

void bflBootProgramErase(u32 addr, void *s, u32 siz)
{/*
    u8 *fadr = &((u8 *)(addr))[0];
    u8 *padr = s;
    u32 n;
    for (n=0; n<siz; n++)
    {
      if (fadr[n]!=padr[n]) return 0;
    }
    */
    const u32 maxsafeblock = FlashBlockSize*2;
  
    if ( (addr>=flashaddr()) && (addr<(flashaddr()+maxsafeblock)) && (siz>maxsafeblock) )
    {
      bflBootProgramErase(addr+maxsafeblock, &((u8 *)(s))[maxsafeblock], siz-maxsafeblock );
      bflBootProgramErase(addr, s, maxsafeblock );
    } else {
      if ( !bflFlashCompareBlock(addr, s, siz) )
      {
        bflFlashEraseAlignBLK(addr, siz);
        bflFlashWriteBlock(addr, s, siz);
      }
    }
  
}

void bflBootProgramBlock(u16 bnum)
{
    t_bfl_BlockRec *blk = bflBootBlockPTR(bnum);
    if ( (blk->blkadr>=flashaddr()) && (blk->blkadr<flashtop()) )
    {
      /*
      if ( !bflFlashCompareBlock(blk->blkadr, blk->data, blk->blksiz) )
      {
        bflFlashEraseAlignBLK(blk->blkadr, blk->blksiz);
        bflFlashWriteBlock(blk->blkadr, blk->data, blk->blksiz);
      }
      */
      bflBootProgramErase(blk->blkadr, blk->data, blk->blksiz);
    }
}

void bflBootProgramBlockType(u16 typ)
{
    u16 w=bflBootFindByType(typ);
    if (w!=0xFFFF)
    {
      bflBootProgramBlock(w);
    }
}


void bflBootFlashDisable(void)
{
      const u32 size=128;
      bflFlashEraseAlignBLK(flashtop()-size, size);
}

////////////////////////////////
// Block Creator
////////////////////////////////

void bflImageStart(void)
{
    bflBootFlashDisable();
    memset(&bflImgRec, 0, sizeof(bflImgRec));
    bflImgRec.imgAddr = flashtop()-sizeof(bflImgRec.imgPos);
    bflImgRec.imgPos[0] = 0xFFFFFFFF;
    bflImgRec.imgCnt = bfl_BlocksMax;
}

//return free blocks
u8 bflImageAddBlockA(u32 addr, void *sA, u32 sizA, void *sB, u32 sizB, u16 typ)
{
    u32 siz = sizA + sizB;
    if (bflImgRec.imgCnt)
    {
      t_bfl_BlockRec rec={
        .recsize = sizeof(t_bfl_BlockRec)-4-4,
        .blkadr  = addr,
        .blksiz  = siz,
        .blktyp  = typ,
        .dsize   = siz,
      };
      u16 bnum = bflImgRec.imgCnt;
      u32 bsiz = sizeof(rec) + siz;
      bflImgRec.imgAddr -= bsiz;
      u32 bofs = (flashtop() - sizeof(bflImgRec.imgPos) + (bnum*4)) - bflImgRec.imgAddr;
      bflImgRec.imgPos[bnum] = bofs;
      
      bflFlashWriteBlock(bflImgRec.imgAddr, (u8 *)(&rec), sizeof(rec));
      bflFlashWriteBlock(bflImgRec.imgAddr+sizeof(rec),      sA, sizA);
      bflFlashWriteBlock(bflImgRec.imgAddr+sizeof(rec)+sizA, sB, sizB);
      
      bflImgRec.imgCnt--;
    }
    return bflImgRec.imgCnt;
}


u8 bflImageAddBlock(u32 addr, void *s, u32 siz, u16 typ)
{
    return bflImageAddBlockA(addr, s, siz, 0, 0, typ);
}
/*
u8 bflImageAddBlock(u32 addr, void *s, u32 siz, u16 typ)
{
    if (bflImgRec.imgCnt)
    {
      t_bfl_BlockRec rec={
        .recsize = sizeof(t_bfl_BlockRec)-4-4,
        .blkadr  = addr,
        .blksiz  = siz,
        .blktyp  = typ,
        .dsize   = siz,
      };
      u16 bnum = bflImgRec.imgCnt;
      u32 bsiz = sizeof(rec) + siz;
      bflImgRec.imgAddr -= bsiz;
      u32 bofs = (flashtop() - sizeof(bflImgRec.imgPos) + (bnum*4)) - bflImgRec.imgAddr;
      bflImgRec.imgPos[bnum] = bofs;
      
      bflFlashWriteBlock(bflImgRec.imgAddr, (u8 *)(&rec), sizeof(rec));
      bflFlashWriteBlock(bflImgRec.imgAddr+sizeof(rec), s, siz);
      
      bflImgRec.imgCnt--;
    }
    return bflImgRec.imgCnt;
}
*/

void bflImageFinish(void)
{
    while (bflImgRec.imgCnt)
    {
      bflImageAddBlock(0, 0, 0,  BLOCK_TYPES_UNCNOWN);
    }
    u32 aip = flashtop()-sizeof(bflImgRec.imgPos);
    u32 asi = aip - bflImgRec.imgAddr;
    u16 crc16 = crc16_blk_CCITT((u32 *)(bflImgRec.imgAddr), asi);
    crc16 = crc16_blk(&bflImgRec.imgPos[0], sizeof(bflImgRec.imgPos), crc16);
    
    bflFlashWriteBlock(bflImgRec.imgAddr-2, &crc16, 2);
    bflFlashWriteBlock(aip ,bflImgRec.imgPos, sizeof(bflImgRec.imgPos));
}

//#pragma pop
