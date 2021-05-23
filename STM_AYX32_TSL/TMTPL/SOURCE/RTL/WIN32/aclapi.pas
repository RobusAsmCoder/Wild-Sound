(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit Acl and trusted server access APIs       *)
(*       Based on aclapi.h                                      *)
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
//  Copyright  conv arg_stdcall (C) Microsoft Corporation, 1993-1997.
//
//  File:        aclapi.h
//
//  Contents:    public header file for acl and trusted server access control
//               APIs
//
//--------------------------------------------------------------------

interface

uses
  Windows, AccCtrl;

const
  aclapidll = 'ACLAPI.DLL';

type
  PPSID = ^PSID;
  PPSECURITY_DESCRIPTOR = ^PSECURITY_DESCRIPTOR;

function SetEntriesInAclA conv arg_stdcall (cCountOfExplicitEntries: ULONG; pListOfExplicitEntries: PEXPLICIT_ACCESS_A;
         OldAcl: PACL; var NewAcl: ACL): DWORD;
         external aclapidll name 'SetEntriesInAclA';

function SetEntriesInAclW conv arg_stdcall (cCountOfExplicitEntries: ULONG; pListOfExplicitEntries: PEXPLICIT_ACCESS_W;
         OldAcl: PACL; var NewAcl: ACL): DWORD;
         external aclapidll name 'SetEntriesInAclW';

function SetEntriesInAcl conv arg_stdcall (cCountOfExplicitEntries: ULONG; pListOfExplicitEntries: PEXPLICIT_ACCESS_;
         OldAcl: PACL; var NewAcl: ACL): DWORD;
         external aclapidll name 'SetEntriesInAclA';

function GetExplicitEntriesFromAclA conv arg_stdcall (var pacl: ACL; var pcCountOfExplicitEntries: ULONG;
         pListOfExplicitEntries: PEXPLICIT_ACCESS_A): DWORD;
         external aclapidll name 'GetExplicitEntriesFromAclA';

function GetExplicitEntriesFromAclW conv arg_stdcall (var pacl: ACL; var pcCountOfExplicitEntries: ULONG;
         pListOfExplicitEntries: PEXPLICIT_ACCESS_W): DWORD;
         external aclapidll name 'GetExplicitEntriesFromAclW';

function GetExplicitEntriesFromAcl conv arg_stdcall (var pacl: ACL; var pcCountOfExplicitEntries: ULONG;
         pListOfExplicitEntries: PEXPLICIT_ACCESS_): DWORD;
         external aclapidll name 'GetExplicitEntriesFromAclA';

function GetEffectiveRightsFromAclA conv arg_stdcall (var pacl: ACL; var pTrustee: TRUSTEE_A;
         var pAccessRights: ACCESS_MASK): DWORD;
         external aclapidll name 'GetEffectiveRightsFromAclA';

function GetEffectiveRightsFromAclW conv arg_stdcall (var pacl: ACL; var pTrustee: TRUSTEE_W;
         var pAccessRights: ACCESS_MASK): DWORD;
         external aclapidll name 'GetEffectiveRightsFromAclW';

function GetEffectiveRightsFromAcl conv arg_stdcall (var pacl: ACL; var pTrustee: TRUSTEE_;
         var pAccessRights: ACCESS_MASK): DWORD;
         external aclapidll name 'GetEffectiveRightsFromAclA';

function GetAuditedPermissionsFromAclA conv arg_stdcall (var pacl: ACL; var pTrustee: TRUSTEE_A;
         var pSuccessfulAuditedRights: ACCESS_MASK; var pFailedAuditRights: ACCESS_MASK): DWORD;
         external aclapidll name 'GetAuditedPermissionsFromAclA';

function GetAuditedPermissionsFromAclW conv arg_stdcall (var pacl: ACL; var pTrustee: TRUSTEE_W;
         var pSuccessfulAuditedRights: ACCESS_MASK; var pFailedAuditRights: ACCESS_MASK): DWORD;
         external aclapidll name 'GetAuditedPermissionsFromAclW';

function GetAuditedPermissionsFromAcl conv arg_stdcall (var pacl: ACL; var pTrustee: TRUSTEE_;
         var pSuccessfulAuditedRights: ACCESS_MASK; var pFailedAuditRights: ACCESS_MASK): DWORD;
         external aclapidll name 'GetAuditedPermissionsFromAclA';

