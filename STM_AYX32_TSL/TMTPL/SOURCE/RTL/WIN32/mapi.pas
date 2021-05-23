(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit MAPI Interface                           *)
(*       Based on mapi.h                                        *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit Mapi;

(*
 *  M A P I . H
 *
 *  Messaging Applications Programming Interface.
 *
 *  Copyright 1986-1996 Microsoft Corporation. All Rights Reserved.
 *
 *  Purpose:
 *
 *    This file defines the structures and constants used by that
 *    subset of the Messaging Applications Programming Interface
 *    which is supported under Windows by Microsoft Mail for PC
 *    Networks version 3.x.
 *)

interface

uses Windows;

const
  lhSessionNull   = (0);

type
  FLAGS    = DWORD;
  LHANDLE  = DWORD;
  PLHANDLE = PDWORD;

  PMapiFileDesc = ^TMapiFileDesc;
  TMapiFileDesc = packed record
    ulReserved: DWORD;          // Reserved for future use (must be 0)
    flFlags: DWORD;             // Flags
    nPosition: DWORD;           // character in text to be replaced by attachment
    lpszPathName: LPSTR;        // Full path name of attachment file
    lpszFileName: LPSTR;        // Original file name (optional)
    lpFileType: Pointer;        // Attachment file type (can be lpMapiFileTagExt)
  end;

 PMapiFileTagExt = ^TMapiFileTagExt;
  TMapiFileTagExt = packed record
    ulReserved: DWORD;          // Reserved, must be zero.
    cbTag: DWORD;               // Size (in bytes) of
    lpTag: PByte;               // X.400 OID for this attachment type
    cbEncoding: DWORD;          // Size (in bytes) of
    lpEncoding: PByte;          // X.400 OID for this attachment's encoding
  end;


  PMapiRecipDesc = ^TMapiRecipDesc;
  TMapiRecipDesc = packed record
    ulReserved: DWORD;          // Reserved for future use
    ulRecipClass: DWORD;        // Recipient class
                                // MAPI_TO, MAPI_CC, MAPI_BCC, MAPI_ORIG
    lpszName: LPSTR;            // Recipient name
    lpszAddress: LPSTR;         // Recipient address (optional)
    ulEIDSize: DWORD;           // Count in bytes of size of pEntryID
    lpEntryID: Pointer;         // System-specific recipient reference
  end;

  PMapiMessage = ^TMapiMessage;
  TMapiMessage = packed record
    ulReserved: DWORD;            // Reserved for future use (M.B. 0)
    lpszSubject: LPSTR;           // Message Subject
    lpszNoteText: LPSTR;          // Message Text
    lpszMessageType: LPSTR;       // Message Class
    lpszDateReceived: LPSTR;      // in YYYY/MM/DD HH:MM format
    lpszConversationID: LPSTR;    // conversation thread ID
    flFlags: FLAGS;               // unread,return receipt
    lpOriginator: PMapiRecipDesc; // Originator descriptor
    nRecipCount: DWORD;           // Number of recipients
    lpRecips: PMapiRecipDesc;     // Recipient descriptors
    nFileCount: DWORD;            // # of file attachments
    lpFiles: PMapiFileDesc;       // Attachment descriptors
  end;

type
  PFNMapiLogon = ^TFNMapiLogOn;
  TFNMapiLogOn = function conv arg_stdcall (ulUIParam: DWORD; lpszProfileName: LPSTR;
    lpszPassword: LPSTR; flFlags: FLAGS; ulReserved: DWORD; lplhSession: PLHANDLE): DWORD;

  PFNMapiLogOff = ^TFNMapiLogOff;
  TFNMapiLogOff = function conv arg_stdcall (lhSession: LHANDLE; ulUIParam: DWORD; flFlags: FLAGS;
    ulReserved: DWORD): DWORD;

  PFNMapiSendMail = ^TFNMapiSendMail;
  TFNMapiSendMail = function conv arg_stdcall (lhSession: LHANDLE; ulUIParam: DWORD;
    var lpMessage: TMapiMessage; flFlags: FLAGS;  ulReserved: DWORD): DWORD;

  PFNMapiSendDocuments = ^TFNMapiSendDocuments;
  TFNMapiSendDocuments = function conv arg_stdcall (ulUIParam: DWORD; lpszDelimChar: LPSTR;
    lpszFilePaths: LPSTR; lpszFileNames: LPSTR; ulReserved: DWORD): DWORD;

  PFNMapiFindNext = ^TFNMapiFindNext;
  TFNMapiFindNext = function conv arg_stdcall (lhSession: LHANDLE; ulUIParam: DWORD;
    lpszMessageType: LPSTR; lpszSeedMessageID: LPSTR; flFlags: FLAGS;
    ulReserved: DWORD; lpszMessageID: LPSTR): DWORD;

  PFNMapiReadMail = ^TFNMapiReadMail;
  TFNMapiReadMail = function conv arg_stdcall (lhSession: LHANDLE; ulUIParam: DWORD;
    lpszMessageID: LPSTR; flFlags: FLAGS; ulReserved: DWORD;
    var lppMessage: PMapiMessage): DWORD;

  PFNMapiSaveMail = ^TFNMapiSaveMail;
  TFNMapiSaveMail = function conv arg_stdcall (lhSession: LHANDLE; ulUIParam: DWORD;
    var lpMessage: TMapiMessage; flFlags: FLAGS; ulReserved: DWORD;
    lpszMessageID: LPSTR): DWORD;

  PFNMapiDeleteMail = ^TFNMapiDeleteMail;
  TFNMapiDeleteMail = function conv arg_stdcall (lhSession: LHANDLE; ulUIParam: DWORD;
    lpszMessageID: LPSTR; flFlags: FLAGS; ulReserved: DWORD): DWORD;

  PFNMapiFreeBuffer = ^TFNMapiFreeBuffer;
  TFNMapiFreeBuffer = function conv arg_stdcall (pv: Pointer): DWORD;

  PFNMapiAddress = ^TFNMapiAddress;
  TFNMapiAddress = function conv arg_stdcall (lhSession: LHANDLE; ulUIParam: DWORD;
    lpszCaption: LPSTR; nEditFields: DWORD; lpszLabels: LPSTR;
    nRecips: DWORD; var lpRecips: TMapiRecipDesc; flFlags: FLAGS;
    ulReserved: DWORD; lpnNewRecips: PULONG; var lppNewRecips: PMapiRecipDesc): DWORD;

  PFNMapiDetails = ^TFNMapiDetails;
  TFNMapiDetails = function conv arg_stdcall (lhSession: LHANDLE; ulUIParam: DWORD;
    var lpRecip: TMapiRecipDesc; flFlags: FLAGS; ulReserved: DWORD): DWORD;

  PFNMapiResolveName = ^TFNMapiResolveName;
  TFNMapiResolveName = function conv arg_stdcall (lhSession: LHANDLE; ulUIParam: DWORD;
    lpszName: LPSTR; flFlags: FLAGS; ulReserved: DWORD;
    var lppRecip: PMapiRecipDesc): DWORD;

const
  MAPI_LOGON_UI = $00000001;
  MAPI_PASSWORD_UI = $00020000;
  MAPI_NEW_SESSION = $00000002;
  MAPI_FORCE_DOWNLOAD = $00001000;
  MAPI_ALLOW_OTHERS = $00000008;
  MAPI_EXPLICIT_PROFILE = $00000010;
  MAPI_EXTENDED = $00000020;
  MAPI_USE_DEFAULT = $00000040;
  MAPI_SIMPLE_DEFAULT = MAPI_LOGON_UI or MAPI_FORCE_DOWNLOAD or MAPI_ALLOW_OTHERS;
  MAPI_SIMPLE_EXPLICIT = MAPI_NEW_SESSION or MAPI_FORCE_DOWNLOAD or MAPI_EXPLICIT_PROFILE;
  MAPI_LOGOFF_SHARED = $00000001;
  MAPI_LOGOFF_UI = $00000002;
  MAPI_DIALOG = $00000008;
  MAPI_UNREAD_ONLY = $00000020;
  MAPI_GUARANTEE_FIFO = $00000100;
  MAPI_LONG_MSGID = $00004000;
  MAPI_PEEK = $00000080;
  MAPI_SUPPRESS_ATTACH = $00000800;
  MAPI_ENVELOPE_ONLY = $00000040;
  MAPI_BODY_AS_FILE = $00000200;
  MAPI_AB_NOMODIFY = $00000400;
  MAPI_OLE = $00000001;
  MAPI_OLE_STATIC = $00000002;
  MAPI_ORIG = 0;
  MAPI_TO = 1;
  MAPI_CC = 2;
  MAPI_BCC = 3;
  MAPI_UNREAD = $00000001;
  MAPI_RECEIPT_REQUESTED = $00000002;
  MAPI_SENT = $00000004;
  SUCCESS_SUCCESS = 0;
  MAPI_USER_ABORT = 1;
  MAPI_E_USER_ABORT = MAPI_USER_ABORT;
  MAPI_E_FAILURE = 2;
  MAPI_E_LOGON_FAILURE = 3;
  MAPI_E_LOGIN_FAILURE = MAPI_E_LOGON_FAILURE;
  MAPI_E_DISK_FULL = 4;
  MAPI_E_INSUFFICIENT_MEMORY = 5;
  MAPI_E_ACCESS_DENIED = 6;
  MAPI_E_TOO_MANY_SESSIONS = 8;
  MAPI_E_TOO_MANY_FILES = 9;
  MAPI_E_TOO_MANY_RECIPIENTS = 10;
  MAPI_E_ATTACHMENT_NOT_FOUND = 11;
  MAPI_E_ATTACHMENT_OPEN_FAILURE = 12;
  MAPI_E_ATTACHMENT_WRITE_FAILURE = 13;
  MAPI_E_UNKNOWN_RECIPIENT = 14;
  MAPI_E_BAD_RECIPTYPE = 15;
  MAPI_E_NO_MESSAGES = 16;
  MAPI_E_INVALID_MESSAGE = 17;
  MAPI_E_TEXT_TOO_LARGE = 18;
  MAPI_E_INVALID_SESSION = 19;
  MAPI_E_TYPE_NOT_SUPPORTED = 20;
  MAPI_E_AMBIGUOUS_RECIPIENT = 21;
  MAPI_E_AMBIG_RECIP = MAPI_E_AMBIGUOUS_RECIPIENT;
  MAPI_E_MESSAGE_IN_USE = 22;
  MAPI_E_NETWORK_FAILURE = 23;
  MAPI_E_INVALID_EDITFIELDS = 24;
  MAPI_E_INVALID_RECIPS = 25;
  MAPI_E_NOT_SUPPORTED = 26;

function MapiLogOn(ulUIParam: DWORD; lpszProfileName: LPSTR;
  lpszPassword: LPSTR; flFlags: FLAGS; ulReserved: DWORD;
  lplhSession: PLHANDLE): DWORD;

function MapiLogOff(lhSession: LHANDLE; ulUIParam: DWORD; flFlags: FLAGS;
  ulReserved: DWORD): DWORD;

function MapiSendMail(lhSession: LHANDLE; ulUIParam: DWORD;
  var lpMessage: TMapiMessage; flFlags: FLAGS; ulReserved: DWORD): DWORD;

function MapiSendDocuments(ulUIParam: DWORD; lpszDelimChar: LPSTR;
  lpszFilePaths: LPSTR; lpszFileNames: LPSTR; ulReserved: DWORD): DWORD;

function MapiFindNext(lhSession: LHANDLE; ulUIParam: DWORD;
  lpszMessageType: LPSTR; lpszSeedMessageID: LPSTR; flFlags: FLAGS;
  ulReserved: DWORD; lpszMessageID: LPSTR): DWORD;

function MapiReadMail(lhSession: LHANDLE; ulUIParam: DWORD;
  lpszMessageID: LPSTR; flFlags: FLAGS; ulReserved: DWORD;
  var lppMessage: PMapiMessage): DWORD;

function MapiSaveMail(lhSession: LHANDLE; ulUIParam: DWORD;
  var lpMessage: TMapiMessage; flFlags: FLAGS; ulReserved: DWORD;
  lpszMessageID: LPSTR): DWORD;

function MapiDeleteMail(lhSession: LHANDLE; ulUIParam: DWORD;
  lpszMessageID: LPSTR; flFlags: FLAGS;
  ulReserved: DWORD): DWORD;

function MapiFreeBuffer(pv: Pointer): DWORD;

function MapiAddress(lhSession: LHANDLE; ulUIParam: DWORD;
  lpszCaption: LPSTR; nEditFields: DWORD; lpszLabels: LPSTR;
  nRecips: DWORD; var lpRecips: TMapiRecipDesc; flFlags: FLAGS;
  ulReserved: DWORD; lpnNewRecips: PULONG;
  var lppNewRecips: PMapiRecipDesc): DWORD;

function MapiDetails(lhSession: LHANDLE; ulUIParam: DWORD;
  var lpRecip: TMapiRecipDesc; flFlags: FLAGS;
  ulReserved: DWORD): DWORD;

function MapiResolveName(lhSession: LHANDLE; ulUIParam: DWORD;
  lpszName: LPSTR; flFlags: FLAGS; ulReserved: DWORD;
  var lppRecip: PMapiRecipDesc): DWORD;

implementation

var
  MAPIExitProc: Pointer;
  hlibMAPI: HModule;
  _MapiLogOn: TFNMapiLogOn := nil;
  _MapiLogOff: TFNMapiLogOff := nil;
  _MapiSendMail: TFNMapiSendMail := nil;
  _MapiSendDocuments: TFNMapiSendDocuments := nil;
  _MapiFindNext: TFNMapiFindNext := nil;
  _MapiReadMail: TFNMapiReadMail := nil;
  _MapiSaveMail: TFNMapiSaveMail := nil;
  _MapiDeleteMail: TFNMapiDeleteMail := nil;
  _MapiFreeBuffer: TFNMapiFreeBuffer := nil;
  _MapiAddress: TFNMapiAddress := nil;
  _MapiDetails: TFNMapiDetails := nil;
  _MapiResolveName: TFNMapiResolveName := nil;

(*
 -  ifMAPIInstalled
 -
 *  Purpose:
 *      Checks the appropriate win.ini/registry value to see if MAPI is
 *      installed in the system.
 *
 *  Returns:
 *      TRUE if Simple MAPI is installed, else FALSE
 *
 *)
function ifMAPIInstalled: Boolean;
var
  OSVersionInfo: TOSVersionInfo;
  MAPIVSize: Longint;
  szMAPIValie: array[0..8] of Char;
  hkWMS: HKEY;
  dwType: Longint;
begin
  Result := FALSE;
  (*
    on win32, if it's NT 3.51 or lower the value to check is
    win.ini \ [Mail] \ MAPI, otherwise it's a registry value
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Messaging Subsystem\MAPI
  *)
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if not GetVersionEx(OSVersionInfo) then Exit;

  if (OSVersionInfo.dwMajorVersion > 3) or
     ((OSVersionInfo.dwMajorVersion = 3) and (OSVersionInfo.dwMinorVersion > 51)) then
  begin
    MAPIVSize := SizeOf(szMAPIValie);
    //check the registry value
    if RegOpenKeyEx(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows Messaging Subsystem', 0, KEY_READ, hkWMS) <> ERROR_SUCCESS then
      Exit;
    if RegQueryValueEx(hkWMS, 'MAPI', nil, @dwType, @szMAPIValie, @MAPIVSize) <> ERROR_SUCCESS then
      Exit;
    RegCloseKey(hkWMS);
    if not ((szMAPIValie[0] = '1') and (szMAPIValie[1] = #0)) then Exit;
  end else
    if GetProfileInt('Mail', 'MAPI', 0) = 0 then Exit;
  Result := TRUE;
end;

(*
 -  InitMAPI
 -
 *  Purpose:
 *      Loads the DLL containing the MAPI functions and sets
 *      up a pointer to each.
 *
 *  Side effects:
 *      Loads a DLL and sets up function pointers
 *)
procedure InitMapi;
begin
  if hlibMAPI = 0 then
  begin
    (*
     *Check if MAPI is installed on the system
     *)
    if ifMAPIInstalled then
    begin
      declare
      var
        fuError: UINT;
      begin
        fuError := SetErrorMode(SEM_NOOPENFILEERRORBOX);
        hlibMAPI := LoadLibrary('MAPI32.DLL');
        SetErrorMode(fuError);
      end;
      @_MapiLogOn         := GetProcAddress(hlibMAPI, 'MAPILogon');
      @_MapiLogOff        := GetProcAddress(hlibMAPI, 'MAPILogoff');
      @_MapiSendMail      := GetProcAddress(hlibMAPI, 'MAPISendMail');
      @_MapiSendDocuments := GetProcAddress(hlibMAPI, 'MAPISendDocuments');
      @_MapiFindNext      := GetProcAddress(hlibMAPI, 'MAPIFindNext');
      @_MapiReadMail      := GetProcAddress(hlibMAPI, 'MAPIReadMail');
      @_MapiSaveMail      := GetProcAddress(hlibMAPI, 'MAPISaveMail');
      @_MapiDeleteMail    := GetProcAddress(hlibMAPI, 'MAPIDeleteMail');
      @_MapiFreeBuffer    := GetProcAddress(hlibMAPI, 'MAPIFreeBuffer');
      @_MapiAddress       := GetProcAddress(hlibMAPI, 'MAPIAddress');
      @_MapiDetails       := GetProcAddress(hlibMAPI, 'MAPIDetails');
      @_MapiResolveName   := GetProcAddress(hlibMAPI, 'MAPIResolveName');
    end;
  end;
end;

procedure DeInitMAPI;
begin
  if hlibMAPI <> 0 then
  begin
    FreeLibrary(hlibMAPI);
    hlibMAPI := 0;
  end;
  ExitProc := MAPIExitProc;
end;

function MapiLogOn(ulUIParam: DWORD; lpszProfileName: LPSTR;
  lpszPassword: LPSTR; flFlags: FLAGS; ulReserved: DWORD;
  lplhSession: PLHANDLE): DWORD;
begin
  if @_MapiLogOn <> nil then
    Result := _MapiLogOn(ulUIParam, lpszProfileName, lpszPassword, flFlags, ulReserved, lplhSession)
  else
    Result := 1;
end;

function MapiLogOff(lhSession: LHANDLE; ulUIParam: DWORD; flFlags: FLAGS;
  ulReserved: DWORD): DWORD;
begin
  if @_MapiLogOff <> nil then
    Result := _MapiLogOff(lhSession, ulUIParam, flFlags, ulReserved)
  else
    Result := 1;
end;

function MapiSendMail(lhSession: LHANDLE; ulUIParam: DWORD;
  var lpMessage: TMapiMessage; flFlags: FLAGS; ulReserved: DWORD): DWORD;
begin
  if @_MapiSendMail <> nil then
    Result := _MapiSendMail(lhSession, ulUIParam, lpMessage, flFlags, ulReserved)
  else
    Result := 1;
end;

function MapiSendDocuments(ulUIParam: DWORD; lpszDelimChar: LPSTR;
  lpszFilePaths: LPSTR; lpszFileNames: LPSTR;
  ulReserved: DWORD): DWORD;
begin
  if @_MapiSendDocuments <> nil then
    Result := _MapiSendDocuments(ulUIParam, lpszDelimChar, lpszFilePaths, lpszFileNames, ulReserved)
  else
    Result := 1;
end;

function MapiFindNext(lhSession: LHANDLE; ulUIParam: DWORD;
  lpszMessageType: LPSTR; lpszSeedMessageID: LPSTR; flFlags: FLAGS;
  ulReserved: DWORD; lpszMessageID: LPSTR): DWORD;
begin
  if @_MapiFindNext <> nil then
    Result := _MapiFindNext(lhSession, ulUIParam, lpszMessageType, lpszSeedMessageID, flFlags, ulReserved, lpszMessageID)
  else
    Result := 1;
end;

function MapiReadMail(lhSession: LHANDLE; ulUIParam: DWORD;
  lpszMessageID: LPSTR; flFlags: FLAGS; ulReserved: DWORD;
  var lppMessage: PMapiMessage): DWORD;
begin
  if @_MapiReadMail <> nil then
    Result := _MapiReadMail(lhSession, ulUIParam, lpszMessageID, flFlags, ulReserved, lppMessage)
  else
    Result := 1;
end;

function MapiSaveMail(lhSession: LHANDLE; ulUIParam: DWORD;
  var lpMessage: TMapiMessage; flFlags: FLAGS; ulReserved: DWORD;
  lpszMessageID: LPSTR): DWORD;
begin
  if @_MapiSaveMail <> nil then
    Result := _MapiSaveMail(lhSession, ulUIParam, lpMessage, flFlags, ulReserved, lpszMessageID)
  else
    Result := 1;
end;

function MapiDeleteMail(lhSession: LHANDLE; ulUIParam: DWORD;
  lpszMessageID: LPSTR; flFlags: FLAGS;
  ulReserved: DWORD): DWORD;
begin
  if @_MapiDeleteMail <> nil then
    Result := _MapiDeleteMail(lhSession, ulUIParam, lpszMessageID, flFlags, ulReserved)
  else
    Result := 1;
end;

function MapiFreeBuffer(pv: Pointer): DWORD;
begin
  if @_MapiFreeBuffer <> nil then
    Result := _MapiFreeBuffer(pv)
  else
    Result := 1;
end;

function MapiAddress(lhSession: LHANDLE; ulUIParam: DWORD;
  lpszCaption: LPSTR; nEditFields: DWORD; lpszLabels: LPSTR;
  nRecips: DWORD; var lpRecips: TMapiRecipDesc; flFlags: FLAGS;
  ulReserved: DWORD; lpnNewRecips: PULONG;
  var lppNewRecips: PMapiRecipDesc): DWORD;
begin
  if @_MapiAddress <> nil then
    Result := _MapiAddress(lhSession, ulUIParam, lpszCaption, nEditFields,
      lpszLabels, nRecips, lpRecips, flFlags, ulReserved, lpnNewRecips,
      lppNewRecips)
  else
    Result := 1;
end;

function MapiDetails(lhSession: LHANDLE; ulUIParam: DWORD;
  var lpRecip: TMapiRecipDesc; flFlags: FLAGS; ulReserved: DWORD): DWORD;
begin
  if @_MapiDetails <> nil then
    Result := _MapiDetails(lhSession, ulUIParam, lpRecip, flFlags, ulReserved)
  else
    Result := 1;
end;

function MapiResolveName(lhSession: LHANDLE; ulUIParam: DWORD;
  lpszName: LPSTR; flFlags: FLAGS; ulReserved: DWORD;
  var lppRecip: PMapiRecipDesc): DWORD;
begin
  if @_MapiResolveName <> nil then
    Result := _MapiResolveName(lhSession, ulUIParam, lpszName, flFlags, ulReserved, lppRecip)
  else
    Result := 1;
end;

begin
  MAPIExitProc := ExitProc;
  ExitProc := @DeInitMAPI;
  InitMapi;
end.
