(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       MSDOS Interface Unit                                   *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Authors: Anton Moscal, Vadim Bodrov                    *)
(*                                                              *)
(****************************************************************)
unit Dos;

interface

{$i-,o+,s-}

uses SysIO32, {$ifdef __OS2__} DosCall, Os2Types, Os2Ord, {$endif} {$ifdef __WIN32__} Windows, {$endif} Strings;

const
  READONLY   = $0001;
  HIDDEN     = $0002;
  SYSFILE    = $0004;
  VOLUMEID   = $0008;
  DIRECTORY  = $0010;
  ARCHIVE    = $0020;
  ANYFILE    = $003F;

  FMCLOSED   = $D7B0;
  FMINPUT    = $D7B1;
  FMOUTPUT   = $D7B2;
  FMINOUT    = $D7B3;

  FCARRY     = $0001;
  FPARITY    = $0004;
  FAUXILIARY = $0010;
  FZERO      = $0040;
  FSIGN      = $0080;
  FOVERFLOW  = $0800;

  hmaxpathcomp = 256;

{$ifdef __OS2__}

type
  ComStr  = String[255];
  PathStr = String[255];
  DirStr  = String[255];
  NameStr = String[255];
  ExtStr  = String[255];

type
  SearchRec = record
    Fill: array[1..21] of Byte;
    Attr: Byte;
    Time: Longint;
    Size: Longint;
    Name: String;
  end;

const
  Execflags: Word = 0;
{$endif}

{$ifdef __DOS__}
type
  Comstr  = String[127];
  PathStr = String[79];
  DirStr  = String[67];
  NameStr = String[8];
  ExtStr  = String[4];

  Registers = SysIO32.regs;

  SearchRec = record
    Fill: array [1..21] of Byte;
    Attr: Byte;
    Time: Longint;
    Size: Longint;
    Name: String[12];
  end;

type
  Int_Vecs =
    (int00, int02, int04, int05, int06, int1b, int21,
     int23, int24, int34, int35, int36, int37, int38,
     int39, int3a, int3b, int3c, int3d, int3e, int3f,
     int75);

  Exc_Vecs =
    (exc00, exc02, exc04, exc05, exc06, exc08,
     exc09, exc0a, exc0b, exc0c, exc0d, exc0e, exc75);

const
  Int_Vecs_No: array [Int_Vecs] of Byte =
    ($00, $02, $04, $05, $06, $1b, $21,
     $23, $24, $34, $35, $36, $37, $38,
     $39, $3a, $3b, $3c, $3d, $3e, $3f,
     $75);

  Exc_Vecs_No: array [Exc_Vecs] of Byte =
    ($00, $02, $04, $05, $06, $08,
     $09, $0a, $0b, $0c, $0d, $0e, $75);
var
  Int_Save: array [Int_Vecs] of FarPointer;
  Exc_Save: array [Exc_Vecs] of FarPointer;
{$endif}

{$ifdef __WIN32__}
type
  TFileName = String[255];

  ComStr  = String[255];
  PathStr = String[255];
  DirStr  = String[255];
  NameStr = String[255];
  ExtStr  = String[255];

  SearchRec = record
    Fill: Array[1..21] of Byte;
    Attr: Byte;
    Time: Longint;
    Size: Longint;
    Name: TFileName;
    ExcludeAttr: Longint;
    FindHandle: THandle;
    FindData: TWin32FindData;
  end;

const
  faReadOnly  = WINDOWS.FILE_ATTRIBUTE_READONLY;
  faHidden    = WINDOWS.FILE_ATTRIBUTE_HIDDEN;
  faSysFile   = WINDOWS.FILE_ATTRIBUTE_SYSTEM;
  faVolumeID  = $08;
  faDirectory = WINDOWS.FILE_ATTRIBUTE_DIRECTORY;
  faArchive   = WINDOWS.FILE_ATTRIBUTE_ARCHIVE;
  faAnyFile   = WINDOWS.FILE_ATTRIBUTE_NORMAL;

{$endif}

type
  TSearchRec = SearchRec;

  Datetime = record
    Year, Month, Day, Hour, Min, Sec: Word;
  end;

var
  DosError: Longint := 0;

function  DosVersion: DWord;
procedure GetDate(var Year, Month, Day, DayOfWeek: Word);
procedure SetDate(Year, Month, Day: Word);
procedure GetTime(var Hour, Minute, Second, Sec100: Word);
procedure SetTime(Hour, Minute, Second, Sec100: Word);
function  GetClock: Longint;
procedure SetClock(Clock: Longint);
procedure GetVerify(var Verify: Boolean);
procedure SetVerify(Verify: Boolean);
function  DiskFree(Drive: Byte): Longint;
function  DiskFreeKB(Drive: Byte): Longint;
function  DiskSize(Drive: Byte): Longint;
function  DiskSizeKB(Drive: Byte): Longint;
procedure GetFAttr(var F; var Attr: Word);
procedure SetFAttr(var F; Attr: Word);
procedure GetFTime(var F; var Time: Longint);
procedure SetFTime(var F; Time: Longint);
procedure FindFirst(const Path: String; Attr: DWORD; var SrchRec: SearchRec);
procedure FindNext(var SrchRec: SearchRec);
procedure FindClose(var SrchRec: SearchRec);
procedure UnpackTime(Src: Longint; var Dst: DateTime);
procedure PackTime(var Src: DateTime; var Dst: Longint);
function  FSearch(Path: PathStr; Dirlist: String): PathStr;
function  FExpand (const Path: PathStr): PathStr;
procedure FSplit(const Path: PathStr; var Dir: DirStr; var Name: NameStr; var Ext: ExtStr);
function  EnvCount: Longint;
function  EnvStr(Index: Longint): String;
function  GetEnv(EnvVar: String): String;
procedure Exec(Path: PathStr; Comline: ComStr);
function  DosExitCode: DWord;
procedure SwapVectors;
procedure Keep(ExitCode: DWord);
procedure GetCBreak(var Break: Boolean);
procedure SetCBreak(Break: Boolean);
{$ifdef __DOS__}
procedure Intr(IntNo: Byte; var Regs: Registers);
procedure MsDos(var Regs: Registers);
procedure ReleaseTimeSlice;
procedure GetIntVec(IntNo: Byte; var Vector: FarPointer);
procedure GetIntVecFar(IntNo: Byte; var Vector: FarPointer);
procedure GetExcVec(IntNo: Byte; var Vector: FarPointer);
procedure GetExcVecFar(IntNo: Byte; var Vector: FarPointer);
procedure SetIntVecFar(IntNo: Byte; const Vector: FarPointer);
Overload  SetIntVec = SetIntVecFar;
procedure SetIntVecNear(IntNo: Byte; Vector: Pointer);
Overload  SetIntVec = SetIntVecNear;
procedure SetExcVecFar(IntNo: Byte; const Vector: FarPointer);
Overload  SetExcVec = SetExcVecFar;
procedure SetExcVecNear(IntNo: Byte; Vector: Pointer);
Overload  SetExcVec = SetExcVecNear;
{$endif}

implementation


procedure assn_str; code;
   asm
     sub   edx, ebx
     cmp   eax, ebx
     jb    @@1
     mov   eax, ebx
@@1:
     stosb
     mov   ecx, eax
     add   ebx, esi
     rep   movsb
     mov   esi, ebx
     ret
end;

{$ifdef __OS2__}

type
  str257 = array [0..256] of Char;

