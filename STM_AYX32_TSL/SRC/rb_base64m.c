//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "rb_base64m.h"
#include <string.h>


tBase64m bas64m;

////////////////////////////////////////////////
// Init
////////////////////////////////////////////////
void BASE64m_Init(tBase64m *bas, const u8 *bTbl)
{
      bas->bTbl = (u8 *)bTbl;
}

//char to byte
u8 BASE64_T_TBD(tBase64m *bas, u8 N)
{
  const char *pt=(char *)(&bas->bTbl[0]);
  const char *pf=memchr(pt,N,64);
  return (pf==0) ? 0 : (u8)((u32)(&pf[0])-(u32)(&pt[0]));
}

////////////////////////////////////////////////
// EnCode procedures
////////////////////////////////////////////////

#define BASE64_T_TBE(_bas, _N)    _bas->bTbl[_N]

void BASE64m_EnCodeStart(tBase64m *bas)
{
    bas->m = 0;
    bas->w = 0;
}
//OUT: if return hi(word)==1 then buffered one byte
u16 BASE64m_EnCodeStep(tBase64m *bas, u8 b)
{
      u16 res=0;
      switch (bas->m & 3)
      {
        case 0:
          bas->w=b;
          res = BASE64_T_TBE(bas, bas->w & 63) | 0x0000;
          bas->w>>=6;
          break;
        case 1:
          bas->w |= b << 2;
          res = BASE64_T_TBE(bas, bas->w & 63) | 0x0000;
          bas->w>>=6;
          break;
        case 2:
          bas->w |= b << 4;
          res = BASE64_T_TBE(bas, bas->w & 63) | 0x0100;
          bas->w>>=6;
          break;
        case 3:
          res = BASE64_T_TBE(bas, bas->w) | 0x0000;
          break;
      }
      bas->m++;
      return res;
}

//OUT: non zerro if done
u16 BASE64m_EnCodeFlush(tBase64m *bas)
{
      switch (bas->m & 3)
      {
        case 1:
        case 2:
          return BASE64_T_TBE(bas, bas->w) | 0x0100;
      }
      return 0;
}

// IN:bas - struct param of Base64
//    b   - incoming char
//OUT:SIxxDHDL - DL - first byte
//               DH - second byte
//               SI - size of byte (1 or 2)
u32 BASE64m_EnCodeStepD(tBase64m *bas, u8 b)
{
    u32 d=BASE64m_EnCodeStep(bas, b);
    if ( (d & 0x0100)==0 )
    {
      d = (u8)(d) | 0x01000000;
    } else {
      d = (u8)(d) | 0x02000000 | ((u8)(BASE64m_EnCodeStep(bas,0))<<8);
    }
    return d;
  
}

// IN:bas - struct param of Base64
//    b   - incoming char
//    buf - out buf update 1 or 2 bytes !!!
//OUT:Size
u8 BASE64m_EnCodeStepPTR(tBase64m *bas, u8 b, u8 *s)
{
    u32 d=BASE64m_EnCodeStepD(bas, b);
    *s++=d;
    if (d&0x02000000)
    {
      *s++=d;
    }
    return d>>24;
}

// IN:bas - struct param of Base64
//    s   - destination string
//    buf - source binary data
//    si  - size
//OUT:size encodet string
u32 BASE64m_EnCode(tBase64m *bas, char *s, u8 *buf, u32 si)
{   //56112
    u32 ss=0;
    u32 d;
    BASE64m_EnCodeStart(bas);
    while(si)
    { 
      d = BASE64m_EnCodeStepD(bas, *buf++);
      *s++=d;
      ss++;
      if (d&0x02000000)
      {
        *s++=d>>8;
        ss++;
      }
      si--;
    }
    d=BASE64m_EnCodeFlush(bas);
    if (d)
    {
      *s++=d;
      ss++;
    }
    *s=0;
    return ss;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////
// DeCode procedures
////////////////////////////////////////////////

void BASE64m_DeCodeStart(tBase64m *bas)
{
    bas->m = 0;
    bas->w = 0;
}
// return zerro if not complete
u16 BASE64m_DeCodeStep(tBase64m *bas, char c)
{
    
    u16 res=0x0000;
    switch (bas->m & 3)
    {
      case 0:
        bas->w = BASE64_T_TBD(bas, c)<<8;
        break;
      case 1:
        bas->w|= BASE64_T_TBD(bas, c)<<6;
        res = (u8)(bas->w) | 0x0100;
        break;
      case 2:
        bas->w|= BASE64_T_TBD(bas, c)<<4;
        res = (u8)(bas->w) | 0x0100;
        break;
      case 3:
        bas->w|= BASE64_T_TBD(bas, c)<<2;
        res = (u8)(bas->w) | 0x0100;
        break;
    }
    bas->w>>=8;
    bas->m++;
    return res;
}

u32 BASE64m_DeCode(tBase64m *bas, char *s, u8 *buf)
{
    u8 c;
    u32 si=0;
    BASE64m_DeCodeStart(bas);
    while ( (c=*s++)!=0 )
    {
      u16 w=BASE64m_DeCodeStep(bas,c);
      if (w)
      {
        buf[si++]=w;
      }
    }
    return si;
}






