(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       VARIANT.INC for System Unit                            *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Authors: Victor Petrov, Dmitriy Nevozhai               *)
(*                                                              *)
(****************************************************************)

{$ifdef interface}

function %double_to_variant  (value: Double ): Variant;
function %longint_to_variant (value: Longint): Variant;
function %dword_to_variant   (value: DWORD): Variant;
function %int64_to_variant   (value: Int64): Variant;
function %boolean_to_variant (value: Boolean): Variant;
function %pwchar_to_variant  (value: PWChar): Variant;

function %variant_to_longint  (value: Variant): Longint;
function %variant_to_dword    (value: Variant): DWORD;
function %variant_to_int64    (value: Variant): Int64;
function %variant_to_double   (value: Variant): Double;
function %variant_to_boolean  (value: Variant): LongBool;
function %variant_to_pwchar   (value: Variant): PWChar;

function %variant_add (const a, b: Variant): Variant;
function %variant_sub (const a, b: Variant): Variant;
function %variant_mul (const a, b: Variant): Variant;
function %variant_div (const a, b: Variant): Variant;
function %variant_mod (const a, b: Variant): Variant;
function %variant_or  (const a, b: Variant): Variant;
function %variant_xor (const a, b: Variant): Variant;
function %variant_and (const a, b: Variant): Variant;
function %variant_not (const a: Variant): Variant;
function %variant_shl (const a, b: Variant): Variant;
function %variant_shr (const a, b: Variant): Variant;

function %variant_eq (const a: Variant; const b: Variant): Boolean;
function %variant_ne (const a: Variant; const b: Variant): Boolean;
function %variant_ge (const a: Variant; const b: Variant): Boolean;
function %variant_gt (const a: Variant; const b: Variant): Boolean;
function %variant_le (const a: Variant; const b: Variant): Boolean;
function %variant_lt (const a: Variant; const b: Variant): Boolean;

procedure %sys_write_variant conv (arg_reverse + arg_no_drop_1) (w: Integer; const value: Variant; var f: text);

{$else}

function %double_to_variant (value: Double): Variant;
begin
  OleVariant(Result).vt := VT_R8;
  OleVariant(Result).dblVal := value;
end;

function %longint_to_variant (value: Longint): Variant;
begin
  OleVariant(Result).vt := VT_I4;
  OleVariant(Result).lVal := value;
end;

function %dword_to_variant (value: DWORD): Variant;
begin
  OleVariant(Result).vt := VT_UI4;
  OleVariant(Result).ulVal := value;
end;

function %int64_to_variant (value: Int64): Variant;
begin
  OleVariant(Result).vt := VT_I8;
  OleVariant(Result).llVal := value;
end;

function %boolean_to_variant (value: Boolean): Variant;
begin
  OleVariant(Result).vt := VT_BOOL;
  if value then
    OleVariant(Result).vbool := WordTRUE
  else
    OleVariant(Result).vbool := WordFALSE;
end;

function %pwchar_to_variant (value: PWChar): Variant;
begin
  OleVariant(Result).vt := VT_BSTR;
  OleVariant(Result).bstrVal := value;
end;

function StrToDbl(str: PWChar): Double;
var
  s: String;
  err: Integer;
begin
  s := StrPasW(str);
  Val(s, Result, err);
  if err <> 0 then
    RunError(INVALID_VARIANT_TYPE_OPERATION);
end;

function %variant_to_longint (value: Variant): Longint;
var
  val: OleVariant absolute value;
