(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       The System Unit                                        *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Authors: Anton Moscal, Vadim Bodrov                    *)
(*                                                              *)
(****************************************************************)

unit System;

{$oa+,ac+}
{$system}

interface {$define interface}

type
  Real = Real48;

  LongRec = packed record
    Lo, Hi: Word;
  end;

  LongLongRec = packed record
    Lo: DWORD;
    Hi: Longint;
  end;

type
  PGUID = ^TGUID;
  TGUID = packed record
    D1: Longint;
    D2: Word;
    D3: Word;
    D4: array[0..7] of Byte;
  end;
  TIID    = TGUID;

type
  IUnknown = interface
    function QueryInterface (const iid: TIID; var obj): LongInt; stdcall;
    function AddRef: Longint; stdcall;
    function Release: Longint; stdcall;
  end;

  TInterfacedObject = object
    function QueryInterface (const iid: TIID; var obj): LongInt; stdcall; virtual;
    function AddRef: Longint; stdcall; virtual;
    function Release: Longint; stdcall; virtual;
  end;

type
  SmallWord  = Word;
  ULong      = LongInt;
  Short      = SmallInt;
  UShort     = Word;
  Cardinal   = DWORD;
  LongWord   = DWORD;
  Integer    = Longint;

  PSmallWord = ^SmallWord;
  PULong     = ^ULong;
  PShort     = ^Short;
  PUShort    = ^UShort;
  PByte      = ^Byte;
  PLongWord  = ^LongWord;
  PLongint   = ^Longint;
  PInteger   = ^Integer;
  PSmallInt  = ^SmallInt;
  PDWORD     = ^DWORD;
  PWord      = ^Word;
  PDouble    = ^Double;
  PSingle    = ^Single;
  PReal      = ^Real;
  PExtended  = ^Extended;

  HRESULT    = Longint;

  Boolean    = False..True;
  Bool       = LongBool;
  PBool      = ^Bool;

{$i int64.inc}

const
  LongTRUE   = LongBool($FFFFFFFF);
  LongFALSE  = LongBool(0);
  WordTRUE   = WordBool($FFFF);
  WordFALSE  = WordBool(0);
  ByteTRUE   = ByteBool($FF);
  ByteFALSE  = ByteBool(0);

const
  MAXSMALL    = High(SmallInt);
  MAXSMALLINT = High(SmallInt);
  MAXINT      = High(Integer);
  MAXINTEGER  = High(Integer);
  MAXWORD     = High(Word);
  MAXLONG     = High(Longint);
  MAXLONGINT  = High(Longint);
  MAXDWORD    = High(DWORD);
  MAXCARDINAL = High(Cardinal);
  MAXINT64    = High(Int64);

  MINSMALL    = Low(SmallInt);
  MINSMALLINT = Low(SmallInt);
  MININT      = Low(Integer);
  MININTEGER  = Low(Integer);
  MINWORD     = Low(Word);
  MINLONG     = Low(Longint);
  MINLONGINT  = Low(Longint);
  MINDWORD    = Low(DWORD);
  MINCARDINAL = Low(Cardinal);
  MININT64    = Low(Int64);

const
  Test8086: DWORD = 2; // Always is 2 (386 or later)
  Test8087: DWORD = 3; // DOS: 3 for (387 or later) or 0 if FPU is absent
                       // OS/2 and Win32: Always is 3 (387 or later)
const
  arg_reverse        = [0];
  arg_proc_16        = [2];
  arg_noregsave      = [3];
  arg_no_drop_1      = [4];
  arg_no_drop_2      = [5];
  arg_no_drop_3      = arg_no_drop_1 + arg_no_drop_2;
  arg_no_drop_4      = [6];
  arg_no_drop_5      = arg_no_drop_1 + arg_no_drop_4;
  arg_no_drop_6      = arg_no_drop_2 + arg_no_drop_4;
  arg_no_drop_all    = [4..6];
  arg_IO_test        = [8];
  arg_save_edi       = [9];
  arg_save_esi       = [10];
  arg_no_fp_on_stack = [11];
  arg_based          = [12];
  arg_stdcall        = arg_reverse + arg_noregsave + arg_save_edi + arg_save_esi;
  arg_cdecl          = arg_reverse + arg_no_drop_all;
  arg_os2            = arg_cdecl + arg_noregsave;
  arg_os2_16         = arg_proc_16 + arg_no_drop_all + arg_noregsave;
  arg_pascal         = arg_noregsave;

