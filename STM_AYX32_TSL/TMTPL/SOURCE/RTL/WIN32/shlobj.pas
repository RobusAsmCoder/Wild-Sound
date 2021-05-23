(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Shell and SHFolder Objects Interface Unit              *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit ShlObj;

interface

//===========================================================================
//
// Copyright (c) Microsoft Corporation 1991-1998
//
// File: shlobj.h
//
//===========================================================================


uses Windows, Messages, CommCtrl, ActiveX, ShellAPI, RegStr,WinINet, URLMon;

const
  shell32dll  = 'shell32.dll';
  shfolderdll = 'shfolder.dll';

  CMF_NORMAL             = $00000000;
  CMF_DEFAULTONLY        = $00000001;
  CMF_VERBSONLY          = $00000002;
  CMF_EXPLORE            = $00000004;
  CMF_NOVERBS            = $00000008;
  CMF_CANRENAME          = $00000010;
  CMF_NODEFAULT          = $00000020;
  CMF_INCLUDESTATIC      = $00000040;
  CMF_RESERVED           = $FFFF0000;

  GCS_VERBA              = $00000000;
  GCS_HELPTEXTA          = $00000001;
  GCS_VALIDATEA          = $00000002;
  GCS_VERBW              = $00000004;
  GCS_HELPTEXTW          = $00000005;
  GCS_VALIDATEW          = $00000006;
  GCS_UNICODE            = $00000004;

  GCS_VERB               = GCS_VERBA;
  GCS_HELPTEXT           = GCS_HELPTEXTA;
  GCS_VALIDATE           = GCS_VALIDATEA;

  CMDSTR_NEWFOLDERA       = 'NewFolder';
  CMDSTR_VIEWLISTA        = 'ViewList';
  CMDSTR_VIEWDETAILSA     = 'ViewDetails';
  CMDSTR_NEWFOLDERW       = 'NewFolder';
  CMDSTR_VIEWLISTW        = 'ViewList';
  CMDSTR_VIEWDETAILSW     = 'ViewDetails';

  CMDSTR_NEWFOLDER        = CMDSTR_NEWFOLDERA;
  CMDSTR_VIEWLIST         = CMDSTR_VIEWLISTA;
  CMDSTR_VIEWDETAILS      = CMDSTR_VIEWDETAILSA;

  CMIC_MASK_HOTKEY        = SEE_MASK_HOTKEY;
  CMIC_MASK_ICON          = SEE_MASK_ICON;
  CMIC_MASK_FLAG_NO_UI    = SEE_MASK_FLAG_NO_UI;
  CMIC_MASK_UNICODE       = SEE_MASK_UNICODE;
  CMIC_MASK_NO_CONSOLE    = SEE_MASK_NO_CONSOLE;
  CMIC_MASK_ASYNCOK       = SEE_MASK_ASYNCOK;

  CMIC_MASK_PTINVOKE      = $20000000;

  GIL_OPENICON         = $0001;
  GIL_FORSHELL         = $0002;
  GIL_ASYNC            = $0020;
  GIL_SIMULATEDOC      = $0001;
  GIL_PERINSTANCE      = $0002;
  GIL_PERCLASS         = $0004;
  GIL_NOTFILENAME      = $0008;
  GIL_DONTCACHE        = $0010;

  ISIOI_ICONFILE            = $00000001;
  ISIOI_ICONINDEX           = $00000002;
  ISIOI_SYSIMAGELISTINDEX   = $00000004;

  SLR_NO_UI           = $0001;
  SLR_ANY_MATCH       = $0002;
  SLR_UPDATE          = $0004;
  SLR_NOUPDATE        = $0008;

  SLGP_SHORTPATH      = $0001;
  SLGP_UNCPRIORITY    = $0002;
  SLGP_RAWPATH        = $0004;

  FVSIF_RECT      = $00000001;
  FVSIF_PINNED    = $00000002;

  FVSIF_NEWFAILED = $08000000;


  FVSIF_NEWFILE   = $80000000;
  FVSIF_CANVIEWIT = $40000000;

  FCIDM_SHVIEWFIRST               = $0000;
  FCIDM_SHVIEWLAST                = $7fff;
  FCIDM_BROWSERFIRST              = $a000;
  FCIDM_BROWSERLAST               = $bf00;
  FCIDM_GLOBALFIRST               = $8000;
  FCIDM_GLOBALLAST                = $9fff;

  FCIDM_MENU_FILE                 = FCIDM_GLOBALFIRST+$0000;
  FCIDM_MENU_EDIT                 = FCIDM_GLOBALFIRST+$0040;
  FCIDM_MENU_VIEW                 = FCIDM_GLOBALFIRST+$0080;
  FCIDM_MENU_VIEW_SEP_OPTIONS     = FCIDM_GLOBALFIRST+$0081;
  FCIDM_MENU_TOOLS                = FCIDM_GLOBALFIRST+$00c0;
  FCIDM_MENU_TOOLS_SEP_GOTO       = FCIDM_GLOBALFIRST+$00c1;
  FCIDM_MENU_HELP                 = FCIDM_GLOBALFIRST+$0100;
  FCIDM_MENU_FIND                 = FCIDM_GLOBALFIRST+$0140;
  FCIDM_MENU_EXPLORE              = FCIDM_GLOBALFIRST+$0150;
  FCIDM_MENU_FAVORITES            = FCIDM_GLOBALFIRST+$0170;
  FCIDM_TOOLBAR                   = FCIDM_BROWSERFIRST + 0;
  FCIDM_STATUS                    = FCIDM_BROWSERFIRST + 1;

  IDC_OFFLINE_HAND       = 103;

  FWF_AUTOARRANGE = $0001;
  FWF_ABBREVIATEDNAMES = $0002;
  FWF_SNAPTOGRID = $0004;
  FWF_OWNERDATA = $0008;
  FWF_BESTFITWINDOW = $0010;
  FWF_DESKTOP = $0020;
  FWF_SINGLESEL = $0040;
  FWF_NOSUBFOLDERS = $0080;
  FWF_TRANSPARENT = $0100;
  FWF_NOCLIENTEDGE = $0200;
  FWF_NOSCROLL    = $0400;
  FWF_ALIGNLEFT   = $0800;
  FWF_NOICONS     = $1000;
  FWF_SINGLECLICKACTIVATE = $8000;

  FVM_ICON = 1;
  FVM_SMALLICON = 2;
  FVM_LIST = 3;
  FVM_DETAILS = 4;

  SV2GV_CURRENTVIEW     = -1;
  SV2GV_DEFAULTVIEW     = -2;

  STRRET_WSTR         = $0000;
  STRRET_OFFSET       = $0001;
  STRRET_CSTR         = $0002;

  SBSP_DEFBROWSER      = $0000;
  SBSP_SAMEBROWSER     = $0001;
  SBSP_NEWBROWSER      = $0002;

  SBSP_DEFMODE         = $0000;
  SBSP_OPENMODE        = $0010;
  SBSP_EXPLOREMODE     = $0020;

  SBSP_ABSOLUTE        = $0000;
  SBSP_RELATIVE        = $1000;
  SBSP_PARENT          = $2000;
  SBSP_NAVIGATEBACK    = $4000;
  SBSP_NAVIGATEFORWARD = $8000;

  SBSP_ALLOW_AUTONAVIGATE = $10000;

  SBSP_INITIATEDBYHLINKFRAME            = $80000000;
  SBSP_REDIRECT                         = $40000000;

  SBSP_WRITENOHISTORY     = $08000000;
  SBSP_NOAUTOSELECT       = $04000000;

  REGSTR_PATH_SPECIAL_FOLDERS         = REGSTR_PATH_EXPLORER + '\Shell Folders';
  CSIDL_DESKTOP                       = $0000;
  CSIDL_INTERNET                      = $0001;
  CSIDL_PROGRAMS                      = $0002;
  CSIDL_CONTROLS                      = $0003;
  CSIDL_PRINTERS                      = $0004;
  CSIDL_PERSONAL                      = $0005;
  CSIDL_FAVORITES                     = $0006;
  CSIDL_STARTUP                       = $0007;
  CSIDL_RECENT                        = $0008;
  CSIDL_SENDTO                        = $0009;
  CSIDL_BITBUCKET                     = $000a;
  CSIDL_STARTMENU                     = $000b;
  CSIDL_DESKTOPDIRECTORY              = $0010;
  CSIDL_DRIVES                        = $0011;
  CSIDL_NETWORK                       = $0012;
  CSIDL_NETHOOD                       = $0013;
  CSIDL_FONTS                         = $0014;
  CSIDL_TEMPLATES                     = $0015;
  CSIDL_COMMON_STARTMENU              = $0016;
  CSIDL_COMMON_PROGRAMS               = $0017;
  CSIDL_COMMON_STARTUP                = $0018;
  CSIDL_COMMON_DESKTOPDIRECTORY       = $0019;
  CSIDL_APPDATA                       = $001a;
  CSIDL_PRINTHOOD                     = $001b;
  CSIDL_ALTSTARTUP                    = $001d;
  CSIDL_COMMON_ALTSTARTUP             = $001e;
  CSIDL_COMMON_FAVORITES              = $001f;
  CSIDL_INTERNET_CACHE                = $0020;
  CSIDL_COOKIES                       = $0021;
  CSIDL_HISTORY                       = $0022;

  FCW_STATUS          = $0001;
  FCW_TOOLBAR         = $0002;
  FCW_TREE            = $0003;
  FCW_INTERNETBAR     = $0006;
  FCW_PROGRESS        = $0008;

  FCT_MERGE           = $0001;
  FCT_CONFIGABLE      = $0002;
  FCT_ADDTOEND        = $0004;

  CDBOSC_SETFOCUS         = $00000000;
  CDBOSC_KILLFOCUS        = $00000001;
  CDBOSC_SELCHANGE        = $00000002;
  CDBOSC_RENAME           = $00000003;

  SVSI_DESELECT           = $0000;
  SVSI_SELECT             = $0001;
  SVSI_EDIT               = $0003;
  SVSI_DESELECTOTHERS     = $0004;
  SVSI_ENSUREVISIBLE      = $0008;
  SVSI_FOCUSED            = $0010;
  SVSI_TRANSLATEPT        = $0020;

  SVGIO_BACKGROUND        = $00000000;
  SVGIO_SELECTION         = $00000001;
  SVGIO_ALLVIEW           = $00000002;

  BIF_RETURNONLYFSDIRS   = $0001;
  BIF_DONTGOBELOWDOMAIN  = $0002;
  BIF_STATUSTEXT         = $0004;
  BIF_RETURNFSANCESTORS  = $0008;
  BIF_EDITBOX            = $0010;
  BIF_VALIDATE           = $0020;

  BIF_BROWSEFORCOMPUTER  = $1000;
  BIF_BROWSEFORPRINTER   = $2000;
  BIF_BROWSEINCLUDEFILES = $4000;

  BFFM_INITIALIZED       = 1;
  BFFM_SELCHANGED        = 2;
  BFFM_VALIDATEFAILEDA   = 3;
  BFFM_VALIDATEFAILEDW   = 4;
  BFFM_SETSTATUSTEXTA    = WM_USER + 100;
  BFFM_ENABLEOK          = WM_USER + 101;
  BFFM_SETSELECTIONA     = WM_USER + 102;
  BFFM_SETSELECTIONW     = WM_USER + 103;
  BFFM_SETSTATUSTEXTW    = WM_USER + 104;
  BFFM_VALIDATEFAILED    = BFFM_VALIDATEFAILEDA;
  BFFM_SETSTATUSTEXT     = BFFM_SETSTATUSTEXTA;
  BFFM_SETSELECTION      = BFFM_SETSELECTIONA;

  CLSID_ShellDesktop: TGUID = (D1:$00021400; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  CLSID_ShellLink: TGUID = (D1:$00021401; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));

  FMTID_Intshcut: TGUID = (D1:$000214A0; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  FMTID_InternetSite: TGUID = (D1:$000214A1; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));

  CGID_Explorer: TGUID = (D1:$000214D0; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  CGID_ShellDocView: TGUID = (D1:$000214D1; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));

  IID_INewShortcutHookA: TGUID = (D1:$000214E1; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IShellBrowser: TGUID = (D1:$000214E2; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IShellView: TGUID = (D1:$000214E3; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IContextMenu: TGUID = (D1:$000214E4; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IShellIcon: TGUID = (D1:$000214E5; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IShellFolder: TGUID = (D1:$000214E6; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IShellExtInit: TGUID = (D1:$000214E8; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IShellPropSheetExt: TGUID = (D1:$000214E9; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IPersistFolder: TGUID = (D1:$000214EA; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IExtractIconA: TGUID = (D1:$000214EB; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IShellLinkA: TGUID = (D1:$000214EE; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IShellCopyHookA: TGUID = (D1:$000214EF; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IFileViewerA: TGUID = (D1:$000214F0; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_ICommDlgBrowser: TGUID = (D1:$000214F1; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IEnumIDList: TGUID = (D1:$000214F2; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IFileViewerSite: TGUID = (D1:$000214F3; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IContextMenu2: TGUID = (D1:$000214F4; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IShellExecuteHook: TGUID = (D1:$000214F5; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IPropSheetPage: TGUID = (D1:$000214F6; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_INewShortcutHookW: TGUID = (D1:$000214F7; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IFileViewerW: TGUID = (D1:$000214F8; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IShellLinkW: TGUID = (D1:$000214F9; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IExtractIconW: TGUID = (D1:$000214FA; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IShellExecuteHookW: TGUID = (D1:$000214FB; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IShellCopyHookW: TGUID = (D1:$000214FC; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IShellView2: TGUID = (D1:$88E39E80; D2:$3578; D3:$11CF; D4:($AE,$69,$08,$00,$2B,$2E,$12,$62));

  DWFRF_NORMAL            = $0000;
  DWFRF_DELETECONFIGDATA  = $0001;
  DWFAF_HIDDEN            = $0001;

  SHGDN_NORMAL             = $0000;
  SHGDN_INFOLDER           = $0001;
  SHGDN_INCLUDE_NONFILESYS = $2000;
  SHGDN_FORADDRESSBAR      = $4000;
  SHGDN_FORPARSING         = $8000;

  SHCONTF_FOLDERS         = 32;
  SHCONTF_NONFOLDERS      = 64;
  SHCONTF_INCLUDEHIDDEN   = 128;

  DBIM_MINSIZE    = $0001;
  DBIM_MAXSIZE    = $0002;
  DBIM_INTEGRAL   = $0004;
  DBIM_ACTUAL     = $0008;
  DBIM_TITLE      = $0010;
  DBIM_MODEFLAGS  = $0020;
  DBIM_BKCOLOR    = $0040;

  DBIMF_NORMAL            = $0000;
  DBIMF_VARIABLEHEIGHT    = $0008;
  DBIMF_DEBOSSED          = $0020;
  DBIMF_BKCOLOR           = $0040;

  DBIF_VIEWMODE_NORMAL         = $0000;
  DBIF_VIEWMODE_VERTICAL       = $0001;
  DBIF_VIEWMODE_FLOATING       = $0002;
  DBIF_VIEWMODE_TRANSPARENT    = $0004;

  DBID_BANDINFOCHANGED = 0;
  DBID_SHOWONLY        = 1;
  DBID_MAXIMIZEBAND    = 2;

  COMPONENT_TOP = $7fffffff;

  COMP_TYPE_HTMLDOC       = 0;
  COMP_TYPE_PICTURE       = 1;
  COMP_TYPE_WEBSITE       = 2;
  COMP_TYPE_CONTROL       = 3;
  COMP_TYPE_CFHTML        = 4;
  COMP_TYPE_MAX           = 4;

  SFGAO_CANCOPY           = DROPEFFECT_COPY;
  SFGAO_CANMOVE           = DROPEFFECT_MOVE;
  SFGAO_CANLINK           = DROPEFFECT_LINK;
  SFGAO_CANRENAME         = $00000010;
  SFGAO_CANDELETE         = $00000020;
  SFGAO_HASPROPSHEET      = $00000040;
  SFGAO_DROPTARGET        = $00000100;
  SFGAO_CAPABILITYMASK    = $00000177;
  SFGAO_LINK              = $00010000;
  SFGAO_SHARE             = $00020000;
  SFGAO_READONLY          = $00040000;
  SFGAO_GHOSTED           = $00080000;
  SFGAO_HIDDEN            = $00080000;
  SFGAO_DISPLAYATTRMASK   = $000F0000;
  SFGAO_FILESYSANCESTOR   = $10000000;
  SFGAO_FOLDER            = $20000000;
  SFGAO_FILESYSTEM        = $40000000;
  SFGAO_HASSUBFOLDER      = $80000000;
  SFGAO_CONTENTSMASK      = $80000000;
  SFGAO_VALIDATE          = $01000000;
  SFGAO_REMOVABLE         = $02000000;
  SFGAO_COMPRESSED        = $04000000;
  SFGAO_BROWSABLE         = $08000000;
  SFGAO_NONENUMERATED     = $00100000;
  SFGAO_NEWCONTENT        = $00200000;

  AD_APPLY_SAVE         = $00000001;
  AD_APPLY_HTMLGEN      = $00000002;
  AD_APPLY_REFRESH      = $00000004;
  AD_APPLY_ALL          = AD_APPLY_SAVE or AD_APPLY_HTMLGEN or AD_APPLY_REFRESH;
  AD_APPLY_FORCE        = $00000008;
  AD_APPLY_BUFFERED_REFRESH = $00000010;

  WPSTYLE_CENTER      = 0;
  WPSTYLE_TILE        = 1;
  WPSTYLE_STRETCH     = 2;
  WPSTYLE_MAX         = 3;

  COMP_ELEM_TYPE          = $00000001;
  COMP_ELEM_CHECKED       = $00000002;
  COMP_ELEM_DIRTY         = $00000004;
  COMP_ELEM_NOSCROLL      = $00000008;
  COMP_ELEM_POS_LEFT      = $00000010;
  COMP_ELEM_POS_TOP       = $00000020;
  COMP_ELEM_SIZE_WIDTH    = $00000040;
  COMP_ELEM_SIZE_HEIGHT   = $00000080;
  COMP_ELEM_POS_ZINDEX    = $00000100;
  COMP_ELEM_SOURCE        = $00000200;
  COMP_ELEM_FRIENDLYNAME  = $00000400;
  COMP_ELEM_SUBSCRIBEDURL = $00000800;

  COMP_ELEM_ALL           = COMP_ELEM_TYPE or COMP_ELEM_CHECKED or
                            COMP_ELEM_DIRTY or COMP_ELEM_NOSCROLL or
                            COMP_ELEM_POS_LEFT or COMP_ELEM_SIZE_WIDTH  or
                            COMP_ELEM_SIZE_HEIGHT or COMP_ELEM_POS_ZINDEX or
                            COMP_ELEM_SOURCE or COMP_ELEM_FRIENDLYNAME;

  ADDURL_SILENT               = $0001;


//==========================================================================
// Clipboard format which may be supported by IDataObject from system
// defined shell folders (such as directories, network, ...).
//==========================================================================
  CFSTR_SHELLIDLIST           = 'Shell IDList Array';
  CFSTR_SHELLIDLISTOFFSET     = 'Shell Object Offsets';
  CFSTR_NETRESOURCES          = 'Net Resource';
  CFSTR_FILEDESCRIPTORA       = 'FileGroupDescriptor';
  CFSTR_FILEDESCRIPTORW       = 'FileGroupDescriptorW';
  CFSTR_FILECONTENTS          = 'FileContents';
  CFSTR_FILENAMEA             = 'FileName';
  CFSTR_FILENAMEW             = 'FileNameW';
  CFSTR_PRINTERGROUP          = 'PrinterFriendlyName';
  CFSTR_FILENAMEMAPA          = 'FileNameMap';
  CFSTR_FILENAMEMAPW          = 'FileNameMapW';
  CFSTR_SHELLURL              = 'UniformResourceLocator';
  CFSTR_PREFERREDDROPEFFECT   = 'Preferred DropEffect';
  CFSTR_PERFORMEDDROPEFFECT   = 'Performed DropEffect';
  CFSTR_PASTESUCCEEDED        = 'Paste Succeeded';
  CFSTR_INDRAGLOOP            = 'InShellDragLoop';

  CFSTR_FILEDESCRIPTOR        = CFSTR_FILEDESCRIPTORA;
  CFSTR_FILENAME              = CFSTR_FILENAMEA;
  CFSTR_FILENAMEMAP           = CFSTR_FILENAMEMAPA;

//====== File System Notification APIs ===============================
//

//
//  File System Notification flags
//
  FD_CLSID            = $0001;
  FD_SIZEPOINT        = $0002;
  FD_ATTRIBUTES       = $0004;
  FD_CREATETIME       = $0008;
  FD_ACCESSTIME       = $0010;
  FD_WRITESTIME       = $0020;
  FD_FILESIZE         = $0040;
  FD_LINKUI           = $8000;

  SHCNE_RENAMEITEM          = $00000001;
  SHCNE_CREATE              = $00000002;
  SHCNE_DELETE              = $00000004;
  SHCNE_MKDIR               = $00000008;
  SHCNE_RMDIR               = $00000010;
  SHCNE_MEDIAINSERTED       = $00000020;
  SHCNE_MEDIAREMOVED        = $00000040;
  SHCNE_DRIVEREMOVED        = $00000080;
  SHCNE_DRIVEADD            = $00000100;
  SHCNE_NETSHARE            = $00000200;
  SHCNE_NETUNSHARE          = $00000400;
  SHCNE_ATTRIBUTES          = $00000800;
  SHCNE_UPDATEDIR           = $00001000;
  SHCNE_UPDATEITEM          = $00002000;
  SHCNE_SERVERDISCONNECT    = $00004000;
  SHCNE_UPDATEIMAGE         = $00008000;
  SHCNE_DRIVEADDGUI         = $00010000;
  SHCNE_RENAMEFOLDER        = $00020000;
  SHCNE_FREESPACE           = $00040000;
  SHCNE_EXTENDED_EVENT      = $04000000;
  SHCNE_EXTENDED_EVENT_PRE_IE4 = $00080000;

  SHCNE_ASSOCCHANGED        = $08000000;

  SHCNE_DISKEVENTS          = $0002381F;
  SHCNE_GLOBALEVENTS        = $0C0581E0;
  SHCNE_ALLEVENTS           = $7FFFFFFF;
  SHCNE_INTERRUPT           = $80000000;

  SHCNEE_THEMECHANGED       = $00000001;
  SHCNEE_ORDERCHANGED       = $00000002;

// Flags
// uFlags & SHCNF_TYPE is an ID which indicates what dwItem1 and dwItem2 mean
  SHCNF_IDLIST          = $0000;
  SHCNF_PATHA           = $0001;
  SHCNF_PRINTERA        = $0002;
  SHCNF_DWORD           = $0003;
  SHCNF_PATHW           = $0005;
  SHCNF_PRINTERW        = $0006;
  SHCNF_TYPE            = $00FF;
  SHCNF_FLUSH           = $1000;
  SHCNF_FLUSHNOWAIT     = $2000;

  SHCNF_PATH          = SHCNF_PATHA;
  SHCNF_PRINTER       = SHCNF_PRINTERA;

  QIF_CACHED           = $00000001;
  QIF_DONTEXPANDFOLDER = $00000002;

  SHARD_PIDL          = $00000001;
  SHARD_PATHA         = $00000002;
  SHARD_PATHW         = $00000003;

  SHARD_PATH      = SHARD_PATHA;

  SHGDFIL_FINDDATA            = 1;
  SHGDFIL_NETRESOURCE         = 2;
  SHGDFIL_DESCRIPTIONID       = 3;

  SHDID_ROOT_REGITEM              = 1;
  SHDID_FS_FILE                   = 2;
  SHDID_FS_DIRECTORY              = 3;
  SHDID_FS_OTHER                  = 4;
  SHDID_COMPUTER_DRIVE35          = 5;
  SHDID_COMPUTER_DRIVE525         = 6;
  SHDID_COMPUTER_REMOVABLE        = 7;
  SHDID_COMPUTER_FIXED            = 8;
  SHDID_COMPUTER_NETDRIVE         = 9;
  SHDID_COMPUTER_CDROM            = 10;
  SHDID_COMPUTER_RAMDISK          = 11;
  SHDID_COMPUTER_OTHER            = 12;
  SHDID_NET_DOMAIN                = 13;
  SHDID_NET_SERVER                = 14;
  SHDID_NET_SHARE                 = 15;
  SHDID_NET_RESTOFNET             = 16;
  SHDID_NET_OTHER                 = 17;

  DVASPECT_SHORTNAME              = 2;

//
// PROPIDs for Internet Shortcuts (FMTID_Intshcut) to be used with
// IPropertySetStorage/IPropertyStorage
//
// The known property ids and their variant types are:
//      PID_IS_URL          [VT_LPWSTR]   URL
//      PID_IS_NAME         [VT_LPWSTR]   Name of the internet shortcut
//      PID_IS_WORKINGDIR   [VT_LPWSTR]   Working directory for the shortcut
//      PID_IS_HOTKEY       [VT_UI2]      Hotkey for the shortcut
//      PID_IS_SHOWCMD      [VT_I4]       Show command for shortcut
//      PID_IS_ICONINDEX    [VT_I4]       Index into file that has icon
//      PID_IS_ICONFILE     [VT_LPWSTR]   File that has the icon
//      PID_IS_WHATSNEW     [VT_LPWSTR]   What's New text
//      PID_IS_AUTHOR       [VT_LPWSTR]   Author
//      PID_IS_DESCRIPTION  [VT_LPWSTR]   Description text of site
//      PID_IS_COMMENT      [VT_LPWSTR]   User annotated comment
//

  PID_IS_URL           = 2;
  PID_IS_NAME          = 4;
  PID_IS_WORKINGDIR    = 5;
  PID_IS_HOTKEY        = 6;
  PID_IS_SHOWCMD       = 7;
  PID_IS_ICONINDEX     = 8;
  PID_IS_ICONFILE      = 9;
  PID_IS_WHATSNEW      = 10;
  PID_IS_AUTHOR        = 11;
  PID_IS_DESCRIPTION   = 12;
  PID_IS_COMMENT       = 13;

//
// PROPIDs for Internet Sites (FMTID_InternetSite) to be used with
// IPropertySetStorage/IPropertyStorage
//
// The known property ids and their variant types are:
//      PID_INTSITE_WHATSNEW     [VT_LPWSTR]   What's New text
//      PID_INTSITE_AUTHOR       [VT_LPWSTR]   Author
//      PID_INTSITE_LASTVISIT    [VT_FILETIME] Time site was last visited
//      PID_INTSITE_LASTMOD      [VT_FILETIME] Time site was last modified
//      PID_INTSITE_VISITCOUNT   [VT_UI4]      Number of times user has visited
//      PID_INTSITE_DESCRIPTION  [VT_LPWSTR]   Description text of site
//      PID_INTSITE_COMMENT      [VT_LPWSTR]   User annotated comment
//      PID_INTSITE_RECURSE      [VT_UI4]      Levels to recurse (0-3)
//      PID_INTSITE_WATCH        [VT_UI4]      PIDISM_ flags
//      PID_INTSITE_SUBSCRIPTION [VT_UI8]      Subscription cookie
//      PID_INTSITE_URL          [VT_LPWSTR]   URL
//      PID_INTSITE_TITLE        [VT_LPWSTR]   Title
//      PID_INTSITE_CODEPAGE     [VT_UI4]      Codepage of the document
//      PID_INTSITE_TRACKING     [VT_UI4]      Tracking
//

  PID_INTSITE_WHATSNEW      = 2;
  PID_INTSITE_AUTHOR        = 3;
  PID_INTSITE_LASTVISIT     = 4;
  PID_INTSITE_LASTMOD       = 5;
  PID_INTSITE_VISITCOUNT    = 6;
  PID_INTSITE_DESCRIPTION   = 7;
  PID_INTSITE_COMMENT       = 8;
  PID_INTSITE_FLAGS         = 9;
  PID_INTSITE_CONTENTLEN    = 10;
  PID_INTSITE_CONTENTCODE   = 11;
  PID_INTSITE_RECURSE       = 12;
  PID_INTSITE_WATCH         = 13;
  PID_INTSITE_SUBSCRIPTION  = 14;
  PID_INTSITE_URL           = 15;
  PID_INTSITE_TITLE         = 16;
  PID_INTSITE_CODEPAGE      = 18;
  PID_INTSITE_TRACKING      = 19;

  PIDISF_RECENTLYCHANGED  = $00000001;
  PIDISF_CACHEDSTICKY     = $00000002;
  PIDISF_CACHEIMAGES      = $00000010;
  PIDISF_FOLLOWALLLINKS   = $00000020;

  PIDISM_GLOBAL           = 0;
  PIDISM_WATCH            = 1;
  PIDISM_DONTWATCH        = 2;

  SSF_SHOWALLOBJECTS          = $0001;
  SSF_SHOWEXTENSIONS          = $0002;
  SSF_SHOWCOMPCOLOR           = $0008;
  SSF_SHOWSYSFILES            = $0020;
  SSF_DOUBLECLICKINWEBVIEW    = $0080;
  SSF_SHOWATTRIBCOL           = $0100;
  SSF_DESKTOPHTML             = $0200;
  SSF_WIN95CLASSIC            = $0400;
  SSF_DONTPRETTYPATH          = $0800;
  SSF_SHOWINFOTIP             = $2000;
  SSF_MAPNETDRVBUTTON         = $1000;
  SSF_NOCONFIRMRECYCLE        = $8000;
  SSF_HIDEICONS               = $4000;

  CSIDL_COMMON_APPDATA        = $0023;
  CSIDL_WINDOWS               = $0024;
  CSIDL_SYSTEM                = $0025;
  CSIDL_PROGRAM_FILES         = $0026;
  CSIDL_MYPICTURES            = $0027;
  CSIDL_PROGRAM_FILES_COMMON  = $002b;
  CSIDL_COMMON_DOCUMENTS      = $002e;

  CSIDL_FLAG_CREATE           = $8000;

  CSIDL_COMMON_ADMINTOOLS     = $002f;
  CSIDL_ADMINTOOLS            = $0030;

type
  IShellView = interface;
  IShellBrowser = interface;
  IDockingWindow = interface;

//===========================================================================
//
// Object identifiers in the explorer's name space (ItemID and IDList)
//
//  All the items that the user can browse with the explorer (such as files,
// directories, servers, work-groups, etc.) has an identifier which is unique
// among items within the parent folder. Those identifiers are called item
// IDs (SHITEMID). Since all its parent folders have their own item IDs,
// any items can be uniquely identified by a list of item IDs, which is called
// an ID list (ITEMIDLIST).
//
//  ID lists are almost always allocated by the task allocator (see some
// description below as well as OLE 2.0 SDK) and may be passed across
// some of shell interfaces (such as IShellFolder). Each item ID in an ID list
// is only meaningful to its parent folder (which has generated it), and all
// the clients must treat it as an opaque binary data except the first two
// bytes, which indicates the size of the item ID.
//
//  When a shell extension -- which implements the IShellFolder interace --
// generates an item ID, it may put any information in it, not only the data
// with that it needs to identifies the item, but also some additional
// information, which would help implementing some other functions efficiently.
// For example, the shell's IShellFolder implementation of file system items
// stores the primary (long) name of a file or a directory as the item
// identifier, but it also stores its alternative (short) name, size and date
// etc.
//
//  When an ID list is passed to one of shell APIs (such as SHGetPathFromIDList),
// it is always an absolute path -- relative from the root of the name space,
// which is the desktop folder. When an ID list is passed to one of IShellFolder
// member function, it is always a relative path from the folder (unless it
// is explicitly specified).
//
//===========================================================================

  PSHItemID = ^TSHItemID;
  _SHITEMID = record
    cb: Word;
    abID: array[0..0] of Byte;
  end;
  TSHItemID = _SHITEMID;
  SHITEMID = _SHITEMID;

  PItemIDList = ^TItemIDList;
  _ITEMIDLIST = record
     mkid: TSHItemID;
   end;
  TItemIDList = _ITEMIDLIST;
  ITEMIDLIST = _ITEMIDLIST;

  //NOTE: When SEE_MASK_HMONITOR is set, hIcon is treated as hMonitor
  PCMInvokeCommandInfo = ^TCMInvokeCommandInfo;
  _CMINVOKECOMMANDINFO = record
    cbSize: DWORD;
    fMask: DWORD;
    hwnd: HWND;
    lpVerb: LPCSTR;
    lpParameters: LPCSTR;
    lpDirectory: LPCSTR;
    nShow: Integer;
    dwHotKey: DWORD;
    hIcon: THandle;
  end;
  TCMInvokeCommandInfo = _CMINVOKECOMMANDINFO;
  CMINVOKECOMMANDINFO = _CMINVOKECOMMANDINFO;

  PCMInvokeCommandInfoEx = ^TCMInvokeCommandInfoEx;
  _CMInvokeCommandInfoEx = record
    cbSize: DWORD;
    fMask: DWORD;
    hwnd: HWND;
    lpVerb: LPCSTR;
    lpParameters: LPCSTR;
    lpDirectory: LPCSTR;
    nShow: Integer;
    dwHotKey: DWORD;
    hIcon: THandle;
    lpTitle: LPCSTR;
    lpVerbW: LPCWSTR;
    lpParametersW: LPCWSTR;
    lpDirectoryW: LPCWSTR;
    lpTitleW: LPCWSTR;
    ptInvoke: TPoint;
  end;
  TCMInvokeCommandInfoEx = _CMINVOKECOMMANDINFOEX;
  CMINVOKECOMMANDINFOEX = _CMINVOKECOMMANDINFOEX;

  PFVShowInfo = ^TFVShowInfo;
  TFVShowInfo = packed record
    cbSize: DWORD;
    hwndOwner: HWND;
    iShow: Integer;
    dwFlags: DWORD;
    rect: TRECT;
    punkRel: IUNKNOWN;
    strNewFile: array[0..MAX_PATH-1] of TOleChar;
  end;

  PFolderSettings = ^TFolderSettings;
  TFolderSettings = packed record
    ViewMode: UINT;
    fFlags: UINT;
  end;

  TSBSCEnums = (SBSC_HIDE, SBSC_SHOW, SBSC_TOGGLE, SBSC_QUERY);

  TSBOEnums = (SBO_DEFAULT, SBO_NOBROWSERPAGES);

  TSBCMDIDEnums = (SBCMDID_ENABLESHOWTREE, SBCMDID_SHOWCONTROL, SBCMDID_CANCELNAVIGATION,
    SBCMDID_MAYSAVECHANGES, SBCMDID_SETHLINKFRAME, SBCMDID_ENABLESTOP, SBCMDID_OPTIONS);

  TSVUIAEnums = (SVUIA_DEACTIVATE, SVUIA_ACTIVATE_NOFOCUS, SVUIA_ACTIVATE_FOCUS, SVUIA_INPLACEACTIVATE);

  SHELLVIEWID = TGUID;
  TShellViewID = SHELLVIEWID;
  PShellViewID = ^TShellViewID;

  PSV2CreateParams = ^TSV2CreateParams;
  _SV2CVW2_PARAMS = record
    cbSize: DWORD;
    psvPrev: IShellView;
    pfs: PFolderSettings;
    psbOwner: IShellBrowser;
    prcView: PRect;
    pvid: PShellViewID;
    hwndView: HWND;
  end;
  TSV2CreateParams = _SV2CVW2_PARAMS;
  SV2CVW2_PARAMS = _SV2CVW2_PARAMS;

  PSTRRet = ^TStrRet;
  _STRRET = record
     uType: UINT;
     case Integer of
       0: (pOleStr: LPWSTR);
       1: (pStr: LPSTR);
       2: (uOffset: UINT);
       3: (cStr: array[0..MAX_PATH-1] of Char);
    end;
  TStrRet = _STRRET;
  STRRET = _STRRET;

  BFFCALLBACK = function conv arg_stdcall (Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer;
  TFNBFFCallBack = BFFCALLBACK;

  PBrowseInfoA = ^TBrowseInfoA;
  PBrowseInfoW = ^TBrowseInfoW;
  PBrowseInfo = PBrowseInfoA;
  _browseinfoA = record
    hwndOwner: HWND;
    pidlRoot: PItemIDList;
    pszDisplayName: PAnsiChar;
    lpszTitle: PAnsiChar;
    ulFlags: UINT;
    lpfn: TFNBFFCallBack;
    lParam: LPARAM;
    iImage: Integer;
  end;
  _browseinfoW = record
    hwndOwner: HWND;
    pidlRoot: PItemIDList;
    pszDisplayName: PWideChar;
    lpszTitle: PWideChar;
    ulFlags: UINT;
    lpfn: TFNBFFCallBack;
    lParam: LPARAM;
    iImage: Integer;
  end;
  _browseinfo = _browseinfoA;
  TBrowseInfoA = _browseinfoA;
  TBrowseInfoW = _browseinfoW;
  TBrowseInfo = TBrowseInfoA;
  BROWSEINFOA = _browseinfoA;
  BROWSEINFOW = _browseinfoW;
  BROWSEINFO = BROWSEINFOA;

  DESKBANDINFO = packed record
    dwMask: DWORD;
    ptMinSize: TPointL;
    ptMaxSize: TPointL;
    ptIntegral: TPointL;
    ptActual: TPointL;
    wszTitle: array[0..255] of WideChar;
    dwModeFlags: DWORD;
    crBkgnd: COLORREF;
  end;
  PDeskBandInfo = ^TDeskBandInfo;
  TDeskBandInfo = DESKBANDINFO;

  _tagWALLPAPEROPT = packed record
    dwSize: DWORD;
    dwStyle: DWORD;
  end;
  PWallPaperOpt = ^TWallPaperOpt;
  TWallPaperOpt = _tagWALLPAPEROPT;

  _tagCOMPONENTSOPT = packed record
    dwSize: DWORD;
    fEnableComponents: BOOL;
    fActiveDesktop: BOOL;
  end;
  PComponentsOpt = ^TComponentsOpt;
  TComponentsOpt = _tagCOMPONENTSOPT;

  _tagCOMPPOS = packed record
    dwSize: DWORD;
    iLeft: Integer;
    iTop: Integer;
    dwWidth: DWORD;
    dwHeight: DWORD;
    izIndex: Integer;
    fCanResize: BOOL;
    fCanResizeX: BOOL;
    fCanResizeY: BOOL;
    iPreferredLeftPercent: Integer;
    iPreferredTopPercent: Integer;
  end;
  PCompPos = ^TCompPos;
  TCompPos = _tagCOMPPOS;

  _tagCOMPONENT = packed record
    dwSize: DWORD;
    dwID: DWORD;
    iComponentType: Integer;
    fChecked: BOOL;
    fDirty: BOOL;
    fNoScroll: BOOL;
    cpPos: TCompPos;
    wszFriendlyName: array[0..MAX_PATH - 1] of WideChar;
    wszSource: array[0..INTERNET_MAX_URL_LENGTH - 1] of WideChar;
    wszSubscribedURL: array[0..INTERNET_MAX_URL_LENGTH - 1] of WideChar;
  end;
  PShComponent = ^TShComponent;
  TShComponent = _tagCOMPONENT;

  tagDTI_ADTIWUI = (DTI_ADDUI_DEFAULT, DTI_ADDUI_DISPSUBWIZARD);

  PNResArray = ^TNResArray;
  _NRESARRAY = record
    cItems: UINT;
    nr: array[0..0] of TNetResource;
  end;
  TNResArray = _NRESARRAY;
  NRESARRAY = _NRESARRAY;

  PIDA = ^TIDA;
  _IDA = record
    cidl: UINT;
    aoffset: array[0..0] of UINT;
  end;
  TIDA = _IDA;
  CIDA = _IDA;

  PFileDescriptorA = ^TFileDescriptorA;
  PFileDescriptorW = ^TFileDescriptorW;
  PFileDescriptor = PFileDescriptorA;
  _FILEDESCRIPTORA = record
    dwFlags: DWORD;
    clsid: TCLSID;
    sizel: TSize;
    pointl: TPoint;
    dwFileAttributes: DWORD;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    cFileName: array[0..MAX_PATH-1] of AnsiChar;
  end;

  _FILEDESCRIPTORW = record
    dwFlags: DWORD;
    clsid: TCLSID;
    sizel: TSize;
    pointl: TPoint;
    dwFileAttributes: DWORD;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    cFileName: array[0..MAX_PATH-1] of WideChar;
  end;
  _FILEDESCRIPTOR = _FILEDESCRIPTORA;
  TFileDescriptorA = _FILEDESCRIPTORA;
  TFileDescriptorW = _FILEDESCRIPTORW;
  TFileDescriptor = TFileDescriptorA;
  FILEDESCRIPTORA = _FILEDESCRIPTORA;
  FILEDESCRIPTORW = _FILEDESCRIPTORW;
  FILEDESCRIPTOR = FILEDESCRIPTORA;

  PFileGroupDescriptorA = ^TFileGroupDescriptorA;
  PFileGroupDescriptorW = ^TFileGroupDescriptorW;
  PFileGroupDescriptor = PFileGroupDescriptorA;
  _FILEGROUPDESCRIPTORA = record
    cItems: UINT;
    fgd: array[0..0] of TFileDescriptor;
  end;
  _FILEGROUPDESCRIPTORW = record
    cItems: UINT;
    fgd: array[0..0] of TFileDescriptor;
  end;
  _FILEGROUPDESCRIPTOR = _FILEGROUPDESCRIPTORA;
  TFileGroupDescriptorA = _FILEGROUPDESCRIPTORA;
  TFileGroupDescriptorW = _FILEGROUPDESCRIPTORW;
  TFileGroupDescriptor = TFileGroupDescriptorA;
  FILEGROUPDESCRIPTORA = _FILEGROUPDESCRIPTORA;
  FILEGROUPDESCRIPTORW = _FILEGROUPDESCRIPTORW;
  FILEGROUPDESCRIPTOR = FILEGROUPDESCRIPTORA;

  PDropFiles = ^TDropFiles;
  _DROPFILES = record
    pFiles: DWORD;
    pt: TPoint;
    fNC: BOOL;

    fWide: BOOL;
  end;
  TDropFiles = _DROPFILES;
  DROPFILES = _DROPFILES;

  PSHDescriptionID = ^TSHDescriptionID;
  _SHDESCRIPTIONID = record
    dwDescriptionId: DWORD;
    Id: TCLSID;
  end;
  TSHDescriptionID = _SHDESCRIPTIONID;
  SHDESCRIPTIONID = _SHDESCRIPTIONID;

  SHELLFLAGSTATE = packed record
    Data: Word;
  end;
  PShellFlagState = ^TShellFlagState;
  TShellFlagState = SHELLFLAGSTATE;

  PFNSHGETFOLDERPATHA = function conv arg_stdcall (hwnd: HWND; csidl: Integer; hToken: THandle; dwFlags: DWord; pszPath: PAnsiChar): HRESULT;
  TSHGetFolderPathA = PFNSHGETFOLDERPATHA;

  PFNSHGETFOLDERPATHW = function conv arg_stdcall (hwnd: HWND; csidl: Integer; hToken: THandle; dwFlags: DWord; pszPath: PAnsiChar): HRESULT;
  TSHGetFolderPathW = PFNSHGETFOLDERPATHW;

  PFNSHGETFOLDERPATH  = PFNSHGETFOLDERPATHA;
  TSHGetFolderPath  = TSHGetFolderPathA;

//===========================================================================
//
// IContextMenu interface
//
// [OverView]
//
//  The shell uses the IContextMenu interface in following three cases.
//
// case-1: The shell is loading context menu extensions.
//
//   When the user clicks the right mouse button on an item within the shell's
//  name space (i.g., file, directory, server, work-group, etc.), it creates
//  the default context menu for its type, then loads context menu extensions
//  that are registered for that type (and its base type) so that they can
//  add extra menu items. Those context menu extensions are registered at
//  HKCR\{ProgID}\shellex\ContextMenuHandlers.
//
// case-2: The shell is retrieving a context menu of sub-folders in extended
//   name-space.
//
//   When the explorer's name space is extended by name space extensions,
//  the shell calls their IShellFolder::GetUIObjectOf to get the IContextMenu
//  objects when it creates context menus for folders under those extended
//  name spaces.
//
// case-3: The shell is loading non-default drag and drop handler for directories.
//
//   When the user performed a non-default drag and drop onto one of file
//  system folders (i.e., directories), it loads shell extensions that are
//  registered at HKCR\{ProgID}\DragDropHandlers.
//
//
// [Member functions]
//
//
// IContextMenu::QueryContextMenu
//
//   This member function may insert one or more menuitems to the specified
//  menu (hmenu) at the specified location (indexMenu which is never be -1).
//  The IDs of those menuitem must be in the specified range (idCmdFirst and
//  idCmdLast). It returns the maximum menuitem ID offset (ushort) in the
//  'code' field (low word) of the scode.
//
//   The uFlags specify the context. It may have one or more of following
//  flags.
//
//  CMF_DEFAULTONLY: This flag is passed if the user is invoking the default
//   action (typically by double-clicking, case 1 and 2 only). Context menu
//   extensions (case 1) should not add any menu items, and returns NOERROR.
//
//  CMF_VERBSONLY: The explorer passes this flag if it is constructing
//   a context menu for a short-cut object (case 1 and case 2 only). If this
//   flag is passed, it should not add any menu-items that is not appropriate
//   from a short-cut.
//    A good example is the "Delete" menuitem, which confuses the user
//   because it is not clear whether it deletes the link source item or the
//   link itself.
//
//  CMF_EXPLORER: The explorer passes this flag if it has the left-side pane
//   (case 1 and 2 only). Context menu extensions should ignore this flag.
//
//   High word (16-bit) are reserved for context specific communications
//  and the rest of flags (13-bit) are reserved by the system.
//
//
// IContextMenu::InvokeCommand
//
//   This member is called when the user has selected one of menuitems that
//  are inserted by previous QueryContextMenu member. In this case, the
//  LOWORD(lpici->lpVerb) contains the menuitem ID offset (menuitem ID -
//  idCmdFirst).
//
//   This member function may also be called programmatically. In such a case,
//  lpici->lpVerb specifies the canonical name of the command to be invoked,
//  which is typically retrieved by GetCommandString member previously.
//
//  Parameters in lpci:
//    cbSize -- Specifies the size of this structure (sizeof(*lpci))
//    hwnd   -- Specifies the owner window for any message/dialog box.
//    fMask  -- Specifies whether or not dwHotkey/hIcon paramter is valid.
//    lpVerb -- Specifies the command to be invoked.
//    lpParameters -- Parameters (optional)
//    lpDirectory  -- Working directory (optional)
//    nShow -- Specifies the flag to be passed to ShowWindow (SW_*).
//    dwHotKey -- Hot key to be assigned to the app after invoked (optional).
//    hIcon -- Specifies the icon (optional).
//    hMonitor -- Specifies the default monitor (optional).
//
//
// IContextMenu::GetCommandString
//
//   This member function is called by the explorer either to get the
//  canonical (language independent) command name (uFlags == GCS_VERB) or
//  the help text ((uFlags & GCS_HELPTEXT) != 0) for the specified command.
//  The retrieved canonical string may be passed to its InvokeCommand
//  member function to invoke a command programmatically. The explorer
//  displays the help texts in its status bar; therefore, the length of
//  the help text should be reasonably short (<40 characters).
//
//  Parameters:
//   idCmd -- Specifies menuitem ID offset (from idCmdFirst)
//   uFlags -- Either GCS_VERB or GCS_HELPTEXT
//   pwReserved -- Reserved (must pass NULL when calling, must ignore when called)
//   pszName -- Specifies the string buffer.
//   cchMax -- Specifies the size of the string buffer.
//
//===========================================================================

  IContextMenu = interface(IUnknown)
    ['{000214E4-0000-0000-C000-000000000046}']
    function QueryContextMenu(Menu: HMENU;
      indexMenu, idCmdFirst, idCmdLast, uFlags: UINT): HResult; stdcall;
    function InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult; stdcall;
    function GetCommandString(idCmd, uType: UINT; pwReserved: PUINT;
      pszName: LPSTR; cchMax: UINT): HResult; stdcall;
  end;

//
// IContextMenu2 (IContextMenu with one new member)
//
// IContextMenu2::HandleMenuMsg
//
//  This function is called, if the client of IContextMenu is aware of
// IContextMenu2 interface and receives one of following messages while
// it is calling TrackPopupMenu (in the window proc of hwndOwner):
//      WM_INITPOPUP, WM_DRAWITEM and WM_MEASUREITEM
//  The callee may handle these messages to draw owner draw menuitems.
//

  IContextMenu2 = interface(IContextMenu)
    ['{000214F3-0000-0000-C000-000000000046}']
    function HandleMenuMsg(uMsg: UINT; WParam, LParam: Integer): HResult; stdcall;
  end;

//
// IContextMenu3 (IContextMenu with one new member)
//
// IContextMenu3::HandleMenuMsg2
//
//  This function is called, if the client of IContextMenu is aware of
// IContextMenu3 interface and receives a menu message while
// it is calling TrackPopupMenu (in the window proc of hwndOwner):
//

  IContextMenu3 = interface(IContextMenu2)
    ['{BCFCE0A0-EC17-11d0-8D10-00A0C90F2719}']
    function HandleMenuMsg2(uMsg: UINT; wParam, lParam: Integer;
      var Result: Integer): HResult; stdcall;
  end;

//===========================================================================
//
// Interface: IShellExtInit
//
//  The IShellExtInit interface is used by the explorer to initialize shell
// extension objects. The explorer (1) calls CoCreateInstance (or equivalent)
// with the registered CLSID and IID_IShellExtInit, (2) calls its Initialize
// member, then (3) calls its QueryInterface to a particular interface (such
// as IContextMenu or IPropSheetExt and (4) performs the rest of operation.
//
//
// [Member functions]
//
// IShellExtInit::Initialize
//
//  This member function is called when the explorer is initializing either
// context menu extension, property sheet extension or non-default drag-drop
// extension.
//
//  Parameters: (context menu or property sheet extension)
//   pidlFolder -- Specifies the parent folder
//   lpdobj -- Spefifies the set of items selected in that folder.
//   hkeyProgID -- Specifies the type of the focused item in the selection.
//
//  Parameters: (non-default drag-and-drop extension)
//   pidlFolder -- Specifies the target (destination) folder
//   lpdobj -- Specifies the items that are dropped (see the description
//    about shell's clipboard below for clipboard formats).
//   hkeyProgID -- Specifies the folder type.
//
//===========================================================================

  IShellExtInit = interface(IUnknown)
    ['{000214E8-0000-0000-C000-000000000046}']
    function Initialize(pidlFolder: PItemIDList; lpdobj: IDataObject;
      hKeyProgID: HKEY): HResult; stdcall;
  end;

//===========================================================================
//
// Interface: IShellPropSheetExt
//
//  The explorer uses the IShellPropSheetExt to allow property sheet
// extensions or control panel extensions to add additional property
// sheet pages.
//
//
// [Member functions]
//
// IShellPropSheetExt::AddPages
//
//  The explorer calls this member function when it finds a registered
// property sheet extension for a particular type of object. For each
// additional page, the extension creates a page object by calling
// CreatePropertySheetPage API and calls lpfnAddPage.
//
//  Parameters:
//   lpfnAddPage -- Specifies the callback function.
//   lParam -- Specifies the opaque handle to be passed to the callback function.
//
//
// IShellPropSheetExt::ReplacePage
//
//  The explorer never calls this member of property sheet extensions. The
// explorer calls this member of control panel extensions, so that they
// can replace some of default control panel pages (such as a page of
// mouse control panel).
//
//  Parameters:
//   uPageID -- Specifies the page to be replaced.
//   lpfnReplace Specifies the callback function.
//   lParam -- Specifies the opaque handle to be passed to the callback function.
//
//===========================================================================

  IShellPropSheetExt = interface(IUnknown)
    ['{000214E9-0000-0000-C000-000000000046}']
    function AddPages(lpfnAddPage: TFNAddPropSheetPage; lParam: LPARAM): HResult; stdcall;
    function ReplacePage(uPageID: UINT; lpfnReplaceWith: TFNAddPropSheetPage;
      lParam: LPARAM): HResult; stdcall;
  end;

//===========================================================================
//
// IPersistFolder Interface
//
//  The IPersistFolder interface is used by the file system implementation of
// IShellFolder::BindToObject when it is initializing a shell folder object.
//
//
// [Member functions]
//
// IPersistFolder::Initialize
//
//  This member function is called when the explorer is initializing a
// shell folder object.
//
//  Parameters:
//   pidl -- Specifies the absolute location of the folder.
//
//===========================================================================

  IPersistFolder = interface(IPersist)
    ['{000214EA-0000-0000-C000-000000000046}']
    function Initialize(pidl: PItemIDList): HResult; stdcall;
  end;

  IPersistFolder2 = interface(IPersistFolder)
    ['{1AC3D9F0-175C-11d1-95BE-00609797EA4F}']
    function GetCurFolder(var pidl: PItemIDList): HResult; stdcall;
  end;

  IExtractIconA = interface(IUnknown)
    ['{000214EB-0000-0000-C000-000000000046}']
    function GetIconLocation(uFlags: UINT; szIconFile: PAnsiChar; cchMax: UINT;
      out piIndex: Integer; out pwFlags: UINT): HResult; stdcall;
    function Extract(pszFile: PAnsiChar; nIconIndex: UINT;
      out phiconLarge, phiconSmall: HICON; nIconSize: UINT): HResult; stdcall;
  end;

  IExtractIconW = interface(IUnknown)
    ['{000214FA-0000-0000-C000-000000000046}']
    function GetIconLocation(uFlags: UINT; szIconFile: PWideChar; cchMax: UINT;
      out piIndex: Integer; out pwFlags: UINT): HResult; stdcall;
    function Extract(pszFile: PWideChar; nIconIndex: UINT;
      out phiconLarge, phiconSmall: HICON; nIconSize: UINT): HResult; stdcall;
  end;
  IExtractIcon = IExtractIconA;

  IShellIcon = interface(IUnknown)
    ['{000214E5-0000-0000-C000-000000000046}']
    function GetIconOf(pidl: PItemIDList; flags: UINT;
      out IconIndex: Integer): HResult; stdcall;
  end;

  IShellIconOverlay = interface(IUnknown)
    ['{7D688A70-C613-11D0-999B-00C04FD655E1}']
    function GetOverlayIndex(pidl: PItemIDList; out pIndex: Integer): HResult; stdcall;
    function GetOverlayIconIndex(pidl: PItemIDList; out pIconIndex: Integer): HResult; stdcall;
  end;

  IShellLinkA = interface(IUnknown)
    ['{000214EE-0000-0000-C000-000000000046}']
    function GetPath(pszFile: PAnsiChar; cchMaxPath: Integer; var pfd: TWin32FindData; fFlags: DWORD): HResult; stdcall;
    function GetIDList(var ppidl: PItemIDList): HResult; stdcall;
    function SetIDList(pidl: PItemIDList): HResult; stdcall;
    function GetDescription(pszName: PAnsiChar; cchMaxName: Integer): HResult; stdcall;
    function SetDescription(pszName: PAnsiChar): HResult; stdcall;
    function GetWorkingDirectory(pszDir: PAnsiChar; cchMaxPath: Integer): HResult; stdcall;
    function SetWorkingDirectory(pszDir: PAnsiChar): HResult; stdcall;
    function GetArguments(pszArgs: PAnsiChar; cchMaxPath: Integer): HResult; stdcall;
    function SetArguments(pszArgs: PAnsiChar): HResult; stdcall;
    function GetHotkey(var pwHotkey: Word): HResult; stdcall;
    function SetHotkey(wHotkey: Word): HResult; stdcall;
    function GetShowCmd(out piShowCmd: Integer): HResult; stdcall;
    function SetShowCmd(iShowCmd: Integer): HResult; stdcall;
    function GetIconLocation(pszIconPath: PAnsiChar; cchIconPath: Integer; out piIcon: Integer): HResult; stdcall;
    function SetIconLocation(pszIconPath: PAnsiChar; iIcon: Integer): HResult; stdcall;
    function SetRelativePath(pszPathRel: PAnsiChar; dwReserved: DWORD): HResult; stdcall;
    function Resolve(Wnd: HWND; fFlags: DWORD): HResult; stdcall;
    function SetPath(pszFile: PAnsiChar): HResult; stdcall;
  end;

  IShellLinkW = interface(IUnknown)
    ['{000214F9-0000-0000-C000-000000000046}']
    function GetPath(pszFile: PWideChar; cchMaxPath: Integer; var pfd: TWin32FindData; fFlags: DWORD): HResult; stdcall;
    function GetIDList(var ppidl: PItemIDList): HResult; stdcall;
    function SetIDList(pidl: PItemIDList): HResult; stdcall;
    function GetDescription(pszName: PWideChar; cchMaxName: Integer): HResult; stdcall;
    function SetDescription(pszName: PWideChar): HResult; stdcall;
    function GetWorkingDirectory(pszDir: PWideChar; cchMaxPath: Integer): HResult; stdcall;
    function SetWorkingDirectory(pszDir: PWideChar): HResult; stdcall;
    function GetArguments(pszArgs: PWideChar; cchMaxPath: Integer): HResult; stdcall;
    function SetArguments(pszArgs: PWideChar): HResult; stdcall;
    function GetHotkey(var pwHotkey: Word): HResult; stdcall;
    function SetHotkey(wHotkey: Word): HResult; stdcall;
    function GetShowCmd(out piShowCmd: Integer): HResult; stdcall;
    function SetShowCmd(iShowCmd: Integer): HResult; stdcall;
    function GetIconLocation(pszIconPath: PWideChar; cchIconPath: Integer; out piIcon: Integer): HResult; stdcall;
    function SetIconLocation(pszIconPath: PWideChar; iIcon: Integer): HResult; stdcall;
    function SetRelativePath(pszPathRel: PWideChar; dwReserved: DWORD): HResult; stdcall;
    function Resolve(Wnd: HWND; fFlags: DWORD): HResult; stdcall;
    function SetPath(pszFile: PWideChar): HResult; stdcall;
  end;
  IShellLink = IShellLinkA;

  IShellExecuteHookA = interface(IUnknown)
    ['{000214F5-0000-0000-C000-000000000046}']
    function Execute(var ShellExecuteInfo: TShellExecuteInfo): HResult; stdcall;
  end;

  IShellExecuteHookW = interface(IUnknown)
    ['{000214FA-0000-0000-C000-000000000046}']
    function Execute(var ShellExecuteInfo: TShellExecuteInfo): HResult; stdcall;
  end;
  IShellExecuteHook = IShellExecuteHookA;

  IURLSearchHook = interface(IUnknown)
    ['{AC60F6A0-0FD9-11D0-99CB-00C04FD64497}']
    function Translate(lpwszSearchURL: PWideChar; cchBufferSize: DWORD): HResult; stdcall;
  end;

  INewShortcutHookA = interface(IUnknown)
    ['{000214E1-0000-0000-C000-000000000046}']
    function SetReferent(pcszReferent: PAnsiChar; Wnd: HWND): HResult; stdcall;
    function GetReferent(pcszReferent: PAnsiChar; cchReferent: Integer): HResult; stdcall;
    function SetFolder(pcszFolder: PAnsiChar; Wnd: HWND): HResult; stdcall;
    function GetFolder(pcszFolder: PAnsiChar; cchFolder: Integer): HResult; stdcall;
    function GetName(pcszName: PAnsiChar; cchName: Integer): HResult; stdcall;
    function GetExtension(pcszExtension: PAnsiChar; cchExtension: Integer): HResult; stdcall;
  end;

  INewShortcutHookW = interface(IUnknown)
    ['{000214F7-0000-0000-C000-000000000046}']
    function SetReferent(pcszReferent: PWideChar; Wnd: HWND): HResult; stdcall;
    function GetReferent(pcszReferent: PWideChar; cchReferent: Integer): HResult; stdcall;
    function SetFolder(pcszFolder: PWideChar; Wnd: HWND): HResult; stdcall;
    function GetFolder(pcszFolder: PWideChar; cchFolder: Integer): HResult; stdcall;
    function GetName(pcszName: PWideChar; cchName: Integer): HResult; stdcall;
    function GetExtension(pcszExtension: PWideChar; cchExtension: Integer): HResult; stdcall;
  end;
  INewShortcutHook = INewShortcutHookA;

  ICopyHookA = interface(IUnknown)
    ['{000214EF-0000-0000-C000-000000000046}']
    function CopyCallback(Wnd: HWND; wFunc, wFlags: UINT; pszSrcFile: PAnsiChar;
      dwSrcAttribs: DWORD; pszDestFile: PAnsiChar; dwDestAttribs: DWORD): UINT; stdcall;
  end;

  ICopyHookW = interface(IUnknown)
    ['{000214FC-0000-0000-C000-000000000046}']
    function CopyCallback(Wnd: HWND; wFunc, wFlags: UINT; pszSrcFile: PWideChar;
      dwSrcAttribs: DWORD; pszDestFile: PWideChar; dwDestAttribs: DWORD): UINT; stdcall;
  end;
  ICopyHook = ICopyHookA;

  IFileViewerSite = interface(IUnknown)
    ['{000214F3-0000-0000-C000-000000000046}']
    function SetPinnedWindow(Wnd: HWND): HResult; stdcall;
    function GetPinnedWindow(var Wnd: HWND): HResult; stdcall;
  end;

  IFileViewerA = interface(IUnknown)
    ['{000214F0-0000-0000-C000-000000000046}']
    function ShowInitialize(fsi: IFileViewerSite): HResult; stdcall;
    function Show(var pvsi: TFVShowInfo): HResult; stdcall;
    function PrintTo(pszDriver: PAnsiChar; fSuppressUI: BOOL): HResult; stdcall;
  end;

  IFileViewerW = interface(IUnknown)
    ['{000214F8-0000-0000-C000-000000000046}']
    function ShowInitialize(fsi: IFileViewerSite): HResult; stdcall;
    function Show(var pvsi: TFVShowInfo): HResult; stdcall;
    function PrintTo(pszDriver: PWideChar; fSuppressUI: BOOL): HResult; stdcall;
  end;
  IFileViewer = IFileViewerA;

  IShellBrowser = interface(IOleWindow)
    ['{000214E2-0000-0000-C000-000000000046}']
    function InsertMenusSB(hMenuShared: HMENU; out MenuWidths: TOleMenuGroupWidths): HResult; stdcall; function SetMenuSB(hMenuShared: HMENU;
      hOleMenuReserved: HOLEMENU): HResult; stdcall; function RemoveMenusSB(hMenuShared: HMENU): HResult; stdcall;
    function SetStatusTextSB(StatusText: POleStr): HResult; stdcall;
    function EnableModelessSB(Enable: BOOL): HResult; stdcall;
    function TranslateAcceleratorSB(Msg: PMsg; ID: Word): HResult; stdcall;
    function BrowseObject(pidl: PItemIDList; flags: UINT): HResult; stdcall;
    function GetViewStateStream(Mode: DWORD; out Stream: IStream): HResult; stdcall;
    function GetControlWindow(ID: UINT; out Wnd: HWND): HResult; stdcall;
    function SendControlMsg(ID, Msg: UINT; wParm: WPARAM; lParm: LPARAM; Result: LResult): HResult; stdcall;
    function QueryActiveShellView(var ShellView: IShellView): HResult; stdcall;
    function OnViewWindowActive(var ShellView: IShellView): HResult; stdcall;
    function SetToolbarItems(TBButton: PTBButton; nButtons, uFlags: UINT): HResult; stdcall;
  end;

  ICommDlgBrowser = interface(IUnknown)
    ['{000214F1-0000-0000-C000-000000000046}']
    function OnDefaultCommand: HResult; stdcall;
    function OnStateChange(Change: ULONG): HResult; stdcall;
    function IncludeObject(pidl: PItemIDList): HResult; stdcall;
  end;

  IShellView = interface(IOleWindow)
    ['{000214E3-0000-0000-C000-000000000046}']
    function TranslateAccelerator(var Msg: TMsg): HResult; stdcall;
    function EnableModeless(Enable: Boolean): HResult; stdcall;
    function UIActivate(State: UINT): HResult; stdcall;
    function Refresh: HResult; stdcall;
    function CreateViewWindow(PrevView: IShellView;  var FolderSettings: TFolderSettings; ShellBrowser: IShellBrowser; var Rect: TRect; out Wnd: HWND): HResult; stdcall;
    function DestroyViewWindow: HResult; stdcall;
    function GetCurrentInfo(out FolderSettings: TFolderSettings): HResult; stdcall;
    function AddPropertySheetPages(Reseved: DWORD; lpfnAddPage: TFNAddPropSheetPage; lParam: LPARAM): HResult; stdcall;
    function SaveViewState: HResult; stdcall;
    function SelectItem(pidl: PItemIDList; flags: UINT): HResult; stdcall;
    function GetItemObject(Item: UINT; const iid: TIID; IPtr: Pointer): HResult; stdcall;
  end;

  IShellView2 = interface(IShellView)
    ['{88E39E80-3578-11CF-AE69-08002B2E1262}']
    function GetView(pvid: PShellViewID; uView: ULONG): HResult; stdcall;
    function CreateViewWindow2(SV2CreateParams: PSV2CreateParams): HResult; stdcall;
    function HandleRename(pidlNew: PItemIDList): HResult; stdcall;
    function SelectAndPositionItem(pidlItem: PItemIDList; uFlags: UINT; var Point: TPoint): HResult; stdcall;
  end;

  IEnumIDList = interface(IUnknown)
    ['{000214F2-0000-0000-C000-000000000046}']
    function Next(celt: ULONG; out rgelt: PItemIDList; var pceltFetched: ULONG): HResult; stdcall;
    function Skip(celt: ULONG): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppenum: IEnumIDList): HResult; stdcall;
  end;

  IShellFolder = interface(IUnknown)
    ['{000214E6-0000-0000-C000-000000000046}']
    function ParseDisplayName(hwndOwner: HWND; pbcReserved: Pointer; lpszDisplayName: POLESTR; out pchEaten: ULONG;
      out ppidl: PItemIDList; var dwAttributes: ULONG): HResult; stdcall;
    function EnumObjects(hwndOwner: HWND; grfFlags: DWORD; out EnumIDList: IEnumIDList): HResult; stdcall;
    function BindToObject(pidl: PItemIDList; pbcReserved: Pointer; const riid: TIID; out ppvOut: Pointer): HResult; stdcall;
    function BindToStorage(pidl: PItemIDList; pbcReserved: Pointer; const riid: TIID; out ppvObj: Pointer): HResult; stdcall;
    function CompareIDs(lParam: LPARAM; pidl1, pidl2: PItemIDList): HResult; stdcall;
    function CreateViewObject(hwndOwner: HWND; const riid: TIID; out ppvOut: Pointer): HResult; stdcall;
    function GetAttributesOf(cidl: UINT; var apidl: PItemIDList; var rgfInOut: UINT): HResult; stdcall;
    function GetUIObjectOf(hwndOwner: HWND; cidl: UINT; var apidl: PItemIDList; const riid: TIID; prgfInOut: Pointer; out ppvOut: Pointer): HResult; stdcall;
    function GetDisplayNameOf(pidl: PItemIDList; uFlags: DWORD; var lpName: TStrRet): HResult; stdcall;
    function SetNameOf(hwndOwner: HWND; pidl: PItemIDList; lpszName: POLEStr; uFlags: DWORD; var ppidlOut: PItemIDList): HResult; stdcall;
  end;

//-------------------------------------------------------------------------
//
// IInputObjectSite interface
//
//   A site implements this interface so the object can communicate
// focus change to it.
//
// [Member functions]
//
// IInputObjectSite::OnFocusChangeIS(punkObj, fSetFocus)
//   Object (punkObj) is getting or losing the focus.
//
//-------------------------------------------------------------------------

  IInputObjectSite = interface(IUnknown)
    ['{f1db8392-7331-11d0-8c99-00a0c92dbfe8}']
    function OnFocusChangeIS(punkObj: IUnknown; fSetFocus: BOOL): HResult; stdcall;
  end;

//-------------------------------------------------------------------------
//
// IDockingWindowFrame interface
//
//
// [Member functions]
//
// IDockingWindowFrame::AddToolbar(punkSrc, pwszItem, dwReserved)
//
// IDockingWindowFrame::RemoveToolbar(punkSrc, dwRemoveFlags)
//
// IDockingWindowFrame::FindToolbar(pwszItem, riid, ppvObj)
//
//-------------------------------------------------------------------------

  IDockingWindowFrame = interface(IOleWindow)
    ['{47d2657a-7b27-11d0-8ca9-00a0c92dbfe8}']
    function AddToolbar(punkSrc: IUnknown; pwszItem: PWideChar;
      dwAddFlags: DWORD): HResult; stdcall;
    function RemoveToolbar(punkSrc: IUnknown; dwRemoveFlags: DWORD): HResult; stdcall;
    function FindToolbar(pwszItem: PWideChar; const riid: TIID;
      var ppvObj: Pointer): HResult; stdcall;
  end;

//-------------------------------------------------------------------------
//
// IDockingWindow interface
//
//   An object (docking window) implements this interface so the site can
// communicate with it.  An example of a docking window is a toolbar.
//
// [Member functions]
//
// IDockingWindow::ShowDW(fShow)
//   Shows or hides the docking window.
//
// IDockingWindow::CloseDW(dwReserved)
//   Closes the docking window.  dwReserved must be 0.
//
// IDockingWindow::ResizeBorderDW(prcBorder, punkToolbarSite, fReserved)
//   Resizes the docking window's border to *prcBorder.  fReserved must
//   be 0.
// IObjectWithSite::SetSite(punkSite)
//   IDockingWindow usually paired with IObjectWithSite.
//   Provides the IUnknown pointer of the site to the docking window.
//
//
//-------------------------------------------------------------------------

  IDockingWindow = interface(IOleWindow)
    ['{012dd920-7b26-11d0-8ca9-00a0c92dbfe8}']
    function ShowDW(fShow: BOOL): HResult; stdcall;
    function CloseDW(dwReserved: DWORD): HResult; stdcall;
    function ResizeBorderDW(var prcBorder: TRect; punkToolbarSite: IUnknown;
      fReserved: BOOL): HResult; stdcall;
  end;

//-------------------------------------------------------------------------
//
// IDeskBand interface
//
//
// [Member functions]
//
// IDeskBand::GetBandInfo(dwBandID, dwViewMode, pdbi)
//   Returns info on the given band in *pdbi, according to the mask
//   field in the DESKBANDINFO structure and the given viewmode.
//
//-------------------------------------------------------------------------

  IDeskBand = interface(IDockingWindow)
    ['{EB0FE172-1A3A-11D0-89B3-00A0C90A90AC}']
    function GetBandInfo(dwBandID, dwViewMode: DWORD; var pdbi: TDeskBandInfo):
      HResult; stdcall;
  end;

  IActiveDesktop = interface(IUnknown)
    ['{F490EB00-1240-11D1-9888-006097DEACF9}']
    function ApplyChanges(dwFlags: DWORD): HResult; stdcall;
    function GetWallpaper(pwszWallpaper: PWideChar; cchWallpaper: UINT; dwReserved: DWORD): HResult; stdcall;
    function SetWallpaper(pwszWallpaper: PWideChar; dwReserved: DWORD): HResult; stdcall;
    function GetWallpaperOptions(var pwpo: TWallPaperOpt; dwReserved: DWORD): HResult; stdcall;
    function SetWallpaperOptions(var pwpo: TWallPaperOpt; dwReserved: DWORD): HResult; stdcall;
    function GetPattern(pwszPattern: PWideChar; cchPattern: UINT; dwReserved: DWORD): HResult; stdcall;
    function SetPattern(pwszPattern: PWideChar; dwReserved: DWORD): HResult; stdcall;
    function GetDesktopItemOptions(var pco: TComponentsOpt; dwReserved: DWORD): HResult; stdcall;
    function SetDesktopItemOptions(var pco: TComponentsOpt; dwReserved: DWORD): HResult; stdcall;
    function AddDesktopItem(var pcomp: TShComponent; dwReserved: DWORD): HResult; stdcall;
    function AddDesktopItemWithUI(hwnd: HWND; var pcomp: TShComponent; dwReserved: DWORD): HResult; stdcall;
    function ModifyDesktopItem(var pcomp: TShComponent; dwReserved: DWORD): HResult; stdcall;
    function RemoveDesktopItem(var pcomp: TShComponent; dwReserved: DWORD): HResult; stdcall;
    function GetDesktopItemCount(var lpiCount: Integer; dwReserved: DWORD): HResult; stdcall;
    function GetDesktopItem(nComponent: Integer; var pcomp: TShComponent; dwReserved: DWORD): HResult; stdcall;
    function GetDesktopItemByID(dwID: DWORD; var pcomp: TShComponent; dwReserved: DWORD): HResult; stdcall;
    function GenerateDesktopItemHtml(pwszFileName: PWideChar; var pcomp: TShComponent; dwReserved: DWORD): HResult; stdcall;
    function AddUrl(hwnd: HWND; pszSource: PWideChar; var pcomp: TShComponent; dwFlags: DWORD): HResult; stdcall;
    function GetDesktopItemBySource(pwszSource: PWideChar; var pcomp: TShComponent; dwReserved: DWORD): HResult; stdcall;
  end;

  IShellChangeNotify = interface(IUnknown)
    function OnChange(lEvent: Longint; var pidl1, pidl2: TItemIDList): HResult; stdcall;
  end;

  IQueryInfo = interface(IUnknown)
    ['{00021500-0000-0000-C000-000000000046}']
    function GetInfoTip(dwFlags: DWORD; var ppwszTip: PWideChar): HResult; stdcall;
    function GetInfoFlags(out pdwFlags: DWORD): HResult; stdcall;
  end;

  IShellIconOverlayIdentifier = interface(IUnknown)
    ['{0C6C4200-C589-11D0-999A-00C04FD655E1}']
    function IsMemberOf(pwszPath: PWideChar; dwAttrib: DWORD): HResult; stdcall;
    function GetOverlayInfo(pwszIconFile: PWideChar; cchMax: Integer;
      var pIndex: Integer; var pdwFlags: DWORD): HResult; stdcall;
    function GetPriority(out pIPriority: Integer): HResult; stdcall;
  end;

//-------------------------------------------------------------------------
//
// IInputObject interface
//
//   An object implements this interface so the site can communicate
// activation and accelerator events to it.
//
// [Member functions]
//
// IInputObject::UIActivateIO(fActivate, lpMsg)
//   Activates or deactivates the object.  lpMsg may be NULL.  Returns
//   S_OK if the activation succeeded.
//
// IInputObject::HasFocusIO()
//   Returns S_OK if the object has the focus, S_FALSE if not.
//
// IInputObject::TranslateAcceleratorIO(lpMsg)
//   Allow the object to process the message.  Returns S_OK if the
//   message was processed (eaten).
//
//-------------------------------------------------------------------------

  IInputObject = interface(IUnknown)
    ['{68284faa-6a48-11d0-8c78-00c04fd918b4}']
    function UIActivateIO(fActivate: BOOL; var lpMsg: TMsg): HResult; stdcall;
    function HasFocusIO: HResult; stdcall;
    function TranslateAcceleratorIO(var lpMsg: TMsg): HResult; stdcall;
  end;

//-------------------------------------------------------------------------
//
// IDockingWindowSite interface
//
//   A site implements this interface so the object can negotiate for
// and inquire about real estate on the site.
//
// [Member functions]
//
// IDockingWindowSite::GetBorderDW(punkObj, prcBorder)
//   Site returns the bounding rectangle of the given source object
//   (punkObj).
//
// IDockingWindowSite::RequestBorderSpaceDW(punkObj, pbw)
//   Object requests that the site makes room for it, as specified in
//   *pbw.
//
// IDockingWindowSite::SetBorderSpaceDW(punkObj, pbw)
//   Object requests that the site set the border spacing to the size
//   specified in *pbw.
//
//-------------------------------------------------------------------------

  IDockingWindowSite = interface(IOleWindow)
    ['{2a342fc2-7b26-11d0-8ca9-00a0c92dbfe8}']
    function GetBorderDW(punkObj: IUnknown; var prcBorder: TRect): HResult; stdcall;
    function RequestBorderSpaceDW(punkObj: IUnknown; var pbw: TBorderWidths): HResult; stdcall;
    function SetBorderSpaceDW(punkObj: IUnknown; var pbw: TBorderWidths): HResult; stdcall;
  end;

//===========================================================================
//
// Task allocator API
//
//  All the shell extensions MUST use the task allocator (see OLE 2.0
// programming guild for its definition) when they allocate or free
// memory objects (mostly ITEMIDLIST) that are returned across any
// shell interfaces. There are two ways to access the task allocator
// from a shell extension depending on whether or not it is linked with
// OLE32.DLL or not (purely for efficiency).
//
// (1) A shell extension which calls any OLE API (i.e., linked with
//  OLE32.DLL) should call OLE's task allocator (by retrieving
//  the task allocator by calling CoGetMalloc API).
//
// (2) A shell extension which does not call any OLE API (i.e., not linked
//  with OLE32.DLL) should call the shell task allocator API (defined
//  below), so that the shell can quickly loads it when OLE32.DLL is not
//  loaded by any application at that point.
//
// Notes:
//  In next version of Windowso release, SHGetMalloc will be replaced by
// the following macro.
//
// #define SHGetMalloc(ppmem)   CoGetMalloc(MEMCTX_TASK, ppmem)
//
//===========================================================================
function SHGetMalloc(var ppMalloc: IMalloc): HResult; stdcall;
  external shell32dll name 'SHGetMalloc';

procedure SHAddToRecentDocs(uFlags: UINT; pv: Pointer); stdcall;
  external shell32dll name 'SHAddToRecentDocs';

function SHBrowseForFolderA(var lpbi: TBrowseInfoA): PItemIDList; stdcall;
  external shell32dll name 'SHBrowseForFolderA';

function SHBrowseForFolderW(var lpbi: TBrowseInfoW): PItemIDList; stdcall;
  external shell32dll name 'SHBrowseForFolderW';

function SHBrowseForFolder(var lpbi: TBrowseInfo): PItemIDList; stdcall;
  external shell32dll name 'SHBrowseForFolderA';

procedure SHChangeNotify(wEventId: Longint; uFlags: UINT; dwItem1, dwItem2: Pointer); stdcall;
  external shell32dll name 'SHChangeNotify';

function SHGetDataFromIDListA(psf: IShellFolder; pidl: PItemIDList; nFormat: Integer; ptr: Pointer; cb: Integer): HResult; stdcall;
  external shell32dll name 'SHGetDataFromIDListA';

function SHGetDataFromIDListW(psf: IShellFolder; pidl: PItemIDList; nFormat: Integer; ptr: Pointer; cb: Integer): HResult; stdcall;
  external shell32dll name 'SHGetDataFromIDListW';

function SHGetDataFromIDList(psf: IShellFolder; pidl: PItemIDList; nFormat: Integer; ptr: Pointer; cb: Integer): HResult; stdcall;
  external shell32dll name 'SHGetDataFromIDListA';

function SHGetDesktopFolder(var ppshf: IShellFolder): HResult; stdcall;
  external shell32dll name 'SHGetDesktopFolder';

function SHGetInstanceExplorer(var ppUnk: IUnknown): HResult; stdcall;
  external shell32dll name 'SHGetInstanceExplorer';

function SHGetPathFromIDListA(pidl: PItemIDList; pszPath: PAnsiChar): BOOL; stdcall;
  external shell32dll name 'SHGetPathFromIDListA';

function SHGetPathFromIDListW(pidl: PItemIDList; pszPath: PWideChar): BOOL; stdcall;
  external shell32dll name 'SHGetPathFromIDListW';

function SHGetPathFromIDList(pidl: PItemIDList; pszPath: PChar): BOOL; stdcall;
  external shell32dll name 'SHGetPathFromIDListA';

function SHGetSpecialFolderLocation(hwndOwner: HWND; nFolder: Integer; var ppidl: PItemIDList): HResult; stdcall;
  external shell32dll name 'SHGetSpecialFolderLocation';

function SHLoadInProc(rclsid: TCLSID): HRESULT; stdcall;
  external shell32dll name 'SHLoadInProc';

function SHGetSpecialFolderPathA(hwndOwner: HWND; lpszPath: PAnsiChar; nFolder: Integer; fCreate: BOOL): BOOL; stdcall;
  external shell32dll name 'SHGetSpecialFolderPathA';

function SHGetSpecialFolderPathW(hwndOwner: HWND; lpszPath: PWideChar; nFolder: Integer; fCreate: BOOL): BOOL; stdcall;
  external shell32dll name 'SHGetSpecialFolderPathW';

function SHGetSpecialFolderPath(hwndOwner: HWND; lpszPath: PChar; nFolder: Integer; fCreate: BOOL): BOOL; stdcall;
  external shell32dll name 'SHGetSpecialFolderPathA';

procedure SHGetSettings(var lpss: TShellFlagState; dwMask: DWORD); stdcall;
  external shell32dll name 'SHGetSettings';

function SoftwareUpdateMessageBox(hWnd: HWND; szDistUnit: PWideChar; dwFlags: DWORD; var psdi: TSoftDistInfo): DWORD; stdcall;
  external shell32dll name 'SoftwareUpdateMessageBox';

function SHGetFolderPath(hwnd: HWND; csidl: Integer; hToken: THandle; dwFlags: DWord; pszPath: PAnsiChar): HRESULT; stdcall;
  external shfolderdll name 'SHGetFolderPathA';

function SHGetFolderPathA(hwnd: HWND; csidl: Integer; hToken: THandle; dwFlags: DWord; pszPath: PAnsiChar): HRESULT; stdcall;
  external shfolderdll name 'SHGetFolderPathA';

function SHGetFolderPathW(hwnd: HWND; csidl: Integer; hToken: THandle; dwFlags: DWord; pszPath: PAnsiChar): HRESULT; stdcall;
  external shfolderdll name 'SHGetFolderPathW';

implementation
  (* nothing to implement *)
end.