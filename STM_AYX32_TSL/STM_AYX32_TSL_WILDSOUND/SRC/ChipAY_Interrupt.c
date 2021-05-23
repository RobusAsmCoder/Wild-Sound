//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "ChipAY_Interrupt.h"
#include "ChipAY_Hardware.h"
#include "ChipAY_WildSound.h"
#include "ChipAY_StreamData.h"
#include "ChipAY_DigitalPlayer.h"
#include "MemoryAllocator.h"
#include "hdinterrupt.h"
#include "rb_util.h"
#include "hardware.h"
#include "interface.h"
#include <cstddef>
#include <string.h>
#include <ctype.h>

//R[ 0, 1] - TONE A
//R[ 2, 3] - TONE B
//R[ 4, 5] - TONE C
//R[ 6]    - NOISE
//R[ 7]    - MIX
//R[ 8]    - VOL A
//R[ 9]    - VOL B
//R[10]    - VOL C
//R[11,12] - ENV 
//R[13]    - ENV EFF


// OUT 65533,255    - sl CHIP 0
// OUT 65533,254    - sl CHIP 1
// OUT 65533,3      - wr REG=3
// OUT 49149,34     - wr DTA=34
// IN  65533        - rd DTA 




//__attribute__((section("ROMCODE")))
//__attribute__((section("RAMCODE")))
//__attribute__((section("ccmram")))
#define ayMemeorySection    "ccmram"
//#define ayMemReg    __attribute__((section(ayMemeorySection)))

#pragma push
#pragma arm section code = "ccmram"
#pragma arm section rwdata = "ccmram"
#pragma arm section rodata = "ccmram"
#pragma arm section zidata = "ccmram"



//TABLE generator for update Set/Clear GPIOB8..15
#define tblTslGen001(v)     (u32)( ((((u32)(v)) & 0xFF) | (((~(u32)(v)) & 0xFF)<<16) ) << 8 )
#define tblTslGen002(v)    tblTslGen001((v)), tblTslGen001((v)+  1)
#define tblTslGen004(v)    tblTslGen002((v)), tblTslGen002((v)+  2)
#define tblTslGen008(v)    tblTslGen004((v)), tblTslGen004((v)+  4)
#define tblTslGen016(v)    tblTslGen008((v)), tblTslGen008((v)+  8)
#define tblTslGen032(v)    tblTslGen016((v)), tblTslGen016((v)+ 16)
#define tblTslGen064(v)    tblTslGen032((v)), tblTslGen032((v)+ 32)
#define tblTslGen128(v)    tblTslGen064((v)), tblTslGen064((v)+ 64)
#define tblTslGen256(v)    tblTslGen128((v)), tblTslGen128((v)+128)
//ayMemReg
const u32 outDataForTslPort[256]={
  tblTslGen256(0)
};



//const void (*tbl_AYREGPER_proc[32])(void);

//void asd(void)
//{
//}

//
//void (*tbl_AYREGPER_proc[1])(void) ={asd};
//

//ayMemReg
//volatile tAdrHL ad;//={  .adHL = (u16)ayStr.ay[ayStr.ayn].adr, };

#define tonOFS     (-1)
#define envOFS     (-1)

//ayMemReg
static __forceinline u16 prcAYtneMAX(u16 vvv)
{
    const u16 vv = vvv & 0x0FFF;
    const u16 v = vv;// ? vv : 1;
    u16 t = v + tonOFS;
    return (t & 0x8000) ? 0 : t;
}

//ayMemReg
static __forceinline u16 prcAYenvMAX(u16 vvv)
{
    const u16 vv = vvv;
    const u16 v = vv;// ? vv : 1;
    u32 t = v + envOFS;
    return (t & 0xFFFF0000) ? 0 : t;
}

//#define prcAYnoiMAX(_v)     ((_v) & 0x1F)
//ayMemReg
static __forceinline u16 prcAYnoiMAX(u8 v)
{
    const u8 vv=v & 0x1F;
    return vv ? vv : 1;
}

//typedef void(*)(void) tVoidProc;
void prcAY0prcR00(void) { AYxPERcur(AY0TONEA) = prcAYtneMAX(ayStr.ay[0].REG.ST.TONE[0]);        }
void prcAY0prcR02(void) { AYxPERcur(AY0TONEB) = prcAYtneMAX(ayStr.ay[0].REG.ST.TONE[1]);        }
void prcAY0prcR04(void) { AYxPERcur(AY0TONEC) = prcAYtneMAX(ayStr.ay[0].REG.ST.TONE[2]);        }
void prcAY0prcR06(void) { AYxPERupd(AY0NOI,     prcAYnoiMAX(ayStr.ay[0].REG.ST.NOISE)       );  }
void prcAY0prcR0B(void) { AYxPERupd(AY0ENV,     prcAYenvMAX(ayStr.ay[0].REG.ST.ENV  )       );  }
void prcAY0prcR0D(void) { AYxCNTcur(AY0ENV)   = 0x0000;     ayStr.ay[0].REG.ST.ENVFLG=0;        }
void prcAY0prcR18(void) { AYxPWMupd(AY0TONEA,               ayStr.ay[0].REG.ST.PWM[0]       );  }
void prcAY0prcR19(void) { AYxPWMupd(AY0TONEB,               ayStr.ay[0].REG.ST.PWM[1]       );  }
void prcAY0prcR1A(void) { AYxPWMupd(AY0TONEC,               ayStr.ay[0].REG.ST.PWM[2]       );  }


void prcAY1prcR00(void) { AYxPERcur(AY1TONEA) = prcAYtneMAX(ayStr.ay[1].REG.ST.TONE[0]);        }
void prcAY1prcR02(void) { AYxPERcur(AY1TONEB) = prcAYtneMAX(ayStr.ay[1].REG.ST.TONE[1]);        }
void prcAY1prcR04(void) { AYxPERcur(AY1TONEC) = prcAYtneMAX(ayStr.ay[1].REG.ST.TONE[2]);        }
void prcAY1prcR06(void) { AYxPERupd(AY1NOI,     prcAYnoiMAX(ayStr.ay[1].REG.ST.NOISE)       );  }
void prcAY1prcR0B(void) { AYxPERupd(AY1ENV,     prcAYenvMAX(ayStr.ay[1].REG.ST.ENV  )       );  }
void prcAY1prcR0D(void) { AYxCNTcur(AY1ENV)   = 0x0000;     ayStr.ay[1].REG.ST.ENVFLG=0;        }
void prcAY1prcR18(void) { AYxPWMupd(AY1TONEA,               ayStr.ay[1].REG.ST.PWM[0]       );  }
void prcAY1prcR19(void) { AYxPWMupd(AY1TONEB,               ayStr.ay[1].REG.ST.PWM[1]       );  }
void prcAY1prcR1A(void) { AYxPWMupd(AY1TONEC,               ayStr.ay[1].REG.ST.PWM[2]       );  }

//Read IOA
void prcAYRprcR0E(void)
{
    u8 b=ayStr.ay[ayStr.ayn].REG.R[14];
    switch (ayStr.WORK_TRANS_TYPE & (~TRANS_MODE_USART_READY))
    {
      case TRANS_MODE_USART_SET_ZXUNO:
        b = (b & (~(1<<UNO_RSBIT_RX))) | ((USARTZXUNO_RX()&1)<<UNO_RSBIT_RX);
        break;
      case TRANS_MODE_USART_SET_ZXBURYAK:
        b = (b & (~(1<<BUR_RSBIT_RX))) | ((BURYAK_AY_RX()&1)<<BUR_RSBIT_RX);
        //b = 123;
        break;
      case TRANS_MODE_USART_SET_ZXIOA:
        b = hdPinAYIOA_Read();
        break;
    }
    ayStr.ay[ayStr.ayn].REG.R[14] = b;
}
//Write IOA
void prcAYWprcR0E(void)
{
    u8 b;
    b=ayStr.ay[ayStr.ayn].REG.R[14];
    switch (ayStr.WORK_TRANS_TYPE & (~TRANS_MODE_USART_READY))
    {
      case TRANS_MODE_USART_SET_ZXUNO:
        USARTZXUNO_TX( (b>>UNO_RSBIT_TX)&1 );
        break;
      case TRANS_MODE_USART_SET_ZXBURYAK:
        BURYAK_AY_TX( (b>>BUR_RSBIT_TX)&1 );
        BURYAK_AY_CTS( (b>>BUR_RSBIT_CTS)&1 );
        break;
      case TRANS_MODE_USART_SET_ZXIOA:
        hdPinAYIOA_Write(b);
        break;
    }
}

