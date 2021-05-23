(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       The WinCRT Unit                                        *)
(*       Targets: WIN32 GUI only                                *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$DEFINE AUTOINIT}

unit WinCrt;

interface

uses Math, Strings, Windows, Messages;

const
  InactiveTitle: PChar = '(Inactive %s)';

type
  TLongPoint = record
    X: Longint;
    Y: Longint;
  end;

const
  // Standard CRT colors
  Black         = $000000;
  Blue          = $FF0000;
  Green         = $008000;
  LightBlue     = $FF8080;
  Red           = $0000FF;
  Yellow        = $00FFFF;
  LightCyan     = $800080;
  White         = $FFFFFF;
  LightGray     = $C0C0C0;
  DarkGray      = $808080;
  Cyan          = $C0C000;
  Magenta       = $C000C0;
  Brown         = $0080C0;
  LightGreen    = $80FF80;
  LightRed      = $8080FF;
  LightMagenta  = $FF80FF;
  // Additional Windows colors
  Maroon        = $000080;
  Olive         = $008080;
  Navy          = $800000;
  Purple        = $800080;
  Teal          = $808000;
  Gray          = $808080;
  Silver        = $C0C0C0;
  Lime          = $00FF00;
  Fuchsia       = $FF00FF;
  Aqua          = $FFFF00;

const
  WindowOrg       : TLongPoint = (X: CW_USEDEFAULT; Y: CW_USEDEFAULT);
  WindowSize      : TLongPoint = (X: CW_USEDEFAULT; Y: CW_USEDEFAULT);
  ScreenSize      : TLongPoint = (X: 80; Y: 25);
  Cursor          : TLongPoint = (X: 0; Y: 0);
  CurOrg          : TLongPoint = (X: 0; Y: 0);
  WindMax         : Word = 6223;
  WindMin         : Word = 0;

var
  AutoTracking    : Boolean := TRUE;
  CheckEOF        : Boolean := FALSE;
  CheckBreak      : Boolean := TRUE;
  ScrollCrtWindow : Boolean := TRUE;
  CloseOnExit     : Boolean := FALSE;
  WindowTitle     : array [0..79] of Char;
  CrtWindow       : HWnd := 0;

procedure AssignCrt(var F: Text);
procedure InitWinCrt;
procedure DoneWinCrt;
procedure ShowCursor;
procedure HideCursor;
procedure WriteBuf(Buffer: PChar; Count: DWORD);
procedure WriteChar(Ch: Char);
function  KeyPressed: Boolean;
function  ReadKey: Char;
function  ReadBuf(Buffer: PChar; Count: DWORD): DWORD;
procedure GotoXY(X, Y: Longint);
function  WhereX: Longint;
function  WhereY: Longint;
procedure ClrScr;
procedure ClrEol;
procedure CursorTo(X, Y: Longint);
procedure ScrollTo(X, Y: Longint);
procedure TrackCursor;
procedure Delay(MS: Longint);
procedure TextBackground(Color: DWORD);
procedure TextColor(Color: DWORD);
function  GetCharXY(X, Y: Longint): Char;
procedure Sound(Hz: DWORD);
procedure NoSound;
procedure PlaySound(Freq, Duration: Longint);

implementation

const
  ZeroCoord: TPoint = (X: 0; Y: 0);
  OldScreenSize: TLongPoint = (X: 0; Y: 0);

var
  CrtWindowClass: TWndClass;

type
  PMinMaxInfo = ^TMinMaxInfo;
  TMinMaxInfo = array[0..4] of TPoint;

type
  TScrollKey = record
    Key: Byte;
    Ctrl: LongBool;
    SBar: Longint;
    Action: Longint;
  end;

