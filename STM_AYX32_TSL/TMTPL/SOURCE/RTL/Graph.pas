(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Graph Unit                                             *)
(*       Target: MS-DOS, Win32                                  *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$r-,q-,i-,t-,x+,v-,a+,oa+,opt+}

unit Graph;

interface

{$ifdef __WIN32__}
uses Windows, Messages;
{$endif}

{$ifdef __DOS__}
type
 (* VBE info block for GetVbeInfo *)
 VbeInfoType = packed record
  VbeSignature       : DWord;
  VbeVersion         : Word;
  OemStringPtr       : DWord;
  Capabilities       : DWord;
  VideoModePtr       : DWord;
  TotalMemory        : Word;
  OEMSoftwareRev     : Word;
  OEMVendorNamePtr   : DWord;
  OEMProductNamePtr  : DWord;
  OEMProductRevPtr   : DWord;
  Reserved           : array [0..221] of Byte;
  OEMData            : array [0..255] of Byte;
 end;

 (* VBE mode info block for GetVbeModeInfo *)
 VbeModeInfoType = packed record
  ModeAttributes     : Word;
  WinAAttributes     : Byte;
  WinBAttributes     : Byte;
  WinGranularity     : Word;
  WinSize            : Word;
  WinASegment        : Word;
  WinBSegment        : Word;
  WinFuncPtr         : Pointer;
  BytesPerScanLine   : Word;
  XResolution        : Word;
  YResolution        : Word;
  XCharSize          : Byte;
  YCharSize          : Byte;
  NumberOfPlanes     : Byte;
  BitsPerPixel       : Byte;
  NumberOfBanks      : Byte;
  MemoryModel        : Byte;
  BankSize           : Byte;
  NumberOfImagePages : Byte;
  Reserved           : Byte;
  RedMaskSize        : Byte;
  RedFieldPosition   : Byte;
  GreenMaskSize      : Byte;
  GreenFieldPosition : Byte;
  BlueMaskSize       : Byte;
  BlueFieldPosition  : Byte;
  RsvdMaskSize       : Byte;
  RsvdFieldPosition  : Byte;
  DirectColorModeInfo: Byte;
  PhysBasePtr        : DWord;
  OffScreenMemOffset : DWord;
  OffScreenMemSize   : Word;
  Reserved2          : Array [0..205] of Byte;
 end;
{$endif}

type
 GraphModeType = packed record
  VideoMode          : Word;
  HaveLFB            : Boolean;
  BitsPerPixel       : Byte;
  XResolution        : Word;
  YResolution        : Word;
 end;

 ViewPortType = packed record
  X1,Y1,X2,Y2        : LongInt;
  Clip               : Boolean;
 end;

 TextSettingsType = packed record
  Font               : Pointer;
  FontSize           : DWord;
  FirstChar          : DWord;
  Width              : DWord;
  Height             : DWord;
  Space              : DWord;
  Direction          : DWord;
  Horiz              : DWord;
  Vert               : DWord;
 end;

 FillPatternType = array[1..8] of byte;

 PointType = packed record
  X, Y               : LongInt;
 end;

 RGBType = packed record
  Blue,Green,Red,Alignment: Byte;
 end;

 PaletteType = packed record
  Size               : Word;
  Colors             : Array [0..255] of DWord;
 end;

 LineSettingsType = packed record
  LineStyle          : Word;
  Pattern            : Word;
  Thickness          : Word;
 end;

 FillSettingsType = packed record
  Pattern : DWord;
  Color   : DWord;
 end;

const
  MaxVbeModes        = 70;

 (* GraphResult error return codes *)
  grOK               = 0;
  grInvalidMode      = 1;
  grModeNotSupported = 2;
  grSetModeError     = 3;
  grLFBSetupError    = 4;
  grError            = 5;
  grVESANotFound     = 6;
  grVESAError        = 7;
  grNoGraphMem       = 8;
  grInvalidDriver    = 9;
  grDirectXNotFound  = 10;
  grDirectXError     = 11;

 (* VMode constants for SetVideoMode *)
  LFBorBanked        = 0;
  BankedOnly         = 1;
  LFBOnly            = 2;

 (* Clip constants for SetViewPort *)
  ClipOn             = TRUE;
  ClipOff            = FALSE;

 (* Top constants for Bar3D *)
  TopOn              = TRUE;
  TopOff             = FALSE;

 (* Stile constants for SetLineStyle *)
  CopyPut            = 0;
  NormalPut          = 0;
  XorPut             = 1;
  OrPut              = 2;
  AndPut             = 3;

 (* Font constants for SetTextStyle *)
  SmallFont          = 0;
  MediumFont         = 1;
  LargeFont          = 2;

  DefaultFont        : DWord=2;
  CurrentFont        = $FFFFFFFF;

 (* Direction constants for SetFontStyle *)
  HorizDir           = 0;
  VertDir            = 1;

 (* Justify constants for SetTextJustify *)
  LeftText           = 0;
  CenterText         = 1;
  RightText          = 2;
  BottomText         = 0;
  TopText            = 2;

 (* Line style constants *)
  SolidLn            = 0;
  DottedLn           = 1;
  CenterLn           = 2;
  DashedLn           = 3;
  UserBitLn          = 4;

  NormWidth          = 1;
  ThickWidth         = 3;

 (* Fill style constants *)
  EmptyFill          = 0;
  SolidFill          = 1;
  LineFill           = 2;
  LtSlashFill        = 3;
  SlashFill          = 4;
  BkSlashFill        = 5;
  LtBkSlashFill      = 6;
  HatchFill          = 7;
  XHatchFill         = 8;
  InterleaveFill     = 9;
  WideDotFill        = 10;
  CloseDotFill       = 11;
  UserFill           = 12;

  Black              = 0;
  Blue               = 1;
  Green              = 2;
  Cyan               = 3;
  Red                = 4;
  Magenta            = 5;
  Brown              = 6;
  LightGray          = 7;
  DarkGray           = 8;
  LightBlue          = 9;
  LightGreen         = 10;
  LightCyan          = 11;
  LightRed           = 12;
  LightMagenta       = 13;
  Yellow             = 14;
  White              = 15;

 (* Following color constants aren't permanent. They are changes depending on
 current color mode. *)
  clBlack:        DWord =0;
  clBlue:         DWord =1;
  clGreen:        DWord =2;
  clCyan:         DWord =3;
  clRed:          DWord =4;
  clMagenta:      DWord =5;
  clBrown:        DWord =6;
  clLightGray:    DWord =7;
  clDarkGray:     DWord =8;
  clLightBlue:    DWord =9;
  clLightGreen:   DWord =10;
  clLightCyan:    DWord =11;
  clLightRed:     DWord =12;
  clLightMagenta: DWord =13;
  clYellow:       DWord =14;
  clWhite:        DWord =15;

 (* Direct color modes info *)
  DcRedMask       : Byte=0;
  DcGreenMask     : Byte=0;
  DcBlueMask      : Byte=0;
  DcRedPos        : Byte=0;
  DcGreenPos      : Byte=0;
  DcBluePos       : Byte=0;
  DcRedAdjust     : Byte=0;
  DcGreenAdjust   : Byte=0;
  DcBlueAdjust    : Byte=0;

 (* Graphic driver constants *)
  Detect        = 0;
  CGA           = 1;
  MCGA          = 2;
  EGA           = 3;
  EGA64         = 4;
  EGAMono       = 5;
  IBM8514       = 6;
  HercMono      = 7;
  ATT400        = 8;
  VGA           = 9;
  PC3270        = 10;
  SVGA256       = 11;
  SVGA32K       = 12;
  SVGA64K       = 13;
  SVGA16M       = 14;
  SVGA4G        = 15;

 (* Graphic mode constants *)
  CGAC0         = $00; // 320  x 200  - not supported
  CGAC          = $01; // 320  x 200  - not supported
  CGAC2         = $02; // 320  x 200  - not supported
  CGAC3         = $03; // 320  x 200  - not supported
  CGAHi         = $04; // 640  x 200  - not supported
  MCGAC0        = $00; // 320  x 200  - MCGA 320x200x256
  MCGAC1        = $01; // 320  x 200  - MCGA 320x200x256
  MCGAC2        = $02; // 320  x 200  - MCGA 320x200x256
  MCGAC3        = $03; // 320  x 200  - MCGA 320x200x256
  MCGAMed       = $04; // 640  x 200  - not supported
  MCGAHi        = $05; // 640  x 480  - not supported
  EGAMonoHi     = $03; // 640  x 350  - not supported
  HercMonoHi    = $00; // 720  x 348  - not supported
  VGALo         = $00; // 640  x 200  - not supported
  VGAMed        = $01; // 640  x 350  - emulated using VESA 640x350x256
  EGALo         = $00; // 640  x 200  - not supported
  EGAHi         = $01; // 640  x 350  - emulated using VESA 640x350x256
  EGA64Lo       = $00; // 640  x 200  - not supported
  EGA64Hi       = $01; // 640  x 350  - not supported
  ATT400C0      = $00; // 320  x 200  - not supported
  ATT400C1      = $01; // 320  x 200  - not supported
  ATT400C2      = $02; // 320  x 200  - not supported
  ATT400C3      = $03; // 320  x 200  - not supported
  ATT400Med     = $04; // 640  x 200  - not supported
  ATT400Hi      = $05; // 640  x 400  - not supported
  IBM8514Lo     = $00; // 640  x 480  - not supported
  IBM8514Hi     = $01; // 1024 x 768  - not supported
  PC3270Hi      = $00; // 720  x 350  - not supported
  VGAHi         = $02; // 640  x 480  - emulated using VESA 640x480x256
  SVGALo        = $00; // 640  x 480  - SVGA mode
  SVGAMed       = $01; // 800  x 600  - SVGA mode
  SVGAHi        = $02; // 1024 x 768  - SVGA mode
  SVGA0         = $03; // 320  x 200  - SVGA mode
  SVGA1         = $04; // 320  x 240  - SVGA mode
  SVGA2         = $05; // 512  x 384  - SVGA mode
  SVGA3         = $06; // 640  x 350  - SVGA mode
  SVGA4         = $07; // 640  x 400  - SVGA mode
  SVGA5         = $08; // 1152 x 864  - SVGA mode
  SVGA6         = $09; // 1280 x 1024 - SVGA mode
  SVGA7         = $0A; // 1600 x 1200 - SVGA mode

const
  DrawBorder:         Boolean  = TRUE;
{$ifdef __WIN32__}
  IgnoreCloseMessage: Boolean  = TRUE; // Do not process Alt+F4
  IgnoreBreak:        Boolean  = FALSE; // Do Process Ctrl+Break and Ctrl+C
  DefaultIcon:        THandle  = 0;
  DefaultCursor:      THandle  = 0;
var
  GraphWndProc: function(Window: HWND; Mess, WParam, LParam: LongInt): LongInt := nil;
{$endif}

 function  GraphResult: LongInt;
 function  GraphErrorMsg(ErrorCode: LongInt): String;
 procedure ClearViewPort;
 procedure SetViewPort(X1,Y1,X2,Y2: LongInt; Clip: Boolean);
 procedure GetViewSettings(var ViewPort: ViewPortType);
 procedure SetLogicalPage(SX,SY: Word);
 procedure GetLogicalPage(var SX,SY: Word);

 function  GetPageSize: DWord;
 procedure SetVisualPage(PageNo: DWord; WaitForRetrace: Boolean);
 function  GetVisualPage: DWord;
 procedure SetActivePage(PageNo: DWord);
 function  GetActivePage: DWord;
 function  GetMaxColor: DWord;
 procedure SetColor(Color: DWord);
 function  GetColor: DWord;
 procedure SetBkColor(Color: DWord);
 function  GetBkColor: DWord;
 procedure SetFillColor(Color: DWord);
 procedure SetFillPattern(Pattern: FillPatternType; Color: DWord);
 procedure SetFillStyle(Pattern: DWord; Color: DWord);
 procedure GetFillPattern(var FillPattern: FillPatternType);
 procedure GetFillSettings(var FillInfo: FillSettingsType);
 function  GetFillColor: DWord;
 procedure SetLineStyle(LineStyle: Word; Pattern: Word; Thickness: Word);
 procedure GetLineSettings(var LineInfo: LineSettingsType);
 function  GetMaxX: DWord;
 function  GetMaxY: DWord;
 function  GetScreenHeight: DWord;
 function  GetScreenWidth: DWord;
 function  GetBitsPerPixel: DWord;
 function  GetBytesPerScanLine: DWord;
 function  GetMaxPossibleY: DWord;
 function  GetMaxPage: DWord;
 procedure SetWriteMode(WriteMode: DWord);
 function  GetWriteMode: DWord;
 procedure SetTranspMode(Mode: Boolean; Color: DWord);
 procedure GetTranspSettings(var Mode: Boolean; var Color: DWord);
 procedure SetAspectRatio(AspectRatio: Real);
 procedure GetAspectRatio(var AspectRatio: Real);
 procedure SetGraphBufSize(BufSize: DWord);
 function  GetGraphBufSize: DWord;

{$ifdef __DOS__}
 procedure Stretch(Param: Byte);
 procedure SetScreenStart(X,Y: DWord; WaitForRetrace: Boolean);
 procedure GetVbeInfo(var VI: VbeInfoType);
 procedure GetVbeModeInfo(ModeNo: Word; var VMI: VbeModeInfoType);
 function  GetVbeVersion: DWord;
 function  GetOemString: String;
 function  GetOemVendorName: String;
 function  GetOemProductName: String;
 function  GetOemProductRev: String;
 function  GetGraphMode: Word;
 function  DetectSVGAMode(XRes,YRes,BPP,VMode: DWord): DWord;
 function  GetVbeCapabilities: DWord;
 function  GetLfbAddress: DWord;
{$endif}
{$ifdef __WIN32__}
 function  GetWindowHandle: THandle;
 function  GetPageDC(PageNo: DWORD): HDC;
 procedure ReleasePageDC(PageNo: DWORD);
{$endif}
 function  TotalVbeModes: DWord;
 procedure GetVbeModesList(var ModesList);
 function  TotalVbeMemory: DWord;
 procedure RestoreCrtMode;
 function  IsLFBUsed: Boolean;
 function  GetScreenPtr: Pointer;
 procedure GraphDefaults;
 procedure SetSVGAMode(XRes,YRes,BPP,VMode: DWord);
 procedure SetGraphMode(VbeMode: Word);
 procedure SetVirtualMode(BuffAddr: Pointer);
 procedure SetNormalMode;
 procedure CloseGraph;
 procedure ClearDevice;

 function  RGBColor(R,G,B: Byte): DWord;
 procedure AnalizeRGB(Color: Dword; var R,G,B: Byte);
 procedure SetRGBPalette(Color,R,G,B: Byte);
 procedure SetPalette(ColorNum: Byte; Color: Word);
 procedure GetRGBPalette(Color: Byte; var R,G,B: Byte);
 procedure GetPalette(var Palette: PaletteType);
 procedure SetAllPalette(var Palette: PaletteType);
 procedure GetDefaultPalette(var Palette: PaletteType);

 procedure ClearPage;
 procedure FlipToScreen(Addr: Pointer);
 procedure FlipToMemory(Addr: Pointer);
 function  GetX: LongInt;
 function  GetY: LongInt;
 procedure PutPixelA(X,Y: LongInt);
 overload  PutPixel = PutPixelA;
 procedure PutPixelB(X,Y: LongInt; Color: DWord);
 overload  PutPixel = PutPixelB;
 function  GetPixel(X,Y: LongInt): DWord;
 procedure DrawHLine(X1,X2,Y: LongInt);
 procedure PutHtextel(X1,X2,Y: LongInt; var Textel);
 procedure GetHtextel(X1,X2,Y: LongInt; var Textel);
 procedure PutSprite(X1,Y1,X2,Y2: LongInt; var Sprite);
 procedure GetSprite(X1,Y1,X2,Y2: LongInt; var Sprite);
 function  ImageSize(X1,Y1,X2,Y2: DWord): DWord;
 procedure InvertImage(var BitMap);
 procedure FlipImageOY(var BitMap);
 procedure FlipImageOX(var BitMap);
 procedure PutImage(X,Y: LongInt; var BitMap);
 procedure GetImage(X,Y,X1,Y1: LongInt; var BitMap);
 procedure LineA(X1,Y1,X2,Y2: LongInt);
 overload  Line = LineA;
 procedure LineB(X1,Y1,X2,Y2: LongInt; Color: DWORD);
 overload  Line = LineB;
 procedure MoveTo(X,Y: LongInt);
 procedure MoveRel(Dx,Dy: LongInt);
 procedure LineTo(X,Y: LongInt);
 procedure LineRel(Dx,Dy: LongInt);
 procedure SetSplineSteps(Steps: DWord);
 procedure Spline(Nodes: Byte; Points: array of PointType);
 procedure RectangleA(X1,Y1,X2,Y2: LongInt);
 overload  Rectangle = RectangleA;
 procedure RectangleB(X1,Y1,X2,Y2: LongInt; Color: DWORD);
 overload  Rectangle = RectangleB;
 procedure Bar(X1,Y1,X2,Y2: LongInt);
 procedure Bar3D(X1,Y1,X2,Y2: LongInt; Depth: Word; Top: Boolean);
 procedure Arc(X,Y: LongInt; StAngle, EndAngle, Radius: DWord);
 procedure Ellipse(X,Y: LongInt; StAngle, EndAngle, XRadius, YRadius: DWord);
 procedure DrawEllipse(X,Y,A,B: LongInt);
 procedure FillEllipse(X,Y,A,B: LongInt);
 procedure CircleA(X, Y: LongInt; Radius: DWord);
 overload  Circle = CircleA;
 procedure CircleB(X, Y: LongInt; Radius, Color: DWord);
 overload  Circle = CircleB;
 procedure FillCircle(X,Y: LongInt; Radius: DWord);
 procedure TriangleA(X1, Y1 ,X2, Y2, X3, Y3: LongInt);
 overload  Triangle = TriangleA;
 procedure TriangleB(X1, Y1 ,X2, Y2, X3, Y3: LongInt; Color: DWORD);
 overload  Triangle = TriangleB;
 procedure FillTriangle(X1,Y1,X2,Y2,X3,Y3: LongInt);
 procedure DrawPoly(NumVert: DWord; var Vert);
 procedure FillPoly(NumVert: DWord; var Vert);
 procedure FloodFill(X,Y: LongInt; Border: DWord);
 procedure ExpandFill(X,Y: LongInt);

 procedure SetCustomFont(AddrPtr: Pointer; Width,Height,Start,Space: DWord);
 procedure SetTextStyle(Font, Direction: DWord);
 procedure SetTextJustify(Horiz, Vert: DWord);
 procedure GetTextSettings(var TextInfo: TextSettingsType);
 procedure OutCharXY(X,Y: LongInt; C: Char; Color: DWord);
 function  TextHeight(TextString: String): DWord;
 function  TextWidth(TextString: String): DWord;
 procedure OutText(TextString: String);
 procedure OutTextXY(X,Y: LongInt; TextString: String);

 procedure Retrace;
 procedure CliRetrace;
 procedure HRetrace;
 procedure CliHRetrace;
{$ifndef __WIN32__}
 procedure SetSplitLine(Line: DWord);
{$endif}

 function  GetDriverName: String;
 function  RegisterBGIDriver(Driver: Pointer): Longint;
 function  RegisterBGIFont(Driver: Pointer): Longint;
 function  InstallUserDriver(Name: String; AutoDetectPtr: Pointer): Longint;
 function  InstallUserFont(FontFileName: String): Longint;
 procedure DetectGraph(var GraphDriver: Integer; var GraphMode: Integer);
 procedure InitGraph(var GraphDriver: Integer; var GraphMode: Integer; Dummy: String);

implementation

{$ifdef __DOS__}
uses DPMI;
{$endif}

{$ifdef __WIN32__}
{$i graphx.inc}
{$endif}

 {$L SMALL.OBJ}
 procedure Small; external;
 {$L MEDIUM.OBJ}
 procedure Medium; external;
 {$L LARGE.OBJ}
 procedure Large; external;

 const
  VbeStatusOk        = $004F;         // Success execute of VBE function
  VbeLinearBuffer    = $4000;         // Enable linear framebuffer mode
  VbeMdAvailable     = $0001;         // Video mode is available
  VbeMdGraphMode     = $0010;         // Mode is a graphics mode
  VbeMdNonVGA        = $0020;         // Mode is not VGA compatible
  VbeMdNonBanked     = $0040;         // Banked mode is not supported
  VbeMdLinear        = $0080;         // Linear mode supported
  vbeMemPL           = $0003;         // 16 color VGA style planar mode
  vbeMemPK           = $0004;         // Packed pixel mode
  vbeMemRGB          = $0006;         // Direct color RGB mode

  { VGA ports }
  GRAC_ADDR= $3CE;  CRTC_ADDR= $3D4;  MISC_ADDR= $3C2; VGAE_ADDR= $3C3;
  SEQU_ADDR= $3C4;  ATTR_ADDR= $3C0;  STAT_ADDR= $3DA;

 const
   isUnsupported = 0;
   isMCGAMode    = 1;
   isSVGAMode    = 2;

   PatternBuffSize   = 256;  // Always must be divisible on 8 and >= 16

{$ifdef __WIN32__}
const
   StandardVbeModes: array [0..303] of DWORD =
   (
 // Standard  8-bit VBE modes
    320,  200,   8, $163,
    320,  240,   8, $164,
    320,  400,   8, $165,
    320,  480,   8, $166,
    400,  300,   8, $14F,
    512,  384,   8, $12D,
    640,  350,   8, $11C,
    640,  400,   8, $100,
    640,  480,   8, $101,
    800,  600,   8, $103,
    1024, 768,   8, $105,
    1152, 864,   8, $156,
    1280, 960,   8, $157,
    1280, 1024,  8, $107,
    1600, 1200,  8, $124,
 // Standard 15-bit VBE modes
    320,  200,  15, $10D,
    320,  240,  15, $12E,
    320,  400,  15, $12F,
    320,  480,  15, $130,
    400,  300,  15, $150,
    512,  384,  15, $135,
    640,  350,  15, $11D,
    640,  400,  15, $11E,
    640,  480,  15, $110,
    800,  600,  15, $113,
    1024, 768,  15, $116,
    1152, 864,  15, $158,
    1280, 960,  15, $159,
    1280, 1024, 15, $119,
    1600, 1200, 15, $125,
 // Standard 16-bit VBE modes
    320,  200,  16, $10E,
    320,  240,  16, $136,
    320,  400,  16, $137,
    320,  480,  16, $138,
    400,  300,  16, $151,
    512,  384,  16, $13D,
    640,  350,  16, $11F,
    640,  400,  16, $120,
    640,  480,  16, $111,
    800,  600,  16, $114,
    1024, 768,  16, $117,
    1152, 864,  16, $15A,
    1280, 960,  16, $15B,
    1280, 1024, 16, $11A,
    1600, 1200, 16, $126,
 // Standard 24-bit VBE modes
    320,  200,  24, $10F,
    320,  240,  24, $13E,
    320,  400,  24, $13F,
    320,  480,  24, $140,
    400,  300,  24, $152,
    512,  384,  24, $145,
    640,  350,  24, $121,
    640,  400,  24, $122,
    640,  480,  24, $112,
    800,  600,  24, $115,
    1024, 768,  24, $118,
    1152, 864,  24, $15C,
    1280, 960,  24, $15D,
    1280, 1024, 24, $11B,
    1600, 1200, 24, $127,
 // Standard 32-bit VBE modes
    320,  200,  32, $146,
    320,  240,  32, $147,
    320,  400,  32, $148,
    320,  480,  32, $149,
    400,  300,  32, $153,
    512,  384,  32, $14E,
    640,  350,  32, $154,
    640,  400,  32, $155,
    640,  480,  32, $128,
    800,  600,  32, $129,
    1024, 768,  32, $12A,
    1152, 864,  32, $15E,
    1280, 960,  32, $15F,
    1280, 1024, 32, $12B,
    1600, 1200, 32, $12C,
    0,    0,    0,  $0
    );
{$endif}

 var GrResult        : LongInt := grInvalidMode;
     MaxPossibleY    : DWord := 0;
     BankTable       : Array [0..255] of Word;
     FlipToScrProc   : Pointer := nil;
     FlipToMemProc   : Pointer := nil;
     BankProc        : DWord := 0;
     PmCode          : Pointer := nil;
     PmCodeSize      : DWord := 0;
     BankFunc        : Pointer := nil;
     ClearPageProc   : Pointer := nil;
     PutPixelProc    : Pointer := nil;
     GetPixelProc    : Pointer := nil;
     PutTextelProc   : Pointer := nil;
     GetTextelProc   : Pointer := nil;
     HLineProc       : Pointer := nil;
     sClearPageProc  : Pointer := nil;
     sPutPixelProc   : Pointer := nil;
     sGetPixelProc   : Pointer := nil;
     sPutTextelProc  : Pointer := nil;
     sGetTextelProc  : Pointer := nil;
     sHLineProc      : Pointer := nil;
     SetStartAddrWR  : Pointer := nil;
     SetStartAddrNW  : Pointer := nil;
     StoreExitProc   : Pointer := nil;
     WndX1,WndY1     : DWord := 0;
     WndX2,WndY2     : DWord := 0;
     AddX,AddY       : LongInt := 0;
     CpX,CpY         : LongInt := 0;
     VirtualMode     : Boolean := FALSE;
     CurViewPort     : ViewPortType;
     GraphColor      : DWord := 15;
     TranspColor     : DWord := 0;
     FillColor       : DWord := 0;
     BkGrColor       : DWord := 0;
     GrLineStyle     : DWord := $FFFFFFFF;
     GrBufferPtr     : Pointer := nil;
     BufferSize      : DWord := 0;
     PixListLen      : DWord := 0;
     GrAspectRatio   : Real := 0;
     GrMaxColor      : DWord := 0;
     TspMode         : Boolean := FALSE;
     VideoMode       : DWord := 0;
     DefaultPal      : PaletteType;
     GrWriteMode     : DWord := 0;
     LineThick       : Word := 0;
     GrLineStl       : Word := 0;
     SplineIterations: DWord := 30;
     LastMode        : Word := 0;
     Chars           : TextSettingsType;
     LfbPtr          : DWord := 0;          // Physical LFB address
     VideoPtr        : DWord := $A0000;
     sVideoPtr       : DWord := $A0000;
     VideoPagePtr    : DWord := $A0000;
     sVideoPagePtr   : DWord := $A0000;
     LfbAddress      : DWord := $00000;     // Linear LFB address
     ScreenPtr       : DWord := $A0000;     // Address of page to flip
     UseLfb          : Boolean := FALSE;
     PhysMaxX        : DWord := 0;
     PhysMaxY        : DWord := 0;
     VpHeight        : DWord := 0;
     VpWidth         : DWord := 0;
     ActivePage      : DWord := 0;
     VisualPage      : DWord := 0;
     BitsPerPixel    : Word := 0;
     BytesPerPixel   : DWord := 0;
     MaxPage         : Word := 0;
     PageSize        : DWord := 0;
     BytesPerLine    : DWord := 0;
     BankOffset      : DWord := 0;
     OriginOffset    : Word := 0;
     sBankOffset     : DWord := 0;
     sOriginOffset   : Word := 0;
     CurBank         : Word := 0;
     VbeVer          : Word := 0;
     TotalMem        : DWord := 0;
     VbeCap          : DWord := 0;
     OemString       : String := '';
     OemVendor       : String := '';
     OemProduct      : String := '';
     OemProductRev   : String := '';
     VbeModesList    : Array[0..MaxVbeModes] of GraphModeType;
     VbeModes        : DWord := 0;
     PossibleMaxPage : Word := 0;
     UseSolidFill    : Boolean  :=  TRUE;

{$ifdef __WIN32__}
     GraphActive: Boolean :=  FALSE;
     OldMouseX, OldMouseY: DWORD :=  0;
     DirectXWnd: THandle :=  0;
     DirectXWndRegistered: Boolean := FALSE;
     TmpScr1, TmpScr2: Pointer := nil;
     WndRestored: Boolean := TRUE;
     DirectXEnabled: Boolean;
     DD_VideoMem: DWORD := 0;
     DD_CurrentPage: DWORD := 0;
     DD_CurrentPal: PaletteType;
     DD_PrimPtr: Pointer;
     DD_BackPtr: Pointer;
     DD_Palette: THandle := 0;
     DD_SurfaceDesc1: TDDSurfaceDesc;
     DD_SurfaceDesc2: TDDSurfaceDesc;
     DD_SurfaceDesc3: TDDSurfaceDesc;
     DD_SCaps: TDDSCaps;
     DirectDraw1: PPDirectDraw;
     DirectDraw2: PPDirectDraw2;
     lpprim: PPDirectDrawSurface;
     lpback: PPDirectDrawSurface;
     PrimDC: hDC;
     BackDC: hDC;
     DD_ModeCnt: Longint := 0;
     lplpDDPalette: PPDirectDrawPalette;
     GraphModesList: Array[0..MaxVbeModes] of GraphModeType;
     UseDirectDraw5: Boolean;  // TRUE if DirectDraw 5 or higher is installed
{$endif}

     CurrentPattern  : array [1..8] of Pointer;
     UsedPatternNo   : DWord;

