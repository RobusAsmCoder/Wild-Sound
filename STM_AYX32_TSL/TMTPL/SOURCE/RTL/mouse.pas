(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Console Mouse Interface Unit                           *)
(*       Targets: MS-DOS, OS/2 Console, Win32 Console, GUI      *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Authors: Anton Moscal, Vadim Bodrov                    *)
(*                                                              *)
(****************************************************************)

unit Mouse;

interface

const
 LeftBtnMask   = 1;
 RightBtnMask  = 2;
 MiddleBtnMask = 4;

function  MousePresent: Boolean;
procedure InitMouse;
function  GetButtonCount: DWord;
procedure ShowMouse;
procedure HideMouse;
procedure SetMousePos(X, Y: DWord);
procedure GetMouseInfo(var ButtonMask: Word; var X: Word; var Y: Word);
function  GetMouseX: DWord;
function  GetMouseY: DWord;
function  LeftButtonPressed: Boolean;
function  MiddleButtonPressed: Boolean;
function  RightButtonPressed: Boolean;
procedure SetMouseHandler(Mask: DWord; procedure Hnd(Mask, Buttons, X, Y, MovX, MovY: System.Word));
procedure ClearMouseHandler;
procedure DoneMouse;
procedure SetMouseRange(MinX, MinY, MaxX, MaxY: DWord);
function  MickyToText(Coord: DWord): DWord;
function  TextToMicky(Coord: DWord): DWord;

implementation

{$ifdef __DOS__}
uses DPMI, Dos, Crt;
{$endif}
{$ifdef __WIN32__}
uses Windows, Messages, SysIO32;
{$endif}
{$ifdef __OS2__}
uses Os2Types, DosCall;
{$endif}

var
  ButtonCount: DWord;
  Initialized: Boolean;
{$ifdef __DOS__}
  save_ss:   DWord;
  save_sp:   DWord;
  Stack:     Pointer;
  MouseHnd:  procedure(Mask, Buttons, X, Y, MovX, MovY: System.Word);
  Hnd:       record
               Entry, Base: Longint
             end absolute MouseHnd;
  hnd_es :   Word;
  hnd_edx:   DWord;
  new_stack: Pointer;
  RealRegs:  ^Registers;

{$endif}
{$ifdef __OS2__}
  hMou:        System.Word;
  ProtectArea: NoPtrRect;
{$endif}

{$system}

function GetButtonCount: DWord;
code;
      asm
        mov     eax,[ButtonCount]
        ret
end;

procedure ShowMouse;
{$ifdef __DOS__}
assembler;
asm
        cmp     [ButtonCount], 0
        je      @@1
        push    eax
        mov     eax, 1
        int     33h
        pop     eax
@@1:
end;
{$endif}
{$ifdef __WIN32__}
begin
{$system}
  if %inGraph then ShowCursor(TRUE);
end;
{$endif}
{$ifdef __OS2__}
begin
  Mou16DrawPtr(hMou);
end;
{$endif}

procedure HideMouse;
{$ifdef __DOS__}
assembler;
      asm
        cmp     [ButtonCount], 0
        je      @@1
        push    eax
        mov     eax, 2
        int     33h
        pop     eax
@@1:
end;
{$endif}
{$ifdef __WIN32__}
begin
{$system}
  if %inGraph then ShowCursor(FALSE);
end;
{$endif}
{$ifdef __OS2__}
begin
  Mou16RemovePtr(ProtectArea, hMou);
end;
{$endif}

{$system}

{$ifdef __DOS__}
procedure MouseHandler; code;
asm
   push    ds
   push    es
   pushfd
   pushad
   mov     ds, cs:%flat_ds
   mov     es, cs:%flat_ds
   mov     save_ss, ss
   mov     save_sp, esp
   mov     ss, cs:%flat_ds
   mov     esp, new_stack

   cmp     dword ptr [MouseHnd], 0
   je      @Done

   mov     edi, RealRegs
   push    [edi].Registers.eax
   push    [edi].Registers.ebx
   push    [edi].Registers.ecx
   push    [edi].Registers.edx
   push    [edi].Registers.edi
   push    [edi].Registers.esi
   mov     ebp, dword ptr [MouseHnd+4]
   call    dword ptr [MouseHnd]
