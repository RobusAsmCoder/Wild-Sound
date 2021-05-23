unit rbBase64;

interface



VAR BASE64_T_TBE:ARRAY[0..255] OF BYTE;
    BASE64_T_TBD:ARRAY[0..255] OF BYTE;
    BASE64_T_DEF:STRING='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#$%&()*+,-./:;<=>?[\]^_@';


PROCEDURE BASE64_DEF(S:STRING);
FUNCTION BASE64_EnCode(S:STRING):STRING;
FUNCTION BASE64_DeCode(S:STRING):STRING;

implementation




PROCEDURE BASE64_DEF(S:STRING);
VAR N,M,I:LONGINT;
BEGIN
    FillChar(BASE64_T_TBD, SizeOf(BASE64_T_TBD), 0);
    FillChar(BASE64_T_TBE, SizeOf(BASE64_T_TBE), 0);
    FOR N:=1 TO Length(S) DO BEGIN
     BASE64_T_TBD[BYTE(S[N])]:=N-1;
     BASE64_T_TBE[N-1]:=BYTE(S[N]);
    END;
END;

FUNCTION BASE64_EnCode(S:STRING):STRING;
VAR N,M,I:LONGINT;
    B:WORD;
BEGIN
    RESULT:='';
    M:=0;
    N:=1;
    WHILE N<=Length(S) DO BEGIN
     CASE M AND 3 OF
      0:BEGIN
       B:=BYTE(S[N]);
       INC(N);
       RESULT:=RESULT+CHAR(BASE64_T_TBE[B AND 63]);
       B:=B SHR 6;
       RESULT:=RESULT+CHAR(BASE64_T_TBE[B]);
      END;
      1:BEGIN
       B:=B OR (BYTE(S[N]) SHL 2);
       INC(N);
       RESULT[Length(RESULT)]:=CHAR(BASE64_T_TBE[B AND 63]);
       B:=B SHR 6;
       RESULT:=RESULT+CHAR(BASE64_T_TBE[B]);
      END;
      2:BEGIN
       B:=B OR (BYTE(S[N]) SHL 4);
       INC(N);
       RESULT[Length(RESULT)]:=CHAR(BASE64_T_TBE[B AND 63]);
       B:=B SHR 6;
       RESULT:=RESULT+CHAR(BASE64_T_TBE[B]);
       INC(M);
      END;
     END;
     INC(M);

    END;

END;


//10111111 00101010


FUNCTION BASE64_DeCode(S:STRING):STRING;
VAR N,M,I:LONGINT;
    B:WORD;
BEGIN

    RESULT:='';
    N:=1;
    M:=0;
    WHILE N<=Length(S) DO BEGIN
     CASE M AND 3 OF
      0:BEGIN
       B:=BASE64_T_TBD[BYTE(S[N])] SHL 8;
      END;
      1:BEGIN
       B:=B OR (BASE64_T_TBD[BYTE(S[N])] SHL 6);
       RESULT:=RESULT + CHAR(B AND 255);
      END;
      2:BEGIN
       B:=B OR (BASE64_T_TBD[BYTE(S[N])] SHL 4);
       RESULT:=RESULT + CHAR(B AND 255);
      END;
      3:BEGIN
       B:=B OR (BASE64_T_TBD[BYTE(S[N])] SHL 2);
       RESULT:=RESULT + CHAR(B AND 255);
      END;
     END;
     B:=B SHR 8;
     INC (N);
     INC (M);
    END;
END;



BEGIN

    BASE64_DEF(BASE64_T_DEF);
//    BasCRC32.ID:='';
//    BasCRC16.ID:='';
//    CRC_OPEN(BasCRC32, $04C11DB7, CRC_MODE_32 OR CRC_REVERT);
//    CRC_OPEN(BasCRC16, $15AE, CRC_MODE_16);

//    CrcTest();

END.