const
  //////////// Variant const declaration /////////////
  VT_EMPTY           = 0;
  VT_NULL            = 1;
  VT_I2              = 2;
  VT_I4              = 3;
  VT_R4              = 4;
  VT_R8              = 5;
  VT_CY              = 6;
  VT_DATE            = 7;
  VT_BSTR            = 8;
  VT_DISPATCH        = 9;
  VT_ERROR           = 10;
  VT_BOOL            = 11;
  VT_VARIANT         = 12;
  VT_UNKNOWN         = 13;
  VT_DECIMAL         = 14;

  VT_I1              = 16;
  VT_UI1             = 17;
  VT_UI2             = 18;
  VT_UI4             = 19;
  VT_I8              = 20;
  VT_UI8             = 21;
  VT_INT             = 22;
  VT_UINT            = 23;
  VT_VOID            = 24;
  VT_HRESULT         = 25;
  VT_PTR             = 26;
  VT_SAFEARRAY       = 27;
  VT_CARRAY          = 28;
  VT_USERDEFINED     = 29;
  VT_LPSTR           = 30;
  VT_LPWSTR          = 31;

  VT_FILETIME        = 64;
  VT_BLOB            = 65;
  VT_STREAM          = 66;
  VT_STORAGE         = 67;
  VT_STREAMED_OBJECT = 68;
  VT_STORED_OBJECT   = 69;
  VT_BLOB_OBJECT     = 70;
  VT_CF              = 71;
  VT_CLSID           = 72;

  VT_VECTOR        = $1000;
  VT_ARRAY         = $2000;
  VT_BYREF         = $4000;
  VT_RESERVED      = $8000;
  VT_ILLEGAL       = $FFFF;
  VT_ILLEGALMASKED = $0FFF;
  VT_TYPEMASK      = $0FFF;
  ////////////////////////////////////////////////////

