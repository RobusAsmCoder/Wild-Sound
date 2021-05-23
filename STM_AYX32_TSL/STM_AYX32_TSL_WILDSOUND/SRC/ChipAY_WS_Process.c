//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "ChipAY_WS_Process.h"
#include "hardware.h"
#include "interface.h"
#include "ChipAY_Test.h"
#include "ChipAY_WildSound.h"
#include "ChipAY_Interrupt.h"
#include "ChipAY_Hardware.h"
#include "ChipAY_BootFlasher.h"
#include "ChipAY_StreamData.h"


void wsPoolFlasherMode(void)
{
        //if ( (ayStr.WORK_STATUS & TSL_AYX32_S_DRQ)*0 )
        if ( ayStr.WORK_ERROR == TSL_AYX32_E_DOFLASH )
        {
          chayBootFlashDo();
        }
}

void wsPoolTransMode(void)
{
      u32 d;
      //u8 b;
      switch (ayStr.WORK_TRANS_TYPE)
      {
        case TRANS_MODE_USART_SET_115200: d = 115200; goto LabelDoUartInit;
        case TRANS_MODE_USART_SET_57600:  d =  57600; goto LabelDoUartInit;
        case TRANS_MODE_USART_SET_38400:  d =  38400; goto LabelDoUartInit;
        case TRANS_MODE_USART_SET_19200:  d =  19200; goto LabelDoUartInit;
        case TRANS_MODE_USART_SET_14400:  d =  14400; goto LabelDoUartInit;
        case TRANS_MODE_USART_SET_9600:   d =   9600; goto LabelDoUartInit;
        case TRANS_MODE_USART_SET_4800:   d =   4800;
LabelDoUartInit:
          chipAY_IOConfig(IOIntPool_OFF);
          Uart_RS_Init(d,0x01);
          ayStr.WORK_TRANS_TYPE |= TRANS_MODE_USART_READY;
          break;
        case TRANS_MODE_USART_SET_ZXUNO:
          //GPIO_RS_SetMode(interface_GPIO_OFF);
          GpioInit_USARTZXUNO_TX();
          GpioInit_USARTZXUNO_RX();
          chipAY_IOConfig(IOIntPool_PA10);
          ayStr.WORK_TRANS_TYPE |= TRANS_MODE_USART_READY;
          break;
        case TRANS_MODE_USART_SET_ZXBURYAK:
          GpioInit_BURYAK_AY_TX();
          GpioInit_BURYAK_AY_RX();
          GpioInit_BURYAK_AY_CTS();
          chipAY_IOConfig(IOIntPool_PC7);
          ayStr.WORK_TRANS_TYPE |= TRANS_MODE_USART_READY;
          break;
        case TRANS_MODE_USART_SET_ZXIOA:
          GpioInit_AYPIOA0();
          GpioInit_AYPIOA1();
          GpioInit_AYPIOA2();
          GpioInit_AYPIOA3();
          GpioInit_AYPIOA4();
          GpioInit_AYPIOA5();
          GpioInit_AYPIOA6();
          GpioInit_AYPIOA7();
          ayStr.WORK_TRANS_TYPE |= TRANS_MODE_USART_READY;
          break;
      }
      if (ayStr.WORK_TRANS_TYPE & TRANS_MODE_USART_READY)
      {
        switch (ayStr.WORK_TRANS_TYPE & TRANS_MODE_USART_MASK)
        {
          case TRANS_MODE_USART_DO_MODE:
            __nop();
            break;
          case TRANS_MODE_USART_DO_ZXUNO:
//            b=ayStr.ay[ayStr.ayn].REG.R[14];
//            USARTZXUNO_TX( (b>>UNO_RSBIT_TX)&1 );
//            b = (b & (~(1<<UNO_RSBIT_RX))) | ((USARTZXUNO_RX()&1)<<UNO_RSBIT_RX);
//            ayStr.ay[ayStr.ayn].REG.R[14] = b;
            break;
          case TRANS_MODE_USART_SET_ZXBURYAK:
            break;
          case TRANS_MODE_USART_DO_IOA:
            if (ad.adHL==0x0E)
            {
              prcAYRprcR0E();
              EXT_DoAyBusUpdate();
            }
            break;
        }
      }
}

void wsPoolStreamMode(void)
{
        cayStrmPool(&chipAY_Stream);
}

void wsPoolDigitalPlayer(void)
{
    if (ayStr.WORK_EMUL_HARDMD == work_hrdEmul_mode_AY_DIGITAL)
    {
      if (cayDigPlayerPool(&digPlayer))
      {
        ayStr.WORK_EMUL_HARDMD = work_hrdEmul_mode_AY_HARDWARE_TIMER;
      }
    }
}
