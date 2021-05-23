(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit New style Win32 Access Control API       *)
(*       Based on accctrl.h                                     *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit AccCtrl;

//+-------------------------------------------------------------------
//
//  Microsoft Windows
//  Copyright (C) Microsoft Corporation, 1993-1997.
//
//  File:       accctrl.h
//
//  Contents:   common includes for new style Win32 Access Control
//              APIs
//
//
//--------------------------------------------------------------------

interface

uses
  Windows;

type
  TRUSTEE_TYPE = (
    TRUSTEE_IS_UNKNOWN,
    TRUSTEE_IS_USER,
    TRUSTEE_IS_GROUP,
    TRUSTEE_IS_DOMAIN,
    TRUSTEE_IS_ALIAS,
    TRUSTEE_IS_WELL_KNOWN_GROUP,
    TRUSTEE_IS_DELETED,
    TRUSTEE_IS_INVALID
  );

  TRUSTEE_FORM = (
    TRUSTEE_IS_SID,
    TRUSTEE_IS_NAME,
    TRUSTEE_BAD_FORM
  );

  MULTIPLE_TRUSTEE_OPERATION = (
    NO_MULTIPLE_TRUSTEE,
    TRUSTEE_IS_IMPERSONATE
  );

  P_TRUSTEE_A = ^_TRUSTEE_A;
  _TRUSTEE_A = packed record
    pMultipleTrustee: P_TRUSTEE_A;
    MultipleTrusteeOperation: MULTIPLE_TRUSTEE_OPERATION;
    TrusteeForm: TRUSTEE_FORM;
    TrusteeType: TRUSTEE_TYPE;
    ptstrName: PAnsiChar;
  end;
  P_TRUSTEE_W = ^_TRUSTEE_W;
  _TRUSTEE_W = packed record
    pMultipleTrustee: P_TRUSTEE_W;
    MultipleTrusteeOperation: MULTIPLE_TRUSTEE_OPERATION;
    TrusteeForm: TRUSTEE_FORM;
    TrusteeType: TRUSTEE_TYPE;
    ptstrName: PAnsiChar;
  end;
  P_TRUSTEE_ = P_TRUSTEE_A;
  TRUSTEEA = _TRUSTEE_A;
  TRUSTEEW = _TRUSTEE_W;
  TRUSTEE = TRUSTEEA;
  PTRUSTEEA = ^TRUSTEEA;
  PTRUSTEEW = ^TRUSTEEW;
  PTRUSTEE = PTRUSTEEA;
  TRUSTEE_A = TRUSTEEA;
  TRUSTEE_W = TRUSTEEW;
  TRUSTEE_ = TRUSTEE_A;
  PTRUSTEE_A = PTRUSTEEA;
  PTRUSTEE_W = PTRUSTEEW;
  PTRUSTEE_ = PTRUSTEE_A;

  ACCESS_MODE = (
    NOT_USED_ACCESS,
    GRANT_ACCESS,
    SET_ACCESS,
    DENY_ACCESS,
    REVOKE_ACCESS,
    SET_AUDIT_SUCCESS,
    SET_AUDIT_FAILURE
  );

  SE_OBJECT_TYPE = (
    SE_UNKNOWN_OBJECT_TYPE,
    SE_FILE_OBJECT,
    SE_SERVICE,
    SE_PRINTER,
    SE_REGISTRY_KEY,
    SE_LMSHARE,
    SE_KERNEL_OBJECT,
    SE_WINDOW_OBJECT,
    SE_DS_OBJECT,
    SE_DS_OBJECT_ALL,
    SE_PROVIDER_DEFINED_OBJECT,
    SE_WMIGUID_OBJECT
  );

  PEXPLICIT_ACCESS_A = ^EXPLICIT_ACCESS_A;
  EXPLICIT_ACCESS_A = packed record
    grfAccessPermissions: DWORD;
    grfAccessMode: ACCESS_MODE;
    grfInheritance: DWORD;
    Trustee: TRUSTEE_A;
  end;
  PEXPLICIT_ACCESS_W = ^EXPLICIT_ACCESS_W;
  EXPLICIT_ACCESS_W = packed record
    grfAccessPermissions: DWORD;
    grfAccessMode: ACCESS_MODE;
    grfInheritance: DWORD;
    Trustee: TRUSTEE_W;
  end;
  PEXPLICIT_ACCESS_ = PEXPLICIT_ACCESS_A;
  EXPLICIT_ACCESSA = EXPLICIT_ACCESS_A;
  EXPLICIT_ACCESSW = EXPLICIT_ACCESS_W;
  EXPLICIT_ACCESS = EXPLICIT_ACCESSA;
  PEXPLICIT_ACCESSA = ^EXPLICIT_ACCESS_A;
  PEXPLICIT_ACCESSW = ^EXPLICIT_ACCESS_W;
  PEXPLICIT_ACCESS = PEXPLICIT_ACCESSA;

  ACCESS_RIGHTS = ULONG;
  PACCESS_RIGHTS = ^ACCESS_RIGHTS;
  INHERIT_FLAGS = ULONG;
  PINHERIT_FLAGS = ^INHERIT_FLAGS;
  PACTRL_ACCESS_ENTRYA = ^ACTRL_ACCESS_ENTRYA;

  ACTRL_ACCESS_ENTRYA = packed record
    Trustee: TRUSTEE_A;
    fAccessFlags: ULONG;
    Access: ACCESS_RIGHTS;
    ProvSpecificAccess: ACCESS_RIGHTS;
    Inheritance: INHERIT_FLAGS;
    lpInheritProperty: PAnsiChar;
  end;
  PACTRL_ACCESS_ENTRYW = ^ACTRL_ACCESS_ENTRYW;
  ACTRL_ACCESS_ENTRYW = packed record
    Trustee: TRUSTEE_W;
    fAccessFlags: ULONG;
    Access: ACCESS_RIGHTS;
    ProvSpecificAccess: ACCESS_RIGHTS;
    Inheritance: INHERIT_FLAGS;
    lpInheritProperty: PAnsiChar;
  end;
  PACTRL_ACCESS_ENTRY = PACTRL_ACCESS_ENTRYA;

  PACTRL_ACCESS_ENTRY_LISTA = ^ACTRL_ACCESS_ENTRY_LISTA;
  ACTRL_ACCESS_ENTRY_LISTA = packed record
    cEntries: ULONG;
    pAccessList: ^ACTRL_ACCESS_ENTRYA;
  end;
  PACTRL_ACCESS_ENTRY_LISTW = ^ACTRL_ACCESS_ENTRY_LISTW;
  ACTRL_ACCESS_ENTRY_LISTW = packed record
    cEntries: ULONG;
    pAccessList: ^ACTRL_ACCESS_ENTRYW;
  end;
  PACTRL_ACCESS_ENTRY_LIST = PACTRL_ACCESS_ENTRY_LISTA;

  PACTRL_PROPERTY_ENTRYA = ^ACTRL_PROPERTY_ENTRYA;
  ACTRL_PROPERTY_ENTRYA = packed record
    lpProperty: PAnsiChar;
    pAccessEntryList: PACTRL_ACCESS_ENTRY_LISTA;
    fListFlags: ULONG;
  end;
  PACTRL_PROPERTY_ENTRYW = ^ACTRL_PROPERTY_ENTRYW;
  ACTRL_PROPERTY_ENTRYW = packed record
    lpProperty: PAnsiChar;
    pAccessEntryList: PACTRL_ACCESS_ENTRY_LISTW;
    fListFlags: ULONG;
  end;
  PACTRL_PROPERTY_ENTRY = PACTRL_PROPERTY_ENTRYA;

  PACTRL_ACCESSA = ^ACTRL_ACCESSA;
  ACTRL_ACCESSA = packed record
    cEntries: ULONG;
    pPropertyAccessList: PACTRL_PROPERTY_ENTRYA;
  end;
  PACTRL_ACCESSW = ^ACTRL_ACCESSW;
  ACTRL_ACCESSW = packed record
    cEntries: ULONG;
    pPropertyAccessList: PACTRL_PROPERTY_ENTRYW;
  end;
  PACTRL_ACCESS = PACTRL_ACCESSA;
  PPACTRL_ACCESSA = ^PACTRL_ACCESSA;
  PPACTRL_ACCESSW = ^PACTRL_ACCESSW;
  PPACTRL_ACCESS = PPACTRL_ACCESSA;
  ACTRL_AUDITA = ACTRL_ACCESSA;
  ACTRL_AUDITW = ACTRL_ACCESSW;
  ACTRL_AUDIT = ACTRL_AUDITA;
  PACTRL_AUDITA = ^ACTRL_AUDITA;
  PACTRL_AUDITW = ^ACTRL_AUDITW;
  PACTRL_AUDIT = PACTRL_AUDITA;
  PPACTRL_AUDITA = ^PACTRL_AUDITA;
  PPACTRL_AUDITW = ^PACTRL_AUDITW;
  PPACTRL_AUDIT = PPACTRL_AUDITA;

  PTRUSTEE_ACCESSA = ^TRUSTEE_ACCESSA;
  TRUSTEE_ACCESSA = packed record
    lpProperty: PAnsiChar;
    Access: ACCESS_RIGHTS;
    fAccessFlags: ULONG;
    fReturnedAccess: ULONG;
  end;
  PTRUSTEE_ACCESSW = ^TRUSTEE_ACCESSW;
  TRUSTEE_ACCESSW = packed record
    lpProperty: PAnsiChar;
    Access: ACCESS_RIGHTS;
    fAccessFlags: ULONG;
    fReturnedAccess: ULONG;
  end;
  PTRUSTEE_ACCESS = PTRUSTEE_ACCESSA;

  PACTRL_OVERLAPPED = ^ACTRL_OVERLAPPED;
  ACTRL_OVERLAPPED = packed record
    case Longint of
      0: (Provider: Pointer; Rsrvd2: ULONG; hEvnt: THandle);
      1: (Reserved1: ULONG; Reserved2: ULONG; hEvent: THandle);
  end;

  PACTRL_ACCESS_INFOA = ^ACTRL_ACCESS_INFOA;
  ACTRL_ACCESS_INFOA = packed record
    fAccessPermission: ULONG;
    lpAccessPermissionName: PAnsiChar;
  end;
  PACTRL_ACCESS_INFOW = ^ACTRL_ACCESS_INFOW;
  ACTRL_ACCESS_INFOW = packed record
    fAccessPermission: ULONG;
    lpAccessPermissionName: PAnsiChar;
  end;
  PACTRL_ACCESS_INFO = PACTRL_ACCESS_INFOA;
  PPACTRL_ACCESS_INFOA = ^PACTRL_ACCESS_INFOA;
  PPACTRL_ACCESS_INFOW = ^PACTRL_ACCESS_INFOW;
  PPACTRL_ACCESS_INFO = PPACTRL_ACCESS_INFOA;

  PACTRL_CONTROL_INFOA = ^ACTRL_CONTROL_INFOA;
  ACTRL_CONTROL_INFOA = packed record
    lpControlId: PAnsiChar;
    lpControlName: PAnsiChar;
  end;
  PACTRL_CONTROL_INFOW = ^ACTRL_CONTROL_INFOW;
  ACTRL_CONTROL_INFOW = packed record
    lpControlId: PAnsiChar;
    lpControlName: PAnsiChar;
  end;
  PACTRL_CONTROL_INFO = PACTRL_CONTROL_INFOA;
  PPACTRL_CONTROL_INFOA = ^PACTRL_CONTROL_INFOA;
  PPACTRL_CONTROL_INFOW = ^PACTRL_CONTROL_INFOW;
  PPACTRL_CONTROL_INFO = PPACTRL_CONTROL_INFOA;

const
  NO_INHERITANCE                      = $0;
  SUB_OBJECTS_ONLY_INHERIT            = $1;
  SUB_CONTAINERS_ONLY_INHERIT         = $2;
  SUB_CONTAINERS_AND_OBJECTS_INHERIT  = $3;
  INHERIT_NO_PROPAGATE                = $4;
  INHERIT_ONLY                        = $8;
  INHERITED_ACCESS_ENTRY              = $10;
  INHERITED_PARENT                    = $10000000;
  INHERITED_GRANDPARENT               = $20000000;
  ACTRL_ACCESS_NO_OPTIONS             = $00000000;
  ACTRL_ACCESS_SUPPORTS_OBJECT_ENTRIES= $00000001;
  ACCCTRL_DEFAULT_PROVIDERA           = 'Windows NT Access Provider';
  ACCCTRL_DEFAULT_PROVIDERW           = 'Windows NT Access Provider';
  ACCCTRL_DEFAULT_PROVIDER            = ACCCTRL_DEFAULT_PROVIDERA;
  TRUSTEE_ACCESS_ALLOWED              = $00000001;
  TRUSTEE_ACCESS_READ                 = $00000002;
  TRUSTEE_ACCESS_WRITE                = $00000004;
  TRUSTEE_ACCESS_EXPLICIT             = $00000001;
  TRUSTEE_ACCESS_READ_WRITE           = TRUSTEE_ACCESS_READ or TRUSTEE_ACCESS_WRITE;
  TRUSTEE_ACCESS_ALL                  = $FFFFFFFF;
  ACTRL_RESERVED                      = $00000000;
  ACTRL_PERM_1                        = $00000001;
  ACTRL_PERM_2                        = $00000002;
  ACTRL_PERM_3                        = $00000004;
  ACTRL_PERM_4                        = $00000008;
  ACTRL_PERM_5                        = $00000010;
  ACTRL_PERM_6                        = $00000020;
  ACTRL_PERM_7                        = $00000040;
  ACTRL_PERM_8                        = $00000080;
  ACTRL_PERM_9                        = $00000100;
  ACTRL_PERM_10                       = $00000200;
  ACTRL_PERM_11                       = $00000400;
  ACTRL_PERM_12                       = $00000800;
  ACTRL_PERM_13                       = $00001000;
  ACTRL_PERM_14                       = $00002000;
  ACTRL_PERM_15                       = $00004000;
  ACTRL_PERM_16                       = $00008000;
  ACTRL_PERM_17                       = $00010000;
  ACTRL_PERM_18                       = $00020000;
  ACTRL_PERM_19                       = $00040000;
  ACTRL_PERM_20                       = $00080000;
  ACTRL_ACCESS_ALLOWED                = $00000001;
  ACTRL_ACCESS_DENIED                 = $00000002;
  ACTRL_AUDIT_SUCCESS                 = $00000004;
  ACTRL_AUDIT_FAILURE                 = $00000008;
  ACTRL_ACCESS_PROTECTED              = $00000001;
  ACTRL_SYSTEM_ACCESS                 = $04000000;
  ACTRL_DELETE                        = $08000000;
  ACTRL_READ_CONTROL                  = $10000000;
  ACTRL_CHANGE_ACCESS                 = $20000000;
  ACTRL_CHANGE_OWNER                  = $40000000;
  ACTRL_SYNCHRONIZE                   = $80000000;
  ACTRL_STD_RIGHTS_ALL                = $F8000000;
  ACTRL_STD_RIGHT_REQUIRED            = ACTRL_STD_RIGHTS_ALL and not ACTRL_SYNCHRONIZE;
  ACTRL_DS_OPEN                       = ACTRL_RESERVED;
  ACTRL_DS_CREATE_CHILD               = ACTRL_PERM_1;
  ACTRL_DS_DELETE_CHILD               = ACTRL_PERM_2;
  ACTRL_DS_LIST                       = ACTRL_PERM_3;
  ACTRL_DS_SELF                       = ACTRL_PERM_4;
  ACTRL_DS_READ_PROP                  = ACTRL_PERM_5;
  ACTRL_DS_WRITE_PROP                 = ACTRL_PERM_6;
  ACTRL_DS_DELETE_TREE                = ACTRL_PERM_7;
  ACTRL_DS_LIST_OBJECT                = ACTRL_PERM_8;
  ACTRL_DS_CONTROL_ACCESS             = ACTRL_PERM_9;
  ACTRL_FILE_READ                     = ACTRL_PERM_1;
  ACTRL_FILE_WRITE                    = ACTRL_PERM_2;
  ACTRL_FILE_APPEND                   = ACTRL_PERM_3;
  ACTRL_FILE_READ_PROP                = ACTRL_PERM_4;
  ACTRL_FILE_WRITE_PROP               = ACTRL_PERM_5;
  ACTRL_FILE_EXECUTE                  = ACTRL_PERM_6;
  ACTRL_FILE_READ_ATTRIB              = ACTRL_PERM_8;
  ACTRL_FILE_WRITE_ATTRIB             = ACTRL_PERM_9;
  ACTRL_FILE_CREATE_PIPE              = ACTRL_PERM_10;
  ACTRL_DIR_LIST                      = ACTRL_PERM_1;
  ACTRL_DIR_CREATE_OBJECT             = ACTRL_PERM_2;
  ACTRL_DIR_CREATE_CHILD              = ACTRL_PERM_3;
  ACTRL_DIR_DELETE_CHILD              = ACTRL_PERM_7;
  ACTRL_DIR_TRAVERSE                  = ACTRL_PERM_6;
  ACTRL_KERNEL_TERMINATE              = ACTRL_PERM_1;
  ACTRL_KERNEL_THREAD                 = ACTRL_PERM_2;
  ACTRL_KERNEL_VM                     = ACTRL_PERM_3;
  ACTRL_KERNEL_VM_READ                = ACTRL_PERM_4;
  ACTRL_KERNEL_VM_WRITE               = ACTRL_PERM_5;
  ACTRL_KERNEL_DUP_HANDLE             = ACTRL_PERM_6;
  ACTRL_KERNEL_PROCESS                = ACTRL_PERM_7;
  ACTRL_KERNEL_SET_INFO               = ACTRL_PERM_8;
  ACTRL_KERNEL_GET_INFO               = ACTRL_PERM_9;
  ACTRL_KERNEL_CONTROL                = ACTRL_PERM_10;
  ACTRL_KERNEL_ALERT                  = ACTRL_PERM_11;
  ACTRL_KERNEL_GET_CONTEXT            = ACTRL_PERM_12;
  ACTRL_KERNEL_SET_CONTEXT            = ACTRL_PERM_13;
  ACTRL_KERNEL_TOKEN                  = ACTRL_PERM_14;
  ACTRL_KERNEL_IMPERSONATE            = ACTRL_PERM_15;
  ACTRL_KERNEL_DIMPERSONATE           = ACTRL_PERM_16;
  ACTRL_PRINT_SADMIN                  = ACTRL_PERM_1;
  ACTRL_PRINT_SLIST                   = ACTRL_PERM_2;
  ACTRL_PRINT_PADMIN                  = ACTRL_PERM_3;
  ACTRL_PRINT_PUSE                    = ACTRL_PERM_4;
  ACTRL_PRINT_JADMIN                  = ACTRL_PERM_5;
  ACTRL_SVC_GET_INFO                  = ACTRL_PERM_1;
  ACTRL_SVC_SET_INFO                  = ACTRL_PERM_2;
  ACTRL_SVC_STATUS                    = ACTRL_PERM_3;
  ACTRL_SVC_LIST                      = ACTRL_PERM_4;
  ACTRL_SVC_START                     = ACTRL_PERM_5;
  ACTRL_SVC_STOP                      = ACTRL_PERM_6;
  ACTRL_SVC_PAUSE                     = ACTRL_PERM_7;
  ACTRL_SVC_INTERROGATE               = ACTRL_PERM_8;
  ACTRL_SVC_UCONTROL                  = ACTRL_PERM_9;
  ACTRL_REG_QUERY                     = ACTRL_PERM_1;
  ACTRL_REG_SET                       = ACTRL_PERM_2;
  ACTRL_REG_LIST                      = ACTRL_PERM_4;
  ACTRL_REG_NOTIFY                    = ACTRL_PERM_5;
  ACTRL_REG_LINK                      = ACTRL_PERM_6;
  ACTRL_WIN_CLIPBRD                   = ACTRL_PERM_1;
  ACTRL_WIN_GLOBAL_ATOMS              = ACTRL_PERM_2;
  ACTRL_WIN_CREATE                    = ACTRL_PERM_3;
  ACTRL_WIN_LIST_DESK                 = ACTRL_PERM_4;
  ACTRL_WIN_LIST                      = ACTRL_PERM_5;
  ACTRL_WIN_READ_ATTRIBS              = ACTRL_PERM_6;
  ACTRL_WIN_WRITE_ATTRIBS             = ACTRL_PERM_7;
  ACTRL_WIN_SCREEN                    = ACTRL_PERM_8;
  ACTRL_WIN_EXIT                      = ACTRL_PERM_9;

implementation

begin
  (* Nothing to implement *)
end.
