(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows NT process API Interface Unit                  *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit PsAPI;

interface

uses Windows;

const
  psapidll = 'psapi.dll';

type

  _MODULEINFO = packed record
    lpBaseOfDll: Pointer;
    SizeOfImage: DWORD;
    EntryPoint: Pointer;
  end;
  MODULEINFO = _MODULEINFO;
  LPMODULEINFO = ^_MODULEINFO;
  TModuleInfo = _MODULEINFO;
  PModuleInfo = LPMODULEINFO;

  _PSAPI_WS_WATCH_INFORMATION = packed record
    FaultingPc: Pointer;
    FaultingVa: Pointer;
  end;
  PSAPI_WS_WATCH_INFORMATION = _PSAPI_WS_WATCH_INFORMATION;
  PPSAPI_WS_WATCH_INFORMATION = ^_PSAPI_WS_WATCH_INFORMATION;
  TPSAPIWsWatchInformation = _PSAPI_WS_WATCH_INFORMATION;
  PPSAPIWsWatchInformation = PPSAPI_WS_WATCH_INFORMATION;

  _PROCESS_MEMORY_COUNTERS = packed record
    cb: DWORD;
    PageFaultCount: DWORD;
    PeakWorkingSetSize: DWORD;
    WorkingSetSize: DWORD;
    QuotaPeakPagedPoolUsage: DWORD;
    QuotaPagedPoolUsage: DWORD;
    QuotaPeakNonPagedPoolUsage: DWORD;
    QuotaNonPagedPoolUsage: DWORD;
    PagefileUsage: DWORD;
    PeakPagefileUsage: DWORD;
  end;
  PROCESS_MEMORY_COUNTERS = _PROCESS_MEMORY_COUNTERS;
  PPROCESS_MEMORY_COUNTERS = ^_PROCESS_MEMORY_COUNTERS;
  TProcessMemoryCounters = _PROCESS_MEMORY_COUNTERS;
  PProcessMemoryCounters = ^_PROCESS_MEMORY_COUNTERS;

function EnumProcesses conv arg_stdcall (lpidProcess: LPDWORD; cb: DWORD; var cbNeeded: DWORD): Boolean;
  external psapidll name 'EnumProcesses';
function EnumProcessModules conv arg_stdcall (hProcess: THandle; lphModule: LPDWORD; cb: DWORD; var lpcbNeeded: DWORD): Boolean;
  external psapidll name 'EnumProcessModules';
function GetModuleBaseNameA conv arg_stdcall (hProcess: THandle; hModule: HMODULE; lpBaseName: PAnsiChar; nSize: DWORD): DWORD;
  external psapidll name 'GetModuleBaseNameA';
function GetModuleBaseNameW conv arg_stdcall (hProcess: THandle; hModule: HMODULE; lpBaseName: PWideChar; nSize: DWORD): DWORD;
  external psapidll name 'GetModuleBaseNameW';
function GetModuleBaseName conv arg_stdcall (hProcess: THandle; hModule: HMODULE; lpBaseName: PChar; nSize: DWORD): DWORD;
  external psapidll name 'GetModuleBaseName';
function GetModuleFileNameExA conv arg_stdcall (hProcess: THandle; hModule: HMODULE; lpFilename: PAnsiChar; nSize: DWORD): DWORD;
  external psapidll name 'GetModuleFileNameExA';
function GetModuleFileNameExW conv arg_stdcall (hProcess: THandle; hModule: HMODULE; lpFilename: PWideChar; nSize: DWORD): DWORD;
  external psapidll name 'GetModuleFileNameExW';
function GetModuleFileNameEx conv arg_stdcall (hProcess: THandle; hModule: HMODULE; lpFilename: PChar; nSize: DWORD): DWORD;
  external psapidll name 'GetModuleFileNameEx';
function GetModuleInformation conv arg_stdcall (hProcess: THandle; hModule: HMODULE; lpmodinfo: LPMODULEINFO; cb: DWORD): Boolean;
  external psapidll name 'GetModuleInformation';
function EmptyWorkingSet conv arg_stdcall (hProcess: THandle): Boolean;
  external psapidll name 'EmptyWorkingSet';
function QueryWorkingSet conv arg_stdcall (hProcess: THandle; pv: Pointer; cb: DWORD): Boolean;
  external psapidll name 'QueryWorkingSet';
function InitializeProcessForWsWatch conv arg_stdcall (hProcess: THandle): Boolean;
  external psapidll name 'InitializeProcessForWsWatch';
function GetMappedFileNameA conv arg_stdcall (hProcess: THandle; lpv: Pointer; lpFilename: PAnsiChar; nSize: DWORD): DWORD;
  external psapidll name 'GetMappedFileNameA';
function GetMappedFileNameW conv arg_stdcall (hProcess: THandle; lpv: Pointer; lpFilename: PWideChar; nSize: DWORD): DWORD;
  external psapidll name 'GetMappedFileNameW';
function GetMappedFileName conv arg_stdcall (hProcess: THandle; lpv: Pointer; lpFilename: PChar; nSize: DWORD): DWORD;
  external psapidll name 'GetMappedFileName';
function GetDeviceDriverBaseNameA conv arg_stdcall (ImageBase: Pointer; lpBaseName: PAnsiChar; nSize: DWORD): DWORD;
  external psapidll name 'GetDeviceDriverBaseNameA';
function GetDeviceDriverBaseNameW conv arg_stdcall (ImageBase: Pointer; lpBaseName: PWideChar; nSize: DWORD): DWORD;
  external psapidll name 'GetDeviceDriverBaseNameW';
function GetDeviceDriverBaseName conv arg_stdcall (ImageBase: Pointer; lpBaseName: PChar; nSize: DWORD): DWORD;
  external psapidll name 'GetDeviceDriverBaseName';
function GetDeviceDriverFileNameA conv arg_stdcall (ImageBase: Pointer; lpFileName: PAnsiChar; nSize: DWORD): DWORD;
  external psapidll name 'GetDeviceDriverFileNameA';
function GetDeviceDriverFileNameW conv arg_stdcall (ImageBase: Pointer; lpFileName: PWideChar; nSize: DWORD): DWORD;
  external psapidll name 'GetDeviceDriverFileNameW';
function GetDeviceDriverFileName conv arg_stdcall (ImageBase: Pointer; lpFileName: PChar; nSize: DWORD): DWORD;
  external psapidll name 'GetDeviceDriverFileName';
function GetProcessMemoryInfo conv arg_stdcall (Process: THandle; ppsmemCounters: PPROCESS_MEMORY_COUNTERS; cb: DWORD): Boolean;
  external psapidll name 'GetProcessMemoryInfo';

implementation

end.