begin
  case val.vt of
    VT_UI1:                  Result := val.bVal;
    VT_I2:                   Result := val.iVal;
    VT_I4:                   Result := val.lVal;
    VT_I8:                   Result := LongLongRec(val.llVal).Lo;
    VT_R4:                   Result := Trunc(val.fltVal);
    VT_R8:                   Result := Trunc(val.dblVal);
    VT_BOOL:                 Result := Longint(val.vbool);
    VT_ERROR:                Result := Longint(val.scode);
    VT_CY:                   Result := Trunc(val.cyVal);
    VT_DATE:                 Result := Trunc(val.date);
    VT_BSTR:                 Result := Trunc(StrToDbl(val.bstrVal));
    VT_UNKNOWN:              Result := Longint(val.unkVal);
    VT_DISPATCH:             Result := Longint(val.dispVal);
    VT_ARRAY:                Result := Longint(val.parray);
    VT_BYREF or VT_UI1:      Result := Longint(val.pbVal);
    VT_BYREF or VT_I2:       Result := Longint(val.piVal);
    VT_BYREF or VT_I4:       Result := Longint(val.plVal);
    VT_BYREF or VT_R4:       Result := Longint(val.pfltVal);
    VT_BYREF or VT_R8:       Result := Longint(val.pdblVal);
    VT_BYREF or VT_BOOL:     Result := Longint(val.pbool);
    VT_BYREF or VT_ERROR:    Result := Longint(val.pscode);
    VT_BYREF or VT_CY:       Result := Longint(val.pcyVal);
    VT_BYREF or VT_DATE:     Result := Longint(val.pdate);
    VT_BYREF or VT_BSTR:     Result := Longint(val.pbstrVal);
    VT_BYREF or VT_UNKNOWN:  Result := Longint(val.punkVal);
    VT_BYREF or VT_DISPATCH: Result := Longint(val.pdispVal);
    VT_BYREF or VT_ARRAY:    Result := Longint(val.pparray);
    VT_BYREF or VT_VARIANT:  Result := Longint(val.pvarVal);
    VT_BYREF:                Result := Longint(val.byRef);
    VT_I1:                   Result := Longint(val.cVal);
    VT_UI2:                  Result := Longint(val.uiVal);
    VT_UI4:                  Result := Longint(val.ulVal);
    VT_INT:                  Result := Longint(val.intVal);
    VT_UINT:                 Result := Longint(val.uintVal);
    VT_BYREF or VT_DECIMAL:  Result := Longint(val.pdecVal);
    VT_BYREF or VT_I1:       Result := Longint(val.pcVal);
    VT_BYREF or VT_UI2:      Result := Longint(val.puiVal);
    VT_BYREF or VT_UI4:      Result := Longint(val.pulVal);
    VT_BYREF or VT_INT:      Result := Longint(val.pintVal);
    VT_BYREF or VT_UINT:     Result := Longint(val.puintVal);
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_to_dword (value: Variant): DWORD;
var
  val: OleVariant absolute value;
begin
  case val.vt of
    VT_UI1:                  Result := val.bVal;
    VT_I2:                   Result := val.iVal;
    VT_I4:                   Result := val.lVal;
    VT_I8:                   Result := LongLongRec(val.llVal).Lo;
    VT_R4:                   Result := Trunc(val.fltVal);
    VT_R8:                   Result := Trunc(val.dblVal);
    VT_BOOL:                 Result := DWORD(val.vbool);
    VT_ERROR:                Result := DWORD(val.scode);
    VT_CY:                   Result := Trunc(val.cyVal);
    VT_DATE:                 Result := Trunc(val.date);
    VT_BSTR:                 Result := Trunc(StrToDbl(val.bstrVal));
    VT_UNKNOWN:              Result := DWORD(val.unkVal);
    VT_DISPATCH:             Result := DWORD(val.dispVal);
    VT_ARRAY:                Result := DWORD(val.parray);
    VT_BYREF or VT_UI1:      Result := DWORD(val.pbVal);
    VT_BYREF or VT_I2:       Result := DWORD(val.piVal);
    VT_BYREF or VT_I4:       Result := DWORD(val.plVal);
    VT_BYREF or VT_R4:       Result := DWORD(val.pfltVal);
    VT_BYREF or VT_R8:       Result := DWORD(val.pdblVal);
    VT_BYREF or VT_BOOL:     Result := DWORD(val.pbool);
    VT_BYREF or VT_ERROR:    Result := DWORD(val.pscode);
    VT_BYREF or VT_CY:       Result := DWORD(val.pcyVal);
    VT_BYREF or VT_DATE:     Result := DWORD(val.pdate);
    VT_BYREF or VT_BSTR:     Result := DWORD(val.pbstrVal);
    VT_BYREF or VT_UNKNOWN:  Result := DWORD(val.punkVal);
    VT_BYREF or VT_DISPATCH: Result := DWORD(val.pdispVal);
    VT_BYREF or VT_ARRAY:    Result := DWORD(val.pparray);
    VT_BYREF or VT_VARIANT:  Result := DWORD(val.pvarVal);
    VT_BYREF:                Result := DWORD(val.byRef);
    VT_I1:                   Result := DWORD(val.cVal);
    VT_UI2:                  Result := DWORD(val.uiVal);
    VT_UI4:                  Result := DWORD(val.ulVal);
    VT_INT:                  Result := DWORD(val.intVal);
    VT_UINT:                 Result := DWORD(val.uintVal);
    VT_BYREF or VT_DECIMAL:  Result := DWORD(val.pdecVal);
    VT_BYREF or VT_I1:       Result := DWORD(val.pcVal);
    VT_BYREF or VT_UI2:      Result := DWORD(val.puiVal);
    VT_BYREF or VT_UI4:      Result := DWORD(val.pulVal);
    VT_BYREF or VT_INT:      Result := DWORD(val.pintVal);
    VT_BYREF or VT_UINT:     Result := DWORD(val.puintVal);
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_to_int64 (value: Variant): Int64;
var
  val: OleVariant absolute value;