const
  ScrollKeyMax = 11;
  ScrollKeyArray: array[0..ScrollKeyMax] of TScrollKey = (
    (Key: VK_LEFT;  CTRL: LONGFALSE; SBar: SB_HORZ; Action: SB_LINEUP),
    (Key: VK_RIGHT; CTRL: LONGFALSE; SBar: SB_HORZ; Action: SB_LINEDOWN),
    (Key: VK_LEFT;  CTRL: LONGTRUE;  SBar: SB_HORZ; Action: SB_PAGEUP),
    (Key: VK_RIGHT; CTRL: LONGTRUE;  SBar: SB_HORZ; Action: SB_PAGEDOWN),
    (Key: VK_HOME;  CTRL: LONGFALSE; SBar: SB_HORZ; Action: SB_TOP),
    (Key: VK_END;   CTRL: LONGFALSE; SBar: SB_HORZ; Action: SB_BOTTOM),
    (Key: VK_UP;    CTRL: LONGFALSE; SBar: SB_VERT; Action: SB_LINEUP),
    (Key: VK_DOWN;  CTRL: LONGFALSE; SBar: SB_VERT; Action: SB_LINEDOWN),
    (Key: VK_PRIOR; CTRL: LONGFALSE; SBar: SB_VERT; Action: SB_PAGEUP),
    (Key: VK_NEXT;  CTRL: LONGFALSE; SBar: SB_VERT; Action: SB_PAGEDOWN),
    (Key: VK_HOME;  CTRL: LONGTRUE;  SBar: SB_VERT; Action: SB_TOP),
    (Key: VK_END;   CTRL: LONGTRUE;  SBar: SB_VERT; Action: SB_BOTTOM));

var
  FirstLine: Longint := 0;
  KeyNumber: Longint := 0;
  isWindowExists: Boolean := FALSE;
  isFocused: Boolean := FALSE;
  isReading: Boolean := FALSE;
  isPainting: Boolean := FALSE;
  isUseCaret: Boolean := TRUE;
  OldExitProc: Pointer;
  ScreenBuffer: PChar := nil;
  TextColorBuffer: Pointer := nil;
  WindowColorBuffer: Pointer := nil;
  ClientSize: TPoint;
  Range: TLongPoint;
  CharSize: TPoint;
  CharAscent: Longint;
  WinCrtDC: HDC;
  PS: TPaintStruct;
  SaveFont: hFont;
  KeyBuffer: array[0..79] of Char;
  CrtTextColor: DWORD;
  CrtWindowColor: DWORD;
  CrtFont: HFont := 0;

procedure CrtShowCaret;
begin
  if isUseCaret then
  begin
    CreateCaret(CrtWindow, 0, CharSize.X, 2);
    SetCaretPos((Cursor.X - CurOrg.X) * CharSize.X, (Cursor.Y - CurOrg.Y) * CharSize.Y + CharAscent);
    ShowCaret(CrtWindow);
  end;
end;

procedure CrtHideCaret;
begin
  DestroyCaret;
end;

procedure AdjustScrollBars;
begin
  SetScrollRange(CrtWindow, SB_HORZ, 0, Max(1, Range.X), FALSE);
  SetScrollPos(CrtWindow, SB_HORZ, CurOrg.X, TRUE);
  SetScrollRange(CrtWindow, SB_VERT, 0, Max(1, Range.Y), FALSE);
  SetScrollPos(CrtWindow, SB_VERT, CurOrg.Y, TRUE);
end;

procedure OnResize(X, Y: Longint);
begin
  if isReading and isFocused then CrtHideCaret;
  ClientSize.X := X div CharSize.X;
  ClientSize.Y := Y div CharSize.Y;
  Range.X := Max(0, ScreenSize.X - ClientSize.X);
  Range.Y := Max(0, ScreenSize.Y - ClientSize.Y);
  CurOrg.X := Min(CurOrg.X, Range.X);
  CurOrg.Y := Min(CurOrg.Y, Range.Y);
  AdjustScrollBars;
  if isFocused and isReading then CrtShowCaret;
end;

procedure FillDWORD(P: Pointer; Num, Value: DWORD); code;
asm
  push  ecx
  mov   ecx, [Num + 4]
  mov   eax, [Value + 4]
  mov   edi, [P + 4]
  rep   stosd
  pop   ecx
  ret
end;

procedure CheckScreenBuffer;
var
  rect: TRect;
