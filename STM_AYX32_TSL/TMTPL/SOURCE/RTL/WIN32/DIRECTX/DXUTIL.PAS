unit DXUtil;
//-----------------------------------------------------------------------------
// File: DXUtil.h
//
// Desc: Helper functions and typing shortcuts for DirectX programming.
//
// Copyright (c) 1997-2000 Microsoft Corporation. All rights reserved
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Original ObjectPascal conversion made by: Boris V.
// E-Mail: bst@bstnet.org
//
// Updates and modifications by: Alexey Barkovoy and Vadim Bodrov
//-----------------------------------------------------------------------------

interface

{$i directx.inc}

uses
  Windows, D3D8, DSound, DDraw, MMSystem;

function DDLoadBitmap(pdd : IDirectDraw7; szBitmap: PChar; dx, dy: Longint): IDirectDrawSurface7;
function DDReLoadBitmap(pdds : IDirectDrawSurface7; szBitmap: PChar): HRESULT;
function DDCopyBitmap(pdds: IDirectDrawSurface7; hbm: HBITMAP; x, y, dx, dy: Longint): HRESULT;
function DDLoadPalette(pdd: IDirectDraw7; szBitmap: PChar) : IDirectDrawPalette;
function DDColorMatch(pdds: IDirectDrawSurface7; rgb: COLORREF): DWORD;
function DDSetColorKey(pdds: IDirectDrawSurface7; rgb: COLORREF): HRESULT;

function isGUID_NULL(iGUID: TGUID): Boolean;

const
  c_szWAV = 'WAV';
  MAX_BUFFER_COUNT = 4;

type
  PWordArray = ^TWordArray;
  TWordArray = array[0..16383] of Word;

  PObject = ^TObject;
  TObject = object
    constructor Create;
    procedure Free;
    destructor Destroy; virtual;
  end;

{$IFDEF UNICODE}
type
  PTChar = PWideChar;
  TChar  = WideChar;
{$ELSE}
type
  PTChar = PChar;
  TChar  = Char;
{$ENDIF}

type
  TSNDOBJ = record
    pbWaveData: POINTER;             // pointer into wave resource (for restore)
    cbWaveSize: DWORD;               // size of wave data (for restore)
    iAlloc: Longint;                 // number of buffers.
    iCurrent: Longint;               // current buffer
    Buffers: array [0..MAX_BUFFER_COUNT] of IDirectSoundBuffer; // list of buffers
end;

type
  HSNDOBJ = ^TSNDOBJ;
  PSNDOBJ = ^TSNDOBJ;

function DSLoadSoundBuffer(var pDS: IDirectSound; lpName: LPCTSTR ): IDirectSoundBuffer;
function DSReloadSoundBuffer(var pDSB: IDirectSoundBuffer; lpName: LPCTSTR): Boolean;
function DSGetWaveResource(Module: HMODULE; lpName: LPCTSTR;
  var ppWaveHeader: PWAVEFORMATEX; var ppbWaveData: POINTER; var pcbWaveSize: DWORD ): Boolean;
function SndObjCreate(var pDS: IDirectSound; lpName: LPCTSTR; iConcurrent: Longint): PSNDOBJ;
function SndObjGetFreeBuffer(pSO: PSNDOBJ): IDirectSoundBuffer;
function SndObjPlay(pSO: PSNDOBJ; dwPlayFlags: DWORD): Boolean;
function SndObjStop(pSO: PSNDOBJ): Boolean;
procedure SndObjDestroy(pSO: PSNDOBJ);
function DSFillSoundBuffer(var pDSB: IDirectSoundBuffer; var pbWaveData: POINTER; cbWaveSize: DWORD): Boolean;
function DSParseWaveResource(pvRes: Pointer; var ppWaveHeader: PWAVEFORMATEX;
  var ppbWaveData: POINTER; var pcbWaveSize: DWORD): Boolean;


type
  __tcscpy = function(Dest, Source: PChar): PChar;

var
  _tcscpy: __tcscpy;

procedure OutputDebugInfo(S: String);

//-----------------------------------------------------------------------------
// Miscellaneous helper functions
//-----------------------------------------------------------------------------
//#define SAFE_DELETE(p)       { if(p) { delete (p);     (p)=NULL; } }
//#define SAFE_DELETE_ARRAY(p) { if(p) { delete[] (p);   (p)=NULL; } }
//#define SAFE_RELEASE(p)      { if(p) { (p)->Release(); (p)=NULL; } }

procedure SAFE_RELEASE(var i);
procedure SAFE_DELETE(var Obj);

//-----------------------------------------------------------------------------
// Name: DXUtil_GetDXSDKMediaPath() and DXUtil_FindMediaFile()
// Desc: Returns the DirectX SDK path, as stored in the system registry
//       during the SDK install.
//-----------------------------------------------------------------------------
function DXUtil_GetDXSDKMediaPath: PChar;
function DXUtil_FindMediaFile(strPath: PChar; strFilename: PChar): HRESULT;



//-----------------------------------------------------------------------------
// Name: DXUtil_Read*RegKey() and DXUtil_Write*RegKey()
// Desc: Helper functions to read/write a string registry key
//-----------------------------------------------------------------------------
function DXUtil_WriteStringRegKey(hKey_: HKEY; strRegName: PChar; strValue: PChar): HRESULT;
function DXUtil_WriteIntRegKey (hKey_: HKEY; strRegName: PChar; dwValue: DWORD): HRESULT;
function DXUtil_WriteGuidRegKey(hKey_: HKEY; strRegName: PChar; guidValue: TGUID): HRESULT;
function DXUtil_WriteBoolRegKey(hKey_: HKEY; strRegName: PChar; bValue: BOOL): HRESULT;

function DXUtil_ReadStringRegKey(hKey_: HKEY; strRegName: PChar; var strValue: PChar; dwLength: DWORD; strDefault: PChar): HRESULT;
function DXUtil_ReadIntRegKey (hKey_: HKEY; strRegName: PChar; var pdwValue: DWORD; dwDefault: DWORD): HRESULT;
function DXUtil_ReadGuidRegKey(hKey_: HKEY; strRegName: PChar; var pGuidValue: TGUID; guidDefault: TGUID): HRESULT;
function DXUtil_ReadBoolRegKey(hKey_: HKEY; strRegName: PChar; var pbValue: BOOL; bDefault: BOOL): HRESULT;



//-----------------------------------------------------------------------------
// Name: DXUtil_Timer()
// Desc: Performs timer opertations. Use the following commands:
//          TIMER_RESET           - to reset the timer
//          TIMER_START           - to start the timer
//          TIMER_STOP            - to stop (or pause) the timer
//          TIMER_ADVANCE         - to advance the timer by 0.1 seconds
//          TIMER_GETABSOLUTETIME - to get the absolute system time
//          TIMER_GETAPPTIME      - to get the current time
//          TIMER_GETELAPSEDTIME  - to get the time that elapsed between
//                                  TIMER_GETELAPSEDTIME calls
//-----------------------------------------------------------------------------
type
  TIMER_COMMAND = DWORD;