begin
  case val.vt of
    VT_UI1:                  Result := val.bVal;
    VT_I2:                   Result := val.iVal;
    VT_I4:                   Result := val.lVal;
    VT_I8:                   Result := val.llVal;
    VT_R4:                   Result := Trunc(val.fltVal);
    VT_R8:                   Result := Trunc(val.dblVal);
    VT_BOOL:                 Result := DWORD(val.vbool);
    VT_ERROR:                Result := DWORD(val.scode);
    VT_CY:                   Result := Trunc(val.cyVal);
    VT_DATE:                 Result := Trunc(val.date);
    VT_BSTR:                 Result := Trunc(StrToDbl(val.bstrVal));
    VT_UNKNOWN:              Result := DWORD(val.unkVal);
    VT_DISPATCH:             Result := DWORD(val.dispVal);
    VT_ARRAY:                Result := DWORD(val.parray);
    VT_BYREF or VT_UI1:      Result := DWORD(val.pbVal);
    VT_BYREF or VT_I2:       Result := DWORD(val.piVal);
    VT_BYREF or VT_I4:       Result := DWORD(val.plVal);
    VT_BYREF or VT_R4:       Result := DWORD(val.pfltVal);
    VT_BYREF or VT_R8:       Result := DWORD(val.pdblVal);
    VT_BYREF or VT_BOOL:     Result := DWORD(val.pbool);
    VT_BYREF or VT_ERROR:    Result := DWORD(val.pscode);
    VT_BYREF or VT_CY:       Result := DWORD(val.pcyVal);
    VT_BYREF or VT_DATE:     Result := DWORD(val.pdate);
    VT_BYREF or VT_BSTR:     Result := DWORD(val.pbstrVal);
    VT_BYREF or VT_UNKNOWN:  Result := DWORD(val.punkVal);
    VT_BYREF or VT_DISPATCH: Result := DWORD(val.pdispVal);
    VT_BYREF or VT_ARRAY:    Result := DWORD(val.pparray);
    VT_BYREF or VT_VARIANT:  Result := DWORD(val.pvarVal);
    VT_BYREF:                Result := DWORD(val.byRef);
    VT_I1:                   Result := DWORD(val.cVal);
    VT_UI2:                  Result := DWORD(val.uiVal);
    VT_UI4:                  Result := DWORD(val.ulVal);
    VT_INT:                  Result := DWORD(val.intVal);
    VT_UINT:                 Result := DWORD(val.uintVal);
    VT_BYREF or VT_DECIMAL:  Result := DWORD(val.pdecVal);
    VT_BYREF or VT_I1:       Result := DWORD(val.pcVal);
    VT_BYREF or VT_UI2:      Result := DWORD(val.puiVal);
    VT_BYREF or VT_UI4:      Result := DWORD(val.pulVal);
    VT_BYREF or VT_INT:      Result := DWORD(val.pintVal);
    VT_BYREF or VT_UINT:     Result := DWORD(val.puintVal);
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_to_double (value: Variant): Double;
var
  val: OleVariant absolute value;
