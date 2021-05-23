(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       WINDOS Unit                                            *)
(*       Targets: MS-DOS, OS/2, Win32                           *)
(*                                                              *)
(*       Copyright (c) 1995,99 TMT Development Corporation      *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)
unit WinDos;

interface

uses DOS, Strings;

{$ifdef __DOS__}
type
  TRegisters = DOS.Registers;
{$endif}

type
  TDatetime = DOS.DateTime;
  TSearchRec = DOS.SearchRec;

const
  faReadOnly  = $01;
  faHidden    = $02;
  faSysFile   = $04;
  faVolumeID  = $08;
  faDirectory = $10;
  faArchive   = $20;
  faAnyFile   = $3F;

  fcExtension = $0001;
  fcFileName  = $0002;
  fcDirectory = $0004;
  fcWildcards = $0008;

  fCarry      = $0001;
  fParity     = $0004;
  fAuxiliary  = $0010;
  fZero       = $0040;
  fSign       = $0080;
  fOverflow   = $0800;

  fmClosed    = $D7B0;
  fmInput     = $D7B1;
  fmOutput    = $D7B2;
  fmInOut     = $D7B3;

  fsPathName  = 79;
  fsDirectory = 67;
  fsFileName  = 8;
  fsExtension = 4;

procedure CreateDir(Dir: PChar);
function  DiskFree(Drive: Byte): Longint;
function  DiskFreeKB(Drive: Byte): Longint;
function  DiskSize(Drive: Byte): Longint;
function  DiskSizeKB(Drive: Byte): Longint;
function  DosVersion: DWORD;
function  FileExpand(Dest, Name: PChar): PChar;
procedure FindFirst(Path: PChar; Attr: Word; var F: TSearchRec);
procedure FindNext(var F: TSearchRec);
function  FileSearch(Dest, Name, List: PChar): PChar;
function  FileSplit(Path, Dir, Name, Ext: PChar): DWORD;
function  GetArgCount: Longint;
function  GetArgStr(Dest: PChar; Index: Longint; MaxLen: DWORD): PChar;
procedure GetCBreak(var Break: Boolean);
function  GetCurDir(Dir: PChar; Drive: Byte): PChar;
procedure GetDate(var Year, Month, Day, DayOfWeek: Word);
function  GetEnvVar(Name: PChar): PChar;
procedure GetFAttr(var F; var Attr: Word);
procedure GetFTime(var F; var Time: Longint);
procedure GetTime(var Hour, Minute, Second, Sec100: Word);
procedure GetVerify(var Verify: Boolean);
procedure PackTime(var T: DateTime; var Time: Longint);
procedure RemoveDir(Dir: PChar);
procedure SetCBreak(Break: Boolean);
procedure SetCurDir(Dir: PChar);
procedure SetFAttr(var F; Attr: Word);
procedure SetDate(Year, Month, Day: Word);
procedure SetFTime(var F; Time: Longint);
procedure SetTime(Hour, Minute, Second, Sec100: Word);
procedure SetVerify(Verify: Boolean);
procedure UnpackTime(Time: Longint; var DT: TDateTime);
{$ifdef __DOS__}
procedure GetIntVec(IntNo: Byte; var Vector: FarPointer);
procedure GetIntVecFar(IntNo: Byte; var Vector: FarPointer);
procedure Intr(IntNo: Byte; var Regs: Registers);
procedure MsDos(var Regs: Registers);
procedure SetIntVecFar(IntNo: Byte; const Vector: FarPointer);
Overload  SetIntVec = SetIntVecFar;
procedure SetIntVecNear(IntNo: Byte; Vector: Pointer);
Overload  SetIntVec = SetIntVecNear;
{$endif}

var
  DosError: Longint := 0;

implementation

var
  EnvStr: array[0..256] of Char;

procedure CreateDir(Dir: PChar);
begin
  MkDir(StrPas(Dir));
end;

function DiskFree(Drive: Byte): Longint;
begin
  Result := DOS.DiskFree(Drive);
  DosError := DOS.DosError;
end;

function DiskFreeKB(Drive: Byte): Longint;
begin
  Result := DOS.DiskFreeKB(Drive);
  DosError := DOS.DosError;
end;

function DiskSize(Drive: Byte): Longint;
begin
  Result := DOS.DiskSize(Drive);
  DosError := DOS.DosError;
end;

function DiskSizeKB(Drive: Byte): Longint;
begin
  Result := DOS.DiskSizeKB(Drive);
  DosError := DOS.DosError;
end;

function DosVersion: DWORD;
begin
  Result := DOS.DosVersion;
  DosError := DOS.DosError;
end;

function FileExpand(Dest, Name: PChar): PChar;
begin
  Result := StrPCopy(Dest, FExpand(StrPas(Name)));
end;

procedure FindFirst(Path: PChar; Attr: Word; var F: TSearchRec);
begin
  DOS.FindFirst(StrPas(Path), Attr, F);
  DosError := DOS.DosError;
end;

procedure FindNext(var F: TSearchRec);
begin
  DOS.FindNext(F);
  DosError := DOS.DosError;
end;

