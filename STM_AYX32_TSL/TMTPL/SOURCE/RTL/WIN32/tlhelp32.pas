(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Win32 Tool Help Unit                                   *)
(*       Based on tlhelp32.h                                    *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995,99 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit TLHelp32;

(****************************************************************************)
(*                                                                          *)
(* tlhelp32.h -  WIN32 tool help functions, types, and definitions          *)
(*                                                                          *)
(* Version 1.0                                                              *)
(*                                                                          *)
(* NOTE: windows.h/winbase.h must be #included first                        *)
(*                                                                          *)
(* Copyright 1994 - 1998 Microsoft Corp.   All rights reserved.             *)
(*                                                                          *)
(****************************************************************************)

interface

uses Windows;

const
  kernel32dll = 'kernel32.dll';

const
  MAX_MODULE_NAME32   = $000000FF;
  TH32CS_SNAPHEAPLIST = $00000001;
  TH32CS_SNAPPROCESS  = $00000002;
  TH32CS_SNAPTHREAD   = $00000004;
  TH32CS_SNAPMODULE   = $00000008;
  TH32CS_SNAPALL      = TH32CS_SNAPHEAPLIST or TH32CS_SNAPPROCESS or
                        TH32CS_SNAPTHREAD or TH32CS_SNAPMODULE;
  TH32CS_INHERIT      = $80000000;

//
// Use CloseHandle to destroy the snapshot
//

(****** heap walking ***************************************************)

type
  tagHEAPLIST32 = record
    dwSize: DWORD;
    th32ProcessID: DWORD;  // owning process
    th32HeapID: DWORD;     // heap (in owning process's context!)
    dwFlags: DWORD;
  end;
  HEAPLIST32 = tagHEAPLIST32;
  PHEAPLIST32 = ^tagHEAPLIST32;
  LPHEAPLIST32 = ^tagHEAPLIST32;
  THeapList32 = tagHEAPLIST32;
//
// dwFlags
//
const
  HF32_DEFAULT = 1;  // process's default heap
  HF32_SHARED  = 2;  // is shared heap

type
  tagHEAPENTRY32 = record
    dwSize: DWORD;
    hHandle: THandle;     // Handle of this heap block
    dwAddress: DWORD;     // Linear address of start of block
    dwBlockSize: DWORD;   // Size of block in bytes
    dwFlags: DWORD;
    dwLockCount: DWORD;
    dwResvd: DWORD;
    th32ProcessID: DWORD; // owning process
    th32HeapID: DWORD;    // heap block is in
  end;
  HEAPENTRY32 = tagHEAPENTRY32;
  PHEAPENTRY32 = ^tagHEAPENTRY32;
  LPHEAPENTRY32 = ^tagHEAPENTRY32;
  THeapEntry32 = tagHEAPENTRY32;
//
// dwFlags
//
const
  LF32_FIXED    = $00000001;
  LF32_FREE     = $00000002;
  LF32_MOVEABLE = $00000004;

(***** Process walking *************************************************)
type
  tagPROCESSENTRY32W = packed record
    dwSize: DWORD;
    cntUsage: DWORD;
    th32ProcessID: DWORD;       // this process
    th32DefaultHeapID: DWORD;
    th32ModuleID: DWORD;        // associated exe
    cntThreads: DWORD;
    th32ParentProcessID: DWORD; // this process's parent process
    pcPriClassBase: Longint;    // Base priority of process's threads
    dwFlags: DWORD;
    szExeFile: array[0..MAX_PATH - 1] of WChar;// Path
  end;
  PROCESSENTRY32W = tagPROCESSENTRY32W;
  PPROCESSENTRY32W = ^tagPROCESSENTRY32W;
  LPPROCESSENTRY32W = ^tagPROCESSENTRY32W;
  TProcessEntry32W = tagPROCESSENTRY32W;

type
  tagPROCESSENTRY32 = packed record
    dwSize: DWORD;
    cntUsage: DWORD;
    th32ProcessID: DWORD;       // this process
    th32DefaultHeapID: DWORD;
    th32ModuleID: DWORD;        // associated exe
    cntThreads: DWORD;
    th32ParentProcessID: DWORD; // this process's parent process
    pcPriClassBase: Longint;    // Base priority of process's threads
    dwFlags: DWORD;
    szExeFile: array[0..MAX_PATH - 1] of Char;// Path
  end;
  PROCESSENTRY32 = tagPROCESSENTRY32;
  PPROCESSENTRY32 = ^tagPROCESSENTRY32;
  LPPROCESSENTRY32 = ^tagPROCESSENTRY32;
  TProcessEntry32 = tagPROCESSENTRY32;

(***** Thread walking **************************************************)

type
  tagTHREADENTRY32 = record
    dwSize: DWORD;
    cntUsage: DWORD;
    th32ThreadID: DWORD;       // this thread
    th32OwnerProcessID: DWORD; // Process this thread is associated with
    tpBasePri: Longint;
    tpDeltaPri: Longint;
    dwFlags: DWORD;
  end;
  THREADENTRY32 = tagTHREADENTRY32;
  PTHREADENTRY32 = ^tagTHREADENTRY32;
  LPTHREADENTRY32 = ^tagTHREADENTRY32;
  TThreadEntry32 = tagTHREADENTRY32;

(***** Module walking *************************************************)

type
  tagMODULEENTRY32 = record
    dwSize: DWORD;
    th32ModuleID: DWORD;  // This module
    th32ProcessID: DWORD; // owning process
    GlblcntUsage: DWORD;  // Global usage count on the module
    ProccntUsage: DWORD;  // Module usage count in th32ProcessID's context
    modBaseAddr: PBYTE;   // Base address of module in th32ProcessID's context
    modBaseSize: DWORD;   // Size in bytes of module starting at modBaseAddr
    hModule: HMODULE;     // The hModule of this module in th32ProcessID's context
    szModule: array[0..MAX_MODULE_NAME32] of Char;
    szExePath: array[0..MAX_PATH - 1] of Char;
  end;
  MODULEENTRY32 = tagMODULEENTRY32;
  PMODULEENTRY32 = ^tagMODULEENTRY32;
  LPMODULEENTRY32 = ^tagMODULEENTRY32;
  TModuleEntry32 = tagMODULEENTRY32;

type
  tagMODULEENTRY32W = record
    dwSize: DWORD;
    th32ModuleID: DWORD;  // This module
    th32ProcessID: DWORD; // owning process
    GlblcntUsage: DWORD;  // Global usage count on the module
    ProccntUsage: DWORD;  // Module usage count in th32ProcessID's context
    modBaseAddr: PBYTE;   // Base address of module in th32ProcessID's context
    modBaseSize: DWORD;   // Size in bytes of module starting at modBaseAddr
    hModule: HMODULE;     // The hModule of this module in th32ProcessID's context
    szModule: array[0..MAX_MODULE_NAME32] of WChar;
    szExePath: array[0..MAX_PATH - 1] of WChar;
  end;
  MODULEENTRY32W = tagMODULEENTRY32W;
  PMODULEENTRY32W = ^tagMODULEENTRY32W;
  LPMODULEENTRY32W = ^tagMODULEENTRY32W;
  TModuleEntry32W = tagMODULEENTRY32W;

function CreateToolhelp32Snapshot conv arg_stdcall (dwFlags, th32ProcessID: DWORD): THandle;
  external kernel32dll name 'CreateToolhelp32Snapshot';

function Heap32ListFirst conv arg_stdcall (hSnapshot: THandle; var lphl: THeapList32): Boolean;
  external kernel32dll name 'Heap32ListFirst';

function Heap32ListNext conv arg_stdcall (hSnapshot: THandle; var lphl: THeapList32): Boolean;
  external kernel32dll name 'Heap32ListNext';

function Heap32First conv arg_stdcall (var lphe: THeapEntry32; th32ProcessID, th32HeapID: DWORD): Boolean;
  external kernel32dll name 'Heap32First';

function Heap32Next conv arg_stdcall (var lphe: THeapEntry32): Boolean;
  external kernel32dll name 'Heap32Next';

function Toolhelp32ReadProcessMemory conv arg_stdcall (th32ProcessID: DWORD; lpBaseAddress: Pointer;
  var lpBuffer; cbRead: DWORD; var lpNumberOfBytesRead: DWORD): Boolean;
  external kernel32dll name 'Toolhelp32ReadProcessMemory';

function Module32First conv arg_stdcall (hSnapshot: THandle; var lpme: TModuleEntry32): Boolean;
  external kernel32dll name 'Module32First';

function Module32FirstW conv arg_stdcall (hSnapshot: THandle; var lpme: TModuleEntry32W): Boolean;
  external kernel32dll name 'Module32FirstW';

function Module32Next conv arg_stdcall (hSnapshot: THandle; var lpme: TModuleEntry32): Boolean;
  external kernel32dll name 'Module32Next';

function Module32NextW conv arg_stdcall (hSnapshot: THandle; var lpme: TModuleEntry32W): Boolean;
  external kernel32dll name 'Module32NextW';

function Process32First conv arg_stdcall (hSnapshot: THandle; var lppe: TProcessEntry32): Boolean;
  external kernel32dll name 'Process32First';

function Process32FirstW conv arg_stdcall (hSnapshot: THandle; var lppe: TProcessEntry32W): Boolean;
  external kernel32dll name 'Process32FirstW';

function Process32Next conv arg_stdcall (hSnapshot: THandle; var lppe: TProcessEntry32): Boolean;
  external kernel32dll name 'Process32Next';

function Process32NextW conv arg_stdcall (hSnapshot: THandle; var lppe: TProcessEntry32W): Boolean;
  external kernel32dll name 'Process32NextW';

function Thread32First conv arg_stdcall (hSnapshot: THandle; var lpte: TThreadEntry32): Boolean;
  external kernel32dll name 'Thread32First';

function Thread32Next conv arg_stdcall (hSnapshot: THandle; var lpte: TThreadENtry32): Boolean;
  external kernel32dll name 'Thread32Next';

implementation

(* nothing to implement *)

end.