void prcAYprcNULL(void) {}

  
const tVoidProc tbl_AYREGPER_proc[64]={
  [0x00] = prcAY0prcR00,
  [0x01] = prcAY0prcR00,
  [0x02] = prcAY0prcR02,
  [0x03] = prcAY0prcR02,
  [0x04] = prcAY0prcR04,
  [0x05] = prcAY0prcR04,
  [0x06] = prcAY0prcR06,
  [0x07] = prcAYprcNULL,
  [0x08] = prcAYprcNULL,
  [0x09] = prcAYprcNULL,
  [0x0A] = prcAYprcNULL,
  [0x0B] = prcAY0prcR0B,
  [0x0C] = prcAY0prcR0B,
  [0x0D] = prcAY0prcR0D,
  [0x0E] = prcAYWprcR0E,
  [0x0F] = prcAYprcNULL,
  
  [0x10] = prcAYprcNULL,
  [0x11] = prcAYprcNULL,
  [0x12] = prcAYprcNULL,
  [0x13] = prcAYprcNULL,
  [0x14] = prcAYprcNULL,
  [0x15] = prcAYprcNULL,
  [0x16] = prcAYprcNULL,
  [0x17] = prcAYprcNULL,
  [0x18] = prcAY0prcR18,
  [0x19] = prcAY0prcR19,
  [0x1A] = prcAY0prcR1A,
  [0x1B] = prcAYprcNULL,
  [0x1C] = prcAYprcNULL,
  [0x1D] = prcAYprcNULL,
  [0x1E] = prcAYprcNULL,
  [0x1F] = prcAYprcNULL,
////
  [0x20] = prcAY1prcR00,
  [0x21] = prcAY1prcR00,
  [0x22] = prcAY1prcR02,
  [0x23] = prcAY1prcR02,
  [0x24] = prcAY1prcR04,
  [0x25] = prcAY1prcR04,
  [0x26] = prcAY1prcR06,
  [0x27] = prcAYprcNULL,
  [0x28] = prcAYprcNULL,
  [0x29] = prcAYprcNULL,
  [0x2A] = prcAYprcNULL,
  [0x2B] = prcAY1prcR0B,
  [0x2C] = prcAY1prcR0B,
  [0x2D] = prcAY1prcR0D,
  [0x2E] = prcAYWprcR0E,
  [0x2F] = prcAYprcNULL,
  
  [0x30] = prcAYprcNULL,
  [0x31] = prcAYprcNULL,
  [0x32] = prcAYprcNULL,
  [0x33] = prcAYprcNULL,
  [0x34] = prcAYprcNULL,
  [0x35] = prcAYprcNULL,
  [0x36] = prcAYprcNULL,
  [0x37] = prcAYprcNULL,
  [0x38] = prcAY1prcR18,
  [0x39] = prcAY1prcR19,
  [0x3A] = prcAY1prcR1A,
  [0x3B] = prcAYprcNULL,
  [0x3C] = prcAYprcNULL,
  [0x3D] = prcAYprcNULL,
  [0x3E] = prcAYprcNULL,
  [0x3F] = prcAYprcNULL,
};



//6876

/*
void EXT_DoAyReneratorUpdate(u8 ayn, u8 adL)
{
      tbl_AYREGPER_proc[(adL | (ayn<<4)) & 0x1F]();
}
*/

// REG      BIT  Description
// 00       8    TONE A LO
// 01       4    TONE A HI
// 02       8    TONE B LO
// 03       4    TONE B HI
// 04       8    TONE C LO
// 05       4    TONE C HI
// 06       5    NOISE
// 07       6    MASK
// 08       5    VOL A
// 09       5    VOL B
// 0A       5    VOL C
// 0B       8    ENV LO
// 0C       8    ENV HI
// 0D       5    ENV MODE
// 0E       8    PORT A
// 0F       8    PORT B
// 10       8    TONE A LO PHASE
// 11       4    TONE A HI PHASE
// 12       8    TONE B LO PHASE
// 13       4    TONE B HI PHASE
// 14       8    TONE C LO PHASE
// 15       4    TONE C HI PHASE
// 16            NONE
// 17            NONE
// 18       8    PWM A (PHASE FIX)
// 19       8    PWM A (PHASE FIX)
// 1A       8    PWM A (PHASE FIX)
// 1B            NONE
// 1C            NONE
// 1D            NONE
// 1E            NONE
// 1F            NONE
// F0       8    Unlock String 
//                IN:"Wild Sound Enable ",WORK_CMD,0x00
//               OUT:0xDF (UNLOCKED)

/*
u8 adL = 0x00;
u8 adH = 0x00;
void EXT_DoAyBusGetUpdateDataLatch(void)
{

}
*/

#define doStepSPI(_v)         \
      LASPI_CLK(0);           \
      LASPI_MOSI(_v>>7);      \
      _v<<=1;                 \
      LASPI_CLK(1);

#define doBitSPI(_v, _b)                  \
      LASPI_MOSI( ((_v)&(_b))?1:0 );      \
      LASPI_CLK(1);                       \
      LASPI_CLK(0);

//      __nop(); __nop(); __nop(); __nop(); \

#define evntLSysTickSPIDATA   0x00800100

u32 LSysTickSPIDATA = evntLSysTickSPIDATA;


__attribute__((section("ROMCODE")))
void EXT_DoPortDelay(void)
{
    __nop(); __nop(); __nop(); __nop();
}
__attribute__((section("ROMCODE")))
void EXT_DoPortSendSPIx(u8 v)
{
//    static u8 oldv=0xAA;
//    if (oldv!=v)
    {
      doBitSPI(v,0x80);
      doBitSPI(v,0x40);
      doBitSPI(v,0x20);
      doBitSPI(v,0x10);
      doBitSPI(v,0x08);
      doBitSPI(v,0x04);
      doBitSPI(v,0x02);
      doBitSPI(v,0x01);
      LASPI_NSS(1);
//      oldv = v;
      LASPI_MOSI(1);
      LASPI_NSS(0);
    }
}

#define EXT_DoPortSendSPI(_v)    SPI3DMAbufferTx[0]=((_v)<<2) //SPI3->DR = (_v)

//#define EXT_DoPortUpdateSPI(_v)     LSysTickSPIDATA = ((u8)(_v)) | evntLSysTickSPIDATA; LSysTickStart()
#define EXT_DoPortUpdateSPI(_v)     EXT_DoPortSendSPI(_v)

#define EXT_DoPortUpdate(_v)    if (isRbousCFG) { EXT_DoPortUpdateSPI(_v); } else { GPIO_Port(GPIOB) = outDataForTslPort[ (u8)(_v) ]; }

const char LOCKSTRING[] = "Wild Sound Enable ";
const char WILDdataINFO[] = "Wild Sound II By Rob F.";
char WILDdataVER[] = __TIME__" "__DATE__;//"3.777.13.12.2019";
char WILDwsVER[32];
u16 WILDfwVer[3] = {0,0,0};



