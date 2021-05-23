(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit API Interface Unit                       *)
(*       Based on dde.h and winuser.h                           *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995-98 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit Messages;

interface

uses Windows;

const
 WM_DDE_FIRST                           = $03E0;
 WM_DDE_INITIATE                        = WM_DDE_FIRST;
 WM_DDE_TERMINATE                       = WM_DDE_FIRST+1;
 WM_DDE_ADVISE                          = WM_DDE_FIRST+2;
 WM_DDE_UNADVISE                        = WM_DDE_FIRST+3;
 WM_DDE_ACK                             = WM_DDE_FIRST+4;
 WM_DDE_DATA                            = WM_DDE_FIRST+5;
 WM_DDE_REQUEST                         = WM_DDE_FIRST+6;
 WM_DDE_POKE                            = WM_DDE_FIRST+7;
 WM_DDE_EXECUTE                         = WM_DDE_FIRST+8;
 WM_DDE_LAST                            = WM_DDE_FIRST+8;
 WM_NULL                                = $0000;
 WM_CREATE                              = $0001;
 WM_DESTROY                             = $0002;
 WM_MOVE                                = $0003;
 WM_SIZE                                = $0005;
 WM_ACTIVATE                            = $0006;
 WM_SETFOCUS                            = $0007;
 WM_KILLFOCUS                           = $0008;
 WM_ENABLE                              = $000A;
 WM_SETREDRAW                           = $000B;
 WM_SETTEXT                             = $000C;
 WM_GETTEXT                             = $000D;
 WM_GETTEXTLENGTH                       = $000E;
 WM_PAINT                               = $000F;
 WM_CLOSE                               = $0010;
 WM_QUERYENDSESSION                     = $0011;
 WM_QUIT                                = $0012;
 WM_QUERYOPEN                           = $0013;
 WM_ERASEBKGND                          = $0014;
 WM_SYSCOLORCHANGE                      = $0015;
 WM_ENDSESSION                          = $0016;
 WM_SYSTEMERROR                         = $0017;
 WM_SHOWWINDOW                          = $0018;
 WM_CTLCOLOR                            = $0019;
 WM_WININICHANGE                        = $001A;
 WM_SETTINGCHANGE                       = WM_WININICHANGE;
 WM_DEVMODECHANGE                       = $001B;
 WM_ACTIVATEAPP                         = $001C;
 WM_FONTCHANGE                          = $001D;
 WM_TIMECHANGE                          = $001E;
 WM_CANCELMODE                          = $001F;
 WM_SETCURSOR                           = $0020;
 WM_MOUSEACTIVATE                       = $0021;
 WM_CHILDACTIVATE                       = $0022;
 WM_QUEUESYNC                           = $0023;
 WM_GETMINMAXINFO                       = $0024;
 WM_PAINTICON                           = $0026;
 WM_ICONERASEBKGND                      = $0027;
 WM_NEXTDLGCTL                          = $0028;
 WM_SPOOLERSTATUS                       = $002A;
 WM_DRAWITEM                            = $002B;
 WM_MEASUREITEM                         = $002C;
 WM_DELETEITEM                          = $002D;
 WM_VKEYTOITEM                          = $002E;
 WM_CHARTOITEM                          = $002F;
 WM_SETFONT                             = $0030;
 WM_GETFONT                             = $0031;
 WM_SETHOTKEY                           = $0032;
 WM_GETHOTKEY                           = $0033;
 WM_QUERYDRAGICON                       = $0037;
 WM_COMPAREITEM                         = $0039;
 WM_COMPACTING                          = $0041;
 WM_COMMNOTIFY                          = $0044;
 WM_WINDOWPOSCHANGING                   = $0046;
 WM_WINDOWPOSCHANGED                    = $0047;
 WM_POWER                               = $0048;
 WM_COPYDATA                            = $004A;
 WM_CANCELJOURNAL                       = $004B;
 WM_NOTIFY                              = $004E;
 WM_INPUTLANGCHANGEREQUEST              = $0050;
 WM_INPUTLANGCHANGE                     = $0051;
 WM_TCARD                               = $0052;
 WM_HELP                                = $0053;
 WM_USERCHANGED                         = $0054;
 WM_NOTIFYFORMAT                        = $0055;
 WM_CONTEXTMENU                         = $007B;
 WM_STYLECHANGING                       = $007C;
 WM_STYLECHANGED                        = $007D;
 WM_DISPLAYCHANGE                       = $007E;
 WM_GETICON                             = $007F;
 WM_SETICON                             = $0080;
 WM_NCCREATE                            = $0081;
 WM_NCDESTROY                           = $0082;
 WM_NCCALCSIZE                          = $0083;
 WM_NCHITTEST                           = $0084;
 WM_NCPAINT                             = $0085;
 WM_NCACTIVATE                          = $0086;
 WM_GETDLGCODE                          = $0087;
 WM_NCMOUSEMOVE                         = $00A0;
 WM_NCLBUTTONDOWN                       = $00A1;
 WM_NCLBUTTONUP                         = $00A2;
 WM_NCLBUTTONDBLCLK                     = $00A3;
 WM_NCRBUTTONDOWN                       = $00A4;
 WM_NCRBUTTONUP                         = $00A5;
 WM_NCRBUTTONDBLCLK                     = $00A6;
 WM_NCMBUTTONDOWN                       = $00A7;
 WM_NCMBUTTONUP                         = $00A8;
 WM_NCMBUTTONDBLCLK                     = $00A9;
 WM_KEYFIRST                            = $0100;
 WM_KEYDOWN                             = $0100;
 WM_KEYUP                               = $0101;
 WM_CHAR                                = $0102;
 WM_DEADCHAR                            = $0103;
 WM_SYSKEYDOWN                          = $0104;
 WM_SYSKEYUP                            = $0105;
 WM_SYSCHAR                             = $0106;
 WM_SYSDEADCHAR                         = $0107;
 WM_KEYLAST                             = $0108;
 WM_INITDIALOG                          = $0110;
 WM_COMMAND                             = $0111;
 WM_SYSCOMMAND                          = $0112;
 WM_TIMER                               = $0113;
 WM_HSCROLL                             = $0114;
 WM_VSCROLL                             = $0115;
 WM_INITMENU                            = $0116;
 WM_INITMENUPOPUP                       = $0117;
 WM_MENUSELECT                          = $011F;
 WM_MENUCHAR                            = $0120;
 WM_ENTERIDLE                           = $0121;
 WM_CTLCOLORMSGBOX                      = $0132;
 WM_CTLCOLOREDIT                        = $0133;
 WM_CTLCOLORLISTBOX                     = $0134;
 WM_CTLCOLORBTN                         = $0135;
 WM_CTLCOLORDLG                         = $0136;
 WM_CTLCOLORSCROLLBAR                   = $0137;
 WM_CTLCOLORSTATIC                      = $0138;
 WM_MOUSEFIRST                          = $0200;
 WM_MOUSEMOVE                           = $0200;
 WM_LBUTTONDOWN                         = $0201;
 WM_LBUTTONUP                           = $0202;
 WM_LBUTTONDBLCLK                       = $0203;
 WM_RBUTTONDOWN                         = $0204;
 WM_RBUTTONUP                           = $0205;
 WM_RBUTTONDBLCLK                       = $0206;
 WM_MBUTTONDOWN                         = $0207;
 WM_MBUTTONUP                           = $0208;
 WM_MBUTTONDBLCLK                       = $0209;
 WM_MOUSEWHEEL                          = $020A;
 WM_MOUSELAST                           = $020A;
 WM_PARENTNOTIFY                        = $0210;
 WM_ENTERMENULOOP                       = $0211;
 WM_EXITMENULOOP                        = $0212;
 WM_NEXTMENU                            = $0213;
 WM_SIZING                              = $0214;
 WM_CAPTURECHANGED                      = $0215;
 WM_MOVING                              = $0216;
 WM_POWERBROADCAST                      = $0218;
 WM_DEVICECHANGE                        = $0219;
 WM_IME_STARTCOMPOSITION                = $010D;
 WM_IME_ENDCOMPOSITION                  = $010E;
 WM_IME_COMPOSITION                     = $010F;
 WM_IME_KEYLAST                         = $010F;
 WM_IME_SETCONTEXT                      = $0281;
 WM_IME_NOTIFY                          = $0282;
 WM_IME_CONTROL                         = $0283;
 WM_IME_COMPOSITIONFULL                 = $0284;
 WM_IME_SELECT                          = $0285;
 WM_IME_CHAR                            = $0286;
 WM_IME_KEYDOWN                         = $0290;
 WM_IME_KEYUP                           = $0291;
 WM_MDICREATE                           = $0220;
 WM_MDIDESTROY                          = $0221;
 WM_MDIACTIVATE                         = $0222;
 WM_MDIRESTORE                          = $0223;
 WM_MDINEXT                             = $0224;
 WM_MDIMAXIMIZE                         = $0225;
 WM_MDITILE                             = $0226;
 WM_MDICASCADE                          = $0227;
 WM_MDIICONARRANGE                      = $0228;
 WM_MDIGETACTIVE                        = $0229;
 WM_MDISETMENU                          = $0230;
 WM_ENTERSIZEMOVE                       = $0231;
 WM_EXITSIZEMOVE                        = $0232;
 WM_DROPFILES                           = $0233;
 WM_MDIREFRESHMENU                      = $0234;
 WM_MOUSEHOVER                          = $02A1;
 WM_MOUSELEAVE                          = $02A3;
 WM_CUT                                 = $0300;
 WM_COPY                                = $0301;
 WM_PASTE                               = $0302;
 WM_CLEAR                               = $0303;
 WM_UNDO                                = $0304;
 WM_RENDERFORMAT                        = $0305;
 WM_RENDERALLFORMATS                    = $0306;
 WM_DESTROYCLIPBOARD                    = $0307;
 WM_DRAWCLIPBOARD                       = $0308;
 WM_PAINTCLIPBOARD                      = $0309;
 WM_VSCROLLCLIPBOARD                    = $030A;
 WM_SIZECLIPBOARD                       = $030B;
 WM_ASKCBFORMATNAME                     = $030C;
 WM_CHANGECBCHAIN                       = $030D;
 WM_HSCROLLCLIPBOARD                    = $030E;
 WM_QUERYNEWPALETTE                     = $030F;
 WM_PALETTEISCHANGING                   = $0310;
 WM_PALETTECHANGED                      = $0311;
 WM_HOTKEY                              = $0312;
 WM_PRINT                               = $0317;
 WM_PRINTCLIENT                         = $0318;
 WM_HANDHELDFIRST                       = $0319;
 WM_HANDHELDLAST                        = $0320;
 WM_PENWINFIRST                         = $0380;
 WM_PENWINLAST                          = $038F;
 WM_COALESCE_FIRST                      = $0390;
 WM_COALESCE_LAST                       = $039F;
 WM_APP                                 = $8000;
 WM_USER                                = $0400;

 BN_CLICKED       = 0;
 BN_PAINT         = 1;
 BN_HILITE        = 2;
 BN_UNHILITE      = 3;
 BN_DISABLE       = 4;
 BN_DOUBLECLICKED = 5;
 BN_PUSHED        = BN_HILITE;
 BN_UNPUSHED      = BN_UNHILITE;
 BN_DBLCLK        = BN_DOUBLECLICKED;
 BN_SETFOCUS      = 6;
 BN_KILLFOCUS     = 7;

 BM_GETCHECK    = $00F0;
 BM_SETCHECK    = $00F1;
 BM_GETSTATE    = $00F2;
 BM_SETSTATE    = $00F3;
 BM_SETSTYLE    = $00F4;
 BM_CLICK       = $00F5;
 BM_GETIMAGE    = $00F6;
 BM_SETIMAGE    = $00F7;

 LBN_ERRSPACE            = -2;
 LBN_SELCHANGE           = 1;
 LBN_DBLCLK              = 2;
 LBN_SELCANCEL           = 3;
 LBN_SETFOCUS            = 4;
 LBN_KILLFOCUS           = 5;

 LB_ADDSTRING            = $0180;
 LB_INSERTSTRING         = $0181;
 LB_DELETESTRING         = $0182;
 LB_SELITEMRANGEEX       = $0183;
 LB_RESETCONTENT         = $0184;
 LB_SETSEL               = $0185;
 LB_SETCURSEL            = $0186;
 LB_GETSEL               = $0187;
 LB_GETCURSEL            = $0188;
 LB_GETTEXT              = $0189;
 LB_GETTEXTLEN           = $018A;
 LB_GETCOUNT             = $018B;
 LB_SELECTSTRING         = $018C;
 LB_DIR                  = $018D;
 LB_GETTOPINDEX          = $018E;
 LB_FINDSTRING           = $018F;
 LB_GETSELCOUNT          = $0190;
 LB_GETSELITEMS          = $0191;
 LB_SETTABSTOPS          = $0192;
 LB_GETHORIZONTALEXTENT  = $0193;
 LB_SETHORIZONTALEXTENT  = $0194;
 LB_SETCOLUMNWIDTH       = $0195;
 LB_ADDFILE              = $0196;
 LB_SETTOPINDEX          = $0197;
 LB_GETITEMRECT          = $0198;
 LB_GETITEMDATA          = $0199;
 LB_SETITEMDATA          = $019A;
 LB_SELITEMRANGE         = $019B;
 LB_SETANCHORINDEX       = $019C;
 LB_GETANCHORINDEX       = $019D;
 LB_SETCARETINDEX        = $019E;
 LB_GETCARETINDEX        = $019F;
 LB_SETITEMHEIGHT        = $01A0;
 LB_GETITEMHEIGHT        = $01A1;
 LB_FINDSTRINGEXACT      = $01A2;
 LB_SETLOCALE            = $01A5;
 LB_GETLOCALE            = $01A6;
 LB_SETCOUNT             = $01A7;
 LB_INITSTORAGE          = $01A8;
 LB_ITEMFROMPOINT        = $01A9;
 LB_MSGMAX               = 432;

 CBN_ERRSPACE            = -1;
 CBN_SELCHANGE           = 1;
 CBN_DBLCLK              = 2;
 CBN_SETFOCUS            = 3;
 CBN_KILLFOCUS           = 4;
 CBN_EDITCHANGE          = 5;
 CBN_EDITUPDATE          = 6;
 CBN_DROPDOWN            = 7;
 CBN_CLOSEUP             = 8;
 CBN_SELENDOK            = 9;
 CBN_SELENDCANCEL        = 10;

 CB_GETEDITSEL            = $0140;
 CB_LIMITTEXT             = $0141;
 CB_SETEDITSEL            = $0142;
 CB_ADDSTRING             = $0143;
 CB_DELETESTRING          = $0144;
 CB_DIR                   = $0145;
 CB_GETCOUNT              = $0146;
 CB_GETCURSEL             = $0147;
 CB_GETLBTEXT             = $0148;
 CB_GETLBTEXTLEN          = $0149;
 CB_INSERTSTRING          = $014A;
 CB_RESETCONTENT          = $014B;
 CB_FINDSTRING            = $014C;
 CB_SELECTSTRING          = $014D;
 CB_SETCURSEL             = $014E;
 CB_SHOWDROPDOWN          = $014F;
 CB_GETITEMDATA           = $0150;
 CB_SETITEMDATA           = $0151;
 CB_GETDROPPEDCONTROLRECT = $0152;
 CB_SETITEMHEIGHT         = $0153;
 CB_GETITEMHEIGHT         = $0154;
 CB_SETEXTENDEDUI         = $0155;
 CB_GETEXTENDEDUI         = $0156;
 CB_GETDROPPEDSTATE       = $0157;
 CB_FINDSTRINGEXACT       = $0158;
 CB_SETLOCALE             = 345;
 CB_GETLOCALE             = 346;
 CB_GETTOPINDEX           = 347;
 CB_SETTOPINDEX           = 348;
 CB_GETHORIZONTALEXTENT   = 349;
 CB_SETHORIZONTALEXTENT   = 350;
 CB_GETDROPPEDWIDTH       = 351;
 CB_SETDROPPEDWIDTH       = 352;
 CB_INITSTORAGE           = 353;
 CB_MSGMAX                = 354;

 EN_SETFOCUS              = $0100;
 EN_KILLFOCUS             = $0200;
 EN_CHANGE                = $0300;
 EN_UPDATE                = $0400;
 EN_ERRSPACE              = $0500;
 EN_MAXTEXT               = $0501;
 EN_HSCROLL               = $0601;
 EN_VSCROLL               = $0602;

 EM_GETSEL              = $00B0;
 EM_SETSEL              = $00B1;
 EM_GETRECT             = $00B2;
 EM_SETRECT             = $00B3;
 EM_SETRECTNP           = $00B4;
 EM_SCROLL              = $00B5;
 EM_LINESCROLL          = $00B6;
 EM_SCROLLCARET         = $00B7;
 EM_GETMODIFY           = $00B8;
 EM_SETMODIFY           = $00B9;
 EM_GETLINECOUNT        = $00BA;
 EM_LINEINDEX           = $00BB;
 EM_SETHANDLE           = $00BC;
 EM_GETHANDLE           = $00BD;
 EM_GETTHUMB            = $00BE;
 EM_LINELENGTH          = $00C1;
 EM_REPLACESEL          = $00C2;
 EM_GETLINE             = $00C4;
 EM_LIMITTEXT           = $00C5;
 EM_CANUNDO             = $00C6;
 EM_UNDO                = $00C7;
 EM_FMTLINES            = $00C8;
 EM_LINEFROMCHAR        = $00C9;
 EM_SETTABSTOPS         = $00CB;
 EM_SETPASSWORDCHAR     = $00CC;
 EM_EMPTYUNDOBUFFER     = $00CD;
 EM_GETFIRSTVISIBLELINE = $00CE;
 EM_SETREADONLY         = $00CF;
 EM_SETWORDBREAKPROC    = $00D0;
 EM_GETWORDBREAKPROC    = $00D1;
 EM_GETPASSWORDCHAR     = $00D2;
 EM_SETMARGINS          = 211;
 EM_GETMARGINS          = 212;
 EM_SETLIMITTEXT        = EM_LIMITTEXT;
 EM_GETLIMITTEXT        = 213;
 EM_POSFROMCHAR         = 214;
 EM_CHARFROMPOS         = 215;

 SBM_SETPOS             = 224;
 SBM_GETPOS             = 225;
 SBM_SETRANGE           = 226;
 SBM_SETRANGEREDRAW     = 230;
 SBM_GETRANGE           = 227;
 SBM_ENABLE_ARROWS      = 228;
 SBM_SETSCROLLINFO      = 233;
 SBM_GETSCROLLINFO      = 234;

 DM_GETDEFID            = WM_USER;
 DM_SETDEFID            = WM_USER+1;
 DM_REPOSITION          = WM_USER+2;

 PSM_PAGEINFO           = WM_USER+100;
 PSM_SHEETINFO          = WM_USER+101;

type
  PMessage = ^TMessage;
  TMessage = record
    Msg: DWord;
    case DWORD of
     0: (
         WParam: Longint;
         LParam: Longint;
         Result: Longint
        );
     1: (
         WParamLo: Word;
         WParamHi: Word;
         LParamLo: Word;
         LParamHi: Word;
         ResultLo: Word;
         ResultHi: Word
         );
  end;

  TWMNoParams = record
    Msg: DWord;
    Unused: array[0..3] of Word;
    Result: Longint;
  end;

  TWMKey = record
    Msg: DWord;
    CharCode: Word;
    Unused: Word;
    KeyData: Longint;
    Result: Longint;
  end;

  TWMMouse = record
    Msg: DWord;
    Keys: Longint;
    case DWORD of
     0: (
         XPos: Smallint;
         YPos: Smallint
        );
     1: (
         Pos: TSmallPoint;
         Result: Longint
        );
  end;

  TWMWindowPosMsg = record
    Msg: DWord;
    Unused: DWORD;
    WindowPos: PWindowPos;
    Result: Longint;
  end;

  TWMScroll = record
    Msg: DWord;
    ScrollCode: Smallint;
    Pos: Smallint;
    ScrollBar: HWND;
    Result: Longint;
  end;

  TWMActivate = record
    Msg: DWord;
    Active: Word;
    Minimized: WordBool;
    ActiveWindow: HWND;
    Result: Longint;
  end;

  TWMActivateApp = record
    Msg: DWord;
    Active: Bool;
    ThreadId: Longint;
    Result: Longint;
  end;

  TWMAskCBFormatName = record
    Msg: DWord;
    NameLen: Word;
    Unused: Word;
    FormatName: PChar;
    Result: Longint;
  end;

  TWMCancelMode = TWMNoParams;

  TWMChangeCBChain = record
    Msg: DWord;
    Remove: HWND;
    Next: HWND;
    Result: Longint;
  end;

  TWMChar = TWMKey;

  TWMCharToItem = record
    Msg: DWord;
    Key: Word;
    CaretPos: Word;
    ListBox: HWND;
    Result: Longint;
  end;

  TWMChildActivate = TWMNoParams;

  TWMChooseFont_GetLogFont = record
    Msg: DWord;
    Unused: Longint;
    LogFont: PLogFont;
    Result: Longint;
  end;

  TWMClear = TWMNoParams;
  TWMClose = TWMNoParams;

  TWMCommand = record
    Msg: DWord;
    ItemID: Word;
    NotifyCode: Word;
    Ctl: HWND;
    Result: Longint;
  end;

  TWMCompacting = record
    Msg: DWord;
    CompactRatio: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMCompareItem = record
    Msg: DWord;
    Ctl: HWnd;
    CompareItemStruct: PCompareItemStruct;
    Result: Longint;
  end;

  TWMCopy = TWMNoParams;

  TWMCopyData = record
    Msg: DWord;
    From: HWND;
    CopyDataStruct: PCopyDataStruct;
    Result: Longint;
  end;

  TWMCreate = record
    Msg: DWord;
    Unused: DWORD;
    CreateStruct: PCreateStruct;
    Result: Longint;
  end;

  TWMCtlColor = record
    Msg: DWord;
    ChildDC: HDC;
    ChildWnd: HWND;
    Result: Longint;
  end;

  TWMCtlColorBtn = TWMCtlColor;
  TWMCtlColorDlg = TWMCtlColor;
  TWMCtlColorEdit = TWMCtlColor;
  TWMCtlColorListbox = TWMCtlColor;
  TWMCtlColorMsgbox = TWMCtlColor;
  TWMCtlColorScrollbar = TWMCtlColor;
  TWMCtlColorStatic = TWMCtlColor;

  TWMCut = TWMNoParams;

  TWMDDE_Ack = record
    Msg: DWord;
    PostingApp: HWND;
    case Word of
      WM_DDE_INITIATE:
      (
        App: Word;
        Topic: Word;
        Result: Longint
      );
      WM_DDE_EXECUTE :
      (
        PackedVal: Longint
      );
  end;

  TWMDDE_Advise = record
    Msg: DWord;
    PostingApp: HWND;
    PackedVal: Longint;
    Result: Longint;
  end;

  TWMDDE_Data = record
    Msg: DWord;
    PostingApp: HWND;
    PackedVal: Longint;
    Result: Longint;
  end;

  TWMDDE_Execute = record
    Msg: DWord;
    PostingApp: HWND;
    Commands: THandle;
    Result: Longint;
  end;

  TWMDDE_Initiate = record
    Msg: DWord;
    PostingApp: HWND;
    App: Word;
    Topic: Word;
    Result: Longint;
  end;

  TWMDDE_Poke = record
    Msg: DWord;
    PostingApp: HWND;
    PackedVal: Longint;
    Result: Longint;
  end;

  TWMDDE_Request = record
    Msg: DWord;
    PostingApp: HWND;
    Format: Word;
    Item: Word;
    Result: Longint;
  end;

  TWMDDE_Terminate = record
    Msg: DWord;
    PostingApp: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMDDE_Unadvise = record
    Msg: DWord;
    PostingApp: HWND;
    Format: Word;
    Item: Word;
    Result: Longint;
  end;

  TWMDeadChar = TWMChar;

  TWMDeleteItem = record
    Msg: DWord;
    Ctl: HWND;
    DeleteItemStruct: PDeleteItemStruct;
    Result: Longint;
  end;

  TWMDestroy = TWMNoParams;
  TWMDestroyClipboard = TWMNoParams;

  TWMDevModeChange = record
    Msg: DWord;
    Unused: DWORD;
    Device: PChar;
    Result: Longint;
  end;

  TWMDrawClipboard = TWMNoParams;

  TWMDrawItem = record
    Msg: DWord;
    Ctl: HWND;
    DrawItemStruct: PDrawItemStruct;
    Result: Longint;
  end;

  TWMDropFiles = record
    Msg: DWord;
    Drop: THANDLE;
    Unused: Longint;
    Result: Longint;
  end;

  TWMEnable = record
    Msg: DWord;
    Enabled: Bool;
    Unused: Longint;
    Result: Longint;
  end;

  TWMEndSession = record
    Msg: DWord;
    EndSession: Bool;
    Unused: Longint;
    Result: Longint;
  end;

  TWMEnterIdle = record
    Msg: DWord;
    Source: Longint;
    IdleWnd: HWND;
    Result: Longint;
  end;

  TWMEnterMenuLoop = record
    Msg: DWord;
    IsTrackPopupMenu: Bool;
    Unused: Longint;
    Result: Longint;
  end;

  TWMExitMenuLoop = TWMEnterMenuLoop;

  TWMEraseBkgnd = record
    Msg: DWord;
    DC: HDC;
    Unused: Longint;
    Result: Longint;
  end;

  TWMFontChange = TWMNoParams;
  TWMGetDlgCode = TWMNoParams;
  TWMGetFont = TWMNoParams;

  TWMGetIcon = record
    Msg: DWord;
    BigIcon: Bool;
    Unused: Longint;
    Result: Longint;
  end;

  TWMGetHotKey = TWMNoParams;

  TWMGetMinMaxInfo = record
    Msg: DWord;
    Unused: DWORD;
    MinMaxInfo: PMinMaxInfo;
    Result: Longint;
  end;

  TWMGetText = record
    Msg: DWord;
    TextMax: DWORD;
    Text: PChar;
    Result: Longint;
  end;

  TWMGetTextLength = TWMNoParams;

  TWMHotKey = record
    Msg: DWord;
    HotKey: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMHScroll = TWMScroll;

  TWMHScrollClipboard = record
    Msg: DWord;
    Viewer: HWND;
    ScrollCode: Word;
    Pos: Word;
    Result: Longint;
  end;

  TWMIconEraseBkgnd = TWMEraseBkgnd;

  TWMInitDialog = record
    Msg: DWord;
    Focus: HWND;
    InitParam: Longint;
    Result: Longint;
  end;

  TWMInitMenu = record
    Msg: DWord;
    Menu: HMENU;
    Unused: Longint;
    Result: Longint;
  end;

  TWMInitMenuPopup = record
    Msg: DWord;
    MenuPopup: HMENU;
    Pos: Smallint;
    SystemMenu: WordBool;
    Result: Longint;
  end;

  TWMKeyDown = TWMKey;
  TWMKeyUp = TWMKey;

  TWMKillFocus = record
    Msg: DWord;
    FocusedWnd: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMLButtonDblClk = TWMMouse;
  TWMLButtonDown   = TWMMouse;
  TWMLButtonUp     = TWMMouse;
  TWMMButtonDblClk = TWMMouse;
  TWMMButtonDown   = TWMMouse;
  TWMMButtonUp     = TWMMouse;

  TWMMDIActivate = record
    Msg: DWord;
    case DWORD of
     0: (ChildWnd: HWND);
     1: (DeactiveWnd: HWND;
         ActiveWnd: HWND;
         Result: Longint);
  end;

  TWMMDICascade = record
    Msg: DWord;
    Cascade: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMMDICreate = record
    Msg: DWord;
    Unused: DWORD;
    MDICreateStruct: PMDICreateStruct;
    Result: Longint;
  end;

  TWMMDIDestroy = record
    Msg: DWord;
    Child: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMMDIGetActive = TWMNoParams;
  TWMMDIIconArrange = TWMNoParams;

  TWMMDIMaximize = record
    Msg: DWord;
    Maximize: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMMDINext = record
    Msg: DWord;
    Child: HWND;
    Next: Longint;
    Result: Longint;
  end;

  TWMMDIRefreshMenu = TWMNoParams;

  TWMMDIRestore = record
    Msg: DWord;
    IDChild: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMMDISetMenu = record
    Msg: DWord;
    MenuFrame: HMENU;
    MenuWindow: HMENU;
    Result: Longint;
  end;

  TWMMDITile = record
    Msg: DWord;
    Tile: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMMeasureItem = record
    Msg: DWord;
    IDCtl: HWnd;
    MeasureItemStruct: PMeasureItemStruct;
    Result: Longint;
  end;

  TWMMenuChar = record
    Msg: DWord;
    User: Char;
    Unused: Byte;
    MenuFlag: Word;
    Menu: HMENU;
    Result: Longint;
  end;

  TWMMenuSelect = record
    Msg: DWord;
    IDItem: Word;
    MenuFlag: Word;
    Menu: HMENU;
    Result: Longint;
  end;

  TWMMouseActivate = record
    Msg: DWord;
    TopLevel: HWND;
    HitTestCode: Word;
    MouseMsg: Word;
    Result: Longint;
  end;

  TWMMouseMove = TWMMouse;

  TWMMove = record
    Msg: DWord;
    Unused: DWORD;
    case DWORD of
     0: (
         XPos: Smallint;
         YPos: Smallint
        );
     1: (
         Pos: TSmallPoint;
         Result: Longint
        );
  end;

  TWMNCActivate = record
    Msg: DWord;
    Active: Bool;
    Unused: Longint;
    Result: Longint;
  end;

  TWMNCCalcSize = record
    Msg: DWord;
    CalcValidRects: Bool;
    CalcSize_Params: PNCCalcSizeParams;
    Result: Longint;
  end;

  TWMNCCreate = record
    Msg: DWord;
    Unused: DWORD;
    CreateStruct: PCreateStruct;
    Result: Longint;
  end;

  TWMNCDestroy = TWMNoParams;

  TWMNCHitTest = record
    Msg: DWord;
    Unused: Longint;
    case DWORD of
      0: (XPos: Smallint;
          YPos: Smallint);
      1: (Pos: TSmallPoint;
          Result: Longint);
  end;

  TWMNCHitMessage = record
    Msg: DWord;
    HitTest: Longint;
    XCursor: Smallint;
    YCursor: Smallint;
    Result: Longint;
  end;

  TWMNCLButtonDblClk = TWMNCHitMessage;
  TWMNCLButtonDown   = TWMNCHitMessage;
  TWMNCLButtonUp     = TWMNCHitMessage;
  TWMNCMButtonDblClk = TWMNCHitMessage;
  TWMNCMButtonDown   = TWMNCHitMessage;
  TWMNCMButtonUp     = TWMNCHitMessage;
  TWMNCMouseMove     = TWMNCHitMessage;
  TWMNCPaint         = TWMNoParams;
  TWMNCRButtonDblClk = TWMNCHitMessage;
  TWMNCRButtonDown   = TWMNCHitMessage;
  TWMNCRButtonUp     = TWMNCHitMessage;

  TWMNextDlgCtl = record
    Msg: DWord;
    CtlFocus: Longint;
    Handle: WordBool;
    Unused: Word;
    Result: Longint;
  end;

  TWMNotify = record
    Msg: DWord;
    IDCtrl: Longint;
    NMHdr: PNMHdr;
    Result: Longint;
  end;

  TWMNotifyFormat = record
    Msg: DWord;
    From: HWND;
    Command: Longint;
    Result: Longint;
  end;

  TWMPaint = record
    Msg: DWord;
    DC: HDC;
    Unused: Longint;
    Result: Longint;
  end;

  TWMPaintClipboard = record
    Msg: DWord;
    Viewer: HWND;
    PaintStruct: THandle;
    Result: Longint;
  end;

  TWMPaintIcon = TWMNoParams;

  TWMPaletteChanged = record
    Msg: DWord;
    PalChg: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMPaletteIsChanging = record
    Msg: DWord;
    Realize: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMParentNotify = record
    Msg: DWord;
    case Event: Word of
      WM_CREATE, WM_DESTROY:
      (
        ChildID: Word;
        ChildWnd: HWnd
      );
      WM_LBUTTONDOWN, WM_MBUTTONDOWN, WM_RBUTTONDOWN:
      (
        Value: Word;
        XPos: Smallint;
        YPos: Smallint
      );
      0:
      (
        Value1: Word;
        Value2: Longint;
        Result: Longint
      );
  end;

  TWMPaste = TWMNoParams;

  TWMPower = record
    Msg: DWord;
    PowerEvt: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMQueryDragIcon = TWMNoParams;

  TWMQueryEndSession = record
    Msg: DWord;
    Source: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMQueryNewPalette = TWMNoParams;
  TWMQueryOpen = TWMNoParams;
  TWMQueueSync = TWMNoParams;

  TWMQuit = record
    Msg: DWord;
    ExitCode: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMRButtonDblClk = TWMMouse;
  TWMRButtonDown = TWMMouse;
  TWMRButtonUp = TWMMouse;

  TWMRenderAllFormats = TWMNoParams;

  TWMRenderFormat = record
    Msg: DWord;
    Format: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMSetCursor = record
    Msg: DWord;
    CursorWnd: HWND;
    HitTest: Word;
    MouseMsg: Word;
    Result: Longint;
  end;

  TWMSetFocus = record
    Msg: DWord;
    FocusedWnd: HWND;
    Unused: Longint;
    Result: Longint;
  end;

  TWMSetFont = record
    Msg: DWord;
    Font: HFONT;
    Redraw: WordBool;
    Unused: Word;
    Result: Longint;
  end;

  TWMSetHotKey = record
    Msg: DWord;
    Key: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMSetIcon = record
    Msg: DWord;
    BigIcon: Bool;
    Icon: HICON;
    Result: Longint;
  end;

  TWMSetRedraw = record
    Msg: DWord;
    Redraw: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TWMSetText = record
    Msg: DWord;
    Unused: Longint;
    Text: PChar;
    Result: Longint;
  end;

  TWMShowWindow = record
    Msg: DWord;
    Show: Bool;
    Status: Longint;
    Result: Longint;
  end;

  TWMSize = record
    Msg: DWord;
    SizeType: Longint;
    Width: Word;
    Height: Word;
    Result: Longint;
  end;

  TWMSizeClipboard = record
    Msg: DWord;
    Viewer: HWND;
    RC: THandle;
    Result: Longint;
  end;

  TWMSpoolerStatus = record
    Msg: DWord;
    JobStatus: Longint;
    JobsLeft: Word;
    Unused: Word;
    Result: Longint;
  end;

  TWMStyleChange = record
    Msg: DWord;
    StyleType: Longint;
    StyleStruct: PStyleStruct;
    Result: Longint;
  end;

  TWMStyleChanged = TWMStyleChange;
  TWMStyleChanging = TWMStyleChange;

  TWMSysChar = TWMKey;
  TWMSysColorChange = TWMNoParams;

  TWMSysCommand = record
    Msg: DWord;
    case CmdType: Longint of
      SC_HOTKEY:
      (
        ActivateWnd: HWND
      );
      SC_KEYMENU:
      (
        Key: Word
      );
      SC_CLOSE, SC_HSCROLL, SC_MAXIMIZE, SC_MINIMIZE, SC_MOUSEMENU, SC_MOVE,
      SC_NEXTWINDOW, SC_PREVWINDOW, SC_RESTORE, SC_SCREENSAVE, SC_SIZE,
      SC_TASKLIST, SC_VSCROLL:
      (
        XPos: Smallint;
        YPos: Smallint;
        Result: Longint
      );
  end;

  TWMSysDeadChar = record
    Msg: DWord;
    CharCode: Word;
    Unused: Word;
    KeyData: Longint;
    Result: Longint;
  end;

  TWMSysKeyDown = TWMKey;
  TWMSysKeyUp = TWMKey;

  TWMSystemError = record
    Msg: DWord;
    ErrSpec: Word;
    Unused: Longint;
    Result: Longint;
  end;

  TWMTimeChange = TWMNoParams;

  TWMTimer = record
    Msg: DWord;
    TimerID: Longint;
    TimerProc: TFarProc;
    Result: Longint;
  end;

  TWMUndo = TWMNoParams;

  TWMVKeyToItem = TWMCharToItem;

  TWMVScroll = TWMScroll;

  TWMVScrollClipboard = record
    Msg: DWord;
    Viewer: HWND;
    ScollCode: Word;
    ThumbPos: Word;
    Result: Longint;
  end;

  TWMWindowPosChanged = TWMWindowPosMsg;
  TWMWindowPosChanging = TWMWindowPosMsg;

  TWMWinIniChange = record
    Msg: DWord;
    Unused: DWORD;
    Section: PChar;
    Result: Longint;
  end;

  TWMHelp = record
    Msg: DWord;
    Unused: DWORD;
    HelpInfo: PHelpInfo;
    Result: Longint;
  end;

  TWMDisplayChange = record
    Msg: DWord;
    BitsPerPixel: DWORD;
    Width: Word;
    Height: Word;
  end;

implementation

end.