begin
  if ((OldScreenSize.X) <> (ScreenSize.X)) or
     ((OldScreenSize.Y) <> (ScreenSize.Y)) then
  begin
    GetWindowRect(CrtWindow, rect);
    MoveWindow(CrtWindow, rect.Left, rect.Top, rect.Left + CharSize.X * ScreenSize.X, rect.Bottom - rect.Top + 1, TRUE);

    if ScreenBuffer <> nil then
      FreeMem(ScreenBuffer, OldScreenSize.X * OldScreenSize.Y);
    GetMem(ScreenBuffer, ScreenSize.X * ScreenSize.Y);
    FillChar(ScreenBuffer^, ScreenSize.X * ScreenSize.Y, ' ');

    if TextColorBuffer <> nil then
      FreeMem(TextColorBuffer, 4 * OldScreenSize.X * OldScreenSize.Y);
    GetMem(TextColorBuffer, 4 * ScreenSize.X * ScreenSize.Y);
    FillDWORD(TextColorBuffer, ScreenSize.X * ScreenSize.Y, CrtTextColor);

    if WindowColorBuffer <> nil then
      FreeMem(WindowColorBuffer, 4 * OldScreenSize.X * OldScreenSize.Y);
    GetMem(WindowColorBuffer, 4 * ScreenSize.X * ScreenSize.Y);
    FillDWORD(WindowColorBuffer, ScreenSize.X * ScreenSize.Y, CrtWindowColor);

    OldScreenSize := ScreenSize;
  end;
end;

procedure _init(UpdateTitle: Boolean);
begin
  if not isWindowExists then
  begin
    CrtWindow := CreateWindow(CrtWindowClass.lpszClassName, WindowTitle,
      WS_OVERLAPPEDWINDOW or WS_HSCROLL or WS_VSCROLL, WindowOrg.X, WindowOrg.Y,
      WindowSize.X, WindowSize.Y, 0, 0, hInstance, nil);
    ShowWindow(CrtWindow, CmdShow);
    UpdateWindow(CrtWindow);
  end else
  begin
    if UpdateTitle then
      SendMessage(CrtWindow, WM_SETTEXT, 0, LParam(@WindowTitle));
  end;
  CheckScreenBuffer;
end;

procedure ColorTextOut(WinCrtDC: HDC; xStart, yStart: Longint; s: PChar; TextColorBuf, WindowColorBuf: Pointer; Num: DWORD);
var
  CurTextColor: DWORD := GetTextColor(WinCrtDC);
  CurWindowColor: DWORD := GetBkColor(WinCrtDC);
begin
  repeat
    if DWORD(TextColorBuf^) <> CurTextColor then
    begin
      CurTextColor := DWORD(TextColorBuf^);
      SetTextColor(WinCrtDC, CurTextColor);
    end;
    if DWORD(WindowColorBuf^) <> CurWindowColor then
    begin
      CurWindowColor := DWORD(WindowColorBuf^);
      SetBkColor(WinCrtDC, CurWindowColor);
    end;
    TextOut(WinCrtDC, xStart, yStart, s, 1);
    inc(WindowColorBuf, 4);
    inc(TextColorBuf, 4);
    inc(s);
    xStart +:= CharSize.X;
    Num -:= 1;
  until Num <= 0;
end;

procedure InitDeviceContext;
begin
  CheckScreenBuffer;
  if isPainting then
    WinCrtDC := BeginPaint(CrtWindow, PS)
  else
    WinCrtDC := GetDC(CrtWindow);
  SaveFont := SelectObject(WinCrtDC, GetStockObject(SYSTEM_FIXED_FONT));
  SetTextColor(WinCrtDC, CrtTextColor);
  SetBkColor(WinCrtDC, CrtWindowColor);
end;

procedure DoneDeviceContext;
begin
  SelectObject(WinCrtDC, SaveFont);
  if CrtFont <> 0 then
  begin
    DeleteObject(CrtFont);
    CrtFont := 0;
  end;
  if isPainting then
    EndPaint(CrtWindow, PS) else
    ReleaseDC(CrtWindow, WinCrtDC);
end;

procedure ShowCursor;
begin
  isUseCaret := TRUE;
  CrtShowCaret;
end;

procedure HideCursor;
begin
  isUseCaret := FALSE;
  CrtHideCaret;
end;

procedure Terminate;
begin
  if isFocused and isReading then
    CrtHideCaret;
  Halt($FF);
end;

procedure CursorTo(X, Y: Longint);
begin
  Cursor.X := Max(0, Min(X, ScreenSize.X - 1));
  Cursor.Y := Max(0, Min(Y, ScreenSize.Y - 1));
