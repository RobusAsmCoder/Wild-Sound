(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Base ActiveX and OLE 2 Interface Unit                  *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit ActiveX;

//+---------------------------------------------------------------------------
//
//  Microsoft Windows
//  Copyright (C) Microsoft Corporation, 1992-1997.
//
//  File:       OLE2.h
//  Contents:   Main OLE2 header; Defines Linking and Emmebbeding interfaces, and API's.
//              Also includes .h files for the compobj, and oleauto  subcomponents.
//
//----------------------------------------------------------------------------

//+---------------------------------------------------------------------------
//
//  Microsoft Windows
//  Copyright (C) Microsoft Corporation, 1992 - 1997.
//
//  File:       oleauto.h
//
//  Contents:   Defines Ole Automation support function prototypes, constants
//
//----------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////
//
// olectl.h     OLE Control interfaces
//
//              OLE Version 2.0
//
//              Copyright 1992 - 1998 Microsoft Corp. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////

(*++ BUILD Version: 0002    Increment this if a change has global effects

Copyright 1993 - 1998 Microsoft Corporation

Module Name:

        oledlg.h

Abstract:

        Include file for the OLE common dialogs.
        The following dialog implementations are provided:
                - Insert Object Dialog
                - Convert Object Dialog
                - Paste Special Dialog
                - Change Icon Dialog
                - Edit Links Dialog
                - Update Links Dialog
                - Change Source Dialog
                - Busy Dialog
                - User Error Message Dialog
                - Object Properties Dialog

--*)

interface

uses Windows, Messages, CommCtrl;

const
  ole32dll    = 'ole32.dll';
  oleaut32dll = 'oleaut32.dll';
  olepro32dll = 'olepro32.dll';
  oledlgdll   = 'oledlg.dll';

const
  MEMCTX_TASK      = 1;
  MEMCTX_SHARED    = 2;
  MEMCTX_MACSYSTEM = 3;
  MEMCTX_UNKNOWN   = -1;
  MEMCTX_SAME      = -2;

  ROTFLAGS_REGISTRATIONKEEPSALIVE = 1;
  ROTFLAGS_ALLOWANYCLIENT         = 2;

  CLSCTX_INPROC_SERVER     = 1;
  CLSCTX_INPROC_HANDLER    = 2;
  CLSCTX_LOCAL_SERVER      = 4;
  CLSCTX_INPROC_SERVER16   = 8;
  CLSCTX_REMOTE_SERVER     = $10;
  CLSCTX_INPROC_HANDLER16  = $20;
  CLSCTX_INPROC_SERVERX86  = $40;
  CLSCTX_INPROC_HANDLERX86 = $80;

  CLSCTX_ALL    = CLSCTX_INPROC_SERVER or CLSCTX_INPROC_HANDLER or
      CLSCTX_LOCAL_SERVER;
  CLSCTX_INPROC = CLSCTX_INPROC_SERVER or CLSCTX_INPROC_HANDLER;
  CLSCTX_SERVER = CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER;

  COM_RIGHTS_EXECUTE = 1;

  INTERFACESAFE_FOR_UNTRUSTED_CALLER = 1;
  INTERFACESAFE_FOR_UNTRUSTED_DATA   = 2;

  MSHLFLAGS_NORMAL      = 0;
  MSHLFLAGS_TABLESTRONG = 1;
  MSHLFLAGS_TABLEWEAK   = 2;
  MSHLFLAGS_NOPING      = 4;

  MSHCTX_LOCAL            = 0;
  MSHCTX_NOSHAREDMEM      = 1;
  MSHCTX_DIFFERENTMACHINE = 2;
  MSHCTX_INPROC           = 3;

  DVASPECT_CONTENT   = 1;
  DVASPECT_THUMBNAIL = 2;
  DVASPECT_ICON      = 4;
  DVASPECT_DOCPRINT  = 8;

  STGC_DEFAULT                            = 0;
  STGC_OVERWRITE                          = 1;
  STGC_ONLYIFCURRENT                      = 2;
  STGC_DANGEROUSLYCOMMITMERELYTODISKCACHE = 4;

  STGMOVE_MOVE        = 0;
  STGMOVE_COPY        = 1;
  STGMOVE_SHALLOWCOPY = 2;

  STATFLAG_DEFAULT = 0;
  STATFLAG_NONAME  = 1;

  BIND_MAYBOTHERUSER     = 1;
  BIND_JUSTTESTEXISTENCE = 2;

  MKSYS_NONE             = 0;
  MKSYS_GENERICCOMPOSITE = 1;
  MKSYS_FILEMONIKER      = 2;
  MKSYS_ANTIMONIKER      = 3;
  MKSYS_ITEMMONIKER      = 4;
  MKSYS_POINTERMONIKER   = 5;

  MKRREDUCE_ONE         = 3 shl 16;
  MKRREDUCE_TOUSER      = 2 shl 16;
  MKRREDUCE_THROUGHUSER = 1 shl 16;
  MKRREDUCE_ALL         = 0;

  STGTY_STORAGE   = 1;
  STGTY_STREAM    = 2;
  STGTY_LOCKBYTES = 3;
  STGTY_PROPERTY  = 4;

  STREAM_SEEK_SET = 0;
  STREAM_SEEK_CUR = 1;
  STREAM_SEEK_END = 2;

  LOCK_WRITE     = 1;
  LOCK_EXCLUSIVE = 2;
  LOCK_ONLYONCE  = 4;

  ADVF_NODATA            = 1;
  ADVF_PRIMEFIRST        = 2;
  ADVF_ONLYONCE          = 4;
  ADVF_DATAONSTOP        = 64;
  ADVFCACHE_NOHANDLER    = 8;
  ADVFCACHE_FORCEBUILTIN = 16;
  ADVFCACHE_ONSAVE       = 32;

  TYMED_HGLOBAL  = 1;
  TYMED_FILE     = 2;
  TYMED_ISTREAM  = 4;
  TYMED_ISTORAGE = 8;
  TYMED_GDI      = 16;
  TYMED_MFPICT   = 32;
  TYMED_ENHMF    = 64;
  TYMED_NULL     = 0;

  DATADIR_GET = 1;
  DATADIR_SET = 2;

  CALLTYPE_TOPLEVEL             = 1;
  CALLTYPE_NESTED               = 2;
  CALLTYPE_ASYNC                = 3;
  CALLTYPE_TOPLEVEL_CALLPENDING = 4;
  CALLTYPE_ASYNC_CALLPENDING    = 5;

  SERVERCALL_ISHANDLED  = 0;
  SERVERCALL_REJECTED   = 1;
  SERVERCALL_RETRYLATER = 2;

  PENDINGTYPE_TOPLEVEL = 1;
  PENDINGTYPE_NESTED   = 2;

  PENDINGMSG_CANCELCALL     = 0;
  PENDINGMSG_WAITNOPROCESS  = 1;
  PENDINGMSG_WAITDEFPROCESS = 2;

  PROPSETFLAG_DEFAULT   = 0;
  PROPSETFLAG_NONSIMPLE = 1;
  PROPSETFLAG_ANSI      = 2;

  PROPSETHDR_OSVERSION_UNKNOWN = $FFFFFFFF;
  ACTIVEOBJECT_STRONG   = 0;
  ACTIVEOBJECT_WEAK     = 1;

  REGCLS_SINGLEUSE      = 0;
  REGCLS_MULTIPLEUSE    = 1;
  REGCLS_MULTI_SEPARATE = 2;
  REGCLS_SUSPENDED      = 4;

  MARSHALINTERFACE_MIN = 500;

  CWCSTORAGENAME = 32;

  STGM_DIRECT           = $00000000;
  STGM_TRANSACTED       = $00010000;
  STGM_SIMPLE           = $08000000;

  STGM_READ             = $00000000;
  STGM_WRITE            = $00000001;
  STGM_READWRITE        = $00000002;

  STGM_SHARE_DENY_NONE  = $00000040;
  STGM_SHARE_DENY_READ  = $00000030;
  STGM_SHARE_DENY_WRITE = $00000020;
  STGM_SHARE_EXCLUSIVE  = $00000010;

  STGM_PRIORITY         = $00040000;
  STGM_DELETEONRELEASE  = $04000000;
  STGM_NOSCRATCH        = $00100000;

  STGM_CREATE           = $00001000;
  STGM_CONVERT          = $00020000;
  STGM_FAILIFTHERE      = $00000000;

  FADF_AUTO      = $0001;
  FADF_STATIC    = $0002;
  FADF_EMBEDDED  = $0004;
  FADF_FIXEDSIZE = $0010;
  FADF_BSTR      = $0100;
  FADF_UNKNOWN   = $0200;
  FADF_DISPATCH  = $0400;
  FADF_VARIANT   = $0800;
  FADF_RESERVED  = $F0E8;

  TKIND_ENUM      = 0;
  TKIND_RECORD    = 1;
  TKIND_MODULE    = 2;
  TKIND_INTERFACE = 3;
  TKIND_DISPATCH  = 4;
  TKIND_COCLASS   = 5;
  TKIND_ALIAS     = 6;
  TKIND_UNION     = 7;
  TKIND_MAX       = 8;

  CC_CDECL       = 1;
  CC_PASCAL      = 2;
  CC_MACPASCAL   = 3;
  CC_STDCALL     = 4;
  CC_FPFASTCALL  = 5;
  CC_SYSCALL     = 6;
  CC_MPWCDECL    = 7;
  CC_MPWPASCAL   = 8;
  CC_MAX         = 9;

  FUNC_VIRTUAL     = 0;
  FUNC_PUREVIRTUAL = 1;
  FUNC_NONVIRTUAL  = 2;
  FUNC_STATIC      = 3;
  FUNC_DISPATCH    = 4;

  INVOKE_FUNC           = 1;
  INVOKE_PROPERTYGET    = 2;
  INVOKE_PROPERTYPUT    = 4;
  INVOKE_PROPERTYPUTREF = 8;

  VAR_PERINSTANCE = 0;
  VAR_STATIC      = 1;
  VAR_CONST       = 2;
  VAR_DISPATCH    = 3;

  IMPLTYPEFLAG_FDEFAULT        = 1;
  IMPLTYPEFLAG_FSOURCE         = 2;
  IMPLTYPEFLAG_FRESTRICTED     = 4;
  IMPLTYPEFLAG_FDEFAULTVTABLE  = 8;

  TYPEFLAG_FAPPOBJECT     = $0001;
  TYPEFLAG_FCANCREATE     = $0002;
  TYPEFLAG_FLICENSED      = $0004;
  TYPEFLAG_FPREDECLID     = $0008;
  TYPEFLAG_FHIDDEN        = $0010;
  TYPEFLAG_FCONTROL       = $0020;
  TYPEFLAG_FDUAL          = $0040;
  TYPEFLAG_FNONEXTENSIBLE = $0080;
  TYPEFLAG_FOLEAUTOMATION = $0100;
  TYPEFLAG_FRESTRICTED    = $0200;
  TYPEFLAG_FAGGREGATABLE  = $0400;
  TYPEFLAG_FREPLACEABLE   = $0800;
  TYPEFLAG_FDISPATCHABLE  = $1000;
  TYPEFLAG_FREVERSEBIND   = $2000;

  FUNCFLAG_FRESTRICTED       = $0001;
  FUNCFLAG_FSOURCE           = $0002;
  FUNCFLAG_FBINDABLE         = $0004;
  FUNCFLAG_FREQUESTEDIT      = $0008;
  FUNCFLAG_FDISPLAYBIND      = $0010;
  FUNCFLAG_FDEFAULTBIND      = $0020;
  FUNCFLAG_FHIDDEN           = $0040;
  FUNCFLAG_FUSESGETLASTERROR = $0080;
  FUNCFLAG_FDEFAULTCOLLELEM  = $0100;
  FUNCFLAG_FUIDEFAULT        = $0200;
  FUNCFLAG_FNONBROWSABLE     = $0400;
  FUNCFLAG_FREPLACEABLE      = $0800;
  FUNCFLAG_FIMMEDIATEBIND    = $1000;

  VARFLAG_FREADONLY        = $0001;
  VARFLAG_FSOURCE          = $0002;
  VARFLAG_FBINDABLE        = $0004;
  VARFLAG_FREQUESTEDIT     = $0008;
  VARFLAG_FDISPLAYBIND     = $0010;
  VARFLAG_FDEFAULTBIND     = $0020;
  VARFLAG_FHIDDEN          = $0040;
  VARFLAG_FRESTRICTED      = $0080;
  VARFLAG_FDEFAULTCOLLELEM = $0100;
  VARFLAG_FUIDEFAULT       = $0200;
  VARFLAG_FNONBROWSABLE    = $0400;
  VARFLAG_FREPLACEABLE     = $0800;
  VARFLAG_FIMMEDIATEBIND   = $1000;

  DISPID_VALUE       = 0;
  DISPID_UNKNOWN     = -1;
  DISPID_PROPERTYPUT = -3;
  DISPID_NEWENUM     = -4;
  DISPID_EVALUATE    = -5;
  DISPID_CONSTRUCTOR = -6;
  DISPID_DESTRUCTOR  = -7;
  DISPID_COLLECT     = -8;

  DESCKIND_NONE = 0;
  DESCKIND_FUNCDESC = 1;
  DESCKIND_VARDESC = 2;
  DESCKIND_TYPECOMP = 3;
  DESCKIND_IMPLICITAPPOBJ = 4;
  DESCKIND_MAX = 5;

  SYS_WIN16 = 0;
  SYS_WIN32 = 1;
  SYS_MAC   = 2;

  COINIT_MULTITHREADED      = 0;
  COINIT_APARTMENTTHREADED  = 2;
  COINIT_DISABLE_OLE1DDE    = 4;
  COINIT_SPEED_OVER_MEMORY  = 8;

  LIBFLAG_FRESTRICTED   = 1;
  LIBFLAG_FCONTROL      = 2;
  LIBFLAG_FHIDDEN       = 4;
  LIBFLAG_FHASDISKIMAGE = 8;

  STDOLE_MAJORVERNUM = 1;
  STDOLE_MINORVERNUM = 0;
  STDOLE_LCID = 0;

  VARIANT_NOVALUEPROP = 1;

  VAR_TIMEVALUEONLY = 1;
  VAR_DATEVALUEONLY = 2;

  MEMBERID_NIL = DISPID_UNKNOWN;
  ID_DEFAULTINST = -2;

  DISPATCH_METHOD         = 1;
  DISPATCH_PROPERTYGET    = 2;
  DISPATCH_PROPERTYPUT    = 4;
  DISPATCH_PROPERTYPUTREF = 8;

  IDLFLAG_NONE    = 0;
  IDLFLAG_FIN     = 1;
  IDLFLAG_FOUT    = 2;
  IDLFLAG_FLCID   = 4;
  IDLFLAG_FRETVAL = 8;

  PARAMFLAG_NONE          = $00;
  PARAMFLAG_FIN           = $01;
  PARAMFLAG_FOUT          = $02;
  PARAMFLAG_FLCID         = $04;
  PARAMFLAG_FRETVAL       = $08;
  PARAMFLAG_FOPT          = $10;
  PARAMFLAG_FHASDEFAULT   = $20;

  OLEIVERB_PRIMARY          = 0;
  OLEIVERB_SHOW             = -1;
  OLEIVERB_OPEN             = -2;
  OLEIVERB_HIDE             = -3;
  OLEIVERB_UIACTIVATE       = -4;
  OLEIVERB_INPLACEACTIVATE  = -5;
  OLEIVERB_DISCARDUNDOSTATE = -6;

  EMBDHLP_INPROC_HANDLER = $00000000;
  EMBDHLP_INPROC_SERVER  = $00000001;
  EMBDHLP_CREATENOW      = $00000000;
  EMBDHLP_DELAYCREATE    = $00010000;

  OLECREATE_LEAVERUNNING = $00000001;

  UPDFCACHE_NODATACACHE = 1;
  UPDFCACHE_ONSAVECACHE = 2;
  UPDFCACHE_ONSTOPCACHE = 4;
  UPDFCACHE_NORMALCACHE = 8;
  UPDFCACHE_IFBLANK     = $10;
  UPDFCACHE_ONLYIFBLANK = DWORD($80000000);

  UPDFCACHE_IFBLANKORONSAVECACHE = UPDFCACHE_IFBLANK or UPDFCACHE_ONSAVECACHE;
  UPDFCACHE_ALL                  = not UPDFCACHE_ONLYIFBLANK;
  UPDFCACHE_ALLBUTNODATACACHE    = UPDFCACHE_ALL and not UPDFCACHE_NODATACACHE;

  DISCARDCACHE_SAVEIFDIRTY = 0;
  DISCARDCACHE_NOSAVE      = 1;

  OLEGETMONIKER_ONLYIFTHERE = 1;
  OLEGETMONIKER_FORCEASSIGN = 2;
  OLEGETMONIKER_UNASSIGN    = 3;
  OLEGETMONIKER_TEMPFORUSER = 4;

  OLEWHICHMK_CONTAINER = 1;
  OLEWHICHMK_OBJREL    = 2;
  OLEWHICHMK_OBJFULL   = 3;

  USERCLASSTYPE_FULL    = 1;
  USERCLASSTYPE_SHORT   = 2;
  USERCLASSTYPE_APPNAME = 3;

  OLEMISC_RECOMPOSEONRESIZE            = 1;
  OLEMISC_ONLYICONIC                   = 2;
  OLEMISC_INSERTNOTREPLACE             = 4;
  OLEMISC_STATIC                       = 8;
  OLEMISC_CANTLINKINSIDE               = $10;
  OLEMISC_CANLINKBYOLE1                = $20;
  OLEMISC_ISLINKOBJECT                 = $40;
  OLEMISC_INSIDEOUT                    = $80;
  OLEMISC_ACTIVATEWHENVISIBLE          = $100;
  OLEMISC_RENDERINGISDEVICEINDEPENDENT = $200;
  OLEMISC_INVISIBLEATRUNTIME           = $400;
  OLEMISC_ALWAYSRUN                    = $800;
  OLEMISC_ACTSLIKEBUTTON               = $1000;
  OLEMISC_ACTSLIKELABEL                = $2000;
  OLEMISC_NOUIACTIVATE                 = $4000;
  OLEMISC_ALIGNABLE                    = $8000;
  OLEMISC_SIMPLEFRAME                  = $10000;
  OLEMISC_SETCLIENTSITEFIRST           = $20000;
  OLEMISC_IMEMODE                      = $40000;
  OLEMISC_IGNOREACTIVATEWHENVISIBLE    = $80000;
  OLEMISC_WANTSTOMENUMERGE             = $100000;
  OLEMISC_SUPPORTSMULTILEVELUNDO       = $200000;

  OLECLOSE_SAVEIFDIRTY = 0;
  OLECLOSE_NOSAVE      = 1;
  OLECLOSE_PROMPTSAVE  = 2;

  OLERENDER_NONE   = 0;
  OLERENDER_DRAW   = 1;
  OLERENDER_FORMAT = 2;
  OLERENDER_ASIS   = 3;

  OLEUPDATE_ALWAYS = 1;
  OLEUPDATE_ONCALL = 3;

  OLELINKBIND_EVENIFCLASSDIFF = 1;

  BINDSPEED_INDEFINITE = 1;
  BINDSPEED_MODERATE   = 2;
  BINDSPEED_IMMEDIATE  = 3;

  OLECONTF_EMBEDDINGS    = 1;
  OLECONTF_LINKS         = 2;
  OLECONTF_OTHERS        = 4;
  OLECONTF_ONLYUSER      = 8;
  OLECONTF_ONLYIFRUNNING = 16;

  DROPEFFECT_NONE   = 0;
  DROPEFFECT_COPY   = 1;
  DROPEFFECT_MOVE   = 2;
  DROPEFFECT_LINK   = 4;
  DROPEFFECT_SCROLL = $80000000;

  DD_DEFSCROLLINSET    = 11;
  DD_DEFSCROLLDELAY    = 50;
  DD_DEFSCROLLINTERVAL = 50;
  DD_DEFDRAGDELAY      = 200;
  DD_DEFDRAGMINDIST    = 2;

  OLEVERBATTRIB_NEVERDIRTIES    = 1;
  OLEVERBATTRIB_ONCONTAINERMENU = 2;

  CTL_E_ILLEGALFUNCTIONCALL       = $800A0000 + 5;
  CTL_E_OVERFLOW                  = $800A0000 + 6;
  CTL_E_OUTOFMEMORY               = $800A0000 + 7;
  CTL_E_DIVISIONBYZERO            = $800A0000 + 11;
  CTL_E_OUTOFSTRINGSPACE          = $800A0000 + 14;
  CTL_E_OUTOFSTACKSPACE           = $800A0000 + 28;
  CTL_E_BADFILENAMEORNUMBER       = $800A0000 + 52;
  CTL_E_FILENOTFOUND              = $800A0000 + 53;
  CTL_E_BADFILEMODE               = $800A0000 + 54;
  CTL_E_FILEALREADYOPEN           = $800A0000 + 55;
  CTL_E_DEVICEIOERROR             = $800A0000 + 57;
  CTL_E_FILEALREADYEXISTS         = $800A0000 + 58;
  CTL_E_BADRECORDLENGTH           = $800A0000 + 59;
  CTL_E_DISKFULL                  = $800A0000 + 61;
  CTL_E_BADRECORDNUMBER           = $800A0000 + 63;
  CTL_E_BADFILENAME               = $800A0000 + 64;
  CTL_E_TOOMANYFILES              = $800A0000 + 67;
  CTL_E_DEVICEUNAVAILABLE         = $800A0000 + 68;
  CTL_E_PERMISSIONDENIED          = $800A0000 + 70;
  CTL_E_DISKNOTREADY              = $800A0000 + 71;
  CTL_E_PATHFILEACCESSERROR       = $800A0000 + 75;
  CTL_E_PATHNOTFOUND              = $800A0000 + 76;
  CTL_E_INVALIDPATTERNSTRING      = $800A0000 + 93;
  CTL_E_INVALIDUSEOFNULL          = $800A0000 + 94;
  CTL_E_INVALIDFILEFORMAT         = $800A0000 + 321;
  CTL_E_INVALIDPROPERTYVALUE      = $800A0000 + 380;
  CTL_E_INVALIDPROPERTYARRAYINDEX = $800A0000 + 381;
  CTL_E_SETNOTSUPPORTEDATRUNTIME  = $800A0000 + 382;
  CTL_E_SETNOTSUPPORTED           = $800A0000 + 383;
  CTL_E_NEEDPROPERTYARRAYINDEX    = $800A0000 + 385;
  CTL_E_SETNOTPERMITTED           = $800A0000 + 387;
  CTL_E_GETNOTSUPPORTEDATRUNTIME  = $800A0000 + 393;
  CTL_E_GETNOTSUPPORTED           = $800A0000 + 394;
  CTL_E_PROPERTYNOTFOUND          = $800A0000 + 422;
  CTL_E_INVALIDCLIPBOARDFORMAT    = $800A0000 + 460;
  CTL_E_INVALIDPICTURE            = $800A0000 + 481;
  CTL_E_PRINTERERROR              = $800A0000 + 482;
  CTL_E_CANTSAVEFILETOTEMP        = $800A0000 + 735;
  CTL_E_SEARCHTEXTNOTFOUND        = $800A0000 + 744;
  CTL_E_REPLACEMENTSTOOLONG       = $800A0000 + 746;

  CTL_E_CUSTOM_FIRST = $800A0000 + 600;

  CLASS_E_NOTLICENSED = CLASSFACTORY_E_FIRST + 2;

  CONNECT_E_FIRST = $80040200;
  CONNECT_E_LAST  = $8004020F;
  CONNECT_S_FIRST = $00040200;
  CONNECT_S_LAST  = $0004020F;

  CONNECT_E_NOCONNECTION  = CONNECT_E_FIRST + 0;
  CONNECT_E_ADVISELIMIT   = CONNECT_E_FIRST + 1;
  CONNECT_E_CANNOTCONNECT = CONNECT_E_FIRST + 2;
  CONNECT_E_OVERRIDDEN    = CONNECT_E_FIRST + 3;

  SELFREG_E_FIRST = $80040200;
  SELFREG_E_LAST  = $80040200;
  SELFREG_S_FIRST = $00040200;
  SELFREG_S_LAST  = $00040200;

  SELFREG_E_TYPELIB = SELFREG_E_FIRST + 0;
  SELFREG_E_CLASS   = SELFREG_E_FIRST + 1;

  PERPROP_E_FIRST = $80040200;
  PERPROP_E_LAST  = $8004020F;
  PERPROP_S_FIRST = $00040200;
  PERPROP_S_LAST  = $0004020F;

  PERPROP_E_NOPAGEAVAILABLE = PERPROP_E_FIRST + 0;

  OLEIVERB_PROPERTIES = -7;

  VT_STREAMED_PROPSET = 73;
  VT_STORED_PROPSET   = 74;
  VT_BLOB_PROPSET     = 75;
  VT_VERBOSE_ENUM     = 76;

  VT_COLOR          = VT_I4;
  VT_XPOS_PIXELS    = VT_I4;
  VT_YPOS_PIXELS    = VT_I4;
  VT_XSIZE_PIXELS   = VT_I4;
  VT_YSIZE_PIXELS   = VT_I4;
  VT_XPOS_HIMETRIC  = VT_I4;
  VT_YPOS_HIMETRIC  = VT_I4;
  VT_XSIZE_HIMETRIC = VT_I4;
  VT_YSIZE_HIMETRIC = VT_I4;
  VT_TRISTATE       = VT_I2;
  VT_OPTEXCLUSIVE   = VT_BOOL;
  VT_FONT           = VT_DISPATCH;
  VT_PICTURE        = VT_DISPATCH;
  VT_HANDLE         = VT_I4;

  OCM__BASE = WM_USER + $1C00;

  OCM_COMMAND           = OCM__BASE + WM_COMMAND;
  OCM_CTLCOLORBTN       = OCM__BASE + WM_CTLCOLORBTN;
  OCM_CTLCOLOREDIT      = OCM__BASE + WM_CTLCOLOREDIT;
  OCM_CTLCOLORDLG       = OCM__BASE + WM_CTLCOLORDLG;
  OCM_CTLCOLORLISTBOX   = OCM__BASE + WM_CTLCOLORLISTBOX;
  OCM_CTLCOLORMSGBOX    = OCM__BASE + WM_CTLCOLORMSGBOX;
  OCM_CTLCOLORSCROLLBAR = OCM__BASE + WM_CTLCOLORSCROLLBAR;
  OCM_CTLCOLORSTATIC    = OCM__BASE + WM_CTLCOLORSTATIC;
  OCM_DRAWITEM          = OCM__BASE + WM_DRAWITEM;
  OCM_MEASUREITEM       = OCM__BASE + WM_MEASUREITEM;
  OCM_DELETEITEM        = OCM__BASE + WM_DELETEITEM;
  OCM_VKEYTOITEM        = OCM__BASE + WM_VKEYTOITEM;
  OCM_CHARTOITEM        = OCM__BASE + WM_CHARTOITEM;
  OCM_COMPAREITEM       = OCM__BASE + WM_COMPAREITEM;
  OCM_HSCROLL           = OCM__BASE + WM_HSCROLL;
  OCM_VSCROLL           = OCM__BASE + WM_VSCROLL;
  OCM_PARENTNOTIFY      = OCM__BASE + WM_PARENTNOTIFY;
  OCM_NOTIFY            = OCM__BASE + WM_NOTIFY;

  CTRLINFO_EATS_RETURN = 1;
  CTRLINFO_EATS_ESCAPE = 2;

  XFORMCOORDS_POSITION            = 1;
  XFORMCOORDS_SIZE                = 2;
  XFORMCOORDS_HIMETRICTOCONTAINER = 4;
  XFORMCOORDS_CONTAINERTOHIMETRIC = 8;

  PROPPAGESTATUS_DIRTY    = 1;
  PROPPAGESTATUS_VALIDATE = 2;
  PROPPAGESTATUS_CLEAN    = 4;

  PICTURE_SCALABLE    = 1;
  PICTURE_TRANSPARENT = 2;

  PICTYPE_UNINITIALIZED = -1;
  PICTYPE_NONE          = 0;
  PICTYPE_BITMAP        = 1;
  PICTYPE_METAFILE      = 2;
  PICTYPE_ICON          = 3;
  PICTYPE_ENHMETAFILE   = 4;

  DISPID_AUTOSIZE      = -500;
  DISPID_BACKCOLOR     = -501;
  DISPID_BACKSTYLE     = -502;
  DISPID_BORDERCOLOR   = -503;
  DISPID_BORDERSTYLE   = -504;
  DISPID_BORDERWIDTH   = -505;
  DISPID_DRAWMODE      = -507;
  DISPID_DRAWSTYLE     = -508;
  DISPID_DRAWWIDTH     = -509;
  DISPID_FILLCOLOR     = -510;
  DISPID_FILLSTYLE     = -511;
  DISPID_FONT          = -512;
  DISPID_FORECOLOR     = -513;
  DISPID_ENABLED       = -514;
  DISPID_HWND          = -515;
  DISPID_TABSTOP       = -516;
  DISPID_TEXT          = -517;
  DISPID_CAPTION       = -518;
  DISPID_BORDERVISIBLE = -519;
  DISPID_APPEARANCE    = -520;
  DISPID_MOUSEPOINTER  = -521;
  DISPID_MOUSEICON     = -522;
  DISPID_PICTURE       = -523;
  DISPID_VALID         = -524;
  DISPID_READYSTATE    = -525;

  DISPID_REFRESH  = -550;
  DISPID_DOCLICK  = -551;
  DISPID_ABOUTBOX = -552;

  DISPID_CLICK            = -600;
  DISPID_DBLCLICK         = -601;
  DISPID_KEYDOWN          = -602;
  DISPID_KEYPRESS         = -603;
  DISPID_KEYUP            = -604;
  DISPID_MOUSEDOWN        = -605;
  DISPID_MOUSEMOVE        = -606;
  DISPID_MOUSEUP          = -607;
  DISPID_ERROREVENT       = -608;
  DISPID_READYSTATECHANGE = -609;

  DISPID_AMBIENT_BACKCOLOR         = -701;
  DISPID_AMBIENT_DISPLAYNAME       = -702;
  DISPID_AMBIENT_FONT              = -703;
  DISPID_AMBIENT_FORECOLOR         = -704;
  DISPID_AMBIENT_LOCALEID          = -705;
  DISPID_AMBIENT_MESSAGEREFLECT    = -706;
  DISPID_AMBIENT_SCALEUNITS        = -707;
  DISPID_AMBIENT_TEXTALIGN         = -708;
  DISPID_AMBIENT_USERMODE          = -709;
  DISPID_AMBIENT_UIDEAD            = -710;
  DISPID_AMBIENT_SHOWGRABHANDLES   = -711;
  DISPID_AMBIENT_SHOWHATCHING      = -712;
  DISPID_AMBIENT_DISPLAYASDEFAULT  = -713;
  DISPID_AMBIENT_SUPPORTSMNEMONICS = -714;
  DISPID_AMBIENT_AUTOCLIP          = -715;
  DISPID_AMBIENT_APPEARANCE        = -716;

  DISPID_AMBIENT_PALETTE           = -726;
  DISPID_AMBIENT_TRANSFERPRIORITY  = -728;

  DISPID_Name                      = -800;
  DISPID_Delete                    = -801;
  DISPID_Object                    = -802;
  DISPID_Parent                    = -803;

  DISPID_FONT_NAME    = 0;
  DISPID_FONT_SIZE    = 2;
  DISPID_FONT_BOLD    = 3;
  DISPID_FONT_ITALIC  = 4;
  DISPID_FONT_UNDER   = 5;
  DISPID_FONT_STRIKE  = 6;
  DISPID_FONT_WEIGHT  = 7;
  DISPID_FONT_CHARSET = 8;

  DISPID_PICT_HANDLE = 0;
  DISPID_PICT_HPAL   = 2;
  DISPID_PICT_TYPE   = 3;
  DISPID_PICT_WIDTH  = 4;
  DISPID_PICT_HEIGHT = 5;
  DISPID_PICT_RENDER = 6;

  PID_DICTIONARY         = 0;
  PID_CODEPAGE           = $1;
  PID_FIRST_USABLE       = $2;
  PID_FIRST_NAME_DEFAULT = $fff;
  PID_LOCALE             = $80000000;
  PID_MODIFY_TIME        = $80000001;
  PID_SECURITY           = $80000002;
  PID_ILLEGAL            = $ffffffff;

  PIDSI_TITLE               = $00000002;
  PIDSI_SUBJECT             = $00000003;
  PIDSI_AUTHOR              = $00000004;
  PIDSI_KEYWORDS            = $00000005;
  PIDSI_COMMENTS            = $00000006;
  PIDSI_TEMPLATE            = $00000007;
  PIDSI_LASTAUTHOR          = $00000008;
  PIDSI_REVNUMBER           = $00000009;
  PIDSI_EDITTIME            = $0000000a;
  PIDSI_LASTPRINTED         = $0000000b;
  PIDSI_CREATE_DTM          = $0000000c;
  PIDSI_LASTSAVE_DTM        = $0000000d;
  PIDSI_PAGECOUNT           = $0000000e;
  PIDSI_WORDCOUNT           = $0000000f;
  PIDSI_CHARCOUNT           = $00000010;
  PIDSI_THUMBNAIL           = $00000011;
  PIDSI_APPNAME             = $00000012;
  PIDSI_DOC_SECURITY        = $00000013;

  PRSPEC_INVALID            = $ffffffff;
  PRSPEC_LPWSTR             = 0;
  PRSPEC_PROPID             = 1;

  triUnchecked = 0;
  triChecked   = 1;
  triGray      = 2;

  PRINTFLAG_MAYBOTHERUSER         = 1;
  PRINTFLAG_PROMPTUSER            = 2;
  PRINTFLAG_USERMAYCHANGEPRINTER  = 4;
  PRINTFLAG_RECOMPOSETODEVICE     = 8;
  PRINTFLAG_DONTACTUALLYPRINT     = 16;
  PRINTFLAG_FORCEPROPERTIES       = 32;
  PRINTFLAG_PRINTTOFILE           = 64;

  PAGESET_TOLASTPAGE              = Cardinal(-1);

  CLSID_StdComponentCategoryMgr: TGUID = '{0002E005-0000-0000-C000-000000000046}';
  GUID_NULL: TGUID = '{00000000-0000-0000-0000-000000000000}';
  GUID_OLE_COLOR: TGUID = '{66504301-BE0F-101A-8BBB-00AA00300CAB}';
  CATID_WebDesigntimeControl: TGUID = '{73cef3dd-ae85-11cf-a406-00aa00c00940}';

  IDC_OLEUIHELP                   = 99;
  IDC_IO_CREATENEW                = 2100;
  IDC_IO_CREATEFROMFILE           = 2101;
  IDC_IO_LINKFILE                 = 2102;
  IDC_IO_OBJECTTYPELIST           = 2103;
  IDC_IO_DISPLAYASICON            = 2104;
  IDC_IO_CHANGEICON               = 2105;
  IDC_IO_FILE                     = 2106;
  IDC_IO_FILEDISPLAY              = 2107;
  IDC_IO_RESULTIMAGE              = 2108;
  IDC_IO_RESULTTEXT               = 2109;
  IDC_IO_ICONDISPLAY              = 2110;
  IDC_IO_OBJECTTYPETEXT           = 2111;
  IDC_IO_FILETEXT                 = 2112;
  IDC_IO_FILETYPE                 = 2113;
  IDC_IO_INSERTCONTROL            = 2114;
  IDC_IO_ADDCONTROL               = 2115;
  IDC_IO_CONTROLTYPELIST          = 2116;

  IDC_PS_PASTE                    = 500;
  IDC_PS_PASTELINK                = 501;
  IDC_PS_SOURCETEXT               = 502;
  IDC_PS_PASTELIST                = 503;
  IDC_PS_PASTELINKLIST            = 504;
  IDC_PS_DISPLAYLIST              = 505;
  IDC_PS_DISPLAYASICON            = 506;
  IDC_PS_ICONDISPLAY              = 507;
  IDC_PS_CHANGEICON               = 508;
  IDC_PS_RESULTIMAGE              = 509;
  IDC_PS_RESULTTEXT               = 510;

  IDC_CI_GROUP                    = 120;
  IDC_CI_CURRENT                  = 121;
  IDC_CI_CURRENTICON              = 122;
  IDC_CI_DEFAULT                  = 123;
  IDC_CI_DEFAULTICON              = 124;
  IDC_CI_FROMFILE                 = 125;
  IDC_CI_FROMFILEEDIT             = 126;
  IDC_CI_ICONLIST                 = 127;
  IDC_CI_LABEL                    = 128;
  IDC_CI_LABELEDIT                = 129;
  IDC_CI_BROWSE                   = 130;
  IDC_CI_ICONDISPLAY              = 131;

  IDC_CV_OBJECTTYPE               = 150;
  IDC_CV_DISPLAYASICON            = 152;
  IDC_CV_CHANGEICON               = 153;
  IDC_CV_ACTIVATELIST             = 154;
  IDC_CV_CONVERTTO                = 155;
  IDC_CV_ACTIVATEAS               = 156;
  IDC_CV_RESULTTEXT               = 157;
  IDC_CV_CONVERTLIST              = 158;
  IDC_CV_ICONDISPLAY              = 165;

  IDC_EL_CHANGESOURCE             = 201;
  IDC_EL_AUTOMATIC                = 202;
  IDC_EL_CANCELLINK               = 209;
  IDC_EL_UPDATENOW                = 210;
  IDC_EL_OPENSOURCE               = 211;
  IDC_EL_MANUAL                   = 212;
  IDC_EL_LINKSOURCE               = 216;
  IDC_EL_LINKTYPE                 = 217;
  IDC_EL_LINKSLISTBOX             = 206;
  IDC_EL_COL1                     = 220;
  IDC_EL_COL2                     = 221;
  IDC_EL_COL3                     = 222;

  IDC_BZ_RETRY                    = 600;
  IDC_BZ_ICON                     = 601;
  IDC_BZ_MESSAGE1                 = 602;
  IDC_BZ_SWITCHTO                 = 604;

  IDC_UL_METER                    = 1029;
  IDC_UL_STOP                     = 1030;
  IDC_UL_PERCENT                  = 1031;
  IDC_UL_PROGRESS                 = 1032;

  IDC_PU_LINKS                    = 900;
  IDC_PU_TEXT                     = 901;
  IDC_PU_CONVERT                  = 902;
  IDC_PU_ICON                     = 908;

  IDC_GP_OBJECTNAME               = 1009;
  IDC_GP_OBJECTTYPE               = 1010;
  IDC_GP_OBJECTSIZE               = 1011;
  IDC_GP_CONVERT                  = 1013;
  IDC_GP_OBJECTICON               = 1014;
  IDC_GP_OBJECTLOCATION           = 1022;

  IDC_VP_PERCENT                  = 1000;
  IDC_VP_CHANGEICON               = 1001;
  IDC_VP_EDITABLE                 = 1002;
  IDC_VP_ASICON                   = 1003;
  IDC_VP_RELATIVE                 = 1005;
  IDC_VP_SPIN                     = 1006;
  IDC_VP_SCALETXT                 = 1034;
  IDC_VP_ICONDISPLAY              = 1021;
  IDC_VP_RESULTIMAGE              = 1033;

  IDC_LP_OPENSOURCE               = 1006;
  IDC_LP_UPDATENOW                = 1007;
  IDC_LP_BREAKLINK                = 1008;
  IDC_LP_LINKSOURCE               = 1012;
  IDC_LP_CHANGESOURCE             = 1015;
  IDC_LP_AUTOMATIC                = 1016;
  IDC_LP_MANUAL                   = 1017;
  IDC_LP_DATE                     = 1018;
  IDC_LP_TIME                     = 1019;

  IDD_INSERTOBJECT                = 1000;
  IDD_CHANGEICON                  = 1001;
  IDD_CONVERT                     = 1002;
  IDD_PASTESPECIAL                = 1003;
  IDD_EDITLINKS                   = 1004;
  IDD_BUSY                        = 1006;
  IDD_UPDATELINKS                 = 1007;
  IDD_CHANGESOURCE                = 1009;
  IDD_INSERTFILEBROWSE            = 1010;
  IDD_CHANGEICONBROWSE            = 1011;
  IDD_CONVERTONLY                 = 1012;
  IDD_CHANGESOURCE4               = 1013;
  IDD_GNRLPROPS                   = 1100;
  IDD_VIEWPROPS                   = 1101;
  IDD_LINKPROPS                   = 1102;

  IDD_CANNOTUPDATELINK            = 1008;
  IDD_LINKSOURCEUNAVAILABLE       = 1020;
  IDD_SERVERNOTFOUND              = 1023;
  IDD_OUTOFMEMORY                 = 1024;
  IDD_SERVERNOTREG                = 1021;
  IDD_LINKTYPECHANGED             = 1022;

  OLESTDDELIM = '\';

  SZOLEUI_MSG_HELP                = 'OLEUI_MSG_HELP';
  SZOLEUI_MSG_ENDDIALOG           = 'OLEUI_MSG_ENDDIALOG';
  SZOLEUI_MSG_BROWSE              = 'OLEUI_MSG_BROWSE';
  SZOLEUI_MSG_CHANGEICON          = 'OLEUI_MSG_CHANGEICON';
  SZOLEUI_MSG_CLOSEBUSYDIALOG     = 'OLEUI_MSG_CLOSEBUSYDIALOG';
  SZOLEUI_MSG_CONVERT             = 'OLEUI_MSG_CONVERT';
  SZOLEUI_MSG_CHANGESOURCE        = 'OLEUI_MSG_CHANGESOURCE';
  SZOLEUI_MSG_ADDCONTROL          = 'OLEUI_MSG_ADDCONTROL';
  SZOLEUI_MSG_BROWSE_OFN          = 'OLEUI_MSG_BROWSE_OFN';

  ID_BROWSE_CHANGEICON            = 1;
  ID_BROWSE_INSERTFILE            = 2;
  ID_BROWSE_ADDCONTROL            = 3;
  ID_BROWSE_CHANGESOURCE          = 4;

  OLEUI_FALSE                     = 0;
  OLEUI_SUCCESS                   = 1;
  OLEUI_OK                        = 1;
  OLEUI_CANCEL                    = 2;

  OLEUI_ERR_STANDARDMIN           = 100;
  OLEUI_ERR_STRUCTURENULL         = 101;
  OLEUI_ERR_STRUCTUREINVALID      = 102;
  OLEUI_ERR_CBSTRUCTINCORRECT     = 103;
  OLEUI_ERR_HWNDOWNERINVALID      = 104;
  OLEUI_ERR_LPSZCAPTIONINVALID    = 105;
  OLEUI_ERR_LPFNHOOKINVALID       = 106;
  OLEUI_ERR_HINSTANCEINVALID      = 107;
  OLEUI_ERR_LPSZTEMPLATEINVALID   = 108;
  OLEUI_ERR_HRESOURCEINVALID      = 109;

  OLEUI_ERR_FINDTEMPLATEFAILURE   = 110;
  OLEUI_ERR_LOADTEMPLATEFAILURE   = 111;
  OLEUI_ERR_DIALOGFAILURE         = 112;
  OLEUI_ERR_LOCALMEMALLOC         = 113;
  OLEUI_ERR_GLOBALMEMALLOC        = 114;
  OLEUI_ERR_LOADSTRING            = 115;
  OLEUI_ERR_OLEMEMALLOC           = 116;

  OLEUI_ERR_STANDARDMAX           = 117;

  IOF_SHOWHELP                    = $00000001;
  IOF_SELECTCREATENEW             = $00000002;
  IOF_SELECTCREATEFROMFILE        = $00000004;
  IOF_CHECKLINK                   = $00000008;
  IOF_CHECKDISPLAYASICON          = $00000010;
  IOF_CREATENEWOBJECT             = $00000020;
  IOF_CREATEFILEOBJECT            = $00000040;
  IOF_CREATELINKOBJECT            = $00000080;
  IOF_DISABLELINK                 = $00000100;
  IOF_VERIFYSERVERSEXIST          = $00000200;
  IOF_DISABLEDISPLAYASICON        = $00000400;
  IOF_HIDECHANGEICON              = $00000800;
  IOF_SHOWINSERTCONTROL           = $00001000;
  IOF_SELECTCREATECONTROL         = $00002000;

  OLEUI_IOERR_LPSZFILEINVALID         = OLEUI_ERR_STANDARDMAX + 0;
  OLEUI_IOERR_LPSZLABELINVALID        = OLEUI_ERR_STANDARDMAX + 1;
  OLEUI_IOERR_HICONINVALID            = OLEUI_ERR_STANDARDMAX + 2;
  OLEUI_IOERR_LPFORMATETCINVALID      = OLEUI_ERR_STANDARDMAX + 3;
  OLEUI_IOERR_PPVOBJINVALID           = OLEUI_ERR_STANDARDMAX + 4;
  OLEUI_IOERR_LPIOLECLIENTSITEINVALID = OLEUI_ERR_STANDARDMAX + 5;
  OLEUI_IOERR_LPISTORAGEINVALID       = OLEUI_ERR_STANDARDMAX + 6;
  OLEUI_IOERR_SCODEHASERROR           = OLEUI_ERR_STANDARDMAX + 7;
  OLEUI_IOERR_LPCLSIDEXCLUDEINVALID   = OLEUI_ERR_STANDARDMAX + 8;
  OLEUI_IOERR_CCHFILEINVALID          = OLEUI_ERR_STANDARDMAX + 9;

  OLEUIPASTE_ENABLEICON    = 2048;
  OLEUIPASTE_PASTEONLY     = 0;
  OLEUIPASTE_PASTE         = 512;
  OLEUIPASTE_LINKANYTYPE   = 1024;
  OLEUIPASTE_LINKTYPE1     = 1;
  OLEUIPASTE_LINKTYPE2     = 2;
  OLEUIPASTE_LINKTYPE3     = 4;
  OLEUIPASTE_LINKTYPE4     = 8;
  OLEUIPASTE_LINKTYPE5     = 16;
  OLEUIPASTE_LINKTYPE6     = 32;
  OLEUIPASTE_LINKTYPE7     = 64;
  OLEUIPASTE_LINKTYPE8     = 128;

  PS_MAXLINKTYPES          = 8;

  PSF_SHOWHELP                    = $00000001;
  PSF_SELECTPASTE                 = $00000002;
  PSF_SELECTPASTELINK             = $00000004;
  PSF_CHECKDISPLAYASICON          = $00000008;
  PSF_DISABLEDISPLAYASICON        = $00000010;
  PSF_HIDECHANGEICON              = $00000020;
  PSF_STAYONCLIPBOARDCHANGE       = $00000040;
  PSF_NOREFRESHDATAOBJECT         = $00000080;

  OLEUI_IOERR_SRCDATAOBJECTINVALID   = OLEUI_ERR_STANDARDMAX + 0;
  OLEUI_IOERR_ARRPASTEENTRIESINVALID = OLEUI_ERR_STANDARDMAX + 1;
  OLEUI_IOERR_ARRLINKTYPESINVALID    = OLEUI_ERR_STANDARDMAX + 2;
  OLEUI_PSERR_CLIPBOARDCHANGED       = OLEUI_ERR_STANDARDMAX + 3;
  OLEUI_PSERR_GETCLIPBOARDFAILED     = OLEUI_ERR_STANDARDMAX + 4;

  OLEUI_ELERR_LINKCNTRNULL    = OLEUI_ERR_STANDARDMAX + 0;
  OLEUI_ELERR_LINKCNTRINVALID = OLEUI_ERR_STANDARDMAX + 1;

  ELF_SHOWHELP                    = $00000001;
  ELF_DISABLEUPDATENOW            = $00000002;
  ELF_DISABLEOPENSOURCE           = $00000004;
  ELF_DISABLECHANGESOURCE         = $00000008;
  ELF_DISABLECANCELLINK           = $00000010;

  CIF_SHOWHELP                    = $00000001;
  CIF_SELECTCURRENT               = $00000002;
  CIF_SELECTDEFAULT               = $00000004;
  CIF_SELECTFROMFILE              = $00000008;
  CIF_USEICONEXE                  = $00000010;

  OLEUI_CIERR_MUSTHAVECLSID           = OLEUI_ERR_STANDARDMAX + 0;
  OLEUI_CIERR_MUSTHAVECURRENTMETAFILE = OLEUI_ERR_STANDARDMAX + 1;
  OLEUI_CIERR_SZICONEXEINVALID        = OLEUI_ERR_STANDARDMAX + 2;
  PROP_HWND_CHGICONDLG                = 'HWND_CIDLG';

  CF_SHOWHELPBUTTON               = $00000001;
  CF_SETCONVERTDEFAULT            = $00000002;
  CF_SETACTIVATEDEFAULT           = $00000004;
  CF_SELECTCONVERTTO              = $00000008;
  CF_SELECTACTIVATEAS             = $00000010;
  CF_DISABLEDISPLAYASICON         = $00000020;
  CF_DISABLEACTIVATEAS            = $00000040;
  CF_HIDECHANGEICON               = $00000080;
  CF_CONVERTONLY                  = $00000100;

  OLEUI_CTERR_CLASSIDINVALID      = OLEUI_ERR_STANDARDMAX + 1;
  OLEUI_CTERR_DVASPECTINVALID     = OLEUI_ERR_STANDARDMAX + 2;
  OLEUI_CTERR_CBFORMATINVALID     = OLEUI_ERR_STANDARDMAX + 3;
  OLEUI_CTERR_HMETAPICTINVALID    = OLEUI_ERR_STANDARDMAX + 4;
  OLEUI_CTERR_STRINGINVALID       = OLEUI_ERR_STANDARDMAX + 5;

  BZ_DISABLECANCELBUTTON          = $00000001;
  BZ_DISABLESWITCHTOBUTTON        = $00000002;
  BZ_DISABLERETRYBUTTON           = $00000004;
  BZ_NOTRESPONDINGDIALOG          = $00000008;

  OLEUI_BZERR_HTASKINVALID     = OLEUI_ERR_STANDARDMAX + 0;
  OLEUI_BZ_SWITCHTOSELECTED    = OLEUI_ERR_STANDARDMAX + 1;
  OLEUI_BZ_RETRYSELECTED       = OLEUI_ERR_STANDARDMAX + 2;
  OLEUI_BZ_CALLUNBLOCKED       = OLEUI_ERR_STANDARDMAX + 3;

  VPF_SELECTRELATIVE          = $00000001;
  VPF_DISABLERELATIVE         = $00000002;
  VPF_DISABLESCALE            = $00000004;

  OPF_OBJECTISLINK                = $00000001;
  OPF_NOFILLDEFAULT               = $00000002;
  OPF_SHOWHELP                    = $00000004;
  OPF_DISABLECONVERT              = $00000008;

  OLEUI_OPERR_SUBPROPNULL           = OLEUI_ERR_STANDARDMAX + 0;
  OLEUI_OPERR_SUBPROPINVALID        = OLEUI_ERR_STANDARDMAX + 1;
  OLEUI_OPERR_PROPSHEETNULL         = OLEUI_ERR_STANDARDMAX + 2;
  OLEUI_OPERR_PROPSHEETINVALID      = OLEUI_ERR_STANDARDMAX + 3;
  OLEUI_OPERR_SUPPROP               = OLEUI_ERR_STANDARDMAX + 4;
  OLEUI_OPERR_PROPSINVALID          = OLEUI_ERR_STANDARDMAX + 5;
  OLEUI_OPERR_PAGESINCORRECT        = OLEUI_ERR_STANDARDMAX + 6;
  OLEUI_OPERR_INVALIDPAGES          = OLEUI_ERR_STANDARDMAX + 7;
  OLEUI_OPERR_NOTSUPPORTED          = OLEUI_ERR_STANDARDMAX + 8;
  OLEUI_OPERR_DLGPROCNOTNULL        = OLEUI_ERR_STANDARDMAX + 9;
  OLEUI_OPERR_LPARAMNOTZERO         = OLEUI_ERR_STANDARDMAX + 10;
  OLEUI_GPERR_STRINGINVALID         = OLEUI_ERR_STANDARDMAX + 11;
  OLEUI_GPERR_CLASSIDINVALID        = OLEUI_ERR_STANDARDMAX + 12;
  OLEUI_GPERR_LPCLSIDEXCLUDEINVALID = OLEUI_ERR_STANDARDMAX + 13;
  OLEUI_GPERR_CBFORMATINVALID       = OLEUI_ERR_STANDARDMAX + 14;
  OLEUI_VPERR_METAPICTINVALID       = OLEUI_ERR_STANDARDMAX + 15;
  OLEUI_VPERR_DVASPECTINVALID       = OLEUI_ERR_STANDARDMAX + 16;
  OLEUI_LPERR_LINKCNTRNULL          = OLEUI_ERR_STANDARDMAX + 17;
  OLEUI_LPERR_LINKCNTRINVALID       = OLEUI_ERR_STANDARDMAX + 18;
  OLEUI_OPERR_PROPERTYSHEET         = OLEUI_ERR_STANDARDMAX + 19;
  OLEUI_QUERY_GETCLASSID            = $FF00;
  OLEUI_QUERY_LINKBROKEN            = $FF01;

type
  IStream = interface;
  IRunningObjectTable = interface;
  IEnumString = interface;
  IMoniker = interface;
  IAdviseSink = interface;
  ITypeInfo = interface;
  ITypeInfo2 = interface;
  ITypeComp = interface;
  ITypeLib = interface;
  ITypeLib2 = interface;
  IEnumOLEVERB = interface;
  IOleInPlaceActiveObject = interface;
  IOleControl = interface;
  IOleControlSite = interface;
  ISimpleFrameSite = interface;
  IPersistStreamInit = interface;
  IPersistPropertyBag = interface;
  IPropertyNotifySink = interface;
  IProvideClassInfo = interface;
  IConnectionPointContainer = interface;
  IEnumConnectionPoints = interface;
  IConnectionPoint = interface;
  IEnumConnections = interface;
  IClassFactory2 = interface;
  ISpecifyPropertyPages = interface;
  IPerPropertyBrowsing = interface;
  IPropertyPageSite = interface;
  IPropertyPage = interface;
  IPropertyPage2 = interface;
  IPropertySetStorage = interface;
  IPropertyStorage = interface;
  IEnumSTATPROPSTG = interface;
  IEnumSTATPROPSETSTG = interface;
  IEnumGUID = interface;
  IEnumCATEGORYINFO = interface;
  ICatRegister = interface;
  ICatInformation = interface;
  IOleClientSite = interface;
  IFont = interface;
  IOleUndoManager = interface;
  IBindHost = interface;
  IPictureDisp = interface;
  IFontDisp = interface;
  IOleUILinkContainer = interface;
  IDataObject = interface;
  IStorage = interface;
  IOleUILinkInfo = interface;
  IOleUIObjInfo = interface;

  //////////// Variant type declaration /////////////
  //POleVariant = PVariant;
  //OleVariant = Variant;
  ///////////////////////////////////////////////////

  HOLEMENU = HGLOBAL;

  PROPID = ULONG;
  PPropID = ^TPropID;
  TPropID = PROPID;

  BORDERWIDTHS = TRect;
  PBorderWidths = ^TBorderWidths;
  TBorderWidths = BORDERWIDTHS;

  PHResult = ^HResult;
  PSCODE = ^Integer;
  SCODE = Integer;

  PSYSINT = ^SYSINT;
  SYSINT = Integer;
  PSYSUINT = ^SYSUINT;
  SYSUINT = LongWord;

  PResultList = ^TResultList;
  TResultList = array[0..65535] of HRESULT;

  PUnknownList = ^TUnknownList;
  TUnknownList = array[0..65535] of IUnknown;

  Largeint = Int64;

  PLargeuint = ^Largeuint;
  Largeuint = Int64;

  PIID = PGUID;
  TIID = TGUID;

  PCLSID = PGUID;
  TCLSID = TGUID;

  PObjectID = ^TObjectID;
  _OBJECTID = record
    Lineage: TGUID;
    Uniquifier: Longint;
  end;
  TObjectID = _OBJECTID;
  OBJECTID = TObjectID;

  TLCID = DWORD;

  FMTID = TGUID;
  PFmtID = ^TFmtID;
  TFmtID = TGUID;

  PTextMetricOle = PTextMetricW;
  TTextMetricOle = TTextMetricW;

  OLE_COLOR = DWORD;
  TOleColor = OLE_COLOR;

  PCoServerInfo = ^TCoServerInfo;
  _COSERVERINFO = record
    dwReserved1: Longint;
    pwszName: LPWSTR;
    pAuthInfo: Pointer;
    dwReserved2: Longint;
  end;
  TCoServerInfo = _COSERVERINFO;
  COSERVERINFO = TCoServerInfo;

  PMultiQI = ^TMultiQI;
  tagMULTI_QI = record
    IID: PIID;
    Itf: IUnknown;
    hr: HRESULT;
  end;
  TMultiQI = tagMULTI_QI;
  MULTI_QI = TMultiQI;

  PMultiQIArray = ^TMultiQIArray;
  TMultiQIArray = array[0..65535] of TMultiQI;

  PSafeArrayBound = ^TSafeArrayBound;
  tagSAFEARRAYBOUND = record
    cElements: Longint;
    lLbound: Longint;
  end;
  TSafeArrayBound = tagSAFEARRAYBOUND;
  SAFEARRAYBOUND = TSafeArrayBound;

  PSafeArray = ^TSafeArray;
  tagSAFEARRAY = record
    cDims: Word;
    fFeatures: Word;
    cbElements: Longint;
    cLocks: Longint;
    pvData: Pointer;
    rgsabound: array[0..0] of TSafeArrayBound;
  end;
  TSafeArray = tagSAFEARRAY;
  SAFEARRAY = TSafeArray;

  TOleBool = WordBool;
  POleBool = ^TOleBool;
  TOleDate = Double;
  POleDate = ^TOleDate;
  TOleChar = WChar;
  POleStr = PWChar;
  PPOleStr = ^POleStr;
  PBStr = ^TBStr;
  TBStr = POleStr;

  TSNB = ^POleStr;
  TRpcOleDataRep = DWORD;

  POleStrList = ^TOleStrList;
  TOleStrList = array[0..65535] of POleStr;

  TCurrency = Comp;
  Currency = TCurrency;
  PCurrency = ^TCurrency;

  OLE_XPOS_PIXELS  = Longint;
  OLE_YPOS_PIXELS  = Longint;
  OLE_XSIZE_PIXELS = Longint;
  OLE_YSIZE_PIXELS = Longint;

  OLE_XPOS_HIMETRIC  = Longint;
  OLE_YPOS_HIMETRIC  = Longint;
  OLE_XSIZE_HIMETRIC = Longint;
  OLE_YSIZE_HIMETRIC = Longint;

  OLE_XPOS_CONTAINER  = Single;
  OLE_YPOS_CONTAINER  = Single;
  OLE_XSIZE_CONTAINER = Single;
  OLE_YSIZE_CONTAINER = Single;

  OLE_TRISTATE = SmallInt;

  OLE_OPTEXCLUSIVE = WordBool;
  OLE_CANCELBOOL = WordBool;
  OLE_ENABLEDEFAULTBOOL = WordBool;
  OLE_HANDLE = LongWord;

  FONTNAME = TBStr;
  FONTSIZE = Currency;
  FONTBOLD = WordBool;
  FONTITALIC = WordBool;
  FONTUNDERSCORE = WordBool;
  FONTSTRIKETHROUGH = WordBool;

  TDLLRegisterServer = function: HResult stdcall;
  TDLLUnregisterServer = function: HResult stdcall;
  TFNOleUIHook = function(Wnd: HWnd; Msg, WParam, LParam: Longint): Longint stdcall;

  POleUIChangeIcon = ^TOleUIChangeIcon;
  tagOLEUICHANGEICONA = record
    cbStruct: Longint;
    dwFlags: Longint;
    hWndOwner: HWnd;
    lpszCaption: PChar;
    lpfnHook: TFNOleUIHook;
    lCustData: Longint;
    hInstance: THandle;
    lpszTemplate: PChar;
    hResource: HRsrc;
    hMetaPict: HGlobal;
    clsid: TCLSID;
    szIconExe: array[0..MAX_PATH - 1] of Char;
    cchIconExe: Integer;
  end;
  TOleUIChangeIcon = tagOLEUICHANGEICONA;

  POleUIConvert = ^TOleUIConvert;
  tagOLEUICONVERTA = record
    cbStruct: Longint;
    dwFlags: Longint;
    hWndOwner: HWnd;
    lpszCaption: PChar;
    lpfnHook: TFNOleUIHook;
    lCustData: Longint;
    hInstance: THandle;
    lpszTemplate: PChar;
    hResource: HRsrc;
    clsid: TCLSID;
    clsidConvertDefault: TCLSID;
    clsidActivateDefault: TCLSID;
    clsidNew: TCLSID;
    dvAspect: Longint;
    wFormat: Word;
    fIsLinkedObject: BOOL;
    hMetaPict: HGlobal;
    lpszUserType: PChar;
    fObjectsIconChanged: BOOL;
    lpszDefLabel: PChar;
    cClsidExclude: Integer;
    lpClsidExclude: PCLSID;
  end;
  TOleUIConvert = tagOLEUICONVERTA;

  POleUIBusy = ^TOleUIBusy;
  tagOLEUIBUSYA = record
    cbStruct: Longint;
    dwFlags: Longint;
    hWndOwner: HWnd;
    lpszCaption: PChar;
    lpfnHook: TFNOleUIHook;
    lCustData: Longint;
    hInstance: THandle;
    lpszTemplate: PChar;
    hResource: HRsrc;
    task: HTask;
    lphWndDialog: ^HWnd;
  end;
  TOleUIBusy = tagOLEUIBUSYA;

  POleUIGnrlProps = ^TOleUIGnrlProps;
  tagOLEUIGNRLPROPSA = record
    cbStruct: Longint;
    dwFlags: Longint;
    dwReserved1: array[1..2] of Longint;
    lpfnHook: TFNOleUIHook;
    lCustData: Longint;
    dwReserved2: array[1..3] of Longint;
    lpOP: Pointer;
  end;
  TOleUIGnrlProps = tagOLEUIGNRLPROPSA;
  OLEUIGNRLPROPS = tagOLEUIGNRLPROPSA;

  POleUIViewProps = ^TOleUIViewProps;
  tagOLEUIVIEWPROPSA = record
    cbStruct: Longint;
    dwFlags: Longint;
    dwReserved1: array[1..2] of Longint;
    lpfnHook: TFNOleUIHook;
    lCustData: Longint;
    dwReserved2: array[1..3] of Longint;
    lpOP: Pointer;
    nScaleMin: Integer;
    nScaleMax: Integer;
  end;
  TOleUIViewProps = tagOLEUIVIEWPROPSA;
  OLEUIVIEWPROPS = tagOLEUIVIEWPROPSA;

  POleUILinkProps = ^TOleUILinkProps;
  tagOLEUILINKPROPSA = record
    cbStruct: Longint;
    dwFlags: Longint;
    dwReserved1: array[1..2] of Longint;
    lpfnHook: TFNOleUIHook;
    lCustData: Longint;
    dwReserved2: array[1..3] of Longint;
    lpOP: Pointer;
  end;
  TOleUILinkProps = tagOLEUILINKPROPSA;
  OLEUILINKPROPS = tagOLEUILINKPROPSA;

  PPointF = ^TPointF;
  tagPOINTF = record
    x: Single;
    y: Single;
  end;
  TPointF = tagPOINTF;
  POINTF = TPointF;

  PControlInfo = ^TControlInfo;
  tagCONTROLINFO = record
    cb: Longint;
    hAccel: HAccel;
    cAccel: Word;
    dwFlags: Longint;
  end;
  TControlInfo = tagCONTROLINFO;
  CONTROLINFO = TControlInfo;

  PBStrList = ^TBStrList;
  TBStrList = array[0..65535] of TBStr;

  PComp = ^Comp;

  PDecimal = ^TDecimal;
  tagDEC = record
    wReserved: Word;
    case Integer of
      0: (scale, sign: Byte; Hi32: Longint;
      case Integer of
        0: (Lo32, Mid32: Longint);
        1: (Lo64: LONGLONG));
      1: (signscale: Word);
  end;
  TDecimal = tagDEC;
  DECIMAL = TDecimal;

  PBlob = ^TBlob;
  tagBLOB = record
    cbSize: Longint;
    pBlobData: Pointer;
  end;
  TBlob = tagBLOB;
  BLOB = TBlob;

  PClipData = ^TClipData;
  tagCLIPDATA = record
    cbSize: Longint;
    ulClipFmt: Longint;
    pClipData: Pointer;
  end;
  TClipData = tagCLIPDATA;
  CLIPDATA = TClipData;

  PPropVariant = ^TPropVariant;

  tagCAUB = packed record
    cElems: ULONG;
    pElems: PByte;
  end;
  CAUB = tagCAUB;
  PCAUB = ^TCAUB;
  TCAUB = tagCAUB;

  tagCAI = packed record
    cElems: ULONG;
    pElems: PShortInt;
  end;
  CAI = tagCAI;
  PCAI = ^TCAI;
  TCAI = tagCAI;

  tagCAUI = packed record
    cElems: ULONG;
    pElems: PWord;
  end;
  CAUI = tagCAUI;
  PCAUI = ^TCAUI;
  TCAUI = tagCAUI;

  tagCAL = packed record
    cElems: ULONG;
    pElems: PLongint;
  end;
  CAL = tagCAL;
  PCAL = ^TCAL;
  TCAL = tagCAL;

  tagCAUL = packed record
    cElems: ULONG;
    pElems: PULONG;
  end;
  CAUL = tagCAUL;
  PCAUL = ^TCAUL;
  TCAUL = tagCAUL;

  tagCAFLT = packed record
    cElems: ULONG;
    pElems: PSingle;
  end;
  CAFLT = tagCAFLT;
  PCAFLT = ^TCAFLT;
  TCAFLT = tagCAFLT;

  tagCADBL = packed record
    cElems: ULONG;
    pElems: PDouble;
  end;
  CADBL = tagCADBL;
  PCADBL = ^TCADBL;
  TCADBL = tagCADBL;

  tagCACY = packed record
    cElems: ULONG;
    pElems: PCurrency;
  end;
  CACY = tagCACY;
  PCACY = ^TCACY;
  TCACY = tagCACY;

  tagCADATE = packed record
    cElems: ULONG;
    pElems: POleDate;
  end;
  CADATE = tagCADATE;
  PCADATE = ^TCADATE;
  TCADATE = tagCADATE;

  tagCABSTR = packed record
    cElems: ULONG;
    pElems: PBSTR;
  end;
  CABSTR = tagCABSTR;
  PCABSTR = ^TCABSTR;
  TCABSTR = tagCABSTR;

  tagCABOOL = packed record
    cElems: ULONG;
    pElems: POleBool;
  end;
  CABOOL = tagCABOOL;
  PCABOOL = ^TCABOOL;
  TCABOOL = tagCABOOL;

  tagCASCODE = packed record
    cElems: ULONG;
    pElems: PSCODE;
  end;
  CASCODE = tagCASCODE;
  PCASCODE = ^TCASCODE;
  TCASCODE = tagCASCODE;

  tagCAPROPVARIANT = packed record
    cElems: ULONG;
    pElems: PPropVariant;
  end;
  CAPROPVARIANT = tagCAPROPVARIANT;
  PCAPROPVARIANT = ^TCAPROPVARIANT;
  TCAPROPVARIANT = tagCAPROPVARIANT;

  tagCAH = packed record
    cElems: ULONG;
    pElems: PLargeInteger;
  end;
  CAH = tagCAH;
  PCAH = ^TCAH;
  TCAH = tagCAH;

  tagCAUH = packed record
    cElems: ULONG;
    pElems: PULargeInteger;
  end;
  CAUH = tagCAUH;
  PCAUH = ^TCAUH;
  TCAUH = tagCAUH;

  tagCALPSTR = packed record
    cElems: ULONG;
    pElems: PLPSTR;
  end;
  CALPSTR = tagCALPSTR;
  PCALPSTR = ^TCALPSTR;
  TCALPSTR = tagCALPSTR;

  tagCALPWSTR = packed record
    cElems: ULONG;
    pElems: PLPWSTR;
  end;
  CALPWSTR = tagCALPWSTR;
  PCALPWSTR = ^TCALPWSTR;
  TCALPWSTR = tagCALPWSTR;

  tagCAFILETIME = packed record
    cElems: ULONG;
    pElems: PFileTime;
  end;
  CAFILETIME = tagCAFILETIME;
  PCAFILETIME = ^TCAFILETIME;
  TCAFILETIME = tagCAFILETIME;

  tagCACLIPDATA = packed record
    cElems: ULONG;
    pElems: PClipData;
  end;
  CACLIPDATA = tagCACLIPDATA;
  PCACLIPDATA = ^TCACLIPDATA;
  TCACLIPDATA = tagCACLIPDATA;

  tagCACLSID = packed record
    cElems: ULONG;
    pElems: PCLSID;
  end;
  CACLSID = tagCACLSID;
  PCACLSID = ^TCACLSID;
  TCACLSID = tagCACLSID;

  tagPROPVARIANT = packed record
    vt: TVarType;
    wReserved1: Word;
    wReserved2: Word;
    wReserved3: Word;
    case Integer of
      0: (bVal: Byte);
      1: (iVal: SmallInt);
      2: (uiVal: Word);
      3: (boolVal: TOleBool);
      4: (bool: TOleBool);
      5: (lVal: Longint);
      6: (ulVal: Cardinal);
      7: (fltVal: Single);
      8: (scode: SCODE);
      9: (hVal: LARGE_INTEGER);
      10: (uhVal: ULARGE_INTEGER);
      11: (dblVal: Double);
      12: (cyVal: Currency);
      13: (date: TOleDate);
      14: (filetime: TFileTime);
      15: (puuid: PGUID);
      16: (blob: TBlob);
      17: (pclipdata: PClipData);
      18: (pStream: Pointer);
      19: (pStorage: Pointer);
      20: (bstrVal: TBStr);
      21: (pszVal: PAnsiChar);
      22: (pwszVal: PWideChar);
      23: (caub: TCAUB);
      24: (cai: TCAI);
      25: (caui: TCAUI);
      26: (cabool: TCABOOL);
      27: (cal: TCAL);
      28: (caul: TCAUL);
      29: (caflt: TCAFLT);
      30: (cascode: TCASCODE);
      31: (cah: TCAH);
      32: (cauh: TCAUH);
      33: (cadbl: TCADBL);
      34: (cacy: TCACY);
      35: (cadate: TCADATE);
      36: (cafiletime: TCAFILETIME);
      37: (cauuid: TCACLSID);
      38: (caclipdata: TCACLIPDATA);
      39: (cabstr: TCABSTR);
      40: (calpstr: TCALPSTR);
      41: (calpwstr: TCALPWSTR );
      42: (capropvar: TCAPROPVARIANT);
  end;
  PROPVARIANT = tagPROPVARIANT;
  TPropVariant = tagPROPVARIANT;

  tagPROPSPEC = packed record
    ulKind: ULONG;
    case Integer of
      0: (propid: TPropID);
      1: (lpwstr: POleStr);
  end;
  PROPSPEC = tagPROPSPEC;
  PPropSpec = ^TPropSpec;
  TPropSpec = tagPROPSPEC;

  tagSTATPROPSTG = packed record
    lpwstrName: POleStr;
    propid: TPropID;
    vt: TVarType;
  end;
  STATPROPSTG = tagSTATPROPSTG;
  PStatPropStg = ^TStatPropStg;
  TStatPropStg = tagSTATPROPSTG;

  tagSTATPROPSETSTG = packed record
    fmtid: TFmtID;
    clsid: TClsID;
    grfFlags: DWORD;
    mtime: TFileTime;
    ctime: TFileTime;
    atime: TFileTime;
    dwOSVersion: DWORD;
  end;
  STATPROPSETSTG = tagSTATPROPSETSTG;
  PStatPropSetStg = ^TStatPropSetStg;
  TStatPropSetStg = tagSTATPROPSETSTG;

  PCATEGORYINFO = ^TCATEGORYINFO;
  TCATEGORYINFO = record
    catid: TGUID;
    lcid: UINT;
    szDescription: array[0..127] of WideChar;
  end;

  tagQACONTAINER = record
    cbSize: LongInt;
    pClientSite: IOleClientSite;
    pAdviseSink: IAdviseSink;
    pPropertyNotifySink: IPropertyNotifySink;
    pUnkEventSink: IUnknown;
    dwAmbientFlags: LongInt;
    colorFore: OLE_COLOR;
    colorBack: OLE_COLOR;
    pFont: IFont;
    pUndoMgr: IOleUndoManager;
    dwAppearance: LongInt;
    lcid: LongInt;
    hpal: HPALETTE;
    pBindHost: IBindHost;
  end;

  PQaContainer = ^tagQACONTAINER;
  TQaContainer =  tagQACONTAINER;

  tagQACONTROL = record
    cbSize: LongInt;
    dwMiscStatus: LongInt;
    dwViewStatus: LongInt;
    dwEventCookie: LongInt;
    dwPropNotifyCookie: LongInt;
    dwPointerActivationPolicy: LongInt;
  end;

  PQaControl = ^TQaControl;
  TQaControl =  tagQACONTROL;

  POleCmd = ^TOleCmd;
  _tagOLECMD = record
    cmdID: Cardinal;
    cmdf: Longint;
  end;
  OLECMD = _tagOLECMD;
  TOleCmd = _tagOLECMD;

  POleCmdText = ^TOleCmdText;
  _tagOLECMDTEXT = record
    cmdtextf: Longint;
    cwActual: Cardinal;
    cwBuf: Cardinal;
    rgwz: array [0..0] of WideChar;
  end;
  OLECMDTEXT = _tagOLECMDTEXT;
  TOleCmdText = _tagOLECMDTEXT;

    PPageRange = ^TPageRange;
  tagPAGERANGE = record
    nFromPage: Longint;
    nToPage: Longint;
  end;
  PAGERANGE = tagPAGERANGE;
  TPageRange = tagPAGERANGE;

  PPageSet = ^TPageSet;
  tagPAGESET = record
    cbStruct: Cardinal;
    fOddPages: BOOL;
    fEvenPages: BOOL;
    cPageRange: Cardinal;
    rgPages: array [0..0] of TPageRange;
  end;
  PAGESET = tagPAGESET;
  TPageSet = tagPAGESET;

  Picture = IPictureDisp;

  PPictDesc = ^TPictDesc;
  tagPICTDESC = record
    cbSizeofstruct: Integer;
    picType: Integer;
    case Integer of
      PICTYPE_BITMAP: (hbitmap: THandle; hpal: THandle);
      PICTYPE_METAFILE: (hMeta: THandle; xExt, yExt: Integer);
      PICTYPE_ICON: (hIcon: THandle);
      PICTYPE_ENHMETAFILE: (hemf: THandle);
  end;
  TPictDesc = tagPICTDESC;
  PICTDESC = TPictDesc;

  Font = IFontDisp;

  PSOleAuthenticationService = ^TSOleAuthenticationService;
  tagSOLE_AUTHENTICATION_SERVICE = record
    dwAuthnSvc: Longint;
    dwAuthzSvc: Longint;
    pPrincipalName: POleStr;
    hr: HResult;
  end;
  TSOleAuthenticationService = tagSOLE_AUTHENTICATION_SERVICE;
  SOLE_AUTHENTICATION_SERVICE = TSOleAuthenticationService;

  PFontDesc = ^TFontDesc;
  tagFONTDESC = record
    cbSizeofstruct: Integer;
    lpstrName: POleStr;
    cySize: Currency;
    sWeight: Smallint;
    sCharset: Smallint;
    fItalic: BOOL;
    fUnderline: BOOL;
    fStrikethrough: BOOL;
  end;
  TFontDesc = tagFONTDESC;
  FONTDESC = TFontDesc;

  PConnectData = ^TConnectData;
  tagCONNECTDATA = record
    pUnk: IUnknown;
    dwCookie: Longint;
  end;
  TConnectData = tagCONNECTDATA;
  CONNECTDATA = TConnectData;

  PLicInfo = ^TLicInfo;
  tagLICINFO = record
    cbLicInfo: Longint;
    fRuntimeKeyAvail: BOOL;
    fLicVerified: BOOL;
  end;
  TLicInfo = tagLICINFO;
  LICINFO = TLicInfo;

  PGUIDList = ^TGUIDList;
  TGUIDList = array[0..65535] of TGUID;

  PCAGUID = ^TCAGUID;
  tagCAUUID = record
    cElems: Longint;
    pElems: PGUIDList;
  end;
  TCAGUID = tagCAUUID;
  CAUUID = TCAGUID;

  PCAPOleStr = ^TCAPOleStr;
  tagCALPOLESTR = record
    cElems: Longint;
    pElems: POleStrList;
  end;
  CALPOLESTR = tagCALPOLESTR;
  TCAPOleStr = tagCALPOLESTR;

  PLongintList = ^TLongintList;
  TLongintList = array[0..65535] of Longint;

  PCALongint = ^TCALongint;
  tagCADWORD = record
    cElems: Longint;
    pElems: PLongintList;
  end;
  CADWORD = tagCADWORD;
  TCALongint = tagCADWORD;

  TDispID = Longint;

  POCPFIParams = ^TOCPFIParams;
  tagOCPFIPARAMS = record
    cbStructSize: Longint;
    hWndOwner: HWnd;
    x: Integer;
    y: Integer;
    lpszCaption: POleStr;
    cObjects: Longint;
    pObjects: Pointer;
    cPages: Longint;
    pPages: Pointer;
    lcid: TLCID;
    dispidInitialProperty: TDispID;
  end;
  TOCPFIParams = tagOCPFIPARAMS;
  OCPFIPARAMS = TOCPFIParams;

  PPropPageInfo = ^TPropPageInfo;
  tagPROPPAGEINFO = record
    cb: Longint;
    pszTitle: POleStr;
    size: TSize;
    pszDocString: POleStr;
    pszHelpFile: POleStr;
    dwHelpContext: Longint;
  end;
  TPropPageInfo = tagPROPPAGEINFO;
  PROPPAGEINFO = TPropPageInfo;

  POleInPlaceFrameInfo = ^TOleInPlaceFrameInfo;
  tagOIFI = record
    cb: Integer;
    fMDIApp: BOOL;
    hwndFrame: HWND;
    haccel: HAccel;
    cAccelEntries: Integer;
  end;
  TOleInPlaceFrameInfo = tagOIFI;
  OLEINPLACEFRAMEINFO = TOleInPlaceFrameInfo;

  POleMenuGroupWidths = ^TOleMenuGroupWidths;
  tagOleMenuGroupWidths = record
    width: array[0..5] of Longint;
  end;
  TOleMenuGroupWidths = tagOleMenuGroupWidths;
  OLEMENUGROUPWIDTHS = TOleMenuGroupWidths;

  PObjectDescriptor = ^TObjectDescriptor;
  tagOBJECTDESCRIPTOR = record
    cbSize: Longint;
    clsid: TCLSID;
    dwDrawAspect: Longint;
    size: TPoint;
    point: TPoint;
    dwStatus: Longint;
    dwFullUserTypeName: Longint;
    dwSrcOfCopy: Longint;
  end;
  TObjectDescriptor = tagOBJECTDESCRIPTOR;
  OBJECTDESCRIPTOR = TObjectDescriptor;

  PLinkSrcDescriptor = PObjectDescriptor;
  TLinkSrcDescriptor = TObjectDescriptor;

  PParamData = ^TParamData;
  tagPARAMDATA = record
    szName: POleStr;
    vt: TVarType;
  end;
  TParamData = tagPARAMDATA;
  PARAMDATA = TParamData;

  tagCALLCONV = Longint;
  TCallConv = tagCALLCONV;

  PParamDataList = ^TParamDataList;
  TParamDataList = array[0..65535] of TParamData;

  PMethodData = ^TMethodData;
  tagMETHODDATA = record
    szName: POleStr;
    ppdata: PParamDataList;
    dispid: TDispID;
    iMeth: Integer;
    cc: TCallConv;
    cArgs: Integer;
    wFlags: Word;
    vtReturn: TVarType;
  end;
  TMethodData = tagMETHODDATA;
  METHODDATA = TMethodData;

  PMethodDataList = ^TMethodDataList;
  TMethodDataList = array[0..65535] of TMethodData;

  PInterfaceData = ^TInterfaceData;
  tagINTERFACEDATA = record
    pmethdata: PMethodDataList;
    cMembers: Integer;
  end;
  TInterfaceData = tagINTERFACEDATA;
  INTERFACEDATA = TInterfaceData;

  tagREGKIND = (REGKIND_DEFAULT, REGKIND_REGISTER, REGKIND_NONE);
  TRegKind = tagREGKIND;

  TSysKind = Longint;

  PTLibAttr = ^TTLibAttr;
  tagTLIBATTR = record
    guid: TGUID;
    lcid: TLCID;
    syskind: TSysKind;
    wMajorVerNum: Word;
    wMinorVerNum: Word;
    wLibFlags: Word;
  end;
  TTLibAttr = tagTLIBATTR;
  TLIBATTR = TTLibAttr;

  PTypeInfoList = ^TTypeInfoList;
  TTypeInfoList = array[0..65535] of ITypeInfo;

  PVariantArg = ^TVariantArg;
  tagVARIANT = record
    vt: TVarType;
    wReserved1: Word;
    wReserved2: Word;
    wReserved3: Word;
    case Integer of
      VT_UI1:                  (bVal: Byte);
      VT_I2:                   (iVal: Smallint);
      VT_I4:                   (lVal: Longint);
      VT_R4:                   (fltVal: Single);
      VT_R8:                   (dblVal: Double);
      VT_BOOL:                 (vbool: TOleBool);
      VT_ERROR:                (scode: HResult);
      VT_CY:                   (cyVal: Currency);
      VT_DATE:                 (date: TOleDate);
      VT_BSTR:                 (bstrVal: TBStr);
      VT_UNKNOWN:              (unkVal: Pointer);
      VT_DISPATCH:             (dispVal: Pointer);
      VT_ARRAY:                (parray: PSafeArray);
      VT_BYREF or VT_UI1:      (pbVal: ^Byte);
      VT_BYREF or VT_I2:       (piVal: ^Smallint);
      VT_BYREF or VT_I4:       (plVal: ^Longint);
      VT_BYREF or VT_R4:       (pfltVal: ^Single);
      VT_BYREF or VT_R8:       (pdblVal: ^Double);
      VT_BYREF or VT_BOOL:     (pbool: ^TOleBool);
      VT_BYREF or VT_ERROR:    (pscode: ^HResult);
      VT_BYREF or VT_CY:       (pcyVal: ^Currency);
      VT_BYREF or VT_DATE:     (pdate: ^TOleDate);
      VT_BYREF or VT_BSTR:     (pbstrVal: ^TBStr);
      VT_BYREF or VT_UNKNOWN:  (punkVal: ^IUnknown);
      VT_BYREF or VT_DISPATCH: (pdispVal: ^IDispatch);
      VT_BYREF or VT_ARRAY:    (pparray: ^PSafeArray);
      VT_BYREF or VT_VARIANT:  (pvarVal: PVariant);
      VT_BYREF:                (byRef: Pointer);
      VT_I1:                   (cVal: Char);
      VT_UI2:                  (uiVal: Word);
      VT_UI4:                  (ulVal: LongWord);
      VT_INT:                  (intVal: Integer);
      VT_UINT:                 (uintVal: LongWord);
      VT_BYREF or VT_DECIMAL:  (pdecVal: PDecimal);
      VT_BYREF or VT_I1:       (pcVal: PChar);
      VT_BYREF or VT_UI2:      (puiVal: PWord);
      VT_BYREF or VT_UI4:      (pulVal: PInteger);
      VT_BYREF or VT_INT:      (pintVal: PInteger);
      VT_BYREF or VT_UINT:     (puintVal: PLongWord);
  end;
  TVariantArg = tagVARIANT;

  PVariantArgList = ^TVariantArgList;
  TVariantArgList = array[0..65535] of TVariantArg;

  PDispIDList = ^TDispIDList;
  TDispIDList = array[0..65535] of TDispID;

  TMemberID = TDispID;

  PMemberIDList = ^TMemberIDList;
  TMemberIDList = array[0..65535] of TMemberID;

  HRefType = DWORD;

  tagTYPEKIND = DWORD;
  TTypeKind = tagTYPEKIND;

  PArrayDesc = ^TArrayDesc;

  PTypeDesc = ^TTypeDesc;
  tagTYPEDESC = record
  case Integer of
    VT_PTR:         (ptdesc: PTypeDesc; vt: TVarType);
    VT_CARRAY:      (padesc: PArrayDesc);
    VT_USERDEFINED: (hreftype: HRefType);
  end;
  TTypeDesc = tagTYPEDESC;
  TYPEDESC = TTypeDesc;

  tagARRAYDESC = record
    tdescElem: TTypeDesc;
    cDims: Word;
    rgbounds: array[0..0] of TSafeArrayBound;
  end;
  TArrayDesc = tagARRAYDESC;
  ARRAYDESC = TArrayDesc;

  PIDLDesc = ^TIDLDesc;
  tagIDLDESC = record
    dwReserved: Longint;
    wIDLFlags: Word;
  end;
  TIDLDesc = tagIDLDESC;
  IDLDESC = TIDLDesc;

  PParamDescEx = ^TParamDescEx;
  tagPARAMDESCEX = record
    cBytes: Longint;
    FourBytePad: Longint;
    varDefaultValue: TVariantArg;
  end;
  TParamDescEx = tagPARAMDESCEX;
  PARAMDESCEX = TParamDescEx;

  PParamDesc = ^TParamDesc;
  tagPARAMDESC = record
    pparamdescex: PParamDescEx;
    wParamFlags: Word;
  end;
  TParamDesc = tagPARAMDESC;
  PARAMDESC = TParamDesc;

  PElemDesc = ^TElemDesc;
  tagELEMDESC = record
    tdesc: TTypeDesc;
    case Integer of
      0: (idldesc: TIDLDesc);
      1: (paramdesc: TParamDesc);
  end;
  TElemDesc = tagELEMDESC;
  ELEMDESC = TElemDesc;

  PElemDescList = ^TElemDescList;
  TElemDescList = array[0..65535] of TElemDesc;

  PTypeAttr = ^TTypeAttr;
  tagTYPEATTR = record
    guid: TGUID;
    lcid: TLCID;
    dwReserved: Longint;
    memidConstructor: TMemberID;
    memidDestructor: TMemberID;
    lpstrSchema: POleStr;
    cbSizeInstance: Longint;
    typekind: TTypeKind;
    cFuncs: Word;
    cVars: Word;
    cImplTypes: Word;
    cbSizeVft: Word;
    cbAlignment: Word;
    wTypeFlags: Word;
    wMajorVerNum: Word;
    wMinorVerNum: Word;
    tdescAlias: TTypeDesc;
    idldescType: TIDLDesc;
  end;
  TTypeAttr = tagTYPEATTR;
  TYPEATTR = TTypeAttr;


  PDispParams = ^TDispParams;
  tagDISPPARAMS = record
    rgvarg: PVariantArgList;
    rgdispidNamedArgs: PDispIDList;
    cArgs: Longint;
    cNamedArgs: Longint;
  end;
  TDispParams = tagDISPPARAMS;
  DISPPARAMS = TDispParams;

  PExcepInfo = ^TExcepInfo;

  TFNDeferredFillIn = function(ExInfo: PExcepInfo): HResult stdcall;

  tagEXCEPINFO = record
    wCode: Word;
    wReserved: Word;
    bstrSource: TBStr;
    bstrDescription: TBStr;
    bstrHelpFile: TBStr;
    dwHelpContext: Longint;
    pvReserved: Pointer;
    pfnDeferredFillIn: TFNDeferredFillIn;
    scode: HResult;
  end;
  TExcepInfo = tagEXCEPINFO;
  EXCEPINFO = TExcepInfo;

  tagFUNCKIND = Longint;
  TFuncKind = tagFUNCKIND;

  tagINVOKEKIND = Longint;
  TInvokeKind = tagINVOKEKIND;

  PFuncDesc = ^TFuncDesc;
  tagFUNCDESC = record
    memid: TMemberID;
    lprgscode: PResultList;
    lprgelemdescParam: PElemDescList;
    funckind: TFuncKind;
    invkind: TInvokeKind;
    callconv: TCallConv;
    cParams: Smallint;
    cParamsOpt: Smallint;
    oVft: Smallint;
    cScodes: Smallint;
    elemdescFunc: TElemDesc;
    wFuncFlags: Word;
  end;
  TFuncDesc = tagFUNCDESC;
  FUNCDESC = TFuncDesc;

  TVarKind = Longint;

  PVarDesc = ^TVarDesc;
  tagVARDESC = record
    memid: TMemberID;
    lpstrSchema: POleStr;
    case Integer of
      VAR_PERINSTANCE: (
        oInst: Longint;
        elemdescVar: TElemDesc;
        wVarFlags: Word;
        varkind: TVarKind);
      VAR_CONST: (
        lpvarValue: POleVariant);
  end;
  TVarDesc = tagVARDESC;
  VARDESC = TVarDesc;

  PCustDataItem = ^TCustDataItem;
  tagCUSTDATAITEM = record
    guid: TGUID;
    varValue: TVariantArg;
   end;
  TCustDataItem = tagCUSTDATAITEM;
  CUSTDATAITEM = TCustDataItem;

  PCustDataItemList = ^TCustDataItemList;
  TCustDataItemList = array[0..65535] of TCustDataItem;

  PCustData = ^TCustData;
  tagCUSTDATA = record
    cCustData: DWORD;
    prgCustData: PCustDataItemList;
  end;
  TCustData = tagCUSTDATA;
  CUSTDATA = TCustData;

  TDescKind = Longint;

  PBindPtr = ^TBindPtr;
  tagBINDPTR = record
    case Integer of
      0: (lpfuncdesc: PFuncDesc);
      1: (lpvardesc: PVarDesc);
      2: (lptcomp: ITypeComp);
  end;
  TBindPtr = tagBINDPTR;
  BINDPTR = TBindPtr;

  PBindOpts = ^TBindOpts;
  tagBIND_OPTS = record
    cbStruct: Longint;
    grfFlags: Longint;
    grfMode: Longint;
    dwTickCountDeadline: Longint;
  end;
  TBindOpts = tagBIND_OPTS;
  BIND_OPTS = TBindOpts;

  PStatStg = ^TStatStg;
  tagSTATSTG = record
    pwcsName: POleStr;
    dwType: Longint;
    cbSize: Largeint;
    mtime: TFileTime;
    ctime: TFileTime;
    atime: TFileTime;
    grfMode: Longint;
    grfLocksSupported: Longint;
    clsid: TCLSID;
    grfStateBits: Longint;
    reserved: Longint;
  end;
  TStatStg = tagSTATSTG;
  STATSTG = TStatStg;

  PDVTargetDevice = ^TDVTargetDevice;
  tagDVTARGETDEVICE = record
    tdSize: Longint;
    tdDriverNameOffset: Word;
    tdDeviceNameOffset: Word;
    tdPortNameOffset: Word;
    tdExtDevmodeOffset: Word;
    tdData: record end;
  end;
  TDVTargetDevice = tagDVTARGETDEVICE;
  DVTARGETDEVICE = TDVTargetDevice;

  PClipFormat = ^TClipFormat;
  TClipFormat = Word;

  PFormatEtc = ^TFormatEtc;
  tagFORMATETC = record
    cfFormat: TClipFormat;
    ptd: PDVTargetDevice;
    dwAspect: Longint;
    lindex: Longint;
    tymed: Longint;
  end;
  TFormatEtc = tagFORMATETC;
  FORMATETC = TFormatEtc;

  POleUIEditLinks = ^TOleUIEditLinks;
  tagOLEUIEDITLINKSA = record
    cbStruct: Longint;
    dwFlags: Longint;
    hWndOwner: HWnd;
    lpszCaption: PChar;
    lpfnHook: TFNOleUIHook;
    lCustData: Longint;
    hInstance: THandle;
    lpszTemplate: PChar;
    hResource: HRsrc;
    OleUILinkContainer: IOleUILinkContainer;
  end;
  TOleUIEditLinks = tagOLEUIEDITLINKSA;

  POleUIInsertObject = ^TOleUIInsertObject;
  tagOLEUIINSERTOBJECTA = record
    cbStruct: Longint;
    dwFlags: Longint;
    hWndOwner: HWnd;
    lpszCaption: PChar;
    lpfnHook: TFNOleUIHook;
    lCustData: Longint;
    hInstance: THandle;
    lpszTemplate: PChar;
    hResource: HRsrc;
    clsid: TCLSID;
    lpszFile: PChar;
    cchFile: Integer;
    cClsidExclude: Integer;
    lpClsidExclude: PCLSID;
    iid: TIID;
    oleRender: Longint;
    lpFormatEtc: PFormatEtc;
    lpIOleClientSite: IOleClientSite;
    lpIStorage: IStorage;
    ppvObj: Pointer;
    sc: HResult;
    hMetaPict: HGlobal;
  end;
  TOleUIInsertObject = tagOLEUIINSERTOBJECTA;

  POleUIPasteEntry = ^TOleUIPasteEntry;
  tagOLEUIPASTEENTRYA = record
    fmtetc: TFormatEtc;
    lpstrFormatName: PChar;
    lpstrResultText: PChar;
    dwFlags: Longint;
    dwScratchSpace: Longint;
  end;
  TOleUIPasteEntry = tagOLEUIPASTEENTRYA;
  OLEUIPASTEENTRY = tagOLEUIPASTEENTRYA;

  POleUIPasteSpecial = ^TOleUIPasteSpecial;
  tagOLEUIPASTESPECIALA = record
    cbStruct: Longint;
    dwFlags: Longint;
    hWndOwner: HWnd;
    lpszCaption: PChar;
    lpfnHook: TFNOleUIHook;
    lCustData: Longint;
    hInstance: THandle;
    lpszTemplate: PChar;
    hResource: HRsrc;
    lpSrcDataObj: IDataObject;
    arrPasteEntries: POleUIPasteEntry;
    cPasteEntries: Integer;
    arrLinkTypes: PLongint;
    cLinkTypes: Integer;
    cClsidExclude: Integer;
    lpClsidExclude: PCLSID;
    nSelectedIndex: Integer;
    fLink: BOOL;
    hMetaPict: HGlobal;
    sizel: TSize;
  end;
  TOleUIPasteSpecial = tagOLEUIPASTESPECIALA;

  PStatData = ^TStatData;
  tagSTATDATA = record
    formatetc: TFormatEtc;
    advf: Longint;
    advSink: IAdviseSink;
    dwConnection: Longint;
  end;
  TStatData = tagSTATDATA;
  STATDATA = TStatData;

  PRemStgMedium = ^TRemStgMedium;
  tagRemSTGMEDIUM = record
    tymed: Longint;
    dwHandleType: Longint;
    pData: Longint;
    pUnkForRelease: Longint;
    cbData: Longint;
    data: record end;
  end;
  TRemStgMedium = tagRemSTGMEDIUM;
  RemSTGMEDIUM = TRemStgMedium;

  PStgMedium = ^TStgMedium;
  tagSTGMEDIUM = record
    tymed: Longint;
    case Integer of
      0: (hBitmap: HBitmap; unkForRelease: Pointer);
      1: (hMetaFilePict: THandle);
      2: (hEnhMetaFile: THandle);
      3: (hGlobal: HGlobal);
      4: (lpszFileName: POleStr);
      5: (stm: Pointer);
      6: (stg: Pointer);
  end;
  TStgMedium = tagSTGMEDIUM;
  STGMEDIUM = TStgMedium;

  PInterfaceInfo = ^TInterfaceInfo;
  tagINTERFACEINFO = record
    unk: IUnknown;
    iid: TIID;
    wMethod: Word;
  end;
  TInterfaceInfo = tagINTERFACEINFO;
  INTERFACEINFO = TInterfaceInfo;

  PRpcOleMessage = ^TRpcOleMessage;
  tagRPCOLEMESSAGE = record
    reserved1: Pointer;
    dataRepresentation: TRpcOleDataRep;
    Buffer: Pointer;
    cbBuffer: Longint;
    iMethod: Longint;
    reserved2: array[0..4] of Pointer;
    rpcFlags: Longint;
  end;
  TRpcOleMessage = tagRPCOLEMESSAGE;
  RPCOLEMESSAGE = TRpcOleMessage;

  POleUIObjectProps = ^TOleUIObjectProps;
  tagOLEUIOBJECTPROPSA = record
    cbStruct: Longint;
    dwFlags: Longint;
    lpPS: PPropSheetHeader;
    dwObject: Longint;
    lpObjInfo: IOleUIObjInfo;
    dwLink: Longint;
    lpLinkInfo: IOleUILinkInfo;
    lpGP: POleUIGnrlProps;
    lpVP: POleUIViewProps;
    lpLP: POleUILinkProps;
  end;
  TOleUIObjectProps = tagOLEUIOBJECTPROPSA;
  OLEUIOBJECTPROPS = tagOLEUIOBJECTPROPSA;

  TContinueFunc = function conv arg_stdcall (dwContinue: Longint): BOOL;
  TDLLGetClassObject = function conv arg_stdcall (const clsid: TCLSID; const iid: TIID; out pv): HResult;
  TDLLCanUnloadNow = function conv arg_stdcall : HResult;

  // Basic ActiveX/OLE2 interfaces

  IClassFactory = interface(IUnknown)
    ['{00000001-0000-0000-C000-000000000046}']
    function CreateInstance(const unkOuter: IUnknown; const iid: TIID; out obj): HResult; stdcall;
    function LockServer(fLock: BOOL): HResult; stdcall;
  end;

  IMarshal = interface(IUnknown)
    ['{00000003-0000-0000-C000-000000000046}']
    function GetUnmarshalClass(const iid: TIID; pv: Pointer;
      dwDestContext: Longint; pvDestContext: Pointer; mshlflags: Longint;
      out cid: TCLSID): HResult; stdcall;
    function GetMarshalSizeMax(const iid: TIID; pv: Pointer;
      dwDestContext: Longint; pvDestContext: Pointer; mshlflags: Longint;
      out size: Longint): HResult; stdcall;
    function MarshalInterface(const stm: IStream; const iid: TIID; pv: Pointer;
      dwDestContext: Longint; pvDestContext: Pointer;
      mshlflags: Longint): HResult; stdcall;
    function UnmarshalInterface(const stm: IStream; const iid: TIID;
      out pv): HResult; stdcall;
    function ReleaseMarshalData(const stm: IStream): HResult; stdcall;
    function DisconnectObject(dwReserved: Longint): HResult; stdcall;
  end;

  IMalloc = interface(IUnknown)
    ['{00000002-0000-0000-C000-000000000046}']
    function Alloc(cb: Longint): Pointer; stdcall;
    function Realloc(pv: Pointer; cb: Longint): Pointer; stdcall;
    procedure Free(pv: Pointer); stdcall;
    function GetSize(pv: Pointer): Longint; stdcall;
    function DidAlloc(pv: Pointer): Integer; stdcall;
    procedure HeapMinimize; stdcall;
  end;

  IMallocSpy = interface(IUnknown)
    ['{0000001D-0000-0000-C000-000000000046}']
    function PreAlloc(cbRequest: Longint): Longint; stdcall;
    function PostAlloc(pActual: Pointer): Pointer; stdcall;
    function PreFree(pRequest: Pointer; fSpyed: BOOL): Pointer; stdcall;
    procedure PostFree(fSpyed: BOOL); stdcall;
    function PreRealloc(pRequest: Pointer; cbRequest: Longint;
      out ppNewRequest: Pointer; fSpyed: BOOL): Longint; stdcall;
    function PostRealloc(pActual: Pointer; fSpyed: BOOL): Pointer; stdcall;
    function PreGetSize(pRequest: Pointer; fSpyed: BOOL): Pointer; stdcall;
    function PostGetSize(pActual: Pointer; fSpyed: BOOL): Longint; stdcall;
    function PreDidAlloc(pRequest: Pointer; fSpyed: BOOL): Pointer; stdcall;
    function PostDidAlloc(pRequest: Pointer; fSpyed: BOOL; fActual: Integer): Integer; stdcall;
    procedure PreHeapMinimize; stdcall;
    procedure PostHeapMinimize; stdcall;
  end;

  IStdMarshalInfo = interface(IUnknown)
    ['{00000018-0000-0000-C000-000000000046}']
    function GetClassForHandler(dwDestContext: Longint; pvDestContext: Pointer;
      out clsid: TCLSID): HResult; stdcall;
  end;

  IExternalConnection = interface(IUnknown)
    ['{00000019-0000-0000-C000-000000000046}']
    function AddConnection(extconn: Longint; reserved: Longint): Longint; stdcall;
    function ReleaseConnection(extconn: Longint; reserved: Longint;
      fLastReleaseCloses: BOOL): Longint; stdcall;
  end;

  IWeakRef = interface(IUnknown)
    ['{A35E20C2-837D-11D0-9E9F-00A02457621F}']
    function ChangeWeakCount(delta: Longint): Longint; stdcall;
    function ReleaseKeepAlive(const unkReleased: IUnknown; reserved: Longint): Longint; stdcall;
  end;

  IEnumUnknown = interface(IUnknown)
    ['{00000100-0000-0000-C000-000000000046}']
    function Next(celt: Longint; out elt; pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enm: IEnumUnknown): HResult; stdcall;
  end;

  IBindCtx = interface(IUnknown)
    ['{0000000E-0000-0000-C000-000000000046}']
    function RegisterObjectBound(const unk: IUnknown): HResult; stdcall;
    function RevokeObjectBound(const unk: IUnknown): HResult; stdcall;
    function ReleaseBoundObjects: HResult; stdcall;
    function SetBindOptions(const bindopts: TBindOpts): HResult; stdcall;
    function GetBindOptions(var bindopts: TBindOpts): HResult; stdcall;
    function GetRunningObjectTable(out rot: IRunningObjectTable): HResult; stdcall;
    function RegisterObjectParam(pszKey: POleStr; const unk: IUnknown): HResult; stdcall;
    function GetObjectParam(pszKey: POleStr; out unk: IUnknown): HResult; stdcall;
    function EnumObjectParam(out Enum: IEnumString): HResult; stdcall;
    function RevokeObjectParam(pszKey: POleStr): HResult; stdcall;
  end;

  IEnumMoniker = interface(IUnknown)
    ['{00000102-0000-0000-C000-000000000046}']
    function Next(celt: Longint; out elt;
      pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enm: IEnumMoniker): HResult; stdcall;
  end;

  IRunnableObject = interface(IUnknown)
    ['{00000126-0000-0000-C000-000000000046}']
    function GetRunningClass(out clsid: TCLSID): HResult; stdcall;
    function Run(const bc: IBindCtx): HResult; stdcall;
    function IsRunning: BOOL; stdcall;
    function LockRunning(fLock: BOOL; fLastUnlockCloses: BOOL): HResult; stdcall;
    function SetContainedObject(fContained: BOOL): HResult; stdcall;
  end;

  IRunningObjectTable = interface(IUnknown)
    ['{00000010-0000-0000-C000-000000000046}']
    function Register(grfFlags: Longint; const unkObject: IUnknown;
      const mkObjectName: IMoniker; out dwRegister: Longint): HResult; stdcall;
    function Revoke(dwRegister: Longint): HResult; stdcall;
    function IsRunning(const mkObjectName: IMoniker): HResult; stdcall;
    function GetObject(const mkObjectName: IMoniker;
      out unkObject: IUnknown): HResult; stdcall;
    function NoteChangeTime(dwRegister: Longint;
      const filetime: TFileTime): HResult; stdcall;
    function GetTimeOfLastChange(const mkObjectName: IMoniker;
      out filetime: TFileTime): HResult; stdcall;
    function EnumRunning(out enumMoniker: IEnumMoniker): HResult; stdcall;
  end;

  IPersist = interface(IUnknown)
    ['{0000010C-0000-0000-C000-000000000046}']
    function GetClassID(out classID: TCLSID): HResult; stdcall;
  end;

  IPersistStream = interface(IPersist)
    ['{00000109-0000-0000-C000-000000000046}']
    function IsDirty: HResult; stdcall;
    function Load(const stm: IStream): HResult; stdcall;
    function Save(const stm: IStream; fClearDirty: BOOL): HResult; stdcall;
    function GetSizeMax(out cbSize: Largeint): HResult; stdcall;
  end;

  PIMoniker = ^IMoniker;
  IMoniker = interface(IPersistStream)
    ['{0000000F-0000-0000-C000-000000000046}']
    function BindToObject(const bc: IBindCtx; const mkToLeft: IMoniker;
      const iidResult: TIID; out vResult): HResult; stdcall;
    function BindToStorage(const bc: IBindCtx; const mkToLeft: IMoniker;
      const iid: TIID; out vObj): HResult; stdcall;
    function Reduce(const bc: IBindCtx; dwReduceHowFar: Longint;
      mkToLeft: PIMoniker; out mkReduced: IMoniker): HResult; stdcall;
    function ComposeWith(const mkRight: IMoniker; fOnlyIfNotGeneric: BOOL;
      out mkComposite: IMoniker): HResult; stdcall;
    function Enum(fForward: BOOL; out enumMoniker: IEnumMoniker): HResult; stdcall;
    function IsEqual(const mkOtherMoniker: IMoniker): HResult; stdcall;
    function Hash(out dwHash: Longint): HResult; stdcall;
    function IsRunning(const bc: IBindCtx; const mkToLeft: IMoniker;
      const mkNewlyRunning: IMoniker): HResult; stdcall;
    function GetTimeOfLastChange(const bc: IBindCtx; const mkToLeft: IMoniker;
      out filetime: TFileTime): HResult; stdcall;
    function Inverse(out mk: IMoniker): HResult; stdcall;
    function CommonPrefixWith(const mkOther: IMoniker;
      out mkPrefix: IMoniker): HResult; stdcall;
    function RelativePathTo(const mkOther: IMoniker;
      out mkRelPath: IMoniker): HResult; stdcall;
    function GetDisplayName(const bc: IBindCtx; const mkToLeft: IMoniker;
      out pszDisplayName: POleStr): HResult; stdcall;
    function ParseDisplayName(const bc: IBindCtx; const mkToLeft: IMoniker;
      pszDisplayName: POleStr; out chEaten: Longint; out mkOut: IMoniker): HResult; stdcall;
    function IsSystemMoniker(out dwMksys: Longint): HResult; stdcall;
  end;

  IEnumString = interface(IUnknown)
    ['{00000101-0000-0000-C000-000000000046}']
    function Next(celt: Longint; out elt; pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enm: IEnumString): HResult; stdcall;
  end;

  IStream = interface(IUnknown)
    ['{0000000C-0000-0000-C000-000000000046}']
    function Read(pv: Pointer; cb: Longint; pcbRead: PLongint): HResult; stdcall;
    function Write(pv: Pointer; cb: Longint; pcbWritten: PLongint): HResult; stdcall;
    function Seek(dlibMove: Largeint; dwOrigin: Longint;
      out libNewPosition: Largeint): HResult; stdcall;
    function SetSize(libNewSize: Largeint): HResult; stdcall;
    function CopyTo(stm: IStream; cb: Largeint; out cbRead: Largeint;
      out cbWritten: Largeint): HResult; stdcall;
    function Commit(grfCommitFlags: Longint): HResult; stdcall;
    function Revert: HResult; stdcall;
    function LockRegion(libOffset: Largeint; cb: Largeint;
      dwLockType: Longint): HResult; stdcall;
    function UnlockRegion(libOffset: Largeint; cb: Largeint;
      dwLockType: Longint): HResult; stdcall;
    function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult; stdcall;
    function Clone(out stm: IStream): HResult; stdcall;
  end;

  IEnumStatStg = interface(IUnknown)
    ['{0000000D-0000-0000-C000-000000000046}']
    function Next(celt: Longint; out elt; pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enm: IEnumStatStg): HResult; stdcall;
  end;

  IStorage = interface(IUnknown)
    ['{0000000B-0000-0000-C000-000000000046}']
    function CreateStream(pwcsName: POleStr; grfMode: Longint; reserved1: Longint;
      reserved2: Longint; out stm: IStream): HResult; stdcall;
    function OpenStream(pwcsName: POleStr; reserved1: Pointer; grfMode: Longint;
      reserved2: Longint; out stm: IStream): HResult; stdcall;
    function CreateStorage(pwcsName: POleStr; grfMode: Longint;
      dwStgFmt: Longint; reserved2: Longint; out stg: IStorage): HResult; stdcall;
    function OpenStorage(pwcsName: POleStr; const stgPriority: IStorage;
      grfMode: Longint; snbExclude: TSNB; reserved: Longint; out stg: IStorage): HResult; stdcall;
    function CopyTo(ciidExclude: Longint; rgiidExclude: PIID;
      snbExclude: TSNB; const stgDest: IStorage): HResult; stdcall;
    function MoveElementTo(pwcsName: POleStr; const stgDest: IStorage;
      pwcsNewName: POleStr; grfFlags: Longint): HResult; stdcall;
    function Commit(grfCommitFlags: Longint): HResult; stdcall;
    function Revert: HResult; stdcall;
    function EnumElements(reserved1: Longint; reserved2: Pointer; reserved3: Longint;
      out enm: IEnumStatStg): HResult; stdcall;
    function DestroyElement(pwcsName: POleStr): HResult; stdcall;
    function RenameElement(pwcsOldName: POleStr; pwcsNewName: POleStr): HResult; stdcall;
    function SetElementTimes(pwcsName: POleStr; const ctime: TFileTime;
      const atime: TFileTime; const mtime: TFileTime): HResult; stdcall;
    function SetClass(const clsid: TCLSID): HResult; stdcall;
    function SetStateBits(grfStateBits: Longint; grfMask: Longint): HResult; stdcall;
    function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult; stdcall;
  end;

  IPersistFile = interface(IPersist)
    ['{0000010B-0000-0000-C000-000000000046}']
    function IsDirty: HResult; stdcall;
    function Load(pszFileName: POleStr; dwMode: Longint): HResult; stdcall;
    function Save(pszFileName: POleStr; fRemember: BOOL): HResult; stdcall;
    function SaveCompleted(pszFileName: POleStr): HResult; stdcall;
    function GetCurFile(out pszFileName: POleStr): HResult; stdcall;
  end;

  IPersistStorage = interface(IPersist)
    ['{0000010A-0000-0000-C000-000000000046}']
    function IsDirty: HResult; stdcall;
    function InitNew(const stg: IStorage): HResult; stdcall;
    function Load(const stg: IStorage): HResult; stdcall;
    function Save(const stgSave: IStorage; fSameAsLoad: BOOL): HResult; stdcall;
    function SaveCompleted(const stgNew: IStorage): HResult; stdcall;
    function HandsOffStorage: HResult; stdcall;
  end;

  ILockBytes = interface(IUnknown)
    ['{0000000A-0000-0000-C000-000000000046}']
    function ReadAt(ulOffset: Largeint; pv: Pointer; cb: Longint; pcbRead: PLongint): HResult; stdcall;
    function WriteAt(ulOffset: Largeint; pv: Pointer; cb: Longint; pcbWritten: PLongint): HResult; stdcall;
    function Flush: HResult; stdcall;
    function SetSize(cb: Largeint): HResult; stdcall;
    function LockRegion(libOffset: Largeint; cb: Largeint; dwLockType: Longint): HResult; stdcall;
    function UnlockRegion(libOffset: Largeint; cb: Largeint; dwLockType: Longint): HResult; stdcall;
    function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult; stdcall;
  end;

  IEnumFORMATETC = interface(IUnknown)
    ['{00000103-0000-0000-C000-000000000046}']
    function Next(celt: Longint; out elt; pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out Enum: IEnumFormatEtc): HResult; stdcall;
  end;

   IEnumSTATDATA = interface(IUnknown)
    ['{00000105-0000-0000-C000-000000000046}']
    function Next(celt: Longint; out elt; pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out Enum: IEnumStatData): HResult; stdcall;
  end;

  IRootStorage = interface(IUnknown)
    ['{00000012-0000-0000-C000-000000000046}']
    function SwitchToFile(pszFile: POleStr): HResult; stdcall;
  end;

  IAdviseSink = interface(IUnknown)
    ['{0000010F-0000-0000-C000-000000000046}']
    procedure OnDataChange(const formatetc: TFormatEtc; const stgmed: TStgMedium); stdcall;
    procedure OnViewChange(dwAspect: Longint; lindex: Longint); stdcall;
    procedure OnRename(const mk: IMoniker); stdcall;
    procedure OnSave; stdcall;
    procedure OnClose; stdcall;
  end;

  IAdviseSink2 = interface(IAdviseSink)
    ['{00000125-0000-0000-C000-000000000046}']
    procedure OnLinkSrcChange(const mk: IMoniker); stdcall;
  end;

  IDataObject = interface(IUnknown)
    ['{0000010E-0000-0000-C000-000000000046}']
    function GetData(const formatetcIn: TFormatEtc; out medium: TStgMedium): HResult; stdcall;
    function GetDataHere(const formatetc: TFormatEtc; out medium: TStgMedium): HResult; stdcall;
    function QueryGetData(const formatetc: TFormatEtc): HResult; stdcall;
    function GetCanonicalFormatEtc(const formatetc: TFormatEtc;
      out formatetcOut: TFormatEtc): HResult; stdcall;
    function SetData(const formatetc: TFormatEtc; var medium: TStgMedium;
      fRelease: BOOL): HResult; stdcall;
    function EnumFormatEtc(dwDirection: Longint; out enumFormatEtc: IEnumFormatEtc): HResult; stdcall;
    function DAdvise(const formatetc: TFormatEtc; advf: Longint;
      const advSink: IAdviseSink; out dwConnection: Longint): HResult; stdcall;
    function DUnadvise(dwConnection: Longint): HResult; stdcall;
    function EnumDAdvise(out enumAdvise: IEnumStatData): HResult; stdcall;
  end;

  IDataAdviseHolder = interface(IUnknown)
    ['{00000110-0000-0000-C000-000000000046}']
    function Advise(const dataObject: IDataObject; const fetc: TFormatEtc;
      advf: Longint; const advise: IAdviseSink; out pdwConnection: Longint): HResult;
      stdcall;
    function Unadvise(dwConnection: Longint): HResult; stdcall;
    function EnumAdvise(out enumAdvise: IEnumStatData): HResult; stdcall;
    function SendOnDataChange(const dataObject: IDataObject; dwReserved: Longint;
      advf: Longint): HResult; stdcall;
  end;

  IMessageFilter = interface(IUnknown)
    ['{00000016-0000-0000-C000-000000000046}']
    function HandleInComingCall(dwCallType: Longint; htaskCaller: HTask;
      dwTickCount: Longint; lpInterfaceInfo: PInterfaceInfo): Longint; stdcall;
    function RetryRejectedCall(htaskCallee: HTask; dwTickCount: Longint;
      dwRejectType: Longint): Longint; stdcall;
    function MessagePending(htaskCallee: HTask; dwTickCount: Longint;
      dwPendingType: Longint): Longint; stdcall;
  end;

  IRpcChannelBuffer = interface(IUnknown)
    ['{D5F56B60-593B-101A-B569-08002B2DBF7A}']
    function GetBuffer(var message: TRpcOleMessage; iid: TIID): HResult; stdcall;
    function SendReceive(var message: TRpcOleMessage; var status: Longint): HResult; stdcall;
    function FreeBuffer(var message: TRpcOleMessage): HResult; stdcall;
    function GetDestCtx(out dwDestContext: Longint; out pvDestContext): HResult; stdcall;
    function IsConnected: HResult; stdcall;
  end;

  IRpcProxyBuffer = interface(IUnknown)
    ['{D5F56A34-593B-101A-B569-08002B2DBF7A}']
    function Connect(const rpcChannelBuffer: IRpcChannelBuffer): HResult; stdcall;
    procedure Disconnect; stdcall;
  end;

  IRpcStubBuffer = interface(IUnknown)
    ['{D5F56AFC-593B-101A-B569-08002B2DBF7A}']
    function Connect(const unkServer: IUnknown): HResult; stdcall;
    procedure Disconnect; stdcall;
    function Invoke(var rpcmsg: TRpcOleMessage; rpcChannelBuffer:
      IRpcChannelBuffer): HResult; stdcall;
    function IsIIDSupported(const iid: TIID): Pointer; stdcall;
    function CountRefs: Longint; stdcall;
    function DebugServerQueryInterface(var pv): HResult;
      stdcall;
    procedure DebugServerRelease(pv: Pointer); stdcall;
  end;

  IPSFactoryBuffer = interface(IUnknown)
    ['{D5F569D0-593B-101A-B569-08002B2DBF7A}']
    function CreateProxy(const unkOuter: IUnknown; const iid: TIID;
      out proxy: IRpcProxyBuffer; out pv): HResult; stdcall;
    function CreateStub(const iid: TIID; const unkServer: IUnknown;
      out stub: IRpcStubBuffer): HResult; stdcall;
  end;

  IChannelHook = interface(IUnknown)
    ['{1008C4A0-7613-11CF-9AF1-0020AF6E72F4}']
    procedure ClientGetSize(const uExtent: TGUID; const iid: TIID; out DataSize: Longint); stdcall;
    procedure ClientFillBuffer(const uExtent: TGUID; const iid: TIID;
      var DataSize: Longint; var DataBuffer); stdcall;
    procedure ClientNotify(const uExtent: TGUID; const iid: TIID; DataSize: Longint;
      var DataBuffer; lDataRep: Longint; hrFault: HResult); stdcall;
    procedure ServerNotify(const uExtent: TGUID; const iid: TIID;
      DataSize: Longint; var DataBuffer; lDataRep: Longint); stdcall;
    procedure ServerGetSize(const uExtent: TGUID; const iid: TIID;
      hrFault: HResult; out DataSize: Longint); stdcall;
    procedure ServerFillBuffer(const uExtent: TGUID; const iid: TIID;
      var DataSize: Longint; var DataBuffer; hrFault: HResult); stdcall;
  end;

  IFillLockBytes = interface(IUnknown)
    ['{99CAF010-415E-11CF-8814-00AA00B569F5}']
    function FillAppend(const pv; cb: Longint; out cbWritten: Longint): HResult; stdcall;
    function FillAt(Offset: Longint; const pv; cb: Longint; out cbWritten: Longint): HResult; stdcall;
    function SetFillSize(Offset: Longint): HResult; stdcall;
    function Terminate(bCanceled: Boolean): HResult; stdcall;
  end;

  IPropertyStorage = interface(IUnknown)
    ['{00000138-0000-0000-C000-000000000046}']
    function ReadMultiple(cpspec: ULONG; rgpspec, rgpropvar: PPropSpec): HResult; stdcall;
    function WriteMultiple(cpspec: ULONG; rgpspec, rgpropvar: PPropSpec;
      propidNameFirst: TPropID): HResult; stdcall;
    function DeleteMultiple(cpspec: ULONG; rgpspec: PPropSpec): HResult; stdcall;
    function ReadPropertyNames(cpropid: ULONG; rgpropid: PPropID;
      rglpwstrName: PPOleStr): HResult; stdcall;
    function WritePropertyNames(cpropid: ULONG; rgpropid: PPropID;
      rglpwstrName: PPOleStr): HResult; stdcall;
    function DeletePropertyNames(cpropid: ULONG; rgpropid: PPropID): HResult; stdcall;
    function Commit(grfCommitFlags: DWORD): HResult; stdcall;
    function Revert: HResult; stdcall;
    function Enum(out ppenum: IEnumSTATPROPSTG): HResult; stdcall;
    function SetTimes(const pctime, patime, pmtime: TFileTime): HResult; stdcall;
    function SetClass(const clsid: TCLSID): HResult; stdcall;
    function Stat(pstatpsstg: PStatPropSetStg): HResult; stdcall;
  end;

  IPropertySetStorage = interface(IUnknown)
    ['{0000013A-0000-0000-C000-000000000046}']
    function Create(const rfmtid: TFmtID; const pclsid: TCLSID; grfFlags,
      grfMode: DWORD; out ppprstg: IPropertyStorage): HResult; stdcall;
    function Open(const rfmtid: TFmtID; grfMode: DWORD;
      out ppprstg: IPropertyStorage): HResult; stdcall;
    function Delete(const rfmtid: TFmtID): HResult; stdcall;
    function Enum(out ppenum: IEnumSTATPROPSETSTG): HResult; stdcall;
  end;

  IEnumSTATPROPSTG = interface(IUnknown)
    ['{00000139-0000-0000-C000-000000000046}']
    function Next(celt: ULONG; out rgelt; pceltFetched: PULONG): HResult; stdcall;
    function Skip(celt: ULONG): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppenum: IEnumSTATPROPSTG): HResult; stdcall;
  end;

  IEnumSTATPROPSETSTG = interface(IUnknown)
    ['{0000013B-0000-0000-C000-000000000046}']
    function Next(celt: ULONG; out rgelt; pceltFetched: PULONG): HResult; stdcall;
    function Skip(celt: ULONG): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppenum: IEnumSTATPROPSETSTG): HResult; stdcall;
  end;

  ICreateTypeInfo = interface(IUnknown)
    ['{00020405-0000-0000-C000-000000000046}']
    function SetGuid(const guid: TGUID): HResult; stdcall;
    function SetTypeFlags(uTypeFlags: Integer): HResult; stdcall;
    function SetDocString(pstrDoc: POleStr): HResult; stdcall;
    function SetHelpContext(dwHelpContext: Longint): HResult; stdcall;
    function SetVersion(wMajorVerNum: Word; wMinorVerNum: Word): HResult; stdcall;
    function AddRefTypeInfo(const tinfo: ITypeInfo; out reftype: HRefType): HResult; stdcall;
    function AddFuncDesc(index: Integer; const funcdesc: TFuncDesc): HResult; stdcall;
    function AddImplType(index: Integer; reftype: HRefType): HResult; stdcall;
    function SetImplTypeFlags(index: Integer; impltypeflags: Integer): HResult; stdcall;
    function SetAlignment(cbAlignment: Word): HResult; stdcall;
    function SetSchema(lpstrSchema: POleStr): HResult; stdcall;
    function AddVarDesc(index: Integer; const vardesc: TVarDesc): HResult; stdcall;
    function SetFuncAndParamNames(index: Integer; rgszNames: POleStrList;
      cNames: Integer): HResult; stdcall;
    function SetVarName(index: Integer; szName: POleStr): HResult; stdcall;
    function SetTypeDescAlias(const descAlias: TTypeDesc): HResult; stdcall;
    function DefineFuncAsDllEntry(index: Integer; szDllName: POleStr;
      szProcName: POleStr): HResult; stdcall;
    function SetFuncDocString(index: Integer; szDocString: POleStr): HResult; stdcall;
    function SetVarDocString(index: Integer; szDocString: POleStr): HResult; stdcall;
    function SetFuncHelpContext(index: Integer; dwHelpContext: Longint): HResult; stdcall;
    function SetVarHelpContext(index: Integer; dwHelpContext: Longint): HResult; stdcall;
    function SetMops(index: Integer; const bstrMops: TBStr): HResult; stdcall;
    function SetTypeIdldesc(const idldesc: TIDLDesc): HResult; stdcall;
    function LayOut: HResult; stdcall;
  end;

  ICreateTypeInfo2 = interface(ICreateTypeInfo)
    ['{00020412-0000-0000-C000-000000000046}']
    function DeleteFuncDesc(index: Integer): HResult; stdcall;
    function DeleteFuncDescByMemId(memid: TMemberID; invKind: TInvokeKind): HResult; stdcall;
    function DeleteVarDesc(index: Integer): HResult; stdcall;
    function DeleteVarDescByMemId(memid: TMemberID): HResult; stdcall;
    function DeleteImplType(index: Integer): HResult; stdcall;
    function SetCustData(const guid: TGUID; pVarVal: POleVariant): HResult; stdcall;
    function SetFuncCustData(index: Integer; const guid: TGUID;
      pVarVal: POleVariant): HResult; stdcall;
    function SetParamCustData(indexFunc: Integer; indexParam: Integer;
      const guid: TGUID; pVarVal: POleVariant): HResult; stdcall;
    function SetVarCustData(index: Integer; const guid: TGUID;
      pVarVal: POleVariant): HResult; stdcall;
    function SetImplTypeCustData(index: Integer; const guid: TGUID;
      pVarVal: POleVariant): HResult; stdcall;
    function SetHelpStringContext(dwHelpStringContext: Longint): HResult; stdcall;
    function SetFuncHelpStringContext(index: Integer;
      dwHelpStringContext: Longint): HResult; stdcall;
    function SetVarHelpStringContext(index: Integer;
       dwHelpStringContext: Longint): HResult; stdcall;
    function Invalidate: HResult; stdcall;
    function SetName(szName: POleStr): HResult; stdcall;
  end;

  ICreateTypeLib = interface(IUnknown)
    ['{00020406-0000-0000-C000-000000000046}']
    function CreateTypeInfo(szName: POleStr; tkind: TTypeKind;
      out ictinfo: ICreateTypeInfo): HResult; stdcall;
    function SetName(szName: POleStr): HResult; stdcall;
    function SetVersion(wMajorVerNum: Word; wMinorVerNum: Word): HResult; stdcall;
    function SetGuid(const guid: TGUID): HResult; stdcall;
    function SetDocString(szDoc: POleStr): HResult; stdcall;
    function SetHelpFileName(szHelpFileName: POleStr): HResult; stdcall;
    function SetHelpContext(dwHelpContext: Longint): HResult; stdcall;
    function SetLcid(lcid: TLCID): HResult; stdcall;
    function SetLibFlags(uLibFlags: Integer): HResult; stdcall;
    function SaveAllChanges: HResult; stdcall;
  end;

  ICreateTypeLib2 = interface(ICreateTypeLib)
    ['{0002040F-0000-0000-C000-000000000046}']
    function DeleteTypeInfo(szName: PWideChar): HResult; stdcall;
    function SetCustData(const guid: TGUID; pVarVal: POleVariant): HResult; stdcall;
    function SetHelpStringContext(dwHelpStringContext: Longint): HResult; stdcall;
    function SetHelpStringDll(szFileName: PWideChar): HResult; stdcall;
  end;

  IEnumVariant = interface(IUnknown)
    ['{00020404-0000-0000-C000-000000000046}']
    function Next(celt: Longint; out elt;  pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out Enum: IEnumVariant): HResult; stdcall;
  end;

  ITypeComp = interface(IUnknown)
    ['{00020403-0000-0000-C000-000000000046}']
    function Bind(szName: POleStr; lHashVal: Longint; wflags: Word;
      out tinfo: ITypeInfo; out desckind: TDescKind; out bindptr: TBindPtr): HResult; stdcall;
    function BindType(szName: POleStr; lHashVal: Longint;
      out tinfo: ITypeInfo; out tcomp: ITypeComp): HResult; stdcall;
  end;

  ITypeInfo = interface(IUnknown)
    ['{00020401-0000-0000-C000-000000000046}']
    function GetTypeAttr(out ptypeattr: PTypeAttr): HResult; stdcall;
    function GetTypeComp(out tcomp: ITypeComp): HResult; stdcall;
    function GetFuncDesc(index: Integer; out pfuncdesc: PFuncDesc): HResult; stdcall;
    function GetVarDesc(index: Integer; out pvardesc: PVarDesc): HResult; stdcall;
    function GetNames(memid: TMemberID; rgbstrNames: PBStrList;
      cMaxNames: Integer; out cNames: Integer): HResult; stdcall;
    function GetRefTypeOfImplType(index: Integer; out reftype: HRefType): HResult; stdcall;
    function GetImplTypeFlags(index: Integer; out impltypeflags: Integer): HResult; stdcall;
    function GetIDsOfNames(rgpszNames: POleStrList; cNames: Integer;
      rgmemid: PMemberIDList): HResult; stdcall;
    function Invoke(pvInstance: Pointer; memid: TMemberID; flags: Word;
      var dispParams: TDispParams; varResult: PVariant; excepInfo: PExcepInfo; argErr: PInteger): HResult; stdcall;
    function GetDocumentation(memid: TMemberID; pbstrName: PBStr; pbstrDocString: PBStr;
      pdwHelpContext: PLongint; pbstrHelpFile: PBStr): HResult; stdcall;
    function GetDllEntry(memid: TMemberID; invkind: TInvokeKind;
      bstrDllName, bstrName: PBStr; wOrdinal: PWord): HResult; stdcall;
    function GetRefTypeInfo(reftype: HRefType; out tinfo: ITypeInfo): HResult; stdcall;
    function AddressOfMember(memid: TMemberID; invkind: TInvokeKind; out ppv: Pointer): HResult; stdcall;
    function CreateInstance(const unkOuter: IUnknown; const iid: TIID; out vObj): HResult; stdcall;
    function GetMops(memid: TMemberID; out bstrMops: TBStr): HResult; stdcall;
    function GetContainingTypeLib(out tlib: ITypeLib; out pindex: Integer): HResult; stdcall;
    procedure ReleaseTypeAttr(ptypeattr: PTypeAttr); stdcall;
    procedure ReleaseFuncDesc(pfuncdesc: PFuncDesc); stdcall;
    procedure ReleaseVarDesc(pvardesc: PVarDesc); stdcall;
  end;

  ITypeLib = interface(IUnknown)
    ['{00020402-0000-0000-C000-000000000046}']
    function GetTypeInfoCount: Integer; stdcall;
    function GetTypeInfo(index: Integer; out tinfo: ITypeInfo): HResult; stdcall;
    function GetTypeInfoType(index: Integer; out tkind: TTypeKind): HResult; stdcall;
    function GetTypeInfoOfGuid(const guid: TGUID; out tinfo: ITypeInfo): HResult; stdcall;
    function GetLibAttr(out ptlibattr: PTLibAttr): HResult; stdcall;
    function GetTypeComp(out tcomp: ITypeComp): HResult; stdcall;
    function GetDocumentation(index: Integer; pbstrName: PBStr;
      pbstrDocString: PBStr; pdwHelpContext: PLongint; pbstrHelpFile: PBStr): HResult; stdcall;
    function IsName(szNameBuf: POleStr; lHashVal: Longint; out fName: BOOL): HResult; stdcall;
    function FindName(szNameBuf: POleStr; lHashVal: Longint; rgptinfo: PTypeInfoList;
      rgmemid: PMemberIDList; out pcFound: Word): HResult; stdcall;
    procedure ReleaseTLibAttr(ptlibattr: PTLibAttr); stdcall;
  end;

  ITypeLib2 = interface(ITypeLib)
    ['{00020411-0000-0000-C000-000000000046}']
    function GetCustData(guid: TGUID;
      out pVarVal: OleVariant): HResult; stdcall;
    function GetLibStatistics(pcUniqueNames: PLongInt;
      out pcchUniqueNames: LongInt): HResult; stdcall;
    function GetDocumentation2(index: Integer; lcid: TLCID;
      pbstrHelpString: PBStr; pdwHelpStringContext: PDWORD;
      pbstrHelpStringDll: PBStr): HResult; stdcall;
    function GetAllCustData(out pCustData: TCustData): HResult; stdcall;
  end;

  ITypeInfo2 = interface(ITypeInfo)
    ['{00020412-0000-0000-C000-000000000046}']
    function GetTypeKind(out pTypeKind: TTypeKind): HResult; stdcall;
    function GetTypeFlags(out pTypeFlags: LongInt): HResult; stdcall;
    function GetFuncIndexOfMemId(memid: TMemberID; invKind: TInvokeKind; out pFuncIndex: UINT): HResult; stdcall;
    function GetVarIndexOfMemId(memid: TMemberID; out pVarIndex: UINT): HResult; stdcall;
    function GetCustData(guid: TGUID; out pVarVal: OleVariant): HResult; stdcall;
    function GetFuncCustData(index: UINT; guid: TGUID; out pVarVal: OleVariant): HResult; stdcall;
    function GetParamCustData(indexFunc, indexParam: UINT; guid: TGUID; out pVarVal: OleVariant): HResult; stdcall;
    function GetVarCustData(index: UINT; guid: TGUID; out pVarVal: OleVariant): HResult; stdcall;
    function GetImplTypeCustData(index: UINT; guid: TGUID; out pVarVal: OleVariant): HResult; stdcall;
    function GetDocumentation2(memid: TMemberID; lcid: TLCID; pbstrHelpString: PBStr;
      pdwHelpStringContext: PDWORD; pbstrHelpStringDll: PBStr): HResult; stdcall;
    function GetAllCustData(out pCustData: TCustData): HResult; stdcall;
    function GetAllFuncCustData(index: UINT; out pCustData: TCustData): HResult; stdcall;
    function GetAllParamCustData(indexFunc, indexParam: UINT; out pCustData: TCustData): HResult; stdcall;
    function GetAllVarCustData(index: UINT; out pCustData: TCustData): HResult; stdcall;
    function GetAllImplTypeCustData(index: UINT; out pCustData: TCustData): HResult; stdcall;
  end;

  IErrorInfo = interface(IUnknown)
    ['{1CF2B120-547D-101B-8E65-08002B2BD119}']
    function GetGUID(out guid: TGUID): HResult; stdcall;
    function GetSource(out bstrSource: TBStr): HResult; stdcall;
    function GetDescription(out bstrDescription: TBStr): HResult; stdcall;
    function GetHelpFile(out bstrHelpFile: TBStr): HResult; stdcall;
    function GetHelpContext(out dwHelpContext: Longint): HResult; stdcall;
  end;

  ICreateErrorInfo = interface(IUnknown)
    ['{22F03340-547D-101B-8E65-08002B2BD119}']
    function SetGUID(const guid: TGUID): HResult; stdcall;
    function SetSource(szSource: POleStr): HResult; stdcall;
    function SetDescription(szDescription: POleStr): HResult; stdcall;
    function SetHelpFile(szHelpFile: POleStr): HResult; stdcall;
    function SetHelpContext(dwHelpContext: Longint): HResult; stdcall;
  end;

  ISupportErrorInfo = interface(IUnknown)
    ['{DF0B3D60-548F-101B-8E65-08002B2BD119}']
    function InterfaceSupportsErrorInfo(const iid: TIID): HResult; stdcall;
  end;

  IDispatch = interface(IUnknown)
    ['{00020400-0000-0000-C000-000000000046}']
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
  end;

  IOleAdviseHolder = interface(IUnknown)
    ['{00000111-0000-0000-C000-000000000046}']
    function Advise(const advise: IAdviseSink; out dwConnection: Longint): HResult; stdcall;
    function Unadvise(dwConnection: Longint): HResult; stdcall;
    function EnumAdvise(out enumAdvise: IEnumStatData): HResult; stdcall;
    function SendOnRename(const mk: IMoniker): HResult; stdcall;
    function SendOnSave: HResult; stdcall;
    function SendOnClose: HResult; stdcall;
  end;

  IOleCache = interface(IUnknown)
    ['{0000011E-0000-0000-C000-000000000046}']
    function Cache(const formatetc: TFormatEtc; advf: Longint;
      out dwConnection: Longint): HResult; stdcall;
    function Uncache(dwConnection: Longint): HResult; stdcall;
    function EnumCache(out enumStatData: IEnumStatData): HResult; stdcall;
    function InitCache(const dataObject: IDataObject): HResult; stdcall;
    function SetData(const formatetc: TFormatEtc; const medium: TStgMedium;
      fRelease: BOOL): HResult; stdcall;
  end;

  IOleCache2 = interface(IOleCache)
    ['{00000128-0000-0000-C000-000000000046}']
    function UpdateCache(const dataObject: IDataObject; grfUpdf: Longint;
      pReserved: Pointer): HResult; stdcall;
    function DiscardCache(dwDiscardOptions: Longint): HResult; stdcall;
  end;

  IOleCacheControl = interface(IUnknown)
    ['{00000129-0000-0000-C000-000000000046}']
    function OnRun(const dataObject: IDataObject): HResult; stdcall;
    function OnStop: HResult; stdcall;
  end;

  IParseDisplayName = interface(IUnknown)
    ['{0000011A-0000-0000-C000-000000000046}']
    function ParseDisplayName(const bc: IBindCtx; pszDisplayName: POleStr;
      out chEaten: Longint; out mkOut: IMoniker): HResult; stdcall;
  end;

  IOleContainer = interface(IParseDisplayName)
    ['{0000011B-0000-0000-C000-000000000046}']
    function EnumObjects(grfFlags: Longint; out Enum: IEnumUnknown): HResult; stdcall;
    function LockContainer(fLock: BOOL): HResult; stdcall;
  end;

  IOleClientSite = interface(IUnknown)
    ['{00000118-0000-0000-C000-000000000046}']
    function SaveObject: HResult; stdcall;
    function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint; out mk: IMoniker): HResult; stdcall;
    function GetContainer(out container: IOleContainer): HResult; stdcall;
    function ShowObject: HResult; stdcall;
    function OnShowWindow(fShow: BOOL): HResult; stdcall;
    function RequestNewObjectLayout: HResult; stdcall;
  end;

  IOleObject = interface(IUnknown)
    ['{00000112-0000-0000-C000-000000000046}']
    function SetClientSite(const clientSite: IOleClientSite): HResult; stdcall;
    function GetClientSite(out clientSite: IOleClientSite): HResult; stdcall;
    function SetHostNames(szContainerApp: POleStr;
      szContainerObj: POleStr): HResult; stdcall;
    function Close(dwSaveOption: Longint): HResult; stdcall;
    function SetMoniker(dwWhichMoniker: Longint; const mk: IMoniker): HResult; stdcall;
    function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint; out mk: IMoniker): HResult; stdcall;
    function InitFromData(const dataObject: IDataObject; fCreation: BOOL; dwReserved: Longint): HResult; stdcall;
    function GetClipboardData(dwReserved: Longint; out dataObject: IDataObject): HResult; stdcall;
    function DoVerb(iVerb: Longint; msg: PMsg; const activeSite: IOleClientSite;
      lindex: Longint; hwndParent: HWND; const posRect: TRect): HResult; stdcall;
    function EnumVerbs(out enumOleVerb: IEnumOleVerb): HResult; stdcall;
    function Update: HResult; stdcall;
    function IsUpToDate: HResult; stdcall;
    function GetUserClassID(out clsid: TCLSID): HResult; stdcall;
    function GetUserType(dwFormOfType: Longint; out pszUserType: POleStr): HResult; stdcall;
    function SetExtent(dwDrawAspect: Longint; const size: TPoint): HResult; stdcall;
    function GetExtent(dwDrawAspect: Longint; out size: TPoint): HResult; stdcall;
    function Advise(const advSink: IAdviseSink; out dwConnection: Longint): HResult; stdcall;
    function Unadvise(dwConnection: Longint): HResult; stdcall;
    function EnumAdvise(out enumAdvise: IEnumStatData): HResult; stdcall;
    function GetMiscStatus(dwAspect: Longint; out dwStatus: Longint): HResult; stdcall;
    function SetColorScheme(const logpal: TLogPalette): HResult; stdcall;
  end;

  IOleWindow = interface(IUnknown)
    ['{00000114-0000-0000-C000-000000000046}']
    function GetWindow(out wnd: HWnd): HResult; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HResult; stdcall;
  end;

  IOleLink = interface(IUnknown)
    ['{0000011D-0000-0000-C000-000000000046}']
    function SetUpdateOptions(dwUpdateOpt: Longint): HResult; stdcall;
    function GetUpdateOptions(out dwUpdateOpt: Longint): HResult; stdcall;
    function SetSourceMoniker(const mk: IMoniker; const clsid: TCLSID): HResult; stdcall;
    function GetSourceMoniker(out mk: IMoniker): HResult; stdcall;
    function SetSourceDisplayName(pszDisplayName: POleStr): HResult; stdcall;
    function GetSourceDisplayName(out pszDisplayName: POleStr): HResult; stdcall;
    function BindToSource(bindflags: Longint; const bc: IBindCtx): HResult; stdcall;
    function BindIfRunning: HResult; stdcall;
    function GetBoundSource(out unk: IUnknown): HResult; stdcall;
    function UnbindSource: HResult; stdcall;
    function Update(const bc: IBindCtx): HResult; stdcall;
  end;

  IOleItemContainer = interface(IOleContainer)
    ['{0000011C-0000-0000-C000-000000000046}']
    function GetObject(pszItem: POleStr; dwSpeedNeeded: Longint; const bc: IBindCtx; const iid: TIID; out vObject): HResult; stdcall;
    function GetObjectStorage(pszItem: POleStr; const bc: IBindCtx; const iid: TIID; out vStorage): HResult; stdcall;
    function IsRunning(pszItem: POleStr): HResult; stdcall;
  end;

  IOleInPlaceUIWindow = interface(IOleWindow)
    ['{00000115-0000-0000-C000-000000000046}']
    function GetBorder(out rectBorder: TRect): HResult; stdcall;
    function RequestBorderSpace(const borderwidths: TRect): HResult; stdcall;
    function SetBorderSpace(pborderwidths: PRect): HResult; stdcall;
    function SetActiveObject(const activeObject: IOleInPlaceActiveObject;
      pszObjName: POleStr): HResult; stdcall;
  end;

  IOleInPlaceActiveObject = interface(IOleWindow)
    ['{00000117-0000-0000-C000-000000000046}']
    function TranslateAccelerator(var msg: TMsg): HResult; stdcall;
    function OnFrameWindowActivate(fActivate: BOOL): HResult; stdcall;
    function OnDocWindowActivate(fActivate: BOOL): HResult; stdcall;
    function ResizeBorder(const rcBorder: TRect; const uiWindow: IOleInPlaceUIWindow;
      fFrameWindow: BOOL): HResult; stdcall;
    function EnableModeless(fEnable: BOOL): HResult; stdcall;
  end;

  IOleInPlaceFrame = interface(IOleInPlaceUIWindow)
    ['{00000116-0000-0000-C000-000000000046}']
    function InsertMenus(hmenuShared: HMenu; var menuWidths: TOleMenuGroupWidths): HResult; stdcall;
    function SetMenu(hmenuShared: HMenu; holemenu: HMenu;
      hwndActiveObject: HWnd): HResult; stdcall;
    function RemoveMenus(hmenuShared: HMenu): HResult; stdcall;
    function SetStatusText(pszStatusText: POleStr): HResult; stdcall;
    function EnableModeless(fEnable: BOOL): HResult; stdcall;
    function TranslateAccelerator(var msg: TMsg; wID: Word): HResult; stdcall;
  end;

  IOleInPlaceObject = interface(IOleWindow)
    ['{00000113-0000-0000-C000-000000000046}']
    function InPlaceDeactivate: HResult; stdcall;
    function UIDeactivate: HResult; stdcall;
    function SetObjectRects(const rcPosRect: TRect; const rcClipRect: TRect): HResult; stdcall;
    function ReactivateAndUndo: HResult; stdcall;
  end;

  IOleInPlaceSite = interface(IOleWindow)
    ['{00000119-0000-0000-C000-000000000046}']
    function CanInPlaceActivate: HResult; stdcall;
    function OnInPlaceActivate: HResult; stdcall;
    function OnUIActivate: HResult; stdcall;
    function GetWindowContext(out frame: IOleInPlaceFrame; out doc: IOleInPlaceUIWindow; out rcPosRect: TRect;
      out rcClipRect: TRect; out frameInfo: TOleInPlaceFrameInfo): HResult; stdcall;
    function Scroll(scrollExtent: TPoint): HResult; stdcall;
    function OnUIDeactivate(fUndoable: BOOL): HResult; stdcall;
    function OnInPlaceDeactivate: HResult; stdcall;
    function DiscardUndoState: HResult; stdcall;
    function DeactivateAndUndo: HResult; stdcall;
    function OnPosRectChange(const rcPosRect: TRect): HResult; stdcall;
  end;

  IViewObject = interface(IUnknown)
    ['{0000010D-0000-0000-C000-000000000046}']
    function Draw(dwDrawAspect: Longint; lindex: Longint; pvAspect: Pointer;
      ptd: PDVTargetDevice; hicTargetDev: HDC; hdcDraw: HDC; prcBounds: PRect; prcWBounds: PRect; fnContinue: TContinueFunc;
      dwContinue: Longint): HResult; stdcall;
    function GetColorSet(dwDrawAspect: Longint; lindex: Longint;
      pvAspect: Pointer; ptd: PDVTargetDevice; hicTargetDev: HDC;
      out colorSet: PLogPalette): HResult; stdcall;
    function Freeze(dwDrawAspect: Longint; lindex: Longint; pvAspect: Pointer;
      out dwFreeze: Longint): HResult; stdcall;
    function Unfreeze(dwFreeze: Longint): HResult; stdcall;
    function SetAdvise(aspects: Longint; advf: Longint;
      const advSink: IAdviseSink): HResult; stdcall;
    function GetAdvise(pAspects: PLongint; pAdvf: PLongint;
      out advSink: IAdviseSink): HResult; stdcall;
  end;

  IViewObject2 = interface(IViewObject)
    ['{00000127-0000-0000-C000-000000000046}']
    function GetExtent(dwDrawAspect: Longint; lindex: Longint; ptd: PDVTargetDevice; out size: TPoint): HResult; stdcall;
  end;

  IDropSource = interface(IUnknown)
    ['{00000121-0000-0000-C000-000000000046}']
    function QueryContinueDrag(fEscapePressed: BOOL; grfKeyState: Longint): HResult; stdcall;
    function GiveFeedback(dwEffect: Longint): HResult; stdcall;
  end;

  IDropTarget = interface(IUnknown)
    ['{00000122-0000-0000-C000-000000000046}']
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
  end;

  POleVerb = ^TOleVerb;
  tagOLEVERB = record
    lVerb: Longint;
    lpszVerbName: POleStr;
    fuFlags: Longint;
    grfAttribs: Longint;
  end;
  TOleVerb = tagOLEVERB;
  OLEVERB = TOleVerb;

  IEnumOLEVERB = interface(IUnknown)
    ['{00000104-0000-0000-C000-000000000046}']
    function Next(celt: Longint; out elt; pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enm: IEnumOleVerb): HResult; stdcall;
  end;

  IOleControl = interface
    ['{B196B288-BAB4-101A-B69C-00AA00341D07}']
    function GetControlInfo(var ci: TControlInfo): HResult; stdcall;
    function OnMnemonic(msg: PMsg): HResult; stdcall;
    function OnAmbientPropertyChange(dispid: TDispID): HResult; stdcall;
    function FreezeEvents(bFreeze: BOOL): HResult; stdcall;
  end;

  IOleControlSite = interface
    ['{B196B289-BAB4-101A-B69C-00AA00341D07}']
    function OnControlInfoChanged: HResult; stdcall;
    function LockInPlaceActive(fLock: BOOL): HResult; stdcall;
    function GetExtendedControl(out disp: IDispatch): HResult; stdcall;
    function TransformCoords(var ptlHimetric: TPoint; var ptfContainer: TPointF; flags: Longint): HResult; stdcall;
    function TranslateAccelerator(msg: PMsg; grfModifiers: Longint): HResult; stdcall;
    function OnFocus(fGotFocus: BOOL): HResult; stdcall;
    function ShowPropertyFrame: HResult; stdcall;
  end;

  ISimpleFrameSite = interface
    ['{742B0E01-14E6-101B-914E-00AA00300CAB}']
    function PreMessageFilter(wnd: HWnd; msg, wp, lp: Integer;
      out res: Integer; out Cookie: Longint): HResult; stdcall;
    function PostMessageFilter(wnd: HWnd; msg, wp, lp: Integer;
      out res: Integer; Cookie: Longint): HResult; stdcall;
  end;

  IObjectWithSite = interface
    ['{FC4801A3-2BA9-11CF-A229-00AA003D7352}']
    function SetSite(const pUnkSite: IUnknown ):HResult; stdcall;
    function GetSite(const riid: TIID; out site: IUnknown):HResult; stdcall;
  end;

  IErrorLog = interface
    ['{3127CA40-446E-11CE-8135-00AA004BB851}']
    function AddError(pszPropName: POleStr; pExcepInfo: PExcepInfo): HResult; stdcall;
  end;

  IPropertyBag = interface
    ['{55272A00-42CB-11CE-8135-00AA004BB851}']
    function Read(pszPropName: POleStr; var pvar: OleVariant; const pErrorLog: IErrorLog): HResult; stdcall;
    function Write(pszPropName: POleStr; const pvar: OleVariant): HResult; stdcall;
  end;

  IPersistPropertyBag = interface(IPersist)
    ['{37D84F60-42CB-11CE-8135-00AA004BB851}']
    function InitNew: HResult; stdcall;
    function Load(const pPropBag: IPropertyBag; const pErrorLog: IErrorLog): HResult; stdcall;
    function Save(const pPropBag: IPropertyBag; fClearDirty: BOOL; fSaveAllProperties: BOOL): HResult; stdcall;
  end;

  IPersistStreamInit = interface(IPersistStream)
    ['{7FD52380-4E07-101B-AE2D-08002B2EC713}']
    function InitNew: HResult; stdcall;
  end;

  IPropertyNotifySink = interface
    ['{9BFBBC02-EFF1-101A-84ED-00AA00341D07}']
    function OnChanged(dispid: TDispID): HResult; stdcall;
    function OnRequestEdit(dispid: TDispID): HResult; stdcall;
  end;

  IProvideClassInfo = interface
    ['{B196B283-BAB4-101A-B69C-00AA00341D07}']
    function GetClassInfo(out ti: ITypeInfo): HResult; stdcall;
  end;

  IConnectionPointContainer = interface
    ['{B196B284-BAB4-101A-B69C-00AA00341D07}']
    function EnumConnectionPoints(out Enum: IEnumConnectionPoints): HResult; stdcall;
    function FindConnectionPoint(const iid: TIID; out cp: IConnectionPoint): HResult; stdcall;
  end;

  IEnumConnectionPoints = interface
    ['{B196B285-BAB4-101A-B69C-00AA00341D07}']
    function Next(celt: Longint; out elt; pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out Enum: IEnumConnectionPoints): HResult; stdcall;
  end;

  IConnectionPoint = interface
    ['{B196B286-BAB4-101A-B69C-00AA00341D07}']
    function GetConnectionInterface(out iid: TIID): HResult; stdcall;
    function GetConnectionPointContainer(out cpc: IConnectionPointContainer): HResult; stdcall;
    function Advise(const unkSink: IUnknown; out dwCookie: Longint): HResult; stdcall;
    function Unadvise(dwCookie: Longint): HResult; stdcall;
    function EnumConnections(out Enum: IEnumConnections): HResult; stdcall;
  end;

  IEnumConnections = interface
    ['{B196B287-BAB4-101A-B69C-00AA00341D07}']
    function Next(celt: Longint; out elt; pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out Enum: IEnumConnections): HResult; stdcall;
  end;

  IClassFactory2 = interface(IClassFactory)
    ['{B196B28F-BAB4-101A-B69C-00AA00341D07}']
    function GetLicInfo(var licInfo: TLicInfo): HResult; stdcall;
    function RequestLicKey(dwResrved: Longint; out bstrKey: TBStr): HResult; stdcall;
    function CreateInstanceLic(const unkOuter: IUnknown; const unkReserved: IUnknown;
      const iid: TIID; const bstrKey: TBStr; out vObject): HResult; stdcall;
  end;

  ISpecifyPropertyPages = interface
    ['{B196B28B-BAB4-101A-B69C-00AA00341D07}']
    function GetPages(out pages: TCAGUID): HResult; stdcall;
  end;

  IPerPropertyBrowsing = interface
    ['{376BD3AA-3845-101B-84ED-08002B2EC713}']
    function GetDisplayString(dispid: TDispID; out bstr: TBStr): HResult; stdcall;
    function MapPropertyToPage(dispid: TDispID; out clsid: TCLSID): HResult; stdcall;
    function GetPredefinedStrings(dispid: TDispID; out caStringsOut: TCAPOleStr; out caCookiesOut: TCALongint): HResult; stdcall;
    function GetPredefinedValue(dispid: TDispID; dwCookie: Longint; out varOut: OleVariant): HResult; stdcall;
  end;

  IPropertyPageSite = interface
    ['{B196B28C-BAB4-101A-B69C-00AA00341D07}']
    function OnStatusChange(flags: Longint): HResult; stdcall;
    function GetLocaleID(out localeID: TLCID): HResult; stdcall;
    function GetPageContainer(out unk: IUnknown): HResult; stdcall;
    function TranslateAccelerator(msg: PMsg): HResult; stdcall;
  end;

  IPropertyPage = interface
    ['{B196B28D-BAB4-101A-B69C-00AA00341D07}']
    function SetPageSite(const pageSite: IPropertyPageSite): HResult; stdcall;
    function Activate(hwndParent: HWnd; const rc: TRect; bModal: BOOL): HResult; stdcall;
    function Deactivate: HResult; stdcall;
    function GetPageInfo(out pageInfo: TPropPageInfo): HResult; stdcall;
    function SetObjects(cObjects: Longint; pUnkList: PUnknownList): HResult; stdcall;
    function Show(nCmdShow: Integer): HResult; stdcall;
    function Move(const rect: TRect): HResult; stdcall;
    function IsPageDirty: HResult; stdcall;
    function Apply: HResult; stdcall;
    function Help(pszHelpDir: POleStr): HResult; stdcall;
    function TranslateAccelerator(msg: PMsg): HResult; stdcall;
  end;

  IPropertyPage2 = interface(IPropertyPage)
    ['{01E44665-24AC-101B-84ED-08002B2EC713}']
    function EditProperty(dispid: TDispID): HResult; stdcall;
  end;

  IFont = interface
    ['{BEF6E002-A874-101A-8BBA-00AA00300CAB}']
    function get_Name(out name: TBStr): HResult; stdcall;
    function put_Name(name: TBStr): HResult; stdcall;
    function get_Size(out size: Currency): HResult; stdcall;
    function put_Size(size: Currency): HResult; stdcall;
    function get_Bold(out bold: BOOL): HResult; stdcall;
    function put_Bold(bold: BOOL): HResult; stdcall;
    function get_Italic(out italic: BOOL): HResult; stdcall;
    function put_Italic(italic: BOOL): HResult; stdcall;
    function get_Underline(out underline: BOOL): HResult; stdcall;
    function put_Underline(underline: BOOL): HResult; stdcall;
    function get_Strikethrough(out strikethrough: BOOL): HResult; stdcall;
    function put_Strikethrough(strikethrough: BOOL): HResult; stdcall;
    function get_Weight(out weight: Smallint): HResult; stdcall;
    function put_Weight(weight: Smallint): HResult; stdcall;
    function get_Charset(out charset: Smallint): HResult; stdcall;
    function put_Charset(charset: Smallint): HResult; stdcall;
    function get_hFont(out font: HFont): HResult; stdcall;
    function Clone(out font: IFont): HResult; stdcall;
    function IsEqual(const fontOther: IFont): HResult; stdcall;
    function SetRatio(cyLogical, cyHimetric: Longint): HResult; stdcall;
    function QueryTextMetrics(out tm: TTextMetricOle): HResult; stdcall;
    function AddRefHfont(font: HFont): HResult; stdcall;
    function ReleaseHfont(font: HFont): HResult; stdcall;
  end;

  IFontDisp = interface(IDispatch)
    ['{BEF6E003-A874-101A-8BBA-00AA00300CAB}']
  end;

  IPicture = interface
    ['{7BF80980-BF32-101A-8BBB-00AA00300CAB}']
    function get_Handle(out handle: OLE_HANDLE): HResult; stdcall;
    function get_hPal(out handle: OLE_HANDLE): HResult; stdcall;
    function get_Type(out typ: Smallint): HResult; stdcall;
    function get_Width(out width: OLE_XSIZE_HIMETRIC): HResult; stdcall;
    function get_Height(out height: OLE_YSIZE_HIMETRIC): HResult; stdcall;
    function Render(dc: HDC; x, y, cx, cy: Longint; xSrc: OLE_XPOS_HIMETRIC; ySrc: OLE_YPOS_HIMETRIC;
      cxSrc: OLE_XSIZE_HIMETRIC; cySrc: OLE_YSIZE_HIMETRIC; const rcWBounds: TRect): HResult; stdcall;
    function set_hPal(hpal: OLE_HANDLE): HResult; stdcall;
    function get_CurDC(out dcOut: HDC): HResult; stdcall;
    function SelectPicture(dcIn: HDC; out hdcOut: HDC; out bmpOut: OLE_HANDLE): HResult; stdcall;
    function get_KeepOriginalFormat(out fkeep: BOOL): HResult; stdcall;
    function put_KeepOriginalFormat(fkeep: BOOL): HResult; stdcall;
    function PictureChanged: HResult; stdcall;
    function SaveAsFile(const stream: IStream; fSaveMemCopy: BOOL; out cbSize: Longint): HResult; stdcall;
    function get_Attributes(out dwAttr: Longint): HResult; stdcall;
  end;

  IPictureDisp = interface(IDispatch)
    ['{7BF80981-BF32-101A-8BBB-00AA00300CAB}']
  end;

  IOleDocumentView = interface(IUnknown)
    ['{b722bcc6-4e68-101b-a2bc-00aa00404770}']
    function SetInPlaceSite(Site: IOleInPlaceSite):HResult; stdcall;
    function GetInPlaceSite(out Site: IOleInPlaceSite):HResult; stdcall;
    function GetDocument(out P: IUnknown):HResult; stdcall;
    function SetRect(const View: TRECT):HResult; stdcall;
    function GetRect(var View: TRECT):HResult; stdcall;
    function SetRectComplex(const View, HScroll, VScroll, SizeBox):HResult; stdcall;
    function Show(fShow: BOOL):HResult; stdcall;
    function UIActivate(fUIActivate: BOOL):HResult; stdcall;
    function Open:HResult; stdcall;
    function CloseView(dwReserved: DWORD):HResult; stdcall;
    function SaveViewState(pstm: IStream):HResult; stdcall;
    function ApplyViewState(pstm: IStream):HResult; stdcall;
    function Clone(NewSite: IOleInPlaceSite; out NewView: IOleDocumentView):HResult; stdcall;
  end;

  IEnumOleDocumentViews = interface(IUnknown)
    ['{b722bcc8-4e68-101b-a2bc-00aa00404770}']
    function Next(Count: Longint; out View: IOleDocumentView; var Fetched: Longint):HResult; stdcall;
    function Skip(Count: Longint):HResult; stdcall;
    function Reset:HResult; stdcall;
    function Clone(out Enum: IEnumOleDocumentViews):HResult; stdcall;
  end;

  IOleDocument = interface(IUnknown)
    ['{b722bcc5-4e68-101b-a2bc-00aa00404770}']
    function CreateView(Site: IOleInPlaceSite; Stream: IStream; rsrvd: DWORD;
      out View: IOleDocumentView):HResult; stdcall;
    function GetDocMiscStatus(var Status: DWORD):HResult; stdcall;
    function EnumViews(out Enum: IEnumOleDocumentViews; out View: IOleDocumentView):HResult; stdcall;
  end;

  IOleDocumentSite = interface(IUnknown)
    ['{b722bcc7-4e68-101b-a2bc-00aa00404770}']
    function ActivateMe(View: IOleDocumentView): HRESULT; stdcall;
  end;

  IContinueCallback = interface(IUnknown)
    ['{b722bcca-4e68-101b-a2bc-00aa00404770}']
    function Continue: HResult; stdcall;
    function ContinuePrinting( nCntPrinted, nCurPage: Longint; PrintStatus: PWideChar): HResult; stdcall;
  end;

  IServiceProvider = interface(IUnknown)
    ['{6d5140c1-7436-11ce-8034-00aa006009fa}']
    function QueryService(const rsid, iid: TGuid; out Obj): HResult; stdcall;
  end;

  IPrint = interface(IUnknown)
    ['{b722bcc9-4e68-101b-a2bc-00aa00404770}']
    function SetInitialPageNum(nFirstPage: Longint): HResult; stdcall;
    function GetPageInfo(var pnFirstPage, pcPages: Longint): HResult; stdcall;
    function Print(grfFlags: DWORD; var td: TDVTARGETDEVICE;
      PageSet: PPageSet; stgmOptions: PStgMedium; Callback: IContinueCallback;
      FirstPage: Longint; pcPagesPrinted, pnLastPage: PLongint): HResult; stdcall;
  end;

  IOleCommandTarget = interface(IUnknown)
    ['{b722bccb-4e68-101b-a2bc-00aa00404770}']
    function QueryStatus(CmdGroup: PGUID; cCmds: Cardinal;
      prgCmds: POleCmd; CmdText: POleCmdText): HResult; stdcall;
    function Exec(CmdGroup: PGUID; nCmdID, nCmdexecopt: DWORD;
      const vaIn: OleVariant; var vaOut: OleVariant): HResult; stdcall;
  end;

  IActiveDesigner = interface
    ['{51AAE3E0-7486-11cf-A0C2-00AA0062BE57}']
    function GetRuntimeClassID(var clsid: TGUID): HResult; stdcall;
    function GetRuntimeMiscStatusFlags(var dwMiscFlags: DWORD): HResult; stdcall;
    function QueryPersistenceInterface(const iid: TGUID): HResult; stdcall;
    function SaveRuntimeState(const iidItf: TGUID; const iidObj: TGUID; Obj: IUnknown): HResult; stdcall;
    function GetExtensibilityObject(var ppvObjOut: IDispatch): HResult; stdcall;
  end;

  IPersistTextStream = interface(IPersistStreamInit)
    ['{56223fe3-d397-11cf-a42e-00aa00c00940}']
  end;

  IProvideRuntimeText = interface
    ['{56223FE1-D397-11cf-A42E-00AA00C00940}']
    function GetRuntimeText( var strRuntimeText: TBSTR ): HResult; stdcall;
  end;

  IEnumGUID = interface(IUnknown)
    ['{0002E000-0000-0000-C000-000000000046}']
    function Next(celt: UINT; out rgelt: TGUID; out pceltFetched: UINT): HResult; stdcall;
    function Skip(celt: UINT): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppenum: IEnumGUID): HResult; stdcall;
  end;

  IEnumCATEGORYINFO = interface(IUnknown)
    ['{0002E011-0000-0000-C000-000000000046}']
    function Next(celt: UINT; out rgelt: TCATEGORYINFO; out pceltFetched: UINT): HResult; stdcall;
    function Skip(celt: UINT): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppenum: IEnumCATEGORYINFO): HResult; stdcall;
  end;

  ICatRegister = interface(IUnknown)
    ['{0002E012-0000-0000-C000-000000000046}']
    function RegisterCategories(cCategories: UINT; rgCategoryInfo: PCATEGORYINFO): HResult; stdcall;
    function UnRegisterCategories(cCategories: UINT; rgcatid: Pointer): HResult; stdcall;
    function RegisterClassImplCategories(const rclsid: TGUID; cCategories: UINT; rgcatid: Pointer): HResult; stdcall;
    function UnRegisterClassImplCategories(const rclsid: TGUID; cCategories: UINT; rgcatid: Pointer): HResult; stdcall;
    function RegisterClassReqCategories(const rclsid: TGUID; cCategories: UINT; rgcatid: Pointer): HResult; stdcall;
    function UnRegisterClassReqCategories(const rclsid: TGUID; cCategories: UINT; rgcatid: Pointer): HResult; stdcall;
  end;

  ICatInformation = interface(IUnknown)
    ['{0002E013-0000-0000-C000-000000000046}']
    function EnumCategories(lcid: UINT; out ppenumCategoryInfo: IEnumCATEGORYINFO): HResult; stdcall;
    function GetCategoryDesc(const rcatid: TGUID; lcid: UINT; out pszDesc: PWideChar): HResult; stdcall;
    function EnumClassesOfCategories(cImplemented: UINT; rgcatidImpl: Pointer; cRequired: UINT; rgcatidReq: Pointer; out ppenumClsid: IEnumGUID): HResult; stdcall;
    function IsClassOfCategories(const rclsid: TGUID; cImplemented: UINT; rgcatidImpl: Pointer; cRequired: UINT; rgcatidReq: Pointer): HResult; stdcall;
    function EnumImplCategoriesOfClass(var rclsid: TGUID; out ppenumCatid: IEnumGUID): HResult; stdcall;
    function EnumReqCategoriesOfClass(var rclsid: TGUID; out ppenumCatid: IEnumGUID): HResult; stdcall;
  end;

  IBindHost = interface(IUnknown)
    ['{fc4801a1-2ba9-11cf-a229-00aa003d7352}']
  end;

  IOleUndoManager = interface(IUnknown)
    ['{d001f200-ef97-11ce-9bc9-00aa00608e01}']
  end;

  IQuickActivate = interface(IUnknown)
    ['{cf51ed10-62fe-11cf-bf86-00a0c9034836}']
    function QuickActivate(var qaCont: tagQACONTAINER; var qaCtrl: tagQACONTROL): HResult; stdcall;
    function SetContentExtent(const sizel: TPoint): HResult; stdcall;
    function GetContentExtent(out sizel: TPoint): HResult; stdcall;
  end;

  IObjectSafety = interface(IUnknown)
    ['{CB5BDC81-93C1-11CF-8F20-00805F2CD064}']
    function GetInterfaceSafetyOptions(const IID: TIID; pdwSupportedOptions,
      pdwEnabledOptions: PDWORD): HResult; stdcall;
    function SetInterfaceSafetyOptions(const IID: TIID; dwOptionSetMask,
      dwEnabledOptions: DWORD): HResult; stdcall;
  end;

  iOleUILinkContainer = interface(IUnknown)
    function GetNextLink(dwLink: Longint): Longint; stdcall;
    function SetLinkUpdateOptions(dwLink: Longint; dwUpdateOpt: Longint): HResult; stdcall;
    function GetLinkUpdateOptions(dwLink: Longint; var dwUpdateOpt: Longint): HResult; stdcall;
    function SetLinkSource(dwLink: Longint; pszDisplayName: PChar; lenFileName: Longint; var chEaten: Longint;
      fValidateSource: BOOL): HResult; stdcall;
    function GetLinkSource(dwLink: Longint; var pszDisplayName: PChar; var lenFileName: Longint; var pszFullLinkType: PChar;
      var pszShortLinkType: PChar; var fSourceAvailable: BOOL; var fIsSelected: BOOL): HResult; stdcall;
    function OpenLinkSource(dwLink: Longint): HResult; stdcall;
    function UpdateLink(dwLink: Longint; fErrorMessage: BOOL;
      fErrorAction: BOOL): HResult; stdcall;
    function CancelLink(dwLink: Longint): HResult; stdcall;
  end;

  iOleUIObjInfo = interface(IUnknown)
    function GetObjectInfo(dwObject: Longint; var dwObjSize: Longint; var lpszLabel: PChar;
       var lpszType: PChar; var lpszShortType: PChar; var lpszLocation: PChar): HResult; stdcall;
    function GetConvertInfo(dwObject: Longint; var ClassID: TCLSID;
      var wFormat: Word; var ConvertDefaultClassID: TCLSID;
      var lpClsidExclude: PCLSID; var cClsidExclude: Longint): HResult; stdcall;
    function ConvertObject(dwObject: Longint; const clsidNew: TCLSID): HResult; stdcall;
    function GetViewInfo(dwObject: Longint; var hMetaPict: HGlobal;
      var dvAspect: Longint; var nCurrentScale: Integer): HResult; stdcall;
    function SetViewInfo(dwObject: Longint; hMetaPict: HGlobal;
      dvAspect: Longint; nCurrentScale: Integer; bRelativeToOrig: BOOL): HResult; stdcall;
  end;

  iOleUILinkInfo = interface(IOleUILinkContainer)
    function GetLastUpdate(dwLink: Longint; var LastUpdate: TFileTime): HResult; stdcall;
  end;