const  u16 TSL_AYX32_M_DEVSIG  = (u16)0xAA55;     // Device signature
const  u32 TSL_AYX32_MAGIC_FFW = (u32)0x7841AA55; // 'Flash Firmware' parameter
const  u32 TSL_AYX32_MAGIC_CFG = (u32)0x37C855AA; // 'Save Config' parameter
const  u32 TSL_AYX32_MAGIC_RES = (u32)0xDEADBEEF; // 'Reset' parameter
const  u32 TSL_AYX32_MAGIC_LCK = (u32)0xC0DEFACE; // 'Unlock' parameter



__attribute__((section("ROMCODE")))
void EXT_DoAyxCmd(u8 cmd)
{
    u32 d = uu32(ayStr.WORK_DATA);
    switch (cmd)
    {
      case TSL_AYX32_C_UP_FW:
        ayStr.WORK_STATUS |= TSL_AYX32_S_DRQ;
        ayStr.WORK_FW_SIZE = d;
        break;
      case TSL_AYX32_C_FLASH_FW:
        if (d == TSL_AYX32_MAGIC_FFW)
        {
          ayStr.WORK_STATUS |= TSL_AYX32_S_BUSY;
          ayStr.WORK_ERROR = TSL_AYX32_E_DOFLASH;
        }
        break;
      case TSL_AYX32_C_RESET:
        if (d == TSL_AYX32_MAGIC_RES)
        {
          NVIC_SystemReset();
        }
        break;
    }
}


//u8 testREG[256];
//u8 testREGP=0;


#pragma push
#pragma O1
void EXT_DoAyBusUpdate(void)
{
    //volatile tAdrHL adx = { ad.adHL = (u16)ayStr.ay[ayStr.ayn].adr };
    ad.adHL = (u16)ayStr.ay[ayStr.ayn].adr;
    switch (ad.ad.H)
    {
      case 0x0:
        ayStr.dta = ayStr.ay[ayStr.ayn].REG.R[ad.ad.L+0x00];
        break;
      case 0x1:
        ayStr.dta = ayStr.ay[ayStr.ayn].REG.R[ad.ad.L+0x10];
        break;
      default:
        ayStr.dta = ayStr.ws.R[ad.adHL];
        break;
    }
    EXT_DoPortUpdate(ayStr.dta); //GPIO_Port(GPIOB) = outDataForTslPort[ (u8)ayStr.dta ];
}
#pragma pop


//ayMemReg
u8 EXT_DoWsReadStopString(char *s, __packed u16 *p)
{
    u8 b=s[*p];
    if (b)
    {
      p[0]++;
    }
    return b;
}

u8 EXT_DoWsStreamCalcCRCstp(u8 b, u8 r, u8 p)
{
    switch (p&0x03)
    {
      case 0:  r^=b+p; break;
      case 1:  r^=b-p; break;
      case 2:  r-=b+p; break;
      default: r+=b-p; break;
    }
    return r;
}

u8 EXT_DoWsStreamCalcCRC(u8 *buf, u8 size)
{
    u8 r=0;
    u8 p=0;
    while (size)
    {
      r=EXT_DoWsStreamCalcCRCstp(*buf++, r, p);
      size--;
      p++;
    }
    return r;
}

void EXT_DoWsStreamStatus(void)
{
    const u8 ws = sizeof(ayStr.WORK_DATA);
    const u8 bu = ((cayStrmFlagGet(&chipAY_Stream) & cays_FLAG_DODONE) ? 1 : 0);
    static u8 busy = 0; busy = (busy<<1) | bu;
    //au16(ayStr.WORK_DATA)[0] = chipAY_Stream.CMD;
    *((u16 *)(&ayStr.WORK_DATA[ 0])) = (chipAY_Stream.CMD & 0x7FFF) | ((bu) ? 0x8000 : 0);
    *((u32 *)(&ayStr.WORK_DATA[ 2])) = chipAY_Stream.SIZE;
    *((u32 *)(&ayStr.WORK_DATA[ 6])) = chipAY_Stream.POS;
    *((u8  *)(&ayStr.WORK_DATA[10])) = cayStrmFifoOUwrFree(&chipAY_Stream);
    *((u8  *)(&ayStr.WORK_DATA[11])) = cayStrmFifoINwrSize(&chipAY_Stream);
    *((u16 *)(&ayStr.WORK_DATA[ws-3])) = 0x3DFA;
    //*((u16 *)(&ayStr.WORK_DATA[ws-1])) = EXT_DoWsStreamCalcCRC(ayStr.WORK_DATA, ws-1);
}

u8 EXT_DoWsStreamGetStatusByte(void)
{
    const u8 m=(sizeof(ayStr.WORK_DATA)-1);
    const u8 r=ayStr.WORK_POS>>8;
    const u8 p=ayStr.WORK_POS;
          u8 b;
    if (p!=m)
    {
      b=ayStr.WORK_DATA[ayStr.WORK_POS & m];
      ayStr.WORK_POS = (EXT_DoWsStreamCalcCRCstp(b, r, p)<<8) | (p+1);
    } else {
      ayStr.WORK_DATA[ayStr.WORK_POS & m] = r;
      EXT_DoWsStreamStatus();
      ayStr.WORK_POS = 0;
      b = r;
    }
    return b;
}

//ayMemReg
void EXT_DoWsBusReadData(void)
{
      u8 b;
      switch (ad.adHL)
      {
        case 0xE0:    //TSL AYX32 - Dev Info
          ayStr.ws.R[ad.adHL] = au8(TSL_AYX32_M_DEVSIG)[(ayStr.WORK_POS++) & 1];
          break;
        case 0xE1:    //TSL AYX32_R_CMD - CMD/STATUS
          ayStr.ws.R[ad.adHL] = ayStr.WORK_STATUS;
          break;
        case 0xEB:    //TSL AYX32_R_UPTIME - Timer
          ayStr.ws.R[ad.adHL] = ayStr.WORK_DATA[(ayStr.WORK_POS++) & (sizeof(ayStr.WORK_DATA)-1)];
          break;
        case 0xEC:    //TSL AYX32_R_VER - Ver
          ayStr.ws.R[ad.adHL] = ayStr.WORK_DATA[(ayStr.WORK_POS++) & (sizeof(ayStr.WORK_DATA)-1)];
          break;
        case 0xED:    //TSL AYX32_R_CPR_STR - Info Str
          ayStr.ws.R[ad.adHL] = EXT_DoWsReadStopString((char *)&WILDdataINFO, &ayStr.WORK_POS);
          break;
        case 0xEE:    //TSL AYX32_R_BLD_STR - Build Str
          ayStr.ws.R[ad.adHL] = EXT_DoWsReadStopString((char *)&WILDdataVER, &ayStr.WORK_POS);
          break;
        case 0xEF:    //TSL AYX32_R_CORE_FRQ - Read Core Freq
          ayStr.ws.R[ad.adHL] = ayStr.WORK_DATA[(ayStr.WORK_POS++) & (sizeof(ayStr.WORK_DATA)-1)];
          break;
        case 0xF0:
          if (ayStr.WORK_LOCK_BIT==0x00) ayStr.ws.R[ad.adHL] = EXT_DoWsReadStopString((char *)&WILDwsVER, &ayStr.WORK_POS);
          break;
        case 0xF1:    //Stream CMD        //Read cmd(x2) + size(x4) + pos(x4) + fiOUTfree(x1) + fiINsize(x1) + 0x3DFA(x2) + crcX(x1) + 0x00(x1)
          ad.adHL = ayStr.ay[ayStr.ayn].adr = 0xF3;
          EXT_DoWsStreamGetStatusByte();
        case 0xF3:    //Stream STATUS
          ayStr.ws.R[ad.adHL] = EXT_DoWsStreamGetStatusByte();
          break;
        case 0xF4:    //Loader Read Byte
//Fast Variant          
          if ( Read_RS_Size() )
          {
            if ( (ayStr.ws.R[ad.adHL]==0x03) && (ayStr.WORK_MODE==0xF2) )
            {
              b=0x00;   //Reset
            } else {
              b = Read_RS_Byte();
              ayStr.WORK_MODE = (b==0x03) ? 0xF3 : 0xF1;
            }
          } else {
            ayStr.WORK_MODE = ayStr.WORK_MODE==0xF3 ? 0xF3 : 0xF2; //Lock For Skip Byte
            b = 0x03;
          }
//          if ( ayStr.WORK_MODE==0xF0 )
//          {
//            b = ayStr.WORK_03;
//            ayStr.WORK_MODE = 0xF2;
//          } else if ( Read_RS_Size() ) {
//            const u8 st = ((ayStr.ws.R[ad.adHL]==0x03)?2:0) | ((ayStr.WORK_MODE==0xF3)?1:0);
//            switch (st)
//            {
//              case 1:
//                b = 0x03;
//                break;
//              case 2:
//                b = Read_RS_Byte();
//                if (b==0x03)
//                {
//                  ayStr.WORK_MODE = 0xF3;
//                } else {
//                  ayStr.WORK_03 = b;
//                  ayStr.WORK_MODE = 0xF0;
//                  b = 0x00;
//                }
//                break;
//              default://case 0x00:
//                b = Read_RS_Byte();
//                ayStr.WORK_MODE = (b==0x03) ? 0xF3:0xF2;
//                break;
//            }
//          } else {
//            b = 0x03;
//          }
          ayStr.ws.R[ad.adHL] = b;
          break;
        case 0xF6:    //Loader Buffer Read Size ... Read Byte Byte Byte
          if (ayStr.WORK_MODE)
          {
            ayStr.ws.R[ad.adHL] = Read_RS_Byte();
            ayStr.WORK_MODE--;
          }
          break;
        case 0xF7:    //Loader Buffer Read Free Write Byte
          ayStr.ws.R[ad.adHL] = Send_RS_FREEBusy();
          break;
      }
}