type
  //////////// Variant type declaration /////////////
  TVarType = Word;

  TOleBool = WordBool;
  POleBool = ^TOleBool;

  %HResult  = Longint;
  %Currency = Double;
  %TOleDate = Double;
  %TBStr    = PWChar;
  %TOleBool = WordBool;

  %SAFEARRAYBOUND = record
    cElements: Longint;
    lLbound: Longint;
  end;

  %PSafeArray = ^%TSafeArray;
  %TSafeArray = record
    cDims: Word;
    fFeatures: Word;
    cbElements: Longint;
    cLocks: Longint;
    pvData: Pointer;
    rgsabound: array[0..0] of %SAFEARRAYBOUND;
  end;

  %IDispatch = interface(IUnknown)
    ['{00020400-0000-0000-C000-000000000046}']
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
  end;

  %PDecimal = ^%TDecimal;
  %TDecimal = record
    wReserved: Word;
    case Integer of
      0: (scale, sign: Byte; Hi32: Longint;
      case Integer of
        0: (Lo32, Mid32: Longint);
        1: (Lo64: Int64));
      1: (signscale: Word);
  end;

  PVariant = ^Variant;
  POleVariant = ^%Variant;
  %Variant = record
    vt: TVarType;
    wReserved1: Word;
    wReserved2: Word;
    wReserved3: Word;
    case Integer of
      VT_UI1:                  (bVal: Byte);
      VT_I2:                   (iVal: Smallint);
      VT_I4:                   (lVal: Longint);
      VT_I8:                   (llVal: Int64);
      VT_R4:                   (fltVal: Single);
      VT_R8:                   (dblVal: Double);
      VT_BOOL:                 (vbool: TOleBool);
      VT_ERROR:                (scode: %HResult);
      VT_CY:                   (cyVal: %Currency);
      VT_DATE:                 (date: %TOleDate);
      VT_BSTR:                 (bstrVal: %TBStr);
      VT_UNKNOWN:              (unkVal: Pointer);
      VT_DISPATCH:             (dispVal: Pointer);
      VT_ARRAY:                (parray: %PSafeArray);
      VT_BYREF or VT_UI1:      (pbVal: ^Byte);
      VT_BYREF or VT_I2:       (piVal: ^Smallint);
      VT_BYREF or VT_I4:       (plVal: ^Longint);
      VT_BYREF or VT_R4:       (pfltVal: ^Single);
      VT_BYREF or VT_R8:       (pdblVal: ^Double);
      VT_BYREF or VT_BOOL:     (pbool: ^%TOleBool);
      VT_BYREF or VT_ERROR:    (pscode: ^%HResult);
      VT_BYREF or VT_CY:       (pcyVal: ^%Currency);
      VT_BYREF or VT_DATE:     (pdate: ^%TOleDate);
      VT_BYREF or VT_BSTR:     (pbstrVal: ^%TBStr);
      VT_BYREF or VT_UNKNOWN:  (punkVal: ^IUnknown);
      VT_BYREF or VT_DISPATCH: (pdispVal: ^%IDispatch);
      VT_BYREF or VT_ARRAY:    (pparray: ^%PSafeArray);
      VT_BYREF or VT_VARIANT:  (pvarVal: PVariant);
      VT_BYREF:                (byRef: Pointer);
      VT_I1:                   (cVal: Char);
      VT_UI2:                  (uiVal: Word);
      VT_UI4:                  (ulVal: LongWord);
      VT_INT:                  (intVal: Integer);
      VT_UINT:                 (uintVal: LongWord);
      VT_BYREF or VT_DECIMAL:  (pdecVal: %PDecimal);
      VT_BYREF or VT_I1:       (pcVal: PChar);
      VT_BYREF or VT_UI2:      (puiVal: PWord);
      VT_BYREF or VT_UI4:      (pulVal: PInteger);
      VT_BYREF or VT_INT:      (pintVal: PInteger);
      VT_BYREF or VT_UINT:     (puintVal: PLongWord);
  end;
  OleVariant = %Variant;
  TOleVariant = OleVariant;

  ///////////////////////////////////////////////////

function  ParamCount: Longint;
function  ParamStr(n: Longint): String;

procedure %runerror(code: Longint); %builtin 71;

procedure %sys_object_assn;         %builtin 17;
procedure %DMT_error;               %builtin 70;
procedure %halt(Code: Longint);     %builtin 72;
procedure %exit(Code: Longint);

{$i  variant.inc}
{$i  get_xxx.inc}
{$i  str_fun.inc}
{$i  chk_fun.inc}
{$i  mem_fun.inc}
{$i  set_fun.inc}
{$i sort_fun.inc}
{$i swap_fun.inc}
{$i  mem_alc.inc}
{$i math_fun.inc}
{$i    files.inc}
{$i  win_fun.inc}



var
  _zero: DWORD := 0; // dummy variable for compatibility with old versions

{$ifdef __DOS__}
type FarPointer = packed record
   Ofs: Pointer;
   Seg: Word
end;

const
  Seg0040: Word = $0040;
  SegA000: Word = $A000;
  SegB000: Word = $B000;
  SegB800: Word = $B800;

var
  _psp     : Pointer;
  _environ : PChar;
  ExeSize  : DWORD;
  ExeName  : PChar;
  buf_16   : Word;
  buf_32   : DWORD;
{$else}
type
  FarPointer = Pointer;
{$endif}

{$ifdef __OS2__}
var
  Mutex: Longint;