function IsEqualGUID(const guid1, guid2: TGUID): Boolean; stdcall;
  external ole32dll name 'IsEqualGUID';

function IsEqualIID(const iid1, iid2: TIID): Boolean; stdcall;
  external ole32dll name 'IsEqualGUID';

function IsEqualCLSID(const clsid1, clsid2: TCLSID): Boolean; stdcall;
  external ole32dll name 'IsEqualGUID';

function CoBuildVersion: Longint; stdcall;
  external ole32dll name 'CoBuildVersion';

function CoInitialize(pvReserved: Pointer): HResult; stdcall;
  external ole32dll name 'CoInitialize';

procedure CoUninitialize; stdcall;
  external ole32dll name 'CoUninitialize';

function CoInitializeEx(pvReserved: Pointer; coInit: Longint): HResult; stdcall;
  external ole32dll name 'CoInitializeEx';

function CoGetMalloc(dwMemContext: Longint; out malloc: IMalloc): HResult; stdcall;
  external ole32dll name 'CoGetMalloc';

function CoGetCurrentProcess: Longint; stdcall;
  external ole32dll name 'CoGetCurrentProcess';

function CoRegisterMallocSpy(mallocSpy: IMallocSpy): HResult; stdcall;
  external ole32dll name 'CoRegisterMallocSpy';

