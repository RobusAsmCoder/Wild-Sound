(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Types for OS/2 API Interface                           *)
(*       Targets: OS/2 only                                     *)
(*                                                              *)
(*       Copyright (c) 1995,98 TMT Development Corporation      *)
(*       Portions Copyright (c) by IBM Corporation              *)
(*       Author: Anton Moscal                                   *)
(*                                                              *)
(****************************************************************)

unit Os2Types;

interface

type
  ApiRet   = Longint;
  ApiRet16 = Word;
  SHandle  = Word;
  LHandle  = DWORD;
  Long     = Longint;
  PLong    = ^Long;
  PFn      = Pointer;

{ Quad-word }

  PQWord = ^QWord;
  QWord = record
   Lo: ULong;
   Hi: ULong;
 end;

const
  hNull   = 0;          { Null handle }
  ulFalse = 0;
  ulTrue  = 1;

{ cchMaxPath is the maximum fully qualified path name length including  }
{ the drive letter, colon, backslashes and terminating #0 symbol.       }
  cchMaxPath                    = 260;

{ cchMaxPathComp is the maximum individual path component name length   }
{ including a terminating #0 symbol.                                    }
  cchMaxPathComp                = 256;

type
{  Common Error definitions }
  PErrorId = ^ErrorId;
  ErrorId = ULong;

{ Severity codes }
const
  severity_NoError              = $0000;
  severity_Warning              = $0004;
  severity_Error                = $0008;
  severity_Severe               = $000C;
  severity_Unrecoverable        = $0010;

{ Base component error values }

winerr_Base                     = $1000;  { Window Manager                    }
gpierr_Base                     = $2000;  { Graphics Presentation Interface   }
deverr_Base                     = $3000;  { Device Manager                    }
splerr_Base                     = $4000;  { Spooler                           }

{ Common types used across components }

{ Common DOS types }
type
  HModule = LHandle;
  Pid     = LHandle;
  Tid     = LHandle;
  Sgid    = Word;

  PHmodule = ^HModule;
  PPid     = ^Pid;
  PTid     = ^Tid;

{ Common SUP types }
  Hab = LHandle;
  PHab = ^Hab;

{ Common GPI/DEV types }
  Hps = LHandle;
  PHps = ^Hps;

  Hdc = LHandle;
  PHdc = ^Hdc;

  HRgn = LHandle;
  PHRgn = ^HRgn;

  HBitMap = LHandle;
  PHbitMap = ^HBitMap;

  Hmf = LHandle;
  PHmf = ^Hmf;

  HPal = LHandle;
  PHPal = ^HPal;

  Color = Long;
  PColor = ^Color;

  PPointL  = ^PointL;
  NPPointL = ^PointL;
  PointL   = record
    X: Long;
    Y: Long;
  end;

  PPointS = ^PointS;
  PointS  = record
    X: Word;
    Y: Word;
  end;

  PRectL  = ^RectL;
  NPRectL = ^RectL;
  RectL   = record
    xLeft:   Long;
    yBottom: Long;
    xRight:  Long;
    yTop:    Long;
  end;

  Str8 = array[0..7] of Char;
  PStr8 = ^Str8;

{ Common DEV/SPL types }

  PDrivData = ^DrivData;
  DrivData  = record            { Record for for Device Driver data }
    cb:         Long;
    lVersion:   Long;
    szDeviceName: array[0..31] of Char;
    abGeneralData: Char;
  end;

 { Array indices for array parameter for DevOpenDC, SplQmOpen or SplQpOpen }

const
  Address                       = 0;
  Driver_Name                   = 1;
  Driver_Data                   = 2;
  Data_Type                     = 3;
  Comment                       = 4;
  Proc_Name                     = 5;
  Proc_Params                   = 6;
  Spl_Params                    = 7;
  Network_Params                = 8;

 { Record definition as an alternative of the array parameter }

type
 PDevOpenStruc = ^DevOpenStruc;
 DevOpenStruc = record
   pszLogAddress:       PChar;
   pszDriverName:       PChar;
   pDriv:               PDrivData;
   pszDataType:         PChar;
   pszComment:          PChar;
   pszQueueProcName:    PChar;
   pszQueueProcParams:  PChar;
   pszSpoolerParams:    PChar;
   pszNetworkParams:    PChar;
 end;

{ Common PMWP object and PMSTDDLG drag data }

  PPrintDest = ^PrintDest;
  PrintDest =  record
    cb:          ULong;
    lType:       Long;
    pszToken:    PChar;
    lCount:      Long;
    pdopData:    PChar;
    fl:          ULong;
    pszPrinter:  PChar;
  end;

const
  pd_job_Property               = $0001;        { Flags for .fl field }

{ Common AVIO/GPI types }

{ Values of fsSelection field of FATTRS structure }
  fattr_Sel_Italic               = $0001;
  fattr_Sel_Underscore           = $0002;
  fattr_Sel_Outline              = $0008;
  fattr_Sel_Strikeout            = $0010;
  fattr_Sel_Bold                 = $0020;

{ Values of fsType field of FATTRS structure }
  fattr_Type_Kerning            = $0004;
  fattr_Type_Mbcs               = $0008;
  fattr_Type_Dbcs               = $0010;
  fattr_Type_Antialiased        = $0020;

{ Values of fsFontUse field of FATTRS structure }
  fattr_FontUse_NoMix           = $0002;
  fattr_FontUse_Outline         = $0004;
  fattr_FontUse_Transformable   = $0008;

{ Size for fields in the font structures }
  FaceSize                      = 32;

{ Font struct for Vio/GpiCreateLogFont }

type
  PFAttrs = ^FAttrs;
  FAttrs  = record
    usRecordLength:         Word;
    fsSelection:            Word;
    lMatch:                 Long;
    szFacename: array [0..FACESIZE-1] of Char;
    idRegistry:             Word;
    usCodePage:             Word;
    lMaxBaselineExt:        Long;
    lAveCharWidth:          Long;
    fsType:                 Word;
    fsFontUse:              Word;
  end;

{ Values of fsType field of FONTMETRICS structure }
const
  fm_Type_Fixed                 = $0001;
  fm_Type_Licensed              = $0002;
  fm_Type_Kerning               = $0004;
  fm_Type_Dbcs                  = $0010;
  fm_Type_Mbcs                  = $0018;
  fm_Type_64k                   = $8000;
  fm_Type_Atoms                 = $4000;
  fm_Type_FamTrunc              = $2000;
  fm_Type_FaceTrunc             = $1000;

{ Values of fsDefn field of FONTMETRICS structure }
  fm_Defn_Outline               = $0001;
  fm_Defn_Ifi                   = $0002;
  fm_Defn_Win                   = $0004;
  fm_Defn_Generic               = $8000;

{ Values of fsSelection field of FONTMETRICS structure }
  fm_Sel_Italic                 = $0001;
  fm_Sel_Underscore             = $0002;
  fm_Sel_Negative               = $0004;
  fm_Sel_Outline                = $0008;
  fm_Sel_StrikeOut              = $0010;
  fm_Sel_Bold                   = $0020;

{ Values of fsCapabilities field of FONTMETRICS structure }
  fm_Cap_NoMix                  = $0001;

{ Font metrics returned by GpiQueryFonts and others }
type
  Panose  = record
    bFamilyType:        Byte;
    bSerifStyle:        Byte;
    bWeight:            Byte;
    bProportion:        Byte;
    bContrast:          Byte;
    bStrokeVariation:   Byte;
    bArmStyle:          Byte;
    bLetterform:        Byte;
    bMidline:           Byte;
    bXHeight:           Byte;
    abReserved: array[0..1] of Byte;
  end;

  PFontMetrics = ^FontMetrics;
  FontMetrics  = record
    szFamilyname: array[0..FACESIZE-1] of Char;
    szFacename:   array[0..FACESIZE-1] of Char;
    idRegistry:             Word;
    usCodePage:             Word;
    lEmHeight:              Long;
    lXHeight:               Long;
    lMaxAscender:           Long;
    lMaxDescender:          Long;
    lLowerCaseAscent:       Long;
    lLowerCaseDescent:      Long;
    lInternalLeading:       Long;
    lExternalLeading:       Long;
    lAveCharWidth:          Long;
    lMaxCharInc:            Long;
    lEmInc:                 Long;
    lMaxBaselineExt:        Long;
    sCharSlope:             SmallInt;
    sInlineDir:             SmallInt;
    sCharRot:               SmallInt;
    usWeightClass:          Word;
    usWidthClass:           Word;
    sXDeviceRes:            SmallInt;
    sYDeviceRes:            SmallInt;
    sFirstChar:             SmallInt;
    sLastChar:              SmallInt;
    sDefaultChar:           SmallInt;
    sBreakChar:             SmallInt;
    sNominalPointSize:      SmallInt;
    sMinimumPointSize:      SmallInt;
    sMaximumPointSize:      SmallInt;
    fsType:                 Word;
    fsDefn:                 Word;
    fsSelection:            Word;
    fsCapabilities:         Word;
    lSubscriptXSize:        Long;
    lSubscriptYSize:        Long;
    lSubscriptXOffset:      Long;
    lSubscriptYOffset:      Long;
    lSuperscriptXSize:      Long;
    lSuperscriptYSize:      Long;
    lSuperscriptXOffset:    Long;
    lSuperscriptYOffset:    Long;
    lUnderscoreSize:        Long;
    lUnderscorePosition:    Long;
    lStrikeoutSize:         Long;
    lStrikeoutPosition:     Long;
    sKerningPairs:          SmallInt;
    sFamilyClass:           SmallInt;
    lMatch:                 Long;
    FamilyNameAtom:         Long;
    FaceNameAtom:           Long;
    FmPanose:               Panose;
  end;

{ Common WIN types }
  HWnd = LHandle;
  PHWnd = ^HWnd;

  HMQ = LHandle;
  PHMQ = ^HMQ;

implementation

end.
