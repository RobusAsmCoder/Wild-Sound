(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       The CRT Unit                                           *)
(*       Targets: MS-DOS, OS/2 Console, WIN32 Console           *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Authors: Anton Moscal, Vadim Bodrov                    *)
(*                                                              *)
(****************************************************************)
unit Crt;
{$w+,r-,q-,i-,t-,x+,v-,a+,oa+,opt+}
{$system}

interface

const
///////////////////////////////// CRT modes /////////////////////////////////

  BW40          = 0;            // 40x25 B/W on Color Adapter
  CO40          = 1;            // 40x25 Color on Color Adapter
  BW80          = 2;            // 80x25 B/W on Color Adapter
  CO80          = 3;            // 80x25 Color on Color Adapter
  Mono          = 7;            // 80x25 on Monochrome Adapter
  Font8x8       = 256;          // Add-in for 8x8 font

///////////////// Foreground and background color constants /////////////////

  Black         = 0;
  Blue          = 1;
  Green         = 2;
  Cyan          = 3;
  Red           = 4;
  Magenta       = 5;
  Brown         = 6;
  LightGray     = 7;

///////////////////////// Foreground color constants ////////////////////////

  DarkGray      = 8;
  LightBlue     = 9;
  LightGreen    = 10;
  LightCyan     = 11;
  LightRed      = 12;
  LightMagenta  = 13;
  Yellow        = 14;
  White         = 15;

  Blink         = 128;          // Add-in for blinking

/////////////////////////// Interface variables /////////////////////////////

const
  CheckBreak: Boolean = True;   // Enable Ctrl-Break
  CheckEOF: Boolean = False;    // Allow Ctrl-Z for EOF?
  TextAttr: Byte = LightGray;   // Current text attribute

var
  LastMode: Word;               // Current text mode
  WindMin:  Word;               // Window upper left coordinates
  WindMax:  Word;               // Window lower right coordinates

const
  DirectVideo: Boolean = True;  // Enable direct video addressing
  CheckSnow:   Boolean = False; // Enable snow filtering (not used)

/////////////////////////// Interface procedures ////////////////////////////

procedure HideCursor;
procedure ShowCursor;
procedure AssignCrt(var F: Text);
function  KeyPressed: Boolean;
function  ReadKey: Char;
{$ifdef __WIN32__}
procedure SetScreenSize(Cols, Rows: DWord);
procedure SetTextAttr(Attr: DWord);
{$endif}
procedure TextMode(Mode: LongInt);
procedure Window(X1, Y1, X2, Y2: Byte);
procedure GotoXY(X, Y: Byte);
function  WhereX: Byte;
function  WhereY: Byte;
procedure ClrScr;
procedure ClrEol;
procedure InsLine;
procedure DelLine;
procedure TextColor(Color: Byte);
procedure TextBackground(Color: Byte);
procedure LowVideo;
procedure HighVideo;
procedure NormVideo;
procedure Delay(MS: Longint);
procedure Sound(Hz: DWord);
procedure NoSound;
procedure PlaySound(Freq, Duration: Longint);
function  GetCharXY(X, Y: Longint): Char;
procedure WriteAttr(X, Y: Longint; Var _s; Len: Longint);

implementation

uses SysIO32, Dos, Strings {$ifdef __OS2__}, DosCall, Os2Types{$endif} {$ifdef __WIN32__}, Messages, Windows, ZenTimer{$endif};

const
  legal_modes   = [BW40, CO40, BW80, CO80, Mono];

var
  NormAttr:   Byte;
  DelayCount: Longint;

procedure SetWindowPos; forward;

{$ifdef __OS2__}
{$system}
var
  VioMode      : VioModeInfo;
  PreviousAttr : Word := 0;

const
  ScanCode: Byte = 0;

type
  Cell = packed record
    Ch:  Char;
    Atr: Byte
  end;

procedure HideCursor;
var
  CurData: VioCursorInfo;
begin
  Vio16GetCurType(CurData, 0);
  if CurData.Attr <> $FFFF then
    PreviousAttr := CurData.Attr;
  CurData.Attr := $FFFF;
  Vio16SetCurType(CurData, 0);
end;

procedure ShowCursor;
var CurData: VioCursorInfo;
begin
  Vio16GetCurType(CurData, 0);
  CurData.Attr := PreviousAttr;
  Vio16SetCurType(CurData, 0);
end;

{ Determines if a key has been pressed on the keyboard and returns True }
{ if a key has been pressed                                             }
function KeyPressed: Boolean;
var
  Key: KbdKeyInfo;
begin
  Kbd16Peek(Key,0);
  KeyPressed := (ScanCode <> 0) or ((Key.fbStatus and kbdtrf_Final_Char_In) <> 0);
end;

{ Reads a character from the keyboard and returns a character or an }
{ extended scan code.                                               }
function ReadKey: Char;
var
  Key: KbdKeyInfo;
begin
  If ScanCode <> 0 then
  begin
    ReadKey  := Chr(ScanCode);
    ScanCode := 0;
  end
 else
  begin
    Kbd16CharIn(Key,io_Wait,0);
    case Key.chChar of
      chr(0): ScanCode := Key.chScan;
      chr($E0):
        if Key.chScan in
       { Up, Dn, Left Rt Ins Del Home End PgUp PgDn C-Home C-End C-PgUp C-PgDn C-Left C-Right C-Up C-Dn }
        [$48,$50,$4B,$4D,$52,$53,$47, $4F,$49, $51, $77,   $75,  $84,   $76,   $73,   $74,    $8D, $91] then
        begin
          ScanCode := Key.chScan;
          Key.chChar := #0;
        end;
      else;
    end;
    ReadKey := Key.chChar;
  end;
end;

{ Reads normal character attribute }
procedure ReadNormAttr;
var
  Cell,Size: word;
begin
  Size := 2;
  Vio16ReadCellStr(Cell, Size, WhereY-1, WhereX-1, 0);
  NormAttr := Hi(Cell) and $7F;
  NormVideo;
end;

{ Stores current video mode in LastMode }
procedure GetLastMode;
begin
  VioMode.cb := SizeOf(VioMode);
  Vio16GetMode(VioMode, 0);
  with VioMode do
  begin
    if Col = 40 then
      LastMode := BW40
    else
      LastMode := BW80;
    if (fbType and vgmt_DisableBurst) = 0 then
      if LastMode = BW40 then
        LastMode := CO40
      else
        LastMode := CO80;
    if Color = 0 then
      LastMode := Mono;
    if Row > 25 then
      LastMode +:= Font8x8;
  end;