var
  exec_res: ResultCodes;

function DosQFileMode conv arg_os2_16 (name: pchar; var attrib: Word; res: Longint): Word;
  external 'doscalls' index ord_dosqfilemode;

function DosGetVersion conv arg_os2_16 (var version: Word): Word;
  external 'doscalls' index ord_dosgetversion;

function DosVersion: DWord;
var
  version: Word;
begin
  DosError := DosGetVersion(version);
  if DosError = 0 then
    Result := version
  else
    Result := 0;
end;

{$system}
procedure GetDate(var Year, Month, Day, DayOfWeek: Word);
var
  dt: DosCall.OS2datetime;
begin
  DosError := dosgetdatetime (dt);
  if DosError = 0 then
  begin
    Year      := dt.Year;
    Month     := dt.Month;
    Day       := dt.Day;
    DayOfWeek := dt.WeekDay;
  end else
  begin
    Year      := 0;
    Month     := 0;
    Day       := 0;
    DayOfWeek := 0;
  end;
end;

procedure SetDate(Year, Month, Day: Word);
var
  dt: DosCall.OS2datetime;
begin
  DosError := DosGetDateTime(dt);
  if DosError = 0 then
  begin
    dt.Year    := Year;
    dt.Month   := Month;
    dt.Day     := Day;
    DosSetDateTime(dt);
  end;
end;

procedure GetTime(var Hour, Minute, Second, Sec100: Word);
var
  dt: DosCall.OS2datetime;
begin
  DosError := DosGetDateTime(dt);
  if DosError = 0 then
  begin
    Hour   := dt.Hours;
    Minute := dt.Minutes;
    Second := dt.Seconds;
    Sec100 := dt.Hundredths;
  end else
  begin
    Hour   := 0;
    Minute := 0;
    Second := 0;
    Sec100 := 0;
  end;
end;

procedure SetTime(Hour, Minute, Second, Sec100: Word);
var
  dt: DosCall.OS2datetime;
begin
  DosError := DosGetDateTime(dt);
  if DosError = 0 then
  begin
    dt.Hours      := Hour;
    dt.Minutes    := Minute;
    dt.Seconds    := Second;
    dt.Hundredths := Sec100;
    DosSetDateTime(dt);
  end;
end;

function GetClock: Longint;
var
  dt: DosCall.OS2datetime;
begin
  DosError := DosGetDateTime(dt);
  if DosError = 0 then with dt do
    Result := (((hours * 60) + minutes) * 60 + seconds) * 100 + hundredths;
end;

procedure SetClock(Clock: Longint);
begin
  RunError;
end;

procedure GetVerify(var Verify: Boolean);
var
  ver: Bool;
begin
  DosError := DosQueryVerify(ver);
  if DosError = 0 then
    verify := ver
  else
    verify := FALSE;
end;

procedure SetVerify(Verify: Boolean);
begin
  DosError := DosSetVerify(Verify);
end;

function DiskFree(Drive: Byte): Longint;
var
  fi: DosCall.FsAllocate;
begin
  DosError := DosQueryFsInfo(Drive, 1, @fi, SizeOf(fi));
  if DosError = 0 then
    Result := fi.cunitavail * fi.csectorunit * fi.cbsector
  else
    Result := -1;
end;

function  DiskFreeKB(Drive: Byte): Longint;
begin
  Result := DiskFree(Drive) div 1024;
end;

function DiskSize(Drive: Byte): Longint;
var
  fi: DosCall.FsAllocate;
begin
  DosError := DosQueryFsInfo(Drive, 1, @fi, SizeOf(fi));
  if DosError = 0 then
    Result := fi.cunit * fi.csectorunit * fi.cbsector
  else
    Result := -1;
end;

function  DiskSizeKB(Drive: Byte): Longint;
begin
  Result := DiskSize(Drive) div 1024;
end;

procedure GetFAttr(var F; var Attr: Word);
var
  info: FileStatus;
begin
  with TFileRec(F) do
  begin
    check_magic;
    Attr := 0;
    if not (%file_opened in state) then
    begin
      DosError := 1;
      exit;
    end;
    DosError := DosQueryFileInfo(handle, FIL_STANDARD, @info, SizeOf(info));
    if DosError = 0 then
      Attr := info.AttrFile;
  end;
end;

procedure SetFAttr(var F; Attr: Word);
var
  info: FileStatus;
begin
  with TFileRec(f) do
  begin
    check_magic;
    if not (%file_opened in state) then
    begin
      DosError := 1;
      exit;
    end;
    DosError := DosQueryFileInfo(handle, FIL_STANDARD, @info, SizeOf(info));
    if DosError = 0 then
    begin
      info.attrfile := Attr;
      DosError := DosSetFileInfo(handle, FIL_STANDARD, @info, SizeOf(info));
    end;
  end;
end;

procedure GetFTime(var F; var Time: Longint);
var
  fi: DosCall.FileStatus;
  t1: record
    Time: Word;
    Date: Word;
  end absolute Time;
begin
    DosError := DosQueryFileInfo(TFileRec(F).handle, 1, @fi, SizeOf(fi));
    with t1, fi do if DosError = 0 then
    begin
      Time := FTimeLastWrite;
      Date := FDateLastWrite;
    end else begin
      Time := 0;
      Date := 0;
    end
end;

procedure SetFTime(var F; Time: Longint);
var
  fi: Doscall.FileStatus;
  t1: record
    Time: Word;
    Date: Word;
  end absolute Time;
begin
  DosError := DosQueryFileInfo(TFileRec(F).handle, 1, @fi, SizeOf(fi));
  if DosError = 0 then with t1, fi do
  begin
    FTimeLastWrite := Time;
    FDateLastWrite := Date;
    DosError := DosSetFileInfo(TFileRec(F).handle, 1, @fi, SizeOf(fi));
  end;
end;

procedure FindFirst(const Path: String; Attr: DWORD; var SrchRec: SearchRec);
var
  fbuf: DosCall.filefindbuf3;
  n: String;
  Count: Longint;
begin
  n := Path + #0;
  Count := 1;
  phdir(@SrchRec)^ := $FFFF;
  DosError := DosFindFirst(@n [1], phdir(@SrchRec)^, Attr, @fbuf, SizeOf(fbuf), Count, 1);
  if DosError = 0 then with SrchRec, fbuf do
  begin
    Attr := AttrFile;
    Time := (Longint(FDateLastWrite) shl 16) + FTimeLastWrite;
    Size := cbFile;
    Name := achName;
  end;
end;

procedure FindNext(var srchrec: searchrec);
var
  fbuf: DosCall.filefindbuf3;
  Count: Longint;
begin
  Count := 1;
  DosError := DosFindNext(phdir(@SrchRec)^, @fbuf, SizeOf(fbuf), Count);
  if DosError = 0 then with SrchRec, fbuf do
  begin
    Attr := AttrFile;
    Time := (Longint(FDateLastWrite) shl 16) + FTimeLastWrite;
    Size := cbFile;
    Name := achName;
  end else
    DosFindClose(phdir(@SrchRec)^);
end;

procedure FindClose(var SrchRec: SearchRec);
begin
  DosFindClose(phdir(@SrchRec)^);
end;

function FSearch(Path: PathStr; Dirlist: String): PathStr;
var
  name: String;
  attrib: Word;
  p: Byte;
  ff_buf: SearchRec;
