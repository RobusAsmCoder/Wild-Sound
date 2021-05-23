(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       GET_XXX.INP for System Unit                            *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995,99 TMT Development Corporation      *)
(*       Authors: Anton Moscal, Vadim Bodrov                    *)
(*                                                              *)
(****************************************************************)

{$ifdef interface}

function %sys_val_int64 (const src: string; var code): int64;
function %sys_val_int   (const src: string; var code): Longint;
function %sys_val_real  (const src: string; var code): Extended;

{$else}

function val_init(const s: String; var neg: Boolean; var Base: DWORD): Longint;
var
  Code : Longint := 1;
begin
  neg := FALSE;
  while (s[Code] in [' ',#9]) and (Code <= length(s)) do Code +:= 1;
  case s[Code] of
   '-' : begin
           neg := TRUE;
           Code +:= 1;
         end;
   '+' : Code +:= 1;
  end;
  Base := $0A;
  if Code <= length(s) then
  begin
    case s[Code] of
     '$' : begin
             Base := $10;
             repeat
               Code +:= 1;
             until (Code >= length(s)) or (s[Code] <> '0');
             //if length(s) - Code > 7 then Code +:= 8;
           end;
     '%' : begin
             Base := 2;
             Code +:= 1;
           end;
    end;
  end;
  Result := Code;
end;

function get_int(const s: String; var Code: Longint): Longint;
var
  Base, Temp: DWORD;
  neg: Boolean;
  Res: Longint := 0;
begin
  Code := val_init(s, neg, Base);
  if Code > length(s) then exit;
  if (neg) and (s = '-2147483648') then
  begin
    Code := 0;
    Result := $80000000;
    exit;
  end;
  while Code <= Length(s) do
  begin
    Temp := ord(s[Code]);
    case Temp of
      48..57  : Temp -:= 48;
      65..70  : Temp -:= 55;
      97..104 : Temp -:= 87;
    else
      Temp := $10;
    end;
    Res := Res * Longint(Base);
    if (Temp >= Base) or ((Base = $0A) and (High(Longint) - Res < longint(Temp))) then
    begin
      Result := 0;
      exit;
    end;
    Res +:= Temp;
    Code +:= 1;
  end;
  Code := 0;
  if neg then
    Result := -Res
  else
    Result := +Res;
end;

function get_int64(const s: String; var Code: Longint): int64;
var
  Base: DWORD;
  Temp: DWORD;
  neg:  Boolean;
  Res:  Int64 := 0;
begin
  Code := val_init(s, neg, Base);
  if Code > length(s) then exit;
  if (neg) and (s = '-9223372036854775808') then
  begin
    Code := 0;
    Result := $80000000;
    exit;
  end;
  while Code <= Length(s) do
  begin
    Temp := ord(s[Code]);
    case Temp of
      48..57  : Temp -:= 48;
      65..70  : Temp -:= 55;
      97..104 : Temp -:= 87;
    else
      Temp := $10;
    end;
    Res := Res * int64(Base);
    if (Temp >= Base) or ((Base = $0A) and (MAXINT64 - Res < int64 (Temp))) then
    begin
      Result := 0;
      exit;
    end;
    Res := Res + Temp;
    Code +:= 1;
  end;
  Code := 0;
  if neg then
    Result := -Res
  else
    Result := +Res;
end;

function %sys_val_int64 (const src: string; var code): int64;
begin
  Result := get_int64(src, longint (code));
end;

function %sys_val_int(const Src: string; var code): Longint;
begin
  Result := get_int(src, longint (code));
end;

function get_real(s: String; var Code : Longint): Extended;
const
  MaxArray: array[0..9] of Byte =
  (
   $E7, $F7, $79, $FF, $BD, $88, $5A, $BD, $FB, $7F
  );
  MinArray: array[0..9] of Byte =
  (
   $BD, $35, $F2, $06, $16, $B1, $CD, $A1, $04, $00
  );
var
  MaxExt10: Extended absolute MaxArray; // = MaxExtended / 10
  MinExt10: Extended absolute MinArray; // = MaxExtended * 10
var
  Res: Extended := 0.0;
  eSign: Extended := 1.0;
  Sign: Extended := 1.0;
  i: DWORD;               // DWORD types are important to correctly
  Exponent: DWORD := 0;   // control exponent overflow
  Flag: Boolean := FALSE;
  Temp: Extended;
begin
  Code := 1;
  while (s[Code] in [' ',#9]) and (Code <= length(s)) do Code +:= 1;
  case s[Code] of
    '+' : inc(Code);
    '-' : begin
            Sign := -1.0;
            Code +:= 1;
          end;
  end;
  while (s[Code] in ['0'..'9']) and (Code <= Length(s)) do
  begin
    Flag := TRUE;
    Res := Res * 10;
    Res := Res + (ord(s[Code]) - ord('0'));
    Code +:= 1;
  end;
  if (s[Code] = '.') and (length(s) >= Code) then
  begin
    Temp := 0.1;
    Code +:= 1;
    if length(s) < Code then
      S := S + '0';
    if not (s[Code] in ['0'..'9']) then
    begin
      Result := 0.0;
      exit;
    end;
    while (s[Code] in ['0'..'9']) and (length(s) >= Code) do
    begin
      Flag := TRUE;
      Res := Res + Temp * (ord(s[Code]) - ord('0'));
      Temp := Temp / 10.0;
      Code +:= 1;
    end;
  end;
  if not Flag then
  begin
    Result := 0.0;
    exit;
  end;
  if (LoCase(s[Code]) = 'e') and (length(s) >= Code) then
  begin
    Code +:= 1;
    if s[Code] = '+' then
      Code +:= 1
    else if s[Code] = '-' then
    begin
      eSign := -1;
      Code +:= 1;
    end;
    if not(s[Code] in ['0'..'9']) or (length(s) < Code) then
    begin
      Result := 0.0;
      exit;
    end;
    while (s[Code] in ['0'..'9']) and (length(s) >= Code) do
    begin
      Exponent := ord(s[Code]) - ord('0') + Exponent * 10;
      Code +:= 1;
    end;
  end;
  if eSign > 0 then
  begin
    for i := 1 to Exponent do
    begin
      if Res < MaxExt10 then
        Res := Res * 10
      else
      begin
        Result := 0;
        exit;
      end;
    end;
  end else
  begin
    for i := 1 to Exponent do
    begin
      if Res > MinExt10 then
        Res := Res / 10
      else
      begin
        Result := 0;
        exit;
      end;
    end;
  end;
  if length(s) >= Code then
  begin
    Result := 0.0;
    exit;
  end;
  Code := 0;
  Result := Res * Sign;
end;

function %sys_val_real(const src: string; var code): Extended;
var
  r: Longint;
begin
  Result := get_real(src, longint (code));
end;
{$endif}