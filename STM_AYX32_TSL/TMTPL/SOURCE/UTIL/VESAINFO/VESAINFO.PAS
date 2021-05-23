(*****************************************************)
(*                                                   *)
(* VESA Info Utility                                 *)
(* Copyright (c) 2000 TMT Development Corporation    *)
(* Written by Vadim Bodrov                           *)
(*                                                   *)
(* Targets:                                          *)
(*   MS-DOS 32-bit protected mode only               *)
(*                                                   *)
(*****************************************************)

program VESAINFO;

uses Keyboard, Strings, Graph;

var
  CommandIndex: Longint := 0;
  Mode: DWORD;
  Command: Char;

function add_s(n: Longint): String;
var
  S: String;
begin
  S := IntToStr(n);
  if Length(S) = 3 then
    Result := S + ' '
  else
    Result := S;
end;

procedure PrintHeader;
begin
  Writeln('VBE Mode    Resolution', #9, '    BPP');
  Writeln('-------------------------------');
end;

procedure ShowVideoModes;
const
  Modes: array[0..4] of Byte =
    (8, 15, 16, 24, 32);
var
  ModesList: array[0..70] of GraphModeType;
  i, j: DWORD;
begin
  GetVbeModesList(ModesList);
  PrintHeader;
  for j := 0 to High(Modes) do
  begin
    for i := 0 to TotalVbeModes - 1 do
    begin
      if ModesList[i].BitsPerPixel = Modes[j] then
        Writeln(IntToHex(ModesList[i].VideoMode, 4), 'h', '    ',
        add_s(ModesList[i].XResolution), ' x ',
        add_s(ModesList[i].YResolution), '    ',
        ModesList[i].BitsPerPixel);
    end;
  end;
end;

procedure ShowModeInfo(ModeNo: DWORD);
var
  VbeModeInfo: VbeModeInfoType;
begin
  GetVbeModeInfo(ModeNo, VbeModeInfo);
  if GraphResult <> grOk then
    Writeln('Video mode not supported.')
  else
  with VbeModeInfo do
  begin
    Writeln('VESA VBE Mode Information Block:');
    Writeln('  Mode Number             ', '0x' + IntToHex(Mode, 4));
    Writeln('  Mode Attributes         ', BinStr(ModeAttributes, 2) + 'b');
    Writeln('  Win A Attributes        ', BinStr(WinAAttributes, 1) + 'b');
    Writeln('  Win B Attributes        ', BinStr(WinBAttributes, 1) + 'b');
    Writeln('  Win Granularity         ', WinGranularity);
    Writeln('  Win Size                ', WinSize);
    Writeln('  Win A RM Segment        ', '0x' + Hex(WinASegment));
    Writeln('  Win B RM Segment        ', '0x' + Hex(WinBSegment));
    Writeln('  Win Func Ptr            ', '0x' + Hex(DWORD(WinFuncPtr)));
    Writeln('  Bytes Per Scan Line     ', BytesPerScanLine);
    // VESA VBE 1.01 and higher
    if GetVbeVersion < $0101 then exit;
    Writeln('  X Resolution            ', XResolution);
    Writeln('  Y Resolution            ', YResolution);
    Writeln('  X CharSize              ', XCharSize);
    Writeln('  Y CharSize              ', YCharSize);
    Writeln('  Number Of Planes        ', NumberOfPlanes);
    Writeln('  Bits Per Pixel          ', BitsPerPixel);
    Writeln('  Number Of Banks         ', NumberOfBanks);
    Writeln('  Memory Model            ', MemoryModel);
    Writeln('  Bank Size               ', BankSize);
    Writeln('  Number Of Image Pages   ', NumberOfImagePages);
    Writeln('  Red Mask Size           ', RedMaskSize);
    Writeln('  Red Field Position      ', RedFieldPosition);
    Writeln('  Green Mask Size         ', GreenMaskSize);
    Writeln('  Green Field Position    ', GreenFieldPosition);
    Writeln('  Blue Mask Size          ', BlueMaskSize);
    Writeln('  Blue Field Position     ', BlueFieldPosition);
    Writeln('  Rsvd Mask Size          ', RsvdMaskSize);
    Writeln('  Rsvd Field Position     ', RsvdFieldPosition);
    Writeln('  Direct Color Mode Info  ', DirectColorModeInfo);
    // VESA VBE 2.00 and higher
    if GetVbeVersion < $0200 then exit;
    Writeln('  Phys Base Ptr           ', '0x' + Hex(PhysBasePtr));
    Writeln('  Off Screen Mem Offset   ', OffScreenMemOffset);
    Writeln('  Off Screen Mem Size     ', OffScreenMemSize);
  end;
end;

procedure TestMode(ModeNo: DWORD);
var
  i: DWORD;
  Value: Byte;
  ViewInfo: ViewPortType;
  Height: DWORD;
begin
  SetGraphMode(ModeNo);
  if GraphResult <> grOk then
  begin
    Writeln('Video mode not supported.');
    exit;
  end;
  GetViewSettings(ViewInfo);
  Height := ViewInfo.Y2 - ViewInfo.Y1;
  if GetBitsPerPixel > 8 then
  begin
   for i := 0 to ViewInfo.X2 do
   begin
     SetColor(RGBColor(i * 255 div ViewInfo.X2, 0, 0));
     Line(ViewInfo.X2 shr 1, Height shr 1, i, 0);
     SetColor(RGBColor(0, i * 255 div ViewInfo.X2, 0));
     Line(ViewInfo.X2 shr 1, Height shr 1, i, Height);
   end;
   for i := 0 to Height do
   begin
    value := Byte(i * 255 div Height);
    SetColor(RGBColor(value, 0, 255 - value));
    Line(ViewInfo.X2 shr 1, Height shr 1, 0, i);
    SetColor(RGBColor(0, 255 - value, value));
    Line(ViewInfo.X2 shr 1, Height shr 1, ViewInfo.X2,i);
  end;
  end else
  begin
    i := 0;
    repeat
      SetColor(i mod 255);
      Line(ViewInfo.X2 shr 1, Height shr 1, i ,0);
      SetColor((i + 1) mod 255);
      Line(ViewInfo.X2 shr 1, Height shr 1, i, Height);
      inc(i, 4);
    until (i > ViewInfo.X2);
    i := 0;
    repeat
      SetColor((i + 2) mod 255);
      Line(ViewInfo.X2 shr 1, Height shr 1, 0, i);
      SetColor((i + 3) mod 255);
      Line(ViewInfo.X2 shr 1, Height shr 1, ViewInfo.X2, i);
      inc(i, 4);
    until (i > Height);
  end;
  Rectangle(0, 0, ViewInfo.X2 - 1, Height - 1, clWhite);
  GetKey;
  RestoreCRTMode;
end;

procedure ShowBriefInfo;
var
  VbeCapabilities: DWORD;
begin
  // VESA VBE 1.02 and higher
  if GetVbeVersion >= $0102 then
  begin
    Writeln('Product family:    ', GetOemString);
    // VESA VBE 1.01 and higher
    if TotalVbeMemory > 0 then
      Writeln('VRAM accessible:   ', TotalVbeMemory div 1024, 'k');
  end;

  Writeln('VESA VBE version:  ', Hi(GetVbeVersion), '.', Lo(GetVbeVersion));

  // VESA VBE 2.00 and higher
  if GetVbeVersion >= $0200 then
  begin
    Writeln('Product ID:        ', GetOemProductName);
    Writeln('Product revision:  ', GetOemProductRev);
    Writeln('OEM vendor:        ', GetOemVendorName);

    if GetLfbAddress > 0 then
      Writeln('LFB located at:    0x', Hex(GetLfbAddress))
    else
      Writeln('LFB support:       No');
  end;

  VbeCapabilities := GetVbeCapabilities;
  if (VbeCapabilities and 1) = 1 then
    Writeln('DAC width:         Switchable to 8 bits per primary color')
  else
    Writeln('DAC width:         Fixed width, with 6 bits per primary color');

  if (VbeCapabilities and 2) = 2 then
    Writeln('Controller type:   Not VGA compatible')
  else
    Writeln('Controller type:   VGA compatible');

  if (VbeCapabilities and 4) = 4 then
    Writeln('RAMDAC operation:  Use the blank bit in Function 09h')
  else
    Writeln('RAMDAC operation:  Normal');

  {
  if (VbeCapabilities and 8) = 8 then
    Writeln('Hardware SS:       Supported')
  else
    Writeln('Hardware SS:       Not supported');
  }

  // VESA VBE 3.00 and higher
  if GetVbeVersion >= $0300 then
  begin
    if (VbeCapabilities and 16) = 16 then
      Writeln('Stereo signaling:  Supported via VESA EVC connector')
    else
      Writeln('Stereo signaling:  Supported via external VESA stereo connector');
  end;
end;

procedure ShowHelp;
begin
  ShowBriefInfo;
  Writeln;
  Writeln('Usage:');
  Writeln('  VESAINFO [command]');
  Writeln;
  Writeln('Commands:');
  Writeln('  /l               - show list of supported video modes');
  Writeln('  /i [hex mode no] - show VESA mode info');
  Writeln('  /t [hex mode no] - test VESA mode');
  Writeln;
  halt(0);
end;

function GetModeNumber: Boolean;
begin
  if CommandIndex < ParamCount then
  begin
    CommandIndex +:= 1;
    Mode := DWORD(HexVal(ParamStr(CommandIndex)));
    Result := TRUE;
  end else
    Result := FALSE;
end;

procedure GetCommand;
var
  cmd: String;
begin
  Command := #0;
  if CommandIndex < ParamCount then
  begin
    CommandIndex +:= 1;
    cmd := LowerCase(ParamStr(CommandIndex));
    if (cmd = '/l') or (cmd = '-l') then
      Command := 'l'
    else
    if (cmd = '/h') or (cmd = '-h') then
      Command := 'h';
    if (cmd = '/i') or (cmd = '-i') then
      if (GetModeNumber) and (Mode > 0) then
        Command := 'i';
    if (cmd = '/t') or (cmd = '-t') then
      if (GetModeNumber) and (Mode > 0) then
        Command := 't';
  end;
end;

begin
  Writeln('VESA Info Utility Version 1.00');
  Writeln('Copyright (c) 1995, 2000 TMT Development Corporation. All rights reserved.');
  Writeln;

  if GraphResult = grVESANotFound then
  begin
    Writeln('VESA-compatible vido adapter not detected.');
    halt(0);
  end;

  GetCommand;
  if Command = 'l' then ShowVideoModes
  else
  if Command = 'h' then ShowHelp
  else
  if Command = 'i' then ShowModeInfo(Mode)
  else
  if Command = 't' then TestMode(Mode)
  else
    ShowHelp;
end.