(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Advanced Keyboard Unit                                 *)
(*       Targets: MS-DOS, Win32 Console                         *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit Keyboard;

interface

const
  ESC_Scan  = $01;  Ent_Scan   = $1c;
  Back_Scan = $0e;  Rsh_Scan   = $36;
  Ctrl_Scan = $1d;  Prt_Scan   = $37;
  Lsh_Scan  = $2a;  Alt_Scan   = $38;
  Caps_Scan = $3a;  Home_Scan  = $47;
  F1_Scan   = $3b;  Up_Scan    = $48;
  F2_Scan   = $3c;  PgUp_Scan  = $49;
  F3_Scan   = $3d;  Min_Scan   = $4a;
  F4_Scan   = $3e;  Left_Scan  = $4b;
  F5_Scan   = $3f;  Mid_Scan   = $4c;
  F6_Scan   = $40;  Right_Scan = $4d;
  F7_Scan   = $41;  Plus_Scan  = $4e;
  F8_Scan   = $42;  End_Scan   = $4f;
  F9_Scan   = $43;  Down_Scan  = $50;
  F10_Scan  = $44;  PgDn_Scan  = $51;
  F11_Scan  = $d9;  Ins_Scan   = $52;
  F12_Scan  = $da;  Del_Scan   = $53;
  Scrl_Scan = $46;  Num_Scan   = $45;
  Tab_Scan  = $0f;  Space_Scan = $39;

function  KbHit: Boolean;
function  ScanToAscii(ScanCode: Byte): Char;
function  AsciiToScan(AsciiChar: Char): Byte;
procedure FlushKeyboard;
function  GetKey: Word;
procedure ReadKeyScan(var Key: Char; var ScanCode: Byte);
function  TestCapsLock: Boolean;
function  TestNumLock: Boolean;
function  TestScrollLock: Boolean;
function  TestShift: Boolean;
function  TestCtrl: Boolean;
function  TestAlt: Boolean;
procedure MultiKeysInit;
procedure MultiKeysDone;
function  TestKey(Scan: Byte): Boolean;

implementation

{$ifdef __DOS__}
uses DOS;
const
  key_flg: Boolean = FALSE;
var
  Keys: Array [0..$80] of Boolean;
  OldInt09: FarPointer;
{$endif}
{$ifdef __WIN32__}
uses Messages, Windows, SysIO32;
var
  Keys: Array [0..$80] of Boolean absolute thKeys;
  MultiKeysMode: Boolean := FALSE;
{$endif}

const
  SCAN_TABLE: array [0..139] of Byte =
  (byte('1'), $02, byte('!'), $02, byte('2'), $03, byte('@'), $03,
   byte('3'), $04, byte('#'), $04, byte('4'), $05, byte('$'), $05,
   byte('5'), $06, byte('%'), $06, byte('6'), $07, byte('^'), $07,
   byte('7'), $08, byte('&'), $08, byte('8'), $09, byte('*'), $09,
   byte('9'), $0A, byte('('), $0A, byte('0'), $0B, byte(')'), $0B,
   byte('-'), $0C, byte('_'), $0C, byte('='), $0C, byte('+'), $0C,
   byte('A'), $1E, byte('S'), $1F, byte('D'), $20, byte('F'), $21,
   byte('G'), $22, byte('H'), $23, byte('J'), $24, byte('K'), $25,
   byte('L'), $26, byte(':'), $27, byte(';'), $27, byte(#39), $28,
   byte('"'), $28, byte('`'), $29, byte('~'), $29, byte(' '), $39,
   byte('Q'), $10, byte('W'), $11, byte('E'), $12, byte('R'), $13,
   byte('T'), $14, byte('Y'), $15, byte('U'), $16, byte('I'), $17,
   byte('O'), $18, byte('P'), $19, byte('['), $1A, byte('{'), $1A,
   byte(']'), $1B, byte('}'), $1B, byte('\'), $2B, byte('|'), $2B,
   byte('Z'), $2C, byte('X'), $2D, byte('C'), $2E, byte('V'), $2F,
   byte('B'), $30, byte('N'), $31, byte('M'), $32, byte(','), $33,
   byte('<'), $33, byte('.'), $34, byte('>'), $34, byte('/'), $35,
   byte('?'), $35, 0, 0);

{$ifdef __WIN32__}
const
  VK_CODES: array [0..75] of Byte =
  (
    ESC_Scan,   VK_ESCAPE,   Ent_Scan,   VK_RETURN,
    Back_Scan,  VK_BACK,     Rsh_Scan,   VK_SHIFT,
    Ctrl_Scan,  VK_CONTROL,  Space_Scan, 32,
    Prt_Scan,   VK_PRINT,    Lsh_Scan,   VK_SHIFT,
    Alt_Scan,   VK_MENU,     Caps_Scan,  VK_CAPITAL,
    Home_Scan,  VK_HOME,     F1_Scan,    VK_F1,
    F2_Scan,    VK_F2,       F3_Scan,    VK_F3,
    F4_Scan,    VK_F4,       F5_Scan,    VK_F5,
    F6_Scan,    VK_F6,       F7_Scan,    VK_F7,
    F8_Scan,    VK_F8,       F9_Scan,    VK_F9,
    F10_Scan,   VK_F10,      F11_Scan,   VK_F11,
    F12_Scan,   VK_F12,      Scrl_Scan,  VK_SCROLL,
    Tab_Scan,   VK_TAB,      Up_Scan,    VK_UP,
    PgUp_Scan,  VK_PRIOR,    Min_Scan,   VK_SUBTRACT,
    Left_Scan,  VK_LEFT,     Mid_Scan,   VK_NUMPAD5,
    Right_Scan, VK_RIGHT,    Plus_Scan,  VK_ADD,
    End_Scan,   VK_END,      Down_Scan,  VK_DOWN,
    PgDn_Scan,  VK_NEXT,     Ins_Scan,   VK_INSERT,
    Del_Scan,   VK_DELETE,   Num_Scan,   VK_NUMLOCK
  );
{$endif}

{$ifdef __DOS__}
function KbHit: Boolean; code;
      asm
        cmp     key_flg, 0
        jne     @@ret1
        mov     ah, 01h
        int     16H
        jnz     @@ret1
        xor     al, al
        jmp     @@ret
@@ret1:
        mov     al, 1
@@ret:
        ret
end;
{$endif}
{$ifdef __WIN32__}
{$system}
function KbHit: Boolean;
begin
  if not %InGraph then
    Result := thKbPtr > 0
  else begin
    declare
    var
      M: TMsg;
    begin
      while PeekMessage(M, 0, 0, 0, pm_Remove) do
      begin
        if M.Message = wm_Quit then Halt(255);
        TranslateMessage(M);
        DispatchMessage(M);
      end;
      KbHit := %KeyNumber > 0;
    end;
  end;
end;

function GrReadKey: Char;
begin
  if not KbHit then
  begin
    repeat WaitMessage until KbHit;
  end;
  GrReadKey := %KeyBuffer[0];
  %KeyNumber -:= 1;
  Move(%KeyBuffer[1], %KeyBuffer[0], %KeyNumber);
end;
{$endif}

function ScanToAscii(ScanCode: Byte): Char;
var
  i: DWORD;
begin
  i := 1;
  while (SCAN_TABLE[i] <> ScanCode) and (SCAN_TABLE[i] <> 0) do i +:= 2;
  Result := Char(SCAN_TABLE[i - 1]);
end;

function AsciiToScan(AsciiChar: Char): Byte;
var
  i: DWORD := 0;
  c: Byte;
begin
  c := Byte(UpCase(AsciiChar));
  while (SCAN_TABLE[i] <> c) and (SCAN_TABLE[i] <> 0) do i +:= 2;
  Result := SCAN_TABLE[i + 1];
end;

{$system}
procedure FlushKeyboard;
{$ifdef __DOS__}
code;
     asm
        mov     edi, 041Ch
        mov     ax, [edi]
        mov     [edi-2], ax
        ret
end;
{$endif}
{$ifdef __WIN32__}
begin
  if %inGraph then
    %KeyNumber := 0
  else
    FlushConsoleInputBuffer(TTextRec(input).handle);
end;
{$endif}

function GetKey: Word;
{$ifdef __DOS__}
code;
     asm
        mov     eax, 10h
        int     16h
        cmp     al, 0E0h
        jne     @@Exit
        xor     eax, eax
@@Exit:
        ret
end;
{$endif}
{$ifdef __WIN32__}
var
  ch: Char;
begin
  if %inGraph then
  begin
    ch := GrReadKey;
    if ch <> #0 then
      Result := DWord(ch) + AsciiToScan(ch) shl 8
    else
    begin
      ch := GrReadKey;
      Result := DWord(ScanToAscii(Byte(ch))) + DWORD(ch) shl 8;
    end;
  end else
  begin
    repeat
      if thKbPtr = 0 then WaitForSingleObject(thKbdFlag, INFINITE);
    until thKbPtr > 0;
    Dec(thKbPtr);
    if thKbSBuf[thKbPtr] = 0 then
    begin
      Dec(thKbPtr);
      Result := thKbSBuf[thKbPtr] shl 8;
    end else
      Result := DWord(thKbCBuf[thKbPtr]) + DWord(thKbSBuf[thKbPtr]) shl 8;
  end;
end;
{$endif}

procedure ReadKeyScan(var Key: Char; var ScanCode: Byte);
{$ifdef __DOS__}
code;
     asm
        mov     ah, 10h
        int     16h
        mov     edi, [Key]
        mov     [edi], al
        in      al, 60h
        mov     edi, [ScanCode]
        mov     [edi], al
        ret
end;
{$endif}
{$ifdef __WIN32__}
var
  ch: Char;
begin
  if %inGraph then
  begin
    ch := GrReadKey;
    if ch <> #0 then
    begin
      Key := ch;
      ScanCode := AsciiToScan(ch);
    end else
    begin
      ch := GrReadKey;
      Key := ScanToAscii(Byte(ch));
      ScanCode := Byte(ch);
    end;
  end else
  begin
    repeat
      repeat
        WaitForSingleObject(TTextRec(input).handle, INFINITE);
      until thKbPtr > 0;
      Dec(thKbPtr);
    until thKbSBuf[thKbPtr] <> 0;
    Key := thKbCBuf[thKbPtr];
    ScanCode := thKbSBuf[thKbPtr];
  end;
end;
{$endif}

function TestCapsLock: Boolean;
{$ifdef __DOS__}
code;
     asm
        mov     edi, 0417h
        xor     eax, eax
        mov     ah, [edi]
        and     ah, 40h
        jz      @@Cont
        inc     eax
@@Cont:
        ret
end;
{$endif}
{$ifdef __WIN32__}
begin
  if %inGraph then
    Result := (GetKeyState(VK_CAPITAL) and 1) = 1
  else
    Result := (thCtrKey and CAPSLOCK_ON) > 0;
end;
{$endif}

function TestNumLock: Boolean;
{$ifdef __DOS__}
code;
     asm
        mov     edi, 0417h
        xor     eax, eax
        mov     ah, [edi]
        and     ah, 20h
        jz      @@Cont
        inc     eax
@@Cont:
        ret
end;
{$endif}
{$ifdef __WIN32__}
begin
  if %inGraph then
    Result := (GetKeyState(VK_NUMLOCK) and 1) = 1
  else
    Result := (thCtrKey and NUMLOCK_ON) > 0;
end;
{$endif}

function TestScrollLock: Boolean;
{$ifdef __DOS__}
code;
     asm
        mov     edi, 0417h
        xor     eax, eax
        mov     ah, [edi]
        and     ah, 10h
        jz      @@Cont
        inc     eax
@@Cont:
        ret
end;
{$endif}
{$ifdef __WIN32__}
begin
 if %inGraph then
    Result := (GetKeyState(VK_SCROLL) and 1) = 1
  else
    Result := (thCtrKey and SCROLLLOCK_ON) > 0;
end;
{$endif}

function TestShift: Boolean;
{$ifdef __DOS__}
code;
     asm
        mov     edi, 0417h
        xor     eax, eax
        mov     ah, [edi]
        and     ah, 03h
        jz      @@Cont
        inc     eax
@@Cont:
        ret
end;
{$endif}
{$ifdef __WIN32__}
begin
  if %inGraph then
    Result := (GetAsyncKeyState(VK_SHIFT) and 1) = 1
  else
    Result := (thCtrKey and SHIFT_PRESSED) > 0;
end;
{$endif}

function TestCtrl: Boolean;
{$ifdef __DOS__}
code;
     asm
        mov     edi, 0417h
        xor     eax, eax
        mov     ah, [edi]
        and     ah, 04h
        jz      @@Cont
        inc     eax
@@Cont:
        ret
end;
{$endif}
{$ifdef __WIN32__}
begin
 if %inGraph then
    Result := (GetAsyncKeyState(VK_CONTROL) and 1) = 1
  else
    Result := (thCtrKey and (LEFT_CTRL_PRESSED or RIGHT_CTRL_PRESSED)) > 0;
end;
{$endif}

function TestAlt: Boolean;
{$ifdef __DOS__}
code;
      asm
        mov     edi, 0417h
        xor     eax, eax
        mov     ah, [edi]
        and     ah, 08h
        jz      @@Cont
        inc     eax
@@Cont:
        ret
end;
{$endif}
{$ifdef __WIN32__}
begin
  if %inGraph then
    Result := (GetAsyncKeyState(VK_MENU) and 1) = 1
  else
    Result := (thCtrKey and (LEFT_ALT_PRESSED or RIGHT_ALT_PRESSED)) > 0;
end;
{$endif}

{$ifdef __DOS__}
procedure MultiKeys(eax, ebx: dword); interrupt;
begin
      asm
        xor     eax, eax
        in      al, 60h
        mov     ebx, eax
        and     al, 80h
        jz      @kDown
        and     bl, 7Fh
        mov     byte ptr Keys[ebx], 0
        jmp     @Quit
@kDown:
        mov     byte ptr Keys[ebx], 1
@Quit:
        in      al, 61h
        mov     ah, al
        or      al, 80h
        out     61h, al
        xchg    ah, al
        out     61h, al
        mov     al, 20h
        out     20h, al
     end;
end;
{$endif}

procedure MultiKeysInit;
begin
{$ifdef __DOS__}
  FillChar(Keys, $81, 0);
  GetIntVec($09, OldInt09);
  SetIntVec($09, @MultiKeys);
{$endif}
{$ifdef __WIN32__}
  MultiKeysMode := TRUE;
{$endif}
end;

procedure MultiKeysDone;
begin
{$ifdef __DOS__}
  SetIntVec($09, OldInt09);
{$endif}
{$ifdef __WIN32__}
  MultiKeysMode := FALSE;
{$endif}
end;

{$system}
function TestKey(Scan: Byte): Boolean;
begin
{$ifdef __WIN32__}
  if not MultiKeysMode then exit;
  if not %inGraph then
    Result := Keys[Scan]
  else
    declare
    var
      i: DWORD;
    begin
      KbHit;
      for i := 0 to High(VK_CODES) div 2 - 1 do
        if VK_CODES[i*2] = Scan then
        begin
          Result := (GetKeyState(VK_CODES[i*2 + 1]) and $8000) = $8000;
          exit;
        end;
      Result := (GetKeyState(Byte(ScanToAscii(Scan))) and $8000) = $8000;
    end;
{$endif}
{$ifdef __DOS__}
  Result := Keys[Scan];
{$endif}
end;

begin
{$ifdef __WIN32__}
  if isConsole then SysAddEvent(KEY_EVENT);
{$endif}
end.