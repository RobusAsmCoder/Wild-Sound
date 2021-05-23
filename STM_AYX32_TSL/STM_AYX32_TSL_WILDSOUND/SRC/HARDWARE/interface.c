//////////////////////////////////////////////////////////////////////////////////////
// 
// Middle level interface for STM32F100
// 
// By Rob F. / Entire Group
// 
//////////////////////////////////////////////////////////////////////////////////////
#include "SysType.h"
#include "hardware.h"
#include "interface.h"
//#include "core_cm3.h"
#include "cortex_rb_sys.h"
#include "rb_fifo.h"
#include "rb_util.h"
#include <string.h>


#ifndef USART1_IRQChannel
#define USART1_IRQChannel    USART1_IRQn
#endif
#ifndef USART2_IRQChannel
#define USART2_IRQChannel    USART2_IRQn
#endif
#ifndef USART3_IRQChannel
#define USART3_IRQChannel    USART3_IRQn
#endif

///////////////////////////
// UARTS Allocation
///////////////////////////
vu8 Mode_RS_CFG = 0;      //0=RS 1=CFG
///////////////////////////
// USART RS
///////////////////////////


#define interface_USART_MacroFunctionGenerator(_name,_usart,_insize,_ousize)\
rb_fifo_alloc(uart_##_name##_fifo_in,   _insize);                           \
rb_fifo_alloc(uart_##_name##_fifo_out,  _ousize);                           \
void _usart##uIntDisable(void)                                              \
{                                                                           \
      NVIC_DisableIRQ(_usart##_IRQChannel);                                 \
}                                                                           \
void _usart##uIntSet(void)                                                  \
{                                                                           \
      USART_ITConfig(_usart, USART_IT_TXE, ENABLE);                         \
}                                                                           \
void _usart##uIntEnable(void)                                               \
{                                                                           \
      NVIC_EnableIRQ(_usart##_IRQChannel);                                  \
}                                                                           \
void _usart##_IRQHandler(void) __irq                                        \
{                                                                           \
  if( USART_GetITStatus(_usart, USART_IT_RXNE) != RESET )                   \
  {                                                                         \
    u8 b=USART_ReceiveData(_usart);                                         \
    if ( rb_fifo_free(&uart_##_name##_fifo_in) )                            \
    {                                                                       \
      if ( rb_fifo_wr_blk( &uart_##_name##_fifo_in, &b, 1 ) )               \
      {                                                                     \
      }                                                                     \
    }                                                                       \
    _usart##uIntSet();                                                      \
  }                                                                         \
  if( USART_GetITStatus(_usart, USART_IT_TXE) != RESET )                    \
  {                                                                         \
    if ( rb_fifo_size(&uart_##_name##_fifo_out) )                           \
    {                                                                       \
      USART_SendData(_usart, rb_fifo_rd(&uart_##_name##_fifo_out));         \
    } else {                                                                \
      USART_ITConfig(_usart, USART_IT_TXE, DISABLE);                        \
    }                                                                       \
  }                                                                         \
}                                                                           \
u8 Echo_##_name##_isEnabled(void)                                           \
{                                                                           \
  return uart_##_name##_fifo_in.bfifo!=0;                                   \
}                                                                           \
void Echo_##_name##_Enable(void)                                            \
{                                                                           \
  uart_##_name##_fifo_in.bfifo = (void *)&uart_##_name##_fifo_out;          \
}                                                                           \
void Echo_##_name##_Disable(void)                                           \
{                                                                           \
  uart_##_name##_fifo_in.bfifo = 0;                                         \
}                                                                           \
u16 Read_##_name##_Byte(void)                                               \
{                                                                           \
    if ( rb_fifo_size(&uart_##_name##_fifo_in) )                            \
    {                                                                       \
      return rb_fifo_rd(&uart_##_name##_fifo_in);                           \
    }                                                                       \
    return 0xFFFF;                                                          \
}                                                                           \
void Read_##_name##_Flush(void)                                             \
{                                                                           \
    rb_fifo_clear(&uart_##_name##_fifo_in);                                 \
}                                                                           \
u16 Read_##_name##_Size(void)                                               \
{                                                                           \
    return rb_fifo_size(&uart_##_name##_fifo_in);                           \
}                                                                           \
u16 Read_##_name##_Buf(char *s, u32 siz)                                    \
{                                                                           \
      return rb_fifo_rd_blk(&uart_##_name##_fifo_in, s, siz);               \
}                                                                           \
u16 Send_##_name##_FREE(void)                                               \
{                                                                           \
  return rb_fifo_free(&uart_##_name##_fifo_out);                            \
}                                                                           \
u16 Send_##_name##_isBusy(void)                                             \
{                                                                           \
      if ( rb_fifo_size(&uart_##_name##_fifo_out) ) return 1;               \
      if (USART_GetFlagStatus(_usart, USART_FLAG_TC) == RESET) return 1;    \
      return 0;                                                             \
}                                                                           \
u16 Send_##_name##_FREEBusy(void)                                           \
{                                                                           \
    u16 res = Send_##_name##_FREE();                                        \
    if ( Send_##_name##_isBusy() &&                                         \
         (res==uart_##_name##_fifo_out.size_mask) ) res--;                  \
    return res;                                                             \
}                                                                           \
void Send_##_name##_WaitFlush(void)                                         \
{                                                                           \
      while (Send_##_name##_isBusy());                                      \
}                                                                           \
void GPIO_##_name##_SetMode(u8 mode)                                        \
{                                                                           \
        _usart##_GPIO(mode);                                                \
}                                                                           \
void Send_##_name##_Hold(u16 hold)                                          \
{                                                                           \
      Send_##_name##_WaitFlush();                                           \
      if (hold)                                                             \
      {                                                                     \
        _usart##_GPIO(interface_GPIO_TX_OFF);                               \
        if (hold<50)                                                        \
        {                                                                   \
          while(hold)                                                       \
          {                                                                 \
            Send_##_name##_Byte(0xFF);                                      \
            hold--;                                                         \
          }                                                                 \
          Send_##_name##_WaitFlush();                                       \
        } else {                                                            \
          DelayMCS(hold);                                                   \
        }                                                                   \
        _usart##_GPIO(interface_GPIO_TX_ON);                                \
      }                                                                     \
}                                                                           \
void Send_##_name##_Start(u16 hold)                                         \
{                                                                           \
      Send_##_name##_WaitFlush();                                           \
      _usart##_GPIO(interface_GPIO_DIR_WR);                                 \
      Send_##_name##_Hold(hold);                                            \
}                                                                           \
void Send_##_name##_End(u16 hold)                                           \
{                                                                           \
      Send_##_name##_Hold(hold);                                            \
      _usart##_GPIO(interface_GPIO_DIR_RD);                                 \
}                                                                           \
u16 Send_##_name##_BLK(char *s, u32 siz)                                    \
{                                                                           \
      if ( siz>uart_##_name##_fifo_out.size_mask )                          \
      {                                                                     \
        siz=uart_##_name##_fifo_out.size_mask;                              \
      }                                                                     \
      while ( rb_fifo_free(&uart_##_name##_fifo_out)<siz );                 \
      _usart##uIntDisable();                                                \
      rb_fifo_wr_blk(&uart_##_name##_fifo_out, s, siz);                     \
      _usart##uIntSet();                                                    \
      _usart##uIntEnable();                                                 \
      return siz;                                                           \
}                                                                           \
void Send_##_name##_Buf(char *s, u32 siz)                                   \
{                                                                           \
      if (s)                                                                \
      {                                                                     \
        while (siz)                                                         \
        {                                                                   \
          u16 size=Send_##_name##_BLK(s, siz);                              \
          s+=size;                                                          \
          siz-=size;                                                        \
        }                                                                   \
      } else {                                                              \
        if ( (siz>>16)==0 )                                                 \
        {                                                                   \
          Send_##_name##_Start((u16)(siz));                                 \
        } else {                                                            \
          Send_##_name##_End((u16)(siz));                                   \
        }                                                                   \
      }                                                                     \
}                                                                           \
void Send_##_name##_Byte(u8 c)                                              \
{                                                                           \
      Send_##_name##_Buf((char *)&c, 1);                                    \
}                                                                           \
void Send_##_name##_B(u8 c)                                                 \
{                                                                           \
      _usart##uIntDisable();                                                \
      rb_fifo_wr(&uart_##_name##_fifo_out, c);                              \
      _usart##uIntSet();                                                    \
      _usart##uIntEnable();                                                 \
}                                                                           \
void Send_##_name##_W(u16 w)                                                \
{                                                                           \
      Send_##_name##_Buf((char *)&w, 2);                                    \
}                                                                           \
void Send_##_name##_Q(u32 d)                                                \
{                                                                           \
      Send_##_name##_Buf((char *)&d, 3);                                    \
}                                                                           \
void Send_##_name##_D(u32 d)                                                \
{                                                                           \
      Send_##_name##_Buf((char *)&d, 4);                                    \
}                                                                           \
void Send_##_name##_String(char *s)                                         \
{                                                                           \
      Send_##_name##_Buf(s, strlen(s));                                     \
}                                                                           \
void Send_##_name##_HEX(u32 da, u8 Dig)                                     \
{                                                                           \
    rb_IntToProc(da, rb_istr_mode_HEX | Dig, &Send_##_name##_Byte);         \
}                                                                           \
void Send_##_name##_DEC(u32 da)                                             \
{                                                                           \
    rb_IntToProc(da, rb_istr_mode_DEC, &Send_##_name##_Byte);               \
}                                                                           \
void Uart_##_name##_Init(u32 baud, u8 parstop)                              \
{                                                                           \
   NVIC_InitTypeDef NVIC_InitStructure;                                     \
   USART_InitTypeDef USART_InitStructure;                                   \
      _usart##_GPIO(1);                                                     \
      USART_Cmd(_usart, DISABLE);                                           \
      rb_fifo_flush(&uart_##_name##_fifo_in, rb_fifo_size(&uart_##_name##_fifo_in));      \
      Uart_CFG(&USART_InitStructure, baud, parstop);                        \
      USART_Init(_usart, &USART_InitStructure);                             \
      NVIC_InitStructure.NVIC_IRQChannel = _usart##_IRQChannel;             \
      NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 255;           \
      NVIC_InitStructure.NVIC_IRQChannelSubPriority = 255;                  \
      NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;                       \
      NVIC_Init(&NVIC_InitStructure);                                       \
      NVIC_SetPriority(_usart##_IRQn, 255);                                 \
      USART_ITConfig(_usart, USART_IT_RXNE, ENABLE);                        \
      USART_Cmd(_usart, ENABLE);                                            \
}                                                                           \







// par = 0 - None
//     = 1 - Odd
//     = 2 - Even
//stop = 0 - 0.5
//     = 1 - 1
//     = 2 - 2
//     = 3 - 1.5
void Uart_CFG(USART_InitTypeDef *USART_InitStructure, u32 baud, u8 parstop)
{
      u16 stop = parstop & 0x0F;
      u16 par  = parstop >> 4;
      u16 wlen = USART_WordLength_8b;
  
      switch (par)
      {
        case 1: par=USART_Parity_Odd;  wlen = USART_WordLength_9b; break;
        case 2: par=USART_Parity_Even; wlen = USART_WordLength_9b; break;
        default:par=USART_Parity_No;                               break;
      }
      switch (stop)
      {
        case 0: stop=USART_StopBits_0_5;  break;
        case 2: stop=USART_StopBits_2;    break;
        case 3: stop=USART_StopBits_1_5;  break;
        default:stop=USART_StopBits_1;    break;
      }
  
      USART_InitStructure->USART_BaudRate = baud;
      USART_InitStructure->USART_WordLength = wlen;//USART_WordLength_8b;
      USART_InitStructure->USART_StopBits = stop;//Uart_Get_Stop(parstop & 0x0F);//USART_StopBits_1;
      USART_InitStructure->USART_Parity = par;//Uart_Get_Parity(parstop >> 4);//USART_Parity_No;
      USART_InitStructure->USART_HardwareFlowControl = USART_HardwareFlowControl_None;
      USART_InitStructure->USART_Mode = USART_Mode_Tx | USART_Mode_Rx;
}

//////////////////////////////////////////////////////////////////
//hdPin_O_DefineSetup(USART1_TX,      A,  9, hd_gptp_AF_PPU,     1);
//hdPin_O_DefineSetup(USART1_RX,      A, 10, hd_gptp_IN_PPU,     1);
void USART1_GPIO(u8 v)
{
  switch (v)
  {
    case interface_GPIO_OFF:      //OFF
      RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE);
      GPIO_PinAFConfig(GPIOA, GPIO_PinSource9, GPIO_AF_USART1);
      GPIO_PinAFConfig(GPIOA, GPIO_PinSource10, GPIO_AF_USART1);
      GpioInit_USART1_TX_OFF();
      GpioInit_USART1_RX_OFF();
      break;
    case interface_GPIO_ON:       //ON
      RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE);
      GPIO_PinAFConfig(GPIOA, GPIO_PinSource9, GPIO_AF_USART1);
      GPIO_PinAFConfig(GPIOA, GPIO_PinSource10, GPIO_AF_USART1);
      GpioInit_USART1_TX_ON();
      GpioInit_USART1_RX_ON();
      break;
    case interface_GPIO_TX_OFF:     //HOLD ENABLE
      GpioInit_USART1_TX_OFF();
      break;
    case interface_GPIO_TX_ON:      //HOLD DISABLE
      GpioInit_USART1_TX_ON();
      break;
    case interface_GPIO_DIR_RD:     //READ ENABLE
      USART1_DIR(0);
      break;
    case interface_GPIO_DIR_WR:     //WRITE ENABLE
      USART1_DIR(1);
      break;
  }
}



/*
//////////////////////////////////////////////////////////////////
hdPin_O_DefineSetup(USART2_TX_ON,      A,  2, hd_gptp_AF_PPU,     1);
hdPin_O_DefineSetup(USART2_TX_OFF,     A,  2, hd_gptp_OUT_PP,     1);
hdPin_O_DefineSetup(USART2_RX_ON,      A,  3, hd_gptp_IN_PPU,     1);
hdPin_O_DefineSetup(USART2_RX_OFF,     A,  3, hd_gptp_IN_OD,      1);
void USART2_GPIO(u8 v)
{
  switch (v)
  {
    case interface_GPIO_OFF:      //OFF
      RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART2, ENABLE);
      GpioInit_USART2_TX_OFF();
      GpioInit_USART2_RX_OFF();
      break;
    case interface_GPIO_ON:       //ON
      RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART2, ENABLE);
      GpioInit_USART2_TX_ON();
      GpioInit_USART2_RX_ON();
      break;
  }
}

//////////////////////////////////////////////////////////////////
hdPin_O_DefineSetup(USART3_TX_ON,   B, 10, hd_gptp_AF_PPU,     1);
hdPin_O_DefineSetup(USART3_TX_OFF,  B, 10, hd_gptp_OUT_PP,     1);
hdPin_O_DefineSetup(USART3_RX_ON,   B, 11, hd_gptp_IN_PPU,     1);
hdPin_O_DefineSetup(USART3_RX_OFF,  B, 11, hd_gptp_IN_OD,      1);
hdPin_O_DefineSetup(USART3_DIR,     B,  2, hd_gptp_OUT_PP,     0);    //0-read 1-write
#define USART3_DIR(_v)              dH_PORT_Write(USART3_DIR,_v)
void USART3_GPIO(u8 v)
{
  switch (v)
  {
    case interface_GPIO_OFF:      //OFF
      RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART3, DISABLE);
      GpioInit_USART3_TX_OFF();
      GpioInit_USART3_RX_OFF();
      GpioInit_USART3_DIR();
      break;
    case interface_GPIO_ON:       //ON
      RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART3, ENABLE);
      GpioInit_USART3_TX_ON();
      GpioInit_USART3_RX_ON();
      GpioInit_USART3_DIR();
      break;
    case interface_GPIO_TX_OFF:     //HOLD ENABLE
      GpioInit_USART3_TX_OFF();
      break;
    case interface_GPIO_TX_ON:      //HOLD DISABLE
      GpioInit_USART3_TX_ON();
      break;
    case interface_GPIO_DIR_RD:     //READ ENABLE
      USART3_DIR(0);
      break;
    case interface_GPIO_DIR_WR:     //WRITE ENABLE
      USART3_DIR(1);
      break;
  }
}
*/
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

#define interface_USB_MacroFunctionGenerator(_name,_usbcdc,_insize,_ousize) \
rb_fifo_alloc(uart_##_name##_fifo_in,   _insize);                           \
rb_fifo_alloc(uart_##_name##_fifo_out,  _ousize);                           \
void Echo_##_name##_Enable(void)                                            \
{                                                                           \
  uart_##_name##_fifo_in.bfifo = (void *)&uart_##_name##_fifo_out;          \
}                                                                           \
u8 Echo_##_name##_isEnabled(void)                                           \
{                                                                           \
  return uart_##_name##_fifo_in.bfifo!=0;                                   \
}                                                                           \
void Echo_##_name##_Disable(void)                                           \
{                                                                           \
  uart_##_name##_fifo_in.bfifo = 0;                                         \
}                                                                           \
u16 Read_##_name##_Size(void)                                               \
{                                                                           \
    return rb_fifo_size(&uart_##_name##_fifo_in);                           \
}                                                                           \
u16 Read_##_name##_Byte(void)                                               \
{                                                                           \
    if ( rb_fifo_size(&uart_##_name##_fifo_in) )                            \
    {                                                                       \
      return rb_fifo_rd(&uart_##_name##_fifo_in);                           \
    }                                                                       \
    return 0xFFFF;                                                          \
}                                                                           \
void Read_##_name##_Flush(void)                                             \
{                                                                           \
    rb_fifo_clear(&uart_##_name##_fifo_in);                                 \
}                                                                           \
u16 Read_##_name##_Buf(char *s, u32 siz)                                    \
{                                                                           \
      return rb_fifo_rd_blk(&uart_##_name##_fifo_in, s, siz);               \
}                                                                           \
u16 Send_##_name##_FREE(void)                                               \
{                                                                           \
  return rb_fifo_free(&uart_##_name##_fifo_out);                            \
}                                                                           \
u16 Send_##_name##_BLK(char *s, u32 siz)                                    \
{                                                                           \
      if ( siz>uart_##_name##_fifo_out.size_mask ) siz=uart_##_name##_fifo_out.size_mask; \
      while ( rb_fifo_free(&uart_##_name##_fifo_out)<siz );                 \
      rb_fifo_wr_blk(&uart_##_name##_fifo_out, s, siz);                     \
      return siz;                                                           \
}                                                                           \
void Send_##_name##_Buf(char *s, u32 siz)                                   \
{                                                                           \
      if (Uart_##_name##_isConnected())                                     \
      {                                                                     \
        while (siz)                                                         \
        {                                                                   \
          u16 size=Send_##_name##_BLK(s, siz);                              \
          s+=size;                                                          \
          siz-=size;                                                        \
        }                                                                   \
      }                                                                     \
}                                                                           \
void Send_##_name##_Byte(u8 c)                                              \
{                                                                           \
      Send_##_name##_Buf((char *)&c, 1);                                    \
}                                                                           \
void Send_##_name##_B(u8 c)                                                 \
{                                                                           \
      Send_##_name##_Buf((char *)&c, 1);                                    \
}                                                                           \
void Send_##_name##_W(u16 w)                                                \
{                                                                           \
      Send_##_name##_Buf((char *)&w, 2);                                    \
}                                                                           \
void Send_##_name##_Q(u32 d)                                                \
{                                                                           \
      Send_##_name##_Buf((char *)&d, 3);                                    \
}                                                                           \
void Send_##_name##_D(u32 d)                                                \
{                                                                           \
      Send_##_name##_Buf((char *)&d, 4);                                    \
}                                                                           \
void Send_##_name##_String(char *s)                                         \
{                                                                           \
      Send_##_name##_Buf(s, strlen(s));                                     \
}                                                                           \
void Send_##_name##_HEX(u32 da, u8 Dig)                                     \
{                                                                           \
    rb_IntToProc(da, rb_istr_mode_HEX | Dig, &Send_##_name##_Byte);         \
}                                                                           \
void Send_##_name##_DEC(u32 da)                                             \
{                                                                           \
    rb_IntToProc(da, rb_istr_mode_DEC, &Send_##_name##_Byte);               \
}                                                                           \
u8 Uart_##_name##_PortStatus(interface_status_t *prtst)                     \
{                                                                           \
  if (prtst)                                                                \
  {                                                                         \
    prtst->baud = usb##_usbcdc.usbdata->lineCoding.bitrate;                 \
    prtst->datatype = usb##_usbcdc.usbdata->lineCoding.datatype;            \
    prtst->format = usb##_usbcdc.usbdata->lineCoding.format;                \
    prtst->paritytype = usb##_usbcdc.usbdata->lineCoding.paritytype;        \
    prtst->RTS = 0;                                                         \
    prtst->DTR = 0;                                                         \
    prtst->isConnected = usb##_usbcdc.usbdata->stateCOM.isConnected;        \
  }                                                                         \
  return usb##_usbcdc.usbdata->stateCOM.isConnected;                        \
}                                                                           \
u8 Uart_##_name##_isConnected(void)                                         \
{                                                                           \
  return usb##_usbcdc.usbdata->stateCOM.isConnected;                        \
}                                                                           \
void Uart_##_name##_isConnectedSet(u8 b)                                    \
{                                                                           \
  usb##_usbcdc.usbdata->stateCOM.isConnected=b;                             \
}                                                                           \
void Uart_##_name##_Init(u32 baud, u8 parstop)                              \
{                                                                           \
    rb_fifo_flush(&uart_##_name##_fifo_in, rb_fifo_size(&uart_##_name##_fifo_in));        \
    rb_fifo_flush(&uart_##_name##_fifo_out, rb_fifo_size(&uart_##_name##_fifo_out));      \
    usb##_usbcdc.fifo_in = &uart_##_name##_fifo_in;                         \
    usb##_usbcdc.fifo_out = &uart_##_name##_fifo_out;                       \
    if (bDeviceState != CONFIGURED)                                         \
    {                                                                       \
      USBEN_OFF();                                                          \
      DelayMS(100);                                                         \
      USB_Prepare();                                                        \
      USB_Init();                                                           \
      DelayMS(1000);                                                        \
      USBEN_ON();                                                           \
    }                                                                       \
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////




interface_USART_MacroFunctionGenerator(RS,USART1,256,32);
//interface_USART_MacroFunctionGenerator(RS232,USART2,128,128);
//interface_USART_MacroFunctionGenerator(RS485,USART3,128,128);




//interface_USB_MacroFunctionGenerator(DC0,CDC0,128,128);
//interface_USB_MacroFunctionGenerator(DC1,CDC1,128,128);



//uartCDC0_fifo_in

void InterfaceInit(void)
{
}