end;

{ Selects a specific text mode. The valid text modes are:               }
{   BW40: 40x25 Black and white                                         }
{   CO40  40x25 Color                                                   }
{   BW80  80x25 Black and white                                         }
{   CO80  80x25 Color                                                   }
{   Mono  80x25 Black and white                                         }
{   Font8x8 (Add-in) 43-/50-line mode                                   }
procedure TextMode(Mode: LongInt);
var
  BiosMode: Byte;
  Cell: Word;
  VideoConfig: VioConfigInfo;
begin
  GetLastMode;
  TextAttr := LightGray;
  BiosMode := Lo(Mode);
  VideoConfig.cb := SizeOf(VideoConfig);
  Vio16GetConfig(0, VideoConfig, 0);
  with VioMode do
  begin
    cb := SizeOf(VioMode);
    fbType := vgmt_Other;
    Color := colors_16;         { Color }
    Row := 25;                  { 80x25 }
    Col := 80;
    VRes := 400;
    HRes := 720;
    case BiosMode of            { 40x25 }
      BW40,CO40:
        begin
          Col := 40;
          HRes := 360;
        end;
    end;
    if (Mode and Font8x8) <> 0 then
    case VideoConfig.Adapter of { 80x43 }
      display_Monochrome..display_CGA: ;
      display_EGA:
        begin
          Row := 43;
          VRes := 350;
          HRes := 640;
        end;
      else                      { 80x50 }
        begin
          Row := 50;
          VRes := 400;
          HRes := 720;
        end;
    end;
    case BiosMode of            { Black and white }
      BW40,BW80: fbType := vgmt_Other + vgmt_DisableBurst;
      Mono:
        begin                   { Monochrome }
          HRes := 720;
          VRes := 350;
          Color := 0;
          fbType := 0;
        end;
    end;
  end;
  Vio16SetMode(VioMode, 0);
  Vio16GetMode(VioMode, 0);
  NormVideo;
  SetWindowPos;
  Cell := Ord(' ') + TextAttr shl 8;    { Clear entire screen }
  Vio16ScrollUp(0, 0, 65535, 65535, 65535, Cell, 0);
end;

{ Clears the screen and returns the cursor to the upper-left corner }
procedure ClrScr;
var
  Cell: Word;
begin
  Cell := Ord(' ') + TextAttr shl 8;
  Vio16ScrollUp(Hi(WindMin), Lo(WindMin), Hi(WindMax), Lo(WindMax),
    Hi(WindMax) - Hi(WindMin) + 1, Cell, 0);
  GotoXY(1, 1);
end;

{ Clears all characters from the cursor position to the end of the line }
{ without moving the cursor                                             }
procedure ClrEol;
var
  Cell, X, Y: Word;
begin
  Cell := Ord(' ') + TextAttr shl 8;
  Vio16GetCurPos(Y, X, 0);
  Vio16ScrollUp(Y, X, Y, Lo(WindMax), 1, Cell, 0);
end;

{ Inserts an empty line at the cursor position }
procedure InsLine;
var
  Cell, X, Y: Word;
begin
  Cell := Ord(' ') + TextAttr shl 8;
  Vio16GetCurPos(Y, X, 0);
  Vio16ScrollDn(Y, Lo(WindMin), Hi(WindMax), Lo(WindMax), 1, Cell, 0);
end;

{ Deletes the line containing the cursor }
procedure DelLine;
var
  Cell, X, Y: Word;
begin
  Cell := Ord(' ') + TextAttr shl 8;
  Vio16GetCurPos(Y, X, 0);
  Vio16ScrollUp(Y, Lo(WindMin), Hi(WindMax), Lo(WindMax), 1, Cell, 0);
end;

{ Selects the foreground character color }
procedure TextColor(Color: Byte);
begin
  if Color > White then Color := (Color and $0F) or $80;
  TextAttr := (TextAttr and $70) or Color;
end;

procedure TextBackground(Color: Byte);
begin
  TextAttr := (TextAttr and $8F) or ((Color and $07) shl 4);
end;

procedure LowVideo;
begin
  TextAttr := TextAttr and $F7;
end;

procedure NormVideo;
begin
  TextAttr := NormAttr;
end;

procedure HighVideo;
begin
  TextAttr := TextAttr or $08;
end;

procedure Delay(MS: Longint);
var
  EndValue, Value: DWord;
begin
  if MS >= 5 * 31 then
    DosSleep(MS)
  else begin
    DosQuerySysInfo(qsv_Ms_Count, qsv_Ms_Count, EndValue, 4);
    EndValue +:= MS;
    repeat
      DosQuerySysInfo(qsv_Ms_Count, qsv_Ms_Count, Value, 4);
    until Value >= EndValue;
  end;
end;

{ Plays sound of a specified frequency and duration }
procedure Sound(Hz: DWord);
begin
  (* Do nothing *)
end;

procedure NoSound;
begin
  (* Do nothing *)
end;

procedure PlaySound(Freq, Duration: Longint);
begin
  DosBeep(Freq, Duration);
end;

procedure LineFeed;
var
  Cell: Word;
begin
  Cell := Ord(' ') + TextAttr shl 8;
  Vio16ScrollUp(Hi(WindMin), Lo(WindMin), Hi(WindMax), Lo(WindMax), 1, Cell, 0);
end;

procedure WritePackedString(S: PChar; Len: Longint);
var
  X, Y: Word;
  C:    Char;
  i:    Longint;
begin
  for i := 0 to Len - 1 do
  begin
    C := S[i];
    Vio16GetCurPos(Y, X, 0);
    case C of
      ^J: if Y >= Hi(WindMax) then LineFeed else Y +:= 1;  // Line Feed
      ^M: X := Lo(WindMin);                                // Carriage return
      ^H: if X > Lo(WindMin) then x -:= 1;                 // Backspace
      ^G: Vio16WrtTTY(@C, 1, 0);                           // Bell
    else
      begin
        Vio16WrtCharStrAtt(@C, 1, Y, X, TextAttr, 0);
        x +:= 1;
        if X > Lo(WindMax) then
        begin
          X := Lo(WindMin);
          Y +:= 1;
        end;
        if Y > Hi(WindMax) then
        begin
          LineFeed;
          Y := Hi(WindMax);
        end;
      end;
    end;
    Vio16SetCurPos(Y, X, 0);
  end;
end;

function Crt_Read(f: Longint; aBuf: Pointer; Len: Longint; var Act: Longint): Longint;
const
  buf: String = '';
