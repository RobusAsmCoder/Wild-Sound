(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Arg Private Unit                                       *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Authors: Anton Moscal, Vadim Bodrov                    *)
(*                                                              *)
(****************************************************************)

unit Arg;

interface

function Argc: DWord;
function Argv(I: DWord): string;
function Args: string;

implementation

uses SysIO32, Strings {$ifdef __WIN32__}, Windows {$endif} {$ifdef __OS2__}, DosCall {$endif};

var
  PP        : PChar;
  ProgName  : PChar;
  Plen      : LongInt;

const
  InitFlg        : Boolean  = false;
  Argcount       : LongInt  = -1;
  Arg_quote_char : Char = '"';

procedure ArgInit;
{$ifdef __OS2__}
var
  Process: PPib;
  Thread : PTib;
{$endif}
begin
{$ifdef __OS2__}
  DosGetInfoBlocks (Thread,Process);
  PP    := Process^.Pib_pchCmd;
  ProgName  := PP;
  PLen := 0;
  while PP^ <> #0 do Inc(PP);
  Inc(PP);
  while PP[PLen] <> #0 do PLen +:= 1;
  if Plen <> 0 then Plen -:= 1;
{$endif}

{$ifdef __DOS__}
  ProgName :=  ExeName;
  PP       :=  PChar(_psp) + $81;
  PLen     :=  $FF and Byte((Pointer(_psp) + $80)^);
  Plen -:= 1;
  PP [PLen+1] := #0;
{$endif}

{$ifdef __WIN32__}
  PP := GetCommandLine;

  ProgName  := PP;
  PLen      := 0;

  while PP[PLen] <> #0 do PLen +:= 1;
  if Plen <> 0 then Plen -:= 1;
{$endif}
  InitFlg := true;
end;

type EachProc = procedure(const S: string);

procedure Each_Arg(procedure Yield (const s: string));
const
  White_space = [' ',Chr(9)];
  Delimiters  = White_space;

Var
  Q:  string;
  S:  string;
  C:  Char;
  I:  DWord;
  QC: Char;

label 1;

procedure AddC; if Length(Q) < High (Q) then q +:= c;

function End_Of_String: Boolean; End_Of_String := (i > Plen);
begin
  QC := Arg_quote_char;
  Length(Q) := 0;
  I := 0;

  while (i <= plen) and (pp [i] in white_space) do i +:= 1;

  while i <= Plen do
  begin
    C := PP[I];
    if C in Delimiters then
    begin
      if (Length(Q) > 0) or not (C in White_space) then
      begin
        Yield (Q);
        Length (Q) := 0;
      end;
    end else
      if C = QC then
      begin
        i +:= 1;
1:      while not (i > Plen) do
        begin
          C := PP[i];
          i +:= 1;
          if C = QC then break;
          AddC;
        end;
        if not (I > Plen) then
          if PP [I] = QC then
          begin
            AddC;
            i +:= 1;
            goto 1;
          end else
            i -:= 1;
      end else
        AddC;
        i +:= 1;
  end;
  if Length(Q) > 0 then Yield(Q);
end;

function Argc: DWord;
begin
  if not InitFlg then
    ArgInit;
  if Argcount < 0 then
  begin
    Argcount := 0;
    Each_arg(begin argcount +:= 1 end);
  end;
  Argc := Argcount;
end;

function Argv(i: DWord): string;
label
  ProcExit;
var
  Cnt: LongInt;
  J:   DWord;
  Ptr: PChar;
begin
  if not InitFlg then
    ArgInit;
  if I = 0 then
  begin
    Ptr := ProgName;
    Argv := '';
    J := 1;
    while Ptr^ <> Chr(0) do
    begin
      Result[J] := Ptr^;
      J +:= 1; Inc (Ptr);
    end;
    Length(Result) := J - 1;
    exit;
  end;
  Cnt := 0;
  Each_arg(begin Cnt +:= 1; if Cnt = I then begin Result := S; goto ProcExit; end; end);
  Result := '';
ProcExit:
end;

function Args: string;
var
  S : string;
begin
  if not InitFlg then ArgInit;
  Length(S) := PLen + 1;
  Move(PP^, S [1], PLen + 1);
  Args := S;
end;

end.
