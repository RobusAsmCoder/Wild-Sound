//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "rb_crc16.h"

u16 crc16_byte(u8 b, u16 c16)
{
  u16 t;
  c16 ^= b;
  t = (c16 ^ (c16<<4))&0x00ff;
  c16 = (c16>>8)^(t<<8)^(t<<3)^(t>>4);
  return c16;
}

u16 crc16_blk(void *src, u32 size, u16 start)
{
  u16 c16 = start;
  const u8 *p = (u8*)src;
  while(size--) c16 = crc16_byte(*p++, c16);
  return c16;
}

u16 crc16_blk_CCITT(void *src, u32 size)
{
  return crc16_blk(src, size, crc16_CCITT_StartValue);
}

u16 crc16_str_CCITT(void *src)
{
  u16 c16=crc16_CCITT_StartValue;
  const u8 *p = (u8*)src;
  while(*p) c16 = crc16_byte(*p++, c16);
  return c16;
} 