const
  TIMER_RESET           = 0;
  TIMER_START           = 1;
  TIMER_STOP            = 2;
  TIMER_ADVANCE         = 3;
  TIMER_GETABSOLUTETIME = 4;
  TIMER_GETAPPTIME      = 5;
  TIMER_GETELAPSEDTIME  = 6;

function DXUtil_Timer(command: TIMER_COMMAND): Single; stdcall;


//-----------------------------------------------------------------------------
// UNICODE support for converting between CHAR, TCHAR, and WCHAR strings
//-----------------------------------------------------------------------------
//TODO!!

procedure DXUtil_ConvertAnsiStringToWide(var wstrDestination: PWideChar;
  const strSource: PChar; cchDestChar: Integer{$IFDEF SUPPORTS_DEFAULTPARAMS} = -1{$ENDIF});
(*
VOID DXUtil_ConvertWideStringToAnsi( CHAR* strDestination, const WCHAR* wstrSource, int cchDestChar = -1 );
*)
procedure DXUtil_ConvertGenericStringToAnsi(strDestination: PChar;
  const tstrSource: PChar; cchDestChar: Integer{$IFDEF SUPPORTS_DEFAULTPARAMS} = -1{$ENDIF});
procedure DXUtil_ConvertGenericStringToWide(var wstrDestination: PWideChar;
  const tstrSource: PChar; cchDestChar: Integer{$IFDEF SUPPORTS_DEFAULTPARAMS} = -1{$ENDIF});

procedure DXUtil_ConvertAnsiStringToGeneric(tstrDestination: PTChar;
  const strSource: PChar; cchDestChar: Integer{$IFDEF SUPPORTS_DEFAULTPARAMS} = -1{$ENDIF});
(*
VOID DXUtil_ConvertWideStringToGeneric( TCHAR* tstrDestination, const WCHAR* wstrSource, int cchDestChar = -1 );
*)




//-----------------------------------------------------------------------------
// Debug printing support
//-----------------------------------------------------------------------------
(*
VOID    DXUtil_Trace( TCHAR* strMsg, ... );
HRESULT _DbgOut( TCHAR*, DWORD, HRESULT, TCHAR* );

#if defined(DEBUG) | defined(_DEBUG)
    #define DXTRACE           DXUtil_Trace
#else
    #define DXTRACE           sizeof
#endif

#if defined(DEBUG) | defined(_DEBUG)
    #define DEBUG_MSG(str)    _DbgOut( __FILE__, (DWORD)__LINE__, 0, str )
#else
    #define DEBUG_MSG(str)    (0L)
#endif
*)

implementation

uses
  Strings;

procedure SAFE_RELEASE(var i);
begin
  if IUnknown(i) <> nil then
  begin
    IUnknown(i).Release;
    IUnknown(i):= nil;
  end;
end;

procedure SAFE_DELETE(var Obj);
var
  Temp: PObject;
begin
  Temp := PObject(Obj);
  Pointer(Obj) := nil;
  Temp^.Free;
end;


