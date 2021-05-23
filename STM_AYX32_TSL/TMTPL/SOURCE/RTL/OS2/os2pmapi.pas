(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       OS/2 API Interface Unit                                *)
(*       Targets: OS/2 only                                     *)
(*                                                              *)
(*       Copyright (c) 1995,98 TMT Development Corporation      *)
(*       Portions Copyright (c) by IBM Corporation              *)
(*       Author: Anton Moscal                                   *)
(*                                                              *)
(****************************************************************)

unit Os2PmApi;

interface

uses os2types, os2ord;

{----[ PMWIN ]----}

{ General Window Management types and constants }

type
  MParam    = Longint;
  PMParam   = ^MParam;
  MResult   = Longint;
  PMResult  = ^MResult;

{ This is the standard function definition for window procedures.             }
{ Typically they are named like "XxxxxxxxWndProc", where the prefix           }
{ "Xxxxxxxxx" is replaced by some name descriptive of the window procedure    }
{ being declared.  Window procedures must be EXPORTED in the definitions      }
{ file used by the linker.                                                    }

type
  FnWp = function conv arg_cdecl (Wnd: HWnd; Msg: ULong; Mp1,Mp2: MParam): MResult;

{ Predefined window handles }
const
  hwnd_Desktop                  = HWnd(1);
  hwnd_Object                   = HWnd(2);
  hwnd_Top                      = HWnd(3);
  hwnd_Bottom                   = HWnd(4);
  hwnd_ThreadCapture            = HWnd(5);

{ Standard Window Classes }
  wc_Frame                      = PChar($FFFF0001);
  wc_ComboBox                   = PChar($FFFF0002);
  wc_Button                     = PChar($FFFF0003);
  wc_Menu                       = PChar($FFFF0004);
  wc_Static                     = PChar($FFFF0005);
  wc_EntryField                 = PChar($FFFF0006);
  wc_ListBox                    = PChar($FFFF0007);
  wc_ScrollBar                  = PChar($FFFF0008);
  wc_TitleBar                   = PChar($FFFF0009);
  wc_Mle                        = PChar($FFFF000A);
  { 000B to 000F reserved}
  wc_AppStat                    = PChar($FFFF0010);
  wc_KbdStat                    = PChar($FFFF0011);
  wc_Pecic                      = PChar($FFFF0012);
  wc_Dbe_kkPopup                = PChar($FFFF0013);
  { 0014 to 001f reserved}
  wc_SpinButton                 = PChar($FFFF0020);
  { 0021 to 0024 reserved}
  wc_Container                  = PChar($FFFF0025);
  wc_Slider                     = PChar($FFFF0026);
  wc_ValueSet                   = PChar($FFFF0027);
  wc_NoteBook                   = PChar($FFFF0028);
  { 0029 to 003F reserved}

{ Standard Window Styles }
  ws_Visible                    = $80000000;
  ws_Disabled                   = $40000000;
  ws_ClipChildren               = $20000000;
  ws_ClipSiblings               = $10000000;
  ws_ParentClip                 = $08000000;
  ws_SaveBits                   = $04000000;
  ws_SyncPaint                  = $02000000;
  ws_Minimized                  = $01000000;
  ws_Maximized                  = $00800000;
  ws_Animate                    = $00400000;

{ Dialog manager styles }
  ws_Group                      = $00010000;
  ws_TabStop                    = $00020000;
  ws_MultiSelect                = $00040000;

{ Class styles }
  cs_MoveNotify                 = $00000001;
  cs_SizeRedraw                 = $00000004;
  cs_HitTest                    = $00000008;
  cs_Public                     = $00000010;
  cs_Frame                      = $00000020;
  cs_ClipChildren               = $20000000;
  cs_ClipSiblings               = $10000000;
  cs_ParentClip                 = $08000000;
  cs_SaveBits                   = $04000000;
  cs_SyncPaint                  = $02000000;

function WinRegisterClass conv arg_os2 (Ab: Hab; ClassName: PChar; WndProc: FnWp;
  flStyle,cbWindowData: ULong): Bool; external 'PMWIN' index ord_Win32RegisterClass;
function WinDefWindowProc conv arg_cdecl (Wnd: HWnd; Msg: ULong; Mp1,Mp2: MParam): MResult; external 'PMWIN' index ord_Win32DefWindowProc;
function WinDestroyWindow conv arg_os2 (Wnd: HWnd): Bool; external 'PMWIN' index ord_Win32DestroyWindow;
function WinShowWindow conv arg_os2 (Wnd: HWnd; fShow: Bool): Bool; external 'PMWIN' index ord_Win32ShowWindow;
function WinQueryWindowRect conv arg_os2 (Wnd: HWnd; var R: RectL): Bool; external 'PMWIN' index ord_Win32QueryWindowRect;
function WinGetPS conv arg_os2 (Wnd: HWnd): Hps; external 'PMWIN' index ord_Win32GetPS;
function WinReleasePS conv arg_os2 (PS: Hps): Bool; external 'PMWIN' index ord_Win32ReleasePS;
function WinEndPaint conv arg_os2 (PS: Hps): Bool; external 'PMWIN' index ord_Win32EndPaint;
function WinGetClipPS conv arg_os2 (Wnd: HWnd; WndClip: HWnd; Flags: ULong): Hps; external 'PMWIN' index ord_Win32GetClipPS;
function WinIsWindowShowing conv arg_os2 (Wnd: HWnd): Bool; external 'PMWIN' index ord_Win32IsWindowShowing;
function WinBeginPaint conv arg_os2 (Wnd: HWnd; PS: Hps; R: PRectL): Hps; external 'PMWIN' index ord_Win32BeginPaint;
function WinOpenWindowDC conv arg_os2 (Wnd: HWnd): Hdc; external 'PMWIN' index ord_Win32OpenWindowDC;
function WinScrollWindow conv arg_os2 (Wnd: HWnd; dX, dY: Long; Scroll: PRectL; Clip: PRectL;
  RgnUpdate: HRgn; Update: PRectL; rgfsw: ULong): Long; external 'PMWIN' index ord_Win32ScrollWindow;

{ WinGetClipPS flags }
const
  psf_LockWindowUpdate          = $0001;
  psf_ClipUpwards               = $0002;
  psf_ClipDownwards             = $0004;
  psf_ClipSiblings              = $0008;
  psf_ClipChildren              = $0010;
  psf_ParentClip                = $0020;

{ WinScrollWindow flags }
  sw_ScrollChildren             = $0001;
  sw_InvalidateRgn              = $0002;

function WinFillRect conv arg_os2 (PS: Hps; var R: RectL; Color: Long): Bool; external 'PMWIN' index ord_Win32FillRect;


{ WinInitialize/WinTerminate Interface declarations }

type
  PQVersData = ^QVersData;
  QVersData = record
    Environment: Word;
    Version:     Word;
  end;

const
  qv_OS2                        = $0000;
  qv_CMS                        = $0001;
  qv_TSO                        = $0002;
  qv_TSOBatch                   = $0003;
  qv_OS400                      = $0004;

function WinQueryVersion conv arg_os2 (AB: Hab): ULong; external 'PMWIN' index ord_Win32QueryVersion;
function WinInitialize conv arg_os2 (Options: ULong): Hab; external 'PMWIN' index ord_Win32Initialize;
function WinTerminate conv arg_os2 (AB: Hab): Bool; external 'PMWIN' index ord_Win32Terminate;
function WinQueryAnchorBlock conv arg_os2 (Wnd: HWnd): Hab; external 'PMWIN' index ord_Win32QueryAnchorBlock;
function WinCreateWindow conv arg_os2 (Parent: HWnd; Class: PChar; Name: PChar; Style: ULong;
  X,Y,cX,cY: Long; Owner: HWnd; InsertBehind: HWnd; Id: ULong;
  CtlData,PresParams: Pointer): HWnd; external 'PMWIN' index ord_Win32CreateWindow;
function WinEnableWindow conv arg_os2 (Wnd: HWnd; Enable: Bool): Bool; external 'PMWIN' index ord_Win32EnableWindow;
function WinIsWindowEnabled conv arg_os2 (Wnd: HWnd): Bool; external 'PMWIN' index ord_Win32IsWindowEnabled;
function WinEnableWindowUpdate conv arg_os2 (Wnd: HWnd; Enable: Bool): Bool; external 'PMWIN' index ord_Win32EnableWindowUpdate;
function WinIsWindowVisible conv arg_os2 (Wnd: HWnd): Bool; external 'PMWIN' index ord_Win32IsWindowVisible;
function WinQueryWindowText conv arg_os2 (Wnd: HWnd; BufferMax: Long; Buffer: PChar): Long; external 'PMWIN' index ord_Win32QueryWindowText;
function WinSetWindowText conv arg_os2 (Wnd: HWnd; Text: PChar): Bool; external 'PMWIN' index ord_Win32SetWindowText;
function WinQueryWindowTextLength conv arg_os2 (Wnd: HWnd): Long; external 'PMWIN' index ord_Win32QueryWindowTextLength;
function WinWindowFromID conv arg_os2 (Parent: HWnd; Id: ULong): HWnd; external 'PMWIN' index ord_Win32WindowFromID;
function WinIsWindow conv arg_os2 (AB: Hab; Wnd: HWnd): Bool; external 'PMWIN' index ord_Win32IsWindow;
function WinQueryWindow conv arg_os2 (Wnd: HWnd; Cmd: Long): HWnd; external 'PMWIN' index ord_Win32QueryWindow;
function WinMultWindowFromIDs conv arg_os2 (Parent: HWnd; PRgHWnd: PHWnd;
   idFirst,idLast: ULong): Long; external 'PMWIN' index ord_Win32MultWindowFromIDs;

{ WinQueryWindow codes }
const
  qw_Next                       = 0;
  qw_Prev                       = 1;
  qw_Top                        = 2;
  qw_Bottom                     = 3;
  qw_Owner                      = 4;
  qw_Parent                     = 5;
  qw_NextTop                    = 6;
  qw_PrevTop                    = 7;
  qw_FrameOwner                 = 8;

function WinSetParent conv arg_os2 (Wnd: HWnd; NewParent: HWnd; Redraw: Bool): Bool; external 'PMWIN' index ord_Win32SetParent;
function WinIsChild   conv arg_os2 (Wnd: HWnd; Parent: HWnd): Bool;                  external 'PMWIN' index ord_Win32IsChild;
function WinSetOwner  conv arg_os2 (Wnd: HWnd; NewOwner: HWnd): Bool;                external 'PMWIN' index ord_Win32SetOwner;
function WinQueryWindowProcess conv arg_os2 (Wnd: HWnd; Pid: PPid; Tid: PTid): Bool; external 'PMWIN' index ord_Win32QueryWindowProcess;
function WinQueryObjectWindow  conv arg_os2 (Desktop: HWnd): HWnd;                   external 'PMWIN' index ord_Win32QueryObjectWindow;
function WinQueryDesktopWindow conv arg_os2 (AB: Hab; DC: Hdc): HWnd;                external 'PMWIN' index ord_Win32QueryDesktopWindow;

{ Window positioning functions }
{ WinSetMultWindowPos record   }
type
  PSwp = ^Swp;
  Swp = record
    Fl:               ULong;
    cY,cX,Y,X:        Long;
    HWndInsertBehind: HWnd;
    Wnd:              HWnd;
    ulReserved1:      ULong;
    ulReserved2:      ULong;
  end;

function WinSetWindowPos conv arg_os2 (Wnd: HWnd; InsertBehind: HWnd; X,Y,cX,cY: Long;
  Flags: ULong): Bool; external 'PMWIN' index ord_Win32SetWindowPos;
function WinSetMultWindowPos conv arg_os2 (AB: Hab; var Swap: Swp; Count: ULong): Bool; external 'PMWIN' index ord_Win32SetMultWindowPos;
function WinQueryWindowPos   conv arg_os2 (Wnd: HWnd; var Swap: Swp): Bool; external 'PMWIN' index ord_Win32QueryWindowPos;

{ Values returned from wm_AdjustWindowPos and passed to wm_WindowPosChanged }
const
  awp_Minimized                 = $00010000;
  awp_Maximized                 = $00020000;
  awp_Restored                  = $00040000;
  awp_Activate                  = $00080000;
  awp_Deactivate                = $00100000;

{ WinSetWindowPos flags }
  swp_Size                      = $0001;
  swp_Move                      = $0002;
  swp_Zorder                    = $0004;
  swp_Show                      = $0008;
  swp_Hide                      = $0010;
  swp_NoRedraw                  = $0020;
  swp_NoAdjust                  = $0040;
  swp_Activate                  = $0080;
  swp_Deactivate                = $0100;
  swp_ExtStateChange            = $0200;
  swp_Minimize                  = $0400;
  swp_Maximize                  = $0800;
  swp_Restore                   = $1000;
  swp_FocusActivate             = $2000;
  swp_FocusDeactivate           = $4000;
  swp_NoAutoClose               = $8000;   { Valid in ProgDetails record only }

{ Window painting }

function WinUpdateWindow     conv arg_os2 (Wnd: HWnd): Bool;                                   external 'PMWIN' index ord_Win32UpdateWindow;
function WinInvalidateRect   conv arg_os2 (Wnd: HWnd; R: PRectL; IncludeChildren: Bool): Bool; external 'PMWIN' index ord_Win32InvalidateRect;
function WinInvalidateRegion conv arg_os2 (Wnd: HWnd; Rgn: HRgn; IncludeChildren: Bool): Bool; external 'PMWIN' index ord_Win32InvalidateRegion;

{ Drawing helpers }

function WinInvertRect conv arg_os2 (PS: Hps; var R: PRectL): Bool; external 'PMWIN' index ord_Win32InvertRect;
function WinDrawBitmap conv arg_os2 (PS: Hps; BitMap: HBitMap; Src,Dest: PRectL;
  ForeColor,BackColor: Long; Flags: ULong): Bool;     external 'PMWIN' index ord_Win32DrawBitmap;

{ WinDrawBitMap flags }
const
  dbm_Normal                    = $0000;
  dbm_Invert                    = $0001;
  dbm_HalfTone                  = $0002;
  dbm_Stretch                   = $0004;
  dbm_ImageAttrs                = $0008;

function WinDrawText conv arg_os2 (PS: Hps; TextLen: Long; Text: PChar; var R: RectL;
  ForeColor,BackColor: Long; Flags: ULong): Long; external 'PMWIN' index ord_Win32DrawText;

{ WinDrawText() codes: from dt_Left to dt_ExternalLeading, the codes are   }
{ designed to be OR'ed with ss_Text to create variations of the basic text }
{ static item.                                                             }
const
  dt_Left                       = $0000;
  dt_QueryExtent                = $0002;
  dt_UnderScore                 = $0010;
  dt_StrikeOut                  = $0020;
  dt_TextAttrs                  = $0040;
  dt_ExternalLeading            = $0080;
  dt_Center                     = $0100;
  dt_Right                      = $0200;
  dt_Top                        = $0000;
  dt_VCenter                    = $0400;
  dt_Bottom                     = $0800;
  dt_HalfTone                   = $1000;
  dt_Mnemonic                   = $2000;
  dt_WordBreak                  = $4000;
  dt_EraseRect                  = $8000;

function WinDrawBorder conv arg_os2 (PS: Hps; var R: RectL; cX,cY: Long;
  ForeColor,BackColor: Long; Flags: ULong): Bool; external 'PMWIN' index ord_Win32DrawBorder;

{ WinDrawBorder flags }
const
  db_PatCopy                    = $0000;
  db_PatInvert                  = $0001;
  db_DestInvert                 = $0002;
  db_AreaMixMode                = $0003;
  db_Rop                        = $0007;
  db_Interior                   = $0008;
  db_AreaAttrs                  = $0010;
  db_Standard                   = $0100;
  db_DlgBorder                  = $0200;

{ Resource loading functions }

function WinLoadString conv arg_os2 (AB: Hab; Module: HModule; Id: ULong; MaxLen: Long;
  Buffer: PChar): Long; external 'PMWIN' index ord_Win32LoadMessage;
function WinLoadMessage conv arg_os2 (AB: Hab; Module: HModule; Id: ULong; MaxLen: Long;
  Buffer: PChar): Long; external 'PMWIN' index ord_Win32LoadMessage;

function WinSetActiveWindow conv arg_os2 (Desktop: HWnd; Wnd: HWnd): Bool; external 'PMWIN' index ord_Win32SetActiveWindow;

{ wm_Create record }
type
  PCreateStruct = ^CreateStruct;
  CreateStruct = record
    pPresParams:      Pointer;
    pCtlData:         Pointer;
    Id:               ULong;
    HWndInsertBehind: HWnd;
    HWndOwner:        HWnd;
    cY,cX,Y,X:        Long;
    flStyle:          ULong;
    pszText:          PChar;
    pszClass:         PChar;
    HWndParent:       HWnd;
  end;

{ WinQueryClassInfo record }
  PClassInfo = ^ClassInfo;
  ClassInfo = record
    flClassStyle:    ULong;
    pfnWindowProc:   FnWp;
    cbWindowData:    ULong;
  end;

function WinSubclassWindow conv arg_os2 (Wnd: HWnd; WndProc: FnWp): Pointer;                        external 'PMWIN' index ord_Win32SubclassWindow;
function WinQueryClassName conv arg_os2 (Wnd: HWnd; MaxLen: Long; Buffer: PChar): Long;             external 'PMWIN' index ord_Win32QueryClassName;
function WinQueryClassInfo conv arg_os2 (AB: Hab; ClassName: PChar; var ClassInf: ClassInfo): Bool; external 'PMWIN' index ord_Win32QueryClassInfo;
function WinQueryActiveWindow conv arg_os2 (Desktop: HWnd): HWnd;                                   external 'PMWIN' index ord_Win32QueryActiveWindow;
function WinIsThreadActive conv arg_os2 (AB: Hab): Bool;                                            external 'PMWIN' index ord_Win32IsThreadActive;
function WinQuerySysModalWindow conv arg_os2 (Desktop: HWnd): HWnd;                                 external 'PMWIN' index ord_Win32QuerySysModalWindow;
function WinSetSysModalWindow conv arg_os2 (Desktop: HWnd; Wnd: HWnd): Bool;                        external 'PMWIN' index ord_Win32SetSysModalWindow;
function WinQueryWindowUShort conv arg_os2 (Wnd: HWnd; Index: Long): UShort;                        external 'PMWIN' index ord_Win32QueryWindowUShort;
function WinSetWindowUShort conv arg_os2 (Wnd: HWnd; Index: Long; us: UShort): Bool;                external 'PMWIN' index ord_Win32SetWindowUShort;
function WinQueryWindowULong conv arg_os2 (Wnd: HWnd; Index: Long): ULong;                          external 'PMWIN' index ord_Win32QueryWindowULong;
function WinSetWindowULong conv arg_os2 (Wnd: HWnd; Index: Long; ul: ULong): Bool;                  external 'PMWIN' index ord_Win32SetWindowULong;
function WinQueryWindowPtr conv arg_os2 (Wnd: HWnd; Index: Long): Pointer;                          external 'PMWIN' index ord_Win32QueryWindowPtr;
function WinSetWindowPtr conv arg_os2 (Wnd: HWnd; Index: Long; P: Pointer): Bool;                   external 'PMWIN' index ord_Win32SetWindowPtr;
function WinSetWindowBits conv arg_os2 (Wnd: HWnd; Index: Long; flData,flMask: ULong): Bool;        external 'PMWIN' index ord_Win32SetWindowBits;

{ Standard WinQueryWindowUShort/ULong indices }
const
  qws_User                      =  0;
  qws_Id                        = -1;
  qws_Min                       = -1;

  qwl_User                      =  0;
  qwl_Style                     = -2;
  qwp_PFnWp                     = -3;
  qwl_Hmq                       = -4;
  qwl_Reserved                  = -5;
  qwl_Min                       = -6;

{ wc_Frame WinQueryWindowUShort/ULong indices }
  qwl_HHeap                     = $0004;
  qwl_HWndFocusSave             = $0018;
  qwl_DefButton                 = $0040;
  qwl_PSscBlk                   = $0048;
  qwl_PFepBlk                   = $004C;
  qwl_PStatBlk                  = $0050;

  qws_Flags                     = $0008;
  qws_Result                    = $000A;
  qws_XRestore                  = $000C;
  qws_YRestore                  = $000E;
  qws_cXRestore                 = $0010;
  qws_cYRestore                 = $0012;
  qws_XMinimize                 = $0014;
  qws_YMinimize                 = $0016;

{ Window enumeration }
type
  HEnum = LHandle;

function WinBeginEnumWindows conv arg_os2 (Wnd: HWnd): HEnum;                                                 external 'PMWIN' index ord_Win32BeginEnumWindows;
function WinGetNextWindow    conv arg_os2 (Enum: HEnum): HWnd;                                                external 'PMWIN' index ord_Win32GetNextWindow;
function WinEndEnumWindows   conv arg_os2 (Enum: HEnum): Bool;                                                external 'PMWIN' index ord_Win32EndEnumWindows;
function WinWindowFromPoint  conv arg_os2 (Wnd: HWnd; var Point: PointL; Children: Bool): HWnd;               external 'PMWIN' index ord_Win32WindowFromPoint;
function WinMapWindowPoints  conv arg_os2 (FromWin: HWnd; ToWin: HWnd; var Point: PointL; Count: Long): Bool; external 'PMWIN' index ord_Win32MapWindowPoints;

{ More window painting functions }

function WinValidateRect        conv arg_os2 (Wnd: HWnd; R: PRectL; IncludeChildren: Bool): Bool;             external 'PMWIN' index ord_Win32ValidateRect;
function WinValidateRegion      conv arg_os2 (Wnd: HWnd; Rgn: HRgn; IncludeChildren: Bool): Bool;             external 'PMWIN' index ord_Win32ValidateRegion;
function WinWindowFromDC        conv arg_os2 (DC: Hdc): HWnd;                                                 external 'PMWIN' index ord_Win32WindowFromDC;
function WinQueryWindowDC       conv arg_os2 (Wnd: HWnd): Hdc;                                                external 'PMWIN' index ord_Win32QueryWindowDC;
function WinGetScreenPS         conv arg_os2 (Desktop: HWnd): Hps;                                            external 'PMWIN' index ord_Win32GetScreenPS;
function WinLockWindowUpdate    conv arg_os2 (Desktop: HWnd; LockUpdate: HWnd): Bool;                         external 'PMWIN' index ord_Win32LockWindowUpdate;
function WinLockVisRegions      conv arg_os2 (Desktop: HWnd; Lock: Bool): Bool;                               external 'PMWIN' index ord_Win32LockVisRegions;
function WinQueryUpdateRect     conv arg_os2 (Wnd: HWnd; var R: RectL): Bool;                                 external 'PMWIN' index ord_Win32QueryUpdateRect;
function WinQueryUpdateRegion   conv arg_os2 (Wnd: HWnd; Rgn: HRgn): Long;                                    external 'PMWIN' index ord_Win32QueryUpdateRegion;
function WinExcludeUpdateRegion conv arg_os2 (PS: Hps; Wnd: HWnd): Long;                                      external 'PMWIN' index ord_Win32ExcludeUpdateRegion;

{ QMsg record }
type
  PQMsg = ^QMsg;
  QMsg = record
    HWnd:     HWnd;
    Msg:      ULong;
    Mp1,Mp2:  MParam;
    Time:     ULong;
    ptl:      PointL;
    Reserved: ULong;
  end;

{ Standard Window Messages }
const
  wm_Null                       = $0000;
  wm_Create                     = $0001;
  wm_Destroy                    = $0002;
  wm_Enable                     = $0004;
  wm_Show                       = $0005;
  wm_Move                       = $0006;
  wm_Size                       = $0007;
  wm_AdjustWindowPos            = $0008;
  wm_CalcValidRects             = $0009;
  wm_SetWindowParams            = $000A;
  wm_QueryWindowParams          = $000B;
  wm_HitTest                    = $000C;
  wm_Activate                   = $000D;
  wm_SetFocus                   = $000F;
  wm_SetSelection               = $0010;
{ Language support Winproc }
  wm_PPaint                     = $0011;
  wm_PSetFocus                  = $0012;
  wm_PSysColorChange            = $0013;
  wm_PSize                      = $0014;
  wm_PActivate                  = $0015;
  wm_PControl                   = $0016;
  wm_Command                    = $0020;
  wm_SysCommand                 = $0021;
  wm_Help                       = $0022;
  wm_Paint                      = $0023;
  wm_Timer                      = $0024;
  wm_Sem1                       = $0025;
  wm_Sem2                       = $0026;
  wm_Sem3                       = $0027;
  wm_Sem4                       = $0028;
  wm_Close                      = $0029;
  wm_Quit                       = $002A;
  wm_SysColorChange             = $002B;
  wm_SysValueChanged            = $002D;
  wm_AppTerminateNotify         = $002E;
  wm_PresParamChanged           = $002F;
{ Control notification messages }
  wm_Control                    = $0030;
  wm_VScroll                    = $0031;
  wm_HScroll                    = $0032;
  wm_InitMenu                   = $0033;
  wm_MenuSelect                 = $0034;
  wm_MenuEnd                    = $0035;
  wm_DrawItem                   = $0036;
  wm_MeasureItem                = $0037;
  wm_ControlPointer             = $0038;
  wm_QueryDlgCode               = $003A;
  wm_InitDlg                    = $003B;
  wm_SubstituteString           = $003C;
  wm_MatchMnemonic              = $003D;
  wm_SaveApplication            = $003E;

{ Reserve a range of messages for help manager. This range includes     }
{ public messages, defined below, and private ones, which need to be    }
{ reserved here to prevent clashing with application messages           }
  wm_HelpBase                   = $0F00; { Start of msgs for help manager }
  wm_HelpTop                    = $0FFF; { End of msgs for help manager   }
  wm_User                       = $1000;

{ wm_Command msg source codes }
  cmdsrc_PushButton             = 1;
  cmdsrc_Menu                   = 2;
  cmdsrc_Accelerator            = 3;
  cmdsrc_FontDlg                = 4;
  cmdsrc_FileDlg                = 5;
  cmdsrc_PrintDlg               = 6;
  cmdsrc_ColorDlg               = 7;
  cmdsrc_Other                  = 0;

{ The following record is used to access the wm_Command, wm_Help, and   }
{ wm_SysCommand message parameters:                                     }

type
  PCmdMsgMp1 = ^CommandMsgMp1;  { Mp1 }
  CommandMsgMp1 = record
    Cmd:    Word;
    Unused: Word;
  end;

  PCmdMsgMp2 = ^CommandMsgMp2;  { Mp2 }
  CommandMsgMp2 = record
    Source: Word;
    fMouse: Word;
  end;

{ The following record is used by the WinQueryQueueInfo routine }

  PMqInfo = ^MqInfo;
  MqInfo = record
    cb:        ULong;
    Pid:       Pid;
    Tid:       Tid;
    CMsgs:     ULong;
    pReserved: Pointer;
  end;

function WinSendMsg conv arg_os2 (Wnd: HWnd; Msg: ULong; Mp1,Mp2: MParam): MResult; external 'PMWIN' index ord_Win32SendMsg;
function WinCreateMsgQueue conv arg_os2 (AB: Hab; CMsg: Long): Hmq;                 external 'PMWIN' index ord_Win32CreateMsgQueue;
function WinDestroyMsgQueue conv arg_os2 (Mq: Hmq): Bool;                           external 'PMWIN' index ord_Win32DestroyMsgQueue;
function WinQueryQueueInfo conv arg_os2 (Mq: Hmq; var Mqi: MqInfo; cbCopy: ULong): Bool; external 'PMWIN' index ord_Win32QueryQueueInfo;
function WinCancelShutdown conv arg_os2 (Mq: Hmq; CancelAlways: Bool): Bool;        external 'PMWIN' index ord_Win32CancelShutdown;
function WinGetMsg conv arg_os2 (AB: Hab; var Msg: QMsg; Filter: HWnd;
  msgFilterFirst,msgFilterLast: ULong): Bool;                         external 'PMWIN' index ord_Win32GetMsg;
function WinPeekMsg conv arg_os2 (AB: Hab; var Msg: QMsg; HWndFilter: HWnd;
  msgFilterFirst,msgFilterLast,Flags: ULong): Bool;                   external 'PMWIN' index ord_Win32PeekMsg;
function WinDispatchMsg conv arg_os2 (AB: Hab; var Msg: QMsg): MResult;             external 'PMWIN' index ord_Win32DispatchMsg;
function WinPostMsg conv arg_os2 (Wnd: HWnd; Msg: ULong; Mp1,Mp2: MParam): Bool;    external 'PMWIN' index ord_Win32PostMsg;
function WinRegisterUserMsg conv arg_os2 (AB: Hab; MsgId: ULong;
  DataType1,Dir1,DataType2,Dir2,DataTypeR: Long): Bool;               external 'PMWIN' index ord_Win32RegisterUserMsg;
function WinRegisterUserDataType conv arg_os2 (AB: Hab; DataType,Count: Long;
  Types: PLong): Bool;                                                external 'PMWIN' index ord_Win32RegisterUserDataType;
function WinSetMsgMode conv arg_os2 (AB: Hab; ClassName: PChar; Control: Long): Bool; external 'PMWIN' index ord_Win32SetMsgMode;
function WinSetSynchroMode conv arg_os2 (AB: Hab; Mode: Long): Bool;                  external 'PMWIN' index ord_Win32SetSynchroMode;

{ WinPeekMsg constants }
const
  pm_Remove                     = $0001;
  pm_NoRemove                   = $0000;

{ WinRegisterUserDatatype datatypes are declared in the PmTypes unit }

{ WinRegisterUserMsg direction codes }
  rum_In                        = 1;
  rum_Out                       = 2;
  rum_InOut                     = 3;

{ WinSetMsgMode constants }
  smd_Delayed                   = $0001;
  smd_Immediate                 = $0002;

{ WinSetSynchroMode constants }
  ssm_Synchronous               = $0001;
  ssm_Asynchronous              = $0002;
  ssm_Mixed                     = $0003;

{ wm_CalcValidRects return flags }
  cvr_AlignLeft                 = $0001;
  cvr_AlignBottom               = $0002;
  cvr_AlignRight                = $0004;
  cvr_AlignTop                  = $0008;
  cvr_Redraw                    = $0010;

{ wm_HitTest return codes }
  ht_Normal                     =  0;
  ht_Transparent                = -1;
  ht_Discard                    = -2;
  ht_Error                      = -3;

{ wm_Set/QueryWindowParams record and flags }
type
  PWndParams = ^WndParams;
  WndParams = record
    fsStatus:     ULong;
    cchText:      ULong;
    pszText:      PChar;
    cbPresParams: ULong;
    pPresParams:  Pointer;
    cbCtlData:    ULong;
    pCtlData:     Pointer;
  end;

const
  wpm_Text                      = $0001;
  wpm_CtlData                   = $0002;
  wpm_PresParams                = $0004;
  wpm_CChText                   = $0008;
  wpm_CbCtlData                 = $0010;
  wpm_CbPresParams              = $0020;

function WinInSendMsg conv arg_os2 (AB: Hab): Bool; external 'PMWIN' index ord_Win32InSendMsg;
function WinBroadcastMsg conv arg_os2 (Wnd: HWnd; Msg: ULong; Mp1,Mp2: MParam; rgf: ULong): Bool; external 'PMWIN' index ord_Win32BroadcastMsg;

{ WinBroadcastMsg codes }
const
  bmsg_Post                     = $0000;
  bmsg_Send                     = $0001;
  bmsg_PostQueue                = $0002;
  bmsg_Descendants              = $0004;
  bmsg_FrameOnly                = $0008;

function WinWaitMsg conv arg_os2 (AB: Hab; msgFirst,msgLast: ULong): Bool; external 'PMWIN' index ord_Win32WaitMsg;
function WinQueryQueueStatus conv arg_os2 (Desktop: HWnd): ULong;          external 'PMWIN' index ord_Win32QueryQueueStatus;

{ WinQueryQueueStatus constants }
const
  qs_Key                        = $0001;
  qs_MouseButton                = $0002;
  qs_MouseMove                  = $0004;
  qs_Mouse                      = $0006;  { qs_MouseMove or qs_MouseButton }
  qs_Timer                      = $0008;
  qs_Paint                      = $0010;
  qs_PostMsg                    = $0020;
  qs_Sem1                       = $0040;
  qs_Sem2                       = $0080;
  qs_Sem3                       = $0100;
  qs_Sem4                       = $0200;
  qs_SendMsg                    = $0400;

function WinQueryMsgPos  conv arg_os2 (AB: Hab; var Point: PointL): Bool; external 'PMWIN' index ord_Win32QueryMsgPos;
function WinQueryMsgTime conv arg_os2 (AB: Hab): ULong;                   external 'PMWIN' index ord_Win32QueryMsgTime;

type
  HEv  = ULong;
  HMtx = ULong;
  HMux = ULong;

//function WinWaitEventSem conv arg_os2 (EvSem: HEv; Timeout: ULong): ApiRet;                      external 'PMWIN' index ord_Win32WaitEventSem;
//function WinRequestMutexSem conv arg_os2 (MtxSem: HMtx; Timeout: ULong): ApiRet;                 external 'PMWIN' index ord_Win32RequestMutexSem;
//function WinWaitMuxWaitSem conv arg_os2 (MuxSem: HMux; Timeout: ULong; pulUser: PULong): ApiRet; external 'PMWIN' index ord_Win32WaitMuxWaitSem;
//function WinPostQueueMsg const arg_os2 (Mq: Hmq; Msg: ULong; Mp1,Mp2: MParam): Bool;             external 'PMWIN' index ord_Win32PostQueueMsg;

{ WinSetMsgInterest/WinSetClassMsgInterest constants }
const
  smim_All                      = $0EFF;
  smi_NoInterest                = $0001;
  smi_Interest                  = $0002;
  smi_Reset                     = $0004;
  smi_AutoDispatch              = $0008;

function WinSetMsgInterest conv arg_os2 (Wnd: HWnd; MsgClass: ULong; Control: Long): Bool; external 'PMWIN' index ord_Win32SetMsgInterest;
function WinSetClassMsgInterest conv arg_os2 (AB: Hab; ClassName: PChar; MsgClass: ULong;
  Control: Long): Bool; external 'PMWIN' index ord_Win32SetClassMsgInterest;

{ Keyboard and mouse }

function WinSetFocus conv arg_os2 (Desktop: HWnd; SetFocus: HWnd): Bool; external 'PMWIN' index ord_Win32SetFocus;
function WinFocusChange conv arg_os2 (Desktop: HWnd; SetFocus: HWnd; flFocusChange: ULong): Bool; external 'PMWIN' index ord_Win32FocusChange;

const
  fc_NoSetFocus                 = $0001;
  fc_NoBringToTop               = fc_NoSetFocus;
  fc_NoLoseFocus                = $0002;
  fc_NoBringTopFirstWindow      = fc_NoLoseFocus;
  fc_NoSetActive                = $0004;
  fc_NoLoseActive               = $0008;
  fc_NoSetSelection             = $0010;
  fc_NoLoseSelection            = $0020;

  qfc_NextInChain               = $0001;
  qfc_Active                    = $0002;
  qfc_Frame                     = $0003;
  qfc_SelectActive              = $0004;
  qfc_PartOfChain               = $0005;

function WinSetCapture conv arg_os2 (Desktop: HWnd; Wnd: HWnd): Bool; external 'PMWIN' index ord_Win32SetCapture;
function WinQueryCapture conv arg_os2 (Desktop: HWnd): HWnd;          external 'PMWIN' index ord_Win32QueryCapture;

{ Mouse input messages}
const
  wm_MouseFirst                 = $0070;
  wm_MouseLast                  = $0079;
  wm_ButtonClickFirst           = $0071;
  wm_ButtonClickLast            = $0079;
  wm_MouseMove                  = $0070;
  wm_Button1Down                = $0071;
  wm_Button1Up                  = $0072;
  wm_Button1DblClk              = $0073;
  wm_Button2Down                = $0074;
  wm_Button2Up                  = $0075;
  wm_Button2DblClk              = $0076;
  wm_Button3Down                = $0077;
  wm_Button3Up                  = $0078;
  wm_Button3DblClk              = $0079;
  wm_ExtMouseFirst              = $0410;
  wm_ExtMouseLast               = $0419;
  wm_Chord                      = $0410;
  wm_Button1MotionStart         = $0411;
  wm_Button1MotionEnd           = $0412;
  wm_Button1Click               = $0413;
  wm_Button2MotionStart         = $0414;
  wm_Button2MotionEnd           = $0415;
  wm_Button2Click               = $0416;
  wm_Button3MotionStart         = $0417;
  wm_Button3MotionEnd           = $0418;
  wm_Button3Click               = $0419;
  { Messages $041A - $041F are reserved }
  wm_MouseTranslateFirst        = $0420;
  wm_MouseTranslateLast         = $0428;
  wm_BeginDrag                  = $0420;
  wm_EndDrag                    = $0421;
  wm_SingleSelect               = $0422;
  wm_Open                       = $0423;
  wm_ContextMenu                = $0424;
  wm_ContextHelp                = $0425;
  wm_TextEdit                   = $0426;
  wm_BeginSelect                = $0427;
  wm_EndSelect                  = $0428;

function WinQueryFocus conv arg_os2 (Desktop: HWnd): HWnd; external 'PMWIN' index ord_Win32QueryFocus;

{ Key/Character input messages }
const
  wm_Char                       = $007A;
  wm_VioChar                    = $007B;

{ wm_Char fs field bits }
  kc_None                       = $0000;    { Reserved }
  kc_Char                       = $0001;
  kc_VirtualKey                 = $0002;
  kc_ScanCode                   = $0004;
  kc_Shift                      = $0008;
  kc_Ctrl                       = $0010;
  kc_Alt                        = $0020;
  kc_KeyUp                      = $0040;
  kc_PrevDown                   = $0080;
  kc_LoneKey                    = $0100;
  kc_DeadKey                    = $0200;
  kc_Composite                  = $0400;
  kc_InvalidComp                = $0800;
  kc_Toggle                     = $1000;
  kc_InvalidChar                = $2000;
  kc_DbcsRsrvd1                 = $4000;
  kc_DbcsRsrvd2                 = $8000;

{ The following record is used to access the wm_MouseMove, and wm_Button }
{ message parameters                                                     }
type
  PMseMsgMp1 = ^MouseMsgMp1;    { Mp1 }
  MouseMsgMp1 = record
    X: Word;
    Y: Word;
  end;

  PMseMsgMp2 = ^MouseMsgMp2;    { Mp2 }
  MouseMsgMp2 = record
    codeHitTest: Word;
    fsInp:       Word;          { Input flags }
  end;

  PChrMsgMp1 = ^CharMsgMp1;     { Mp1 }
  CharMsgMp1 = record
    fs:         Word;
    cRepeat:    Byte;
    ScanCode:   Byte;
  end;

  PChrMsgMp2 = ^CharMsgMp2;     { Mp2 }
  CharMsgMp2 = record
    Chr:        Word;
    VKey:       Word;
  end;

const
  inp_None                      = $0000;
  inp_Kbd                       = $0001;
  inp_Mult                      = $0002;
  inp_Res2                      = $0004;
  inp_Shift                     = $0008;
  inp_Ctrl                      = $0010;
  inp_Alt                       = $0020;
  inp_Res3                      = $0040;
  inp_Res4                      = $0080;
  inp_Ignore                    = $FFFF;

{ Virtual key values }
  vk_Button1                    = $01;
  vk_Button2                    = $02;
  vk_Button3                    = $03;
  vk_Break                      = $04;
  vk_BackSpace                  = $05;
  vk_Tab                        = $06;
  vk_BackTab                    = $07;
  vk_NewLine                    = $08;
  vk_Shift                      = $09;
  vk_Ctrl                       = $0A;
  vk_Alt                        = $0B;
  vk_AltGraf                    = $0C;
  vk_Pause                      = $0D;
  vk_CapsLock                   = $0E;
  vk_Esc                        = $0F;
  vk_Space                      = $10;
  vk_PageUp                     = $11;
  vk_PageDown                   = $12;
  vk_End                        = $13;
  vk_Home                       = $14;
  vk_Left                       = $15;
  vk_Up                         = $16;
  vk_Right                      = $17;
  vk_Down                       = $18;
  vk_PrintScrn                  = $19;
  vk_Insert                     = $1A;
  vk_Delete                     = $1B;
  vk_ScrlLock                   = $1C;
  vk_NumLock                    = $1D;
  vk_Enter                      = $1E;
  vk_SysRq                      = $1F;
  vk_F1                         = $20;
  vk_F2                         = $21;
  vk_F3                         = $22;
  vk_F4                         = $23;
  vk_F5                         = $24;
  vk_F6                         = $25;
  vk_F7                         = $26;
  vk_F8                         = $27;
  vk_F9                         = $28;
  vk_F10                        = $29;
  vk_F11                        = $2A;
  vk_F12                        = $2B;
  vk_F13                        = $2C;
  vk_F14                        = $2D;
  vk_F15                        = $2E;
  vk_F16                        = $2F;
  vk_F17                        = $30;
  vk_F18                        = $31;
  vk_F19                        = $32;
  vk_F20                        = $33;
  vk_F21                        = $34;
  vk_F22                        = $35;
  vk_F23                        = $36;
  vk_F24                        = $37;
  vk_EndDrag                    = $38;
  vk_Menu                       = VK_F10;
  vk_DbcsFirst                  = $0080;
  vk_DbcsLast                   = $00ff;
  vk_UserFirst                  = $0100;
  vk_UserLast                   = $01ff;

function WinGetKeyState conv arg_os2 (Desktop: HWnd; VKey: Long): Long;                                    external 'PMWIN' index ord_Win32GetKeyState;
function WinGetPhysKeyState conv arg_os2 (Desktop: HWnd; Sc: Long): Long;                                  external 'PMWIN' index ord_Win32GetPhysKeyState;
function WinEnablePhysInput conv arg_os2 (Desktop: HWnd; Enable: Bool): Bool;                              external 'PMWIN' index ord_Win32EnablePhysInput;
function WinIsPhysInputEnabled conv arg_os2 (Desktop: HWnd): Bool;                                         external 'PMWIN' index ord_Win32IsPhysInputEnabled;
function WinSetKeyboardStateTable conv arg_os2 (Desktop: HWnd; pKeyStateTable: Pointer; fSet: Bool): Bool; external 'PMWIN' index ord_Win32SetKeyboardStateTable;

{ Journal Notification messages }
const
  wm_JournalNotify              = $007C;
  { Define the valid commands (lParm1) for journal notify message }
  jrn_QueueStatus               = $00000001;
  jrn_PhysKeyState              = $00000002;

{ Dialog Manager }

function WinGetDlgMsg conv arg_os2 (Dlg: HWnd; var Msg: QMsg): Bool; external 'PMWIN' index ord_Win32GetDlgMsg;
function WinLoadDlg conv arg_os2 (Parent,Owner: HWnd; DlgProc: FnWp; Module: HModule;
  IdDlg: ULong; CreateParams: Pointer): HWnd; external 'PMWIN' index ord_Win32LoadDlg;
function WinDlgBox conv arg_os2 (Parent,Owner: HWnd; DlgProc: FnWp; Module: HModule;
  idDlg: ULong; CreateParams: Pointer): ULong; external 'PMWIN' index ord_Win32DlgBox;
function WinDismissDlg conv arg_os2 (Dlg: HWnd; Result: ULong): Bool; external 'PMWIN' index ord_Win32DismissDlg;
function WinQueryDlgItemShort conv arg_os2 (Dlg: HWnd; IdItem: ULong; Result: Pointer;
  Signed: Bool): Bool; external 'PMWIN' index ord_Win32QueryDlgItemShort;
function WinSetDlgItemShort conv arg_os2 (Dlg: HWnd; IdItem: ULong; Value: Word;
  Signed: Bool): Bool; external 'PMWIN' index ord_Win32SetDlgItemShort;
function WinSetDlgItemText conv arg_os2 (Dlg: HWnd; IdItem: ULong; Text: PChar): Bool; external 'PMWIN' index ord_Win32SetDlgItemText;
function WinQueryDlgItemText conv arg_os2 (Dlg: HWnd; IdItem: ULong; BufferMax: Long;
  Buffer: PChar): ULong; external 'PMWIN' index ord_Win32QueryDlgItemText;
function WinQueryDlgItemTextLength conv arg_os2 (Dlg: HWnd; IdItem: ULong): Long; external 'PMWIN' index ord_Win32QueryDlgItemTextLength;
function WinDefDlgProc conv arg_cdecl (Dlg: HWnd; Msg: ULong; Mp1,Mp2: MParam): MResult; external 'PMWIN' index ord_Win32DefDlgProc;

{ Special item IDs }
const
  did_Ok                        = 1;
  did_Cancel                    = 2;
  did_Error                     = $FFFF;

function WinAlarm conv arg_os2 (Desktop: HWnd; rgfType: ULong): Bool; external 'PMWIN' index ord_Win32Alarm;

{ WinAlarm Codes }
const
  wa_Warning                    = 0;
  wa_Note                       = 1;
  wa_Error                      = 2;
  wa_CWinAlarms                 = 3;    { count of valid alarms }

function WinMessageBox conv arg_os2 (Parent,Owner: HWnd; Text,Caption: PChar;
  IdWindow,Style: ULong): ULong; external 'PMWIN' index ord_Win32MessageBox;

{ Message box types }
const
  mb_Ok                         = $0000;
  mb_OkCancel                   = $0001;
  mb_RetryCancel                = $0002;
  mb_AbortRetryIgnore           = $0003;
  mb_YesNo                      = $0004;
  mb_YesNoCancel                = $0005;
  mb_Cancel                     = $0006;
  mb_Enter                      = $0007;
  mb_EnterCancel                = $0008;

  mb_NoIcon                     = $0000;
  mb_CUANotification            = $0000;
  mb_IconQuestion               = $0010;
  mb_IconExclamation            = $0020;
  mb_CUAWarning                 = $0020;
  mb_IconAsterisk               = $0030;
  mb_IconHand                   = $0040;
  mb_CUACritical                = $0040;
  mb_Query                      = mb_IconQuestion;
  mb_Warning                    = mb_CUAWarning;
  mb_Information                = mb_IconAsterisk;
  mb_Critical                   = mb_CUACritical;
  mb_Error                      = mb_Critical;

  mb_DefButton1                 = $0000;
  mb_DefButton2                 = $0100;
  mb_DefButton3                 = $0200;

  mb_ApplModal                  = $0000;
  mb_SystemModal                = $1000;
  mb_Help                       = $2000;
  mb_Moveable                   = $4000;

  { Message box return codes }
  mbid_Ok                       = 1;
  mbid_Cancel                   = 2;
  mbid_Abort                    = 3;
  mbid_Retry                    = 4;
  mbid_Ignore                   = 5;
  mbid_Yes                      = 6;
  mbid_No                       = 7;
  mbid_Help                     = 8;
  mbid_Enter                    = 9;
  mbid_Error                    = $FFFF;

{ Dialog codes: returned by wm_QueryDlgCode msg }
  dlgc_EntryField               = $0001; { Entry field item understands em_SetSel) }
  dlgc_Button                   = $0002; { Button item                             }
  dlgc_RadioButton              = $0004; { Radio button                            }
  dlgc_Static                   = $0008; { Static item                             }
  dlgc_Default                  = $0010; { Default push button                     }
  dlgc_PushButton               = $0020; { Normal (Non-default) push button        }
  dlgc_CheckBox                 = $0040; { Check box button control                }
  dlgc_ScrollBar                = $0080; { Scroll bar                              }
  dlgc_Menu                     = $0100; { Menu                                    }
  dlgc_TabOnClick               = $0200;
  dlgc_MLE                      = $0400; { Multiple Line Entry                     }

function WinProcessDlg(Dlg: HWnd): ULong; external 'PMWIN' index ord_Win32ProcessDlg;
function WinSendDlgItemMsg(Dlg: HWnd; IdItem: ULong; Msg: ULong;
  Mp1,Mp2: MParam): MResult; external 'PMWIN' index ord_Win32SendDlgItemMsg;
function WinMapDlgPoints(Dlg: HWnd; var PrgWPtL: PointL; Count: ULong;
  CalcWindowCoords: Bool): Bool; external 'PMWIN' index ord_Win32MapDlgPoints;
function WinEnumDlgItem(Dlg: HWnd; Wnd: HWnd; Code: ULong): HWnd; external 'PMWIN' index ord_Win32EnumDlgItem;
function WinSubstituteStrings(Wnd: HWnd; Src: PChar; DestMax: Long;
  Dest: PChar): Long; external 'PMWIN' index ord_Win32SubstituteStrings;

{ WinEnumDlgItem constants }
const
  edi_FirstTabItem              = 0;
  edi_LastTabItem               = 1;
  edi_NextTabItem               = 2;
  edi_PrevTabItem               = 3;
  edi_FirstGroupItem            = 4;
  edi_LastGroupItem             = 5;
  edi_NextGroupItem             = 6;
  edi_PrevGroupItem             = 7;

{ Dialog template definitions }
type
  PDlgTItem = ^DlgTItem;
  DlgTItem = record
    fsItemStatus:    Word;
    cChildren:       Word;
    cchClassName:    Word;
    offClassName:    Word;
    cchText:         Word;
    offText:         Word;
    flStyle:         ULong;
    X:               SmallInt;
    Y:               SmallInt;
    cX:              SmallInt;
    cY:              SmallInt;
    id:              Word;
    offPresParams:   Word;
    offCtlData:      Word;
  end;

{ Dialog Template structure }
 PDlgTemplate = ^DlgTemplate;
 DlgTemplate = record
   cbTemplate:             Word;
   dtype:                  Word;
   codepage:               Word;
   offadlgti:              Word;
   fsTemplateStatus:       Word;
   iItemFocus:             Word;
   coffPresParams:         Word;
   adlgti:                 DlgTItem;
 end;

function WinCreateDlg conv arg_os2 (Parent,Owner: HWnd; DlgProc: FnWp; var Dlg: DlgTemplate;
  CreateParams: Pointer): HWnd; external 'PMWIN' index ord_Win32CreateDlg;

{ Static Control Manager }

{ Static control styles:                                                 }
{  NOTE: the top 9 bits of the LOWORD of the window flStyle are used for }
{  dt_* flags.  The lower 7 bits are for SS_* styles.  This gives us up  }
{  to 128 distinct static control types (we currently use 11 of them).   }
const
  ss_Text                       = $0001;
  ss_GroupBox                   = $0002;
  ss_Icon                       = $0003;
  ss_BitMap                     = $0004;
  ss_FgndRect                   = $0005;
  ss_HalfToneRect               = $0006;
  ss_BkgndRect                  = $0007;
  ss_FgndFrame                  = $0008;
  ss_HalfToneFrame              = $0009;
  ss_BkgndFrame                 = $000A;
  ss_SysIcon                    = $000B;
  ss_AutoSize                   = $0040;

{ Static control messages }
  SM_SETHANDLE                  = $0100;
  SM_QUERYHANDLE                = $0101;

{ Button control styles }
  bs_PushButton                 = 0;
  bs_CheckBox                   = 1;
  bs_AutoCheckBox               = 2;
  bs_RadioButton                = 3;
  bs_AutoRadioButton            = 4;
  bs_3State                     = 5;
  bs_Auto3State                 = 6;
  bs_UserButton                 = 7;
  bs_PrimaryStyles              = $000F;
  bs_BitMap                     = $0040;
  bs_Icon                       = $0080;
  bs_Help                       = $0100;
  bs_SysCommand                 = $0200;
  bs_Default                    = $0400;
  bs_NoPointerFocus             = $0800;
  bs_NoBorder                   = $1000;
  bs_NoCursorSelect             = $2000;
  bs_AutoSize                   = $4000;

type
  PBtnCData = ^BtnCData;
  BtnCData = record
    cd:            Word;
    fsCheckState:  Word;
    fsHiliteState: Word;
    hImage:        LHandle;
  end;

{ User button record (passed in wm_Control msg }
  PUserButton = ^UserButton;
  UserButton = record
    HWnd:       HWnd;
    Hps:        Hps;
    fsState:    ULong;
    fsStateOld: ULong;
  end;

{ Button control messages }
const
  bm_Click                      = $0120;
  bm_QueryCheckIndex            = $0121;
  bm_QueryHilite                = $0122;
  bm_SetHilite                  = $0123;
  bm_QueryCheck                 = $0124;
  bm_SetCheck                   = $0125;
  bm_SetDefault                 = $0126;

{ Button notification codes }
  bn_Clicked                    = 1;
  bn_DblClicked                 = 2;
  bn_Paint                      = 3;

{ bn_Paint button draw state codes (must be in high byte) }
  bds_Hilited                   = $0100;
  bds_Disabled                  = $0200;
  bds_Default                   = $0400;

{ Entry field styles }
  es_Left                       = $00000000;
  es_Center                     = $00000001;
  es_Right                      = $00000002;
  es_AutoScroll                 = $00000004;
  es_Margin                     = $00000008;
  es_AutoTab                    = $00000010;
  es_ReadOnly                   = $00000020;
  es_Command                    = $00000040;
  es_UnReadable                 = $00000080;
  es_AutoSize                   = $00000200;
  es_Any                        = $00000000;
  es_Sbcs                       = $00001000;
  es_Dbcs                       = $00002000;
  es_Mixed                      = $00003000;

{ combo box styles }
  cbs_Simple                    = $0001;
  cbs_DropDown                  = $0002;
  cbs_DropDownList              = $0004;

{ Use this bit for drop down combo boxes that do not want to       }
{ receive a cbn_Enter on a single click in their list boxes.       }
{ This is for compatibility with releases prior to OS/2 2.0 which  }
{ did not send this message                                        }
  cbs_Compatible                = $0008;

{ The following edit and listbox styles may be used in conjunction }
{ with cbs_ styles es_AutoTab es_Any es_Sbcs es_Dbcs es_Mixed ls_HorzScroll }
{ IDs of combobox entry field and listbox.                         }
  cbid_List                     = $029A;
  cbid_Edit                     = $029B;

  cbm_ShowList                  = $0170;
  cbm_Hilite                    = $0171;
  cbm_IsListShowing             = $0172;

  cbn_EfChange                  = 1;
  cbn_EfScroll                  = 2;
  cbn_MemError                  = 3;
  cbn_LbSelect                  = 4;
  cbn_LbScroll                  = 5;
  cbn_ShowList                  = 6;
  cbn_Enter                     = 7;

type
  PEntryFData = ^EntryFData;
  EntryFData = record
    cb:           Word;
    cchEditLimit: Word;
    ichMinSel:    Word;
    ichMaxSel:    Word;
  end;

{ Entry Field messages }
const
  em_QueryChanged               = $0140;
  em_QuerySel                   = $0141;
  em_SetSel                     = $0142;
  em_SetTextLimit               = $0143;
  em_Cut                        = $0144;
  em_Copy                       = $0145;
  em_Clear                      = $0146;
  em_Paste                      = $0147;
  em_QueryFirstChar             = $0148;
  em_SetFirstChar               = $0149;
  em_QueryReadOnly              = $014A;
  em_SetReadOnly                = $014B;
  em_SetInsertMode              = $014C;

{ Entry Field notification messages }
  en_SetFocus                   = $0001;
  en_KillFocus                  = $0002;
  en_Change                     = $0004;
  en_Scroll                     = $0008;
  en_MemError                   = $0010;
  en_Overflow                   = $0020;
  en_InsertModeToggle           = $0040;

{  Multiple Line Entries are declared in PmMle unit}

{ List box styles }
  ls_MultipleSel                = $00000001;
  ls_OwnerDraw                  = $00000002;
  ls_NoAdjustPos                = $00000004;
  ls_HorzScroll                 = $00000008;
  ls_ExtendedSel                = $00000010;

{ List box notification messages }
  ln_Select                     = 1;
  ln_SetFocus                   = 2;
  ln_KillFocus                  = 3;
  ln_Scroll                     = 4;
  ln_Enter                      = 5;

{ List box messages }
  lm_QueryItemCount             = $0160;
  lm_InsertItem                 = $0161;
  lm_SetTopIndex                = $0162;
  lm_DeleteItem                 = $0163;
  lm_SelectItem                 = $0164;
  lm_QuerySelection             = $0165;
  lm_SetItemText                = $0166;
  lm_QueryItemTextLength        = $0167;
  lm_QueryItemText              = $0168;
  lm_SetItemHandle              = $0169;
  lm_QueryItemHandle            = $016A;
  lm_SearchString               = $016B;
  lm_SetItemHeight              = $016C;
  lm_QueryTopIndex              = $016D;
  lm_DeleteAll                  = $016E;

{ List box constants }
  lit_Cursor                    = -4;
  lit_Error                     = -3;
  lit_MemError                  = -2;
  lit_None                      = -1;
  lit_First                     = -1;

{ For lm_InsertItem msg }
  lit_End                       = -1;
  lit_SortAscending             = -2;
  lit_SortDescending            = -3;

{ For lm_SearchString msg }
  lss_SubString                 = $0001;
  lss_Prefix                    = $0002;
  lss_CaseSensitive             = $0004;

{ Menu control styles }
  ms_ActionBar                  = $00000001;
  ms_TitleButton                = $00000002;
  ms_VerticalFlip               = $00000004;
  ms_ConditionalCascade         = $00000040;

function WinLoadMenu conv arg_os2 (Frame: HWnd; Module: HModule; IdMenu: ULong): HWnd; external 'PMWIN' index ord_Win32LoadMenu;

{ Menu control messages }
const
  mm_InsertItem                 = $0180;
  mm_DeleteItem                 = $0181;
  mm_QueryItem                  = $0182;
  mm_SetItem                    = $0183;
  mm_QueryItemCount             = $0184;
  mm_StartMenuMode              = $0185;
  mm_EndMenuMode                = $0186;
  mm_RemoveItem                 = $0188;
  mm_SelectItem                 = $0189;
  mm_QuerySelItemId             = $018A;
  mm_QueryItemText              = $018B;
  mm_QueryItemTextLength        = $018C;
  mm_SetItemHandle              = $018D;
  mm_SetItemText                = $018E;
  mm_ItemPositionFromId         = $018F;
  mm_ItemIdFromPosition         = $0190;
  mm_QueryItemAttr              = $0191;
  mm_SetItemAttr                = $0192;
  mm_IsItemValid                = $0193;
  mm_QueryItemRect              = $0194;

  mm_QueryDefaultItemId         = $0431;
  mm_SetDefaultItemId           = $0432;

function WinCreateMenu conv arg_os2 (Parent: HWnd; lpmt: Pointer): HWnd; external 'PMWIN' index ord_Win32CreateMenu;

{ Owner Item Structure (Also used for listboxes) }
type
  POwnerItem = ^OwnerItem;
  OwnerItem = record
    HWnd:           HWnd;
    Hps:            Hps;
    fsState:        ULong;
    fsAttribute:    ULong;
    fsStateOld:     ULong;
    fsAttributeOld: ULong;
    rclItem:        RectL;
    idItem:         Long;       { This field contains idItem for menus, iItem for lb. }
    hItem:          ULong;
  end;

{ Menu item }
  PMenuItem = ^MenuItem;
  MenuItem = record
    iPosition:   SmallInt;
    afStyle:     Word;
    afAttribute: Word;
    id:          Word;
    HWndSubMenu: HWnd;
    hItem:       ULong;
  end;

const
  mit_End                       = -1;
  mit_None                      = -1;
  mit_MemError                  = -1;
  mit_Error                     = -1;
  mit_First                     = -2;
  mit_Last                      = -3;
  mid_None                      = mit_None;
  mid_Error                     = -1;

{ Menu item styles & attributes }
  mis_Text                      = $0001;
  mis_BitMap                    = $0002;
  mis_Separator                 = $0004;
  mis_OwnerDraw                 = $0008;
  mis_SubMenu                   = $0010;
  mis_MultMenu                  = $0020;        { multiple choice submenu }
  mis_SysCommand                = $0040;
  mis_Help                      = $0080;
  mis_Static                    = $0100;
  mis_ButtonSeparator           = $0200;
  mis_Break                     = $0400;
  mis_BreakSeparator            = $0800;
  mis_Group                     = $1000;        { multiple choice group start }
{ In multiple choice submenus a style of 'single' denotes the item is a       }
{ radiobutton. Absence of this style defaults the item to a checkbox.         }
  mis_Single                    = $2000;

  mia_NoDismiss                 = $0020;
  mia_Framed                    = $1000;
  mia_Checked                   = $2000;
  mia_Disabled                  = $4000;
  mia_Hilited                   = $8000;

function WinPopupMenu conv arg_os2 (Parent,Owner,Menu: HWnd; X,Y,IdItem: Long; fs: ULong): Bool; external 'PMWIN' index ord_Win32PopupMenu;

{ Values of fs in WinPopupMenu call }
const
  pu_PositionOnItem             = $0001; { Need idItem parameter }
  pu_HConstrain                 = $0002; { Keep menu on left and right edge }
  pu_VConstrain                 = $0004; { Keep menu on top and bottom edge }
  pu_None                       = $0000; { If invoked by keyboard }
  pu_MouseButton1Down           = $0008; { If invoked by button 1 }
  pu_MouseButton2Down           = $0010; { If invoked by button 2 }
  pu_MouseButton3Down           = $0018; { If invoked by button 3 }
  pu_SelectItem                 = $0020; { Set selected item (use with kbd) }
  pu_MouseButton1               = $0040; { If button1 use allowed }
  pu_MouseButton2               = $0080; { If button2 use allowed }
  pu_MouseButton3               = $0100; { If button3 use allowed }
  pu_Keyboard                   = $0200; { If keyboard use allowed}

{ Scroll Bar styles }
  sbs_Horz                      = 0;
  sbs_Vert                      = 1;
  sbs_ThumbSize                 = 2;
  sbs_AutoTrack                 = 4;
  sbs_AutoSize                  = $2000;

{ Scroll Bar messages }
  sbm_SetScrollBar              = $01A0;
  sbm_SetPos                    = $01A1;
  sbm_QueryPos                  = $01A2;
  sbm_QueryRange                = $01A3;
  sbm_SetThumbSize              = $01A6;

{ Scroll Bar Commands }
  sb_LineUp                     = 1;
  sb_LineDown                   = 2;
  sb_LineLeft                   = 1;
  sb_LineRight                  = 2;
  sb_PageUp                     = 3;
  sb_PageDown                   = 4;
  sb_PageLeft                   = 3;
  sb_PageRight                  = 4;
  sb_SliderTrack                = 5;
  sb_SliderPosition             = 6;
  sb_EndScroll                  = 7;

type
  PSbcData = ^SbcData;
  SbcData = record
    cb:       Word;
    sHilite:  Word;             { Reserved, should be set to zero }
    posFirst: SmallInt;
    posLast:  SmallInt;
    posThumb: SmallInt;
    cVisible: SmallInt;
    cTotal:   SmallInt;
  end;

  PFrameCData = ^FrameCData;
  FrameCData = record
    cb:            Word;
    flCreateFlags: ULong;
    hmodResources: Word;
    idResources:   Word;
  end;

{ Frame window styles }
{ All unused fcf_xxx bits are reserved }
const
  fcf_TitleBar                  = $00000001;
  fcf_SysMenu                   = $00000002;
  fcf_Menu                      = $00000004;
  fcf_SizeBorder                = $00000008;
  fcf_MinButton                 = $00000010;
  fcf_MaxButton                 = $00000020;
  fcf_MinMax                    = $00000030; { MinMax means BOTH buttons }
  fcf_VertScroll                = $00000040;
  fcf_HorzScroll                = $00000080;
  fcf_DlgBorder                 = $00000100;
  fcf_Border                    = $00000200;
  fcf_ShellPosition             = $00000400;
  fcf_TaskList                  = $00000800;
  fcf_NoByteAlign               = $00001000;
  fcf_NoMoveWithOwner           = $00002000;
  fcf_Icon                      = $00004000;
  fcf_AccelTable                = $00008000;
  fcf_SysModal                  = $00010000;
  fcf_ScreenAlign               = $00020000;
  fcf_MouseAlign                = $00040000;
  fcf_HideButton                = $01000000;
  fcf_HideMax                   = $01000020; { HideMax means BOTH buttons }
  fcf_Dbe_AppStat               = $80000000;
  fcf_AutoIcon                  = $40000000;

{ fcf_TitleBar or fcf_SysMenu or fcf_Menu or fcf_SizeBorder or fcf_MinMax or
  fcf_Icon or fcf_AccelTable or fcf_ShellPosition or fcf_TaskList }
  fcf_Standard                  = $0000CC3F;

  fs_Icon                       = $00000001;
  fs_AccelTable                 = $00000002;
  fs_ShellPosition              = $00000004;
  fs_TaskList                   = $00000008;
  fs_NoByteAlign                = $00000010;
  fs_NoMoveWithOwner            = $00000020;
  fs_SysModal                   = $00000040;
  fs_DlgBorder                  = $00000080;
  fs_Border                     = $00000100;
  fs_ScreenAlign                = $00000200;
  fs_MouseAlign                 = $00000400;
  fs_SizeBorder                 = $00000800;
  fs_AutoIcon                   = $00001000;
  fs_Dbe_AppStat                = $00008000;

{ fs_Icon OR fs_AccelTable OR fs_ShellPosition OR fs_TaskList }
  fs_Standard                   = $0000000F;

{ Frame Window Flags accessed via WinSet/QueryWindowUShort(qws_Flags) }
  ff_FlashWindow                = $0001;
  ff_Active                     = $0002;
  ff_FlashHilite                = $0004;
  ff_OwnerHidden                = $0008;
  ff_DlgDismissed               = $0010;
  ff_OwnerDisabled              = $0020;
  ff_Selected                   = $0040;
  ff_NoActivateSwp              = $0080;

function WinCreateStdWindow conv arg_os2 (Parent: HWnd; flStyle: ULong; var CreateFlags: ULong;
  ClientClass: PChar; Title: PChar; StyleClient: ULong; Module: HModule;
  IdResources: ULong; var ClientWindow: HWnd): HWnd; external 'PMWIN' index ord_Win32CreateStdWindow;
function WinFlashWindow conv arg_os2 (Frame: HWnd; Flash: Bool): Bool; external 'PMWIN' index ord_Win32FLashWindow;

{ Frame window related messages }
const
  wm_FlashWindow                = $0040;
  wm_FormatFrame                = $0041;
  wm_UpdateFrame                = $0042;
  wm_FocusChange                = $0043;
  wm_SetBorderSize              = $0044;
  wm_TrackFrame                 = $0045;
  wm_MinMaxFrame                = $0046;
  wm_SetIcon                    = $0047;
  wm_QueryIcon                  = $0048;
  wm_SetAccelTable              = $0049;
  wm_QueryAccelTable            = $004A;
  wm_TranslateAccel             = $004B;
  wm_QueryTrackInfo             = $004C;
  wm_QueryBorderSize            = $004D;
  wm_NextMenu                   = $004E;
  wm_EraseBackground            = $004F;
  wm_QueryFrameInfo             = $0050;
  wm_QueryFocusChain            = $0051;
  wm_OwnerPosChange             = $0052;
  wm_CalcFrameRect              = $0053;
{ Note $0054 is reserved }
  wm_WindowPosChanged           = $0055;
  wm_AdjustFramePos             = $0056;
  wm_QueryFrameCtlCount         = $0059;
{ Note $005A is reserved }
  wm_QueryHelpInfo              = $005B;
  wm_SetHelpInfo                = $005C;
  wm_Error                      = $005D;
  wm_RealizePalette             = $005E;

{ wm_QueryFrameInfo constants }
  fi_Frame                      = $00000001;
  fi_OwnerHide                  = $00000002;
  fi_ActivateOk                 = $00000004;
  fi_NoMoveWithOwner            = $00000008;

function WinCreateFrameControls conv arg_os2 (Frame: HWnd; var FCData: FrameCData; Title: PChar): Bool; external 'PMWIN' index ord_Win32CreateFrameControls;
function WinCalcFrameRect conv arg_os2 (Frame: HWnd; var R: RectL; Client: Bool): Bool;                 external 'PMWIN' index ord_Win32CalcFrameRect;
function WinGetMinPosition conv arg_os2 (Wnd: HWnd; var Swap: Swp; Point: PPointL): Bool;               external 'PMWIN' index ord_Win32GetMinPosition;
function WinGetMaxPosition conv arg_os2 (Wnd: HWnd; var Swap: Swp): Bool;                               external 'PMWIN' index ord_Win32GetMaxPosition;

type
  HSaveWp = LHandle;

function WinSaveWindowPos conv arg_os2 (SaveWp: HSaveWp; var Swap: Swp; Count: ULong): Bool; external 'PMWIN' index ord_Win32SaveWindowPos;

{ Frame control IDs    }
const
  fid_SysMenu                   = $8002;
  fid_TitleBar                  = $8003;
  fid_MinMax                    = $8004;
  fid_Menu                      = $8005;
  fid_VertScroll                = $8006;
  fid_HorzScroll                = $8007;
  fid_Client                    = $8008;
{ Note $8009 is reserved }
  fid_Dbe_AppStat               = $8010;
  fid_Dbe_KbdStat               = $8011;
  fid_Dbe_Pecic                 = $8012;
  fid_Dbe_KkPopup               = $8013;

{ Standard wm_SysCommand command values }
  sc_Size                       = $8000;
  sc_Move                       = $8001;
  sc_Minimize                   = $8002;
  sc_Maximize                   = $8003;
  sc_Close                      = $8004;
  sc_Next                       = $8005;
  sc_AppMenu                    = $8006;
  sc_SysMenu                    = $8007;
  sc_Restore                    = $8008;
  sc_NextFrame                  = $8009;
  sc_NextWindow                 = $8010;
  sc_TaskManager                = $8011;
  sc_HelpKeys                   = $8012;
  sc_HelpIndex                  = $8013;
  sc_HelpExtended               = $8014;
  sc_SwitchPanelIds             = $8015;
  sc_Dbe_First                  = $8018;
  sc_Dbe_Last                   = $801F;
  sc_BeginDrag                  = $8020;
  sc_EndDrag                    = $8021;
  sc_Select                     = $8022;
  sc_Open                       = $8023;
  sc_ContextMenu                = $8024;
  sc_ContextHelp                = $8025;
  sc_TextEdit                   = $8026;
  sc_BeginSelect                = $8027;
  sc_EndSelect                  = $8028;
  sc_Window                     = $8029;
  sc_Hide                       = $802A;

{ Title bar control messages }
  TBM_SETHILITE                 = $01E3;
  TBM_QUERYHILITE               = $01E4;

{ Rectangle routines }

function WinCopyRect conv arg_os2 (AB: Hab; var Dest,Src: RectL): Bool;           external 'PMWIN' index ord_Win32CopyRect;
function WinSetRect conv arg_os2 (AB: Hab; var R: RectL; xLeft,yBottom,xRight,yTop: Long): Bool; external 'PMWIN' index ord_Win32SetRect;
function WinIsRectEmpty conv arg_os2 (AB: Hab; var R: RectL): Bool;               external 'PMWIN' index ord_Win32IsRectEmpty;
function WinEqualRect conv arg_os2 (AB: Hab; var R1,R2: RectL): Bool;             external 'PMWIN' index ord_Win32EqualRect;
function WinSetRectEmpty conv arg_os2 (AB: Hab; var R: RectL): Bool;              external 'PMWIN' index ord_Win32SetRectEmpty;
function WinOffsetRect conv arg_os2 (AB: Hab; var R: RectL; cX,cY: Long): Bool;   external 'PMWIN' index ord_Win32OffsetRect;
function WinInflateRect conv arg_os2 (AB: Hab; var R: PRectL; cX,cY: Long): Bool; external 'PMWIN' index ord_Win32InflateRect;
function WinPtInRect conv arg_os2 (AB: Hab; var R: RectL; var Point: PointL): Bool; external 'PMWIN' index ord_Win32PtInRect;
function WinIntersectRect conv arg_os2 (AB: Hab; var Dest,Src1,Src2: RectL): Bool;  external 'PMWIN' index ord_Win32IntersectRect;
function WinUnionRect conv arg_os2 (AB: Hab; var Dest,Src1,Src2: RectL): Bool;      external 'PMWIN' index ord_Win32UnionRect;
function WinSubtractRect conv arg_os2 (AB: Hab; var Dest,Src1,Src2: RectL): Bool;   external 'PMWIN' index ord_Win32SubtractRect;
function WinMakeRect conv arg_os2 (AB: Hab; var R: RectL): Bool;                    external 'PMWIN' index ord_Win32MakeRect;
function WinMakePoints conv arg_os2 (AB: Hab; var Point: PointL; Count: ULong): Bool; external 'PMWIN' index ord_Win32MakePoints;

{ System values }

function WinQuerySysValue conv arg_os2 (Desktop: HWnd; Index: Long): Long; external 'PMWIN' index ord_Win32QuerySysValue;
function WinSetSysValue conv arg_os2 (Desktop: HWnd; Index,Value: Long): Bool; external 'PMWIN' index ord_Win32SetSysValue;

const
  sv_SwapButton                 = 0;
  sv_DblClkTime                 = 1;
  sv_CxDblClk                   = 2;
  sv_CyDblClk                   = 3;
  sv_CxSizeBorder               = 4;
  sv_CySizeBorder               = 5;
  sv_Alarm                      = 6;
  sv_ReservedFirst1             = 7;
  sv_ReservedLast1              = 8;
  sv_CursorRate                 = 9;
  sv_FirstScrollRate            = 10;
  sv_ScrollRate                 = 11;
  sv_NumberEdLists              = 12;
  sv_WarningFreq                = 13;
  sv_NoteFreq                   = 14;
  sv_ErrorFreq                  = 15;
  sv_WarningDuration            = 16;
  sv_NoteDuration               = 17;
  sv_ErrorDuration              = 18;
  sv_ReservedFirst              = 19;
  sv_ReservedLast               = 19;
  sv_CxScreen                   = 20;
  sv_CyScreen                   = 21;
  sv_CxVScroll                  = 22;
  sv_CyHScroll                  = 23;
  sv_CyVScrollArrow             = 24;
  sv_CxHScrollArrow             = 25;
  sv_CxBorder                   = 26;
  sv_CyBorder                   = 27;
  sv_CxDlgFrame                 = 28;
  sv_CyDlgFrame                 = 29;
  sv_CyTitleBar                 = 30;
  sv_CyVSlider                  = 31;
  sv_CxHSlider                  = 32;
  sv_CxMinMaxButton             = 33;
  sv_CyMinMaxButton             = 34;
  sv_CyMenu                     = 35;
  sv_CxFullScreen               = 36;
  sv_CyFullScreen               = 37;
  sv_CxIcon                     = 38;
  sv_CyIcon                     = 39;
  sv_CxPointer                  = 40;
  sv_CyPointer                  = 41;
  sv_Debug                      = 42;
  sv_CMouseButtons              = 43;
  sv_CPointerButtons            = 43;
  sv_PointerLevel               = 44;
  sv_CursorLevel                = 45;
  sv_TrackRectLevel             = 46;
  sv_CTimers                    = 47;
  sv_MousePresent               = 48;
  sv_CxByteAlign                = 49;
  sv_CxAlign                    = 49;
  sv_CyByteAlign                = 50;
  sv_CyAlign                    = 50;

{ The following value enables any greater value to be set by WinSetSysVlaue. }
{ Values of 51-55 are spare for extra non-settable system values             }
{ This is to enable the setting of sv_ExtraKeyBeep by applications.          }
  sv_NotReserved                = 56;
  sv_ExtraKeyBeep               = 57;

{ The following system value controls whether PM controls the keyboard      }
{ lights for light key keystrokes (else applications will)                  }
  sv_SetLights                  = 58;
  sv_InsertMode                 = 59;

  sv_MenuRollDownDelay          = 64;
  sv_MenuRollUpDelay            = 65;
  sv_AltMnemonic                = 66;
  sv_TaskListMouseAccess        = 67;

  sv_CxIconTextWidth            = 68;
  sv_CIconTextLines             = 69;

  sv_ChordTime                  = 70;
  sv_CxChord                    = 71;
  sv_CyChord                    = 72;
  sv_CxMotion                   = 73;
  sv_CyMotion                   = 74;

  sv_BeginDrag                  = 75;
  sv_EndDrag                    = 76;
  sv_SingleSelect               = 77;
  sv_Open                       = 78;
  sv_ContextMenu                = 79;
  sv_ContextHelp                = 80;
  sv_TextEdit                   = 81;
  sv_BeginSelect                = 82;
  sv_EndSelect                  = 83;

  sv_BeginDragKb                = 84;
  sv_EndDragKb                  = 85;
  sv_SelectKb                   = 86;
  sv_OpenKb                     = 87;
  sv_ContextMenuKb              = 88;
  sv_ContextHelpKb              = 89;
  sv_TextEditKb                 = 90;
  sv_BeginSelectKb              = 91;
  sv_EndSelectKb                = 92;

  sv_Animation                  = 93;
  sv_AnimationSpeed             = 94;

  sv_MonoIcons                  = 95;
  sv_KbdAltered                 = 96;
  sv_PrintScreen                = 97;
  sv_CSysValues                 = 98;

{ Presentation parameter structures }
type
  NpParam = ^Param;
  PParam = ^Param;
  Param = record
    id:   ULong;
    cb:   ULong;
    ab:   Byte;
  end;

  NpPresParams = ^PresParams;
  PPresParams = ^PresParams;
  PresParams = record
    cb:     ULong;
    aparam: Param;
  end;

{ Presentation parameter APIs }

function WinSetPresParam(Wnd: HWnd; Id,cbParam: ULong; pbParam: Pointer): Bool; external 'PMWIN' index ord_Win32SetPresParam;
function WinQueryPresParam(Wnd: HWnd; Id1,Id2: ULong; Id: PULong; cbBuf: ULong;
  pbBuf: Pointer; fs: ULong): ULong; external 'PMWIN' index ord_Win32QueryPresParam;
function WinRemovePresParam(Wnd: HWnd; Id: ULong): Bool; external 'PMWIN' index ord_Win32RemovePresParam;

{ Presentation parameter types }
const
  pp_ForegroundColor            = 1;
  pp_ForegroundColorIndex       = 2;
  pp_BackgroundColor            = 3;
  pp_BackgroundColorIndex       = 4;
  pp_HiliteForegroundColor      = 5;
  pp_HiliteForegroundColorIndex = 6;
  pp_HiliteBackgroundColor      = 7;
  pp_HiliteBackgroundColorIndex = 8;
  pp_DisabledForegroundColor    = 9;
  pp_DisabledForegroundColorIndex = 10;
  pp_DisabledBackgroundColor    = 11;
  pp_DisabledBackgroundColorIndex = 12;
  pp_BorderColor                = 13;
  pp_BorderColorIndex           = 14;
  pp_FontNameSize               = 15;
  pp_FontHandle                 = 16;
  pp_Reserved                   = 17;
  pp_ActiveColor                = 18;
  pp_ActiveColorIndex           = 19;
  pp_InactiveColor              = 20;
  pp_InactiveColorIndex         = 21;
  pp_ActiveTextFgndColor        = 22;
  pp_ActiveTextFgndColorIndex   = 23;
  pp_ActiveTextBgndColor        = 24;
  pp_ActiveTextBgndColorIndex   = 25;
  pp_InactiveTextFgndColor      = 26;
  pp_InactiveTextFgndColorIndex = 27;
  pp_InactiveTextBgndColor      = 28;
  pp_InactiveTextBgndColorIndex = 29;
  pp_Shadow                     = 30;
  pp_MenuForegroundColor        = 31;
  pp_MenuForegroundColorIndex   = 32;
  pp_MenuBackgroundColor        = 33;
  pp_MenuBackgroundColorIndex   = 34;
  pp_MenuHiliteFgndColor        = 35;
  pp_MenuHiliteFgndColorIndex   = 36;
  pp_MenuHiliteBgndColor        = 37;
  pp_MenuHiliteBgndColorIndex   = 38;
  pp_MenuDisabledFgndColor      = 39;
  pp_MenuDisabledFgndColorIndex = 40;
  pp_MenuDisabledBgndColor      = 41;
  pp_MenuDisabledBgndColorIndex = 42;

  pp_User                       = $8000;

{ Flags for WinQueryPresParams }
  qpf_NoInherit                 = $0001; { Don't inherit                      }
  qpf_Id1ColorIndex             = $0002; { Convert id1 color index into RGB   }
  qpf_Id2ColorIndex             = $0004; { Convert id2 color index into RGB   }
  qpf_PureRGBColor              = $0008; { Return pure RGB colors             }
  qpf_ValidFlags                = $000F; { Valid WinQueryPresParams flags     }

{ System color functions }

function WinQuerySysColor conv arg_os2 (Desktop: HWnd; Color,Reserved: Long): Long; external 'PMWIN' index ord_Win32QuerySysColor;
function WinSetSysColors conv arg_os2 (Desktop: HWnd; Options,Format: ULong;
  FirstColor: Long; ColorCount: ULong; PColor: PLong): Bool; external 'PMWIN' index ord_Win32SetSysColors;

const
  sysclr_ShadowHiliteBgnd       = -50;
  sysclr_ShadowHiliteFgnd       = -49;
  sysclr_ShadowText             = -48;
  sysclr_EntryField             = -47;
  sysclr_MenuDisabledText       = -46;
  sysclr_MenuHilite             = -45;
  sysclr_MenuHiliteBgnd         = -44;
  sysclr_PageBackground         = -43;
  sysclr_FieldBackground        = -42;
  sysclr_ButtonLight            = -41;
  sysclr_ButtonMiddle           = -40;
  sysclr_ButtonDark             = -39;
  sysclr_ButtonDefault          = -38;
  sysclr_TitleBottom            = -37;
  sysclr_Shadow                 = -36;
  sysclr_IconText               = -35;
  sysclr_DialogBackground       = -34;
  sysclr_HiliteForeground       = -33;
  sysclr_HiliteBackground       = -32;
  sysclr_InactiveTitleTextBgnd  = -31;
  sysclr_ActiveTitleTextBgnd    = -30;
  sysclr_InactiveTitleText      = -29;
  sysclr_ActiveTitleText        = -28;
  sysclr_OutputText             = -27;
  sysclr_WindowStaticText       = -26;
  sysclr_ScrollBar              = -25;
  sysclr_BackGround             = -24;
  sysclr_ActiveTitle            = -23;
  sysclr_InactiveTitle          = -22;
  sysclr_Menu                   = -21;
  sysclr_Window                 = -20;
  sysclr_WindowFrame            = -19;
  sysclr_MenuText               = -18;
  sysclr_WindowText             = -17;
  sysclr_TitleText              = -16;
  sysclr_ActiveBorder           = -15;
  sysclr_InactiveBorder         = -14;
  sysclr_AppWorkSpace           = -13;
  sysclr_HelpBackGround         = -12;
  sysclr_HelpText               = -11;
  sysclr_HelpHilite             = -10;
  sysclr_CSysColors             = 41;

{ Timer manager }

function WinStartTimer conv arg_os2 (AB: Hab; Wnd: HWnd; IdTimer, Timeout: ULong): ULong; external 'PMWIN' index ord_Win32StartTimer;
function WinStopTimer conv arg_os2 (AB: Hab; Wnd: HWnd; IdTimer: ULong): Bool;            external 'PMWIN' index ord_Win32StopTimer;
function WinGetCurrentTime conv arg_os2 (AB: Hab): ULong;                                 external 'PMWIN' index ord_Win32GetCurrentTime;

const
  tid_Cursor                    = $FFFF; { Reserved cursor timer ID              }
  tid_Scroll                    = $FFFE; { Reserved scrolling timer ID           }
  tid_FlashWindow               = $FFFD; { Reserved for window flashing timer ID }
  tid_UserMax                   = $7FFF; { Maximum user timer ID                 }

type
  HAccel = LHandle;

{ Accelerator functions }
{ Accel fs bits         }
{ NOTE: the first six af_ code bits have the same value as their kc_ counterparts }
const
  af_Char                       = $0001;
  af_VirtualKey                 = $0002;
  af_ScanCode                   = $0004;
  af_Shift                      = $0008;
  af_Control                    = $0010;
  af_Alt                        = $0020;
  af_LoneKey                    = $0040;
  af_SysCommand                 = $0100;
  af_Help                       = $0200;

type
  PAccel = ^Accel;
  Accel = record
    fs:  Word;
    Key: Word;
    Cmd: Word;
  end;

  PAccelTable = ^AccelTable;
  AccelTable = record
    cAccel: Word;
    CodePage: Word;
    aaccel: Accel;
  end;

function WinLoadAccelTable conv arg_os2 (AB: Hab; Module: HModule; IdAccelTable: ULong): HAccel; external 'PMWIN' index ord_Win32LoadAccelTable;
function WinCopyAccelTable conv arg_os2 (Acl: HAccel; AclTable: PAccelTable;
  cbCopyMax: ULong): ULong; external 'PMWIN' index ord_Win32CopyAccelTable;
function WinCreateAccelTable conv arg_os2 (AB: Hab; var AclTable: AccelTable): HAccel; external 'PMWIN' index ord_Win32CreateAccelTable;
function WinDestroyAccelTable conv arg_os2 (Acl: HAccel): Bool; external 'PMWIN' index ord_Win32DestroyAccelTable;
function WinTranslateAccel conv arg_os2 (AB: Hab; Wnd: HWnd; Acl: HAccel; var Msg: QMsg): Bool; external 'PMWIN' index ord_Win32TranslateAccel;
function WinSetAccelTable conv arg_os2 (AB: Hab; Acl: HAccel; Frame: HWnd): Bool; external 'PMWIN' index ord_Win32SetAccelTable;
function WinQueryAccelTable conv arg_os2 (AB: Hab; Frame: HWnd): HAccel; external 'PMWIN' index ord_Win32QueryAccelTable;

{ Extended Attribute Flags (Association Table) }
const
  eaf_DefaultOwner              = $0001;
  eaf_Unchangeable              = $0002;
  eaf_ReuseIcon                 = $0004;

{ WinTrackRect information }
type
  PTrackInfo = ^TrackInfo;
  TrackInfo = record
    cxBorder:        Long;
    cyBorder:        Long;
    cxGrid:          Long;
    cyGrid:          Long;
    cxKeyboard:      Long;
    cyKeyboard:      Long;
    rclTrack:        RectL;
    rclBoundary:     RectL;
    ptlMinTrackSize: PointL;
    ptlMaxTrackSize: PointL;
    fs:              ULong;
  end;

function WinTrackRect conv arg_os2 (Wnd: HWnd; PS: Hps; var Info: TrackInfo): Bool; external 'PMWIN' index ord_Win32TrackRect;
function WinShowTrackRect conv arg_os2 (Wnd: HWnd; Show: Bool): Bool; external 'PMWIN' index ord_Win32ShowTrackRect;

{ WinTrackRect flags }
const
  tf_Left                       = $0001;
  tf_Top                        = $0002;
  tf_Right                      = $0004;
  tf_Bottom                     = $0008;
  { tf_Move = tf_Left or tf_Top or tf_Right or tf_Bottom }
  tf_Move                       = $000F;

  tf_SetPointerPos              = $0010;
  tf_Grid                       = $0020;
  tf_Standard                   = $0040;
  tf_AllInBoundary              = $0080;
  tf_ValidateTrackRect          = $0100;
  tf_PartInBoundary             = $0200;

{ Clipboard Manager  }
{ Clipboard messages }
  wm_RenderFmt                  = $0060;
  wm_RenderAllFmts              = $0061;
  wm_DestroyClipboard           = $0062;
  wm_PaintClipboard             = $0063;
  wm_SizeClipboard              = $0064;
  wm_HScrollClipboard           = $0065;
  wm_VScrollClipboard           = $0066;
  wm_DrawClipBoard              = $0067;

{ Standard Clipboard formats }
  cf_Text                       = 1;
  cf_BitMap                     = 2;
  cf_DspText                    = 3;
  cf_DspBitMap                  = 4;
  cf_MetaFile                   = 5;
  cf_DspMetaFile                = 6;
  cf_Palette                    = 9;

{ standard DDE and clipboard format stings }
  szfmt_Text                    = '1';
  szfmt_BitMap                  = '2';
  szfmt_DspText                 = '3';
  szfmt_DspBitMap               = '4';
  szfmt_MetaFile                = '5';
  szfmt_DspMetaFile             = '6';
  szfmt_Palette                 = '9';
  szfmt_Sylk                    = 'Sylk';
  szfmt_Dif                     = 'Dif';
  szfmt_Tiff                    = 'Tiff';
  szfmt_OemText                 = 'OemText';
  szfmt_Dib                     = 'Dib';
  szfmt_OwnerDisplay            = 'OwnerDisplay';
  szfmt_Link                    = 'Link';
  szfmt_MetaFilePict            = 'MetaFilePict';
  szfmt_DspMetaFilePict         = 'DspMetaFilePict';
  szfmt_CpText                  = 'Codepage Text';
  szddefmt_Rtf                  = 'Rich Text Format';
  szddefmt_PtrPict              = 'Printer_Picture';

type
  PMfp = ^Mfp;
  Mfp = record
    sizeBounds: PointL; { metafile notional grid size      }
    sizeMM:     PointL; { metafile size high metric units  }
    cbLength:   ULong;  { length of metafile data          }
    mapMode:    Word;   { a PM metaflie map mode           }
    reserved:   Word;
    abData:     Byte;   { metafile Data                    }
  end;

  PCpText = ^CpText;
  CpText = record
    idCountry:   Word;
    usCodepage:  Word;
    usLangID:    Word;
    usSubLangID: Word;
    abText:      Char;  { text string starts here          }
  end;

function WinSetClipbrdOwner conv arg_os2 (AB: Hab; Wnd: HWnd): Bool; external 'PMWIN' index ord_Win32SetClipbrdOwner;
function WinSetClipbrdData conv arg_os2 (AB: Hab; Data,Fmt,rgfFmtInfo: ULong): Bool; external 'PMWIN' index ord_Win32SetClipbrdData;
function WinQueryClipbrdData conv arg_os2 (AB: Hab; Fmt: ULong): ULong; external 'PMWIN' index ord_Win32QueryClipbrdData;
function WinQueryClipbrdFmtInfo conv arg_os2 (AB: Hab; Fmt: ULong; var FmtInfo: PULong): Bool; external 'PMWIN' index ord_Win32QueryClipbrdFmtInfo;
function WinSetClipbrdViewer conv arg_os2 (AB: Hab; NewClipViewer: HWnd): Bool; external 'PMWIN' index ord_Win32SetClipbrdViewer;

{ WinSetClipbrdData flags }
const
  cfi_OwnerFree                 = $0001;
  cfi_OwnerDisplay              = $0002;
  cfi_Pointer                   = $0400;
  cfi_Handle                    = $0200;

function WinEnumClipbrdFmts conv arg_os2 (AB: Hab; Fmt: ULong): ULong; external 'PMWIN' index ord_Win32EnumClipbrdFmts;
function WinEmptyClipbrd conv arg_os2 (AB: Hab): Bool;                 external 'PMWIN' index ord_Win32EmptyClipbrd;
function WinOpenClipbrd conv arg_os2 (AB: Hab): Bool;                  external 'PMWIN' index ord_Win32OpenClipbrd;
function WinCloseClipbrd conv arg_os2 (AB: Hab): Bool;                 external 'PMWIN' index ord_Win32CloseClipbrd;
function WinQueryClipbrdOwner conv arg_os2 (AB: Hab): HWnd;            external 'PMWIN' index ord_Win32QueryClipbrdOwner;
function WinQueryClipbrdViewer conv arg_os2 (AB: Hab): HWnd;           external 'PMWIN' index ord_Win32QueryClipbrdViewer;

{ Cursor manager common subsection }
function WinDestroyCursor conv arg_os2 (Wnd: HWnd): Bool;              external 'PMWIN' index ord_Win32DestroyCursor;
function WinShowCursor conv arg_os2 (Wnd: HWnd; Show: Bool): Bool;     external 'PMWIN' index ord_Win32ShowCursor;
function WinCreateCursor conv arg_os2 (Wnd: HWnd; X,Y,cX,cY: Long; fs: ULong; Clip: PRectL): Bool; external 'PMWIN' index ord_Win32CreateCursor;

{ WinCreateCursor flags }
const
  cursor_Solid                  = $0000;
  cursor_HalfTone               = $0001;
  cursor_Frame                  = $0002;
  cursor_Flash                  = $0004;
  cursor_SetPos                 = $8000;

type
  PCursorInfo = ^CursorInfo;
  CursorInfo = record
    HWnd:    HWnd;
    x:       Long;
    y:       Long;
    cx:      Long;
    cy:      Long;
    fs:      ULong;
    rclClip: RectL;
  end;

function WinQueryCursorInfo conv arg_os2 (Desktop: HWnd; var CurInfo: CursorInfo): Bool; external 'PMWIN' index ord_Win32QueryCursorInfo;

{ Pointer manager }
type
  HPointer = LHandle;

function WinSetPointer conv arg_os2 (Desktop: HWnd; PtrNew: HPointer): Bool;                 external 'PMWIN' index ord_Win32Setpointer;
function WinSetPointerOwner conv arg_os2 (Ptr: HPointer; Pid: Pid; Destroy: Bool): Bool;     external 'PMWIN' index ord_Win32SetPointerOwner;
function WinShowPointer conv arg_os2 (Desktop: HWnd; Show: Bool): Bool;                      external 'PMWIN' index ord_Win32ShowPointer;
function WinQuerySysPointer conv arg_os2 (Desktop: HWnd; Index: Long; Load: Bool): HPointer; external 'PMWIN' index ord_Win32QuerySysPointer;

{ System pointers (NOTE: these are 1-based) }
const
  sptr_Arrow                    = 1;
  sptr_Text                     = 2;
  sptr_Wait                     = 3;
  sptr_Size                     = 4;
  sptr_Move                     = 5;
  sptr_Sizenwse                 = 6;
  sptr_Sizenesw                 = 7;
  sptr_Sizewe                   = 8;
  sptr_Sizens                   = 9;
  sptr_AppIcon                  = 10;

  sptr_IconInformation          = 11;
  sptr_IconQuestion             = 12;
  sptr_IconError                = 13;
  sptr_IconWarning              = 14;
  sptr_CPtr                     = 14;   { count loaded by pmwin }

  sptr_Illegal                  = 18;
  sptr_File                     = 19;
  sptr_Folder                   = 20;
  sptr_Multfile                 = 21;
  sptr_Program                  = 22;

{ backward compatibility }
  sptr_HandIcon                 = sptr_IconError;
  sptr_QuesIcon                 = sptr_IconQuestion;
  sptr_BangIcon                 = sptr_IconWarning;
  sptr_NoteIcon                 = sptr_IconInformation;

function WinLoadPointer conv arg_os2 (Desktop: HWnd; Module: HModule; IdRes: ULong): HPointer; external 'PMWIN' index ord_Win32LoadPointer;
function WinCreatePointer conv arg_os2 (Desktop: HWnd; hbmPointer: HBitMap; fPointer: Bool;
  xHotspot,yHotspot: Long): HPointer;                                            external 'PMWIN' index ord_Win32CreatePointer;
function WinSetPointerPos conv arg_os2 (Desktop: HWnd; X,Y: Long): Bool;                       external 'PMWIN' index ord_Win32SetPointerPos;
function WinDestroyPointer conv arg_os2 (Ptr: HPointer): Bool;                                 external 'PMWIN' index ord_Win32DestroyPointer;
function WinQueryPointer conv arg_os2 (Desktop: HWnd): HPointer;                               external 'PMWIN' index ord_Win32QueryPointer;
function WinQueryPointerPos conv arg_os2 (Desktop: HWnd; var Point: PointL): Bool;             external 'PMWIN' index ord_Win32QueryPointerPos;

type
  PPointerInfo = ^PointerInfo;
  PointerInfo = record
    fPointer:       ULong;
    xHotspot:       Long;
    yHotspot:       Long;
    hbmPointer:     HBitMap;
    hbmColor:       HBitMap;
    hbmMiniPointer: HBitMap;
    hbmMiniColor:   HBitMap;
  end;

function WinCreatePointerIndirect conv arg_os2 (Desktop: HWnd; var PtrInfo: PointerInfo): HPointer; external 'PMWIN' index ord_Win32CreatePointerIndirect;
function WinQueryPointerInfo conv arg_os2 (Ptr: HPointer; var PtrInfo: PointerInfo): Bool;          external 'PMWIN' index ord_Win32QueryPointerInfo;
function WinDrawPointer conv arg_os2 (PS: Hps; X,Y: Long; Ptr: HPointer; fs: ULong): Bool;          external 'PMWIN' index ord_Win32DrawPointer;

{ WinDrawPointer() constants }
const
  dp_Normal                     = $0000;
  dp_Halftoned                  = $0001;
  dp_Inverted                   = $0002;

function WinGetSysBitmap conv arg_os2 (Desktop: HWnd; ibm: ULong): HBitMap; external 'PMWIN' index ord_Win32GetSysBitmap;

{ System bitmaps (NOTE: these are 1-based) }
const
  sbmp_Old_SysMenu              = 1;
  sbmp_Old_SbUpArrow            = 2;
  sbmp_Old_SbDnArrow            = 3;
  sbmp_Old_SbRgArrow            = 4;
  sbmp_Old_SbLfArrow            = 5;
  sbmp_MenuCheck                = 6;
  sbmp_Old_CheckBoxes           = 7;
  sbmp_BtnCorners               = 8;
  sbmp_Old_MinButton            = 9;
  sbmp_Old_MaxButton            = 10;
  sbmp_Old_RestoreButton        = 11;
  sbmp_Old_ChildSysMenu         = 12;
  sbmp_Drive                    = 15;
  sbmp_File                     = 16;
  sbmp_Folder                   = 17;
  sbmp_TreePlus                 = 18;
  sbmp_TreeMinus                = 19;
  sbmp_Program                  = 22;
  sbmp_MenuAttached             = 23;
  sbmp_SizeBox                  = 24;
  sbmp_SysMenu                  = 25;
  sbmp_MinButton                = 26;
  sbmp_MaxButton                = 27;
  sbmp_RestoreButton            = 28;
  sbmp_ChildSysMenu             = 29;
  sbmp_SysMenuDep               = 30;
  sbmp_MinButtonDep             = 31;
  sbmp_MaxButtonDep             = 32;
  sbmp_RestoreButtonDep         = 33;
  sbmp_ChildSysMenuDep          = 34;
  sbmp_SbUpArrow                = 35;
  sbmp_SbDnArrow                = 36;
  sbmp_SbLfArrow                = 37;
  sbmp_SbRgArrow                = 38;
  sbmp_SbUpArrowDep             = 39;
  sbmp_SbDnArrowDep             = 40;
  sbmp_SbLfArrowDep             = 41;
  sbmp_SbRgArrowDep             = 42;
  sbmp_SbUpArrowDis             = 43;
  sbmp_SbDnArrowDis             = 44;
  sbmp_SbLfArrowDis             = 45;
  sbmp_SbRgArrowDis             = 46;
  sbmp_ComBoDown                = 47;
  sbmp_CheckBoxes               = 48;

{ Hook manager }

function WinSetHook conv arg_os2 (AB: Hab; Mq: Hmq; iHook: Long; HookFunc: PFn;
  Module: HModule): Bool; external 'PMWIN' index ord_Win32SetHook;
function WinReleaseHook conv arg_os2 (AB: Hab; Mq: Hmq; iHook: Long; HookFunc: Pointer;
  Module: HModule): Bool; external 'PMWIN' index ord_Win32ReleaseHook;
function WinCallMsgFilter conv arg_os2 (AB: Hab; var Msg: QMsg; MsgF: ULong): Bool; external 'PMWIN' index ord_Win32CallMsgFilter;

{ Hook codes }
{ 32-bit hook will receive Long parameters }
const
  hk_SendMsg                    = 0;
  { procedure SendMsgHook(AB: Hab;                      ** installer's hab
  *                       var Smh: SmhStruct;           ** p send msg struct
  *                       InterTask: Bool);             ** between threads }

  hk_Input                      = 1;
  { function InputHook(AB: Hab;                         ** installer's hab
  *                    var Msg: QMsg;                   ** p qmsg
  *                    fs: ULong): Bool;                ** remove/noremove }

  hk_MsgFilter                  = 2;
  { function MsgFilterHook(AB: Hab;                     ** installer's hab
  *                        var Msg: QMsgg,              ** p qmsg
  *                        Msgf: ULong): Bool;          ** filter flag }

  hk_JournalRecord              = 3;
  { procedure JournalRecordHook(AB: Hab;                ** installer's hab
  *                             var Msg: WMsg);         ** p qmsg }

  hk_JournalPlayBack            = 4;
  { function JournalPlaybackHook(AB: Hab;               **installer's hab
  *                           Skip: Bool fSkip,         ** skip messages
  *                           var Msg: QMsg): ULong;    ** p qmsg }

  hk_Help                       = 5;
  { function HelpHook(AB: Hab;                          ** installer's hab
  *                   Mode:  ULong;                     ** mode
  *                   Topic: ULong;                     ** main topic
  *                   SubTopic: ULong;                  ** sub topic
  *                   var Pos: RectL): Bool;            ** associated position }
  hk_Loader                     = 6;
  { function LoaderHook(AB: Hab;                        ** installer's hab
  *                     IdContext: Long;                ** who called hook
  *                     LibName: PChar;                 ** lib name string
  *                     var Lib: HLib;                  ** p to lib handle
  *                     ProcName: PChar;                ** procedure name
  *                     WndProc: FnWp): Bool;           ** window procedure }

  hk_RegisterUserMsg            = 7;
  { function RegisterUserHook(AB: Hab;                  ** installer's hab
  *                        Count: ULong;                ** entries in arRMP
  *                        arPMP: PULong;               ** RMP array
  *                        var Registered: Bool): Bool; ** msg parms already reg}

  hk_MsgControl                 = 8;
  { function MsgControlHook(AB: Hab;                    ** installer's hab
  *                        IdContext: Long;             ** who called hook
  *                        Wnd: HWnd;                   ** SEI window handle
  *                        ClassName: PChar;            ** window class name
  *                        MsgClass: ULong;             ** interested msg class **
  *                        IdControl: Long;             ** SMI_*
  *                        var Success: Bool): Bool;    ** mode already set}

  hk_PList_eEtry                = 9;
  { function ProgramListEntryHook(AB: Hab;              ** installer's hab
  *             var ProfileHookParams: PrfHookParms;    ** data
  *             var NoExecute: Bool): Bool;             ** cease hook processing}

  hk_PList_Exit                 = 10;
  { function ProgramListExitHook(AB: Hab;               ** installer's hab
  *         var ProfileHookParams: PrfHookParms): Bool; ** data}

  hk_FindWord                   = 11;
  { function FindWordHook(Codepage: ULong;              ** code page to use
  *                       Text: PChar;                  ** text to break
  *                       cb: ULong;                    ** maximum text size
  *                       ich: ULong;                   ** break 'near' here
  *                       pichStart: PULong;            ** where break began
  *                       pichEnd: PULong;              ** where break ended
  *                       pichNext: PULong): Bool;      ** where next word begin}

  hk_CodePageChanged            = 12;
  { procedure CodePageChangedHook(Mq: Hmq;              ** msg q handle
  *                               OldCodepage: ULong;   ** old code page
  *                               NewCodepage: ULong);  ** new code page}

  hk_WindowDC                   = 15;
  { function WindowDCHook(AB: Hab;                      ** installer's hab
  *                       Dc: Hdc;                      ** current Hdc
  *                       Wnd: HWnd;                    ** current HWnd
  *                       Assoc: Bool): Bool;           ** association flag}

  hk_DESTROYWINDOW              = 16;
  { function DestroyWindowHook(AB: Hab;                 ** installer's hab
  *                            Wnd: HWnd;               ** destroyed win HWnd
  *                            Reserved: ULong): Bool;  ** association flag}
  hk_CHECKMSGFILTER             = 20;
  { function CheckMsgFilteHook(AB: Hab;                 ** installer's hab
  *                            Msg: QMsg;               ** p qmsg
  *                            First,Last: ULong;       ** first and last msg
  *                            Options: ULong): Bool;   ** flags  }

{ Current message queue constant }
  hmq_Current                   = Hmq(1);

{ wh_MsgFilter context codes }
  msgf_DialogBox                = 1;
  msgf_MessageBox               = 2;
  msgf_Track                    = 8;
  msgf_DDepostMsg               = 3;

{ hk_Help Help modes }
  hlpm_Frame                    = -1;
  hlpm_Window                   = -2;
  hlpm_Menu                     = -3;

{ hk_SendMsg structure }
  pm_Model_1x                   = 0;
  pm_Model_2x                   = 1;

type
  PSmhStruct = ^SmhStruct;
  SmhStruct = record
    mp2:   MParam;
    mp1:   MParam;
    msg:   ULong;
    HWnd:  HWnd;
    model: ULong;
  end;

{ hk_Loader context codes }
const
  lhk_DeleteProc                = 1;
  lhk_DeleteLib                 = 2;
  lhk_LoadProc                  = 3;
  lhk_LoadLib                   = 4;

{ hk_MsgControl context codes }
  mchk_MsgInterest              = 1;
  mchk_ClassMsgInterest         = 2;
  mchk_Synchronisation          = 3;
  mchk_MsgMode                  = 4;

{ hk_RegisterUserMsg conext codes }
  rumhk_DataType                = 1;
  rumhk_Msg                     = 2;

function WinSetClassThunkProc    conv arg_os2 (ClassName: PChar; ThunkProc: PFn): Bool; external 'PMWIN' index ord_Win32SetClassThunkProc;
function WinQueryClassThunkProc  conv arg_os2 (ClassName: PChar): PFn;                  external 'PMWIN' index ord_Win32queryClassThunkProc;
function WinSetWindowThunkProc   conv arg_os2 (Wnd: HWnd; ThunkProc: PFn): Bool;        external 'PMWIN' index ord_Win32SetwindowThunkProc;
function WinQueryWindowThunkProc conv arg_os2 (Wnd: HWnd): PFn;                         external 'PMWIN' index ord_Win32querywindowThunkProc;
function WinQueryWindowModel     conv arg_os2 (Wnd: HWnd): Long;                        external 'PMWIN' index ord_Win32querywindowmodel;

{ Shell API is declared in the PmShl unit }

{function WinQueryCp(Mq: Hmq): ULong;
function WinSetCp(Mq: Hmq; IdCodePage: ULong): Bool;
function WinQueryCpList(AB: Hab; ccpMax: ULong; PrgCp: PULong): ULong;
function WinCpTranslateString(AB: Hab; cpSrc: ULong; Src: PChar;
  cpDst: ULong; cchDestMax: ULong; Dest: PChar): Bool;
function WinCpTranslateChar(AB: Hab; cpSrc: ULong; Src: Char; cpDest: ULong): Char;
function WinUpper(AB: Hab; IdCp,IdCc: ULong; Str: PChar): ULong;
function WinUpperChar(AB: Hab; IdCp,IdCc: ULong; C: ULong): ULong;
function WinNextChar(AB: Hab; IdCp,IdCc: ULong; Str: PChar): PChar;
function WinPrevChar(AB: Hab; IdCp,IdCc: ULong; Start,Str: PChar): PChar;
function WinCompareStrings(AB: Hab; IdCp,IdCcc: ULong; Str1,Str2: PChar;
  Reserved: ULong): ULong;}

const
  wcs_Error                     = 0;
  wcs_Eq                        = 1;
  wcs_Lt                        = 2;
  wcs_Gt                        = 3;

{ Atom Manager Interface declarations }

type
  HAtomTbl = LHandle;
  Atom = ULong;

function WinQuerySystemAtomTable conv arg_os2 : HAtomTbl;                        external 'PMWIN' index ord_Win32QuerySystemAtomTable;
function WinCreateAtomTable conv arg_os2 (cbInitial,cBuckets: ULong): HAtomTbl;  external 'PMWIN' index ord_Win32CreateAtomTable;
function WinDestroyAtomTable conv arg_os2 (AtomTbl: HAtomTbl): HAtomTbl;         external 'PMWIN' index ord_Win32DestroyAtomTable;
function WinAddAtom conv arg_os2 (AtomTbl: HAtomTbl; AtomName: PChar): Atom;     external 'PMWIN' index ord_Win32AddAtom;
function WinFindAtom conv arg_os2 (AtomTbl: HAtomTbl; AtomName: Pchar): Atom;    external 'PMWIN' index ord_Win32FindAtom;
function WinDeleteAtom conv arg_os2 (AtomTbl: HAtomTbl; Atom: Atom): Atom;       external 'PMWIN' index ord_Win32DeleteAtom;
function WinQueryAtomUsage conv arg_os2 (AtomTbl: HAtomTbl; Atom: Atom): ULong;  external 'PMWIN' index ord_Win32QueryAtomUsage;
function WinQueryAtomLength conv arg_os2 (AtomTbl: HAtomTbl; Atom: Atom): ULong; external 'PMWIN' index ord_Win32QueryAtomLength;
function WinQueryAtomName conv arg_os2 (AtomTbl: HAtomTbl; Atom: Atom; Buffer: PChar;
  BufferMax: ULong): ULong; external 'PMWIN' index ord_Win32QueryAtomName;

{ Error codes for debugging support                              }
{ $1001 - $1021, $1034, $1036 - $1050 are reserved               }
const
  windbg_HWnd_Not_Destroyed     = $1022;
  windbg_HPtr_Not_Destroyed     = $1023;
  windbg_HAccel_Not_Destroyed   = $1024;
  windbg_HEnum_Not_Destroyed    = $1025;
  windbg_Visrgn_Sem_Busy        = $1026;
  windbg_User_Sem_Busy          = $1027;
  windbg_Dc_Cache_Busy          = $1028;
  windbg_Hook_Still_Installed   = $1029;
  windbg_Window_Still_Locked    = $102A;
  windbg_Updateps_Assertion_Fail = $102B;
  windbg_Sendmsg_Within_User_Sem = $102C;
  windbg_User_Sem_Not_Entered   = $102D;
  windbg_Proc_Not_Exported      = $102E;
  windbg_Bad_SendMsg_HWnd       = $102F;
  windbg_Abnormal_Exit          = $1030;
  windbg_Internal_Revision      = $1031;
  windbg_InitSystem_Failed      = $1032;
  windbg_HAtomTbl_Not_Destroyed = $1033;
  windbg_Window_Unlock_Wait     = $1035;

{ Get/Set Error Information Interface declarations }
type
  PErrInfo = ^ErrInfo;
  ErrInfo = record
    cbFixedErrInfo: ULong;
    idError:        ErrorId;
    cDetailLevel:   ULong;
    offaoffszMsg:   ULong;
    offBinaryData:  ULong;
  end;

function WinGetLastError conv arg_os2 (AB: Hab): ErrorId;                        external 'PMWIN' index ord_Win32GetLastError;
function WinGetErrorInfo conv arg_os2 (AB: Hab): PErrInfo;                       external 'PMWIN' index ord_Win32GetErrorInfo;
function WinFreeErrorInfo conv arg_os2 (var ErrInf: ErrInfo): Bool;              external 'PMWIN' index ord_Win32FreeErrorInfo;
//function WinSetErrorInfo conv arg_os2 (Err: ErrorId; Arguments: ULong): ErrorId; external 'PMWIN' index ord_Win32SetErrorInfo;

{ Important!: Original C declaration of this function is:            }
{             ERRORID APIENTRY WinSetErrorInfo(ERRORID, ULONG, ...); }
{ Virtual Pascal doesn't support variable number of parameters, so   }
{ the only issue is to call this function via special wrapper        }
{ function written in the inline assembler.                          }

const
  sei_Breakpoint                = $8000; { Always enter an INT 3 breakpt       }
  sei_NoBeep                    = $4000; { Do not call DosBeep                 }
  sei_NoPrompt                  = $2000; { Do not prompt the user              }
  sei_DbgRsrvd                  = $1000; { Reserved for debug use              }

  sei_StackTrace                = $0001; { save the stack trace                }
  sei_Registers                 = $0002; { save the registers                  }
  sei_ArgCount                  = $0004; { first Word in args is arg count     }
  sei_DosError                  = $0008; { first Word in args is OS2 error code}
  sei_Reserved                  = $0FE0; { Reserved for future use             }
  sei_DebugOnly                 = sei_Breakpoint or sei_NoBeep or sei_NoPrompt or sei_Reserved;

{ DDE standard system topic and item strings }
  szddesys_Topic                = 'System';
  szddesys_Item_Topics          = 'Topics';
  szddesys_Item_SysItems        = 'SysItems';
  szddesys_Item_RtnMsg          = 'ReturnMessage';
  szddesys_Item_Status          = 'Status';
  szddesys_Item_Formats         = 'Formats';
  szddesys_Item_Security        = 'Security';
  szddesys_Item_ItemFormats     = 'ItemFormats';
  szddesys_Item_Help            = 'Help';
  szddesys_Item_Protocols       = 'Protocols';
  szddesys_Item_Restart         = 'Restart';

{ Dynamic Data Exchange (DDE) Structure Declarations }
type
  PConvContext = ^ConvContext;
  ConvContext = record
    cb:          ULong;         { SizeOf(ConvContext) }
    fsContext:   ULong;
    idCountry:   ULong;
    usCodepage:  ULong;
    usLangID:    ULong;
    usSubLangID: ULong;
  end;

const
  ddectxt_CaseSensitive         = $0001;

type
  PDdeInit = ^DdeInit;
  DdeInit = record
    cb:             ULong;      { SizeOf(DdeInit) }
    pszAppName:     PChar;
    pszTopic:       PChar;
    offConvContext: ULong;
  end;

  PDdeStruct = ^DdeStruct;
  DdeStruct = record
    cbData:        ULong;
    fsStatus:      Word;
    usFormat:      Word;
    offszItemName: Word;
    offabData:     Word;
  end;

{ DDE constants for wStatus field }
const
  dde_Fack                      = $0001;
  dde_FBusy                     = $0002;
  dde_FNoData                   = $0004;
  dde_FackReq                   = $0008;
  dde_FResponse                 = $0010;
  dde_NotProcessed              = $0020;
  dde_FReserved                 = $00C0;
  dde_FAppStatus                = $FF00;

{ old DDE public formats - new ones are cf_ constants }
  ddefmt_Text                   = $0001;

{ Dynamic Data Exchange (DDE) Routines }

function WinDdeInitiate conv arg_os2 (Client: HWnd; AppName,TopicName: PChar;
  var Context: ConvContext): Bool; external 'PMWIN' index ord_Win32DDEInitiate;
function WinDdeRespond conv arg_os2 (Client,Server: HWnd; AppName,TopicName: PChar;
  var Context: ConvContext): MResult; external 'PMWIN' index ord_Win32DDERespond;
function WinDdePostMsg conv arg_os2 (ToWnd,FromWnd: HWnd;Wm: ULong; Dest: PDdeStruct;
  Options: ULong): Bool; external 'PMWIN' index ord_Win32DDEPostMsg;

const
  ddepm_RETRY                   = $00000001;
  ddepm_NOFREE                  = $00000002;
{ Dynamic Data Exchange (DDE) Messages }
  wm_Dde_First                  = $00A0;
  wm_Dde_Initiate               = $00A0;
  wm_Dde_Request                = $00A1;
  wm_Dde_Ack                    = $00A2;
  wm_Dde_Data                   = $00A3;
  wm_Dde_Advise                 = $00A4;
  wm_Dde_Unadvise               = $00A5;
  wm_Dde_Poke                   = $00A6;
  wm_Dde_Execute                = $00A7;
  wm_Dde_Terminate              = $00A8;
  wm_Dde_InitiateAck            = $00A9;
  wm_Dde_Last                   = $00AF;

{ wm_DbcsFirst }
  wm_QueryConvertPos            = $00B0;

{ Return values for wm_QueryConvertPos }
  qcp_Convert                   = $0001;
  qcp_NoConvert                 = $0000;

{ Load/Delete Library/Procedure }

type
  PHLib = ^HLib;
  HLib = HModule;

function WinDeleteProcedure conv arg_os2 (AB: Hab; WndProc: FnWp): Bool; external 'PMWIN' index ord_Win32DeleteProcedure;
function WinDeleteLibrary conv arg_os2 (AB: Hab; LibHandle: HLib): Bool; external 'PMWIN' index ord_Win32DeleteLibrary;
function WinLoadProcedure conv arg_os2 (AB: Hab; LibHandle: HLib; ProcName: PChar): Pointer; external 'PMWIN' index ord_Win32LoadProcedure;
function WinLoadLibrary conv arg_os2 (AB: Hab; LibName: PChar): HLib; external 'PMWIN' index ord_Win32LoadLibrary;

{ Desktop API definitions }
type
  PDesktop = ^Desktop;
  Desktop = record
    cbSize:       ULong;
    hbm:          HBitMap;
    x:            Long;
    y:            Long;
    fl:           ULong;
    lTileCount:   Long;
    szFile: array [0..259] of Char;
  end;

function WinSetDesktopBkgnd conv arg_os2 (Desktop: HWnd; var DskNew: Desktop): HBitMap; external 'PMWIN' index ord_Win32SetDesktopBkgnd;
function WinQueryDesktopBkgnd conv arg_os2 (Desktop: HWnd; var Dsk: Desktop): Bool; external 'PMWIN' index ord_Win32QueryDesktopBkgnd;

const
  sdt_Destroy                   = $0001;
  sdt_NoBkgnd                   = $0002;
  sdt_Tile                      = $0004;
  sdt_Scale                     = $0008;
  sdt_Pattern                   = $0010;
  sdt_Center                    = $0020;
  sdt_Retain                    = $0040;
  sdt_LoadFile                  = $0080;

{ Palette Manager API definitions }

function WinRealizePalette conv arg_os2 (Wnd: HWnd; PS: Hps; var CClr: ULong): Long; external 'PMWIN' index ord_Win32RealizePalette;

const
  str_DllName                   = 'keyremap';
  wm_DbcsFirst                  = $00B0;
  wm_DbcsLast                   = $00CF;

{----[ PMMLE ]----}

const
{ MLE Window styles ( in addition to ws_* ) }
  mls_WordWrap                  = $00000001;
  mls_Border                    = $00000002;
  mls_VScroll                   = $00000004;
  mls_HScroll                   = $00000008;
  mls_ReadOnly                  = $00000010;
  mls_IgnoreTab                 = $00000020;
  mls_DisableUndo               = $00000040;

{ MLE External Data Types }
type
  IPt = Long;                   { insertion point }
  PIpt = ^Ipt;
  Pix  = Long;                  { pixel           }
  Line =  ULong;                { Line number     }

  PMleFormatRect = ^MleFormatRect;
  MleFormatRect = record
     cxFormat: Long;            { format rectangle width  }
     cyFormat: Long;            { format rectangle height }
  end;

  PMleCtlData = ^MleCtlData;
  MleCtlData = record
    cbCtlData:     Word;        { Length of the MLECTLDATA structure  }
    afIEFormat:    Word;        { import/export format                }
    cchText:       ULong;       { text limit                          }
    iptAnchor:     IPt;         { beginning of selection              }
    iptCursor:     IPt;         { ending of selection                 }
    cxFormat:      Long;        { format rectangle width              }
    cyFormat:      Long;        { format rectangle height             }
    afFormatFlags: ULong;       { formatting rectangle flags          }
  end;

{ afFormatFlags mask }
const
  mlffmtrect_LimitHorz          = $00000001;
  mlffmtrect_LimitVert          = $00000002;
  mlffmtrect_MatchWindow        = $00000004;
  mlffmtrect_FormatRect         = $00000007;
{ afIEFormat - Import/Export Format flags }
  mlfie_CfText                  = 0;
  mlfie_NoTrans                 = 1;
  mlfie_WinFmt                  = 2;
  mlfie_Rtf                     = 3;

type
  POverflow = ^MleOverflow;
  MleOverflow = record
    afErrInd:    ULong;         { see mask below                         }
    nBytesOver:  Long;          { number of bytes overflowed             }
    pixHorzOver: Long;          { number of pixels horizontally overflow }
    pixVertOver: Long;          { number of pixels vertically overflowed }
  end;

{ afErrInd - error format rectangle flags }
const
  mlfefr_Resize                 = $00000001;
  mlfefr_TabStop                = $00000002;
  mlfefr_Font                   = $00000004;
  mlfefr_Text                   = $00000008;
  mlfefr_WordWrap               = $00000010;
  mlfetl_TextBytes              = $00000020;

type
  PMargStruct = ^MleMargStruct;
  MleMargStruct = record
    afMargins:   Word;          { margin indicator }
    usMouMsg:    Word;          { mouse message    }
    iptNear:     IPt;           { the geometrically nearest insertion point }
  end;

{ afFlags - margin notification indicators }
const
  mlfmargin_Left                = $0001;
  mlfmargin_Bottom              = $0002;
  mlfmargin_Right               = $0003;
  mlfmargin_Top                 = $0004;

{ mlm_QuerySelection flags }
  mlfqs_MinMaxSel               = 0;
  mlfqs_MinSel                  = 1;
  mlfqs_MaxSel                  = 2;
  mlfqs_AnchorSel               = 3;
  mlfqs_CursorSel               = 4;

{ mln_ClpbdFail flags }
  mlfclpbd_TooMuchText          = $00000001;
  mlfclpbd_Error                = $00000002;

type
  PMle_SearchData = ^Mle_SearchData;
  Mle_SearchData = record
    cb:           Word;     { size of search spec structure       }
    pchFind:      PChar;    { string to search for                }
    pchReplace:   PChar;    { string to replace with              }
    cchFind:      Word;     { length of pchFindString             }
    cchReplace:   Word;     { length of replace string            }
    iptStart:     IPt;      { point at which to start search      }
                            { (negative indicates cursor pt)      }
                            { becomes pt where string found       }
    iptStop:      IPt;      { point at which to stop search       }
                            { (negative indicates EOT)            }
    cchFound:     Word;     { Length of found string at iptStart  }
  end;

{ mlm_Search style flags }
const
  mlfsearch_CaseSensitive       = $00000001;
  mlfsearch_SelectMatch         = $00000002;
  mlfsearch_ChangeAll           = $00000004;

{ MLE messages - MLM from $01B0 to $01DE; MLN from $0001 to $000F }
{ formatting messages }
  mlm_SetTextLimit              = $01B0;
  mlm_QueryTextLimit            = $01B1;
  mlm_SetFormatRect             = $01B2;
  mlm_QueryFormatRect           = $01B3;
  mlm_SetWrap                   = $01B4;
  mlm_QueryWrap                 = $01B5;
  mlm_SetTabStop                = $01B6;
  mlm_QueryTabStop              = $01B7;
  mlm_SetReadOnly               = $01B8;
  mlm_QueryReadOnly             = $01B9;

{ text content manipulation and queries Messages }
  mlm_QueryChanged              = $01BA;
  mlm_SetChanged                = $01BB;
  mlm_QueryLineCount            = $01BC;
  mlm_CharFromLine              = $01BD;
  mlm_LineFromChar              = $01BE;
  mlm_QueryLineLength           = $01BF;
  mlm_QueryTextLength           = $01C0;

{ text import and export messages }
  mlm_Format                    = $01C1;
  mlm_SetImportExport           = $01C2;
  mlm_Import                    = $01C3;
  mlm_Export                    = $01C4;
  mlm_Delete                    = $01C6;
  mlm_QueryFormatLineLength     = $01C7;
  mlm_QueryFormatTextLength     = $01C8;
  mlm_Insert                    = $01C9;

{ selection messages }
  mlm_SetSel                    = $01CA;
  mlm_QuerySel                  = $01CB;
  mlm_QuerySelText              = $01CC;

{ undo and redo messages }
  mlm_QueryUndo                 = $01CD;
  mlm_Undo                      = $01CE;
  mlm_ResetUndo                 = $01CF;

{ text attributes messages }
  mlm_QueryFont                 = $01D0;
  mlm_SetFont                   = $01D1;
  mlm_SetTextColor              = $01D2;
  mlm_QueryTextColor            = $01D3;
  mlm_SetBackColor              = $01D4;
  mlm_QueryBackColor            = $01D5;

{ scrolling messages }
  mlm_QueryFirstChar            = $01D6;
  mlm_SetFirstChar              = $01D7;

{ clipboard messages }
  mlm_Cut                       = $01D8;
  mlm_Copy                      = $01D9;
  mlm_Paste                     = $01DA;
  mlm_Clear                     = $01DB;

{ display manipulation messages }
  mlm_EnableRefresh             = $01DC;
  mlm_DisableRefresh            = $01DD;

{ search message }
  mlm_Search                    = $01DE;
  mlm_QueryImportExport         = $01DF;

{ notification messages }
  mln_Overflow                  = $0001;
  mln_PixHorzOverflow           = $0002;
  mln_PixVertOverflow           = $0003;
  mln_TextOverflow              = $0004;
  mln_VScroll                   = $0005;
  mln_HScroll                   = $0006;
  mln_Change                    = $0007;
  mln_SetFocus                  = $0008;
  mln_KillFocus                 = $0009;
  mln_Margin                    = $000A;
  mln_SearchPause               = $000B;
  mln_MemError                  = $000C;
  mln_UndoOverflow              = $000D;
  mln_ClpbdFail                 = $000F;

{----[ PMGPI ]----}

{ General GPI return values }
const
  gpi_Error                     = Bool(0);
  gpi_Ok                        = Bool(1);
  gpi_AltError                  = Bool(-1);

{ fixed point number - implicit binary point between 2 and 3 hex digits }
type
  PFixed = ^Fixed;
  Fixed  = Long;
{ fixed point number - implicit binary point between 1st and 2nd hex digits }
  Fixed88 = Word;
{ fixed point signed number - implicit binary point between bits 14 and 13. }
{                             Bit 15 is the sign bit.                       }
{                             Thus 1.0 is represented by 16384 (0x4000)     }
{                             and -1.0 is represented by -16384 (0xc000)    }
  Fixed114 = Word;
{ structure for size parameters e.g. for GpiCreatePS }
  PSizeL = ^SizeL;
  SizeL = record
    cx: Long;
    cy: Long;
  end;

{ return code on GpiQueryLogColorTable,GpiQueryRealColors and GpiQueryPel }
const
  clr_NoIndex                   = -254;
  { units for GpiCreatePS and others }
  pu_Arbitrary                  = $0004;
  pu_Pels                       = $0008;
  pu_Lometric                   = $000C;
  pu_Himetric                   = $0010;
  pu_Loenglish                  = $0014;
  pu_Hienglish                  = $0018;
  pu_Twips                      = $001C;
  { format for GpiCreatePS }
  gpif_Default                  = 0;
  gpif_Short                    = $0100;
  gpif_Long                     = $0200;
  { PS type for GpiCreatePS }
  gpit_Normal                   = 0;
  gpit_Micro                    = $1000;
  { implicit associate flag for GpiCreatePS }
  gpia_NoAssoc                  = 0;
  gpia_Assoc                    = $4000;
  { return error for GpiQueryDevice }
  hdc_Error                     = Hdc(-1);

  { common GPICONTROL functions }

function GpiCreatePS conv arg_os2 (Ab: Hab; DC: Hdc; var sizlSize: SizeL; Options: ULong): Hps; external 'PMGPI' index ord_Gpi32CreatePS;
function GpiDestroyPS conv arg_os2 (PS: Hps): Bool;              external 'PMGPI' index ord_Gpi32DestroyPS;
function GpiAssociate conv arg_os2 (PS: Hps; DC: Hdc): Bool;     external 'PMGPI' index ord_Gpi32Associate;
function GpiRestorePS conv arg_os2 (PS: Hps; lPSid: Long): Bool; external 'PMGPI' index ord_Gpi32RestorePS;
function GpiSavePS conv arg_os2 (PS: Hps): Long;                 external 'PMGPI' index ord_Gpi32SavePS;
function GpiErase conv arg_os2 (PS: Hps): Bool;                  external 'PMGPI' index ord_Gpi32Erase;
function GpiQueryDevice conv arg_os2 (PS: Hps): Hdc;             external 'PMGPI' index ord_Gpi32QueryDevice;

{ options for GpiResetPS }
const
  gres_Attrs                    = $0001;
  gres_Segments                 = $0002;
  gres_All                      = $0004;

  { option masks for PS options used by GpiQueryPs }
  ps_Units                      = $00FC;
  ps_Format                     = $0F00;
  ps_Type                       = $1000;
  ps_Mode                       = $2000;
  ps_Associate                  = $4000;
  ps_NoReset                    = $8000;

  { error context returned by GpiErrorSegmentData }
  gpie_Segment                  = 0;
  gpie_Element                  = 1;
  gpie_Data                     = 2;

  { control parameter for GpiSetDrawControl }
  dctl_Erase                    = 1;
  dctl_Display                  = 2;
  dctl_Boundary                 = 3;
  dctl_Dynamic                  = 4;
  dctl_Correlate                = 5;

  { constants for GpiSet/QueryDrawControl }
  dctl_Error                    = -1;
  dctl_Off                      = 0;
  dctl_On                       = 1;

  { constants for GpiSet/QueryStopDraw }
  sdw_Error                     = -1;
  sdw_Off                       = 0;
  sdw_On                        = 1;

  { drawing for GpiSet/QueryDrawingMode }
  dm_Error                      = 0;
  dm_Draw                       = 1;
  dm_Retain                     = 2;
  dm_DrawAndRetain              = 3;

{ other GPICONTROL functions }

function GpiResetPS conv arg_os2 (PS: Hps; Options: ULong): Bool;                     external 'PMGPI' index ord_Gpi32ResetPS;
function GpiSetPS conv arg_os2 (PS: Hps; var sizlsize: SizeL; Options: ULong): Bool;  external 'PMGPI' index ord_Gpi32SetPS;
function GpiQueryPS conv arg_os2 (PS: Hps; var sizlsize: SizeL): ULong;               external 'PMGPI' index ord_Gpi32QueryPS;
function GpiErrorSegmentData conv arg_os2 (PS: Hps; var Segment,Context: Long): Long; external 'PMGPI' index ord_Gpi32ErrorSegmentData;
function GpiQueryDrawControl conv arg_os2 (PS: Hps; Control: Long): Long;             external 'PMGPI' index ord_Gpi32QueryDrawControl;
function GpiSetDrawControl conv arg_os2 (PS: Hps; Control,Value: Long): Bool;         external 'PMGPI' index ord_Gpi32SetDrawControl;
function GpiQueryDrawingMode conv arg_os2 (PS: Hps): Long;                            external 'PMGPI' index ord_Gpi32QueryDrawingMode;
function GpiSetDrawingMode conv arg_os2 (PS: Hps; Mode: Long): Bool;                  external 'PMGPI' index ord_Gpi32SetDrawingMode;
function GpiQueryStopDraw conv arg_os2 (PS: Hps): Long;                               external 'PMGPI' index ord_Gpi32QueryStopDraw;
function GpiSetStopDraw conv arg_os2 (PS: Hps; Value: Long): Bool;                    external 'PMGPI' index ord_Gpi32SetStopDraw;

{ options for GpiSetPickApertureSize }
const
  pickap_Default                = 0;
  pickap_Rec                    = 2;

  { type of correlation for GpiCorrelateChain }
  picksel_Visible               = 0;
  picksel_All                   = 1;

  { return code to indicate correlate hit(s) }
  gpi_Hits                      = 2;

{ picking, correlation and boundary functions }

function GpiCorrelateChain conv arg_os2 (PS: Hps; lType: Long; var ptlPick: PointL;
  MaxHits,MaxDepth: Long; var l2: Long): Long; external 'PMGPI' index ord_Gpi32CorrelateChain;
function GpiQueryTag conv arg_os2 (PS: Hps; var Tag: Long): Bool; external 'PMGPI' index ord_Gpi32QueryTag;
function GpiSetTag conv arg_os2 (PS: Hps; Tag: Long): Bool; external 'PMGPI' index ord_Gpi32SetTag;
function GpiQueryPickApertureSize conv arg_os2 (PS: Hps; var sizlsize: SizeL): Bool; external 'PMGPI' index ord_Gpi32QueryPickApertureSize;
function GpiSetPickApertureSize conv arg_os2 (PS: Hps; Options: Long; var sizlsize: SizeL): Bool; external 'PMGPI' index ord_Gpi32SetPickApertureSize;
function GpiQueryPickAperturePosition conv arg_os2 (PS: Hps; var ptlPoint: PointL): Bool; external 'PMGPI' index ord_Gpi32QueryPickAperturePosition;
function GpiSetPickAperturePosition conv arg_os2 (PS: Hps; ptlPick: PointL): Bool; external 'PMGPI' index ord_Gpi32SetPickAperturePosition;
function GpiQueryBoundaryData conv arg_os2 (PS: Hps; var rclBoundary: RectL): Bool; external 'PMGPI' index ord_Gpi32QueryBoundaryData;
function GpiResetBoundaryData conv arg_os2 (PS: Hps): Bool; external 'PMGPI' index ord_Gpi32ResetBoundaryData;
function GpiCorrelateFrom conv arg_os2 (PS: Hps; FirstSegment,LastSegment,lType: Long;
  var ptlPick: PointL; MaxHits,MaxDepth: Long; var SegTag: Long): Long; external 'PMGPI' index ord_Gpi32CorrelateFrom;
function GpiCorrelateSegment conv arg_os2 (PS: Hps; Segment,lType: Long; var ptlPick: PointL;
  MaxHits,MaxDepth: Long; var SegTag: Long): Long; external 'PMGPI' index ord_Gpi32CorrelateSegment;

{ data formats for GpiPutData and GpiGetData }
const
  dform_NoConv                  = 0;
  dform_S370Short               = 1;
  dform_PCShort                 = 2;
  dform_PCLong                  = 4;

  { segment attributes used by GpiSet/QuerySegmentAttrs and others }
  attr_Error                    = -1;
  attr_Detectable               = 1;
  attr_Visible                  = 2;
  attr_Chained                  = 6;
  attr_Dynamic                  = 8;
  attr_FastChain                = 9;
  attr_Prop_Detectable          = 10;
  attr_Prop_Visible             = 11;
  { attribute on/off values }
  attr_Off                      = 0;
  attr_On                       = 1;

  { segment priority used by GpiSetSegmentPriority and others }
  lower_Pri                     = -1;
  higher_Pri                    = 1;

  { segment control functions }

function GpiOpenSegment conv arg_os2 (PS: Hps; Segment: Long): Bool;                    external 'PMGPI' index ord_Gpi32OpenSegment;
function GpiCloseSegment conv arg_os2 (PS: Hps): Bool;                                  external 'PMGPI' index ord_Gpi32CloseSegment;
function GpiDeleteSegment conv arg_os2 (PS: Hps; Segid: Long): Bool;                    external 'PMGPI' index ord_Gpi32DeleteSegment;
function GpiQueryInitialSegmentAttrs conv arg_os2 (PS: Hps; Attribute: Long): Long;     external 'PMGPI' index ord_Gpi32QueryInitialSegmentAttrs;
function GpiSetInitialSegmentAttrs conv arg_os2 (PS: Hps; Attribute,Value: Long): Bool; external 'PMGPI' index ord_Gpi32SetInitialSegmentAttrs;
function GpiQuerySegmentAttrs conv arg_os2 (PS: Hps; Segid,Attribute: Long): Long;      external 'PMGPI' index ord_Gpi32QuerySegmentAttrs;
function GpiSetSegmentAttrs conv arg_os2 (PS: Hps; Segid,Attribute,Value: Long): Bool;  external 'PMGPI' index ord_Gpi32SetSegmentAttrs;
function GpiQuerySegmentPriority conv arg_os2 (PS: Hps; RefSegid,Order: Long): Long;    external 'PMGPI' index ord_Gpi32QuerySegmentPriority;
function GpiSetSegmentPriority conv arg_os2 (PS: Hps; Segid,RefSegid,Order: Long): Bool;external 'PMGPI' index ord_Gpi32SetSegmentPriority;
function GpiDeleteSegments conv arg_os2 (PS: Hps; FirstSegment,LastSegment: Long): Bool;external 'PMGPI' index ord_Gpi32DeleteSegments;
function GpiQuerySegmentNames conv arg_os2 (PS: Hps; FirstSegid,LastSegid,Max: Long;
  var Segids: Long): Long;                                                external 'PMGPI' index ord_Gpi32QuerySegmentNames;

{ draw functions for segments }
function GpiGetData conv arg_os2 (PS: Hps; Segid: Long; var Offset: Long; Format,Length: Long;
  var Data): Long; external 'PMGPI' index ord_Gpi32GetData;
function GpiPutData conv arg_os2 (PS: Hps; Format: Long; var Count: Long; var Data): Long; external 'PMGPI' index ord_Gpi32PutData;
function GpiDrawChain conv arg_os2 (PS: Hps): Bool;                                        external 'PMGPI' index ord_Gpi32DrawChain;
function GpiDrawFrom conv arg_os2 (PS: Hps; FirstSegment,LastSegment: Long): Bool;         external 'PMGPI' index ord_Gpi32DrawFrom;
function GpiDrawSegment conv arg_os2 (PS: Hps; Segment: Long): Bool;                       external 'PMGPI' index ord_Gpi32DrawSegment;
function GpiDrawDynamics conv arg_os2 (PS: Hps): Bool;                                     external 'PMGPI' index ord_Gpi32DrawDynamics;
function GpiRemoveDynamics conv arg_os2 (PS: Hps; FirstSegid,LastSegid: Long): Bool;       external 'PMGPI' index ord_Gpi32RemoveDynamics;

{ edit modes used by GpiSet/QueryEditMode }
const
  segem_Error                   = 0;
  segem_Insert                  = 1;
  segem_Replace                 = 2;

  { segment editing by element functions }

function GpiBeginElement conv arg_os2 (PS: Hps; lType: Long; Desc: PChar): Bool;      external 'PMGPI' index ord_Gpi32BeginElement;
function GpiEndElement conv arg_os2 (PS: Hps): Bool;                                  external 'PMGPI' index ord_Gpi32EndElement;
function GpiLabel conv arg_os2 (PS: Hps; lLabel: Long): Bool;                         external 'PMGPI' index ord_Gpi32Label;
function GpiElement conv arg_os2 (PS: Hps; lType: Long; Desc: PChar; Length: Long;
  var Data): Long;                                                      external 'PMGPI' index ord_Gpi32Element;
function GpiQueryElement conv arg_os2 (PS: Hps; Off,MaxLength: Long; var Data): Long; external 'PMGPI' index ord_Gpi32QueryElement;
function GpiDeleteElement conv arg_os2 (PS: Hps): Bool;                               external 'PMGPI' index ord_Gpi32DeleteElement;
function GpiDeleteElementRange conv arg_os2 (PS: Hps; FirstElement,LastElement: Long): Bool; external 'PMGPI' index ord_Gpi32DeleteElementRange;
function GpiDeleteElementsBetweenLabels conv arg_os2 (PS: Hps; FirstLabel,LastLabel: Long): Bool; external 'PMGPI' index ord_Gpi32DeleteElementsBetweenLabe;
function GpiQueryEditMode conv arg_os2 (PS: Hps): Long;                               external 'PMGPI' index ord_Gpi32QueryEditMode;
function GpiSetEditMode conv arg_os2 (PS: Hps; Mode: Long): Bool;                     external 'PMGPI' index ord_Gpi32SetEditMode;
function GpiQueryElementPointer conv arg_os2 (PS: Hps): Long;                         external 'PMGPI' index ord_Gpi32QueryElementPointer;
function GpiSetElementPointer conv arg_os2 (PS: Hps; Element: Long): Bool;            external 'PMGPI' index ord_Gpi32SetElementPointer;
function GpiOffsetElementPointer conv arg_os2 (PS: Hps; offset: Long): Bool;          external 'PMGPI' index ord_Gpi32OffsetElementPointer;
function GpiQueryElementType conv arg_os2 (PS: Hps; var lType: Long; Length: Long;
  Data: PChar): Long;                                                   external 'PMGPI' index ord_Gpi32QueryElementType;
function GpiSetElementPointerAtLabel conv arg_os2 (PS: Hps; lLabel: Long): Bool;      external 'PMGPI' index ord_Gpi32SetElementPointerAtLabel;

{ co-ordinates space for GpiConvert }
const
  cvtc_World                    = 1;
  cvtc_Model                    = 2;
  cvtc_DefaultPage              = 3;
  cvtc_Page                     = 4;
  cvtc_Device                   = 5;

  { type of transformation for GpiSetSegmentTransformMatrix }
  transform_Replace             = 0;
  transform_Add                 = 1;
  transform_Preempt             = 2;

  { transform matrix }
type
  PMatrixLf = ^MatrixLf;
  MatrixLf = record
    fxM11: Fixed;
    fxM12: Fixed;
    lM13:  Long;
    fxM21: Fixed;
    fxM22: Fixed;
    lM23:  Long;
    lM31:  Long;
    lM32:  Long;
    lM33:  Long;
  end;

  { transform and transform conversion functions }
function GpiQuerySegmentTransformMatrix conv arg_os2 (PS: Hps; Segid,Count: Long;
  var matlfArray: MatrixLf): Bool; external 'PMGPI' index ord_Gpi32QuerySegmentTransformMatr;
function GpiSetSegmentTransformMatrix conv arg_os2 (PS: Hps; Segid,Count: Long;
  var matlfarray: MatrixLf; Options: Long): Bool; external 'PMGPI' index ord_Gpi32SetSegmentTransformMatrix;
function GpiConvert conv arg_os2 (PS: Hps; Src,Targ,Count: Long; var aptlPoints: PointL): Bool; external 'PMGPI' index ord_Gpi32Convert;
function GpiConvertWithMatrix conv arg_os2 (PS: Hps; Countp: Long; var aptlPoints: PointL;
  Count: Long; var matlfArray: MatrixLf): Bool; external 'PMGPI' index ord_Gpi32ConvertWithMatrix;
function GpiQueryModelTransformMatrix conv arg_os2 (PS: Hps; Count: Long; pmatlfArray: MatrixLf): Bool; external 'PMGPI' index ord_Gpi32QueryModelTransformMatrix;
function GpiSetModelTransformMatrix conv arg_os2 (PS: Hps; Count: Long; matlfArray: MatrixLf;
  Options: Long): Bool; external 'PMGPI' index ord_Gpi32SetModelTransformMatrix;
function GpiCallSegmentMatrix conv arg_os2 (PS: Hps; Segment,Count: Long; matlfArray: MatrixLf;
  Options: Long): Long; external 'PMGPI' index ord_Gpi32CallSegmentMatrix;
function GpiQueryDefaultViewMatrix conv arg_os2 (PS: Hps; Count: Long; var matlfArray: MatrixLf): Bool; external 'PMGPI' index ord_Gpi32QueryDefaultViewMatrix;
function GpiSetDefaultViewMatrix conv arg_os2 (PS: Hps; Count: Long; var matlfarray: MatrixLf;
  Options: Long): Bool; external 'PMGPI' index ord_Gpi32SetDefaultViewMatrix;
function GpiQueryPageViewport conv arg_os2 (PS: Hps; var rclViewport: RectL): Bool; external 'PMGPI' index ord_Gpi32QueryPageViewPort;
function GpiSetPageViewport conv arg_os2 (PS: Hps; var rclViewport: RectL): Bool;   external 'PMGPI' index ord_Gpi32SetPageViewPort;
function GpiQueryViewingTransformMatrix conv arg_os2 (PS: Hps; Count: Long; matlfArray: MatrixLf): Bool; external 'PMGPI' index ord_Gpi32QueryViewingTransformMatr;
function GpiSetViewingTransformMatrix conv arg_os2 (PS: Hps; Count: Long; matlfArray: MatrixLf;
  Options: Long): Bool; external 'PMGPI' index ord_Gpi32SetViewingTransformMatrix;
{ transform helper routines }
function GpiTranslate conv arg_os2 (PS: Hps; var matlfArray: MatrixLf; Options: Long;
  var ptlTranslation: PointL): Bool; external 'PMGPI' index ord_Gpi32Translate;
function GpiScale conv arg_os2 (PS: Hps; var matlfArray: MatrixLf; Options: Long;
  var afxScale: Fixed; var ptlCenter: PointL): Bool; external 'PMGPI' index ord_Gpi32Scale;
function GpiRotate conv arg_os2 (PS: Hps; var matlfArray: MatrixLf; Options: Long;
  fxAngle: Fixed; ptlCenter: PPointL): Bool; external 'PMGPI' index ord_Gpi32Rotate;
{ general clipping functions }
function GpiSetGraphicsField conv arg_os2 (PS: Hps; var rclField: RectL): Bool;    external 'PMGPI' index ord_Gpi32SetGraphicsField;
function GpiQueryGraphicsField conv arg_os2 (PS: Hps; var rclField: RectL): Bool;  external 'PMGPI' index ord_Gpi32QueryGraphicsField;
function GpiSetViewingLimits conv arg_os2 (PS: Hps; var rclLimits: RectL): Bool;   external 'PMGPI' index ord_Gpi32SetViewingLimits;
function GpiQueryViewingLimits conv arg_os2 (PS: Hps; var rclLimits: RectL): Bool; external 'PMGPI' index ord_Gpi32QueryViewingLimits;

{ modes for GpiModifyPath }
const
  mpath_Stroke                  = 6;

  { modes for GpiFillPath }
  fpath_Alternate               = 0;
  fpath_Winding                 = 2;
  fpath_Excl                    = 0;
  fpath_Incl                    = 8;

   { modes for GpiSetClipPath }
  scp_Alternate                 = 0;
  scp_Winding                   = 2;
  scp_And                       = 4;
  scp_Reset                     = 0;
  scp_Excl                      = 0;
  scp_Incl                      = 8;

{ Path and Clip Path functions }

function GpiBeginPath conv arg_os2 (PS: Hps; Path: Long): Bool;                  external 'PMGPI' index ord_Gpi32BeginPath;
function GpiEndPath conv arg_os2 (PS: Hps): Bool;                                external 'PMGPI' index ord_Gpi32EndPath;
function GpiCloseFigure conv arg_os2 (PS: Hps): Bool;                            external 'PMGPI' index ord_Gpi32CloseFigure;
function GpiModifyPath conv arg_os2 (PS: Hps; Path,Mode: Long): Bool;            external 'PMGPI' index ord_Gpi32ModifyPath;
function GpiFillPath conv arg_os2 (PS: Hps; Path,Options: Long): Long;           external 'PMGPI' index ord_Gpi32FillPath;
function GpiSetClipPath conv arg_os2 (PS: Hps; Path,Options: Long): Bool;        external 'PMGPI' index ord_Gpi32SetClipPath;
function GpiOutlinePath conv arg_os2 (PS: Hps; Path,Options: Long): Long;        external 'PMGPI' index ord_Gpi32OutlinePath;
function GpiPathToRegion conv arg_os2 (PS: Hps; Path,Options: Long): HRgn;       external 'PMGPI' index ord_Gpi32PathToRegion;
function GpiStrokePath conv arg_os2 (PS: Hps; Path: Long; Options: ULong): Long; external 'PMGPI' index ord_Gpi32StrokePath;

{ options for GpiCreateLogColorTable and others }
const
  lcol_Reset                    = $0001;
  lcol_Realizable               = $0002;
  lcol_PureColor                = $0004;
  lcol_Override_Default_Colors  = $0008;
  lcol_Realized                 = $0010;

  { format of logical lColor table for GpiCreateLogColorTable and others }
  lcolf_Default                 = 0;
  lcolf_IndRgb                  = 1;
  lcolf_ConsecRgb               = 2;
  lcolf_Rgb                     = 3;
  lcolf_Palette                 = 4;

  { options for GpiQueryRealColors and others }
  lcolopt_Realized              = $0001;
  lcolopt_Index                 = $0002;

  { return codes from GpiQueryLogColorTable to indicate it is in RGB mode }
  qlct_Error                    = -1;
  qlct_Rgb                      = -2;

  { GpiQueryLogColorTable index returned for colors not explicitly loaded }
  qlct_NotLoaded                = -1;
  { return codes for GpiQueryColorData }
  qcd_lct_Format                = 0;
  qcd_lct_LoIndex               = 1;
  qcd_lct_HiIndex               = 2;
  qcd_lct_Options               = 3;

  { Palette manager return values }
  pal_Error                     = -1;

  { color flags for GpiCreatePalette and others }
  pc_Reserved                   = $01;
  pc_Explicit                   = $02;
  pc_NoCollapse                 = $04;

{ logical lColor table functions }

function GpiCreateLogColorTable conv arg_os2 (PS: Hps; Options: ULong; Format,Start,Count: Long;
  var alTable: ULong): Bool; external 'PMGPI' index ord_Gpi32CreateLogColorTable;
function GpiQueryColorData conv arg_os2 (PS: Hps; Count: Long; var alArray: Long): Bool; external 'PMGPI' index ord_Gpi32QueryColorData;
function GpiQueryLogColorTable conv arg_os2 (PS: Hps; Options: ULong; Start,Count: Long;
  var alArray: Long): Long; external 'PMGPI' index ord_Gpi32QueryLogColorTable;
function GpiQueryRealColors conv arg_os2 (PS: Hps; Options: ULong; Start,Count: Long;
  var alColors: Long): Long; external 'PMGPI' index ord_Gpi32QueryRealColors;
function GpiQueryNearestColor conv arg_os2 (PS: Hps; Options: ULong; RgbIn: Long): Long;  external 'PMGPI' index ord_Gpi32QueryNearestColor;
function GpiQueryColorIndex conv arg_os2 (PS: Hps; Options: ULong; RgbColor: Long): Long; external 'PMGPI' index ord_Gpi32QueryColorIndex;
function GpiQueryRGBColor conv arg_os2 (PS: Hps; Options: ULong; ColorIndex: Long): Long; external 'PMGPI' index ord_Gpi32QueryRGBColor;

{ Palette manager functions }
function GpiCreatePalette conv arg_os2 (Ab: Hab; Options: ULong; Format,Count: ULong;
  var aulTable: ULong): HPal; external 'PMGPI' index ord_Gpi32CreatePalette;
function GpiDeletePalette conv arg_os2 (Pal: HPal): Bool; external 'PMGPI' index ord_Gpi32DeletePalette;
function GpiSelectPalette conv arg_os2 (PS: Hps; Pal: HPal): HPal; external 'PMGPI' index ord_Gpi32SelectPalette;
function GpiAnimatePalette conv arg_os2 (Pal: HPal; Format,Start,Count: ULong;
  var aulTable: ULong): Long; external 'PMGPI' index ord_Gpi32AnimatePalette;
function GpiSetPaletteEntries conv arg_os2 (Pal: HPal; Format,Start,Count: ULong;
  var aulTable: ULong): Bool; external 'PMGPI' index ord_Gpi32SetPaletteEntries;
function GpiQueryPalette conv arg_os2 (PS: Hps): HPal; external 'PMGPI' index ord_Gpi32QueryPalette;
function GpiQueryPaletteInfo conv arg_os2 (Pal: HPal; PS: Hps; Options,Start,Count: ULong;
  var aulArray: ULong): Long; external 'PMGPI' index ord_Gpi32QueryPaletteInfo;

{ default color table indices }
const
  clr_False                     = -5;
  clr_True                      = -4;

  clr_Error                     = -255;
  clr_Default                   = -3;
  clr_White                     = -2;
  clr_Black                     = -1;
  clr_Background                = 0;
  clr_Blue                      = 1;
  clr_Red                       = 2;
  clr_Pink                      = 3;
  clr_Green                     = 4;
  clr_Cyan                      = 5;
  clr_Yellow                    = 6;
  clr_Neutral                   = 7;

  clr_Darkgray                  = 8;
  clr_Darkblue                  = 9;
  clr_Darkred                   = 10;
  clr_Darkpink                  = 11;
  clr_Darkgreen                 = 12;
  clr_Darkcyan                  = 13;
  clr_Brown                     = 14;
  clr_Palegray                  = 15;

  { RGB colors }
  rgb_Error                     = -255;
  rgb_Black                     = $00000000;
  rgb_Blue                      = $000000FF;
  rgb_Green                     = $0000FF00;
  rgb_Cyan                      = $0000FFFF;
  rgb_Red                       = $00FF0000;
  rgb_Pink                      = $00FF00FF;
  rgb_Yellow                    = $00FFFF00;
  rgb_White                     = $00FFFFFF;

  { control flags used by GpiBeginArea }
  ba_NoBoundary                 = 0;
  ba_Boundary                   = $0001;
  ba_Alternate                  = 0;
  ba_Winding                    = $0002;
  ba_Excl                       = 0;
  ba_Incl                       = $0008;

  { fill options for GpiBox/GpiFullArc }
  dro_Fill                      = 1;
  dro_Outline                   = 2;
  dro_OutlineFill               = 3;

  { basic pattern symbols }
  patsym_Error                  = -1;
  patsym_Default                = 0;
  patsym_Dense1                 = 1;
  patsym_Dense2                 = 2;
  patsym_Dense3                 = 3;
  patsym_Dense4                 = 4;
  patsym_Dense5                 = 5;
  patsym_Dense6                 = 6;
  patsym_Dense7                 = 7;
  patsym_Dense8                 = 8;
  patsym_Vert                   = 9;
  patsym_Horiz                  = 10;
  patsym_Diag1                  = 11;
  patsym_Diag2                  = 12;
  patsym_Diag3                  = 13;
  patsym_Diag4                  = 14;
  patsym_NoShade                = 15;
  patsym_Solid                  = 16;
  patsym_Halftone               = 17;
  patsym_Hatch                  = 18;
  patsym_DiagHatch              = 19;
  patsym_Blank                  = 64;

  { lcid values for GpiSet/QueryPattern and others }
  lcid_Error                    = -1;
  lcid_Default                  = 0;

{ global primitive functions }

function GpiSetColor conv arg_os2 (PS: Hps; Color: Long): Bool; external 'PMGPI' index ord_Gpi32SetColor;
function GpiQueryColor conv arg_os2 (PS: Hps): Long;            external 'PMGPI' index ord_Gpi32QueryColor;

{ line primitive functions }

function GpiBox conv arg_os2 (PS: Hps; Control: Long; var ptlPoint: PointL;
  HRound,VRound: Long): Long; external 'PMGPI' index ord_Gpi32Box;

function GpiMove conv arg_os2 (PS: Hps; var ptlPoint: PointL): Bool; external 'PMGPI' index ord_Gpi32Move;
function GpiLine conv arg_os2 (PS: Hps; var ptlEndPoint: PointL): Long; external 'PMGPI' index ord_Gpi32Line;
function GpiPolyLine conv arg_os2 (PS: Hps; Count: Long; var aptlPoints: PointL): Long; external 'PMGPI' index ord_Gpi32PolyLine;
function GpiPolyLineDisjoint conv arg_os2 (PS: Hps; Count: Long; var aptlPoints: PointL): Long; external 'PMGPI' index ord_Gpi32PolyLineDisjoint;

{ area primitive functions }

function GpiSetPattern conv arg_os2 (PS: Hps; PatternSymbol: Long): Bool; external 'PMGPI' index ord_Gpi32SetPattern;
function GpiQueryPattern conv arg_os2 (PS: Hps): Long;                    external 'PMGPI' index ord_Gpi32QueryPattern;
function GpiBeginArea conv arg_os2 (PS: Hps; Options: ULong): Bool;       external 'PMGPI' index ord_Gpi32BeginArea;
function GpiEndArea conv arg_os2 (PS: Hps): Long;                         external 'PMGPI' index ord_Gpi32EndArea;

{ character primitive functions }

function GpiCharString conv arg_os2 (PS: Hps; Count: Long; chString: PChar): Long; external 'PMGPI' index ord_Gpi32CharString;
function GpiCharStringAt conv arg_os2 (PS: Hps; var ptlPoint: PointL; Count: Long;
  chString: PChar): Long; external 'PMGPI' index ord_Gpi32CharStringAt;

{ mode for GpiSetAttrMode }
const
  am_Error                      = -1;
  am_Preserve                   = 0;
  am_NoPreserve                 = 1;

  { foreground mixes }
  fm_Error                      = -1;
  fm_Default                    = 0;
  fm_Or                         = 1;
  fm_OverPaint                  = 2;
  fm_LeaveAlone                 = 5;

  fm_Xor                        = 4;
  fm_And                        = 6;
  fm_Subtract                   = 7;
  fm_MaskSrcNot                 = 8;
  fm_Zero                       = 9;
  fm_NotMergeSrc                = 10;
  fm_NotXorSrc                  = 11;
  fm_Invert                     = 12;
  fm_MergeSrcNot                = 13;
  fm_NotCopySrc                 = 14;
  fm_MergeNotSrc                = 15;
  fm_NotMaskSrc                 = 16;
  fm_One                        = 17;

  { background mixes }
  bm_Error                      = -1;
  bm_Default                    = 0;
  bm_Or                         = 1;
  bm_OverPaint                  = 2;
  bm_LeaveAlone                 = 5;

  bm_Xor                        = 4;
  bm_And                        = 6;
  bm_Subtract                   = 7;
  bm_MaskSrcNot                 = 8;
  bm_Zero                       = 9;
  bm_NotMergeSrc                = 10;
  bm_NotXorSrc                  = 11;
  bm_Invert                     = 12;
  bm_MergeSrcNot                = 13;
  bm_NotCopySrc                 = 14;
  bm_MergeNotSrc                = 15;
  bm_NotMaskSrc                 = 16;
  bm_One                        = 17;
  bm_SrcTransparent             = 18;
  bm_DestTransparent            = 19;

  { basic line type styles }
  linetype_Error                = -1;
  linetype_Default              = 0;
  linetype_Dot                  = 1;
  linetype_ShortDash            = 2;
  linetype_DashDot              = 3;
  linetype_DoubleDot            = 4;
  linetype_LongDash             = 5;
  linetype_DashDoubleDot        = 6;
  linetype_Solid                = 7;
  linetype_Invisible            = 8;
  linetype_Alternate            = 9;

  { cosmetic line widths }
  linewidth_Error               = -1;
  linewidth_Default             = 0;
  linewidth_Normal              = $00010000;   { 1.0 }
  linewidth_Thick               = $00020000;   { 2.0 }

  { actual line widths }
  lineWidthGeom_Error           = -1;

  { line end styles }
  lineend_Error                 = -1;
  lineend_Default               = 0;
  lineend_Flat                  = 1;
  lineend_Square                = 2;
  lineend_Round                 = 3;

  { line join styles }
  linejoin_Error                = -1;
  linejoin_Default              = 0;
  linejoin_Bevel                = 1;
  linejoin_Round                = 2;
  linejoin_Mitre                = 3;

  { character directions }
  chdirn_Error                  = -1;
  chdirn_Default                = 0;
  chdirn_LeftRight              = 1;
  chdirn_TopBottom              = 2;
  chdirn_RightLeft              = 3;
  chdirn_BottomTop              = 4;

  { character text alignments }
  ta_Normal_Horiz               = $0001;
  ta_Left                       = $0002;
  ta_Center                     = $0003;
  ta_Right                      = $0004;
  ta_Standard_Horiz             = $0005;
  ta_Normal_Vert                = $0100;
  ta_Top                        = $0200;
  ta_Half                       = $0300;
  ta_Base                       = $0400;
  ta_Bottom                     = $0500;
  ta_Standard_Vert              = $0600;

  { character modes }
  cm_Error                      = -1;
  cm_Default                    = 0;
  cm_Mode1                      = 1;
  cm_Mode2                      = 2;
  cm_Mode3                      = 3;

  { basic marker symbols }
  marksym_Error                 = -1;
  marksym_Default               = 0;
  marksym_Cross                 = 1;
  marksym_Plus                  = 2;
  marksym_Diamond               = 3;
  marksym_Square                = 4;
  marksym_SixPointStar          = 5;
  marksym_EightPointStar        = 6;
  marksym_SolidDiamond          = 7;
  marksym_SolidSquare           = 8;
  marksym_Dot                   = 9;
  marksym_SmallCircle           = 10;
  marksym_Blank                 = 64;

  { formatting options for GpiCharStringPosAt }
  chs_Opaque                    = $0001;
  chs_Vector                    = $0002;
  chs_LeavePos                  = $0008;
  chs_Clip                      = $0010;
  chs_Underscore                = $0200;
  chs_StrikeOut                 = $0400;

  { bundle codes for GpiSetAttributes and GpiQueryAttributes }
  prim_Line                     = 1;
  prim_Char                     = 2;
  prim_Marker                   = 3;
  prim_Area                     = 4;
  prim_Image                    = 5;

  { line bundle mask bits }
  lbb_Color                     = $0001;
  lbb_Back_Color                = $0002;
  lbb_Mix_Mode                  = $0004;
  lbb_Back_Mix_Mode             = $0008;
  lbb_Width                     = $0010;
  lbb_Geom_Width                = $0020;
  lbb_Type                      = $0040;
  lbb_End                       = $0080;
  lbb_Join                      = $0100;

  { character bundle mask bits }
  cbb_Color                     = $0001;
  cbb_Back_Color                = $0002;
  cbb_Mix_Mode                  = $0004;
  cbb_Back_Mix_Mode             = $0008;
  cbb_Set                       = $0010;
  cbb_Mode                      = $0020;
  cbb_Box                       = $0040;
  cbb_Angle                     = $0080;
  cbb_Shear                     = $0100;
  cbb_Direction                 = $0200;
  cbb_Text_Align                = $0400;
  cbb_Extra                     = $0800;
  cbb_Break_Extra               = $1000;

  { marker bundle mask bits }
  mbb_Color                     = $0001;
  mbb_Back_Color                = $0002;
  mbb_Mix_Mode                  = $0004;
  mbb_Back_Mix_Mode             = $0008;
  mbb_Set                       = $0010;
  mbb_Symbol                    = $0020;
  mbb_Box                       = $0040;

  { pattern bundle mask bits }
  abb_Color                     = $0001;
  abb_Back_Color                = $0002;
  abb_Mix_Mode                  = $0004;
  abb_Back_Mix_Mode             = $0008;
  abb_Set                       = $0010;
  abb_Symbol                    = $0020;
  abb_Ref_Point                 = $0040;

  { image bundle mask bits }
  ibb_Color                     = $0001;
  ibb_Back_Color                = $0002;
  ibb_Mix_Mode                  = $0004;
  ibb_Back_Mix_Mode             = $0008;

{ structure for GpiSetArcParams and GpiQueryArcParams }
type
  PArcParams = ^ArcParams;
  ArcParams = record
    lP: Long;
    lQ: Long;
    lR: Long;
    lS: Long;
  end;

{ variation of SIZE used for FIXEDs }
  PSizeF = ^SizeF;
  SizeF = record
    cx: Fixed;
    cy: Fixed;
  end;

{ structure for gradient parameters e.g. for GpiSetCharAngle }
  PGradientL = ^GradientL;
  GradientL = record
    x: Long;
    y: Long;
  end;

{ line bundle for GpiSetAttributes and GpiQueryAttributes }
  PLineBundle = ^LineBundle;
  LineBundle = record
    lColor:        Long;
    lBackColor:    Long;
    usMixMode:     Word;
    usBackMixMode: Word;
    fxWidth:       Fixed;
    lGeomWidth:    Long;
    usType:        Word;
    usEnd:         Word;
    usJoin:        Word;
    usReserved:    Word;
  end;

{ character bundle for GpiSetAttributes and GpiQueryAttributes }
  PCharBundle = ^CharBundle;
  CharBundle = record
    lColor:        Long;
    lBackColor:    Long;
    usMixMode:     Word;
    usBackMixMode: Word;
    usSet:         Word;
    usPrecision:   Word;
    sizfxCell:     SizeF;
    ptlAngle:      PointL;
    ptlShear:      PointL;
    usDirection:   Word;
    usTextAlign:   Word;
    fxExtra:       Fixed;
    fxBreakExtra:  Fixed;
  end;

{ marker bundle for GpiSetAttributes and GpiQueryAttributes }
  PMarkerBundle = ^MarkerBundle;
  MarkerBundle = record
    lColor:        Long;
    lBackColor:    Long;
    usMixMode:     Word;
    usBackMixMode: Word;
    usSet:         Word;
    usSymbol:      Word;
    sizfxCell:     SizeF;
  end;

{ pattern bundle for GpiSetAttributes and GpiQueryAttributes }
  PAreaBundle = ^AreaBundle;
  AreaBundle = record
    lColor:        Long;
    lBackColor:    Long;
    usMixMode:     Word;
    usBackMixMode: Word;
    usSet:         Word;
    usSymbol:      Word;
    ptlRefPoint:   PointL;
  end;

{ image bundle for GpiSetAttributes and GpiQueryAttributes }
  PImageBundle = ^ImageBundle;
  ImageBundle = record
    lColor:        Long;
    lBackColor:    Long;
    usMixMode:     Word;
    usBackMixMode: Word;
  end;

{ pointer to any bundle used by GpiSet/QueryAttrs }
  PBundle = Pointer;

{ array indices for GpiQueryTextBox }
const
  txtbox_TopLeft                = 0;
  txtbox_BottomLeft             = 1;
  txtbox_TopRight               = 2;
  txtbox_BottomRight            = 3;
  txtbox_Concat                 = 4;
  { array count for GpiQueryTextBox }
  txtbox_Count                  = 5;

  { return codes for GpiPtVisible }
  pvis_Error                    = 0;
  pvis_Invisible                = 1;
  pvis_Visible                  = 2;

  { return codes for GpiRectVisible }
  rvis_Error                    = 0;
  rvis_Invisible                = 1;
  rvis_Partial                  = 2;
  rvis_Visible                  = 3;

{ attribute mode functions }

function GpiSetAttrMode conv arg_os2 (PS: Hps; Mode: Long): Bool; external 'PMGPI' index ord_Gpi32SetAttrMode;
function GpiQueryAttrMode conv arg_os2 (PS: Hps): Long; external 'PMGPI' index ord_Gpi32QueryAttrMode;

{ bundle primitive functions }

function GpiSetAttrs conv arg_os2 (PS: Hps; PrimType: Long; AttrMask,DefMask: ULong; bunAttrs: PBundle): Bool; external 'PMGPI' index ord_Gpi32SetAttrs;
function GpiQueryAttrs conv arg_os2 (PS: Hps; PrimType: Long; AttrMask: ULong; bunAttrs: PBundle): Long; external 'PMGPI' index ord_Gpi32QueryAttrs;

{ global primitive functions }

function GpiSetBackColor conv arg_os2 (PS: Hps; Color: Long): Bool; external 'PMGPI' index ord_Gpi32SetBackColor;
function GpiQueryBackColor conv arg_os2 (PS: Hps): Long;            external 'PMGPI' index ord_Gpi32QueryBackColor;
function GpiSetMix conv arg_os2 (PS: Hps; MixMode: Long): Bool;     external 'PMGPI' index ord_Gpi32SetMix;
function GpiQueryMix conv arg_os2 (PS: Hps): Long;                  external 'PMGPI' index ord_Gpi32QueryMix;
function GpiSetBackMix conv arg_os2 (PS: Hps; MixMode: Long): Bool; external 'PMGPI' index ord_Gpi32SetBackMix;
function GpiQueryBackMix conv arg_os2 (PS: Hps): Long;              external 'PMGPI' index ord_Gpi32QueryBackMix;

{ line primitive functions }

function GpiSetLineType conv arg_os2 (PS: Hps; LineType: Long): Bool;                external 'PMGPI' index ord_Gpi32SetLineType;
function GpiQueryLineType conv arg_os2 (PS: Hps): Long;                              external 'PMGPI' index ord_Gpi32QueryLineType;
function GpiSetLineWidth conv arg_os2 (PS: Hps; LineWidth: Fixed): Bool;             external 'PMGPI' index ord_Gpi32SetLineWidth;
function GpiQueryLineWidth conv arg_os2 (PS: Hps): Fixed;                            external 'PMGPI' index ord_Gpi32QueryLineWidth;
function GpiSetLineWidthGeom conv arg_os2 (PS: Hps; LineWidth: Long): Bool;          external 'PMGPI' index ord_Gpi32SetLineWidthGeom;
function GpiQueryLineWidthGeom conv arg_os2 (PS: Hps): Long;                         external 'PMGPI' index ord_Gpi32QueryLineWidthGeom;
function GpiSetLineEnd conv arg_os2 (PS: Hps; LineEnd: Long): Bool;                  external 'PMGPI' index ord_Gpi32SetLineEnd;
function GpiQueryLineEnd conv arg_os2 (PS: Hps): Long;                               external 'PMGPI' index ord_Gpi32QueryLineEnd;
function GpiSetLineJoin conv arg_os2 (PS: Hps; LineJoin: Long): Bool;                external 'PMGPI' index ord_Gpi32SetLineJoin;
function GpiQueryLineJoin conv arg_os2 (PS: Hps): Long;                              external 'PMGPI' index ord_Gpi32QueryLineJoin;
function GpiSetCurrentPosition conv arg_os2 (PS: Hps; var ptlPoint: PointL): Bool;   external 'PMGPI' index ord_Gpi32SetCurrentPosition;
function GpiQueryCurrentPosition conv arg_os2 (PS: Hps; var ptlPoint: PointL): Bool; external 'PMGPI' index ord_Gpi32QueryCurrentPosition;

{ arc primitive functions }

function GpiSetArcParams conv arg_os2 (PS: Hps; var Params: ArcParams): Bool;             external 'PMGPI' index ord_Gpi32SetArcParams;
function GpiQueryArcParams conv arg_os2 (PS: Hps; Params: ArcParams): Bool;               external 'PMGPI' index ord_Gpi32QueryArcParams;
function GpiPointArc conv arg_os2 (PS: Hps; var ptl2: PointL): Long;                      external 'PMGPI' index ord_Gpi32PointArc;
function GpiFullArc conv arg_os2 (PS: Hps; Control: Long; Multiplier: Fixed): Long;       external 'PMGPI' index ord_Gpi32FullArc;
function GpiPartialArc conv arg_os2 (PS: Hps; var ptlCenter: PointL;
  Multiplier,StartAngle,SweepAngle: Fixed): Long;                                         external 'PMGPI' index ord_Gpi32PartialArc;
function GpiPolyFillet conv arg_os2 (PS: Hps; Count: Long; var aptlPoints: PointL): Long; external 'PMGPI' index ord_Gpi32PolyFillet;
function GpiPolySpline conv arg_os2 (PS: Hps; Count: Long; var aptlPoints: PointL): Long; external 'PMGPI' index ord_Gpi32PolySpline;
function GpiPolyFilletSharp conv arg_os2 (PS: Hps; Count: Long; var aptlPoints: PointL;
  var afxPoints: Fixed): Long;                                                            external 'PMGPI' index ord_Gpi32PolyFilletSharp;

{ area primitive functions }

function GpiSetPatternSet conv arg_os2 (PS: Hps; lSet: Long): Bool;                     external 'PMGPI' index ord_Gpi32SetPatternSet;
function GpiQueryPatternSet conv arg_os2 (PS: Hps): Long;                               external 'PMGPI' index ord_Gpi32QueryPatternSet;
function GpiSetPatternRefPoint conv arg_os2 (PS: Hps; var ptlRefPoint: PointL): Bool;   external 'PMGPI' index ord_Gpi32SetPatternRefPoint;
function GpiQueryPatternRefPoint conv arg_os2 (PS: Hps; var ptlRefPoint: PointL): Bool; external 'PMGPI' index ord_Gpi32QueryPatternRefPoint;

{ character primitive functions }

function GpiQueryCharStringPos conv arg_os2 (PS: Hps; Options: ULong; lCount: Long;
  chString: PChar; var alXincrements: Long; var aptlPositions: PointL): Bool;                  external 'PMGPI' index ord_Gpi32QueryCharStringPos;
function GpiQueryCharStringPosAt conv arg_os2 (PS: Hps; var ptlStartL: PointL; Options: ULong;
  Count: Long; chString: PChar; var alXincrements: Long; var aptlPositions: PointL): Bool;     external 'PMGPI' index ord_Gpi32QueryCharStringPosAt;
function GpiQueryTextBox conv arg_os2 (PS: Hps; Count1:Long; chString: PChar; Count2: Long;
  var aptlPoints: PointL): Bool;                                               external 'PMGPI' index ord_Gpi32QueryTextBox;
function GpiQueryDefCharBox conv arg_os2 (PS: Hps; var sizlsize: SizeL): Bool; external 'PMGPI' index ord_Gpi32QueryDefCharBox;
function GpiSetCharSet conv arg_os2 (PS: Hps; lcid: Long): Bool; external 'PMGPI' index ord_Gpi32SetCharSet;
function GpiQueryCharSet conv arg_os2 (PS: Hps): Long;  external 'PMGPI' index ord_Gpi32QueryCharSet;
function GpiSetCharBox conv arg_os2 (PS: Hps; sizfxBox: SizeF): Bool; external 'PMGPI' index ord_Gpi32SetCharBox;
function GpiQueryCharBox conv arg_os2 (PS: Hps; var sizfxSize: SizeF): Bool;       external 'PMGPI' index ord_Gpi32QueryCharBox;
function GpiSetCharAngle conv arg_os2 (PS: Hps; var gradlAngle: GradientL): Bool;  external 'PMGPI' index ord_Gpi32SetCharAngle;
function GpiQueryCharAngle conv arg_os2 (PS: Hps; var gradlAngle: GradientL): Bool;external 'PMGPI' index ord_Gpi32QueryCharAngle;
function GpiSetCharShear conv arg_os2 (PS: Hps; var ptlAngle: PointL): Bool;       external 'PMGPI' index ord_Gpi32SetCharShear;
function GpiQueryCharShear conv arg_os2 (PS: Hps; ptlShear: PointL): Bool;         external 'PMGPI' index ord_Gpi32QueryCharShear;
function GpiSetCharDirection conv arg_os2 (PS: Hps; Direction: Long): Bool;        external 'PMGPI' index ord_Gpi32SetCharDirection;
function GpiQueryCharDirection conv arg_os2 (PS: Hps): Long;                       external 'PMGPI' index ord_Gpi32QueryCharDirection;
function GpiSetCharMode conv arg_os2 (PS: Hps; Mode: Long): Bool;                  external 'PMGPI' index ord_Gpi32SetCharMode;
function GpiQueryCharMode conv arg_os2 (PS: Hps): Long;                            external 'PMGPI' index ord_Gpi32QueryCharMode;
function GpiSetTextAlignment conv arg_os2 (PS: Hps; Horiz,Vert: Long): Bool;       external 'PMGPI' index ord_Gpi32SetTextAlignment;
function GpiQueryTextAlignment conv arg_os2 (PS: Hps; var Horiz,Vert: Long): Bool; external 'PMGPI' index ord_Gpi32QueryTextAlignment;
function GpiCharStringPos conv arg_os2 (PS: Hps; var rclRect: RectL; Options: ULong;
  Count: Long; chString: PChar; var alAdx: Long): Long;                            external 'PMGPI' index ord_Gpi32CharStringPos;
function GpiCharStringPosAt conv arg_os2 (PS: Hps; var ptlStart: PointL; var rclRect: RectL;
  Options: ULong; Count: Long; chString: PChar; var alAdx: Long): Long;            external 'PMGPI' index ord_Gpi32CharStringPosAt;
function GpiSetCharExtra conv arg_os2 (PS: Hps; Extra: Fixed): Bool;               external 'PMGPI' index ord_Gpi32SetCharExtra;
function GpiSetCharBreakExtra conv arg_os2 (PS: Hps; BreakExtra: Fixed): Bool;     external 'PMGPI' index ord_Gpi32SetCharBreakExtra;
function GpiQueryCharExtra conv arg_os2 (PS: Hps; var Extra: Fixed): Bool;         external 'PMGPI' index ord_Gpi32QueryCharExtra;
function GpiQueryCharBreakExtra conv arg_os2 (PS: Hps; var BreakExtra: Fixed): Bool; external 'PMGPI' index ord_Gpi32QueryCharBreakExtra;

{ marker primitive functions  }

function GpiMarker conv arg_os2 (PS: Hps; var ptlPoint: PointL): Long;                    external 'PMGPI' index ord_Gpi32Marker;
function GpiPolyMarker conv arg_os2 (PS: Hps; Count: Long; var aptlPoints: PointL): Long; external 'PMGPI' index ord_Gpi32PolyMarker;
function GpiSetMarker conv arg_os2 (PS: Hps; Symbol: Long): Bool;                         external 'PMGPI' index ord_Gpi32SetMarker;
function GpiSetMarkerBox conv arg_os2 (PS: Hps; var sizfxSize: SizeF): Bool;              external 'PMGPI' index ord_Gpi32SetMarkerBox;
function GpiSetMarkerSet conv arg_os2 (PS: Hps; lSet: Long): Bool;                        external 'PMGPI' index ord_Gpi32SetMarkerSet;
function GpiQueryMarker conv arg_os2 (PS: Hps): Long;                                     external 'PMGPI' index ord_Gpi32QueryMarker;
function GpiQueryMarkerBox conv arg_os2 (PS: Hps; var sizfxSize: SizeF): Bool;            external 'PMGPI' index ord_Gpi32QueryMarkerBox;
function GpiQueryMarkerSet conv arg_os2 (PS: Hps): Long;                                  external 'PMGPI' index ord_Gpi32QueryMarkerSet;

{ image primitive functions }

function GpiImage conv arg_os2 (PS: Hps; Format: Long; var sizlImageSize: SizeL;
  Length: Long; var Data): Long; external 'PMGPI' index ord_Gpi32Image;

{ miscellaneous primitive functions }

function GpiPop conv arg_os2 (PS: Hps; Count: Long): Bool;                     external 'PMGPI' index ord_Gpi32Pop;
function GpiPtVisible conv arg_os2 (PS: Hps; var ptlPoint: PointL): Long;      external 'PMGPI' index ord_Gpi32PtVisible;
function GpiRectVisible conv arg_os2 (PS: Hps; var rclRectangle: RectL): Long; external 'PMGPI' index ord_Gpi32RectVisible;
function GpiComment conv arg_os2 (PS: Hps; Length: Long; var Data): Bool;      external 'PMGPI' index ord_Gpi32Comment;

{ return codes from GpiCreateLogFont }
const
  font_Default                  = 1;
  font_Match                    = 2;

  { lcid type for GpiQuerySetIds }
  lcidt_Font                    = 6;
  lcidt_BitMap                  = 7;

  { constant used to delete all lcids by GpiDeleteSetId }
  lcid_All                      = -1;

type
  { kerning data returned by GpiQueryKerningPairs }
  PKerningPairs = ^KerningPairs;
  KerningPairs = record
    sFirstChar:     Word;
    sSecondChar:    Word;
    lKerningAmount: Long;
  end;

  { data required by GpiQueryFaceString }
  PFaceNameDesc = ^FaceNameDesc;
  FaceNameDesc = record
    usSize:        Word;
    usWeightClass: Word;
    usWidthClass:  Word;
    usReserved:    Word;
    flOptions:     ULong;
  end;

  { FACENAMEDESC 'WeightClass' options for GpiQueryFaceString }
  const
  fweight_Dont_Care             = 0;
  fweight_Ultra_Light           = 1;
  fweight_Extra_Light           = 2;
  fweight_Light                 = 3;
  fweight_Semi_Light            = 4;
  fweight_Normal                = 5;
  fweight_Semi_Bold             = 6;
  fweight_Bold                  = 7;
  fweight_Extra_Bold            = 8;
  fweight_Ultra_Bold            = 9;

  { faceNAMEDESC 'WidthClass' options for GpiQueryFaceString }
  fwidth_Dont_Care              = 0;
  fwidth_Ultra_Condensed        = 1;
  fwidth_Extra_Condensed        = 2;
  fwidth_Condensed              = 3;
  fwidth_Semi_Condensed         = 4;
  fwidth_Normal                 = 5;
  fwidth_Semi_Expanded          = 6;
  fwidth_Expanded               = 7;
  fwidth_Extra_Expanded         = 8;
  fwidth_Ultra_Expanded         = 9;

  { FACENAMEDESC 'options' for GpiQueryFaceString }
  ftype_Italic                  = $0001;
  ftype_Italic_Dont_Care        = $0002;
  ftype_Oblique                 = $0004;
  ftype_Oblique_Dont_Care       = $0008;
  ftype_Rounded                 = $0010;
  ftype_Rounded_Dont_Care       = $0020;

  { actions for GpiQueryFontAction }
  qfa_Public                    = 1;
  qfa_Private                   = 2;
  qfa_Error                     = GPI_ALTERROR;

  { options for GpiQueryFonts }
  qf_Public                     = $0001;
  qf_Private                    = $0002;
  qf_No_Generic                 = $0004;
  qf_No_Device                  = $0008;

{ font file descriptions for GpiQueryFontFileDescriptions }
type
  PFfDescs  = ^FfDescS;
  FfDescs   = array [0..1,0..FaceSize-1] of Char;
  PFfDescs2 = ^FfDescs2;
  FfDescs2  = record
    cbLength:         ULong;
    cbFacenameOffset: ULong;
    abFamilyName: array[0..0] of Byte;
  end;

{ physical and logical font functions }

function GpiCreateLogFont conv arg_os2 (PS: Hps; Name: PStr8; Lcid: Long; var fatAttrs: FAttrs): Long; external 'PMGPI' index ord_Gpi32CreateLogFont;
function GpiDeleteSetId conv arg_os2 (PS: Hps; Lcid: Long): Bool;                                      external 'PMGPI' index ord_Gpi32DeleteSetId;
function GpiLoadFonts conv arg_os2 (Ab: Hab; Filename: PChar): Bool;                                   external 'PMGPI' index ord_Gpi32LoadFonts;
function GpiUnloadFonts conv arg_os2 (Ab: Hab; Filename: PChar): Bool;                                 external 'PMGPI' index ord_Gpi32UnloadFonts;
function GpiQueryFonts conv arg_os2 (PS: Hps; Options: ULong; Facename: PChar; var ReqFonts: Long;
  MetricsLength: Long; var afmMetrics: FontMetrics): Long; external 'PMGPI' index ord_Gpi32QueryFonts;
function GpiQueryFontMetrics conv arg_os2 (PS: Hps; MetricsLength: Long; var fmMetrics: FontMetrics): Bool; external 'PMGPI' index ord_Gpi32QueryFontMetrics;
function GpiQueryKerningPairs conv arg_os2 (PS: Hps; Count: Long; var akrnprData: KerningPairs): Long; external 'PMGPI' index ord_Gpi32QueryKerningPairs;
function GpiQueryWidthTable conv arg_os2 (PS: Hps; FirstChar,Count: Long; var alData: Long): Bool;     external 'PMGPI' index ord_Gpi32QueryWidthTable;
function GpiQueryNumberSetIds conv arg_os2 (PS: Hps): Long;                  external 'PMGPI' index ord_Gpi32QuerySetIds;
function GpiQuerySetIds conv arg_os2 (PS: Hps; Count: Long; var alTypes: Long; var aNames: Str8;
  var allcids: Long): Bool;                                                  external 'PMGPI' index ord_Gpi32QuerySetIds;
function GpiQueryFaceString conv arg_os2 (PS: Hps; FamilyName: PChar; var attrs: FaceNameDesc;
  length: Long; CompoundFaceName: PChar): ULong;                             external 'PMGPI' index ord_Gpi32QueryFaceString;
function GpiQueryLogicalFont conv arg_os2 (PS: Hps; cid: Long; var Name: Str8; var attrs: FAttrs;
  Length: Long): Bool;                                                       external 'PMGPI' index ord_Gpi32QueryLogicalFont;
function GpiQueryFontAction conv arg_os2 (AB: Hab; Options: ULong): ULong;   external 'PMGPI' index ord_Gpi32QueryFontAction;
function GpiLoadPublicFonts conv arg_os2 (AB: Hab; Filename: PChar): Bool;   external 'PMGPI' index ord_Gpi32LoadPublicFonts;
function GpiUnloadPublicFonts conv arg_os2 (AB: Hab; Filename: PChar): Bool; external 'PMGPI' index ord_Gpi32UnloadPublicFonts;
function GpiSetCp conv arg_os2 (PS: Hps; CodePage: ULong): Bool; external 'PMGPI' index ord_Gpi32SetCp;
function GpiQueryCp conv arg_os2 (PS: Hps): ULong;               external 'PMGPI' index ord_Gpi32QueryCp;
function GpiQueryFontFileDescriptions conv arg_os2 (Ab: Hab; Filename: PChar;
  var Count: Long; var affdescsNames: FfDescs): Long;           external 'PMGPI' index ord_Gpi32QueryFontFileDescriptions;
function GpiQueryFullFontFileDescs conv arg_os2 (Ab: Hab; Filename: PChar;
  var Count: Long; var Names; var NamesBuffLength: Long): Long; external 'PMGPI' index ord_Gpi32QueryFullFontFileDescs;

{ raster operations defined for GpiBitBlt }
const
  rop_SrcCopy                   = $00CC;
  rop_SrcPaint                  = $00EE;
  rop_SrcAnd                    = $0088;
  rop_SrcInvert                 = $0066;
  rop_SrcErase                  = $0044;
  rop_NotSrcCopy                = $0033;
  rop_NotSrcErase               = $0011;
  rop_MergeCopy                 = $00C0;
  rop_MergePaint                = $00BB;
  rop_PatCopy                   = $00F0;
  rop_PatPaint                  = $00FB;
  rop_PatInvert                 = $005A;
  rop_DstInvert                 = $0055;
  rop_Zero                      = $0000;
  rop_One                       = $00FF;

  { Blt options for GpiBitBlt }
  bbo_Or                        = 0;
  bbo_And                       = 1;
  bbo_Ignore                    = 2;
  bbo_Pal_Colors                = 4;
  bbo_No_Color_Info             = 8;

  { Fill options for GpiFloodFill }
  ff_Boundary                   = 0;
  ff_Surface                    = 1;

  { error return for GpiSetBitmap }
  hbm_Error                     = HBitMap(-1);

{ bitmap and pel functions }

function GpiBitBlt conv arg_os2 (Target,Src: Hps; Count: Long; var aptlPoints: PointL;
  Rop: Long; Options: ULong): Long;                            external 'PMGPI' index ord_Gpi32BitBlt;
function GpiDeleteBitmap conv arg_os2 (BitMap: HBitMap): Bool; external 'PMGPI' index ord_Gpi32DeleteBitMap;
function GpiLoadBitmap conv arg_os2 (PS: Hps; Resource: HModule; idBitmap: ULong;
  Width,Height: Long): HBitMap;     external 'PMGPI' index ord_Gpi32LoadBitMap;
function GpiSetBitmap conv arg_os2 (PS: Hps; Bitmap: HBitMap): HBitMap; external 'PMGPI' index ord_Gpi32SetBitMap;
function GpiWCBitBlt conv arg_os2 (PS: Hps; Src: HBitMap; Count: Long; var aptlPoints: PointL;
  Rop: Long; Options: ULong): Long; external 'PMGPI' index ord_Gpi32WCBitBlt;

{ bitmap structures and file formats (from PMBITMAP.H) }

{ This is the file format structure for Bit Maps, Pointers and Icons    }
{ as stored in the resource file of a PM application.                   }
{                                                                       }
{ Notes on file format:                                                 }
{                                                                       }
{ Each BITMAPFILEHEADER entry is immediately followed by the color table}
{ for the bit map bits it references.                                   }
{ Icons and Pointers contain two BITMAPFILEHEADERs for each ARRAYHEADER }
{ item.  The first one is for the ANDXOR mask, the second is for the    }
{ COLOR mask.  All offsets are absolute based on the start of the FILE. }
{                                                                       }
{ For OS/2 Version 2.0 and later BITMAPFILEHEADER2 and the other '2'    }
{ versions of each structure are recommended. Use the non-2 versions    }
{ of each structure if compatibility with OS/2 Version 1.X is required. }

{ bitmap parameterization used by GpiCreateBitmap and others }
type
  PBitMapInfoHeader = ^BitMapInfoHeader;
  BitMapInfoHeader = record
    cbFix:     ULong;
    cx:        Word;
    cy:        Word;
    cPlanes:   Word;
    cBitCount: Word;
  end;

  { RGB data for _BITMAPINFO struct }
  RGB = record
    bBlue:  Byte;
    bGreen: Byte;
    bRed:   Byte;
  end;

  { bitmap data used by GpiSetBitmapBits and others }
  PBitMapInfo = ^BitMapInfo;
  BitMapInfo = record
    cbFix:        ULong;
    cx:           Word;
    cy:           Word;
    cPlanes:      Word;
    cBitCount:    Word;
    argbColor: array[0..0] of RGB;
  end;

{ Constants for compression/decompression command }
const
  cbd_Compression               = 1;
  cbd_DeCompression             = 2;
  cbd_Bits                      = 0;

  { Flags for compression/decompression option }

  cbd_Color_Conversion          = $00000001;

  { Compression scheme in the ulCompression field of the bitmapinfo structure }

  bca_Uncomp                    = 0;
  bca_Huffman1d                 = 3;
  bca_Rle4                      = 2;
  bca_Rle8                      = 1;
  bca_Rle24                     = 4;

  bru_Metric                    = 0;

  bra_BottomUp                  = 0;

  brh_NotHalfToned              = 0;
  brh_ErrorDiffusion            = 1;
  brh_Panda                     = 2;
  brh_SuperCircle               = 3;

  bce_Palette                   = -1;
  bce_Rgb                       = 0;

type
  PBitMapInfoHeader2 = ^BitMapInfoHeader2;
  BitMapInfoHeader2 = record
    cbFix:           ULong;     { Length of structure                    }
    cx:              ULong;     { Bit-map width in pels                  }
    cy:              ULong;     { Bit-map height in pels                 }
    cPlanes:         Word;      { Number of bit planes                   }
    cBitCount:       Word;      { Number of bits per pel within a plane  }
    ulCompression:   ULong;     { Compression scheme used to store the bitmap }
    cbImage:         ULong;     { Length of bit-map storage data in bytes}
    cxResolution:    ULong;     { x resolution of target device          }
    cyResolution:    ULong;     { y resolution of target device          }
    cclrUsed:        ULong;     { Number of color indices used           }
    cclrImportant:   ULong;     { Number of important color indices      }
    usUnits:         Word;      { Units of measure                       }
    usReserved:      Word;      { Reserved                               }
    usRecording:     Word;      { Recording algorithm                    }
    usRendering:     Word;      { Halftoning algorithm                   }
    cSize1:          ULong;     { Size value 1                           }
    cSize2:          ULong;     { Size value 2                           }
    ulColorEncoding: ULong;     { Color encoding                         }
    ulIdentifier:    ULong;     { Reserved for application use           }
  end;

  PRGB2 = ^RGB2;
  RGB2 = record
    bBlue:     Byte;            { Blue component of the color definition }
    bGreen:    Byte;            { Green component of the color definition}
    bRed:      Byte;            { Red component of the color definition  }
    fcOptions: Byte;            { Reserved, must be zero                 }
   end;

   PBitMapInfo2 = ^BitMapInfo2;
   BitMapInfo2 = record
     cbFix:           ULong;    { Length of fixed portion of structure   }
     cx:              ULong;    { Bit-map width in pels                  }
     cy:              ULong;    { Bit-map height in pels                 }
     cPlanes:         Word;     { Number of bit planes                   }
     cBitCount:       Word;     { Number of bits per pel within a plane  }
     ulCompression:   ULong;    { Compression scheme used to store the bitmap }
     cbImage:         ULong;    { Length of bit-map storage data in bytes}
     cxResolution:    ULong;    { x resolution of target device          }
     cyResolution:    ULong;    { y resolution of target device          }
     cclrUsed:        ULong;    { Number of color indices used           }
     cclrImportant:   ULong;    { Number of important color indices      }
     usUnits:         Word;     { Units of measure                       }
     usReserved:      Word;     { Reserved                               }
     usRecording:     Word;     { Recording algorithm                    }
     usRendering:     Word;     { Halftoning algorithm                   }
     cSize1:          ULong;    { Size value 1                           }
     cSize2:          ULong;    { Size value 2                           }
     ulColorEncoding: ULong;    { Color encoding                         }
     ulIdentifier:    ULong;    { Reserved for application use           }
     argbColor: array [0..0] of RGB2; { Color definition record          }
  end;

  PBitMapFileHeader = ^BitMapFileHeader;
  BitMapFileHeader = record
    usType:   Word;
    cbSize:   ULong;
    xHotspot: SmallInt;
    yHotspot: SmallInt;
    offBits:  ULong;
    bmp:      BitMapInfoHeader;
  end;

  PBitMapArrayFileHeader = ^BitMapArrayFileHeader;
  BitMapArrayFileHeader = record
    usType:    Word;
    cbSize:    ULong;
    offNext:   ULong;
    cxDisplay: Word;
    cyDisplay: Word;
    bfh:       BitMapFileHeader;
  end;

  PBitMapFileHeader2 = ^BitMapFileHeader2;
  BitMapFileHeader2 = record
    usType:   Word;
    cbSize:   ULong;
    xHotspot: SmallInt;
    yHotspot: SmallInt;
    offBits:  ULong;
    bmp2:     BitMapInfoHeader2;
  end;

  PBitMapArrayFileHeader2 = ^BitMapArrayFileHeader2;
  BitMapArrayFileHeader2 = record
    usType:    Word;
    cbSize:    ULong;
    offNext:   ULong;
    cxDisplay: Word;
    cyDisplay: Word;
    bfh2:      BitMapFileHeader2;
  end;

{ These are the identifying values that go in the usType field of the }
{ BitMapFileHeader(2) and BitMapArrayFileHeader(2).                   }
{ (bft_ => Bit map File Type                                          }
const
  bft_Icon                      = $4349;   { 'IC' }
  bft_BMap                      = $4D42;   { 'BM' }
  bft_Pointer                   = $5450;   { 'PT' }
  bft_ColorIcon                 = $4943;   { 'CI' }
  bft_ColorPointer              = $5043;   { 'CP' }
  bft_BitMapArray               = $4142;   { 'BA' }

  { usage flags for GpiCreateBitmap }
  cbm_Init                      = $0004;

  { error return code for GpiSet/QueryBitmapBits }
  bmb_Error                             = -1;

{ bitmap and pel functions }

function GpiCreateBitmap conv arg_os2 (PS: Hps; var bmpNew: BitMapInfoHeader2; Options: ULong;
  var InitData; var bmiInfoTable: BitMapInfo2): HBitMap; external 'PMGPI' index ord_Gpi32CreateBitMap;
function GpiSetBitmapBits conv arg_os2 (PS: Hps; ScanStart,Scans: Long; var Buffer;
  var bmiInfoTable: BitMapInfo2): Long;                  external 'PMGPI' index ord_Gpi32SetBitmapBits;
function GpiSetBitmapDimension conv arg_os2 (BitMap: HBitMap; var sizlBitmapDimension: SizeL): Bool; external 'PMGPI' index ord_Gpi32SetBitmapDimension;
function GpiSetBitmapId conv arg_os2 (PS: Hps; BitMap: HBitMap; Lcid: Long): Bool;                   external 'PMGPI' index ord_Gpi32SetBitmapId;
function GpiQueryBitmapBits conv arg_os2 (PS: Hps; ScanStart,Scans: Long; var Buffer;
  var bmiInfoTable: BitMapInfo2): Long;                                                              external 'PMGPI' index ord_Gpi32QueryBitmapBits;
function GpiQueryBitmapDimension conv arg_os2 (BitMap: HBitMap; var sizlBitmapDimension: SizeL): Bool; external 'PMGPI' index ord_Gpi32QueryBitmapDimension;
function GpiQueryBitmapHandle conv arg_os2 (PS: Hps; Lcid: Long): HBitMap;                             external 'PMGPI' index ord_Gpi32QueryBitmapHandle;
function GpiQueryBitmapParameters conv arg_os2 (BitMap: HBitMap; var bmpData: BitMapInfoHeader): Bool; external 'PMGPI' index ord_Gpi32QueryBitmapParameters;
function GpiQueryBitmapInfoHeader conv arg_os2 (BitMap: HBitMap; var bmpData: BitMapInfoHeader2): Bool;external 'PMGPI' index ord_Gpi32QueryBitmapInfoHeader;
function GpiQueryDeviceBitmapFormats conv arg_os2 (PS: Hps; Count: Long; var alArray: Long): Bool;     external 'PMGPI' index ord_Gpi32QueryDeviceBitmapFormats;
function GpiSetPel conv arg_os2 (PS: Hps; var ptlPoint: PointL): Long;                                 external 'PMGPI' index ord_Gpi32SetPel;
function GpiQueryPel conv arg_os2 (PS: Hps; var ptlPoint: PointL): Long;                               external 'PMGPI' index ord_Gpi32QueryPel;
function GpiFloodFill conv arg_os2 (PS: Hps; Options,Color: Long): Long;                               external 'PMGPI' index ord_Gpi32FloodFill;
function GpiDrawBits conv arg_os2 (PS: Hps; var Bits; bmiInfoTable: BitMapInfo2; Count: Long;
  var aptlPoints: PointL; Rop: Long; Options: ULong): Long; external 'PMGPI' index ord_Gpi32DrawBits;

{ options for GpiCombineRegion }
const
  crgn_Or                       = 1;
  crgn_Copy                     = 2;
  crgn_Xor                      = 4;
  crgn_And                      = 6;
  crgn_Diff                     = 7;

  { usDirection of returned region data for GpiQueryRegionRects }
  rectdir_LfRt_TopBot           = 1;
  rectdir_RtLf_TopBot           = 2;
  rectdir_LfRt_BotTop           = 3;
  rectdir_RtLf_BotTop           = 4;

{ control data for GpiQueryRegionRects }
type
  PRgnRect = ^RgnRect;
  RgnRect = record
    ircStart:    ULong;
    crc:         ULong;
    crcReturned: ULong;
    ulDirection: ULong;
  end;

{ return code to indicate type of region for GpiCombineRegion and others }
const
  rgn_Error                     = 0;
  rgn_Null                      = 1;
  rgn_Rect                      = 2;
  rgn_Complex                   = 3;

  { return codes for GpiPtInRegion }
  prgn_Error                    = 0;
  prgn_Outside                  = 1;
  prgn_Inside                   = 2;

  { return codes for GpiRectInRegion }
  rrgn_Error                    = 0;
  rrgn_Outside                  = 1;
  rrgn_Partial                  = 2;
  rrgn_Inside                   = 3;

  { return codes for GpiEqualRegion }
  eqrgn_Error                   = 0;
  eqrgn_NotEqual                = 1;
  eqrgn_Equal                   = 2;

  { error return code for GpiSetRegion }
  hrgn_Error                    = HRgn(-1);

  { main region functions }
function GpiCombineRegion conv arg_os2 (PS: Hps; Dest,Src1,Src2: HRgn; Mode: Long): Long;              external 'PMGPI' index ord_Gpi32CombineRegion;
function GpiCreateRegion conv arg_os2 (PS: Hps; Count: Long; var arclRectangles: RectL): HRgn;         external 'PMGPI' index ord_Gpi32CreateRegion;
function GpiDestroyRegion conv arg_os2 (PS: Hps; Rgn: HRgn): Bool;                                     external 'PMGPI' index ord_Gpi32DestroyRegion;
function GpiEqualRegion conv arg_os2 (PS: Hps; Src1,Src2: HRgn): Long;                                 external 'PMGPI' index ord_Gpi32EqualRegion;
function GpiOffsetRegion conv arg_os2 (PS: Hps; Rgn: HRgn; var ptlOffset: PointL): Bool;               external 'PMGPI' index ord_Gpi32OffsetRegion;
function GpiPaintRegion conv arg_os2 (PS: Hps; Rgn: HRgn): Long;                                       external 'PMGPI' index ord_Gpi32PaintRegion;
function GpiFrameRegion conv arg_os2 (PS: Hps; Rgn: HRgn; var thickness: SizeL): Long;                 external 'PMGPI' index ord_Gpi32FrameRegion;
function GpiPtInRegion conv arg_os2 (PS: Hps; Rgn: HRgn; var ptlPoint: PointL): Long;                  external 'PMGPI' index ord_Gpi32PtInRegion;
function GpiQueryRegionBox conv arg_os2 (PS: Hps; Rgn: HRgn; var rclBound: RectL): Long;               external 'PMGPI' index ord_Gpi32QueryRegionBox;
function GpiQueryRegionRects conv arg_os2 (PS: Hps; Rgn: HRgn; var rclBound: RectL;
  var rgnrcControl: RgnRect; var rclRect: RectL): Bool;                                                external 'PMGPI' index ord_Gpi32QueryRegionRects;
function GpiRectInRegion conv arg_os2 (PS: Hps; Rgn: HRgn; var rclRect: RectL): Long;                  external 'PMGPI' index ord_Gpi32RectInRegion;
function GpiSetRegion conv arg_os2 (PS: Hps; Rgn: HRgn; Count: Long; var arclRectangles: RectL): Bool; external 'PMGPI' index ord_Gpi32SetRegion;

{ clip region functions }

function GpiSetClipRegion conv arg_os2 (PS: Hps; Rgn: HRgn; var RgnOld: HRgn): Long;      external 'PMGPI' index ord_Gpi32SetClipRegion;
function GpiQueryClipRegion conv arg_os2 (PS: Hps): HRgn;                                 external 'PMGPI' index ord_Gpi32QueryClipRegion;
function GpiQueryClipBox conv arg_os2 (PS: Hps; var rclBound: RectL): Long;               external 'PMGPI' index ord_Gpi32QueryClipBox;
function GpiExcludeClipRectangle conv arg_os2 (PS: Hps; var rclRectangle: RectL): Long;   external 'PMGPI' index ord_Gpi32ExcludeClipRectangle;
function GpiIntersectClipRectangle conv arg_os2 (PS: Hps; var rclRectangle: RectL): Long; external 'PMGPI' index ord_Gpi32IntersectClipRectangle;
function GpiOffsetClipRegion conv arg_os2 (PS: Hps; var ptlPoint: PointL): Long;          external 'PMGPI' index ord_Gpi32OffsetClipRegion;

{ constants for index values of options array for GpiPlayMetaFile }
const
  pmf_SegBase                   = 0;
  pmf_LoadType                  = 1;
  pmf_Resolve                   = 2;
  pmf_Lcids                     = 3;
  pmf_Reset                     = 4;
  pmf_Suppress                  = 5;
  pmf_ColorTables               = 6;
  pmf_ColorRealizable           = 7;
  pmf_Defaults                  = 8;
  pmf_DeleteObjects             = 9;

  { options for GpiPlayMetaFile }
  rs_Default                    = 0;
  rs_NoDiscard                  = 1;
  lc_Default                    = 0;
  lc_Noload                     = 1;
  lc_LoadDisc                   = 3;
  lt_Default                    = 0;
  lt_NoModify                   = 1;
  lt_OriginalView               = 4;
  res_Default                   = 0;
  res_NoReset                   = 1;
  res_Reset                     = 2;
  sup_Default                   = 0;
  sup_NoSuppress                = 1;
  sup_Suppress                  = 2;
  ctab_Default                  = 0;
  ctab_NoModify                 = 1;
  ctab_Replace                  = 3;
  ctab_ReplacePalette           = 4;
  crea_Default                  = 0;
  crea_Realize                  = 1;
  crea_NoRealize                = 2;
  crea_DoRealize                = 3;

  ddef_Default                  = 0;
  ddef_Ignore                   = 1;
  ddef_Loaddisc                 = 3;
  dobj_Default                  = 0;
  dobj_Nodelete                 = 1;
  dobj_Delete                   = 2;
  rsp_Default                   = 0;
  rsp_NoDiscard                 = 1;

{ MetaFile functions }

function GpiCopyMetaFile conv arg_os2 (MF: Hmf): Hmf;                                                  external 'PMGPI' index ord_Gpi32CopyMetaFile;
function GpiDeleteMetaFile conv arg_os2 (MF: Hmf): Bool;                                               external 'PMGPI' index ord_Gpi32DeleteMetaFile;
function GpiLoadMetaFile conv arg_os2 (Ab: Hab; Filename: PChar): Hmf;                                 external 'PMGPI' index ord_Gpi32LoadMetaFile;
function GpiPlayMetaFile conv arg_os2 (PS: Hps; MF: Hmf; Count1: Long; var alOptarray,lSegCount: Long;
  Count2: Long; Desc: PChar): Long;                                                                    external 'PMGPI' index ord_Gpi32PlayMetaFile;
function GpiQueryMetaFileBits conv arg_os2 (MF: Hmf; Offset,Length: Long; var Data): Bool;             external 'PMGPI' index ord_Gpi32QueryMetaFileBits;
function GpiQueryMetaFileLength conv arg_os2 (MF: Hmf): Long;                                          external 'PMGPI' index ord_Gpi32QueryMetaFileLength;
function GpiSaveMetaFile conv arg_os2 (MF: Hmf; Filename: PChar): Bool;                                external 'PMGPI' index ord_Gpi32SaveMetaFile;
function GpiSetMetaFileBits conv arg_os2 (MF: Hmf; Offset,Length: Long; var Buffer): Bool;             external 'PMGPI' index ord_Gpi32SetMetaFileBits;

{ default functions }

function GpiQueryDefArcParams conv arg_os2 (PS: Hps; var arcpArcParams: ArcParams): Bool; external 'PMGPI' index ord_Gpi32QueryDefArcParams;
function GpiQueryDefAttrs conv arg_os2 (PS: Hps; PrimType: Long; flAttrMask: ULong; bunAttr: PBundle): Bool; external 'PMGPI' index ord_Gpi32QueryDefAttrs;
function GpiQueryDefTag conv arg_os2 (PS: Hps; var Tag: Long): Bool;                      external 'PMGPI' index ord_Gpi32QueryDefTag;
function GpiQueryDefViewingLimits conv arg_os2 (PS: Hps; var rclLimits: RectL): Bool;     external 'PMGPI' index ord_Gpi32QueryDefViewingLimits;
function GpiSetDefArcParams conv arg_os2 (PS: Hps; arcpArcParams: ArcParams): Bool;       external 'PMGPI' index ord_Gpi32SetDefArcParams;
function GpiSetDefAttrs conv arg_os2 (PS: Hps; PrimType: Long; AttrMask: ULong; bunAttrs: PBundle): Bool; external 'PMGPI' index ord_Gpi32SetDefAttrs;
function GpiSetDefTag conv arg_os2 (PS: Hps; Tag: Long): Bool;                            external 'PMGPI' index ord_Gpi32SetDefTag;
function GpiSetDefViewingLimits conv arg_os2 (PS: Hps; var rclLimits: RectL): Bool;       external 'PMGPI' index ord_Gpi32SetDefViewingLimits;

type
  PPolygon = ^Polygon;
  Polygon = record
    ulPoints: ULong;
    aPointl:  PPointL;
  end;

  PPolySet = ^PolySet;
  PolySet = record
    ulPolys:     ULong;
    aPolygon: array [0..0] of Polygon;
  end;

{ control flags used by GpiPolygons }
const
  polygon_NoBoundary            = 0;
  polygon_Boundary              = $0001;

  polygon_Alternate             = 0;
  polygon_Winding               = $0002;

  polygon_Excl                  = 0;
  polygon_Incl                  = $0008;

{ default function }

function GpiPolygons conv arg_os2 (PS: Hps; Count: ULong; var aplgn: Polygon; Options,Model: ULong): Long; external 'PMGPI' index ord_Gpi32Polygons;

{ General DEV return values }

const
  dev_Error                     = 0;
  dev_Ok                        = 1;

{ DC type for DevOpenDC }
  od_Queued                     = 2;
  od_Direct                     = 5;
  od_Info                       = 6;
  od_Metafile                   = 7;
  od_Memory                     = 8;
  od_Metafile_NoQuery           = 9;

{ Codes for DevQueryCaps }
  caps_Family                   = 0;
  caps_Io_Caps                  = 1;
  caps_Technology               = 2;
  caps_Driver_Version           = 3;
  caps_Width                    = 4;    { pels }
  caps_Height                   = 5;    { pels }
  caps_Width_In_Chars           = 6;
  caps_Height_In_Chars          = 7;
  caps_Horizontal_Resolution    = 8;    { pels per meter }
  caps_Vertical_Resolution      = 9;    { pels per meter }
  caps_Char_Width               = 10;   { pels }
  caps_Char_Height              = 11;   { pels }
  caps_Small_Char_Width         = 12;   { pels }
  caps_Small_Char_Height        = 13;   { pels }
  caps_Colors                   = 14;
  caps_Color_Planes             = 15;
  caps_Color_BitCount           = 16;
  caps_Color_Table_Support      = 17;
  caps_Mouse_Buttons            = 18;
  caps_Foreground_Mix_Support   = 19;
  caps_Background_Mix_Support   = 20;
  caps_Device_Windowing         = 31;
  caps_Additional_Graphics      = 32;
  caps_Vio_Loadable_Fonts       = 21;
  caps_Window_Byte_Alignment    = 22;
  caps_Bitmap_Formats           = 23;
  caps_Raster_Caps              = 24;
  caps_Marker_Height            = 25;   { pels }
  caps_Marker_Width             = 26;   { pels }
  caps_Device_Fonts             = 27;
  caps_Graphics_Subset          = 28;
  caps_Graphics_Version         = 29;
  caps_Graphics_Vector_Subset   = 30;
  caps_Phys_Colors              = 33;
  caps_Color_Index              = 34;
  caps_Graphics_Char_Width      = 35;
  caps_Graphics_Char_Height     = 36;
  caps_Horizontal_Font_Res      = 37;
  caps_Vertical_Font_Res        = 38;
  caps_Device_Font_Sim          = 39;
  caps_LineWidth_Thick          = 40;
  caps_Device_Polyset_Points    = 41;

{ Constants for CAPS_IO_CAPS }
  caps_Io_Dummy                 = 1;
  caps_Io_Supports_Op           = 2;
  caps_Io_Supports_Ip           = 3;
  caps_Io_Supports_Io           = 4;

{ Constants for caps_Technology }
  caps_Tech_Unknown             = 0;
  caps_Tech_Vector_Plotter      = 1;
  caps_Tech_Raster_Display      = 2;
  caps_Tech_Raster_Printer      = 3;
  caps_Tech_Raster_Camera       = 4;
  caps_Tech_PostScript          = 5;

{ Constants for caps_Color_Table_Support }
  caps_Coltabl_Rgb_8            = 1;
  caps_Coltabl_Rgb_8_Plus       = 2;
  caps_Coltabl_True_Mix         = 4;
  caps_Coltabl_Realize          = 8;

{ Constants for caps_Foreground_Mix_Support }
  caps_Fm_Or                    = 1;
  caps_Fm_Overpaint             = 2;
  caps_Fm_Xor                   = 8;
  caps_Fm_Leavealone            = 16;
  caps_Fm_And                   = 32;
  caps_Fm_General_Boolean       = 64;

{ Constants for caps_Background_Mix_Support }
  caps_Bm_Or                    = 1;
  caps_Bm_OverPaint             = 2;
  caps_Bm_Xor                   = 8;
  caps_Bm_LeaveAlone            = 16;
  caps_Bm_And                   = 32;
  caps_Bm_General_Boolean       = 64;
  caps_Bm_SrcTransparent        = 128;
  caps_Bm_DestTransparent       = 256;

{ Constants for caps_Device_Windowing }
  caps_Dev_Windowing_Support    = 1;

{ Constants for caps_Dev_Font_Sim     }
  caps_Dev_Font_Sim_Bold        = 1;
  caps_Dev_Font_Sim_Italic      = 2;
  caps_Dev_Font_Sim_Underscore  = 4;
  caps_Dev_Font_Sim_Strikeout   = 8;

{ Constants for caps_Additional_Graphics }
  caps_Vdd_Ddb_Transfer         = 1;
  caps_Graphics_Kerning_Support = 2;
  caps_Font_Outline_Default     = 4;
  caps_Font_Image_Default       = 8;
{ bits represented by values 16 and 32 are reserved }
  caps_Scaled_Default_Markers   = 64;
  caps_Color_Cursor_Support     = 128;
  caps_Palette_Manager          = 256;
  caps_Cosmetic_WideLine_Support = 512;
  caps_Direct_Fill              = 1024;
  caps_Rebuild_Fills            = 2048;
  caps_Clip_Fills               = $00001000 { 4096  };
  caps_Enhanced_FontMetrics     = $00002000 { 8192  };
  caps_Transform_Support        = $00004000 { 16384 };
  caps_External_16_BitCount     = $00008000 { 32768 };

{ Constants for caps_Window_Byte_Alignment }
  caps_Byte_Align_Required      = 0;
  caps_Byte_Align_Recommended   = 1;
  caps_Byte_Align_Not_Required  = 2;

{ Constants for caps_Raster_Caps }
  caps_Raster_Bitblt            = 1;
  caps_Raster_Banding           = 2;
  caps_Raster_Bitblt_Scaling    = 4;
  caps_Raster_Set_Pel           = 16;
  caps_Raster_Fonts             = 32;
  caps_Raster_Flood_Fill        = 64;

function DevOpenDC conv arg_os2 (AB: HAB; lType: Long; Token: PChar; Count: Long;
  var dopData: PChar; dcComp: HDC): HDC; external 'PMGPI' index ord_Dev32OpenDC;

function DevCloseDC conv arg_os2 (DC: HDC): HMF; external 'PMGPI' index ord_Dev32CloseDC;

function DevQueryCaps conv arg_os2 (DC: HDC; Start,Count: Long; var lArray: Long): Bool; external 'PMGPI' index ord_Dev32QueryCaps;

{ Records for devesc_QueryVioCellSizes }
type
  PVioSizeCount = ^VioSizeCount;
  VioSizeCount = record
    maxcount: Long;
    count:    Long;
  end;

  PVioFontCellSize = ^VioFontCellSize;
  VioFontCellSize = record
    cx: Long;
    cy: Long;
  end;

{ Record for devesc_GetScalingFactor }

  PSFactors = ^SFactors;
  SFactors = record
    x: Long;
    y: Long;
  end;

{ Record for devesc_NextBand }

  PBandRect = ^BandRect;
  BandRect = record
    xleft:   Long;
    ybottom: Long;
    xright:  Long;
    ytop:    Long;
  end;

{ Return codes for DevEscape }
const
  devesc_Error                  = -1;
  devesc_NotImplemented         = 0;

{ codes for DevEscape }
  devesc_QueryEscSupport        = 0;
  devesc_GetScalingFactor       = 1;
  devesc_QueryVioCellSizes      = 2;
  devesc_GetCp                  = 8000;

  devesc_StartDoc               = 8150;
  devesc_EndDoc                 = 8151;
  devesc_NextBand               = 8152;
  devesc_AbortDoc               = 8153;

  devesc_NewFrame               = 16300;
  devesc_DraftMode              = 16301;
  devesc_FlushOutput            = 16302;
  devesc_RawData                = 16303;
  devesc_SetMode                = 16304;

  devesc_Dbe_First              = 24450;
  devesc_Dbe_Last               = 24455;

{ DevEscape codes for adding extra space to character strings }
  devesc_Char_Extra             = 16998;
  devesc_Break_Extra            = 16999;

{ Codes for DevEscape PM_Q_ESC spool files }
  devesc_Std_Journal            = 32600;

{ Record for devesc_SetMode }
type
  PEscMode = ^EscMode;
  EscMode = record
    mode:     ULong;
    modedata: array[0..0] of Byte;
  end;

{ Return codes for DevPostDeviceModes }
const
  dpdm_Error                    = -1;
  dpdm_None                     = 0;

{ Codes for DevPostDeviceModes }
  dpdm_PostJobProp              = 0;
  dpdm_ChangeProp               = 1;
  dpdm_QueryJobProp             = 2;

{ String types for DevQueryDeviceNames }
type
  Str16 = array [0..15] of Char;
  Str32 = array [0..31] of Char;
  Str64 = array [0..63] of Char;
  PStr16 = ^Str16;
  PStr32 = ^Str32;
  PStr64 = ^Str64;

{ Return code for DevQueryHardcopyCaps }
const
  dqhc_Error                    = -1;

{ codes for DevQueryHardcopyCaps }
  hcaps_Current                 = 1;
  hcaps_Selectable              = 2;

{ Record for DevQueryHardcopyCaps }
type
  PHcInfo = ^HcInfo;
  HcInfo = record
    szFormname: array [0..31] of Char;
    cx:             Long;
    cy:             Long;
    xLeftClip:      Long;
    yBottomClip:    Long;
    xRightClip:     Long;
    yTopClip:       Long;
    xPels:          Long;
    yPels:          Long;
    flAttributes:   Long;
  end;

{ Device Context Functions }

function DevEscape conv arg_os2 (DC: HDC; Code,InCount: Long; var InData; var OutCount: Long;
  OutData: Pointer): Long; external 'PMGPI' index ord_Dev32Escape;
function DevQueryDeviceNames conv arg_os2 (AB: HAB; DriverName: PChar; var dn: Long;
  DeviceName: PStr32; DeviceDesc: PStr64; var dt: Long; DataType: PStr16): Bool; external 'PMGPI' index ord_Dev32QueryDeviceNames;
function DevQueryHardcopyCaps conv arg_os2 (DC: HDC; StartForm,Forms: Long; var HcInf: HcInfo): Long; external 'PMGPI' index ord_Dev32QueryHardCopyCaps;
function DevPostDeviceModes conv arg_os2 (AB: HAB; DriverData: PDrivData; DriverName,
  DeviceName,Name: PChar; Options: ULong): Long; external 'PMGPI' index ord_Dev32PostDeviceModes;

{----[ PMHELP ]----}

{ HelpSubTable entry structure }
type
  PHelpSubTable = ^HelpSubTable;
  HelpSubTable = Word;

{ HelpTable entry structure }
type
  PHelpTable = ^HelpTable;
  HelpTable = record
    idAppWindow:      Word;
    phstHelpSubTable: PHelpSubTable;
    idExtPanel:       Word;
  end;

{ IPF Initialization record used on the WinCreateHelpInstance call }

  PHelpInit = ^HelpInit;
  HelpInit = record
    cb:                       ULong;
    ulReturnCode:             ULong;
    pszTutorialName:          PChar;
    phtHelpTable:             PHelpTable;
    hmodHelpTableModule:      HModule;
    hmodAccelActionBarModule: HModule;
    idAccelTable:             ULong;
    idActionBar:              ULong;
    PCharHelpWindowTitle:     PChar;
    fShowPanelId:             ULong;
    PCharHelpLibraryName:     PChar;
  end;

{ Search parent chain indicator for hm_Set_Active_Window message }
const
  hwnd_Parent                   = HWnd(0);

{ Constants used to define whether user wants to display panel using }
{ panel number or panel name                                         }
  hm_ResourceId                 = 0;
  hm_PanelName                  = 1;

  hmPanelType_Number            = 0;
  hmPanelType_Name              = 1;

{ Constants used to define how the panel IDs are displayed on }
{ help panels                                                 }
  cmic_Hide_Panel_Id            = $0000;
  cmic_Show_Panel_Id            = $0001;
  cmic_Toggle_Panel_Id          = $0002;

{ Window Help API declarations }

function WinDestroyHelpInstance conv arg_os2 (HelpInstance: HWnd): Bool; external 'HELPMGR' index ord_Win32DestroyHelpInstance;
function WinCreateHelpInstance conv arg_os2 (AB: Hab; var InitHMInitRec: HelpInit): HWnd; external 'HELPMGR' index ord_Win32CreateHelpInstance;
function WinAssociateHelpInstance conv arg_os2 (HelpInstance,App: HWnd): Bool; external 'HELPMGR' index ord_Win32AssociateHelpInstance;
function WinQueryHelpInstance conv arg_os2 (App: HWnd): HWnd; external 'HELPMGR' index ord_Win32QueryHelpInstance;
function WinLoadHelpTable conv arg_os2 (HelpInstance: HWnd; IdHelpTable: ULong;
  Module: HModule): Bool; external 'HELPMGR' index ord_Win32LoadHelpTable;
function WinCreateHelpTable conv arg_os2 (HelpInstance: HWnd; var HelpTbl: HelpTable): Bool; external 'HELPMGR' index ord_Win32CreateHelpTable;

{ IPF message base }
const
  hm_Msg_base                   = $0220;
  { Messages applications can send to the IPF }
  hm_Dismiss_Window             = hm_Msg_Base + $0001;
  hm_Display_Help               = hm_Msg_Base + $0002;
  hm_Ext_Help                   = hm_Msg_Base + $0003;
  hm_General_Help               = hm_Ext_Help;
  hm_Set_Active_Window          = hm_Msg_Base + $0004;
  hm_Load_Help_Table            = hm_Msg_Base + $0005;
  hm_Create_Help_Table          = hm_Msg_Base + $0006;
  hm_Set_Help_Window_Title      = hm_Msg_Base + $0007;
  hm_Set_Show_Panel_Id          = hm_Msg_Base + $0008;
  hm_Replace_Help_For_Help      = hm_Msg_Base + $0009;
  hm_Replace_Using_Help         = hm_Replace_Help_For_Help;
  hm_Help_Index                 = hm_Msg_Base + $000A;
  hm_Help_Contents              = hm_Msg_Base + $000B;
  hm_Keys_Help                  = hm_Msg_Base + $000C;
  hm_Set_Help_Library_Name      = hm_Msg_Base + $000D;

  hm_Set_ObjCom_Window          = hm_Msg_Base + $0018;
  hm_Update_ObjCom_Window_Chain = hm_Msg_Base + $0019;
  hm_Query_Ddf_Data             = hm_Msg_Base + $001A;
  hm_Invalidate_Ddf_Data        = hm_Msg_Base + $001B;
  hm_Query                      = hm_Msg_Base + $001C;
  hm_Set_CoverPage_Size         = hm_Msg_Base + $001D;

{ Constants used to query the info from IPF in hm_Query message }
{ Hi word in lParam 1 }
  hmqw_CoverPage                = $0001;
  hmqw_Index                    = $0002;
  hmqw_Toc                      = $0003;
  hmqw_Search                   = $0004;
  hmqw_ViewPages                = $0005;
  hmqw_Library                  = $0006;
  hmqw_ViewPort                 = $0007;
  hmqw_ObjCom_Window            = $0008;
  hmqw_Instance                 = $0009;
  hmqw_ActiveViewPort           = $000A;
  Control_Selected              = $000B;

  hmqw_Group_ViewPort           = $00F1;
  hmqw_Res_ViewPort             = $00F2;
  UserData                      = $00F3;

{ Lo word in lParam1 of hmqw_ViewPort }
  hmqvp_Number                  = $0001;
  hmqvp_Name                    = $0002;
  hmqvp_Group                   = $0003;

{ Predefined Control IDs }
  ctrl_Previous_Id              = $0001;
  ctrl_Search_Id                = $0002;
  ctrl_Print_Id                 = $0003;
  ctrl_Index_Id                 = $0004;
  ctrl_Contents_Id              = $0005;
  ctrl_Back_Id                  = $0006;
  ctrl_Forward_Id               = $0007;
  ctrl_Tutorial_Id              = $00FF;

  ctrl_User_Id_Base             = 257;

{ Messages the IPF sends to the applications active window }
{ as defined by the IPF.                                   }
  hm_Error                      = hm_Msg_Base + $000E;
  hm_HelpSubitem_Not_Found      = hm_Msg_Base + $000F;
  hm_Query_Keys_Help            = hm_Msg_Base + $0010;
  hm_Tutorial                   = hm_Msg_Base + $0011;
  hm_Ext_Help_Undefined         = hm_Msg_Base + $0012;
  hm_General_Help_Undefined     = hm_Ext_Help_Undefined;
  hm_ActionBar_Command          = hm_Msg_Base + $0013;
  hm_Inform                     = hm_Msg_Base + $0014;
  hm_Notify                     = hm_Msg_Base + $0022;
  hm_Set_UserData               = hm_Msg_Base + $0023;
  hm_Control                    = hm_Msg_Base + $0024;

{ notify information for hm_Notify }
  open_CoverPage                = $0001;
  open_Page                     = $0002;
  swap_Page                     = $0003;
  open_Toc                      = $0004;
  open_Index                    = $0005;
  open_History                  = $0006;
  open_Search_Hit_List          = $0007;
  open_Library                  = $0008;

{  hmerr_No_Frame_Wnd_In_Chain - There is no frame window in the        }
{  window chain from which to find or set the associated help instance  }
  hmerr_No_Frame_Wnd_In_Chain   = $00001001;

{ hmerr_Invalid_Assoc_App_Wnd - The application window handle specified }
{ on the WinAssociateHelpInstance call is not a valid window handle     }
  hmerr_Invalid_Assoc_App_Wnd   = $00001002;

{ hmerr_Invalid_Assoc_Help_Inst - The help instance handle specified on }
{ the WinAssociateHelpInstance call is not a valid window handle        }
  hmerr_Invalid_Assoc_Help_Inst = $00001003;

{ hmerr_Invalid_Destroy_Help_Inst - The window handle specified as the  }
{ help instance to destroy is not of the help instance class            }
  hmerr_Invalid_Destroy_Help_Inst = $00001004;

{ hmerr_No_Help_Inst_In_chain - The parent or owner chain of the        }
{ application window specified does not have a help instance associated }
{ with it }
  hmerr_No_Help_Inst_In_chain   = $00001005;

{ hmerr_Invalid_Help_Instance_Hdl - The handle specified to be a help   }
{ instance does not have the class name of a IPF help instance          }
  hmerr_Invalid_Help_Instance_Hdl = $00001006;

{ hmerr_Invalid_Query_App_Wnd - The application window specified on     }
{ a WinQueryHelpInstance call is not a valid window handle              }
  hmerr_Invalid_Query_App_Wnd   = $00001007;

{ hmerr_Help_Inst_Called_Invalid - The handle of the help instance      }
{ specified on an API call to the IPF does not have the class name of   }
{ an IPF help instance }
  hmerr_Help_Inst_Called_Invalid = $00001008;

  hmerr_HelpTable_Undefine      = $00001009;
  hmerr_Help_Instance_Undefine  = $0000100A;
  hmerr_Helpitem_Not_Found      = $0000100B;
  hmerr_Invalid_HelpSubitem_Size = $0000100C;
  hmerr_HelpSubitem_Not_Found   = $0000100D;

{ hmerr_Index_Not_Found - No index in library file }
  hmerr_Index_Not_Found         = $00002001;

{ hmerr_Content_Not_Found - Library file does not have any contents }
  hmerr_Content_Not_Found       = $00002002;

{ hmerr_Open_Lib_File - Cannot open library file }
  hmerr_Open_Lib_File           = $00002003;

{ hmerr_Read_Lib_File - Cannot read library file }
  hmerr_Read_Lib_File           = $00002004;

{ hmerr_Close_Lib_File - Cannot close library file }
  hmerr_Close_Lib_File          = $00002005;

{ hmerr_Invalid_Lib_File - Improper library file provided }
  hmerr_Invalid_Lib_File        = $00002006;

{  hmerr_No_Memory - Unable to allocate the requested amount of memory }
  hmerr_No_Memory               = $00002007;

{ hmerr_Allocate_Segment - Unable to allocate a segment of memory for memory }
{ allocation requested from the IPF                                          }
  hmerr_Allocate_Segment        = $00002008;

{ hmerr_Free_Memory - Unable to free allocated  memory }
  hmerr_FREE_MEMORY             = $00002009;

{ hmerr_Panel_Not_Found - Unable to find a help panel requested to }
{ help manager }
  hmerr_Panel_Not_Found         = $00002010;

{ hmerr_Database_Not_Open - Unable to read the unopened database }
  hmerr_Database_Not_Open       = $00002011;

{ hmerr_Load_Dll - Unable to load resource dll }
  hmerr_Load_Dll                = $00002013;

{ AC Viewport stucture definitions }
type
  PAcVp = ^AcVp;
  AcVp = record
    cb:         ULong;
    hAB:        Hab;
    hmq:        Hmq;
    ObjectID:   ULong;          { object identifier }
    HWndParent: HWnd;           { IPF viewport client handle }
    HWndOwner:  HWnd;           { IPF viewport client handle }
    HWndACVP:   HWnd;           { applications frame window HWnd }
  end;

{ DDF types and constants }
  Hddf = Pointer;

{ DdfHyperText Flags }
const
  reference_By_Id               = 0;
  reference_By_Res              = 1;

{ DdfBeginList formatting flags }
  hmbt_None                     = 1;
  hmbt_All                      = 2;
  hmbt_Fit                      = 3;

  hmls_SingleLine               = 1;
  hmls_DoubleLine               = 2;

{ DdfBitmap alignment flags }
  art_RunIn                     = $10;
  art_Left                      = $01;
  art_Right                     = $02;
  art_Center                    = $04;

{ DdfSetColor Color Flag }
  clr_Unchanged                 = -6;

{ DDF API declarations }

function DdfInitialize conv arg_os2 (HelpInstance: HWnd; cbBuffer,Increment: ULong): Hddf; external 'HELPMGR' index ord_DdfInitialize;
function DdfPara conv arg_os2 (Ddf: Hddf): Bool; external 'HELPMGR' index ord_DdfPara;
function DdfSetFormat conv arg_os2 (Ddf: Hddf; FormatType: ULong): Bool; external 'HELPMGR' index ord_DdfSetFormat;
function DdfSetTextAlign conv arg_os2 (Ddf: Hddf; Align: ULong): Bool; external 'HELPMGR' index ord_DdfSetTextAlign;
function DdfSetColor conv arg_os2 (Ddf: Hddf; BackColor,ForColor: Color): Bool; external 'HELPMGR' index ord_DdfSetColor;
function DdfInform conv arg_os2 (Ddf: Hddf; Text: PChar; InformNumber: ULong): Bool; external 'HELPMGR' index ord_DdfInform;
function DdfSetFontStyle conv arg_os2 (Ddf: Hddf; FontStyle: ULong): Bool; external 'HELPMGR' index ord_DdfSetFontStyle;
function DdfHyperText conv arg_os2 (Ddf: Hddf; Text,Reference: PChar; RefType: ULong): Bool; external 'HELPMGR' index ord_DdfHyperText;
function DdfBeginList conv arg_os2 (Ddf: Hddf; WidthDT,BreakType,Spacing: ULong): Bool; external 'HELPMGR' index ord_DdfBeginList;
function DdfListItem conv arg_os2 (Ddf: Hddf; Term,Description: PChar): Bool; external 'HELPMGR' index ord_DdfListItem;
function DdfEndList conv arg_os2 (Ddf: Hddf): Bool; external 'HELPMGR' index ord_DdfEndList;
function DdfMetafile conv arg_os2 (Ddf: Hddf; mf: Hmf; R: PRectL): Bool; external 'HELPMGR' index ord_DdfMetafile;
function DdfText conv arg_os2 (Ddf: Hddf; Text: PChar): Bool; external 'HELPMGR' index ord_DdfText;
function DdfSetFont conv arg_os2 (Ddf: Hddf; FaceName: PChar; Width,Height: ULong): Bool; external 'HELPMGR' index ord_DdfSetFont;
function DdfBitmap conv arg_os2 (Ddf: Hddf; Hbm: HBitMap; Align: ULong): Bool; external 'HELPMGR' index ord_DdfBitMap;

{ Error codes returned by DDF API functions }
const
  hmerr_Ddf_Memory              = $3001;
  hmerr_Ddf_Align_Type          = $3002;
  hmerr_Ddf_BackColor           = $3003;
  hmerr_Ddf_ForeColor           = $3004;
  hmerr_Ddf_FontStyle           = $3005;
  hmerr_Ddf_RefType             = $3006;
  hmerr_Ddf_List_Unclosed       = $3007;
  hmerr_Ddf_List_Uninitialized  = $3008;
  hmerr_Ddf_List_BreakType      = $3009;
  hmerr_Ddf_List_Spacing        = $300A;
  hmerr_Ddf_HInstance           = $300B;
  hmerr_Ddf_Exceed_Max_Length   = $300C;
  hmerr_Ddf_Exceed_Max_Inc      = $300D;
  hmerr_Ddf_Invalid_Ddf         = $300E;
  hmerr_Ddf_Format_Type         = $300F;
  hmerr_Ddf_Invalid_Parm        = $3010;
  hmerr_Ddf_Invalid_Font        = $3011;
  hmerr_Ddf_Severe              = $3012;

{ From HMTAILOR.H }
{ OS/2 Help window menu identifiers }

  idm_ChildVpSysMenu            = 810;

  idm_File                      = $7F00;
  idm_Search                    = $7F01;
  idm_Print                     = $7F02;
  idm_Viewport                  = $7F05;

  idm_Edit                      = $7F10;
  idm_Clip_Copy                 = $7F11;
  idm_Clip_Cf                   = $7F12;
  idm_Clip_Af                   = $7F13;
  idm_Libraries                 = $7F14;

  idm_Options                   = $7F20;
  idm_Viewpages                 = $7F21;
  idm_Toc                       = $7F23;
  idm_Option_ExpLevel           = $7F24;
  idm_Option_ExpBranch          = $7F25;
  idm_Option_ExpAll             = $7F26;
  idm_Option_ColBranch          = $7F27;
  idm_Option_ColAll             = $7F28;
  idm_Previous                  = $7F29;

  idm_Help                      = $7F30;
  idm_HelpHelp                  = $7F31;
  idm_Help_Extended             = $7F32;
  idm_Using_Help                = idm_HelpHelp;
  idm_General_Help              = idm_Help_Extended;
  idm_Help_Keys                 = $7F33;
  idm_Help_Index                = $7F34;

  idm_Tutorial                  = $7F37;

{----[ PMSHL ]----}

const
  { Maximum title length }
  MaxNameL                      = 60;

{ program handle }
type
   PHProgram = ^HProgram;
   HProgram  = LHandle;
   HApp      = LHandle;
   { ini file handle }
   PHIni     = ^HIni;
   HIni      = LHandle;

const
  HIni_Profile                  = HIni( 0);
  HIni_UserProfile              = HIni(-1);
  HIni_SystemProfile            = HIni(-2);
  HIni_User                     = HIni_UserProfile;
  HIni_System                   = HIni_SystemProfile;

type
  PPrfProfile = ^PrfProfile;
  PrfProfile = record
    cchUserName: ULong;
    pszUserName: PChar;
    cchSysName:  ULong;
    pszSysName:  PChar;
  end;

{ program list section }
{ maximum path length  }
const
  MaxPathL                      = 128;

{ root group handle }
  sgh_Root                      = HProgram(-1);

type
  PHProgArray   = ^HProgArray;
  HProgArray    = HProgram;
  PProgCategory = ^ProgCategory;
  ProgCategory  = ULong;

{ values acceptable for ProgCategory for PM groups }
const
  prog_Default                  = ProgCategory(0);
  prog_FullScreen               = ProgCategory(1);
  prog_WindowableVio            = ProgCategory(2);
  prog_Pm                       = ProgCategory(3);
  prog_Group                    = ProgCategory(5);
  prog_Real                     = ProgCategory(4);
  prog_Vdm                      = ProgCategory(4);
  prog_WindowedVdm              = ProgCategory(7);
  prog_Dll                      = ProgCategory(6);
  prog_Pdd                      = ProgCategory(8);
  prog_Vdd                      = ProgCategory(9);
  prog_Window_Real              = ProgCategory(10);
  prog_Window_Prot              = ProgCategory(11);
  prog_Window_Auto              = ProgCategory(12);
  prog_SeamlessVdm              = ProgCategory(13);
  prog_SeamlessCommon           = ProgCategory(14);
  prog_Reserved                 = ProgCategory(255);

type
  PProgType = ^ProgType;
  ProgType = record
    progc:     ProgCategory;
    fbVisible: ULong;
  end;

{ visibility flag for ProgType record }
const
  she_Visible                   = $00;
  she_Invisible                 = $01;
  she_Reserved                  = $FF;

{ Protected group flag for ProgType record }
  she_Unprotected               = $00;
  she_Protected                 = $02;

{ Records associated with 'Prf' calls }
type
  PProgDetails = ^ProgDetails;
  ProgDetails = record
    Length:         ULong;      { set this to SizeOf(ProgDetails)  }
    progt:          ProgType;
    pszTitle:       PChar;      { any of the pointers can be Nil   }
    pszExecutable:  PChar;
    pszParameters:  PChar;
    pszStartupDir:  PChar;
    pszIcon:        PChar;
    pszEnvironment: PChar;      { this is terminated by  #0#0      }
    swpInitial:     Swp;        { this replaces XYWINSIZE          }
  end;

  PProgTitle = ^ProgTitle;
  ProgTitle = record
    hprog:    HProgram;
    progt:    ProgType;
    pszTitle: PChar;
  end;

{ Program List API Function Definitions }
{ Program List API available 'Prf' calls }

function PrfQueryProgramTitles conv arg_os2 (Ini: HIni; PrgGroup: HProgram;
  Titles: PProgTitle; cchBufferMax: ULong; var Count: ULong): ULong; external 'PMSHAPI' index ord_Prf32QueryProgramTitles;

{  NOTE: string information is concatanated after the array of      }
{        ProgTitle structures so you need to allocate storage       }
{        greater than SizeOf(ProgTitle)*cPrograms to query programs }
{        in a group.                                                }
{                                                                   }
{  PrfQueryProgramTitles recommended usage to obtain titles of all  }
{  programs in a group (Hgroup=sgh_Root is for all groups):         }
{                                                                   }
{  BufLen := PrfQueryProgramTitles(HIni, Hgroup, nil, 0 Count);     }
{                                                                   }
{  Alocate buffer of  Buflen                                        }
{                                                                   }
{  Len = PrfQueryProgramTitles(HIni, Hgroup, PProgTitle(pBuffer),   }
{                               BufLen, Count);                     }
{                                                                   }

function PrfAddProgram conv arg_os2 (Ini: HIni; pDetails: PProgDetails;
  ProgGroup: HProgram): HProgram; external 'PMSHAPI' index ord_Prf32AddProgram;
function PrfChangeProgram conv arg_os2 (Ini: HIni; Prog: HProgram;
  Details: PProgDetails): Bool; external 'PMSHAPI' index ord_Prf32ChangeProgram;
function PrfQueryDefinition conv arg_os2 (Ini: HIni; Prog: HProgram; Details: PProgDetails;
  cchBufferMax: ULong): ULong; external 'PMSHAPI' index ord_Prf32QueryDefinition;

{  NOTE: string information is concatanated after the ProgDetails   }
{        field structure so you need to allocate storage greater    }
{        than SizeOf(ProgDetails) to query programs                 }
{                                                                   }
{  PrfQueryDefinition recomended usage:                             }
{                                                                   }
{  BufferLen := PrfQueryDefinition(HIni,Hprog,nil,0)                }
{                                                                   }
{  Alocate buffer of bufferlen bytes                                }
{  set Length field (0 will be supported)                           }
{                                                                   }
{  PProgDetails(pBuffer)^.Length := SizeOf(PProgDetails)            }
{                                                                   }
{  Len := PrfQueryDefinition(HIni, Hprog, PProgDetails(pBuffer),    }
{      bufferlen)                                                   }

function PrfRemoveProgram conv arg_os2 (Ini: HIni; Prog: HProgram): Bool; external 'PMSHAPI' index ord_Prf32RemoveProgram;
function PrfQueryProgramHandle conv arg_os2_16 (Ini: HIni; pszExe: PChar;
  ProgArray: PHProgArray; cchBufferMax: ULong; var Count: ULong): ULong; external 'PMSHAPI' index ord_PrfQueryProgramHandle;
function PrfCreateGroup conv arg_os2_16 (Ini: HIni; Title: PChar; Visibility: Byte): HProgram; external 'PMSHAPI' index ord_PrfCreateGroup;
function PrfDestroyGroup conv arg_os2 (Ini: HIni; ProgGroup: HProgram): Bool; external 'PMSHAPI' index ord_Prf32DestroyGroup;
function PrfQueryProgramCategory conv arg_os2_16 (Ini: HIni; Exe: PChar): ProgCategory; external 'PMSHAPI' index ord_PrfQueryProgramCategory;
function WinStartApp conv arg_os2 (Notify: HWnd; Details: PProgDetails; Params: PChar;
  Reserved: Pointer; Options: ULong): HApp; external 'PMSHAPI' index ord_Win32StartApp;

{ bit values for Options parameter }
const
  saf_ValidFlags                = $001F;
  saf_InstalledCmdLine          = $0001;    { use installed parameters }
  saf_StartChildApp             = $0002;    { related application }
  saf_Maximized                 = $0004;    { Start App maximized }
  saf_Minimized                 = $0008;    { Start App minimized, if not saf_Maximized }
  saf_Background                = $0010;    { Start app in the background }

function WinTerminateApp conv arg_os2 (App: HApp): Bool; external 'PMSHAPI' index ord_Win32Terminate;

{ switch list section }

type
  PHSwitch = ^LHandle;
  HSwitch = LHandle;

  PSwCntrl = ^SwCntrl;
  SwCntrl = record
    hwnd:                  HWnd;
    hwndIcon:              HWnd;
    hprog:                 HProgram;
    idProcess:             Pid;
    idSession:             ULong;
    uchVisibility:         ULong;
    fbJump:                ULong;
    szSwtitle: array [0..MaxNameL+3] of Char;
    bProgType:             ULong;
  end;

{ visibility flag for SwCntrl record }
const
  swl_Visible                   = $04;
  swl_Invisible                 = $01;
  swl_Grayed                    = $02;

{ jump flag for SwCntrl record }
  swl_Jumpable                  = $02;
  swl_NotJumpable               = $01;

{ Switching Program functions }

function WinAddSwitchEntry conv arg_os2 (Sw: PSwCntrl): HSwitch; external 'PMSHAPI' index ord_Win32AddSwitchEntry;
function WinRemoveSwitchEntry conv arg_os2 (Sw: HSwitch): ULong; external 'PMSHAPI' index ord_Win32RemoveSwitchEntry;

type
  PSwEntry = ^SwEntry;
  SwEntry = record
    HSwitch: HSwitch;
    swctl:   SwCntrl;
  end;

  PSwbLock = ^SwbLock;
  SwbLock = record
    cswentry: ULong;
    aswentry: SwEntry;
  end;

function WinChangeSwitchEntry conv arg_os2 (Switch: HSwitch; pswctlSwitchData: PSwCntrl): ULong; external 'PMSHAPI' index ord_Win32ChangeSwitchEntry;
function WinCreateSwitchEntry conv arg_os2 (AB: Hab; pswctlSwitchData: PSwCntrl): HSwitch; external 'PMSHAPI' index ord_Win32CreateSwitchEntry;
function WinQuerySessionTitle conv arg_os2 (AB: Hab; Session: ULong; Title: PChar;
  Titlelen: ULong): ULong; external 'PMSHAPI' index ord_Win32QuerySessionTitle;
function WinQuerySwitchEntry conv arg_os2 (Switch: HSwitch; pswctlSwitchData: PSwCntrl): ULong; external 'PMSHAPI' index ord_Win32QuerySwitchEntry;
function WinQuerySwitchHandle conv arg_os2 (Wnd: HWnd; Process: Pid): HSwitch; external 'PMSHAPI' index ord_Win32QuerySwitchHandle;
function WinQuerySwitchList conv arg_os2_16 (AB: Hab; pswblkSwitchEntries: PSwbLock;
  DataLength: ULong): ULong; external 'PMSHAPI' index ord_WinQuerySwitchList;
function WinQueryTaskSizePos conv arg_os2 (AB: Hab; ScreenGroup: ULong; PositionData: PSwp): ULong; external 'PMSHAPI' index ord_Win32QueryTaskSizePos;
function WinQueryTaskTitle conv arg_os2 (Session: ULong; Title: PChar; Titlelen: ULong): ULong; external 'PMSHAPI' index ord_Win32QueryTaskTitle;
function WinSwitchToProgram conv arg_os2 (HSwitchSwHandle: HSwitch): ULong; external 'PMSHAPI' index ord_Win32SwitchToProgram;

{ OS2.INI Access functions }

function PrfQueryProfileInt conv arg_os2 (Ini: HIni; App,Key: PChar; Default: Long): Long; external 'PMSHAPI' index ord_Prf32QueryProfileInt;
function PrfQueryProfileString conv arg_os2 (Ini: HIni; App,Key,Default: PChar;
  Buffer: Pointer; cchBufferMax: ULong): ULong; external 'PMSHAPI' index ord_Prf32QueryProfileString;
function PrfWriteProfileString conv arg_os2 (Ini: HIni; App,Key,Data: PChar): Bool; external 'PMSHAPI' index ord_Prf32WriteProfileString;
function PrfQueryProfileSize conv arg_os2 (Ini: HIni; App,Key: PChar; var ReqLen: ULong): Bool; external 'PMSHAPI' index ord_Prf32QueryProfileSize;
function PrfQueryProfileData conv arg_os2 (Ini: HIni; App,Key: PChar; Buffer: Pointer;
  var BufLen: ULong): Bool;external 'PMSHAPI' index ord_Prf32QueryProfileData;
function PrfWriteProfileData conv arg_os2 (Ini: HIni; App,Key: PChar; Data: Pointer;
  DataLen: ULong): Bool; external 'PMSHAPI' index ord_Prf32WriteProfileData;
function PrfOpenProfile conv arg_os2 (AB: Hab; FileName: PChar): HIni; external 'PMSHAPI' index ord_Prf32OpenProfile;
function PrfCloseProfile conv arg_os2 (Ini: HIni): Bool; external 'PMSHAPI' index ord_Prf32CloseProfile;
function PrfReset conv arg_os2 (AB: Hab; Prf: PPrfProfile): Bool; external 'PMSHAPI' index ord_Prf32Reset;
function PrfQueryProfile conv arg_os2 (AB: Hab; Prf: PPrfProfile): Bool; external 'PMSHAPI' index ord_Prf32QueryProfile;

{ public message, broadcast on WinReset }
const
  pl_Altered                    = $008E; { wm_ShellFirst + $0E }

{----[ PMTYPES ]----}

const
  dtyp_User                     = 16384;
  dtyp_Ctl_Array                = 1;
  dtyp_Ctl_PArray               = -1;
  dtyp_Ctl_offset               = 2;
  dtyp_Ctl_length               = 3;
{ Ordinary datatypes }
  dtyp_Accel                    = 28;
  dtyp_AccelTable               = 29;
  dtyp_ArcParams                = 38;
  dtyp_AreaBundle               = 139;
  dtyp_Atom                     = 90;
  dtyp_BitMapInfo               = 60;
  dtyp_BitMapInfoHeader         = 61;
  dtyp_BitMapInfo2              = 170;
  dtyp_BitMapInfoHeader2        = 171;
  dtyp_Bit16                    = 20;
  dtyp_Bit32                    = 21;
  dtyp_Bit8                     = 19;
  dtyp_Bool                     = 18;
  dtyp_BtncData                 = 35;
  dtyp_Byte                     = 13;
  dtyp_CatchBuf                 = 141;
  dtyp_Char                     = 15;
  dtyp_CharBundle               = 135;
  dtyp_ClassInfo                = 95;
  dtyp_Count2                   = 93;
  dtyp_Count2b                  = 70;
  dtyp_Count2Ch                 = 82;
  dtyp_Count4                   = 152;
  dtyp_Count4b                  = 42;
  dtyp_Cpid                     = 57;
  dtyp_CreateStruct             = 98;
  dtyp_CursorInfo               = 34;
  dtyp_DevOpenStruc             = 124;
  dtyp_DlgTemplate              = 96;
  dtyp_DlgTItem                 = 97;
  dtyp_EntryFData               = 127;
  dtyp_ErrorId                  = 45;
  dtyp_FAttrs                   = 75;
  dtyp_Ffdescs                  = 142;
  dtyp_Fixed                    = 99;
  dtyp_FontMetrics              = 74;
  dtyp_FrameCData               = 144;
  dtyp_Gradientl                = 48;
  dtyp_Hab                      = 10;
  dtyp_Haccel                   = 30;
  dtyp_Happ                     = 146;
  dtyp_HAtomTbl                 = 91;
  dtyp_HBitMap                  = 62;
  dtyp_HcInfo                   = 46;
  dtyp_Hdc                      = 132;
  dtyp_HEnum                    = 117;
  dtyp_HHeap                    = 109;
  dtyp_HIni                     = 53;
  dtyp_HLib                     = 147;
  dtyp_Hmf                      = 85;
  dtyp_Hmq                      = 86;
  dtyp_HPointer                 = 106;
  dtyp_HProgram                 = 131;
  dtyp_Hps                      = 12;
  dtyp_HRgn                     = 116;
  dtyp_HSem                     = 140;
  dtyp_Hspl                     = 32;
  dtyp_HSwitch                  = 66;
  dtyp_Hvps                     = 58;
  dtyp_HWnd                     = 11;
  dtyp_Identity                 = 133;
  dtyp_Identity4                = 169;
  dtyp_ImageBundle              = 136;
  dtyp_Index2                   = 81;
  dtyp_Ipt                      = 155;
  dtyp_KerningPairs             = 118;
  dtyp_Length2                  = 68;
  dtyp_Length4                  = 69;
  dtyp_LineBundle               = 137;
  dtyp_Long                     = 25;
  dtyp_MarkerBundle             = 138;
  dtyp_Matrixlf                 = 113;
  dtyp_MlectlData               = 161;
  dtyp_MLeMargStruct            = 157;
  dtyp_MLeOverflow              = 158;
  dtyp_Offset2b                 = 112;
  dtyp_OwnerItem                = 154;
  dtyp_Pid                      = 92;
  dtyp_Pix                      = 156;
  dtyp_PointerInfo              = 105;
  dtyp_PointL                   = 77;
  dtyp_ProgCategory             = 129;
  dtyp_ProgramEntry             = 128;
  dtyp_ProgType                 = 130;
  dtyp_Property2                = 88;
  dtyp_Property4                = 89;
  dtyp_Qmsg                     = 87;
  dtyp_RectL                    = 121;
  dtyp_ResId                    = 125;
  dtyp_RGB                      = 111;
  dtyp_RgnRect                  = 115;
  dtyp_SbcData                  = 159;
  dtyp_SegOff                   = 126;
  dtyp_Short                    = 23;
  dtyp_SizeF                    = 101;
  dtyp_SizeL                    = 102;
  dtyp_StrL                     = 17;
  dtyp_Str16                    = 40;
  dtyp_Str32                    = 37;
  dtyp_Str64                    = 47;
  dtyp_Str8                     = 33;
  dtyp_SwBlock                  = 63;
  dtyp_SwCntrl                  = 64;
  dtyp_SwEntry                  = 65;
  dtyp_Swp                      = 31;
  dtyp_Tid                      = 104;
  dtyp_Time                     = 107;
  dtyp_TrackInfo                = 73;
  dtyp_UChar                    = 22;
  dtyp_ULong                    = 26;
  dtyp_UserButton               = 36;
  dtyp_UShort                   = 24;
  dtyp_Width4                   = 108;
  dtyp_WndParams                = 83;
  dtyp_WndProc                  = 84;
  dtyp_WPoint                   = 59;
  dtyp_WRect                    = 55;
  dtyp_xyMinSize                = 52;
{ pointer datatypes }
  dtyp_PAccel                   = -28;
  dtyp_PAccelTable              = -29;
  dtyp_PArcParams               = -38;
  dtyp_PAreaBundle              = -139;
  dtyp_PAtom                    = -90;
  dtyp_PBitMapInfo              = -60;
  dtyp_PBitMapInfoHeader        = -61;
  dtyp_PBitMapInfo2             = -170;
  dtyp_PBitMapInfoHeader2       = -171;
  dtyp_PBit16                   = -20;
  dtyp_PBit32                   = -21;
  dtyp_PBit8                    = -19;
  dtyp_PBool                    = -18;
  dtyp_PBtnCData                = -35;
  dtyp_PByte                    = -13;
  dtyp_PCatchBuf                = -141;
  dtyp_PChar                    = -15;
  dtyp_PCharBundle              = -135;
  dtyp_PClassInfo               = -95;
  dtyp_PCount2                  = -93;
  dtyp_PCount2b                 = -70;
  dtyp_PCount2Ch                = -82;
  dtyp_PCount4                  = -152;
  dtyp_PCount4b                 = -42;
  dtyp_PCPid                    = -57;
  dtyp_PCreateStruct            = -98;
  dtyp_PCursorInfo              = -34;
  dtyp_PDevOpenStruc            = -124;
  dtyp_PDlgTemplate             = -96;
  dtyp_PDlgTItem                = -97;
  dtyp_PEntryFData              = -127;
  dtyp_PErrorId                 = -45;
  dtyp_PFAttrs                  = -75;
  dtyp_Pffdescs                 = -142;
  dtyp_PFixed                   = -99;
  dtyp_PFontMetrics             = -74;
  dtyp_PFrameCData              = -144;
  dtyp_PGradientl               = -48;
  dtyp_PHab                     = -10;
  dtyp_PHAccel                  = -30;
  dtyp_PHApp                    = -146;
  dtyp_PHAtomTbl                = -91;
  dtyp_PHBitMap                 = -62;
  dtyp_PHcInfo                  = -46;
  dtyp_PHdc                     = -132;
  dtyp_PHEnum                   = -117;
  dtyp_PHHeap                   = -109;
  dtyp_PHIni                    = -53;
  dtyp_PHLib                    = -147;
  dtyp_PHmf                     = -85;
  dtyp_PHmq                     = -86;
  dtyp_PHPointer                = -106;
  dtyp_PHProgram                = -131;
  dtyp_PHps                     = -12;
  dtyp_PHRgn                    = -116;
  dtyp_PHSem                    = -140;
  dtyp_PHSpl                    = -32;
  dtyp_PHSwitch                 = -66;
  dtyp_PHvps                    = -58;
  dtyp_PHWnd                    = -11;
  dtyp_PIdentity                = -133;
  dtyp_PIdentity4               = -169;
  dtyp_PImageBundle             = -136;
  dtyp_PIndex2                  = -81;
  dtyp_Pipt                     = -155;
  dtyp_PkerningPairs            = -118;
  dtyp_PLength2                 = -68;
  dtyp_PLength4                 = -69;
  dtyp_PLinebundle              = -137;
  dtyp_PLong                    = -25;
  dtyp_PMarkerBundle            = -138;
  dtyp_PMatrixlf                = -113;
  dtyp_PmLeCtlData              = -161;
  dtyp_PmLeMargStruct           = -157;
  dtyp_PmLeOverflow             = -158;
  dtyp_POffset2b                = -112;
  dtyp_POwnerItem               = -154;
  dtyp_PPid                     = -92;
  dtyp_PPix                     = -156;
  dtyp_PPointerInfo             = -105;
  dtyp_PPointL                  = -77;
  dtyp_PProgCategory            = -129;
  dtyp_PProgramEntry            = -128;
  dtyp_PProgType                = -130;
  dtyp_PProperty2               = -88;
  dtyp_PProperty4               = -89;
  dtyp_PQMsg                    = -87;
  dtyp_PRectL                   = -121;
  dtyp_PResid                   = -125;
  dtyp_PRGB                     = -111;
  dtyp_PRgnRect                 = -115;
  dtyp_PSbcData                 = -159;
  dtyp_PSegOff                  = -126;
  dtyp_PShort                   = -23;
  dtyp_PSizeF                   = -101;
  dtyp_PSizeL                   = -102;
  dtyp_PStrL                    = -17;
  dtyp_PStr16                   = -40;
  dtyp_PStr32                   = -37;
  dtyp_PStr64                   = -47;
  dtyp_PStr8                    = -33;
  dtyp_PSwBlock                 = -63;
  dtyp_PSwCntrl                 = -64;
  dtyp_PSwEntry                 = -65;
  dtyp_PSwp                     = -31;
  dtyp_PTid                     = -104;
  dtyp_PTime                    = -107;
  dtyp_PTrackInfo               = -73;
  dtyp_PUChar                   = -22;
  dtyp_PULong                   = -26;
  dtyp_PUserButton              = -36;
  dtyp_PUShort                  = -24;
  dtyp_PWidth4                  = -108;
  dtyp_PWndParams               = -83;
  dtyp_PWndProc                 = -84;
  dtyp_PWPoint                  = -59;
  dtyp_PWRect                   = -55;
  dtyp_PxyWinSize               = -52;

{----[ PMSTDDLG ]----}

{---------------[ F I L E    D I A L O G ]----------------}

{ File Dialog Invocation Flag Definitions }
const
  fds_Center                    = $00000001; { Center within owner wnd   }
  fds_Custom                    = $00000002; { Use custom user template  }
  fds_FilterUnion               = $00000004; { Use union of filters      }
  fds_HelpButton                = $00000008; { Display Help button       }
  fds_ApplyButton               = $00000010; { Display Apply button      }
  fds_Preload_VolInfo           = $00000020; { Preload volume info       }
  fds_ModeLess                  = $00000040; { Make dialog modeless      }
  fds_Include_Eas               = $00000080; { Always load EA info       }
  fds_Open_Dialog               = $00000100; { Select Open dialog        }
  fds_Saveas_Dialog             = $00000200; { Select SaveAs dialog      }
  fds_MultipleSel               = $00000400; { Enable multiple selection }
  fds_EnableFileLb              = $00000800; { Enable SaveAs Listbox     }
{ File Dialog Selection returned attribute }
  fds_EfSelection               = 0;
  fds_LbSelection               = 1;
{ Error Return Codes from dialog (self defining) }
  fds_Successful                = 0;
  fds_Err_Deallocate_Memory     = 1;
  fds_Err_Filter_Trunc          = 2;
  fds_Err_Invalid_Dialog        = 3;
  fds_Err_Invalid_Drive         = 4;
  fds_Err_Invalid_Filter        = 5;
  fds_Err_Invalid_PathFile      = 6;
  fds_Err_Out_Of_Memory         = 7;
  fds_Err_Path_Too_Long         = 8;
  fds_Err_Too_Many_File_Types   = 9;
  fds_Err_Invalid_Version       = 10;
  fds_Err_Invalid_Custom_Handle = 11;
  fds_Err_Dialog_Load_Error     = 12;
  fds_Err_Drive_Error           = 13;
{ File Dialog Messages }
  fdm_Filter                    = wm_User+40; { mp1 = PChar pszFileName}
  {                                      mp2 = Chap EA .TYPE value     }
  {                                      mr  = True -> keep file.      }
  fdm_Validate                  = wm_User+41; { mp1 = PChar pszPathName}
  {                                      mp2 = Word Field name id      }
  {                                      mr  = True -> Valid name      }
  fdm_Error                     = wm_User+42; { mp1 = Word Error message id }
  {                                      mp2 = nil   reserved          }
  {                                      mr  = nil -> Use default msg  }

  { Define the type that is a pointer to an array of pointers.         }
  {     Hence: pointer to an array of Z string pointers.               }
type
   PApSz = ^ApSz;
   ApSz  = array[0..1*1024*1024] of PChar;

  { File Dialog application data record }
   PFileDlg = ^FileDlg;
   FileDlg = record
     cbSize:          ULong;     { Size of FileDlg record.            }
     fl:              ULong;     { fds_ flags. Alter behavior of dlg. }
     ulUser:          ULong;     { User defined field.                }
     lReturn:         Long;      { Result code from dialog dismissal. }
     lSRC:            Long;      { System return code.                }
     pszTitle:        PChar;     { String to display in title bar.    }
     pszOKButton:     PChar;     { String to display in OK button.    }
     pfnDlgProc:      FnWp;      { Entry point to custom dialog proc. }
     pszIType:        PChar;     { Pointer to string containing       }
                                 {   initial EA type filter. Type     }
                                 {   does not have to exist in list.  }
     papszITypeList:  PApSz;     { Pointer to table of pointers that  }
                                 {    point to null terminated Type   }
                                 {    strings. End of table is marked }
                                 {    by a nil pointer.               }
     pszIDrive:       PChar;     { Pointer to string containing       }
                                 {   initial drive. Drive does not    }
                                 {   have to exist in drive list.     }
     papszIDriveList: PApSz;     { Pointer to table of pointers that  }
                                 {    point to null terminated Drive  }
                                 {    strings. End of table is marked }
                                 {    by a nil pointer.               }
     hMod:             HModule;  { Custom File Dialog template.       }
     szFullFile: array[0..cchMaxPath-1] of Char;{ Initial or selected }
                                 { fully qualified path and file.     }
     papszFQFilename:  PApSz;    { Pointer to table of pointers that  }
                                 {    point to null terminated FQFname}
                                 {    strings. End of table is marked }
                                 {    by a nil pointer.               }
     ulFQFCount:       ULong;    { Number of files selected           }
     usDlgId:          Word;     { Custom dialog id.                  }
     x:                SmallInt;  { X coordinate of the dialog         }
     y:                SmallInt;  { Y coordinate of the dialog         }
     sEAType:          SmallInt;  { Selected file's EA Type.           }
   end;

{ File Dialog functions }

function WinFileDlg conv arg_os2_16 (WndP,WndO: HWnd; var fild: FileDlg): HWnd; external 'PMSTDDLG' index ord_WinFileDlg;
function WinDefFileDlgProc conv arg_os2_16 (Wnd: HWnd; Msg: ULong; Mp1,Mp2: MParam): MResult; external 'PMSTDDLG' index ord_WinDefFileDlgProc;
function WinFreeFileDlgList conv arg_os2_16 (papszFQFilename: PApSz): Bool; external 'PMSTDDLG' index ord_WinFreeFileDlgList;

{ File Dialog - dialog and control ids }
const
  did_File_Dialog               = 256;
  did_Filename_Txt              = 257;
  did_Filename_Ed               = 258;
  did_Drive_Txt                 = 259;
  did_Drive_Cb                  = 260;
  did_Filter_Txt                = 261;
  did_Filter_Cb                 = 262;
  did_Directory_Txt             = 263;
  did_Directory_Lb              = 264;
  did_Files_Txt                 = 265;
  did_Files_Lb                  = 266;
  did_Help_Pb                   = 267;
  did_Apply_Pb                  = 268;
  did_Ok_Pb                     = did_Ok;
  did_Cancel_Pb                 = did_Cancel;

  ids_File_All_Files_Selector   = 1000;
  ids_File_Back_Cur_Path        = 1001;
  ids_File_Back_Prev_Path       = 1002;
  ids_File_Back_Slash           = 1003;
  ids_File_Base_Filter          = 1004;
  ids_File_Blank                = 1005;
  ids_File_Colon                = 1006;
  ids_File_Dot                  = 1007;
  ids_File_Drive_Letters        = 1008;
  ids_File_Fwd_Cur_Path         = 1009;
  ids_File_Fwd_Prev_Path        = 1010;
  ids_File_Forward_Slash        = 1011;
  ids_File_Parent_Dir           = 1012;
  ids_File_Q_Mark               = 1013;
  ids_File_Splat                = 1014;
  ids_File_Splat_Dot            = 1015;
  ids_File_SaveAs_Title         = 1016;
  ids_File_SaveAs_Filter_Txt    = 1017;
  ids_File_SaveAs_FileNm_Txt    = 1018;
  ids_File_Dummy_File_Name      = 1019;
  ids_File_Dummy_File_Ext       = 1020;
  ids_File_Dummy_Drive          = 1021;
  ids_File_Dummy_Root_Dir       = 1022;
  ids_File_Path_Ptr             = 1023;
  ids_File_Volume_Prefix        = 1024;
  ids_File_Volume_Suffix        = 1025;
  ids_File_Path_Ptr2            = 1026;
  ids_File_Invalid_Chars        = 1027;

  ids_File_Bad_Drive_Name       = 1100;
  ids_File_Bad_Drive_Or_Path_Name = 1101;
  ids_File_Bad_File_Name        = 1102;
  ids_File_Bad_Fqf              = 1103;
  ids_File_Bad_Network_Name     = 1104;
  ids_File_Bad_Sub_Dir_Name     = 1105;
  ids_File_Drive_Not_Available  = 1106;
  ids_File_Fqfname_Too_Long     = 1107;
  ids_File_Open_Dialog_Note     = 1108;
  ids_File_Path_Too_Long        = 1109;
  ids_File_SaveAs_Dialog_Note   = 1110;

  ids_File_Drive_Disk_Change    = 1120;
  ids_File_Drive_Not_Ready      = 1122;
  ids_File_Drive_Locked         = 1123;
  ids_File_Drive_No_Sector      = 1124;
  ids_File_Drive_Some_Error     = 1125;
  ids_File_Drive_Invalid        = 1126;
  ids_File_Insert_Disk_Note     = 1127;
  ids_File_Ok_When_Ready        = 1128;

{---------------[ F O N T    D I A L O G ]----------------}

{ Font Dialog Creation record }
type
  PFontDlg = ^FontDlg;
  FontDlg = record
    cbSize:            ULong;      { SizeOf(FontDlg)                 }
    hpsScreen:         Hps;        { Screen presentation space       }
    hpsPrinter:        Hps;        { Printer presentation space      }
    pszTitle:          PChar;      { Application supplied title      }
    pszPreview:        PChar;      { String to print in preview wndw }
    pszPtSizeList:     PChar;      { Application provided size list  }
    pfnDlgProc:        FnWp;       { Dialog subclass procedure       }
    pszFamilyname:     PChar;      { Family name of font             }
    fxPointSize:       Fixed;      { Point size the user selected    }
    fl:                ULong;      { fnts_* flags - dialog styles    }
    flFlags:           ULong;      { fntf_* state flags              }
    flType:            ULong;      { Font type option bits           }
    flTypeMask:        ULong;      { Mask of which font types to use }
    flStyle:           ULong;      { The selected style bits         }
    flStyleMask:       ULong;      { Mask of which style bits to use }
    clrFore:           Long;       { Selected foreground color       }
    clrBack:           Long;       { Selected background color       }
    ulUser:            ULong;      { Blank field for application     }
    lReturn:           Long;       { Return Value of the Dialog      }
    lSRC:              Long;       { System return code.             }
    lEmHeight:         Long;       { Em height of the current font   }
    lXHeight:          Long;       { X height of the current font    }
    lExternalLeading:  Long;       { External Leading of font        }
    hMod:              HModule;    { Module to load custom template  }
    fAttrs:            FAttrs;     { Font attribute record           }
    sNominalPointSize: Word;       { Nominal Point Size of font      }
    usWeight:          Word;       { The boldness of the font        }
    usWidth:           Word;       { The width of the font           }
    x:                 SmallInt;    { X coordinate of the dialog      }
    y:                 SmallInt;    { Y coordinate of the dialog      }
    usDlgId:           Word;       { ID of a custom dialog template  }
    usFamilyBufLen:    Word;       { Length of family buffer provided}
    usReserved:        Word;       { reserved                        }
  end;

{ Font Dialog Style Flags }
const
  fnts_Center                   = $00000001; { Center in owner dialog}
  fnts_Custom                   = $00000002; { Use custom template   }
  fnts_OwnerDrawPreview         = $00000004; { Allow app to draw     }
  fnts_HelpButton               = $00000008; { Display Help button   }
  fnts_ApplyButton              = $00000010; { Display Apply button  }
  fnts_ResetButton              = $00000020; { Display Reset button  }
  fnts_Modeless                 = $00000040; { Make dialog modeless  }
  fnts_InitFromFAttrs           = $00000080; { Initialize from FATTRs}
  fnts_BitmapOnly               = $00000100; { Only allow bitmap font}
  fnts_VectorOnly               = $00000200; { Only allow vector font}
  fnts_FixedWidthOnly           = $00000400; { Only allow monospaced }
  fnts_ProportionalOnly         = $00000800; { Only proportional font}
  fnts_NoSynthesizedFonts       = $00001000; { Don't synthesize fonts}
{ Font Dialog Flags }
  fntf_NoViewScreenFonts        = 1;
  fntf_NoViewPrinterFonts       = 2;
  fntf_ScreenFontSelected       = 4;
  fntf_PrinterFontSelected      = 8;
{ Color code definitions }
  clrc_Foreground               = 1;
  clrc_Background               = 2;
{ Filter List message string identifiers }
  fnti_BitmapFont               = $0001;
  fnti_VectorFont               = $0002;
  fnti_FixedWidthFont           = $0004;
  fnti_ProportionalFont         = $0008;
  fnti_Synthesized              = $0010;
  fnti_DefaultList              = $0020;
  fnti_FamilyName               = $0100;
  fnti_StyleName                = $0200;
  fnti_PointSize                = $0400;
{ Error Return Codes from dialog (self defining) }
  fnts_Successful               = 0;
  fnts_Err_Invalid_Dialog       = 3;
  fnts_Err_Alloc_Shared_Mem     = 4;
  fnts_Err_Invalid_Parm         = 5;
  fnts_Err_Out_Of_Memory        = 7;
  fnts_Err_Invalid_Version      = 10;
  fnts_Err_Dialog_Load_Error    = 12;
{ Font Dialog Messages }
  fntm_FaceNameChanged          = wm_User+50; { mp1 = PChar pszFacename   }
  fntm_PointSizeChanged         = wm_User+51; { mp1 = PChar pszPointSize, }
                                              { mp2 = Fixed fxPointSize   }
  fntm_StyleChanged             = wm_User+52; { mp1 = PStyleChange pstyc  }
  fntm_ColorChanged             = wm_User+53; { mp1 = Long clr            }
                                              { mp2 = Word codeClr        }
  fntm_UpdatePreview            = wm_User+54; { mp1 = HWnd HWndPreview    }
  fntm_FilterList               = wm_User+55; { mp1 = PChar pszFacename   }
                                              { mp2 = Word usStrStyle     }
                                              { mr=True(Add),False(Dont)  }
{ StyleChange message parameter record }
type
  PStyleChange = ^StyleChange;
  StyleChange = record
    usWeight:       Word;
    usWeightOld:    Word;
    usWidth:        Word;
    usWidthOld:     Word;
    flType:         ULong;
    flTypeOld:      ULong;
    flTypeMask:     ULong;
    flTypeMaskOld:  ULong;
    flStyle:        ULong;
    flStyleOld:     ULong;
    flStyleMask:    ULong;
    flStyleMaskOld: ULong;
  end;

{ Font Dialog functions }

function WinFontDlg conv arg_os2_16 (WndP,WndO: HWnd; var fntd: FontDlg): HWnd;               external 'PMSTDDLG' index ord_WinFontDlg;
function WinDefFontDlgProc conv arg_os2_16 (Wnd: HWnd; Msg: ULong; Mp1,Mp2: MParam): MResult; external 'PMSTDDLG' index ord_WinFontDlg;


{ font dialog and control id's }
const
  did_Font_Dialog               = 300;
  did_Name                      = 301;
  did_Style                     = 302;
  did_Display_Filter            = 303;
  did_Printer_Filter            = 304;
  did_Size                      = 305;
  did_Sample                    = 306;
  did_Outline                   = 307;
  did_Underscore                = 308;
  did_Strikeout                 = 309;
  did_Help_Button               = 310;
  did_Apply_Button              = 311;
  did_Reset_Button              = 312;
  did_Ok_Button                 = did_OK;
  did_Cancel_Button             = did_Cancel;
  did_Name_Prefix               = 313;
  did_Style_Prefix              = 314;
  did_Size_Prefix               = 315;
  did_Sample_Groupbox           = 316;
  did_Emphasis_Groupbox         = 317;
{ stringtable id's }
  ids_Font_Sample               = 350;
  ids_Font_Blank                = 351;
  ids_Font_Key_0                = 352;
  ids_Font_Key_9                = 353;
  ids_Font_Key_Sep              = 354;
  ids_Font_Disp_Only            = 355;
  ids_Font_Printer_Only         = 356;
  ids_Font_Combined             = 357;
  ids_Font_Weight1              = 358;
  ids_Font_Weight2              = 359;
  ids_Font_Weight3              = 360;
  ids_Font_Weight4              = 361;
  ids_Font_Weight5              = 362;
  ids_Font_Weight6              = 363;
  ids_Font_Weight7              = 364;
  ids_Font_Weight8              = 365;
  ids_Font_Weight9              = 366;
  ids_Font_Width1               = 367;
  ids_Font_Width2               = 368;
  ids_Font_Width3               = 369;
  ids_Font_Width4               = 370;
  ids_Font_Width5               = 371;
  ids_Font_Width6               = 372;
  ids_Font_Width7               = 373;
  ids_Font_Width8               = 374;
  ids_Font_Width9               = 375;
  ids_Font_Option0              = 376;
  ids_Font_Option1              = 377;
  ids_Font_Option2              = 378;
  ids_Font_Option3              = 379;
  ids_Font_Point_Size_List      = 380;

{---------------[ S P I N    B U T T O N ]----------------}

{ SPINBUTTON Creation Flags }
const
{ Character Acceptance      }
  spbs_AllCharActers            = $00000000; { Default: All chars accepted }
  spbs_NumericOnly              = $00000001; { Only 0 - 9 accepted & VKeys }
  spbs_ReadOnly                 = $00000002; { No chars allowed in entryfld}
{ Type of Component }
  spbs_Master                   = $00000010;
  spbs_Servant                  = $00000000; { Default: Servant            }
{ Type of Justification }
  spbs_JustDefault              = $00000000; { Default: Same as Left       }
  spbs_JustLeft                 = $00000008;
  spbs_JustRight                = $00000004;
  spbs_JustCenter               = $0000000C;
{ Border or not }
  spbs_NoBorder                 = $00000020; { Borderless SpinField        }
                                             { Default is to have a border }
{ Fast spin or not }
  spbs_FastSpin                 = $00000100; { Allow fast spinning.  Fast  }
                                             { spinning is performed by    }
                                             { skipping over numbers       }
{ Pad numbers on front with 0's }
  spbs_PadWithZeros             = $00000080; { Pad the number with zeroes  }

{ SPINBUTTON Messages }
{ Notification from Spinbutton to the application is sent in a }
{ wm_Control message.                                          }
  spbn_UpArrow                  = $20A;      { up arrow button was pressed  }
  spbn_DownArrow                = $20B;      { down arrow button was pressed}
  spbn_EndSpin                  = $20C;      { mouse button was released    }
  spbn_Change                   = $20D;      { spinfield text has changed   }
  spbn_SetFocus                 = $20E;      { spinfield received focus     }
  spbn_KillFocus                = $20F;      { spinfield lost focus         }
{ Messages from application to Spinbutton }
  spbm_OverrideSetLimits        = $200; { Set spinbutton limits without }
                                        {   resetting the current value }
  spbm_QueryLimits              = $201; { Query limits set by           }
                                        {   spbm_SetLimits              }
  spbm_SetTextLimit             = $202; { Max entryfield characters     }
  spbm_SpinUp                   = $203; { Tell entry field to spin up   }
  spbm_SpinDown                 = $204; { Tell entry field to spin down }
  spbm_QueryValue               = $205; { Tell entry field to send      }
                                        { current value                 }
{ Query Flags }
  spbq_UpdateIfValid            = 0;    { Default                       }
  spbq_AlwaysUpdate             = 1;
  spbq_DoNotUpdate              = 3;

{ Return value for Empty Field }
{ If ptr too Long, variable sent in query msg }
  spbm_SetArray                 = $206; { Change the data to spin      }
  spbm_SetLimits                = $207; { Change the numeric Limits    }
  spbm_SetCurrentValue          = $208; { Change the current value     }
  spbm_SetMaster                = $209; { Tell entryfield who master is}

{---------------[ DIRECT MANIPULATION ]-------------------}

  pmerr_Not_Dragging            = $1F00;
  pmerr_Already_Dragging        = $1F01;

  msgf_Drag                     = $0010    { message filter identifier };

  wm_DragFirst                  = $0310;
  wm_DragLast                   = $032F;

  dm_Drop                       = $032F;
  dm_DragOver                   = $032E;
  dm_DragLeave                  = $032D;
  dm_DropHelp                   = $032C;
  dm_EndConversation            = $032B;
  dm_Print                      = $032A;
  dm_Render                     = $0329;
  dm_RenderComplete             = $0328;
  dm_RenderPrepare              = $0327;
  dm_DragFileComplete           = $0326;
  dm_EmphasizeTarget            = $0325;
  dm_DragError                  = $0324;
  dm_FileRendered               = $0323;
  dm_RenderFile                 = $0322;
  dm_DragOverNotify             = $0321;
  dm_PrintObject                = $0320;
  dm_DiscardObject              = $031F;

  drt_Asm                       = 'Assembler Code';  { drag type constants  }
  drt_Basic                     = 'BASIC Code';
  drt_BinData                   = 'Binary Data';
  drt_Bitmap                    = 'Bitmap';
  drt_C                         = 'C Code';
  drt_Cobol                     = 'COBOL Code';
  drt_Dll                       = 'Dynamic Link Library';
  drt_DosCmd                    = 'DOS Command File';
  drt_Exe                       = 'Executable';
  drt_Fortran                   = 'FORTRAN Code';
  drt_Icon                      = 'Icon';
  drt_Lib                       = 'Library';
  drt_MetaFile                  = 'Metafile';
  drt_Os2Cmd                    = 'OS/2 Command File';
  drt_Pascal                    = 'Pascal Code';
  drt_Resource                  = 'Resource File';
  drt_Text                      = 'Plain Text';
  drt_Unknown                   = 'Unknown';

  dor_NoDrop                    = $0000;  { dm_DragOver response codes }
  dor_Drop                      = $0001;
  dor_NoDropOp                  = $0002;
  dor_NeverDrop                 = $0003;

  do_Copyable                   = $0001;  { supported operation flags  }
  do_Moveable                   = $0002;
  do_Linkable                   = $0004;

  dc_Open                       = $0001;  { source control flags       }
  dc_Ref                        = $0002;
  dc_Group                      = $0004;
  dc_Container                  = $0008;
  dc_Prepare                    = $0010;
  dc_RemoveableMedia            = $0020;

  do_Default                    = $BFFE;  { Default operation          }
  do_Unknown                    = $BFFF;  { Unknown operation          }
  do_Copy                       = $0010;
  do_Move                       = $0020;
  do_Link                       = $0018;
  do_Create                     = $0040;

  dmfl_TargetSuccessful         = $0001;  { transfer reply flags       }
  dmfl_TargetFail               = $0002;
  dmfl_NativeRender             = $0004;
  dmfl_RenderRetry              = $0008;
  dmfl_RenderOk                 = $0010;
  dmfl_RenderFail               = $0020;

  drg_Icon                      = $00000001;    { drag image manipulation    }
  drg_Bitmap                    = $00000002;    {   flags                    }
  drg_Polygon                   = $00000004;
  drg_Stretch                   = $00000008;
  drg_Transparent               = $00000010;
  drg_Closed                    = $00000020;

  dme_IgnoreAbort               = 1;            { dm_DragError return values }
  dme_IgnoreContinue            = 2;
  dme_Replace                   = 3;
  dme_Retry                     = 4;

  df_Move                       = $0001;        { dm_DragFileComplete flags  }
  df_Source                     = $0002;
  df_Successful                 = $0004;

  drr_Source                    = 1;
  drr_Target                    = 2;
  drr_Abort                     = 3;

  dff_Move                      = 1;            { dm_DragError operation IDs }
  dff_Copy                      = 2;
  dff_Delete                    = 3;

type
  HStr = LHandle;
  PDragItem = ^DragItem;
  DragItem = record
    hWndItem:          HWnd;           { conversation partner          }
    ulItemID:          ULong;          { identifies item being dragged }
    HStrType:          HStr;           { type of item                  }
    HStrRMF:           HStr;           { rendering mechanism and format}
    HStrContainerName: HStr;           { name of source container      }
    HStrSourceName:    HStr;           { name of item at source        }
    HStrTargetName:    HStr;           { suggested name of item at dest}
    cxOffset:          SmallInt;        { x offset of the origin of the }
                                       {   image from the mouse hotspot}
    cyOffset:          SmallInt;        { y offset of the origin of the }
                                       {   image from the mouse hotspot}
    fsControl:         Word;           { source item control flags     }
    fsSupportedOps:    Word;           { ops supported by source       }
  end;

  PDragInfo = ^DragInfo;
  DragInfo = record
    cbDraginfo:  ULong;                { Size of DragInfo and DragItems}
    cbDragitem:  Word;                 { size of DragItem              }
    usOperation: Word;                 { current drag operation        }
    hWndSource:  HWnd;                 { window handle of source       }
    xDrop:       SmallInt;              { x coordinate of drop position }
    yDrop:       SmallInt;              { y coordinate of drop position }
    cditem:      Word;                 { count of DragItems            }
    usReserved:  Word;                 { reserved for future use       }
  end;

  PDragImage = ^DragImage;
  DragImage = record
    cb:          Word;                 { size control block            }
    cptl:        Word;                 { count of pts, if drg_Polygon  }
    hImage:      LHandle;              { image handle passed to DrgDrag}
    sizlStretch: SizeL;                { size to strecth ico or bmp to }
    fl:          ULong;                { flags passed to DrgDrag       }
    cxOffset:    SmallInt;             { x offset of the origin of the }
                                       {   image from the mouse hotspot}
    cyOffset:    SmallInt;             { y offset of the origin of the }
  end;                                 {   image from the mouse hotspot}

  PDragTransfer = ^DragTransfer;
  DragTransfer = record
    cb:               ULong;           { size of control block         }
    hWndClient:       HWnd;            { handle of target              }
    pditem:           PDragItem;       { DragItem being transferred    }
    HStrSelectedRMF:  HStr;            { rendering mech & fmt of choice}
    HStrRenderToName: HStr;            { name source will use          }
    ulTargetInfo:     ULong;           { reserved for target's use     }
    usOperation:      Word;            { operation being performed     }
    fsReply:          Word;            { reply flags                   }
  end;

  PRenderFile = ^RenderFile;
  RenderFile = record
    hWndDragFiles: HWnd;               { conversation window           }
    HStrSource:    HStr;               { handle to source file name    }
    HStrTarget:    HStr;               { handle to target file name    }
    fMove:         Word;               { True - move, False - copy     }
    usRsvd:        Word;               { reserved                      }
  end;

function DrgAcceptDroppedFiles conv arg_os2 (Wnd: HWnd; Path,Types: PChar;
  DefaultOp,Reserved: ULong): Bool; external 'PMDRAG' index ord_DrgAcceptDroppedFiles;
function DrgAllocDraginfo conv arg_os2 (cditem: ULong): PDragInfo; external 'PMDRAG' index ord_DrgAllocDragInfo;
function DrgAllocDragtransfer conv arg_os2 (cdxfer: ULong): PDragTransfer; external 'PMDRAG' index ord_DrgAllocDragTransfer;
function DrgDrag conv arg_os2 (Source: HWnd; var dinfo: DragInfo; var dimg: DragImage;
  cdimg: ULong; vkTerminate: Long; Reserved: Pointer): HWnd; external 'PMDRAG' index ord_DrgDrag;
function DrgDragFiles conv arg_os2 (Wnd: HWnd; var apszFiles,apszTypes,apszTargets: PChar;
  cFiles: ULong; hptrDrag: HPointer; vkTerm: ULong; fSourceRender: Bool; Reserved: ULong): Bool; external 'PMDRAG' index ord_DrgDragFiles;
function DrgPostTransferMsg conv arg_os2 (Wnd: HWnd; Msg: ULong; var dxfer: DragTransfer;
  fl,Reserved: ULong; fRetry: Bool): Bool; external 'PMDRAG' index ord_DrgPostTransferMsg;
function DrgQueryDragitem conv arg_os2 (var dinfo: DragInfo; cbBuffer: ULong; var ditem: DragItem;
  iItem: ULong): Bool; external 'PMDRAG' index ord_DrgQueryDragItem;
function DrgQueryDragitemCount conv arg_os2 (var dinfo: DragInfo): ULong; external 'PMDRAG' index ord_DrgQueryDragItemCount;
function DrgQueryDragitemPtr conv arg_os2 (var dinfo: DragInfo; I: ULong): PDragItem; external 'PMDRAG' index ord_DrgQueryDragItemPtr;
function DrgQueryNativeRMF conv arg_os2 (var ditem: DragItem; cbBuffer: ULong; var Buffer): Bool; external 'PMDRAG' index ord_DrgQueryNativeRMF;
function DrgQueryNativeRMFLen conv arg_os2 (var ditem: DragItem): ULong; external 'PMDRAG' index ord_DrgQueryNativeRMFLen;
function DrgQueryStrName conv arg_os2 (Str: HStr; cbBuffer: ULong; Buffer: PChar): ULong; external 'PMDRAG' index ord_DrgQueryStrName;
function DrgQueryStrNameLen conv arg_os2 (Str: HStr): ULong; external 'PMDRAG' index ord_DrgQueryStrNameLen;
function DrgQueryTrueType conv arg_os2 (var ditem: DragItem; cbBuffer: ULong; Buffer: PChar): Bool; external 'PMDRAG' index ord_DrgQueryTrueType;
function DrgQueryTrueTypeLen conv arg_os2 (var ditem: DragItem): ULong; external 'PMDRAG' index ord_DrgQueryTrueTypeLen;
function DrgSendTransferMsg conv arg_os2 (Wnd: HWnd; Msg: ULong; Mp1,Mp2: MParam): MResult; external 'PMDRAG' index ord_DrgSendTransferMsg;
function DrgSetDragitem conv arg_os2 (var dinfo: DragInfo; var ditem: DragItem;
  cbBuffer,iItem: ULong): Bool; external 'PMDRAG' index ord_DrgSetDragItem;
function DrgSetDragImage conv arg_os2 (var dinfo: DragInfo; var dimg: DragImage; cdimg: ULong;
  Reserved: Pointer): Bool; external 'PMDRAG' index ord_DrgSetDragImage;
function DrgVerifyTypeSet conv arg_os2 (var ditem: DragItem; pszType: PChar; cbMatch: ULong;
  pszMatch: PChar): Bool; external 'PMDRAG' index ord_DrgVerifyTypeSet;
function DrgAccessDraginfo conv arg_os2 (var dinfo: DragInfo): Bool; external 'PMDRAG' index ord_DrgAccessDragInfo;
function DrgAddStrHandle conv arg_os2 (P: PChar): HStr; external 'PMDRAG' index ord_DrgAddStrHandle;
function DrgDeleteDraginfoStrHandles conv arg_os2 (var dinfo: DragInfo): Bool; external 'PMDRAG' index ord_DrgDeleteDragInfoStrHandles;
function DrgDeleteStrHandle conv arg_os2 (Str: HStr): Bool; external 'PMDRAG' index ord_DrgDeleteStrHandle;
function DrgFreeDraginfo conv arg_os2 (var dinfo: DragInfo): Bool; external 'PMDRAG' index ord_DrgFreeDragInfo;
function DrgFreeDragtransfer conv arg_os2 (var dxfer: DragTransfer): Bool; external 'PMDRAG' index ord_DrgFreeDragTransfer;
function DrgGetPS conv arg_os2 (Wnd: HWnd): Hps; external 'PMDRAG' index ord_DrgGetPS;
function DrgPushDraginfo conv arg_os2 (var dinfo: DragInfo; WndDest: HWnd): Bool; external 'PMDRAG' index ord_DrgPushDragInfo;
function DrgReleasePS conv arg_os2 (PS: Hps): Bool; external 'PMDRAG' index ord_DrgReleasePS;
function DrgSetDragPointer conv arg_os2 (var dinfo: DragInfo; hptr: HPointer): Bool; external 'PMDRAG' index ord_DrgSetDragPointer;
function DrgVerifyNativeRMF conv arg_os2 (var ditem: DragItem; pszRMF: PChar): Bool; external 'PMDRAG' index ord_DrgVerifyNativeRMF;
function DrgVerifyRMF conv arg_os2 (var ditem: DragItem; Mech,Fmt: PChar): Bool; external 'PMDRAG' index ord_DrgVerifyRMF;
function DrgVerifyTrueType conv arg_os2 (var ditem: DragItem; pszType: PChar): Bool; external 'PMDRAG' index ord_DrgVerifyTrueType;
function DrgVerifyType conv arg_os2 (var ditem: DragItem; pszType: PChar): Bool; external 'PMDRAG' index ord_DrgVerifyType;

{---------------[ C O N T A I N E R ]---------------------}

const
{ Error constants }
  pmerr_Nofiltered_Items        = $1F02;
  pmerr_Comparison_Failed       = $1F03;
  pmerr_Record_Currently_Inserted = $1F04;
  pmerr_Fi_Currently_Inserted   = $1F05;
{ Container control styles }
  ccs_ExtendSel                 = $00000001;
  ccs_MultipleSel               = $00000002;
  ccs_SingleSel                 = $00000004;
  ccs_AutoPosition              = $00000008;
  ccs_VerifyPointers            = $00000010;
  ccs_ReadOnly                  = $00000020;
  ccs_MiniRecordCore            = $00000040;
{ view identifiers (flWindowAttr) }
  cv_Text                       = $00000001;  { text view            }
  cv_Name                       = $00000002;  { name view            }
  cv_Icon                       = $00000004;  { icon view            }
  cv_Detail                     = $00000008;  { detail view          }
  cv_Flow                       = $00000010;  { flow items           }
  cv_Mini                       = $00000020;  { use mini icon        }
  cv_Tree                       = $00000040;  { tree view            }
{ Container Attributes (flWindowAttr) }
  ca_ContainerTitle             = $00000200;
  ca_TitleSeparator             = $00000400;
  ca_TitleLeft                  = $00000800;
  ca_TitleRight                 = $00001000;
  ca_TitleCenter                = $00002000;
  ca_OwnerDraw                  = $00004000;
  ca_DetailsViewTitles          = $00008000;
  ca_OrderedTargetEmph          = $00010000;
  ca_DrawBitmap                 = $00020000;
  ca_DrawIcon                   = $00040000;
  ca_TitleReadOnly              = $00080000;
  ca_OwnerPaintBackground       = $00100000;
  ca_MixedTargetEmph            = $00200000;
  ca_TreeLine                   = $00400000;
{ child window IDs }
  cid_LeftColTitleWnd           = $7FF0;   { column title (left)       }
  cid_RightColTitleWnd          = $7FF1;   { right column title        }
  cid_BlankBox                  = $7FF2;   { blank box at bottom right }
  cid_HScroll                   = $7FF3;   { horizontal scroll bar     }
  cid_RighthScroll              = $7FF4;   { right horz scroll bar     }
  cid_CnrTitleWnd               = $7FF5;   { Container title window    }
  cid_LeftDvWnd                 = $7FF7;   { Left Details View window  }
  cid_RightDvWnd                = $7FF8;   { Right Details View window }
  cid_VScroll                   = $7FF9;   { vertical scroll bar       }
  cid_Mle                       = $7FFA;   { MLE window for direct edit}

{ Bitmap descriptor array element }

type
  PTreeItemDesc = ^TreeItemDesc;
  TreeItemDesc = record
    hbmExpanded:   HBitMap;
    hbmCollapsed:  HBitMap;
    hptrExpanded:  HPointer;
    hptrCollapsed: HPointer;
  end;

{ Field Info data record, attribute and data types, cv_Detail }

  PFieldInfo = ^FieldInfo;
  FieldInfo = record
    cb:           ULong;              { size of FieldInfo record         }
    flData:       ULong;              { attributes of field's data       }
    flTitle:      ULong;              { attributes of field's title      }
    pTitleData:   Pointer;            { title data (default is string)   }
                                      { If cft_Bitmap, must be HBitMap   }
    offStruct:    ULong;              { offset from RecordCore to data   }
    pUserData:    Pointer;            { pointer to user data             }
    pNextFieldInfo: PFieldInfo;       { pointer to next linked FieldInfo }
    cxWidth:      ULong;              { width of field in pels           }
  end;

{ RecordCore data record, attribute values }

  PRecordCore = ^RecordCore;
  RecordCore = record
    cb:              ULong;
    flRecordAttr:    ULong;            { record attributes                }
    ptlIcon:         PointL;           { Position of cv_Icon item         }
    preccNextRecord: PRecordCore;      { ptr to next record               }
    pszIcon:         PChar;            { Text for cv_Icon view            }
    hptrIcon:        HPointer;         { Icon to display for not cv_Mini  }
    hptrMiniIcon:    HPointer;         { Icon to display for cv_Mini      }
    hbmBitmap:       HBitMap;          { Bitmap to display for not cv_Mini}
    hbmMiniBitmap:   HBitMap;          { Bitmap to display for cv_Mini    }
    TreeItemDesc:    PTreeItemDesc;    { Icons for the tree view          }
    pszText:         PChar;            { Text for cv_Text view            }
    pszName:         PChar;            { Text for cv_Name view            }
    pszTree:         PChar;            { Text for cv_Tree view            }
  end;

{ MiniRecordCore data record, attribute values }

  PMiniRecordCore = ^MiniRecordCore;
  MiniRecordCore = record
    cb:              ULong;
    flRecordAttr:    ULong;          { record attributes              }
    ptlIcon:         PointL;         { Position of cv_Icon item       }
    preccNextRecord: PMiniRecordCore;{ ptr to next record             }
    pszIcon:         PChar;          { Text for cv_Icon view          }
    hptrIcon:        HPointer;       { Icon to display for not cv_Mini}
  end;

{ CnrInfo data record, describes the container control }

  PCnrInfo = ^CnrInfo;
  CnrInfo = record
    cb:                 ULong;       { size of CnrInfo record        }
    pSortRecord:        Pointer;     { ptr to sort function,         }
                                     { RecordCore                    }
    PFieldInfoLast:     PFieldInfo;  { pointer to last column in     }
                                     { left pane of a split window.  }
    PFieldInfoObject:   PFieldInfo;  { Pointer to a column to        }
                                     { represent an object.  This is }
                                     { the column which will receive }
                                     { IN-USE emphasis.              }
    pszCnrTitle:        PChar;       { text for container title. One }
                                     { string separated by line      }
                                     { separators for multi-lines    }
    flWindowAttr:       ULong;       { container attrs - cv_*, ca_*  }
    ptlOrigin:          PointL;      { lower-left origin in virtual  }
                                     {   coordinates. cv_Icon view   }
    cDelta:             ULong;       { Application defined threshold }
                                     {   or number of records from   }
                                     {   either end of the list.     }
    cRecords:           ULong;       { number of records in container}
    slBitmapOrIcon:     SizeL;       { size of bitmap in pels        }
    slTreeBitmapOrIcon: SizeL;       { size of tree bitmaps in pels  }
    hbmExpanded:        HBitMap;     { bitmap  for tree node         }
    hbmCollapsed:       HBitMap;     { bitmap  for tree node         }
    hptrExpanded:       HPointer;    { icon    for tree node         }
    hptrCollapsed:      HPointer;    { icon    for tree node         }
    cyLineSpacing:      Long;        { space between two rows        }
    cxTreeIndent:       Long;        { indent for children           }
    cxTreeLine:         Long;        { thickness of the Tree Line    }
    cFields:            ULong;       { number of fields  in container}
    xVertSplitbar:      Long;        { position relative to the      }
                                     {   container (cv_Detail): if   }
                                     {   $FFFF then unsplit          }
  end;

  PCDate = ^CDate;
  CDate = record
    day:   Byte;                     { current day               }
    month: Byte;                     { current month             }
    year:  Word;                     { current year              }
  end;

  PCTime = ^CTime;
  CTime = record
    hours:      Byte;                { current hour              }
    minutes:    Byte;                { current minute            }
    seconds:    Byte;                { current second            }
    ucReserved: Byte;                { reserved                  }
  end;

{ attribute and type values for flData and flTitle members of }
{ FieldInfo, cfa_ (attributes), cft_ (types)                  }
const
  cfa_Left                      = $00000001; { left align text            }
  cfa_Right                     = $00000002; { right align text           }
  cfa_Center                    = $00000004; { center text                }
  cfa_Top                       = $00000008; { top-align text             }
  cfa_VCenter                   = $00000010; { vertically center text     }
  cfa_Bottom                    = $00000020; { bottom-align text          }
  cfa_Invisible                 = $00000040; { Specify invisible column.  }
  cfa_BitmapOrIcon              = $00000100; { field title is bitmap      }
  cfa_Separator                 = $00000200; { vert sep, right of fld     }
  cfa_HorzSeparator             = $00000400; { horz sep, bottom of fld    }

  cfa_String                    = $00000800; { string of characters       }
  cfa_Owner                     = $00001000; { ownerdraw field            }
  cfa_Date                      = $00002000; { date record                }
  cfa_Time                      = $00004000; { time record                }
  cfa_FiReadOnly                = $00008000; { Column is read-only.       }
  cfa_FiTitleReadOnly           = $00010000; { Column Title is read-only  }
  cfa_ULong                     = $00020000; { Column is number format    }
{ attribute values for flRecordAttr member of RecordCore }
  cra_Selected                  = $00000001; { record is selected         }
  cra_Target                    = $00000002; { record has target emphasis }
  cra_Cursored                  = $00000004; { cursor is on the record    }
  cra_Inuse                     = $00000008; { record has in-use emphasis }
  cra_Filtered                  = $00000010; { record has been filtered   }
  cra_Droponable                = $00000020; { record can be dropped on   }
  cra_RecordReadOnly            = $00000040; { record is read-only        }
  cra_Expanded                  = $00000080; { record is expanded         }
  cra_Collapsed                 = $00000100; { record is collapsed        }

{ Container messages }
  cm_AllocDetailFieldInfo       = $0330;
  cm_AllocRecord                = $0331;
  cm_Arrange                    = $0332;
  cm_EraseRecord                = $0333;
  cm_Filter                     = $0334;
  cm_FreeDetailFieldInfo        = $0335;
  cm_FreeRecord                 = $0336;
  cm_HorzScrollSplitWindow      = $0337;
  cm_InsertDetailFieldInfo      = $0338;
  cm_InsertRecord               = $0339;
  cm_InvalidateDetailFieldInfo  = $033A;
  cm_InvalidateRecord           = $033B;
  cm_PaintBackground            = $033C;
  cm_QueryCnrInfo               = $033D;
  cm_QueryDetailFieldInfo       = $033E;
  cm_QueryDragImage             = $033F;
  cm_QueryRecord                = $0340;
  cm_QueryRecordEmphasis        = $0341;
  cm_QueryRecordFromRect        = $0342;
  cm_QueryRecordRect            = $0343;
  cm_QueryViewPortRect          = $0344;
  cm_RemoveDetailFieldInfo      = $0345;
  cm_RemoveRecord               = $0346;
  cm_ScrollWindow               = $0347;
  cm_SearchString               = $0348;
  cm_SetCnrInfo                 = $0349;
  cm_SetRecordEmphasis          = $034A;
  cm_SortRecord                 = $034B;
  cm_OpenEdit                   = $034C;
  cm_CloseEdit                  = $034D;
  cm_CollapseTree               = $034E;
  cm_ExpandTree                 = $034F;
  cm_QueryRecordInfo            = $0350;
{ Container notifications }
  cn_DragAfter                  = 101;
  cn_DragLeave                  = 102;
  cn_DragOver                   = 103;
  cn_Drop                       = 104;
  cn_DropHelp                   = 105;
  cn_Enter                      = 106;
  cn_InitDrag                   = 107;
  cn_Emphasis                   = 108;
  cn_KillFocus                  = 109;
  cn_Scroll                     = 110;
  cn_QueryDelta                 = 111;
  cn_SetFocus                   = 112;
  cn_ReallocPsz                 = 113;
  cn_BeginEdit                  = 114;
  cn_EndEdit                    = 115;
  cn_CollapseTree               = 116;
  cn_ExpandTree                 = 117;
  cn_Help                       = 118;
  cn_ContextMenu                = 119;

{ Data records for Message Parameters   }
{ Container Direct Manipulation records }
type
  PCnrDragInit = ^CnrDragInit;
  CnrDragInit = record
    hWndCnr: HWnd;                      { Container window handle   }
    pRecord: PRecordCore;               { record under mouse ptr    }
    x:       Long;                      { x coordinate of mouse ptr }
    y:       Long;                      { y coordinate of mouse ptr }
    cx:      Long;                      { x offset from record      }
    cy:      Long;                      { y offset from record      }
  end;

{ Data record for cm_insertDetailFieldInfo                       }
{ This record is used by the application to specify the position }
{ of the FieldInfo records they are inserting.                   }

  PFieldInfoInsert = ^FieldInfoInsert;
  FieldInfoInsert = record
    cb:                   ULong;        { Size of record.           }
    PFieldInfoOrder:      PFieldInfo;   { Specifies the order of the}
                                        {  FieldInfo records.       }
    fInvalidateFieldInfo: ULong;        { Invalidate on Insert.     }
    cFieldInfoInsert:     ULong;        { The number of FieldInfo   }
                                        { records to insert.        }
  end;

{ Data record for cm_InsertRecord }

  PRecordInsert = ^RecordInsert;
  RecordInsert = record
    cb:                ULong;
    pRecordOrder:      PRecordCore;
    pRecordParent:     PRecordCore;
    fInvalidateRecord: ULong;
    zOrder:            ULong;
    cRecordsInsert:    ULong;
  end;

{ Data record for cm_QueryRecordFromRect }

  PQueryRecFromRect = ^QueryRecFromRect;
  QueryRecFromRect = record
    cb:       ULong;
    rect:     RectL;
    fsSearch: ULong;
  end;

{ Data record for cm_QueryRecordRect }

  PQueryRecordRect = ^QueryRecordRect;
  QueryRecordRect = record
    cb:                ULong;
    pRecord:           PRecordCore;
    fRightSplitWindow: ULong;
    fsExtent:          ULong;
  end;

{ Data record for cm_SearchString }

  PSearchString = ^SearchString;
  SearchString = record
    cb:              ULong;
    pszSearch:       PChar;
    fsPrefix:        ULong;
    fsCaseSensitive: ULong;
    usView:          ULong;
  end;

  { Data record for cn_DragLeave,cn_DragOver,cn_Drop,cn_DropHelp }

  PCnrDragInfo = ^CnrDragInfo;
  CnrDragInfo = record
    PDragInfo: PDragInfo;
    pRecord:  PRecordCore;
  end;

{ Data record for cn_Emphasis }

  PNotifyRecordEmphasis = ^NotifyRecordEmphasis;
  NotifyRecordEmphasis = record
    hWndCnr:       HWnd;
    pRecord:       PRecordCore;
    fEmphasisMask: ULong;
  end;

{ Data record for cn_Enter }

  PNotifyRecordEnter = ^NotifyRecordEnter;
  NotifyRecordEnter = record
    hWndCnr: HWnd;
    fKey:    ULong;
    pRecord: PRecordCore;
  end;

{ Data record for cn_QueryDelta }

  PNotifyDelta = ^NotifyDelta;
  NotifyDelta = record
    hWndCnr: HWnd;
    fDelta:  ULong;
  end;

{ Data record for cn_Scroll }

  PNotifyScroll = ^NotifyScroll;
  NotifyScroll = record
    hWndCnr:    HWnd;
    lScrollInc: Long;
    fScroll:    ULong;
  end;

{ Data record for cn_ReallocPsz }

  PPChar = ^PChar;
  PCnrEditData = ^CnrEditData;
  CnrEditData = record
    cb:         ULong;
    hWndCnr:    HWnd;
    pRecord:    PRecordCore;
    PFieldInfo: PFieldInfo;
    ppszText:   PPChar;               { address of PChar      }
    cbText:     ULong;                { size of the new text  }
    id:         ULong;
  end;

{ Data record for cm_PaintBackground }

  POwnerBackground = ^OwnerBackground;
  OwnerBackground = record
    hWnd:          HWnd;
    Hps:           Hps;
    rclBackground: RectL;
    idWindow:      Long;
  end;

{ Data record used as part of wm_DragItem }

  PCnrDrawItemInfo = ^CnrDrawItemInfo;
  CnrDrawItemInfo = record
    pRecord:    PRecordCore;
    PFieldInfo: PFieldInfo;
  end;

{ Message parameter flags }
const
  cma_Top                       = $0001;      { Place at top of zorder   }
  cma_Bottom                    = $0002;      { Place at bottom of zorder}
  cma_Left                      = $0004;
  cma_Right                     = $0008;

  cma_First                     = $0010;      { Add record as first      }
  cma_Last                      = $0020;
  cma_End                       = $0040;      { Add record to end of list}
  cma_Prev                      = $0080;
  cma_Next                      = $0100;

  cma_Horizontal                = $0200;
  cma_Vertical                  = $0400;
  cma_Icon                      = $0800;
  cma_Text                      = $1000;
  cma_Partial                   = $2000;
  cma_Complete                  = $4000;

  cma_Parent                    = $0001;
  cma_FirstChild                = $0002;
  cma_LastChild                 = $0004;

  cma_CnrTitle                  = $0001;      { Container title          }
  cma_Delta                     = $0002;      { Application defined      }
  cma_FlWindowAttr              = $0004;      { Container attributes     }
  cma_LineSpacing               = $0008;
  cma_PFieldInfoLast            = $0010;      { Ptr to last column in    }

  cma_PSortRecord               = $0020;      { Pointer to sort function }
  cma_PtlOrigin                 = $0040;      { Lower left origin        }
  cma_SlBitmapOrIcon            = $0080;      { Size  of bitmap          }
  cma_XVertSplitBar             = $0100;      { Splitbar position        }
  cma_PFieldInfoObject          = $0200;      { Pointer to IN-USE        }
                                              {   emphasis column.       }

  cma_TreeIcon                  = $0400;      { Icon for tree node       }
  cma_TreeBitmap                = $0800;      { bitmap for tree node     }
  cma_CxTreeIndent              = $1000;      { indent for children      }
  cma_CxTreeLine                = $2000;      { thickness of tree line   }
  cma_SlTreeBitmapOrIcon        = $4000;      { size of icon of tree node}

  cma_ItemOrder                 = $0001;      { QueryRecord search flags }
  cma_Window                    = $0002;
  cma_Workspace                 = $0004;
  cma_ZOrder                    = $0008;

  cma_DeltaTop                  = $0001;      { Industrial - top delta   }
  cma_DeltaBot                  = $0002;      { Industrial - bottom delta}
  cma_DeltaHome                 = $0004;      { Industrial - top of list }
  cma_DeltaEnd                  = $0008;      { Industrial - end of list }

  cma_NoReposition              = $0001;      { InvalidateRecord flags   }
  cma_Reposition                = $0002;
  cma_TextChanged               = $0004;
  cma_Erase                     = $0008;

  cma_Free                      = $0001;
  cma_Invalidate                = $0002;

{---------------[ S L I D E R ]---------------------------}

{ Define messages for the slider control }
  slm_AddDetent                 = $0369;    { Add detent niche          }
  slm_QueryDetentPos            = $036A;    { Query position of detent  }
  slm_QueryScaleText            = $036B;    { Query text at tick number }
  slm_QuerySliderInfo           = $036C;    { Query slider information  }
  slm_QueryTickPos              = $036D;    { Query position of tick    }
  slm_QueryTickSize             = $036E;    { Query size of tick        }
  slm_RemoveDetent              = $036F;    { Remove detent niche       }
  slm_SetScaleText              = $0370;    { Set text above tick       }
  slm_SetSliderInfo             = $0371;    { Set slider parameters     }
  slm_SetTickSize               = $0372;    { Set size of tick          }
  sln_Change                    = 1;        { Slider position changed   }
  sln_SliderTrack               = 2;        { Slider dragged by user    }
  sln_SetFocus                  = 3;        { Slider gaining focus      }
  sln_KillFocus                 = 4;        { Slider losing focus       }

{ Slider control data record }
type
  PSldCData = ^SldCData;
  SldCData = record
    cbSize:             ULong;     { Size of control block             }
    usScale1Increments: Word;      { # of divisions on scale           }
    usScale1Spacing:    Word;      { Space in pels between increments  }
    usScale2Increments: Word;      { # of divisions on scale           }
    usScale2Spacing:    Word;      { Space in pels between increments  }
  end;

{ Slider control style flag definition }
const
  sls_Horizontal                = $00000000; { Orient slider horizontally}
  sls_Vertical                  = $00000001; { Orient slider vertically  }
  sls_Center                    = $00000000; { Center shaft in window    }
  sls_Bottom                    = $00000002; { Offset shaft to bottom (H)}
  sls_Top                       = $00000004; { Offset shaft to top (H)   }
  sls_Left                      = $00000002; { Offset shaft to left (V)  }
  sls_Right                     = $00000004; { Offset shaft to right (V) }
  sls_SnapToIncrement           = $00000008; { Snap to nearest increment }
  sls_ButtonsBottom             = $00000010; { Add buttons at shaft bot. }
  sls_ButtonStop                = $00000020; { Add buttons at shaft top  }
  sls_ButtonsLeft               = $00000010; { Add buttons left of shaft }
  sls_ButtonsRight              = $00000020; { Add buttons right of shaft}
  sls_OwnerDraw                 = $00000040; { Owner draw some fields    }
  sls_ReadOnly                  = $00000080; { Provide a read only slider}
  sls_RibbonStrip               = $00000100; { Provide a ribbon strip    }
  sls_HomeBottom                = $00000000; { Set home position at bot. }
  sls_HomeTop                   = $00000200; { Set home position at top  }
  sls_HomeLeft                  = $00000000; { Set home position at left }
  sls_HomeRight                 = $00000200; { Set home position at right}
  sls_PrimaryScale1             = $00000000; { Scale 1 is primary scale  }
  sls_PrimaryScale2             = $00000400; { Scale 2 is primary scale  }

{ Message attributes for setting and querying slider components }
  sma_Scale1                    = $0001;
  sma_Scale2                    = $0002;
  sma_ShaftDimensions           = $0000;
  sma_ShaftPosition             = $0001;
  sma_SliderArmDimensions       = $0002;
  sma_SliderArmPosition         = $0003;
  sma_RangeValue                = $0000;
  sma_IncrementValue            = $0001;
  sma_SetAllTicks               = $FFFF;

{ Ownerdraw flag definitions }
  sda_RibbonStrip               = $0001;
  sda_SliderShaft               = $0002;
  sda_Background                = $0003;
  sda_SliderArm                 = $0004;

{ Error return codes }
  pmerr_Update_In_Progress      = $1F06;
  slderr_Invalid_Parameters     = -1;

{---------------[ V A L U E   S E T ]---------------------}

{ Define messages for the value set control }
  vm_QueryItem                  = $0375;    { Query item at location    }
  vm_QueryItemAttr              = $0376;    { Query item attributes     }
  vm_QueryMetrics               = $0377;    { Query metrics of control  }
  vm_QuerySelectEdItem          = $0378;    { Query selected item       }
  vm_SelectItem                 = $0379;    { Set selected item         }
  vm_SetItem                    = $037A;    { Set item at location      }
  vm_SetItemAttr                = $037B;    { Set item attributes       }
  vm_SetMetrics                 = $037C;    { Set metrics of control    }

  vn_Select                     = 120;      { Item selected by user     }
  vn_Enter                      = 121;      { Item entered by user      }
  vn_DragLeave                  = 122;      { Drag left control         }
  vn_DragOver                   = 123;      { Drag is over item         }
  vn_Drop                       = 124;      { Drop occurred on item     }
  vn_DropHelp                   = 125;      { Request help for drop     }
  vn_InitDrag                   = 126;      { Drag initiated on item    }
  vn_SetFocus                   = 127;      { Value set gaining focus   }
  vn_KillFocus                  = 128;      { Value set losing focus    }
  vn_Help                       = 129;      { Help requested by user    }

{ Value set control data record }
type
  PVSCData = ^VSCData;
  VSCData = record
    cbSize:        ULong;          { Size of control block             }
    usRowCount:    Word;           { Number of rows in value set       }
    usColumnCount: Word;           { Number of columns in value set    }
  end;

{ Value set drag initialization record }

  PVSDragInit = ^VSDragInit;
  VSDragInit = record
    hWnd:     HWnd;                { Window handle of value set control}
    x:        Long;                { X coordinate of pointer on desktop}
    y:        Long;                { Y coordinate of pointer on desktop}
    cx:       Long;                { X offset from pointer hot spot    }
    cy:       Long;                { Y offset from pointer hot spot    }
    usRow:    Word;                { Number of rows in value set       }
    usColumn: Word;                { Number of columns in value set    }
  end;

{ Value set drag information record }
  PVSDragInfo = ^VSDragInfo;
  VSDragInfo = record
    PDragInfo: PDragInfo;          { Pointer to a drag info record     }
    usRow:     Word;               { Number of rows in value set       }
    usColumn:  Word;               { Number of columns in value set    }
  end;

{ Value set query item text record }

  PVSText = ^VSText;
  VSText = record
    pszItemText: PChar;            { Pointer to string for item text      }
    ulBufLen:    ULong;            { Length of buffer to copy string into }
  end;

{ Value set control style flag definition }
const
  vs_Bitmap                     = $0001;  { Default all items to bitmaps      }
  vs_Icon                       = $0002;  { Default all items to icons        }
  vs_Text                       = $0004;  { Default all items to text strings }
  vs_RGB                        = $0008;  { Default all items to color info   }
  vs_ColorIndex                 = $0010;  { Default all items to color indices}
  vs_Border                     = $0020;  { Add a border around the control   }
  vs_ItemBorder                 = $0040;  { Add a border around each item     }
  vs_ScaleBitmaps               = $0080;  { Scale bitmaps to cell size        }
  vs_RightToLeft                = $0100;  { Support right to left ordering    }
  vs_OwnerDraw                  = $0200;  { Owner draws value set background  }

{ Value set item attribute definition }
  via_Bitmap                    = $0001; { If set, item contains a bitmap    }
  via_Icon                      = $0002; { If set, item contains an icon     }
  via_Text                      = $0004; { If set, item contains text string }
  via_RGB                       = $0008; { If set, item contains color value }
  via_ColorIndex                = $0010; { If set, item contains color index }
  via_OwnerDraw                 = $0020; { If set, item is ownerdraw         }
  via_Disabled                  = $0040; { If set, item is unselectable      }
  via_Draggable                 = $0080; { If set, item can be source of drag}
  via_Droponable                = $0100; { If set, item can be target of drop}

{ Message parameter attributes for sizing and spacing of items }
  vma_ItemSize                  = $0001;
  vma_ItemSpacing               = $0002;

{ Ownerdraw flag definitions }
  vda_Item                      = $0001;
  vda_ItemBackground            = $0002;
  vda_Surrounding               = $0003;
  vda_Background                = $0004;

{ Error return codes }
  vserr_Invalid_Parameters      = -1;

{---------------[ N O T E B O O K ]-----------------------}

{ Message ids }
  bkm_CalcPageRect              = $0353; { Calc book/page rectangle  }
  bkm_DeletePage                = $0354; { Delete page(s)            }
  bkm_InsertPage                = $0355; { Insert page               }
  bkm_InvalidateTabs            = $0356; { Invalidate tab area       }
  bkm_TurnToPage                = $0357; { Turn to page              }
  bkm_QueryPageCount            = $0358; { Query number of pages     }
  bkm_QueryPageId               = $0359; { Query page identifier     }
  bkm_QueryPageData             = $035A; { Query page user data      }
  bkm_QueryPageWindowHWnd       = $035B; { Query page window handle  }
  bkm_QueryTabBitmap            = $035C; { Query tab bitmap handle   }
  bkm_QueryTabText              = $035D; { Query tab text pointer    }
  bkm_SetDimensions             = $035E; { Set tab/dogear dimensions }
  bkm_SetPageData               = $035F; { Set page user data        }
  bkm_SetPageWindowHWnd         = $0360; { Set page window handle    }
  bkm_SetStatusLineText         = $0361; { Set status line text      }
  bkm_SetTabBitmap              = $0362; { Set tab bitmap            }
  bkm_SetTabText                = $0363; { Set tab text              }
  bkm_SetNotebookColors         = $0364; { Set Notebook colors       }
  bkm_QueryPageStyle            = $0365; { Query page style          }
  bkm_QueryStatusLineText       = $0366; { Query status line text    }

  bkn_PageSelected              = 130;   { New page selected by user }
  bkn_NewPageSize               = 131;   { App page size changed     }
  bkn_Help                      = 132;   { Help notification         }
  bkn_PageDeleted               = 133;   { Page deleted notification }

{ Page deletion flags (usDeleteFlag) }
  bka_All                       = $0001; { all pages                 }
  bka_Single                    = $0002; { single page               }
  bka_Tab                       = $0004; { minor/major section       }

{ Page insertion/query order (usPageOrder, usQueryOrder) }
  bka_Last                      = $0002; { Insert/Query last page    }
  bka_First                     = $0004; { Insert/Query first page   }
  bka_Next                      = $0008; { Insert/Query after page   }
  bka_Prev                      = $0010; { Insert/Query before page  }
  bka_Top                       = $0020; { Query topmost page        }

{ Notebook region types (usBookRegion, usType) }
  bka_MajorTab                  = $0001; { Major Tab                 }
  bka_MinorTab                  = $0002; { Minor Tab                 }
  bka_PageButton                = $0100; { Page Turning Button       }

{ Page insertion/query styles (usPageStyle,usQueryEnd) }
  bka_StatusTextOn              = $0001; { status area text          }
  bka_Major                     = $0040; { Major Tab                 }
  bka_Minor                     = $0080; { Minor Tab                 }
  bka_AutoPageSize              = $0100; { Page window position/size }
  bka_End                       = $0200; { Query to end of book      }

{ Tab window contents (usTabDisplay) }
  bka_Text                      = $0400; { text data                 }
  bka_Bitmap                    = $0800; { bitmap                    }

{ Notebook window styles (ulNotebookStyles) }

  bks_BackPageSbr               = $00000001; { Bottom right          }
  bks_BackPageSbl               = $00000002; { Bottom left           }
  bks_BackPageStr               = $00000004; { Top right             }
  bks_BackPageStl               = $00000008; { Top left              }

{ Major Tab Side }
  bks_MajorTabRight             = $00000010; { Major tabs right      }
  bks_MajorTabLeft              = $00000020; { Major tabs left       }
  bks_MajorTabTop               = $00000040; { Major tabs top        }
  bks_MajorTabBottom            = $00000080; { Major tabs bottom     }

{ Tab Type }
  bks_SquareTabs                = $00000000; { Square edged tabs     }
  bks_RoundedTabs               = $00000100; { Round edged tabs      }
  bks_PolygonTabs               = $00000200; { Polygon edged tabs    }

{ Binding type }
  bks_SolidBind                 = $00000000; { Solid binding         }
  bks_SpiralBind                = $00000400; { Spiral binding        }

{ Status line text justification }
  bks_StatusTextLeft            = $00000000; { Left justify text     }
  bks_StatusTextRight           = $00001000; { Right justify text    }
  bks_StatusTextCenter          = $00002000; { Center text           }

{ Tab text justification }
  bks_TabTextLeft               = $00000000; { Left justify tab text }
  bks_TabTextRight              = $00004000; { Right justify tab text}
  bks_TabTextCenter             = $00008000; { Center tab text       }

{ Notebook color presentation param attributes }
  bka_BackgroundPageColorIndex  = $0001; { Page Background       }
  bka_BackgroundPageColor       = $0002;
  bka_BackgroundMajorColorIndex = $0003; { Major Tab Background  }
  bka_BackgroundMajorColor      = $0004;
  bka_BackgroundMinorColorIndex = $0005; { Minor Tab Background  }
  bka_BackgroundMinorColor      = $0006;
  bka_ForegroundMajorColorIndex = $0007; { Major Tab Text        }
  bka_ForegroundMajorColor      = $0008;
  bka_ForegroundMinorColorIndex = $0009; { Minor Tab Text        }
  bka_ForegroundMinorColor      = $000A;

{ Error message ids }
  bookerr_Invalid_Parameters    = -1;   { Invalid parameters     }

{ bkm_QueryTabText and bkm_QueryStatusLineText message record }
type
  PBookText = ^BookText;
  BookText = record
    pString: PChar;                     { ptr to string buffer      }
    textLen: ULong;                     { length of string to query }
  end;

{ bkn_PageDeleted notify message record }

  PDeleteNotify = ^DeleteNotify;
  DeleteNotify = record
    hWndBook:      HWnd;                { Notebook window handle    }
    hWndPage:      HWnd;                { App. page window handle   }
    ulAppPageData: ULong;               { App. page data            }
    hbmTab:        HBitMap;             { App. tab bitmap handle    }
  end;

{ bkn_PageSelected notify message record }

  PPageSelectNotify = ^PageSelectNotify;
  PageSelectNotify = record
    hWndBook:    HWnd;                  { Notebook window handle    }
    ulPageIdCur: ULong;                 { Previous top page id      }
    ulPageIdNew: ULong;                 { New top Page id           }
  end;

{----[ PMERR ]----}

{ Window Manager error codes }
const
  pmerr_Invalid_HWnd            = $1001;
  pmerr_Invalid_Hmq             = $1002;
  pmerr_Parameter_Out_Of_Range  = $1003;
  pmerr_Window_Lock_Underflow   = $1004;
  pmerr_Window_Lock_Overflow    = $1005;
  pmerr_Bad_Window_Lock_Count   = $1006;
  pmerr_Window_Not_Locked       = $1007;
  pmerr_Invalid_Selector        = $1008;
  pmerr_Call_From_Wrong_Thread  = $1009;
  pmerr_Resource_Not_Found      = $100A;
  pmerr_Invalid_String_Parm     = $100B;
  pmerr_Invalid_HHeap           = $100C;
  pmerr_Invalid_Heap_Pointer    = $100D;
  pmerr_Invalid_Heap_Size_Parm  = $100E;
  pmerr_Invalid_Heap_Size       = $100F;
  pmerr_Invalid_Heap_Size_Word  = $1010;
  pmerr_Heap_Out_Of_Memory      = $1011;
  pmerr_Heap_Max_Size_Reached   = $1012;
  pmerr_Invalid_HAtomTbl        = $1013;
  pmerr_Invalid_Atom            = $1014;
  pmerr_Invalid_Atom_Name       = $1015;
  pmerr_Invalid_Integer_Atom    = $1016;
  pmerr_Atom_Name_Not_Found     = $1017;
  pmerr_Queue_Too_Large         = $1018;
  pmerr_Invalid_Flag            = $1019;
  pmerr_Invalid_HAccel          = $101A;
  pmerr_Invalid_HPtr            = $101B;
  pmerr_Invalid_HEnum           = $101C;
  pmerr_Invalid_Src_CodePage    = $101D;
  pmerr_Invalid_Dst_CodePage    = $101E;

{ These are not real error codes, but just used to access special  }
{ error message strings used by WinGetErrorInfo to format an error }
{ message.                                                         }

  pmerr_Unknown_Component_Id    = $101f;
  pmerr_Unknown_Error_Code      = $1020;
  pmerr_Severity_Levels         = $1021;

{ $1022 - $1033, $1035, $104B - $104C used elsewhere }
  pmerr_Invalid_Resource_Format = $1034;
  pmerr_No_Msg_Queue            = $1036;
  pmerr_Win_Debugmsg            = $1037;
  pmerr_Queue_Full              = $1038;

  pmerr_Library_Load_Failed     = $1039;
  pmerr_Procedure_Load_Failed   = $103A;
  pmerr_Library_Delete_Failed   = $103B;
  pmerr_Procedure_Delete_Failed = $103C;
  pmerr_Array_Too_Large         = $103D;
  pmerr_Array_Too_Small         = $103E;
  pmerr_Datatype_Entry_Bad_Index = $103F;
  pmerr_Datatype_Entry_Ctl_Bad  = $1040;
  pmerr_Datatype_Entry_Ctl_Miss = $1041;
  pmerr_Datatype_Entry_Invalid  = $1042;
  pmerr_Datatype_Entry_Not_Num  = $1043;
  pmerr_Datatype_Entry_Not_Off  = $1044;
  pmerr_Datatype_Invalid        = $1045;
  pmerr_Datatype_Not_Unique     = $1046;
  pmerr_Datatype_Too_Long       = $1047;
  pmerr_Datatype_Too_Small      = $1048;
  pmerr_Direction_Invalid       = $1049;
  pmerr_Invalid_Hab             = $104A;
  pmerr_Invalid_Hstruct         = $104D;
  pmerr_Length_Too_Small        = $104E;
  pmerr_Msgid_Too_Small         = $104F;
  pmerr_No_Handle_Alloc         = $1050;
  pmerr_Not_In_A_Pm_Session     = $1051;
  pmerr_Msg_Queue_Already_Exists = $1052;
  pmerr_Old_Resource            = $1055;

{ Window Manager error codes }
  pmerr_Invalid_Pib             = $1101;
  pmerr_Insuff_Space_To_Add     = $1102;
  pmerr_Invalid_Group_Handle    = $1103;
  pmerr_Duplicate_Title         = $1104;
  pmerr_Invalid_Title           = $1105;
  pmerr_Handle_Not_In_Group     = $1107;
  pmerr_Invalid_Target_Handle   = $1106;
  pmerr_Invalid_Path_Statement  = $1108;
  pmerr_No_Program_Found        = $1109;
  pmerr_Invalid_Buffer_Size     = $110A;
  pmerr_Buffer_Too_Small        = $110B;
  pmerr_Pl_Initialisation_Fail  = $110C;
  pmerr_Cant_Destroy_Sys_Group  = $110D;
  pmerr_Invalid_Type_Change     = $110E;
  pmerr_Invalid_Program_Handle  = $110F;

  pmerr_Not_Current_Pl_Version  = $1110;
  pmerr_Invalid_Circular_Ref    = $1111;
  pmerr_Memory_Allocation_Err   = $1112;
  pmerr_Memory_Deallocation_Err = $1113;
  pmerr_Task_Header_Too_Big     = $1114;

  pmerr_Invalid_Ini_File_Handle = $1115;
  pmerr_Memory_Share            = $1116;
  pmerr_Open_Queue              = $1117;
  pmerr_Create_Queue            = $1118;
  pmerr_Write_Queue             = $1119;
  pmerr_Read_Queue              = $111A;
  pmerr_Call_Not_Executed       = $111B;
  pmerr_Unknown_Apipkt          = $111C;
  pmerr_Inithread_Exists        = $111D;
  pmerr_Create_Thread           = $111E;
  pmerr_No_Hk_Profile_Installed = $111F;
  pmerr_Invalid_Directory       = $1120;
  pmerr_Wildcard_In_Filename    = $1121;
  pmerr_Filename_Buffer_Full    = $1122;
  pmerr_Filename_Too_Long       = $1123;
  pmerr_Ini_File_Is_Sys_Or_User = $1124;
  pmerr_Broadcast_Plmsg         = $1125;
  pmerr_190_Init_Done           = $1126;
  pmerr_Hmod_For_Pmshapi        = $1127;
  pmerr_Set_Hk_Profile          = $1128;
  pmerr_Api_Not_Allowed         = $1129;
  pmerr_Ini_Still_Open          = $112A;

  pmerr_Progdetails_Not_In_Ini  = $112B;
  pmerr_Pibstruct_Not_In_Ini    = $112C;
  pmerr_Invalid_Diskprogdetails = $112D;
  pmerr_Progdetails_Read_Failure  = $112E;
  pmerr_Progdetails_Write_Failure = $112F;
  pmerr_Progdetails_Qsize_Failure = $1130;
  pmerr_Invalid_Progdetails     = $1131;
  pmerr_Sheprofilehook_Not_Found = $1132;
  pmerr_190plconverted          = $1133;
  pmerr_Failed_To_Convert_Ini_Pl = $1134;
  pmerr_Pmshapi_Not_Initialised = $1135;
  pmerr_Invalid_Shell_Api_Hook_Id = $1136;

  pmerr_Dos_Error               = $1200;

  pmerr_No_Space                = $1201;
  pmerr_Invalid_Switch_Handle   = $1202;
  pmerr_No_Handle               = $1203;
  pmerr_Invalid_Process_Id      = $1204;
  pmerr_Not_Shell               = $1205;
  pmerr_Invalid_Window          = $1206;
  pmerr_Invalid_Post_Msg        = $1207;
  pmerr_Invalid_Parameters      = $1208;
  pmerr_Invalid_Program_Type    = $1209;
  pmerr_Not_Extended_Focus      = $120A;
  pmerr_Invalid_Session_Id      = $120B;
  pmerr_Smg_Invalid_Icon_File   = $120C;
  pmerr_Smg_Icon_Not_Created    = $120D;
  pmerr_Shl_Debug               = $120E;

  pmerr_Opening_Ini_File        = $1301;
  pmerr_Ini_File_Corrupt        = $1302;
  pmerr_Invalid_Parm            = $1303;
  pmerr_Not_In_Idx              = $1304;
  pmerr_No_Entries_In_Group     = $1305;

  pmerr_Ini_Write_Fail          = $1306;
  pmerr_Idx_Full                = $1307;
  pmerr_Ini_Protected           = $1308;
  pmerr_Memory_Alloc            = $1309;
  pmerr_Ini_Init_Already_Done   = $130A;
  pmerr_Invalid_Integer         = $130B;
  pmerr_Invalid_Asciiz          = $130C;
  pmerr_Can_Not_Call_Spooler    = $130D;
  pmerr_Validation_Rejected     = pmerr_Can_Not_Call_Spooler;

  pmerr_Warning_Window_Not_Killed = $1401;
  pmerr_Error_Invalid_Window    = $1402;
  pmerr_Already_Initialized     = $1403;
  pmerr_Msg_Prog_No_Mou         = $1405;
  pmerr_Msg_Prog_Non_Recov      = $1406;
  pmerr_Winconv_Invalid_Path    = $1407;
  pmerr_Pi_Not_Initialised      = $1408;
  pmerr_Pl_Not_Initialised      = $1409;
  pmerr_No_Task_Manager         = $140A;
  pmerr_Save_Not_In_Progress    = $140B;
  pmerr_No_Stack_Space          = $140C;
  pmerr_Invalid_Colr_Field      = $140d;
  pmerr_Invalid_Colr_Value      = $140e;
  pmerr_Colr_Write              = $140f;

  pmerr_Target_File_Exists      = $1501;
  pmerr_Source_Same_As_Target   = $1502;
  pmerr_Source_File_Not_Found   = $1503;
  pmerr_Invalid_New_Path        = $1504;
  pmerr_Target_File_Not_Found   = $1505;
  pmerr_Invalid_Drive_Number    = $1506;
  pmerr_Name_Too_Long           = $1507;
  pmerr_Not_Enough_Room_On_Disk = $1508;
  pmerr_Not_Enough_Mem          = $1509;

  pmerr_Log_Drv_Does_Not_Exist  = $150B;
  pmerr_Invalid_Drive           = $150C;
  pmerr_Access_Denied           = $150D;
  pmerr_No_First_Slash          = $150E;
  pmerr_Read_Only_File          = $150F;
  pmerr_Group_Protected         = $151F;
  pmerr_Invalid_Program_Category = $152F;
  pmerr_Invalid_Appl            = $1530;
  pmerr_Cannot_Start            = $1531;
  pmerr_Started_In_Background   = $1532;
  pmerr_Invalid_Happ            = $1533;
  pmerr_Cannot_Stop             = $1534;

{ Errors generated by Language Bindings layer    }
{ (Range $1600 thru $16FF reserved for Bindings) }
{ severity_Unrecoverable }
  pmerr_Internal_Error_1        = $1601;
  pmerr_Internal_Error_2        = $1602;
  pmerr_Internal_Error_3        = $1603;
  pmerr_Internal_Error_4        = $1604;
  pmerr_Internal_Error_5        = $1605;
  pmerr_Internal_Error_6        = $1606;
  pmerr_Internal_Error_7        = $1607;
  pmerr_Internal_Error_8        = $1608;
  pmerr_Internal_Error_9        = $1609;
  pmerr_Internal_Error_10       = $160A;
  pmerr_Internal_Error_11       = $160B;
  pmerr_Internal_Error_12       = $160C;
  pmerr_Internal_Error_13       = $160D;
  pmerr_Internal_Error_14       = $160E;
  pmerr_Internal_Error_15       = $160F;
  pmerr_Internal_Error_16       = $1610;
  pmerr_Internal_Error_17       = $1611;
  pmerr_Internal_Error_18       = $1612;
  pmerr_Internal_Error_19       = $1613;
  pmerr_Internal_Error_20       = $1614;
  pmerr_Internal_Error_21       = $1615;
  pmerr_Internal_Error_22       = $1616;
  pmerr_Internal_Error_23       = $1617;
  pmerr_Internal_Error_24       = $1618;
  pmerr_Internal_Error_25       = $1619;
  pmerr_Internal_Error_26       = $161A;
  pmerr_Internal_Error_27       = $161B;
  pmerr_Internal_Error_28       = $161C;
  pmerr_Internal_Error_29       = $161D;

{ severity_Warning }
  pmerr_Invalid_Free_Message_Id = $1630;

{ severity_Error }

  pmerr_Function_Not_Supported  = $1641;
  pmerr_Invalid_Array_Count     = $1642;
  pmerr_Invalid_Length          = $1643;
  pmerr_Invalid_Bundle_Type     = $1644;
  pmerr_Invalid_Parameter       = $1645;
  pmerr_Invalid_Number_Of_Parms = $1646;
  pmerr_Greater_Than_64k        = $1647;
  pmerr_Invalid_Parameter_Type  = $1648;
  pmerr_Negative_Strcond_Dim    = $1649;
  pmerr_Invalid_Number_Of_Types = $164A;
  pmerr_Incorrect_Hstruct       = $164B;
  pmerr_Invalid_Array_Size      = $164C;
  pmerr_Invalid_Control_Datatype = $164D;
  pmerr_Incomplete_Control_Sequ = $164E;
  pmerr_Invalid_Datatype        = $164F;
  pmerr_Incorrect_Datatype      = $1650;
  pmerr_Not_Self_Describing_Dtyp = $1651;
  pmerr_Invalid_Ctrl_Seq_Index  = $1652;
  pmerr_Invalid_Type_For_Length = $1653;
  pmerr_Invalid_Type_For_Offset = $1654;
  pmerr_Invalid_Type_For_Mparam = $1655;
  pmerr_Invalid_Message_Id      = $1656;
  pmerr_C_Length_Too_Small      = $1657;
  pmerr_Appl_Structure_Too_Small = $1658;
  pmerr_Invalid_Errorinfo_Handle = $1659;
  pmerr_Invalid_Character_Index = $165A;

{ Workplace Shell error codes }
  wperr_Protected_Class         = $1700;
  wperr_Invalid_Class           = $1701;
  wperr_Invalid_Superclass      = $1702;
  wperr_No_Memory               = $1703;
  wperr_Semaphore_Error         = $1704;
  wperr_Buffer_Too_Small        = $1705;
  wperr_Clsloadmod_Failed       = $1706;
  wperr_Clsprocaddr_Failed      = $1707;
  wperr_Objword_Location        = $1708;
  wperr_Invalid_Object          = $1709;
  wperr_Memory_Cleanup          = $170A;
  wperr_Invalid_Module          = $170B;
  wperr_Invalid_Oldclass        = $170C;
  wperr_Invalid_Newclass        = $170D;
  wperr_Not_Immediate_Child     = $170E;
  wperr_Not_Workplace_Class     = $170F;
  wperr_Cant_Replace_Metacls    = $1710;
  wperr_Ini_File_Write          = $1711;
  wperr_Invalid_Folder          = $1712;
  wperr_Buffer_Overflow         = $1713;
  wperr_Object_Not_Found        = $1714;
  wperr_Invalid_Hfind           = $1715;
  wperr_Invalid_Count           = $1716;
  wperr_Invalid_Buffer          = $1717;
  wperr_Already_Exists          = $1718;
  wperr_Invalid_Flags           = $1719;
  wperr_Invalid_Objectid        = $1720;

{ GPI error codes }
  pmerr_Ok                      = $0000;
  pmerr_Already_In_Area         = $2001;
  pmerr_Already_In_Element      = $2002;
  pmerr_Already_In_Path         = $2003;
  pmerr_Already_In_Seg          = $2004;
  pmerr_Area_Incomplete         = $2005;
  pmerr_Base_Error              = $2006;
  pmerr_Bitblt_Length_Exceeded  = $2007;
  pmerr_Bitmap_In_Use           = $2008;
  pmerr_Bitmap_Is_Selected      = $2009;
  pmerr_Bitmap_Not_Found        = $200A;
  pmerr_Bitmap_Not_Selected     = $200B;
  pmerr_Bounds_Overflow         = $200C;
  pmerr_Called_Seg_Is_Chained   = $200D;
  pmerr_Called_Seg_Is_Current   = $200E;
  pmerr_Called_Seg_Not_Found    = $200F;
  pmerr_Cannot_Delete_All_Data  = $2010;
  pmerr_Cannot_Replace_Element_0 = $2011;
  pmerr_Col_Table_Not_Realizable = $2012;
  pmerr_Col_Table_Not_Realized  = $2013;
  pmerr_Coordinate_Overflow     = $2014;
  pmerr_Corr_Format_Mismatch    = $2015;
  pmerr_Data_Too_Long           = $2016;
  pmerr_Dc_Is_Associated        = $2017;
  pmerr_Desc_String_Truncated   = $2018;
  pmerr_Device_Driver_Error_1   = $2019;
  pmerr_Device_Driver_Error_2   = $201A;
  pmerr_Device_Driver_Error_3   = $201B;
  pmerr_Device_Driver_Error_4   = $201C;
  pmerr_Device_Driver_Error_5   = $201D;
  pmerr_Device_Driver_Error_6   = $201E;
  pmerr_Device_Driver_Error_7   = $201F;
  pmerr_Device_Driver_Error_8   = $2020;
  pmerr_Device_Driver_Error_9   = $2021;
  pmerr_Device_Driver_Error_10  = $2022;
  pmerr_Dev_Func_Not_Installed  = $2023;
  pmerr_Dosopen_Failure         = $2024;
  pmerr_Dosread_Failure         = $2025;
  pmerr_Driver_Not_Found        = $2026;
  pmerr_Dup_Seg                 = $2027;
  pmerr_Dynamic_Seg_Seq_Error   = $2028;
  pmerr_Dynamic_Seg_Zero_Inv    = $2029;
  pmerr_Element_Incomplete      = $202A;
  pmerr_Esc_Code_Not_Supported  = $202B;
  pmerr_Exceeds_Max_Seg_Length  = $202C;
  pmerr_Font_And_Mode_Mismatch  = $202D;
  pmerr_Font_File_Not_Loaded    = $202E;
  pmerr_Font_Not_Loaded         = $202F;
  pmerr_Font_Too_Big            = $2030;
  pmerr_Hardware_Init_Failure   = $2031;
  pmerr_Hbitmap_Busy            = $2032;
  pmerr_Hdc_Busy                = $2033;
  pmerr_Hrgn_Busy               = $2034;
  pmerr_Huge_Fonts_Not_Supported = $2035;
  pmerr_Id_Has_No_Bitmap        = $2036;
  pmerr_Image_Incomplete        = $2037;
  pmerr_Incompat_Color_Format   = $2038;
  pmerr_Incompat_Color_Options  = $2039;
  pmerr_Incompatible_Bitmap     = $203A;
  pmerr_Incompatible_Metafile   = $203B;
  pmerr_Incorrect_Dc_Type       = $203C;
  pmerr_Insufficient_Disk_Space = $203D;
  pmerr_Insufficient_Memory     = $203E;
  pmerr_Inv_Angle_Parm          = $203F;
  pmerr_Inv_Arc_Control         = $2040;
  pmerr_Inv_Area_Control        = $2041;
  pmerr_Inv_Arc_Points          = $2042;
  pmerr_Inv_Attr_Mode           = $2043;
  pmerr_Inv_Background_Col_Attr = $2044;
  pmerr_Inv_Background_Mix_Attr = $2045;
  pmerr_Inv_Bitblt_Mix          = $2046;
  pmerr_Inv_Bitblt_Style        = $2047;
  pmerr_Inv_Bitmap_Dimension    = $2048;
  pmerr_Inv_Box_Control         = $2049;
  pmerr_Inv_Box_Rounding_Parm   = $204A;
  pmerr_Inv_Char_Angle_Attr     = $204B;
  pmerr_Inv_Char_Direction_Attr = $204C;
  pmerr_Inv_Char_Mode_Attr      = $204D;
  pmerr_Inv_Char_Pos_Options    = $204E;
  pmerr_Inv_Char_Set_Attr       = $204F;
  pmerr_Inv_Char_Shear_Attr     = $2050;
  pmerr_Inv_Clip_Path_Options   = $2051;
  pmerr_Inv_Codepage            = $2052;
  pmerr_Inv_Color_Attr          = $2053;
  pmerr_Inv_Color_Data          = $2054;
  pmerr_Inv_Color_Format        = $2055;
  pmerr_Inv_Color_Index         = $2056;
  pmerr_Inv_Color_Options       = $2057;
  pmerr_Inv_Color_Start_Index   = $2058;
  pmerr_Inv_Coord_Offset        = $2059;
  pmerr_Inv_Coord_Space         = $205A;
  pmerr_Inv_Coordinate          = $205B;
  pmerr_Inv_Correlate_Depth     = $205C;
  pmerr_Inv_Correlate_Type      = $205D;
  pmerr_Inv_Cursor_Bitmap       = $205E;
  pmerr_Inv_Dc_Data             = $205F;
  pmerr_Inv_Dc_Type             = $2060;
  pmerr_Inv_Device_Name         = $2061;
  pmerr_Inv_Dev_Modes_Options   = $2062;
  pmerr_Inv_Draw_Control        = $2063;
  pmerr_Inv_Draw_Value          = $2064;
  pmerr_Inv_Drawing_Mode        = $2065;
  pmerr_Inv_Driver_Data         = $2066;
  pmerr_Inv_Driver_Name         = $2067;
  pmerr_Inv_Draw_Border_Option  = $2068;
  pmerr_Inv_Edit_Mode           = $2069;
  pmerr_Inv_Element_Offset      = $206A;
  pmerr_Inv_Element_Pointer     = $206B;
  pmerr_Inv_End_Path_Options    = $206C;
  pmerr_Inv_Esc_Code            = $206D;
  pmerr_Inv_Escape_Data         = $206E;
  pmerr_Inv_Extended_Lcid       = $206F;
  pmerr_Inv_Fill_Path_Options   = $2070;
  pmerr_Inv_First_Char          = $2071;
  pmerr_Inv_Font_Attrs          = $2072;
  pmerr_Inv_Font_File_Data      = $2073;
  pmerr_Inv_For_This_Dc_Type    = $2074;
  pmerr_Inv_Format_Control      = $2075;
  pmerr_Inv_Forms_Code          = $2076;
  pmerr_Inv_Fontdef             = $2077;
  pmerr_Inv_Geom_Line_Width_Attr = $2078;
  pmerr_Inv_Getdata_Control     = $2079;
  pmerr_Inv_Graphics_Field      = $207A;
  pmerr_Inv_Hbitmap             = $207B;
  pmerr_Inv_Hdc                 = $207C;
  pmerr_Inv_Hjournal            = $207D;
  pmerr_Inv_Hmf                 = $207E;
  pmerr_Inv_Hps                 = $207F;
  pmerr_Inv_Hrgn                = $2080;
  pmerr_Inv_Id                  = $2081;
  pmerr_Inv_Image_Data_Length   = $2082;
  pmerr_Inv_Image_Dimension     = $2083;
  pmerr_Inv_Image_Format        = $2084;
  pmerr_Inv_In_Area             = $2085;
  pmerr_Inv_In_Called_Seg       = $2086;
  pmerr_Inv_In_Current_Edit_Mode = $2087;
  pmerr_Inv_In_Draw_Mode        = $2088;
  pmerr_Inv_In_Element          = $2089;
  pmerr_Inv_In_Image            = $208A;
  pmerr_Inv_In_Path             = $208B;
  pmerr_Inv_In_Retain_Mode      = $208C;
  pmerr_Inv_In_Seg              = $208D;
  pmerr_Inv_In_Vector_Symbol    = $208E;
  pmerr_Inv_Info_Table          = $208F;
  pmerr_Inv_Journal_Option      = $2090;
  pmerr_Inv_Kerning_Flags       = $2091;
  pmerr_Inv_Length_Or_Count     = $2092;
  pmerr_Inv_Line_End_Attr       = $2093;
  pmerr_Inv_Line_Join_Attr      = $2094;
  pmerr_Inv_Line_Type_Attr      = $2095;
  pmerr_Inv_Line_Width_Attr     = $2096;
  pmerr_Inv_Logical_Address     = $2097;
  pmerr_Inv_Marker_Box_Attr     = $2098;
  pmerr_Inv_Marker_Set_Attr     = $2099;
  pmerr_Inv_Marker_Symbol_Attr  = $209A;
  pmerr_Inv_Matrix_Element      = $209B;
  pmerr_Inv_Max_Hits            = $209C;
  pmerr_Inv_Metafile            = $209D;
  pmerr_Inv_Metafile_Length     = $209E;
  pmerr_Inv_Metafile_Offset     = $209F;
  pmerr_Inv_Microps_Draw_Control = $20A0;
  pmerr_Inv_Microps_Function    = $20A1;
  pmerr_Inv_Microps_Order       = $20A2;
  pmerr_Inv_Mix_Attr            = $20A3;
  pmerr_Inv_Mode_For_Open_Dyn   = $20A4;
  pmerr_Inv_Mode_For_Reopen_Seg = $20A5;
  pmerr_Inv_Modify_Path_Mode    = $20A6;
  pmerr_Inv_Multiplier          = $20A7;
  pmerr_Inv_Nested_Figures      = $20A8;
  pmerr_Inv_Or_Incompat_Options = $20A9;
  pmerr_Inv_Order_Length        = $20AA;
  pmerr_Inv_Ordering_Parm       = $20AB;
  pmerr_Inv_Outside_Draw_Mode   = $20AC;
  pmerr_Inv_Page_Viewport       = $20AD;
  pmerr_Inv_Path_Id             = $20AE;
  pmerr_Inv_Path_Mode           = $20AF;
  pmerr_Inv_Pattern_Attr        = $20B0;
  pmerr_Inv_Pattern_Ref_Pt_Attr = $20B1;
  pmerr_Inv_Pattern_Set_Attr    = $20B2;
  pmerr_Inv_Pattern_Set_Font    = $20B3;
  pmerr_Inv_Pick_Aperture_Option = $20B4;
  pmerr_Inv_Pick_Aperture_Posn  = $20B5;
  pmerr_Inv_Pick_Aperture_Size  = $20B6;
  pmerr_Inv_Pick_Number         = $20B7;
  pmerr_Inv_Play_Metafile_Option = $20B8;
  pmerr_Inv_Primitive_Type      = $20B9;
  pmerr_Inv_Ps_Size             = $20BA;
  pmerr_Inv_Putdata_Format      = $20BB;
  pmerr_Inv_Query_Element_No    = $20BC;
  pmerr_Inv_Rect                = $20BD;
  pmerr_Inv_Region_Control      = $20BE;
  pmerr_Inv_Region_Mix_Mode     = $20BF;
  pmerr_Inv_Replace_Mode_Func   = $20C0;
  pmerr_Inv_Reserved_Field      = $20C1;
  pmerr_Inv_Reset_Options       = $20C2;
  pmerr_Inv_Rgbcolor            = $20C3;
  pmerr_Inv_Scan_Start          = $20C4;
  pmerr_Inv_Seg_Attr            = $20C5;
  pmerr_Inv_Seg_Attr_Value      = $20C6;
  pmerr_Inv_Seg_Ch_Length       = $20C7;
  pmerr_Inv_Seg_Name            = $20C8;
  pmerr_Inv_Seg_Offset          = $20C9;
  pmerr_Inv_Setid               = $20CA;
  pmerr_Inv_Setid_Type          = $20CB;
  pmerr_Inv_Set_Viewport_Option = $20CC;
  pmerr_Inv_Sharpness_Parm      = $20CD;
  pmerr_Inv_Source_Offset       = $20CE;
  pmerr_Inv_Stop_Draw_Value     = $20CF;
  pmerr_Inv_Transform_Type      = $20D0;
  pmerr_Inv_Usage_Parm          = $20D1;
  pmerr_Inv_Viewing_Limits      = $20D2;
  pmerr_Jfile_Busy              = $20D3;
  pmerr_Jnl_Func_Data_Too_Long  = $20D4;
  pmerr_Kerning_Not_Supported   = $20D5;
  pmerr_Label_Not_Found         = $20D6;
  pmerr_Matrix_Overflow         = $20D7;
  pmerr_Metafile_Internal_Error = $20D8;
  pmerr_Metafile_In_Use         = $20D9;
  pmerr_Metafile_Limit_Exceeded = $20DA;
  pmerr_Name_Stack_Full         = $20DB;
  pmerr_Not_Created_By_Devopendc = $20DC;
  pmerr_Not_In_Area             = $20DD;
  pmerr_Not_In_Draw_Mode        = $20DE;
  pmerr_Not_In_Element          = $20DF;
  pmerr_Not_In_Image            = $20E0;
  pmerr_Not_In_Path             = $20E1;
  pmerr_Not_In_Retain_Mode      = $20E2;
  pmerr_Not_In_Seg              = $20E3;
  pmerr_No_Bitmap_Selected      = $20E4;
  pmerr_No_Current_Element      = $20E5;
  pmerr_No_Current_Seg          = $20E6;
  pmerr_No_Metafile_Record_Handle = $20E7;
  pmerr_Order_Too_Big           = $20E8;
  pmerr_Other_Set_Id_Refs       = $20E9;
  pmerr_Overran_Seg             = $20EA;
  pmerr_Own_Set_Id_Refs         = $20EB;
  pmerr_Path_Incomplete         = $20EC;
  pmerr_Path_Limit_Exceeded     = $20ED;
  pmerr_Path_Unknown            = $20EE;
  pmerr_Pel_Is_Clipped          = $20EF;
  pmerr_Pel_Not_Available       = $20F0;
  pmerr_Primitive_Stack_Empty   = $20F1;
  pmerr_Prolog_Error            = $20F2;
  pmerr_Prolog_Seg_Attr_Not_Set = $20F3;
  pmerr_Ps_Busy                 = $20F4;
  pmerr_Ps_Is_Associated        = $20F5;
  pmerr_Ram_Jnl_File_Too_Small  = $20F6;
  pmerr_Realize_Not_Supported   = $20F7;
  pmerr_Region_Is_Clip_Region   = $20F8;
  pmerr_Resource_Depletion      = $20F9;
  pmerr_Seg_And_Refseg_Are_Same = $20FA;
  pmerr_Seg_Call_Recursive      = $20FB;
  pmerr_Seg_Call_Stack_Empty    = $20FC;
  pmerr_Seg_Call_Stack_Full     = $20FD;
  pmerr_Seg_Is_Current          = $20FE;
  pmerr_Seg_Not_Chained         = $20FF;
  pmerr_Seg_Not_Found           = $2100;
  pmerr_Seg_Store_Limit_Exceeded = $2101;
  pmerr_Setid_In_Use            = $2102;
  pmerr_Setid_Not_Found         = $2103;
  pmerr_Startdoc_Not_Issued     = $2104;
  pmerr_Stop_Draw_Occurred      = $2105;
  pmerr_Too_Many_Metafiles_In_Use = $2106;
  pmerr_Truncated_Order         = $2107;
  pmerr_Unchained_Seg_Zero_Inv  = $2108;
  pmerr_Unsupported_Attr        = $2109;
  pmerr_Unsupported_Attr_Value  = $210A;
  pmerr_Enddoc_Not_Issued       = $210B;
  pmerr_Ps_Not_Associated       = $210C;
  pmerr_Inv_Flood_Fill_Options  = $210D;
  pmerr_Inv_Facename            = $210E;
  pmerr_Palette_Selected        = $210F;
  pmerr_No_Palette_Selected     = $2110;
  pmerr_Inv_Hpal                = $2111;
  pmerr_Palette_Busy            = $2112;
  pmerr_Start_Point_Clipped     = $2113;
  pmerr_No_Fill                 = $2114;
  pmerr_Inv_Facenamedesc        = $2115;
  pmerr_Inv_Bitmap_Data         = $2116;
  pmerr_Inv_Char_Align_Attr     = $2117;
  pmerr_Inv_Hfont               = $2118;
  pmerr_Hfont_Is_Selected       = $2119;

{ Device Manager error codes }
{ None yet }

{ Spooler error codes }
  pmerr_Spl_Driver_Error        = $4001;
  pmerr_Spl_Device_Error        = $4002;
  pmerr_Spl_Device_Not_Installed = $4003;
  pmerr_Spl_Queue_Error         = $4004;
  pmerr_Spl_Inv_Hspl            = $4005;
  pmerr_Spl_No_Disk_Space       = $4006;
  pmerr_Spl_No_Memory           = $4007;
  pmerr_Spl_Print_Abort         = $4008;
  pmerr_Spl_Spooler_Not_Installed = $4009;
  pmerr_Spl_Inv_Forms_Code      = $400A;
  pmerr_Spl_Inv_Priority        = $400B;
  pmerr_Spl_No_Free_Job_Id      = $400C;
  pmerr_Spl_No_Data             = $400D;
  pmerr_Spl_Inv_Token           = $400E;
  pmerr_Spl_Inv_Datatype        = $400F;
  pmerr_Spl_Processor_Error     = $4010;
  pmerr_Spl_Inv_Job_Id          = $4011;
  pmerr_Spl_Job_Not_Printing    = $4012;
  pmerr_Spl_Job_Printing        = $4013;
  pmerr_Spl_Queue_Already_Exists = $4014;
  pmerr_Spl_Inv_Queue_Name      = $4015;
  pmerr_Spl_Queue_Not_Empty     = $4016;
  pmerr_Spl_Device_Already_Exists = $4017;
  pmerr_Spl_Device_Limit_Reached  = $4018;
  pmerr_Spl_Status_String_Trunc = $4019;
  pmerr_Spl_Inv_Length_Or_Count = $401A;
  pmerr_Spl_File_Not_Found      = $401B;
  pmerr_Spl_Cannot_Open_File    = $401C;
  pmerr_Spl_Driver_Not_Installed  = $401D;
  pmerr_Spl_Inv_Processor_Dattype = $401E;
  pmerr_Spl_Inv_Driver_Datatype = $401F;
  pmerr_Spl_Processor_Not_Inst  = $4020;
  pmerr_Spl_No_Such_Log_Address = $4021;
  pmerr_Spl_Printer_Not_Found   = $4022;
  pmerr_Spl_Dd_Not_Found        = $4023;
  pmerr_Spl_Queue_Not_Found     = $4024;
  pmerr_Spl_Many_Queues_Assoc   = $4025;
  pmerr_Spl_No_Queues_Associated = $4026;
  pmerr_Spl_Ini_File_Error      = $4027;
  pmerr_Spl_No_Default_Queue    = $4028;
  pmerr_Spl_No_Current_Forms_Code = $4029;
  pmerr_Spl_Not_Authorised      = $402A;
  pmerr_Spl_Temp_Network_Error  = $402B;
  pmerr_Spl_Hard_Network_Error  = $402C;
  pmerr_Del_Not_Allowed         = $402D;
  pmerr_Cannot_Del_Qp_Ref       = $402E;
  pmerr_Cannot_Del_Qname_Ref    = $402F;
  pmerr_Cannot_Del_Printer_Dd_Ref = $4030;
  pmerr_Cannot_Del_Prn_Name_Ref = $4031;
  pmerr_Cannot_Del_Prn_Addr_Ref = $4032;
  pmerr_Spooler_Qp_Not_Defined  = $4033;
  pmerr_Prn_Name_Not_Defined    = $4034;
  pmerr_Prn_Addr_Not_Defined    = $4035;
  pmerr_Printer_Dd_Not_Defined  = $4036;
  pmerr_Printer_Queue_Not_Defined = $4037;
  pmerr_Prn_Addr_In_Use         = $4038;
  pmerr_Spl_Too_Many_Open_Files = $4039;
  pmerr_Spl_Cp_Not_Reqd         = $403A;
  pmerr_Unable_To_Close_Device  = $4040;

  pmerr_Spl_Error_1             = splerr_Base + 4001;
  pmerr_Spl_Error_2             = splerr_Base + 4002;
  pmerr_Spl_Error_3             = splerr_Base + 4003;
  pmerr_Spl_Error_4             = splerr_Base + 4004;
  pmerr_Spl_Error_5             = splerr_Base + 4005;
  pmerr_Spl_Error_6             = splerr_Base + 4006;
  pmerr_Spl_Error_7             = splerr_Base + 4007;
  pmerr_Spl_Error_8             = splerr_Base + 4008;
  pmerr_Spl_Error_9             = splerr_Base + 4009;
  pmerr_Spl_Error_10            = splerr_Base + 4010;
  pmerr_Spl_Error_11            = splerr_Base + 4011;
  pmerr_Spl_Error_12            = splerr_Base + 4012;
  pmerr_Spl_Error_13            = splerr_Base + 4013;
  pmerr_Spl_Error_14            = splerr_Base + 4014;
  pmerr_Spl_Error_15            = splerr_Base + 4015;
  pmerr_Spl_Error_16            = splerr_Base + 4016;
  pmerr_Spl_Error_17            = splerr_Base + 4017;
  pmerr_Spl_Error_18            = splerr_Base + 4018;
  pmerr_Spl_Error_19            = splerr_Base + 4019;
  pmerr_Spl_Error_20            = splerr_Base + 4020;
  pmerr_Spl_Error_21            = splerr_Base + 4021;
  pmerr_Spl_Error_22            = splerr_Base + 4022;
  pmerr_Spl_Error_23            = splerr_Base + 4023;
  pmerr_Spl_Error_24            = splerr_Base + 4024;
  pmerr_Spl_Error_25            = splerr_Base + 4025;
  pmerr_Spl_Error_26            = splerr_Base + 4026;
  pmerr_Spl_Error_27            = splerr_Base + 4027;
  pmerr_Spl_Error_28            = splerr_Base + 4028;
  pmerr_Spl_Error_29            = splerr_Base + 4029;
  pmerr_Spl_Error_30            = splerr_Base + 4030;
  pmerr_Spl_Error_31            = splerr_Base + 4031;
  pmerr_Spl_Error_32            = splerr_Base + 4032;
  pmerr_Spl_Error_33            = splerr_Base + 4033;
  pmerr_Spl_Error_34            = splerr_Base + 4034;
  pmerr_Spl_Error_35            = splerr_Base + 4035;
  pmerr_Spl_Error_36            = splerr_Base + 4036;
  pmerr_Spl_Error_37            = splerr_Base + 4037;
  pmerr_Spl_Error_38            = splerr_Base + 4038;
  pmerr_Spl_Error_39            = splerr_Base + 4039;
  pmerr_Spl_Error_40            = splerr_Base + 4040;

  pmerr_SplMsgBox_Info_caption          = splerr_Base + 4041;
  pmerr_SplMsgBox_Warning_caption       = splerr_Base + 4042;
  pmerr_SplMsgBox_Error_caption         = splerr_Base + 4043;
  pmerr_SplMsgBox_Severe_caption        = splerr_Base + 4044;

  pmerr_SplMsgBox_Job_details           = splerr_Base + 4045;

  pmerr_SplMsgBox_Error_action          = splerr_Base + 4046;
  pmerr_SplMsgBox_Severe_action         = splerr_Base + 4047;

  pmerr_SplMsgBox_Bit_0_Text            = splerr_Base + 4048;
  pmerr_SplMsgBox_Bit_1_Text            = splerr_Base + 4049;
  pmerr_SplMsgBox_Bit_2_Text            = splerr_Base + 4050;
  pmerr_SplMsgBox_Bit_3_Text            = splerr_Base + 4051;
  pmerr_SplMsgBox_Bit_4_Text            = splerr_Base + 4052;
  pmerr_SplMsgBox_Bit_5_Text            = splerr_Base + 4053;
  pmerr_SplMsgBox_Bit_15_Text           = splerr_Base + 4054;
  pmerr_Spl_NoPathBuffer                = splerr_Base + 4055;

  pmerr_Spl_Already_Initialised         = splerr_Base + 4093;
  pmerr_Spl_Error                       = splerr_Base + 4095;

{ Picture utilities error codes }
  pmerr_Inv_Type                = $5001;
  pmerr_Inv_Conv                = $5002;
  pmerr_Inv_SegLen              = $5003;
  pmerr_Dup_SegName             = $5004;
  pmerr_Inv_XForm               = $5005;
  pmerr_Inv_ViewLim             = $5006;
  pmerr_Inv_3dcoord             = $5007;
  pmerr_Smb_Ovflow              = $5008;
  pmerr_Seg_Ovflow              = $5009;
  pmerr_Pic_Dup_FileName        = $5010;

{ Numbers from $5100 to $5FFF are reserved }

implementation

end.
