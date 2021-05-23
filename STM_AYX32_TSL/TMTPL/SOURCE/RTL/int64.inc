(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       INT64.INC for System Unit                              *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Authors: Victor Petrov, Dmitriy Nevozhai               *)
(*                                                              *)
(****************************************************************)

{$ifdef interface}
procedure __writer (var f: text; const _i: int64; w: integer);
procedure __reader (var _f: text; var result: int64);

function   %dword_to_int64 (d:   dword): int64;
function %longint_to_int64 (i: longint): int64;

function %int64_to_dword   (i: int64): dword;
function %int64_to_longint (i: int64): longint;
function %int64_to_double  (i: Int64): Double;

function %int64_add (_a, _b: int64): int64;
function %int64_sub (_a, _b: int64): int64;
function %int64_mul (_a, _b: int64): int64;
function %int64_div (_a, _b: int64): int64;
function %int64_mod (_a, _b: int64): int64;

function %int64_and (_a, _b: int64): int64;
function %int64_or  (_a, _b: int64): int64;
function %int64_xor (_a, _b: int64): int64;

function %int64_not (_a: int64): int64;
function %int64_neg (_a: int64): int64;
function %int64_shl (_a: int64; _b: Integer): int64;
function %int64_shr (_a: int64; _b: Integer): int64;

function %int64_abs (_a: Int64): Int64;

function %int64_eq(_a, _b: int64): Boolean;
function %int64_ne(_a, _b: int64): Boolean;
function %int64_ge(_a, _b: int64): Boolean;
function %int64_le(_a, _b: int64): Boolean;
function %int64_gt(_a, _b: int64): Boolean;
function %int64_lt(_a, _b: int64): Boolean;

function Round64(val: Extended): Int64;
function Trunc64(val: Extended): Int64;

{$else}

type %Int64 = record
  case DWORD of
      0: (Low : DWORD; High: Longint);
      1: (LowU: DWORD; HighU: DWORD);
  end;

/////////////////////////////////////////////////////////////////////////////

procedure __writer (var f: text; const _i: int64; w: integer);
var
  i: int64 := _i;
  s: String := '';
begin
  if i = minint64 then begin
      write (f, '-9223372036854775808');
      exit;
  end;
  if i < 0 then
  begin
    Write (f, '-');
    i := 0-i;
  end;
  repeat
    s := '0123456789' [DWORD(i mod 10) + 1] + s;
    i := i div 10;
  until i = 0;
  Write(f, s);
end;

procedure __reader (var _f: text; var result: int64);
label
  err, no_sgn;
var
  c: Char;
  new_res: int64;
  dig: LongInt;
  neg: Boolean;
  f: ttextrec absolute _f;
begin
  Result := 0;
  if InOutRes <> 0 then exit;
  f.check_readable;
  if InOutRes <> 0 then exit;
  f.skip_spaces;
  if %text_eof(f) then exit;
  c := pchar(f.buf_adr)[f.index];
  neg := false;
  if c = '-' then
    neg := true
  else if c <> '+' then
    goto no_sgn;
  f.get_n_char(1);
  c := pchar(f.buf_adr) [f.index];
no_sgn:
  if (c in digits) then
  begin
    result := 0;
    repeat
      dig := ord(c) - ord('0');
      new_res := result * 10 + dig;
      if new_res < result then goto err;
      result := new_res;
      f.get_n_char(1);
      c := pchar(f.buf_adr)[f.index];
    until not (c in digits);
    if %text_eof(f) or (c in white_spaces) then
    begin
      if neg then result := -result;
      exit;
    end;
  end;
err:
  f.index := f.len_buf - 2;
  RunError(invalid_numeric_format);
end;

/////////////////////////////////////////////////////////////////////////////

function %dword_to_int64; with %int64 (result) do begin highU := 0; lowU := d; end;

function %longint_to_int64;
with %int64 (result) do
begin
  low  := i;
  high  := 0;
  if i < 0 then high := -1;
end;

function %int64_to_dword  ; result := %int64 (i).lowU;

function %int64_to_longint; result := %int64 (i).low;

function %int64_to_double (i: Int64): Double; code;
asm
  fild  qword ptr [i]
  ret   8
end;

/////////////////////////////////////////////////////////////////////////////

var
  temp: DWORD;

function %int64_add (_a, _b: int64): int64; code;
asm
    mov   eax, dword ptr [_a]
    add   eax, dword ptr [_b]
    mov   esi, dword ptr [_a+4]
    adc   esi, dword ptr [_b+4]
    mov   edi, [Result]
    mov   [edi+4], esi
    mov   [edi], eax
    ret
end;

function %int64_sub (_a, _b: int64): int64; code;
asm
    mov   eax, dword ptr [_a]
    sub   eax, dword ptr [_b]
    mov   esi, dword ptr [_a+4]
    sbb   esi, dword ptr [_b+4]
    mov   edi, [Result]
    mov   [edi+4], esi
    mov   [edi], eax
    ret
end;