//ayMemReg
void EXT_DoWsBusWriteAddr(void)
{
      switch (ad.adHL)
      {
        case 0xE0:    //TSL AYX32_R_DEV_SIG - Dev Info
          ayStr.WORK_POS = 0x00;
          ayStr.ws.R[ad.adHL] = au8(TSL_AYX32_M_DEVSIG)[(ayStr.WORK_POS++) & 1];
          break;
        case 0xE1:    //TSL AYX32_R_CMD - CMD/STATUS
          ayStr.ws.R[ad.adHL] = ayStr.WORK_STATUS;
          break;
        case 0xE2:    //TSL AYX32_R_ERROR - Error Status
          ayStr.ws.R[ad.adHL] = ayStr.WORK_ERROR;
          break;
        case 0xE3:    //TSL AYX32_R_PARAM - Param
          ayStr.WORK_POS = 0x00;
          break;
        case 0xE4:    //TSL AYX32_R_DATA - Send Data
          ayStr.WORK_POS = 0x00;
          ayStr.WORK_ERROR = TSL_AYX32_E_BUSY;
          break;
        case 0xEB:    //TSL AYX32_R_UPTIME - Timer
          ayStr.WORK_POS = 0;
          uu32(ayStr.WORK_DATA) = Timer_1ms_Counter;
          ayStr.ws.R[ad.adHL] = ayStr.WORK_DATA[(ayStr.WORK_POS++) & (sizeof(ayStr.WORK_DATA)-1)];
          break;
        case 0xEC:    //TSL AYX32_R_VER - Ver
          ayStr.WORK_POS = 0x00;
          au16(ayStr.WORK_DATA)[0] = WILDfwVer[0];    //HARD VER
          au16(ayStr.WORK_DATA)[1] = WILDfwVer[1];    //FRMW VER
          au16(ayStr.WORK_DATA)[2] = WILDfwVer[2];    //CONF VER
          ayStr.ws.R[ad.adHL] = ayStr.WORK_DATA[(ayStr.WORK_POS++) & (sizeof(ayStr.WORK_DATA)-1)];
          break;
        case 0xED:    //TSL AYX32_R_CPR_STR - Info Str
          ayStr.WORK_POS = 0x00;
          ayStr.ws.R[ad.adHL] = EXT_DoWsReadStopString((char *)&WILDdataINFO, &ayStr.WORK_POS);
          break;
        case 0xEE:    //TSL AYX32_R_BLD_STR - Build Str
          ayStr.WORK_POS = 0x00;
          ayStr.ws.R[ad.adHL] = EXT_DoWsReadStopString((char *)&WILDdataVER, &ayStr.WORK_POS);
          break;
        case 0xEF:    //TSL AYX32_R_CORE_FRQ - Read Core Freq
          ayStr.WORK_POS = 0x00;
          uu32(ayStr.WORK_DATA) = MPU_ClocksStatus.SYSCLK_Frequency;
          ayStr.ws.R[ad.adHL] = ayStr.WORK_DATA[(ayStr.WORK_POS++) & (sizeof(ayStr.WORK_DATA)-1)];
          break;
        case 0xF0:
//            ayStr.ay[ayStr.ayn].adr = bdt;
          ayStr.WORK_MODE = 0xFF;
          ayStr.WORK_CMD = 0x00;
          ayStr.WORK_LOCK_BIT = 0xFF;
          ayStr.WORK_POS = 0x00;
          break;
        case 0xF1:    //Stream CMD        //Write cmd(x2) + Size(x4)  ... Read cmd(x2) + size(x4) + pos(x4) + fiOUTfree(x1) + fiINsize(x1) + 0x3DFA(x2) + crcX(x1) + 0x00(x1)
          ayStr.WORK_POS = 0x00;
          EXT_DoWsStreamStatus();
          ayStr.ws.R[ad.adHL] = ayStr.WORK_DATA[0];
          break;
        case 0xF2:    //Stream DATA       Read / Write
          ayStr.WORK_POS = 0x00;
          break;
        case 0xF3:    //Stream STATUS                                 ... Read cmd(x2) + size(x4) + pos(x4) + fiOUTfree(x1) + fiINsize(x1) + 0x3DFA(x2) + crcX(x1) + 0x00(x1)
          ayStr.WORK_POS = 0x00;
          EXT_DoWsStreamStatus();
          ayStr.ws.R[ad.adHL] = EXT_DoWsStreamGetStatusByte();
          break;
        case 0xF4:    //Loader Byte
          ayStr.ws.R[ad.adHL] = 3;
          break;
        case 0xF5:    //Loader Init
          ayStr.WORK_MODE = 0xFF;
          break;
        case 0xF6:    //Loader Buffer Read Size ... Read Byte Byte Byte
          ayStr.ws.R[ad.adHL] = ayStr.WORK_MODE = Read_RS_Size();
          break;
        case 0xF7:    //Loader Buffer Read Free Write Byte
          ayStr.ws.R[ad.adHL] = Send_RS_FREEBusy();
          break;
        case 0xFC:
        case 0xFD:
          break;
        case 0xFE:
          ayStr.ayn = 1;
          ad.adHL = (u16)ayStr.ay[ayStr.ayn].adr;
          break;
        case 0xFF:
          ayStr.ayn = 0;
          ad.adHL = (u16)ayStr.ay[ayStr.ayn].adr;
          break;
//        default:
//          ayStr.ay[ayStr.ayn].adr = bdt;
//          break;
      }
}

