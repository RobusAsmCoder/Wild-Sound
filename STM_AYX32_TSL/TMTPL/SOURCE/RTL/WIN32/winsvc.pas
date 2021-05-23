(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit service API interface unit               *)
(*       Based on winsvc.h                                      *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit WinSVC;

interface

(*++ BUILD Version: 0010    // Increment this if a change has global effects
Copyright 1995 - 1998 Microsoft Corporation

Module Name:
    winsvc.h

Abstract:
    Header file for the Service Control Manager

Environment:
    User Mode - Win32
--*)

uses Windows;

const
  advapi32dll = 'advapi32.dll';

//
// Service database names
//
  SERVICES_ACTIVE_DATABASEA     = 'ServicesActive';
  SERVICES_ACTIVE_DATABASEW     = 'ServicesActive';
  SERVICES_ACTIVE_DATABASE = SERVICES_ACTIVE_DATABASEA;
  SERVICES_FAILED_DATABASEA     = 'ServicesFailed';
  SERVICES_FAILED_DATABASEW     = 'ServicesFailed';
  SERVICES_FAILED_DATABASE = SERVICES_FAILED_DATABASEA;

//
// Character to designate that a name is a group
//
  SC_GROUP_IDENTIFIERA          = '+';
  SC_GROUP_IDENTIFIERW          = '+';
  SC_GROUP_IDENTIFIER = SC_GROUP_IDENTIFIERA;

//
// Value to indicate no change to an optional parameter
//
  SERVICE_NO_CHANGE              = $FFFFFFFF;

//
// Service State -- for Enum Requests (Bit Mask)
//
  SERVICE_ACTIVE                 = $00000001;
  SERVICE_INACTIVE               = $00000002;
  SERVICE_STATE_ALL              = (SERVICE_ACTIVE or SERVICE_INACTIVE);

//
// Controls
//
  SERVICE_CONTROL_STOP           = $00000001;
  SERVICE_CONTROL_PAUSE          = $00000002;
  SERVICE_CONTROL_CONTINUE       = $00000003;
  SERVICE_CONTROL_INTERROGATE    = $00000004;
  SERVICE_CONTROL_SHUTDOWN       = $00000005;

//
// Service State -- for CurrentState
//
  SERVICE_STOPPED                = $00000001;
  SERVICE_START_PENDING          = $00000002;
  SERVICE_STOP_PENDING           = $00000003;
  SERVICE_RUNNING                = $00000004;
  SERVICE_CONTINUE_PENDING       = $00000005;
  SERVICE_PAUSE_PENDING          = $00000006;
  SERVICE_PAUSED                 = $00000007;

//
// Controls Accepted  (Bit Mask)
//
  SERVICE_ACCEPT_STOP            = $00000001;
  SERVICE_ACCEPT_PAUSE_CONTINUE  = $00000002;
  SERVICE_ACCEPT_SHUTDOWN        = $00000004;

//
// Service Control Manager object specific access types
//
  SC_MANAGER_CONNECT             = $0001;
  SC_MANAGER_CREATE_SERVICE      = $0002;
  SC_MANAGER_ENUMERATE_SERVICE   = $0004;
  SC_MANAGER_LOCK                = $0008;
  SC_MANAGER_QUERY_LOCK_STATUS   = $0010;
  SC_MANAGER_MODIFY_BOOT_CONFIG  = $0020;
  SC_MANAGER_ALL_ACCESS          = (STANDARD_RIGHTS_REQUIRED or
                                    SC_MANAGER_CONNECT or
                                    SC_MANAGER_CREATE_SERVICE or
                                    SC_MANAGER_ENUMERATE_SERVICE or
                                    SC_MANAGER_LOCK or
                                    SC_MANAGER_QUERY_LOCK_STATUS or
                                    SC_MANAGER_MODIFY_BOOT_CONFIG);
//
// Service object specific access type
//
  SERVICE_QUERY_CONFIG           = $0001;
  SERVICE_CHANGE_CONFIG          = $0002;
  SERVICE_QUERY_STATUS           = $0004;
  SERVICE_ENUMERATE_DEPENDENTS   = $0008;
  SERVICE_START                  = $0010;
  SERVICE_STOP                   = $0020;
  SERVICE_PAUSE_CONTINUE         = $0040;
  SERVICE_INTERROGATE            = $0080;
  SERVICE_USER_DEFINED_CONTROL   = $0100;
  SERVICE_ALL_ACCESS             = (STANDARD_RIGHTS_REQUIRED or
                                    SERVICE_QUERY_CONFIG or
                                    SERVICE_CHANGE_CONFIG or
                                    SERVICE_QUERY_STATUS or
                                    SERVICE_ENUMERATE_DEPENDENTS or
                                    SERVICE_START or
                                    SERVICE_STOP or
                                    SERVICE_PAUSE_CONTINUE or
                                    SERVICE_INTERROGATE or
                                    SERVICE_USER_DEFINED_CONTROL);

//
// Service Types (Bit Mask)
//
  SERVICE_KERNEL_DRIVER         = $00000001;
  SERVICE_FILE_SYSTEM_DRIVER    = $00000002;
  SERVICE_ADAPTER               = $00000004;
  SERVICE_RECOGNIZER_DRIVER     = $00000008;
  SERVICE_DRIVER                = (SERVICE_KERNEL_DRIVER or
                                   SERVICE_FILE_SYSTEM_DRIVER or
                                   SERVICE_RECOGNIZER_DRIVER);
  SERVICE_WIN32_OWN_PROCESS     = $00000010;
  SERVICE_WIN32_SHARE_PROCESS   = $00000020;
  SERVICE_WIN32                 = (SERVICE_WIN32_OWN_PROCESS or
                                   SERVICE_WIN32_SHARE_PROCESS);
  SERVICE_INTERACTIVE_PROCESS   = $00000100;
  SERVICE_TYPE_ALL              = (SERVICE_WIN32 or
                                  SERVICE_ADAPTER or
                                  SERVICE_DRIVER or
                                  SERVICE_INTERACTIVE_PROCESS);
//
// Start Type
//
  SERVICE_BOOT_START            = $00000000;
  SERVICE_SYSTEM_START          = $00000001;
  SERVICE_AUTO_START            = $00000002;
  SERVICE_DEMAND_START          = $00000003;
  SERVICE_DISABLED              = $00000004;

//
// Error control type
//
  SERVICE_ERROR_IGNORE          = $00000000;
  SERVICE_ERROR_NORMAL          = $00000001;
  SERVICE_ERROR_SEVERE          = $00000002;
  SERVICE_ERROR_CRITICAL        = $00000003;

type

//
// Handle Types
//
  SC_HANDLE = THandle;
  LPSC_HANDLE = ^SC_HANDLE;
  SERVICE_STATUS_HANDLE = DWORD;

//
// pointer to string pointer
//
  PLPSTRA = ^PAnsiChar;
  PLPWSTRW = ^PWideChar;
  PLPSTR = PLPSTRA;

//
// Service Status Structure
//
  PServiceStatus = ^TServiceStatus;
  _SERVICE_STATUS = record
    dwServiceType: DWORD;
    dwCurrentState: DWORD;
    dwControlsAccepted: DWORD;
    dwWin32ExitCode: DWORD;
    dwServiceSpecificExitCode: DWORD;
    dwCheckPoint: DWORD;
    dwWaitHint: DWORD;
  end;
  SERVICE_STATUS = _SERVICE_STATUS;
  TServiceStatus = _SERVICE_STATUS;

//
// Service Status Enumeration Structure
//
  PEnumServiceStatusA = ^TEnumServiceStatusA;
  PEnumServiceStatusW = ^TEnumServiceStatusW;
  PEnumServiceStatus = PEnumServiceStatusA;
  _ENUM_SERVICE_STATUSA = record
    lpServiceName: PAnsiChar;
    lpDisplayName: PAnsiChar;
    ServiceStatus: TServiceStatus;
  end;
  ENUM_SERVICE_STATUSA = _ENUM_SERVICE_STATUSA;
  _ENUM_SERVICE_STATUSW = record
    lpServiceName: PWideChar;
    lpDisplayName: PWideChar;
    ServiceStatus: TServiceStatus;
  end;
  ENUM_SERVICE_STATUSW = _ENUM_SERVICE_STATUSW;
  _ENUM_SERVICE_STATUS = _ENUM_SERVICE_STATUSA;
  TEnumServiceStatusA = _ENUM_SERVICE_STATUSA;
  TEnumServiceStatusW = _ENUM_SERVICE_STATUSW;
  TEnumServiceStatus = TEnumServiceStatusA;

//
// Structures for the Lock API functions
//
  SC_LOCK = Pointer;
  PQueryServiceLockStatusA = ^TQueryServiceLockStatusA;
  PQueryServiceLockStatusW = ^TQueryServiceLockStatusW;
  PQueryServiceLockStatus = PQueryServiceLockStatusA;
  _QUERY_SERVICE_LOCK_STATUSA = record
    fIsLocked: DWORD;
    lpLockOwner: PAnsiChar;
    dwLockDuration: DWORD;
  end;
  _QUERY_SERVICE_LOCK_STATUSW = record
    fIsLocked: DWORD;
    lpLockOwner: PWideChar;
    dwLockDuration: DWORD;
  end;
  _QUERY_SERVICE_LOCK_STATUS = _QUERY_SERVICE_LOCK_STATUSA;
  QUERY_SERVICE_LOCK_STATUSA = _QUERY_SERVICE_LOCK_STATUSA;
  QUERY_SERVICE_LOCK_STATUSW = _QUERY_SERVICE_LOCK_STATUSW;
  QUERY_SERVICE_LOCK_STATUS = QUERY_SERVICE_LOCK_STATUSA;
  TQueryServiceLockStatusA = _QUERY_SERVICE_LOCK_STATUSA;
  TQueryServiceLockStatusW = _QUERY_SERVICE_LOCK_STATUSW;
  TQueryServiceLockStatus = TQueryServiceLockStatusA;

//
// Query Service Configuration Structure
//
  PQueryServiceConfigA = ^TQueryServiceConfigA;
  PQueryServiceConfigW = ^TQueryServiceConfigW;
  PQueryServiceConfig = PQueryServiceConfigA;
   _QUERY_SERVICE_CONFIGA = record
    dwServiceType: DWORD;
    dwStartType: DWORD;
    dwErrorControl: DWORD;
    lpBinaryPathName: PAnsiChar;
    lpLoadOrderGroup: PAnsiChar;
    dwTagId: DWORD;
    lpDependencies: PAnsiChar;
    lpServiceStartName: PAnsiChar;
    lpDisplayName: PAnsiChar;
  end;
   _QUERY_SERVICE_CONFIGW = record
    dwServiceType: DWORD;
    dwStartType: DWORD;
    dwErrorControl: DWORD;
    lpBinaryPathName: PWideChar;
    lpLoadOrderGroup: PWideChar;
    dwTagId: DWORD;
    lpDependencies: PWideChar;
    lpServiceStartName: PWideChar;
    lpDisplayName: PWideChar;
  end;
  _QUERY_SERVICE_CONFIG = _QUERY_SERVICE_CONFIGA;
  QUERY_SERVICE_CONFIGA = _QUERY_SERVICE_CONFIGA;
  QUERY_SERVICE_CONFIGW = _QUERY_SERVICE_CONFIGW;
  QUERY_SERVICE_CONFIG = QUERY_SERVICE_CONFIGA;
  TQueryServiceConfigA = _QUERY_SERVICE_CONFIGA;
  TQueryServiceConfigW = _QUERY_SERVICE_CONFIGW;
  TQueryServiceConfig = TQueryServiceConfigA;

//
// Function Prototype for the Service Main Function
//
  LPSERVICE_MAIN_FUNCTIONA = TFarProc;
  LPSERVICE_MAIN_FUNCTIONW = TFarProc;
  LPSERVICE_MAIN_FUNCTION = LPSERVICE_MAIN_FUNCTIONA;
  TServiceMainFunctionA = LPSERVICE_MAIN_FUNCTIONA;
  TServiceMainFunctionW = LPSERVICE_MAIN_FUNCTIONW;
  TServiceMainFunction = TServiceMainFunctionA;

//
// Service Start Table
//
  PServiceTableEntryA = ^TServiceTableEntryA;
  PServiceTableEntryW = ^TServiceTableEntryW;
  PServiceTableEntry = PServiceTableEntryA;
  _SERVICE_TABLE_ENTRYA = record
    lpServiceName: PAnsiChar;
    lpServiceProc: TServiceMainFunctionA;
  end;
  _SERVICE_TABLE_ENTRYW = record
    lpServiceName: PWideChar;
    lpServiceProc: TServiceMainFunctionW;
  end;
  _SERVICE_TABLE_ENTRY = _SERVICE_TABLE_ENTRYA;
  SERVICE_TABLE_ENTRYA = _SERVICE_TABLE_ENTRYA;
  SERVICE_TABLE_ENTRYW = _SERVICE_TABLE_ENTRYW;
  SERVICE_TABLE_ENTRY = SERVICE_TABLE_ENTRYA;
  TServiceTableEntryA = _SERVICE_TABLE_ENTRYA;
  TServiceTableEntryW = _SERVICE_TABLE_ENTRYW;
  TServiceTableEntry = TServiceTableEntryA;

//
// Prototype for the Service Control Handler Function
//
  LPHANDLER_FUNCTION = TFarProc;
  THandlerFunction = LPHANDLER_FUNCTION;

///////////////////////////////////////////////////////////////////////////
// API Function Prototypes
///////////////////////////////////////////////////////////////////////////
function ChangeServiceConfigA conv arg_stdcall (hService: SC_HANDLE; dwServiceType, dwStartType,
  dwErrorControl: DWORD; lpBinaryPathName, lpLoadOrderGroup: PAnsiChar;
  lpdwTagId: LPDWORD; lpDependencies, lpServiceStartName, lpPassword,
  lpDisplayName: PAnsiChar): BOOL;
  external advapi32dll name 'ChangeServiceConfigA';

function ChangeServiceConfigW conv arg_stdcall (hService: SC_HANDLE; dwServiceType, dwStartType,
  dwErrorControl: DWORD; lpBinaryPathName, lpLoadOrderGroup: PWideChar;
  lpdwTagId: LPDWORD; lpDependencies, lpServiceStartName, lpPassword,
  lpDisplayName: PWideChar): BOOL;
  external advapi32dll name 'ChangeServiceConfigW';

function ChangeServiceConfig conv arg_stdcall (hService: SC_HANDLE; dwServiceType, dwStartType,
  dwErrorControl: DWORD; lpBinaryPathName, lpLoadOrderGroup: PChar;
  lpdwTagId: LPDWORD; lpDependencies, lpServiceStartName, lpPassword,
  lpDisplayName: PChar): BOOL;
  external advapi32dll name 'ChangeServiceConfigA';

function CloseServiceHandle conv arg_stdcall (hSCObject: SC_HANDLE): BOOL;
  external advapi32dll name 'CloseServiceHandle';

function ControlService conv arg_stdcall (hService: SC_HANDLE; dwControl: DWORD;
  var lpServiceStatus: TServiceStatus): BOOL;
  external advapi32dll name 'ControlService';

function CreateServiceA conv arg_stdcall (hSCManager: SC_HANDLE; lpServiceName, lpDisplayName: PAnsiChar;
  dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl: DWORD;
  lpBinaryPathName, lpLoadOrderGroup: PAnsiChar; lpdwTagId: LPDWORD; lpDependencies,
  lpServiceStartName, lpPassword: PAnsiChar): SC_HANDLE;
  external advapi32dll name 'CreateServiceA';

function CreateServiceW conv arg_stdcall (hSCManager: SC_HANDLE; lpServiceName, lpDisplayName: PWideChar;
  dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl: DWORD;
  lpBinaryPathName, lpLoadOrderGroup: PWideChar; lpdwTagId: LPDWORD; lpDependencies,
  lpServiceStartName, lpPassword: PWideChar): SC_HANDLE;
  external advapi32dll name 'CreateServiceW';

function CreateService conv arg_stdcall (hSCManager: SC_HANDLE; lpServiceName, lpDisplayName: PChar;
  dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl: DWORD;
  lpBinaryPathName, lpLoadOrderGroup: PChar; lpdwTagId: LPDWORD; lpDependencies,
  lpServiceStartName, lpPassword: PChar): SC_HANDLE;
  external advapi32dll name 'CreateServiceA';

function DeleteService conv arg_stdcall (hService: SC_HANDLE): BOOL;
  external advapi32dll name 'DeleteService';

function EnumDependentServicesA conv arg_stdcall (hService: SC_HANDLE; dwServiceState: DWORD;
  var lpServices: TEnumServiceStatusA; cbBufSize: DWORD; var pcbBytesNeeded,
  lpServicesReturned : DWORD): BOOL;
  external advapi32dll name 'EnumDependentServicesA';

function EnumDependentServicesW conv arg_stdcall (hService: SC_HANDLE; dwServiceState: DWORD;
  var lpServices: TEnumServiceStatusW; cbBufSize: DWORD; var pcbBytesNeeded,
  lpServicesReturned : DWORD): BOOL;
  external advapi32dll name 'EnumDependentServicesW';

function EnumDependentServices conv arg_stdcall (hService: SC_HANDLE; dwServiceState: DWORD;
  var lpServices: TEnumServiceStatus; cbBufSize: DWORD; var pcbBytesNeeded,
  lpServicesReturned : DWORD): BOOL;
  external advapi32dll name 'EnumDependentServicesA';

function EnumServicesStatusA conv arg_stdcall (hSCManager: SC_HANDLE; dwServiceType,
  dwServiceState: DWORD; var lpServices: TEnumServiceStatusA; cbBufSize: DWORD;
  var pcbBytesNeeded, lpServicesReturned, lpResumeHandle: DWORD): BOOL;
  external advapi32dll name 'EnumServicesStatusA';

function EnumServicesStatusW conv arg_stdcall (hSCManager: SC_HANDLE; dwServiceType,
  dwServiceState: DWORD; var lpServices: TEnumServiceStatusW; cbBufSize: DWORD;
  var pcbBytesNeeded, lpServicesReturned, lpResumeHandle: DWORD): BOOL;
  external advapi32dll name 'EnumServicesStatusW';

function EnumServicesStatus conv arg_stdcall (hSCManager: SC_HANDLE; dwServiceType,
  dwServiceState: DWORD; var lpServices: TEnumServiceStatus; cbBufSize: DWORD;
  var pcbBytesNeeded, lpServicesReturned, lpResumeHandle: DWORD): BOOL;
  external advapi32dll name 'EnumServicesStatusA';

function GetServiceKeyNameA conv arg_stdcall (hSCManager: SC_HANDLE; lpDisplayName,
  lpServiceName: PAnsiChar; var lpcchBuffer: DWORD): BOOL;
  external advapi32dll name 'GetServiceKeyNameA';

function GetServiceKeyNameW conv arg_stdcall (hSCManager: SC_HANDLE; lpDisplayName,
  lpServiceName: PWideChar; var lpcchBuffer: DWORD): BOOL;
  external advapi32dll name 'GetServiceKeyNameW';

function GetServiceKeyName conv arg_stdcall (hSCManager: SC_HANDLE; lpDisplayName,
  lpServiceName: PChar; var lpcchBuffer: DWORD): BOOL;
  external advapi32dll name 'GetServiceKeyNameA';

function GetServiceDisplayNameA conv arg_stdcall (hSCManager: SC_HANDLE; lpServiceName,
  lpDisplayName: PAnsiChar; var lpcchBuffer: DWORD): BOOL;
  external advapi32dll name 'GetServiceDisplayNameA';

function GetServiceDisplayNameW conv arg_stdcall (hSCManager: SC_HANDLE; lpServiceName,
  lpDisplayName: PWideChar; var lpcchBuffer: DWORD): BOOL;
  external advapi32dll name 'GetServiceDisplayNameW';

function GetServiceDisplayName conv arg_stdcall (hSCManager: SC_HANDLE; lpServiceName,
  lpDisplayName: PChar; var lpcchBuffer: DWORD): BOOL;
  external advapi32dll name 'GetServiceDisplayNameA';

function LockServiceDatabase conv arg_stdcall (hSCManager: SC_HANDLE): SC_LOCK;
  external advapi32dll name 'LockServiceDatabase';

function NotifyBootConfigStatus conv arg_stdcall (BootAcceptable: BOOL): BOOL;
  external advapi32dll name 'NotifyBootConfigStatus';

function OpenSCManagerA conv arg_stdcall (lpMachineName, lpDatabaseName: PAnsiChar;
  dwDesiredAccess: DWORD): SC_HANDLE;
  external advapi32dll name 'OpenSCManagerA';

function OpenSCManagerW conv arg_stdcall (lpMachineName, lpDatabaseName: PWideChar;
  dwDesiredAccess: DWORD): SC_HANDLE;
  external advapi32dll name 'OpenSCManagerW';

function OpenSCManager conv arg_stdcall (lpMachineName, lpDatabaseName: PChar;
  dwDesiredAccess: DWORD): SC_HANDLE;
  external advapi32dll name 'OpenSCManagerA';

function OpenServiceA conv arg_stdcall (hSCManager: SC_HANDLE; lpServiceName: PAnsiChar;
  dwDesiredAccess: DWORD): SC_HANDLE;
  external advapi32dll name 'OpenServiceA';

function OpenServiceW conv arg_stdcall (hSCManager: SC_HANDLE; lpServiceName: PWideChar;
  dwDesiredAccess: DWORD): SC_HANDLE;
  external advapi32dll name 'OpenServiceW';

function OpenService conv arg_stdcall (hSCManager: SC_HANDLE; lpServiceName: PChar;
  dwDesiredAccess: DWORD): SC_HANDLE;
  external advapi32dll name 'OpenServiceA';

function QueryServiceConfigA conv arg_stdcall (hService: SC_HANDLE;
  lpServiceConfig: PQueryServiceConfigA; cbBufSize: DWORD;
  var pcbBytesNeeded: DWORD): BOOL;
  external advapi32dll name 'QueryServiceConfigA';

function QueryServiceConfigW conv arg_stdcall (hService: SC_HANDLE;
  lpServiceConfig: PQueryServiceConfigW; cbBufSize: DWORD;
  var pcbBytesNeeded: DWORD): BOOL;
  external advapi32dll name 'QueryServiceConfigW';

function QueryServiceConfig conv arg_stdcall (hService: SC_HANDLE;
  lpServiceConfig: PQueryServiceConfig; cbBufSize: DWORD;
  var pcbBytesNeeded: DWORD): BOOL;
  external advapi32dll name 'QueryServiceConfigA';

function QueryServiceLockStatusA conv arg_stdcall (hSCManager: SC_HANDLE;
  var lpLockStatus: TQueryServiceLockStatusA; cbBufSize: DWORD;
  var pcbBytesNeeded: DWORD): BOOL;
  external advapi32dll name 'QueryServiceLockStatusA';

function QueryServiceLockStatusW conv arg_stdcall (hSCManager: SC_HANDLE;
  var lpLockStatus: TQueryServiceLockStatusW; cbBufSize: DWORD;
  var pcbBytesNeeded: DWORD): BOOL;
  external advapi32dll name 'QueryServiceLockStatusW';

function QueryServiceLockStatus conv arg_stdcall (hSCManager: SC_HANDLE;
  var lpLockStatus: TQueryServiceLockStatus; cbBufSize: DWORD;
  var pcbBytesNeeded: DWORD): BOOL;
  external advapi32dll name 'QueryServiceLockStatusA';

function QueryServiceObjectSecurity conv arg_stdcall (hService: SC_HANDLE;
  dwSecurityInformation: SECURITY_INFORMATION;
  lpSecurityDescriptor: PSECURITY_DESCRIPTOR; cbBufSize: DWORD;
  var pcbBytesNeeded: DWORD): BOOL;
  external advapi32dll name 'QueryServiceObjectSecurity';

function QueryServiceStatus conv arg_stdcall (hService: SC_HANDLE; var
  lpServiceStatus: TServiceStatus): BOOL;
  external advapi32dll name 'QueryServiceStatus';

function RegisterServiceCtrlHandlerA conv arg_stdcall (lpServiceName: PAnsiChar;
  lpHandlerProc: ThandlerFunction): SERVICE_STATUS_HANDLE;
  external advapi32dll name 'RegisterServiceCtrlHandlerA';

function RegisterServiceCtrlHandlerW conv arg_stdcall (lpServiceName: PWideChar;
  lpHandlerProc: ThandlerFunction): SERVICE_STATUS_HANDLE;
  external advapi32dll name 'RegisterServiceCtrlHandlerW';

function RegisterServiceCtrlHandler conv arg_stdcall (lpServiceName: PChar;
  lpHandlerProc: ThandlerFunction): SERVICE_STATUS_HANDLE;
  external advapi32dll name 'RegisterServiceCtrlHandlerA';

function SetServiceObjectSecurity conv arg_stdcall (hService: SC_HANDLE;
  dwSecurityInformation: SECURITY_INFORMATION;
  lpSecurityDescriptor: PSECURITY_DESCRIPTOR): BOOL;
  external advapi32dll name 'SetServiceObjectSecurity';

function SetServiceStatus conv arg_stdcall (hServiceStatus: SERVICE_STATUS_HANDLE;
  var lpServiceStatus: TServiceStatus): BOOL;
  external advapi32dll name 'SetServiceStatus';

function StartServiceCtrlDispatcherA conv arg_stdcall (
  var lpServiceStartTable: TServiceTableEntryA): BOOL;
  external advapi32dll name 'StartServiceCtrlDispatcherA';

function StartServiceCtrlDispatcherW conv arg_stdcall (
  var lpServiceStartTable: TServiceTableEntryW): BOOL;
  external advapi32dll name 'StartServiceCtrlDispatcherW';

function StartServiceCtrlDispatcher conv arg_stdcall (
  var lpServiceStartTable: TServiceTableEntry): BOOL;
  external advapi32dll name 'StartServiceCtrlDispatcherA';

function StartServiceA conv arg_stdcall (hService: SC_HANDLE; dwNumServiceArgs: DWORD;
  var lpServiceArgVectors: PAnsiChar): BOOL;
  external advapi32dll name 'StartServiceA';

function StartServiceW conv arg_stdcall (hService: SC_HANDLE; dwNumServiceArgs: DWORD;
  var lpServiceArgVectors: PWideChar): BOOL;
  external advapi32dll name 'StartServiceW';

function StartService conv arg_stdcall (hService: SC_HANDLE; dwNumServiceArgs: DWORD;
  var lpServiceArgVectors: PChar): BOOL;
  external advapi32dll name 'StartServiceA';

function UnlockServiceDatabase conv arg_stdcall (ScLock: SC_LOCK): BOOL;
  external advapi32dll name 'UnlockServiceDatabase';

implementation

begin
  (* Nothing to implement *)
end.