function CoRevokeMallocSpy: HResult stdcall;
  external ole32dll name 'CoRevokeMallocSpy';

function CoCreateStandardMalloc(memctx: Longint; out malloc: IMalloc): HResult; stdcall;
  external ole32dll name 'CoCreateStandardMalloc';

function CoGetClassObject(const clsid: TCLSID; dwClsContext: Longint; pvReserved: Pointer; const iid: TIID; out pv): HResult; stdcall;
  external ole32dll name 'CoGetClassObject';

function CoRegisterClassObject(const clsid: TCLSID; unk: IUnknown; dwClsContext: Longint; flags: Longint; out dwRegister: Longint): HResult; stdcall;
  external ole32dll name 'CoRegisterClassObject';

function CoRevokeClassObject(dwRegister: Longint): HResult; stdcall;
  external ole32dll name 'CoRevokeClassObject';

function CoResumeClassObjects: HResult; stdcall;
  external ole32dll name 'CoResumeClassObjects';

function CoSuspendClassObjects: HResult; stdcall;
  external ole32dll name 'CoSuspendClassObjects';

function CoAddRefServerProcess: Longint; stdcall;
  external ole32dll name 'CoAddRefServerProcess';

function CoReleaseServerProcess: Longint; stdcall;
  external ole32dll name 'CoReleaseServerProcess';