begin
  Length(Result) := 0;
  name := Path;
  repeat
    FindFirst(name, ANYFILE, ff_buf);
    if DosError = 0 then
    begin
      Result := name;
      break
    end else
    begin
      if Length(DirList) = 0 then break;
      p := Pos(';', DirList);
      if p <> 0 then
      begin
        Name := Copy(DirList, 1, p - 1) + '\' + Path;
        DirList := Copy(DirList, p + 1, 255);
      end else
      begin
        name := DirList + '\' + Path;
        Length(DirList) := 0;
      end
    end
  until FALSE;
end;

function _env: PChar;
var
  Process: PPib;
  Thread: PTib;
begin
  DosGetInfoBlocks(Thread, Process);
  Result := Process^.pib_pchenv;
end;

function FExpand(const Path: PathStr): PathStr;
var
  s: String;
  dir: String;
  i: Longint;
begin
  GetDir(0, dir);
  if dir[Length(dir) - 1] <> '\' then
  dir := dir + '\';
  i := 1;
  if (Length(Path) >= 2) and (Path[1] in ['a'..'z', 'A'..'Z']) and (Path[2] = ':') then
  begin
    Dir[1] := UpCase(Path[1]);
    i := 3;
  end;
  if Path[i] = '\' then Length(dir) := 2;
  Result := dir + Copy(Path, i, 256);
end;

function EnvCount: Longint;
var
  p: PChar;
begin
  p := _env;
  Result := 0;
  repeat
    if p^ = #0 then break;
    repeat
      inc(p)
    until p^ = #0;
    inc(p);
    Result +:= 1;
  until FALSE;
end;

function EnvStr(Index: Longint): String;
var
  p: PChar;
  i: Longint;
begin
  p := _env;
  Length(Result) := 0;
  for i := 1 to Index do
  begin
    Length(Result) := 0;
    if p^ = #0 then break;
    repeat
      Result +:= p^;
      inc(p);
    until p^ = #0;
    inc(p);
  end;
end;

function GetEnv(EnvVar: String): String;
var
  i: Longint;
  s: String;
  p: Longint;
begin
  EnvVar := UpperCase(EnvVar);
  for i := 1 to EnvCount do
  begin
    s := EnvStr(i);
    p := Pos('=', s);
    if (p <> 0) and (Copy(s, 1, p - 1) = EnvVar) then
    begin
      Result := Copy(s, p + 1, 255);
      exit
    end
  end;
  Length(Result) := 0
end;

procedure Exec(Path: PathStr; Comline: ComStr);
var
  b : array [0..255] of Char;
begin
  Path := Path + #0;
  Comline := ComLine + #0#0;
  DosError := DosExecPgm(b, 256, ExecFlags, @ComLine[1], _env, exec_res, @Path[1]);
end;

function DosExitCode: DWord;
begin
  Result := exec_res.coderesult;
end;
{$endif}

{$ifdef __DOS__}

type str257 = array [0..256] of Char;

var
  r: Registers;

procedure GetIntVec(IntNo: Byte; var Vector: FarPointer);
assembler;
      asm
        mov     bl,  [intno]
        mov     eax, 0204h
        int     31h
        mov     eax, [vector]
        mov     dword [eax], edx
        mov     word [eax+4], cx
end;

procedure GetExcVec(IntNo: Byte; var Vector: FarPointer);
assembler;
      asm
        mov     bl, [intno]
        mov     eax, 0202h
        int     31h
        mov     eax, [vector]
        mov     dword [eax], edx
        mov     word [eax+4], cx
end;

procedure SetIntVecNear(IntNo: Byte; Vector: Pointer);
assembler;
      asm
        mov     bl, [intno]
        mov     eax, 0205h
        mov     edx, [vector]
        mov     cx, cs
        int     31h
end;

procedure SetExcVecNear(IntNo: Byte; Vector: Pointer);
assembler;
      asm
        mov     bl,  [intno]
        mov     eax, 0203h
        mov     edx, [vector]
        mov     cx, cs
        int     31h
end;

procedure GetIntVecFar(IntNo: Byte; var Vector: FarPointer);
begin
  GetIntVec(IntNo, Vector);
end;

procedure GetExcVecFar(IntNo: Byte; var Vector: FarPointer);
begin
  GetExcVec(IntNo, Vector);
end;

procedure SetIntVecFar(IntNo: Byte; const Vector: FarPointer);
assembler;
      asm
        mov     bl, [intno]
        mov     eax, [vector]
        mov     edx, dword [eax]
        mov     cx, word [eax+4]
        mov     eax, 0205h
        int     31h
end;

procedure SetExcVecFar(IntNo: Byte; const Vector: FarPointer);
assembler;
      asm
        mov     bl, [intno]
        mov     eax, [vector]
        mov     edx, dword [eax]
        mov     cx, word [eax+4]
        mov     eax, 0203h
        int     31h
end;

function  DosVersion: DWord;
assembler;
      asm
        mov     ah, 30h
        int     21h
        movzx   eax, ax
end;

procedure ReleaseTimeSlice;
assembler;
      asm
        int     28h
end;

function GetClock: Longint;
assembler;
      asm
        mov     ah, 00h
        int     1Ah
        movzx   eax, cx
        shl     eax, 16
        mov     ax, dx
end;

procedure SetClock(Clock: Longint);
assembler;
      asm
        mov     cx, word [clock + 2]
        mov     dx, word [clock]
        mov     ah, 01h
        int     1Ah
end;

procedure GetTime(var Hour, Minute, Second, Sec100: Word);
assembler;
      asm
        mov     ah, 2Ch
        int     21h
        xor     eax, eax

        mov     al, ch
        mov     ebx, [hour]
        mov     [ebx], ax

        mov     al, cl
        mov     ebx, [minute]
        mov     [ebx], ax

        mov     al, dh
        mov     ebx, [second]
        mov     [ebx], ax

        mov     al, dl
        mov     ebx, [sec100]
        mov     [ebx], ax
end;

procedure SetTime(Hour, Minute, Second, Sec100: Word);
assembler;
      asm
        mov     ch, byte [hour]
        mov     cl, byte [minute]
        mov     dh, byte [second]
        mov     dl, byte [sec100]
        mov     ah, 2Dh
        int     21h
end;

procedure GetDate(var Year, Month, Day, DayOfWeek: Word);
assembler;
      asm
        mov     ah, 2Ah
        int     21h

        movzx   eax, al
        mov     ebx, [dayofweek]
        mov     [ebx], ax

        mov     ebx, [year]
        mov     [ebx], cx

        mov     al, dh
        mov     ebx, [month]
        mov     [ebx], ax

        mov     al, dl
        mov     ebx, [day]
        mov     [ebx], ax
end;

procedure SetDate(Year, Month, Day: Word);
assembler;
      asm
        mov     cx, word [Year]
        mov     dh, byte [Month]
        mov     dl, byte [Day]
        mov     ah, 2Bh
        int     21h
end;

function DiskFree(Drive: Byte): Longint;
begin
  FillChar(R, SizeOf(r), 0);
  r.dl := Drive;
  r.ah := $36;
  DosInt($21, r, 0);
  if r.ax <> $FFFF then
     Result := DWord(r.ax) * DWord(r.cx) * DWord(r.bx)
  else
     Result := Longint(r.ax);
end;

function  DiskFreeKB(Drive: Byte): Longint;
begin
  Result := DiskFree(Drive) div 1024;
end;