var
  c  : Char;
  procedure crt_rd_ln;
  begin
    length(buf) := 0;
    while true do
    begin
      repeat
         c := ReadKey;
         if c = #0 then ReadKey;
      until c <> #0;
      case c of
        ^H:
           if Length(buf) <> 0 then
           begin
             WritePackedString(^H' '^H, 3);
             Length(buf) -:= 1;
           end;
        #27:
           while Length(buf) <> 0 do
           begin
             WritePackedString(^H' '^H, 3);
             Length(buf) -:= 1;
           end;
        ' '..#255:
           if Length(buf) <> 253 then
           begin
             Length(buf) +:= 1;
             buf[Length(buf)] := c;
             WritePackedString(@c, 1);
           end;
        else begin
          if (c = ^M) or (c = ^J) or (c = ^Z) and checkEOF then
          begin
            Length(buf) +:= 1;
            buf[Length(buf)] := ^M;
            Length(buf) +:= 1;
            Buf[Length(buf)] := ^J;
            WritePackedString(^M^J, 2);
            exit;
          end;
        end;
      end;
    end;
  end;
begin
  act := 0;
  while len > length (buf) do
  begin
    Move(buf[1], PChar(abuf)[act], Length(buf));
    act +:= Length(buf);
    len -:= Length(buf);
    crt_rd_ln;
  end;
  Move(buf[1], PChar(abuf)[act], len);
  act +:= len;
  Delete(buf, 1, len);
  crt_read := 0;
end;

procedure WriteAttr(X, Y: Longint; var _s; Len: Longint);
var
  s: array [0..1000] of Cell absolute _s;
  i: Longint;
begin
  x -:= 1;
  y -:= 1;
  if x > Lo(WindMax) then
    x := Lo(WindMin);
  if x + len > Lo(WindMax) then
    Len := Lo(WindMax) - x + 1;
  for i := 0 to len - 1 do
  begin
    if not DirectVideo then
      Vio16Setcurpos(Y, X, 0);
    Vio16WrtCharStrAtt(@s[i].ch, 1, Y, X, s[i].atr, 0);
    x +:= 1;
  end;
end;

function GetCharXY(X, Y: Longint): Char;
var
  Ch: Char;
  l:  Word;
begin
  l := 1;
  Vio16ReadCharStr(Ch, l, y - 1, x - 1, 0);
  Result := Ch;
end;

{ CRT text file I/O functions }
function crt_write(f: Longint; Buf: Pointer; Len: Longint; var act: Longint): Longint;
begin
  WritePackedString(Buf, Len);
  act := len;
  crt_write := 0;
end;

procedure AssignCrt(var F: Text);
{$system}
begin
  with TTextRec (f) do
  begin
    Assign(f, '');
    include(state, %file_tty);
    include(state, %file_special);
    // include(state, %file_readable);
    rd_proc := crt_read;
    wr_proc := crt_write;
  end;
end;
{$endif}

{$ifdef __DOS__}
const
  break_flag   : Boolean   = false;
  key_flg      : Boolean   = false;
  key_buf      : Char      = #0;
  delay_count  : Longint   = 0;
  old_exit_proc: procedure = nil;

type
  Cell = packed record
    Ch: Char;
    Atr: Byte
  end;
  vmem  = array [0..100*80-1] of cell;
  pvmem = ^vmem;

  VioModeRec = packed record
    Row, Col: Byte;
    vm: pvmem;
  end;

var
  viomode:  VioModeRec;
  DelayCnt: Longint;

procedure Vio16SetCurPos(y, x: longint; pg: longint); assembler;
      asm
        cmp     [DirectVideo], 0
        jnz     @@UseBIOS
        mov     ax, [LastMode]
        cmp     ax, Mono
        jz      @@UseBIOS
@@Direct:
        xor     ebx, ebx
        mov     edx, 3D4h
        mov     al, 12
        out     dx, al
        inc     edx
        in      al, dx
        mov     byte ptr bh, al
        mov     edx, 3D4h
        mov     al, 13
        out     dx, al
        inc     edx
        in      al, dx
        mov     byte ptr bl, al
        movzx   ecx, byte ptr [viomode.col]
        imul    ecx, [Y]
        add     ecx, [X]
        add     ecx, ebx
        mov     edx, 3D4h
        mov     al, 14
        out     dx, al
        inc     edx
        mov     al, ch
        out     dx, al
        mov     edx, 3D4h
        mov     al, 15
        out     dx, al
        inc     edx
        mov     al, cl
        out     dx, al
@@1:    jmp     @@Ok
@@UseBIOS:
        mov     ah, 02h
        xor     ebx, ebx
        mov     bh, byte ptr [pg]
        mov     dh, byte ptr [y]
        mov     dl, byte ptr [x]
        int     10h
@@Ok:
end;

procedure Vio16GetCurPos(var Y, X: Word; pg: Longint); assembler;
      asm
        cmp     [DirectVideo], 0
        jnz     @@UseBIOS
        mov     ax, [LastMode]
        cmp     ax, Mono
        jz      @@UseBIOS
@@Direct:
        mov     edx, 3D4h
        mov     al, 12
        out     dx, al
        inc     edx
        in      al, dx
        mov     byte ptr bh, al
        mov     edx, 3D4h
        mov     al, 13
        out     dx, al
        inc     edx
        in      al, dx
        mov     byte ptr bl, al
        mov     edx, 3D4h
        mov     al, 14
        out     dx, al
        inc     edx
        in      al, dx
        mov     byte ptr ah, al
        mov     edx, 3D4h
        mov     al, 15
        out     dx, al
        inc     edx
        in      al, dx
        movzx   ebx, bx
        movzx   eax, ax
        sub     eax, ebx
        xor     edx, edx
        movzx   ebx, byte ptr [viomode.col]
        div     ebx
        mov     ecx, [Y]
        mov     [ecx], ax
        mov     ecx, [X]
        mov     [ecx], dx
        jmp     @@Ok
@@UseBIOS:
        mov     ah, 03h
        mov     bh, byte ptr [pg]
        int     10h
        xor     eax, eax
        mov     al, dh
        mov     ebx, [Y]
        mov     [ebx], ax
        mov     al, dl
        mov     ebx, [X]
        mov     [ebx], ax
@@Ok:
end;

procedure Vio16ScrollUp(Y1, X1, Y2, X2: Byte; nLines: Longint; Cell: Word; pg: Byte);
var
  X, Y: Longint;