{$ifdef __WIN32__}
const
  DefaultPalette: array [0..1025] of Byte =
  (01, 00, 00, 00, 00, 00, 42, 00, 00, 00, 00, 42, 00, 00, 42, 42,
   00, 00, 00, 00, 42, 00, 42, 00, 42, 00, 00, 21, 42, 00, 42, 42,
   42, 00, 21, 21, 21, 00, 63, 21, 21, 00, 21, 63, 21, 00, 63, 63,
   21, 00, 21, 21, 63, 00, 63, 21, 63, 00, 21, 63, 63, 00, 63, 63,
   63, 00, 00, 00, 00, 00, 05, 05, 05, 00, 08, 08, 08, 00, 11, 11,
   11, 00, 14, 14, 14, 00, 17, 17, 17, 00, 20, 20, 20, 00, 24, 24,
   24, 00, 28, 28, 28, 00, 32, 32, 32, 00, 36, 36, 36, 00, 40, 40,
   40, 00, 45, 45, 45, 00, 50, 50, 50, 00, 56, 56, 56, 00, 63, 63,
   63, 00, 63, 00, 00, 00, 63, 00, 16, 00, 63, 00, 31, 00, 63, 00,
   47, 00, 63, 00, 63, 00, 47, 00, 63, 00, 31, 00, 63, 00, 16, 00,
   63, 00, 00, 00, 63, 00, 00, 16, 63, 00, 00, 31, 63, 00, 00, 47,
   63, 00, 00, 63, 63, 00, 00, 63, 47, 00, 00, 63, 31, 00, 00, 63,
   16, 00, 00, 63, 00, 00, 16, 63, 00, 00, 31, 63, 00, 00, 47, 63,
   00, 00, 63, 63, 00, 00, 63, 47, 00, 00, 63, 31, 00, 00, 63, 16,
   00, 00, 63, 31, 31, 00, 63, 31, 39, 00, 63, 31, 47, 00, 63, 31,
   55, 00, 63, 31, 63, 00, 55, 31, 63, 00, 47, 31, 63, 00, 39, 31,
   63, 00, 31, 31, 63, 00, 31, 39, 63, 00, 31, 47, 63, 00, 31, 55,
   63, 00, 31, 63, 63, 00, 31, 63, 55, 00, 31, 63, 47, 00, 31, 63,
   39, 00, 31, 63, 31, 00, 39, 63, 31, 00, 47, 63, 31, 00, 55, 63,
   31, 00, 63, 63, 31, 00, 63, 55, 31, 00, 63, 47, 31, 00, 63, 39,
   31, 00, 63, 45, 45, 00, 63, 45, 49, 00, 63, 45, 54, 00, 63, 45,
   58, 00, 63, 45, 63, 00, 58, 45, 63, 00, 54, 45, 63, 00, 49, 45,
   63, 00, 45, 45, 63, 00, 45, 49, 63, 00, 45, 54, 63, 00, 45, 58,
   63, 00, 45, 63, 63, 00, 45, 63, 58, 00, 45, 63, 54, 00, 45, 63,
   49, 00, 45, 63, 45, 00, 49, 63, 45, 00, 54, 63, 45, 00, 58, 63,
   45, 00, 63, 63, 45, 00, 63, 58, 45, 00, 63, 54, 45, 00, 63, 49,
   45, 00, 28, 00, 00, 00, 28, 00, 07, 00, 28, 00, 14, 00, 28, 00,
   21, 00, 28, 00, 28, 00, 21, 00, 28, 00, 14, 00, 28, 00, 07, 00,
   28, 00, 00, 00, 28, 00, 00, 07, 28, 00, 00, 14, 28, 00, 00, 21,
   28, 00, 00, 28, 28, 00, 00, 28, 21, 00, 00, 28, 14, 00, 00, 28,
   07, 00, 00, 28, 00, 00, 07, 28, 00, 00, 14, 28, 00, 00, 21, 28,
   00, 00, 28, 28, 00, 00, 28, 21, 00, 00, 28, 14, 00, 00, 28, 07,
   00, 00, 28, 14, 14, 00, 28, 14, 17, 00, 28, 14, 21, 00, 28, 14,
   24, 00, 28, 14, 28, 00, 24, 14, 28, 00, 21, 14, 28, 00, 17, 14,
   28, 00, 14, 14, 28, 00, 14, 17, 28, 00, 14, 21, 28, 00, 14, 24,
   28, 00, 14, 28, 28, 00, 14, 28, 24, 00, 14, 28, 21, 00, 14, 28,
   17, 00, 14, 28, 14, 00, 17, 28, 14, 00, 21, 28, 14, 00, 24, 28,
   14, 00, 28, 28, 14, 00, 28, 24, 14, 00, 28, 21, 14, 00, 28, 17,
   14, 00, 28, 20, 20, 00, 28, 20, 22, 00, 28, 20, 24, 00, 28, 20,
   26, 00, 28, 20, 28, 00, 26, 20, 28, 00, 24, 20, 28, 00, 22, 20,
   28, 00, 20, 20, 28, 00, 20, 22, 28, 00, 20, 24, 28, 00, 20, 26,
   28, 00, 20, 28, 28, 00, 20, 28, 26, 00, 20, 28, 24, 00, 20, 28,
   22, 00, 20, 28, 20, 00, 22, 28, 20, 00, 24, 28, 20, 00, 26, 28,
   20, 00, 28, 28, 20, 00, 28, 26, 20, 00, 28, 24, 20, 00, 28, 22,
   20, 00, 16, 00, 00, 00, 16, 00, 04, 00, 16, 00, 08, 00, 16, 00,
   12, 00, 16, 00, 16, 00, 12, 00, 16, 00, 08, 00, 16, 00, 04, 00,
   16, 00, 00, 00, 16, 00, 00, 04, 16, 00, 00, 08, 16, 00, 00, 12,
   16, 00, 00, 16, 16, 00, 00, 16, 12, 00, 00, 16, 08, 00, 00, 16,
   04, 00, 00, 16, 00, 00, 04, 16, 00, 00, 08, 16, 00, 00, 12, 16,
   00, 00, 16, 16, 00, 00, 16, 12, 00, 00, 16, 08, 00, 00, 16, 04,
   00, 00, 16, 08, 08, 00, 16, 08, 10, 00, 16, 08, 12, 00, 16, 08,
   14, 00, 16, 08, 16, 00, 14, 08, 16, 00, 12, 08, 16, 00, 10, 08,
   16, 00, 08, 08, 16, 00, 08, 10, 16, 00, 08, 12, 16, 00, 08, 14,
   16, 00, 08, 16, 16, 00, 08, 16, 14, 00, 08, 16, 12, 00, 08, 16,
   10, 00, 08, 16, 08, 00, 10, 16, 08, 00, 12, 16, 08, 00, 14, 16,
   08, 00, 16, 16, 08, 00, 16, 14, 08, 00, 16, 12, 08, 00, 16, 10,
   08, 00, 16, 11, 11, 00, 16, 11, 12, 00, 16, 11, 13, 00, 16, 11,
   15, 00, 16, 11, 16, 00, 15, 11, 16, 00, 13, 11, 16, 00, 12, 11,
   16, 00, 11, 11, 16, 00, 11, 12, 16, 00, 11, 13, 16, 00, 11, 15,
   16, 00, 11, 16, 16, 00, 11, 16, 15, 00, 11, 16, 13, 00, 11, 16,
   12, 00, 11, 16, 11, 00, 12, 16, 11, 00, 13, 16, 11, 00, 15, 16,
   11, 00, 16, 16, 11, 00, 16, 15, 11, 00, 16, 13, 11, 00, 16, 12,
   11, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00,
   00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00,
   00, 00);
{$endif}

const
  SysFillPattern: array[0..12] of FillPatternType = (
      ($00,$00,$00,$00,$00,$00,$00,$00),
      ($FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF),
      ($FF,$FF,$00,$00,$FF,$FF,$00,$00),
      ($01,$02,$04,$08,$10,$20,$40,$80),
      ($07,$0E,$1C,$38,$70,$E0,$C1,$83),
      ($07,$83,$C1,$E0,$70,$38,$1C,$0E),
      ($5A,$2D,$96,$4B,$A5,$D2,$69,$B4),
      ($FF,$88,$88,$88,$FF,$88,$88,$88),
      ($18,$24,$42,$81,$81,$42,$24,$18),
      ($CC,$33,$CC,$33,$CC,$33,$CC,$33),
      ($80,$00,$08,$00,$80,$00,$08,$00),
      ($88,$00,$22,$00,$88,$00,$22,$00),
      ($00,$00,$00,$00,$00,$00,$00,$00)
     );

///////////////////////////////////////////////////////////////////////////
// <<<<<<<<<<<<    PRIVATE LOW LEVEL GRAPHIC SECTION    >>>>>>>>>>>>>>>> //
///////////////////////////////////////////////////////////////////////////

function ConvertMask(Mask: DWORD): DWORD;
begin
  if Mask <> 0 then
  begin
    while (Mask and 1) <> 1 do
      Mask  :=  Mask shr 1;
  end;
  Result  :=  Mask;
end;

function GetMaskPos(Mask: DWORD): DWORD;
begin
  Result  :=  0;
  if Mask <> 0 then
  begin
    while (Mask and 1) <> 1 do
    begin
      Mask  :=  Mask shr 1;
      inc(Result);
    end;
  end;
end;

function GetAdjustFactor(Mask: DWORD): DWORD;
var
  Res, i: DWORD;
begin
  Res  :=  0;
  if Mask <> 0 then
  begin
    for i  :=  0 to 32 do
    begin
      if (Mask and 1) = 1 then inc(Res);
      Mask  :=  Mask shr 1;
    end;
  end;
  Result  :=  8 - Res;
end;

{$ifdef __WIN32__}

function DD_SetDisplayMode(Handle: hWnd; XRes, YRes, ColorDepth: DWord): Boolean;
var
  ExitLoop: Boolean;
  DDResult: HResult;
begin
  // Determine the top-level behavior of the application
  if DirectDraw1^^.SetCooperativeLevel(DirectDraw1, Handle, DDSCL_EXCLUSIVE or DDSCL_FULLSCREEN) <> DD_OK then
  begin
    Result := FALSE;
    exit;
  end;

  // Set the mode of the display-device hardware

  if UseDirectDraw5 then
  begin
    if DirectDraw2^^.SetDisplayMode(DirectDraw2, XRes, YRes, ColorDepth, 0, DDSDM_STANDARDVGAMODE) <> DD_OK then
    begin
      Result := FALSE;
      exit;
    end;
  end else
  begin
    if DirectDraw1^^.SetDisplayMode(DirectDraw1, XRes, YRes, ColorDepth) <> DD_OK then
    begin
      Result := FALSE;
      exit;
    end;
  end;

  // Initialize DD_SurfaceDesc1 fields
  DD_SurfaceDesc1.dwSize := sizeof(DD_SurfaceDesc1);
  DD_SurfaceDesc1.dwFlags:=DDSD_CAPS or DDSD_BACKBUFFERCOUNT;
  DD_SurfaceDesc1.ddsCaps.dwCaps := ddscaps_PRIMARYSURFACE or ddscaps_FLIP or ddscaps_COMPLEX;
  // One back buffer to be allocated
  DD_SurfaceDesc1.dwBackBufferCount := 1;

  // Create a DirectDrawSurface object for the DirectDraw object

  if UseDirectDraw5 then
  begin
    if DirectDraw2^^.CreateSurface(DirectDraw2, DD_SurfaceDesc1, lpprim, nil) <> DD_OK then
    begin
      Result := FALSE;
      exit;
    end;
  end else
  begin
    if DirectDraw1^^.CreateSurface(DirectDraw1, DD_SurfaceDesc1, lpprim, nil) <> DD_OK then
    begin
      Result := FALSE;
      exit;
    end;
  end;

  // Obtain the attached backbuffer surface for the
  DD_SCaps.dwCaps := ddscaps_BACKBUFFER;
  if lpprim^^.GetAttachedSurface(lpprim, DD_SCaps, lpBack) <> DD_OK then
  begin
    Result := FALSE;
    exit;
  end;

  // Obtain a direct pointer to the primary surface
  FillChar(DD_SurfaceDesc2, SizeOf(DD_SurfaceDesc2), 0);
  DD_SurfaceDesc2.dwSize := SizeOf(TDDSurfaceDesc);
  ExitLoop := FALSE;
  repeat
    DDResult := Lpprim^^.Lock(Lpprim, PRect(nil), DD_SurfaceDesc2, DDLOCK_SURFACEMEMORYPTR, 0);
    if DDResult = DDERR_SURFACELOST then
      lpprim^^.Restore(lpprim)
    else
      ExitLoop := TRUE;
  until ExitLoop;
  if DDResult <> DD_OK then
  begin
    Result := FALSE;
    exit;
  end;
  Lpprim^^.UnLock(Lpprim, DD_SurfaceDesc2.lpSurface);
  DD_PrimPtr := DD_SurfaceDesc2.lpSurface;

  // Obtain a direct pointer to the secondary surface
  FillChar(DD_SurfaceDesc3, SizeOf(DD_SurfaceDesc3), 0);
  DD_SurfaceDesc3.dwSize := SizeOf(TDDSurfaceDesc);
  ExitLoop := FALSE;
  repeat
    DDResult := LpBack^^.Lock(LpBack, PRect(nil), DD_SurfaceDesc3, DDLOCK_SURFACEMEMORYPTR, 0);
    if DDResult = DDERR_SURFACELOST then
      LpBack^^.Restore(LpBack)
    else
      ExitLoop := TRUE;
  until ExitLoop;
  if DDResult <> DD_OK then
  begin
    Result := FALSE;
    exit;
  end;
  LpBack^^.UnLock(LpBack, DD_SurfaceDesc3.lpSurface);
  DD_BackPtr := DD_SurfaceDesc3.lpSurface;

  // Fill mode-depended constants
  BytesPerLine := DD_SurfaceDesc2.lPitch;

  DcRedMask      :=  ConvertMask(DD_SurfaceDesc2.ddpfPixelFormat.dwRBitMask);
  DcRedPos       :=  GetMaskPos(DD_SurfaceDesc2.ddpfPixelFormat.dwRBitMask);
  DcRedAdjust    :=  GetAdjustFactor(DD_SurfaceDesc2.ddpfPixelFormat.dwRBitMask);

  DcGreenMask    :=  ConvertMask(DD_SurfaceDesc2.ddpfPixelFormat.dwGBitMask);
  DcGreenPos     :=  GetMaskPos(DD_SurfaceDesc2.ddpfPixelFormat.dwGBitMask);
  DcGreenAdjust  :=  GetAdjustFactor(DD_SurfaceDesc2.ddpfPixelFormat.dwGBitMask);

  DcBlueMask     :=  ConvertMask(DD_SurfaceDesc2.ddpfPixelFormat.dwBBitMask);
  DcBluePos      :=  GetMaskPos(DD_SurfaceDesc2.ddpfPixelFormat.dwBBitMask);
  DcBlueAdjust   :=  GetAdjustFactor(DD_SurfaceDesc2.ddpfPixelFormat.dwBBitMask);

  Move(DefaultPalette, DD_CurrentPal, 1026);
  Result := true;
end;

function DD_Init: Boolean;
var
  Temp, Dummy: DWORD;
begin
  // Create an instance of a DirectDraw object
  if DirectDrawCreate(nil, DirectDraw1, nil) = DD_Ok then
  begin
    // Create an instance of a DirectDraw object
    UseDirectDraw5 := DirectDraw1^^.QueryInterface(DirectDraw1, IID_IDirectDraw2, DirectDraw2) = S_OK;

    // Retrieve the total amount of display memory available
    DD_SCaps.dwCaps := DDSCAPS_VIDEOMEMORY;

    if UseDirectDraw5 then
    begin
      if DirectDraw2^^.GetAvailableVidMem(DirectDraw2, DD_SCaps, Temp, Dummy) = DD_OK then
        DD_VideoMem := Temp
      else
        DD_VideoMem := 0;
    end
    else
      DD_VideoMem := 0;
    Result := TRUE;
  end else
    Result := FALSE;
end;

procedure DD_Done;
begin
  if PrimDC <> 0 then LpPrim^^.ReleaseDC(LpPrim, PrimDC);
  if BackDC <> 0 then LpBack^^.ReleaseDC(LpBack, BackDC);
  if DD_Palette <> 0 then lplpDDPalette^^.Release(lplpDDPalette);
  if lpprim <> nil then lpprim^^.Release(lpprim);
  if UseDirectDraw5 and (DirectDraw2 <> nil) then DirectDraw2^^.Release(DirectDraw2);
  if DirectDraw1 <> nil then DirectDraw1^^.Release(DirectDraw1);
end;

function ModeCallback conv arg_stdcall (const lpDDSurfaceDesc: TDDSurfaceDesc;
  lpContext: Pointer): HResult;
var
  i, v: DWORD;
begin
  GraphModesList[DD_ModeCnt].XResolution  := lpDDSurfaceDesc.dwWidth;
  GraphModesList[DD_ModeCnt].YResolution  := lpDDSurfaceDesc.dwHeight;
  GraphModesList[DD_ModeCnt].BitsPerPixel := lpDDSurfaceDesc.ddpfPixelFormat.dwRGBBitCount;
  GraphModesList[DD_ModeCnt].VideoMode    := $FFFF;
  GraphModesList[DD_ModeCnt].HaveLfb      := TRUE;

  for i := 0 to (304 div 4) - 1 do
  begin

    if not UseDirectDraw5 or (DD_VideoMem = 0) then
    begin
      v := GraphModesList[DD_ModeCnt].XResolution * GraphModesList[DD_ModeCnt].YResolution * GraphModesList[DD_ModeCnt].BitsPerPixel;
      if DD_VideoMem < v then DD_VideoMem := v;
    end;

    if (GraphModesList[DD_ModeCnt].XResolution  = StandardVbeModes[i * 4 + 0]) and
       (GraphModesList[DD_ModeCnt].YResolution  = StandardVbeModes[i * 4 + 1]) and
       (GraphModesList[DD_ModeCnt].BitsPerPixel = StandardVbeModes[i * 4 + 2])
    then
       GraphModesList[DD_ModeCnt].VideoMode := StandardVbeModes[i * 4 + 3]
  end;
  inc(DD_ModeCnt);
  Result := S_FALSE;
end;

procedure EnumDisplayModes;
begin
  DD_ModeCnt := 0;
  if UseDirectDraw5 then
    DirectDraw2^^.EnumDisplayModes(DirectDraw2, DDEDM_STANDARDVGAMODES, nil, nil, ModeCallback)
  else
    DirectDraw1^^.EnumDisplayModes(DirectDraw1, DDEDM_STANDARDVGAMODES, nil, nil, ModeCallback);
end;


function DD_SetPalette(Palette: Pointer): Boolean;
var
  palEntries: array [0..255] of TPaletteEntry;
  i: DWORD;
begin
  inc(DWORD(Palette), 2);
  for i := 0 to 255 do
  begin
    palEntries[i].peBlue := Byte(Palette^) shl 2;
    inc(DWORD(Palette));
    palEntries[i].peGreen := Byte(Palette^) shl 2;
    inc(DWORD(Palette));
    palEntries[i].peRed := Byte(Palette^) shl 2;
    inc(DWORD(Palette), 2);
  end;
  if DD_Palette <> 0 then lplpDDPalette^^.Release(lplpDDPalette);

  if UseDirectDraw5 then
    DD_Palette := DirectDraw2^^.CreatePalette(DirectDraw2, DDPCAPS_8BIT, @palEntries, lplpDDPalette, nil)
  else
    DD_Palette := DirectDraw1^^.CreatePalette(DirectDraw1, DDPCAPS_8BIT, @palEntries, lplpDDPalette, nil);

  if DD_Palette = DD_OK then
  begin
    Result := (lpprim^^.SetPalette(lpprim, lplpDDPalette)) +
              (lpprim^^.SetPalette(lpprim, lplpDDPalette)) = 0;
  end else
    Result := FALSE;
end;
{$endif}

procedure ClearBanked; code;
      asm
        cld
        mov     edx,[BankOffset]
        cmp     dx,[CurBank]
        jz      @@Next1
        call    [BankFunc]
@@Next1:
        xor     ebx,ebx
        movzx   edi,[OriginOffset]
        or      edi,edi
        jz      @@Skip1
        mov     ecx,edi
        xor     cx,0FFFFh
        mov     ebx,ecx
        push    ecx
        and     ecx,3
        inc     ecx
        add     edi,[VideoPtr]
        rep     stosb
        pop     ecx
        shr     ecx,2
        ALIGN   4
        rep     stosd
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
@@Skip1:
        mov     ecx,[PageSize]
        sub     ecx,ebx
        sub     ecx,1
        push    ecx
        shr     ecx,16
        cmp     ecx,0
        je      @@Skip2
        ALIGN   4
@@Loop: push    ecx
        mov     edi,[VideoPtr]
        mov     ecx,16384
        ALIGN   4
        rep     stosd
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        pop     ecx
        loop    @@Loop
@@Skip2:
        pop     ecx
        and     ecx,0FFFFh
        mov     edi,[VideoPtr]
        shr     ecx,2
        inc     ecx
        ALIGN   4
        rep     stosd
        ret
end;

procedure ClearLinear; code;
      asm
        cld
        mov     edi,[VideoPagePtr]
        mov     ecx,[PageSize]
        shr     ecx,2
        ALIGN   4
        rep     stosd
        ret
end;

procedure FlipToScreenBanked; code;
      asm
        cld
        mov     edx,[BankOffset]
        cmp     dx,[CurBank]
        jz      @@Next1
        call    [BankFunc]
@@Next1:
        xor     ebx,ebx
        movzx   edi,[OriginOffset]
        or      edi,edi
        jz      @@Skip1
        mov     ecx,edi
        xor     cx,0FFFFh
        mov     ebx,ecx
        push    ecx
        and     ecx,3
        inc     ecx
        add     edi,[ScreenPtr]
        rep     movsb
        pop     ecx
        shr     ecx,2
        ALIGN   4
        rep     movsd
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
@@Skip1:
        mov     ecx,[PageSize]
        sub     ecx,ebx
        sub     ecx,1
        push    ecx
        shr     ecx,16
        cmp     ecx,0
        je      @@Skip2
        ALIGN   4
@@Loop: push    ecx
        mov     edi,[ScreenPtr]
        mov     ecx,16384
        ALIGN   4
        rep     movsd
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        pop     ecx
        loop    @@Loop
@@Skip2:
        pop     ecx
        and     ecx,0FFFFh
        mov     edi,[ScreenPtr]
        shr     ecx,2
        inc     ecx
        ALIGN   4
        rep     movsd
        ret
end;

procedure FlipToMemoryBanked; code;
      asm
        cld
        mov     edx,[BankOffset]
        cmp     dx,[CurBank]
        jz      @@Next1
        call    [BankFunc]
@@Next1:
        xor     ebx,ebx
        movzx   esi,[OriginOffset]
        or      esi,esi
        jz      @@Skip1
        mov     ecx,esi
        xor     cx,0FFFFh
        mov     ebx,ecx
        push    ecx
        and     ecx,3
        inc     ecx
        add     esi,[ScreenPtr]
        rep     movsb
        pop     ecx
        shr     ecx,2
        ALIGN   4
        rep     movsd
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
@@Skip1:
        mov     ecx,[PageSize]
        sub     ecx,ebx
        sub     ecx,1
        push    ecx
        shr     ecx,16
        cmp     ecx,0
        je      @@Skip2
        ALIGN   4
@@Loop: push    ecx
        mov     esi,[ScreenPtr]
        mov     ecx,16384
        ALIGN   4
        rep     movsd
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        pop     ecx
        loop    @@Loop
@@Skip2:
        pop     ecx
        and     ecx,0FFFFh
        mov     esi,[ScreenPtr]
        shr     ecx,2
        inc     ecx
        ALIGN   4
        rep     movsd
        ret
end;

procedure FlipToScreenLin; code;
      asm
        cld
        mov     edi,[ScreenPtr]
        mov     ecx,[PageSize]
        shr     ecx,2
        ALIGN   4
        rep     movsd
        ret
end;

procedure FlipToMemoryLin; code;
      asm
        cld
        mov     esi,[ScreenPtr]
        mov     ecx,[PageSize]
        shr     ecx,2
        ALIGN   4
        rep     movsd
        ret
end;

procedure FlipToScreen (Addr: Pointer);
assembler;
      asm
        mov     esi,[Addr]
        call    dword ptr [FlipToScrProc]
end;

procedure FlipToMemory (Addr: Pointer);
assembler;
      asm
        mov     edi,[Addr]
        call    dword ptr [FlipToMemProc]
end;

////////////////////////////////////////////////////////////////////////////
// Clear256
////////////////////////////////////////////////////////////////////////////
// Routine to clear the screen. Assumes pages begin on bank boundaries
// for simplicity of coding.
////////////////////////////////////////////////////////////////////////////
procedure ClearPage256Bnk;
assembler;
      asm
        mov     al,byte ptr [BkGrColor]
        mov     ah,al
        mov     edx,eax
        shl     eax,16
        mov     ax,dx
        call    ClearBanked
end;

////////////////////////////////////////////////////////////////////////////
// Clear256
////////////////////////////////////////////////////////////////////////////
// Routine to clear the screen. Assumes pages begin on bank boundaries
// for simplicity of coding.
////////////////////////////////////////////////////////////////////////////
procedure ClearPage256Lin;
assembler;
      asm
        mov     al,byte ptr [BkGrColor]
        mov     ah,al
        mov     edx,eax
        shl     eax,16
        mov     ax,dx
        call    ClearLinear
end;

procedure ClearPage32kBnk;
assembler;
      asm
        mov     ax,word ptr [BkGrColor]
        mov     edx,eax
        shl     eax,16
        mov     ax,dx
        call    ClearBanked
end;

procedure ClearPage32kLin;
assembler;
      asm
        mov     ax,word ptr [BkGrColor]
        mov     edx,eax
        shl     eax,16
        mov     ax,dx
        call    ClearLinear
end;

////////////////////////////////////////////////////////////////////////////
// Clear16M
////////////////////////////////////////////////////////////////////////////
// Routine to clear the screen. Assumes pages begin on bank boundaries
// for simplicity of coding.
////////////////////////////////////////////////////////////////////////////
procedure ClearPage16mBnk;
assembler;
var
  ScanLineAdjast: Word;
      asm
        mov     eax,[BkGrColor]
        or      eax,eax
        jnz     @@SlowClear
        call    ClearBanked
        jmp     @@Quit
@@SlowClear:
        mov     ebx,[VideoPtr]
        add     bx,[OriginOffset]
        mov     edi,[VpWidth]
        mov     esi,[VpHeight]
        mov     edx,edi
        shl     edx,1
        add     edx,edi
        sub     edx,[BytesPerLine]
        neg     dx
        mov     [ScanLineAdjast],dx
        mov     edx,[BankOffset]
        cmp     dx,[CurBank]
        jz      @@NoChange
        call    [BankFunc]
@@NoChange:
        mov     dh,byte ptr [BkGrColor+2]
@@NextScanLine:
        mov     ecx,edi
        ALIGN   4
@@LoopSolid:
        cmp     bx,0FFFDh
        jae     @@BankSwitch
        mov     [ebx],ax
        mov     [ebx+2],dh
        add     ebx,3
        loop    @@LoopSolid
@@AfterPlot:
        add     bx,[ScanLineAdjast]
        jc      @@BankSwitch2
        dec     esi
        jnz     @@NextScanLine
        jmp     @@Quit
@@BankSwitch:
        jne     @@Next5
        mov     [ebx],ax
        mov     [ebx+2],dh
        xor     bx,bx
        inc     dl
        call    [BankFunc]
        loop    @@LoopSolid
        jmp     @@AfterPlot
@@Next5:
        cmp     bx,0FFFEh
        jne     @@Next4
        mov     [ebx],ax
        inc     dl
        call    [BankFunc]
        xor     bx,bx
        mov     [ebx],dh
        inc     ebx
        loop    @@LoopSolid
        jmp     @@AfterPlot
@@Next4:
        mov     [ebx],al
        inc     dl
        call    [BankFunc]
        xor     bx,bx
        mov     [ebx],ah
        mov     [ebx+1],dh
        add     ebx,2
        loop    @@LoopSolid
        jmp     @@AfterPlot
@@BankSwitch2:
        inc     dl
        xor     bx,bx
        call    [BankFunc]
        dec     esi
        jnz     @@NextScanLine
@@Quit:
end;

procedure ClearPage16mLin;
assembler;
var
  ScanLineAdjust: DWord;
      asm
        mov     eax,[BkGrColor]
        or      eax,eax
        jnz     @@SlowClear
        call    ClearLinear
        jmp     @@Quit
@@SlowClear:
        cld
        mov     ebx,[VideoPagePtr]
        mov     edi,[VpWidth]
        mov     esi,[VpHeight]
        mov     edx,edi
        shl     edx,1
        add     edx,edi
        sub     edx,[BytesPerLine]
        neg     edx
        mov     [ScanLineAdjust],edx
        mov     dh,byte ptr [BkGrColor+2]
@@NextScanLine:
        mov     ecx,edi
        ALIGN   4
@@LoopSolid:
        mov     [ebx],ax
        mov     [ebx+2],dh
        add     ebx,3
        loop    @@LoopSolid
@@AfterPlot:
        add     ebx,[ScanLineAdjust]
        dec     esi
        jnz     @@NextScanLine
@@Quit:
end;

procedure ClearPage4GBnk;
assembler;
      asm
        mov     eax,[BkGrColor]
        call    ClearBanked
end;

procedure ClearPage4GLin;
assembler;
      asm
        mov     eax,[BkGrColor]
        call    ClearLinear
end;

procedure PutHtextelBnk;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     dx
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@Pass
        call    [BankFunc]