function DiskSize(Drive: Byte): Longint;
assembler;
      asm
        mov     dl, [drive]
        mov     ah, 36h
        int     21h
        movzx   eax, ax
        cmp     ax, 0FFFFh
        je      @@err
        movzx   ebx, dx
        movzx   ecx, cx
        mul     ecx
        mul     ebx
        jmp     @@quit
@@err:
        movsx   eax, ax
@@quit:
end;

function  DiskSizeKB(Drive: Byte): Longint;
begin
  Result := DiskSize(Drive) div 1024;
end;

procedure GetVerify(var Verify: Boolean);
assembler;
      asm
        mov     ah, 54h
        int     21h
        mov     ebx, [Verify]
        mov     [ebx], al
end;

procedure SetVerify(Verify: Boolean);
assembler;
      asm
        mov     al, [Verify]
        xor     dl, dl
        mov     ah, 2Eh
        int     21h
end;

procedure GetCBreak(var Break: Boolean);
assembler;
      asm
        mov     ax, 3300h
        int     21h
        mov     ebx, [Break]
        mov     [ebx], dl
end;

procedure SetCBreak(Break: Boolean);
assembler;
      asm
        mov     dl, [Break]
        mov     ax, 3301h
        int     21h
end;

{$system }

function _getfattr(Name: PChar): DWord;
assembler;
      asm
        mov     edx, [name]
        mov     ax, 4300h
        int     21h
        jc      @@err
        xor     eax, eax
        jmp     @@ok
@@err:
        xor     ecx, ecx
@@ok:
        and     eax, $FFFF
        mov     [DosError], eax
        movzx   eax, cx
end;

procedure GetFAttr(var F; var Attr: Word);
var
{$ifdef __WIN32__}
  Temp: array [0..MAX_PATH] of Char;
{$else}
  Temp: array [0..255] of Char;
{$endif}
begin
  Attr := _getfattr(StrPCopy(Temp, TFileRec(F).Name));
end;

procedure _setfattr(Name: PChar; Attr: Word);
assembler;
      asm
        mov     edx, [name]
        mov     cx, [attr]
        mov     ax, 4301h
        int     21h
        jc      @@err
        xor     eax, eax
@@err:
        and     eax, $FFFF
        mov     [DosError], eax
end;

procedure SetFAttr(var F; Attr: Word);
begin
  TFileRec(F).Name[Length(TFileRec(F).Name) + 1] := #0;
  _setfattr(@TFileRec(F).Name[1], Attr);
end;

procedure _getftime(Han: DWord; var Time: Longint);
assembler;
      asm
        mov     ebx, [han]
        mov     ax, 5700h
        int     21h
        xor     eax, eax
        jmp     @@ok
@@err:
        xor     ecx, ecx
        xor     edx, edx
@@ok:
        and     eax, $FFFF
        mov     [DosError], eax
        mov     ebx, [time]
        mov     [ebx], cx
        mov     [ebx+2], dx
end;

procedure GetFTime(var F; var Time: Longint);
begin
  _getftime(TFileRec(F).Handle, Time);
end;

procedure _setftime(Han: DWord; Time: Longint);
assembler;
      asm
        mov     ebx, [han]
        mov     cx, Word [time]
        mov     dx, Word [time+2]
        mov     ax, 5701h
        int     21h
        xor     eax, eax
@@err:
        and     eax, $FFFF
        mov     [DosError], eax
end;

procedure SetFTime(var F; Time: Longint);
begin
  _setftime(TFileRec(F).Handle, Time);
end;

var
  SrchRec_2: DWord;
  save_80h: array [1..43] of Char;

procedure FindEnd; code;
      asm
        jc      @@ret
        mov     esi, system._psp
        add     esi, 80h
        mov     edi, srchrec_2
        movsd
        movsd
        movsd
        movsd
        movsd
        movsd
        movsd
        movsw
        mov     ebx, edi
        xor     eax, eax
        stosb
@@loop:
        lodsb
        or      al, al
        je      @@ret
        stosb
        inc     byte [ebx]
        jmp     @@loop
@@ret:
        and     eax, $FFFF
        mov     [DosError], eax

        mov     edi, system._psp
        add     edi, 80h
        mov     esi, offset save_80h
        movsd
        movsd
        movsd
        movsd
        movsd
        movsd
        movsd
        movsw
        movsd
        movsd
        movsd
        movsb
        ret
end;

procedure int_4E_4F; code;
      asm
        push    eax ebx ecx edx
        mov     r.ah, 1Ah
        mov     eax, system._psp
        shr     eax, 4
        mov     r.ds, ax
        mov     r.dx, 80h
        mov     r.ss, 0
        mov     r.sp, 0
        mov     word ptr r.flags, 0200h
        mov     edi, offset r                // offset of register structure
        xor     cx, cx                       // no parameters on stack
        mov     bx, 21h                      // call interrupt 21h
        mov     ax, 300h                     // INT 31h function 0300h
        int     31h
        pop     edx ecx ebx eax

        push    ebx ecx edx esi edi
        call    @@dsdx_copy0
        mov     r.ax, ax
        mov     ax, buf_16
        mov     r.ds, ax
        mov     ax, 0
        mov     r.dx, ax
        mov     r.cx, cx
        mov     r.ss, 0
        mov     r.sp, 0
        mov     edi, offset r                // offset of register structure
        mov     word ptr r.flags, 0200h
        xor     cx, cx                       // no parameters on stack
        mov     bx, 21h                      // call interrupt 21h
        mov     ax, 300h                     // INT 31h function 0300h
        int     31h
        pop     edi esi edx ecx ebx

        movzx   ecx, r.cx
        movzx   eax, r.ax

        push    eax
        and     word ptr [esp+12], NOT 1
        mov     ax, r.flags
        or      [esp+12], ax
        rcr     eax, 1                       // Carry flag
        pop     eax
        ret

@@dsdx_copy0:
       push     es
       push     eax ecx edx edi
       mov      ecx, 8192
       mov      edi, Buf_32
@@loop:
       mov      al, [edx]
       mov      es:[edi], al
       inc      edi
       inc      edx
       test     al, al
       loopne   @@loop
       mov      byte ptr es:[edi], 0
       pop      edi edx ecx eax
       pop      es
       ret
 end;

procedure FindFirst(const Path: String; Attr: DWORD; var SrchRec: SearchRec);
assembler;
var
  name: array [1..256] of Char;
      asm
        mov       esi, system._psp
        add       esi, 80h
        mov       edi, offset save_80h
        movsd
        movsd
        movsd
        movsd
        movsd
        movsd
        movsd
        movsw
        movsd
        movsd
        movsd
        movsb
        mov       esi, SrchRec
        mov       SrchRec_2, esi
        lea       edi, Name
        mov       edx, edi
        mov       esi, Path
        lodsb
        movzx     ecx, al
        rep       movsb
        xor       al, al
        stosb

        mov       ecx, Attr
        mov       ah, 4Eh

        call      int_4E_4F                  // emulate int 21h (4E) int 21h
        call      FindEnd
 end;

procedure FindNext(var SrchRec: SearchRec);
assembler;
      asm
        mov       esi, system._psp
        add       esi, 80h
        mov       edi, offset save_80h
        movsd
        movsd
        movsd
        movsd
        movsd
        movsd
        movsd
        movsw
        movsd
        movsd
        movsd
        movsb

        mov       esi, SrchRec
        mov       SrchRec_2, esi
        mov       edi, System._psp
        lea       edi, [edi+80h]
        mov       edx, edi
        movsd
        movsd
        movsd
        movsd
        movsd
        movsd
        movsd
        movsw
        mov       ah, 4Fh

        call      int_4E_4F                  // emulate int 21h (4F) int 21h
        call      FindEnd
 end;

