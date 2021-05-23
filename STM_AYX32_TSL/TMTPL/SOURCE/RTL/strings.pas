(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       The Strings Unit                                       *)
(*       Targets: MS-DOS, OS/2, Win32                           *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Authors: Anton Moscal, Vadim Bodrov                    *)
(*                                                              *)
(****************************************************************)

unit Strings;

{$i-,opt+,a+,cc+}

interface

function  Dup_SI(const s: String; n: Longint): String;
overload  * = Dup_SI;
function  Dup_CI(c: Char; n: Longint): String;
overload  * = Dup_CI;
procedure StrAppend(var dst: String; const src: String);
overload  +:= = StrAppend;
procedure StrAppendC(var dst: String; src: Char);
overload  +:= = StrAppendC;

function  LowerCase(str: String): String;
function  UpperCase(str: String): String;

function  StrCopyW(dst, src: PWChar): PWChar;
overload  StrCopy = StrCopyW;
function  StrCopyA(dst, src: PChar): PChar;
overload  StrCopy = StrCopyA;
function  StrLenW(str: PWChar): Longint;
overload  StrLen = StrLenW;
function  StrLenA(str: PChar): Longint;
overload  StrLen = StrLenA;
function  StrEndW(str: PWChar): PWChar;
overload  StrEnd = StrEndW;
function  StrEndA(str: PChar): PChar;
overload  StrEnd = StrEndA;
function  StrMoveW(dst, src: PWChar; count: Longint): PWChar;
overload  StrMove = StrMoveW;
function  StrMoveA(dst, src: PChar; count: Longint): PChar;
overload  StrMove = StrMoveA;
function  StrECopyW(dst, src: PWChar): PWChar;
overload  StrECopy = StrECopyW;
function  StrECopyA(dst, src: PChar): PChar;
overload  StrECopy = StrECopyA;
function  StrLCopyW(dst, src: PWChar; maxlen: Longint): PWChar;
overload  StrLCopy = StrLCopyW;
function  StrLCopyA(dst, src: PChar; maxlen: Longint): PChar;
overload  StrLCopy = StrLCopyA;
function  StrPCopyW(dst: PWChar; const src: String ): PWChar;
overload  StrPCopy = StrPCopyW;
function  StrPCopyA(dst: PChar; const src: String ): PChar;
overload  StrPCopy = StrPCopyA;
function  StrCatW(dst, src: PWChar): PWChar;
overload  StrCat = StrCatW;
function  StrCatA(dst, src: PChar): PChar;
overload  StrCat = StrCatA;
function  StrLCatW(dst, src: PWChar; maxlen: Longint): PWChar;
overload  StrLCat = StrLCatW;
function  StrLCatA(dst, src: PChar; maxlen: Longint): PChar;
overload  StrLCat = StrLCatA;
function  StrCompW(str1, str2: PWChar): Longint;
overload  StrComp = StrCompW;
function  StrCompA(str1, str2: PChar): Longint;
overload  StrComp = StrCompA;
function  StrICompW(str1, str2: PWChar): Longint;
overload  StrIComp = StrICompW;
function  StrICompA(str1, str2: PChar): Longint;
overload  StrIComp = StrICompA;
function  StrLCompW(str1, str2: PWChar; maxlen: Longint): Longint;
overload  StrLComp = StrLCompW;
function  StrLCompA(str1, str2: PChar; maxlen: Longint): Longint;
overload  StrLComp = StrLCompA;
function  StrLICompW(str1, str2: PWChar; maxlen: Longint): Longint;
overload  StrLIComp = StrLICompW;
function  StrLICompA(str1, str2: PChar; maxlen: Longint): Longint;
overload  StrLIComp = StrLICompA;
function  StrScanW(str: PWChar; chr: WChar): PWChar;
overload  StrScan = StrScanW;
function  StrScanA(str: PChar; chr: Char): PChar;
overload  StrScan = StrScanA;
function  StrRScanW(str: PWChar; chr: WChar): PWChar;
overload  StrRScan = StrRScanW;
function  StrRScanA(str: PChar; chr: Char): PChar;
overload  StrRScan = StrRScanA;
function  StrPosW(str1, str2: PWChar): PWChar;
overload  StrPos = StrPosW;
function  StrPosA(str1, str2: PChar): PChar;
overload  StrPos = StrPosA;
function  StrUpperW(str: PWChar): PWChar;
overload  StrUpper = StrUpperW;
function  StrUpperA(str: PChar): PChar;
overload  StrUpper = StrUpperA;
function  StrLowerW(str: PWChar): PWChar;
overload  StrLower = StrLowerW;
function  StrLowerA(str: PChar): PChar;
overload  StrLower = StrLowerA;
function  StrPasW(str: PWChar): String;
overload  StrPas = StrPasW;
function  StrPasA(str: PChar): String;
overload  StrPas = StrPasA;
function  StrNewW(str: PWChar): PWChar;
overload  StrNew = StrNewW;
function  StrNewA(str: PChar): PChar;
overload  StrNew = StrNewA;
procedure StrDisposeW(str: PWChar);
overload  StrDispose = StrDisposeW;
procedure StrDisposeA(str: PChar);
overload  StrDispose = StrDisposeA;

function  Hex64(n: Int64): String [20];
overload  Hex = Hex64;
function  Hex32(n: Longint): String [12];
overload  Hex = Hex32;
function  Whl(n: Longint): String [12];
function  Uns(n: DWORD): String [12];
function  Flt(x: extended; w: Longint): String;
function  Fls(x: Extended): String;
function  Fix(x: extended; w, pr: Longint): String;
function  Align(str: String; w: Longint): String;
function  HexVal(const s: String): Int64;
function  Bin64(n: Longint): String[64];
overload  Bin = Bin64;
function  Bin32(n: Longint): String[32];
overload  Bin = Bin32;

function  IntToStr(Value: Longint): String;
function  StrToInt(const S: String): Longint;
function  HexStr(var Num; ByteCount: DWORD): String;
function  IntToHex64(Value: Int64; Digits: DWORD): String;
overload  IntToHex = IntToHex64;
function  IntToHex32(Value: Longint; Digits: DWORD): String;
overload  IntToHex = IntToHex32;
function  BinStr(var Num; ByteCount: DWORD): String;
function  IntToBin64(Value: Int64; Digits: DWORD): String;
overload  IntToBin = IntToBin64;
function  IntToBin32(Value: Longint; Digits: DWORD): String;
overload  IntToBin = IntToBin32;

