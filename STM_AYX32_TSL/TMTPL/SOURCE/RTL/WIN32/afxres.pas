(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       AFXRES unit                                            *)
(*       Based on afxres.h                                      *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995-98 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

unit AFXRES;

// This is a part of the Microsoft Foundation Classes C++ library.
// Copyright (C) 1992-1998 Microsoft Corporation
// All rights reserved.
//
// This source code is only intended as a supplement to the
// Microsoft Foundation Classes Reference and related
// electronic documentation provided with the library.
// See these sources for detailed information regarding the
// Microsoft Foundation Classes product.

interface

uses Windows;

// Macro for mapping standard control bars to bitmask (limit of 32)
 function AFX_CONTROLBAR_MASK(nIDC: DWORD): DWORD;

const
/////////////////////////////////////////////////////////////////////////////
// MFC resource types (see Technical note TN024 for implementation details)

 RT_DLGINIT = MAKEINTRESOURCE(240);
 RT_TOOLBAR = MAKEINTRESOURCE(241);

/////////////////////////////////////////////////////////////////////////////
// General style bits etc

// ControlBar styles
 CBRS_ALIGN_LEFT   =  $1000;
 CBRS_ALIGN_TOP    =  $2000;
 CBRS_ALIGN_RIGHT  =  $4000;
 CBRS_ALIGN_BOTTOM =  $8000;
 CBRS_ALIGN_ANY    =  $F000;

 CBRS_BORDER_LEFT  =  $0100;
 CBRS_BORDER_TOP   =  $0200;
 CBRS_BORDER_RIGHT =  $0400;
 CBRS_BORDER_BOTTOM=  $0800;
 CBRS_BORDER_ANY   =  $0F00;

 CBRS_TOOLTIPS     =  $0010;
 CBRS_FLYBY        =  $0020;
 CBRS_FLOAT_MULTI  =  $0040;
 CBRS_BORDER_3D    =  $0080;
 CBRS_HIDE_INPLACE =  $0008;
 CBRS_SIZE_DYNAMIC =  $0004;
 CBRS_SIZE_FIXED   =  $0002;
 CBRS_FLOATING     =  $0001;

 CBRS_GRIPPER      =  $00400000;

 CBRS_ORIENT_HORZ  =  (CBRS_ALIGN_TOP or CBRS_ALIGN_BOTTOM);
 CBRS_ORIENT_VERT  =  (CBRS_ALIGN_LEFT or CBRS_ALIGN_RIGHT);
 CBRS_ORIENT_ANY   =  (CBRS_ORIENT_HORZ or CBRS_ORIENT_VERT);

 CBRS_ALL          =  $0040FFFF;

// the CBRS_ style is made up of an alignment style and a draw border style
//  the alignment styles are mutually exclusive
//  the draw border styles may be combined
 CBRS_NOALIGN      =  $00000000;
 CBRS_LEFT         =  (CBRS_ALIGN_LEFT or CBRS_BORDER_RIGHT);
 CBRS_TOP          =  (CBRS_ALIGN_TOP or CBRS_BORDER_BOTTOM);
 CBRS_RIGHT        =  (CBRS_ALIGN_RIGHT or CBRS_BORDER_LEFT);
 CBRS_BOTTOM       =  (CBRS_ALIGN_BOTTOM or CBRS_BORDER_TOP);

/////////////////////////////////////////////////////////////////////////////
// Standard window components

// Mode indicators in status bar - these are routed like commands
 ID_INDICATOR_EXT  =              $E700;  // extended selection indicator
 ID_INDICATOR_CAPS =              $E701;  // cap lock indicator
 ID_INDICATOR_NUM  =              $E702;  // num lock indicator
 ID_INDICATOR_SCRL =              $E703;  // scroll lock indicator
 ID_INDICATOR_OVR  =              $E704;  // overtype mode indicator
 ID_INDICATOR_REC  =              $E705;  // record mode indicator
 ID_INDICATOR_KANA =              $E706;  // kana lock indicator

 ID_SEPARATOR      =              0;   // special separator value

// Standard control bars (IDW = window ID)
 AFX_IDW_CONTROLBAR_FIRST     =   $E800;
 AFX_IDW_CONTROLBAR_LAST      =   $E8FF;

 AFX_IDW_TOOLBAR              =   $E800;  // main Toolbar for window
 AFX_IDW_STATUS_BAR           =   $E801;  // Status bar window
 AFX_IDW_PREVIEW_BAR          =   $E802;  // PrintPreview Dialog Bar
 AFX_IDW_RESIZE_BAR           =   $E803;  // OLE in-place resize bar
 AFX_IDW_REBAR                =   $E804;  // COMCTL32 "rebar" Bar
 AFX_IDW_DIALOGBAR            =   $E805;  // CDialogBar

// Note: If your application supports docking toolbars, you should
//  not use the following IDs for your own toolbars.  The IDs chosen
//  are at the top of the first 32 such that the bars will be hidden
//  while in print preview mode, and are not likely to conflict with
//  IDs your application may have used succesfully in the past.

 AFX_IDW_DOCKBAR_TOP          =   $E81B;
 AFX_IDW_DOCKBAR_LEFT         =   $E81C;
 AFX_IDW_DOCKBAR_RIGHT        =   $E81D;
 AFX_IDW_DOCKBAR_BOTTOM       =   $E81E;
 AFX_IDW_DOCKBAR_FLOAT        =   $E81F;

// parts of Main Frame
 AFX_IDW_PANE_FIRST           =   $E900;  // first pane (256 max)
 AFX_IDW_PANE_LAST            =   $E9ff;
 AFX_IDW_HSCROLL_FIRST        =   $EA00;  // first Horz scrollbar (16 max)
 AFX_IDW_VSCROLL_FIRST        =   $EA10;  // first Vert scrollbar (16 max)

 AFX_IDW_SIZE_BOX             =   $EA20;  // size box for splitters
 AFX_IDW_PANE_SAVE            =   $EA21;  // to shift AFX_IDW_PANE_FIRST

// common style for form views
 AFX_WS_DEFAULT_VIEW          =   WS_CHILD  or  WS_VISIBLE  or  WS_BORDER;

/////////////////////////////////////////////////////////////////////////////
// Standard app configurable strings

// for application title (defaults to EXE name or name in constructor)
 AFX_IDS_APP_TITLE            =   $E000;
// idle message bar line
 AFX_IDS_IDLEMESSAGE          =   $E001;
// message bar line when in shift-F1 help mode
 AFX_IDS_HELPMODEMESSAGE      =   $E002;
// document title when editing OLE embedding
 AFX_IDS_APP_TITLE_EMBEDDING  =   $E003;
// company name
 AFX_IDS_COMPANY_NAME         =   $E004;
// object name when server is inplace
 AFX_IDS_OBJ_TITLE_INPLACE    =   $E005;

/////////////////////////////////////////////////////////////////////////////
// Standard Commands

// File commands
 ID_FILE_NEW                  =   $E100;
 ID_FILE_OPEN                 =   $E101;
 ID_FILE_CLOSE                =   $E102;
 ID_FILE_SAVE                 =   $E103;
 ID_FILE_SAVE_AS              =   $E104;
 ID_FILE_PAGE_SETUP           =   $E105;
 ID_FILE_PRINT_SETUP          =   $E106;
 ID_FILE_PRINT                =   $E107;
 ID_FILE_PRINT_DIRECT         =   $E108;
 ID_FILE_PRINT_PREVIEW        =   $E109;
 ID_FILE_UPDATE               =   $E10A;
 ID_FILE_SAVE_COPY_AS         =   $E10B;
 ID_FILE_SEND_MAIL            =   $E10C;

 ID_FILE_MRU_FIRST            =   $E110;
 ID_FILE_MRU_FILE1            =   $E110;          // range - 16 max
 ID_FILE_MRU_FILE2            =   $E111;
 ID_FILE_MRU_FILE3            =   $E112;
 ID_FILE_MRU_FILE4            =   $E113;
 ID_FILE_MRU_FILE5            =   $E114;
 ID_FILE_MRU_FILE6            =   $E115;
 ID_FILE_MRU_FILE7            =   $E116;
 ID_FILE_MRU_FILE8            =   $E117;
 ID_FILE_MRU_FILE9            =   $E118;
 ID_FILE_MRU_FILE10           =   $E119;
 ID_FILE_MRU_FILE11           =   $E11A;
 ID_FILE_MRU_FILE12           =   $E11B;
 ID_FILE_MRU_FILE13           =   $E11C;
 ID_FILE_MRU_FILE14           =   $E11D;
 ID_FILE_MRU_FILE15           =   $E11E;
 ID_FILE_MRU_FILE16           =   $E11F;
 ID_FILE_MRU_LAST             =   $E11F;

// Edit commands
 ID_EDIT_CLEAR                =   $E120;
 ID_EDIT_CLEAR_ALL            =   $E121;
 ID_EDIT_COPY                 =   $E122;
 ID_EDIT_CUT                  =   $E123;
 ID_EDIT_FIND                 =   $E124;
 ID_EDIT_PASTE                =   $E125;
 ID_EDIT_PASTE_LINK           =   $E126;
 ID_EDIT_PASTE_SPECIAL        =   $E127;
 ID_EDIT_REPEAT               =   $E128;
 ID_EDIT_REPLACE              =   $E129;
 ID_EDIT_SELECT_ALL           =   $E12A;
 ID_EDIT_UNDO                 =   $E12B;
 ID_EDIT_REDO                 =   $E12C;

// Window commands
 ID_WINDOW_NEW                =   $E130;
 ID_WINDOW_ARRANGE            =   $E131;
 ID_WINDOW_CASCADE            =   $E132;
 ID_WINDOW_TILE_HORZ          =   $E133;
 ID_WINDOW_TILE_VERT          =   $E134;
 ID_WINDOW_SPLIT              =   $E135;
 AFX_IDM_WINDOW_FIRST         =   $E130;
 AFX_IDM_WINDOW_LAST          =   $E13F;
 AFX_IDM_FIRST_MDICHILD       =   $FF00;  // window list starts here

// Help and App commands
 ID_APP_ABOUT                 =   $E140;
 ID_APP_EXIT                  =   $E141;
 ID_HELP_INDEX                =   $E142;
 ID_HELP_FINDER               =   $E143;
 ID_HELP_USING                =   $E144;
 ID_CONTEXT_HELP              =   $E145;      // shift-F1
// special commands for processing help
 ID_HELP                      =   $E146;      // first attempt for F1
 ID_DEFAULT_HELP              =   $E147;      // last attempt

// Misc
 ID_NEXT_PANE                 =   $E150;
 ID_PREV_PANE                 =   $E151;

// Format
 ID_FORMAT_FONT               =   $E160;

// OLE commands
 ID_OLE_INSERT_NEW            =   $E200;
 ID_OLE_EDIT_LINKS            =   $E201;
 ID_OLE_EDIT_CONVERT          =   $E202;
 ID_OLE_EDIT_CHANGE_ICON      =   $E203;
 ID_OLE_EDIT_PROPERTIES       =   $E204;
 ID_OLE_VERB_FIRST            =   $E210;     // range - 16 max
 ID_OLE_VERB_LAST             =   $E21F;

// for print preview dialog bar
 AFX_ID_PREVIEW_CLOSE         =   $E300;
 AFX_ID_PREVIEW_NUMPAGE       =   $E301;      // One/Two Page button
 AFX_ID_PREVIEW_NEXT          =   $E302;
 AFX_ID_PREVIEW_PREV          =   $E303;
 AFX_ID_PREVIEW_PRINT         =   $E304;
 AFX_ID_PREVIEW_ZOOMIN        =   $E305;
 AFX_ID_PREVIEW_ZOOMOUT       =   $E306;

// View commands (same number used as IDW used for control bar)
 ID_VIEW_TOOLBAR              =   $E800;
 ID_VIEW_STATUS_BAR           =   $E801;
 ID_VIEW_REBAR                =   $E804;
 ID_VIEW_AUTOARRANGE          =   $E805;
// E810 -> E81F must be kept in order for RANGE macros
 ID_VIEW_SMALLICON            =   $E810;
 ID_VIEW_LARGEICON            =   $E811;
 ID_VIEW_LIST                 =   $E812;
 ID_VIEW_DETAILS              =   $E813;
 ID_VIEW_LINEUP               =   $E814;
 ID_VIEW_BYNAME               =   $E815;
 AFX_ID_VIEW_MINIMUM          =   ID_VIEW_SMALLICON;
 AFX_ID_VIEW_MAXIMUM          =   ID_VIEW_BYNAME;
// E800 -> E8FF reserved for other control bar commands

// RecordForm commands
 ID_RECORD_FIRST              =   $E900;
 ID_RECORD_LAST               =   $E901;
 ID_RECORD_NEXT               =   $E902;
 ID_RECORD_PREV               =   $E903;

/////////////////////////////////////////////////////////////////////////////
// Standard control IDs

 IDC_STATIC                   =  (-1);     // all static controls

/////////////////////////////////////////////////////////////////////////////
// Standard string error/warnings

 AFX_IDS_SCFIRST              =   $EF00;

 AFX_IDS_SCSIZE               =   $EF00;
 AFX_IDS_SCMOVE               =   $EF01;
 AFX_IDS_SCMINIMIZE           =   $EF02;
 AFX_IDS_SCMAXIMIZE           =   $EF03;
 AFX_IDS_SCNEXTWINDOW         =   $EF04;
 AFX_IDS_SCPREVWINDOW         =   $EF05;
 AFX_IDS_SCCLOSE              =   $EF06;
 AFX_IDS_SCRESTORE            =   $EF12;
 AFX_IDS_SCTASKLIST           =   $EF13;

 AFX_IDS_MDICHILD             =   $EF1F;

 AFX_IDS_DESKACCESSORY        =   $EFDA;

// General strings
 AFX_IDS_OPENFILE             =   $F000;
 AFX_IDS_SAVEFILE             =   $F001;
 AFX_IDS_ALLFILTER            =   $F002;
 AFX_IDS_UNTITLED             =   $F003;
 AFX_IDS_SAVEFILECOPY         =   $F004;
 AFX_IDS_PREVIEW_CLOSE        =   $F005;
 AFX_IDS_UNNAMED_FILE         =   $F006;
 AFX_IDS_HIDE                 =   $F011;

// MFC Standard Exception Error messages
 AFX_IDP_NO_ERROR_AVAILABLE     = $F020;
 AFX_IDS_NOT_SUPPORTED_EXCEPTION= $F021;
 AFX_IDS_RESOURCE_EXCEPTION     = $F022;
 AFX_IDS_MEMORY_EXCEPTION       = $F023;
 AFX_IDS_USER_EXCEPTION         = $F024;

// Printing and print preview strings
 AFX_IDS_PRINTONPORT            = $F040;
 AFX_IDS_ONEPAGE                = $F041;
 AFX_IDS_TWOPAGE                = $F042;
 AFX_IDS_PRINTPAGENUM           = $F043;
 AFX_IDS_PREVIEWPAGEDESC        = $F044;
 AFX_IDS_PRINTDEFAULTEXT        = $F045;
 AFX_IDS_PRINTDEFAULT           = $F046;
 AFX_IDS_PRINTFILTER            = $F047;
 AFX_IDS_PRINTCAPTION           = $F048;
 AFX_IDS_PRINTTOFILE            = $F049;


// OLE strings
 AFX_IDS_OBJECT_MENUITEM        = $F080;
 AFX_IDS_EDIT_VERB              = $F081;
 AFX_IDS_ACTIVATE_VERB          = $F082;
 AFX_IDS_CHANGE_LINK            = $F083;
 AFX_IDS_AUTO                   = $F084;
 AFX_IDS_MANUAL                 = $F085;
 AFX_IDS_FROZEN                 = $F086;
 AFX_IDS_ALL_FILES              = $F087;
// dynamically changing menu items
 AFX_IDS_SAVE_MENU              = $F088;
 AFX_IDS_UPDATE_MENU            = $F089;
 AFX_IDS_SAVE_AS_MENU           = $F08A;
 AFX_IDS_SAVE_COPY_AS_MENU      = $F08B;
 AFX_IDS_EXIT_MENU              = $F08C;
 AFX_IDS_UPDATING_ITEMS         = $F08D;
// COlePasteSpecialDialog defines
 AFX_IDS_METAFILE_FORMAT        = $F08E;
 AFX_IDS_DIB_FORMAT             = $F08F;
 AFX_IDS_BITMAP_FORMAT          = $F090;
 AFX_IDS_LINKSOURCE_FORMAT      = $F091;
 AFX_IDS_EMBED_FORMAT           = $F092;
// other OLE utility strings
 AFX_IDS_PASTELINKEDTYPE        = $F094;
 AFX_IDS_UNKNOWNTYPE            = $F095;
 AFX_IDS_RTF_FORMAT             = $F096;
 AFX_IDS_TEXT_FORMAT            = $F097;
// OLE datatype format error strings
 AFX_IDS_INVALID_CURRENCY       = $F098;
 AFX_IDS_INVALID_DATETIME       = $F099;
 AFX_IDS_INVALID_DATETIMESPAN   = $F09A;

// General error / prompt strings
 AFX_IDP_INVALID_FILENAME       = $F100;
 AFX_IDP_FAILED_TO_OPEN_DOC     = $F101;
 AFX_IDP_FAILED_TO_SAVE_DOC     = $F102;
 AFX_IDP_ASK_TO_SAVE            = $F103;
 AFX_IDP_FAILED_TO_CREATE_DOC   = $F104;
 AFX_IDP_FILE_TOO_LARGE         = $F105;
 AFX_IDP_FAILED_TO_START_PRINT  = $F106;
 AFX_IDP_FAILED_TO_LAUNCH_HELP  = $F107;
 AFX_IDP_INTERNAL_FAILURE       = $F108;      // general failure
 AFX_IDP_COMMAND_FAILURE        = $F109;      // command failure
 AFX_IDP_FAILED_MEMORY_ALLOC    = $F10A;
 AFX_IDP_UNREG_DONE             = $F10B;
 AFX_IDP_UNREG_FAILURE          = $F10C;
 AFX_IDP_DLL_LOAD_FAILED        = $F10D;
 AFX_IDP_DLL_BAD_VERSION        = $F10E;

// DDV parse errors
 AFX_IDP_PARSE_INT              = $F110;
 AFX_IDP_PARSE_REAL             = $F111;
 AFX_IDP_PARSE_INT_RANGE        = $F112;
 AFX_IDP_PARSE_REAL_RANGE       = $F113;
 AFX_IDP_PARSE_STRING_SIZE      = $F114;
 AFX_IDP_PARSE_RADIO_BUTTON     = $F115;
 AFX_IDP_PARSE_BYTE             = $F116;
 AFX_IDP_PARSE_UINT             = $F117;
 AFX_IDP_PARSE_DATETIME         = $F118;
 AFX_IDP_PARSE_CURRENCY         = $F119;

// CFile/CArchive error strings for user failure
 AFX_IDP_FAILED_INVALID_FORMAT  = $F120;
 AFX_IDP_FAILED_INVALID_PATH    = $F121;
 AFX_IDP_FAILED_DISK_FULL       = $F122;
 AFX_IDP_FAILED_ACCESS_READ     = $F123;
 AFX_IDP_FAILED_ACCESS_WRITE    = $F124;
 AFX_IDP_FAILED_IO_ERROR_READ   = $F125;
 AFX_IDP_FAILED_IO_ERROR_WRITE  = $F126;

// OLE errors / prompt strings
 AFX_IDP_STATIC_OBJECT          = $F180;
 AFX_IDP_FAILED_TO_CONNECT      = $F181;
 AFX_IDP_SERVER_BUSY            = $F182;
 AFX_IDP_BAD_VERB               = $F183;
 AFX_IDS_NOT_DOCOBJECT          = $F184;
 AFX_IDP_FAILED_TO_NOTIFY       = $F185;
 AFX_IDP_FAILED_TO_LAUNCH       = $F186;
 AFX_IDP_ASK_TO_UPDATE          = $F187;
 AFX_IDP_FAILED_TO_UPDATE       = $F188;
 AFX_IDP_FAILED_TO_REGISTER     = $F189;
 AFX_IDP_FAILED_TO_AUTO_REGISTER= $F18A;
 AFX_IDP_FAILED_TO_CONVERT      = $F18B;
 AFX_IDP_GET_NOT_SUPPORTED      = $F18C;
 AFX_IDP_SET_NOT_SUPPORTED      = $F18D;
 AFX_IDP_ASK_TO_DISCARD         = $F18E;
 AFX_IDP_FAILED_TO_CREATE       = $F18F;

// MAPI errors / prompt strings
 AFX_IDP_FAILED_MAPI_LOAD       = $F190;
 AFX_IDP_INVALID_MAPI_DLL       = $F191;
 AFX_IDP_FAILED_MAPI_SEND       = $F192;

 AFX_IDP_FILE_NONE              = $F1A0;
 AFX_IDP_FILE_GENERIC           = $F1A1;
 AFX_IDP_FILE_NOT_FOUND         = $F1A2;
 AFX_IDP_FILE_BAD_PATH          = $F1A3;
 AFX_IDP_FILE_TOO_MANY_OPEN     = $F1A4;
 AFX_IDP_FILE_ACCESS_DENIED     = $F1A5;
 AFX_IDP_FILE_INVALID_FILE      = $F1A6;
 AFX_IDP_FILE_REMOVE_CURRENT    = $F1A7;
 AFX_IDP_FILE_DIR_FULL          = $F1A8;
 AFX_IDP_FILE_BAD_SEEK          = $F1A9;
 AFX_IDP_FILE_HARD_IO           = $F1AA;
 AFX_IDP_FILE_SHARING           = $F1AB;
 AFX_IDP_FILE_LOCKING           = $F1AC;
 AFX_IDP_FILE_DISKFULL          = $F1AD;
 AFX_IDP_FILE_EOF               = $F1AE;

 AFX_IDP_ARCH_NONE              = $F1B0;
 AFX_IDP_ARCH_GENERIC           = $F1B1;
 AFX_IDP_ARCH_READONLY          = $F1B2;
 AFX_IDP_ARCH_ENDOFFILE         = $F1B3;
 AFX_IDP_ARCH_WRITEONLY         = $F1B4;
 AFX_IDP_ARCH_BADINDEX          = $F1B5;
 AFX_IDP_ARCH_BADCLASS          = $F1B6;
 AFX_IDP_ARCH_BADSCHEMA         = $F1B7;

 AFX_IDS_OCC_SCALEUNITS_PIXELS  = $F1C0;

// $f200-$f20f reserved

// font names and point sizes
 AFX_IDS_STATUS_FONT            = $F230;
 AFX_IDS_TOOLTIP_FONT           = $F231;
 AFX_IDS_UNICODE_FONT           = $F232;
 AFX_IDS_MINI_FONT              = $F233;

// ODBC Database errors / prompt strings
 AFX_IDP_SQL_FIRST                          = $F280;
 AFX_IDP_SQL_CONNECT_FAIL                   = $F281;
 AFX_IDP_SQL_RECORDSET_FORWARD_ONLY         = $F282;
 AFX_IDP_SQL_EMPTY_COLUMN_LIST              = $F283;
 AFX_IDP_SQL_FIELD_SCHEMA_MISMATCH          = $F284;
 AFX_IDP_SQL_ILLEGAL_MODE                   = $F285;
 AFX_IDP_SQL_MULTIPLE_ROWS_AFFECTED         = $F286;
 AFX_IDP_SQL_NO_CURRENT_RECORD              = $F287;
 AFX_IDP_SQL_NO_ROWS_AFFECTED               = $F288;
 AFX_IDP_SQL_RECORDSET_READONLY             = $F289;
 AFX_IDP_SQL_SQL_NO_TOTAL                   = $F28A;
 AFX_IDP_SQL_ODBC_LOAD_FAILED               = $F28B;
 AFX_IDP_SQL_DYNASET_NOT_SUPPORTED          = $F28C;
 AFX_IDP_SQL_SNAPSHOT_NOT_SUPPORTED         = $F28D;
 AFX_IDP_SQL_API_CONFORMANCE                = $F28E;
 AFX_IDP_SQL_SQL_CONFORMANCE                = $F28F;
 AFX_IDP_SQL_NO_DATA_FOUND                  = $F290;
 AFX_IDP_SQL_ROW_UPDATE_NOT_SUPPORTED       = $F291;
 AFX_IDP_SQL_ODBC_V2_REQUIRED               = $F292;
 AFX_IDP_SQL_NO_POSITIONED_UPDATES          = $F293;
 AFX_IDP_SQL_LOCK_MODE_NOT_SUPPORTED        = $F294;
 AFX_IDP_SQL_DATA_TRUNCATED                 = $F295;
 AFX_IDP_SQL_ROW_FETCH                      = $F296;
 AFX_IDP_SQL_INCORRECT_ODBC                 = $F297;
 AFX_IDP_SQL_UPDATE_DELETE_FAILED           = $F298;
 AFX_IDP_SQL_DYNAMIC_CURSOR_NOT_SUPPORTED   = $F299;
 AFX_IDP_SQL_FIELD_NOT_FOUND                = $F29A;
 AFX_IDP_SQL_BOOKMARKS_NOT_SUPPORTED        = $F29B;
 AFX_IDP_SQL_BOOKMARKS_NOT_ENABLED          = $F29C;

// ODBC Database strings
 AFX_IDS_DELETED                        = $F29D;

// DAO Database errors / prompt strings
 AFX_IDP_DAO_FIRST                      = $F2B0;
 AFX_IDP_DAO_ENGINE_INITIALIZATION      = $F2B0;
 AFX_IDP_DAO_DFX_BIND                   = $F2B1;
 AFX_IDP_DAO_OBJECT_NOT_OPEN            = $F2B2;

// ICDAORecordset::GetRows Errors
//  These are not placed in DAO Errors collection
//  and must be handled directly by MFC.
 AFX_IDP_DAO_ROWTOOSHORT                = $F2B3;
 AFX_IDP_DAO_BADBINDINFO                = $F2B4;
 AFX_IDP_DAO_COLUMNUNAVAILABLE          = $F2B5;

/////////////////////////////////////////////////////////////////////////////
// Strings for ISAPI support

 AFX_IDS_HTTP_TITLE             = $F2D1;
 AFX_IDS_HTTP_NO_TEXT           = $F2D2;
 AFX_IDS_HTTP_BAD_REQUEST       = $F2D3;
 AFX_IDS_HTTP_AUTH_REQUIRED     = $F2D4;
 AFX_IDS_HTTP_FORBIDDEN         = $F2D5;
 AFX_IDS_HTTP_NOT_FOUND         = $F2D6;
 AFX_IDS_HTTP_SERVER_ERROR      = $F2D7;
 AFX_IDS_HTTP_NOT_IMPLEMENTED   = $F2D8;

/////////////////////////////////////////////////////////////////////////////
// AFX implementation - control IDs (AFX_IDC)

// Parts of dialogs
 AFX_IDC_LISTBOX                = 100;
 AFX_IDC_CHANGE                 = 101;

// for print dialog
 AFX_IDC_PRINT_DOCNAME          = 201;
 AFX_IDC_PRINT_PRINTERNAME      = 202;
 AFX_IDC_PRINT_PORTNAME         = 203;
 AFX_IDC_PRINT_PAGENUM          = 204;

// Property Sheet control id's (determined with Spy++)
 ID_APPLY_NOW                   = $3021;
 ID_WIZBACK                     = $3023;
 ID_WIZNEXT                     = $3024;
 ID_WIZFINISH                   = $3025;
 AFX_IDC_TAB_CONTROL            = $3020;

/////////////////////////////////////////////////////////////////////////////
// IDRs for standard components

// These are really COMMDLG dialogs, so there usually isn't a resource
// for them, but these IDs are used as help IDs.
 AFX_IDD_FILEOPEN               = 28676;
 AFX_IDD_FILESAVE               = 28677;
 AFX_IDD_FONT                   = 28678;
 AFX_IDD_COLOR                  = 28679;
 AFX_IDD_PRINT                  = 28680;
 AFX_IDD_PRINTSETUP             = 28681;
 AFX_IDD_FIND                   = 28682;
 AFX_IDD_REPLACE                = 28683;

// Standard dialogs app should leave alone ($7801->)
 AFX_IDD_NEWTYPEDLG             = 30721;
 AFX_IDD_PRINTDLG               = 30722;
 AFX_IDD_PREVIEW_TOOLBAR        = 30723;

// Dialogs defined for OLE2UI library
 AFX_IDD_INSERTOBJECT           = 30724;
 AFX_IDD_CHANGEICON             = 30725;
 AFX_IDD_CONVERT                = 30726;
 AFX_IDD_PASTESPECIAL           = 30727;
 AFX_IDD_EDITLINKS              = 30728;
 AFX_IDD_FILEBROWSE             = 30729;
 AFX_IDD_BUSY                   = 30730;

 AFX_IDD_OBJECTPROPERTIES       = 30732;
 AFX_IDD_CHANGESOURCE           = 30733;

// Standard cursors ($7901->)
// AFX_IDC = Cursor resources
 AFX_IDC_CONTEXTHELP            = 30977;       // context sensitive help
 AFX_IDC_MAGNIFY                = 30978;       // print preview zoom
 AFX_IDC_SMALLARROWS            = 30979;       // splitter
 AFX_IDC_HSPLITBAR              = 30980;       // splitter
 AFX_IDC_VSPLITBAR              = 30981;       // splitter
 AFX_IDC_NODROPCRSR             = 30982;       // No Drop Cursor
 AFX_IDC_TRACKNWSE              = 30983;       // tracker
 AFX_IDC_TRACKNESW              = 30984;       // tracker
 AFX_IDC_TRACKNS                = 30985;       // tracker
 AFX_IDC_TRACKWE                = 30986;       // tracker
 AFX_IDC_TRACK4WAY              = 30987;       // tracker
 AFX_IDC_MOVE4WAY               = 30988;       // resize bar (server only)

// Mini frame window bitmap ID
 AFX_IDB_MINIFRAME_MENU         = 30994;

// CheckListBox checks bitmap ID
 AFX_IDB_CHECKLISTBOX_NT        = 30995;
 AFX_IDB_CHECKLISTBOX_95        = 30996;

// AFX standard accelerator resources
 AFX_IDR_PREVIEW_ACCEL          = 30997;

// AFX standard ICON IDs (for MFC V1 apps) ($7A01->)
 AFX_IDI_STD_MDIFRAME           = 31233;
 AFX_IDI_STD_FRAME              = 31234;

/////////////////////////////////////////////////////////////////////////////
// AFX OLE control implementation - control IDs (AFX_IDC)

// Font property page
 AFX_IDC_FONTPROP               = 1000;
 AFX_IDC_FONTNAMES              = 1001;
 AFX_IDC_FONTSTYLES             = 1002;
 AFX_IDC_FONTSIZES              = 1003;
 AFX_IDC_STRIKEOUT              = 1004;
 AFX_IDC_UNDERLINE              = 1005;
 AFX_IDC_SAMPLEBOX              = 1006;

// Color property page
 AFX_IDC_COLOR_BLACK            = 1100;
 AFX_IDC_COLOR_WHITE            = 1101;
 AFX_IDC_COLOR_RED              = 1102;
 AFX_IDC_COLOR_GREEN            = 1103;
 AFX_IDC_COLOR_BLUE             = 1104;
 AFX_IDC_COLOR_YELLOW           = 1105;
 AFX_IDC_COLOR_MAGENTA          = 1106;
 AFX_IDC_COLOR_CYAN             = 1107;
 AFX_IDC_COLOR_GRAY             = 1108;
 AFX_IDC_COLOR_LIGHTGRAY        = 1109;
 AFX_IDC_COLOR_DARKRED          = 1110;
 AFX_IDC_COLOR_DARKGREEN        = 1111;
 AFX_IDC_COLOR_DARKBLUE         = 1112;
 AFX_IDC_COLOR_LIGHTBROWN       = 1113;
 AFX_IDC_COLOR_DARKMAGENTA      = 1114;
 AFX_IDC_COLOR_DARKCYAN         = 1115;
 AFX_IDC_COLORPROP              = 1116;
 AFX_IDC_SYSTEMCOLORS           = 1117;

// Picture porperty page
 AFX_IDC_PROPNAME               = 1201;
 AFX_IDC_PICTURE                = 1202;
 AFX_IDC_BROWSE                 = 1203;
 AFX_IDC_CLEAR                  = 1204;

/////////////////////////////////////////////////////////////////////////////
// IDRs for OLE control standard components

// Standard propery page dialogs app should leave alone ($7E01->)
 AFX_IDD_PROPPAGE_COLOR        = 32257;
 AFX_IDD_PROPPAGE_FONT         = 32258;
 AFX_IDD_PROPPAGE_PICTURE      = 32259;

 AFX_IDB_TRUETYPE              = 32384;

/////////////////////////////////////////////////////////////////////////////
// Standard OLE control strings

// OLE Control page strings
 AFX_IDS_PROPPAGE_UNKNOWN       = $FE01;
 AFX_IDS_COLOR_DESKTOP          = $FE04;
 AFX_IDS_COLOR_APPWORKSPACE     = $FE05;
 AFX_IDS_COLOR_WNDBACKGND       = $FE06;
 AFX_IDS_COLOR_WNDTEXT          = $FE07;
 AFX_IDS_COLOR_MENUBAR          = $FE08;
 AFX_IDS_COLOR_MENUTEXT         = $FE09;
 AFX_IDS_COLOR_ACTIVEBAR        = $FE0A;
 AFX_IDS_COLOR_INACTIVEBAR      = $FE0B;
 AFX_IDS_COLOR_ACTIVETEXT       = $FE0C;
 AFX_IDS_COLOR_INACTIVETEXT     = $FE0D;
 AFX_IDS_COLOR_ACTIVEBORDER     = $FE0E;
 AFX_IDS_COLOR_INACTIVEBORDER   = $FE0F;
 AFX_IDS_COLOR_WNDFRAME         = $FE10;
 AFX_IDS_COLOR_SCROLLBARS       = $FE11;
 AFX_IDS_COLOR_BTNFACE          = $FE12;
 AFX_IDS_COLOR_BTNSHADOW        = $FE13;
 AFX_IDS_COLOR_BTNTEXT          = $FE14;
 AFX_IDS_COLOR_BTNHIGHLIGHT     = $FE15;
 AFX_IDS_COLOR_DISABLEDTEXT     = $FE16;
 AFX_IDS_COLOR_HIGHLIGHT        = $FE17;
 AFX_IDS_COLOR_HIGHLIGHTTEXT    = $FE18;
 AFX_IDS_REGULAR                = $FE19;
 AFX_IDS_BOLD                   = $FE1A;
 AFX_IDS_ITALIC                 = $FE1B;
 AFX_IDS_BOLDITALIC             = $FE1C;
 AFX_IDS_SAMPLETEXT             = $FE1D;
 AFX_IDS_DISPLAYSTRING_FONT     = $FE1E;
 AFX_IDS_DISPLAYSTRING_COLOR    = $FE1F;
 AFX_IDS_DISPLAYSTRING_PICTURE  = $FE20;
 AFX_IDS_PICTUREFILTER          = $FE21;
 AFX_IDS_PICTYPE_UNKNOWN        = $FE22;
 AFX_IDS_PICTYPE_NONE           = $FE23;
 AFX_IDS_PICTYPE_BITMAP         = $FE24;
 AFX_IDS_PICTYPE_METAFILE       = $FE25;
 AFX_IDS_PICTYPE_ICON           = $FE26;
 AFX_IDS_COLOR_PPG              = $FE28;
 AFX_IDS_COLOR_PPG_CAPTION      = $FE29;
 AFX_IDS_FONT_PPG               = $FE2A;
 AFX_IDS_FONT_PPG_CAPTION       = $FE2B;
 AFX_IDS_PICTURE_PPG            = $FE2C;
 AFX_IDS_PICTURE_PPG_CAPTION    = $FE2D;
 AFX_IDS_PICTUREBROWSETITLE     = $FE30;
 AFX_IDS_BORDERSTYLE_0          = $FE31;
 AFX_IDS_BORDERSTYLE_1          = $FE32;

// OLE Control verb names
 AFX_IDS_VERB_EDIT              = $FE40;
 AFX_IDS_VERB_PROPERTIES        = $FE41;

// OLE Control internal error messages
 AFX_IDP_PICTURECANTOPEN        = $FE83;
 AFX_IDP_PICTURECANTLOAD        = $FE84;
 AFX_IDP_PICTURETOOLARGE        = $FE85;
 AFX_IDP_PICTUREREADFAILED      = $FE86;

// Standard OLE Control error strings
 AFX_IDP_E_ILLEGALFUNCTIONCALL      = $FEA0;
 AFX_IDP_E_OVERFLOW                 = $FEA1;
 AFX_IDP_E_OUTOFMEMORY              = $FEA2;
 AFX_IDP_E_DIVISIONBYZERO           = $FEA3;
 AFX_IDP_E_OUTOFSTRINGSPACE         = $FEA4;
 AFX_IDP_E_OUTOFSTACKSPACE          = $FEA5;
 AFX_IDP_E_BADFILENAMEORNUMBER      = $FEA6;
 AFX_IDP_E_FILENOTFOUND             = $FEA7;
 AFX_IDP_E_BADFILEMODE              = $FEA8;
 AFX_IDP_E_FILEALREADYOPEN          = $FEA9;
 AFX_IDP_E_DEVICEIOERROR            = $FEAA;
 AFX_IDP_E_FILEALREADYEXISTS        = $FEAB;
 AFX_IDP_E_BADRECORDLENGTH          = $FEAC;
 AFX_IDP_E_DISKFULL                 = $FEAD;
 AFX_IDP_E_BADRECORDNUMBER          = $FEAE;
 AFX_IDP_E_BADFILENAME              = $FEAF;
 AFX_IDP_E_TOOMANYFILES             = $FEB0;
 AFX_IDP_E_DEVICEUNAVAILABLE        = $FEB1;
 AFX_IDP_E_PERMISSIONDENIED         = $FEB2;
 AFX_IDP_E_DISKNOTREADY             = $FEB3;
 AFX_IDP_E_PATHFILEACCESSERROR      = $FEB4;
 AFX_IDP_E_PATHNOTFOUND             = $FEB5;
 AFX_IDP_E_INVALIDPATTERNSTRING     = $FEB6;
 AFX_IDP_E_INVALIDUSEOFNULL         = $FEB7;
 AFX_IDP_E_INVALIDFILEFORMAT        = $FEB8;
 AFX_IDP_E_INVALIDPROPERTYVALUE     = $FEB9;
 AFX_IDP_E_INVALIDPROPERTYARRAYINDEX= $FEBA;
 AFX_IDP_E_SETNOTSUPPORTEDATRUNTIME = $FEBB;
 AFX_IDP_E_SETNOTSUPPORTED          = $FEBC;
 AFX_IDP_E_NEEDPROPERTYARRAYINDEX   = $FEBD;
 AFX_IDP_E_SETNOTPERMITTED          = $FEBE;
 AFX_IDP_E_GETNOTSUPPORTEDATRUNTIME = $FEBF;
 AFX_IDP_E_GETNOTSUPPORTED          = $FEC0;
 AFX_IDP_E_PROPERTYNOTFOUND         = $FEC1;
 AFX_IDP_E_INVALIDCLIPBOARDFORMAT   = $FEC2;
 AFX_IDP_E_INVALIDPICTURE           = $FEC3;
 AFX_IDP_E_PRINTERERROR             = $FEC4;
 AFX_IDP_E_CANTSAVEFILETOTEMP       = $FEC5;
 AFX_IDP_E_SEARCHTEXTNOTFOUND       = $FEC6;
 AFX_IDP_E_REPLACEMENTSTOOLONG      = $FEC7;

/////////////////////////////////////////////////////////////////////////////

implementation

function AFX_CONTROLBAR_MASK(nIDC: DWORD): DWORD;
begin
   Result := 1 shl (nIDC - AFX_IDW_CONTROLBAR_FIRST);
end;

end.