begin
  if not DirectVideo then
  asm
    mov   ah, 06h
    mov   bh, byte ptr [Cell+1]
    mov   al, byte ptr [nLines]
    mov   cl, byte ptr [X1]
    mov   ch, byte ptr [Y1]
    mov   dl, byte ptr [X2]
    mov   dh, byte ptr [Y2]
    int   10h
  end else
    with viomode do
    begin
      for Y := Y1 to Y2 - nLines do
        Move(vm^[(Y + nLines) * Col + X1], vm^[Y * Col + X1], (X2 - X1 + 1) * 2);
      for Y := Y2 - nLines + 1 to Y2 do
        for X := X1 to X2 do
           Word(vm^[Y * Col + X]) := Cell;
    end;
end;

procedure Vio16ScrollDn(Y1, X1, Y2, X2: Byte; nLines: Longint; Cell: Word; pg: Byte);
var
  X, Y: Longint;
begin
  if not DirectVideo then
  asm
    mov   ah, 07h
    mov   bh, byte ptr [Cell+1]
    mov   al, byte ptr [nLines]
    mov   cl, byte ptr [X1]
    mov   ch, byte ptr [Y1]
    mov   dl, byte ptr [X2]
    mov   dh, byte ptr [Y2]
    int   10h
  end else
    with viomode do
    begin
      for Y := Y2 downto Y1 + nLines do
        Move(vm^[(Y - nLines) * Col + X1], vm^[Y * Col + X1], (X2 - X1) * 2);
      for Y := Y1 to Y1 + nLines-1 do
          for X := X1 to X2 do
              Word(vm^[Y * Col + X]) := Cell;
    end;
end;

procedure Vio16WrtCharStrAtt(s: PChar; l, Y, X, Atr, pg: Longint);
begin
  if DirectVideo then
    with viomode do
    asm
      mov   eax, [Y]
      mul   [viomode.Col]
      add   eax, [X]
      mov   edi, [viomode.vm]
      add   edi, eax
      add   edi, eax
      mov   esi, [s]
      mov   ah,  byte ptr Atr
      mov   ecx, [l]
      jecxz @@ret
@@loop:
      lodsb
      stosw
      loop  @@loop
@@ret:
    end
  else
  Declare
    var r: Registers;
    with r do begin
      ax := $1300;
      bh := 0;
      bl := Atr;
      cx := l;
      dh := Y;
      dl := X;
      es := buf_16;
      bp := 0;
      ss := 0;
      sp := 0;
      Move(s^, PChar(buf_32)^, l);
      Intr($10, r);
    end;
end;

procedure HideCursor; code;
      asm
        push    ebx
        push    ecx
        mov     eax, 100h
        xor     ebx, ebx
        mov     ecx, 2000h
        int     10h
        pop     ecx
        pop     ebx
        ret
end;

procedure ShowCursor; code;
      asm
        push    ebx
        push    ecx
        mov     eax, 100h
        xor     ebx, ebx
        mov     ecx, 607h
        int     10h
        pop     ecx
        pop     ebx
        ret
end;

procedure break_handler; interrupt;
begin
  if checkbreak then
    break_flag := true;
end;

procedure break_test;
begin
  if break_flag then
  begin
    Writeln('^C');
    Halt(255);
  end;
end;

procedure Dos_WChar(c: char); assembler;
      asm
        mov     dl, [c];
        mov     ah, $06;
        int     $21;
end;

function GetCharXY(X, Y: Longint): Char;
var
  LX, LY: Longint;
begin
  if DirectVideo then
  begin
    x -:= 1;
    y -:= 1;
    asm
      mov   eax, [Y]
      mul   [viomode.Col]
      add   eax, [X]
      mov   edi, [viomode.vm]
      add   edi, eax
      add   edi, eax
      mov   al, [edi]
      mov   @Result, al
    end;
  end else begin
    LX := WhereX;
    LY := WhereY;
    GotoXY(X, Y);
    asm
      mov   eax, 800h
      xor   ebx, ebx
      int   10h
      mov   @Result, al
    end;
    GotoXY(LX, LY);
  end;
end;

procedure LineFeed;
var
  Cell: word;
begin
  Cell := Ord(' ') + TextAttr shl 8;
  Vio16ScrollUp(Hi(WindMin), Lo(WindMin), Hi(WindMax), Lo(WindMax), 1, Cell, 0);
end;

{ Outputs packed string to the CRT device }
procedure WritePackedString(S: PChar; Len: Longint);
var
  X, Y: Word;
  i: Longint;
begin
  Vio16GetCurPos(Y, X, 0);
  i := 0;
  while i <> Len do
  Declare
    var
      C: Char := S [i];
      l: Longint := 1;
    begin
      case C of
        ^J: if Y >= Hi(WindMax) then LineFeed else Y +:= 1; // Line Feed
        ^M: X := Lo(WindMin);                               // Carriage return
        ^H: if X > Lo(WindMin) then X -:= 1;                // Backspace
        ^G: Dos_WChar (c);                                  // Bell
      else
        while (i + l <> Len) and (x + l < Lo(WindMax)) and not (s[i+l] in [^J, ^M, ^H, ^G]) do
          l +:= 1;
        Vio16WrtCharStrAtt(s+i,l,Y,X,TextAttr,0);
        X +:= l;
        if X > Lo(WindMax) then
        begin
          X := Lo(WindMin);
          Y +:= 1;
        end;
        if Y > Hi(WindMax) then
        begin
          linefeed;
          Y := Hi(WindMax);
        end;
      end;
      i +:= l;
    end;
    Vio16SetCurPos(Y, X, 0);
end;

procedure WriteAttr(X, Y: Longint; var _s; Len: Longint);
var
  s: array [0..1000] of Cell absolute _s;
  i: Longint;
begin
  X -:= 1;
  Y -:= 1;
  if x > Lo(WindMax) then
    x := Lo(WindMin);
  if x + len > Lo(WindMax) then
    len := Lo(WindMax) - x + 1;
  for i := 0 to len - 1 do
  begin
    if not directvideo then
      Vio16SetCurPos(Y, X, 0);
    Vio16WrtCharStrAtt(@s[i].ch, 1, Y, X, s[i].Atr, 0);
    X +:= 1;
  end;
end;

function crt_read(f: Longint; aBuf: Pointer; Len: Longint; var Act: Longint): Longint;
const
  buf: string = '';
