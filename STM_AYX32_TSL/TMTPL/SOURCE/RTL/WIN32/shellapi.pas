(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit API Interface Unit                       *)
(*       Based on shellapi.h                                    *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995-98 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit ShellAPI;

interface

uses Windows;

const
  shell32dll               = 'shell32.dll';

const
 ABM_NEW                 = $00000000;
 ABM_REMOVE              = $00000001;
 ABM_QUERYPOS            = $00000002;
 ABM_SETPOS              = $00000003;
 ABM_GETSTATE            = $00000004;
 ABM_GETTASKBARPOS       = $00000005;
 ABM_ACTIVATE            = $00000006;
 ABM_GETAUTOHIDEBAR      = $00000007;
 ABM_SETAUTOHIDEBAR      = $00000008;
 ABM_WINDOWPOSCHANGED    = $0000009;
 ABN_STATECHANGE         = $0000000;
 ABN_POSCHANGED          = $0000001;
 ABN_FULLSCREENAPP       = $0000002;
 ABN_WINDOWARRANGE       = $0000003;
 ABS_AUTOHIDE            = $0000001;
 ABS_ALWAYSONTOP         = $0000002;

 ABE_LEFT                = $0000000;
 ABE_TOP                 = $0000001;
 ABE_RIGHT               = $0000002;
 ABE_BOTTOM              = $0000003;

 NIM_ADD                 = $00000000;
 NIM_MODIFY              = $00000001;
 NIM_DELETE              = $00000002;

 NIF_MESSAGE             = $00000001;
 NIF_ICON                = $00000002;
 NIF_TIP                 = $00000004;

 FO_MOVE                 = $0001;
 FO_COPY                 = $0002;
 FO_DELETE               = $0003;
 FO_RENAME               = $0004;

 FOF_MULTIDESTFILES      = $0001;
 FOF_CONFIRMMOUSE        = $0002;
 FOF_SILENT              = $0004;
 FOF_RENAMEONCOLLISION   = $0008;
 FOF_NOCONFIRMATION      = $0010;
 FOF_WANTMAPPINGHANDLE   = $0020;

 FOF_ALLOWUNDO           = $0040;
 FOF_FILESONLY           = $0080;
 FOF_SIMPLEPROGRESS      = $0100;
 FOF_NOCONFIRMMKDIR      = $0200;
 FOF_NOERRORUI           = $0400;

 PO_DELETE               = $0013;
 PO_RENAME               = $0014;
 PO_PORTCHANGE           = $0020;

 PO_REN_PORT             = $0034;

 SE_ERR_FNF              = $02;
 SE_ERR_PNF              = $03;
 SE_ERR_ACCESSDENIED     = $05;
 SE_ERR_OOM              = $08;
 SE_ERR_SHARE            = $1A;
 SE_ERR_ASSOCINCOMPLETE  = $1B;
 SE_ERR_DDETIMEOUT       = $1C;
 SE_ERR_DDEFAIL          = $1D;
 SE_ERR_DDEBUSY          = $1E;
 SE_ERR_NOASSOC          = $1F;
 SE_ERR_DLLNOTFOUND      = $20;

 SEE_MASK_CLASSNAME      = $00000001;
 SEE_MASK_CLASSKEY       = $00000003;
 SEE_MASK_IDLIST         = $00000004;
 SEE_MASK_INVOKEIDLIST   = $0000000c;
 SEE_MASK_ICON           = $00000010;
 SEE_MASK_HOTKEY         = $00000020;
 SEE_MASK_NOCLOSEPROCESS = $00000040;
 SEE_MASK_CONNECTNETDRV  = $00000080;
 SEE_MASK_FLAG_DDEWAIT   = $00000100;
 SEE_MASK_DOENVSUBST     = $00000200;
 SEE_MASK_FLAG_NO_UI     = $00000400;
 SEE_MASK_UNICODE        = $00010000;
 SEE_MASK_NO_CONSOLE     = $00008000;
 SEE_MASK_ASYNCOK        = $00100000;

 SHGNLI_PIDL             = $000000001;
 SHGNLI_PREFIXNAME       = $000000002;
 SHGNLI_NOUNIQUE         = $000000004;

 SHGFI_ICON              = $000000100;
 SHGFI_DISPLAYNAME       = $000000200;
 SHGFI_TYPENAME          = $000000400;
 SHGFI_ATTRIBUTES        = $000000800;
 SHGFI_ICONLOCATION      = $000001000;
 SHGFI_EXETYPE           = $000002000;
 SHGFI_SYSICONINDEX      = $000004000;
 SHGFI_LINKOVERLAY       = $000008000;
 SHGFI_SELECTED          = $000010000;
 SHGFI_LARGEICON         = $000000000;
 SHGFI_SMALLICON         = $000000001;
 SHGFI_OPENICON          = $000000002;
 SHGFI_SHELLICONSIZE     = $000000004;
 SHGFI_PIDL              = $000000008;
 SHGFI_USEFILEATTRIBUTES = $000000010;

type
 HDROP        = Longint;
 FILEOP_FLAGS = Word;
 PRINTEROP_FLAGS = Word;
 PPWideChar = ^PWideChar;

  PDragInfoA = ^TDragInfoA;
  PDragInfoW = ^TDragInfoW;
  PDragInfo = PDragInfoA;
  TDragInfoA = record
    uSize: UINT;
    pt: TPoint;
    fNC: BOOL;
    lpFileList: PAnsiChar;
    grfKeyState: DWORD;
  end;
  TDragInfoW = record
    uSize: UINT;
    pt: TPoint;
    fNC: BOOL;
    lpFileList: PWideChar;
    grfKeyState: DWORD;
  end;
  TDragInfo = TDragInfoA;

  PAppBarData = ^TAppBarData;
  TAppBarData = record
    cbSize: DWORD;
    hWnd: HWND;
    uCallbackMessage: UINT;
    uEdge: UINT;
    rc: TRect;
    lParam: LPARAM;
  end;

  PSHNameMappingA = ^TSHNameMappingA;
  PSHNameMappingW = ^TSHNameMappingW;
  PSHNameMapping = PSHNameMappingA;
  TSHNameMappingA = record
    pszOldPath: PAnsiChar;
    pszNewPath: PAnsiChar;
    cchOldPath: LongInt;
    cchNewPath: LongInt;
  end;
  TSHNameMappingW = record
    pszOldPath: PWideChar;
    pszNewPath: PWideChar;
    cchOldPath: LongInt;
    cchNewPath: LongInt;
  end;
  TSHNameMapping = TSHNameMappingA;

  PShellExecuteInfoA = ^TShellExecuteInfoA;
  PShellExecuteInfoW = ^TShellExecuteInfoW;
  PShellExecuteInfo = PShellExecuteInfoA;
  TShellExecuteInfoA = record
    cbSize: DWORD;
    fMask: ULONG;
    Wnd: HWND;
    lpVerb: PAnsiChar;
    lpFile: PAnsiChar;
    lpParameters: PAnsiChar;
    lpDirectory: PAnsiChar;
    nShow: LongInt;
    hInstApp: HINST;
    lpIDList: Pointer;
    lpClass: PAnsiChar;
    hkeyClass: HKEY;
    dwHotKey: DWORD;
    hIcon: THandle;
    hProcess: THandle;
  end;
  TShellExecuteInfoW = record
    cbSize: DWORD;
    fMask: ULONG;
    Wnd: HWND;
    lpVerb: PWideChar;
    lpFile: PWideChar;
    lpParameters: PWideChar;
    lpDirectory: PWideChar;
    nShow: LongInt;
    hInstApp: HINST;
    lpIDList: Pointer;
    lpClass: PWideChar;
    hkeyClass: HKEY;
    dwHotKey: DWORD;
    hIcon: THandle;
    hProcess: THandle;
  end;
  TShellExecuteInfo = TShellExecuteInfoA;

  PNotifyIconDataA = ^TNotifyIconDataA;
  PNotifyIconDataW = ^TNotifyIconDataW;
  PNotifyIconData = PNotifyIconDataA;
  TNotifyIconDataA = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array [0..63] of AnsiChar;
  end;
  TNotifyIconDataW = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array [0..63] of WideChar;
  end;
  TNotifyIconData = TNotifyIconDataA;

  PSHFileInfoA = ^TSHFileInfoA;
  PSHFileInfoW = ^TSHFileInfoW;
  PSHFileInfo = PSHFileInfoA;
  TSHFileInfoA = record
    hIcon: HICON;
    iIcon: LongInt;
    dwAttributes: DWORD;
    szDisplayName: array [0..MAX_PATH-1] of AnsiChar;
    szTypeName: array [0..79] of AnsiChar;
  end;
  TSHFileInfoW = record
    hIcon: HICON;
    iIcon: LongInt;
    dwAttributes: DWORD;
    szDisplayName: array [0..MAX_PATH-1] of  WideChar;
    szTypeName: array [0..79] of WideChar;
  end;
  TSHFileInfo = TSHFileInfoA;

  PSHFileOpStructA = ^TSHFileOpStructA;
  PSHFileOpStructW = ^TSHFileOpStructW;
  PSHFileOpStruct = PSHFileOpStructA;
  TSHFileOpStructA = packed record
    Wnd: HWND;
    wFunc: UINT;
    pFrom: PAnsiChar;
    pTo: PAnsiChar;
    fFlags: FILEOP_FLAGS;
    fAnyOperationsAborted: BOOL;
    hNameMappings: Pointer;
    lpszProgressTitle: PAnsiChar; { only used if FOF_SIMPLEPROGRESS }
  end;
  TSHFileOpStructW = packed record
    Wnd: HWND;
    wFunc: UINT;
    pFrom: PWideChar;
    pTo: PWideChar;
    fFlags: FILEOP_FLAGS;
    fAnyOperationsAborted: BOOL;
    hNameMappings: Pointer;
    lpszProgressTitle: PWideChar; { only used if FOF_SIMPLEPROGRESS }
  end;
  TSHFileOpStruct = TSHFileOpStructA;

//////////////////////////////// SHELL32.DLL //////////////////////////////////

function CommandLineToArgvW conv arg_stdcall (lpCmdLine: LPCWSTR; var pNumArgs: LongInt): PPWideChar;
 external shell32dll name 'CommandLineToArgvW';

function DoEnvironmentSubstA conv arg_stdcall (szString: PAnsiChar; cbString: UINT): DWORD;
 external shell32dll name 'DoEnvironmentSubstA';

function DoEnvironmentSubstW conv arg_stdcall (szString: PWideChar; cbString: UINT): DWORD;
 external shell32dll name 'DoEnvironmentSubstW';

function DoEnvironmentSubst conv arg_stdcall (szString: PChar; cbString: UINT): DWORD;
 external shell32dll name 'DoEnvironmentSubstA';

procedure DragAcceptFiles conv arg_stdcall (Wnd: HWND; Accept: BOOL);
 external shell32dll name 'DragAcceptFiles';

procedure DragFinish conv arg_stdcall (Drop: HDROP);
 external shell32dll name 'DragFinish';

function DragQueryFileA conv arg_stdcall (Drop: HDROP; FileIndex: UINT; FileName: PAnsiChar; cb: UINT): UINT;
 external shell32dll name 'DragQueryFileA';

function DragQueryFileW conv arg_stdcall (Drop: HDROP; FileIndex: UINT; FileName: PWideChar; cb: UINT): UINT;
 external shell32dll name 'DragQueryFileW';

function DragQueryFile conv arg_stdcall (Drop: HDROP; FileIndex: UINT; FileName: PChar; cb: UINT): UINT;
 external shell32dll name 'DragQueryFileA';

function DragQueryPoint conv arg_stdcall (Drop: HDROP; var Point: TPoint): BOOL;
 external shell32dll name 'DragQueryPoint';

function DuplicateIcon conv arg_stdcall (hInst: HINST; Icon: HICON): HICON;
 external shell32dll name 'DuplicateIcon';

function ExtractAssociatedIconA conv arg_stdcall (hInst: HINST; lpIconPath: PAnsiChar; var lpiIcon: Word): HICON;
 external shell32dll name 'ExtractAssociatedIconA';

function ExtractAssociatedIconW conv arg_stdcall (hInst: HINST; lpIconPath: PWideChar; var lpiIcon: Word): HICON;
 external shell32dll name 'ExtractAssociatedIconW';

function ExtractAssociatedIcon conv arg_stdcall (hInst: HINST; lpIconPath: PChar; var lpiIcon: Word): HICON;
 external shell32dll name 'ExtractAssociatedIconA';

function ExtractIconA conv arg_stdcall (hInst: HINST; lpszExeFileName: PAnsiChar; nIconIndex: UINT): HICON;
 external shell32dll name 'ExtractIconA';

function ExtractIconW conv arg_stdcall (hInst: HINST; lpszExeFileName: PWideChar; nIconIndex: UINT): HICON;
 external shell32dll name 'ExtractIconW';

function ExtractIcon conv arg_stdcall (hInst: HINST; lpszExeFileName: PChar; nIconIndex: UINT): HICON;
 external shell32dll name 'ExtractIconA';

function ExtractIconExA conv arg_stdcall (lpszFile: PAnsiChar; nIconIndex: LongInt;
 var phiconLarge, phiconSmall: HICON; nIcons: UINT): UINT;
 external shell32dll name 'ExtractIconExA';

function ExtractIconExW conv arg_stdcall (lpszFile: PWideChar; nIconIndex: LongInt;
 var phiconLarge, phiconSmall: HICON; nIcons: UINT): UINT;
 external shell32dll name 'ExtractIconExW';

function ExtractIconEx conv arg_stdcall (lpszFile: PChar; nIconIndex: LongInt;
 var phiconLarge, phiconSmall: HICON; nIcons: UINT): UINT;
 external shell32dll name 'ExtractIconExA';

function FindExecutableA conv arg_stdcall (FileName, Directory: PAnsiChar; Result: PAnsiChar): HINST;
 external shell32dll name 'FindExecutableA';

function FindExecutableW conv arg_stdcall (FileName, Directory: PWideChar; Result: PWideChar): HINST;
 external shell32dll name 'FindExecutableW';

function FindExecutable conv arg_stdcall (FileName, Directory: PChar; Result: PChar): HINST;
 external shell32dll name 'FindExecutableA';

function SHAppBarMessage conv arg_stdcall (dwMessage: DWORD; var pData: TAppBarData): UINT;
 external shell32dll name 'SHAppBarMessage';

function SHFileOperationA conv arg_stdcall (const lpFileOp: TSHFileOpStructA): LongInt;
 external shell32dll name 'SHFileOperationA';

function SHFileOperationW conv arg_stdcall (const lpFileOp: TSHFileOpStructW): LongInt;
 external shell32dll name 'SHFileOperationW';

function SHFileOperation conv arg_stdcall (const lpFileOp: TSHFileOpStruct): LongInt;
 external shell32dll name 'SHFileOperationA';

procedure SHFreeNameMappings conv arg_stdcall (hNameMappings: THandle);
 external shell32dll name 'SHFreeNameMappings';

function SHGetFileInfoA conv arg_stdcall (pszPath: PAnsiChar; dwFileAttributes: DWORD;
 var psfi: TSHFileInfoA; cbFileInfo, uFlags: UINT): DWORD;
 external shell32dll name 'SHGetFileInfoA';

function SHGetFileInfoW conv arg_stdcall (pszPath: PAnsiChar; dwFileAttributes: DWORD;
 var psfi: TSHFileInfoW; cbFileInfo, uFlags: UINT): DWORD;
 external shell32dll name 'SHGetFileInfoW';

function SHGetFileInfo conv arg_stdcall (pszPath: PAnsiChar; dwFileAttributes: DWORD;
 var psfi: TSHFileInfo; cbFileInfo, uFlags: UINT): DWORD;
 external shell32dll name 'SHGetFileInfoA';

function ShellAboutA conv arg_stdcall (Wnd: HWND; szApp, szOtherStuff: PAnsiChar; Icon: HICON): LongInt;
 external shell32dll name 'ShellAboutA';

function ShellAboutW conv arg_stdcall (Wnd: HWND; szApp, szOtherStuff: PWideChar; Icon: HICON): LongInt;
 external shell32dll name 'ShellAboutW';

function ShellAbout conv arg_stdcall (Wnd: HWND; szApp, szOtherStuff: PChar; Icon: HICON): LongInt;
 external shell32dll name 'ShellAboutA';

function ShellExecuteA conv arg_stdcall (hWnd: HWND; Operation, FileName, Parameters, Directory: PAnsiChar; ShowCmd: LongInt): HINST;
 external shell32dll name 'ShellExecuteA';

function ShellExecuteW conv arg_stdcall (hWnd: HWND; Operation, FileName, Parameters, Directory: PWideChar; ShowCmd: LongInt): HINST;
 external shell32dll name 'ShellExecuteW';

function ShellExecute conv arg_stdcall (hWnd: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: LongInt): HINST;
 external shell32dll name 'ShellExecuteA';

function ShellExecuteExA conv arg_stdcall (lpExecInfo: PShellExecuteInfoA): BOOL;
 external shell32dll name 'ShellExecuteExA';

function ShellExecuteExW conv arg_stdcall (lpExecInfo: PShellExecuteInfoW): BOOL;
 external shell32dll name 'ShellExecuteExW';

function ShellExecuteEx conv arg_stdcall (lpExecInfo: PShellExecuteInfo): BOOL;
 external shell32dll name 'ShellExecuteExA';

function Shell_NotifyIconA conv arg_stdcall (dwMessage: DWORD; lpData: PNotifyIconDataA): BOOL;
 external shell32dll name 'Shell_NotifyIconA';

function Shell_NotifyIconW conv arg_stdcall (dwMessage: DWORD; lpData: PNotifyIconDataW): BOOL;
 external shell32dll name 'Shell_NotifyIconW';

function Shell_NotifyIcon conv arg_stdcall (dwMessage: DWORD; lpData: PNotifyIconData): BOOL;
 external shell32dll name 'Shell_NotifyIconA';

implementation

end.
