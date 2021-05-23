(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit API Library Functions                    *)
(*       Based on imm.h                                         *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995-98 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

/**********************************************************************/
/*      IMM.H - Input Method Manager definitions                      */
/*                                                                    */
/*      Copyright 1993 - 1998 Microsoft Corporation                   */
/**********************************************************************/

unit Imm;

interface

uses Windows;

const
  Imm32DLL                       = 'Imm32Dll.DLL';

  VK_PROCESSKEY                  = $E5;
  STYLE_DESCRIPTION_SIZE         = 32;

  WM_CONVERTREQUESTEX            = $0108;
  WM_IME_STARTCOMPOSITION        = $010D;
  WM_IME_ENDCOMPOSITION          = $010E;
  WM_IME_COMPOSITION             = $010F;
  WM_IME_KEYLAST                 = $010F;

  WM_IME_SETCONTEXT              = $0281;
  WM_IME_NOTIFY                  = $0282;
  WM_IME_CONTROL                 = $0283;
  WM_IME_COMPOSITIONFULL         = $0284;
  WM_IME_SELECT                  = $0285;
  WM_IME_CHAR                    = $0286;

  WM_IME_KEYDOWN                 = $0290;
  WM_IME_KEYUP                   = $0291;

// wParam for WM_IME_CONTROL
  IMC_GETCANDIDATEPOS            = $0007;
  IMC_SETCANDIDATEPOS            = $0008;
  IMC_GETCOMPOSITIONFONT         = $0009;
  IMC_SETCOMPOSITIONFONT         = $000A;
  IMC_GETCOMPOSITIONWINDOW       = $000B;
  IMC_SETCOMPOSITIONWINDOW       = $000C;
  IMC_GETSTATUSWINDOWPOS         = $000F;
  IMC_SETSTATUSWINDOWPOS         = $0010;
  IMC_CLOSESTATUSWINDOW          = $0021;
  IMC_OPENSTATUSWINDOW           = $0022;

// dwAction for ImmNotifyIME
  NI_OPENCANDIDATE               = $0010;
  NI_CLOSECANDIDATE              = $0011;
  NI_SELECTCANDIDATESTR          = $0012;
  NI_CHANGECANDIDATELIST         = $0013;
  NI_FINALIZECONVERSIONRESULT    = $0014;
  NI_COMPOSITIONSTR              = $0015;
  NI_SETCANDIDATE_PAGESTART      = $0016;
  NI_SETCANDIDATE_PAGESIZE       = $0017;

// lParam for WM_IME_SETCONTEXT
  ISC_SHOWUICANDIDATEWINDOW      = $00000001;
  ISC_SHOWUICOMPOSITIONWINDOW    = $80000000;
  ISC_SHOWUIGUIDELINE            = $40000000;
  ISC_SHOWUIALLCANDIDATEWINDOW   = $0000000F;
  ISC_SHOWUIALL                  = $C000000F;

// dwIndex for ImmNotifyIME/NI_COMPOSITIONSTR
  CPS_COMPLETE                   = $0001;
  CPS_CONVERT                    = $0002;
  CPS_REVERT                     = $0003;
  CPS_CANCEL                     = $0004;

// the modifiers of hot key
  MOD_ALT                        = $0001;
  MOD_CONTROL                    = $0002;
  MOD_SHIFT                      = $0004;

  MOD_LEFT                       = $8000;
  MOD_RIGHT                      = $4000;

  MOD_ON_KEYUP                   = $0800;
  MOD_IGNORE_ALL_MODIFIER        = $0400;

// Windows for Simplified Chinese Edition hot key ID from 0x10 - 0x2F
  IME_CHOTKEY_IME_NONIME_TOGGLE          = $10;
  IME_CHOTKEY_SHAPE_TOGGLE               = $11;
  IME_CHOTKEY_SYMBOL_TOGGLE              = $12;

// Windows for Japanese Edition hot key ID from 0x30 - 0x4F
  IME_JHOTKEY_CLOSE_OPEN                 = $30;

// Windows for Korean Edition hot key ID from 0x50 - 0x6F
  IME_KHOTKEY_SHAPE_TOGGLE               = $50;
  IME_KHOTKEY_HANJACONVERT               = $51;
  IME_KHOTKEY_ENGLISH                    = $52;

// Windows for Traditional Chinese Edition hot key ID from 0x70 - 0x8F
  IME_THOTKEY_IME_NONIME_TOGGLE          = $70;
  IME_THOTKEY_SHAPE_TOGGLE               = $71;
  IME_THOTKEY_SYMBOL_TOGGLE              = $72;

// direct switch hot key ID from 0x100 - 0x11F
  IME_HOTKEY_DSWITCH_FIRST               = $100;
  IME_HOTKEY_DSWITCH_LAST                = $11F;

// IME private hot key from 0x200 - 0x21F
  IME_ITHOTKEY_RESEND_RESULTSTR          = $200;
  IME_ITHOTKEY_PREVIOUS_COMPOSITION      = $201;
  IME_ITHOTKEY_UISTYLE_TOGGLE            = $202;

// parameter of ImmGetCompositionString
  GCS_COMPREADSTR                = $0001;
  GCS_COMPREADATTR               = $0002;
  GCS_COMPREADCLAUSE             = $0004;
  GCS_COMPSTR                    = $0008;
  GCS_COMPATTR                   = $0010;
  GCS_COMPCLAUSE                 = $0020;
  GCS_CURSORPOS                  = $0080;
  GCS_DELTASTART                 = $0100;
  GCS_RESULTREADSTR              = $0200;
  GCS_RESULTREADCLAUSE           = $0400;
  GCS_RESULTSTR                  = $0800;
  GCS_RESULTCLAUSE               = $1000;

// style bit flags for WM_IME_COMPOSITION
  CS_INSERTCHAR                  = $2000;
  CS_NOMOVECARET                 = $4000;

// bits of fdwInit of INPUTCONTEXT
// IME version constants
  IMEVER_0310                    = $0003000A;
  IMEVER_0400                    = $00040000;

// IME property bits
  IME_PROP_AT_CARET              = $00010000;
  IME_PROP_SPECIAL_UI            = $00020000;
  IME_PROP_CANDLIST_START_FROM_1 = $00040000;
  IME_PROP_UNICODE               = $00080000;

// IME UICapability bits
  UI_CAP_2700                    = $00000001;
  UI_CAP_ROT90                   = $00000002;
  UI_CAP_ROTANY                  = $00000004;

// ImmSetCompositionString Capability bits
  SCS_CAP_COMPSTR                = $00000001;
  SCS_CAP_MAKEREAD               = $00000002;

// IME WM_IME_SELECT inheritance Capability bits
  SELECT_CAP_CONVERSION          = $00000001;
  SELECT_CAP_SENTENCE            = $00000002;

// ID for deIndex of ImmGetGuideLine
  GGL_LEVEL                      = $00000001;
  GGL_INDEX                      = $00000002;
  GGL_STRING                     = $00000003;
  GGL_PRIVATE                    = $00000004;

// ID for dwLevel of GUIDELINE Structure
  GL_LEVEL_NOGUIDELINE           = $00000000;
  GL_LEVEL_FATAL                 = $00000001;
  GL_LEVEL_ERROR                 = $00000002;
  GL_LEVEL_WARNING               = $00000003;
  GL_LEVEL_INFORMATION           = $00000004;

// ID for dwIndex of GUIDELINE Structure
  GL_ID_UNKNOWN                  = $00000000;
  GL_ID_NOMODULE                 = $00000001;
  GL_ID_NODICTIONARY             = $00000010;
  GL_ID_CANNOTSAVE               = $00000011;
  GL_ID_NOCONVERT                = $00000020;
  GL_ID_TYPINGERROR              = $00000021;
  GL_ID_TOOMANYSTROKE            = $00000022;
  GL_ID_READINGCONFLICT          = $00000023;
  GL_ID_INPUTREADING             = $00000024;
  GL_ID_INPUTRADICAL             = $00000025;
  GL_ID_INPUTCODE                = $00000026;
  GL_ID_INPUTSYMBOL              = $00000027;
  GL_ID_CHOOSECANDIDATE          = $00000028;
  GL_ID_REVERSECONVERSION        = $00000029;
  GL_ID_PRIVATE_FIRST            = $00008000;
  GL_ID_PRIVATE_LAST             = $0000FFFF;

// ID for dwIndex of ImmGetProperty
  IGP_GETIMEVERSION              = 4;
  IGP_PROPERTY                   = $00000004;
  IGP_CONVERSION                 = $00000008;
  IGP_SENTENCE                   = $0000000c;
  IGP_UI                         = $00000010;
  IGP_SETCOMPSTR                 = $00000014;
  IGP_SELECT                     = $00000018;

// dwIndex for ImmSetCompositionString API
  SCS_SETSTR                     = (GCS_COMPREADSTR or GCS_COMPSTR);
  SCS_CHANGEATTR                 = (GCS_COMPREADATTR or GCS_COMPATTR);
  SCS_CHANGECLAUSE               = (GCS_COMPREADCLAUSE or GCS_COMPCLAUSE);

// attribute for COMPOSITIONSTRING Structure
  ATTR_INPUT                     = $00;
  ATTR_TARGET_CONVERTED          = $01;
  ATTR_CONVERTED                 = $02;
  ATTR_TARGET_NOTCONVERTED       = $03;
  ATTR_INPUT_ERROR               = $04;

// bit field for IMC_SETCOMPOSITIONWINDOW, IMC_SETCANDIDATEWINDOW
  CFS_DEFAULT                    = $0000;
  CFS_RECT                       = $0001;
  CFS_POINT                      = $0002;
  CFS_SCREEN                     = $0004;
  CFS_FORCE_POSITION             = $0020;
  CFS_CANDIDATEPOS               = $0040;
  CFS_EXCLUDE                    = $0080;

// conversion direction for ImmGetConversionList
  GCL_CONVERSION                 = $0001;
  GCL_REVERSECONVERSION          = $0002;
  GCL_REVERSE_LENGTH             = $0003;

// bit field for conversion mode
  IME_CMODE_ALPHANUMERIC         = $0000;
  IME_CMODE_NATIVE               = $0001;
  IME_CMODE_CHINESE              = IME_CMODE_NATIVE;
  IME_CMODE_HANGEUL              = IME_CMODE_NATIVE;
  IME_CMODE_JAPANESE             = IME_CMODE_NATIVE;
  IME_CMODE_KATAKANA             = $0002;  // only effect under IME_CMODE_NATIVE
  IME_CMODE_LANGUAGE             = $0003;
  IME_CMODE_FULLSHAPE            = $0008;
  IME_CMODE_ROMAN                = $0010;
  IME_CMODE_CHARCODE             = $0020;
  IME_CMODE_HANJACONVERT         = $0040;
  IME_CMODE_SOFTKBD              = $0080;
  IME_CMODE_NOCONVERSION         = $0100;
  IME_CMODE_EUDC                 = $0200;
  IME_CMODE_SYMBOL               = $0400;

  IME_SMODE_NONE                 = $0000;
  IME_SMODE_PLAURALCLAUSE        = $0001;
  IME_SMODE_SINGLECONVERT        = $0002;
  IME_SMODE_AUTOMATIC            = $0004;
  IME_SMODE_PHRASEPREDICT        = $0008;

// style of candidate
  IME_CAND_UNKNOWN               = $0000;
  IME_CAND_READ                  = $0001;
  IME_CAND_CODE                  = $0002;
  IME_CAND_MEANING               = $0003;
  IME_CAND_RADICAL               = $0004;
  IME_CAND_STROKE                = $0005;

// wParam of report message WM_IME_NOTIFY
  IMN_CLOSESTATUSWINDOW          = $0001;
  IMN_OPENSTATUSWINDOW           = $0002;
  IMN_CHANGECANDIDATE            = $0003;
  IMN_CLOSECANDIDATE             = $0004;
  IMN_OPENCANDIDATE              = $0005;
  IMN_SETCONVERSIONMODE          = $0006;
  IMN_SETSENTENCEMODE            = $0007;
  IMN_SETOPENSTATUS              = $0008;
  IMN_SETCANDIDATEPOS            = $0009;
  IMN_SETCOMPOSITIONFONT         = $000A;
  IMN_SETCOMPOSITIONWINDOW       = $000B;
  IMN_SETSTATUSWINDOWPOS         = $000C;
  IMN_GUIDELINE                  = $000D;
  IMN_PRIVATE                    = $000E;

// error code of ImmGetCompositionString
  IMM_ERROR_NODATA               = -1;
  IMM_ERROR_GENERAL              = -2;

// dialog mode of ImmConfigureIME
  IME_CONFIG_GENERAL             = 1;
  IME_CONFIG_REGISTERWORD        = 2;
  IME_CONFIG_SELECTDICTIONARY    = 3;

// dialog mode of ImmEscape
  IME_ESC_QUERY_SUPPORT          = $0003;
  IME_ESC_RESERVED_FIRST         = $0004;
  IME_ESC_RESERVED_LAST          = $07FF;
  IME_ESC_PRIVATE_FIRST          = $0800;
  IME_ESC_PRIVATE_LAST           = $0FFF;
  IME_ESC_SEQUENCE_TO_INTERNAL   = $1001;
  IME_ESC_GET_EUDC_DICTIONARY    = $1003;
  IME_ESC_SET_EUDC_DICTIONARY    = $1004;
  IME_ESC_MAX_KEY                = $1005;
  IME_ESC_IME_NAME               = $1006;
  IME_ESC_SYNC_HOTKEY            = $1007;
  IME_ESC_HANJA_MODE             = $1008;
  IME_ESC_AUTOMATA               = $1009;

// style of word registration
  IME_REGWORD_STYLE_EUDC         = $00000001;
  IME_REGWORD_STYLE_USER_FIRST   = $80000000;
  IME_REGWORD_STYLE_USER_LAST    = $FFFFFFFF;

// type of soft keyboard
// for Windows Tranditional Chinese Edition
  SOFTKEYBOARD_TYPE_T1           = $0001;
// for Windows Simplified Chinese Edition
  SOFTKEYBOARD_TYPE_C1           = $0002;

type
  HIMC = Longint;

  PCompositionForm = ^TCompositionForm;
  TCompositionForm = record
    dwStyle: DWORD;
    ptCurrentPos: TPOINT;
    rcArea: TRECT;
  end;

  PCandidateForm = ^TCandidateForm;
  TCandidateForm = record
    dwIndex: DWORD;
    dwStyle: DWORD;
    ptCurrentPos: TPOINT;
    rcArea: TRECT;
  end;

  PCandidateList = ^TCandidateList;
  TCandidateList = record
    dwSize: DWORD;
    dwStyle: DWORD;
    dwCount: DWORD;
    dwSelection: DWORD;
    dwPageStart: DWORD;
    dwPageSize: DWORD;
    dwOffset: array[1..1] of DWORD;
  end;

  PRegisterWordA = ^TRegisterWordA;
  PRegisterWordW = ^TRegisterWordW;
  PRegisterWord = PRegisterWordA;
  TRegisterWordA = record
    lpReading: PAnsiChar;
    lpWord: PAnsiChar;
  end;
  TRegisterWordW = record
    lpReading: PWideChar;
    lpWord: PWideChar;
  end;
  TRegisterWord = TRegisterWordA;

  PStyleBufA = ^TStyleBufA;
  PStyleBufW = ^TStyleBufW;
  PStyleBuf = PStyleBufA;
  TStyleBufA = record
    dwStyle: DWORD;
    szDescription: array[0..STYLE_DESCRIPTION_SIZE-1] of AnsiChar;
  end;
  TStyleBufW = record
    dwStyle: DWORD;
    szDescription: array[0..STYLE_DESCRIPTION_SIZE-1] of WideChar;
  end;
  TStyleBuf = TStyleBufA;

  RegisterWordEnumProcA = function(lpReading: PAnsiChar; dwStyle: DWORD; lpszString: PAnsiChar; lpData: Pointer): Longint;
  RegisterWordEnumProcW = function(lpReading: PWideChar; dwStyle: DWORD; lpszString: PWideChar; lpData: Pointer): Longint;
  RegisterWordEnumProc  = RegisterWordEnumProcA;


function ImmInstallIMEA conv arg_stdcall (lpszIMEFileName, lpszLayoutText: PAnsiChar): HKL;
  external Imm32Dll name 'ImmInstallIMEA';

function ImmInstallIMEW conv arg_stdcall (lpszIMEFileName, lpszLayoutText: PWideChar): HKL; stdcall;
  external Imm32Dll name 'ImmInstallIMEW';

function ImmInstallIME conv arg_stdcall (lpszIMEFileName, lpszLayoutText: PChar): HKL;
  external Imm32Dll name 'ImmInstallIMEA';

function ImmGetDefaultIMEWnd conv arg_stdcall (hWnd: HWND): HWND;
  external Imm32Dll name 'ImmGetDefaultIMEWnd{%}';

function ImmGetDescriptionA conv arg_stdcall (hKl: HKL; PAnsiChar: PAnsiChar; uBufLen: UINT): UINT;
  external Imm32Dll name 'ImmGetDescriptionA';

function ImmGetDescriptionW conv arg_stdcall (hKl: HKL; PWideChar: PWideChar; uBufLen: UINT): UINT;
  external Imm32Dll name 'ImmGetDescriptionW';

function ImmGetDescription conv arg_stdcall (hKl: HKL; PChar: PChar; uBufLen: UINT): UINT;
  external Imm32Dll name 'ImmGetDescriptionA';

function ImmGetIMEFileNameA conv arg_stdcall (hKl: HKL; PAnsiChar: PAnsiChar; uBufLen: UINT): UINT;
  external Imm32Dll name 'ImmGetIMEFileNameA';

function ImmGetIMEFileNameW conv arg_stdcall (hKl: HKL; PWideChar: PWideChar; uBufLen: UINT): UINT;
  external Imm32Dll name 'ImmGetIMEFileNameW';

function ImmGetIMEFileName conv arg_stdcall (hKl: HKL; PChar: PChar; uBufLen: UINT): UINT;
  external Imm32Dll name 'ImmGetIMEFileNameA';

function ImmGetProperty conv arg_stdcall (hKl: HKL; dWord: DWORD): DWORD;
  external Imm32Dll name 'ImmGetProperty';

function ImmIsIME conv arg_stdcall (hKl: HKL): Boolean;
  external Imm32Dll name 'ImmIsIME';

function ImmSimulateHotKey conv arg_stdcall (hWnd: HWND; dWord: DWORD): Boolean;
 external Imm32Dll name 'ImmSimulateHotKey';

function ImmCreateContext: HIMC;
  external Imm32Dll name 'ImmCreateContext';

function ImmDestroyContext conv arg_stdcall (hImc: HIMC): Boolean;
  external Imm32Dll name 'ImmDestroyContext';

function ImmGetContext conv arg_stdcall (hWnd: HWND): HIMC; stdcall;
  external Imm32Dll name 'ImmGetContext';

function ImmReleaseContext conv arg_stdcall (hWnd: HWND; hImc: HIMC): Boolean;
  external Imm32Dll name 'ImmReleaseContext';

function ImmAssociateContext conv arg_stdcall (hWnd: HWND; hImc: HIMC): HIMC;
  external Imm32Dll name 'ImmAssociateContext';

function ImmGetCompositionStringA conv arg_stdcall (hImc: HIMC; dWord1: DWORD; lpBuf: Pointer; dwBufLen: DWORD): Longint;
  external Imm32Dll name 'ImmGetCompositionStringA';

function ImmGetCompositionStringW conv arg_stdcall (hImc: HIMC; dWord1: DWORD; lpBuf: Pointer; dwBufLen: DWORD): Longint;
  external Imm32Dll name 'ImmGetCompositionStringW';

function ImmGetCompositionString conv arg_stdcall (hImc: HIMC; dWord1: DWORD; lpBuf: Pointer; dwBufLen: DWORD): Longint;
  external Imm32Dll name 'ImmGetCompositionStringA';

function ImmSetCompositionStringA conv arg_stdcall (hImc: HIMC; dwIndex: DWORD; lpComp: Pointer; dwCompLen: DWORD; lpRead: Pointer; dwReadLen: DWORD):Boolean;
  external Imm32Dll name 'ImmSetCompositionStringA';

function ImmSetCompositionStringW conv arg_stdcall (hImc: HIMC; dwIndex: DWORD; lpComp: Pointer; dwCompLen: DWORD; lpRead: Pointer; dwReadLen: DWORD):Boolean;
  external Imm32Dll name 'ImmSetCompositionStringW';

function ImmSetCompositionString conv arg_stdcall (hImc: HIMC; dwIndex: DWORD; lpComp: Pointer; dwCompLen: DWORD; lpRead: Pointer; dwReadLen: DWORD):Boolean;
  external Imm32Dll name 'ImmSetCompositionStringA';

function ImmGetCandidateListCountA conv arg_stdcall (hImc: HIMC; var ListCount: DWORD): DWORD;
  external Imm32Dll name 'ImmGetCandidateListCountA';

function ImmGetCandidateListCountW conv arg_stdcall (hImc: HIMC; var ListCount: DWORD): DWORD;
  external Imm32Dll name 'ImmGetCandidateListCountW';

function ImmGetCandidateListCount conv arg_stdcall (hImc: HIMC; var ListCount: DWORD): DWORD;
  external Imm32Dll name 'ImmGetCandidateListCountA';

function ImmGetCandidateListA conv arg_stdcall (hImc: HIMC; deIndex: DWORD; lpCandidateList: PCANDIDATELIST; dwBufLen: DWORD): DWORD;
  external Imm32Dll name 'ImmGetCandidateListA';

function ImmGetCandidateListW conv arg_stdcall (hImc: HIMC; deIndex: DWORD; lpCandidateList: PCANDIDATELIST; dwBufLen: DWORD): DWORD;
  external Imm32Dll name 'ImmGetCandidateListW';

function ImmGetCandidateList conv arg_stdcall (hImc: HIMC; deIndex: DWORD; lpCandidateList: PCANDIDATELIST; dwBufLen: DWORD): DWORD;
  external Imm32Dll name 'ImmGetCandidateListA';

function ImmGetGuideLineA conv arg_stdcall (hImc: HIMC; dwIndex: DWORD; lpBuf: PAnsiChar; dwBufLen: DWORD): DWORD;
  external Imm32Dll name 'ImmGetGuideLineA';

function ImmGetGuideLineW conv arg_stdcall (hImc: HIMC; dwIndex: DWORD; lpBuf: PWideChar; dwBufLen: DWORD): DWORD;
  external Imm32Dll name 'ImmGetGuideLineW';

function ImmGetGuideLine conv arg_stdcall (hImc: HIMC; dwIndex: DWORD; lpBuf: PChar; dwBufLen: DWORD): DWORD;
  external Imm32Dll name 'ImmGetGuideLineA';

function ImmGetConversionStatus conv arg_stdcall (hImc: HIMC; var Conversion, Sentence: DWORD): Boolean;
  external Imm32Dll name 'ImmGetConversionStatus';

function ImmSetConversionStatus conv arg_stdcall (hImc: HIMC; Conversion, Sentence: DWORD): Boolean;
  external Imm32Dll name 'ImmSetConversionStatus';

function ImmGetOpenStatus conv arg_stdcall (hImc: HIMC): Boolean;
  external Imm32Dll name 'ImmGetOpenStatus';

function ImmSetOpenStatus conv arg_stdcall (hImc: HIMC; fOpen: Boolean): Boolean;
  external Imm32Dll name 'ImmSetOpenStatus';

function ImmGetCompositionFontA conv arg_stdcall (hImc: HIMC; lpLogfont: PLOGFONTA): Boolean;
  external Imm32Dll name 'ImmGetCompositionFontA';

function ImmGetCompositionFontW conv arg_stdcall (hImc: HIMC; lpLogfont: PLOGFONTW): Boolean;
  external Imm32Dll name 'ImmGetCompositionFontW';

function ImmGetCompositionFont conv arg_stdcall (hImc: HIMC; lpLogfont: PLOGFONT): Boolean;
  external Imm32Dll name 'ImmGetCompositionFontA';

function ImmSetCompositionFontA conv arg_stdcall (hImc: HIMC; lpLogfont: PLOGFONTA): Boolean;
  external Imm32Dll name 'ImmSetCompositionFontA';

function ImmSetCompositionFontW conv arg_stdcall (hImc: HIMC; lpLogfont: PLOGFONTW): Boolean;
  external Imm32Dll name 'ImmSetCompositionFontW';

function ImmSetCompositionFont conv arg_stdcall (hImc: HIMC; lpLogfont: PLOGFONT): Boolean;
  external Imm32Dll name 'ImmSetCompositionFontA';

function ImmConfigureIMEA conv arg_stdcall (hKl: HKL; hWnd: HWND; dwMode: DWORD; lpData: Pointer): Boolean;
  external Imm32Dll name 'ImmConfigureIMEA';

function ImmConfigureIMEW conv arg_stdcall (hKl: HKL; hWnd: HWND; dwMode: DWORD; lpData: Pointer): Boolean;
  external Imm32Dll name 'ImmConfigureIMEW';

function ImmConfigureIME conv arg_stdcall (hKl: HKL; hWnd: HWND; dwMode: DWORD; lpData: Pointer): Boolean;
  external Imm32Dll name 'ImmConfigureIMEA';

function ImmEscapeA conv arg_stdcall (hKl: HKL; hImc: HIMC; uEscape: UINT; lpData: Pointer): LRESULT;
  external Imm32Dll name 'ImmEscapeA';

function ImmEscapeW conv arg_stdcall (hKl: HKL; hImc: HIMC; uEscape: UINT; lpData: Pointer): LRESULT;
 external Imm32Dll name 'ImmEscapeW';

function ImmEscape conv arg_stdcall (hKl: HKL; hImc: HIMC; uEscape: UINT; lpData: Pointer): LRESULT;
 external Imm32Dll name 'ImmEscapeA';

function ImmGetConversionListA conv arg_stdcall (hKl: HKL; hImc: HIMC; lpSrc: PAnsiChar; lpDst: PCANDIDATELIST; dwBufLen: DWORD; uFlag: UINT ): DWORD;
  external Imm32Dll name 'ImmGetConversionListA';

function ImmGetConversionListW conv arg_stdcall (hKl: HKL; hImc: HIMC; lpSrc: PWideChar; lpDst: PCANDIDATELIST; dwBufLen: DWORD; uFlag: UINT ): DWORD;
  external Imm32Dll name 'ImmGetConversionListW';

function ImmGetConversionList conv arg_stdcall (hKl: HKL; hImc: HIMC; lpSrc: PChar; lpDst: PCANDIDATELIST; dwBufLen: DWORD; uFlag: UINT ): DWORD;
  external Imm32Dll name 'ImmGetConversionListA';

function ImmNotifyIME conv arg_stdcall (hImc: HIMC; dwAction, dwIndex, dwValue: DWORD): Boolean;
  external Imm32Dll name 'ImmNotifyIME';

function ImmGetStatusWindowPos conv arg_stdcall (hImc: HIMC; var lpPoint : TPoint): Boolean;
  external Imm32Dll name 'ImmGetStatusWindowPos';

function ImmSetStatusWindowPos conv arg_stdcall (hImc: HIMC; lpPoint: PPOINT): Boolean;
  external Imm32Dll name 'ImmSetStatusWindowPos';

function ImmGetCompositionWindow conv arg_stdcall (hImc: HIMC; lpCompForm: PCOMPOSITIONFORM): Boolean;
  external Imm32Dll name 'ImmGetCompositionWindow';

function ImmSetCompositionWindow conv arg_stdcall (hImc: HIMC; lpCompForm: PCOMPOSITIONFORM): Boolean;
  external Imm32Dll name 'ImmSetCompositionWindow';

function ImmGetCandidateWindow conv arg_stdcall (hImc: HIMC; dwBufLen: DWORD; lpCandidate: PCANDIDATEFORM): Boolean;
  external Imm32Dll name 'ImmGetCandidateWindow';

function ImmSetCandidateWindow conv arg_stdcall (hImc: HIMC; lpCandidate: PCANDIDATEFORM): Boolean;
  external Imm32Dll name 'ImmSetCandidateWindow';

function ImmIsUIMessageA conv arg_stdcall (hWnd: HWND; msg: UINT; wParam: WPARAM; lParam: LPARAM): Boolean;
  external Imm32Dll name 'ImmIsUIMessageA';

function ImmIsUIMessageW conv arg_stdcall (hWnd: HWND; msg: UINT; wParam: WPARAM; lParam: LPARAM): Boolean;
  external Imm32Dll name 'ImmIsUIMessageW';

function ImmIsUIMessage conv arg_stdcall (hWnd: HWND; msg: UINT; wParam: WPARAM; lParam: LPARAM): Boolean;
  external Imm32Dll name 'ImmIsUIMessageA';

function ImmGetVirtualKey conv arg_stdcall (hWnd: HWND ): UINT;
  external Imm32Dll name 'ImmGetVirtualKey';

function ImmRegisterWordA conv arg_stdcall (hKl: HKL; lpszReading: PAnsiChar; dwStyle: DWORD; lpszRegister: PAnsiChar): Boolean;
  external Imm32Dll name 'ImmRegisterWordA';

function ImmRegisterWordW conv arg_stdcall (hKl: HKL; lpszReading: PWideChar; dwStyle: DWORD; lpszRegister: PWideChar): Boolean;
  external Imm32Dll name 'ImmRegisterWordW';

function ImmRegisterWord conv arg_stdcall (hKl: HKL; lpszReading: PChar; dwStyle: DWORD; lpszRegister: PChar): Boolean;
  external Imm32Dll name 'ImmRegisterWordA';

function ImmUnregisterWordA conv arg_stdcall (hKl: HKL; lpszReading: PAnsiChar; dwStyle: DWORD; lpszUnregister: PAnsiChar): Boolean;
  external Imm32Dll name 'ImmUnregisterWordA';

function ImmUnregisterWordW conv arg_stdcall (hKl: HKL; lpszReading: PWideChar; dwStyle: DWORD; lpszUnregister: PWideChar): Boolean;
  external Imm32Dll name 'ImmUnregisterWordW';

function ImmUnregisterWord conv arg_stdcall (hKl: HKL; lpszReading: PChar; dwStyle: DWORD; lpszUnregister: PChar): Boolean;
  external Imm32Dll name 'ImmUnregisterWordA';

function ImmGetRegisterWordStyleA conv arg_stdcall (hKl: HKL; nItem: UINT; lpStyleBuf: PSTYLEBUFA): UINT;
  external Imm32Dll name 'ImmGetRegisterWordStyleA';

function ImmGetRegisterWordStyleW conv arg_stdcall (hKl: HKL; nItem: UINT; lpStyleBuf: PSTYLEBUFW): UINT;
  external Imm32Dll name 'ImmGetRegisterWordStyleW';

function ImmGetRegisterWordStyle conv arg_stdcall (hKl: HKL; nItem: UINT; lpStyleBuf: PSTYLEBUF): UINT;
  external Imm32Dll name 'ImmGetRegisterWordStyleA';

function ImmEnumRegisterWordA conv arg_stdcall (hKl: HKL; lpfnEnumProc: REGISTERWORDENUMPROCA; lpszReading: PAnsiChar; dwStyle: DWORD; lpszRegister: PAnsiChar; lpData: Pointer): UINT;
  external Imm32Dll name 'ImmEnumRegisterWordA';

function ImmEnumRegisterWordW conv arg_stdcall (hKl: HKL; lpfnEnumProc: REGISTERWORDENUMPROCW; lpszReading: PWideChar; dwStyle: DWORD; lpszRegister: PWideChar; lpData: Pointer): UINT;
  external Imm32Dll name 'ImmEnumRegisterWordW';

function ImmEnumRegisterWord conv arg_stdcall (hKl: HKL; lpfnEnumProc: REGISTERWORDENUMPROC; lpszReading: PChar; dwStyle: DWORD; lpszRegister: PChar; lpData: Pointer): UINT;
  external Imm32Dll name 'ImmEnumRegisterWordA';

implementation

end.