function  FloatToStr(Value: Extended): String;

function  TrimLeftS(const S: String): String;
overload  TrimLeft = TrimLeftS;
function  TrimRightS(const S: String): String;
overload  TrimRight = TrimRightS;
function  TrimS(const S: String): String;
overload  Trim = TrimS;

function  TrimLeftC(const S: String; const C: Char): String;
overload  TrimLeft = TrimLeftC;
function  TrimRightC(const S: String; const C: Char): String;
overload  TrimRight = TrimRightC;
function  TrimC(const S: String; const C: Char): String;
overload  Trim = TrimC;

function  QuotedStr(const S: String): String;
function  IsValidIdent(const Ident: String): Boolean;
function  StrToIntDef(const S: String; Default: Longint): Longint;
function  IsPathDelimiter(const S: String; IndexPos: Longint): Boolean;
function  IsDelimiter(const Delimiters, S: String; IndexPos: Longint): Boolean;
function  LastDelimiter(const Delimiters, S: String): Longint;
function  AppendPathDelimiter(const S: String): String;

function  AnsiUpperCase(S: String): String;
function  AnsiLowerCase(S: String): String;
function  AnsiCompareStr(S1, S2: String): Longint;
function  AnsiCompareText(S1, S2: String): Longint;

function  AnsiStrCompW(S1, S2: PWChar): Longint;
overload  AnsiStrComp = AnsiStrCompW;
function  AnsiStrCompA(S1, S2: PChar): Longint;
overload  AnsiStrComp = AnsiStrCompA;
function  AnsiStrICompW(S1, S2: PWChar): Longint;
overload  AnsiStrIComp = AnsiStrICompW;
function  AnsiStrICompA(S1, S2: PChar): Longint;
overload  AnsiStrIComp = AnsiStrICompA;
function  AnsiStrLCompW(S1, S2: PWChar; MaxLen: DWORD): Longint;
overload  AnsiStrLComp = AnsiStrLCompW;
function  AnsiStrLCompA(S1, S2: PChar; MaxLen: DWORD): Longint;
overload  AnsiStrLComp = AnsiStrLCompA;
function  AnsiStrLICompW(S1, S2: PWChar; MaxLen: DWORD): Longint;
overload  AnsiStrLIComp = AnsiStrLICompW;
function  AnsiStrLICompA(S1, S2: PChar; MaxLen: DWORD): Longint;
overload  AnsiStrLIComp = AnsiStrLICompA;
function  AnsiStrLowerW(Str: PWChar): PWChar;
overload  AnsiStrLower = AnsiStrLowerW;
function  AnsiStrLowerA(Str: PChar): PChar;
overload  AnsiStrLower = AnsiStrLowerA;
function  AnsiStrUpperW(Str: PWChar): PWChar;
overload  AnsiStrUpper = AnsiStrUpperW;
function  AnsiStrUpperA(Str: PChar): PChar;
overload  AnsiStrUpper = AnsiStrUpperA;

function  CompareStr(S1, S2: String): Longint;
function  CompareText(S1, S2: String): Longint;

implementation

{$ifdef __WIN32__}
uses Windows;
{$endif}

function Dup_SI(const s: String; n: Longint): String;
var
  i: Longint;
begin
  Length(result) := 0;
  for i := 1 to n do Result +:= s;
end;

function Dup_CI(c: Char; n: Longint): String; code;
asm
     push ecx
     mov ecx, [n+4]
     cmp ecx, 0FFh
     jle @1
     mov ecx, 0FFh
@1:  or  ecx, ecx
     jge @2
     xor ecx, ecx
@2:  mov al, cl
     mov edi, [@Result+4]
     stosb
     jecxz @3
     mov al, [c+4]
     rep stosb
@3:  pop ecx
     ret
end;

procedure StrAppend(var dst: String; const src: String);
begin
  dst := dst + src;
end;

procedure StrAppendC(var dst: String; src: Char); code;
asm
     mov   edi, dword ptr [dst]
     movzx esi, byte ptr [edi]
     cmp   esi, dword ptr [dst+4]
     jae   @L1
     inc   byte ptr [edi]
     mov   al, src
     mov   [edi+esi+1], al
@L1: ret
end;

function UpperCase(str: String): String; code;
asm
     push  ecx
     mov   edi, [@Result+4]
     mov   esi, [str+4]
     lodsb
     movzx ecx, al
     stosb
     or    ecx, ecx
     jz    @@end
@@loop:
     lodsb
     sub   al, 'a'
     cmp   al, 'z' - 'a'
     jbe   @@skip
     add   al, 32
@@skip:
     add   al, 'A'
     stosb
     loop  @@loop
@@end:
     pop   ecx
     ret
end;

function LowerCase(str: String): String; code;
asm
     push  ecx
     mov   edi, @Result+4
     mov   esi, str+4
     lodsb
     movzx ecx, al
     stosb
     or    ecx, ecx
     jz    @@end
@@loop:
     lodsb
     sub   al, 'A'
     cmp   al, 'z' - 'a'
     ja    @@skip
     add   al, 32
@@skip:
     add   al, 'A'
     stosb
     loop  @@loop
@@end:
     pop   ecx
     ret
end;

function StrCopyA(dst, src: PChar): PChar; code;
asm
     mov     esi, [dst]
     mov     edi, [src]
     push    ecx
     push    edx
     mov     ecx, 0FFFFFFFFh
     xor     eax, eax
     repne   scasb
     not     ecx
     mov     edi, esi
     mov     esi, [src + 8]
     mov     edx, ecx
     mov     eax, edi
     shr     ecx, 2
     rep     movsd
     mov     ecx, edx
     and     ecx, 3
     rep     movsb
     pop     edx
     pop     ecx
     ret
end;

function StrCopyW(dst, src: PWChar): PWChar; code;
asm
     mov     esi, [dst]
     mov     edi, [src]
     push    ecx
     push    edx
     mov     ecx, 0FFFFFFFFh
     xor     eax, eax
     repne   scasw
     not     ecx
     mov     edi, esi
     mov     esi, [src + 8]
     mov     edx, ecx
     mov     eax, edi
     rep     movsw
     pop     edx
     pop     ecx
     ret
end;