@Done:
   mov     ss, save_ss
   mov     esp, save_sp
   popad
   popfd
   pop     es
   pop     ds

   push    eax
   movzx   eax, si
   mov     eax,dword ptr [eax]
   mov     dword ptr es:[edi+02ah], eax
   add     word ptr es:[edi+02eh], 4
   pop     eax
   iretd
end;

function GetFreeInt: Word;
var
  N: Word;
begin
  Result:=0;
  while Result <= 240 do
  begin
    N := 0;
    while MemD[(Result + N) shl 2] = 0 do
    begin
      Inc(N);
      if N = 13 then
        exit;
    end;
    Inc(Result);
  end;
end;
{$endif}

function  MousePresent: Boolean;
begin
  if not Initialized then
  begin
    InitMouse;
    Result := ButtonCount <> 0;
    DoneMouse;
  end else
    Result := ButtonCount <> 0;
end;

procedure InitMouse;
{$ifdef __DOS__}
var
  R: TRmRegs;
  FreeInt: Word;
begin
  ClearRmRegs(R);
  r.AX := $3533;
  RealModeInt($21, r);
  FreeInt := GetFreeInt;
  if FreeInt > 240 then
    FreeInt := 435;
  if (r.ES or r.BX)<>0 then
    asm
      pushad
      xor   eax, eax
      int   33h
      or    eax, eax
      je    @Exit
      and   ebx, 0FFFFh
      mov   [ButtonCount], ebx
   @Exit:
      popad
   end;
   if ButtonCount > 0 then
   begin
      RealRegs := Pointer(FreeInt shl 2);
      GetMem(Stack, 4096);
      asm
         mov   eax, Stack
         add   eax, 4096
         mov   new_stack, eax
         pushad
         mov   ax, 303h
         mov   esi, offset MouseHandler
         mov   edi, RealRegs
         push  ds
         push  cs
         pop   ds
         int   31h
         pop   ds
         mov   [hnd_es], cx
         mov   [hnd_edx], edx
         popad
      end;
   end;
   Initialized := TRUE;
end;
{$endif}
{$ifdef __WIN32__}
var Mode: DWord := 0;
begin
{$system}
  if %inGraph then
    ButtonCount := GetSystemMetrics(SM_CMOUSEBUTTONS)
  else
  begin
    GetNumberOfConsoleMouseButtons(ButtonCount);
    if ButtonCount > 0 then begin
     SysAddEvent(_MOUSE_EVENT);
     GetConsoleMode(TTextRec(Input).Handle, Mode);
     SetConsoleMode(TTextRec(Input).Handle, Mode or ENABLE_MOUSE_INPUT);
     GetConsoleMode(TTextRec(Input).Handle, Mode);
     SetConsoleMode(TTextRec(Input).Handle, Mode or ENABLE_MOUSE_INPUT);
    end;
  end;
  Initialized := TRUE;
end;
{$endif}
{$ifdef __OS2__}
var
  Buttons: System.Word;
begin
 if Mou16Open(nil, hMou) = 0 then
  begin
    Mou16GetNumButtons(Buttons, hMou);
    ButtonCount := Buttons;
    ShowMouse;
  end;
  Initialized := TRUE;
end;
{$endif}

procedure SetMousePos(X, Y: DWord);
{$ifdef __DOS__}
assembler;
      asm
        cmp     [ButtonCount], 0
        je      @@1
        mov     ecx, [X]
        mov     edx, [Y]
        mov     eax, 4
        int     33h
@@1:
end;
{$endif}
{$ifdef __WIN32__}
begin
{$system}
  if %inGraph then SetCursorPos(X, Y);
end;
{$endif}
{$ifdef __OS2__}
var
  MouLoc: PtrLoc;
begin
  MouLoc.Col := X;
  MouLoc.Row := Y;
  Mou16SetPtrPos(MouLoc, hMou);
end;
{$endif}

procedure GetMouseInfo(var ButtonMask: Word; var X: Word; var Y: Word);
{$ifdef __DOS__}
assembler;
      asm
        cmp     [ButtonCount], 0
        jne     @@Cont
        xor     ebx, ebx
        xor     ecx, ecx
        xor     edx, edx
        jmp     @@1
@@Cont:
        mov     eax, 3
        int     33h
@@1:
        mov     eax, [ButtonMask]
        mov     [eax], bx
        mov     eax, [X]
        mov     [eax], cx
        mov     eax, [Y]
        mov     [eax], dx