//ayMemReg
void EXT_DoWsBusWriteData(void)
{
    const u8 bdt = ayStr.bus>>8;
      u8 b;
      switch (ad.adHL)
      {
        case 0xE1:    //TSL AYX32_R_CMD - CMD/STATUS
          ayStr.WORK_CMD = bdt;
          EXT_DoAyxCmd(ayStr.WORK_CMD);
          ayStr.ws.R[ad.adHL] = ayStr.WORK_STATUS;
          break;
        case 0xE3:    //TSL AYX32_R_PARAM - Param ???
          ayStr.WORK_DATA[(ayStr.WORK_POS++) & (sizeof(ayStr.WORK_DATA)-1)] = bdt;
          break;
        case 0xE4:    //TSL AYX32_R_DATA - Send Data
          if (ayStr.WORK_POS<ayStr.WORK_FW_SIZE)
          {
            ((u8 *)(fwCCRMAM_ADDR))[ayStr.WORK_POS++] = bdt;
            if (ayStr.WORK_POS==ayStr.WORK_FW_SIZE)
            {
              ayStr.WORK_ERROR = TSL_AYX32_E_DONE;//ayStr.WORK_STATUS |= TSL_AYX32_S_BUSY;
            }
          } else {
            ayStr.WORK_ERROR = TSL_AYX32_E_DATAERR;
          }
          break;
        case 0xF0:
          b=LOCKSTRING[ayStr.WORK_POS];
          if (b)
          {
            ayStr.WORK_LOCK_BIT = 0xFF;
            if (b==bdt)
            {
              ayStr.WORK_POS++;
            } else {
              ayStr.WORK_POS = 0x00;
            }
          } else {
            if (ayStr.WORK_LOCK_BIT == 0xFF)
            {
              ayStr.WORK_CMD = bdt;
              ayStr.WORK_LOCK_BIT--;
            } else {
              if (bdt==0x00)
              {
                ayStr.WORK_LOCK_BIT = 0x00;
                ayStr.ws.R[ad.adHL] = 0xDF;
                ayStr.WORK_POS = 0x00;
              } else {
                ayStr.WORK_LOCK_BIT = 0xFF;
              }
            }
          }
          break;
        case 0xF1:    //Stream CMD       //Write cmd(x2) + Size(x4)
          ayStr.WORK_DATA[(ayStr.WORK_POS++) & (sizeof(ayStr.WORK_DATA)-1)] = bdt;
          if (ayStr.WORK_POS==2)
          {
            cayStrmClear(&chipAY_Stream);
            cayStrmCmdSet(&chipAY_Stream, uu16(ayStr.WORK_DATA[0]) );
          }
          if (ayStr.WORK_POS==6)
          {
            chipAY_Stream.SIZE = uu32( ayStr.WORK_DATA[2] );
            chipAY_Stream.POS = 0;
          }
          break;
        case 0xF2:    //Stream DATA       Write
          if ( (cayStrmFlagGet(&chipAY_Stream) & cays_FLAG_DODONE)==0 )
          {
            if (ayStr.WORK_POS==0)
            {
              //ayStr.WORK_MODEO = ayStr.WORK_MODE;
              //ayStr.WORK_MODE = 
              ayStr.WORK_FW_SIZE = bdt;   //Size Of Send Block ...
              ayStr.WORK_POS++;
            } else {
              if (ayStr.WORK_FW_SIZE)
              {
                ayStr.WORK_FW_SIZE--;
                if ( cayStrmFifoOUwrFree(&chipAY_Stream) ) cayStrmFifoOUwrB(&chipAY_Stream, bdt);
              }
            }
            if (ayStr.WORK_FW_SIZE==0)
            {
              cayStrmFlagSet(&chipAY_Stream, cays_FLAG_DODONE);
              ayStr.WORK_POS = 0;
            }
          }
          break;
        case 0xF4:    //Loader Send Byte
          Send_RS_B(bdt);
          break;
        case 0xF5:    //Loader Init
          ayStr.WORK_MODE = 0xFF;
          switch (bdt)
          {
            case 0x80:
              ayStr.WORK_MODE = 0xF1;
              ayStr.WORK_TRANS_TYPE = TRANS_MODE_USART_SET_115200;
              break;
            case 0x81:
              ayStr.WORK_MODE = 0xF1;
              ayStr.WORK_TRANS_TYPE = TRANS_MODE_USART_SET_57600;
              break;
            case 0x82:
              ayStr.WORK_MODE = 0xF1;
              ayStr.WORK_TRANS_TYPE = TRANS_MODE_USART_SET_38400;
              break;
            case 0x83:
              ayStr.WORK_MODE = 0xF1;
              ayStr.WORK_TRANS_TYPE = TRANS_MODE_USART_SET_19200;
              break;
            case 0x84:
              ayStr.WORK_MODE = 0xF1;
              ayStr.WORK_TRANS_TYPE = TRANS_MODE_USART_SET_14400;
              break;
            case 0x85:
              ayStr.WORK_MODE = 0xF1;
              ayStr.WORK_TRANS_TYPE = TRANS_MODE_USART_SET_9600;
              break;
            case 0x86:
              ayStr.WORK_MODE = 0xF1;
              ayStr.WORK_TRANS_TYPE = TRANS_MODE_USART_SET_4800;
              break;
            case 0x90:
              ayStr.WORK_MODE = 0xE1;
              ayStr.WORK_TRANS_TYPE = TRANS_MODE_USART_SET_115200;
              break;
            case 0xAA:
              ayStr.WORK_TRANS_TYPE = TRANS_MODE_USART_SET_ZXUNO;
              break;
            case 0xAB:
              ayStr.WORK_TRANS_TYPE = TRANS_MODE_USART_SET_ZXBURYAK;
              break;
            case 0xAC:
              ayStr.WORK_TRANS_TYPE = TRANS_MODE_USART_SET_ZXIOA;
              break;
          }
          ayStr.ws.R[ad.adHL] = ayStr.WORK_MODE;
          break;
        case 0xF6:    //Loader Buffer Read Size/Write Free
          ayStr.WORK_MODE = 0xFF;
          break;
        case 0xF7:    //Loader Buffer Read Free Write Byte
          Send_RS_B(bdt);
          ayStr.ws.R[ad.adHL] = Send_RS_FREEBusy();
          break;
      }
}


