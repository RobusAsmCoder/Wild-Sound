(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       WIN_FUN.INC for System Unit                            *)
(*       Target: WIN32                                          *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$ifdef __WIN32__}

{$ifdef interface}

function Win32BuildNumber: Longint;
function Win32Platform: Longint;
function Win32MajorVersion: Longint;
function Win32MinorVersion: Longint;
function GetLocaleStr(Locale, LocaleType: Longint; DefaultString: string): string;

{$else}

function Win32BuildNumber: Longint;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
    Result := OSVersionInfo.dwBuildNumber
  else
    Result := 0;
end;

function Win32Platform: Longint;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
    Result := OSVersionInfo.dwPLatformId
  else
    Result := 0;
end;

function Win32MajorVersion: Longint;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
    Result := OSVersionInfo.dwMajorVersion
  else
    Result := 0;
end;

function Win32MinorVersion: Longint;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
    Result := OSVersionInfo.dwMinorVersion
  else
    Result := 0;
end;

function GetLocaleStr(Locale, LocaleType: Longint; DefaultString: string): string;
var
  LS: Longint;
  Temp: array[0..MAX_PATH] of Char;
begin
  FillChar(Temp, SizeOf(Temp), 0);
  if GetLocaleInfo(Locale, LocaleType, Temp, MAX_PATH) > 0 then
    Result := StrPas(Temp)
  else
    Result := DefaultString;
end;

{$endif}

{$endif}