@@Pass: cld
        mov     edi,ebx
        add     edi,[VideoPtr]
        add     bx,cx
        jnc     @@Novf
        push    ecx
        mov     cx,di
        not     cx
        inc     ecx
        mov     ebx,ecx
        mov     edx,ecx
        and     ecx,3
        rep     movsb
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     movsd
        pop     ecx
        sub     ecx,ebx
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        sub     edi,10000h
        mov     edx,ecx
        and     ecx,3
        rep     movsb
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     movsd
        ret
@@Novf: mov     edx,ecx
        and     ecx,3
        rep     movsb
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     movsd
        ret
end;

procedure XORHtextelBnk;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     dx
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@Pass
        call    [BankFunc]
@@Pass: cld
        mov     edi,ebx
        add     edi,[VideoPtr]
        add     bx,cx
        jnc     @@Novf
        push    ecx
        mov     cx,di
        not     cx
        inc     ecx
        mov     ebx,ecx
        mov     edx,ecx
        and     ecx,3
        jz      @@Pass1
        ALIGN   4
@@Loop1:
        lodsb
        xor     [edi],al
        inc     edi
        loop    @@Loop1
@@Pass1:
        mov     ecx,edx
        shr     ecx,2
        or      ecx,0
        jz      @@Pass2
        ALIGN   4
@@Loop2:
        lodsd
        xor     [edi],eax
        add     edi,4
        loop    @@Loop2
@@Pass2:
        pop     ecx
        sub     ecx,ebx
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        sub     edi,10000h
        mov     edx,ecx
        and     ecx,3
        jz      @@Pass3
        ALIGN   4
@@Loop3:
        lodsb
        xor     [edi],al
        inc     edi
        loop    @@Loop3
@@Pass3:
        mov     ecx,edx
        shr     ecx,2
        or      ecx,0
        jz      @@Pass4
        ALIGN   4
@@Loop4:
        lodsd
        xor     [edi],eax
        add     edi,4
        loop    @@Loop4
@@Pass4:
        ret
@@Novf: mov     edx,ecx
        and     ecx,3
        jz      @@Pass5
        ALIGN   4
@@Loop5:
        lodsb
        xor     [edi],al
        inc     edi
        loop    @@Loop5
@@Pass5:
        mov     ecx,edx
        shr     ecx,2
        or      ecx,0
        jz      @@Pass6
        ALIGN   4
@@Loop6:
        lodsd
        xor     [edi],eax
        add     edi,4
        loop    @@Loop6
@@Pass6:
        ret
end;

procedure ORHtextelBnk;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     dx
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@Pass
        call    [BankFunc]
@@Pass: cld
        mov     edi,ebx
        add     edi,[VideoPtr]
        add     bx,cx
        jnc     @@Novf
        push    ecx
        mov     cx,di
        not     cx
        inc     ecx
        mov     ebx,ecx
        mov     edx,ecx
        and     ecx,3
        jz      @@Pass1
        ALIGN   4
@@Loop1:
        lodsb
        or      [edi],al
        inc     edi
        loop    @@Loop1
@@Pass1:
        mov     ecx,edx
        shr     ecx,2
        or      ecx,0
        jz      @@Pass2
        ALIGN   4
@@Loop2:
        lodsd
        or      [edi],eax
        add     edi,4
        loop    @@Loop2
@@Pass2:
        pop     ecx
        sub     ecx,ebx
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        sub     edi,10000h
        mov     edx,ecx
        and     ecx,3
        jz      @@Pass3
        ALIGN   4
@@Loop3:
        lodsb
        or      [edi],al
        inc     edi
        loop    @@Loop3
@@Pass3:
        mov     ecx,edx
        shr     ecx,2
        xor     ecx,0
        jz      @@Pass4
        ALIGN   4
@@Loop4:
        lodsd
        or      [edi],eax
        add     edi,4
        loop    @@Loop4
@@Pass4:
        ret
@@Novf: mov     edx,ecx
        and     ecx,3
        jz      @@Pass5
        ALIGN   4
@@Loop5:
        lodsb
        or      [edi],al
        inc     edi
        loop    @@Loop5
@@Pass5:
        mov     ecx,edx
        shr     ecx,2
        xor     ecx,0
        jz      @@Pass6
        ALIGN   4
@@Loop6:
        lodsd
        or      [edi],eax
        add     edi,4
        loop    @@Loop6
@@Pass6:
        ret
end;

procedure ANDHtextelBnk;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     dx
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@Pass
        call    [BankFunc]
@@Pass: cld
        mov     edi,ebx
        add     edi,[VideoPtr]
        add     bx,cx
        jnc     @@Novf
        push    ecx
        mov     cx,di
        not     cx
        inc     ecx
        mov     ebx,ecx
        mov     edx,ecx
        and     ecx,3
        jz      @@Pass1
        ALIGN   4
@@Loop1:
        lodsb
        and     [edi],al
        inc     edi
        loop    @@Loop1
@@Pass1:
        mov     ecx,edx
        shr     ecx,2
        xor     ecx,0
        jz      @@Pass2
        ALIGN   4
@@Loop2:
        lodsd
        and     [edi],eax
        add     edi,4
        loop    @@Loop2
@@Pass2:
        pop     ecx
        sub     ecx,ebx
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        sub     edi,10000h
        mov     edx,ecx
        and     ecx,3
        jz      @@Pass3
        ALIGN   4
@@Loop3:
        lodsb
        and     [edi],al
        inc     edi
        loop    @@Loop3
@@Pass3:
        mov     ecx,edx
        shr     ecx,2
        xor     ecx,0
        jz      @@Pass4
        ALIGN   4
@@Loop4:
        lodsd
        and     [edi],eax
        add     edi,4
        loop    @@Loop4
@@Pass4:
        ret
@@Novf: mov     edx,ecx
        and     ecx,3
        jz      @@Pass5
        ALIGN   4
@@Loop5:
        lodsb
        and     [edi],al
        inc     edi
        loop    @@Loop5
@@Pass5:
        mov     ecx,edx
        shr     ecx,2
        xor     ecx,0
        jz      @@Pass6
        ALIGN   4
@@Loop6:
        lodsd
        and     [edi],eax
        add     edi,4
        loop    @@Loop6
@@Pass6:
        ret
end;

procedure TspHtextel256Bnk;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     dx
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@Pass
        call    [BankFunc]
@@Pass: cld
        mov     edi,ebx
        add     edi,[VideoPtr]
        add     bx,cx
        jnc     @@Novf
        push    ecx
        mov     cx,di
        not     cx
        inc     ecx
        mov     ebx,ecx
        xor     ecx,0
        jz      @@Pass1
        mov     edx,[TranspColor]
        ALIGN   4
@@Loop1:
        lodsb
        cmp     al,dl
        jz      @@Next1
        mov     [edi],al
@@Next1:
        inc     edi
        loop    @@Loop1
@@Pass1:
        pop     ecx
        sub     ecx,ebx
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        sub     edi,10000h
        xor     ecx,0
        jz      @@Pass2
        mov     edx,[TranspColor]
        ALIGN   4
@@Loop2:
        lodsb
        cmp     al,dl
        jz      @@Next2
        mov     [edi],al
@@Next2:
        inc     edi
        loop    @@Loop2
@@Pass2:
        ret
@@Novf: xor     ecx,0
        jz      @@Pass3
        mov     edx,[TranspColor]
        ALIGN   4
@@Loop3:
        lodsb
        cmp     al,dl
        jz      @@Next2
        mov     [edi],al
@@Next3:
        inc     edi
        loop    @@Loop2
@@Pass3:
        ret
end;

procedure TspHtextel32KBnk;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     dx
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@Pass
        call    [BankFunc]
@@Pass: cld
        mov     edi,ebx
        add     edi,[VideoPtr]
        add     bx,cx
        jnc     @@Novf
        push    ecx
        mov     cx,di
        not     cx
        inc     ecx
        mov     ebx,ecx
        shr     ecx,1
        xor     ecx,0
        jz      @@Pass1
        mov     edx,[TranspColor]
        ALIGN   4
@@Loop1:
        lodsw
        cmp     ax,dx
        jz      @@Next1
        mov     [edi],ax
@@Next1:
        add     edi,2
        loop    @@Loop1
@@Pass1:
        pop     ecx
        sub     ecx,ebx
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        sub     edi,10000h
        shr     ecx,1
        xor     ecx,0
        jz      @@Pass2
        mov     edx,[TranspColor]
        ALIGN   4
@@Loop2:
        lodsw
        cmp     ax,dx
        jz      @@Next2
        mov     [edi],ax
@@Next2:
        add     edi,2
        loop    @@Loop2
@@Pass2:
        ret
@@Novf: shr     ecx,1
        xor     ecx,0
        jz      @@Pass3
        mov     edx,[TranspColor]
        ALIGN   4
@@Loop3:
        lodsw
        cmp     ax,dx
        jz      @@Next2
        mov     [edi],ax
@@Next3:
        add     edi,2
        loop    @@Loop2
@@Pass3:
        ret
end;

procedure TspHtextel16mBnk;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     dx
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@Pass
        call    [BankFunc]
@@Pass: cld
        mov     edi,ebx
        add     edi,[VideoPtr]
        xor     edx,edx
        mov     eax,ecx
        mov     ecx,3
        div     ecx
        mov     ecx,eax
        xor     ecx,0
        jz      @@Quit
        mov     edx,[TranspColor]
        ALIGN   4
@@Loop: xor     eax,eax
        mov     al,[esi+2]
        shl     eax,16
        mov     ax,[esi]
        add     esi,3
        cmp     eax,edx
        jz      @@Skip
        cmp     di,0FFFDh
        jae     @@Next3
        mov     [edi],ax
        add     edi,2
        shr     eax,16
        mov     [edi],al
        inc     edi
@@NextPix:
        loop    @@Loop
        ret
@@Next3:
        jne     @@Next5
        mov     [edi],ax
        shr     eax,16
        mov     [edi+2],al
        xor     di,di
        push    edx
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        pop     edx
        jmp     @@NextPix
@@Next5:
        cmp     di,0FFFEh
        jne     @@Next4
        mov     [edi],ax
        push    edx
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        pop     edx
        shr     eax,16
        xor     di,di
        mov     [edi],al
        inc     edi
        jmp     @@NextPix
@@Next4:
        mov     [edi],al
        push    edx
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        pop     edx
        shr     eax,8
        xor     di,di
        mov     [edi],ax
        add     edi,2
        xor     eax,eax
        jmp     @@NextPix
@@Skip: add     di,3
        jnc     @@NextPix
        push    edx
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        pop     edx
        jmp     @@NextPix
@@Quit:
        ret
end;

procedure TspHtextel4GBnk;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     dx
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@Pass
        call    [BankFunc]
@@Pass: cld
        mov     edi,ebx
        add     edi,[VideoPtr]
        add     bx,cx
        jnc     @@Novf
        push    ecx
        mov     cx,di
        not     cx
        inc     ecx
        mov     ebx,ecx
        shr     ecx,2
        xor     ecx,0
        jz      @@Pass1
        mov     edx,[TranspColor]
        ALIGN   4
@@Loop1:
        lodsd
        cmp     eax,edx
        jz      @@Next1
        mov     [edi],eax
@@Next1:
        add     edi,4
        loop    @@Loop1
@@Pass1:
        pop     ecx
        sub     ecx,ebx
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        sub     edi,10000h
        shr     ecx,2
        xor     ecx,0
        jz      @@Pass2
        mov     edx,[TranspColor]
        ALIGN   4
@@Loop2:
        lodsd
        cmp     eax,edx
        jz      @@Next2
        mov     [edi],eax
@@Next2:
        add     edi,4
        loop    @@Loop2
@@Pass2:
        ret
@@Novf: shr     ecx,2
        xor     ecx,0
        jz      @@Pass3
        mov     edx,[TranspColor]
        ALIGN   4
@@Loop3:
        lodsd
        cmp     eax,edx
        jz      @@Next2
        mov     [edi],eax
@@Next3:
        add     edi,4
        loop    @@Loop2
@@Pass3:
        ret
end;

procedure PutHtextelLin;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     edx
        add     ebx,eax
        add     ebx,[VideoPagePtr]
        cld
        mov     edi,ebx
        mov     edx,ecx
        and     ecx,3
        rep     movsb
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     movsd
        ret
end;

procedure XorHtextelLin;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     edx
        add     ebx,eax
        add     ebx,[VideoPagePtr]
        cld
        mov     edi,ebx
        mov     edx,ecx
        and     ecx,3
        jz      @@Pass1
        ALIGN   4
@@Loop1:
        lodsb
        xor     [edi],al
        inc     edi
        loop    @@Loop1
@@Pass1:
        mov     ecx,edx
        shr     ecx,2
        xor     ecx,0
        jz      @@Pass2
        ALIGN   4
@@Loop2:
        lodsd
        xor     [edi],eax
        add     edi,4
        loop    @@Loop2
@@Pass2:
        ret
end;

procedure OrHtextelLin;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     edx
        add     ebx,eax
        add     ebx,[VideoPagePtr]
        cld
        mov     edi,ebx
        mov     edx,ecx
        and     ecx,3
        jz      @@Pass1
        ALIGN   4
@@Loop1:
        lodsb
        or      [edi],al
        inc     edi
        loop    @@Loop1
@@Pass1:
        mov     ecx,edx
        shr     ecx,2
        xor     ecx,0
        jz      @@Pass2
        ALIGN   4
@@Loop2:
        lodsd
        or      [edi],eax
        add     edi,4
        loop    @@Loop2
@@Pass2:
        ret
end;

procedure AndHtextelLin;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     edx
        add     ebx,eax
        add     ebx,[VideoPagePtr]
        cld
        mov     edi,ebx
        mov     edx,ecx
        and     ecx,3
        jz      @@Pass1
        ALIGN   4
@@Loop1:
        lodsb
        and     [edi],al
        inc     edi
        loop    @@Loop1
@@Pass1:
        mov     ecx,edx
        shr     ecx,2
        xor     ecx,0
        jz      @@Pass2
        ALIGN   4
@@Loop2:
        lodsd
        and     [edi],eax
        add     edi,4
        loop    @@Loop2
@@Pass2:
        ret
end;

procedure TspHtextel256Lin;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     edx
        add     ebx,eax
        add     ebx,[VideoPagePtr]
        cld
        mov     edi,ebx
        mov     edx,[TranspColor]
        xor     ecx,0
        jz      @@Quit
        ALIGN   4
@@Loop1:
        lodsb
        cmp     al,dl
        jz      @@Next1
        mov     [edi],al
@@Next1:
        inc     edi
        loop    @@Loop1
@@Quit:
        ret
end;

procedure TspHtextel32kLin;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     edx
        add     ebx,eax
        add     ebx,[VideoPagePtr]
        cld
        mov     edi,ebx
        mov     edx,[TranspColor]
        shr     ecx,1
        xor     ecx,0
        jz      @@Quit
        ALIGN   4
@@Loop1:
        lodsw
        cmp     ax,dx
        jz      @@Next1
        mov     [edi],ax
@@Next1:
        add     edi,2
        loop    @@Loop1
@@Quit:
        ret
end;

procedure TspHtextel16mLin;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     edx
        add     ebx,eax
        add     ebx,[VideoPagePtr]
        cld
        mov     edi,ebx
        xor     edx,edx
        mov     eax,ecx
        mov     ecx,3
        div     ecx
        mov     ecx,eax
        xor     ecx,0
        jz      @@Quit
        mov     dx,word ptr [TranspColor]
        mov     bl,byte ptr [TranspColor+2]
        ALIGN   4
@@Loop1:
        lodsw
        mov     bh,[esi]
        cmp     ax,dx
        jnz     @@Show
        cmp     bh,bl
        jz      @@Next1
@@Show:
        mov     [edi],ax
        mov     [edi+2],bh
@@Next1:
        add     edi,3
        inc     esi
        loop    @@Loop1
@@Quit:
        ret
end;

procedure TspHtextel4GLin;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     edx
        add     ebx,eax
        add     ebx,[VideoPagePtr]
        cld
        mov     edi,ebx
        mov     edx,[TranspColor]
        shr     ecx,2
        xor     ecx,0
        jz      @@Quit
        ALIGN   4
@@Loop1:
        lodsd
        cmp     eax,edx
        jz      @@Next1
        mov     [edi],eax
@@Next1:
        add     edi,4
        loop    @@Loop1
@@Quit:
        ret
end;

procedure GetHtextelBnk;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     dx
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@Pass
        call    [BankFunc]
@@Pass: cld
        mov     esi,ebx
        add     esi,[VideoPtr]
        add     bx,cx
        jnc     @@Novf
        push    ecx
        mov     cx,si
        not     cx
        inc     ecx
        mov     ebx,ecx
        mov     edx,ecx
        and     ecx,3
        rep     movsb
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     movsd
        pop     ecx
        sub     ecx,ebx
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        sub     esi,10000h
        mov     edx,ecx
        and     ecx,3
        rep     movsb
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     movsd
        ret
@@Novf: mov     edx,ecx
        and     ecx,3
        rep     movsb
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     movsd
        ret
end;

procedure GetHtextelLin;
code;
      asm
        mov     eax,[BytesPerLine]
        mul     edx
        add     ebx,eax
        add     ebx,[VideoPagePtr]
        cld
        mov     esi,ebx
        mov     edx,ecx
        and     ecx,3
        rep     movsb
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     movsd
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Ultra fast video memory cler (ExpandFill with zero) routine            //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure ClearDevice;
assembler;
      asm
        xor     eax,eax
        mov     [CpX],eax
        mov     [CpY],eax
        cld
        cmp     [VideoMode],isUnsupported
        jg      @@Pass1
        mov     [GrResult],grInvalidMode
        jmp     @@Exit
@@Pass1:
        cmp     [VideoMode],isMCGAMode
        jg      @@Pass2
        mov     ecx,16000
        mov     edi,0A0000h
        xor     eax,eax
        ALIGN   4
        rep     stosd
        mov     [GrResult],grOk
        jmp     @@Exit
@@Pass2:
        xor     [UseLfb],0
        je      @@Bnk
@@Lfb:  mov     edi,[ScreenPtr]
        mov     ecx,[TotalMem]
        shl     ecx,8
        xor     eax,eax
        ALIGN   4
        rep     stosd
        mov     [GrResult],grOk
        jmp     @@Exit
@@Bnk:  xor     [CurBank],0
        je      @@Next
        xor     edx,edx
        call    [BankFunc]
@@Next: mov     ecx,[TotalMem]
        shr     ecx,6
        ALIGN   4
@@Loop: push    ecx
        mov     edi,[ScreenPtr]
        xor     eax,eax
        mov     ecx,16384
        ALIGN   4
        rep     stosd
        mov     dx,[CurBank]
        inc     dx
        call    [BankFunc]
        pop     ecx
        loop    @@Loop
        mov     [GrResult],grOk
@@Exit: xor     [VirtualMode],0
        push    dword ptr [BkGrColor]
        mov     [BkGrColor],0
{$ifdef __DOS__}
        Call    ClearPage
{$endif}
{$ifdef __WIN32__}
        push    1
        call    SetActivePage
        Call    ClearPage
        push    0
        call    SetActivePage
        Call    ClearPage
{$endif}
        pop     dword ptr [BkGrColor]
        je      @@Done
@@Done:
end;

////////////////////////////////////////////////////////////////////////////
// Dummy procedure.                                                       //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure DummyProc;
code;
      asm
        mov     [GrResult], grInvalidMode
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in palette colored banked SVGA graphics modes.   //
// Uses normal copy/put operation                                         //
// EAX=Y, EBX=X, ECX=COLOR                                                //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure PutPixel256Bnk;
code;
      asm
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        je      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        mov     [ebx],cl
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in palette colored LFB SVGA graphics modes.      //
// Uses normal copy/put operation                                         //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure PutPixel256Lin;
code;
      asm
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        mov     [ebx],cl
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in hi colored banked SVGA graphics modes.        //
// Uses normal copy/put operation                                         //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure PutPixel32kBnk;
code;
      asm
        shl     ebx,1
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        mov     [ebx],cx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in hi colored LFB SVGA graphics modes.           //
// Uses normal copy/put operation                                         //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure PutPixel32kLin;
code;
      asm
        shl     ebx,1
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        mov     [ebx],cx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M colored banked SVGA graphics modes.       //
// Uses normal copy/put operation                                         //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure PutPixel16mBnk;
code;
      asm
        mul     word ptr [BytesPerLine]
        add     ax,bx
        adc     edx,0
        shl     ebx,1
        add     ax,bx
        adc     edx,[BankOffset]
        add     ax,[OriginOffset]
        adc     edx,0
        mov     ebx,eax
        add     ebx,[VideoPtr]
        cmp     dx,word ptr [CurBank]
        je      @@NoChange
        call    dword ptr [BankFunc]
@@NoChange:
        cmp     bx,0FFFEh
        jae     @@Next2
        mov     [ebx],cx
        shr     ecx,16
        mov     [ebx+2],cl
        jmp     @@Quit
@@Next2:
        jne     @@Next1
        mov     [ebx],cx
        mov     dx,[CurBank]
        inc     dx
        call    dword ptr [BankFunc]
        xor     bx,bx
        shr     ecx,16
        mov     [ebx],cl
        jmp     @@Quit
@@Next1:
        mov     [ebx],cl
        mov     dx,[CurBank]
        inc     dx
        call    dword ptr [BankFunc]
        xor     bx,bx
        shr     ecx,8
        mov     [ebx],cx
@@Quit: ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M colored LFB SVGA graphics modes.          //
// Uses normal copy/put operation                                         //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure PutPixel16mLin;
code;
      asm
        mov     edx,ebx
        shl     ebx,1
        add     ebx,edx
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        mov     [ebx],cx
        shr     ecx,16
        mov     [ebx+2],cl
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M+A colored banked SVGA graphics modes.     //
// Uses normal copy/put operation                                         //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure PutPixel4GBnk;
code;
      asm
        shl     ebx,2
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        mov     [ebx],ecx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M+A colored LFB SVGA graphics modes.        //
// Uses normal copy/put operation                                         //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure PutPixel4GLin;
code;
      asm
        shl     ebx,2
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        mov     [ebx],ecx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in palette colored banked SVGA graphics modes.   //
// Uses logical Or operation                                              //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure OrPixel256Bnk;
code;
      asm
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        je      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        or      [ebx],cl
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in palette colored LFB SVGA graphics modes.      //
// Uses logical Or operation                                              //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure OrPixel256Lin;
code;
      asm
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        or      [ebx],cl
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in hi colored banked SVGA graphics modes.        //
// Uses logical Or operation                                              //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure OrPixel32kBnk;
code;
      asm
        shl     ebx,1
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        or      [ebx],cx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in hi colored LFB SVGA graphics modes.           //
// Uses logical Or operation                                              //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure OrPixel32kLin;
code;
      asm
        shl     ebx,1
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        or      [ebx],cx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M colored banked SVGA graphics modes.       //
// Uses logical Or operation                                              //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure OrPixel16mBnk;
code;
      asm
        mul     word ptr [BytesPerLine]
        add     ax,bx
        adc     edx,0
        shl     ebx,1
        add     ax,bx
        adc     edx,[BankOffset]
        add     ax,[OriginOffset]
        adc     edx,0
        mov     ebx,eax
        add     ebx,[VideoPtr]
        cmp     dx,word ptr [CurBank]
        je      @@NoChange
        call    dword ptr [BankFunc]
@@NoChange:
        cmp     bx,0FFFEh
        jae     @@Next2
        or      [ebx],cx
        shr     ecx,16
        or      [ebx+2],cl
        jmp     @@Quit
@@Next2:
        jne     @@Next1
        or      [ebx],cx
        mov     dx,[CurBank]
        inc     dx
        call    dword ptr [BankFunc]
        xor     bx,bx
        shr     ecx,16
        or      [ebx],cl
        jmp     @@Quit
@@Next1:
        or      [ebx],cl
        mov     dx,[CurBank]
        inc     dx
        call    dword ptr [BankFunc]
        xor     bx,bx
        shr     ecx,8
        or      [ebx],cx
@@Quit: ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M colored LFB SVGA graphics modes.          //
// Uses logical Or operation                                              //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure OrPixel16mLin;
code;
      asm
        mov     edx,ebx
        shl     ebx,1
        add     ebx,edx
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        or      [ebx],cx
        shr     ecx,16
        or      [ebx+2],cl
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M+A colored banked SVGA graphics modes.     //
// Uses logical Or operation                                              //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure OrPixel4GBnk;
code;
      asm
        shl     ebx,2
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        or      [ebx],ecx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M+A colored LFB SVGA graphics modes.        //
// Uses logical Or operation                                              //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure OrPixel4GLin;
code;
      asm
        shl     ebx,2
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        or      [ebx],ecx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in palette colored banked SVGA graphics modes.   //
// Uses logical And operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure AndPixel256Bnk;
code;
      asm
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        je      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        and     [ebx],cl
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in palette colored LFB SVGA graphics modes.      //
// Uses logical And operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure AndPixel256Lin;
code;
      asm
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        and     [ebx],cl
        ret
end;

 ////////////////////////////////////////////////////////////////////////////
 // Routine draws a pixel in hi colored banked SVGA graphics modes.        //
 // Uses logical And operation                                             //
 //                                                                        //
 // Private                                                                //
 ////////////////////////////////////////////////////////////////////////////
procedure AndPixel32kBnk;
code;
      asm
        shl     ebx,1
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        and     [ebx],cx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in hi colored LFB SVGA graphics modes.           //
// Uses logical And operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure AndPixel32kLin;
code;
      asm
        shl     ebx,1
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        and     [ebx],cx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M colored banked SVGA graphics modes.       //
// Uses logical And operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure AndPixel16mBnk;
code;
      asm
        mul     word ptr [BytesPerLine]
        add     ax,bx
        adc     edx,0
        shl     ebx,1
        add     ax,bx
        adc     edx,[BankOffset]
        add     ax,[OriginOffset]
        adc     edx,0
        mov     ebx,eax
        add     ebx,[VideoPtr]
        cmp     dx,word ptr [CurBank]
        je      @@NoChange
        call    dword ptr [BankFunc]
@@NoChange:
        cmp     bx,0FFFEh
        jae     @@Next2
        and     [ebx],cx
        shr     ecx,16
        and     [ebx+2],cl
        jmp     @@Quit
@@Next2:
        jne     @@Next1
        and     [ebx],cx
        mov     dx,[CurBank]
        inc     dx
        call    dword ptr [BankFunc]
        and     bx,bx
        shr     ecx,16
        and     [ebx],cl
        jmp     @@Quit
@@Next1:
        and     [ebx],cl
        mov     dx,[CurBank]
        inc     dx
        call    dword ptr [BankFunc]
        and     bx,bx
        shr     ecx,8
        and     [ebx],cx
@@Quit: ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M colored LFB SVGA graphics modes.          //
// Uses logical And operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure AndPixel16mLin;
code;
      asm
        mov     eax,ebx
        shl     ebx,1
        add     ebx,eax
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        and     [ebx],cx
        shr     ecx,16
        and     [ebx+2],cl
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M+A colored banked SVGA graphics modes.     //
// Uses logical And operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure AndPixel4GBnk;
code;
      asm
        shl     ebx,2
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        and     [ebx],ecx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M+A colored LFB SVGA graphics modes.        //
// Uses logical And operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure AndPixel4GLin;
code;
      asm
        shl     ebx,2
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        and     [ebx],ecx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in palette colored banked SVGA graphics modes.   //
// Uses logical Xor operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure XorPixel256Bnk;
code;
      asm
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        je      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        xor     [ebx],cl
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in palette colored LFB SVGA graphics modes.      //
// Uses logical Xor operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure XorPixel256Lin;
code;
      asm
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        xor     [ebx],cl
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in hi colored banked SVGA graphics modes.        //
// Uses logical Xor operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure XorPixel32kBnk;
code;
      asm
        shl     ebx,1
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        xor     [ebx],cx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in hi colored LFB SVGA graphics modes.           //
// Uses logical Xor operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure XorPixel32kLin;
code;
      asm
        shl     ebx,1
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        xor     [ebx],cx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M colored banked SVGA graphics modes.       //
// Uses logical Xor operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure XorPixel16mBnk;
code;
      asm
        mul     word ptr [BytesPerLine]
        add     ax,bx
        adc     edx,0
        shl     ebx,1
        add     ax,bx
        adc     edx,[BankOffset]
        add     ax,[OriginOffset]
        adc     edx,0
        mov     ebx,eax
        add     ebx,[VideoPtr]
        cmp     dx,word ptr [CurBank]
        je      @@NoChange
        call    dword ptr [BankFunc]
@@NoChange:
        cmp     bx,0FFFEh
        jae     @@Next2
        xor     [ebx],cx
        shr     ecx,16
        xor     [ebx+2],cl
        jmp     @@Quit
@@Next2:
        jne     @@Next1
        xor     [ebx],cx
        mov     dx,[CurBank]
        inc     dx
        call    dword ptr [BankFunc]
        xor     bx,bx
        shr     ecx,16
        xor     [ebx],cl
        jmp     @@Quit
@@Next1:
        xor     [ebx],cl
        mov     dx,[CurBank]
        inc     dx
        call    dword ptr [BankFunc]
        xor     bx,bx
        shr     ecx,8
        xor     [ebx],cx