procedure FindClose;
begin
  (* do nothing *)
end;

function EnvironSize: DWord; code;
      asm
        mov     esi,[System._environ]
        mov     eax,esi
@@loop:
        cmp     word [esi],0
        jz      @@quit
        inc     esi
        loop    @@loop
@@quit:
        add     esi,2
        sub     eax,esi
        neg     eax
        ret
end;


{
procedure _exec(const path: PathStr; const comline: ComStr); assembler;
var
  iname: array[0..255] of Char;
  est: DWORD;
  sst: WORD;
  asm
        lea     edi, [iname]
        mov     edx, edi
        mov     esi, [path]
        lodsb
        movzx   ecx, al
        rep     movsb
        xor     al, al
        stosb
        mov     [est], esp
        mov     [sst], ss
        mov     esi, [comline]
        xor     edi, edi
        mov     ax, 4B00h
        int     21h
        jc      @@err
        mov     esp, [est]
        mov     ss, [sst]
        xor     eax, eax
@@err:
        and     eax, $FFFF
        mov     [doserror], eax
end;
}

procedure _exec(path: String; comline: String);
var
  i, j, offset1, offset2, addr32: DWord;
  addr16, esz: DWord;
begin
  esz := EnvironSize;
  FillChar(r, SizeOf(r), 0);
  r.AH := $48;
  r.BX := (esz + 1024 + 16) shr 4;
  DosInt($21, r, 0);
  addr16 := r.AX;
  addr32 := DWord(addr16) * 16;
  if (r.Flags and 1)=1 then
  begin
    DosError := $08; // not enough DOS memory
    exit;
  end;

  FillChar(r, SizeOf(r), 0);
  FillChar(Pointer(addr32)^, esz + 1024, 0);
  move(Pointer(_environ)^, Pointer(DWord(addr32))^, esz);
  i := esz;
  offset1 := i;
  Word(Pointer(DWord(addr32) + offset1)^) := addr16;
  inc(i, 14);
  Word(Pointer(DWord(addr32) + offset1 + 2)^) := i;
  Word(Pointer(DWord(addr32) + offset1 + 4)^) := addr16;
  comline := comline + chr(13);
  for j := 0 to Length(comline) do
  begin
    Byte(Pointer(DWord(addr32) + i)^) := Byte(comline[j]);
    inc(i);
  end;
  path:=path + #0; //Char('0');
  offset2 := i;
  for j := 1 to Length(path) do
  begin
    Byte(Pointer(DWord(addr32)+i)^) := Byte(path[j]);
    inc(i);
  end;
  r.AX := $4B00;
  r.ES := addr16;
  r.DS := addr16;
  r.EBX := offset1;
  r.EDX := offset2;
  DosInt($21, r, 0);

  if (r.Flags and 1) = 1 then
    DosError:=r.AX
  else
    DosError:=0;

  FillChar(r, SizeOf(r), 0);
  r.AH := $49;
  r.ES := addr16;
  DosInt($21, r, 0);
end;

procedure Exec(Path: PathStr; Comline: ComStr);
begin
  _exec (path, comline);
end;

function  DosExitCode: DWord; assembler;
      asm
        mov     ah, 4dh
        int     21h
        movzx   eax, ax
end;

procedure Intr(IntNo: Byte; var Regs: Registers);
begin
  regs.sp := 0;
  regs.ss := 0;
  SysIO32.dosint(IntNo, Regs, 0);
end;

procedure MsDos(var Regs: Registers);
begin
  Intr($21, regs);
end;

function  EnvCount: Longint;
assembler;
      asm
        mov     edi, [System._environ]
        xor     eax, eax
        xor     edx, edx
@@loop:
        cmp     byte [edi], 0
        je      @@ret
        inc     edx
        mov     ecx, -1
        repne   scasb
        jmp     @@loop
        repne
@@ret:
        mov     eax, edx
 end;

function EnvStr(Index: Longint): String;
assembler;
      asm
        mov     edi, [System._environ]
        xor     eax, eax
@@loop:
        cmp     byte [edi], 0
        je      @@end
        dec     Index
        jle     @@end
        mov     ecx, -1
        repne   scasb
        jmp     @@loop
@@end:
        mov     esi, edi
        mov     ebx, [@Result]
        lea     edi, [ebx+1]
        mov     byte [ebx], 0
@@loop2:
        lodsb
        test    al, al
        je      @@ret
        cmp     byte [ebx], 255
        je      @@loop2
        stosb
        inc     byte [ebx]
        jmp     @@loop2
@@ret:
end;

function GetEnv(EnvVar: String): String;
var
  i: Longint;
  s: String;
  p: Longint;
begin
  for i := 1 to Length(EnvVar) do
    EnvVar [i] := UpCase(EnvVar[i]);
  for i := 1 to EnvCount do
  begin
    s := EnvStr(i);
    p := Pos('=', s);
    if (p <> 0) and (Copy(s, 1, p - 1) = EnvVar) then
    begin
     Result := Copy(s, p + 1, 255);
     exit;
    end
  end;
  Length(Result) := 0
end;

procedure SwapVectors;
var
  t: FarPointer;
   iv: int_vecs;
   ie: exc_vecs;
begin
  for iv := Low(int_vecs) to High(int_vecs) do
  begin
    GetIntVecFar(int_vecs_no[iv], t);
    SetIntVecFar(int_vecs_no[iv], int_save[iv]);
    int_save[iv] := t;
  end;
  for ie := Low(exc_vecs) to High(exc_vecs) do
  begin
    GetExcVecFar(exc_vecs_no[ie], t);
    SetExcVecFar(exc_vecs_no[ie], exc_save[ie]);
    exc_save[ie] := t;
  end;
end;

function FSearch(Path: PathStr; Dirlist: String): PathStr;
assembler;
      asm
        mov     esi, DirList
        lodsb
        movzx   ebx, al
        add     ebx, esi
        mov     edi, @result
        inc     edi
@@1:
        push    esi
        mov     esi, Path
        lodsb
        movzx   ecx, al
        rep     movsb
        xor     eax, eax
        stosb
        dec     edi
        mov     eax, 4300h
        mov     edx, @result
        inc     edx
        int     21h
        pop     esi
        jc      @@2
        test    cx, 18h
        je      @@5
@@2:
        mov     edi, @result
        inc     edi
        cmp     esi, ebx
        je      @@5
        xor     eax, eax
@@3:
        lodsb
        cmp     al, ';'
        je      @@4
        stosb
        mov     ah, al
        cmp     esi, ebx
        jne     @@3
@@4:
        cmp     ah, ':'
        je      @@1
        cmp     ah, '\'
        je      @@1
        mov     al, '\'
        stosb
        jmp     @@1
@@5:
        mov     eax, edi
        mov     edi, @result
        sub     eax, edi
        dec     eax
        stosb
@@6:
end;

function FExpand(const Path: PathStr): PathStr;
assembler;
      asm
        mov     esi, [path]
        lodsb
        movzx   ecx, al
        add     ecx, esi
        mov     edi, [@result]
        inc     edi
        lodsw
        cmp     esi, ecx
        ja      @@1
        cmp     ah, ':'
        jne     @@1
        cmp     al, 'a'
        jb      @@2
        cmp     al, 'z'
        ja      @@2
        sub     al, 20h
        jmp     @@2