function CoGetPSClsid(const iid: TIID; var pClsid: TCLSID): HResult; stdcall;
  external ole32dll name 'CoGetPSClsid';

function CoRegisterPSClsid(const iid: TIID; clsid: TCLSID): HResult; stdcall;
  external ole32dll name 'CoRegisterPSClsid';

function CoGetMarshalSizeMax(out ulSize: Longint; const iid: TIID; unk: IUnknown;
  dwDestContext: Longint; pvDestContext: Pointer; mshlflags: Longint): HResult; stdcall;
  external ole32dll name 'CoGetMarshalSizeMax';

function CoMarshalInterface(stm: IStream; const iid: TIID; unk: IUnknown;
  dwDestContext: Longint; pvDestContext: Pointer; mshlflags: Longint): HResult; stdcall;
  external ole32dll name 'CoMarshalInterface';

function CoUnmarshalInterface(stm: IStream; const iid: TIID; out pv): HResult; stdcall;
  external ole32dll name 'CoUnmarshalInterface';

function CoMarshalHResult(stm: IStream; result: HResult): HResult; stdcall;
  external ole32dll name 'CoMarshalHResult';

function CoUnmarshalHResult(stm: IStream; out result: HResult): HResult; stdcall;
  external ole32dll name 'CoUnmarshalHResult';

