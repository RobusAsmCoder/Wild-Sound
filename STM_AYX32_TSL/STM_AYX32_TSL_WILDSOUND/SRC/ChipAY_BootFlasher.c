//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "hardware.h"
#include "interface.h"
#include "ChipAY_BootFlasher.h"
#include "ChipAY_Main.h"
#include "ChipAY_Test.h"
#include "ChipAY_WildSound.h"
#include "ChipAY_Interrupt.h"
#include "ChipAY_Hardware.h"
#include "BootFlasherF4.h"
#include "string.h"


#define fwBootStaticADDR    0x20000000
#define fwBootStaticTYPE    BLOCK_TYPES_BOOT_STATIC
const u8 fwBootStatic[]={
  #include "..\..\BootFlasherMemoryStatic\OBJ\STM_BootFlasherMemoryStatic.inc"
};
#define fwBootFlashADDR     0x08000000
#define fwBootFlashTYPE     BLOCK_TYPES_BOOT_FLASH
const u8 fwBootFlash[]={
  #include "..\..\BootFlasherMemoryFlash\OBJ\STM_BootFlasherMemoryFlash.inc"
};
#define fwDataFlashADDR     0x08000000
#define fwDataFlashTYPE     BLOCK_TYPES_DATA_FLASH


//const u8 fwFirmWareWS[]={
//  #include "..\..\STM_AYX32_TSL_WILDFIRMWARE\OBJ\STM_AYX32_TSL_WILDFIRMWARE.inc"
//};


const u8 binBootTSL[]={
  #include "..\..\TMT\BININC\boot.inc"
};


#pragma pack(1)
typedef struct
{
  u16 hdr;      // Header version always 1
  u16 hw;       // H/W version
  u16 fw;       // F/W version
  u16 offs;     // data offset
  u32 size;     // F/W size
  u16 crc[];    // CRC16 for chunks (one per 256, 768 bytes max)
} FW_HDR;
#pragma pack()



void chayBootFlashDo(void)
{

          //__disable_irq();
          //bflBootFlashDisable();
          //bflFlashWriteBlock(flashtop()-sizeof(fwtest), &fwtest, sizeof(fwtest) );
          
          FW_HDR *fwts = (void *)(fwCCRMAM_ADDR);
          u8 *p = (void *)((u32)(fwts)+fwts->offs);
          u32 fwsize = fwts->size;
          //TEST FOR PERSONAL FW
          //fwsize = sizeof(fwFirmWareWS);
          //memcpy(p, fwFirmWareWS, fwsize);
          ////////////////////////
          /* u8 *pp = &p[-0x00008000];
          memset(pp, 0xFF, 0x00008000);
          memcpy(pp, binBootTSL, sizeof(binBootTSL)); */
          //u32 ppsize = fwsize+0x00008000;
  
  
          
          Send_RS_String("Flashing Size: ");
          Send_RS_DEC(ayStr.WORK_FW_SIZE);
          Send_RS_String("(");
          Send_RS_DEC(fwsize);
          Send_RS_String(") ");
          DelayMS(100);
          bflImageStart();
          ayStr.WORK_ERROR = TSL_AYX32_E_DONE;
          ayStr.WORK_STATUS &= ~TSL_AYX32_S_BUSY;
          DelayMS(500);
          Send_RS_String(".");
          bflImageAddBlock(fwBootStaticADDR, (void *)&fwBootStatic, sizeof(fwBootStatic), fwBootStaticTYPE);
          Send_RS_String(".");
          bflImageAddBlock(fwBootFlashADDR, (void *)&fwBootFlash, sizeof(fwBootFlash), fwBootFlashTYPE);
          Send_RS_String(".");
          bflImageAddBlockA(fwDataFlashADDR, (void *)&binBootTSL, 0x00008000, p, fwsize, fwDataFlashTYPE); //bflImageAddBlockA(fwDataFlashADDR, pp, ppsize, fwDataFlashTYPE);
          
          Send_RS_String(".");
          bflImageFinish();
          Send_RS_String(" OK\x0D\x0A");
          DelayMS(100);
          if (bflBootCheckNeedFlashing())
          {
            //NVIC_SystemReset(); //bflBootExtremalExecuteBlockType(BLOCK_TYPES_BOOT_STATIC);
          }
          
          //ayStr.WORK_STATUS &= ~TSL_AYX32_S_DRQ;
          //bflFlashErase( flashaddr() );
          __nop();


}






