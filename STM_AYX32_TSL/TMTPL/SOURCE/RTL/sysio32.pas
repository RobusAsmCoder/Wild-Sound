(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Low Level IO Unit                                      *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

unit SysIO32;

interface

{$ifdef __OS2__}
uses OS2Types, DOSCall, ErrCodes;
{$endif}
{$ifdef __WIN32__}
uses Windows, Strings, ErrCodes;
{$endif}

{$ifdef __WIN32__}

const
  OPEN_RD = $0;
  OPEN_WR = $1;
  OPEN_RW = $2;

  SH_COMPAT   = $00;
  SH_DENYRW   = $10;
  SH_DENYWR   = $20;
  SH_DENYRD   = $30;
  SH_DENYNONE = $40;

type
  ApiRet = DWORD;

(* Event Emulation Variables *)
var
  thKeyboard: Boolean := FALSE;
  thMouse:    Boolean := FALSE;
  thKbCBuf:   array [0..15] of Char;
  thKbSBuf:   array [0..15] of Word;
  thKbPtr:    DWORD;
  thKbChar:   Char;
  thKbScan:   Word;
  thMouseX:   DWORD := 0;
  thMouseY:   DWORD := 0;
  thMouseL:   Boolean;
  thMouseM:   Boolean;
  thMouseR:   Boolean;
  thKeys:     array [0..$80] of Boolean;
  thCtrKey:   DWORD;
  thKbdFlag:  THandle;

procedure SysAddEvent(EventType: DWORD);
procedure SysRemoveEvent(EventType: DWORD);
procedure SysCloseEvent;
procedure SysEventMask(EventType: DWORD; Mask: DWORD; Proc: Pointer);

{$endif}

{$ifdef __DOS__}

const
  OPEN_RD = $0;
  OPEN_WR = $1;
  OPEN_RW = $2;

  SH_COMPAT   = $00;
  SH_DENYRW   = $10;
  SH_DENYWR   = $20;
  SH_DENYRD   = $30;
  SH_DENYNONE = $40;

(* DosSetFilePtr file position codes *)
  file_Begin    = $0000; { Move relative to beginning of = file }
  file_Current  = $0001; { Move relative to current fptr = position }
  file_End      = $0002; { Move relative to end of = file }

type
  ULong  = LongInt;
  ApiRet = Word;

type
  Regs = record
    case Integer of
       1:  (edi, esi, ebp, _res, ebx, edx, ecx, eax: longint;
            flags, es, ds, fs, gs, ip, cs, sp, ss: word);
       2: (_dmy2: array [0..15] of byte; bl, bh, b1, b2, dl, dh, d1, d2, cl, ch, c1, c2, al, ah: byte);
       3: (di, i1, si, i2, bp, i3, i4, i5, bx, b3, dx, d3, cx, c3, ax: word);
  end;

function  DosInt(no: longint; var r: regs; flags: longint): Boolean;
function  SysGetMem(Len: LongInt; var act: LongInt): Pointer;
procedure DosRelease;

{$endif}

function  SysCreate(FileName: PChar; access: ULong; var F: DWORD): ApiRet;
function  SysClose(F: DWORD): ApiRet;
function  SysRead(F: DWORD; Buffer: pointer; cbRead: ULong; var Actual: ULong): ApiRet;
function  SysWrite(F: DWORD; Buffer: pointer; cbWrite: ULong; var Actual: ULong): ApiRet;
procedure SysExit(rc: LongInt);
procedure SysType(const s: string);
function  SysOpen(FileName: PChar; access: ULong; var F: DWORD): ApiRet;
function  SysFileLength(F: DWORD): DWORD;
function  SysFilePos(F: DWORD): Longint;
function  SysSetFilePtr(F: DWORD; Pos: DWORD; Cmd: Byte; var act: LongInt): ApiRet;

implementation

{$ifdef __WIN32__}

function SysOpen;
const
  ShareMode = FILE_SHARE_READ or FILE_SHARE_WRITE;
var
  WinAccess: DWORD;
begin
  case (Access and 3) of
    0: WinAccess := GENERIC_READ;
    1: WinAccess := GENERIC_WRITE;
    2: WinAccess := GENERIC_READ or GENERIC_WRITE;
  end;
  F := CreateFile(FileName, WinAccess, ShareMode, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if F = INVALID_HANDLE_VALUE then
    Result := GetLastError
  else
    Result := NO_ERROR;
end;

function SysCreate;
const
  ShareMode = FILE_SHARE_READ or FILE_SHARE_WRITE;
var
  WinAccess: DWORD;
begin
  case (Access and 3) of
    0: WinAccess := GENERIC_READ;
    1: WinAccess := GENERIC_WRITE;
    2: WinAccess := GENERIC_READ or GENERIC_WRITE;
  end;
  F := CreateFile(FileName, WinAccess, ShareMode, nil, OPEN_EXISTING and CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if F = INVALID_HANDLE_VALUE then
    Result := GetLastError
  else
    Result := NO_ERROR;
end;

function SysClose;
begin
  if CloseHandle(F)
  then
    Result := NO_ERROR
  else
    Result := GetLastError;
end;

var
  thID       : DWORD := 0;
  cNumRead, i: DWORD;
  cNumWrite  : DWORD;
  thHandle   : DWORD := 0;
  thCounter  : DWORD;
  thEventType: DWORD;
  thStdin    : DWORD;
  irInBuf    : TInputRecord;
  thOMouseX  : DWORD;
  thOMouseY  : DWORD;
  thOMouseL  : Boolean;
  thOMouseM  : Boolean;
  thOMouseR  : Boolean;
  thMouseMask: DWORD;
  thKbdMask  : DWORD;
  thKbdHnd   : procedure(Chr: Char; Scan: DWORD);
  thMouseHnd : procedure(Mask, Buttons, X, Y, MovX, MovY: System.Word);

function SysRead;
begin
  if ReadFile(F, Buffer^, cbRead, DWORD(Actual), nil)
  then
    Result := NO_ERROR
  else
    Result := GetLastError;
end;

function SysWrite;
begin
  SetLastError(NO_ERROR);
  if WriteFile(F, Buffer^, cbWrite, DWORD(Actual), nil)
  then
    Result := NO_ERROR
  else
    Result := GetLastError;
end;

function SysFileLength;
var
  res: LongInt;
begin
  res := GetFileSize (f, nil);
  if res = -1 then
  begin
    Result := 0;
    InOutRes := GetLastError;
  end else
  begin
    Result := res;
    InOutRes := NO_ERROR;
  end;
end;

function SysFilePos;
var
  res: LongInt;
begin
  res := SetFilePointer(F, 0, nil, FILE_CURRENT);
  if res = -1 then
  begin
    Result := 0;
    InOutRes := GetLastError;
  end else
  begin
    Result := res;
    InOutRes := NO_ERROR;
  end;
end;

function SysSetFilePtr;
var
  res: LongInt;
begin
  res := SetFilePointer(F, Pos, nil, Cmd);
  if res = -1 then
  begin
    Result := DISK_SEEK_ERROR;
    act := 0;
  end else
  begin
    Result := NO_ERROR;
    act := res;
  end;
end;

procedure SysExit;
begin
  ExitProcess(rc);
end;

procedure SysType;
begin
  Writeln(S);
end;

procedure ThreadFunc;
var
  Temp: DWORD;
begin
  repeat
    if thID > 0 then
    begin
      WaitForSingleObject(thStdin, INFINITE);
      if ReadConsoleInput(thStdin, irInBuf, 1, cNumRead) then
       begin
         thEventType := irInBuf.EventType;
         if (thEventType = KEY_EVENT) and (thKeyboard) then
         begin
           thCtrKey := irInBuf.KeyEvent.dwControlKeyState;
           thKbChar := irInBuf.KeyEvent.AsciiChar;
           thKbScan := irInBuf.KeyEvent.wVirtualScanCode;
           if not irInBuf.KeyEvent.bKeyDown then
             thKeys[thKbScan] := FALSE
           else
           begin
             thKeys[thKbScan] := TRUE;
             if (thKbScan <> 42) and (thKbPtr < 14) then
             begin
               if not (thKbScan in [$1D, $36, $38, $3A, $45, $46]) then
               begin
                 if ((thKbScan in
                   { Up, Dn, Left Rt Ins Del Home End PgUp PgDn C-Home C-End C-PgUp C-PgDn C-Left C-Right C-Up C-Dn F1..F10 }
                   [$48,$50, $4B,$4D,$52,$53,$47, $4F,$49, $51,   $77,   $75,  $84,   $76,   $73,   $74,  $8D, $91,$3B..$44])
                   and (thKbChar in [#0, #224]))
                   or ((thCtrKey and LEFT_ALT_PRESSED) = LEFT_ALT_PRESSED)
                   or ((thCtrKey and RIGHT_ALT_PRESSED) = RIGHT_ALT_PRESSED)
                 then
                 begin
                   if (thKbScan in [$3B..$44]) and ((thCtrKey and (LEFT_ALT_PRESSED or RIGHT_ALT_PRESSED)) > 0) then
                     inc(thKbScan, 45);

                     Move(thKbCBuf[0], thKbCBuf[1], 15);
                     Move(thKbSBuf[0], thKbSBuf[1], 30);
                     inc(thKbPtr);
                     thKbCBuf[0] := #0;
                     thKbSBuf[0] := 0;

                     Move(thKbCBuf[0], thKbCBuf[1], 15);
                     Move(thKbSBuf[0], thKbSBuf[1], 30);
                     inc(thKbPtr);
                     thKbCBuf[0] := Char(thKbScan);
                     thKbSBuf[0] := thKbScan;
                   end else
                   begin
                     Move(thKbCBuf[0], thKbCBuf[1], 15);
                     Move(thKbSBuf[0], thKbSBuf[1], 30);
                     inc(thKbPtr);
                     thKbCBuf[0] := thKbChar;
                     thKbSBuf[0] := thKbScan;
                   end;
                   ReleaseSemaphore(thKbdFlag, 1, nil);
                 end else
                   thKbScan := 0;
               end;
             end;
           end;
         if (thEventType = _MOUSE_EVENT) and (thMouse) then
         begin
           thOMouseX := thMouseX;
           thOMouseY := thMouseY;
           thOMouseL := thMouseL;
           thOMouseM := thMouseM;
           thOMouseR := thMouseR;
           thMouseX  := irInBuf.MouseEvent.dwMousePosition.X shl 3;
           thMouseY  := irInBuf.MouseEvent.dwMousePosition.Y shl 3;
           thMouseL  := (irInBuf.MouseEvent.dwButtonState and FROM_LEFT_1ST_BUTTON_PRESSED) <> 0;
           thMouseM  := (irInBuf.MouseEvent.dwButtonState and FROM_LEFT_2ND_BUTTON_PRESSED) <> 0;
           thMouseR  := (irInBuf.MouseEvent.dwButtonState and RIGHTMOST_BUTTON_PRESSED) <> 0;
           if thMouseMask <> 0 then
           begin
             Temp := (irInBuf.MouseEvent.dwButtonState and FROM_LEFT_1ST_BUTTON_PRESSED) +
                     ((irInBuf.MouseEvent.dwButtonState and RIGHTMOST_BUTTON_PRESSED) shl 1) +
                     ((irInBuf.MouseEvent.dwButtonState and FROM_LEFT_2ND_BUTTON_PRESSED) shl 2);
             if (irInBuf.MouseEvent.dwEventFlags = MOUSE_MOVED) and ((thMouseMask and 1) <> 0)
             then
               thMouseHnd(1, Temp, thMouseX, thMouseY, thMouseX - thOMouseX, thMouseY - thOMouseY);
             if (not (thOMouseL) and thMouseL) and ((thMouseMask and 2) <> 0)
             then
               thMouseHnd(2, Temp, thMouseX, thMouseY, thMouseX - thOMouseX, thMouseY - thOMouseY);
             if (not (thMouseL) and thOMouseL) and ((thMouseMask and 4) <> 0)
             then
               thMouseHnd(4, Temp, thMouseX, thMouseY, thMouseX - thOMouseX, thMouseY - thOMouseY);
             if (not (thOMouseR) and thMouseR) and ((thMouseMask and 8) <> 0)
             then
               thMouseHnd(8, Temp, thMouseX, thMouseY, thMouseX - thOMouseX, thMouseY - thOMouseY);
             if (not (thMouseR) and thOMouseR) and ((thMouseMask and 16) <> 0)
             then
               thMouseHnd(16, Temp, thMouseX, thMouseY, thMouseX - thOMouseX, thMouseY - thOMouseY);
             if (not (thOMouseM) and thMouseM) and ((thMouseMask and 32) <> 0)
             then
               thMouseHnd(32, Temp, thMouseX, thMouseY, thMouseX - thOMouseX, thMouseY - thOMouseY);
             if (not (thMouseM) and thOMouseM) and ((thMouseMask and 64) <> 0)
             then
               thMouseHnd(64, Temp, thMouseX, thMouseY, thMouseX - thOMouseX, thMouseY - thOMouseY);
           end;
         end;
      end;
    end;
  until FALSE;
end;

procedure SysAddEvent(EventType: DWORD);
begin
  case EventType of
    _MOUSE_EVENT: begin
                    thMouseMask := 0;
                    thMouse     := TRUE;
                    thMouseL    := FALSE;
                    thMouseM    := FALSE;
                    thMouseR    := FALSE;
                  end;
    KEY_EVENT   : begin
                    thKbdMask  := 0;
                    thKeyboard := TRUE;
                    thKbPtr    := 0;
                  end;
  end;
  if thID > 0 then exit;
  thHandle := CreateThread(nil, 0, @ThreadFunc, nil, 0, thID);
  //SetThreadPriority(thHandle, THREAD_PRIORITY_BELOW_NORMAL);
  thStdin := GetStdHandle(STD_INPUT_HANDLE);
end;

procedure SysCloseEvent;
var
  thExitCode: DWORD;
begin
  GetExitCodeThread(thHandle, thExitCode);
  TerminateThread(thHandle, thExitCode);
  thHandle := 0;
  thID     := 0;
end;

procedure SysRemoveEvent(EventType: DWORD);
begin
  case EventType of
    _MOUSE_EVENT: thMouse    := FALSE;
    KEY_EVENT   : begin
                     thKeyboard := FALSE;
                     CloseHandle(thKbdFlag);
                   end;
  end;
  if (thID > 0) and not (thMouse or thKeyboard) then SysCloseEvent;
end;

procedure SysEventMask(EventType: DWORD; Mask: DWORD; Proc: Pointer);
begin
 case EventType of
   _MOUSE_EVENT: begin
                   thMouseMask := Mask;
                   @thMouseHnd := Proc;
                 end;
   KEY_EVENT   : begin
                   thKeyboard := FALSE;
                   @thKbdHnd  := Proc;
                   thKbdFlag := CreateSemaphore(nil, 0, 256, 'KbdSemaphore');
                 end;
  end;
end;
{$endif}

{$ifdef __DOS__}

function SysOpen; assembler;
asm
    mov     eax, Access
    mov     edx, FileName
    mov     ah, 3Dh
    int     21h
    movzx   eax, ax
    mov     edx, F
    mov     [edx], eax
    sbb     edx, edx
    and     eax, edx
end;

function SysCreate; assembler;
asm
    mov     ecx, Access
    mov     edx, FileName
    mov     ah, 3Ch
    int     21h
    movzx   eax, ax
    mov     edx, F
    mov     [edx], eax
    sbb     edx, edx
    and     eax, edx
end;

function SysClose; assembler;
asm
    mov     ebx, F
    mov     ah, 3Eh
    int     21h
    movzx   eax, ax
    sbb     edx, edx
    and     eax, edx
end;

function SysRead; assembler;
asm
    mov     ebx, F
    mov     ecx, cbRead
    mov     edx, Buffer
    mov     ah, 3Fh
    int     21h
    mov     edx, Actual
    mov     [edx], eax
    sbb     edx, edx
    and     eax, edx
end;

function SysWrite; assembler;
asm
    mov     ebx, F
    mov     ecx, cbWrite
    mov     edx, Buffer
    mov     ah, 40h
    int     21h
    mov     edx, Actual
    mov     [edx], eax
    sbb     edx, edx
    and     eax, edx
end;

function SysFileLength;
var
  R: Regs;
  H, L: Word;
begin
  FillChar(R, SizeOf(R), 0);
  R.EBX := F;
  R.AX := $4201;
  R.DX := $0000;
  R.CX := $0000;
  DOSInt($21, R, 0);
  H := R.DX;
  L := R.AX;

  R.EBX := F;
  R.AX := $4202;
  R.DX := $0000;
  R.CX := 0;
  DOSInt($21, R, 0);
  Result := (DWORD(R.DX) shl 16) + R.AX;

  R.EBX := F;
  R.AX := $4200;
  R.DX := L;
  R.CX := H;
  DOSInt($21, R, 0);
end;

function SysFilePos;
var
  R: Regs;
begin
  FillChar(R, SizeOf(R), 0);
  R.EBX := F;
  R.AX := $4201;
  R.CX := $0000;
  R.DX := $0000;
  DOSInt($21, R, 0);
  if (R.Flags and 1) = 1 then
    Result := -1
  else
    Result := (R.EDX shl 16) + (R.EAX and $FFFF);
end;

function SysSetFilePtr;
var
  R: Regs;
begin
  FillChar(R,SizeOf(R),0);
  R.EBX := F;
  R.EAX := Cmd;
  R.AH  := $42;
  R.ECX := Pos shr 16;
  R.EDX := Pos and $FFFF;
  DOSInt($21, R, 0);
  act := (R.EDX shl 16) + (R.EAX and $FFFF);
  Result := R.FLAGS and 1;
end;

function  SysGetMem; assembler;
asm
    mov   ax, 0EE42h
    mov   edx, [Len]
    int   31h
    mov   ecx, [Act]
    mov   [ecx], eax
    mov   eax, edx
end;

procedure DosRelease; assembler;
asm
    mov   ax, 0EE40h
    int   31h
end;

function  DosInt; assembler;
asm
    mov     edi, [r]
    mov     ebx, [no]
    mov     bh,  byte [flags]
    xor     ecx, ecx
    mov     eax, 0300h
    int     31h
    sbb     eax, eax
    neg     eax
end;

procedure SysExit; code;
asm
    pop     eax
    pop     eax
    mov     ah, 4Ch
    int     21h
end;

procedure SysType; assembler;
asm
    mov     edx, s
    inc     edx
    mov     ah, 09h
    int     21h
end;

{$endif}

{$ifdef __OS2__}
function SysSetFilePtr; external 'DOSCALLS' index 256;
function SysClose; external 'DOSCALLS' index 257;
function SysRead; external 'DOSCALLS' index 281;
function SysWrite; external 'DOSCALLS' index 282;

function SysOpen;
var
  action: ULong;
begin
  Result := DosOpen(FileName, F, action, 0, FILE_NORMAL, FILE_OPEN, access, nil);
end;

function SysCreate;
var
  action: ULong;
begin
  Result := DosOpen(FileName, F, action, 0, FILE_NORMAL, FILE_TRUNCATE + FILE_CREATE,
    access, nil);
end;

procedure SysExit;
begin
  DosExit(1, rc);
end;

procedure SysType;
begin
  Writeln(S);
end;

function SysFileLength(F: DWORD): DWORD;
var
  info: FileStatus;
begin
  if dosqueryfileinfo(F, FIL_STANDARD, @info, SizeOf(info)) <> 0 then
  begin
    InOutRes := DISK_SEEK_ERROR;
    Result := 0;
  end else
  begin
    InOutRes := 0;
    Result := info.cbfile;
  end;
end;

function SysFilePos;
var
  act: ULong;
begin
  if DosSetFileptr(F, 0, FILE_CURRENT, act) <> 0 then
  begin
    InOutRes := DISK_SEEK_ERROR;
    Result := 0;
  end else
  begin
    InOutRes := 0;
    Result := act;
  end;
end;
{$endif}

end.