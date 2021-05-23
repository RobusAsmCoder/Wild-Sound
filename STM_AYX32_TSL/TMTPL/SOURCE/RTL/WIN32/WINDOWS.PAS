(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit API Interface Unit                       *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit Windows;

(*++

Abstract:

    Master include file for Windows applications.

--*)


interface

type
  WideChar         = WChar;
  PWideChar        = PWChar;

  AnsiChar         = Char;
  PAnsiChar        = PChar;
  Comp             = Double;
  LPSTR            = PAnsiChar;
  LPCSTR           = PAnsiChar;
  LPWSTR           = PWideChar;
  PWSTR            = LPWSTR;
  LPCWSTR          = PWideChar;
  UCHAR            = Byte;
  UINT             = DWORD;

  LPDWORD          = ^DWORD;
  PShortInt        = ^ShortInt;
  ULONG_PTR        = ^ULONG;
  PUINT            = ^DWORD;
  PUCHAR           = ^Byte;
  PINT             = ^Integer;
  PComp            = ^Double;
  LPTSTR           = PAnsiChar;
  PLPSTR           = ^LPSTR;
  PLPWSTR          = ^LPWSTR;
  LPCTSTR          = PAnsiChar;
  PVOID            = Pointer;
  PPVOID           = ^PVOID;
  PCharAW          = PAnsiChar;

  PUNICODE_STRING = ^UNICODE_STRING;
  _UNICODE_STRING = record
    Length: USHORT;
    MaximumLength: USHORT;
    Buffer: PWSTR;
  end;
  UNICODE_STRING = _UNICODE_STRING;
  PCUNICODE_STRING = ^UNICODE_STRING;
  TUnicodeString = UNICODE_STRING;
  PUnicodeString = PUNICODE_STRING;

type
  TSecurityImpersonationLevel = (SecurityAnonymous, SecurityIdentification, SecurityImpersonation, SecurityDelegation);

const
  UnrecognizedError = 'Unrecognized Error';
  UNICODE_NULL = WCHAR(0);

type
  WPARAM          = Longint;
  LPARAM          = Longint;
  LRESULT         = Longint;

  LOWORD          = Word;
  LOBYTE          = Byte;

  HWND            = DWORD;
  HHOOK           = DWORD;

  ATOM            = Word;
  TAtom           = Word;
/////////////////////////////////////////////////////////////////////////////
// The MAKEINTRESOURCE macro converts an Longint value to a resource type
// compatible with Win32 resource-management functions. This macro is used
// in place of a string containing the name of the resource.
/////////////////////////////////////////////////////////////////////////////
  MakeIntResourceA = PAnsiChar;
  MakeIntResourceW = PWideChar;
  MakeIntResource  = MakeIntResourceA;

/////////////////////////////////////////////////////////////////////////////
// The MAKEINTATOM macro creates an Longint atom that represents a character
// string of decimal digits.
/////////////////////////////////////////////////////////////////////////////
  MakeIntAtomA = PAnsiChar;
  MakeIntAtomW = PWideChar;
  MakeIntAtom  = MakeIntAtomA;

/////////////////////////////////////////////////////////////////////////////
// The LANGIDFROMLCID macro retrieves a language identifier from a locale
// identifier.
/////////////////////////////////////////////////////////////////////////////
  LANGIDFROMLCID = WORD;

/////////////////////////////////////////////////////////////////////////////
// The MAKELPARAM macro creates an unsigned 32-bit value for use as an lParam
// parameter in a message. The macro concatenates two given 16-bit values.
/////////////////////////////////////////////////////////////////////////////
function MAKELPARAM(wLow, wHigh: Word): LParam;

/////////////////////////////////////////////////////////////////////////////
// The MAKEWPARAM macro creates an unsigned 32-bit value for use as an wParam
// parameter in a message. The macro concatenates two given 16-bit values.
/////////////////////////////////////////////////////////////////////////////
function MAKEWPARAM(wLow, wHigh: Word): WParam;

/////////////////////////////////////////////////////////////////////////////
// The MAKELANGID function creates a language identifier from a primary
// language identifier and a sublanguage identifier
/////////////////////////////////////////////////////////////////////////////
function MAKELANGID (usPrimaryLanguage, usSubLanguage: Word): Word;

/////////////////////////////////////////////////////////////////////////////
// The MAKELCID function creates a locale identifier from a language
// identifier
/////////////////////////////////////////////////////////////////////////////
function MAKELCID (wLanguageID, wSortID: Word): DWord;

/////////////////////////////////////////////////////////////////////////////
// The PRIMARYLANGID function extracts a primary language identifier from
// a language identifier.
/////////////////////////////////////////////////////////////////////////////
function PRIMARYLANGID (lgid: Word): Word;

/////////////////////////////////////////////////////////////////////////////
// The SUBLANGID function extracts a sublanguage identifier from a language
// identifier
/////////////////////////////////////////////////////////////////////////////
function SUBLANGID (lgid: Word): Word;

function MAKELONG(A, B: Word): Longint;

const
 kernel32dll              = 'kernel32.dll';
 advapi32dll              = 'advapi32.dll';
 user32dll                = 'user32.dll';
 gdi32dll                 = 'gdi32.dll';
 mprdll                   = 'mpr.dll';
 versiondll               = 'version.dll';
 comctl32dll              = 'comctl32.dll';
 wintrustdll              = 'wintrust.dll';
 opengl32dll              = 'opengl32.dll';

////////////////////////////////// RawFile ///////////////////////////////////
 WIN_TRUST_SUBJTYPE_RAW_FILE: TGUID =
  (D1: $959DC450; D2: $8D9E; D3: $11CF; D4: ($87, $36, $00, $AA, $00, $A4, $85,
  $EB));

////////////////////////////////// PeImage ///////////////////////////////////
 WIN_TRUST_SUBJTYPE_PE_IMAGE: TGUID =
  (D1: $43C9A1E0; D2: $8DA0; D3: $11CF; D4: ($87, $36, $00, $AA, $00, $A4, $85,
  $EB));

////////////////////////////////// JavaClass /////////////////////////////////
 WIN_TRUST_SUBJTYPE_JAVA_CLASS: TGUID =
  (D1: $08AD3990; D2: $8DA1; D3: $11CF; D4: ($87, $36, $00, $AA, $00, $A4, $85,
  $EB));

/////////////////////////////////// Cabinet //////////////////////////////////
 WIN_TRUST_SUBJTYPE_CABINET: TGUID =
  (D1: $D17C5374; D2: $A392; D3: $11CF; D4: ($9D, $F5, $00, $AA, $00, $C1, $84,
  $E0));

////////////////////////////////// OleStorage ////////////////////////////////
 WIN_TRUST_SUBJTYPE_OLE_STORAGE: TGUID =
  (D1: $C257E740; D2: $8DA0; D3: $11CF; D4: ($87, $36, $00, $AA, $00, $A4, $85,
  $EB));

////////////////////////////// TrustedPublisher //////////////////////////////
 WIN_SPUB_ACTION_TRUSTED_PUBLISHER: TGUID =
  (D1: $66426730; D2: $8DA1; D3: $11CF; D4: ($87, $36, $00, $AA, $00, $A4, $85,
  $EB));

/////////////////////////////// NtActivateImage //////////////////////////////
 WIN_SPUB_ACTION_NT_ACTIVATE_IMAGE: TGUID =
  (D1: $8BC96B00; D2: $8DA1; D3: $11CF; D4: ($87, $36, $00, $AA, $00, $A4, $85,
  $EB));

////////////////////////////// PublishedSoftware /////////////////////////////
 WIN_SPUB_ACTION_PUBLISHED_SOFTWARE: TGUID =
  (D1: $64B9D180; D2: $8DA2; D3: $11CF; D4: ($87, $36, $00, $AA, $00, $A4, $85,
  $EB));

 LDTF_BASEHI              = $000000FF;
 LDTF_GRANULARITY         = $00000100;
 LDTF_DEFAULT_BIG         = $00000200;
 LDTF_RESERVED_0          = $00000400;
 LDTF_SYS                 = $00000800;
 LDTF_LIMITHI             = $0000F000;
 LDTF_PRES                = $00010000;
 LDTF_DPL                 = $00060000;
 LDTF_TYPE_8              = $00F80000;
 LDTF_BASEMID             = $FF000000;

(***
*limits.h - implementation dependent values
*
*       Copyright (c) 1985-1997, Microsoft Corporation.  All rights reserved.
*
*Purpose:
*       Contains defines for a number of implementation dependent values
*       which are commonly used in C programs.
*       [ANSI]
*
*       [Public]
*
****)

 CHAR_BIT   =   8;         // number of bits in a char
 SCHAR_MIN  =  -128;       // minimum signed char value
 SCHAR_MAX  =   127;       // maximum signed char value
 UCHAR_MAX  =   $FF;       // maximum unsigned char value

 CHAR_MIN   =   0;
 CHAR_MAX   = UCHAR_MAX;

 MB_LEN_MAX =   2;              // max. # bytes in multibyte char
 SHRT_MIN   =  -32768;          // minimum (signed) short value
 SHRT_MAX   =   32767;          // maximum (signed) short value
 USHRT_MAX  =   $FFFF;          // maximum unsigned short value
 INT_MIN    =  -2147483647 - 1; // minimum (signed) int value
 INT_MAX    =   2147483647;     // maximum (signed) int value
 UINT_MAX   =   $FFFFFFFF;      // maximum unsigned int value
 LONG_MIN   =  -2147483647 - 1; // minimum (signed) long value
 LONG_MAX   =   2147483647;     // maximum (signed) long value
 ULONG_MAX  =   $FFFFFFFF;      // maximum unsigned long value

 _I8_MIN    =  -127 - 1;        // minimum signed 8 bit value
 _I8_MAX    =   127;            // maximum signed 8 bit value
 _UI8_MAX   =   $FF;            // maximum unsigned 8 bit value

 _I16_MIN   = -32767 - 1;       // minimum signed 16 bit value
 _I16_MAX   =  32767;           // maximum signed 16 bit value
 _UI16_MAX  =  $FFFF;           // maximum unsigned 16 bit value

 _I32_MIN   =  -2147483647 - 1; // minimum signed 32 bit value
 _I32_MAX   =   2147483647;     // maximum signed 32 bit value
 _UI32_MAX  =   $FFFFFFFF;      // maximum unsigned 32 bit value

 _POSIX_ARG_MAX     = 4096;
 _POSIX_CHILD_MAX   = 6;
 _POSIX_LINK_MAX    = 8;
 _POSIX_MAX_CANON   = 255;
 _POSIX_MAX_INPUT   = 255;
 _POSIX_NAME_MAX    = 14;
 _POSIX_NGROUPS_MAX = 0;
 _POSIX_OPEN_MAX    = 16;
 _POSIX_PATH_MAX    = 255;
 _POSIX_PIPE_BUF    = 512;
 _POSIX_SSIZE_MAX   = 32767;
 _POSIX_STREAM_MAX  = 8;
 _POSIX_TZNAME_MAX  = 3;

 ARG_MAX            = 14500;    (* 16k heap, minus overhead *)
 LINK_MAX           = 1024;
 MAX_CANON          = _POSIX_MAX_CANON;
 MAX_INPUT          = _POSIX_MAX_INPUT;
 NAME_MAX           = 255;
 NGROUPS_MAX        = 16;
 OPEN_MAX           = 32;
 PATH_MAX           = 512;
 PIPE_BUF           = _POSIX_PIPE_BUF;
 SSIZE_MAX          = _POSIX_SSIZE_MAX;
 STREAM_MAX         = 20;
 TZNAME_MAX         = 10;

(****************************************************************************
*  Definitions for the Virtual Power Management Device.
*****************************************************************************
*  CHANGE LOG:
*  DATE        REV DESCRIPTION
*  ----------- --- -----------------------------------------------------------
*  15 Jan 1994 TCS Original implementation.
*****************************************************************************)

const
  WM_POWERBROADCAST             = $0218;
  PBT_APMQUERYSUSPEND           = $0000;
  PBT_APMQUERYSTANDBY           = $0001;
  PBT_APMQUERYSUSPENDFAILED     = $0002;
  PBT_APMQUERYSTANDBYFAILED     = $0003;
  PBT_APMSUSPEND                = $0004;
  PBT_APMSTANDBY                = $0005;
  PBT_APMRESUMECRITICAL         = $0006;
  PBT_APMRESUMESUSPEND          = $0007;
  PBT_APMRESUMESTANDBY          = $0008;
  PBTF_APMRESUMEFROMFAILURE     = $00000001;
  PBT_APMBATTERYLOW             = $0009;
  PBT_APMPOWERSTATUSCHANGE      = $000A;
  PBT_APMOEMEVENT               = $000B;
  PBT_APMRESUMEAUTOMATIC        = $0012;

/////////////////////////////////////////////////////////////////////////////
// Win32 Error codes
/////////////////////////////////////////////////////////////////////////////
 ERROR_SUCCESS                            = 0;
 NO_ERROR                                 = 0;
 ERROR_INVALID_FUNCTION                   = 1;
 ERROR_FILE_NOT_FOUND                     = 2;
 ERROR_PATH_NOT_FOUND                     = 3;
 ERROR_TOO_MANY_OPEN_FILES                = 4;
 ERROR_ACCESS_DENIED                      = 5;
 ERROR_INVALID_HANDLE                     = 6;
 ERROR_ARENA_TRASHED                      = 7;
 ERROR_NOT_ENOUGH_MEMORY                  = 8;
 ERROR_INVALID_BLOCK                      = 9;
 ERROR_BAD_ENVIRONMENT                    = 10;
 ERROR_BAD_FORMAT                         = 11;
 ERROR_INVALID_ACCESS                     = 12;
 ERROR_INVALID_DATA                       = 13;
 ERROR_OUTOFMEMORY                        = 14;
 ERROR_INVALID_DRIVE                      = 15;
 ERROR_CURRENT_DIRECTORY                  = 16;
 ERROR_NOT_SAME_DEVICE                    = 17;
 ERROR_NO_MORE_FILES                      = 18;
 ERROR_WRITE_PROTECT                      = 19;
 ERROR_BAD_UNIT                           = 20;
 ERROR_NOT_READY                          = 21;
 ERROR_BAD_COMMAND                        = 22;
 ERROR_CRC                                = 23;
 ERROR_BAD_LENGTH                         = 24;
 ERROR_SEEK                               = 25;
 ERROR_NOT_DOS_DISK                       = 26;
 ERROR_SECTOR_NOT_FOUND                   = 27;
 ERROR_OUT_OF_PAPER                       = 28;
 ERROR_WRITE_FAULT                        = 29;
 ERROR_READ_FAULT                         = 30;
 ERROR_GEN_FAILURE                        = 31;
 ERROR_SHARING_VIOLATION                  = 32;
 ERROR_LOCK_VIOLATION                     = 33;
 ERROR_WRONG_DISK                         = 34;
 ERROR_SHARING_BUFFER_EXCEEDED            = 36;
 ERROR_HANDLE_EOF                         = 38;
 ERROR_HANDLE_DISK_FULL                   = 39;
 ERROR_NOT_SUPPORTED                      = 50;
 ERROR_REM_NOT_LIST                       = 51;
 ERROR_DUP_NAME                           = 52;
 ERROR_BAD_NETPATH                        = 53;
 ERROR_NETWORK_BUSY                       = 54;
 ERROR_DEV_NOT_EXIST                      = 55;
 ERROR_TOO_MANY_CMDS                      = 56;
 ERROR_ADAP_HDW_ERR                       = 57;
 ERROR_BAD_NET_RESP                       = 58;
 ERROR_UNEXP_NET_ERR                      = 59;
 ERROR_BAD_REM_ADAP                       = 60;
 ERROR_PRINTQ_FULL                        = 61;
 ERROR_NO_SPOOL_SPACE                     = 62;
 ERROR_PRINT_CANCELLED                    = 63;
 ERROR_NETNAME_DELETED                    = 64;
 ERROR_NETWORK_ACCESS_DENIED              = 65;
 ERROR_BAD_DEV_TYPE                       = 66;
 ERROR_BAD_NET_NAME                       = 67;
 ERROR_TOO_MANY_NAMES                     = 68;
 ERROR_TOO_MANY_SESS                      = 69;
 ERROR_SHARING_PAUSED                     = 70;
 ERROR_REQ_NOT_ACCEP                      = 71;
 ERROR_REDIR_PAUSED                       = 72;
 ERROR_FILE_EXISTS                        = 80;
 ERROR_CANNOT_MAKE                        = 82;
 ERROR_FAIL_I24                           = 83;
 ERROR_OUT_OF_STRUCTURES                  = 84;
 ERROR_ALREADY_ASSIGNED                   = 85;
 ERROR_INVALID_PASSWORD                   = 86;
 ERROR_INVALID_PARAMETER                  = 87;
 ERROR_NET_WRITE_FAULT                    = 88;
 ERROR_NO_PROC_SLOTS                      = 89;
 ERROR_TOO_MANY_SEMAPHORES                = 100;
 ERROR_EXCL_SEM_ALREADY_OWNED             = 101;
 ERROR_SEM_IS_SET                         = 102;
 ERROR_TOO_MANY_SEM_REQUESTS              = 103;
 ERROR_INVALID_AT_INTERRUPT_TIME          = 104;
 ERROR_SEM_OWNER_DIED                     = 105;
 ERROR_SEM_USER_LIMIT                     = 106;
 ERROR_DISK_CHANGE                        = 107;
 ERROR_DRIVE_LOCKED                       = 108;
 ERROR_BROKEN_PIPE                        = 109;
 ERROR_OPEN_FAILED                        = 110;
 ERROR_BUFFER_OVERFLOW                    = 111;
 ERROR_DISK_FULL                          = 112;
 ERROR_NO_MORE_SEARCH_HANDLES             = 113;
 ERROR_INVALID_TARGET_HANDLE              = 114;
 ERROR_INVALID_CATEGORY                   = 117;
 ERROR_INVALID_VERIFY_SWITCH              = 118;
 ERROR_BAD_DRIVER_LEVEL                   = 119;
 ERROR_CALL_NOT_IMPLEMENTED               = 120;
 ERROR_SEM_TIMEOUT                        = 121;
 ERROR_INSUFFICIENT_BUFFER                = 122;
 ERROR_INVALID_NAME                       = 123;
 ERROR_INVALID_LEVEL                      = 124;
 ERROR_NO_VOLUME_LABEL                    = 125;
 ERROR_MOD_NOT_FOUND                      = 126;
 ERROR_PROC_NOT_FOUND                     = 127;
 ERROR_WAIT_NO_CHILDREN                   = 128;
 ERROR_CHILD_NOT_COMPLETE                 = 129;
 ERROR_DIRECT_ACCESS_HANDLE               = 130;
 ERROR_NEGATIVE_SEEK                      = 131;
 ERROR_SEEK_ON_DEVICE                     = 132;
 ERROR_IS_JOIN_TARGET                     = 133;
 ERROR_IS_JOINED                          = 134;
 ERROR_IS_SUBSTED                         = 135;
 ERROR_NOT_JOINED                         = 136;
 ERROR_NOT_SUBSTED                        = 137;
 ERROR_JOIN_TO_JOIN                       = 138;
 ERROR_SUBST_TO_SUBST                     = 139;
 ERROR_JOIN_TO_SUBST                      = 140;
 ERROR_SUBST_TO_JOIN                      = 141;
 ERROR_BUSY_DRIVE                         = 142;
 ERROR_SAME_DRIVE                         = 143;
 ERROR_DIR_NOT_ROOT                       = 144;
 ERROR_DIR_NOT_EMPTY                      = 145;
 ERROR_IS_SUBST_PATH                      = 146;
 ERROR_IS_JOIN_PATH                       = 147;
 ERROR_PATH_BUSY                          = 148;
 ERROR_IS_SUBST_TARGET                    = 149;
 ERROR_SYSTEM_TRACE                       = 150;
 ERROR_INVALID_EVENT_COUNT                = 151;
 ERROR_TOO_MANY_MUXWAITERS                = 152;
 ERROR_INVALID_LIST_FORMAT                = 153;
 ERROR_LABEL_TOO_LONG                     = 154;
 ERROR_TOO_MANY_TCBS                      = 155;
 ERROR_SIGNAL_REFUSED                     = 156;
 ERROR_DISCARDED                          = 157;
 ERROR_NOT_LOCKED                         = 158;
 ERROR_BAD_THREADID_ADDR                  = 159;
 ERROR_BAD_ARGUMENTS                      = 160;
 ERROR_BAD_PATHNAME                       = 161;
 ERROR_SIGNAL_PENDING                     = 162;
 ERROR_MAX_THRDS_REACHED                  = 164;
 ERROR_LOCK_FAILED                        = 167;
 ERROR_BUSY                               = 170;
 ERROR_CANCEL_VIOLATION                   = 173;
 ERROR_ATOMIC_LOCKS_NOT_SUPPORTED         = 174;
 ERROR_INVALID_SEGMENT_NUMBER             = 180;
 ERROR_INVALID_ORDINAL                    = 182;
 ERROR_ALREADY_EXISTS                     = 183;
 ERROR_INVALID_FLAG_NUMBER                = 186;
 ERROR_SEM_NOT_FOUND                      = 187;
 ERROR_INVALID_STARTING_CODESEG           = 188;
 ERROR_INVALID_STACKSEG                   = 189;
 ERROR_INVALID_MODULETYPE                 = 190;
 ERROR_INVALID_EXE_SIGNATURE              = 191;
 ERROR_EXE_MARKED_INVALID                 = 192;
 ERROR_BAD_EXE_FORMAT                     = 193;
 ERROR_ITERATED_DATA_EXCEEDS_64K          = 194;
 ERROR_INVALID_MINALLOCSIZE               = 195;
 ERROR_DYNLINK_FROM_INVALID_RING          = 196;
 ERROR_IOPL_NOT_ENABLED                   = 197;
 ERROR_INVALID_SEGDPL                     = 198;
 ERROR_AUTODATASEG_EXCEEDS_64K            = 199;
 ERROR_RING2SEG_MUST_BE_MOVABLE           = 200;
 ERROR_RELOC_CHAIN_XEEDS_SEGLIM           = 201;
 ERROR_INFLOOP_IN_RELOC_CHAIN             = 202;
 ERROR_ENVVAR_NOT_FOUND                   = 203;
 ERROR_NO_SIGNAL_SENT                     = 205;
 ERROR_FILENAME_EXCED_RANGE               = 206;
 ERROR_RING2_STACK_IN_USE                 = 207;
 ERROR_META_EXPANSION_TOO_LONG            = 208;
 ERROR_INVALID_SIGNAL_NUMBER              = 209;
 ERROR_THREAD_1_INACTIVE                  = 210;
 ERROR_LOCKED                             = 212;
 ERROR_TOO_MANY_MODULES                   = 214;
 ERROR_NESTING_NOT_ALLOWED                = 215;
 ERROR_EXE_MACHINE_TYPE_MISMATCH          = 216;
 ERROR_BAD_PIPE                           = 230;
 ERROR_PIPE_BUSY                          = 231;
 ERROR_NO_DATA                            = 232;
 ERROR_PIPE_NOT_CONNECTED                 = 233;
 ERROR_MORE_DATA                          = 234;
 ERROR_VC_DISCONNECTED                    = 240;
 ERROR_INVALID_EA_NAME                    = 254;
 ERROR_EA_LIST_INCONSISTENT               = 255;
 ERROR_NO_MORE_ITEMS                      = 259;
 ERROR_CANNOT_COPY                        = 266;
 ERROR_DIRECTORY                          = 267;
 ERROR_EAS_DIDNT_FIT                      = 275;
 ERROR_EA_FILE_CORRUPT                    = 276;
 ERROR_EA_TABLE_FULL                      = 277;
 ERROR_INVALID_EA_HANDLE                  = 278;
 ERROR_EAS_NOT_SUPPORTED                  = 282;
 ERROR_NOT_OWNER                          = 288;
 ERROR_TOO_MANY_POSTS                     = 298;
 ERROR_PARTIAL_COPY                       = 299;
 ERROR_MR_MID_NOT_FOUND                   = 317;
 ERROR_INVALID_ADDRESS                    = 487;
 ERROR_ARITHMETIC_OVERFLOW                = 534;
 ERROR_PIPE_CONNECTED                     = 535;
 ERROR_PIPE_LISTENING                     = 536;
 ERROR_EA_ACCESS_DENIED                   = 994;
 ERROR_OPERATION_ABORTED                  = 995;
 ERROR_IO_INCOMPLETE                      = 996;
 ERROR_IO_PENDING                         = 997;
 ERROR_NOACCESS                           = 998;
 ERROR_SWAPERROR                          = 999;
 ERROR_STACK_OVERFLOW                     = 1001;
 ERROR_INVALID_MESSAGE                    = 1002;
 ERROR_CAN_NOT_COMPLETE                   = 1003;
 ERROR_INVALID_FLAGS                      = 1004;
 ERROR_UNRECOGNIZED_VOLUME                = 1005;
 ERROR_FILE_INVALID                       = 1006;
 ERROR_FULLSCREEN_MODE                    = 1007;
 ERROR_NO_TOKEN                           = 1008;
 ERROR_BADDB                              = 1009;
 ERROR_BADKEY                             = 1010;
 ERROR_CANTOPEN                           = 1011;
 ERROR_CANTREAD                           = 1012;
 ERROR_CANTWRITE                          = 1013;
 ERROR_REGISTRY_RECOVERED                 = 1014;
 ERROR_REGISTRY_CORRUPT                   = 1015;
 ERROR_REGISTRY_IO_FAILED                 = 1016;
 ERROR_NOT_REGISTRY_FILE                  = 1017;
 ERROR_KEY_DELETED                        = 1018;
 ERROR_NO_LOG_SPACE                       = 1019;
 ERROR_KEY_HAS_CHILDREN                   = 1020;
 ERROR_CHILD_MUST_BE_VOLATILE             = 1021;
 ERROR_NOTIFY_ENUM_DIR                    = 1022;
 ERROR_DEPENDENT_SERVICES_RUNNING         = 1051;
 ERROR_INVALID_SERVICE_CONTROL            = 1052;
 ERROR_SERVICE_REQUEST_TIMEOUT            = 1053;
 ERROR_SERVICE_NO_THREAD                  = 1054;
 ERROR_SERVICE_DATABASE_LOCKED            = 1055;
 ERROR_SERVICE_ALREADY_RUNNING            = 1056;
 ERROR_INVALID_SERVICE_ACCOUNT            = 1057;
 ERROR_SERVICE_DISABLED                   = 1058;
 ERROR_CIRCULAR_DEPENDENCY                = 1059;
 ERROR_SERVICE_DOES_NOT_EXIST             = 1060;
 ERROR_SERVICE_CANNOT_ACCEPT_CTRL         = 1061;
 ERROR_SERVICE_NOT_ACTIVE                 = 1062;
 ERROR_FAILED_SERVICE_CONTROLLER          = 1063;
 ERROR_EXCEPTION_IN_SERVICE               = 1064;
 ERROR_DATABASE_DOES_NOT_EXIST            = 1065;
 ERROR_SERVICE_SPECIFIC_ERROR             = 1066;
 ERROR_PROCESS_ABORTED                    = 1067;
 ERROR_SERVICE_DEPENDENCY_FAIL            = 1068;
 ERROR_SERVICE_LOGON_FAILED               = 1069;
 ERROR_SERVICE_START_HANG                 = 1070;
 ERROR_INVALID_SERVICE_LOCK               = 1071;
 ERROR_SERVICE_MARKED_FOR_DELETE          = 1072;
 ERROR_SERVICE_EXISTS                     = 1073;
 ERROR_ALREADY_RUNNING_LKG                = 1074;
 ERROR_SERVICE_DEPENDENCY_DELETED         = 1075;
 ERROR_BOOT_ALREADY_ACCEPTED              = 1076;
 ERROR_SERVICE_NEVER_STARTED              = 1077;
 ERROR_DUPLICATE_SERVICE_NAME             = 1078;
 ERROR_DIFFERENT_SERVICE_ACCOUNT          = 1079;
 ERROR_END_OF_MEDIA                       = 1100;
 ERROR_FILEMARK_DETECTED                  = 1101;
 ERROR_BEGINNING_OF_MEDIA                 = 1102;
 ERROR_SETMARK_DETECTED                   = 1103;
 ERROR_NO_DATA_DETECTED                   = 1104;
 ERROR_PARTITION_FAILURE                  = 1105;
 ERROR_INVALID_BLOCK_LENGTH               = 1106;
 ERROR_DEVICE_NOT_PARTITIONED             = 1107;
 ERROR_UNABLE_TO_LOCK_MEDIA               = 1108;
 ERROR_UNABLE_TO_UNLOAD_MEDIA             = 1109;
 ERROR_MEDIA_CHANGED                      = 1110;
 ERROR_BUS_RESET                          = 1111;
 ERROR_NO_MEDIA_IN_DRIVE                  = 1112;
 ERROR_NO_UNICODE_TRANSLATION             = 1113;
 ERROR_DLL_INIT_FAILED                    = 1114;
 ERROR_SHUTDOWN_IN_PROGRESS               = 1115;
 ERROR_NO_SHUTDOWN_IN_PROGRESS            = 1116;
 ERROR_IO_DEVICE                          = 1117;
 ERROR_SERIAL_NO_DEVICE                   = 1118;
 ERROR_IRQ_BUSY                           = 1119;
 ERROR_MORE_WRITES                        = 1120;
 ERROR_COUNTER_TIMEOUT                    = 1121;
 ERROR_FLOPPY_ID_MARK_NOT_FOUND           = 1122;
 ERROR_FLOPPY_WRONG_CYLINDER              = 1123;
 ERROR_FLOPPY_UNKNOWN_ERROR               = 1124;
 ERROR_FLOPPY_BAD_REGISTERS               = 1125;
 ERROR_DISK_RECALIBRATE_FAILED            = 1126;
 ERROR_DISK_OPERATION_FAILED              = 1127;
 ERROR_DISK_RESET_FAILED                  = 1128;
 ERROR_EOM_OVERFLOW                       = 1129;
 ERROR_NOT_ENOUGH_SERVER_MEMORY           = 1130;
 ERROR_POSSIBLE_DEADLOCK                  = 1131;
 ERROR_MAPPED_ALIGNMENT                   = 1132;
 ERROR_SET_POWER_STATE_VETOED             = 1140;
 ERROR_SET_POWER_STATE_FAILED             = 1141;
 ERROR_TOO_MANY_LINKS                     = 1142;
 ERROR_OLD_WIN_VERSION                    = 1150;
 ERROR_APP_WRONG_OS                       = 1151;
 ERROR_SINGLE_INSTANCE_APP                = 1152;
 ERROR_RMODE_APP                          = 1153;
 ERROR_INVALID_DLL                        = 1154;
 ERROR_NO_ASSOCIATION                     = 1155;
 ERROR_DDE_FAIL                           = 1156;
 ERROR_DLL_NOT_FOUND                      = 1157;
 ERROR_BAD_USERNAME                       = 2202;
 ERROR_NOT_CONNECTED                      = 2250;
 ERROR_OPEN_FILES                         = 2401;
 ERROR_ACTIVE_CONNECTIONS                 = 2402;
 ERROR_DEVICE_IN_USE                      = 2404;
 ERROR_BAD_DEVICE                         = 1200;
 ERROR_CONNECTION_UNAVAIL                 = 1201;
 ERROR_DEVICE_ALREADY_REMEMBERED          = 1202;
 ERROR_NO_NET_OR_BAD_PATH                 = 1203;
 ERROR_BAD_PROVIDER                       = 1204;
 ERROR_CANNOT_OPEN_PROFILE                = 1205;
 ERROR_BAD_PROFILE                        = 1206;
 ERROR_NOT_CONTAINER                      = 1207;
 ERROR_EXTENDED_ERROR                     = 1208;
 ERROR_INVALID_GROUPNAME                  = 1209;
 ERROR_INVALID_COMPUTERNAME               = 1210;
 ERROR_INVALID_EVENTNAME                  = 1211;
 ERROR_INVALID_DOMAINNAME                 = 1212;
 ERROR_INVALID_SERVICENAME                = 1213;
 ERROR_INVALID_NETNAME                    = 1214;
 ERROR_INVALID_SHARENAME                  = 1215;
 ERROR_INVALID_PASSWORDNAME               = 1216;
 ERROR_INVALID_MESSAGENAME                = 1217;
 ERROR_INVALID_MESSAGEDEST                = 1218;
 ERROR_SESSION_CREDENTIAL_CONFLIC         = 1219;
 ERROR_REMOTE_SESSION_LIMIT_EXCEE         = 1220;
 ERROR_DUP_DOMAINNAME                     = 1221;
 ERROR_NO_NETWORK                         = 1222;
 ERROR_CANCELLED                          = 1223;
 ERROR_USER_MAPPED_FILE                   = 1224;
 ERROR_CONNECTION_REFUSED                 = 1225;
 ERROR_GRACEFUL_DISCONNECT                = 1226;
 ERROR_ADDRESS_ALREADY_ASSOCIATED         = 1227;
 ERROR_ADDRESS_NOT_ASSOCIATED             = 1228;
 ERROR_CONNECTION_INVALID                 = 1229;
 ERROR_CONNECTION_ACTIVE                  = 1230;
 ERROR_NETWORK_UNREACHABLE                = 1231;
 ERROR_HOST_UNREACHABLE                   = 1232;
 ERROR_PROTOCOL_UNREACHABLE               = 1233;
 ERROR_PORT_UNREACHABLE                   = 1234;
 ERROR_REQUEST_ABORTED                    = 1235;
 ERROR_CONNECTION_ABORTED                 = 1236;
 ERROR_RETRY                              = 1237;
 ERROR_CONNECTION_COUNT_LIMIT             = 1238;
 ERROR_LOGIN_TIME_RESTRICTION             = 1239;
 ERROR_LOGIN_WKSTA_RESTRICTION            = 1240;
 ERROR_INCORRECT_ADDRESS                  = 1241;
 ERROR_ALREADY_REGISTERED                 = 1242;
 ERROR_SERVICE_NOT_FOUND                  = 1243;
 ERROR_NOT_AUTHENTICATED                  = 1244;
 ERROR_NOT_LOGGED_ON                      = 1245;
 ERROR_CONTINUE                           = 1246;
 ERROR_ALREADY_INITIALIZED                = 1247;
 ERROR_NO_MORE_DEVICES                    = 1248;
 ERROR_NOT_ALL_ASSIGNED                   = 1300;
 ERROR_SOME_NOT_MAPPED                    = 1301;
 ERROR_NO_QUOTAS_FOR_ACCOUNT              = 1302;
 ERROR_LOCAL_USER_SESSION_KEY             = 1303;
 ERROR_NULL_LM_PASSWORD                   = 1304;
 ERROR_UNKNOWN_REVISION                   = 1305;
 ERROR_REVISION_MISMATCH                  = 1306;
 ERROR_INVALID_OWNER                      = 1307;
 ERROR_INVALID_PRIMARY_GROUP              = 1308;
 ERROR_NO_IMPERSONATION_TOKEN             = 1309;
 ERROR_CANT_DISABLE_MANDATORY             = 1310;
 ERROR_NO_LOGON_SERVERS                   = 1311;
 ERROR_NO_SUCH_LOGON_SESSION              = 1312;
 ERROR_NO_SUCH_PRIVILEGE                  = 1313;
 ERROR_PRIVILEGE_NOT_HELD                 = 1314;
 ERROR_INVALID_ACCOUNT_NAME               = 1315;
 ERROR_USER_EXISTS                        = 1316;
 ERROR_NO_SUCH_USER                       = 1317;
 ERROR_GROUP_EXISTS                       = 1318;
 ERROR_NO_SUCH_GROUP                      = 1319;
 ERROR_MEMBER_IN_GROUP                    = 1320;
 ERROR_MEMBER_NOT_IN_GROUP                = 1321;
 ERROR_LAST_ADMIN                         = 1322;
 ERROR_WRONG_PASSWORD                     = 1323;
 ERROR_ILL_FORMED_PASSWORD                = 1324;
 ERROR_PASSWORD_RESTRICTION               = 1325;
 ERROR_LOGON_FAILURE                      = 1326;
 ERROR_ACCOUNT_RESTRICTION                = 1327;
 ERROR_INVALID_LOGON_HOURS                = 1328;
 ERROR_INVALID_WORKSTATION                = 1329;
 ERROR_PASSWORD_EXPIRED                   = 1330;
 ERROR_ACCOUNT_DISABLED                   = 1331;
 ERROR_NONE_MAPPED                        = 1332;
 ERROR_TOO_MANY_LUIDS_REQUESTED           = 1333;
 ERROR_LUIDS_EXHAUSTED                    = 1334;
 ERROR_INVALID_SUB_AUTHORITY              = 1335;
 ERROR_INVALID_ACL                        = 1336;
 ERROR_INVALID_SID                        = 1337;
 ERROR_INVALID_SECURITY_DESCR             = 1338;
 ERROR_BAD_INHERITANCE_ACL                = 1340;
 ERROR_SERVER_DISABLED                    = 1341;
 ERROR_SERVER_NOT_DISABLED                = 1342;
 ERROR_INVALID_ID_AUTHORITY               = 1343;
 ERROR_ALLOTTED_SPACE_EXCEEDED            = 1344;
 ERROR_INVALID_GROUP_ATTRIBUTES           = 1345;
 ERROR_BAD_IMPERSONATION_LEVEL            = 1346;
 ERROR_CANT_OPEN_ANONYMOUS                = 1347;
 ERROR_BAD_VALIDATION_CLASS               = 1348;
 ERROR_BAD_TOKEN_TYPE                     = 1349;
 ERROR_NO_SECURITY_ON_OBJECT              = 1350;
 ERROR_CANT_ACCESS_DOMAIN_INFO            = 1351;
 ERROR_INVALID_SERVER_STATE               = 1352;
 ERROR_INVALID_DOMAIN_STATE               = 1353;
 ERROR_INVALID_DOMAIN_ROLE                = 1354;
 ERROR_NO_SUCH_DOMAIN                     = 1355;
 ERROR_DOMAIN_EXISTS                      = 1356;
 ERROR_DOMAIN_LIMIT_EXCEEDED              = 1357;
 ERROR_INTERNAL_DB_CORRUPTION             = 1358;
 ERROR_INTERNAL_ERROR                     = 1359;
 ERROR_GENERIC_NOT_MAPPED                 = 1360;
 ERROR_BAD_DESCRIPTOR_FORMAT              = 1361;
 ERROR_NOT_LOGON_PROCESS                  = 1362;
 ERROR_LOGON_SESSION_EXISTS               = 1363;
 ERROR_NO_SUCH_PACKAGE                    = 1364;
 ERROR_BAD_LOGON_SESSION_STATE            = 1365;
 ERROR_LOGON_SESSION_COLLISION            = 1366;
 ERROR_INVALID_LOGON_TYPE                 = 1367;
 ERROR_CANNOT_IMPERSONATE                 = 1368;
 ERROR_RXACT_INVALID_STATE                = 1369;
 ERROR_RXACT_COMMIT_FAILURE               = 1370;
 ERROR_SPECIAL_ACCOUNT                    = 1371;
 ERROR_SPECIAL_GROUP                      = 1372;
 ERROR_SPECIAL_USER                       = 1373;
 ERROR_MEMBERS_PRIMARY_GROUP              = 1374;
 ERROR_TOKEN_ALREADY_IN_USE               = 1375;
 ERROR_NO_SUCH_ALIAS                      = 1376;
 ERROR_MEMBER_NOT_IN_ALIAS                = 1377;
 ERROR_MEMBER_IN_ALIAS                    = 1378;
 ERROR_ALIAS_EXISTS                       = 1379;
 ERROR_LOGON_NOT_GRANTED                  = 1380;
 ERROR_TOO_MANY_SECRETS                   = 1381;
 ERROR_SECRET_TOO_LONG                    = 1382;
 ERROR_INTERNAL_DB_ERROR                  = 1383;
 ERROR_TOO_MANY_CONTEXT_IDS               = 1384;
 ERROR_LOGON_TYPE_NOT_GRANTED             = 1385;
 ERROR_NT_CROSS_ENCRYPTION_REQUIR         = 1386;
 ERROR_NO_SUCH_MEMBER                     = 1387;
 ERROR_INVALID_MEMBER                     = 1388;
 ERROR_TOO_MANY_SIDS                      = 1389;
 ERROR_LM_CROSS_ENCRYPTION_REQUIR         = 1390;
 ERROR_NO_INHERITANCE                     = 1391;
 ERROR_FILE_CORRUPT                       = 1392;
 ERROR_DISK_CORRUPT                       = 1393;
 ERROR_NO_USER_SESSION_KEY                = 1394;
 ERROR_LICENSE_QUOTA_EXCEEDED             = 1395;
 ERROR_INVALID_WINDOW_HANDLE              = 1400;
 ERROR_INVALID_MENU_HANDLE                = 1401;
 ERROR_INVALID_CURSOR_HANDLE              = 1402;
 ERROR_INVALID_ACCEL_HANDLE               = 1403;
 ERROR_INVALID_HOOK_HANDLE                = 1404;
 ERROR_INVALID_DWP_HANDLE                 = 1405;
 ERROR_TLW_WITH_WSCHILD                   = 1406;
 ERROR_CANNOT_FIND_WND_CLASS              = 1407;
 ERROR_WINDOW_OF_OTHER_THREAD             = 1408;
 ERROR_HOTKEY_ALREADY_REGISTERED          = 1409;
 ERROR_CLASS_ALREADY_EXISTS               = 1410;
 ERROR_CLASS_DOES_NOT_EXIST               = 1411;
 ERROR_CLASS_HAS_WINDOWS                  = 1412;
 ERROR_INVALID_INDEX                      = 1413;
 ERROR_INVALID_ICON_HANDLE                = 1414;
 ERROR_PRIVATE_DIALOG_INDEX               = 1415;
 ERROR_LISTBOX_ID_NOT_FOUND               = 1416;
 ERROR_NO_WILDCARD_CHARACTERS             = 1417;
 ERROR_CLIPBOARD_NOT_OPEN                 = 1418;
 ERROR_HOTKEY_NOT_REGISTERED              = 1419;
 ERROR_WINDOW_NOT_DIALOG                  = 1420;
 ERROR_CONTROL_ID_NOT_FOUND               = 1421;
 ERROR_INVALID_COMBOBOX_MESSAGE           = 1422;
 ERROR_WINDOW_NOT_COMBOBOX                = 1423;
 ERROR_INVALID_EDIT_HEIGHT                = 1424;
 ERROR_DC_NOT_FOUND                       = 1425;
 ERROR_INVALID_HOOK_FILTER                = 1426;
 ERROR_INVALID_FILTER_PROC                = 1427;
 ERROR_HOOK_NEEDS_HMOD                    = 1428;
 ERROR_GLOBAL_ONLY_HOOK                   = 1429;
 ERROR_JOURNAL_HOOK_SET                   = 1430;
 ERROR_HOOK_NOT_INSTALLED                 = 1431;
 ERROR_INVALID_LB_MESSAGE                 = 1432;
 ERROR_SETCOUNT_ON_BAD_LB                 = 1433;
 ERROR_LB_WITHOUT_TABSTOPS                = 1434;
 ERROR_DESTROY_OBJECT_OF_OTHER_TH         = 1435;
 ERROR_CHILD_WINDOW_MENU                  = 1436;
 ERROR_NO_SYSTEM_MENU                     = 1437;
 ERROR_INVALID_MSGBOX_STYLE               = 1438;
 ERROR_INVALID_SPI_VALUE                  = 1439;
 ERROR_SCREEN_ALREADY_LOCKED              = 1440;
 ERROR_HWNDS_HAVE_DIFF_PARENT             = 1441;
 ERROR_NOT_CHILD_WINDOW                   = 1442;
 ERROR_INVALID_GW_COMMAND                 = 1443;
 ERROR_INVALID_THREAD_ID                  = 1444;
 ERROR_NON_MDICHILD_WINDOW                = 1445;
 ERROR_POPUP_ALREADY_ACTIVE               = 1446;
 ERROR_NO_SCROLLBARS                      = 1447;
 ERROR_INVALID_SCROLLBAR_RANGE            = 1448;
 ERROR_INVALID_SHOWWIN_COMMAND            = 1449;
 ERROR_NO_SYSTEM_RESOURCES                = 1450;
 ERROR_NONPAGED_SYSTEM_RESOURCES          = 1451;
 ERROR_PAGED_SYSTEM_RESOURCES             = 1452;
 ERROR_WORKING_SET_QUOTA                  = 1453;
 ERROR_PAGEFILE_QUOTA                     = 1454;
 ERROR_COMMITMENT_LIMIT                   = 1455;
 ERROR_MENU_ITEM_NOT_FOUND                = 1456;
 ERROR_INVALID_KEYBOARD_HANDLE            = 1457;
 ERROR_HOOK_TYPE_NOT_ALLOWED              = 1458;
 ERROR_REQUIRES_INTERACTIVE_WINDOWSTATION = 1459;
 ERROR_TIMEOUT                            = 1460;
 ERROR_EVENTLOG_FILE_CORRUPT              = 1500;
 ERROR_EVENTLOG_CANT_START                = 1501;
 ERROR_LOG_FILE_FULL                      = 1502;
 ERROR_EVENTLOG_FILE_CHANGED              = 1503;
 RPC_S_INVALID_STRING_BINDING             = 1700;
 RPC_S_WRONG_KIND_OF_BINDING              = 1701;
 RPC_S_INVALID_BINDING                    = 1702;
 RPC_S_PROTSEQ_NOT_SUPPORTED              = 1703;
 RPC_S_INVALID_RPC_PROTSEQ                = 1704;
 RPC_S_INVALID_STRING_UUID                = 1705;
 RPC_S_INVALID_ENDPOINT_FORMAT            = 1706;
 RPC_S_INVALID_NET_ADDR                   = 1707;
 RPC_S_NO_ENDPOINT_FOUND                  = 1708;
 RPC_S_INVALID_TIMEOUT                    = 1709;
 RPC_S_OBJECT_NOT_FOUND                   = 1710;
 RPC_S_ALREADY_REGISTERED                 = 1711;
 RPC_S_TYPE_ALREADY_REGISTERED            = 1712;
 RPC_S_ALREADY_LISTENING                  = 1713;
 RPC_S_NO_PROTSEQS_REGISTERED             = 1714;
 RPC_S_NOT_LISTENING                      = 1715;
 RPC_S_UNKNOWN_MGR_TYPE                   = 1716;
 RPC_S_UNKNOWN_IF                         = 1717;
 RPC_S_NO_BINDINGS                        = 1718;
 RPC_S_NO_PROTSEQS                        = 1719;
 RPC_S_CANT_CREATE_ENDPOINT               = 1720;
 RPC_S_OUT_OF_RESOURCES                   = 1721;
 RPC_S_SERVER_UNAVAILABLE                 = 1722;
 RPC_S_SERVER_TOO_BUSY                    = 1723;
 RPC_S_INVALID_NETWORK_OPTIONS            = 1724;
 RPC_S_NO_CALL_ACTIVE                     = 1725;
 RPC_S_CALL_FAILED                        = 1726;
 RPC_S_CALL_FAILED_DNE                    = 1727;
 RPC_S_PROTOCOL_ERROR                     = 1728;
 RPC_S_UNSUPPORTED_TRANS_SYN              = 1730;
 RPC_S_UNSUPPORTED_TYPE                   = 1732;
 RPC_S_INVALID_TAG                        = 1733;
 RPC_S_INVALID_BOUND                      = 1734;
 RPC_S_NO_ENTRY_NAME                      = 1735;
 RPC_S_INVALID_NAME_SYNTAX                = 1736;
 RPC_S_UNSUPPORTED_NAME_SYNTAX            = 1737;
 RPC_S_UUID_NO_ADDRESS                    = 1739;
 RPC_S_DUPLICATE_ENDPOINT                 = 1740;
 RPC_S_UNKNOWN_AUTHN_TYPE                 = 1741;
 RPC_S_MAX_CALLS_TOO_SMALL                = 1742;
 RPC_S_STRING_TOO_LONG                    = 1743;
 RPC_S_PROTSEQ_NOT_FOUND                  = 1744;
 RPC_S_PROCNUM_OUT_OF_RANGE               = 1745;
 RPC_S_BINDING_HAS_NO_AUTH                = 1746;
 RPC_S_UNKNOWN_AUTHN_SERVICE              = 1747;
 RPC_S_UNKNOWN_AUTHN_LEVEL                = 1748;
 RPC_S_INVALID_AUTH_IDENTITY              = 1749;
 RPC_S_UNKNOWN_AUTHZ_SERVICE              = 1750;
 EPT_S_INVALID_ENTRY                      = 1751;
 EPT_S_CANT_PERFORM_OP                    = 1752;
 EPT_S_NOT_REGISTERED                     = 1753;
 RPC_S_NOTHING_TO_EXPORT                  = 1754;
 RPC_S_INCOMPLETE_NAME                    = 1755;
 RPC_S_INVALID_VERS_OPTION                = 1756;
 RPC_S_NO_MORE_MEMBERS                    = 1757;
 RPC_S_NOT_ALL_OBJS_UNEXPORTED            = 1758;
 RPC_S_INTERFACE_NOT_FOUND                = 1759;
 RPC_S_ENTRY_ALREADY_EXISTS               = 1760;
 RPC_S_ENTRY_NOT_FOUND                    = 1761;
 RPC_S_NAME_SERVICE_UNAVAILABLE           = 1762;
 RPC_S_INVALID_NAF_ID                     = 1763;
 RPC_S_CANNOT_SUPPORT                     = 1764;
 RPC_S_NO_CONTEXT_AVAILABLE               = 1765;
 RPC_S_INTERNAL_ERROR                     = 1766;
 RPC_S_ZERO_DIVIDE                        = 1767;
 RPC_S_ADDRESS_ERROR                      = 1768;
 RPC_S_FP_DIV_ZERO                        = 1769;
 RPC_S_FP_UNDERFLOW                       = 1770;
 RPC_S_FP_OVERFLOW                        = 1771;
 RPC_X_NO_MORE_ENTRIES                    = 1772;
 RPC_X_SS_CHAR_TRANS_OPEN_FAIL            = 1773;
 RPC_X_SS_CHAR_TRANS_SHORT_FILE           = 1774;
 RPC_X_SS_IN_NULL_CONTEXT                 = 1775;
 RPC_X_SS_CONTEXT_DAMAGED                 = 1777;
 RPC_X_SS_HANDLES_MISMATCH                = 1778;
 RPC_X_SS_CANNOT_GET_CALL_HANDLE          = 1779;
 RPC_X_NULL_REF_POINTER                   = 1780;
 RPC_X_ENUM_VALUE_OUT_OF_RANGE            = 1781;
 RPC_X_BYTE_COUNT_TOO_SMALL               = 1782;
 RPC_X_BAD_STUB_DATA                      = 1783;
 ERROR_INVALID_USER_BUFFER                = 1784;
 ERROR_UNRECOGNIZED_MEDIA                 = 1785;
 ERROR_NO_TRUST_LSA_SECRET                = 1786;
 ERROR_NO_TRUST_SAM_ACCOUNT               = 1787;
 ERROR_TRUSTED_DOMAIN_FAILURE             = 1788;
 ERROR_TRUSTED_RELATIONSHIP_FAILU         = 1789;
 ERROR_TRUST_FAILURE                      = 1790;
 RPC_S_CALL_IN_PROGRESS                   = 1791;
 ERROR_NETLOGON_NOT_STARTED               = 1792;
 ERROR_ACCOUNT_EXPIRED                    = 1793;
 ERROR_REDIRECTOR_HAS_OPEN_HANDLE         = 1794;
 ERROR_PRINTER_DRIVER_ALREADY_INS         = 1795;
 ERROR_UNKNOWN_PORT                       = 1796;
 ERROR_UNKNOWN_PRINTER_DRIVER             = 1797;
 ERROR_UNKNOWN_PRINTPROCESSOR             = 1798;
 ERROR_INVALID_SEPARATOR_FILE             = 1799;
 ERROR_INVALID_PRIORITY                   = 1800;
 ERROR_INVALID_PRINTER_NAME               = 1801;
 ERROR_PRINTER_ALREADY_EXISTS             = 1802;
 ERROR_INVALID_PRINTER_COMMAND            = 1803;
 ERROR_INVALID_DATATYPE                   = 1804;
 ERROR_INVALID_ENVIRONMENT                = 1805;
 RPC_S_NO_MORE_BINDINGS                   = 1806;
 ERROR_NOLOGON_INTERDOMAIN_TRUST          = 1807;
 ERROR_NOLOGON_WORKSTATION_TRUST          = 1808;
 ERROR_NOLOGON_SERVER_TRUST_ACCOU         = 1809;
 ERROR_DOMAIN_TRUST_INCONSISTENT          = 1810;
 ERROR_SERVER_HAS_OPEN_HANDLES            = 1811;
 ERROR_RESOURCE_DATA_NOT_FOUND            = 1812;
 ERROR_RESOURCE_TYPE_NOT_FOUND            = 1813;
 ERROR_RESOURCE_NAME_NOT_FOUND            = 1814;
 ERROR_RESOURCE_LANG_NOT_FOUND            = 1815;
 ERROR_NOT_ENOUGH_QUOTA                   = 1816;
 RPC_S_NO_INTERFACES                      = 1817;
 RPC_S_CALL_CANCELLED                     = 1818;
 RPC_S_BINDING_INCOMPLETE                 = 1819;
 RPC_S_COMM_FAILURE                       = 1820;
 RPC_S_UNSUPPORTED_AUTHN_LEVEL            = 1821;
 RPC_S_NO_PRINC_NAME                      = 1822;
 RPC_S_NOT_RPC_ERROR                      = 1823;
 RPC_S_UUID_LOCAL_ONLY                    = 1824;
 RPC_S_SEC_PKG_ERROR                      = 1825;
 RPC_S_NOT_CANCELLED                      = 1826;
 RPC_X_INVALID_ES_ACTION                  = 1827;
 RPC_X_WRONG_ES_VERSION                   = 1828;
 RPC_X_WRONG_STUB_VERSION                 = 1829;
 RPC_X_INVALID_PIPE_OBJECT                = 1830;
 RPC_X_INVALID_PIPE_OPERATION             = 1831;
 RPC_X_WRONG_PIPE_VERSION                 = 1832;
 RPC_S_GROUP_MEMBER_NOT_FOUND             = 1898;
 EPT_S_CANT_CREATE                        = 1899;
 RPC_S_INVALID_OBJECT                     = 1900;
 ERROR_INVALID_TIME                       = 1901;
 ERROR_INVALID_FORM_NAME                  = 1902;
 ERROR_INVALID_FORM_SIZE                  = 1903;
 ERROR_ALREADY_WAITING                    = 1904;
 ERROR_PRINTER_DELETED                    = 1905;
 ERROR_INVALID_PRINTER_STATE              = 1906;
 ERROR_PASSWORD_MUST_CHANGE               = 1907;
 ERROR_DOMAIN_CONTROLLER_NOT_FOUN         = 1908;
 ERROR_ACCOUNT_LOCKED_OUT                 = 1909;
 OR_INVALID_OXID                          = 1910;
 OR_INVALID_OID                           = 1911;
 OR_INVALID_SET                           = 1912;
 RPC_S_SEND_INCOMPLETE                    = 1913;
 ERROR_INVALID_PIXEL_FORMAT               = 2000;
 ERROR_BAD_DRIVER                         = 2001;
 ERROR_INVALID_WINDOW_STYLE               = 2002;
 ERROR_METAFILE_NOT_SUPPORTED             = 2003;
 ERROR_TRANSFORM_NOT_SUPPORTED            = 2004;
 ERROR_CLIPPING_NOT_SUPPORTED             = 2005;
 ERROR_UNKNOWN_PRINT_MONITOR              = 3000;
 ERROR_PRINTER_DRIVER_IN_USE              = 3001;
 ERROR_SPOOL_FILE_NOT_FOUND               = 3002;
 ERROR_SPL_NO_STARTDOC                    = 3003;
 ERROR_SPL_NO_ADDJOB                      = 3004;
 ERROR_PRINT_PROCESSOR_ALREADY_INSTALLED  = 3005;
 ERROR_PRINT_MONITOR_ALREADY_INSTALLED    = 3006;
 ERROR_INVALID_PRINT_MONITOR              = 3007;
 ERROR_PRINT_MONITOR_IN_USE               = 3008;
 ERROR_PRINTER_HAS_JOBS_QUEUED            = 3009;
 ERROR_SUCCESS_REBOOT_REQUIRED            = 3010;
 ERROR_SUCCESS_RESTART_REQUIRED           = 3011;
 ERROR_WINS_INTERNAL                      = 4000;
 ERROR_CAN_NOT_DEL_LOCAL_WINS             = 4001;
 ERROR_STATIC_INIT                        = 4002;
 ERROR_INC_BACKUP                         = 4003;
 ERROR_FULL_BACKUP                        = 4004;
 ERROR_REC_NON_EXISTENT                   = 4005;
 ERROR_RPL_NOT_ALLOWED                    = 4006;
 ERROR_NO_BROWSER_SERVERS_FOUND           = 6118;

/////////////////////////////////////////////////////////////////////////////
// Primary language identifiers
/////////////////////////////////////////////////////////////////////////////
 LANG_NEUTRAL                         = $00;
 LANG_AFRIKAANS                       = $36;
 LANG_ALBANIAN                        = $1C;
 LANG_ARABIC                          = $01;
 LANG_BASQUE                          = $2D;
 LANG_BELARUSIAN                      = $23;
 LANG_BULGARIAN                       = $02;
 LANG_CATALAN                         = $03;
 LANG_CHINESE                         = $04;
 LANG_CROATIAN                        = $1A;
 LANG_CZECH                           = $05;
 LANG_DANISH                          = $06;
 LANG_DUTCH                           = $13;
 LANG_ENGLISH                         = $09;
 LANG_ESTONIAN                        = $25;
 LANG_FAEROESE                        = $38;
 LANG_FARSI                           = $29;
 LANG_FINNISH                         = $0B;
 LANG_FRENCH                          = $0C;
 LANG_GERMAN                          = $07;
 LANG_GREEK                           = $08;
 LANG_HEBREW                          = $0D;
 LANG_HUNGARIAN                       = $0E;
 LANG_ICELANDIC                       = $0F;
 LANG_INDONESIAN                      = $21;
 LANG_ITALIAN                         = $10;
 LANG_JAPANESE                        = $11;
 LANG_KOREAN                          = $12;
 LANG_LATVIAN                         = $26;
 LANG_LITHUANIAN                      = $27;
 LANG_NORWEGIAN                       = $14;
 LANG_POLISH                          = $15;
 LANG_PORTUGUESE                      = $16;
 LANG_ROMANIAN                        = $18;
 LANG_RUSSIAN                         = $19;
 LANG_SERBIAN                         = $1A;
 LANG_SLOVAK                          = $1B;
 LANG_SLOVENIAN                       = $24;
 LANG_SPANISH                         = $0A;
 LANG_SWEDISH                         = $1D;
 LANG_THAI                            = $1E;
 LANG_TURKISH                         = $1F;
 LANG_UKRAINIAN                       = $22;
 LANG_VIETNAMESE                      = $2A;

/////////////////////////////////////////////////////////////////////////////
// The sublanguage identifiers
/////////////////////////////////////////////////////////////////////////////
 SUBLANG_NEUTRAL                      = $00;
 SUBLANG_DEFAULT                      = $01;
 SUBLANG_SYS_DEFAULT                  = $02;
 SUBLANG_ARABIC_SAUDI_ARABIA          = $01;
 SUBLANG_ARABIC_IRAQ                  = $02;
 SUBLANG_ARABIC_EGYPT                 = $03;
 SUBLANG_ARABIC_LIBYA                 = $04;
 SUBLANG_ARABIC_ALGERIA               = $05;
 SUBLANG_ARABIC_MOROCCO               = $06;
 SUBLANG_ARABIC_TUNISIA               = $07;
 SUBLANG_ARABIC_OMAN                  = $08;
 SUBLANG_ARABIC_YEMEN                 = $09;
 SUBLANG_ARABIC_SYRIA                 = $0A;
 SUBLANG_ARABIC_JORDAN                = $0B;
 SUBLANG_ARABIC_LEBANON               = $0C;
 SUBLANG_ARABIC_KUWAIT                = $0D;
 SUBLANG_ARABIC_UAE                   = $0E;
 SUBLANG_ARABIC_BAHRAIN               = $0F;
 SUBLANG_ARABIC_QATAR                 = $10;
 SUBLANG_CHINESE_TRADITIONAL          = $01;
 SUBLANG_CHINESE_SIMPLIFIED           = $02;
 SUBLANG_CHINESE_HONGKONG             = $03;
 SUBLANG_CHINESE_SINGAPORE            = $04;
 SUBLANG_DUTCH                        = $01;
 SUBLANG_DUTCH_BELGIAN                = $02;
 SUBLANG_ENGLISH_US                   = $01;
 SUBLANG_ENGLISH_UK                   = $02;
 SUBLANG_ENGLISH_AUS                  = $03;
 SUBLANG_ENGLISH_CAN                  = $04;
 SUBLANG_ENGLISH_NZ                   = $05;
 SUBLANG_ENGLISH_EIRE                 = $06;
 SUBLANG_ENGLISH_SOUTH_AFRICA         = $07;
 SUBLANG_ENGLISH_JAMAICA              = $08;
 SUBLANG_ENGLISH_CARIBBEAN            = $09;
 SUBLANG_ENGLISH_BELIZE               = $0a;
 SUBLANG_ENGLISH_TRINIDAD             = $0b;
 SUBLANG_FRENCH                       = $01;
 SUBLANG_FRENCH_BELGIAN               = $02;
 SUBLANG_FRENCH_CANADIAN              = $03;
 SUBLANG_FRENCH_SWISS                 = $04;
 SUBLANG_FRENCH_LUXEMBOURG            = $05;
 SUBLANG_GERMAN                       = $01;
 SUBLANG_GERMAN_SWISS                 = $02;
 SUBLANG_GERMAN_AUSTRIAN              = $03;
 SUBLANG_GERMAN_LUXEMBOURG            = $04;
 SUBLANG_GERMAN_LIECHTENSTEIN         = $05;
 SUBLANG_ITALIAN                      = $01;
 SUBLANG_ITALIAN_SWISS                = $02;
 SUBLANG_KOREAN                       = $01;
 SUBLANG_KOREAN_JOHAB                 = $02;
 SUBLANG_NORWEGIAN_BOKMAL             = $01;
 SUBLANG_NORWEGIAN_NYNORSK            = $02;
 SUBLANG_PORTUGUESE                   = $02;
 SUBLANG_PORTUGUESE_BRAZILIAN         = $01;
 SUBLANG_SERBIAN_LATIN                = $02;
 SUBLANG_SERBIAN_CYRILLIC             = $03;
 SUBLANG_SPANISH                      = $01;
 SUBLANG_SPANISH_MEXICAN              = $02;
 SUBLANG_SPANISH_MODERN               = $03;
 SUBLANG_SPANISH_GUATEMALA            = $04;
 SUBLANG_SPANISH_COSTA_RICA           = $05;
 SUBLANG_SPANISH_PANAMA               = $06;
 SUBLANG_SPANISH_DOMINICAN_REPUBLIC   = $07;
 SUBLANG_SPANISH_VENEZUELA            = $08;
 SUBLANG_SPANISH_COLOMBIA             = $09;
 SUBLANG_SPANISH_PERU                 = $0A;
 SUBLANG_SPANISH_ARGENTINA            = $0B;
 SUBLANG_SPANISH_ECUADOR              = $0C;
 SUBLANG_SPANISH_CHILE                = $0D;
 SUBLANG_SPANISH_URUGUAY              = $0E;
 SUBLANG_SPANISH_PARAGUAY             = $0F;
 SUBLANG_SPANISH_BOLIVIA              = $10;
 SUBLANG_SPANISH_EL_SALVADOR          = $11;
 SUBLANG_SPANISH_HONDURAS             = $12;
 SUBLANG_SPANISH_NICARAGUA            = $13;
 SUBLANG_SPANISH_PUERTO_RICO          = $14;
 SUBLANG_SWEDISH                      = $01;
 SUBLANG_SWEDISH_FINLAND              = $02;

 SORT_DEFAULT                         = $00;
 SORT_JAPANESE_XJIS                   = $00;
 SORT_JAPANESE_UNICODE                = $01;
 SORT_CHINESE_BIG5                    = $00;
 SORT_CHINESE_PRCP                    = $00;
 SORT_CHINESE_UNICODE                 = $01;
 SORT_CHINESE_PRC                     = $02;
 SORT_KOREAN_KSC                      = $00;
 SORT_KOREAN_UNICODE                  = $01;
 SORT_GERMAN_PHONE_BOOK               = $01;

 LANG_SYSTEM_DEFAULT   = (SUBLANG_SYS_DEFAULT shl 10) or LANG_NEUTRAL;
 LANG_USER_DEFAULT     = (SUBLANG_DEFAULT shl 10) or LANG_NEUTRAL;

 LOCALE_SYSTEM_DEFAULT = (SORT_DEFAULT shl 16) or LANG_SYSTEM_DEFAULT;
 LOCALE_USER_DEFAULT   = (SORT_DEFAULT shl 16) or LANG_USER_DEFAULT;

 STATUS_WAIT_0                   = $00000000;
 STATUS_ABANDONED_WAIT_0         = $00000080;
 STATUS_USER_APC                 = $000000C0;
 STATUS_TIMEOUT                  = $00000102;
 STATUS_PENDING                  = $00000103;
 STATUS_SEGMENT_NOTIFICATION     = $40000005;
 STATUS_GUARD_PAGE_VIOLATION     = $80000001;
 STATUS_DATATYPE_MISALIGNMENT    = $80000002;
 STATUS_BREAKPOINT               = $80000003;
 STATUS_SINGLE_STEP              = $80000004;
 STATUS_ACCESS_VIOLATION         = $C0000005;
 STATUS_IN_PAGE_ERROR            = $C0000006;
 STATUS_INVALID_HANDLE           = $C0000008;
 STATUS_NO_MEMORY                = $C0000017;
 STATUS_ILLEGAL_INSTRUCTION      = $C000001D;
 STATUS_NONCONTINUABLE_EXCEPTION = $C0000025;
 STATUS_INVALID_DISPOSITION      = $C0000026;
 STATUS_ARRAY_BOUNDS_EXCEEDED    = $C000008C;
 STATUS_FLOAT_DENORMAL_OPERAND   = $C000008D;
 STATUS_FLOAT_DIVIDE_BY_ZERO     = $C000008E;
 STATUS_FLOAT_INEXACT_RESULT     = $C000008F;
 STATUS_FLOAT_INVALID_OPERATION  = $C0000090;
 STATUS_FLOAT_OVERFLOW           = $C0000091;
 STATUS_FLOAT_STACK_CHECK        = $C0000092;
 STATUS_FLOAT_UNDERFLOW          = $C0000093;
 STATUS_INTEGER_DIVIDE_BY_ZERO   = $C0000094;
 STATUS_INTEGER_OVERFLOW         = $C0000095;
 STATUS_PRIVILEGED_INSTRUCTION   = $C0000096;
 STATUS_STACK_OVERFLOW           = $C00000FD;
 STATUS_CONTROL_C_EXIT           = $C000013A;

 MAXIMUM_WAIT_OBJECTS            = $00040;
 SIZE_OF_80387_REGISTERS         = $00050;
 CONTEXT_i386                    = $10000;
 CONTEXT_i486                    = $10000;
 CONTEXT_CONTROL                 = CONTEXT_i386 or $00000001;
 CONTEXT_INTEGER                 = CONTEXT_i386 or $00000002;
 CONTEXT_SEGMENTS                = CONTEXT_i386 or $00000004;
 CONTEXT_FLOATING_POINT          = CONTEXT_i386 or $00000008;
 CONTEXT_DEBUG_REGISTERS         = CONTEXT_i386 or $00000010;
 CONTEXT_FULL = CONTEXT_CONTROL or CONTEXT_INTEGER or CONTEXT_SEGMENTS;

 EXCEPTION_NONCONTINUABLE            = 1;
 EXCEPTION_MAXIMUM_PARAMETERS        = 15;

 THREAD_BASE_PRIORITY_LOWRT          = 15;
 THREAD_BASE_PRIORITY_MAX            = 2;
 THREAD_BASE_PRIORITY_MIN            = -2;
 THREAD_BASE_PRIORITY_IDLE           = -15;

 SYNCHRONIZE                         = $00100000;
 STANDARD_RIGHTS_REQUIRED            = $000F0000;
 EVENT_MODIFY_STATE                  = $0002;
 EVENT_ALL_ACCESS                    = STANDARD_RIGHTS_REQUIRED or
                                       SYNCHRONIZE or $03;
 MUTANT_QUERY_STATE                  = $0001;
 MUTANT_ALL_ACCESS                   = STANDARD_RIGHTS_REQUIRED or
                                       SYNCHRONIZE or MUTANT_QUERY_STATE;

 PROCESS_TERMINATE                   = $0001;
 PROCESS_CREATE_THREAD               = $0002;
 PROCESS_VM_OPERATION                = $0008;
 PROCESS_VM_READ                     = $0010;
 PROCESS_VM_WRITE                    = $0020;
 PROCESS_DUP_HANDLE                  = $0040;
 PROCESS_CREATE_PROCESS              = $0080;
 PROCESS_SET_QUOTA                   = $0100;
 PROCESS_SET_INFORMATION             = $0200;
 PROCESS_QUERY_INFORMATION           = $0400;
 PROCESS_ALL_ACCESS                  = STANDARD_RIGHTS_REQUIRED or
                                       SYNCHRONIZE or $FFF;

 SECTION_QUERY                       = $01;
 SECTION_MAP_WRITE                   = $02;
 SECTION_MAP_READ                    = $04;
 SECTION_MAP_EXECUTE                 = $08;
 SECTION_EXTEND_SIZE                 = $10;
 SECTION_ALL_ACCESS                  = STANDARD_RIGHTS_REQUIRED or
                                       SECTION_QUERY or SECTION_MAP_WRITE or
                                       SECTION_MAP_READ or SECTION_MAP_EXECUTE
                                       or SECTION_EXTEND_SIZE;

 PAGE_NOACCESS                       = $00000001;
 PAGE_READONLY                       = $00000002;
 PAGE_READWRITE                      = $00000004;
 PAGE_WRITECOPY                      = $00000008;
 PAGE_EXECUTE                        = $00000010;
 PAGE_EXECUTE_READ                   = $00000020;
 PAGE_EXECUTE_READWRITE              = $00000040;
 PAGE_EXECUTE_WRITECOPY              = $00000080;
 PAGE_GUARD                          = $00000100;
 PAGE_NOCACHE                        = $00000200;
 MEM_COMMIT                          = $00001000;
 MEM_RESERVE                         = $00002000;
 MEM_DECOMMIT                        = $00004000;
 MEM_RELEASE                         = $00008000;
 MEM_FREE                            = $00010000;
 MEM_PRIVATE                         = $00020000;
 MEM_MAPPED                          = $00040000;
 MEM_RESET                           = $00080000;
 MEM_TOP_DOWN                        = $00100000;
 SEC_FILE                            = $00800000;
 SEC_IMAGE                           = $01000000;
 SEC_RESERVE                         = $04000000;
 SEC_COMMIT                          = $08000000;
 SEC_NOCACHE                         = $10000000;
 MEM_IMAGE                           = SEC_IMAGE;

 MAX_PATH                            = 260;

 FILE_SHARE_READ                     = $00000001;
 FILE_SHARE_WRITE                    = $00000002;
 FILE_SHARE_DELETE                   = $00000004;
 FILE_ATTRIBUTE_READONLY             = $00000001;
 FILE_ATTRIBUTE_HIDDEN               = $00000002;
 FILE_ATTRIBUTE_SYSTEM               = $00000004;
 FILE_ATTRIBUTE_DIRECTORY            = $00000010;
 FILE_ATTRIBUTE_ARCHIVE              = $00000020;
 FILE_ATTRIBUTE_NORMAL               = $00000080;
 FILE_ATTRIBUTE_TEMPORARY            = $00000100;
 FILE_ATTRIBUTE_COMPRESSED           = $00000800;
 FILE_ATTRIBUTE_OFFLINE              = $00001000;
 FILE_NOTIFY_CHANGE_FILE_NAME        = $00000001;
 FILE_NOTIFY_CHANGE_DIR_NAME         = $00000002;
 FILE_NOTIFY_CHANGE_ATTRIBUTES       = $00000004;
 FILE_NOTIFY_CHANGE_SIZE             = $00000008;
 FILE_NOTIFY_CHANGE_LAST_WRITE       = $00000010;
 FILE_NOTIFY_CHANGE_LAST_ACCESS      = $00000020;
 FILE_NOTIFY_CHANGE_CREATION         = $00000040;
 FILE_NOTIFY_CHANGE_SECURITY         = $00000100;
 FILE_ACTION_ADDED                   = $00000001;
 FILE_ACTION_REMOVED                 = $00000002;
 FILE_ACTION_MODIFIED                = $00000003;
 FILE_ACTION_RENAMED_OLD_NAME        = $00000004;
 FILE_ACTION_RENAMED_NEW_NAME        = $00000005;
 MAILSLOT_NO_MESSAGE                 =-$00000001;
 MAILSLOT_WAIT_FOREVER               =-$00000001;
 FILE_CASE_SENSITIVE_SEARCH          = $00000001;
 FILE_CASE_PRESERVED_NAMES           = $00000002;
 FILE_UNICODE_ON_DISK                = $00000004;
 FILE_PERSISTENT_ACLS                = $00000008;
 FILE_FILE_COMPRESSION               = $00000010;
 FILE_VOLUME_IS_COMPRESSED           = $00008000;

 IO_COMPLETION_MODIFY_STATE          = $0002;
 IO_COMPLETION_ALL_ACCESS            = $0003 or STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE;
 DUPLICATE_CLOSE_SOURCE              = $00000001;
 DUPLICATE_SAME_ACCESS               = $00000002;

 _DELETE                             = $00010000;
 READ_CONTROL                        = $00020000;
 WRITE_DAC                           = $00040000;
 WRITE_OWNER                         = $00080000;
 STANDARD_RIGHTS_ALL                 = $001F0000;
 SPECIFIC_RIGHTS_ALL                 = $0000FFFF;
 ACCESS_SYSTEM_SECURITY              = $01000000;
 MAXIMUM_ALLOWED                     = $02000000;
 GENERIC_READ                        = $80000000;
 GENERIC_WRITE                       = $40000000;
 GENERIC_EXECUTE                     = $20000000;
 GENERIC_ALL                         = $10000000;

 STANDARD_RIGHTS_READ                = READ_CONTROL;
 STANDARD_RIGHTS_WRITE               = READ_CONTROL;
 STANDARD_RIGHTS_EXECUTE             = READ_CONTROL;

 SidTypeUser                         = $01;
 SidTypeGroup                        = $02;
 SidTypeDomain                       = $03;
 SidTypeAlias                        = $04;
 SidTypeWellKnownGroup               = $05;
 SidTypeDeletedAccount               = $06;
 SidTypeInvalid                      = $07;
 SidTypeUnknown                      = $08;

 SECURITY_DESCRIPTOR_MIN_LENGTH      = $14;

 SE_OWNER_DEFAULTED                  = $0001;
 SE_GROUP_DEFAULTED                  = $0002;
 SE_DACL_PRESENT                     = $0004;
 SE_DACL_DEFAULTED                   = $0008;
 SE_SACL_PRESENT                     = $0010;
 SE_SACL_DEFAULTED                   = $0020;
 SE_SELF_RELATIVE                    = $8000;

 SE_PRIVILEGE_ENABLED_BY_DEFAULT     = $00000001;
 SE_PRIVILEGE_ENABLED                = $00000002;
 SE_PRIVILEGE_USED_FOR_ACCESS        = $80000000;

 PRIVILEGE_SET_ALL_NECESSARY         = $01;

 SECURITY_MAX_IMPERSONATION_LEVEL    = SecurityDelegation;
 DEFAULT_IMPERSONATION_LEVEL         = SecurityImpersonation;

 TOKEN_ASSIGN_PRIMARY             = $0001;
 TOKEN_DUPLICATE                  = $0002;
 TOKEN_IMPERSONATE                = $0004;
 TOKEN_QUERY                      = $0008;
 TOKEN_QUERY_SOURCE               = $0010;
 TOKEN_ADJUST_PRIVILEGES          = $0020;
 TOKEN_ADJUST_GROUPS              = $0040;
 TOKEN_ADJUST_DEFAULT             = $0080;
 TOKEN_ALL_ACCESS                 = STANDARD_RIGHTS_REQUIRED or
                                    TOKEN_ASSIGN_PRIMARY or
                                    TOKEN_DUPLICATE or TOKEN_IMPERSONATE or
                                    TOKEN_QUERY or TOKEN_QUERY_SOURCE or
                                    TOKEN_ADJUST_GROUPS or
                                    TOKEN_ADJUST_PRIVILEGES or
                                    TOKEN_ADJUST_DEFAULT;
 TOKEN_READ                       = STANDARD_RIGHTS_READ or TOKEN_QUERY;
 TOKEN_WRITE                      = STANDARD_RIGHTS_WRITE or
                                    TOKEN_ADJUST_GROUPS or
                                    TOKEN_ADJUST_PRIVILEGES or
                                    TOKEN_ADJUST_DEFAULT;
 TOKEN_EXECUTE                    = STANDARD_RIGHTS_EXECUTE;

 SECURITY_DYNAMIC_TRACKING        = True;
 SECURITY_STATIC_TRACKING         = False;

 OWNER_SECURITY_INFORMATION       = $00000001;
 GROUP_SECURITY_INFORMATION       = $00000002;
 DACL_SECURITY_INFORMATION        = $00000004;
 SACL_SECURITY_INFORMATION        = $00000008;

 IMAGE_DOS_SIGNATURE              = $5A4D;
 IMAGE_OS2_SIGNATURE              = $454E;
 IMAGE_OS2_SIGNATURE_LE           = $454C;
 IMAGE_VXD_SIGNATURE              = $454C;
 IMAGE_NT_SIGNATURE               = $00004550;

 IMAGE_SIZEOF_FILE_HEADER         = $14;

 IMAGE_FILE_RELOCS_STRIPPED               = $0001;
 IMAGE_FILE_EXECUTABLE_IMAGE              = $0002;
 IMAGE_FILE_LINE_NUMS_STRIPPED            = $0004;
 IMAGE_FILE_LOCAL_SYMS_STRIPPED           = $0008;
 IMAGE_FILE_AGGRESIVE_WS_TRIM             = $0010;
 IMAGE_FILE_BYTES_REVERSED_LO             = $0080;
 IMAGE_FILE_32BIT_MACHINE                 = $0100;
 IMAGE_FILE_DEBUG_STRIPPED                = $0200;
 IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP       = $0400;
 IMAGE_FILE_NET_RUN_FROM_SWAP             = $0800;
 IMAGE_FILE_SYSTEM                        = $1000;
 IMAGE_FILE_DLL                           = $2000;
 IMAGE_FILE_UP_SYSTEM_ONLY                = $4000;
 IMAGE_FILE_BYTES_REVERSED_HI             = $8000;

 IMAGE_FILE_MACHINE_UNKNOWN               = $0000;
 IMAGE_FILE_MACHINE_I386                  = $014C;
 IMAGE_FILE_MACHINE_R3000                 = $0162;
 IMAGE_FILE_MACHINE_R4000                 = $0166;
 IMAGE_FILE_MACHINE_R10000                = $0168;
 IMAGE_FILE_MACHINE_ALPHA                 = $0184;
 IMAGE_FILE_MACHINE_POWERPC               = $01F0;

 IMAGE_NUMBEROF_DIRECTORY_ENTRIES         = 16;
 IMAGE_SIZEOF_ROM_OPTIONAL_HEADER         = 56;
 IMAGE_SIZEOF_STD_OPTIONAL_HEADER         = 28;
 IMAGE_SIZEOF_NT_OPTIONAL_HEADER          = 224;

 IMAGE_NT_OPTIONAL_HDR_MAGIC              = $010B;
 IMAGE_ROM_OPTIONAL_HDR_MAGIC             = $0107;

 IMAGE_SUBSYSTEM_UNKNOWN                  = $00;
 IMAGE_SUBSYSTEM_NATIVE                   = $01;
 IMAGE_SUBSYSTEM_WINDOWS_GUI              = $02;
 IMAGE_SUBSYSTEM_WINDOWS_CUI              = $03;
 IMAGE_SUBSYSTEM_OS2_CUI                  = $05;
 IMAGE_SUBSYSTEM_POSIX_CUI                = $07;
 IMAGE_SUBSYSTEM_RESERVED8                = $08;

 IMAGE_DIRECTORY_ENTRY_EXPORT             = $00;
 IMAGE_DIRECTORY_ENTRY_IMPORT             = $01;
 IMAGE_DIRECTORY_ENTRY_RESOURCE           = $02;
 IMAGE_DIRECTORY_ENTRY_EXCEPTION          = $03;
 IMAGE_DIRECTORY_ENTRY_SECURITY           = $04;
 IMAGE_DIRECTORY_ENTRY_BASERELOC          = $05;
 IMAGE_DIRECTORY_ENTRY_DEBUG              = $06;
 IMAGE_DIRECTORY_ENTRY_COPYRIGHT          = $07;
 IMAGE_DIRECTORY_ENTRY_GLOBALPTR          = $08;
 IMAGE_DIRECTORY_ENTRY_TLS                = $09;
 IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG        = $0A;
 IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT       = $0B;
 IMAGE_DIRECTORY_ENTRY_IAT                = $0C;

 IMAGE_SIZEOF_SHORT_NAME                  = $08;
 IMAGE_SIZEOF_SECTION_HEADER              = $28;

 IMAGE_SCN_TYPE_NO_PAD                    = $00000008;

 IMAGE_SCN_CNT_CODE                       = $00000020;
 IMAGE_SCN_CNT_INITIALIZED_DATA           = $00000040;
 IMAGE_SCN_CNT_UNINITIALIZED_DATA         = $00000080;

 IMAGE_SCN_LNK_OTHER                      = $00000100;
 IMAGE_SCN_LNK_INFO                       = $00000200;
 IMAGE_SCN_LNK_REMOVE                     = $00000800;
 IMAGE_SCN_LNK_COMDAT                     = $00001000;

 IMAGE_SCN_ALIGN_1BYTES                   = $00100000;
 IMAGE_SCN_ALIGN_2BYTES                   = $00200000;
 IMAGE_SCN_ALIGN_4BYTES                   = $00300000;
 IMAGE_SCN_ALIGN_8BYTES                   = $00400000;
 IMAGE_SCN_ALIGN_16BYTES                  = $00500000;
 IMAGE_SCN_ALIGN_32BYTES                  = $00600000;
 IMAGE_SCN_ALIGN_64BYTES                  = $00700000;

 IMAGE_SCN_MEM_FARDATA                    = $00008000;
 IMAGE_SCN_MEM_PURGEABLE                  = $00020000;
 IMAGE_SCN_MEM_16BIT                      = $00020000;
 IMAGE_SCN_MEM_LOCKED                     = $00040000;
 IMAGE_SCN_MEM_PRELOAD                    = $00080000;

 IMAGE_SCN_LNK_NRELOC_OVFL                = $01000000;
 IMAGE_SCN_MEM_DISCARDABLE                = $02000000;
 IMAGE_SCN_MEM_NOT_CACHED                 = $04000000;
 IMAGE_SCN_MEM_NOT_PAGED                  = $08000000;
 IMAGE_SCN_MEM_SHARED                     = $10000000;
 IMAGE_SCN_MEM_EXECUTE                    = $20000000;
 IMAGE_SCN_MEM_READ                       = $40000000;
 IMAGE_SCN_MEM_WRITE                      = $80000000;

 IMAGE_DEBUG_TYPE_UNKNOWN                 = $00;
 IMAGE_DEBUG_TYPE_COFF                    = $01;
 IMAGE_DEBUG_TYPE_CODEVIEW                = $02;
 IMAGE_DEBUG_TYPE_FPO                     = $03;
 IMAGE_DEBUG_TYPE_MISC                    = $04;
 IMAGE_DEBUG_TYPE_EXCEPTION               = $05;
 IMAGE_DEBUG_TYPE_FIXUP                   = $06;
 IMAGE_DEBUG_TYPE_OMAP_TO_SRC             = $07;
 IMAGE_DEBUG_TYPE_OMAP_FROM_SRC           = $08;

 FRAME_FPO       = $00;
 FRAME_TRAP      = $01;
 FRAME_TSS       = $02;
 FRAME_NONFPO    = $03;

 SIZEOF_RFPO_DATA         = $10;
 IMAGE_DEBUG_MISC_EXENAME = $01;

 RTL_CRITSECT_TYPE        = $00;
 RTL_RESOURCE_TYPE        = $01;

 DLL_PROCESS_ATTACH       = $01;
 DLL_THREAD_ATTACH        = $02;
 DLL_THREAD_DETACH        = $03;
 DLL_PROCESS_DETACH       = $00;

 KEY_QUERY_VALUE          = $0001;
 KEY_SET_VALUE            = $0002;
 KEY_CREATE_SUB_KEY       = $0004;
 KEY_ENUMERATE_SUB_KEYS   = $0008;
 KEY_NOTIFY               = $0010;
 KEY_CREATE_LINK          = $0020;

 KEY_READ                 = STANDARD_RIGHTS_READ or
                            KEY_QUERY_VALUE or
                            KEY_ENUMERATE_SUB_KEYS or
                            KEY_NOTIFY and not SYNCHRONIZE;

 KEY_WRITE                = STANDARD_RIGHTS_WRITE or
                            KEY_SET_VALUE or
                            KEY_CREATE_SUB_KEY and not SYNCHRONIZE;

 KEY_EXECUTE              = KEY_READ and not SYNCHRONIZE;

 KEY_ALL_ACCESS           = STANDARD_RIGHTS_ALL or
                            KEY_QUERY_VALUE or
                            KEY_SET_VALUE or
                            KEY_CREATE_SUB_KEY or
                            KEY_ENUMERATE_SUB_KEYS or
                            KEY_NOTIFY or
                            KEY_CREATE_LINK and not SYNCHRONIZE;

 REG_OPTION_RESERVED       = $00000000;
 REG_OPTION_NON_VOLATILE   = $00000000;
 REG_OPTION_VOLATILE       = $00000001;
 REG_OPTION_CREATE_LINK    = $00000002;
 REG_OPTION_BACKUP_RESTORE = $00000004;
 REG_LEGAL_OPTION          = REG_OPTION_RESERVED or
                             REG_OPTION_NON_VOLATILE or
                             REG_OPTION_VOLATILE or
                             REG_OPTION_CREATE_LINK or
                             REG_OPTION_BACKUP_RESTORE;

 REG_CREATED_NEW_KEY       = $00000001;
 REG_OPENED_EXISTING_KEY   = $00000002;
 REG_WHOLE_HIVE_VOLATILE   = $00000001;
 REG_REFRESH_HIVE          = $00000002;

 REG_NOTIFY_CHANGE_NAME       = $00000001;
 REG_NOTIFY_CHANGE_ATTRIBUTES = $00000002;
 REG_NOTIFY_CHANGE_LAST_SET   = $00000004;
 REG_NOTIFY_CHANGE_SECURITY   = $00000008;

 REG_LEGAL_CHANGE_FILTER = REG_OPTION_RESERVED or
                           REG_NOTIFY_CHANGE_NAME or
                           REG_NOTIFY_CHANGE_ATTRIBUTES or
                           REG_NOTIFY_CHANGE_LAST_SET or
                           REG_NOTIFY_CHANGE_SECURITY;

 REG_NONE                       = $00;
 REG_SZ                         = $01;
 REG_EXPAND_SZ                  = $02;
 REG_BINARY                     = $03;
 REG_DWORD                      = $04;
 REG_DWORD_LITTLE_ENDIAN        = $04;
 REG_DWORD_BIG_ENDIAN           = $05;
 REG_LINK                       = $06;
 REG_MULTI_SZ                   = $07;
 REG_RESOURCE_LIST              = $08;
 REG_FULL_RESOURCE_DESCRIPTOR   = $09;
 REG_RESOURCE_REQUIREMENTS_LIST = $0A;

 HFILE_ERROR                    = -1;

 INVALID_HANDLE_VALUE           = $FFFFFFFF;
 INVALID_FILE_SIZE              = $FFFFFFFF;

 FILE_BEGIN                     = $00;
 FILE_CURRENT                   = $01;
 FILE_END                       = $02;

 TIME_ZONE_ID_INVALID           = $FFFFFFFF;

 WAIT_FAILED                    = $FFFFFFFF;
 WAIT_OBJECT_0                  = STATUS_WAIT_0;

 WAIT_ABANDONED                 = STATUS_ABANDONED_WAIT_0;
 WAIT_ABANDONED_0               = STATUS_ABANDONED_WAIT_0;

 WAIT_TIMEOUT                       = STATUS_TIMEOUT;
 WAIT_IO_COMPLETION                 = STATUS_USER_APC;
 STILL_ACTIVE                       = STATUS_PENDING;
 EXCEPTION_ACCESS_VIOLATION         = STATUS_ACCESS_VIOLATION;
 EXCEPTION_DATATYPE_MISALIGNMENT    = STATUS_DATATYPE_MISALIGNMENT;
 EXCEPTION_BREAKPOINT               = STATUS_BREAKPOINT;
 EXCEPTION_SINGLE_STEP              = STATUS_SINGLE_STEP;
 EXCEPTION_ARRAY_BOUNDS_EXCEEDED    = STATUS_ARRAY_BOUNDS_EXCEEDED;
 EXCEPTION_FLT_DENORMAL_OPERAND     = STATUS_FLOAT_DENORMAL_OPERAND;
 EXCEPTION_FLT_DIVIDE_BY_ZERO       = STATUS_FLOAT_DIVIDE_BY_ZERO;
 EXCEPTION_FLT_INEXACT_RESULT       = STATUS_FLOAT_INEXACT_RESULT;
 EXCEPTION_FLT_INVALID_OPERATION    = STATUS_FLOAT_INVALID_OPERATION;
 EXCEPTION_FLT_OVERFLOW             = STATUS_FLOAT_OVERFLOW;
 EXCEPTION_FLT_STACK_CHECK          = STATUS_FLOAT_STACK_CHECK;
 EXCEPTION_FLT_UNDERFLOW            = STATUS_FLOAT_UNDERFLOW;
 EXCEPTION_INT_DIVIDE_BY_ZERO       = STATUS_INTEGER_DIVIDE_BY_ZERO;
 EXCEPTION_INT_OVERFLOW             = STATUS_INTEGER_OVERFLOW;
 EXCEPTION_PRIV_INSTRUCTION         = STATUS_PRIVILEGED_INSTRUCTION;
 EXCEPTION_IN_PAGE_ERROR            = STATUS_IN_PAGE_ERROR;
 EXCEPTION_ILLEGAL_INSTRUCTION      = STATUS_ILLEGAL_INSTRUCTION;
 EXCEPTION_NONCONTINUABLE_EXCEPTION = STATUS_NONCONTINUABLE_EXCEPTION;
 EXCEPTION_STACK_OVERFLOW           = STATUS_STACK_OVERFLOW;
 EXCEPTION_INVALID_DISPOSITION      = STATUS_INVALID_DISPOSITION;
 EXCEPTION_GUARD_PAGE               = STATUS_GUARD_PAGE_VIOLATION;
 EXCEPTION_INVALID_HANDLE           = STATUS_INVALID_HANDLE;
 CONTROL_C_EXIT                     = STATUS_CONTROL_C_EXIT;

 FILE_FLAG_SEQUENTIAL_SCAN              = $08000000;
 FILE_FLAG_DELETE_ON_CLOSE              = $04000000;
 FILE_FLAG_BACKUP_SEMANTICS             = $02000000;
 FILE_FLAG_POSIX_SEMANTICS              = $01000000;
 FILE_FLAG_WRITE_THROUGH                = $80000000;
 FILE_FLAG_OVERLAPPED                   = $40000000;
 FILE_FLAG_NO_BUFFERING                 = $20000000;
 FILE_FLAG_RANDOM_ACCESS                = $10000000;

 CREATE_NEW                             = 1;
 CREATE_ALWAYS                          = 2;
 OPEN_EXISTING                          = 3;
 OPEN_ALWAYS                            = 4;
 TRUNCATE_EXISTING                      = 5;

 PROGRESS_CONTINUE                      = 0;
 PROGRESS_CANCEL                        = 1;
 PROGRESS_STOP                          = 2;
 PROGRESS_QUIET                         = 3;

 CALLBACK_CHUNK_FINISHED                = $00000000;
 CALLBACK_STREAM_SWITCH                 = $00000001;

 COPY_FILE_FAIL_IF_EXISTS               = $00000001;
 COPY_FILE_RESTARTABLE                  = $00000002;

 PIPE_ACCESS_INBOUND                    = 1;
 PIPE_ACCESS_OUTBOUND                   = 2;
 PIPE_ACCESS_DUPLEX                     = 3;

 PIPE_CLIENT_END                        = 0;
 PIPE_SERVER_END                        = 1;

 PIPE_WAIT                              = 0;
 PIPE_NOWAIT                            = 1;
 PIPE_READMODE_BYTE                     = 0;
 PIPE_READMODE_MESSAGE                  = 2;
 PIPE_TYPE_BYTE                         = 0;
 PIPE_TYPE_MESSAGE                      = 4;

 PIPE_UNLIMITED_INSTANCES               = $FF;

 SECURITY_ANONYMOUS =                   Ord(SecurityAnonymous) shl 16;
 SECURITY_IDENTIFICATION =              Ord(SecurityIdentification) shl 16;
 SECURITY_IMPERSONATION =               Ord(SecurityImpersonation) shl 16;
 SECURITY_DELEGATION =                  Ord(SecurityDelegation) shl 16;

 SECURITY_CONTEXT_TRACKING              = $40000;
 SECURITY_EFFECTIVE_ONLY                = $80000;

 SECURITY_SQOS_PRESENT                  = $100000;
 SECURITY_VALID_SQOS_FLAGS              = $1F0000;

 MUTEX_MODIFY_STATE                     = MUTANT_QUERY_STATE;
 MUTEX_ALL_ACCESS                       = MUTANT_ALL_ACCESS;

 SP_SERIALCOMM                          = $00000001;

 PST_UNSPECIFIED                        = $00000000;
 PST_RS232                              = $00000001;
 PST_PARALLELPORT                       = $00000002;
 PST_RS422                              = $00000003;
 PST_RS423                              = $00000004;
 PST_RS449                              = $00000005;
 PST_MODEM                              = $00000006;
 PST_FAX                                = $00000021;
 PST_SCANNER                            = $00000022;
 PST_NETWORK_BRIDGE                     = $00000100;
 PST_LAT                                = $00000101;
 PST_TCPIP_TELNET                       = $00000102;
 PST_X25                                = $00000103;

 PCF_DTRDSR                             = $0001;
 PCF_RTSCTS                             = $0002;
 PCF_RLSD                               = $0004;
 PCF_PARITY_CHECK                       = $0008;
 PCF_XONXOFF                            = $0010;
 PCF_SETXCHAR                           = $0020;
 PCF_TOTALTIMEOUTS                      = $0040;
 PCF_INTTIMEOUTS                        = $0080;
 PCF_SPECIALCHARS                       = $0100;
 PCF_16BITMODE                          = $0200;

 SP_PARITY                              = $0001;
 SP_BAUD                                = $0002;
 SP_DATABITS                            = $0004;
 SP_STOPBITS                            = $0008;
 SP_HANDSHAKING                         = $0010;
 SP_PARITY_CHECK                        = $0020;
 SP_RLSD                                = $0040;

 BAUD_075                               = $00000001;
 BAUD_110                               = $00000002;
 BAUD_134_5                             = $00000004;
 BAUD_150                               = $00000008;
 BAUD_300                               = $00000010;
 BAUD_600                               = $00000020;
 BAUD_1200                              = $00000040;
 BAUD_1800                              = $00000080;
 BAUD_2400                              = $00000100;
 BAUD_4800                              = $00000200;
 BAUD_7200                              = $00000400;
 BAUD_9600                              = $00000800;
 BAUD_14400                             = $00001000;
 BAUD_19200                             = $00002000;
 BAUD_38400                             = $00004000;
 BAUD_56K                               = $00008000;
 BAUD_128K                              = $00010000;
 BAUD_115200                            = $00020000;
 BAUD_57600                             = $00040000;
 BAUD_USER                              = $10000000;

 DATABITS_5                             = $0001;
 DATABITS_6                             = $0002;
 DATABITS_7                             = $0004;
 DATABITS_8                             = $0008;
 DATABITS_16                            = $0010;
 DATABITS_16X                           = $0020;

 STOPBITS_10                            = $0001;
 STOPBITS_15                            = $0002;
 STOPBITS_20                            = $0004;
 PARITY_NONE                            = $0100;
 PARITY_ODD                             = $0200;
 PARITY_EVEN                            = $0400;
 PARITY_MARK                            = $0800;
 PARITY_SPACE                           = $1000;

 COMMPROP_INITIALIZED                   = $E73CF52E;

 DTR_CONTROL_DISABLE                    = $00;
 DTR_CONTROL_ENABLE                     = $01;
 DTR_CONTROL_HANDSHAKE                  = $02;

 RTS_CONTROL_DISABLE                    = $00;
 RTS_CONTROL_ENABLE                     = $01;
 RTS_CONTROL_HANDSHAKE                  = $02;
 RTS_CONTROL_TOGGLE                     = $03;

 GMEM_FIXED                             = $0000;
 GMEM_MOVEABLE                          = $0002;
 GMEM_NOCOMPACT                         = $0010;
 GMEM_NODISCARD                         = $0020;
 GMEM_ZEROINIT                          = $0040;
 GMEM_MODIFY                            = $0080;
 GMEM_DISCARDABLE                       = $100;
 GMEM_NOT_BANKED                        = $1000;
 GMEM_SHARE                             = $2000;
 GMEM_DDESHARE                          = $2000;
 GMEM_NOTIFY                            = $4000;
 GMEM_LOWER                             = GMEM_NOT_BANKED;
 GMEM_VALID_FLAGS                       = 32626;
 GMEM_INVALID_HANDLE                    = $8000;

 GHND                                   = GMEM_MOVEABLE or GMEM_ZEROINIT;
 GPTR                                   = GMEM_FIXED or GMEM_ZEROINIT;

 GMEM_DISCARDED                         = $4000;
 GMEM_LOCKCOUNT                         = $00FF;

 LMEM_FIXED                             = $0000;
 LMEM_MOVEABLE                          = $0002;
 LMEM_NOCOMPACT                         = $0010;
 LMEM_NODISCARD                         = $0020;
 LMEM_ZEROINIT                          = $0040;
 LMEM_MODIFY                            = $0080;
 LMEM_DISCARDABLE                       = $0F00;
 LMEM_VALID_FLAGS                       = $0F72;
 LMEM_INVALID_HANDLE                    = $8000;

 LHND = LMEM_MOVEABLE or LMEM_ZEROINIT;
 LPTR = LMEM_FIXED or LMEM_ZEROINIT;

 NONZEROLPTR = LMEM_FIXED;

 LMEM_DISCARDED                  = $4000;
 LMEM_LOCKCOUNT                  = $00FF;

 DEBUG_PROCESS                   = $00000001;
 DEBUG_ONLY_THIS_PROCESS         = $00000002;
 CREATE_SUSPENDED                = $00000004;
 DETACHED_PROCESS                = $00000008;
 CREATE_NEW_CONSOLE              = $00000010;
 NORMAL_PRIORITY_CLASS           = $00000020;
 IDLE_PRIORITY_CLASS             = $00000040;
 HIGH_PRIORITY_CLASS             = $00000080;
 REALTIME_PRIORITY_CLASS         = $00000100;
 CREATE_NEW_PROCESS_GROUP        = $00000200;
 CREATE_UNICODE_ENVIRONMENT      = $00000400;
 CREATE_SEPARATE_WOW_VDM         = $00000800;
 CREATE_SHARED_WOW_VDM           = $00001000;
 CREATE_FORCEDOS                 = $00002000;
 CREATE_DEFAULT_ERROR_MODE       = $04000000;
 CREATE_NO_WINDOW                = $08000000;
 PROFILE_USER                    = $10000000;
 PROFILE_KERNEL                  = $20000000;
 PROFILE_SERVER                  = $40000000;

 THREAD_PRIORITY_LOWEST              = THREAD_BASE_PRIORITY_MIN;
 THREAD_PRIORITY_BELOW_NORMAL        = THREAD_PRIORITY_LOWEST + 1;
 THREAD_PRIORITY_NORMAL              = $00000000;
 THREAD_PRIORITY_HIGHEST             = THREAD_BASE_PRIORITY_MAX;
 THREAD_PRIORITY_ABOVE_NORMAL        = THREAD_PRIORITY_HIGHEST - 1;
 THREAD_PRIORITY_ERROR_RETURN        = MAXLONG;
 THREAD_PRIORITY_TIME_CRITICAL       = THREAD_BASE_PRIORITY_LOWRT;
 THREAD_PRIORITY_IDLE                = THREAD_BASE_PRIORITY_IDLE;

 EXCEPTION_DEBUG_EVENT               = $00000001;
 CREATE_THREAD_DEBUG_EVENT           = $00000002;
 CREATE_PROCESS_DEBUG_EVENT          = $00000003;
 EXIT_THREAD_DEBUG_EVENT             = $00000004;
 EXIT_PROCESS_DEBUG_EVENT            = $00000005;
 LOAD_DLL_DEBUG_EVENT                = $00000006;
 UNLOAD_DLL_DEBUG_EVENT              = $00000007;
 OUTPUT_DEBUG_STRING_EVENT           = $00000008;
 RIP_EVENT                           = $00000009;

 DRIVE_UNKNOWN                       = $00000000;
 DRIVE_NO_ROOT_DIR                   = $00000001;
 DRIVE_REMOVABLE                     = $00000002;
 DRIVE_FIXED                         = $00000003;
 DRIVE_REMOTE                        = $00000004;
 DRIVE_CDROM                         = $00000005;
 DRIVE_RAMDISK                       = $00000006;

 FILE_TYPE_UNKNOWN                   = $00000000;
 FILE_TYPE_DISK                      = $00000001;
 FILE_TYPE_CHAR                      = $00000002;
 FILE_TYPE_PIPE                      = $00000003;
 FILE_TYPE_REMOTE                    = $00008000;

 STD_INPUT_HANDLE                    = $FFFFFFF6;
 STD_OUTPUT_HANDLE                   = $FFFFFFF5;
 STD_ERROR_HANDLE                    = $FFFFFFF4;

 NOPARITY                            = $00000000;
 ODDPARITY                           = $00000001;
 EVENPARITY                          = $00000002;
 MARKPARITY                          = $00000003;
 SPACEPARITY                         = $00000004;

 ONESTOPBIT                          = $00000000;
 ONE5STOPBITS                        = $00000001;
 TWOSTOPBITS                         = $00000002;

 IGNORE                              = $00000000;
 INFINITE                            = $FFFFFFFF;

 CBR_110                             = 000110;
 CBR_300                             = 000300;
 CBR_600                             = 000600;
 CBR_1200                            = 001200;
 CBR_2400                            = 002400;
 CBR_4800                            = 004800;
 CBR_9600                            = 009600;
 CBR_14400                           = 014400;
 CBR_19200                           = 019200;
 CBR_38400                           = 038400;
 CBR_56000                           = 056000;
 CBR_57600                           = 057600;
 CBR_115200                          = 115200;
 CBR_128000                          = 128000;
 CBR_256000                          = 256000;

 CE_RXOVER                           = $00000001;
 CE_OVERRUN                          = $00000002;
 CE_RXPARITY                         = $00000004;
 CE_FRAME                            = $00000008;
 CE_BREAK                            = $00000010;
 CE_TXFULL                           = $00000100;
 CE_PTO                              = $00000200;
 CE_IOE                              = $00000400;
 CE_DNS                              = $00000800;
 CE_OOP                              = $00001000;
 CE_MODE                             = $00008000;

 IE_BADID                            = -1;
 IE_OPEN                             = -2;
 IE_NOPEN                            = -3;
 IE_MEMORY                           = -4;
 IE_DEFAULT                          = -5;
 IE_HARDWARE                         = -10;
 IE_BYTESIZE                         = -11;
 IE_BAUDRATE                         = -12;

 EV_RXCHAR                           = $00000001;
 EV_RXFLAG                           = $00000002;
 EV_TXEMPTY                          = $00000004;
 EV_CTS                              = $00000008;
 EV_DSR                              = $00000010;
 EV_RLSD                             = $00000020;
 EV_BREAK                            = $00000040;
 EV_ERR                              = $00000080;
 EV_RING                             = $00000100;
 EV_PERR                             = $00000200;
 EV_RX80FULL                         = $00000400;
 EV_EVENT1                           = $00000800;
 EV_EVENT2                           = $00001000;

 SETXOFF                             = 1;
 SETXON                              = 2;
 SETRTS                              = 3;
 CLRRTS                              = 4;
 SETDTR                              = 5;
 CLRDTR                              = 6;
 RESETDEV                            = 7;
 SETBREAK                            = 8;
 CLRBREAK                            = 9;

 PURGE_TXABORT                       = 1;
 PURGE_RXABORT                       = 2;
 PURGE_TXCLEAR                       = 4;
 PURGE_RXCLEAR                       = 8;

 WM_CTLCOLORMSGBOX                   = $0132;
 WM_CTLCOLOREDIT                     = $0133;
 WM_CTLCOLORLISTBOX                  = $0134;
 WM_CTLCOLORBTN                      = $0135;
 WM_CTLCOLORDLG                      = $0136;
 WM_CTLCOLORSCROLLBAR                = $0137;
 WM_CTLCOLORSTATIC                   = $0138;

 LPTx                                = $80;

 MS_CTS_ON                           = $00000010;
 MS_DSR_ON                           = $00000020;
 MS_RING_ON                          = $00000040;
 MS_RLSD_ON                          = $00000080;

 S_QUEUEEMPTY     = 0;
 S_THRESHOLD      = 1;
 S_ALLTHRESHOLD   = 2;

 S_NORMAL         = 0;
 S_LEGATO         = 1;
 S_STACCATO       = 2;

 S_PERIOD512      = 0;
 S_PERIOD1024     = 1;
 S_PERIOD2048     = 2;
 S_PERIODVOICE    = 3;
 S_WHITE512       = 4;
 S_WHITE1024      = 5;
 S_WHITE2048      = 6;
 S_WHITEVOICE     = 7;

 S_SERDVNA        = -1;
 S_SEROFM         = -2;
 S_SERMACT        = -3;
 S_SERQFUL        = -4;
 S_SERBDNT        = -5;
 S_SERDLN         = -6;
 S_SERDCC         = -7;
 S_SERDTP         = -8;
 S_SERDVL         = -9;
 S_SERDMD         = -10;
 S_SERDSH         = -11;
 S_SERDPT         = -12;
 S_SERDFQ         = -13;
 S_SERDDR         = -14;
 S_SERDSR         = -15;
 S_SERDST         = -16;

 NMPWAIT_WAIT_FOREVER     = $FFFFFFFF;
 NMPWAIT_NOWAIT           = $00000001;
 NMPWAIT_USE_DEFAULT_WAIT = $00000000;

 FS_CASE_IS_PRESERVED      = FILE_CASE_PRESERVED_NAMES;
 FS_CASE_SENSITIVE         = FILE_CASE_SENSITIVE_SEARCH;
 FS_UNICODE_STORED_ON_DISK = FILE_UNICODE_ON_DISK;
 FS_PERSISTENT_ACLS        = FILE_PERSISTENT_ACLS;
 FS_VOL_IS_COMPRESSED      = FILE_VOLUME_IS_COMPRESSED;
 FS_FILE_COMPRESSION       = FILE_FILE_COMPRESSION;

 FILE_MAP_COPY       = SECTION_QUERY;
 FILE_MAP_WRITE      = SECTION_MAP_WRITE;
 FILE_MAP_READ       = SECTION_MAP_READ;
 FILE_MAP_ALL_ACCESS = SECTION_ALL_ACCESS;

 OF_READ             = $0000;
 OF_WRITE            = $0001;
 OF_READWRITE        = $0002;
 OF_SHARE_COMPAT     = $0000;
 OF_SHARE_EXCLUSIVE  = $0010;
 OF_SHARE_DENY_WRITE = $0020;
 OF_SHARE_DENY_READ  = $0030;
 OF_SHARE_DENY_NONE  = $0040;
 OF_PARSE            = $0100;
 OF_DELETE           = $0200;
 OF_VERIFY           = $0400;
 OF_CANCEL           = $0800;
 OF_CREATE           = $1000;
 OF_PROMPT           = $2000;
 OF_EXIST            = $4000;
 OF_REOPEN           = $8000;

 OFS_MAXPATHNAME = $0080;
 MAXINTATOM      = $C000;
 INVALID_ATOM    = $0000;

 PROCESS_HEAP_REGION            = $01;
 PROCESS_HEAP_UNCOMMITTED_RANGE = $02;
 PROCESS_HEAP_ENTRY_BUSY        = $04;
 PROCESS_HEAP_ENTRY_MOVEABLE    = $10;
 PROCESS_HEAP_ENTRY_DDESHARE    = $20;

 SCS_32BIT_BINARY               = $00;
 SCS_DOS_BINARY                 = $01;
 SCS_WOW_BINARY                 = $02;
 SCS_PIF_BINARY                 = $03;
 SCS_POSIX_BINARY               = $04;
 SCS_OS216_BINARY               = $05;

 SEM_FAILCRITICALERRORS         = $0001;
 SEM_NOGPFAULTERRORBOX          = $0002;
 SEM_NOALIGNMENTFAULTEXCEPT     = $0004;
 SEM_NOOPENFILEERRORBOX         = $8000;

 LOCKFILE_FAIL_IMMEDIATELY      = 1;
 LOCKFILE_EXCLUSIVE_LOCK        = 2;

 HANDLE_FLAG_INHERIT            = $01;
 HANDLE_FLAG_PROTECT_FROM_CLOSE = $02;
 HINSTANCE_ERROR                = $20;

 GET_TAPE_MEDIA_INFORMATION     = 0;
 GET_TAPE_DRIVE_INFORMATION     = 1;

 SET_TAPE_MEDIA_INFORMATION     = 0;
 SET_TAPE_DRIVE_INFORMATION     = 1;

 TLS_OUT_OF_INDEXES             = $FFFFFFFF;

 BACKUP_INVALID                 = 0;
 BACKUP_DATA                    = 1;
 BACKUP_EA_DATA                 = 2;
 BACKUP_SECURITY_DATA           = 3;
 BACKUP_ALTERNATE_DATA          = 4;
 BACKUP_LINK                    = 5;
 BACKUP_PROPERTY_DATA           = 6;

 STREAM_NORMAL_ATTRIBUTE        = 0;
 STREAM_MODIFIED_WHEN_READ      = 1;
 STREAM_CONTAINS_SECURITY       = 2;
 STREAM_CONTAINS_PROPERTIES     = 4;

 STARTF_USESHOWWINDOW           = $0001;
 STARTF_USESIZE                 = $0002;
 STARTF_USEPOSITION             = $0004;
 STARTF_USECOUNTCHARS           = $0008;
 STARTF_USEFILLATTRIBUTE        = $0010;
 STARTF_RUNFULLSCREEN           = $0020;
 STARTF_FORCEONFEEDBACK         = $0040;
 STARTF_FORCEOFFFEEDBACK        = $0080;
 STARTF_USESTDHANDLES           = $0100;
 STARTF_USEHOTKEY               = $0200;

 SHUTDOWN_NORETRY               = 1;

 DONT_RESOLVE_DLL_REFERENCES    = 1;
 LOAD_LIBRARY_AS_DATAFILE       = 2;
 LOAD_WITH_ALTERED_SEARCH_PATH  = 8;

 DDD_RAW_TARGET_PATH            = $00000001;
 DDD_REMOVE_DEFINITION          = $00000002;
 DDD_EXACT_MATCH_ON_REMOVE      = $00000004;
 DDD_NO_BROADCAST_SYSTEM        = $00000008;

 FIND_FIRST_EX_CASE_SENSITIVE   = $00000001;

 MOVEFILE_REPLACE_EXISTING      = $00000001;
 MOVEFILE_COPY_ALLOWED          = $00000002;
 MOVEFILE_DELAY_UNTIL_REBOOT    = $00000004;
 MOVEFILE_WRITE_THROUGH         = $00000008;

 MAX_COMPUTERNAME_LENGTH        = 15;

 LOGON32_LOGON_INTERACTIVE      = 2;
 LOGON32_LOGON_NETWORK          = 3;
 LOGON32_LOGON_BATCH            = 4;
 LOGON32_LOGON_SERVICE          = 5;

 LOGON32_PROVIDER_DEFAULT       = 0;
 LOGON32_PROVIDER_WINNT35       = 1;
 LOGON32_PROVIDER_WINNT40       = 2;

 HW_PROFILE_GUIDLEN             = 39;
 MAX_PROFILE_LEN                = 80;

 DOCKINFO_UNDOCKED              = 1;
 DOCKINFO_DOCKED                = 2;
 DOCKINFO_USER_SUPPLIED         = 4;
 DOCKINFO_USER_UNDOCKED         = DOCKINFO_USER_SUPPLIED or DOCKINFO_UNDOCKED;
 DOCKINFO_USER_DOCKED           = DOCKINFO_USER_SUPPLIED or DOCKINFO_DOCKED;

 VER_PLATFORM_WIN32s            = 0;
 VER_PLATFORM_WIN32_WINDOWS     = 1;
 VER_PLATFORM_WIN32_NT          = 2;

 FACILITY_NULL                  = 0;
 FACILITY_RPC                   = 1;
 FACILITY_DISPATCH              = 2;
 FACILITY_STORAGE               = 3;
 FACILITY_ITF                   = 4;
 FACILITY_SSPI                  = 9;
 FACILITY_WIN32                 = 7;
 FACILITY_WINDOWS               = 8;
 FACILITY_CONTROL               = 10;
 FACILITY_CERT                  = 11;
 FACILITY_INTERNET              = 12;
 FACILITY_NT_BIT                = $10000000;

 SEVERITY_SUCCESS               = 0;
 SEVERITY_ERROR                 = 1;

 S_OK                           = $00000000;
 S_FALSE                        = $00000001;

 NOERROR                        = $00000000;

 E_UNEXPECTED                   = HResult($8000FFFF);
 E_NOTIMPL                      = HResult($80004001);
 E_OUTOFMEMORY                  = HResult($8007000E);
 E_INVALIDARG                   = HResult($80070057);
 E_NOINTERFACE                  = HResult($80004002);
 E_POINTER                      = HResult($80004003);
 E_HANDLE                       = HResult($80070006);
 E_ABORT                        = HResult($80004004);
 E_FAIL                         = HResult($80004005);
 E_ACCESSDENIED                 = HResult($80070005);
 E_PENDING                      = HResult($8000000A);

 CO_E_INIT_TLS                     = HResult($80004006);
 CO_E_INIT_SHARED_ALLOCATOR        = HResult($80004007);
 CO_E_INIT_MEMORY_ALLOCATOR        = HResult($80004008);
 CO_E_INIT_CLASS_CACHE             = HResult($80004009);
 CO_E_INIT_RPC_CHANNEL             = HResult($8000400A);
 CO_E_INIT_TLS_SET_CHANNEL_CONTRO  = HResult($8000400B);
 CO_E_INIT_TLS_CHANNEL_CONTROL     = HResult($8000400C);
 CO_E_INIT_UNACCEPTED_USER_ALLOCA  = HResult($8000400D);
 CO_E_INIT_SCM_MUTEX_EXISTS        = HResult($8000400E);
 CO_E_INIT_SCM_FILE_MAPPING_EXIST  = HResult($8000400F);
 CO_E_INIT_SCM_MAP_VIEW_OF_FILE    = HResult($80004010);
 CO_E_INIT_SCM_EXEC_FAILURE        = HResult($80004011);
 CO_E_INIT_ONLY_SINGLE_THREADED    = HResult($80004012);
 CO_E_CANT_REMOTE                  = HResult($80004013);
 CO_E_BAD_SERVER_NAME              = HResult($80004014);
 CO_E_WRONG_SERVER_IDENTITY        = HResult($80004015);
 CO_E_OLE1DDE_DISABLED             = HResult($80004016);
 CO_E_RUNAS_SYNTAX                 = HResult($80004017);
 CO_E_CREATEPROCESS_FAILURE        = HResult($80004018);
 CO_E_RUNAS_CREATEPROCESS_FAILURE  = HResult($80004019);
 CO_E_RUNAS_LOGON_FAILURE          = HResult($8000401A);
 CO_E_LAUNCH_PERMSSION_DENIED      = HResult($8000401B);
 CO_E_START_SERVICE_FAILURE        = HResult($8000401C);
 CO_E_REMOTE_COMMUNICATION_FAILURE = HResult($8000401D);
 CO_E_SERVER_START_TIMEOUT         = HResult($8000401E);
 CO_E_CLSREG_INCONSISTENT          = HResult($8000401F);
 CO_E_IIDREG_INCONSISTENT          = HResult($80004020);
 CO_E_NOT_SUPPORTED                = HResult($80004021);

 OLE_E_FIRST                       = HResult($80040000);
 OLE_E_LAST                        = HResult($800400FF);
 OLE_S_FIRST                       = $40000;
 OLE_S_LAST                        = $400FF;
 OLE_S_USEREG                      = $40000;
 OLE_S_STATIC                      = $40001;
 OLE_S_MAC_CLIPFORMAT              = $40002;

 OLE_E_OLEVERB                     = HResult($80040000);
 OLE_E_ADVF                        = HResult($80040001);
 OLE_E_ENUM_NOMORE                 = HResult($80040002);
 OLE_E_ADVISENOTSUPPORTED          = HResult($80040003);
 OLE_E_NOCONNECTION                = HResult($80040004);
 OLE_E_NOTRUNNING                  = HResult($80040005);
 OLE_E_NOCACHE                     = HResult($80040006);
 OLE_E_BLANK                       = HResult($80040007);
 OLE_E_CLASSDIFF                   = HResult($80040008);
 OLE_E_CANT_GETMONIKER             = HResult($80040009);
 OLE_E_CANT_BINDTOSOURCE           = HResult($8004000A);
 OLE_E_STATIC                      = HResult($8004000B);
 OLE_E_PROMPTSAVECANCELLED         = HResult($8004000C);
 OLE_E_INVALIDRECT                 = HResult($8004000D);
 OLE_E_WRONGCOMPOBJ                = HResult($8004000E);
 OLE_E_INVALIDHWND                 = HResult($8004000F);
 OLE_E_NOT_INPLACEACTIVE           = HResult($80040010);
 OLE_E_CANTCONVERT                 = HResult($80040011);
 OLE_E_NOSTORAGE                   = HResult($80040012);

 DV_E_FORMATETC                    = HResult($80040064);
 DV_E_DVTARGETDEVICE               = HResult($80040065);
 DV_E_STGMEDIUM                    = HResult($80040066);
 DV_E_STATDATA                     = HResult($80040067);
 DV_E_LINDEX                       = HResult($80040068);
 DV_E_TYMED                        = HResult($80040069);
 DV_E_CLIPFORMAT                   = HResult($8004006A);
 DV_E_DVASPECT                     = HResult($8004006B);
 DV_E_DVTARGETDEVICE_SIZE          = HResult($8004006C);
 DV_E_NOIVIEWOBJECT                = HResult($8004006D);

 DRAGDROP_E_FIRST                  = HResult($80040100);
 DRAGDROP_E_LAST                   = HResult($8004010F);
 DRAGDROP_S_FIRST                  = $40100;
 DRAGDROP_E_NOTREGISTERED          = HResult($80040100);
 DRAGDROP_E_ALREADYREGISTERED      = HResult($80040101);
 DRAGDROP_E_INVALIDHWND            = HResult($80040102);
 DRAGDROP_S_DROP                   = $40100;
 DRAGDROP_S_CANCEL                 = $40101;
 DRAGDROP_S_USEDEFAULTCURSORS      = $40102;

 CLASSFACTORY_E_FIRST              = HResult($80040110);
 CLASSFACTORY_E_LAST               = HResult($8004011F);
 CLASSFACTORY_S_FIRST              = $40110;

 CLASS_E_NOAGGREGATION             = HResult($80040110);
 CLASS_E_CLASSNOTAVAILABLE         = HResult($80040111);

 MARSHAL_E_FIRST = HResult($80040120);
 MARSHAL_E_LAST  = HResult($8004012F);
 MARSHAL_S_FIRST = $40120;
 MARSHAL_S_LAST  = $4012F;

 DATA_E_FIRST    = HResult($80040130);
 DATA_E_LAST     = HResult($8004013F);
 DATA_S_FIRST    = $40130;
 DATA_S_LAST     = $4013F;

 VIEW_E_FIRST    = HResult($80040140);
 VIEW_E_LAST     = HResult($8004014F);
 VIEW_S_FIRST    = $40140;
 VIEW_E_DRAW     = HResult($80040140);

 REGDB_E_FIRST        = HResult($80040150);
 REGDB_E_LAST         = HResult($8004015F);
 REGDB_S_FIRST        = $40150;
 REGDB_E_READREGDB    = HResult($80040150);
 REGDB_E_WRITEREGDB   = HResult($80040151);
 REGDB_E_KEYMISSING   = HResult($80040152);
 REGDB_E_INVALIDVALUE = HResult($80040153);
 REGDB_E_CLASSNOTREG  = HResult($80040154);
 REGDB_E_IIDNOTREG    = HResult($80040155);

 CACHE_E_FIRST                  = HResult($80040170);
 CACHE_E_LAST                   = HResult($8004017F);
 CACHE_S_FIRST                  = $40170;
 CACHE_E_NOCACHE_UPDATED        = HResult($80040170);
 CACHE_S_FORMATETC_NOTSUPPORTED = $40170;
 CACHE_S_SAMECACHE              = $40171;
 CACHE_S_SOMECACHES_NOTUPDATED  = $40172;

 OLEOBJ_E_FIRST                 = HResult($80040180);
 OLEOBJ_E_LAST                  = HResult($8004018F);
 OLEOBJ_S_FIRST                 = $40180;
 OLEOBJ_E_NOVERBS               = HResult($80040180);
 OLEOBJ_E_INVALIDVERB           = HResult($80040181);

 CLIENTSITE_E_FIRST = HResult($80040190);
 CLIENTSITE_E_LAST  = HResult($8004019F);
 CLIENTSITE_S_FIRST = $40190;

 INPLACE_E_NOTUNDOABLE = HResult($800401A0);
 INPLACE_E_NOTOOLSPACE = HResult($800401A1);

 INPLACE_E_FIRST = HResult($800401A0);
 INPLACE_E_LAST  = HResult($800401AF);
 INPLACE_S_FIRST = $401A0;
 INPLACE_S_LAST  = $401AF;

 ENUM_E_FIRST = HResult($800401B0);
 ENUM_E_LAST  = HResult($800401BF);
 ENUM_S_FIRST = $401B0;
 ENUM_S_LAST  = $401BF;

 CONVERT10_E_FIRST                = HResult($800401C0);
 CONVERT10_E_LAST                 = HResult($800401CF);
 CONVERT10_S_FIRST                = $401C0;
 CONVERT10_E_OLESTREAM_GET        = HResult($800401C0);
 CONVERT10_E_OLESTREAM_PUT        = HResult($800401C1);
 CONVERT10_E_OLESTREAM_FMT        = HResult($800401C2);
 CONVERT10_E_OLESTREAM_BITMAP_TO  = HResult($800401C3);
 CONVERT10_E_STG_FMT              = HResult($800401C4);
 CONVERT10_E_STG_NO_STD_STREAM    = HResult($800401C5);
 CONVERT10_E_STG_DIB_TO_BITMAP    = HResult($800401C6);
 CONVERT10_S_NO_PRESENTATION      = $401C0;

 CLIPBRD_E_FIRST                  = HResult($800401D0);
 CLIPBRD_E_LAST                   = HResult($800401DF);
 CLIPBRD_S_FIRST                  = $401D0;
 CLIPBRD_E_CANT_OPEN              = HResult($800401D0);
 CLIPBRD_E_CANT_EMPTY             = HResult($800401D1);
 CLIPBRD_E_CANT_SET               = HResult($800401D2);
 CLIPBRD_E_BAD_DATA               = HResult($800401D3);
 CLIPBRD_E_CANT_CLOSE             = HResult($800401D4);

 MK_E_FIRST                       = HResult($800401E0);
 MK_E_LAST                        = HResult($800401EF);
 MK_S_FIRST                       = $401E0;
 MK_E_CONNECTMANUALLY             = HResult($800401E0);
 MK_E_EXCEEDEDDEADLINE            = HResult($800401E1);
 MK_E_NEEDGENERIC                 = HResult($800401E2);
 MK_E_UNAVAILABLE                 = HResult($800401E3);
 MK_E_SYNTAX                      = HResult($800401E4);
 MK_E_NOOBJECT                    = HResult($800401E5);
 MK_E_INVALIDEXTENSION            = HResult($800401E6);
 MK_E_INTERMEDIATEINTERFACENOTSUP = HResult($800401E7);
 MK_E_NOTBINDABLE                 = HResult($800401E8);
 MK_E_NOTBOUND                    = HResult($800401E9);
 MK_E_CANTOPENFILE                = HResult($800401EA);
 MK_E_MUSTBOTHERUSER              = HResult($800401EB);
 MK_E_NOINVERSE                   = HResult($800401EC);
 MK_E_NOSTORAGE                   = HResult($800401ED);
 MK_E_NOPREFIX                    = HResult($800401EE);
 MK_E_ENUMERATION_FAILED          = HResult($800401EF);
 MK_S_REDUCED_TO_SELF             = $000401E2;
 MK_S_ME                          = $000401E4;
 MK_S_HIM                         = $000401E5;
 MK_S_US                          = $000401E6;
 MK_S_MONIKERALREADYREGISTERED    = $000401E7;
 MK_E_NO_NORMALIZED               = HResult($80080007);

 CO_E_FIRST                       = HResult($800401F0);
 CO_E_LAST                        = HResult($800401FF);
 CO_S_FIRST                       = $401F0;
 CO_E_NOTINITIALIZED              = HResult($800401F0);
 CO_E_ALREADYINITIALIZED          = HResult($800401F1);
 CO_E_CANTDETERMINECLASS          = HResult($800401F2);
 CO_E_CLASSSTRING                 = HResult($800401F3);
 CO_E_IIDSTRING                   = HResult($800401F4);
 CO_E_APPNOTFOUND                 = HResult($800401F5);
 CO_E_APPSINGLEUSE                = HResult($800401F6);
 CO_E_ERRORINAPP                  = HResult($800401F7);
 CO_E_DLLNOTFOUND                 = HResult($800401F8);
 CO_E_ERRORINDLL                  = HResult($800401F9);
 CO_E_WRONGOSFORAPP               = HResult($800401FA);
 CO_E_OBJNOTREG                   = HResult($800401FB);
 CO_E_OBJISREG                    = HResult($800401FC);
 CO_E_OBJNOTCONNECTED             = HResult($800401FD);
 CO_E_APPDIDNTREG                 = HResult($800401FE);
 CO_E_RELEASED                    = HResult($800401FF);
 CO_E_CLASS_CREATE_FAILED         = HResult($80080001);
 CO_E_SCM_ERROR                   = HResult($80080002);
 CO_E_SCM_RPC_FAILURE             = HResult($80080003);
 CO_E_BAD_PATH                    = HResult($80080004);
 CO_E_SERVER_EXEC_FAILURE         = HResult($80080005);
 CO_E_OBJSRV_RPC_FAILURE          = HResult($80080006);
 CO_E_SERVER_STOPPING             = HResult($80080008);
 CO_S_NOTALLINTERFACES            = HResult($00080012);


 DATA_S_SAMEFORMATETC             = $40130;
 VIEW_S_ALREADY_FROZEN            = $40140;

 OLEOBJ_S_INVALIDVERB             = $40180;
 OLEOBJ_S_CANNOT_DOVERB_NOW       = $40181;
 OLEOBJ_S_INVALIDHWND             = $40182;

 INPLACE_S_TRUNCATED              = $401A0;

 MEM_E_INVALID_ROOT = HResult($80080009);
 MEM_E_INVALID_LINK = HResult($80080010);
 MEM_E_INVALID_SIZE = HResult($80080011);

 DISP_E_UNKNOWNINTERFACE = HResult($80020001);
 DISP_E_MEMBERNOTFOUND   = HResult($80020003);
 DISP_E_PARAMNOTFOUND    = HResult($80020004);
 DISP_E_TYPEMISMATCH     = HResult($80020005);
 DISP_E_UNKNOWNNAME      = HResult($80020006);
 DISP_E_NONAMEDARGS      = HResult($80020007);
 DISP_E_BADVARTYPE       = HResult($80020008);
 DISP_E_EXCEPTION        = HResult($80020009);
 DISP_E_OVERFLOW         = HResult($8002000A);
 DISP_E_BADINDEX         = HResult($8002000B);
 DISP_E_UNKNOWNLCID      = HResult($8002000C);
 DISP_E_ARRAYISLOCKED    = HResult($8002000D);
 DISP_E_BADPARAMCOUNT    = HResult($8002000E);
 DISP_E_PARAMNOTOPTIONAL = HResult($8002000F);
 DISP_E_BADCALLEE        = HResult($80020010);
 DISP_E_NOTACOLLECTION   = HResult($80020011);

 TYPE_E_BUFFERTOOSMALL          = HResult($80028016);
 TYPE_E_INVDATAREAD             = HResult($80028018);
 TYPE_E_UNSUPFORMAT             = HResult($80028019);
 TYPE_E_REGISTRYACCESS          = HResult($8002801C);
 TYPE_E_LIBNOTREGISTERED        = HResult($8002801D);
 TYPE_E_UNDEFINEDTYPE           = HResult($80028027);
 TYPE_E_QUALIFIEDNAMEDISALLOWED = HResult($80028028);
 TYPE_E_INVALIDSTATE            = HResult($80028029);
 TYPE_E_WRONGTYPEKIND           = HResult($8002802A);
 TYPE_E_ELEMENTNOTFOUND         = HResult($8002802B);
 TYPE_E_AMBIGUOUSNAME           = HResult($8002802C);
 TYPE_E_NAMECONFLICT            = HResult($8002802D);
 TYPE_E_UNKNOWNLCID             = HResult($8002802E);
 TYPE_E_DLLFUNCTIONNOTFOUND     = HResult($8002802F);
 TYPE_E_BADMODULEKIND           = HResult($800288BD);
 TYPE_E_SIZETOOBIG              = HResult($800288C5);
 TYPE_E_DUPLICATEID             = HResult($800288C6);
 TYPE_E_INVALIDID               = HResult($800288CF);
 TYPE_E_TYPEMISMATCH            = HResult($80028CA0);
 TYPE_E_OUTOFBOUNDS             = HResult($80028CA1);
 TYPE_E_IOERROR                 = HResult($80028CA2);
 TYPE_E_CANTCREATETMPFILE       = HResult($80028CA3);
 TYPE_E_CANTLOADLIBRARY         = HResult($80029C4A);
 TYPE_E_INCONSISTENTPROPFUNCS   = HResult($80029C83);
 TYPE_E_CIRCULARTYPE            = HResult($80029C84);

 STG_E_INVALIDFUNCTION            = HResult($80030001);
 STG_E_FILENOTFOUND               = HResult($80030002);
 STG_E_PATHNOTFOUND               = HResult($80030003);
 STG_E_TOOMANYOPENFILES           = HResult($80030004);
 STG_E_ACCESSDENIED               = HResult($80030005);
 STG_E_INVALIDHANDLE              = HResult($80030006);
 STG_E_INSUFFICIENTMEMORY         = HResult($80030008);
 STG_E_INVALIDPOINTER             = HResult($80030009);
 STG_E_NOMOREFILES                = HResult($80030012);
 STG_E_DISKISWRITEPROTECTED       = HResult($80030013);
 STG_E_SEEKERROR                  = HResult($80030019);
 STG_E_WRITEFAULT                 = HResult($8003001D);
 STG_E_READFAULT                  = HResult($8003001E);
 STG_E_SHAREVIOLATION             = HResult($80030020);
 STG_E_LOCKVIOLATION              = HResult($80030021);
 STG_E_FILEALREADYEXISTS          = HResult($80030050);
 STG_E_INVALIDPARAMETER           = HResult($80030057);
 STG_E_MEDIUMFULL                 = HResult($80030070);
 STG_E_PROPSETMISMATCHED          = HResult($800300F0);
 STG_E_ABNORMALAPIEXIT            = HResult($800300FA);
 STG_E_INVALIDHEADER              = HResult($800300FB);
 STG_E_INVALIDNAME                = HResult($800300FC);
 STG_E_UNKNOWN                    = HResult($800300FD);
 STG_E_UNIMPLEMENTEDFUNCTION      = HResult($800300FE);
 STG_E_INVALIDFLAG                = HResult($800300FF);
 STG_E_INUSE                      = HResult($80030100);
 STG_E_NOTCURRENT                 = HResult($80030101);
 STG_E_REVERTED                   = HResult($80030102);
 STG_E_CANTSAVE                   = HResult($80030103);
 STG_E_OLDFORMAT                  = HResult($80030104);
 STG_E_OLDDLL                     = HResult($80030105);
 STG_E_SHAREREQUIRED              = HResult($80030106);
 STG_E_NOTFILEBASEDSTORAGE        = HResult($80030107);
 STG_E_EXTANTMARSHALLINGS         = HResult($80030108);
 STG_E_DOCFILECORRUPT             = HResult($80030109);
 STG_E_BADBASEADDRESS             = HResult($80030110);
 STG_E_INCOMPLETE                 = HResult($80030201);
 STG_E_TERMINATED                 = HResult($80030202);
 STG_S_CONVERTED                  = $00030200;
 STG_S_BLOCK                      = $00030201;
 STG_S_RETRYNOW                   = $00030202;
 STG_S_MONITORING                 = $00030203;

 RPC_E_CALL_REJECTED              = HResult($80010001);
 RPC_E_CALL_CANCELED              = HResult($80010002);
 RPC_E_CANTPOST_INSENDCALL        = HResult($80010003);
 RPC_E_CANTCALLOUT_INASYNCCALL    = HResult($80010004);
 RPC_E_CANTCALLOUT_INEXTERNALCALL = HResult($80010005);
 RPC_E_CONNECTION_TERMINATED      = HResult($80010006);
 RPC_E_SERVER_DIED                = HResult($80010007);
 RPC_E_CLIENT_DIED                = HResult($80010008);
 RPC_E_INVALID_DATAPACKET         = HResult($80010009);
 RPC_E_CANTTRANSMIT_CALL          = HResult($8001000A);
 RPC_E_CLIENT_CANTMARSHAL_DATA    = HResult($8001000B);
 RPC_E_CLIENT_CANTUNMARSHAL_DATA  = HResult($8001000C);
 RPC_E_SERVER_CANTMARSHAL_DATA    = HResult($8001000D);
 RPC_E_SERVER_CANTUNMARSHAL_DATA  = HResult($8001000E);
 RPC_E_INVALID_DATA               = HResult($8001000F);
 RPC_E_INVALID_PARAMETER          = HResult($80010010);
 RPC_E_CANTCALLOUT_AGAIN          = HResult($80010011);
 RPC_E_SERVER_DIED_DNE            = HResult($80010012);
 RPC_E_SYS_CALL_FAILED            = HResult($80010100);
 RPC_E_OUT_OF_RESOURCES           = HResult($80010101);
 RPC_E_ATTEMPTED_MULTITHREAD      = HResult($80010102);
 RPC_E_NOT_REGISTERED             = HResult($80010103);
 RPC_E_FAULT                      = HResult($80010104);
 RPC_E_SERVERFAULT                = HResult($80010105);
 RPC_E_CHANGED_MODE               = HResult($80010106);
 RPC_E_INVALIDMETHOD              = HResult($80010107);
 RPC_E_DISCONNECTED               = HResult($80010108);
 RPC_E_RETRY                      = HResult($80010109);
 RPC_E_SERVERCALL_RETRYLATER      = HResult($8001010A);
 RPC_E_SERVERCALL_REJECTED        = HResult($8001010B);
 RPC_E_INVALID_CALLDATA           = HResult($8001010C);
 RPC_E_CANTCALLOUT_ININPUTSYNCCAL = HResult($8001010D);
 RPC_E_WRONG_THREAD               = HResult($8001010E);
 RPC_E_THREAD_NOT_INIT            = HResult($8001010F);
 RPC_E_VERSION_MISMATCH           = HResult($80010110);
 RPC_E_INVALID_HEADER             = HResult($80010111);
 RPC_E_INVALID_EXTENSION          = HResult($80010112);
 RPC_E_INVALID_IPID               = HResult($80010113);
 RPC_E_INVALID_OBJECT             = HResult($80010114);
 RPC_S_CALLPENDING                = HResult($80010115);
 RPC_S_WAITONTIMER                = HResult($80010116);
 RPC_E_CALL_COMPLETE              = HResult($80010117);
 RPC_E_UNSECURE_CALL              = HResult($80010118);
 RPC_E_TOO_LATE                   = HResult($80010119);
 RPC_E_NO_GOOD_SECURITY_PACKAGES  = HResult($8001011A);
 RPC_E_ACCESS_DENIED              = HResult($8001011B);
 RPC_E_REMOTE_DISABLED            = HResult($8001011C);
 RPC_E_INVALID_OBJREF             = HResult($8001011D);
 RPC_E_UNEXPECTED                 = HResult($8001FFFF);

 NTE_BAD_UID                      = HResult($80090001);
 NTE_BAD_HASH                     = HResult($80090002);
 NTE_BAD_KEY                      = HResult($80090003);
 NTE_BAD_LEN                      = HResult($80090004);
 NTE_BAD_DATA                     = HResult($80090005);
 NTE_BAD_SIGNATURE                = HResult($80090006);
 NTE_BAD_VER                      = HResult($80090007);
 NTE_BAD_ALGID                    = HResult($80090008);
 NTE_BAD_FLAGS                    = HResult($80090009);
 NTE_BAD_TYPE                     = HResult($8009000A);
 NTE_BAD_KEY_STATE                = HResult($8009000B);
 NTE_BAD_HASH_STATE               = HResult($8009000C);
 NTE_NO_KEY                       = HResult($8009000D);
 NTE_NO_MEMORY                    = HResult($8009000E);
 NTE_EXISTS                       = HResult($8009000F);
 NTE_PERM                         = HResult($80090010);
 NTE_NOT_FOUND                    = HResult($80090011);
 NTE_DOUBLE_ENCRYPT               = HResult($80090012);
 NTE_BAD_PROVIDER                 = HResult($80090013);
 NTE_BAD_PROV_TYPE                = HResult($80090014);
 NTE_BAD_PUBLIC_KEY               = HResult($80090015);
 NTE_BAD_KEYSET                   = HResult($80090016);
 NTE_PROV_TYPE_NOT_DEF            = HResult($80090017);
 NTE_PROV_TYPE_ENTRY_BAD          = HResult($80090018);
 NTE_KEYSET_NOT_DEF               = HResult($80090019);
 NTE_KEYSET_ENTRY_BAD             = HResult($8009001A);
 NTE_PROV_TYPE_NO_MATCH           = HResult($8009001B);
 NTE_SIGNATURE_FILE_BAD           = HResult($8009001C);
 NTE_PROVIDER_DLL_FAIL            = HResult($8009001D);
 NTE_PROV_DLL_NOT_FOUND           = HResult($8009001E);
 NTE_BAD_KEYSET_PARAM             = HResult($8009001F);
 NTE_FAIL                         = HResult($80090020);
 NTE_SYS_ERR                      = HResult($80090021);
 NTE_OP_OK                        = HResult($00000000);

 TRUST_E_PROVIDER_UNKNOWN         = HResult($800B0001);
 TRUST_E_ACTION_UNKNOWN           = HResult($800B0002);
 TRUST_E_SUBJECT_FORM_UNKNOWN     = HResult($800B0003);
 TRUST_E_SUBJECT_NOT_TRUSTED      = HResult($800B0004);
 TRUST_E_NOSIGNATURE              = HResult($800B0100);

 DIGSIG_E_ENCODE                  = HResult($800B0005);
 DIGSIG_E_DECODE                  = HResult($800B0006);
 DIGSIG_E_EXTENSIBILITY           = HResult($800B0007);
 DIGSIG_E_CRYPTO                  = HResult($800B0008);

 PERSIST_E_SIZEDEFINITE           = HResult($800B0009);
 PERSIST_E_SIZEINDEFINITE         = HResult($800B000A);
 PERSIST_E_NOTSELFSIZING          = HResult($800B000B);

 CERT_E_EXPIRED                   = HResult($800B0101);
 CERT_E_VALIDIYPERIODNESTING      = HResult($800B0102);
 CERT_E_ROLE                      = HResult($800B0103);
 CERT_E_PATHLENCONST              = HResult($800B0104);
 CERT_E_CRITICAL                  = HResult($800B0105);
 CERT_E_PURPOSE                   = HResult($800B0106);
 CERT_E_ISSUERCHAINING            = HResult($800B0107);
 CERT_E_MALFORMED                 = HResult($800B0108);
 CERT_E_UNTRUSTEDROOT             = HResult($800B0109);
 CERT_E_CHAINING                  = HResult($800B010A);

 TC_NORMAL      = 0;
 TC_HARDERR     = 1;
 TC_GP_TRAP     = 2;
 TC_SIGNAL      = 3;

 AC_LINE_OFFLINE      = 0;
 AC_LINE_ONLINE       = 1;
 AC_LINE_BACKUP_POWER = 2;
 AC_LINE_UNKNOWN      = 255;

 BATTERY_FLAG_HIGH          = 1;
 BATTERY_FLAG_LOW           = 2;
 BATTERY_FLAG_CRITICAL      = 4;
 BATTERY_FLAG_CHARGING      = 8;
 BATTERY_FLAG_NO_BATTERY    = 128;
 BATTERY_FLAG_UNKNOWN       = 255;
 BATTERY_PERCENTAGE_UNKNOWN = 255;
 BATTERY_LIFE_UNKNOWN       = $FFFFFFFF;

 WIN_CERT_REVISION_1_0          = $0100;
 WIN_CERT_TYPE_X509             = $0001;
 WIN_CERT_TYPE_PKCS_SIGNED_DATA = $0002;
 WIN_CERT_TYPE_RESERVED_1       = $0003;

 R2_BLACK       = 1;
 R2_NOTMERGEPEN = 2;
 R2_MASKNOTPEN  = 3;
 R2_NOTCOPYPEN  = 4;
 R2_MASKPENNOT  = 5;
 R2_NOT         = 6;
 R2_XORPEN      = 7;
 R2_NOTMASKPEN  = 8;
 R2_MASKPEN     = 9;
 R2_NOTXORPEN   = 10;
 R2_NOP         = 11;
 R2_MERGENOTPEN = 12;
 R2_COPYPEN     = 13;
 R2_MERGEPENNOT = 14;
 R2_MERGEPEN    = 15;
 R2_WHITE       = 16;
 R2_LAST        = 16;

 SRCCOPY     = $00CC0020;
 SRCPAINT    = $00EE0086;
 SRCAND      = $008800C6;
 SRCINVERT   = $00660046;
 SRCERASE    = $00440328;
 NOTSRCCOPY  = $00330008;
 NOTSRCERASE = $001100A6;
 MERGECOPY   = $00C000CA;
 MERGEPAINT  = $00BB0226;
 PATCOPY     = $00F00021;
 PATPAINT    = $00FB0A09;
 PATINVERT   = $005A0049;
 DSTINVERT   = $00550009;
 BLACKNESS   = $00000042;
 WHITENESS   = $00FF0062;

 GDI_ERROR   = $FFFFFFFF;
 HGDI_ERROR  = $FFFFFFFF;

 ERROR         = 0;
 NULLREGION    = 1;
 SIMPLEREGION  = 2;
 COMPLEXREGION = 3;
 RGN_ERROR     = 0;

 RGN_AND       = 1;
 RGN_OR        = 2;
 RGN_XOR       = 3;
 RGN_DIFF      = 4;
 RGN_COPY      = 5;
 RGN_MIN       = RGN_AND;
 RGN_MAX       = RGN_COPY;

 BLACKONWHITE      = 1;
 WHITEONBLACK      = 2;
 COLORONCOLOR      = 3;
 HALFTONE          = 4;
 MAXSTRETCHBLTMODE = 4;

 STRETCH_ANDSCANS    = BLACKONWHITE;
 STRETCH_ORSCANS     = WHITEONBLACK;
 STRETCH_DELETESCANS = COLORONCOLOR;
 STRETCH_HALFTONE    = HALFTONE;

 ALTERNATE           = 1;
 WINDING             = 2;
 POLYFILL_LAST       = 2;

 TA_NOUPDATECP       = $0000;
 TA_UPDATECP         = $0001;
 TA_LEFT             = $0000;
 TA_RIGHT            = $0002;
 TA_CENTER           = $0006;
 TA_TOP              = $0000;
 TA_BOTTOM           = $0008;
 TA_BASELINE         = $0024;
 TA_RTLREADING       = $0100;
 TA_MASK             = TA_BASELINE+TA_CENTER+TA_UPDATECP+TA_RTLREADING;

 VTA_BASELINE   = TA_BASELINE;
 VTA_LEFT       = TA_BOTTOM;
 VTA_RIGHT      = TA_TOP;
 VTA_CENTER     = TA_CENTER;
 VTA_BOTTOM     = TA_RIGHT;
 VTA_TOP        = TA_LEFT;

 ASPECT_FILTERING    = 1;

 ETO_OPAQUE          = $0002;
 ETO_CLIPPED         = $0004;
 ETO_GLYPH_INDEX     = $0010;
 ETO_RTLREADING      = $0080;
 ETO_IGNORELANGUAGE  = $1000;

 DCB_RESET           = 1;
 DCB_ACCUMULATE      = 2;
 DCB_DIRTY           = DCB_ACCUMULATE;
 DCB_SET             = DCB_RESET or DCB_ACCUMULATE;
 DCB_ENABLE          = 4;
 DCB_DISABLE         = 8;

 META_SETBKCOLOR            = 513;
 META_SETBKMODE             = 258;
 META_SETMAPMODE            = 259;
 META_SETROP2               = 260;
 META_SETRELABS             = 261;
 META_SETPOLYFILLMODE       = 262;
 META_SETSTRETCHBLTMODE     = 263;
 META_SETTEXTCHAREXTRA      = 264;
 META_SETTEXTCOLOR          = 521;
 META_SETTEXTJUSTIFICATION  = 522;
 META_SETWINDOWORG          = 523;
 META_SETWINDOWEXT          = 524;
 META_SETVIEWPORTORG        = 525;
 META_SETVIEWPORTEXT        = 526;
 META_OFFSETWINDOWORG       = 527;
 META_SCALEWINDOWEXT        = 1040;
 META_OFFSETVIEWPORTORG     = 529;
 META_SCALEVIEWPORTEXT      = 1042;
 META_LINETO                = 531;
 META_MOVETO                = 532;
 META_EXCLUDECLIPRECT       = 1045;
 META_INTERSECTCLIPRECT     = 1046;
 META_ARC                   = 2071;
 META_ELLIPSE               = 1048;
 META_FLOODFILL             = 1049;
 META_PIE                   = 2074;
 META_RECTANGLE             = 1051;
 META_ROUNDRECT             = 1564;
 META_PATBLT                = 1565;
 META_SAVEDC                = 30;
 META_SETPIXEL              = 1055;
 META_OFFSETCLIPRGN         = 544;
 META_TEXTOUT               = 1313;
 META_BITBLT                = 2338;
 META_STRETCHBLT            = 2851;
 META_POLYGON               = 804;
 META_POLYLINE              = 805;
 META_ESCAPE                = 1574;
 META_RESTOREDC             = 295;
 META_FILLREGION            = 552;
 META_FRAMEREGION           = 1065;
 META_INVERTREGION          = 298;
 META_PAINTREGION           = 299;
 META_SELECTCLIPREGION      = 300;
 META_SELECTOBJECT          = 301;
 META_SETTEXTALIGN          = 302;
 META_CHORD                 = 2096;
 META_SETMAPPERFLAGS        = 561;
 META_EXTTEXTOUT            = 2610;
 META_SETDIBTODEV           = 3379;
 META_SELECTPALETTE         = 564;
 META_REALIZEPALETTE        = 53;
 META_ANIMATEPALETTE        = 1078;
 META_SETPALENTRIES         = 55;
 META_POLYPOLYGON           = 1336;
 META_RESIZEPALETTE         = 313;
 META_DIBBITBLT             = 2368;
 META_DIBSTRETCHBLT         = 2881;
 META_DIBCREATEPATTERNBRUSH = 322;
 META_STRETCHDIB            = 3907;
 META_EXTFLOODFILL          = 1352;
 META_DELETEOBJECT          = 496;
 META_CREATEPALETTE         = 247;
 META_CREATEPATTERNBRUSH    = 505;
 META_CREATEPENINDIRECT     = 762;
 META_CREATEFONTINDIRECT    = 763;
 META_CREATEBRUSHINDIRECT   = 764;
 META_CREATEREGION          = 1791;

 NEWFRAME                   = 1;
 ABORT_DOC                  = 2;
 NEXTBAND                   = 3;
 SETCOLORTABLE              = 4;
 GETCOLORTABLE              = 5;
 FLUSHOUTPUT                = 6;
 DRAFTMODE                  = 7;
 QUERYESCSUPPORT            = 8;
 SET_ABORTPROC              = 9;
 START_DOC                  = 10;
 END_DOC                    = 11;
 GETPHYSPAGESIZE            = 12;
 GETPRINTINGOFFSET          = 13;
 GETSCALINGFACTOR           = 14;
 MFCOMMENT                  = 15;
 GETPENWIDTH                = 16;
 SETCOPYCOUNT               = 17;
 SELECTPAPERSOURCE          = 18;
 DEVICEDATA                 = 19;
 PASSTHROUGH                = 19;
 GETTECHNOLGY               = 20;
 GETTECHNOLOGY              = 20;
 SETLINECAP                 = 21;
 SETLINEJOIN                = 22;
 SE_TMITERLIMIT             = 23;
 BANDINFO                   = 24;
 DRAWPATTERNRECT            = 25;
 GETVECTORPENSIZE           = 26;
 GETVECTORBRUSHSIZE         = 27;
 ENABLEDUPLEX               = 28;
 GETSETPAPERBINS            = 29;
 GETSETPRINTORIENT          = 30;
 ENUMPAPERBINS              = 31;
 SETDIBSCALING              = 32;
 EPSPRINTING                = 33;
 ENUMPAPERMETRICS           = 34;
 GETSETPAPERMETRICS         = 35;
 POSTSCRIPT_DATA            = 37;
 POSTSCRIPT_IGNORE          = 38;
 MOUSETRAILS                = 39;
 GETDEVICEUNITS             = 42;

 GETEXTENDEDTEXTMETRICS     = 256;
 GETEXTENTTABLE             = 257;
 GETPAIRKERNTABLE           = 258;
 GETTRACKKERNTABLE          = 259;
 EXTTEXT_OUT                = 512;
 GETFACENAME                = 513;
 DOWNLOADFACE               = 514;
 ENABLERELATIVEWIDTHS       = 768;
 ENABLEPAIRKERNING          = 769;
 SETKERNTRACK               = 770;
 SETALLJUSTVALUES           = 771;
 SETCHARSET                 = 772;

 STRETCH_BLT                = 2048;
 GETSETSCREENPARAMS         = 3072;
 QUERYDIBSUPPORT            = 3073;
 BEGIN_PATH                 = 4096;
 CLIP_TO_PATH               = 4097;
 END_PATH                   = 4098;
 EXT_DEVICE_CAPS            = 4099;
 RESTORE_CTM                = 4100;
 SAVE_CTM                   = 4101;
 SET_ARC_DIRECTION          = 4102;
 SET_BACKGROUND_COLOR       = 4103;
 SET_POLY_MODE              = 4104;
 SET_SCREEN_ANGLE           = 4105;
 SET_SPREAD                 = 4106;
 TRANSFORM_CTM              = 4107;
 SET_CLIP_BOX               = 4108;
 SET_BOUNDS                 = 4109;
 SET_MIRROR_MODE            = 4110;
 OPENCHANNEL                = 4110;
 DOWNLOADHEADER             = 4111;
 CLOSECHANNEL               = 4112;
 POSTSCRIPT_PASSTHROUGH     = 4115;
 ENCAPSULATED_POSTSCRIPT    = 4116;

 QDI_SETDIBITS              = 1;
 QDI_GETDIBITS              = 2;
 QDI_DIBTOSCREEN            = 4;
 QDI_STRETCHDIB             = 8;

 SP_NOTREPORTED             = 16384;
 SP_ERROR                   = -1;
 SP_APPABORT                = -2;
 SP_USERABORT               = -3;
 SP_OUTOFDISK               = -4;
 SP_OUTOFMEMORY             = -5;

 PR_JOBSTATUS               = 0;

 OBJ_PEN                    = 1;
 OBJ_BRUSH                  = 2;
 OBJ_DC                     = 3;
 OBJ_METADC                 = 4;
 OBJ_PAL                    = 5;
 OBJ_FONT                   = 6;
 OBJ_BITMAP                 = 7;
 OBJ_REGION                 = 8;
 OBJ_METAFILE               = 9;
 OBJ_MEMDC                  = 10;
 OBJ_EXTPEN                 = 11;
 OBJ_ENHMETADC              = 12;
 OBJ_ENHMETAFILE            = 13;

 MWT_IDENTITY               = 1;
 MWT_LEFTMULTIPLY           = 2;
 MWT_RIGHTMULTIPLY          = 3;
 MWT_MIN                    = MWT_IDENTITY;
 MWT_MAX                    = MWT_RIGHTMULTIPLY;

 LCS_CALIBRATED_RGB         = 0;
 LCS_DEVICE_RGB             = 1;
 LCS_DEVICE_CMYK            = 2;
 LCS_GM_BUSINESS            = 1;
 LCS_GM_GRAPHICS            = 2;
 LCS_GM_IMAGES              = 4;

 CM_OUT_OF_GAMUT = 255;
 CM_IN_GAMUT     = 0;

 BI_RGB       = 0;
 BI_RLE8      = 1;
 BI_RLE4      = 2;
 BI_BITFIELDS = 3;

 TCI_SRCCHARSET  = 1;
 TCI_SRCCODEPAGE = 2;
 TCI_SRCFONTSIG  = 3;

 TMPF_FIXED_PITCH = 1;
 TMPF_VECTOR      = 2;
 TMPF_TRUETYPE    = 4;
 TMPF_DEVICE      = 8;

 NTM_ITALIC       = 1;
 NTM_BOLD         = 32;
 NTM_REGULAR      = 64;

 LF_FACESIZE     = 32;
 LF_FULLFACESIZE = 64;

 OUT_DEFAULT_PRECIS        = 0;
 OUT_STRING_PRECIS         = 1;
 OUT_CHARACTER_PRECIS      = 2;
 OUT_STROKE_PRECIS         = 3;
 OUT_TT_PRECIS             = 4;
 OUT_DEVICE_PRECIS         = 5;
 OUT_RASTER_PRECIS         = 6;
 OUT_TT_ONLY_PRECIS        = 7;
 OUT_OUTLINE_PRECIS        = 8;
 OUT_SCREEN_OUTLINE_PRECIS = 9;

 CLIP_DEFAULT_PRECIS   = 0;
 CLIP_CHARACTER_PRECIS = 1;
 CLIP_STROKE_PRECIS    = 2;
 CLIP_MASK             = 15;
 CLIP_LH_ANGLES        = 1 shl 4;
 CLIP_TT_ALWAYS        = 2 shl 4;
 CLIP_EMBEDDED         = 8 shl 4;

 DEFAULT_QUALITY        = 0;
 DRAFT_QUALITY          = 1;
 PROOF_QUALITY          = 2;
 NONANTIALIASED_QUALITY = 3;
 ANTIALIASED_QUALITY    = 4;

 DEFAULT_PITCH  = 0;
 FIXED_PITCH    = 1;
 VARIABLE_PITCH = 2;
 MONO_FONT      = 8;

 ANSI_CHARSET        = 0;
 DEFAULT_CHARSET     = 1;
 SYMBOL_CHARSET      = 2;
 SHIFTJIS_CHARSET    = 128;
 HANGEUL_CHARSET     = 129;
 GB2312_CHARSET      = 134;
 CHINESEBIG5_CHARSET = 136;
 OEM_CHARSET         = 255;
 JOHAB_CHARSET       = 130;
 HEBREW_CHARSET      = 177;
 ARABIC_CHARSET      = 178;
 GREEK_CHARSET       = 161;
 TURKISH_CHARSET     = 162;
 VIETNAMESE_CHARSET  = 163;
 THAI_CHARSET        = 222;
 EASTEUROPE_CHARSET  = 238;
 RUSSIAN_CHARSET     = 204;

 MAC_CHARSET    = 77;
 BALTIC_CHARSET = 186;

 FS_LATIN1      = $00000001;
 FS_LATIN2      = $00000002;
 FS_CYRILLIC    = $00000004;
 FS_GREEK       = $00000008;
 FS_TURKISH     = $00000010;
 FS_HEBREW      = $00000020;
 FS_ARABIC      = $00000040;
 FS_BALTIC      = $00000080;
 FS_VIETNAMESE  = $00000100;
 FS_THAI        = $00010000;
 FS_JISJAPAN    = $00020000;
 FS_CHINESESIMP = $00040000;
 FS_WANSUNG     = $00080000;
 FS_CHINESETRAD = $00100000;
 FS_JOHAB       = $00200000;
 FS_SYMBOL      = $80000000;

 FF_DONTCARE   = 0 shl 4;
 FF_ROMAN      = 1 shl 4;
 FF_SWISS      = 2 shl 4;
 FF_MODERN     = 3 shl 4;
 FF_SCRIPT     = 4 shl 4;
 FF_DECORATIVE = 5 shl 4;

 FW_DONTCARE   = 0;
 FW_THIN       = 100;
 FW_EXTRALIGHT = 200;
 FW_LIGHT      = 300;
 FW_NORMAL     = 400;
 FW_MEDIUM     = 500;
 FW_SEMIBOLD   = 600;
 FW_BOLD       = 700;
 FW_EXTRABOLD  = 800;
 FW_HEAVY      = 900;
 FW_ULTRALIGHT = FW_EXTRALIGHT;
 FW_REGULAR    = FW_NORMAL;
 FW_DEMIBOLD   = FW_SEMIBOLD;
 FW_ULTRABOLD  = FW_EXTRABOLD;
 FW_BLACK      = FW_HEAVY;

 PANOSE_COUNT              = 10;
 PAN_FAMILYTYPE_INDEX      = 0;
 PAN_SERIFSTYLE_INDEX      = 1;
 PAN_WEIGHT_INDEX          = 2;
 PAN_PROPORTION_INDEX      = 3;
 PAN_CONTRAST_INDEX        = 4;
 PAN_STROKEVARIATION_INDEX = 5;
 PAN_ARMSTYLE_INDEX        = 6;
 PAN_LETTERFORM_INDEX      = 7;
 PAN_MIDLINE_INDEX         = 8;
 PAN_XHEIGHT_INDEX         = 9;

 PAN_CULTURE_LATIN              = 0;
 PAN_ANY                        = 0;
 PAN_NO_FIT                     = 1;
 PAN_FAMILY_TEXT_DISPLAY        = 2;
 PAN_FAMILY_SCRIPT              = 3;
 PAN_FAMILY_DECORATIVE          = 4;
 PAN_FAMILY_PICTORIAL           = 5;
 PAN_SERIF_COVE                 = 2;
 PAN_SERIF_OBTUSE_COVE          = 3;
 PAN_SERIF_SQUARE_COVE          = 4;
 PAN_SERIF_OBTUSE_SQUARE_COVE   = 5;
 PAN_SERIF_SQUARE               = 6;
 PAN_SERIF_THIN                 = 7;
 PAN_SERIF_BONE                 = 8;
 PAN_SERIF_EXAGGERATED          = 9;
 PAN_SERIF_TRIANGLE             = 10;
 PAN_SERIF_NORMAL_SANS          = 11;
 PAN_SERIF_OBTUSE_SANS          = 12;
 PAN_SERIF_PERP_SANS            = 13;
 PAN_SERIF_FLARED               = 14;
 PAN_SERIF_ROUNDED              = 15;
 PAN_WEIGHT_VERY_LIGHT          = 2;
 PAN_WEIGHT_LIGHT               = 3;
 PAN_WEIGHT_THIN                = 4;
 PAN_WEIGHT_BOOK                = 5;
 PAN_WEIGHT_MEDIUM              = 6;
 PAN_WEIGHT_DEMI                = 7;
 PAN_WEIGHT_BOLD                = 8;
 PAN_WEIGHT_HEAVY               = 9;
 PAN_WEIGHT_BLACK               = 10;
 PAN_WEIGHT_NORD                = 11;
 PAN_PROP_OLD_STYLE             = 2;
 PAN_PROP_MODERN                = 3;
 PAN_PROP_EVEN_WIDTH            = 4;
 PAN_PROP_EXPANDED              = 5;
 PAN_PROP_CONDENSED             = 6;
 PAN_PROP_VERY_EXPANDED         = 7;
 PAN_PROP_VERY_CONDENSED        = 8;
 PAN_PROP_MONOSPACED            = 9;
 PAN_CONTRAST_NONE              = 2;
 PAN_CONTRAST_VERY_LOW          = 3;
 PAN_CONTRAST_LOW               = 4;
 PAN_CONTRAST_MEDIUM_LOW        = 5;
 PAN_CONTRAST_MEDIUM            = 6;
 PAN_CONTRAST_MEDIUM_HIGH       = 7;
 PAN_CONTRAST_HIGH              = 8;
 PAN_CONTRAST_VERY_HIGH         = 9;
 PAN_STROKE_GRADUAL_DIAG        = 2;
 PAN_STROKE_GRADUAL_TRAN        = 3;
 PAN_STROKE_GRADUAL_VERT        = 4;
 PAN_STROKE_GRADUAL_HORZ        = 5;
 PAN_STROKE_RAPID_VERT          = 6;
 PAN_STROKE_RAPID_HORZ          = 7;
 PAN_STROKE_INSTANT_VERT        = 8;
 PAN_STRAIGHT_ARMS_HORZ         = 2;
 PAN_STRAIGHT_ARMS_WEDGE        = 3;
 PAN_STRAIGHT_ARMS_VERT         = 4;
 PAN_STRAIGHT_ARMS_SINGLE_SERIF = 5;
 PAN_STRAIGHT_ARMS_DOUBLE_SERIF = 6;
 PAN_BENT_ARMS_HORZ             = 7;
 PAN_BENT_ARMS_WEDGE            = 8;
 PAN_BENT_ARMS_VERT             = 9;
 PAN_BENT_ARMS_SINGLE_SERIF     = 10;
 PAN_BENT_ARMS_DOUBLE_SERIF     = 11;
 PAN_LETT_NORMAL_CONTACT        = 2;
 PAN_LETT_NORMAL_WEIGHTED       = 3;
 PAN_LETT_NORMAL_BOXED          = 4;
 PAN_LETT_NORMAL_FLATTENED      = 5;
 PAN_LETT_NORMAL_ROUNDED        = 6;
 PAN_LETT_NORMAL_OFF_CENTER     = 7;
 PAN_LETT_NORMAL_SQUARE         = 8;
 PAN_LETT_OBLIQUE_CONTACT       = 9;
 PAN_LETT_OBLIQUE_WEIGHTED      = 10;
 PAN_LETT_OBLIQUE_BOXED         = 11;
 PAN_LETT_OBLIQUE_FLATTENED     = 12;
 PAN_LETT_OBLIQUE_ROUNDED       = 13;
 PAN_LETT_OBLIQUE_OFF_CENTER    = 14;
 PAN_LETT_OBLIQUE_SQUARE        = 15;
 PAN_MIDLINE_STANDARD_TRIMMED   = 2;
 PAN_MIDLINE_STANDARD_POINTED   = 3;
 PAN_MIDLINE_STANDARD_SERIFED   = 4;
 PAN_MIDLINE_HIGH_TRIMMED       = 5;
 PAN_MIDLINE_HIGH_POINTED       = 6;
 PAN_MIDLINE_HIGH_SERIFED       = 7;
 PAN_MIDLINE_CONSTANT_TRIMMED   = 8;
 PAN_MIDLINE_CONSTANT_POINTED   = 9;
 PAN_MIDLINE_CONSTANT_SERIFED   = 10;
 PAN_MIDLINE_LOW_TRIMMED        = 11;
 PAN_MIDLINE_LOW_POINTED        = 12;
 PAN_MIDLINE_LOW_SERIFED        = 13;
 PAN_XHEIGHT_CONSTANT_SMALL     = 2;
 PAN_XHEIGHT_CONSTANT_STD       = 3;
 PAN_XHEIGHT_CONSTANT_LARGE     = 4;
 PAN_XHEIGHT_DUCKING_SMALL      = 5;
 PAN_XHEIGHT_DUCKING_STD        = 6;
 PAN_XHEIGHT_DUCKING_LARGE      = 7;

 ELF_VENDOR_SIZE   = 4;
 ELF_VERSION       = 0;
 ELF_CULTURE_LATIN = 0;

 RASTER_FONTTYPE   = 1;
 DEVICE_FONTTYPE   = 2;
 TRUETYPE_FONTTYPE = 4;

 PC_RESERVED   = 1;
 PC_EXPLICIT   = 2;
 PC_NOCOLLAPSE = 4;

 TRANSPARENT = 1;
 OPAQUE      = 2;
 BKMODE_LAST = 2;

 GM_COMPATIBLE = 1;
 GM_ADVANCED   = 2;
 GM_LAST       = 2;

 PT_CLOSEFIGURE = 1;
 PT_LINETO      = 2;
 PT_BEZIERTO    = 4;
 PT_MOVETO      = 6;

 MM_TEXT        = 1;
 MM_LOMETRIC    = 2;
 MM_HIMETRIC    = 3;
 MM_LOENGLISH   = 4;
 MM_HIENGLISH   = 5;
 MM_TWIPS       = 6;
 MM_ISOTROPIC   = 7;
 MM_ANISOTROPIC = 8;

 MM_MIN            = MM_TEXT;
 MM_MAX            = MM_ANISOTROPIC;
 MM_MAX_FIXEDSCALE = MM_TWIPS;

 ABSOLUTE = 1;
 RELATIVE = 2;

 WHITE_BRUSH         = 0;
 LTGRAY_BRUSH        = 1;
 GRAY_BRUSH          = 2;
 DKGRAY_BRUSH        = 3;
 BLACK_BRUSH         = 4;
 NULL_BRUSH          = 5;
 HOLLOW_BRUSH        = 5;
 WHITE_PEN           = 6;
 BLACK_PEN           = 7;
 NULL_PEN            = 8;
 OEM_FIXED_FONT      = 10;
 ANSI_FIXED_FONT     = 11;
 ANSI_VAR_FONT       = 12;
 SYSTEM_FONT         = 13;
 DEVICE_DEFAULT_FONT = 14;
 DEFAULT_PALETTE     = 15;
 SYSTEM_FIXED_FONT   = 16;
 DEFAULT_GUI_FONT    = 17;
 STOCK_LAST          = 17;

 CLR_INVALID         = $FFFFFFFF;

 BS_SOLID                = 0;
 BS_NULL                 = 1;
 BS_HOLLOW               = BS_NULL;
 BS_HATCHED              = 2;
 BS_PATTERN              = 3;
 BS_INDEXED              = 4;
 BS_DIBPATTERN           = 5;
 BS_DIBPATTERNPT         = 6;
 BS_PATTERN8X8           = 7;
 BS_DIBPATTERN8X8        = 8;
 BS_MONOPATTERN          = 9;

 HS_HORIZONTAL = 0;
 HS_VERTICAL   = 1;
 HS_FDIAGONAL  = 2;
 HS_BDIAGONAL  = 3;
 HS_CROSS      = 4;
 HS_DIAGCROSS  = 5;

 PS_SOLID       = 0;
 PS_DASH        = 1;
 PS_DOT         = 2;
 PS_DASHDOT     = 3;
 PS_DASHDOTDOT  = 4;
 PS_NULL        = 5;
 PS_INSIDEFRAME = 6;
 PS_USERSTYLE   = 7;
 PS_ALTERNATE   = 8;
 PS_STYLE_MASK  = 15;

 PS_ENDCAP_ROUND  = $00000;
 PS_ENDCAP_SQUARE = $00100;
 PS_ENDCAP_FLAT   = $00200;
 PS_ENDCAP_MASK   = $00F00;
 PS_JOIN_ROUND    = $00000;
 PS_JOIN_BEVEL    = $01000;
 PS_JOIN_MITER    = $02000;
 PS_JOIN_MASK     = $0F000;
 PS_COSMETIC      = $00000;
 PS_GEOMETRIC     = $10000;
 PS_TYPE_MASK     = $F0000;

 AD_COUNTERCLOCKWISE = 1;
 AD_CLOCKWISE        = 2;

 DRIVERVERSION   = 0;
 TECHNOLOGY      = 2;
 HORZSIZE        = 4;
 VERTSIZE        = 6;
 HORZRES         = 8;
 VERTRES         = 10;
 BITSPIXEL       = 12;
 PLANES          = 14;
 NUMBRUSHES      = 16;
 NUMPENS         = 18;
 NUMMARKERS      = 20;
 NUMFONTS        = 22;
 NUMCOLORS       = 24;
 PDEVICESIZE     = 26;
 CURVECAPS       = 28;
 LINECAPS        = 30;
 POLYGONALCAPS   = 32;
 TEXTCAPS        = 34;
 CLIPCAPS        = 36;
 RASTERCAPS      = 38;
 ASPECTX         = 40;
 ASPECTY         = 42;
 ASPECTXY        = 44;
 LOGPIXELSX      = 88;
 LOGPIXELSY      = 90;
 SIZEPALETTE     = 104;
 NUMRESERVED     = 106;
 COLORRES        = 108;
 PHYSICALWIDTH   = 110;
 PHYSICALHEIGHT  = 111;
 PHYSICALOFFSETX = 112;
 PHYSICALOFFSETY = 113;
 SCALINGFACTORX  = 114;
 SCALINGFACTORY  = 115;
 VREFRESH        = 116;
 DESKTOPVERTRES  = 117;
 DESKTOPHORZRES  = 118;
 BLTALIGNMENT    = 119;

 DT_PLOTTER    = 0;
 DT_RASDISPLAY = 1;
 DT_RASPRINTER = 2;
 DT_RASCAMERA  = 3;
 DT_CHARSTREAM = 4;
 DT_METAFILE   = 5;
 DT_DISPFILE   = 6;

 CC_NONE       = $0000;
 CC_CIRCLES    = $0001;
 CC_PIE        = $0002;
 CC_CHORD      = $0004;
 CC_ELLIPSES   = $0008;
 CC_WIDE       = $0010;
 CC_STYLED     = $0020;
 CC_WIDESTYLED = $0040;
 CC_INTERIORS  = $0080;
 CC_ROUNDRECT  = $0100;

 LC_NONE       = $00;
 LC_POLYLINE   = $02;
 LC_MARKER     = $04;
 LC_POLYMARKER = $08;
 LC_WIDE       = $10;
 LC_STYLED     = $20;
 LC_WIDESTYLED = $40;
 LC_INTERIORS  = $80;

 PC_NONE        = 0;
 PC_POLYGON     = 1;
 PC_RECTANGLE   = 2;
 PC_WINDPOLYGON = 4;
 PC_TRAPEZOID   = 4;
 PC_SCANLINE    = 8;
 PC_WIDE        = $10;
 PC_STYLED      = $20;
 PC_WIDESTYLED  = $40;
 PC_INTERIORS   = $80;
 PC_POLYPOLYGON = $100;
 PC_PATHS       = $200;

 CP_NONE      = 0;
 CP_RECTANGLE = 1;
 CP_REGION    = 2;

 TC_OP_CHARACTER = $0001;
 TC_OP_STROKE    = $0002;
 TC_CP_STROKE    = $0004;
 TC_CR_90        = $0008;
 TC_CR_ANY       = $0010;
 TC_SF_X_YINDEP  = $0020;
 TC_SA_DOUBLE    = $0040;
 TC_SA_INTEGER   = $0080;
 TC_SA_CONTIN    = $0100;
 TC_EA_DOUBLE    = $0200;
 TC_IA_ABLE      = $0400;
 TC_UA_ABLE      = $0800;
 TC_SO_ABLE      = $1000;
 TC_RA_ABLE      = $2000;
 TC_VA_ABLE      = $4000;
 TC_RESERVED     = $8000;
 TC_SCROLLBLT    = $10000;

 RC_BITBLT       = $0001;
 RC_BANDING      = $0002;
 RC_SCALING      = $0004;
 RC_BITMAP64     = $0008;
 RC_GDI20_OUTPUT = $0010;
 RC_GDI20_STATE  = $0020;
 RC_SAVEBITMAP   = $0040;
 RC_DI_BITMAP    = $0080;
 RC_PALETTE      = $0100;
 RC_DIBTODEV     = $0200;
 RC_BIGFONT      = $0400;
 RC_STRETCHBLT   = $0800;
 RC_FLOODFILL    = $1000;
 RC_STRETCHDIB   = $2000;
 RC_OP_DX_OUTPUT = $4000;
 RC_DEVBITS      = $8000;

 DIB_RGB_COLORS = 0;
 DIB_PAL_COLORS = 1;

 SYSPAL_ERROR     = 0;
 SYSPAL_STATIC    = 1;
 SYSPAL_NOSTATIC  = 2;

 CBM_INIT         = 4;

 FLOODFILLBORDER  = 0;
 FLOODFILLSURFACE = 1;

 CCHDEVICENAME    = 32;
 CCHFORMNAME      = 32;

 DM_SPECVERSION      = $0401;
 DM_ORIENTATION      = $0001;
 DM_PAPERSIZE        = $0002;
 DM_PAPERLENGTH      = $0004;
 DM_PAPERWIDTH       = $0008;
 DM_SCALE            = $0010;
 DM_COPIES           = $0100;
 DM_DEFAULTSOURCE    = $0200;
 DM_PRINTQUALITY     = $0400;
 DM_COLOR            = $0800;
 DM_DUPLEX           = $1000;
 DM_YRESOLUTION      = $2000;
 DM_TTOPTION         = $4000;
 DM_COLLATE          = $8000;
 DM_FORMNAME         = $10000;
 DM_LOGPIXELS        = $20000;
 DM_BITSPERPEL       = $40000;
 DM_PELSWIDTH        = $80000;
 DM_PELSHEIGHT       = $100000;
 DM_DISPLAYFLAGS     = $200000;
 DM_DISPLAYFREQUENCY = $400000;
 DM_PANNINGWIDTH     = $00800000;
 DM_PANNINGHEIGHT    = $01000000;
 DM_ICMMETHOD        = $2000000;
 DM_ICMINTENT        = $4000000;
 DM_MEDIATYPE        = $8000000;
 DM_DITHERTYPE       = $10000000;
 DM_ICCMANUFACTURER  = $20000000;
 DM_ICCMODEL         = $40000000;

 DMORIENT_PORTRAIT                      = 1;
 DMORIENT_LANDSCAPE                     = 2;
 DMPAPER_LETTER                         = 1;
 DMPAPER_FIRST                          = DMPAPER_LETTER;
 DMPAPER_LETTERSMALL                    = 2;
 DMPAPER_TABLOID                        = 3;
 DMPAPER_LEDGER                         = 4;
 DMPAPER_LEGAL                          = 5;
 DMPAPER_STATEMENT                      = 6;
 DMPAPER_EXECUTIVE                      = 7;
 DMPAPER_A3                             = 8;
 DMPAPER_A4                             = 9;
 DMPAPER_A4SMALL                        = 10;
 DMPAPER_A5                             = 11;
 DMPAPER_B4                             = 12;
 DMPAPER_B5                             = 13;
 DMPAPER_FOLIO                          = 14;
 DMPAPER_QUARTO                         = 15;
 DMPAPER_10X14                          = 16;
 DMPAPER_11X17                          = 17;
 DMPAPER_NOTE                           = 18;
 DMPAPER_ENV_9                          = 19;
 DMPAPER_ENV_10                         = 20;
 DMPAPER_ENV_11                         = 21;
 DMPAPER_ENV_12                         = 22;
 DMPAPER_ENV_14                         = 23;
 DMPAPER_CSHEET                         = 24;
 DMPAPER_DSHEET                         = 25;
 DMPAPER_ESHEET                         = 26;
 DMPAPER_ENV_DL                         = 27;
 DMPAPER_ENV_C5                         = 28;
 DMPAPER_ENV_C3                         = 29;
 DMPAPER_ENV_C4                         = 30;
 DMPAPER_ENV_C6                         = 31;
 DMPAPER_ENV_C65                        = 32;
 DMPAPER_ENV_B4                         = 33;
 DMPAPER_ENV_B5                         = 34;
 DMPAPER_ENV_B6                         = 35;
 DMPAPER_ENV_ITALY                      = 36;
 DMPAPER_ENV_MONARCH                    = 37;
 DMPAPER_ENV_PERSONAL                   = 38;
 DMPAPER_FANFOLD_US                     = 39;
 DMPAPER_FANFOLD_STD_GERMAN             = 40;
 DMPAPER_FANFOLD_LGL_GERMAN             = 41;
 DMPAPER_ISO_B4                         = 42;
 DMPAPER_JAPANESE_POSTCARD              = 43;
 DMPAPER_9X11                           = 44;
 DMPAPER_10X11                          = 45;
 DMPAPER_15X11                          = 46;
 DMPAPER_ENV_INVITE                     = 47;
 DMPAPER_RESERVED_48                    = 48;
 DMPAPER_RESERVED_49                    = 49;
 DMPAPER_LETTER_EXTRA                   = 50;
 DMPAPER_LEGAL_EXTRA                    = 51;
 DMPAPER_TABLOID_EXTRA                  = 52;
 DMPAPER_A4_EXTRA                       = 53;
 DMPAPER_LETTER_TRANSVERSE              = 54;
 DMPAPER_A4_TRANSVERSE                  = 55;
 DMPAPER_LETTER_EXTRA_TRANSVERSE        = 56;
 DMPAPER_A_PLUS                         = 57;
 DMPAPER_B_PLUS                         = 58;
 DMPAPER_LETTER_PLUS                    = 59;
 DMPAPER_A4_PLUS                        = 60;
 DMPAPER_A5_TRANSVERSE                  = 61;
 DMPAPER_B5_TRANSVERSE                  = 62;
 DMPAPER_A3_EXTRA                       = 63;
 DMPAPER_A5_EXTRA                       = 64;
 DMPAPER_B5_EXTRA                       = 65;
 DMPAPER_A2                             = 66;
 DMPAPER_A3_TRANSVERSE                  = 67;
 DMPAPER_A3_EXTRA_TRANSVERSE            = 68;
 DMPAPER_DBL_JAPANESE_POSTCARD          = 69;
 DMPAPER_A6                             = 70;
 DMPAPER_JENV_KAKU2                     = 71;
 DMPAPER_JENV_KAKU3                     = 72;
 DMPAPER_JENV_CHOU3                     = 73;
 DMPAPER_JENV_CHOU4                     = 74;
 DMPAPER_LETTER_ROTATED                 = 75;
 DMPAPER_A3_ROTATED                     = 76;
 DMPAPER_A4_ROTATED                     = 77;
 DMPAPER_A5_ROTATED                     = 78;
 DMPAPER_B4_JIS_ROTATED                 = 79;
 DMPAPER_B5_JIS_ROTATED                 = 80;
 DMPAPER_JAPANESE_POSTCARD_ROTATED      = 81;
 DMPAPER_DBL_JAPANESE_POSTCARD_ROTATED  = 82;
 DMPAPER_A6_ROTATED                     = 83;
 DMPAPER_JENV_KAKU2_ROTATED             = 84;
 DMPAPER_JENV_KAKU3_ROTATED             = 85;
 DMPAPER_JENV_CHOU3_ROTATED             = 86;
 DMPAPER_JENV_CHOU4_ROTATED             = 87;
 DMPAPER_B6_JIS                         = 88;
 DMPAPER_B6_JIS_ROTATED                 = 89;
 DMPAPER_12X11                          = 90;
 DMPAPER_JENV_YOU4                      = 91;
 DMPAPER_JENV_YOU4_ROTATED              = 92;
 DMPAPER_P16K                           = 93;
 DMPAPER_P32K                           = 94;
 DMPAPER_P32KBIG                        = 95;
 DMPAPER_PENV_1                         = 96;
 DMPAPER_PENV_2                         = 97;
 DMPAPER_PENV_3                         = 98;
 DMPAPER_PENV_4                         = 99;
 DMPAPER_PENV_5                         = 100;
 DMPAPER_PENV_6                         = 101;
 DMPAPER_PENV_7                         = 102;
 DMPAPER_PENV_8                         = 103;
 DMPAPER_PENV_9                         = 104;
 DMPAPER_PENV_10                        = 105;
 DMPAPER_P16K_ROTATED                   = 106;
 DMPAPER_P32K_ROTATED                   = 107;
 DMPAPER_P32KBIG_ROTATED                = 108;
 DMPAPER_PENV_1_ROTATED                 = 109;
 DMPAPER_PENV_2_ROTATED                 = 110;
 DMPAPER_PENV_3_ROTATED                 = 111;
 DMPAPER_PENV_4_ROTATED                 = 112;
 DMPAPER_PENV_5_ROTATED                 = 113;
 DMPAPER_PENV_6_ROTATED                 = 114;
 DMPAPER_PENV_7_ROTATED                 = 115;
 DMPAPER_PENV_8_ROTATED                 = 116;
 DMPAPER_PENV_9_ROTATED                 = 117;
 DMPAPER_PENV_10_ROTATED                = 118;
 DMPAPER_LAST                           = DMPAPER_PENV_10_ROTATED;
 DMPAPER_USER                           = 256;
 DMBIN_UPPER                            = 1;
 DMBIN_FIRST                            = DMBIN_UPPER;
 DMBIN_ONLYONE                          = 1;
 DMBIN_LOWER                            = 2;
 DMBIN_MIDDLE                           = 3;
 DMBIN_MANUAL                           = 4;
 DMBIN_ENVELOPE                         = 5;
 DMBIN_ENVMANUAL                        = 6;
 DMBIN_AUTO                             = 7;
 DMBIN_TRACTOR                          = 8;
 DMBIN_SMALLFMT                         = 9;
 DMBIN_LARGEFMT                         = 10;
 DMBIN_LARGECAPACITY                    = 11;
 DMBIN_CASSETTE                         = 14;
 DMBIN_FORMSOURCE                       = 15;
 DMBIN_LAST                             = DMBIN_FORMSOURCE;
 DMBIN_USER                             = 256;
 DMRES_DRAFT                            = -1;
 DMRES_LOW                              = -2;
 DMRES_MEDIUM                           = -3;
 DMRES_HIGH                             = -4;
 DMCOLOR_MONOCHROME                     = 1;
 DMCOLOR_COLOR                          = 2;
 DMDUP_SIMPLEX                          = 1;
 DMDUP_VERTICAL                         = 2;
 DMDUP_HORIZONTAL                       = 3;
 DMTT_BITMAP                            = 1;
 DMTT_DOWNLOAD                          = 2;
 DMTT_SUBDEV                            = 3;
 DMTT_DOWNLOAD_OUTLINE                  = 4;
 DMCOLLATE_FALSE                        = 0;
 DMCOLLATE_TRUE                         = 1;
 DMDISPLAYFLAGS_TEXTMODE                = $00000004;
 DMICMMETHOD_NONE                       = 1;
 DMICMMETHOD_SYSTEM                     = 2;
 DMICMMETHOD_DRIVER                     = 3;
 DMICMMETHOD_DEVICE                     = 4;
 DMICMMETHOD_USER                       = 256;
 DMICM_SATURATE                         = 1;
 DMICM_CONTRAST                         = 2;
 DMICM_COLORMETRIC                      = 3;
 DMICM_USER                             = 256;

 DMMEDIA_STANDARD            = 1;
 DMMEDIA_TRANSPARENCY        = 2;
 DMMEDIA_GLOSSY              = 3;
 DMMEDIA_USER                = 256;
 DMDITHER_NONE               = 1;
 DMDITHER_COARSE             = 2;
 DMDITHER_FINE               = 3;
 DMDITHER_LINEART            = 4;
 DMDITHER_GRAYSCALE          = 5;
 DMDITHER_USER               = 256;

 RDH_RECTANGLES              = 1;

 GGO_METRICS                 = 0;
 GGO_BITMAP                  = 1;
 GGO_NATIVE                  = 2;
 GGO_GRAY2_BITMAP            = 4;
 GGO_GRAY4_BITMAP            = 5;
 GGO_GRAY8_BITMAP            = 6;
 GGO_GLYPH_INDEX             = 128;

 TT_POLYGON_TYPE             = 24;
 TT_PRIM_LINE                = 1;
 TT_PRIM_QSPLINE             = 2;

 GCP_DBCS                    = $00000001;
 GCP_REORDER                 = $00000002;
 GCP_USEKERNING              = $00000008;
 GCP_GLYPHSHAPE              = $00000010;
 GCP_LIGATE                  = $00000020;
 GCP_GLYPHINDEXING           = $00000080;
 GCP_DIACRITIC               = $00000100;
 GCP_KASHIDA                 = $00000400;
 GCP_ERROR                   = $00008000;
 GCP_JUSTIFY                 = $00010000;
 GCP_NODIACRITICS            = $00020000;
 GCP_CLASSIN                 = $00080000;
 GCP_MAXEXTENT               = $00100000;
 GCP_JUSTIFYIN               = $00200000;
 GCP_DISPLAYZWG              = $00400000;
 GCP_SYMSWAPOFF              = $00800000;
 GCP_NUMERICOVERRIDE         = $01000000;
 GCP_NEUTRALOVERRIDE         = $02000000;
 GCP_NUMERICSLATIN           = $04000000;
 GCP_NUMERICSLOCAL           = $08000000;

 GCPCLASS_LATIN                  = $0001;
 GCPCLASS_HEBREW                 = $0002;
 GCPCLASS_ARABIC                 = $0002;
 GCPCLASS_NEUTRAL                = $0003;
 GCPCLASS_LOCALNUMBER            = $0004;
 GCPCLASS_LATINNUMBER            = $0005;
 GCPCLASS_LATINNUMERICTERMINATOR = $0006;
 GCPCLASS_LATINNUMERICSEPARATOR  = $0007;
 GCPCLASS_NUMERICSEPARATOR       = $0008;
 GCPCLASS_PREBOUNDRTL            = $0080;
 GCPCLASS_PREBOUNDLTR            = $0040;
 GCPCLASS_POSTBOUNDLTR           = $0020;
 GCPCLASS_POSTBOUNDRTL           = $0010;
 GCPGLYPH_LINKBEFORE             = $8000;
 GCPGLYPH_LINKAFTER              = $4000;

 FLI_MASK                        = $000103B;
 FLI_GLYPHS                      = $0040000;

 TT_AVAILABLE = 1;
 TT_ENABLED   = 2;

 PFD_TYPE_RGBA                   = 0;
 PFD_TYPE_COLORINDEX             = 1;
 PFD_MAIN_PLANE                  = 0;
 PFD_OVERLAY_PLANE               = 1;
 PFD_UNDERLAY_PLANE              = -1;
 PFD_DOUBLEBUFFER                = $00000001;
 PFD_STEREO                      = $00000002;
 PFD_DRAW_TO_WINDOW              = $00000004;
 PFD_DRAW_TO_BITMAP              = $00000008;
 PFD_SUPPORT_GDI                 = $00000010;
 PFD_SUPPORT_OPENGL              = $00000020;
 PFD_GENERIC_FORMAT              = $00000040;
 PFD_NEED_PALETTE                = $00000080;
 PFD_NEED_SYSTEM_PALETTE         = $00000100;
 PFD_SWAP_EXCHANGE               = $00000200;
 PFD_SWAP_COPY                   = $00000400;
 PFD_SWAP_LAYER_BUFFERS          = $00000800;
 PFD_GENERIC_ACCELERATED         = $00001000;
 PFD_DEPTH_DONTCARE              = $20000000;
 PFD_DOUBLEBUFFER_DONTCARE       = $40000000;
 PFD_STEREO_DONTCARE             = $80000000;

 DM_UPDATE                       = 1;
 DM_COPY                         = 2;
 DM_PROMPT                       = 4;
 DM_MODIFY                       = 8;
 DM_IN_BUFFER                    = DM_MODIFY;
 DM_IN_PROMPT                    = DM_PROMPT;
 DM_OUT_BUFFER                   = DM_COPY;
 DM_OUT_DEFAULT                  = DM_UPDATE;

 DC_FIELDS                       = 1;
 DC_PAPERS                       = 2;
 DC_PAPERSIZE                    = 3;
 DC_MINEXTENT                    = 4;
 DC_MAXEXTENT                    = 5;
 DC_BINS                         = 6;
 DC_DUPLEX                       = 7;
 DC_SIZE                         = 8;
 DC_EXTRA                        = 9;
 DC_VERSION                      = 10;
 DC_DRIVER                       = 11;
 DC_BINNAMES                     = 12;
 DC_ENUMRESOLUTIONS              = 13;
 DC_FILEDEPENDENCIES             = 14;
 DC_TRUETYPE                     = 15;
 DC_PAPERNAMES                   = 16;
 DC_ORIENTATION                  = 17;
 DC_COPIES                       = 18;
 DC_BINADJUST                    = 19;
 DC_EMF_COMPLIANT                = 20;
 DC_DATATYPE_PRODUCED            = 21;
 DC_COLLATE                      = 22;

 DCTT_BITMAP                     = 1;
 DCTT_DOWNLOAD                   = 2;
 DCTT_SUBDEV                     = 4;
 DCTT_DOWNLOAD_OUTLINE           = 8;

 DCBA_FACEUPNONE                 = 0;
 DCBA_FACEUPCENTER               = 1;
 DCBA_FACEUPLEFT                 = 2;
 DCBA_FACEUPRIGHT                = 3;
 DCBA_FACEDOWNNONE               = 256;
 DCBA_FACEDOWNCENTER             = 257;
 DCBA_FACEDOWNLEFT               = 258;
 DCBA_FACEDOWNRIGHT              = 259;

 CA_NEGATIVE                     = 1;
 CA_LOG_FILTER                   = 2;

 ILLUMINANT_DEVICE_DEFAULT       = 0;
 ILLUMINANT_A                    = 1;
 ILLUMINANT_B                    = 2;
 ILLUMINANT_C                    = 3;
 ILLUMINANT_D50                  = 4;
 ILLUMINANT_D55                  = 5;
 ILLUMINANT_D65                  = 6;
 ILLUMINANT_D75                  = 7;
 ILLUMINANT_F2                   = 8;
 ILLUMINANT_MAX_INDEX            = ILLUMINANT_F2;
 ILLUMINANT_TUNGSTEN             = ILLUMINANT_A;
 ILLUMINANT_DAYLIGHT             = ILLUMINANT_C;
 ILLUMINANT_FLUORESCENT          = ILLUMINANT_F2;
 ILLUMINANT_NTSC                 = ILLUMINANT_C;

 RGB_GAMMA_MIN = 02500;
 RGB_GAMMA_MAX = 65000;

 REFERENCE_WHITE_MIN = 6000;
 REFERENCE_WHITE_MAX = 10000;
 REFERENCE_BLACK_MIN = 0;
 REFERENCE_BLACK_MAX = 4000;

 COLOR_ADJ_MIN  = -100;
 COLOR_ADJ_MAX  = 100;

 DI_APPBANDING  = 1;

 FONTMAPPER_MAX = 10;

 ICM_OFF   = 1;
 ICM_ON    = 2;
 ICM_QUERY = 3;

 ENHMETA_SIGNATURE    = $464D4520;
 ENHMETA_STOCK_OBJECT = $80000000;

 EMR_HEADER                       = 1;
 EMR_POLYBEZIER                   = 2;
 EMR_POLYGON                      = 3;
 EMR_POLYLINE                     = 4;
 EMR_POLYBEZIERTO                 = 5;
 EMR_POLYLINETO                   = 6;
 EMR_POLYPOLYLINE                 = 7;
 EMR_POLYPOLYGON                  = 8;
 EMR_SETWINDOWEXTEX               = 9;
 EMR_SETWINDOWORGEX               = 10;
 EMR_SETVIEWPORTEXTEX             = 11;
 EMR_SETVIEWPORTORGEX             = 12;
 EMR_SETBRUSHORGEX                = 13;
 EMR_EOF                          = 14;
 EMR_SETPIXELV                    = 15;
 EMR_SETMAPPERFLAGS               = 16;
 EMR_SETMAPMODE                   = 17;
 EMR_SETBKMODE                    = 18;
 EMR_SETPOLYFILLMODE              = 19;
 EMR_SETROP2                      = 20;
 EMR_SETSTRETCHBLTMODE            = 21;
 EMR_SETTEXTALIGN                 = 22;
 EMR_SETCOLORADJUSTMENT           = 23;
 EMR_SETTEXTCOLOR                 = 24;
 EMR_SETBKCOLOR                   = 25;
 EMR_OFFSETCLIPRGN                = 26;
 EMR_MOVETOEX                     = 27;
 EMR_SETMETARGN                   = 28;
 EMR_EXCLUDECLIPRECT              = 29;
 EMR_INTERSECTCLIPRECT            = 30;
 EMR_SCALEVIEWPORTEXTEX           = 31;
 EMR_SCALEWINDOWEXTEX             = 32;
 EMR_SAVEDC                       = 33;
 EMR_RESTOREDC                    = 34;
 EMR_SETWORLDTRANSFORM            = 35;
 EMR_MODIFYWORLDTRANSFORM         = 36;
 EMR_SELECTOBJECT                 = 37;
 EMR_CREATEPEN                    = 38;
 EMR_CREATEBRUSHINDIRECT          = 39;
 EMR_DELETEOBJECT                 = 40;
 EMR_ANGLEARC                     = 41;
 EMR_ELLIPSE                      = 42;
 EMR_RECTANGLE                    = 43;
 EMR_ROUNDRECT                    = 44;
 EMR_ARC                          = 45;
 EMR_CHORD                        = 46;
 EMR_PIE                          = 47;
 EMR_SELECTPALETTE                = 48;
 EMR_CREATEPALETTE                = 49;
 EMR_SETPALETTEENTRIES            = 50;
 EMR_RESIZEPALETTE                = 51;
 EMR_REALIZEPALETTE               = 52;
 EMR_EXTFLOODFILL                 = 53;
 EMR_LINETO                       = 54;
 EMR_ARCTO                        = 55;
 EMR_POLYDRAW                     = 56;
 EMR_SETARCDIRECTION              = 57;
 EMR_SETMITERLIMIT                = 58;
 EMR_BEGINPATH                    = 59;
 EMR_ENDPATH                      = 60;
 EMR_CLOSEFIGURE                  = 61;
 EMR_FILLPATH                     = 62;
 EMR_STROKEANDFILLPATH            = 63;
 EMR_STROKEPATH                   = 64;
 EMR_FLATTENPATH                  = 65;
 EMR_WIDENPATH                    = 66;
 EMR_SELECTCLIPPATH               = 67;
 EMR_ABORTPATH                    = 68;
 EMR_GDICOMMENT                   = 70;
 EMR_FILLRGN                      = 71;
 EMR_FRAMERGN                     = 72;
 EMR_INVERTRGN                    = 73;
 EMR_PAINTRGN                     = 74;
 EMR_EXTSELECTCLIPRGN             = 75;
 EMR_BITBLT                       = 76;
 EMR_STRETCHBLT                   = 77;
 EMR_MASKBLT                      = 78;
 EMR_PLGBLT                       = 79;
 EMR_SETDIBITSTODEVICE            = 80;
 EMR_STRETCHDIBITS                = 81;
 EMR_EXTCREATEFONTINDIRECTW       = 82;
 EMR_EXTTEXTOUTA                  = 83;
 EMR_EXTTEXTOUTW                  = 84;
 EMR_POLYBEZIER16                 = 85;
 EMR_POLYGON16                    = 86;
 EMR_POLYLINE16                   = 87;
 EMR_POLYBEZIERTO16               = 88;
 EMR_POLYLINETO16                 = 89;
 EMR_POLYPOLYLINE16               = 90;
 EMR_POLYPOLYGON16                = 91;
 EMR_POLYDRAW16                   = 92;
 EMR_CREATEMONOBRUSH              = 93;
 EMR_CREATEDIBPATTERNBRUSHPT      = 94;
 EMR_EXTCREATEPEN                 = 95;
 EMR_POLYTEXTOUTA                 = 96;
 EMR_POLYTEXTOUTW                 = 97;
 EMR_SETICMMODE                   = 98;
 EMR_CREATECOLORSPACE             = 99;
 EMR_SETCOLORSPACE                = 100;
 EMR_DELETECOLORSPACE             = 101;
 EMR_GLSRECORD                    = 102;
 EMR_GLSBOUNDEDRECORD             = 103;
 EMR_PIXELFORMAT                  = 104;
 EMR_MIN                          = 1;
 EMR_MAX                          = 104;


 GDICOMMENT_IDENTIFIER            = $43494447;
 GDICOMMENT_WINDOWS_METAFILE      = $80000001;
 GDICOMMENT_BEGINGROUP            = $00000002;
 GDICOMMENT_ENDGROUP              = $00000003;
 GDICOMMENT_MULTIFORMATS          = $40000004;
 EPS_SIGNATURE                    = $46535045;

 WGL_FONT_LINES    = 0;
 WGL_FONT_POLYGONS = 1;

 LPD_DOUBLEBUFFER    = $00000001;
 LPD_STEREO          = $00000002;
 LPD_SUPPORT_GDI     = $00000010;
 LPD_SUPPORT_OPENGL  = $00000020;
 LPD_SHARE_DEPTH     = $00000040;
 LPD_SHARE_STENCIL   = $00000080;
 LPD_SHARE_ACCUM     = $00000100;
 LPD_SWAP_EXCHANGE   = $00000200;
 LPD_SWAP_COPY       = $00000400;
 LPD_TRANSPARENT     = $00001000;
 LPD_TYPE_RGBA       = $00000000;
 LPD_TYPE_COLORINDEX = $00000001;

 WGL_SWAP_MAIN_PLANE = $00000001;
 WGL_SWAP_OVERLAY1   = $00000002;
 WGL_SWAP_OVERLAY2   = $00000004;
 WGL_SWAP_OVERLAY3   = $00000008;
 WGL_SWAP_OVERLAY4   = $00000010;
 WGL_SWAP_OVERLAY5   = $00000020;
 WGL_SWAP_OVERLAY6   = $00000040;
 WGL_SWAP_OVERLAY7   = $00000080;
 WGL_SWAP_OVERLAY8   = $00000100;
 WGL_SWAP_OVERLAY9   = $00000200;
 WGL_SWAP_OVERLAY10  = $00000400;
 WGL_SWAP_OVERLAY11  = $00000800;
 WGL_SWAP_OVERLAY12  = $00001000;
 WGL_SWAP_OVERLAY13  = $00002000;
 WGL_SWAP_OVERLAY14  = $00004000;
 WGL_SWAP_OVERLAY15  = $00008000;
 WGL_SWAP_UNDERLAY1  = $00010000;
 WGL_SWAP_UNDERLAY2  = $00020000;
 WGL_SWAP_UNDERLAY3  = $00040000;
 WGL_SWAP_UNDERLAY4  = $00080000;
 WGL_SWAP_UNDERLAY5  = $00100000;
 WGL_SWAP_UNDERLAY6  = $00200000;
 WGL_SWAP_UNDERLAY7  = $00400000;
 WGL_SWAP_UNDERLAY8  = $00800000;
 WGL_SWAP_UNDERLAY9  = $01000000;
 WGL_SWAP_UNDERLAY10 = $02000000;
 WGL_SWAP_UNDERLAY11 = $04000000;
 WGL_SWAP_UNDERLAY12 = $08000000;
 WGL_SWAP_UNDERLAY13 = $10000000;
 WGL_SWAP_UNDERLAY14 = $20000000;
 WGL_SWAP_UNDERLAY15 = $40000000;

 RT_CURSOR       = MakeIntResource(1);
 RT_BITMAP       = MakeIntResource(2);
 RT_ICON         = MakeIntResource(3);
 RT_MENU         = MakeIntResource(4);
 RT_DIALOG       = MakeIntResource(5);
 RT_STRING       = MakeIntResource(6);
 RT_FONTDIR      = MakeIntResource(7);
 RT_FONT         = MakeIntResource(8);
 RT_ACCELERATOR  = MakeIntResource(9);
 RT_RCDATA       = MakeIntResource(10);
 RT_MESSAGETABLE = MakeIntResource(11);
 RT_GROUP_CURSOR = MakeIntResource(12);
 RT_GROUP_ICON   = MakeIntResource(14);
 RT_VERSION      = MakeIntResource(16);
 RT_DLGINCLUDE   = MakeIntResource(17);
 RT_PLUGPLAY     = MakeIntResource(19);
 RT_VXD          = MakeIntResource(20);
 RT_ANICURSOR    = MakeIntResource(21);
 RT_ANIICON      = MakeIntResource(22);

 SB_HORZ             = 0;
 SB_VERT             = 1;
 SB_CTL              = 2;
 SB_BOTH             = 3;
 SB_LINEUP           = 0;
 SB_LINELEFT         = 0;
 SB_LINEDOWN         = 1;
 SB_LINERIGHT        = 1;
 SB_PAGEUP           = 2;
 SB_PAGELEFT         = 2;
 SB_PAGEDOWN         = 3;
 SB_PAGERIGHT        = 3;
 SB_THUMBPOSITION    = 4;
 SB_THUMBTRACK       = 5;
 SB_TOP              = 6;
 SB_LEFT             = 6;
 SB_BOTTOM           = 7;
 SB_RIGHT            = 7;
 SB_ENDSCROLL        = 8;

 SW_HIDE             = 0;
 SW_SHOWNORMAL       = 1;
 SW_NORMAL           = 1;
 SW_SHOWMINIMIZED    = 2;
 SW_SHOWMAXIMIZED    = 3;
 SW_MAXIMIZE         = 3;
 SW_SHOWNOACTIVATE   = 4;
 SW_SHOW             = 5;
 SW_MINIMIZE         = 6;
 SW_SHOWMINNOACTIVE  = 7;
 SW_SHOWNA           = 8;
 SW_RESTORE          = 9;
 SW_SHOWDEFAULT      = 10;
 SW_MAX              = 10;
 SW_PARENTCLOSING    = 1;
 SW_OTHERZOOM        = 2;
 SW_PARENTOPENING    = 3;
 SW_OTHERUNZOOM      = 4;

 HIDE_WINDOW         = 0;
 SHOW_OPENWINDOW     = 1;
 SHOW_ICONWINDOW     = 2;
 SHOW_FULLSCREEN     = 3;
 SHOW_OPENNOACTIVATE = 4;

 KF_EXTENDED         = $0100;
 KF_DLGMODE          = $0800;
 KF_MENUMODE         = $1000;
 KF_ALTDOWN          = $2000;
 KF_REPEAT           = $4000;
 KF_UP               = $8000;

 VK_LBUTTON          = 1;
 VK_RBUTTON          = 2;
 VK_CANCEL           = 3;
 VK_MBUTTON          = 4;
 VK_BACK             = 8;
 VK_TAB              = 9;
 VK_CLEAR            = 12;
 VK_RETURN           = 13;
 VK_SHIFT            = 16;
 VK_CONTROL          = 17;
 VK_MENU             = 18;
 VK_PAUSE            = 19;
 VK_CAPITAL          = 20;
 VK_KANA             = 21;
 VK_HANGUL           = 21;
 VK_JUNJA            = 23;
 VK_FINAL            = 24;
 VK_HANJA            = 25;
 VK_KANJI            = 25;
 VK_CONVERT          = 28;
 VK_NONCONVERT       = 29;
 VK_ACCEPT           = 30;
 VK_MODECHANGE       = 31;
 VK_ESCAPE           = 27;
 VK_SPACE            = 32;
 VK_PRIOR            = 33;
 VK_NEXT             = 34;
 VK_END              = 35;
 VK_HOME             = 36;
 VK_LEFT             = 37;
 VK_UP               = 38;
 VK_RIGHT            = 39;
 VK_DOWN             = 40;
 VK_SELECT           = 41;
 VK_PRINT            = 42;
 VK_EXECUTE          = 43;
 VK_SNAPSHOT         = 44;
 VK_INSERT           = 45;
 VK_DELETE           = 46;
 VK_HELP             = 47;
 VK_LWIN             = 91;
 VK_RWIN             = 92;
 VK_APPS             = 93;
 VK_NUMPAD0          = 96;
 VK_NUMPAD1          = 97;
 VK_NUMPAD2          = 98;
 VK_NUMPAD3          = 99;
 VK_NUMPAD4          = 100;
 VK_NUMPAD5          = 101;
 VK_NUMPAD6          = 102;
 VK_NUMPAD7          = 103;
 VK_NUMPAD8          = 104;
 VK_NUMPAD9          = 105;
 VK_MULTIPLY         = 106;
 VK_ADD              = 107;
 VK_SEPARATOR        = 108;
 VK_SUBTRACT         = 109;
 VK_DECIMAL          = 110;
 VK_DIVIDE           = 111;
 VK_F1               = 112;
 VK_F2               = 113;
 VK_F3               = 114;
 VK_F4               = 115;
 VK_F5               = 116;
 VK_F6               = 117;
 VK_F7               = 118;
 VK_F8               = 119;
 VK_F9               = 120;
 VK_F10              = 121;
 VK_F11              = 122;
 VK_F12              = 123;
 VK_F13              = 124;
 VK_F14              = 125;
 VK_F15              = 126;
 VK_F16              = 127;
 VK_F17              = 128;
 VK_F18              = 129;
 VK_F19              = 130;
 VK_F20              = 131;
 VK_F21              = 132;
 VK_F22              = 133;
 VK_F23              = 134;
 VK_F24              = 135;
 VK_NUMLOCK          = 144;
 VK_SCROLL           = 145;
 VK_LSHIFT           = 160;
 VK_RSHIFT           = 161;
 VK_LCONTROL         = 162;
 VK_RCONTROL         = 163;
 VK_LMENU            = 164;
 VK_RMENU            = 165;
 VK_PROCESSKEY       = 229;
 VK_ATTN             = 246;
 VK_CRSEL            = 247;
 VK_EXSEL            = 248;
 VK_EREOF            = 249;
 VK_PLAY             = 250;
 VK_ZOOM             = 251;
 VK_NONAME           = 252;
 VK_PA1              = 253;
 VK_OEM_CLEAR        = 254;

 WH_MIN              = -1;
 WH_MSGFILTER        = -1;
 WH_JOURNALRECORD    = 0;
 WH_JOURNALPLAYBACK  = 1;
 WH_KEYBOARD         = 2;
 WH_GETMESSAGE       = 3;
 WH_CALLWNDPROC      = 4;
 WH_CBT              = 5;
 WH_SYSMSGFILTER     = 6;
 WH_MOUSE            = 7;
 WH_HARDWARE         = 8;
 WH_DEBUG            = 9;
 WH_SHELL            = 10;
 WH_FOREGROUNDIDLE   = 11;
 WH_CALLWNDPROCRET   = 12;
 WH_MAX              = 12;
 WH_MINHOOK          = WH_MIN;
 WH_MAXHOOK          = WH_MAX;

 HC_ACTION           = 0;
 HC_GETNEXT          = 1;
 HC_SKIP             = 2;
 HC_NOREMOVE         = 3;
 HC_NOREM            = HC_NOREMOVE;
 HC_SYSMODALON       = 4;
 HC_SYSMODALOFF      = 5;

 HCBT_MOVESIZE       = 0;
 HCBT_MINMAX         = 1;
 HCBT_QS             = 2;
 HCBT_CREATEWND      = 3;
 HCBT_DESTROYWND     = 4;
 HCBT_ACTIVATE       = 5;
 HCBT_CLICKSKIPPED   = 6;
 HCBT_KEYSKIPPED     = 7;
 HCBT_SYSCOMMAND     = 8;
 HCBT_SETFOCUS       = 9;

 MSGF_DIALOGBOX      = 0;
 MSGF_MESSAGEBOX     = 1;
 MSGF_MENU           = 2;
 MSGF_MOVE           = 3;
 MSGF_SIZE           = 4;
 MSGF_SCROLLBAR      = 5;
 MSGF_NEXTWINDOW     = 6;
 MSGF_MAINLOOP       = 8;
 MSGF_MAX            = 8;
 MSGF_USER           = 4096;

 HSHELL_WINDOWCREATED       = 1;
 HSHELL_WINDOWDESTROYED     = 2;
 HSHELL_ACTIVATESHELLWINDOW = 3;
 HSHELL_WINDOWACTIVATED     = 4;
 HSHELL_GETMINRECT          = 5;
 HSHELL_REDRAW              = 6;
 HSHELL_TASKMAN             = 7;
 HSHELL_LANGUAGE            = 8;

 HKL_PREV = 0;
 HKL_NEXT = 1;

 KLF_ACTIVATE       = 1;
 KLF_SUBSTITUTE_OK  = 2;
 KLF_UNLOADPREVIOUS = 4;
 KLF_REORDER        = 8;
 KLF_REPLACELANG    = 16;
 KLF_NOTELLSHELL    = 128;

 KL_NAMELENGTH      = 9;

 DESKTOP_READOBJECTS            = $0001;
 DESKTOP_CREATEWINDOW           = $0002;
 DESKTOP_CREATEMENU             = $0004;
 DESKTOP_HOOKCONTROL            = $0008;
 DESKTOP_JOURNALRECORD          = $0010;
 DESKTOP_JOURNALPLAYBACK        = $0020;
 DESKTOP_ENUMERATE              = $0040;
 DESKTOP_WRITEOBJECTS           = $0080;
 DESKTOP_SWITCHDESKTOP          = $0100;

 DF_ALLOWOTHERACCOUNTHOOK = 1;

 WINSTA_ENUMDESKTOPS      = $0001;
 WINSTA_READATTRIBUTES    = $0002;
 WINSTA_ACCESSCLIPBOARD   = $0004;
 WINSTA_CREATEDESKTOP     = $0008;
 WINSTA_WRITEATTRIBUTES   = $0010;
 WINSTA_ACCESSGLOBALATOMS = $0020;
 WINSTA_EXITWINDOWS       = $0040;
 WINSTA_ENUMERATE         = $0100;
 WINSTA_READSCREEN        = $0200;

 WSF_VISIBLE              = 1;

 UOI_FLAGS                = 1;
 UOI_NAME                 = 2;
 UOI_TYPE                 = 3;
 UOI_USER_SID             = 4;

 GWL_WNDPROC              = -4;
 GWL_HINSTANCE            = -6;
 GWL_HWNDPARENT           = -8;
 GWL_STYLE                = -16;
 GWL_EXSTYLE              = -20;
 GWL_USERDATA             = -21;
 GWL_ID                   = -12;

 GCL_MENUNAME             = -8;
 GCL_HBRBACKGROUND        = -10;
 GCL_HCURSOR              = -12;
 GCL_HICON                = -14;
 GCL_HMODULE              = -16;
 GCL_CBWNDEXTRA           = -18;
 GCL_CBCLSEXTRA           = -20;
 GCL_WNDPROC              = -24;
 GCL_STYLE                = -26;
 GCW_ATOM                 = -32;
 GCL_HICONSM              = -34;

 WA_INACTIVE              = 0;
 WA_ACTIVE                = 1;
 WA_CLICKACTIVE           = 2;

 PWR_OK                   = 1;
 PWR_FAIL                 = -1;
 PWR_SUSPENDREQUEST       = 1;
 PWR_SUSPENDRESUME        = 2;
 PWR_CRITICALRESUME       = 3;

 NFR_ANSI                 = 1;
 NFR_UNICODE              = 2;
 NF_QUERY                 = 3;
 NF_REQUERY               = 4;

 WHEEL_DELTA              = 120;
 WHEEL_PAGESCROLL         = $FFFFFFFF;

 MENULOOP_WINDOW          = 0;
 MENULOOP_POPUP           = 1;

 WMSZ_LEFT                = 1;
 WMSZ_RIGHT               = 2;
 WMSZ_TOP                 = 3;
 WMSZ_TOPLEFT             = 4;
 WMSZ_TOPRIGHT            = 5;
 WMSZ_BOTTOM              = 6;
 WMSZ_BOTTOMLEFT          = 7;
 WMSZ_BOTTOMRIGHT         = 8;

 ST_BEGINSWP              = 0;
 ST_ENDSWP                = 1;

 HTERROR                  = -2;
 HTTRANSPARENT            = -1;
 HTNOWHERE                = 0;
 HTCLIENT                 = 1;
 HTCAPTION                = 2;
 HTSYSMENU                = 3;
 HTGROWBOX                = 4;
 HTSIZE                   = HTGROWBOX;
 HTMENU                   = 5;
 HTHSCROLL                = 6;
 HTVSCROLL                = 7;
 HTMINBUTTON              = 8;
 HTMAXBUTTON              = 9;
 HTLEFT                   = 10;
 HTRIGHT                  = 11;
 HTTOP                    = 12;
 HTTOPLEFT                = 13;
 HTTOPRIGHT               = 14;
 HTBOTTOM                 = 15;
 HTBOTTOMLEFT             = 16;
 HTBOTTOMRIGHT            = 17;
 HTBORDER                 = 18;
 HTREDUCE                 = HTMINBUTTON;
 HTZOOM                   = HTMAXBUTTON;
 HTSIZEFIRST              = HTLEFT;
 HTSIZELAST               = HTBOTTOMRIGHT;
 HTOBJECT                 = 19;
 HTCLOSE                  = 20;
 HTHELP                   = 21;

 SMTO_NORMAL              = 0;
 SMTO_BLOCK               = 1;
 SMTO_ABORTIFHUNG         = 2;

 MA_ACTIVATE              = 1;
 MA_ACTIVATEANDEAT        = 2;
 MA_NOACTIVATE            = 3;
 MA_NOACTIVATEANDEAT      = 4;

 ICON_SMALL               = 0;
 ICON_BIG                 = 1;

 SIZE_RESTORED  = 0;
 SIZE_MINIMIZED = 1;
 SIZE_MAXIMIZED = 2;
 SIZE_MAXSHOW   = 3;
 SIZE_MAXHIDE   = 4;

 SIZENORMAL     = SIZE_RESTORED;
 SIZEICONIC     = SIZE_MINIMIZED;
 SIZEFULLSCREEN = SIZE_MAXIMIZED;
 SIZEZOOMSHOW   = SIZE_MAXSHOW;
 SIZEZOOMHIDE   = SIZE_MAXHIDE;

 WVR_ALIGNTOP    = $10;
 WVR_ALIGNLEFT   = $20;
 WVR_ALIGNBOTTOM = $40;
 WVR_ALIGNRIGHT  = $80;
 WVR_HREDRAW     = $100;
 WVR_VREDRAW     = $200;
 WVR_REDRAW      = WVR_HREDRAW or WVR_VREDRAW;
 WVR_VALIDRECTS  = $400;


 MK_LBUTTON = $01;
 MK_RBUTTON = $02;
 MK_SHIFT   = $04;
 MK_CONTROL = $08;
 MK_MBUTTON = $10;

 TME_HOVER           = $00000001;
 TME_LEAVE           = $00000002;
 TME_QUERY           = $40000000;
 TME_CANCEL          = $80000000;

 HOVER_DEFAULT       = $FFFFFFFF;

 WS_OVERLAPPED       = $00000000;
 WS_POPUP            = $80000000;
 WS_CHILD            = $40000000;
 WS_MINIMIZE         = $20000000;
 WS_VISIBLE          = $10000000;
 WS_DISABLED         = $8000000;
 WS_CLIPSIBLINGS     = $4000000;
 WS_CLIPCHILDREN     = $2000000;
 WS_MAXIMIZE         = $1000000;
 WS_CAPTION          = $C00000;
 WS_BORDER           = $800000;
 WS_DLGFRAME         = $400000;
 WS_VSCROLL          = $200000;
 WS_HSCROLL          = $100000;
 WS_SYSMENU          = $80000;
 WS_THICKFRAME       = $40000;
 WS_GROUP            = $20000;
 WS_TABSTOP          = $10000;
 WS_MINIMIZEBOX      = $20000;
 WS_MAXIMIZEBOX      = $10000;
 WS_TILED            = WS_OVERLAPPED;
 WS_ICONIC           = WS_MINIMIZE;
 WS_SIZEBOX          = WS_THICKFRAME;
 WS_OVERLAPPEDWINDOW = WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU or
                       WS_THICKFRAME or WS_MINIMIZEBOX or WS_MAXIMIZEBOX;
 WS_TILEDWINDOW      = WS_OVERLAPPEDWINDOW;
 WS_POPUPWINDOW      = WS_POPUP or WS_BORDER or WS_SYSMENU;
 WS_CHILDWINDOW      = WS_CHILD;

 WS_EX_DLGMODALFRAME    = $01;
 WS_EX_NOPARENTNOTIFY   = $04;
 WS_EX_TOPMOST          = $08;
 WS_EX_ACCEPTFILES      = $10;
 WS_EX_TRANSPARENT      = $20;
 WS_EX_MDICHILD         = $40;
 WS_EX_TOOLWINDOW       = $80;
 WS_EX_WINDOWEDGE       = $100;
 WS_EX_CLIENTEDGE       = $200;
 WS_EX_CONTEXTHELP      = $400;
 WS_EX_RIGHT            = $1000;
 WS_EX_LEFT             = $0000;
 WS_EX_RTLREADING       = $2000;
 WS_EX_LTRREADING       = $0000;
 WS_EX_LEFTSCROLLBAR    = $4000;
 WS_EX_RIGHTSCROLLBAR   = $0000;
 WS_EX_CONTROLPARENT    = $10000;
 WS_EX_STATICEDGE       = $20000;
 WS_EX_APPWINDOW        = $40000;
 WS_EX_OVERLAPPEDWINDOW = WS_EX_WINDOWEDGE or WS_EX_CLIENTEDGE;
 WS_EX_PALETTEWINDOW    = WS_EX_WINDOWEDGE or WS_EX_TOOLWINDOW or
                          WS_EX_TOPMOST;

 CS_VREDRAW               = $01;
 CS_HREDRAW               = $02;
 CS_KEYCVTWINDOW          = $04;
 CS_DBLCLKS               = $08;
 CS_OWNDC                 = $20;
 CS_CLASSDC               = $40;
 CS_PARENTDC              = $80;
 CS_NOKEYCVT              = $100;
 CS_NOCLOSE               = $200;
 CS_SAVEBITS              = $800;
 CS_BYTEALIGNCLIENT       = $1000;
 CS_BYTEALIGNWINDOW       = $2000;
 CS_GLOBALCLASS           = $4000;
 CS_IME                   = $10000;

 PRF_CHECKVISIBLE = $01;
 PRF_NONCLIENT    = $02;
 PRF_CLIENT       = $04;
 PRF_ERASEBKGND   = $08;
 PRF_CHILDREN     = $10;
 PRF_OWNED        = $20;

 BDR_RAISEDOUTER = 1;
 BDR_SUNKENOUTER = 2;
 BDR_RAISEDINNER = 4;
 BDR_SUNKENINNER = 8;

 BDR_OUTER  = 3;
 BDR_INNER  = 12;
 BDR_RAISED = 5;
 BDR_SUNKEN = 10;

 EDGE_RAISED = BDR_RAISEDOUTER or BDR_RAISEDINNER;
 EDGE_SUNKEN = BDR_SUNKENOUTER or BDR_SUNKENINNER;
 EDGE_ETCHED = BDR_SUNKENOUTER or BDR_RAISEDINNER;
 EDGE_BUMP   = BDR_RAISEDOUTER or BDR_SUNKENINNER;

 BF_LEFT        = 1;
 BF_TOP         = 2;
 BF_RIGHT       = 4;
 BF_BOTTOM      = 8;
 BF_TOPLEFT     = BF_TOP or BF_LEFT;
 BF_TOPRIGHT    = BF_TOP or BF_RIGHT;
 BF_BOTTOMLEFT  = BF_BOTTOM or BF_LEFT;
 BF_BOTTOMRIGHT = BF_BOTTOM or BF_RIGHT;
 BF_RECT        = BF_LEFT or BF_TOP or BF_RIGHT or BF_BOTTOM;

 BF_DIAGONAL                = $10;
 BF_DIAGONAL_ENDTOPRIGHT    = BF_DIAGONAL or BF_TOP or BF_RIGHT;
 BF_DIAGONAL_ENDTOPLEFT     = BF_DIAGONAL or BF_TOP or BF_LEFT;
 BF_DIAGONAL_ENDBOTTOMLEFT  = BF_DIAGONAL or BF_BOTTOM or BF_LEFT;
 BF_DIAGONAL_ENDBOTTOMRIGHT = BF_DIAGONAL or BF_BOTTOM or BF_RIGHT;

 BF_MIDDLE  = $0800;
 BF_SOFT    = $1000;
 BF_ADJUST  = $2000;
 BF_FLAT    = $4000;
 BF_MONO    = $8000;

 DFC_CAPTION = 1;
 DFC_MENU    = 2;
 DFC_SCROLL = 3;
 DFC_BUTTON = 4;

 DFCS_CAPTIONCLOSE        = 0;
 DFCS_CAPTIONMIN          = 1;
 DFCS_CAPTIONMAX          = 2;
 DFCS_CAPTIONRESTORE      = 3;
 DFCS_CAPTIONHELP         = 4;
 DFCS_MENUARROW           = 0;
 DFCS_MENUCHECK           = 1;
 DFCS_MENUBULLET          = 2;
 DFCS_MENUARROWRIGHT      = 4;
 DFCS_SCROLLUP            = 0;
 DFCS_SCROLLDOWN          = 1;
 DFCS_SCROLLLEFT          = 2;
 DFCS_SCROLLRIGHT         = 3;
 DFCS_SCROLLCOMBOBOX      = 5;
 DFCS_SCROLLSIZEGRIP      = 8;
 DFCS_SCROLLSIZEGRIPRIGHT = 16;
 DFCS_BUTTONCHECK         = 0;
 DFCS_BUTTONRADIOIMAGE    = 1;
 DFCS_BUTTONRADIOMASK     = 2;
 DFCS_BUTTONRADIO         = 4;
 DFCS_BUTTON3STATE        = 8;
 DFCS_BUTTONPUSH          = $10;
 DFCS_INACTIVE            = $100;
 DFCS_PUSHED              = $200;
 DFCS_CHECKED             = $400;
 DFCS_ADJUSTRECT          = $2000;
 DFCS_FLAT                = $4000;
 DFCS_MONO                = $8000;

 DC_ACTIVE                = 1;
 DC_SMALLCAP              = 2;
 DC_ICON                  = 4;
 DC_TEXT                  = 8;
 DC_INBUTTON              = 16;

 IDANI_OPEN               = 1;
 IDANI_CLOSE              = 2;
 IDANI_CAPTION            = 3;

 CF_TEXT                  = 1;
 CF_BITMAP                = 2;
 CF_METAFILEPICT          = 3;
 CF_SYLK                  = 4;
 CF_DIF                   = 5;
 CF_TIFF                  = 6;
 CF_OEMTEXT               = 7;
 CF_DIB                   = 8;
 CF_PALETTE               = 9;
 CF_PENDATA               = 10;
 CF_RIFF                  = 11;
 CF_WAVE                  = 12;
 CF_UNICODETEXT           = 13;
 CF_ENHMETAFILE           = 14;
 CF_HDROP                 = 15;
 CF_LOCALE                = 16;
 CF_MAX                   = 17;
 CF_OWNERDISPLAY          = 128;
 CF_DSPTEXT               = 129;
 CF_DSPBITMAP             = 130;
 CF_DSPMETAFILEPICT       = 131;
 CF_DSPENHMETAFILE        = 142;
 CF_PRIVATEFIRST          = 512;
 CF_PRIVATELAST           = 767;
 CF_GDIOBJFIRST           = 768;
 CF_GDIOBJLAST            = 1023;

 FVIRTKEY                 = 1;
 FNOINVERT                = 2;
 FSHIFT                   = 4;
 FCONTROL                 = 8;
 FALT                     = 16;

 WPF_SETMINPOSITION       = 1;
 WPF_RESTORETOMAXIMIZED   = 2;

 ODT_MENU                 = 1;
 ODT_LISTBOX              = 2;
 ODT_COMBOBOX             = 3;
 ODT_BUTTON               = 4;
 ODT_STATIC               = 5;

 ODA_DRAWENTIRE           = 1;
 ODA_SELECT               = 2;
 ODA_FOCUS                = 4;

 ODS_SELECTED             = $0001;
 ODS_GRAYED               = $0002;
 ODS_DISABLED             = $0004;
 ODS_CHECKED              = $0008;
 ODS_FOCUS                = $0010;
 ODS_DEFAULT              = $0020;
 ODS_COMBOBOXEDIT         = $1000;

 PM_NOREMOVE = 0;
 PM_REMOVE   = 1;
 PM_NOYIELD  = 2;

 MOD_ALT     = 1;
 MOD_CONTROL = 2;
 MOD_SHIFT   = 4;
 MOD_WIN     = 8;

 IDHOT_SNAPWINDOW  = -1;
 IDHOT_SNAPDESKTOP = -2;

 EW_RESTARTWINDOWS        = $0042;
 EW_REBOOTSYSTEM          = $0043;
 EW_EXITANDEXECAPP        = $0044;

 ENDSESSION_LOGOFF        = $80000000;

 EWX_LOGOFF               = 0;
 EWX_SHUTDOWN             = 1;
 EWX_REBOOT               = 2;
 EWX_FORCE                = 4;
 EWX_POWEROFF             = 8;

 BSM_ALLCOMPONENTS        = $00000000;
 BSM_VXDS                 = $00000001;
 BSM_NETDRIVER            = $00000002;
 BSM_INSTALLABLEDRIVERS   = $00000004;
 BSM_APPLICATIONS         = $00000008;
 BSM_ALLDESKTOPS          = $00000010;

 BSF_QUERY                = $00000001;
 BSF_IGNORECURRENTTASK    = $00000002;
 BSF_FLUSHDISK            = $00000004;
 BSF_NOHANG               = $00000008;
 BSF_POSTMESSAGE          = $00000010;
 BSF_FORCEIFHUNG          = $00000020;
 BSF_NOTIMEOUTIFNOTHUNG   = $00000040;

 DBWF_LPARAMPOINTER       = $8000;

 BROADCAST_QUERY_DENY     = $424D5144;

 HWND_BROADCAST           = $FFFF;
 wnd_Broadcast            = HWND_BROADCAST;

 CW_USEDEFAULT            = $80000000;

 HWND_DESKTOP             = 0;

 SWP_NOSIZE               = $01;
 SWP_NOMOVE               = $02;
 SWP_NOZORDER             = $04;
 SWP_NOREDRAW             = $08;
 SWP_NOACTIVATE           = $10;
 SWP_FRAMECHANGED         = $20;
 SWP_SHOWWINDOW           = $40;
 SWP_HIDEWINDOW           = $80;
 SWP_NOCOPYBITS           = $100;
 SWP_NOOWNERZORDER        = $200;
 SWP_NOSENDCHANGING       = $400;
 SWP_DRAWFRAME            = SWP_FRAMECHANGED;
 SWP_NOREPOSITION         = SWP_NOOWNERZORDER;
 SWP_DEFERERASE           = $2000;
 SWP_ASYNCWINDOWPOS       = $4000;

 HWND_TOP                 = 0;
 HWND_BOTTOM              = 1;
 HWND_TOPMOST             = -1;
 HWND_NOTOPMOST           = -2;

 DLGWINDOWEXTRA           = 30;

 KEYEVENTF_EXTENDEDKEY = 1;
 KEYEVENTF_KEYUP       = 2;

 MOUSEEVENTF_MOVE            = $0001;
 MOUSEEVENTF_LEFTDOWN        = $0002;
 MOUSEEVENTF_LEFTUP          = $0004;
 MOUSEEVENTF_RIGHTDOWN       = $0008;
 MOUSEEVENTF_RIGHTUP         = $0010;
 MOUSEEVENTF_MIDDLEDOWN      = $0020;
 MOUSEEVENTF_MIDDLEUP        = $0040;
 MOUSEEVENTF_WHEEL           = $0800;
 MOUSEEVENTF_ABSOLUTE        = $8000;

 MWMO_WAITALL   = $0001;
 MWMO_ALERTABLE = $0002;

 QS_KEY                  = $0001;
 QS_MOUSEMOVE            = $0002;
 QS_MOUSEBUTTON          = $0004;
 QS_POSTMESSAGE          = $0008;
 QS_TIMER                = $0010;
 QS_PAINT                = $0020;
 QS_SENDMESSAGE          = $0040;
 QS_HOTKEY               = $0080;
 QS_ALLPOSTMESSAGE       = $0100;

 QS_MOUSE                = QS_MOUSEMOVE or QS_MOUSEBUTTON;
 QS_INPUT                = QS_MOUSE or QS_KEY;
 QS_ALLEVENTS            = QS_INPUT or QS_POSTMESSAGE or QS_TIMER or
                           QS_PAINT or QS_HOTKEY;
 QS_ALLINPUT             = QS_INPUT or QS_POSTMESSAGE or QS_TIMER or
                           QS_PAINT or QS_HOTKEY or QS_SENDMESSAGE;

 SM_CXSCREEN               = 0;
 SM_CYSCREEN               = 1;
 SM_CXVSCROLL              = 2;
 SM_CYHSCROLL              = 3;
 SM_CYCAPTION              = 4;
 SM_CXBORDER               = 5;
 SM_CYBORDER               = 6;
 SM_CXDLGFRAME             = 7;
 SM_CYDLGFRAME             = 8;
 SM_CYVTHUMB               = 9;
 SM_CXHTHUMB               = 10;
 SM_CXICON                 = 11;
 SM_CYICON                 = 12;
 SM_CXCURSOR               = 13;
 SM_CYCURSOR               = 14;
 SM_CYMENU                 = 15;
 SM_CXFULLSCREEN           = 16;
 SM_CYFULLSCREEN           = 17;
 SM_CYKANJIWINDOW          = 18;
 SM_MOUSEPRESENT           = 19;
 SM_CYVSCROLL              = 20;
 SM_CXHSCROLL              = 21;
 SM_DEBUG                  = 22;
 SM_SWAPBUTTON             = 23;
 SM_RESERVED1              = 24;
 SM_RESERVED2              = 25;
 SM_RESERVED3              = 26;
 SM_RESERVED4              = 27;
 SM_CXMIN                  = 28;
 SM_CYMIN                  = 29;
 SM_CXSIZE                 = 30;
 SM_CYSIZE                 = 31;
 SM_CXFRAME                = 32;
 SM_CYFRAME                = 33;
 SM_CXMINTRACK             = 34;
 SM_CYMINTRACK             = 35;
 SM_CXDOUBLECLK            = 36;
 SM_CYDOUBLECLK            = 37;
 SM_CXICONSPACING          = 38;
 SM_CYICONSPACING          = 39;
 SM_MENUDROPALIGNMENT      = 40;
 SM_PENWINDOWS             = 41;
 SM_DBCSENABLED            = 42;
 SM_CMOUSEBUTTONS          = 43;

 SM_CXFIXEDFRAME           = SM_CXDLGFRAME;
 SM_CYFIXEDFRAME           = SM_CYDLGFRAME;
 SM_CXSIZEFRAME            = SM_CXFRAME;
 SM_CYSIZEFRAME            = SM_CYFRAME;

 SM_SECURE                 = 44;
 SM_CXEDGE                 = 45;
 SM_CYEDGE                 = 46;
 SM_CXMINSPACING           = 47;
 SM_CYMINSPACING           = 48;
 SM_CXSMICON               = 49;
 SM_CYSMICON               = 50;
 SM_CYSMCAPTION            = 51;
 SM_CXSMSIZE               = 52;
 SM_CYSMSIZE               = 53;
 SM_CXMENUSIZE             = 54;
 SM_CYMENUSIZE             = 55;
 SM_ARRANGE                = 56;
 SM_CXMINIMIZED            = 57;
 SM_CYMINIMIZED            = 58;
 SM_CXMAXTRACK             = 59;
 SM_CYMAXTRACK             = 60;
 SM_CXMAXIMIZED            = 61;
 SM_CYMAXIMIZED            = 62;
 SM_NETWORK                = 63;
 SM_CLEANBOOT              = 67;
 SM_CXDRAG                 = 68;
 SM_CYDRAG                 = 69;
 SM_SHOWSOUNDS             = 70;
 SM_CXMENUCHECK            = 71;
 SM_CYMENUCHECK            = 72;
 SM_SLOWMACHINE            = 73;
 SM_MIDEASTENABLED         = 74;
 SM_MOUSEWHEELPRESENT      = 75;
 SM_CMETRICS               = 76;

 MNC_IGNORE                = 0;
 MNC_CLOSE                 = 1;
 MNC_EXECUTE               = 2;
 MNC_SELECT                = 3;

 MIIM_STATE                = 1;
 MIIM_ID                   = 2;
 MIIM_SUBMENU              = 4;
 MIIM_CHECKMARKS           = 8;
 MIIM_TYPE                 = 16;
 MIIM_DATA                 = 32;

 GMDI_USEDISABLED  = 1;
 GMDI_GOINTOPOPUPS = 2;

 TPM_LEFTBUTTON    = 0;
 TPM_RIGHTBUTTON   = 2;
 TPM_LEFTALIGN     = 0;
 TPM_CENTERALIGN   = 4;
 TPM_RIGHTALIGN    = 8;
 TPM_TOPALIGN      = 0;
 TPM_VCENTERALIGN  = 16;
 TPM_BOTTOMALIGN   = 32;

 TPM_HORIZONTAL = $0000;
 TPM_VERTICAL   = $0040;
 TPM_NONOTIFY   = $0080;
 TPM_RETURNCMD  = $0100;

 DOF_EXECUTABLE = 32769;
 DOF_DOCUMENT   = 32770;
 DOF_DIRECTORY  = 32771;
 DOF_MULTIPLE   = 32772;
 DOF_PROGMAN    = 1;
 DOF_SHELLDATA  = 2;

 DO_DROPFILE    = $454C4946;
 DO_PRINTFILE   = $544E5250;

 DT_TOP             = $0000;
 DT_LEFT            = $0000;
 DT_CENTER          = $0001;
 DT_RIGHT           = $0002;
 DT_VCENTER         = $0004;
 DT_BOTTOM          = $0008;
 DT_WORDBREAK       = $0010;
 DT_SINGLELINE      = $0020;
 DT_EXPANDTABS      = $0040;
 DT_TABSTOP         = $0080;
 DT_NOCLIP          = $0100;
 DT_EXTERNALLEADING = $0200;
 DT_CALCRECT        = $0400;
 DT_NOPREFIX        = $0800;
 DT_INTERNAL        = $1000;

 DT_EDITCONTROL     = $2000;
 DT_PATH_ELLIPSIS   = $4000;
 DT_END_ELLIPSIS    = $8000;
 DT_MODIFYSTRING    = $10000;
 DT_RTLREADING      = $20000;
 DT_WORD_ELLIPSIS   = $40000;

 DST_COMPLEX        = 0;
 DST_TEXT           = 1;
 DST_PREFIXTEXT     = 2;
 DST_ICON           = 3;
 DST_BITMAP         = 4;

 DSS_NORMAL         = $00;
 DSS_UNION          = $10;
 DSS_DISABLED       = $20;
 DSS_MONO           = $80;
 DSS_RIGHT          = $8000;

 DCX_WINDOW           = $01;
 DCX_CACHE            = $02;
 DCX_NORESETATTRS     = $04;
 DCX_CLIPCHILDREN     = $08;
 DCX_CLIPSIBLINGS     = $10;
 DCX_PARENTCLIP       = $20;
 DCX_EXCLUDERGN       = $40;
 DCX_INTERSECTRGN     = $80;
 DCX_EXCLUDEUPDATE    = $100;
 DCX_INTERSECTUPDATE  = $200;
 DCX_LOCKWINDOWUPDATE = $400;
 DCX_VALIDATE         = $200000;

 RDW_INVALIDATE       = $01;
 RDW_INTERNALPAINT    = $02;
 RDW_ERASE            = $04;
 RDW_VALIDATE         = $08;
 RDW_NOINTERNALPAINT  = $10;
 RDW_NOERASE          = $20;
 RDW_NOCHILDREN       = $40;
 RDW_ALLCHILDREN      = $80;
 RDW_UPDATENOW        = $100;
 RDW_ERASENOW         = $200;
 RDW_FRAME            = $400;
 RDW_NOFRAME          = $800;

 SW_SCROLLCHILDREN    = 1;
 SW_INVALIDATE        = 2;
 SW_ERASE             = 4;

 ESB_ENABLE_BOTH      = 0;
 ESB_DISABLE_BOTH     = 3;
 ESB_DISABLE_LEFT     = 1;
 ESB_DISABLE_RIGHT    = 2;
 ESB_DISABLE_UP       = 1;
 ESB_DISABLE_DOWN     = 2;
 ESB_DISABLE_LTUP     = ESB_DISABLE_LEFT;
 ESB_DISABLE_RTDN     = ESB_DISABLE_RIGHT;

 HELPINFO_WINDOW      = 1;
 HELPINFO_MENUITEM    = 2;

 MB_OK                = $00000000;
 MB_OKCANCEL          = $00000001;
 MB_ABORTRETRYIGNORE  = $00000002;
 MB_YESNOCANCEL       = $00000003;
 MB_YESNO             = $00000004;
 MB_RETRYCANCEL       = $00000005;

 MB_ICONHAND          = $00000010;
 MB_ICONQUESTION      = $00000020;
 MB_ICONEXCLAMATION   = $00000030;
 MB_ICONASTERISK      = $00000040;
 MB_USERICON          = $00000080;
 MB_ICONWARNING       = MB_ICONEXCLAMATION;
 MB_ICONERROR         = MB_ICONHAND;
 MB_ICONINFORMATION   = MB_ICONASTERISK;
 MB_ICONSTOP          = MB_ICONHAND;

 MB_DEFBUTTON1 = $00000000;
 MB_DEFBUTTON2 = $00000100;
 MB_DEFBUTTON3 = $00000200;
 MB_DEFBUTTON4 = $00000300;

 MB_APPLMODAL    = $00000000;
 MB_SYSTEMMODAL  = $00001000;
 MB_TASKMODAL    = $00002000;
 MB_HELP         = $00004000;

 MB_NOFOCUS              = $00008000;
 MB_SETFOREGROUND        = $00010000;
 MB_DEFAULT_DESKTOP_ONLY = $00020000;

 MB_TOPMOST              = $00040000;
 MB_RIGHT                = $00080000;
 MB_RTLREADING           = $00100000;

 MB_SERVICE_NOTIFICATION      = $00200000;
 MB_SERVICE_NOTIFICATION_NT3X = $00040000;

 MB_TYPEMASK = $0000000F;
 MB_ICONMASK = $000000F0;
 MB_DEFMASK  = $00000F00;
 MB_MODEMASK = $00003000;
 MB_MISCMASK = $0000C000;

 CWP_ALL             = 0;
 CWP_SKIPINVISIBLE   = 1;
 CWP_SKIPDISABLED    = 2;
 CWP_SKIPTRANSPARENT = 4;

 CTLCOLOR_MSGBOX    = 0;
 CTLCOLOR_EDIT      = 1;
 CTLCOLOR_LISTBOX   = 2;
 CTLCOLOR_BTN       = 3;
 CTLCOLOR_DLG       = 4;
 CTLCOLOR_SCROLLBAR = 5;
 CTLCOLOR_STATIC    = 6;
 CTLCOLOR_MAX       = 7;

 COLOR_SCROLLBAR           = 0;
 COLOR_BACKGROUND          = 1;
 COLOR_ACTIVECAPTION       = 2;
 COLOR_INACTIVECAPTION     = 3;
 COLOR_MENU                = 4;
 COLOR_WINDOW              = 5;
 COLOR_WINDOWFRAME         = 6;
 COLOR_MENUTEXT            = 7;
 COLOR_WINDOWTEXT          = 8;
 COLOR_CAPTIONTEXT         = 9;
 COLOR_ACTIVEBORDER        = 10;
 COLOR_INACTIVEBORDER      = 11;
 COLOR_APPWORKSPACE        = 12;
 COLOR_HIGHLIGHT           = 13;
 COLOR_HIGHLIGHTTEXT       = 14;
 COLOR_BTNFACE             = 15;
 COLOR_BTNSHADOW           = 16;
 COLOR_GRAYTEXT            = 17;
 COLOR_BTNTEXT             = 18;
 COLOR_INACTIVECAPTIONTEXT = 19;
 COLOR_BTNHIGHLIGHT        = 20;

 COLOR_3DDKSHADOW          = 21;
 COLOR_3DLIGHT             = 22;
 COLOR_INFOTEXT            = 23;
 COLOR_INFOBK              = 24;
 COLOR_ENDCOLORS           = COLOR_INFOBK;
 COLOR_DESKTOP             = COLOR_BACKGROUND;
 COLOR_3DFACE              = COLOR_BTNFACE;
 COLOR_3DSHADOW            = COLOR_BTNSHADOW;
 COLOR_3DHIGHLIGHT         = COLOR_BTNHIGHLIGHT;
 COLOR_3DHILIGHT           = COLOR_BTNHIGHLIGHT;
 COLOR_BTNHILIGHT          = COLOR_BTNHIGHLIGHT;

 GW_HWNDFIRST              = 0;
 GW_HWNDLAST               = 1;
 GW_HWNDNEXT               = 2;
 GW_HWNDPREV               = 3;
 GW_OWNER                  = 4;
 GW_CHILD                  = 5;
 GW_MAX                    = 5;

 MF_INSERT = 0;
 MF_CHANGE = $80;
 MF_APPEND = $100;
 MF_DELETE = $200;
 MF_REMOVE = $1000;

 MF_BYCOMMAND      = 0;
 MF_BYPOSITION     = $400;

 MF_SEPARATOR      = $800;

 MF_ENABLED        = 0;
 MF_GRAYED         = 1;
 MF_DISABLED       = 2;

 MF_UNCHECKED       = 0;
 MF_CHECKED         = 8;
 MF_USECHECKBITMAPS = $200;

 MF_STRING    = 0;
 MF_BITMAP    = 4;
 MF_OWNERDRAW = $100;

 MF_POPUP        = $10;
 MF_MENUBARBREAK = $20;
 MF_MENUBREAK    = $40;

 MF_UNHILITE = $00;
 MF_HILITE   = $80;

 MF_DEFAULT      = $1000;
 MF_SYSMENU      = $2000;
 MF_HELP         = $4000;
 MF_RIGHTJUSTIFY = $4000;

 MF_MOUSESELECT = $8000;
 MF_END         = $80;

 MFT_STRING       = MF_STRING;
 MFT_BITMAP       = MF_BITMAP;
 MFT_MENUBARBREAK = MF_MENUBARBREAK;
 MFT_MENUBREAK    = MF_MENUBREAK;
 MFT_OWNERDRAW    = MF_OWNERDRAW;
 MFT_RADIOCHECK   = $200;
 MFT_SEPARATOR    = MF_SEPARATOR;
 MFT_RIGHTORDER   = $2000;
 MFT_RIGHTJUSTIFY = MF_RIGHTJUSTIFY;

 MFS_GRAYED       = 3;
 MFS_DISABLED     = MFS_GRAYED;
 MFS_CHECKED      = MF_CHECKED;
 MFS_HILITE       = MF_HILITE;
 MFS_ENABLED      = MF_ENABLED;
 MFS_UNCHECKED    = MF_UNCHECKED;
 MFS_UNHILITE     = MF_UNHILITE;
 MFS_DEFAULT      = MF_DEFAULT;

 SC_SIZE          = 61440;
 SC_MOVE          = 61456;
 SC_MINIMIZE      = 61472;
 SC_MAXIMIZE      = 61488;
 SC_NEXTWINDOW    = 61504;
 SC_PREVWINDOW    = 61520;
 SC_CLOSE         = 61536;
 SC_VSCROLL       = 61552;
 SC_HSCROLL       = 61568;
 SC_MOUSEMENU     = 61584;
 SC_KEYMENU       = 61696;
 SC_ARRANGE       = 61712;
 SC_RESTORE       = 61728;
 SC_TASKLIST      = 61744;
 SC_SCREENSAVE    = 61760;
 SC_HOTKEY        = 61776;
 SC_DEFAULT       = 61792;
 SC_MONITORPOWER  = 61808;
 SC_CONTEXTHELP   = 61824;
 SC_SEPARATOR     = 61455;

 SC_ICON          = SC_MINIMIZE;
 SC_ZOOM          = SC_MAXIMIZE;

 IDC_ARROW        = MakeIntResource(32512);
 IDC_IBEAM        = MakeIntResource(32513);
 IDC_WAIT         = MakeIntResource(32514);
 IDC_CROSS        = MakeIntResource(32515);
 IDC_UPARROW      = MakeIntResource(32516);
 IDC_SIZE         = MakeIntResource(32640);
 IDC_ICON         = MakeIntResource(32641);
 IDC_SIZENWSE     = MakeIntResource(32642);
 IDC_SIZENESW     = MakeIntResource(32643);
 IDC_SIZEWE       = MakeIntResource(32644);
 IDC_SIZENS       = MakeIntResource(32645);
 IDC_SIZEALL      = MakeIntResource(32646);
 IDC_NO           = MakeIntResource(32648);
 IDC_APPSTARTING  = MakeIntResource(32650);
 IDC_HELP         = MakeIntResource(32651);

 IMAGE_BITMAP      = 0;
 IMAGE_ICON        = 1;
 IMAGE_CURSOR      = 2;
 IMAGE_ENHMETAFILE = 3;

 LR_DEFAULTCOLOR     = $0000;
 LR_MONOCHROME       = $0001;
 LR_COLOR            = $0002;
 LR_COPYRETURNORG    = $0004;
 LR_COPYDELETEORG    = $0008;
 LR_LOADFROMFILE     = $0010;
 LR_LOADTRANSPARENT  = $0020;
 LR_DEFAULTSIZE      = $0040;
 LR_VGACOLOR         = $0080;
 LR_LOADMAP3DCOLORS  = $1000;
 LR_CREATEDIBSECTION = $2000;
 LR_COPYFROMRESOURCE = $4000;
 LR_SHARED           = $8000;

 DI_MASK             = 1;
 DI_IMAGE            = 2;
 DI_NORMAL           = 3;
 DI_COMPAT           = 4;
 DI_DEFAULTSIZE      = 8;

 OBM_CLOSE               = 32754;
 OBM_UPARROW             = 32753;
 OBM_DNARROW             = 32752;
 OBM_RGARROW             = 32751;
 OBM_LFARROW             = 32750;
 OBM_REDUCE              = 32749;
 OBM_ZOOM                = 32748;
 OBM_RESTORE             = 32747;
 OBM_REDUCED             = 32746;
 OBM_ZOOMD               = 32745;
 OBM_RESTORED            = 32744;
 OBM_UPARROWD            = 32743;
 OBM_DNARROWD            = 32742;
 OBM_RGARROWD            = 32741;
 OBM_LFARROWD            = 32740;
 OBM_MNARROW             = 32739;
 OBM_COMBO               = 32738;
 OBM_UPARROWI            = 32737;
 OBM_DNARROWI            = 32736;
 OBM_RGARROWI            = 32735;
 OBM_LFARROWI            = 32734;

 OBM_OLD_CLOSE           = 32767;
 OBM_SIZE                = 32766;
 OBM_OLD_UPARROW         = 32765;
 OBM_OLD_DNARROW         = 32764;
 OBM_OLD_RGARROW         = 32763;
 OBM_OLD_LFARROW         = 32762;
 OBM_BTSIZE              = 32761;
 OBM_CHECK               = 32760;
 OBM_CHECKBOXES          = 32759;
 OBM_BTNCORNERS          = 32758;
 OBM_OLD_REDUCE          = 32757;
 OBM_OLD_ZOOM            = 32756;
 OBM_OLD_RESTORE         = 32755;

 OCR_NORMAL              = 32512;
 OCR_IBEAM               = 32513;
 OCR_WAIT                = 32514;
 OCR_CROSS               = 32515;
 OCR_UP                  = 32516;
 OCR_SIZE                = 32640;
 OCR_ICON                = 32641;
 OCR_SIZENWSE            = 32642;
 OCR_SIZENESW            = 32643;
 OCR_SIZEWE              = 32644;
 OCR_SIZENS              = 32645;
 OCR_SIZEALL             = 32646;
 OCR_ICOCUR              = 32647;
 OCR_NO                  = 32648;
 OCR_APPSTARTING         = 32650;

 OIC_SAMPLE              = 32512;
 OIC_HAND                = 32513;
 OIC_QUES                = 32514;
 OIC_BANG                = 32515;
 OIC_NOTE                = 32516;
 OIC_WINLOGO             = 32517;
 OIC_WARNING             = OIC_BANG;
 OIC_ERROR               = OIC_HAND;
 OIC_INFORMATION         = OIC_NOTE;

 RES_ICON                = 1;
 RES_CURSOR              = 2;

 ORD_LANGDRIVER          = 1;

 IDI_APPLICATION         = MakeIntResource(32512);
 IDI_HAND                = MakeIntResource(32513);
 IDI_QUESTION            = MakeIntResource(32514);
 IDI_EXCLAMATION         = MakeIntResource(32515);
 IDI_ASTERISK            = MakeIntResource(32516);
 IDI_WINLOGO             = MakeIntResource(32517);
 IDI_WARNING             = IDI_EXCLAMATION;
 IDI_ERROR               = IDI_HAND;
 IDI_INFORMATION         = IDI_ASTERISK;

 IDOK                    = 1;
 IDCANCEL                = 2;
 IDABORT                 = 3;
 IDRETRY                 = 4;
 IDIGNORE                = 5;
 IDYES                   = 6;
 IDNO                    = 7;
 IDCLOSE                 = 8;
 IDHELP                  = 9;

 ID_OK                   = IDOK;
 ID_CANCEL               = IDCANCEL;
 ID_ABORT                = IDABORT;
 ID_RETRY                = IDRETRY;
 ID_IGNORE               = IDIGNORE;
 ID_YES                  = IDYES;
 ID_NO                   = IDNO;
 ID_CLOSE                = IDCLOSE;
 ID_HELP                 = IDHELP;

 ES_LEFT                 = $0000;
 ES_CENTER               = $0001;
 ES_RIGHT                = $0002;
 ES_MULTILINE            = $0004;
 ES_UPPERCASE            = $0008;
 ES_LOWERCASE            = $0010;
 ES_PASSWORD             = $0020;
 ES_AUTOVSCROLL          = $0040;
 ES_AUTOHSCROLL          = $0080;
 ES_NOHIDESEL            = $0100;
 ES_OEMCONVERT           = $0400;
 ES_READONLY             = $0800;
 ES_WANTRETURN           = $1000;
 ES_NUMBER               = $2000;

 EC_LEFTMARGIN           = 1;
 EC_RIGHTMARGIN          = 2;
 EC_USEFONTINFO          = 65535;

 WB_LEFT                 = 0;
 WB_RIGHT                = 1;
 WB_ISDELIMITER          = 2;

 BS_PUSHBUTTON           = $0000;
 BS_DEFPUSHBUTTON        = $0001;
 BS_CHECKBOX             = $0002;
 BS_AUTOCHECKBOX         = $0003;
 BS_RADIOBUTTON          = $0004;
 BS_3STATE               = $0005;
 BS_AUTO3STATE           = $0006;
 BS_GROUPBOX             = $0007;
 BS_USERBUTTON           = $0008;
 BS_AUTORADIOBUTTON      = $0009;
 BS_OWNERDRAW            = $000B;
 BS_LEFTTEXT             = $0020;

 BS_TEXT                 = $0000;
 BS_ICON                 = $0040;
 BS_BITMAP               = $0080;
 BS_LEFT                 = $0100;
 BS_RIGHT                = $0200;
 BS_CENTER               = $0300;
 BS_TOP                  = $400;
 BS_BOTTOM               = $800;
 BS_VCENTER              = $900;
 BS_PUSHLIKE             = $1000;
 BS_MULTILINE            = $2000;
 BS_NOTIFY               = $4000;
 BS_FLAT                 = $8000;
 BS_RIGHTBUTTON          = BS_LEFTTEXT;

 BST_UNCHECKED           = 0;
 BST_CHECKED             = 1;
 BST_INDETERMINATE       = 2;
 BST_PUSHED              = 4;
 BST_FOCUS               = 8;

 SS_LEFT                 = 0;
 SS_CENTER               = 1;
 SS_RIGHT                = 2;
 SS_ICON                 = 3;
 SS_BLACKRECT            = 4;
 SS_GRAYRECT             = 5;
 SS_WHITERECT            = 6;
 SS_BLACKFRAME           = 7;
 SS_GRAYFRAME            = 8;
 SS_WHITEFRAME           = 9;
 SS_USERITEM             = 10;
 SS_SIMPLE               = 11;
 SS_LEFTNOWORDWRAP       = 12;
 SS_BITMAP               = 14;
 SS_OWNERDRAW            = 13;
 SS_ENHMETAFILE          = 15;
 SS_ETCHEDHORZ           = 16;
 SS_ETCHEDVERT           = 17;
 SS_ETCHEDFRAME          = 18;
 SS_TYPEMASK             = 31;
 SS_NOPREFIX             = 128;
 SS_NOTIFY               = 256;
 SS_CENTERIMAGE          = 512;
 SS_RIGHTJUST            = 1024;
 SS_REALSIZEIMAGE        = 2048;
 SS_SUNKEN               = 4096;
 SS_ENDELLIPSIS          = 16384;
 SS_PATHELLIPSIS         = 32768;
 SS_WORDELLIPSIS         = 49152;
 SS_ELLIPSISMASK         = 49152;

 STN_CLICKED             = 0;
 STN_DBLCLK              = 1;
 STN_ENABLE              = 2;
 STN_DISABLE             = 3;
 STM_GETICON             = 369;
 STM_SETIMAGE            = 370;
 STM_GETIMAGE            = 371;
 STM_SETICON             = 368;
 STM_MSGMAX              = 372;

 WC_DIALOG               = MakeIntAtom($8002);

 DWL_MSGRESULT           = 0;
 DWL_DLGPROC             = 4;
 DWL_USER                = 8;

 DDL_READWRITE           = 0;
 DDL_READONLY            = 1;
 DDL_HIDDEN              = 2;
 DDL_SYSTEM              = 4;
 DDL_DIRECTORY           = 16;
 DDL_ARCHIVE             = 32;

 DDL_POSTMSGS            = $2000;
 DDL_DRIVES              = $4000;
 DDL_EXCLUSIVE           = $8000;

 DS_ABSALIGN             = $0001;
 DS_SYSMODAL             = $0002;
 DS_LOCALEDIT            = $0020;
 DS_SETFONT              = $0040;
 DS_MODALFRAME           = $0080;
 DS_NOIDLEMSG            = $0100;
 DS_SETFOREGROUND        = $0200;

 DS_3DLOOK               = $0004;
 DS_FIXEDSYS             = $0008;
 DS_NOFAILCREATE         = $0010;
 DS_CONTROL              = $0400;
 DS_CENTER               = $0800;
 DS_CENTERMOUSE          = $1000;
 DS_CONTEXTHELP          = $2000;

 PSI_SETACTIVE           = 1;
 PSI_KILLACTIVE          = 2;
 PSI_APPLY               = 3;
 PSI_RESET               = 4;
 PSI_HASHELP             = 5;
 PSI_HELP                = 6;

 PSI_CHANGED             = 1;
 PSI_GUISTART            = 2;
 PSI_REBOOT              = 3;
 PSI_GETSIBLINGS         = 4;

 DC_HASDEFID             = 21323;

 DLGC_WANTARROWS         = $0001;
 DLGC_WANTTAB            = $0002;
 DLGC_WANTALLKEYS        = $0004;
 DLGC_WANTMESSAGE        = $0004;
 DLGC_HASSETSEL          = $0008;
 DLGC_DEFPUSHBUTTON      = $0010;
 DLGC_UNDEFPUSHBUTTON    = $0020;
 DLGC_RADIOBUTTON        = $0040;
 DLGC_WANTCHARS          = $0080;
 DLGC_STATIC             = $0100;
 DLGC_BUTTON             = $2000;

 LB_CTLCODE              = 0;
 LB_OKAY                 = 0;
 LB_ERR                  = -1;
 LB_ERRSPACE             = -2;

 LBS_NOTIFY              = $0001;
 LBS_SORT                = $0002;
 LBS_NOREDRAW            = $0004;
 LBS_MULTIPLESEL         = $0008;
 LBS_OWNERDRAWFIXED      = $0010;
 LBS_OWNERDRAWVARIABLE   = $0020;
 LBS_HASSTRINGS          = $0040;
 LBS_USETABSTOPS         = $0080;
 LBS_NOINTEGRALHEIGHT    = $0100;
 LBS_MULTICOLUMN         = $0200;
 LBS_WANTKEYBOARDINPUT   = $0400;
 LBS_EXTENDEDSEL         = $0800;
 LBS_DISABLENOSCROLL     = $1000;
 LBS_NODATA              = $2000;
 LBS_NOSEL               = $4000;
 LBS_STANDARD            = LBS_NOTIFY or LBS_SORT or WS_VSCROLL or WS_BORDER;


 CB_OKAY                        = 0;
 CB_ERR                         = -1;
 CB_ERRSPACE                    = -2;

 CBS_SIMPLE                     = 1;
 CBS_DROPDOWN                   = 2;
 CBS_DROPDOWNLIST               = 3;
 CBS_OWNERDRAWFIXED             = 16;
 CBS_OWNERDRAWVARIABLE          = 32;
 CBS_AUTOHSCROLL                = 64;
 CBS_OEMCONVERT                 = 128;
 CBS_SORT                       = 256;
 CBS_HASSTRINGS                 = 512;
 CBS_NOINTEGRALHEIGHT           = 1024;
 CBS_DISABLENOSCROLL            = 2048;
 CBS_UPPERCASE                  = 8192;
 CBS_LOWERCASE                  = 16384;

 SBS_HORZ                       = 0;
 SBS_VERT                       = 1;
 SBS_TOPALIGN                   = 2;
 SBS_LEFTALIGN                  = 2;
 SBS_BOTTOMALIGN                = 4;
 SBS_RIGHTALIGN                 = 4;
 SBS_SIZEBOXTOPLEFTALIGN        = 2;
 SBS_SIZEBOXBOTTOMRIGHTALIGN    = 4;
 SBS_SIZEBOX                    = 8;
 SBS_SIZEGRIP                   = 16;

 SIF_RANGE                      = 1;
 SIF_PAGE                       = 2;
 SIF_POS                        = 4;
 SIF_DISABLENOSCROLL            = 8;
 SIF_TRACKPOS                   = 16;
 SIF_ALL =                      SIF_RANGE or SIF_PAGE or
                                SIF_POS or SIF_TRACKPOS;

 MDIS_ALLCHILDSTYLES            = 1;

 MDITILE_VERTICAL               = 0;
 MDITILE_HORIZONTAL             = 1;
 MDITILE_SKIPDISABLED           = 2;

 IMC_GETCANDIDATEPOS            = $07;
 IMC_SETCANDIDATEPOS            = $08;
 IMC_GETCOMPOSITIONFONT         = $09;
 IMC_SETCOMPOSITIONFONT         = $0A;
 IMC_GETCOMPOSITIONWINDOW       = $0B;
 IMC_SETCOMPOSITIONWINDOW       = $0C;
 IMC_GETSTATUSWINDOWPOS         = $0F;
 IMC_SETSTATUSWINDOWPOS         = $10;
 IMC_CLOSESTATUSWINDOW          = $21;
 IMC_OPENSTATUSWINDOW           = $22;

 IMN_CLOSESTATUSWINDOW          = 1;
 IMN_OPENSTATUSWINDOW           = 2;
 IMN_CHANGECANDIDATE            = 3;
 IMN_CLOSECANDIDATE             = 4;
 IMN_OPENCANDIDATE              = 5;
 IMN_SETCONVERSIONMODE          = 6;
 IMN_SETSENTENCEMODE            = 7;
 IMN_SETOPENSTATUS              = 8;
 IMN_SETCANDIDATEPOS            = 9;
 IMN_SETCOMPOSITIONFONT         = 10;
 IMN_SETCOMPOSITIONWINDOW       = 11;
 IMN_SETSTATUSWINDOWPOS         = 12;
 IMN_GUIDELINE                  = 13;
 IMN_PRIVATE                    = 14;

 HELP_CONTEXT                   = 1;
 HELP_QUIT                      = 2;
 HELP_INDEX                     = 3;
 HELP_CONTENTS                  = 3;
 HELP_HELPONHELP                = 4;
 HELP_SETINDEX                  = 5;
 HELP_SETCONTENTS               = 5;
 HELP_CONTEXTPOPUP              = 8;
 HELP_FORCEFILE                 = 9;
 HELP_KEY                       = 257;
 HELP_COMMAND                   = 258;
 HELP_PARTIALKEY                = 261;
 HELP_MULTIKEY                  = 513;
 HELP_SETWINPOS                 = 515;
 HELP_CONTEXTMENU               = 10;
 HELP_FINDER                    = 11;
 HELP_WM_HELP                   = 12;
 HELP_SETPOPUP_POS              = 13;

 HELP_TCARD                     = $8000;
 HELP_TCARD_DATA                = $0010;
 HELP_TCARD_OTHER_CALLER        = $0011;

 IDH_NO_HELP                    = 28440;
 IDH_MISSING_CONTEXT            = 28441;
 IDH_GENERIC_HELP_BUTTON        = 28442;
 IDH_OK                         = 28443;
 IDH_CANCEL                     = 28444;
 IDH_HELP                       = 28445;

 SPI_GETBEEP                    = 1;
 SPI_SETBEEP                    = 2;
 SPI_GETMOUSE                   = 3;
 SPI_SETMOUSE                   = 4;
 SPI_GETBORDER                  = 5;
 SPI_SETBORDER                  = 6;
 SPI_GETKEYBOARDSPEED           = 10;
 SPI_SETKEYBOARDSPEED           = 11;
 SPI_LANGDRIVER                 = 12;
 SPI_ICONHORIZONTALSPACING      = 13;
 SPI_GETSCREENSAVETIMEOUT       = 14;
 SPI_SETSCREENSAVETIMEOUT       = 15;
 SPI_GETSCREENSAVEACTIVE        = 16;
 SPI_SETSCREENSAVEACTIVE        = 17;
 SPI_GETGRIDGRANULARITY         = 18;
 SPI_SETGRIDGRANULARITY         = 19;
 SPI_SETDESKWALLPAPER           = 20;
 SPI_SETDESKPATTERN             = 21;
 SPI_GETKEYBOARDDELAY           = 22;
 SPI_SETKEYBOARDDELAY           = 23;
 SPI_ICONVERTICALSPACING        = 24;
 SPI_GETICONTITLEWRAP           = 25;
 SPI_SETICONTITLEWRAP           = 26;
 SPI_GETMENUDROPALIGNMENT       = 27;
 SPI_SETMENUDROPALIGNMENT       = 28;
 SPI_SETDOUBLECLKWIDTH          = 29;
 SPI_SETDOUBLECLKHEIGHT         = 30;
 SPI_GETICONTITLELOGFONT        = 31;
 SPI_SETDOUBLECLICKTIME         = 32;
 SPI_SETMOUSEBUTTONSWAP         = 33;
 SPI_SETICONTITLELOGFONT        = 34;
 SPI_GETFASTTASKSWITCH          = 35;
 SPI_SETFASTTASKSWITCH          = 36;
 SPI_SETDRAGFULLWINDOWS         = 37;
 SPI_GETDRAGFULLWINDOWS         = 38;
 SPI_GETNONCLIENTMETRICS        = 41;
 SPI_SETNONCLIENTMETRICS        = 42;
 SPI_GETMINIMIZEDMETRICS        = 43;
 SPI_SETMINIMIZEDMETRICS        = 44;
 SPI_GETICONMETRICS             = 45;
 SPI_SETICONMETRICS             = 46;
 SPI_SETWORKAREA                = 47;
 SPI_GETWORKAREA                = 48;
 SPI_SETPENWINDOWS              = 49;
 SPI_GETHIGHCONTRAST            = 66;
 SPI_SETHIGHCONTRAST            = 67;
 SPI_GETKEYBOARDPREF            = 68;
 SPI_SETKEYBOARDPREF            = 69;
 SPI_GETSCREENREADER            = 70;
 SPI_SETSCREENREADER            = 71;
 SPI_GETANIMATION               = 72;
 SPI_SETANIMATION               = 73;
 SPI_GETFONTSMOOTHING           = 74;
 SPI_SETFONTSMOOTHING           = 75;
 SPI_SETDRAGWIDTH               = 76;
 SPI_SETDRAGHEIGHT              = 77;
 SPI_SETHANDHELD                = 78;
 SPI_GETLOWPOWERTIMEOUT         = 79;
 SPI_GETPOWEROFFTIMEOUT         = 80;
 SPI_SETLOWPOWERTIMEOUT         = 81;
 SPI_SETPOWEROFFTIMEOUT         = 82;
 SPI_GETLOWPOWERACTIVE          = 83;
 SPI_GETPOWEROFFACTIVE          = 84;
 SPI_SETLOWPOWERACTIVE          = 85;
 SPI_SETPOWEROFFACTIVE          = 86;
 SPI_SETCURSORS                 = 87;
 SPI_SETICONS                   = 88;
 SPI_GETDEFAULTINPUTLANG        = 89;
 SPI_SETDEFAULTINPUTLANG        = 90;
 SPI_SETLANGTOGGLE              = 91;
 SPI_GETWINDOWSEXTENSION        = 92;
 SPI_SETMOUSETRAILS             = 93;
 SPI_GETMOUSETRAILS             = 94;
 SPI_SCREENSAVERRUNNING         = 97;
 SPI_GETFILTERKEYS              = 50;
 SPI_SETFILTERKEYS              = 51;
 SPI_GETTOGGLEKEYS              = 52;
 SPI_SETTOGGLEKEYS              = 53;
 SPI_GETMOUSEKEYS               = 54;
 SPI_SETMOUSEKEYS               = 55;
 SPI_GETSHOWSOUNDS              = 56;
 SPI_SETSHOWSOUNDS              = 57;
 SPI_GETSTICKYKEYS              = 58;
 SPI_SETSTICKYKEYS              = 59;
 SPI_GETACCESSTIMEOUT           = 60;
 SPI_SETACCESSTIMEOUT           = 61;
 SPI_GETSERIALKEYS              = 62;
 SPI_SETSERIALKEYS              = 63;
 SPI_GETSOUNDSENTRY             = 64;
 SPI_SETSOUNDSENTRY             = 65;
 SPI_GETSNAPTODEFBUTTON         = 95;
 SPI_SETSNAPTODEFBUTTON         = 96;
 SPI_GETMOUSEHOVERWIDTH         = 98;
 SPI_SETMOUSEHOVERWIDTH         = 99;
 SPI_GETMOUSEHOVERHEIGHT        = 100;
 SPI_SETMOUSEHOVERHEIGHT        = 101;
 SPI_GETMOUSEHOVERTIME          = 102;
 SPI_SETMOUSEHOVERTIME          = 103;
 SPI_GETWHEELSCROLLLINES        = 104;
 SPI_SETWHEELSCROLLLINES        = 105;

 SPIF_UPDATEINIFILE             = 1;
 SPIF_SENDWININICHANGE          = 2;
 SPIF_SENDCHANGE                = SPIF_SENDWININICHANGE;

 METRICS_USEDEFAULT             = -1;

 ARW_BOTTOMLEFT                 = 0;
 ARW_BOTTOMRIGHT                = 1;
 ARW_TOPLEFT                    = 2;
 ARW_TOPRIGHT                   = 3;
 ARW_STARTMASK                  = 3;
 ARW_STARTRIGHT                 = 1;
 ARW_STARTTOP                   = 2;

 ARW_LEFT                       = 0;
 ARW_RIGHT                      = 0;
 ARW_UP                         = 4;
 ARW_DOWN                       = 4;
 ARW_HIDE                       = 8;
 ARW_VALID                      = 15;

 SERKF_SERIALKEYSON             = 1;
 SERKF_AVAILABLE                = 2;
 SERKF_INDICATOR                = 4;

 HCF_HIGHCONTRASTON      = $00000001;
 HCF_AVAILABLE           = $00000002;
 HCF_HOTKEYACTIVE        = $00000004;
 HCF_CONFIRMHOTKEY       = $00000008;
 HCF_HOTKEYSOUND         = $00000010;
 HCF_INDICATOR           = $00000020;
 HCF_HOTKEYAVAILABLE     = $00000040;

 CDS_UPDATEREGISTRY      = $00000001;
 CDS_TEST                = $00000002;
 CDS_FULLSCREEN          = $00000004;
 CDS_GLOBAL              = $00000008;
 CDS_SET_PRIMARY         = $00000010;
 CDS_RESET               = $40000000;
 CDS_SETRECT             = $20000000;
 CDS_NORESET             = $10000000;

 DISP_CHANGE_SUCCESSFUL           = 0;
 DISP_CHANGE_RESTART              = 1;
 DISP_CHANGE_FAILED               = -1;
 DISP_CHANGE_BADMODE              = -2;
 DISP_CHANGE_NOTUPDATED           = -3;
 DISP_CHANGE_BADFLAGS             = -4;
 DISP_CHANGE_BADPARAM             = -5;

 FKF_FILTERKEYSON                 = $01;
 FKF_AVAILABLE                    = $02;
 FKF_HOTKEYACTIVE                 = $04;
 FKF_CONFIRMHOTKEY                = $08;
 FKF_HOTKEYSOUND                  = $10;
 FKF_INDICATOR                    = $20;
 FKF_CLICKON                      = $40;

 SKF_STICKYKEYSON                 = $01;
 SKF_AVAILABLE                    = $02;
 SKF_HOTKEYACTIVE                 = $04;
 SKF_CONFIRMHOTKEY                = $08;
 SKF_HOTKEYSOUND                  = $10;
 SKF_INDICATOR                    = $20;
 SKF_AUDIBLEFEEDBACK              = $40;
 SKF_TRISTATE                     = $80;
 SKF_TWOKEYSOFF                   = $100;

 MKF_MOUSEKEYSON                  = $01;
 MKF_AVAILABLE                    = $02;
 MKF_HOTKEYACTIVE                 = $04;
 MKF_CONFIRMHOTKEY                = $08;
 MKF_HOTKEYSOUND                  = $10;
 MKF_INDICATOR                    = $20;
 MKF_MODIFIERS                    = $40;
 MKF_REPLACENUMBERS               = $80;

 ATF_TIMEOUTON                    = 1;
 ATF_ONOFFFEEDBACK                = 2;

 SSGF_NONE                        = 0;
 SSGF_DISPLAY                     = 3;

 SSTF_NONE                        = 0;
 SSTF_CHARS                       = 1;
 SSTF_BORDER                      = 2;
 SSTF_DISPLAY                     = 3;

 SSWF_NONE                        = 0;
 SSWF_TITLE                       = 1;
 SSWF_WINDOW                      = 2;
 SSWF_DISPLAY                     = 3;
 SSWF_CUSTOM                      = 4;

 SSF_SOUNDSENTRYON                = 1;
 SSF_AVAILABLE                    = 2;
 SSF_INDICATOR                    = 4;

 TKF_TOGGLEKEYSON                 = $01;
 TKF_AVAILABLE                    = $02;
 TKF_HOTKEYACTIVE                 = $04;
 TKF_CONFIRMHOTKEY                = $08;
 TKF_HOTKEYSOUND                  = $10;
 TKF_INDICATOR                    = $20;

 SLE_ERROR                        = 1;
 SLE_MINORERROR                   = 2;
 SLE_WARNING                      = 3;

 MAX_LEADBYTES                    = 12;
 MAX_DEFAULTCHAR                  = 2;

 MB_PRECOMPOSED                   = 1;
 MB_COMPOSITE                     = 2;
 MB_USEGLYPHCHARS                 = 4;

 WC_DISCARDNS                     = $0010;
 WC_SEPCHARS                      = $0020;
 WC_DEFAULTCHAR                   = $0040;
 WC_DEFAULTCHECK                  = $0100;
 WC_COMPOSITECHECK                = $0200;

 CT_CTYPE1                        = 1;
 CT_CTYPE2                        = 2;
 CT_CTYPE3                        = 4;

 C1_UPPER                         = $0001;
 C1_LOWER                         = $0002;
 C1_DIGIT                         = $0004;
 C1_SPACE                         = $0008;
 C1_PUNCT                         = $0010;
 C1_CNTRL                         = $0020;
 C1_BLANK                         = $0040;
 C1_XDIGIT                        = $0080;
 C1_ALPHA                         = $0100;

 C2_LEFTTORIGHT                   = 1;
 C2_RIGHTTOLEFT                   = 2;
 C2_EUROPENUMBER                  = 3;
 C2_EUROPESEPARATOR               = 4;
 C2_EUROPETERMINATOR              = 5;
 C2_ARABICNUMBER                  = 6;
 C2_COMMONSEPARATOR               = 7;
 C2_BLOCKSEPARATOR                = 8;
 C2_SEGMENTSEPARATOR              = 9;
 C2_WHITESPACE                    = 10;
 C2_OTHERNEUTRAL                  = 11;
 C2_NOTAPPLICABLE                 = 0;

 C3_NONSPACING                    = 1;
 C3_DIACRITIC                     = 2;
 C3_VOWELMARK                     = 4;
 C3_SYMBOL                        = 8;
 C3_NOTAPPLICABLE                 = 0;

 NORM_IGNORECASE                  = $000001;
 NORM_IGNORENONSPACE              = $000002;
 NORM_IGNORESYMBOLS               = $000004;
 NORM_IGNOREKANATYPE              = $010000;
 NORM_IGNOREWIDTH                 = $020000;

 MAP_FOLDCZONE                    = $10;
 MAP_PRECOMPOSED                  = $20;
 MAP_COMPOSITE                    = $40;
 MAP_FOLDDIGITS                   = $80;

 LCMAP_LOWERCASE                  = $00000100;
 LCMAP_UPPERCASE                  = $00000200;
 LCMAP_SORTKEY                    = $00000400;
 LCMAP_BYTEREV                    = $00000800;
 LCMAP_HIRAGANA                   = $00100000;
 LCMAP_KATAKANA                   = $00200000;
 LCMAP_HALFWIDTH                  = $00400000;
 LCMAP_FULLWIDTH                  = $00800000;
 LCMAP_LINGUISTIC_CASING          = $01000000;
 LCMAP_SIMPLIFIED_CHINESE         = $02000000;
 LCMAP_TRADITIONAL_CHINESE        = $04000000;
 LCID_INSTALLED                   = $00000001;
 LCID_SUPPORTED                   = $00000002;

 CP_INSTALLED                     = $00000001;
 CP_SUPPORTED                     = $00000002;
 CP_ACP                           = $00000000;
 CP_OEMCP                         = $00000001;
 CP_MACCP                         = $00000002;
 CP_UTF7                          = $0000FDE8;
 CP_UTF8                          = $0000FDE9;

 SORT_STRINGSORT                  = $1000;

 CTRY_DEFAULT                     = 0;
 CTRY_AUSTRALIA                   = 61;
 CTRY_AUSTRIA                     = 43;
 CTRY_BELGIUM                     = 32;
 CTRY_BRAZIL                      = 55;
 CTRY_CANADA                      = 2;
 CTRY_DENMARK                     = 45;
 CTRY_FINLAND                     = 358;
 CTRY_FRANCE                      = 33;
 CTRY_GERMANY                     = 49;
 CTRY_ICELAND                     = 354;
 CTRY_IRELAND                     = 353;
 CTRY_ITALY                       = 39;
 CTRY_JAPAN                       = 81;
 CTRY_MEXICO                      = 52;
 CTRY_NETHERLANDS                 = 31;
 CTRY_NEW_ZEALAND                 = 64;
 CTRY_NORWAY                      = 47;
 CTRY_PORTUGAL                    = 351;
 CTRY_PRCHINA                     = 86;
 CTRY_SOUTH_KOREA                 = 82;
 CTRY_SPAIN                       = 34;
 CTRY_SWEDEN                      = 46;
 CTRY_SWITZERLAND                 = 41;
 CTRY_TAIWAN                      = 886;
 CTRY_UNITED_KINGDOM              = 44;
 CTRY_UNITED_STATES               = 1;

 LOCALE_NOUSEROVERRIDE           = $80000000;
 LOCALE_USE_CP_ACP               = $40000000;
 LOCALE_ILANGUAGE                = $00000001;
 LOCALE_SLANGUAGE                = $00000002;
 LOCALE_SENGLANGUAGE             = $00001001;
 LOCALE_SABBREVLANGNAME          = $00000003;
 LOCALE_SNATIVELANGNAME          = $00000004;
 LOCALE_ICOUNTRY                 = $00000005;
 LOCALE_SCOUNTRY                 = $00000006;
 LOCALE_SENGCOUNTRY              = $00001002;
 LOCALE_SABBREVCTRYNAME          = $00000007;
 LOCALE_SNATIVECTRYNAME          = $00000008;
 LOCALE_IDEFAULTLANGUAGE         = $00000009;
 LOCALE_IDEFAULTCOUNTRY          = $0000000A;
 LOCALE_IDEFAULTCODEPAGE         = $0000000B;
 LOCALE_IDEFAULTANSICODEPAGE     = $00001004;
 LOCALE_IDEFAULTMACCODEPAGE      = $00001011;
 LOCALE_SLIST                    = $0000000C;
 LOCALE_IMEASURE                 = $0000000D;
 LOCALE_SDECIMAL                 = $0000000E;
 LOCALE_STHOUSAND                = $0000000F;
 LOCALE_SGROUPING                = $00000010;
 LOCALE_IDIGITS                  = $00000011;
 LOCALE_ILZERO                   = $00000012;
 LOCALE_INEGNUMBER               = $00001010;
 LOCALE_SNATIVEDIGITS            = $00000013;
 LOCALE_SCURRENCY                = $00000014;
 LOCALE_SINTLSYMBOL              = $00000015;
 LOCALE_SMONDECIMALSEP           = $00000016;
 LOCALE_SMONTHOUSANDSEP          = $00000017;
 LOCALE_SMONGROUPING             = $00000018;
 LOCALE_ICURRDIGITS              = $00000019;
 LOCALE_IINTLCURRDIGITS          = $0000001A;
 LOCALE_ICURRENCY                = $0000001B;
 LOCALE_INEGCURR                 = $0000001C;
 LOCALE_SDATE                    = $0000001D;
 LOCALE_STIME                    = $0000001E;
 LOCALE_SSHORTDATE               = $0000001F;
 LOCALE_SLONGDATE                = $00000020;
 LOCALE_STIMEFORMAT              = $00001003;
 LOCALE_IDATE                    = $00000021;
 LOCALE_ILDATE                   = $00000022;
 LOCALE_ITIME                    = $00000023;
 LOCALE_ITIMEMARKPOSN            = $00001005;
 LOCALE_ICENTURY                 = $00000024;
 LOCALE_ITLZERO                  = $00000025;
 LOCALE_IDAYLZERO                = $00000026;
 LOCALE_IMONLZERO                = $00000027;
 LOCALE_S1159                    = $00000028;
 LOCALE_S2359                    = $00000029;
 LOCALE_ICALENDARTYPE            = $00001009;
 LOCALE_IOPTIONALCALENDAR        = $0000100B;
 LOCALE_IFIRSTDAYOFWEEK          = $0000100C;
 LOCALE_IFIRSTWEEKOFYEAR         = $0000100D;
 LOCALE_SDAYNAME1                = $0000002A;
 LOCALE_SDAYNAME2                = $0000002B;
 LOCALE_SDAYNAME3                = $0000002C;
 LOCALE_SDAYNAME4                = $0000002D;
 LOCALE_SDAYNAME5                = $0000002E;
 LOCALE_SDAYNAME6                = $0000002F;
 LOCALE_SDAYNAME7                = $00000030;
 LOCALE_SABBREVDAYNAME1          = $00000031;
 LOCALE_SABBREVDAYNAME2          = $00000032;
 LOCALE_SABBREVDAYNAME3          = $00000033;
 LOCALE_SABBREVDAYNAME4          = $00000034;
 LOCALE_SABBREVDAYNAME5          = $00000035;
 LOCALE_SABBREVDAYNAME6          = $00000036;
 LOCALE_SABBREVDAYNAME7          = $00000037;
 LOCALE_SMONTHNAME1              = $00000038;
 LOCALE_SMONTHNAME2              = $00000039;
 LOCALE_SMONTHNAME3              = $0000003A;
 LOCALE_SMONTHNAME4              = $0000003B;
 LOCALE_SMONTHNAME5              = $0000003C;
 LOCALE_SMONTHNAME6              = $0000003D;
 LOCALE_SMONTHNAME7              = $0000003E;
 LOCALE_SMONTHNAME8              = $0000003F;
 LOCALE_SMONTHNAME9              = $00000040;
 LOCALE_SMONTHNAME10             = $00000041;
 LOCALE_SMONTHNAME11             = $00000042;
 LOCALE_SMONTHNAME12             = $00000043;
 LOCALE_SMONTHNAME13             = $0000100E;
 LOCALE_SABBREVMONTHNAME1        = $00000044;
 LOCALE_SABBREVMONTHNAME2        = $00000045;
 LOCALE_SABBREVMONTHNAME3        = $00000046;
 LOCALE_SABBREVMONTHNAME4        = $00000047;
 LOCALE_SABBREVMONTHNAME5        = $00000048;
 LOCALE_SABBREVMONTHNAME6        = $00000049;
 LOCALE_SABBREVMONTHNAME7        = $0000004A;
 LOCALE_SABBREVMONTHNAME8        = $0000004B;
 LOCALE_SABBREVMONTHNAME9        = $0000004C;
 LOCALE_SABBREVMONTHNAME10       = $0000004D;
 LOCALE_SABBREVMONTHNAME11       = $0000004E;
 LOCALE_SABBREVMONTHNAME12       = $0000004F;
 LOCALE_SABBREVMONTHNAME13       = $0000100F;
 LOCALE_SPOSITIVESIGN            = $00000050;
 LOCALE_SNEGATIVESIGN            = $00000051;
 LOCALE_IPOSSIGNPOSN             = $00000052;
 LOCALE_INEGSIGNPOSN             = $00000053;
 LOCALE_IPOSSYMPRECEDES          = $00000054;
 LOCALE_IPOSSEPBYSPACE           = $00000055;
 LOCALE_INEGSYMPRECEDES          = $00000056;
 LOCALE_INEGSEPBYSPACE           = $00000057;
 LOCALE_FONTSIGNATURE            = $00000058;
 LOCALE_SISO639LANGNAME          = $00000059;
 LOCALE_SISO3166CTRYNAME         = $0000005A;

 TIME_NOMINUTESORSECONDS         = 1;
 TIME_NOSECONDS                  = 2;
 TIME_NOTIMEMARKER               = 4;
 TIME_FORCE24HOURFORMAT          = 8;

 DATE_SHORTDATE                  = 1;
 DATE_LONGDATE                   = 2;
 DATE_USE_ALT_CALENDAR           = 4;

 CAL_ICALINTVALUE                = 1;
 CAL_SCALNAME                    = 2;
 CAL_IYEAROFFSETRANGE            = 3;
 CAL_SERASTRING                  = 4;
 CAL_SSHORTDATE                  = 5;
 CAL_SLONGDATE                   = 6;
 CAL_SDAYNAME1                   = 7;
 CAL_SDAYNAME2                   = 8;
 CAL_SDAYNAME3                   = 9;
 CAL_SDAYNAME4                   = 10;
 CAL_SDAYNAME5                   = 11;
 CAL_SDAYNAME6                   = 12;
 CAL_SDAYNAME7                   = 13;
 CAL_SABBREVDAYNAME1             = 14;
 CAL_SABBREVDAYNAME2             = 15;
 CAL_SABBREVDAYNAME3             = 16;
 CAL_SABBREVDAYNAME4             = 17;
 CAL_SABBREVDAYNAME5             = 18;
 CAL_SABBREVDAYNAME6             = 19;
 CAL_SABBREVDAYNAME7             = 20;
 CAL_SMONTHNAME1                 = 21;
 CAL_SMONTHNAME2                 = 22;
 CAL_SMONTHNAME3                 = 23;
 CAL_SMONTHNAME4                 = 24;
 CAL_SMONTHNAME5                 = 25;
 CAL_SMONTHNAME6                 = 26;
 CAL_SMONTHNAME7                 = 27;
 CAL_SMONTHNAME8                 = 28;
 CAL_SMONTHNAME9                 = 29;
 CAL_SMONTHNAME10                = 30;
 CAL_SMONTHNAME11                = 31;
 CAL_SMONTHNAME12                = 32;
 CAL_SMONTHNAME13                = 33;
 CAL_SABBREVMONTHNAME1           = 34;
 CAL_SABBREVMONTHNAME2           = 35;
 CAL_SABBREVMONTHNAME3           = 36;
 CAL_SABBREVMONTHNAME4           = 37;
 CAL_SABBREVMONTHNAME5           = 38;
 CAL_SABBREVMONTHNAME6           = 39;
 CAL_SABBREVMONTHNAME7           = 40;
 CAL_SABBREVMONTHNAME8           = 41;
 CAL_SABBREVMONTHNAME9           = 42;
 CAL_SABBREVMONTHNAME10          = 43;
 CAL_SABBREVMONTHNAME11          = 44;
 CAL_SABBREVMONTHNAME12          = 45;
 CAL_SABBREVMONTHNAME13          = 46;
 CAL_GREGORIAN                   = 1;
 CAL_GREGORIAN_US                = 2;
 CAL_JAPAN                       = 3;
 CAL_TAIWAN                      = 4;
 CAL_KOREA                       = 5;
 CAL_HIJRI                       = 6;
 CAL_THAI                        = 7;
 CAL_HEBREW                      = 8;

 ENUM_ALL_CALENDARS              = $FFFFFFFF;

 RIGHT_ALT_PRESSED               = 1;
 LEFT_ALT_PRESSED                = 2;
 RIGHT_CTRL_PRESSED              = 4;
 LEFT_CTRL_PRESSED               = 8;
 SHIFT_PRESSED                   = 16;
 NUMLOCK_ON                      = 32;
 SCROLLLOCK_ON                   = 64;
 CAPSLOCK_ON                     = 128;
 ENHANCED_KEY                    = 256;

 FROM_LEFT_1ST_BUTTON_PRESSED   = 1;
 RIGHTMOST_BUTTON_PRESSED       = 2;
 FROM_LEFT_2ND_BUTTON_PRESSED   = 4;
 FROM_LEFT_3RD_BUTTON_PRESSED   = 8;
 FROM_LEFT_4TH_BUTTON_PRESSED   = 16;

 MOUSE_MOVED                    = 1;
 DOUBLE_CLICK                   = 2;

 KEY_EVENT                      = 1;
 _MOUSE_EVENT                   = 2;
 WINDOW_BUFFER_SIZE_EVENT       = 4;
 MENU_EVENT                     = 8;
 FOCUS_EVENT                    = 16;

 FOREGROUND_BLUE                = 1;
 FOREGROUND_GREEN               = 2;
 FOREGROUND_RED                 = 4;
 FOREGROUND_INTENSITY           = 8;
 BACKGROUND_BLUE                = 16;
 BACKGROUND_GREEN               = 32;
 BACKGROUND_RED                 = 64;
 BACKGROUND_INTENSITY           = 128;

 CTRL_C_EVENT                   = 0;
 CTRL_BREAK_EVENT               = 1;
 CTRL_CLOSE_EVENT               = 2;

 CTRL_LOGOFF_EVENT              = 5;
 CTRL_SHUTDOWN_EVENT            = 6;
 ENABLE_PROCESSED_INPUT         = 1;
 ENABLE_LINE_INPUT              = 2;
 ENABLE_ECHO_INPUT              = 4;
 ENABLE_WINDOW_INPUT            = 8;
 ENABLE_MOUSE_INPUT             = 16;
 ENABLE_PROCESSED_OUTPUT        = 1;
 ENABLE_WRAP_AT_EOL_OUTPUT      = 2;

 CONSOLE_TEXTMODE_BUFFER        = 1;

 VS_FILE_INFO                   = RT_VERSION;
 VS_VERSION_INFO                = 1;
 VS_USER_DEFINED                = 100;
 VS_FFI_STRUCVERSION            = 65536;
 VS_FFI_FILEFLAGSMASK           = 63;
 VS_FF_DEBUG                    = 1;
 VS_FF_PRERELEASE               = 2;
 VS_FF_PATCHED                  = 4;
 VS_FF_PRIVATEBUILD             = 8;
 VS_FF_INFOINFERRED             = 16;
 VS_FF_SPECIALBUILD             = 32;
 VS_FFI_SIGNATURE               = $FEEF04BD;

 VOS_UNKNOWN                    = $00000;
 VOS_DOS                        = $10000;
 VOS_OS216                      = $20000;
 VOS_OS232                      = $30000;
 VOS_NT                         = $40000;

 VOS__BASE                      = $00000;
 VOS__WINDOWS16                 = $00001;
 VOS__PM16                      = $00002;
 VOS__PM32                      = $00003;
 VOS__WINDOWS32                 = $00004;
 VOS_DOS_WINDOWS16              = $10001;
 VOS_DOS_WINDOWS32              = $10004;
 VOS_OS216_PM16                 = $20002;
 VOS_OS232_PM32                 = $30003;
 VOS_NT_WINDOWS32               = $40004;

 VFT_UNKNOWN           = 0;
 VFT_APP               = 1;
 VFT_DLL               = 2;
 VFT_DRV               = 3;
 VFT_FONT              = 4;
 VFT_VXD               = 5;
 VFT_STATIC_LIB        = 7;

 VFT2_FONT_RASTER      = 1;
 VFT2_FONT_VECTOR      = 2;
 VFT2_FONT_TRUETYPE    = 3;
 VFT2_UNKNOWN          = 0;
 VFT2_DRV_PRINTER      = 1;
 VFT2_DRV_KEYBOARD     = 2;
 VFT2_DRV_LANGUAGE     = 3;
 VFT2_DRV_DISPLAY      = 4;
 VFT2_DRV_MOUSE        = 5;
 VFT2_DRV_NETWORK      = 6;
 VFT2_DRV_SYSTEM       = 7;
 VFT2_DRV_INSTALLABLE  = 8;
 VFT2_DRV_SOUND        = 9;
 VFT2_DRV_COMM         = 10;

 VFFF_ISSHAREDFILE = 1;

 VFF_CURNEDEST = 1;
 VFF_FILEINUSE = 2;
 VFF_BUFFTOOSMALL = 4;

 VIFF_FORCEINSTALL     = 1;
 VIFF_DONTDELETEOLD    = 2;

 VIF_TEMPFILE          = $00001;
 VIF_MISMATCH          = $00002;
 VIF_SRCOLD            = $00004;

 VIF_DIFFLANG          = $00008;
 VIF_DIFFCODEPG        = $00010;
 VIF_DIFFTYPE          = $00020;

 VIF_WRITEPROT         = $00040;
 VIF_FILEINUSE         = $00080;
 VIF_OUTOFSPACE        = $00100;
 VIF_ACCESSVIOLATION   = $00200;
 VIF_SHARINGVIOLATION  = $00400;
 VIF_CANNOTCREATE      = $00800;
 VIF_CANNOTDELETE      = $01000;
 VIF_CANNOTRENAME      = $02000;
 VIF_CANNOTDELETECUR   = $04000;
 VIF_OUTOFMEMORY       = $08000;
 VIF_CANNOTREADSRC     = $10000;
 VIF_CANNOTREADDST     = $20000;
 VIF_BUFFTOOSMALL      = $40000;

 HKEY_CLASSES_ROOT     = $80000000;
 HKEY_CURRENT_USER     = $80000001;
 HKEY_LOCAL_MACHINE    = $80000002;
 HKEY_USERS            = $80000003;
 HKEY_PERFORMANCE_DATA = $80000004;
 HKEY_CURRENT_CONFIG   = $80000005;
 HKEY_DYN_DATA         = $80000006;

 PROVIDER_KEEPS_VALUE_LENGTH = 1;

 WNNC_NET_MSNET              = $00010000;
 WNNC_NET_LANMAN             = $00020000;
 WNNC_NET_NETWARE            = $00030000;
 WNNC_NET_VINES              = $00040000;
 WNNC_NET_10NET              = $00050000;
 WNNC_NET_LOCUS              = $00060000;
 WNNC_NET_SUN_PC_NFS         = $00070000;
 WNNC_NET_LANSTEP            = $00080000;
 WNNC_NET_9TILES             = $00090000;
 WNNC_NET_LANTASTIC          = $000A0000;
 WNNC_NET_AS400              = $000B0000;
 WNNC_NET_FTP_NFS            = $000C0000;
 WNNC_NET_PATHWORKS          = $000D0000;
 WNNC_NET_LIFENET            = $000E0000;
 WNNC_NET_POWERLAN           = $000F0000;
 WNNC_NET_BWNFS              = $00100000;
 WNNC_NET_COGENT             = $00110000;
 WNNC_NET_FARALLON           = $00120000;
 WNNC_NET_APPLETALK          = $00130000;
 WNNC_NET_INTERGRAPH         = $00140000;
 WNNC_NET_SYMFONET           = $00150000;
 WNNC_NET_CLEARCASE          = $00160000;

 RESOURCE_CONNECTED          = 1;
 RESOURCE_GLOBALNET          = 2;
 RESOURCE_REMEMBERED         = 3;
 RESOURCE_RECENT             = 4;
 RESOURCE_CONTEXT            = 5;

 RESOURCETYPE_ANY            = 0;
 RESOURCETYPE_DISK           = 1;
 RESOURCETYPE_PRINT          = 2;
 RESOURCETYPE_RESERVED       = 8;
 RESOURCETYPE_UNKNOWN        = $FFFFFFFF;

 RESOURCEUSAGE_CONNECTABLE   = 1;
 RESOURCEUSAGE_CONTAINER     = 2;
 RESOURCEUSAGE_NOLOCALDEVICE = 4;
 RESOURCEUSAGE_SIBLING       = 8;

 RESOURCEUSAGE_ATTACHED = $00000010;
 RESOURCEUSAGE_ALL      = RESOURCEUSAGE_CONNECTABLE or
                          RESOURCEUSAGE_CONTAINER or RESOURCEUSAGE_ATTACHED;
 RESOURCEUSAGE_RESERVED = $80000000;

 RESOURCEDISPLAYTYPE_GENERIC            = $00000000;
 RESOURCEDISPLAYTYPE_DOMAIN             = $00000001;
 RESOURCEDISPLAYTYPE_SERVER             = $00000002;
 RESOURCEDISPLAYTYPE_SHARE              = $00000003;
 RESOURCEDISPLAYTYPE_FILE               = $00000004;
 RESOURCEDISPLAYTYPE_GROUP              = $00000005;
 RESOURCEDISPLAYTYPE_NETWORK            = $00000006;
 RESOURCEDISPLAYTYPE_ROOT               = $00000007;
 RESOURCEDISPLAYTYPE_SHAREADMIN         = $00000008;
 RESOURCEDISPLAYTYPE_DIRECTORY          = $00000009;
 RESOURCEDISPLAYTYPE_TREE               = $0000000A;
 RESOURCEDISPLAYTYPE_NDSCONTAINER       = $0000000B;

 NETPROPERTY_PERSISTENT = 1;

 CONNECT_UPDATE_PROFILE          = $00000001;
 CONNECT_UPDATE_RECENT           = $00000002;
 CONNECT_TEMPORARY               = $00000004;
 CONNECT_INTERACTIVE             = $00000008;
 CONNECT_PROMPT                  = $00000010;
 CONNECT_NEED_DRIVE              = $00000020;
 CONNECT_REFCOUNT                = $00000040;
 CONNECT_REDIRECT                = $00000080;
 CONNECT_LOCALDRIVE              = $00000100;
 CONNECT_CURRENT_MEDIA           = $00000200;
 CONNECT_DEFERRED                = $00000400;
 CONNECT_RESERVED                = $FF000000;

 CONNDLG_RO_PATH     = 1;
 CONNDLG_CONN_POINT  = 2;
 CONNDLG_USE_MRU     = 4;
 CONNDLG_HIDE_BOX    = 8;
 CONNDLG_PERSIST     = $10;
 CONNDLG_NOT_PERSIST = $20;

 DISC_UPDATE_PROFILE = 1;
 DISC_NO_FORCE       = $40;

 UNIVERSAL_NAME_INFO_LEVEL = 1;
 REMOTE_NAME_INFO_LEVEL    = 2;

 WNFMT_MULTILINE   = 1;
 WNFMT_ABBREVIATED = 2;
 WNFMT_INENUM      = $10;
 WNFMT_CONNECTION  = $20;

 NETINFO_DLL16      = 1;
 NETINFO_DISKRED    = 4;
 NETINFO_PRINTERRED = 8;

 RP_LOGON   = 1;
 RP_INIFILE = 2;

 PP_DISPLAYERRORS = 1;

 WN_SUCCESS                             = NO_ERROR;
 WN_NO_ERROR                            = NO_ERROR;
 WN_NOT_SUPPORTED                       = ERROR_NOT_SUPPORTED;
 WN_CANCEL                              = ERROR_CANCELLED;
 WN_RETRY                               = ERROR_RETRY;
 WN_NET_ERROR                           = ERROR_UNEXP_NET_ERR;
 WN_MORE_DATA                           = ERROR_MORE_DATA;
 WN_BAD_POINTER                         = ERROR_INVALID_ADDRESS;
 WN_BAD_VALUE                           = ERROR_INVALID_PARAMETER;
 WN_BAD_USER                            = ERROR_BAD_USERNAME;
 WN_BAD_PASSWORD                        = ERROR_INVALID_PASSWORD;
 WN_ACCESS_DENIED                       = ERROR_ACCESS_DENIED;
 WN_FUNCTION_BUSY                       = ERROR_BUSY;
 WN_WINDOWS_ERROR                       = ERROR_UNEXP_NET_ERR;
 WN_OUT_OF_MEMORY                       = ERROR_NOT_ENOUGH_MEMORY;
 WN_NO_NETWORK                          = ERROR_NO_NETWORK;
 WN_EXTENDED_ERROR                      = ERROR_EXTENDED_ERROR;
 WN_BAD_LEVEL                           = ERROR_INVALID_LEVEL;
 WN_BAD_HANDLE                          = ERROR_INVALID_HANDLE;
 WN_NOT_INITIALIZING                    = ERROR_ALREADY_INITIALIZED;
 WN_NO_MORE_DEVICES                     = ERROR_NO_MORE_DEVICES;
 WN_NOT_CONNECTED                       = ERROR_NOT_CONNECTED;
 WN_OPEN_FILES                          = ERROR_OPEN_FILES;
 WN_DEVICE_IN_USE                       = ERROR_DEVICE_IN_USE;
 WN_BAD_NETNAME                         = ERROR_BAD_NET_NAME;
 WN_BAD_LOCALNAME                       = ERROR_BAD_DEVICE;
 WN_ALREADY_CONNECTED                   = ERROR_ALREADY_ASSIGNED;
 WN_DEVICE_ERROR                        = ERROR_GEN_FAILURE;
 WN_CONNECTION_CLOSED                   = ERROR_CONNECTION_UNAVAIL;
 WN_NO_NET_OR_BAD_PATH                  = ERROR_NO_NET_OR_BAD_PATH;
 WN_BAD_PROVIDER                        = ERROR_BAD_PROVIDER;
 WN_CANNOT_OPEN_PROFILE                 = ERROR_CANNOT_OPEN_PROFILE;
 WN_BAD_PROFILE                         = ERROR_BAD_PROFILE;
 WN_BAD_DEV_TYPE                        = ERROR_BAD_DEV_TYPE;
 WN_DEVICE_ALREADY_REMEMBERED           = ERROR_DEVICE_ALREADY_REMEMBERED;
 WN_NO_MORE_ENTRIES                     = ERROR_NO_MORE_ITEMS;
 WN_NOT_CONTAINER                       = ERROR_NOT_CONTAINER;
 WN_NOT_AUTHENTICATED                   = ERROR_NOT_AUTHENTICATED;
 WN_NOT_LOGGED_ON                       = ERROR_NOT_LOGGED_ON;
 WN_NOT_VALIDATED                       = ERROR_NO_LOGON_SERVERS;

 WNCON_FORNETCARD = 1;
 WNCON_NOTROUTED  = 2;
 WNCON_SLOWLINK   = 4;
 WNCON_DYNAMIC    = 8;

 dde_AppReturnCode = $00FF;
 dde_Busy          = $4000;
 dde_Ack           = $8000;
 dde_DeferUpd      = $4000;
 dde_AckReq        = $8000;
 dde_Response      = $1000;
 dde_Release       = $2000;

 IMAGE_ORDINAL_FLAG32 = $80000000;

//
// Type packing constants
//
 N_BTMASK = $000F;
 N_TMASK  = $0030;
 N_TMASK1 = $00C0;
 N_TMASK2 = $00F0;
 N_BTSHFT = 4;
 N_TSHIFT = 2;

//
// Type (derived) values.
//
 IMAGE_SYM_DTYPE_NULL     = 0; // no derived type.
 IMAGE_SYM_DTYPE_POINTER  = 1; // pointer.
 IMAGE_SYM_DTYPE_FUNCTION = 2; // function.
 IMAGE_SYM_DTYPE_ARRAY    = 3; // array.

 FORMAT_MESSAGE_ALLOCATE_BUFFER = $100;
 FORMAT_MESSAGE_IGNORE_INSERTS = $200;
 FORMAT_MESSAGE_FROM_STRING = $400;
 FORMAT_MESSAGE_FROM_HMODULE = $800;
 FORMAT_MESSAGE_FROM_SYSTEM = $1000;
 FORMAT_MESSAGE_ARGUMENT_ARRAY = $2000;
 FORMAT_MESSAGE_MAX_WIDTH_MASK = 255;

//
// Storage classes.
//
  IMAGE_SYM_CLASS_END_OF_FUNCTION  = BYTE(-1);
  IMAGE_SYM_CLASS_NULL             = $0000;
  IMAGE_SYM_CLASS_AUTOMATIC        = $0001;
  IMAGE_SYM_CLASS_EXTERNAL         = $0002;
  IMAGE_SYM_CLASS_STATIC           = $0003;
  IMAGE_SYM_CLASS_REGISTER         = $0004;
  IMAGE_SYM_CLASS_EXTERNAL_DEF     = $0005;
  IMAGE_SYM_CLASS_LABEL            = $0006;
  IMAGE_SYM_CLASS_UNDEFINED_LABEL  = $0007;
  IMAGE_SYM_CLASS_MEMBER_OF_STRUCT = $0008;
  IMAGE_SYM_CLASS_ARGUMENT         = $0009;
  IMAGE_SYM_CLASS_STRUCT_TAG       = $000A;
  IMAGE_SYM_CLASS_MEMBER_OF_UNION  = $000B;
  IMAGE_SYM_CLASS_UNION_TAG        = $000C;
  IMAGE_SYM_CLASS_TYPE_DEFINITION  = $000D;
  IMAGE_SYM_CLASS_UNDEFINED_STATIC = $000E;
  IMAGE_SYM_CLASS_ENUM_TAG         = $000F;
  IMAGE_SYM_CLASS_MEMBER_OF_ENUM   = $0010;
  IMAGE_SYM_CLASS_REGISTER_PARAM   = $0011;
  IMAGE_SYM_CLASS_BIT_FIELD        = $0012;
  IMAGE_SYM_CLASS_FAR_EXTERNAL     = $0044;
  IMAGE_SYM_CLASS_BLOCK            = $0064;
  IMAGE_SYM_CLASS_FUNCTION         = $0065;
  IMAGE_SYM_CLASS_END_OF_STRUCT    = $0066;
  IMAGE_SYM_CLASS_FILE             = $0067;
  IMAGE_SYM_CLASS_SECTION          = $0068;
  IMAGE_SYM_CLASS_WEAK_EXTERNAL    = $0069;

///////////////////////////////////////////////////////////////////////////////


type

/////////////////////////////////////////////////////////////////////////////
// Use the MAKELCID macro to create a locale identifier
/////////////////////////////////////////////////////////////////////////////

 LCID = DWORD;
 LANGID = Word;

 THandle = DWORD;
 PHandle = ^THandle;
 HANDLE  = THandle;

  LONGLONG = Comp;
  PSID = Pointer;
  PLargeInteger = ^TLargeInteger;
  TLargeInteger = record
    case DWORD of
      0: (LowPart: DWORD; HighPart: Longint);
      1: (QuadPart: LONGLONG);
  end;
  LARGE_INTEGER = TLargeInteger;
  PLARGE_INTEGER = PLargeInteger;

  PULargeInteger = ^TULargeInteger;
  TULargeInteger = record
    case DWORD of
      0: (LowPart: DWORD; HighPart: DWORD);
      1: (QuadPart: LONGLONG);
  end;
  ULARGE_INTEGER = TULargeInteger;
  PULARGE_INTEGER = PULargeInteger;

  PListEntry = ^TListEntry;
  TListEntry = record
    Flink: PListEntry;
    Blink: PListEntry;
  end;

  PFloatingSaveArea = ^TFloatingSaveArea;
  TFloatingSaveArea = record
    ControlWord: DWORD;
    StatusWord: DWORD;
    TagWord: DWORD;
    ErrorOffset: DWORD;
    ErrorSelector: DWORD;
    DataOffset: DWORD;
    DataSelector: DWORD;
    RegisterArea: array[0..SIZE_OF_80387_REGISTERS - 1] of Byte;
    Cr0NpxState: DWORD;
  end;

  PContext = ^TContext;
  TContext = record
   ContextFlags: DWORD;
   Dr0: DWORD;
   Dr1: DWORD;
   Dr2: DWORD;
   Dr3: DWORD;
   Dr6: DWORD;
   Dr7: DWORD;
   FloatSave: TFloatingSaveArea;
   SegGs: DWORD;
   SegFs: DWORD;
   SegEs: DWORD;
   SegDs: DWORD;
   Edi: DWORD;
   Esi: DWORD;
   Ebx: DWORD;
   Edx: DWORD;
   Ecx: DWORD;
   Eax: DWORD;
   Ebp: DWORD;
   Eip: DWORD;
   SegCs: DWORD;
   EFlags: DWORD;
   Esp: DWORD;
   SegSs: DWORD;
 end;

 PLDTEntry = ^TLDTEntry;
 TLDTEntry = record
  LimitLow: Word;
  BaseLow: Word;
   case DWORD of
    0: (BaseMid: Byte;
        Flags1: Byte;
        Flags2: Byte;
        BaseHi: Byte);
    1: (Flags: Longint);
  end;

  PExceptionRecord = ^TExceptionRecord;
  TExceptionRecord = record
    ExceptionCode: DWORD;
    ExceptionFlags: DWORD;
    ExceptionRecord: PExceptionRecord;
    ExceptionAddress: Pointer;
    NumberParameters: DWORD;
    ExceptionInformation: array[0..EXCEPTION_MAXIMUM_PARAMETERS - 1] of DWORD;
  end;

  TExceptionPointers = record
    ExceptionRecord : PExceptionRecord;
    ContextRecord : PContext;
  end;

  PMemoryBasicInformation = ^TMemoryBasicInformation;
  TMemoryBasicInformation = record
    BaseAddress : Pointer;
    AllocationBase : Pointer;
    AllocationProtect : DWORD;
    RegionSize : DWORD;
    State : DWORD;
    Protect : DWORD;
    Type_9 : DWORD;
  end;

  SECURITY_DESCRIPTOR_CONTROL = Word;
  PSECURITY_DESCRIPTOR_CONTROL = ^WORD;

  PSECURITY_DESCRIPTOR = Pointer;

  PAbortProc = ^TAbortProc;
  TAbortProc = Pointer;

  PACMDRIVERENUMCB = ^TACMDRIVERENUMCB;
  TACMDRIVERENUMCB = Pointer;

  ACCESS_MASK = DWORD;
  PACCESS_MASK = ^ACCESS_MASK;

  PGenericMapping = ^TGenericMapping;
  TGenericMapping = record
    GenericRead: ACCESS_MASK;
    GenericWrite: ACCESS_MASK;
    GenericExecute: ACCESS_MASK;
    GenericAll: ACCESS_MASK;
  end;

  PLUIDAndAttributes = ^TLUIDAndAttributes;
  TLUIDAndAttributes = record
    Luid: TLargeInteger;
    Attributes: DWORD;
  end;

  PSIDIdentifierAuthority = ^TSIDIdentifierAuthority;
  TSIDIdentifierAuthority = record
    Value: array[0..5] of Byte;
  end;

  SID_NAME_USE = DWORD;

  PSIDAndAttributes = ^TSIDAndAttributes;
  TSIDAndAttributes = record
    Sid: PSID;
    Attributes: DWORD;
  end;

  PACL = ^TACL;
  TACL = record
    AclRevision: Byte;
    Sbz1: Byte;
    AclSize: Word;
    AceCount: Word;
    Sbz2: Word;
  end;
  ACL = TACL;

  PSecurityDescriptor = ^TSecurityDescriptor;
  _SECURITY_DESCRIPTOR = record
    Revision: Byte;
    Sbz1: Byte;
    Control: SECURITY_DESCRIPTOR_CONTROL;
    Owner: PSID;
    Group: PSID;
    Sacl: PACL;
    Dacl: PACL;
  end;
  TSecurityDescriptor = _SECURITY_DESCRIPTOR;
  SECURITY_DESCRIPTOR = _SECURITY_DESCRIPTOR;

  TAclInformationClass = (AclInfoPad, AclRevisionInformation, AclSizeInformation);

  PPrivilegeSet = ^TPrivilegeSet;
  TPrivilegeSet = record
    PrivilegeCount: DWORD;
    Control: DWORD;
    Privilege: array[0..0] of TLUIDAndAttributes;
  end;

  TTokenType = (TokenTPad, TokenPrimary, TokenImpersonation);

  TTokenInformationClass = (TokenICPad, TokenUser, TokenGroups, TokenPrivileges,
    TokenOwner, TokenPrimaryGroup, TokenDefaultDacl, TokenSource, TokenType,
    TokenImpersonationLevel, TokenStatistics);

  PTokenGroups = ^TTokenGroups;
  TTokenGroups = record
    GroupCount: DWORD;
    Groups: array[0..0] of TSIDAndAttributes;
  end;

  PTokenPrivileges = ^TTokenPrivileges;
  TTokenPrivileges = record
    PrivilegeCount: DWORD;
    Privileges: array[0..0] of TLUIDAndAttributes;
  end;

  SECURITY_CONTEXT_TRACKING_MODE = Boolean;

  PSecurityQualityOfService = ^TSecurityQualityOfService;
  TSecurityQualityOfService = record
    Length: DWORD;
    ImpersonationLevel: TSecurityImpersonationLevel;
    ContextTrackingMode: SECURITY_CONTEXT_TRACKING_MODE;
    EffectiveOnly: Boolean;
  end;

  SECURITY_INFORMATION = DWORD;
  PSECURITY_INFORMATION = ^DWORD;

  TThreadStartRoutine = function conv arg_stdcall (lpThreadParameter: Pointer): DWORD;

  PImageFileHeader = ^TImageFileHeader;
  TImageFileHeader = packed record
    Machine: Word;
    NumberOfSections: Word;
    TimeDateStamp: DWORD;
    PointerToSymbolTable: DWORD;
    NumberOfSymbols: DWORD;
    SizeOfOptionalHeader: Word;
    Characteristics: Word;
  end;
  PImageDataDirectory = ^TImageDataDirectory;
  TImageDataDirectory = record
    VirtualAddress: DWORD;
    Size: DWORD;
  end;

  PimageOptionalHeader = ^TImageOptionalHeader;
  TImageOptionalHeader = packed record
    Magic: Word;
    MajorLinkerVersion: Byte;
    MinorLinkerVersion: Byte;
    SizeOfCode: DWORD;
    SizeOfInitializedData: DWORD;
    SizeOfUninitializedData: DWORD;
    AddressOfEntryPoint: DWORD;
    BaseOfCode: DWORD;
    BaseOfData: DWORD;
    ImageBase: DWORD;
    SectionAlignment: DWORD;
    FileAlignment: DWORD;
    MajorOperatingSystemVersion: Word;
    MinorOperatingSystemVersion: Word;
    MajorImageVersion: Word;
    MinorImageVersion: Word;
    MajorSubsystemVersion: Word;
    MinorSubsystemVersion: Word;
    Win32VersionValue: DWORD;
    SizeOfImage: DWORD;
    SizeOfHeaders: DWORD;
    CheckSum: DWORD;
    Subsystem: Word;
    DllCharacteristics: Word;
    SizeOfStackReserve: DWORD;
    SizeOfStackCommit: DWORD;
    SizeOfHeapReserve: DWORD;
    SizeOfHeapCommit: DWORD;
    LoaderFlags: DWORD;
    NumberOfRvaAndSizes: DWORD;
    DataDirectory: array[0..IMAGE_NUMBEROF_DIRECTORY_ENTRIES-1] of TImageDataDirectory;
  end;

  PImageRomOptionalHeader = ^TImageRomOptionalHeader;
  TImageRomOptionalHeader = packed record
    Magic: Word;
    MajorLinkerVersion: Byte;
    MinorLinkerVersion: Byte;
    SizeOfCode: DWORD;
    SizeOfInitializedData: DWORD;
    SizeOfUninitializedData: DWORD;
    AddressOfEntryPoint: DWORD;
    BaseOfCode: DWORD;
    BaseOfData: DWORD;
    BaseOfBss: DWORD;
    GprMask: DWORD;
    CprMask: array[0..3] of DWORD;
    GpValue: DWORD;
  end;

  PImageNtHeaders = ^TImageNtHeaders;
  TImageNtHeaders = packed record
    Signature: DWORD;
    FileHeader: TImageFileHeader;
    OptionalHeader: TImageOptionalHeader;
  end;

  PImageRomHeaders = ^TImageRomHeaders;
  TImageRomHeaders = packed record
    FileHeader: TImageFileHeader;
    OptionalHeader: TImageRomOptionalHeader;
  end;

  TISHMisc = packed record
    case DWORD of
      0: (PhysicalAddress: DWORD);
      1: (VirtualSize: DWORD);
  end;

  PImageSectionHeader = ^TImageSectionHeader;
  TImageSectionHeader = packed record
    Name: array[0..IMAGE_SIZEOF_SHORT_NAME-1] of Byte;
    Misc: TISHMisc;
    VirtualAddress: DWORD;
    SizeOfRawData: DWORD;
    PointerToRawData: DWORD;
    PointerToRelocations: DWORD;
    PointerToLinenumbers: DWORD;
    NumberOfRelocations: Word;
    NumberOfLinenumbers: Word;
    Characteristics: DWORD;
  end;

  PImageLoadConfigDirectory = ^TImageLoadConfigDirectory;
  TImageLoadConfigDirectory = packed record
    Characteristics: DWORD;
    TimeDateStamp: DWORD;
    MajorVersion: Word;
    MinorVersion: Word;
    GlobalFlagsClear: DWORD;
    GlobalFlagsSet: DWORD;
    CriticalSectionDefaultTimeout: DWORD;
    DeCommitFreeBlockThreshold: DWORD;
    DeCommitTotalFreeThreshold: DWORD;
    LockPrefixTable: Pointer;
    MaximumAllocationSize: DWORD;
    VirtualMemoryThreshold: DWORD;
    ProcessHeapFlags: DWORD;
    ProcessAffinityMask: DWORD;
    Reserved: array[0..2] of DWORD;
  end;

  PImageRuntimeFunctionEntry = ^TImageRuntimeFunctionEntry;
  TImageRuntimeFunctionEntry = record
    BeginAddress: DWORD;
    EndAddress: DWORD;
    ExceptionHandler: Pointer;
    HandlerData: Pointer;
    PrologEndAddress: DWORD;
  end;

  PImageDebugDirectory = ^TImageDebugDirectory;
  TImageDebugDirectory = packed record
    Characteristics: DWORD;
    TimeDateStamp: DWORD;
    MajorVersion: Word;
    MinorVersion: Word;
    _Type: DWORD;
    SizeOfData: DWORD;
    AddressOfRawData: DWORD;
    PointerToRawData: DWORD;
  end;

  PImageCOFFSymbolsHeader = ^TImageCOFFSymbolsHeader;
  TImageCOFFSymbolsHeader = record
    NumberOfSymbols: DWORD;
    LvaToFirstSymbol: DWORD;
    NumberOfLinenumbers: DWORD;
    LvaToFirstLinenumber: DWORD;
    RvaToFirstByteOfCode: DWORD;
    RvaToLastByteOfCode: DWORD;
    RvaToFirstByteOfData: DWORD;
    RvaToLastByteOfData: DWORD;
  end;

  PFpoData = ^TFpoData;
  TFpoData = packed record
    ulOffStart: DWORD;
    cbProcSize: DWORD;
    cdwLocals: DWORD;
    cdwParams: Word;
    cbProlog: Byte;
    OtherStuff: Byte;
  end;

  PImageDebugMisc = ^TImageDebugMisc;
  TImageDebugMisc = packed record
    DataType: DWORD;
    Length: DWORD;
    Unicode: ByteBool;
    Reserved: array[0..2] of Byte;
    Data: array[0..0] of Byte;
  end;

  PImageFunctionEntry = ^TImageFunctionEntry;
  TImageFunctionEntry = record
    StartingAddress: DWORD;
    EndingAddress: DWORD;
    EndOfPrologue: DWORD;
  end;

  PRTLCriticalSection = ^TRTLCriticalSection;
  PRTLCriticalSectionDebug = ^TRTLCriticalSectionDebug;
  TRTLCriticalSectionDebug = record
    Type_18: Word;
    CreatorBackTraceIndex: Word;
    CriticalSection: PRTLCriticalSection;
    ProcessLocksList: TListEntry;
    EntryCount: DWORD;
    ContentionCount: DWORD;
    Spare: array[0..1] of DWORD;
  end;

  TRTLCriticalSection = record
    DebugInfo: PRTLCriticalSectionDebug;
    LockCount: Longint;
    RecursionCount: Longint;
    OwningThread: THandle;
    LockSemaphore: THandle;
    Reserved: DWORD;
  end;

  HGLOBAL = THandle;
  HLOCAL = THandle;
  FARPROC = Pointer;
  TFarProc = Pointer;
  PROC_22 = Pointer;

  HGDIOBJ = DWORD;
  HACCEL = DWORD;
  HBITMAP = DWORD;
  HBRUSH = DWORD;
  HCOLORSPACE = DWORD;
  HDC = DWORD;
  HGLRC = DWORD;
  HDESK = DWORD;
  HENHMETAFILE = DWORD;
  HFONT = DWORD;
  HICON = DWORD;
  HMENU = DWORD;
  HMETAFILE = DWORD;
  HINST = DWORD;
  HMODULE = HINST;
  HPALETTE = DWORD;
  HPEN = DWORD;
  HRGN = DWORD;
  HRSRC = DWORD;
  HSTR = DWORD;
  HTASK = DWORD;
  HWINSTA = DWORD;
  HKL = DWORD;


  HFILE = DWORD;
  HCURSOR = DWORD;

  COLORREF = DWORD;
  TColorRef = Longint;

  PPoint = ^TPoint;
  TPoint = record
    x: Longint;
    y: Longint;
  end;

  POINTL = packed record
    x: Longint;
    y: Longint;
  end;
  PPointL = ^TPointL;
  TPointL = POINTL;

  PRect = ^TRect;
  TRect = record
    case DWORD of
      0: (Left, Top, Right, Bottom: DWORD);
      1: (TopLeft, BottomRight: TPoint);
  end;

  PSize = ^TSize;
  TSize = record
    cx: Longint;
    cy: Longint;
  end;

  PSmallPoint = ^TSmallPoint;
  TSmallPoint = record
    x: SHORT;
    y: SHORT;
  end;

  POverlapped = ^TOverlapped;
  TOverlapped = record
    Internal: DWORD;
    InternalHigh: DWORD;
    Offset: DWORD;
    OffsetHigh: DWORD;
    hEvent: THandle;
  end;

  PSecurityAttributes = ^TSecurityAttributes;
  TSecurityAttributes = record
    nLength: DWORD;
    lpSecurityDescriptor: Pointer;
    bInheritHandle: LONGBOOL;
  end;

  PProcessInformation = ^TProcessInformation;
  TProcessInformation = record
    hProcess: THandle;
    hThread: THandle;
    dwProcessId: DWORD;
    dwThreadId: DWORD;
  end;

  PFileTime = ^TFileTime;
  TFileTime = record
    dwLowDateTime: DWORD;
    dwHighDateTime: DWORD;
  end;

  PSystemTime = ^TSystemTime;
  TSystemTime = record
    wYear: Word;
    wMonth: Word;
    wDayOfWeek: Word;
    wDay: Word;
    wHour: Word;
    wMinute: Word;
    wSecond: Word;
    wMilliseconds: Word;
  end;

  TFNThreadStartRoutine = TFarProc;
  TFNFiberStartRoutine = TFarProc;

  PCommProp = ^TCommProp;
  TCommProp = record
    wPacketLength: Word;
    wPacketVersion: Word;
    dwServiceMask: DWORD;
    dwReserved1: DWORD;
    dwMaxTxQueue: DWORD;
    dwMaxRxQueue: DWORD;
    dwMaxBaud: DWORD;
    dwProvSubType: DWORD;
    dwProvCapabilities: DWORD;
    dwSettableParams: DWORD;
    dwSettableBaud: DWORD;
    wSettableData: Word;
    wSettableStopParity: Word;
    dwCurrentTxQueue: DWORD;
    dwCurrentRxQueue: DWORD;
    dwProvSpec1: DWORD;
    dwProvSpec2: DWORD;
    wcProvChar: array[0..0] of WCHAR;
  end;

  TComStateFlag = (fCtlHold, fDsrHold, fRlsHold, fXoffHold, fXOffSent, fEof, fTxim);
  TComStateFlags = set of TComStateFlag;
  TComStat = packed record
    Flags: TComStateFlags;
    Reserved: array[0..2] of Byte;
    cbInQue: DWORD;
    cbOutQue: DWORD;
  end;
  PComStat = ^TComStat;

  TDCB = packed record
    DCBlength: DWORD;
    BaudRate: DWORD;
    Flags: Longint;
    wReserved: Word;
    XonLim: Word;
    XoffLim: Word;
    ByteSize: Byte;
    Parity: Byte;
    StopBits: Byte;
    XonChar: CHAR;
    XoffChar: CHAR;
    ErrorChar: CHAR;
    EofChar: CHAR;
    EvtChar: CHAR;
    wReserved1: Word;
  end;
  PDCB = ^TDCB;

  PCommTimeouts = ^TCommTimeouts;
  TCommTimeouts = record
    ReadIntervalTimeout: DWORD;
    ReadTotalTimeoutMultiplier: DWORD;
    ReadTotalTimeoutConstant: DWORD;
    WriteTotalTimeoutMultiplier: DWORD;
    WriteTotalTimeoutConstant: DWORD;
  end;

  PCommConfig = ^TCommConfig;
  TCommConfig = record
    dwSize: DWORD;
    wVersion: Word;
    wReserved: Word;
    dcb: TDCB;
    dwProviderSubType: DWORD;
    dwProviderOffset: DWORD;
    dwProviderSize: DWORD;
    wcProviderData: array[0..0] of WCHAR;
  end;

  PSystemInfo = ^TSystemInfo;
  TSystemInfo = record
    case DWORD of
      0: (
        dwOemId: DWORD);
      1: (
        wProcessorArchitecture: Word;
        wReserved: Word;
        dwPageSize: DWORD;
        lpMinimumApplicationAddress: Pointer;
        lpMaximumApplicationAddress: Pointer;
        dwActiveProcessorMask: DWORD;
        dwNumberOfProcessors: DWORD;
        dwProcessorType: DWORD;
        dwAllocationGranularity: DWORD;
        wProcessorLevel: Word;
        wProcessorRevision: Word);
  end;

  PMemoryStatus = ^TMemoryStatus;
  TMemoryStatus = record
    dwLength: DWORD;
    dwMemoryLoad: DWORD;
    dwTotalPhys: DWORD;
    dwAvailPhys: DWORD;
    dwTotalPageFile: DWORD;
    dwAvailPageFile: DWORD;
    dwTotalVirtual: DWORD;
    dwAvailVirtual: DWORD;
  end;

  PExceptionDebugInfo = ^TExceptionDebugInfo;
  TExceptionDebugInfo = record
    ExceptionRecord: TExceptionRecord;
    dwFirstChance: DWORD;
  end;

  PCreateThreadDebugInfo = ^TCreateThreadDebugInfo;
  TCreateThreadDebugInfo = record
    hThread: THandle;
    lpThreadLocalBase: Pointer;
    lpStartAddress: TFNThreadStartRoutine;
  end;

  PCreateProcessDebugInfo = ^TCreateProcessDebugInfo;
  TCreateProcessDebugInfo = record
    hFile: THandle;
    hProcess: THandle;
    hThread: THandle;
    lpBaseOfImage: Pointer;
    dwDebugInfoFileOffset: DWORD;
    nDebugInfoSize: DWORD;
    lpThreadLocalBase: Pointer;
    lpStartAddress: TFNThreadStartRoutine;
    lpImageName: Pointer;
    fUnicode: Word;
  end;

  PExitThreadDebugInfo = ^TExitThreadDebugInfo;
  TExitThreadDebugInfo = record
    dwExitCode: DWORD;
  end;

  PExitProcessDebugInfo = ^TExitProcessDebugInfo;
  TExitProcessDebugInfo = record
    dwExitCode: DWORD;
  end;

  PLoadDLLDebugInfo = ^TLoadDLLDebugInfo;
  TLoadDLLDebugInfo = record
    hFile: THandle;
    lpBaseOfDll: Pointer;
    dwDebugInfoFileOffset: DWORD;
    nDebugInfoSize: DWORD;
    lpImageName: Pointer;
    fUnicode: Word;
  end;

  PUnloadDLLDebugInfo = ^TUnloadDLLDebugInfo;
  TUnloadDLLDebugInfo = record
    lpBaseOfDll: Pointer;
  end;

  POutputDebugStringInfo = ^TOutputDebugStringInfo;
  TOutputDebugStringInfo = record
    lpDebugStringData: LPSTR;
    fUnicode: Word;
    nDebugStringLength: Word;
  end;

  PRIPInfo = ^TRIPInfo;
  TRIPInfo = record
    dwError: DWORD;
    dwType: DWORD;
  end;

  PDebugEvent = ^TDebugEvent;
  TDebugEvent = record
    dwDebugEventCode: DWORD;
    dwProcessId: DWORD;
    dwThreadId: DWORD;
    case DWORD of
      0: (Exception: TExceptionDebugInfo);
      1: (CreateThread: TCreateThreadDebugInfo);
      2: (CreateProcessInfo: TCreateProcessDebugInfo);
      3: (ExitThread: TExitThreadDebugInfo);
      4: (ExitProcess: TExitThreadDebugInfo);
      5: (LoadDll: TLoadDLLDebugInfo);
      6: (UnloadDll: TUnloadDLLDebugInfo);
      7: (DebugString: TOutputDebugStringInfo);
      8: (RipInfo: TRIPInfo);
  end;

  POFStruct = ^TOFStruct;
  TOFStruct = record
    cBytes: Byte;
    fFixedDisk: Byte;
    nErrCode: Word;
    Reserved1: Word;
    Reserved2: Word;
    szPathName: array[0..OFS_MAXPATHNAME-1] of CHAR;
  end;

  PProcessHeapEntry = ^TProcessHeapEntry;
  TProcessHeapEntry = record
    lpData: Pointer;
    cbData: DWORD;
    cbOverhead: Byte;
    iRegionIndex: Byte;
    wFlags: Word;
    case DWORD of
      0: (
        hMem: THandle);
      1: (
        dwCommittedSize: DWORD;
        dwUnCommittedSize: DWORD;
        lpFirstBlock: Pointer;
        lpLastBlock: Pointer);
  end;

  TFNTopLevelExceptionFilter = TFarProc;

  TFNAPCProc = TFarProc;

  TWOHandleArray = array[0..MAXIMUM_WAIT_OBJECTS - 1] of THandle;
  PWOHandleArray = ^TWOHandleArray;

  PByHandleFileInformation = ^TByHandleFileInformation;
  TByHandleFileInformation = record
    dwFileAttributes: DWORD;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    dwVolumeSerialNumber: DWORD;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    nNumberOfLinks: DWORD;
    nFileIndexHigh: DWORD;
    nFileIndexLow: DWORD;
  end;

  PTimeZoneInformation = ^TTimeZoneInformation;
  TTimeZoneInformation = record
    Bias: Longint;
    StandardName: array[0..31] of WCHAR;
    StandardDate: TSystemTime;
    StandardBias: Longint;
    DaylightName: array[0..31] of WCHAR;
    DaylightDate: TSystemTime;
    DaylightBias: Longint;
  end;

  TPROverlappedCompletionRoutine =
    procedure conv (arg_stdcall) (dwErrorCode, dwNumberOfBytesTransfered: DWORD;
    lpOverlapped: POverlapped);

  PWIN32StreamID = ^TWIN32StreamID;
  TWIN32StreamID = record
    dwStreamId: DWORD;
    dwStreamAttributes: DWORD;
    Size: TLargeInteger;
    dwStreamNameSize: DWORD;
    cStreamName: array[0..0] of WCHAR;
  end;

  PStartupInfo = ^TStartupInfo;
  TStartupInfo = record
    cb: DWORD;
    lpReserved: Pointer;
    lpDesktop: Pointer;
    lpTitle: Pointer;
    dwX: DWORD;
    dwY: DWORD;
    dwXSize: DWORD;
    dwYSize: DWORD;
    dwXCountChars: DWORD;
    dwYCountChars: DWORD;
    dwFillAttribute: DWORD;
    dwFlags: DWORD;
    wShowWindow: Word;
    cbReserved2: Word;
    lpReserved2: PByte;
    hStdInput: THandle;
    hStdOutput: THandle;
    hStdError: THandle;
  end;

  PWin32FindDataA = ^TWin32FindDataA;
  PWin32FindDataW = ^TWin32FindDataW;
  PWin32FindData = PWin32FindDataA;
  TWin32FindDataA = record
    dwFileAttributes: DWORD;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    dwReserved0: DWORD;
    dwReserved1: DWORD;
    cFileName: array[0..260 - 1] of AnsiChar;
    cAlternateFileName: array[0..13] of AnsiChar;
  end;
  TWin32FindDataW = record
    dwFileAttributes: DWORD;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    dwReserved0: DWORD;
    dwReserved1: DWORD;
    cFileName: array[0..259] of WideChar;
    cAlternateFileName: array[0..13] of WideChar;
  end;
  TWin32FindData = TWin32FindDataA;

  PWin32FileAttributeData = ^TWin32FileAttributeData;
  TWin32FileAttributeData = record
    dwFileAttributes: DWORD;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
  end;

  TFNTimerAPCRoutine = TFarProc;

  ENUMRESTYPEPROC = FARPROC;
  ENUMRESNAMEPROC = FARPROC;
  ENUMRESLANGPROC = FARPROC;

  TGetFileExInfoLevels = (GetFileExInfoStandard, GetFileExMaxInfoLevel);

  TFindexInfoLevels = (FindExInfoStandard, FindExInfoMaxInfoLevel);
  TFindexSearchOps = (FindExSearchNameMatch, FindExSearchLimitToDirectories,
    FindExSearchLimitToDevices, FindExSearchMaxSearchOp);

  TFNProgressRoutine = TFarProc;

  PHWProfileInfoA = ^THWProfileInfoA;
  PHWProfileInfoW = ^THWProfileInfoW;
  PHWProfileInfo = PHWProfileInfoA;
  THWProfileInfoA = packed record
    dwDockInfo: DWORD;
    szHwProfileGuid: array[0..HW_PROFILE_GUIDLEN-1] of AnsiChar;
    szHwProfileName: array[0..MAX_PROFILE_LEN-1] of AnsiChar;
  end;
  THWProfileInfoW = packed record
    dwDockInfo: DWORD;
    szHwProfileGuid: array[0..HW_PROFILE_GUIDLEN-1] of WideChar;
    szHwProfileName: array[0..MAX_PROFILE_LEN-1] of WideChar;
  end;
  THWProfileInfo = THWProfileInfoA;

  POSVersionInfoA = ^TOSVersionInfoA;
  POSVersionInfoW = ^TOSVersionInfoW;
  POSVersionInfo = POSVersionInfoA;
  TOSVersionInfoA = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of AnsiChar;
  end;
  TOSVersionInfoW = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of WideChar;
  end;
  TOSVersionInfo = TOSVersionInfoA;

  PSystemPowerStatus = ^TSystemPowerStatus;
  TSystemPowerStatus = packed record
    ACLineStatus : Byte;
    BatteryFlag : Byte;
    BatteryLifePercent : Byte;
    Reserved1 : Byte;
    BatteryLifeTime : DWORD;
    BatteryFullLifeTime : DWORD;
  end;

  PWinCertificate = ^TWinCertificate;
  TWinCertificate = packed record
    dwLength: DWORD;
    wRevision: Word;
    wCertificateType: Word;
    bCertificate: array[0..0] of Byte;
  end;

  TWinTrustSubject = Pointer;

  PWinTrustActdataContextWithSubject = ^TWinTrustActdataContextWithSubject;
  TWinTrustActdataContextWithSubject = record
    hClientToken: THandle;
    SubjectType: PGUID;
    Subject: TWinTrustSubject;
  end;

  PWinTrustActdataSubjectOnly = ^TWinTrustActdataSubjectOnly;
  TWinTrustActdataSubjectOnly = record
    SubjectType: PGUID;
    Subject: TWinTrustSubject;
  end;

  PWinTrustSubjectFile = ^TWinTrustSubjectFile;
  TWinTrustSubjectFile = record
    hFile: THandle;
    lpPath: PWideChar;
  end;

  PWinSpubTrustedPublisherData = ^TWinSpubTrustedPublisherData;
  TWinSpubTrustedPublisherData = record
    hClientToken: THandle;
    lpCertificate: PWinCertificate;
  end;

  PXForm = ^TXForm;
  TXForm = packed record
    eM11: Single;
    eM12: Single;
    eM21: Single;
    eM22: Single;
    eDx: Single;
    eDy: Single;
  end;

  PBitmap = ^TBitmap;
  TBitmap = packed record
    bmType: Longint;
    bmWidth: Longint;
    bmHeight: Longint;
    bmWidthBytes: Longint;
    bmPlanes: Word;
    bmBitsPixel: Word;
    bmBits: Pointer;
  end;

  PRGBTriple = ^TRGBTriple;
  TRGBTriple = packed record
    rgbtBlue: Byte;
    rgbtGreen: Byte;
    rgbtRed: Byte;
  end;

  PRGBQuad = ^TRGBQuad;
  TRGBQuad = packed record
    rgbBlue: Byte;
    rgbGreen: Byte;
    rgbRed: Byte;
    rgbReserved: Byte;
  end;

  LCSCSTYPE = Longint;
  LCSGAMUTMATCH = Longint;
  FXPT16DOT16 = Longint;
  LPFXPT16DOT16 = ^Longint;
  FXPT2DOT30 = Longint;
  LPFXPT2DOT30 = ^Longint;

  PCIEXYZ = ^TCIEXYZ;
  TCIEXYZ = packed record
    ciexyzX: FXPT2DOT30;
    ciexyzY: FXPT2DOT30;
    ciexyzZ: FXPT2DOT30;
  end;

  PCIEXYZTriple = ^TCIEXYZTriple;
  TCIEXYZTriple = packed record
    ciexyzRed: TCIEXYZ;
    ciexyzGreen: TCIEXYZ;
    ciexyzBlue: TCIEXYZ;
  end;
  PLogColorSpaceA = ^TLogColorSpaceA;
  PLogColorSpaceW = ^TLogColorSpaceW;
  PLogColorSpace = PLogColorSpaceA;
  TLogColorSpaceA = record
    lcsSignature: DWORD;
    lcsVersion: DWORD;
    lcsSize: DWORD;
    lcsCSType: LCSCSTYPE;
    lcsIntent: LCSGAMUTMATCH;
    lcsEndpoints: TCIEXYZTriple;
    lcsGammaRed: DWORD;
    lcsGammaGreen: DWORD;
    lcsGammaBlue: DWORD;
    lcsFilename: array[0..259] of AnsiChar;
  end;
  TLogColorSpaceW = record
    lcsSignature: DWORD;
    lcsVersion: DWORD;
    lcsSize: DWORD;
    lcsCSType: LCSCSTYPE;
    lcsIntent: LCSGAMUTMATCH;
    lcsEndpoints: TCIEXYZTriple;
    lcsGammaRed: DWORD;
    lcsGammaGreen: DWORD;
    lcsGammaBlue: DWORD;
    lcsFilename: array[0..259] of WideChar;
  end;
  TLogColorSpace = TLogColorSpaceA;

  PBitmapCoreHeader = ^TBitmapCoreHeader;
  TBitmapCoreHeader = packed record
    bcSize: DWORD;
    bcWidth: Word;
    bcHeight: Word;
    bcPlanes: Word;
    bcBitCount: Word;
  end;

  PBitmapInfoHeader = ^TBitmapInfoHeader;
  TBitmapInfoHeader = packed record
    biSize: DWORD;
    biWidth: Longint;
    biHeight: Longint;
    biPlanes: Word;
    biBitCount: Word;
    biCompression: DWORD;
    biSizeImage: DWORD;
    biXPelsPerMeter: Longint;
    biYPelsPerMeter: Longint;
    biClrUsed: DWORD;
    biClrImportant: DWORD;
  end;

  PBitmapV4Header = ^TBitmapV4Header;
  TBitmapV4Header = packed record
    bV4Size: DWORD;
    bV4Width: Longint;
    bV4Height: Longint;
    bV4Planes: Word;
    bV4BitCount: Word;
    bV4V4Compression: DWORD;
    bV4SizeImage: DWORD;
    bV4XPelsPerMeter: Longint;
    bV4YPelsPerMeter: Longint;
    bV4ClrUsed: DWORD;
    bV4ClrImportant: DWORD;
    bV4RedMask: DWORD;
    bV4GreenMask: DWORD;
    bV4BlueMask: DWORD;
    bV4AlphaMask: DWORD;
    bV4CSType: DWORD;
    bV4Endpoints: TCIEXYZTriple;
    bV4GammaRed: DWORD;
    bV4GammaGreen: DWORD;
    bV4GammaBlue: DWORD;
  end;

  PBitmapInfo = ^TBitmapInfo;
  TBitmapInfo = packed record
    bmiHeader: TBitmapInfoHeader;
    bmiColors: array[0..0] of TRGBQuad;
  end;

  PBitmapCoreInfo = ^TBitmapCoreInfo;
  TBitmapCoreInfo = packed record
    bmciHeader: TBitmapCoreHeader;
    bmciColors: array[0..0] of TRGBTriple;
  end;

  PBitmapFileHeader = ^TBitmapFileHeader;
  TBitmapFileHeader = packed record
    bfType: Word;
    bfSize: DWORD;
    bfReserved1: Word;
    bfReserved2: Word;
    bfOffBits: DWORD;
  end;

  PFontSignature = ^TFontSignature;
  TFontSignature = packed record
    fsUsb: array[0..3] of DWORD;
    fsCsb: array[0..1] of DWORD;
  end;

  PCharsetInfo = ^TCharsetInfo;
  TCharsetInfo = packed record
    ciCharset: UINT;
    ciACP: UINT;
    fs: TFontSignature;
  end;

  PLocaleSignature = ^TLocaleSignature;
  TLocaleSignature = packed record
    lsUsb: array[0..3] of DWORD;
    lsCsbDefault: array[0..1] of DWORD;
    lsCsbSupported: array[0..1] of DWORD;
  end;

  PHandleTable = ^THandleTable;
  THandleTable = packed record
    objectHandle: array[0..0] of HGDIOBJ;
  end;

  PMetaRecord = ^TMetaRecord;
  TMetaRecord = packed record
    rdSize: DWORD;
    rdFunction: Word;
    rdParm: array[0..0] of Word;
  end;

  PMetafilePict = ^TMetafilePict;
  TMetafilePict = packed record
    mm: Longint;
    xExt: Longint;
    yExt: Longint;
    hMF: HMETAFILE;
  end;

  PMetaHeader = ^TMetaHeader;
  TMetaHeader = packed record
    mtType: Word;
    mtHeaderSize: Word;
    mtVersion: Word;
    mtSize: DWORD;
    mtNoObjects: Word;
    mtMaxRecord: DWORD;
    mtNoParameters: Word;
  end;

  PEnhMetaRecord = ^TEnhMetaRecord;
  TEnhMetaRecord = packed record
    iType: DWORD;
    nSize: DWORD;
    dParm: array[0..0] of DWORD;
  end;

  PEnhMetaHeader = ^TEnhMetaHeader;
  TEnhMetaHeader = packed record
    iType: DWORD;
    nSize: DWORD;
    rclBounds: TRect;
    rclFrame: TRect;
    dSignature: DWORD;
    nVersion: DWORD;
    nBytes: DWORD;
    nRecords: DWORD;
    nHandles: Word;
    sReserved: Word;
    nDescription: DWORD;
    offDescription: DWORD;
    nPalEntries: DWORD;
    szlDevice: TSize;
    szlMillimeters: TSize;
    cbPixelFormat: DWORD;
    offPixelFormat: DWORD;
    bOpenGL: DWORD;
  end;

  PTextMetricA = ^TTextMetricA;
  PTextMetricW = ^TTextMetricW;
  PTextMetric = PTextMetricA;
  TTextMetricA = record
    tmHeight: Longint;
    tmAscent: Longint;
    tmDescent: Longint;
    tmInternalLeading: Longint;
    tmExternalLeading: Longint;
    tmAveCharWidth: Longint;
    tmMaxCharWidth: Longint;
    tmWeight: Longint;
    tmOverhang: Longint;
    tmDigitizedAspectX: Longint;
    tmDigitizedAspectY: Longint;
    tmFirstChar: AnsiChar;
    tmLastChar: AnsiChar;
    tmDefaultChar: AnsiChar;
    tmBreakChar: AnsiChar;
    tmItalic: Byte;
    tmUnderlined: Byte;
    tmStruckOut: Byte;
    tmPitchAndFamily: Byte;
    tmCharSet: Byte;
  end;
  TTextMetricW = record
    tmHeight: Longint;
    tmAscent: Longint;
    tmDescent: Longint;
    tmInternalLeading: Longint;
    tmExternalLeading: Longint;
    tmAveCharWidth: Longint;
    tmMaxCharWidth: Longint;
    tmWeight: Longint;
    tmOverhang: Longint;
    tmDigitizedAspectX: Longint;
    tmDigitizedAspectY: Longint;
    tmFirstChar: WideChar;
    tmLastChar: WideChar;
    tmDefaultChar: WideChar;
    tmBreakChar: WideChar;
    tmItalic: Byte;
    tmUnderlined: Byte;
    tmStruckOut: Byte;
    tmPitchAndFamily: Byte;
    tmCharSet: Byte;
  end;
  TTextMetric = TTextMetricA;

  PNewTextMetricA = ^TNewTextMetricA;
  PNewTextMetricW = ^TNewTextMetricW;
  PNewTextMetric = PNewTextMetricA;
  TNewTextMetricA = record
    tmHeight: Longint;
    tmAscent: Longint;
    tmDescent: Longint;
    tmInternalLeading: Longint;
    tmExternalLeading: Longint;
    tmAveCharWidth: Longint;
    tmMaxCharWidth: Longint;
    tmWeight: Longint;
    tmOverhang: Longint;
    tmDigitizedAspectX: Longint;
    tmDigitizedAspectY: Longint;
    tmFirstChar: AnsiChar;
    tmLastChar: AnsiChar;
    tmDefaultChar: AnsiChar;
    tmBreakChar: AnsiChar;
    tmItalic: Byte;
    tmUnderlined: Byte;
    tmStruckOut: Byte;
    tmPitchAndFamily: Byte;
    tmCharSet: Byte;
    ntmFlags: DWORD;
    ntmSizeEM: UINT;
    ntmCellHeight: UINT;
    ntmAvgWidth: UINT;
  end;
  TNewTextMetricW = record
    tmHeight: Longint;
    tmAscent: Longint;
    tmDescent: Longint;
    tmInternalLeading: Longint;
    tmExternalLeading: Longint;
    tmAveCharWidth: Longint;
    tmMaxCharWidth: Longint;
    tmWeight: Longint;
    tmOverhang: Longint;
    tmDigitizedAspectX: Longint;
    tmDigitizedAspectY: Longint;
    tmFirstChar: WideChar;
    tmLastChar: WideChar;
    tmDefaultChar: WideChar;
    tmBreakChar: WideChar;
    tmItalic: Byte;
    tmUnderlined: Byte;
    tmStruckOut: Byte;
    tmPitchAndFamily: Byte;
    tmCharSet: Byte;
    ntmFlags: DWORD;
    ntmSizeEM: UINT;
    ntmCellHeight: UINT;
    ntmAvgWidth: UINT;
  end;
  TNewTextMetric = TNewTextMetricA;

  PNewTextMetricEx = ^TNewTextMetricEx;
  TNewTextMetricEx = packed record
    ntmTm: TNewTextMetric;
    ntmFontSig: TFontSignature;
  end;

  PPelArray = ^TPelArray;
  TPelArray = record
    paXCount: Longint;
    paYCount: Longint;
    paXExt: Longint;
    paYExt: Longint;
    paRGBs: Byte;
  end;

  PLogBrush = ^TLogBrush;
  TLogBrush = packed record
    lbStyle: UINT;
    lbColor: COLORREF;
    lbHatch: Longint;
  end;

  PPattern = ^TPattern;
  TPattern = TLogBrush;

  PLogPen = ^TLogPen;
  TLogPen = packed record
    lopnStyle: UINT;
    lopnWidth: TPoint;
    lopnColor: COLORREF;
  end;

  PExtLogPen = ^TLogPen;
  TExtLogPen = packed record
    elpPenStyle: DWORD;
    elpWidth: DWORD;
    elpBrushStyle: UINT;
    elpColor: COLORREF;
    elpHatch: Longint;
    elpNumEntries: DWORD;
    elpStyleEntry: array[0..0] of DWORD;
  end;

  PPaletteEntry = ^TPaletteEntry;
  TPaletteEntry = packed record
    peRed: Byte;
    peGreen: Byte;
    peBlue: Byte;
    peFlags: Byte;
  end;

  PLogPalette = ^TLogPalette;
  TLogPalette = packed record
    palVersion: Word;
    palNumEntries: Word;
    palPalEntry: array[0..0] of TPaletteEntry;
  end;

  PMaxLogPalette = ^TMaxLogPalette;
  TMaxLogPalette = packed record
    palVersion: Word;
    palNumEntries: Word;
    palPalEntry: array [Byte] of TPaletteEntry;
  end;

  PLogFontA = ^TLogFontA;
  PLogFontW = ^TLogFontW;
  PLogFont = PLogFontA;
  TLogFontA = packed record
    lfHeight: Longint;
    lfWidth: Longint;
    lfEscapement: Longint;
    lfOrientation: Longint;
    lfWeight: Longint;
    lfItalic: Byte;
    lfUnderline: Byte;
    lfStrikeOut: Byte;
    lfCharSet: Byte;
    lfOutPrecision: Byte;
    lfClipPrecision: Byte;
    lfQuality: Byte;
    lfPitchAndFamily: Byte;
    lfFaceName: array[0..LF_FACESIZE - 1] of AnsiChar;
  end;
  TLogFontW = packed record
    lfHeight: Longint;
    lfWidth: Longint;
    lfEscapement: Longint;
    lfOrientation: Longint;
    lfWeight: Longint;
    lfItalic: Byte;
    lfUnderline: Byte;
    lfStrikeOut: Byte;
    lfCharSet: Byte;
    lfOutPrecision: Byte;
    lfClipPrecision: Byte;
    lfQuality: Byte;
    lfPitchAndFamily: Byte;
    lfFaceName: array[0..LF_FACESIZE - 1] of WideChar;
  end;
  TLogFont = TLogFontA;

  PEnumLogFontA = ^TEnumLogFontA;
  PEnumLogFontW = ^TEnumLogFontW;
  PEnumLogFont = PEnumLogFontA;
  TEnumLogFontA = packed record
    elfLogFont: TLogFontA;
    elfFullName: array[0..LF_FULLFACESIZE - 1] of AnsiChar;
    elfStyle: array[0..LF_FACESIZE - 1] of AnsiChar;
  end;
  TEnumLogFontW = packed record
    elfLogFont: TLogFontW;
    elfFullName: array[0..LF_FULLFACESIZE - 1] of WideChar;
    elfStyle: array[0..LF_FACESIZE - 1] of WideChar;
  end;
  TEnumLogFont = TEnumLogFontA;

  PEnumLogFontEx = ^TEnumLogFontEx;
  TEnumLogFontEx = packed record
    elfLogFont: TLogFont;
    elfFullName: array[0..LF_FULLFACESIZE - 1] of Char;
    elfStyle: array[0..LF_FACESIZE - 1] of Char;
    elfScript: array[0..LF_FACESIZE - 1] of Char;
  end;

  PPanose = ^TPanose;
  TPanose = packed record
    bFamilyType: Byte;
    bSerifStyle: Byte;
    bWeight: Byte;
    bProportion: Byte;
    bContrast: Byte;
    bStrokeVariation: Byte;
    bArmStyle: Byte;
    bLetterform: Byte;
    bMidline: Byte;
    bXHeight: Byte;
  end;

  PExtLogFontA = ^TExtLogFontA;
  PExtLogFontW = ^TExtLogFontW;
  PExtLogFont = PExtLogFontA;
  TExtLogFontA = packed record
    elfLogFont: TLogFontA;
    elfFullName: array[0..LF_FULLFACESIZE - 1] of AnsiChar;
    elfStyle: array[0..LF_FACESIZE - 1] of AnsiChar;
    elfVersion: DWORD;
    elfStyleSize: DWORD;
    elfMatch: DWORD;
    elfReserved: DWORD;
    elfVendorId: array[0..ELF_VENDOR_SIZE - 1] of Byte;
    elfCulture: DWORD;
    elfPanose: TPanose;
  end;
  TExtLogFontW = packed record
    elfLogFont: TLogFontW;
    elfFullName: array[0..LF_FULLFACESIZE - 1] of WideChar;
    elfStyle: array[0..LF_FACESIZE - 1] of WideChar;
    elfVersion: DWORD;
    elfStyleSize: DWORD;
    elfMatch: DWORD;
    elfReserved: DWORD;
    elfVendorId: array[0..ELF_VENDOR_SIZE - 1] of Byte;
    elfCulture: DWORD;
    elfPanose: TPanose;
  end;
  TExtLogFont = TExtLogFontA;

  PDeviceModeA = ^TDeviceModeA;
  PDeviceModeW = ^TDeviceModeW;
  PDeviceMode = PDeviceModeA;
  TDeviceModeA = packed record
    dmDeviceName: array[0..CCHDEVICENAME - 1] of AnsiChar;
    dmSpecVersion: Word;
    dmDriverVersion: Word;
    dmSize: Word;
    dmDriverExtra: Word;
    dmFields: DWORD;
    dmOrientation: SHORT;
    dmPaperSize: SHORT;
    dmPaperLength: SHORT;
    dmPaperWidth: SHORT;
    dmScale: SHORT;
    dmCopies: SHORT;
    dmDefaultSource: SHORT;
    dmPrintQuality: SHORT;
    dmColor: SHORT;
    dmDuplex: SHORT;
    dmYResolution: SHORT;
    dmTTOption: SHORT;
    dmCollate: SHORT;
    dmFormName: array[0..CCHFORMNAME - 1] of AnsiChar;
    dmLogPixels: Word;
    dmBitsPerPel: DWORD;
    dmPelsWidth: DWORD;
    dmPelsHeight: DWORD;
    dmDisplayFlags: DWORD;
    dmDisplayFrequency: DWORD;
    dmICMMethod: DWORD;
    dmICMIntent: DWORD;
    dmMediaType: DWORD;
    dmDitherType: DWORD;
    dmICCManufacturer: DWORD;
    dmICCModel: DWORD;
    dmPanningWidth: DWORD;
    dmPanningHeight: DWORD;
  end;
  TDeviceModeW = packed record
    dmDeviceName: array[0..CCHDEVICENAME - 1] of WideChar;
    dmSpecVersion: Word;
    dmDriverVersion: Word;
    dmSize: Word;
    dmDriverExtra: Word;
    dmFields: DWORD;
    dmOrientation: SHORT;
    dmPaperSize: SHORT;
    dmPaperLength: SHORT;
    dmPaperWidth: SHORT;
    dmScale: SHORT;
    dmCopies: SHORT;
    dmDefaultSource: SHORT;
    dmPrintQuality: SHORT;
    dmColor: SHORT;
    dmDuplex: SHORT;
    dmYResolution: SHORT;
    dmTTOption: SHORT;
    dmCollate: SHORT;
    dmFormName: array[0..CCHFORMNAME - 1] of WideChar;
    dmLogPixels: Word;
    dmBitsPerPel: DWORD;
    dmPelsWidth: DWORD;
    dmPelsHeight: DWORD;
    dmDisplayFlags: DWORD;
    dmDisplayFrequency: DWORD;
    dmICMMethod: DWORD;
    dmICMIntent: DWORD;
    dmMediaType: DWORD;
    dmDitherType: DWORD;
    dmICCManufacturer: DWORD;
    dmICCModel: DWORD;
    dmPanningWidth: DWORD;
    dmPanningHeight: DWORD;
  end;
  TDeviceMode = TDeviceModeA;

  PRgnDataHeader = ^TRgnDataHeader;
  TRgnDataHeader = packed record
    dwSize: DWORD;
    iType: DWORD;
    nCount: DWORD;
    nRgnSize: DWORD;
    rcBound: TRect;
  end;

  PRgnData = ^TRgnData;
  TRgnData = record
    rdh: TRgnDataHeader;
    Buffer: array[0..0] of CHAR;
  end;

  PABC = ^TABC;
  TABC = packed record
    abcA: DWORD;
    abcB: UINT;
    abcC: DWORD;
  end;

  PABCFloat = ^TABCFloat;
  TABCFloat = packed record
    abcfA: Single;
    abcfB: Single;
    abcfC: Single;
  end;

  POutlineTextmetricA = ^TOutlineTextmetricA;
  POutlineTextmetricW = ^TOutlineTextmetricW;
  POutlineTextmetric = POutlineTextmetricA;
  TOutlineTextmetricA = record
    otmSize: UINT;
    otmTextMetrics: TTextMetricA;
    otmFiller: Byte;
    otmPanoseNumber: TPanose;
    otmfsSelection: UINT;
    otmfsType: UINT;
    otmsCharSlopeRise: DWORD;
    otmsCharSlopeRun: DWORD;
    otmItalicAngle: DWORD;
    otmEMSquare: UINT;
    otmAscent: DWORD;
    otmDescent: DWORD;
    otmLineGap: UINT;
    otmsCapEmHeight: UINT;
    otmsXHeight: UINT;
    otmrcFontBox: TRect;
    otmMacAscent: DWORD;
    otmMacDescent: DWORD;
    otmMacLineGap: UINT;
    otmusMinimumPPEM: UINT;
    otmptSubscriptSize: TPoint;
    otmptSubscriptOffset: TPoint;
    otmptSuperscriptSize: TPoint;
    otmptSuperscriptOffset: TPoint;
    otmsStrikeoutSize: UINT;
    otmsStrikeoutPosition: DWORD;
    otmsUnderscoreSize: DWORD;
    otmsUnderscorePosition: DWORD;
    otmpFamilyName: PAnsiChar;
    otmpFaceName: PAnsiChar;
    otmpStyleName: PAnsiChar;
    otmpFullName: PAnsiChar;
  end;
  TOutlineTextmetricW = record
    otmSize: UINT;
    otmTextMetrics: TTextMetricW;
    otmFiller: Byte;
    otmPanoseNumber: TPanose;
    otmfsSelection: UINT;
    otmfsType: UINT;
    otmsCharSlopeRise: DWORD;
    otmsCharSlopeRun: DWORD;
    otmItalicAngle: DWORD;
    otmEMSquare: UINT;
    otmAscent: DWORD;
    otmDescent: DWORD;
    otmLineGap: UINT;
    otmsCapEmHeight: UINT;
    otmsXHeight: UINT;
    otmrcFontBox: TRect;
    otmMacAscent: DWORD;
    otmMacDescent: DWORD;
    otmMacLineGap: UINT;
    otmusMinimumPPEM: UINT;
    otmptSubscriptSize: TPoint;
    otmptSubscriptOffset: TPoint;
    otmptSuperscriptSize: TPoint;
    otmptSuperscriptOffset: TPoint;
    otmsStrikeoutSize: UINT;
    otmsStrikeoutPosition: DWORD;
    otmsUnderscoreSize: DWORD;
    otmsUnderscorePosition: DWORD;
    otmpFamilyName: PWideChar;
    otmpFaceName: PWideChar;
    otmpStyleName: PWideChar;
    otmpFullName: PWideChar;
  end;
  TOutlineTextmetric = TOutlineTextmetricA;

  PPolyTextA = ^TPolyTextA;
  PPolyTextW = ^TPolyTextW;
  PPolyText = PPolyTextA;
  TPolyTextA = packed record
    x: DWORD;
    y: DWORD;
    n: UINT;
    PAnsiChar: PAnsiChar;
    uiFlags: UINT;
    rcl: TRect;
    pdx: PINT;
  end;
  TPolyTextW = packed record
    x: DWORD;
    y: DWORD;
    n: UINT;
    PAnsiChar: PWideChar;
    uiFlags: UINT;
    rcl: TRect;
    pdx: PINT;
  end;
  TPolyText = TPolyTextA;

  TFixed = packed record
    fract: Word;
    value: SHORT;
  end;

  PMat2 = ^TMat2;
  TMat2 = packed record
    eM11: TFixed;
    eM12: TFixed;
    eM21: TFixed;
    eM22: TFixed;
  end;

  PGlyphMetrics = ^TGlyphMetrics;
  TGlyphMetrics = packed record
    gmBlackBoxX: UINT;
    gmBlackBoxY: UINT;
    gmptGlyphOrigin: TPoint;
    gmCellIncX: SHORT;
    gmCellIncY: SHORT;
  end;

  PPointfx = ^TPointfx;
  TPointfx = packed record
    x: TFixed;
    y: TFixed;
  end;

  PTTPolyCurve = ^TTTPolyCurve;
  TTTPolyCurve = packed record
    wType: Word;
    cpfx: Word;
    apfx: array[0..0] of TPointFX;
  end;

  PTTPolygonHeader = ^TTTPolygonHeader;
  TTTPolygonHeader = packed record
    cb: DWORD;
    dwType: DWORD;
    pfxStart: TPointFX;
  end;

  PGCPResultsA = ^TGCPResultsA;
  PGCPResultsW = ^TGCPResultsW;
  PGCPResults = PGCPResultsA;
  TGCPResultsA = packed record
    lStructSize: DWORD;
    lpOutString: PAnsiChar;
    lpOrder: PUINT;
    lpDx: PINT;
    lpCaretPos: PINT;
    lpClass: PAnsiChar;
    lpGlyphs: PUINT;
    nGlyphs: UINT;
    nMaxFit: DWORD;
  end;
  TGCPResultsW = packed record
    lStructSize: DWORD;
    lpOutString: PWideChar;
    lpOrder: PUINT;
    lpDx: PINT;
    lpCaretPos: PINT;
    lpClass: PWideChar;
    lpGlyphs: PUINT;
    nGlyphs: UINT;
    nMaxFit: DWORD;
  end;
  TGCPResults = TGCPResultsA;

  PRasterizerStatus = ^TRasterizerStatus;
  TRasterizerStatus = packed record
    nSize: SHORT;
    wFlags: SHORT;
    nLanguageID: SHORT;
  end;

  PPixelFormatDescriptor = ^TPixelFormatDescriptor;
  TPixelFormatDescriptor = packed record
    nSize: Word;
    nVersion: Word;
    dwFlags: DWORD;
    iPixelType: Byte;
    cColorBits: Byte;
    cRedBits: Byte;
    cRedShift: Byte;
    cGreenBits: Byte;
    cGreenShift: Byte;
    cBlueBits: Byte;
    cBlueShift: Byte;
    cAlphaBits: Byte;
    cAlphaShift: Byte;
    cAccumBits: Byte;
    cAccumRedBits: Byte;
    cAccumGreenBits: Byte;
    cAccumBlueBits: Byte;
    cAccumAlphaBits: Byte;
    cDepthBits: Byte;
    cStencilBits: Byte;
    cAuxBuffers: Byte;
    iLayerType: Byte;
    bReserved: Byte;
    dwLayerMask: DWORD;
    dwVisibleMask: DWORD;
    dwDamageMask: DWORD;
  end;

  TFNOldFontEnumProcA = TFarProc;
  TFNOldFontEnumProcW = TFarProc;
  TFNOldFontEnumProc = TFNOldFontEnumProcA;
  TFNGObjEnumProc = TFarProc;
  TFNLineDDAProc = TFarProc;
  TFNFontEnumProcA = TFarProc;
  TFNFontEnumProcW = TFarProc;
  TFNFontEnumProc = TFNFontEnumProcA;

  TFNDevMode = function conv (arg_stdcall) (Wnd: HWND; Driver: HMODULE;
    var DevModeOutput: TDeviceMode; DeciveName, Port: LPSTR;
    var DevModeInput: TDeviceMode; Profile: LPSTR; Mode: UINT): UINT;
  TFNDevCaps = function conv (arg_stdcall) (DeviceName, Port: LPSTR;
    Index: UINT; Output: LPSTR; var DevMode: TDeviceMode): DWORD;

  TFNMFEnumProc = TFarProc;
  TFNEnhMFEnumProc = TFarProc;

  PDIBSection = ^TDIBSection;
  TDIBSection = packed record
    dsBm: TBitmap;
    dsBmih: TBitmapInfoHeader;
    dsBitfields: array[0..2] of DWORD;
    dshSection: THandle;
    dsOffset: DWORD;
  end;

  PColorAdjustment = ^TColorAdjustment;
  TColorAdjustment = packed record
    caSize: Word;
    caFlags: Word;
    caIlluminantIndex: Word;
    caRedGamma: Word;
    caGreenGamma: Word;
    caBlueGamma: Word;
    caReferenceBlack: Word;
    caReferenceWhite: Word;
    caContrast: SHORT;
    caBrightness: SHORT;
    caColorfulness: SHORT;
    caRedGreenTint: SHORT;
  end;

  TFNAbortProc = function conv (arg_stdcall) (DC: HDC; p2: DWORD): BOOL;

  PDocInfoA = ^TDocInfoA;
  PDocInfoW = ^TDocInfoW;
  PDocInfo = PDocInfoA;
  TDocInfoA = packed record
    cbSize: DWORD;
    lpszDocName: PAnsiChar;
    lpszOutput: PAnsiChar;
    lpszDatatype: PAnsiChar;
    fwType: DWORD;
  end;
  TDocInfoW = packed record
    cbSize: DWORD;
    lpszDocName: PWideChar;
    lpszOutput: PWideChar;
    lpszDatatype: PWideChar;
    fwType: DWORD;
  end;
  TDocInfo = TDocInfoA;

  PKerningPair = ^TKerningPair;
  TKerningPair = packed record
    wFirst: Word;
    wSecond: Word;
    iKernAmount: DWORD;
  end;

  TFNICMEnumProc = TFarProc;

  PEMR = ^TEMR;
  TEMR = packed record
    iType: DWORD;
    nSize: DWORD;
  end;

  PEMRText = ^TEMRText;
  TEMRText = packed record
    ptlReference: TPoint;
    nChars: DWORD;
    offString: DWORD;
    fOptions: DWORD;
    rcl: TRect;
    offDx: DWORD;
  end;

  PAbortPath = ^TAbortPath;
  TAbortPath = packed record
    emr: TEMR;
  end;
  TEMRAbortPath = TAbortPath;
  PEMRAbortPath = PAbortPath;
  TEMRBeginPath = TAbortPath;
  PEMRBeginPath = PAbortPath;
  TEMREndPath = TAbortPath;
  PEMREndPath = PAbortPath;
  TEMRCloseFigure = TAbortPath;
  PEMRCloseFigure = PAbortPath;
  TEMRFlattenPath = TAbortPath;
  PEMRFlattenPath = PAbortPath;
  TEMRWidenPath = TAbortPath;
  PEMRWidenPath = PAbortPath;
  TEMRSetMetaRgn = TAbortPath;
  PEMRSetMetaRgn = PAbortPath;
  TEMRSaveDC = TAbortPath;
  PEMRSaveDC = PAbortPath;
  TEMRRealizePalette = TAbortPath;
  PEMRRealizePalette = PAbortPath;

  PEMRSelectclippath = ^TEMRSelectClipPath;
  TEMRSelectClipPath = packed record
    emr: TEMR;
    iMode: DWORD;
  end;
  TEMRSetBkMode = TEMRSelectClipPath;
  PEMRSetBkMode = PEMRSelectClipPath;
  TEMRSetMapMode = TEMRSelectClipPath;
  PEMRSetMapMode = PEMRSelectClipPath;
  TEMRSetPolyFillMode = TEMRSelectClipPath;
  PEMRSetPolyFillMode = PEMRSelectClipPath;
  TEMRSetRop2 = TEMRSelectClipPath;
  PEMRSetRop2 = PEMRSelectClipPath;
  TEMRSetStretchBltMode = TEMRSelectClipPath;
  PEMRSetStretchBltMode = PEMRSelectClipPath;
  TEMRSetICMMode = TEMRSelectClipPath;
  PEMRSetICMMode = PEMRSelectClipPath;
  TEMRSetTextAlign = TEMRSelectClipPath;
  PEMRSetTextAlign = PEMRSelectClipPath;

  PEMRSetMiterLimit = ^TEMRSetMiterLimit;
  TEMRSetMiterLimit = packed record
    emr: TEMR;
    eMiterLimit: Single;
  end;

  PEMRRestoreDC = ^TEMRRestoreDC;
  TEMRRestoreDC = packed record
    emr: TEMR;
    iRelative: Longint;
  end;

  PEMRSetArcDirection = ^TEMRSetArcDirection;
  TEMRSetArcDirection = packed record
    emr: TEMR;
    iArcDirection: DWORD;
  end;

  PEMRSetMapperFlags = ^TEMRSetMapperFlags;
  TEMRSetMapperFlags = packed record
    emr: TEMR;
    dwFlags: DWORD;
  end;

  PEMRSetTextColor = ^TEMRSetTextColor;
  TEMRSetTextColor = packed record
    emr: TEMR;
    crColor: COLORREF;
  end;
  TEMRSetBkColor = TEMRSetTextColor;
  PEMRSetBkColor = PEMRSetTextColor;

  PEMRSelectObject = ^TEMRSelectObject;
  TEMRSelectObject = packed record
    emr: TEMR;
    ihObject: DWORD;
  end;
  EMRDeleteObject = TEMRSelectObject;
  PEMRDeleteObject = PEMRSelectObject;

  PEMRSelectColorSpace = ^TEMRSelectColorSpace;
  TEMRSelectColorSpace = packed record
    emr: TEMR;
    ihCS: DWORD;
  end;
  EMRDeleteColorSpace = TEMRSelectColorSpace;
  PEMRDeleteColorSpace = PEMRSelectColorSpace;

  PEMRSelectPalette = ^TEMRSelectPalette;
  TEMRSelectPalette = packed record
    emr: TEMR;
    ihPal: DWORD;
  end;

  PEMRResizePalette = ^TEMRResizePalette;
  TEMRResizePalette = packed record
    emr: TEMR;
    ihPal: DWORD;
    cEntries: DWORD;
  end;

  PEMRSetPaletteEntries = ^TEMRSetPaletteEntries;
  TEMRSetPaletteEntries = packed record
    emr: TEMR;
    ihPal: DWORD;
    iStart: DWORD;
    cEntries: DWORD;
    aPalEntries: array[0..0] of TPaletteEntry;
  end;

  PEMRSetColorAdjustment = ^TEMRSetColorAdjustment;
  TEMRSetColorAdjustment =  packed record
    emr: TEMR;
    ColorAdjustment: TColorAdjustment;
  end;

  PEMRGDIComment = ^TEMRGDIComment;
  TEMRGDIComment = packed record
    emr: TEMR;
    cbData: DWORD;
    Data: array[0..0] of Byte;
  end;

  PEMREOF = ^TEMREOF;
  TEMREOF =  packed record
    emr: TEMR;
    nPalEntries: DWORD;
    offPalEntries: DWORD;
    nSizeLast: DWORD;
  end;

  PEMRLineTo = ^TEMRLineTo;
  TEMRLineTo =  packed record
    emr: TEMR;
    ptl: TPoint;
  end;
  EMRMoveToEx = TEMRLineTo;
  PEMRMoveToEx = PEMRLineTo;

  PEMROffsetClipRgn = ^TEMROffsetClipRgn;
  TEMROffsetClipRgn =  packed record
    emr: TEMR;
    ptlOffset: TPoint;
  end;

  PEMRFillPath = ^TEMRFillPath;
  TEMRFillPath =  packed record
    emr: TEMR;
    rclBounds: TRect;
  end;

  EMRStrokeAndFillPath = TEMRFillPath;
  PEMRStrokeAndFillPath = PEMRFillPath;
  EMRStrokePath = TEMRFillPath;
  PEMRStrokePath = PEMRFillPath;

  PEMRExcludeClipRect = ^TEMRExcludeClipRect;
  TEMRExcludeClipRect =  packed record
    emr: TEMR;
    rclClip: TRect;
  end;

  EMRIntersectClipRect = TEMRExcludeClipRect;
  PEMRIntersectClipRect = PEMRExcludeClipRect;

  PEMRSetViewportOrgEx = ^TEMRSetViewportOrgEx;
  TEMRSetViewportOrgEx =  packed record
    emr: TEMR;
    ptlOrigin: TPoint;
  end;

  EMRSetWindowOrgEx = TEMRSetViewportOrgEx;
  PEMRSetWindowOrgEx = PEMRSetViewportOrgEx;
  EMRSetBrushOrgEx = TEMRSetViewportOrgEx;
  PEMRSetBrushOrgEx = PEMRSetViewportOrgEx;

  PEMRSetViewportExtEx = ^TEMRSetViewportExtEx;
  TEMRSetViewportExtEx =  packed record
    emr: TEMR;
    szlExtent: TSize;
  end;

  EMRSetWindowExtEx = TEMRSetViewportExtEx;
  PEMRSetWindowExtEx = PEMRSetViewportExtEx;

  PEMRScaleViewportExtEx = ^TEMRScaleViewportExtEx;
  TEMRScaleViewportExtEx =  packed record
    emr: TEMR;
    xNum: Longint;
    xDenom: Longint;
    yNum: Longint;
    yDenom: Longint;
  end;
  EMRScaleWindowExtEx = TEMRScaleViewportExtEx;
  PEMRScaleWindowExtEx = PEMRScaleViewportExtEx;

  PEMRSetWorldTransform = ^TEMRSetWorldTransform;
  TEMRSetWorldTransform =  packed record
    emr: TEMR;
    xform: TXForm;
  end;

  PEMRModifyWorldTransform = ^TEMRModifyWorldTransform;
  TEMRModifyWorldTransform =  packed record
    emr: TEMR;
    xform: TXForm;
    iMode: DWORD;
  end;

  PEMRSetPixelV = ^TEMRSetPixelV;
  TEMRSetPixelV =  packed record
    emr: TEMR;
    ptlPixel: TPoint;
    crColor: COLORREF;
  end;

  PEMRExtFloodFill = ^TEMRExtFloodFill;
  TEMRExtFloodFill =  packed record
    emr: TEMR;
    ptlStart: TPoint;
    crColor: COLORREF;
    iMode: DWORD;
  end;

  PEMREllipse = ^TEMREllipse;
  TEMREllipse =  packed record
    emr: TEMR;
    rclBox: TRect;
  end;

  EMRRectangle = TEMREllipse;
  PEMRRectangle = PEMREllipse;

  PEMRRoundRect = ^TEMRRoundRect;
  TEMRRoundRect =  packed record
    emr: TEMR;
    rclBox: TRect;
    szlCorner: TSize;
  end;

  PEMRArc = ^TEMRArc;
  TEMRArc =  packed record
    emr: TEMR;
    rclBox: TRect;
    ptlStart: TPoint;
    ptlEnd: TPoint;
  end;

  EMRArcTo = TEMRArc;
  PEMRArcTo = PEMRArc;
  EMRChord = TEMRArc;
  PEMRChord = PEMRArc;
  EMRPie = TEMRArc;
  PEMRPie = PEMRArc;

  PEMRAngleArc = ^TEMRAngleArc;
  TEMRAngleArc =  packed record
    emr: TEMR;
    ptlCenter: TPoint;
    nRadius: DWORD;
    eStartAngle: Single;
    eSweepAngle: Single;
  end;

  PEMRPolyline = ^TEMRPolyline;
  TEMRPolyline =  packed record
    emr: TEMR;
    rclBounds: TRect;
    cptl: DWORD;
    aptl: array[0..0] of TPoint;
  end;

  EMRPolyBezier = TEMRPolyLine;
  PEMRPolyBezier = PEMRPolyLine;
  EMRPolyGON = TEMRPolyLine;
  PEMRPolyGON = PEMRPolyLine;
  EMRPolyBezierTo = TEMRPolyLine;
  PEMRPolyBezierTo = PEMRPolyLine;
  EMRPolyLineTo = TEMRPolyLine;
  PEMRPolyLineTo = PEMRPolyLine;

  PEMRPolyline16 = ^TEMRPolyline16;
  TEMRPolyline16 =  packed record
    emr: TEMR;
    rclBounds: TRect;
    cpts: DWORD;
    apts: array[0..0] of TSmallPoint;
  end;

  EMRPolyBezier16 = TEMRPolyLine16;
  PEMRPolyBezier16 = PEMRPolyLine16;
  EMRPolygon16 = TEMRPolyLine16;
  PEMRPolygon16 = PEMRPolyLine16;
  EMRPolyBezierTo16 = TEMRPolyLine16;
  PEMRPolyBezierTo16 = PEMRPolyLine16;
  EMRPolyLineTo16 = TEMRPolyLine16;
  PEMRPolyLineTo16 = PEMRPolyLine16;

  PEMRPolyDraw = ^TEMRPolyDraw;
  TEMRPolyDraw = record
    emr: TEMR;
    rclBounds: TRect;
    cptl: DWORD;
    aptl: array[0..0] of TPoint;
    abTypes: array[0..0] of Byte;
  end;

  PEMRPolyDraw16 = ^TEMRPolyDraw16;
  TEMRPolyDraw16 = record
    emr: TEMR;
    rclBounds: TRect;
    cpts: DWORD;
    apts: array[0..0] of TSmallPoint;
    abTypes: array[0..0] of Byte;
  end;

  PEMRPolyPolyline = ^TEMRPolyPolyline;
  TEMRPolyPolyline =  packed record
    emr: TEMR;
    rclBounds: TRect;
    nPolys: DWORD;
    cptl: DWORD;
    aPolyCounts: array[0..0] of DWORD;
    aptl: array[0..0] of TPoint;
  end;
  EMRPolyPolygon = TEMRPolyPolyline;
  PEMRPolyPolygon = PEMRPolyPolyline;

  PEMRPolyPolyline16 = ^TEMRPolyPolyline16;
  TEMRPolyPolyline16 =  packed record
    emr: TEMR;
    rclBounds: TRect;
    nPolys: DWORD;
    cpts: DWORD;
    aPolyCounts: array[0..0] of DWORD;
    apts: array[0..0] of TSmallPoint;
  end;

  EMRPolyPolygon16 = TEMRPolyPolyline16;
  PEMRPolyPolygon16 = PEMRPolyPolyline16;

  PEMRInvertRgn = ^TEMRInvertRgn;
  TEMRInvertRgn = record
    emr: TEMR;
    rclBounds: TRect;
    cbRgnData: DWORD;
    RgnData: array[0..0] of Byte;
  end;
  EMRPaintRgn = TEMRInvertRgn;
  PEMRPaintRgn = PEMRInvertRgn;

  PEMRFillRgn = ^TEMRFillRgn;
  TEMRFillRgn = record
    emr: TEMR;
    rclBounds: TRect;
    cbRgnData: DWORD;
    ihBrush: DWORD;
    RgnData: array[0..0] of Byte;
  end;

  PEMRFrameRgn = ^TEMRFrameRgn;
  TEMRFrameRgn = record
    emr: TEMR;
    rclBounds: TRect;
    cbRgnData: DWORD;
    ihBrush: DWORD;
    szlStroke: TSize;
    RgnData: array[0..0] of Byte;
  end;

  PEMRExtSelectClipRgn = ^TEMRExtSelectClipRgn;
  TEMRExtSelectClipRgn = record
    emr: TEMR;
    cbRgnData: DWORD;
    iMode: DWORD;
    RgnData: array[0..0] of Byte;
  end;

  PEMRExtTextOut = ^TEMRExtTextOut;
  TEMRExtTextOut =  packed record
    emr: TEMR;
    rclBounds: TRect;
    iGraphicsMode: DWORD;
    exScale: Single;
    eyScale: Single;
    emrtext: TEMRText;
  end;

  PEMRPolyTextOut = ^TEMRPolyTextOut;
  TEMRPolyTextOut =  packed record
    emr: TEMR;
    rclBounds: TRect;
    iGraphicsMode: DWORD;
    exScale: Single;
    eyScale: Single;
    cStrings: Longint;
    aemrtext: array[0..0] of TEMRText;
  end;

  PEMRBitBlt = ^TEMRBitBlt;
  TEMRBitBlt =  packed record
    emr: TEMR;
    rclBounds: TRect;
    xDest: Longint;
    yDest: Longint;
    cxDest: Longint;
    cyDest: Longint;
    dwRop: DWORD;
    xSrc: Longint;
    ySrc: Longint;
    xformSrc: TXForm;
    crBkColorSrc: COLORREF;
    iUsageSrc: DWORD;
    offBmiSrc: DWORD;
    cbBmiSrc: DWORD;
    offBitsSrc: DWORD;
    cbBitsSrc: DWORD;
  end;

  PEMRStretchBlt = ^TEMRStretchBlt;
  TEMRStretchBlt =  packed record
    emr: TEMR;
    rclBounds: TRect;
    xDest: Longint;
    yDest: Longint;
    cxDest: Longint;
    cyDest: Longint;
    dwRop: DWORD;
    xSrc: Longint;
    ySrc: Longint;
    xformSrc: TXForm;
    crBkColorSrc: COLORREF;
    iUsageSrc: DWORD;
    offBmiSrc: DWORD;
    cbBmiSrc: DWORD;
    offBitsSrc: DWORD;
    cbBitsSrc: DWORD;
    cxSrc: Longint;
    cySrc: Longint;
  end;

  PEMRMaskBlt = ^TEMRMaskBlt;
  TEMRMaskBlt =  packed record
    emr: TEMR;
    rclBounds: TRect;
    xDest: Longint;
    yDest: Longint;
    cxDest: Longint;
    cyDest: Longint;
    dwRop: DWORD;
    xSrc: Longint;
    ySrc: Longint;
    xformSrc: TXForm;
    crBkColorSrc: COLORREF;
    iUsageSrc: DWORD;
    offBmiSrc: DWORD;
    cbBmiSrc: DWORD;
    offBitsSrc: DWORD;
    cbBitsSrc: DWORD;
    xMask: Longint;
    yMask: Longint;
    iUsageMask: DWORD;
    offBmiMask: DWORD;
    cbBmiMask: DWORD;
    offBitsMask: DWORD;
    cbBitsMask: DWORD;
  end;

  PEMRPLGBlt = ^TEMRPLGBlt;
  TEMRPLGBlt =  packed record
    emr: TEMR;
    rclBounds: TRect;
    aptlDest: array[0..2] of TPoint;
    xSrc: Longint;
    ySrc: Longint;
    cxSrc: Longint;
    cySrc: Longint;
    xformSrc: TXForm;
    crBkColorSrc: COLORREF;
    iUsageSrc: DWORD;
    offBmiSrc: DWORD;
    cbBmiSrc: DWORD;
    offBitsSrc: DWORD;
    cbBitsSrc: DWORD;
    xMask: Longint;
    yMask: Longint;
    iUsageMask: DWORD;
    offBmiMask: DWORD;
    cbBmiMask: DWORD;
    offBitsMask: DWORD;
    cbBitsMask: DWORD;
  end;

  PEMRSetDIBitsToDevice = ^TEMRSetDIBitsToDevice;
  TEMRSetDIBitsToDevice =  packed record
    emr: TEMR;
    rclBounds: TRect;
    xDest: Longint;
    yDest: Longint;
    xSrc: Longint;
    ySrc: Longint;
    cxSrc: Longint;
    cySrc: Longint;
    offBmiSrc: DWORD;
    cbBmiSrc: DWORD;
    offBitsSrc: DWORD;
    cbBitsSrc: DWORD;
    iUsageSrc: DWORD;
    iStartScan: DWORD;
    cScans: DWORD;
  end;

  PEMRStretchDIBits = ^TEMRStretchDIBits;
  TEMRStretchDIBits =  packed record
    emr: TEMR;
    rclBounds: TRect;
    xDest: Longint;
    yDest: Longint;
    xSrc: Longint;
    ySrc: Longint;
    cxSrc: Longint;
    cySrc: Longint;
    offBmiSrc: DWORD;
    cbBmiSrc: DWORD;
    offBitsSrc: DWORD;
    cbBitsSrc: DWORD;
    iUsageSrc: DWORD;
    dwRop: DWORD;
    cxDest: Longint;
    cyDest: Longint;
  end;

  PEMRExtCreateFontIndirect = ^TEMRExtCreateFontIndirect;
  TEMRExtCreateFontIndirect = packed record
    emr: TEMR;
    ihFont: DWORD;
    elfw: TExtLogFontW;
  end;

  PEMRCreatePalette = ^TEMRCreatePalette;
  TEMRCreatePalette =  packed record
    emr: TEMR;
    ihPal: DWORD;
    lgpl: TLogPalette;
  end;

  PEMRCreateColorSpace = ^TEMRCreateColorSpace;
  TEMRCreateColorSpace =  packed record
    emr: TEMR;
    ihCS: DWORD;
    lcs: TLogColorSpaceW;
  end;

  PEMRCreatePen = ^TEMRCreatePen;
  TEMRCreatePen =  packed record
    emr: TEMR;
    ihPen: DWORD;
    lopn: TLogPen;
  end;

  PEMRExtCreatePen = ^TEMRExtCreatePen;
  TEMRExtCreatePen =  packed record
    emr: TEMR;
    ihPen: DWORD;
    offBmi: DWORD;
    cbBmi: DWORD;
    offBits: DWORD;
    cbBits: DWORD;
    elp: TExtLogPen;
  end;

  PEMRCreateBrushIndirect = ^TEMRCreateBrushIndirect;
  TEMRCreateBrushIndirect =  packed record
    emr: TEMR;
    ihBrush: DWORD;
    lb: TLogBrush;
  end;

  PEMRCreateMonoBrush = ^TEMRCreateMonoBrush;
  TEMRCreateMonoBrush =  packed record
    emr: TEMR;
    ihBrush: DWORD;
    iUsage: DWORD;
    offBmi: DWORD;
    cbBmi: DWORD;
    offBits: DWORD;
    cbBits: DWORD;
  end;

  PEMRCreateDIBPatternBrushPt = ^TEMRCreateDIBPatternBrushPt;
  TEMRCreateDIBPatternBrushPt =  packed record
    emr: TEMR;
    ihBrush: DWORD;
    iUsage: DWORD;
    offBmi: DWORD;
    cbBmi: DWORD;
    offBits: DWORD;
    cbBits: DWORD;
  end;

  PEMRFormat = ^TEMRFormat;
  TEMRFormat =  packed record
    dSignature: DWORD;
    nVersion: DWORD;
    cbData: DWORD;
    offData: DWORD;
  end;

  PEMRGLSRecord = ^TEMRGLSRecord;
  TEMRGLSRecord =  packed record
    emr: TEMR;
    cbData: DWORD;
    Data:  array[0..0] of Byte;
  end;

  PEMRGLSBoundedRecord = ^TEMRGLSBoundedRecord;
  TEMRGLSBoundedRecord =  packed record
    emr: TEMR;
    rclBounds: TRect;
    cbData: DWORD;
    Data:  array[0..0] of Byte;
  end;

  PEMRPixelFormat = ^TEMRPixelFormat;
  TEMRPixelFormat =  packed record
    emr: TEMR;
    pfd: TPixelFormatDescriptor;
  end;

  PPointFloat = ^TPointFloat;
  TPointFloat =  packed record
    x: Single;
    y: Single;
  end;

  PGlyphMetricsFloat = ^TGlyphMetricsFloat;
  TGlyphMetricsFloat =  packed record
    gmfBlackBoxX: Single;
    gmfBlackBoxY: Single;
    gmfptGlyphOrigin: TPointFloat;
    gmfCellIncX: Single;
    gmfCellIncY: Single;
  end;

  PLayerPlaneDescriptor = ^TLayerPlaneDescriptor;
  TLayerPlaneDescriptor =  packed record
    nSize: Word;
    nVersion: Word;
    dwFlags: DWORD;
    iPixelType: Byte;
    cColorBits: Byte;
    cRedBits: Byte;
    cRedShift: Byte;
    cGreenBits: Byte;
    cGreenShift: Byte;
    cBlueBits: Byte;
    cBlueShift: Byte;
    cAlphaBits: Byte;
    cAlphaShift: Byte;
    cAccumBits: Byte;
    cAccumRedBits: Byte;
    cAccumGreenBits: Byte;
    cAccumBlueBits: Byte;
    cAccumAlphaBits: Byte;
    cDepthBits: Byte;
    cStencilBits: Byte;
    cAuxBuffers: Byte;
    iLayerPlane: Byte;
    bReserved: Byte;
    crTransparent: COLORREF;
  end;

  HDWP = THandle;
  PMENUTEMPLATE = Pointer;
  va_list = PChar;

  TFNWndProc = TFarProc;
  TFNDlgProc = TFarProc;
  TFNTimerProc = TFarProc;
  TFNGrayStringProc = TFarProc;
  TFNWndEnumProc = TFarProc;
  TFNSendAsyncProc = TFarProc;
  TFNDrawStateProc = TFarProc;

  TFNHookProc = function conv (arg_stdcall) (code: DWORD; wparam: WPARAM; lparam: LPARAM): LRESULT;

  TFNPropEnumProc = TFarProc;
  TFNPropEnumProcEx = TFarProc;
  TFNEditWordBreakProc = TFarProc;
  TFNNameEnumProc = TFarProc;
  TFNWinStaEnumProc = TFNNameEnumProc;
  TFNDeskTopEnumProc = TFNNameEnumProc;

  PCreateStructA = ^TCreateStructA;
  PCreateStructW = ^TCreateStructW;
  PCreateStruct = PCreateStructA;
  TCreateStructA =  packed record
    lpCreateParams: Pointer;
    hInstance: HINST;
    hMenu: HMENU;
    hwndParent: HWND;
    cy: DWORD;
    cx: DWORD;
    y: DWORD;
    x: DWORD;
    style: Longint;
    lpszName: PAnsiChar;
    lpszClass: PAnsiChar;
    dwExStyle: DWORD;
  end;
  TCreateStructW =  packed record
    lpCreateParams: Pointer;
    hInstance: HINST;
    hMenu: HMENU;
    hwndParent: HWND;
    cy: DWORD;
    cx: DWORD;
    y: DWORD;
    x: DWORD;
    style: Longint;
    lpszName: PWideChar;
    lpszClass: PWideChar;
    dwExStyle: DWORD;
  end;
  TCreateStruct = TCreateStructA;

  PCBTCreateWnd = ^TCBTCreateWnd;
  TCBTCreateWnd =  record
    lpcs: PCreateStruct;
    hwndInsertAfter: HWND;
  end;

  PCBTActivateStruct = ^TCBTActivateStruct;
  TCBTActivateStruct =  packed record
    fMouse: LONGBOOL;
    hWndActive: HWND;
  end;

  PEventMsg = ^TEventMsg;
  TEventMsg =  packed record
    message: UINT;
    paramL: UINT;
    paramH: UINT;
    time: DWORD;
    hwnd: HWND;
  end;

  PCWPStruct = ^TCWPStruct;
  TCWPStruct =  packed record
    lParam: LPARAM;
    wParam: WPARAM;
    message: UINT;
    hwnd: HWND;
  end;

  PCWPRetStruct = ^TCWPRetStruct;
  TCWPRetStruct =  packed record
    lResult: LRESULT;
    lParam: LPARAM;
    wParam: WPARAM;
    message: UINT;
    hwnd: HWND;
  end;

  PDebugHookInfo = ^TDebugHookInfo;
  TDebugHookInfo =  packed record
    idThread: DWORD;
    idThreadInstaller: DWORD;
    lParam: LPARAM;
    wParam: WPARAM;
    code: DWORD;
  end;

  PMouseHookStruct = ^TMouseHookStruct;
  TMouseHookStruct =  packed record
    pt: TPoint;
    hwnd: HWND;
    wHitTestCode: UINT;
    dwExtraInfo: DWORD;
  end;

  PHardwareHookStruct = ^THardwareHookStruct;
  THardwareHookStruct =  packed record
    hwnd: HWND;
    message: UINT;
    wParam: WPARAM;
    lParam: LPARAM;
  end;

  PUserObjectFlags = ^TUserObjectFlags;
  TUserObjectFlags =  packed record
    fInherit: LONGBOOL;
    fReserved: LONGBOOL;
    dwFlags: DWORD;
  end;

  PWndClassExA = ^TWndClassExA;
  PWndClassExW = ^TWndClassExW;
  PWndClassEx = PWndClassExA;
  TWndClassExA =  packed record
    cbSize: UINT;
    style: UINT;
    lpfnWndProc: TFNWndProc;
    cbClsExtra: DWORD;
    cbWndExtra: DWORD;
    hInstance: HINST;
    hIcon: HICON;
    hCursor: HCURSOR;
    hbrBackground: HBRUSH;
    lpszMenuName: PAnsiChar;
    lpszClassName: PAnsiChar;
    hIconSm: HICON;
  end;
  TWndClassExW =  packed record
    cbSize: UINT;
    style: UINT;
    lpfnWndProc: TFNWndProc;
    cbClsExtra: DWORD;
    cbWndExtra: DWORD;
    hInstance: HINST;
    hIcon: HICON;
    hCursor: HCURSOR;
    hbrBackground: HBRUSH;
    lpszMenuName: PWideChar;
    lpszClassName: PWideChar;
    hIconSm: HICON;
  end;
  TWndClassEx = TWndClassExA;

  PWndClassA = ^TWndClassA;
  PWndClassW = ^TWndClassW;
  PWndClass = PWndClassA;
  TWndClassA =  packed record
    style: UINT;
    lpfnWndProc: TFNWndProc;
    cbClsExtra: DWORD;
    cbWndExtra: DWORD;
    hInstance: HINST;
    hIcon: HICON;
    hCursor: HCURSOR;
    hbrBackground: HBRUSH;
    lpszMenuName: PAnsiChar;
    lpszClassName: PAnsiChar;
  end;
  TWndClassW =  packed record
    style: UINT;
    lpfnWndProc: TFNWndProc;
    cbClsExtra: DWORD;
    cbWndExtra: DWORD;
    hInstance: HINST;
    hIcon: HICON;
    hCursor: HCURSOR;
    hbrBackground: HBRUSH;
    lpszMenuName: PWideChar;
    lpszClassName: PWideChar;
  end;
  TWndClass = TWndClassA;

  PMsg = ^TMsg;
  TMsg =  packed record
    hwnd: HWND;
    message: UINT;
    wParam: WPARAM;
    lParam: LPARAM;
    time: DWORD;
    pt: TPoint;
  end;

  PMinMaxInfo = ^TMinMaxInfo;
  TMinMaxInfo =  packed record
    ptReserved: TPoint;
    ptMaxSize: TPoint;
    ptMaxPosition: TPoint;
    ptMinTrackSize: TPoint;
    ptMaxTrackSize: TPoint;
  end;

  PCopyDataStruct = ^TCopyDataStruct;
  TCopyDataStruct =  packed record
    dwData: DWORD;
    cbData: DWORD;
    lpData: Pointer;
  end;

  PMDINextMenu = ^TMDINextMenu;
  TMDINextMenu =  packed record
    hmenuIn: HMENU;
    hmenuNext: HMENU;
    hwndNext: HWND;
  end;

  PWindowPos = ^TWindowPos;
  TWindowPos =  packed record
    hwnd: HWND;
    hwndInsertAfter: HWND;
    x: DWORD;
    y: DWORD;
    cx: DWORD;
    cy: DWORD;
    flags: UINT;
  end;

  PNCCalcSizeParams = ^TNCCalcSizeParams;
  TNCCalcSizeParams =  packed record
    rgrc: array[0..2] of TRect;
    lppos: PWindowPos;
  end;

  PTrackMouseEvent = ^TTrackMouseEvent;
        TTrackMouseEvent = record
    cbSize: DWORD;
    dwFlags: DWORD;
    hwndTrack: HWND;
    dwHoverTime: DWORD;
  end;

  PAccel = ^TAccel;
  TAccel =  packed record
    fVirt: Word;
    key: Word;
    cmd: Word;
  end;

  PPaintStruct = ^TPaintStruct;
  TPaintStruct =  packed record
    hdc: HDC;
    fErase: LONGBOOL;
    rcPaint: TRect;
    fRestore: LONGBOOL;
    fIncUpdate: LONGBOOL;
    rgbReserved: array[0..31] of Byte;
  end;

  PWindowPlacement = ^TWindowPlacement;
  TWindowPlacement =  packed record
    length: UINT;
    flags: UINT;
    showCmd: UINT;
    ptMinPosition: TPoint;
    ptMaxPosition: TPoint;
    rcNormalPosition: TRect;
  end;

  PNMHdr = ^TNMHdr;
  TNMHdr =  packed record
    hwndFrom: HWND;
    idFrom: UINT;
    code: DWORD;
  end;

  PStyleStruct = ^TStyleStruct;
  TStyleStruct =  packed record
    styleOld: DWORD;
    styleNew: DWORD;
  end;

  PMeasureItemStruct = ^TMeasureItemStruct;
  TMeasureItemStruct =  packed record
    CtlType: UINT;
    CtlID: UINT;
    itemID: UINT;
    itemWidth: UINT;
    itemHeight: UINT;
    itemData: DWORD;
  end;

  PDrawItemStruct = ^TDrawItemStruct;
  TDrawItemStruct =  packed record
    CtlType: UINT;
    CtlID: UINT;
    itemID: UINT;
    itemAction: UINT;
    itemState: UINT;
    hwndItem: HWND;
    hDC: HDC;
    rcItem: TRect;
    itemData: DWORD;
  end;

  PDeleteItemStruct = ^TDeleteItemStruct;
  TDeleteItemStruct =  packed record
    CtlType: UINT;
    CtlID: UINT;
    itemID: UINT;
    hwndItem: HWND;
    itemData: UINT;
  end;

  PCompareItemStruct = ^TCompareItemStruct;
  TCompareItemStruct =  packed record
    CtlType: UINT;
    CtlID: UINT;
    hwndItem: HWND;
    itemID1: UINT;
    itemData1: DWORD;
    itemID2: UINT;
    itemData2: DWORD;
    dwLocaleId: DWORD;
  end;

  PBroadcastSysMsg = ^TBroadcastSysMsg;
  TBroadcastSysMsg =  packed record
    uiMessage: UINT;
    wParam: WPARAM;
    lParam: LPARAM;
  end;

  PDlgTemplate = ^TDlgTemplate;
  TDlgTemplate =  packed record
    style: DWORD;
    dwExtendedStyle: DWORD;
    cdit: Word;
    x: SHORT;
    y: SHORT;
    cx: SHORT;
    cy: SHORT;
  end;

  PDlgItemTemplate = ^TDlgItemTemplate;
  TDlgItemTemplate =  packed record
    style: DWORD;
    dwExtendedStyle: DWORD;
    x: SHORT;
    y: SHORT;
    cx: SHORT;
    cy: SHORT;
    id: Word;
  end;

  PKeyboardState = ^TKeyboardState;
  TKeyboardState = array[0..255] of Byte;

  PTPMParams = ^TTPMParams;
  TTPMParams =  packed record
    cbSize: UINT;
    rcExclude: TRect;
  end;

  PMenuItemInfoA = ^TMenuItemInfoA;
  PMenuItemInfoW = ^TMenuItemInfoW;
  PMenuItemInfo = PMenuItemInfoA;
  TMenuItemInfoA = packed record
    cbSize: UINT;
    fMask: UINT;
    fType: UINT;
    fState: UINT;
    wID: UINT;
    hSubMenu: HMENU;
    hbmpChecked: HBITMAP;
    hbmpUnchecked: HBITMAP;
    dwItemData: DWORD;
    dwTypeData: PAnsiChar;
    cch: UINT;
  end;
  TMenuItemInfoW =  packed record
    cbSize: UINT;
    fMask: UINT;
    fType: UINT;
    fState: UINT;
    wID: UINT;
    hSubMenu: HMENU;
    hbmpChecked: HBITMAP;
    hbmpUnchecked: HBITMAP;
    dwItemData: DWORD;
    dwTypeData: PWideChar;
    cch: UINT;
  end;
  TMenuItemInfo = TMenuItemInfoA;

  PDropStruct = ^TDropStruct;
  TDropStruct =  packed record
    hwndSource: HWND;
    hwndSink: HWND;
    wFmt: DWORD;
    dwData: DWORD;
    ptDrop: TPoint;
    dwControlData: DWORD;
  end;

  PDrawTextParams = ^TDrawTextParams;
  TDrawTextParams =  packed record
    cbSize: UINT;
    iTabLength: DWORD;
    iLeftMargin: DWORD;
    iRightMargin: DWORD;
    uiLengthDrawn: UINT;
  end;

  PHelpInfo = ^THelpInfo;
  THelpInfo =  packed record
    cbSize: UINT;
    iContextType: DWORD;
    iCtrlId: DWORD;
    hItemHandle: THandle;
    dwContextId: DWORD;
    MousePos: TPoint;
  end;

  TPRMsgBoxCallback = procedure(var lpHelpInfo: THelpInfo);

  PMsgBoxParamsA = ^TMsgBoxParamsA;
  PMsgBoxParamsW = ^TMsgBoxParamsW;
  PMsgBoxParams = PMsgBoxParamsA;
  TMsgBoxParamsA =  packed record
    cbSize: UINT;
    hwndOwner: HWND;
    hInstance: HINST;
    lpszText: PAnsiChar;
    lpszCaption: PAnsiChar;
    dwStyle: DWORD;
    lpszIcon: PAnsiChar;
    dwContextHelpId: DWORD;
    lpfnMsgBoxCallback: TPRMsgBoxCallback;
    dwLanguageId: DWORD;
  end;
  TMsgBoxParamsW =  packed record
    cbSize: UINT;
    hwndOwner: HWND;
    hInstance: HINST;
    lpszText: PWideChar;
    lpszCaption: PWideChar;
    dwStyle: DWORD;
    lpszIcon: PWideChar;
    dwContextHelpId: DWORD;
    lpfnMsgBoxCallback: TPRMsgBoxCallback;
    dwLanguageId: DWORD;
  end;
  TMsgBoxParams = TMsgBoxParamsA;

  PMenuItemTemplateHeader = ^TMenuItemTemplateHeader;
  TMenuItemTemplateHeader =  packed record
    versionNumber: Word;
    offset: Word;
  end;

  PMenuItemTemplate = ^TMenuItemTemplate;
  TMenuItemTemplate =  packed record
    mtOption: Word;
    mtID: Word;
    mtString: array[0..0] of WCHAR;
  end;

  PIconInfo = ^TIconInfo;
  TIconInfo =  packed record
    fIcon: LONGBOOL;
    xHotspot: DWORD;
    yHotspot: DWORD;
    hbmMask: HBITMAP;
    hbmColor: HBITMAP;
  end;

  PCursorShape = ^TCursorShape;
  TCursorShape = record
    xHotSpot: DWORD;
    yHotSpot: DWORD;
    cx: DWORD;
    cy: DWORD;
    cbWidth: DWORD;
    Planes: Byte;
    BitsPixel: Byte;
  end;

  TScrollInfo =  packed record
    cbSize: UINT;
    fMask: UINT;
    nMin: DWORD;
    nMax: DWORD;
    nPage: UINT;
    nPos: DWORD;
    nTrackPos: DWORD;
  end;

  PMDICreateStructA = ^TMDICreateStructA;
  PMDICreateStructW = ^TMDICreateStructW;
  PMDICreateStruct = PMDICreateStructA;
  TMDICreateStructA = packed record
    szClass: PAnsiChar;
    szTitle: PAnsiChar;
    hOwner: THandle;
    x: DWORD;
    y: DWORD;
    cx: DWORD;
    cy: DWORD;
    style: DWORD;
    lParam: LPARAM;
  end;
  TMDICreateStructW =  packed record
    szClass: PWideChar;
    szTitle: PWideChar;
    hOwner: THandle;
    x: DWORD;
    y: DWORD;
    cx: DWORD;
    cy: DWORD;
    style: DWORD;
    lParam: LPARAM;
  end;
  TMDICreateStruct = TMDICreateStructA;

  PClientCreateStruct = ^TClientCreateStruct;
  TClientCreateStruct =  packed record
    hWindowMenu: THandle;
    idFirstChild: UINT;
  end;

  HELPPOLY = DWORD;
  PMultiKeyHelpA = ^TMultiKeyHelpA;
  PMultiKeyHelpW = ^TMultiKeyHelpW;
  PMultiKeyHelp = PMultiKeyHelpA;
  TMultiKeyHelpA = record
    mkSize: DWORD;
    mkKeylist: AnsiChar;
    szKeyphrase: array[0..0] of AnsiChar;
  end;
  TMultiKeyHelpW = record
    mkSize: DWORD;
    mkKeylist: WideChar;
    szKeyphrase: array[0..0] of WideChar;
  end;
  TMultiKeyHelp = TMultiKeyHelpA;

  PHelpWinInfoA = ^THelpWinInfoA;
  PHelpWinInfoW = ^THelpWinInfoW;
  PHelpWinInfo = PHelpWinInfoA;
  THelpWinInfoA = record
    wStructSize: DWORD;
    x: DWORD;
    y: DWORD;
    dx: DWORD;
    dy: DWORD;
    wMax: DWORD;
    rgchMember: array[0..1] of AnsiChar;
  end;
  THelpWinInfoW = record
    wStructSize: DWORD;
    x: DWORD;
    y: DWORD;
    dx: DWORD;
    dy: DWORD;
    wMax: DWORD;
    rgchMember: array[0..1] of WideChar;
  end;
  THelpWinInfo = THelpWinInfoA;

  PNonClientMetricsA = ^TNonClientMetricsA;
  PNonClientMetricsW = ^TNonClientMetricsW;
  PNonClientMetrics = PNonClientMetricsA;
  TNonClientMetricsA = packed record
    cbSize: UINT;
    iBorderWidth: DWORD;
    iScrollWidth: DWORD;
    iScrollHeight: DWORD;
    iCaptionWidth: DWORD;
    iCaptionHeight: DWORD;
    lfCaptionFont: TLogFontA;
    iSmCaptionWidth: DWORD;
    iSmCaptionHeight: DWORD;
    lfSmCaptionFont: TLogFontA;
    iMenuWidth: DWORD;
    iMenuHeight: DWORD;
    lfMenuFont: TLogFontA;
    lfStatusFont: TLogFontA;
    lfMessageFont: TLogFontA;
  end;
  TNonClientMetricsW = packed record
    cbSize: UINT;
    iBorderWidth: DWORD;
    iScrollWidth: DWORD;
    iScrollHeight: DWORD;
    iCaptionWidth: DWORD;
    iCaptionHeight: DWORD;
    lfCaptionFont: TLogFontW;
    iSmCaptionWidth: DWORD;
    iSmCaptionHeight: DWORD;
    lfSmCaptionFont: TLogFontW;
    iMenuWidth: DWORD;
    iMenuHeight: DWORD;
    lfMenuFont: TLogFontW;
    lfStatusFont: TLogFontW;
    lfMessageFont: TLogFontW;
  end;
  TNonClientMetrics = TNonClientMetricsA;

  PMinimizedMetrics = ^TMinimizedMetrics;
  TMinimizedMetrics = packed record
    cbSize: UINT;
    iWidth: DWORD;
    iHorzGap: DWORD;
    iVertGap: DWORD;
    iArrange: DWORD;
  end;

  PIconMetricsA = ^TIconMetricsA;
  PIconMetricsW = ^TIconMetricsW;
  PIconMetrics = PIconMetricsA;
  TIconMetricsA =  packed record
    cbSize: UINT;
    iHorzSpacing: DWORD;
    iVertSpacing: DWORD;
    iTitleWrap: DWORD;
    lfFont: TLogFontA;
  end;
  TIconMetricsW =  packed record
    cbSize: UINT;
    iHorzSpacing: DWORD;
    iVertSpacing: DWORD;
    iTitleWrap: DWORD;
    lfFont: TLogFontW;
  end;
  TIconMetrics = TIconMetricsA;

  PAnimationInfo = ^TAnimationInfo;
  TAnimationInfo =  packed record
    cbSize: UINT;
    iMinAnimate: DWORD;
  end;

  PSerialKeysA = ^TSerialKeysA;
  PSerialKeysW = ^TSerialKeysW;
  PSerialKeys = PSerialKeysA;
  TSerialKeysA = packed record
    cbSize: UINT;
    dwFlags: DWORD;
    lpszActivePort: PAnsiChar;
    lpszPort: PAnsiChar;
    iBaudRate: UINT;
    iPortState: UINT;
    iActive: UINT;
  end;
  TSerialKeysW =  packed record
    cbSize: UINT;
    dwFlags: DWORD;
    lpszActivePort: PWideChar;
    lpszPort: PWideChar;
    iBaudRate: UINT;
    iPortState: UINT;
    iActive: UINT;
  end;
  TSerialKeys = TSerialKeysA;

  PHighContrastA = ^THighContrastA;
  PHighContrastW = ^THighContrastW;
  PHighContrast = PHighContrastA;
  THighContrastA = packed record
    cbSize: UINT;
    dwFlags: DWORD;
    lpszDefaultScheme: PAnsiChar;
  end;
  THighContrastW =  packed record
    cbSize: UINT;
    dwFlags: DWORD;
    lpszDefaultScheme: PWideChar;
  end;
  THighContrast = THighContrastA;

  PFilterKeys = ^TFilterKeys;
  TFilterKeys = packed record
    cbSize: UINT;
    dwFlags: DWORD;
    iWaitMSec: DWORD;
    iDelayMSec: DWORD;
    iRepeatMSec: DWORD;
    iBounceMSec: DWORD;
  end;

  PStickyKeys = ^TStickyKeys;
  TStickyKeys = packed record
    cbSize: UINT;
    dwFlags: DWORD;
  end;

  PMouseKeys = ^TMouseKeys;
  TMouseKeys = packed record
    cbSize: UINT;
    dwFlags: DWORD;
    iMaxSpeed: DWORD;
    iTimeToMaxSpeed: DWORD;
    iCtrlSpeed: DWORD;
    dwReserved1: DWORD;
    dwReserved2: DWORD;
  end;

  PAccessTimeout = ^TAccessTimeout;
  TAccessTimeout = packed record
    cbSize: UINT;
    dwFlags: DWORD;
    iTimeOutMSec: DWORD;
  end;

  PSoundsEntryA = ^TSoundsEntryA;
  PSoundsEntryW = ^TSoundsEntryW;
  PSoundsEntry = PSoundsEntryA;
  TSoundsEntryA = packed record
    cbSize: UINT;
    dwFlags: DWORD;
    iFSTextEffect: DWORD;
    iFSTextEffectMSec: DWORD;
    iFSTextEffectColorBits: DWORD;
    iFSGrafEffect: DWORD;
    iFSGrafEffectMSec: DWORD;
    iFSGrafEffectColor: DWORD;
    iWindowsEffect: DWORD;
    iWindowsEffectMSec: DWORD;
    lpszWindowsEffectDLL: PAnsiChar;
    iWindowsEffectOrdinal: DWORD;
  end;
  TSoundsEntryW =  packed record
    cbSize: UINT;
    dwFlags: DWORD;
    iFSTextEffect: DWORD;
    iFSTextEffectMSec: DWORD;
    iFSTextEffectColorBits: DWORD;
    iFSGrafEffect: DWORD;
    iFSGrafEffectMSec: DWORD;
    iFSGrafEffectColor: DWORD;
    iWindowsEffect: DWORD;
    iWindowsEffectMSec: DWORD;
    lpszWindowsEffectDLL: PWideChar;
    iWindowsEffectOrdinal: DWORD;
  end;
  TSoundsEntry = TSoundsEntryA;

  PToggleKeys = ^TToggleKeys;
  TToggleKeys = packed record
    cbSize: UINT;
    dwFlags: DWORD;
  end;

  LCTYPE = DWORD;
  CALTYPE = DWORD;
  CALID = DWORD;

  PCPInfo = ^TCPInfo;
  TCPInfo = record
    MaxCharSize: UINT;
    DefaultChar: array[0..MAX_DEFAULTCHAR - 1] of Byte;
    LeadByte: array[0..MAX_LEADBYTES - 1] of Byte;
  end;

  PNumberFmtA = ^TNumberFmtA;
  PNumberFmtW = ^TNumberFmtW;
  PNumberFmt = PNumberFmtA;
  TNumberFmtA =  packed record
    NumDigits: UINT;
    LeadingZero: UINT;
    Grouping: UINT;
    lpDecimalSep: PAnsiChar;
    lpThousandSep: PAnsiChar;
    NegativeOrder: UINT;
  end;
  TNumberFmtW =  packed record
    NumDigits: UINT;
    LeadingZero: UINT;
    Grouping: UINT;
    lpDecimalSep: PWideChar;
    lpThousandSep: PWideChar;
    NegativeOrder: UINT;
  end;
  TNumberFmt = TNumberFmtA;

  PCurrencyFmtA = ^TCurrencyFmtA;
  PCurrencyFmtW = ^TCurrencyFmtW;
  PCurrencyFmt = PCurrencyFmtA;
  TCurrencyFmtA =  packed record
    NumDigits: UINT;
    LeadingZero: UINT;
    Grouping: UINT;
    lpDecimalSep: PAnsiChar;
    lpThousandSep: PAnsiChar;
    NegativeOrder: UINT;
    PositiveOrder: UINT;
    lpCurrencySymbol: PAnsiChar;
  end;
  TCurrencyFmtW =  packed record
    NumDigits: UINT;
    LeadingZero: UINT;
    Grouping: UINT;
    lpDecimalSep: PWideChar;
    lpThousandSep: PWideChar;
    NegativeOrder: UINT;
    PositiveOrder: UINT;
    lpCurrencySymbol: PWideChar;
  end;
  TCurrencyFmt = TCurrencyFmtA;

  TFNLocaleEnumProc = TFarProc;
  TFNCodepageEnumProc = TFarProc;
  TFNDateFmtEnumProc = TFarProc;
  TFNTimeFmtEnumProc = TFarProc;
  TFNCalInfoEnumProc = TFarProc;

 PCoord = ^TCoord;
  TCoord =  packed record
    X: SHORT;
    Y: SHORT;
  end;

  PSmallRect = ^TSmallRect;
  TSmallRect =  packed record
    Left: SHORT;
    Top: SHORT;
    Right: SHORT;
    Bottom: SHORT;
  end;

  PKeyEventRecord = ^TKeyEventRecord;
  TKeyEventRecord = packed record
    bKeyDown: LONGBOOL;
    wRepeatCount: Word;
    wVirtualKeyCode: Word;
    wVirtualScanCode: Word;
    case DWORD of
      0: (UnicodeChar: WCHAR; dwControlKeyState: DWORD);
      1: (AsciiChar: CHAR);
  end;

  PMouseEventRecord = ^TMouseEventRecord;
  TMouseEventRecord = packed record
    dwMousePosition: TCoord;
    dwButtonState: DWORD;
    dwControlKeyState: DWORD;
    dwEventFlags: DWORD;
  end;

  PWindowBufferSizeRecord = ^TWindowBufferSizeRecord;
  TWindowBufferSizeRecord = packed record
    dwSize: TCoord;
  end;

  PMenuEventRecord = ^TMenuEventRecord;
  TMenuEventRecord = packed record
    dwCommandId: UINT;
  end;

  PFocusEventRecord = ^TFocusEventRecord;
  TFocusEventRecord =  packed record
    bSetFocus: LONGBOOL;
  end;

  PInputRecord = ^TInputRecord;
  TInputRecord = record
    EventType: Word;
    case DWord of
      0: (KeyEvent: TKeyEventRecord);
      1: (MouseEvent: TMouseEventRecord);
      2: (WindowBufferSizeEvent: TWindowBufferSizeRecord);
      3: (MenuEvent: TMenuEventRecord);
      4: (FocusEvent: TFocusEventRecord);
  end;

  PCharInfo = ^TCharInfo;
  TCharInfo =  packed record
    case DWORD of
      0: (UnicodeChar: WCHAR; Attributes: Word);
      1: (AsciiChar: CHAR);
  end;

  PConsoleScreenBufferInfo = ^TConsoleScreenBufferInfo;
  TConsoleScreenBufferInfo = packed record
    dwSize: TCoord;
    dwCursorPosition: TCoord;
    wAttributes: Word;
    srWindow: TSmallRect;
    dwMaximumWindowSize: TCoord;
  end;

  PConsoleCursorInfo = ^TConsoleCursorInfo;
  TConsoleCursorInfo =  packed record
    dwSize: DWORD;
    bVisible: LONGBOOL;
  end;

  TFNHandlerRoutine = TFarProc;

  PVSFixedFileInfo = ^TVSFixedFileInfo;
  TVSFixedFileInfo =  packed record
    dwSignature: DWORD;
    dwStrucVersion: DWORD;
    dwFileVersionMS: DWORD;
    dwFileVersionLS: DWORD;
    dwProductVersionMS: DWORD;
    dwProductVersionLS: DWORD;
    dwFileFlagsMask: DWORD;
    dwFileFlags: DWORD;
    dwFileOS: DWORD;
    dwFileType: DWORD;
    dwFileSubtype: DWORD;
    dwFileDateMS: DWORD;
    dwFileDateLS: DWORD;
  end;

  REGSAM = ACCESS_MASK;

  HKEY = DWORD;
  PHKEY = ^HKEY;

  PValContext = ^TValContext;
  TValContext =  packed record
    valuelen: DWORD;
    value_context: Pointer;
    val_buff_ptr: Pointer;
  end;

  PPValueA = ^TPValueA;
  PPValueW = ^TPValueW;
  PPValue = PPValueA;
  TPValueA = packed record
    pv_valuename: PAnsiChar;
    pv_valuelen: LONGBOOL;
    pv_value_context: Pointer;
    pv_type: DWORD;
  end;
  TPValueW =  packed record
    pv_valuename: PWideChar;
    pv_valuelen: LONGBOOL;
    pv_value_context: Pointer;
    pv_type: DWORD;
  end;
  TPValue = TPValueA;

  TFNQueryHandler = TFarProc;
  PFNQueryHandler = ^TFNQueryHandler;

  PProviderInfo = ^TProviderInfo;
  TProviderInfo = packed record
    pi_R0_1val: PFNQueryHandler;
    pi_R0_allvals: PFNQueryHandler;
    pi_R3_1val: PFNQueryHandler;
    pi_R3_allvals: PFNQueryHandler;
    pi_flags: DWORD;
    pi_key_context: Pointer;
  end;
  TRegProvider = TProviderInfo;
  PProvider = PProviderInfo;

  PValueEntA = ^TValueEntA;
  PValueEntW = ^TValueEntW;
  PValueEnt = PValueEntA;
  TValueEntA = packed record
    ve_valuename: PAnsiChar;
    ve_valuelen: DWORD;
    ve_valueptr: DWORD;
    ve_type: DWORD;
  end;
  TValueEntW =  packed record
    ve_valuename: PWideChar;
    ve_valuelen: DWORD;
    ve_valueptr: DWORD;
    ve_type: DWORD;
  end;
  TValueEnt = TValueEntA;
  TValEnt = TValueEnt;
  PValEnt = PValueEnt;

  PNetResourceA = ^TNetResourceA;
  PNetResourceW = ^TNetResourceW;
  PNetResource = PNetResourceA;
  TNetResourceA = packed record
    dwScope: DWORD;
    dwType: DWORD;
    dwDisplayType: DWORD;
    dwUsage: DWORD;
    lpLocalName: PAnsiChar;
    lpRemoteName: PAnsiChar;
    lpComment: PAnsiChar;
    lpProvider: PAnsiChar;
  end;
  TNetResourceW =  packed record
    dwScope: DWORD;
    dwType: DWORD;
    dwDisplayType: DWORD;
    dwUsage: DWORD;
    lpLocalName: PWideChar;
    lpRemoteName: PWideChar;
    lpComment: PWideChar;
    lpProvider: PWideChar;
  end;
  TNetResource = TNetResourceA;

  PConnectDlgStruct = ^TConnectDlgStruct;
  TConnectDlgStruct = packed record
    cbStructure: DWORD;
    hwndOwner: HWND;
    lpConnRes: PNetResource;
    dwFlags: DWORD;
    dwDevNum: DWORD;
  end;

  PDiscDlgStructA = ^TDiscDlgStructA;
  PDiscDlgStructW = ^TDiscDlgStructW;
  PDiscDlgStruct = PDiscDlgStructA;
  TDiscDlgStructA = packed record
    cbStructure: DWORD;
    hwndOwner: HWND;
    lpLocalName: PAnsiChar;
    lpRemoteName: PAnsiChar;
    dwFlags: DWORD;
  end;
  TDiscDlgStructW = packed record
    cbStructure: DWORD;
    hwndOwner: HWND;
    lpLocalName: PWideChar;
    lpRemoteName: PWideChar;
    dwFlags: DWORD;
  end;
  TDiscDlgStruct = TDiscDlgStructA;

  PUniversalNameInfoA = ^TUniversalNameInfoA;
  PUniversalNameInfoW = ^TUniversalNameInfoW;
  PUniversalNameInfo = PUniversalNameInfoA;
  TUniversalNameInfoA = packed record
    lpUniversalName: PAnsiChar;
  end;
  TUniversalNameInfoW = packed record
    lpUniversalName: PWideChar;
  end;
  TUniversalNameInfo = TUniversalNameInfoA;

  PRemoteNameInfoA = ^TRemoteNameInfoA;
  PRemoteNameInfoW = ^TRemoteNameInfoW;
  PRemoteNameInfo = PRemoteNameInfoA;
  TRemoteNameInfoA = packed record
    lpUniversalName: PAnsiChar;
    lpConnectionName: PAnsiChar;
    lpRemainingPath: PAnsiChar;
  end;
  TRemoteNameInfoW =  packed record
    lpUniversalName: PWideChar;
    lpConnectionName: PWideChar;
    lpRemainingPath: PWideChar;
  end;
  TRemoteNameInfo = TRemoteNameInfoA;

  PNetInfoStruct = ^TNetInfoStruct;
  TNetInfoStruct = record
    cbStructure: DWORD;
    dwProviderVersion: DWORD;
    dwStatus: DWORD;
    dwCharacteristics: DWORD;
    dwHandle: DWORD;
    wNetType: Word;
    dwPrinters: DWORD;
    dwDrives: DWORD;
  end;

  TFNGetProfilePath = TFarProc;
  TFNReconcileProfile = TFarProc;
  TFNProcessPolicies = TFarProc;

  PNetConnectInfoStruct = ^TNetConnectInfoStruct;
  TNetConnectInfoStruct = packed record
    cbStructure: DWORD;
    dwFlags: DWORD;
    dwSpeed: DWORD;
    dwDelay: DWORD;
    dwOptDataSize: DWORD;
  end;

  PDDEAck = ^TDDEAck;
  TDDEAck =  packed record
    Flags: Word;
  end;

  PDDEAdvise = ^TDDEAdvise;
  TDDEAdvise =  packed record
    Flags: Word;
    cfFormat: SmallInt;
  end;

  PDDEData = ^TDDEData;
  TDDEData = packed record
    Flags: Word;
    cfFormat: SmallInt;
    Value: array[0..0] of Byte;
  end;

  PDDEPoke = ^TDDEPoke;
  TDDEPoke = packed record
    Flags: Word;
    cfFormat: SmallInt;
    Value: array[0..0] of Byte;
  end;

//////////////////////// KERNEL32.DLL IMPORT SECTION //////////////////////////

function IsDebuggerPresent: BOOL;
external kernel32dll name 'IsDebuggerPresent';

function AddAtomA conv arg_stdcall (lpString: PAnsiChar): ATOM;
external kernel32dll name 'AddAtomA';

function AddAtomW conv arg_stdcall (lpString: PWideChar): ATOM;
external kernel32dll name 'AddAtomW';

function AddAtom conv arg_stdcall (lpString: PChar): ATOM;
 external kernel32dll name 'AddAtomA';

function AllocConsole: BOOL;
 external kernel32dll name 'AllocConsole';

function AreFileApisANSI: BOOL;
 external kernel32dll name 'AreFileApisANSI';

function BackupRead conv arg_stdcall (hFile: THandle; lpBuffer: PByte; nNumberOfBytesToRead: DWORD;
 var lpNumberOfBytesRead: DWORD; bAbort: BOOL; bProcessSecurity: BOOL; var lpContext: Pointer): BOOL;
 external kernel32dll name 'BackupRead';

function BackupSeek conv arg_stdcall (hFile: THandle; dwLowBytesToSeek, dwHighBytesToSeek: DWORD;
 var lpdwLowByteSeeked, lpdwHighByteSeeked: DWORD; lpContext: Pointer): BOOL;
 external kernel32dll name 'BackupSeek';

function BackupWrite conv arg_stdcall (hFile: THandle; lpBuffer: PByte; nNumberOfBytesToWrite: DWORD;
 var lpNumberOfBytesWritten: DWORD; bAbort, bProcessSecurity: BOOL; var lpContext: Pointer): BOOL;
 external kernel32dll name 'BackupWrite';

function Beep conv arg_stdcall (dwFreq, dwDuration: DWORD): BOOL;
 external kernel32dll name 'Beep';

function BeginUpdateResourceA conv arg_stdcall (pFileName: PAnsiChar; bDeleteExistingResources: BOOL): THandle;
external kernel32dll name 'BeginUpdateResourceA';

function BeginUpdateResourceW conv arg_stdcall (pFileName: PWideChar; bDeleteExistingResources: BOOL): THandle;
external kernel32dll name 'BeginUpdateResourceW';

function BeginUpdateResource conv arg_stdcall (pFileName: PChar; bDeleteExistingResources: BOOL): THandle;
 external kernel32dll name 'BeginUpdateResourceA';

function BuildCommDCBA conv arg_stdcall (lpDef: PAnsiChar; var lpDCB: TDCB): BOOL;
external kernel32dll name 'BuildCommDCBA';

function BuildCommDCBW conv arg_stdcall (lpDef: PWideChar; var lpDCB: TDCB): BOOL;
external kernel32dll name 'BuildCommDCBW';

function BuildCommDCB conv arg_stdcall (lpDef: PChar; var lpDCB: TDCB): BOOL;
 external kernel32dll name 'BuildCommDCBA';

function BuildCommDCBAndTimeoutsA conv arg_stdcall (lpDef: PAnsiChar; var lpDCB: TDCB;
var lpCommTimeouts: TCommTimeouts): BOOL;
external kernel32dll name 'BuildCommDCBAndTimeoutsA';

function BuildCommDCBAndTimeoutsW conv arg_stdcall (lpDef: PWideChar; var lpDCB: TDCB;
var lpCommTimeouts: TCommTimeouts): BOOL;
external kernel32dll name 'BuildCommDCBAndTimeoutsW';

function BuildCommDCBAndTimeouts conv arg_stdcall (lpDef: PChar; var lpDCB: TDCB;
 var lpCommTimeouts: TCommTimeouts): BOOL;
 external kernel32dll name 'BuildCommDCBAndTimeoutsA';

function CallNamedPipeA conv arg_stdcall (lpNamedPipeName: PAnsiChar; lpInBuffer: Pointer;
nInBufferSize: DWORD; lpOutBuffer: Pointer; nOutBufferSize: DWORD;
var lpBytesRead: DWORD; nTimeOut: DWORD): BOOL;
external kernel32dll name 'CallNamedPipeA';

function CallNamedPipeW conv arg_stdcall (lpNamedPipeName: PWideChar; lpInBuffer: Pointer;
nInBufferSize: DWORD; lpOutBuffer: Pointer; nOutBufferSize: DWORD;
var lpBytesRead: DWORD; nTimeOut: DWORD): BOOL;
external kernel32dll name 'CallNamedPipeW';

function CallNamedPipe conv arg_stdcall (lpNamedPipeName: PChar; lpInBuffer: Pointer;
 nInBufferSize: DWORD; lpOutBuffer: Pointer; nOutBufferSize: DWORD;
 var lpBytesRead: DWORD; nTimeOut: DWORD): BOOL;
 external kernel32dll name 'CallNamedPipeA';

function CancelIo conv arg_stdcall (hFile: THandle): BOOL;
 external kernel32dll name 'CancelIo';

function CancelWaitableTimer conv arg_stdcall (hTimer: THandle): BOOL;
 external kernel32dll name 'CancelWaitableTimer';

function ClearCommBreak conv arg_stdcall (hFile: THandle): BOOL;
 external kernel32dll name 'ClearCommBreak';

function ClearCommError conv arg_stdcall (hFile: THandle; var lpErrors: DWORD;
 lpStat: PComStat): BOOL;
 external kernel32dll name 'ClearCommError';

function CloseHandle conv arg_stdcall (hObject: THandle): BOOL;
 external kernel32dll name 'CloseHandle';

function CommConfigDialogA conv arg_stdcall (lpszName: PAnsiChar; hWnd: HWND; var lpCC: TCommConfig): BOOL;
external kernel32dll name 'CommConfigDialogA';

function CommConfigDialogW conv arg_stdcall (lpszName: PWideChar; hWnd: HWND; var lpCC: TCommConfig): BOOL;
external kernel32dll name 'CommConfigDialogW';

function CommConfigDialog conv arg_stdcall (lpszName: PChar; hWnd: HWND; var lpCC: TCommConfig): BOOL;
 external kernel32dll name 'CommConfigDialogA';

function CompareFileTime conv arg_stdcall (const lpFileTime1, lpFileTime2: TFileTime): Longint;
 external kernel32dll name 'CompareFileTime';

function CompareStringA conv arg_stdcall (Locale: LCID; dwCmpFlags: DWORD; lpString1: PAnsiChar;
cchCount1: DWORD; lpString2: PAnsiChar; cchCount2: DWORD): DWORD;
external kernel32dll name 'CompareStringA';

function CompareStringW conv arg_stdcall (Locale: LCID; dwCmpFlags: DWORD; lpString1: PWideChar;
cchCount1: DWORD; lpString2: PWideChar; cchCount2: DWORD): DWORD;
external kernel32dll name 'CompareStringW';

function CompareString conv arg_stdcall (Locale: LCID; dwCmpFlags: DWORD; lpString1: PChar;
 cchCount1: DWORD; lpString2: PChar; cchCount2: DWORD): DWORD;
 external kernel32dll name 'CompareStringA';

function ConnectNamedPipe conv arg_stdcall (hNamedPipe: THandle; lpOverlapped: POverlapped): BOOL;
 external kernel32dll name 'ConnectNamedPipe';

function ContinueDebugEvent conv arg_stdcall (dwProcessId, dwThreadId, dwContinueStatus: DWORD): BOOL;
 external kernel32dll name 'ContinueDebugEvent';

function ConvertThreadToFiber conv arg_stdcall (lpParameter: Pointer): BOOL;
 external kernel32dll name 'ConvertThreadToFiber';

function ConvertDefaultLocale conv arg_stdcall (Locale: LCID): LCID;
 external kernel32dll name 'ConvertDefaultLocale';

function CopyFileA conv arg_stdcall (lpExistingFileName, lpNewFileName: PAnsiChar;
bFailIfExists: BOOL): BOOL;
external kernel32dll name 'CopyFileA';

function CopyFileW conv arg_stdcall (lpExistingFileName, lpNewFileName: PWideChar;
bFailIfExists: BOOL): BOOL;
external kernel32dll name 'CopyFileW';

function CopyFile conv arg_stdcall (lpExistingFileName, lpNewFileName: PChar; bFailIfExists: BOOL): BOOL;
 external kernel32dll name 'CopyFileA';

function CopyFileExA conv arg_stdcall (lpExistingFileName, lpNewFileName: PAnsiChar;
bFailIfExists: BOOL): BOOL;
external kernel32dll name 'CopyFileExA';

function CopyFileExW conv arg_stdcall (lpExistingFileName, lpNewFileName: PWideChar;
lpProgressRoutine: TFNProgressRoutine; lpData: Pointer; pbCancel: PBool;
dwCopyFlags: DWORD): BOOL;
external kernel32dll name 'CopyFileExW';


function CopyFileEx conv arg_stdcall (lpExistingFileName, lpNewFileName: PChar;
 lpProgressRoutine: TFNProgressRoutine; lpData: Pointer; pbCancel: PBool;
 dwCopyFlags: DWORD): BOOL;
 external kernel32dll name 'CopyFileExA';

function CreateConsoleScreenBuffer conv arg_stdcall (dwDesiredAccess, dwShareMode: DWORD;
 lpSecurityAttributes: PSecurityAttributes; dwFlags: DWORD;
 lpScreenBufferData: Pointer): THandle;
 external kernel32dll name 'CreateConsoleScreenBuffer';

function CreateDirectoryA conv arg_stdcall (lpPathName: PAnsiChar;
lpSecurityAttributes: PSecurityAttributes): BOOL;
external kernel32dll name 'CreateDirectoryA';

function CreateDirectoryW conv arg_stdcall (lpPathName: PWideChar;
lpSecurityAttributes: PSecurityAttributes): BOOL;
external kernel32dll name 'CreateDirectoryW';

function CreateDirectory conv arg_stdcall (lpPathName: PChar; lpSecurityAttributes: PSecurityAttributes): BOOL;
 external kernel32dll name 'CreateDirectoryA';

function CreateDirectoryExA conv arg_stdcall (lpTemplateDirectory, lpNewDirectory: PAnsiChar;
lpSecurityAttributes: PSecurityAttributes): BOOL;
external kernel32dll name 'CreateDirectoryExA';

function CreateDirectoryExW conv arg_stdcall (lpTemplateDirectory, lpNewDirectory: PWideChar;
lpSecurityAttributes: PSecurityAttributes): BOOL;
external kernel32dll name 'CreateDirectoryExW';

function CreateDirectoryEx conv arg_stdcall (lpTemplateDirectory, lpNewDirectory: PChar;
 lpSecurityAttributes: PSecurityAttributes): BOOL;
 external kernel32dll name 'CreateDirectoryExA';

function CreateEventA conv arg_stdcall (lpEventAttributes: PSecurityAttributes;
bManualReset, bInitialState: BOOL; lpName: PAnsiChar): THandle;
external kernel32dll name 'CreateEventA';

function CreateEventW conv arg_stdcall (lpEventAttributes: PSecurityAttributes;
bManualReset, bInitialState: BOOL; lpName: PWideChar): THandle;
external kernel32dll name 'CreateEventW';

function CreateEvent conv arg_stdcall (lpEventAttributes: PSecurityAttributes;
 bManualReset, bInitialState: BOOL; lpName: PChar): THandle;
 external kernel32dll name 'CreateEventA';

function CreateFiber conv arg_stdcall (dwStackSize: DWORD; lpStartAddress: TFNFiberStartRoutine;
 lpParameter: Pointer): BOOL;
 external kernel32dll name 'CreateFiber';

function CreateFileA conv arg_stdcall (lpFileName: PAnsiChar; dwDesiredAccess,
dwShareMode: DWORD; lpSecurityAttributes: PSecurityAttributes;
dwCreationDisposition, dwFlagsAndAttributes: DWORD; hTemplateFile: THandle):
THandle;
external kernel32dll name 'CreateFileA';

function CreateFileWCreateFileW conv arg_stdcall (lpFileName: PWideChar; dwDesiredAccess,
dwShareMode: DWORD; lpSecurityAttributes: PSecurityAttributes;
dwCreationDisposition, dwFlagsAndAttributes: DWORD; hTemplateFile: THandle): THandle;
external kernel32dll name 'CreateFileW';

function CreateFile conv arg_stdcall (lpFileName: PChar; dwDesiredAccess, dwShareMode: DWORD;
 lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition,
 dwFlagsAndAttributes: DWORD; hTemplateFile: THandle): THandle;
 external kernel32dll name 'CreateFileA';

function CreateFileMappingA conv arg_stdcall (hFile: THandle; lpFileMappingAttributes:
PSecurityAttributes; flProtect, dwMaximumSizeHigh, dwMaximumSizeLow: DWORD;
lpName: PAnsiChar): THandle;
external kernel32dll name 'CreateFileMappingA';

function CreateFileMappingW conv arg_stdcall (hFile: THandle; lpFileMappingAttributes:
PSecurityAttributes; flProtect, dwMaximumSizeHigh, dwMaximumSizeLow: DWORD;
lpName: PWideChar): THandle;
external kernel32dll name 'CreateFileMappingW';

function CreateFileMapping conv arg_stdcall (hFile: THandle; lpFileMappingAttributes:
 PSecurityAttributes; flProtect, dwMaximumSizeHigh, dwMaximumSizeLow: DWORD;
 lpName: PChar): THandle;
 external kernel32dll name 'CreateFileMappingA';

function CreateIoCompletionPort conv arg_stdcall (FileHandle, ExistingCompletionPort:
 THandle; CompletionKey, NumberOfConcurrentThreads: DWORD): THandle;
 external kernel32dll name 'CreateIoCompletionPort';

function CreateMailslotA conv arg_stdcall (lpName: PAnsiChar; nMaxMessageSize: DWORD;
lReadTimeout: DWORD; lpSecurityAttributes: PSecurityAttributes): THandle;
external kernel32dll name 'CreateMailslotA';

function CreateMailslotW conv arg_stdcall (lpName: PWideChar; nMaxMessageSize: DWORD;
lReadTimeout: DWORD; lpSecurityAttributes: PSecurityAttributes): THandle;
external kernel32dll name 'CreateMailslotW';

function CreateMailslot conv arg_stdcall (lpName: PChar; nMaxMessageSize: DWORD;
 lReadTimeout: DWORD; lpSecurityAttributes: PSecurityAttributes): THandle;
 external kernel32dll name 'CreateMailslotA';

function CreateMutexA conv arg_stdcall (lpMutexAttributes: PSecurityAttributes;
bInitialOwner: BOOL; lpName: PAnsiChar): THandle;
external kernel32dll name 'CreateMutexA';

function CreateMutexW conv arg_stdcall (lpMutexAttributes: PSecurityAttributes;
bInitialOwner: BOOL; lpName: PWideChar): THandle;
external kernel32dll name 'CreateMutexW';

function CreateMutex conv arg_stdcall (lpMutexAttributes: PSecurityAttributes;
 bInitialOwner: BOOL; lpName: PChar): THandle;
 external kernel32dll name 'CreateMutexA';

function CreateNamedPipeA conv arg_stdcall (lpName: PAnsiChar; dwOpenMode, dwPipeMode,
nMaxInstances, nOutBufferSize, nInBufferSize, nDefaultTimeOut: DWORD;
lpSecurityAttributes: PSecurityAttributes): THandle;
external kernel32dll name 'CreateNamedPipeA';

function CreateNamedPipeW conv arg_stdcall (lpName: PWideChar; dwOpenMode, dwPipeMode,
nMaxInstances, nOutBufferSize, nInBufferSize, nDefaultTimeOut: DWORD;
lpSecurityAttributes: PSecurityAttributes): THandle;
external kernel32dll name 'CreateNamedPipeW';

function CreateNamedPipe conv arg_stdcall (lpName: PChar; dwOpenMode, dwPipeMode,
 nMaxInstances, nOutBufferSize, nInBufferSize, nDefaultTimeOut: DWORD;
 lpSecurityAttributes: PSecurityAttributes): THandle;
 external kernel32dll name 'CreateNamedPipeA';

function CreatePipe conv arg_stdcall (var hReadPipe, hWritePipe: THandle;
 lpPipeAttributes: PSecurityAttributes; nSize: DWORD): BOOL;
 external kernel32dll name 'CreatePipe';

function CreateProcessA conv arg_stdcall (lpApplicationName: PAnsiChar; lpCommandLine:
PAnsiChar; lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer;
lpCurrentDirectory: PAnsiChar; const lpStartupInfo: TStartupInfo;
var lpProcessInformation: TProcessInformation): BOOL;
external kernel32dll name 'CreateProcessA';

function CreateProcessW conv arg_stdcall (lpApplicationName: PWideChar; lpCommandLine:
PWideChar;lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer;
lpCurrentDirectory: PWideChar; const lpStartupInfo: TStartupInfo;
var lpProcessInformation: TProcessInformation): BOOL;
external kernel32dll name 'CreateProcessW';

function CreateProcess conv arg_stdcall (lpApplicationName: PChar; lpCommandLine: PChar;
 lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
 bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer;
 lpCurrentDirectory: PChar; const lpStartupInfo: TStartupInfo;
 var lpProcessInformation: TProcessInformation): BOOL;
 external kernel32dll name 'CreateProcessA';

function CreateRemoteThread conv arg_stdcall (hProcess: THandle; lpThreadAttributes: Pointer;
 dwStackSize: DWORD; lpStartAddress: TFNThreadStartRoutine; lpParameter:
 Pointer; dwCreationFlags: DWORD; var lpThreadId: DWORD): THandle;
 external kernel32dll name 'CreateRemoteThread';

function CreateSemaphoreA conv arg_stdcall (lpSemaphoreAttributes: PSecurityAttributes;
lInitialCount, lMaximumCount: Longint; lpName: PAnsiChar): THandle;
external kernel32dll name 'CreateSemaphoreA';

function CreateSemaphoreW conv arg_stdcall (lpSemaphoreAttributes: PSecurityAttributes;
lInitialCount, lMaximumCount: Longint; lpName: PWideChar): THandle;
external kernel32dll name 'CreateSemaphoreW';

function CreateSemaphore conv arg_stdcall (lpSemaphoreAttributes: PSecurityAttributes;
 lInitialCount, lMaximumCount: Longint; lpName: PChar): THandle;
 external kernel32dll name 'CreateSemaphoreA';

function CreateTapePartition conv arg_stdcall (hDevice: THandle; dwPartitionMethod, dwCount,
 dwSize: DWORD): DWORD;
 external kernel32dll name 'CreateTapePartition';

function CreateThread conv arg_stdcall (lpThreadAttributes: Pointer; dwStackSize: DWORD;
 lpStartAddress: TFNThreadStartRoutine; lpParameter: Pointer;
 dwCreationFlags: DWORD; var lpThreadId: DWORD): THandle;
 external kernel32dll name 'CreateThread';

function CreateWaitableTimerA conv arg_stdcall (lpTimerAttributes: PSecurityAttributes;
bManualReset: BOOL; lpTimerName: PAnsiChar): BOOL;
external kernel32dll name 'CreateWaitableTimerA';

function CreateWaitableTimerW conv arg_stdcall (lpTimerAttributes: PSecurityAttributes;
bManualReset: BOOL; lpTimerName: PWideChar): BOOL;
external kernel32dll name 'CreateWaitableTimerW';

function CreateWaitableTimer conv arg_stdcall (lpTimerAttributes: PSecurityAttributes;
 bManualReset: BOOL; lpTimerName: PChar): BOOL;
 external kernel32dll name 'CreateWaitableTimerA';

function DebugActiveProcess conv arg_stdcall (dwProcessId: DWORD): BOOL;
 external kernel32dll name 'DebugActiveProcess';

procedure DebugBreak; external kernel32dll name 'DebugBreak';

function DefineDosDeviceA conv arg_stdcall (dwFlags: DWORD; lpDeviceName, lpTargetPath:
PAnsiChar): BOOL;
external kernel32dll name 'DefineDosDeviceA';

function DefineDosDeviceW conv arg_stdcall (dwFlags: DWORD; lpDeviceName, lpTargetPath:
PWideChar): BOOL;
external kernel32dll name 'DefineDosDeviceW';

function DefineDosDevice conv arg_stdcall (dwFlags: DWORD; lpDeviceName, lpTargetPath: PChar):
 BOOL;
 external kernel32dll name 'DefineDosDeviceA';

function DeleteAtom conv arg_stdcall (nAtom: ATOM): ATOM;
 external kernel32dll name 'DeleteAtom';

procedure DeleteCriticalSection conv arg_stdcall (var lpCriticalSection: TRTLCriticalSection);

 external kernel32dll name 'DeleteCriticalSection';

function DeleteFiber conv arg_stdcall (lpFiber: Pointer): BOOL;
 external kernel32dll name 'DeleteFiber';

function DeleteFileA conv arg_stdcall (lpFileName: PAnsiChar): BOOL;
 external kernel32dll name 'DeleteFileA';

function DeleteFileW conv arg_stdcall (lpFileName: PWideChar): BOOL;
 external kernel32dll name 'DeleteFileW';

function DeleteFile conv arg_stdcall (lpFileName: PChar): BOOL;
 external kernel32dll name 'DeleteFileA';

function DeviceIoControl conv arg_stdcall (hDevice: THandle; dwIoControlCode: DWORD;
 lpInBuffer: Pointer; nInBufferSize: DWORD; lpOutBuffer: Pointer;
 nOutBufferSize: DWORD; var lpBytesReturned: DWORD; lpOverlapped:
 POverlapped): BOOL;
 external kernel32dll name 'DeviceIoControl';

function DisableThreadLibraryCalls conv arg_stdcall (hLibModule: HMODULE): BOOL;
 external kernel32dll name 'DisableThreadLibraryCalls';

function DisconnectNamedPipe conv arg_stdcall (hNamedPipe: THandle): BOOL;
 external kernel32dll name 'DisconnectNamedPipe';

function DosDateTimeToFileTime conv arg_stdcall (wFatDate, wFatTime: Word;
 var lpFileTime: TFileTime): BOOL;
 external kernel32dll name 'DosDateTimeToFileTime';

function DuplicateHandle conv arg_stdcall (hSourceProcessHandle, hSourceHandle,
 hTargetProcessHandle: THandle; lpTargetHandle: PHandle;
 dwDesiredAccess: DWORD; bInheritHandle: BOOL; dwOptions: DWORD): BOOL;
  external kernel32dll name 'DuplicateHandle';

function EndUpdateResourceA conv arg_stdcall (hUpdate: THandle; fDiscard: BOOL): BOOL;
 external kernel32dll name 'EndUpdateResourceA';

function EndUpdateResourceW conv arg_stdcall (hUpdate: THandle; fDiscard: BOOL): BOOL;
 external kernel32dll name 'EndUpdateResourceW';

function EndUpdateResource conv arg_stdcall (hUpdate: THandle; fDiscard: BOOL): BOOL;
 external kernel32dll name 'EndUpdateResourceA';

procedure EnterCriticalSection conv arg_stdcall (var lpCriticalSection: TRTLCriticalSection);
 external kernel32dll name 'EnterCriticalSection';

function EnumCalendarInfoA conv arg_stdcall (lpCalInfoEnumProc: TFNCalInfoEnumProc; Locale: LCID;
 Calendar: CALID; CalType: CALTYPE): BOOL;
 external kernel32dll name 'EnumCalendarInfoA';

function EnumCalendarInfoW conv arg_stdcall (lpCalInfoEnumProc: TFNCalInfoEnumProc; Locale: LCID;
 Calendar: CALID; CalType: CALTYPE): BOOL;
 external kernel32dll name 'EnumCalendarInfoW';

function EnumCalendarInfo conv arg_stdcall (lpCalInfoEnumProc: TFNCalInfoEnumProc;
 Locale: LCID; Calendar: CALID; CalType: CALTYPE): BOOL;
 external kernel32dll name 'EnumCalendarInfoA';

function EnumDateFormatsA conv arg_stdcall (lpDateFmtEnumProc: TFNDateFmtEnumProc;
 Locale: LCID; dwFlags: DWORD): BOOL;
 external kernel32dll name 'EnumDateFormatsA';

function EnumDateFormatsW conv arg_stdcall (lpDateFmtEnumProc: TFNDateFmtEnumProc;
 Locale: LCID; dwFlags: DWORD): BOOL;
 external kernel32dll name 'EnumDateFormatsW';

function EnumDateFormats conv arg_stdcall (lpDateFmtEnumProc: TFNDateFmtEnumProc;
 Locale: LCID; dwFlags: DWORD): BOOL;
 external kernel32dll name 'EnumDateFormatsA';

function EnumResourceLanguagesA conv arg_stdcall (hModule: HMODULE; lpType, lpName: PAnsiChar;
lpEnumFunc: ENUMRESLANGPROC; lParam: Longint): BOOL;
external kernel32dll name 'EnumResourceLanguagesA';

function EnumResourceLanguagesW conv arg_stdcall (hModule: HMODULE; lpType, lpName: PWideChar;
lpEnumFunc: ENUMRESLANGPROC; lParam: Longint): BOOL;
external kernel32dll name 'EnumResourceLanguagesW';

function EnumResourceLanguages conv arg_stdcall (hModule: HMODULE; lpType, lpName: PChar;
 lpEnumFunc: ENUMRESLANGPROC; lParam: Longint): BOOL;
 external kernel32dll name 'EnumResourceLanguagesA';

function EnumResourceNamesA conv arg_stdcall (hModule: HMODULE; lpType: PAnsiChar;
lpEnumFunc: ENUMRESNAMEPROC; lParam: Longint): BOOL;
external kernel32dll name 'EnumResourceNamesA';

function EnumResourceNamesW conv arg_stdcall (hModule: HMODULE; lpType: PWideChar;
lpEnumFunc: ENUMRESNAMEPROC; lParam: Longint): BOOL;
external kernel32dll name 'EnumResourceNamesW';

function EnumResourceNames conv arg_stdcall (hModule: HMODULE; lpType: PChar;
 lpEnumFunc: ENUMRESNAMEPROC; lParam: Longint): BOOL;
 external kernel32dll name 'EnumResourceNamesA';

function EnumResourceTypesA conv arg_stdcall (hModule: HMODULE; lpEnumFunc: ENUMRESTYPEPROC;
 lParam: Longint): BOOL;
 external kernel32dll name 'EnumResourceTypesA';

function EnumResourceTypesW conv arg_stdcall (hModule: HMODULE; lpEnumFunc: ENUMRESTYPEPROC;
 lParam: Longint): BOOL;
 external kernel32dll name 'EnumResourceTypesW';

function EnumResourceTypes conv arg_stdcall (hModule: HMODULE; lpEnumFunc: ENUMRESTYPEPROC;
 lParam: Longint): BOOL;
 external kernel32dll name 'EnumResourceTypesA';

function EnumSystemCodePagesA conv arg_stdcall (lpCodePageEnumProc: TFNCodepageEnumProc;
 dwFlags: DWORD): BOOL;
 external kernel32dll name 'EnumSystemCodePagesA';

function EnumSystemCodePagesW conv arg_stdcall (lpCodePageEnumProc: TFNCodepageEnumProc;
 dwFlags: DWORD): BOOL;
 external kernel32dll name 'EnumSystemCodePagesW';

function EnumSystemCodePages conv arg_stdcall (lpCodePageEnumProc: TFNCodepageEnumProc;
 dwFlags: DWORD): BOOL;
 external kernel32dll name 'EnumSystemCodePagesA';

function EnumSystemLocalesA conv arg_stdcall (lpLocaleEnumProc: TFNLocaleEnumProc;
 dwFlags: DWORD): BOOL;
 external kernel32dll name 'EnumSystemLocalesA';

function EnumSystemLocalesW conv arg_stdcall (lpLocaleEnumProc: TFNLocaleEnumProc;
 dwFlags: DWORD): BOOL;
 external kernel32dll name 'EnumSystemLocalesW';

function EnumSystemLocales conv arg_stdcall (lpLocaleEnumProc: TFNLocaleEnumProc;
 dwFlags: DWORD): BOOL;
 external kernel32dll name 'EnumSystemLocalesA';

function EnumTimeFormatsA conv arg_stdcall (lpTimeFmtEnumProc: TFNTimeFmtEnumProc;
 Locale: LCID; dwFlags: DWORD): BOOL;
 external kernel32dll name 'EnumTimeFormatsA';

function EnumTimeFormatsW conv arg_stdcall (lpTimeFmtEnumProc: TFNTimeFmtEnumProc;
 Locale: LCID; dwFlags: DWORD): BOOL;
 external kernel32dll name 'EnumTimeFormatsW';

function EnumTimeFormatsEnumTimeFormats conv arg_stdcall (lpTimeFmtEnumProc: TFNTimeFmtEnumProc;
 Locale: LCID; dwFlags: DWORD): BOOL;
 external kernel32dll name 'EnumTimeFormatsA';

function EraseTape conv arg_stdcall (hDevice: THandle; dwEraseType: DWORD; bImmediate: BOOL):
 DWORD;
 external kernel32dll name 'EraseTape';

function EscapeCommFunction conv arg_stdcall (hFile: THandle; dwFunc: DWORD): BOOL;
 external kernel32dll name 'EscapeCommFunction';

procedure ExitProcess conv arg_stdcall (uExitCode: DWORD);
 external kernel32dll name 'ExitProcess';

procedure ExitThread conv arg_stdcall (dwExitCode: DWORD);
 external kernel32dll name 'ExitThread';

function ExpandEnvironmentStringsA conv arg_stdcall (lpSrc: PAnsiChar; lpDst: PAnsiChar;
nSize: DWORD): DWORD;
external kernel32dll name 'ExpandEnvironmentStringsA';

function ExpandEnvironmentStringsW conv arg_stdcall (lpSrc: PWideChar; lpDst: PWideChar;
nSize: DWORD): DWORD;
external kernel32dll name 'ExpandEnvironmentStringsW';

function ExpandEnvironmentStrings conv arg_stdcall (lpSrc: PChar; lpDst: PChar; nSize: DWORD):
 DWORD;
 external kernel32dll name 'ExpandEnvironmentStringsA';

procedure FatalAppExitA conv arg_stdcall (uAction: DWORD; lpMessageText: PAnsiChar);
external kernel32dll name 'FatalAppExitA';

procedure FatalAppExitW conv arg_stdcall (uAction: DWORD; lpMessageText: PWideChar);
external kernel32dll name 'FatalAppExitW';

procedure FatalAppExit conv arg_stdcall (uAction: DWORD; lpMessageText: PChar);
 external kernel32dll name 'FatalAppExitA';

procedure FatalExit conv arg_stdcall (ExitCode: DWORD);
 external kernel32dll name 'FatalExit';

function FileTimeToDosDateTime conv arg_stdcall (const lpFileTime: TFileTime;
 var lpFatDate, lpFatTime: Word): BOOL;
 external kernel32dll name 'FileTimeToDosDateTime';

function FileTimeToLocalFileTime conv arg_stdcall (const lpFileTime: TFileTime;
 var lpLocalFileTime: TFileTime): BOOL;
 external kernel32dll name 'FileTimeToLocalFileTime';

function FileTimeToSystemTime conv arg_stdcall (const lpFileTime: TFileTime;
 var lpSystemTime: TSystemTime): BOOL;
 external kernel32dll name 'FileTimeToSystemTime';

function FillConsoleOutputAttribute conv arg_stdcall (hConsoleOutput: THandle;
 wAttribute: Word; nLength: DWORD; dwWriteCoord: TCoord;
 var lpNumberOfAttrsWritten: DWORD): BOOL;
 external kernel32dll name 'FillConsoleOutputAttribute';

function FillConsoleOutputCharacterA conv arg_stdcall (hConsoleOutput: THandle;
 cCharacter: AnsiChar; nLength: DWORD; dwWriteCoord: TCoord;
 var lpNumberOfCharsWritten: DWORD): BOOL;
 external kernel32dll name 'FillConsoleOutputCharacterA';

function FillConsoleOutputCharacterW conv arg_stdcall (hConsoleOutput: THandle;
 cCharacter: WideChar; nLength: DWORD; dwWriteCoord: TCoord;
 var lpNumberOfCharsWritten: DWORD): BOOL;
 external kernel32dll name 'FillConsoleOutputCharacterW';

function FillConsoleOutputCharacter conv arg_stdcall (hConsoleOutput: THandle;
 cCharacter: Char;  nLength: DWORD; dwWriteCoord: TCoord;
 var lpNumberOfCharsWritten: DWORD): BOOL;
 external kernel32dll name 'FillConsoleOutputCharacterA';

function FindAtomA conv arg_stdcall (lpString: PAnsiChar): ATOM;
 external kernel32dll name 'FindAtomA';

function FindAtomW conv arg_stdcall (lpString: PWideChar): ATOM;
 external kernel32dll name 'FindAtomW';

function FindAtom conv arg_stdcall (lpString: PChar): ATOM;
 external kernel32dll name 'FindAtomA';

function FindClose conv arg_stdcall (hFindFile: THandle): BOOL;
 external kernel32dll name 'FindClose';

function FindCloseChangeNotification conv arg_stdcall (hChangeHandle: THandle): BOOL;
 external kernel32dll name 'FindCloseChangeNotification';

function FindFirstChangeNotificationA conv arg_stdcall (lpPathName: PAnsiChar;
 bWatchSubtree: BOOL; dwNotifyFilter: DWORD): THandle;
 external kernel32dll name 'FindFirstChangeNotificationA';

function FindFirstChangeNotificationW conv arg_stdcall (lpPathName: PWideChar;
 bWatchSubtree: BOOL; dwNotifyFilter: DWORD): THandle;
 external kernel32dll name 'FindFirstChangeNotificationW';

function FindFirstChangeNotification conv arg_stdcall (lpPathName: PChar;
 bWatchSubtree: BOOL; dwNotifyFilter: DWORD): THandle;
 external kernel32dll name 'FindFirstChangeNotificationA';

function FindFirstFileA conv arg_stdcall (lpFileName: PAnsiChar; var lpFindFileData:
TWIN32FindDataA): THandle;
external kernel32dll name 'FindFirstFileA';

function FindFirstFileExA conv arg_stdcall (lpFileName: PAnsiChar; fInfoLevelId:
TFindexInfoLevels; lpFindFileData: Pointer; fSearchOp: TFindexSearchOps;
lpSearchFilter: Pointer; dwAdditionalFlags: DWORD): BOOL;
external kernel32dll name 'FindFirstFileExA';

function FindFirstFileW conv arg_stdcall (lpFileName: PWideChar; var lpFindFileData:
 TWIN32FindDataW): THandle;
 external kernel32dll name 'FindFirstFileW';

function FindFirstFileExW conv arg_stdcall (lpFileName: PWideChar; fInfoLevelId:
 TFindexInfoLevels; lpFindFileData: Pointer; fSearchOp: TFindexSearchOps;
 lpSearchFilter: Pointer; dwAdditionalFlags: DWORD): BOOL;
 external kernel32dll name 'FindFirstFileExW';

function FindFirstFile conv arg_stdcall (lpFileName: PChar; var lpFindFileData: TWIN32FindData):
 THandle;
 external kernel32dll name 'FindFirstFileA';

function FindFirstFileEx conv arg_stdcall (lpFileName: PChar; fInfoLevelId: TFindexInfoLevels;
 lpFindFileData: Pointer; fSearchOp: TFindexSearchOps;
 lpSearchFilter: Pointer; dwAdditionalFlags: DWORD): BOOL;
 external kernel32dll name 'FindFirstFileExA';

function FindNextChangeNotification conv arg_stdcall (hChangeHandle: THandle): BOOL;
 external kernel32dll name 'FindNextChangeNotification';

function FindNextFileA conv arg_stdcall (hFindFile: THandle; var lpFindFileData:
 TWIN32FindDataA): BOOL;
 external kernel32dll name 'FindNextFileA';

function FindNextFileW conv arg_stdcall (hFindFile: THandle; var lpFindFileData:
 TWIN32FindDataW): BOOL;
 external kernel32dll name 'FindNextFileW';

function FindNextFile conv arg_stdcall (hFindFile: THandle; var lpFindFileData: TWIN32FindData):
 BOOL;
 external kernel32dll name 'FindNextFileA';

function FindResourceA conv arg_stdcall (hModule: HMODULE; lpName, lpType: PAnsiChar): HRSRC;

external kernel32dll name 'FindResourceA';

function FindResourceW conv arg_stdcall (hModule: HMODULE; lpName, lpType: PWideChar): HRSRC;

external kernel32dll name 'FindResourceW';

function FindResource conv arg_stdcall (hModule: HMODULE; lpName, lpType: PChar): HRSRC;
  external kernel32dll name 'FindResourceA';

function FindResourceExA conv arg_stdcall (hModule: HMODULE; lpType, lpName: PAnsiChar;
wLanguage: Word): HRSRC;
external kernel32dll name 'FindResourceExA';

function FindResourceExW conv arg_stdcall (hModule: HMODULE; lpType, lpName: PWideChar;
wLanguage: Word): HRSRC;
external kernel32dll name 'FindResourceExW';

function FindResourceEx conv arg_stdcall (hModule: HMODULE; lpType, lpName: PChar;
 wLanguage: Word): HRSRC;
 external kernel32dll name 'FindResourceExA';

function FlushConsoleInputBuffer conv arg_stdcall (hConsoleInput: THandle): BOOL;
 external kernel32dll name 'FlushConsoleInputBuffer';

function FlushFileBuffers conv arg_stdcall (hFile: THandle): BOOL;
 external kernel32dll name 'FlushFileBuffers';

function FlushInstructionCache conv arg_stdcall (hProcess: THandle;
 const lpBaseAddress: Pointer; dwSize: DWORD): BOOL;
 external kernel32dll name 'FlushInstructionCache';

function FlushViewOfFile conv arg_stdcall (const lpBaseAddress: Pointer;
 dwNumberOfBytesToFlush: DWORD): BOOL;
 external kernel32dll name 'FlushViewOfFile';

function FoldStringA conv arg_stdcall (dwMapFlags: DWORD; lpSrcStr: PAnsiChar; cchSrc: DWORD;
lpDestStr: PAnsiChar; cchDest: DWORD): DWORD;
external kernel32dll name 'FoldStringA';

function FoldStringW conv arg_stdcall (dwMapFlags: DWORD; lpSrcStr: PWideChar; cchSrc: DWORD;
lpDestStr: PWideChar; cchDest: DWORD): DWORD;
external kernel32dll name 'FoldStringW';

function FoldString conv arg_stdcall (dwMapFlags: DWORD; lpSrcStr: PChar; cchSrc: DWORD;
 lpDestStr: PChar; cchDest: DWORD): DWORD;
 external kernel32dll name 'FoldStringA';

function FormatMessageA conv arg_stdcall (dwFlags: DWORD; lpSource: Pointer;
dwMessageId: DWORD; dwLanguageId: DWORD; lpBuffer: PAnsiChar;
nSize: DWORD; Arguments: Pointer): DWORD;
external kernel32dll name 'FormatMessageA';

function FormatMessageW conv arg_stdcall (dwFlags: DWORD; lpSource: Pointer;
dwMessageId: DWORD; dwLanguageId: DWORD; lpBuffer: PWideChar;
nSize: DWORD; Arguments: Pointer): DWORD;
external kernel32dll name 'FormatMessageW';

function FormatMessage conv arg_stdcall (dwFlags: DWORD; lpSource: Pointer; dwMessageId:
 DWORD; dwLanguageId: DWORD; lpBuffer: PWideChar; nSize: DWORD;
 Arguments: Pointer): DWORD;
 external kernel32dll name 'FormatMessageA';

function FreeConsole: BOOL;  external kernel32dll name 'FreeConsole';

function FreeEnvironmentStringsA conv arg_stdcall (p1: PAnsiChar): BOOL;
external kernel32dll name 'FreeEnvironmentStringsA';

function FreeEnvironmentStringsW conv arg_stdcall (p1: PWideChar): BOOL;
external kernel32dll name 'FreeEnvironmentStringsW';

function FreeEnvironmentStrings conv arg_stdcall (p1: PChar): BOOL;
 external kernel32dll name 'FreeEnvironmentStringsA';

function FreeLibrary conv arg_stdcall (hLibModule: HMODULE): BOOL;
 external kernel32dll name 'FreeLibrary';

procedure FreeLibraryAndExitThread conv arg_stdcall (hLibModule: HMODULE; dwExitCode: DWORD);

 external kernel32dll name 'FreeLibraryAndExitThread';

function FreeResource conv arg_stdcall (hResData: HGLOBAL): BOOL;
 external kernel32dll name 'FreeResource';

function InterlockedCompareExchange conv arg_stdcall (var Destination: Pointer;
 Exchange: Pointer; Comperand: Pointer): Pointer;
 external kernel32dll name 'InterlockedCompareExchange';

function InterlockedDecrement conv arg_stdcall (var Addend: DWORD): DWORD;
 external kernel32dll name 'InterlockedDecrement';

function InterlockedExchange conv arg_stdcall (var Target: DWORD; Value: DWORD): DWORD;
  external kernel32dll name 'InterlockedExchange';

function InterlockedExchangeAdd conv arg_stdcall (Addend: PLongint; Value: Longint): Longint;

 external kernel32dll name 'InterlockedExchangeAdd';

function InterlockedIncrement conv arg_stdcall (var Addend: DWORD): DWORD;
 external kernel32dll name 'InterlockedIncrement';

function GenerateConsoleCtrlEvent conv arg_stdcall (dwCtrlEvent: DWORD;
 dwProcessGroupId: DWORD): BOOL;
 external kernel32dll name 'GenerateConsoleCtrlEvent';

function GetACP: DWORD; external kernel32dll name 'GetACP';

function GetAtomNameA conv arg_stdcall (nAtom: ATOM; lpBuffer: PAnsiChar; nSize: DWORD): DWORD;

external kernel32dll name 'GetAtomNameA';

function GetAtomNameW conv arg_stdcall (nAtom: ATOM; lpBuffer: PWideChar; nSize: DWORD): DWORD;

external kernel32dll name 'GetAtomNameW';

function GetAtomName conv arg_stdcall (nAtom: ATOM; lpBuffer: PChar; nSize: DWORD): DWORD;

 external kernel32dll name 'GetAtomNameA';

function GetBinaryTypeA conv arg_stdcall (lpApplicationName: PAnsiChar; var lpBinaryType: DWORD): BOOL;
external kernel32dll name 'GetBinaryTypeA';

function GetBinaryTypeW conv arg_stdcall (lpApplicationName: PWideChar; var lpBinaryType: DWORD): BOOL;
external kernel32dll name 'GetBinaryTypeW';

function GetBinaryType conv arg_stdcall (lpApplicationName: PChar; var lpBinaryType: DWORD): BOOL;
 external kernel32dll name 'GetBinaryTypeA';

function GetCPInfo conv arg_stdcall (CodePage: DWORD; var lpCPInfo: TCPInfo): BOOL;
 external kernel32dll name 'GetCPInfo';

function GetCommandLineA: PAnsiChar;
external kernel32dll name 'GetCommandLineA';

function GetCommandLineW: PWideChar;
external kernel32dll name 'GetCommandLineW';

function GetCommandLine: PChar;
 external kernel32dll name 'GetCommandLineA';

function GetCommConfig conv arg_stdcall (hCommDev: THandle; var lpCC: TCommConfig; var lpdwSize: DWORD): BOOL;
 external kernel32dll name 'GetCommConfig';

function GetCommMask conv arg_stdcall (hFile: THandle; var lpEvtMask: DWORD): BOOL;
 external kernel32dll name 'GetCommMask';

function GetCommModemStatus conv arg_stdcall (hFile: THandle; var lpModemStat: DWORD): BOOL;
 external kernel32dll name 'GetCommModemStatus';

function GetCommProperties conv arg_stdcall (hFile: THandle; var lpCommProp: TCommProp): BOOL;
 external kernel32dll name 'GetCommProperties';

function GetCommState conv arg_stdcall (hFile: THandle; const lpDCB: TDCB): BOOL;
 external kernel32dll name 'GetCommState';

function GetCommTimeouts conv arg_stdcall (hFile: THandle; const lpCommTimeouts: TCommTimeouts): BOOL;
 external kernel32dll name 'GetCommTimeouts';

function GetCompressedFileSizeA conv arg_stdcall (lpFileName: PAnsiChar; lpFileSizeHigh: PDWORD): DWORD;
external kernel32dll name 'GetCompressedFileSizeA';

function GetCompressedFileSizeW conv arg_stdcall (lpFileName: PWideChar; lpFileSizeHigh: PDWORD): DWORD;
external kernel32dll name 'GetCompressedFileSizeW';

function GetCompressedFileSize conv arg_stdcall (lpFileName: PChar; lpFileSizeHigh: PDWORD): DWORD;
 external kernel32dll name 'GetCompressedFileSizeA';

function GetComputerNameA conv arg_stdcall (lpBuffer: PAnsiChar; var nSize: DWORD): BOOL;
external kernel32dll name 'GetComputerNameA';

function GetComputerNameW conv arg_stdcall (lpBuffer: PWideChar; var nSize: DWORD): BOOL;
external kernel32dll name 'GetComputerNameW';

function GetComputerName conv arg_stdcall (lpBuffer: PChar; var nSize: DWORD): BOOL;
 external kernel32dll name 'GetComputerNameA';

function GetConsoleCP: DWORD;
 external kernel32dll name 'GetConsoleCP';

function GetConsoleCursorInfo conv arg_stdcall (hConsoleOutput: THandle; var lpConsoleCursorInfo: TConsoleCursorInfo): BOOL;
 external kernel32dll name 'GetConsoleCursorInfo';

function GetConsoleMode conv arg_stdcall (hConsoleHandle: THandle; var lpMode: DWORD): BOOL;
 external kernel32dll name 'GetConsoleMode';

function GetConsoleOutputCP: DWORD;
 external kernel32dll name 'GetConsoleOutputCP';

function GetConsoleScreenBufferInfo conv arg_stdcall (hConsoleOutput: THandle; var lpConsoleScreenBufferInfo: TConsoleScreenBufferInfo): BOOL;
 external kernel32dll name 'GetConsoleScreenBufferInfo';

function GetConsoleTitleA conv arg_stdcall (lpConsoleTitle: PAnsiChar; nSize: DWORD): DWORD;
external kernel32dll name 'GetConsoleTitleA';

function GetConsoleTitleW conv arg_stdcall (lpConsoleTitle: PWideChar; nSize: DWORD): DWORD;
external kernel32dll name 'GetConsoleTitleW';

function GetConsoleTitle conv arg_stdcall (lpConsoleTitle: PChar; nSize: DWORD): DWORD;
 external kernel32dll name 'GetConsoleTitleA';

function GetCurrencyFormatA conv arg_stdcall (Locale: LCID; dwFlags: DWORD; lpValue: PAnsiChar;
lpFormat: PCurrencyFmtA; lpCurrencyStr: PAnsiChar; cchCurrency: DWORD): DWORD;
external kernel32dll name 'GetCurrencyFormatA';

function GetCurrencyFormatW conv arg_stdcall (Locale: LCID; dwFlags: DWORD; lpValue: PWideChar;
lpFormat: PCurrencyFmtW; lpCurrencyStr: PWideChar; cchCurrency: DWORD): DWORD;
external kernel32dll name 'GetCurrencyFormatW';

function GetCurrencyFormat conv arg_stdcall (Locale: LCID; dwFlags: DWORD; lpValue: PChar;
 lpFormat: PCurrencyFmt; lpCurrencyStr: PChar; cchCurrency: DWORD): DWORD;
 external kernel32dll name 'GetCurrencyFormatA';

function GetCurrentDirectoryA conv arg_stdcall (nBufferLength: DWORD; lpBuffer: PAnsiChar): DWORD;
external kernel32dll name 'GetCurrentDirectoryA';

function GetCurrentDirectoryW conv arg_stdcall (nBufferLength: DWORD; lpBuffer: PWideChar): DWORD;
external kernel32dll name 'GetCurrentDirectoryW';

function GetCurrentDirectory conv arg_stdcall (nBufferLength: DWORD; lpBuffer: PChar): DWORD;
 external kernel32dll name 'GetCurrentDirectoryA';

function GetCurrentProcess: THandle;
 external kernel32dll name 'GetCurrentProcess';

function GetCurrentProcessId: DWORD;
 external kernel32dll name 'GetCurrentProcessId';

function GetCurrentThread: THandle;
 external kernel32dll name 'GetCurrentThread';

function GetCurrentThreadId: DWORD;
 external kernel32dll name 'GetCurrentThreadId';

function GetDateFormatA conv arg_stdcall (Locale: LCID; dwFlags: DWORD; lpDate: PSystemTime;
lpFormat: PAnsiChar; lpDateStr: PAnsiChar; cchDate: DWORD): DWORD;
external kernel32dll name 'GetDateFormatA';

function GetDateFormatW conv arg_stdcall (Locale: LCID; dwFlags: DWORD; lpDate: PSystemTime;
lpFormat: PWideChar; lpDateStr: PWideChar; cchDate: DWORD): DWORD;
external kernel32dll name 'GetDateFormatW';

function GetDateFormat conv arg_stdcall (Locale: LCID; dwFlags: DWORD; lpDate: PSystemTime;
 lpFormat: PChar; lpDateStr: PChar; cchDate: DWORD): DWORD;
 external kernel32dll name 'GetDateFormatA';

function GetDefaultCommConfigA conv arg_stdcall (lpszName: PAnsiChar; var lpCC: TCommConfig; var lpdwSize: DWORD): BOOL;
external kernel32dll name 'GetDefaultCommConfigA';

function GetDefaultCommConfigW conv arg_stdcall (lpszName: PWideChar; var lpCC: TCommConfig; var lpdwSize: DWORD): BOOL;
external kernel32dll name 'GetDefaultCommConfigW';

function GetDefaultCommConfig conv arg_stdcall (lpszName: PChar; var lpCC: TCommConfig; var lpdwSize: DWORD): BOOL;
 external kernel32dll name 'GetDefaultCommConfigA';

function GetDiskFreeSpaceA conv arg_stdcall (lpRootPathName: PAnsiChar; var lpSectorsPerCluster, lpBytesPerSector, lpNumberOfFreeClusters, lpTotalNumberOfClusters: DWORD): BOOL;
external kernel32dll name 'GetDiskFreeSpaceA';

function GetDiskFreeSpaceW conv arg_stdcall (lpRootPathName: PWideChar; var lpSectorsPerCluster, lpBytesPerSector, lpNumberOfFreeClusters, lpTotalNumberOfClusters: DWORD): BOOL;
external kernel32dll name 'GetDiskFreeSpaceW';

function GetDiskFreeSpace conv arg_stdcall (lpRootPathName: PChar; var lpSectorsPerCluster, lpBytesPerSector, lpNumberOfFreeClusters, lpTotalNumberOfClusters: DWORD): BOOL;
 external kernel32dll name 'GetDiskFreeSpaceA';

function GetDiskFreeSpaceExA conv arg_stdcall (lpDirectoryName: PAnsiChar; var lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes: TLargeInteger): BOOL;
external kernel32dll name 'GetDiskFreeSpaceExA';

function GetDiskFreeSpaceExW conv arg_stdcall (lpDirectoryName: PWideChar; var lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes: TLargeInteger): BOOL;
external kernel32dll name 'GetDiskFreeSpaceExW';

function GetDiskFreeSpaceEx conv arg_stdcall (lpDirectoryName: PChar;
 var lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes: TLargeInteger): BOOL;
 external kernel32dll name 'GetDiskFreeSpaceExA';

function GetDriveTypeA conv arg_stdcall (lpRootPathName: PAnsiChar): DWORD;
external kernel32dll name 'GetDriveTypeA';

function GetDriveTypeW conv arg_stdcall (lpRootPathName: PWideChar): DWORD;
external kernel32dll name 'GetDriveTypeW';

function GetDriveType conv arg_stdcall (lpRootPathName: PChar): DWORD;
 external kernel32dll name 'GetDriveTypeA';

function GetEnvironmentStringsA: PAnsiChar;
external kernel32dll name 'GetEnvironmentStringsA';

function GetEnvironmentStringsW: PWideChar;
external kernel32dll name 'GetEnvironmentStringsW';

function GetEnvironmentStrings: PChar;
 external kernel32dll name 'GetEnvironmentStringsA';

function GetEnvironmentVariableA conv arg_stdcall (lpName: PAnsiChar; lpBuffer: PAnsiChar; nSize: DWORD): DWORD;
external kernel32dll name 'GetEnvironmentVariableA';

function GetEnvironmentVariableW conv arg_stdcall (lpName: PWideChar; lpBuffer: PWideChar; nSize: DWORD): DWORD;
external kernel32dll name 'GetEnvironmentVariableW';

function GetEnvironmentVariable conv arg_stdcall (lpName: PChar; lpBuffer: PChar; nSize: DWORD): DWORD;
 external kernel32dll name 'GetEnvironmentVariableA';

function GetExitCodeProcess conv arg_stdcall (hProcess: THandle; var lpExitCode: DWORD): BOOL;
 external kernel32dll name 'GetExitCodeProcess';

function GetExitCodeThread conv arg_stdcall (hThread: THandle; var lpExitCode: DWORD): BOOL;
 external kernel32dll name 'GetExitCodeThread';

function GetFileAttributesA conv arg_stdcall (lpFileName: PAnsiChar): DWORD;
external kernel32dll name 'GetFileAttributesA';

function GetFileAttributesW conv arg_stdcall (lpFileName: PWideChar): DWORD;
external kernel32dll name 'GetFileAttributesW';

function GetFileAttributes conv arg_stdcall (lpFileName: PChar): DWORD;
 external kernel32dll name 'GetFileAttributesA';

function GetFileAttributesExA conv arg_stdcall (lpFileName: PAnsiChar; fInfoLevelId: TGetFileExInfoLevels; lpFileInformation: Pointer): BOOL;
external kernel32dll name 'GetFileAttributesExA';

function GetFileAttributesExW conv arg_stdcall (lpFileName: PWideChar; fInfoLevelId: TGetFileExInfoLevels; lpFileInformation: Pointer): BOOL;
external kernel32dll name 'GetFileAttributesExW';

function GetFileAttributesEx conv arg_stdcall (lpFileName: PChar; fInfoLevelId: TGetFileExInfoLevels; lpFileInformation: Pointer): BOOL;
 external kernel32dll name 'GetFileAttributesExA';

function GetFileInformationByHandle conv arg_stdcall (hFile: THandle; var lpFileInformation: TByHandleFileInformation): BOOL;
 external kernel32dll name 'GetFileInformationByHandle';

function GetFileSize conv arg_stdcall (hFile: THandle; lpFileSizeHigh: Pointer): DWORD;
 external kernel32dll name 'GetFileSize';

function GetFileTime conv arg_stdcall (hFile: THandle; lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL;
 external kernel32dll name 'GetFileTime';

function GetFileType conv arg_stdcall (hFile: THandle): DWORD;
 external kernel32dll name 'GetFileType';

function GetFullPathNameA conv arg_stdcall (lpFileName: PAnsiChar; nBufferLength: DWORD; lpBuffer: PAnsiChar; var lpFilePart: PAnsiChar): DWORD;
external kernel32dll name 'GetFullPathNameA';

function GetFullPathNameW conv arg_stdcall (lpFileName: PWideChar; nBufferLength: DWORD; lpBuffer: PWideChar; var lpFilePart: PWideChar): DWORD;
external kernel32dll name 'GetFullPathNameW';

function GetFullPathName conv arg_stdcall (lpFileName: PChar; nBufferLength: DWORD; lpBuffer: PChar; var lpFilePart: PChar): DWORD;
 external kernel32dll name 'GetFullPathNameA';

function GetHandleInformation conv arg_stdcall (hObject: THandle; var lpdwFlags: DWORD): BOOL;
 external kernel32dll name 'GetHandleInformation';

function GetLargestConsoleWindowSize conv arg_stdcall (hConsoleOutput: THandle): TCoord;
 external kernel32dll name 'GetLargestConsoleWindowSize';

function GetLastError: DWORD;
 external kernel32dll name 'GetLastError';

procedure GetLocalTime conv arg_stdcall (var lpSystemTime: TSystemTime);
 external kernel32dll name 'GetLocalTime';

function GetLocaleInfoA conv arg_stdcall (Locale: LCID; LCType: LCTYPE; lpLCData: PAnsiChar; cchData: DWORD): DWORD;
external kernel32dll name 'GetLocaleInfoA';

function GetLocaleInfoW conv arg_stdcall (Locale: LCID; LCType: LCTYPE; lpLCData: PWideChar; cchData: DWORD): DWORD;
external kernel32dll name 'GetLocaleInfoW';

function GetLocaleInfo conv arg_stdcall (Locale: LCID; LCType: LCTYPE; lpLCData: PChar; cchData: DWORD): DWORD;
 external kernel32dll name 'GetLocaleInfoA';

function GetLogicalDrives: DWORD;
 external kernel32dll name 'GetLogicalDrives';

function GetLogicalDriveStringsA conv arg_stdcall (nBufferLength: DWORD; lpBuffer: PAnsiChar): DWORD;
external kernel32dll name 'GetLogicalDriveStringsA';

function GetLogicalDriveStringsW conv arg_stdcall (nBufferLength: DWORD; lpBuffer: PAnsiChar): DWORD;
external kernel32dll name 'GetLogicalDriveStringsW';

function GetLogicalDriveStrings conv arg_stdcall (nBufferLength: DWORD; lpBuffer: PChar): DWORD;
 external kernel32dll name 'GetLogicalDriveStringsA';

function GetMailslotInfo conv arg_stdcall (hMailslot: THandle; lpMaxMessageSize: Pointer;
 var lpNextSize: DWORD; lpMessageCount, lpReadTimeout: Pointer): BOOL;
 external kernel32dll name 'GetMailslotInfo';

function GetModuleFileNameA conv arg_stdcall (hModule: HINST; lpFilename: PAnsiChar; nSize: DWORD): DWORD;
external kernel32dll name 'GetModuleFileNameA';

function GetModuleFileNameW conv arg_stdcall (hModule: HINST; lpFilename: PWideChar; nSize: DWORD): DWORD;
external kernel32dll name 'GetModuleFileNameW';

function GetModuleFileName conv arg_stdcall (hModule: HINST; lpFilename: PChar; nSize: DWORD): DWORD;
 external kernel32dll name 'GetModuleFileNameA';

function GetModuleHandleA conv arg_stdcall (lpModuleName: PAnsiChar): HMODULE;
external kernel32dll name 'GetModuleHandleA';

function GetModuleHandleW conv arg_stdcall (lpModuleName: PWideChar): HMODULE;
external kernel32dll name 'GetModuleHandleW';

function GetModuleHandle conv arg_stdcall (lpModuleName: PChar): HMODULE;
 external kernel32dll name 'GetModuleHandleA';

function GetNamedPipeHandleStateA conv arg_stdcall (hNamedPipe: THandle; lpState, lpCurInstances, lpMaxCollectionCount, lpCollectDataTimeout: PDWORD;
 lpUserName: PAnsiChar; nMaxUserNameSize: DWORD): BOOL;
external kernel32dll name 'GetNamedPipeHandleStateA';

function GetNamedPipeHandleStateW conv arg_stdcall (hNamedPipe: THandle; lpState, lpCurInstances, lpMaxCollectionCount, lpCollectDataTimeout: PDWORD;
 lpUserName: PWideChar; nMaxUserNameSize: DWORD): BOOL;
external kernel32dll name 'GetNamedPipeHandleStateW';

function GetNamedPipeHandleState conv arg_stdcall (hNamedPipe: THandle; lpState, lpCurInstances, lpMaxCollectionCount, lpCollectDataTimeout: PDWORD;
  lpUserName: PChar; nMaxUserNameSize: DWORD): BOOL;
 external kernel32dll name 'GetNamedPipeHandleStateA';

function GetNamedPipeInfo conv arg_stdcall (hNamedPipe: THandle; var lpFlags: DWORD; lpOutBufferSize, lpInBufferSize, lpMaxInstances: Pointer): BOOL;
 external kernel32dll name 'GetNamedPipeInfo';

function GetNumberFormatA conv arg_stdcall (Locale: LCID; dwFlags: DWORD; lpValue: PAnsiChar; lpFormat: PNumberFmtA; lpNumberStr: PAnsiChar; cchNumber: DWORD): DWORD;
external kernel32dll name 'GetNumberFormatA';

function GetNumberFormatW conv arg_stdcall (Locale: LCID; dwFlags: DWORD; lpValue: PWideChar; lpFormat: PNumberFmtW; lpNumberStr: PWideChar; cchNumber: DWORD): DWORD;
external kernel32dll name 'GetNumberFormatW';

function GetNumberFormat conv arg_stdcall (Locale: LCID; dwFlags: DWORD; lpValue: PChar; cchNumber: DWORD): DWORD;
 external kernel32dll name 'GetNumberFormatA';

function GetNumberOfConsoleInputEvents conv arg_stdcall (hConsoleInput: THandle; var lpNumberOfEvents: DWORD): BOOL;
 external kernel32dll name 'GetNumberOfConsoleInputEvents';

function GetNumberOfConsoleMouseButtons conv arg_stdcall (var lpNumberOfMouseButtons: DWORD): BOOL;
 external kernel32dll name 'GetNumberOfConsoleMouseButtons';

function GetOEMCP: DWORD;
 external kernel32dll name 'GetOEMCP';

function GetOverlappedResult conv arg_stdcall (hFile: THandle; const lpOverlapped: TOverlapped;
 var lpNumberOfBytesTransferred: DWORD; bWait: BOOL): BOOL;
 external kernel32dll name 'GetOverlappedResult';

function GetPriorityClass conv arg_stdcall (hProcess: THandle): DWORD;
 external kernel32dll name 'GetPriorityClass';

function GetPrivateProfileIntA conv arg_stdcall (lpAppName, lpKeyName: PAnsiChar; nDefault: DWORD; lpFileName: PAnsiChar): DWORD;
external kernel32dll name 'GetPrivateProfileIntA';

function GetPrivateProfileIntW conv arg_stdcall (lpAppName, lpKeyName: PWideChar; nDefault: DWORD; lpFileName: PWideChar): DWORD;
external kernel32dll name 'GetPrivateProfileIntW';

function GetPrivateProfileInt conv arg_stdcall (lpAppName, lpKeyName: PChar; nDefault: DWORD; lpFileName: PChar): DWORD;
 external kernel32dll name 'GetPrivateProfileIntA';

function GetPrivateProfileSectionA conv arg_stdcall (lpAppName: PAnsiChar; lpReturnedString: PAnsiChar; nSize: DWORD): DWORD;
external kernel32dll name 'GetPrivateProfileSectionA';

function GetPrivateProfileSectionW conv arg_stdcall (lpAppName: PWideChar; lpReturnedString: PWideChar; nSize: DWORD): DWORD;
external kernel32dll name 'GetPrivateProfileSectionW';

function GetPrivateProfileSection conv arg_stdcall (lpAppName: PChar; lpReturnedString: PChar; nSize: DWORD): DWORD;
 external kernel32dll name 'GetPrivateProfileSectionA';

function GetPrivateProfileSectionNamesA conv arg_stdcall (lpszReturnBuffer: PAnsiChar; nSize: DWORD; lpFileName: PAnsiChar): DWORD;
external kernel32dll name 'GetPrivateProfileSectionNamesA';

function GetPrivateProfileSectionNamesW conv arg_stdcall (lpszReturnBuffer: PWideChar; nSize: DWORD; lpFileName: PWideChar): DWORD;
external kernel32dll name 'GetPrivateProfileSectionNamesW';

function GetPrivateProfileSectionNames conv arg_stdcall (lpszReturnBuffer: PChar; nSize: DWORD; lpFileName: PChar): DWORD;
 external kernel32dll name 'GetPrivateProfileSectionNamesA';

function GetPrivateProfileStringA conv arg_stdcall (lpAppName, lpKeyName, lpDefault: PAnsiChar;
lpReturnedString: PAnsiChar; nSize: DWORD; lpFileName: PAnsiChar): DWORD;
external kernel32dll name 'GetPrivateProfileStringA';

function GetPrivateProfileStringW conv arg_stdcall (lpAppName, lpKeyName, lpDefault: PWideChar;
lpReturnedString: PWideChar; nSize: DWORD; lpFileName: PWideChar): DWORD;
external kernel32dll name 'GetPrivateProfileStringW';

function GetPrivateProfileString conv arg_stdcall (lpAppName, lpKeyName, lpDefault: PChar;
 lpReturnedString: PChar; nSize: DWORD; lpFileName: PChar): DWORD;
 external kernel32dll name 'GetPrivateProfileStringA';

function GetProcAddress conv arg_stdcall (hModule: HMODULE; lpProcName: LPCSTR): FARPROC;
 external kernel32dll name 'GetProcAddress';

function GetProcessAffinityMask conv arg_stdcall (hProcess: THandle; var lpProcessAffinityMask, lpSystemAffinityMask: DWORD): BOOL;
 external kernel32dll name 'GetProcessAffinityMask';

function GetProcessHeap: THandle;
 external kernel32dll name 'GetProcessHeap';

function GetProcessHeaps conv arg_stdcall (NumberOfHeaps: DWORD; var ProcessHeaps: THandle): DWORD;
 external kernel32dll name 'GetProcessHeaps';

function GetProcessPriorityBoost conv arg_stdcall (hThread: THandle; var DisablePriorityBoost: Bool): BOOL;
 external kernel32dll name 'GetProcessPriorityBoost';

function GetProcessShutdownParameters conv arg_stdcall (var lpdwLevel, lpdwFlags: DWORD): BOOL;
 external kernel32dll name 'GetProcessShutdownParameters';

function GetProcessTimes conv arg_stdcall (hProcess: THandle; var lpCreationTime, lpExitTime, lpKernelTime, lpUserTime: TFileTime): BOOL;
 external kernel32dll name 'GetProcessTimes';

function GetProcessVersion conv arg_stdcall (ProcessId: DWORD): DWORD;
 external kernel32dll name 'GetProcessVersion';

function GetProcessWorkingSetSize conv arg_stdcall (hProcess: THandle; var lpMinimumWorkingSetSize, lpMaximumWorkingSetSize: DWORD): BOOL;
 external kernel32dll name 'GetProcessWorkingSetSize';

function GetProfileIntA conv arg_stdcall (lpAppName, lpKeyName: PAnsiChar; nDefault: DWORD): DWORD;
external kernel32dll name 'GetProfileIntA';

function GetProfileIntW conv arg_stdcall (lpAppName, lpKeyName: PWideChar; nDefault: DWORD): DWORD;
external kernel32dll name 'GetProfileIntW';

function GetProfileInt conv arg_stdcall (lpAppName, lpKeyName: PChar; nDefault: DWORD): DWORD;
 external kernel32dll name 'GetProfileIntA';

function GetProfileSectionA conv arg_stdcall (lpAppName: PAnsiChar; lpReturnedString: PAnsiChar; nSize: DWORD): DWORD;
external kernel32dll name 'GetProfileSectionA';

function GetProfileSectionW conv arg_stdcall (lpAppName: PWideChar; lpReturnedString: PWideChar; nSize: DWORD): DWORD;
external kernel32dll name 'GetProfileSectionW';

function GetProfileSection conv arg_stdcall (lpAppName: PChar; lpReturnedString: PChar; nSize: DWORD): DWORD;
 external kernel32dll name 'GetProfileSectionA';

function GetProfileStringA conv arg_stdcall (lpAppName, lpKeyName, lpDefault: PAnsiChar; lpReturnedString: PAnsiChar; nSize: DWORD): DWORD;
external kernel32dll name 'GetProfileStringA';

function GetProfileStringW conv arg_stdcall (lpAppName, lpKeyName, lpDefault: PWideChar; lpReturnedString: PWideChar; nSize: DWORD): DWORD;
external kernel32dll name 'GetProfileStringW';

function GetProfileString conv arg_stdcall (lpAppName, lpKeyName, lpDefault: PChar; lpReturnedString: PChar; nSize: DWORD): DWORD;
 external kernel32dll name 'GetProfileStringA';

function GetQueuedCompletionStatus conv arg_stdcall (CompletionPort: THandle; var lpNumberOfBytesTransferred, lpCompletionKey: DWORD;
  var lpOverlapped: POverlapped; dwMilliseconds: DWORD): BOOL;
 external kernel32dll name 'GetQueuedCompletionStatus';

function GetShortPathNameA conv arg_stdcall (lpszLongPath: PAnsiChar; lpszShortPath: PAnsiChar; cchBuffer: DWORD): DWORD;
external kernel32dll name 'GetShortPathNameA';

function GetShortPathNameW conv arg_stdcall (lpszLongPath: PWideChar; lpszShortPath: PWideChar; cchBuffer: DWORD): DWORD;
external kernel32dll name 'GetShortPathNameW';

function GetShortPathName conv arg_stdcall (lpszLongPath: PChar; lpszShortPath: PChar; cchBuffer: DWORD): DWORD;
 external kernel32dll name 'GetShortPathNameA';

procedure GetStartupInfoA conv arg_stdcall (var lpStartupInfo: TStartupInfo);
 external kernel32dll name 'GetStartupInfoA';

procedure GetStartupInfoW conv arg_stdcall (var lpStartupInfo: TStartupInfo);
 external kernel32dll name 'GetStartupInfoW';

procedure GetStartupInfo conv arg_stdcall (var lpStartupInfo: TStartupInfo);
 external kernel32dll name 'GetStartupInfoA';

function GetStdHandle conv arg_stdcall (nStdHandle: DWORD): THandle;
 external kernel32dll name 'GetStdHandle';

function GetStringTypeExA conv arg_stdcall (Locale: LCID; dwInfoType: DWORD; lpSrcStr: PAnsiChar; cchSrc: DWORD; var lpCharType): BOOL;
external kernel32dll name 'GetStringTypeExA';

function GetStringTypeExW conv arg_stdcall (Locale: LCID; dwInfoType: DWORD; lpSrcStr: PWideChar; cchSrc: DWORD; var lpCharType): BOOL;
external kernel32dll name 'GetStringTypeExW';

function GetStringTypeEx conv arg_stdcall (Locale: LCID; dwInfoType: DWORD; lpSrcStr: PChar; cchSrc: DWORD; var lpCharType): BOOL;
 external kernel32dll name 'GetStringTypeExA';

function GetStringTypeA conv arg_stdcall (Locale: LCID; dwInfoType: DWORD; const lpSrcStr: LPCSTR; cchSrc: BOOL; var lpCharType: Word): BOOL;
 external kernel32dll name 'GetStringTypeA';

function GetStringTypeW conv arg_stdcall (dwInfoType: DWORD; const lpSrcStr: WCHAR; cchSrc: BOOL; var lpCharType: Word): BOOL;
 external kernel32dll name 'GetStringTypeW';

function GetSystemDefaultLCID: LCID;
 external kernel32dll name 'GetSystemDefaultLCID';

function GetSystemDefaultLangID: LANGID;
 external kernel32dll name 'GetSystemDefaultLangID';

function GetSystemDirectoryA conv arg_stdcall (lpBuffer: PAnsiChar; uSize: DWORD): DWORD;
external kernel32dll name 'GetSystemDirectoryA';

function GetSystemDirectoryW conv arg_stdcall (lpBuffer: PWideChar; uSize: DWORD): DWORD;
external kernel32dll name 'GetSystemDirectoryW';

function GetSystemDirectory conv arg_stdcall (lpBuffer: PChar; uSize: DWORD): DWORD;
 external kernel32dll name 'GetSystemDirectoryA';

procedure GetSystemInfo conv arg_stdcall (var lpSystemInfo: TSystemInfo);
 external kernel32dll name 'GetSystemInfo';

function GetSystemPowerStatus conv arg_stdcall (var lpSystemPowerStatus: TSystemPowerStatus): BOOL;
 external kernel32dll name 'GetSystemPowerStatus';

procedure GetSystemTime conv arg_stdcall (var lpSystemTime: TSystemTime);
 external kernel32dll name 'GetSystemTime';

procedure GetSystemTimeAsFileTime conv arg_stdcall (var lpSystemTimeAsFileTime: TFileTime);
 external kernel32dll name 'GetSystemTimeAsFileTime';

function GetSystemTimeAdjustment conv arg_stdcall (var lpTimeAdjustment, lpTimeIncrement: DWORD; var lpTimeAdjustmentDisabled: BOOL): BOOL;
 external kernel32dll name 'GetSystemTimeAdjustment';

function GetTapeParameters conv arg_stdcall (hDevice: THandle; dwOperation: DWORD; var lpdwSize: DWORD; lpTapeInformation: Pointer): DWORD;
 external kernel32dll name 'GetTapeParameters';

function GetTapePosition conv arg_stdcall (hDevice: THandle; dwPositionType: DWORD; var lpdwPartition, lpdwOffsetLow: DWORD; lpdwOffsetHigh: Pointer): DWORD;
 external kernel32dll name 'GetTapePosition';

function GetTapeStatus conv arg_stdcall (hDevice: THandle): DWORD;
 external kernel32dll name 'GetTapeStatus';

function GetTempFileNameA conv arg_stdcall (lpPathName, lpPrefixString: PAnsiChar; uUnique: DWORD; lpTempFileName: PAnsiChar): DWORD;
external kernel32dll name 'GetTempFileNameA';

function GetTempFileNameW conv arg_stdcall (lpPathName, lpPrefixString: PWideChar; uUnique: DWORD; lpTempFileName: PWideChar): DWORD;
external kernel32dll name 'GetTempFileNameW';

function GetTempFileName conv arg_stdcall (lpPathName, lpPrefixString: PChar; uUnique: DWORD; lpTempFileName: PChar): DWORD;
 external kernel32dll name 'GetTempFileNameA';

function GetTempPathA conv arg_stdcall (nBufferLength: DWORD; lpBuffer: PAnsiChar): DWORD;
external kernel32dll name 'GetTempPathA';

function GetTempPathW conv arg_stdcall (nBufferLength: DWORD; lpBuffer: PWideChar): DWORD;
external kernel32dll name 'GetTempPathW';

function GetTempPath conv arg_stdcall (nBufferLength: DWORD; lpBuffer: PChar): DWORD;
 external kernel32dll name 'GetTempPathA';

function GetThreadContext conv arg_stdcall (hThread: THandle; var lpContext: TContext): BOOL;
 external kernel32dll name 'GetThreadContext';

function GetThreadLocale: LCID;
 external kernel32dll name 'GetThreadLocale';

function GetThreadPriority conv arg_stdcall (hThread: THandle): DWORD;
 external kernel32dll name 'GetThreadPriority';

function GetThreadPriorityBoost conv arg_stdcall (hThread: THandle; var DisablePriorityBoost: Bool): BOOL;
 external kernel32dll name 'GetThreadPriorityBoost';

function GetThreadSelectorEntry conv arg_stdcall (hThread: THandle; dwSelector: DWORD; var lpSelectorEntry: TLDTEntry): BOOL;
 external kernel32dll name 'GetThreadSelectorEntry';

function GetThreadTimes conv arg_stdcall (hThread: THandle; var lpCreationTime, lpExitTime, lpKernelTime, lpUserTime: TFileTime): BOOL;
 external kernel32dll name 'GetThreadTimes';

function GetTickCount: DWORD;
 external kernel32dll name 'GetTickCount';

function GetTimeFormatA conv arg_stdcall (Locale: LCID; dwFlags: DWORD; lpTime: PSystemTime;
 lpFormat: PAnsiChar; lpTimeStr: PAnsiChar; cchTime: DWORD): DWORD;
external kernel32dll name 'GetTimeFormatA';

function GetTimeFormatW conv arg_stdcall (Locale: LCID; dwFlags: DWORD; lpTime: PSystemTime;
 lpFormat: PWideChar; lpTimeStr: PWideChar; cchTime: DWORD): DWORD;
external kernel32dll name 'GetTimeFormatW';

function GetTimeFormat conv arg_stdcall (Locale: LCID; dwFlags: DWORD; lpTime: PSystemTime;
  lpFormat: PChar; lpTimeStr: PChar; cchTime: DWORD): DWORD;
 external kernel32dll name 'GetTimeFormatA';

function GetTimeZoneInformation conv arg_stdcall (var lpTimeZoneInformation: TTimeZoneInformation): DWORD;
 external kernel32dll name 'GetTimeZoneInformation';

function GetUserDefaultLCID: LCID;
 external kernel32dll name 'GetUserDefaultLCID';

function GetUserDefaultLangID: LANGID;
 external kernel32dll name 'GetUserDefaultLangID';

function GetVersion: DWORD;
 external kernel32dll name 'GetVersion';

function GetVersionExA conv arg_stdcall (var lpVersionInformation: TOSVersionInfo): BOOL;
 external kernel32dll name 'GetVersionExA';

function GetVersionExW conv arg_stdcall (var lpVersionInformation: TOSVersionInfo): BOOL;
 external kernel32dll name 'GetVersionExW';

function GetVersionEx conv arg_stdcall (var lpVersionInformation: TOSVersionInfo): BOOL;
 external kernel32dll name 'GetVersionExA';

function GetVolumeInformationA conv arg_stdcall (lpRootPathName: PAnsiChar; lpVolumeNameBuffer: PAnsiChar; nVolumeNameSize: DWORD; lpVolumeSerialNumber: PDWORD;
var lpMaximumComponentLength, lpFileSystemFlags: DWORD; lpFileSystemNameBuffer: PAnsiChar; nFileSystemNameSize: DWORD): BOOL;
external kernel32dll name 'GetVolumeInformationA';

function GetVolumeInformationW conv arg_stdcall (lpRootPathName: PWideChar; lpVolumeNameBuffer: PWideChar; nVolumeNameSize: DWORD; lpVolumeSerialNumber: PDWORD;
 var lpMaximumComponentLength, lpFileSystemFlags: DWORD; lpFileSystemNameBuffer: PWideChar; nFileSystemNameSize: DWORD): BOOL;
external kernel32dll name 'GetVolumeInformationW';

function GetVolumeInformation conv arg_stdcall (lpRootPathName: PChar; lpVolumeNameBuffer: PChar; nVolumeNameSize: DWORD; lpVolumeSerialNumber: PDWORD;
  var lpMaximumComponentLength, lpFileSystemFlags: DWORD; lpFileSystemNameBuffer: PChar; nFileSystemNameSize: DWORD): BOOL;
 external kernel32dll name 'GetVolumeInformationA';

function GetWindowsDirectoryA conv arg_stdcall (lpBuffer: PAnsiChar; uSize: DWORD): DWORD;
external kernel32dll name 'GetWindowsDirectoryA';

function GetWindowsDirectoryW conv arg_stdcall (lpBuffer: PWideChar; uSize: DWORD): DWORD;
external kernel32dll name 'GetWindowsDirectoryW';

function GetWindowsDirectory conv arg_stdcall (lpBuffer: PChar; uSize: DWORD): DWORD;
 external kernel32dll name 'GetWindowsDirectoryA';

function GlobalAddAtomA conv arg_stdcall (lpString: PAnsiChar): ATOM;
external kernel32dll name 'GlobalAddAtomA';

function GlobalAddAtomW conv arg_stdcall (lpString: PWideChar): ATOM;
external kernel32dll name 'GlobalAddAtomW';

function GlobalAddAtom conv arg_stdcall (lpString: PChar): ATOM;
 external kernel32dll name 'GlobalAddAtomA';

function GlobalAlloc conv arg_stdcall (uFlags: DWORD; dwBytes: DWORD): HGLOBAL;
 external kernel32dll name 'GlobalAlloc';

function GlobalCompact conv arg_stdcall (dwMinFree: DWORD): DWORD;
 external kernel32dll name 'GlobalCompact';

function GlobalDeleteAtom conv arg_stdcall (nAtom: ATOM): ATOM;
 external kernel32dll name 'GlobalDeleteAtom';

function GlobalFindAtomA conv arg_stdcall (lpString: PAnsiChar): ATOM;
external kernel32dll name 'GlobalFindAtomA';

function GlobalFindAtomW conv arg_stdcall (lpString: PWideChar): ATOM;
external kernel32dll name 'GlobalFindAtomW';

function GlobalFindAtom conv arg_stdcall (lpString: PChar): ATOM;
 external kernel32dll name 'GlobalFindAtomA';

procedure GlobalFix conv arg_stdcall (hMem: HGLOBAL);
 external kernel32dll name 'GlobalFix';

function GlobalFlags conv arg_stdcall (hMem: HGLOBAL): DWORD;
 external kernel32dll name 'GlobalFlags';

function GlobalFree conv arg_stdcall (hMem: HGLOBAL): HGLOBAL;
 external kernel32dll name 'GlobalFree';

function GlobalGetAtomNameA conv arg_stdcall (nAtom: ATOM; lpBuffer: PAnsiChar; nSize: DWORD): DWORD;
external kernel32dll name 'GlobalGetAtomNameA';

function GlobalGetAtomNameW conv arg_stdcall (nAtom: ATOM; lpBuffer: PWideChar; nSize: DWORD): DWORD;
external kernel32dll name 'GlobalGetAtomNameW';

function GlobalGetAtomName conv arg_stdcall (nAtom: ATOM; lpBuffer: PChar; nSize: DWORD): DWORD;
 external kernel32dll name 'GlobalGetAtomNameA';

function GlobalLock conv arg_stdcall (hMem: HGLOBAL): Pointer;
 external kernel32dll name 'GlobalLock';

function GlobalHandle conv arg_stdcall (Mem: Pointer): HGLOBAL;
 external kernel32dll name 'GlobalHandle';

procedure GlobalMemoryStatus conv arg_stdcall (var lpBuffer: TMemoryStatus);
 external kernel32dll name 'GlobalMemoryStatus';

function GlobalReAlloc conv arg_stdcall (hMem: HGLOBAL; dwBytes: DWORD; uFlags: DWORD): HGLOBAL;
 external kernel32dll name 'GlobalReAlloc';

function GlobalSize conv arg_stdcall (hMem: HGLOBAL): DWORD;
 external kernel32dll name 'GlobalSize';

function GlobalUnWire conv arg_stdcall (hMem: HGLOBAL): BOOL;
 external kernel32dll name 'GlobalUnWire';

procedure GlobalUnfix conv arg_stdcall (hMem: HGLOBAL);
 external kernel32dll name 'GlobalUnfix';

function GlobalUnlock conv arg_stdcall (hMem: HGLOBAL): BOOL;
 external kernel32dll name 'GlobalUnlock';

function GlobalWire conv arg_stdcall (hMem: HGLOBAL): Pointer;
 external kernel32dll name 'GlobalWire';

function HeapAlloc conv arg_stdcall (hHeap: THandle; dwFlags, dwBytes: DWORD): Pointer;
 external kernel32dll name 'HeapAlloc';

function HeapCompact conv arg_stdcall (hHeap: THandle; dwFlags: DWORD): DWORD;
 external kernel32dll name 'HeapCompact';

function HeapCreate conv arg_stdcall (flOptions, dwInitialSize, dwMaximumSize: DWORD): THandle;
 external kernel32dll name 'HeapCreate';

function HeapDestroy conv arg_stdcall (hHeap: THandle): BOOL;
 external kernel32dll name 'HeapDestroy';

function HeapFree conv arg_stdcall (hHeap: THandle; dwFlags: DWORD; lpMem: Pointer): BOOL;
 external kernel32dll name 'HeapFree';

function HeapLock conv arg_stdcall (hHeap: THandle): BOOL;
 external kernel32dll name 'HeapLock';

function HeapReAlloc conv arg_stdcall (hHeap: THandle; dwFlags: DWORD; lpMem: Pointer; dwBytes: DWORD): Pointer;
 external kernel32dll name 'HeapReAlloc';

function HeapSize conv arg_stdcall (hHeap: THandle; dwFlags: DWORD; lpMem: Pointer): DWORD;
 external kernel32dll name 'HeapSize';

function HeapUnlock conv arg_stdcall (hHeap: THandle): BOOL;
 external kernel32dll name 'HeapUnlock';

function HeapValidate conv arg_stdcall (hHeap: THandle; dwFlags: DWORD; lpMem: Pointer): BOOL;
 external kernel32dll name 'HeapValidate';

function HeapWalk conv arg_stdcall (hHeap: THandle; var lpEntry: TProcessHeapEntry): BOOL;
 external kernel32dll name 'HeapWalk';

function InitAtomTable conv arg_stdcall (nSize: DWORD): BOOL;
 external kernel32dll name 'InitAtomTable';

procedure InitializeCriticalSection conv arg_stdcall (var lpCriticalSection: TRTLCriticalSection);
 external kernel32dll name 'InitializeCriticalSection';

function IsBadCodePtr conv arg_stdcall (lpfn: FARPROC): BOOL;
 external kernel32dll name 'IsBadCodePtr';

function IsBadHugeReadPtr conv arg_stdcall (lp: Pointer; ucb: DWORD): BOOL;
 external kernel32dll name 'IsBadHugeReadPtr';

function IsBadHugeWritePtr conv arg_stdcall (lp: Pointer; ucb: DWORD): BOOL;
 external kernel32dll name 'IsBadHugeWritePtr';

function IsBadReadPtr conv arg_stdcall (lp: Pointer; ucb: DWORD): BOOL;
 external kernel32dll name 'IsBadReadPtr';

function IsBadStringPtrA conv arg_stdcall (lpsz: PAnsiChar; ucchMax: DWORD): BOOL;
external kernel32dll name 'IsBadStringPtrA';

function IsBadStringPtrW conv arg_stdcall (lpsz: PWideChar; ucchMax: DWORD): BOOL;
external kernel32dll name 'IsBadStringPtrW';

function IsBadStringPtr conv arg_stdcall (lpsz: PChar; ucchMax: DWORD): BOOL;
 external kernel32dll name 'IsBadStringPtrA';

function IsBadWritePtr conv arg_stdcall (lp: Pointer; ucb: DWORD): BOOL;
 external kernel32dll name 'IsBadWritePtr';

function IsDBCSLeadByte conv arg_stdcall (TestChar: Byte): BOOL;
 external kernel32dll name 'IsDBCSLeadByte';

function IsDBCSLeadByteEx conv arg_stdcall (CodePage: DWORD; TestChar: Byte): BOOL;
 external kernel32dll name 'IsDBCSLeadByteEx';

function IsProcessorFeaturePresent conv arg_stdcall (ProcessorFeature: DWORD): BOOL;
 external kernel32dll name 'IsProcessorFeaturePresent';

function IsValidCodePage conv arg_stdcall (CodePage: DWORD): BOOL;
 external kernel32dll name 'IsValidCodePage';

function IsValidLocale conv arg_stdcall (Locale: LCID; dwFlags: DWORD): BOOL;
 external kernel32dll name 'IsValidLocale';

function LCMapStringA conv arg_stdcall (Locale: LCID; dwMapFlags: DWORD; lpSrcStr: PAnsiChar;
cchSrc: DWORD; lpDestStr: PAnsiChar; cchDest: DWORD): DWORD;
external kernel32dll name 'LCMapStringA';

function LCMapStringW conv arg_stdcall (Locale: LCID; dwMapFlags: DWORD; lpSrcStr: PWideChar;
cchSrc: DWORD; lpDestStr: PWideChar; cchDest: DWORD): DWORD;
external kernel32dll name 'LCMapStringW';

function LCMapString conv arg_stdcall (Locale: LCID; dwMapFlags: DWORD; lpSrcStr: PChar;
 cchSrc: DWORD; lpDestStr: PChar; cchDest: DWORD): DWORD;
 external kernel32dll name 'LCMapStringA';

procedure LeaveCriticalSection conv arg_stdcall (var lpCriticalSection: TRTLCriticalSection);
 external kernel32dll name 'LeaveCriticalSection';

function LoadLibraryA conv arg_stdcall (lpLibFileName: PAnsiChar): HMODULE;
external kernel32dll name 'LoadLibraryA';

function LoadLibraryW conv arg_stdcall (lpLibFileName: PWideChar): HMODULE;
external kernel32dll name 'LoadLibraryW';

function LoadLibrary conv arg_stdcall (lpLibFileName: PChar): HMODULE;
 external kernel32dll name 'LoadLibraryA';

function LoadLibraryExA conv arg_stdcall (lpLibFileName: PAnsiChar; hFile: THandle; dwFlags: DWORD): HMODULE;
external kernel32dll name 'LoadLibraryExA';

function LoadLibraryExW conv arg_stdcall (lpLibFileName: PWideChar; hFile: THandle; dwFlags: DWORD): HMODULE;
external kernel32dll name 'LoadLibraryExW';

function LoadLibraryEx conv arg_stdcall (lpLibFileName: PChar; hFile: THandle; dwFlags: DWORD): HMODULE;
 external kernel32dll name 'LoadLibraryExA';

function LoadModule conv arg_stdcall (lpModuleName: LPCSTR; lpParameterBlock: Pointer): DWORD;
 external kernel32dll name 'LoadModule';

function LoadResource conv arg_stdcall (hModule: HINST; hResInfo: HRSRC): HGLOBAL;
 external kernel32dll name 'LoadResource';

function LocalAlloc conv arg_stdcall (uFlags, uBytes: DWORD): HLOCAL;
 external kernel32dll name 'LocalAlloc';

function LocalCompact conv arg_stdcall (uMinFree: DWORD): DWORD;
 external kernel32dll name 'LocalCompact';

function LocalFileTimeToFileTime conv arg_stdcall (const lpLocalFileTime: TFileTime; var lpFileTime: TFileTime): BOOL;
 external kernel32dll name 'LocalFileTimeToFileTime';

function LocalFlags conv arg_stdcall (hMem: HLOCAL): DWORD;
 external kernel32dll name 'LocalFlags';

function LocalFree conv arg_stdcall (hMem: HLOCAL): HLOCAL;
 external kernel32dll name 'LocalFree';

function LocalLock conv arg_stdcall (hMem: HLOCAL): Pointer;
 external kernel32dll name 'LocalLock';

function LocalReAlloc conv arg_stdcall (hMem: HLOCAL; uBytes, uFlags: DWORD): HLOCAL;
 external kernel32dll name 'LocalReAlloc';

function LocalShrink conv arg_stdcall (hMem: HLOCAL; cbNewSize: DWORD): DWORD;
 external kernel32dll name 'LocalShrink';

function LocalSize conv arg_stdcall (hMem: HLOCAL): DWORD;
 external kernel32dll name 'LocalSize';

function LocalUnlock conv arg_stdcall (hMem: HLOCAL): BOOL;
 external kernel32dll name 'LocalUnlock';

function LockFile conv arg_stdcall (hFile: THandle; dwFileOffsetLow, dwFileOffsetHigh: DWORD; nNumberOfBytesToLockLow, nNumberOfBytesToLockHigh: DWORD): BOOL;
 external kernel32dll name 'LockFile';

function LockFileEx conv arg_stdcall (hFile: THandle; dwFlags, dwReserved: DWORD; nNumberOfBytesToLockLow, nNumberOfBytesToLockHigh: DWORD;
 const lpOverlapped: TOverlapped): BOOL;
 external kernel32dll name 'LockFileEx';

function LockResource conv arg_stdcall (hResData: HGLOBAL): Pointer;
 external kernel32dll name 'LockResource';

function MapViewOfFile conv arg_stdcall (hFileMappingObject: THandle; dwDesiredAccess: DWORD;
 dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap: DWORD): Pointer;
 external kernel32dll name 'MapViewOfFile';

function MapViewOfFileEx conv arg_stdcall (hFileMappingObject: THandle; dwDesiredAccess, dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap: DWORD;
 lpBaseAddress: Pointer): Pointer;
 external kernel32dll name 'MapViewOfFileEx';

function MoveFileA conv arg_stdcall (lpExistingFileName, lpNewFileName: PAnsiChar): BOOL;
external kernel32dll name 'MoveFileA';

function MoveFileW conv arg_stdcall (lpExistingFileName, lpNewFileName: PWideChar): BOOL;
external kernel32dll name 'MoveFileW';

function MoveFile conv arg_stdcall (lpExistingFileName, lpNewFileName: PChar): BOOL;
 external kernel32dll name 'MoveFileA';

function MoveFileExA conv arg_stdcall (lpExistingFileName, lpNewFileName: PAnsiChar; dwFlags: DWORD): BOOL;
external kernel32dll name 'MoveFileExA';

function MoveFileExW conv arg_stdcall (lpExistingFileName, lpNewFileName: PWideChar; dwFlags: DWORD): BOOL;
external kernel32dll name 'MoveFileExW';

function MoveFileEx conv arg_stdcall (lpExistingFileName, lpNewFileName: PChar; dwFlags: DWORD): BOOL;
external kernel32dll name 'MoveFileExA';

function MulDiv conv arg_stdcall (nNumber, nNumerator, nDenominator: DWORD): DWORD;
external kernel32dll name 'MulDiv';

function MultiByteToWideChar conv arg_stdcall (CodePage: UINT; dwFlags: DWORD;
lpMultiByteStr: LPCSTR; cchMultiByte: Longint; lpWideCharStr: LPWSTR; cchWideChar: Longint): Longint;
external kernel32dll name 'MultiByteToWideChar';

function OpenEventA conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PAnsiChar): THandle;
external kernel32dll name 'OpenEventA';

function OpenEventW conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PWideChar): THandle;
external kernel32dll name 'OpenEventW';

function OpenEvent conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PChar): THandle;
 external kernel32dll name 'OpenEventA';

function OpenFile conv arg_stdcall (const lpFileName: LPCSTR; var lpReOpenBuff: TOFStruct; uStyle: DWORD): HFILE;
 external kernel32dll name 'OpenFile';

function OpenFileMappingA conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PAnsiChar): THandle;
external kernel32dll name 'OpenFileMappingA';

function OpenFileMappingW conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PWideChar): THandle;
external kernel32dll name 'OpenFileMappingW';

function OpenFileMapping conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PChar): THandle;
 external kernel32dll name 'OpenFileMappingA';

function OpenMutexA conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PAnsiChar): THandle;
external kernel32dll name 'OpenMutexA';

function OpenMutexW conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PWideChar): THandle;
external kernel32dll name 'OpenMutexW';

function OpenMutex conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PChar): THandle;
 external kernel32dll name 'OpenMutexA';

function OpenProcess conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; dwProcessId: DWORD): THandle;
 external kernel32dll name 'OpenProcess';

function OpenSemaphoreA conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PAnsiChar): THandle;
external kernel32dll name 'OpenSemaphoreA';

function OpenSemaphoreW conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PWideChar): THandle;
external kernel32dll name 'OpenSemaphoreW';

function OpenSemaphore conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PChar): THandle;
 external kernel32dll name 'OpenSemaphoreA';

function OpenWaitableTimerA conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpTimerName: PAnsiChar): BOOL;
external kernel32dll name 'OpenWaitableTimerA';

function OpenWaitableTimerW conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpTimerName: PWideChar): BOOL;
 external kernel32dll name 'OpenWaitableTimerW';

function OpenWaitableTimer conv arg_stdcall (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpTimerName: PChar): BOOL;
 external kernel32dll name 'OpenWaitableTimerA';

procedure OutputDebugStringA conv arg_stdcall (lpOutputString: PAnsiChar);
external kernel32dll name 'OutputDebugStringA';

procedure OutputDebugStringW conv arg_stdcall (lpOutputString: PWideChar);
external kernel32dll name 'OutputDebugStringW';

procedure OutputDebugString conv arg_stdcall (lpOutputString: PChar);
 external kernel32dll name 'OutputDebugStringA';

function PeekConsoleInputA conv arg_stdcall (hConsoleInput: THandle; var lpBuffer: TInputRecord;
 nLength: DWORD; var lpNumberOfEventsRead: DWORD): BOOL;
 external kernel32dll name 'PeekConsoleInputA';

function PeekConsoleInputW conv arg_stdcall (hConsoleInput: THandle; var lpBuffer: TInputRecord;
 nLength: DWORD; var lpNumberOfEventsRead: DWORD): BOOL;
 external kernel32dll name 'PeekConsoleInputW';

function PeekConsoleInput conv arg_stdcall (hConsoleInput: THandle; var lpBuffer: TInputRecord;
 nLength: DWORD; var lpNumberOfEventsRead: DWORD): BOOL;
 external kernel32dll name 'PeekConsoleInputA';

function PeekNamedPipe conv arg_stdcall (hNamedPipe: THandle; lpBuffer: Pointer; nBufferSize: DWORD;
 lpBytesRead, lpTotalBytesAvail, lpBytesLeftThisMessage: Pointer): BOOL;
 external kernel32dll name 'PeekNamedPipe';

function PostQueuedCompletionStatus conv arg_stdcall (CompletionPort: THandle; dwNumberOfBytesTransferred: DWORD;
 dwCompletionKey: DWORD; lpOverlapped: POverlapped): BOOL;
 external kernel32dll name 'PostQueuedCompletionStatus';

function PrepareTape conv arg_stdcall (hDevice: THandle; dwOperation: DWORD; bImmediate: BOOL): DWORD;
 external kernel32dll name 'PrepareTape';

function PulseEvent conv arg_stdcall (hEvent: THandle): BOOL;
 external kernel32dll name 'PulseEvent';

function PurgeComm conv arg_stdcall (hFile: THandle; dwFlags: DWORD): BOOL;
 external kernel32dll name 'PurgeComm';

function QueryDosDeviceA conv arg_stdcall (lpDeviceName: PAnsiChar; lpTargetPath: PAnsiChar; ucchMax: DWORD): DWORD;
external kernel32dll name 'QueryDosDeviceA';

function QueryDosDeviceW conv arg_stdcall (lpDeviceName: PWideChar; lpTargetPath: PWideChar; ucchMax: DWORD): DWORD;
external kernel32dll name 'QueryDosDeviceW';

function QueryDosDevice conv arg_stdcall (lpDeviceName: PChar; lpTargetPath: PChar; ucchMax: DWORD): DWORD;
 external kernel32dll name 'QueryDosDeviceA';

function QueryPerformanceCounter conv arg_stdcall (var lpPerformanceCount: TLargeInteger): BOOL;
 external kernel32dll name 'QueryPerformanceCounter';

function QueryPerformanceFrequency conv arg_stdcall (var lpFrequency: TLargeInteger): BOOL;
 external kernel32dll name 'QueryPerformanceFrequency';

function QueueUserAPC conv arg_stdcall (pfnAPC: TFNAPCProc; hThread: THandle; dwData: DWORD): BOOL;
 external kernel32dll name 'QueueUserAPC';

procedure RaiseException conv arg_stdcall (dwExceptionCode, dwExceptionFlags, nNumberOfArguments: DWORD;
 lpArguments: PDWORD);
 external kernel32dll name 'RaiseException';

function ReadConsoleA conv arg_stdcall (hConsoleInput: THandle; lpBuffer: Pointer;
 nNumberOfCharsToRead: DWORD; var lpNumberOfCharsRead: DWORD; lpReserved: Pointer): BOOL;
 external kernel32dll name 'ReadConsoleA';

function ReadConsoleW conv arg_stdcall (hConsoleInput: THandle; lpBuffer: Pointer;
 nNumberOfCharsToRead: DWORD; var lpNumberOfCharsRead: DWORD; lpReserved: Pointer): BOOL;
 external kernel32dll name 'ReadConsoleW';

function ReadConsole conv arg_stdcall (hConsoleInput: THandle; lpBuffer: Pointer;
 nNumberOfCharsToRead: DWORD; var lpNumberOfCharsRead: DWORD; lpReserved: Pointer): BOOL;
 external kernel32dll name 'ReadConsoleA';

function ReadConsoleInputA conv arg_stdcall (hConsoleInput: THandle; var lpBuffer: TInputRecord;
 nLength: DWORD; var lpNumberOfEventsRead: DWORD): BOOL;
 external kernel32dll name 'ReadConsoleInputA';

function ReadConsoleInputW conv arg_stdcall (hConsoleInput: THandle; var lpBuffer: TInputRecord;
 nLength: DWORD; var lpNumberOfEventsRead: DWORD): BOOL;
 external kernel32dll name 'ReadConsoleInputW';

function ReadConsoleInput conv arg_stdcall (hConsoleInput: THandle; var lpBuffer: TInputRecord;
 nLength: DWORD; var lpNumberOfEventsRead: DWORD): BOOL;
 external kernel32dll name 'ReadConsoleInputA';

function ReadConsoleOutputA conv arg_stdcall (hConsoleOutput: THandle; lpBuffer: Pointer;
 dwBufferSize, dwBufferCoord: TCoord; var lpReadRegion: TSmallRect): BOOL;
 external kernel32dll name 'ReadConsoleOutputA';

function ReadConsoleOutputW conv arg_stdcall (hConsoleOutput: THandle; lpBuffer: Pointer;
 dwBufferSize, dwBufferCoord: TCoord; var lpReadRegion: TSmallRect): BOOL;
 external kernel32dll name 'ReadConsoleOutputW';

function ReadConsoleOutput conv arg_stdcall (hConsoleOutput: THandle; lpBuffer: Pointer;
 dwBufferSize, dwBufferCoord: TCoord; var lpReadRegion: TSmallRect): BOOL;
 external kernel32dll name 'ReadConsoleOutputA';

function ReadConsoleOutputAttribute conv arg_stdcall (hConsoleOutput: THandle; lpAttribute: Pointer;
 nLength: DWORD; dwReadCoord: TCoord; var lpNumberOfAttrsRead: DWORD): BOOL;
 external kernel32dll name 'ReadConsoleOutputAttribute';

function ReadConsoleOutputCharacterA conv arg_stdcall (hConsoleOutput: THandle;lpCharacter: PAnsiChar;
nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfCharsWritten: DWORD): BOOL;
external kernel32dll name 'ReadConsoleOutputCharacterA';

function ReadConsoleOutputCharacterW conv arg_stdcall (hConsoleOutput: THandle;lpCharacter: PWideChar;
 nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfCharsWritten: DWORD): BOOL;
external kernel32dll name 'ReadConsoleOutputCharacterW';

function ReadConsoleOutputCharacter conv arg_stdcall (hConsoleOutput: THandle;lpCharacter: PChar;
 nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfCharsWritten: DWORD): BOOL;
 external kernel32dll name 'ReadConsoleOutputCharacterA';

function ReadFile conv arg_stdcall (hFile: THandle; var Buffer; nNumberOfBytesToRead: DWORD;
 var lpNumberOfBytesRead: DWORD; lpOverlapped: POverlapped): BOOL;
 external kernel32dll name 'ReadFile';

function ReadFileEx conv arg_stdcall (hFile: THandle; lpBuffer: Pointer; nNumberOfBytesToRead: DWORD;
 lpOverlapped: POverlapped; lpCompletionRoutine: TPROverlappedCompletionRoutine): BOOL;
 external kernel32dll name 'ReadFileEx';

function ReadProcessMemory conv arg_stdcall (hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
 nSize: DWORD; var lpNumberOfBytesRead: DWORD): BOOL;
 external kernel32dll name 'ReadProcessMemory';

function ReleaseMutex conv arg_stdcall (hMutex: THandle): BOOL;
 external kernel32dll name 'ReleaseMutex';

function ReleaseSemaphore conv arg_stdcall (hSemaphore: THandle; lReleaseCount: Longint; lpPreviousCount: Pointer): BOOL;
 external kernel32dll name 'ReleaseSemaphore';

function RemoveDirectoryA conv arg_stdcall (lpPathName: PAnsiChar): BOOL;
external kernel32dll name 'RemoveDirectoryA';

function RemoveDirectoryW conv arg_stdcall (lpPathName: PWideChar): BOOL;
external kernel32dll name 'RemoveDirectoryW';

function RemoveDirectory conv arg_stdcall (lpPathName: PChar): BOOL;
 external kernel32dll name 'RemoveDirectoryA';

function ResetEvent conv arg_stdcall (hEvent: THandle): BOOL;
 external kernel32dll name 'ResetEvent';

function ResumeThread conv arg_stdcall (hThread: THandle): DWORD;
 external kernel32dll name 'ResumeThread';

function ScrollConsoleScreenBufferA conv arg_stdcall (hConsoleOutput: THandle; const lpScrollRectangle: TSmallRect; lpClipRectangle: TSmallRect;
 dwDestinationOrigin: TCoord; var lpFill: TCharInfo): BOOL;
 external kernel32dll name 'ScrollConsoleScreenBufferA';

function ScrollConsoleScreenBufferW conv arg_stdcall (hConsoleOutput: THandle; const lpScrollRectangle: TSmallRect; lpClipRectangle: TSmallRect;
 dwDestinationOrigin: TCoord; var lpFill: TCharInfo): BOOL;
 external kernel32dll name 'ScrollConsoleScreenBufferW';

function ScrollConsoleScreenBuffer conv arg_stdcall (hConsoleOutput: THandle; const lpScrollRectangle: TSmallRect; lpClipRectangle: TSmallRect;
 dwDestinationOrigin: TCoord; var lpFill: TCharInfo): BOOL;
 external kernel32dll name 'ScrollConsoleScreenBufferA';

function SearchPathA conv arg_stdcall (lpPath, lpFileName, lpExtension: PAnsiChar;
 nBufferLength: DWORD; lpBuffer: PAnsiChar; var lpFilePart: PAnsiChar): DWORD;
 external kernel32dll name 'SearchPathA';

function SearchPathW conv arg_stdcall (lpPath, lpFileName, lpExtension: PWideChar;
 nBufferLength: DWORD; lpBuffer: PWideChar; var lpFilePart: PWideChar): DWORD;
 external kernel32dll name 'SearchPathW';

function SearchPath conv arg_stdcall (lpPath, lpFileName, lpExtension: PChar;
 nBufferLength: DWORD; lpBuffer: PChar; var lpFilePart: PChar): DWORD;
 external kernel32dll name 'SearchPathA';

function SetCommBreak conv arg_stdcall (hFile: THandle): BOOL;
 external kernel32dll name 'SetCommBreak';

function SetCommConfig conv arg_stdcall (hCommDev: THandle; const lpCC: TCommConfig; dwSize: DWORD): BOOL;
 external kernel32dll name 'SetCommConfig';

function SetCommMask conv arg_stdcall (hFile: THandle; dwEvtMask: DWORD): BOOL;
 external kernel32dll name 'SetCommMask';

function SetCommState conv arg_stdcall (hFile: THandle; const lpDCB: TDCB): BOOL;
 external kernel32dll name 'SetCommState';

function SetCommTimeouts conv arg_stdcall (hFile: THandle; const lpCommTimeouts: TCommTimeouts): BOOL;
 external kernel32dll name 'SetCommTimeouts';

function SetComputerNameA conv arg_stdcall (lpComputerName: PAnsiChar): BOOL;
external kernel32dll name 'SetComputerNameA';

function SetComputerNameW conv arg_stdcall (lpComputerName: PWideChar): BOOL;
external kernel32dll name 'SetComputerNameW';

function SetComputerName conv arg_stdcall (lpComputerName: PChar): BOOL;
 external kernel32dll name 'SetComputerNameA';

function SetConsoleActiveScreenBuffer conv arg_stdcall (hConsoleOutput: THandle): BOOL;
 external kernel32dll name 'SetConsoleActiveScreenBuffer';

function SetConsoleCP conv arg_stdcall (wCodePageID: DWORD): BOOL;
 external kernel32dll name 'SetConsoleCP';

function SetConsoleCtrlHandler conv arg_stdcall (HandlerRoutine: TFNHandlerRoutine; Add: BOOL): BOOL;
 external kernel32dll name 'SetConsoleCtrlHandler';

function SetConsoleCursorInfo conv arg_stdcall (hConsoleOutput: THandle; const lpConsoleCursorInfo: TConsoleCursorInfo): BOOL;
 external kernel32dll name 'SetConsoleCursorInfo';

function SetConsoleCursorPosition conv arg_stdcall (hConsoleOutput: THandle; dwCursorPosition: TCoord): BOOL;
 external kernel32dll name 'SetConsoleCursorPosition';

function SetConsoleMode conv arg_stdcall (hConsoleHandle: THandle; dwMode: DWORD): BOOL;
 external kernel32dll name 'SetConsoleMode';

function SetConsoleOutputCP conv arg_stdcall (wCodePageID: DWORD): BOOL;
 external kernel32dll name 'SetConsoleOutputCP';

function SetConsoleScreenBufferSize conv arg_stdcall (hConsoleOutput: THandle; dwSize: TCoord): BOOL;
 external kernel32dll name 'SetConsoleScreenBufferSize';

function SetConsoleTextAttribute conv arg_stdcall (hConsoleOutput: THandle; wAttributes: Word): BOOL;
 external kernel32dll name 'SetConsoleTextAttribute';

function SetConsoleTitleA conv arg_stdcall (lpConsoleTitle: PAnsiChar): BOOL;
external kernel32dll name 'SetConsoleTitleA';

function SetConsoleTitleW conv arg_stdcall (lpConsoleTitle: PWideChar): BOOL;
external kernel32dll name 'SetConsoleTitleW';

function SetConsoleTitle conv arg_stdcall (lpConsoleTitle: PChar): BOOL;
 external kernel32dll name 'SetConsoleTitleA';

function SetConsoleWindowInfo conv arg_stdcall (hConsoleOutput: THandle; bAbsolute: BOOL;
 const lpConsoleWindow: TSmallRect): BOOL;
 external kernel32dll name 'SetConsoleWindowInfo';

function SetCurrentDirectoryA conv arg_stdcall (lpPathName: PAnsiChar): BOOL;
external kernel32dll name 'SetCurrentDirectoryA';

function SetCurrentDirectoryW conv arg_stdcall (lpPathName: PWideChar): BOOL;
external kernel32dll name 'SetCurrentDirectoryW';

function SetCurrentDirectory conv arg_stdcall (lpPathName: PChar): BOOL;
 external kernel32dll name 'SetCurrentDirectoryA';

function SetDefaultCommConfigA conv arg_stdcall (lpszName: PAnsiChar; lpCC: PCommConfig; dwSize: DWORD): BOOL;
external kernel32dll name 'SetDefaultCommConfigA';

function SetDefaultCommConfigW conv arg_stdcall (lpszName: PWideChar; lpCC: PCommConfig; dwSize: DWORD): BOOL;
external kernel32dll name 'SetDefaultCommConfigW';

function SetDefaultCommConfig conv arg_stdcall (lpszName: PChar; lpCC: PCommConfig; dwSize: DWORD): BOOL;
 external kernel32dll name 'SetDefaultCommConfigA';

function SetEndOfFile conv arg_stdcall (hFile: THandle): BOOL;
 external kernel32dll name 'SetEndOfFile';

function SetEnvironmentVariableA conv arg_stdcall (lpName, lpValue: PAnsiChar): BOOL;
external kernel32dll name 'SetEnvironmentVariableA';

function SetEnvironmentVariableW conv arg_stdcall (lpName, lpValue: PWideChar): BOOL;
external kernel32dll name 'SetEnvironmentVariableW';

function SetEnvironmentVariable conv arg_stdcall (lpName, lpValue: PChar): BOOL;
 external kernel32dll name 'SetEnvironmentVariableA';

function SetErrorMode conv arg_stdcall (uMode: DWORD): DWORD;
 external kernel32dll name 'SetErrorMode';

function SetEvent conv arg_stdcall (hEvent: THandle): BOOL;
 external kernel32dll name 'SetEvent';

procedure SetFileApisToANSI;
 external kernel32dll name 'SetFileApisToANSI';

procedure SetFileApisToOEM;
 external kernel32dll name 'SetFileApisToOEM';

function SetFileAttributesA conv arg_stdcall (lpFileName: PAnsiChar; dwFileAttributes: DWORD): BOOL;
external kernel32dll name 'SetFileAttributesA';

function SetFileAttributesW conv arg_stdcall (lpFileName: PWideChar; dwFileAttributes: DWORD): BOOL;
external kernel32dll name 'SetFileAttributesW';

function SetFileAttributes conv arg_stdcall (lpFileName: PChar; dwFileAttributes: DWORD): BOOL;
 external kernel32dll name 'SetFileAttributesA';

function SetFilePointer conv arg_stdcall (hFile: THandle; lDistanceToMove: Longint; lpDistanceToMoveHigh: Pointer; dwMoveMethod: DWORD): DWORD;
 external kernel32dll name 'SetFilePointer';

function SetFileTime conv arg_stdcall (hFile: THandle; lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL;
 external kernel32dll name 'SetFileTime';

function SetHandleCount conv arg_stdcall (uNumber: DWORD): DWORD;
 external kernel32dll name 'SetHandleCount';

function SetHandleInformation conv arg_stdcall (hObject: THandle; dwMask: DWORD; dwFlags: DWORD): BOOL;
 external kernel32dll name 'SetHandleInformation';

procedure SetLastError conv arg_stdcall (dwErrCode: DWORD);
 external kernel32dll name 'SetLastError';

function SetLocalTime conv arg_stdcall (const lpSystemTime: TSystemTime): BOOL;
 external kernel32dll name 'SetLocalTime';

function SetLocaleInfoA conv arg_stdcall (Locale: LCID; LCType: LCTYPE; lpLCData: PAnsiChar): BOOL;
external kernel32dll name 'SetLocaleInfoA';

function SetLocaleInfoW conv arg_stdcall (Locale: LCID; LCType: LCTYPE; lpLCData: PWideChar): BOOL;
external kernel32dll name 'SetLocaleInfoW';

function SetLocaleInfo conv arg_stdcall (Locale: LCID; LCType: LCTYPE; lpLCData: PChar): BOOL;
 external kernel32dll name 'SetLocaleInfoA';

function SetMailslotInfo conv arg_stdcall (hMailslot: THandle; lReadTimeout: DWORD): BOOL;
 external kernel32dll name 'SetMailslotInfo';

function SetNamedPipeHandleState conv arg_stdcall (hNamedPipe: THandle; var lpMode: DWORD;
 lpMaxCollectionCount, lpCollectDataTimeout: Pointer): BOOL;
 external kernel32dll name 'SetNamedPipeHandleState';

function SetPriorityClass conv arg_stdcall (hProcess: THandle; dwPriorityClass: DWORD): BOOL;
 external kernel32dll name 'SetPriorityClass';

function SetProcessAffinityMask conv arg_stdcall (hProcess: THandle; dwProcessAffinityMask: DWORD): BOOL;
 external kernel32dll name 'GetProcessAffinityMask';

function SetProcessPriorityBoost conv arg_stdcall (hThread: THandle; DisablePriorityBoost: Bool): BOOL;
 external kernel32dll name 'SetProcessPriorityBoost';

function SetProcessShutdownParameters conv arg_stdcall (dwLevel, dwFlags: DWORD): BOOL;
 external kernel32dll name 'SetProcessShutdownParameters';

function SetProcessWorkingSetSize conv arg_stdcall (hProcess: THandle; dwMinimumWorkingSetSize, dwMaximumWorkingSetSize: DWORD): BOOL;
 external kernel32dll name 'SetProcessWorkingSetSize';

function SetStdHandle conv arg_stdcall (nStdHandle: DWORD; hHandle: THandle): BOOL;
 external kernel32dll name 'SetStdHandle';

function SetSystemPowerState conv arg_stdcall (fSuspend, fForce: BOOL): BOOL;
 external kernel32dll name 'SetSystemPowerState';

function SetSystemTime conv arg_stdcall (const lpSystemTime: TSystemTime): BOOL;
 external kernel32dll name 'SetSystemTime';

function SetSystemTimeAdjustment conv arg_stdcall (dwTimeAdjustment: DWORD; bTimeAdjustmentDisabled: BOOL): BOOL;
 external kernel32dll name 'SetSystemTimeAdjustment';

function SetTapeParameters conv arg_stdcall (hDevice: THandle; dwOperation: DWORD; lpTapeInformation: Pointer): DWORD;
 external kernel32dll name 'SetTapeParameters';

function SetTapePosition conv arg_stdcall (hDevice: THandle; dwPositionMethod, dwPartition: DWORD;
 dwOffsetLow, dwOffsetHigh: DWORD; bImmediate: BOOL): DWORD;
 external kernel32dll name 'SetTapePosition';

function SetThreadAffinityMask conv arg_stdcall (hThread: THandle; dwThreadAffinityMask: DWORD): DWORD;
 external kernel32dll name 'SetThreadAffinityMask';

function SetThreadContext conv arg_stdcall (hThread: THandle; const lpContext: TContext): BOOL;
 external kernel32dll name 'SetThreadContext';

function SetThreadIdealProcessor conv arg_stdcall (hThread: THandle; dwIdealProcessor: DWORD): BOOL;
 external kernel32dll name 'SetThreadIdealProceesor';

function SetThreadLocale conv arg_stdcall (Locale: LCID): BOOL;
 external kernel32dll name 'SetThreadLocale';

function SetThreadPriority conv arg_stdcall (hThread: THandle; nPriority: DWORD): BOOL;
 external kernel32dll name 'SetThreadPriority';

function SetThreadPriorityBoost conv arg_stdcall (hThread: THandle; DisablePriorityBoost: Bool): BOOL;
 external kernel32dll name 'SetThreadPriorityBoost';

function SetTimeZoneInformation conv arg_stdcall (const lpTimeZoneInformation: TTimeZoneInformation): BOOL;
 external kernel32dll name 'SetTimeZoneInformation';

function SetUnhandledExceptionFilter conv arg_stdcall (lpTopLevelExceptionFilter: TFNTopLevelExceptionFilter): TFNTopLevelExceptionFilter;
 external kernel32dll name 'SetUnhandledExceptionFilter';

function SetVolumeLabelA conv arg_stdcall (lpRootPathName: PAnsiChar; lpVolumeName: PAnsiChar): BOOL;
external kernel32dll name 'SetVolumeLabelA';

function SetVolumeLabelW conv arg_stdcall (lpRootPathName: PWideChar; lpVolumeName: PAnsiChar): BOOL;
external kernel32dll name 'SetVolumeLabelW';

function SetVolumeLabel conv arg_stdcall (lpRootPathName: PChar; lpVolumeName: PChar): BOOL;
 external kernel32dll name 'SetVolumeLabelA';

function SetWaitableTimer conv arg_stdcall (hTimer: THandle; const lpDueTime: TLargeInteger; lPeriod: Longint; pfnCompletionRoutine: TFNTimerAPCRoutine;
 lpArgToCompletionRoutine: Pointer; fResume: BOOL): BOOL;
 external kernel32dll name 'SetWaitableTimer';

function SetupComm conv arg_stdcall (hFile: THandle; dwInQueue, dwOutQueue: DWORD): BOOL;
 external kernel32dll name 'SetupComm';

function SignalObjectAndWait conv arg_stdcall (hObjectToSignal: THandle; hObjectToWaitOn: THandle;
 dwMilliseconds: DWORD; bAlertable: BOOL): BOOL;
 external kernel32dll name 'SignalObjectAndWait';

function SizeofResource conv arg_stdcall (hModule: HINST; hResInfo: HRSRC): DWORD;
 external kernel32dll name 'SizeofResource';

procedure Sleep conv arg_stdcall (dwMilliseconds: DWORD);
 external kernel32dll name 'Sleep';

function SleepEx conv arg_stdcall (dwMilliseconds: DWORD; bAlertable: BOOL): DWORD;
 external kernel32dll name 'SleepEx';

function SuspendThread conv arg_stdcall (hThread: THandle): DWORD;
 external kernel32dll name 'SuspendThread';

function SwitchToFiber conv arg_stdcall (lpFiber: Pointer): BOOL;
 external kernel32dll name 'SwitchToFiber';

function SwitchToThread: BOOL;
 external kernel32dll name 'SwitchToThread';

function SystemTimeToFileTime conv arg_stdcall (const lpSystemTime: TSystemTime; var lpFileTime: TFileTime): BOOL;
 external kernel32dll name 'SystemTimeToFileTime';

function SystemTimeToTzSpecificLocalTime conv arg_stdcall (lpTimeZoneInformation: PTimeZoneInformation;  var lpUniversalTime, lpLocalTime: TSystemTime): BOOL;
 external kernel32dll name 'SystemTimeToTzSpecificLocalTime';

function TerminateProcess conv arg_stdcall (hProcess: THandle; uExitCode: DWORD): BOOL;
 external kernel32dll name 'TerminateProcess';

function TerminateThread conv arg_stdcall (hThread: THandle; dwExitCode: DWORD): BOOL;
 external kernel32dll name 'TerminateThread';

function TlsAlloc: DWORD;
 external kernel32dll name 'TlsAlloc';

function TlsFree conv arg_stdcall (dwTlsIndex: DWORD): BOOL;
 external kernel32dll name 'TlsFree';

function TlsGetValue conv arg_stdcall (dwTlsIndex: DWORD): Pointer;
 external kernel32dll name 'TlsGetValue';

function TlsSetValue conv arg_stdcall (dwTlsIndex: DWORD; lpTlsValue: Pointer): BOOL;
 external kernel32dll name 'TlsSetValue';

function TransactNamedPipe conv arg_stdcall (hNamedPipe: THandle; lpInBuffer: Pointer; nInBufferSize: DWORD;
 lpOutBuffer: Pointer; nOutBufferSize: DWORD; var lpBytesRead: DWORD; lpOverlapped: POverlapped): BOOL;
 external kernel32dll name 'TransactNamedPipe';

function TransmitCommChar conv arg_stdcall (hFile: THandle; cChar: CHAR): BOOL;
 external kernel32dll name 'TransmitCommChar';

function TryEnterCriticalSection conv arg_stdcall (var lpCriticalSection: TRTLCriticalSection): BOOL;
 external kernel32dll name 'TryEnterCriticalSection';

function UnhandledExceptionFilter conv arg_stdcall (const ExceptionInfo: TExceptionPointers): Longint;
 external kernel32dll name 'UnhandledExceptionFilter';

function UnlockFile conv arg_stdcall (hFile: THandle; dwFileOffsetLow, dwFileOffsetHigh: DWORD;
 nNumberOfBytesToUnlockLow, nNumberOfBytesToUnlockHigh: DWORD): BOOL;
 external kernel32dll name 'UnlockFile';

function UnlockFileEx conv arg_stdcall (hFile: THandle; dwReserved, nNumberOfBytesToUnlockLow: DWORD;
 nNumberOfBytesToUnlockHigh: DWORD; const lpOverlapped: TOverlapped): BOOL;
 external kernel32dll name 'UnlockFileEx';

function UnmapViewOfFile conv arg_stdcall (lpBaseAddress: Pointer): BOOL;
 external kernel32dll name 'UnmapViewOfFile';

function UpdateResourceA conv arg_stdcall (hUpdate: THandle; lpType, lpName: PAnsiChar; wLanguage: Word; lpData: Pointer; cbData: DWORD): BOOL;
external kernel32dll name 'UpdateResourceA';

function UpdateResourceW conv arg_stdcall (hUpdate: THandle; lpType, lpName: PWideChar; wLanguage: Word; lpData: Pointer; cbData: DWORD): BOOL;
external kernel32dll name 'UpdateResourceW';

function UpdateResource conv arg_stdcall (hUpdate: THandle; lpType, lpName: PChar; wLanguage: Word; lpData: Pointer; cbData: DWORD): BOOL;
 external kernel32dll name 'UpdateResourceA';

function VerLanguageNameA conv arg_stdcall (wLang: DWORD; szLang: PAnsiChar; nSize: DWORD): DWORD;
external kernel32dll name 'VerLanguageNameA';

function VerLanguageNameW conv arg_stdcall (wLang: DWORD; szLang: PWideChar; nSize: DWORD): DWORD;
external kernel32dll name 'VerLanguageNameW';

function VerLanguageName conv arg_stdcall (wLang: DWORD; szLang: PChar; nSize: DWORD): DWORD;
 external kernel32dll name 'VerLanguageNameA';

function VirtualAlloc conv arg_stdcall (lpvAddress: Pointer; dwSize, flAllocationType, flProtect: DWORD): Pointer;
 external kernel32dll name 'VirtualAlloc';

function VirtualAllocEx conv arg_stdcall (hProcess: THandle; lpAddress: Pointer; dwSize, flAllocationType: DWORD; flProtect: DWORD): Pointer;
 external kernel32dll name 'VirtualAllocEx';

function VirtualFree conv arg_stdcall (lpAddress: Pointer; dwSize, dwFreeType: DWORD): BOOL;
 external kernel32dll name 'VirtualFree';

function VirtualFreeEx conv arg_stdcall (hProcess: THandle; lpAddress: Pointer; dwSize, dwFreeType: DWORD): Pointer;
 external kernel32dll name 'VirtualFreeEx';

function VirtualLock conv arg_stdcall (lpAddress: Pointer; dwSize: DWORD): BOOL;
 external kernel32dll name 'VirtualLock';

function VirtualProtect conv arg_stdcall (lpAddress: Pointer; dwSize, flNewProtect: DWORD; lpflOldProtect: Pointer): BOOL;
 external kernel32dll name 'VirtualProtect';

function VirtualProtectEx conv arg_stdcall (hProcess: THandle; lpAddress: Pointer; dwSize, flNewProtect: DWORD; lpflOldProtect: Pointer): BOOL;
 external kernel32dll name 'VirtualProtectEx';

function VirtualQuery conv arg_stdcall (lpAddress: Pointer; var lpBuffer: TMemoryBasicInformation; dwLength: DWORD): DWORD;
 external kernel32dll name 'VirtualQuery';

function VirtualQueryEx conv arg_stdcall (hProcess: THandle; lpAddress: Pointer; var lpBuffer: TMemoryBasicInformation; dwLength: DWORD): DWORD;
 external kernel32dll name 'VirtualQueryEx';

function VirtualUnlock conv arg_stdcall (lpAddress: Pointer; dwSize: DWORD): BOOL;
 external kernel32dll name 'VirtualUnlock';

function WaitCommEvent conv arg_stdcall (hFile: THandle; var lpEvtMask: DWORD; lpOverlapped: POverlapped): BOOL;
 external kernel32dll name 'WaitCommEvent';

function WaitForDebugEvent conv arg_stdcall (var lpDebugEvent: TDebugEvent; dwMilliseconds: DWORD): BOOL;
 external kernel32dll name 'WaitForDebugEvent';

function WaitForMultipleObjects conv arg_stdcall (nCount: DWORD; lpHandles: PWOHandleArray; bWaitAll: BOOL; dwMilliseconds: DWORD): DWORD;
 external kernel32dll name 'WaitForMultipleObjects';

function WaitForMultipleObjectsEx conv arg_stdcall (nCount: DWORD; lpHandles: PWOHandleArray; bWaitAll: BOOL; dwMilliseconds: DWORD; bAlertable: BOOL): DWORD;
 external kernel32dll name 'WaitForMultipleObjectsEx';

function WaitForSingleObject conv arg_stdcall (hHandle: THandle; dwMilliseconds: DWORD): DWORD;
 external kernel32dll name 'WaitForSingleObject';

function WaitForSingleObjectEx conv arg_stdcall (hHandle: THandle; dwMilliseconds: DWORD; bAlertable: BOOL): DWORD;
 external kernel32dll name 'WaitForSingleObjectEx';

function WaitNamedPipeA conv arg_stdcall (lpNamedPipeName: PAnsiChar; nTimeOut: DWORD): BOOL;
external kernel32dll name 'WaitNamedPipeA';

function WaitNamedPipeW conv arg_stdcall (lpNamedPipeName: PWideChar; nTimeOut: DWORD): BOOL;
external kernel32dll name 'WaitNamedPipeW';

function WaitNamedPipe conv arg_stdcall (lpNamedPipeName: PChar; nTimeOut: DWORD): BOOL;
 external kernel32dll name 'WaitNamedPipeA';

function WideCharToMultiByte conv arg_stdcall (CodePage: DWORD; dwFlags: DWORD; lpWideCharStr: LPWSTR; cchWideChar: DWORD; lpMultiByteStr: LPSTR;
 cchMultiByte: DWORD; lpDefaultChar: LPCSTR; lpUsedDefaultChar: PBOOL): DWORD;
 external kernel32dll name 'WideCharToMultiByte';

function WinExec conv arg_stdcall (lpCmdLine: LPCSTR; uCmdShow: DWORD): DWORD;
 external kernel32dll name 'WinExec';

function WriteConsoleA conv arg_stdcall (hConsoleOutput: THandle; const lpBuffer: Pointer;
 nNumberOfCharsToWrite: DWORD; var lpNumberOfCharsWritten: DWORD; lpReserved: Pointer): BOOL;
 external kernel32dll name 'WriteConsoleA';

function WriteConsoleW conv arg_stdcall (hConsoleOutput: THandle; const lpBuffer: Pointer;
 nNumberOfCharsToWrite: DWORD; var lpNumberOfCharsWritten: DWORD; lpReserved: Pointer): BOOL;
 external kernel32dll name 'WriteConsoleW';

function WriteConsole conv arg_stdcall (hConsoleOutput: THandle; const lpBuffer: Pointer;
 nNumberOfCharsToWrite: DWORD; var lpNumberOfCharsWritten: DWORD; lpReserved: Pointer): BOOL;
 external kernel32dll name 'WriteConsoleA';

function WriteConsoleInputA conv arg_stdcall (hConsoleInput: THandle; const lpBuffer: TInputRecord;
 nLength: DWORD; var lpNumberOfEventsWritten: DWORD): BOOL;
 external kernel32dll name 'WriteConsoleInputA';

function WriteConsoleInputW conv arg_stdcall (hConsoleInput: THandle; const lpBuffer: TInputRecord;
 nLength: DWORD; var lpNumberOfEventsWritten: DWORD): BOOL;
 external kernel32dll name 'WriteConsoleInputW';

function WriteConsoleInput conv arg_stdcall (hConsoleInput: THandle; const lpBuffer: TInputRecord;
 nLength: DWORD; var lpNumberOfEventsWritten: DWORD): BOOL;
 external kernel32dll name 'WriteConsoleInputA';

function WriteConsoleOutputA conv arg_stdcall (hConsoleOutput: THandle; lpBuffer: Pointer;
 dwBufferSize, dwBufferCoord: TCoord; var lpWriteRegion: TSmallRect): BOOL;
 external kernel32dll name 'WriteConsoleOutputA';

function WriteConsoleOutputW conv arg_stdcall (hConsoleOutput: THandle; lpBuffer: Pointer;
 dwBufferSize, dwBufferCoord: TCoord; var lpWriteRegion: TSmallRect): BOOL;
 external kernel32dll name 'WriteConsoleOutputW';

function WriteConsoleOutput conv arg_stdcall (hConsoleOutput: THandle; lpBuffer: Pointer;
 dwBufferSize, dwBufferCoord: TCoord; var lpWriteRegion: TSmallRect): BOOL;
 external kernel32dll name 'WriteConsoleOutputA';

function WriteConsoleOutputAttribute conv arg_stdcall (hConsoleOutput: THandle; lpAttribute: Pointer;
 nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfAttrsWritten: DWORD): BOOL;
 external kernel32dll name 'WriteConsoleOutputAttribute';

function WriteConsoleOutputCharacterA conv arg_stdcall (hConsoleOutput: THandle;lpCharacter: PAnsiChar;
nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfCharsWritten: DWORD): BOOL;
external kernel32dll name 'WriteConsoleOutputCharacterA';

function WriteConsoleOutputCharacterW conv arg_stdcall (hConsoleOutput: THandle;lpCharacter: PWideChar;
nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfCharsWritten: DWORD): BOOL;
external kernel32dll name 'WriteConsoleOutputCharacterW';

function WriteConsoleOutputCharacter conv arg_stdcall (hConsoleOutput: THandle;lpCharacter: PChar;
 nLength: DWORD; dwWriteCoord: TCoord; var lpNumberOfCharsWritten: DWORD): BOOL;
 external kernel32dll name 'WriteConsoleOutputCharacterA';

function WriteFile conv arg_stdcall (hFile: THandle; const Buffer; nNumberOfBytesToWrite: DWORD;
 var lpNumberOfBytesWritten: DWORD; lpOverlapped: POverlapped): BOOL;
 external kernel32dll name 'WriteFile';

function WriteFileEx conv arg_stdcall (hFile: THandle; lpBuffer: Pointer; nNumberOfBytesToWrite: DWORD;
 const lpOverlapped: TOverlapped; lpCompletionRoutine: FARPROC): BOOL;
 external kernel32dll name 'WriteFileEx';

function WritePrivateProfileSectionA conv arg_stdcall (lpAppName, lpString, lpFileName: PAnsiChar): BOOL;
external kernel32dll name 'WritePrivateProfileSectionA';

function WritePrivateProfileSectionW conv arg_stdcall (lpAppName, lpString, lpFileName: PWideChar): BOOL;
external kernel32dll name 'WritePrivateProfileSectionW';

function WritePrivateProfileSection conv arg_stdcall (lpAppName, lpString, lpFileName: PChar): BOOL;
 external kernel32dll name 'WritePrivateProfileSectionA';

function WritePrivateProfileStringA conv arg_stdcall (lpAppName, lpKeyName, lpString, lpFileName: PAnsiChar): BOOL;
external kernel32dll name 'WritePrivateProfileStringA';

function WritePrivateProfileStringW conv arg_stdcall (lpAppName, lpKeyName, lpString, lpFileName: PWideChar): BOOL;
external kernel32dll name 'WritePrivateProfileStringW';

function WritePrivateProfileString conv arg_stdcall (lpAppName, lpKeyName, lpString, lpFileName: PChar): BOOL;
 external kernel32dll name 'WritePrivateProfileStringA';

function WriteProcessMemory conv arg_stdcall (hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
 nSize: DWORD; var lpNumberOfBytesWritten: DWORD): BOOL;
 external kernel32dll name 'WriteProcessMemory';

function WriteProfileSectionA conv arg_stdcall (lpAppName, lpString: PAnsiChar): BOOL;
external kernel32dll name 'WriteProfileSectionA';

function WriteProfileSectionW conv arg_stdcall (lpAppName, lpString: PWideChar): BOOL;
external kernel32dll name 'WriteProfileSectionW';

function WriteProfileSection conv arg_stdcall (lpAppName, lpString: PChar): BOOL;
 external kernel32dll name 'WriteProfileSectionA';

function WriteProfileStringA conv arg_stdcall (lpAppName, lpKeyName, lpString: PAnsiChar): BOOL;
external kernel32dll name 'WriteProfileStringA';

function WriteProfileStringW conv arg_stdcall (lpAppName, lpKeyName, lpString: PWideChar): BOOL;
external kernel32dll name 'WriteProfileStringW';

function WriteProfileString conv arg_stdcall (lpAppName, lpKeyName, lpString: PChar): BOOL;
 external kernel32dll name 'WriteProfileStringA';

function WriteTapemark conv arg_stdcall (hDevice: THandle; dwTapemarkType, dwTapemarkCount: DWORD; bImmediate: BOOL): DWORD;
 external kernel32dll name 'WriteTapemark';

function _hread conv arg_stdcall (hFile: HFILE; lpBuffer: Pointer; lBytes: Longint): Longint;
 external kernel32dll name '_hread';

function _hwrite conv arg_stdcall (hFile: HFILE; lpBuffer: LPCSTR; lBytes: Longint): Longint;
 external kernel32dll name '_hwrite';

function _lclose conv arg_stdcall (hFile: HFILE): HFILE;
 external kernel32dll name '_lclose';

function _lcreat conv arg_stdcall (const lpPathName: LPCSTR; iAttribute: DWORD): HFILE;
 external kernel32dll name '_lcreat';

function _llseek conv arg_stdcall (hFile: HFILE; lOffset: Longint; iOrigin: DWORD): Longint;
 external kernel32dll name '_llseek';

function _lopen conv arg_stdcall (const lpPathName: LPCSTR; iReadWrite: DWORD): HFILE;
 external kernel32dll name '_lopen';

function _lread conv arg_stdcall (hFile: HFILE; lpBuffer: Pointer; uBytes: DWORD): DWORD;
 external kernel32dll name '_lread';

function _lwrite conv arg_stdcall (hFile: HFILE; const lpBuffer: LPCSTR; uBytes: DWORD): DWORD;
 external kernel32dll name '_lwrite';

function lstrcatA conv arg_stdcall (lpString1, lpString2: PAnsiChar): PAnsiChar;
external kernel32dll name 'lstrcatA';

function lstrcatW conv arg_stdcall (lpString1, lpString2: PWideChar): PWideChar;
external kernel32dll name 'lstrcatW';

function lstrcat conv arg_stdcall (lpString1, lpString2: PChar): PChar;
 external kernel32dll name 'lstrcatA';

function lstrcmpA conv arg_stdcall (lpString1, lpString2: PAnsiChar): DWORD;
external kernel32dll name 'lstrcmpA';

function lstrcmpW conv arg_stdcall (lpString1, lpString2: PWideChar): DWORD;
external kernel32dll name 'lstrcmpW';

function lstrcmp conv arg_stdcall (lpString1, lpString2: PChar): DWORD;
 external kernel32dll name 'lstrcmpA';

function lstrcmpiA conv arg_stdcall (lpString1, lpString2: PAnsiChar): DWORD;
external kernel32dll name 'lstrcmpiA';

function lstrcmpiW conv arg_stdcall (lpString1, lpString2: PWideChar): DWORD;
external kernel32dll name 'lstrcmpiW';

function lstrcmpi conv arg_stdcall (lpString1, lpString2: PChar): DWORD;
 external kernel32dll name 'lstrcmpiA';

function lstrcpyA conv arg_stdcall (lpString1, lpString2: PAnsiChar): PAnsiChar;
external kernel32dll name 'lstrcpynA';

function lstrcpyW conv arg_stdcall (lpString1, lpString2: PWideChar): PWideChar;
external kernel32dll name 'lstrcpynW';

function lstrcpy conv arg_stdcall (lpString1, lpString2: PChar): PChar;
 external kernel32dll name 'lstrcpynA';

function lstrcpynA conv arg_stdcall (lpString1, lpString2: PAnsiChar; iMaxLength: DWORD): PAnsiChar;
external kernel32dll name 'lstrcpyA';

function lstrcpynW conv arg_stdcall (lpString1, lpString2: PWideChar; iMaxLength: DWORD): PWideChar;
external kernel32dll name 'lstrcpyW';

function lstrcpyn conv arg_stdcall (lpString1, lpString2: PChar; iMaxLength: DWORD): PChar;
 external kernel32dll name 'lstrcpyA';

function lstrlenA conv arg_stdcall (lpString: PAnsiChar): DWORD;
external kernel32dll name 'lstrlenA';

function lstrlenW conv arg_stdcall (lpString: PWideChar): DWORD;
external kernel32dll name 'lstrlenW';

function lstrlen conv arg_stdcall (lpString: PChar): DWORD;
 external kernel32dll name 'lstrlenA';

///////////////////////// ADVAPI32.DLL IMPORT SECTION /////////////////////////

function AbortSystemShutdownA conv arg_stdcall (lpMachineName: PAnsiChar): BOOL;
external advapi32dll name 'AbortSystemShutdownA';

function AbortSystemShutdownW conv arg_stdcall (lpMachineName: PWideChar): BOOL;
external advapi32dll name 'AbortSystemShutdownW';

function AbortSystemShutdown conv arg_stdcall (lpMachineName: PChar): BOOL;
 external advapi32dll name 'AbortSystemShutdownA';

function AccessCheck conv arg_stdcall (pSecurityDescriptor: PSecurityDescriptor;
 ClientToken: THandle; DesiredAccess: DWORD; const GenericMapping: TGenericMapping;
 var PrivilegeSet: TPrivilegeSet; var PrivilegeSetLength: DWORD;
 var GrantedAccess: DWORD; var AccessStatus: BOOL): BOOL;
 external advapi32dll name 'AccessCheck';

function AccessCheckAndAuditAlarmA conv arg_stdcall (pSecurityDescriptor: PSecurityDescriptor;
 ClientToken: THandle; DesiredAccess: DWORD; const GenericMapping: TGenericMapping;
 var PrivilegeSet: TPrivilegeSet; var PrivilegeSetLength: DWORD; var GrantedAccess: DWORD;
 var AccessStatus: BOOL): BOOL;
 external advapi32dll name 'AccessCheckAndAuditAlarmA';

function AccessCheckAndAuditAlarmW conv arg_stdcall (SubsystemName: PWideChar;
 HandleId: Pointer; ObjectTypeName, ObjectName: PWideChar;
 SecurityDescriptor: PSecurityDescriptor; DesiredAccess: DWORD;
 const GenericMapping: TGenericMapping;  ObjectCreation: BOOL;
 var GrantedAccess: DWORD; var AccessStatus, pfGenerateOnClose: BOOL): BOOL;
 external advapi32dll name 'AccessCheckAndAuditAlarmW';

function AccessCheckAndAuditAlarm conv arg_stdcall (SubsystemName: PChar;
 HandleId: Pointer; ObjectTypeName, ObjectName: PChar;
 SecurityDescriptor: PSecurityDescriptor; DesiredAccess: DWORD;
 const GenericMapping: TGenericMapping;  ObjectCreation: BOOL;
 var GrantedAccess: DWORD; var AccessStatus, pfGenerateOnClose: BOOL): BOOL;
 external advapi32dll name 'AccessCheckAndAuditAlarmA';

function AddAccessAllowedAce conv arg_stdcall (var pAcl: TACL; dwAceRevision: DWORD; AccessMask: DWORD; pSid: PSID): BOOL;
 external advapi32dll name 'AddAccessAllowedAce';

function AddAccessDeniedAce conv arg_stdcall (var pAcl: TACL; dwAceRevision: DWORD;
 AccessMask: DWORD; pSid: PSID): BOOL;
 external advapi32dll name 'AddAccessDeniedAce';

function AddAce conv arg_stdcall (var pAcl: TACL; dwAceRevision, dwStartingAceIndex: DWORD; pAceList: Pointer;
 nAceListLength: DWORD): BOOL;
 external advapi32dll name 'AddAce';

function AddAuditAccessAce conv arg_stdcall (var pAcl: TACL; dwAceRevision: DWORD;
 dwAccessMask: DWORD; pSid: Pointer; bAuditSuccess, bAuditFailure: BOOL): BOOL;
 external advapi32dll name 'AddAuditAccessAce';

function AdjustTokenGroups conv arg_stdcall (TokenHandle: THandle; ResetToDefault: BOOL;
 const NewState: TTokenGroups; BufferLength: DWORD; var PreviousState: TTokenGroups; var ReturnLength: DWORD): BOOL;
 external advapi32dll name 'AdjustTokenGroups';

function AdjustTokenPrivileges conv arg_stdcall (TokenHandle: THandle; DisableAllPrivileges: BOOL;
 const NewState: TTokenPrivileges; BufferLength: DWORD; var PreviousState: TTokenPrivileges; var ReturnLength: DWORD): BOOL;
 external advapi32dll name 'AdjustTokenPrivileges';

function AllocateAndInitializeSid conv arg_stdcall (const pIdentifierAuthority: TSIDIdentifierAuthority;
 nSubAuthorityCount: Byte; nSubAuthority0, nSubAuthority1: DWORD; nSubAuthority2, nSubAuthority3, nSubAuthority4: DWORD;
 nSubAuthority5, nSubAuthority6, nSubAuthority7: DWORD; var pSid: Pointer): BOOL;
 external advapi32dll name 'AllocateAndInitializeSid';

function AllocateLocallyUniqueId conv arg_stdcall (var Luid: TLargeInteger): BOOL;
 external advapi32dll name 'AllocateLocallyUniqueId';

function AreAllAccessesGranted conv arg_stdcall (GrantedAccess, DesiredAccess: DWORD): BOOL;
 external advapi32dll name 'AreAllAccessesGranted';

function AreAnyAccessesGranted conv arg_stdcall (GrantedAccess, DesiredAccess: DWORD): BOOL;
 external advapi32dll name 'AreAnyAccessesGranted';

function BackupEventLogA conv arg_stdcall (hEventLog: THandle; lpBackupFileName: PAnsiChar): BOOL;
external advapi32dll name 'BackupEventLogA';

function BackupEventLogW conv arg_stdcall (hEventLog: THandle; lpBackupFileName: PWideChar): BOOL;
external advapi32dll name 'BackupEventLogW';

function BackupEventLog conv arg_stdcall (hEventLog: THandle; lpBackupFileName: PChar): BOOL;
 external advapi32dll name 'BackupEventLogA';

function ClearEventLogA conv arg_stdcall (hEventLog: THandle; lpBackupFileName: PAnsiChar): BOOL;
external advapi32dll name 'ClearEventLogA';

function ClearEventLogW conv arg_stdcall (hEventLog: THandle; lpBackupFileName: PWideChar): BOOL;
external advapi32dll name 'ClearEventLogW';

function ClearEventLog conv arg_stdcall (hEventLog: THandle; lpBackupFileName: PChar): BOOL;
 external advapi32dll name 'ClearEventLogA';

function CloseEventLog conv arg_stdcall (hEventLog: THandle): BOOL;
 external advapi32dll name 'CloseEventLog';

function CopySid conv arg_stdcall (nDestinationSidLength: DWORD; pDestinationSid, pSourceSid: Pointer): BOOL;
 external advapi32dll name 'CopySid';

function CreatePrivateObjectSecurity conv arg_stdcall (ParentDescriptor, CreatorDescriptor: PSecurityDescriptor;
 var NewDescriptor: PSecurityDescriptor; IsDirectoryObject: BOOL; Token: THandle; const GenericMapping: TGenericMapping): BOOL;
 external advapi32dll name 'CreatePrivateObjectSecurity';

function CreateProcessAsUserA conv arg_stdcall (hToken: THandle; lpApplicationName: PAnsiChar;
 lpCommandLine: PAnsiChar; lpProcessAttributes: PSecurityAttributes;
 lpThreadAttributes: PSecurityAttributes; bInheritHandles: BOOL;
 dwCreationFlags: DWORD; lpEnvironment: Pointer; lpCurrentDirectory: PAnsiChar;
 const lpStartupInfo: TStartupInfo; var lpProcessInformation: TProcessInformation): BOOL;
 external advapi32dll name 'CreateProcessAsUserA';

function CreateProcessAsUserW conv arg_stdcall (hToken: THandle; lpApplicationName: PWideChar;
 lpCommandLine: PWideChar; lpProcessAttributes: PSecurityAttributes;
 lpThreadAttributes: PSecurityAttributes; bInheritHandles: BOOL;
 dwCreationFlags: DWORD; lpEnvironment: Pointer; lpCurrentDirectory: PWideChar;
 const lpStartupInfo: TStartupInfo; var lpProcessInformation: TProcessInformation): BOOL;
 external advapi32dll name 'CreateProcessAsUserW';

function CreateProcessAsUser conv arg_stdcall (hToken: THandle; lpApplicationName: PChar;
 lpCommandLine: PChar; lpProcessAttributes: PSecurityAttributes;
 lpThreadAttributes: PSecurityAttributes; bInheritHandles: BOOL;
 dwCreationFlags: DWORD; lpEnvironment: Pointer; lpCurrentDirectory: PChar;
 const lpStartupInfo: TStartupInfo; var lpProcessInformation: TProcessInformation): BOOL;
 external advapi32dll name 'CreateProcessAsUserA';

function DeleteAce conv arg_stdcall (var pAcl: TACL; dwAceIndex: DWORD): BOOL;
 external advapi32dll name 'DeleteAce';

function DeregisterEventSource conv arg_stdcall (hEventLog: THandle): BOOL;
 external advapi32dll name 'DeregisterEventSource';

function DestroyPrivateObjectSecurity conv arg_stdcall (var ObjectDescriptor: PSecurityDescriptor): BOOL;
 external advapi32dll name 'DestroyPrivateObjectSecurity';

function DuplicateToken conv arg_stdcall (ExistingTokenHandle: THandle; ImpersonationLevel: TSecurityImpersonationLevel; DuplicateTokenHandle: PHandle): BOOL;
 external advapi32dll name 'DuplicateToken';

function DuplicateTokenEx conv arg_stdcall (hExistingToken: THandle; dwDesiredAccess: DWORD;
 lpTokenAttributes: PSecurityAttributes; ImpersonationLevel: TSecurityImpersonationLevel; TokenType: TTokenType;
 var phNewToken: THandle): BOOL;
 external advapi32dll name 'DuplicateTokenEx';

function EqualPrefixSid conv arg_stdcall (pSid1, pSid2: Pointer): BOOL;
 external advapi32dll name 'EqualPrefixSid';

function EqualSid conv arg_stdcall (pSid1, pSid2: Pointer): BOOL;
 external advapi32dll name 'EqualSid';

function FindFirstFreeAce conv arg_stdcall (var pAcl: TACL; var pAce: Pointer): BOOL;
 external advapi32dll name 'FindFirstFreeAce';

function FreeSid conv arg_stdcall (pSid: Pointer): Pointer;
 external advapi32dll name 'FreeSid';

function GetAce conv arg_stdcall (const pAcl: TACL; dwAceIndex: DWORD; var pAce: Pointer): BOOL;
 external advapi32dll name 'GetAce';

function GetAclInformation conv arg_stdcall (const pAcl: TACL; pAclInformation: Pointer;
 nAclInformationLength: DWORD; dwAclInformationClass: TAclInformationClass): BOOL;
 external advapi32dll name 'GetAclInformation';

function GetCurrentHwProfileA conv arg_stdcall (var lpHwProfileInfo: THWProfileInfoA): BOOL;
 external advapi32dll name 'GetCurrentHwProfileA';

function GetCurrentHwProfileW conv arg_stdcall (var lpHwProfileInfo: THWProfileInfoW): BOOL;
 external advapi32dll name 'GetCurrentHwProfileW';

function GetCurrentHwProfile conv arg_stdcall (var lpHwProfileInfo: THWProfileInfo): BOOL;
 external advapi32dll name 'GetCurrentHwProfileA';

function GetFileSecurityA conv arg_stdcall (lpFileName: PAnsiChar; RequestedInformation: SECURITY_INFORMATION;
pSecurityDescriptor: PSecurityDescriptor; nLength: DWORD; var lpnLengthNeeded: DWORD): BOOL;
external advapi32dll name 'GetFileSecurityA';

function GetFileSecurityW conv arg_stdcall (lpFileName: PWideChar; RequestedInformation: SECURITY_INFORMATION;
 pSecurityDescriptor: PSecurityDescriptor; nLength: DWORD; var lpnLengthNeeded: DWORD): BOOL;
 external advapi32dll name 'GetFileSecurityW';

function GetFileSecurity conv arg_stdcall (lpFileName: PChar; RequestedInformation: SECURITY_INFORMATION;
 pSecurityDescriptor: PSecurityDescriptor; nLength: DWORD; var lpnLengthNeeded: DWORD): BOOL;
 external advapi32dll name 'GetFileSecurityA';

function GetKernelObjectSecurity conv arg_stdcall (Handle: THandle; RequestedInformation: SECURITY_INFORMATION;
 pSecurityDescriptor: PSecurityDescriptor; nLength: DWORD; var lpnLengthNeeded: DWORD): BOOL;
 external advapi32dll name 'GetKernelObjectSecurity';

function GetLengthSid conv arg_stdcall (pSid: Pointer): DWORD;
 external advapi32dll name 'GetLengthSid';

function GetNumberOfEventLogRecords conv arg_stdcall (hEventLog: THandle; var NumberOfRecords: DWORD): BOOL;
 external advapi32dll name 'GetNumberOfEventLogRecords';

function GetOldestEventLogRecord conv arg_stdcall (hEventLog: THandle; var OldestRecord: DWORD): BOOL;
 external advapi32dll name 'GetOldestEventLogRecord';

function GetPrivateObjectSecurity conv arg_stdcall (ObjectDescriptor: PSecurityDescriptor;
 SecurityInformation: SECURITY_INFORMATION; ResultantDescriptor: PSecurityDescriptor;
 DescriptorLength: DWORD; var ReturnLength: DWORD): BOOL;
 external advapi32dll name 'GetPrivateObjectSecurity';

function GetSecurityDescriptorControl conv arg_stdcall (pSecurityDescriptor: PSecurityDescriptor;
 var pControl: SECURITY_DESCRIPTOR_CONTROL; var lpdwRevision: DWORD): BOOL;
 external advapi32dll name 'GetSecurityDescriptorControl';

function GetSecurityDescriptorDacl conv arg_stdcall (pSecurityDescriptor: PSecurityDescriptor;
 var lpbDaclPresent: BOOL; var pDacl: PACL; var lpbDaclDefaulted: BOOL): BOOL;
 external advapi32dll name 'GetSecurityDescriptorDacl';

function GetSecurityDescriptorGroup conv arg_stdcall (pSecurityDescriptor: PSecurityDescriptor; var pGroup: PSID; var lpbGroupDefaulted: BOOL): BOOL;
 external advapi32dll name 'GetSecurityDescriptorGroup';

function GetSecurityDescriptorLength conv arg_stdcall (pSecurityDescriptor: PSecurityDescriptor): DWORD;
 external advapi32dll name 'GetSecurityDescriptorLength';

function GetSecurityDescriptorOwner conv arg_stdcall (pSecurityDescriptor: PSecurityDescriptor; var pOwner: PSID; var lpbOwnerDefaulted: BOOL): BOOL;
 external advapi32dll name 'GetSecurityDescriptorOwner';

function GetSecurityDescriptorSacl conv arg_stdcall (pSecurityDescriptor: PSecurityDescriptor;
 var lpbSaclPresent: BOOL; var pSacl: PACL; var lpbSaclDefaulted: BOOL): BOOL;
 external advapi32dll name 'GetSecurityDescriptorSacl';

function GetSidIdentifierAuthority conv arg_stdcall (pSid: Pointer): PSIDIdentifierAuthority;
 external advapi32dll name 'GetSidIdentifierAuthority';

function GetSidLengthRequired conv arg_stdcall (nSubAuthorityCount: UCHAR): DWORD;
 external advapi32dll name 'GetSidLengthRequired';

function GetSidSubAuthority conv arg_stdcall (pSid: Pointer; nSubAuthority: DWORD): PDWORD;
 external advapi32dll name 'GetSidSubAuthority';

function GetSidSubAuthorityCount conv arg_stdcall (pSid: Pointer): PUCHAR;
 external advapi32dll name 'GetSidSubAuthorityCount';

function GetTokenInformation conv arg_stdcall (TokenHandle: THandle; TokenInformationClass: TTokenInformationClass; TokenInformation: Pointer;
 TokenInformationLength: DWORD; var ReturnLength: DWORD): BOOL;
 external advapi32dll name 'GetTokenInformation';

function GetUserNameA conv arg_stdcall (lpBuffer: PAnsiChar; var nSize: DWORD): BOOL;
 external advapi32dll name 'GetUserNameA';

function GetUserNameW conv arg_stdcall (lpBuffer: PWideChar; var nSize: DWORD): BOOL;
 external advapi32dll name 'GetUserNameW';

function GetUserName conv arg_stdcall (lpBuffer: PChar; var nSize: DWORD): BOOL;
 external advapi32dll name 'GetUserNameA';

function ImpersonateLoggedOnUser conv arg_stdcall (hToken: THandle): BOOL;
 external advapi32dll name 'ImpersonateLoggedOnUser';

function ImpersonateNamedPipeClient conv arg_stdcall (hNamedPipe: THandle): BOOL;
 external advapi32dll name 'ImpersonateNamedPipeClient';

function ImpersonateSelf conv arg_stdcall (ImpersonationLevel: TSecurityImpersonationLevel): BOOL;
 external advapi32dll name 'ImpersonateSelf';

function InitializeAcl conv arg_stdcall (var pAcl: TACL; nAclLength, dwAclRevision: DWORD): BOOL;
 external advapi32dll name 'InitializeAcl';

function InitializeSecurityDescriptor conv arg_stdcall (pSecurityDescriptor: PSecurityDescriptor;
 dwRevision: DWORD): BOOL;
 external advapi32dll name 'InitializeSecurityDescriptor';

function InitializeSid conv arg_stdcall (Sid: Pointer; const pIdentifierAuthority: TSIDIdentifierAuthority;
 nSubAuthorityCount: Byte): BOOL;
 external advapi32dll name 'InitializeSid';

function InitiateSystemShutdownA conv arg_stdcall (lpMachineName, lpMessage: PAnsiChar;
 dwTimeout: DWORD; bForceAppsClosed, bRebootAfterShutdown: BOOL): BOOL;
 external advapi32dll name 'InitiateSystemShutdownA';

function InitiateSystemShutdownW conv arg_stdcall (lpMachineName, lpMessage: PWideChar;
 dwTimeout: DWORD; bForceAppsClosed, bRebootAfterShutdown: BOOL): BOOL;
 external advapi32dll name 'InitiateSystemShutdownW';

function InitiateSystemShutdown conv arg_stdcall (lpMachineName, lpMessage: PChar;
 dwTimeout: DWORD; bForceAppsClosed, bRebootAfterShutdown: BOOL): BOOL;
 external advapi32dll name 'InitiateSystemShutdownA';

function IsTextUnicode conv arg_stdcall (lpBuffer: Pointer; cb: DWord; lpi: PINT): BOOL;
 external advapi32dll name 'IsTextUnicode';

function IsValidAcl conv arg_stdcall (const pAcl: TACL): BOOL;
 external advapi32dll name 'IsValidAcl';

function IsValidSecurityDescriptor conv arg_stdcall (pSecurityDescriptor: PSecurityDescriptor): BOOL;
 external advapi32dll name 'IsValidSecurityDescriptor';

function IsValidSid conv arg_stdcall (pSid: Pointer): BOOL;
 external advapi32dll name 'IsValidSid';

function LogonUserA conv arg_stdcall (lpszUsername, lpszDomain, lpszPassword: PAnsiChar;
 dwLogonType, dwLogonProvider: DWORD; var phToken: THandle): BOOL;
 external advapi32dll name 'LogonUserA';

function LogonUserW conv arg_stdcall (lpszUsername, lpszDomain, lpszPassword: PWideChar;
 dwLogonType, dwLogonProvider: DWORD; var phToken: THandle): BOOL;
 external advapi32dll name 'LogonUserW';

function LogonUser conv arg_stdcall (lpszUsername, lpszDomain, lpszPassword: PChar;
 dwLogonType, dwLogonProvider: DWORD; var phToken: THandle): BOOL;
 external advapi32dll name 'LogonUserA';

function LookupAccountNameA conv arg_stdcall (lpSystemName, lpAccountName: PAnsiChar;
 Sid: PSID; var cbSid: DWORD; ReferencedDomainName: PAnsiChar;
 var cbReferencedDomainName: DWORD; var peUse: SID_NAME_USE): BOOL;
 external advapi32dll name 'LookupAccountNameA';

function LookupAccountNameW conv arg_stdcall (lpSystemName, lpAccountName: PWideChar;
 Sid: PSID; var cbSid: DWORD; ReferencedDomainName: PWideChar;
 var cbReferencedDomainName: DWORD; var peUse: SID_NAME_USE): BOOL;
 external advapi32dll name 'LookupAccountNameW';

function LookupAccountName conv arg_stdcall (lpSystemName, lpAccountName: PChar;
 Sid: PSID; var cbSid: DWORD; ReferencedDomainName: PChar;
 var cbReferencedDomainName: DWORD; var peUse: SID_NAME_USE): BOOL;
 external advapi32dll name 'LookupAccountNameA';

function LookupAccountSidA conv arg_stdcall (lpSystemName: PAnsiChar; Sid: PSID;
 Name: PAnsiChar; var cbName: DWORD; ReferencedDomainName: PAnsiChar;
 var cbReferencedDomainName: DWORD; var peUse: SID_NAME_USE): BOOL;
 external advapi32dll name 'LookupAccountSidA';

function LookupAccountSidW conv arg_stdcall (lpSystemName: PWideChar; Sid: PSID;
 Name: PWideChar; var cbName: DWORD; ReferencedDomainName: PWideChar;
 var cbReferencedDomainName: DWORD; var peUse: SID_NAME_USE): BOOL;
 external advapi32dll name 'LookupAccountSidW';

function LookupAccountSid conv arg_stdcall (lpSystemName: PChar; Sid: PSID;
 Name: PChar; var cbName: DWORD; ReferencedDomainName: PChar;
 var cbReferencedDomainName: DWORD; var peUse: SID_NAME_USE): BOOL;
 external advapi32dll name 'LookupAccountSidA';

function LookupPrivilegeDisplayNameA conv arg_stdcall (lpSystemName, lpName: PAnsiChar;
 lpDisplayName: PAnsiChar; var cbDisplayName, lpLanguageId: DWORD): BOOL;
 external advapi32dll name 'LookupPrivilegeDisplayNameA';

function LookupPrivilegeDisplayNameW conv arg_stdcall (lpSystemName, lpName: PAnsiChar;
 lpDisplayName: PWideChar; var cbDisplayName, lpLanguageId: DWORD): BOOL;
 external advapi32dll name 'LookupPrivilegeDisplayNameW';

function LookupPrivilegeDisplayName conv arg_stdcall (lpSystemName, lpName: PChar;
 lpDisplayName: PChar; var cbDisplayName, lpLanguageId: DWORD): BOOL;
 external advapi32dll name 'LookupPrivilegeDisplayNameA';

function LookupPrivilegeNameA conv arg_stdcall (lpSystemName: PAnsiChar; var lpLuid: TLargeInteger; lpName: PAnsiChar; var cbName: DWORD): BOOL;
 external advapi32dll name 'LookupPrivilegeNameA';

function LookupPrivilegeNameW conv arg_stdcall (lpSystemName: PWideChar; var lpLuid: TLargeInteger; lpName: PWideChar; var cbName: DWORD): BOOL;
 external advapi32dll name 'LookupPrivilegeNameW';

function LookupPrivilegeName conv arg_stdcall (lpSystemName: PChar; var lpLuid: TLargeInteger; lpName: PChar; var cbName: DWORD): BOOL;
 external advapi32dll name 'LookupPrivilegeNameA';

function LookupPrivilegeValueA conv arg_stdcall (lpSystemName, lpName: PAnsiChar; var lpLuid: TLargeInteger): BOOL;
 external advapi32dll name 'LookupPrivilegeValueA';

function LookupPrivilegeValueW conv arg_stdcall (lpSystemName, lpName: PWideChar; var lpLuid: TLargeInteger): BOOL;
 external advapi32dll name 'LookupPrivilegeValueW';

function LookupPrivilegeValue conv arg_stdcall (lpSystemName, lpName: PChar; var lpLuid: TLargeInteger): BOOL;
 external advapi32dll name 'LookupPrivilegeValueA';

function MakeAbsoluteSD conv arg_stdcall (pSelfRelativeSecurityDescriptor: PSecurityDescriptor;
 pAbsoluteSecurityDescriptor: PSecurityDescriptor; var lpdwAbsoluteSecurityDescriptorSi: DWORD;
 var pDacl: TACL; var lpdwDaclSize: DWORD; var pSacl: TACL;
 var lpdwSaclSize: DWORD; pOwner: PSID; var lpdwOwnerSize: DWORD;
 pPrimaryGroup: Pointer; var lpdwPrimaryGroupSize: DWORD): BOOL;
 external advapi32dll name 'MakeAbsoluteSD';

function MakeSelfRelativeSD conv arg_stdcall (pAbsoluteSecurityDescriptor: PSecurityDescriptor;
 pSelfRelativeSecurityDescriptor: PSecurityDescriptor; var lpdwBufferLength: DWORD): BOOL;
 external advapi32dll name 'MakeSelfRelativeSD';

procedure MapGenericMask;
 external advapi32dll name 'MapGenericMask';

function NotifyChangeEventLog conv arg_stdcall (hEventLog, hEvent: THandle): BOOL;
 external advapi32dll name 'NotifyChangeEventLog';

function ObjectCloseAuditAlarmA conv arg_stdcall (SubsystemName: PAnsiChar; HandleId: Pointer; GenerateOnClose: BOOL): BOOL;
 external advapi32dll name 'ObjectCloseAuditAlarmA';

function ObjectCloseAuditAlarmW conv arg_stdcall (SubsystemName: PWideChar; HandleId: Pointer; GenerateOnClose: BOOL): BOOL;
 external advapi32dll name 'ObjectCloseAuditAlarmW';

function ObjectCloseAuditAlarm conv arg_stdcall (SubsystemName: PChar; HandleId: Pointer; GenerateOnClose: BOOL): BOOL;
 external advapi32dll name 'ObjectCloseAuditAlarmA';

function ObjectDeleteAuditAlarmA conv arg_stdcall (SubsystemName: PAnsiChar; HandleId: Pointer; GenerateOnClose: BOOL): BOOL;
 external advapi32dll name 'ObjectDeleteAuditAlarmA';

function ObjectDeleteAuditAlarmW conv arg_stdcall (SubsystemName: PWideChar; HandleId: Pointer; GenerateOnClose: BOOL): BOOL;
 external advapi32dll name 'ObjectDeleteAuditAlarmW';

function ObjectDeleteAuditAlarm conv arg_stdcall (SubsystemName: PChar; HandleId: Pointer; GenerateOnClose: BOOL): BOOL;
 external advapi32dll name 'ObjectDeleteAuditAlarmA';

function ObjectOpenAuditAlarmA conv arg_stdcall (SubsystemName: PAnsiChar; HandleId: Pointer;
 ObjectTypeName: PAnsiChar; ObjectName: PAnsiChar; pSecurityDescriptor: PSecurityDescriptor;
 ClientToken: THandle; DesiredAccess, GrantedAccess: DWORD;
 var Privileges: TPrivilegeSet; ObjectCreation, AccessGranted: BOOL;
 var GenerateOnClose: BOOL): BOOL;
 external advapi32dll name 'ObjectOpenAuditAlarmA';

function ObjectOpenAuditAlarmW conv arg_stdcall (SubsystemName: PWideChar; HandleId: Pointer;
 ObjectTypeName: PWideChar; ObjectName: PWideChar; pSecurityDescriptor: PSecurityDescriptor;
 ClientToken: THandle; DesiredAccess, GrantedAccess: DWORD;
 var Privileges: TPrivilegeSet; ObjectCreation, AccessGranted: BOOL;
 var GenerateOnClose: BOOL): BOOL;
 external advapi32dll name 'ObjectOpenAuditAlarmW';

function ObjectOpenAuditAlarm conv arg_stdcall (SubsystemName: PChar; HandleId: Pointer;
 ObjectTypeName: PChar; ObjectName: PChar; pSecurityDescriptor: PSecurityDescriptor;
 ClientToken: THandle; DesiredAccess, GrantedAccess: DWORD;
 var Privileges: TPrivilegeSet; ObjectCreation, AccessGranted: BOOL;
 var GenerateOnClose: BOOL): BOOL;
 external advapi32dll name 'ObjectOpenAuditAlarmA';

function ObjectPrivilegeAuditAlarmA conv arg_stdcall (SubsystemName: PAnsiChar;
 HandleId: Pointer; ClientToken: THandle; DesiredAccess: DWORD;
 var Privileges: TPrivilegeSet; AccessGranted: BOOL): BOOL;
 external advapi32dll name 'ObjectPrivilegeAuditAlarmA';

function ObjectPrivilegeAuditAlarmW conv arg_stdcall (SubsystemName: PWideChar;
 HandleId: Pointer; ClientToken: THandle; DesiredAccess: DWORD;
 var Privileges: TPrivilegeSet; AccessGranted: BOOL): BOOL;
 external advapi32dll name 'ObjectPrivilegeAuditAlarmW';

function ObjectPrivilegeAuditAlarm conv arg_stdcall (SubsystemName: PChar;
 HandleId: Pointer; ClientToken: THandle; DesiredAccess: DWORD;
 var Privileges: TPrivilegeSet; AccessGranted: BOOL): BOOL;
 external advapi32dll name 'ObjectPrivilegeAuditAlarmA';

function OpenBackupEventLogA conv arg_stdcall (lpUNCServerName, lpFileName: PAnsiChar): THandle;
 external advapi32dll name 'OpenBackupEventLogA';

function OpenBackupEventLogW conv arg_stdcall (lpUNCServerName, lpFileName: PWideChar): THandle;
 external advapi32dll name 'OpenBackupEventLogW';

function OpenBackupEventLog conv arg_stdcall (lpUNCServerName, lpFileName: PChar): THandle;
 external advapi32dll name 'OpenBackupEventLogA';

function OpenEventLogA conv arg_stdcall (lpUNCServerName, lpSourceName: PAnsiChar): THandle;
 external advapi32dll name 'OpenEventLogA';

function OpenEventLogW conv arg_stdcall (lpUNCServerName, lpSourceName: PWideChar): THandle;
 external advapi32dll name 'OpenEventLogW';

function OpenEventLog conv arg_stdcall (lpUNCServerName, lpSourceName: PChar): THandle;
 external advapi32dll name 'OpenEventLogA';

function OpenProcessToken conv arg_stdcall (ProcessHandle: THandle; DesiredAccess: DWORD; var TokenHandle: THandle): BOOL;
 external advapi32dll name 'OpenProcessToken';

function OpenThreadToken conv arg_stdcall (ThreadHandle: THandle; DesiredAccess: DWORD; OpenAsSelf: BOOL; var TokenHandle: THandle): BOOL;
 external advapi32dll name 'OpenThreadToken';

function PrivilegeCheck conv arg_stdcall (ClientToken: THandle; const RequiredPrivileges: TPrivilegeSet; var pfResult: BOOL): BOOL;
 external advapi32dll name 'PrivilegeCheck';

function PrivilegedServiceAuditAlarmA conv arg_stdcall (SubsystemName, ServiceName: PAnsiChar;
 ClientToken: THandle; var Privileges: TPrivilegeSet; AccessGranted: BOOL): BOOL;
 external advapi32dll name 'PrivilegedServiceAuditAlarmA';

function PrivilegedServiceAuditAlarmW conv arg_stdcall (SubsystemName, ServiceName: PWideChar;
 ClientToken: THandle; var Privileges: TPrivilegeSet; AccessGranted: BOOL): BOOL;
 external advapi32dll name 'PrivilegedServiceAuditAlarmW';

function PrivilegedServiceAuditAlarm conv arg_stdcall (SubsystemName, ServiceName: PChar;
 ClientToken: THandle; var Privileges: TPrivilegeSet; AccessGranted: BOOL): BOOL;
 external advapi32dll name 'PrivilegedServiceAuditAlarmA';

function ReadEventLogA conv arg_stdcall (hEventLog: THandle; dwReadFlags, dwRecordOffset: DWORD;
 lpBuffer: Pointer; nNumberOfBytesToRead: DWORD; var pnBytesRead, pnMinNumberOfBytesNeeded: DWORD): BOOL;
 external advapi32dll name 'ReadEventLogA';

function ReadEventLogW conv arg_stdcall (hEventLog: THandle; dwReadFlags, dwRecordOffset: DWORD;
 lpBuffer: Pointer; nNumberOfBytesToRead: DWORD; var pnBytesRead, pnMinNumberOfBytesNeeded: DWORD): BOOL;
 external advapi32dll name 'ReadEventLogW';

function ReadEventLog conv arg_stdcall (hEventLog: THandle; dwReadFlags, dwRecordOffset: DWORD;
 lpBuffer: Pointer; nNumberOfBytesToRead: DWORD; var pnBytesRead, pnMinNumberOfBytesNeeded: DWORD): BOOL;
 external advapi32dll name 'ReadEventLogA';

function RegCloseKey conv arg_stdcall (hKey: HKEY): Longint;
 external advapi32dll name 'RegCloseKey';

function RegConnectRegistryA conv arg_stdcall (lpMachineName: PAnsiChar; hKey: HKEY; var phkResult: HKEY): Longint;
 external advapi32dll name 'RegConnectRegistryA';

function RegConnectRegistryW conv arg_stdcall (lpMachineName: PWideChar; hKey: HKEY; var phkResult: HKEY): Longint;
 external advapi32dll name 'RegConnectRegistryW';

function RegConnectRegistry conv arg_stdcall (lpMachineName: PChar; hKey: HKEY; var phkResult: HKEY): Longint;
 external advapi32dll name 'RegConnectRegistryA';

function RegCreateKeyA conv arg_stdcall (hKey: HKEY; lpSubKey: PAnsiChar; var phkResult: HKEY): Longint;
 external advapi32dll name 'RegCreateKeyA';

function RegCreateKeyW conv arg_stdcall (hKey: HKEY; lpSubKey: PWideChar; var phkResult: HKEY): Longint;
 external advapi32dll name 'RegCreateKeyW';

function RegCreateKey conv arg_stdcall (hKey: HKEY; lpSubKey: PChar; var phkResult: HKEY): Longint;
 external advapi32dll name 'RegCreateKeyA';

function RegCreateKeyExA conv arg_stdcall (hKey: HKEY; lpSubKey: PAnsiChar; Reserved: DWORD; lpClass: PAnsiChar; dwOptions: DWORD; samDesired: REGSAM;
 lpSecurityAttributes: PSecurityAttributes; var phkResult: HKEY; lpdwDisposition: PDWORD): Longint;
 external advapi32dll name 'RegCreateKeyExA';

function RegCreateKeyExW conv arg_stdcall (hKey: HKEY; lpSubKey: PWideChar; Reserved: DWORD; lpClass: PWideChar; dwOptions: DWORD; samDesired: REGSAM;
 lpSecurityAttributes: PSecurityAttributes; var phkResult: HKEY; lpdwDisposition: PDWORD): Longint;
 external advapi32dll name 'RegCreateKeyExW';

function RegCreateKeyEx conv arg_stdcall (hKey: HKEY; lpSubKey: PChar; Reserved: DWORD; lpClass: PChar; dwOptions: DWORD; samDesired: REGSAM;
 lpSecurityAttributes: PSecurityAttributes; var phkResult: HKEY; lpdwDisposition: PDWORD): Longint;
 external advapi32dll name 'RegCreateKeyExA';

function RegDeleteKeyA conv arg_stdcall (hKey: HKEY; lpSubKey: PAnsiChar): Longint;
 external advapi32dll name 'RegDeleteKeyA';

function RegDeleteKeyW conv arg_stdcall (hKey: HKEY; lpSubKey: PWideChar): Longint;
 external advapi32dll name 'RegDeleteKeyW';

function RegDeleteKey conv arg_stdcall (hKey: HKEY; lpSubKey: PChar): Longint;
 external advapi32dll name 'RegDeleteKeyA';

function RegDeleteValueA conv arg_stdcall (hKey: HKEY; lpValueName: PAnsiChar): Longint;
 external advapi32dll name 'RegDeleteValueA';

function RegDeleteValueW conv arg_stdcall (hKey: HKEY; lpValueName: PWideChar): Longint;
 external advapi32dll name 'RegDeleteValueW';

function RegDeleteValue conv arg_stdcall (hKey: HKEY; lpValueName: PChar): Longint;
 external advapi32dll name 'RegDeleteValueA';

function RegEnumKeyA conv arg_stdcall (hKey: HKEY; dwIndex: DWORD; lpName: PAnsiChar; cbName: DWORD): Longint;
 external advapi32dll name 'RegEnumKeyA';

function RegEnumKeyW conv arg_stdcall (hKey: HKEY; dwIndex: DWORD; lpName: PWideChar; cbName: DWORD): Longint;
 external advapi32dll name 'RegEnumKeyW';

function RegEnumKey conv arg_stdcall (hKey: HKEY; dwIndex: DWORD; lpName: PChar; cbName: DWORD): Longint;
 external advapi32dll name 'RegEnumKeyA';

function RegEnumKeyExA conv arg_stdcall (hKey: HKEY; dwIndex: DWORD; lpName: PAnsiChar;
 var lpcbName: DWORD; lpReserved: Pointer; lpClass: PAnsiChar;
 lpcbClass: PDWORD; lpftLastWriteTime: PFileTime): Longint;
 external advapi32dll name 'RegEnumKeyExA';

function RegEnumKeyExW conv arg_stdcall (hKey: HKEY; dwIndex: DWORD; lpName: PWideChar;
 var lpcbName: DWORD; lpReserved: Pointer; lpClass: PWideChar;
 lpcbClass: PDWORD; lpftLastWriteTime: PFileTime): Longint;
 external advapi32dll name 'RegEnumKeyExW';

function RegEnumKeyEx conv arg_stdcall (hKey: HKEY; dwIndex: DWORD; lpName: PChar;
 var lpcbName: DWORD; lpReserved: Pointer; lpClass: PChar;
 lpcbClass: PDWORD; lpftLastWriteTime: PFileTime): Longint;
 external advapi32dll name 'RegEnumKeyExA';

function RegEnumValueA conv arg_stdcall (hKey: HKEY; dwIndex: DWORD; lpValueName: PChar;
 var lpcbValueName: DWORD; lpReserved: Pointer; lpType: PDWORD;
 lpData: PByte; lpcbData: PDWORD): Longint;
 external advapi32dll name 'RegEnumValueA';

function RegEnumValueW conv arg_stdcall (hKey: HKEY; dwIndex: DWORD; lpValueName: PChar;
 var lpcbValueName: DWORD; lpReserved: Pointer; lpType: PDWORD;
 lpData: PByte; lpcbData: PDWORD): Longint;
 external advapi32dll name 'RegEnumValueW';

function RegEnumValue conv arg_stdcall (hKey: HKEY; dwIndex: DWORD; lpValueName: PChar;
 var lpcbValueName: DWORD; lpReserved: Pointer; lpType: PDWORD;
 lpData: PByte; lpcbData: PDWORD): Longint;
 external advapi32dll name 'RegEnumValueA';

function RegFlushKey conv arg_stdcall (hKey: HKEY): Longint;
 external advapi32dll name 'RegFlushKey';

function RegGetKeySecurity conv arg_stdcall (hKey: HKEY; SecurityInformation: SECURITY_INFORMATION;
 pSecurityDescriptor: PSecurityDescriptor; var lpcbSecurityDescriptor: DWORD): Longint;
 external advapi32dll name 'RegGetKeySecurity';

function RegLoadKeyA conv arg_stdcall (hKey: HKEY; lpSubKey, lpFile: PAnsiChar): Longint;
 external advapi32dll name 'RegLoadKeyA';

function RegLoadKeyW conv arg_stdcall (hKey: HKEY; lpSubKey, lpFile: PWideChar): Longint;
 external advapi32dll name 'RegLoadKeyW';

function RegLoadKey conv arg_stdcall (hKey: HKEY; lpSubKey, lpFile: PChar): Longint;
 external advapi32dll name 'RegLoadKeyA';

function RegNotifyChangeKeyValue conv arg_stdcall (hKey: HKEY; bWatchSubtree: BOOL;
 dwNotifyFilter: DWORD; hEvent: THandle; fAsynchronus: BOOL): Longint;
 external advapi32dll name 'RegNotifyChangeKeyValue';

function RegOpenKeyA conv arg_stdcall (hKey: HKEY; lpSubKey: PAnsiChar; var phkResult: HKEY): Longint;
 external advapi32dll name 'RegOpenKeyA';

function RegOpenKeyW conv arg_stdcall (hKey: HKEY; lpSubKey: PWideChar; var phkResult: HKEY): Longint;
 external advapi32dll name 'RegOpenKeyW';

function RegOpenKey conv arg_stdcall (hKey: HKEY; lpSubKey: PChar; var phkResult: HKEY): Longint;
 external advapi32dll name 'RegOpenKeyA';

function RegOpenKeyExA conv arg_stdcall (hKey: HKEY; lpSubKey: PAnsiChar; ulOptions: DWORD; samDesired: REGSAM; var phkResult: HKEY): Longint;
 external advapi32dll name 'RegOpenKeyExA';

function RegOpenKeyExW conv arg_stdcall (hKey: HKEY; lpSubKey: PWideChar; ulOptions: DWORD; samDesired: REGSAM; var phkResult: HKEY): Longint;
 external advapi32dll name 'RegOpenKeyExW';

function RegOpenKeyEx conv arg_stdcall (hKey: HKEY; lpSubKey: PChar; ulOptions: DWORD; samDesired: REGSAM; var phkResult: HKEY): Longint;
 external advapi32dll name 'RegOpenKeyExA';

function RegQueryInfoKeyA conv arg_stdcall (hKey: HKEY; lpClass: PChar; lpcbClass: PDWORD; lpReserved: Pointer;
 lpcSubKeys, lpcbMaxSubKeyLen, lpcbMaxClassLen, lpcValues,
 lpcbMaxValueNameLen, lpcbMaxValueLen, lpcbSecurityDescriptor: PDWORD;
 lpftLastWriteTime: PFileTime): Longint;
 external advapi32dll name 'RegQueryInfoKeyA';

function RegQueryInfoKeyW conv arg_stdcall (hKey: HKEY; lpClass: PChar; lpcbClass: PDWORD; lpReserved: Pointer;
 lpcSubKeys, lpcbMaxSubKeyLen, lpcbMaxClassLen, lpcValues,
 lpcbMaxValueNameLen, lpcbMaxValueLen, lpcbSecurityDescriptor: PDWORD;
 lpftLastWriteTime: PFileTime): Longint;
 external advapi32dll name 'RegQueryInfoKeyW';

function RegQueryInfoKey conv arg_stdcall (hKey: HKEY; lpClass: PChar; lpcbClass: PDWORD; lpReserved: Pointer;
 lpcSubKeys, lpcbMaxSubKeyLen, lpcbMaxClassLen, lpcValues,
 lpcbMaxValueNameLen, lpcbMaxValueLen, lpcbSecurityDescriptor: PDWORD;
 lpftLastWriteTime: PFileTime): Longint;
 external advapi32dll name 'RegQueryInfoKeyA';

function RegQueryMultipleValuesA conv arg_stdcall (hKey: HKEY; var ValList;
 NumVals: DWORD; lpValueBuf: PAnsiChar; var ldwTotsize: DWORD): Longint;
 external advapi32dll name 'RegQueryMultipleValuesA';

function RegQueryMultipleValuesW conv arg_stdcall (hKey: HKEY; var ValList;
 NumVals: DWORD; lpValueBuf: PWideChar; var ldwTotsize: DWORD): Longint;
 external advapi32dll name 'RegQueryMultipleValuesW';

function RegQueryMultipleValues conv arg_stdcall (hKey: HKEY; var ValList;
 NumVals: DWORD; lpValueBuf: PChar; var ldwTotsize: DWORD): Longint;
 external advapi32dll name 'RegQueryMultipleValuesA';

function RegQueryValueA conv arg_stdcall (hKey: HKEY; lpSubKey: PAnsiChar; lpValue: PAnsiChar; var lpcbValue: Longint): Longint;
 external advapi32dll name 'RegQueryValueA';

function RegQueryValueW conv arg_stdcall (hKey: HKEY; lpSubKey: PWideChar; lpValue: PWideChar; var lpcbValue: Longint): Longint;
 external advapi32dll name 'RegQueryValueW';

function RegQueryValue conv arg_stdcall (hKey: HKEY; lpSubKey: PChar; lpValue: PChar; var lpcbValue: Longint): Longint;
 external advapi32dll name 'RegQueryValueA';

function RegQueryValueExA conv arg_stdcall (hKey: HKEY; lpValueName: PAnsiChar;
 lpReserved: Pointer; lpType: PDWORD; lpData: PByte; lpcbData: PDWORD): Longint;
 external advapi32dll name 'RegQueryValueExA';

function RegQueryValueExW conv arg_stdcall (hKey: HKEY; lpValueName: PWideChar;
 lpReserved: Pointer; lpType: PDWORD; lpData: PByte; lpcbData: PDWORD): Longint;
 external advapi32dll name 'RegQueryValueExW';

function RegQueryValueEx conv arg_stdcall (hKey: HKEY; lpValueName: PChar;
 lpReserved: Pointer; lpType: PDWORD; lpData: PByte; lpcbData: PDWORD): Longint;
 external advapi32dll name 'RegQueryValueExA';

function RegReplaceKeyA conv arg_stdcall (hKey: HKEY; lpSubKey: PAnsiChar; lpNewFile: PAnsiChar; lpOldFile: PAnsiChar): Longint;
 external advapi32dll name 'RegReplaceKeyA';

function RegReplaceKeyW conv arg_stdcall (hKey: HKEY; lpSubKey: PWideChar; lpNewFile: PWideChar; lpOldFile: PWideChar): Longint;
 external advapi32dll name 'RegReplaceKeyW';

function RegReplaceKey conv arg_stdcall (hKey: HKEY; lpSubKey: PChar; lpNewFile: PChar; lpOldFile: PChar): Longint;
 external advapi32dll name 'RegReplaceKeyA';

function RegRestoreKeyA conv arg_stdcall (hKey: HKEY; lpFile: PAnsiChar; dwFlags: DWORD): Longint;
 external advapi32dll name 'RegRestoreKeyA';

function RegRestoreKeyW conv arg_stdcall (hKey: HKEY; lpFile: PWideChar; dwFlags: DWORD): Longint;
 external advapi32dll name 'RegRestoreKeyW';

function RegRestoreKey conv arg_stdcall (hKey: HKEY; lpFile: PChar; dwFlags: DWORD): Longint;
 external advapi32dll name 'RegRestoreKeyA';

function RegSaveKeyA conv arg_stdcall (hKey: HKEY; lpFile: PAnsiChar; lpSecurityAttributes: PSecurityAttributes): Longint;
 external advapi32dll name 'RegSaveKeyA';

function RegSaveKeyW conv arg_stdcall (hKey: HKEY; lpFile: PWideChar; lpSecurityAttributes: PSecurityAttributes): Longint;
 external advapi32dll name 'RegSaveKeyW';

function RegSaveKey conv arg_stdcall (hKey: HKEY; lpFile: PChar; lpSecurityAttributes: PSecurityAttributes): Longint;
 external advapi32dll name 'RegSaveKeyA';

function RegSetKeySecurity conv arg_stdcall (hKey: HKEY; SecurityInformation: SECURITY_INFORMATION;
 pSecurityDescriptor: PSECURITY_DESCRIPTOR): Longint;
 external advapi32dll name 'RegSetKeySecurity';

function RegSetValueA conv arg_stdcall (hKey: HKEY; lpSubKey: PAnsiChar; dwType: DWORD; lpData: PAnsiChar; cbData: DWORD): Longint;
 external advapi32dll name 'RegSetValueA';

function RegSetValueW conv arg_stdcall (hKey: HKEY; lpSubKey: PWideChar; dwType: DWORD; lpData: PWideChar; cbData: DWORD): Longint;
 external advapi32dll name 'RegSetValueW';

function RegSetValue conv arg_stdcall (hKey: HKEY; lpSubKey: PChar; dwType: DWORD; lpData: PChar; cbData: DWORD): Longint;
 external advapi32dll name 'RegSetValueA';

function RegSetValueExA conv arg_stdcall (hKey: HKEY; lpValueName: PAnsiChar;
Reserved: DWORD; dwType: DWORD; lpData: Pointer; cbData: DWORD): Longint;
external advapi32dll name 'RegSetValueExA';

function RegSetValueExW conv arg_stdcall (hKey: HKEY; lpValueName: PWideChar;
 Reserved: DWORD; dwType: DWORD; lpData: Pointer; cbData: DWORD): Longint;
 external advapi32dll name 'RegSetValueExW';

function RegSetValueEx conv arg_stdcall (hKey: HKEY; lpValueName: PChar;
 Reserved: DWORD; dwType: DWORD; lpData: Pointer; cbData: DWORD): Longint;
 external advapi32dll name 'RegSetValueExA';

function RegUnLoadKeyA conv arg_stdcall (hKey: HKEY; lpSubKey: PAnsiChar): Longint;
external advapi32dll name 'RegUnLoadKeyA';

function RegUnLoadKeyW conv arg_stdcall (hKey: HKEY; lpSubKey: PWideChar): Longint;
external advapi32dll name 'RegUnLoadKeyW';

function RegUnLoadKey conv arg_stdcall (hKey: HKEY; lpSubKey: PChar): Longint;
 external advapi32dll name 'RegUnLoadKeyA';

function RegisterEventSourceA conv arg_stdcall (lpUNCServerName, lpSourceName: PAnsiChar): THandle;
external advapi32dll name 'RegisterEventSourceA';

function RegisterEventSourceW conv arg_stdcall (lpUNCServerName, lpSourceName: PWideChar): THandle;
 external advapi32dll name 'RegisterEventSourceW';

function RegisterEventSource conv arg_stdcall (lpUNCServerName, lpSourceName: PChar): THandle;
 external advapi32dll name 'RegisterEventSourceA';

function ReportEventA conv arg_stdcall (hEventLog: THandle; wType, wCategory: Word;
 dwEventID: DWORD; lpUserSid: Pointer; wNumStrings: Word; dwDataSize: DWORD; lpStrings, lpRawData: Pointer): BOOL;
 external advapi32dll name 'ReportEventA';

function ReportEventW conv arg_stdcall (hEventLog: THandle; wType, wCategory: Word;
 dwEventID: DWORD; lpUserSid: Pointer; wNumStrings: Word; dwDataSize: DWORD; lpStrings, lpRawData: Pointer): BOOL;
 external advapi32dll name 'ReportEventW';

function ReportEvent conv arg_stdcall (hEventLog: THandle; wType, wCategory: Word;
 dwEventID: DWORD; lpUserSid: Pointer; wNumStrings: Word; dwDataSize: DWORD; lpStrings, lpRawData: Pointer): BOOL;
 external advapi32dll name 'ReportEventA';

function RevertToSelf: BOOL;
 external advapi32dll name 'RevertToSelf';

function SetAclInformation conv arg_stdcall (var pAcl: TACL; pAclInformation: Pointer;
 nAclInformationLength: DWORD; dwAclInformationClass: TAclInformationClass): BOOL;
 external advapi32dll name 'SetAclInformation';

function SetFileSecurityA conv arg_stdcall (lpFileName: PAnsiChar; SecurityInformation: SECURITY_INFORMATION;
 pSecurityDescriptor: PSecurityDescriptor): BOOL;
 external advapi32dll name 'SetFileSecurityA';

function SetFileSecurityW conv arg_stdcall (lpFileName: PWideChar; SecurityInformation: SECURITY_INFORMATION;
 pSecurityDescriptor: PSecurityDescriptor): BOOL;
 external advapi32dll name 'SetFileSecurityW';

function SetFileSecurity conv arg_stdcall (lpFileName: PChar; SecurityInformation: SECURITY_INFORMATION;
 pSecurityDescriptor: PSecurityDescriptor): BOOL;
 external advapi32dll name 'SetFileSecurityA';

function SetKernelObjectSecurity conv arg_stdcall (Handle: THandle; SecurityInformation: SECURITY_INFORMATION;
 SecurityDescriptor: PSecurityDescriptor): BOOL;
 external advapi32dll name 'SetKernelObjectSecurity';

function SetPrivateObjectSecurity conv arg_stdcall (SecurityInformation: SECURITY_INFORMATION;
 ModificationDescriptor: PSecurityDescriptor; var ObjectsSecurityDescriptor: PSecurityDescriptor;
 const GenericMapping: TGenericMapping; Token: THandle): BOOL;
 external advapi32dll name 'SetPrivateObjectSecurity';

function SetSecurityDescriptorDacl conv arg_stdcall (pSecurityDescriptor: PSecurityDescriptor;
 bDaclPresent: BOOL; pDacl: PACL; bDaclDefaulted: BOOL): BOOL;
 external advapi32dll name 'SetSecurityDescriptorDacl';

function SetSecurityDescriptorGroup conv arg_stdcall (pSecurityDescriptor: PSecurityDescriptor;
 pGroup: PSID; bGroupDefaulted: BOOL): BOOL;
 external advapi32dll name 'SetSecurityDescriptorGroup';

function SetSecurityDescriptorOwner conv arg_stdcall (pSecurityDescriptor: PSecurityDescriptor;
 pOwner: PSID; bOwnerDefaulted: BOOL): BOOL;
 external advapi32dll name 'SetSecurityDescriptorOwner';

function SetSecurityDescriptorSacl conv arg_stdcall (pSecurityDescriptor: PSecurityDescriptor;
 bSaclPresent: BOOL; pSacl: PACL; bSaclDefaulted: BOOL): BOOL;
 external advapi32dll name 'SetSecurityDescriptorSacl';

function SetThreadToken conv arg_stdcall (Thread: PHandle; Token: THandle): BOOL;
 external advapi32dll name 'SetThreadToken';

function SetTokenInformation conv arg_stdcall (TokenHandle: THandle; TokenInformationClass: TTokenInformationClass; TokenInformation: Pointer;
 TokenInformationLength: DWORD): BOOL;
 external advapi32dll name 'SetTokenInformation';

///////////////////////// USER32.DLL IMPORT SECTION ///////////////////////////

function ActivateKeyboardLayout conv arg_stdcall (hkl: HKL; Flags: DWORD): HKL;
 external user32dll name 'ActivateKeyboardLayout';

function AdjustWindowRect conv arg_stdcall (var lpRect: TRect; dwStyle: DWORD; bMenu: BOOL): BOOL;
 external user32dll name 'AdjustWindowRect';

function AdjustWindowRectEx conv arg_stdcall (var lpRect: TRect; dwStyle: DWORD; bMenu: BOOL; dwExStyle: DWORD): BOOL;
 external user32dll name 'AdjustWindowRectEx';

function AnsiToOem conv arg_stdcall (const lpszSrc: LPCSTR; lpszDst: LPSTR): BOOL;
 external user32dll name 'CharToOemA';

function AnsiToOemBuff conv arg_stdcall (lpszSrc: LPCSTR; lpszDst: LPSTR; cchDstLength: DWORD): BOOL;
 external user32dll name 'CharToOemBuffA';

function AnsiUpper conv arg_stdcall (lpsz: LPSTR): LPSTR;
 external user32dll name 'CharUpperA';

function AnsiUpperBuff conv arg_stdcall (lpsz: LPSTR; cchLength: DWORD): DWORD;
 external user32dll name 'CharUpperBuffA';

function AnsiLower conv arg_stdcall (lpsz: LPSTR): LPSTR;
 external user32dll name 'CharLowerA';

function AnsiLowerBuff conv arg_stdcall (lpsz: LPSTR; cchLength: DWORD): DWORD;
 external user32dll name 'CharLowerBuffA';

function AnsiNext conv arg_stdcall (const lpsz: LPCSTR): LPSTR;
 external user32dll name 'CharNextA';

function AnsiPrev conv arg_stdcall (const lpszStart: LPCSTR; const lpszCurrent: LPCSTR): LPSTR;
 external user32dll name 'CharPrevA';

function AnyPopup: BOOL;
 external user32dll name 'AnyPopup';

function AppendMenuA conv arg_stdcall (hMenu: HMENU; uFlags, uIDNewItem: DWORD; lpNewItem: PAnsiChar): BOOL;
external user32dll name 'AppendMenuA';

function AppendMenuW conv arg_stdcall (hMenu: HMENU; uFlags, uIDNewItem: DWORD; lpNewItem: PWideChar): BOOL;
external user32dll name 'AppendMenuW';

function AppendMenu conv arg_stdcall (hMenu: HMENU; uFlags, uIDNewItem: DWORD; lpNewItem: PChar): BOOL;
 external user32dll name 'AppendMenuA';

function ArrangeIconicWindows conv arg_stdcall (hWnd: HWND): DWORD;
 external user32dll name 'ArrangeIconicWindows';

function AttachThreadInput conv arg_stdcall (idAttach, idAttachTo: DWORD; fAttach: BOOL): BOOL;
 external user32dll name 'AttachThreadInput';

function BeginDeferWindowPos conv arg_stdcall (nNumWindows: DWORD): HDWP;
 external user32dll name 'BeginDeferWindowPos';

function BeginPaint conv arg_stdcall (hWnd: HWND; var lpPaint: TPaintStruct): HDC;
 external user32dll name 'BeginPaint';

function BringWindowToTop conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'BringWindowToTop';

function BroadcastSystemMessageA conv arg_stdcall (Flags: DWORD; Recipients: PDWORD;
 uiMessage: DWORD; wParam: WPARAM; lParam: LPARAM): Longint;
 external user32dll name 'BroadcastSystemMessageA';

function BroadcastSystemMessageW conv arg_stdcall (Flags: DWORD; Recipients: PDWORD;
 uiMessage: DWORD; wParam: WPARAM; lParam: LPARAM): Longint;
 external user32dll name 'BroadcastSystemMessageW';

function BroadcastSystemMessage conv arg_stdcall (Flags: DWORD; Recipients: PDWORD;
 uiMessage: DWORD; wParam: WPARAM; lParam: LPARAM): Longint;
 external user32dll name 'BroadcastSystemMessage';

function CallMsgFilterA conv arg_stdcall (var lpMsg: TMsg; nCode: DWORD): BOOL;
 external user32dll name 'CallMsgFilterA';

function CallMsgFilterW conv arg_stdcall (var lpMsg: TMsg; nCode: DWORD): BOOL;
 external user32dll name 'CallMsgFilterW';

function CallMsgFilter conv arg_stdcall (var lpMsg: TMsg; nCode: DWORD): BOOL;
 external user32dll name 'CallMsgFilterA';

function CallNextHookEx conv arg_stdcall (hhk: HHOOK; nCode: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'CallNextHookEx';

function CallWindowProcA conv arg_stdcall (lpPrevWndFunc: TFNWndProc; hWnd: HWND; Msg: DWORD;
 wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'CallWindowProcA';

function CallWindowProcW conv arg_stdcall (lpPrevWndFunc: TFNWndProc; hWnd: HWND; Msg: DWORD;
 wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'CallWindowProcW';

function CallWindowProc conv arg_stdcall (lpPrevWndFunc: TFNWndProc; hWnd: HWND; Msg: DWORD;
 wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'CallWindowProcA';

function CascadeWindows conv arg_stdcall (hwndParent: HWND; wHow: DWORD; lpRect: PRect;
 cKids: DWORD; lpKids: Pointer): Word;
 external user32dll name 'CascadeWindows';

function ChangeClipboardChain conv arg_stdcall (hWndRemove, hWndNewNext: HWND): BOOL;
 external user32dll name 'ChangeClipboardChain';

function ChangeDisplaySettingsA conv arg_stdcall (var lpDevMode: TDeviceModeA; dwFlags: DWORD): Longint;
 external user32dll name 'ChangeDisplaySettingsA';

function ChangeDisplaySettingsW conv arg_stdcall (var lpDevMode: TDeviceModeW; dwFlags: DWORD): Longint;
 external user32dll name 'ChangeDisplaySettingsW';

function ChangeDisplaySettings conv arg_stdcall (var lpDevMode: TDeviceMode; dwFlags: DWORD): Longint;
 external user32dll name 'ChangeDisplaySettingsA';

function ChangeDisplaySettingsExA conv arg_stdcall (lpszDeviceName: PAnsiChar; var lpDevMode: TDeviceModeA;
 wnd: HWND; dwFlags: DWORD; lParam: Pointer): Longint;
 external user32dll name 'ChangeDisplaySettingsExA';

function ChangeDisplaySettingsExW conv arg_stdcall (lpszDeviceName: PWideChar; var lpDevMode: TDeviceModeW;
 wnd: HWND; dwFlags: DWORD; lParam: Pointer): Longint;
 external user32dll name 'ChangeDisplaySettingsExW';

function ChangeDisplaySettingsEx conv arg_stdcall (lpszDeviceName: PChar; var lpDevMode: TDeviceMode;
 wnd: HWND; dwFlags: DWORD; lParam: Pointer): Longint;
 external user32dll name 'ChangeDisplaySettingsExA';

function ChangeMenuA conv arg_stdcall (hMenu: HMENU; cmd: DWORD; lpszNewItem: PAnsiChar;
 cmdInsert: DWORD; flags: DWORD): BOOL;
 external user32dll name 'ChangeMenuA';

function ChangeMenuW conv arg_stdcall (hMenu: HMENU; cmd: DWORD; lpszNewItem: PWideChar;
 cmdInsert: DWORD; flags: DWORD): BOOL;
 external user32dll name 'ChangeMenuW';

function ChangeMenu conv arg_stdcall (hMenu: HMENU; cmd: DWORD; lpszNewItem: PChar;
 cmdInsert: DWORD; flags: DWORD): BOOL;
 external user32dll name 'ChangeMenuA';

function CharLowerA conv arg_stdcall (lpsz: PAnsiChar): PAnsiChar;
external user32dll name 'CharLowerA';

function CharLowerW conv arg_stdcall (lpsz: PWideChar): PWideChar;
external user32dll name 'CharLowerW';

function CharLower conv arg_stdcall (lpsz: PChar): PChar;
 external user32dll name 'CharLowerA';

function CharLowerBuffA conv arg_stdcall (lpsz: PAnsiChar; cchLength: DWORD): DWORD;
external user32dll name 'CharLowerBuffA';

function CharLowerBuffW conv arg_stdcall (lpsz: PWideChar; cchLength: DWORD): DWORD;
 external user32dll name 'CharLowerBuffW';

function CharLowerBuff conv arg_stdcall (lpsz: PChar; cchLength: DWORD): DWORD;
 external user32dll name 'CharLowerBuffA';

function CharNextA conv arg_stdcall (lpsz: PAnsiChar): PAnsiChar;
external user32dll name 'CharNextA';

function CharNextW conv arg_stdcall (lpsz: PWideChar): PWideChar;
external user32dll name 'CharNextW';

function CharNext conv arg_stdcall (lpsz: PChar): PChar;
 external user32dll name 'CharNextA';

function CharNextEx conv arg_stdcall (CodePage: Word; lpCurrentChar: LPCSTR; dwFlags: DWORD): LPSTR;
 external user32dll name 'CharNextExA';

function CharPrevA conv arg_stdcall (lpszStart: PAnsiChar; lpszCurrent: PAnsiChar): PAnsiChar;
external user32dll name 'CharPrevA';

function CharPrevW conv arg_stdcall (lpszStart: PWideChar; lpszCurrent: PWideChar): PWideChar;
external user32dll name 'CharPrevW';

function CharPrev conv arg_stdcall (lpszStart: PChar; lpszCurrent: PChar): PChar;
 external user32dll name 'CharPrevA';

function CharPrevEx conv arg_stdcall (CodePage: Word; lpStart, lpCurrentChar: LPCSTR; dwFlags: DWORD): LPSTR;
 external user32dll name 'CharPrevExA';

function CharToOemA conv arg_stdcall (lpszSrc: PAnsiChar; lpszDst: PAnsiChar): BOOL;
external user32dll name 'CharToOemA';

function CharToOemW conv arg_stdcall (lpszSrc: PWideChar; lpszDst: PWideChar): BOOL;
external user32dll name 'CharToOemW';

function CharToOem conv arg_stdcall (lpszSrc: PChar; lpszDst: PChar): BOOL;
 external user32dll name 'CharToOemA';

function CharToOemBuffA conv arg_stdcall (lpszSrc: PAnsiChar; lpszDst: PAnsiChar; cchDstLength: DWORD): BOOL;
external user32dll name 'CharToOemBuffA';

function CharToOemBuffW conv arg_stdcall (lpszSrc: PWideChar; lpszDst: PWideChar; cchDstLength: DWORD): BOOL;
external user32dll name 'CharToOemBuffW';

function CharToOemBuff conv arg_stdcall (lpszSrc: PChar; lpszDst: PChar; cchDstLength: DWORD): BOOL;
 external user32dll name 'CharToOemBuffA';

function CharUpperA conv arg_stdcall (lpsz: PAnsiChar): PAnsiChar;
external user32dll name 'CharUpperA';

function CharUpperW conv arg_stdcall (lpsz: PWideChar): PWideChar;
external user32dll name 'CharUpperW';

function CharUpper conv arg_stdcall (lpsz: PChar): PChar;
 external user32dll name 'CharUpperA';

function CharUpperBuffA conv arg_stdcall (lpsz: PAnsiChar; cchLength: DWORD): DWORD;
external user32dll name 'CharUpperBuffA';

function CharUpperBuffW conv arg_stdcall (lpsz: PWideChar; cchLength: DWORD): DWORD;
 external user32dll name 'CharUpperBuffW';

function CharUpperBuff conv arg_stdcall (lpsz: PChar; cchLength: DWORD): DWORD;
 external user32dll name 'CharUpperBuffA';

function CheckDlgButton conv arg_stdcall (hDlg: HWND; nIDButton: DWORD; uCheck: DWORD): BOOL;
 external user32dll name 'CheckDlgButton';

function CheckMenuItem conv arg_stdcall (hMenu: HMENU; uIDCheckItem, uCheck: DWORD): DWORD;
 external user32dll name 'CheckMenuItem';

function CheckMenuRadioItem conv arg_stdcall (hMenu: HMENU; First, Last, Check, Flags: DWORD): BOOL;
 external user32dll name 'CheckMenuRadioItem';

function CheckRadioButton conv arg_stdcall (hDlg: HWND; nIDFirstButton, nIDLastButton, nIDCheckButton: DWORD): BOOL;
 external user32dll name 'CheckRadioButton';

function ChildWindowFromPoint conv arg_stdcall (hWndParent: HWND; Point: TPoint): HWND;
 external user32dll name 'ChildWindowFromPoint';

function ChildWindowFromPointEx conv arg_stdcall (hWnd: HWND; Point: TPoint; Flags: DWORD): HWND;
 external user32dll name 'ChildWindowFromPointEx';

function ClientToScreen conv arg_stdcall (hWnd: HWND; var lpPoint: TPoint): BOOL;
 external user32dll name 'ClientToScreen';

function ClipCursor conv arg_stdcall (lpRect: TRect): BOOL;
 external user32dll name 'ClipCursor';

function CloseClipboard: BOOL;
 external user32dll name 'CloseClipboard';

function CloseDesktop conv arg_stdcall (hDesktop: HDESK): BOOL;
 external user32dll name 'CloseDesktop';

function CloseWindow conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'CloseWindow';

function CloseWindowStation conv arg_stdcall (hWinSta: HWINSTA): BOOL;
 external user32dll name 'CloseWindowStation';

function CopyAcceleratorTableA conv arg_stdcall (hAccelSrc: HACCEL; var lpAccelDst; cAccelEntries: DWORD): DWORD;
 external user32dll name 'CopyAcceleratorTableA';

function CopyAcceleratorTableW conv arg_stdcall (hAccelSrc: HACCEL; var lpAccelDst; cAccelEntries: DWORD): DWORD;
 external user32dll name 'CopyAcceleratorTableW';

function CopyAcceleratorTable conv arg_stdcall (hAccelSrc: HACCEL; var lpAccelDst; cAccelEntries: DWORD): DWORD;
 external user32dll name 'CopyAcceleratorTableA';

function CopyIcon conv arg_stdcall (hIcon: HICON): HICON;
 external user32dll name 'CopyIcon';

function CopyImage conv arg_stdcall (hImage: THandle; ImageType: DWORD; X, Y: DWORD; Flags: DWORD): THandle;
 external user32dll name 'CopyImage';

function CopyRect conv arg_stdcall (var lprcDst: TRect; const lprcSrc: TRect): BOOL;
 external user32dll name 'CopyRect';

function CountClipboardFormats: DWORD;
 external user32dll name 'CountClipboardFormats';

function CreateAcceleratorTableA conv arg_stdcall (var Accel; Count: DWORD): HACCEL;
 external user32dll name 'CreateAcceleratorTableA';

function CreateAcceleratorTableW conv arg_stdcall (var Accel; Count: DWORD): HACCEL;
 external user32dll name 'CreateAcceleratorTableW';

function CreateAcceleratorTable conv arg_stdcall (var Accel; Count: DWORD): HACCEL;
 external user32dll name 'CreateAcceleratorTableA';

function CreateCaret conv arg_stdcall (hWnd: HWND; hBitmap: HBITMAP; nWidth, nHeight: DWORD): BOOL;
 external user32dll name 'CreateCaret';

function CreateCursor conv arg_stdcall (hInst: HINST; xHotSpot, yHotSpot, nWidth, nHeight: DWORD;
 pvANDPlaneter, pvXORPlane: Pointer): HCURSOR;
 external user32dll name 'CreateCursor';

function CreateDesktopA conv arg_stdcall (lpszDesktop, lpszDevice: PAnsiChar; pDevmode: PDeviceModeA; dwFlags: DWORD; dwDesiredAccess:
 DWORD; lpsa: PSecurityAttributes): HDESK;
 external user32dll name 'CreateDesktopA';

function CreateDesktopW conv arg_stdcall (lpszDesktop, lpszDevice: PWideChar; pDevmode: PDeviceModeW; dwFlags: DWORD; dwDesiredAccess:
 DWORD; lpsa: PSecurityAttributes): HDESK;
 external user32dll name 'CreateDesktopW';

function CreateDesktop conv arg_stdcall (lpszDesktop, lpszDevice: PChar; pDevmode: PDeviceMode; dwFlags: DWORD; dwDesiredAccess:
 DWORD; lpsa: PSecurityAttributes): HDESK;
 external user32dll name 'CreateDesktopA';

function CreateDialogIndirectParamA conv arg_stdcall (hInstance: HINST; const lpTemplate: TDlgTemplate;
 hWndParent: HWND; lpDialogFunc: TFNDlgProc; dwInitParam: LPARAM): HWND;
 external user32dll name 'CreateDialogIndirectParamA';

function CreateDialogIndirectParamW conv arg_stdcall (hInstance: HINST; const lpTemplate: TDlgTemplate;
 hWndParent: HWND; lpDialogFunc: TFNDlgProc; dwInitParam: LPARAM): HWND;
 external user32dll name 'CreateDialogIndirectParamW';

function CreateDialogIndirectParam conv arg_stdcall (hInstance: HINST; const lpTemplate: TDlgTemplate;
 hWndParent: HWND; lpDialogFunc: TFNDlgProc; dwInitParam: LPARAM): HWND;
 external user32dll name 'CreateDialogIndirectParamA';

function CreateDialogParamA conv arg_stdcall (hInstance: HINST; lpTemplateName: PAnsiChar;
 hWndParent: HWND; lpDialogFunc: TFNDlgProc; dwInitParam: LPARAM): HWND;
 external user32dll name 'CreateDialogParamA';

function CreateDialogParamW conv arg_stdcall (hInstance: HINST; lpTemplateName: PWideChar;
 hWndParent: HWND; lpDialogFunc: TFNDlgProc; dwInitParam: LPARAM): HWND;
 external user32dll name 'CreateDialogParamW';

function CreateDialogParam conv arg_stdcall (hInstance: HINST; lpTemplateName: PChar;
 hWndParent: HWND; lpDialogFunc: TFNDlgProc; dwInitParam: LPARAM): HWND;
 external user32dll name 'CreateDialogParamA';

function CreateIcon conv arg_stdcall (hInstance: HINST; nWidth, nHeight: DWORD;
 cPlanes, cBitsPixel: Byte; lpbANDbits, lpbXORbits: Pointer): HICON;
 external user32dll name 'CreateIcon';

function CreateIconFromResource conv arg_stdcall (presbits: PByte; dwResSize: DWORD; fIcon: BOOL; dwVer: DWORD): HICON;
 external user32dll name 'CreateIconFromResource';

function CreateIconFromResourceEx conv arg_stdcall (presbits: PByte; dwResSize: DWORD;
 fIcon: BOOL; dwVer: DWORD; cxDesired, cyDesired: DWORD; Flags: DWORD): HICON;
 external user32dll name 'CreateIconFromResourceEx';

function CreateIconIndirect conv arg_stdcall (var piconinfo: TIconInfo): HICON;
 external user32dll name 'CreateIconIndirect';

function CreateMDIWindowA conv arg_stdcall (lpClassName, lpWindowName: PAnsiChar;
 dwStyle: DWORD; X, Y, nWidth, nHeight: DWORD;
 hWndParent: HWND; hInstance: HINST; lParam: LPARAM): HWND;
 external user32dll name 'CreateMDIWindowA';

function CreateMDIWindowW conv arg_stdcall (lpClassName, lpWindowName: PWideChar;
 dwStyle: DWORD; X, Y, nWidth, nHeight: DWORD;
 hWndParent: HWND; hInstance: HINST; lParam: LPARAM): HWND;
 external user32dll name 'CreateMDIWindowW';

function CreateMDIWindow conv arg_stdcall (lpClassName, lpWindowName: PChar;
 dwStyle: DWORD; X, Y, nWidth, nHeight: DWORD;
 hWndParent: HWND; hInstance: HINST; lParam: LPARAM): HWND;
 external user32dll name 'CreateMDIWindowA';

function CreateMenu: HMENU;
 external user32dll name 'CreateMenu';

function CreatePopupMenu: HMENU;
 external user32dll name 'CreatePopupMenu';

function CreateWindowExA conv arg_stdcall (dwExStyle: DWORD; lpClassName: PAnsiChar;
 lpWindowName: PAnsiChar; dwStyle: DWORD; X, Y, nWidth, nHeight: DWORD;
 hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND;
 external user32dll name 'CreateWindowExA';

function CreateWindowExW conv arg_stdcall (dwExStyle: DWORD; lpClassName: PWideChar;
 lpWindowName: PWideChar; dwStyle: DWORD; X, Y, nWidth, nHeight: DWORD;
 hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND;
 external user32dll name 'CreateWindowExW';

function CreateWindowEx conv arg_stdcall (dwExStyle: DWORD; lpClassName: PChar;
 lpWindowName: PChar; dwStyle: DWORD; X, Y, nWidth, nHeight: DWORD;
 hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND;
 external user32dll name 'CreateWindowExA';

function CreateWindowStationA conv arg_stdcall (lpwinsta: PAnsiChar; dwReserved, dwDesiredAccess: DWORD;
 lpsa: PSecurityAttributes): HWINSTA;
 external user32dll name 'CreateWindowStationA';

function CreateWindowStationW conv arg_stdcall (lpwinsta: PWideChar; dwReserved, dwDesiredAccess: DWORD;
 lpsa: PSecurityAttributes): HWINSTA;
 external user32dll name 'CreateWindowStationW';

function CreateWindowStation conv arg_stdcall (lpwinsta: PChar; dwReserved, dwDesiredAccess: DWORD;
 lpsa: PSecurityAttributes): HWINSTA;
 external user32dll name 'CreateWindowStationA';

function DdeSetQualityOfService conv arg_stdcall (hWndClient: HWnd; const pqosNew: TSecurityQualityOfService;
 pqosPrev: PSecurityQualityOfService): BOOL;
 external user32dll name 'DdeSetQualityOfService';

function DefDlgProcA conv arg_stdcall (hDlg: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'DefDlgProcA';

function DefDlgProcW conv arg_stdcall (hDlg: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'DefDlgProcW';

function DefDlgProc conv arg_stdcall (hDlg: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'DefDlgProcA';

function DefFrameProcA conv arg_stdcall (hWnd, hWndMDIClient: HWND; uMsg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'DefFrameProcA';

function DefFrameProcW conv arg_stdcall (hWnd, hWndMDIClient: HWND; uMsg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'DefFrameProcW';

function DefFrameProc conv arg_stdcall (hWnd, hWndMDIClient: HWND; uMsg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'DefFrameProcA';

function DefMDIChildProcA conv arg_stdcall (hWnd: HWND; uMsg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'DefMDIChildProcA';

function DefMDIChildProcW conv arg_stdcall (hWnd: HWND; uMsg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'DefMDIChildProcW';

function DefMDIChildProc conv arg_stdcall (hWnd: HWND; uMsg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'DefMDIChildProcA';

function DefWindowProcA conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'DefWindowProcA';

function DefWindowProcW conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'DefWindowProcW';

function DefWindowProc conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'DefWindowProcA';

function DeferWindowPos conv arg_stdcall (hWinPosInfo: HDWP; hWnd: HWND; hWndInsertAfter: HWND; x, y, cx, cy: DWORD; uFlags: DWORD): HDWP;
 external user32dll name 'DeferWindowPos';

function DeleteMenu conv arg_stdcall (hMenu: HMENU; uPosition, uFlags: DWORD): BOOL;
 external user32dll name 'DeleteMenu';

function DestroyAcceleratorTable conv arg_stdcall (hAccel: HACCEL): BOOL;
 external user32dll name 'DestroyAcceleratorTable';

function DestroyCaret: BOOL;
 external user32dll name 'DestroyCaret';

function DestroyCursor conv arg_stdcall (hCursor: HICON): BOOL;
 external user32dll name 'DestroyCursor';

function DestroyIcon conv arg_stdcall (hIcon: HICON): BOOL;
 external user32dll name 'DestroyIcon';

function DestroyMenu conv arg_stdcall (hMenu: HMENU): BOOL;
 external user32dll name 'DestroyMenu';

function DestroyWindow conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'DestroyWindow';

function DialogBoxIndirectParamA conv arg_stdcall (hInstance: HINST; const lpDialogTemplate: TDlgTemplate;
 hWndParent: HWND; lpDialogFunc: TFNDlgProc; dwInitParam: LPARAM): DWORD;
 external user32dll name 'DialogBoxIndirectParamA';

function DialogBoxIndirectParamW conv arg_stdcall (hInstance: HINST; const lpDialogTemplate: TDlgTemplate;
 hWndParent: HWND; lpDialogFunc: TFNDlgProc; dwInitParam: LPARAM): DWORD;
 external user32dll name 'DialogBoxIndirectParamW';

function DialogBoxIndirectParam conv arg_stdcall (hInstance: HINST; const lpDialogTemplate: TDlgTemplate;
 hWndParent: HWND; lpDialogFunc: TFNDlgProc; dwInitParam: LPARAM): DWORD;
 external user32dll name 'DialogBoxIndirectParamA';

function DialogBoxParamA conv arg_stdcall (hInstance: HINST; lpTemplateName: PAnsiChar;
 hWndParent: HWND; lpDialogFunc: TFNDlgProc; dwInitParam: LPARAM): DWORD;
 external user32dll name 'DialogBoxParamA';

function DialogBoxParamW conv arg_stdcall (hInstance: HINST; lpTemplateName: PWideChar;
 hWndParent: HWND; lpDialogFunc: TFNDlgProc; dwInitParam: LPARAM): DWORD;
 external user32dll name 'DialogBoxParamW';

function DialogBoxParam conv arg_stdcall (hInstance: HINST; lpTemplateName: PChar;
 hWndParent: HWND; lpDialogFunc: TFNDlgProc; dwInitParam: LPARAM): DWORD;
 external user32dll name 'DialogBoxParamA';

function DispatchMessageA conv arg_stdcall (const lpMsg: TMsg): Longint;
 external user32dll name 'DispatchMessageA';

function DispatchMessageW conv arg_stdcall (const lpMsg: TMsg): Longint;
 external user32dll name 'DispatchMessageW';

function DispatchMessage conv arg_stdcall (const lpMsg: TMsg): Longint;
 external user32dll name 'DispatchMessageA';

function DlgDirListA conv arg_stdcall (hDlg: HWND; lpPathSpec: PAnsiChar;
 nIDListBox, nIDStaticPath: DWORD; uFileType: DWORD): DWORD;
 external user32dll name 'DlgDirListA';

function DlgDirListW conv arg_stdcall (hDlg: HWND; lpPathSpec: PWideChar;
 nIDListBox, nIDStaticPath: DWORD; uFileType: DWORD): DWORD;
 external user32dll name 'DlgDirListW';

function DlgDirList conv arg_stdcall (hDlg: HWND; lpPathSpec: PChar;
 nIDListBox, nIDStaticPath: DWORD; uFileType: DWORD): DWORD;
 external user32dll name 'DlgDirListA';

function DlgDirListComboBoxA conv arg_stdcall (hDlg: HWND; lpPathSpec: PAnsiChar;
 nIDComboBox, nIDStaticPath: DWORD; uFiletype: DWORD): DWORD;
 external user32dll name 'DlgDirListComboBoxA';

function DlgDirListComboBoxW conv arg_stdcall (hDlg: HWND; lpPathSpec: PWideChar;
 nIDComboBox, nIDStaticPath: DWORD; uFiletype: DWORD): DWORD;
 external user32dll name 'DlgDirListComboBoxW';

function DlgDirListComboBox conv arg_stdcall (hDlg: HWND; lpPathSpec: PChar;
 nIDComboBox, nIDStaticPath: DWORD; uFiletype: DWORD): DWORD;
 external user32dll name 'DlgDirListComboBoxA';

function DlgDirSelectComboBoxExA conv arg_stdcall (hDlg: HWND; lpString: PAnsiChar;
nCount, nIDComboBox: DWORD): BOOL;
external user32dll name 'DlgDirSelectComboBoxExA';

function DlgDirSelectComboBoxExW conv arg_stdcall (hDlg: HWND; lpString: PWideChar;
 nCount, nIDComboBox: DWORD): BOOL;
 external user32dll name 'DlgDirSelectComboBoxExW';

function DlgDirSelectComboBoxEx conv arg_stdcall (hDlg: HWND; lpString: PChar;
 nCount, nIDComboBox: DWORD): BOOL;
 external user32dll name 'DlgDirSelectComboBoxExA';

function DlgDirSelectExA conv arg_stdcall (hDlg: HWND; lpString: PAnsiChar; nCount, nIDListBox: DWORD): BOOL;
external user32dll name 'DlgDirSelectExA';

function DlgDirSelectExW conv arg_stdcall (hDlg: HWND; lpString: PWideChar; nCount, nIDListBox: DWORD): BOOL;
external user32dll name 'DlgDirSelectExW';

function DlgDirSelectEx conv arg_stdcall (hDlg: HWND; lpString: PChar; nCount, nIDListBox: DWORD): BOOL;
 external user32dll name 'DlgDirSelectExA';

function DragDetect conv arg_stdcall (p1: HWND; p2: TPoint): BOOL;
 external user32dll name 'DragDetect';

function DragObject conv arg_stdcall (p1, p2: HWND; p3: DWORD; p4: DWORD; p5: HICON): DWORD;
 external user32dll name 'DragObject';

function DrawAnimatedRects conv arg_stdcall (hwnd: HWND; idAni: DWORD; const lprcFrom, lprcTo: TRect): BOOL;
 external user32dll name 'DrawAnimatedRects';

function DrawCaption conv arg_stdcall (p1: HWND; p2: HDC; const p3: TRect; p4: DWORD): BOOL;
 external user32dll name 'DrawCaption';

function DrawEdge conv arg_stdcall (hdc: HDC; var qrc: TRect; edge: DWORD; grfFlags: DWORD): BOOL;
 external user32dll name 'DrawEdge';

function DrawFocusRect conv arg_stdcall (hDC: HDC; const lprc: TRect): BOOL;
 external user32dll name 'DrawFocusRect';

function DrawFrameControl conv arg_stdcall (DC: HDC; const Rect: TRect; uType, uState: DWORD): BOOL;
 external user32dll name 'DrawFrameControl';

function DrawIcon conv arg_stdcall (hDC: HDC; X, Y: DWORD; hIcon: HICON): BOOL;
 external user32dll name 'DrawIcon';

function DrawIconEx conv arg_stdcall (hdc: HDC; xLeft, yTop: DWORD; hIcon: HICON;
 cxWidth, cyWidth: DWORD; istepIfAniCur: DWORD; hbrFlickerFreeDraw: HBRUSH; diFlags: DWORD): BOOL;
 external user32dll name 'DrawIconEx';

function DrawMenuBar conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'DrawMenuBar';

function DrawStateA conv arg_stdcall (DC: HDC; p2: HBRUSH; p3: TFNDrawStateProc;
 p4: LPARAM; p5: WPARAM; p6, p7, p8, p9: DWORD; p10: DWORD): BOOL;
 external user32dll name 'DrawStateA';

function DrawStateW conv arg_stdcall (DC: HDC; p2: HBRUSH; p3: TFNDrawStateProc;
 p4: LPARAM; p5: WPARAM; p6, p7, p8, p9: DWORD; p10: DWORD): BOOL;
 external user32dll name 'DrawStateW';

function DrawState conv arg_stdcall (DC: HDC; p2: HBRUSH; p3: TFNDrawStateProc;
 p4: LPARAM; p5: WPARAM; p6, p7, p8, p9: DWORD; p10: DWORD): BOOL;
 external user32dll name 'DrawStateA';

function DrawTextA conv arg_stdcall (hDC: HDC; lpString: PAnsiChar; nCount: DWORD;
 var lpRect: TRect; uFormat: DWORD): DWORD;
 external user32dll name 'DrawTextA';

function DrawTextW conv arg_stdcall (hDC: HDC; lpString: PWideChar; nCount: DWORD;
 var lpRect: TRect; uFormat: DWORD): DWORD;
 external user32dll name 'DrawTextW';

function DrawText conv arg_stdcall (hDC: HDC; lpString: PChar; nCount: DWORD;
 var lpRect: TRect; uFormat: DWORD): DWORD;
 external user32dll name 'DrawTextA';

function DrawTextExA conv arg_stdcall (DC: HDC; lpchText: PAnsiChar; cchText: DWORD; var p4: TRect;
 dwDTFormat: DWORD; DTParams: PDrawTextParams): DWORD;
 external user32dll name 'DrawTextExA';

function DrawTextExW conv arg_stdcall (DC: HDC; lpchText: PWideChar; cchText: DWORD; var p4: TRect;
 dwDTFormat: DWORD; DTParams: PDrawTextParams): DWORD;
 external user32dll name 'DrawTextExW';

function DrawTextEx conv arg_stdcall (DC: HDC; lpchText: PChar; cchText: DWORD; var p4: TRect;
 dwDTFormat: DWORD; DTParams: PDrawTextParams): DWORD;
 external user32dll name 'DrawTextExA';

function EmptyClipboard: BOOL;
 external user32dll name 'EmptyClipboard';

function EnableMenuItem conv arg_stdcall (hMenu: HMENU; uIDEnableItem, uEnable: DWORD): BOOL;
 external user32dll name 'EnableMenuItem';

function EnableScrollBar conv arg_stdcall (hWnd: HWND; wSBflags, wArrows: DWORD): BOOL;
 external user32dll name 'EnableScrollBar';

function EnableWindow conv arg_stdcall (hWnd: HWND; bEnable: BOOL): BOOL;
 external user32dll name 'EnableWindow';

function EndDeferWindowPos conv arg_stdcall (hWinPosInfo: HDWP): BOOL;
 external user32dll name 'EndDeferWindowPos';

function EndDialog conv arg_stdcall (hDlg: HWND; nResult: DWORD): BOOL;
 external user32dll name 'EndDialog';

function EndPaint conv arg_stdcall (hWnd: HWND; const lpPaint: TPaintStruct): BOOL;
 external user32dll name 'EndPaint';

function EnumChildWindows conv arg_stdcall (hWndParent: HWND; lpEnumFunc: TFNWndEnumProc; lParam: LPARAM): BOOL;
 external user32dll name 'EnumChildWindows';

function EnumClipboardFormats conv arg_stdcall (format: DWORD): DWORD;
 external user32dll name 'EnumClipboardFormats';

function EnumDesktopsA conv arg_stdcall (hwinsta: HWINSTA; lpEnumFunc: TFNDeskTopEnumProc; lParam: LPARAM): BOOL;
 external user32dll name 'EnumDesktopsA';

function EnumDesktopsW conv arg_stdcall (hwinsta: HWINSTA; lpEnumFunc: TFNDeskTopEnumProc; lParam: LPARAM): BOOL;
 external user32dll name 'EnumDesktopsW';

function EnumDesktops conv arg_stdcall (hwinsta: HWINSTA; lpEnumFunc: TFNDeskTopEnumProc; lParam: LPARAM): BOOL;
 external user32dll name 'EnumDesktopsA';

function EnumDesktopWindows conv arg_stdcall (hDesktop: HDESK; lpfn: TFNWndEnumProc; lParam: LPARAM): BOOL;
 external user32dll name 'EnumDesktopWindows';

function EnumDisplaySettingsA conv arg_stdcall (lpszDeviceName: PAnsiChar; iModeNum: DWORD; var lpDevMode: TDeviceModeA): BOOL;
external user32dll name 'EnumDisplaySettingsA';

function EnumDisplaySettingsW conv arg_stdcall (lpszDeviceName: PWideChar; iModeNum: DWORD; var lpDevMode: TDeviceModeW): BOOL;
external user32dll name 'EnumDisplaySettingsW';

function EnumDisplaySettings conv arg_stdcall (lpszDeviceName: PChar; iModeNum: DWORD; var lpDevMode: TDeviceMode): BOOL;
 external user32dll name 'EnumDisplaySettingsA';

function EnumPropsA conv arg_stdcall (hWnd: HWND; lpEnumFunc: TFNPropEnumProc): DWORD;
 external user32dll name 'EnumPropsA';

function EnumPropsW conv arg_stdcall (hWnd: HWND; lpEnumFunc: TFNPropEnumProc): DWORD;
 external user32dll name 'EnumPropsW';

function EnumProps conv arg_stdcall (hWnd: HWND; lpEnumFunc: TFNPropEnumProc): DWORD;
 external user32dll name 'EnumPropsA';

function EnumPropsExA conv arg_stdcall (hWnd: HWND; lpEnumFunc: TFNPropEnumProcEx; lParam: LPARAM): DWORD;
 external user32dll name 'EnumPropsExA';

function EnumPropsExW conv arg_stdcall (hWnd: HWND; lpEnumFunc: TFNPropEnumProcEx; lParam: LPARAM): DWORD;
 external user32dll name 'EnumPropsExW';

function EnumPropsEx conv arg_stdcall (hWnd: HWND; lpEnumFunc: TFNPropEnumProcEx; lParam: LPARAM): DWORD;
 external user32dll name 'EnumPropsExA';

function EnumThreadWindows conv arg_stdcall (dwThreadId: DWORD; lpfn: TFNWndEnumProc; lParam: LPARAM): BOOL;
 external user32dll name 'EnumThreadWindows';

function EnumWindowStationsA conv arg_stdcall (lpEnumFunc: TFNWinStaEnumProc; lParam: LPARAM): BOOL;
 external user32dll name 'EnumWindowStationsA';

function EnumWindowStationsW conv arg_stdcall (lpEnumFunc: TFNWinStaEnumProc; lParam: LPARAM): BOOL;
 external user32dll name 'EnumWindowStationsW';

function EnumWindowStations conv arg_stdcall (lpEnumFunc: TFNWinStaEnumProc; lParam: LPARAM): BOOL;
 external user32dll name 'EnumWindowStationsA';

function EnumWindows conv arg_stdcall (lpEnumFunc: TFNWndEnumProc; lParam: LPARAM): BOOL;
 external user32dll name 'EnumWindows';

function EqualRect conv arg_stdcall (const lprc1, lprc2: TRect): BOOL;
 external user32dll name 'EqualRect';

function ExcludeUpdateRgn conv arg_stdcall (hDC: HDC; hWnd: HWND): DWORD;
 external user32dll name 'ExcludeUpdateRgn';

function ExitWindowsEx conv arg_stdcall (uFlags: DWORD; dwReserved: DWORD): BOOL;
 external user32dll name 'ExitWindowsEx';

function FillRect conv arg_stdcall (hDC: HDC; const lprc: TRect; hbr: HBRUSH): DWORD;
 external user32dll name 'FillRect';

function FindWindowA conv arg_stdcall (lpClassName, lpWindowName: PAnsiChar): HWND;
 external user32dll name 'FindWindowA';

function FindWindowW conv arg_stdcall (lpClassName, lpWindowName: PWideChar): HWND;
 external user32dll name 'FindWindowW';

function FindWindow conv arg_stdcall (lpClassName, lpWindowName: PChar): HWND;
 external user32dll name 'FindWindowA';

function FindWindowExA conv arg_stdcall (Parent, Child: HWND; ClassName, WindowName: PAnsiChar): HWND;
 external user32dll name 'FindWindowExA';

function FindWindowExW conv arg_stdcall (Parent, Child: HWND; ClassName, WindowName: PWideChar): HWND;
external user32dll name 'FindWindowExW';

function FindWindowEx conv arg_stdcall (Parent, Child: HWND; ClassName, WindowName: PChar): HWND;
 external user32dll name 'FindWindowExA';

function FlashWindow conv arg_stdcall (hWnd: HWND; bInvert: BOOL): BOOL;
 external user32dll name 'FlashWindow';

function FrameRect conv arg_stdcall (hDC: HDC; const lprc: TRect; hbr: HBRUSH): DWORD;
 external user32dll name 'FrameRect';

function FreeDDElParam conv arg_stdcall (msg: DWORD; lParam: Longint): BOOL;
 external user32dll name 'FreeDDElParam';

function GetActiveWindow: HWND;
 external user32dll name 'GetActiveWindow';

function GetAsyncKeyState conv arg_stdcall (vKey: DWORD): SHORT;
 external user32dll name 'GetAsyncKeyState';

function GetCapture: HWND;
 external user32dll name 'GetCapture';

function GetCaretBlinkTime: DWORD;
 external user32dll name 'GetCaretBlinkTime';

function GetCaretPos conv arg_stdcall (var lpPoint: TPoint): BOOL;
 external user32dll name 'GetCaretPos';

function GetClassInfoA conv arg_stdcall (hInstance: HINST; lpClassName: PAnsiChar;
 var lpWndClass: TWndClassA): BOOL;
 external user32dll name 'GetClassInfoA';

function GetClassInfoW conv arg_stdcall (hInstance: HINST; lpClassName: PWideChar;
 var lpWndClass: TWndClassW): BOOL;
 external user32dll name 'GetClassInfoW';

function GetClassInfo conv arg_stdcall (hInstance: HINST; lpClassName: PChar;
 var lpWndClass: TWndClass): BOOL;
 external user32dll name 'GetClassInfoA';

function GetClassInfoExA conv arg_stdcall (Instance: HINST; Classname: PAnsiChar; var WndClass: TWndClassExA): BOOL;
external user32dll name 'GetClassInfoExA';

function GetClassInfoExW conv arg_stdcall (Instance: HINST; Classname: PWideChar; var WndClass: TWndClassExW): BOOL;
external user32dll name 'GetClassInfoExW';

function GetClassInfoEx conv arg_stdcall (Instance: HINST; Classname: PChar; var WndClass: TWndClassEx): BOOL;
 external user32dll name 'GetClassInfoExA';

function GetClassLongA conv arg_stdcall (hWnd: HWND; nIndex: DWORD): DWORD;
 external user32dll name 'GetClassLongA';

function GetClassLongW conv arg_stdcall (hWnd: HWND; nIndex: DWORD): DWORD;
 external user32dll name 'GetClassLongW';

function GetClassLong conv arg_stdcall (hWnd: HWND; nIndex: DWORD): DWORD;
 external user32dll name 'GetClassLongA';

function GetClassNameA conv arg_stdcall (hWnd: HWND; lpClassName: PAnsiChar; nMaxCount: DWORD): DWORD;
external user32dll name 'GetClassNameA';

function GetClassNameW conv arg_stdcall (hWnd: HWND; lpClassName: PWideChar; nMaxCount: DWORD): DWORD;
external user32dll name 'GetClassNameW';

function GetClassName conv arg_stdcall (hWnd: HWND; lpClassName: PChar; nMaxCount: DWORD): DWORD;
 external user32dll name 'GetClassNameA';

function GetClassWord conv arg_stdcall (hWnd: HWND; nIndex: DWORD): Word;
 external user32dll name 'GetClassWord';

function GetClientRect conv arg_stdcall (hWnd: HWND; var lpRect: TRect): BOOL;
 external user32dll name 'GetClientRect';

function GetClipCursor conv arg_stdcall (var lpRect: TRect): BOOL;
 external user32dll name 'GetClipCursor';

function GetClipboardData conv arg_stdcall (uFormat: DWORD): THandle;
 external user32dll name 'GetClipboardData';

function GetClipboardFormatNameA conv arg_stdcall (format: DWORD; lpszFormatName: PAnsiChar;
cchMaxCount: DWORD): DWORD;
external user32dll name 'GetClipboardFormatNameA';

function GetClipboardFormatNameW conv arg_stdcall (format: DWORD; lpszFormatName: PWideChar;
cchMaxCount: DWORD): DWORD;
external user32dll name 'GetClipboardFormatNameW';

function GetClipboardFormatName conv arg_stdcall (format: DWORD; lpszFormatName: PChar;
 cchMaxCount: DWORD): DWORD;
 external user32dll name 'GetClipboardFormatNameA';

function GetClipboardOwner: HWND;
 external user32dll name 'GetClipboardOwner';

function GetClipboardViewer: HWND;
 external user32dll name 'GetClipboardViewer';

function GetCursor: HCURSOR;
 external user32dll name 'GetCursor';

function GetCursorPos conv arg_stdcall (var lpPoint: TPoint): BOOL;
 external user32dll name 'GetCursorPos';

function GetDC conv arg_stdcall (hWnd: HWND): HDC;
 external user32dll name 'GetDC';

function GetDCEx conv arg_stdcall (hWnd: HWND; hrgnClip: HRGN; flags: DWORD): HDC;
 external user32dll name 'GetDCEx';

function GetDesktopWindow: HWND;
 external user32dll name 'GetDesktopWindow';

function GetDialogBaseUnits: Longint;
 external user32dll name 'GetDialogBaseUnits';

function GetDlgCtrlID conv arg_stdcall (hWnd: HWND): DWORD;
 external user32dll name 'GetDlgCtrlID';

function GetDlgItem conv arg_stdcall (hDlg: HWND; nIDDlgItem: DWORD): HWND;
 external user32dll name 'GetDlgItem';

function GetDlgItemInt conv arg_stdcall (hDlg: HWND; nIDDlgItem: DWORD; var lpTranslated: BOOL; bSigned: BOOL): DWORD;
 external user32dll name 'GetDlgItemInt';

function GetDlgItemTextA conv arg_stdcall (hDlg: HWND; nIDDlgItem: DWORD; lpString: PAnsiChar; nMaxCount: DWORD): DWORD;
external user32dll name 'GetDlgItemTextA';

function GetDlgItemTextW conv arg_stdcall (hDlg: HWND; nIDDlgItem: DWORD; lpString: PWideChar; nMaxCount: DWORD): DWORD;
external user32dll name 'GetDlgItemTextW';

function GetDlgItemText conv arg_stdcall (hDlg: HWND; nIDDlgItem: DWORD; lpString: PChar; nMaxCount: DWORD): DWORD;
 external user32dll name 'GetDlgItemTextA';

function GetDoubleClickTime: DWORD;
 external user32dll name 'GetDoubleClickTime';

function GetFocus: HWND;
 external user32dll name 'GetFocus';

function GetForegroundWindow: HWND;
 external user32dll name 'GetForegroundWindow';

function GetIconInfo conv arg_stdcall (hIcon: HICON; var piconinfo: TIconInfo): BOOL;
 external user32dll name 'GetIconInfo';

function GetInputState: BOOL;
 external user32dll name 'GetInputState';

function GetKBCodePage: DWORD;
 external user32dll name 'GetKBCodePage';

function GetKeyNameTextA conv arg_stdcall (lParam: Longint; lpString: PAnsiChar; nSize: DWORD): DWORD;
 external user32dll name 'GetKeyNameTextA';

function GetKeyNameTextW conv arg_stdcall (lParam: Longint; lpString: PWideChar; nSize: DWORD): DWORD;
 external user32dll name 'GetKeyNameTextW';

function GetKeyNameText conv arg_stdcall (lParam: Longint; lpString: PChar; nSize: DWORD): DWORD;
 external user32dll name 'GetKeyNameTextA';

function GetKeyState conv arg_stdcall (nVirtKey: DWORD): SHORT;
 external user32dll name 'GetKeyState';

function GetKeyboardLayout conv arg_stdcall (dwLayout: DWORD): HKL;
 external user32dll name 'GetKeyboardLayout';

function GetKeyboardLayoutList conv arg_stdcall (nBuff: DWORD; var List): DWORD;
 external user32dll name 'GetKeyboardLayoutList';

function GetKeyboardLayoutNameA conv arg_stdcall (pwszKLID: PAnsiChar): BOOL;
external user32dll name 'GetKeyboardLayoutNameA';

function GetKeyboardLayoutNameW conv arg_stdcall (pwszKLID: PWideChar): BOOL;
external user32dll name 'GetKeyboardLayoutNameW';

function GetKeyboardLayoutName conv arg_stdcall (pwszKLID: PChar): BOOL;
 external user32dll name 'GetKeyboardLayoutNameA';

function GetKeyboardState conv arg_stdcall (var KeyState: TKeyboardState): BOOL;
 external user32dll name 'GetKeyboardState';

function GetKeyboardType conv arg_stdcall (nTypeFlag: DWORD): DWORD;
 external user32dll name 'GetKeyboardType';

function GetLastActivePopup conv arg_stdcall (hWnd: HWND): HWND;
 external user32dll name 'GetLastActivePopup';

function GetMenu conv arg_stdcall (hWnd: HWND): HMENU;
 external user32dll name 'GetMenu';

function GetMenuCheckMarkDimensions: Longint;
 external user32dll name 'GetMenuCheckMarkDimensions';

function GetMenuContextHelpId conv arg_stdcall (hMenu: HMENU): DWORD;
 external user32dll name 'GetMenuContextHelpId';

function GetMenuDefaultItem conv arg_stdcall (hMenu: HMENU; fByPos, gmdiFlags: DWORD): DWORD;
 external user32dll name 'GetMenuDefaultItem';

function GetMenuItemCount conv arg_stdcall (hMenu: HMENU): DWORD;
 external user32dll name 'GetMenuItemCount';

function GetMenuItemID conv arg_stdcall (hMenu: HMENU; nPos: DWORD): DWORD;
 external user32dll name 'GetMenuItemID';

function GetMenuItemInfoA conv arg_stdcall (p1: HMENU; p2: DWORD; p3: Bool; var p4: TMenuItemInfoA): BOOL;
 external user32dll name 'GetMenuItemInfoA';

function GetMenuItemInfoW conv arg_stdcall (p1: HMENU; p2: DWORD; p3: Bool; var p4: TMenuItemInfoW): BOOL;
 external user32dll name 'GetMenuItemInfoW';

function GetMenuItemInfo conv arg_stdcall (p1: HMENU; p2: DWORD; p3: Bool; var p4: TMenuItemInfo): BOOL;
 external user32dll name 'GetMenuItemInfoA';

function GetMenuItemRect conv arg_stdcall (hWnd: HWND; hMenu: HMENU; uItem: DWORD; var lprcItem: TRect): BOOL;
 external user32dll name 'GetMenuItemRect';

function GetMenuState conv arg_stdcall (hMenu: HMENU; uId, uFlags: DWORD): DWORD;
 external user32dll name 'GetMenuState';

function GetMenuStringA conv arg_stdcall (hMenu: HMENU; uIDItem: DWORD; lpString: PAnsiChar;
 nMaxCount: DWORD; uFlag: DWORD): DWORD;
 external user32dll name 'GetMenuStringA';

function GetMenuStringW conv arg_stdcall (hMenu: HMENU; uIDItem: DWORD; lpString: PWideChar;
 nMaxCount: DWORD; uFlag: DWORD): DWORD;
 external user32dll name 'GetMenuStringW';

function GetMenuString conv arg_stdcall (hMenu: HMENU; uIDItem: DWORD; lpString: PChar;
 nMaxCount: DWORD; uFlag: DWORD): DWORD;
 external user32dll name 'GetMenuStringA';

function GetMessageA conv arg_stdcall (var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax: DWORD): BOOL;
 external user32dll name 'GetMessageA';

function GetMessageW conv arg_stdcall (var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax: DWORD): BOOL;
 external user32dll name 'GetMessageW';

function GetMessage conv arg_stdcall (var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax: DWORD): BOOL;
 external user32dll name 'GetMessageA';

function GetMessageExtraInfo: Longint;
 external user32dll name 'GetMessageExtraInfo';

function GetMessagePos: DWORD;
 external user32dll name 'GetMessagePos';

function GetMessageTime: Longint;
 external user32dll name 'GetMessageTime';

function GetNextDlgGroupItem conv arg_stdcall (hDlg: HWND; hCtl: HWND; bPrevious: BOOL): HWND;
 external user32dll name 'GetNextDlgGroupItem';

function GetNextDlgTabItem conv arg_stdcall (hDlg: HWND; hCtl: HWND; bPrevious: BOOL): HWND;
 external user32dll name 'GetNextDlgTabItem';

function GetNextWindow conv arg_stdcall (hWnd: HWND; uCmd: DWORD): HWND;
 external user32dll name 'GetWindow';

function GetOpenClipboardWindow: HWND;
 external user32dll name 'GetOpenClipboardWindow';

function GetParent conv arg_stdcall (hWnd: HWND): HWND;
 external user32dll name 'GetParent';

function GetPriorityClipboardFormat conv arg_stdcall (var paFormatPriorityList; cFormats: DWORD): DWORD;
 external user32dll name 'GetPriorityClipboardFormat';

function GetProcessWindowStation: HWINSTA;
 external user32dll name 'GetProcessWindowStation';

function GetPropA conv arg_stdcall (hWnd: HWND; lpString: PAnsiChar): THandle;
 external user32dll name 'GetPropA';

function GetPropW conv arg_stdcall (hWnd: HWND; lpString: PWideChar): THandle;
 external user32dll name 'GetPropW';

function GetProp conv arg_stdcall (hWnd: HWND; lpString: PChar): THandle;
 external user32dll name 'GetPropA';

function GetQueueStatus conv arg_stdcall (flags: DWORD): DWORD;
 external user32dll name 'GetQueueStatus';

function GetScrollInfo conv arg_stdcall (hWnd: HWND; BarFlag: DWORD; var ScrollInfo: TScrollInfo): BOOL;
 external user32dll name 'GetScrollInfo';

function GetScrollPos conv arg_stdcall (hWnd: HWND; nBar: DWORD): DWORD;
 external user32dll name 'GetScrollPos';

function GetScrollRange conv arg_stdcall (hWnd: HWND; nBar: DWORD; var lpMinPos, lpMaxPos: DWORD): BOOL;
 external user32dll name 'GetScrollRange';

function GetSubMenu conv arg_stdcall (hMenu: HMENU; nPos: DWORD): HMENU;
 external user32dll name 'GetSubMenu';

function GetSysColor conv arg_stdcall (nIndex: DWORD): DWORD;
 external user32dll name 'GetSysColor';

function GetSysColorBrush conv arg_stdcall (nIndex: DWORD): HBRUSH;
 external user32dll name 'GetSysColorBrush';

function GetSystemMenu conv arg_stdcall (hWnd: HWND; bRevert: BOOL): HMENU;
 external user32dll name 'GetSystemMenu';

function GetSystemMetrics conv arg_stdcall (nIndex: DWORD): DWORD;
 external user32dll name 'GetSystemMetrics';

function GetTabbedTextExtentA conv arg_stdcall (hDC: HDC; lpString: PAnsiChar; nCount, nTabPositions: DWORD; var lpnTabStopPositions): DWORD;
 external user32dll name 'GetTabbedTextExtentA';

function GetTabbedTextExtentW conv arg_stdcall (hDC: HDC; lpString: PWideChar; nCount, nTabPositions: DWORD; var lpnTabStopPositions): DWORD;
 external user32dll name 'GetTabbedTextExtentW';

function GetTabbedTextExtent conv arg_stdcall (hDC: HDC; lpString: PChar; nCount, nTabPositions: DWORD; var lpnTabStopPositions): DWORD;
 external user32dll name 'GetTabbedTextExtentA';

function GetThreadDesktop conv arg_stdcall (dwThreadId: DWORD): HDESK;
 external user32dll name 'GetThreadDesktop';

function GetTopWindow conv arg_stdcall (hWnd: HWND): HWND;
 external user32dll name 'GetTopWindow';

function GetUpdateRect conv arg_stdcall (hWnd: HWND; var lpRect: TRect; bErase: BOOL): BOOL;
 external user32dll name 'GetUpdateRect';

function GetUpdateRgn conv arg_stdcall (hWnd: HWND; hRgn: HRGN; bErase: BOOL): DWORD;
 external user32dll name 'GetUpdateRgn';

function GetUserObjectInformationA conv arg_stdcall (hObj: THandle; nIndex: DWORD; pvInfo: Pointer;
 nLength: DWORD; var lpnLengthNeeded: DWORD): BOOL;
 external user32dll name 'GetUserObjectInformationA';

function GetUserObjectInformationW conv arg_stdcall (hObj: THandle; nIndex: DWORD; pvInfo: Pointer;
 nLength: DWORD; var lpnLengthNeeded: DWORD): BOOL;
 external user32dll name 'GetUserObjectInformationW';

function GetUserObjectInformation conv arg_stdcall (hObj: THandle; nIndex: DWORD; pvInfo: Pointer;
 nLength: DWORD; var lpnLengthNeeded: DWORD): BOOL;
 external user32dll name 'GetUserObjectInformationA';

function GetUserObjectSecurity conv arg_stdcall (hObj: THandle; var pSIRequested: DWORD;
 pSID: PSecurityDescriptor; nLength: DWORD; var lpnLengthNeeded: DWORD): BOOL;
 external user32dll name 'GetUserObjectSecurity';

function GetWindow conv arg_stdcall (hWnd: HWND; uCmd: DWORD): HWND;
 external user32dll name 'GetWindow';

function GetWindowContextHelpId conv arg_stdcall (hWnd: HWND): DWORD;
 external user32dll name 'GetWindowContextHelpId';

function GetWindowDC conv arg_stdcall (hWnd: HWND): HDC;
 external user32dll name 'GetWindowDC';

function GetWindowLongA conv arg_stdcall (hWnd: HWND; nIndex: DWORD): Longint;
 external user32dll name 'GetWindowLongA';

function GetWindowLongW conv arg_stdcall (hWnd: HWND; nIndex: DWORD): Longint;
 external user32dll name 'GetWindowLongW';

function GetWindowLong conv arg_stdcall (hWnd: HWND; nIndex: DWORD): Longint;
 external user32dll name 'GetWindowLongA';

function GetWindowPlacement conv arg_stdcall (hWnd: HWND; WindowPlacement: PWindowPlacement): BOOL;
 external user32dll name 'GetWindowPlacement';

function GetWindowRect conv arg_stdcall (hWnd: HWND; var lpRect: TRect): BOOL;
 external user32dll name 'GetWindowRect';

function GetWindowRgn conv arg_stdcall (hWnd: HWND; hRgn: HRGN): BOOL;
 external user32dll name 'GetWindowRgn';

function GetWindowTextA conv arg_stdcall (hWnd: HWND; lpString: PAnsiChar; nMaxCount: DWORD): DWORD;
external user32dll name 'GetWindowTextA';

function GetWindowTextW conv arg_stdcall (hWnd: HWND; lpString: PWideChar; nMaxCount: DWORD): DWORD;
external user32dll name 'GetWindowTextW';

function GetWindowText conv arg_stdcall (hWnd: HWND; lpString: PChar; nMaxCount: DWORD): DWORD;
 external user32dll name 'GetWindowTextA';

function GetWindowTextLengthA conv arg_stdcall (hWnd: HWND): DWORD;
 external user32dll name 'GetWindowTextLengthA';

function GetWindowTextLengthW conv arg_stdcall (hWnd: HWND): DWORD;
 external user32dll name 'GetWindowTextLengthW';

function GetWindowTextLength conv arg_stdcall (hWnd: HWND): DWORD;
 external user32dll name 'GetWindowTextLengthA';

function GetWindowThreadProcessId conv arg_stdcall (hWnd: HWND; lpdwProcessId: Pointer): DWORD;
 external user32dll name 'GetWindowThreadProcessId';

function GetWindowWord conv arg_stdcall (hWnd: HWND; nIndex: DWORD): Word;
 external user32dll name 'GetWindowWord';

function GrayStringA conv arg_stdcall (hDC: HDC; hBrush: HBRUSH; lpOutputFunc: TFNGrayStringProc;
 lpData: LPARAM; nCount, X, Y, nWidth, nHeight: DWORD): BOOL;
 external user32dll name 'GrayStringA';

function GrayStringW conv arg_stdcall (hDC: HDC; hBrush: HBRUSH; lpOutputFunc: TFNGrayStringProc;
 lpData: LPARAM; nCount, X, Y, nWidth, nHeight: DWORD): BOOL;
 external user32dll name 'GrayStringW';

function GrayString conv arg_stdcall (hDC: HDC; hBrush: HBRUSH; lpOutputFunc: TFNGrayStringProc;
 lpData: LPARAM; nCount, X, Y, nWidth, nHeight: DWORD): BOOL;
 external user32dll name 'GrayStringA';

function HideCaret conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'HideCaret';

function HiliteMenuItem conv arg_stdcall (hWnd: HWND; hMenu: HMENU; uIDHiliteItem: DWORD; uHilite: DWORD): BOOL;
 external user32dll name 'HiliteMenuItem';

function ImpersonateDdeClientWindow conv arg_stdcall (hWndClient: HWnd; hWndServer: HWnd): BOOL;
 external user32dll name 'ImpersonateDdeClientWindow';

function InSendMessage: BOOL;
 external user32dll name 'InSendMessage';

function InflateRect conv arg_stdcall (var lprc: TRect; dx, dy: DWORD): BOOL;
 external user32dll name 'InflateRect';

function InsertMenuA conv arg_stdcall (hMenu: HMENU; uPosition, uFlags, uIDNewItem: DWORD;
 lpNewItem: PAnsiChar): BOOL;
 external user32dll name 'InsertMenuA';

function InsertMenuW conv arg_stdcall (hMenu: HMENU; uPosition, uFlags, uIDNewItem: DWORD;
 lpNewItem: PWideChar): BOOL;
 external user32dll name 'InsertMenuW';

function InsertMenu conv arg_stdcall (hMenu: HMENU; uPosition, uFlags, uIDNewItem: DWORD;
 lpNewItem: PChar): BOOL;
 external user32dll name 'InsertMenuA';

function InsertMenuItemA conv arg_stdcall (p1: HMENU; p2: DWORD; p3: BOOL; const p4: TMenuItemInfoA): BOOL;
 external user32dll name 'InsertMenuItemA';

function InsertMenuItemW conv arg_stdcall (p1: HMENU; p2: DWORD; p3: BOOL; const p4: TMenuItemInfoW): BOOL;
 external user32dll name 'InsertMenuItemW';

function InsertMenuItem conv arg_stdcall (p1: HMENU; p2: DWORD; p3: BOOL; const p4: TMenuItemInfo): BOOL;
 external user32dll name 'InsertMenuItemA';

function IntersectRect conv arg_stdcall (var lprcDst: TRect; const lprcSrc1, lprcSrc2: TRect): BOOL;
 external user32dll name 'IntersectRect';

function InvalidateRect conv arg_stdcall (hWnd: HWND; lpRect: PRect; bErase: BOOL): BOOL;
 external user32dll name 'InvalidateRect';

function InvalidateRgn conv arg_stdcall (hWnd: HWND; hRgn: HRGN; bErase: BOOL): BOOL;
 external user32dll name 'InvalidateRgn';

function InvertRect conv arg_stdcall (hDC: HDC; const lprc: TRect): BOOL;
 external user32dll name 'InvertRect';

function IsCharAlphaA conv arg_stdcall (ch: AnsiChar): BOOL;
 external user32dll name 'IsCharAlphaA';

function IsCharAlphaW conv arg_stdcall (ch: AnsiChar): BOOL;
 external user32dll name 'IsCharAlphaW';

function IsCharAlpha conv arg_stdcall (ch: Char): BOOL;
 external user32dll name 'IsCharAlphaA';

function IsCharAlphaNumericA conv arg_stdcall (ch: AnsiChar): BOOL;
 external user32dll name 'IsCharAlphaNumericA';

function IsCharAlphaNumericW conv arg_stdcall (ch: WideChar): BOOL;
 external user32dll name 'IsCharAlphaNumericW';

function IsCharAlphaNumeric conv arg_stdcall (ch: Char): BOOL;
 external user32dll name 'IsCharAlphaNumericA';

function IsCharLowerA conv arg_stdcall (ch: AnsiChar): BOOL;
 external user32dll name 'IsCharLowerA';

function IsCharLowerW conv arg_stdcall (ch: WideChar): BOOL;
 external user32dll name 'IsCharLowerW';

function IsCharLower conv arg_stdcall (ch: Char): BOOL;
 external user32dll name 'IsCharLowerA';

function IsCharUpperA conv arg_stdcall (ch: AnsiChar): BOOL;
 external user32dll name 'IsCharUpperA';

function IsCharUpperW conv arg_stdcall (ch: WideChar): BOOL;
 external user32dll name 'IsCharUpperW';

function IsCharUpper conv arg_stdcall (ch: Char): BOOL;
 external user32dll name 'IsCharUpperA';

function IsChild conv arg_stdcall (hWndParent, hWnd: HWND): BOOL;
 external user32dll name 'IsChild';

function IsClipboardFormatAvailable conv arg_stdcall (format: DWORD): BOOL;
 external user32dll name 'IsClipboardFormatAvailable';

function IsDialogMessageA conv arg_stdcall (hDlg: HWND; var lpMsg: TMsg): BOOL;
 external user32dll name 'IsDialogMessageA';

function IsDialogMessageW conv arg_stdcall (hDlg: HWND; var lpMsg: TMsg): BOOL;
 external user32dll name 'IsDialogMessageW';

function IsDialogMessage conv arg_stdcall (hDlg: HWND; var lpMsg: TMsg): BOOL;
 external user32dll name 'IsDialogMessageA';

function IsDlgButtonChecked conv arg_stdcall (hDlg: HWND; nIDButton: DWORD): DWORD;
 external user32dll name 'IsDlgButtonChecked';

function IsIconic conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'IsIconic';

function IsMenu conv arg_stdcall (hMenu: HMENU): BOOL;
 external user32dll name 'IsMenu';

function IsRectEmpty conv arg_stdcall (const lprc: TRect): BOOL;
 external user32dll name 'IsRectEmpty';

function IsWindow conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'IsWindow';

function IsWindowEnabled conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'IsWindowEnabled';

function IsWindowUnicode conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'IsWindowUnicode';

function IsWindowVisible conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'IsWindowVisible';

function IsZoomed conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'IsZoomed';

function KillTimer conv arg_stdcall (hWnd: HWND; uIDEvent: DWORD): BOOL;
 external user32dll name 'KillTimer';

function LoadAcceleratorsA conv arg_stdcall (hInstance: HINST; lpTableName: PAnsiChar): HACCEL;
 external user32dll name 'LoadAcceleratorsA';

function LoadAcceleratorsW conv arg_stdcall (hInstance: HINST; lpTableName: PWideChar): HACCEL;
 external user32dll name 'LoadAcceleratorsW';

function LoadAccelerators conv arg_stdcall (hInstance: HINST; lpTableName: PChar): HACCEL;
 external user32dll name 'LoadAcceleratorsA';

function LoadBitmapA conv arg_stdcall (hInstance: HINST; lpBitmapName: PAnsiChar): HBITMAP;
 external user32dll name 'LoadBitmapA';

function LoadBitmapW conv arg_stdcall (hInstance: HINST; lpBitmapName: PAnsiChar): HBITMAP;
 external user32dll name 'LoadBitmapW';

function LoadBitmap conv arg_stdcall (hInstance: HINST; lpBitmapName: PChar): HBITMAP;
 external user32dll name 'LoadBitmapA';

function LoadCursorA conv arg_stdcall (hInstance: HINST; lpCursorName: PAnsiChar): HCURSOR;
 external user32dll name 'LoadCursorA';

function LoadCursorW conv arg_stdcall (hInstance: HINST; lpCursorName: PAnsiChar): HCURSOR;
 external user32dll name 'LoadCursorW';

function LoadCursor conv arg_stdcall (hInstance: HINST; lpCursorName: PChar): HCURSOR;
 external user32dll name 'LoadCursorA';

function LoadCursorFromFileA conv arg_stdcall (lpFileName: PAnsiChar): HCURSOR;
 external user32dll name 'LoadCursorFromFileA';

function LoadCursorFromFileW conv arg_stdcall (lpFileName: PAnsiChar): HCURSOR;
 external user32dll name 'LoadCursorFromFileW';

function LoadCursorFromFile conv arg_stdcall (lpFileName: PChar): HCURSOR;
 external user32dll name 'LoadCursorFromFileA';

function LoadIconA conv arg_stdcall (hInstance: HINST; lpIconName: PAnsiChar): HICON;
 external user32dll name 'LoadIconA';

function LoadIconW conv arg_stdcall (hInstance: HINST; lpIconName: PWideChar): HICON;
 external user32dll name 'LoadIconW';

function LoadIcon conv arg_stdcall (hInstance: HINST; lpIconName: PChar): HICON;
 external user32dll name 'LoadIconA';

function LoadImageA conv arg_stdcall (hInst: HINST; ImageName: PAnsiChar; ImageType: DWORD;
 X, Y: DWORD; Flags: DWORD): THandle;
 external user32dll name 'LoadImageA';

function LoadImageW conv arg_stdcall (hInst: HINST; ImageName: PWideChar; ImageType: DWORD;
 X, Y: DWORD; Flags: DWORD): THandle;
 external user32dll name 'LoadImageW';

function LoadImage conv arg_stdcall (hInst: HINST; ImageName: PChar; ImageType: DWORD;
 X, Y: DWORD; Flags: DWORD): THandle;
 external user32dll name 'LoadImageA';

function LoadKeyboardLayoutA conv arg_stdcall (pwszKLID: PAnsiChar; Flags: DWORD): HKL;
 external user32dll name 'LoadKeyboardLayoutA';

function LoadKeyboardLayoutW conv arg_stdcall (pwszKLID: PWideChar; Flags: DWORD): HKL;
 external user32dll name 'LoadKeyboardLayoutW';

function LoadKeyboardLayout conv arg_stdcall (pwszKLID: PChar; Flags: DWORD): HKL;
 external user32dll name 'LoadKeyboardLayoutA';

function LoadMenuA conv arg_stdcall (hInstance: HINST; lpMenuName: PAnsiChar): HMENU;
 external user32dll name 'LoadMenuA';

function LoadMenuW conv arg_stdcall (hInstance: HINST; lpMenuName: PAnsiChar): HMENU;
 external user32dll name 'LoadMenuW';

function LoadMenu conv arg_stdcall (hInstance: HINST; lpMenuName: PChar): HMENU;
 external user32dll name 'LoadMenuA';

function LoadMenuIndirectA conv arg_stdcall (lpMenuTemplate: Pointer): HMENU;
 external user32dll name 'LoadMenuIndirectA';

function LoadMenuIndirectW conv arg_stdcall (lpMenuTemplate: Pointer): HMENU;
 external user32dll name 'LoadMenuIndirectW';

function LoadMenuIndirect conv arg_stdcall (lpMenuTemplate: Pointer): HMENU;
 external user32dll name 'LoadMenuIndirectA';

function LoadStringA conv arg_stdcall (hInstance: HINST; uID: DWORD; lpBuffer: PAnsiChar; nBufferMax: DWORD): DWORD;
 external user32dll name 'LoadStringA';

function LoadStringW conv arg_stdcall (hInstance: HINST; uID: DWORD; lpBuffer: PWideChar; nBufferMax: DWORD): DWORD;
 external user32dll name 'LoadStringW';

function LoadString conv arg_stdcall (hInstance: HINST; uID: DWORD; lpBuffer: PChar; nBufferMax: DWORD): DWORD;
 external user32dll name 'LoadStringA';

function LockWindowUpdate conv arg_stdcall (hWndLock: HWND): BOOL;
 external user32dll name 'LockWindowUpdate';

function LookupIconIdFromDirectory conv arg_stdcall (presbits: PByte; fIcon: BOOL): DWORD;
 external user32dll name 'LookupIconIdFromDirectory';

function LookupIconIdFromDirectoryEx conv arg_stdcall (presbits: PByte; fIcon: BOOL; cxDesired, cyDesired: DWORD; Flags: DWORD): DWORD;
 external user32dll name 'LookupIconIdFromDirectoryEx';

function MapDialogRect conv arg_stdcall (hDlg: HWND; var lpRect: TRect): BOOL;
 external user32dll name 'MapDialogRect';

function MapVirtualKeyA conv arg_stdcall (uCode, uMapType: DWORD): DWORD;
 external user32dll name 'MapVirtualKeyA';

function MapVirtualKeyW conv arg_stdcall (uCode, uMapType: DWORD): DWORD;
 external user32dll name 'MapVirtualKeyW';

function MapVirtualKey conv arg_stdcall (uCode, uMapType: DWORD): DWORD;
 external user32dll name 'MapVirtualKeyA';

function MapVirtualKeyExA conv arg_stdcall (uCode, uMapType: DWORD; dwhkl: HKL): DWORD;
 external user32dll name 'MapVirtualKeyExA';

function MapVirtualKeyExW conv arg_stdcall (uCode, uMapType: DWORD; dwhkl: HKL): DWORD;
 external user32dll name 'MapVirtualKeyExW';

function MapVirtualKeyEx conv arg_stdcall (uCode, uMapType: DWORD; dwhkl: HKL): DWORD;
 external user32dll name 'MapVirtualKeyExA';

function MapWindowPoints conv arg_stdcall (hWndFrom, hWndTo: HWND; var lpPoints; cPoints: DWORD): DWORD;
 external user32dll name 'MapWindowPoints';

function MenuItemFromPoint conv arg_stdcall (hWnd: HWND; hMenu: HMENU; ptScreen: TPoint): BOOL;
 external user32dll name 'MenuItemFromPoint';

function MessageBeep conv arg_stdcall (uType: DWORD): BOOL;
 external user32dll name 'MessageBeep';

function MessageBoxA conv arg_stdcall (hWnd: HWND; lpText, lpCaption: PAnsiChar; uType: DWORD): DWORD;
 external user32dll name 'MessageBoxA';

function MessageBoxW conv arg_stdcall (hWnd: HWND; lpText, lpCaption: PWideChar; uType: DWORD): DWORD;
 external user32dll name 'MessageBoxW';

function MessageBox conv arg_stdcall (hWnd: HWND; lpText, lpCaption: PChar; uType: DWORD): DWORD;
 external user32dll name 'MessageBoxA';

function MessageBoxExA conv arg_stdcall (hWnd: HWND; lpText, lpCaption: PAnsiChar;
 uType: DWORD; wLanguageId: Word): DWORD;
 external user32dll name 'MessageBoxExA';

function MessageBoxExW conv arg_stdcall (hWnd: HWND; lpText, lpCaption: PWideChar;
 uType: DWORD; wLanguageId: Word): DWORD;
 external user32dll name 'MessageBoxExW';

function MessageBoxEx conv arg_stdcall (hWnd: HWND; lpText, lpCaption: PChar;
 uType: DWORD; wLanguageId: Word): DWORD;
 external user32dll name 'MessageBoxExA';

function MessageBoxIndirectA conv arg_stdcall (const MsgBoxParams: TMsgBoxParamsA): BOOL;
 external user32dll name 'MessageBoxIndirectA';

function MessageBoxIndirectW conv arg_stdcall (const MsgBoxParams: TMsgBoxParamsW): BOOL;
 external user32dll name 'MessageBoxIndirectW';

function MessageBoxIndirect conv arg_stdcall (const MsgBoxParams: TMsgBoxParams): BOOL;
 external user32dll name 'MessageBoxIndirectA';

function ModifyMenuA conv arg_stdcall (hMnu: HMENU; uPosition, uFlags, uIDNewItem: DWORD; lpNewItem: PAnsiChar): BOOL;
 external user32dll name 'ModifyMenuA';

function ModifyMenuW conv arg_stdcall (hMnu: HMENU; uPosition, uFlags, uIDNewItem: DWORD;lpNewItem: PWideChar): BOOL;
 external user32dll name 'ModifyMenuW';

function ModifyMenu conv arg_stdcall (hMnu: HMENU; uPosition, uFlags, uIDNewItem: DWORD; lpNewItem: PChar): BOOL;
 external user32dll name 'ModifyMenuA';

function MoveWindow conv arg_stdcall (hWnd: HWND; X, Y, nWidth, nHeight: DWORD; bRepaint: BOOL): BOOL;
 external user32dll name 'MoveWindow';

function MsgWaitForMultipleObjects conv arg_stdcall (nCount: DWORD; var pHandles; fWaitAll: BOOL; dwMilliseconds, dwWakeMask: DWORD): DWORD;
 external user32dll name 'MsgWaitForMultipleObjects';

function MsgWaitForMultipleObjectsEx conv arg_stdcall (nCount: DWORD; var pHandles; dwMilliseconds, dwWakeMask, dwFlags: DWORD): DWORD;
 external user32dll name 'MsgWaitForMultipleObjectsEx';

function OemKeyScan conv arg_stdcall (wOemChar: Word): DWORD;
 external user32dll name 'OemKeyScan';

function OemToAnsi conv arg_stdcall (const lpszSrc: LPCSTR; lpszDst: LPSTR): BOOL;
 external user32dll name 'OemToCharA';

function OemToAnsiBuff conv arg_stdcall (lpszSrc: LPCSTR; lpszDst: LPSTR; cchDstLength: DWORD): BOOL;
 external user32dll name 'OemToCharBuffA';

function OemToCharA conv arg_stdcall (lpszSrc: PAnsiChar; lpszDst: PAnsiChar): BOOL;
 external user32dll name 'OemToCharA';

function OemToCharW conv arg_stdcall (lpszSrc: PWideChar; lpszDst: PWideChar): BOOL;
 external user32dll name 'OemToCharW';

function OemToChar conv arg_stdcall (lpszSrc: PChar; lpszDst: PChar): BOOL;
 external user32dll name 'OemToCharA';

function OemToCharBuffA conv arg_stdcall (lpszSrc: PAnsiChar; lpszDst: PAnsiChar; cchDstLength: DWORD): BOOL;
 external user32dll name 'OemToCharBuffA';

function OemToCharBuffW conv arg_stdcall (lpszSrc: PWideChar; lpszDst: PWideChar; cchDstLength: DWORD): BOOL;
 external user32dll name 'OemToCharBuffW';

function OemToCharBuff conv arg_stdcall (lpszSrc: PChar; lpszDst: PChar; cchDstLength: DWORD): BOOL;
 external user32dll name 'OemToCharBuffA';

function OffsetRect conv arg_stdcall (var lprc: TRect; dx, dy: DWORD): BOOL;
 external user32dll name 'OffsetRect';

function OpenClipboard conv arg_stdcall (hWndNewOwner: HWND): BOOL;
 external user32dll name 'OpenClipboard';

function OpenDesktopA conv arg_stdcall (lpszDesktop: PAnsiChar; dwFlags: DWORD; fInherit: BOOL; dwDesiredAccess: DWORD): HDESK;
external user32dll name 'OpenDesktopA';

function OpenDesktopW conv arg_stdcall (lpszDesktop: PWideChar; dwFlags: DWORD; fInherit: BOOL; dwDesiredAccess: DWORD): HDESK;
external user32dll name 'OpenDesktopW';

function OpenDesktop conv arg_stdcall (lpszDesktop: PChar; dwFlags: DWORD; fInherit: BOOL; dwDesiredAccess: DWORD): HDESK;
 external user32dll name 'OpenDesktopA';

function OpenIcon conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'OpenIcon';

function OpenInputDesktop conv arg_stdcall (dwFlags: DWORD; fInherit: BOOL; dwDesiredAccess: DWORD): HDESK;
 external user32dll name 'OpenInputDesktop';

function OpenWindowStationA conv arg_stdcall (lpszWinSta: PAnsiChar; fInherit: BOOL; dwDesiredAccess: DWORD): HWINSTA;
 external user32dll name 'OpenWindowStationA';

function OpenWindowStationW conv arg_stdcall (lpszWinSta: PWideChar; fInherit: BOOL; dwDesiredAccess: DWORD): HWINSTA;
 external user32dll name 'OpenWindowStationW';

function OpenWindowStation conv arg_stdcall (lpszWinSta: PChar; fInherit: BOOL; dwDesiredAccess: DWORD): HWINSTA;
 external user32dll name 'OpenWindowStationA';

function PackDDElParam conv arg_stdcall (msg: DWORD; uiLo: DWORD; uiHi: DWORD): Longint;
 external user32dll name 'PackDDElParam';

function PaintDesktop conv arg_stdcall (hdc: HDC): BOOL;
 external user32dll name 'PaintDesktop';

function PeekMessageA conv arg_stdcall (var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: DWORD): BOOL;
 external user32dll name 'PeekMessageA';

function PeekMessageW conv arg_stdcall (var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: DWORD): BOOL;
 external user32dll name 'PeekMessageW';

function PeekMessage conv arg_stdcall (var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: DWORD): BOOL;
 external user32dll name 'PeekMessageA';

function PostMessageA conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): BOOL;
 external user32dll name 'PostMessageA';

function PostMessageW conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): BOOL;
 external user32dll name 'PostMessageW';

function PostMessage conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): BOOL;
 external user32dll name 'PostMessageA';

procedure PostQuitMessage conv arg_stdcall (nExitCode: DWORD);
 external user32dll name 'PostQuitMessage';

function PostThreadMessageA conv arg_stdcall (idThread: DWORD; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): BOOL;
 external user32dll name 'PostThreadMessageA';

function PostThreadMessageW conv arg_stdcall (idThread: DWORD; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): BOOL;
 external user32dll name 'PostThreadMessageW';

function PostThreadMessage conv arg_stdcall (idThread: DWORD; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): BOOL;
 external user32dll name 'PostThreadMessageA';

function PtInRect conv arg_stdcall (const lprc: TRect; pt: TPoint): BOOL;
 external user32dll name 'PtInRect';

function RedrawWindow conv arg_stdcall (hWnd: HWND; lprcUpdate: PRect; hrgnUpdate: HRGN; flags: DWORD): BOOL;
 external user32dll name 'RedrawWindow';

function RegisterClassA conv arg_stdcall (const lpWndClass: TWndClassA): ATOM;
 external user32dll name 'RegisterClassA';

function RegisterClassW conv arg_stdcall (const lpWndClass: TWndClassW): ATOM;
 external user32dll name 'RegisterClassW';

function RegisterClass conv arg_stdcall (const lpWndClass: TWndClass): ATOM;
 external user32dll name 'RegisterClassA';

function RegisterClassExA conv arg_stdcall (const WndClass: TWndClassExA): ATOM;
 external user32dll name 'RegisterClassExA';

function RegisterClassExW conv arg_stdcall (const WndClass: TWndClassExW): ATOM;
 external user32dll name 'RegisterClassExW';

function RegisterClassEx conv arg_stdcall (const WndClass: TWndClassEx): ATOM;
 external user32dll name 'RegisterClassExA';

function RegisterClipboardFormatA conv arg_stdcall (lpszFormat: PAnsiChar): DWORD;
 external user32dll name 'RegisterClipboardFormatA';

function RegisterClipboardFormatW conv arg_stdcall (lpszFormat: PWideChar): DWORD;
 external user32dll name 'RegisterClipboardFormatW';

function RegisterClipboardFormat conv arg_stdcall (lpszFormat: PChar): DWORD;
 external user32dll name 'RegisterClipboardFormatA';

function RegisterHotKey conv arg_stdcall (hWnd: HWND; id: DWORD; fsModifiers, vk: DWORD): BOOL;
 external user32dll name 'RegisterHotKey';

function RegisterWindowMessageA conv arg_stdcall (lpString: PAnsiChar): DWORD;
 external user32dll name 'RegisterWindowMessageA';

function RegisterWindowMessageW conv arg_stdcall (lpString: PWideChar): DWORD;
 external user32dll name 'RegisterWindowMessageW';

function RegisterWindowMessage conv arg_stdcall (lpString: PChar): DWORD;
 external user32dll name 'RegisterWindowMessageA';

function ReleaseCapture: BOOL;
 external user32dll name 'ReleaseCapture';

function ReleaseDC conv arg_stdcall (hWnd: HWND; hDC: HDC): DWORD;
 external user32dll name 'ReleaseDC';

function RemoveMenu conv arg_stdcall (hMenu: HMENU; uPosition, uFlags: DWORD): BOOL;
 external user32dll name 'RemoveMenu';

function RemovePropA conv arg_stdcall (hWnd: HWND; lpString: PAnsiChar): THandle;
 external user32dll name 'RemovePropA';

function RemovePropW conv arg_stdcall (hWnd: HWND; lpString: PWideChar): THandle;
 external user32dll name 'RemovePropW';

function RemoveProp conv arg_stdcall (hWnd: HWND; lpString: PChar): THandle;
 external user32dll name 'RemovePropA';

function ReplyMessage conv arg_stdcall (lResult: LRESULT): BOOL;
 external user32dll name 'ReplyMessage';

function ReuseDDElParam conv arg_stdcall (lParam: Longint; msgIn: DWORD; msgOut: DWORD; uiLo: DWORD; uiHi: DWORD): Longint;
 external user32dll name 'ReuseDDElParam';

function ScreenToClient conv arg_stdcall (hWnd: HWND; var lpPoint: TPoint): BOOL;
 external user32dll name 'ScreenToClient';

function ScrollDC conv arg_stdcall (DC: HDC; DX, DY: DWORD; var Scroll, Clip: TRect; Rgn: HRGN;
 Update: PRect): BOOL;
 external user32dll name 'ScrollDC';

function ScrollWindow conv arg_stdcall (hWnd: HWND; XAmount, YAmount: DWORD; Rect, ClipRect: PRect): BOOL;
 external user32dll name 'ScrollWindow';

function ScrollWindowEx conv arg_stdcall (hWnd: HWND; dx, dy: DWORD; prcScroll, prcClip: PRect;
 hrgnUpdate: HRGN; prcUpdate: PRect; flags: DWORD): BOOL;
 external user32dll name 'ScrollWindowEx';

function SendDlgItemMessageA conv arg_stdcall (hDlg: HWND; nIDDlgItem: DWORD; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): Longint;
 external user32dll name 'SendDlgItemMessageA';

function SendDlgItemMessageW conv arg_stdcall (hDlg: HWND; nIDDlgItem: DWORD; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): Longint;
 external user32dll name 'SendDlgItemMessageW';

function SendDlgItemMessage conv arg_stdcall (hDlg: HWND; nIDDlgItem: DWORD; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): Longint;
 external user32dll name 'SendDlgItemMessageA';

function SendMessageA conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'SendMessageA';

function SendMessageW conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'SendMessageW';

function SendMessage conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): LRESULT;
 external user32dll name 'SendMessageA';

function SendMessageCallbackA conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM;
 lParam: LPARAM; lpResultCallBack: TFNSendAsyncProc; dwData: DWORD): BOOL;
 external user32dll name 'SendMessageCallbackA';

function SendMessageCallbackW conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM;
 lParam: LPARAM; lpResultCallBack: TFNSendAsyncProc; dwData: DWORD): BOOL;
 external user32dll name 'SendMessageCallbackW';

function SendMessageCallback conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM;
 lParam: LPARAM; lpResultCallBack: TFNSendAsyncProc; dwData: DWORD): BOOL;
 external user32dll name 'SendMessageCallbackA';

function SendMessageTimeoutA conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM;
 lParam: LPARAM; fuFlags, uTimeout: DWORD; var lpdwResult: DWORD): LRESULT;
 external user32dll name 'SendMessageTimeoutA';

function SendMessageTimeoutW conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM;
 lParam: LPARAM; fuFlags, uTimeout: DWORD; var lpdwResult: DWORD): LRESULT;
 external user32dll name 'SendMessageTimeoutW';

function SendMessageTimeout conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM;
 lParam: LPARAM; fuFlags, uTimeout: DWORD; var lpdwResult: DWORD): LRESULT;
 external user32dll name 'SendMessageTimeoutA';

function SendNotifyMessageA conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): BOOL;
 external user32dll name 'SendNotifyMessageA';

function SendNotifyMessageW conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): BOOL;
 external user32dll name 'SendNotifyMessageW';

function SendNotifyMessage conv arg_stdcall (hWnd: HWND; Msg: DWORD; wParam: WPARAM; lParam: LPARAM): BOOL;
 external user32dll name 'SendNotifyMessageA';

function SetActiveWindow conv arg_stdcall (hWnd: HWND): HWND;
 external user32dll name 'SetActiveWindow';

function SetCapture conv arg_stdcall (hWnd: HWND): HWND;
 external user32dll name 'SetCapture';

function SetCaretBlinkTime conv arg_stdcall (uMSeconds: DWORD): BOOL;
 external user32dll name 'SetCaretBlinkTime';

function SetCaretPos conv arg_stdcall (X, Y: DWORD): BOOL;
 external user32dll name 'SetCaretPos';

function SetClassLongA conv arg_stdcall (hWnd: HWND; nIndex: DWORD; dwNewLong: Longint): DWORD;
 external user32dll name 'SetClassLongA';

function SetClassLongW conv arg_stdcall (hWnd: HWND; nIndex: DWORD; dwNewLong: Longint): DWORD;
 external user32dll name 'SetClassLongW';

function SetClassLong conv arg_stdcall (hWnd: HWND; nIndex: DWORD; dwNewLong: Longint): DWORD;
 external user32dll name 'SetClassLongA';

function SetClassWord conv arg_stdcall (hWnd: HWND; nIndex: DWORD; wNewWord: Word): Word;
 external user32dll name 'SetClassWord';

function SetClipboardData conv arg_stdcall (uFormat: DWORD; hMem: THandle): THandle;
 external user32dll name 'SetClipboardData';

function SetClipboardViewer conv arg_stdcall (hWndNewViewer: HWND): HWND;
 external user32dll name 'SetClipboardViewer';

function SetCursor conv arg_stdcall (hCursor: HICON): HCURSOR;
 external user32dll name 'SetCursor';

function SetCursorPos conv arg_stdcall (X, Y: DWORD): BOOL;
 external user32dll name 'SetCursorPos';

procedure SetDebugErrorLevel conv arg_stdcall (dwLevel: DWORD);
 external user32dll name 'SetDebugErrorLevel';

function SetDlgItemInt conv arg_stdcall (hDlg: HWND; nIDDlgItem: DWORD; uValue: DWORD; bSigned: BOOL): BOOL;
 external user32dll name 'SetDlgItemInt';

function SetDlgItemTextA conv arg_stdcall (hDlg: HWND; nIDDlgItem: DWORD; lpString: PAnsiChar): BOOL;
external user32dll name 'SetDlgItemTextA';

function SetDlgItemTextW conv arg_stdcall (hDlg: HWND; nIDDlgItem: DWORD; lpString: PWideChar): BOOL;
external user32dll name 'SetDlgItemTextW';

function SetDlgItemText conv arg_stdcall (hDlg: HWND; nIDDlgItem: DWORD; lpString: PChar): BOOL;
 external user32dll name 'SetDlgItemTextA';

function SetDoubleClickTime conv arg_stdcall (Interval: DWORD): BOOL;
 external user32dll name 'SetDoubleClickTime';

function SetFocus conv arg_stdcall (hWnd: HWND): HWND;
 external user32dll name 'SetFocus';

function SetForegroundWindow conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'SetForegroundWindow';

function SetKeyboardState conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'SetKeyboardState';

procedure SetLastErrorEx conv arg_stdcall (dwErrCode, dwType: DWORD);
 external user32dll name 'SetLastErrorEx';

function SetMenu conv arg_stdcall (hWnd: HWND; hMenu: HMENU): BOOL;
 external user32dll name 'SetMenu';

function SetMenuContextHelpId conv arg_stdcall (hMenu: HMENU; HelpID: DWORD): BOOL;
 external user32dll name 'SetMenuContextHelpId';

function SetMenuDefaultItem conv arg_stdcall (hMenu: HMENU; uItem, fByPos: DWORD): BOOL;
 external user32dll name 'SetMenuDefaultItem';

function SetMenuItemBitmaps conv arg_stdcall (hMenu: HMENU; uPosition, uFlags: DWORD;
 hBitmapUnchecked: HBITMAP; hBitmapChecked: HBITMAP): BOOL;
 external user32dll name 'SetMenuItemBitmaps';

function SetMenuItemInfoA conv arg_stdcall (p1: HMENU; p2: DWORD; p3: Bool; const p4: TMenuItemInfoA): BOOL;
 external user32dll name 'SetMenuItemInfoA';

function SetMenuItemInfoW conv arg_stdcall (p1: HMENU; p2: DWORD; p3: Bool; const p4: TMenuItemInfoW): BOOL;
 external user32dll name 'SetMenuItemInfoW';

function SetMenuItemInfo conv arg_stdcall (p1: HMENU; p2: DWORD; p3: Bool; const p4: TMenuItemInfo): BOOL;
 external user32dll name 'SetMenuItemInfoA';

function SetMessageExtraInfo conv arg_stdcall (lParam: LPARAM): LPARAM;
 external user32dll name 'SetMessageExtraInfo';

function SetMessageQueue conv arg_stdcall (cMessagesMax: DWORD): BOOL;
 external user32dll name 'SetMessageQueue';

function SetParent conv arg_stdcall (hWndChild, hWndNewParent: HWND): HWND;
 external user32dll name 'SetParent';

function SetProcessWindowStation conv arg_stdcall (hWinSta: HWINSTA): BOOL;
 external user32dll name 'SetProcessWindowStation';

function SetPropA conv arg_stdcall (hWnd: HWND; lpString: PAnsiChar; hData: THandle): BOOL;
external user32dll name 'SetPropA';

function SetPropW conv arg_stdcall (hWnd: HWND; lpString: PWideChar; hData: THandle): BOOL;
external user32dll name 'SetPropW';

function SetProp conv arg_stdcall (hWnd: HWND; lpString: PChar; hData: THandle): BOOL;
 external user32dll name 'SetPropA';

function SetRect conv arg_stdcall (var lprc: TRect; xLeft, yTop, xRight, yBottom: DWORD): BOOL;
 external user32dll name 'SetRect';

function SetRectEmpty conv arg_stdcall (var lprc: TRect): BOOL;
 external user32dll name 'SetRectEmpty';

function SetScrollInfo conv arg_stdcall (hWnd: HWND; BarFlag: DWORD; const ScrollInfo: TScrollInfo; Redraw: BOOL): DWORD;
 external user32dll name 'SetScrollInfo';

function SetScrollPos conv arg_stdcall (hWnd: HWND; nBar, nPos: DWORD; bRedraw: BOOL): DWORD;
 external user32dll name 'SetScrollPos';

function SetScrollRange conv arg_stdcall (hWnd: HWND; nBar, nMinPos, nMaxPos: DWORD; bRedraw: Bool): BOOL;
 external user32dll name 'SetScrollRange';

function SetSysColors conv arg_stdcall (cElements: DWORD; const lpaElements; const lpaRgbValues): BOOL;
 external user32dll name 'SetSysColors';

function SetSystemCursor conv arg_stdcall (hcur: HICON; id: DWORD): BOOL;
 external user32dll name 'SetSystemCursor';

function SetThreadDesktop conv arg_stdcall (hDesktop: HDESK): BOOL;
 external user32dll name 'SetThreadDesktop';

function SetTimer conv arg_stdcall (hWnd: HWND; nIDEvent, uElapse: DWORD; lpTimerFunc: TFNTimerProc): DWORD;
 external user32dll name 'SetTimer';

function SetUserObjectInformationA conv arg_stdcall (hObj: THandle; nIndex: DWORD; pvInfo: Pointer; nLength: DWORD): BOOL;
 external user32dll name 'SetUserObjectInformationA';

function SetUserObjectInformationW conv arg_stdcall (hObj: THandle; nIndex: DWORD; pvInfo: Pointer; nLength: DWORD): BOOL;
 external user32dll name 'SetUserObjectInformationW';

function SetUserObjectInformation conv arg_stdcall (hObj: THandle; nIndex: DWORD; pvInfo: Pointer; nLength: DWORD): BOOL;
 external user32dll name 'SetUserObjectInformationA';

function SetUserObjectSecurity conv arg_stdcall (hObj: THandle; var pSIRequested: DWORD; pSID: PSecurityDescriptor): BOOL;
 external user32dll name 'SetUserObjectSecurity';

function SetWindowContextHelpId conv arg_stdcall (hWnd: HWND; HelpID: DWORD): BOOL;
 external user32dll name 'SetWindowContextHelpId';

function SetWindowLongA conv arg_stdcall (hWnd: HWND; nIndex: DWORD; dwNewLong: Longint): Longint;
 external user32dll name 'SetWindowLongA';

function SetWindowLongW conv arg_stdcall (hWnd: HWND; nIndex: DWORD; dwNewLong: Longint): Longint;
 external user32dll name 'SetWindowLongW';

function SetWindowLong conv arg_stdcall (hWnd: HWND; nIndex: DWORD; dwNewLong: Longint): Longint;
 external user32dll name 'SetWindowLongA';

function SetWindowPlacement conv arg_stdcall (hWnd: HWND; WindowPlacement: PWindowPlacement): BOOL;
 external user32dll name 'SetWindowPlacement';

function SetWindowPos conv arg_stdcall (hWnd: HWND; hWndInsertAfter: HWND; X, Y, cx, cy: DWORD; uFlags: DWORD): BOOL;
 external user32dll name 'SetWindowPos';

function SetWindowTextA conv arg_stdcall (hWnd: HWND; lpString: PAnsiChar): BOOL;
 external user32dll name 'SetWindowTextA';

function SetWindowTextW conv arg_stdcall (hWnd: HWND; lpString: PWideChar): BOOL;
 external user32dll name 'SetWindowTextW';

function SetWindowText conv arg_stdcall (hWnd: HWND; lpString: PChar): BOOL;
 external user32dll name 'SetWindowTextA';

function SetWindowWord conv arg_stdcall (hWnd: HWND; nIndex: DWORD; wNewWord: Word): Word;
 external user32dll name 'SetWindowWord';

function SetWindowsHookA conv arg_stdcall (nFilterType: DWORD; pfnFilterProc: TFNHookProc): HHOOK;
 external user32dll name 'SetWindowsHookA';

function SetWindowsHookW conv arg_stdcall (nFilterType: DWORD; pfnFilterProc: TFNHookProc): HHOOK;
 external user32dll name 'SetWindowsHookW';

function SetWindowsHook conv arg_stdcall (nFilterType: DWORD; pfnFilterProc: TFNHookProc): HHOOK;
 external user32dll name 'SetWindowsHookA';

function SetWindowsHookExA conv arg_stdcall (idHook: DWORD; lpfn: TFNHookProc; hmod: HINST; dwThreadId: DWORD): HHOOK;
 external user32dll name 'SetWindowsHookExA';

function SetWindowsHookExW conv arg_stdcall (idHook: DWORD; lpfn: TFNHookProc; hmod: HINST; dwThreadId: DWORD): HHOOK;
 external user32dll name 'SetWindowsHookExW';

function SetWindowsHookEx conv arg_stdcall (idHook: DWORD; lpfn: TFNHookProc; hmod: HINST; dwThreadId: DWORD): HHOOK;
 external user32dll name 'SetWindowsHookExA';

function SetWindowRgn conv arg_stdcall (hWnd: HWND; hRgn: HRGN; bRedraw: BOOL): BOOL;
 external user32dll name 'SetWindowRgn';

function ShowCaret conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'ShowCaret';

function ShowCursor conv arg_stdcall (bShow: BOOL): DWORD;
 external user32dll name 'ShowCursor';

function ShowOwnedPopups conv arg_stdcall (hWnd: HWND; fShow: BOOL): BOOL;
 external user32dll name 'ShowOwnedPopups';

function ShowScrollBar conv arg_stdcall (hWnd: HWND; wBar: DWORD; bShow: BOOL): BOOL;
 external user32dll name 'ShowScrollBar';

function ShowWindow conv arg_stdcall (hWnd: HWND; nCmdShow: DWORD): BOOL;
 external user32dll name 'ShowWindow';

function ShowWindowAsync conv arg_stdcall (hWnd: HWND; nCmdShow: DWORD): BOOL;
 external user32dll name 'ShowWindowAsync';

function SubtractRect conv arg_stdcall (var lprcDst: TRect; const lprcSrc1, lprcSrc2: TRect): BOOL;
 external user32dll name 'SubtractRect';

function SwapMouseButton conv arg_stdcall (fSwap: BOOL): BOOL;
 external user32dll name 'SwapMouseButton';

function SwitchDesktop conv arg_stdcall (hDesktop: HDESK): BOOL;
 external user32dll name 'SwitchDesktop';

function SystemParametersInfoA conv arg_stdcall (uiAction, uiParam: DWORD; pvParam: Pointer; fWinIni: DWORD): BOOL;
 external user32dll name 'SystemParametersInfoA';

function SystemParametersInfoW conv arg_stdcall (uiAction, uiParam: DWORD; pvParam: Pointer; fWinIni: DWORD): BOOL;
 external user32dll name 'SystemParametersInfoW';

function SystemParametersInfo conv arg_stdcall (uiAction, uiParam: DWORD; pvParam: Pointer; fWinIni: DWORD): BOOL;
 external user32dll name 'SystemParametersInfoA';

function TabbedTextOutA conv arg_stdcall (hDC: HDC; X, Y: DWORD; lpString: PAnsiChar; nCount, nTabPositions: DWORD;
 var lpnTabStopPositions; nTabOrigin: DWORD): Longint;
 external user32dll name 'TabbedTextOutA';

function TabbedTextOutW conv arg_stdcall (hDC: HDC; X, Y: DWORD; lpString: PWideChar; nCount, nTabPositions: DWORD;
 var lpnTabStopPositions; nTabOrigin: DWORD): Longint;
 external user32dll name 'TabbedTextOutW';

function TabbedTextOut conv arg_stdcall (hDC: HDC; X, Y: DWORD; lpString: PChar; nCount, nTabPositions: DWORD;
 var lpnTabStopPositions; nTabOrigin: DWORD): Longint;
 external user32dll name 'TabbedTextOutA';

function TileWindows conv arg_stdcall (hwndParent: HWND; wHow: DWORD; lpRect: PRect; cKids: DWORD; lpKids: Pointer): Word;
 external user32dll name 'TileWindows';

function ToAscii conv arg_stdcall (uVirtKey, uScanCode: DWORD; const KeyState: TKeyboardState;
 lpChar: PChar; uFlags: DWORD): DWORD;
 external user32dll name 'ToAscii';

function ToAsciiEx conv arg_stdcall (uVirtKey: DWORD; uScanCode: DWORD; const KeyState: TKeyboardState;
 lpChar: PChar; uFlags: DWORD; dwhkl: HKL): DWORD;
 external user32dll name 'ToAsciiEx';

function ToUnicode conv arg_stdcall (wVirtKey, wScanCode: DWORD; const KeyState: TKeyboardState;
 var pwszBuff; cchBuff: DWORD; wFlags: DWORD): DWORD;
 external user32dll name 'ToUnicode';

function ToUnicodeEx conv arg_stdcall (wVirtKey, wScanCode: DWORD; lpKeyState: PByte; pwszBuff: PWideChar; cchBuff: DWORD; wFlags: DWORD; dwhkl: HKL): DWORD;
 external user32dll name 'ToUnicodeEx';

function TrackMouseEvent conv arg_stdcall (var EventTrack: TTrackMouseEvent): BOOL;
 external user32dll name 'TrackMouseEvent';

function TrackPopupMenu conv arg_stdcall (hMenu: HMENU; uFlags: DWORD; x, y, nReserved: DWORD;
 hWnd: HWND; prcRect: PRect): BOOL;
 external user32dll name 'TrackPopupMenu';

function TrackPopupMenuEx conv arg_stdcall (hMenu: HMENU; Flags: DWORD; x, y: DWORD; Wnd: HWND; TPMParams: PTPMParams): BOOL;
 external user32dll name 'TrackPopupMenuEx';

function TranslateAcceleratorA conv arg_stdcall (hWnd: HWND; hAccTable: HACCEL; var lpMsg: TMsg): DWORD;
 external user32dll name 'TranslateAcceleratorA';

function TranslateAcceleratorW conv arg_stdcall (hWnd: HWND; hAccTable: HACCEL; var lpMsg: TMsg): DWORD;
 external user32dll name 'TranslateAcceleratorW';

function TranslateAccelerator conv arg_stdcall (hWnd: HWND; hAccTable: HACCEL; var lpMsg: TMsg): DWORD;
 external user32dll name 'TranslateAcceleratorA';

function TranslateCharsetInfo conv arg_stdcall (var lpSrc: DWORD; var lpCs: TCharsetInfo; dwFlags: DWORD): BOOL;
 external user32dll name 'TranslateCharsetInfo';

function TranslateMDISysAccel conv arg_stdcall (hWndClient: HWND; const lpMsg: TMsg): BOOL;
 external user32dll name 'TranslateMDISysAccel';

function TranslateMessage conv arg_stdcall (const lpMsg: TMsg): BOOL;
 external user32dll name 'TranslateMessage';

function UnhookWindowsHook conv arg_stdcall (nCode: DWORD; pfnFilterProc: TFNHookProc): BOOL;
 external user32dll name 'UnhookWindowsHook';

function UnhookWindowsHookEx conv arg_stdcall (hhk: HHOOK): BOOL;
 external user32dll name 'UnhookWindowsHookEx';

function UnionRect conv arg_stdcall (var lprcDst: TRect; const lprcSrc1, lprcSrc2: TRect): BOOL;
 external user32dll name 'UnionRect';

function UnloadKeyboardLayout conv arg_stdcall (hkl: HKL): BOOL;
 external user32dll name 'UnloadKeyboardLayout';

function UnpackDDElParam conv arg_stdcall (msg: DWORD; lParam: Longint; puiLo: PDWORD; puiHi: PDWORD): BOOL;
 external user32dll name 'UnpackDDElParam';

function UnregisterClassA conv arg_stdcall (lpClassName: PAnsiChar; hInstance: HINST): BOOL;
 external user32dll name 'UnregisterClassA';

function UnregisterClassW conv arg_stdcall (lpClassName: PWideChar; hInstance: HINST): BOOL;
 external user32dll name 'UnregisterClassW';

function UnregisterClass conv arg_stdcall (lpClassName: PChar; hInstance: HINST): BOOL;
 external user32dll name 'UnregisterClassA';

function UnregisterHotKey conv arg_stdcall (hWnd: HWND; id: DWORD): BOOL;
 external user32dll name 'UnregisterHotKey';

function UpdateWindow conv arg_stdcall (hWnd: HWND): BOOL;
 external user32dll name 'UpdateWindow';

function ValidateRect conv arg_stdcall (hWnd: HWND; lpRect: PRect): BOOL;
 external user32dll name 'ValidateRect';

function ValidateRgn conv arg_stdcall (hWnd: HWND; hRgn: HRGN): BOOL;
 external user32dll name 'ValidateRgn';

function VkKeyScanA conv arg_stdcall (ch: AnsiChar): SHORT;
 external user32dll name 'VkKeyScanA';

function VkKeyScanW conv arg_stdcall (ch: WideChar): SHORT;
 external user32dll name 'VkKeyScanW';

function VkKeyScan conv arg_stdcall (ch: Char): SHORT;
 external user32dll name 'VkKeyScanA';

function VkKeyScanExA conv arg_stdcall (ch: AnsiChar; dwhkl: HKL): SHORT;
 external user32dll name 'VkKeyScanExA';

function VkKeyScanExW conv arg_stdcall (ch: WideChar; dwhkl: HKL): SHORT;
 external user32dll name 'VkKeyScanExW';

function VkKeyScanEx conv arg_stdcall (ch: Char; dwhkl: HKL): SHORT;
 external user32dll name 'VkKeyScanExA';

function WaitForInputIdle conv arg_stdcall (hProcess: THandle; dwMilliseconds: DWORD): DWORD;
 external user32dll name 'WaitForInputIdle';

function WaitMessage: BOOL;
 external user32dll name 'WaitMessage';

function WinHelpA conv arg_stdcall (hWndMain: HWND; lpszHelp: PAnsiChar; uCommand: DWORD; dwData: DWORD): BOOL;
 external user32dll name 'WinHelpA';

function WinHelpW conv arg_stdcall (hWndMain: HWND; lpszHelp: PWideChar; uCommand: DWORD; dwData: DWORD): BOOL;
 external user32dll name 'WinHelpW';

function WinHelp conv arg_stdcall (hWndMain: HWND; lpszHelp: PChar; uCommand: DWORD; dwData: DWORD): BOOL;
 external user32dll name 'WinHelpA';

function WindowFromDC conv arg_stdcall (hDC: HDC): HWND;
 external user32dll name 'WindowFromDC';

function WindowFromPoint conv arg_stdcall (Point: TPoint): HWND;
 external user32dll name 'WindowFromPoint';

procedure keybd_event conv arg_stdcall (bVk: Byte; bScan: Byte; dwFlags, dwExtraInfo: DWORD);
 external user32dll name 'keybd_event';

procedure mouse_event conv arg_stdcall (dwFlags, dx, dy, dwData, dwExtraInfo: DWORD);
 external user32dll name 'mouse_event';

function wsprintfA conv arg_stdcall (Output: PAnsiChar; Format: PAnsiChar): DWORD;
 external user32dll name 'wsprintfA';

function wsprintfW conv arg_stdcall (Output: PWideChar; Format: PWideChar): DWORD;
 external user32dll name 'wsprintfW';

function wsprintf conv arg_stdcall (Output: PChar; Format: PChar): DWORD;
 external user32dll name 'wsprintfA';

function wvsprintfA conv arg_stdcall (Output: PAnsiChar; Format: PAnsiChar; arglist: va_list): DWORD;
 external user32dll name 'wvsprintfA';

function wvsprintfW conv arg_stdcall (Output: PWideChar; Format: PWideChar; arglist: va_list): DWORD;
 external user32dll name 'wvsprintfW';

function wvsprintf conv arg_stdcall (Output: PChar; Format: PChar; arglist: va_list): DWORD;
 external user32dll name 'wvsprintfA';

////////////////////////// GDI32.DLL IMPORT SECTION ///////////////////////////

function AbortDoc conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'AbortDoc';

function AbortPath conv arg_stdcall (DC: HDC): BOOL;
 external gdi32dll name 'AbortPath';

function AddFontResourceA conv arg_stdcall (p1: PAnsiChar): DWORD;
external gdi32dll name 'AddFontResourceA';

function AddFontResourceW conv arg_stdcall (p1: PWideChar): DWORD;
external gdi32dll name 'AddFontResourceW';

function AddFontResource conv arg_stdcall (p1: PChar): DWORD;
 external gdi32dll name 'AddFontResourceA';

function AngleArc conv arg_stdcall (DC: HDC; p2, p3: DWORD; p4: DWORD; p5, p6: Single): BOOL;
 external gdi32dll name 'AngleArc';

function AnimatePalette conv arg_stdcall (p1: HPALETTE; p2, p3: DWORD; p4: PPaletteEntry): BOOL;
 external gdi32dll name 'AnimatePalette';

function Arc conv arg_stdcall (hDC: HDC; left, top, right, bottom, startX, startY, endX, endY: DWORD): BOOL;
 external gdi32dll name 'Arc';

function ArcTo conv arg_stdcall (DC: HDC; RLeft, RTop, RRight, RBottom: DWORD; X1, Y1, X2, Y2: DWORD): BOOL;
 external gdi32dll name 'ArcTo';

function BeginPath conv arg_stdcall (hDC: HDC; left, top, right, bottom, startX, startY, endX, endY: DWORD): BOOL;
 external gdi32dll name 'BeginPath';

function BitBlt conv arg_stdcall (DestDC: HDC; X, Y, Width, Height: DWORD; SrcDC: HDC; XSrc, YSrc: DWORD; Rop: DWORD): BOOL;
 external gdi32dll name 'BitBlt';

function CancelDC conv arg_stdcall (DC: HDC): BOOL;
 external gdi32dll name 'CancelDC';

function CheckColorsInGamut conv arg_stdcall (DC: HDC; var RGBQuads, Results; Count: DWORD): BOOL;
 external gdi32dll name 'CheckColorsInGamut';

function ChoosePixelFormat conv arg_stdcall (DC: HDC; p2: PPixelFormatDescriptor): DWORD;
 external gdi32dll name 'ChoosePixelFormat';

function Chord conv arg_stdcall (DC: HDC; X1, Y1, X2, Y2, X3, Y3, X4, Y4: DWORD): BOOL;
 external gdi32dll name 'Chord';

function CloseEnhMetaFile conv arg_stdcall (DC: HDC): HENHMETAFILE;
 external gdi32dll name 'CloseEnhMetaFile';

function CloseFigure conv arg_stdcall (DC: HDC): BOOL;
 external gdi32dll name 'CloseFigure';

function CloseMetaFile conv arg_stdcall (DC: HDC): HMETAFILE;
 external gdi32dll name 'CloseMetaFile';

function ColorMatchToTarget conv arg_stdcall (DC: HDC; Target: HDC; Action: DWORD): BOOL;
 external gdi32dll name 'ColorMatchToTarget';

function CombineRgn conv arg_stdcall (p1, p2, p3: HRGN; p4: DWORD): DWORD;
 external gdi32dll name 'CombineRgn';

function CombineTransform conv arg_stdcall (var p1: TXForm; const p2, p3: TXForm): BOOL;
 external gdi32dll name 'CombineTransform';

function CopyEnhMetaFileA conv arg_stdcall (p1: HENHMETAFILE; p2: PAnsiChar): HENHMETAFILE;
 external gdi32dll name 'CopyEnhMetaFileA';

function CopyEnhMetaFileW conv arg_stdcall (p1: HENHMETAFILE; p2: PWideChar): HENHMETAFILE;
 external gdi32dll name 'CopyEnhMetaFileW';

function CopyEnhMetaFile conv arg_stdcall (p1: HENHMETAFILE; p2: PChar): HENHMETAFILE;
 external gdi32dll name 'CopyEnhMetaFileA';

function CopyMetaFileA conv arg_stdcall (p1: HMETAFILE; p2: PAnsiChar): HMETAFILE;
 external gdi32dll name 'CopyMetaFileA';

function CopyMetaFileW conv arg_stdcall (p1: HMETAFILE; p2: PWideChar): HMETAFILE;
 external gdi32dll name 'CopyMetaFileW';

function CopyMetaFile conv arg_stdcall (p1: HMETAFILE; p2: PChar): HMETAFILE;
 external gdi32dll name 'CopyMetaFileA';

function CreateBitmap conv arg_stdcall (Width, Height: DWORD; Planes, BitCount: Longint; Bits: Pointer): HBITMAP;
 external gdi32dll name 'CreateBitmap';

function CreateBitmapIndirect conv arg_stdcall (const p1: TBitmap): HBITMAP;
 external gdi32dll name 'CreateBitmapIndirect';

function CreateBrushIndirect conv arg_stdcall (const p1: TLogBrush): HBRUSH;
 external gdi32dll name 'CreateBrushIndirect';

function CreateColorSpaceA conv arg_stdcall (var ColorSpace: TLogColorSpaceA): HCOLORSPACE;
 external gdi32dll name 'CreateColorSpaceA';

function CreateColorSpaceW conv arg_stdcall (var ColorSpace: TLogColorSpaceW): HCOLORSPACE;
 external gdi32dll name 'CreateColorSpaceW';

function CreateColorSpace conv arg_stdcall (var ColorSpace: TLogColorSpace): HCOLORSPACE;
 external gdi32dll name 'CreateColorSpaceA';

function CreateCompatibleBitmap conv arg_stdcall (DC: HDC; Width, Height: DWORD): HBITMAP;
 external gdi32dll name 'CreateCompatibleBitmap';

function CreateCompatibleDC conv arg_stdcall (DC: HDC): HDC;
 external gdi32dll name 'CreateCompatibleDC';

function CreateDCA conv arg_stdcall (lpszDriver, lpszDevice, lpszOutput: PAnsiChar; lpdvmInit: PDeviceModeA): HDC;
 external gdi32dll name 'CreateDCA';

function CreateDCW conv arg_stdcall (lpszDriver, lpszDevice, lpszOutput: PWideChar; lpdvmInit: PDeviceModeW): HDC;
 external gdi32dll name 'CreateDCW';

function CreateDC conv arg_stdcall (lpszDriver, lpszDevice, lpszOutput: PChar; lpdvmInit: PDeviceMode): HDC;
 external gdi32dll name 'CreateDCA';

function CreateDIBPatternBrush conv arg_stdcall (p1: HGLOBAL; p2: DWORD): HBRUSH;
 external gdi32dll name 'CreateDIBPatternBrush';

function CreateDIBPatternBrushPt conv arg_stdcall (const p1: Pointer; p2: DWORD): HBRUSH;
 external gdi32dll name 'CreateDIBPatternBrushPt';

function CreateDIBSection conv arg_stdcall (DC: HDC; const p2: TBitmapInfo; p3: DWORD;
 var p4: Pointer; p5: THandle; p6: DWORD): HBITMAP;
 external gdi32dll name 'CreateDIBSection';

function CreateDIBitmap conv arg_stdcall (DC: HDC; var InfoHeader: TBitmapInfoHeader;
 dwUsage: DWORD; InitBits: PChar; var InitInfo: TBitmapInfo; wUsage: DWORD): HBITMAP;
 external gdi32dll name 'CreateDIBitmap';

function CreateDiscardableBitmap conv arg_stdcall (DC: HDC; p2, p3: DWORD): HBITMAP;
 external gdi32dll name 'CreateDiscardableBitmap';

function CreateEllipticRgn conv arg_stdcall (p1, p2, p3, p4: DWORD): HRGN;
 external gdi32dll name 'CreateEllipticRgn';

function CreateEllipticRgnIndirect conv arg_stdcall (const p1: TRect): HRGN;
 external gdi32dll name 'CreateEllipticRgnIndirect';

function CreateEnhMetaFileA conv arg_stdcall (DC: HDC; p2: PAnsiChar; p3: PRect; p4: PAnsiChar): HDC;
 external gdi32dll name 'CreateEnhMetaFileA';

function CreateEnhMetaFileW conv arg_stdcall (DC: HDC; p2: PWideChar; p3: PRect; p4: PWideChar): HDC;
 external gdi32dll name 'CreateEnhMetaFileW';

function CreateEnhMetaFile conv arg_stdcall (DC: HDC; p2: PChar; p3: PRect; p4: PChar): HDC;
 external gdi32dll name 'CreateEnhMetaFileA';

function CreateFontA conv arg_stdcall (nHeight, nWidth, nEscapement, nOrientaion, fnWeight: DWORD;
 fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharSet, fdwOutputPrecision,
 fdwClipPrecision, fdwQuality, fdwPitchAndFamily: DWORD; lpszFace: PAnsiChar): HFONT;
 external gdi32dll name 'CreateFontA';

function CreateFontW conv arg_stdcall (nHeight, nWidth, nEscapement, nOrientaion, fnWeight: DWORD;
 fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharSet, fdwOutputPrecision,
 fdwClipPrecision, fdwQuality, fdwPitchAndFamily: DWORD; lpszFace: PWideChar): HFONT;
 external gdi32dll name 'CreateFontW';

function CreateFont conv arg_stdcall (nHeight, nWidth, nEscapement, nOrientaion, fnWeight: DWORD;
 fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharSet, fdwOutputPrecision,
 fdwClipPrecision, fdwQuality, fdwPitchAndFamily: DWORD; lpszFace: PChar): HFONT;
 external gdi32dll name 'CreateFontA';

function CreateFontIndirectA conv arg_stdcall (const p1: TLogFontA): HFONT;
 external gdi32dll name 'CreateFontIndirectA';

function CreateFontIndirectW conv arg_stdcall (const p1: TLogFontW): HFONT;
 external gdi32dll name 'CreateFontIndirectW';

function CreateFontIndirect conv arg_stdcall (const p1: TLogFont): HFONT;
 external gdi32dll name 'CreateFontIndirectA';

function CreateHalftonePalette conv arg_stdcall (DC: HDC): HPALETTE;
 external gdi32dll name 'CreateHalftonePalette';

function CreateHatchBrush conv arg_stdcall (p1: DWORD; p2: COLORREF): HBRUSH;
 external gdi32dll name 'CreateHatchBrush';

function CreateICA conv arg_stdcall (lpszDriver, lpszDevice, lpszOutput: PAnsiChar; lpdvmInit: PDeviceModeA): HDC;
external gdi32dll name 'CreateICA';

function CreateICW conv arg_stdcall (lpszDriver, lpszDevice, lpszOutput: PWideChar; lpdvmInit: PDeviceModeW): HDC;
 external gdi32dll name 'CreateICW';

function CreateIC conv arg_stdcall (lpszDriver, lpszDevice, lpszOutput: PChar; lpdvmInit: PDeviceMode): HDC;
 external gdi32dll name 'CreateICA';

function CreateMetaFileA conv arg_stdcall (p1: PAnsiChar): HDC;
 external gdi32dll name 'CreateMetaFileA';

function CreateMetaFileW conv arg_stdcall (p1: PWideChar): HDC;
 external gdi32dll name 'CreateMetaFileW';

function CreateMetaFile conv arg_stdcall (p1: PChar): HDC;
 external gdi32dll name 'CreateMetaFileA';

function CreatePalette conv arg_stdcall (const LogPalette: TLogPalette): HPalette;
 external gdi32dll name 'CreatePalette';

function CreatePatternBrush conv arg_stdcall (Bitmap: HBITMAP): HBRUSH;
 external gdi32dll name 'CreatePatternBrush';

function CreatePen conv arg_stdcall (Style, Width: DWORD; Color: COLORREF): HPEN;
 external gdi32dll name 'CreatePen';

function CreatePenIndirect conv arg_stdcall (const LogPen: TLogPen): HPEN;
 external gdi32dll name 'CreatePenIndirect';

function CreatePolyPolygonRgn conv arg_stdcall (const pPtStructs; const pIntArray; p3, p4: DWORD): HRGN;
 external gdi32dll name 'CreatePolyPolygonRgn';

function CreatePolygonRgn conv arg_stdcall (const Points; Count, FillMode: DWORD): HRGN;
 external gdi32dll name 'CreatePolygonRgn';

function CreateRectRgn conv arg_stdcall (p1, p2, p3, p4: DWORD): HRGN;
 external gdi32dll name 'CreateRectRgn';

function CreateRectRgnIndirect conv arg_stdcall (const p1: TRect): HRGN;
 external gdi32dll name 'CreateRectRgnIndirect';

function CreateRoundRectRgn conv arg_stdcall (p1, p2, p3, p4, p5, p6: DWORD): HRGN;
 external gdi32dll name 'CreateRoundRectRgn';

function CreateScalableFontResourceA conv arg_stdcall (p1: DWORD; p2, p3, p4: PAnsiChar): BOOL;
 external gdi32dll name 'CreateScalableFontResourceA';

function CreateScalableFontResourceW conv arg_stdcall (p1: DWORD; p2, p3, p4: PWideChar): BOOL;
 external gdi32dll name 'CreateScalableFontResourceW';

function CreateScalableFontResource conv arg_stdcall (p1: DWORD; p2, p3, p4: PChar): BOOL;
 external gdi32dll name 'CreateScalableFontResourceA';

function CreateSolidBrush conv arg_stdcall (p1: COLORREF): HBRUSH;
 external gdi32dll name 'CreateSolidBrush';

function DPtoLP conv arg_stdcall (DC: HDC; var Points; Count: DWORD): BOOL;
 external gdi32dll name 'DPtoLP';

function DeleteColorSpace conv arg_stdcall (ColorSpace: HCOLORSPACE): BOOL;
 external gdi32dll name 'DeleteColorSpace';

function DeleteDC conv arg_stdcall (DC: HDC): BOOL;
 external gdi32dll name 'DeleteDC';

function DeleteEnhMetaFile conv arg_stdcall (p1: HENHMETAFILE): BOOL;
 external gdi32dll name 'DeleteEnhMetaFile';

function DeleteMetaFile conv arg_stdcall (p1: HMETAFILE): BOOL;
 external gdi32dll name 'DeleteMetaFile';

function DeleteObject conv arg_stdcall (p1: HGDIOBJ): BOOL;
 external gdi32dll name 'DeleteObject';

function DescribePixelFormat conv arg_stdcall (DC: HDC; p2: DWORD; p3: DWORD; var p4: TPixelFormatDescriptor): BOOL;
 external gdi32dll name 'DescribePixelFormat';

function DeviceCapabilitiesExA conv arg_stdcall (pDriverName, pDeviceName, pPort: PAnsiChar;
 iIndex: DWORD; pOutput: PAnsiChar; DevMode: PDeviceModeA): DWORD;
 external gdi32dll name 'DeviceCapabilitiesA';

function DeviceCapabilitiesExW conv arg_stdcall (pDriverName, pDeviceName, pPort: PWideChar;
 iIndex: DWORD; pOutput: PWideChar; DevMode: PDeviceModeW): DWORD;
 external gdi32dll name 'DeviceCapabilitiesW';

function DeviceCapabilitiesEx conv arg_stdcall (pDriverName, pDeviceName, pPort: PChar;
 iIndex: DWORD; pOutput: PChar; DevMode: PDeviceMode): DWORD;
 external gdi32dll name 'DeviceCapabilitiesA';

function DrawEscape conv arg_stdcall (DC: HDC; p2, p3: DWORD; p4: LPCSTR): BOOL;
 external gdi32dll name 'DrawEscape';

function Ellipse conv arg_stdcall (DC: HDC; X1, Y1, X2, Y2: DWORD): BOOL;
 external gdi32dll name 'Ellipse';

function EndDoc conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'EndDoc';

function EndPage conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'EndPage';

function EndPath conv arg_stdcall (DC: HDC): BOOL;
 external gdi32dll name 'EndPath';

function EnumEnhMetaFile conv arg_stdcall (DC: HDC; p2: HENHMETAFILE; p3: TFNEnhMFEnumProc; p4: Pointer; const p5: TRect): BOOL;
 external gdi32dll name 'EnumEnhMetaFile';

function EnumFontFamiliesA conv arg_stdcall (DC: HDC; p2: PAnsiChar; p3: TFNFontEnumProcA; p4: LPARAM): BOOL;
 external gdi32dll name 'EnumFontFamiliesA';

function EnumFontFamiliesW conv arg_stdcall (DC: HDC; p2: PWideChar; p3: TFNFontEnumProcW; p4: LPARAM): BOOL;
 external gdi32dll name 'EnumFontFamiliesW';

function EnumFontFamilies conv arg_stdcall (DC: HDC; p2: PChar; p3: TFNFontEnumProc; p4: LPARAM): BOOL;
 external gdi32dll name 'EnumFontFamiliesA';

function EnumFontFamiliesExA conv arg_stdcall (DC: HDC; var p2: TLogFontA; p3: TFNFontEnumProcA; p4: LPARAM; p5: DWORD): BOOL;
 external gdi32dll name 'EnumFontFamiliesExA';

function EnumFontFamiliesExW conv arg_stdcall (DC: HDC; var p2: TLogFontW; p3: TFNFontEnumProcW; p4: LPARAM; p5: DWORD): BOOL;
 external gdi32dll name 'EnumFontFamiliesExW';

function EnumFontFamiliesEx conv arg_stdcall (DC: HDC; var p2: TLogFont; p3: TFNFontEnumProc; p4: LPARAM; p5: DWORD): BOOL;
 external gdi32dll name 'EnumFontFamiliesExA';

function EnumFontsA conv arg_stdcall (DC: HDC; lpszFace: PAnsiChar; fntenmprc: TFNFontEnumProcA; lpszData: PChar): DWORD;
external gdi32dll name 'EnumFontsA';

function EnumFontsW conv arg_stdcall (DC: HDC; lpszFace: PWideChar; fntenmprc: TFNFontEnumProcW; lpszData: PChar): DWORD;
 external gdi32dll name 'EnumFontsW';

function EnumFonts conv arg_stdcall (DC: HDC; lpszFace: PChar; fntenmprc: TFNFontEnumProc; lpszData: PChar): DWORD;
 external gdi32dll name 'EnumFontsA';

function EnumICMProfilesA conv arg_stdcall (DC: HDC; ICMProc: TFNICMEnumProc; p3: LPARAM): DWORD;
 external gdi32dll name 'EnumICMProfilesA';

function EnumICMProfilesW conv arg_stdcall (DC: HDC; ICMProc: TFNICMEnumProc; p3: LPARAM): DWORD;
 external gdi32dll name 'EnumICMProfilesW';

function EnumICMProfiles conv arg_stdcall (DC: HDC; ICMProc: TFNICMEnumProc; p3: LPARAM): DWORD;
 external gdi32dll name 'EnumICMProfilesA';

function EnumMetaFile conv arg_stdcall (DC: HDC; p2: HMETAFILE; p3: TFNMFEnumProc; p4: LPARAM): BOOL;
 external gdi32dll name 'EnumMetaFile';

function EnumObjects conv arg_stdcall (DC: HDC; p2: DWORD; p3: TFNGObjEnumProc; p4: LPARAM): DWORD;
 external gdi32dll name 'EnumObjects';

function EqualRgn conv arg_stdcall (p1, p2: HRGN): BOOL;
 external gdi32dll name 'EqualRgn';

function Escape conv arg_stdcall (DC: HDC; p2, p3: DWORD; p4: LPCSTR; p5: Pointer): DWORD;
 external gdi32dll name 'Escape';

function ExcludeClipRect conv arg_stdcall (DC: HDC; p2, p3, p4, p5: DWORD): DWORD;
 external gdi32dll name 'ExcludeClipRect';

function ExtCreatePen conv arg_stdcall (PenStyle, Width: DWORD; const Brush: TLogBrush; StyleCount: DWORD; Style: Pointer): HPEN;
 external gdi32dll name 'ExtCreatePen';

function ExtCreateRegion conv arg_stdcall (p1: PXForm; p2: DWORD; const p3: TRgnData): HRGN;
 external gdi32dll name 'ExtCreateRegion';

function ExtEscape conv arg_stdcall (DC: HDC; p2, p3: DWORD; const p4: LPCSTR; p5: DWORD; p6: LPSTR): DWORD;
 external gdi32dll name 'ExtEscape';

function ExtFloodFill conv arg_stdcall (DC: HDC; X, Y: DWORD; Color: COLORREF; FillType: DWORD): BOOL;
 external gdi32dll name 'ExtFloodFill';

function ExtSelectClipRgn conv arg_stdcall (DC: HDC; p2: HRGN; p3: DWORD): DWORD;
 external gdi32dll name 'ExtSelectClipRgn';

function ExtTextOutA conv arg_stdcall (DC: HDC; X, Y: DWORD; Options: Longint;
 Rect: PRect; Str: PAnsiChar; Count: Longint; Dx: PDWORD): BOOL;
 external gdi32dll name 'ExtTextOutA';

function ExtTextOutW conv arg_stdcall (DC: HDC; X, Y: DWORD; Options: Longint;
 Rect: PRect; Str: PWideChar; Count: Longint; Dx: PDWORD): BOOL;
 external gdi32dll name 'ExtTextOutW';

function ExtTextOut conv arg_stdcall (DC: HDC; X, Y: DWORD; Options: Longint;
 Rect: PRect; Str: PChar; Count: Longint; Dx: PDWORD): BOOL;
 external gdi32dll name 'ExtTextOutA';

function FillPath conv arg_stdcall (DC: HDC): BOOL;
 external gdi32dll name 'FillPath';

function FillRgn conv arg_stdcall (DC: HDC; p2: HRGN; p3: HBRUSH): BOOL;
 external gdi32dll name 'FillRgn';

function FlattenPath conv arg_stdcall (DC: HDC): BOOL;
 external gdi32dll name 'FlattenPath';

function FloodFill conv arg_stdcall (DC: HDC; nXStart, nYStart: DWORD; crFill: COLORREF): BOOL;
 external gdi32dll name 'FloodFill';

function FrameRgn conv arg_stdcall (DC: HDC; p2: HRGN; p3: HBRUSH; p4, p5: DWORD): BOOL;
 external gdi32dll name 'FrameRgn';

function GdiComment conv arg_stdcall (DC: HDC; p2: DWORD; p3: PChar): BOOL;
 external gdi32dll name 'GdiComment';

function GdiFlush: BOOL;
 external gdi32dll name 'GdiFlush';

function GdiGetBatchLimit: DWORD;
 external gdi32dll name 'GdiGetBatchLimit';

function GdiSetBatchLimit conv arg_stdcall (Limit: DWORD): DWORD;
 external gdi32dll name 'GdiSetBatchLimit';

function GetArcDirection conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'GetArcDirection';

function GetAspectRatioFilterEx conv arg_stdcall (DC: HDC; var p2: TSize): BOOL;
 external gdi32dll name 'GetAspectRatioFilterEx';

function GetBitmapBits conv arg_stdcall (Bitmap: HBITMAP; Count: Longint; Bits: Pointer): Longint;
 external gdi32dll name 'GetBitmapBits';

function GetBitmapDimensionEx conv arg_stdcall (p1: HBITMAP; var p2: TSize): BOOL;
 external gdi32dll name 'GetBitmapDimensionEx';

function GetBkColor conv arg_stdcall (hDC: HDC): COLORREF;
 external gdi32dll name 'GetBkColor';

function GetBkMode conv arg_stdcall (hDC: HDC): DWORD;
 external gdi32dll name 'GetBkMode';

function GetBoundsRect conv arg_stdcall (DC: HDC; var p2: TRect; p3: DWORD): DWORD;
 external gdi32dll name 'GetBoundsRect';

function GetBrushOrgEx conv arg_stdcall (DC: HDC; var p2: TPoint): BOOL;
 external gdi32dll name 'GetBrushOrgEx';

function GetCharABCWidthsA conv arg_stdcall (DC: HDC; p2, p3: DWORD; const ABCStructs): BOOL;
 external gdi32dll name 'GetCharABCWidthsA';

function GetCharABCWidthsW conv arg_stdcall (DC: HDC; p2, p3: DWORD; const ABCStructs): BOOL;
 external gdi32dll name 'GetCharABCWidthsW';

function GetCharABCWidths conv arg_stdcall (DC: HDC; p2, p3: DWORD; const ABCStructs): BOOL;
 external gdi32dll name 'GetCharABCWidthsA';

function GetCharABCWidthsFloatA conv arg_stdcall (DC: HDC; p2, p3: DWORD; const ABCFloatSturcts): BOOL;
 external gdi32dll name 'GetCharABCWidthsFloatA';

function GetCharABCWidthsFloatW conv arg_stdcall (DC: HDC; p2, p3: DWORD; const ABCFloatSturcts): BOOL;
 external gdi32dll name 'GetCharABCWidthsFloatW';

function GetCharABCWidthsFloat conv arg_stdcall (DC: HDC; p2, p3: DWORD; const ABCFloatSturcts): BOOL;
 external gdi32dll name 'GetCharABCWidthsFloatA';

function GetCharWidth32A conv arg_stdcall (DC: HDC; p2, p3: DWORD; const Widths): BOOL;
 external gdi32dll name 'GetCharWidth32A';

function GetCharWidth32W conv arg_stdcall (DC: HDC; p2, p3: DWORD; const Widths): BOOL;
 external gdi32dll name 'GetCharWidth32W';

function GetCharWidth32 conv arg_stdcall (DC: HDC; p2, p3: DWORD; const Widths): BOOL;
 external gdi32dll name 'GetCharWidth32A';

function GetCharWidthA conv arg_stdcall (DC: HDC; p2, p3: DWORD; const Widths): BOOL;
 external gdi32dll name 'GetCharWidthA';

function GetCharWidthW conv arg_stdcall (DC: HDC; p2, p3: DWORD; const Widths): BOOL;
 external gdi32dll name 'GetCharWidthW';

function GetCharWidth conv arg_stdcall (DC: HDC; p2, p3: DWORD; const Widths): BOOL;
 external gdi32dll name 'GetCharWidthA';

function GetCharWidthFloatA conv arg_stdcall (DC: HDC; p2, p3: DWORD; const Widths): BOOL;
 external gdi32dll name 'GetCharWidthFloatA';

function GetCharWidthFloatW conv arg_stdcall (DC: HDC; p2, p3: DWORD; const Widths): BOOL;
 external gdi32dll name 'GetCharWidthFloatW';

function GetCharWidthFloat conv arg_stdcall (DC: HDC; p2, p3: DWORD; const Widths): BOOL;
 external gdi32dll name 'GetCharWidthFloatA';

function GetCharacterPlacementA conv arg_stdcall (DC: HDC; lpString: PAnsiChar; nCount, nMaxExtent: Longint; var lpResults: TGCPResults; dwFlags : DWORD): DWORD;
 external gdi32dll name 'GetCharacterPlacementA';

function GetCharacterPlacementW conv arg_stdcall (DC: HDC; lpString: PWideChar; nCount, nMaxExtent: Longint; var lpResults: TGCPResults; dwFlags : DWORD): DWORD;
 external gdi32dll name 'GetCharacterPlacementW';

function GetCharacterPlacement conv arg_stdcall (DC: HDC; lpString: PChar; nCount, nMaxExtent: Longint; var lpResults: TGCPResults; dwFlags : DWORD): DWORD;
 external gdi32dll name 'GetCharacterPlacementA';

function GetClipBox conv arg_stdcall (DC: HDC; var Rect: TRect): DWORD;
 external gdi32dll name 'GetClipBox';

function GetClipRgn conv arg_stdcall (DC: HDC; rgn: HRGN): DWORD;
 external gdi32dll name 'GetClipRgn';

function GetColorAdjustment conv arg_stdcall (DC: HDC; var p2: TColorAdjustment): BOOL;
 external gdi32dll name 'GetColorAdjustment';

function GetColorSpace conv arg_stdcall (DC: HDC): THandle;
 external gdi32dll name 'GetColorSpace';

function GetCurrentObject conv arg_stdcall (DC: HDC; p2: DWORD): HGDIOBJ;
 external gdi32dll name 'GetCurrentObject';

function GetCurrentPositionEx conv arg_stdcall (DC: HDC; Point: PPoint): BOOL;
 external gdi32dll name 'GetCurrentPositionEx';

function GetDCOrgEx conv arg_stdcall (DC: HDC; var Origin: TPoint): BOOL;
 external gdi32dll name 'GetDCOrgEx';

function GetDIBColorTable conv arg_stdcall (DC: HDC; p2, p3: DWORD; var RGBQuadStructs): DWORD;
 external gdi32dll name 'GetDIBColorTable';

function GetDIBits conv arg_stdcall (DC: HDC; Bitmap: HBitmap; StartScan, NumScans: DWORD;
 Bits: Pointer; var BitInfo: TBitmapInfo; Usage: DWORD): DWORD;
 external gdi32dll name 'GetDIBits';

function GetDeviceCaps conv arg_stdcall (DC: HDC; Index: DWORD): DWORD;
 external gdi32dll name 'GetDeviceCaps';

function GetDeviceGammaRamp conv arg_stdcall (DC: HDC; var Ramp): BOOL;
 external gdi32dll name 'GetDeviceGammaRamp';

function GetEnhMetaFileA conv arg_stdcall (p1: PAnsiChar): HENHMETAFILE;
 external gdi32dll name 'GetEnhMetaFileA';

function GetEnhMetaFileW conv arg_stdcall (p1: PWideChar): HENHMETAFILE;
 external gdi32dll name 'GetEnhMetaFileW';

function GetEnhMetaFile conv arg_stdcall (p1: PChar): HENHMETAFILE;
 external gdi32dll name 'GetEnhMetaFileA';

function GetEnhMetaFileBits conv arg_stdcall (p1: HENHMETAFILE; p2: DWORD; p3: PByte): DWORD;
 external gdi32dll name 'GetEnhMetaFileBits';

function GetEnhMetaFileDescriptionA conv arg_stdcall (p1: HENHMETAFILE; p2: DWORD; p3: PAnsiChar): DWORD;
 external gdi32dll name 'GetEnhMetaFileDescriptionA';

function GetEnhMetaFileDescriptionW conv arg_stdcall (p1: HENHMETAFILE; p2: DWORD; p3: PWideChar): DWORD;
 external gdi32dll name 'GetEnhMetaFileDescriptionW';

function GetEnhMetaFileDescription conv arg_stdcall (p1: HENHMETAFILE; p2: DWORD; p3: PChar): DWORD;
 external gdi32dll name 'GetEnhMetaFileDescriptionA';

function GetEnhMetaFileHeader conv arg_stdcall (p1: HENHMETAFILE; p2: DWORD; p3: PEnhMetaHeader): DWORD;
 external gdi32dll name 'GetEnhMetaFileHeader';

function GetEnhMetaFilePaletteEntries conv arg_stdcall (p1: HENHMETAFILE; p2: DWORD; p3: Pointer): DWORD;
 external gdi32dll name 'GetEnhMetaFilePaletteEntries';

function GetEnhMetaFilePixelFormat conv arg_stdcall (p1: HENHMETAFILE; p2: DWord; var p3: TPixelFormatDescriptor): DWORD;
 external gdi32dll name 'GetEnhMetaFilePixelFormat';

function GetFontData conv arg_stdcall (DC: HDC; p2, p3: DWORD; p4: Pointer; p5: DWORD): DWORD;
 external gdi32dll name 'GetFontData';

function GetFontLanguageInfo conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'GetFontLanguageInfo';

function GetGlyphOutlineA conv arg_stdcall (DC: HDC; p2, p3: DWORD; const p4: TGlyphMetrics; p5: DWORD; p6: Pointer; const p7: TMat2): DWORD;
 external gdi32dll name 'GetGlyphOutlineA';

function GetGlyphOutlineW conv arg_stdcall (DC: HDC; p2, p3: DWORD; const p4: TGlyphMetrics; p5: DWORD; p6: Pointer; const p7: TMat2): DWORD;
 external gdi32dll name 'GetGlyphOutlineW';

function GetGlyphOutline conv arg_stdcall (DC: HDC; p2, p3: DWORD; const p4: TGlyphMetrics; p5: DWORD; p6: Pointer; const p7: TMat2): DWORD;
 external gdi32dll name 'GetGlyphOutlineA';

function GetGraphicsMode conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'GetGraphicsMode';

function GetICMProfileA conv arg_stdcall (DC: HDC; var Size: DWORD; Name: PAnsiChar): BOOL;
external gdi32dll name 'GetICMProfileA';

function GetICMProfileW conv arg_stdcall (DC: HDC; var Size: DWORD; Name: PWideChar): BOOL;
external gdi32dll name 'GetICMProfileW';

function GetICMProfile conv arg_stdcall (DC: HDC; var Size: DWORD; Name: PChar): BOOL;
 external gdi32dll name 'GetICMProfileA';

function GetKerningPairs conv arg_stdcall (DC: HDC; Count: DWORD; var KerningPairs): DWORD;
 external gdi32dll name 'GetKerningPairs';

function GetLogColorSpaceA conv arg_stdcall (p1: HCOLORSPACE; var ColorSpace: TLogColorSpaceA; Size: DWORD): BOOL;
 external gdi32dll name 'GetLogColorSpaceA';

function GetLogColorSpaceW conv arg_stdcall (p1: HCOLORSPACE; var ColorSpace: TLogColorSpaceW; Size: DWORD): BOOL;
 external gdi32dll name 'GetLogColorSpaceW';

function GetLogColorSpace conv arg_stdcall (p1: HCOLORSPACE; var ColorSpace: TLogColorSpace; Size: DWORD): BOOL;
 external gdi32dll name 'GetLogColorSpaceA';

function GetMapMode conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'GetMapMode';

function GetMetaFileA conv arg_stdcall (p1: PAnsiChar): HMETAFILE;
external gdi32dll name 'GetMetaFileA';

function GetMetaFileW conv arg_stdcall (p1: PWideChar): HMETAFILE;
external gdi32dll name 'GetMetaFileW';

function GetMetaFile conv arg_stdcall (p1: PChar): HMETAFILE;
 external gdi32dll name 'GetMetaFileA';

function GetMetaFileBitsEx conv arg_stdcall (p1: HMETAFILE; p2: DWORD; p3: Pointer): DWORD;
 external gdi32dll name 'GetMetaFileBitsEx';

function GetMetaRgn conv arg_stdcall (DC: HDC; rgn: HRGN): DWORD;
 external gdi32dll name 'GetMetaRgn';

function GetMiterLimit conv arg_stdcall (DC: HDC; var Limit: Single): BOOL;
 external gdi32dll name 'GetMiterLimit';

function GetNearestColor conv arg_stdcall (DC: HDC; p2: COLORREF): COLORREF;
 external gdi32dll name 'GetNearestColor';

function GetNearestPaletteIndex conv arg_stdcall (p1: HPALETTE; p2: COLORREF): DWORD;
 external gdi32dll name 'GetNearestPaletteIndex';

function GetObjectA conv arg_stdcall (p1: HGDIOBJ; p2: DWORD; p3: Pointer): DWORD;
 external gdi32dll name 'GetObjectA';

function GetObjectW conv arg_stdcall (p1: HGDIOBJ; p2: DWORD; p3: Pointer): DWORD;
 external gdi32dll name 'GetObjectW';

function GetObject conv arg_stdcall (p1: HGDIOBJ; p2: DWORD; p3: Pointer): DWORD;
 external gdi32dll name 'GetObjectA';

function GetObjectType conv arg_stdcall (h: HGDIOBJ): DWORD;
 external gdi32dll name 'GetObjectType';

function GetOutlineTextMetricsA conv arg_stdcall (DC: HDC; p2: DWORD; OTMetricStructs: Pointer): DWORD;
 external gdi32dll name 'GetOutlineTextMetricsA';

function GetOutlineTextMetricsW conv arg_stdcall (DC: HDC; p2: DWORD; OTMetricStructs: Pointer): DWORD;
 external gdi32dll name 'GetOutlineTextMetricsW';

function GetOutlineTextMetrics conv arg_stdcall (DC: HDC; p2: DWORD; OTMetricStructs: Pointer): DWORD;
 external gdi32dll name 'GetOutlineTextMetricsA';

function GetPaletteEntries conv arg_stdcall (Palette: HPALETTE; StartIndex, NumEntries: DWORD; var PaletteEntries): DWORD;
 external gdi32dll name 'GetPaletteEntries';

function GetPath conv arg_stdcall (DC: HDC; var Points, Types; nSize: DWORD): DWORD;
 external gdi32dll name 'GetPath';

function GetPixel conv arg_stdcall (DC: HDC; X, Y: DWORD): COLORREF;
 external gdi32dll name 'GetPixel';

function GetPixelFormat conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'GetPixelFormat';

function GetPolyFillMode conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'GetPolyFillMode';

function GetROP2 conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'GetROP2';

function GetRasterizerCaps conv arg_stdcall (var p1: TRasterizerStatus; p2: DWORD): BOOL;
 external gdi32dll name 'GetRasterizerCaps';

function GetRegionData conv arg_stdcall (RGN: HRGN; p2: DWORD; p3: PRgnData): DWORD;
 external gdi32dll name 'GetRegionData';

function GetRgnBox conv arg_stdcall (RGN: HRGN; var p2: TRect): DWORD;
 external gdi32dll name 'GetRgnBox';

function GetStockObject conv arg_stdcall (Index: DWORD): HGDIOBJ;
 external gdi32dll name 'GetStockObject';

function GetStretchBltMode conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'GetStretchBltMode';

function GetSystemPaletteEntries conv arg_stdcall (DC: HDC; StartIndex, NumEntries: DWORD; var PaletteEntries): DWORD;
 external gdi32dll name 'GetSystemPaletteEntries';

function GetSystemPaletteUse conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'GetSystemPaletteUse';

function GetTextAlign conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'GetTextAlign';

function GetTextCharacterExtra conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'GetTextCharacterExtra';

function GetTextCharset conv arg_stdcall (hdc: HDC): DWORD;
 external gdi32dll name 'GetTextCharset';

function GetTextCharsetInfo conv arg_stdcall (hdc: HDC; lpSig: PFontSignature; dwFlags: DWORD): BOOL;
 external gdi32dll name 'GetTextCharsetInfo';

function GetTextColor conv arg_stdcall (DC: HDC): COLORREF;
 external gdi32dll name 'GetTextColor';

function GetTextExtentExPointA conv arg_stdcall (DC: HDC; p2: PAnsiChar;
p3, p4: DWORD; var p5, p6: DWORD; var p7: TSize): BOOL;
external gdi32dll name 'GetTextExtentExPointA';

function GetTextExtentExPointW conv arg_stdcall (DC: HDC; p2: PWideChar;
p3, p4: DWORD; var p5, p6: DWORD; var p7: TSize): BOOL;
external gdi32dll name 'GetTextExtentExPointW';

function GetTextExtentExPoint conv arg_stdcall (DC: HDC; p2: PChar;
 p3, p4: DWORD; var p5, p6: DWORD; var p7: TSize): BOOL;
 external gdi32dll name 'GetTextExtentExPointA';

function GetTextExtentPoint32A conv arg_stdcall (DC: HDC; Str: PAnsiChar; Count: DWORD; var Size: TSize): BOOL;
external gdi32dll name 'GetTextExtentPoint32A';

function GetTextExtentPoint32W conv arg_stdcall (DC: HDC; Str: PWideChar; Count: DWORD; var Size: TSize): BOOL;
external gdi32dll name 'GetTextExtentPoint32W';

function GetTextExtentPoint32 conv arg_stdcall (DC: HDC; Str: PChar; Count: DWORD; var Size: TSize): BOOL;
 external gdi32dll name 'GetTextExtentPoint32A';

function GetTextExtentPointA conv arg_stdcall (DC: HDC; Str: PAnsiChar; Count: DWORD; var Size: TSize): BOOL;
external gdi32dll name 'GetTextExtentPointA';

function GetTextExtentPointW conv arg_stdcall (DC: HDC; Str: PWideChar; Count: DWORD; var Size: TSize): BOOL;
external gdi32dll name 'GetTextExtentPointW';

function GetTextExtentPoint conv arg_stdcall (DC: HDC; Str: PChar; Count: DWORD; var Size: TSize): BOOL;
 external gdi32dll name 'GetTextExtentPointA';

function GetTextFaceA conv arg_stdcall (DC: HDC; Count: DWORD; Buffer: PAnsiChar): DWORD;
external gdi32dll name 'GetTextFaceA';

function GetTextFaceW conv arg_stdcall (DC: HDC; Count: DWORD; Buffer: PWideChar): DWORD;
external gdi32dll name 'GetTextFaceW';

function GetTextFace conv arg_stdcall (DC: HDC; Count: DWORD; Buffer: PChar): DWORD;
 external gdi32dll name 'GetTextFaceA';

function GetTextMetricsA conv arg_stdcall (DC: HDC; var TM: TTextMetricA): BOOL;
 external gdi32dll name 'GetTextMetricsA';

function GetTextMetricsW conv arg_stdcall (DC: HDC; var TM: TTextMetricW): BOOL;
 external gdi32dll name 'GetTextMetricsW';

function GetTextMetrics conv arg_stdcall (DC: HDC; var TM: TTextMetric): BOOL;
 external gdi32dll name 'GetTextMetricsA';

function GetViewportExtEx conv arg_stdcall (DC: HDC; var Size: TSize): BOOL;
 external gdi32dll name 'GetViewportExtEx';

function GetViewportOrgEx conv arg_stdcall (DC: HDC; var Point: TPoint): BOOL;
 external gdi32dll name 'GetViewportOrgEx';

function GetWinMetaFileBits conv arg_stdcall (p1: HENHMETAFILE; p2: DWORD; p3: PByte; p4: DWORD; p5: HDC): DWORD;
 external gdi32dll name 'GetWinMetaFileBits';

function GetWindowExtEx conv arg_stdcall (DC: HDC; var Size: TSize): BOOL;
 external gdi32dll name 'GetWindowExtEx';

function GetWindowOrgEx conv arg_stdcall (DC: HDC; var Point: TPoint): BOOL;
 external gdi32dll name 'GetWindowOrgEx';

function GetWorldTransform conv arg_stdcall (DC: HDC; var p2: TXForm): BOOL;
 external gdi32dll name 'GetWorldTransform';

function IntersectClipRect conv arg_stdcall (DC: HDC; X1, Y1, X2, Y2: DWORD): DWORD;
 external gdi32dll name 'IntersectClipRect';

function InvertRgn conv arg_stdcall (DC: HDC; p2: HRGN): BOOL;
 external gdi32dll name 'InvertRgn';

function LPtoDP conv arg_stdcall (DC: HDC; var Points; Count: DWORD): BOOL;
 external gdi32dll name 'LPtoDP';

function LineDDA conv arg_stdcall (p1, p2, p3, p4: DWORD; p5: TFNLineDDAProc; p6: LPARAM): BOOL;
 external gdi32dll name 'LineDDA';

function LineTo conv arg_stdcall (DC: HDC; X, Y: DWORD): BOOL;
 external gdi32dll name 'LineTo';

function MaskBlt conv arg_stdcall (DC: HDC; p2, p3, p4, p5: DWORD; p6: HDC;
 p7, p8: DWORD; p9: HBITMAP; p10, p11: DWORD; p12: DWORD): BOOL;
 external gdi32dll name 'MaskBlt';

function ModifyWorldTransform conv arg_stdcall (DC: HDC; const p2: TXForm; p3: DWORD): BOOL;
 external gdi32dll name 'ModifyWorldTransform';

function MoveToEx conv arg_stdcall (DC: HDC; p2, p3: DWORD; p4: PPoint): BOOL;
 external gdi32dll name 'MoveToEx';

function OffsetClipRgn conv arg_stdcall (DC: HDC; p2, p3: DWORD): DWORD;
 external gdi32dll name 'OffsetClipRgn';

function OffsetRgn conv arg_stdcall (RGN: HRGN; p2, p3: DWORD): DWORD;
 external gdi32dll name 'OffsetRgn';

function OffsetViewportOrgEx conv arg_stdcall (DC: HDC; X, Y: DWORD; var Points): BOOL;
 external gdi32dll name 'OffsetViewportOrgEx';

function OffsetWindowOrgEx conv arg_stdcall (DC: HDC; X, Y: DWORD; var Points): BOOL;
 external gdi32dll name 'OffsetWindowOrgEx';

function PaintRgn conv arg_stdcall (DC: HDC; RGN: HRGN): BOOL;
 external gdi32dll name 'PaintRgn';

function PatBlt conv arg_stdcall (DC: HDC; X, Y, Width, Height: DWORD; Rop: DWORD): BOOL;
 external gdi32dll name 'PatBlt';

function PathToRegion conv arg_stdcall (DC: HDC): HRGN;
 external gdi32dll name 'PathToRegion';

function Pie conv arg_stdcall (DC: HDC; X1, Y1, X2, Y2, X3, Y3, X4, Y4: DWORD): BOOL;
 external gdi32dll name 'Pie';

function PlayEnhMetaFile conv arg_stdcall (DC: HDC; p2: HENHMETAFILE; const p3: TRect): BOOL;
 external gdi32dll name 'PlayEnhMetaFile';

function PlayEnhMetaFileRecord conv arg_stdcall (DC: HDC; var p2: THandleTable; const p3: TEnhMetaRecord; p4: DWORD): BOOL;
 external gdi32dll name 'PlayEnhMetaFileRecord';

function PlayMetaFile conv arg_stdcall (DC: HDC; MF: HMETAFILE): BOOL;
 external gdi32dll name 'PlayMetaFile';

function PlayMetaFileRecord conv arg_stdcall (DC: HDC; const p2: THandleTable; const p3: TMetaRecord; p4: DWORD): BOOL;
 external gdi32dll name 'PlayMetaFileRecord';

function PlgBlt conv arg_stdcall (DC: HDC; const PointsArray; p3: HDC; p4, p5, p6, p7: DWORD; p8: HBITMAP; p9, p10: DWORD): BOOL;
 external gdi32dll name 'PlgBlt';

function PolyBezier conv arg_stdcall (DC: HDC; const Points; Count: DWORD): BOOL;
 external gdi32dll name 'PolyBezier';

function PolyBezierTo conv arg_stdcall (DC: HDC; const Points; Count: DWORD): BOOL;
 external gdi32dll name 'PolyBezierTo';

function PolyDraw conv arg_stdcall (DC: HDC; const Points, Types; cCount: DWORD): BOOL;
 external gdi32dll name 'PolyDraw';

function PolyPolygon conv arg_stdcall (DC: HDC; var Points; var nPoints; p4: DWORD): BOOL;
 external gdi32dll name 'PolyPolygon';

function PolyPolyline conv arg_stdcall (DC: HDC; const PointStructs; const Points; p4: DWORD): BOOL;
 external gdi32dll name 'PolyPolyline';

function PolyTextOutA conv arg_stdcall (DC: HDC; const PolyTextArray; Strings: DWORD): BOOL;
 external gdi32dll name 'PolyTextOutA';

function PolyTextOutW conv arg_stdcall (DC: HDC; const PolyTextArray; Strings: DWORD): BOOL;
 external gdi32dll name 'PolyTextOutW';

function PolyTextOut conv arg_stdcall (DC: HDC; const PolyTextArray; Strings: DWORD): BOOL;
 external gdi32dll name 'PolyTextOutA';

function Polygon conv arg_stdcall (DC: HDC; var Points; Count: DWORD): BOOL;
 external gdi32dll name 'Polygon';

function Polyline conv arg_stdcall (DC: HDC; var Points; Count: DWORD): BOOL;
 external gdi32dll name 'Polyline';

function PolylineTo conv arg_stdcall (DC: HDC; const Points; Count: DWORD): BOOL;
 external gdi32dll name 'PolylineTo';

function PtInRegion conv arg_stdcall (RGN: HRGN; p2, p3: DWORD): BOOL;
 external gdi32dll name 'PtInRegion';

function PtVisible conv arg_stdcall (DC: HDC; p2, p3: DWORD): BOOL;
 external gdi32dll name 'PtVisible';

function RealizePalette conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'RealizePalette';

function RectInRegion conv arg_stdcall (RGN: HRGN; const p2: TRect): BOOL;
 external gdi32dll name 'RectInRegion';

function RectVisible conv arg_stdcall (DC: HDC; const Rect: TRect): BOOL;
 external gdi32dll name 'RectVisible';

function Rectangle conv arg_stdcall (DC: HDC; X1, Y1, X2, Y2: DWORD): BOOL;
 external gdi32dll name 'Rectangle';

function RemoveFontResourceA conv arg_stdcall (p1: PAnsiChar): BOOL;
 external gdi32dll name 'RemoveFontResourceA';

function RemoveFontResourceW conv arg_stdcall (p1: PWideChar): BOOL;
external gdi32dll name 'RemoveFontResourceW';

function RemoveFontResource conv arg_stdcall (p1: PChar): BOOL;
 external gdi32dll name 'RemoveFontResourceA';

function ResetDCA conv arg_stdcall (DC: HDC; const p2: TDeviceModeA): HDC;
 external gdi32dll name 'ResetDCA';

function ResetDCW conv arg_stdcall (DC: HDC; const p2: TDeviceModeW): HDC;
 external gdi32dll name 'ResetDCW';

function ResetDC conv arg_stdcall (DC: HDC; const p2: TDeviceMode): HDC;
 external gdi32dll name 'ResetDCA';

function ResizePalette conv arg_stdcall (p1: HPALETTE; p2: DWORD): BOOL;
 external gdi32dll name 'ResizePalette';

function RestoreDC conv arg_stdcall (DC: HDC; SavedDC: DWORD): BOOL;
 external gdi32dll name 'RestoreDC';

function RoundRect conv arg_stdcall (DC: HDC; X1, Y1, X2, Y2, X3, Y3: DWORD): BOOL;
 external gdi32dll name 'RoundRect';

function SaveDC conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'SaveDC';

function ScaleViewportExtEx conv arg_stdcall (DC: HDC; XM, XD, YM, YD: DWORD; Size: PSize): BOOL;
 external gdi32dll name 'ScaleViewportExtEx';

function ScaleWindowExtEx conv arg_stdcall (DC: HDC; XM, XD, YM, YD: DWORD; Size: PSize): BOOL;
 external gdi32dll name 'ScaleWindowExtEx';

function SelectClipPath conv arg_stdcall (DC: HDC; Mode: DWORD): BOOL;
 external gdi32dll name 'SelectClipPath';

function SelectClipRgn conv arg_stdcall (DC: HDC; p2: HRGN): DWORD;
 external gdi32dll name 'SelectClipRgn';

function SelectObject conv arg_stdcall (DC: HDC; p2: HGDIOBJ): HGDIOBJ;
 external gdi32dll name 'SelectObject';

function SelectPalette conv arg_stdcall (DC: HDC; Palette: HPALETTE; ForceBackground: Bool): HPALETTE;
 external gdi32dll name 'SelectPalette';

function SetAbortProc conv arg_stdcall (DC: HDC; lpAbortProc: TFNAbortProc): DWORD;
 external gdi32dll name 'SetAbortProc';

function SetArcDirection conv arg_stdcall (DC: HDC; Direction: DWORD): DWORD;
 external gdi32dll name 'SetArcDirection';

function SetBitmapBits conv arg_stdcall (p1: HBITMAP; p2: DWORD; bits: Pointer): Longint;
 external gdi32dll name 'SetBitmapBits';

function SetBitmapDimensionEx conv arg_stdcall (hBitmap: HBITMAP; Width, Height: DWORD; Size: PSize): BOOL;
 external gdi32dll name 'SetBitmapDimensionEx';

function SetBkColor conv arg_stdcall (DC: HDC; Color: COLORREF): COLORREF;
 external gdi32dll name 'SetBkColor';

function SetBkMode conv arg_stdcall (DC: HDC; BkMode: DWORD): DWORD;
 external gdi32dll name 'SetBkMode';

function SetBoundsRect conv arg_stdcall (DC: HDC; p2: PRect; p3: DWORD): DWORD;
 external gdi32dll name 'SetBoundsRect';

function SetBrushOrgEx conv arg_stdcall (DC: HDC; X, Y: DWORD; PrevPt: PPoint): BOOL;
 external gdi32dll name 'SetBrushOrgEx';

function SetColorAdjustment conv arg_stdcall (DC: HDC; const p2: TColorAdjustment): BOOL;
 external gdi32dll name 'SetColorAdjustment';

function SetColorSpace conv arg_stdcall (DC: HDC; ColorSpace: HCOLORSPACE): BOOL;
 external gdi32dll name 'SetColorSpace';

function SetDIBColorTable conv arg_stdcall (DC: HDC; p2, p3: DWORD; var RGBQuadSTructs): DWORD;
 external gdi32dll name 'SetDIBColorTable';

function SetDIBits conv arg_stdcall (DC: HDC; Bitmap: HBITMAP; StartScan, NumScans: DWORD;
 Bits: Pointer; var BitsInfo: TBitmapInfo; Usage: DWORD): DWORD;
 external gdi32dll name 'SetDIBits';

function SetDIBitsToDevice conv arg_stdcall (DC: HDC; DestX, DestY: DWORD; Width, Height: DWORD;
 SrcX, SrcY: DWORD; nStartScan, NumScans: DWORD; Bits: Pointer;
 var BitsInfo: TBitmapInfo; Usage: DWORD): DWORD;
 external gdi32dll name 'SetDIBitsToDevice';

function SetDeviceGammaRamp conv arg_stdcall (DC: HDC; var Ramp): BOOL;
 external gdi32dll name 'SetDeviceGammaRamp';

function SetEnhMetaFileBits conv arg_stdcall (p1: DWORD; p2: PChar): HENHMETAFILE;
 external gdi32dll name 'SetEnhMetaFileBits';

function SetGraphicsMode conv arg_stdcall (hdc: HDC; iMode: DWORD): DWORD;
 external gdi32dll name 'SetGraphicsMode';

function SetICMMode conv arg_stdcall (DC: HDC; Mode: DWORD): DWORD;
 external gdi32dll name 'SetICMMode';

function SetICMProfileA conv arg_stdcall (DC: HDC; Name: PAnsiChar): BOOL;
external gdi32dll name 'SetICMProfileA';

function SetICMProfileW conv arg_stdcall (DC: HDC; Name: PWideChar): BOOL;
 external gdi32dll name 'SetICMProfileW';

function SetICMProfile conv arg_stdcall (DC: HDC; Name: PChar): BOOL;
 external gdi32dll name 'SetICMProfileA';

function SetMapMode conv arg_stdcall (DC: HDC; p2: DWORD): DWORD;
 external gdi32dll name 'SetMapMode';

function SetMapperFlags conv arg_stdcall (DC: HDC; Flag: DWORD): DWORD;
 external gdi32dll name 'SetMapperFlags';

function SetMetaFileBitsEx conv arg_stdcall (p1: DWORD; const p2: PChar): HMETAFILE;
 external gdi32dll name 'SetMetaFileBitsEx';

function SetMetaRgn conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'SetMetaRgn';

function SetMiterLimit conv arg_stdcall (DC: HDC; NewLimit: Single; OldLimit: PSingle): BOOL;
 external gdi32dll name 'SetMiterLimit';

function SetPaletteEntries conv arg_stdcall (Palette: HPALETTE; StartIndex, NumEntries: DWORD; var PaletteEntries): DWORD;
 external gdi32dll name 'SetPaletteEntries';

function SetPixel conv arg_stdcall (DC: HDC; X, Y: DWORD; Color: COLORREF): COLORREF;
 external gdi32dll name 'SetPixel';

function SetPixelFormat conv arg_stdcall (DC: HDC; p2: DWORD; p3: PPixelFormatDescriptor): BOOL;
 external gdi32dll name 'SetPixelFormat';

function SetPixelV conv arg_stdcall (DC: HDC; X, Y: DWORD; Color: COLORREF): BOOL;
 external gdi32dll name 'SetPixelV';

function SetPolyFillMode conv arg_stdcall (DC: HDC; PolyFillMode: DWORD): DWORD;
 external gdi32dll name 'SetPolyFillMode';

function SetROP2 conv arg_stdcall (DC: HDC; p2: DWORD): DWORD;
 external gdi32dll name 'SetROP2';

function SetRectRgn conv arg_stdcall (Rgn: HRgn; X1, Y1, X2, Y2: DWORD): BOOL;
 external gdi32dll name 'SetRectRgn';

function SetStretchBltMode conv arg_stdcall (DC: HDC; p2: DWORD): DWORD;
 external gdi32dll name 'SetStretchBltMode';

function SetSystemPaletteUse conv arg_stdcall (DC: HDC; p2: DWORD): DWORD;
 external gdi32dll name 'SetSystemPaletteUse';

function SetTextAlign conv arg_stdcall (DC: HDC; Flags: DWORD): DWORD;
 external gdi32dll name 'SetTextAlign';

function SetTextColor conv arg_stdcall (DC: HDC; Color: COLORREF): COLORREF;
 external gdi32dll name 'SetTextColor';

function SetTextCharacterExtra conv arg_stdcall (DC: HDC; CharExtra: DWORD): DWORD;
 external gdi32dll name 'SetTextCharacterExtra';

function SetTextJustification conv arg_stdcall (DC: HDC; BreakExtra, BreakCount: DWORD): DWORD;
 external gdi32dll name 'SetTextJustification';

function SetViewportExtEx conv arg_stdcall (DC: HDC; XExt, YExt: DWORD; Size: PSize): BOOL;
 external gdi32dll name 'SetViewportExtEx';

function SetViewportOrgEx conv arg_stdcall (DC: HDC; X, Y: DWORD; Point: PPoint): BOOL;
 external gdi32dll name 'SetViewportOrgEx';

function SetWinMetaFileBits conv arg_stdcall (p1: DWORD; p2: PChar; p3: HDC; const p4: TMetaFilePict): HENHMETAFILE;
 external gdi32dll name 'SetWinMetaFileBits';

function SetWindowExtEx conv arg_stdcall (DC: HDC; XExt, YExt: DWORD; Size: PSize): BOOL;
 external gdi32dll name 'SetWindowExtEx';

function SetWindowOrgEx conv arg_stdcall (DC: HDC; X, Y: DWORD; Point: PPoint): BOOL;
 external gdi32dll name 'SetWindowOrgEx';

function SetWorldTransform conv arg_stdcall (DC: HDC; const p2: TXForm): BOOL;
 external gdi32dll name 'SetWorldTransform';

function StartDocA conv arg_stdcall (DC: HDC; const p2: TDocInfoA): DWORD;
 external gdi32dll name 'StartDocA';

function StartDocW conv arg_stdcall (DC: HDC; const p2: TDocInfoW): DWORD;
 external gdi32dll name 'StartDocW';

function StartDoc conv arg_stdcall (DC: HDC; const p2: TDocInfo): DWORD;
 external gdi32dll name 'StartDocA';

function StartPage conv arg_stdcall (DC: HDC): DWORD;
 external gdi32dll name 'StartPage';

function StretchBlt conv arg_stdcall (DestDC: HDC; X, Y, Width, Height: DWORD; SrcDC: HDC;
 XSrc, YSrc, SrcWidth, SrcHeight: DWORD; Rop: DWORD): BOOL;
 external gdi32dll name 'StretchBlt';

function StretchDIBits conv arg_stdcall (DC: HDC; DestX, DestY, DestWidth, DestHegiht, SrcX,
 SrcY, SrcWidth, SrcHeight: DWORD; Bits: Pointer; var BitsInfo: TBitmapInfo;
 Usage: DWORD; Rop: DWORD): DWORD;
 external gdi32dll name 'StretchDIBits';

function StrokeAndFillPath conv arg_stdcall (DC: HDC): BOOL;
 external gdi32dll name 'StrokeAndFillPath';

function StrokePath conv arg_stdcall (DC: HDC): BOOL;
 external gdi32dll name 'StrokePath';

function SwapBuffers conv arg_stdcall (DC: HDC): BOOL;
 external gdi32dll name 'SwapBuffers';

function TextOutA conv arg_stdcall (DC: HDC; X, Y: DWORD; Str: PAnsiChar; Count: DWORD): BOOL;
 external gdi32dll name 'TextOutA';

function TextOutW conv arg_stdcall (DC: HDC; X, Y: DWORD; Str: PWideChar; Count: DWORD): BOOL;
 external gdi32dll name 'TextOutW';

function TextOut conv arg_stdcall (DC: HDC; X, Y: DWORD; Str: PChar; Count: DWORD): BOOL;
 external gdi32dll name 'TextOutA';

function UnrealizeObject conv arg_stdcall (hGDIObj: HGDIOBJ): BOOL;
 external gdi32dll name 'UnrealizeObject';

function UpdateColors conv arg_stdcall (DC: HDC): BOOL;
 external gdi32dll name 'UpdateColors';

function WidenPath conv arg_stdcall (DC: HDC): BOOL;
 external gdi32dll name 'WidenPath';

/////////////////////////// MPR.DLL IMPORT SECTION  ///////////////////////////

function MultinetGetConnectionPerformanceA conv arg_stdcall (lpNetResource: PNetResourceA;
 lpNetConnectInfoStruc: PNetConnectInfoStruct): DWORD;
 external mprdll name 'MultinetGetConnectionPerformanceA';

function MultinetGetConnectionPerformanceW conv arg_stdcall (lpNetResource: PNetResourceW;
 lpNetConnectInfoStruc: PNetConnectInfoStruct): DWORD;
 external mprdll name 'MultinetGetConnectionPerformanceW';

function MultinetGetConnectionPerformance conv arg_stdcall (lpNetResource: PNetResource;
 lpNetConnectInfoStruc: PNetConnectInfoStruct): DWORD;
 external mprdll name 'MultinetGetConnectionPerformanceA';

function WNetAddConnection2A conv arg_stdcall (var lpNetResource: TNetResourceA;
 lpPassword, lpUserName: PAnsiChar; dwFlags: DWORD): DWORD;
 external mprdll name 'WNetAddConnection2A';

function WNetAddConnection2W conv arg_stdcall (var lpNetResource: TNetResourceW;
 lpPassword, lpUserName: PWideChar; dwFlags: DWORD): DWORD;
 external mprdll name 'WNetAddConnection2W';

function WNetAddConnection2 conv arg_stdcall (var lpNetResource: TNetResource;
 lpPassword, lpUserName: PChar; dwFlags: DWORD): DWORD;
 external mprdll name 'WNetAddConnection2A';

function WNetAddConnection3A conv arg_stdcall (hwndOwner: HWND; var lpNetResource: TNetResourceA;
 lpPassword, lpUserName: PAnsiChar; dwFlags: DWORD): DWORD;
 external mprdll name 'WNetAddConnection3A';

function WNetAddConnection3W conv arg_stdcall (hwndOwner: HWND; var lpNetResource: TNetResourceW;
 lpPassword, lpUserName: PWideChar; dwFlags: DWORD): DWORD;
 external mprdll name 'WNetAddConnection3W';

function WNetAddConnection3 conv arg_stdcall (hwndOwner: HWND; var lpNetResource: TNetResource;
 lpPassword, lpUserName: PChar; dwFlags: DWORD): DWORD;
 external mprdll name 'WNetAddConnection3A';

function WNetAddConnectionA conv arg_stdcall (lpRemoteName, lpPassword, lpLocalName: PAnsiChar): DWORD;
 external mprdll name 'WNetAddConnectionA';

function WNetAddConnectionW conv arg_stdcall (lpRemoteName, lpPassword, lpLocalName: PWideChar): DWORD;
 external mprdll name 'WNetAddConnectionW';

function WNetAddConnection conv arg_stdcall (lpRemoteName, lpPassword, lpLocalName: PChar): DWORD;
 external mprdll name 'WNetAddConnectionA';

function WNetCancelConnection2A conv arg_stdcall (lpName: PAnsiChar; dwFlags: DWORD; fForce: BOOL): DWORD;
 external mprdll name 'WNetCancelConnection2A';

function WNetCancelConnection2W conv arg_stdcall (lpName: PWideChar; dwFlags: DWORD; fForce: BOOL): DWORD;
 external mprdll name 'WNetCancelConnection2W';

function WNetCancelConnection2 conv arg_stdcall (lpName: PChar; dwFlags: DWORD; fForce: BOOL): DWORD;
 external mprdll name 'WNetCancelConnection2A';

function WNetCancelConnectionA conv arg_stdcall (lpName: PAnsiChar; fForce: BOOL): DWORD;
 external mprdll name 'WNetCancelConnectionA';

function WNetCancelConnectionW conv arg_stdcall (lpName: PWideChar; fForce: BOOL): DWORD;
 external mprdll name 'WNetCancelConnectionW';

function WNetCancelConnection conv arg_stdcall (lpName: PChar; fForce: BOOL): DWORD;
 external mprdll name 'WNetCancelConnectionA';

function WNetCloseEnum conv arg_stdcall (hEnum: THandle): DWORD;
 external mprdll name 'WNetCloseEnum';

function WNetConnectionDialog1A conv arg_stdcall (var lpConnDlgStruct: TConnectDlgStruct): DWORD;
 external mprdll name 'WNetConnectionDialog1A';

function WNetConnectionDialog1W conv arg_stdcall (var lpConnDlgStruct: TConnectDlgStruct): DWORD;
 external mprdll name 'WNetConnectionDialog1W';

function WNetConnectionDialog1 conv arg_stdcall (var lpConnDlgStruct: TConnectDlgStruct): DWORD;
 external mprdll name 'WNetConnectionDialog1A';

function WNetConnectionDialog conv arg_stdcall (hwnd: HWND; dwType: DWORD): DWORD;
 external mprdll name 'WNetConnectionDialog';

function WNetDisconnectDialog1A conv arg_stdcall (var lpConnDlgStruct: TDiscDlgStructA): DWORD;
 external mprdll name 'WNetDisconnectDialog1A';

function WNetDisconnectDialog1W conv arg_stdcall (var lpConnDlgStruct: TDiscDlgStructW): DWORD;
 external mprdll name 'WNetDisconnectDialog1W';

function WNetDisconnectDialog1 conv arg_stdcall (var lpConnDlgStruct: TDiscDlgStruct): DWORD;
 external mprdll name 'WNetDisconnectDialog1A';

function WNetDisconnectDialog conv arg_stdcall (hwnd: HWND; dwType: DWORD): DWORD;
 external mprdll name 'WNetDisconnectDialog';

function WNetEnumResourceA conv arg_stdcall (hEnum: THandle; var lpcCount: DWORD; lpBuffer: Pointer; var lpBufferSize: DWORD): DWORD;
 external mprdll name 'WNetEnumResourceA';

function WNetEnumResourceW conv arg_stdcall (hEnum: THandle; var lpcCount: DWORD; lpBuffer: Pointer; var lpBufferSize: DWORD): DWORD;
 external mprdll name 'WNetEnumResourceW';

function WNetEnumResource conv arg_stdcall (hEnum: THandle; var lpcCount: DWORD; lpBuffer: Pointer; var lpBufferSize: DWORD): DWORD;
 external mprdll name 'WNetEnumResourceA';

function WNetGetConnectionA conv arg_stdcall (lpLocalName: PAnsiChar; lpRemoteName: PAnsiChar; var lpnLength: DWORD): DWORD;
 external mprdll name 'WNetGetConnectionA';

function WNetGetConnectionW conv arg_stdcall (lpLocalName: PWideChar; lpRemoteName: PWideChar; var lpnLength: DWORD): DWORD;
 external mprdll name 'WNetGetConnectionW';

function WNetGetConnection conv arg_stdcall (lpLocalName: PChar; lpRemoteName: PChar; var lpnLength: DWORD): DWORD;
 external mprdll name 'WNetGetConnectionA';

function WNetGetLastErrorA conv arg_stdcall (var lpError: DWORD; lpErrorBuf: PAnsiChar;
 nErrorBufSize: DWORD; lpNameBuf: PAnsiChar; nNameBufSize: DWORD): DWORD;
 external mprdll name 'WNetGetLastErrorA';

function WNetGetLastErrorW conv arg_stdcall (var lpError: DWORD; lpErrorBuf: PWideChar;
 nErrorBufSize: DWORD; lpNameBuf: PWideChar; nNameBufSize: DWORD): DWORD;
 external mprdll name 'WNetGetLastErrorW';

function WNetGetLastError conv arg_stdcall (var lpError: DWORD; lpErrorBuf: PChar;
 nErrorBufSize: DWORD; lpNameBuf: PChar; nNameBufSize: DWORD): DWORD;
 external mprdll name 'WNetGetLastErrorA';

function WNetGetNetworkInformationA conv arg_stdcall (lpProvider: PAnsiChar; var lpNetInfoStruct: TNetInfoStruct): DWORD;
 external mprdll name 'WNetGetNetworkInformationA';

function WNetGetNetworkInformationW conv arg_stdcall (lpProvider: PWideChar; var lpNetInfoStruct: TNetInfoStruct): DWORD;
 external mprdll name 'WNetGetNetworkInformationW';

function WNetGetNetworkInformation conv arg_stdcall (lpProvider: PChar; var lpNetInfoStruct: TNetInfoStruct): DWORD;
 external mprdll name 'WNetGetNetworkInformationA';

function WNetGetProviderNameA conv arg_stdcall (dwNetType: DWORD; lpProviderName: PAnsiChar;
 var lpBufferSize: DWORD): DWORD;
 external mprdll name 'WNetGetProviderNameA';

function WNetGetProviderNameW conv arg_stdcall (dwNetType: DWORD; lpProviderName: PWideChar;
 var lpBufferSize: DWORD): DWORD;
 external mprdll name 'WNetGetProviderNameW';

function WNetGetProviderName conv arg_stdcall (dwNetType: DWORD; lpProviderName: PChar;
 var lpBufferSize: DWORD): DWORD;
 external mprdll name 'WNetGetProviderNameA';

function WNetGetResourceParentA conv arg_stdcall (lpNetResource: PNetResourceA; lpBuffer: Pointer; var cbBuffer: DWORD): DWORD;
 external mprdll name 'WNetGetResourceParentA';

function WNetGetResourceParentW conv arg_stdcall (lpNetResource: PNetResourceW; lpBuffer: Pointer; var cbBuffer: DWORD): DWORD;
 external mprdll name 'WNetGetResourceParentW';

function WNetGetResourceParent conv arg_stdcall (lpNetResource: PNetResource; lpBuffer: Pointer; var cbBuffer: DWORD): DWORD;
 external mprdll name 'WNetGetResourceParentA';

function WNetGetUniversalNameA conv arg_stdcall (lpLocalPath: PAnsiChar; dwInfoLevel: DWORD;
 lpBuffer: Pointer; var lpBufferSize: DWORD): DWORD;
 external mprdll name 'WNetGetUniversalNameA';

function WNetGetUniversalNameW conv arg_stdcall (lpLocalPath: PWideChar; dwInfoLevel: DWORD;
 lpBuffer: Pointer; var lpBufferSize: DWORD): DWORD;
 external mprdll name 'WNetGetUniversalNameW';

function WNetGetUniversalName conv arg_stdcall (lpLocalPath: PChar; dwInfoLevel: DWORD;
 lpBuffer: Pointer; var lpBufferSize: DWORD): DWORD;
 external mprdll name 'WNetGetUniversalNameA';

function WNetGetUserA conv arg_stdcall (lpName: PAnsiChar; lpUserName: PAnsiChar; var lpnLength: DWORD): DWORD;
 external mprdll name 'WNetGetUserA';

function WNetGetUserW conv arg_stdcall (lpName: PWideChar; lpUserName: PWideChar; var lpnLength: DWORD): DWORD;
 external mprdll name 'WNetGetUserW';

function WNetGetUser conv arg_stdcall (lpName: PChar; lpUserName: PChar; var lpnLength: DWORD): DWORD;
 external mprdll name 'WNetGetUserA';

function WNetOpenEnumA conv arg_stdcall (dwScope, dwType, dwUsage: DWORD; lpNetResource: PNetResourceA; var lphEnum: THandle): DWORD;
 external mprdll name 'WNetOpenEnumA';

function WNetOpenEnumW conv arg_stdcall (dwScope, dwType, dwUsage: DWORD; lpNetResource: PNetResourceW; var lphEnum: THandle): DWORD;
 external mprdll name 'WNetOpenEnumW';

function WNetOpenEnum conv arg_stdcall (dwScope, dwType, dwUsage: DWORD; lpNetResource: PNetResource; var lphEnum: THandle): DWORD;
 external mprdll name 'WNetOpenEnumA';

function WNetSetConnectionA conv arg_stdcall (lpName: PAnsiChar; dwProperties: DWORD; pvValues: Pointer): DWORD;
 external mprdll name 'WNetSetConnectionA';

function WNetSetConnectionW conv arg_stdcall (lpName: PWideChar; dwProperties: DWORD; pvValues: Pointer): DWORD;
 external mprdll name 'WNetSetConnectionW';

function WNetSetConnection conv arg_stdcall (lpName: PChar; dwProperties: DWORD; pvValues: Pointer): DWORD;
 external mprdll name 'WNetSetConnectionA';

function WNetUseConnectionA conv arg_stdcall (hwndOwner: HWND; var lpNetResource: TNetResourceA; lpUserID: PAnsiChar;
 lpPassword: PAnsiChar; dwFlags: DWORD; lpAccessName: PAnsiChar; var lpBufferSize: DWORD; var lpResult: DWORD): DWORD;
 external mprdll name 'WNetUseConnectionA';

function WNetUseConnectionW conv arg_stdcall (hwndOwner: HWND; var lpNetResource: TNetResourceW; lpUserID: PWideChar;
 lpPassword: PWideChar; dwFlags: DWORD; lpAccessName: PWideChar; var lpBufferSize: DWORD; var lpResult: DWORD): DWORD;
 external mprdll name 'WNetUseConnectionW';

function WNetUseConnection conv arg_stdcall (hwndOwner: HWND; var lpNetResource: TNetResource; lpUserID: PChar;
 lpPassword: PChar; dwFlags: DWORD; lpAccessName: PChar; var lpBufferSize: DWORD; var lpResult: DWORD): DWORD;
 external mprdll name 'WNetUseConnectionA';

/////////////////////// VERSION.DLL IMPORT SECTION  ///////////////////////////

function GetFileVersionInfoA conv arg_stdcall (lptstrFilename: PAnsiChar; dwHandle, dwLen: DWORD;
 lpData: Pointer): BOOL;
 external versiondll name 'GetFileVersionInfoA';

function GetFileVersionInfoW conv arg_stdcall (lptstrFilename: PWideChar; dwHandle, dwLen: DWORD;
 lpData: Pointer): BOOL;
 external versiondll name 'GetFileVersionInfoW';

function GetFileVersionInfo conv arg_stdcall (lptstrFilename: PChar; dwHandle, dwLen: DWORD;
 lpData: Pointer): BOOL;
 external versiondll name 'GetFileVersionInfoA';

function GetFileVersionInfoSizeA conv arg_stdcall (lptstrFilename: PAnsiChar; var lpdwHandle: DWORD): DWORD;
 external versiondll name 'GetFileVersionInfoSizeA';

function GetFileVersionInfoSizeW conv arg_stdcall (lptstrFilename: PWideChar; var lpdwHandle: DWORD): DWORD;
 external versiondll name 'GetFileVersionInfoSizeW';

function GetFileVersionInfoSize conv arg_stdcall (lptstrFilename: PChar; var lpdwHandle: DWORD): DWORD;
 external versiondll name 'GetFileVersionInfoSizeA';

function VerFindFileA conv arg_stdcall (uFlags: DWORD; szFileName, szWinDir, szAppDir, szCurDir: PAnsiChar;
 var lpuCurDirLen: DWORD; szDestDir: PAnsiChar; var lpuDestDirLen: DWORD): DWORD;
 external versiondll name 'VerFindFileA';

function VerFindFileW conv arg_stdcall (uFlags: DWORD; szFileName, szWinDir, szAppDir, szCurDir: PWideChar;
 var lpuCurDirLen: DWORD; szDestDir: PWideChar; var lpuDestDirLen: DWORD): DWORD;
 external versiondll name 'VerFindFileW';

function VerFindFile conv arg_stdcall (uFlags: DWORD; szFileName, szWinDir, szAppDir, szCurDir: PChar;
 var lpuCurDirLen: DWORD; szDestDir: PChar; var lpuDestDirLen: DWORD): DWORD;
 external versiondll name 'VerFindFileA';

function VerInstallFileA conv arg_stdcall (uFlags: DWORD; szSrcFileName, szDestFileName, szSrcDir,
 szDestDir, szCurDir, szTmpFile: PAnsiChar; var lpuTmpFileLen: DWORD): DWORD;
 external versiondll name 'VerInstallFileA';

function VerInstallFileW conv arg_stdcall (uFlags: DWORD; szSrcFileName, szDestFileName, szSrcDir,
 szDestDir, szCurDir, szTmpFile: PWideChar; var lpuTmpFileLen: DWORD): DWORD;
 external versiondll name 'VerInstallFileW';

function VerInstallFile conv arg_stdcall (uFlags: DWORD; szSrcFileName, szDestFileName, szSrcDir,
 szDestDir, szCurDir, szTmpFile: PChar; var lpuTmpFileLen: DWORD): DWORD;
 external versiondll name 'VerInstallFileA';

function VerQueryValueA conv arg_stdcall (pBlock: Pointer; lpSubBlock: PAnsiChar; var lplpBuffer: Pointer; var puLen: DWORD): BOOL;
 external versiondll name 'VerQueryValueA';

function VerQueryValueW conv arg_stdcall (pBlock: Pointer; lpSubBlock: PWideChar; var lplpBuffer: Pointer; var puLen: DWORD): BOOL;
 external versiondll name 'VerQueryValueW';

function VerQueryValue conv arg_stdcall (pBlock: Pointer; lpSubBlock: PChar; var lplpBuffer: Pointer; var puLen: DWORD): BOOL;
 external versiondll name 'VerQueryValueA';

//////////////////////////////// COMCTRL32.DLL ////////////////////////////////

function GetPrivateProfileStructA conv arg_stdcall (lpszSection, lpszKey: PAnsiChar;
 lpStruct: Pointer; uSizeStruct: DWORD; szFile: PAnsiChar): BOOL;
 external comctl32dll name 'GetPrivateProfileStructA';

function GetPrivateProfileStructW conv arg_stdcall (lpszSection, lpszKey: PWideChar;
 lpStruct: Pointer; uSizeStruct: DWORD; szFile: PWideChar): BOOL;
 external comctl32dll name 'GetPrivateProfileStructW';

function GetPrivateProfileStruct conv arg_stdcall (lpszSection, lpszKey: PChar;
 lpStruct: Pointer; uSizeStruct: DWORD; szFile: PChar): BOOL;
 external comctl32dll name 'GetPrivateProfileStructA';

function WritePrivateProfileStructA conv arg_stdcall (lpszSection, lpszKey: PAnsiChar;
 lpStruct: Pointer; uSizeStruct: DWORD; szFile: PAnsiChar): BOOL;
 external comctl32dll name 'WritePrivateProfileStructA';

function WritePrivateProfileStructW conv arg_stdcall (lpszSection, lpszKey: PWideChar;
 lpStruct: Pointer; uSizeStruct: DWORD; szFile: PWideChar): BOOL;
 external comctl32dll name 'WritePrivateProfileStructW';

function WritePrivateProfileStruct conv arg_stdcall (lpszSection, lpszKey: PChar;
 lpStruct: Pointer; uSizeStruct: DWORD; szFile: PChar): BOOL;
 external comctl32dll name 'WritePrivateProfileStructA';

/////////////////////////////// WINTRUST.DLL //////////////////////////////////

function WinLoadTrustProvider conv arg_stdcall (ActionID: PGUID): BOOL;
 external wintrustdll name 'WinLoadTrustProvider';

function WinSubmitCertificate conv arg_stdcall (var lpCertificate: TWinCertificate): BOOL;
 external wintrustdll name 'WinSubmitCertificate';

function WinVerifyTrust conv arg_stdcall (hwnd: HWND; const ActionID: TGUID; ActionData: Pointer): Longint;
 external wintrustdll name 'WinVerifyTrust';

//////////////////////// OPENGL32.DLL IMPORT SECTION  /////////////////////////

function wglCopyContext conv arg_stdcall (p1: HGLRC; p2: HGLRC; p3: DWord): BOOL;
 external opengl32dll name 'wglCopyContext';

function wglCreateContext conv arg_stdcall (DC: HDC): HGLRC;
 external opengl32dll name 'wglCreateContext';

function wglCreateLayerContext conv arg_stdcall (p1: HDC; p2: DWORD): HGLRC;
 external opengl32dll name 'wglCreateLayerContext';

function wglDeleteContext conv arg_stdcall (p1: HGLRC): BOOL;
 external opengl32dll name 'wglDeleteContext';

function wglDescribeLayerPlane conv arg_stdcall (p1: HDC; p2, p3: DWORD; p4: DWord; var p5: TLayerPlaneDescriptor): BOOL;
 external opengl32dll name 'wglDescribeLayerPlane';

function wglGetCurrentContext: HGLRC;
 external opengl32dll name 'wglGetCurrentContext';

function wglGetCurrentDC: HDC;
 external opengl32dll name 'wglGetCurrentDC';

function wglGetLayerPaletteEntries conv arg_stdcall (p1: HDC; p2, p3, p4: DWORD; var pcr): DWORD;
 external opengl32dll name 'wglGetLayerPaletteEntries';

function wglMakeCurrent conv arg_stdcall (DC: HDC; p2: HGLRC): BOOL;
 external opengl32dll name 'wglMakeCurrent';

function wglRealizeLayerPalette conv arg_stdcall (p1: HDC; p2: DWORD; p3: BOOL): BOOL;
 external opengl32dll name 'wglRealizeLayerPalette';

function wglSetLayerPaletteEntries conv arg_stdcall (p1: HDC; p2, p3, p4: DWORD; var pcr): DWORD;
 external opengl32dll name 'wglSetLayerPaletteEntries';

function wglShareLists conv arg_stdcall (p1, p2: HGLRC): BOOL;
 external opengl32dll name 'wglShareLists';

function wglSwapLayerBuffers conv arg_stdcall (p1: HDC; p2: DWord): BOOL;
 external opengl32dll name 'wglSwapLayerBuffers';

function wglUseFontBitmapsA conv arg_stdcall (DC: HDC; p2, p3, p4: DWORD): BOOL;
 external opengl32dll name 'wglUseFontBitmapsA';

function wglUseFontBitmapsW conv arg_stdcall (DC: HDC; p2, p3, p4: DWORD): BOOL;
 external opengl32dll name 'wglUseFontBitmapsW';

function wglUseFontBitmaps conv arg_stdcall (DC: HDC; p2, p3, p4: DWORD): BOOL;
 external opengl32dll name 'wglUseFontBitmapsA';

function wglUseFontOutlinesA conv arg_stdcall (p1: HDC; p2, p3, p4: DWORD; p5, p6: Single; p7: DWORD; p8: PGlyphMetricsFloat): BOOL;
 external opengl32dll name 'wglUseFontOutlinesA';

function wglUseFontOutlinesW conv arg_stdcall (p1: HDC; p2, p3, p4: DWORD; p5, p6: Single; p7: DWORD; p8: PGlyphMetricsFloat): BOOL;
 external opengl32dll name 'wglUseFontOutlinesW';

function wglUseFontOutlines conv arg_stdcall (p1: HDC; p2, p3, p4: DWORD; p5, p6: Single; p7: DWORD; p8: PGlyphMetricsFloat): BOOL;
 external opengl32dll name 'wglUseFontOutlinesA';

function VerSetConditionMask conv arg_stdcall (ConditionMask: LONGLONG; TypeMask: DWORD;
  Condition: BYTE): LONGLONG; external kernel32dll name 'VerSetConditionMask';

//////////////////////////// ADDITIONAL SECTION ///////////////////////////////

function GET_WM_COMMAND_ID(wp, lp: DWORD): Word;

function GET_WM_COMMAND_HWND(wp, lp: DWORD): THandle;

function GET_WM_COMMAND_CMD(wp, lp: DWORD): Word;

function GET_WPARAM(wp, lp: DWORD): WParam;

function GET_LPARAM(wp, lp: DWORD): LParam;

function GET_X_LPARAM(lp: LParam): LParam;

function GET_Y_LPARAM(lp: LParam): LParam;

function GET_WM_ACTIVATE_STATE(wp, lp: DWORD): DWORD;

function GET_WM_ACTIVATE_FMINIMIZED(wp, lp: DWORD): Boolean;

function GET_WM_ACTIVATE_HWND(wp, lp: DWORD): HWND;

function GET_WM_CHARTOITEM_CHAR(wp, lp: DWORD): CHAR;

function GET_WM_CHARTOITEM_POS(wp, lp: DWORD): DWORD;

function GET_WM_CHARTOITEM_HWND(wp, lp: DWORD): HWND;

function GET_WM_CTLCOLOR_HDC(wp, lp, msg: DWORD): HDC;

function GET_WM_CTLCOLOR_HWND(wp, lp, msg: DWORD): HWND;

function GET_WM_CTLCOLOR_TYPE(wp, lp, msg: DWORD): WORD;

function GET_WM_CTLCOLOR_MSG(msg_type: DWORD): WORD;

function GET_WM_MENUSELECT_CMD(wp, lp: DWORD): DWORD;

function GET_WM_MENUSELECT_FLAGS(wp, lp: DWORD): DWORD;

function GET_WM_MENUSELECT_HMENU(wp, lp: DWORD): HMENU;

function GET_WM_MDIACTIVATE_FACTIVATE(hwnd, wp, lp: DWORD): Boolean;

function GET_WM_MDIACTIVATE_HWNDDEACT(wp, lp: DWORD): HWND;

function GET_WM_MDIACTIVATE_HWNDACTIVATE(wp, lp: DWORD): HWND;

function GET_WM_MENUCHAR_CHAR(wp, lp: DWORD): CHAR;

function GET_WM_MENUCHAR_HMENU(wp, lp: DWORD): HMENU;

function GET_WM_MENUCHAR_FMENU(wp, lp: DWORD): Boolean;

function GET_WM_PARENTNOTIFY_MSG(wp, lp: DWORD): DWORD;

function GET_WM_PARENTNOTIFY_ID(wp, lp: DWORD): DWORD;

function GET_WM_PARENTNOTIFY_HWNDCHILD(wp, lp: DWORD): HWND;

function GET_WM_PARENTNOTIFY_X(wp, lp: DWORD): DWORD;

function GET_WM_PARENTNOTIFY_Y(wp, lp: DWORD): DWORD;

function GET_WM_VKEYTOITEM_CODE(wp, lp: DWORD): DWORD;

function GET_WM_VKEYTOITEM_ITEM(wp, lp: DWORD): DWORD;

function GET_WM_VKEYTOITEM_HWND(wp, lp: DWORD): HWND;

function GET_EM_SETSEL_START(wp, lp: DWORD): DWORD;

function GET_EM_SETSEL_END(wp, lp: DWORD): DWORD;

function GET_WM_CHANGECBCHAIN_HWNDNEXT(wp, lp: DWORD): HWND;

function GET_WM_HSCROLL_CODE(wp, lp: DWORD): DWORD;

function GET_WM_HSCROLL_POS(wp, lp: DWORD): DWORD;

function GET_WM_HSCROLL_HWND(wp, lp: DWORD): HWND;

function GET_WM_VSCROLL_CODE(wp, lp: DWORD): DWORD;

function GET_WM_VSCROLL_POS(wp, lp: DWORD): DWORD;

function GET_WM_VSCROLL_HWND(wp, lp: DWORD): HWND;

function CreateDialog(hInstance: HINST; lpTemplateName: PChar;
  hWndParent: HWND; lpDialogFunc: TFNDlgProc): HWND;

function CreateDialogA(hInstance: HINST; lpTemplateName: PAnsiChar;
  hWndParent: HWND; lpDialogFunc: TFNDlgProc): HWND;

function CreateDialogW(hInstance: HINST; lpTemplateName: PWideChar;
 hWndParent: HWND; lpDialogFunc: TFNDlgProc): HWND;

function FileWrite(Handle: THandle; const Buffer; Count: Longint): Longint;

function CreateWindow(lpClassName: PChar; lpWindowName: PChar;
 dwStyle: DWORD; X, Y, nWidth, nHeight: DWORD; hWndParent: HWND;
 hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND;

function DialogBoxA(hInstance: HINST; lpTemplateName: PAnsiChar; hWndParent: HWND; lpDialogFunc: TFNDlgProc): DWORD;

function DialogBoxW(hInstance: HINST; lpTemplateName: PWideChar; hWndParent: HWND; lpDialogFunc: TFNDlgProc): DWORD;

function DialogBox(hInstance: HINST; lpTemplateName: PAnsiChar; hWndParent: HWND; lpDialogFunc: TFNDlgProc): DWORD;

function DialogBoxIndirectA(hInstance: HINST; const lpDialogTemplate: TDlgTemplate; hWndParent: HWND; lpDialogFunc: TFNDlgProc): Longint;

function DialogBoxIndirectW(hInstance: HINST; const lpDialogTemplate: TDlgTemplate; hWndParent: HWND; lpDialogFunc: TFNDlgProc): Longint;

function DialogBoxIndirect(hInstance: HINST; const lpDialogTemplate: TDlgTemplate; hWndParent: HWND; lpDialogFunc: TFNDlgProc): Longint;

procedure ZeroMemory(Destination: Pointer; Length: DWORD);

procedure CopyMemory(Destination, Source: Pointer; Length: DWORD);

procedure FillMemory(Destination: Pointer; Length: DWORD; Fill: Byte);

procedure MoveMemory(Destination, Source: Pointer; Length: DWORD);

function GetBvalue(i: Longint): Byte;

function GetGvalue(i: Longint): Byte;

function GetRvalue(i: Longint): Byte;

function GetKValue(cmyk: COLORREF): Byte;

function GetYValue(cmyk: COLORREF): Byte;

function GetMValue(cmyk: COLORREF): Byte;

function GetCValue(cmyk: COLORREF): Byte;

function CMYK(c, m, y, k: Byte): COLORREF;

function RGB(r, g, b: Byte ): DWORD;

function PaletteRGB(r, g, b: Byte): COLORREF;

function PaletteIndex(i: Word): COLORREF;

function MakeWord(a, b: Byte): Word;

function MakeLResult(a, b: Word): LResult;

function MakeRop4(Fore, Back: Longint): DWORD;

function INDEXTOOVERLAYMASK(iOverlay : UINT): UINT;

function INDEXTOSTATEIMAGEMASK(i: UINT): UINT;

function SORTIDFROMLCID(alcid: lcid): Word;

function SEXT_HIWORD(l: Longint): Longint;

function ZEXT_HIWORD(l: Word): Longint;

function FreeModule(h: THandle): Boolean;

function EnumTaskWindows(hTask: THandle; lpfn: FARPROC; lParam: LPARAM): Boolean;

function GetWindowTask(hWnd: HWND): THandle;

function DefHookProc(nCode: Longint; wParam: WPARAM; lParam: LPARAM; phhk: FARPROC): LRESULT;

function ExitWindows(dwReserved: DWORD; Code: Word): Boolean;

function PostAppMessageA(idThread: DWORD; Msg: UINT; wParam: WPARAM; lParam: LPARAM): Boolean;

function PostAppMessageW(idThread: DWORD; Msg: UINT; wParam: WPARAM; lParam: LPARAM): Boolean;

function PostAppMessage(idThread: DWORD; Msg: UINT; wParam: WPARAM; lParam: LPARAM): Boolean;

function CreateDialogIndirectA(hInstance: HINST; const lpTemplate: TDlgTemplate; hWndParent: HWND; lpDialogFunc: TFNDlgProc): HWND;

function CreateDialogIndirectW(hInstance: HINST; const lpTemplate: TDlgTemplate; hWndParent: HWND; lpDialogFunc: TFNDlgProc): HWND;

function CreateDialogIndirect(hInstance: HINST; const lpTemplate: TDlgTemplate; hWndParent: HWND; lpDialogFunc: TFNDlgProc): HWND;

function SmallPointToPoint(const P: TSmallPoint): TPoint;

function PointToSmallPoint(const P: TPoint): TSmallPoint;

function Succeeded(Status: HRESULT): Boolean;

function SysErrorMessage(ErrorCode: Longint): String;

function Failed(Status: HRESULT): Boolean;

function IsError(Status: HRESULT): Boolean;

function HResultCode(hr: HRESULT): Longint;

function HResultFacility(hr: HRESULT): Longint;

function HResultSeverity(hr: HRESULT): Longint;

function MakeResult(sev, fac, code: Longint): HResult;

function HResultFromWin32(x: Longint): HRESULT;

function HResultFromNT(x: Longint): HRESULT;

function HEAP_MAKE_TAG_FLAGS(b, o: DWORD): DWORD;

procedure VER_SET_CONDITION(var Mask: LONGLONG; TypeBitmask, ConditionMask: ULONG);

function  IMAGE_SNAP_BY_ORDINAL(Ordinal: DWORD): Boolean;

function  IMAGE_SNAP_BY_ORDINAL32(Ordinal: DWORD): Boolean;

function IMAGE_ORDINAL(Ordinal: DWORD): DWORD;

function ISPTR(x: DWORD): Boolean;

function ISFCN(x: DWORD): Boolean;

function ISARY(x: DWORD): Boolean;

function ISTAG(x: DWORD): Boolean;

implementation

function GET_WM_COMMAND_ID(wp, lp: DWORD): Word;
begin
  Result := LOWORD(wp);
end;

function GET_WM_COMMAND_HWND(wp, lp: DWORD): THandle;
begin
  Result := lp;
end;

function GET_WM_COMMAND_CMD(wp, lp: DWORD): Word;
begin
  Result := HIWORD(wp);
end;

function GET_WPARAM(wp, lp: DWORD): WParam;
begin
  Result := wp;
end;

function GET_LPARAM(wp, lp: DWORD): LParam;
begin
  Result := lp;
end;

function GET_X_LPARAM(lp: LParam): LParam;
begin
  Result := LoWord(lp);
end;

function GET_Y_LPARAM(lp: LParam): LParam;
begin
  Result := HiWord(lp);
end;

function GET_WM_ACTIVATE_STATE(wp, lp: DWORD): DWORD;
begin
  Result := LoWord(wp);
end;

function GET_WM_ACTIVATE_FMINIMIZED(wp, lp: DWORD): Boolean;
begin
  Result := HiWord(wp) <> 0;
end;

function GET_WM_ACTIVATE_HWND(wp, lp: DWORD): HWND;
begin
  Result := lp;
end;

function GET_WM_CHARTOITEM_CHAR(wp, lp: DWORD): CHAR;
begin
  Result := CHAR(LoWord(wp));
end;

function GET_WM_CHARTOITEM_POS(wp, lp: DWORD): DWORD;
begin
  Result := HiWord(wp);
end;

function GET_WM_CHARTOITEM_HWND(wp, lp: DWORD): HWND;
begin
  Result := lp;
end;

function GET_WM_CTLCOLOR_HDC(wp, lp, msg: DWORD): HDC;
begin
  Result := wp;
end;

function GET_WM_CTLCOLOR_HWND(wp, lp, msg: DWORD): HWND;
begin
  Result := lp;
end;

function GET_WM_CTLCOLOR_TYPE(wp, lp, msg: DWORD): WORD;
begin
  Result := msg - WM_CTLCOLORMSGBOX;
end;

function GET_WM_CTLCOLOR_MSG(msg_type: DWORD): WORD;
begin
  Result := WM_CTLCOLORMSGBOX + msg_type;
end;

function GET_WM_MENUSELECT_CMD(wp, lp: DWORD): DWORD;
begin
  Result := wp;
end;

function GET_WM_MENUSELECT_FLAGS(wp, lp: DWORD): DWORD;
begin
  Result := HIWORD(wp);
end;

function GET_WM_MENUSELECT_HMENU(wp, lp: DWORD): HMENU;
begin
  Result := lp;
end;

(* Note: the following are for interpreting MDIclient to MDI child messages. *)

function GET_WM_MDIACTIVATE_FACTIVATE(hwnd, wp, lp: DWORD): Boolean;
begin
  Result := lp = hwnd;
end;

function GET_WM_MDIACTIVATE_HWNDDEACT(wp, lp: DWORD): HWND;
begin
  Result := wp;
end;

function GET_WM_MDIACTIVATE_HWNDACTIVATE(wp, lp: DWORD): HWND;
begin
  Result := lp;
end;

(* Note: the following is for sending to the MDI client window. *)

function GET_WM_MENUCHAR_CHAR(wp, lp: DWORD): CHAR;
begin
  Result := Char(LoWord(wp));
end;

function GET_WM_MENUCHAR_HMENU(wp, lp: DWORD): HMENU;
begin
  Result := lp;
end;

function GET_WM_MENUCHAR_FMENU(wp, lp: DWORD): Boolean;
begin
  Result := HIWORD(wp) <> 0;
end;

function GET_WM_PARENTNOTIFY_MSG(wp, lp: DWORD): DWORD;
begin
  Result := LOWORD(wp);
end;

function GET_WM_PARENTNOTIFY_ID(wp, lp: DWORD): DWORD;
begin
  Result := HIWORD(wp);
end;

function GET_WM_PARENTNOTIFY_HWNDCHILD(wp, lp: DWORD): HWND;
begin
  Result := lp;
end;

function GET_WM_PARENTNOTIFY_X(wp, lp: DWORD): DWORD;
begin
  Result := LOWORD(lp);
end;

function GET_WM_PARENTNOTIFY_Y(wp, lp: DWORD): DWORD;
begin
  Result := HIWORD(lp);
end;

function GET_WM_VKEYTOITEM_CODE(wp, lp: DWORD): DWORD;
begin
  Result := LOWORD(wp);
end;

function GET_WM_VKEYTOITEM_ITEM(wp, lp: DWORD): DWORD;
begin
  Result := HIWORD(wp);
end;

function GET_WM_VKEYTOITEM_HWND(wp, lp: DWORD): HWND;
begin
  Result := lp;
end;

function GET_EM_SETSEL_START(wp, lp: DWORD): DWORD;
begin
  Result := wp;
end;

function GET_EM_SETSEL_END(wp, lp: DWORD): DWORD;
begin
  Result := lp;
end;

function GET_WM_CHANGECBCHAIN_HWNDNEXT(wp, lp: DWORD): HWND;
begin
  Result := lp;
end;

function GET_WM_HSCROLL_CODE(wp, lp: DWORD): DWORD;
begin
  Result := LOWORD(wp);
end;

function GET_WM_HSCROLL_POS(wp, lp: DWORD): DWORD;
begin
  Result := HIWORD(wp);
end;

function GET_WM_HSCROLL_HWND(wp, lp: DWORD): HWND;
begin
  Result := lp;
end;

function GET_WM_VSCROLL_CODE(wp, lp: DWORD): DWORD;
begin
  Result := LOWORD(wp);
end;

function GET_WM_VSCROLL_POS(wp, lp: DWORD): DWORD;
begin
  Result := HIWORD(wp);
end;

function GET_WM_VSCROLL_HWND(wp, lp: DWORD): HWND;
begin
  Result := lp;
end;

function MAKELPARAM(wLow, wHigh: Word): LParam; code;
      asm
        movzx   eax, [wHigh]
        shl     eax, 16
        mov     ax, [wLow]
        ret
end;

function MAKEWPARAM(wLow, wHigh: Word): WParam; code;
      asm
        movzx   eax, [wHigh]
        shl     eax, 16
        mov     ax, [wLow]
        ret
end;

function MAKELANGID(usPrimaryLanguage, usSubLanguage: Word): Word; code;
      asm
        movzx   eax, [usSubLanguage]
        shl     eax, 10
        movzx   esi, [usPrimaryLanguage]
        or      eax, esi
        ret
end;

function MAKELCID(wLanguageID, wSortID: Word): DWord; code;
      asm
        movzx   eax, [wSortID]
        shl     eax, 16
        movzx   esi, [wLanguageID]
        or      eax, esi
        ret
end;

function PRIMARYLANGID(lgid: Word): Word; code;
      asm
        movzx   eax, [lgid]
        and     eax, $000003FF
        ret
end;

function SUBLANGID(lgid: Word): Word; code;
      asm
        movzx   eax, [lgid]
        shr     eax, 10
        ret
end;

function CreateDialog(hInstance: HINST; lpTemplateName: PChar;
  hWndParent: HWND; lpDialogFunc: TFNDlgProc): HWND;
begin
  Result := CreateDialogParamA(hInstance, lpTemplateName, hWndParent, lpDialogFunc, 0);
end;

function CreateDialogA(hInstance: HINST; lpTemplateName: PAnsiChar;
  hWndParent: HWND; lpDialogFunc: TFNDlgProc): HWND;
begin
  Result := CreateDialogParamA(hInstance, lpTemplateName, hWndParent, lpDialogFunc, 0);
end;

function CreateDialogW(hInstance: HINST; lpTemplateName: PWideChar;
 hWndParent: HWND; lpDialogFunc: TFNDlgProc): HWND;
begin
  Result := CreateDialogParamW(hInstance, lpTemplateName, hWndParent, lpDialogFunc, 0);
end;

function MAKELONG(A, B: Word): Longint;
begin
  Result := Longint(A) or (Longint(B) shl 16);
end;

function FileWrite(Handle: THandle; const Buffer; Count: Longint): Longint;
var Temp: DWord;
begin
  if not WriteFile(Handle, Buffer, Count, Temp, nil) then
   Result := -1
  else
   Result := Temp;
end;

function CreateWindow(lpClassName: PChar; lpWindowName: PChar;
 dwStyle: DWORD; X, Y, nWidth, nHeight: DWORD; hWndParent: HWND;
 hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND;
begin
 Result:=CreateWindowEx(0,lpClassName,lpWindowName,dwStyle,X,Y,
  nWidth,nHeight,hWndParent,hMenu,hInstance,lpParam);
end;

function DialogBoxA(hInstance: HINST; lpTemplateName: PAnsiChar;
  hWndParent: HWND; lpDialogFunc: TFNDlgProc): DWORD;
begin
  Result := DialogBoxParamA(hInstance, lpTemplateName, hWndParent, lpDialogFunc, 0);
end;

function DialogBoxW(hInstance: HINST; lpTemplateName: PWideChar;
  hWndParent: HWND; lpDialogFunc: TFNDlgProc): DWORD;
begin
  Result := DialogBoxParamW(hInstance, lpTemplateName, hWndParent, lpDialogFunc, 0)
end;

function DialogBox(hInstance: HINST; lpTemplateName: PAnsiChar;
  hWndParent: HWND; lpDialogFunc: TFNDlgProc): DWORD;
begin
  Result := DialogBoxParam(hInstance, lpTemplateName, hWndParent, lpDialogFunc, 0);
end;

function DialogBoxIndirectA(hInstance: HINST; const lpDialogTemplate: TDlgTemplate; hWndParent: HWND; lpDialogFunc: TFNDlgProc): Longint;
begin
  Result := DialogBoxIndirectParamA(hInstance, lpDialogTemplate, hWndParent, lpDialogFunc, 0);
end;

function DialogBoxIndirectW(hInstance: HINST; const lpDialogTemplate: TDlgTemplate; hWndParent: HWND; lpDialogFunc: TFNDlgProc): Longint;
begin
  Result := DialogBoxIndirectParamW(hInstance, lpDialogTemplate, hWndParent, lpDialogFunc, 0);
end;

function DialogBoxIndirect(hInstance: HINST; const lpDialogTemplate: TDlgTemplate; hWndParent: HWND; lpDialogFunc: TFNDlgProc): Longint;
begin
  Result := DialogBoxIndirectParam(hInstance, lpDialogTemplate, hWndParent, lpDialogFunc, 0);
end;

procedure ZeroMemory(Destination: Pointer; Length: DWORD);
begin
  FillChar(Destination^, Length, 0);
end;

procedure CopyMemory(Destination, Source: Pointer; Length: DWORD); assembler;
      asm
        push    ecx
        mov     esi, [Source]
        mov     edi, [Destination]
        mov     ecx, [Length]
        cld
        mov     eax, ecx
        shr     ecx, 2
        ALIGN   4
        rep     movsd
        mov     ecx, eax
        and     ecx, 3
        rep     movsb
@@4:
        pop     ecx
end;

procedure FillMemory(Destination: Pointer; Length: DWORD; Fill: Byte);
begin
  FillChar(Destination^, Length, Fill);
end;

procedure MoveMemory(Destination, Source: Pointer; Length: DWORD);
begin
  Move(Source^, Destination^, Length);
end;

function GetBvalue(i: Longint): Byte;
begin
  Result := i shr 16;
end;

function GetGvalue(i: Longint): Byte;
begin
  Result := i shr 8;
end;

function GetRvalue(i: Longint): Byte;
begin
  Result := Byte(i);
end;

function GetKValue(cmyk: COLORREF): Byte;
begin
  Result := Byte(cmyk);
end;

function GetYValue(cmyk: COLORREF): Byte;
begin
  Result := Byte(cmyk shr 8);
end;

function GetMValue(cmyk: COLORREF): Byte;
begin
  Result := Byte(cmyk shr 16);
end;

function GetCValue(cmyk: COLORREF): Byte;
begin
  Result := Byte(cmyk shr 24);
end;

function CMYK(c, m, y, k: Byte): COLORREF;
begin
  Result := (k or (y shl 8) or (m shl 16) or (c shl 24));
end;

function RGB(r, g, b: Byte ): DWORD;
begin
  Result := (r OR g shl 8 OR b shl 16);
end;

function PaletteRGB(r, g, b: Byte): COLORREF;
begin
  Result := RGB(r,g,b) or $02000000;
end;

function PaletteIndex(i: Word): COLORREF;
begin
  Result := i or $01000000;
end;

function MakeWord(a, b: Byte): Word;
begin
  Result := a or b shl 8;
end;

function MakeLResult(a, b: Word): LResult;
begin
  Result := MakeLong(a, b);
end;

function MakeRop4(Fore, Back: Longint): DWORD;
begin
  Result := (Back shl 8) AND $FF000000 or Fore;
end;

function INDEXTOOVERLAYMASK(iOverlay : UINT): UINT;
begin
  Result := iOverlay shl 8;
end;

function INDEXTOSTATEIMAGEMASK(i: UINT): UINT;
begin
  Result := i shl 12;
end;

function SORTIDFROMLCID(alcid: lcid): Word;
begin
  Result := alcid and $000FFFF shr 16;
end;

function SEXT_HIWORD(l: Longint): Longint;
begin
  Result := l shr 16;
end;

function ZEXT_HIWORD(l: Word): Longint;
begin
  Result := l shr 16;
end;

function FreeModule(h: THandle): Boolean;
begin
  Result := FreeLibrary(h);
end;

function EnumTaskWindows(hTask: THandle; lpfn: FARPROC; lParam: LPARAM): Boolean;
begin
  Result := EnumThreadWindows(DWORD(hTask), lpfn, lParam);
end;

function GetWindowTask(hWnd: HWND): THandle;
begin
  Result := THandle(GetWindowThreadProcessId(hWnd, nil));
end;

function DefHookProc(nCode: Longint; wParam: WPARAM; lParam: LPARAM; phhk: FARPROC): LRESULT;
begin
  Result := CallNextHookEx(HHOOK(phhk), nCode, wParam, lParam);
end;

function ExitWindows(dwReserved: DWORD; Code: Word): Boolean;
begin
  Result := ExitWindowsEx(EWX_LOGOFF, 0);
end;

function PostAppMessageA(idThread: DWORD; Msg: UINT; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  Result := PostThreadMessageA(idThread, Msg, wParam, lParam);
end;

function PostAppMessageW(idThread: DWORD; Msg: UINT; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  Result := PostThreadMessageW(idThread, Msg, wParam, lParam);
end;

function PostAppMessage(idThread: DWORD; Msg: UINT; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  Result := PostThreadMessage(idThread, Msg, wParam, lParam)
end;

function CreateDialogIndirectA(hInstance: HINST; const lpTemplate: TDlgTemplate; hWndParent: HWND; lpDialogFunc: TFNDlgProc): HWND;
begin
  Result := CreateDialogIndirectParamA(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0);
end;

function CreateDialogIndirectW(hInstance: HINST; const lpTemplate: TDlgTemplate; hWndParent: HWND; lpDialogFunc: TFNDlgProc): HWND;
begin
  Result := CreateDialogIndirectParamW(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0);
end;

function CreateDialogIndirect(hInstance: HINST; const lpTemplate: TDlgTemplate; hWndParent: HWND; lpDialogFunc: TFNDlgProc): HWND;
begin
  Result := CreateDialogIndirectParam(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0);
end;

function SmallPointToPoint(const P: TSmallPoint): TPoint;
begin
  with Result do
  begin
    X := P.X;
    Y := P.Y;
  end;
end;

function PointToSmallPoint(const P: TPoint): TSmallPoint;
begin
  with Result do
  begin
    X := P.X;
    Y := P.Y;
  end;
end;

function Succeeded(Status: HRESULT): Boolean;
begin
  Result := (DWORD(Status) and $80000000) = 0;
end;

function SysErrorMessage(ErrorCode: Longint): String;
var
  Len: Longint;
  Buf: array[0..MAX_PATH] of Char;
begin
  Len := FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM or
    FORMAT_MESSAGE_ARGUMENT_ARRAY, nil, ErrorCode, 0, @Buf,
    SizeOf(Buf), nil);
  while (Len > 0) and (Buf[Len - 1] in [#0..#32, '.']) do Dec(Len);
  SetString(Result, Buf, Len);
end;

function Failed(Status: HRESULT): Boolean;
begin
  Result := (Status and $80000000) <> 0;
end;

function IsError(Status: HRESULT): Boolean;
begin
  Result := (Status shr 31) = SEVERITY_ERROR;
end;

function HResultCode(hr: HRESULT): Longint;
begin
  Result := hr and $0000FFFF;
end;

function HResultFacility(hr: HRESULT): Longint;
begin
  Result := (hr shr 16) and $00001FFF;
end;

function HResultSeverity(hr: HRESULT): Longint;
begin
  Result := (hr shr 31) and $00000001;
end;

function MakeResult(sev, fac, code: Longint): HResult;
begin
  Result := (sev shl 31) or (fac shl 16) or code;
end;

function HResultFromWin32(x: Longint): HRESULT;
begin
  if x <> 0 then
    Result := ((x and $0000FFFF) or (FACILITY_WIN32 shl 16) or $80000000)
  else
    Result := x;
end;

function HResultFromNT(x: Longint): HRESULT;
begin
  Result := x or FACILITY_NT_BIT;
end;

function HEAP_MAKE_TAG_FLAGS(b, o: DWORD): DWORD;
begin
  Result := b + (o shl 18);
end;

procedure VER_SET_CONDITION(var Mask: LONGLONG; TypeBitmask, ConditionMask: ULONG);
begin
  Mask := VerSetConditionMask(Mask, TypeBitmask, ConditionMask);
end;

function IMAGE_SNAP_BY_ORDINAL(Ordinal: DWORD): Boolean;
begin
  Result := ((Ordinal and IMAGE_ORDINAL_FLAG32) <> 0);
end;

function IMAGE_SNAP_BY_ORDINAL32(Ordinal: DWORD): Boolean;
begin
  Result := ((Ordinal and IMAGE_ORDINAL_FLAG32) <> 0);
end;

function IMAGE_ORDINAL(Ordinal: DWORD): DWORD;
begin
  Result := (Ordinal and $FFFF);
end;

function ISPTR(x: DWORD): Boolean;
begin
  Result := (x and N_TMASK) = (IMAGE_SYM_DTYPE_POINTER shl N_BTSHFT);
end;

function ISFCN(x: DWORD): Boolean;
begin
  Result := (x and N_TMASK) = (IMAGE_SYM_DTYPE_FUNCTION shl N_BTSHFT);
end;

function ISARY(x: DWORD): Boolean;
begin
  Result := (x and N_TMASK) = (IMAGE_SYM_DTYPE_ARRAY shl N_BTSHFT);
end;

function ISTAG(x: DWORD): Boolean;
begin
  Result := (x = IMAGE_SYM_CLASS_STRUCT_TAG) or (x = IMAGE_SYM_CLASS_UNION_TAG) or
    (x = IMAGE_SYM_CLASS_ENUM_TAG);
end;

end.