var
  i: Longint;
  c: Char;
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
        ^H:
           if Length(buf) <> 0 then
           begin
             WritePackedString(^H' '^H, 3);
             Length(buf) -:= 1;
           end;
        #27:
           while Length(buf) <> 0 do
           begin
             WritePackedString(^H' '^H, 3);
             Length(buf) -:= 1;
           end;
         ' '..#255:
           if Length(buf) <> 253 then
           begin
             Length(buf) +:= 1;
             buf[Length(buf)] := c;
             WritePackedString(@c, 1);
           end;
      else
        if (c = ^M) or (c = ^J) or (c = ^Z) and checkEOF then
        begin
          Length(buf) +:= 1;
          buf[Length(buf)] := ^M;
          Length(buf) +:= 1;
          buf[Length(buf)] := ^J;
          WritePackedString(^M^J, 2);
          exit;
        end;
      end
    end
  end;
begin
  act := 0;
  while len > length (buf) do
  begin
    Move(buf[1], PChar(aBuf)[Act], Length(buf));
    Act +:= Length(buf);
    Len -:= Length(buf);
    crt_rd_ln;
  end;
  Move(buf[1], PChar(aBuf)[act], Len);
  Act +:= Len;
  Delete(buf, 1, Len);
  crt_read := 0;
end;

function crt_write(f: Longint; buf: Pointer; len: Longint; var Act: Longint): Longint;
begin
  WritePackedString(buf, len);
  act := len;
  crt_write := 0;
end;

procedure AssignCrt(var F: Text);
begin
{$system}
  with TTextRec (f) do begin
    Assign(f, '');
    Include(state, %file_tty);
    Include(state, %file_special);
    rd_proc := crt_read;
    wr_proc := crt_write;
  end;
end;

function KeyPressed: Boolean; code;
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

function ReadKey: Char; code;
      asm
        cmp     [key_flg], 0
        je      @@1
        mov     [key_flg], 0
        mov     al, [key_buf]
        jmp     @@ret
@@1:
        xor     eax, eax
        int     16h
        or      al, al
        jne     @@ret
        mov     [key_buf], ah
        inc     [key_flg]
@@ret:
        push    eax
        call    break_test
        pop     eax
        ret
end;

procedure ClrScr;
var
  Cell: Word := Ord(' ') + TextAttr shl 8;
begin
  Vio16ScrollUp(Hi(WindMin), Lo(WindMin), Hi(WindMax), Lo(WindMax),
    Hi(WindMax) - Hi(WindMin) + 1, Cell, 0);
  GotoXY(1, 1);
end;

procedure ClrEol;
var
  Cell: Word := Ord(' ') + TextAttr shl 8;
  X, Y: Word;
begin
  Vio16GetCurPos(Y, X, 0);
  Vio16ScrollUp(Y, X, Y, Lo(WindMax), 1, Cell, 0);
end;

procedure InsLine;
var
  Cell: Word := Ord(' ') + TextAttr shl 8;
  X, Y: Word;
begin
  Vio16GetCurPos(Y, X, 0);
  Vio16ScrollDn(Y, Lo(WindMin), Hi(WindMax), Lo(WindMax), 1, Cell, 0);
end;

procedure DelLine;
var
  Cell: Word;
  X, Y: Word;
begin
  Cell := Ord(' ') + TextAttr shl 8;
  Vio16GetCurPos(Y, X, 0);
  Vio16ScrollUp(Y, Lo(WindMin), Hi(WindMax), Lo(WindMax), 1, Cell, 0);
end;

procedure DelayLoop; code;
asm
   @Loop1:
   sub   eax,1
   jc    @Done
   cmp   ebx,[edi]
   je    @Loop1
   @Done:
   ret
end;

procedure InitDelay; code;
asm
   pushad
   mov   edi,46ch
   mov   edx,-28
   mov   ebx,[edi]
   @Loop1:
   cmp   ebx,[edi]
   je    @Loop1
   mov   ebx,[edi]
   mov   eax,edx
   call  DelayLoop
   not   eax
   xor   edx,edx
   mov   ecx,55h
   div   ecx
   mov   DelayCnt,eax
   popad
   ret
end;

procedure Delay; assembler;
asm
   pushad
   mov   ecx,MS
   jecxz @Done
   mov   edi,400h
   mov   edx,DelayCnt
   mov   ebx,[edi]
   @Loop1:
   mov   eax,edx
   call  DelayLoop
   loop  @Loop1
   @Done:
   popad
end;

procedure Sound(Hz: DWord); assembler;
      asm
        mov     ebx, [hz]
        cmp     ebx, 12h
        jbe     @l2
        mov     eax, 1234DDh
        xor     edx, edx
        div     ebx
        mov     ebx, eax
        in      al, 61h
        test    al, 3
        jne     @l1
        or      al, 3
        out     61h, al
        mov     al,  0B6h
        out     43h, al
@l1:
        mov     al, bl
        out     42h, al
        mov     al, bh
        out     42h ,al
@l2:
end;

procedure NoSound; assembler;
      asm
        in      al, 61h
        and     al, 0FCh
        out     61h, al
end;

procedure PlaySound(Freq, Duration: Longint);
begin
  Sound(Freq);
  Delay(Duration);
  NoSound;
end;

procedure TextColor(Color: Byte);
begin
  if Color > White then
    Color := (Color and $0F) or $80;
  TextAttr := (TextAttr and $70) or Color;
end;

procedure ReadNormAttr;
begin
  with viomode do
    normattr := vm^[pred(WhereY) * Col + Pred(WhereX)].atr and $7F;
  NormVideo;
end;

procedure GetLastMode;
begin
  with viomode do
  begin
    LastMode := Mem[$449];
    col := MemW[$44a];
    declare
    var
      r: Registers;
    with r do
    begin
      ax := $1130;
      bh := $00;
      dl := $00;
      Intr($10, r);
      if dl <> 0 then
      begin
        if dl > 24 then LastMode := LastMode + Font8x8;
        row := dl + 1;
      end else
        row := 24;
    end;
    vm := Pointer($B8000 + MemW[$44E]);
    if LastMode = Mono then dec(vm, $8000);
  end;
end;

procedure TextMode(Mode: Longint);
begin
  if Byte(Mode) in legal_modes then
  begin
      asm
        mov     al, byte ptr Mode
        mov     ah, 0
        int     10h
        cmp     byte ptr [Mode + 1], 0
        je      @@2
        mov     eax, 1112h
        mov     bl, 0
        push   esi edi ebp es
        int    10h
        pop    es ebp edi esi
    @@2:
    end;
    GetLastMode;
    SetWindowPos;
  end;
end;

procedure LowVideo;
begin
  TextAttr := TextAttr and $F7;
end;

procedure NormVideo;
begin
  TextAttr := NormAttr;
end;

procedure HighVideo;
begin
  TextAttr := TextAttr or $08;
