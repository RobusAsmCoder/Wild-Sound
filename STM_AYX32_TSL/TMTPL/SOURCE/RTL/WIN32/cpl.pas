(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Control panel extension DLL definitions Unit           *)
(*       Based on cpl.h, cplext.h                               *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995-98 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

(*
 *  General rules for being installed in the Control Panel:
 *
 *     1) The DLL must export a function named CPlApplet which will handle
 *        the messages discussed below.
 *     2) If the applet needs to save information in CONTROL.INI minimize
 *        clutter by using the application name [MMCPL.appletname].
 *     2) If the applet is refrenced in CONTROL.INI under [MMCPL] use
 *        the following form:
 *             ...
 *              [MMCPL]
 *              uniqueName=c:\mydir\myapplet.dll
 *             ...
 *
 *
 * The order applet DLL's are loaded by CONTROL.EXE is not guaranteed.
 * Control panels may be sorted for display, etc.
 *
 * CONTROL.EXE will answer this message and launch an applet
 *
 * WM_CPL_LAUNCH
 *
 *      wParam      - window handle of calling app
 *      lParam      - LPTSTR of name of applet to launch
 *
 * WM_CPL_LAUNCHED
 *
 *      wParam      - TRUE/FALSE if applet was launched
 *      lParam      - NIL
 *
 * CONTROL.EXE will post this message to the caller when the applet returns
 * (ie., when wParam is a valid window handle)
 *
 *)

unit CPL;

interface

uses Windows, Messages;
const
  WM_CPL_LAUNCH   = (WM_USER+1000);
  WM_CPL_LAUNCHED = (WM_USER+1001);

// The messages CPlApplet() must handle:
  CPL_DYNAMIC_RES = 0;
  CPL_INIT = 1;
  CPL_GETCOUNT = 2;
  CPL_INQUIRE = 3;
  CPL_SELECT = 4;
  CPL_DBLCLK = 5;
  CPL_STOP = 6;
  CPL_EXIT = 7;
  CPL_NEWINQUIRE = 8;
  CPL_STARTWPARMS = 9;
  CPL_SETUP = 200;

type
//A function prototype for CPlApplet()
  APPLET_PROC = function conv arg_stdcall (hwndCPl: THandle; uMsg: DWORD; lParam1, lParam2: Longint): Longint;

  TCPLApplet = APPLET_PROC;

//The data structure CPlApplet() must fill in.
  PCPLInfo = ^TCPLInfo;
  tagCPLINFO = packed record
    idIcon: Longint;  // icon resource id, provided by CPlApplet()
    idName: Longint;  // name string res. id, provided by CPlApplet()
    idInfo: Longint;  // info string res. id, provided by CPlApplet()
    lData : Longint;  // user defined data
  end;
  CPLINFO = tagCPLINFO;
  TCPLInfo = tagCPLINFO;

  PNewCPLInfoA = ^TNewCPLInfoA;
  PNewCPLInfoW = ^TNewCPLInfoW;
  PNewCPLInfo = PNewCPLInfoA;
  tagNEWCPLINFOA = packed record
    dwSize:        DWORD;   // similar to the commdlg
    dwFlags:       DWORD;
    dwHelpContext: DWORD;   // help context to use
    lData:         Longint; // user defined data
    hIcon:         HICON;   // icon to use, this is owned by CONTROL.EXE (may be deleted)
    szName:        array[0..31] of AnsiChar;    // short name
    szInfo:        array[0..63] of AnsiChar;    // long name (status line)
    szHelpFile:    array[0..127] of AnsiChar;   // path to help file to use
  end;
  tagNEWCPLINFOW = packed record
    dwSize:        DWORD;   // similar to the commdlg
    dwFlags:       DWORD;
    dwHelpContext: DWORD;   // help context to use
    lData:         Longint; // user defined data
    hIcon:         HICON;   // icon to use, this is owned by CONTROL.EXE (may be deleted)
    szName:        array[0..31] of WideChar;    // short name
    szInfo:        array[0..63] of WideChar;    // long name (status line)
    szHelpFile:    array[0..127] of WideChar;   // path to help file to use
  end;
  tagNEWCPLINFO = tagNEWCPLINFOA;
  NEWCPLINFOA   = tagNEWCPLINFOA;
  NEWCPLINFOW   = tagNEWCPLINFOW;
  NEWCPLINFO    = NEWCPLINFOA;
  TNewCPLInfoA  = tagNEWCPLINFOA;
  TNewCPLInfoW  = tagNEWCPLINFOW;
  TNewCPLInfo   = TNewCPLInfoA;

///////////////////////////////////////////////////////////////////////////////
// Below are constants for pages which can be replaced in the standard control
// panel applets.  To extend an applet, you must define an object which
// supports the IShellPropSheetExt interface and register it's in-process
// server in a subkey under the applet's registry key.  Registry paths for the
// applets are defined in the header file REGSTR.H
//  Generally, when an IShellPropSheetExt is loaded, it's AddPages method
// will be called once, while it's ReplacePage method may be called zero or
// more times.  ReplacePage is only called in context.
///////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Mouse Control Panel Extensions
// The following constants MAY be passed in IShellPropSheetExt::ReplacePage's
// uPageID parameter for servers registered under
//                                  ( REGSTR_PATH_CONTROLSFOLDER "\\Mouse" )
//-----------------------------------------------------------------------------
const
  CPLPAGE_MOUSE_BUTTONS     =  1;
  CPLPAGE_MOUSE_PTRMOTION   =  2;


//-----------------------------------------------------------------------------
// Keyboard Control Panel Extensions
// The following constants MAY be passed in IShellPropSheetExt::ReplacePage's
// uPageID parameter for servers registered under
//                                  ( REGSTR_PATH_CONTROLSFOLDER "\\Keyboard" )
//-----------------------------------------------------------------------------
const
  CPLPAGE_KEYBOARD_SPEED    =  1;

///////////////////////////////////////////////////////////////////////////////


implementation

end.