@@Quit: ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M colored LFB SVGA graphics modes.          //
// Uses logical Xor operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure XorPixel16mLin;
code;
      asm
        mov     edx,ebx
        shl     ebx,1
        add     ebx,edx
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        xor     [ebx],cx
        shr     ecx,16
        xor     [ebx+2],cl
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M+A colored banked SVGA graphics modes.     //
// Uses logical Xor operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure XorPixel4GBnk;
code;
      asm
        shl     ebx,2
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        xor     [ebx],ecx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a pixel in 16M+A colored LFB SVGA graphics modes.        //
// Uses logical Xor operation                                             //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure XorPixel4GLin;
code;
      asm
        shl     ebx,2
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        xor     [ebx],ecx
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine gets a pixel in palette colored banked SVGA graphics modes.    //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure GetPixel256Bnk;
code;
      asm
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        je      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        xor     eax,eax
        mov     al,[ebx]
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine gets a pixel in palette colored LFB SVGA graphics modes.       //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure GetPixel256Lin;
code;
      asm
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        xor     eax,eax
        mov     al,[ebx]
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine gets a pixel in hi colored banked SVGA graphics modes.         //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure GetPixel32kBnk;
code;
      asm
        shl     ebx,1
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        xor     eax,eax
        mov     ax,[ebx]
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine gets a pixel in hi colored LFB SVGA graphics modes.            //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure GetPixel32kLin;
code;
      asm
        shl     ebx,1
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        xor     eax,eax
        mov     ax,[ebx]
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine gets a pixel in 16M colored banked SVGA graphics modes.        //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure GetPixel16mBnk;
code;
      asm
        mul     word ptr [BytesPerLine]
        add     ax,bx
        adc     edx,0
        shl     bx,1
        add     ax,bx
        adc     edx,[BankOffset]
        add     ax,[OriginOffset]
        adc     edx,0
        mov     ebx,eax
        add     ebx,[VideoPtr]
        cmp     dx,word ptr [CurBank]
        je      @@NoChange
        call    dword ptr [BankFunc]
@@NoChange:
        cmp     bx,0FFFEh
        jae     @@Next2
        mov     ax,[ebx]
        mov     dl,[ebx+2]
        jmp     @@Quit
@@Next2:
        jne     @@Next1
        mov     ax,[ebx]
        mov     dx,[CurBank]
        inc     dx
        call    dword ptr [BankFunc]
        xor     bx,bx
        mov     dl,[ebx]
        jmp     @@Quit
@@Next1:
        mov     al,[ebx]
        mov     dx,[CurBank]
        inc     dx
        call    dword ptr [BankFunc]
        xor     bx,bx
        mov     ah,[ebx]
        mov     dl,[ebx+1]