end;
{$endif}
{$ifdef __WIN32__}
begin
  if ButtonCount = 0 then
  begin
    ButtonMask := 0;
    X := 0;
    Y := 0;
  end else
  begin
    if not %inGraph then
    begin
      asm
        mov     eax, [thMouseX]
        mov     edi, [X]
        mov     [edi], ax
        mov     eax, [thMouseY]
        mov     edi, [Y]
        mov     [edi], ax
        xor     eax, eax
        or      al, [thMouseM]
        shl     eax, 1
        or      al, [thMouseR]
        shl     eax, 1
        or      al, [thMouseL]
        mov     edi, [ButtonMask]
        mov     [edi], eax
      end;
    end else
    begin
      ButtonMask := DWORD(LeftButtonPressed) * LeftBtnMask +
                    DWORD(MiddleButtonPressed) * MiddleBtnMask +
                    DWORD(RightButtonPressed) * RightBtnMask;
      X := GetMouseX;
      Y := GetMouseY;
    end;
  end;
end;
{$endif}
{$ifdef __OS2__}
begin
  (* not implemented *)
end;
{$endif}

function GetMouseX: DWord;
{$ifdef __DOS__}
assembler;
      asm
        mov     eax, [ButtonCount]
        xor     eax, 0
        jz      @@1
        mov     eax, 3
        int     $33
        and     ecx, $FFFF
        mov     eax, ecx
@@1:
end;
{$endif}
{$ifdef __WIN32__}
begin
{$system}
  if ButtonCount = 0 then
    Result := 0
  else
  begin
    if %inGraph then
    declare
    var
      lp: TPoint;
    begin
      GetCursorPos(lp);
      Result := lp.X;
    end
    else
      Result := thMouseX;
  end;
end;
{$endif}
{$ifdef __OS2__}
var
  MouLoc: PtrLoc;
begin
  if ButtonCount = 0 then
    Result := 0
  else
  begin
    Mou16GetPtrPos(MouLoc, hMou);
    Result := MouLoc.Col;
  end;
end;
{$endif}

function GetMouseY: DWord;
{$ifdef __DOS__}
assembler;
      asm
        mov     eax, [ButtonCount]
        xor     eax, 0
        jz      @@1
        mov     eax, 3
        int     $33
        and     edx, $FFFF
        mov     eax, edx
@@1:
end;
{$endif}
{$ifdef __WIN32__}
{$system}
  if ButtonCount = 0 then
    Result := 0
  else
  begin
    if %inGraph then
    declare
    var
      lp: TPoint;
    begin
      GetCursorPos(lp);
      Result := lp.Y;
    end
    else
      Result := thMouseY;
  end;
{$endif}
{$ifdef __OS2__}
var
  MouLoc: PtrLoc;
begin
  if ButtonCount = 0 then
    Result := 0
  else
  begin
    Mou16GetPtrPos(MouLoc, hMou);
    Result := MouLoc.Row;
  end;
end;
{$endif}

function LeftButtonPressed: Boolean;
{$ifdef __DOS__}
assembler;
      asm
        mov     eax, [ButtonCount]
        xor     eax, 0
        jz      @@1
        mov     eax, 3
        int     33h
        mov     eax, ebx
        and     eax, 01h
@@1:
end;
{$endif}
{$ifdef __WIN32__}
{$system}
begin
  if ButtonCount = 0 then
    Result := FALSE
  else
  begin
    if %inGraph then
    begin
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
        Result := %MouseLButton;
      end;
    end else
      Result := thMouseL;
  end;
end;
{$endif}
{$ifdef __OS2__}
begin
  (* not implemented *)
end;
{$endif}

function MiddleButtonPressed: Boolean;
{$ifdef __DOS__}
assembler;
      asm
        mov     eax, [ButtonCount]
        xor     eax, 0
        jz      @@1
        mov     eax, 3
        int     33h
        mov     eax, ebx
        and     eax, 04h
@@1:
end;
{$endif}
{$ifdef __WIN32__}
{$system}
begin
  if ButtonCount = 0 then
    Result := FALSE
  else
  begin
    if %inGraph then
    begin
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
        Result := %MouseMButton;
      end;
    end else
      Result := thMouseM;
  end;
end;
{$endif}
{$ifdef __OS2__}
begin
  (* not implemented *)
end;
{$endif}