function CoReleaseMarshalData(stm: IStream): HResult; stdcall;
  external ole32dll name 'CoReleaseMarshalData';

function CoDisconnectObject(unk: IUnknown; dwReserved: Longint): HResult; stdcall;
  external ole32dll name 'CoDisconnectObject';

function CoLockObjectExternal(unk: IUnknown; fLock: BOOL; fLastUnlockReleases: BOOL): HResult; stdcall;
  external ole32dll name 'CoLockObjectExternal';

function CoGetStandardMarshal(const iid: TIID; unk: IUnknown; dwDestContext: Longint;
  pvDestContext: Pointer; mshlflags: Longint; out marshal: IMarshal): HResult; stdcall;
  external ole32dll name 'CoGetStandardMarshal';

function CoIsHandlerConnected(unk: IUnknown): BOOL; stdcall;
  external ole32dll name 'CoIsHandlerConnected';

function CoHasStrongExternalConnections(unk: IUnknown): BOOL; stdcall;
  external ole32dll name 'CoHasStrongExternalConnections';

function CoMarshalInterThreadInterfaceInStream(const iid: TIID; unk: IUnknown; out stm: IStream): HResult; stdcall;
  external ole32dll name 'CoMarshalInterThreadInterfaceInStream';

function CoGetInterfaceAndReleaseStream(stm: IStream; const iid: TIID; out pv): HResult; stdcall;
  external ole32dll name 'CoGetInterfaceAndReleaseStream';