end;

procedure TextBackground(Color: Byte);
begin
  TextAttr := (TextAttr and $8F) or ((Color and $07) shl 4);
end;

procedure restore_crt;
var
  X, Y: Word;
begin
  ExitProcedure := old_exit_proc;
  Vio16GetCurPos(X, Y, 0);
  DirectVideo := false;
  Vio16SetCurPos(X, Y, 0);
  NormVideo;
  TTextRec(input).rd_proc := %normal_read;
  TTextRec(output).wr_proc := %normal_write;
end;
{$endif}

{$ifdef __WIN32__}
const
  break_flag:    Boolean   = false;
  key_flg:       Boolean   = false;
  key_buf:       Char      = #0;
  old_exit_proc: procedure = nil;

type
  VioModeRec = packed record
    Row, Col: Byte;
  end;

  Cell = packed record
    Ch:  Char;
    Atr: Byte
  end;

var
  ScanCode: Word;
  Mode:     DWORD := 0;
  GlobalX:  DWord := 0;
  GlobalY:  DWord := 0;
  viomode:  VioModeRec;

procedure Vio16SetCurPos(Y, X: LongInt; pg: LongInt);
var
  Coord: TCoord;
begin
  Coord.X := Word(X);
  Coord.Y := Word(Y);
  SetConsoleCursorPosition (TTextRec(output).handle, Coord);
end;

procedure Vio16GetCurPos(var Y, X: DWord; Pg: Longint);
var
  si: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo (TTextRec(output).handle, si);
  X := si.dwCursorPosition.X;
  Y := si.dwCursorPosition.Y;
end;

procedure Vio16ScrollUp(y1, x1, y2, x2: Word; nlins: longint; cell: dword; pg: byte);
var
  sRect: TSmallRect;
  dCoord: TCoord;
  ci: TCharInfo;
begin
  sRect.Left   := x1;
  sRect.Top    := y1;
  sRect.Right  := x2;
  sRect.Bottom := y2;
  dCoord.X := x1;
  dCoord.Y := y1 - nlins;
  ci.AsciiChar  := Char(cell);
  ci.Attributes := Word(cell shr 8);
  ScrollConsoleScreenBuffer (TTextRec(output).handle, sRect, sRect {!}, dCoord, ci);
end;

procedure Vio16ScrollDn(y1, x1, y2, x2: Word; nlins: longint; cell: Dword; pg: byte);
var
  sRect: TSmallRect;
  dCoord: TCoord;
  ci: TCharInfo;
begin
  sRect.Left   := x1;
  sRect.Top    := y1;
  sRect.Right  := x2;
  sRect.Bottom := y2;
  dCoord.X := x1;
  dCoord.Y := y1 + nlins;
  ci.AsciiChar  := Char(cell);
  ci.Attributes := Word(cell shr 8);
  ScrollConsoleScreenBuffer (TTextRec(output).handle, sRect, sRect {!}, dCoord, ci);
end;

procedure Vio16WrtCharStrAtt(s: pchar; l, y, x, atr, pg: longint);
var
  act: DWord;
  coord: TCoord;
begin
  coord.X := X;
  coord.Y := Y;
  WriteConsoleOutputCharacter(TTextRec(output).handle, s, l, coord, act);
  FillConsoleOutputAttribute(TTextRec(output).handle, atr, l, coord, act);
end;

procedure HideCursor;
var
  ci: TConsoleCursorInfo;
begin
  GetConsoleCursorInfo(TTextRec(output).handle, ci);
  ci.bVisible := False;
  SetConsoleCursorInfo(TTextRec(output).handle, ci);
end;

procedure ShowCursor;
var
  ci: TConsoleCursorInfo;
begin
  GetConsoleCursorInfo(TTextRec(output).handle, ci);
  ci.bVisible := True;
  SetConsoleCursorInfo(TtextRec(output).handle, ci);
end;

procedure LineFeed;
var
  Cell: word;
begin
  Cell := Ord(' ') + TextAttr shl 8;
  Vio16ScrollUp(Hi(WindMin), Lo(WindMin), Hi(WindMax), Lo(WindMax), 1, Cell, 0);
end;

{ Outputs packed string to the CRT device }
procedure WritePackedString(S: PChar; Len: Longint);
var
  X, Y: DWord;
  i: Longint := 0;
begin
  if DirectVideo then
  begin
    X := GlobalX;
    Y := GlobalY;
  end else
    Vio16GetCurPos(Y,X,0);
  while i <> len do
  Declare
    var
      C: Char := S [i];
      l: Longint := 1;
    begin
    case C of
      ^J: begin
            if Y >= Hi(WindMax) then LineFeed else y +:= 1;
            Vio16SetCurPos(Y,X,0);
          end;
      ^M: X := Lo(WindMin);
      ^H: if X > Lo(WindMin) then
          begin
            X -:= 1;
            Vio16SetCurPos(Y, X, 0);
          end;
    else
      while (i + l <> Len) and (x + l < Lo(WindMax)) and not (s[i+l] in [^J, ^M, ^H, ^G]) do
        l +:= 1;
    WriteConsole(TTextRec(output).handle, Pointer(DWord(s+i)), l, DWord(l), nil);
    X +:= l;
    if X > Lo(WindMax) then
    begin
      X := Lo(WindMin);
      Y +:= 1;
      if Y > Hi(WindMax) then
      begin
        LineFeed;
        Y := Hi(WindMax);
      end;
      Vio16SetCurPos(Y, X, 0);
    end;
  end;
  i +:= l;
  end;
  GlobalX := X;
  GlobalY := Y;
end;

procedure WriteAttr(X, Y: Longint; var _s; Len: Longint);
var
  s: array [0..1000] of cell absolute _s;
  i: Longint;
begin
  X -:= 1;
  Y -:= 1;
  if x > Lo(WindMax) then
    x := Lo(WindMin);
  if x + Len > Lo(WindMax) then
    Len := Lo(WindMax) - X + 1;
  for i := 0 to Len - 1 do
  begin
    if not DirectVideo then
      Vio16SetCurPos(Y, X, 0);
    Vio16WrtCharStrAtt(@s [i].ch, 1, Y, X, s[i].atr, 0);
    X +:= 1;
  end;
end;

function GetCharXY(X, Y: Longint): Char;
var
  Ch: Char;
  Coord: TCoord;
  Act: DWord;
begin
  Coord.X := X - 1;
  Coord.Y := Y - 1;
  ReadConsoleOutputCharacter(TTextRec(output).handle, @Ch, 1, Coord, Act);
  Result := Ch;