function StrLenA(str: PChar): Longint; code;
asm
     push   ecx
     mov    edi, [str+4]
     stc
     sbb    ecx, ecx
     xor    eax, eax
     cmp    edi, 0
     jz     @@1
     repne  scasb
     mov    eax, 0FFFFFFFEh
     sub    eax, ecx
     pop    ecx
     ret
@@1: pop    ecx
     ret
end;

function StrLenW(str: PWChar): Longint; code;
asm
     push   ecx
     mov    edi, [str+4]
     stc
     sbb    ecx, ecx
     xor    eax, eax
     cmp    edi, 0
     jz     @@1
     repne  scasw
     mov    eax, 0FFFFFFFEh
     sub    eax, ecx
     pop    ecx
     ret
@@1: pop    ecx
     ret

end;

function StrEndA(str: PChar): PChar; code;
asm
     push   ecx
     mov    edi, [str+4]
     stc
     sbb    ecx, ecx
     xor    eax, eax
     repne  scasb
     mov    eax, edi
     dec    eax
     pop    ecx
     ret
end;

function StrEndW(str: PWChar): PWChar; code;
asm
     push   ecx
     mov    edi, [str+4]
     stc
     sbb    ecx, ecx
     xor    eax, eax
     repne  scasw
     mov    eax, edi
     sub    eax, 2
     pop    ecx
     ret
end;

function StrMoveA(Dst, Src: PChar; Count: Longint): PChar; code;
asm
     push    edx
     push    ecx
     mov     esi, [src+8]
     mov     edi, [dst+8]
     mov     edx, [count+8]
     mov     ecx, edx
     cmp     edi, esi
     jg      @L1
     je      @L2
     shr     ecx, 2
     rep     movsd
     mov     ecx, edx
     and     ecx, 3
     rep     movsb
     jmp     @L2
@L1: lea     esi, [esi+ecx-1]
     lea     edi, [edi+ecx-1]
     and     ecx, 3
     std
     rep     movsb
     sub     esi, 3
     sub     edi, 3
     mov     ecx, edx
     shr     ecx, 2
     rep     movsd
     cld
@L2: pop     ecx
     pop     edx
     ret
end;

function StrMoveW(Dst, Src: PWChar; Count: Longint): PWChar; code;
asm
     push    edx
     push    ecx
     mov     esi, [src+8]
     mov     edi, [dst+8]
     mov     edx, [count+8]
     mov     ecx, edx
     cmp     edi, esi
     jg      @L1
     je      @L2
     rep     movsw
     jmp     @L2
@L1: push    ecx
     shl     ecx, 1
     lea     esi, [esi+ecx-2]
     lea     edi, [edi+ecx-2]
     pop     ecx
     std
     rep     movsw
     cld
@L2: pop     ecx
     pop     edx
     ret
end;

function StrECopyA(dst, src: PChar): PChar; code;
asm
     push  ecx
     mov   edi, [src+4]
     stc
     sbb   ecx, ecx
     xor   eax, eax
     repne scasb
     not   ecx
     mov   esi, [src+4]
     mov   edi, [dst+4]
     rep   movsb
     lea   eax, [edi-1]
     pop   ecx
     ret
end;

function StrECopyW(dst, src: PWChar): PWChar; code;
asm
     push  ecx
     mov   edi, [src+4]
     stc
     sbb   ecx, ecx
     xor   eax, eax
     repne scasw
     not   ecx
     mov   esi, [src+4]
     mov   edi, [dst+4]
     rep   movsw
     lea   eax, [edi-2]
     pop   ecx
     ret
end;

function StrLCopyA(dst, src: PChar; maxlen: Longint): PChar; code;
asm
     push  ecx
     mov   edi, [src+4]
     mov   ecx, [maxlen+4]
     mov   esi, ecx
     xor   eax, eax
     repne scasb
     sub   esi, ecx
     mov   ecx, esi
     mov   esi, [src+4]
     mov   edi, [dst+4]
     mov   eax, edi
     rep   movsb
     mov   byte ptr [edi], 0
     pop   ecx
     ret
end;

function StrLCopyW(dst, src: PWChar; maxlen: Longint): PWChar; code;
asm
     push  ecx
     mov   edi, [src+4]
     mov   ecx, [maxlen+4]
     mov   esi, ecx
     xor   eax, eax
     repne scasw
     sub   esi, ecx
     mov   ecx, esi
     mov   esi, [src+4]
     mov   edi, [dst+4]
     mov   eax, edi
     rep   movsw
     mov   word ptr [edi], 0
     pop   ecx
     ret
end;

function StrPCopyA(dst: PChar; const src: String): PChar; code;
asm
     push   ebx
     mov    esi, [src+4]
     mov    edi, [dst+4]
     mov    ebx, edi
     xor    eax, eax
     lodsb
     xchg   eax, ecx
     rep    movsb
     xchg   eax, ecx
     xor    eax, eax
     stosb
     xchg   eax, ebx
     pop    ebx
     ret
end;

function StrPCopyW(dst: PWChar; const src: String): PWChar; code;
asm
     push   ebx
     mov    esi, [src+4]
     mov    edi, [dst+4]
     mov    ebx, edi
     xor    eax, eax
     lodsb
     xchg   eax, ecx
     xor    eax, eax
@@1: lodsb
     stosw
     loop   @@1
     xchg   eax, ecx
     xor    eax, eax
     stosw
     xchg   eax, ebx
     pop    ebx
     ret
end;

function StrCompA(str1, str2: PChar): Longint; code;
asm
     push   ecx
     mov    edi, [str2+4]
     mov    esi, edi
     stc
     sbb    ecx, ecx
     xor    eax, eax
     repne  scasb
     not    ecx
     mov    edi, [str1+4]
     repe   cmpsb
     mov    al, [edi-1]
     movzx  ecx, byte ptr [esi-1]
     sub    eax, ecx
     pop    ecx
     ret
end;

function StrCompW(str1, str2: PWChar): Longint; code;
asm
     push   ecx
     mov    edi, [str2+4]
     mov    esi, edi
     stc
     sbb    ecx, ecx
     xor    eax, eax
     repne  scasw
     not    ecx
     mov    edi, [str1+4]
     repe   cmpsw
     mov    ax, [edi-2]
     movzx  ecx, word ptr [esi-2]
     sub    eax, ecx
     pop    ecx
     ret
end;