//6788  
//__attribute__((section("RAMCODE")))
//__attribute__((section("ccmram")))
//ayMemReg
void EXT_DoAyBusReg(void)
{//7024
//      u8 b;
//tAdrHL ad={  .adHL = (u16)ayStr.ay[ayStr.ayn].adr, };
    ad.adHL = (u16)ayStr.ay[ayStr.ayn].adr;
    const u8 bdt = ayStr.bus>>8;
//#define bdt   (u8)(ayStr.bus>>8)
    switch ( ayStr.bus & BDIRBC_mask )
    {//187B , E178
      case BDIRBC_READ:
        if (ad.adHL & 0x80)
        {
          EXT_DoWsBusReadData();
        } else {
//          switch (ad.adHL)
//          {
//            case 0x0E:
//              prcAYWprcR0E();
//              break;
//          }
        }
        break;
      case BDIRBC_WRITE_ADDR:
        ad.adHL = bdt;
        if (ad.adHL & 0x80) EXT_DoWsBusWriteAddr();
        ayStr.ay[ayStr.ayn].adr = bdt;
        //ayStr.dta = ayStr.ay[ayStr.ayn].REG.R[ad.ad.L];
        break;
      case BDIRBC_WRITE_DATA:
        ayStr.ws.R[ad.adHL] = bdt;
        //testREG[testREGP++] = bdt;
        if (ad.adHL & 0x80)
        {
          EXT_DoWsBusWriteData();
        } else {
          switch (ad.ad.H)
          {
            case 0x0:
              ayStr.ay[ayStr.ayn].REG.R[ad.ad.L+0x00] = bdt;
              EXT_DoAyReneratorUpdate(ayStr.ayn, ad.ad.L+0x00);
//            b=ayStr.ay[ayStr.ayn].REG.R[14];
//            USARTZXUNO_TX( (b>>UNO_RSBIT_TX)&1 );
//            b = (b & (~(1<<UNO_RSBIT_RX))) | ((USARTZXUNO_RX()&1)<<UNO_RSBIT_RX);
//            ayStr.ay[ayStr.ayn].REG.R[14] = b;
              break;
            case 0x1:
              ayStr.ay[ayStr.ayn].REG.R[ad.ad.L+0x10] = bdt;
              EXT_DoAyReneratorUpdate(ayStr.ayn, ad.ad.L+0x10);
              break;
          }
        }
        
        break;
    }
    
    switch (ad.ad.H)
    {
      case 0x0:
        ayStr.dta = ayStr.ay[ayStr.ayn].REG.R[ad.ad.L+0x00];
        break;
      case 0x1:
        ayStr.dta = ayStr.ay[ayStr.ayn].REG.R[ad.ad.L+0x10];
        break;
      default:
        ayStr.dta = ayStr.ws.R[ad.adHL];
        break;
    }
    EXT_DoPortUpdate(ayStr.dta); //GPIO_Port(GPIOB) = outDataForTslPort[ (u8)ayStr.dta ];
    
    //EXT_DoAyBusUpdate();
    
//    EXTI_ClearITPendingBit(EXTI_Line0);
//    EXTI_ClearITPendingBit(EXTI_Line1);
//    __nop();
//    NVIC_ClearPendingIRQ(EXTI0_IRQn);
//    NVIC_ClearPendingIRQ(EXTI1_IRQn);
//    __nop();
    
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
#define isUseBusBuffering     0

#if isUseBusBuffering

u16 AY_BusBuf[256];
u8 AY_BusWR=0;
u8 AY_BusRD=0;

#define EXT_DoBusWR(_v)       AY_BusBuf[AY_BusWR++]=(_v); SCB->ICSR |= SCB_ICSR_PENDSTSET_Msk //LSysTickStart()//NVIC_SetPendingIRQ(SysTick_IRQn)   //;LSysTickStart()
#define EXT_DoBusRD()         AY_BusBuf[AY_BusRD++]
#define EXT_DoBusSize()       (u8)(AY_BusWR-AY_BusRD)


void EXT_DoBusProcess(void)
{
    while(EXT_DoBusSize())
    {
      //SWO(0);
      ayStr.bus = EXT_DoBusRD();
      EXT_DoAyBusReg();
      //SWO(1);
    }
    LSysTickStop();
}
#endif

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

#define extWaitBusFreeMODE 0
//ayMemReg
//////u32 oldGPIOBmode;

//__attribute__((section("RAMCODE")))
//__attribute__((section("ccmram")))
//ayMemReg
__asm void EXTI01_extProc(void) __irq
{
    //CPSID     I
    LDR       R0, = __cpp( SWOwp_port )

   //Read GPIOB
    LDR       R2, [R0, #__cpp(offsetof(GPIO_TypeDef, IDR))]
    MOV       R1, R2
    
    MOV       R3, #0x5555       //MODE OUT
#if (extWaitBusFreeMODE == 0)
lRD
    AND       R2, R2, #__cpp(BDIRBC_mask)
    CMP       R2, #__cpp(BDIRBC_READ)
   //Out Mode
    STRHEQ    R3, [R0, #__cpp(offsetof(GPIO_TypeDef, MODER))+2]
    LDREQ     R2, [R0, #__cpp(offsetof(GPIO_TypeDef, IDR))]
    BEQ       lRD
#elif (extWaitBusFreeMODE == 1)
lRD
    AND       R2, R2, #__cpp(BDIRBC_mask)
    CMP       R2, #__cpp(BDIRBC_TRISTATE)
    STRH      R3, [R0, #__cpp(offsetof(GPIO_TypeDef, MODER))+2]
    LDR       R2, [R0, #__cpp(offsetof(GPIO_TypeDef, IDR))]
    BNE       lRD
#else
    STRH      R3, [R0, #__cpp(offsetof(GPIO_TypeDef, MODER))+2]
lRD
    LDR       R2, [R0, #__cpp(offsetof(GPIO_TypeDef, IDR))]
    AND       R2, R2, #__cpp(BDIRBC_mask)
    CMP       R2, #__cpp(BDIRBC_TRISTATE)
    BNE       lRD
#endif    
   //In Mode
    MOV       R3, #0x0000       //MODE IN
    STRH      R3, [R0, #__cpp(offsetof(GPIO_TypeDef, MODER))+2]
    
    LDR       R3, =__cpp(&ayStr)
    STRH      R1, [R3, #__cpp(offsetof(tAY_Struct, bus))]   //16 bit !!!

#if SWOinputMode<=1
     MOV       R2, #__cpp(dH_PORT_BSSR((SWOwp_pin),(0)))         //Get SetResetBit
     STR       R2, [R0, #__cpp(offsetof(GPIO_TypeDef, BSRRL))]   //SWO = "0"
#else     
     LDR       R2, [R0, #__cpp(offsetof(GPIO_TypeDef, PUPDR))]
     EOR       R2, #__cpp((3<<(SWOwp_pin*2)))        //1 - PULUP, 2 - PULDO
     STR       R2, [R0, #__cpp(offsetof(GPIO_TypeDef, PUPDR))]
#endif    
        //TIM_ClearITPendingBit(TIM3, TIM_IT_CC3 | TIM_IT_CC4);
        //TIM3->SR = (u16)~TIM_IT;
        LDR       R1, = __cpp((u32)&TIM3->SR)
        MOV       R2,#__cpp(~(TIM_IT_CC3 | TIM_IT_CC4))
        STR       R2, [R1]
        
    
    PUSH      {R0,LR}
    PUSH      {R4-R7,R8-R11}
    BL        __cpp(EXT_DoAyBusReg)
    POP       {R4-R7,R8-R11}
    POP       {R0,LR}

    
#if SWOinputMode<=1
//    LDR       R0, = __cpp( SWOwp_port )
     MOV       R2, # __cpp(dH_PORT_BSSR((SWOwp_pin),(1)))        //Get SetResetBit
     STR       R2, [R0, #__cpp(offsetof(GPIO_TypeDef, BSRRL))]   //SWO = "1"
#else     
     LDR       R2, [R0, #__cpp(offsetof(GPIO_TypeDef, PUPDR))]
     EOR       R2, #__cpp((3<<(SWOwp_pin*2)))        //1 - PULUP, 2 - PULDO
     STR       R2, [R0, #__cpp(offsetof(GPIO_TypeDef, PUPDR))]
#endif    

    
    //POP       {R4-R5}//POP       {R0-R3,R4-R5} //
    //CPSIE     I
    BX        LR
    ALIGN
}

//void EXTI0_IRQHandler(void) __attribute__((alias("EXTI01_extProc")));
//void EXTI1_IRQHandler(void) __attribute__((alias("EXTI01_extProc")));
void TIM3_IRQHandler(void) __attribute__((alias("EXTI01_extProc")));

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

__attribute__((section("ROMCODE")))
void EXTI01_extProcRobusCFG(void) __irq
{
    const u16 w = ((GPIO_TypeDef *)(SWOwp_port))->IDR ^ 0x0003;
#if isUseBusBuffering  
    SWO(0);
    TIM3->SR = (u16)(~(TIM_IT_CC3 | TIM_IT_CC4));
    EXT_DoBusWR( w ); //ayStr.bus = ((GPIO_TypeDef *)(SWOwp_port))->IDR ^ 0x0003;
    SWO(1);
#else
    SWO(0);
    TIM3->SR = (u16)(~(TIM_IT_CC3 | TIM_IT_CC4));
    ayStr.bus = w;
    EXT_DoAyBusReg();
    SWO(1);
#endif
  
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

//void TIM3_IRQHandler(void) __attribute__((alias("EXTI01_extProcRobusCFG")));

#pragma pop
//RST
void EXTI2_IRQHandler(void)
{
    EXTI_ClearITPendingBit(EXTI_Line2);//  EXTI->PR = EXTI_Line2;
    NVIC_ClearPendingIRQ(EXTI2_IRQn);
  
    while ( AY_RESET() ==0) __nop();
    NVIC_SystemReset();
}


void EXTI_SetITStatus(uint32_t EXTI_Line)
{
    EXTI->SWIER = EXTI_Line;
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

__attribute__((section("ROMCODE")))
u32 getNextVar(char **s)
{
    static const char *mo[] = {  "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
                                 "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" };
    u32 res = 0;
    u8 b=0;
    char ss[4];
    u8 ssp=0;
    while(**s==' ') ((u32 *)(s))[0]++;//*s[0]++;
    while(1)
    {
      b=**s;
      ((u32 *)(s))[0]++;//*s[0]++;
      if ( (b!=':') && (b!=' ') && (b!=0) )
      {
        if ( (b>='0') && (b<='9') )
        {
          res = (res*10) + (b-='0');
        } else {
          if (ssp<(sizeof(ss)-1))
          {
            ss[ssp++]=toupper(b);
            ss[ssp]=0;
          }
        }
      } else {
        if (ssp)
        {
          u16 ma=(sizeof(mo)/4);
          for (u16 n=0; n<ma; n++)
          {
            if (strcmp(mo[n],ss)==0)
            {
              res=n+1;
              break;
            }
          }
        }
        break;
      }
    }
    return res;
}

__attribute__((section("ROMCODE")))
u64 WildDateVerToFirmVerConverter(void)
{
    u64 r = 0x00000000;
    char *s = (char *)&WILDdataVER;
    r += getNextVar(&s)     *10000;        //hour
    r += getNextVar(&s)     *100;          //min
    r += getNextVar(&s)     *1;            //sec
    r += getNextVar(&s)     *100000000;    //month
    r += getNextVar(&s)     *1000000;      //day
    r +=(getNextVar(&s)%100)*10000000000;  //year
    return r;
}






__attribute__((section("ROMCODE")))
void WildConvertDateToString(char *s, u8 t)
{
    s[0] = 0;
    rb_IntToStr((WILDfwVer[1]/  1)%100, 2, &s[strlen(s)]);  if (t) strcat(s,":");
    rb_IntToStr((WILDfwVer[2]/100)%100, 2, &s[strlen(s)]);  if (t) strcat(s,":");
    rb_IntToStr((WILDfwVer[2]/  1)%100, 2, &s[strlen(s)]);  if (t) strcat(s," "); else strcat(s,"."); 
    rb_IntToStr((WILDfwVer[1]/100)%100, 2, &s[strlen(s)]);  if (t) strcat(s,".");
    rb_IntToStr((WILDfwVer[0]/  1)%100, 2, &s[strlen(s)]);  if (t) strcat(s,".20"); else strcat(s,"20");
    rb_IntToStr((WILDfwVer[0]/100)%100, 2, &s[strlen(s)]);
}


//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

void EXTI15_10_IRQHandler(void) __irq
{
    SWO(0);
    EXTI_ClearITPendingBit(EXTI_Line10);
    //NVIC_ClearPendingIRQ(EXTI15_10_IRQn);
    prcAYRprcR0E();//prcAYWprcR0E();
    EXT_DoAyBusUpdate();
    SWO(1);
    
}

void EXTI9_5_IRQHandler(void) __irq
{
    SWO(0);
    EXTI_ClearITPendingBit(EXTI_Line7);
    //NVIC_ClearPendingIRQ(EXTI9_5_IRQn);
    prcAYRprcR0E();//prcAYWprcR0E();
    EXT_DoAyBusUpdate();
    SWO(1);
}

__attribute__((section("ROMCODE")))
void chipAY_IO_HardPoolIntCFG(u8 mode, u8 isON)
{
    EXTI_InitTypeDef EXTI_InitStructure;
    NVIC_InitTypeDef NVIC_InitStructure;
  
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_SYSCFG, ENABLE);
  
    static u32 xEXTI_Line = EXTI_Line10;
    static IRQn_Type xNVIC_IRQChannel = EXTI15_10_IRQn;
    switch (mode)
    {
      case IOIntPool_PA10:
        SYSCFG_EXTILineConfig(EXTI_PortSourceGPIOA, EXTI_PinSource10);
        xEXTI_Line = EXTI_Line10;
        xNVIC_IRQChannel = EXTI15_10_IRQn;
        break;
      case IOIntPool_PC7:
        SYSCFG_EXTILineConfig(EXTI_PortSourceGPIOC, EXTI_PinSource7);
        xEXTI_Line = EXTI_Line7;
        xNVIC_IRQChannel = EXTI9_5_IRQn;
        break;
      case IOIntPool_OFF:
        chipAY_IO_HardPoolIntCFG(IOIntPool_PA10, 0);
        chipAY_IO_HardPoolIntCFG(IOIntPool_PC7,  0);
        break;
    }
  
    // Connect EXTI Line to GPIO Pin 
    SYSCFG_EXTILineConfig(EXTI_PortSourceGPIOA, EXTI_PinSource10);

    // Configure Button EXTI line
    EXTI_InitStructure.EXTI_Mode = EXTI_Mode_Interrupt;
    NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x00;
    NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0x00;
    EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Rising_Falling;
    EXTI_InitStructure.EXTI_LineCmd = isON ? ENABLE : DISABLE;

    // Enable and set EXTI Interrupt to the lowest priority 
    NVIC_InitStructure.NVIC_IRQChannelCmd = isON ? ENABLE : DISABLE;
    EXTI_InitStructure.EXTI_Line = xEXTI_Line;
    EXTI_Init(&EXTI_InitStructure);
    NVIC_InitStructure.NVIC_IRQChannel = xNVIC_IRQChannel;
    NVIC_Init(&NVIC_InitStructure);
    NVIC_SetPriority(xNVIC_IRQChannel, 255*0);
    
    if (isON)
    {
      EXTI_SetITStatus(EXTI_InitStructure.EXTI_Line);
    }
    
}

//mode 0 - TX(PA10) polling OFF
//     1 - TX(PA10) polling ON
//     2 - TX(PC7)  polling ON
__attribute__((section("ROMCODE")))
void chipAY_IOConfig(u8 mode)
{
    static u8 lastmode = 0xFF;//IOIntPool_OFF;
    if (lastmode != 0xFF) chipAY_IO_HardPoolIntCFG(lastmode, 0);
    lastmode = mode;
    chipAY_IO_HardPoolIntCFG(mode, 1);
/*
    EXTI_InitTypeDef EXTI_InitStructure;
    NVIC_InitTypeDef NVIC_InitStructure;
  
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_SYSCFG, ENABLE);
  
    // Connect EXTI Line to GPIO Pin 
    SYSCFG_EXTILineConfig(EXTI_PortSourceGPIOA, EXTI_PinSource10);

    // Configure Button EXTI line
    EXTI_InitStructure.EXTI_Mode = EXTI_Mode_Interrupt;
    NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x00;
    NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0x00;
    EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Rising_Falling;
    EXTI_InitStructure.EXTI_LineCmd = mode ? ENABLE : DISABLE;

    // Enable and set EXTI Interrupt to the lowest priority 
    NVIC_InitStructure.NVIC_IRQChannelCmd = mode ? ENABLE : DISABLE;
    EXTI_InitStructure.EXTI_Line = EXTI_Line10;
    EXTI_Init(&EXTI_InitStructure);
    NVIC_InitStructure.NVIC_IRQChannel = EXTI15_10_IRQn;
    NVIC_Init(&NVIC_InitStructure);
    NVIC_SetPriority(EXTI15_10_IRQn, 255*0);
  
    if (mode) EXTI_SetITStatus(EXTI_Line10);
*/
}

__attribute__((section("ROMCODE")))
void chipAY_InterruptConfig(void)
{
  EXTI_InitTypeDef EXTI_InitStructure;
  NVIC_InitTypeDef NVIC_InitStructure;
  

    //vectorTable_RAM[16+EXTI0_IRQn] = vectorTable_RAM[16+EXTI1_IRQn] = (u32)EXTI01_extProc;

  
  
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_SYSCFG, ENABLE);
/*
    // Connect EXTI Line to GPIO Pin 
    SYSCFG_EXTILineConfig(EXTI_PortSourceGPIOB, EXTI_PinSource0);
    // Connect EXTI Line to GPIO Pin 
    SYSCFG_EXTILineConfig(EXTI_PortSourceGPIOB, EXTI_PinSource1);
*/  
    // Configure Button EXTI line
    EXTI_InitStructure.EXTI_Mode = EXTI_Mode_Interrupt;
    NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x00;
    NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0x00;
    EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Rising;//EXTI_Trigger_Rising;  
    EXTI_InitStructure.EXTI_LineCmd = ENABLE;

    // Enable and set EXTI Interrupt to the lowest priority 
    NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
/*  
    EXTI_InitStructure.EXTI_Line = EXTI_Line0;
    EXTI_Init(&EXTI_InitStructure);
    NVIC_InitStructure.NVIC_IRQChannel = EXTI0_IRQn;
    NVIC_Init(&NVIC_InitStructure);
    NVIC_SetPriority(EXTI0_IRQn, 0);

    EXTI_InitStructure.EXTI_Line = EXTI_Line1;
    EXTI_Init(&EXTI_InitStructure);
    NVIC_InitStructure.NVIC_IRQChannel = EXTI1_IRQn;
    NVIC_Init(&NVIC_InitStructure);
    NVIC_SetPriority(EXTI1_IRQn, 0);
*/
  //RESET CFG
    SYSCFG_EXTILineConfig(EXTI_PortSourceGPIOA, EXTI_PinSource2);
    EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Falling;
    EXTI_InitStructure.EXTI_Line = EXTI_Line2;
    EXTI_Init(&EXTI_InitStructure);
    NVIC_InitStructure.NVIC_IRQChannel = EXTI2_IRQn;
    NVIC_Init(&NVIC_InitStructure);
    

//    EXTI_SetITStatus(EXTI_Line0);  
//    EXTI_SetITStatus(EXTI_Line1);  



//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////



  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE);

  GPIO_InitTypeDef gpioStruct;
  gpioStruct.GPIO_Mode = GPIO_Mode_AF;
  gpioStruct.GPIO_PuPd = GPIO_PuPd_NOPULL;
  gpioStruct.GPIO_Speed = GPIO_Speed_50MHz;
  gpioStruct.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1;
  GPIO_Init(GPIOB, &gpioStruct);
  GPIO_PinAFConfig(GPIOB, GPIO_PinSource0, GPIO_AF_TIM3);
  GPIO_PinAFConfig(GPIOB, GPIO_PinSource1, GPIO_AF_TIM3);





   RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM3, ENABLE);

    
   TIM_TimeBaseInitTypeDef base_timer;
   TIM_TimeBaseStructInit(&base_timer);
   base_timer.TIM_Prescaler = chipAY_TimerFreq(TIM3) / 1000 - 1;
   base_timer.TIM_Period = 2000;
   base_timer.TIM_ClockDivision = TIM_CKD_DIV1;
   base_timer.TIM_CounterMode = TIM_CounterMode_Up;
   TIM_TimeBaseInit(TIM3, &base_timer);
////////////// Config BDIR(PB0) + BC1(BP1) for Timer 3 Latch ...
  TIM_ICInitTypeDef timICStruct;

  timICStruct.TIM_ICPolarity = isRbousCFG ? TIM_ICPolarity_Falling : TIM_ICPolarity_Rising;
  timICStruct.TIM_ICSelection = TIM_ICSelection_DirectTI;
  timICStruct.TIM_ICPrescaler = TIM_ICPSC_DIV1;
  timICStruct.TIM_ICFilter = 0x0;

  timICStruct.TIM_Channel = TIM_Channel_3;
  TIM_ICInit(TIM3, &timICStruct);
  timICStruct.TIM_Channel = TIM_Channel_4;
  TIM_ICInit(TIM3, &timICStruct);
  
  // TIM3 Update DMA Request enable
  TIM_DMACmd(TIM3, TIM_DMA_CC3 | TIM_DMA_CC4, ENABLE);

  // TIM enable counter
  //TIM_Cmd(TIM3, ENABLE);
  TIM3->CNT = 0x1234;//dH_PORT_BSSR((SWOwp_pin),(1))*0;

  // Enable the CC3 & CC4 Interrupt Request
  TIM_ITConfig(TIM3, TIM_IT_CC3 | TIM_IT_CC4, ENABLE);

  if (isRbousCFG)
  {
    hdIntSetVector(TIM3_IRQn, EXTI01_extProcRobusCFG);//vectorTable_RAM[TIM3_IRQn + 16] = (u32)(EXTI01_extProcRobusCFG);
  }
    
  NVIC_InitStructure.NVIC_IRQChannel = TIM3_IRQn;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 1;
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&NVIC_InitStructure);
  NVIC_SetPriority(TIM3_IRQn, 0);
   
  
////////////////////////////////
////////////////////////////////
////////////////////////////////
    //For ASM speed run ...
//////    oldGPIOBmode = GPIOB->MODER>>16;
    u64 dd = WildDateVerToFirmVerConverter();
    WILDfwVer[0] = 10000+((dd/100000000) % 10000);
    WILDfwVer[1] = 10000+((dd/    10000) % 10000);
    WILDfwVer[2] = 10000+((dd/        1) % 10000);
    
    WildConvertDateToString(WILDdataVER, 1);
    WildConvertDateToString(WILDwsVER, 0);
    
    //NVIC_SetPriority(SysTick_IRQn, 0x00);
    //NVIC_SystemHandlerPriorityConfig(SystemHandler_SysTick, 1, 0);
    SysTick_Config( 2 );//MPU_ClocksStatus.SYSCLK_Frequency/(1000000+20) );
}


__attribute__((section("ROMCODE")))
void SysTick_Handler(void) __irq
{
  /*
    const u16 st = LSysTickSPIDATA>>16;
    if (st==0x1FE)
    {
      LASPI_NSS(1);
      LSysTickStop();
    } else {
      if ( (st&1)==0 )
      {
        if (st==0x00)
        {
          LASPI_NSS(0);
        }
        LASPI_CLK(0);
        LASPI_MOSI( (LSysTickSPIDATA & 0x80)?1:0 );
        LSysTickSPIDATA|=0x00010000;
      } else {
        LASPI_CLK(1);
        //LSysTickSPIDATA|=0x00010000;
        LSysTickSPIDATA<<=1;
      }
    }
  */
    /*
    const u8 st = LSysTickSPIDATA>>16;
    if (st==0x01)
    {
      LASPI_NSS(1);
      LSysTickStop();
    } else if (st==0x80) {
      LASPI_NSS(0);
      LSysTickSPIDATA &=0x0000FFFF;
    } else {
      LASPI_MOSI( (LSysTickSPIDATA & 0x80)?1:0 );
      LASPI_CLK(0);
      __nop(); __nop(); __nop(); __nop();
      __nop(); __nop(); __nop(); __nop();
      __nop(); __nop(); __nop(); __nop();
      LSysTickSPIDATA<<=1;
      LASPI_CLK(1);
    }
    */
    /*
    if (LSysTickSPIDATA&0xFFFFFF00)
    {
      EXT_DoPortSendSPI(LSysTickSPIDATA);
      LSysTickSPIDATA = 0;
    }
    LSysTickStop();
    */
#if isUseBusBuffering
    EXT_DoBusProcess();
#else
    LSysTickStop();
#endif
}