function GetNamedSecurityInfoA conv arg_stdcall (pObjectName: PAnsiChar; ObjectType: SE_OBJECT_TYPE;
         SecurityInfo: SECURITY_INFORMATION; ppsidOwner, ppsidGroup: PPSID; ppDacl, ppSacl: PACL;
         var ppSecurityDescriptor: PSECURITY_DESCRIPTOR): DWORD;
         external aclapidll name 'GetNamedSecurityInfoA';

function GetNamedSecurityInfoW conv arg_stdcall (pObjectName: PAnsiChar; ObjectType: SE_OBJECT_TYPE;
         SecurityInfo: SECURITY_INFORMATION; ppsidOwner, ppsidGroup: PPSID; ppDacl, ppSacl: PACL;
         var ppSecurityDescriptor: PSECURITY_DESCRIPTOR): DWORD;
         external aclapidll name 'GetNamedSecurityInfoW';

function GetNamedSecurityInfo conv arg_stdcall (pObjectName: PAnsiChar; ObjectType: SE_OBJECT_TYPE;
         SecurityInfo: SECURITY_INFORMATION; ppsidOwner, ppsidGroup: PPSID; ppDacl, ppSacl: PACL;
         var ppSecurityDescriptor: PSECURITY_DESCRIPTOR): DWORD;
         external aclapidll name 'GetNamedSecurityInfoA';

function GetSecurityInfo conv arg_stdcall (handle: THandle; ObjectType: SE_OBJECT_TYPE;
         SecurityInfo: SECURITY_INFORMATION; ppsidOwner, ppsidGroup: PPSID; ppDacl, ppSacl: PACL;
         var ppSecurityDescriptor: PPSECURITY_DESCRIPTOR): DWORD;
         external aclapidll name 'GetSecurityInfo';

function SetNamedSecurityInfoA conv arg_stdcall (pObjectName: PAnsiChar; ObjectType: SE_OBJECT_TYPE;
         SecurityInfo: SECURITY_INFORMATION; ppsidOwner, ppsidGroup: PPSID;
         ppDacl, ppSacl: PACL): DWORD;
         external aclapidll name 'SetNamedSecurityInfoA';

function SetNamedSecurityInfoW conv arg_stdcall (pObjectName: PAnsiChar; ObjectType: SE_OBJECT_TYPE;
         SecurityInfo: SECURITY_INFORMATION; ppsidOwner, ppsidGroup: PPSID;
         ppDacl, ppSacl: PACL): DWORD;
         external aclapidll name 'SetNamedSecurityInfoW';

function SetNamedSecurityInfo conv arg_stdcall (pObjectName: PAnsiChar; ObjectType: SE_OBJECT_TYPE;
         SecurityInfo: SECURITY_INFORMATION; ppsidOwner, ppsidGroup: PPSID;
         ppDacl, ppSacl: PACL): DWORD;
         external aclapidll name 'SetNamedSecurityInfoA';

function SetSecurityInfo conv arg_stdcall (handle: THandle; ObjectType: SE_OBJECT_TYPE;
         SecurityInfo: SECURITY_INFORMATION; ppsidOwner, ppsidGroup: PPSID;
         ppDacl, ppSacl: PACL): DWORD;
         external aclapidll name 'SetSecurityInfo';

//----------------------------------------------------------------------------
// The following API are provided for trusted servers to use to
// implement access control on their own objects.
//----------------------------------------------------------------------------

function BuildSecurityDescriptorA conv arg_stdcall (pOwner, pGroup: PTRUSTEE_A; cCountOfAccessEntries: ULONG;
         pListOfAccessEntries: PEXPLICIT_ACCESS_A; cCountOfAuditEntries: ULONG;
         pListOfAuditEntries: PEXPLICIT_ACCESS_A; pOldSD: PSECURITY_DESCRIPTOR;
         var pSizeNewSD: ULONG; var pNewSD: SECURITY_DESCRIPTOR): DWORD;
         external aclapidll name 'BuildSecurityDescriptorA';

function BuildSecurityDescriptorW conv arg_stdcall (pOwner, pGroup: PTRUSTEE_W; cCountOfAccessEntries: ULONG;
         pListOfAccessEntries: PEXPLICIT_ACCESS_W; cCountOfAuditEntries: ULONG;
         pListOfAuditEntries: PEXPLICIT_ACCESS_W; pOldSD: PSECURITY_DESCRIPTOR;
         var pSizeNewSD: ULONG; var pNewSD: SECURITY_DESCRIPTOR): DWORD;
         external aclapidll name 'BuildSecurityDescriptorW';