end;

procedure ScrollTo(X, Y: Longint);
begin
  if isWindowExists then
  begin
    X := Max(0, Min(X, Range.X));
    Y := Max(0, Min(Y, Range.Y));
    if (X <> CurOrg.X) or (Y <> CurOrg.Y) then
    begin
      if X <> CurOrg.X then SetScrollPos(CrtWindow, SB_HORZ, X, TRUE);
      if Y <> CurOrg.Y then SetScrollPos(CrtWindow, SB_VERT, Y, TRUE);
      ScrollWindow(CrtWindow, (CurOrg.X - X) * CharSize.X, (CurOrg.Y - Y) * CharSize.Y, nil, nil);
      CurOrg.X := X;
      CurOrg.Y := Y;
      UpdateWindow(CrtWindow);
    end;
  end;
end;

procedure TrackCursor;
begin
  ScrollTo(Max(Cursor.X - ClientSize.X + 1, Min(CurOrg.X, Cursor.X)),
    Max(Cursor.Y - ClientSize.Y + 1, Min(CurOrg.Y, Cursor.Y)));
end;

function ScreenPtr(X, Y: Longint): PChar;
begin
  Y +:= FirstLine;
  if Y >= ScreenSize.Y then
    Y -:= ScreenSize.Y;
  Result := @ScreenBuffer[Y * ScreenSize.X + X];
end;

function TextColorPtr(X, Y: Longint): Pointer;
begin
  Y +:= FirstLine;
  if Y >= ScreenSize.Y then
    Y -:= ScreenSize.Y;
  Result := TextColorBuffer + (4 * (Y * ScreenSize.X + X));
end;

function WindowColorPtr(X, Y: Longint): Pointer;
begin
  Y +:= FirstLine;
  if Y >= ScreenSize.Y then
    Y -:= ScreenSize.Y;
  Result := WindowColorBuffer + (4 * (Y * ScreenSize.X + X));
end;

procedure ShowText(L, R: Longint);
begin
  if L < R then
  begin
    InitDeviceContext;
    ColorTextOut(WinCrtDC, (L - CurOrg.X) * CharSize.X,
      (Cursor.Y - CurOrg.Y) * CharSize.Y,
      ScreenPtr(L, Cursor.Y), TextColorPtr(L, Cursor.Y), WindowColorPtr(L, Cursor.Y), R - L);
    DoneDeviceContext;
  end;
end;

function crt_write(f: Longint; buf: Pointer; Len: Longint; var Act: Longint): Longint;
var
  L, R: Longint;
  Buffer: PChar := PChar(Buf);
  Count: Longint := Len;
procedure NewLine;
begin
  ShowText(L, R);
  L := 0;
  R := 0;
  Cursor.X := 0;
  Cursor.Y +:= 1;
  if Cursor.Y = ScreenSize.Y then
  begin
    Cursor.Y -:= 1;
    FirstLine +:= 1;
    if FirstLine = ScreenSize.Y then FirstLine := 0;
    FillChar(ScreenPtr(0, Cursor.Y)^, ScreenSize.X, ' ');
    FillDWORD(TextColorPtr(0, Cursor.Y), ScreenSize.X, CrtTextColor);
    FillDWORD(WindowColorPtr(0, Cursor.Y), ScreenSize.X, CrtWindowColor);
    ScrollWindow(CrtWindow, 0, -CharSize.Y, nil, nil);
    UpdateWindow(CrtWindow);
  end;
end;

begin
  _init(FALSE);
  L := Cursor.X;
  R := Cursor.X;
  while Count > 0 do
  begin
    case Buffer^ of
      #1..#6, #9, #11, #12, #14..#255:
        begin
          ScreenPtr(Cursor.X, Cursor.Y)^ := Buffer^;
          DWORD(TextColorPtr(Cursor.X, Cursor.Y)^) := CrtTextColor;
          DWORD(WindowColorPtr(Cursor.X, Cursor.Y)^) := CrtWindowColor;
          Cursor.X +:= 1;
          if Cursor.X > R then R := Cursor.X;
          if Cursor.X = ScreenSize.X then NewLine;
        end;
      #13:
        NewLine;
      #8:
        if Cursor.X > 0 then
        begin
          Cursor.X -:= 1;
          ScreenPtr(Cursor.X, Cursor.Y)^ := ' ';
          DWORD(TextColorPtr(Cursor.X, Cursor.Y)^) := CrtTextColor;
          DWORD(WindowColorPtr(Cursor.X, Cursor.Y)^) := CrtWindowColor;
          if Cursor.X < L then L := Cursor.X;
        end;
      #7:
        MessageBeep(0);
    end;
    Inc(Buffer);
    Count -:= 1;
  end;
  ShowText(L, R);
  if AutoTracking then TrackCursor;
  Act := Len;
  Result := 0;