end;

function crt_read(f: Longint; aBuf: Pointer; len: Longint; var Act: Longint): Longint;
var
  i: Longint;
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
        ^H:
           if Length(buf) <> 0 then
           begin
             WritePackedString(^H' '^H, 3);
             Length(buf) -:= 1;
           end;
        #27:
           while Length(buf) <> 0 do
           begin
             WritePackedString(^H' '^H, 3);
             Length(buf) -:= 1;
           end;
        ' '..#255:
           if Length(buf) <> 253 then
           begin
             Length(buf) +:= 1;
             buf[Length(buf)] := c;
             WritePackedString(@c, 1);
           end;
        else
             if (c = ^M) or (c = ^J) or (c = ^Z) and checkEOF then
             begin
               Length(buf) +:= 1;
               buf[Length(buf)] := ^M;
               Length(buf) +:= 1;
               Buf[Length(buf)] := ^J;
               WritePackedString(^M^J, 2);
               exit;
             end;
      end;
    end;
  end;
begin
  act := 0;
  if DirectVideo then Vio16GetCurPos(GlobalY, GlobalX, 0);
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
  crt_read := 0;
end;

function crt_write(f: Longint; buf: Pointer; len: Longint; var Act: Longint): Longint;
begin
  WritePackedString(buf, len);
  act := len;
  crt_write := 0;
end;

procedure AssignCrt(var F: Text);
{$system}
begin
  with TTextRec(f) do begin
   Assign(f, 'CON');
   Include(state, %file_tty);
   Include(state, %file_special);
   rd_proc := crt_read; //TTextRec(input).rd_proc;
   wr_proc := TTextRec(output).wr_proc;
  end;
end;

{$system}
function KeyPressed: Boolean;
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
      KeyPressed := %KeyNumber > 0;
    end;
  end;
end;

function ReadKey: Char;
begin
  if not %InGraph then
  begin
    repeat
      if thKbPtr = 0 then WaitForSingleObject(thKbdFlag, INFINITE);
    until thKbPtr > 0;
    dec(thKbPtr);
    Result := thKbCBuf[thKbPtr];
  end else
  begin
    if not KeyPressed then
    begin
      repeat WaitMessage until KeyPressed;
    end;
    ReadKey := %KeyBuffer[0];
    %KeyNumber -:= 1;
    Move(%KeyBuffer[1], %KeyBuffer[0], %KeyNumber);
  end;
end;

procedure ClrScr;
var
  act, l, i: DWord;
  Coord: TCoord;
begin
  l := LongInt(Lo(WindMax)) - LongInt(Lo(WindMin)) + 1;
  Coord.X := Word(Lo(WindMin));
  for i := DWord(Hi(WindMin)) to DWord(Hi(WindMax)) do
  begin
    Coord.Y := i;
    FillConsoleOutputAttribute(TTextRec(output).handle, TextAttr, l, Coord, act);
    FillConsoleOutputCharacter(TTextRec(output).handle, ' ', l, Coord, act);
  end;
  GotoXY(1, 1);
end;

procedure ClrEol;
var
  X, Y: DWord;
  act: DWORD;
  Coord: TCoord;
begin
  if DirectVideo then
  begin
    X := GlobalX;
    Y := GlobalY;
  end else
    Vio16GetCurPos(Y, X, 0);

  Coord.X := X;
  Coord.Y := Y;
  FillConsoleOutputAttribute(TTextRec(output).handle, TextAttr, 1 + Lo(WindMax) - x, Coord, act);
  FillConsoleOutputCharacter(TTextRec(output).handle, ' ', 1 + Lo(WindMax) - x, Coord, act);
end;

procedure InsLine;
var
  Cell: Word := Ord(' ') + TextAttr shl 8;
  X, Y: DWord;
begin
  if DirectVideo then
  begin
    X := GlobalX;
    Y := GlobalY;
  end else
    Vio16GetCurPos(Y, X, 0);
  Vio16ScrollDn(Y, Lo(WindMin), Hi(WindMax), Lo(WindMax), 1, Cell, 0);
end;

procedure DelLine;
var
  Cell: Word := Ord(' ') + TextAttr shl 8;
  X, Y: DWord;
begin
  if directvideo then
  begin
    X := GlobalX;
    Y := GlobalY;
  end else
    Vio16GetCurPos(Y, X, 0);
  Vio16ScrollUp(Y, Lo(WindMin), Hi(WindMax), Lo(WindMax), 1, Cell, 0);
end;

procedure Delay;
begin
  if isConsole then
    Sleep(MS)
  else
    ULZDelay(MS);
end;

procedure Sound(Hz: DWord);           // Windows NT only
begin
  Beep(hz, -1);
end;

procedure NoSound;                    // Windows NT only
begin
  Beep(37, 0);
end;

procedure PlaySound(Freq, Duration: Longint);  // Windows NT only
begin
  Beep(Freq, Duration);
end;

procedure ReadNormAttr;
var si: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo(TTextRec(output).handle, si);
  NormAttr := Byte(si.wAttributes);
  NormVideo;
end;

procedure GetModeInfo;
var
  si: TConsoleScreenBufferInfo;
begin
 GetConsoleScreenBufferInfo(TTextRec(output).handle, si);
 VioMode.Col := si.dwSize.X;
 VioMode.Row := si.dwSize.Y;
end;

procedure GetLastMode;
var
  si: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo (TTextRec(output).handle, si);
  if si.dwSize.X = 40 then
    LastMode := CO40
  else
    LastMode := CO80;
  if si.dwSize.Y > 25 then
    LastMode := LastMode or Font8x8;
end;

procedure SetScreenSize(Cols, Rows: DWord);
var
  Coord: TCoord;
begin
  GetLastMode;
  Coord.X := Cols;
  Coord.Y := Rows;
  SetConsoleScreenBufferSize(TTextRec(output).handle, Coord);
  TextAttr := LightGray;
  NormVideo;
  GetModeInfo;
  SetWindowPos;
  ClrScr;
end;

procedure TextMode(Mode: LongInt);
var
  Cols, Rows: DWord;
begin
  case (Mode and $FF) of
    BW40: begin Cols := 40; Rows := 25; end;
    CO40: begin Cols := 40; Rows := 25; end;
    BW80: begin Cols := 80; Rows := 25; end;
    CO80: begin Cols := 80; Rows := 25; end;
    Mono: begin Cols := 80; Rows := 25; end;
  end;
  if (Mode and Font8x8) <> 0 then Rows := 50; // (Add-in) 50-line mode
  SetScreenSize(Cols, Rows);
