(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit IntelliMouse support interface unit      *)
(*       Based on zmouse.h                                      *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

unit ZMouse;

interface

uses
  Windows, Messages;

(****************************************************************************
*                                                                           *
* ZMOUSE.H -- Include file for IntelliMouse(tm) 1.0                         *
*                                                                           *
* NOTE:  Zmouse.h contains #defines required when providing IntelliMouse    *
*        wheel support for Windows95 and NT3.51.  Wheel is supported        *
*        natively in WinNT4.0, please refer to the NT4.0 SDK for more info  *
*        on providing support for IntelliMouse in NT4.0.                    *
*                                                                           *
* Copyright (c) 1983-1996, Microsoft Corp. All rights reserved.             *
*                                                                           *
****************************************************************************)


(**************************************************************************
         Client Appplication (API) Defines for Wheel rolling
***************************************************************************)


// Apps need to call RegisterWindowMessage using the #define below to
// get the message number that is sent to the foreground window
// when a wheel roll occurs

const
  MSH_MOUSEWHEEL = 'MSWHEEL_ROLLMSG';

// wParam = wheel rotation expressed in multiples of WHEEL_DELTA
// lParam is the mouse coordinates

  WHEEL_DELTA    = 120;               // Default value for rolling one notch

  WM_MOUSEWHEEL  = WM_MOUSELAST + 1;  // message that will be supported by the OS

(**************************************************************************
    Client Appplication (API) Defines for
           *  determining if wheel support active
           *  determining # of Scroll Lines
***************************************************************************)

// Class name for MSWHEEL.EXE's invisible window
// use FindWindow to get hwnd to MSWHEEL

  MOUSEZ_CLASSNAME  = 'MouseZ';           // wheel window class
  MOUSEZ_TITLE      = 'Magellan MSWHEEL'; // wheel window title

  MSH_WHEELMODULE_CLASS = MOUSEZ_CLASSNAME;
  MSH_WHEELMODULE_TITLE = MOUSEZ_TITLE;

// Apps need to call RegisterWindowMessage using the #defines
// below to get the message numbers for:
// 1) the message that can be sent to the MSWHEEL window to
//    query if wheel support is active (MSH_WHEELSUPPORT)>
// 2) the message to query for the number of scroll lines
//    (MSH_SCROLL_LINES)
//
// To send a message to MSWheel window, use FindWindow with the #defines
// for CLASS and TITLE above.  If FindWindow fails to find the MSWHEEL
// window or the return from SendMessage is false, then Wheel support
// is not currently available.

  MSH_WHEELSUPPORT = 'MSH_WHEELSUPPORT_MSG';  // name of msg to send to query for wheel support

// MSH_WHEELSUPPORT
//    wParam - not used
//    lParam - not used
//    returns BOOL - TRUE if wheel support is active, FALSE otherwise

  MSH_SCROLL_LINES = 'MSH_SCROLL_LINES_MSG';

// MSH_SCROLL_LINES
//    wParam - not used
//    lParam - not used
//    returns int  - number of lines to scroll on a wheel roll

  WHEEL_PAGESCROLL = UINT_MAX;   // signifies to scroll a page, also
                                 // defined in winuser.h in the NT4.0 SDK

  SPI_SETWHEELSCROLLLINES  = 105;      // Also defined in winuser.h in the
                                       // NT4.0 SDK, please see the NT4.0 SDK
                                       // documentation for NT4.0 implementation
                                       // specifics.
                                       // For Win95 and WinNT3.51,
                                       // Mswheel broadcasts the message
                                       // WM_SETTINGCHANGE (equivalent to
                                       // WM_WININICHANGE) when the scroll
                                       // lines has changed.  Applications
                                       // will recieve the WM_SETTINGCHANGE
                                       // message with the wParam set to
                                       // SPI_SETWHEELSCROLLLINES.  When
                                       // this message is recieved the application
                                       // should query Mswheel for the new
                                       // setting.

(*********************************************************************
* INLINE FUNCTION: HwndMsWheel
* Purpose : Get a reference to MSWheel Window, the registered messages,
*           wheel support active setting, and number of scrollLines
* Params  : PUINT puiMsh_MsgMouseWheel - address of UINT to contain returned registered wheel message
*           PUINT puiMsh_Msg3DSupport - address of UINT to contain wheel support registered message
*           PUINT puiMsh_MsgScrollLines - address of UINT to contain Scroll lines registered message
*           PBOOL pf3DSupport - address of BOOL to contain returned flag for wheel support active
*           PINT  piScrollLines - address of int to contain returned scroll lines
* Returns : HWND handle to the MsWheel window
* Note    : The return value for pf3DSupport and piScrollLines is dependant
*           on the POINT32 module.  If POINT32 module is not running then
*           the values returned for these parameters will be
*           FALSE and 3, respectively.
*********************************************************************)

function HwndMSWheel(var puiMsh_MsgMouseWheel, puiMsh_Msg3DSupport,
  puiMsh_MsgScrollLines: UINT; var pf3DSupport: BOOL;
  var piScrollLines: Longint): HWND;

implementation

function HwndMSWheel(var puiMsh_MsgMouseWheel, puiMsh_Msg3DSupport,
  puiMsh_MsgScrollLines: UINT; var pf3DSupport: BOOL;
  var piScrollLines: Longint): HWND;
var
  hdlMsWheel: HWnd;
begin
  hdlMsWheel := FindWindow(MSH_WHEELMODULE_CLASS, MSH_WHEELMODULE_TITLE);
  puiMsh_MsgMouseWheel := RegisterWindowMessage(MSH_MOUSEWHEEL);
  puiMsh_Msg3DSupport := RegisterWindowMessage(MSH_WHEELSUPPORT);
  puiMsh_MsgScrollLines := RegisterWindowMessage(MSH_SCROLL_LINES);
  if (puiMsh_Msg3DSupport <> 0) and (hdlMsWheel <> 0) then
    pf3DSupport := BOOL(SendMessage(hdlMsWheel, puiMsh_Msg3DSupport, 0, 0))
  else
    pf3DSupport := False;  // default to FALSE
  if (puiMsh_MsgScrollLines <> 0) and (hdlMsWheel <> 0) then
    piScrollLines := SendMessage(hdlMsWheel, puiMsh_MsgScrollLines, 0, 0)
  else
    piScrollLines := 3;  // default
  Result := hdlMsWheel;
end;

end.