function %int64_mul (_a, _b: int64): int64; code;
asm
    push  edx
    mov   eax, dword ptr [_b+4+4]
    mul   dword ptr [_a+4]
    mov   esi, eax
    mov   eax, dword ptr [_a+4+4]
    mul   dword ptr [_b+4]
    add   esi, eax
    mov   eax, dword ptr [_a+4]
    mul   dword ptr [_b+4]
    add   edx, esi
    mov   edi, [Result+4]
    mov   [edi+4], edx
    mov   [edi], eax
    pop   edx
    ret
end;

function %int64_div (_a, _b: int64): int64;  code;
asm
    push  ecx
    push  edx
    push  ebx
    xor   edi, edi
    mov   ebx, dword ptr [_b+12]
    mov   ecx, dword ptr [_b+4+12]
    mov   eax, dword ptr [_a+12]
    mov   edx, dword ptr [_a+4+12]
    or    ecx, ecx
    jnz   @@1
    or    edx, edx
    jz    @@8
    or    ebx, ebx
    jz    @@8
@@1:
    or    edx, edx
    jns   @@2
    neg   edx
    neg   eax
    sbb   edx, 0
    or    edi, 1
@@2:
    or    ecx, ecx
    jns   @@3
    neg   ecx
    neg   ebx
    sbb   ecx, 0
    xor   edi, 1
@@3:
    mov   [temp], ecx
    mov   ecx, 64
    push  edi
    xor   edi, edi
    xor   esi, esi
@@4:
    shl   eax,1
    rcl   edx,1
    rcl   esi,1
    rcl   edi,1
    cmp   edi,[temp]
    jb    @@6
    ja    @@5
    cmp   esi,ebx
    jb    @@6
@@5:
    sub   esi,ebx
    sbb   edi,[temp]
    inc   eax
@@6:
    loop  @@4
    pop   ebx
    test  ebx,1
    jz    @@7
    neg   edx
    neg   eax
    sbb   edx,0
@@7:
    mov   edi, [Result+12]
    mov   [edi+4], edx
    mov   [edi], eax
    pop   ebx
    pop   edx
    pop   ecx
    ret
@@8:
    div   ebx
    xor   edx,edx
    mov   edi, [Result+12]
    mov   [edi+4], edx
    mov   [edi], eax
    pop   ebx
    pop   edx
    pop   ecx
    ret
end;

function %int64_mod (_a, _b: int64): Int64; code;
asm
    push  ecx
    push  edx
    push  ebx
    xor   edi, edi
    mov   ebx, dword ptr [_b+12]
    mov   ecx, dword ptr [_b+4+12]
    mov   eax, dword ptr [_a+12]
    mov   edx, dword ptr [_a+4+12]
    or    ecx, ecx
    jnz   @@1
    or    edx, edx
    jz    @@8
    or    ebx, ebx
    jz    @@8
@@1:
    or    edx, edx
    jns   @@2
    neg   edx
    neg   eax
    sbb   edx, 0
    or    edi, 1
@@2:
    or    ecx, ecx
    jns   @@3
    neg   ecx
    neg   ebx
    sbb   ecx, 0
@@3:
    mov   [temp], ecx
    mov   ecx, 64
    push  edi
    xor   edi, edi
    xor   esi, esi
@@4:
    shl   eax, 1
    rcl   edx, 1
    rcl   esi, 1
    rcl   edi, 1
    cmp   edi, [temp]
    jb    @@6
    ja    @@5
    cmp   esi, ebx
    jb    @@6
@@5:
    sub   esi, ebx
    sbb   edi, [temp]
    inc   eax
@@6:
    loop  @@4
    mov   eax, esi
    mov   edx, edi
    pop   ebx
    test  ebx, 1
    jz    @@7
    neg   edx
    neg   eax
    sbb   edx, 0
@@7:
    mov   edi, [Result+12]
    mov   [edi+4], edx
    mov   [edi], eax
    pop   ebx
    pop   edx
    pop   ecx
    ret
@@8:
    div   ebx
    xchg  eax,edx
    xor   edx,edx
    mov   edi, [Result+12]
    mov   [edi+4], edx
    mov   [edi], eax
    pop   ebx
    pop   edx
    pop   ecx
    ret
end;

function %int64_and (_a, _b: int64): int64; code;
asm
    mov   eax, dword ptr [_a]
    and   eax, dword ptr [_b]
    mov   esi, dword ptr [_a+4]
    and   esi, dword ptr [_b+4]
    mov   edi, [Result]
    mov   [edi+4], esi
    mov   [edi], eax
    ret
end;

function %int64_or (_a, _b: int64): int64; code;
asm
    mov   eax, dword ptr [_a]
    or    eax, dword ptr [_b]
    mov   esi, dword ptr [_a+4]
    or    esi, dword ptr [_b+4]
    mov   edi, [Result]
    mov   [edi+4], esi
    mov   [edi], eax
    ret
end;

function %int64_xor (_a, _b: int64): int64; code;
asm
    mov   eax, dword ptr [_a]
    xor   eax, dword ptr [_b]
    mov   esi, dword ptr [_a+4]
    xor   esi, dword ptr [_b+4]
    mov   edi, [Result]
    mov   [edi+4], esi
    mov   [edi], eax
    ret