begin
  case val.vt of
    VT_UI1:                  Result := val.bVal;
    VT_I2:                   Result := val.iVal;
    VT_I4:                   Result := val.lVal;
    VT_R4:                   Result := val.fltVal;
    VT_I8:                   Result := val.llVal;
    VT_R8:                   Result := val.dblVal;
    VT_BOOL:                 Result := Longint(val.vbool);
    VT_ERROR:                Result := Longint(val.scode);
    VT_CY:                   Result := val.cyVal;
    VT_DATE:                 Result := val.date;
    VT_BSTR:                 Result := StrToDbl(val.bstrVal);
    VT_UNKNOWN:              Result := DWORD(val.unkVal);
    VT_DISPATCH:             Result := DWORD(val.dispVal);
    VT_ARRAY:                Result := DWORD(val.parray);
    VT_BYREF or VT_UI1:      Result := DWORD(val.pbVal);
    VT_BYREF or VT_I2:       Result := DWORD(val.piVal);
    VT_BYREF or VT_I4:       Result := DWORD(val.plVal);
    VT_BYREF or VT_R4:       Result := DWORD(val.pfltVal);
    VT_BYREF or VT_R8:       Result := DWORD(val.pdblVal);
    VT_BYREF or VT_BOOL:     Result := DWORD(val.pbool);
    VT_BYREF or VT_ERROR:    Result := DWORD(val.pscode);
    VT_BYREF or VT_CY:       Result := DWORD(val.pcyVal);
    VT_BYREF or VT_DATE:     Result := DWORD(val.pdate);
    VT_BYREF or VT_BSTR:     Result := DWORD(val.pbstrVal);
    VT_BYREF or VT_UNKNOWN:  Result := DWORD(val.punkVal);
    VT_BYREF or VT_DISPATCH: Result := DWORD(val.pdispVal);
    VT_BYREF or VT_ARRAY:    Result := DWORD(val.pparray);
    VT_BYREF or VT_VARIANT:  Result := DWORD(val.pvarVal);
    VT_BYREF:                Result := DWORD(val.byRef);
    VT_I1:                   Result := Byte(val.cVal);
    VT_UI2:                  Result := Word(val.uiVal);
    VT_UI4:                  Result := DWORD(val.ulVal);
    VT_INT:                  Result := Integer(val.intVal);
    VT_UINT:                 Result := DWORD(val.uintVal);
    VT_BYREF or VT_DECIMAL:  Result := DWORD(val.pdecVal);
    VT_BYREF or VT_I1:       Result := DWORD(val.pcVal);
    VT_BYREF or VT_UI2:      Result := DWORD(val.puiVal);
    VT_BYREF or VT_UI4:      Result := DWORD(val.pulVal);
    VT_BYREF or VT_INT:      Result := DWORD(val.pintVal);
    VT_BYREF or VT_UINT:     Result := DWORD(val.puintVal);
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_to_boolean (value: Variant): LongBool;
var
  val: OleVariant absolute value;
