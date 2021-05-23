//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __RB_BASE64M_H
#define __RB_BASE64M_H

#include "SysType.h"

#define BASE64_T_DEF    "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#" //$%&()*+,-./:;<=>?[\\]^_@"

#pragma pack(push, 2)
typedef struct {
    u8 *bTbl;
    u16 m;
    u16 w;
}tBase64m;
#pragma pack(pop)

extern tBase64m bas64m;

extern void BASE64m_Init(tBase64m *bas, const u8 *bTbl);

extern void BASE64m_EnCodeStart(tBase64m *bas);
extern u16 BASE64m_EnCodeStep(tBase64m *bas, u8 b);
extern u16 BASE64m_EnCodeFlush(tBase64m *bas);
extern u32 BASE64m_EnCodeStepD(tBase64m *bas, u8 b);
extern u8 BASE64m_EnCodeStepPTR(tBase64m *bas, u8 b, u8 *s);
extern u32 BASE64m_EnCode(tBase64m *bas, char *s, u8 *buf, u32 si);

extern void BASE64m_DeCodeStart(tBase64m *bas);
extern u16 BASE64m_DeCodeStep(tBase64m *bas, char c);
extern u32 BASE64m_DeCode(tBase64m *bas, char *s, u8 *buf);



#endif