function RightButtonPressed: Boolean;
{$ifdef __DOS__}
assembler;
      asm
        mov     eax, [ButtonCount]
        xor     eax, 0
        jz      @@1
        mov     eax,3
        int     33h
        mov     eax, ebx
        and     eax, 02h
@@1:
end;
{$endif}
{$ifdef __WIN32__}
{$system}
begin
  if ButtonCount = 0 then
    Result := FALSE
  else
  begin
    if %inGraph then
    begin
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
        Result := %MouseRButton;
      end;
    end else
      Result := thMouseR;
  end;
end;
{$endif}
{$ifdef __OS2__}
begin
  (* not implemented *)
end;
{$endif}

procedure SetMouseHandler(Mask: DWord; procedure Hnd(Mask, Buttons, X, Y, MovX, MovY: System.Word));
{$ifdef __DOS__}
var R: Registers;
begin
  if ButtonCount = 0 then exit;
  MouseHnd := Hnd;
      asm
        mov     ax, [hnd_es]
        mov     [r.es], ax
        mov     eax, [hnd_edx]
        mov     [r.edx], eax
        mov     eax, [Mask]
        mov     [r.cx], ax
        mov     [r.ax], $0C
        mov     [r.sp], 0
        mov     [r.ss], 0
        mov     ax, 0300h
        mov     bx, 33h
        xor     ecx, ecx
        mov     [r.sp], 0
        mov     [r.ss], 0
        lea     edi, [r]
        int     31h
     end;
end;
{$endif}
{$ifdef __WIN32__}
begin
  if ButtonCount = 0 then exit;
  if %inGraph then
  begin
    %GrMouseHnd  := Hnd;
    %GrMouseMask := Mask;
  end else
    SysEventMask(_MOUSE_EVENT, Mask, @Hnd);
end;
{$endif}
{$ifdef __OS2__}
begin
  (* not implemented *)
end;
{$endif}

procedure ClearMouseHandler;
{$ifdef __DOS__}
begin
  Hnd.Entry := 0;
  Hnd.Base  := 0;
end;
{$endif}
{$ifdef __WIN32__}
begin
  if %inGraph then
  begin
    %GrMouseMask := 0;
    %GrMouseHnd  := nil;
  end else
    SysEventMask(_MOUSE_EVENT, 0, nil);
end;
{$endif}
{$ifdef __OS2__}
begin
  (* not implemented *)
end;
{$endif}

procedure DoneMouse;
{$ifdef __DOS__}
begin
  HideMouse;
  asm
    mov    cx, [hnd_es]
    mov    edx, [hnd_edx]
    mov    ax, 0304h
    int    31h
    mov    eax, 0Ch
    xor    ecx, ecx
    int    33h
  end;
  ButtonCount := 0;
  FreeMem(Stack, 4096);
  FillChar(RealRegs^, SizeOf(RealRegs^), 0);
  Initialized := FALSE;
end;
{$endif}
{$ifdef __WIN32__}
begin
{$system}
  if %inGraph then
    ClearMouseHandler
  else
    SysRemoveEvent(_MOUSE_EVENT);
  Initialized := FALSE;
end;
{$endif}
{$ifdef __OS2__}
begin
  Mou16Close(hMou);
  Initialized := FALSE;
end;
{$endif}

procedure SetMouseRange(MinX, MinY, MaxX, MaxY: DWord);
{$ifdef __DOS__}
assembler;
      asm
        mov     ecx, [MinX]
        mov     edx, [MaxX]
        mov     eax, 7
        int     $33
        mov     ecx, [MinY]
        mov     edx, [MaxY]
        mov     eax, 8
        int     $33
end;
{$endif}
{$ifdef __WIN32__}
var
  r: TRect;
begin
  if %inGraph then
  begin
    r.Left := MinX;
    r.Top := MinY;
    r.Right := MaxX;
    r.Bottom := MaxY;
    ClipCursor(r);
  end;
end;
{$endif}
{$ifdef __OS2__}
begin
  (* not implemented *)
end;
{$endif}

function MickyToText(Coord: DWord): DWord; code;
      asm
        mov     eax, [Coord]
        shr     eax, 3
        ret
end;

function TextToMicky(Coord: DWord): DWord; code;
      asm
        mov     eax, [Coord]
        shl     eax, 3
        ret
end;

begin
  ButtonCount := 0;
  Initialized := FALSE;
end.