begin
  case val.vt of
    VT_UI1:                  Result := LongBool(val.bVal);
    VT_I2:                   Result := LongBool(val.iVal);
    VT_I4:                   Result := LongBool(val.lVal);
    VT_R4:                   Result := LongBool(Trunc(val.fltVal));
    VT_I8:                   Result := LongBool(LongLongRec(val.llVal).Lo);
    VT_R8:                   Result := LongBool(Trunc(val.dblVal));
    VT_BOOL:                 Result := val.vbool;
    VT_ERROR:                Result := LongBool(val.scode);
    VT_CY:                   Result := LongBool(Trunc(val.cyVal));
    VT_DATE:                 Result := LongBool(Trunc(val.date));
    VT_BSTR:                 Result := LongBool(Trunc(StrToDbl(val.bstrVal)));
    VT_UNKNOWN:              Result := LongBool(val.unkVal);
    VT_DISPATCH:             Result := LongBool(val.dispVal);
    VT_ARRAY:                Result := LongBool(val.parray);
    VT_BYREF or VT_UI1:      Result := LongBool(val.pbVal);
    VT_BYREF or VT_I2:       Result := LongBool(val.piVal);
    VT_BYREF or VT_I4:       Result := LongBool(val.plVal);
    VT_BYREF or VT_R4:       Result := LongBool(val.pfltVal);
    VT_BYREF or VT_R8:       Result := LongBool(val.pdblVal);
    VT_BYREF or VT_BOOL:     Result := LongBool(val.pbool);
    VT_BYREF or VT_ERROR:    Result := LongBool(val.pscode);
    VT_BYREF or VT_CY:       Result := LongBool(val.pcyVal);
    VT_BYREF or VT_DATE:     Result := LongBool(val.pdate);
    VT_BYREF or VT_BSTR:     Result := LongBool(val.pbstrVal);
    VT_BYREF or VT_UNKNOWN:  Result := LongBool(val.punkVal);
    VT_BYREF or VT_DISPATCH: Result := LongBool(val.pdispVal);
    VT_BYREF or VT_ARRAY:    Result := LongBool(val.pparray);
    VT_BYREF or VT_VARIANT:  Result := LongBool(val.pvarVal);
    VT_BYREF:                Result := LongBool(val.byRef);
    VT_I1:                   Result := LongBool(DWORD(val.cVal));
    VT_UI2:                  Result := LongBool(DWORD(val.uiVal));
    VT_UI4:                  Result := LongBool(val.ulVal);
    VT_INT:                  Result := LongBool(val.intVal);
    VT_UINT:                 Result := LongBool(val.uintVal);
    VT_BYREF or VT_DECIMAL:  Result := LongBool(val.pdecVal);
    VT_BYREF or VT_I1:       Result := LongBool(val.pcVal);
    VT_BYREF or VT_UI2:      Result := LongBool(val.puiVal);
    VT_BYREF or VT_UI4:      Result := LongBool(val.pulVal);
    VT_BYREF or VT_INT:      Result := LongBool(val.pintVal);
    VT_BYREF or VT_UINT:     Result := LongBool(val.puintVal);
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_to_pwchar(value: Variant): PWChar;
var
  val: OleVariant absolute value;
begin
  if val.vt = VT_BSTR then
    Result := val.bstrVal
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
end;

function VariantResType(arg1, arg2: Variant): Integer;
begin
  // Check both args
  if (OleVariant(arg1).vt in [VT_BOOL]) and (OleVariant(arg2).vt in [VT_BOOL]) then
      Result := VT_BOOL
  else
  // Check arg1
  if OleVariant(arg1).vt in [VT_BOOL, VT_UI1, VT_I2, VT_I4, VT_I8, VT_I1, VT_UI2, VT_UI4, VT_INT, VT_UINT, VT_BSTR] then
  begin
    if OleVariant(arg2).vt = VT_I8 then
      Result := VT_I8
    else
    if OleVariant(arg2).vt in [VT_BOOL, VT_UI1, VT_I2, VT_I4, VT_I1, VT_UI2, VT_UI4, VT_INT, VT_UINT] then
      Result := VT_I4
    else
      Result := VT_R8
  end else
  // Check arg 2
  if OleVariant(arg2).vt in [VT_BOOL, VT_UI1, VT_I2, VT_I4, VT_I8, VT_I1, VT_UI2, VT_UI4, VT_INT, VT_UINT, VT_BSTR] then
  begin
    if OleVariant(arg1).vt = VT_I8 then
      Result := VT_I8
    else
    if OleVariant(arg1).vt in [VT_BOOL, VT_UI1, VT_I2, VT_I4, VT_I1, VT_UI2, VT_UI4, VT_INT, VT_UINT] then
      Result := VT_I4
    else
      Result := VT_R8
  end else
    Result := VT_ILLEGAL;
end;