end;

function %int64_not (_a: int64): int64;  code;
asm
    mov   edi, [Result]
    mov   eax, dword ptr [_a]
    not   eax
    mov   [edi], eax
    mov   eax, dword ptr [_a+4]
    not   eax
    mov   [edi+4], eax
    ret
end;

function %int64_neg (_a: int64): int64;  code;
asm
    mov   edi, [Result]
    mov   esi, dword ptr [_a+4]
    mov   eax, dword ptr [_a]
    neg   esi
    neg   eax
    sbb   esi, 0
    mov   [edi], eax
    mov   [edi+4], esi
    ret
end;

function %int64_shl (_a: int64; _b: Integer): int64; code;
asm
    push  ecx
    mov   ecx, [_b+4]
    mov   eax, dword ptr [_a+4]
    mov   esi, dword ptr [_a+4+4]
    cmp   cl, 20h
    jl    @@2
    cmp   cl, 40h
    jl    @@1
    xor   eax, eax
    mov   edi, [Result+4]
    mov   [edi+4], eax
    mov   [edi], eax
    pop   ecx
    ret
@@1:
    mov   esi, eax
    shl   esi, cl
    xor   eax, eax
    mov   edi, [Result+4]
    mov   [edi+4], esi
    mov   [edi], eax
    pop   ecx
    ret
@@2:
    shld  esi, eax, cl
    shl   eax, cl
    mov   edi, [Result+4]
    mov   [edi+4], esi
    mov   [edi], eax
    pop   ecx
    ret
end;


function %int64_shr (_a: int64; _b: Integer): int64; code;
asm
    push  ecx
    push  edx
    mov   ecx, [_b+8]
    cmp   cl, 20h
    jl    @@2
    cmp   cl, 40h
    jl    @@1

    mov   edx, dword ptr [_a+4+8]

    sar   edx,1Fh
    mov   edi,[Result+8]
    mov   [edi+4], edx
    mov   [edi], edx
    pop   edx
    pop   ecx
    ret
@@1:
    mov   edx, dword ptr [_a+4+8]
    mov   eax, edx
    cdq
    sar   eax, cl
    mov   edi, [Result+8]
    mov   [edi+4], edx
    mov   [edi], eax
    pop   edx
    pop   ecx
    ret
@@2:
    mov   eax, dword ptr [_a+8]
    mov   edx, dword ptr [_a+4+8]
    shrd  eax, edx, cl
    sar   edx, cl
    mov   edi, [Result+8]
    mov   [edi+4], edx
    mov   [edi], eax
    pop   edx
    pop   ecx
    ret
end;

/////////////////////////////////////////////////////////////////////////////

function %int64_abs (_a: Int64): Int64; code;
asm
    mov   eax, dword ptr [_a]
    mov   esi, dword ptr [_a+4]
    test  esi, esi
    jnl   @@1
    neg   eax
    adc   esi, 0
    neg   esi
@@1:
    mov   edi, [Result]
    mov   [edi+4], esi
    mov   [edi], eax
    ret
end;

/////////////////////////////////////////////////////////////////////////////

function %int64_eq (_a, _b: int64): boolean;
  var a: %int64 absolute _a;
  var b: %int64 absolute _b;
begin result := (a.low = b.low) and (a.high = b.high); end;

function %int64_ne (_a, _b: int64): boolean;
  var a: %int64 absolute _a;
  var b: %int64 absolute _b;
begin result := (a.low <> b.low) and (a.high <> b.high); end;

function %int64_lt (_a, _b: int64): boolean;
  var a: %int64 absolute _a;
  var b: %int64 absolute _b;
begin result := (a.high < b.high) or (a.high = b.high) and (a.lowU < b.lowU); end;

function %int64_le (_a, _b: int64): boolean;
  var a: %int64 absolute _a;
  var b: %int64 absolute _b;
begin result := (a.high < b.high) or (a.high = b.high) and (a.lowU <= b.lowU); end;

function %int64_gt (_a, _b: int64): boolean;
  var a: %int64 absolute _a;
  var b: %int64 absolute _b;
begin result := (a.high > b.high) or (a.high = b.high) and (a.lowU > b.lowU); end;

function %int64_ge (_a, _b: int64): boolean;
  var a: %int64 absolute _a;
  var b: %int64 absolute _b;
begin result := (a.high > b.high) or (a.high = b.high) and (a.lowU >= b.lowU); end;


/////////////////////////////////////////////////////////////////////////////

const
  cwTrunc: Word = $1F32;

function Round64(val: Extended): Int64; code;
asm
   fld     tbyte ptr [esp+4]
   mov     edi, [Result]
   fistp   qword ptr [edi]
   fwait
   ret     16
end;

function Trunc64(val: Extended): Int64; code;
var
  cwt: Word;
asm
   fstcw   [cwt]
   fld     tbyte ptr [esp+4]
   mov     edi, [Result]
   fldcw   [cwTrunc]
   fistp   qword ptr [edi]
   fwait
   fldcw   [cwt]
   ret     16
end;
{$endif}