@@1:
        dec     esi
        dec     esi
        mov     ah, 19h;                     // current drive
        int     21h
        add     al, 'A'
        mov     ah, ':'
@@2:
        stosw
        cmp     esi, ecx
        je      @@21
        cmp     byte [esi], '\'
        je      @@3
@@21:
        sub     al, 'A'-1
        mov     dl, al
        mov     al, '\'
        stosb
        push    esi
        mov     ah, 47h
        mov     esi, edi
        int     21h
        pop     esi
        jc      @@3
        cmp     byte [edi], 0
        je      @@3
        push    ecx
        stc
        sbb     ecx, ecx
        xor     eax, eax
        repne   scasb
        dec     edi
        mov     al, '\'
        stosb
        pop     ecx
@@3:
        sub     ecx, esi
        rep     movsb
        xor     eax, eax
        stosb

        mov     esi, [@result]
        inc     esi
        mov     edi, esi
        push    edi
@@4:
        lodsb
        test    al, al
        je      @@6
        cmp     al, '\'
        je      @@6
        cmp     al, 'a'
        jb      @@5
        cmp     al, 'z'
        ja      @@5
        sub     al, 20h
@@5:
        stosb
        jmp     @@4
@@6:
        cmp     word [edi - 2], '.\'
        jne     @@7
        dec     edi
        dec     edi
        jmp     @@9
@@7:
        cmp     word [edi-2], '..'
        jne     @@9
        cmp     byte [edi-3], '\'
        jne     @@9
        sub     edi, 3
        cmp     byte [edi-1], ':'
        je      @@9
@@8:
        dec     edi
        cmp     byte [edi], '\'
        jne     @@8
@@9:
        test    al, al
        jne     @@5
        cmp     byte [edi-1], ':'
        jne     @@10
        mov     al, '\'
        stosb
@@10:
        mov     eax, edi
        pop     edi
        sub     eax, edi
        dec     edi
        stosb
end;
{$endif}

{$ifdef __WIN32__}
type str257 = array [0..256] of Char;

var
  exec_res: DWord;


function DOSVersion: DWord;
begin
  Result := GetVersion;
end;

function GetClock: Longint;
var
  SystemTime: TSystemTime;
begin
  GetSystemTime(SystemTime);
  with SystemTime do
    Result := (((DWord(wHour) * 60) + DWord(wMinute)) * 60 + DWord(wSecond)) * 100 + DWord(wMilliseconds) div 10;
end;

procedure SetClock(Clock: Longint);
begin
  RunError;
end;

procedure GetTime(var Hour, Minute, Second, Sec100: Word);
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Hour := SystemTime.wHour;
  Minute := SystemTime.wMinute;
  Second := SystemTime.wSecond;
  Sec100 := SystemTime.wMilliseconds div 10;
end;

procedure SetTime(Hour, Minute, Second, Sec100: Word); // See AdjustTokenPrivileges
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  SystemTime.wHour := Hour;
  SystemTime.wMinute := Minute;
  SystemTime.wSecond := Second;
  SystemTime.wMilliseconds := Sec100;
  if not SetLocalTime(SystemTime) then
    DosError := GetLastError
  else
    DosError := NO_ERROR;
end;

procedure GetDate(var Year, Month, Day, DayOfWeek: Word);
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Year := SystemTime.wYear;
  Month := SystemTime.wMonth;
  Day := SystemTime.wDay;
  DayOfWeek := SystemTime.wDayOfWeek;
end;

procedure SetDate(Year, Month, Day: Word);   // See AdjustTokenPrivileges
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  SystemTime.wYear := Year;
  SystemTime.wMonth := Month;
  SystemTime.wDay := Day;
  if not SetLocalTime(SystemTime) then
    DosError := GetLastError
  else
    DosError := NO_ERROR;
end;

function DiskFree(Drive: Byte): Longint;
var
  pSectorsPerCluster,
  lpBytesPerSector,
  lpNumberOfFreeClusters,
  lpTotalNumberOfClusters: DWord;
  Path: String;
  PathPtr: PChar;
  // Win'95 OSR2 and higher
  lpVersionInformation: TOSVersionInfo;
  lpFreeBytesAvailableToCaller,
  lpTotalNumberOfBytes,
  lpTotalNumberOfFreeBytes: TLargeInteger;
begin
  if Drive > 0 then
  begin
    Path := Chr(Drive + 64) + ':\' + #0;
    PathPtr := @Path[1];
  end else
    PathPtr := nil;
  lpVersionInformation.dwOSVersionInfoSize := SizeOf(lpVersionInformation);
  GetVersionEx(lpVersionInformation);
  if (lpVersionInformation.dwPlatformId in [VER_PLATFORM_WIN32_WINDOWS, VER_PLATFORM_WIN32_NT]) and
    (LOWORD(lpVersionInformation.dwBuildNumber) > 1000) then
  begin
    if not GetDiskFreeSpaceEx(PathPtr, lpFreeBytesAvailableToCaller,
      lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes)
    then
      DosError := GetLastError
    else
      DosError := NO_ERROR;
    Result := lpTotalNumberOfFreeBytes.LowPart;
  end else
  begin
    if not GetDiskFreeSpace(PathPtr, pSectorsPerCluster, lpBytesPerSector,
      lpNumberOfFreeClusters, lpTotalNumberOfClusters)
    then
      DosError := GetLastError
    else
      DosError := NO_ERROR;
    Result := lpBytesPerSector * pSectorsPerCluster * lpNumberOfFreeClusters;
  end;
end;

function DiskFreeKB(Drive: Byte): Longint;
var
  pSectorsPerCluster,
  lpBytesPerSector,
  lpNumberOfFreeClusters,
  lpTotalNumberOfClusters: DWord;
  Path: String;
  PathPtr: PChar;
  // Win'95 OSR2 and higher
  lpVersionInformation: TOSVersionInfo;
  lpFreeBytesAvailableToCaller,
  lpTotalNumberOfBytes,
  lpTotalNumberOfFreeBytes: TLargeInteger;
begin
  if Drive > 0 then
  begin
    Path := Chr(Drive + 64) + ':\' + #0;
    PathPtr := @Path[1];
  end else
    PathPtr := nil;
  lpVersionInformation.dwOSVersionInfoSize := SizeOf(lpVersionInformation);
  GetVersionEx(lpVersionInformation);
  if (lpVersionInformation.dwPlatformId in [VER_PLATFORM_WIN32_WINDOWS, VER_PLATFORM_WIN32_NT]) and
    (LOWORD(lpVersionInformation.dwBuildNumber) > 1000) then
  begin
    if not GetDiskFreeSpaceEx(PathPtr, lpFreeBytesAvailableToCaller,
      lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes)
    then
      DosError := GetLastError
    else
      DosError := NO_ERROR;
    Result := (lpTotalNumberOfFreeBytes.HighPart shl 22) or (lpTotalNumberOfFreeBytes.LowPart shr 10);
  end else
  begin
    if not GetDiskFreeSpace(PathPtr, pSectorsPerCluster, lpBytesPerSector,
      lpNumberOfFreeClusters, lpTotalNumberOfClusters)
    then
      DosError := GetLastError
    else
      DosError := NO_ERROR;
    Result := lpBytesPerSector * pSectorsPerCluster * lpNumberOfFreeClusters div 1024;
  end;