procedure mutex_up;
procedure mutex_down;
{$endif}

{$ifdef __WIN32__}
var
  _environ        : PChar;
  ExeName         : PChar;
  hInstance       : DWORD;
  hPrevInst       : DWORD := 0;
  MainInstance    : DWORD;
  CmdShow         : DWORD;
  CmdLine         : PChar;
  StdInputHandle  : DWORD := 0;
  StdOutputHandle : DWORD := 0;
  StdErrorHandle  : DWORD := 0;

  // Following variables used by CRT and GRAPH units to
  // emulate keyboard handling
  %KeyNumber      : Longint := 0;
  %KeyBuffer      : array[0..63] of Char;
  %InGraph        : Boolean := FALSE;  // InGraph is TRUE when DirectX
                                       // graphic mode is active
  %MouseLButton   : Boolean := FALSE;
  %MouseMButton   : Boolean := FALSE;
  %MouseRButton   : Boolean := FALSE;
  %GrMouseMask    : DWORD   := 0;
  %GrMouseHnd     : procedure(Mask, Buttons, X, Y, MovX, MovY: System.Word);
{$endif}

const
 %flat_ds %builtin 112 : Word = 2390;
 %flat_tr              : Word = 0;

const
 isConsole %builtin 115 : Boolean = False;
 isLibrary              : Boolean = False;

const
 ExitProcedure: procedure = nil;
var
  ExitProc: ^procedure absolute ExitProcedure;
  ErrorAddr: Pointer;
  ExitCode:  DWORD   := 0;
  HeapError: Pointer;

{$ifdef __WIN32__}
var
  HeapHandle: DWORD;
{$endif}

procedure %runerr_call_stack_proc(code, ebp, eip: DWORD);
const %runerr_call_stack_proc_addr: ^procedure(code, ebp, eip: DWORD) = @%runerr_call_stack_proc;

procedure %Assert(expr : Boolean; const fname: String; line: Integer);

implementation {$undef interface}

uses SysIO32, Arg, ErrCodes, Strings, Dos {$ifdef __OS2__}, DosCall, OS2Types {$endif}
  {$ifdef __WIN32__}, Windows, ActiveX {$endif};

{$r-,q-}
{$system}

function TInterfacedObject.QueryInterface (const iid: TIID; var obj): LongInt; begin end;
function TInterfacedObject.AddRef: Longint; begin end;
function TInterfacedObject.Release: Longint; begin end;

var
  SysMessage: String := '';

const
  cw: Word = $1372;

procedure System_Init; code;
   asm
     xor     eax, eax
     mov     [HeapError], eax
     mov     [ErrorAddr], eax
{$ifdef __DOS__}
     mov     edi, $410
     mov     al, Byte ptr [edi]
     and     al, 2
     jnz     @@Cont
     mov     [Test8087], 0
     ret
{$endif}
@@Cont:
     finit
     fwait
     fldcw   cw
     fwait
     ret
     db    0, 'TMT Pascal Runtime Library', 0
end;

{$ifdef __OS2__}
procedure mutex_down; DosRequestMutexSem(mutex, sem_indefinite_wait);
procedure mutex_up;   DosReleaseMutexSem(mutex);
procedure ex_unset; forward;
{$endif}

procedure do_exits;
begin
  while assigned (exitproc) do
  declare
  var
    pr: procedure;
  begin
    pr := exitprocedure;
    exitproc := nil;
    pr;
  end;
end;

procedure %RunErr_Call_Stack_Proc;
begin
  %tty(SysMessage + ^m^j + 'RunError #' + whl(code) + ' at ' + hex(eip) + ^m^j);
  SysMessage := '';
end;

procedure final_proc(code, ebp, eip: DWORD);
begin
  ErrorAddr := Pointer(eip);
  ExitCode  := code;
  do_exits;
  if ErrorAddr <> nil then
    %runerr_call_stack_proc_addr^(code, ebp, eip);
  %exit(4);
end;