//-----------------------------------------------------------------------------
// Name: DXUtil_GetDXSDKMediaPath()
// Desc: Returns the DirectX SDK media path
//-----------------------------------------------------------------------------
function DXUtil_GetDXSDKMediaPath: PChar;
const
  strNull: array[0..1] of Char = (#0,#0);
  strPath: array[0..MAX_PATH-1] of Char = #0;
var
  dwType,dwSize: DWORD;
  hKey_: HKEY;
  lResult: Integer;
begin
  dwSize := MAX_PATH;

  // Open the appropriate registry key
  lResult := RegOpenKeyEx(HKEY_LOCAL_MACHINE,
                          'Software\Microsoft\DirectX',
                          0, KEY_READ, hKey_);
  if (ERROR_SUCCESS <> lResult) then
  begin
    Result:= strNull;
    Exit;
  end;

  lResult := RegQueryValueEx(hKey_, 'DX8SDK Samples Path', nil,
                             @dwType, PByte(@strPath), @dwSize);
  RegCloseKey(hKey_);

  if (ERROR_SUCCESS <> lResult) then
  begin
    Result:= strNull;
    Exit;
  end;

  strcat(strPath, '\Media\');

  Result:= strPath;
end;




//-----------------------------------------------------------------------------
// Name: DXUtil_FindMediaFile()
// Desc: Returns a valid path to a DXSDK media file
//-----------------------------------------------------------------------------
function DXUtil_FindMediaFile(strPath: PChar; strFilename: PChar): HRESULT;
var
  file_: DWord;
begin
  if (nil = strFilename) or (nil = strPath) then
  begin
    Result:= E_INVALIDARG;
    Exit;
  end;

  // Check if the file exists in the current directory
  strcopy(strPath, strFilename);

  file_:= CreateFile(strPath, GENERIC_READ, FILE_SHARE_READ, nil,
                     OPEN_EXISTING, 0, 0 );
  if (INVALID_HANDLE_VALUE <> file_) then
  begin
    CloseHandle(file_);
    Result:= S_OK;
    Exit;
  end;

  // Check if the file exists in the current directory
  // _stprintf( strPath, _T("%s%s"), DXUtil_GetDXSDKMediaPath(), strFilename );
  strcopy(strPath, DXUtil_GetDXSDKMediaPath);
  strcat(strPath, strFilename);

  file_:= CreateFile(strPath, GENERIC_READ, FILE_SHARE_READ, nil,
                     OPEN_EXISTING, 0, 0);
  if (INVALID_HANDLE_VALUE <> file_) then
  begin
    CloseHandle(file_);
    Result:= S_OK;
    Exit;
  end;

  // On failure, just return the file as the path
  strcopy(strPath, strFilename);
  Result:= E_FAIL;
end;




//-----------------------------------------------------------------------------
// Name: DXUtil_ReadStringRegKey()
// Desc: Helper function to read a registry key string
//-----------------------------------------------------------------------------
function DXUtil_ReadStringRegKey(hKey_: HKEY; strRegName: PChar;
  var strValue: PChar; dwLength: DWORD; strDefault: PChar): HRESULT;
var
  dwType: DWORD;
begin
  if (ERROR_SUCCESS <> RegQueryValueEx(hKey_, strRegName, nil, @dwType,
                                       PByte(strValue), @dwLength)) then
  begin
    strcopy(strValue, strDefault);
  end;

  Result:= S_OK;
end;




//-----------------------------------------------------------------------------
// Name: DXUtil_WriteStringRegKey()
// Desc: Helper function to write a registry key string
//-----------------------------------------------------------------------------
function DXUtil_WriteStringRegKey(hKey_: HKEY; strRegName: PChar; strValue: PChar): HRESULT;
begin
  if (ERROR_SUCCESS <> RegSetValueEx(hKey_, strRegName, 0, REG_SZ,
                                     strValue,
                                     strlen(strValue)+1)*sizeof(PChar)) then
  begin
    Result:= E_FAIL;
    Exit;
  end;

  Result:= S_OK;
end;




//-----------------------------------------------------------------------------
// Name: DXUtil_ReadIntRegKey()
// Desc: Helper function to read a registry key int
//-----------------------------------------------------------------------------
function DXUtil_ReadIntRegKey(hKey_: HKEY; strRegName: PChar; var pdwValue: DWORD; dwDefault: DWORD): HRESULT;
var
  dwType: DWORD;
  dwLength: DWORD;
begin
  dwLength := SizeOf(DWORD);

  if (ERROR_SUCCESS <> RegQueryValueEx(hKey_, strRegName, nil, @dwType,
                                       PByte(@pdwValue), @dwLength)) then
  begin
    pdwValue:= dwDefault;
  end;

  Result:= S_OK;
end;




//-----------------------------------------------------------------------------
// Name: DXUtil_WriteIntRegKey()
// Desc: Helper function to write a registry key int
//-----------------------------------------------------------------------------
function DXUtil_WriteIntRegKey(hKey_: HKEY; strRegName: PChar; dwValue: DWORD): HRESULT;
begin
  if (ERROR_SUCCESS <> RegSetValueEx(hKey_, strRegName, 0, REG_DWORD,
                                     PByte(@dwValue), SizeOf(DWORD))) then
  begin
    Result:= E_FAIL;
    Exit;
  end;

  Result:= S_OK;
end;




//-----------------------------------------------------------------------------
// Name: DXUtil_ReadBoolRegKey()
// Desc: Helper function to read a registry key BOOL
//-----------------------------------------------------------------------------
function DXUtil_ReadBoolRegKey(hKey_: HKEY; strRegName: PChar; var pbValue: BOOL;
  bDefault: BOOL): HRESULT;
var
  dwType: DWORD;
  dwLength: DWORD;
begin
  dwLength := SizeOf(BOOL);

  if (ERROR_SUCCESS <> RegQueryValueEx(hKey_, strRegName, nil, @dwType,
                                       PByte(@pbValue), @dwLength)) then
  begin
    pbValue := bDefault;
  end;

  Result:= S_OK;
end;




//-----------------------------------------------------------------------------
// Name: DXUtil_WriteBoolRegKey()
// Desc: Helper function to write a registry key BOOL
//-----------------------------------------------------------------------------
function DXUtil_WriteBoolRegKey(hKey_: HKEY; strRegName: PChar; bValue: BOOL): HRESULT;
begin
  if (ERROR_SUCCESS <> RegSetValueEx(hKey_, strRegName, 0, REG_DWORD,
                                     PByte(@bValue), sizeof(BOOL))) then
  begin
    Result:= E_FAIL;
    Exit;
  end;

  Result:= S_OK;
end;




//-----------------------------------------------------------------------------
// Name: DXUtil_ReadGuidRegKey()
// Desc: Helper function to read a registry key guid
//-----------------------------------------------------------------------------
function DXUtil_ReadGuidRegKey(hKey_: HKEY; strRegName: PChar;
  var pGuidValue: TGUID; guidDefault: TGUID): HRESULT;
var
  dwType: DWORD;
  dwLength: DWORD;
begin
  dwLength := SizeOf(TGUID);

  if (ERROR_SUCCESS <> RegQueryValueEx(hKey_, strRegName, nil, @dwType,
                                       PByte(@pGuidValue), @dwLength)) then
  begin
    pGuidValue := guidDefault;
  end;

  Result:= S_OK;
end;




//-----------------------------------------------------------------------------
// Name: DXUtil_WriteGuidRegKey()
// Desc: Helper function to write a registry key guid
//-----------------------------------------------------------------------------
function DXUtil_WriteGuidRegKey(hKey_: HKEY; strRegName: PChar; guidValue: TGUID): HRESULT;
begin
  if (ERROR_SUCCESS <> RegSetValueEx(hKey_, strRegName, 0, REG_BINARY,
                                     PByte(@guidValue), SizeOf(TGUID))) then
  begin
    Result:=E_FAIL;
    Exit;
  end;

  Result:= S_OK;
end;

{$Q-}
{function add2_66 (a, b: Int64): Int64;
begin
  Result.LowDWord:=  (a.LowDWord  + b.LowDWord);
  Result.HighDWord:= (a.HighDWord + b.HighDWord);
end;
function add2_ii (a, b: Integer): Integer;
Result := (a + b) * 2;
overload + = add_rr;
overload + = add_ii; }

//-----------------------------------------------------------------------------
// Name: DXUtil_Timer()
// Desc: Performs timer opertations. Use the following commands:
//          TIMER_RESET           - to reset the timer
//          TIMER_START           - to start the timer
//          TIMER_STOP            - to stop (or pause) the timer
//          TIMER_ADVANCE         - to advance the timer by 0.1 seconds
//          TIMER_GETABSOLUTETIME - to get the absolute system time
//          TIMER_GETAPPTIME      - to get the current time
//          TIMER_GETELAPSEDTIME  - to get the time that elapsed between
//                                  TIMER_GETELAPSEDTIME calls
//-----------------------------------------------------------------------------
function DXUtil_Timer(command: TIMER_COMMAND): Single; stdcall;
const
  m_bTimerInitialized: BOOL   = FALSE;
  m_bUsingQPF: BOOL           = FALSE;
  m_llQPFTicksPerSec: Comp    = 0;
  m_llStopTime: Comp          = 0;
  m_llLastElapsedTime: Comp   = 0;
  m_llBaseTime: Comp          = 0;
  m_fLastElapsedTime: Double  = 0.0;
  m_fBaseTime: Double         = 0.0;
  m_fStopTime: Double         = 0.0;
var
  qwTicksPerSec: Comp;
  qwTime: Comp;
  fTime: Double;
  fElapsedTime: Double;
  fAppTime: Double;
begin
  // Initialize the timer
  if (FALSE = m_bTimerInitialized) then
  begin
    m_bTimerInitialized := TRUE;

    // Use QueryPerformanceFrequency() to get frequency of timer.  If QPF is
    // not supported, we will timeGetTime() which returns milliseconds.

//    m_bUsingQPF := QueryPerformanceFrequency(Int64(qwTicksPerSec));
    m_bUsingQPF := QueryPerformanceFrequency(TLargeInteger(qwTicksPerSec));
    if (m_bUsingQPF) then
      m_llQPFTicksPerSec:= qwTicksPerSec{.QuadPart};
  end;

  if (m_bUsingQPF) then
  begin
    // Get either the current time or the stop time, depending
    // on whether we're stopped and what command was sent
    if (m_llStopTime <> 0) and (command <> TIMER_START) and (command <> TIMER_GETABSOLUTETIME) then
      qwTime{.QuadPart} := m_llStopTime
    else
      QueryPerformanceCounter(TLargeInteger(qwTime));

    // Return the elapsed time
    if (command = TIMER_GETELAPSEDTIME) then
    begin
      fElapsedTime:= (qwTime{.QuadPart} - m_llLastElapsedTime) /  m_llQPFTicksPerSec;
      m_llLastElapsedTime:= qwTime{.QuadPart};
      Result:= fElapsedTime;
      Exit;
    end;

    // Return the current time
    if (command = TIMER_GETAPPTIME) then
    begin
      fAppTime:= (qwTime{.QuadPart} - m_llBaseTime) /  m_llQPFTicksPerSec;
      Result:= fAppTime;
      Exit;
    end;

    // Reset the timer
    if (command = TIMER_RESET) then
    begin
      m_llBaseTime        := qwTime{.QuadPart};
      m_llLastElapsedTime := qwTime{.QuadPart};
      Result:= 0.0;
      Exit;
    end;

    // Start the timer
    if (command = TIMER_START) then
    begin
      m_llBaseTime:= m_llBaseTime + qwTime{.QuadPart} - m_llStopTime;
      m_llStopTime:= 0;
      m_llLastElapsedTime:= qwTime{.QuadPart};
      Result:=0.0;
      Exit;
    end;

    // Stop the timer
    if (command = TIMER_STOP) then
    begin
      m_llStopTime:= qwTime{.QuadPart};
      m_llLastElapsedTime:= qwTime{.QuadPart};
      Result:= 0.0;
      Exit;
    end;

    // Advance the timer by 1/10th second
    if (command = TIMER_ADVANCE) then
    begin
      m_llStopTime:= Trunc(m_llStopTime + m_llQPFTicksPerSec/10);
      Result:= 0.0;
      Exit;
    end;

    if (command = TIMER_GETABSOLUTETIME) then
    begin
      fTime:= qwTime{.QuadPart} / m_llQPFTicksPerSec;
      Result:= fTime;
      Exit;
    end;

    Result:= -1.0; // Invalid command specified
    Exit;
  end else
  begin
    // Get the time using timeGetTime()

    // Get either the current time or the stop time, depending
    // on whether we're stopped and what command was sent
    if (m_fStopTime <> 0.0) and (command <> TIMER_START) and (command <> TIMER_GETABSOLUTETIME) then
      fTime:= m_fStopTime
    else
      fTime:= timeGetTime * 0.001;

    // Return the elapsed time
    if (command = TIMER_GETELAPSEDTIME) then
    begin
      fElapsedTime:= (fTime - m_fLastElapsedTime);
      m_fLastElapsedTime:= fTime;
      Result:= fElapsedTime;
      Exit;
    end;

    // Return the current time
    if (command = TIMER_GETAPPTIME) then
    begin
      Result:= (fTime - m_fBaseTime);
      Exit;
    end;

    // Reset the timer
    if (command = TIMER_RESET) then
    begin
      m_fBaseTime         := fTime;
      m_fLastElapsedTime  := fTime;
      Result:= 0.0;
      Exit;
    end;

    // Start the timer
    if (command = TIMER_START) then
    begin
      m_fBaseTime := m_fBaseTime+fTime - m_fStopTime;
      m_fStopTime := 0.0;
      m_fLastElapsedTime:= fTime;
      Result:= 0.0;
      Exit;
    end;

    // Stop the timer
    if (command = TIMER_STOP) then
    begin
      m_fStopTime:= fTime;
      Result:= 0.0;
      Exit;
    end;

    // Advance the timer by 1/10th second
    if (command = TIMER_ADVANCE) then
    begin
      m_fStopTime:= m_fStopTime + 0.1;
      Result:= 0.0;
      Exit;
    end;

    if (command = TIMER_GETABSOLUTETIME) then
    begin
      Result:= fTime;
      Exit;
    end;

    Result:= -1.0; // Invalid command specified
  end;
end;




//-----------------------------------------------------------------------------
// Name: DXUtil_ConvertAnsiStringToWide()
// Desc: This is a UNICODE conversion utility to convert a CHAR string into a
//       WCHAR string. cchDestChar defaults -1 which means it
//       assumes strDest is large enough to store strSource
//-----------------------------------------------------------------------------
procedure DXUtil_ConvertAnsiStringToWide(var wstrDestination: PWideChar; const strSource: PChar;
  cchDestChar: Integer);
var
  Dest: PWideChar;
begin
  if (wstrDestination = nil) or (strSource = nil) then Exit;

  if (cchDestChar = -1) then
    cchDestChar:= strlen(strSource) + 1;

  MultiByteToWideChar(CP_ACP, 0, strSource, -1, wstrDestination, cchDestChar - 1);

  Dest:= wstrDestination;
  Dest:= PWideChar(Integer(Dest) + SizeOf(WideChar)*(cchDestChar - 1));
  Dest^:= #0;
end;



(*
//-----------------------------------------------------------------------------
// Name: DXUtil_ConvertWideStringToAnsi()
// Desc: This is a UNICODE conversion utility to convert a WCHAR string into a
//       CHAR string. cchDestChar defaults -1 which means it
//       assumes strDest is large enough to store strSource
//-----------------------------------------------------------------------------
VOID DXUtil_ConvertWideStringToAnsi( CHAR* strDestination, const WCHAR* wstrSource,
                                     int cchDestChar )
{
    if( strDestination==NULL || wstrSource==NULL )
        return;

    if( cchDestChar == -1 )
        cchDestChar = wcslen(wstrSource)+1;

    WideCharToMultiByte( CP_ACP, 0, wstrSource, -1, strDestination,
                         cchDestChar-1, NULL, NULL );

    strDestination[cchDestChar-1] = 0;
}



*)

//-----------------------------------------------------------------------------
// Name: DXUtil_ConvertGenericStringToAnsi()
// Desc: This is a UNICODE conversion utility to convert a TCHAR string into a
//       CHAR string. cchDestChar defaults -1 which means it
//       assumes strDest is large enough to store strSource
//-----------------------------------------------------------------------------
procedure DXUtil_ConvertGenericStringToAnsi(strDestination: PChar;
  const tstrSource: PChar; cchDestChar: Integer);
begin
  if (strDestination = nil) or (tstrSource = nil) or (cchDestChar = 0) then Exit;

{$ifdef _UNICODE}
  DXUtil_ConvertWideStringToAnsi(strDestination, tstrSource, cchDestChar);
{$else}
  if (cchDestChar = -1) then
  begin
    strcopy( strDestination, tstrSource);
  end else
  begin
    strlcopy(strDestination, tstrSource, cchDestChar);
    strDestination[cchDestChar-1]:= #0;
  end;
{$endif}
end;




//-----------------------------------------------------------------------------
// Name: DXUtil_ConvertGenericStringToWide()
// Desc: This is a UNICODE conversion utility to convert a TCHAR string into a
//       WCHAR string. cchDestChar defaults -1 which means it
//       assumes strDest is large enough to store strSource
//-----------------------------------------------------------------------------
procedure DXUtil_ConvertGenericStringToWide(var wstrDestination: PWideChar;
  const tstrSource: PChar; cchDestChar: Integer);
begin
  if (wstrDestination = nil) or (tstrSource = nil) or (cchDestChar = 0) then Exit;

{$ifdef _UNICODE}
  if (cchDestChar = -1) then
  begin
    wcscpy(wstrDestination, tstrSource);
  end else
  begin
    wcsncpy(wstrDestination, tstrSource, cchDestChar);
    wstrDestination[cchDestChar-1] = #0; // This should be WORD
  end;
{$else}
  DXUtil_ConvertAnsiStringToWide(wstrDestination, tstrSource, cchDestChar);
{$endif}
end;




//-----------------------------------------------------------------------------
// Name: DXUtil_ConvertAnsiStringToGeneric()
// Desc: This is a UNICODE conversion utility to convert a CHAR string into a
//       TCHAR string. cchDestChar defaults -1 which means it
//       assumes strDest is large enough to store strSource
//-----------------------------------------------------------------------------
procedure DXUtil_ConvertAnsiStringToGeneric(tstrDestination: PTChar;
  const strSource: PChar; cchDestChar: Integer);
begin
  if (tstrDestination = nil) or (strSource = nil) or (cchDestChar = 0) then Exit;

{$ifdef _UNICODE}
  DXUtil_ConvertAnsiStringToWide(tstrDestination, strSource, cchDestChar);
{$else}
  if (cchDestChar = -1) then
  begin
    strcopy(tstrDestination, strSource)
  end else
  begin
    strlcopy(tstrDestination, strSource, cchDestChar);
    tstrDestination[cchDestChar-1]:= #0;
  end;
{$endif}
end;

procedure OutputDebugInfo(S: String);
var
  F: Text;
begin
  Assign(F, '_out.txt');
  // Rewrite(F);
  Append(F);
  WriteLn(F, S);
  Close(F);
end;

constructor TObject.Create;
begin end;

destructor TObject.Destroy;
begin end;

procedure TObject.Free;
begin
  if @Self <> nil then
    Destroy;
end;

(*
//-----------------------------------------------------------------------------
// Name: DXUtil_ConvertAnsiStringToGeneric()
// Desc: This is a UNICODE conversion utility to convert a WCHAR string into a
//       TCHAR string. cchDestChar defaults -1 which means it
//       assumes strDest is large enough to store strSource
//-----------------------------------------------------------------------------
VOID DXUtil_ConvertWideStringToGeneric( TCHAR* tstrDestination, const WCHAR* wstrSource,
                                        int cchDestChar )
{
    if( tstrDestination==NULL || wstrSource==NULL )
        return;

#ifdef _UNICODE
    if( cchDestChar == -1 )
      wcscpy( tstrDestination, wstrSource );
    else
      wcsncpy( tstrDestination, wstrSource, cchDestChar );
#else
    DXUtil_ConvertWideStringToAnsi( tstrDestination, wstrSource, cchDestChar );
#endif
}




//-----------------------------------------------------------------------------
// Name: _DbgOut()
// Desc: Outputs a message to the debug stream
//-----------------------------------------------------------------------------
HRESULT _DbgOut( TCHAR* strFile, DWORD dwLine, HRESULT hr, TCHAR* strMsg )
{
    TCHAR buffer[256];
    wsprintf( buffer, _T("%s(%ld): "), strFile, dwLine );
    OutputDebugString( buffer );
    OutputDebugString( strMsg );

    if( hr )
    {
        wsprintf( buffer, _T("(hr=%08lx)\n"), hr );
        OutputDebugString( buffer );
    }

    OutputDebugString( _T("\n") );

    return hr;
}




//-----------------------------------------------------------------------------
// Name: DXUtil_Trace()
// Desc: Outputs to the debug stream a formatted string with a variable-
//       argument list.
//-----------------------------------------------------------------------------
VOID DXUtil_Trace( TCHAR* strMsg, ... )
{
#if defined(DEBUG) | defined(_DEBUG)
    TCHAR strBuffer[512];

    va_list args;
    va_start(args, strMsg);
    _vsntprintf( strBuffer, 512, strMsg, args );
    va_end(args);

    OutputDebugString( strBuffer );
#endif
}

*)

//-----------------------------------------------------------------------------
// Name: DDLoadBitmap()
// Desc: Create a DirectDrawSurface from a bitmap resource.
//-----------------------------------------------------------------------------
function DDLoadBitmap(pdd: IDirectDraw7; szBitmap: PChar; dx, dy: Longint): IDirectDrawSurface7;
var
  hbm:  HBITMAP;
  bm:   TBITMAP;
  ddsd: TDDSurfaceDesc2;
  pdds: IDirectDrawSurface7;
begin
  //
  //  Try to load the bitmap as a resource, if that fails, try it as a file
  //
  hbm := LoadImage(GetModuleHandle(nil), szBitmap, IMAGE_BITMAP, dx, dy, LR_CREATEDIBSECTION);
  if hbm = 0 then
    begin
      hbm := LoadImage(0, szBitmap, IMAGE_BITMAP, dx, dy, LR_LOADFROMFILE or LR_CREATEDIBSECTION);
    end;
  if hbm = 0 then
    begin
      Result := nil;
      Exit;
    end;
  //
  // Get size of the bitmap
  //
  GetObject(hbm, SizeOf(bm), @bm);
  //
  // Create a DirectDrawSurface for this bitmap
  //
  FillChar(ddsd, SizeOf(ddsd), 0);
  ddsd.dwSize := SizeOf(ddsd);
  ddsd.dwFlags := DDSD_CAPS or DDSD_HEIGHT or DDSD_WIDTH;
  ddsd.ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN;
  ddsd.dwWidth := bm.bmWidth;
  ddsd.dwHeight := bm.bmHeight;
  if pdd.CreateSurface(ddsd, pdds, nil) <> DD_OK then
    begin
      Result := nil;
      Exit;
    end;
  DDCopyBitmap(pdds, hbm, 0, 0, 0, 0);
  DeleteObject(hbm);
  Result := pdds;
end;

//-----------------------------------------------------------------------------
// Name: DDReLoadBitmap()
// Desc: Load a bitmap from a file or resource into a directdraw surface.
//       normaly used to re-load a surface after a restore.
//-----------------------------------------------------------------------------
function DDReLoadBitmap(pdds: IDirectDrawSurface7; szBitmap: PChar): HRESULT;
var
  hbm: HBITMAP;
  hr:  HRESULT;
begin
  //
  //  Try to load the bitmap as a resource, if that fails, try it as a file
  //
  hbm := LoadImage(GetModuleHandle(nil), szBitmap, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION);
  if hbm = 0 then
    begin
      hbm := LoadImage(0, szBitmap, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_CREATEDIBSECTION);
    end;
  if hbm = 0 then
    begin
      OutputDebugString('handle is null');
      Result := E_FAIL;
      Exit;
    end;
  hr := DDCopyBitmap(pdds, hbm, 0, 0, 0, 0);
  if hr <> DD_OK then
    begin
      OutputDebugString('ddcopybitmap failed');
      Result := hr;
      Exit;
    end;
  DeleteObject(hbm);
  Result := hr;
end;

//-----------------------------------------------------------------------------
// Name: DDCopyBitmap()
// Desc: Draw a bitmap into a DirectDrawSurface
//-----------------------------------------------------------------------------
function DDCopyBitmap(pdds: IDirectDrawSurface7; hbm: HBITMAP; x, y, dx, dy: Longint): HRESULT;
var
 hdcImage : HDC;
 h_dc:      HDC;
 bm:        TBITMAP;
 ddsd:      TDDSurfaceDesc2;
 hr:        HRESULT;
begin
  if (hbm = 0) or (pdds = nil) then
    begin
      Result := E_FAIL;
      Exit;
    end;
  //
  // Make sure this surface is restored.
  //
  pdds.Restore;
  //
  // Select bitmap into a memoryDC so we can use it.
  //
  hdcImage := CreateCompatibleDC(0);
  if hdcImage = 0 then
    begin
      OutputDebugString('createcompatible dc failed');
    end;
  SelectObject(hdcImage, hbm);
  //
  // Get size of the bitmap
  //
  GetObject(hbm, SizeOf(bm), @bm);
  if dx = 0 then                      // Use the passed size, unless zero
    begin
      dx := bm.bmWidth;
    end;
  if dy = 0 then
    begin
      dy := bm.bmHeight;
    end;
  //
  // Get size of surface.
  //
  ddsd.dwSize := SizeOf(ddsd);
  ddsd.dwFlags := DDSD_HEIGHT or DDSD_WIDTH;
  pdds.GetSurfaceDesc(ddsd);

  hr := pdds.GetDC(h_dc);
  if hr = DD_OK then
    begin
      StretchBlt(h_dc, 0, 0, ddsd.dwWidth, ddsd.dwHeight, hdcImage, x, y, dx, dy, SRCCOPY);
      pdds.ReleaseDC(h_dc);
    end;
  DeleteDC(hdcImage);
  Result := hr;
end;

var
  Old: Pointer;

//-----------------------------------------------------------------------------
// Name: DDLoadPalette()
// Desc: Create a DirectDraw palette object from a bitmap resource
//       if the resource does not exist or NULL is passed create a
//       default 332 palette.
//-----------------------------------------------------------------------------
function DDLoadPalette(pdd: IDirectDraw7; szBitmap: PChar): IDirectDrawPalette;
var
  ddpal: IDirectDrawPalette;
  i:     Longint;
  n:     Longint;
  fh:    Longint;
  h:     HRSRC;
  lpbi:  PBITMAPINFOHEADER;
  ape:   array[0..255] of TPALETTEENTRY;
  prgb:  PRGBQUAD;
  bf:    TBITMAPFILEHEADER;
  bi:    TBITMAPINFOHEADER;
  r:     Byte;
begin
  //
  // Build a 332 palette as the default.
  //
  for i := 0 to 255 do
    begin
      ape[i].peRed :=   ((i shr 5) and $07) * 255 div 7;
      ape[i].peGreen := ((i shr 2) and $07) * 255 div 7;
      ape[i].peBlue :=  ((i shr 0) and $03) * 255 div 3;
      ape[i].peFlags := 0;
    end;
  //
  // Get a pointer to the bitmap resource.
  //
  h := FindResource(0, szBitmap, RT_BITMAP);
  if (szBitmap <> nil) and (h <> 0) then
    begin
      lpbi := PBITMAPINFOHEADER(LockResource(LoadResource(0, h)));
      prgb := PRGBQUAD(lpbi + SizeOf(lpbi^.biSize));

      if lpbi = nil then
        OutputDebugString('lock resource failed');
      if (lpbi = nil) or (lpbi^.biSize < SizeOf(TBITMAPINFOHEADER)) then
        n := 0
      else if lpbi^.biBitCount > 8 then
        n := 0
      else if lpbi^.biClrUsed = 0 then
        n := 1 shl lpbi^.biBitCount
      else
        n := lpbi^.biClrUsed;

      //
      //  A DIB color table has its colors stored BGR not RGB
      //  so flip them around.
      //
      for i := 0 to n-1 do
        begin
          ape[i].peRed := prgb^.rgbRed;
          ape[i].peGreen := prgb^.rgbGreen;
          ape[i].peBlue := prgb^.rgbBlue;
          ape[i].peFlags := 0;
          inc(prgb);
        end;
    end
  else
    begin
      fh := _lopen(szBitmap, OF_READ);
      if (szBitmap <> nil) and (fh <> -1) then
        begin
          _lread(fh, @bf, SizeOf(bf));
          _lread(fh, @bi, SizeOf(bi));
          _lread(fh, @ape[0], SizeOf(ape));
          _lclose(fh);
          if bi.biSize <> SizeOf(TBITMAPINFOHEADER) then
            n := 0
          else if bi.biBitCount > 8 then
            n := 0
          else if bi.biClrUsed = 0 then
            n := 1 shl bi.biBitCount
          else
            n := bi.biClrUsed;
          //
          //  A DIB color table has its colors stored BGR not RGB
          //  so flip them around.
          //
          for i := 0 to n - 1 do
            begin
            r := ape[i].peRed;
            ape[i].peRed := ape[i].peBlue;
            ape[i].peBlue := r;
            end;
        end;
    end;
  pdd.CreatePalette(DDPCAPS_8BIT, @ape[0], ddpal, nil);
  Result := ddpal;
end;

//-----------------------------------------------------------------------------
// Name: DDColorMatch()
// Desc: Convert a RGB color to a pysical color.
//       We do this by leting GDI SetPixel() do the color matching
//       then we lock the memory and see what it got mapped to.
//-----------------------------------------------------------------------------
function DDColorMatch(pdds: IDirectDrawSurface7; rgb: COLORREF): DWORD;
var
  rgbT: COLORREF;
  h_dc: HDC;
  dw:   DWORD;
  ddsd: TDDSurfaceDesc2;
  hres: HRESULT;
begin
  dw := CLR_INVALID;
  rgbT := 0;
  //
  //  Use GDI SetPixel to color match for us
  //
  if (rgb <> CLR_INVALID) and (pdds.GetDC(h_dc) = DD_OK) then
    begin
      rgbT := GetPixel(h_dc, 0, 0);     // Save current pixel value
      SetPixel(h_dc, 0, 0, rgb);       // Set our value
      pdds.ReleaseDC(h_dc);
    end;
  //
  // Now lock the surface so we can read back the converted color
  //
  ddsd.dwSize := SizeOf(ddsd);
  hres := pdds.Lock(nil, ddsd, 0, 0);
  while hres = DDERR_WASSTILLDRAWING do
    begin
      hres := pdds.Lock(nil, ddsd, 0, 0);
    end;
  if hres = DD_OK then
    begin
      dw := PDWORD(ddsd.lpSurface)^;                 // Get DWORD
      if ddsd.ddpfPixelFormat.dwRGBBitCount < 32 then
        dw := dw and ((1 shl ddsd.ddpfPixelFormat.dwRGBBitCount) - 1);  // Mask it to bpp
      pdds.Unlock(nil);
    end;
  //
  //  Now put the color that was there back.
  //
  if (rgb <> CLR_INVALID) and (pdds.GetDC(h_dc) = DD_OK) then
    begin
      SetPixel(h_dc, 0, 0, rgbT);
      pdds.ReleaseDC(h_dc);
    end;
  Result := dw;
end;

//-----------------------------------------------------------------------------
// Name: DDSetColorKey()
// Desc: Set a color key for a surface, given a RGB.
//       If you pass CLR_INVALID as the color key, the pixel
//       in the upper-left corner will be used.
//-----------------------------------------------------------------------------
function DDSetColorKey(pdds: IDirectDrawSurface7; rgb: COLORREF): HRESULT;
var
  ddck: TDDColorKey;
begin
  ddck.dwColorSpaceLowValue := DDColorMatch(pdds, rgb);
  ddck.dwColorSpaceHighValue := ddck.dwColorSpaceLowValue;
  Result := pdds.SetColorKey(DDCKEY_SRCBLT, @ddck);
end;

function isGUID_NULL(iGUID: TGUID): Boolean;
begin
    Result := (iGUID.D1 = 0) and (iGUID.D2 = 0) and (iGUID.D3 = 0) and
        (iGUID.D4[0] = 0) and (iGUID.D4[1] = 0) and (iGUID.D4[2] = 0) and
        (iGUID.D4[3] = 0) and (iGUID.D4[4] = 0) and (iGUID.D4[5] = 0) and
        (iGUID.D4[6] = 0) and (iGUID.D4[7] = 0);
end;

function DSLoadSoundBuffer(var pDS: IDirectSound; lpName: LPCTSTR): IDirectSoundBuffer;
var
    pDSB: IDirectSoundBuffer;
    dsBD: TDSBUFFERDESC;
    pbWaveData: Pointer;
begin
    ZeroMemory(@dsBD, SizeOf(dsBD));

    pDSB := nil;
    pbWaveData := nil;

    if (DSGetWaveResource(0, lpName, dsBD.lpwfxFormat, pbWaveData, dsBD.dwBufferBytes)) then
    begin
        dsBD.dwSize := SizeOf(dsBD);
        dsBD.dwFlags := DSBCAPS_STATIC or DSBCAPS_CTRLDEFAULT or DSBCAPS_GETCURRENTPOSITION2;

        if pDS.CreateSoundBuffer(dsBD, pDSB, nil) = DS_OK then
        begin
            if not DSFillSoundBuffer(pDSB, pbWaveData, dsBD.dwBufferBytes) then
            begin
                pDSB.Release;
                pDSB := nil;
            end;
        end
        else
        begin
            pDSB := nil;
        end;
    end;

    Result := pDSB;
end;


function DSReloadSoundBuffer(var pDSB: IDirectSoundBuffer; lpName: LPCTSTR): Boolean;
var
    pbWaveData: Pointer;
    cbWaveSize: DWORD;
    dummy: PWAVEFORMATEX;
begin

    Result:= FALSE;
    pbWaveData := nil;
    cbWaveSize := 0;

    if DSGetWaveResource(0, lpName, dummy, pbWaveData, cbWaveSize) then
    begin
        if (pDSB.Restore = DS_OK) and (DSFillSoundBuffer(pDSB, pbWaveData, cbWaveSize)) then
            Result:= TRUE;
    end;
end;

function DSGetWaveResource(Module:HMODULE; lpName: LPCTSTR; var ppWaveHeader: PWAVEFORMATEX; var ppbWaveData: Pointer; var pcbWaveSize: DWORD): Boolean;
var
    hResInfo:HRSRC;
    hResData:HGLOBAL;
    pvRes:Pointer;

begin
    hResInfo := FindResource(Module, Pchar(lpName), c_szWAV);

    if hResInfo <> 0 then
     hResData := LoadResource(Module, hResInfo)
    else
     begin
       Result := FALSE;
       exit;
     end;

    pvRes := LockResource(hResData);
    if (pvRes <> nil) and
       DSParseWaveResource(pvRes, ppWaveHeader, ppbWaveData, pcbWaveSize)
     then
    else
     begin
        Result := FALSE;
        exit;
     end;

     Result := TRUE
end;


function SndObjCreate(var pDS: IDirectSound; lpName: LPCTSTR; iConcurrent: Longint): PSNDOBJ;
var
    pSO: PSNDOBJ;
    pWaveHeader: PWAVEFORMATEX;
    pbData: Pointer;
    cbData: DWORD;
    i: Longint;
begin
    if DSGetWaveResource(0, lpName,pWaveHeader, pbData, cbData) then
    begin
        if iConcurrent < 1 then iConcurrent:= 1;

        pSO := PSNDOBJ(LocalAlloc(LPTR, SizeOf(TSNDOBJ) + (iConcurrent-1) * SizeOf(IDirectSoundBuffer)));

        pSO^.iAlloc := iConcurrent;
        pSO^.pbWaveData := pbData;
        pSO^.cbWaveSize := cbData;
        pSO^.Buffers[0] := DSLoadSoundBuffer(pDS, lpName);

        for i := 1 to pSO^.iAlloc - 1 do
        begin
            if FAILED(pDS.DuplicateSoundBuffer(pSO^.Buffers[0], pSO^.Buffers[i])) then
            begin
              pSO^.Buffers[i] := DSLoadSoundBuffer(pDS, lpName);
              if pSO^.Buffers[i] <> nil then
              begin
                 SndObjDestroy(pSO);
                 pSO := nil;
                 break;
              end;
            end;
        end;
    end;

    Result := pSO;
end;

procedure SndObjDestroy(pSO: PSNDOBJ);
var
  i: Longint;
begin
  if (pSO <> nil ) then
  begin
    for i := 0 to pSO^.iAlloc - 1 do
    begin
      if pSO^.Buffers[i] <> nil then
      begin
        pSO^.Buffers[i].Release;
        pSO^.Buffers[i] := nil;
      end;
    end;
    LocalFree(THandle(pSO));
  end;
end;


function SndObjGetFreeBuffer(pSO: PSNDOBJ): IDirectSoundBuffer;
var
    pDSB: IDirectSoundBuffer;
    hres: HRESULT;
    dwStatus: DWORD;
begin

 if pSO = nil then
 begin
   Result := nil;
   exit;
 end;

 pDSB := pSO^.Buffers[pSO^.iCurrent];

 if pDSB <> nil then
 begin
   hres := pDSB.GetStatus(dwStatus);

   if (FAILED(hres)) then dwStatus := 0;

   if (dwStatus and DSBSTATUS_PLAYING) = DSBSTATUS_PLAYING then
      if pSO^.iAlloc > 1 then
      begin
        inc(pSO^.iCurrent);
        if (pSO^.iCurrent >= pSO^.iAlloc) then
            pSO^.iCurrent := 0;

            pDSB := pSO^.Buffers[pSO^.iCurrent];
            hres := pDSB.GetStatus(dwStatus);

            if SUCCEEDED(hres) and ((dwStatus and DSBSTATUS_PLAYING) = DSBSTATUS_PLAYING) then
            begin
                pDSB.Stop;
                pDSB.SetCurrentPosition(0);
            end;
      end
      else
         pDSB := nil;

   if (pDSB <> nil) and ((dwStatus and DSBSTATUS_BUFFERLOST) <> 0) then
    begin
        if FAILED(pDSB.Restore) or (not DSFillSoundBuffer(pDSB, pSO^.pbWaveData, pSO^.cbWaveSize)) then
           pDSB := nil;
    end;
 end;

 Result := pDSB;
end;

function SndObjPlay(pSO: PSNDOBJ; dwPlayFlags: DWORD): Boolean;
var
   pDSB: IDirectSoundBuffer;
begin
    if pSO = nil then
    begin
      Result := FALSE;
      exit;
    end;
    if ((dwPlayFlags and DSBPLAY_LOOPING) = 0) or (pSO^.iAlloc = 1) then
    begin
      pDSB := SndObjGetFreeBuffer(pSO);
      if (pDSB <> nil) then
         Result := SUCCEEDED(pDSB.Play(0, 0, dwPlayFlags));
    end else
      Result:= FALSE;
end;


function SndObjStop(pSO: PSNDOBJ): Boolean;
var
  i: Longint;
begin
   if pSO = nil then
   begin
     Result := FALSE;
     exit;
   end;
   for i:=0 to pSO^.iAlloc - 1 do
   begin
     pSO^.Buffers[i].Stop;
     pSO^.Buffers[i].SetCurrentPosition(0);
   end;
   Result := TRUE;
end;

function DSFillSoundBuffer(var pDSB: IDirectSoundBuffer; var pbWaveData: Pointer; cbWaveSize: DWORD): Boolean;
var
    pMem1, pMem2:Pointer;
    dwSize1, dwSize2:DWORD ;
begin
    if (pDSB <> nil) and (pbWaveData <> nil) and (cbWaveSize <> 0) then
    begin

        if (SUCCEEDED(pDSB.Lock(0, cbWaveSize,
            pMem1, dwSize1, pMem2, dwSize2, 0))) then
        begin
            CopyMemory(pMem1, pbWaveData, dwSize1);

            if ( 0 <> dwSize2 ) then
                CopyMemory(pMem2, Pointer(DWORD(pbWaveData) + dwSize1), dwSize2);

            if pDSB.Unlock(pMem1, dwSize1, pMem2, dwSize2) <> DS_OK then
              begin
               Result:=FALSE;
               exit;
              end;

            Result:=TRUE;
            exit;
        end;
    end;

    Result := FALSE;
end;

function DSParseWaveResource(pvRes: Pointer; var ppWaveHeader: PWAVEFORMATEX;
  var ppbWaveData: Pointer; var pcbWaveSize: DWORD): Boolean;

const
  FOURCC_WAVE = $45564157;
  FOURCC_DATA = $61746164;
  FOURCC_FMT  = $20746d66;

var
   pdw, pdwEnd: PDWORD;
   dwRiff, dwType, dwLength: DWORD;
   temp: DWORD;
begin
  pdw := PDWORD(pvRes);

  dwRiff :=pdw^;
  inc(pdw);

  dwLength :=pdw^;
  inc(pdw);

  dwType :=pdw^;
  inc(pdw);

  //not a RIFF
  if dwRiff <> FOURCC_RIFF then
  begin
      Result := FALSE;
      exit;
  end;

  // not a WAV
  if dwType <> FOURCC_WAVE then
  begin
      Result := FALSE;
      exit;
  end;

  pdwEnd := PDWORD(PBYTE(Longint(pdw) + Longint(dwLength)-4));

  while Longint(pdw) < Longint(pdwEnd) do
  begin
    dwType :=pdw^;
    inc(pdw);

    dwLength :=pdw^;
    inc(pdw);

    case dwType of
    FOURCC_FMT:
        begin
          if ppWaveHeader = nil then
          begin
              if (dwLength < SizeOf(TWAVEFORMAT)) then
              begin
                  Result := FALSE;
                  exit;
              end;

              ppWaveHeader:=PWAVEFORMATEX(pdw);

              if (ppbWaveData <> nil) and (pcbWaveSize <> 0) then
              begin
                  Result := TRUE;
                  exit;
              end;
          end;
        end;

    FOURCC_DATA:
        begin
          if (ppbWaveData = nil) and (pcbWaveSize = 0) then
          begin
              ppbWaveData := pdw;
              pcbWaveSize := dwLength;

              if ppWaveHeader<>nil then
              begin
                 Result := TRUE;
                 exit;
              end;
          end;
        end;
    end;

    temp:=(dwLength + 1) and (not $1);
    pdw := PDWORD(PBYTE(DWORD(pdw) + temp ));

  end;
end;

begin
{$IFDEF UNICODE}
  _tcscpy := StrCopyW;
{$ELSE}
{$system}
  _tcscpy := StrCopyA;
{$ENDIF}
end.