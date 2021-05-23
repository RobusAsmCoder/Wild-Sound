(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Math Unit v.2.0                                        *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit Math;

interface

const
  MaxDoubleArray: array[0..7] of Byte =
    ($76, $3B, $77, $30, $D1, $42, $EE, $7F);
  MinDoubleArray: array[0..7] of Byte =
    ($01, $00, $00, $00, $00, $00, $00, $00);
  MaxExtendedArray: array[0..9] of Byte =
    ($E1, $75, $58, $7F, $ED, $2A, $B1, $EC, $FE, $7F);
  MinExtendedArray: array[0..9] of Byte =
    ($64, $91, $8E, $05, $78, $5A, $71, $81, $01, $00);

var
  MaxDouble:   Double   absolute MaxDoubleArray;
  MinDouble:   Double   absolute MinDoubleArray;
  MaxExtended: Extended absolute MaxExtendedArray;
  MinExtended: Extended absolute MinExtendedArray;

const
  MinSingle   = 1.5E-45;
  MaxSingle   = 3.4E+38;

  HalfLnMax   = 3.54863405227661E+0002;
  Deg2Rad     = 1.74532925199433E-0002;
  Rad2Deg     = 5.72957795130823E+0001;
  Grad2Rad    = 1.57079632679490E-0002;
  Rad2Grad    = 6.36619772367581E+0001;
  DoublePI    = 6.28318530717959E+0000;
  e           = 2.71828182845905E+0000;

type
  TPoly = record
    Neg, Pos, DNeg, DPos: Extended
  end;

{$system}

function  %CeilE(Value: Extended): Extended;
overload  Ceil = %CeilE;
function  %CeilL(Value: Extended): Longint;
overload  Ceil = %CeilL;
function  %FloorE(Value: Extended): Extended;
overload  Floor = %FloorE;
function  %FloorL(Value: Extended): Longint;
overload  Floor = %FloorL;
function  %SgnE(Value: Extended): Longint;
overload  Sgn = %SgnE;
function  %SgnL(Value: LongInt): Longint;
overload  Sgn = %SgnL;
function  Ldexp(X: Extended; P: Longint): Extended;
procedure %FrexpD(X: Extended; var Mantissa: Extended; var Exponent: Longint);
overload  Frexp = %FrexpD;
function  %FrexpC(X: Extended; var Exponent: Longint): Extended;
overload  Frexp = %FrexpC;

function  Fmod(X, Y: Extended): Extended;
function  %ModfL(X: Extended; var Y: Longint): Extended;
overload  Modf = %ModfL;
function  %ModfI(X: Extended; var Y: SmallInt): Extended;
overload  Modf = %ModfI;
function  LRotL(value, shift: DWORD): DWORD;
function  LRotR(value, shift: DWORD): DWORD;
function  ChgSign(X: Extended): Extended;
function  CopySign(X, Y: Extended): Extended;

procedure %PolyXR(const Vector: array of Real; X: Extended; var Poly: TPoly);
overload  PolyX = %PolyXR;
procedure %PolyXS(const Vector: array of Single; X: Extended; var Poly: TPoly);
overload  PolyX = %PolyXS;
procedure %PolyXD(const Vector: array of Double; X: Extended; var Poly: TPoly);
overload  PolyX = %PolyXD;
procedure %PolyXE(const Vector: array of Extended; X: Extended; var Poly: TPoly);
overload  PolyX = %PolyXE;

{ Angle unit conversion routines }
function  DegToRad(Degrees: Extended): Extended;
function  RadToDeg(Radians: Extended): Extended;
function  GradToRad(Grads: Extended): Extended;
function  RadToGrad(Radians: Extended): Extended;
function  CycleToRad(Cycles: Extended): Extended;
function  RadToCycle(Radians: Extended): Extended;

{ Measure unit conversion routines }
function  CelsToFahr(Value: Extended): Extended;
function  FahrToCels(Value: Extended): Extended;
function  GalToLitre(Value: Extended): Extended;
function  LitreToGal(Value: Extended): Extended;
function  InchToCm(Value: Extended): Extended;
function  CmToInch(Value: Extended): Extended;
function  LbToKg(Value: Extended): Extended;
function  KgToLb(Value: Extended): Extended;

{ Trigonometric functions }
function  Tan(X: Extended): Extended;
function  Cotan(X: Extended): Extended;
function  Hypot(X, Y: Extended): Extended;
function  Csc(X: Extended): Extended;
function  Sec(X: Extended): Extended;
function  ArcTan2(Y, X: Extended): Extended;
function  ArcCos(X: Extended): Extended;
function  ArcSin(X: Extended): Extended;
function  ArcCotan(X: Extended): Extended;
function  ArcSec(X: Extended): Extended;
function  ArcCsc(X: Extended): Extended;

{ Hyperbolic functions and inverses }
function  Cosh(X: Extended): Extended;
function  Sinh(X: Extended): Extended;
function  Tanh(X: Extended): Extended;
function  Sech(X: Extended): Extended;
function  Csch(X: Extended): Extended;
function  ArcCosh(X: Extended): Extended;
function  ArcSinh(X: Extended): Extended;
function  ArcTanh(X: Extended): Extended;
function  ArcCotanh(X: Extended): Extended;
function  ArcSech(X: Extended): Extended;
function  ArcCsch(X: Extended): Extended;

{ Logorithmic functions }
function  Log10(X: Extended): Extended;
function  Log2(X: Extended): Extended;
function  LogN(X, Base: Extended): Extended;
function  %PowerE(Base, Exponent: Extended): Extended;
overload  Power = %PowerE;
function  IntPower(X: Extended; N: Longint): Extended;
overload  Power = IntPower;

{ Percentage calculation }
function  Percent(Value1, Value2: Extended): Extended;
function  DeltaPercent(Value1, Value2: Extended): Extended;

{ Statistic functions }
function  %MaxE(A, B: Extended): Extended;
overload  Max = %MaxE;
function  %MaxL(A, B: Longint): Longint;
overload  Max = %MaxL;

function  %MinE(A, B: Extended): Extended;
overload  Min = %MinE;
function  %MinL(A, B: Longint): Longint;
overload  Min = %MinL;

function  %MaxValueR(const Vector: array of Real): Real;
overload  MaxValue = %MaxValueR;
function  %MaxValueS(const Vector: array of Single): Single;
overload  MaxValue = %MaxValueS;
function  %MaxValueD(const Vector: array of Double): Double;
overload  MaxValue = %MaxValueD;
function  %MaxValueE(const Vector: array of Extended): Extended;
overload  MaxValue = %MaxValueE;
function  MaxIntValue(const Vector: array of Longint): Longint;
overload  MaxValue = MaxIntValue;

function  %MinValueR(const Vector: array of Real): Real;
overload  MinValue = %MinValueR;
function  %MinValueS(const Vector: array of Single): Single;
overload  MinValue = %MinValueS;
function  %MinValueD(const Vector: array of Double): Double;
overload  MinValue = %MinValueD;
function  %MinValueE(const Vector: array of Extended): Extended;
overload  MinValue = %MinValueE;
function  MinIntValue(const Vector: array of Longint): Longint;
overload  MinValue = MinIntValue;

function  %SumR(const Vector: array of Real): Extended;
overload  Sum = %SumR;
function  %SumS(const Vector: array of Single): Extended;
overload  Sum = %SumS;
function  %SumD(const Vector: array of Double): Extended;
overload  Sum = %SumD;
function  %SumE(const Vector: array of Extended): Extended;
overload  Sum = %SumE;
function  SumInt(const Vector: array of Longint): Longint;
overload  Sum = SumInt;

function  %SumOfSquaresR(const Vector: array of Real): Extended;
overload  SumOfSquares = %SumOfSquaresR;
function  %SumOfSquaresS(const Vector: array of Single): Extended;
overload  SumOfSquares = %SumOfSquaresS;
function  %SumOfSquaresD(const Vector: array of Double): Extended;
overload  SumOfSquares = %SumOfSquaresD;
function  %SumOfSquaresE(const Vector: array of Extended): Extended;
overload  SumOfSquares = %SumOfSquaresE;
function  %SumOfSquaresL(const Vector: array of Longint): Longint;
overload  SumOfSquares = %SumOfSquaresL;

procedure %SumsAndSquaresR(const Vector: array of Real; var Sum, SumOfSquares: Extended);
overload  SumsAndSquares = %SumsAndSquaresR;
procedure %SumsAndSquaresS(const Vector: array of Single; var Sum, SumOfSquares: Extended);
overload  SumsAndSquares = %SumsAndSquaresS;
procedure %SumsAndSquaresD(const Vector: array of Double; var Sum, SumOfSquares: Extended);
overload  SumsAndSquares = %SumsAndSquaresD;
procedure %SumsAndSquaresE(const Vector: array of Extended; var Sum, SumOfSquares: Extended);
overload  SumsAndSquares = %SumsAndSquaresE;
procedure %SumsAndSquaresL(const Vector: array of Longint; var Sum, SumOfSquares: Longint);
overload  SumsAndSquares = %SumsAndSquaresL;

function  %MeanR(const Vector: array of Real): Extended;
overload  Mean = %MeanR;
function  %MeanS(const Vector: array of Single): Extended;
overload  Mean = %MeanS;
function  %MeanD(const Vector: array of Double): Extended;
overload  Mean = %MeanD;
function  %MeanE(const Vector: array of Extended): Extended;
overload  Mean = %MeanE;
function  %MeanL(const Vector: array of Longint): Extended;
overload  Mean = %MeanL;

function  %TotalVarianceR(const Vector: array of Real): Extended;
overload  TotalVariance = %TotalVarianceR;
function  %TotalVarianceS(const Vector: array of Single): Extended;
overload  TotalVariance = %TotalVarianceS;
function  %TotalVarianceD(const Vector: array of Double): Extended;
overload  TotalVariance = %TotalVarianceD;
function  %TotalVarianceE(const Vector: array of Extended): Extended;
overload  TotalVariance = %TotalVarianceE;

function  %VarianceR(const Vector: array of Real): Extended;
overload  Variance = %VarianceR;
function  %VarianceS(const Vector: array of Single): Extended;
overload  Variance = %VarianceS;
function  %VarianceD(const Vector: array of Double): Extended;
overload  Variance = %VarianceD;
function  %VarianceE(const Vector: array of Extended): Extended;
overload  Variance = %VarianceE;

function  %PopnVarianceR(const Vector: array of Real): Extended;
overload  PopnVariance = %PopnVarianceR;
function  %PopnVarianceS(const Vector: array of Single): Extended;
overload  PopnVariance = %PopnVarianceS;
function  %PopnVarianceD(const Vector: array of Double): Extended;
overload  PopnVariance = %PopnVarianceD;
function  %PopnVarianceE(const Vector: array of Extended): Extended;
overload  PopnVariance = %PopnVarianceE;

function  %PopnStdDevR(const Vector: array of Real): Extended;
overload  PopnStdDev = %PopnStdDevR;
function  %PopnStdDevS(const Vector: array of Single): Extended;
overload  PopnStdDev = %PopnStdDevS;
function  %PopnStdDevD(const Vector: array of Double): Extended;
overload  PopnStdDev = %PopnStdDevD;
function  %PopnStdDevE(const Vector: array of Extended): Extended;
overload  PopnStdDev = %PopnStdDevE;

function  %NormR(const Vector: array of Real): Extended;
overload  Norm = %NormR;
function  %NormS(const Vector: array of Single): Extended;
overload  Norm = %NormS;
function  %NormD(const Vector: array of Double): Extended;
overload  Norm = %NormD;
function  %NormE(const Vector: array of Extended): Extended;
overload  Norm = %NormE;

function  RandG(Mean, StdDev: Extended): Extended;

{ Business functions }
function  Sln(InitialValue, Residue: Extended; Time: DWord): Extended;
function  Syd(InitialValue, Residue: Extended; Period, Time: DWord): Extended;
function  Cterm(Rate: Extended; FutureValue, PresentValue: Extended): Extended;
function  Term(Payment: Extended; Rate: Extended; FutureValue: Extended): Extended;
function  Pmt(Principal: Extended; Rate: Extended; Term: DWord): Extended;
function  Rate(FutureValue, PresentValue: Extended; Term: DWord): Extended;
function  Pv(Payment: Extended; Rate: Extended; Term: DWord): Extended;
function  Npv(Rate: Extended; Series: array of Double): Extended;
function  Fv(Payment: Extended; Rate: Extended; Term: DWord): Extended;

{ Evaluate procedure }
procedure Evaluate(Expr: String; var Result: Extended; var ErrCode: Longint);

implementation

uses Strings;

{$system}

const
  FAND_MASK = $0000F3FF;
  FORU_MASK = $00000800;
  FORD_MASK = $00000400;

function %CeilL(Value: Extended): Longint; code;
asm
        fld     tbyte ptr [esp + 4]
        fstcw   word ptr [esp + 4]
        fwait
        movzx   eax, word ptr [esp + 4]
        and     eax, FAND_MASK
        or      eax, FORU_MASK
        xchg    ax, word ptr [esp + 4]
        fldcw   word ptr [esp + 4]
        frndint
        fistp   dword ptr [esp + 8]
        fwait
        xchg    ax, word ptr [esp + 4]
        fldcw   word ptr [esp + 4]
        mov     eax,dword ptr [esp + 8]
        ret     12
end;

function %CeilE(Value: Extended): Extended; code;
asm
        fld     tbyte ptr [esp + 4]
        fstcw   word ptr [esp + 4]
        fwait
        movzx   eax, word ptr [esp + 4]
        and     eax, FAND_MASK
        or      eax, FORU_MASK
        xchg    ax, word ptr [esp + 4]
        fldcw   word ptr [esp + 4]
        frndint
        ret     12
end;

function %FloorL(Value: Extended): Longint; code;
asm
        fld     tbyte ptr [esp + 4]
        fstcw   word ptr [esp + 4]
        fwait
        movzx   eax, word ptr [esp + 4]
        and     eax, FAND_MASK
        or      eax, FORD_MASK
        xchg    ax, word ptr [esp + 4]
        fldcw   word ptr [esp + 4]
        frndint
        fistp   dword ptr [esp + 8]
        fwait
        xchg    ax, word ptr [esp + 4]
        mov     eax,dword ptr [esp + 8]
        ret     12
end;

function %FloorE(Value: Extended): Extended; code;
asm
       fld     tbyte ptr [esp + 4]
       fstcw   word ptr [esp + 4]
       fwait
       movzx   eax, word ptr [esp + 4]
       and     eax, FAND_MASK
       or      eax, FORD_MASK
       xchg    ax, word ptr [esp + 4]
       fldcw   word ptr [esp + 4]
       frndint
       ret     12
end;

function %SgnE(Value: Extended): Longint;
begin
  if Value < 0.0 then
    Result := -1
  else if Value > 0.0 then
    Result := 1
  else
    Result := 0
end;

function %SgnL(Value: LongInt): Longint;
begin
  if Value < 0 then
    Result := -1
  else if Value > 0 then
    Result := 1
  else
    Result := 0
end;

function Ldexp(X: Extended; P: Longint): Extended; code;
      asm
        fild    dword ptr [esp + 4]
        fld     tbyte ptr [esp + 8]
        fscale
        fstp    st(1)
        fwait
        ret     16
end;

procedure %FrexpD(X: Extended; var Mantissa: Extended; var Exponent: Longint); code;
      asm
        fld     tbyte ptr [esp + 12]
        mov     edi, dword ptr [esp + 4]
        mov     dword ptr [edi], 0
        ftst
        fstsw   ax
        fwait
        sahf
        jz      @@Quit
        fxtract
        fxch
        fistp   dword ptr [edi]
        fld1
        fchs
        fxch
        fscale
        inc     dword ptr [edi]
        fstp    st(1)
@@Quit:
        mov     eax, [esp+8]
        fstp    tbyte ptr [eax]
        fwait
        ret     12
end;

function %FrexpC(X: Extended; var Exponent: Longint): Extended; code;
      asm
        fld     tbyte ptr [esp + 8]
        mov     edi, dword ptr [esp + 4]
        mov     dword ptr [edi], 0
        ftst
        fstsw   ax
        fwait
        sahf
        jz      @@Quit
        fxtract
        fxch
        fistp   dword ptr [edi]
        fld1
        fchs
        fxch
        fscale
        inc     dword ptr [edi]
        fstp    st(1)
@@Quit:
        fwait
        ret     16
end;

function Fmod(X, Y: Extended): Extended;
begin
  Result := X - (Y * Trunc(X / Y));
end;

function %ModfL(X: Extended; var Y: Longint): Extended;
begin
  Y := Trunc(X);
  Result := X - Y;
end;

function %ModfI(X: Extended; var Y: SmallInt): Extended;
begin
  Y := Trunc(X);
  Result := X - Y;
end;

function LRotL(value, shift: DWORD): DWORD;
code;
   asm
     mov  ecx, [shift]
     mov  eax, [value]
     rol  eax, cl
     ret
end;

function LRotR(value, shift: DWORD): DWORD;
code;
   asm
     mov  ecx, [shift]
     mov  eax, [value]
     ror  eax, cl
     ret
end;

function ChgSign(X: Extended): Extended;
begin
  Result := X * (-1);
end;

function CopySign(X, Y: Extended): Extended;
begin
  Result := Abs(X) * Sgn(Y);
end;

procedure %PolyXR(const Vector: array of Real; X: Extended; var Poly: TPoly);
var
  i: Longint;
begin
  with Poly do begin
    Neg := 0;
    Pos := 0;
    Neg := 0;
    DPos:= 0;
    for i := High(Vector) downto Low(Vector) do
    begin
      DNeg := X * DNeg + Neg;
      Neg := Neg * X;
      DPos := X * DPos + Pos;
      Pos := Pos * X;
      if Vector[i] >= 0 then
        Pos +:= Vector[i]
      else
        Neg +:= Vector[i]
    end;
    DNeg := DNeg * X;
    DPos := DPos * X;
  end;
end;

procedure %PolyXS(const Vector: array of Single; X: Extended; var Poly: TPoly);
var
  i: Longint;
begin
  with Poly do begin
    Neg := 0;
    Pos := 0;
    Neg := 0;
    DPos:= 0;
    for i := High(Vector) downto Low(Vector) do
    begin
      DNeg := X * DNeg + Neg;
      Neg := Neg * X;
      DPos := X * DPos + Pos;
      Pos := Pos * X;
      if Vector[i] >= 0 then
        Pos +:= Vector[i]
      else
        Neg +:= Vector[i]
    end;
    DNeg := DNeg * X;
    DPos := DPos * X;
  end;
end;

procedure %PolyXD(const Vector: array of Double; X: Extended; var Poly: TPoly);
var
  i: Longint;
begin
  with Poly do begin
    Neg := 0;
    Pos := 0;
    Neg := 0;
    DPos:= 0;
    for i := High(Vector) downto Low(Vector) do
    begin
      DNeg := X * DNeg + Neg;
      Neg := Neg * X;
      DPos := X * DPos + Pos;
      Pos := Pos * X;
      if Vector[i] >= 0 then
        Pos +:= Vector[i]
      else
        Neg +:= Vector[i]
    end;
    DNeg := DNeg * X;
    DPos := DPos * X;
  end;
end;

procedure %PolyXE(const Vector: array of Extended; X: Extended; var Poly: TPoly);
var
  i: Longint;
begin
  with Poly do begin
    Neg := 0;
    Pos := 0;
    Neg := 0;
    DPos:= 0;
    for i := High(Vector) downto Low(Vector) do
    begin
      DNeg := X * DNeg + Neg;
      Neg := Neg * X;
      DPos := X * DPos + Pos;
      Pos := Pos * X;
      if Vector[i] >= 0 then
        Pos +:= Vector[i]
      else
        Neg +:= Vector[i]
    end;
    DNeg := DNeg * X;
    DPos := DPos * X;
  end;
end;

{ Angle unit conversion routines }
function DegToRad(Degrees: Extended): Extended;
begin
  Result := Degrees * Deg2Rad;
end;

function RadToDeg(Radians: Extended): Extended;
begin
  Result := Radians * Rad2Deg;
end;

function GradToRad(Grads: Extended): Extended;
begin
  Result := Grads* Grad2Rad;
end;

function RadToGrad(Radians: Extended): Extended;
begin
  Result := Radians * Rad2Grad;
end;

function CycleToRad(Cycles: Extended): Extended;
begin
  Result := Cycles * DoublePI;
end;

function RadToCycle(Radians: Extended): Extended;
begin
  Result := Radians / DoublePI;
end;

{ Measure unit conversion routines }
function CelsToFahr(Value: Extended): Extended;
begin
  Result := Value * 9.0 / 5.0 + 32.0;
end;

function FahrToCels(Value: Extended): Extended;
begin
  Result := (Value - 32.0) * 5.0 / 9.0;
end;

function GalToLitre(Value: Extended): Extended;
begin
  Result := Value * 3.785411784;
end;

function LitreToGal(Value : Extended): Extended;
begin
  Result := Value / 3.785411784;
end;

function InchToCm(Value : Extended): Extended;
begin
  Result := Value * 2.54;
end;

function CmToInch(Value: Extended): Extended;
begin
  Result := Value / 2.54;
end;

function LbToKg(Value: Extended) : Extended;
begin
  Result := Value * 0.45359237;
end;

function KgToLb(Value: Extended): Extended;
begin
 Result := Value / 0.45359237;
end;

{ Trigonometric functions }
function Tan(X: Extended): Extended; code;
asm
        fld     tbyte ptr [esp + 4]
        fptan
        fstp    st(0)
        fwait
        ret     12
end;

function CoTan(X: Extended): Extended; code;
asm
        fld     tbyte ptr [esp+4]
        fptan
        fdivrp
        fwait
        ret     12
end;

function Hypot(X, Y: Extended): Extended;
begin
  Hypot := Sqrt(X * X + Y * Y);
end;

function Csc(X: Extended): Extended;
begin
  Result := 1.0 / Sin(X);
end;

function Sec(X: Extended): Extended;
begin
  Result := 1.0 / Cos(X);
end;

function ArcTan2(Y, X: Extended): Extended; code;
      asm
        fld     tbyte ptr [esp+16]
        fld     tbyte ptr [esp+4]
        fpatan
        fwait
        ret     24
end;

function ArcCos(X: Extended): Extended;
begin
  Result := ArcTan2(Sqrt(1 - X * X), X);
end;

function ArcSin(X: Extended): Extended;
begin
  Result := ArcTan2(X, Sqrt(1 - X * X));
end;

function ArcCotan(X: Extended): Extended;
begin
  Result := -ArcTan(X) + PI / 2.0;
end;

function ArcSec(X: Extended): Extended;
begin
  Result := ArcTan(X / Sqrt(1.0 - Sqrt(X))) + (Sgn(X) - 1.0) * (PI / 2.0);
end;

function ArcCsc(X: Extended): Extended;
begin
  Result := ArcTan(1.0 / Sqrt(1.0 - Sqrt(X))) + (Sgn(X) - 1.0) * (PI / 2.0);
end;

{ Hyperbolic functions }
function Cosh(X: Extended): Extended;
var Temp: Extended;
begin
  Temp := Exp(X) / 2;
  Result := Temp + 0.25 / Temp;
end;

function Sinh(X: Extended): Extended;
var Temp: Extended;
begin
  Temp := Exp(X) / 2;
  Result := Temp - 0.25 / Temp;
end;

function Tanh(X: Extended): Extended;
var Temp: Extended;
begin
  if X > HalfLnMax then Result := 1.0 else
    if X < (-HalfLnMax) then Result := -1.0 else begin
      Temp := Exp(X);
      Temp := Temp * Temp;
      Result := (Temp - 1.0) / (Temp + 1.0);
    end;
end;

function Sech(X: Extended): Extended;
begin
  Result := 2.0 / (Exp(X) + Exp(-X));
end;

function Csch(X: Extended): Extended;
begin
  Result := 2.0 / (Exp(X) - Exp(-X));
end;

function ArcCosh(X: Extended): Extended;
var Temp: Extended;
begin
  if X <=1.0 then Result := 0.0 else
    if X > 10.0 then Result := Ln(2) + Ln(X) else
      Result := Ln(X + Sqrt((X - 1.0) * (X + 1.0)));
end;

function ArcSinh(X: Extended): Extended;
var OldX, Temp: Extended;
begin
  if X = 0.0 then
    Result := 0.0
  else begin
    OldX := X;
    X := Abs(X);
    if X > 10.0 then
      Temp := Ln(2) + Ln(X)
    else begin
      Temp := X * X;
      Temp := Ln(1 + X + Temp / (1 + Sqrt( 1 + Temp)));
    end;
    if OldX < 0.0 then
      Result := -Temp
    else
      Result := Temp;
  end;
end;

function ArcTanh(X: Extended): Extended;
var OldX, Temp: Extended;
begin
  if X = 0.0 then
    Result := 0
  else begin
    OldX := X;
    X := Abs(X);
    if X >= 1 then
      Temp := MaxDouble
    else
      Temp := 0.5 * Ln(1 + (2.0 * X) / (1.0 - X));
    if OldX < 0.0 then
      Result := -Temp
    else
      Result := Temp;
  end;
end;

function ArcCotanh(X: Extended): Extended;
begin
  Result := Ln((X + 1.0) / (X - 1.0)) / 2.0;
end;

function ArcSech(X: Extended): Extended;
begin
  ArcSech := Ln((Sqrt(1.0 - Sqr(X)) + 1.0) / X);
end;

function ArcCsch(X: Extended): Extended;
begin
  ArcCsch := Ln((Sgn(X) * Sqrt(Sqr(X) + 1.0) + 1.0) / X);
end;

{ Logorithmic functions }
function Log10(X: Extended): Extended;
begin
  Result := Ln(X) / Ln(10.0);
end;

function Log2(X: Extended): Extended;
begin
  Result := Ln(X) / Ln(2.0);
end;

function LogN(X, Base: Extended): Extended;
begin
  Result := Ln(X) / Ln(Base);
end;

function IntPower(X: Extended; N: Longint): Extended;
var
  i: Longint;
  Tmp: Extended := 1;
begin
  i := Abs(N);
  while i > 0 do begin
    while not Odd(i) do
    begin
      i := i shr 1;
      X := X * X
    end;
    i -:= 1;
    Tmp := Tmp * X
  end;
  if i < 0 then
    Result := 1 / Tmp
  else
    Result := Tmp;
end;

function %PowerE(Base, Exponent: Extended): Extended;
begin
  if Exponent = 0 then
    Result := 1
  else if (Base = 0) and (Exponent > 0) then
    Result := 0
  else if (Frac(Exponent) = 0) and (Abs(Exponent) <= MaxLong) then
    Result := IntPower(Base, Trunc(Exponent))
  else
    Result := Exp(Exponent * Ln(Base))
end;

{ Statistic functions }
function %MaxL(A, B: Longint): Longint;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function %MaxE(A, B: Extended): Extended;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function %MinL(A, B: Longint): Longint;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function %MinE(A, B: Extended): Extended;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function %MaxValueR(const Vector: array of Real): Real;
var
  i: Longint;
begin
  Result := Vector[Low(Vector)];
  for I := Low(Vector) + 1 to High(Vector) do
    if Result < Vector[i] then Result := Vector[i];
end;

function %MaxValueS(const Vector: array of Single): Single;
var
  i: Longint;
begin
  Result := Vector[Low(Vector)];
  for I := Low(Vector) + 1 to High(Vector) do
    if Result < Vector[i] then Result := Vector[i];
end;

function %MaxValueD(const Vector: array of Double): Double;
var
  i: Longint;
begin
  Result := Vector[Low(Vector)];
  for I := Low(Vector) + 1 to High(Vector) do
    if Result < Vector[i] then Result := Vector[i];
end;

function %MaxValueE(const Vector: array of Extended): Extended;
var
  i: Longint;
begin
  Result := Vector[Low(Vector)];
  for I := Low(Vector) + 1 to High(Vector) do
    if Result < Vector[i] then Result := Vector[i];
end;

function MaxIntValue(const Vector: array of Longint): Longint;
var
  i: Longint;
begin
  Result := Vector[Low(Vector)];
  for I := Low(Vector) + 1 to High(Vector) do
    if Result < Vector[i] then Result := Vector[i];
end;

function %MinValueR(const Vector: array of Real): Real;
var
  i: Longint;
begin
  Result := Vector[Low(Vector)];
  for I := Low(Vector) + 1 to High(Vector) do
    if Result > Vector[i] then Result := Vector[i];
end;

function %MinValueS(const Vector: array of Single): Single;
var
  i: Longint;
begin
  Result := Vector[Low(Vector)];
  for I := Low(Vector) + 1 to High(Vector) do
    if Result > Vector[i] then Result := Vector[i];
end;

function %MinValueD(const Vector: array of Double): Double;
var
  i: Longint;
begin
  Result := Vector[Low(Vector)];
  for I := Low(Vector) + 1 to High(Vector) do
    if Result > Vector[i] then Result := Vector[i];
end;

function %MinValueE(const Vector: array of Extended): Extended;
var
  i: Longint;
begin
  Result := Vector[Low(Vector)];
  for I := Low(Vector) + 1 to High(Vector) do
    if Result > Vector[i] then Result := Vector[i];
end;

function MinIntValue(const Vector: array of Longint): Longint;
var
  i: Longint;
begin
  Result := Vector[Low(Vector)];
  for I := Low(Vector) + 1 to High(Vector) do
    if Result > Vector[i] then Result := Vector[i];
end;

function %SumR(const Vector: array of Real): Extended;
var
  i: Longint;
begin
  Result := 0;
  for i := Low(Vector) to High(Vector) do
    Result := Result + Vector[i]
end;

function %SumS(const Vector: array of Single): Extended;
var
  i: Longint;
begin
  Result := 0;
  for i := Low(Vector) to High(Vector) do
    Result := Result + Vector[i]
end;

function %SumD(const Vector: array of Double): Extended;
var
  i: Longint;
begin
  Result := 0;
  for i := Low(Vector) to High(Vector) do
    Result := Result + Vector[i]
end;

function %SumE(const Vector: array of Extended): Extended;
var
  i: Longint;
begin
  Result := 0;
  for i := Low(Vector) to High(Vector) do
    Result := Result + Vector[i]
end;

function SumInt(const Vector: array of Longint): Longint;
var
  i: Longint;
begin
  Result := 0;
  for i := Low(Vector) to High(Vector) do
    Result := Result + Vector[i]
end;

function %SumOfSquaresR(const Vector: array of Real): Extended;
var
  i: Longint;
begin
  Result := 0;
  for i := Low(Vector) to High(Vector) do
    Result := Result + Sqr(Vector[i]);
end;

function %SumOfSquaresS(const Vector: array of Single): Extended;
var
  i: Longint;
begin
  Result := 0;
  for i := Low(Vector) to High(Vector) do
    Result := Result + Sqr(Vector[i]);
end;

function %SumOfSquaresD(const Vector: array of Double): Extended;
var
  i: Longint;
begin
  Result := 0;
  for i := Low(Vector) to High(Vector) do
    Result := Result + Sqr(Vector[i]);
end;

function %SumOfSquaresE(const Vector: array of Extended): Extended;
var
  i: Longint;
begin
  Result := 0;
  for i := Low(Vector) to High(Vector) do
    Result := Result + Sqr(Vector[i]);
end;

function %SumOfSquaresL(const Vector: array of Longint): Longint;
var
  i: Longint;
begin
  Result := 0;
  for i := Low(Vector) to High(Vector) do
    Result := Result + Sqr(Vector[i]);
end;

procedure %SumsAndSquaresR(const Vector: array of Real; var Sum, SumOfSquares: Extended);
var
  i: Longint;
begin
  Sum := 0;
  SumOfSquares := 0;
  for i := Low(Vector) to High(Vector) do
  begin
    Sum := Sum + Vector[i];
    SumOfSquares := SumOfSquares + Vector[i] * Vector[i];
  end;
end;

procedure %SumsAndSquaresS(const Vector: array of Single; var Sum, SumOfSquares: Extended);
var
  i: Longint;
begin
  Sum := 0;
  SumOfSquares := 0;
  for i := Low(Vector) to High(Vector) do
  begin
    Sum := Sum + Vector[i];
    SumOfSquares := SumOfSquares + Vector[i] * Vector[i];
  end;
end;

procedure %SumsAndSquaresD(const Vector: array of Double; var Sum, SumOfSquares: Extended);
var
  i: Longint;
begin
  Sum := 0;
  SumOfSquares := 0;
  for i := Low(Vector) to High(Vector) do
  begin
    Sum := Sum + Vector[i];
    SumOfSquares := SumOfSquares + Vector[i] * Vector[i];
  end;
end;

procedure %SumsAndSquaresE(const Vector: array of Extended; var Sum, SumOfSquares: Extended);
var
  i: Longint;
begin
  Sum := 0;
  SumOfSquares := 0;
  for i := Low(Vector) to High(Vector) do
  begin
    Sum := Sum + Vector[i];
    SumOfSquares := SumOfSquares + Vector[i] * Vector[i];
  end;
end;

procedure %SumsAndSquaresL(const Vector: array of Longint; var Sum, SumOfSquares: Longint);
var
  i: Longint;
begin
  Sum := 0;
  SumOfSquares := 0;
  for i := Low(Vector) to High(Vector) do
  begin
    Sum := Sum + Vector[i];
    SumOfSquares := SumOfSquares + Vector[i] * Vector[i];
  end;
end;

function %MeanR(const Vector: array of Real): Extended;
begin
  Result := %SumR(Vector) / (High(Vector) - Low(Vector) + 1)
end;

function %MeanS(const Vector: array of Single): Extended;
begin
  Result := %SumS(Vector) / (High(Vector) - Low(Vector) + 1)
end;

function %MeanD(const Vector: array of Double): Extended;
begin
  Result := %SumD(Vector) / (High(Vector) - Low(Vector) + 1)
end;

function %MeanE(const Vector: array of Extended): Extended;
begin
  Result := %SumE(Vector) / (High(Vector) - Low(Vector) + 1)
end;

function %MeanL(const Vector: array of Longint): Extended;
begin
  Result := SumInt(Vector) / (High(Vector) - Low(Vector) + 1)
end;

function %TotalVarianceR(const Vector: array of Real): Extended;
var
  Sum, SumSquares: Extended;
begin
  SumsAndSquares(Vector, Sum, SumSquares);
  Result := SumSquares - Sqr(Sum) / (High(Vector) - Low(Vector) + 1);
end;

function %TotalVarianceS(const Vector: array of Single): Extended;
var
  Sum, SumSquares: Extended;
begin
  SumsAndSquares(Vector, Sum, SumSquares);
  Result := SumSquares - Sqr(Sum) / (High(Vector) - Low(Vector) + 1);
end;

function %TotalVarianceD(const Vector: array of Double): Extended;
var
  Sum, SumSquares: Extended;
begin
  SumsAndSquares(Vector, Sum, SumSquares);
  Result := SumSquares - Sqr(Sum) / (High(Vector) - Low(Vector) + 1);
end;

function %TotalVarianceE(const Vector: array of Extended): Extended;
var
  Sum, SumSquares: Extended;
begin
  SumsAndSquares(Vector, Sum, SumSquares);
  Result := SumSquares - Sqr(Sum) / (High(Vector) - Low(Vector) + 1);
end;

function %VarianceR(const Vector: array of Real): Extended;
begin
  Result := TotalVariance(Vector) / (High(Vector) - Low(Vector));
end;

function %VarianceS(const Vector: array of Single): Extended;
begin
  Result := TotalVariance(Vector) / (High(Vector) - Low(Vector));
end;

function %VarianceD(const Vector: array of Double): Extended;
begin
  Result := TotalVariance(Vector) / (High(Vector) - Low(Vector));
end;

function %VarianceE(const Vector: array of Extended): Extended;
begin
  Result := TotalVariance(Vector) / (High(Vector) - Low(Vector));
end;

function %PopnVarianceR(const Vector: array of Real): Extended;
begin
  Result := TotalVariance(Vector) / (High(Vector) - Low(Vector) + 1)
end;

function %PopnVarianceS(const Vector: array of Single): Extended;
begin
  Result := TotalVariance(Vector) / (High(Vector) - Low(Vector) + 1)
end;

function %PopnVarianceD(const Vector: array of Double): Extended;
begin
  Result := TotalVariance(Vector) / (High(Vector) - Low(Vector) + 1)
end;

function %PopnVarianceE(const Vector: array of Extended): Extended;
begin
  Result := TotalVariance(Vector) / (High(Vector) - Low(Vector) + 1)
end;

function %PopnStdDevR(const Vector: array of Real): Extended;
begin
  Result := Sqrt(PopnVariance(Vector));
end;

function %PopnStdDevS(const Vector: array of Single): Extended;
begin
  Result := Sqrt(PopnVariance(Vector));
end;

function %PopnStdDevD(const Vector: array of Double): Extended;
begin
  Result := Sqrt(PopnVariance(Vector));
end;

function %PopnStdDevE(const Vector: array of Extended): Extended;
begin
  Result := Sqrt(PopnVariance(Vector));
end;

function %NormR(const Vector: array of Real): Extended;
begin
  Result := Sqrt(SumOfSquares(Vector));
end;

function %NormS(const Vector: array of Single): Extended;
begin
  Result := Sqrt(SumOfSquares(Vector));
end;

function %NormD(const Vector: array of Double): Extended;
begin
  Result := Sqrt(SumOfSquares(Vector));
end;

function %NormE(const Vector: array of Extended): Extended;
begin
  Result := Sqrt(SumOfSquares(Vector));
end;

function RandG(Mean, StdDev: Extended): Extended;
var
  temp1, temp2: Extended;
begin
  repeat
    temp1 := 2 * Random - 1;
    temp2 := Sqr(temp1) + Sqr(2*Random-1);
  until temp2 < 1;
  Result := Mean + Sqrt(2 * Ln(temp2) / Abs(temp2)) * temp1 * StdDev;
end;

{ Percentage calculation }
function Percent(Value1, Value2: Extended): Extended;
begin
  Result := 100 * Value2 / Value1;
end;

function DeltaPercent (Value1, Value2: Extended): Extended;
begin
  if Value2 = 0 then
    Result := 0
  else
    Result := 100 * (Value1 - Value2) / Value2;
end;

{ Business functions }
function Sln(InitialValue, Residue: Extended; Time: DWord): Extended;
begin
  Result := (InitialValue - Residue) / Time;
end;

function Syd(InitialValue, Residue: Extended; Period, Time: DWord): Extended;
begin
  Result := (InitialValue - Residue) * ((Period + 1 - Time) / (Period * (Period + 1) / 2));
end;

function Cterm(Rate: Extended; FutureValue, PresentValue: Extended): Extended;
begin
  Result := (Ln(FutureValue / PresentValue) / Ln(1 + Rate));
end;

function Term(Payment: Extended; Rate: Extended; FutureValue: Extended): Extended;
begin
  Result := (Ln(1 + FutureValue * (Rate / Payment)) / Ln(1 + Rate));
end;

function Pmt(Principal: Extended; Rate: Extended; Term: DWord): Extended;
begin
  Result := Principal * (Rate / (1 - Power(1 + Rate, - Term)));
end;

function Rate(FutureValue, PresentValue: Extended; Term: DWord): Extended;
begin
  Result := Power((FutureValue) / (PresentValue), 1 / Term) - 1;
end;

function Pv(Payment: Extended; Rate: Extended; Term: DWord): Extended;
begin
  Result := (Payment * (1 - Power(1 + Rate, - Term)) / Rate);
end;

function Npv(Rate: Extended; Series: array of Double): Extended;
var
  i: DWord := 1;
  num: DWord := 12;
  Temp : Extended := 0;
begin
  repeat
    if Series[i] = 0 then num := i;
    i +:= 1;
  until (i = 12) or (Series[i] = 0);
  for i := 1 to num do
    Temp +:= (Series[i] / Power(1 + Rate, i));
  Result := Temp;
end;

function Fv(Payment: Extended; Rate: Extended; Term: DWord): Extended;
begin
  Result := Payment * (Power(1 + Rate, Term) - 1) / Rate;
end;

{$I CALC.INC}

procedure Evaluate(Expr: String; var Result: Extended; var ErrCode: Longint);
begin
  Result := Calculate(Expr);
  if CalcError then
    ErrCode := 1
  else
    ErrCode := 0;
end;

begin
  (* nothing to implement *)
end.
