(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       URL Moniker support Unit                               *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit UrlMon;

interface

uses Windows, ActiveX;

const
  urlmondll = 'urlmon.dll';

const
  UseUI: Boolean = True;

  BINDVERB_GET       = $00000000;
  BINDVERB_POST      = $00000001;
  BINDVERB_PUT       = $00000002;
  BINDVERB_CUSTOM    = $00000003;

  BINDINFOF_URLENCODESTGMEDDATA   = $00000001;
  BINDINFOF_URLENCODEDEXTRAINFO   = $00000002;

  BINDF_ASYNCHRONOUS              = $00000001;
  BINDF_ASYNCSTORAGE              = $00000002;
  BINDF_NOPROGRESSIVERENDERING    = $00000004;
  BINDF_OFFLINEOPERATION          = $00000008;
  BINDF_GETNEWESTVERSION          = $00000010;
  BINDF_NOWRITECACHE              = $00000020;
  BINDF_NEEDFILE                  = $00000040;
  BINDF_PULLDATA                  = $00000080;
  BINDF_IGNORESECURITYPROBLEM     = $00000100;
  BINDF_RESYNCHRONIZE             = $00000200;
  BINDF_HYPERLINK                 = $00000400;
  BINDF_NO_UI                     = $00000800;
  BINDF_SILENTOPERATION           = $00001000;
  BINDF_PRAGMA_NO_CACHE           = $00002000;
  BINDF_FREE_THREADED             = $00010000;
  BINDF_DIRECT_READ               = $00020000;
  BINDF_FORMS_SUBMIT              = $00040000;
  BINDF_GETFROMCACHE_IF_NET_FAIL  = $00080000;
  BINDF_INLINESGETNEWESTVERSION   = $10000000;
  BINDF_INLINESRESYNCHRONIZE      = $20000000;
  BINDF_CONTAINER_NOWRITECACHE    = $40000000;
  BINDF_DONTUSECACHE   = BINDF_GETNEWESTVERSION;
  BINDF_DONTPUTINCACHE = BINDF_NOWRITECACHE;
  BINDF_NOCOPYDATA     = BINDF_PULLDATA;

  BSCF_FIRSTDATANOTIFICATION          = $00000001;
  BSCF_INTERMEDIATEDATANOTIFICATION   = $00000002;
  BSCF_LASTDATANOTIFICATION           = $00000004;

  BINDSTATUS_FINDINGRESOURCE          = 1;
  BINDSTATUS_CONNECTING               = 2;
  BINDSTATUS_REDIRECTING              = 3;
  BINDSTATUS_BEGINDOWNLOADDATA        = 4;
  BINDSTATUS_DOWNLOADINGDATA          = 5;
  BINDSTATUS_ENDDOWNLOADDATA          = 6;
  BINDSTATUS_BEGINDOWNLOADCOMPONENTS  = 7;
  BINDSTATUS_INSTALLINGCOMPONENTS     = 8;
  BINDSTATUS_ENDDOWNLOADCOMPONENTS    = 9;
  BINDSTATUS_USINGCACHEDCOPY          = 10;
  BINDSTATUS_SENDINGREQUEST           = 11;
  BINDSTATUS_CLASSIDAVAILABLE         = 12;
  BINDSTATUS_MIMETYPEAVAILABLE        = 13;
  BINDSTATUS_CACHEFILENAMEAVAILABLE   = 14;
  MKSYS_URLMONIKER = 6;

  URLMON_OPTION_USERAGENT     = $10000001;

  CF_NULL                     = 0;
  CFSTR_MIME_NULL             = 0;
  CFSTR_MIME_TEXT             = 'text/plain';
  CFSTR_MIME_RICHTEXT         = 'text/richtext';
  CFSTR_MIME_X_BITMAP         = 'image/x-xbitmap';
  CFSTR_MIME_POSTSCRIPT       = 'application/postscript';
  CFSTR_MIME_AIFF             = 'audio/aiff';
  CFSTR_MIME_BASICAUDIO       = 'audio/basic';
  CFSTR_MIME_WAV              = 'audio/wav';
  CFSTR_MIME_X_WAV            = 'audio/x-wav';
  CFSTR_MIME_GIF              = 'image/gif';
  CFSTR_MIME_PJPEG            = 'image/pjpeg';
  CFSTR_MIME_JPEG             = 'image/jpeg';
  CFSTR_MIME_TIFF             = 'image/tiff';
  CFSTR_MIME_X_PNG            = 'image/x-png';
  CFSTR_MIME_BMP              = 'image/bmp';
  CFSTR_MIME_X_ART            = 'image/x-jg';
  CFSTR_MIME_AVI              = 'video/avi';
  CFSTR_MIME_MPEG             = 'video/mpeg';
  CFSTR_MIME_FRACTALS         = 'application/fractals';
  CFSTR_MIME_RAWDATA          = 'application/octet-stream';
  CFSTR_MIME_RAWDATASTRM      = 'application/octet-stream';
  CFSTR_MIME_PDF              = 'application/pdf';
  CFSTR_MIME_X_AIFF           = 'audio/x-aiff';
  CFSTR_MIME_X_REALAUDIO      = 'audio/x-pn-realaudio';
  CFSTR_MIME_XBM              = 'image/xbm';
  CFSTR_MIME_QUICKTIME        = 'video/quicktime';
  CFSTR_MIME_X_MSVIDEO        = 'video/x-msvideo';
  CFSTR_MIME_X_SGI_MOVIE      = 'video/x-sgi-movie';
  CFSTR_MIME_HTML             = 'text/html';

  MK_S_ASYNCHRONOUS = $000401E8;
  S_ASYNCHRONOUS    = MK_S_ASYNCHRONOUS;
  E_PENDING         = $8000000A;

  INET_E_INVALID_URL               : HResult = $800C0002;
  INET_E_NO_SESSION                : HResult = $800C0003;
  INET_E_CANNOT_CONNECT            : HResult = $800C0004;
  INET_E_RESOURCE_NOT_FOUND        : HResult = $800C0005;
  INET_E_OBJECT_NOT_FOUND          : HResult = $800C0006;
  INET_E_DATA_NOT_AVAILABLE        : HResult = $800C0007;
  INET_E_DOWNLOAD_FAILURE          : HResult = $800C0008;
  INET_E_AUTHENTICATION_REQUIRED   : HResult = $800C0009;
  INET_E_NO_VALID_MEDIA            : HResult = $800C000A;
  INET_E_CONNECTION_TIMEOUT        : HResult = $800C000B;
  INET_E_INVALID_REQUEST           : HResult = $800C000C;
  INET_E_UNKNOWN_PROTOCOL          : HResult = $800C000D;
  INET_E_SECURITY_PROBLEM          : HResult = $800C000E;
  INET_E_CANNOT_LOAD_DATA          : HResult = $800C000F;
  INET_E_CANNOT_INSTANTIATE_OBJECT : HResult = $800C0010;
  INET_E_ERROR_FIRST               : HResult = $800C0002;
  INET_E_ERROR_LAST                : HResult = $800C0010;

  SOFTDIST_FLAG_USAGE_EMAIL         = $00000001;
  SOFTDIST_FLAG_USAGE_PRECACHE      = $00000002;
  SOFTDIST_FLAG_USAGE_AUTOINSTALL   = $00000004;
  SOFTDIST_FLAG_DELETE_SUBSCRIPTION = $00000008;

  SOFTDIST_ADSTATE_NONE             = $00000000;
  SOFTDIST_ADSTATE_AVAILABLE        = $00000001;
  SOFTDIST_ADSTATE_DOWNLOADED       = $00000002;
  SOFTDIST_ADSTATE_INSTALLED        = $00000003;

  URLOSTRM_USECACHEDCOPY_ONLY = $1;
  URLOSTRM_USECACHEDCOPY      = $2;
  URLOSTRM_GETNEWESTVERSION   = $3;

  IID_IPersistMoniker = '{79EAC9C9-BAF9-11CE-8C82-00AA004BA90B}';
  IID_IBindProtocol = '{79EAC9CD-BAF9-11CE-8C82-00AA004BA90B}';
  IID_IBinding = '{79EAC9C0-BAF9-11CE-8C82-00AA004BA90B}';
  IID_IBindStatusCallback = '{79EAC9C1-BAF9-11CE-8C82-00AA004BA90B}';
  IID_IAuthenticate = '{79EAC9D0-BAF9-11CE-8C82-00AA004BA90B}';
  IID_HttpNegotiate = '{79EAC9D2-BAF9-11CE-8C82-00AA004BA90B}';
  IID_IWindowForBindingUI = '{79EAC9D5-BAFA-11CE-8C82-00AA004BA90B}';
  IID_ICodeInstall = '{79EAC9D1-BAF9-11CE-8C82-00AA004BA90B}';
  IID_IWinInetInfo = '{79EAC9D6-BAFA-11CE-8C82-00AA004BA90B}';
  IID_IHttpSecurity = '{79EAC9D7-BAFA-11CE-8C82-00AA004BA90B}';
  IID_IWinInetHttpInfo = '{79EAC9D8-BAFA-11CE-8C82-00AA004BA90B}';
  IID_IBindHost = '{FC4801A1-2BA9-11CF-A229-00AA003D7352}';

type
  PBindInfo = ^TBindInfo;
  TBindInfo = packed record
    cbSize: Longint;
    szExtraInfo: PWideChar;
    stgmedData: TStgMedium;
    grfBindInfoF: DWORD;
    dwBindVerb: DWORD;
    szCustomVerb: PWideChar;
    cbstgmedData: Longint;
  end;

  PRemBindInfo = ^TRemBindInfo;
  TRemBindInfo = packed record
    cbSize: Cardinal;
    szExtraInfo: PWideChar;
    grfBindInfoF: DWORD;
    dwBindVerb: DWORD;
    szCustomVerb: PWideChar;
    cbstgmedData: DWORD;
  end;

  PRemFormatEtc = ^TRemFormatEtc;
  TRemFormatEtc = packed record
    cfFormat: DWORD;
    ptd: DWORD;
    dwAspect: DWORD;
    lindex: Longint;
    tymed: DWORD;
  end;

  _tagCODEBASEHOLD = packed record
    cbSize: ULONG;
    szDistUnit: PWideChar;
    szCodeBase: PWideChar;
    dwVersionMS: DWORD;
    dwVersionLS: DWORD;
    dwStyle: DWORD;
  end;
  PCodeBaseHold = ^TCodeBaseHold;
  TCodeBaseHold = _tagCODEBASEHOLD;

  _tagSOFTDISTINFO = packed record
    cbSize: ULONG;
    dwFlags: DWORD;
    dwAdState: DWORD;
    szTitle: PWideChar;
    szAbstract: PWideChar;
    szHREF: PWideChar;
    dwInstalledVersionMS: DWORD;
    dwInstalledVersionLS: DWORD;
    dwUpdateVersionMS: DWORD;
    dwUpdateVersionLS: DWORD;
    dwAdvertisedVersionMS: DWORD;
    dwAdvertisedVersionLS: DWORD;
    dwReserved: DWORD;
  end;
  PSoftDistInfo = ^TSoftDistInfo;
  TSoftDistInfo = _tagSOFTDISTINFO;

  PCIP_Status = ^TCip_Status;
  TCIP_Status = (CIP_DISK_FULL, CIP_ACCESS_DENIED, CIP_NEWER_VERSION_EXISTS,
    CIP_OLDER_VERSION_EXISTS, CIP_NAME_CONFLICT,
    CIP_TRUST_VERIFICATION_COMPONENT_MISSING,
    CIP_EXE_SELF_REGISTERATION_TIMEOUT, CIP_UNSAFE_TO_ABORT, CIP_NEED_REBOOT);

  IPersistMoniker = interface
    ['{79eac9c9-baf9-11ce-8c82-00aa004ba90b}']
    function GetClassID(out pClassID: TCLSID): HRESULT; stdcall;
    function IsDirty: HRESULT; stdcall;
    function Load(fFullyAvailable: BOOL; pimkName: IMoniker; pibc: IBindCtx; grfMode: DWORD): HResult; stdcall;
    function Save(pimkName: IMoniker; pibc: IBindCtx; fRemember: BOOL): HResult; stdcall;
    function SaveCompleted(pimkName: IMoniker; pibc: IBindCtx): HRESULT; stdcall;
    function GetCurMoniker(out ppimkName: IMoniker): HRESULT; stdcall;
  end;

  IBinding = interface
    ['{79eac9c0-baf9-11ce-8c82-00aa004ba90b}']
    function Abort: HResult; stdcall;
    function Suspend: HResult; stdcall;
    function Resume: HResult; stdcall;
    function SetPriority(nPriority: Longint): HResult; stdcall;
    function GetPriority(out nPriority: Longint): HResult; stdcall;
    function GetBindResult(out clsidProtocol: TGUID; out dwResult: Longint; out szResult: PWideChar; var dwReserved: Longint): HResult; stdcall;
  end;

  IBindProtocol = interface
    ['{79eac9cd-baf9-11ce-8c82-00aa004ba90b}']
    function CreateBinding(szUrl: PWideChar; pbc: IBindCtx;
      out ppb: IBinding): HResult; stdcall;
  end;

  IBindStatusCallback = interface
    ['{79eac9c1-baf9-11ce-8c82-00aa004ba90b}']
    function OnStartBinding(dwReserved: Longint; pib: IBinding): HResult;
      stdcall;
    function GetPriority(out pnPriority: Longint): HResult; stdcall;
    function OnLowResource(reserved: Longint): HResult; stdcall;
    function OnProgress(ulProgress: Longint; ulProgressMax: Longint; ulStatusCode: Longint; szStatusText: PWideChar): HResult; stdcall;
    function OnStopBinding( hRes: HResult; szError: PWideChar ): HResult; stdcall;
    function GetBindInfo(out grfBINDF: Longint; var pbindinfo: TBindInfo): HResult; stdcall;
    function OnDataAvailable(grfBSCF: Longint; dwSize: Longint; var pformatetc: TFormatEtc; var pstgmed: TSTGMEDIUM): HResult; stdcall;
    function OnObjectAvailable(const iid: TGUID; const punk: IUnknown): HResult;
      stdcall;
  end;

  IAuthenticate = interface
    ['{79eac9d0-baf9-11ce-8c82-00aa004ba90b}']
    function Authenticate(var phwnd: HWND; pszUserName, pszPassword: PWideChar): HRESULT; stdcall;
  end;

  IHttpNegotiate = interface
    ['{79eac9d2-baf9-11ce-8c82-00aa004ba90b}']
    function BeginningTransaction(szURL, szHeaders: PWideChar; dwReserved: DWORD;
      out pszAdditionalHeaders: PWideChar): HRESULT; stdcall; function OnResponse(dwResponseCode: DWORD; szResponseHeaders,
      szRequestHeaders: PWideChar; out pszAdditionalRequestHeaders: PWideChar):  HResult; stdcall;
  end;

  IWindowForBindingUI = interface
    ['{79eac9d5-bafa-11ce-8c82-00aa004ba90b}']
    function GetWindow(const guidReason: TGUID; out wnd: HWND): HResult; stdcall;
  end;

  ICodeInstall = interface(IWindowForBindingUI)
    ['{79eac9d1-baf9-11ce-8c82-00aa004ba90b}']
    function OnCodeInstallProblem(ulStatusCode: Cardinal; szDestination, szSource: PWideChar; dwReserved: DWORD): HResult; stdcall;
  end;

  IWinInetInfo = interface
    ['{79eac9d6-bafa-11ce-8c82-00aa004ba90b}']
    function QueryOption(dwOption: DWORD; Buffer: Pointer; var pcbBuf: DWORD): HResult; stdcall;
  end;

  IHttpSecurity = interface(IWindowForBindingUI)
    ['{79eac9d7-bafa-11ce-8c82-00aa004ba90b}']
    function OnSecurityProblem(dwProblem: DWORD): HRESULT; stdcall;
  end;

  IWinInetHttpInfo = interface(IWinInetInfo)
    ['{79eac9d8-bafa-11ce-8c82-00aa004ba90b}']
    function QueryInfo(dwOption: DWORD; pBuffer: Pointer; var pcbBuf, pdwFlags, pdwReserved: DWORD): HResult; stdcall;
  end;

  IBindHost = interface
    ['{fc4801a1-2ba9-11cf-a229-00aa003d7352}']
    function CreateMoniker(szName: PWideChar; pBC: IBindCtx; out ppmk: IMoniker; dwReserved: DWORD): HResult; stdcall;
    function MonikerBindToStorage(pMk: IMoniker; pBC: IBindCtx; pBSC: IBindStatusCallback; const riid: TIID; out ppvObj): HResult; stdcall;
    function RemoteMonikerBindToStorage(pMk: IMoniker; pBC: IBindCtx; pBSC: IBindStatusCallback; const riid: TIID; out ppvObj: IUnknown): HResult; stdcall;
    function MonikerBindToObject(pMk: IMoniker; pBC: IBindCtx; pBSC: IBindStatusCallback; const riid: TIID; out ppvObj): HResult; stdcall;
    function RemoteMonikerBindToObject(pMk: IMoniker; pBC: IBindCtx; pBSC: IBindStatusCallback; const riid: TIID; out ppvObj: IUnknown): HResult; stdcall;
  end;

function CreateURLMoniker(pMkCtx: IMoniker; szURL: PWideChar; out ppmk: IMoniker): HResult; stdcall;
  external urlmondll name 'CreateURLMoniker';

function GetClassURL(szURL: PWideChar; const pClsID: TCLSID): HResult; stdcall;
  external urlmondll name 'GetClassURL';

function CreateAsyncBindCtx(reserved: DWORD; pBSCb: IBindStatusCallback; pEFetc: IEnumFORMATETC; out ppBC: IBindCtx): HResult;
  external urlmondll name 'CreateAsyncBindCtx';

function MkParseDisplayNameEx(pbc: IBindCtx; szDisplayName: PWideChar; var pchEaten: Cardinal; out ppmk: IMoniker): HResult; stdcall;
  external urlmondll name 'MkParseDisplayNameEx';

function RegisterBindStatusCallback(pBC: IBindCtx; pBSCb: IBindStatusCallback; out ppBSCBPrev: IBindStatusCallback; dwReserved: DWORD): HResult; stdcall;
  external urlmondll name 'RegisterBindStatusCallback';

function RevokeBindStatusCallback(pBC: IBindCtx; pBSCb: IBindStatusCallback): HResult; stdcall;
  external urlmondll name '';

function GetClassFileOrMime(pBC: IBindCtx; szFilename: PWideChar; pBuffer: Pointer; cbSize: DWORD; szMime: PWideChar; dwReserved: DWORD; out pclsid: TCLSID): HResult; stdcall;
  external urlmondll name 'GetClassFileOrMime';

function IsValidURL(pBC: IBindCtx; szURL: PWideChar; dwReserved: DWORD): HResult; stdcall;
  external urlmondll name 'IsValidURL';

function CoGetClassObjectFromURL(const rCLASSID: TCLSID; szCODE: PWideChar; dwFileVersionMS: DWORD; dwFileVersionLS: DWORD; szTYPE: PWideChar;
  pBindCtx: IBindCtx; dwClsContext: DWORD; pvReserved: Pointer; const riid: TIID; out ppv): HResult; stdcall;
  external urlmondll name 'CoGetClassObjectFromURL';

function IsAsyncMoniker(pmk: IMoniker): HResult; stdcall;
  external urlmondll name 'IsAsyncMoniker';

function CreateURLBinding(lpszUrl: PWideChar; pbc: IBindCtx; out ppBdg: IBinding): HResult; stdcall;
  external urlmondll name 'CreateURLBinding';

function RegisterMediaTypesW(ctypes: Cardinal; rgszTypes: PWideChar; const rgcfTypes: TClipFormat): HResult; stdcall;
  external urlmondll name 'RegisterMediaTypesW';

function RegisterMediaTypes(ctypes: Cardinal; rgszTypes: PChar; const rgcfTypes: TClipFormat): HResult; stdcall;
  external urlmondll name 'RegisterMediaTypes';

function FindMediaType(rgszTypes: PChar; rgcfTypes: TClipFormat): HResult; stdcall;
  external urlmondll name 'FindMediaType';

function CreateFormatEnumerator(cfmtetc: Cardinal; const rgfmtetc: TFormatEtc; out ppenumfmtetc: IEnumFormatEtc): HResult; stdcall;
  external urlmondll name 'CreateFormatEnumerator';

function RegisterFormatEnumerator(pBC: IBindCtx; pEFetc: IEnumFormatEtc; reserved: DWORD): HResult; stdcall;
  external urlmondll name 'RegisterFormatEnumerator';

function RevokeFormatEnumerator(pBC: IBindCtx; pEFetc: IEnumFormatEtc): HResult; stdcall;
  external urlmondll name 'RevokeFormatEnumerator';

function RegisterMediaTypeClass(pBC: IBindCtx; ctypes: Cardinal; rgszTypes: PChar; const rgclsID: TCLSID; reserved: DWORD): HResult; stdcall;
  external urlmondll name 'RegisterMediaTypeClass';

function FindMediaTypeClass(pBC: IBindCtx; szType: PChar; out pclsID: TCLSID; reserved: DWORD): HResult; stdcall;
  external urlmondll name 'FindMediaTypeClass';

function UrlMkSetSessionOption(dwOption: DWORD; pBuffer: Pointer; dwBufferLength: DWORD; dwReserved: DWORD): HResult; stdcall;
  external urlmondll name 'UrlMkSetSessionOption';

function HlinkSimpleNavigateToString(szTarget, szLocation, szTargetFrameName: PWideChar; pUnk: IUnknown; pbc: IBindCtx;
  pBSCb: IBindStatusCallback; grfHLNF, dwReserved: DWORD): HResult; stdcall;
  external urlmondll name 'HlinkSimpleNavigateToString';

function HlinkSimpleNavigateToMoniker(pmkTarget: IMoniker; szLocation, szTargetFrameName: PWideChar; pUnk: IUnknown; pbc: IBindCtx;
  pBSCb: IBindStatusCallback; grfHLNF, dwReserved: DWORD): HResult; stdcall;
  external urlmondll name 'HlinkSimpleNavigateToMoniker';

function URLOpenStreamA(p1: IUnknown; p2: PAnsiChar; p3: DWORD; p4: IBindStatusCallback): HResult; stdcall;
  external urlmondll name 'URLOpenStreamA';

function URLOpenStreamW(p1: IUnknown; p2: PWideChar; p3: DWORD; p4: IBindStatusCallback): HResult; stdcall;
  external urlmondll name '';

function URLOpenStream(p1: IUnknown; p2: PChar; p3: DWORD; p4: IBindStatusCallback): HResult; stdcall;
  external urlmondll name 'URLOpenStreamA';

function URLOpenPullStreamA(p1: IUnknown; p2: PAnsiChar; p3: DWORD; p4: IBindStatusCallback): HResult; stdcall;
  external urlmondll name 'URLOpenPullStreamA';

function URLOpenPullStreamW(p1: IUnknown; p2: PWideChar; p3: DWORD; p4: IBindStatusCallback): HResult; stdcall;
  external urlmondll name 'URLOpenPullStreamW';

function URLOpenPullStream(p1: IUnknown; p2: PChar; p3: DWORD; p4: IBindStatusCallback): HResult; stdcall;
  external urlmondll name 'URLOpenPullStreamA';

function URLDownloadToFileA(p1: IUnknown; p2: PAnsiChar; p3: PAnsiChar; p4: DWORD; p5: IBindStatusCallback): HResult; stdcall;
  external urlmondll name 'URLDownloadToFileA';

function URLDownloadToFileW(p1: IUnknown; p2: PWideChar; p3: PWideChar; p4: DWORD; p5: IBindStatusCallback): HResult; stdcall;
  external urlmondll name 'URLDownloadToFileW';

function URLDownloadToFile(p1: IUnknown; p2: PChar; p3: PChar; p4: DWORD; p5: IBindStatusCallback): HResult; stdcall;
  external urlmondll name 'URLDownloadToFileA';

function URLDownloadToCacheFileA(p1: IUnknown; p2: PAnsiChar; p3: PAnsiChar; p4: DWORD; p5: DWORD; p6: IBindStatusCallback): HResult; stdcall;
  external urlmondll name 'URLDownloadToCacheFileA';

function URLDownloadToCacheFileW(p1: IUnknown; p2: PWideChar; p3: PWideChar; p4: DWORD; p5: DWORD; p6: IBindStatusCallback): HResult; stdcall;
  external urlmondll name 'URLDownloadToCacheFileW';

function URLDownloadToCacheFile(p1: IUnknown; p2: PChar; p3: PChar; p4: DWORD; p5: DWORD; p6: IBindStatusCallback): HResult; stdcall;
  external urlmondll name 'URLDownloadToCacheFileA';

function URLOpenBlockingStreamA(p1: IUnknown; p2: PAnsiChar; out p3: IStream; p4: DWORD; p5: IBindStatusCallback): HResult; stdcall;
  external urlmondll name 'URLOpenBlockingStreamA';

function URLOpenBlockingStreamW(p1: IUnknown; p2: PWideChar; out p3: IStream; p4: DWORD; p5: IBindStatusCallback): HResult; stdcall;
  external urlmondll name 'URLOpenBlockingStreamW';

function URLOpenBlockingStream(p1: IUnknown; p2: PChar; out p3: IStream; p4: DWORD; p5: IBindStatusCallback): HResult; stdcall;
  external urlmondll name 'URLOpenBlockingStreamA';

function HlinkGoBack(pUnk: IUnknown): HResult; stdcall;
  external urlmondll name 'HlinkGoBack';

function HlinkGoForward(pUnk: IUnknown): HResult; stdcall;
  external urlmondll name 'HlinkGoForward';

function HlinkNavigateString(pUnk: IUnknown; szTarget: PWideChar): HResult; stdcall;
  external urlmondll name 'HlinkNavigateString';

function HlinkNavigateMoniker(pUnk: IUnknown; pmkTarget: IMoniker): HResult; stdcall;
  external urlmondll name 'HlinkNavigateMoniker';

implementation
  (* nothing to implement *)
end.