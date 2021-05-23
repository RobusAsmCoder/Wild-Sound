(********************************************************)
(*                                                      *)
(* BIN to OBJ Converter Utility                         *)
(* Copyright (c) 2000, 2001 TMT Development Corporation *)
(* Written by Vadim Bodrov                              *)
(*                                                      *)
(* Targets:                                             *)
(*   MS-DOS 32-bit protected mode                       *)
(*   OS/2 console application                           *)
(*   WIN32 console application                          *)
(*                                                      *)
(********************************************************)

program BINOBJ32;

const
  SEG_SIZE = 1016;

var
  summ:       Longint;
  offset:     DWORD;
  in_file:    file;
  out_file:   file;
  InName:     String;
  OutName:    String;
  PublicName: String;

procedure ResetSumm;
begin
  summ := 0;
end;

procedure OutByte(b: Byte);
begin
  BlockWrite(out_file, b, 1);
  summ +:= b;
end;

procedure OutWord(w: Word);
begin
  BlockWrite(out_file, w, 2);
  summ +:= Hi(w);
  summ +:= Lo(w);
end;

procedure OutDWord(dw: DWORD);
begin
  BlockWrite(out_file, dw, 4);
  summ +:= Hi(HiWord(dw));
  summ +:= Lo(HiWord(dw));
  summ +:= Hi(LoWord(dw));
  summ +:= Lo(LoWord(dw));
end;

procedure OutData(Buffer: Pointer; Count: DWORD);
var
  i: DWORD;
  p: Pointer;
begin
  p := Buffer;
  for i := 1 to Count do
  begin
    summ +:= Byte(p^);
    inc(p);
  end;
  BlockWrite(out_file, Buffer^, Count);
end;

procedure OutSumm;
begin
  OutByte(-summ);
end;

procedure WriteName(fName: String);
begin
  ResetSumm;
  OutByte($80);
  OutWord(Length(fName) + 2);
  OutByte(Length(fName));
  OutData(@fName[1], Length(fName));
  OutSumm;
end;

procedure WriteComment(Comment: String);
begin
  ResetSumm;
  OutByte($88);
  OutWord(Length(Comment) + 4);
  OutWord(0); // comment type (Purge = 0, List = 0);
  OutByte(Length(Comment));
  OutData(@Comment[1], Length(Comment));
  OutSumm;
end;

procedure WriteListOfNames(SegName: String);
begin
  ResetSumm;
  OutByte($96);
  OutWord(Length(SegName) + 3);
  OutByte($00); // not defined (list index = 0)
  OutByte(Length(SegName));
  OutData(@SegName[1], Length(SegName));
  OutSumm;
end;

procedure WriteSeg32Info(Size: DWORD);
begin
  ResetSumm;
  OutByte($99);
  OutWord($09); // length = 9
  OutByte($69); // unknown code
  OutDWord(Size);
  OutByte($02); // unknown code (seems like Segment/Group Symbol Number)
  OutByte($01); // unknown code
  OutByte($01); // unknown code
  OutSumm;
end;

procedure WriteLSEG(SegName: String);
begin
  ResetSumm;
  OutByte($90);
  OutWord(Length(SegName) + 7);
  OutByte($00); // absolute segment (ACBP = 0)
  OutByte($01); // one frame (frame number = 1)
  OutByte(Length(SegName));
  OutData(@SegName[1], Length(SegName));
  OutByte($00);
  OutByte($00);
  OutByte($00);
  OutSumm;
end;

procedure WriteEnd;
begin
  ResetSumm;
  OutByte($8A);
  OutWord($02); // length = 2
  OutByte($00); // Non-main, no Start Address
  OutSumm;
end;

(* Count must be SEG_SIZE or less *)
procedure WriteData(Addr: Pointer; Count: DWORD);
begin
  ResetSumm;
  if HiWord(offset) = 0 then
  begin
    OutByte($A0);
    OutWord(Count + 4);
    OutByte($01);
    OutWord(offset);
  end else
  begin
    OutByte($A1);
    OutWord(Count + 6);
    OutByte($01);
    OutDWord(offset);
  end;
  offset +:= Count;
  OutData(Addr, Count);
  OutSumm;
end;

procedure ShowHelp;
begin
  Writeln;
  Writeln('Usage:');
  Writeln('  BINOBJ32 <source[.BIN]> <destination[.OBJ]> <public name>');
  halt(0);
end;

function ParseOptions: Boolean;
begin
  if ParamCount <> 3 then
  begin
    Result := FALSE;
    exit;
  end;
  InName := ParamStr(1);
  if Pos('.', InName) = 0 then
    InName := InName + '.BIN';

  OutName := ParamStr(2);
  if Pos('.', OutName) = 0 then
    OutName := OutName + '.OBJ';

  PublicName := ParamStr(3);

  Result := TRUE;
end;

procedure Error(FileName, Reason: String);
begin
  Writeln('''' + Filename + ''' : ' + Reason);
  halt(0);
end;

var
  t, FSize: DWORD;
  Buffer: Pointer;
begin
  Writeln('32-bit BIN to OBJ Converter Version 1.10');
  Writeln('Copyright (c) 1995, 2001 TMT Development Corporation. All rights reserved.');
  if not ParseOptions then ShowHelp;

{$i-}
  FileMode := 0;
  Assign(out_file, OutName);
  Rewrite(out_file, 1);
{$i+}
  if IOResult <> 0 then Error(OutName, 'unable to create file');

{$i-}
  WriteName('::');
  WriteComment('BINOBJ32 1.10 Copyright (c) 1995, 2001 TMT Development Corp.' + ' <' + InName + '>');
  WriteListOfNames('CODE32');
{$i+}
  if IOResult <> 0 then Error(OutName, 'can''t write file');

{$i-}
  Assign(in_file, InName);
  Reset(in_file, 1);
{$i+}
  if IOResult <> 0 then
  begin
    Close(out_file);
    Erase(out_file);
    Error(InName, 'unable to open file');
  end;
  FSize := FileSize(in_file);
  t := FSize;

{$i-}
  WriteSeg32Info(FSize);
  WriteLSEG(PublicName);

  GetMem(Buffer, SEG_SIZE);
  offset := 0;
  while (FSize > 0) do
  begin
    if FSize >= SEG_SIZE then
    begin
      BlockRead(in_file, Buffer^, SEG_SIZE);
      WriteData(Buffer, SEG_SIZE);
      FSize -:= SEG_SIZE;
    end else
    begin
      BlockRead(in_file, Buffer^, FSize);
      WriteData(Buffer, FSize);
      FSize := 0;
    end;
  end;
  FreeMem(Buffer, SEG_SIZE);
  Close(in_file);

  WriteEnd;
  Close(out_file);
{$i-}
  if IOResult <> 0 then Error(OutName, 'file I/O error');

  Writeln;
  Writeln(t, ' bytes converted.');
end.