@@Quit: shl     edx,16
        mov     dx,ax
        mov     eax,edx
        and     eax,0FFFFFFh
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine gets a pixel in 16M colored LFB SVGA graphics modes.           //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure GetPixel16mLin;
code;
      asm
        mov     edx,ebx
        shl     ebx,1
        add     ebx,edx
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        mov     al,[ebx+2]
        shl     eax,16
        mov     ax,[ebx]
        and     eax,0FFFFFFh
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine gets a pixel in 16M+A colored banked SVGA graphics modes.      //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure GetPixel4GBnk;
code;
      asm
        shl     ebx,2
        mul     word [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        jz      @@NoChange
        call    [BankFunc]
@@NoChange:
        add     ebx,[VideoPtr]
        mov     eax,[ebx]
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine gets a pixel in 16M+A colored LFB SVGA graphics modes.         //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure GetPixel4GLin;
code;
      asm
        shl     ebx,2
        mul     dword ptr [BytesPerLine]
        add     ebx,[VideoPagePtr]
        add     ebx,eax
        mov     eax,[ebx]
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a horizontal line in palette colored banked SVGA         //
// graphics modes.                                                        //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure DrawHLine256Bnk;
code;
      asm
        sub     ecx,ebx
        inc     ecx
        mov     eax,edx
        mul     word ptr [BytesPerLine]
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        je      @@Pass
        call    [BankFunc]
@@Pass:
        cld
        mov     al,byte ptr [FillColor]
        mov     ah,al
        mov     edx,eax
        shl     eax,16
        mov     ax,dx
        mov     edi,ebx
        add     edi,[VideoPtr]
        add     bx,cx
        jnc     @@Novf
        push    ecx
        mov     cx,di
        not     cx
        inc     ecx
        mov     ebx,ecx
        mov     edx,ecx
        and     ecx,3
        rep     stosb
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     stosd
        pop     ecx
        sub     ecx,ebx
        mov     dx,[CurBank]
        inc     edx
        call    [BankFunc]
        sub     edi,10000h
        mov     edx,ecx
        and     ecx,3
        rep     stosb
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     stosd
        jmp     @@Quit
@@Novf:
        mov     edx,ecx
        and     ecx,3
        rep     stosb
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     stosd
@@Quit: ret
end;

////////////////////////////////////////////////////////////////////////////
// Routine draws a line in palette colored LFB SVGA graphics modes.       //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure DrawHLine256Lin;
code;
      asm
        mov     edi,ebx
        sub     ecx,edi
        inc     ecx
        mov     eax,edx
        mul     [BytesPerLine]
        add     edi,eax
        add     edi,[VideoPagePtr]
        cld
        mov     al,byte ptr [FillColor]
        mov     ah,al
        mov     edx,eax
        shl     eax,16
        mov     ax,dx
        mov     edx,ecx
        and     ecx,3
        rep     stosb
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     stosd
@@Quit: ret
end;

procedure DrawHLine32kBnk;
code;
      asm
        sub     ecx,ebx
        inc     ecx
        shl     ecx,1
        mov     eax,edx
        mul     word ptr [BytesPerLine]
        shl     ebx,1
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        je      @@Pass
        call    [BankFunc]
@@Pass:
        cld
        mov     ax,word ptr [FillColor]
        shl     eax,16
        mov     ax,word ptr [FillColor]
        mov     edi,ebx
        add     edi,[VideoPtr]
        add     bx,cx
        jnc     @@Novf
        push    ecx
        mov     cx,di
        not     cx
        inc     ecx
        mov     ebx,ecx
        mov     edx,ecx
        and     ecx,3
        shr     ecx,1
        rep     stosw
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     stosd
        pop     ecx
        sub     ecx,ebx
        mov     dx,[CurBank]
        inc     edx
        call    [BankFunc]
        sub     edi,10000h
        mov     edx,ecx
        and     ecx,3
        shr     ecx,1
        rep     stosw
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     stosd
        jmp     @@Quit
@@Novf:
        mov     edx,ecx
        and     ecx,3
        shr     ecx,1
        rep     stosw
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     stosd
@@Quit: ret
end;

procedure DrawHLine32kLin;
code;
      asm
        mov     edi,ebx
        sub     ecx,edi
        inc     ecx
        shl     ecx,1
        mov     eax,edx
        mul     [BytesPerLine]
        shl     edi,1
        add     edi,eax
        add     edi,[VideoPagePtr]
        cld
        mov     ax,word ptr [FillColor]
        shl     eax,16
        mov     ax,word ptr [FillColor]
        mov     edx,ecx
        and     ecx,3
        shr     ecx,1
        rep     stosw
        mov     ecx,edx
        shr     ecx,2
        ALIGN   4
        rep     stosd
@@Quit: ret
end;

procedure DrawHLine16mBnk;
code;
      asm
        sub     ecx,ebx
        inc     ecx
        mov     eax,edx
        mul     word ptr [BytesPerLine]
        add     ax,bx
        adc     edx,0
        shl     ebx,1
        add     ax,bx
        adc     edx,[BankOffset]
        add     ax,[OriginOffset]
        adc     edx,0
        mov     edi,eax
        add     edi,[VideoPtr]
        cmp     dx,[CurBank]
        je      @@NoChange
        call    [BankFunc]
@@NoChange:
        mov     ax,word ptr [FillColor]
        mov     dl,byte ptr [FillColor+2]
        ALIGN   4
@@Loop:
        cmp     di,0FFFDh
        jae     @@Next3
        mov     [edi],ax
        mov     [edi+2],dl
        add     di,3
@@NextPix:
        loop    @@Loop
        jmp     @@Quit
@@Next3:
        jne     @@Next5
        mov     [edi],ax
        mov     [edi+2],dl
        xor     di,di
        push    edx
        mov     dx,[CurBank]
        inc     edx
        call    [BankFunc]
        pop     edx
        jmp     @@NextPix
@@Next5:
        cmp     di,0FFFEh
        jne     @@Next4
        mov     [edi],ax
        push    edx
        mov     dx,[CurBank]
        inc     edx
        call    [BankFunc]
        pop     edx
        xor     di,di
        mov     [edi],dl
        mov     di,1
        jmp     @@NextPix
@@Next4:
        mov     [edi],al
        push    edx
        mov     dx,[CurBank]
        inc     edx
        call    [BankFunc]
        pop     edx
        xor     di,di
        mov     [edi],ah
        mov     [edi+1],dl
        mov     di,2
        jmp     @@NextPix
@@Quit: ret
end;

procedure DrawHLine16mLin;
code;
      asm
        mov     edi,ebx
        sub     ecx,edi
        inc     ecx
        mov     eax,edx
        mul     [BytesPerLine]
        add     edi,eax
        add     edi,ebx
        add     edi,ebx
        add     edi,[VideoPagePtr]
        cld
        mov     ax,word ptr [FillColor]
        mov     dh,byte ptr [FillColor+2]
        ALIGN   4
@@Loop: mov     [edi],ax
        mov     [edi+2],dh
        add     edi,3
        loop    @@Loop
@@Quit: ret
end;

procedure DrawHLine4GBnk;
code;
      asm
        sub     ecx,ebx
        inc     ecx
        shl     ecx,2
        mov     eax,edx
        mul     word ptr [BytesPerLine]
        shl     ebx,2
        add     bx,ax
        adc     edx,[BankOffset]
        add     bx,[OriginOffset]
        adc     edx,0
        cmp     dx,[CurBank]
        je      @@Pass
        call    [BankFunc]
@@Pass:
        cld
        mov     eax,[FillColor]
        mov     edi,ebx
        add     edi,[VideoPtr]
        add     bx,cx
        jnc     @@Novf
        push    ecx
        mov     cx,di
        not     cx
        inc     ecx
        mov     ebx,ecx
        shr     ecx,2
        ALIGN   4
        rep     stosd
        pop     ecx
        sub     ecx,ebx
        mov     dx,[CurBank]
        inc     edx
        call    [BankFunc]
        sub     edi,10000h
        shr     ecx,2
        ALIGN   4
        rep     stosd
        jmp     @@Quit
@@Novf:
        shr     ecx,2
        ALIGN   4
        rep     stosd
@@Quit: ret
end;

procedure DrawHLine4GLin;
code;
      asm
        mov     edi,ebx
        sub     ecx,edi
        inc     ecx
        mov     eax,edx
        mul     [BytesPerLine]
        shl     edi,2
        add     edi,eax
        add     edi,[VideoPagePtr]
        cld
        mov     eax,[FillColor]
        ALIGN   4
        rep     stosd
@@Quit: ret
end;

///////////////////////////////////////////////////////////////////////////
// Computes the page size in bytes for the specified mode                //
//                                                                       //
// Public                                                                //
///////////////////////////////////////////////////////////////////////////
function GetPageSize: DWord;
begin
  Result := VpHeight*DWord(BytesPerLine);
end;

{$ifdef __WIN32__}
procedure DD_Retrace;
begin
  if UseDirectDraw5 then
    DirectDraw2^^.WaitForVerticalBlank(DirectDraw2, DDWAITVB_BLOCKEND, 0)
  else
    DirectDraw1^^.WaitForVerticalBlank(DirectDraw1, DDWAITVB_BLOCKEND, 0)
end;
{$endif}

procedure SetVisualPage(PageNo: DWord; WaitForRetrace: Boolean);
{$ifdef __DOS__}
assembler;
      asm
        mov     eax,[PageNo]
        cmp     ax,[MaxPage]
        jle     @@Next
        mov     [GrResult],grError
        jmp     @@Quit
@@Next: mov     [GrResult],grOk
        mov     ebx,[VpHeight]
        mov     [VisualPage],eax
        mul     ebx
        mov     edx,eax
        xor     ecx,ecx
        call    [SetStartAddrNW]
        cmp     [WaitForRetrace],0
        jz      @@Quit
        call    Retrace
@@Quit:
end;
{$endif}
{$ifdef __WIN32__}
begin
  if (PageNo < 2) and (PageNo <> DD_CurrentPage) then lpprim^^.Flip(lpprim, lpback, DDFLIP_WAIT);
  DD_CurrentPage := PageNo;
  if WaitForRetrace then DD_Retrace;
end;
{$endif}

function GetVisualPage: DWord;
code;
      asm
        mov     eax,[VisualPage]
        ret
end;

procedure SetActivePage(PageNo: DWord);
begin
{$ifdef __DOS__}
  if VirtualMode then
  begin
    GrResult := grError;
    exit;
  end;
  if MaxPage >= PageNo then
  begin
    if UseLfb then
    begin
      VideoPagePtr := VideoPtr+PageSize*DWord(PageNo);
    end else
    begin
      BankOffset := (PageSize*DWord(PageNo)) shr 16;
      OriginOffset := Word(PageSize*DWord(PageNo));
      ActivePage := PageNo;
    end;
    GrResult := grOk;
  end else
    GrResult := grError;
{$endif}
{$ifdef __WIN32__}
  if PageNo = 0 then
    VideoPagePtr  :=  DWORD(DD_PrimPtr);
  if PageNo = 1 then
    VideoPagePtr  :=  DWORD(DD_BackPtr);
  ActivePage := PageNo;
  GrResult := grOk;
{$endif}
end;

function GetActivePage: DWord;
code;
      asm
        mov     eax,[ActivePage]
        ret
end;

function GetMaxColor: DWord;
code;
      asm
        mov     eax,[GrMaxColor]
        ret
end;

procedure SetColor(Color: DWord);
code;
      asm
        mov     eax,[Color]
        mov     [GraphColor],eax
        ret
end;

function GetColor: DWord;
code;
      asm
        mov     eax,[GraphColor]
        ret
end;

procedure SetBkColor(Color: DWord);
begin
  BkGrColor := Color;
end;

function GetBkColor: DWord;
code;
      asm
        mov     eax,[BkGrColor]
        ret
end;

procedure SetFillColor(Color: DWord);
code;
      asm
        mov     eax,[Color]
        mov     [FillColor],eax
        mov     [UseSolidFill], 1
        ret
end;

function GetFillColor: DWord;
code;
      asm
        mov     eax,[FillColor]
        ret
end;

procedure SetLineStyle (LineStyle: Word; Pattern: Word; Thickness: Word);
begin
  case LineStyle of
    SolidLn :  GrLineStyle := $FFFFFFFF;
    DottedLn:  GrLineStyle := $33333333;
    CenterLn:  GrLineStyle := $1E3F1E3F;
    DashedLn:  GrLineStyle := $1F1F1F1F;
    UserBitLn: GrLineStyle := (DWord(Pattern) shl 16) + Pattern;
    else
    begin
     GrResult := grError;
     exit;
    end;
  end;
  GrLineStl := LineStyle;
  if (Thickness=NormWidth) or (Thickness=ThickWidth) then
  begin
    LineThick := Thickness;
    GrResult := grOk;
  end else
    GrResult := grError;
end;

procedure GetLineSettings(var LineInfo: LineSettingsType);
begin
  LineInfo.LineStyle := GrLineStl;
  LineInfo.Pattern := GrLineStyle;
  LineInfo.Thickness := LineThick;
end;

function GetMaxX: DWord;
code;
      asm
        mov     eax,[VpWidth]
        dec     eax
        ret
end;

function GetMaxY: DWord;
code;
      asm
        mov     eax,[VpHeight]
        dec     eax
        ret
end;

function GetScreenHeight: DWord;
code;
      asm
        mov     eax,[PhysMaxY]
        inc     eax
        ret
end;

function GetScreenWidth: DWord;
code;
      asm
        mov     eax,[PhysMaxX]
        inc     eax
        ret
end;

function GetBitsPerPixel: DWord;
begin
  Result := BitsPerPixel;
end;

function GetBytesPerScanLine: DWord;
begin
  Result := BytesPerLine;
end;

function  GetMaxPossibleY: DWord;
code;
      asm
        mov     eax,[MaxPossibleY]
        ret
end;

function GetMaxPage: DWord;
begin
  if VideoMode = isMCGAMode then
   Result := 0
  else
   Result := MaxPage;
end;

procedure SetWriteMode (WriteMode: DWord);
begin
  if WriteMode>3 then
  begin
    GrResult := grError;
    exit;
  end;
  if WriteMode>3 then
  begin
    GrResult := grInvalidMode;
    exit;
  end;
  if (not UseLfb) and (not VirtualMode) then
  begin
    case WriteMode of
      0: begin
           case BytesPerPixel of
             1: PutPixelProc := @PutPixel256Bnk;
             2: PutPixelProc := @PutPixel32kBnk;
             3: PutPixelProc := @PutPixel16mBnk;
             4: PutPixelProc := @PutPixel4GBnk;
           end;
           PutTextelProc := @PutHtextelBnk;
         end;
      1: begin
           case BytesPerPixel of
             1: PutPixelProc := @XorPixel256Bnk;
             2: PutPixelProc := @XorPixel32kBnk;
             3: PutPixelProc := @XorPixel16mBnk;
             4: PutPixelProc := @XorPixel4GBnk;
           end;
           PutTextelProc := @XorHTextelBnk;
         end;
      2: begin
           case BytesPerPixel of
             1: PutPixelProc := @OrPixel256Bnk;
             2: PutPixelProc := @OrPixel32kBnk;
             3: PutPixelProc := @OrPixel16mBnk;
             4: PutPixelProc := @OrPixel4GBnk;
           end;
           PutTextelProc := @OrHTextelBnk;
         end;
      3: begin
           case BytesPerPixel of
             1: PutPixelProc := @AndPixel256Bnk;
             2: PutPixelProc := @AndPixel32kBnk;
             3: PutPixelProc := @AndPixel16mBnk;
             4: PutPixelProc := @AndPixel4GBnk;
           end;
           PutTextelProc := @AndHTextelBnk;
         end;
       end;
     end else
     begin
       case WriteMode of
         0: begin
              case BytesPerPixel of
                1: PutPixelProc := @PutPixel256Lin;
                2: PutPixelProc := @PutPixel32kLin;
                3: PutPixelProc := @PutPixel16mLin;
                4: PutPixelProc := @PutPixel4GLin;
              end;
              PutTextelProc := @PutHTextelLin;
            end;
         1: begin
              case BytesPerPixel of
                1: PutPixelProc := @XorPixel256Lin;
                2: PutPixelProc := @XorPixel32kLin;
                3: PutPixelProc := @XorPixel16mLin;
                4: PutPixelProc := @XorPixel4GLin;
              end;
              PutTextelProc := @XorHTextelLin;
            end;
         2: begin
              case BytesPerPixel of
                1: PutPixelProc := @OrPixel256Lin;
                2: PutPixelProc := @OrPixel32kLin;
                3: PutPixelProc := @OrPixel16mLin;
                4: PutPixelProc := @OrPixel4GLin;
              end;
              PutTextelProc := @OrHTextelLin;
            end;
         3: begin
            case BytesPerPixel of
              1: PutPixelProc := @AndPixel256Lin;
              2: PutPixelProc := @AndPixel32kLin;
              3: PutPixelProc := @AndPixel16mLin;
              4: PutPixelProc := @AndPixel4GLin;
            end;
            PutTextelProc := @AndHTextelLin;
          end;
        end;
      end;
  GrWriteMode := WriteMode;
  GrResult := grOk;
end;

function GetWriteMode: DWord; code;
      asm
        mov     eax,[GrWriteMode]
        ret
end;

procedure SetTranspMode (Mode: Boolean; Color: DWord);
begin
  if (not UseLfb) and (not VirtualMode) then
  begin
   case BytesPerPixel of
    1: if Mode then
        PutTextelProc := @TspHTextel256Bnk
       else
        PutTextelProc := @PutHTextelBnk;
    2: if Mode then
        PutTextelProc := @TspHTextel32kBnk
       else
        PutTextelProc := @PutHTextelBnk;
    3: if Mode then
        PutTextelProc := @TspHTextel16mBnk
       else
        PutTextelProc := @PutHTextelBnk;
    4: if Mode then
        PutTextelProc := @TspHTextel4GBnk
       else
        PutTextelProc := @PutHTextelBnk;
   end;
  end else
  begin
   case BytesPerPixel of
    1: if Mode then
        PutTextelProc := @TspHTextel256Lin
       else
        PutTextelProc := @PutHTextelLin;
    2: if Mode then
        PutTextelProc := @TspHTextel32kLin
       else
        PutTextelProc := @PutHTextelLin;
    3: if Mode then
        PutTextelProc := @TspHTextel16mLin
       else
        PutTextelProc := @PutHTextelLin;
    4: if Mode then
        PutTextelProc := @TspHTextel4GLin
       else
        PutTextelProc := @PutHTextelLin;
   end;
  end;
  TranspColor := Color;
  TspMode := Mode;
  GrResult := grOk;
end;

procedure GetTranspSettings (var Mode: Boolean; var Color: DWord);
code;
      asm
        mov     al,[TspMode]
        mov     edi,[Mode]
        mov     [edi],al
        mov     eax,[TranspColor]
        mov     edi,[Color]
        mov     [edi],eax
        ret
end;

procedure SetAspectRatio (AspectRatio: Real);
begin
  GrAspectRatio := AspectRatio;
end;

procedure GetAspectRatio (var AspectRatio: Real);
begin
  AspectRatio := GrAspectRatio;
end;

procedure SetGraphBufSize (BufSize: DWord);
begin
  if BufferSize>0 then FreeMem(GrBufferPtr,BufferSize);
  GetMem(GrBufferPtr,BufSize);
  if GrBufferPtr<>nil then
  begin
   BufferSize := BufSize;
   GrResult := grOk;
  end else begin
   BufferSize := 0;
   GrResult := grError;
  end;
end;

function GetGraphBufSize: DWord;
code;
      asm
        mov     [GrResult],grOk
        mov     eax,[BufferSize]
        ret
end;

{$ifdef __DOS__}
procedure SetScreenStart(X,Y: DWord; WaitForRetrace: Boolean);
assembler;
      asm
        mov     ecx,[X]
        mov     edx,[Y]
        cmp     [WaitForRetrace],0
        jz      @@DoNotWait
        call    [SetStartAddrWR]
        jmp     @@Cont
@@DoNotWait:
        call    [SetStartAddrNW]
@@Cont: mov     edx,grOk
        cmp     ax,VbeStatusOk
        jz      @@Quit
        mov     edx,grVESAError
@@Quit: mov     [GrResult],edx
end;

///////////////////////////////////////////////////////////////////////////
// Returns VBE Controller Information                                    //
//                                                                       //
// Public                                                                //
///////////////////////////////////////////////////////////////////////////
procedure GetVbeInfo(var VI: VbeInfoType);
var
  Regs: TRmRegs;
begin
  ClearRmRegs(Regs);
  Regs.ES := Buf_16;
  Regs.AX := $4F00;
  Regs.DI := $0000;
  DWord(Pointer(Buf_32)^) := $32454256;
  RealModeInt($10,Regs);
  if (Regs.AX<>VbeStatusOK) or
      (DWord(Pointer(Buf_32)^)<>$41534556) then GrResult := grVESAError
  else
  begin
   Move(Pointer(Buf_32)^,VI,512);
   if (VI.VbeVersion>=$200) and
       (VI.OemVendorNamePtr=0)
        then VI.VbeVersion := $102;
   GrResult := grOk;
  end;
end;

///////////////////////////////////////////////////////////////////////////
// Returns VBE Mode Information                                          //
//                                                                       //
// Public                                                                //
///////////////////////////////////////////////////////////////////////////
procedure GetVbeModeInfo (ModeNo: Word; var VMI: VbeModeInfoType);
var
  Regs: TRmRegs;
begin
  ModeNo := ModeNo and $3FFF;
  if VbeVer=0 then
  begin
   GrResult := grVESANotFound;
   exit;
  end;
  ClearRmRegs(Regs);
  Regs.ES := Buf_16;
  Regs.AX := $4F01;
  Regs.DI := $0000;
  Regs.CX := ModeNo;
  RealModeInt($10,Regs);
  Move(Pointer(Buf_32)^,VMI,256);
  if (Regs.AX<>VbeStatusOK) or ((VMI.ModeAttributes and vbeMdAvailable)=0)
   then GrResult := grVESAError else
   begin
   if (VMI.MemoryModel=vbeMemPK) and (VMI.BitsPerPixel>8) then
   begin
    VMI.MemoryModel := vbeMemRGB;
    case VMI.BitsPerPixel of
     15: begin
          VMI.RedMaskSize := 5;
          VMI.RedFieldPosition := 10;
          VMI.GreenMaskSize := 5;
          VMI.GreenFieldPosition := 5;
          VMI.BlueMaskSize := 5;
          VMI.BlueFieldPosition := 0;
          VMI.RsvdMaskSize := 1;
          VMI.RsvdFieldPosition := 15;
         end;
     16: begin
          VMI.RedMaskSize := 5;
          VMI.RedFieldPosition := 11;
          VMI.GreenMaskSize := 5;
          VMI.GreenFieldPosition := 5;
          VMI.BlueMaskSize := 5;
          VMI.BlueFieldPosition := 0;
          VMI.RsvdMaskSize := 0;
          VMI.RsvdFieldPosition := 0;
         end;
     24: begin
          VMI.RedMaskSize := 8;
          VMI.RedFieldPosition := 16;
          VMI.GreenMaskSize := 8;
          VMI.GreenFieldPosition := 8;
          VMI.BlueMaskSize := 8;
          VMI.BlueFieldPosition := 0;
          VMI.RsvdMaskSize := 0;
          VMI.RsvdFieldPosition := 0;
         end;
    end;
   end;
   if (VbeVer<$200) and (VMI.NumberOfImagePages=0) and
      (VMI.XResolution>0) and (VMI.YResolution>0) then
       VMI.NumberOfImagePages := ((TotalMem*1024) div VMI.BytesPerScanLine div VMI.YResolution)-1;
   if (VMI.BitsPerPixel=16) and (VMI.RsvdMaskSize=1)
    then VMI.BitsPerPixel := 15;
   GrResult := grOk;
  end;
end;

///////////////////////////////////////////////////////////////////////////
// Rerurns null-terminated string from specified address in lower memory //
//                                                                       //
// Private                                                               //
///////////////////////////////////////////////////////////////////////////
function VbeGetStr(VbeStringPtr: DWord): String;
var
  Addr: DWord;
begin
  Addr := ((VbeStringPtr shr 16) shl 4)+Word(VbeStringPtr);
  Result := '';
  repeat
   Result := Result+Char(Pointer(Addr)^);
   inc(Addr);
  until Byte(Pointer(Addr)^)=0;
end;

///////////////////////////////////////////////////////////////////////////
// Creates VBE supported modes table                                     //
//                                                                       //
// Private                                                               //
///////////////////////////////////////////////////////////////////////////
procedure CreateModeTable (VideoModePtr: DWord);
var
  ModeNo  : DWord;
  ModeInfo: VbeModeInfoType;
  Addr    : DWord;
  i,j     : DWord;
  ModesTmp: array [0..MaxVbeModes] of Word;
begin
  FillChar(ModesTmp,SizeOf(ModesTmp),0);
  Addr := ((VideoModePtr shr 16) shl 4)+Word(VideoModePtr);
  i := 0;
  repeat
   if Word((Pointer(Addr)^))>=$100 then ModesTmp[i] := Word((Pointer(Addr)^));
   Inc(Addr,2);
   Inc(i);
  until (i>MaxVbeModes) or (ModesTmp[i]=$FFFF);
  ModesTmp[i] := $FFFF;
  i := 0; j := 0;
  repeat
   ModeNo := ModesTmp[j];
   if (ModeNo>$00FF) and (ModeNo<$FFFF) then
   begin
    GetVbeModeInfo(ModeNo,ModeInfo);
    if GrResult=grOk then begin
     if (ModeInfo.BitsPerPixel>0) and
        (ModeInfo.XResolution>0) and
        (ModeInfo.YResolution>0) and
        (TotalVbeMemory>=(DWord(ModeInfo.BitsPerPixel+1) div 8)*
        (DWord(ModeInfo.XResolution)*DWord(ModeInfo.YResolution))) and
        ((ModeInfo.ModeAttributes and $18)=$18) then
     begin
      VbeModesList[i].VideoMode := ModeNo;
      VbeModesList[i].BitsPerPixel := ModeInfo.BitsPerPixel;
      VbeModesList[i].XResolution := ModeInfo.XResolution;
      VbeModesList[i].YResolution := ModeInfo.YResolution;
      if ((ModeInfo.ModeAttributes and VbeMdLinear)>0)
        and (ModeInfo.PhysBasePtr>0) then
        begin
         VbeModesList[i].HaveLFB := MapPhysicalToLinear(LfbPtr, TotalMem * 1024) <> 0;
         LfbPtr := ModeInfo.PhysBasePtr;
        end else
         VbeModesList[i].HaveLFB := FALSE;
      Inc(i);
     end;
    end;
   end;
   Inc(j);
  until ModeNo=$FFFF;
  VbeModes := i;
end;
{$endif}

///////////////////////////////////////////////////////////////////////////
// Returns an error code for the last graphics operation.                //
//                                                                       //
// Public                                                                //
///////////////////////////////////////////////////////////////////////////
function GraphResult: LongInt;
code;
      asm
        mov     eax,[GrResult]
        ret
end;

function GraphErrorMsg(ErrorCode: LongInt): String;
begin
  case ErrorCode of
   grOK               : Result := 'No error';
   grInvalidMode      : Result := 'Invalid graphics mode';
   grModeNotSupported : Result := 'Mode not supported';
   grSetModeError     : Result := 'Set mode error';
   grLFBSetupError    : Result := 'LFB setup error';
   grError            : Result := 'Graphics error (generic error)';
   grVESANotFound     : Result := 'VESA VBE not found';
   grVESAError        : Result := 'VESA VBE error';
   grNoGraphMem       : Result := 'Not enough memory';
   grDirectXNotFound  : Result := 'DirectX not found';
   grDirectXError     : Result := 'Error';
  else
   Result := ''
  end;
end;

procedure ClearViewPort;
assembler;
      asm
        mov     al, [UseSolidFill]
        push    eax
        push    [FillColor]
        xor     eax,eax
        mov     [CpX],eax
        mov     [CpY],eax
        push    eax
        push    eax
        mov     [UseSolidFill], 1
        mov     eax,[BkGrColor]
        mov     [FillColor],eax
        push    [WndX2]
        push    [WndY2]
        call    Bar
        pop     [FillColor]
        pop     eax
        mov     [UseSolidFill], al
end;

procedure SetViewPort (X1,Y1,X2,Y2: LongInt; Clip: Boolean);
begin
  if (X1>=X2) or (Y1>=Y2) then
   GrResult := grError
  else begin
   CurViewPort.X1 := X1;
   CurViewPort.Y1 := Y1;
   CurViewPort.X2 := X2;
   CurViewPort.Y2 := Y2;
   CurViewPort.Clip := Clip;
   if Clip then
   begin
    if X1<0 then WndX1 := 0 else WndX1 := X1;
    if Y1<0 then WndY1 := 0 else WndY1 := Y1;
    if X2>=VpWidth then WndX2 := VpWidth-1 else WndX2 := X2;
    if Y2>=VpHeight then WndY2 := VpHeight-1 else WndY2 := Y2;
   end else
   begin
    WndX1 := 0;
    WndY1 := 0;
    WndX2 := VpWidth-1;
    WndY2 := VpHeight-1;
   end;
   AddX := X1;
   AddY := Y1;
   GrResult := grOk;
  end;
  CpX := 0;
  CpY := 0;
end;

procedure GetViewSettings(var ViewPort: ViewPortType);
begin
  ViewPort := CurViewPort;
end;

function SetScanLine(Pixels: Word): Word;
assembler;
      asm
        cmp     [VideoMode],isSVGAMode
        jz      @@Cont1
        mov     [GrResult],grInvalidMode
        jmp     @@Quit
@@Cont1:
        movzx   eax,[Pixels]
        cmp     eax,[PhysMaxX]
        jg      @@Cont2
        mov     [GrResult],grError
        xor     eax,eax
        jmp     @@Quit
@@Cont2:
        mov     cx,ax
        mov     ax,4F06h
        xor     bx,bx
        int     10h
        mov     ax,cx
        and     ebx,0FFFFh
        and     edx,0FFFFh
        mov     [BytesPerLine],ebx
        mov     [MaxPossibleY],edx
        mov     [GrResult],grOk
@@Quit:
end;

procedure SetLogicalPage (SX,SY: Word);
var
  LB,LX,LY: DWord;
begin
{$ifdef __DOS__}
  if VirtualMode then
  begin
   GrResult := grError;
   exit;
  end;
  LX := VpWidth;
  LY := MaxPossibleY;
  LB := BytesPerLine;
  VpWidth := SetScanLine(Word(SX));
  if (VpWidth<=PhysMaxX) or (MaxPossibleY<=PhysMaxY) or
     (BytesPerLine=0) or (GrResult<>grOk) then
  begin
   SetScanLine(LX);
   VpWidth := LX;
   MaxPossibleY := LY;
   BytesPerLine := LB;
   if GrResult=0 then
     GrResult  :=  grVESAError;
   exit;
  end;
  if SY<=MaxPossibleY then
    VpHeight := SY
  else
    VpHeight := MaxPossibleY;
  PageSize := GetPageSize;
  MaxPage := (TotalMem*1024 div PageSize)-1;
  if MaxPage>PossibleMaxPage then MaxPage := PossibleMaxPage;
  SetViewPort(0,0,VpWidth-1,VpHeight-1,ClipOn);
{$endif}
end;

procedure GetLogicalPage(var SX,SY: Word);
begin
  SX  :=  Word(VpWidth);
  SY  :=  Word(VpHeight);
end;

{$ifdef __DOS__}
///////////////////////////////////////////////////////////////////////////
// Initialize VESAlib global variables                                   //
//                                                                       //
// Private                                                               //
///////////////////////////////////////////////////////////////////////////
procedure InitVbe;
var
  VI: VbeInfoType;
begin
  GetVBEInfo(VI);
  if GrResult=grOk then
  begin
   VbeVer := VI.VbeVersion;
   VbeCap := VI.Capabilities;
   TotalMem := VI.TotalMemory shl 6;
   OemString := VbeGetStr(VI.OemStringPtr);
   if VbeVer>=$200 then
   begin
    OemVendor := VbeGetStr(VI.OemVendorNamePtr);
    OemProduct := VbeGetStr(VI.OemProductNamePtr);
    OemProductRev := VbeGetStr(VI.OemProductRevPtr);
   end;
   CreateModeTable(VI.VideoModePtr);
   GrResult := grOk;
  end else GrResult := grVESANotFound;
end;

function GetVbeVersion: DWord;
begin
  if VbeVer=0 then GrResult := grVESANotFound else
  begin
   Result := VbeVer;
   GrResult := grOk;
  end;
end;

function GetOemString: String;
begin
  if VbeVer=0 then
  begin
   GrResult := grVESANotFound;
   Result := '';
  end else
  begin
   Result := OemString;
   GrResult := grOk;
  end;
end;

function GetOemVendorName: String;
begin
  if VbeVer<$200 then
  begin
   GrResult := grVESAError;
   Result := '';
  end else
  begin
   Result := OemVendor;
   GrResult := grOk;
  end;
end;

function GetOemProductName: String;
begin
  if VbeVer<$200 then
  begin
   GrResult := grVESAError;
   Result := '';
  end else
  begin
   Result := OemProduct;
   GrResult := grOk;
  end;
end;

function GetOemProductRev: String;
begin
  if VbeVer<$200 then
  begin
   GrResult := grVESAError;
   Result := '';
  end else
  begin
   Result := OemProductRev;
   GrResult := grOk;
  end;
end;

function GetGraphMode: Word;
var
  Regs: TRmRegs;
begin
  ClearRmRegs(Regs);
  if VbeVer = 0 then
  begin
   Regs.AH := $0F;
   RealModeInt($10,Regs);
   Result := Regs.AX and $FF;
   GrResult := grOk
  end else
  begin
   Regs.AX := $4F03;
   RealModeInt($10,Regs);
   if Regs.AX=VbeStatusOk then
    GrResult := grOk
   else
    GrResult := grVESAError;
   Result := Regs.BX;
  end;
end;

//////////////////////////////////////////////////////////////////////////
// Sets VGA/VESA video mode                                             //
//                                                                      //
// Private                                                              //
//////////////////////////////////////////////////////////////////////////
function SetBIOSMode (Mode: Word): Boolean;
var
  Regs: TRmRegs;
begin
  if (Mode>$100) and (TotalMem<256) then
  begin
   Result := FALSE;
   exit;
  end;
  ClearRmRegs(Regs);
  if Mode<$100 then
  begin
   Regs.AL := Byte(Mode);
   RealModeInt($10,Regs);
   Result := TRUE;
  end else
  begin
   if VbeVer>0 then
   begin
    Regs.AX := $4F02;
    Regs.BX := Mode;
    RealModeInt($10,Regs);
    Result := Regs.AX=VbeStatusOk;
   end else
    Result := FALSE;
  end;
end;
{$endif}

//////////////////////////////////////////////////////////////////////////
// Returns number of availible VESA VBE modes                           //
//                                                                      //
// Public                                                               //
//////////////////////////////////////////////////////////////////////////
function TotalVbeModes: DWord;
{$ifdef __DOS__}
code;
      asm
        mov     eax,[VbeModes]
        ret
end;
{$endif}
{$ifdef __WIN32__}
begin
  Result := DD_ModeCnt;
end;
{$endif}

{$ifdef __WIN32__}
function GetWindowHandle: THandle;
begin
  Result  :=  DirectXWnd;
end;

function GetPageDC(PageNo: DWORD): HDC;
begin
  case PageNo of
    0: begin
         if PrimDC = 0 then
           LpPrim^^.GetDC(LpPrim, PrimDC);
         Result := PrimDC;
       end;
    1: begin
         if BackDC = 0 then
           LpBack^^.GetDC(LpBack, BackDC);
         Result := BackDC;
       end;
  else
    GrResult := grError;
  end;
end;

procedure ReleasePageDC(PageNo: DWORD);
begin
  case PageNo of
    0: begin
         if PrimDC <> 0 then
           LpPrim^^.ReleaseDC(LpPrim, PrimDC);
         PrimDC := 0;
       end;
    1: begin
         if BackDC <> 0 then
           LpBack^^.ReleaseDC(LpBack, BackDC);
         BackDC := 0;
       end;
  else
    GrResult := grError;
  end;
end;
{$endif}

procedure GetVbeModesList(var ModesList);
begin
{$ifdef __DOS__}
  Move(VbeModesList,ModesList,SizeOf(VbeModesList));
{$endif}
{$ifdef __WIN32__}
  EnumDisplayModes;
  Move(GraphModesList, ModesList, SizeOf(GraphModesList));
{$endif}
end;

function TotalVbeMemory: DWord;
begin
{$ifdef __DOS__}
  if VbeVer=0 then
    GrResult := grVESANotFound
  else
  begin
    Result := TotalMem*1024;
    GrResult := grOk;
  end;
{$endif}
{$ifdef __WIN32__}
  if not DirectXEnabled then
  begin
    DirectXEnabled := DD_Init;
    if DD_VideoMem = 0 then EnumDisplayModes;
    Result := DD_VideoMem;
  end;
{$endif}
end;

//////////////////////////////////////////////////////////////////////////
// Initialize some mode variables                                       //
//                                                                      //
// Public                                                               //
//////////////////////////////////////////////////////////////////////////
procedure GraphDefaults;
begin
  clBlack := 0;
  if BytesPerPixel>1 then
  begin
   clBlue := RGBColor(0,0,$A8);
   clGreen := RGBColor(0,$A8,0);
   clCyan := RGBColor(0,$A8,$A8);
   clRed := RGBColor($A8,0,0);
   clMagenta := RGBColor($A8,0,$A8);
   clBrown := RGBColor($A8,$54,0);
   clLightGray := RGBColor($A8,$A8,$A8);
   clDarkGray := RGBColor($54,$54,$54);
   clLightBlue := RGBColor($54,$54,$FC);
   clLightGreen := RGBColor($54,$FC,$54);
   clLightCyan := RGBColor($54,$FC,$FC);
   clLightRed := RGBColor($FC,$54,$54);
   clLightMagenta := RGBColor($FC,$54,$FC);
   clYellow := RGBColor($FC,$FC,$54);
   clWhite := RGBColor($FC,$FC,$FC);
  end else
  begin
   clBlue := 1;
   clGreen := 2;
   clCyan := 3;
   clRed := 4;
   clMagenta := 5;
   clBrown := 6;
   clLightGray := 7;
   clDarkGray := 8;
   clLightBlue := 9;
   clLightGreen := 10;
   clLightCyan := 11;
   clLightRed := 12;
   clLightMagenta := 13;
   clYellow := 14;
   clWhite := 15;
  end;
  if VideoMode=isMCGAMode then
   MaxPossibleY := 200
  else
   MaxPossibleY := DWord(TotalMem)*1024 div BytesPerLine;
  if BitsPerPixel=8 then SetAllPalette(DefaultPal);
  SetViewPort(0,0,VpWidth-1,VpHeight-1,FALSE);
  SetLineStyle(SolidLn,$FFFF,NormWidth);
  SetColor(clWhite);
  SetFillColor(clBlack);
  SetBkColor(clBlack);
  GrAspectRatio := (PhysMaxY/PhysMaxX)*1.344;
  SetTranspMode(FALSE,clBlack);
  SetTextStyle(LargeFont,HorizDir);
  SetTextJustify(LeftText,TopText);
  SetSplineSteps(30);
  GrResult := grOk;
  DefaultFont := 2;
  if PhysMaxY<=480 then DefaultFont := 1;
  if PhysMaxY<=300 then DefaultFont := 0;
end;

function IsLFBUsed: Boolean;
begin
  Result := (UseLfb) and (VideoMode=isSVGAMode) and (VbeVer>0);
end;

function GetScreenPtr: Pointer;
begin
  Result := Pointer(ScreenPtr);
end;

{$ifdef __DOS__}
procedure Stretch(Param: Byte);
assembler;
      asm
        mov     al,09h
        mov     dx,CRTC_ADDR
        out     dx,al
        inc     dx
        in      al,dx
        and     al,0E0h
        add     al,[Param]
        out     dx,al
end;

function GetLfbAddress: DWord;
code;
      asm
        mov     eax,[LfbPtr]
        ret
end;

function GetVbeCapabilities: DWord;
code;
      asm
        mov     eax,[VbeCap]
        ret
end;

//////////////////////////////////////////////////////////////////////////
// Sets MCGA 320x200x256 video mode and initialize global varisbles     //
//                                                                      //
// Public                                                               //
//////////////////////////////////////////////////////////////////////////
procedure SetMCGAMode;
begin
  MaxPossibleY := 199;
  UseLfb := TRUE;
  PhysMaxX := 319;
  PhysMaxY := 199;
  BitsPerPixel := 8;
  BytesPerPixel := 1;
  BytesPerLine := 320;
  VpHeight := 200;
  VpWidth := 320;
  PageSize := 64000;
  MaxPage := 0;
  GrMaxColor := 255;
  VideoPtr := $A0000;
  VideoPagePtr := VideoPtr;
  PutTextelProc := @PutHtextelLin;
  GetTextelProc := @GetHtextelLin;
  PutPixelProc := @PutPixel256Lin;
  GetPixelProc := @GetPixel256Lin;
  HLineProc := @DrawHLine256Lin;
  ClearPageProc := @ClearPage256Lin;
  FlipToScrProc := @FlipToScreenLin;
  FlipToMemProc := @FlipToMemoryLin;
  VideoMode := isMCGAMode;
  SetBIOSMode($13);
  GetPalette(DefaultPal);
  GraphDefaults;
end;

///////////////////////////////////////////////////////////////////////////
// Creates bank table                                                    //
//                                                                       //
// Private                                                               //
///////////////////////////////////////////////////////////////////////////
procedure CreateBankTable(WinGran: Word);
assembler;
      asm
        mov     edi,offset BankTable
        xor     ecx,ecx
@@BankLoop:
        mov     eax,ecx
        mov     bx,64
        mul     bx
        mov     bx,[WinGran]
        jcxz    @@be
        div     bx
@@be:   mov     [edi],ax
        add     edi,2
        inc     ecx
        cmp     ecx,256
        jb      @@BankLoop
end;

////////////////////////////////////////////////////////////////////////////
// Sets the read/write bank A by calling INT 10h (SLOW)                   //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure VESA_SetBankA;
code;
      asm
        push    eax
        push    ebx
        push    ecx
        push    edx
        and     edx,0FFh
        mov     [CurBank],dx
        mov     ebx,offset BankTable
        add     edx,edx
        add     ebx,edx
        mov     dx,[ebx]
        mov     eax,4F05h
        xor     ebx,ebx
        int     10h
        pop     edx
        pop     ecx
        pop     ebx
        pop     eax
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Sets both read/write banks A and B by calling INT 10h (SLOW)           //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure VESA_SetBankAB;
code;
      asm
        push    eax
        push    ebx
        push    ecx
        push    edx
        and     edx,0FFh
        mov     [CurBank],dx
        mov     ebx,offset BankTable
        add     edx,edx
        add     ebx,edx
        mov     dx,[ebx]
        push    edx
        mov     eax,4F05h
        xor     ebx,ebx
        int     10h
        pop     edx
        mov     eax,4F05h
        mov     ebx,1
        int     10h
        pop     edx
        pop     ecx
        pop     ebx
        pop     eax
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Sets the read/write bank A by calling PM VBE function  (FAST)          //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure VESA2_SetBankA;
code;
      asm
        push    eax
        push    ebx
        push    ecx
        push    edx
        and     edx,0FFh
        mov     [CurBank],dx
        mov     ebx,offset BankTable
        add     edx,edx
        add     ebx,edx
        mov     dx,[ebx]
        mov     eax,4F05h
        xor     ebx,ebx
        call    [BankProc]
        pop     edx
        pop     ecx
        pop     ebx
        pop     eax
        ret
end;

////////////////////////////////////////////////////////////////////////////
// Sets both read/write banks A and B by calling PM VBE function (FAST)   //
//                                                                        //
// Private                                                                //
////////////////////////////////////////////////////////////////////////////
procedure VESA2_SetBankAB;
code;
      asm
        push    eax
        push    ebx
        push    ecx
        push    edx
        and     edx,0FFh
        mov     [CurBank],dx
        mov     ebx,offset BankTable
        add     edx,edx
        add     ebx,edx
        mov     dx,[ebx]
        push    edx
        mov     eax,4F05h
        xor     ebx,ebx
        call    [BankProc]
        pop     edx
        mov     eax,4F05h
        mov     ebx,1
        call    [BankProc]
        pop     edx
        pop     ecx
        pop     ebx
        pop     eax
        ret
end;

////////////////////////////////////////////////////////////////////////////
// VBEFunc07 - Sets screen start on VESA 1.2/2.0, WaitForRetrace=FALSE
////////////////////////////////////////////////////////////////////////////
//
// Private
////////////////////////////////////////////////////////////////////////////
procedure VESA_Func07NW;
code;
      asm
        mov     eax,04F07h
        xor     ebx,ebx
        int     10h
        ret
end;

////////////////////////////////////////////////////////////////////////////
// VBEFunc07 - Sets screen start on VESA 1.2, WaitForRetrace=TRUE
////////////////////////////////////////////////////////////////////////////
//
// Private
////////////////////////////////////////////////////////////////////////////
procedure VESA_Func07W1;
code;
      asm
        push    edx
        mov     edx,STAT_ADDR
@@WaitDE:
        in      al,dx
        test    al,1
        jnz     @@WaitDE
        pop     edx

        mov     eax,04F07h
        xor     ebx,ebx
        int     10h
        push    eax

        mov     edx,STAT_ADDR
@@WaitVS:
        in      al,dx
        test    al,8
        jz      @@WaitVS
        pop     eax
        ret
end;

////////////////////////////////////////////////////////////////////////////
// VBEFunc07 - Sets screen start on VESA 2.0, WaitForRetrace=TRUE
////////////////////////////////////////////////////////////////////////////
//
// Private
////////////////////////////////////////////////////////////////////////////
procedure VESA_Func07W2;
code;
      asm
        mov     eax,04F07h
        mov     ebx,80h
        int     10h
        ret
end;
{$endif}

procedure ProcsReset;
begin
  DrawBorder := TRUE;
  VirtualMode := FALSE;
  FlipToScrProc := @DummyProc;
  FlipToMemProc := @DummyProc;
  ClearPageProc := @DummyProc;
  PutPixelProc := @DummyProc;
  GetPixelProc := @DummyProc;
  PutTextelProc := @DummyProc;
  GetTextelProc := @DummyProc;
  SetStartAddrWR := @DummyProc;
  SetStartAddrNW := @DummyProc;
  HLineProc := @DummyProc;
  GrAspectRatio := 0;
  BitsPerPixel := 0;
  BytesPerPixel := 0;
  BytesPerLine := 0;
  VideoMode := isUnsupported;
end;

{$ifdef __DOS__}
//////////////////////////////////////////////////////////////////////////
// Sets VESA VBE video mode and initialize global varisbles             //
//                                                                      //
// Public                                                               //
//////////////////////////////////////////////////////////////////////////
procedure SetGraphMode(VbeMode: Word);
var
  VMI:    VbeModeInfoType;
  Regs:   TRmRegs;
  wOfs:   Word;
  pmAddr: DWord;
begin
  if BufferSize>0 then FreeMem(GrBufferPtr,BufferSize);
  GetMem(GrBufferPtr,2048);
  BufferSize := 2048;
  if VbeMode=$13 then
  begin
   SetMCGAMode;
   exit;
  end;
  if VbeMode<100 then
  begin
   SetBIOSMode(VbeMode);
   VideoMode := IsUnsupported;
   ProcsReset;
   exit;
  end;
 (* Get info for VESA VBE mode *)
  GetVbeModeInfo(VbeMode, VMI);
  if GrResult<>0 then
  begin
    if GrResult<>grVESANotFound then GrResult := grModeNotSupported;
    exit;
  end;
 (* Setup global variables for direct color modes *)
  DcRedAdjust := 8-VMI.RedMaskSize;
  DcRedMask := $FF shr DcRedAdjust;
  DcRedPos := VMI.RedFieldPosition;
  DcGreenAdjust := 8-VMI.GreenMaskSize;
  DcGreenMask := $FF shr DcGreenAdjust;
  DcGreenPos := VMI.GreenFieldPosition;
  DcBlueAdjust := 8-VMI.BlueMaskSize;
  DcBlueMask := $FF shr DcBlueAdjust;
  DcBluePos := VMI.BlueFieldPosition;
 (* PhysMaxX and PhysMaxY = physical size of page *)
  PhysMaxX := VMI.XResolution-1;
  PhysMaxY := VMI.YResolution-1;
  BitsPerPixel := VMI.BitsPerPixel;
  BytesPerPixel := (VMI.BitsPerPixel+1) div 8;
  BytesPerLine := VMI.BytesPerScanLine;
  VpHeight := VMI.YResolution;
  VpWidth := VMI.XResolution;
  PageSize := GetPageSize;
  PossibleMaxPage := VMI.NumberOfImagePages;
  if PossibleMaxPage>(TotalMem*1024 div PageSize)-1 then
   PossibleMaxPage := (TotalMem*1024 div PageSize)-1;
  MaxPage := PossibleMaxPage;
  case BitsPerPixel of
   8:     GrMaxColor := 255;
   15:    GrMaxColor := 32767;
   16:    GrMaxColor := 65535;
   24,32: GrMaxColor := 16777215
  end;
  if ((VbeMode and VbeLinearBuffer)>0) and
     ((VMI.ModeAttributes and VbeMdLinear)>0) and
     (LfbPtr>0) then
  begin
   if LfbAddress=0 then
      LfbAddress := MapPhysicalToLinear(LfbPtr, TotalMem*1024);
   if LfbAddress=0 then
   begin
    GrResult := grLFBSetupError;
    exit;
   end;
   VideoPtr := LfbAddress;
   VideoPagePtr := VideoPtr;
   PutTextelProc := @PutHtextelLin;
   GetTextelProc := @GetHtextelLin;
   SetStartAddrWR := @VESA_Func07W2;
   SetStartAddrNW := @VESA_Func07NW;
   FlipToScrProc := @FlipToScreenLin;
   FlipToMemProc := @FlipToMemoryLin;
   case BytesPerPixel of
    1: begin
         PutPixelProc := @PutPixel256Lin;
         GetPixelProc := @GetPixel256Lin;
         HLineProc := @DrawHLine256Lin;
         ClearPageProc := @ClearPage256Lin;
       end;
    2: begin
         PutPixelProc := @PutPixel32kLin;
         GetPixelProc := @GetPixel32kLin;
         HLineProc := @DrawHLine32kLin;
         ClearPageProc := @ClearPage32kLin;
       end;
    3: begin
         PutPixelProc := @PutPixel16mLin;
         GetPixelProc := @GetPixel16mLin;
         HLineProc := @DrawHLine16mLin;
         ClearPageProc := @ClearPage16mLin;
       end;
    4: begin
         PutPixelProc := @PutPixel4GLin;
         GetPixelProc := @GetPixel4GLin;
         HLineProc := @DrawHLine4GLin;
         ClearPageProc := @ClearPage4GLin;
       end;
   end;
   UseLfb := TRUE;
  end else
  begin
   CreateBankTable(VMI.WinGranularity);
   VideoPtr := DWord(VMI.WinASegment) shl 4;
   OriginOffset := 0;
   CurBank := 0;
   BankOffset := 0;
   if (VMI.WinAAttributes and $07)<>$07 then
    BankFunc := @VESA_SetBankAB
   else
    BankFunc := @VESA_SetBankA;
   PutTextelProc := @PutHtextelBnk;
   GetTextelProc := @GetHtextelBnk;
   SetStartAddrWR := @VESA_Func07W1;
   SetStartAddrNW := @VESA_Func07NW;
   FlipToScrProc := @FlipToScreenBanked;
   FlipToMemProc := @FlipToMemoryBanked;
   case BytesPerPixel of
    1: begin
         PutPixelProc := @PutPixel256Bnk;
         GetPixelProc := @GetPixel256Bnk;
         HLineProc := @DrawHLine256Bnk;
         ClearPageProc := @ClearPage256Bnk;
       end;
    2: begin
         PutPixelProc := @PutPixel32kBnk;
         GetPixelProc := @GetPixel32kBnk;
         HLineProc := @DrawHLine32kBnk;
         ClearPageProc := @ClearPage32kBnk;
       end;
    3: begin
         PutPixelProc := @PutPixel16mBnk;
         GetPixelProc := @GetPixel16mBnk;
         HLineProc := @DrawHLine16mBnk;
         ClearPageProc := @ClearPage16mBnk;
       end;
    4: begin
         PutPixelProc := @PutPixel4GBnk;
         GetPixelProc := @GetPixel4GBnk;
         HLineProc := @DrawHLine4GBnk;
         ClearPageProc := @ClearPage4GBnk;
       end;
   end;
   UseLfb := FALSE;
  end;

  if VbeVer>=$200 then
  begin
   ClearRmRegs(Regs);
   Regs.AX := $4F0A;
   Regs.BX := $0000;
   RealModeInt($10,Regs);
   if Regs.AX=VbeStatusOk then
   begin
    if PmCodeSize>0 then FreeMem(PmCode,PmCodeSize);
    PmCodeSize := Regs.ECX and $FFFF;
    GetMem(PmCode,PmCodeSize);
    pmAddr := (DWord(Regs.ES) shl 4)+Regs.DI;
    Move(Pointer(pmAddr)^,PmCode^,PmCodeSize);
    BankProc := DWord(PmCode)+(DWord(Pointer(PmCode)^) and $FFFF);
    if (VMI.WinAAttributes and $07)<>$07 then
     //BankFunc := @VESA2_SetBankAB
       BankFunc := @VESA_SetBankAB
    else
     //BankFunc := @VESA2_SetBankA;
     BankFunc := @VESA_SetBankA;
   end;
  end;
  if not SetBIOSMode(VbeMode) then
  begin
   ProcsReset;
   GrResult := grSetModeError;
   ProcsReset;
   exit;
  end;
  VideoMode := isSVGAMode;
  if ((VMI.ModeAttributes and $18) <> $18) or (VMI.BitsPerPixel<8) then
  ProcsReset else
  begin
   if BitsPerPixel=8 then GetPalette(DefaultPal);
   GraphDefaults;
  end;
  ScreenPtr := VideoPtr;
  SetFillStyle(SolidFill, clWhite);
  GrResult  :=  grOk;
end;

function DetectSVGAMode(XRes,YRes,BPP,VMode: DWord): DWord;
var
  i: DWord;
begin
 Result := 0;
 for i := 0 to VbeModes do
 begin
  if (VbeModesList[i].BitsPerPixel=BPP) and
     (VbeModesList[i].XResolution=XRes) and
     (VbeModesList[i].YResolution=YRes) and (BPP>=8) then
     begin
      Result := VbeModesList[i].VideoMode;
       if (VMode=LFBOnly) then
       begin
        if (VbeModesList[i].HaveLFB) then
         Result := Result+$4000
        else Result := 0;
       end;
       if (VMode=LFBorBanked) and (VbeModesList[i].HaveLFB) then
        Result := Result+$4000
   end;
  end;
  if Result>0 then
    grResult := grOk
  else
    GrResult := grVESAnotFound;
end;
{$endif}

procedure StoreModeVariables;
begin
  sVideoPtr := VideoPtr;
  sVideoPagePtr := VideoPagePtr;
  sBankOffset := BankOffset;
  sOriginOffset := OriginOffset;
  sPutTextelProc := PutTextelProc;
  sGetTextelProc := GetTextelProc;
  sPutPixelProc := PutPixelProc;
  sGetPixelProc := GetPixelProc;
  sHLineProc := HLineProc;
  sClearPageProc := ClearPageProc;
end;

procedure RestoreModeVariables;
begin
  VideoPtr := sVideoPtr;
  VideoPagePtr := sVideoPagePtr;
  BankOffset := sBankOffset;
  OriginOffset := sOriginOffset;
  PutTextelProc := sPutTextelProc;
  GetTextelProc := sGetTextelProc;
  PutPixelProc := sPutPixelProc;
  GetPixelProc := sGetPixelProc;
  HLineProc := sHLineProc;
  ClearPageProc := sClearPageProc;
end;

procedure ResetModeVariables;
begin
  VideoPtr := 0;
  VideoPagePtr := 0;
  BankOffset := 0;
  OriginOffset := 0;
  PutTextelProc := @DummyProc;
  GetTextelProc := @DummyProc;
  PutPixelProc := @DummyProc;
  GetPixelProc := @DummyProc;
  HLineProc := @DummyProc;
  ClearPageProc := @DummyProc;
end;

procedure SetVirtualMode(BuffAddr: Pointer);
begin
  if VirtualMode then
  begin
   GrResult := grError;
   exit;
  end;
  if VideoMode=isUnsupported then
  begin
   GrResult := grError;
   exit;
  end;
  StoreModeVariables;
  GrResult := grOk;
  VideoPtr := DWord(BuffAddr);
  VideoPagePtr := VideoPtr;
  BankOffset := 0;
  OriginOffset := 0;
  PutTextelProc := @PutHtextelLin;
  GetTextelProc := @GetHtextelLin;
  case BytesPerPixel of
    1: begin
         PutPixelProc := @PutPixel256Lin;
         GetPixelProc := @GetPixel256Lin;
         HLineProc := @DrawHLine256Lin;
         ClearPageProc := @ClearPage256Lin;
       end;
    2: begin
         PutPixelProc := @PutPixel32kLin;
         GetPixelProc := @GetPixel32kLin;
         HLineProc := @DrawHLine32kLin;
         ClearPageProc := @ClearPage32kLin;
       end;
    3: begin
         PutPixelProc := @PutPixel16mLin;
         GetPixelProc := @GetPixel16mLin;
         HLineProc := @DrawHLine16mLin;
         ClearPageProc := @ClearPage16mLin;
       end;
    4: begin
         PutPixelProc := @PutPixel4GLin;
         GetPixelProc := @GetPixel4GLin;
         HLineProc := @DrawHLine4GLin;
         ClearPageProc := @ClearPage4GLin;
       end;
   end;
   VirtualMode := TRUE;
end;

procedure SetNormalMode;
begin
  if not VirtualMode then
  begin
   GrResult := grError;
   exit;
  end;
  RestoreModeVariables;
  VirtualMode := FALSE;
  GrResult := grOk;
end;

{$ifdef __DOS__}
procedure SetSVGAMode (XRes,YRes,BPP,VMode: DWord);
var
  i: DWord;
  Mode: Word;
begin
  Mode := DetectSVGAMode(XRes,YRes,BPP,VMode);
  if Mode=0 then
  begin
   GrResult := grModeNotSupported;
   exit;
  end;
  SetGraphMode(Mode);
  if (GrResult<>0) and (VMode=LFBorBanked) and (Mode>$4000) then
  SetGraphMode(Mode-$4000);
end;
{$endif}

{$ifdef __WIN32__}
procedure Terminate;
begin
  Halt(255);
end;

{$system}
procedure WindowChar(Ch: Char);
begin
  if (not IgnoreBreak) and (Ch = #3) then Terminate;
  if %KeyNumber < SizeOf(%KeyBuffer) - 1 then
  begin
    %KeyBuffer[%KeyNumber]  :=  Ch;
    %KeyNumber +:=  1;
  end;
end;

procedure WindowKeyDown(KeyDown: Byte);
var
  CtrlDown: Boolean;
  I: Longint;
begin
  if (not IgnoreBreak) and (KeyDown = vk_Cancel) then Terminate;
  CtrlDown  :=  GetKeyState(vk_Control) < 0;
  case KeyDown of
    vk_Escape: begin WindowChar(#0); WindowChar(#01); end;
    vk_Menu  : begin WindowChar(#0); WindowChar(#56); end;
    vk_Insert: begin WindowChar(#0); WindowChar(#82); end;
    vk_Delete: begin WindowChar(#0); WindowChar(#83); end;
    vk_Left  : begin WindowChar(#0); WindowChar(#75); end;
    vk_Right : begin WindowChar(#0); WindowChar(#77); end;
    vk_Up    : begin WindowChar(#0); WindowChar(#72); end;
    vk_Down  : begin WindowChar(#0); WindowChar(#80); end;
    vk_Home  : begin WindowChar(#0); WindowChar(#71); end;
    vk_End   : begin WindowChar(#0); WindowChar(#79); end;
    vk_F1    : begin WindowChar(#0); WindowChar(#59); end;
    vk_F2    : begin WindowChar(#0); WindowChar(#60); end;
    vk_F3    : begin WindowChar(#0); WindowChar(#61); end;
    vk_F4    : begin WindowChar(#0); WindowChar(#62); end;
    vk_F5    : begin WindowChar(#0); WindowChar(#63); end;
    vk_F6    : begin WindowChar(#0); WindowChar(#64); end;
    vk_F7    : begin WindowChar(#0); WindowChar(#65); end;
    vk_F8    : begin WindowChar(#0); WindowChar(#66); end;
    vk_F9    : begin WindowChar(#0); WindowChar(#67); end;
    vk_F10   : begin WindowChar(#0); WindowChar(#68); end;
    vk_F11   : begin WindowChar(#0); WindowChar(#69); end;
    vk_F12   : begin WindowChar(#0); WindowChar(#70); end;
  end;
end;

{$system}
procedure CallMouseHandler(Mask: DWORD);
var
  lp: TPoint;
  Btn: DWORD;
begin
  Btn  :=  1 * DWORD(%MouseLButton) + 2 * DWORD(%MouseRButton) + 4 * DWORD(%MouseMButton);
  GetCursorPos(lp);
  %GrMouseHnd(Mask, Btn, lp.X, lp.Y, lp.X - OldMouseX, lp.Y - OldMouseY);
  OldMouseX  :=  lp.X;
  OldMouseY  :=  lp.Y;
end;

procedure PauseApp;
var
  Msg: TMsg;
begin
  while not WndRestored do
  begin
    GetMessage(Msg, 0, 0, 0);
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end;

var
  IsActive: Boolean := TRUE;

function MainWndProc(Window: HWND; Mess, WParam, LParam: LongInt): LongInt; stdcall;
begin
  if @GraphWndProc <> nil then
    Result := GraphWndProc(Window, Mess, WParam, LParam)
  else
    Result  :=  0;
  case Mess of
    WM_NCACTIVATE:
      begin
        if not %InGraph then exit;
        if (wParam = 0) and (IsActive) then
        begin
          StoreModeVariables;
          ResetModeVariables;
          WndRestored := FALSE;
          PauseApp;
        end;
        if wParam = 1 then
        begin
          RestoreModeVariables;
          WndRestored := TRUE;
        end;
      end;
    WM_SYSKEYUP:
    begin
       if (WndRestored) and (wParam = 9) then
       begin
          if TmpScr1 <> nil then
          begin
            FreeMem(TmpScr1, 4 + PageSize);
            TmpScr1 := nil;
            FreeMem(TmpScr2, 4 + PageSize);
            TmpScr2 := nil;
          end;
          GetMem(TmpScr1, 4 + PageSize);
          GetMem(TmpScr2, 4 + PageSize);
          GetImage(0, 0, GetMaxX, GetMaxY, TmpScr1^);
          SetActivePage(GetActivePage xor 1);
          GetImage(0, 0, GetMaxX, GetMaxY, TmpScr2^);
          SetActivePage(GetActivePage xor 1);
          WndRestored := FALSE;
       end;
    end;
    WM_SIZE:
      begin
        if (VideoMode = isSVGAMode) and (TmpScr1 <> nil)
           and (wParam = SIZE_RESTORED) and (WndRestored) then
        begin
          PutImage(0, 0, TmpScr1^);
          SetActivePage(GetActivePage xor 1);
          PutImage(0, 0, TmpScr2^);
          SetActivePage(GetActivePage xor 1);
        end;
      end;
    WM_CHAR:        WindowChar(Char(WParam));
    WM_KEYDOWN:     WindowKeyDown(Byte(WParam));
    WM_CLOSE:
      begin
        if IgnoreCloseMessage then
          Result := 0
        else
        begin
          IsActive := FALSE;
          Result := DefWindowProc(Window, Mess, WParam, LParam);
          exit;
        end;
      end;
    WM_DESTROY:
      begin
        if DirectXEnabled then
        begin
          DD_Done;
          DirectXEnabled := DD_Init;
        end;
      end;
    WM_MOUSEMOVE:
    begin
      if (%GrMouseMask and $01) = $01 then CallMouseHandler($01);
    end;
    WM_LBUTTONDOWN:
    begin
      %MouseLButton  :=  TRUE;
      if (%GrMouseMask and $02) = $02 then CallMouseHandler($02);
    end;
    WM_LBUTTONUP:
    begin
      %MouseLButton  :=  FALSE;
      if (%GrMouseMask and $04) = $04 then CallMouseHandler($04);
    end;
    WM_RBUTTONDOWN:
    begin
      %MouseRButton  :=  TRUE;
      if (%GrMouseMask and $08) = $08 then CallMouseHandler($08);
    end;
    WM_RBUTTONUP:
    begin
      %MouseRButton  :=  FALSE;
      if (%GrMouseMask and $10) = $10 then CallMouseHandler($10);
    end;
    WM_MBUTTONDOWN:
    begin
      %MouseMButton  :=  TRUE;
      if (%GrMouseMask and $20) = $20 then CallMouseHandler($20);
    end;
    WM_MBUTTONUP:
    begin
      %MouseMButton  :=  FALSE;
      if (%GrMouseMask and $40) = $40 then CallMouseHandler($40);
    end;
  else
    Result  :=  DefWindowProc(Window, Mess, WParam, LParam);
  end;
end;

function InitMainWindow: THandle;
var
  wc: TWNDCLASS;
begin
  wc.style  :=  CS_HREDRAW or CS_VREDRAW;
  wc.lpfnWndProc := @MainWndProc;
  wc.cbClsExtra := 0;
  wc.cbWndExtra := 0;
  wc.hInstance := System.hInstance;
  if DefaultIcon <> 0 then
    wc.hIcon := DefaultIcon
  else
    wc.hIcon :=  LoadIcon(0, IDI_APPLICATION);
  if DefaultCursor <> 0 then
    wc.hCursor := DefaultCursor
  else
    wc.hCursor := LoadCursor(0, IDC_ARROW);
  wc.hbrBackground := 0;
  wc.lpszMenuName := nil;
  wc.lpszClassName := 'TMT_GRAPH';

  if not DirectXWndRegistered then
  begin
    if RegisterClass(wc) = 0 then
    begin
      DirectXWnd := 0;
      Result := 0;
      exit;
    end else
      DirectXWndRegistered := TRUE;
  end;

  DirectXWnd := CreateWindowEx(
  WS_EX_TOPMOST,
  'TMT_GRAPH',
  exename,
  WS_POPUP or WS_MAXIMIZE,
  0, 0,
  GetSystemMetrics(SM_CXSCREEN),
  GetSystemMetrics(SM_CYSCREEN),
  0,
  0,
  0,
  nil);

  ShowWindow(DirectXWnd, SW_RESTORE);
  BringWindowToTop(DirectXWnd);
  UpdateWindow(DirectXWnd);

  Result  :=  DirectXWnd;
end;

procedure SetSVGAMode(XRes,YRes,BPP,VMode: DWord);
begin
  if %inGraph then CloseGraph;
  if not DirectXEnabled then
  begin
    GrResult := grDirectXNotFound;
    exit;
  end;
  InitMainWindow;
  if DirectXWnd <> 0 then
  begin
    if DD_SetDisplayMode(DirectXWnd, XRes, YRes, BPP) then
    begin
      LfbAddress := DWORD(DD_PrimPtr);

      if BufferSize>0 then FreeMem(GrBufferPtr,BufferSize);
      GetMem(GrBufferPtr,2048);
      BufferSize := 2048;

     (* PhysMaxX and PhysMaxY = physical size of page *)
      PhysMaxX := XRes-1;
      PhysMaxY := YRes-1;
      BitsPerPixel := BPP;
      BytesPerPixel := (BPP+1) div 8;
      VpHeight := YRes;
      VpWidth := XRes;
      PageSize := YRes * BytesPerLine;
      PossibleMaxPage := 1;
      MaxPage := PossibleMaxPage;
      case BitsPerPixel of
       8:     GrMaxColor := 255;
       15:    GrMaxColor := 32767;
       16:    GrMaxColor := 65535;
       24,32: GrMaxColor := 16777215
      end;

      VideoPtr := LfbAddress;
      VideoPagePtr := VideoPtr;
      PutTextelProc := @PutHtextelLin;
      GetTextelProc := @GetHtextelLin;
      SetStartAddrWR := nil; //@VESA_Func07W2;
      SetStartAddrNW := nil; //@VESA_Func07NW;
      FlipToScrProc := @FlipToScreenLin;
      FlipToMemProc := @FlipToMemoryLin;
      case BytesPerPixel of
        1: begin
             PutPixelProc := @PutPixel256Lin;
             GetPixelProc := @GetPixel256Lin;
             HLineProc := @DrawHLine256Lin;
             ClearPageProc := @ClearPage256Lin;
            end;
        2: begin
             PutPixelProc := @PutPixel32kLin;
             GetPixelProc := @GetPixel32kLin;
             HLineProc := @DrawHLine32kLin;
             ClearPageProc := @ClearPage32kLin;
            end;
        3: begin
             PutPixelProc := @PutPixel16mLin;
             GetPixelProc := @GetPixel16mLin;
             HLineProc := @DrawHLine16mLin;
             ClearPageProc := @ClearPage16mLin;
            end;
        4: begin
             PutPixelProc := @PutPixel4GLin;
             GetPixelProc := @GetPixel4GLin;
             HLineProc := @DrawHLine4GLin;
             ClearPageProc := @ClearPage4GLin;
            end;
      end;

      UseLfb := TRUE;

      VideoMode := isSVGAMode;
      if BitsPerPixel=8 then GetPalette(DefaultPal);
      GraphDefaults;
      ScreenPtr := VideoPtr;
      SetFillStyle(SolidFill, clWhite);
      ShowCursor(FALSE);
      %inGraph:= TRUE;
      GrResult:= grOk;
      ClearDevice;
    end else
    begin
      %inGraph:= FALSE;
      GrResult:= grDirectXError;
    end;
  end;
end;

procedure SetGraphMode(VbeMode: Word);
var
  i, XR, YR, BP, NR: DWORD;
begin
  if VbeMode = $13 then
  begin
    SetSVGAMode(320, 200, 8, LfbOnly);
    exit;
  end;
  VbeMode := VbeMode and $FFFF;
  for i := 0 to High(StandardVbeModes) div 4 - 1 do
  begin
    XR := StandardVbeModes[i * 4 + 0];
    YR := StandardVbeModes[i * 4 + 1];
    BP := StandardVbeModes[i * 4 + 2];
    NR := StandardVbeModes[i * 4 + 3];
    if NR = VbeMode then
    begin
      SetSVGAMode(XR, YR, BP, LfbOnly);
      exit;
    end;
  end;
  GrResult := grModeNotSupported;
end;
{$endif}

procedure CloseGraph;
begin
{$ifdef __DOS__}
  if GrBufferPtr <> nil then FreeMem(GrBufferPtr, BufferSize);
  SetBIOSMode(LastMode);
  ProcsReset;
  if LfbAddress <> 0 then
  begin
   if FreePhysicalMap(LfbAddress) then LfbAddress := 0;
  end;
  if PmCodeSize > 0 then FreeMem(PmCode, PmCodeSize);
{$endif}
{$ifdef __WIN32__}
  %InGraph  :=  FALSE;
  DestroyWindow(DirectXWnd);
  if TmpScr1 <> nil then
  begin
    FreeMem(TmpScr1, 4 + PageSize);
    TmpScr1 := nil;
    FreeMem(TmpScr2, 4 + PageSize);
    TmpScr2 := nil;
  end;
{$endif}
end;

procedure RestoreCrtMode;
begin
{$ifdef __DOS__}
  SetBIOSMode(LastMode);
  ProcsReset;
{$endif}
{$ifdef __WIN32__}
  CloseGraph;
{$endif}
end;

///////////////////////////////////////////////////////////////////////////
// Packs a set of RGB values into a color value for passing to the       //
// primitive drawing routines that is appropriate for the current        //
// video mode                                                            //
//                                                                       //
// Public                                                                //
///////////////////////////////////////////////////////////////////////////
function RGBColor(R, G, B: Byte): DWord;
assembler;
      asm
        movzx   eax,[R]
        mov     cl,[DcRedAdjust]
        shr     al,cl
        and     al,[DcRedMask]
        mov     cl,[DcRedPos]
        shl     eax,cl
        movzx   ebx,[G]
        mov     cl,[DcGreenAdjust]
        shr     bl,cl
        and     bl,[DcGreenMask]
        mov     cl,[DcGreenPos]
        shl     ebx,cl
        movzx   edx,[B]
        mov     cl,[DcBlueAdjust]
        shr     dl,cl
        and     dl,[DcBlueMask]
        mov     cl,[DcBluePos]
        shl     edx,cl
        or      eax,ebx
        or      eax,edx
end;

procedure AnalizeRGB(Color: Dword; var R, G, B: Byte);
assembler;
      asm
        mov     eax,[Color]
        mov     cl,[DcRedPos]
        shr     eax,cl
        and     al,[DcRedMask]
        mov     cl,[DcRedAdjust]
        shl     eax,cl
        mov     edi,[R]
        mov     [edi],al
        mov     eax,[Color]
        mov     cl,[DcGreenPos]
        shr     eax,cl
        and     al,[DcGreenMask]
        mov     cl,[DcGreenAdjust]
        shl     eax,cl
        mov     edi,[G]
        mov     [edi],al
        mov     eax,[Color]
        mov     cl,[DcBluePos]
        shr     eax,cl
        and     al,[DcBlueMask]
        mov     cl,[DcBlueAdjust]
        shl     eax,cl
        mov     edi,[B]
        mov     [edi],al
end;

///////////////////////////////////////////////////////////////////////////
// Modifies palette entries for the VGA drivers.                         //
//                                                                       //
// Public                                                                //
///////////////////////////////////////////////////////////////////////////
procedure SetRGBPalette(Color, R, G, B: Byte);
{$ifdef __DOS__}
assembler;
      asm
        mov     dx,03C8h
        mov     al,[Color]
        out     dx,al
        inc     dx
        mov     al,[R]
        out     dx,al
        mov     al,[G]
        out     dx,al
        mov     al,[B]
        out     dx,al
 end;
{$endif}
{$ifdef __WIN32__}
begin
  RGBType(DD_CurrentPal.Colors[Color]).Red := R;
  RGBType(DD_CurrentPal.Colors[Color]).Green := G;
  RGBType(DD_CurrentPal.Colors[Color]).Blue := B;
  DD_SetPalette(@DD_CurrentPal);
end;
{$endif}

///////////////////////////////////////////////////////////////////////////
// Changes one palette color as specified by                             //
// ColorNum and Color.                                                   //
//                                                                       //
// Public                                                                //
///////////////////////////////////////////////////////////////////////////
procedure SetPalette(ColorNum: Byte; Color: Word);
var
  R,G,B: Byte;
begin
  if (Color > 255) or (ColorNum > 255) or (BitsPerPixel <> 8)
  then GrResult := GrError else begin
    GetRGBPalette(Color, R, G, B);
    SetRgbPalette(ColorNum, R, G, B);
    GrResult := grOk;
  end;
end;

///////////////////////////////////////////////////////////////////////////
// Returns palette entries for the VGA drivers.                          //
//                                                                       //
// Public                                                                //
///////////////////////////////////////////////////////////////////////////
procedure GetRGBPalette(Color: Byte; var R,G,B: Byte);
{$ifdef __DOS__}
assembler;
      asm
        mov     al,[Color]
        mov     edx,03C7h
        out     dx,al
        mov     edx,03C9h
        in      al,dx
        mov     edi,[R]
        mov     [edi],al
        in      al,dx
        mov     edi,[G]
        mov     [edi],al
        in      al,dx
        mov     edi,[B]
        mov     [edi],al
end;
{$endif}
{$ifdef __WIN32__}
var
  Pal: PaletteType;
begin
  GetPalette(Pal);
  R  :=  RGBType(Pal.Colors[Color]).Red;
  G  :=  RGBType(Pal.Colors[Color]).Green;
  B  :=  RGBType(Pal.Colors[Color]).Blue;
end;
{$endif}

///////////////////////////////////////////////////////////////////////////
// Returns the current palette and its size.                             //
//                                                                       //
// Public                                                                //
///////////////////////////////////////////////////////////////////////////
procedure GetPalette(var Palette: PaletteType);
{$ifdef __DOS__}
assembler;
      asm
        mov     edi,[Palette]
        mov     eax,$100
        mov     [edi],ax
        add     edi,2
        mov     ecx,eax
        mov     edx,03C7h
        xor     eax,eax
        out     dx,al
        mov     dx,03C9h
        ALIGN   4
@PalLp: xor     al, al
        mov     [edi+3],al
        in      al,dx
        mov     [edi+2],al
        in      al,dx
        mov     [edi+1],al
        in      al,dx
        mov     [edi],al
        add     edi,4
        loop    @PalLp
end;
{$endif}
{$ifdef __WIN32__}
begin
  Move(DD_CurrentPal, Palette, 1026);
end;
{$endif}

procedure GetDefaultPalette(var Palette: PaletteType);
begin
  Palette := DefaultPal;
end;

///////////////////////////////////////////////////////////////////////////
// Changes all palette colors as specified.                              //
//                                                                       //
// Public                                                                //
///////////////////////////////////////////////////////////////////////////
procedure SetAllPalette(var Palette: PaletteType);
{$ifdef __DOS__}
assembler;
      asm
        mov     esi,[Palette]
        movzx   ecx,word ptr [esi]
        add     esi,2
        xor     ebx,ebx
        ALIGN   4
@DAC6:  mov     edx,$3C8
        mov     eax,ebx
        out     dx,al
        inc     ebx
        inc     dx
        mov     al,[esi+2]
        out     dx,al
        mov     al,[esi+1]
        out     dx,al
        mov     al,[esi]
        out     dx,al
        add     esi,4
        loop    @DAC6
@Quit:
end;
{$endif}
{$ifdef __WIN32__}
begin
  DD_SetPalette(@Palette);
end;
{$endif}

procedure ClearPage;
assembler;
      asm
        call    dword ptr [ClearPageProc]
end;

function GetX: LongInt;
code;
      asm
        mov     eax,[CpX]
        ret
end;

function GetY: LongInt;
code;
      asm
        mov     eax,[CpY]
        ret
end;

procedure PutPixelB(X, Y: LongInt; Color: DWord);
assembler;
      asm
        mov     ebx,[X]
        add     ebx,[AddX]
        cmp     ebx,[WndX1]
        jl      @@Quit
        cmp     ebx,[WndX2]
        jg      @@Quit
        mov     eax,[Y]
        add     eax,[AddY]
        cmp     eax,[WndY1]
        jl      @@Quit
        cmp     eax,[WndY2]
        jg      @@Quit
        mov     ecx,[Color]
        call    dword ptr [PutPixelProc]
@@Quit:
end;

procedure PutPixelA(X, Y: LongInt);
assembler;
      asm
        mov     ebx,[X]
        add     ebx,[AddX]
        cmp     ebx,[WndX1]
        jl      @@Quit
        cmp     ebx,[WndX2]
        jg      @@Quit
        mov     eax,[Y]
        add     eax,[AddY]
        cmp     eax,[WndY1]
        jl      @@Quit
        cmp     eax,[WndY2]
        jg      @@Quit
        mov     ecx,[GraphColor]
        call    dword ptr [PutPixelProc]
@@Quit:
end;

function GetPixel(X, Y: LongInt): DWord;
assembler;
      asm
        mov     ebx,[X]
        add     ebx,[AddX]
        cmp     ebx,[WndX1]
        jl      @@Quit
        cmp     ebx,[WndX2]
        jg      @@Quit
        mov     eax,[Y]
        add     eax,[AddY]
        cmp     eax,[WndY1]
        jl      @@Quit
        cmp     eax,[WndY2]
        jg      @@Quit
        call    dword ptr [GetPixelProc]
@@Quit:
end;

procedure DrawHLine(X1, X2, Y: LongInt);
assembler;
var
  Temp1, Temp2: DWord;
      asm
        mov     edx,[Y]
        add     edx,[AddY]
        mov     ebx,[X1]
        add     ebx,[AddX]
        mov     ecx,[X2]
        add     ecx,[AddX]

        cmp     ebx,ecx
        jg      @@Quit

        cmp     edx,[WndY1]
        jl      @@Quit
        cmp     edx,[WndY2]
        jg      @@Quit
        cmp     ecx,[WndX1]
        jl      @@Quit
        cmp     ebx,[WndX2]
        jg      @@Quit
        cmp     ebx,[WndX1]
        jge     @@Next1
        mov     ebx,[WndX1]
@@Next1:
        cmp     ecx,[WndX2]
        jle     @@Next2
        mov     ecx,[WndX2]
@@Next2:
        call    dword ptr [HLineProc]
@@Quit:
end;

procedure PutHtextel(X1, X2, Y: LongInt; var Textel);
assembler;
      asm
        mov     esi,[Textel]
        mov     edx,[Y]
        add     edx,[AddY]
        mov     ebx,[X1]
        add     ebx,[AddX]
        mov     ecx,[X2]
        add     ecx,[AddX]
        cmp     edx,[WndY1]
        jl      @@Quit
        cmp     edx,[WndY2]
        jg      @@Quit
        cmp     ecx,[WndX1]
        jl      @@Quit
        cmp     ebx,[WndX2]
        jg      @@Quit
        push    edx
        cmp     ebx,[WndX1]
        jge     @@Next1
        mov     eax,[BytesPerPixel]
        mul     ebx
        sub     esi,eax
        mov     eax,[BytesPerPixel]
        mov     ebx,[WndX1]
        mul     ebx
        add     esi,eax
@@Next1:
        cmp     ecx,[WndX2]
        jle     @@Next2
        mov     ecx,[WndX2]
@@Next2:
        mov     eax,[BytesPerPixel]
        sub     ecx,ebx
        inc     ecx
        mul     ecx
        mov     ecx,eax
        mov     eax,[BytesPerPixel]
        mul     ebx
        mov     ebx,eax
        pop     edx
        call    [PutTextelProc]
@@Quit:
end;

procedure GetHtextel(X1, X2, Y: LongInt; var Textel);
assembler;
      asm
        mov     edi,[Textel]
        mov     edx,[Y]
        add     edx,[AddY]
        mov     ebx,[X1]
        add     ebx,[AddX]
        mov     ecx,[X2]
        add     ecx,[AddX]
        cmp     edx,[WndY1]
        jl      @@Quit
        cmp     edx,[WndY2]
        jg      @@Quit
        cmp     ecx,[WndX1]
        jl      @@Quit
        cmp     ebx,[WndX2]
        jg      @@Quit
        push    edx
        cmp     ebx,[WndX1]
        jge     @@Next1
        mov     eax,[BytesPerPixel]
        mul     ebx
        sub     edi,eax
        mov     eax,[BytesPerPixel]
        mov     ebx,[WndX1]
        mul     ebx
        add     edi,eax
@@Next1:
        cmp     ecx,[WndX2]
        jle     @@Next2
        mov     ecx,[WndX2]
@@Next2:
        mov     eax,[BytesPerPixel]
        sub     ecx,ebx
        inc     ecx
        mul     ecx
        mov     ecx,eax
        mov     eax,[BytesPerPixel]
        mul     ebx
        mov     ebx,eax
        mov     edx,[Y]
        pop     edx
        call    [GetTextelProc]
@@Quit:
end;

procedure PutSprite(X1, Y1, X2, Y2: LongInt; var Sprite);
var
  i: LongInt;
  LineSize: DWord;
  Addr: Pointer;
begin
  if (X2 < X1) or (Y2 < Y1) then
  begin
    GrResult := grError;
    exit;
  end;
  Addr := @Sprite;
  GrResult := grOk;
  LineSize := (X2 - X1 + 1) * BytesPerPixel;
  for i := Y1 to Y2 do
  begin
    PutHtextel(X1, X2, i, Addr^);
    Inc(Addr, LineSize);
  end;
end;

procedure GetSprite(X1, Y1, X2, Y2: LongInt; var Sprite);
var
  i: LongInt;
  LineSize: DWord;
  Addr: Pointer;
begin
  if (X2 < X1) or (Y2 < Y1) then
  begin
    GrResult := grError;
    exit;
  end;
  Addr := @Sprite;
  GrResult := grOk;
  LineSize := (X2 - X1 + 1) * BytesPerPixel;
  for i := Y1 to Y2 do
  begin
    GetHtextel(X1, X2, i, Addr^);
    Inc(Addr, LineSize);
  end;
end;

function ImageSize(X1, Y1, X2, Y2: DWord): DWord;
begin
  if (X2 < X1) or (Y2 < Y1) then
  begin
    GrResult := grError;
    exit;
  end;
  Result := 4 + (X2 - X1 + 1) * (Y2 - Y1 + 1) * DWord(BytesPerPixel);
  GrResult := grOk;
end;

procedure InvertImage(var BitMap);
assembler;
      asm
        mov     esi,[BitMap]
        movzx   eax,Word ptr [esi]
        inc     eax
        add     esi,2
        movzx   ebx,Word ptr [esi]
        inc     ebx
        add     esi,2
        mul     ebx
        mov     ebx,[BytesPerPixel]
        mul     ebx
        mov     ecx,eax
        shr     ecx,2
        jz      @@Pass
        ALIGN   4
@@Lp1:  not     DWord ptr [esi]
        add     esi,4
        loop    @@Lp1
@@Pass: mov     ecx,eax
        and     ecx,3
        jz      @@Quit
        ALIGN   4
@@Lp2:  not     Byte ptr [esi]
        inc     esi
        loop    @@Lp1
@@Quit:
end;

procedure FlipImageOY(var BitMap);
var
  IX, IY: DWord;
  A1, A2: Pointer;
  i, Ls:  DWord;
begin
  A1 := @BitMap;
  IX := 1 + Word(A1^);
  Inc(A1, 2);
  IY := 1 + Word(A1^);
  if IY < 2 then
  begin
    GrResult := grError;
    exit;
  end;
  GrResult := grOk;
  Inc(A1, 2);
  Ls := IX * BytesPerPixel;
  if BufferSize < Ls then
  begin
    GrResult := grNoGraphMem;
    exit;
  end;
  A2 := Pointer(DWord(A1) + (Ls * (DWord(IY) - 1)));
  for i := 1 to IY div 2 do
  begin
    Move(A1^, GrBufferPtr^, Ls);
    Move(A2^, A1^, Ls);
    Move(GrBufferPtr^,A2^, Ls);
    Inc(DWord(A1), Ls);
    Dec(DWord(A2), Ls);
  end;
  GrResult := GrOk;
end;

procedure FlipLineOX(Addr1: Pointer; LP: DWord);
assembler;
      asm
        mov     esi,[Addr1]
        mov     edi,esi
        cmp     [BytesPerPixel],1
        jnz     @@Pass1
@@Bpp1: mov     ecx,[Lp]
        add     edi,ecx
        dec     edi
        shr     ecx,1
        ALIGN   4
@@Lp1:  mov     bl,[esi]
        mov     al,[edi]
        mov     [edi],bl
        mov     [esi],al
        inc     esi
        dec     edi
        loop    @@Lp1
        jmp     @@Quit
@@Pass1:
        cmp     [BytesPerPixel],2
        jnz     @@Pass2
@@Bpp2: mov     ecx,[Lp]
        add     edi,ecx
        add     edi,ecx
        sub     edi,2
        shr     ecx,1
        ALIGN   4
@@Lp2:  mov     bx,[esi]
        mov     ax,[edi]
        mov     [edi],bx
        mov     [esi],ax
        add     esi,2
        sub     edi,2
        loop    @@Lp2
        jmp     @@Quit
@@Pass2:
        cmp     [BytesPerPixel],3
        jnz     @@Pass3
@@Bpp3: mov     ecx,[Lp]
        add     edi,ecx
        add     edi,ecx
        add     edi,ecx
        sub     edi,3
        shr     ecx,1
        ALIGN   4
@@Lp3:  mov     bx,[esi]
        mov     dl,[esi+2]
        mov     ax,[edi]
        mov     dh,[edi+2]
        mov     [edi],bx
        mov     [edi+2],dl
        mov     [esi],ax
        mov     [esi+2],dh
        add     esi,3
        sub     edi,3
        loop    @@Lp3
        jmp     @@Quit
@@Pass3:
        cmp     [BytesPerPixel],4
        jz      @@Bpp4
        mov     [GrResult],grInvalidMode
        jmp     @@Quit
@@Bpp4: mov     ecx,[Lp]
        shl     ecx,2
        add     edi,ecx
        sub     edi,4
        shr     ecx,3
        ALIGN   4
@@Lp4:  mov     ebx,[esi]
        mov     eax,[edi]
        mov     [edi],ebx
        mov     [esi],eax
        add     esi,4
        sub     edi,4
        loop    @@Lp4
@@Quit:
end;

procedure FlipImageOX(var BitMap);
var
  IX,IY: DWord;
  A1:    Pointer;
  i,Ls:  DWord;
begin
  A1 := @BitMap;
  IX := 1 + Word(A1^);
  if IX < 2 then
  begin
    GrResult := grError;
    exit;
  end;
  GrResult := grOk;
  Inc(A1, 2);
  IY := 1 + Word(A1^);
  Inc(A1, 2);
  LS := IX * BytesPerPixel;
  for i := 1 to IY do
  begin
    FlipLineOX(A1, IX);
    Inc(DWord(A1), LS);
  end;
end;

procedure PutImage(X, Y: LongInt; var BitMap);
var
  IX, IY: SmallInt;
  Addr:   Pointer;
begin
  Addr := @BitMap;
  IX := SmallInt(Addr^);
  Inc(Addr, 2);
  IY := SmallInt(Addr^);
  Inc(Addr, 2);
  PutSprite(X, Y, X + IX, Y + IY, Addr^);
end;

procedure GetImage(X, Y, X1, Y1: LongInt; var BitMap);
var
  Addr: Pointer;
begin
  Addr := @BitMap;
  SmallInt(Addr^) := X1 - X;
  Inc(Addr, 2);
  SmallInt(Addr^) := Y1 - Y;
  Inc(Addr, 2);
  GetSprite(X, Y, X1, Y1, Addr^);
end;

procedure xLine(X1,Y1,X2,Y2: LongInt);
assembler;
var
  Cnt,Acc,DeltaX,DeltaY,DirX,DirY: LongInt;
      asm
        mov     esi,[GrLineStyle]
        mov     ebx,[X1]
        mov     edi,[Y1]
        cmp     edi,[Y2]
        jle     @@Pass
        mov     eax, edi
        mov     edi, [Y2]
        mov     [Y2], eax
        mov     eax, ebx
        mov     ebx, [X2]
        mov     [X2], eax
@@Pass: add     ebx,[AddX]
        add     edi,[AddY]
        xor     eax,eax
        mov     [Acc],eax
        mov     eax,[X2]
        add     eax,[AddX]
        sub     eax,ebx
        mov     edx,1
        jns     @@NoSX
        neg     eax
        mov     edx,-1
@@NoSX: mov     [DirX],edx
        mov     [DeltaX],eax
        mov     eax,[Y2]
        add     eax,[AddY]
        sub     eax,edi
        mov     edx,1
        jns     @@NoSY
        neg     eax
        mov     edx,-1
@@NoSY: mov     [DirY],edx
        mov     [DeltaY],eax
        cmp     eax,[DeltaX]
        jge     @@YLp
        push    edi
        push    ebx
        ror     esi,1
        jnc     @@A10
        mov     eax,edi
        mov     ecx,[GraphColor]
        call    dword ptr [PutPixelProc]
@@A10:  pop     ebx
        pop     edi
        mov     eax,[DeltaX]
        mov     [Cnt],eax
@@Lp1:  dec     [Cnt]
        js      @@Quit
        add     ebx,[DirX]
        mov     eax,[DeltaY]
        add     [Acc],eax
        mov     eax,[Acc]
        cmp     eax,[DeltaX]
        jb      @@NoIncY
        mov     eax,[DeltaX]
        sub     [Acc],eax
        add     edi,[DirY]
@@NoIncY:
        push    edi
        push    ebx
        ror     esi,1
        jnc     @@B10
        mov     eax,edi
        mov     ecx,[GraphColor]
        call    dword ptr [PutPixelProc]
@@B10:  pop     ebx
        pop     edi
        jmp     @@Lp1
@@YLp:  push    edi
        push    ebx
        ror     esi,1
        jnc     @@C10
        mov     eax,edi
        mov     ecx,[GraphColor]
        call    dword ptr [PutPixelProc]
@@C10:  pop     ebx
        pop     edi
        mov     eax,[DeltaY]
        mov     [Cnt],eax
@@Lp2:  dec     [Cnt]
        js      @@Quit
        add     edi,[DirY]
        mov     eax,[DeltaX]
        add     [Acc],eax
        mov     eax,[Acc]
        cmp     eax,[DeltaY]
        jb      @@NoIncX
        mov     eax,[DeltaY]
        sub     [Acc],eax
        add     ebx,[DirX]
@@NoIncX:
        push    edi
        push    ebx
        ror     esi,1
        jnc     @@D10
        mov     eax,edi
        mov     ecx,[GraphColor]
        call    dword ptr [PutPixelProc]
@@D10:  pop     ebx
        pop     edi
        jmp     @@Lp2
@@Quit:
end;

function ClipLineR(var x1, y1, x2, y2: LongInt; left, top, right, bottom: LongInt): Boolean;
var
  outcode1,outcode2: LongInt := 0;     // Outcodes for the two endpoints
  outcodeOut: LongInt := 0;            // Outcode of endpoint outside
  x, y, dx, dy: Double;

  procedure SETOUTCODES(var outcode: LongInt; x, y: Double);
  begin
   outcode :=  0;
    if (y >= bottom) then outcode :=  outcode or 1;
    if (y < top) then outcode :=  outcode or 2;
    if (x >= right) then outcode :=  outcode or 4;
    if (x < left) then outcode :=  outcode or 8;
  end;

begin
  inc(right);
  inc(bottom);
  (* Set up the initial 4 bit outcodes *)
  SETOUTCODES(outcode1, x1, y1);
  SETOUTCODES(outcode2, x2, y2);
  if (outcode1 and outcode2) <> 0 then
  begin
    Result := FALSE;
    exit;
  end;
  if ((outcode1 or outcode2)) = 0 then
  begin
    Result := TRUE;
    exit;
  end;
  dx :=  x2 - x1;  // Compute dx and dy once only
  dy :=  y2 - y1;

  repeat
    (* Determine which endpoint is currently outside of clip rectangle *)
    (* and pick it to be clipped.                                      *)

    if outcode2 <> 0 then
      outcodeOut :=  outcode2
    else
      outcodeOut :=  outcode1;

    (* Clip the endpoint to                    *)
    (* one of the appropriate boundaries...    *)

    if (outcodeOut and 1) <> 0 then
    begin
      x :=  x1 + dx*(bottom-1-y1)/dy;
      y :=  bottom-1;
    end
    else if (outcodeOut and 2) <> 0 then
    begin
      x :=  x1 + dx*(top-y1)/dy;
      y :=  top;
    end
    else if (outcodeOut and 4)<>0 then
    begin
      y :=  y1 + dy * (right - 1 - x1) / dx;
      x :=  right - 1;
    end
    else begin
     y :=  y1 + dy * (left - x1) / dx;
     x :=  left;
    end;

    if (outcodeOut = outcode1) then
    begin
      x1 := Trunc(x);
      y1 := Trunc(y);
      SETOUTCODES(outcode1, x, y);
    end
    else
    begin
      x2 := Trunc(x);
      y2 := Trunc(y);
      SETOUTCODES(outcode2, x, y);
    end;

    if (outcode1 and outcode2) <> 0 then
    begin
      Result := FALSE;
      exit;
    end;
    if ((outcode1 or outcode2)) = 0 then
    begin
      Result := TRUE;
      exit;
    end;
  until FALSE;
end;

procedure LineA(X1,Y1,X2,Y2: LongInt);
begin
  if ClipLineR(X1,Y1,X2,Y2,WndX1-AddX,WndY1-AddY,WndX2-AddX,WndY2-AddY) then
    xLine(X1,Y1,X2,Y2);
  if LineThick<>ThickWidth then exit;

  if Abs(X2-X1)>Abs(Y2-Y1) then
  begin
   Y1 := Y1+1; Y2 := Y2+1;
   if ClipLineR(X1,Y1,X2,Y2,WndX1-AddX,WndY1-AddY,WndX2-AddX,WndY2-AddY) then
    xLine(X1,Y1,X2,Y2);
   Y1 := Y1-2; Y2 := Y2-2;
   if ClipLineR(X1,Y1,X2,Y2,WndX1-AddX,WndY1-AddY,WndX2-AddX,WndY2-AddY) then
    xLine(X1,Y1,X2,Y2);
  end else
  begin
   X1 := X1+1; X2 := X2+1;
   if ClipLineR(X1,Y1,X2,Y2,WndX1-AddX,WndY1-AddY,WndX2-AddX,WndY2-AddY) then
    xLine(X1,Y1,X2,Y2);
   X1 := X1-2; X2 := X2-2;
   if ClipLineR(X1,Y1,X2,Y2,WndX1-AddX,WndY1-AddY,WndX2-AddX,WndY2-AddY) then
    xLine(X1,Y1,X2,Y2);
  end;
end;

procedure LineB(X1,Y1,X2,Y2: LongInt; Color: DWORD);
var
  StoreColor: DWORD;
begin
  StoreColor := GraphColor;
  GraphColor := Color;
  LineA(X1, Y1, X2, Y2);
  GraphColor := StoreColor;
end;

procedure MoveTo(X, Y: LongInt);
code;
      asm
        mov     eax,[X]
        mov     [CpX],eax
        mov     eax,[Y]
        mov     [CpY],eax
        ret
end;

procedure MoveRel(Dx, Dy: LongInt);
code;
      asm
        mov     eax,[CpX]
        add     eax,[&Dx]
        mov     [CpX],eax
        mov     eax,[CpY]
        add     eax,[&Dy]
        mov     [CpY],eax
        ret
end;

procedure LineTo(X, Y: LongInt);
begin
  Line(CpX, CpY, X, Y);
  CpX := X;
  CpY := Y;
end;

procedure LineRel(Dx, Dy: LongInt);
begin
  LineTo(CpX + Dx,CpY + Dy);
end;

procedure SetSplineSteps(Steps: DWord);
begin
  if Steps=0 then
    GrResult := grError
  else
  begin
    SplineIterations := Steps;
    GrResult := grOk;
  end;
end;

procedure Spline(Nodes: Byte; Points: array of PointType);
type
  NodesData = array [0..255] of Real;
var
  i,oldy,oldx,x,y,j: LongInt;
  part,t,xx,yy: Real;
  zc,dx,dy,u,WndX1,WndY1,px,py: NodesData;

  function f(g: Real): Real;
  begin
   Result := g*g*g-g;
  end;

begin
  if Nodes<2 then
  begin
    GrResult := grError;
    exit;
  end else GrResult := grOk;
  oldx := $FFFFFF;
  x := Points[0].X;
  y := Points[0].Y;
  zc[0] := 0.0;
  for i := 1 to Nodes-1 do
  begin
    xx := Points[i-1].X-Points[i].X;
    yy := Points[i-1].Y-Points[i].Y;
    t := sqrt(xx*xx+yy*yy);
    zc[i] := zc[i-1]+t;
  end;
  for i := 1 to Nodes-2 do
  begin
    dx[i] := 2*(zc[i+1]-zc[i-1]);
    dy[i] := 2*(zc[i+1]-zc[i-1]);
  end;
  for i := 0 to Nodes-2 do u[i] := zc[i+1]-zc[i]+1;
  for i := 1 to Nodes-2 do
  begin
   WndY1[i] := 6*((Points[i+1].Y-Points[i].Y)/u[i]-(Points[i].Y-Points[i-1].Y)/u[i-1]);
   WndX1[i] := 6*((Points[i+1].X-Points[i].X)/u[i]-(Points[i].X-Points[i-1].X)/u[i-1])
  end;
  py[0] := 0.0;
  px[0] := 0.0;
  px[1] := 0;
  py[1] := 0;
  py[Nodes-1] := 0.0;
  px[Nodes-1] := 0.0;
  for i := 1 to Nodes-3 do
  begin
    WndY1[i+1] := WndY1[i+1]-WndY1[i]*u[i]/dy[i];
    dy[i+1] := dy[i+1]-u[i]*u[i]/dy[i];
    WndX1[i+1] := WndX1[i+1]-WndX1[i]*u[i]/dx[i];
    dx[i+1] := dx[i+1]-u[i]*u[i]/dx[i];
  end;
  for i := Nodes-2 downto 1 do
  begin
    py[i] := (WndY1[i]-u[i]*py[i+1])/dy[i];
    px[i] := (WndX1[i]-u[i]*px[i+1])/dx[i];
  end;
  for i := 0 to Nodes-2 do
  begin
    for j := 0 to SplineIterations do
    begin
      part := zc[i]-(((zc[i]-zc[i+1])/SplineIterations)*j);
      t := (part-zc[i])/u[i];
      part := t*Points[i+1].Y+(1-t)*Points[i].Y+u[i]*u[i]*(f(t)*py[i+1]+f(1-t)*py[i])/6.0;
      y := Round(part);
      part := zc[i]-(((zc[i]-zc[i+1])/SplineIterations)*j);
      t := (part-zc[i])/u[i];
      part := t*Points[i+1].X+(1-t)*Points[i].X+u[i]*u[i]*(f(t)*px[i+1]+f(1-t)*px[i])/6.0;
      x := Round(part);
      if oldx<>$FFFFFF then line(oldx,oldy,x,y);
      oldx := x;
      oldy := y;
    end;
  end;
end;

procedure RectangleA(X1, Y1, X2, Y2: LongInt);
begin
  Line(X1 + 1, Y1, X2, Y1);
  Line(X2,Y1 + 1, X2, Y2);
  Line(X2 - 1, Y2, X1, Y2);
  Line(X1, Y2 - 1, X1, Y1);
end;

procedure RectangleB(X1, Y1, X2, Y2: LongInt; Color: DWORD);
var
  StoreColor: DWORD;
begin
  StoreColor := GraphColor;
  GraphColor := Color;
  RectangleA(X1, Y1, X2, Y2);
  GraphColor := StoreColor;
end;

procedure XchgL(var a, b: LongInt);
code;
      asm
        mov     edi, [a]
        mov     esi, [b]
        mov     eax, [edi]
        xchg    eax, [esi]
        mov     [edi], eax
        ret
end;

procedure DrawPatternLine(X1, X2, Y: Longint);
var
  X, YY: Longint;
begin
  if UseSolidFill then
    DrawHLine(X1, X2, Y)
  else begin
    if X1 > X2 then exit;
    YY  :=  1 + Y mod 8;
    repeat
      X  :=  X2 - X1;
      if X > (PatternBuffSize - 9) then
        X  :=  (PatternBuffSize - 9);
      PutHTextel(X1, X1 + X, Y, (CurrentPattern[YY] + (X1 mod 8) * BytesPerPixel)^);
      X1 +:=  X;
      X1 +:=  1;
    until X1 > X2;
  end;
end;

procedure Bar(X1, Y1, X2, Y2: LongInt);
var
  i: LongInt;
begin
  if X1 > X2 then XchgL(X1, X2);
  if Y1 > Y2 then XchgL(Y1, Y2);
  for i := Y1 to Y2 do
    DrawPatternLine(X1,X2,i);
  GrResult := grOk;
end;

procedure Bar3D(X1, Y1, X2, Y2: LongInt; Depth: Word; Top: Boolean);
var
  XorFlag: Boolean;
begin
  if GrWriteMode = XorPut then
  begin
    XorFlag := TRUE;
    SetWriteMode(NormalPut);
  end else XorFlag := FALSE;
  Bar(X1,Y1,X2,Y2);
  if GrResult<>grOk then exit;
  Rectangle(X1,Y1,X2,Y2);
  if Top then
  begin
    Line(X1,Y1,X1+Depth,Y1-Depth);
    Line(X1+Depth,Y1-Depth,X2+Depth,Y1-Depth);
    Line(X2+Depth,Y1-Depth,X2,Y1);
  end;
  Line(X2+Depth,Y1-Depth,X2+Depth,Y2-Depth);
  Line(X2+Depth,Y2-Depth,X2,Y2);
  if XorFlag then SetWriteMode(XorPut);
end;

procedure GenerateEOctant(MinorAdjust, Threshold, MajorSquared, MinorSquared: LongInt);
assembler;
      asm
        mov     dword ptr [PixListLen],0
        mov     eax,[MajorSquared]
        shl     eax,1
        mov     edx,eax
        mov     eax,[MinorSquared]
        shl     eax,1
        mov     esi,eax
        mov     edi,[GrBufferPtr]
        xor     ecx,ecx
        mov     ebx,[Threshold]
        ALIGN   4
@@GenLoop:
        add     ebx,ecx
        mov     byte ptr [edi],0
        add     ebx,[MinorSquared]
        js      @@MoveMajor
        mov     eax,edx
        sub     [MinorAdjust],eax
        sub     ebx,[MinorAdjust]
        mov     byte ptr [edi],1
@@MoveMajor:
        inc     edi
        inc     [PixListLen]
        mov     eax,[BufferSize]
        cmp     eax,[PixListLen]
        jg      @@Cont
        mov     [GrResult],grNoGraphMem
        jmp     @@Quit
@@Cont: add     ecx,esi
        cmp     ecx,[MinorAdjust]
        jb      @@GenLoop
        mov     [GrResult],grOk
@@Quit:
end;

function CalcSquared(A, B: LongInt; var Aq, Bq, ABq, BAq: DWord): Boolean;
assembler;
      asm
        mov     ebx,2
        mov     eax,[A]
        mul     eax
        jc      @@Error
        mov     edi,[Aq]
        mov     [edi],eax
        mul     dword ptr [B]
        jc      @@Error
        mul     ebx
        jc      @@Error
        mov     edi,[ABq]
        mov     [edi],eax
        mov     eax,[B]
        mul     eax
        jc      @@Error
        mov     edi,[Bq]
        mov     [edi],eax
        mul     dword ptr [A]
        jc      @@Error
        mul     ebx
        jc      @@Error
        mov     edi,[BAq]
        mov     [edi],eax
        mov     eax,1
        jmp     @@Quit
@@Error:mov     [GrResult],grError
        xor     eax,eax
@@Quit:
end;

procedure Arc(X, Y: LongInt; StAngle, EndAngle, Radius: DWord);
var
  P: LongInt;
  Xt, Yt: LongInt;
  Alpha: Real;
begin
  If radius = 0 then
  begin
    PutPixel(X, Y, GraphColor);
    Exit;
  end;
  StAngle := StAngle mod 361;
  EndAngle := EndAngle mod 361;
  If StAngle>EndAngle then
  begin
    StAngle := StAngle xor EndAngle;
    EndAngle := EndAngle xor StAngle;
    StAngle := EndAngle xor StAngle;
  end;
  Xt := 0;
  Yt := Radius;
  p := 3-2*Radius;
  while Xt<=Yt do
  begin
    Alpha := 180 * Arctan(Xt / Yt) / pi;
    If (Alpha >= StAngle) and (Alpha <= EndAngle) then
      PutPixel(X - Xt, Y - Yt, GraphColor);
    If (90-Alpha>=StAngle) and (90 - Alpha <= EndAngle) then
      PutPixel(X - Yt, Y - Xt, GraphColor);
    If (90+Alpha >= StAngle) and (90 + Alpha <= EndAngle) then
      PutPixel(X - Yt, Y + Xt, GraphColor);
    If (180-Alpha >= StAngle) and (180 - Alpha <= EndAngle) then
      PutPixel(X - Xt, Y + Yt, GraphColor);
    If (180+Alpha>=StAngle) and (180 + Alpha <= EndAngle) then
      PutPixel(X + Xt, Y + Yt, GraphColor);
    If (270-Alpha >= StAngle) and (270 - Alpha <= EndAngle) then
      PutPixel(X + Yt, Y + Xt, GraphColor);
    If (270 + Alpha >= StAngle) and (270 + Alpha <= EndAngle) then
      PutPixel(X + Yt, Y - Xt, GraphColor);
    If (360 - Alpha >= StAngle) and (360 - Alpha <= EndAngle) then
      PutPixel(X + Xt, Y - Yt, GraphColor);
    If p < 0 then
      p := p + 4 * Xt + 6
    else
    begin
      p := p + 4 * (Xt - Yt) + 10;
      Dec(Yt);
    end;
    Inc(Xt);
  end;
end;

procedure Ellipse(X,Y: LongInt; StAngle, EndAngle, XRadius, YRadius: DWord);
var
  aSqr, bSqr, twoaSqr, twobSqr, Xt, Yt, twoXbSqr, twoYaSqr, error : LongInt;
  Alpha : Real;
  procedure PlotPoints;
  begin
    If (Alpha>=StAngle) and (Alpha<=EndAngle) then PutPixel (X-Xt,Y-Yt,GraphColor);
    If (180-Alpha>=StAngle) and (180-Alpha<=EndAngle) then PutPixel (X-Xt,Y+Yt,GraphColor);
    If (180+Alpha>=StAngle) and (180+Alpha<=EndAngle) then PutPixel (X+Xt,Y+Yt,GraphColor);
    If (360-Alpha>=StAngle) and (360-Alpha<=EndAngle) then PutPixel (X+Xt,Y-Yt,GraphColor);
  end;
begin
  if XRadius=0 then
  begin
    xLine(X, Y - YRadius, X, Y + YRadius);
    exit;
  end;
  StAngle := StAngle mod 361;
  EndAngle := EndAngle mod 361;
  If StAngle>EndAngle then
  begin
    StAngle := StAngle xor EndAngle;
    EndAngle := EndAngle xor StAngle;
    StAngle := EndAngle xor StAngle;
  end;
  aSqr := XRadius*XRadius;
  bSqr := YRadius*YRadius;
  twoaSqr := 2*aSqr;
  twobSqr := 2*bSqr;
  Xt := 0;
  Yt := YRadius;
  twoXbSqr := 0;
  twoYaSqr := Yt*twoaSqr;
  error := -Yt*aSqr;
  while twoXbSqr<=twoYaSqr do
  begin
   If Yt=0 then
    Alpha := 90
   else
    Alpha := 180*Arctan(Xt/Yt)/PI;
   PlotPoints;
   Inc(Xt);
   Inc(twoXbSqr,twobSqr);
   Inc(error,twoXbSqr-bSqr);
   if error>=0 then
   begin
    Dec(Yt);
    Dec(twoYaSqr,twoaSqr);
    Dec(error,twoYaSqr);
   end;
  end;
  Xt := XRadius;
  Yt := 0;
  twoXbSqr := Xt*twobSqr;
  twoYaSqr := 0;
  error := -Xt*bSqr;
  while twoXbSqr>twoYaSqr do
  begin
   if Yt=0 then
    Alpha := 90
   else
    Alpha := 180*Arctan (Xt/Yt)/PI;
   PlotPoints;
   Inc(Yt);
   Inc(twoYaSqr,twoaSqr);
   Inc(error,twoYaSqr-aSqr);
   if error>=0 then
   begin
    Dec(Xt);
    Dec(twoXbSqr,twobSqr);
    Dec(error,twoXbSqr);
   end;
  end;
end;

procedure DrawEllipse(X, Y, A, B: LongInt);
var
  ASquared,BSquared,ABSquared,BASquared: DWord;
  TempPtr: Pointer;
  procedure DrawVOctant(X,Y: LongInt; DrawLen: DWord; YDir,
                        HMoveDir: LongInt; GrBufferPtr: Pointer);
  var
    CX,CY,I: LongInt;
    DrawList: Pointer;
  begin
    DrawList := GrBufferPtr;
    CX := X; CY := Y;
    for I := 1 to DrawLen do begin
     PutPixel(CX,CY,GraphColor);
     if Byte(DrawList^)=1 then Inc(CX,HMoveDir);
     Inc(CY,YDir);
     Inc(DrawList);
    end;
  end;
procedure DrawHOctant (X,Y: LongInt; DrawLen: DWord; YDir,
                       HMoveDir: LongInt; GrBufferPtr: Pointer);
var
  CX,CY,I: LongInt;
  DrawList: Pointer;
begin
  DrawList := GrBufferPtr;
  CX := X; CY := Y;
  for I := 1 to DrawLen do
  begin
   PutPixel(CX,CY,GraphColor);
   if Byte(DrawList^)=1 then Inc(CY,YDir);
   Inc(CX,HMoveDir);
   Inc(DrawList);
  end;
end;

begin
  if (A = 0) or (B = 0) then
  begin
    GrResult := grError;
    exit;
  end;
  if not CalcSquared(A,B,ASquared,BSquared,ABSquared,BASquared) then exit;
  TempPtr := GrBufferPtr;
  Inc(TempPtr);
  GenerateEOctant(ABSquared,ASquared div 4 - ASquared*B,ASquared,BSquared);
  DrawHOctant(X,Y-B,PixListLen,1,-1,GrBufferPtr);
  DrawHOctant(X+1,Y-B+Byte(GrBufferPtr^),PixListLen-1,1,1,TempPtr);
  DrawHOctant(X,Y+B,PixListLen,-1,-1,GrBufferPtr);
  DrawHOctant(X+1,Y+B-Byte(GrBufferPtr^),PixListLen-1,-1,1,TempPtr);
  GenerateEOctant(BASquared,BSquared div 4 - BSquared*A,BSquared,ASquared);
  DrawVOctant(X-A,Y,PixListLen,-1,1,GrBufferPtr);
  DrawVOctant(X-A+Byte(GrBufferPtr^),Y+1,PixListLen-1,1,1,TempPtr);
  DrawVOctant(X+A,Y,PixListLen,-1,-1,GrBufferPtr);
  DrawVOctant(X+A-Byte(GrBufferPtr^),Y+1,PixListLen-1,1,-1,TempPtr);
end;

procedure FillEllipse (X,Y,A,B: LongInt);
var
  ASquared,BSquared,ABSquared,BASquared: DWord;
  TempPtr: Pointer;
procedure FilledVOctant(X,Y: LongInt; DrawLen: DWord; YDir,
                       HMoveDir: LongInt; GrBufferPtr: Pointer);
var
  CX,CL,CY,I: LongInt; DrawList: Pointer;
begin
  DrawList := GrBufferPtr;
  CX := X; CY := Y; CL := CX+A shl 1;
  for I := 1 to DrawLen do begin
   DrawPatternLine(CX,CL,CY);
   if Byte(DrawList^)=1 then begin Inc(CX,HMoveDir); dec(CL,1); end;
   Inc(CY,YDir);
   Inc(DrawList);
  end;
end;

procedure FilledHOctant(X,Y: LongInt; DrawLen: DWord; YDir,
                        HMoveDir: LongInt; GrBufferPtr: Pointer);
var
  CX,CY,CL,I: LongInt;
  DrawList: Pointer;
begin
  DrawList := GrBufferPtr;
  CX := X; CY := Y; CL := CX;
  DrawPatternLine(CX,CL,CY);
  for I := 1 to DrawLen do begin
   if Byte(DrawList^)=1 then begin
    inc(CY,YDir); DrawPatternLine(CX,CL,CY);
   end;
   Inc(CX,HMoveDir);
   Inc(CL,1);
   Inc(DrawList);
  end;
end;

begin
  if (A=0) or (B=0) then
  begin
   GrResult := grError;
   exit;
  end;
  if not CalcSquared(A,B,ASquared,BSquared,ABSquared,BASquared) then exit;
  TempPtr := GrBufferPtr;
  Inc(TempPtr);
  GenerateEOctant(ABSquared,ASquared div 4 - ASquared*B,ASquared,BSquared);
  FilledHOctant(X,Y-B,PixListLen,1,-1,GrBufferPtr);
  FilledHOctant(X,Y+B,PixListLen,-1,-1,GrBufferPtr);
  GenerateEOctant(BASquared,BSquared div 4 - BSquared*A,BSquared,ASquared);
  FilledVOctant(X-A,Y,PixListLen,-1,1,GrBufferPtr);
  FilledVOctant(X-A+Byte(GrBufferPtr^),Y+1,PixListLen-1,1,1,TempPtr);
  if DrawBorder then DrawEllipse(X,Y,A,B);
end;

procedure CircleA(X, Y: LongInt; Radius: DWord);
begin
  DrawEllipse(X, Y, Radius, Round(Radius * GrAspectRatio));
end;

procedure CircleB(X, Y: LongInt; Radius, Color: DWord);
var
  StoreColor: DWORD;
begin
  StoreColor := GraphColor;
  GraphColor := Color;
  DrawEllipse(X, Y, Radius, Round(Radius * GrAspectRatio));
  GraphColor := StoreColor;
end;

procedure FillCircle(X, Y: LongInt; Radius: DWord);
begin
  FillEllipse(X, Y, Radius, Round(Radius * GrAspectRatio));
end;

procedure TriangleA(X1, Y1, X2, Y2, X3, Y3: LongInt);
begin
  if GrWriteMode=XorPut then
  begin
    PutPixel(X1,Y1,GraphColor);
    PutPixel(X2,Y2,GraphColor);
    PutPixel(X3,Y3,GraphColor);
  end;
  Line(X1,Y1,X2,Y2);
  Line(X2,Y2,X3,Y3);
  Line(X3,Y3,X1,Y1);
end;

procedure TriangleB(X1, Y1, X2, Y2, X3, Y3: LongInt; Color: DWORD);
var
  StoreColor: DWORD;
begin
  StoreColor := GraphColor;
  GraphColor := Color;
  TriangleA(X1, Y1, X2, Y2, X3, Y3);
  GraphColor := StoreColor;
end;

procedure xFillTriangle(X0, Y0, X1, Y1, X2, Y2: LongInt);
assembler;
var
  DX01, DY01, DX02, DY02, DX12, DY12, DP01, DP02, DP12, XA01, XA02, XA12: DWord;
      asm
        mov     eax,[X0]
        mov     ebx,[Y0]
        mov     ecx,[X1]
        mov     edx,[Y1]
        cmp     ebx,edx
        jl      @Y0lY1
        je      @Y0eY1
        xchg    eax,ecx
        xchg    ebx,edx
@Y0lY1: cmp     edx,[Y2]
        jg      @Skip1
        jmp     @sorted
@Skip1: xchg    ecx,[X2]
        xchg    edx,[Y2]
        cmp     ebx,edx
        jge     @Skip2
        jmp     @sorted
@Skip2: je      @bot
        xchg    eax,ecx
        xchg    ebx,edx
        jmp     @sorted
@Y0eY1: cmp     ebx,[Y2]
        jl      @bot
        jg      @Next
        jmp     @Quit
@Next:  xchg    eax,[X2]
        xchg    ebx,[Y2]
        jmp     @sorted
@bot:   cmp     eax,ecx
        jl      @botsorted
        jg      @bota
        jmp     @Quit
@bota:  xchg    eax,ecx
@botsorted:
@boty0ok:
        mov     esi,[Y2]
@boty2ok:
        mov     [X0],eax
        mov     [Y0],ebx
        mov     [X1],ecx
        mov     [Y1],edx
        mov     ebx,[Y2]
        sub     ebx,[Y0]
        mov     [DY02],ebx
        mov     eax,[X2]
        sub     eax,[X0]
        mov     [DX02],eax
        mov     ecx,eax
        cdq
        idiv    ebx
        cmp     ecx,0
        jge     @bot02
        dec     eax
@bot02: mov     [XA02],eax
        imul    ebx
        sub     ecx,eax
        mov     [DP02],ecx
        mov     ebx,[Y2]
        sub     ebx,[Y1]
        mov     [DY12],ebx
        mov     eax,[X2]
        sub     eax,[X1]
        mov     [DX12],eax
        mov     ecx,eax
        cdq
        idiv    ebx
        cmp     ecx,0
        jge     @bot12
        dec     eax
@bot12: mov     [XA12],eax
        imul    ebx
        sub     ecx,eax
        mov     [DP12],ecx
        xor     eax,eax
        xor     ebx,ebx
        mov     ecx,[Y0]
        mov     esi,[X0]
        mov     edi,[X1]
        dec     edi
        ALIGN   4
@botloop:
        inc     ecx
        add     eax, [DP02]
        jle     @botshortl
        sub     eax, [DY02]
        inc     esi
@botshortl:
        add     esi, [XA02]
        add     ebx, [DP12]
        jle     @botshortr
        sub     ebx, [DY12]
        inc     edi
@botshortr:
        add     edi, [XA12]
        push    edi
        push    esi
        cmp     ecx,[Y2]
        jl      @botloop
        jmp     @lineloop
@sorted:
@y0ok:  mov     esi,[Y2]
@y2ok:  mov     [X0],eax
        mov     [Y0],ebx
        mov     [X1],ecx
        mov     [Y1],edx
        mov     ebx,edx
        sub     ebx,[Y0]
        mov     [DY01],ebx
        mov     eax,[X1]
        sub     eax,[X0]
        mov     [DX01],eax
        mov     ecx,eax
        cdq
        idiv    ebx
        cmp     ecx,0
        jge     @psl01
        dec     eax
@psl01: mov     [XA01],eax
        imul    ebx
        sub     ecx,eax
        mov     [DP01],ecx
        mov     ebx,[Y2]
        sub     ebx,[Y0]
        mov     [DY02],ebx
        mov     eax,[X2]
        sub     eax,[X0]
        mov     [DX02],eax
        mov     ecx,eax
        cdq
        idiv    ebx
        cmp     ecx,0
        jge     @psl02
        dec     eax
@psl02: mov     [XA02],eax
        imul    ebx
        sub     ecx,eax
        mov     [DP02],ecx
        mov     ebx,[Y2]
        sub     ebx,[Y1]
        jle     @constcomputed
        mov     [DY12],ebx
        mov     eax,[X2]
        sub     eax,[X1]
        mov     [DX12],eax
        mov     ecx,eax
        cdq
        idiv    ebx
        cmp     ecx,0
        jge     @psl12
        dec     eax
@psl12: mov     [XA12],eax
        imul    ebx
        sub     ecx,eax
        mov     [DP12],ecx
@ConstComputed:
        mov     eax, [DX01]
        imul    [DY02]
        mov     ebx,eax
        mov     eax,[DX02]
        imul    [DY01]
        cmp     ebx,eax
        jg      @pt1rt
        jl      @pt1lt
        jmp     @Quit
@pt1lt: xor     eax,eax
        xor     ebx,ebx
        mov     ecx,[Y0]
        mov     esi,[X0]
        mov     edi,esi
        dec     esi
        ALIGN   4
@ltloop:
        inc     ecx
        add     eax, [DP02]
        jle     @ltshortl
        sub     eax, [DY02]
        inc     esi
@ltshortl:
        add     esi, [XA02]
        add     ebx, [DP01]
        jle     @ltshortr
        sub     ebx, [DY01]
        inc     edi
@ltshortr:
        add     edi, [XA01]
        push    esi
        push    edi
        cmp     ecx,[Y1]
        jl      @ltloop
        jmp     @lbstart
        ALIGN   4
@lbloop:
        inc     ecx
        add     eax, [DP02]
        jle     @lbshortl
        sub     eax, [DY02]
        inc     esi
@lbshortl:
        add     esi, [XA02]
        add     ebx, [DP12]
        jle     @lbshortr
        sub     ebx, [DY12]
        inc     edi
@lbshortr:
        add     edi, [XA12]
        push    esi
        push    edi
@lbstart:
        cmp     ecx,[Y2]
        jl      @lbloop
        jmp     @lineloop
@pt1rt: xor     eax,eax
        xor     ebx,ebx
        mov     ecx,[Y0]
        mov     esi,[X0]
        mov     edi,esi
        dec     edi
        ALIGN   4
@rtloop:
        inc     ecx
        add     eax, [DP02]
        jle     @rtshortl
        sub     eax, [DY02]
        inc     esi
@rtshortl:
        add     esi, [XA02]
        add     ebx, [DP01]
        jle     @rtshortr
        sub     ebx, [DY01]
        inc     edi
@rtshortr:
        add     edi, [XA01]
        push    edi
        push    esi
        cmp     ecx,[Y1]
        jl      @rtloop
        jmp     @rbstart
        ALIGN   4
@rbloop:
        inc     ecx
        add     eax, [DP02]
        jle     @rbshortl
        sub     eax, [DY02]
        inc     esi
@rbshortl:
        add     esi, [XA02]
        add     ebx, [DP12]
        jle     @rbshorts
        sub     ebx, [DY12]
        inc     edi
@rbshorts:
        add     edi, [XA12]
        push    edi
        push    esi
@rbstart:
        cmp     ecx,[Y2]
        jl      @rbloop
        ALIGN   4
@lineloop:
        pop     eax
        pop     edx
        cmp     eax,edx
        jg      @drawnext
        push    eax
        push    edx
        push    dword ptr [Y2]
        call    DrawPatternLine
@drawnext:
        dec     [Y2]
        dec     [DY02]
        jnz     @lineloop
@Quit:
end;

procedure FillTriangle(X1, Y1, X2, Y2, X3, Y3: LongInt);
begin
  xFillTriangle(X1,Y1,X2,Y2,X3,Y3);
  if DrawBorder then Triangle(X1,Y1,X2,Y2,X3,Y3);
end;

procedure DrawPoly(NumVert: DWord; var Vert);
var
  Addr: Pointer;
  i, X1, Y1, X, Y: DWord;
  tX, tY: LongInt;
begin
  if NumVert < 3 then
  begin
    GrResult := grError;
    exit;
  end;
  Addr := @Vert;
  X1 := LongInt(Addr^);
  Inc(Addr,4);
  Y1 := LongInt(Addr^);
  Inc(Addr,4);
  tX := CpX;
  tY := CpY;
  MoveTo(X1,Y1);
  for i := 1 to NumVert - 1 do
  begin
    X := LongInt(Addr^);
    Inc(Addr,4);
    Y := LongInt(Addr^);
    Inc(Addr,4);
    LineTo(X,Y);
  end;
  LineTo(X1,Y1);
  CpX := tX;
  CpY := tY;
  GrResult := GrOk;
end;

procedure FillPoly(NumVert: DWord; var Vert);
assembler;
var
  X, Y, Count: DWord;
      asm
        mov     eax,[NumVert]
        cmp     eax,3
        jge     @@Pass
        mov     [GrResult],grError
        jmp     @@Quit
@@Pass: sub     eax,3
        mov     [Count],eax
        mov     edi,[Vert]
        mov     eax,[edi]
        mov     [X],eax
        mov     eax,[edi+4]
        mov     [Y],eax
@@Next: add     edi,8
        push    edi
        push    [X]
        push    [Y]
        push    dword ptr [edi+8]
        push    dword ptr [edi+12]
        push    dword ptr [edi]
        push    dword ptr [edi+4]
        call    xFillTriangle
        pop     edi
        dec     [Count]
        jns     @@Next
        mov     [GrResult],grOk
@@Quit:
end;

procedure FloodFill(X, Y: Longint; Border: DWORD);
var
  NWX, NWY, NWX1, NWY1: Longint;

  procedure FillLine(X, Y : Longint);
  var
    StartX, EndX, i : Longint;
    PixColor: DWORD;
  begin
    StartX := X;
    EndX   := X;
    PixColor :=  GetPixel(X, Y);
    if (PixColor = Border) or (PixColor = FillColor) then
      exit;

    PixColor := GetPixel(StartX - 1, Y);
    while (StartX - 1 >= NWX) and (PixColor <> Border) and (PixColor <> FillColor) do
    begin
      StartX -:= 1;
      PixColor := GetPixel(StartX - 1, Y);
    end;

    PixColor := GetPixel(EndX + 1, Y);
    while (EndX + 1 <= NWX1) and (PixColor <> Border) and (PixColor <> FillColor) do
    begin
      EndX +:= 1;
      PixColor := GetPixel(EndX + 1, Y);
    end;

    DrawHLine(StartX, EndX, Y);

    if y < NWY1 then
      for i:= StartX to EndX do
      begin
        PixColor := GetPixel(i, Y + 1);
        if (PixColor <> Border) and (PixColor <> FillColor) then
          FillLine(i, Y + 1);
      end;
    if y > NWY then
      for i := StartX to EndX do
      begin
        PixColor := GetPixel(i, Y - 1);
        if (PixColor <> Border) and (PixColor <> FillColor) then
          FillLine(i, Y - 1);
      end;
  end;

begin
  NWX :=  WndX1 + AddX;
  NWY :=  WndY1 + AddY;
  NWX1 := WndX2 + AddX;
  NWY1 := WndY2 + AddY;
  if Border = FillColor then exit;
  FillLine(X,Y);
end;

procedure ExpandFill(X, Y: Longint);
var
  NWX, NWY, NWX1, NWY1: Longint;
  StartColor: DWORD;

  procedure FillLine(X, Y : Longint);
  var
    StartX, EndX, i : Longint;
  begin
    StartX := X;
    EndX   := X;
    if GetPixel(X, Y) <> StartColor then
      exit;
    while (StartX - 1 >= NWX) and (GetPixel(StartX - 1, Y) = StartColor) do
      StartX -:= 1;
    while (EndX + 1 <= NWX1) and (GetPixel(EndX + 1, Y) = StartColor) do
      EndX +:= 1;
    DrawHLine(StartX, EndX, Y);
    if y < NWY1 then
      for i := StartX to EndX do
        if (GetPixel(i, Y + 1) = StartColor) then
          FillLine(i, Y + 1);
    if y > NWY then
      for i := StartX to EndX do
        if (GetPixel(i, Y - 1) = StartColor) then
          FillLine(i, Y - 1);
  end;

begin
  NWX  := WndX1 + AddX;
  NWY  := WndY1 + AddY;
  NWX1 := WndX2 + AddX;
  NWY1 := WndY2 + AddY;
  StartColor := GetPixel(X, Y);
  if StartColor = FillColor then exit;
  FillLine(X,Y);
end;

procedure SetCustomFont(AddrPtr: Pointer; Width, Height, Start, Space: DWord);
assembler;
      asm
        mov     eax,[AddrPtr]
        mov     [Chars.Font],eax
        mov     eax,[Space]
        mov     [Chars.Space],eax
        mov     eax,[Start]
        mov     [Chars.FirstChar],eax
        mov     eax,[Width]
        or      eax,0
        jnz     @Ok
        inc     eax
@Ok:    mov     [Chars.Width],eax
        mov     ebx,[Height]
        mov     [Chars.Height],ebx
        mul     bx
        mov     [Chars.FontSize],eax
end;

procedure SetTextStyle(Font, Direction: DWord);
begin
  case Font of
    SmallFont:   SetCustomFont(@Small,1,8,0,0);
    MediumFont:  SetCustomFont(@Medium,1,14,0,0);
    LargeFont:   SetCustomFont(@Large,1,16,0,0);
    CurrentFont: begin (* do nothing *) end;
  else
    begin
      GrResult := grError;
      exit;
    end;
  end;
  if Direction < 2 then
  begin
    Chars.Direction := Direction;
    GrResult := grOk;
  end else
    GrResult := grError;
end;

procedure SetTextJustify(Horiz, Vert: DWord);
begin
  if (Vert<3) and (Horiz<3) then
  begin
   Chars.Horiz := Horiz;
   Chars.Vert := Vert;
   GrResult := grOk;
  end else GrResult := grError;
end;

procedure GetTextSettings(var TextInfo: TextSettingsType);
begin
  TextInfo := Chars;
end;

procedure OutCharXY(X,Y: LongInt; C: Char; Color: DWord);
assembler;
      asm
@@Horizontal:
        cmp     [Chars.Direction], VertDir
        jz      @@Vertical
        mov     eax,[Chars.Height]
        sub     [Y],eax
        xor     eax,eax
        mov     al,[C]
        sub     al,byte ptr [Chars.FirstChar]
        mul     word ptr [Chars.FontSize]
        mov     edi,[Chars.Font]
        add     edi,eax
        mov     edx,[X]
        add     edx,7
        mov     ecx,[Chars.Height]
@Loop1: push    ecx
        xor     ebx,ebx
        mov     ecx,1
@Loop2: push    ecx
        movzx   eax,byte ptr [edi]
        mov     ecx,[X]
@Loop3: push    ebx
        push    edx
        push    eax
        and     eax,128
        or      eax,0
        jz      @Skip1
        push    ecx
        add     ecx,ebx
        push    ecx
        push    [Y]
        push    [Color]
        call    PutPixelB
        pop     ecx
@Skip1: pop     eax
        pop     edx
        pop     ebx
        shl     eax,1
        inc     ecx
        cmp     ecx,edx
        jle     @Loop3
        inc     edi
        add     ebx,8
        pop     ecx
        inc     ecx
        cmp     ecx,[Chars.Width]
        jle     @Loop2
        inc     [Y]
        pop     ecx
        loop    @Loop1
        jmp     @@Quit
@@Vertical:
        xor     eax,eax
        mov     al,[C]
        sub     al,byte ptr [Chars.FirstChar]
        mul     word ptr [Chars.FontSize]
        mov     edi,[Chars.Font]
        add     edi,eax
        mov     edx,[Y]
        add     edx,[Chars.Height]
        dec     edx
        mov     ecx,[Chars.Height]
        mov     esi,[Chars.Width]
@Loop4: push    ecx
        xor     ebx,ebx
        mov     ecx,1
@Loop5: push    ecx
        movzx   eax,byte ptr [edi]
        mov     ecx,[Y]
@Loop6: push    ebx
        push    edx
        push    eax
        and     eax,1
        or      eax,0
        jz      @Skip2
        push    ecx
        sub     ecx,ebx
        push    [X]
        push    ecx
        push    [Color]
        call    PutPixelB
        pop     ecx
@Skip2: pop     eax
        pop     edx
        pop     ebx
        shr     eax,1
        inc     ecx
        cmp     ecx,edx
        jle     @Loop6
        inc     edi
        add     ebx,8
        pop     ecx
        inc     ecx
        cmp     ecx,[Chars.Width]
        jle     @Loop5
        inc     [X]
        pop     ecx
        loop    @Loop4
@@Quit:
end;

function TextHeight(TextString: String): DWord;
begin
  Result := Chars.Height;
end;

function TextWidth(TextString: String): DWord;
begin
  Result := (Chars.Width+Chars.Space)*8*DWord(Length(TextString));
end;

procedure OutText(TextString: String);
var
  I,J,K: LongInt;
begin
  OutTextXY(CpX, CpY, TextString);
end;

procedure OutTextXY(X, Y: LongInt; TextString: String);
var
  I, J, K: LongInt;
begin
  if Chars.Direction=HorizDir then
  begin
    case Chars.Horiz of
      CenterText: J := X-(TextWidth(TextString) shr 1);
      LeftText:   J := X;
      RightText:  J := X-TextWidth(TextString);
    end;
    case Chars.Vert of
      CenterText: K := Y+(TextHeight(TextString) shr 1);
      BottomText: K := Y;
      TopText:    K := Y+TextHeight(TextString);
    end;
   end else
   begin
    case Chars.Horiz of
      CenterText: J := X-(TextHeight(TextString) shr 1);
      LeftText:   J := X-TextHeight(TextString);
      RightText:  J := X;
    end;
    case Chars.Vert of
      CenterText: K := Y-(TextWidth(TextString) shr 1);
      BottomText: K := Y-TextWidth(TextString);
      TopText:    K := Y;
    end;
  end;
  if Chars.Direction = VertDir then
    for I := Length(TextString) downto 1 do
    begin
      OutCharXY(J,K,TextString[I],GraphColor);
      K := K+(Chars.Width shl 3)+Chars.Space;
    end
  else
    for I := 1 to Length(TextString) do
    begin
      OutCharXY(J,K,TextString[I],GraphColor);
      J := J+(Chars.Width shl 3)+Chars.Space
    end;
end;

procedure Retrace;
{$ifdef __DOS__}
assembler;
      asm
        mov     dx,STAT_ADDR
@@VSync:
        in      al,dx
        test    al,8
        jz      @@VSync
@@NoVSync:
        in      al,dx
        test    al,8
        jnz     @@NoVSync
end;
{$endif}
{$ifdef __WIN32__}
begin
  DD_Retrace;
end;
{$endif}

procedure CliRetrace;
{$ifdef __DOS__}
assembler;
      asm
        pushf
        cli
        mov     dx,STAT_ADDR
@@VSync:
        in      al,dx
        test    al,8
        jz      @@VSync
@@NoVSync:
        in      al,dx
        test    al,8
        jnz     @@NoVSync
        popf
end;
{$endif}
{$ifdef __WIN32__}
begin
  DD_Retrace;
end;
{$endif}

procedure HRetrace;
{$ifdef __DOS__}
assembler;
      asm
        mov     dx,STAT_ADDR
@@HSync:
        in      al,dx
        test    al,1
        jz      @@HSync
        mov     dx,STAT_ADDR
@@NoHSync:
        in      al,dx
        test    al,1
        jnz     @@NoHSync
end;
{$endif}
{$ifdef __WIN32__}
begin
  (* not implemented *)
end;
{$endif}

procedure CliHRetrace;
{$ifdef __DOS__}
assembler;
      asm
        pushf
        cli
        mov     dx,STAT_ADDR
@@HSync:
        in      al,dx
        test    al,1
        jz      @@HSync
        mov     dx,STAT_ADDR
@@NoHSync:
        in      al,dx
        test    al,1
        jnz     @@NoHSync
        popf
end;
{$endif}
{$ifdef __WIN32__}
begin
  (* not implemented *)
end;
{$endif}

procedure CreatePattern(Num, Color: DWord; Pattern: FillPatternType);
assembler;
      asm
        mov     esi, Pattern
        mov     ecx, 8
        xor     edx, edx
@@Loop1:
        push    ecx
        mov     edi, dword ptr [CurrentPattern + edx]
        mov     ecx, Num
        lodsb
        ALIGN   4
@@Loop2:
        ror     al, 1
        jnc     @@BkGr
        mov     ebx, Color
        jmp     @@Pass
@@BkGr:
        mov     ebx, BkGrColor
@@Pass:
        mov     [edi], ebx
        add     edi, BytesPerPixel
        loop    @@Loop2
        add     edx, 4
        pop     ecx
        loop    @@Loop1
end;

procedure SetFillPattern(Pattern: FillPatternType; Color: DWord);
begin
  SysFillPattern[12]  :=  Pattern;
  SetFillStyle(12, Color);
  FillColor  :=  Color;
end;

procedure SetFillStyle(Pattern: DWord; Color: DWord);
begin
  if Pattern > UserFill then
    GrResult  :=  grError
  else begin
    CreatePattern(PatternBuffSize, Color, SysFillPattern[Pattern]);
    UsedPatternNo  :=  Pattern;
    FillColor  :=  Color;
    UseSolidFill  :=  FALSE;
  end;
end;

procedure GetFillPattern(var FillPattern: FillPatternType);
begin
  Move(SysFillPattern[UsedPatternNo], FillPattern, SizeOf(FillPattern));
end;

procedure GetFillSettings(var FillInfo: FillSettingsType);
begin
  FillInfo.Pattern  :=  UsedPatternNo;
  FillInfo.Color  :=  FillColor;
end;

{$ifndef __WIN32__}
procedure SetSplitLine(Line: DWord); assembler;
      asm
@@Next: call    Retrace
        mov     dx,CRTC_ADDR
        mov     ah,byte ptr [Line]
        mov     al,$18
        out     dx,ax
        mov     ah,byte ptr [Line+1]
        and     ah,1
        mov     cl,4
        shl     ah,cl
        mov     al,7
        out     dx,al
        inc     dx
        in      al,dx
        and     al,not $10
        or      al,ah
        out     dx,al
        dec     dx
        mov     ah,byte ptr [Line+1]
        and     ah,2
        mov     cl,3
        ror     ah,cl
        mov     al,9
        out     dx,al
        inc     dx
        in      al,dx
        and     al,not $40
        or      al,ah
        out     dx,al
end;
{$endif}

function GetDriverName: String;
begin
  if VideoMode = isMCGAMode then
    Result  :=  'MCGA'
  else
  if VideoMode = isSVGAMode then
  begin
    case BitsPerPixel of
      8:  Result  :=  'SVGA256';
      15: Result  :=  'SVGA32k';
      16: Result  :=  'SVGA64k';
      24: Result  :=  'SVGA16M';
      32: Result  :=  'SVGA4G';
    end;
  end else
    Result  :=  '';
end;

function RegisterBGIDriver(Driver: Pointer): Longint;
begin
  Result  :=  -1;
  GrResult  :=  grError;
end;

function RegisterBGIFont(Driver: Pointer): Longint;
begin
  Result  :=  -1;
  GrResult  :=  grError;
end;

function InstallUserDriver(Name: String; AutoDetectPtr: Pointer): Longint;
begin
  Result   := grError;
  GrResult := grError;
end;

function InstallUserFont(FontFileName: String): Longint;
begin
  Result   := grError;
  GrResult := grError;
end;

procedure DetectGraph(var GraphDriver: Integer; var GraphMode: Integer);
var
  i: DWord;
begin
  GraphDriver := MCGA;
  GraphMode   := MCGAC0;
  if VbeVer <> 0 then
  begin
    for i  :=  0 to VbeModes - 1 do
    begin
      if (VbeModesList[i].XResolution  = 640) and
         (VbeModesList[i].YResolution  = 480) and
         (VbeModesList[i].BitsPerPixel = 8)  then
       begin
         GraphDriver  :=  SVGA256;
         GraphMode    :=  SVGALo;
       end;
    end;
  end;
end;

procedure InitGraph(var GraphDriver: Integer; var GraphMode: Integer; Dummy: String);
var
  Bpp, XRes, YRes: DWord  :=  0;
begin
  if GraphDriver = Detect then
    DetectGraph(GraphDriver, GraphMode);
  case GraphDriver of
    MCGA   : begin
               if GraphDriver in [MCGAC0..MCGAC3] then
               begin
{$ifdef __DOS__}
                 SetGraphMode($13);
{$endif}
{$ifdef __WIN32}
                 SetSVGAMode(320, 200, 8, LfbOnly);
{$endif}
                 exit;
               end;
             end;
    VGA    : begin
               case GraphMode of
                 VGAMed: begin
                           SetSVGAMode(640, 350, 8, LfbOrBanked);
                           exit;
                         end;
                 VGAHi : begin
                           SetSVGAMode(640, 480, 8, LfbOrBanked);
                           exit;
                         end;
               end;
             end;
    EGA    : begin
               if GraphMode = EGAHi then
               begin
                 SetSVGAMode(640, 350, 8, LfbOrBanked);
                 exit;
               end;
             end;
    SVGA256: Bpp := 8;
    SVGA64K: Bpp := 16;
    SVGA16M: Bpp := 24;
    SVGA4G : Bpp := 32;
  end;
  case GraphMode of
    SVGALo : begin XRes  :=  640;  YRes  :=  480;  end;
    SVGAMed: begin XRes  :=  800;  YRes  :=  600;  end;
    SVGAHi : begin XRes  :=  1024; YRes  :=  768;  end;
    SVGA0  : begin XRes  :=  320;  YRes  :=  200;  end;
    SVGA1  : begin XRes  :=  320;  YRes  :=  240;  end;
    SVGA2  : begin XRes  :=  512;  YRes  :=  384;  end;
    SVGA3  : begin XRes  :=  640;  YRes  :=  350;  end;
    SVGA4  : begin XRes  :=  640;  YRes  :=  400;  end;
    SVGA5  : begin XRes  :=  1152; YRes  :=  864;  end;
    SVGA6  : begin XRes  :=  1280; YRes  :=  1024; end;
    SVGA7  : begin XRes  :=  1600; YRes  :=  1200; end;
  end;
  SetSVGAMode(XRes, YRes, Bpp, LfbOrBanked);
  if (XRes = 0) or (Bpp = 0) then
  begin
    GrResult  :=  grInvalidMode;
    exit;
  end;
  if (Bpp = 0) or (GraphDriver in [CGA, EGA..PC3270]) then
  begin
    GrResult  :=  grInvalidDriver;
    exit;
  end;
end;

var
  i: DWord;
begin
  ProcsReset;
{$ifdef __DOS__}
  InitVbe;
  LastMode := GetGraphMode;
{$endif}
{$ifdef __WIN32__}
  DirectXEnabled := DD_Init;
{$endif}
  SetTextStyle(LargeFont,HorizDir);
  SetTextJustify(LeftText,CenterText);

  for i  :=  1 to 8 do
    GetMem(CurrentPattern[i], PatternBuffSize * 4);
end

postlude
begin
{$ifdef __WIN32__}
  DD_Done;
  PostQuitMessage(0);
{$endif}
end.