function %variant_add (const a, b: Variant): Variant;
begin
  OleVariant(Result).vt := VariantResType(a, b);
  case OleVariant(Result).vt of
    VT_I4:   OleVariant(Result).lVal := %variant_to_longint(a) + %variant_to_longint(b);
    VT_I8:   OleVariant(Result).llVal := %variant_to_int64(a) + %variant_to_int64(b);
    VT_R8:   OleVariant(Result).dblVal := %variant_to_double(a) + %variant_to_double(b);
    VT_BOOL: OleVariant(Result).vbool := %variant_to_boolean(a) or %variant_to_boolean(b);
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_sub (const a, b: Variant): Variant;
begin
  OleVariant(Result).vt := VariantResType(a, b);
  case OleVariant(Result).vt of
    VT_I4:   OleVariant(Result).lVal := %variant_to_longint(a) - %variant_to_longint(b);
    VT_I8:   OleVariant(Result).llVal := %variant_to_int64(a) - %variant_to_int64(b);
    VT_R8:   OleVariant(Result).dblVal := %variant_to_double(a) - %variant_to_double(b);
    VT_BOOL: OleVariant(Result).vbool := %variant_to_boolean(a) xor %variant_to_boolean(b);
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_mul (const a, b: Variant): Variant;
begin
  OleVariant(Result).vt := VariantResType(a, b);
  case OleVariant(Result).vt of
    VT_I4:   OleVariant(Result).lVal := %variant_to_longint(a) * %variant_to_longint(b);
    VT_I8:   OleVariant(Result).llVal := %variant_to_int64(a) * %variant_to_int64(b);
    VT_R8:   OleVariant(Result).dblVal := %variant_to_double(a) * %variant_to_double(b);
    VT_BOOL: OleVariant(Result).vbool := %variant_to_boolean(a) and %variant_to_boolean(b);
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_div (const a, b: Variant): Variant;
begin
  OleVariant(Result).vt := VariantResType(a, b);
  case OleVariant(Result).vt of
    VT_I4:   OleVariant(Result).lVal := %variant_to_longint(a) div %variant_to_longint(b);
    VT_I8:   OleVariant(Result).llVal := %variant_to_int64(a) div %variant_to_int64(b);
    VT_R8:   OleVariant(Result).dblVal := %variant_to_double(a) / %variant_to_double(b);
    VT_BOOL: OleVariant(Result).vbool := LongBool(%variant_to_longint(a) div %variant_to_longint(b));
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_mod (const a, b: Variant): Variant;
begin
  OleVariant(Result).vt := VariantResType(a, b);
  case OleVariant(Result).vt of
    VT_I4:   OleVariant(Result).lVal := %variant_to_longint(a) mod %variant_to_longint(b);
    VT_I8:   OleVariant(Result).llVal := %variant_to_int64(a) mod %variant_to_int64(b);
    VT_BOOL: OleVariant(Result).vbool := LongBool(%variant_to_longint(a) mod %variant_to_longint(b));
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_or (const a, b: Variant): Variant;
begin
  OleVariant(Result).vt := VariantResType(a, b);
  case OleVariant(Result).vt of
    VT_I4:   OleVariant(Result).lVal := %variant_to_longint(a) or %variant_to_longint(b);
    VT_I8:   OleVariant(Result).llVal := %variant_to_int64(a) or %variant_to_int64(b);
    VT_BOOL: OleVariant(Result).vbool := %variant_to_boolean(a) or %variant_to_boolean(b);
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_xor (const a, b: Variant): Variant;
begin
  OleVariant(Result).vt := VariantResType(a, b);
  case OleVariant(Result).vt of
    VT_I4:   OleVariant(Result).lVal := %variant_to_longint(a) xor %variant_to_longint(b);
    VT_I8:   OleVariant(Result).llVal := %variant_to_int64(a) xor %variant_to_int64(b);
    VT_BOOL: OleVariant(Result).vbool := %variant_to_boolean(a) xor %variant_to_boolean(b);
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_and (const a, b: Variant): Variant;
begin
  OleVariant(Result).vt := VariantResType(a, b);
  case OleVariant(Result).vt of
    VT_I4:   OleVariant(Result).lVal := %variant_to_longint(a) and %variant_to_longint(b);
    VT_I8:   OleVariant(Result).llVal := %variant_to_int64(a) and %variant_to_int64(b);
    VT_BOOL: OleVariant(Result).vbool := %variant_to_boolean(a) and %variant_to_boolean(b);
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_not (const a: Variant): Variant;
begin
  OleVariant(Result).vt := OleVariant(a).vt;
  case OleVariant(Result).vt of
    VT_I4:   OleVariant(Result).lVal := not %variant_to_longint(a);
    VT_I8:   OleVariant(Result).llVal := not %variant_to_int64(a);
    VT_BOOL: OleVariant(Result).vbool := not %variant_to_boolean(a);
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_shl (const a, b: Variant): Variant;
begin
  OleVariant(Result).vt := VariantResType(a, b);
  case OleVariant(Result).vt of
    VT_I4:   OleVariant(Result).lVal := %variant_to_longint(a) shl %variant_to_longint(b);
    VT_I8:   OleVariant(Result).llVal := %variant_to_int64(a) shl %variant_to_longint(b);
    VT_BOOL: OleVariant(Result).vbool := LongBool(%variant_to_longint(a) shl %variant_to_longint(b));
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_shr (const a, b: Variant): Variant;
begin
  OleVariant(Result).vt := VariantResType(a, b);
  case OleVariant(Result).vt of
    VT_I4:   OleVariant(Result).lVal := %variant_to_longint(a) shr %variant_to_longint(b);
    VT_I8:   OleVariant(Result).llVal := %variant_to_int64(a) shr %variant_to_longint(b);
    VT_BOOL: OleVariant(Result).vbool := LongBool(%variant_to_longint(a) shr %variant_to_longint(b));
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_eq(const a: Variant; const b: Variant): Boolean;
begin
 case VariantResType(a, b) of
   VT_I4, VT_I8:   Result := %variant_to_int64(a) = %variant_to_longint(b);
   VT_R8:   Result := %variant_to_double(a) = %variant_to_double(b);
   VT_BOOL: Result := %variant_to_longint(a) = %variant_to_longint(b);
 else
   RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_ne(const a: Variant; const b: Variant): Boolean;