procedure %Assert(expr : Boolean; const fname: String; line: Integer);
begin
  if not expr then
  begin
    SysMessage := 'Assertion error in file ''' + fname + ''', line: ' + Whl(line);
    {$IFDEF __WIN32__}
    declare
    var
      exp_addr: DWORD;
    begin
      asm
        mov  eax, [line - 4]
        dec  eax
        mov  [exp_addr], eax
      end;
      RaiseException(assertion_failed, EXCEPTION_NONCONTINUABLE, 1, @exp_addr);
    end;
    {$ELSE}
    RunError(assertion_failed);
    {$ENDIF}
  end;
end;

procedure %RunError;
begin
  final_proc(code, MemD[longint (@code)-8], MemD[longint(@code) - 4]);
end;

procedure %DMT_error;
begin
  RunError(object_not_initialized);
end;

procedure %halt;
begin
  ErrorAddr := nil;
  ExitCode  := code;
  do_exits;
  %exit(code)
end;

procedure %exit;
{$ifdef __OS2__}
begin
  if isLibrary then ex_unset;
  SysExit(code);
end;
{$endif}

{$ifdef __DOS__}
begin
  SysExit(code);
end;
{$endif}

{$ifdef __WIN32__}
begin
  SysExit(code);
end;
{$endif}

procedure %sys_object_assn; code;
      asm
        push    ecx
        push    esi
        push    edi
        mov     ecx, [esp+16]
        mov     ecx, [edi+ecx]
        mov     ecx, [ecx]
        rep     movsb
        pop     edi
        pop     esi
        pop     ecx
        ret     4
end;

{$l system}

{$ifdef __WIN32__}
function ParamCount;
begin
  Result := Argc -1
end;

function ParamStr;
begin
  Result := Argv(n + 1)
end;
{$else}

function ParamCount;
begin
  Result := Argc
end;

function ParamStr;
begin
  Result := Argv(n)
end;
{$endif}

{$i  variant.inc}
{$i  get_xxx.inc}
{$i  str_fun.inc}
{$i  chk_fun.inc}
{$i  mem_fun.inc}
{$i  set_fun.inc}
{$i sort_fun.inc}
{$i swap_fun.inc}
{$i  mem_alc.inc}
{$i math_fun.inc}
{$i    files.inc}
{$i  win_fun.inc}
{$i    int64.inc}

{$ifdef __OS2__}
var
  ex_addr: PExceptionRegistrationRecord;
  ex_rec:  ExceptionRegistrationRecord;
  rc:      ApiRet;
  ex_cnt:  ULong;

procedure ex_unset;
begin
  DosSetSignalExceptionFocus(Bool(sig_unsetfocus), ex_cnt);
  DosUnsetExceptionHandler(ex_addr^);
end;

procedure break_handler(code: Longint);
begin
  case code of
    xcpt_signal_killproc : RunError (break_by_other_process);
    xcpt_signal_intr     : RunError (break_by_ctrl_c       );
    xcpt_signal_break    : RunError (break_by_ctrl_break   );
  end
end;

function ex_handler conv arg_cdecl(p1: PExceptionReportRecord;
 p2: PExceptionRegistrationRecord; p3: PContextRecord; P: Pointer): ULong;
begin
  case p1^.ExceptionNum of
    xcpt_Array_Bounds_Exceeded  : final_proc(range_check_error, p3^.ctx_RegEbp, p3^.ctx_RegEip);
    xcpt_Integer_Overflow       : final_proc(arithmetic_overflow_error, p3^.ctx_RegEbp, p3^.ctx_RegEip);
    xcpt_BreakPoint             : final_proc(breakpoint_error, p3^.ctx_RegEbp, p3^.ctx_RegEip);
    xcpt_Access_Violation       : final_proc(general_protection_fault, p3^.ctx_RegEbp, p3^.ctx_RegEip);
    xcpt_Integer_Divide_by_zero,
    xcpt_Float_Divide_by_zero   : final_proc(division_by_zero, p3^.ctx_RegEbp, p3^.ctx_RegEip);
    xcpt_Float_Overflow         : final_proc(floating_point_overflow, p3^.ctx_RegEbp, p3^.ctx_RegEip);
    xcpt_Float_Underflow        : final_proc(floating_point_underflow, p3^.ctx_RegEbp, p3^.ctx_RegEip);
    xcpt_Float_Invalid_operation: final_proc(invalid_floating_point_operation, p3^.ctx_RegEbp, p3^.ctx_RegEip);
    xcpt_Unable_To_Grow_Stack   : final_proc(stack_overflow_error, p3^.ctx_RegEbp, p3^.ctx_RegEip);
    xcpt_Signal                 : break_handler(p1^.exceptioninfo[0]);
  end;
  Result := xcpt_continue_search;
end;

begin
  if not isLibrary then begin
    asm
      mov     %flat_ds, ds
      call    System_Init
      push    offset ex_handler
      push    0
      mov     ex_addr, esp
    end;
    DosCreateMutexSem(nil, mutex, 0, True);
    rc := DosSetExceptionHandler(ex_addr^);
    if rc <> 0 then RunError;
    rc := DosSetSignalExceptionFocus(Bool(sig_setfocus), ex_cnt);
    asm jmp DWORD ptr [ebp+8] end;
  end else begin
    asm mov %flat_ds, ds end;
    DosCreateMutexsem(nil, mutex, 0, TRUE);
  end;
end

postlude begin
 if isLibrary then do_exits else halt;
{$endif}

{$ifdef __DOS__}
procedure SaveEnv; assembler;
      asm
        mov    ax,0EE02h
        int    31h
        neg    ebx
        mov    _psp, esi
        mov    _environ, edi
        mov    _zero, ebx
        mov    exesize, edx
        mov    exename, ecx
        mov    word ptr buf_16, ax
        movzx  eax, ax
        shl    eax, 4
        add    eax, ebx
        mov    buf_32, eax
end;

var
  exc_eip: DWORD;
  exc_cs : Word;

procedure ZeroDv_Err
(
 eip, eax, ecx, edx, ebx, esp, ebp, esi, edi: DWORD;
 gs, fs, es{, ds}: word
); interrupt;
  final_proc(division_by_zero, ebp, eip);

procedure Exc_ZeroDv_Err
(
 eip, eax, ecx, edx, ebx, esp, ebp, esi, edi: DWORD;
 gs, fs, es{, ds}: word
); interrupt;
  final_proc(division_by_zero, ebp, eip);

procedure zdv; code;
      asm
        push    eax edi
        mov     eax, DWORD ptr [esp+$c+8]
        mov     DWORD ptr [esp+$c+8], offset exc_zerodv_err
        mov     edi, [esp+$18+8]
        sub     DWORD ptr [esp+$18+8], 8
        mov     [edi-8], eax
        pop     edi eax
        retf
end;

procedure Bounds_Err
(
 eip, eax, ecx, edx, ebx, esp, ebp, esi, edi: DWORD;
 gs, fs, es{, ds}: word
); interrupt;
  final_proc(range_check_error, ebp, eip);

procedure bnd; code;
      asm
        push    eax edi
        mov     eax, DWORD ptr [esp+$c+8]
        mov     DWORD ptr [esp+$c+8], offset bounds_err
        mov     edi, [esp+$18+8]
        sub     DWORD ptr [esp+$18+8], 8
        mov     [edi-8], eax
        pop     edi eax
        retf
end;

procedure Stack_Overflow_Err
(
 eip, eax, ecx, edx, ebx, esp, ebp, esi, edi: DWORD;
 gs, fs, es{, ds}: word
); interrupt;
  final_proc(stack_overflow_error, ebp, eip);

procedure stk; code;
      asm
        push    eax edi
        mov     eax, DWORD ptr [esp+$c+8]
        mov     DWORD ptr [esp+$c+8], Stack_Overflow_Err
        mov     edi, [esp+$18+8]
        sub     DWORD ptr [esp+$18+8], 8
        mov     [edi-8], eax
        pop     edi eax
        retf
end;

procedure Overfl_Err
(
 eip, eax, ecx, edx, ebx, esp, ebp, esi, edi: DWORD;
 gs, fs, es{, ds}: word
); interrupt;
  final_proc(arithmetic_overflow_error, ebp, eip);

procedure ofl; code;
      asm
        push    eax edi
        mov     eax, DWORD ptr [esp+$c+8]
        mov     DWORD ptr [esp+$c+8], offset overfl_err
        mov     edi, [esp+$18+8]
        sub     DWORD ptr [esp+$18+8], 8
        mov     [edi-8], eax
        pop     edi eax
        retf
end;

procedure OpCode_Err
(
 eip, eax, ecx, edx, ebx, esp, ebp, esi, edi: DWORD;
 gs, fs, es{, ds}: word
); interrupt;
  final_proc(invalid_operation_code, ebp, eip);

procedure opp; code;
      asm
        push    eax edi
        mov     eax, DWORD ptr [esp+$c+8]
        mov     DWORD ptr [esp+$c+8], offset opcode_err
        mov     edi, [esp+$18+8]
        sub     DWORD ptr [esp+$18+8], 8
        mov     [edi-8], eax
        pop     edi eax
        retf
end;

procedure GPFault_Err
(
 eip, eax, ecx, edx, ebx, esp, ebp, esi, edi: DWORD;
 gs, fs, es{, ds}: word
); interrupt;
  final_proc(general_protection_fault, ebp, eip);

procedure gpf; code;
      asm
        push    eax edi
        mov     eax, DWORD ptr [esp+$c+8]
        mov     DWORD ptr [esp+$c+8], offset gpfault_err
        mov     edi, [esp+$18+8]
        sub     DWORD ptr [esp+$18+8], 8
        mov     [edi-8], eax
        pop     edi eax
        retf
end;

procedure CoProc_Err
(
 eip, eax, ecx, edx, ebx, esp, ebp, esi, edi: DWORD;
 gs, fs, es{, ds}: word
); interrupt;
  final_proc(invalid_floating_point_operation, ebp, eip);

procedure cop; code;
      asm
        push    eax edi
        mov     eax, DWORD ptr [esp+$c+8]
        mov     DWORD ptr [esp+$c+8], offset CoProc_Err
        mov     edi, [esp+$18+8]
        sub     DWORD ptr [esp+$18+8], 8
        mov     [edi-8], eax
        pop     edi eax
        retf
end;

procedure NoCoproc_Err
(
 eip, eax, ecx, edx, ebx, esp, ebp, esi, edi: DWORD;
 gs, fs, es{, ds}: word
); interrupt;
const
  flag: Boolean = false;
begin
  if flag then
    flag := false
  else
    final_proc(no_floating_point_processor, ebp, eip);
end;

procedure restore_system;
var
  iv: int_vecs;
  ie: exc_vecs;
begin
  for iv := low(int_vecs) to high(int_vecs) do
    SetIntVecFar(int_vecs_no [iv], int_save[iv]);
  for ie := low(exc_vecs) to high(exc_vecs) do
    SetExcVecFar(exc_vecs_no [ie], exc_save[ie]);
end;

var
  iv: int_vecs;
  ie: exc_vecs;
begin
  isConsole := true;
  asm mov %flat_ds, ds; end;
  intr_init(16, 2048);
  SaveEnv;
  for iv := low(int_vecs) to high(int_vecs) do
    GetIntVecFar(int_vecs_no[iv], int_save[iv]);
  for ie := low(exc_vecs) to high(exc_vecs) do
    GetExcVecFar(exc_vecs_no[ie], exc_save[ie]);

  SetIntVec($00, @ZeroDv_Err);
  SetExcVec($00, @zdv);
  SetIntVec($02, @Overfl_Err);
  SetExcVec($02, @ofl);
  SetIntVec($04, @Overfl_Err);
  SetExcVec($04, @ofl);
  SetIntVec($05, @Bounds_Err);
  SetExcVec($05, @bnd);
  SetIntVec($06, @OpCode_Err);
  SetExcVec($06, @opp);
  SetIntVec($07, @NoCoproc_Err);
  SetExcVec($08, @GPF);
  SetExcVec($09, @GPF);
  SetExcVec($0A, @GPF);
  SetExcVec($0B, @GPF);
  SetExcVec($0C, @GPF);
  SetExcVec($0D, @GPF);
  SetExcVec($0E, @GPF);
  SetIntVec($75, @CoProc_Err);
  SetExcVec($75, @cop);
  System_Init;
  exitprocedure := restore_system;
end
postlude begin
  halt;
{$endif}

{$ifdef __WIN32__}
var
 exc_eip    : DWORD;
 exc_cs     : Word;
 FileNameBuf: array [0..MAX_PATH - 1] of Char;
 StInfo     : TStartupInfo;

procedure Restore_System;
begin
 SetUnhandledExceptionFilter(nil);
 HeapDestroy(HeapHandle);
 FreeEnvironmentStrings(_environ);
end;

function ExceptionHandler conv arg_stdcall (var ExPt: TExceptionPointers): DWORD;
var
  ExitCode: DWORD;
begin
{$system}
 case ExPt.ExceptionRecord^.ExceptionCode of
  STATUS_ARRAY_BOUNDS_EXCEEDED  : ExitCode := range_check_error;
  STATUS_INTEGER_OVERFLOW       : ExitCode := arithmetic_overflow_error;
  STATUS_BREAKPOINT             : ExitCode := breakpoint_error;
  STATUS_ACCESS_VIOLATION       : ExitCode := general_protection_fault;
  STATUS_FLOAT_DIVIDE_BY_ZERO,
  STATUS_INTEGER_DIVIDE_BY_ZERO : ExitCode := division_by_zero;
  STATUS_FLOAT_OVERFLOW         : ExitCode := floating_point_overflow;
  STATUS_FLOAT_UNDERFLOW        : ExitCode := floating_point_underflow;
  STATUS_FLOAT_INVALID_OPERATION: ExitCode := invalid_floating_point_operation;
  STATUS_STACK_OVERFLOW         : ExitCode := stack_overflow_error;
 else
  ExitCode := ExPt.ExceptionRecord^.ExceptionCode;
 end;
 with Expt.Contextrecord^ do
   final_proc(ExitCode, ebp, eip);
 Result := 1;
end;

begin
 System_Init;

{$i-}

 ExitProcedure := Restore_System;

 SetUnhandledExceptionFilter(@ExceptionHandler);
 HeapHandle := HeapCreate(0,0,0);

 if isConsole then begin
   StdInputHandle  := GetStdHandle(STD_INPUT_HANDLE);
   StdOutputHandle := GetStdHandle(STD_OUTPUT_HANDLE);
   StdErrorHandle  := GetStdHandle(STD_ERROR_HANDLE);
   Assign(input,'');
   Reset(input);
   Assign(output,'');
   Rewrite(output);
 end;

 if not isLibrary then
 begin
   GetStartupInfo(StInfo);
   if (StInfo.dwFlags and 1) <> 0
   then CmdShow := StInfo.wShowWindow
   else CmdShow := 10;

   CmdLine := GetCommandLine;

   HInstance := GetModuleHandle(nil);
   MainInstance := HInstance;
   FillChar(FileNameBuf, MAX_PATH, 0);
   GetModuleFileName(HInstance, FileNameBuf, MAX_PATH);

   _environ := GetEnvironmentStrings;
   exename  := @FileNameBuf;
 end else
 begin
   CmdShow := 0;
   CmdLine := nil;
 end;
end

postlude begin
  if not isLibrary then halt;
{$endif}
end.