//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __INTERFACE_H
#define __INTERFACE_H

#include "SysType.h"
#include "rb_fifo.h"
//#include "hdUSBCDC.h"
#include "hdports.h"

typedef struct {
  u32 baud;
  u8 format;
  u8 paritytype;
  u8 datatype;
  u8 isConnected;
  u8 RTS;
  u8 DTR;
}interface_status_t;

//typedef struct {
//  u16 hold_mode;    //0x00xx - send data; 0x10xx - start; 0x20xx - end
//  u32 hold_timer;
//}interface_t;
enum {
  interface_GPIO_OFF      = 0,
  interface_GPIO_ON       = 1,
  interface_GPIO_TX_OFF   = 2,
  interface_GPIO_TX_ON    = 3,
  interface_GPIO_DIR_RD   = 4,
  interface_GPIO_DIR_WR   = 5,
};


#define interface_USART_MacroFunctionConfig(_name)                                    \
extern Trb_fifo uart_##_name##_fifo_in;                                               \
extern Trb_fifo uart_##_name##_fifo_out;                                              \
extern u8 Echo_##_name##_isEnabled(void);                                             \
extern void Echo_##_name##_Enable(void);                                              \
extern void Echo_##_name##_Disable(void);                                             \
extern u16 Read_##_name##_Size(void);                                                 \
extern void Read_##_name##_Flush(void);                                               \
extern u16 Read_##_name##_Byte(void);                                                 \
extern void Send_##_name##_B(u8 c);                                                   \
extern void Send_##_name##_W(u16 w);                                                  \
extern void Send_##_name##_Q(u32 d);                                                  \
extern void Send_##_name##_D(u32 d);                                                  \
extern u16 Send_##_name##_BLK(char *s, u32 siz);                                      \
extern u16 Read_##_name##_Buf(char *s, u32 siz);                                      \
extern u16 Send_##_name##_FREE(void);                                                 \
extern u16 Send_##_name##_FREEBusy(void);                                             \
extern u16 Send_##_name##_isBusy(void);                                               \
extern void Send_##_name##_WaitFlush(void);                                           \
extern void GPIO_##_name##_SetMode(u8 mode);                                          \
extern void Send_##_name##_Hold(u16 hold);                                            \
extern void Send_##_name##_Start(u16 hold);                                           \
extern void Send_##_name##_End(u16 hold);                                             \
extern void Send_##_name##_Buf(char *s, u32 siz);                                     \
extern void Send_##_name##_Byte(u8 c);                                                \
extern void Send_##_name##_String(char *s);                                           \
extern void Send_##_name##_HEX(u32 da, u8 Dig);                                       \
extern void Send_##_name##_DEC(u32 da);                                               \
extern u8 Uart_##_name##_PortStatus(interface_status_t *prtst);                       \
extern u8 Uart_##_name##_isConnected(void);                                           \
extern void Uart_##_name##_isConnectedSet(u8 b);                                      \
extern void Uart_##_name##_Init(u32 baud, u8 parstop);                                \


//hdPin_O_DefineSetup(USART1_TX,      A,  9, hd_gptp_AF_PPU,     1);
//hdPin_O_DefineSetup(USART1_RX,      A, 10, hd_gptp_IN_PPU,     1);
hdPin_O_DefineSetup(USART1_TX_ON,      A,  9, hd_gptp_AF_PPU,     1);
hdPin_O_DefineSetup(USART1_TX_OFF,     A,  9, hd_gptp_OUT_PP,     1);
hdPin_O_DefineSetup(USART1_RX_ON,      A, 10, hd_gptp_AF_PP,     1);
hdPin_O_DefineSetup(USART1_RX_OFF,     A, 10, hd_gptp_IN_OD,      1);
#define USART1_DIR(_v)

interface_USART_MacroFunctionConfig(RS);
//interface_USART_MacroFunctionConfig(RS232);
//interface_USART_MacroFunctionConfig(RS485);

//interface_USART_MacroFunctionConfig(DC0);
//interface_USART_MacroFunctionConfig(DC1);


extern void Uart_CFG(USART_InitTypeDef *USART_InitStructure, u32 baud, u8 parstop);
extern void InterfaceInit(void);

#endif