end;

function DiskSize(Drive: Byte): Longint;
var
  pSectorsPerCluster,
  lpBytesPerSector,
  lpNumberOfFreeClusters,
  lpTotalNumberOfClusters: DWord;
  Path: String;
  PathPtr: PChar;
  // Win'95 OSR2 and higher
  lpVersionInformation: TOSVersionInfo;
  lpFreeBytesAvailableToCaller,
  lpTotalNumberOfBytes,
  lpTotalNumberOfFreeBytes: TLargeInteger;
begin
  if Drive > 0 then
  begin
    Path := Chr(Drive + 64) + ':\' + #0;
    PathPtr := @Path[1];
  end else
    PathPtr := nil;
  lpVersionInformation.dwOSVersionInfoSize := SizeOf(lpVersionInformation);
  GetVersionEx(lpVersionInformation);
  if (lpVersionInformation.dwPlatformId in [VER_PLATFORM_WIN32_WINDOWS, VER_PLATFORM_WIN32_NT]) and
    (LOWORD(lpVersionInformation.dwBuildNumber) > 1000) then
  begin
    if not GetDiskFreeSpaceEx(PathPtr, lpFreeBytesAvailableToCaller,
      lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes)
    then
      DosError := GetLastError
    else
      DosError := NO_ERROR;
    Result := lpTotalNumberOfBytes.LowPart;
  end else
  begin
    if not GetDiskFreeSpace(PathPtr, pSectorsPerCluster, lpBytesPerSector,
      lpNumberOfFreeClusters, lpTotalNumberOfClusters)
    then
      DosError := GetLastError
    else
      DosError := NO_ERROR;
    Result := lpBytesPerSector * pSectorsPerCluster * lpTotalNumberOfClusters;
  end;
end;

function DiskSizeKB(Drive: Byte): Longint;
var
  pSectorsPerCluster,
  lpBytesPerSector,
  lpNumberOfFreeClusters,
  lpTotalNumberOfClusters: DWord;
  Path: String;
  PathPtr: PChar;
  // Win'95 OSR2 and higher
  lpVersionInformation: TOSVersionInfo;
  lpFreeBytesAvailableToCaller,
  lpTotalNumberOfBytes,
  lpTotalNumberOfFreeBytes: TLargeInteger;
begin
  if Drive > 0 then
  begin
    Path := Chr(Drive + 64) + ':\' + #0;
    PathPtr := @Path[1];
  end else
    PathPtr := nil;
  lpVersionInformation.dwOSVersionInfoSize := SizeOf(lpVersionInformation);
  GetVersionEx(lpVersionInformation);
  if (lpVersionInformation.dwPlatformId in [VER_PLATFORM_WIN32_WINDOWS, VER_PLATFORM_WIN32_NT]) and
   (LOWORD(lpVersionInformation.dwBuildNumber) > 1000) then
  begin
    if not GetDiskFreeSpaceEx(PathPtr, lpFreeBytesAvailableToCaller,
      lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes)
    then
      DosError := GetLastError
    else
      DosError := NO_ERROR;
    Result := (lpTotalNumberOfBytes.HighPart shl 22) or (lpTotalNumberOfBytes.LowPart shr 10);
  end else
  begin
    if not GetDiskFreeSpace(PathPtr, pSectorsPerCluster, lpBytesPerSector,
      lpNumberOfFreeClusters, lpTotalNumberOfClusters)
    then
      DosError := GetLastError
    else
      DosError := NO_ERROR;
    Result := lpBytesPerSector * pSectorsPerCluster * lpTotalNumberOfClusters div 1024;
  end;
end;


procedure GetVerify(var Verify: Boolean);
begin
  (* Do nothing *)
end;

procedure SetVerify(Verify: Boolean);
begin
  (* Do nothing *)
end;
{$system }

procedure GetFAttr(var F; var Attr: Word);
var
  TempAttr: DWord;
  Name: array [0..MAX_PATH] of Char;
begin
  StrPCopy(@Name, TFileRec(F).Name);
  TempAttr := GetFileAttributes(@Name);
  if TempAttr <> $FFFFFFFF then
  begin
    if TempAttr = FILE_ATTRIBUTE_NORMAL then
       Attr := 0
    else
       Attr := TempAttr;
    DosError := NO_ERROR;
  end else
    DosError := GetLastError;
end;

procedure SetFAttr(var F; Attr: Word);
var
  Name: array [0..MAX_PATH] of Char;
begin
  StrPCopy(@Name, TFileRec(F).Name);
  if Attr = 0 then
    Attr := FILE_ATTRIBUTE_NORMAL;
  if SetFileAttributes(Name, Attr) = true then
    DosError := NO_ERROR
  else
    DosError := GetLastError;
end;

function DosToWinTime(DTime: Longint; var Wtime: TFileTime): Boolean;
var
  lft: TFileTime;
begin
  Result := DosDateTimeToFileTime(Longrec(dtime).Hi, LongRec(dtime).Lo, lft) and
    LocalFileTimeToFileTime(lft, Wtime);
end;

function WinToDosTime(Wtime: TFileTime; var DTime: Longint): Boolean;
var
  lft: TFileTime;
begin
  Result := FileTimeToLocalFileTime(WTime, lft) and
    FileTimeToDosDateTime(lft, LongRec(dtime).Hi,LongRec(dtime).Lo);
end;

procedure GetFTime(var F; var Time: Longint);
var
  FileTime: TFileTime;
begin
  if (GetFileTime(TFileRec(f).handle, @FileTime, nil, nil)) and
     (WinToDosTime(FileTime, Time))
  then
    DosError := NO_ERROR
  else begin
    Time := 0;
    DosError  := GetLastError;
  end;
end;

procedure SetFTime(var F; Time: Longint);
var
 FileTime: TFileTime;
begin
  if (DosToWinTime(Time, FileTime)) and
     (SetFileTime(filerec(f).Handle, nil, nil, @FileTime))
  then
    DosError := NO_ERROR
  else
    DosError := GetLastError;
end;

procedure FindClose(var SrchRec: SearchRec);
begin
  if SrchRec.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(SrchRec.FindHandle);
    DosError := NO_ERROR;
  end;
end;

procedure FindGivenFile(var SearchRec: TSearchRec);
var
  FileTime: TFileTime;
begin
  with SearchRec do
  while (ExcludeAttr and FindData.dwFileAttributes) <> 0 do
  begin
    if not FindNextFile(FindHandle, FindData) then
    begin
      DosError := GetLastError;
      exit;
    end;
  end;
  with SearchRec do
  begin
    Size := FindData.nFileSizeLow;
    Attr := FindData.dwFileAttributes;
    Name := StrPas(@FindData.cFileName);
    WinToDosTime(FindData.ftLastWriteTime, Time);
  end;
  DosError := NO_ERROR;
end;

procedure FindFirst(const Path: String; Attr: DWORD; var SrchRec: SearchRec);
var
  temp: array[0..MAX_PATH] of Char;
begin
  SrchRec.ExcludeAttr := (faHidden or faSysFile or faVolumeID or faDirectory) and (not Attr);
  SrchRec.Name := Path;
  SrchRec.Attr := Attr;
  SrchRec.FindHandle := FindFirstFile(StrPCopy(temp, Path), SrchRec.FindData);
  If SrchRec.FindHandle <> INVALID_HANDLE_VALUE then
    FindGivenFile(SrchRec)
  else
    DosError := GetLastError;
end;