function FileSearch(Dest, Name, List: PChar): PChar;
begin
  Result := StrPCopy(Dest, FSearch(StrPas(Name), StrPas(List)));
end;

function FileSplit(Path, Dir, Name, Ext: PChar): DWORD;
var
  sDir: DirStr;
  sName: NameStr;
  sExt: ExtStr;
begin
  FSplit(StrPas(Path), sDir, sName, sExt);
  if (Pos('*', StrPas(Path)) <> 0) or (Pos('?', StrPas(Path)) <> 0) then
    Result := fcWildcards
  else
    Result := 0;
  StrPCopy(Dir, sDir);
  if sDir <> '' then Result := Result or fcDirectory;
  StrPCopy(Name, sName);
  if sName <> '' then Result := Result or fcFileName;
  StrPCopy(Ext, sExt);
  if sExt <> '' then Result := Result or fcExtension;
end;

function  GetArgCount: Longint;
begin
  Result := ParamCount;
end;

function GetArgStr(Dest: PChar; Index: Longint; MaxLen: DWORD): PChar;
begin
  if (Index < 0) or (Index > GetArgCount) then
    Result := StrPCopy(Dest, '')
  else
    Result := StrPCopy(Dest, ParamStr(Index));
end;

procedure GetCBreak(var Break: Boolean);
begin
  DOS.GetCBreak(Break);
  DosError := DOS.DosError;
end;

function GetCurDir(Dir: PChar; Drive: Byte): PChar;
var
  sDir: String;
begin
  GetDir(Drive, sDir);
  Result := StrPCopy(Dir, sDir);
end;

procedure GetDate(var Year, Month, Day, DayOfWeek: Word);
begin
  DOS.GetDate(Year, Month, Day, DayOfWeek);
  DosError := DOS.DosError;
end;

function GetEnvVar(Name: PChar): PChar;
begin
  Result := StrPCopy(EnvStr, GetEnv(StrPas(Name)));
end;

procedure GetFAttr(var F; var Attr: Word);
begin
  DOS.GetFAttr(F, Attr);
  DosError := DOS.DosError;
end;

procedure GetFTime(var F; var Time: Longint);
begin
  DOS.GetFTime(F, Time);
  DosError := DOS.DosError;
end;

procedure GetTime(var Hour, Minute, Second, Sec100: Word);
begin
  DOS.GetTime(Hour, Minute, Second, Sec100);
  DosError := DOS.DosError;
end;

procedure GetVerify(var Verify: Boolean);
begin
  DOS.GetVerify(Verify);
  DosError := DOS.DosError;
end;

procedure PackTime(var T: DateTime; var Time: Longint);
begin
  DOS.PackTime(T, Time);
  DosError := DOS.DosError;
end;

procedure RemoveDir(Dir: PChar);
begin
  RmDir(StrPas(Dir));
end;

procedure SetCBreak(Break: Boolean);
begin
  DOS.SetCBreak(Break);
  DosError := DOS.DosError;
end;

procedure SetCurDir(Dir: PChar);
begin
  ChDir(StrPas(Dir));
end;

procedure SetDate(Year, Month, Day: Word);
begin
  DOS.SetDate(Year, Month, Day);
  DosError := DOS.DosError;
end;

procedure SetFAttr(var F; Attr: Word);
begin
  DOS.SetFAttr(F, Attr);
  DosError := DOS.DosError;
end;

procedure SetFTime(var F; Time: Longint);
begin
  DOS.SetFTime(F, Time);
  DosError := DOS.DosError;
end;

procedure SetTime(Hour, Minute, Second, Sec100: Word);
begin
  DOS.SetTime(Hour, Minute, Second, Sec100);
  DosError := DOS.DosError;
end;

procedure SetVerify(Verify: Boolean);
begin
  DOS.SetVerify(Verify);
  DosError := DOS.DosError;
end;

procedure UnpackTime(Time: Longint; var DT: TDateTime);
begin
  DOS.UnpackTime(Time, DT);
  DosError := DOS.DosError;
end;

{$ifdef __DOS__}
procedure GetIntVec(IntNo: Byte; var Vector: FarPointer);
begin
  DOS.GetIntVec(IntNo, Vector);
  DosError := DOS.DosError;
end;

procedure GetIntVecFar(IntNo: Byte; var Vector: FarPointer);
begin
  DOS.GetIntVecFar(IntNo, Vector);
  DosError := DOS.DosError;
end;

procedure Intr(IntNo: Byte; var Regs: Registers);
begin
  DOS.Intr(IntNo, Regs);
  DosError := DOS.DosError;
end;

procedure MsDos(var Regs: Registers);
begin
  DOS.MsDos(Regs);
  DosError := DOS.DosError;
end;

procedure SetIntVecFar(IntNo: Byte; const Vector: FarPointer);
begin
  DOS.SetIntVecFar(IntNo, Vector);
  DosError := DOS.DosError;
end;

procedure SetIntVecNear(IntNo: Byte; Vector: Pointer);
begin
  DOS.SetIntVecNear(IntNo, Vector);
  DosError := DOS.DosError;
end;
{$endif}

end.