function CoCreateFreeThreadedMarshaler(unkOuter: IUnknown; out unkMarshal: IUnknown): HResult; stdcall;
  external ole32dll name 'CoCreateFreeThreadedMarshaler';

function CoLoadLibrary(pszLibName: POleStr; bAutoFree: BOOL): THandle; stdcall;
  external ole32dll name 'CoLoadLibrary';

procedure CoFreeLibrary(hInst: THandle); stdcall;
  external ole32dll name 'CoFreeLibrary';

procedure CoFreeAllLibraries; stdcall;
  external ole32dll name 'CoFreeAllLibraries';

procedure CoFreeUnusedLibraries; stdcall;
  external ole32dll name 'CoFreeUnusedLibraries';

function CoInitializeSecurity(pSecDesc: PSecurityDescriptor; cAuthSvc: Longint; asAuthSvc: PSOleAuthenticationService;
  pReserved1: Pointer;  dwAuthnLevel, dImpLevel: Longint; pReserved2: Pointer; dwCapabilities: Longint; pReserved3: Pointer): HResult; stdcall;
  external ole32dll name 'CoInitializeSecurity';

function CoGetCallContext(const iid: TIID; pInterface: Pointer): HResult; stdcall;
  external ole32dll name 'CoGetCallContext';

function CoQueryProxyBlanket(Proxy: IUnknown; pwAuthnSvc, pAuthzSvc: PLongint; pServerPrincName: POleStr;
  pAuthnLevel, pImpLevel: PLongint; pAuthInfo: Pointer; pCapabilites: PLongint): HResult; stdcall;
  external ole32dll name 'CoQueryProxyBlanket';

function CoSetProxyBlanket(Proxy: IUnknown; dwAuthnSvc, dwAuthzSvc: Longint; pServerPrincName: POleStr;
  dwAuthnLevel, dwImpLevel: Longint; pAuthInfo: Pointer; dwCapabilites: Longint): HResult; stdcall;
  external ole32dll name 'CoSetProxyBlanket';

function CoCopyProxy(Proxy: IUnknown; var pCopy: IUnknown): HResult; stdcall;
  external ole32dll name 'CoCopyProxy';

function CoQueryClientBlanket(pwAuthnSvc, pAuthzSvc: PLongint; pServerPrincName: POleStr;
  dwAuthnLevel, dwImpLevel: Longint; pPrivs: Pointer; dwCapabilites: Longint): HResult; stdcall;
  external ole32dll name 'CoQueryClientBlanket';

function CoImpersonateClient: HResult; stdcall;
  external ole32dll name 'CoImpersonateClient';

function CoRevertToSelf: HResult; stdcall;
  external ole32dll name 'CoRevertToSelf';

function CoQueryAuthenticationServices(pcAuthSvc: PLongint; asAuthSvc: PSOleAuthenticationService): HResult; stdcall;
  external ole32dll name 'CoQueryAuthenticationServices';

function CoSwitchCallContext(NewObject: IUnknown; var pOldObject: IUnknown): HResult; stdcall;
  external ole32dll name 'CoSwitchCallContext';

function CoCreateInstance(const clsid: TCLSID; unkOuter: IUnknown; dwClsContext: Longint; const iid: TIID; out pv): HResult; stdcall;
  external ole32dll name 'CoCreateInstance';

function CoGetInstanceFromFile(ServerInfo: PCoServerInfo; clsid: PCLSID; punkOuter: IUnknown;
  dwClsCtx, grfMode: Longint; pwszName: POleStr; dwCount: Longint; rgmqResults: PMultiQIArray): HResult; stdcall;
  external ole32dll name 'CoGetInstanceFromFile';

function CoGetInstanceFromIStorage(ServerInfo: PCoServerInfo; clsid: PCLSID; punkOuter: IUnknown; dwClsCtx:
  Longint; stg: IUnknown; dwCount: Longint; rgmqResults: PMultiQIArray): HResult; stdcall;
  external ole32dll name 'CoGetInstanceFromIStorage';