begin
 case VariantResType(a, b) of
   VT_I4, VT_I8:   Result := %variant_to_int64(a) <> %variant_to_int64(b);
   VT_R8:   Result := %variant_to_double(a) <> %variant_to_double(b);
   VT_BOOL: Result := %variant_to_longint(a) <> %variant_to_longint(b);
 else
   RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_ge(const a: Variant; const b: Variant): Boolean;
begin
 case VariantResType(a, b) of
   VT_I4, VT_I8:   Result := %variant_to_int64(a) >= %variant_to_int64(b);
   VT_R8:   Result := %variant_to_double(a) >= %variant_to_double(b);
   VT_BOOL: Result := %variant_to_longint(a) >= %variant_to_longint(b);
 else
   RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_gt(const a: Variant; const b: Variant): Boolean;
begin
 case VariantResType(a, b) of
   VT_I4, VT_I8:   Result := %variant_to_int64(a) > %variant_to_int64(b);
   VT_R8:   Result := %variant_to_double(a) > %variant_to_double(b);
   VT_BOOL: Result := %variant_to_longint(a) > %variant_to_longint(b);
 else
   RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_le(const a: Variant; const b: Variant): Boolean;
begin
 case VariantResType(a, b) of
   VT_I4, VT_I8:   Result := %variant_to_int64(a) <= %variant_to_int64(b);
   VT_R8:   Result := %variant_to_double(a) <= %variant_to_double(b);
   VT_BOOL: Result := %variant_to_longint(a) <= %variant_to_longint(b);
 else
   RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

function %variant_lt(const a: Variant; const b: Variant): Boolean;
begin
  case VariantResType(a, b) of
    VT_I4, VT_I8:   Result := %variant_to_int64(a) < %variant_to_int64(b);
    VT_R8:   Result := %variant_to_double(a) < %variant_to_double(b);
    VT_BOOL: Result := %variant_to_longint(a) < %variant_to_longint(b);
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

procedure %sys_write_variant conv (arg_reverse + arg_no_drop_1) (w: Integer; const value: Variant; var f: text);
var
  val: OleVariant absolute value;
begin
  case OleVariant(val).vt of
    VT_UI1:   Write(f, val.bVal);
    VT_I2:    Write(f, val.iVal);
    VT_I4:    Write(f, val.lVal);
    VT_I8:    Write(f, val.llVal);
    VT_R4:    Write(f, val.fltVal);
    VT_R8:    Write(f, val.dblVal);
    VT_BOOL:  Write(f, val.vbool);
    VT_ERROR: Write(f, val.scode);
    VT_CY:    Write(f, val.cyVal);
    VT_DATE:  Write(f, val.date);
    VT_BSTR:  Write(f, val.bstrVal);
    VT_I1:    Write(f, val.cVal);
    VT_UI2:   Write(f, val.uiVal);
    VT_UI4:   Write(f, val.ulVal);
    VT_INT:   Write(f, val.intVal);
    VT_UINT:  Write(f, val.uintVal);
    VT_BYREF: Write(f, HexStr(DWORD(val.byRef), 8));
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
end;

{$endif}