(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       DDEML API Interface Unit                               *)
(*       Based on ddeml.h                                       *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995-99 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit Ddeml;

/*++ BUILD Version: 0001 // Increment this if a change has global effects --*/

(*****************************************************************************\
*                                                                             *
*  ddeml.h -    DDEML API header file                                         *
*                                                                             *
*               Version 3.10                                                  *
*                                                                             *
*               Copyright 1993 - 1998 Microsoft Corp.  All rights reserved.   *
*                                                                             *
\*****************************************************************************)

interface

uses Windows;

/******** public types ********/
type
  HConvList = Longint;
  HConv = Longint;
  HSz = Longint;
  HDDEData = Longint;

const
  user32dll = 'user32.dll';

  // conversation states (usState)

  XST_NULL = 0;                 // quiescent states
  XST_INCOMPLETE = 1;
  XST_CONNECTED = 2;
  XST_INIT1 = 3;                // mid-initiation states
  XST_INIT2 = 4;
  XST_REQSENT = 5;              // active conversation states
  XST_DATARCVD = 6;
  XST_POKESENT = 7;
  XST_POKEACKRCVD = 8;
  XST_EXECSENT = 9;
  XST_EXECACKRCVD = 10;
  XST_ADVSENT = 11;
  XST_UNADVSENT = 12;
  XST_ADVACKRCVD = 13;
  XST_UNADVACKRCVD = 14;
  XST_ADVDATASENT = 15;
  XST_ADVDATAACKRCVD = 16;

  // used in LOWORD(dwData1) of XTYP_ADVREQ callbacks...

  CADV_LATEACK = $FFFF;

  // conversation status bits (fsStatus)

  ST_CONNECTED = $0001;
  ST_ADVISE = $0002;
  ST_ISLOCAL = $0004;
  ST_BLOCKED = $0008;
  ST_CLIENT = $0010;
  ST_TERMINATED = $0020;
  ST_INLIST = $0040;
  ST_BLOCKNEXT = $0080;
  ST_ISSELF = $0100;

  // DDE constants for wStatus field

  DDE_FACK = $8000;
  DDE_FBUSY = $4000;
  DDE_FDEFERUPD = $4000;
  DDE_FACKREQ = $8000;
  DDE_FRELEASE = $2000;
  DDE_FREQUESTED = $1000;
  DDE_FAPPSTATUS = $00ff;
  DDE_FNOTPROCESSED = $0000;

  DDE_FACKRESERVED = $3ff0;
  DDE_FADVRESERVED = $3fff;
  DDE_FDATRESERVED = $4fff;
  DDE_FPOKRESERVED = $dfff;

  // message filter hook types

  MSGF_DDEMGR = $8001;

  // default codepage for windows & old DDE convs.

  CP_WINANSI = 1004;
  CP_WINUNICOCDE = 1200;

  // transaction types

  XTYPF_NOBLOCK = $0002; // CBR_BLOCK will not work
  XTYPF_NODATA = $0004;  // DDE_FDEFERUPD
  XTYPF_ACKREQ = $0008;  // DDE_FACKREQ

  XCLASS_MASK = $FC00;
  XCLASS_BOOL = $1000;
  XCLASS_DATA = $2000;
  XCLASS_FLAGS = $4000;
  XCLASS_NOTIFICATION = $8000;

  XTYP_ERROR = $0000 or XCLASS_NOTIFICATION or XTYPF_NOBLOCK;
  XTYP_ADVDATA = $0010 or XCLASS_FLAGS;
  XTYP_ADVREQ = $0020 or XCLASS_DATA or XTYPF_NOBLOCK;
  XTYP_ADVSTART = $0030 or XCLASS_BOOL;
  XTYP_ADVSTOP = $0040 or XCLASS_NOTIFICATION;
  XTYP_EXECUTE = $0050 or XCLASS_FLAGS;
  XTYP_CONNECT = $0060 or XCLASS_BOOL or XTYPF_NOBLOCK;
  XTYP_CONNECT_CONFIRM = $0070 or XCLASS_NOTIFICATION or XTYPF_NOBLOCK;
  XTYP_XACT_COMPLETE = $0080 or XCLASS_NOTIFICATION;
  XTYP_POKE = $0090 or XCLASS_FLAGS;
  XTYP_REGISTER = $00A0 or XCLASS_NOTIFICATION or XTYPF_NOBLOCK;
  XTYP_REQUEST = $00B0 or XCLASS_DATA;
  XTYP_DISCONNECT = $00C0 or XCLASS_NOTIFICATION or XTYPF_NOBLOCK;
  XTYP_UNREGISTER = $00D0 or XCLASS_NOTIFICATION or XTYPF_NOBLOCK;
  XTYP_WILDCONNECT = $00E0 or XCLASS_DATA or XTYPF_NOBLOCK;

  XTYP_MASK = $00F0;
  XTYP_SHIFT = 4;  // shift to turn xtyp_ into an index

  // Timeout constants

  TIMEOUT_ASYNC =           -1;

  // Transaction ID constatnts
  QID_SYNC =                -1;

  // public strings used in DDE

  SZDDESYS_TOPIC = 'System';
  SZDDESYS_ITEM_TOPICS = 'Topics';
  SZDDESYS_ITEM_SYSITEMS = 'SysItems';
  SZDDESYS_ITEM_RTNMSG = 'ReturnMessage';
  SZDDESYS_ITEM_STATUS = 'Status';
  SZDDESYS_ITEM_FORMATS = 'Formats';
  SZDDESYS_ITEM_HELP = 'Help';
  SZDDE_ITEM_ITEMLIST = 'TopicItemList';

  MH_CREATE = 1;
  MH_KEEP = 2;
  MH_DELETE = 3;
  MH_CLEANUP = 4;

type
/****** API entry points ******/
{$w-}
  TFNCallback = function conv arg_stdcall (CallType, Fmt: UINT; _Conv: HConv; hsz1, hsz2: HSZ;
    Data: HDDEData; Data1, Data2: DWORD): HDDEData;
{$w+}

const
  CBR_BLOCK = $FFFFFFFF;

/*
 * Callback filter flags for use with standard apps.
 */

  CBF_FAIL_SELFCONNECTIONS = $00001000;
  CBF_FAIL_CONNECTIONS = $00002000;
  CBF_FAIL_ADVISES = $00004000;
  CBF_FAIL_EXECUTES = $00008000;
  CBF_FAIL_POKES = $00010000;
  CBF_FAIL_REQUESTS = $00020000;
  CBF_FAIL_ALLSVRXACTIONS = $0003f000;

  CBF_SKIP_CONNECT_CONFIRMS = $00040000;
  CBF_SKIP_REGISTRATIONS = $00080000;
  CBF_SKIP_UNREGISTRATIONS = $00100000;
  CBF_SKIP_DISCONNECTS = $00200000;
  CBF_SKIP_ALLNOTIFICATIONS = $003c0000;

/*
 * Application command flags
 */

  APPCMD_CLIENTONLY = $00000010;
  APPCMD_FILTERINITS = $00000020;
  APPCMD_MASK = $00000FF0;

/*
 * Application classification flags
 */

  APPCLASS_STANDARD = $00000000;
  APPCLASS_MASK = $0000000F;

  EC_ENABLEALL = 0;
  EC_ENABLEONE = ST_BLOCKNEXT;
  EC_DISABLE = ST_BLOCKED;
  EC_QUERYWAITING = 2;

  DNS_REGISTER = $0001;
  DNS_UNREGISTER = $0002;
  DNS_FILTERON = $0004;
  DNS_FILTEROFF = $0008;

  HDATA_APPOWNED = $0001;

/*
 * conversation enumeration functions
 */

  DMLERR_NO_ERROR = 0;       // must be 0

  DMLERR_FIRST = $4000;

  DMLERR_ADVACKTIMEOUT = $4000;
  DMLERR_BUSY = $4001;
  DMLERR_DATAACKTIMEOUT = $4002;
  DMLERR_DLL_NOT_INITIALIZED = $4003;
  DMLERR_DLL_USAGE = $4004;
  DMLERR_EXECACKTIMEOUT = $4005;
  DMLERR_INVALIDPARAMETER = $4006;
  DMLERR_LOW_MEMORY = $4007;
  DMLERR_MEMORY_ERROR = $4008;
  DMLERR_NOTPROCESSED = $4009;
  DMLERR_NO_CONV_ESTABLISHED = $400a;
  DMLERR_POKEACKTIMEOUT = $400b;
  DMLERR_POSTMSG_FAILED = $400c;
  DMLERR_REENTRANCY = $400D;
  DMLERR_SERVER_DIED = $400E;
  DMLERR_SYS_ERROR = $400F;
  DMLERR_UNADVACKTIMEOUT = $4010;
  DMLERR_UNFOUND_QUEUE_ID = $4011;

  DMLERR_LAST = $4011;

  MAX_MONITORS = 4;
  APPCLASS_MONITOR = 1;
  XTYP_MONITOR = $00F0 or XCLASS_NOTIFICATION or XTYPF_NOBLOCK;

/*
 * Callback filter flags for use with standard apps.
 */

  MF_HSZ_INFO = $01000000;
  MF_SENDMSGS = $02000000;
  MF_POSTMSGS = $04000000;
  MF_CALLBACKS = $08000000;
  MF_ERRORS = $10000000;
  MF_LINKS = $20000000;
  MF_CONV = $40000000;

type
  // the following structure is for use with xtyp_WildConnect processing.
  PHSZPair = ^THSZPair;
  THSZPair = record
    hszSvc: HSZ;
    hszTopic: HSZ;
  end;

  // The following structure is used by DdeConnect() and DdeConnectList()
  // and by xtyp_Connect and xtyp_WildConnect callbacks.

  PConvContext = ^TConvContext;
  TConvContext = record
    cb: UINT;            // set to sizeof(ConvCOnTEXT)
    wFlags: UINT;        // none currently defined.
    wCountryID: UINT;    // country code for topic/item strings used.
    iCodePage: Longint;  // codepage used for topic/item strings.
    dwLangID: DWORD;     // language ID for topic/item strings.
    dwSecurity: DWORD;   // Private security code.
    qos: TSecurityQualityOfService;
  end;

// The following structure is used by DdeQueryConvInfo():

  PConvInfo = ^TConvInfo;
  TConvInfo = record
    cb: DWORD;              // sizeof(CONVINFO)
    hUser: DWORD;           // user specified field
    hConvPartner: HConv;    // hConv on other end or 0 if non-ddemgr partner
    hszSvcPartner: HSz;     // app name of partner if obtainable
    hszServiceReq: HSz;     // AppName requested for connection
    hszTopic: HSz;          // Topic name for conversation
    hszItem: HSz;           // transaction item name or NULL if quiescent
    wFmt: UINT;             // transaction format or NULL if quiescent
    wType: UINT;            // XTYP_ for current transaction
    wStatus: UINT;          // ST_ constant for current conversation
    wConvst: UINT;          // XST_ constant for current transaction
    wLastError: UINT;       // last transaction error.
    hConvList: HConvList;   // parent hConvList if this conversation is in a list
    ConvCtxt: TConvContext; // conversation context
    hwnd: HWND;             // window handle for this conversation
    hwndPartner: HWND;      // partner window handle for this conversation
  end;

  // DDEML public debugging header file info

  TDdemlMsgHookData = packed record     // new for NT
    uiLo: UINT;                  // unpacked lo and hi parts of lParam
    uiHi: UINT;
    cbData: DWORD;               // amount of data in message, if any. May be > than 32 bytes.
    Data: array [0..7] of DWORD; // data peeking by DDESPY is limited to 32 bytes.
  end;

  TMonMsgStruct = packed record
    cb: UINT;
    hWndTo: HWND;
    dwTime: DWORD;
    hTask: THandle;
    wMsg: UINT;
    wParam: WPARAM;
    lParam: LPARAM;
    dmhd: TDdemlMsgHookData;
  end;

  TMonCBStruct = packed record
    cb: UINT;
    dwTime: DWORD;
    hTask: THandle;
    dwRet: DWORD;
    wType: UINT;
    wFmt: UINT;
    hConv: HConv;
    hsz1: HSZ;
    hsz2: HSZ;
    hData: HDDEData;
    dwData1: DWORD;
    dwData2: DWORD;
    cc: TConvContext;            // new for NT for XTYP_CONNECT callbacks
    cbData: DWORD;               // new for NT for data peeking
    Data: array [0..7] of DWORD; // new for NT for data peeking
  end;

  TMonHSZStructA = packed record
    cb: UINT;
    fsAction: BOOL;              // mh_ value
    dwTime: DWORD;
    HSZ: HSZ;
    hTask: THandle;
    wReserved: UINT;
    Str: array[0..0] of AnsiChar;
  end;

  TMonHSZStructW = packed record
    cb: UINT;
    fsAction: BOOL;              // mh_ value
    dwTime: DWORD;
    HSZ: HSZ;
    hTask: THandle;
    wReserved: UINT;
    Str: array[0..0] of WideChar;
  end;
  TMonHSZStruct = TMonHSZStructA;

  PMonErrStruct = ^TMonErrStruct;
  TMonErrStruct = packed record
    cb: UINT;
    wLastError: UINT;
    dwTime: DWORD;
    hTask: THandle;
  end;

  PMonLinkStruct = ^TMonLinkStruct;
  TMonLinkStruct = packed record
    cb: UINT;
    dwTime: DWORD;
    hTask: THandle;
    fEstablished: BOOL;
    fNoData: BOOL;
    hszSvc: HSz;
    hszTopic: HSz;
    hszItem: HSz;
    wFmt: UINT;
    fServer: BOOL;
    hConvServer: HConv;
    hConvClient: HConv;
  end;

  PMonConvStruct = ^TMonConvStruct;
  TMonConvStruct = packed record
    cb: UINT;
    fConnect: BOOL;
    dwTime: DWORD;
    hTask: THandle;
    hszSvc: HSz;
    hszTopic: HSz;
    hConvClient: HConv;
    hConvServer: HConv;
  end;

/* DLL registration functions */
function DdeInitializeA conv arg_stdcall (var Inst: Longint; Callback: TFNCallback; Cmd, Res: Longint): Longint;
  external user32dll name 'DdeInitializeA';

function DdeInitializeW conv arg_stdcall (var Inst: Longint; Callback: TFNCallback; Cmd, Res: Longint): Longint;
  external user32dll name 'DdeInitializeW';

function DdeInitialize conv arg_stdcall (var Inst: Longint; Callback: TFNCallback; Cmd, Res: Longint): Longint;
  external user32dll name 'DdeInitializeA';

function DdeUninitialize conv arg_stdcall (Inst: DWORD): Boolean;
  external user32dll name 'DdeUninitialize';

function DdeConnectList conv arg_stdcall (Inst: DWORD; Service, Topic: HSZ; ConvList: HConvList; CC: PConvContext): HConvList;
  external user32dll name 'DdeConnectList';

function DdeQueryNextServer conv arg_stdcall (ConvList: HConvList; ConvPrev: HConv): HConv;
  external user32dll name 'DdeQueryNextServer';

function DdeDisconnectList conv arg_stdcall (ConvList: HConvList): Boolean;
  external user32dll name 'DdeDisconnectList';

function DdeConnect conv arg_stdcall (Inst: DWORD; Service, Topic: HSZ; CC: PConvContext): HConv;
  external user32dll name 'DdeConnect';

function DdeDisconnect conv arg_stdcall (Conv: HConv): Boolean;
  external user32dll name 'DdeDisconnect';

function DdeReconnect conv arg_stdcall (Conv: HConv): HConv;
  external user32dll name 'DdeReconnect';

function DdeQueryConvInfo conv arg_stdcall (Conv: HConv; Transaction: DWORD; ConvInfo: PConvInfo): UINT;
  external user32dll name 'DdeQueryConvInfo';

function DdeSetUserHandle conv arg_stdcall (Conv: HConv; ID, User: DWORD): Boolean;
  external user32dll name 'DdeSetUserHandle';

function DdeAbandonTransaction conv arg_stdcall (Inst: DWORD; Conv: HConv; Transaction: DWORD): Boolean;
  external user32dll name 'DdeAbandonTransaction';

function DdePostAdvise conv arg_stdcall (Inst: DWORD; Topic, Item: HSZ): Boolean;
  external user32dll name 'DdePostAdvise';

function DdeEnableCallback conv arg_stdcall (Inst: DWORD; Conv: HConv; Cmd: UINT): Boolean;
  external user32dll name 'DdeEnableCallback';

function DdeNameService conv arg_stdcall (Inst: DWORD; hsz1, hsz2: HSZ; Cmd: UINT): HDDEData;
  external user32dll name 'DdeNameService';

function DdeClientTransaction conv arg_stdcall (Data: Pointer; DataLen: DWORD;
  _Conv: HConv; Item: HSZ; Fmt, DataType: UINT; Timeout: DWORD; Result: PDWORD): HDDEData;
  external user32dll name 'DdeClientTransaction';

function DdeCreateDataHandle conv arg_stdcall (Inst: DWORD; Src: Pointer; cb, Off: DWORD; Item: HSZ; Fmt, Cmd: UINT): HDDEData;
  external user32dll name 'DdeCreateDataHandle';

function DdeAddData conv arg_stdcall (Data: HDDEData; Src: Pointer; cb, Off: DWORD): HDDEData;
  external user32dll name 'DdeAddData';

function DdeGetData conv arg_stdcall (Data: HDDEData; Dst: Pointer; Max, Off: DWORD): DWORD;
  external user32dll name 'DdeGetData';

function DdeAccessData conv arg_stdcall (Data: HDDEData; DataSize: PDWORD): Pointer;
  external user32dll name 'DdeAccessData';

function DdeUnaccessData conv arg_stdcall (Data: HDDEData): Boolean;
  external user32dll name 'DdeUnaccessData';

function DdeFreeDataHandle conv arg_stdcall (Data: HDDEData): Boolean;
  external user32dll name 'DdeFreeDataHandle';

function DdeGetLastError conv arg_stdcall (Inst: DWORD): UINT;
  external user32dll name 'DdeGetLastError';

function DdeCreateStringHandleA conv arg_stdcall (Inst: DWORD; psz: PAnsiChar; CodePage: Longint): HSZ;
  external user32dll name 'DdeCreateStringHandleA';

function DdeCreateStringHandleW conv arg_stdcall (Inst: DWORD; psz: PWideChar; CodePage: Longint): HSZ;
  external user32dll name 'DdeCreateStringHandleW';

function DdeCreateStringHandle conv arg_stdcall (Inst: DWORD; psz: PChar; CodePage: Longint): HSZ;
  external user32dll name 'DdeCreateStringHandleA';

function DdeQueryStringA conv arg_stdcall (Inst: DWORD; HSZ: HSZ; psz: PAnsiChar; Max: DWORD; CodePage: Longint): DWORD;
  external user32dll name 'DdeQueryStringA';

function DdeQueryStringW conv arg_stdcall (Inst: DWORD; HSZ: HSZ; psz: PWideChar; Max: DWORD; CodePage: Longint): DWORD;
  external user32dll name 'DdeQueryStringW';

function DdeQueryString conv arg_stdcall (Inst: DWORD; HSZ: HSZ; psz: PChar; Max: DWORD; CodePage: Longint): DWORD;
  external user32dll name 'DdeQueryStringA';

function DdeFreeStringHandle conv arg_stdcall (Inst: DWORD; HSZ: HSZ): Boolean;
  external user32dll name 'DdeFreeStringHandle';

function DdeKeepStringHandle conv arg_stdcall (Inst: DWORD; HSZ: HSZ): Boolean;
  external user32dll name 'DdeKeepStringHandle';

function DdeCmpStringHandles conv arg_stdcall (hsz1, hsz2: HSZ): Longint;
  external user32dll name 'DdeCmpStringHandles';

implementation

end.