function BuildSecurityDescriptor conv arg_stdcall (pOwner, pGroup: PTRUSTEE_; cCountOfAccessEntries: ULONG;
         pListOfAccessEntries: PEXPLICIT_ACCESS_; cCountOfAuditEntries: ULONG;
         pListOfAuditEntries: PEXPLICIT_ACCESS_; pOldSD: PSECURITY_DESCRIPTOR;
         var pSizeNewSD: ULONG; var pNewSD: SECURITY_DESCRIPTOR): DWORD;
         external aclapidll name 'BuildSecurityDescriptorA';

function LookupSecurityDescriptorPartsA conv arg_stdcall (pOwner, pGroup: PTRUSTEE_A; cCountOfAccessEntries: PULONG;
         pListOfAccessEntries: PEXPLICIT_ACCESS_A; cCountOfAuditEntries: PULONG;
         pListOfAuditEntries: PEXPLICIT_ACCESS_A; var pSD: SECURITY_DESCRIPTOR): DWORD;
         external aclapidll name 'LookupSecurityDescriptorPartsA';

function LookupSecurityDescriptorPartsW conv arg_stdcall (pOwner, pGroup: PTRUSTEE_W; cCountOfAccessEntries: PULONG;
         pListOfAccessEntries: PEXPLICIT_ACCESS_W; cCountOfAuditEntries: PULONG;
         pListOfAuditEntries: PEXPLICIT_ACCESS_W; var pSD: SECURITY_DESCRIPTOR): DWORD;
         external aclapidll name 'LookupSecurityDescriptorPartsW';

function LookupSecurityDescriptorParts conv arg_stdcall (pOwner, pGroup: PTRUSTEE_; cCountOfAccessEntries: PULONG;
         pListOfAccessEntries: PEXPLICIT_ACCESS_; cCountOfAuditEntries: PULONG;
         pListOfAuditEntries: PEXPLICIT_ACCESS_; var pSD: SECURITY_DESCRIPTOR): DWORD;
         external aclapidll name 'LookupSecurityDescriptorPartsA';

//----------------------------------------------------------------------------
// The following helper API are provided for building
// access control structures.
//----------------------------------------------------------------------------

procedure BuildExplicitAccessWithNameA conv arg_stdcall (pExplicitAccess: PEXPLICIT_ACCESS_A;
          pTrusteeName: PAnsiChar; AccessPermissions: DWORD; AccessMode: ACCESS_MODE;
          Ineritance: DWORD);
          external aclapidll name 'BuildExplicitAccessWithNameA';

procedure BuildExplicitAccessWithNameW conv arg_stdcall (pExplicitAccess: PEXPLICIT_ACCESS_W;
          pTrusteeName: PAnsiChar; AccessPermissions: DWORD; AccessMode: ACCESS_MODE;
          Ineritance: DWORD);
          external aclapidll name 'BuildExplicitAccessWithNameW';

procedure BuildExplicitAccessWithName conv arg_stdcall (pExplicitAccess: PEXPLICIT_ACCESS_;
          pTrusteeName: PAnsiChar; AccessPermissions: DWORD; AccessMode: ACCESS_MODE;
          Ineritance: DWORD);
          external aclapidll name 'BuildExplicitAccessWithNameA';

procedure BuildImpersonateExplicitAccessWithNameA conv arg_stdcall (pExplicitAccess: PEXPLICIT_ACCESS_A;
          pTrusteeName: PAnsiChar; pTrustee: PTRUSTEE_A; AccessPermissions: DWORD;
          AccessMode: ACCESS_MODE; Inheritance: DWORD);
          external aclapidll name 'BuildImpersonateExplicitAccessWithNameA';

procedure BuildImpersonateExplicitAccessWithNameW conv arg_stdcall (pExplicitAccess: PEXPLICIT_ACCESS_W;
          pTrusteeName: PAnsiChar; pTrustee: PTRUSTEE_W; AccessPermissions: DWORD;
          AccessMode: ACCESS_MODE; Inheritance: DWORD);
          external aclapidll name 'BuildImpersonateExplicitAccessWithNameW';

procedure BuildImpersonateExplicitAccessWithName conv arg_stdcall (pExplicitAccess: PEXPLICIT_ACCESS_;
          pTrusteeName: PAnsiChar; pTrustee: PTRUSTEE_; AccessPermissions: DWORD;
          AccessMode: ACCESS_MODE; Inheritance: DWORD);
          external aclapidll name 'BuildImpersonateExplicitAccessWithNameA';

procedure BuildTrusteeWithNameA conv arg_stdcall (pTrustee: PTRUSTEE_A; pName: PAnsiChar);
          external aclapidll name 'BuildTrusteeWithNameA';