end;

procedure WriteBuf(Buffer: PChar; Count: DWORD);
var
  act: Longint;
begin
  crt_write(TTextRec(Output).Handle, Buffer, Count, act);
end;

procedure WriteChar(Ch: Char);
var
  act: Longint;
begin
  crt_write(0, @Ch, 1, act);
end;

function KeyPressed: Boolean;
var
  Msg: TMsg;
begin
  _init(FALSE);
  while PeekMessage(Msg, 0, 0, 0, PM_REMOVE) do
  begin
    if Msg.Message = WM_QUIT then
    Terminate;
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
  Result := KeyNumber > 0;
end;

function ReadKey: Char;
begin
  TrackCursor;
  if not KeyPressed then
  begin
    isReading := TRUE;
    if isFocused then CrtShowCaret;
    repeat
      WaitMessage
    until KeyPressed;
    if isFocused then CrtHideCaret;
    isReading := FALSE;
  end;
  Result := KeyBuffer[0];
  KeyNumber -:= 1;
  Move(KeyBuffer[1], KeyBuffer[0], KeyNumber);
end;

function crt_read(f: Longint; aBuf: Pointer; Len: Longint; var Act: Longint): Longint;
var
  c: Char;
const
  buf: string = '';
  procedure crt_rd_ln;
  begin
    Length(buf) := 0;
    while true do
    begin
      repeat
         c := ReadKey;
         if c = #0 then ReadKey;
      until c <> #0;
      case c of
        #8:
           if Length(buf) <> 0 then
           begin
             WriteChar(#8);
             Length(buf) -:= 1;
           end;
        ' '..#255:
           if Length(buf) <> 253 then
           begin
             Length(buf) +:= 1;
             buf[Length(buf)] := c;
             WriteChar(c);
           end;
        else
             if (c = ^M) or (c = ^J) or (c = ^Z) and checkEOF then
             begin
               Length(buf) +:= 1;
               buf[Length(buf)] := ^M;
               Length(buf) +:= 1;
               Buf[Length(buf)] := ^J;
               WriteChar(#13);
               exit;
             end;
      end;
    end;
  end;
begin
  act := 0;
  while len > Length(buf) do
  begin
    Move(buf[1], PChar(aBuf)[act], Length(buf));
    act +:= Length(buf);
    Len -:= Length(buf);
    crt_rd_ln;
  end;
  Move(buf[1], PChar(aBuf)[act], len);
  act +:= len;
  Delete(buf, 1, len);
  Result := 0;
  TrackCursor;
end;

function ReadBuf(Buffer: PChar; Count: DWORD): DWORD;
var
  Act: Longint;
begin
  Result := crt_read(TTextRec(Input).Handle, Buffer, Count, Act);
end;

procedure GotoXY(X, Y: Longint);
begin
  Cursor.X := Max(0, Min(X, ScreenSize.X - 1)) - 1;
  Cursor.Y := Max(0, Min(Y, ScreenSize.Y - 1)) - 1;
end;

function WhereX: Longint;
begin
  Result := Cursor.X + 1;
end;

function WhereY: Longint;
begin
  Result := Cursor.Y + 1;
end;

procedure ClrScr;
begin
  _init(FALSE);
  FillChar(ScreenBuffer^, ScreenSize.X * ScreenSize.Y, ' ');
  FillDWORD(TextColorBuffer, ScreenSize.X * ScreenSize.Y, CrtTextColor);
  FillDWORD(WindowColorBuffer, ScreenSize.X * ScreenSize.Y, CrtWindowColor);
  FillChar(Cursor, 4, 0);
  FillChar(CurOrg, 4, 0);
  AdjustScrollBars;
  InvalidateRect(CrtWindow, nil, TRUE);
  UpdateWindow(CrtWindow);
  GotoXY(1, 1);
end;

procedure ClrEol;
begin
  _init(FALSE);
  FillChar(ScreenPtr(Cursor.X, Cursor.Y)^, ScreenSize.X - Cursor.X, ' ');
  FillDWORD(TextColorPtr(Cursor.X, Cursor.Y), ScreenSize.X - Cursor.X, CrtTextColor);
  FillDWORD(WindowColorPtr(Cursor.X, Cursor.Y), ScreenSize.X - Cursor.X, CrtWindowColor);
  ShowText(Cursor.X, ScreenSize.X);
end;

procedure OnCreate;
begin
  isWindowExists := TRUE;
  if not CheckBreak then
    EnableMenuItem(GetSystemMenu(CrtWindow, FALSE), sc_Close, mf_Disabled or mf_Grayed);
end;

procedure OnPaint;
var
  X1, X2, Y1, Y2: Longint;
begin
  isPainting := TRUE;
  InitDeviceContext;
  X1 := Max(0, PS.rcPaint.left div CharSize.X + CurOrg.X);
  Y1 := Max(0, PS.rcPaint.top div CharSize.Y + CurOrg.Y);
  X2 := Min(ScreenSize.X, (PS.rcPaint.right + CharSize.X - 1) div CharSize.X + CurOrg.X);
  Y2 := Min(ScreenSize.Y, (PS.rcPaint.bottom + CharSize.Y - 1) div CharSize.Y + CurOrg.Y);
  while Y1 < Y2 do
  begin
    ColorTextOut(WinCrtDC, (X1 - CurOrg.X) * CharSize.X, (Y1 - CurOrg.Y) * CharSize.Y,
      ScreenPtr(X1, Y1), TextColorPtr(X1, Y1), WindowColorPtr(X1, Y1), X2 - X1);
    Y1 +:= 1;
  end;
  DoneDeviceContext;
  isPainting := FALSE;
end;

procedure OnScroll(ScrollBarID, Action, Thumb: Longint);
var
  X: Longint := CurOrg.X;
  Y: Longint := CurOrg.Y;

  function CalcPos(Pos, Range, Page: Longint): Longint;
  begin
    case Action of
      SB_TOP:           Result := 0;
      SB_BOTTOM:        Result := Range;
      SB_LINEUP:        Result := Pos - 1;
      SB_LINEDOWN:      Result := Pos + 1;
      SB_PAGEUP:        Result := Pos - Page;
      SB_PAGEDOWN:      Result := Pos + Page;
      SB_THUMBPOSITION: Result := Thumb;
    else
      Result := Pos;
    end;
  end;

begin
  case ScrollBarID of
    SB_HORZ: X := CalcPos(X, Range.X, ClientSize.X shr 1);
    SB_VERT: Y := CalcPos(Y, Range.Y, ClientSize.Y);
  end;
  ScrollTo(X, Y);
end;

procedure OnMinMaxInfo(MinMaxInfo: PMinMaxInfo);
var
  X, Y: Longint;
  TextMetric: TTextMetric;
begin
  InitDeviceContext;
  GetTextMetrics(WinCrtDC, TextMetric);
  CharSize.X := TextMetric.tmMaxCharWidth;
  CharSize.Y := TextMetric.tmHeight + TextMetric.tmExternalLeading;
  CharAscent := TextMetric.tmAscent;
  X := Min(ScreenSize.X * CharSize.X + GetSystemMetrics(sm_CXVScroll), GetSystemMetrics(sm_CXScreen)) + GetSystemMetrics(sm_CXFrame) * 2;
  Y := Min(ScreenSize.Y * CharSize.Y + GetSystemMetrics(sm_CYHScroll) + GetSystemMetrics(sm_CYCaption), GetSystemMetrics(sm_CYScreen)) + GetSystemMetrics(sm_CYFrame) * 2;
  MinMaxInfo^[1].x := X;
  MinMaxInfo^[1].y := Y;
  MinMaxInfo^[3].x := CharSize.X * 16 + GetSystemMetrics(sm_CXVScroll) + GetSystemMetrics(sm_CXFrame) * 2;
  MinMaxInfo^[3].y := CharSize.Y * 4 + GetSystemMetrics(sm_CYHScroll) + GetSystemMetrics(sm_CYFrame) * 2 + GetSystemMetrics(sm_CYCaption);
  MinMaxInfo^[4].x := X;
  MinMaxInfo^[4].y := Y;
  DoneDeviceContext;
end;

procedure OnChar(Ch: Char);
begin
  if CheckBreak and (Ch = #3) then Terminate;
  if KeyNumber < SizeOf(KeyBuffer) - 1 then
  begin
    KeyBuffer[KeyNumber] := Ch;
    KeyNumber +:= 1;
  end;
end;

procedure OnKeyDown(KeyDown: Byte);
var
  CtrlDown: Boolean;
  i: Longint;
begin
  if CheckBreak and (KeyDown = VK_CANCEL) then Terminate;
  CtrlDown := GetKeyState(VK_CONTROL) < 0;
  if ScrollCrtWindow then
  begin
    for i := 0 to ScrollKeyMax do
      with ScrollKeyArray[i] do
        if (Key = KeyDown) and (Ctrl = CtrlDown) then
        begin
          OnScroll(SBar, Action, 0);
          Exit;
        end;
  end else
  begin
    case KeyDown of
      VK_LEFT  : begin OnChar(#0); OnChar(#75); end;
      VK_RIGHT : begin OnChar(#0); OnChar(#77); end;
      VK_UP    : begin OnChar(#0); OnChar(#72); end;
      VK_DOWN  : begin OnChar(#0); OnChar(#80); end;
      VK_HOME  : begin OnChar(#0); OnChar(#71); end;
      VK_END   : begin OnChar(#0); OnChar(#79); end;
      VK_END   : begin OnChar(#0); OnChar(#79); end;
      VK_PRIOR : begin OnChar(#0); OnChar(#73); end;
      VK_NEXT  : begin OnChar(#0); OnChar(#81); end;
      VK_INSERT: begin OnChar(#0); OnChar(#82); end;
      VK_DELETE: begin OnChar(#0); OnChar(#83); end;
      VK_F1    : begin OnChar(#0); OnChar(#59); end;
      VK_F2    : begin OnChar(#0); OnChar(#60); end;
      VK_F3    : begin OnChar(#0); OnChar(#61); end;
      VK_F4    : begin OnChar(#0); OnChar(#62); end;
      VK_F5    : begin OnChar(#0); OnChar(#63); end;
      VK_F6    : begin OnChar(#0); OnChar(#64); end;
      VK_F7    : begin OnChar(#0); OnChar(#65); end;
      VK_F8    : begin OnChar(#0); OnChar(#66); end;
      VK_F9    : begin OnChar(#0); OnChar(#67); end;
      VK_F10   : begin OnChar(#0); OnChar(#68); end;
      VK_F11   : begin OnChar(#0); OnChar(#69); end;
      VK_F12   : begin OnChar(#0); OnChar(#70); end;
    end;
  end;
end;

procedure OnSetFocus;
begin
  if isReading then CrtShowCaret;
  isFocused := TRUE;
end;

procedure OnKillFocus;
begin
  if isReading then CrtHideCaret;
  isFocused := FALSE;
end;

procedure OnDestroy;
begin
  FreeMem(ScreenBuffer, ScreenSize.X * ScreenSize.Y);
  FreeMem(TextColorBuffer, 4 * ScreenSize.X * ScreenSize.Y);
  FreeMem(WindowColorBuffer, 4 * ScreenSize.X * ScreenSize.Y);
  FillChar(Cursor, 4, 0);
  FillChar(CurOrg, 4, 0);
  PostQuitMessage(0);
  isWindowExists := FALSE;
end;

function CrtWinProc conv arg_stdcall (Window: HWnd; Message, WParam: DWORD; LParam: Longint): Longint;
begin
  CrtWindow := Window;
  case Message of
    WM_CREATE:        OnCreate;
    WM_DESTROY:       OnDestroy;
    WM_PAINT:         OnPaint;
    WM_GETMINMAXINFO: OnMinMaxInfo(PMinMaxInfo(LParam));
    WM_SIZE:          OnResize(LoWord(LParam), HiWord(LParam));
    WM_SETFOCUS:      OnSetFocus;
    WM_KILLFOCUS:     OnKillFocus;
    WM_CHAR:          OnChar(Char(WParam));
    WM_VSCROLL:       OnScroll(SB_VERT, WParam, LoWord(LParam));
    WM_HSCROLL:       OnScroll(SB_HORZ, WParam, LoWord(LParam));
    WM_KEYDOWN:       OnKeyDown(Byte(WParam));
  else
    begin
      Result := DefWindowProc(Window, Message, WParam, LParam);
      exit;
    end;
  end;
  Result := 0;
end;

{$system}
procedure AssignCrt(var F: Text);
begin
  with TTextRec(f) do
  begin
    Handle := $FFFF;
    include(State, %file_tty);
    include(State, %file_special);
    rd_proc := crt_read;
    wr_proc := crt_write;
  end;
end;

procedure InitWinCRT;
begin
  _init(TRUE);
end;

procedure DoneWinCrt;
begin
  if isWindowExists then
    DestroyWindow(CrtWindow);
  Halt(0);
end;

procedure ExitWinCrt;
var
  TmpStr: String;
  TmpPos: Longint;
  Message: TMsg;
  Title: array[0..MAX_PATH] of Char;
begin
  if (isWindowExists) and (ErrorAddr = nil) then
  begin
    if CloseOnExit then
      DestroyWindow(CrtWindow)
    else
    begin
      TmpStr := StrPas(InactiveTitle);
      TmpPos := Pos('%s', TmpStr);
      if TmpPos > 0 then
      begin
        Delete(TmpStr, TmpPos, 2);
        Insert(StrPas(WindowTitle), TmpStr, TmpPos);
      end;
      SetWindowText(CrtWindow, StrPCopy(Title, TmpStr));
      EnableMenuItem(GetSystemMenu(CrtWindow, TRUE), SC_CLOSE, MF_ENABLED);
      ExitProc := OldExitProc;
      CheckBreak := FALSE;
      while GetMessage(Message, 0, 0, 0) do
      begin
        TranslateMessage(Message);
        DispatchMessage(Message);
      end;
    end;
  end;
end;

procedure Delay;
begin
  Sleep(MS);
end;

procedure TextColor(Color: DWORD);
begin
  CrtTextColor := Color;
end;

procedure TextBackground(Color: DWORD);
begin
  CrtWindowColor := Color;
end;

function GetCharXY(X, Y: Longint): Char;
begin
  Result := Char(ScreenPtr(X - 1, Y - 1)^);
end;

// Windows NT only
procedure Sound(Hz: DWORD);
begin
  Beep(hz, -1);
end;

// Windows NT only
procedure NoSound;
begin
  Beep(37, 0);
end;

// Windows NT only
procedure PlaySound(Freq, Duration: Longint);
begin
  Beep(Freq, Duration);
end;

begin
  FillChar(CrtWindowClass, SizeOf(CrtWindowClass), 0);
  with CrtWindowClass do
  begin
    style := CS_HREDRAW or CS_VREDRAW;
    lpfnWndProc := @CrtWinProc;
    cbClsExtra := 0;
    cbWndExtra := 0;
    hInstance := 0;
    hIcon := 0;
    hCursor := 0;
    hbrBackground := 0;
    lpszMenuName := nil;
    lpszClassName := 'TMTPWinCrt';
    hInstance := System.hInstance;
    hIcon := LoadIcon(0, IDI_APPLICATION);
    hCursor := LoadCursor(0, IDC_ARROW);
    hbrBackground := COLOR_WINDOW + 1;
  end;
  RegisterClass(CrtWindowClass);
  AssignCrt(Input);
  AssignCrt(Output);
  CrtTextColor := GetSysColor(COLOR_WINDOWTEXT);
  CrtWindowColor := GetSysColor(COLOR_WINDOW);
  GetModuleFileName(HInstance, WindowTitle, SizeOf(WindowTitle));
  OemToAnsi(WindowTitle, WindowTitle);
  OldExitProc := ExitProc;
  ExitProc := @ExitWinCrt;
{$IFDEF AUTOINIT}
  _init(FALSE);
{$ENDIF}
end.