procedure FindNext(var SrchRec: TSearchRec);
begin
  if FindNextFile(SrchRec.FindHandle, SrchRec.FindData) then
    FindGivenFile(SrchRec)
  else
    DosError := GetLastError;
end;

procedure Exec(Path: PathStr; Comline: ComStr);
var
  si: TStartupInfo;
  pi: TProcessInformation;
  Proc: THandle;
  AppPath, AppParam: array[0..255] of Char;
  MouseEventState, KeyboardEventState: Boolean;

  procedure StoreEvents;
  begin
    MouseEventState := thMouse;
    if thMouse then SysRemoveEvent(_MOUSE_EVENT);
    KeyboardEventState := thKeyboard;
    if thKeyboard then SysRemoveEvent(KEY_EVENT);
  end;

  procedure RestoreEvents;
  begin
    if MouseEventState then SysAddEvent(_MOUSE_EVENT);
    if KeyboardEventState then SysAddEvent(KEY_EVENT);
  end;

begin
  FillChar(SI, SizeOf(SI), 0);
  SI.cb := SizeOf(SI);
  SI.wShowWindow := 1;
  Move(Path[1], AppPath, Length(Path));
  AppPath[Length(Path)] := #0;
  AppParam[0] := '-';
  AppParam[1] := ' ';
  Move(ComLine[1], AppParam[2], Length(Comline));
  AppParam[Length(ComLine) + 2] := #0;
  StoreEvents;
  if not CreateProcess(PChar(@AppPath), PChar(@AppParam), NIL, NIL, False, $20, NIL, NIL, si, pi) then
  begin
    DosError := GetLastError;
    RestoreEvents;
    exit;
  end else
    DosError := NO_ERROR;
  RestoreEvents;
  Proc:=PI.hProcess;
  CloseHandle(PI.hThread);
  if WaitForSingleObject(Proc, Infinite) <> $FFFFFFFF then
    GetExitCodeProcess(Proc, exec_res)
  else
    exec_res := DWord(-1);
  CloseHandle(Proc);
end;

function  DosExitCode: DWord;
begin
  Result := exec_res;
end;

function EnvCount: Longint;
var
  p: PChar;
begin
  p :=_environ;
  Result := 0;
  repeat
    if p^ = #0 then break;
    repeat
      inc(p)
    until p^ = #0;
    inc(p);
    Result +:= 1;
  until FALSE;
end;

function EnvStr(Index: Longint): String;
var
  p: PChar;
  i: Longint;
begin
  p := _environ;
  Length(Result) := 0;
  inc(Index);
  for i := 1 to Index do
  begin
    Length(Result) := 0;
    if p^ = #0 then Break;
    repeat
      Result +:= p^;
      Inc(p);
    until p^ = #0;
    inc(p);
  end;
end;

function FExpand(const Path: PathStr): PathStr;
var
  Buffer, Temp: array[0..MAX_PATH] of Char;
  Name: PChar;
begin
  GetFullPathName(StrPCopy(Temp, Path), SizeOf(Buffer), Buffer, Name);
  Result := StrPas(Buffer);
end;

function GetEnv(EnvVar: String): String;
var
  i: Longint;
  s: String;
  p: Longint;
begin
  EnvVar := UpperCase(EnvVar);
  for i := 1 to EnvCount do
  begin
    s := EnvStr(i);
    p := Pos('=', s);
    if (p <> 0) and (UpperCase(Copy(s, 1, p - 1)) = EnvVar) then
    begin
     Result := Copy(s, p + 1, 255);
     exit;
    end
  end;
  Length(Result) := 0
end;

function FSearch(Path: PathStr; Dirlist: String): PathStr;
var
  name: String;
  p: Longint;
  ff_buf: SearchRec;
begin
  Length(Result) := 0;
  name := Path;
  repeat
    FindFirst(name, AnyFile, ff_buf);
    if DosError = 0 then
    begin
      Result := name;
      break;
    end else begin
      if Length(DirList) = 0 then break;
      p := Pos(';', DirList);
      if p <> 0 then
      begin
        name := Copy(DirList, 1, p - 1) + '\' + Path;
        DirList := Copy(DirList, p + 1, 255);
      end else begin
        name := DirList + '\' + Path;
        Length(DirList) := 0;
      end
    end
  until FALSE;
end;
{$endif}

{ Common }
procedure Keep(ExitCode: DWord);
begin
  RunError;
end;

{$ifndef __DOS__}
procedure GetCBreak(var Break: Boolean);
begin
 (* Do nothing *)
end;

procedure SetCBreak(Break: Boolean);
begin
  (* Do nothing *)
end;

procedure SwapVectors;
begin
  (* Do nothing *)
end;
{$endif}

procedure UnpackTime(Src: Longint; var Dst: DateTime); code;
      asm
        mov     esi, src
        mov     edi, dst
        mov     eax, esi
        shr     eax, 25
        add     eax, 1980
        stosw
        mov     eax, esi
        shr     eax, 21
        and     eax, 0Fh
        stosw
        mov     eax, esi
        shr     eax, 16
        and     eax, 1Fh
        stosw
        mov     eax, esi
        shr     eax, 11
        and     eax, 1Fh
        stosw
        mov     eax, esi
        shr     eax, 5
        and     eax, 3Fh
        stosw
        mov     eax, esi
        and     eax, 1Fh
        shl     eax, 1
        stosw
        ret
end;

procedure PackTime(var Src: DateTime; var Dst: Longint); code;
      asm
        mov     esi, src
        xor     eax, eax
        lodsw
        sub     eax, 1980
        mov     edi, eax
        shl     edi, 4
        lodsw
        add     edi, eax
        shl     edi, 5
        lodsw
        add     edi, eax
        shl     edi, 5
        lodsw
        add     edi, eax
        shl     edi, 6
        lodsw
        add     edi, eax
        shl     edi, 5
        lodsw
        shr     eax, 1
        add     edi, eax
        mov     eax, dst
        mov     [eax], edi
        ret
end;

procedure FSplit(const Path: PathStr; var Dir: DirStr; var Name: NameStr; var Ext: ExtStr); assembler;
      asm
        mov     esi, [path]
        lodsb
        movzx   edx, al
        mov     ebx, edx
        test    ebx, ebx
        je      @@2
@@1:
        cmp     byte [esi+ebx-1], '\'
        je      @@2
        cmp     byte [esi+ebx-1], ':'
        je      @@2
        dec     ebx
        jne     @@1
@@2:
{$IFDEF __OS2__}
        mov     eax, 255
{$ENDIF}
{$IFDEF __WIN32__}
        mov     eax, MAX_PATH
{$ENDIF}
{$IFDEF __DOS__}
        mov     eax, 67
{$ENDIF}
        mov     edi, [dir]
        call    assn_str
        xor     ebx, ebx
        jmp     @@4
@@3:
        cmp     byte [esi+ebx], '.'
        je      @@5
        inc     ebx
@@4:
        cmp     ebx, edx
        jne     @@3
@@5:
{$IFDEF __OS2__}
        mov     eax, 255
{$ENDIF}
{$IFDEF __WIN32__}
        mov     eax, MAX_PATH
{$ENDIF}
{$IFDEF __DOS__}
        mov     eax, 8
{$ENDIF}
        mov     edi, [name]
        call    assn_str
        mov     ebx, edx
        mov     eax, 4
        mov     edi, [ext]
        call    assn_str
end;
{$ENDIF}

end.