function CoCreateInstanceEx(const clsid: TCLSID; unkOuter: IUnknown; dwClsCtx: Longint;
  ServerInfo: PCoServerInfo; dwCount: Longint; rgmqResults: PMultiQIArray): HResult; stdcall;
  external ole32dll name 'CoCreateInstanceEx';

function StringFromCLSID(const clsid: TCLSID; out psz: POleStr): HResult; stdcall;
  external ole32dll name 'StringFromCLSID';

function CLSIDFromString(psz: POleStr; out clsid: TCLSID): HResult; stdcall;
  external ole32dll name 'CLSIDFromString';

function StringFromIID(const iid: TIID; out psz: POleStr): HResult; stdcall;
  external ole32dll name 'StringFromIID';

function IIDFromString(psz: POleStr; out iid: TIID): HResult; stdcall;
  external ole32dll name 'IIDFromString';

function CoIsOle1Class(const clsid: TCLSID): BOOL; stdcall;
  external ole32dll name 'CoIsOle1Class';

function ProgIDFromCLSID(const clsid: TCLSID; out pszProgID: POleStr): HResult; stdcall;
  external ole32dll name 'ProgIDFromCLSID';

function CLSIDFromProgID(pszProgID: POleStr; out clsid: TCLSID): HResult; stdcall;
  external ole32dll name 'CLSIDFromProgID';

function StringFromGUID2(const guid: TGUID; psz: POleStr; cbMax: Integer): Integer; stdcall;
  external ole32dll name 'StringFromGUID2';

function CoCreateGuid(out guid: TGUID): HResult; stdcall;
  external ole32dll name 'CoCreateGuid';

function CoFileTimeToDosDateTime(const filetime: TFileTime; out dosDate: Word; out dosTime: Word): BOOL; stdcall;
  external ole32dll name 'CoFileTimeToDosDateTime';

function CoDosDateTimeToFileTime(nDosDate: Word; nDosTime: Word; out filetime: TFileTime): BOOL; stdcall;
  external ole32dll name 'CoDosDateTimeToFileTime';

function CoFileTimeNow(out filetime: TFileTime): HResult; stdcall;
  external ole32dll name 'CoFileTimeNow';

function CoRegisterMessageFilter(messageFilter: IMessageFilter; out pMessageFilter: IMessageFilter): HResult; stdcall;
  external ole32dll name 'CoRegisterMessageFilter';

function CoRegisterChannelHook(const ExtensionUuid: TGUID; ChannelHook: IChannelHook): HResult; stdcall;
  external ole32dll name 'CoRegisterChannelHook';

function CoGetTreatAsClass(const clsidOld: TCLSID; out clsidNew: TCLSID): HResult; stdcall;
  external ole32dll name 'CoGetTreatAsClass';

function CoTreatAsClass(const clsidOld: TCLSID; const clsidNew: TCLSID): HResult; stdcall;
  external ole32dll name 'CoTreatAsClass';

function CoTaskMemAlloc(cb: Longint): Pointer; stdcall;
  external ole32dll name 'CoTaskMemAlloc';

function CoTaskMemRealloc(pv: Pointer; cb: Longint): Pointer; stdcall;
  external ole32dll name 'CoTaskMemRealloc';

procedure CoTaskMemFree(pv: Pointer); stdcall;
  external ole32dll name 'CoTaskMemFree';

function CreateDataAdviseHolder(out DAHolder: IDataAdviseHolder): HResult; stdcall;
  external ole32dll name 'CreateDataAdviseHolder';

function CreateDataCache(unkOuter: IUnknown; const clsid: TCLSID; const iid: TIID; out pv): HResult; stdcall;
  external ole32dll name 'CreateDataCache';

function StgCreateDocfile(pwcsName: POleStr; grfMode: Longint; reserved: Longint; out stgOpen: IStorage): HResult; stdcall;
  external ole32dll name 'StgCreateDocfile';

function StgCreateDocfileOnILockBytes(lkbyt: ILockBytes; grfMode: Longint; reserved: Longint; out stgOpen: IStorage): HResult; stdcall;
  external ole32dll name 'StgCreateDocfileOnILockBytes';

function StgOpenStorage(pwcsName: POleStr; stgPriority: IStorage; grfMode: Longint; snbExclude: TSNB;
  reserved: Longint; out stgOpen: IStorage): HResult; stdcall;
  external ole32dll name 'StgOpenStorage';

function StgOpenStorageOnILockBytes(lkbyt: ILockBytes; stgPriority: IStorage; grfMode: Longint;
  snbExclude: TSNB; reserved: Longint; out stgOpen: IStorage): HResult; stdcall;
  external ole32dll name 'StgOpenStorageOnILockBytes';

function StgIsStorageFile(pwcsName: POleStr): HResult; stdcall;
  external ole32dll name 'StgIsStorageFile';

function StgIsStorageILockBytes(lkbyt: ILockBytes): HResult; stdcall;
  external ole32dll name 'StgIsStorageILockBytes';

function StgSetTimes(pszName: POleStr; const ctime: TFileTime; const atime: TFileTime; const mtime: TFileTime): HResult; stdcall;
  external ole32dll name 'StgSetTimes';

function StgOpenAsyncDocfileOnIFillLockBytes(flb: IFillLockBytes; grfMode, asyncFlags: Longint; var stgOpen: IStorage): HResult; stdcall;
  external ole32dll name 'StgOpenAsyncDocfileOnIFillLockBytes';

function StgGetIFillLockBytesOnILockBytes(ilb: ILockBytes; var flb: IFillLockBytes): HResult; stdcall;
  external ole32dll name 'StgGetIFillLockBytesOnILockBytes';

function StgGetIFillLockBytesOnFile(pwcsName: POleStr; var flb: IFillLockBytes): HResult; stdcall;
  external ole32dll name 'StgGetIFillLockBytesOnFile';

function StgOpenLayoutDocfile(pwcsDfName: POleStr; grfMode, reserved: Longint; var stgOpen: IStorage): HResult; stdcall;
  external ole32dll name 'StgOpenLayoutDocfile';

function BindMoniker(mk: IMoniker; grfOpt: Longint; const iidResult: TIID; out pvResult): HResult; stdcall;
  external ole32dll name 'BindMoniker';

function CoGetObject(pszName: PBStr; pBindOptions: PBindOpts; const iid: TIID; ppv: Pointer): HResult; stdcall;
  external ole32dll name 'CoGetObject';

function MkParseDisplayName(bc: IBindCtx; szUserName: POleStr; out chEaten: Longint; out mk: IMoniker): HResult; stdcall;
  external ole32dll name 'MkParseDisplayName';

function MonikerRelativePathTo(mkSrc: IMoniker; mkDest: IMoniker; out mkRelPath: IMoniker; dwReserved: BOOL): HResult; stdcall;
  external ole32dll name 'MonikerRelativePathTo';

function MonikerCommonPrefixWith(mkThis: IMoniker; mkOther: IMoniker; out mkCommon: IMoniker): HResult; stdcall;
  external ole32dll name 'MonikerCommonPrefixWith';

function CreateBindCtx(reserved: Longint; out bc: IBindCtx): HResult; stdcall;
  external ole32dll name 'CreateBindCtx';

function CreateGenericComposite(mkFirst: IMoniker; mkRest: IMoniker; out mkComposite: IMoniker): HResult; stdcall;
  external ole32dll name 'CreateGenericComposite';

function GetClassFile(szFilename: POleStr; out clsid: TCLSID): HResult; stdcall;
  external ole32dll name 'GetClassFile';

function CreateFileMoniker(pszPathName: POleStr; out mk: IMoniker): HResult; stdcall;
  external ole32dll name 'CreateFileMoniker';

function CreateItemMoniker(pszDelim: POleStr; pszItem: POleStr; out mk: IMoniker): HResult; stdcall;
  external ole32dll name 'CreateItemMoniker';

function CreateAntiMoniker(out mk: IMoniker): HResult; stdcall;
  external ole32dll name 'CreateAntiMoniker';

function CreatePointerMoniker(unk: IUnknown; out mk: IMoniker): HResult; stdcall;
  external ole32dll name 'CreatePointerMoniker';

function GetRunningObjectTable(reserved: Longint; out rot: IRunningObjectTable): HResult; stdcall;
  external ole32dll name 'GetRunningObjectTable';

function SysAllocString(psz: POleStr): TBStr; stdcall;
  external oleaut32dll name 'SysAllocString';

function SysReAllocString(var bstr: TBStr; psz: POleStr): Integer; stdcall;
  external oleaut32dll name 'SysReAllocString';

function SysAllocStringLen(psz: POleStr; len: Integer): TBStr; stdcall;
  external oleaut32dll name 'SysAllocStringLen';

function SysReAllocStringLen(var bstr: TBStr; psz: POleStr; len: Integer): Integer; stdcall;
  external oleaut32dll name 'SysReAllocStringLen';

procedure SysFreeString(bstr: TBStr); stdcall;
  external oleaut32dll name 'SysFreeString';

function SysStringLen(bstr: TBStr): Integer; stdcall;
  external oleaut32dll name 'SysStringLen';

function SysStringByteLen(bstr: TBStr): Integer; stdcall;
  external oleaut32dll name 'SysStringByteLen';

function SysAllocStringByteLen(psz: PChar; len: Integer): TBStr; stdcall;
  external oleaut32dll name 'SysAllocStringByteLen';

function DosDateTimeToVariantTime(wDosDate, wDosTime: Word; out vtime: TOleDate): Integer; stdcall;
  external oleaut32dll name 'DosDateTimeToVariantTime';

function VariantTimeToDosDateTime(vtime: TOleDate; out wDosDate, wDosTime: Word): Integer; stdcall;
  external oleaut32dll name 'VariantTimeToDosDateTime';

function SystemTimeToVariantTime(var SystemTime: TSystemTime; out vtime: TOleDate): Integer; stdcall;
  external oleaut32dll name 'SystemTimeToVariantTime';

function VariantTimeToSystemTime(vtime: TOleDate; out SystemTime: TSystemTime): Integer; stdcall;
  external oleaut32dll name 'VariantTimeToSystemTime';

function SafeArrayAllocDescriptor(cDims: Integer; out psaOut: PSafeArray): HResult; stdcall;
  external oleaut32dll name 'SafeArrayAllocDescriptor';

function SafeArrayAllocData(psa: PSafeArray): HResult; stdcall;
  external oleaut32dll name 'SafeArrayAllocData';

function SafeArrayCreate(vt: TVarType; cDims: Integer; const rgsabound): PSafeArray; stdcall;
  external oleaut32dll name 'SafeArrayCreate';

function SafeArrayCreateVector(vt: TVarType; Lbound, cElements: Longint): PSafeArray; stdcall;
  external oleaut32dll name 'SafeArrayCreateVector';

function SafeArrayCopyData(psaSource, psaTarget: PSafeArray): HResult; stdcall;
  external oleaut32dll name 'SafeArrayCopyData';

function SafeArrayDestroyDescriptor(psa: PSafeArray): HResult; stdcall;
  external oleaut32dll name 'SafeArrayDestroyDescriptor';

function SafeArrayDestroyData(psa: PSafeArray): HResult; stdcall;
  external oleaut32dll name 'SafeArrayDestroyData';

function SafeArrayDestroy(psa: PSafeArray): HResult; stdcall;
  external oleaut32dll name 'SafeArrayDestroy';

function SafeArrayRedim(psa: PSafeArray; const saboundNew: TSafeArrayBound): HResult; stdcall;
  external oleaut32dll name 'SafeArrayRedim';

function SafeArrayGetDim(psa: PSafeArray): Integer; stdcall;
  external oleaut32dll name 'SafeArrayGetDim';

function SafeArrayGetElemsize(psa: PSafeArray): Integer; stdcall;
  external oleaut32dll name 'SafeArrayGetElemsize';

function SafeArrayGetUBound(psa: PSafeArray; nDim: Integer; out lUbound: Longint): HResult; stdcall;
  external oleaut32dll name 'SafeArrayGetUBound';

function SafeArrayGetLBound(psa: PSafeArray; nDim: Integer; out lLbound: Longint): HResult; stdcall;
  external oleaut32dll name 'SafeArrayGetLBound';

function SafeArrayLock(psa: PSafeArray): HResult; stdcall;
  external oleaut32dll name 'SafeArrayLock';

function SafeArrayUnlock(psa: PSafeArray): HResult; stdcall;
  external oleaut32dll name 'SafeArrayUnlock';

function SafeArrayAccessData(psa: PSafeArray; out pvData: Pointer): HResult; stdcall;
  external oleaut32dll name 'SafeArrayAccessData';

function SafeArrayUnaccessData(psa: PSafeArray): HResult; stdcall;
  external oleaut32dll name 'SafeArrayUnaccessData';

function SafeArrayGetElement(psa: PSafeArray; const rgIndices; out pv): HResult; stdcall;
  external oleaut32dll name 'SafeArrayGetElement';

function SafeArrayPutElement(psa: PSafeArray; const rgIndices; const pv): HResult; stdcall;
  external oleaut32dll name 'SafeArrayPutElement';

function SafeArrayCopy(psa: PSafeArray; out psaOut: PSafeArray): HResult; stdcall;
  external oleaut32dll name 'SafeArrayCopy';

function SafeArrayPtrOfIndex(psa: PSafeArray; var rgIndices; out pvData: Pointer): HResult; stdcall;
  external oleaut32dll name 'SafeArrayPtrOfIndex';

procedure VariantInit(var varg: OleVariant); stdcall;
  external oleaut32dll name 'VariantInit';

function VariantClear(var varg: OleVariant): HResult; stdcall;
  external oleaut32dll name 'VariantClear';

function VariantCopy(var vargDest: OleVariant; const vargSrc: OleVariant): HResult; stdcall;
  external oleaut32dll name 'VariantCopy';

function VariantCopyInd(var varDest: OleVariant; const vargSrc: OleVariant): HResult; stdcall;
  external oleaut32dll name 'VariantCopyInd';

function VariantChangeType(var vargDest: OleVariant; const vargSrc: OleVariant; wFlags: Word; vt: TVarType): HResult; stdcall;
  external oleaut32dll name 'VariantChangeType';

function VariantChangeTypeEx(var vargDest: OleVariant; const vargSrc: OleVariant; lcid: TLCID; wFlags: Word; vt: TVarType): HResult; stdcall;
  external oleaut32dll name 'VariantChangeTypeEx';

function VectorFromBstr(bstr: TBStr; out psa: PSafeArray): HResult; stdcall;
  external oleaut32dll name 'VectorFromBstr';

function BstrFromVector(psa: PSafeArray; out bstr: TBStr): HResult; stdcall;
  external oleaut32dll name 'BstrFromVector';

function VarUI1FromI2(sIn: Smallint; out bOut: Byte): HResult; stdcall;
  external oleaut32dll name 'VarUI1FromI2';

function VarUI1FromI4(lIn: Longint; out bOut: Byte): HResult; stdcall;
  external oleaut32dll name 'VarUI1FromI4';

function VarUI1FromR4(fltIn: Single; out bOut: Byte): HResult; stdcall;
  external oleaut32dll name 'VarUI1FromR4';

function VarUI1FromR8(dblIn: Double; out bOut: Byte): HResult; stdcall;
  external oleaut32dll name 'VarUI1FromR8';

function VarUI1FromCy(cyIn: Currency; out bOut: Byte): HResult; stdcall;
  external oleaut32dll name 'VarUI1FromCy';

function VarUI1FromDate(dateIn: TOleDate; out bOut: Byte): HResult; stdcall;
  external oleaut32dll name 'VarUI1FromDate';

function VarUI1FromStr(const strIn: TBStr; lcid: TLCID; dwFlags: Longint; out bOut: Byte): HResult; stdcall;
  external oleaut32dll name 'VarUI1FromStr';

function VarUI1FromDisp(dispIn: IDispatch; lcid: TLCID; out bOut: Byte): HResult; stdcall;
  external oleaut32dll name 'VarUI1FromDisp';

function VarUI1FromBool(boolIn: TOleBool; out bOut: Byte): HResult; stdcall;
  external oleaut32dll name 'VarUI1FromBool';

function VarUI1FromI1(cIn: Char; out bOut: Byte): HResult; stdcall;
  external oleaut32dll name 'VarUI1FromI1';

function VarUI1FromUI2(uiIn: Word; out bOut: Byte): HResult; stdcall;
  external oleaut32dll name 'VarUI1FromUI2';

function VarUI1FromUI4(ulIn: Longint; out bOut: Byte): HResult; stdcall;
  external oleaut32dll name 'VarUI1FromUI4';

function VarUI1FromDec(pdecIn: PDecimal; out bOut: Byte): HResult; stdcall;
  external oleaut32dll name 'VarUI1FromDec';

function VarI2FromUI1(bIn: Byte; out sOut: Smallint): HResult; stdcall;
  external oleaut32dll name 'VarI2FromUI1';

function VarI2FromI4(lIn: Longint; out sOut: Smallint): HResult; stdcall;
  external oleaut32dll name 'VarI2FromI4';

function VarI2FromR4(fltIn: Single; out sOut: Smallint): HResult; stdcall;
  external oleaut32dll name 'VarI2FromR4';

function VarI2FromR8(dblIn: Double; out sOut: Smallint): HResult; stdcall;
  external oleaut32dll name 'VarI2FromR8';

function VarI2FromCy(cyIn: Currency; out sOut: Smallint): HResult; stdcall;
  external oleaut32dll name 'VarI2FromCy';

function VarI2FromDate(dateIn: TOleDate; out sOut: Smallint): HResult; stdcall;
  external oleaut32dll name 'VarI2FromDate';

function VarI2FromStr(const strIn: TBStr; lcid: TLCID; dwFlags: Longint; out sOut: Smallint): HResult; stdcall;
  external oleaut32dll name 'VarI2FromStr';

function VarI2FromDisp(dispIn: IDispatch; lcid: TLCID; out sOut: Smallint): HResult; stdcall;
  external oleaut32dll name 'VarI2FromDisp';

function VarI2FromBool(boolIn: TOleBool; out sOut: Smallint): HResult; stdcall;
  external oleaut32dll name 'VarI2FromBool';

function VarI2FromI1(cIn: Char; out bOut: Smallint): HResult; stdcall;
  external oleaut32dll name 'VarI2FromI1';

function VarI2FromUI2(uiIn: Word; out bOut: Smallint): HResult; stdcall;
  external oleaut32dll name 'VarI2FromUI2';

function VarI2FromUI4(ulIn: Longint; out bOut: Smallint): HResult; stdcall;
  external oleaut32dll name 'VarI2FromUI4';

function VarI2FromDec(pdecIn: PDecimal; out bOut: Smallint): HResult; stdcall;
  external oleaut32dll name 'VarI2FromDec';

function VarI4FromUI1(bIn: Byte; out lOut: Longint): HResult; stdcall;
  external oleaut32dll name 'VarI4FromUI1';

function VarI4FromI2(sIn: Smallint; out lOut: Longint): HResult; stdcall;
  external oleaut32dll name 'VarI4FromI2';

function VarI4FromR4(fltIn: Single; out lOut: Longint): HResult; stdcall;
  external oleaut32dll name 'VarI4FromR4';

function VarI4FromR8(dblIn: Double; out lOut: Longint): HResult; stdcall;
  external oleaut32dll name 'VarI4FromR8';

function VarI4FromCy(cyIn: Currency; out lOut: Longint): HResult; stdcall;
  external oleaut32dll name 'VarI4FromCy';

function VarI4FromDate(dateIn: TOleDate; out lOut: Longint): HResult; stdcall;
  external oleaut32dll name 'VarI4FromDate';

function VarI4FromStr(const strIn: TBStr; lcid: TLCID; dwFlags: Longint; out lOut: Longint): HResult; stdcall;
  external oleaut32dll name 'VarI4FromStr';

function VarI4FromDisp(dispIn: IDispatch; lcid: TLCID; out lOut: Longint): HResult; stdcall;
  external oleaut32dll name 'VarI4FromDisp';

function VarI4FromBool(boolIn: TOleBool; out lOut: Longint): HResult; stdcall;
  external oleaut32dll name 'VarI4FromBool';

function VarI4FromI1(cIn: Char; out bOut: Longint): HResult; stdcall;
  external oleaut32dll name 'VarI4FromI1';

function VarI4FromUI2(uiIn: Word; out bOut: Longint): HResult; stdcall;
  external oleaut32dll name 'VarI4FromUI2';

function VarI4FromUI4(ulIn: Longint; out bOut: Longint): HResult; stdcall;
  external oleaut32dll name 'VarI4FromUI4';

function VarI4FromDec(pdecIn: PDecimal; out bOut: Longint): HResult; stdcall;
  external oleaut32dll name 'VarI4FromDec';

function VarI4FromInt(intIn: Integer; out bOut: Longint): HResult; stdcall;
  external oleaut32dll name 'VarI4FromInt';

function VarR4FromUI1(bIn: Byte; out fltOut: Single): HResult; stdcall;
  external oleaut32dll name 'VarR4FromUI1';

function VarR4FromI2(sIn: Smallint; out fltOut: Single): HResult; stdcall;
  external oleaut32dll name 'VarR4FromI2';

function VarR4FromI4(lIn: Longint; out fltOut: Single): HResult; stdcall;
  external oleaut32dll name 'VarR4FromI4';

function VarR4FromR8(dblIn: Double; out fltOut: Single): HResult; stdcall;
  external oleaut32dll name 'VarR4FromR8';

function VarR4FromCy(cyIn: Currency; out fltOut: Single): HResult; stdcall;
  external oleaut32dll name 'VarR4FromCy';

function VarR4FromDate(dateIn: TOleDate; out fltOut: Single): HResult; stdcall;
  external oleaut32dll name 'VarR4FromDate';

function VarR4FromStr(const strIn: TBStr; lcid: TLCID; dwFlags: Longint; out fltOut: Single): HResult; stdcall;
  external oleaut32dll name 'VarR4FromStr';

function VarR4FromDisp(dispIn: IDispatch; lcid: TLCID; out fltOut: Single): HResult; stdcall;
  external oleaut32dll name 'VarR4FromDisp';

function VarR4FromBool(boolIn: TOleBool; out fltOut: Single): HResult; stdcall;
  external oleaut32dll name 'VarR4FromBool';

function VarR4FromI1(cIn: Char; out bOut: Single): HResult; stdcall;
  external oleaut32dll name 'VarR4FromI1';

function VarR4FromUI2(uiIn: Word; out bOut: Single): HResult; stdcall;
  external oleaut32dll name 'VarR4FromUI2';

function VarR4FromUI4(ulIn: Longint; out bOut: Single): HResult; stdcall;
  external oleaut32dll name 'VarR4FromUI4';

function VarR4FromDec(pdecIn: PDecimal; out bOut: Single): HResult; stdcall;
  external oleaut32dll name 'VarR4FromDec';

function VarR8FromUI1(bIn: Byte; out dblOut: Double): HResult; stdcall;
  external oleaut32dll name 'VarR8FromUI1';

function VarR8FromI2(sIn: Smallint; out dblOut: Double): HResult; stdcall;
  external oleaut32dll name 'VarR8FromI2';

function VarR8FromI4(lIn: Longint; out dblOut: Double): HResult; stdcall;
  external oleaut32dll name 'VarR8FromI4';

function VarR8FromR4(fltIn: Single; out dblOut: Double): HResult; stdcall;
  external oleaut32dll name 'VarR8FromR4';

function VarR8FromCy(cyIn: Currency; out dblOut: Double): HResult; stdcall;
  external oleaut32dll name 'VarR8FromCy';

function VarR8FromDate(dateIn: TOleDate; out dblOut: Double): HResult; stdcall;
  external oleaut32dll name 'VarR8FromDate';

function VarR8FromStr(const strIn: TBStr; lcid: TLCID; dwFlags: Longint; out dblOut: Double): HResult; stdcall;
  external oleaut32dll name 'VarR8FromStr';

function VarR8FromDisp(dispIn: IDispatch; lcid: TLCID; out dblOut: Double): HResult; stdcall;
  external oleaut32dll name 'VarR8FromDisp';

function VarR8FromBool(boolIn: TOleBool; out dblOut: Double): HResult; stdcall;
  external oleaut32dll name 'VarR8FromBool';

function VarR8FromI1(cIn: Char; out bOut: Double): HResult; stdcall;
  external oleaut32dll name 'VarR8FromI1';

function VarR8FromUI2(uiIn: Word; out bOut: Double): HResult; stdcall;
  external oleaut32dll name 'VarR8FromUI2';

function VarR8FromUI4(ulIn: Longint; out bOut: Double): HResult; stdcall;
  external oleaut32dll name 'VarR8FromUI4';

function VarR8FromDec(pdecIn: PDecimal; out bOut: Double): HResult; stdcall;
  external oleaut32dll name 'VarR8FromDec';

function VarDateFromUI1(bIn: Byte; out dateOut: TOleDate): HResult; stdcall;
  external oleaut32dll name 'VarDateFromUI1';

function VarDateFromI2(sIn: Smallint; out dateOut: TOleDate): HResult; stdcall;
  external oleaut32dll name 'VarDateFromI2';

function VarDateFromI4(lIn: Longint; out dateOut: TOleDate): HResult; stdcall;
  external oleaut32dll name 'VarDateFromI4';

function VarDateFromR4(fltIn: Single; out dateOut: TOleDate): HResult; stdcall;
  external oleaut32dll name 'VarDateFromR4';

function VarDateFromR8(dblIn: Double; out dateOut: TOleDate): HResult; stdcall;
  external oleaut32dll name 'VarDateFromR8';

function VarDateFromCy(cyIn: Currency; out dateOut: TOleDate): HResult; stdcall;
  external oleaut32dll name 'VarDateFromCy';

function VarDateFromStr(const strIn: TBStr; lcid: TLCID; dwFlags: Longint; out dateOut: TOleDate): HResult; stdcall;
  external oleaut32dll name 'VarDateFromStr';

function VarDateFromDisp(dispIn: IDispatch; lcid: TLCID; out dateOut: TOleDate): HResult; stdcall;
  external oleaut32dll name 'VarDateFromDisp';

function VarDateFromBool(boolIn: TOleBool; out dateOut: TOleDate): HResult; stdcall;
  external oleaut32dll name 'VarDateFromBool';

function VarDateFromI1(cIn: Char; out bOut: TOleDate): HResult; stdcall;
  external oleaut32dll name 'VarDateFromI1';

function VarDateFromUI2(uiIn: Word; out bOut: TOleDate): HResult; stdcall;
  external oleaut32dll name 'VarDateFromUI2';

function VarDateFromUI4(ulIn: Longint; out bOut: TOleDate): HResult; stdcall;
  external oleaut32dll name 'VarDateFromUI4';

function VarDateFromDec(pdecIn: PDecimal; out bOut: TOleDate): HResult; stdcall;
  external oleaut32dll name 'VarDateFromDec';

function VarCyFromUI1(bIn: Byte; out cyOut: Currency): HResult; stdcall;
  external oleaut32dll name 'VarCyFromUI1';

function VarCyFromI2(sIn: Smallint; out cyOut: Currency): HResult; stdcall;
  external oleaut32dll name 'VarCyFromI2';

function VarCyFromI4(lIn: Longint; out cyOut: Currency): HResult; stdcall;
  external oleaut32dll name 'VarCyFromI4';

function VarCyFromR4(fltIn: Single; out cyOut: Currency): HResult; stdcall;
  external oleaut32dll name 'VarCyFromR4';

function VarCyFromR8(dblIn: Double; out cyOut: Currency): HResult; stdcall;
  external oleaut32dll name 'VarCyFromR8';

function VarCyFromDate(dateIn: TOleDate; out cyOut: Currency): HResult; stdcall;
  external oleaut32dll name 'VarCyFromDate';

function VarCyFromStr(const strIn: TBStr; lcid: TLCID; dwFlags: Longint; out cyOut: Currency): HResult; stdcall;
  external oleaut32dll name 'VarCyFromStr';

function VarCyFromDisp(dispIn: IDispatch; lcid: TLCID; out cyOut: Currency): HResult; stdcall;
  external oleaut32dll name 'VarCyFromDisp';

function VarCyFromBool(boolIn: TOleBool; out cyOut: Currency): HResult; stdcall;
  external oleaut32dll name 'VarCyFromBool';

function VarCyFromI1(cIn: Char; out bOut: Currency): HResult; stdcall;
  external oleaut32dll name 'VarCyFromI1';

function VarCyFromUI2(uiIn: Word; out bOut: Currency): HResult; stdcall;
  external oleaut32dll name 'VarCyFromUI2';

function VarCyFromUI4(ulIn: Longint; out bOut: Currency): HResult; stdcall;
  external oleaut32dll name 'VarCyFromUI4';

function VarCyFromDec(pdecIn: PDecimal; out bOut: Currency): HResult; stdcall;
  external oleaut32dll name 'VarCyFromDec';

function VarBStrFromUI1(bVal: Byte; lcid: TLCID; dwFlags: Longint; out bstrOut: TBStr): HResult; stdcall;
  external oleaut32dll name 'VarBStrFromUI1';

function VarBStrFromI2(iVal: Smallint; lcid: TLCID; dwFlags: Longint; out bstrOut: TBStr): HResult; stdcall;
  external oleaut32dll name 'VarBStrFromI2';

function VarBStrFromI4(lIn: Longint; lcid: TLCID; dwFlags: Longint; out bstrOut: TBStr): HResult; stdcall;
  external oleaut32dll name 'VarBStrFromI4';