function StrICompA(str1, str2: PChar): Longint; code;
asm
     push    ecx
     push    edx
     mov     edx, [str2+8]
     mov     edi, edx
     mov     esi, [str1+8]
     mov     ecx, 0FFFFFFFFh
     xor     eax, eax
     repne   scasb
     not     ecx
     mov     edi, edx
     xor     edx, edx
@L1: repe    cmpsb
     je      @L4
     mov     al, [esi-1]
     cmp     al, 'a'
     jb      @L2
     cmp     al, 'z'
     ja      @L2
     sub     al, 20h
@L2: mov     dl, [edi-1]
     cmp     dl, 'a'
     jb      @L3
     cmp     dl, 'z'
     ja      @L3
     sub     dl, 20h
@L3: sub     eax, edx
     je      @L1
@L4: pop     edx
     pop     ecx
     ret
end;

function StrICompW(str1, str2: PWChar): Longint; code;
asm
     push    ecx
     push    edx
     mov     edx, [str2+8]
     mov     edi, edx
     mov     esi, [str1+8]
     mov     ecx, 0FFFFFFFFh
     xor     eax, eax
     repne   scasw
     not     ecx
     mov     edi, edx
     xor     edx, edx
@L1: repe    cmpsw
     je      @L4
     mov     ax, [esi-2]
     cmp     ax, WChar('a')
     jb      @L2
     cmp     ax, WChar('z')
     ja      @L2
     sub     ax, 0020h
@L2: mov     dx, [edi-2]
     cmp     dx, WChar('a')
     jb      @L3
     cmp     dx, WChar('z')
     ja      @L3
     sub     dx, 0020h
@L3: sub     eax, edx
     je      @L1
@L4: pop     edx
     pop     ecx
     ret
end;

function StrLCompA(str1, str2: PChar; maxlen: Longint): Longint; code;
asm
     push    ecx
     push    edx
     push    ebx
     mov     edx, [str2+12]
     mov     edi, edx
     mov     esi, [str1+12]
     mov     ecx, [maxlen+12]
     mov     ebx, ecx
     xor     eax, eax
     or      ecx, ecx
     je      @L1
     repne   scasb
     sub     ebx, ecx
     mov     ecx, ebx
     mov     edi, edx
     xor     edx, edx
     repe    cmpsb
     mov     al, [esi-1]
     mov     dl, [edi-1]
     sub     eax, edx
@L1: pop     ebx
     pop     edx
     pop     ecx
     ret
end;

function StrLCompW(str1, str2: PWChar; maxlen: Longint): Longint; code;
asm
     push    ecx
     push    edx
     push    ebx
     mov     edx, [str2+12]
     mov     edi, edx
     mov     esi, [str1+12]
     mov     ecx, [maxlen+12]
     mov     ebx, ecx
     xor     eax, eax
     or      ecx, ecx
     je      @L1
     repne   scasw
     sub     ebx, ecx
     mov     ecx, ebx
     mov     edi, edx
     xor     edx, edx
     repe    cmpsw
     mov     ax, [esi-2]
     mov     dx, [edi-2]
     sub     eax, edx
@L1: pop     ebx
     pop     edx
     pop     ecx
     ret
end;

function StrLICompA(str1, str2: PChar; maxlen: Longint): Longint; code;
asm
     push    ecx
     push    edx
     push    ebx
     mov     edx, [str2+12]
     mov     edi, edx
     mov     esi, [str1+12]
     mov     ecx, [maxlen+12]
     mov     ebx, ecx
     xor     eax, eax
     or      ecx, ecx
     je      @L4
     repne   scasb
     sub     ebx, ecx
     mov     ecx, ebx
     mov     edi, edx
     xor     edx, edx
@L1: repe    cmpsb
     je      @L4
     mov     al, [esi-1]
     cmp     al, 'a'
     jb      @L2
     cmp     al, 'z'
     ja      @L2
     sub     al, 20h
@L2: mov     dl, [edi-1]
     cmp     dl, 'a'
     jb      @L3
     cmp     dl, 'z'
     ja      @L3
     sub     dl, 20h
@L3: sub     eax, edx
     je      @L1
@L4: pop     ebx
     pop     edx
     pop     ecx
     ret
end;

function StrLICompW(str1, str2: PWChar; maxlen: Longint): Longint; code;
asm
     push    ecx
     push    edx
     push    ebx
     mov     edx, [str2+12]
     mov     edi, edx
     mov     esi, [str1+12]
     mov     ecx, [maxlen+12]
     mov     ebx, ecx
     xor     eax, eax
     or      ecx, ecx
     je      @L4
     repne   scasw
     sub     ebx, ecx
     mov     ecx, ebx
     mov     edi, edx
     xor     edx, edx
@L1: repe    cmpsw
     je      @L4
     mov     ax, [esi-2]
     cmp     ax, WChar('a')
     jb      @L2
     cmp     ax, WChar('z')
     ja      @L2
     sub     ax, 0020h
@L2: mov     dx, [edi-2]
     cmp     dx, WChar('a')
     jb      @L3
     cmp     dx, WChar('z')
     ja      @L3
     sub     dx, 0020h
@L3: sub     eax, edx
     je      @L1
@L4: pop     ebx
     pop     edx
     pop     ecx
     ret
end;

function StrScanA(str: PChar; chr: Char): PChar; code;
asm
    push  ecx
    mov   edi, [str+4]
    mov   esi, edi
    stc
    sbb   ecx, ecx
    xor   eax, eax
    repne scasb
    not   ecx
    mov   edi, esi
    mov   al, [chr+4]
    repne scasb
    mov   eax, 0
    jne   @@ret
    lea   eax, [edi-1]
@@ret:
    pop   ecx
    ret
end;

function StrScanW(str: PWChar; chr: WChar): PWChar; code;
asm
    push  ecx
    mov   edi, [str+4]
    mov   esi, edi
    stc
    sbb   ecx, ecx
    xor   eax, eax
    repne scasw
    not   ecx
    mov   edi, esi
    mov   ax, [chr+4]
    repne scasw
    mov   eax, 0
    jne   @@ret
    lea   eax, [edi-2]
@@ret:
    pop   ecx
    ret
end;

function StrRScanA(str: PChar; chr: Char): PChar; code;
asm
    push  ecx
    mov   edi, [str+4]
    stc
    sbb   ecx, ecx
    xor   eax, eax
    repne scasb
    not   ecx
    std
    dec   edi
    mov   al, [chr+4]
    repne scasb
    mov   eax, 0
    jne   @@ret
    lea   eax, [edi+1]
