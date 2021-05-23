unit rb_crc16;

interface
//USES Windows;

FUNCTION crc16_byte(b:BYTE; c16:WORD):WORD;
FUNCTION crc16_blk(VAR src; size:DWORD; start:WORD):WORD;
FUNCTION crc16_blk_CCITT(VAR src; size:DWORD):WORD;
FUNCTION crc16_str_CCITT(s:STRING):WORD;

implementation



FUNCTION crc16_byte(b:BYTE; c16:WORD):WORD;
VAR t:WORD;
BEGIN
        c16 := c16 XOR b;
        t := (c16 XOR (c16 SHL 4)) AND $00ff;
        c16 := (c16 SHR 8) XOR (t SHL 8) XOR (t SHL 3) XOR (t SHR 4);
        RESULT:=c16;
END;

FUNCTION crc16_blk(VAR src; size:DWORD; start:WORD):WORD;
VAR c16:WORD;
    p:PBYTE;
BEGIN
  c16 := start;
        //const u8      *p              = (u8*)src;
  p:=@src;
  while(size<>0) DO BEGIN
   c16 := crc16_byte(PBYTE(p)^, c16);
   INC(p);
   DEC(size);
  END;
  RESULT:=c16;
END;

FUNCTION crc16_blk_CCITT(VAR src; size:DWORD):WORD;
BEGIN
  RESULT := crc16_blk(src, size, $15AE);
END;

FUNCTION crc16_str_CCITT(s:STRING):WORD;
BEGIN
  RESULT:=crc16_blk_CCITT(s[1], LENGTH(s));
END;

BEGIN
end.
