(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       SWAP_FUN.INC for System Unit                           *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Author: Anton Moscal, Vadim Bodrov                     *)
(*                                                              *)
(****************************************************************)

{$ifdef interface}

function %SwapLong(n: Longint): Longint;
overload Swap = %SwapLong;
function %SwapSmall(n: SmallInt): SmallInt;
overload Swap = %SwapSmall;

procedure %SwapArgsR(var A, B: Real48);
overload SwapArgs = %SwapArgsR;
procedure %SwapArgsS(var A, B: Single);
overload SwapArgs = %SwapArgsS;
procedure %SwapArgsD(var A, B: Double);
overload SwapArgs = %SwapArgsD;
procedure %SwapArgsE(var A, B: Extended);
overload SwapArgs = %SwapArgsE;
procedure %SwapArgsC(var A, B: Char);
overload SwapArgs = %SwapArgsC;
procedure %SwapArgsSS(var A, B: String);
overload SwapArgs = %SwapArgsSS;
procedure %SwapArgsB(var A, B: Byte);
overload SwapArgs = %SwapArgsB;
procedure %SwapArgsW(var A, B: Word);
overload SwapArgs = %SwapArgsW;
procedure %SwapArgsDW(var A, B: DWORD);
overload SwapArgs = %SwapArgsDW;
procedure %SwapArgsI(var A, B: SmallInt);
overload SwapArgs = %SwapArgsI;
procedure %SwapArgsL(var A, B: Longint);
overload SwapArgs = %SwapArgsL;
procedure %SwapArgsLL(var A, B: Int64);
overload SwapArgs = %SwapArgsLL;
procedure %SwapArgsP(var A, B: Pointer);
overload SwapArgs = %SwapArgsP;

{$else}

function %SwapSmall; code;
      asm
        mov     ax, [n]
        ror     ax, 8
        ret
end;

function %SwapLong; code;
      asm
        mov     eax, [n]
        ror     eax, 16
        ret
end;

procedure %SwapArgsR(var A, B: Real48);
var
  temp: Real;
begin
  temp := A;
  A := B;
  B := temp;
end;

procedure %SwapArgsS(var A, B: Single);
var
  temp: Single;
begin
  temp := A;
  A := B;
  B := temp;
end;

procedure %SwapArgsD(var A, B: Double);
var
  temp: Double;
begin
  temp := A;
  A := B;
  B := temp;
end;

procedure %SwapArgsE(var A, B: Extended);
var
  temp: Extended;
begin
  temp := A;
  A := B;
  B := temp;
end;

procedure %SwapArgsC(var A, B: Char);
var
  temp: Char;
begin
  temp := A;
  A := B;
  B := temp;
end;

procedure %SwapArgsSS(var A, B: String);
var
  temp: String;
begin
  temp := A;
  A := B;
  B := temp;
end;

procedure %SwapArgsB(var A, B: Byte);
var
  temp: Byte;
begin
  temp := A;
  A := B;
  B := temp;
end;

procedure %SwapArgsW(var A, B: Word);
var
  temp: Word;
begin
  temp := A;
  A := B;
  B := temp;
end;

procedure %SwapArgsDW(var A, B: DWORD);
var
  temp: Word;
begin
  temp := A;
  A := B;
  B := temp;
end;

procedure %SwapArgsI(var A, B: SmallInt);
var
  temp: SmallInt;
begin
  temp := A;
  A := B;
  B := temp;
end;

procedure %SwapArgsL(var A, B: Longint);
var
  temp: Longint;
begin
  temp := A;
  A := B;
  B := temp;
end;

procedure %SwapArgsLL(var A, B: Int64);
var
  temp: Int64;
begin
  temp := A;
  A := B;
  B := temp;
end;

procedure %SwapArgsP(var A, B: Pointer);
var
  temp: Pointer;
begin
  temp := A;
  A := B;
  B := temp;
end;

{$endif}