procedure BuildTrusteeWithNameW conv arg_stdcall (pTrustee: PTRUSTEE_W; pName: PAnsiChar);
          external aclapidll name 'BuildTrusteeWithNameW';

procedure BuildTrusteeWithName conv arg_stdcall (pTrustee: PTRUSTEE_; pName: PAnsiChar);
          external aclapidll name 'BuildTrusteeWithNameA';

procedure BuildImpersonateTrusteeA conv arg_stdcall (pTrustee: PTRUSTEE_A; pImpersonateTrustee: PTRUSTEE_A);
          external aclapidll name 'BuildImpersonateTrusteeA';

procedure BuildImpersonateTrusteeW conv arg_stdcall (pTrustee: PTRUSTEE_W; pImpersonateTrustee: PTRUSTEE_W);
          external aclapidll name 'BuildImpersonateTrusteeW';

procedure BuildImpersonateTrustee conv arg_stdcall (pTrustee: PTRUSTEE_; pImpersonateTrustee: PTRUSTEE_);
          external aclapidll name 'BuildImpersonateTrusteeA';

procedure BuildTrusteeWithSidA conv arg_stdcall (pTrustee: PTRUSTEE_A; pSidIn: PSID);
          external aclapidll name 'BuildTrusteeWithSidA';

procedure BuildTrusteeWithSidW conv arg_stdcall (pTrustee: PTRUSTEE_W; pSidIn: PSID);
          external aclapidll name 'BuildTrusteeWithSidW';

procedure BuildTrusteeWithSid conv arg_stdcall (pTrustee: PTRUSTEE_; pSidIn: PSID);
          external aclapidll name 'BuildTrusteeWithSidA';

function GetTrusteeNameA conv arg_stdcall (var pTrustee: TRUSTEE_A): PAnsiChar;
         external aclapidll name 'GetTrusteeNameA';

function GetTrusteeNameW conv arg_stdcall (var pTrustee: TRUSTEE_W): PAnsiChar;
         external aclapidll name 'GetTrusteeNameW';

function GetTrusteeName conv arg_stdcall (var pTrustee: TRUSTEE_): PAnsiChar;
         external aclapidll name 'GetTrusteeNameA';

function GetTrusteeTypeA conv arg_stdcall (var pTrustee: TRUSTEE_A): TRUSTEE_TYPE;
         external aclapidll name 'GetTrusteeTypeA';

function GetTrusteeTypeW conv arg_stdcall (var pTrustee: TRUSTEE_W): TRUSTEE_TYPE;
         external aclapidll name 'GetTrusteeTypeW';

function GetTrusteeType conv arg_stdcall (var pTrustee: TRUSTEE_): TRUSTEE_TYPE;
         external aclapidll name 'GetTrusteeTypeA';

function GetTrusteeFormA conv arg_stdcall (var pTrustee: TRUSTEE_A): TRUSTEE_FORM;
         external aclapidll name 'GetTrusteeFormA';

function GetTrusteeFormW conv arg_stdcall (var pTrustee: TRUSTEE_W): TRUSTEE_FORM;
         external aclapidll name 'GetTrusteeFormW';

function GetTrusteeForm conv arg_stdcall (var pTrustee: TRUSTEE_): TRUSTEE_FORM;
         external aclapidll name 'GetTrusteeFormA';

function GetMultipleTrusteeOperationA conv arg_stdcall (pTrustee: PTRUSTEE_A): MULTIPLE_TRUSTEE_OPERATION;
         external aclapidll name 'GetMultipleTrusteeOperationA';

function GetMultipleTrusteeOperationW conv arg_stdcall (pTrustee: PTRUSTEE_W): MULTIPLE_TRUSTEE_OPERATION;
         external aclapidll name 'GetMultipleTrusteeOperationW';

function GetMultipleTrusteeOperation conv arg_stdcall (pTrustee: PTRUSTEE_): MULTIPLE_TRUSTEE_OPERATION;
         external aclapidll name 'GetMultipleTrusteeOperationA';

function GetMultipleTrusteeA conv arg_stdcall (pTrustee: PTrustee_A): PTRUSTEE_A;
         external aclapidll name 'GetMultipleTrusteeA';

function GetMultipleTrusteeW conv arg_stdcall (pTrustee: PTrustee_W): PTRUSTEE_W;
         external aclapidll name 'GetMultipleTrusteeW';

function GetMultipleTrustee conv arg_stdcall (pTrustee: PTrustee_): PTRUSTEE_;
         external aclapidll name 'GetMultipleTrusteeA';

implementation
  (* Nothing to implement *)
end.