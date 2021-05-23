//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////
#ifndef __RB_CRC16_H__
#define __RB_CRC16_H__

#include "SysType.h"

#define crc16_CCITT_StartValue    (u16)(0x15AE)

extern u16 crc16_byte(u8 b, u16 c16);
extern u16 crc16_blk(void *src, u32 size, u16 start);
extern u16 crc16_blk_CCITT(void *src, u32 size);
extern u16 crc16_str_CCITT(void *src);

#define	isCRC16_check( data, sz, start_CRC16, check_CRC16 )                   \
                    ( (get_crc16( data, sz, start_CRC16) == check_CRC16 ) ?   \
                    TRUE : FALSE )

#endif