@@ret:
    cld
    pop   ecx
    ret
end;

function StrRScanW(str: PWChar; chr: WChar): PWChar; code;
asm
    push  ecx
    mov   edi, [str+4]
    stc
    sbb   ecx, ecx
    xor   eax, eax
    repne scasw
    not   ecx
    std
    sub   edi, 2
    mov   ax, [chr+4]
    repne scasw
    mov   eax, 0
    jne   @@ret
    lea   eax, [edi+2]
@@ret:
    cld
    pop   ecx
    ret
end;

function StrPosA(str1, str2: PChar): PChar; code;
asm
     push    ecx
     push    edx
     push    ebx
     mov     edx, [str2+12]
     mov     edi, edx
     mov     eax, [str1+12]
     mov     ebx, eax
     xor     al, al
     mov     ecx, 0FFFFFFFFh
     repne   scasb
     not     ecx
     dec     ecx
     je      @@2
     mov     esi, ecx
     mov     edi, ebx
     mov     ecx, 0FFFFFFFFh
     repne   scasb
     not     ecx
     sub     ecx, esi
     jbe     @@2
     mov     edi, ebx
     lea     ebx, [esi-1]
@@1: mov     esi, edx
     lodsb
     repne   scasb
     jne     @@2
     mov     eax, ecx
     push    edi
     mov     ecx, ebx
     repe    cmpsb
     pop     edi
     mov     ecx, eax
     jne     @@1
     lea     eax, [edi-1]
     jmp     @@3
@@2: xor     eax, eax
@@3: pop     ebx
     pop     edx
     pop     ecx
     ret
end;

function StrPosW(str1, str2: PWChar): PWChar; code;
asm
     push    ecx
     push    edx
     push    ebx
     mov     edx, [str2+12]
     mov     edi, edx
     mov     eax, [str1+12]
     mov     ebx, eax
     xor     ax, ax
     mov     ecx, 0FFFFFFFFh
     repne   scasw
     not     ecx
     dec     ecx
     je      @@2
     mov     esi, ecx
     shl     esi, 1
     mov     edi, ebx
     mov     ecx, 0FFFFFFFFh
     repne   scasw
     not     ecx
     sub     ecx, esi
     jbe     @@2
     mov     edi, ebx
     lea     ebx, [esi-2]
@@1: mov     esi, edx
     lodsw
     repne   scasw
     jne     @@2
     mov     eax, ecx
     push    edi
     mov     ecx, ebx
     repe    cmpsw
     pop     edi
     mov     ecx, eax
     jne     @@1
     lea     eax, [edi-2]
     jmp     @@3
@@2: xor     eax, eax
@@3: pop     ebx
     pop     edx
     pop     ecx
     ret
end;

function StrUpperA(str: PChar): PChar; code;
asm
     mov  esi, [str]
@@loop:
     lodsb
     test  al, al
     je    @@end
     sub   al, 'a'
     cmp   al, 'z' - 'a'
     ja    @@loop
     add   al, 'A'
     mov   [esi-1], al
     jmp   @@loop
@@end:
     mov   eax, [str]
     ret
end;

function StrUpperW(str: PWChar): PWChar; code;
asm
     mov  esi, [str]
@@loop:
     lodsw
     test  ax, ax
     je    @@end
     sub   ax, WChar('a')
     cmp   ax, WChar('z') - WChar('a')
     ja    @@loop
     add   ax, WChar('A')
     mov   [esi-2], ax
     jmp   @@loop
@@end:
     mov   eax, [str]
     ret
end;

function StrLowerA(str: PChar): PChar; code;
asm
     mov  esi, [str]
@@loop:
     lodsb
     test  al, al
     je    @@end
     sub   al, 'A'
     cmp   al, 'Z' - 'A'
     ja    @@loop
     add   al, 'a'
     mov   [esi-1], al
     jmp   @@loop
@@end:
     mov   eax, [str]
     ret
end;

function StrLowerW(str: PWChar): PWChar; code;
asm
     mov  esi, [str]
@@loop:
     lodsw
     test  ax, ax
     je    @@end
     sub   ax, WChar('A')
     cmp   ax, WChar('Z') - WChar('A')
     ja    @@loop
     add   ax, WChar('a')
     mov   [esi-2], ax
     jmp   @@loop
@@end:
     mov   eax, [str]
     ret
end;

function StrPasA(str: PChar): String; code;
asm
     push  ecx
     mov   edi, [str+4]
     stc
     sbb   ecx, ecx
     xor   eax, eax
     repne scasb
     not   ecx
     dec   ecx
     cmp   ecx, 255
     jbe   @@1
     mov   ecx, 255
@@1: mov   esi, [str+4]
     mov   edi, [result+4]
     mov   al, cl
     stosb
     rep   movsb
     pop   ecx
     ret
end;

function StrPasW(str: PWChar): String; code;
asm
     push  ecx
     mov   edi, [str+4]
     stc
     sbb   ecx, ecx
     xor   eax, eax
     repne scasw
     not   ecx
     dec   ecx
     cmp   ecx, 255
     jbe   @@1
     mov   ecx, 255
@@1: mov   esi, [str+4]
     mov   edi, [result+4]
     mov   al, cl
     stosb
@@2: lodsw
     stosb
     loop  @@2
     pop   ecx
     ret
end;

function StrCatA(dst, src: PChar): PChar;
begin
  StrCopyA(StrEndA(dst), src);
  Result := dst;
end;

function StrCatW(dst, src: PWChar): PWChar;
begin
  StrCopyW(StrEndW(dst), src);
  Result := dst;
end;

function StrLCatA(dst, src: PChar; maxlen: Longint): PChar;
var
  ptr: PChar;
  len: Longint;
begin
  ptr := StrEndA(dst);
  len := ptr - dst;
  if len < maxlen then StrLCopyA(ptr, src, maxlen - len);
  Result := dst;
end;

function StrLCatW(dst, src: PWChar; maxlen: Longint): PWChar;
var
  ptr: PWChar;
  len: Longint;
begin
  ptr := StrEndW(dst);
  len := ptr - dst;
  if len < maxlen then StrLCopyW(ptr, src, maxlen - len);
  Result := dst;
end;

function StrNewA(str: PChar): PChar;
var
  l: DWORD;
  p: Pointer;
