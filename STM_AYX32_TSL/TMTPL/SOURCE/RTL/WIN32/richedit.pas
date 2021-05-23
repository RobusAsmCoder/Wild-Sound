(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Win32 RichEdit 2.0 Control Interface Unit              *)
(*       Based on richedit.h                                    *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995,98 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit RichEdit;

(*
 *  Purpose:
 *           RICHEDIT v2.0 public definitions.  Note that there is additional
 *           functionality available for v2.0 that is not in the original
 *           Windows 95 release.
 *)

interface

uses Windows, Messages;

const
 RICHEDIT_CLASSA           = 'RichEdit20A';
 RICHEDIT_CLASSW           = 'RichEdit20W';
 RICHEDIT_CLASS            = 'RichEdit20A';
 RICHEDIT_CLASS10A         = 'RICHEDIT';
 CF_RTF                    = 'Rich Text Format';
 CF_RTFNOOBJS              = 'Rich Text Format Without Objects';
 CF_RETEXTOBJ              = 'RichEdit Text and Objects';

 WM_CONTEXTMENU            = $007B;
 WM_PRINTCLIENT            = $0318;

 PFM_STARTINDENT           = $00000001;
 PFM_RIGHTINDENT           = $00000002;
 PFM_OFFSET                = $00000004;
 PFM_ALIGNMENT             = $00000008;
 PFM_TABSTOPS              = $00000010;
 PFM_NUMBERING             = $00000020;
 PFM_OFFSETINDENT          = $80000000;

 PFN_BULLET                = $0001;

 PFA_LEFT                  = $0001;
 PFA_RIGHT                 = $0002;
 PFA_CENTER                = $0003;

 EM_GETLIMITTEXT           = WM_USER + 37;
 EM_SCROLLCARET            = WM_USER + 49;
 EM_CANPASTE               = WM_USER + 50;
 EM_DISPLAYBAND            = WM_USER + 51;
 EM_EXGETSEL               = WM_USER + 52;
 EM_EXLIMITTEXT            = WM_USER + 53;
 EM_EXLINEFROMCHAR         = WM_USER + 54;
 EM_EXSETSEL               = WM_USER + 55;
 EM_FINDTEXT               = WM_USER + 56;
 EM_FORMATRANGE            = WM_USER + 57;
 EM_GETCHARFORMAT          = WM_USER + 58;
 EM_GETEVENTMASK           = WM_USER + 59;
 EM_GETOLEINTERFACE        = WM_USER + 60;
 EM_GETPARAFORMAT          = WM_USER + 61;
 EM_GETSELTEXT             = WM_USER + 62;
 EM_HIDESELECTION          = WM_USER + 63;
 EM_PASTESPECIAL           = WM_USER + 64;
 EM_REQUESTRESIZE          = WM_USER + 65;
 EM_SELECTIONTYPE          = WM_USER + 66;
 EM_SETBKGNDCOLOR          = WM_USER + 67;
 EM_SETCHARFORMAT          = WM_USER + 68;
 EM_SETEVENTMASK           = WM_USER + 69;
 EM_SETOLECALLBACK         = WM_USER + 70;
 EM_SETPARAFORMAT          = WM_USER + 71;
 EM_SETTARGETDEVICE        = WM_USER + 72;
 EM_STREAMIN               = WM_USER + 73;
 EM_STREAMOUT              = WM_USER + 74;
 EM_GETTEXTRANGE           = WM_USER + 75;
 EM_FINDWORDBREAK          = WM_USER + 76;
 EM_SETOPTIONS             = WM_USER + 77;
 EM_GETOPTIONS             = WM_USER + 78;
 EM_FINDTEXTEX             = WM_USER + 79;
 EM_GETWORDBREAKPROCEX     = WM_USER + 80;
 EM_SETWORDBREAKPROCEX     = WM_USER + 81;
 EM_SETUNDOLIMIT           = WM_USER + 82;
 EM_REDO                   = WM_USER + 84;
 EM_CANREDO                = WM_USER + 85;
 EM_GETUNDONAME            = WM_USER + 86;
 EM_GETREDONAME            = WM_USER + 87;
 EM_STOPGROUPTYPING        = WM_USER + 88;
 EM_SETTEXTMODE            = WM_USER + 89;
 EM_GETTEXTMODE            = WM_USER + 90;
 EM_AUTOURLDETECT          = WM_USER + 91;
 EM_GETAUTOURLDETECT       = WM_USER + 92;
 EM_SETPALETTE             = WM_USER + 93;
 EM_GETTEXTEX              = WM_USER + 94;
 EM_GETTEXTLENGTHEX        = WM_USER + 95;
 EM_SETPUNCTUATION         = WM_USER + 100;
 EM_GETPUNCTUATION         = WM_USER + 101;
 EM_SETWORDWRAPMODE        = WM_USER + 102;
 EM_GETWORDWRAPMODE        = WM_USER + 103;
 EM_SETIMECOLOR            = WM_USER + 104;
 EM_GETIMECOLOR            = WM_USER + 105;
 EM_SETIMEOPTIONS          = WM_USER + 106;
 EM_GETIMEOPTIONS          = WM_USER + 107;
 EM_CONVPOSITION           = WM_USER + 108;
 EM_SETLANGOPTIONS         = WM_USER + 120;
 EM_GETLANGOPTIONS         = WM_USER + 121;
 EM_GETIMECOMPMODE         = WM_USER + 122;

 TM_PLAINTEXT              = $0001;
 TM_RICHTEXT               = $0002;
 TM_SINGLELEVELUNDO        = $0004;
 TM_MULTILEVELUNDO         = $0008;
 TM_SINGLECODEPAGE         = $0010;
 TM_MULTICODEPAGE          = $0020;

 IMF_AUTOKEYBOARD          = $0001;
 IMF_AUTOFONT              = $0002;
 IMF_IMECANCELCOMPLETE     = $0004;
 IMF_IMEALWAYSSENDNOTIFY   = $0008;

 ICM_NOTOPEN               = $0000;
 ICM_LEVEL3                = $0001;
 ICM_LEVEL2                = $0002;
 ICM_LEVEL2_5              = $0003;
 ICM_LEVEL2_SUI            = $0004;

 EN_MSGFILTER              = $0700;
 EN_REQUESTRESIZE          = $0701;
 EN_SELCHANGE              = $0702;
 EN_DROPFILES              = $0703;
 EN_PROTECTED              = $0704;
 EN_CORRECTTEXT            = $0705;
 EN_STOPNOUNDO             = $0706;
 EN_IMECHANGE              = $0707;
 EN_SAVECLIPBOARD          = $0708;
 EN_OLEOPFAILED            = $0709;
 EN_OBJECTPOSITIONS        = $070a;
 EN_LINK                   = $070b;
 EN_DRAGDROPDONE           = $070c;

 ENM_NONE                  = $00000000;
 ENM_CHANGE                = $00000001;
 ENM_UPDATE                = $00000002;
 ENM_SCROLL                = $00000004;
 ENM_KEYEVENTS             = $00010000;
 ENM_MOUSEEVENTS           = $00020000;
 ENM_REQUESTRESIZE         = $00040000;
 ENM_SELCHANGE             = $00080000;
 ENM_DROPFILES             = $00100000;
 ENM_PROTECTED             = $00200000;
 ENM_CORRECTTEXT           = $00400000;
 ENM_SCROLLEVENTS          = $00000008;
 ENM_DRAGDROPDONE          = $00000010;

 ENM_IMECHANGE             = $00800000;
 ENM_LANGCHANGE            = $01000000;
 ENM_OBJECTPOSITIONS       = $02000000;
 ENM_LINK                  = $04000000;

 ES_SAVESEL                = $00008000;
 ES_SUNKEN                 = $00004000;
 ES_DISABLENOSCROLL        = $00002000;
 ES_SELECTIONBAR           = $01000000;
 ES_NOOLEDRAGDROP          = $00000008;

 ES_EX_NOCALLOLEINIT       = $01000000;

 ES_VERTICAL               = $00400000;
 ES_NOIME                  = $00080000;
 ES_SELFIME                = $00040000;

 ECO_AUTOWORDSELECTION     = $00000001;
 ECO_AUTOVSCROLL           = $00000040;
 ECO_AUTOHSCROLL           = $00000080;
 ECO_NOHIDESEL             = $00000100;
 ECO_READONLY              = $00000800;
 ECO_WANTRETURN            = $00001000;
 ECO_SAVESEL               = $00008000;
 ECO_SELECTIONBAR          = $01000000;
 ECO_VERTICAL              = $00400000;

 ECOOP_SET                 = $0001;
 ECOOP_OR                  = $0002;
 ECOOP_AND                 = $0003;
 ECOOP_XOR                 = $0004;

 WB_CLASSIFY               = $0003;
 WB_MOVEWORDLEFT           = $0004;
 WB_MOVEWORDRIGHT          = $0005;
 WB_LEFTBREAK              = $0006;
 WB_RIGHTBREAK             = $0007;

 WB_MOVEWORDPREV           = $0004;
 WB_MOVEWORDNEXT           = $0005;
 WB_PREVBREAK              = $0006;
 WB_NEXTBREAK              = $0007;

 PC_FOLLOWING              = $0001;
 PC_LEADING                = $0002;
 PC_OVERFLOW               = $0003;
 PC_DELIMITER              = $0004;

 WBF_WORDWRAP              = $0010;
 WBF_WORDBREAK             = $0020;
 WBF_OVERFLOW              = $0040;
 WBF_LEVEL1                = $0080;
 WBF_LEVEL2                = $0100;
 WBF_CUSTOM                = $0200;

 IMF_FORCENONE             = $0001;
 IMF_FORCEENABLE           = $0002;
 IMF_FORCEDISABLE          = $0004;
 IMF_CLOSESTATUSWINDOW     = $0008;
 IMF_VERTICAL              = $0020;
 IMF_FORCEACTIVE           = $0040;
 IMF_FORCEINACTIVE         = $0080;
 IMF_FORCEREMEMBER         = $0100;
 IMF_MULTIPLEEDIT          = $0400;

 WBF_CLASS                 = $000F;
 WBF_ISWHITE               = $0010;
 WBF_BREAKLINE             = $0020;
 WBF_BREAKAFTER            = $0040;

 PFM_SPACEBEFORE           = $00000040;
 PFM_SPACEAFTER            = $00000080;
 PFM_LINESPACING           = $00000100;
 PFM_STYLE                 = $00000400;
 PFM_BORDER                = $00000800;
 PFM_SHADING               = $00001000;
 PFM_NUMBERINGSTYLE        = $00002000;
 PFM_NUMBERINGTAB          = $00004000;
 PFM_NUMBERINGSTART        = $00008000;
 PFM_RTLPARA               = $00010000;
 PFM_KEEP                  = $00020000;
 PFM_KEEPNEXT              = $00040000;
 PFM_PAGEBREAKBEFORE       = $00080000;
 PFM_NOLINENUMBER          = $00100000;
 PFM_NOWIDOWCONTROL        = $00200000;
 PFM_DONOTHYPHEN           = $00400000;
 PFM_SIDEBYSIDE            = $00800000;
 PFM_TABLE                 = $C0000000;

 PFM_EFFECTS               = PFM_RTLPARA or PFM_KEEP or PFM_KEEPNEXT or
                             PFM_TABLE or PFM_PAGEBREAKBEFORE or
                             PFM_NOLINENUMBER or PFM_NOWIDOWCONTROL or
                             PFM_DONOTHYPHEN or PFM_SIDEBYSIDE or PFM_TABLE;

 PFM_ALL                   = PFM_STARTINDENT or PFM_RIGHTINDENT or
                             PFM_OFFSET or PFM_ALIGNMENT or PFM_TABSTOPS or
                             PFM_NUMBERING or PFM_OFFSETINDENT;

 PFM_ALL2                  = PFM_ALL or PFM_EFFECTS or PFM_SPACEBEFORE or
                             PFM_SPACEAFTER or PFM_LINESPACING or
                             PFM_STYLE or PFM_SHADING or PFM_BORDER or
                             PFM_NUMBERINGTAB or PFM_NUMBERINGSTART or
                             PFM_NUMBERINGSTYLE;

 PFE_RTLPARA               = PFM_RTLPARA shr 16;
 PFE_KEEP                  = PFM_KEEP shr 16;
 PFE_KEEPNEXT              = PFM_KEEPNEXT shr 16;
 PFE_PAGEBREAKBEFORE       = PFM_PAGEBREAKBEFORE shr 16;
 PFE_NOLINENUMBER          = PFM_NOLINENUMBER shr 16;
 PFE_NOWIDOWCONTROL        = PFM_NOWIDOWCONTROL shr 16;
 PFE_DONOTHYPHEN           = PFM_DONOTHYPHEN shr 16;
 PFE_SIDEBYSIDE            = PFM_SIDEBYSIDE shr 16;
 PFE_TABLEROW              = $C000;
 PFE_TABLECELLEND          = $8000;
 PFE_TABLECELL             = $4000;

 PFA_JUSTIFY               = $0004;

 CFM_BOLD                  = $00000001;
 CFM_ITALIC                = $00000002;
 CFM_UNDERLINE             = $00000004;
 CFM_STRIKEOUT             = $00000008;
 CFM_PROTECTED             = $00000010;
 CFM_LINK                  = $00000020;
 CFM_SIZE                  = $80000000;
 CFM_COLOR                 = $40000000;
 CFM_FACE                  = $20000000;
 CFM_OFFSET                = $10000000;
 CFM_CHARSET               = $08000000;

 CFE_BOLD                  = $00000001;
 CFE_ITALIC                = $00000002;
 CFE_UNDERLINE             = $00000004;
 CFE_STRIKEOUT             = $00000008;
 CFE_PROTECTED             = $00000010;
 CFE_LINK                  = $00000020;
 CFE_AUTOCOLOR             = $40000000;

 SCF_SELECTION             = $0001;
 SCF_WORD                  = $0002;
 SCF_DEFAULT               = $0000;
 SCF_ALL                   = $0004;
 SCF_USEUIRULES            = $0008;

 SF_TEXT                   = $0001;
 SF_RTF                    = $0002;
 SF_RTFNOOBJS              = $0003;
 SF_TEXTIZED               = $0004;
 SF_UNICODE                = $0010;

 SFF_SELECTION             = $8000;


 SFF_PLAINRTF              = $4000;

 CFM_EFFECTS               = CFM_BOLD or CFM_ITALIC or CFM_UNDERLINE or
                             CFM_COLOR or CFM_STRIKEOUT or CFE_PROTECTED or
                             CFM_LINK;

 CFM_ALL                   = CFM_EFFECTS or CFM_SIZE or CFM_FACE or
                             CFM_OFFSET or CFM_CHARSET;

 CFM_SMALLCAPS             = $0040;
 CFM_ALLCAPS               = $0080;
 CFM_HIDDEN                = $0100;
 CFM_OUTLINE               = $0200;
 CFM_SHADOW                = $0400;
 CFM_EMBOSS                = $0800;
 CFM_IMPRINT               = $1000;
 CFM_DISABLED              = $2000;
 CFM_REVISED               = $4000;

 CFM_BACKCOLOR             = $04000000;
 CFM_LCID                  = $02000000;
 CFM_UNDERLINETYPE         = $00800000;
 CFM_WEIGHT                = $00400000;
 CFM_SPACING               = $00200000;
 CFM_KERNING               = $00100000;
 CFM_STYLE                 = $00080000;
 CFM_ANIMATION             = $00040000;
 CFM_REVAUTHOR             = $00008000;

 CFE_SUBSCRIPT             = $00010000;
 CFE_SUPERSCRIPT           = $00020000;
 CFM_SUBSCRIPT             = CFE_SUBSCRIPT or CFE_SUPERSCRIPT;
 CFM_SUPERSCRIPT           = CFM_SUBSCRIPT;

 CFM_EFFECTS2              = CFM_EFFECTS or CFM_DISABLED or CFM_SMALLCAPS or
                             CFM_ALLCAPS or CFM_HIDDEN or CFM_OUTLINE or
                             CFM_SHADOW or CFM_EMBOSS or CFM_IMPRINT or
                             CFM_DISABLED or CFM_REVISED or CFM_SUBSCRIPT or
                             CFM_SUPERSCRIPT or CFM_BACKCOLOR;

 CFM_ALL2                  = CFM_ALL or CFM_EFFECTS2 or CFM_BACKCOLOR or
                             CFM_LCID or CFM_UNDERLINETYPE or CFM_WEIGHT or
                             CFM_REVAUTHOR or CFM_SPACING or CFM_KERNING or
                             CFM_STYLE or CFM_ANIMATION;

 CFE_SMALLCAPS             = CFM_SMALLCAPS;
 CFE_ALLCAPS               = CFM_ALLCAPS;
 CFE_HIDDEN                = CFM_HIDDEN;
 CFE_OUTLINE               = CFM_OUTLINE;
 CFE_SHADOW                = CFM_SHADOW;
 CFE_EMBOSS                = CFM_EMBOSS;
 CFE_IMPRINT               = CFM_IMPRINT;
 CFE_DISABLED              = CFM_DISABLED;
 CFE_REVISED               = CFM_REVISED;

 CFE_AUTOBACKCOLOR         = CFM_BACKCOLOR;

 CFU_UNDERLINENONE         = $0000;
 CFU_UNDERLINE             = $0001;
 CFU_UNDERLINEWORD         = $0002;
 CFU_UNDERLINEDOUBLE       = $0003;
 CFU_UNDERLINEDOTTED       = $0004;
 CFU_INVERT                = $00FE;
 CFU_CF1UNDERLINE          = $00FF;

 SEL_EMPTY                 = $0000;
 SEL_TEXT                  = $0001;
 SEL_OBJECT                = $0002;
 SEL_MULTICHAR             = $0004;
 SEL_MULTIOBJECT           = $0008;

 GCM_RIGHTMOUSEDROP        = $8000;

 FT_MATCHCASE              = $0004;
 FT_WHOLEWORD              = $0002;

 OLEOP_DOVERB              = $0001;
 GT_DEFAULT                = $0000;
 GT_USECRLF                = $0001;
 WCH_EMBEDDING             = $FFFC;
 GTL_DEFAULT               = $0000;
 GTL_USECRLF               = $0001;
 GTL_PRECISE               = $0002;
 GTL_CLOSE                 = $0004;
 GTL_NUMCHARS              = $0008;
 GTL_NUMBYTES              = $0010;

 MAX_TAB_STOPS             = $0020;

 lDefaultTab               = 720;
 cchTextLimitDefault       = $7FFF;
 yHeightCharPtsMost        = 1638;

type
 TCharFormatA = record
   cbSize: UINT;
   dwMask: Longint;
   dwEffects: Longint;
   yHeight: Longint;
   yOffset: Longint;
   crTextColor: TColorRef;
   bCharSet: Byte;
   bPitchAndFamily: Byte;
   szFaceName: array[0..LF_FACESIZE - 1] of AnsiChar;
 end;
 TCharFormatW = record
   cbSize: UINT;
   dwMask: Longint;
   dwEffects: Longint;
   yHeight: Longint;
   yOffset: Longint;
   crTextColor: TColorRef;
   bCharSet: Byte;
   bPitchAndFamily: Byte;
   szFaceName: array[0..LF_FACESIZE - 1] of WideChar;
 end;
 TCharFormat = TCharFormatA;

 _charrange = record
   cpMin: Longint;
   cpMax: LongInt;
 end;
 TCharRange = _charrange;
 CharRange  = _charrange;

 TTextRangeA = record
   chrg: TCharRange;
   lpstrText: PAnsiChar;
 end;
 TTextRangeW = record
   chrg: TCharRange;
   lpstrText: PWideChar;
 end;
 TTextRange = TTextRangeA;

 TEditStreamCallBack = function conv arg_stdcall (dwCookie: Longint; pbBuff: PByte;   cb: Longint; var pcb: Longint): Longint;

 _editstream = record
   dwCookie: Longint;
   dwError: Longint;
   pfnCallback: TEditStreamCallBack;
 end;
 TEditStream = _editstream;
 EditStream  = _editstream;

 TFindTextA = record
   chrg: TCharRange;
   lpstrText: PAnsiChar;
 end;

 TFindTextExA = record
   chrg: TCharRange;
   lpstrText: PAnsiChar;
   chrgText: TCharRange;
 end;
 TFindTextW = record
   chrg: TCharRange;
   lpstrText: PWideChar;
 end;


 TFindTextExW = record
   chrg: TCharRange;
   lpstrText: PWideChar;
   chrgText: TCharRange;
 end;
 TFindText = TFindTextA;

 _formatrange = record
   hdc: HDC;
   hdcTarget: HDC;
   rc: TRect;
   rcPage: TRect;
   chrg: TCharRange;
 end;
 TFormatRange = _formatrange;
 FormatRange  = _formatrange;

 _paraformat = record
   cbSize: UINT;
   dwMask: DWord;
   wNumbering: Word;
   wReserved: Word;
   dxStartIndent: Longint;
   dxRightIndent: Longint;
   dxOffset: Longint;
   wAlignment: Word;
   cTabCount: Smallint;
   rgxTabs: array [0..MAX_TAB_STOPS - 1] of Longint;
 end;
 TParaFormat = _paraformat;
 ParaFormat  = _paraformat;

 TCharFormat2A = record
   cbSize: UINT;
   dwMask: DWord;
   dwEffects: DWord;
   yHeight: Longint;
   yOffset: Longint;
   crTextColor: TColorRef;
   bCharSet: Byte;
   bPitchAndFamily: Byte;
   szFaceName: array[0..LF_FACESIZE - 1] of AnsiChar;
   wWeight: Word;
   sSpacing: Smallint;
   crBackColor: TColorRef;
   lid: LCID;
   dwReserved: DWord;
   sStyle: Smallint;
   wKerning: Word;
   bUnderlineType: Byte;
   bAnimation: Byte;
   bRevAuthor: Byte;
   bReserved1: Byte;
 end;
 TCharFormat2W = record
   cbSize: UINT;
   dwMask: DWord;
   dwEffects: DWord;
   yHeight: Longint;
   yOffset: Longint;
   crTextColor: TColorRef;
   bCharSet: Byte;
   bPitchAndFamily: Byte;
   szFaceName: array[0..LF_FACESIZE - 1] of WideChar;
   wWeight: Word;
   sSpacing: Smallint;
   crBackColor: TColorRef;
   lid: LCID;
   dwReserved: DWord;
   sStyle: Smallint;
   wKerning: Word;
   bUnderlineType: Byte;
   bAnimation: Byte;
   bRevAuthor: Byte;
   bReserved1: Byte;
 end;
 TCharFormat2 = TCharFormat2A;

 TParaFormat2 = record
   cbSize: UINT;
   dwMask: DWord;
   wNumbering: Word;
   wReserved: Word;
   dxStartIndent: Longint;
   dxRightIndent: Longint;
   dxOffset: Longint;
   wAlignment: Word;
   cTabCount: Smallint;
   rgxTabs: array [0..MAX_TAB_STOPS - 1] of Longint;
   dySpaceBefore: Longint;
   dySpaceAfter: Longint;
   dyLineSpacing: Longint;
   sStyle: Smallint;
   bLineSpacingRule: Byte;
   bCRC: Byte;
   wShadingWeight: Word;
   wShadingStyle: Word;
   wNumberingStart: Word;
   wNumberingStyle: Word;
   wNumberingTab: Word;
   wBorderSpace: Word;
   wBorderWidth: Word;
   wBorders: Word;
 end;

 PMsgFilter = ^TMsgFilter;
   _msgfilter = record
   nmhdr: TNMHdr;
   msg: UINT;
   wParam: WPARAM;
   lParam: LPARAM;
 end;
 TMsgFilter = _msgfilter;
 MsgFilter  = _msgfilter;

 PReqSize = ^TReqSize;
 TReqSize = record
   nmhdr: TNMHdr;
   rc: TRect;
 end;

 PSelChange = ^TSelChange;
   _selchange = record
   nmhdr: TNMHdr;
   chrg: TCharRange;
   seltyp: Word;
 end;
 TSelChange = _selchange;
 SelChange  = _selchange;

 TEndDropFiles = record
   nmhdr: TNMHdr;
   hDrop: THandle;
   cp: Longint;
   fProtected: Bool;
 end;

 PENProtected = ^TENProtected;
   _enprotected = record
   nmhdr: TNMHdr;
   msg: UINT;
   wParam: WPARAM;
   lParam: LPARAM;
   chrg: TCharRange;
 end;
 TENProtected = _enprotected;
 EnProtected  = _enprotected;

 PENSaveClipboard = ^TENSaveClipboard;
 _ensaveclipboard = record
   nmhdr: TNMHdr;
   cObjectCount: Longint;
   cch: Longint;
 end;
 TENSaveClipboard = _ensaveclipboard;
 ENSaveClipboard  = _ensaveclipboard;

 TENOleOpFailed = packed record
   nmhdr: TNMHdr;
   iob: Longint;
   lOper: Longint;
   hr: HRESULT;
 end;

 TObjectPositions = packed record
   nmhdr: TNMHdr;
   cObjectCount: Longint;
   pcpPositions: PLongint;
 end;

 TENLink = record
   nmhdr: TNMHdr;
   msg: UINT;
   wParam: WPARAM;
   lParam: LPARAM;
   chrg: TCharRange;
 end;

 _encorrecttext = record
   nmhdr: TNMHdr;
   chrg: TCharRange;
   seltyp: Word;
 end;
 TENCorrectText = _encorrecttext;
 ENCorrectText  = _encorrecttext;

 _punctuation = record
   iSize: UINT;
   szPunctuation: PChar;
 end;
 TPunctuation = _punctuation;
 Punctuation  = _punctuation;

 _compcolor = record
   crText: TColorRef;
   crBackground: TColorRef;
   dwEffects: Longint;
 end;
 TCompColor = _compcolor;
 CompColor  = _compcolor;

 _repastespecial = record
   dwAspect: DWord;
   dwParam: DWord;
 end;
 TRepasteSpecial = _repastespecial;
 RepasteSpecial  = _repastespecial;

 UNDONAMEID = (UID_UNKNOWN, UID_TYPING, UID_DELETE, UID_DRAGDROP, UID_CUT, UID_PASTE);

 TGetTextEx = record
   cb: DWord;
   flags: DWord;
   codepage: UINT;
   lpDefaultChar: LPCSTR;
   lpUsedDefChar: PBOOL;
 end;

 TGetTextLengthEx = record
   flags: DWord;
   codepage: UINT;
 end;

implementation

end.