end;

procedure LowVideo;
var
  csi: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo(TTextRec(output).handle, csi);
  TextAttr := csi.wAttributes and $F7;
  SetConsoleTextAttribute(TTextRec(output).handle, TextAttr);
end;

procedure NormVideo;
var
  csi: TConsoleScreenBufferInfo;
begin
 TextAttr := NormAttr;
 SetConsoleTextAttribute(TTextRec(output).handle, TextAttr);
end;

procedure HighVideo;
var
  csi: TConsoleScreenBufferInfo;
begin
 GetConsoleScreenBufferInfo(TTextRec(output).handle, csi);
 TextAttr := csi.wAttributes or $08;
 SetConsoleTextAttribute(TTextRec(output).handle, TextAttr);
end;

procedure SetTextAttr(Attr: DWord);
begin
  SetConsoleTextAttribute(TTextRec(output).handle, (Attr and $0F) + ((Attr and $F0) shl 4));
end;

procedure TextBackground(Color: Byte);
var
  csi: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo(TTextRec(output).handle, csi);
  TextAttr := (csi.wAttributes and $8F) or (Word(Color and $07) shl 4);
  SetConsoleTextAttribute(TTextRec(output).handle, Word(TextAttr));
end;

procedure TextColor(Color: Byte);
var
  csi: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo(TtextRec(output).handle, csi);
  TextAttr := csi.wAttributes;
  if Color > White then
    Color := (Color and $0F) or $80;
  TextAttr := (TextAttr and $70) or Color;
  SetConsoleTextAttribute(TTextRec(output).handle, Word(TextAttr));
end;

function CtrlHandlerProc conv arg_stdcall(dwCtrlType: DWord): LongBool;
begin
  if CheckBreak then begin
    Writeln('^C');
    Result := False;
   end else
    Result := True;
end;

procedure restore_crt;
var
  X, Y: DWord;
begin
  if isConsole then
  begin
    Vio16GetCurPos(X, Y, 0);
    DirectVideo := false;
    Vio16SetCurPos(X, Y, 0);
    NormVideo;
    SetConsoleCtrlHandler(@CtrlHandlerProc, false);
    ExitProcedure := old_exit_proc;
  end;
end;
{$endif}

/////////////////////////////////// Common //////////////////////////////////
{ Setups window coordinates }
procedure SetWindowPos;
begin
  WindMin := 0;
  WindMax := VioMode.Col - 1 + (VioMode.Row - 1) shl 8;
end;

{Moves the cursor to the given coordinates within the virtual screen }
procedure GotoXY(X, Y: Byte);
begin
  if (X > 0) and (Y > 0) then begin
    X +:= Lo(WindMin) - 1;
    Y +:= Hi(WindMin) - 1;
    if (X <= Lo(WindMax)) and (Y <= Hi(WindMax)) then
      Vio16SetCurPos(Y, X ,0);
  end;
{$ifdef __WIN32__}
  GlobalX := X;
  GlobalY := Y;
{$endif}
end;

{ Defines a text window on the screen }
procedure Window(X1, Y1, X2, Y2: Byte);
begin
{$system}
 if (X1 <= X2) and (Y1 <= Y2) then begin
{$ifdef __WIN32__}
  if (X1 = 1) and (Y1 = 1) and (X2 = VioMode.Col) and (Y2 = VioMode.Row) then
  begin
   TTextRec(input).rd_proc :=  crt_read;
   TTextRec(output).wr_proc := %normal_write;
  end else
  begin
   TTextRec(input).rd_proc := crt_read;
   TTextRec(output).wr_proc := crt_write;
  end;
{$endif}
  x1 -:= 1;
  y1 -:= 1;
  if (X1 >= 0) and (Y1 >= 0) then
  begin
   x2 -:= 1;
   y2 -:= 1;
   if (X2 < VioMode.Col) and (Y2 < VioMode.Row) then
   begin
    WindMin := Word(X1) + Word(Y1) shl 8;
    WindMax := Word(X2) + Word(Y2) shl 8;
    GotoXY(1, 1);
   end;
  end;
 end;
end;

{ Returns the X coordinate of the current cursor location }
function WhereX: Byte;
var
{$ifdef __WIN32__}
  X, Y: DWord;
{$else}
  X, Y: Word;
{$endif}
begin
  Vio16GetCurPos(Y, X, 0);
  WhereX := X - Lo(WindMin) + 1;
end;

{ Returns the Y coordinate of the current cursor location }
function WhereY: Byte;
var
{$ifdef __WIN32__}
  X, Y: DWord;
{$else}
  X, Y: Word;
{$endif}
begin
  Vio16GetCurPos(Y, X, 0);
  WhereY := Y - Hi(WindMin) + 1;
end;

/////////////////////////////// Initialization //////////////////////////////
{$ifdef __OS2__}
begin
  GetLastMode;
  if (VioMode.fbType and vgmt_Graphics) <> 0 then TextMode(CO80);
  ReadNormAttr;
  SetWindowPos;
  AssignCrt(Input);
  Reset(Input);
  AssignCrt(Output);
  ReWrite(Output);
{$endif}

{$ifdef __DOS__}
begin
  GetLastMode;
  SetWindowPos;
  ReadNormAttr;
  AssignCrt(output);
  Rewrite(output);
  AssignCrt(input);
  Reset(input);
  InitDelay;
  old_exit_proc := ExitProcedure;
  ExitProcedure := restore_crt;
{$endif}

{$ifdef __WIN32__}
begin
  if isConsole then
  begin
    AssignCRT(input);
    Reset(input);
    AssignCRT(output);
    Rewrite(output);
    SetConsoleActiveScreenBuffer(TTextRec(output).handle);
    GetModeInfo;
    ReadNormAttr;
    GetLastMode;
    SetWindowPos;
    SetConsoleMode(TTextRec(output).handle, ENABLE_PROCESSED_OUTPUT or ENABLE_WRAP_AT_EOL_OUTPUT);
    GetConsoleMode(TTextRec(input).handle, Mode);
    if (Mode and ENABLE_MOUSE_INPUT) <> 0 then
      SetConsoleMode(TTextRec(input).handle, Mode xor ENABLE_MOUSE_INPUT);
    SysAddEvent(KEY_EVENT);
    FlushConsoleInputBuffer(TTextRec(input).handle);
    SetConsoleCtrlHandler(@CtrlHandlerProc, true);
    old_exit_proc := ExitProcedure;
    ExitProcedure := restore_crt;
 end;
{$endif}
end.