function VarBStrFromR4(fltIn: Single; lcid: TLCID; dwFlags: Longint; out bstrOut: TBStr): HResult; stdcall;
  external oleaut32dll name 'VarBStrFromR4';

function VarBStrFromR8(dblIn: Double; lcid: TLCID; dwFlags: Longint; out bstrOut: TBStr): HResult; stdcall;
  external oleaut32dll name 'VarBStrFromR8';

function VarBStrFromCy(cyIn: Currency; lcid: TLCID; dwFlags: Longint; out bstrOut: TBStr): HResult; stdcall;
  external oleaut32dll name 'VarBStrFromCy';

function VarBStrFromDate(dateIn: TOleDate; lcid: TLCID; dwFlags: Longint; out bstrOut: TBStr): HResult; stdcall;
  external oleaut32dll name 'VarBStrFromDate';

function VarBStrFromDisp(dispIn: IDispatch; lcid: TLCID; dwFlags: Longint; out bstrOut: TBStr): HResult; stdcall;
  external oleaut32dll name 'VarBStrFromDisp';

function VarBStrFromBool(boolIn: TOleBool; lcid: TLCID; dwFlags: Longint; out bstrOut: TBStr): HResult; stdcall;
  external oleaut32dll name 'VarBStrFromBool';

function VarBStrFromI1(cIn: Char; lcid: TLCID; dwFlags: Longint; out bstrOut: TBStr): HResult; stdcall;
  external oleaut32dll name 'VarBstrFromI1';

function VarBStrFromUI2(uiIn: Word; lcid: TLCID; dwFlags: Longint; out bstrOut: TBStr): HResult; stdcall;
  external oleaut32dll name 'VarBstrFromUI2';

function VarBStrFromUI4(ulIn: Longint; lcid: TLCID; dwFlags: Longint; out bstrOut: TBStr): HResult; stdcall;
  external oleaut32dll name 'VarBstrFromUI4';

function VarBStrFromDec(pdecIn: PDecimal; lcid: TLCID; dwFlags: Longint; out bstrOut: TBStr): HResult; stdcall;
  external oleaut32dll name 'VarBstrFromDec';

function VarBoolFromUI1(bIn: Byte; out boolOut: TOleBool): HResult; stdcall;
  external oleaut32dll name 'VarBoolFromUI1';

function VarBoolFromI2(sIn: Smallint; out boolOut: TOleBool): HResult; stdcall;
  external oleaut32dll name 'VarBoolFromI2';

function VarBoolFromI4(lIn: Longint; out boolOut: TOleBool): HResult; stdcall;
  external oleaut32dll name 'VarBoolFromI4';

function VarBoolFromR4(fltIn: Single; out boolOut: TOleBool): HResult; stdcall;
  external oleaut32dll name 'VarBoolFromR4';

function VarBoolFromR8(dblIn: Double; out boolOut: TOleBool): HResult; stdcall;
  external oleaut32dll name 'VarBoolFromR8';

function VarBoolFromDate(dateIn: TOleDate; out boolOut: TOleBool): HResult; stdcall;
  external oleaut32dll name 'VarBoolFromDate';

function VarBoolFromCy(cyIn: Currency; out boolOut: TOleBool): HResult; stdcall;
  external oleaut32dll name 'VarBoolFromCy';

function VarBoolFromStr(const strIn: TBStr; lcid: TLCID; dwFlags: Longint; out boolOut: TOleBool): HResult; stdcall;
  external oleaut32dll name 'VarBoolFromStr';

function VarBoolFromDisp(dispIn: IDispatch; lcid: TLCID; out boolOut: TOleBool): HResult; stdcall;
  external oleaut32dll name 'VarBoolFromDisp';

function VarBoolFromI1(cIn: Char; out boolOut: TOleBool): HResult; stdcall;
  external oleaut32dll name 'VarBoolFromI1';

function VarBoolFromUI2(uiIn: Word; out boolOut: TOleBool): HResult; stdcall;
  external oleaut32dll name 'VarBoolFromUI2';

function VarBoolFromUI4(ulIn: Longint; out boolOut: TOleBool): HResult; stdcall;
  external oleaut32dll name 'VarBoolFromUI4';

function VarBoolFromDec(pdecIn: PDecimal; out boolOut: TOleBool): HResult; stdcall;
  external oleaut32dll name 'VarBoolFromDec';

function LHashValOfNameSys(syskind: TSysKind; lcid: TLCID; szName: POleStr): Longint; stdcall;
  external oleaut32dll name 'LHashValOfNameSys';

function LHashValOfNameSysA(syskind: TSysKind; lcid: TLCID; szName: PChar): Longint; stdcall;
  external oleaut32dll name 'LHashValOfNameSysA';

function LoadTypeLib(szFile: POleStr; out tlib: ITypeLib): HResult; stdcall;
  external oleaut32dll name 'LoadTypeLib';

function LoadTypeLibEx(szFile: POleStr; regkind: TRegKind; out tlib: ITypeLib): HResult; stdcall;
  external oleaut32dll name 'LoadTypeLibEx';

function LoadRegTypeLib(const guid: TGUID; wVerMajor, wVerMinor: Word; lcid: TLCID; out tlib: ITypeLib): HResult; stdcall;
  external oleaut32dll name 'LoadRegTypeLib';

function QueryPathOfRegTypeLib(const guid: TGUID; wMaj, wMin: Word; lcid: TLCID; out bstrPathName: TBStr): HResult; stdcall;
  external oleaut32dll name 'QueryPathOfRegTypeLib';

function RegisterTypeLib(tlib: ITypeLib; szFullPath, szHelpDir: POleStr): HResult; stdcall;
  external oleaut32dll name 'RegisterTypeLib';

function UnRegisterTypeLib(const libID: TGUID; wVerMajor, wVerMinor: Word; lcid: TLCID; syskind: TSysKind): HResult; stdcall;
  external oleaut32dll name 'UnRegisterTypeLib';

function CreateTypeLib(syskind: TSysKind; szFile: POleStr; out ctlib: ICreateTypeLib): HResult; stdcall;
  external oleaut32dll name 'CreateTypeLib';

function CreateTypeLib2(syskind: TSysKind; szFile: POleStr; out ctlib: ICreateTypeLib2): HResult; stdcall;
  external oleaut32dll name 'CreateTypeLib2';

function DispGetParam(const dispparams: TDispParams; position: Integer; vtTarg: TVarType; var varResult: OleVariant; var puArgErr: Integer): HResult; stdcall;
  external oleaut32dll name 'DispGetParam';

function DispGetIDsOfNames(tinfo: ITypeInfo; rgszNames: POleStrList; cNames: Integer; rgdispid: PDispIDList): HResult; stdcall;
  external oleaut32dll name 'DispGetIDsOfNames';

function DispInvoke(This: Pointer; tinfo: ITypeInfo; dispidMember: TDispID; wFlags: Word; var params: TDispParams;
  varResult: PVariant; excepinfo: PExcepInfo; puArgErr: PInteger): HResult; stdcall;
  external oleaut32dll name 'DispInvoke';

function CreateDispTypeInfo(var idata: TInterfaceData; lcid: TLCID; out tinfo: ITypeInfo): HResult; stdcall;
  external oleaut32dll name 'CreateDispTypeInfo';

function CreateStdDispatch(unkOuter: IUnknown; pvThis: Pointer; tinfo: ITypeInfo; out unkStdDisp: IUnknown): HResult; stdcall;
  external oleaut32dll name 'CreateStdDispatch';

function DispCallFunc(pvInstance: Pointer; oVft: Longint; cc: TCallConv; vtReturn: TVarType; cActuals: Longint;
  var rgvt: TVarType; var prgpvarg: OleVariant; var vargResult: OleVariant): HResult; stdcall;
  external oleaut32dll name 'DispCallFunc';

function RegisterActiveObject(unk: IUnknown; const clsid: TCLSID; dwFlags: Longint; out dwRegister: Longint): HResult; stdcall;
  external oleaut32dll name 'RegisterActiveObject';

function RevokeActiveObject(dwRegister: Longint; pvReserved: Pointer): HResult; stdcall;
  external oleaut32dll name 'RevokeActiveObject';

function GetActiveObject(const clsid: TCLSID; pvReserved: Pointer; out unk: IUnknown): HResult; stdcall;
  external oleaut32dll name 'GetActiveObject';

function SetErrorInfo(dwReserved: Longint; errinfo: IErrorInfo): HResult; stdcall;
  external oleaut32dll name 'SetErrorInfo';

function GetErrorInfo(dwReserved: Longint; out errinfo: IErrorInfo): HResult; stdcall;
  external oleaut32dll name 'GetErrorInfo';

function CreateErrorInfo(out errinfo: ICreateErrorInfo): HResult; stdcall;
  external oleaut32dll name 'CreateErrorInfo';

function OaBuildVersion: Longint; stdcall;
  external oleaut32dll name 'OaBuildVersion';

procedure ClearCustData(var pCustData: TCustData); stdcall;
  external oleaut32dll name 'ClearCustData';

function OleBuildVersion: HResult; stdcall;
  external ole32dll name 'OleBuildVersion';

(* helper functions *)

function ReadClassStg(stg: IStorage; out clsid: TCLSID): HResult; stdcall;
  external ole32dll name 'ReadClassStg';

function WriteClassStg(stg: IStorage; const clsid: TIID): HResult; stdcall;
  external ole32dll name 'WriteClassStg';

function ReadClassStm(stm: IStream; out clsid: TCLSID): HResult; stdcall;
  external ole32dll name 'ReadClassStm';

function WriteClassStm(stm: IStream; const clsid: TIID): HResult; stdcall;
  external ole32dll name 'WriteClassStm';

function WriteFmtUserTypeStg(stg: IStorage; cf: TClipFormat; pszUserType: POleStr): HResult; stdcall;
  external ole32dll name 'WriteFmtUserTypeStg';

function ReadFmtUserTypeStg(stg: IStorage; out cf: TClipFormat; out pszUserType: POleStr): HResult; stdcall;
  external ole32dll name 'ReadFmtUserTypeStg';

function OleInitialize(pwReserved: Pointer): HResult; stdcall;
  external ole32dll name 'OleInitialize';

procedure OleUninitialize; stdcall;
  external ole32dll name 'OleUninitialize';

(* APIs to query whether (Embedded/Linked) object can be created from
   the data object *)

function OleQueryLinkFromData(srcDataObject: IDataObject): HResult; stdcall;
  external ole32dll name 'OleQueryLinkFromData';

function OleQueryCreateFromData(srcDataObject: IDataObject): HResult; stdcall;
  external ole32dll name 'OleQueryCreateFromData';

(* Object creation APIs *)

function OleCreate(const clsid: TCLSID; const iid: TIID; renderopt: Longint; formatEtc: PFormatEtc;
  clientSite: IOleClientSite; stg: IStorage; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreate';

function OleCreateEx(const clsid: TCLSID; const iid: TIID; dwFlags, renderopt, cFormats: Longint; rgAdvf: PLongintList;
  rgFFormatEtc: PFormatEtc; AdviseSink: IAdviseSink; rgdwConnection: PLongintList; clientSite: IOleClientSite; stg: IStorage; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreateEx';

function OleCreateFromData(srcDataObj: IDataObject; const iid: TIID; renderopt: Longint; formatEtc: PFormatEtc; clientSite: IOleClientSite; stg: IStorage; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreateFromData';

function OleCreateFromDataEx(srcDataObj: IDataObject; const iid: TIID; dwFlags, renderopt, cFormats: Longint;
  rgAdvf: PLongintList; rgFFormatEtc: PFormatEtc; AdviseSink: IAdviseSink; rgdwConnection: PLongintList; clientSite: IOleClientSite; stg: IStorage; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreateFromDataEx';

function OleCreateLinkFromData(srcDataObj: IDataObject; const iid: TIID; renderopt: Longint; formatEtc: PFormatEtc; clientSite: IOleClientSite; stg: IStorage; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreateLinkFromData';

function OleCreateLinkFromDataEx(srcDataObj: IDataObject; const iid: TIID; dwFlags, renderopt, cFormats: Longint;
  rgAdvf: PLongintList; rgFFormatEtc: PFormatEtc; AdviseSink: IAdviseSink; rgdwConnection: PLongintList; clientSite: IOleClientSite; stg: IStorage; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreateLinkFromDataEx';

function OleCreateStaticFromData(srcDataObj: IDataObject; const iid: TIID; renderopt: Longint; formatEtc: PFormatEtc;
  clientSite: IOleClientSite; stg: IStorage; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreateStaticFromData';

function OleCreateLink(mkLinkSrc: IMoniker; const iid: TIID; renderopt: Longint; formatEtc: PFormatEtc; clientSite: IOleClientSite; stg: IStorage; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreateLink';

function OleCreateLinkEx(mkLinkSrc: IMoniker; const iid: TIID; dwFlags, renderopt, cFormats: Longint;
  rgAdvf: PLongintList; rgFFormatEtc: PFormatEtc; AdviseSink: IAdviseSink; rgdwConnection: PLongintList; clientSite: IOleClientSite; stg: IStorage; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreateLinkEx';

function OleCreateLinkToFile(pszFileName: POleStr; const iid: TIID; renderopt: Longint; formatEtc: PFormatEtc; clientSite: IOleClientSite; stg: IStorage; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreateLinkToFile';

function OleCreateLinkToFileEx(pszFileName: POleStr; const iid: TIID; dwFlags, renderopt, cFormats: Longint; rgAdvf: PLongintList; rgFFormatEtc: PFormatEtc;
  AdviseSink: IAdviseSink; rgdwConnection: PLongintList; clientSite: IOleClientSite; stg: IStorage; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreateLinkToFileEx';

function OleCreateFromFile(const clsid: TCLSID; pszFileName: POleStr;  const iid: TIID; renderopt: Longint;
  formatEtc: PFormatEtc; clientSite: IOleClientSite; stg: IStorage; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreateFromFile';

function OleCreateFromFileEx(const clsid: TCLSID; pszFileName: POleStr; const iid: TIID; dwFlags, renderopt, cFormats: Longint;
  rgAdvf: PLongintList; rgFFormatEtc: PFormatEtc; AdviseSink: IAdviseSink; rgdwConnection: PLongintList;
  clientSite: IOleClientSite; stg: IStorage; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreateFromFileEx';

function OleLoad(stg: IStorage; const iid: TIID; clientSite: IOleClientSite; out vObj): HResult; stdcall;
  external ole32dll name 'OleLoad';

function OleSave(ps: IPersistStorage; stg: IStorage; fSameAsLoad: BOOL): HResult; stdcall;
  external ole32dll name 'OleSave';

function OleLoadFromStream(stm: IStream; const iidInterface: TIID; out vObj): HResult; stdcall;
  external ole32dll name 'OleLoadFromStream';

function OleSaveToStream(pstm: IPersistStream; stm: IStream): HResult; stdcall;
  external ole32dll name 'OleSaveToStream';

function OleSetContainedObject(unknown: IUnknown; fContained: BOOL): HResult; stdcall;
  external ole32dll name 'OleSetContainedObject';

function OleNoteObjectVisible(unknown: IUnknown; fVisible: BOOL): HResult; stdcall;
  external ole32dll name 'OleNoteObjectVisible';

(* Drag/Drop APIs *)

function RegisterDragDrop(wnd: HWnd; dropTarget: IDropTarget): HResult; stdcall;
  external ole32dll name 'RegisterDragDrop';

function RevokeDragDrop(wnd: HWnd): HResult; stdcall;
  external ole32dll name 'RevokeDragDrop';

function DoDragDrop(dataObj: IDataObject; dropSource: IDropSource; dwOKEffects: Longint; var dwEffect: Longint): HResult; stdcall;
  external ole32dll name 'DoDragDrop';

(* Clipboard APIs *)

function OleSetClipboard(dataObj: IDataObject): HResult; stdcall;
  external ole32dll name 'OleSetClipboard';

function OleGetClipboard(out dataObj: IDataObject): HResult; stdcall;
  external ole32dll name 'OleGetClipboard';

function OleFlushClipboard: HResult; stdcall;
  external ole32dll name 'OleFlushClipboard';

function OleIsCurrentClipboard(dataObj: IDataObject): HResult; stdcall;
  external ole32dll name 'OleIsCurrentClipboard';

(* InPlace Editing APIs *)

function OleCreateMenuDescriptor(hmenuCombined: HMenu; var menuWidths: TOleMenuGroupWidths): HMenu; stdcall;
  external ole32dll name 'OleCreateMenuDescriptor';

function OleSetMenuDescriptor(holemenu: HMenu; hwndFrame: HWnd; hwndActiveObject: HWnd; frame: IOleInPlaceFrame; activeObj: IOleInPlaceActiveObject): HResult; stdcall;
  external ole32dll name 'OleSetMenuDescriptor';

function OleDestroyMenuDescriptor(holemenu: HMenu): HResult; stdcall;
  external ole32dll name 'OleDestroyMenuDescriptor';

function OleTranslateAccelerator(frame: IOleInPlaceFrame; var frameInfo: TOleInPlaceFrameInfo; msg: PMsg): HResult; stdcall;
  external ole32dll name 'OleTranslateAccelerator';

(* Helper APIs *)

function OleDuplicateData(hSrc: THandle; cfFormat: TClipFormat; uiFlags: Integer): THandle; stdcall;
  external ole32dll name 'OleDuplicateData';

function OleDraw(unknown: IUnknown; dwAspect: Longint; hdcDraw: HDC; const rcBounds: TRect): HResult; stdcall;
  external ole32dll name 'OleDraw';

function OleRun(unknown: IUnknown): HResult; stdcall;
  external ole32dll name 'OleRun';

function OleIsRunning(obj: IOleObject): BOOL; stdcall;
  external ole32dll name 'OleIsRunning';

function OleLockRunning(unknown: IUnknown; fLock: BOOL; fLastUnlockCloses: BOOL): HResult; stdcall;
  external ole32dll name 'OleLockRunning';

procedure ReleaseStgMedium(var medium: TStgMedium); stdcall;
  external ole32dll name 'ReleaseStgMedium';

function CreateOleAdviseHolder(out OAHolder: IOleAdviseHolder): HResult; stdcall;
  external ole32dll name 'CreateOleAdviseHolder';

function OleCreateDefaultHandler(const clsid: TCLSID; unkOuter: IUnknown; const iid: TIID; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreateDefaultHandler';

function OleCreateEmbeddingHelper(const clsid: TCLSID; unkOuter: IUnknown; flags: Longint; cf: IClassFactory; const iid: TIID; out vObj): HResult; stdcall;
  external ole32dll name 'OleCreateEmbeddingHelper';

function IsAccelerator(accel: HAccel; cAccelEntries: Integer; msg: PMsg; var pwCmd: Word): BOOL; stdcall;
  external ole32dll name 'IsAccelerator';

(* Icon extraction Helper APIs *)

function OleGetIconOfFile(pszPath: POleStr; fUseFileAsLabel: BOOL): HGlobal; stdcall;
  external ole32dll name 'OleGetIconOfFile';

function OleGetIconOfClass(const clsid: TCLSID; pszLabel: POleStr; fUseTypeAsLabel: BOOL): HGlobal; stdcall;
  external ole32dll name 'OleGetIconOfClass';

function OleMetafilePictFromIconAndLabel(icon: HIcon; pszLabel: POleStr; pszSourceFile: POleStr; iIconIndex: Integer): HGlobal; stdcall;
  external ole32dll name 'OleMetafilePictFromIconAndLabel';

(* Registration Database Helper APIs *)

function OleRegGetUserType(const clsid: TCLSID; dwFormOfType: Longint; out pszUserType: POleStr): HResult; stdcall;
  external ole32dll name 'OleRegGetUserType';

function OleRegGetMiscStatus(const clsid: TCLSID; dwAspect: Longint; out dwStatus: Longint): HResult; stdcall;
  external ole32dll name 'OleRegGetMiscStatus';

function OleRegEnumFormatEtc(const clsid: TCLSID; dwDirection: Longint; out Enum: IEnumFormatEtc): HResult; stdcall;
  external ole32dll name 'OleRegEnumFormatEtc';

function OleRegEnumVerbs(const clsid: TCLSID; out Enum: IEnumOleVerb): HResult; stdcall;
  external ole32dll name 'OleRegEnumVerbs';

function OleConvertIStorageToOLESTREAM(stg: IStorage; polestm: Pointer): HResult; stdcall;
  external ole32dll name 'OleConvertIStorageToOLESTREAM';

function OleConvertOLESTREAMToIStorage(polestm: Pointer; stg: IStorage; td: PDVTargetDevice): HResult; stdcall;
  external ole32dll name 'OleConvertOLESTREAMToIStorage';

function OleConvertIStorageToOLESTREAMEx(stg: IStorage; cfFormat: TClipFormat; lWidth: Longint; lHeight: Longint;
  dwSize: Longint; var medium: TStgMedium; polestm: Pointer): HResult; stdcall;
  external ole32dll name 'OleConvertIStorageToOLESTREAMEx';

function OleConvertOLESTREAMToIStorageEx(polestm: Pointer; stg: IStorage; var cfFormat: TClipFormat;
  var lWidth: Longint; var lHeight: Longint; var dwSize: Longint; var medium: TStgMedium): HResult; stdcall;
  external ole32dll name 'OleConvertOLESTREAMToIStorageEx';

(* Storage Utility APIs *)

function GetHGlobalFromILockBytes(lkbyt: ILockBytes; out hglob: HGlobal): HResult; stdcall;
  external ole32dll name 'GetHGlobalFromILockBytes';

function CreateILockBytesOnHGlobal(hglob: HGlobal; fDeleteOnRelease: BOOL; out lkbyt: ILockBytes): HResult; stdcall;
  external ole32dll name 'CreateILockBytesOnHGlobal';

function GetHGlobalFromStream(stm: IStream; out hglob: HGlobal): HResult; stdcall;
  external ole32dll name 'GetHGlobalFromStream';

function CreateStreamOnHGlobal(hglob: HGlobal; fDeleteOnRelease: BOOL; out stm: IStream): HResult; stdcall;
  external ole32dll name 'CreateStreamOnHGlobal';

(* ConvertTo APIS *)

function OleDoAutoConvert(stg: IStorage; out clsidNew: TCLSID): HResult; stdcall;
  external ole32dll name 'OleDoAutoConvert';

function OleGetAutoConvert(const clsidOld: TCLSID; out clsidNew: TCLSID): HResult; stdcall;
  external ole32dll name 'OleGetAutoConvert';

function OleSetAutoConvert(const clsidOld: TCLSID; const clsidNew: TCLSID): HResult; stdcall;
  external ole32dll name 'OleSetAutoConvert';

function GetConvertStg(stg: IStorage): HResult; stdcall;
  external ole32dll name 'GetConvertStg';

function SetConvertStg(stg: IStorage; fConvert: BOOL): HResult; stdcall;
  external ole32dll name 'SetConvertStg';

function OleCreatePropertyFrame(hwndOwner: HWnd; x, y: Integer; lpszCaption: POleStr; cObjects: Integer;
  pObjects: Pointer; cPages: Integer; pPageCLSIDs: Pointer; lcid: TLCID; dwReserved: Longint; pvReserved: Pointer): HResult; stdcall;
  external olepro32dll name 'OleCreatePropertyFrame';

function OleCreatePropertyFrameIndirect(const Params: TOCPFIParams): HResult; stdcall;
  external olepro32dll name 'OleCreatePropertyFrameIndirect';

function OleTranslateColor(clr: TOleColor; hpal: HPalette; out colorref: TColorRef): HResult; stdcall;
  external olepro32dll name 'OleTranslateColor';

function OleCreateFontIndirect(const FontDesc: TFontDesc; const iid: TIID; out vObject): HResult; stdcall;
  external olepro32dll name 'OleCreateFontIndirect';

function OleCreatePictureIndirect(const PictDesc: TPictDesc; const iid: TIID; fOwn: BOOL; out vObject): HResult; stdcall;
  external olepro32dll name 'OleCreatePictureIndirect';

function OleLoadPicture(stream: IStream; lSize: Longint; fRunmode: BOOL; const iid: TIID; out vObject): HResult; stdcall;
  external olepro32dll name 'OleLoadPicture';

function OleLoadPicturePath(szURLorPath: POleStr; unkCaller: IUnknown; dwReserved: Longint; clrReserved: TOleColor;
  const iid: TIID; ppvRet: Pointer): HResult; stdcall;
  external olepro32dll name 'OleLoadPicturePath';

function OleLoadPictureFile(varFileName: OleVariant; var lpdispPicture: IDispatch): HResult; stdcall;
  external olepro32dll name 'OleLoadPictureFile';

function OleSavePictureFile(dispPicture: IDispatch; bstrFileName: TBStr): HResult; stdcall;
  external olepro32dll name 'OleSavePictureFile';

function OleIconToCursor(hinstExe: THandle; hIcon: THandle): HCursor; stdcall;
  external olepro32dll name 'OleIconToCursor';

function OleUIAddVerbMenu(oleObj: IOleObject; pszShortType: PChar; menu: HMenu; uPos: Integer; uIDVerbMin: Integer;
  uIDVerbMax: Integer; bAddConvert: BOOL; idConvert: Integer; var outMenu: HMenu): BOOL; stdcall;
  external oledlgdll name 'OleUIAddVerbMenuA';

function OleUIInsertObject(var Info: TOleUIInsertObject): Integer; stdcall;
  external oledlgdll name 'OleUIInsertObjectA';

function OleUIPasteSpecial(var Info: TOleUIPasteSpecial): Integer; stdcall;
  external oledlgdll name 'OleUIPasteSpecialA';

function OleUIEditLinks(var Info: TOleUIEditLinks): Integer; stdcall;
  external oledlgdll name 'OleUIEditLinksA';

function OleUIChangeIcon(var Info: TOleUIChangeIcon): Integer; stdcall;
  external oledlgdll name 'OleUIChangeIconA';

function OleUIConvert(var Info: TOleUIConvert): Integer; stdcall;
  external oledlgdll name 'OleUIConvertA';

function OleUICanConvertOrActivateAs(const clsid: TCLSID; fIsLinkedObject: BOOL; wFormat: Word): BOOL; stdcall;
  external oledlgdll name 'OleUICanConvertOrActivateAs';

function OleUIBusy(var Info: TOleUIBusy): Integer; stdcall;
  external oledlgdll name 'OleUIBusyA';

function OleUIObjectProperties(var Info: TOleUIObjectProps): Integer; stdcall;
  external oledlgdll name 'OleUIObjectPropertiesA';

function LHashValOfName(lcid: TLCID; szName: POleStr): Longint;
function Succeeded(Res: HResult): Boolean;
function Failed(Res: HResult): Boolean;
function ResultCode(Res: HResult): Integer;
function ResultFacility(Res: HResult): Integer;
function ResultSeverity(Res: HResult): Integer;
function MakeResult(Severity, Facility, _code: Integer): HResult;
function WHashValOfLHashVal(lhashval: Longint): Word;
function IsHashValCompatible(lhashval1, lhashval2: Longint): Boolean;
function PROPSETHDR_OSVER_KIND(dwOSVer: DWORD): Word;
function PROPSETHDR_OSVER_MAJOR(dwOSVer: DWORD): Byte;
function PROPSETHDR_OSVER_MINOR(dwOSVer: DWORD): Byte;

implementation

function LHashValOfName(lcid: TLCID; szName: POleStr): Longint;
begin
  Result := LHashValOfNameSys(SYS_WIN32, lcid, szName);
end;

function Succeeded(Res: HResult): Boolean;
asm
  mov    eax, [Res]
  and    eax, 80000000h
  jnz    @@1
  mov    eax, 1
  ret
@@1:
  xor    eax, eax
  ret
end;

function Failed(Res: HResult): Boolean; code;
asm
  mov    eax, [Res]
  and    eax, 80000000h
  jz     @@1
  mov    eax, 1
  ret
@@1:
  xor    eax, eax
  ret
end;

function ResultCode(Res: HResult): Integer; code;
asm
  mov    eax, [Res]
  and    eax, 0000FFFFh
  ret
end;

function ResultFacility(Res: HResult): Integer; code;
asm
  mov    eax, [Res]
  shr    eax, 16
  and    eax, 00001FFFh
  ret
end;

function ResultSeverity(Res: HResult): Integer; code;
asm
  mov    eax, [Res]
  shr    eax, 31
  ret
end;

function MakeResult(Severity, Facility, _code: Integer): HResult; code;
asm
  shl    [Severity], 31
  mov    eax, [Facility]
  shl    eax, 16
  or     eax, [Severity]
  or     eax, [_code]
  ret
end;

function WHashValOfLHashVal(lhashval: Longint): Word; code;
asm
  mov    eax, [lhashval]
  and    eax, 0000FFFFh
  ret
end;

function IsHashValCompatible(lhashval1, lhashval2: Longint): Boolean; code;
asm
  and    [lhashval1], 00FF0000h
  mov    eax, [lhashval2]
  and    eax, 00FF0000h
  cmp    eax, [lhashval1]
  jz     @@1
  xor    eax, eax
  ret
@@1:
  mov    eax, 1
  ret
end;

function PROPSETHDR_OSVER_KIND(dwOSVer: DWORD): Word; code;
asm
  mov    eax, [dwOSVer]
  shr    eax, 16
  ret
end;

function PROPSETHDR_OSVER_MAJOR(dwOSVer: DWORD): Byte; code;
asm
  mov    eax, [dwOSVer]
  and    eax, 000000FFh
  ret
end;

function PROPSETHDR_OSVER_MINOR(dwOSVer: DWORD): Byte; code;
asm
  mov    eax, [dwOSVer]
  shr    eax, 8
  and    eax, 000000FFh
  ret
end;

end.