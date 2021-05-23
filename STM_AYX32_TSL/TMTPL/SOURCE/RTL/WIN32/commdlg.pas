(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit API Interface Unit                       *)
(*       Based on commdlg.h                                     *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995-98 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit CommDlg;

(**********************************************************************)
(*                                                                    *)
(*  commdlg.pas -- This module defines the 32-Bit Common Dialog APIs  *)
(*                                                                    *)
(**********************************************************************)

interface

uses Windows, Messages;

const
  OFN_READONLY = $00000001;
  OFN_OVERWRITEPROMPT = $00000002;
  OFN_HIDEREADONLY = $00000004;
  OFN_NOCHANGEDIR = $00000008;
  OFN_SHOWHELP = $00000010;
  OFN_ENABLEHOOK = $00000020;
  OFN_ENABLETEMPLATE = $00000040;
  OFN_ENABLETEMPLATEHANDLE = $00000080;
  OFN_NOVALIDATE = $00000100;
  OFN_ALLOWMULTISELECT = $00000200;
  OFN_EXTENSIONDIFFERENT = $00000400;
  OFN_PATHMUSTEXIST = $00000800;
  OFN_FILEMUSTEXIST = $00001000;
  OFN_CREATEPROMPT = $00002000;
  OFN_SHAREAWARE = $00004000;
  OFN_NOREADONLYRETURN = $00008000;
  OFN_NOTESTFILECREATE = $00010000;
  OFN_NONETWORKBUTTON = $00020000;
  OFN_NOLONGNAMES = $00040000;
  OFN_EXPLORER = $00080000;
  OFN_NODEREFERENCELINKS = $00100000;
  OFN_LONGNAMES = $00200000;
  OFN_ENABLEINCLUDENOTIFY = $00400000;
  OFN_ENABLESIZING = $00800000;

  OFN_SHAREFALLTHROUGH = 2;
  OFN_SHARENOWARN = 1;
  OFN_SHAREWARN = 0;

  CDN_FIRST = -601;
  CDN_LAST = -699;

  CDN_INITDONE = CDN_FIRST - 0;
  CDN_SELCHANGE = CDN_FIRST - 1;
  CDN_FOLDERCHANGE = CDN_FIRST - 2;
  CDN_SHAREVIOLATION = CDN_FIRST - 3;
  CDN_HELP = CDN_FIRST - 4;
  CDN_FILEOK = CDN_FIRST - 5;
  CDN_TYPECHANGE = CDN_FIRST - 6;
  CDN_INCLUDEITEM = CDN_FIRST - 7;

  CDM_FIRST = WM_USER + 100;
  CDM_LAST = WM_USER + 200;
  CDM_GETSPEC = CDM_FIRST + 0;
  CDM_GETFILEPATH = CDM_FIRST + 1;
  CDM_GETFOLDERPATH = CDM_FIRST + 2;
  CDM_GETFOLDERIDLIST = CDM_FIRST + 3;
  CDM_SETCONTROLTEXT = CDM_FIRST + 4;
  CDM_HIDECONTROL = CDM_FIRST + 5;
  CDM_SETDEFEXT = CDM_FIRST + 6;
  CC_RGBINIT = $00000001;
  CC_FULLOPEN = $00000002;
  CC_PREVENTFULLOPEN = $00000004;
  CC_SHOWHELP = $00000008;
  CC_ENABLEHOOK = $00000010;
  CC_ENABLETEMPLATE = $00000020;
  CC_ENABLETEMPLATEHANDLE = $00000040;
  CC_SOLIDCOLOR = $00000080;
  CC_ANYCOLOR = $00000100;
  FR_DOWN = $00000001;
  FR_WHOLEWORD = $00000002;
  FR_MATCHCASE = $00000004;
  FR_FINDNEXT = $00000008;
  FR_REPLACE = $00000010;
  FR_REPLACEALL = $00000020;
  FR_DIALOGTERM = $00000040;
  FR_SHOWHELP = $00000080;
  FR_ENABLEHOOK = $00000100;
  FR_ENABLETEMPLATE = $00000200;
  FR_NOUPDOWN = $00000400;
  FR_NOMATCHCASE = $00000800;
  FR_NOWHOLEWORD = $00001000;
  FR_ENABLETEMPLATEHandle = $00002000;
  FR_HIDEUPDOWN = $00004000;
  FR_HIDEMATCHCASE = $00008000;
  FR_HIDEWHOLEWORD = $00010000;
  CF_SCREENFONTS = $00000001;
  CF_PRINTERFONTS = $00000002;
  CF_BOTH = CF_SCREENFONTS OR CF_PRINTERFONTS;
  CF_SHOWHELP = $00000004;
  CF_ENABLEHOOK = $00000008;
  CF_ENABLETEMPLATE = $00000010;
  CF_ENABLETEMPLATEHANDLE = $00000020;
  CF_INITTOLOGFONTSTRUCT = $00000040;
  CF_USESTYLE = $00000080;
  CF_EFFECTS = $00000100;
  CF_APPLY = $00000200;
  CF_ANSIONLY = $00000400;
  CF_SCRIPTSONLY = CF_ANSIONLY;
  CF_NOVECTORFONTS = $00000800;
  CF_NOOEMFONTS = CF_NOVECTORFONTS;
  CF_NOSIMULATIONS = $00001000;
  CF_LIMITSIZE = $00002000;
  CF_FIXEDPITCHONLY = $00004000;
  CF_WYSIWYG = $00008000;
  CF_FORCEFONTEXIST = $00010000;
  CF_SCALABLEONLY = $00020000;
  CF_TTONLY = $00040000;
  CF_NOFACESEL = $00080000;
  CF_NOSTYLESEL = $00100000;
  CF_NOSIZESEL = $00200000;
  CF_SELECTSCRIPT = $00400000;
  CF_NOSCRIPTSEL = $00800000;
  CF_NOVERTFONTS = $01000000;

  SIMULATED_FONTTYPE = $8000;
  PRINTER_FONTTYPE = $4000;
  SCREEN_FONTTYPE = $2000;
  BOLD_FONTTYPE = $0100;
  ITALIC_FONTTYPE = $0200;
  REGULAR_FONTTYPE = $0400;
  OPENTYPE_FONTTYPE = $10000;
  TYPE1_FONTTYPE = $20000;
  DSIG_FONTTYPE = $40000;

  WM_CHOOSEFONT_GETLOGFONT = WM_USER + 1;
  WM_CHOOSEFONT_SETLOGFONT = WM_USER + 101;
  WM_CHOOSEFONT_SETFLAGS   = WM_USER + 102;

  LBSELCHSTRING = 'commdlg_LBSelChangedNotify';
  SHAREVISTRING = 'commdlg_ShareViolation';
  FILEOKSTRING  = 'commdlg_FileNameOK';
  COLOROKSTRING = 'commdlg_ColorOK';
  SETRGBSTRING  = 'commdlg_SetRGBColor';
  FINDMSGSTRING = 'commdlg_FindReplace';
  HELPMSGSTRING = 'commdlg_help';

  CD_LBSELNOITEMS = -1;
  CD_LBSELCHANGE  = 0;
  CD_LBSELSUB     = 1;
  CD_LBSELADD     = 2;
  PD_ALLPAGES = $00000000;
  PD_SELECTION = $00000001;
  PD_PAGENUMS = $00000002;
  PD_NOSELECTION = $00000004;
  PD_NOPAGENUMS = $00000008;
  PD_COLLATE = $00000010;
  PD_PRINTTOFILE = $00000020;
  PD_PRINTSETUP = $00000040;
  PD_NOWARNING = $00000080;
  PD_RETURNDC = $00000100;
  PD_RETURNIC = $00000200;
  PD_RETURNDEFAULT = $00000400;
  PD_SHOWHELP = $00000800;
  PD_ENABLEPRINTHOOK = $00001000;
  PD_ENABLESETUPHOOK = $00002000;
  PD_ENABLEPRINTTEMPLATE = $00004000;
  PD_ENABLESETUPTEMPLATE = $00008000;
  PD_ENABLEPRINTTEMPLATEHANDLE = $00010000;
  PD_ENABLESETUPTEMPLATEHANDLE = $00020000;
  PD_USEDEVMODECOPIES = $00040000;
  PD_USEDEVMODECOPIESANDCOLLATE = $00040000;
  PD_DISABLEPRINTTOFILE = $00080000;
  PD_HIDEPRINTTOFILE = $00100000;
  PD_NONETWORKBUTTON = $00200000;
  DN_DEFAULTPRN = $0001;

  WM_PSD_PAGESETUPDLG     = WM_USER;
  WM_PSD_FULLPAGERECT     = WM_USER + 1;
  WM_PSD_MINMARGINRECT    = WM_USER + 2;
  WM_PSD_MARGINRECT       = WM_USER + 3;
  WM_PSD_GREEKTEXTRECT    = WM_USER + 4;
  WM_PSD_ENVSTAMPRECT     = WM_USER + 5;
  WM_PSD_YAFULLPAGERECT   = WM_USER + 6;

  PSD_DEFAULTMINMARGINS             = $00000000;
  PSD_INWININIINTLMEASURE           = $00000000;
  PSD_MINMARGINS                    = $00000001;
  PSD_MARGINS                       = $00000002;
  PSD_INTHOUSANDTHSOFINCHES         = $00000004;
  PSD_INHUNDREDTHSOFMILLIMETERS     = $00000008;
  PSD_DISABLEMARGINS                = $00000010;
  PSD_DISABLEPRINTER                = $00000020;
  PSD_NOWARNING                     = $00000080;
  PSD_DISABLEORIENTATION            = $00000100;
  PSD_RETURNDEFAULT                 = $00000400;
  PSD_DISABLEPAPER                  = $00000200;
  PSD_SHOWHELP                      = $00000800;
  PSD_ENABLEPAGESETUPHOOK           = $00002000;
  PSD_ENABLEPAGESETUPTEMPLATE       = $00008000;
  PSD_ENABLEPAGESETUPTEMPLATEHANDLE = $00020000;
  PSD_ENABLEPAGEPAINTHOOK           = $00040000;
  PSD_DISABLEPAGEPAINTING           = $00080000;
  PSD_NONETWORKBUTTON               = $00200000;

  CDERR_DIALOGFAILURE    = $FFFF;
  CDERR_GENERALCODES     = $0000;
  CDERR_STRUCTSIZE       = $0001;
  CDERR_INITIALIZATION   = $0002;
  CDERR_NOTEMPLATE       = $0003;
  CDERR_NOHINSTANCE      = $0004;
  CDERR_LOADSTRFAILURE   = $0005;
  CDERR_FINDRESFAILURE   = $0006;
  CDERR_LOADRESFAILURE   = $0007;
  CDERR_LOCKRESFAILURE   = $0008;
  CDERR_MEMALLOCFAILURE  = $0009;
  CDERR_MEMLOCKFAILURE   = $000A;
  CDERR_NOHOOK           = $000B;
  CDERR_REGISTERMSGFAIL  = $000C;

  PDERR_PRINTERCODES     = $1000;
  PDERR_SETUPFAILURE     = $1001;
  PDERR_PARSEFAILURE     = $1002;
  PDERR_RETDEFFAILURE    = $1003;
  PDERR_LOADDRVFAILURE   = $1004;
  PDERR_GETDEVMODEFAIL   = $1005;
  PDERR_INITFAILURE      = $1006;
  PDERR_NODEVICES        = $1007;
  PDERR_NODEFAULTPRN     = $1008;
  PDERR_DNDMMISMATCH     = $1009;
  PDERR_CREATEICFAILURE  = $100A;
  PDERR_PRINTERNOTFOUND  = $100B;
  PDERR_DEFAULTDIFFERENT = $100C;

  CFERR_CHOOSEFONTCODES  = $2000;
  CFERR_NOFONTS          = $2001;
  CFERR_MAXLESSTHANMIN   = $2002;
  FNERR_FILENAMECODES    = $3000;
  FNERR_SUBCLASSFAILURE  = $3001;
  FNERR_INVALIDFILENAME  = $3002;
  FNERR_BUFFERTOOSMALL   = $3003;
  FRERR_FINDREPLACECODES = $4000;
  FRERR_BUFFERLENGTHZERO = $4001;
  CCERR_CHOOSECOLORCODES = $5000;

type
  tagOFNA = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HINST;
    lpstrFilter: PAnsiChar;
    lpstrCustomFilter: PAnsiChar;
    nMaxCustFilter: DWORD;
    nFilterIndex: DWORD;
    lpstrFile: PAnsiChar;
    nMaxFile: DWORD;
    lpstrFileTitle: PAnsiChar;
    nMaxFileTitle: DWORD;
    lpstrInitialDir: PAnsiChar;
    lpstrTitle: PAnsiChar;
    Flags: DWORD;
    nFileOffset: Word;
    nFileExtension: Word;
    lpstrDefExt: PAnsiChar;
    lCustData: LPARAM;
    lpfnHook: function conv arg_stdcall (Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpTemplateName: PAnsiChar;
  end;
  tagOFNW = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HINST;
    lpstrFilter: PWideChar;
    lpstrCustomFilter: PWideChar;
    nMaxCustFilter: DWORD;
    nFilterIndex: DWORD;
    lpstrFile: PWideChar;
    nMaxFile: DWORD;
    lpstrFileTitle: PWideChar;
    nMaxFileTitle: DWORD;
    lpstrInitialDir: PWideChar;
    lpstrTitle: PWideChar;
    Flags: DWORD;
    nFileOffset: Word;
    nFileExtension: Word;
    lpstrDefExt: PWideChar;
    lCustData: LPARAM;
    lpfnHook: function conv arg_stdcall (Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpTemplateName: PWideChar;
  end;
  tagOFN = tagOFNA;
  TOpenFilenameA = tagOFNA;
  TOpenFilenameW = tagOFNW;
  TOpenFilename = TOpenFilenameA;
  POpenFilenameA = ^TOpenFilenameA;
  POpenFilenameW = ^TOpenFilenameW;
  POpenFilename = POpenFilenameA;
  OPENFILENAMEA = tagOFNA;
  OPENFILENAMEW = tagOFNW;
  OPENFILENAME = OPENFILENAMEA;
  POFNotifyA = ^TOFNotifyA;
  POFNotifyW = ^TOFNotifyW;
  POFNotify = POFNotifyA;
  _OFNOTIFYA = packed record
    hdr: TNMHdr;
    lpOFN: POpenFilenameA;
    pszFile: PAnsiChar;
  end;
  _OFNOTIFYW = packed record
    hdr: TNMHdr;
    lpOFN: POpenFilenameW;
    pszFile: PWideChar;
  end;
  _OFNOTIFY = _OFNOTIFYA;
  TOFNotifyA = _OFNOTIFYA;
  TOFNotifyW = _OFNOTIFYW;
  TOFNotify = TOFNotifyA;
  OFNOTIFYA = _OFNOTIFYA;
  OFNOTIFYW = _OFNOTIFYW;
  OFNOTIFY = OFNOTIFYA;
  PChooseColorA = ^TChooseColorA;
  PChooseColorW = ^TChooseColorW;
  PChooseColor = PChooseColorA;
  tagCHOOSECOLORA = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HWND;
    rgbResult: COLORREF;
    lpCustColors: ^COLORREF;
    Flags: DWORD;
    lCustData: LPARAM;
    lpfnHook: function conv arg_stdcall (Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpTemplateName: PAnsiChar;
  end;
  tagCHOOSECOLORW = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HWND;
    rgbResult: COLORREF;
    lpCustColors: ^COLORREF;
    Flags: DWORD;
    lCustData: LPARAM;
    lpfnHook: function conv arg_stdcall (Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpTemplateName: PWideChar;
  end;
  tagCHOOSECOLOR = tagCHOOSECOLORA;
  TChooseColorA = tagCHOOSECOLORA;
  TChooseColorW = tagCHOOSECOLORW;
  TChooseColor = TChooseColorA;

  PFindReplaceA = ^TFindReplaceA;
  PFindReplaceW = ^TFindReplaceW;
  PFindReplace = PFindReplaceA;
  tagFINDREPLACEA = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HINST;
    Flags: DWORD;
    lpstrFindWhat: PAnsiChar;
    lpstrReplaceWith: PAnsiChar;
    wFindWhatLen: Word;
    wReplaceWithLen: Word;
    lCustData: LPARAM;
    lpfnHook: function conv arg_stdcall (Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpTemplateName: PAnsiChar;
  end;
  tagFINDREPLACEW = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HINST;
    Flags: DWORD;
    lpstrFindWhat: PWideChar;
    lpstrReplaceWith: PWideChar;
    wFindWhatLen: Word;
    wReplaceWithLen: Word;
    lCustData: LPARAM;
    lpfnHook: function conv arg_stdcall (Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpTemplateName: PWideChar;
  end;
  tagFINDREPLACE = tagFINDREPLACEA;
  TFindReplaceA = tagFINDREPLACEA;
  TFindReplaceW = tagFINDREPLACEW;
  TFindReplace = TFindReplaceA;
  FINDREPLACEA = tagFINDREPLACEA;
  FINDREPLACEW = tagFINDREPLACEW;
  FINDREPLACE = FINDREPLACEA;
  PChooseFontA = ^TChooseFontA;
  PChooseFontW = ^TChooseFontW;
  PChooseFont = PChooseFontA;
  tagCHOOSEFONTA = packed record
    lStructSize: DWORD;
    hWndOwner: HWnd;
    hDC: HDC;
    lpLogFont: PLogFontA;
    iPointSize: Longint;
    Flags: DWORD;
    rgbColors: COLORREF;
    lCustData: LPARAM;
    lpfnHook: function conv arg_stdcall (Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpTemplateName: PAnsiChar;
    hInstance: HINST;
    lpszStyle: PAnsiChar;
    nFontType: Word;
    wReserved: Word;
    nSizeMin: Longint;
    nSizeMax: Longint;
  end;
  tagCHOOSEFONTW = packed record
    lStructSize: DWORD;
    hWndOwner: HWnd;
    hDC: HDC;
    lpLogFont: PLogFontW;
    iPointSize: Longint;
    Flags: DWORD;
    rgbColors: COLORREF;
    lCustData: LPARAM;
    lpfnHook: function conv arg_stdcall (Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpTemplateName: PWideChar;
    hInstance: HINST;
    lpszStyle: PWideChar;
    nFontType: Word;
    wReserved: Word;
    nSizeMin: Longint;
    nSizeMax: Longint;
  end;
  tagCHOOSEFONT = tagCHOOSEFONTA;
  TChooseFontA = tagCHOOSEFONTA;
  TChooseFontW = tagCHOOSEFONTW;
  TChooseFont = TChooseFontA;
  PPrintDlgA = ^TPrintDlgA;
  PPrintDlgW = ^TPrintDlgW;
  PPrintDlg = PPrintDlgA;
  tagPDA = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hDevMode: HGLOBAL;
    hDevNames: HGLOBAL;
    hDC: HDC;
    Flags: DWORD;
    nFromPage: Word;
    nToPage: Word;
    nMinPage: Word;
    nMaxPage: Word;
    nCopies: Word;
    hInstance: HINST;
    lCustData: LPARAM;
    lpfnPrintHook: function conv arg_stdcall (Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpfnSetupHook: function conv arg_stdcall (Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpPrintTemplateName: PAnsiChar;
    lpSetupTemplateName: PAnsiChar;
    hPrintTemplate: HGLOBAL;
    hSetupTemplate: HGLOBAL;
  end;
  tagPDW = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hDevMode: HGLOBAL;
    hDevNames: HGLOBAL;
    hDC: HDC;
    Flags: DWORD;
    nFromPage: Word;
    nToPage: Word;
    nMinPage: Word;
    nMaxPage: Word;
    nCopies: Word;
    hInstance: HINST;
    lCustData: LPARAM;
    lpfnPrintHook: function conv arg_stdcall (Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpfnSetupHook: function conv arg_stdcall (Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpPrintTemplateName: PWideChar;
    lpSetupTemplateName: PWideChar;
    hPrintTemplate: HGLOBAL;
    hSetupTemplate: HGLOBAL;
  end;
  tagPD = tagPDA;
  TPrintDlgA = tagPDA;
  TPrintDlgW = tagPDW;
  TPrintDlg = TPrintDlgA;
  PDevNames = ^TDevNames;
  tagDEVNAMES = record
    wDriverOffset: Word;
    wDeviceOffset: Word;
    wOutputOffset: Word;
    wDefault: Word;
  end;
  TDevNames = tagDEVNAMES;
  DEVNAMES = tagDEVNAMES;
  PPageSetupDlgA = ^TPageSetupDlgA;
  PPageSetupDlgW = ^TPageSetupDlgW;
  PPageSetupDlg = PPageSetupDlgA;
  tagPSDA = packed record
    lStructSize: DWORD;
    hwndOwner: HWND;
    hDevMode: HGLOBAL;
    hDevNames: HGLOBAL;
    Flags: DWORD;
    ptPaperSize: TPoint;
    rtMinMargin: TRect;
    rtMargin: TRect;
    hInstance: HINST;
    lCustData: LPARAM;
    lpfnPageSetupHook: function conv arg_stdcall (Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpfnPagePaintHook: function conv arg_stdcall (Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpPageSetupTemplateName: PAnsiChar;
    hPageSetupTemplate: HGLOBAL;
  end;
  tagPSDW = packed record
    lStructSize: DWORD;
    hwndOwner: HWND;
    hDevMode: HGLOBAL;
    hDevNames: HGLOBAL;
    Flags: DWORD;
    ptPaperSize: TPoint;
    rtMinMargin: TRect;
    rtMargin: TRect;
    hInstance: HINST;
    lCustData: LPARAM;
    lpfnPageSetupHook: function conv arg_stdcall (Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpfnPagePaintHook: function conv arg_stdcall (Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT;
    lpPageSetupTemplateName: PWideChar;
    hPageSetupTemplate: HGLOBAL;
  end;
  tagPSD = tagPSDA;
  TPageSetupDlgA = tagPSDA;
  TPageSetupDlgW = tagPSDW;
  TPageSetupDlg = TPageSetupDlgA;

function GetOpenFileNameA conv arg_stdcall (var OpenFile: TOpenFilenameA): Bool;
  external 'comdlg32.dll' name 'GetOpenFileNameA';
function GetOpenFileNameW conv arg_stdcall (var OpenFile: TOpenFilenameW): Bool;
  external 'comdlg32.dll' name 'GetOpenFileNameW';
function GetOpenFileName conv arg_stdcall (var OpenFile: TOpenFilename): Bool;
  external 'comdlg32.dll' name 'GetOpenFileNameA';
function  GetSaveFileNameA conv arg_stdcall (var OpenFile: TOpenFilenameA): Bool;
  external 'comdlg32.dll' name 'GetSaveFileNameA';
function  GetSaveFileNameW conv arg_stdcall (var OpenFile: TOpenFilenameW): Bool;
  external 'comdlg32.dll' name 'GetSaveFileNameW';
function  GetSaveFileName conv arg_stdcall (var OpenFile: TOpenFilename): Bool;
  external 'comdlg32.dll' name 'GetSaveFileNameA';
function  GetFileTitleA conv arg_stdcall (FileName: PAnsiChar; Title: PAnsiChar; TitleSize: Word): Smallint;
  external 'comdlg32.dll' name 'GetFileTitleA';
function  GetFileTitleW conv arg_stdcall (FileName: PWideChar; Title: PWideChar; TitleSize: Word): Smallint;
  external 'comdlg32.dll' name 'GetFileTitleW';
function  GetFileTitle conv arg_stdcall (FileName: PChar; Title: PChar; TitleSize: Word): Smallint;
  external 'comdlg32.dll' name 'GetFileTitleA';
function  ChooseColorA conv arg_stdcall (var CC: TChooseColorA): Bool;
  external 'comdlg32.dll'  name 'ChooseColorA';
function  ChooseColorW conv arg_stdcall (var CC: TChooseColorW): Bool;
  external 'comdlg32.dll'  name 'ChooseColorW';
function  ChooseColor conv arg_stdcall (var CC: TChooseColor): Bool;
  external 'comdlg32.dll'  name 'ChooseColorA';
function  FindTextA conv arg_stdcall (var FindReplace: TFindReplaceA): HWND;
  external 'comdlg32.dll'  name 'FindTextA';
function  FindTextW conv arg_stdcall (var FindReplace: TFindReplaceW): HWND;
  external 'comdlg32.dll'  name 'FindTextW';
function  FindText conv arg_stdcall (var FindReplace: TFindReplace): HWND;
  external 'comdlg32.dll' name 'FindTextA';
function  ReplaceTextA conv arg_stdcall (var FindReplace: TFindReplaceA): HWND;
  external 'comdlg32.dll' name 'ReplaceTextA';
function  ReplaceTextW conv arg_stdcall (var FindReplace: TFindReplaceW): HWND;
  external 'comdlg32.dll' name 'ReplaceTextW';
function  ReplaceText conv arg_stdcall (var FindReplace: TFindReplace): HWND;
  external 'comdlg32.dll' name 'ReplaceTextA';
function  ChooseFontA conv arg_stdcall (var ChooseFont: TChooseFontA): Bool;
  external 'comdlg32.dll' name 'ChooseFontA';
function  ChooseFontW conv arg_stdcall (var ChooseFont: TChooseFontW): Bool;
  external 'comdlg32.dll' name 'ChooseFontW';
function  ChooseFont conv arg_stdcall (var ChooseFont: TChooseFont): Bool;
  external 'comdlg32.dll' name 'ChooseFontA';
function  PrintDlgA conv arg_stdcall (var PrintDlg: TPrintDlgA): Bool;
  external 'comdlg32.dll' name 'PrintDlgA';
function  PrintDlgW conv arg_stdcall (var PrintDlg: TPrintDlgW): Bool;
  external 'comdlg32.dll' name 'PrintDlgW';
function  PrintDlg conv arg_stdcall (var PrintDlg: TPrintDlg): Bool;
  external 'comdlg32.dll' name 'PrintDlgA';
function  CommDlgExtendedError: DWORD;
  external 'comdlg32.dll' name 'CommDlgExtendedError';
function  PageSetupDlgA conv arg_stdcall (var PgSetupDialog: TPageSetupDlgA): BOOL;
  external 'comdlg32.dll' name 'PageSetupDlgA';
function  PageSetupDlgW conv arg_stdcall (var PgSetupDialog: TPageSetupDlgW): BOOL;
  external 'comdlg32.dll' name 'PageSetupDlgW';
function  PageSetupDlg conv arg_stdcall (var PgSetupDialog: TPageSetupDlg): BOOL;
  external 'comdlg32.dll' name 'PageSetupDlgA';

implementation

end.