begin
  Result := nil;
  if (str <> nil) and (str^ <> #0) then
  begin
    l := StrLenA(str) + 1;
    GetMem(p, l);
    if p <> nil then Result := StrMoveA(p, str, l);
  end;
end;

function StrNewW(str: PWChar): PWChar;
var
  l: DWORD;
  p: Pointer;
begin
  Result := nil;
  if (str <> nil) and (str^ <> #0) then
  begin
    l := 2 * (StrLenW(str) + 1);
    GetMem(p, l);
    if p <> nil then Result := StrMoveW(p, str, l);
  end;
end;

procedure StrDisposeA(str: PChar);
begin
  if str <> nil then FreeMem(str, StrLenA(str) + 1);
end;

procedure StrDisposeW(str: PWChar);
begin
  if str <> nil then FreeMem(str, 2 * (StrLenW(str) + 1));
end;

function Hex64;
begin
  Result := HexStr(n, 8);
end;

function Hex32;
begin
  Result := HexStr(n, 4);
end;

function Bin64;
begin
  Result := BinStr(n, 8);
end;

function Bin32;
begin
  Result := BinStr(n, 4);
end;

function Uns;
var
  s: array [1..12] of char;
  i: Longint;
begin
  for i := 12 downto 1 do
  begin
    s[i] := '0123456789'[(n mod 10) + 1];
    n := n div DWORD(10);
    if n = 0 then
    begin
      Result := Copy(s, i, 12);
      exit;
    end
  end;
  Result := '********';
end;

function Whl;
begin
  if n < 0 then
    whl := '-' + uns(-n)
  else
    whl := uns(n);
end;

function test_inf(var res: String; n: extended): Boolean;
var
  n16: record
    m1,m2: DWORD;
    exp:   Word
  end absolute n;
begin
  with n16 do if (exp and $7FFF) = $7FFF then
  begin
    if (m1 = 0) and (m2 = $80000000) then
      if exp = $FFFF then
        res := '-inf'
      else
        res := '+inf'
    else
        res := ' nan';
    Result := true;
  end else
    Result := false;
end;

function Flt;
var
  Res: String;
  n: Extended;
  pnt, exp, i: Longint;
begin
  res := ' ';
  n := x;
  if abs(w) <= 8 then
    pnt := 1
  else if abs(w) >= 26 then
    pnt := 18
  else pnt := abs(w) - 8;
  if test_inf(Result, n) then exit;
  if n < 0 then
  begin
    n := -n;
    res [1] := '-';
  end;
  exp := 0;
  if n > 0 then
  begin
    while n > 10 do
    begin
      n /:= 10;
      exp +:= 1;
    end;
    while n < 1 do
    begin
      n *:= 10;
      exp -:= 1;
    end;
    declare
    var d: Extended;
        i: Longint;
    begin
      if n >= 0 then
        d := +0.5
      else
        d := -0.5;
      for i := 1 to pnt do d /:= 10;
      n +:= d;
    end;
    if n > 10 then
    begin
      n /:= 10;
      exp +:= 1;
    end;
  end;
  Length(res) +:= 1; res [Length(res)] := chr(trunc(n) + ord('0'));
  Length(res) +:= 1; res [Length(res)] := '.';
  while pnt <> 0 do
  begin
    n := (n - trunc(n)) * 10;
    Length(res) +:= 1;
    res [Length (res)] := chr (trunc(n) + ord('0'));
    pnt -:= 1;
  end;
  Length(res) +:= 1; res [Length(res)] := 'E';
  Length(res) +:= 1; res [Length(res)] := '+';
  if exp < 0 then begin
    res [Length(res)] := '-';
    exp := -exp;
  end;
  Length(res) +:= 4;
  for i := 0 to 3 do begin
    res[Length(res) - i] := chr(ord('0') + exp mod 10);
    exp := exp div 10;
  end;
  flt := Align(res, w);
end;

function Fls(x: Extended): String;
var
  S: String;
  i, ExpN, C: Longint;
  Sign, IntS, ExpS: String;
  Flag: Boolean;
begin
  Str(x, S);
  if S[1] = '-' then
    Sign := '-'
  else
    Sign := '';
  IntS := '';
  ExpS := '';
  flag := false;
  for i := 2 to Length(S) do
    if S[i] <> '.' then
      if S[i] = 'E' then
        flag := true
      else
        if not flag then
          IntS := IntS + S[i]
        else
          ExpS := ExpS + S[i];
  i := Length(IntS);
  while (IntS[i] = '0') and (i > 1) do dec(i);
  IntS := Copy(IntS, 1, i);
  Val(ExpS, ExpN, C);
  if ExpN > 0 then begin
    if ExpN < Length(IntS) then begin
      Insert('.', IntS, ExpN + 2);
      Result := Sign + IntS;
    end else begin
      Result := Sign + IntS + Dup_CI('0', 1 + ExpN - Length(IntS)) + '.';
    end;
  end;
  if ExpN = 0 then begin
    Insert('.', IntS, 2);
    Result := Sign + IntS;
  end;
  if ExpN < 0 then begin
    Result := Sign + '0.' + Dup_CI('0', Abs(ExpN) - 1) + IntS;
  end;
end;

function Fix(x: extended; w, pr: Longint): String;
var
  res: String;
  exp, i: Longint;
  n, d: Extended;
begin
  if pr < 0 then
  begin
    Result := flt(x, w);
    exit
  end;
  if pr > 18 then pr := 18;
  if x >= 0 then
     d := +0.5
  else
     d := -0.5;
  for i := 1 to pr do d /:= 10;
  x +:= d;
  Length(res) := 0;
  n := x;
  if n < 0 then
  begin
    n := -n;
    Length(res) +:= 1;
    res[1] := '-';
  end;
  if test_inf(result, n) then exit;
  exp := 0;
  if n <> 0 then
  begin
    while n >= 10 do
    begin
      n /:= 10;
      exp +:= 1
    end;
    if exp > 35 then
    begin
      res := flt(x, w);
      exit
    end;
  end;
  repeat
    Length(res) +:= 1;
    res[Length(res)] := chr(ord('0') + trunc(n));
    n := (n - trunc(n)) * 10;
    exp -:= 1;
  until exp < 0;
  if pr > 0 then
  begin
    Length(res) +:= 1;
    res[Length (res)] := '.';
    repeat
      Length(res) +:= 1;
      res[Length(res)] := chr(ord ('0') + trunc(n));
      n := (n - trunc(n)) * 10;
      pr -:= 1;
    until pr = 0;
  end;
  fix := Align(res, w);
end;

function Align;
var
  res: String;
  len: Longint;
begin
  len := abs(w);
  if len > 255 then len := 255;
  if len <= Length(str) then
  begin
    Align := str;
    exit;
  end;
  Length (res) := len;
  fillchar (res[1], len, ord(' '));
  if w > 0 then
     Move(str[1], res[len - Length(str) + 1], Length(str))
  else
     Move(str[1], res[1], Length(str));
  Align := res;
end;

function HexVal(const S: String): Int64;
var
  i: Integer;
  c: Char;
begin
  Result := 0;
  for i := 1 to Length(s) do
  begin
    Result := Result shl 4;
    c := UpCase(s[i]);
    if c in ['0'..'9'] then
      Result := Result + ord(c) - ord('0')
    else if c in ['A'..'F'] then
      Result := Result + ord(c) - ord('A') + 10
    else break
  end
end;

function IntToStr(Value: Longint): String;
var
  Tmp: String;
begin
  Str(Value, Tmp);
  Result := Tmp;
end;

function StrToInt(const S: String): Longint;
var
  Tmp, ErrCode: Longint;
begin
  Val(S, Tmp, ErrCode);
  if ErrCode = 0 then
    Result := Tmp
  else
    Result := 0;
end;

function HexStr(var Num; ByteCount: DWORD): String; code;
asm
     mov   edi, [Result]
     mov   esi, [Num]
     mov   eax, [ByteCount]
     push  ecx
     mov   ecx, eax
     add   esi, eax
     dec   esi
     shl   eax, 1
     cld
     stosb
@L1: std
     lodsb
     push  eax
     shr   eax, 4
     add   eax, 90h
     daa
     adc   eax, 40h
     daa
     cld
     stosb
     pop   eax
     and   eax, 0Fh
     add   eax, 90h
     daa
     adc   eax, 40h
     daa
     stosb
     loop  @L1
     pop   ecx
     ret
end;

function IntToHex64;
begin
  Result := Copy(HexStr(Value, 8), 17 - Digits, Digits);
end;

function IntToHex32;
begin
  Result := Copy(HexStr(Value, 4), 9 - Digits, Digits);
end;

function BinStr(var Num; ByteCount: DWORD): String; code;
asm
     mov     edi, [Result]
     mov     esi, [Num]
     mov     eax, [ByteCount]
     push    ecx
     mov     ecx, eax
     add     esi, eax
     dec     esi
     shl     eax, 3
     cld
     stosb
     xor     eax, eax
@L1: std
     lodsb
     cld
     push    ecx
     mov     ecx, 7
@L2: push    eax
     shr     eax, ecx
     and     eax, 1
     add     eax, '0'
     stosb
     pop     eax
     loop    @L2
     and     eax, 1
     add     eax, '0'
     stosb
     pop     ecx
     loop    @L1
     pop     ecx
     ret
end;

function IntToBin64;
begin
  Result := Copy(BinStr(Value, 8), 1, Digits);
end;

function IntToBin32;
begin
  Result := Copy(BinStr(Value, 4), 1, Digits);
end;

function FloatToStr(Value: Extended): String;
begin
  Result := Fls(Value);
  if Result[Length(Result)] = '.' then
    Result := Copy(Result, 1, Length(Result) - 1);
end;

function TrimLeftS(const S: String): String;
var
  i: Longint := 1;
  Len: Longint := Length(S);
begin
  while (S[i] <= ' ') and (i <= Len) do i +:= 1;
  Result := Copy(S, i, Len - i + 1);
end;

function TrimRightS(const S: String): String;
var
  i: Longint := Length(S);
begin
  while (S[i] <= ' ') and (i > 0) do i -:= 1;
  Result := Copy(S, 1, i);
end;

function TrimS(const S: String): String;
var
  i: Longint := 1;
  Len: Longint := Length(S);
begin
  while (S[i] <= ' ') and (i <= Len) do i +:= 1;
  if i > Len then Result := '' else
  begin
    while S[Len] <= ' ' do Len -:= 1;
    Result := Copy(S, i, Len - i + 1);
  end;
end;

function TrimLeftC(const S: String; const C: Char): String;
var
  i: Longint := 1;
  Len: Longint := Length(S);
begin
  while (S[i] <= C) and (i <= Len) do i +:= 1;
  Result := Copy(S, i, Len - i + 1);
end;

function TrimRightC(const S: String; const C: Char): String;
var
  i: Longint := Length(S);
begin
  while (S[i] <= C) and (i > 0) do i -:= 1;
  Result := Copy(S, 1, i);
end;

function TrimC(const S: String; const C: Char): String;
var
  i: Longint := 1;
  Len: Longint := Length(S);
begin
  while (S[i] <= C) and (i <= Len) do i +:= 1;
  if i > Len then Result := '' else
  begin
    while S[Len] <= ' ' do Len -:= 1;
    Result := Copy(S, i, Len - i + 1);
  end;
end;

function QuotedStr(const S: String): String;
const
  QuoteSymbol: Char = '''';
var
  i: Longint;
  Temp: String := S;
begin
  for i := Length(Temp) downto 1 do
    if Temp[i] = QuoteSymbol then
      Insert(QuoteSymbol, Temp, i);
  Result := QuoteSymbol + Temp + QuoteSymbol;
end;

function IsValidIdent(const Ident: String): Boolean;
var
  i: Longint;
begin
  if (Length(Ident) = 0) or not (Ident[1] in ['_', 'A'..'Z', 'a'..'z']) then
  begin
    Result := FALSE;
    exit;
  end;
  for i := 2 to Length(Ident) do
    if not (Ident[i] in ['_', 'A'..'Z', 'a'..'z', '0'..'9']) then
    begin
      Result := FALSE;
      exit;
    end;
  Result := TRUE;
end;

function StrToIntDef(const S: String; Default: Longint): Longint;
var
  ErrCode: Longint;
  Temp: Longint;
begin
  Val(S, Temp, ErrCode);
  if ErrCode <> 0 then
    Result := Default
  else
    Result := Temp;
end;

function IsPathDelimiter(const S: String; IndexPos: Longint): Boolean;
begin
  Result := (IndexPos > 0) and (S[IndexPos] = '\') and (IndexPos <= Length(S));
end;

function IsDelimiter(const Delimiters, S: String; IndexPos: Longint): Boolean;
var
  Temp: array [0..255] of Char;
begin
  StrPCopy(Temp, Delimiters);
  if (IndexPos <= 0) or (IndexPos > Length(S)) then
    Result := FALSE
  else
    Result := StrScan(Temp, S[IndexPos]) <> nil;
end;

function LastDelimiter(const Delimiters, S: String): Longint;
var
  Temp: array [0..255] of Char;
begin
  Result := Length(S);
  StrPCopy(Temp, Delimiters);
  while Result > 0 do
  begin
    if StrScan(Temp, S[Result]) <> nil then exit;
    Result -:= 1;
  end;
end;

function AppendPathDelimiter(const S: String): String;
begin
  if (S = '') or (S[length(S)] in [':', '\']) then
    Result := S
  else
    Result := S + '\';
end;

function AnsiUpperCase(S: String): String;
begin
{$ifdef __WIN32__}
  CharUpperBuff(PChar(@S[1]), Length(S));
  Result := S;
{$else}
  Result := UpperCase(S);
{$endif}
end;

function AnsiLowerCase(S: String): String;
begin
{$ifdef __WIN32__}
  CharLowerBuff(PChar(@S[1]), Length(S));
  Result := S;
{$else}
  Result := LowerCase(S);
{$endif}
end;

function AnsiCompareStr(S1, S2: String): Longint;
var
  C1, C2: array[0..255] of Char;
begin
{$ifdef __WIN32__}
  Result := CompareString(LOCALE_USER_DEFAULT, 0, @S1[1], Length(S1), @S2[1], Length(S2)) - 2;
{$else}
  Result := StrComp(StrPCopy(C1, S1), StrPCopy(C2, S2));
{$endif}
end;

function AnsiCompareText(S1, S2: String): Longint;
var
  C1, C2: array[0..255] of Char;
begin
{$ifdef __WIN32__}
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, @S1[1], Length(S1), @S2[1], Length(S2)) - 2;
{$else}
  Result := StrComp(StrPCopy(C1, LowerCase(S1)), StrPCopy(C2, LowerCase(S2)));
{$endif}
end;

function AnsiStrCompA(S1, S2: PChar): Longint;
begin
{$ifdef __WIN32__}
  Result := CompareStringA(LOCALE_USER_DEFAULT, 0, S1, -1, S2, -1) - 2;
{$else}
  Result := StrCompA(S1, S2);
{$endif}
end;

function AnsiStrCompW(S1, S2: PWChar): Longint;
begin
{$ifdef __WIN32__}
  Result := CompareStringW(LOCALE_USER_DEFAULT, 0, S1, -1, S2, -1) - 2;
{$else}
  Result := StrCompW(S1, S2);
{$endif}
end;

function AnsiStrICompA(S1, S2: PChar): Longint;
begin
{$ifdef __WIN32__}
  Result := CompareStringA(LOCALE_USER_DEFAULT, NORM_IGNORECASE, S1, -1, S2, -1) - 2;
{$else}
  Result := StrICompA(StrLowerA(S1), StrLowerA(S2));
{$endif}
end;

function AnsiStrICompW(S1, S2: PWChar): Longint;
begin
{$ifdef __WIN32__}
  Result := CompareStringW(LOCALE_USER_DEFAULT, NORM_IGNORECASE, S1, -1, S2, -1) - 2;
{$else}
  Result := StrICompW(StrLowerW(S1), StrLowerW(S2));
{$endif}
end;

function AnsiStrLCompA(S1, S2: PChar; MaxLen: DWORD): Longint;
begin
{$ifdef __WIN32__}
  Result := CompareStringA(LOCALE_USER_DEFAULT, 0, S1, MaxLen, S2, MaxLen) - 2;
{$else}
  Result := StrLCompA(S1, S2, MaxLen);
{$endif}
end;

function AnsiStrLCompW(S1, S2: PWChar; MaxLen: DWORD): Longint;
begin
{$ifdef __WIN32__}
  Result := CompareStringW(LOCALE_USER_DEFAULT, 0, S1, MaxLen, S2, MaxLen) - 2;
{$else}
  Result := StrLCompW(S1, S2, MaxLen);
{$endif}
end;

function AnsiStrLICompA(S1, S2: PChar; MaxLen: DWORD): Longint;
begin
{$ifdef __WIN32__}
  Result := CompareStringA(LOCALE_USER_DEFAULT, NORM_IGNORECASE, S1, MaxLen, S2, MaxLen) - 2;
{$else}
  Result := StrLICompA(StrLowerA(S1), StrLowerA(S2), MaxLen);
{$endif}
end;

function AnsiStrLICompW(S1, S2: PWChar; MaxLen: DWORD): Longint;
begin
{$ifdef __WIN32__}
  Result := CompareStringW(LOCALE_USER_DEFAULT, NORM_IGNORECASE, S1, MaxLen, S2, MaxLen) - 2;
{$else}
  Result := StrLICompW(StrLowerW(S1), StrLowerW(S2), MaxLen);
{$endif}
end;

function AnsiStrLowerA(Str: PChar): PChar;
begin
{$ifdef __WIN32__}
  CharLowerA(Str);
  Result := Str;
{$else}
  Result := StrLowerA(Str);
{$endif}
end;

function AnsiStrLowerW(Str: PWChar): PWChar;
begin
{$ifdef __WIN32__}
  CharLowerW(Str);
  Result := Str;
{$else}
  Result := StrLowerW(Str);
{$endif}
end;

function AnsiStrUpperA(Str: PChar): PChar;
begin
{$ifdef __WIN32__}
  CharUpperA(Str);
  Result := Str;
{$else}
  Result := StrUpperA(Str);
{$endif}
end;

function AnsiStrUpperW(Str: PWChar): PWChar;
begin
{$ifdef __WIN32__}
  CharUpperW(Str);
  Result := Str;
{$else}
  Result := StrUpperW(Str);
{$endif}
end;

function CompareStr(S1, S2: String): Longint;
var
  C1, C2: array[0..255] of Char;
begin
  Result := StrComp(StrPCopy(C1, S1), StrPCopy(C2, S2));
end;

function CompareText(S1, S2: String): Longint;
var
  C1, C2: array[0..255] of Char;
begin
  Result := StrComp(StrPCopy(C1, LowerCase(S1)), StrPCopy(C2, LowerCase(S2)));
end;

end.