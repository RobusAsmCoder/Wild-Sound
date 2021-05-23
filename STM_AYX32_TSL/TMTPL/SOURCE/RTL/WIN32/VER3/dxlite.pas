(****************************************************************)
(*                                                              *)
(*       TMT Pascal 3 Runtime Library                           *)
(*       MS DirectX Lite Unit v.1.00                            *)
(*       Target: Win32 only                                     *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Portions Copyright (c) by Microsoft Corporation,       *)
(*       Also some parts of code based on DirectX7 Delphi port  *)
(*       by Erik Unger and Arne Schôpers                        *)
(*       Author: Vadim Bodrov, TMT Development Corp.            *)
(*                                                              *)
(****************************************************************)

{$w-,r-,q-,i-,t-,x+,v-,a+,oa+,w-,opt+}

unit dxlite;

interface

uses Strings, Windows, MMSystem;

{$DEFINE VERSION_1_0}

(************************ DirectDraw Section *******************************)

const
  DD_ROP_SPACE = (256 div 32);       // space required to store ROP array

(*
 * This flag causes GetDeviceIdentifier to return information about the host (typically 2D) adapter in a system equipped
 * with a stacked secondary 3D adapter. Such an adapter appears to the application as if it were part of the
 * host adapter, but is typically physcially located on a separate card. The stacked secondary's information is
 * returned when GetDeviceIdentifier's dwFlags field is zero, since this most accurately reflects the qualities
 * of the DirectDraw object involved.
 *)
  DDGDI_GETHOSTIDENTIFIER = 1;


{ GUID type }

type
  PGUID = ^TGUID;
  TGUID = packed record
    D1: Longint;
    D2: Word;
    D3: Word;
    D4: array[0..7] of Byte;
  end;

{ Interface ID }

  PIID    = PGUID;
  TIID    = TGUID;
  TREFIID = TIID;

{ Class ID }

  PCLSID = PGUID;
  TCLSID = TGUID;

function CoInitialize conv arg_stdcall (pvReserved: Pointer): HResult;
   external 'ole32.dll' name 'CoInitialize';

procedure CoUninitialize conv arg_stdcall;
   external 'ole32.dll' name 'CoUninitialize';

const
    GUID_NULL: TGUID =
      (D1:$00000000;D2:$0000;D3:$0000;D4:($00,$00,$00,$00,$00,$00,$00,$00));

(*
 * GUIDS used by DirectDraw objects
 *)

const
  CLSID_DirectDraw: TGUID =
      (D1:$D7B70EE0;D2:$4340;D3:$11CF;D4:($B0,$63,$00,$20,$AF,$C2,$CD,$35));
  CLSID_DirectDraw7: TGUID =
      (D1:$3c305196;D2:$50db;D3:$11d3;D4:($9c,$fe,$00,$c0,$4f,$d9,$30,$c5));
  CLSID_DirectDrawClipper: TGUID =
      (D1:$593817A0;D2:$7DB3;D3:$11CF;D4:($A2,$DE,$00,$AA,$00,$b9,$33,$56));
  IID_IDirectDraw: TGUID =
      (D1:$6C14DB80;D2:$A733;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectDraw2: TGUID =
      (D1:$B3A6F3E0;D2:$2B43;D3:$11CF;D4:($A2,$DE,$00,$AA,$00,$B9,$33,$56));
  IID_IDirectDraw4: TGUID =
      (D1:$9c59509a;D2:$39bd;D3:$11d1;D4:($8c,$4a,$00,$c0,$4f,$d9,$30,$c5));
  IID_IDirectDraw7: TGUID =
      (D1:$15e65ec0;D2:$3b9c;D3:$11d2;D4:($b9,$2f,$00,$60,$97,$97,$ea,$5b));
  IID_IDirectDrawSurface: TGUID =
      (D1:$6C14DB81;D2:$A733;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectDrawSurface2: TGUID =
      (D1:$57805885;D2:$6eec;D3:$11cf;D4:($94,$41,$a8,$23,$03,$c1,$0e,$27));
  IID_IDirectDrawSurface3: TGUID =
      (D1:$DA044E00;D2:$69B2;D3:$11D0;D4:($A1,$D5,$00,$AA,$00,$B8,$DF,$BB));
  IID_IDirectDrawSurface4: TGUID =
      (D1:$0B2B8630;D2:$AD35;D3:$11D0;D4:($8E,$A6,$00,$60,$97,$97,$EA,$5B));
  IID_IDirectDrawSurface7: TGUID =
      (D1:$06675a80;D2:$3b9b;D3:$11d2;d4:($b9,$2f,$00,$60,$97,$97,$EA,$5B));
  IID_IDirectDrawPalette: TGUID =
      (D1:$6C14DB84;D2:$A733;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectDrawClipper: TGUID =
      (D1:$6C14DB85;D2:$A733;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectDrawColorControl: TGUID =
      (D1:$4B9F0EE0;D2:$0D7E;D3:$11D0;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  ID_IDirectDrawGammaControl: TGUID =
      (D1:$69C11C3E;D2:$B46B;D3:$11D1;D4:($AD,$7A,$00,$C0,$4F,$C2,$9B,$4E));

type
  PDDColorKey = ^TDDColorKey;
  TDDColorKey = packed record
    dwColorSpaceLowValue: DWORD;     // low boundary of color space that is to
                                     // be treated as Color Key, inclusive
    dwColorSpaceHighValue: DWORD;    // high boundary of color space that is
                                     // to be treated as Color Key, inclusive
  end;

type
  PDDPixelFormat = ^TDDPixelFormat;
  TDDPixelFormat = packed record
    dwSize: DWORD;                   // size of structure
    dwFlags: DWORD;                  // pixel format flags
    dwFourCC: DWORD;                 // (FOURCC code)
    case Longint of
    0: (
      dwRGBBitCount: DWORD;          // how many bits per pixel
      dwRBitMask: DWORD;             // mask for red bit
      dwGBitMask: DWORD;             // mask for green bits
      dwBBitMask: DWORD;             // mask for blue bits
      dwRGBAlphaBitMask: DWORD;      // mask for alpha channel
     );
    1: (
      dwYUVBitCount: DWORD;          // how many bits per pixel
      dwYBitMask: DWORD;             // mask for Y bits
      dwUBitMask: DWORD;             // mask for U bits
      dwVBitMask: DWORD;             // mask for V bits
      dwYUVAlphaBitMask: DWORD;      // mask for alpha channel
     );
    2: (
      dwZBufferBitDepth: DWORD;      // how many bits for z buffers
     );
    3: (
      dwAlphaBitDepth: DWORD;        // how many bits for alpha channels
     );
  end;

  PDDScaps = ^TDDScaps;
  TDDScaps = packed record
     dwCaps: DWORD;                  // capabilities of surface wanted
  end;

type
  PPUnknown = ^^IUnknown;
  IUnknown = packed record
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
  end;

(*
 * TDDSurfaceDesc
 *)

type
  PDDSurfaceDesc = ^TDDSurfaceDesc;
  TDDSurfaceDesc = packed record
    dwSize: DWORD;                   // size of the TDDSurfaceDesc structure
    dwFlags: DWORD;                  // determines what fields are valid
    dwHeight: DWORD;                 // height of surface to be created
    dwWidth: DWORD;                  // width of input surface
    case Longint of
      0: (
        lPitch: Longint;
        dwBackBufferCount: DWORD;        // number of back buffers requested
        case Longint of
        0: (
          dwMipMapCount: DWORD;          // number of mip-map levels requested
          dwAlphaBitDepth: DWORD;        // depth of alpha buffer requested
          dwReserved: DWORD;             // reserved
          lpSurface: Pointer;            // pointer to the associated surface memory
          ddckCKDestOverlay: TDDColorKey;// color key for destination overlay use
          ddckCKDestBlt: TDDColorKey;    // color key for destination blt use
          ddckCKSrcOverlay: TDDColorKey; // color key for source overlay use
          ddckCKSrcBlt: TDDColorKey;     // color key for source blt use
          ddpfPixelFormat: TDDPixelFormat;// pixel format description of the surface
          ddsCaps: TDDSCaps;             // direct draw surface capabilities
          );
        1: (
          dwZBufferBitDepth: DWORD;      // depth of Z buffer requested
          );
        2: (
          dwRefreshRate: DWORD;          // refresh rate (used when display mode is described)
          );
      );
      1: (
        dwLinearSize: DWORD
      );
  end;

  DDSURFACEDESC = TDDSurfaceDesc;
  LPDDSURFACEDESC = PDDSurfaceDesc;

(*
 * TDDSCaps2 structure
 *)

  PDDSCaps2 = ^TDDSCaps2;
  TDDSCaps2 = packed record
    dwCaps: DWORD;         // capabilities of surface wanted
    dwCaps2: DWORD;
    dwCaps3: DWORD;
    dwCaps4: DWORD;
  end;

  DDSCAPS2 = TDDSCaps2;
  LPDDSCAPS2 = PDDSCaps2;


(*
 * TDDSurfaceDesc2 structure
 *)

  PDDSurfaceDesc2 = ^TDDSurfaceDesc2;
  TDDSurfaceDesc2 = packed record
    dwSize: DWORD;                   // size of the TDDSurfaceDesc structure
    dwFlags: DWORD;                  // determines what fields are valid
    dwHeight: DWORD;                 // height of surface to be created
    dwWidth: DWORD;                  // width of input surface
    case Longint of
      0: (
        lPitch: Longint;
        dwBackBufferCount: DWORD;        // number of back buffers requested
        case Longint of
        0: (
          dwMipMapCount: DWORD;          // number of mip-map levels requested
          dwAlphaBitDepth: DWORD;        // depth of alpha buffer requested
          dwReserved: DWORD;             // reserved
          lpSurface: Pointer;            // pointer to the associated surface memory
          ddckCKDestOverlay: TDDColorKey;// color key for destination overlay use
          ddckCKDestBlt: TDDColorKey;    // color key for destination blt use
          ddckCKSrcOverlay: TDDColorKey; // color key for source overlay use
          ddckCKSrcBlt: TDDColorKey;     // color key for source blt use
          ddpfPixelFormat: TDDPixelFormat;// pixel format description of the surface
          ddsCaps: TDDSCaps2;            // direct draw surface capabilities
          dwTextureStage: DWORD;         // stage in multitexture cascade
          );
        1: (
          dwRefreshRate: DWORD;          // refresh rate (used when display mode is described)
          );
      );
      1: (
        dwLinearSize: DWORD
      );
  end;

type
  PPDirectDrawClipper = ^^IDirectDrawClipper;
  IDirectDrawClipper = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectDrawClipper methods ***)
    GetClipList: function conv arg_stdcall (Self: Pointer; lpRect: PRect; lpClipList: PRgnData; var lpdwSize: DWORD): HResult;
    GetHWnd: function conv arg_stdcall (Self: Pointer; var lphWnd: HWND): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpDD: PPDirectDrawClipper; dwFlags: DWORD): HResult;
    IsClipListChanged: function conv arg_stdcall (Self: Pointer; var lpbChanged: BOOL): HResult;
    SetClipList: function conv arg_stdcall (Self: Pointer; lpClipList: PRgnData; dwFlags: DWORD): HResult;
    SetHWnd: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; hWnd: HWND): HResult;
  end;

type
  PPDirectDrawPalette = ^^IDirectDrawPalette;
  IDirectDrawPalette = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectDrawPalette methods ***)
    GetCaps: function conv arg_stdcall (Self: Pointer; var lpdwCaps: DWORD): HResult;
    GetEntries: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; dwBase: DWORD; dwNumEntries: DWORD; lpEntries: Pointer) : HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpDD: Pointer; dwFlags: DWORD; lpDDColorTable: Pointer) : HResult;
    SetEntries: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; dwStartingEntry: DWORD; dwCount: DWORD; lpEntries: pointer) : HResult;
  end;

type
  PDDBltFX = ^TDDBltFX;
  TDDBltFX = packed record
    dwSize                        : DWORD;     // size of structure
    dwDDFX                        : DWORD;     // FX operations
    dwROP                         : DWORD;     // Win32 raster operations
    dwDDROP                       : DWORD;     // Raster operations new for DirectDraw
    dwRotationAngle               : DWORD;     // Rotation angle for blt
    dwZBufferOpCode               : DWORD;     // ZBuffer compares
    dwZBufferLow                  : DWORD;     // Low limit of Z buffer
    dwZBufferHigh                 : DWORD;     // High limit of Z buffer
    dwZBufferBaseDest             : DWORD;     // Destination base value
    dwZDestConstBitDepth          : DWORD;     // Bit depth used to specify Z constant for destination
    case Longint of
    0: (
         dwZDestConst             : DWORD      // Constant to use as Z buffer for dest
       );
    1: (
      lpDDSZBufferDest            : Pointer;   // Surface to use as Z buffer for dest
      dwZSrcConstBitDepth         : DWORD;     // Bit depth used to specify Z constant for source
      case Longint of
      0: (
           dwZSrcConst            : DWORD;     // Constant to use as Z buffer for src
         );
      1: (
        lpDDSZBufferSrc           : Pointer;   // Surface to use as Z buffer for src
        dwAlphaEdgeBlendBitDepth  : DWORD;     // Bit depth used to specify constant for alpha edge blend
        dwAlphaEdgeBlend          : DWORD;     // Alpha for edge blending
        dwReserved                : DWORD;
        dwAlphaDestConstBitDepth  : DWORD;     // Bit depth used to specify alpha constant for destination
        case Longint of
        0: (
             dwAlphaDestConst     : DWORD;     // Constant to use as Alpha Channel
           );
        1: (
          lpDDSAlphaDest          : Pointer; // Surface to use as Alpha Channel
          dwAlphaSrcConstBitDepth : DWORD;     // Bit depth used to specify alpha constant for source
          case Longint of
          0: (
               dwAlphaSrcConst    : DWORD;     // Constant to use as Alpha Channel
             );
          1: (
            lpDDSAlphaSrc         : Pointer; // Surface to use as Alpha Channel
            case Longint of
            0: (
                 dwFillColor      : DWORD;     // color in RGB or Palettized
               );
            1: (
                 dwFillDepth      : DWORD;     // depth value for z-buffer
               );
            2: (
                 dwFillPixel      : DWORD;     // pixel value
               );
            3: (
                 lpDDSPattern     : Pointer; // Surface to use as pattern
                 ddckDestColorkey    : TDDColorKey; // DestColorkey override
                 ddckSrcColorkey     : TDDColorKey; // SrcColorkey override
            )
        )
      )
    )
  )
  end;

type
  PDDBltBatch = ^TDDBltBatch;
  TDDBltBatch = packed record
    lprDest: PRect;
    lpDDSSrc: Pointer;
    lprSrc: PRect;
    dwFlags: DWORD;
    lpDDBltFx: TDDBltFX;
  end;

type
  TDDEnumModesCallback = function conv arg_stdcall (const lpDDSurfaceDesc: TDDSurfaceDesc;
      lpContext: Pointer): HResult;
  LPDDENUMMODESCALLBACK = TDDEnumModesCallback;

  TDDEnumSurfacesCallback = function conv arg_stdcall (lpDDSurface: Pointer;
      const lpDDSurfaceDesc: TDDSurfaceDesc; lpContext: Pointer): HResult;
  LPDDENUMSURFACESCALLBACK = TDDEnumSurfacesCallback;

  TDDEnumModesCallback2 = function conv arg_stdcall (const lpDDSurfaceDesc: TDDSurfaceDesc2; lpContext: Pointer): HResult;
  LPDDENUMMODESCALLBACK2 = TDDEnumModesCallback2;

  TDDEnumSurfacesCallback2 = function conv arg_stdcall (lpDDSurface: Pointer; const lpDDSurfaceDesc: TDDSurfaceDesc2; lpContext: Pointer): HResult;
  LPDDENUMSURFACESCALLBACK2 = TDDEnumSurfacesCallback2;

  TDDEnumSurfacesCallback7 = function conv arg_stdcall (lpDDSurface: Pointer; const lpDDSurfaceDesc: TDDSurfaceDesc2; lpContext: Pointer): HResult;
  LPDDENUMSURFACESCALLBACK7 = TDDEnumSurfacesCallback7;

type
  PDDOverlayFX = ^TDDOverlayFX;
  TDDOverlayFX = packed record
    dwSize: DWORD;                         // size of structure
    dwAlphaEdgeBlendBitDepth: DWORD;       // Bit depth used to specify constant for alpha edge blend
    dwAlphaEdgeBlend: DWORD;               // Constant to use as alpha for edge blend
    dwReserved: DWORD;
    dwAlphaDestConstBitDepth: DWORD;       // Bit depth used to specify alpha constant for destination
    case Longint of
    0: (
         dwAlphaDestConst: DWORD;          // Constant to use as alpha channel for dest
         dwAlphaSrcConstBitDepth: DWORD;   // Bit depth used to specify alpha constant for source
         dwAlphaSrcConst: DWORD;           // Constant to use as alpha channel for src
         dckDestColorkey: TDDColorKey;     // DestColorkey override
         dckSrcColorkey: TDDColorKey;      // DestColorkey override
         dwDDFX: DWORD;                    // Overlay FX
         dwFlags: DWORD;                   // flags
       );
    1: (
         lpDDSAlphaDest: Pointer;          // Surface to use as alpha channel for dest
         UNIONFILLER1b: DWORD;
         lpDDSAlphaSrc: Pointer;           // Surface to use as alpha channel for src
       );
  end;

(*
 * IDirectDrawSurface and related interfaces
 *)

type
  PPDirectDrawSurface = ^^IDirectDrawSurface;
  IDirectDrawSurface = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectDrawSurface methods ***)
    AddAttachedSurface: function conv arg_stdcall (Self: Pointer; lpDDSAttachedSurface: PPDirectDrawSurface): HResult;
    AddOverlayDirtyRect: function conv arg_stdcall (Self: Pointer; const lpRect: TRect): HResult;
    Blt: function conv arg_stdcall (Self: Pointer; lpDestRect: PRect; lpDDSrcSurface: PPDirectDrawSurface; lpSrcRect: PRect; dwFlags: DWORD; lpDDBltFx: PDDBltFX): HResult;
    BltBatch: function conv arg_stdcall (Self: Pointer; const lpDDBltBatch: TDDBltBatch; dwCount: DWORD; dwFlags: DWORD) : HResult;
    BltFast: function conv arg_stdcall (Self: Pointer; dwX: DWORD; dwY: DWORD; lpDDSrcSurface: PPDirectDrawSurface; const lpSrcRect: TRect; dwTrans: DWORD): HResult;
    DeleteAttachedSurface: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpDDSAttachedSurface: PPDirectDrawSurface): HResult;
    EnumAttachedSurfaces: function conv arg_stdcall (Self: Pointer; lpContext: Pointer; lpEnumSurfacesCallback: TDDEnumSurfacesCallback): HResult;
    EnumOverlayZOrders: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpContext: Pointer; lpfnCallback: TDDEnumSurfacesCallback): HResult;
    Flip: function conv arg_stdcall (Self: Pointer; lpDDSurfaceTargetOverride: PPDirectDrawSurface; dwFlags: DWORD): HResult;
    GetAttachedSurface: function conv arg_stdcall (Self: Pointer; var lpDDSCaps: TDDSCaps; var lplpDDAttachedSurface: PPDirectDrawSurface): HResult;
    GetBltStatus: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    GetCaps: function conv arg_stdcall (Self: Pointer; var lpDDSCaps: TDDSCaps): HResult;
    GetClipper: function conv arg_stdcall (Self: Pointer; var lplpDDClipper: PPDirectDrawClipper): HResult;
    GetColorKey: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; var lpDDColorKey: TDDColorKey): HResult;
    GetDC: function conv arg_stdcall (Self: Pointer; var lphDC: HDC): HResult;
    GetFlipStatus: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    GetOverlayPosition: function conv arg_stdcall (Self: Pointer; var lplX, lplY: LongInt): HResult;
    GetPalette: function conv arg_stdcall (Self: Pointer; var lplpDDPalette: PPDirectDrawPalette): HResult;
    GetPixelFormat: function conv arg_stdcall (Self: Pointer; var lpDDPixelFormat: TDDPixelFormat): HResult;
    GetSurfaceDesc: function conv arg_stdcall (Self: Pointer; var lpDDSurfaceDesc: TDDSurfaceDesc): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpDD: Pointer; const lpDDSurfaceDesc: TDDSurfaceDesc): HResult;
    IsLost: function conv arg_stdcall (Self: Pointer): HResult;
    Lock: function conv arg_stdcall (Self: Pointer; lpDestRect: PRect; var lpDDSurfaceDesc: TDDSurfaceDesc; dwFlags: DWORD; hEvent: THandle): HResult;
    ReleaseDC: function conv arg_stdcall (Self: Pointer; hDC: HDC): HResult;
    Restore: function conv arg_stdcall (Self: Pointer): HResult;
    SetClipper: function conv arg_stdcall (Self: Pointer; lpDDClipper: PPDirectDrawClipper): HResult;
    SetColorKey: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; const lpDDColorKey: TDDColorKey): HResult;
    SetOverlayPosition: function conv arg_stdcall (Self: Pointer; lX, lY: LongInt): HResult;
    SetPalette: function conv arg_stdcall (Self: Pointer; lpDDPalette: PPDirectDrawPalette): HResult;
    Unlock: function conv arg_stdcall (Self: Pointer; lpSurfaceData: Pointer): HResult;
    UpdateOverlay: function conv arg_stdcall (Self: Pointer; lpSrcRect: PRect; lpDDDestSurface: PPDirectDrawSurface; lpDestRect: PRect; dwFlags: DWORD; const lpDDOverlayFx: TDDOverlayFX): HResult;
    UpdateOverlayDisplay: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    UpdateOverlayZOrder: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpDDSReference: PPDirectDrawSurface): HResult;
  end;

(*
 * IDirectDrawSurface2 and related interfaces
 *)

type
  PPDirectDrawSurface2 = ^^IDirectDrawSurface2;
  IDirectDrawSurface2 = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectDrawSurface2 methods ***)
    AddAttachedSurface: function conv arg_stdcall (Self: Pointer; lpDDSAttachedSurface: PPDirectDrawSurface): HResult;
    AddOverlayDirtyRect: function conv arg_stdcall (Self: Pointer; const lpRect: TRect): HResult;
    Blt: function conv arg_stdcall (Self: Pointer; lpDestRect: PRect; lpDDSrcSurface: PPDirectDrawSurface; lpSrcRect: PRect; dwFlags: DWORD; lpDDBltFx: PDDBltFX): HResult;
    BltBatch: function conv arg_stdcall (Self: Pointer; const lpDDBltBatch: TDDBltBatch; dwCount: DWORD; dwFlags: DWORD) : HResult;
    BltFast: function conv arg_stdcall (Self: Pointer; dwX: DWORD; dwY: DWORD; lpDDSrcSurface: PPDirectDrawSurface; const lpSrcRect: TRect; dwTrans: DWORD): HResult;
    DeleteAttachedSurface: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpDDSAttachedSurface: PPDirectDrawSurface): HResult;
    EnumAttachedSurfaces: function conv arg_stdcall (Self: Pointer; lpContext: Pointer; lpEnumSurfacesCallback: TDDEnumSurfacesCallback): HResult;
    EnumOverlayZOrders: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpContext: Pointer; lpfnCallback: TDDEnumSurfacesCallback): HResult;
    Flip: function conv arg_stdcall (Self: Pointer; lpDDSurfaceTargetOverride: PPDirectDrawSurface; dwFlags: DWORD): HResult;
    GetAttachedSurface: function conv arg_stdcall (Self: Pointer; var lpDDSCaps: TDDSCaps; var lplpDDAttachedSurface: PPDirectDrawSurface): HResult;
    GetBltStatus: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    GetCaps: function conv arg_stdcall (Self: Pointer; var lpDDSCaps: TDDSCaps): HResult;
    GetClipper: function conv arg_stdcall (Self: Pointer; var lplpDDClipper: PPDirectDrawClipper): HResult;
    GetColorKey: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; var lpDDColorKey: TDDColorKey): HResult;
    GetDC: function conv arg_stdcall (Self: Pointer; var lphDC: HDC): HResult;
    GetFlipStatus: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    GetOverlayPosition: function conv arg_stdcall (Self: Pointer; var lplX, lplY: LongInt): HResult;
    GetPalette: function conv arg_stdcall (Self: Pointer; var lplpDDPalette: PPDirectDrawPalette): HResult;
    GetPixelFormat: function conv arg_stdcall (Self: Pointer; var lpDDPixelFormat: TDDPixelFormat): HResult;
    GetSurfaceDesc: function conv arg_stdcall (Self: Pointer; var lpDDSurfaceDesc: TDDSurfaceDesc): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpDD: Pointer; const lpDDSurfaceDesc: TDDSurfaceDesc): HResult;
    IsLost: function conv arg_stdcall (Self: Pointer): HResult;
    Lock: function conv arg_stdcall (Self: Pointer; lpDestRect: PRect; var lpDDSurfaceDesc: TDDSurfaceDesc; dwFlags: DWORD; hEvent: THandle): HResult;
    ReleaseDC: function conv arg_stdcall (Self: Pointer; hDC: HDC): HResult;
    Restore: function conv arg_stdcall (Self: Pointer): HResult;
    SetClipper: function conv arg_stdcall (Self: Pointer; lpDDClipper: PPDirectDrawClipper): HResult;
    SetColorKey: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; const lpDDColorKey: TDDColorKey): HResult;
    SetOverlayPosition: function conv arg_stdcall (Self: Pointer; lX, lY: LongInt): HResult;
    SetPalette: function conv arg_stdcall (Self: Pointer; lpDDPalette: PPDirectDrawPalette): HResult;
    Unlock: function conv arg_stdcall (Self: Pointer; lpSurfaceData: Pointer): HResult;
    UpdateOverlay: function conv arg_stdcall (Self: Pointer; lpSrcRect: PRect; lpDDDestSurface: PPDirectDrawSurface; lpDestRect: PRect; dwFlags: DWORD; const lpDDOverlayFx: TDDOverlayFX): HResult;
    UpdateOverlayDisplay: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    UpdateOverlayZOrder: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpDDSReference: PPDirectDrawSurface): HResult;
    (*** Added in the v2 interface ***)
    GetDDInterface: function conv arg_stdcall (Self: Pointer; var lplpDD: Pointer): HResult;
    PageLock: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    PageUnlock: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
  end;

(*
 * IDirectDrawSurface2 and related interfaces
 *)

type
  PPDirectDrawSurface3 = ^^IDirectDrawSurface3;
  IDirectDrawSurface3 = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectDrawSurface3 methods ***)
    AddAttachedSurface: function conv arg_stdcall (Self: Pointer; lpDDSAttachedSurface: PPDirectDrawSurface): HResult;
    AddOverlayDirtyRect: function conv arg_stdcall (Self: Pointer; const lpRect: TRect): HResult;
    Blt: function conv arg_stdcall (Self: Pointer; lpDestRect: PRect; lpDDSrcSurface: PPDirectDrawSurface; lpSrcRect: PRect; dwFlags: DWORD; lpDDBltFx: PDDBltFX): HResult;
    BltBatch: function conv arg_stdcall (Self: Pointer; const lpDDBltBatch: TDDBltBatch; dwCount: DWORD; dwFlags: DWORD) : HResult;
    BltFast: function conv arg_stdcall (Self: Pointer; dwX: DWORD; dwY: DWORD; lpDDSrcSurface: PPDirectDrawSurface; const lpSrcRect: TRect; dwTrans: DWORD): HResult;
    DeleteAttachedSurface: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpDDSAttachedSurface: PPDirectDrawSurface): HResult;
    EnumAttachedSurfaces: function conv arg_stdcall (Self: Pointer; lpContext: Pointer; lpEnumSurfacesCallback: TDDEnumSurfacesCallback): HResult;
    EnumOverlayZOrders: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpContext: Pointer; lpfnCallback: TDDEnumSurfacesCallback): HResult;
    Flip: function conv arg_stdcall (Self: Pointer; lpDDSurfaceTargetOverride: PPDirectDrawSurface; dwFlags: DWORD): HResult;
    GetAttachedSurface: function conv arg_stdcall (Self: Pointer; var lpDDSCaps: TDDSCaps2; var lplpDDAttachedSurface: PPDirectDrawSurface): HResult;
    GetBltStatus: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    GetCaps: function conv arg_stdcall (Self: Pointer; var lpDDSCaps: TDDSCaps2): HResult;
    GetClipper: function conv arg_stdcall (Self: Pointer; var lplpDDClipper: PPDirectDrawClipper): HResult;
    GetColorKey: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; var lpDDColorKey: TDDColorKey): HResult;
    GetDC: function conv arg_stdcall (Self: Pointer; var lphDC: HDC): HResult;
    GetFlipStatus: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    GetOverlayPosition: function conv arg_stdcall (Self: Pointer; var lplX, lplY: LongInt): HResult;
    GetPalette: function conv arg_stdcall (Self: Pointer; var lplpDDPalette: PPDirectDrawPalette): HResult;
    GetPixelFormat: function conv arg_stdcall (Self: Pointer; var lpDDPixelFormat: TDDPixelFormat): HResult;
    GetSurfaceDesc: function conv arg_stdcall (Self: Pointer; var lpDDSurfaceDesc: TDDSurfaceDesc2): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpDD: Pointer; const lpDDSurfaceDesc: TDDSurfaceDesc): HResult;
    IsLost: function conv arg_stdcall (Self: Pointer): HResult;
    Lock: function conv arg_stdcall (Self: Pointer; lpDestRect: PRect; var lpDDSurfaceDesc: TDDSurfaceDesc; dwFlags: DWORD; hEvent: THandle): HResult;
    ReleaseDC: function conv arg_stdcall (Self: Pointer; hDC: HDC): HResult;
    Restore: function conv arg_stdcall (Self: Pointer): HResult;
    SetClipper: function conv arg_stdcall (Self: Pointer; lpDDClipper: PPDirectDrawClipper): HResult;
    SetColorKey: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; const lpDDColorKey: TDDColorKey): HResult;
    SetOverlayPosition: function conv arg_stdcall (Self: Pointer; lX, lY: LongInt): HResult;
    SetPalette: function conv arg_stdcall (Self: Pointer; lpDDPalette: PPDirectDrawPalette): HResult;
    Unlock: function conv arg_stdcall (Self: Pointer; lpSurfaceData: Pointer): HResult;
    UpdateOverlay: function conv arg_stdcall (Self: Pointer; lpSrcRect: PRect; lpDDDestSurface: PPDirectDrawSurface; lpDestRect: PRect; dwFlags: DWORD; const lpDDOverlayFx: TDDOverlayFX): HResult;
    UpdateOverlayDisplay: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    UpdateOverlayZOrder: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpDDSReference: PPDirectDrawSurface): HResult;
    (*** Added in the v2 interface ***)
    GetDDInterface: function conv arg_stdcall (Self: Pointer; var lplpDD: Pointer): HResult;
    PageLock: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    PageUnlock: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    (*** Added in the V3 interface ***)
    SetSurfaceDesc: function conv arg_stdcall (Self: Pointer; lpddsd: PDDSurfaceDesc; dwFlags: DWORD): HResult;
  end;

type
  PPDirectDrawSurface4 = ^^IDirectDrawSurface4;
  IDirectDrawSurface4 = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectDrawSurface4 methods ***)
    AddAttachedSurface: function conv arg_stdcall (Self: Pointer; lpDDSAttachedSurface: PPDirectDrawSurface): HResult;
    AddOverlayDirtyRect: function conv arg_stdcall (Self: Pointer; const lpRect: TRect): HResult;
    BltBatch: function conv arg_stdcall (Self: Pointer; const lpDDBltBatch: TDDBltBatch; dwCount: DWORD; dwFlags: DWORD) : HResult;
    BltFast: function conv arg_stdcall (Self: Pointer; dwX: DWORD; dwY: DWORD; lpDDSrcSurface: PPDirectDrawSurface; const lpSrcRect: TRect; dwTrans: DWORD): HResult;
    DeleteAttachedSurface: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpDDSAttachedSurface: PPDirectDrawSurface): HResult;
    EnumAttachedSurfaces: function conv arg_stdcall (Self: Pointer; lpContext: Pointer; lpEnumSurfacesCallback: TDDEnumSurfacesCallback): HResult;
    EnumOverlayZOrders: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpContext: Pointer; lpfnCallback: TDDEnumSurfacesCallback): HResult;
    Flip: function conv arg_stdcall (Self: Pointer; lpDDSurfaceTargetOverride: PPDirectDrawSurface; dwFlags: DWORD): HResult;
    GetAttachedSurface: function conv arg_stdcall (Self: Pointer; var lpDDSCaps: TDDSCaps; var lplpDDAttachedSurface: PPDirectDrawSurface): HResult;
    GetBltStatus: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    GetCaps: function conv arg_stdcall (Self: Pointer; var lpDDSCaps: TDDSCaps): HResult;
    GetClipper: function conv arg_stdcall (Self: Pointer; var lplpDDClipper: PPDirectDrawClipper): HResult;
    GetColorKey: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; var lpDDColorKey: TDDColorKey): HResult;
    GetDC: function conv arg_stdcall (Self: Pointer; var lphDC: HDC): HResult;
    GetFlipStatus: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    GetOverlayPosition: function conv arg_stdcall (Self: Pointer; var lplX, lplY: LongInt): HResult;
    GetPalette: function conv arg_stdcall (Self: Pointer; var lplpDDPalette: PPDirectDrawPalette): HResult;
    GetPixelFormat: function conv arg_stdcall (Self: Pointer; var lpDDPixelFormat: TDDPixelFormat): HResult;
    GetSurfaceDesc: function conv arg_stdcall (Self: Pointer; var lpDDSurfaceDesc: TDDSurfaceDesc): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpDD: Pointer; const lpDDSurfaceDesc: TDDSurfaceDesc): HResult;
    IsLost: function conv arg_stdcall (Self: Pointer): HResult;
    Lock: function conv arg_stdcall (Self: Pointer; lpDestRect: PRect; var lpDDSurfaceDesc: TDDSurfaceDesc; dwFlags: DWORD; hEvent: THandle): HResult;
    ReleaseDC: function conv arg_stdcall (Self: Pointer; hDC: HDC): HResult;
    Restore: function conv arg_stdcall (Self: Pointer): HResult;
    SetClipper: function conv arg_stdcall (Self: Pointer; lpDDClipper: PPDirectDrawClipper): HResult;
    SetColorKey: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; const lpDDColorKey: TDDColorKey): HResult;
    SetOverlayPosition: function conv arg_stdcall (Self: Pointer; lX, lY: LongInt): HResult;
    SetPalette: function conv arg_stdcall (Self: Pointer; lpDDPalette: PPDirectDrawPalette): HResult;
    Unlock: function conv arg_stdcall (Self: Pointer; lpSurfaceData: Pointer): HResult;
    UpdateOverlay: function conv arg_stdcall (Self: Pointer; lpSrcRect: PRect; lpDDDestSurface: PPDirectDrawSurface; lpDestRect: PRect; dwFlags: DWORD; const lpDDOverlayFx: TDDOverlayFX): HResult;
    UpdateOverlayDisplay: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    UpdateOverlayZOrder: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpDDSReference: PPDirectDrawSurface): HResult;
    (*** Added in the v2 interface ***)
    GetDDInterface: function conv arg_stdcall (Self: Pointer; var lplpDD: Pointer): HResult;
    PageLock: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    PageUnlock: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    (*** Added in the V3 interface ***)
    SetSurfaceDesc: function conv arg_stdcall (Self: Pointer; lpddsd: PDDSurfaceDesc; dwFlags: DWORD): HResult;
    (*** Added in the V4 interface ***)
    SetPrivateData: function conv arg_stdcall (Self: Pointer; const guidTag: TGUID; lpData: Pointer; cbSize: DWORD; dwFlags: DWORD): HResult;
    GetPrivateData: function conv arg_stdcall (Self: Pointer; const guidTag: TGUID; lpData: Pointer; var cbSize: DWORD): HResult;
    FreePrivateData: function conv arg_stdcall (Self: Pointer; const guidTag: TGUID): HResult;
    GetUniquenessValue: function conv arg_stdcall (Self: Pointer; var lpValue: DWORD): HResult;
    ChangeUniquenessValue: function conv arg_stdcall (Self: Pointer): HResult;
  end;

type
  PPDirectDrawSurface7 = ^^IDirectDrawSurface7;
  IDirectDrawSurface7 = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectDrawSurface7 methods ***)
    AddAttachedSurface: function conv arg_stdcall (Self: Pointer; lpDDSAttachedSurface: PPDirectDrawSurface7): HResult;
    AddOverlayDirtyRect: function conv arg_stdcall (Self: Pointer; const lpRect: TRect): HResult;
    Blt: function conv arg_stdcall (Self: Pointer; lpDestRect: PRect; lpDDSrcSurface: PPDirectDrawSurface7; lpSrcRect: PRect; dwFlags: DWORD; lpDDBltFx: PDDBltFX): HResult;
    BltBatch: function conv arg_stdcall (Self: Pointer; const lpDDBltBatch: TDDBltBatch; dwCount: DWORD; dwFlags: DWORD) : HResult;
    BltFast: function conv arg_stdcall (Self: Pointer; dwX: DWORD; dwY: DWORD; lpDDSrcSurface: PPDirectDrawSurface7; const lpSrcRect: TRect; dwTrans: DWORD): HResult;
    DeleteAttachedSurface: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpDDSAttachedSurface: PPDirectDrawSurface7): HResult;
    EnumAttachedSurfaces: function conv arg_stdcall (Self: Pointer; lpContext: Pointer; lpEnumSurfacesCallback: TDDEnumSurfacesCallback7): HResult;
    EnumOverlayZOrders: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpContext: Pointer; lpfnCallback: TDDEnumSurfacesCallback7): HResult;
    Flip: function conv arg_stdcall (Self: Pointer; lpDDSurfaceTargetOverride: PPDirectDrawSurface7; dwFlags: DWORD): HResult;
    GetAttachedSurface: function conv arg_stdcall (Self: Pointer; var lpDDSCaps: TDDSCaps2; var lplpDDAttachedSurface: PPDirectDrawSurface7): HResult;
    GetBltStatus: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    GetCaps: function conv arg_stdcall (Self: Pointer; var lpDDSCaps: TDDSCaps2): HResult;
    GetClipper: function conv arg_stdcall (Self: Pointer; var lplpDDClipper: PPDirectDrawClipper): HResult;
    GetColorKey: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; var lpDDColorKey: TDDColorKey): HResult;
    GetDC: function conv arg_stdcall (Self: Pointer; var lphDC: HDC): HResult;
    GetFlipStatus: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    GetOverlayPosition: function conv arg_stdcall (Self: Pointer; var lplX, lplY: LongInt): HResult;
    GetPalette: function conv arg_stdcall (Self: Pointer; var lplpDDPalette: PPDirectDrawPalette): HResult;
    GetPixelFormat: function conv arg_stdcall (Self: Pointer; var lpDDPixelFormat: TDDPixelFormat): HResult;
    GetSurfaceDesc: function conv arg_stdcall (Self: Pointer; var lpDDSurfaceDesc: TDDSurfaceDesc2): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpDD: Pointer; const lpDDSurfaceDesc: TDDSurfaceDesc2): HResult;
    IsLost: function conv arg_stdcall (Self: Pointer): HResult;
    Lock: function conv arg_stdcall (Self: Pointer; lpDestRect: PRect; var lpDDSurfaceDesc: TDDSurfaceDesc2; dwFlags: DWORD; hEvent: THandle): HResult;
    ReleaseDC: function conv arg_stdcall (Self: Pointer; hDC: HDC): HResult;
    Restore: function conv arg_stdcall (Self: Pointer): HResult;
    SetClipper: function conv arg_stdcall (Self: Pointer; lpDDClipper: PPDirectDrawClipper): HResult;
    SetColorKey: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; const lpDDColorKey: TDDColorKey): HResult;
    SetOverlayPosition: function conv arg_stdcall (Self: Pointer; lX, lY: LongInt): HResult;
    SetPalette: function conv arg_stdcall (Self: Pointer; lpDDPalette: PPDirectDrawPalette): HResult;
    Unlock: function conv arg_stdcall (Self: Pointer; lpSurfaceData: Pointer): HResult;
    UpdateOverlay: function conv arg_stdcall (Self: Pointer; lpSrcRect: PRect; lpDDDestSurface: PPDirectDrawSurface7; lpDestRect: PRect; dwFlags: DWORD; const lpDDOverlayFx: TDDOverlayFX): HResult;
    UpdateOverlayDisplay: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    UpdateOverlayZOrder: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpDDSReference: PPDirectDrawSurface7): HResult;
    (*** Added in the v2 interface ***)
    GetDDInterface: function conv arg_stdcall (Self: Pointer; var lplpDD: Pointer): HResult;
    PageLock: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    PageUnlock: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    (*** Added in the V3 interface ***)
    SetSurfaceDesc: function conv arg_stdcall (Self: Pointer; lpddsd: PDDSurfaceDesc2; dwFlags: DWORD): HResult;
    (*** Added in the V4 interface ***)
    SetPrivateData: function conv arg_stdcall (Self: Pointer; const guidTag: TGUID; lpData: Pointer; cbSize: DWORD; dwFlags: DWORD): HResult;
    GetPrivateData: function conv arg_stdcall (Self: Pointer; const guidTag: TGUID; lpData: Pointer; var cbSize: DWORD): HResult;
    FreePrivateData: function conv arg_stdcall (Self: Pointer; const guidTag: TGUID): HResult;
    GetUniquenessValue: function conv arg_stdcall (Self: Pointer; var lpValue: DWORD): HResult;
    ChangeUniquenessValue: function conv arg_stdcall (Self: Pointer): HResult;
    (*** Added in the V7 interface ***)
    SetPriority: function conv arg_stdcall (Self: Pointer; dwPriority: DWORD): HResult;
    GetPriority: function conv arg_stdcall (Self: Pointer; var lpdwPriority: DWORD): HResult;
    SetLOD: function conv arg_stdcall (Self: Pointer; dwMaxLOD: DWORD): HResult;
    GetLOD: function conv arg_stdcall (Self: Pointer; var lpdwMaxLOD: DWORD): HResult;
  end;

type
  PDDCaps = ^TDDCaps;
  TDDCAPS = packed record
    dwSize: DWORD;                 // size of the DDDRIVERCAPS structure
    dwCaps: DWORD;                 // driver specific capabilities
    dwCaps2: DWORD;                // more driver specific capabilites
    dwCKeyCaps: DWORD;             // color key capabilities of the surface
    dwFXCaps: DWORD;               // driver specific stretching and effects capabilites
    dwFXAlphaCaps: DWORD;          // alpha driver specific capabilities
    dwPalCaps: DWORD;              // palette capabilities
    dwSVCaps: DWORD;               // stereo vision capabilities
    dwAlphaBltConstBitDepths: DWORD;       // DDBD_2,4,8
    dwAlphaBltPixelBitDepths: DWORD;       // DDBD_1,2,4,8
    dwAlphaBltSurfaceBitDepths: DWORD;     // DDBD_1,2,4,8
    dwAlphaOverlayConstBitDepths: DWORD;   // DDBD_2,4,8
    dwAlphaOverlayPixelBitDepths: DWORD;   // DDBD_1,2,4,8
    dwAlphaOverlaySurfaceBitDepths: DWORD; // DDBD_1,2,4,8
    dwZBufferBitDepths: DWORD;             // DDBD_8,16,24,32
    dwVidMemTotal: DWORD;          // total amount of video memory
    dwVidMemFree: DWORD;           // amount of free video memory
    dwMaxVisibleOverlays: DWORD;   // maximum number of visible overlays
    dwCurrVisibleOverlays: DWORD;  // current number of visible overlays
    dwNumFourCCCodes: DWORD;       // number of four cc codes
    dwAlignBoundarySrc: DWORD;     // source rectangle alignment
    dwAlignSizeSrc: DWORD;         // source rectangle byte size
    dwAlignBoundaryDest: DWORD;    // dest rectangle alignment
    dwAlignSizeDest: DWORD;        // dest rectangle byte size
    dwAlignStrideAlign: DWORD;     // stride alignment
    dwRops: Array [ 0..DD_ROP_SPACE-1 ] of DWORD;   // ROPS supported
    ddsCaps: TDDSCaps;                // TDDSCaps structure has all the general capabilities
    dwMinOverlayStretch: DWORD;    // minimum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxOverlayStretch: DWORD;    // maximum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinLiveVideoStretch: DWORD;  // minimum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxLiveVideoStretch: DWORD;  // maximum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinHwCodecStretch: DWORD;    // minimum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxHwCodecStretch: DWORD;    // maximum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwReserved1: DWORD;            // reserved
    dwReserved2: DWORD;            // reserved
    dwReserved3: DWORD;            // reserved
    dwSVBCaps: DWORD;              // driver specific capabilities for System->Vmem blts
    dwSVBCKeyCaps: DWORD;          // driver color key capabilities for System->Vmem blts
    dwSVBFXCaps: DWORD;            // driver FX capabilities for System->Vmem blts
    dwSVBRops: Array [ 0..DD_ROP_SPACE-1 ] of DWORD;// ROPS supported for System->Vmem blts
    dwVSBCaps: DWORD;              // driver specific capabilities for Vmem->System blts
    dwVSBCKeyCaps: DWORD;          // driver color key capabilities for Vmem->System blts
    dwVSBFXCaps: DWORD;            // driver FX capabilities for Vmem->System blts
    dwVSBRops: Array [ 0..DD_ROP_SPACE-1 ] of DWORD;// ROPS supported for Vmem->System blts
    dwSSBCaps: DWORD;              // driver specific capabilities for System->System blts
    dwSSBCKeyCaps: DWORD;          // driver color key capabilities for System->System blts
    dwSSBFXCaps: DWORD;            // driver FX capabilities for System->System blts
    dwSSBRops: Array [ 0..DD_ROP_SPACE-1 ] of DWORD;// ROPS supported for System->System blts
    dwMaxVideoPorts: DWORD;     // maximum number of usable video ports
    dwCurrVideoPorts: DWORD;    // current number of video ports used
    dwSVBCaps2: DWORD;          // more driver specific capabilities for System->Vmem blts
    dwNLVBCaps: DWORD;          // driver specific capabilities for non-local->local vidmem blts
    dwNLVBCaps2: DWORD;         // more driver specific capabilities non-local->local vidmem blts
    dwNLVBCKeyCaps: DWORD;      // driver color key capabilities for non-local->local vidmem blts
    dwNLVBFXCaps: DWORD;        // driver FX capabilities for non-local->local blts
    dwNLVBRops: Array [ 0..DD_ROP_SPACE-1 ] of DWORD; // ROPS supported for non-local->local blts
end;


type
  PPDirectDraw = ^^IDirectDraw;
  IDirectDraw = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectDraw methods ***)
    Compact: function conv arg_stdcall (Self: Pointer): HResult;
    CreateClipper: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; var lplpDDClipper: PPDirectDrawClipper; pUnkOuter: PPUnknown): HResult;
    CreatePalette: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpColorTable: pointer; var lplpDDPalette: PPDirectDrawPalette; pUnkOuter: PPUnknown): HResult;
    CreateSurface: function conv arg_stdcall (Self: Pointer; lpDDSurfaceDesc: TDDSurfaceDesc; var lplpDDSurface: PPDirectDrawSurface; pUnkOuter: PPUnknown): HResult;
    DuplicateSurface: function conv arg_stdcall (Self: Pointer; lpDDSurface: PPDirectDrawSurface; var lplpDupDDSurface: PPDirectDrawSurface): HResult;
    EnumDisplayModes: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpDDSurfaceDesc: PDDSurfaceDesc; lpContext: Pointer; lpEnumModesCallback: TDDEnumModesCallback): HResult;
    EnumSurfaces: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; const lpDDSD: TDDSurfaceDesc; lpContext: Pointer; lpEnumCallback: TDDEnumSurfacesCallback): HResult;
    FlipToGDISurface: function conv arg_stdcall (Self: Pointer): HResult;
    GetCaps: function conv arg_stdcall (Self: Pointer; var lpDDDriverCaps: TDDCaps; var lpDDHELCaps: TDDCaps): HResult;
    GetDisplayMode: function conv arg_stdcall (Self: Pointer; var lpDDSurfaceDesc: TDDSurfaceDesc): HResult;
    GetFourCCCodes: function conv arg_stdcall (Self: Pointer; var lpNumCodes, lpCodes: DWORD): HResult;
    GetGDISurface: function conv arg_stdcall (Self: Pointer; var lplpGDIDDSSurface: PPDirectDrawSurface): HResult;
    GetMonitorFrequency: function conv arg_stdcall (Self: Pointer; var lpdwFrequency: DWORD): HResult;
    GetScanLine: function conv arg_stdcall (Self: Pointer; var lpdwScanLine: DWORD): HResult;
    GetVerticalBlankStatus: function conv arg_stdcall (Self: Pointer; var lpbIsInVB: BOOL): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpGUID: PGUID): HResult;
    RestoreDisplayMode: function conv arg_stdcall (Self: Pointer): HResult;
    SetCooperativeLevel: function conv arg_stdcall (Self: Pointer; hWnd: HWND; dwFlags: DWORD): HResult;
    SetDisplayMode: function conv arg_stdcall (Self: Pointer; dwWidth: DWORD; dwHeight: DWORD; dwBpp: DWORD) : HResult;
    WaitForVerticalBlank: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; hEvent: THandle): HResult;
  end;

type
  PPDirectDraw2 = ^^IDirectDraw2;
  IDirectDraw2 = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectDraw2 methods ***)
    Compact: function conv arg_stdcall (Self: Pointer): HResult;
    CreateClipper: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; var lplpDDClipper: PPDirectDrawClipper; pUnkOuter: PPUnknown): HResult;
    CreatePalette: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpColorTable: pointer; var lplpDDPalette: PPDirectDrawPalette; UnkOuter: PPUnknown): HResult;
    CreateSurface: function conv arg_stdcall (Self: Pointer; const lpDDSurfaceDesc: TDDSurfaceDesc; var lplpDDSurface: PPDirectDrawSurface; pUnkOuter: PPUnknown): HResult;
    DuplicateSurface: function conv arg_stdcall (Self: Pointer; lpDDSurface: PPDirectDrawSurface; var lplpDupDDSurface: PPDirectDrawSurface): HResult;
    EnumDisplayModes: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpDDSurfaceDesc: PDDSurfaceDesc; lpContext: Pointer; lpEnumModesCallback: TDDEnumModesCallback): HResult;
    EnumSurfaces: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; const lpDDSD: TDDSurfaceDesc; lpContext: Pointer; lpEnumCallback: TDDEnumSurfacesCallback): HResult;
    FlipToGDISurface: function conv arg_stdcall (Self: Pointer): HResult;
    GetCaps: function conv arg_stdcall (Self: Pointer; var lpDDDriverCaps: TDDCaps; var lpDDHELCaps: TDDCaps): HResult;
    GetDisplayMode: function conv arg_stdcall (Self: Pointer; var lpDDSurfaceDesc: TDDSurfaceDesc): HResult;
    GetFourCCCodes: function conv arg_stdcall (Self: Pointer; var lpNumCodes, lpCodes: DWORD): HResult;
    GetGDISurface: function conv arg_stdcall (Self: Pointer; var lplpGDIDDSSurface: PPDirectDrawSurface): HResult;
    GetMonitorFrequency: function conv arg_stdcall (Self: Pointer; var lpdwFrequency: DWORD): HResult;
    GetScanLine: function conv arg_stdcall (Self: Pointer; var lpdwScanLine: DWORD): HResult;
    GetVerticalBlankStatus: function conv arg_stdcall (Self: Pointer; var lpbIsInVB: BOOL): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpGUID: PGUID): HResult;
    RestoreDisplayMode: function conv arg_stdcall (Self: Pointer): HResult;
    SetCooperativeLevel: function conv arg_stdcall (Self: Pointer; hWnd: HWND; dwFlags: DWORD): HResult;
    SetDisplayMode: function conv arg_stdcall (Self: Pointer; dwWidth: DWORD; dwHeight: DWORD; dwBPP: DWORD; dwRefreshRate: DWORD; dwFlags: DWORD): HResult;
    WaitForVerticalBlank: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; hEvent: THandle): HResult;
    GetAvailableVidMem: function conv arg_stdcall (Self: Pointer; var lpDDSCaps: TDDSCaps; var lpdwTotal, lpdwFree: DWORD): HResult;
  end;

const
  MAX_DDDEVICEID_STRING = 512;

(*
 * Flags for DirectDrawEnumerateEx
 * DirectDrawEnumerateEx supercedes DirectDrawEnumerate. You must use GetProcAddress to
 * obtain a function pointer (of type LPDIRECTDRAWENUMERATEEX) to DirectDrawEnumerateEx.
 * By default, only the primary display device is enumerated.
 * DirectDrawEnumerate is equivalent to DirectDrawEnumerate(,,DDENUM_NONDISPLAYDEVICES)
 *)

(*
 * This flag causes enumeration of any GDI display devices which are part of
 * the Windows Desktop
 *)
  DDENUM_ATTACHEDSECONDARYDEVICES  =   $00000001;

(*
 * This flag causes enumeration of any GDI display devices which are not
 * part of the Windows Desktop
 *)
  DDENUM_DETACHEDSECONDARYDEVICES  =   $00000002;

(*
 * This flag causes enumeration of non-display devices
 *)
  DDENUM_NONDISPLAYDEVICES         =   $00000004;


type
  PDDDeviceIdentifier2 = ^TDDDeviceIdentifier2;
  TDDDeviceIdentifier2 = packed record
    (*
     * These elements are for presentation to the user only. They should not be used to identify particular
     * drivers, since this is unreliable and many different strings may be associated with the same
     * device, and the same driver from different vendors.
     *)
    szDriver: array[0..MAX_DDDEVICEID_STRING - 1] of Char;
    szDescription: array[0..MAX_DDDEVICEID_STRING - 1] of Char;

    (*
     * This element is the version of the DirectDraw/3D driver. It is legal to do <, > comparisons
     * on the whole 64 bits. Caution should be exercised if you use this element to identify problematic
     * drivers. It is recommended that guidDeviceIdentifier is used for this purpose.
     *
     * This version has the form:
     *  wProduct = HIWORD(liDriverVersion.HighPart)
     *  wVersion = LOWORD(liDriverVersion.HighPart)
     *  wSubVersion = HIWORD(liDriverVersion.LowPart)
     *  wBuild = LOWORD(liDriverVersion.LowPart)
     *)
    liDriverVersion: TLargeInteger;   // Defined for applications and other 32 bit components

    (*
     * These elements can be used to identify particular chipsets. Use with extreme caution.
     *   dwVendorId     Identifies the manufacturer. May be zero if unknown.
     *   dwDeviceId     Identifies the type of chipset. May be zero if unknown.
     *   dwSubSysId     Identifies the subsystem, typically this means the particular board. May be zero if unknown.
     *   dwRevision     Identifies the revision level of the chipset. May be zero if unknown.
     *)
    dwVendorId: DWORD;
    dwDeviceId: DWORD;
    dwSubSysId: DWORD;
    dwRevision: DWORD;

    (*
     * This element can be used to check changes in driver/chipset. This GUID is a unique identifier for the
     * driver/chipset pair. Use this element if you wish to track changes to the driver/chipset in order to
     * reprofile the graphics subsystem.
     * This element can also be used to identify particular problematic drivers.
     *)

    guidDeviceIdentifier: TGUID;

    (*
     * This element is used to determine the Windows Hardware Quality Lab (WHQL)
     * certification level for this driver/device pair.
     *)
     dwWHQLLevel: DWORD;
end;

type
  PPDirectDraw4 = ^^IDirectDraw4;
  IDirectDraw4 = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectDraw4 methods ***)
    Compact: function conv arg_stdcall (Self: Pointer): HResult;
    CreateClipper: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; var lplpDDClipper: PPDirectDrawClipper; pUnkOuter: PPUnknown): HResult;
    CreatePalette: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpColorTable: pointer; var lplpDDPalette: PPDirectDrawPalette; UnkOuter: PPUnknown): HResult;
    CreateSurface: function conv arg_stdcall (Self: Pointer; const lpDDSurfaceDesc: TDDSurfaceDesc2; var lplpDDSurface: Pointer; pUnkOuter: PPUnknown): HResult;
    DuplicateSurface: function conv arg_stdcall (Self: Pointer; lpDDSurface: Pointer; var lplpDupDDSurface: Pointer): HResult;
    EnumDisplayModes: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpDDSurfaceDesc: PDDSurfaceDesc2; lpContext: Pointer; lpEnumModesCallback: TDDEnumModesCallback2): HResult;
    EnumSurfaces: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; const lpDDSD: TDDSurfaceDesc2; lpContext: Pointer; lpEnumCallback: TDDEnumSurfacesCallback2): HResult;
    FlipToGDISurface: function conv arg_stdcall (Self: Pointer): HResult;
    GetCaps: function conv arg_stdcall (Self: Pointer; var lpDDDriverCaps: TDDCaps; var lpDDHELCaps: TDDCaps): HResult;
    GetDisplayMode: function conv arg_stdcall (Self: Pointer; var lpDDSurfaceDesc: TDDSurfaceDesc2): HResult;
    GetFourCCCodes: function conv arg_stdcall (Self: Pointer; var lpNumCodes, lpCodes: DWORD): HResult;
    GetGDISurface: function conv arg_stdcall (Self: Pointer; var lplpGDIDDSSurface: PPDirectDrawSurface2): HResult;
    GetMonitorFrequency: function conv arg_stdcall (Self: Pointer; var lpdwFrequency: DWORD): HResult;
    GetScanLine: function conv arg_stdcall (Self: Pointer; var lpdwScanLine: DWORD): HResult;
    GetVerticalBlankStatus: function conv arg_stdcall (Self: Pointer; var lpbIsInVB: BOOL): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpGUID: PGUID): HResult;
    RestoreDisplayMode: function conv arg_stdcall (Self: Pointer): HResult;
    SetCooperativeLevel: function conv arg_stdcall (Self: Pointer; hWnd: HWND; dwFlags: DWORD): HResult;
    SetDisplayMode: function conv arg_stdcall (Self: Pointer; dwWidth: DWORD; dwHeight: DWORD; dwBPP: DWORD; dwRefreshRate: DWORD; dwFlags: DWORD): HResult;
    WaitForVerticalBlank: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; hEvent: THandle): HResult;
    (*** Added in the v2 interface ***)
    GetAvailableVidMem: function conv arg_stdcall (Self: Pointer; var lpDDSCaps: TDDSCaps; var lpdwTotal, lpdwFree: DWORD): HResult;
    (*** Added in the v4 interface ***)
    GetSurfaceFromDC: function conv arg_stdcall (Self: Pointer; DC: HDC; LPDIRECTDRAWSURFACE4: Pointer): HResult;
    RestoreAllSurfaces: function conv arg_stdcall (Self: Pointer): HResult;
    TestCooperativeLevel: function conv arg_stdcall (Self: Pointer): HResult;
    GetDeviceIdentifier: function conv arg_stdcall (Self: Pointer; var lpdddeviceidentifier: TDDPixelFormat; dwFlags: DWORD): HResult;
  end;

type
  PPDirectDraw7 = ^^IDirectDraw7;
  IDirectDraw7 = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectDraw7 methods ***)
    Compact: function conv arg_stdcall (Self: Pointer): HResult;
    CreateClipper: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; var lplpDDClipper: PPDirectDrawClipper; pUnkOuter: PPUnknown): HResult;
    CreatePalette: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpColorTable: Pointer; var lplpDDPalette: PPDirectDrawPalette; UnkOuter: PPUnknown): HResult;
    CreateSurface: function conv arg_stdcall (Self: Pointer; const lpDDSurfaceDesc: TDDSurfaceDesc2; var lplpDDSurface: Pointer; pUnkOuter: PPUnknown): HResult;
    DuplicateSurface: function conv arg_stdcall (Self: Pointer; lpDDSurface: Pointer; var lplpDupDDSurface: Pointer): HResult;
    EnumDisplayModes: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; lpDDSurfaceDesc: PDDSurfaceDesc2; lpContext: Pointer; lpEnumModesCallback: TDDEnumModesCallback2): HResult;
    EnumSurfaces: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; const lpDDSD: TDDSurfaceDesc2; lpContext: Pointer; lpEnumCallback: TDDEnumSurfacesCallback2): HResult;
    FlipToGDISurface: function conv arg_stdcall (Self: Pointer): HResult;
    GetCaps: function conv arg_stdcall (Self: Pointer; var lpDDDriverCaps: TDDCaps; var lpDDHELCaps: TDDCaps): HResult;
    GetDisplayMode: function conv arg_stdcall (Self: Pointer; var lpDDSurfaceDesc: TDDSurfaceDesc2): HResult;
    GetFourCCCodes: function conv arg_stdcall (Self: Pointer; var lpNumCodes, lpCodes: DWORD): HResult;
    GetGDISurface: function conv arg_stdcall (Self: Pointer; var lplpGDIDDSSurface: Pointer): HResult;
    GetMonitorFrequency: function conv arg_stdcall (Self: Pointer; var lpdwFrequency: DWORD): HResult;
    GetScanLine: function conv arg_stdcall (Self: Pointer; var lpdwScanLine: DWORD): HResult;
    GetVerticalBlankStatus: function conv arg_stdcall (Self: Pointer; var lpbIsInVB: BOOL): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpGUID: PGUID): HResult;
    RestoreDisplayMode: function conv arg_stdcall (Self: Pointer): HResult;
    SetCooperativeLevel: function conv arg_stdcall (Self: Pointer; hWnd: HWND; dwFlags: DWORD): HResult;
    SetDisplayMode: function conv arg_stdcall (Self: Pointer; dwWidth: DWORD; dwHeight: DWORD; dwBPP: DWORD; dwRefreshRate: DWORD; dwFlags: DWORD): HResult;
    WaitForVerticalBlank: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; hEvent: THandle): HResult;
    (*** Added in the v2 interface ***)
    GetAvailableVidMem: function conv arg_stdcall (Self: Pointer; var lpDDSCaps: TDDSCaps2; var lpdwTotal, lpdwFree: DWORD): HResult;
    (*** Added in the v4 interface ***)
    GetSurfaceFromDC: function conv arg_stdcall (Self: Pointer; DC: HDC; LPDIRECTDRAWSURFACE7: Pointer): HResult;
    RestoreAllSurfaces: function conv arg_stdcall (Self: Pointer): HResult;
    TestCooperativeLevel: function conv arg_stdcall (Self: Pointer): HResult;
    GetDeviceIdentifier: function conv arg_stdcall (Self: Pointer; var lpdddeviceidentifier: TDDDeviceIdentifier2; dwFlags: DWORD): HResult;
  end;

type
  PPDirectDrawColorControl = ^^IDirectDrawColorControl;
  IDirectDrawColorControl = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectDrawColorControl methods ***)
    GetColorControls: function conv arg_stdcall (Self: Pointer; lpColorControl: Pointer): HResult;
    SetColorControls: function conv arg_stdcall (Self: Pointer; lpColorControl: Pointer): HResult;
  end;

const

(*
 * ddsCaps field is valid.
 *)
  DDSD_CAPS               = $00000001;     // default

(*
 * dwHeight field is valid.
 *)
  DDSD_HEIGHT             = $00000002;

(*
 * dwWidth field is valid.
 *)
  DDSD_WIDTH              = $00000004;

(*
 * lPitch is valid.
 *)
  DDSD_PITCH              = $00000008;

(*
 * dwBackBufferCount is valid.
 *)
  DDSD_BACKBUFFERCOUNT    = $00000020;

(*
 * dwZBufferBitDepth is valid.
 *)
  DDSD_ZBUFFERBITDEPTH    = $00000040;

(*
 * dwAlphaBitDepth is valid.
 *)
   DDSD_ALPHABITDEPTH      = $00000080;

(*
 * lpSurface is valid.
 *)
  DDSD_LPSURFACE           = $00000800;

(*
 * ddpfPixelFormat is valid.
 *)
  DDSD_PIXELFORMAT        = $00001000;

(*
 * ddckCKDestOverlay is valid.
 *)
  DDSD_CKDESTOVERLAY      = $00002000;

(*
 * ddckCKDestBlt is valid.
 *)
  DDSD_CKDESTBLT          = $00004000;

(*
 * ddckCKSrcOverlay is valid.
 *)
  DDSD_CKSRCOVERLAY       = $00008000;

(*
 * ddckCKSrcBlt is valid.
 *)
  DDSD_CKSRCBLT           = $00010000;

(*
 * dwMipMapCount is valid.
 *)
  DDSD_MIPMAPCOUNT        = $00020000;

 (*
  * dwRefreshRate is valid
  *)
  DDSD_REFRESHRATE        = $00040000;

(*
 * dwLinearSize is valid
 *)
  DDSD_LINEARSIZE         = $00080000;

(*
 * All input fields are valid.
 *)
  DDSD_ALL                = $000ff9ee;

(*
 * DDCOLORCONTROL
 *)

(*
 * lBrightness field is valid.
 *)
  DDCOLOR_BRIGHTNESS      = $00000001;

(*
 * lContrast field is valid.
 *)
  DDCOLOR_CONTRAST        = $00000002;

(*
 * lHue field is valid.
 *)
  DDCOLOR_HUE             = $00000004;

(*
 * lSaturation field is valid.
 *)
  DDCOLOR_SATURATION            = $00000008;

(*
 * lSharpness field is valid.
 *)
  DDCOLOR_SHARPNESS             = $00000010;

(*
 * lGamma field is valid.
 *)
  DDCOLOR_GAMMA                 = $00000020;

(*
 * lColorEnable field is valid.
 *)
  DDCOLOR_COLORENABLE           = $00000040;



(*============================================================================
 *
 * Direct Draw Capability Flags
 *
 * These flags are used to describe the capabilities of a given Surface.
 * All flags are bit flags.
 *
 *==========================================================================*)

(****************************************************************************
 *
 * DIRECTDRAWSURFACE CAPABILITY FLAGS
 *
 ****************************************************************************)
(*
 * This bit currently has no meaning.
 *)
  DDSCAPS_RESERVED1                       = $00000001;

(*
 * Indicates that this surface contains alpha information.  The pixel
 * format must be interrogated to determine whether this surface
 * contains only alpha information or alpha information interlaced
 * with pixel color data (e.g. RGBA or YUVA).
 *)
  DDSCAPS_ALPHA                           = $00000002;

(*
 * Indicates that this surface is a backbuffer.  It is generally
 * set by CreateSurface when the DDSCAPS_FLIP capability bit is set.
 * It indicates that this surface is THE back buffer of a surface
 * flipping structure.  DirectDraw supports N surfaces in a
 * surface flipping structure.  Only the surface that immediately
 * precedeces the DDSCAPS_FRONTBUFFER has this capability bit set.
 * The other surfaces are identified as back buffers by the presence
 * of the DDSCAPS_FLIP capability, their attachment order, and the
 * absence of the DDSCAPS_FRONTBUFFER and DDSCAPS_BACKBUFFER
 * capabilities.  The bit is sent to CreateSurface when a standalone
 * back buffer is being created.  This surface could be attached to
 * a front buffer and/or back buffers to form a flipping surface
 * structure after the CreateSurface call.  See AddAttachments for
 * a detailed description of the behaviors in this case.
 *)
  DDSCAPS_BACKBUFFER                      = $00000004;

(*
 * Indicates a complex surface structure is being described.  A
 * complex surface structure results in the creation of more than
 * one surface.  The additional surfaces are attached to the root
 * surface.  The complex structure can only be destroyed by
 * destroying the root.
 *)
  DDSCAPS_COMPLEX                         = $00000008;

(*
 * Indicates that this surface is a part of a surface flipping structure.
 * When it is passed to CreateSurface the DDSCAPS_FRONTBUFFER and
 * DDSCAP_BACKBUFFER bits are not set.  They are set by CreateSurface
 * on the resulting creations.  The dwBackBufferCount field in the
 * TDDSurfaceDesc structure must be set to at least 1 in order for
 * the CreateSurface call to succeed.  The DDSCAPS_COMPLEX capability
 * must always be set with creating multiple surfaces through CreateSurface.
 *)
  DDSCAPS_FLIP                            = $00000010;

(*
 * Indicates that this surface is THE front buffer of a surface flipping
 * structure.  It is generally set by CreateSurface when the DDSCAPS_FLIP
 * capability bit is set.
 * If this capability is sent to CreateSurface then a standalonw front buffer
 * is created.  This surface will not have the DDSCAPS_FLIP capability.
 * It can be attached to other back buffers to form a flipping structure.
 * See AddAttachments for a detailed description of the behaviors in this
 * case.
 *)
  DDSCAPS_FRONTBUFFER                     = $00000020;

(*
 * Indicates that this surface is any offscreen surface that is not an overlay,
 * texture, zbuffer, front buffer, back buffer, or alpha surface.  It is used
 * to identify plain vanilla surfaces.
 *)
  DDSCAPS_OFFSCREENPLAIN                  = $00000040;

(*
 * Indicates that this surface is an overlay.  It may or may not be directly visible
 * depending on whether or not it is currently being overlayed onto the primary
 * surface.  DDSCAPS_VISIBLE can be used to determine whether or not it is being
 * overlayed at the moment.
 *)
  DDSCAPS_OVERLAY                         = $00000080;

(*
 * Indicates that unique DirectDrawPalette objects can be created and
 * attached to this surface.
 *)
  DDSCAPS_PALETTE                         = $00000100;

(*
 * Indicates that this surface is the primary surface.  The primary
 * surface represents what the user is seeing at the moment.
 *)
  DDSCAPS_PRIMARYSURFACE                  = $00000200;

(*
 * Indicates that this surface is the primary surface for the left eye.
 * The primary surface for the left eye represents what the user is seeing
 * at the moment with the users left eye.  When this surface is created the
 * DDSCAPS_PRIMARYSURFACE represents what the user is seeing with the users
 * right eye.
 *)
  DDSCAPS_PRIMARYSURFACELEFT              = $00000400;

(*
 * Indicates that this surface memory was allocated in system memory
 *)
  DDSCAPS_SYSTEMMEMORY                    = $00000800;

(*
 * Indicates that this surface can be used as a 3D texture.  It does not
 * indicate whether or not the surface is being used for that purpose.
 *)
  DDSCAPS_TEXTURE                         = $00001000;

(*
 * Indicates that a surface may be a destination for 3D rendering.  This
 * bit must be set in order to query for a Direct3D Device Interface
 * from this surface.
 *)
  DDSCAPS_3DDEVICE                        = $00002000;

(*
 * Indicates that this surface exists in video memory.
 *)
  DDSCAPS_VIDEOMEMORY                     = $00004000;

(*
 * Indicates that changes made to this surface are immediately visible.
 * It is always set for the primary surface and is set for overlays while
 * they are being overlayed and texture maps while they are being textured.
 *)
  DDSCAPS_VISIBLE                         = $00008000;

(*
 * Indicates that only writes are permitted to the surface.  Read accesses
 * from the surface may or may not generate a protection fault, but the
 * results of a read from this surface will not be meaningful.  READ ONLY.
 *)
  DDSCAPS_WRITEONLY                       = $00010000;

(*
 * Indicates that this surface is a z buffer. A z buffer does not contain
 * displayable information.  Instead it contains bit depth information that is
 * used to determine which pixels are visible and which are obscured.
 *)
  DDSCAPS_ZBUFFER                         = $00020000;

(*
 * Indicates surface will have a DC associated long term
 *)
  DDSCAPS_OWNDC                           = $00040000;

(*
 * Indicates surface should be able to receive live video
 *)
  DDSCAPS_LIVEVIDEO                       = $00080000;

(*
 * Indicates surface should be able to have a stream decompressed
 * to it by the hardware.
 *)
  DDSCAPS_HWCODEC                         = $00100000;

(*
 * Surface is a ModeX surface.
 *)
  DDSCAPS_MODEX                           = $00200000;

(*
 * Indicates surface is one level of a mip-map. This surface will
 * be attached to other DDSCAPS_MIPMAP surfaces to form the mip-map.
 * This can be done explicitly, by creating a number of surfaces and
 * attaching them with AddAttachedSurface or by implicitly by CreateSurface.
 * If this bit is set then DDSCAPS_TEXTURE must also be set.
 *)
  DDSCAPS_MIPMAP                          = $00400000;

(*
 * This bit is reserved. It should not be specified.
 *)
  DDSCAPS_RESERVED2                       = $00800000;

(*
 * Indicates that memory for the surface is not allocated until the surface
 * is loaded (via the Direct3D texture Load() function).
 *)
  DDSCAPS_ALLOCONLOAD                     = $04000000;

(*
 * Indicates that the surface will recieve data from a video port.
 *)
  DDSCAPS_VIDEOPORT                       = $08000000;

(*
 * Indicates that a video memory surface is resident in TRUE, local video
 * memory rather than non-local video memory. If this flag is specified then
 * so must DDSCAPS_VIDEOMEMORY. This flag is mutually exclusive with
 * DDSCAPS_NONLOCALVIDMEM.
 *)
  DDSCAPS_LOCALVIDMEM                     = $10000000;

(*
 * Indicates that a video memory surface is resident in non-local video
 * memory rather than TRUE, local video memory. If this flag is specified
 * then so must DDSCAPS_VIDEOMEMORY. This flag is mutually exclusive with
 * DDSCAPS_LOCALVIDMEM.
 *)
  DDSCAPS_NONLOCALVIDMEM                  = $20000000;

(*
 * Indicates that this surface is a standard VGA mode surface, and not a
 * ModeX surface. (This flag will never be set in combination with the
 * DDSCAPS_MODEX flag).
 *)
  DDSCAPS_STANDARDVGAMODE                 = $40000000;

(*
 * Indicates that this surface will be an optimized surface. This flag is
 * currently only valid in conjunction with the DDSCAPS_TEXTURE flag. The surface
 * will be created without any underlying video memory until loaded.
 *)
  DDSCAPS_OPTIMIZED                       = $80000000;


 (****************************************************************************
 *
 * DIRECTDRAW DRIVER CAPABILITY FLAGS
 *
 ****************************************************************************)

(*
 * Display hardware has 3D acceleration.
 *)
  DDCAPS_3D                       = $00000001;

(*
 * Indicates that DirectDraw will support only dest rectangles that are aligned
 * on DIRECTDRAWCAPS.dwAlignBoundaryDest boundaries of the surface, respectively.
 * READ ONLY.
 *)
  DDCAPS_ALIGNBOUNDARYDEST        = $00000002;

(*
 * Indicates that DirectDraw will support only source rectangles  whose sizes in
 * BYTEs are DIRECTDRAWCAPS.dwAlignSizeDest multiples, respectively.  READ ONLY.
 *)
  DDCAPS_ALIGNSIZEDEST            = $00000004;
(*
 * Indicates that DirectDraw will support only source rectangles that are aligned
 * on DIRECTDRAWCAPS.dwAlignBoundarySrc boundaries of the surface, respectively.
 * READ ONLY.
 *)
  DDCAPS_ALIGNBOUNDARYSRC         = $00000008;

(*
 * Indicates that DirectDraw will support only source rectangles  whose sizes in
 * BYTEs are DIRECTDRAWCAPS.dwAlignSizeSrc multiples, respectively.  READ ONLY.
 *)
  DDCAPS_ALIGNSIZESRC             = $00000010;

(*
 * Indicates that DirectDraw will create video memory surfaces that have a stride
 * alignment equal to DIRECTDRAWCAPS.dwAlignStride.  READ ONLY.
 *)
  DDCAPS_ALIGNSTRIDE              = $00000020;

(*
 * Display hardware is capable of blt operations.
 *)
  DDCAPS_BLT                      = $00000040;

(*
 * Display hardware is capable of asynchronous blt operations.
 *)
  DDCAPS_BLTQUEUE                 = $00000080;

(*
 * Display hardware is capable of color space conversions during the blt operation.
 *)
  DDCAPS_BLTFOURCC                = $00000100;

(*
 * Display hardware is capable of stretching during blt operations.
 *)
  DDCAPS_BLTSTRETCH               = $00000200;

(*
 * Display hardware is shared with GDI.
 *)
  DDCAPS_GDI                      = $00000400;

(*
 * Display hardware can overlay.
 *)
  DDCAPS_OVERLAY                  = $00000800;

(*
 * Set if display hardware supports overlays but can not clip them.
 *)
  DDCAPS_OVERLAYCANTCLIP          = $00001000;

(*
 * Indicates that overlay hardware is capable of color space conversions during
 * the overlay operation.
 *)
  DDCAPS_OVERLAYFOURCC            = $00002000;

(*
 * Indicates that stretching can be done by the overlay hardware.
 *)
  DDCAPS_OVERLAYSTRETCH           = $00004000;

(*
 * Indicates that unique DirectDrawPalettes can be created for DirectDrawSurfaces
 * other than the primary surface.
 *)
  DDCAPS_PALETTE                  = $00008000;

(*
 * Indicates that palette changes can be syncd with the veritcal refresh.
 *)
  DDCAPS_PALETTEVSYNC             = $00010000;

(*
 * Display hardware can return the current scan line.
 *)
  DDCAPS_READSCANLINE             = $00020000;

(*
 * Display hardware has stereo vision capabilities.  DDSCAPS_PRIMARYSURFACELEFT
 * can be created.
 *)
  DDCAPS_STEREOVIEW               = $00040000;

(*
 * Display hardware is capable of generating a vertical blank interrupt.
 *)
  DDCAPS_VBI                      = $00080000;

(*
 * Supports the use of z buffers with blt operations.
 *)
  DDCAPS_ZBLTS                    = $00100000;

(*
 * Supports Z Ordering of overlays.
 *)
  DDCAPS_ZOVERLAYS                = $00200000;

(*
 * Supports color key
 *)
  DDCAPS_COLORKEY                 = $00400000;

(*
 * Supports alpha surfaces
 *)
  DDCAPS_ALPHA                    = $00800000;

(*
 * colorkey is hardware assisted(DDCAPS_COLORKEY will also be set)
 *)
  DDCAPS_COLORKEYHWASSIST         = $01000000;

(*
 * no hardware support at all
 *)
  DDCAPS_NOHARDWARE               = $02000000;

(*
 * Display hardware is capable of color fill with bltter
 *)
  DDCAPS_BLTCOLORFILL             = $04000000;

(*
 * Display hardware is bank switched, and potentially very slow at
 * random access to VRAM.
 *)
  DDCAPS_BANKSWITCHED             = $08000000;

(*
 * Display hardware is capable of depth filling Z-buffers with bltter
 *)
  DDCAPS_BLTDEPTHFILL             = $10000000;

(*
 * Display hardware is capable of clipping while bltting.
 *)
  DDCAPS_CANCLIP                  = $20000000;

(*
 * Display hardware is capable of clipping while stretch bltting.
 *)
  DDCAPS_CANCLIPSTRETCHED         = $40000000;

(*
 * Display hardware is capable of bltting to or from system memory
 *)
  DDCAPS_CANBLTSYSMEM             = $80000000;


 (****************************************************************************
 *
 * MORE DIRECTDRAW DRIVER CAPABILITY FLAGS (dwCaps2)
 *
 ****************************************************************************)

(*
 * Display hardware is certified
 *)
  DDCAPS2_CERTIFIED               = $00000001;

(*
 * Driver cannot interleave 2D operations (lock and blt) to surfaces with
 * Direct3D rendering operations between calls to BeginScene() and EndScene()
 *)
  DDCAPS2_NO2DDURING3DSCENE       = $00000002;

(*
 * Display hardware contains a video port
 *)
  DDCAPS2_VIDEOPORT               = $00000004;

(*
 * The overlay can be automatically flipped according to the video port
 * VSYNCs, providing automatic doubled buffered display of video port
 * data using an overlay
 *)
  DDCAPS2_AUTOFLIPOVERLAY         = $00000008;

(*
 * Overlay can display each field of interlaced data individually while
 * it is interleaved in memory without causing jittery artifacts.
 *)
  DDCAPS2_CANBOBINTERLEAVED     = $00000010;

(*
 * Overlay can display each field of interlaced data individually while
 * it is not interleaved in memory without causing jittery artifacts.
 *)
  DDCAPS2_CANBOBNONINTERLEAVED  = $00000020;

(*
 * The overlay surface contains color controls (brightness, sharpness, etc.)
 *)
  DDCAPS2_COLORCONTROLOVERLAY   = $00000040;

(*
 * The primary surface contains color controls (gamma, etc.)
 *)
  DDCAPS2_COLORCONTROLPRIMARY   = $00000080;

(*
 * RGBZ -> RGB supported for 16:16 RGB:Z
 *)
  DDCAPS2_CANDROPZ16BIT         = $00000100;

(*
 * Driver supports non-local video memory.
 *)
  DDCAPS2_NONLOCALVIDMEM          = $00000200;

(*
 * Dirver supports non-local video memory but has different capabilities for
 * non-local video memory surfaces. If this bit is set then so must
 * DDCAPS2_NONLOCALVIDMEM.
 *)
  DDCAPS2_NONLOCALVIDMEMCAPS      = $00000400;

(*
 * Driver neither requires nor prefers surfaces to be pagelocked when performing
 * blts involving system memory surfaces
 *)
  DDCAPS2_NOPAGELOCKREQUIRED      = $00000800;

(*
 * Driver can create surfaces which are wider than the primary surface
 *)
  DDCAPS2_WIDESURFACES            = $00001000;

(*
 * Driver supports bob using software without using a video port
 *)
  DDCAPS2_CANFLIPODDEVEN          = $00002000;

(****************************************************************************
 *
 * DIRECTDRAW FX ALPHA CAPABILITY FLAGS
 *
 ****************************************************************************)

(*
 * Supports alpha blending around the edge of a source color keyed surface.
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHAEDGEBLEND         = $00000001;

(*
 * Supports alpha information in the pixel format.  The bit depth of alpha
 * information in the pixel format can be 1,2,4, or 8.  The alpha value becomes
 * more opaque as the alpha value increases.  (0 is transparent.)
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHAPIXELS            = $00000002;

(*
 * Supports alpha information in the pixel format.  The bit depth of alpha
 * information in the pixel format can be 1,2,4, or 8.  The alpha value
 * becomes more transparent as the alpha value increases.  (0 is opaque.)
 * This flag can only be set if DDCAPS_ALPHA is set.
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHAPIXELSNEG         = $00000004;

(*
 * Supports alpha only surfaces.  The bit depth of an alpha only surface can be
 * 1,2,4, or 8.  The alpha value becomes more opaque as the alpha value increases.
 * (0 is transparent.)
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHASURFACES          = $00000008;

(*
 * The depth of the alpha channel data can range can be 1,2,4, or 8.
 * The NEG suffix indicates that this alpha channel becomes more transparent
 * as the alpha value increases. (0 is opaque.)  This flag can only be set if
 * DDCAPS_ALPHA is set.
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHASURFACESNEG       = $00000010;

(*
 * Supports alpha blending around the edge of a source color keyed surface.
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHAEDGEBLEND     = $00000020;

(*
 * Supports alpha information in the pixel format.  The bit depth of alpha
 * information in the pixel format can be 1,2,4, or 8.  The alpha value becomes
 * more opaque as the alpha value increases.  (0 is transparent.)
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHAPIXELS        = $00000040;

(*
 * Supports alpha information in the pixel format.  The bit depth of alpha
 * information in the pixel format can be 1,2,4, or 8.  The alpha value
 * becomes more transparent as the alpha value increases.  (0 is opaque.)
 * This flag can only be set if DDCAPS_ALPHA is set.
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHAPIXELSNEG     = $00000080;

(*
 * Supports alpha only surfaces.  The bit depth of an alpha only surface can be
 * 1,2,4, or 8.  The alpha value becomes more opaque as the alpha value increases.
 * (0 is transparent.)
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHASURFACES      = $00000100;

(*
 * The depth of the alpha channel data can range can be 1,2,4, or 8.
 * The NEG suffix indicates that this alpha channel becomes more transparent
 * as the alpha value increases. (0 is opaque.)  This flag can only be set if
 * DDCAPS_ALPHA is set.
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHASURFACESNEG   = $00000200;

(****************************************************************************
 *
 * DIRECTDRAW FX CAPABILITY FLAGS
 *
 ****************************************************************************)

(*
 * Uses arithmetic operations to stretch and shrink surfaces during blt
 * rather than pixel doubling techniques.  Along the Y axis.
 *)
  DDFXCAPS_BLTARITHSTRETCHY       = $00000020;

(*
 * Uses arithmetic operations to stretch during blt
 * rather than pixel doubling techniques.  Along the Y axis. Only
 * works for x1, x2, etc.
 *)
  DDFXCAPS_BLTARITHSTRETCHYN      = $00000010;

(*
 * Supports mirroring left to right in blt.
 *)
  DDFXCAPS_BLTMIRRORLEFTRIGHT     = $00000040;

(*
 * Supports mirroring top to bottom in blt.
 *)
  DDFXCAPS_BLTMIRRORUPDOWN        = $00000080;

(*
 * Supports arbitrary rotation for blts.
 *)
  DDFXCAPS_BLTROTATION            = $00000100;

(*
 * Supports 90 degree rotations for blts.
 *)
   DDFXCAPS_BLTROTATION90          = $00000200;

(*
 * DirectDraw supports arbitrary shrinking of a surface along the
 * x axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSHRINKX             = $00000400;

(*
 * DirectDraw supports Longint shrinking (1x,2x,) of a surface
 * along the x axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSHRINKXN            = $00000800;

(*
 * DirectDraw supports arbitrary shrinking of a surface along the
 * y axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSHRINKY             = $00001000;

(*
 * DirectDraw supports Longint shrinking (1x,2x,) of a surface
 * along the y axis (vertical direction) for blts.
 *)
  DDFXCAPS_BLTSHRINKYN            = $00002000;

(*
 * DirectDraw supports arbitrary stretching of a surface along the
 * x axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSTRETCHX            = $00004000;

(*
 * DirectDraw supports Longint stretching (1x,2x,) of a surface
 * along the x axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSTRETCHXN           = $00008000;

(*
 * DirectDraw supports arbitrary stretching of a surface along the
 * y axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSTRETCHY            = $00010000;

(*
 * DirectDraw supports Longint stretching (1x,2x,) of a surface
 * along the y axis (vertical direction) for blts.
 *)
  DDFXCAPS_BLTSTRETCHYN           = $00020000;

(*
 * Uses arithmetic operations to stretch and shrink surfaces during
 * overlay rather than pixel doubling techniques.  Along the Y axis
 * for overlays.
 *)
  DDFXCAPS_OVERLAYARITHSTRETCHY   = $00040000;

(*
 * Uses arithmetic operations to stretch surfaces during
 * overlay rather than pixel doubling techniques.  Along the Y axis
 * for overlays. Only works for x1, x2, etc.
 *)
  DDFXCAPS_OVERLAYARITHSTRETCHYN  = $00000008;

(*
 * DirectDraw supports arbitrary shrinking of a surface along the
 * x axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSHRINKX         = $00080000;

(*
 * DirectDraw supports Longint shrinking (1x,2x,) of a surface
 * along the x axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSHRINKXN        = $00100000;

(*
 * DirectDraw supports arbitrary shrinking of a surface along the
 * y axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSHRINKY         = $00200000;

(*
 * DirectDraw supports Longint shrinking (1x,2x,) of a surface
 * along the y axis (vertical direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSHRINKYN        = $00400000;

(*
 * DirectDraw supports arbitrary stretching of a surface along the
 * x axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSTRETCHX        = $00800000;

(*
 * DirectDraw supports Longint stretching (1x,2x,) of a surface
 * along the x axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSTRETCHXN       = $01000000;

(*
 * DirectDraw supports arbitrary stretching of a surface along the
 * y axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSTRETCHY        = $02000000;

(*
 * DirectDraw supports Longint stretching (1x,2x,) of a surface
 * along the y axis (vertical direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSTRETCHYN       = $04000000;

(*
 * DirectDraw supports mirroring of overlays across the vertical axis
 *)
  DDFXCAPS_OVERLAYMIRRORLEFTRIGHT = $08000000;

(*
 * DirectDraw supports mirroring of overlays across the horizontal axis
 *)
  DDFXCAPS_OVERLAYMIRRORUPDOWN    = $10000000;

(****************************************************************************
 *
 * DIRECTDRAW STEREO VIEW CAPABILITIES
 *
 ****************************************************************************)

(*
 * The stereo view is accomplished via enigma encoding.
 *)
  DDSVCAPS_ENIGMA                 = $00000001;

(*
 * The stereo view is accomplished via high frequency flickering.
 *)
  DDSVCAPS_FLICKER                = $00000002;

(*
 * The stereo view is accomplished via red and blue filters applied
 * to the left and right eyes.  All images must adapt their colorspaces
 * for this process.
 *)
  DDSVCAPS_REDBLUE                = $00000004;

(*
 * The stereo view is accomplished with split screen technology.
 *)
  DDSVCAPS_SPLIT                  = $00000008;

(****************************************************************************
 *
 * DIRECTDRAWPALETTE CAPABILITIES
 *
 ****************************************************************************)

(*
 * Index is 4 bits.  There are sixteen color entries in the palette table.
 *)
  DDPCAPS_4BIT                    = $00000001;

(*
 * Index is onto a 8 bit color index.  This field is only valid with the
 * DDPCAPS_1BIT, DDPCAPS_2BIT or DDPCAPS_4BIT capability and the target
 * surface is in 8bpp. Each color entry is one byte long and is an index
 * into destination surface's 8bpp palette.
 *)
  DDPCAPS_8BITENTRIES             = $00000002;

(*
 * Index is 8 bits.  There are 256 color entries in the palette table.
 *)
  DDPCAPS_8BIT                    = $00000004;

(*
 * Indicates that this DIRECTDRAWPALETTE should use the palette color array
 * passed into the lpDDColorArray parameter to initialize the DIRECTDRAWPALETTE
 * object.
 *)
  DDPCAPS_INITIALIZE              = $00000008;

(*
 * This palette is the one attached to the primary surface.  Changing this
 * table has immediate effect on the display unless DDPSETPAL_VSYNC is specified
 * and supported.
 *)
  DDPCAPS_PRIMARYSURFACE          = $00000010;

(*
 * This palette is the one attached to the primary surface left.  Changing
 * this table has immediate effect on the display for the left eye unless
 * DDPSETPAL_VSYNC is specified and supported.
 *)
  DDPCAPS_PRIMARYSURFACELEFT      = $00000020;

(*
 * This palette can have all 256 entries defined
 *)
  DDPCAPS_ALLOW256                = $00000040;

(*
 * This palette can have modifications to it synced with the monitors
 * refresh rate.
 *)
  DDPCAPS_VSYNC                   = $00000080;

(*
 * Index is 1 bit.  There are two color entries in the palette table.
 *)
  DDPCAPS_1BIT                    = $00000100;

(*
 * Index is 2 bit.  There are four color entries in the palette table.
 *)
  DDPCAPS_2BIT                    = $00000200;


(****************************************************************************
 *
 * DIRECTDRAWPALETTE SETENTRY CONSTANTS
 *
 ****************************************************************************)


(****************************************************************************
 *
 * DIRECTDRAWPALETTE GETENTRY CONSTANTS
 *
 ****************************************************************************)

(* 0 is the only legal value *)

(****************************************************************************
 *
 * DIRECTDRAWSURFACE SETPALETTE CONSTANTS
 *
 ****************************************************************************)


(****************************************************************************
 *
 * DIRECTDRAW BITDEPTH CONSTANTS
 *
 * NOTE:  These are only used to indicate supported bit depths.   These
 * are flags only, they are not to be used as an actual bit depth.   The
 * absolute numbers 1, 2, 4, 8, 16, 24 and 32 are used to indicate actual
 * bit depths in a surface or for changing the display mode.
 *
 ****************************************************************************)

(*
 * 1 bit per pixel.
 *)
  DDBD_1                  = $00004000;

(*
 * 2 bits per pixel.
 *)
  DDBD_2                  = $00002000;

(*
 * 4 bits per pixel.
 *)
  DDBD_4                  = $00001000;

(*
 * 8 bits per pixel.
 *)
  DDBD_8                  = $00000800;

(*
 * 16 bits per pixel.
 *)
  DDBD_16                 = $00000400;

(*
 * 24 bits per pixel.
 *)
  DDBD_24                 = $00000200;

(*
 * 32 bits per pixel.
 *)
  DDBD_32                 = $00000100;

(****************************************************************************
 *
 * DIRECTDRAWSURFACE SET/GET COLOR KEY FLAGS
 *
 ****************************************************************************)

(*
 * Set if the structure contains a color space.  Not set if the structure
 * contains a single color key.
 *)
  DDCKEY_COLORSPACE       = $00000001;

(*
 * Set if the structure specifies a color key or color space which is to be
 * used as a destination color key for blt operations.
 *)
  DDCKEY_DESTBLT          = $00000002;

(*
 * Set if the structure specifies a color key or color space which is to be
 * used as a destination color key for overlay operations.
 *)
  DDCKEY_DESTOVERLAY      = $00000004;

(*
 * Set if the structure specifies a color key or color space which is to be
 * used as a source color key for blt operations.
 *)
  DDCKEY_SRCBLT           = $00000008;

(*
 * Set if the structure specifies a color key or color space which is to be
 * used as a source color key for overlay operations.
 *)
  DDCKEY_SRCOVERLAY       = $00000010;


(****************************************************************************
 *
 * DIRECTDRAW COLOR KEY CAPABILITY FLAGS
 *
 ****************************************************************************)

(*
 * Supports transparent blting using a color key to identify the replaceable
 * bits of the destination surface for RGB colors.
 *)
  DDCKEYCAPS_DESTBLT                      = $00000001;

(*
 * Supports transparent blting using a color space to identify the replaceable
 * bits of the destination surface for RGB colors.
 *)
  DDCKEYCAPS_DESTBLTCLRSPACE              = $00000002;

(*
 * Supports transparent blting using a color space to identify the replaceable
 * bits of the destination surface for YUV colors.
 *)
  DDCKEYCAPS_DESTBLTCLRSPACEYUV           = $00000004;

(*
 * Supports transparent blting using a color key to identify the replaceable
 * bits of the destination surface for YUV colors.
 *)
  DDCKEYCAPS_DESTBLTYUV                   = $00000008;

(*
 * Supports overlaying using colorkeying of the replaceable bits of the surface
 * being overlayed for RGB colors.
 *)
  DDCKEYCAPS_DESTOVERLAY                  = $00000010;

(*
 * Supports a color space as the color key for the destination for RGB colors.
 *)
  DDCKEYCAPS_DESTOVERLAYCLRSPACE          = $00000020;

(*
 * Supports a color space as the color key for the destination for YUV colors.
 *)
  DDCKEYCAPS_DESTOVERLAYCLRSPACEYUV       = $00000040;

(*
 * Supports only one active destination color key value for visible overlay
 * surfaces.
 *)
  DDCKEYCAPS_DESTOVERLAYONEACTIVE         = $00000080;

(*
 * Supports overlaying using colorkeying of the replaceable bits of the
 * surface being overlayed for YUV colors.
 *)
  DDCKEYCAPS_DESTOVERLAYYUV               = $00000100;

(*
 * Supports transparent blting using the color key for the source with
 * this surface for RGB colors.
 *)
  DDCKEYCAPS_SRCBLT                       = $00000200;

(*
 * Supports transparent blting using a color space for the source with
 * this surface for RGB colors.
 *)
  DDCKEYCAPS_SRCBLTCLRSPACE               = $00000400;

(*
 * Supports transparent blting using a color space for the source with
 * this surface for YUV colors.
 *)
  DDCKEYCAPS_SRCBLTCLRSPACEYUV            = $00000800;

(*
 * Supports transparent blting using the color key for the source with
 * this surface for YUV colors.
 *)
  DDCKEYCAPS_SRCBLTYUV                    = $00001000;

(*
 * Supports overlays using the color key for the source with this
 * overlay surface for RGB colors.
 *)
  DDCKEYCAPS_SRCOVERLAY                   = $00002000;

(*
 * Supports overlays using a color space as the source color key for
 * the overlay surface for RGB colors.
 *)
  DDCKEYCAPS_SRCOVERLAYCLRSPACE           = $00004000;

(*
 * Supports overlays using a color space as the source color key for
 * the overlay surface for YUV colors.
 *)
  DDCKEYCAPS_SRCOVERLAYCLRSPACEYUV        = $00008000;

(*
 * Supports only one active source color key value for visible
 * overlay surfaces.
 *)
  DDCKEYCAPS_SRCOVERLAYONEACTIVE          = $00010000;

(*
 * Supports overlays using the color key for the source with this
 * overlay surface for YUV colors.
 *)
  DDCKEYCAPS_SRCOVERLAYYUV                = $00020000;

(*
 * there are no bandwidth trade-offs for using colorkey with an overlay
 *)
  DDCKEYCAPS_NOCOSTOVERLAY                = $00040000;


(****************************************************************************
 *
 * DIRECTDRAW PIXELFORMAT FLAGS
 *
 ****************************************************************************)

(*
 * The surface has alpha channel information in the pixel format.
 *)
  DDPF_ALPHAPIXELS                        = $00000001;

(*
 * The pixel format contains alpha only information
 *)
  DDPF_ALPHA                              = $00000002;

(*
 * The FourCC code is valid.
 *)
  DDPF_FOURCC                             = $00000004;

(*
 * The surface is 4-bit color indexed.
 *)
  DDPF_PALETTEINDEXED4                    = $00000008;

(*
 * The surface is indexed into a palette which stores indices
 * into the destination surface's 8-bit palette.
 *)
  DDPF_PALETTEINDEXEDTO8                  = $00000010;

(*
 * The surface is 8-bit color indexed.
 *)
  DDPF_PALETTEINDEXED8                    = $00000020;

(*
 * The RGB data in the pixel format structure is valid.
 *)
  DDPF_RGB                                = $00000040;

(*
 * The surface will accept pixel data in the format specified
 * and compress it during the write.
 *)
  DDPF_COMPRESSED                         = $00000080;

(*
 * The surface will accept RGB data and translate it during
 * the write to YUV data.  The format of the data to be written
 * will be contained in the pixel format structure.  The DDPF_RGB
 * flag will be set.
 *)
  DDPF_RGBTOYUV                           = $00000100;

(*
 * pixel format is YUV - YUV data in pixel format struct is valid
 *)
  DDPF_YUV                                = $00000200;

(*
 * pixel format is a z buffer only surface
 *)
  DDPF_ZBUFFER                            = $00000400;

(*
 * The surface is 1-bit color indexed.
 *)
  DDPF_PALETTEINDEXED1                    = $00000800;

(*
 * The surface is 2-bit color indexed.
 *)
  DDPF_PALETTEINDEXED2                    = $00001000;

(*
 * The surface contains Z information in the pixels
 *)
  DDPF_ZPIXELS                          = $00002000;


(*===========================================================================
 *
 *
 * DIRECTDRAW CALLBACK FLAGS
 *
 *
 *==========================================================================*)

(****************************************************************************
 *
 * DIRECTDRAW ENUMSURFACES FLAGS
 *
 ****************************************************************************)

(*
 * Enumerate all of the surfaces that meet the search criterion.
 *)
  DDENUMSURFACES_ALL                      = $00000001;

(*
 * A search hit is a surface that matches the surface description.
 *)
  DDENUMSURFACES_MATCH                    = $00000002;

(*
 * A search hit is a surface that does not match the surface description.
 *)
  DDENUMSURFACES_NOMATCH                  = $00000004;

(*
 * Enumerate the first surface that can be created which meets the search criterion.
 *)
  DDENUMSURFACES_CANBECREATED             = $00000008;

(*
 * Enumerate the surfaces that already exist that meet the search criterion.
 *)
  DDENUMSURFACES_DOESEXIST                = $00000010;


(****************************************************************************
 *
 * DIRECTDRAW ENUMDISPLAYMODES FLAGS
 *
 ****************************************************************************)

(*
 * Enumerate Modes with different refresh rates.  EnumDisplayModes guarantees
 * that a particular mode will be enumerated only once.  This flag specifies whether
 * the refresh rate is taken into account when determining if a mode is unique.
 *)
  DDEDM_REFRESHRATES                      = $00000001;

(*
 * Enumerate VGA modes. Specify this flag if you wish to enumerate supported VGA
 * modes such as mode 0x13 in addition to the usual ModeX modes (which are always
 * enumerated if the application has previously called SetCooperativeLevel with the
 * DDSCL_ALLOWMODEX flag set).
 *)
  DDEDM_STANDARDVGAMODES                  = $00000002;


(****************************************************************************
 *
 * DIRECTDRAW SETCOOPERATIVELEVEL FLAGS
 *
 ****************************************************************************)

(*
 * Exclusive mode owner will be responsible for the entire primary surface.
 * GDI can be ignored. used with DD
 *)
  DDSCL_FULLSCREEN                        = $00000001;

(*
 * allow CTRL_ALT_DEL to work while in fullscreen exclusive mode
 *)
  DDSCL_ALLOWREBOOT                       = $00000002;

(*
 * prevents DDRAW from modifying the application window.
 * prevents DDRAW from minimize/restore the application window on activation.
 *)
  DDSCL_NOWINDOWCHANGES                   = $00000004;

(*
 * app wants to work as a regular Windows application
 *)
  DDSCL_NORMAL                            = $00000008;

(*
 * app wants exclusive access
 *)
  DDSCL_EXCLUSIVE                         = $00000010;


(*
 * app can deal with non-windows display modes
 *)
  DDSCL_ALLOWMODEX                        = $00000040;


(****************************************************************************
 *
 * DIRECTDRAW BLT FLAGS
 *
 ****************************************************************************)

(*
 * Use the alpha information in the pixel format or the alpha channel surface
 * attached to the destination surface as the alpha channel for this blt.
 *)
  DDBLT_ALPHADEST                         = $00000001;

(*
 * Use the dwConstAlphaDest field in the TDDBltFX structure as the alpha channel
 * for the destination surface for this blt.
 *)
  DDBLT_ALPHADESTCONSTOVERRIDE            = $00000002;

(*
 * The NEG suffix indicates that the destination surface becomes more
 * transparent as the alpha value increases. (0 is opaque)
 *)
  DDBLT_ALPHADESTNEG                      = $00000004;

(*
 * Use the lpDDSAlphaDest field in the TDDBltFX structure as the alpha
 * channel for the destination for this blt.
 *)
  DDBLT_ALPHADESTSURFACEOVERRIDE          = $00000008;

(*
 * Use the dwAlphaEdgeBlend field in the TDDBltFX structure as the alpha channel
 * for the edges of the image that border the color key colors.
 *)
  DDBLT_ALPHAEDGEBLEND                    = $00000010;

(*
 * Use the alpha information in the pixel format or the alpha channel surface
 * attached to the source surface as the alpha channel for this blt.
 *)
  DDBLT_ALPHASRC                          = $00000020;

(*
 * Use the dwConstAlphaSrc field in the TDDBltFX structure as the alpha channel
 * for the source for this blt.
 *)
  DDBLT_ALPHASRCCONSTOVERRIDE             = $00000040;

(*
 * The NEG suffix indicates that the source surface becomes more transparent
 * as the alpha value increases. (0 is opaque)
 *)
  DDBLT_ALPHASRCNEG                       = $00000080;

(*
 * Use the lpDDSAlphaSrc field in the TDDBltFX structure as the alpha channel
 * for the source for this blt.
 *)
  DDBLT_ALPHASRCSURFACEOVERRIDE           = $00000100;

(*
 * Do this blt asynchronously through the FIFO in the order received.  If
 * there is no room in the hardware FIFO fail the call.
 *)
  DDBLT_ASYNC                             = $00000200;

(*
 * Uses the dwFillColor field in the TDDBltFX structure as the RGB color
 * to fill the destination rectangle on the destination surface with.
 *)
  DDBLT_COLORFILL                         = $00000400;

(*
 * Uses the dwDDFX field in the TDDBltFX structure to specify the effects
 * to use for the blt.
 *)
  DDBLT_DDFX                              = $00000800;

(*
 * Uses the dwDDROPS field in the TDDBltFX structure to specify the ROPS
 * that are not part of the Win32 API.
 *)
  DDBLT_DDROPS                            = $00001000;

(*
 * Use the color key associated with the destination surface.
 *)
  DDBLT_KEYDEST                           = $00002000;

(*
 * Use the dckDestColorkey field in the TDDBltFX structure as the color key
 * for the destination surface.
 *)
  DDBLT_KEYDESTOVERRIDE                   = $00004000;

(*
 * Use the color key associated with the source surface.
 *)
  DDBLT_KEYSRC                            = $00008000;

(*
 * Use the dckSrcColorkey field in the TDDBltFX structure as the color key
 * for the source surface.
 *)
  DDBLT_KEYSRCOVERRIDE                    = $00010000;

(*
 * Use the dwROP field in the TDDBltFX structure for the raster operation
 * for this blt.  These ROPs are the same as the ones defined in the Win32 API.
 *)
  DDBLT_ROP                               = $00020000;

(*
 * Use the dwRotationAngle field in the TDDBltFX structure as the angle
 * (specified in 1/100th of a degree) to rotate the surface.
 *)
  DDBLT_ROTATIONANGLE                     = $00040000;

(*
 * Z-buffered blt using the z-buffers attached to the source and destination
 * surfaces and the dwZBufferOpCode field in the TDDBltFX structure as the
 * z-buffer opcode.
 *)
  DDBLT_ZBUFFER                           = $00080000;

(*
 * Z-buffered blt using the dwConstDest Zfield and the dwZBufferOpCode field
 * in the TDDBltFX structure as the z-buffer and z-buffer opcode respectively
 * for the destination.
 *)
  DDBLT_ZBUFFERDESTCONSTOVERRIDE          = $00100000;

(*
 * Z-buffered blt using the lpDDSDestZBuffer field and the dwZBufferOpCode
 * field in the TDDBltFX structure as the z-buffer and z-buffer opcode
 * respectively for the destination.
 *)
  DDBLT_ZBUFFERDESTOVERRIDE               = $00200000;

(*
 * Z-buffered blt using the dwConstSrcZ field and the dwZBufferOpCode field
 * in the TDDBltFX structure as the z-buffer and z-buffer opcode respectively
 * for the source.
 *)
  DDBLT_ZBUFFERSRCCONSTOVERRIDE           = $00400000;

(*
 * Z-buffered blt using the lpDDSSrcZBuffer field and the dwZBufferOpCode
 * field in the TDDBltFX structure as the z-buffer and z-buffer opcode
 * respectively for the source.
 *)
   DDBLT_ZBUFFERSRCOVERRIDE                = $00800000;

(*
 * wait until the device is ready to handle the blt
 * this will cause blt to not return DDERR_WASSTILLDRAWING
 *)
  DDBLT_WAIT                              = $01000000;

(*
 * Uses the dwFillDepth field in the TDDBltFX structure as the depth value
 * to fill the destination rectangle on the destination Z-buffer surface
 * with.
 *)
  DDBLT_DEPTHFILL                         = $02000000;


(****************************************************************************
 *
 * BLTFAST FLAGS
 *
 ****************************************************************************)


  DDBLTFAST_NOCOLORKEY                    = $00000000;
  DDBLTFAST_SRCCOLORKEY                   = $00000001;
  DDBLTFAST_DESTCOLORKEY                  = $00000002;
  DDBLTFAST_WAIT                          = $00000010;

(****************************************************************************
 *
 * FLIP FLAGS
 *
 ****************************************************************************)


  DDFLIP_WAIT                          = $00000001;

(*
 * Indicates that the target surface contains the even field of video data.
 * This flag is only valid with an overlay surface.
 *)
  DDFLIP_EVEN                          = $00000002;

(*
 * Indicates that the target surface contains the odd field of video data.
 * This flag is only valid with an overlay surface.
 *)
  DDFLIP_ODD                           = $00000004;

(****************************************************************************
 *
 * DIRECTDRAW SURFACE OVERLAY FLAGS
 *
 ****************************************************************************)

(*
 * Use the alpha information in the pixel format or the alpha channel surface
 * attached to the destination surface as the alpha channel for the
 * destination overlay.
 *)
  DDOVER_ALPHADEST                        = $00000001;

(*
 * Use the dwConstAlphaDest field in the TDDOverlayFX structure as the
 * destination alpha channel for this overlay.
 *)
  DDOVER_ALPHADESTCONSTOVERRIDE           = $00000002;

(*
 * The NEG suffix indicates that the destination surface becomes more
 * transparent as the alpha value increases.
 *)
  DDOVER_ALPHADESTNEG                     = $00000004;

(*
 * Use the lpDDSAlphaDest field in the TDDOverlayFX structure as the alpha
 * channel destination for this overlay.
 *)
  DDOVER_ALPHADESTSURFACEOVERRIDE         = $00000008;

(*
 * Use the dwAlphaEdgeBlend field in the TDDOverlayFX structure as the alpha
 * channel for the edges of the image that border the color key colors.
 *)
  DDOVER_ALPHAEDGEBLEND                   = $00000010;

(*
 * Use the alpha information in the pixel format or the alpha channel surface
 * attached to the source surface as the source alpha channel for this overlay.
 *)
  DDOVER_ALPHASRC                         = $00000020;

(*
 * Use the dwConstAlphaSrc field in the TDDOverlayFX structure as the source
 * alpha channel for this overlay.
 *)
  DDOVER_ALPHASRCCONSTOVERRIDE            = $00000040;

(*
 * The NEG suffix indicates that the source surface becomes more transparent
 * as the alpha value increases.
 *)
  DDOVER_ALPHASRCNEG                      = $00000080;

(*
 * Use the lpDDSAlphaSrc field in the TDDOverlayFX structure as the alpha channel
 * source for this overlay.
 *)
  DDOVER_ALPHASRCSURFACEOVERRIDE          = $00000100;

(*
 * Turn this overlay off.
 *)
  DDOVER_HIDE                             = $00000200;

(*
 * Use the color key associated with the destination surface.
 *)
  DDOVER_KEYDEST                          = $00000400;

(*
 * Use the dckDestColorkey field in the TDDOverlayFX structure as the color key
 * for the destination surface
 *)
  DDOVER_KEYDESTOVERRIDE                  = $00000800;

(*
 * Use the color key associated with the source surface.
 *)
  DDOVER_KEYSRC                           = $00001000;

(*
 * Use the dckSrcColorkey field in the TDDOverlayFX structure as the color key
 * for the source surface.
 *)
  DDOVER_KEYSRCOVERRIDE                   = $00002000;

(*
 * Turn this overlay on.
 *)
  DDOVER_SHOW                             = $00004000;

(*
 * Add a dirty rect to an emulated overlayed surface.
 *)
  DDOVER_ADDDIRTYRECT                     = $00008000;

(*
 * Redraw all dirty rects on an emulated overlayed surface.
 *)
  DDOVER_REFRESHDIRTYRECTS                = $00010000;

(*
 * Redraw the entire surface on an emulated overlayed surface.
 *)
  DDOVER_REFRESHALL                      = $00020000;

(*
 * Use the overlay FX flags to define special overlay FX
 *)
  DDOVER_DDFX                             = $00080000;

(*
 * Autoflip the overlay when ever the video port autoflips
 *)
  DDOVER_AUTOFLIP                         = $00100000;

(*
 * Display each field of video port data individually without
 * causing any jittery artifacts
 *)
  DDOVER_BOB                              = $00200000;

(*
 * Indicates that bob/weave decisions should not be overridden by other
 * interfaces.
 *)
  DDOVER_OVERRIDEBOBWEAVE                 = $00400000;

(*
 * Indicates that the surface memory is composed of interleaved fields.
 *)
  DDOVER_INTERLEAVED                      = $00800000;

(****************************************************************************
 *
 * DIRECTDRAWSURFACE LOCK FLAGS
 *
 ****************************************************************************)

(*
 * The default.  Set to indicate that Lock should return a valid memory pointer
 * to the top of the specified rectangle.  If no rectangle is specified then a
 * pointer to the top of the surface is returned.
 *)
  DDLOCK_SURFACEMEMORYPTR                 = $00000000;    // = default

(*
 * Set to indicate that Lock should wait until it can obtain a valid memory
 * pointer before returning.  If this bit is set, Lock will never return
 * DDERR_WASSTILLDRAWING.
 *)
  DDLOCK_WAIT                             = $00000001;

(*
 * Set if an event handle is being passed to Lock.  Lock will trigger the event
 * when it can return the surface memory pointer requested.
 *)
  DDLOCK_EVENT                            = $00000002;

(*
 * Indicates that the surface being locked will only be read from.
 *)
  DDLOCK_READONLY                         = $00000010;

(*
 * Indicates that the surface being locked will only be written to
 *)
  DDLOCK_WRITEONLY                        = $00000020;

(*
 * Indicates that a system wide lock should not be taken when this surface
 * is locked. This has several advantages (cursor responsiveness, ability
 * to call more Windows functions, easier debugging) when locking video
 * memory surfaces. However, an application specifying this flag must
 * comply with a number of conditions documented in the help file.
 * Furthermore, this flag cannot be specified when locking the primary.
 *)
  DDLOCK_NOSYSLOCK                        = $00000800;


(****************************************************************************
 *
 * DIRECTDRAWSURFACE PAGELOCK FLAGS
 *
 ****************************************************************************)

(*
 * No flags defined at present
 *)


(****************************************************************************
 *
 * DIRECTDRAWSURFACE PAGEUNLOCK FLAGS
 *
 ****************************************************************************)

(*
 * No flags defined at present
 *)


(****************************************************************************
 *
 * DIRECTDRAWSURFACE BLT FX FLAGS
 *
 ****************************************************************************)

(*
 * If stretching, use arithmetic stretching along the Y axis for this blt.
 *)
  DDBLTFX_ARITHSTRETCHY                   = $00000001;

(*
 * Do this blt mirroring the surface left to right.  Spin the
 * surface around its y-axis.
 *)
  DDBLTFX_MIRRORLEFTRIGHT                 = $00000002;

(*
 * Do this blt mirroring the surface up and down.  Spin the surface
 * around its x-axis.
 *)
  DDBLTFX_MIRRORUPDOWN                    = $00000004;

(*
 * Schedule this blt to avoid tearing.
 *)
  DDBLTFX_NOTEARING                       = $00000008;

(*
 * Do this blt rotating the surface one hundred and eighty degrees.
 *)
  DDBLTFX_ROTATE180                       = $00000010;

(*
 * Do this blt rotating the surface two hundred and seventy degrees.
 *)
  DDBLTFX_ROTATE270                       = $00000020;

(*
 * Do this blt rotating the surface ninety degrees.
 *)
  DDBLTFX_ROTATE90                        = $00000040;

(*
 * Do this z blt using dwZBufferLow and dwZBufferHigh as  range values
 * specified to limit the bits copied from the source surface.
 *)
  DDBLTFX_ZBUFFERRANGE                    = $00000080;

(*
 * Do this z blt adding the dwZBufferBaseDest to each of the sources z values
 * before comparing it with the desting z values.
 *)
  DDBLTFX_ZBUFFERBASEDEST                 = $00000100;

(****************************************************************************
 *
 * DIRECTDRAWSURFACE OVERLAY FX FLAGS
 *
 ****************************************************************************)

(*
 * If stretching, use arithmetic stretching along the Y axis for this overlay.
 *)
  DDOVERFX_ARITHSTRETCHY                  = $00000001;

(*
 * Mirror the overlay across the vertical axis
 *)
  DDOVERFX_MIRRORLEFTRIGHT                = $00000002;

(*
 * Mirror the overlay across the horizontal axis
 *)
  DDOVERFX_MIRRORUPDOWN                   = $00000004;

(****************************************************************************
 *
 * DIRECTDRAW WAITFORVERTICALBLANK FLAGS
 *
 ****************************************************************************)

(*
 * return when the vertical blank interval begins
 *)
  DDWAITVB_BLOCKBEGIN                     = $00000001;

(*
 * set up an event to trigger when the vertical blank begins
 *)
  DDWAITVB_BLOCKBEGINEVENT                = $00000002;

(*
 * return when the vertical blank interval ends and display begins
 *)
  DDWAITVB_BLOCKEND                       = $00000004;

(****************************************************************************
 *
 * DIRECTDRAW GETFLIPSTATUS FLAGS
 *
 ****************************************************************************)

(*
 * is it OK to flip now?
 *)
  DDGFS_CANFLIP                   = $00000001;

(*
 * is the last flip finished?
 *)
  DDGFS_ISFLIPDONE                = $00000002;

(****************************************************************************
 *
 * DIRECTDRAW GETBLTSTATUS FLAGS
 *
 ****************************************************************************)

(*
 * is it OK to blt now?
 *)
  DDGBS_CANBLT                    = $00000001;

(*
 * is the blt to the surface finished?
 *)
  DDGBS_ISBLTDONE                 = $00000002;


(****************************************************************************
 *
 * DIRECTDRAW ENUMOVERLAYZORDER FLAGS
 *
 ****************************************************************************)

(*
 * Enumerate overlays back to front.
 *)
  DDENUMOVERLAYZ_BACKTOFRONT      = $00000000;

(*
 * Enumerate overlays front to back
 *)
  DDENUMOVERLAYZ_FRONTTOBACK      = $00000001;

(****************************************************************************
 *
 * DIRECTDRAW UPDATEOVERLAYZORDER FLAGS
 *
 ****************************************************************************)

(*
 * Send overlay to front
 *)
  DDOVERZ_SENDTOFRONT             = $00000000;

(*
 * Send overlay to back
 *)
  DDOVERZ_SENDTOBACK              = $00000001;

(*
 * Move Overlay forward
 *)
  DDOVERZ_MOVEFORWARD             = $00000002;

(*
 * Move Overlay backward
 *)
  DDOVERZ_MOVEBACKWARD            = $00000003;

(*
 * Move Overlay in front of relative surface
 *)
  DDOVERZ_INSERTINFRONTOF         = $00000004;

(*
 * Move Overlay in back of relative surface
 *)
  DDOVERZ_INSERTINBACKOF          = $00000005;

(*===========================================================================
 *
 *
 * DIRECTDRAW RETURN CODES
 *
 * The return values from DirectDraw Commands and Surface that return an HResult
 * are codes from DirectDraw concerning the results of the action
 * requested by DirectDraw.
 *
 *==========================================================================*)

(*
 * Status is OK
 *
 * Issued by: DirectDraw Commands and all callbacks
 *)
  DD_OK                                   = 0;

(****************************************************************************
 *
 * DIRECTDRAW ENUMCALLBACK RETURN VALUES
 *
 * EnumCallback returns are used to control the flow of the DIRECTDRAW and
 * DIRECTDRAWSURFACE object enumerations.   They can only be returned by
 * enumeration callback routines.
 *
 ****************************************************************************)

(*
 * stop the enumeration
 *)
  DDENUMRET_CANCEL                        = 0;

(*
 * continue the enumeration
 *)
  DDENUMRET_OK                            = 1;

(****************************************************************************
 *
 * DIRECTDRAW ERRORS
 *
 * Errors are represented by negative values and cannot be combined.
 *
 ****************************************************************************)

  _FACDD = $876;
  MAKE_DDHRESULT = HResult(1 shl 31) or HResult(_FACDD shl 16);


(*
 * This object is already initialized
 *)
  DDERR_ALREADYINITIALIZED                = MAKE_DDHRESULT + 5;

(*
 * This surface can not be attached to the requested surface.
 *)
  DDERR_CANNOTATTACHSURFACE               = MAKE_DDHRESULT + 10;

(*
 * This surface can not be detached from the requested surface.
 *)
  DDERR_CANNOTDETACHSURFACE               = MAKE_DDHRESULT + 20;

(*
 * Support is currently not available.
 *)
  DDERR_CURRENTLYNOTAVAIL                 = MAKE_DDHRESULT + 40;

(*
 * An exception was encountered while performing the requested operation
 *)
  DDERR_EXCEPTION                         = MAKE_DDHRESULT + 55;

(*
 * Generic failure.
 *)
  DDERR_GENERIC                           = E_FAIL;

(*
 * Height of rectangle provided is not a multiple of reqd alignment
 *)
  DDERR_HEIGHTALIGN                       = MAKE_DDHRESULT + 90;

(*
 * Unable to match primary surface creation request with existing
 * primary surface.
 *)
  DDERR_INCOMPATIBLEPRIMARY               = MAKE_DDHRESULT + 95;

(*
 * One or more of the caps bits passed to the callback are incorrect.
 *)
  DDERR_INVALIDCAPS                       = MAKE_DDHRESULT + 100;

(*
 * DirectDraw does not support provided Cliplist.
 *)
  DDERR_INVALIDCLIPLIST                   = MAKE_DDHRESULT + 110;

(*
 * DirectDraw does not support the requested mode
 *)
  DDERR_INVALIDMODE                       = MAKE_DDHRESULT + 120;

(*
 * DirectDraw received a pointer that was an invalid DIRECTDRAW object.
 *)
  DDERR_INVALIDOBJECT                     = MAKE_DDHRESULT + 130;

(*
 * One or more of the parameters passed to the callback function are
 * incorrect.
 *)
  DDERR_INVALIDPARAMS                     = E_INVALIDARG;

(*
 * pixel format was invalid as specified
 *)
  DDERR_INVALIDPIXELFORMAT                = MAKE_DDHRESULT + 145;

(*
 * Rectangle provided was invalid.
 *)
  DDERR_INVALIDRECT                       = MAKE_DDHRESULT + 150;

(*
 * Operation could not be carried out because one or more surfaces are locked
 *)
  DDERR_LOCKEDSURFACES                    = MAKE_DDHRESULT + 160;

(*
 * There is no 3D present.
 *)
  DDERR_NO3D                              = MAKE_DDHRESULT + 170;

(*
 * Operation could not be carried out because there is no alpha accleration
 * hardware present or available.
 *)
  DDERR_NOALPHAHW                         = MAKE_DDHRESULT + 180;

(*
 * Operation could not be carried out because there is no stereo
 * hardware present or available.
 *)
  DDERR_NOSTEREOHARDWARE          = MAKE_DDHRESULT + 181;

(*
 * Operation could not be carried out because there is no hardware
 * present which supports stereo surfaces
 *)
  DDERR_NOSURFACELEFT             = MAKE_DDHRESULT + 182;

(*
 * no clip list available
 *)
  DDERR_NOCLIPLIST                        = MAKE_DDHRESULT + 205;

(*
 * Operation could not be carried out because there is no color conversion
 * hardware present or available.
 *)
  DDERR_NOCOLORCONVHW                     = MAKE_DDHRESULT + 210;

(*
 * Create function called without DirectDraw object method SetCooperativeLevel
 * being called.
 *)
  DDERR_NOCOOPERATIVELEVELSET             = MAKE_DDHRESULT + 212;

(*
 * Surface doesn't currently have a color key
 *)
  DDERR_NOCOLORKEY                        = MAKE_DDHRESULT + 215;

(*
 * Operation could not be carried out because there is no hardware support
 * of the dest color key.
 *)
  DDERR_NOCOLORKEYHW                      = MAKE_DDHRESULT + 220;

(*
 * No DirectDraw support possible with current display driver
 *)
  DDERR_NODIRECTDRAWSUPPORT               = MAKE_DDHRESULT + 222;

(*
 * Operation requires the application to have exclusive mode but the
 * application does not have exclusive mode.
 *)
  DDERR_NOEXCLUSIVEMODE                   = MAKE_DDHRESULT + 225;

(*
 * Flipping visible surfaces is not supported.
 *)
  DDERR_NOFLIPHW                          = MAKE_DDHRESULT + 230;

(*
 * There is no GDI present.
 *)
  DDERR_NOGDI                             = MAKE_DDHRESULT + 240;

(*
 * Operation could not be carried out because there is no hardware present
 * or available.
 *)
  DDERR_NOMIRRORHW                        = MAKE_DDHRESULT + 250;

(*
 * Requested item was not found
 *)
  DDERR_NOTFOUND                          = MAKE_DDHRESULT + 255;

(*
 * Operation could not be carried out because there is no overlay hardware
 * present or available.
 *)
  DDERR_NOOVERLAYHW                       = MAKE_DDHRESULT + 260;

(*
 * Operation could not be carried out because the source and destination
 * rectangles are on the same surface and overlap each other.
 *)
  DDERR_OVERLAPPINGRECTS                = MAKE_DDHRESULT + 270;

(*
 * Operation could not be carried out because there is no appropriate raster
 * op hardware present or available.
 *)
  DDERR_NORASTEROPHW                      = MAKE_DDHRESULT + 280;

(*
 * Operation could not be carried out because there is no rotation hardware
 * present or available.
 *)
  DDERR_NOROTATIONHW                      = MAKE_DDHRESULT + 290;

(*
 * Operation could not be carried out because there is no hardware support
 * for stretching
 *)
  DDERR_NOSTRETCHHW                       = MAKE_DDHRESULT + 310;

(*
 * DirectDrawSurface is not in 4 bit color palette and the requested operation
 * requires 4 bit color palette.
 *)
  DDERR_NOT4BITCOLOR                      = MAKE_DDHRESULT + 316;

(*
 * DirectDrawSurface is not in 4 bit color index palette and the requested
 * operation requires 4 bit color index palette.
 *)
  DDERR_NOT4BITCOLORINDEX                 = MAKE_DDHRESULT + 317;

(*
 * DirectDraw Surface is not in 8 bit color mode and the requested operation
 * requires 8 bit color.
 *)
  DDERR_NOT8BITCOLOR                      = MAKE_DDHRESULT + 320;

(*
 * Operation could not be carried out because there is no texture mapping
 * hardware present or available.
 *)
  DDERR_NOTEXTUREHW                       = MAKE_DDHRESULT + 330;

(*
 * Operation could not be carried out because there is no hardware support
 * for vertical blank synchronized operations.
 *)
  DDERR_NOVSYNCHW                         = MAKE_DDHRESULT + 335;

(*
 * Operation could not be carried out because there is no hardware support
 * for zbuffer blting.
 *)
  DDERR_NOZBUFFERHW                       = MAKE_DDHRESULT + 340;

(*
 * Overlay surfaces could not be z layered based on their BltOrder because
 * the hardware does not support z layering of overlays.
 *)
  DDERR_NOZOVERLAYHW                      = MAKE_DDHRESULT + 350;

(*
 * The hardware needed for the requested operation has already been
 * allocated.
 *)
  DDERR_OUTOFCAPS                         = MAKE_DDHRESULT + 360;

(*
 * DirectDraw does not have enough memory to perform the operation.
 *)
  DDERR_OUTOFMEMORY                       = E_OUTOFMEMORY;

(*
 * DirectDraw does not have enough memory to perform the operation.
 *)
  DDERR_OUTOFVIDEOMEMORY                  = MAKE_DDHRESULT + 380;

(*
 * hardware does not support clipped overlays
 *)
  DDERR_OVERLAYCANTCLIP                   = MAKE_DDHRESULT + 382;

(*
 * Can only have ony color key active at one time for overlays
 *)
  DDERR_OVERLAYCOLORKEYONLYONEACTIVE      = MAKE_DDHRESULT + 384;

(*
 * Access to this palette is being refused because the palette is already
 * locked by another thread.
 *)
  DDERR_PALETTEBUSY                       = MAKE_DDHRESULT + 387;

(*
 * No src color key specified for this operation.
 *)
  DDERR_COLORKEYNOTSET                    = MAKE_DDHRESULT + 400;

(*
 * This surface is already attached to the surface it is being attached to.
 *)
  DDERR_SURFACEALREADYATTACHED            = MAKE_DDHRESULT + 410;

(*
 * This surface is already a dependency of the surface it is being made a
 * dependency of.
 *)
  DDERR_SURFACEALREADYDEPENDENT           = MAKE_DDHRESULT + 420;

(*
 * Access to this surface is being refused because the surface is already
 * locked by another thread.
 *)
  DDERR_SURFACEBUSY                       = MAKE_DDHRESULT + 430;

(*
 * Access to this surface is being refused because no driver exists
 * which can supply a pointer to the surface.
 * This is most likely to happen when attempting to lock the primary
 * surface when no DCI provider is present.
 * Will also happen on attempts to lock an optimized surface.
 *)
  DDERR_CANTLOCKSURFACE                   = MAKE_DDHRESULT + 435;

(*
 * Access to Surface refused because Surface is obscured.
 *)
  DDERR_SURFACEISOBSCURED                 = MAKE_DDHRESULT + 440;

(*
 * Access to this surface is being refused because the surface is gone.
 * The DIRECTDRAWSURFACE object representing this surface should
 * have Restore called on it.
 *)
  DDERR_SURFACELOST                       = MAKE_DDHRESULT + 450;

(*
 * The requested surface is not attached.
 *)
  DDERR_SURFACENOTATTACHED                = MAKE_DDHRESULT + 460;

(*
 * Height requested by DirectDraw is too large.
 *)
  DDERR_TOOBIGHEIGHT                      = MAKE_DDHRESULT + 470;

(*
 * Size requested by DirectDraw is too large --  The individual height and
 * width are OK.
 *)
  DDERR_TOOBIGSIZE                        = MAKE_DDHRESULT + 480;

(*
 * Width requested by DirectDraw is too large.
 *)
  DDERR_TOOBIGWIDTH                       = MAKE_DDHRESULT + 490;

(*
 * Action not supported.
 *)
  DDERR_UNSUPPORTED                       = E_NOTIMPL;

(*
 * FOURCC format requested is unsupported by DirectDraw
 *)
  DDERR_UNSUPPORTEDFORMAT                 = MAKE_DDHRESULT + 510;

(*
 * Bitmask in the pixel format requested is unsupported by DirectDraw
 *)
  DDERR_UNSUPPORTEDMASK                   = MAKE_DDHRESULT + 520;

(*
 * The specified stream contains invalid data
 *)
  DDERR_INVALIDSTREAM                     = MAKE_DDHRESULT + 521;

(*
 * vertical blank is in progress
 *)
  DDERR_VERTICALBLANKINPROGRESS           = MAKE_DDHRESULT + 537;

(*
 * Informs DirectDraw that the previous Blt which is transfering information
 * to or from this Surface is incomplete.
 *)
  DDERR_WASSTILLDRAWING                   = MAKE_DDHRESULT + 540;

(*
 * The specified surface type requires specification of the COMPLEX flag
 *)
  DDERR_DDSCAPSCOMPLEXREQUIRED            = MAKE_DDHRESULT + 542;

(*
 * Rectangle provided was not horizontally aligned on reqd. boundary
 *)
  DDERR_XALIGN                            = MAKE_DDHRESULT + 560;

(*
 * The GUID passed to DirectDrawCreate is not a valid DirectDraw driver
 * identifier.
 *)
  DDERR_INVALIDDIRECTDRAWGUID             = MAKE_DDHRESULT + 561;

(*
 * A DirectDraw object representing this driver has already been created
 * for this process.
 *)
  DDERR_DIRECTDRAWALREADYCREATED          = MAKE_DDHRESULT + 562;

(*
 * A hardware only DirectDraw object creation was attempted but the driver
 * did not support any hardware.
 *)
  DDERR_NODIRECTDRAWHW                    = MAKE_DDHRESULT + 563;

(*
 * this process already has created a primary surface
 *)
  DDERR_PRIMARYSURFACEALREADYEXISTS       = MAKE_DDHRESULT + 564;

(*
 * software emulation not available.
 *)
  DDERR_NOEMULATION                       = MAKE_DDHRESULT + 565;

(*
 * region passed to Clipper::GetClipList is too small.
 *)
  DDERR_REGIONTOOSMALL                    = MAKE_DDHRESULT + 566;

(*
 * an attempt was made to set a clip list for a clipper objec that
 * is already monitoring an hwnd.
 *)
  DDERR_CLIPPERISUSINGHWND                = MAKE_DDHRESULT + 567;

(*
 * No clipper object attached to surface object
 *)
  DDERR_NOCLIPPERATTACHED                 = MAKE_DDHRESULT + 568;

(*
 * Clipper notification requires an HWND or
 * no HWND has previously been set as the CooperativeLevel HWND.
 *)
  DDERR_NOHWND                            = MAKE_DDHRESULT + 569;

(*
 * HWND used by DirectDraw CooperativeLevel has been subclassed,
 * this prevents DirectDraw from restoring state.
 *)
  DDERR_HWNDSUBCLASSED                    = MAKE_DDHRESULT + 570;

(*
 * The CooperativeLevel HWND has already been set.
 * It can not be reset while the process has surfaces or palettes created.
 *)
  DDERR_HWNDALREADYSET                    = MAKE_DDHRESULT + 571;

(*
 * No palette object attached to this surface.
 *)
  DDERR_NOPALETTEATTACHED                 = MAKE_DDHRESULT + 572;

(*
 * No hardware support for 16 or 256 color palettes.
 *)
  DDERR_NOPALETTEHW                       = MAKE_DDHRESULT + 573;

(*
 * If a clipper object is attached to the source surface passed into a
 * BltFast call.
 *)
  DDERR_BLTFASTCANTCLIP                   = MAKE_DDHRESULT + 574;

(*
 * No blter.
 *)
  DDERR_NOBLTHW                           = MAKE_DDHRESULT + 575;

(*
 * No DirectDraw ROP hardware.
 *)
  DDERR_NODDROPSHW                        = MAKE_DDHRESULT + 576;

(*
 * returned when GetOverlayPosition is called on a hidden overlay
 *)
  DDERR_OVERLAYNOTVISIBLE                 = MAKE_DDHRESULT + 577;

(*
 * returned when GetOverlayPosition is called on a overlay that UpdateOverlay
 * has never been called on to establish a destionation.
 *)
  DDERR_NOOVERLAYDEST                     = MAKE_DDHRESULT + 578;

(*
 * returned when the position of the overlay on the destionation is no longer
 * legal for that destionation.
 *)
  DDERR_INVALIDPOSITION                   = MAKE_DDHRESULT + 579;

(*
 * returned when an overlay member is called for a non-overlay surface
 *)
  DDERR_NOTAOVERLAYSURFACE                = MAKE_DDHRESULT + 580;

(*
 * An attempt was made to set the cooperative level when it was already
 * set to exclusive.
 *)
  DDERR_EXCLUSIVEMODEALREADYSET           = MAKE_DDHRESULT + 581;

(*
 * An attempt has been made to flip a surface that is not flippable.
 *)
  DDERR_NOTFLIPPABLE                      = MAKE_DDHRESULT + 582;

(*
 * Can't duplicate primary & 3D surfaces, or surfaces that are implicitly
 * created.
 *)
  DDERR_CANTDUPLICATE                     = MAKE_DDHRESULT + 583;

(*
 * Surface was not locked.  An attempt to unlock a surface that was not
 * locked at all, or by this process, has been attempted.
 *)
  DDERR_NOTLOCKED                         = MAKE_DDHRESULT + 584;

(*
 * Windows can not create any more DCs, or a DC was requested for a paltte-indexed
 * surface when the surface had no palette AND the display mode was not palette-indexed
 * (in this case DirectDraw cannot select a proper palette into the DC)
 *)
  DDERR_CANTCREATEDC                      = MAKE_DDHRESULT + 585;

(*
 * No DC was ever created for this surface.
 *)
  DDERR_NODC                              = MAKE_DDHRESULT + 586;

(*
 * This surface can not be restored because it was created in a different
 * mode.
 *)
  DDERR_WRONGMODE                         = MAKE_DDHRESULT + 587;

(*
 * This surface can not be restored because it is an implicitly created
 * surface.
 *)
  DDERR_IMPLICITLYCREATED                 = MAKE_DDHRESULT + 588;

(*
 * The surface being used is not a palette-based surface
 *)
  DDERR_NOTPALETTIZED                     = MAKE_DDHRESULT + 589;

(*
 * The display is currently in an unsupported mode
 *)
  DDERR_UNSUPPORTEDMODE                   = MAKE_DDHRESULT + 590;

(*
 * Operation could not be carried out because there is no mip-map
 * texture mapping hardware present or available.
 *)
  DDERR_NOMIPMAPHW                        = MAKE_DDHRESULT + 591;

(*
 * The requested action could not be performed because the surface was of
 * the wrong type.
 *)
  DDERR_INVALIDSURFACETYPE                = MAKE_DDHRESULT + 592;

(*
 * Device does not support optimized surfaces, therefore no video memory optimized surfaces
 *)
  DDERR_NOOPTIMIZEHW                      = MAKE_DDHRESULT + 600;

(*
 * Surface is an optimized surface, but has not yet been allocated any memory
 *)
  DDERR_NOTLOADED                         = MAKE_DDHRESULT + 601;

(*
 * Attempt was made to create or set a device window without first setting
 * the focus window
 *)
  DDERR_NOFOCUSWINDOW                     = MAKE_DDHRESULT + 602;

(*
 * Attempt was made to set a palette on a mipmap sublevel
 *)
  DDERR_NOTONMIPMAPSUBLEVEL               = MAKE_DDHRESULT + 603;

(*
 * A DC has already been returned for this surface. Only one DC can be
 * retrieved per surface.
 *)
  DDERR_DCALREADYCREATED                  = MAKE_DDHRESULT + 620;

(*
 * An attempt was made to allocate non-local video memory from a device
 * that does not support non-local video memory.
 *)
  DDERR_NONONLOCALVIDMEM                  = MAKE_DDHRESULT + 630;

(*
 * The attempt to page lock a surface failed.
 *)
  DDERR_CANTPAGELOCK                      = MAKE_DDHRESULT + 640;

(*
 * The attempt to page unlock a surface failed.
 *)
  DDERR_CANTPAGEUNLOCK                    = MAKE_DDHRESULT + 660;

(*
 * An attempt was made to page unlock a surface with no outstanding page locks.
 *)
  DDERR_NOTPAGELOCKED                     = MAKE_DDHRESULT + 680;

(*
 * There is more data available than the specified buffer size could hold
 *)
  DDERR_MOREDATA                                = MAKE_DDHRESULT + 690;

(*
 * The data has expired and is therefore no longer valid.
 *)
  DDERR_EXPIRED                           = MAKE_DDHRESULT + 691;

(*
 * The mode test has finished executing.
 *)
 DDERR_TESTFINISHED                      = MAKE_DDHRESULT + 692;

(*
 * The mode test has switched to a new mode.
 *)
 DDERR_NEWMODE                           = MAKE_DDHRESULT + 693;

(*
 * D3D has not yet been initialized.
 *)
 DDERR_D3DNOTINITIALIZED                 = MAKE_DDHRESULT + 694;

(*
 * The video port is not active
 *)
  DDERR_VIDEONOTACTIVE                          = MAKE_DDHRESULT + 695;

(*
 * The monitor does not have EDID data.
 *)
 DDERR_NOMONITORINFORMATION             = MAKE_DDHRESULT + 696;

(*
 * The driver does not enumerate display mode refresh rates.
 *)
 DDERR_NODRIVERSUPPORT                  = MAKE_DDHRESULT + 697;

(*
 * Surfaces created by one direct draw device cannot be used directly by
 * another direct draw device.
 *)
  DDERR_DEVICEDOESNTOWNSURFACE                  = MAKE_DDHRESULT + 699;

(*
 * An attempt was made to invoke an interface member of a DirectDraw object
 * created by CoCreateInstance() before it was initialized.
 *)
  DDERR_NOTINITIALIZED                    = CO_E_NOTINITIALIZED;


(* Alpha bit depth constants *)

(*
 * API's
 *
 * BWS: Note that UNICODE versions of some functions were dropped
 * during translation
 *)

type
  TDDEnumCallback = function conv arg_stdcall (const lpGUID: TGUID; lpDriverDescription: LPSTR;
      lpDriverName: LPSTR; lpContext: Pointer): Bool;

const
  REGSTR_KEY_DDHW_DESCRIPTION = 'Description';
  REGSTR_KEY_DDHW_DRIVERNAME  = 'DriverName';
  REGSTR_PATH_DDHW            = 'Hardware\DirectDrawDrivers';

  DDCREATE_HARDWAREONLY       = $00000001;
  DDCREATE_EMULATIONONLY      = $00000002;

  DDSDM_STANDARDVGAMODE       = 1;

function GET_WHQL_YEAR(dwWHQLLevel: DWORD): DWORD;
function GET_WHQL_MONTH(dwWHQLLevel: DWORD): DWORD;
function GET_WHQL_DAY(dwWHQLLevel: DWORD): DWORD;
function MAKEFOURCC(ch0, ch1, ch2, ch3: Char): DWORD;
function DDErrorString(Value: HResult): String;

function DirectDrawEnumerate conv arg_stdcall (lpCallback: Pointer; lpContext: Pointer): HResult;
    external 'DDRAW.DLL' name 'DirectDrawEnumerateA';
function DirectDrawEnumerateEx conv arg_stdcall (lpCallback: TDDEnumCallback; lpContext: Pointer; dwFlags: DWORD): HResult;
    external 'DDRAW.DLL' name 'DirectDrawEnumerateExA';
function DirectDrawCreate conv arg_stdcall (lpGUID: PGUID; var lplpDD: Pointer; pUnkOuter: Pointer): HResult;
    external 'DDRAW.DLL' name 'DirectDrawCreate';
function DirectDrawCreateEx conv arg_stdcall (lpGUID: PGUID; var lplpDD: Pointer; iid: TREFIID; pUnkOuter: Pointer): HResult;
    external 'DDRAW.DLL' name 'DirectDrawCreateEx';
function DirectDrawCreateClipper conv arg_stdcall (dwFlags: DWORD; var lplpDDClipper: Pointer; pUnkOuter: Pointer): HResult;
    external 'DDRAW.DLL' name 'DirectDrawCreateClipper';

(************************ Direct3D Dummy Section ****************************)

(* TD3DValue is the fundamental Direct3D fractional data type *)

type
  TRefClsID = TGUID;

type
  TD3DValue = single;
  TD3DFixed = LongInt;
  float = TD3DValue;
  PD3DColor = ^TD3DColor;
  TD3DColor = DWORD;

type
  PD3DVector = ^TD3DVector;
  TD3DVector = packed record
    case Longint of
    0: (
      x: TD3DValue;
      y: TD3DValue;
      z: TD3DValue;
     );
    1: (
      dvX: TD3DValue;
      dvY: TD3DValue;
      dvZ: TD3DValue;
     );
  end;

(************************ DirectSound Section *******************************)

const
  _FACDS = $878;

const
// Direct Sound Component GUID {47D4D946-62E8-11cf-93BC-444553540000}
  CLSID_DirectSound: TGUID =
    (D1:$47d4d946;D2:$62e8;D3:$11cf;D4:($93,$bc,$44,$45,$53,$54,$00,$0));

// DirectSound Capture Component GUID {B0210780-89CD-11d0-AF08-00A0C925CD16}
  CLSID_DirectSoundCapture: TGUID =
    (D1:$b0210780;D2:$89cd;D3:$11d0;D4:($af,$8,$00,$a0,$c9,$25,$cd,$16));

//
// GUID's for all the objects
//
const
  IID_IDirectSound: TGUID =
      (D1:$279AFA83;D2:$4981;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectSoundBuffer: TGUID =
      (D1:$279AFA85;D2:$4981;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectSound3DListener: TGUID =
      (D1:$279AFA84;D2:$4981;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectSound3DBuffer: TGUID =
      (D1:$279AFA86;D2:$4981;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectSoundCapture: TGUID =
      (D1:$b0210781;D2:$89cd;D3:$11d0;D4:($af,$08,$00,$a0,$c9,$25,$cd,$16));
  IID_IDirectSoundCaptureBuffer: TGUID =
      (D1:$b0210782;D2:$89cd;D3:$11d0;D4:($af,$08,$00,$a0,$c9,$25,$cd,$16));
  IID_IDirectSoundNotify: TGUID =
      (D1:$b0210783;D2:$89cd;D3:$11d0;D4:($af,$08,$00,$a0,$c9,$25,$cd,$16));
  IID_IKsPropertySet: TGUID =
      (D1:$31efac30;D2:$515c;D3:$11d0;D4:($a9,$aa,$00,$aa,$00,$61,$be,$93));

//
// Structures
//
type
  PDSCaps = ^TDSCaps;
  TDSCaps = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwMinSecondarySampleRate: DWORD;
    dwMaxSecondarySampleRate: DWORD;
    dwPrimaryBuffers: DWORD;
    dwMaxHwMixingAllBuffers: DWORD;
    dwMaxHwMixingStaticBuffers: DWORD;
    dwMaxHwMixingStreamingBuffers: DWORD;
    dwFreeHwMixingAllBuffers: DWORD;
    dwFreeHwMixingStaticBuffers: DWORD;
    dwFreeHwMixingStreamingBuffers: DWORD;
    dwMaxHw3DAllBuffers: DWORD;
    dwMaxHw3DStaticBuffers: DWORD;
    dwMaxHw3DStreamingBuffers: DWORD;
    dwFreeHw3DAllBuffers: DWORD;
    dwFreeHw3DStaticBuffers: DWORD;
    dwFreeHw3DStreamingBuffers: DWORD;
    dwTotalHwMemBytes: DWORD;
    dwFreeHwMemBytes: DWORD;
    dwMaxContigFreeHwMemBytes: DWORD;
    dwUnlockTransferRateHwBuffers: DWORD;
    dwPlayCpuOverheadSwBuffers: DWORD;
    dwReserved1: DWORD;
    dwReserved2: DWORD;
  end;
  PCDSCaps = ^TDSCaps;

  PDSBCaps = ^TDSBCaps;
  TDSBCaps = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwBufferBytes: DWORD;
    dwUnlockTransferRate: DWORD;
    dwPlayCpuOverhead: DWORD;
  end;
  PCDSBCaps = ^TDSBCaps;

  PDSBufferDesc = ^TDSBufferDesc;
  TDSBufferDesc = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwBufferBytes: DWORD;
    dwReserved: DWORD;
    lpwfxFormat: PWaveFormatEx;
  end;
  PCDSBufferDesc = ^TDSBufferDesc;

  PDS3DBuffer = ^TDS3DBuffer;
  TDS3DBuffer = packed record
    dwSize: DWORD;
    vPosition: TD3DVector;
    vVelocity: TD3DVector;
    dwInsideConeAngle: DWORD;
    dwOutsideConeAngle: DWORD;
    vConeOrientation: TD3DVector;
    lConeOutsideVolume: Longint;
    flMinDistance: TD3DValue;
    flMaxDistance: TD3DValue;
    dwMode: DWORD;
  end;
  TCDS3DBuffer = ^TDS3DBuffer;

  PDS3DListener = ^TDS3DListener;
  TDS3DListener = packed record
    dwSize: DWORD;
    vPosition: TD3DVector;
    vVelocity: TD3DVector;
    vOrientFront: TD3DVector;
    vOrientTop: TD3DVector;
    flDistanceFactor: TD3DValue;
    flRolloffFactor: TD3DValue;
    flDopplerFactor: TD3DValue;
  end;
  PCDS3DListener = ^TDS3DListener;

  PDSCCaps = ^TDSCCaps;
  TDSCCaps = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwFormats: DWORD;
    dwChannels: DWORD;
  end;
  PCDSCCaps = ^TDSCCaps;

  PDSCBufferDesc = ^TDSCBufferDesc;
  TDSCBufferDesc = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwBufferBytes: DWORD;
    dwReserved: DWORD;
    lpwfxFormat: PWaveFormatEx;
  end;
  PCDSCBufferDesc = ^TDSCBufferDesc;

  PDSCBCaps = ^TDSCBCaps;
  TDSCBCaps = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwBufferBytes: DWORD;
    dwReserved: DWORD;
  end;
  PCDSCBCaps = ^TDSCBCaps;

  PDSBPositionNotify = ^TDSBPositionNotify;
  TDSBPositionNotify = packed record
    dwOffset: DWORD;
    hEventNotify: THandle;
  end;
  PCDSBPositionNotify = ^TDSBPositionNotify;

(*
 * IDirectSound
 *)

  PPDirectSound = ^^IDirectSound;
  IDirectSound = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectSound methods ***)
    CreateSoundBuffer: function conv arg_stdcall (Self: Pointer; lpDSBufferDesc: TDSBufferDesc; var lpIDirectSoundBuffer: Pointer; pUnkOuter: PPUnknown): HResult;
    GetCaps: function conv arg_stdcall (Self: Pointer; var lpDSCaps: TDSCaps) : HResult;
    DuplicateSoundBuffer: function conv arg_stdcall (Self: Pointer; lpDsbOriginal: Pointer; var lpDsbDuplicate: Pointer): HResult;
    SetCooperativeLevel: function conv arg_stdcall (Self: Pointer; wnd: HWND; dwLevel: DWORD): HResult;
    Compact: function conv arg_stdcall (Self: Pointer): HResult;
    GetSpeakerConfig: function conv arg_stdcall (Self: Pointer; var lpdwSpeakerConfig: DWORD): HResult;
    SetSpeakerConfig: function conv arg_stdcall (Self: Pointer; dwSpeakerConfig: DWORD): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpGUID: PGUID): HResult;
  end;

(*
 * IDirectSoundBuffer
 *)

  PPDirectSoundBuffer = ^^IDirectSoundBuffer;
  IDirectSoundBuffer = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectSoundBuffer methods ***)
    GetCaps: function conv arg_stdcall (Self: Pointer; Caps: TDSBCaps): HResult;
    GetCurrentPosition: function conv arg_stdcall (Self: Pointer; var lpdwCurrentPlayCursor: DWORD; var lpdwCurrentWriteCursor: DWORD): HResult;
    GetFormat: function conv arg_stdcall (Self: Pointer; lpwfxFormat: PWaveFormatEx; dwSizeAllocated: DWORD; var lpdwSizeWritten: DWORD): HResult;
    GetVolume: function conv arg_stdcall (Self: Pointer; var lplVolume: Longint): HResult;
    GetPan: function conv arg_stdcall (Self: Pointer; var lplPan: Longint): HResult;
    GetFrequency: function conv arg_stdcall (Self: Pointer; var lpdwFrequency: DWORD): HResult;
    GetStatus: function conv arg_stdcall (Self: Pointer; var lpdwStatus: DWORD): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpDirectSound: PPDirectSound; const lpDSBufferDesc: TDSBufferDesc): HResult;
    Lock: function conv arg_stdcall (Self: Pointer; dwWriteCursor: DWORD; dwWriteBytes: DWORD;
       var lplpvAudioPtr1: Pointer; var lpdwAudioBytes1: DWORD;
       var lplpvAudioPtr2: Pointer; var lpdwAudioBytes2: DWORD;
       dwFlags: DWORD): HResult;
    Play: function conv arg_stdcall (Self: Pointer; dwReserved1, dwReserved2: DWORD; dwFlags: DWORD): HResult;
    SetCurrentPosition: function conv arg_stdcall (Self: Pointer; dwNewPosition: DWORD): HResult;
    SetFormat: function conv arg_stdcall (Self: Pointer; const lpfxFormat: TWaveFormatEx): HResult;
    SetVolume: function conv arg_stdcall (Self: Pointer; lVolume: Longint): HResult;
    SetPan: function conv arg_stdcall (Self: Pointer; lPan: Longint): HResult;
    SetFrequency: function conv arg_stdcall (Self: Pointer; dwFrequency: DWORD): HResult;
    Stop: function conv arg_stdcall (Self: Pointer): HResult;
    Unlock: function conv arg_stdcall (Self: Pointer; lpvAudioPtr1: Pointer; dwAudioBytes1: DWORD;
      lpvAudioPtr2: Pointer; dwAudioBytes2: DWORD): HResult;
    Restore: function conv arg_stdcall (Self: Pointer): HResult;
  end;

(*
 * IDirectSound3DListener
 *)
  PPDirectSound3DListener = ^^IDirectSound3DListener;
  IDirectSound3DListener = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectSound3DListener methods ***)
    GetAllParameters: function conv arg_stdcall (Self: Pointer; var lpListener: TDS3DListener): HResult;
    GetDistanceFactor: function conv arg_stdcall (Self: Pointer; var lpflDistanceFactor: TD3DValue): HResult;
    GetDopplerFactor: function conv arg_stdcall (Self: Pointer; var lpflDopplerFactor: TD3DValue): HResult;
    GetOrientation: function conv arg_stdcall (Self: Pointer; var lpvOrientFront, lpvOrientTop: TD3DVector): HResult;
    GetPosition: function conv arg_stdcall (Self: Pointer; var lpvPosition: TD3DVector): HResult;
    GetRolloffFactor: function conv arg_stdcall (Self: Pointer; var lpflRolloffFactor: TD3DValue): HResult;
    GetVelocity: function conv arg_stdcall (Self: Pointer; var lpvVelocity: TD3DVector): HResult;
    SetAllParameters: function conv arg_stdcall (Self: Pointer; const lpListener: TDS3DListener; dwApply: DWORD): HResult;
    SetDistanceFactor: function conv arg_stdcall (Self: Pointer; flDistanceFactor: TD3DValue; dwApply: DWORD): HResult;
    SetDopplerFactor: function conv arg_stdcall (Self: Pointer; flDopplerFactor: TD3DValue; dwApply: DWORD): HResult;
    SetOrientation: function conv arg_stdcall (Self: Pointer; xFront, yFront, zFront, xTop, yTop, zTop: TD3DValue;
        dwApply: DWORD): HResult;
    SetPosition: function conv arg_stdcall (Self: Pointer; x, y, z: TD3DValue; dwApply: DWORD): HResult;
    SetRolloffFactor: function  conv arg_stdcall (Self: Pointer; flRolloffFactor: TD3DValue; dwApply: DWORD): HResult;
    SetVelocity: function conv arg_stdcall (Self: Pointer; x, y, z: TD3DValue; dwApply: DWORD): HResult;
    CommitDeferredSettings: function conv arg_stdcall (Self: Pointer): HResult;
  end;

(*
 * IDirectSound3DBuffer
 *)

  PPDirectSound3DBuffer = ^^IDirectSound3DBuffer;
  IDirectSound3DBuffer = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectSound3DBuffer methods ***)
    GetAllParameters: function conv arg_stdcall (Self: Pointer; var lpDs3dBuffer: TDS3DBuffer): HResult;
    GetConeAngles: function conv arg_stdcall (Self: Pointer; var lpdwInsideConeAngle: DWORD;
        var lpdwOutsideConeAngle: DWORD): HResult;
    GetConeOrientation: function conv arg_stdcall (Self: Pointer; var lpvOrientation: TD3DVector): HResult;
    GetConeOutsideVolume: function conv arg_stdcall (Self: Pointer; var lplConeOutsideVolume: Longint): HResult;
    GetMaxDistance: function conv arg_stdcall (Self: Pointer; var lpflMaxDistance: TD3DValue): HResult;
    GetMinDistance: function conv arg_stdcall (Self: Pointer; var lpflMinDistance: TD3DValue): HResult;
    GetMode: function conv arg_stdcall (Self: Pointer; var lpdwMod: DWORD): HResult;
    GetPosition: function conv arg_stdcall (Self: Pointer; var lpvPosition: TD3DVector): HResult;
    GetVelocity: function conv arg_stdcall (Self: Pointer; var lpvVelocity: TD3DVector): HResult;
    SetAllParameters: function conv arg_stdcall (Self: Pointer; const lpDs3dBuffer: TDS3DBuffer; dwApply: DWORD): HResult;
    SetConeAngles: function conv arg_stdcall (Self: Pointer; dwInsideConeAngle: DWORD; dwOutsideConeAngle: DWORD; dwApply: DWORD): HResult;
    SetConeOrientation: function conv arg_stdcall (Self: Pointer; x, y, z: TD3DValue; dwApply: DWORD): HResult;
    SetConeOutsideVolume: function conv arg_stdcall (Self: Pointer; lConeOutsideVolume: Longint; dwApply: DWORD): HResult;
    SetMaxDistance: function conv arg_stdcall (Self: Pointer; flMaxDistance: TD3DValue; dwApply: DWORD): HResult;
    SetMinDistance: function conv arg_stdcall (Self: Pointer; flMinDistance: TD3DValue; dwApply: DWORD): HResult;
    SetMode: function conv arg_stdcall (Self: Pointer; dwMode: DWORD; dwApply: DWORD): HResult;
    SetPosition: function conv arg_stdcall (Self: Pointer; x, y, z: TD3DValue; dwApply: DWORD): HResult;
    SetVelocity: function conv arg_stdcall (Self: Pointer; x, y, z: TD3DValue; dwApply: DWORD): HResult;
  end;

(*
 * IDirectSoundCapture
 *)

  PPDirectSoundCapture = ^^IDirectSoundCapture;
  IDirectSoundCapture = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectSoundCapture methods ***)
    CreateCaptureBuffer: function conv arg_stdcall (Self: Pointer; const lpDSCBufferDesc: TDSCBufferDesc;
        var lplpDirectSoundCaptureBuffer: Pointer;
        pUnkOuter: PPUnknown): HResult;
    GetCaps: function conv arg_stdcall (Self: Pointer; var lpDSCCaps: TDSCCaps): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpGuid: PGUID): HResult;
  end;

(*
 * IDirectSoundCaptureBuffer
 *)

  PPDirectSoundCaptureBuffer = ^^IDirectSoundCaptureBuffer;
  IDirectSoundCaptureBuffer = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectSoundCaptureBuffer methods ***)
    GetCaps: function conv arg_stdcall (Self: Pointer; var lpDSCBCaps: TDSCBCaps): HResult;
    GetCurrentPosition: function conv arg_stdcall (Self: Pointer; var lpdwCapturePosition, lpdwReadPosition: DWORD): HResult;
    GetFormat: function conv arg_stdcall (Self: Pointer; var lpwfxFormat: TWaveFormatEx; dwSizeAllocated: DWORD; var lpdwSizeWritten: DWORD): HResult;
    GetStatus: function conv arg_stdcall (Self: Pointer; var lpdwStatus: DWORD): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpDirectSoundCapture: PPDirectSoundCapture; const lpcDSBufferDesc: TDSCBufferDesc): HResult;
    Lock: function conv arg_stdcall (Self: Pointer; dwReadCursor: DWORD; dwReadBytes: DWORD;
        var lplpvAudioPtr1: Pointer; var lpdwAudioBytes1: DWORD;
        var lplpvAudioPtr2: Pointer; var lpdwAudioBytes2: DWORD;
        dwFlags: DWORD): HResult;
    Start: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    Stop: function conv arg_stdcall (Self: Pointer): HResult;
    Unlock: function conv arg_stdcall (Self: Pointer; lpvAudioPtr1: Pointer; dwAudioBytes1: DWORD; lpvAudioPtr2: Pointer; dwAudioBytes2: DWORD): HResult;
  end;

(*
 * IDirectSoundNotify
 *)

  PPDirectSoundNotify = ^^IDirectSoundNotify;
  IDirectSoundNotify = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectSoundNotify methods ***)
    SetNotificationPositions: function conv arg_stdcall (Self: Pointer; cPositionNotifies: DWORD; const lpcPositionNotifies): HResult;
  end;

(*
 * IKsPropertySet
 *)

const
  KSPROPERTY_SUPPORT_GET = $00000001;
  KSPROPERTY_SUPPORT_SET = $00000002;

type

(*
 * IKsPropertySet
 *)

  PPKsPropertySet = ^^IKsPropertySet;
  IKsPropertySet = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectSoundCaptureBuffer methods ***)
    GetProperty: function conv arg_stdcall (Self: Pointer; const PropertySetId: TGUID; PropertyId: DWORD;
        var pPropertyParams; cbPropertyParams: DWORD;
        var pPropertyData; cbPropertyData: DWORD;
        var pcbReturnedData: ULONG): HResult;
    SetProperty: function conv arg_stdcall (Self: Pointer; const PropertySetId: TGUID; PropertyId: DWORD;
        const pPropertyParams; cbPropertyParams: DWORD;
        const pPropertyData; cbPropertyData: DWORD): HResult;
    QuerySupport: function conv arg_stdcall (Self: Pointer; const PropertySetId: TGUID; PropertyId: DWORD; var pSupport: ULONG): HResult;
  end;

// Return Codes

const
  DS_OK                         = HResult(0);
  DSERR_ALLOCATED               = HResult($88780000 + 10);
  DSERR_CONTROLUNAVAIL          = HResult($88780000 + 30);
  DSERR_INVALIDPARAM            = HResult(E_INVALIDARG);
  DSERR_INVALIDCALL             = HResult($88780000 + 50);
  DSERR_GENERIC                 = HResult(E_FAIL);
  DSERR_PRIOLEVELNEEDED         = HResult($88780000 + 70);
  DSERR_OUTOFMEMORY             = HResult(E_OUTOFMEMORY);
  DSERR_BADFORMAT               = HResult($88780000 + 100);
  DSERR_UNSUPPORTED             = HResult(E_NOTIMPL);
  DSERR_NODRIVER                = HResult($88780000 + 120);
  DSERR_ALREADYINITIALIZED      = HResult($88780000 + 130);
  DSERR_NOAGGREGATION           = HResult(CLASS_E_NOAGGREGATION);
  DSERR_BUFFERLOST              = HResult($88780000 + 150);
  DSERR_OTHERAPPHASPRIO         = HResult($88780000 + 160);
  DSERR_UNINITIALIZED           = HResult($88780000 + 170);
  DSERR_NOINTERFACE             = HResult(E_NOINTERFACE);

// Flags

  DSCAPS_PRIMARYMONO      = $00000001;
  DSCAPS_PRIMARYSTEREO    = $00000002;
  DSCAPS_PRIMARY8BIT      = $00000004;
  DSCAPS_PRIMARY16BIT     = $00000008;
  DSCAPS_CONTINUOUSRATE   = $00000010;
  DSCAPS_EMULDRIVER       = $00000020;
  DSCAPS_CERTIFIED        = $00000040;
  DSCAPS_SECONDARYMONO    = $00000100;
  DSCAPS_SECONDARYSTEREO  = $00000200;
  DSCAPS_SECONDARY8BIT    = $00000400;
  DSCAPS_SECONDARY16BIT   = $00000800;

  DSBPLAY_LOOPING         = $00000001;

  DSBSTATUS_PLAYING       = $00000001;
  DSBSTATUS_BUFFERLOST    = $00000002;
  DSBSTATUS_LOOPING       = $00000004;

  DSBLOCK_FROMWRITECURSOR = $00000001;
  DSBLOCK_ENTIREBUFFER    = $00000002;

  DSSCL_NORMAL            = $00000001;
  DSSCL_PRIORITY          = $00000002;
  DSSCL_EXCLUSIVE         = $00000003;
  DSSCL_WRITEPRIMARY      = $00000004;

  DS3DMODE_NORMAL         = $00000000;
  DS3DMODE_HEADRELATIVE   = $00000001;
  DS3DMODE_DISABLE        = $00000002;

  DS3D_IMMEDIATE          = $00000000;
  DS3D_DEFERRED           = $00000001;

  DS3D_MINDISTANCEFACTOR     = 0.0;
  DS3D_MAXDISTANCEFACTOR     = 10.0;
  DS3D_DEFAULTDISTANCEFACTOR = 1.0;

  DS3D_MINROLLOFFFACTOR      = 0.0;
  DS3D_MAXROLLOFFFACTOR      = 10.0;
  DS3D_DEFAULTROLLOFFFACTOR  = 1.0;

  DS3D_MINDOPPLERFACTOR      = 0.0;
  DS3D_MAXDOPPLERFACTOR      = 10.0;
  DS3D_DEFAULTDOPPLERFACTOR  = 1.0;

  DS3D_DEFAULTMINDISTANCE    = 1.0;
  DS3D_DEFAULTMAXDISTANCE    = 1000000000.0;

  DS3D_MINCONEANGLE          = 0;
  DS3D_MAXCONEANGLE          = 360;
  DS3D_DEFAULTCONEANGLE      = 360;

  DS3D_DEFAULTCONEOUTSIDEVOLUME = 0;

  DSBCAPS_PRIMARYBUFFER       = $00000001;
  DSBCAPS_STATIC              = $00000002;
  DSBCAPS_LOCHARDWARE         = $00000004;
  DSBCAPS_LOCSOFTWARE         = $00000008;
  DSBCAPS_CTRL3D              = $00000010;
  DSBCAPS_CTRLFREQUENCY       = $00000020;
  DSBCAPS_CTRLPAN             = $00000040;
  DSBCAPS_CTRLVOLUME          = $00000080;
  DSBCAPS_CTRLPOSITIONNOTIFY  = $00000100;
  DSBCAPS_CTRLDEFAULT         = $000000E0;
  DSBCAPS_CTRLALL             = $000001F0;
  DSBCAPS_STICKYFOCUS         = $00004000;
  DSBCAPS_GLOBALFOCUS         = $00008000;
  DSBCAPS_GETCURRENTPOSITION2 = $00010000;
  DSBCAPS_MUTE3DATMAXDISTANCE = $00020000;

  DSCBCAPS_WAVEMAPPED = $80000000;

  DSSPEAKER_HEADPHONE = $00000001;
  DSSPEAKER_MONO      = $00000002;
  DSSPEAKER_QUAD      = $00000003;
  DSSPEAKER_STEREO    = $00000004;
  DSSPEAKER_SURROUND  = $00000005;

function DSSPEAKER_COMBINED(c, g: Byte): DWORD;
function DSSPEAKER_CONFIG(a: DWORD): Byte;
function DSSPEAKER_GEOMETRY(a: DWORD): Byte;

const
  DSCCAPS_EMULDRIVER    = $00000020;
  DSCBLOCK_ENTIREBUFFER = $00000001;
  DSCBSTATUS_CAPTURING  = $00000001;
  DSCBSTATUS_LOOPING    = $00000002;
  DSCBSTART_LOOPING     = $00000001;
  DSBFREQUENCY_MIN      = 100;
  DSBFREQUENCY_MAX      = 100000;
  DSBFREQUENCY_ORIGINAL = 0;

  DSBPAN_LEFT   = -10000;
  DSBPAN_CENTER = 0;
  DSBPAN_RIGHT  = 10000;

  DSBVOLUME_MIN = -10000;
  DSBVOLUME_MAX = 0;

  DSBSIZE_MIN = 4;
  DSBSIZE_MAX = $0FFFFFFF;

  DSBPN_OFFSETSTOP = $FFFFFFFF;

// DirectSound API

type
  TDSEnumCallbackW = function conv arg_stdcall (lpGuid: PGUID; lpstrDescription: LPCWSTR;
    lpstrModule: LPCWSTR; lpContext: Pointer): Bool;
  LPDSENUMCALLBACKW = TDSEnumCallbackW;

  TDSEnumCallbackA = function conv arg_stdcall (lpGuid: PGUID; lpstrDescription: LPCSTR;
    lpstrModule: LPCSTR; lpContext: Pointer): Bool;
  LPDSENUMCALLBACKA = TDSEnumCallbackA;

  TDSEnumCallback = TDSEnumCallbackA;
  LPDSENUMCALLBACK = TDSEnumCallback;

var
  _DirectSoundCreate: function conv arg_stdcall ( lpGuid: PGUID; var ppDS: PPDirectSound;
      pUnkOuter: PPUnknown): HResult;

  _DirectSoundEnumerateA: function conv arg_stdcall (lpDSEnumCallback: TDSEnumCallbackA;
      lpContext: Pointer): HResult;
  _DirectSoundEnumerate: function conv arg_stdcall (lpDSEnumCallback: TDSEnumCallback;
      lpContext: Pointer): HResult;

  _DirectSoundCaptureCreate: function conv arg_stdcall (lpGUID: PGUID; var lplpDSC: PPDirectSoundCapture;
      pUnkOuter: PPUnknown): HResult;

  _DirectSoundCaptureEnumerateA: function conv arg_stdcall (lpDSEnumCallback: TDSEnumCallbackA;
      lpContext: Pointer): HResult;
  _DirectSoundCaptureEnumerate: function conv arg_stdcall (lpDSEnumCallback: TDSEnumCallback;
      lpContext: Pointer): HResult;


function DirectSoundCreate( lpGuid: PGUID; var ppDS: PPDirectSound; pUnkOuter: PPUnknown): HResult;
function DirectSoundEnumerateA(lpDSEnumCallback: TDSEnumCallbackA; lpContext: Pointer): HResult;
function DirectSoundEnumerate(lpDSEnumCallback: TDSEnumCallback; lpContext: Pointer): HResult;
function DirectSoundCaptureCreate(lpGUID: PGUID; var lplpDSC: PPDirectSoundCapture; pUnkOuter: PPUnknown): HResult;
function DirectSoundCaptureEnumerateA (lpDSEnumCallback: TDSEnumCallbackA; lpContext: Pointer): HResult;
function DirectSoundCaptureEnumerate (lpDSEnumCallback: TDSEnumCallback; lpContext: Pointer): HResult;


(************************ DirectInput Section *******************************)

const
  DIRECTINPUT_VERSION = $0700;

const
  CLSID_DirectInput: TGUID =
    (D1:$25E609E0;D2:$B259;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  CLSID_DirectInputDevice: TGUID =
    (D1:$25E609E1;D2:$B259;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));

const
  IID_IDirectInputA: TGUID =
    (D1:$89521360;D2:$AA8A;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  IID_IDirectInput2A: TGUID =
    (D1:$5944E662;D2:$AA8A;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  IID_IDirectInput7A: TGUID =
    (D1:$9A4CB684;D2:$236D;D3:$11D3;D4:($8E,$9D,$00,$C0,$4F,$68,$44,$AE));
  IID_IDirectInput7: TGUID =
    (D1:$9A4CB684;D2:$236D;D3:$11D3;D4:($8E,$9D,$00,$C0,$4F,$68,$44,$AE));
  IID_IDirectInputDeviceA: TGUID =
    (D1:$5944E680;D2:$C92E;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  IID_IDirectInputDevice: TGUID =
    (D1:$5944E680;D2:$C92E;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  IID_IDirectInputDevice2A: TGUID =
    (D1:$5944E682;D2:$C92E;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  IID_IDirectInputDevice2: TGUID =
    (D1:$5944E682;D2:$C92E;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  IID_IDirectInputEffect: TGUID =
    (D1:$E7E1F7C0;D2:$88D2;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));

  GUID_XAxis: TGUID =
    (D1:$A36D02E0;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_YAxis: TGUID =
    (D1:$A36D02E1;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_ZAxis: TGUID =
    (D1:$A36D02E2;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_RxAxis: TGUID =
    (D1:$A36D02F4;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_RyAxis: TGUID =
    (D1:$A36D02F5;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_RzAxis: TGUID =
    (D1:$A36D02E3;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_Slider: TGUID =
    (D1:$A36D02E4;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_Button: TGUID =
    (D1:$A36D02F0;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_Key: TGUID =
    (D1:$55728220;D2:$D33C;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_POV: TGUID =
    (D1:$A36D02F2;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_Unknown: TGUID =
    (D1:$A36D02F3;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));

  GUID_SysMouse: TGUID =
    (D1:$6F1D2B60;D2:$D5A0;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_SysKeyboard: TGUID =
    (D1:$6F1D2B61;D2:$D5A0;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_Joystick: TGUID =
    (D1:$6F1D2B70;D2:$D5A0;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));

  GUID_ConstantForce: TGUID =
    (D1:$13541C20;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_RampForce: TGUID =
    (D1:$13541C21;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_Square: TGUID =
    (D1:$13541C22;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_Sine: TGUID =
    (D1:$13541C23;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_Triangle: TGUID =
    (D1:$13541C24;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_SawtoothUp: TGUID =
    (D1:$13541C25;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_SawtoothDown: TGUID =
    (D1:$13541C26;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_Spring: TGUID =
    (D1:$13541C27;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_Damper: TGUID =
    (D1:$13541C28;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_Inertia: TGUID =
    (D1:$13541C29;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_Friction: TGUID =
    (D1:$13541C2A;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_CustomForce: TGUID =
    (D1:$13541C2B;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));

(*
 * IDirectInputEffect
 *)

const
  DIEFT_ALL                = $00000000;

  DIEFT_CONSTANTFORCE      = $00000001;
  DIEFT_RAMPFORCE          = $00000002;
  DIEFT_PERIODIC           = $00000003;
  DIEFT_CONDITION          = $00000004;
  DIEFT_CUSTOMFORCE        = $00000005;
  DIEFT_HARDWARE           = $000000FF;

  DIEFT_FFATTACK           = $00000200;
  DIEFT_FFFADE             = $00000400;
  DIEFT_SATURATION         = $00000800;
  DIEFT_POSNEGCOEFFICIENTS = $00001000;
  DIEFT_POSNEGSATURATION   = $00002000;
  DIEFT_DEADBAND           = $00004000;

function DIEFT_GETTYPE(n: DWORD): DWORD;

const
  DI_DEGREES               = 100;
  DI_FFNOMINALMAX          = 10000;
  DI_SECONDS               = 1000000;

type
  PDIConstantForce = ^TDIConstantForce;
  TDIConstantForce = packed record
    lMagnitude: Longint;
  end;

  DICONSTANTFORCE = TDIConstantForce;
  LPDICONSTANTFORCE = PDIConstantForce;

  PDIRampForce = ^TDIRampForce;
  TDIRampForce = packed record
    lStart: Longint;
    lEnd: Longint;
  end;

  DIRAMPFORCE = TDIRampForce;
  LPDIRAMPFORCE = PDIRampForce;

  PDIPeriodic = ^TDIPeriodic;
  TDIPeriodic = packed record
    dwMagnitude: DWORD;
    lOffset: Longint;
    dwPhase: DWORD;
    dwPeriod: DWORD;
  end;

  DIPERIODIC = TDIPeriodic;
  LPDIPERIODIC = PDIPeriodic;

  PDICondition = ^TDICondition;
  TDICondition = packed record
    lOffset: Longint;
    lPositiveCoefficient: Longint;
    lNegativeCoefficient: Longint;
    dwPositiveSaturation: DWORD;
    dwNegativeSaturation: DWORD;
    lDeadBand: Longint;
  end;

  DICONDITION = TDICondition;
  LPDICONDITION = PDICondition;

  PDICustomForce = ^TDICustomForce;
  TDICustomForce = packed record
    cChannels: DWORD;
    dwSamplePeriod: DWORD;
    cSamples: DWORD;
    rglForceData: PLongint;
  end;

  DICUSTOMFORCE = TDICustomForce;
  LPDICUSTOMFORCE = PDICustomForce;

  PDIEnvelope = ^TDIEnvelope;
  TDIEnvelope = packed record
    dwSize: DWORD;                   // SizeOf(DIENVELOPE)
    dwAttackLevel: DWORD;
    dwAttackTime: DWORD;             // Microseconds
    dwFadeLevel: DWORD;
    dwFadeTime: DWORD;               // Microseconds
  end;

  DIENVELOPE = TDIEnvelope;
  LPDIENVELOPE = PDIEnvelope;

  PDIEffect = ^TDIEffect;
  TDIEffect = packed record
    dwSize: DWORD;                   // SizeOf(DIEFFECT)
    dwFlags: DWORD;                  // DIEFF_*
    dwDuration: DWORD;               // Microseconds
    dwSamplePeriod: DWORD;           // Microseconds
    dwGain: DWORD;
    dwTriggerButton: DWORD;          // or DIEB_NOTRIGGER
    dwTriggerRepeatInterval: DWORD;  // Microseconds
    cAxes: DWORD;                    // Number of axes
    rgdwAxes: PDWORD;                // arrayof axes
    rglDirection: PLongint;          // arrayof directions
    lpEnvelope: PDIEnvelope;         // Optional
    cbTypeSpecificParams: DWORD;     // Size of params
    lpvTypeSpecificParams: Pointer;  // Pointer to params
  end;

  DIEFFECT = TDIEffect;
  LPDIEFFECT = PDIEffect;

const
  DIEFF_OBJECTIDS             = $00000001;
  DIEFF_OBJECTOFFSETS         = $00000002;
  DIEFF_CARTESIAN             = $00000010;
  DIEFF_POLAR                 = $00000020;
  DIEFF_SPHERICAL             = $00000040;

  DIEP_DURATION               = $00000001;
  DIEP_SAMPLEPERIOD           = $00000002;
  DIEP_GAIN = $00000004;
  DIEP_TRIGGERBUTTON          = $00000008;
  DIEP_TRIGGERREPEATINTERVAL  = $00000010;
  DIEP_AXES                   = $00000020;
  DIEP_DIRECTION              = $00000040;
  DIEP_ENVELOPE               = $00000080;
  DIEP_TYPESPECIFICPARAMS     = $00000100;
  DIEP_ALLPARAMS              = $000001FF;
  DIEP_START                  = $20000000;
  DIEP_NORESTART              = $40000000;
  DIEP_NODOWNLOAD             = $80000000;
  DIEB_NOTRIGGER              = $FFFFFFFF;

  DIES_SOLO                   = $00000001;
  DIES_NODOWNLOAD             = $80000000;

  DIEGES_PLAYING              = $00000001;
  DIEGES_EMULATED             = $00000002;

type
  PDIEffEscape = ^TDIEffEscape;
  TDIEffEscape = packed record
    dwSize: DWORD;
    dwCommand: DWORD;
    lpvInBuffer: Pointer;
    cbInBuffer: DWORD;
    lpvOutBuffer: Pointer;
    cbOutBuffer: DWORD;
  end;

  DIEFFESCAPE = TDIEffEscape;
  LPDIEFFESCAPE = PDIEffEscape;

  PPDirectInputEffect = ^^IDirectInputEffect;
  IDirectInputEffect = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectInputEffect methods ***)
    Initialize: function conv arg_stdcall (Self: Pointer; hinst: THandle; dwVersion: DWORD; const rguid: TGUID): HResult;
    GetEffectGuid: function conv arg_stdcall (Self: Pointer; var pguid: TGUID): HResult;
    GetParameters: function conv arg_stdcall (Self: Pointer; var peff: TDIEffect; dwFlags: DWORD): HResult;
    SetParameters: function conv arg_stdcall (Self: Pointer; const peff: TDIEffect; dwFlags: DWORD): HResult;
    Start: function conv arg_stdcall (Self: Pointer; dwIterations: DWORD; dwFlags: DWORD): HResult;
    Stop: function conv arg_stdcall (Self: Pointer): HResult;
    GetEffectStatus: function conv arg_stdcall (Self: Pointer; var pdwFlags: DWORD): HResult;
    DownLoad: function conv arg_stdcall (Self: Pointer): HResult;
    Unload: function conv arg_stdcall (Self: Pointer): HResult;
    Escape: function conv arg_stdcall (Self: Pointer; const pesc: TDIEffEscape): HResult;
  end;

{ IDirectInputDevice }

const
  DIDEVTYPE_DEVICE   = 1;
  DIDEVTYPE_MOUSE    = 2;
  DIDEVTYPE_KEYBOARD = 3;
  DIDEVTYPE_JOYSTICK = 4;
  DIDEVTYPE_HID      = $00010000;

  DIDEVTYPEMOUSE_UNKNOWN     = 1;
  DIDEVTYPEMOUSE_TRADITIONAL = 2;
  DIDEVTYPEMOUSE_FINGERSTICK = 3;
  DIDEVTYPEMOUSE_TOUCHPAD    = 4;
  DIDEVTYPEMOUSE_TRACKBALL   = 5;

  DIDEVTYPEKEYBOARD_UNKNOWN     = 0;
  DIDEVTYPEKEYBOARD_PCXT        = 1;
  DIDEVTYPEKEYBOARD_OLIVETTI    = 2;
  DIDEVTYPEKEYBOARD_PCAT        = 3;
  DIDEVTYPEKEYBOARD_PCENH       = 4;
  DIDEVTYPEKEYBOARD_NOKIA1050   = 5;
  DIDEVTYPEKEYBOARD_NOKIA9140   = 6;
  DIDEVTYPEKEYBOARD_NEC98       = 7;
  DIDEVTYPEKEYBOARD_NEC98LAPTOP = 8;
  DIDEVTYPEKEYBOARD_NEC98106    = 9;
  DIDEVTYPEKEYBOARD_JAPAN106    = 10;
  DIDEVTYPEKEYBOARD_JAPANAX     = 11;
  DIDEVTYPEKEYBOARD_J3100       = 12;

  DIDEVTYPEJOYSTICK_UNKNOWN     = 1;
  DIDEVTYPEJOYSTICK_TRADITIONAL = 2;
  DIDEVTYPEJOYSTICK_FLIGHTSTICK = 3;
  DIDEVTYPEJOYSTICK_GAMEPAD     = 4;
  DIDEVTYPEJOYSTICK_RUDDER      = 5;
  DIDEVTYPEJOYSTICK_WHEEL       = 6;
  DIDEVTYPEJOYSTICK_HEADTRACKER = 7;

function GET_DIDEVICE_TYPE(dwDevType: DWORD): DWORD;
function GET_DIDEVICE_SUBTYPE(dwDevType: DWORD): DWORD;

type
  PDIDevCaps_DX3 = ^TDIDevCaps_DX3;
  TDIDevCaps_DX3 = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwDevType: DWORD;
    dwAxes: DWORD;
    dwButtons: DWORD;
    dwPOVs: DWORD;
  end;

  PDIDevCaps_DX5 = ^TDIDevCaps_DX5;
  TDIDevCaps_DX5 = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwDevType: DWORD;
    dwAxes: DWORD;
    dwButtons: DWORD;
    dwPOVs: DWORD;
    dwFFSamplePeriod: DWORD;
    dwFFMinTimeResolution: DWORD;
    dwFirmwareRevision: DWORD;
    dwHardwareRevision: DWORD;
    dwFFDriverVersion: DWORD;
  end;

  TDIDevCaps = TDIDevCaps_DX5;
  PDIDevCaps = PDIDevCaps_DX5;

  DIDEVCAPS = TDIDevCaps;
  LPDIDEVCAPS = PDIDevCaps;

const
  DIDC_ATTACHED           = $00000001;
  DIDC_POLLEDDEVICE       = $00000002;
  DIDC_EMULATED           = $00000004;
  DIDC_POLLEDDATAFORMAT   = $00000008;

  DIDC_FORCEFEEDBACK      = $00000100;
  DIDC_FFATTACK           = $00000200;
  DIDC_FFFADE             = $00000400;
  DIDC_SATURATION         = $00000800;
  DIDC_POSNEGCOEFFICIENTS = $00001000;
  DIDC_POSNEGSATURATION   = $00002000;
  DIDC_DEADBAND           = $00004000;

  DIDFT_ALL        = $00000000;

  DIDFT_RELAXIS    = $00000001;
  DIDFT_ABSAXIS    = $00000002;
  DIDFT_AXIS       = $00000003;

  DIDFT_PSHBUTTON  = $00000004;
  DIDFT_TGLBUTTON  = $00000008;
  DIDFT_BUTTON     = $0000000C;

  DIDFT_POV        = $00000010;

  DIDFT_COLLECTION = $00000040;
  DIDFT_NODATA     = $00000080;

  DIDFT_ANYINSTANCE = $00FFFF00;
  DIDFT_INSTANCEMASK = DIDFT_ANYINSTANCE;

function DIDFT_MAKEINSTANCE(n: WORD): DWORD;
function DIDFT_GETTYPE(n: DWORD): DWORD;
function DIDFT_GETINSTANCE(n: DWORD): WORD;
function DSErrorString(Value: HResult): String;

const
  DIDFT_FFACTUATOR = $01000000;
  DIDFT_FFEFFECTTRIGGER = $02000000;

function DIDFT_ENUMCOLLECTION(n: WORD): DWORD;

const
  DIDFT_NOCOLLECTION = $00FFFF00;

type
  PDIObjectDataFormat = ^TDIObjectDataFormat;
  TDIObjectDataFormat = packed record
    pguid: PGUID;
    dwOfs: DWORD;
    dwType: DWORD;
    dwFlags: DWORD;
  end;

  DIOBJECTDATAFORMAT = TDIObjectDataFormat;
  LPDIOBJECTDATAFORMAT = PDIObjectDataFormat;

  PDIDataFormat = ^TDIDataFormat;
  TDIDataFormat = packed record
    dwSize: DWORD;
    dwObjSize: DWORD;
    dwFlags: DWORD;
    dwDataSize: DWORD;
    dwNumObjs: DWORD;
    rgodf: PDIObjectDataFormat;
  end;

  DIDATAFORMAT = TDIDataFormat;
  LPDIDATAFORMAT = PDIDataFormat;

const
  DIDF_ABSAXIS = $00000001;
  DIDF_RELAXIS = $00000002;

type
  PDIDeviceObjectInstanceA_DX3 = ^TDIDeviceObjectInstanceA_DX3;
  TDIDeviceObjectInstanceA_DX3 = packed record
    dwSize: DWORD;
    guidType: TGUID;
    dwOfs: DWORD;
    dwType: DWORD;
    dwFlags: DWORD;
    tszName: array[0..MAX_PATH-1] of CHAR;
  end;

  PDIDeviceObjectInstanceA_DX5 = ^TDIDeviceObjectInstanceA_DX5;
  TDIDeviceObjectInstanceA_DX5 = packed record
    dwSize: DWORD;
    guidType: TGUID;
    dwOfs: DWORD;
    dwType: DWORD;
    dwFlags: DWORD;
    tszName: array[0..MAX_PATH-1] of CHAR;
    dwFFMaxForce: DWORD;
    dwFFForceResolution: DWORD;
    wCollectionNumber: WORD;
    wDesignatorIndex: WORD;
    wUsagePage: WORD;
    wUsage: WORD;
    dwDimension: DWORD;
    wExponent: WORD;
    wReserved: WORD;
  end;

  TDIDeviceObjectInstanceA = TDIDeviceObjectInstanceA_DX5;
  PDIDeviceObjectInstanceA = PDIDeviceObjectInstanceA_DX5;

  DIDEVICEOBJECTINSTANCEA = TDIDeviceObjectInstanceA;
  LPDIDEVICEOBJECTINSTANCEA = PDIDeviceObjectInstanceA;

  PDIDeviceObjectInstanceW_DX3 = ^TDIDeviceObjectInstanceW_DX3;
  TDIDeviceObjectInstanceW_DX3 = packed record
    dwSize: DWORD;
    guidType: TGUID;
    dwOfs: DWORD;
    dwType: DWORD;
    dwFlags: DWORD;
    tszName: array[0..MAX_PATH-1] of WCHAR;
  end;

  PDIDeviceObjectInstanceW_DX5 = ^TDIDeviceObjectInstanceW_DX5;
  TDIDeviceObjectInstanceW_DX5 = packed record
    dwSize: DWORD;
    guidType: TGUID;
    dwOfs: DWORD;
    dwType: DWORD;
    dwFlags: DWORD;
    tszName: array[0..MAX_PATH-1] of WCHAR;
    dwFFMaxForce: DWORD;
    dwFFForceResolution: DWORD;
    wCollectionNumber: WORD;
    wDesignatorIndex: WORD;
    wUsagePage: WORD;
    wUsage: WORD;
    dwDimension: DWORD;
    wExponent: WORD;
    wReserved: WORD;
  end;

  TDIDeviceObjectInstanceW = TDIDeviceObjectInstanceW_DX5;
  PDIDeviceObjectInstanceW = PDIDeviceObjectInstanceW_DX5;

  DIDEVICEOBJECTINSTANCEW = TDIDeviceObjectInstanceW;
  LPDIDEVICEOBJECTINSTANCEW = PDIDeviceObjectInstanceW;

  TDIDeviceObjectInstance = TDIDeviceObjectInstanceA;
  PDIDeviceObjectInstance = PDIDeviceObjectInstanceA;

  DIDEVICEOBJECTINSTANCE = TDIDeviceObjectInstance;
  LPDIDEVICEOBJECTINSTANCE = PDIDeviceObjectInstance;

  TDIEnumDeviceObjectsCallbackA = function conv arg_stdcall (const peff: TDIDeviceObjectInstanceA; pvRef: Pointer): HResult;
  LPDIENUMDEVICEOBJECTSCALLBACKA = TDIEnumDeviceObjectsCallbackA;

  TDIEnumDeviceObjectsCallbackW = function conv arg_stdcall (const peff: TDIDeviceObjectInstanceW; pvRef: Pointer): HResult;
  LPDIENUMDEVICEOBJECTSCALLBACKW = TDIEnumDeviceObjectsCallbackW;

  TDIEnumDeviceObjectsCallback = TDIEnumDeviceObjectsCallbackA;
  LPDIENUMDEVICEOBJECTSCALLBACK = TDIEnumDeviceObjectsCallback;

const
  DIDOI_FFACTUATOR      = $00000001;
  DIDOI_FFEFFECTTRIGGER = $00000002;
  DIDOI_POLLED          = $00008000;
  DIDOI_ASPECTPOSITION  = $00000100;
  DIDOI_ASPECTVELOCITY  = $00000200;
  DIDOI_ASPECTACCEL     = $00000300;
  DIDOI_ASPECTFORCE     = $00000400;
  DIDOI_ASPECTMASK      = $00000F00;

type
  PDIPropHeader = ^TDIPropHeader;
  TDIPropHeader = packed record
    dwSize: DWORD;
    dwHeaderSize: DWORD;
    dwObj: DWORD;
    dwHow: DWORD;
  end;

  DIPROPHEADER = TDIPropHeader;
  LPDIPROPHEADER = PDIPropHeader;

const
  DIPH_DEVICE   = 0;
  DIPH_BYOFFSET = 1;
  DIPH_BYID     = 2;

type
  PDIPropDWORD = ^TDIPropDWORD;
  TDIPropDWORD = packed record
    diph: TDIPropHeader;
    dwData: DWORD;
  end;

  DIPROPDWORD = TDIPropDWORD;
  LPDIPROPDWORD = PDIPropDWORD;

  PDIPropRange = ^TDIPropRange;
  TDIPropRange = packed record
    diph: TDIPropHeader;
    lMin: Longint;
    lMax: Longint;
  end;

  DIPROPRANGE = TDIPropRange;
  LPDIPROPRANGE = PDIPropRange;

const
  DIPROPRANGE_NOMIN   = $80000000;
  DIPROPRANGE_NOMAX   = $7FFFFFFF;

  DIPROP_BUFFERSIZE   = PGUID(1);
  DIPROP_AXISMODE     = PGUID(2);

  DIPROPAXISMODE_ABS  = 0;
  DIPROPAXISMODE_REL  = 1;

  DIPROP_GRANULARITY  = PGUID(3);
  DIPROP_RANGE        = PGUID(4);
  DIPROP_DEADZONE     = PGUID(5);
  DIPROP_SATURATION   = PGUID(6);
  DIPROP_FFGAIN       = PGUID(7);
  DIPROP_FFLOAD       = PGUID(8);
  DIPROP_AUTOCENTER   = PGUID(9);

  DIPROPAUTOCENTER_OFF = 0;
  DIPROPAUTOCENTER_ON  = 1;

  DIPROP_CALIBRATIONMODE = PGUID(10);

  DIPROPCALIBRATIONMODE_COOKED = 0;
  DIPROPCALIBRATIONMODE_RAW    = 1;

type
  PDIDeviceObjectData = ^TDIDeviceObjectData;
  TDIDeviceObjectData = packed record
    dwOfs: DWORD;
    dwData: DWORD;
    dwTimeStamp: DWORD;
    dwSequence: DWORD;
  end;

  DIDEVICEOBJECTDATA = TDIDeviceObjectData;
  LPDIDEVICEOBJECTDATA = PDIDeviceObjectData;

const
  DIGDD_PEEK = $00000001;

  DISCL_EXCLUSIVE    = $00000001;
  DISCL_NONEXCLUSIVE = $00000002;
  DISCL_FOREGROUND   = $00000004;
  DISCL_BACKGROUND   = $00000008;

type
  PDIDeviceInstanceA_DX3 = ^TDIDeviceInstanceA_DX3;
  TDIDeviceInstanceA_DX3 = packed record
    dwSize: DWORD;
    guidInstance: TGUID;
    guidProduct: TGUID;
    dwDevType: DWORD;
    tszInstanceName: array[0..MAX_PATH-1] of CHAR;
    tszProductName: array[0..MAX_PATH-1] of CHAR;
  end;

  PDIDeviceInstanceA_DX5 = ^TDIDeviceInstanceA_DX5;
  TDIDeviceInstanceA_DX5 = packed record
    dwSize: DWORD;
    guidInstance: TGUID;
    guidProduct: TGUID;
    dwDevType: DWORD;
    tszInstanceName: array[0..MAX_PATH-1] of CHAR;
    tszProductName: array[0..MAX_PATH-1] of CHAR;
    guidFFDriver: TGUID;
    wUsagePage: WORD;
    wUsage: WORD;
  end;

  TDIDeviceInstanceA = TDIDeviceInstanceA_DX5;
  PDIDeviceInstanceA = PDIDeviceInstanceA_DX5;

  DIDEVICEINSTANCEA = TDIDeviceInstanceA;
  LPDIDEVICEINSTANCEA = PDIDeviceInstanceA;

  PDIDeviceInstanceW_DX3 = ^TDIDeviceInstanceW_DX3;
  TDIDeviceInstanceW_DX3 = packed record
    dwSize: DWORD;
    guidInstance: TGUID;
    guidProduct: TGUID;
    dwDevType: DWORD;
    tszInstanceName: array[0..MAX_PATH-1] of WCHAR;
    tszProductName: array[0..MAX_PATH-1] of WCHAR;
  end;

  PDIDeviceInstanceW_DX5 = ^TDIDeviceInstanceW_DX5;
  TDIDeviceInstanceW_DX5 = packed record
    dwSize: DWORD;
    guidInstance: TGUID;
    guidProduct: TGUID;
    dwDevType: DWORD;
    tszInstanceName: array[0..MAX_PATH-1] of WCHAR;
    tszProductName: array[0..MAX_PATH-1] of WCHAR;
    guidFFDriver: TGUID;
    wUsagePage: WORD;
    wUsage: WORD;
  end;

  TDIDeviceInstanceW = TDIDeviceInstanceW_DX5;
  PDIDeviceInstanceW = PDIDeviceInstanceW_DX5;

  DIDEVICEINSTANCEW = TDIDeviceInstanceW;
  LPDIDEVICEINSTANCEW = PDIDeviceInstanceW;

  TDIDeviceInstance = TDIDeviceInstanceA;
  PDIDeviceInstance = PDIDeviceInstanceA;

  DIDEVICEINSTANCE = TDIDeviceInstance;
  LPDIDEVICEINSTANCE = PDIDeviceInstance;

  PPDirectInputDevice = ^^IDirectInputDevice;
  IDirectInputDevice = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectInputDevice methods ***)
    GetCapabilities: function conv arg_stdcall (Self: Pointer; var lpDIDevCaps: TDIDevCaps): HResult;
    EnumObjects: function conv arg_stdcall (Self: Pointer; lpCallback: TDIEnumDeviceObjectsCallbackA; pvRef: Pointer; dwFlags: DWORD): HResult;
    GetProperty: function conv arg_stdcall (Self: Pointer; rguidProp: PGUID; var pdiph: TDIPropHeader): HResult;
    SetProperty: function conv arg_stdcall (Self: Pointer; rguidProp: PGUID; const pdiph: TDIPropHeader): HResult;
    Acquire: function conv arg_stdcall (Self: Pointer): HResult;
    Unacquire: function conv arg_stdcall (Self: Pointer): HResult;
    GetDeviceState: function conv arg_stdcall (Self: Pointer; cbData: DWORD; var lpvData): HResult;
    GetDeviceData: function conv arg_stdcall (Self: Pointer; cbObjectData: DWORD; var rgdod: TDIDeviceObjectData; var pdwInOut: DWORD; dwFlags: DWORD): HResult;
    SetDataFormat: function conv arg_stdcall (Self: Pointer; var lpdf: TDIDataFormat): HResult;
    SetEventNotification: function conv arg_stdcall (Self: Pointer; hEvent: THandle): HResult;
    SetCooperativeLevel: function conv arg_stdcall (Self: Pointer; hwnd: HWND; dwFlags: DWORD): HResult;
    GetObjectInfo: function conv arg_stdcall (Self: Pointer; var pdidoi: TDIDeviceObjectInstanceA; dwObj: DWORD; dwHow: DWORD): HResult;
    GetDeviceInfo: function conv arg_stdcall (Self: Pointer; var pdidi: TDIDeviceInstanceA): HResult;
    RunControlPanel: function conv arg_stdcall (Self: Pointer; hwndOwner: HWND; dwFlags: DWORD): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; hinst: THandle; dwVersion: DWORD; const rguid: TGUID): HResult;
  end;

const
  DISFFC_RESET           = $00000001;
  DISFFC_STOPALL         = $00000002;
  DISFFC_PAUSE           = $00000004;
  DISFFC_CONTINUE        = $00000008;
  DISFFC_SETACTUATORSON  = $00000010;
  DISFFC_SETACTUATORSOFF = $00000020;

  DIGFFS_EMPTY           = $00000001;
  DIGFFS_STOPPED         = $00000002;
  DIGFFS_PAUSED          = $00000004;
  DIGFFS_ACTUATORSON     = $00000010;
  DIGFFS_ACTUATORSOFF    = $00000020;
  DIGFFS_POWERON         = $00000040;
  DIGFFS_POWEROFF        = $00000080;
  DIGFFS_SAFETYSWITCHON  = $00000100;
  DIGFFS_SAFETYSWITCHOFF = $00000200;
  DIGFFS_USERFFSWITCHON  = $00000400;
  DIGFFS_USERFFSWITCHOFF = $00000800;
  DIGFFS_DEVICELOST      = $80000000;

type
  PDIEffectInfoA = ^TDIEffectInfoA;
  TDIEffectInfoA = packed record
    dwSize: DWORD;
    guid: TGUID;
    dwEffType: DWORD;
    dwStaticParams: DWORD;
    dwDynamicParams: DWORD;
    tszName: array[0..MAX_PATH-1] of CHAR;
  end;

  DIEFFECTINFOA = TDIEffectInfoA;
  LPDIEFFECTINFOA = PDIEffectInfoA;

  PDIEffectInfoW = ^TDIEffectInfoW;
  TDIEffectInfoW = packed record
    dwSize: DWORD;
    guid: TGUID;
    dwEffType: DWORD;
    dwStaticParams: DWORD;
    dwDynamicParams: DWORD;
    tszName: array[0..MAX_PATH-1] of WCHAR;
  end;

  DIEFFECTINFOW = TDIEffectInfoW;
  LPDIEFFECTINFOW = PDIEffectInfoW;

  DIEFFECTINFO = TDIEffectInfoA;
  LPDIEFFECTINFO = PDIEffectInfoA;

  TDIEnumEffectsCallbackA = function conv arg_stdcall (const pdei: TDIEffectInfoA; pvRef: Pointer): HResult;
  LPDIENUMEFFECTSCALLBACKA = TDIEnumEffectsCallbackA;

  TDIEnumEffectsCallbackW = function conv arg_stdcall (const pdei: TDIEffectInfoW; pvRef: Pointer): HResult;
  LPDIENUMEFFECTSCALLBACKW = TDIEnumEffectsCallbackW;

  TDIEnumEffectsCallback = TDIEnumEffectsCallbackA;
  LPDIENUMEFFECTSCALLBACK = TDIEnumEffectsCallback;

  LPDIENUMCREATEDEFFECTOBJECTSCALLBACK = function conv arg_stdcall (const peff: IDirectInputEffect; pvRef: Pointer): HResult;

  PPDirectInputDevice2 = ^^IDirectInputDevice2;
  IDirectInputDevice2 = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectInputDevice2 methods ***)
    GetCapabilities: function conv arg_stdcall (Self: Pointer; var lpDIDevCaps: TDIDevCaps): HResult;
    EnumObjects: function conv arg_stdcall (Self: Pointer; lpCallback: TDIEnumDeviceObjectsCallbackA; pvRef: Pointer; dwFlags: DWORD): HResult;
    GetProperty: function conv arg_stdcall (Self: Pointer; rguidProp: PGUID; var pdiph: TDIPropHeader): HResult;
    SetProperty: function conv arg_stdcall (Self: Pointer; rguidProp: PGUID; const pdiph: TDIPropHeader): HResult;
    Acquire: function conv arg_stdcall (Self: Pointer): HResult;
    Unacquire: function conv arg_stdcall (Self: Pointer): HResult;
    GetDeviceState: function conv arg_stdcall (Self: Pointer; cbData: DWORD; var lpvData): HResult;
    GetDeviceData: function conv arg_stdcall (Self: Pointer; cbObjectData: DWORD; var rgdod: TDIDeviceObjectData; var pdwInOut: DWORD; dwFlags: DWORD): HResult;
    SetDataFormat: function conv arg_stdcall (Self: Pointer; const lpdf: TDIDataFormat): HResult;
    SetEventNotification: function conv arg_stdcall (Self: Pointer; hEvent: THandle): HResult;
    SetCooperativeLevel: function conv arg_stdcall (Self: Pointer; hwnd: HWND; dwFlags: DWORD): HResult;
    GetObjectInfo: function conv arg_stdcall (Self: Pointer; var pdidoi: TDIDeviceObjectInstanceA; dwObj: DWORD; dwHow: DWORD): HResult;
    GetDeviceInfo: function conv arg_stdcall (Self: Pointer; var pdidi: TDIDeviceInstanceA): HResult;
    RunControlPanel: function conv arg_stdcall (Self: Pointer; hwndOwner: HWND; dwFlags: DWORD): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; hinst: THandle; dwVersion: DWORD; const rguid: TGUID): HResult;
    // IDirectInputDevice2 methods
    CreateEffect: function conv arg_stdcall (Self: Pointer; const rguid: TGUID; const lpeff: TDIEffect;
        var ppdeff: IDirectInputEffect; punkOuter: IUnknown): HResult;
    EnumEffects: function conv arg_stdcall (Self: Pointer; lpCallback: TDIEnumEffectsCallbackA; pvRef: Pointer;
        dwEffType: DWORD): HResult;
    GetEffectInfo: function conv arg_stdcall (Self: Pointer; var pdei: TDIEffectInfoA; const rguid: TGUID): HResult;
    GetForceFeedbackState: function conv arg_stdcall (Self: Pointer; var pdwOut: DWORD): HResult;
    SendForceFeedbackCommand: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD): HResult;
    EnumCreatedEffectObjects: function conv arg_stdcall (Self: Pointer; lpCallback:
        LPDIENUMCREATEDEFFECTOBJECTSCALLBACK; pvRef: Pointer; fl: DWORD): HResult;
    Escape: function conv arg_stdcall (Self: Pointer; const pesc: TDIEffEscape): HResult;
    Poll: function conv arg_stdcall (Self: Pointer): HResult;
    SendDeviceData: function conv arg_stdcall (Self: Pointer; cbObjectData: DWORD; const rgdod: TDIDeviceObjectData;
        var pdwInOut: DWORD; fl: DWORD): HResult;
  end;

// Mouse

type
  TDIMouseState = packed record
    lX: Longint;
    lY: Longint;
    lZ: Longint;
    rgbButtons: array[0..3] of BYTE;
  end;

  DIMOUSESTATE = TDIMouseState;

const
  _c_dfDIMouse_Objects: array[0..1] of TDIObjectDataFormat = (
    (pguid: nil;          dwOfs: 0;  dwType: DIDFT_RELAXIS or DIDFT_ANYINSTANCE; dwFlags: 0),
    (pguid: @GUID_Button; dwOfs: 12; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;  dwFlags: 0)
  );

  c_dfDIMouse: TDIDataFormat = (
    dwSize: SizeOf(c_dfDIMouse);
    dwObjSize: SizeOf(TDIObjectDataFormat);
    dwFlags: DIDF_RELAXIS;
    dwDataSize: SizeOf(TDIMouseState);
    dwNumObjs: High(_c_dfDIMouse_Objects)+1;
    rgodf: @_c_dfDIMouse_Objects
  );

// Keyboard

type
  TDIKeyboardState = array[0..255] of Byte;
  DIKEYBOARDSTATE = TDIKeyboardState;

var
  _c_dfDIKeyboard_Objects: array[0..255] of TDIObjectDataFormat;

const
  c_dfDIKeyboard: TDIDataFormat = (
    dwSize: SizeOf(c_dfDIKeyboard);
    dwObjSize: SizeOf(TDIObjectDataFormat);
    dwFlags: DIDF_RELAXIS;
    dwDataSize: SizeOf(TDIKeyboardState);
    dwNumObjs: High(_c_dfDIKeyboard_Objects)+1;
    rgodf: @_c_dfDIKeyboard_Objects
  );

// DirectInput keyboard scan codes

const
  DIK_ESCAPE          = $01;
  DIK_1               = $02;
  DIK_2               = $03;
  DIK_3               = $04;
  DIK_4               = $05;
  DIK_5               = $06;
  DIK_6               = $07;
  DIK_7               = $08;
  DIK_8               = $09;
  DIK_9               = $0A;
  DIK_0               = $0B;
  DIK_MINUS           = $0C;    // - on main keyboard
  DIK_EQUALS          = $0D;
  DIK_BACK            = $0E;    // backspace
  DIK_TAB             = $0F;
  DIK_Q               = $10;
  DIK_W               = $11;
  DIK_E               = $12;
  DIK_R               = $13;
  DIK_T               = $14;
  DIK_Y               = $15;
  DIK_U               = $16;
  DIK_I               = $17;
  DIK_O               = $18;
  DIK_P               = $19;
  DIK_LBRACKET        = $1A;
  DIK_RBRACKET        = $1B;
  DIK_RETURN          = $1C;    // Enter on main keyboard
  DIK_LCONTROL        = $1D;
  DIK_A               = $1E;
  DIK_S               = $1F;
  DIK_D               = $20;
  DIK_F               = $21;
  DIK_G               = $22;
  DIK_H               = $23;
  DIK_J               = $24;
  DIK_K               = $25;
  DIK_L               = $26;
  DIK_SEMICOLON       = $27;
  DIK_APOSTROPHE      = $28;
  DIK_GRAVE           = $29;    // accent grave
  DIK_LSHIFT          = $2A;
  DIK_BACKSLASH       = $2B;
  DIK_Z               = $2C;
  DIK_X               = $2D;
  DIK_C               = $2E;
  DIK_V               = $2F;
  DIK_B               = $30;
  DIK_N               = $31;
  DIK_M               = $32;
  DIK_COMMA           = $33;
  DIK_PERIOD          = $34;    // . on main keyboard
  DIK_SLASH           = $35;    // / on main keyboard
  DIK_RSHIFT          = $36;
  DIK_MULTIPLY        = $37;    // * on numeric keypad
  DIK_LMENU           = $38;    // left Alt
  DIK_SPACE           = $39;
  DIK_CAPITAL         = $3A;
  DIK_F1              = $3B;
  DIK_F2              = $3C;
  DIK_F3              = $3D;
  DIK_F4              = $3E;
  DIK_F5              = $3F;
  DIK_F6              = $40;
  DIK_F7              = $41;
  DIK_F8              = $42;
  DIK_F9              = $43;
  DIK_F10             = $44;
  DIK_NUMLOCK         = $45;
  DIK_SCROLL          = $46;    // Scroll Lock
  DIK_NUMPAD7         = $47;
  DIK_NUMPAD8         = $48;
  DIK_NUMPAD9         = $49;
  DIK_SUBTRACT        = $4A;    // - on numeric keypad
  DIK_NUMPAD4         = $4B;
  DIK_NUMPAD5         = $4C;
  DIK_NUMPAD6         = $4D;
  DIK_ADD             = $4E;    // + on numeric keypad
  DIK_NUMPAD1         = $4F;
  DIK_NUMPAD2         = $50;
  DIK_NUMPAD3         = $51;
  DIK_NUMPAD0         = $52;
  DIK_DECIMAL         = $53;    // . on numeric keypad
  DIK_F11             = $57;
  DIK_F12             = $58;

  DIK_F13             = $64;    //                     (NEC PC98)
  DIK_F14             = $65;    //                     (NEC PC98)
  DIK_F15             = $66;    //                     (NEC PC98)

  DIK_KANA            = $70;    // (Japanese keyboard)
  DIK_CONVERT         = $79;    // (Japanese keyboard)
  DIK_NOCONVERT       = $7B;    // (Japanese keyboard)
  DIK_YEN             = $7D;    // (Japanese keyboard)
  DIK_NUMPADEQUALS    = $8D;    // = on numeric keypad (NEC PC98)
  DIK_CIRCUMFLEX      = $90;    // (Japanese keyboard)
  DIK_AT              = $91;    //                     (NEC PC98)
  DIK_COLON           = $92;    //                     (NEC PC98)
  DIK_UNDERLINE       = $93;    //                     (NEC PC98)
  DIK_KANJI           = $94;    // (Japanese keyboard)
  DIK_STOP            = $95;    //                     (NEC PC98)
  DIK_AX              = $96;    //                     (Japan AX)
  DIK_UNLABELED       = $97;    //                        (J3100)
  DIK_NUMPADENTER     = $9C;    // Enter on numeric keypad
  DIK_RCONTROL        = $9D;
  DIK_NUMPADCOMMA     = $B3;    // , on numeric keypad (NEC PC98)
  DIK_DIVIDE          = $B5;    // / on numeric keypad
  DIK_SYSRQ           = $B7;
  DIK_RMENU           = $B8;    // right Alt
  DIK_HOME            = $C7;    // Home on arrow keypad
  DIK_UP              = $C8;    // UpArrow on arrow keypad
  DIK_PRIOR           = $C9;    // PgUp on arrow keypad
  DIK_LEFT            = $CB;    // LeftArrow on arrow keypad
  DIK_RIGHT           = $CD;    // RightArrow on arrow keypad
  DIK_END             = $CF;    // End on arrow keypad
  DIK_DOWN            = $D0;    // DownArrow on arrow keypad
  DIK_NEXT            = $D1;    // PgDn on arrow keypad
  DIK_INSERT          = $D2;    // Insert on arrow keypad
  DIK_DELETE          = $D3;    // Delete on arrow keypad
  DIK_LWIN            = $DB;    // Left Windows key
  DIK_RWIN            = $DC;    // Right Windows key
  DIK_APPS            = $DD;    // AppMenu key

//
//  Alternate names for keys, to facilitate transition from DOS.
//
  DIK_BACKSPACE       = DIK_BACK;            // backspace
  DIK_NUMPADSTAR      = DIK_MULTIPLY;        // * on numeric keypad
  DIK_LALT            = DIK_LMENU;           // left Alt
  DIK_CAPSLOCK        = DIK_CAPITAL;         // CapsLock
  DIK_NUMPADMINUS     = DIK_SUBTRACT;        // - on numeric keypad
  DIK_NUMPADPLUS      = DIK_ADD;             // + on numeric keypad
  DIK_NUMPADPERIOD    = DIK_DECIMAL;         // . on numeric keypad
  DIK_NUMPADSLASH     = DIK_DIVIDE;          // / on numeric keypad
  DIK_RALT            = DIK_RMENU;           // right Alt
  DIK_UPARROW         = DIK_UP;              // UpArrow on arrow keypad
  DIK_PGUP            = DIK_PRIOR;           // PgUp on arrow keypad
  DIK_LEFTARROW       = DIK_LEFT;            // LeftArrow on arrow keypad
  DIK_RIGHTARROW      = DIK_RIGHT;           // RightArrow on arrow keypad
  DIK_DOWNARROW       = DIK_DOWN;            // DownArrow on arrow keypad
  DIK_PGDN            = DIK_NEXT;            // PgDn on arrow keypad

// Joystick

type
  PDIJoyState = ^TDIJoyState;
  TDIJoyState = packed record
    lX: Longint;                        // x-axis position
    lY: Longint;                        // y-axis position
    lZ: Longint;                        // z-axis position
    lRx: Longint;                       // x-axis rotation
    lRy: Longint;                       // y-axis rotation
    lRz: Longint;                       // z-axis rotation
    rglSlider: array[0..1] of Longint;  // extra axes positions
    rgdwPOV: array[0..3] of DWORD;      // POV directions
    rgbButtons: array[0..31] of BYTE;   // 32 buttons
  end;
  DIJOYSTATE = TDIJoyState;

type
  PDIJOYSTATE2 = ^TDIJoyState2;
  TDIJoyState2 = packed record
    lX: Longint;                        // x-axis position
    lY: Longint;                        // y-axis position
    lZ: Longint;                        // z-axis position
    lRx: Longint;                       // x-axis rotation
    lRy: Longint;                       // y-axis rotation
    lRz: Longint;                       // z-axis rotation
    rglSlider: array[0..1] of Longint;  // extra axes positions
    rgdwPOV: array[0..3] of DWORD;      // POV directions
    rgbButtons: array[0..127] of BYTE;  // 128 buttons
    lVX: Longint;                       // x-axis velocity
    lVY: Longint;                       // y-axis velocity
    lVZ: Longint;                       // z-axis velocity
    lVRx: Longint;                      // x-axis angular velocity
    lVRy: Longint;                      // y-axis angular velocity
    lVRz: Longint;                      // z-axis angular velocity
    rglVSlider: array[0..1] of Longint; // extra axes velocities
    lAX: Longint;                       // x-axis acceleration
    lAY: Longint;                       // y-axis acceleration
    lAZ: Longint;                       // z-axis acceleration
    lARx: Longint;                      // x-axis angular acceleration
    lARy: Longint;                      // y-axis angular acceleration
    lARz: Longint;                      // z-axis angular acceleration
    rglASlider: array[0..1] of Longint; // extra axes accelerations
    lFX: Longint;                       // x-axis force
    lFY: Longint;                       // y-axis force
    lFZ: Longint;                       // z-axis force
    lFRx: Longint;                      // x-axis torque
    lFRy: Longint;                      // y-axis torque
    lFRz: Longint;                      // z-axis torque
    rglFSlider: array[0..1] of Longint; // extra axes forces
  end;

  DIJOYSTATE2 = TDIJoyState2;

const
  DIJOFS_X            = 0;
  DIJOFS_Y            = 4;
  DIJOFS_Z            = 8;
  DIJOFS_RX           = 12;
  DIJOFS_RY           = 16;
  DIJOFS_RZ           = 20;
  DIJOFS_SLIDER       = 24;
  DIJOFS_POV          = 32;
  DIJOFS_BUTTON       = 48;
const
  DIJOFS_BUTTON_ = 48;

const
  DIJOFS_BUTTON0 = DIJOFS_BUTTON_ + 0;
  DIJOFS_BUTTON1 = DIJOFS_BUTTON_ + 1;
  DIJOFS_BUTTON2 = DIJOFS_BUTTON_ + 2;
  DIJOFS_BUTTON3 = DIJOFS_BUTTON_ + 3;
  DIJOFS_BUTTON4 = DIJOFS_BUTTON_ + 4;
  DIJOFS_BUTTON5 = DIJOFS_BUTTON_ + 5;
  DIJOFS_BUTTON6 = DIJOFS_BUTTON_ + 6;
  DIJOFS_BUTTON7 = DIJOFS_BUTTON_ + 7;
  DIJOFS_BUTTON8 = DIJOFS_BUTTON_ + 8;
  DIJOFS_BUTTON9 = DIJOFS_BUTTON_ + 9;
  DIJOFS_BUTTON10 = DIJOFS_BUTTON_ + 10;
  DIJOFS_BUTTON11 = DIJOFS_BUTTON_ + 11;
  DIJOFS_BUTTON12 = DIJOFS_BUTTON_ + 12;
  DIJOFS_BUTTON13 = DIJOFS_BUTTON_ + 13;
  DIJOFS_BUTTON14 = DIJOFS_BUTTON_ + 14;
  DIJOFS_BUTTON15 = DIJOFS_BUTTON_ + 15;
  DIJOFS_BUTTON16 = DIJOFS_BUTTON_ + 16;
  DIJOFS_BUTTON17 = DIJOFS_BUTTON_ + 17;
  DIJOFS_BUTTON18 = DIJOFS_BUTTON_ + 18;
  DIJOFS_BUTTON19 = DIJOFS_BUTTON_ + 19;
  DIJOFS_BUTTON20 = DIJOFS_BUTTON_ + 20;
  DIJOFS_BUTTON21 = DIJOFS_BUTTON_ + 21;
  DIJOFS_BUTTON22 = DIJOFS_BUTTON_ + 22;
  DIJOFS_BUTTON23 = DIJOFS_BUTTON_ + 23;
  DIJOFS_BUTTON24 = DIJOFS_BUTTON_ + 24;
  DIJOFS_BUTTON25 = DIJOFS_BUTTON_ + 25;
  DIJOFS_BUTTON26 = DIJOFS_BUTTON_ + 26;
  DIJOFS_BUTTON27 = DIJOFS_BUTTON_ + 27;
  DIJOFS_BUTTON28 = DIJOFS_BUTTON_ + 28;
  DIJOFS_BUTTON29 = DIJOFS_BUTTON_ + 29;
  DIJOFS_BUTTON30 = DIJOFS_BUTTON_ + 30;
  DIJOFS_BUTTON31 = DIJOFS_BUTTON_ + 31;


// IDirectInput

const
  DIENUM_STOP = 0;
  DIENUM_CONTINUE = 1;

const
  _c_dfDIJoystick_Objects: array[0..43] of TDIObjectDataFormat = (
    (  pguid: @GUID_XAxis;
       dwOfs: DIJOFS_X; dwType: $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION; dwFlags: $100),
    (  pguid: @GUID_YAxis;
       dwOfs: DIJOFS_Y; dwType: $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION; dwFlags: $100),
    (  pguid: @GUID_ZAxis;
       dwOfs: DIJOFS_Z; dwType: $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION; dwFlags: $100),
    (  pguid: @GUID_RxAxis;
       dwOfs: DIJOFS_RX; dwType: $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION; dwFlags: $100),
    (  pguid: @GUID_RyAxis;
       dwOfs: DIJOFS_RY; dwType: $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION; dwFlags: $100),
    (  pguid: @GUID_RzAxis;
       dwOfs: DIJOFS_RZ; dwType: $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION; dwFlags: $100),

    (  pguid: @GUID_Slider;  // 2 Sliders
       dwOfs: 24; dwType: $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION; dwFlags: $100),
    (  pguid: @GUID_Slider;
       dwOfs: 28; dwType: $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION; dwFlags: $100),

    (  pguid: @GUID_POV;  // 4 POVs (yes, really)
       dwOfs: 32; dwType: $80000000 or DIDFT_POV or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: @GUID_POV;
       dwOfs: 36; dwType: $80000000 or DIDFT_POV or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: @GUID_POV;
       dwOfs: 40; dwType: $80000000 or DIDFT_POV or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: @GUID_POV;
       dwOfs: 44; dwType: $80000000 or DIDFT_POV or DIDFT_NOCOLLECTION; dwFlags: 0),

    (  pguid: nil;   // Buttons
       dwOfs: DIJOFS_BUTTON0; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON1; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON2; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON3; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON4; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON5; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON6; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON7; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON8; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON9; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON10; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON11; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON12; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON13; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON14; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON15; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON16; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON17; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON18; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON19; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON20; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON21; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON22; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON23; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON24; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON25; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON26; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON27; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON28; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON29; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON30; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIJOFS_BUTTON31; dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION; dwFlags: 0)
  );

  c_dfDIJoystick: TDIDataFormat = (
    dwSize: SizeOf(c_dfDIJoystick);
    dwObjSize: SizeOf(TDIObjectDataFormat);      // $10
    dwFlags: DIDF_ABSAXIS;
    dwDataSize: SizeOf(TDIJoyState);             // $10
    dwNumObjs: High(_c_dfDIJoystick_Objects)+1;  // $2C
    rgodf: @_c_dfDIJoystick_Objects
  );

type
  TDIEnumDevicesCallbackA = function conv arg_stdcall (var lpddi: TDIDeviceInstanceA;
      pvRef: Pointer): HResult;
  LPDIENUMDEVICESCALLBACKA = TDIEnumDevicesCallbackA;

  TDIEnumDevicesCallbackW = function conv arg_stdcall (var lpddi: TDIDeviceInstanceW;
      pvRef: Pointer): HResult;
  LPDIENUMDEVICESCALLBACKW = TDIEnumDevicesCallbackW;

  TDIEnumDevicesCallback = TDIEnumDevicesCallbackA;
  LPDIENUMDEVICESCALLBACK = TDIEnumDevicesCallback;

const
  DIEDFL_ALLDEVICES    = $00000000;
  DIEDFL_ATTACHEDONLY  = $00000001;
  DIEDFL_FORCEFEEDBACK = $00000100;

type
  PPDirectInput = ^^IDirectInput;
  IDirectInput = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectInput methods ***)
    CreateDevice: function conv arg_stdcall (Self: Pointer; const rguid: TGUID;
        var lplpDirectInputDevice: Pointer; pUnkOuter: PPUnknown): HResult;
    EnumDevices: function conv arg_stdcall (Self: Pointer; dwDevType: DWORD; lpCallback: TDIEnumDevicesCallbackA;
        pvRef: Pointer; dwFlags: DWORD): HResult;
    GetDeviceStatus: function conv arg_stdcall (Self: Pointer; const rguidInstance: TGUID): HResult;
    RunControlPanel: function conv arg_stdcall (Self: Pointer; hwndOwner: HWND; dwFlags: DWORD): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; hinst: THandle; dwVersion: DWORD): HResult;
  end;

  PPDirectInput2 = ^^IDirectInput2;
  IDirectInput2 = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectInput2 methods ***)
    CreateDevice: function conv arg_stdcall (Self: Pointer; const rguid: TGUID;
        var lplpDirectInputDevice: Pointer; pUnkOuter: PPUnknown): HResult;
    EnumDevices: function conv arg_stdcall (Self: Pointer; dwDevType: DWORD; lpCallback: TDIEnumDevicesCallbackA;
        pvRef: Pointer; dwFlags: DWORD): HResult;
    GetDeviceStatus: function conv arg_stdcall (Self: Pointer; const rguidInstance: TGUID): HResult;
    RunControlPanel: function conv arg_stdcall (Self: Pointer; hwndOwner: HWND; dwFlags: DWORD): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; hinst: THandle; dwVersion: DWORD): HResult;
    // IDirectInput2A methods
    FindDevice: function conv arg_stdcall (Self: Pointer; Arg1: PGUID; Arg2: PAnsiChar; Arg3: PGUID): HResult;
  end;

  PPDirectInput7 = ^^IDirectInput7;
  IDirectInput7 = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectInput2 methods ***)
    CreateDevice: function conv arg_stdcall (Self: Pointer; const rguid: TGUID;
        var lplpDirectInputDevice: Pointer; pUnkOuter: PPUnknown): HResult;
    EnumDevices: function conv arg_stdcall (Self: Pointer; dwDevType: DWORD; lpCallback: TDIEnumDevicesCallbackA;
        pvRef: Pointer; dwFlags: DWORD): HResult;
    GetDeviceStatus: function conv arg_stdcall (Self: Pointer; const rguidInstance: TGUID): HResult;
    RunControlPanel: function conv arg_stdcall (Self: Pointer; hwndOwner: HWND; dwFlags: DWORD): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; hinst: THandle; dwVersion: DWORD): HResult;
    // IDirectInput2A methods
    FindDevice: function conv arg_stdcall (Self: Pointer; Arg1: PGUID; Arg2: PAnsiChar; Arg3: PGUID): HResult;
    // IDirectInput7A methods
    CreateDeviceEx: function conv arg_stdcall (Self: Pointer; rguid: TGUID; riid: TRefIID; pvOut: Pointer; pUnkOuter: PPUnknown): HResult;
  end;

// Return Codes

const
  DI_OK                         = HResult(S_OK);
  DI_NOTATTACHED                = HResult(S_FALSE);
  DI_BUFFEROVERFLOW             = HResult(S_FALSE);
  DI_PROPNOEFFECT               = HResult(S_FALSE);
  DI_NOEFFECT                   = HResult(S_FALSE);
  DI_POLLEDDEVICE               = HResult($00000002);
  DI_DOWNLOADSKIPPED            = HResult($00000003);
  DI_EFFECTRESTARTED            = HResult($00000004);
  DI_TRUNCATED                  = HResult($00000008);
  DI_TRUNCATEDANDRESTARTED      = HResult($0000000C);

  DIERR_OLDDIRECTINPUTVERSION   = HResult($8007047E);
  DIERR_BETADIRECTINPUTVERSION  = HResult($80070481);
  DIERR_BADDRIVERVER            = HResult($80070077);
  DIERR_DEVICENOTREG            = HResult(REGDB_E_CLASSNOTREG);
  DIERR_NOTFOUND                = HResult($80070002);
  DIERR_OBJECTNOTFOUND          = HResult($80070002);
  DIERR_INVALIDPARAM            = HResult(E_INVALIDARG);
  DIERR_NOINTERFACE             = HResult(E_NOINTERFACE);
  DIERR_GENERIC                 = HResult(E_FAIL);
  DIERR_OUTOFMEMORY             = HResult(E_OUTOFMEMORY);
  DIERR_UNSUPPORTED             = HResult(E_NOTIMPL);
  DIERR_NOTINITIALIZED          = HResult($80070015);
  DIERR_ALREADYINITIALIZED      = HResult($800704DF);
  DIERR_NOAGGREGATION           = HResult(CLASS_E_NOAGGREGATION);
  DIERR_OTHERAPPHASPRIO         = HResult(E_ACCESSDENIED);
  DIERR_INPUTLOST               = HResult($8007001E);
  DIERR_ACQUIRED                = HResult($800700AA);
  DIERR_NOTACQUIRED             = HResult($8007000C);
  DIERR_READONLY                = HResult(E_ACCESSDENIED);
  DIERR_HANDLEEXISTS            = HResult(E_ACCESSDENIED);
  DIERR_PENDING                 = HResult($80070007);
  DIERR_INSUFFICIENTPRIVS       = HResult($80040200);
  DIERR_DEVICEFULL              = HResult($80040201);
  DIERR_MOREDATA                = HResult($80040202);
  DIERR_NOTDOWNLOADED           = HResult($80040203);
  DIERR_HASEFFECTS              = HResult($80040204);
  DIERR_NOTEXCLUSIVEACQUIRED    = HResult($80040205);
  DIERR_INCOMPLETEEFFECT        = HResult($80040206);
  DIERR_NOTBUFFERED             = HResult($80040207);
  DIERR_EFFECTPLAYING           = HResult($80040208);

// Definitions for non-IDirectInput (VJoyD) features defined more recently
//  than the current sdk files

  JOY_PASSDRIVERDATA = $10000000;
  JOY_HWS_ISHEADTRACKER = $02000000;
  JOY_HWS_ISGAMEPORTDRIVER = $04000000;
  JOY_HWS_ISANALOGPORTDRIVER = $08000000;
  JOY_HWS_AUTOLOAD = $10000000;
  JOY_HWS_NODEVNODE = $20000000;
  JOY_HWS_ISGAMEPORTEMULATOR = $40000000;
  JOY_US_VOLATILE = $00000008;
  JOY_OEMPOLL_PASSDRIVERDATA = 7;

function DirectInputCreate conv arg_stdcall (hinst: THandle; dwVersion: DWORD; var ppDI: PPDirectInput; punkOuter: PPUnknown): HResult;
  external 'dinput.dll' name 'DirectInputCreateA';

function DirectInputCreateEx conv arg_stdcall (hinst: THandle; dwVersion: DWORD; riidlt: TREfIID; ppvOut: Pointer; punkOuter: PPUnknown): HResult;
  external 'dinput.dll' name 'DirectInputCreateEx';

function MAKE_DSHRESULT(code: DWORD): HResult;
function DIErrorString(Value: HResult): String;

var
  _c_dfDIJoystick2_Objects: array[0..$A3] of TDIObjectDataFormat;


(********************** DirectDrawVideoPort Section *************************)

const
  IID_IDDVideoPortContainer: TGUID =
    (D1:$6C142760;D2:$A733;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectDrawVideoPort: TGUID =
    (D1:$B36D93E0;D2:$2B43;D3:$11CF;D4:($A2,$DE,$00,$AA,$00,$B9,$33,$56));
  DDVPTYPE_E_HREFH_VREFH: TGUID =
    (D1:$54F39980;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  DDVPTYPE_E_HREFH_VREFL: TGUID =
    (D1:$92783220;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  DDVPTYPE_E_HREFL_VREFH: TGUID =
    (D1:$A07A02E0;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  DDVPTYPE_E_HREFL_VREFL: TGUID =
    (D1:$E09C77E0;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  DDVPTYPE_CCIR656: TGUID =
    (D1:$FCA326A0;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  DDVPTYPE_BROOKTREE: TGUID =
    (D1:$1352A560;D2:$DA61;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  DDVPTYPE_PHILIPS: TGUID =
    (D1:$332CF160;D2:$DA61;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));

// TDDVideoportConnect structure

type
  PDDVideoportConnect = ^TDDVideoportConnect;
  TDDVideoportConnect = packed record
    dwSize: DWORD;        // size of the TDDVideoportConnect structure
    dwPortWidth: DWORD;   // Width of the video port
    guidTypeID: TGUID;    // Description of video port connection
    dwFlags: DWORD;       // Connection flags
    dwReserved1: DWORD;   // Reserved, set to zero.
  end;

  DDVIDEOPORTCONNECT = TDDVideoportConnect;
  LPDDVIDEOPORTCONNECT = PDDVideoportConnect;

{ TDDVideoportCaps structure }

  PDDVideoportCaps = ^TDDVideoportCaps;
  TDDVideoportCaps = packed record
    dwSize: DWORD;                          // size of the TDDVideoportCaps structure
    dwFlags: DWORD;                         // indicates which fields contain data
    dwMaxWidth: DWORD;                      // max width of the video port field
    dwMaxVBIWidth: DWORD;                   // max width of the VBI data
    dwMaxHeight: DWORD;                     // max height of the video port field
    dwVideoPortID: DWORD;                   // Video port ID (0 - (dwMaxVideoPorts -1))
    dwCaps: DWORD;                          // Video port capabilities
    dwFX: DWORD;                            // More video port capabilities
    dwNumAutoFlipSurfaces: DWORD;           // Number of autoflippable surfaces
    dwAlignVideoPortBoundary: DWORD;        // Byte restriction of placement within the surface
    dwAlignVideoPortPrescaleWidth: DWORD;   // Byte restriction of width after prescaling
    dwAlignVideoPortCropBoundary: DWORD;    // Byte restriction of left cropping
    dwAlignVideoPortCropWidth: DWORD;       // Byte restriction of cropping width
    dwPreshrinkXStep: DWORD;                // Width can be shrunk in steps of 1/x
    dwPreshrinkYStep: DWORD;                // Height can be shrunk in steps of 1/x
    dwNumVBIAutoFlipSurfaces: DWORD;        // Number of VBI autoflippable surfaces
    dwNumPreferredAutoflip: DWORD;          // Optimal number of autoflippable surfaces for hardware
    wNumFilterTapsX: WORD;                  // Number of taps the prescaler uses in the X direction (0 - no prescale, 1 - replication, etc.)
    wNumFilterTapsY: WORD;                  // Number of taps the prescaler uses in the Y direction (0 - no prescale, 1 - replication, etc.)
  end;

  DDVIDEOPORTCAPS = TDDVideoportCaps;
  LPDDVIDEOPORTCAPS = PDDVideoportCaps;

{ TDDVideoportDesc structure }

  PDDVideoportDesc = ^TDDVideoportDesc;
  TDDVideoportDesc = packed record
    dwSize: DWORD;                       // size of the TDDVideoportDesc structure
    dwFieldWidth: DWORD;                 // width of the video port field
    dwVBIWidth: DWORD;                   // width of the VBI data
    dwFieldHeight: DWORD;                // height of the video port field
    dwMicrosecondsPerField: DWORD;       // Microseconds per video field
    dwMaxPixelsPerSecond: DWORD;         // Maximum pixel rate per second
    dwVideoPortID: DWORD;                // Video port ID (0 - (dwMaxVideoPorts -1))
    dwReserved1: DWORD;                  // Reserved for future use - set to zero
    VideoPortType: TDDVideoportConnect;   // Description of video port connection
    dwReserved2: DWORD;                  // Reserved for future use - set to zero
    dwReserved3: DWORD;                  // Reserved for future use - set to zero
  end;

  DDVIDEOPORTDESC = TDDVideoportDesc;
  LPDDVIDEOPORTDESC = PDDVideoportDesc;

{ TDDVideoportInfo structure }

  PDDVideoportInfo = ^TDDVideoportInfo;
  TDDVideoportInfo = packed record
    dwSize: DWORD;                            // Size of the structure
    dwOriginX: DWORD;                         // Placement of the video data within the surface.
    dwOriginY: DWORD;                         // Placement of the video data within the surface.
    dwVPFlags: DWORD;                         // Video port options
    rCrop: TRect;                             // Cropping rectangle (optional).
    dwPrescaleWidth: DWORD;                   // Determines pre-scaling/zooming in the X direction (optional).
    dwPrescaleHeight: DWORD;                  // Determines pre-scaling/zooming in the Y direction (optional).
    lpddpfInputFormat: PDDPixelFormat;        // Video format written to the video port
    lpddpfVBIInputFormat: PDDPixelFormat;     // Input format of the VBI data
    lpddpfVBIOutputFormat: PDDPixelFormat;    // Output format of the data
    dwVBIHeight: DWORD;                       // Specifies the number of lines of data within the vertical blanking interval.
    dwReserved1: DWORD;                       // Reserved for future use - set to zero
    dwReserved2: DWORD;                       // Reserved for future use - set to zero
  end;

  DDVIDEOPORTINFO = TDDVideoportInfo;
  LPDDVIDEOPORTINFO = PDDVideoportInfo;

{ TDDVideoportBandWidth structure }

  PDDVideoportBandWidth = ^TDDVideoportBandWidth;
  TDDVideoportBandWidth = packed record
    dwSize: DWORD;                 // Size of the structure
    dwCaps: DWORD;
    dwOverlay: DWORD;              // Zoom factor at which overlay is supported
    dwColorkey: DWORD;             // Zoom factor at which overlay w/ colorkey is supported
    dwYInterpolate: DWORD;         // Zoom factor at which overlay w/ Y interpolation is supported
    dwYInterpAndColorkey: DWORD;   // Zoom factor at which ovelray w/ Y interpolation and colorkeying is supported
    dwReserved1: DWORD;            // Reserved for future use - set to zero
    dwReserved2: DWORD;            // Reserved for future use - set to zero
  end;

  DDVIDEOPORTBANDWIDTH = TDDVideoportBandWidth;
  LPDDVIDEOPORTBANDWIDTH = PDDVideoportBandWidth;

{ TDDVideoportStatus structure }

  PDDVideoportStatus = ^TDDVideoportStatus;
  TDDVideoportStatus = packed record
    dwSize: DWORD;                       // Size of the structure
    bInUse: BOOL;                        // TRUE if video port is currently being used
    dwFlags: DWORD;                      // Currently not used
    dwReserved1: DWORD;                  // Reserved for future use
    VideoPortType: TDDVideoportConnect;   // Information about the connection
    dwReserved2: DWORD;                  // Reserved for future use
    dwReserved3: DWORD;                  // Reserved for future use
  end;

  DDVIDEOPORTSTATUS = TDDVideoportStatus;
  LPDDVIDEOPORTSTATUS = PDDVideoportStatus;

  TDDEnumVideoCallback = function conv arg_stdcall (const lpDDVideoPortCaps: TDDVideoportCaps;
      lpContext: Pointer): HResult;
  LPDDENUMVIDEOCALLBACK = TDDEnumVideoCallback;

  PPDDVideoPortContainer = ^^IDDVideoPortContainer;
  IDDVideoPortContainer = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDDVideoPortContainer methods ***)
    CreateVideoPort: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; const lpDDVideoPortDesc:
        TDDVideoportDesc; var lplpDDVideoPort: Pointer;
        pUnkOuter: PPUnknown): HResult;
    EnumVideoPorts: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD;
        const lpDDVideoPortCaps: TDDVideoportCaps; lpContext: Pointer;
        lpEnumVideoCallback: TDDEnumVideoCallback): HResult;
    GetVideoPortConnectInfo: function conv arg_stdcall (Self: Pointer; dwPortId: DWORD; var lpNumEntries: DWORD;
        var lpConnectInfo: TDDVideoportConnect): HResult;
    QueryVideoPortStatus: function conv arg_stdcall (Self: Pointer; dwPortId: DWORD;
        var lpVPStatus: TDDVideoportStatus): HResult;
  end;

  PDDColorControl = ^TDDColorControl;
  TDDColorControl = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    lBrightness: Longint;
    lContrast: Longint;
    lHue: Longint;
    lSaturation: Longint;
    lSharpness: Longint;
    lGamma: Longint;
    lColorEnable: Longint;
    dwReserved1: DWORD;
  end;

  DDCOLORCONTROL = TDDColorControl;
  LPDDCOLORCONTROL = PDDCOLORCONTROL;

{ TDDGammaRamp structure }

  PDDGammaRamp = ^TDDGammaRamp;
  TDDGammaRamp = packed record
    Red: array[0..255] of Word;
    Green: array[0..255] of Word;
    Blue: array[0..255] of Word;
  end;

  DDGAMMARAMP = TDDGammaRamp;
  LPDDGAMMARAMP = PDDGammaRamp;

{ TDDDeviceIdentifier structure }

  PDDDeviceIdentifier = ^TDDDeviceIdentifier;
  TDDDeviceIdentifier = packed record
    //
    // These elements are for presentation to the user only. They should not be used to identify particular
    // drivers, since this is unreliable and many different strings may be associated with the same
    // device, and the same driver from different vendors.
    //
    szDriver: array[0..MAX_DDDEVICEID_STRING-1] of Char;
    szDescription: array[0..MAX_DDDEVICEID_STRING-1] of Char;

    //
    // This element is the version of the DirectDraw/3D driver. It is legal to do <, > comparisons
    // on the whole 64 bits. Caution should be exercised if you use this element to identify problematic
    // drivers. It is recommended that guidDeviceIdentifier is used for this purpose.
    //
    // This version has the form:
    //  wProduct = HIWORD(liDriverVersion.HighPart)
    //  wVersion = LOWORD(liDriverVersion.HighPart)
    //  wSubVersion = HIWORD(liDriverVersion.LowPart)
    //  wBuild = LOWORD(liDriverVersion.LowPart)
    //
    liDriverVersion: TLargeInteger;     // Defined for applications and other 32 bit components

    //
    // These elements can be used to identify particular chipsets. Use with extreme caution.
    //   dwVendorId     Identifies the manufacturer. May be zero if unknown.
    //   dwDeviceId     Identifies the type of chipset. May be zero if unknown.
    //   dwSubSysId     Identifies the subsystem, typically this means the particular board. May be zero if unknown.
    //   dwRevision     Identifies the revision level of the chipset. May be zero if unknown.
    //
    dwVendorId: DWORD;
    dwDeviceId: DWORD;
    dwSubSysId: DWORD;
    dwRevision: DWORD;

    //
    // This element can be used to check changes in driver/chipset. This GUID is a unique identifier for the
    // driver/chipset pair. Use this element if you wish to track changes to the driver/chipset in order to
    // reprofile the graphics subsystem.
    // This element can also be used to identify particular problematic drivers.
    //
    guidDeviceIdentifier: TGUID;
  end;

  DDDEVICEIDENTIFIER = TDDDeviceIdentifier;
  LPDDDEVICEIDENTIFIER = PDDDeviceIdentifier;


  PPDirectDrawVideoPort = ^^IDirectDrawVideoPort;
  IDirectDrawVideoPort = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDDVideoPortContainer methods ***)
    Flip: function conv arg_stdcall (Self: Pointer; lpDDSurface: IDirectDrawSurface; dwFlags: DWORD): HResult;
    GetBandwidthInfo: function conv arg_stdcall (Self: Pointer; const lpddpfFormat: TDDPixelFormat; dwWidth: DWORD;
        dwHeight: DWORD; dwFlags: DWORD; var lpBandwidth: TDDVideoportBandWidth): HResult;
    GetColorControls: function conv arg_stdcall (Self: Pointer; var lpColorControl: TDDColorControl): HResult;
    GetInputFormats: function conv arg_stdcall (Self: Pointer; var lpNumFormats: DWORD; var lpFormats:
        TDDPixelFormat; dwFlags: DWORD): HResult;
    GetOutputFormats: function conv arg_stdcall (Self: Pointer; const lpInputFormat: TDDPixelFormat;
        var lpNumFormats: DWORD; var lpFormats: TDDPixelFormat; dwFlags: DWORD): HResult;
    GetFieldPolarity: function conv arg_stdcall (Self: Pointer; var lpbVideoField: BOOL): HResult;
    GetVideoLine: function conv arg_stdcall (Self: Pointer; var lpdwLine: DWORD): HResult;
    GetVideoSignalStatus: function conv arg_stdcall (Self: Pointer; varlpdwStatus: DWORD): HResult;
    SetColorControls: function conv arg_stdcall (Self: Pointer; const lpColorControl: TDDColorControl): HResult;
    SetTargetSurface: function conv arg_stdcall (Self: Pointer; lpDDSurface: IDirectDrawSurface; dwFlags: DWORD): HResult;
    StartVideo: function conv arg_stdcall (Self: Pointer; const lpVideoInfo: TDDVideoportInfo): HResult;
    StopVideo: function conv arg_stdcall (Self: Pointer): HResult;
    UpdateVideo: function conv arg_stdcall (Self: Pointer; const lpVideoInfo: TDDVideoportInfo): HResult;
    WaitForSync: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; dwLine: DWORD; dwTimeout: DWORD): HResult;
  end;


const
{ Video Port Flags }

  DDVPD_WIDTH             = $00000001;
  DDVPD_HEIGHT            = $00000002;
  DDVPD_ID                = $00000004;
  DDVPD_CAPS              = $00000008;
  DDVPD_FX                = $00000010;
  DDVPD_AUTOFLIP          = $00000020;
  DDVPD_ALIGN             = $00000040;
  DDVPD_PREFERREDAUTOFLIP = $00000080;
  DDVPD_FILTERQUALITY     = $00000100;

{ TDDVideoportConnect flags }

  DDVPCONNECT_DOUBLECLOCK      = $00000001;
  DDVPCONNECT_VACT             = $00000002;
  DDVPCONNECT_INVERTPOLARITY   = $00000004;
  DDVPCONNECT_DISCARDSVREFDATA = $00000008;
  DDVPCONNECT_HALFLINE         = $00000010;
  DDVPCONNECT_INTERLACED       = $00000020;
  DDVPCONNECT_SHAREEVEN        = $00000040;
  DDVPCONNECT_SHAREODD         = $00000080;

{ TDDVideoportDesc caps }

  DDVPCAPS_AUTOFLIP               = $00000001;
  DDVPCAPS_INTERLACED             = $00000002;
  DDVPCAPS_NONINTERLACED          = $00000004;
  DDVPCAPS_READBACKFIELD          = $00000008;
  DDVPCAPS_READBACKLINE           = $00000010;
  DDVPCAPS_SHAREABLE              = $00000020;
  DDVPCAPS_SKIPEVENFIELDS         = $00000040;
  DDVPCAPS_SKIPODDFIELDS          = $00000080;
  DDVPCAPS_SYNCMASTER             = $00000100;
  DDVPCAPS_VBISURFACE             = $00000200;
  DDVPCAPS_COLORCONTROL           = $00000400;
  DDVPCAPS_OVERSAMPLEDVBI         = $00000800;
  DDVPCAPS_SYSTEMMEMORY           = $00001000;
  DDVPCAPS_VBIANDVIDEOINDEPENDENT = $00002000;
  DDVPCAPS_HARDWAREDEINTERLACE    = $00004000;

{ TDDVideoportDesc FX }

  DDVPFX_CROPTOPDATA     = $00000001;
  DDVPFX_CROPX           = $00000002;
  DDVPFX_CROPY           = $00000004;
  DDVPFX_INTERLEAVE      = $00000008;
  DDVPFX_MIRRORLEFTRIGHT = $00000010;
  DDVPFX_MIRRORUPDOWN    = $00000020;
  DDVPFX_PRESHRINKX      = $00000040;
  DDVPFX_PRESHRINKY      = $00000080;
  DDVPFX_PRESHRINKXB     = $00000100;
  DDVPFX_PRESHRINKYB     = $00000200;
  DDVPFX_PRESHRINKXS     = $00000400;
  DDVPFX_PRESHRINKYS     = $00000800;
  DDVPFX_PRESTRETCHX     = $00001000;
  DDVPFX_PRESTRETCHY     = $00002000;
  DDVPFX_PRESTRETCHXN    = $00004000;
  DDVPFX_PRESTRETCHYN    = $00008000;
  DDVPFX_VBICONVERT      = $00010000;
  DDVPFX_VBINOSCALE      = $00020000;
  DDVPFX_IGNOREVBIXCROP  = $00040000;
  DDVPFX_VBINOINTERLEAVE = $00080000;

{ TDDVideoportInfo flags }

  DDVP_AUTOFLIP            = $00000001;
  DDVP_CONVERT             = $00000002;
  DDVP_CROP                = $00000004;
  DDVP_INTERLEAVE          = $00000008;
  DDVP_MIRRORLEFTRIGHT     = $00000010;
  DDVP_MIRRORUPDOWN        = $00000020;
  DDVP_PRESCALE            = $00000040;
  DDVP_SKIPEVENFIELDS      = $00000080;
  DDVP_SKIPODDFIELDS       = $00000100;
  DDVP_SYNCMASTER          = $00000200;
  DDVP_VBICONVERT          = $00000400;
  DDVP_VBINOSCALE          = $00000800;
  DDVP_OVERRIDEBOBWEAVE    = $00001000;
  DDVP_IGNOREVBIXCROP      = $00002000;
  DDVP_HARDWAREDEINTERLACE = $00008000;

{ DirectDrawVideoport GetInputFormat/GetOutputFormat flags }

  DDVPFORMAT_VIDEO = $00000001;
  DDVPFORMAT_VBI = $00000002;

{ DirectDrawVideoport SetTargetSurface flags }

  DDVPTARGET_VIDEO = $00000001;
  DDVPTARGET_VBI = $00000002;

{ DirectDrawVideoport WaitForSync flags }

  DDVPWAIT_BEGIN = $00000001;
  DDVPWAIT_END = $00000002;
  DDVPWAIT_LINE = $00000003;

{ DirectDrawVideoport flip flags }

  DDVPFLIP_VIDEO = $00000001;
  DDVPFLIP_VBI = $00000002;

{ DirectDrawVideoport GetVideoSiginalStatus values }

  DDVPSQ_NOSIGNAL = $00000001;
  DDVPSQ_SIGNALOK = $00000002;

{ TDDVideoportBandWidth Flags }

  DDVPB_VIDEOPORT = $00000001;
  DDVPB_OVERLAY = $00000002;
  DDVPB_TYPE = $00000004;

{ TDDVideoportBandWidth Caps }

  DDVPBCAPS_SOURCE = $00000001;
  DDVPBCAPS_DESTINATION = $00000002;

{ IDDVideoportContainer.CreateVideoPort flags }

  DDVPCREATE_VBIONLY   = $00000001;
  DDVPCREATE_VIDEOONLY = $00000002;

{ TDDVideoportStatus flags }

  DDVPSTATUS_VBIONLY   = $00000001;
  DDVPSTATUS_VIDEOONLY = $00000002;

(************************ DirectX File Section *******************************)

const
  CLSID_CDirectXFile: TGUID =
    (D1:$4516EC43;D2:$8F20;D3:$11D0;D4:($9B,$6D,$00,$00,$C0,$78,$1B,$C3));
  IID_IDirectXFile: TGUID =
    (D1:$3D82AB40;D2:$62DA;D3:$11CF;D4:($AB,$39,$00,$20,$AF,$71,$E4,$33));
  IID_IDirectXFileEnumObject: TGUID =
    (D1:$3D82AB41;D2:$62DA;D3:$11CF;D4:($AB,$39,$00,$20,$AF,$71,$E4,$33));
  IID_IDirectXFileSaveObject: TGUID =
    (D1:$3D82AB42;D2:$62DA;D3:$11CF;D4:($AB,$39,$00,$20,$AF,$71,$E4,$33));
  IID_IDirectXFileObject: TGUID =
    (D1:$3D82AB43;D2:$62DA;D3:$11CF;D4:($AB,$39,$00,$20,$AF,$71,$E4,$33));
  IID_IDirectXFileData: TGUID =
    (D1:$3D82AB44;D2:$62DA;D3:$11CF;D4:($AB,$39,$00,$20,$AF,$71,$E4,$33));
  IID_IDirectXFileDataReference: TGUID =
    (D1:$3D82AB45;D2:$62DA;D3:$11CF;D4:($AB,$39,$00,$20,$AF,$71,$E4,$33));
  IID_IDirectXFileBinary: TGUID =
    (D1:$3D82AB46;D2:$62DA;D3:$11CF;D4:($AB,$39,$00,$20,$AF,$71,$E4,$33));

type
  TDXFileFormat = DWORD;
  DXFILEFORMAT = TDXFileFormat;

const
  DXFILEFORMAT_BINARY     = 0;
  DXFILEFORMAT_TEXT       = 1;
  DXFILEFORMAT_COMPRESSED = 2;

type
  TDXFileLoadOptions = DWORD;
  DXFILELOADOPTIONS = TDXFileLoadOptions;

const
  DXFILELOAD_FROMFILE     = $00;
  DXFILELOAD_FROMRESOURCE = $01;
  DXFILELOAD_FROMMEMORY   = $02;
  DXFILELOAD_FROMSTREAM   = $04;
  DXFILELOAD_FROMURL      = $08;

type
  PDXFileLoadResource = ^TDXFileLoadResource;
  TDXFileLoadResource = packed record
    hModule: HModule;
    lpName: PChar;
    lpType: PChar;
  end;

  DXFILELOADRESOURCE = TDXFileLoadResource;
  LPDXFILELOADRESOURCE = PDXFileLoadResource;

  PDXFileLoadMemory = ^TDXFileLoadMemory;
  TDXFileLoadMemory = packed record
    lpMemory: Pointer;
    dSize: DWORD;
  end;

  DXFILELOADMEMORY = TDXFileLoadMemory;
  LPDXFILELOADMEMORY = PDXFileLoadMemory;

type
  PPDirectXFile = ^^IDirectXFile;
  IDirectXFile = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectXFile methods ***)
    CreateEnumObject: function conv arg_stdcall (Self: Pointer; pvSource: Pointer; dwLoadOptions: TDXFileLoadOptions;
        var ppEnumObj: Pointer): HResult;
    CreateSaveObject: function conv arg_stdcall (Self: Pointer; szFileName: PChar; dwFileFormat: TDXFileFormat;
        var ppSaveObj: Pointer): HResult;
    RegisterTemplates: function conv arg_stdcall (Self: Pointer; pvData: Pointer; cbSize: DWORD): HResult;
  end;

  PPDirectXFileEnumObject = ^^IDirectXFileEnumObject;
  IDirectXFileEnumObject = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectXFileEnumObject methods ***)
    GetNextDataObject: function conv arg_stdcall (Self: Pointer; var ppDataObj: Pointer): HResult;
    GetDataObjectById: function conv arg_stdcall (Self: Pointer; const rguid: TGUID; var ppDataObj: Pointer): HResult;
    GetDataObjectByName: function conv arg_stdcall (Self: Pointer; szName: PChar; var ppDataObj: Pointer): HResult;
  end;

  PPDirectXFileSaveObject = ^^IDirectXFileSaveObject;
  IDirectXFileSaveObject = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectXFileSaveObject methods ***)
    SaveTemplates: function conv arg_stdcall (Self: Pointer; cTemplates: DWORD; var ppguidTemplates: PGUID): HResult;
    CreateDataObject: function conv arg_stdcall (Self: Pointer; const rguidTemplate: TGUID; szName: PChar;
        const pguid: TGUID; cbSize: DWORD; pvData: Pointer;
        var ppDataObj: Pointer): HResult;
    SaveData: function conv arg_stdcall (Self: Pointer; pDataObj: Pointer): HResult;
  end;

  PPDirectXFileObject = ^^IDirectXFileObject;
  IDirectXFileObject = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectXFileObject methods ***)
    GetName: function conv arg_stdcall (Self: Pointer; pstrNameBuf: PChar; var dwBufLen: DWORD): HResult;
    GetId: function conv arg_stdcall (Self: Pointer; var pGuidBuf: TGUID): HResult;
  end;

  PPDirectXFileData = ^^IDirectXFileData;
  IDirectXFileData = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectXFileObject methods ***)
    GetName: function conv arg_stdcall (Self: Pointer; pstrNameBuf: PChar; var dwBufLen: DWORD): HResult;
    GetId: function conv arg_stdcall (Self: Pointer; var pGuidBuf: TGUID): HResult;
    (*** IDirectXFileData methods ***)
    GetData: function conv arg_stdcall (Self: Pointer; szMember: PChar; var pcbSize: DWORD; var ppvData: Pointer): HResult;
    GetType: function conv arg_stdcall (Self: Pointer; var ppguid: PGUID): HResult;
    GetNextObject: function conv arg_stdcall (Self: Pointer; var ppChildObj: PPDirectXFileObject): HResult;
    AddDataObject: function conv arg_stdcall (Self: Pointer; pDataObj: IDirectXFileData): HResult;
    AddDataReference: function conv arg_stdcall (Self: Pointer; szRef: PChar; pguidRef: PGUID): HResult;
    AddBinaryObjec: function conv arg_stdcall (Self: Pointer; szName: PChar; pguid: PGUID; szMimeType: PChar; pvData: Pointer; cbSize: DWORD): HResult;
  end;

  PPDirectXFileDataReference = ^^IDirectXFileDataReference;
  IDirectXFileDataReference = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectXFileObject methods ***)
    GetName: function conv arg_stdcall (Self: Pointer; pstrNameBuf: PChar; var dwBufLen: DWORD): HResult;
    GetId: function conv arg_stdcall (Self: Pointer; var pGuidBuf: TGUID): HResult;
    (*** IDirectXFileDataReference methods ***)
    Resolve: function conv arg_stdcall (Self: Pointer; var ppDataObj: IDirectXFileData): HResult;
  end;

  PPDirectXFileBinary = ^^IDirectXFileBinary;
  IDirectXFileBinary = packed record
    (*** IUnknown methods ***)
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    (*** IDirectXFileObject methods ***)
    GetName: function conv arg_stdcall (Self: Pointer; pstrNameBuf: PChar; var dwBufLen: DWORD): HResult;
    GetId: function conv arg_stdcall (Self: Pointer; var pGuidBuf: TGUID): HResult;
    (*** IDirectXFileBinary methods ***)
    GetSize: function conv arg_stdcall (Self: Pointer; var pcbSize: DWORD): HResult;
    GetMimeType: function conv arg_stdcall (Self: Pointer; var pszMimeType: PChar): HResult;
    Read: function conv arg_stdcall (Self: Pointer; pvData: Pointer; cbSize: DWORD; var pcbRead: DWORD): HResult;
  end;

const
  TID_DXFILEHeader: TGUID =
    (D1:$3D82AB43;D2:$62DA;D3:$11CF;D4:($AB,$39,$00,$20,$AF,$71,$E4,$33));

{ DirectX File errors. }

const
  DXFILE_OK                         = HResult(0);

  DXFILEERR_BADOBJECT               = HResult($88760000 + 850);
  DXFILEERR_BADVALUE                = HResult($88760000 + 851);
  DXFILEERR_BADTYPE                 = HResult($88760000 + 852);
  DXFILEERR_BADSTREAMHANDLE         = HResult($88760000 + 853);
  DXFILEERR_BADALLOC                = HResult($88760000 + 854);
  DXFILEERR_NOTFOUND                = HResult($88760000 + 855);
  DXFILEERR_NOTDONEYET              = HResult($88760000 + 856);
  DXFILEERR_FILENOTFOUND            = HResult($88760000 + 857);
  DXFILEERR_RESOURCENOTFOUND        = HResult($88760000 + 858);
  DXFILEERR_URLNOTFOUND             = HResult($88760000 + 859);
  DXFILEERR_BADRESOURCE             = HResult($88760000 + 860);
  DXFILEERR_BADFILETYPE             = HResult($88760000 + 861);
  DXFILEERR_BADFILEVERSION          = HResult($88760000 + 862);
  DXFILEERR_BADFILEFLOATSIZE        = HResult($88760000 + 863);
  DXFILEERR_BADFILECOMPRESSIONTYPE  = HResult($88760000 + 864);
  DXFILEERR_BADFILE                 = HResult($88760000 + 865);
  DXFILEERR_PARSEERROR              = HResult($88760000 + 866);
  DXFILEERR_NOTEMPLATE              = HResult($88760000 + 867);
  DXFILEERR_BADARRAYSIZE            = HResult($88760000 + 868);
  DXFILEERR_BADDATAREFERENCE        = HResult($88760000 + 869);
  DXFILEERR_INTERNALERROR           = HResult($88760000 + 870);
  DXFILEERR_NOMOREOBJECTS           = HResult($88760000 + 871);
  DXFILEERR_BADINTRINSICS           = HResult($88760000 + 872);
  DXFILEERR_NOMORESTREAMHANDLES     = HResult($88760000 + 873);
  DXFILEERR_NOMOREDATA              = HResult($88760000 + 874);
  DXFILEERR_BADCACHEFILE            = HResult($88760000 + 875);
  DXFILEERR_NOINTERNET              = HResult($88760000 + 876);

{ API for creating IDirectXFile interface. }

function DirectXFileCreate conv arg_stdcall (var lplpDirectXFile: PPDirectXFile): HResult;
  external 'd3dxof.dll' name 'DirectXFileCreate';

// DSETUP Error Codes, must remain compatible with previous setup.
const
  DSETUPERR_SUCCESS_RESTART     = HResult(1);
  DSETUPERR_SUCCESS             = HResult(0);
  DSETUPERR_BADWINDOWSVERSION   = HResult(-1);
  DSETUPERR_SOURCEFILENOTFOUND  = HResult(-2);
  DSETUPERR_BADSOURCESIZE       = HResult(-3);
  DSETUPERR_BADSOURCETIME       = HResult(-4);
  DSETUPERR_NOCOPY              = HResult(-5);
  DSETUPERR_OUTOFDISKSPACE      = HResult(-6);
  DSETUPERR_CANTFINDINF         = HResult(-7);
  DSETUPERR_CANTFINDDIR         = HResult(-8);
  DSETUPERR_INTERNAL            = HResult(-9);
  DSETUPERR_UNKNOWNOS           = HResult(-11);
  DSETUPERR_USERHITCANCEL       = HResult(-12);
  DSETUPERR_NOTPREINSTALLEDONNT = HResult(-13);

// DSETUP flags. DirectX 5.0 apps should use these flags only.
  DSETUP_DDRAWDRV     = $00000008;   (* install DirectDraw Drivers           *)
  DSETUP_DSOUNDDRV    = $00000010;   (* install DirectSound Drivers          *)
  DSETUP_DXCORE       = $00010000;   (* install DirectX runtime              *)
  DSETUP_DIRECTX = DSETUP_DXCORE or DSETUP_DDRAWDRV or DSETUP_DSOUNDDRV;
  DSETUP_TESTINSTALL  = $00020000;   (* just test install, don't do anything *)

// These OBSOLETE flags are here for compatibility with pre-DX5 apps only.
// They are present to allow DX3 apps to be recompiled with DX5 and still work.
// DO NOT USE THEM for DX5. They will go away in future DX releases.

  DSETUP_DDRAW            = $00000001; (* OBSOLETE. install DirectDraw           *)
  DSETUP_DSOUND           = $00000002; (* OBSOLETE. install DirectSound          *)
  DSETUP_DPLAY            = $00000004; (* OBSOLETE. install DirectPlay           *)
  DSETUP_DPLAYSP          = $00000020; (* OBSOLETE. install DirectPlay Providers *)
  DSETUP_DVIDEO           = $00000040; (* OBSOLETE. install DirectVideo          *)
  DSETUP_D3D              = $00000200; (* OBSOLETE. install Direct3D             *)
  DSETUP_DINPUT           = $00000800; (* OBSOLETE. install DirectInput          *)
  DSETUP_DIRECTXSETUP     = $00001000; (* OBSOLETE. install DirectXSetup DLL's   *)
  DSETUP_NOUI             = $00002000; (* OBSOLETE. install DirectX with NO UI   *)
  DSETUP_PROMPTFORDRIVERS = $10000000; (* OBSOLETE. prompt when replacing display/audio drivers *)
  DSETUP_RESTOREDRIVERS   = $20000000;(* OBSOLETE. restore display/audio drivers *)

//******************************************************************
// DirectX Setup Callback mechanism
//******************************************************************

// DSETUP Message Info Codes, passed to callback as Reason parameter.
  DSETUP_CB_MSG_NOMESSAGE                 = 0;
  DSETUP_CB_MSG_CANTINSTALL_UNKNOWNOS     = 1;
  DSETUP_CB_MSG_CANTINSTALL_NT            = 2;
  DSETUP_CB_MSG_CANTINSTALL_BETA          = 3;
  DSETUP_CB_MSG_CANTINSTALL_NOTWIN32      = 4;
  DSETUP_CB_MSG_CANTINSTALL_WRONGLANGUAGE = 5;
  DSETUP_CB_MSG_CANTINSTALL_WRONGPLATFORM = 6;
  DSETUP_CB_MSG_PREINSTALL_NT             = 7;
  DSETUP_CB_MSG_NOTPREINSTALLEDONNT       = 8;
  DSETUP_CB_MSG_SETUP_INIT_FAILED         = 9;
  DSETUP_CB_MSG_INTERNAL_ERROR            = 10;
  DSETUP_CB_MSG_CHECK_DRIVER_UPGRADE      = 11;
  DSETUP_CB_MSG_OUTOFDISKSPACE            = 12;
  DSETUP_CB_MSG_BEGIN_INSTALL             = 13;
  DSETUP_CB_MSG_BEGIN_INSTALL_RUNTIME     = 14;
  DSETUP_CB_MSG_BEGIN_INSTALL_DRIVERS     = 15;
  DSETUP_CB_MSG_BEGIN_RESTORE_DRIVERS     = 16;
  DSETUP_CB_MSG_FILECOPYERROR             = 17;


  DSETUP_CB_UPGRADE_TYPE_MASK      = $000F;
  DSETUP_CB_UPGRADE_KEEP           = $0001;
  DSETUP_CB_UPGRADE_SAFE           = $0002;
  DSETUP_CB_UPGRADE_FORCE          = $0004;
  DSETUP_CB_UPGRADE_UNKNOWN        = $0008;

  DSETUP_CB_UPGRADE_HASWARNINGS    = $0100;
  DSETUP_CB_UPGRADE_CANTBACKUP     = $0200;

  DSETUP_CB_UPGRADE_DEVICE_ACTIVE  = $0800;

  DSETUP_CB_UPGRADE_DEVICE_DISPLAY = $1000;
  DSETUP_CB_UPGRADE_DEVICE_MEDIA   = $2000;

{ TDSetup_CB_UpgradeInfo }

type
  PDSetup_CB_UpgradeInfo = ^TDSetup_CB_UpgradeInfo;
  TDSetup_CB_UpgradeInfo = packed record
    UpgradeFlags: DWORD;
  end;

  DSETUP_CB_UPGRADEINFO = TDSetup_CB_UpgradeInfo;
  LPDSETUP_CB_UPGRADEINFO = PDSetup_CB_UpgradeInfo;

{ TDSetup_CB_FileCopyError }

  PDSetup_CB_FileCopyError = ^TDSetup_CB_FileCopyError;
  TDSetup_CB_FileCopyError = packed record
    dwError: DWORD;
  end;

  DSETUP_CB_FILECOPYERROR = TDSetup_CB_FileCopyError;
  LPDSETUP_CB_FILECOPYERROR = PDSetup_CB_FileCopyError;

//
// Data Structures
//

{ TDirectXRegisterAppA }

  PDirectXRegisterAppA = ^TDirectXRegisterAppA;
  TDirectXRegisterAppA = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    lpszApplicationName: PAnsiChar;
    lpGUID: PGUID;
    lpszFilename: PAnsiChar;
    lpszCommandLine: PAnsiChar;
    lpszPath: PAnsiChar;
    lpszCurrentDirectory: PAnsiChar;
  end;

  DIRECTXREGISTERAPPA = TDirectXRegisterAppA;
  LPDIRECTXREGISTERAPPA = PDirectXRegisterAppA;

{ TDirectXRegisterAppW }

  PDirectXRegisterAppW = ^TDirectXRegisterAppW;
  TDirectXRegisterAppW = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    lpszApplicationName: PWideChar;
    lpGUID: PGUID;
    lpszFilename: PWideChar;
    lpszCommandLine: PWideChar;
    lpszPath: PWideChar;
    lpszCurrentDirectory: PWideChar;
  end;

  DIRECTXREGISTERAPPW = TDirectXRegisterAppW;
  LPDIRECTXREGISTERAPPW = PDirectXRegisterAppW;

{ TDirectXRegisterApp }

  PDirectXRegisterApp = ^TDirectXRegisterApp;
  TDirectXRegisterApp = TDirectXRegisterAppA;

  DIRECTXREGISTERAPP = TDirectXRegisterApp;
  LPDIRECTXREGISTERAPP = PDirectXRegisterApp;

{ API }

function DirectXSetupA conv arg_stdcall (hWnd: HWND; lpszRootPath: PAnsiChar; dwFlags: DWORD): Longint;
  external 'dsetup.dll' name 'DirectXSetupA';
function DirectXSetupW conv arg_stdcall (hWnd: HWND; lpszRootPath: PWideChar; dwFlags: DWORD): Longint;
  external 'dsetup.dll' name 'DirectXSetupW';
function DirectXSetup conv arg_stdcall (hWnd: HWND; lpszRootPath: PAnsiChar; dwFlags: DWORD): Longint;
  external 'dsetup.dll' name 'DirectXSetupA';

function DirectXDeviceDriverSetupA conv arg_stdcall (hWnd: HWND; lpszDriverClass: PAnsiChar; lpszDriverPath: PAnsiChar; dwFlags: DWORD): Longint;
  external 'dsetup.dll' name 'DirectXDeviceDriverSetupA';
function DirectXDeviceDriverSetupW conv arg_stdcall (hWnd: HWND; lpszDriverClass: PWideChar; lpszDriverPath: PWideChar; dwFlags: DWORD): Longint;
  external 'dsetup.dll' name 'DirectXDeviceDriverSetupW';
function DirectXDeviceDriverSetup conv arg_stdcall (hWnd: HWND; lpszDriverClass: PAnsiChar; lpszDriverPath: PAnsiChar; dwFlags: DWORD): Longint;
  external 'dsetup.dll' name 'DirectXDeviceDriverSetupA';

function DirectXRegisterApplicationA conv arg_stdcall (hWnd: HWND; const lpDXRegApp: TDirectXRegisterAppA): Longint;
  external 'dsetup.dll' name 'DirectXRegisterApplicationA';
function DirectXRegisterApplicationW conv arg_stdcall (hWnd: HWND; const lpDXRegApp: TDirectXRegisterAppW): Longint;
  external 'dsetup.dll' name 'DirectXRegisterApplicationW';
function DirectXRegisterApplication conv arg_stdcall (hWnd: HWND; const lpDXRegApp: TDirectXRegisterAppA): Longint;
  external 'dsetup.dll' name 'DirectXRegisterApplicationA';
function DirectXUnRegisterApplication conv arg_stdcall (hWnd: HWND; const lpGUID: TGUID): Longint;
  external 'dsetup.dll' name 'DirectXUnRegisterApplication';

type
  TDSetup_Callback = function conv arg_stdcall (Reason: DWORD; MsgType: DWORD;
      szMessage: PAnsiChar; szName: PAnsiChar; pInfo: Pointer): DWORD;
  DSETUP_CALLBACK = TDSetup_Callback;

function DirectXSetupSetCallback conv arg_stdcall (Callback: TDSetup_Callback): Longint;
  external 'dsetup.dll' name 'DirectXSetupSetCallback';
function DirectXSetupGetVersion conv arg_stdcall (var lpdwVersion, lpdwMinorVersion: DWORD): Longint;
  external 'dsetup.dll' name 'DirectXSetupGetVersion';

(*********************** DirectX Util Section *****************************)

function DDLoadBitmap(pdd : PPDirectDraw7; szBitmap: PChar; dx, dy: Longint): PPDirectDrawSurface7;
function DDReLoadBitmap(pdds : PPDirectDrawSurface7; szBitmap: PChar): HRESULT;
function DDCopyBitmap(pdds: PPDirectDrawSurface7; hbm: HBITMAP; x, y, dx, dy: Longint): HRESULT;
function DDLoadPalette(pdd: PPDirectDraw7; szBitmap: PChar) : PPDirectDrawPalette;
function DDColorMatch(pdds: PPDirectDrawSurface7; rgb: COLORREF): DWORD;
function DDSetColorKey(pdds: PPDirectDrawSurface7; rgb: COLORREF): HRESULT;

function isGUID_NULL(iGUID: TGUID): Boolean;

const
  c_szWAV = 'WAV';
  MAX_BUFFER_COUNT = 4;

type
TSNDOBJ = packed record
    pbWaveData: POINTER;             // pointer into wave resource (for restore)
    cbWaveSize: DWORD;               // size of wave data (for restore)
    iAlloc: Longint;                 // number of buffers.
    iCurrent: Longint;               // current buffer
    Buffers: array [0..MAX_BUFFER_COUNT] of PPDirectSoundBuffer; // list of buffers
end;

type
  HSNDOBJ = ^TSNDOBJ;
  PSNDOBJ = ^TSNDOBJ;

function DSLoadSoundBuffer(var pDS: PPDirectSound; lpName: LPCTSTR ): PPDirectSoundBuffer;
function DSReloadSoundBuffer(var pDSB: PPDirectSoundBuffer; lpName: LPCTSTR): Boolean;
function DSGetWaveResource(Module: HMODULE; lpName: LPCTSTR;
  var ppWaveHeader: PWAVEFORMATEX; var ppbWaveData: POINTER; var pcbWaveSize: DWORD ): Boolean;
function SndObjCreate(var pDS: PPDirectSound; lpName: LPCTSTR; iConcurrent: Longint): PSNDOBJ;
function SndObjGetFreeBuffer(pSO: PSNDOBJ): PPDirectSoundBuffer;
function SndObjPlay(pSO: PSNDOBJ; dwPlayFlags: DWORD): Boolean;
function SndObjStop(pSO: PSNDOBJ): Boolean;
procedure SndObjDestroy(pSO: PSNDOBJ);
function DSFillSoundBuffer(var pDSB: PPDirectSoundBuffer; var pbWaveData: POINTER; cbWaveSize: DWORD): Boolean;
function DSParseWaveResource(pvRes: Pointer; var ppWaveHeader: PWAVEFORMATEX;
  var ppbWaveData: POINTER; var pcbWaveSize: DWORD): Boolean;

implementation

function GET_WHQL_YEAR(dwWHQLLevel: DWORD): DWORD;
begin
  Result := (dwWHQLLevel) div $10000;
end;

function GET_WHQL_MONTH(dwWHQLLevel: DWORD): DWORD;
begin
  Result := ( (dwWHQLLevel) div $100 ) and $00ff;
end;

function GET_WHQL_DAY(dwWHQLLevel: DWORD): DWORD;
begin
  Result := (dwWHQLLevel) and $ff;
end;


function MAKEFOURCC(ch0, ch1, ch2, ch3: Char): DWORD;
begin
  Result := DWORD(byte(ch0) shl 0) or
            DWORD(byte(ch1) shl 8) or
            DWORD(byte(ch2) shl 16) or
            DWORD(byte(ch3) shl 24);
end;

function DDErrorString(Value: HResult): String;
begin
  case Value of
    DD_OK: Result := 'The request completed successfully.';
    DDERR_ALREADYINITIALIZED: Result := 'This object is already initialized.';
    DDERR_BLTFASTCANTCLIP: Result := ' if a clipper object is attached to the source surface passed into a BltFast call.';
    DDERR_CANNOTATTACHSURFACE: Result := 'This surface can not be attached to the requested surface.';
    DDERR_CANNOTDETACHSURFACE: Result := 'This surface can not be detached from the requested surface.';
    DDERR_CANTCREATEDC: Result := 'Windows can not create any more DCs.';
    DDERR_CANTDUPLICATE: Result := 'Cannot duplicate primary & 3D surfaces, or surfaces that are implicitly created.';
    DDERR_CLIPPERISUSINGHWND: Result := 'An attempt was made to set a cliplist for a clipper object that is already monitoring an hwnd.';
    DDERR_COLORKEYNOTSET: Result := 'No src color key specified for this operation.';
    DDERR_CURRENTLYNOTAVAIL: Result := 'Support is currently not available.';
    DDERR_DIRECTDRAWALREADYCREATED: Result := 'A DirectDraw object representing this driver has already been created for this process.';
    DDERR_EXCEPTION: Result := 'An exception was encountered while performing the requested operation.';
    DDERR_EXCLUSIVEMODEALREADYSET: Result := 'An attempt was made to set the cooperative level when it was already set to exclusive.';
    DDERR_GENERIC: Result := 'Generic failure.';
    DDERR_HEIGHTALIGN: Result := 'Height of rectangle provided is not a multiple of reqd alignment.';
    DDERR_HWNDALREADYSET: Result := 'The CooperativeLevel HWND has already been set. It can not be reset while the process has surfaces or palettes created.';
    DDERR_HWNDSUBCLASSED: Result := 'HWND used by DirectDraw CooperativeLevel has been subclassed, this prevents DirectDraw from restoring state.';
    DDERR_IMPLICITLYCREATED: Result := 'This surface can not be restored because it is an implicitly created surface.';
    DDERR_INCOMPATIBLEPRIMARY: Result := 'Unable to match primary surface creation request with existing primary surface.';
    DDERR_INVALIDCAPS: Result := 'One or more of the caps bits passed to the callback are incorrect.';
    DDERR_INVALIDCLIPLIST: Result := 'DirectDraw does not support the provided cliplist.';
    DDERR_INVALIDDIRECTDRAWGUID: Result := 'The GUID passed to DirectDrawCreate is not a valid DirectDraw driver identifier.';
    DDERR_INVALIDMODE: Result := 'DirectDraw does not support the requested mode.';
    DDERR_INVALIDOBJECT: Result := 'DirectDraw received a pointer that was an invalid DIRECTDRAW object.';
    DDERR_INVALIDPARAMS: Result := 'One or more of the parameters passed to the function are incorrect.';
    DDERR_INVALIDPIXELFORMAT: Result := 'The pixel format was invalid as specified.';
    DDERR_INVALIDPOSITION: Result := 'Returned when the position of the overlay on the destination is no longer legal for that destination.';
    DDERR_INVALIDRECT: Result := 'Rectangle provided was invalid.';
    DDERR_LOCKEDSURFACES: Result := 'Operation could not be carried out because one or more surfaces are locked.';
    DDERR_NO3D: Result := 'There is no 3D present.';
    DDERR_NOALPHAHW: Result := 'Operation could not be carried out because there is no alpha accleration hardware present or available.';
    DDERR_NOBLTHW: Result := 'No blitter hardware present.';
    DDERR_NOCLIPLIST: Result := 'No cliplist available.';
    DDERR_NOCLIPPERATTACHED: Result := 'No clipper object attached to surface object.';
    DDERR_NOCOLORCONVHW: Result := 'Operation could not be carried out because there is no color conversion hardware present or available.';
    DDERR_NOCOLORKEY: Result := 'Surface does not currently have a color key';
    DDERR_NOCOLORKEYHW: Result := 'Operation could not be carried out because there is no hardware support of the destination color key.';
    DDERR_NOCOOPERATIVELEVELSET: Result := 'Create function called without DirectDraw object method SetCooperativeLevel being called.';
    DDERR_NODC: Result := 'No DC was ever created for this surface.';
    DDERR_NODDROPSHW: Result := 'No DirectDraw ROP hardware.';
    DDERR_NODIRECTDRAWHW: Result := 'A hardware-only DirectDraw object creation was attempted but the driver did not support any hardware.';
    DDERR_NOEMULATION: Result := 'Software emulation not available.';
    DDERR_NOEXCLUSIVEMODE: Result := 'Operation requires the application to have exclusive mode but the application does not have exclusive mode.';
    DDERR_NOFLIPHW: Result := 'Flipping visible surfaces is not supported.';
    DDERR_NOGDI: Result := 'There is no GDI present.';
    DDERR_NOHWND: Result := 'Clipper notification requires an HWND or no HWND has previously been set as the CooperativeLevel HWND.';
    DDERR_NOMIRRORHW: Result := 'Operation could not be carried out because there is no hardware present or available.';
    DDERR_NOOVERLAYDEST: Result := 'Returned when GetOverlayPosition is called on an overlay that UpdateOverlay has never been called on to establish a destination.';
    DDERR_NOOVERLAYHW: Result := 'Operation could not be carried out because there is no overlay hardware present or available.';
    DDERR_NOPALETTEATTACHED: Result := 'No palette object attached to this surface.';
    DDERR_NOPALETTEHW: Result := 'No hardware support for 16 or 256 color palettes.';
    DDERR_NORASTEROPHW: Result := 'Operation could not be carried out because there is no appropriate raster op hardware present or available.';
    DDERR_NOROTATIONHW: Result := 'Operation could not be carried out because there is no rotation hardware present or available.';
    DDERR_NOSTRETCHHW: Result := 'Operation could not be carried out because there is no hardware support for stretching.';
    DDERR_NOT4BITCOLOR: Result := 'DirectDrawSurface is not in 4 bit color palette and the requested operation requires 4 bit color palette.';
    DDERR_NOT4BITCOLORINDEX: Result := 'DirectDrawSurface is not in 4 bit color index palette and the requested operation requires 4 bit color index palette.';
    DDERR_NOT8BITCOLOR: Result := 'DirectDrawSurface is not in 8 bit color mode and the requested operation requires 8 bit color.';
    DDERR_NOTAOVERLAYSURFACE: Result := 'Returned when an overlay member is called for a non-overlay surface.';
    DDERR_NOTEXTUREHW: Result := 'Operation could not be carried out because there is no texture mapping hardware present or available.';
    DDERR_NOTFLIPPABLE: Result := 'An attempt has been made to flip a surface that is not flippable.';
    DDERR_NOTFOUND: Result := 'Requested item was not found.';
    DDERR_NOTLOCKED: Result := 'Surface was not locked.  An attempt to unlock a surface that was not locked at all, or by this process, has been attempted.';
    DDERR_NOTPALETTIZED: Result := 'The surface being used is not a palette-based surface.';
    DDERR_NOVSYNCHW: Result := 'Operation could not be carried out because there is no hardware support for vertical blank synchronized operations.';
    DDERR_NOZBUFFERHW: Result := 'Operation could not be carried out because there is no hardware support for zbuffer blitting.';
    DDERR_NOZOVERLAYHW: Result := 'Overlay surfaces could not be z layered based on their BltOrder because the hardware does not support z layering of overlays.';
    DDERR_OUTOFCAPS: Result := 'The hardware needed for the requested operation has already been allocated.';
    DDERR_OUTOFMEMORY: Result := 'DirectDraw does not have enough memory to perform the operation.';
    DDERR_OUTOFVIDEOMEMORY: Result := 'DirectDraw does not have enough memory to perform the operation.';
    DDERR_OVERLAYCANTCLIP: Result := 'The hardware does not support clipped overlays.';
    DDERR_OVERLAYCOLORKEYONLYONEACTIVE: Result := 'Can only have ony color key active at one time for overlays.';
    DDERR_OVERLAYNOTVISIBLE: Result := 'Returned when GetOverlayPosition is called on a hidden overlay.';
    DDERR_PALETTEBUSY: Result := 'Access to this palette is being refused because the palette is already locked by another thread.';
    DDERR_PRIMARYSURFACEALREADYEXISTS: Result := 'This process already has created a primary surface.';
    DDERR_REGIONTOOSMALL: Result := 'Region passed to Clipper::GetClipList is too small.';
    DDERR_SURFACEALREADYATTACHED: Result := 'This surface is already attached to the surface it is being attached to.';
    DDERR_SURFACEALREADYDEPENDENT: Result := 'This surface is already a dependency of the surface it is being made a dependency of.';
    DDERR_SURFACEBUSY: Result := 'Access to this surface is being refused because the surface is already locked by another thread.';
    DDERR_SURFACEISOBSCURED: Result := 'Access to surface refused because the surface is obscured.';
    DDERR_SURFACELOST: Result := 'Access to this surface is being refused because the surface memory is gone. The DirectDrawSurface object representing this surface should have Restore called on it.';
    DDERR_SURFACENOTATTACHED: Result := 'The requested surface is not attached.';
    DDERR_TOOBIGHEIGHT: Result := 'Height requested by DirectDraw is too large.';
    DDERR_TOOBIGSIZE: Result := 'Size requested by DirectDraw is too large, but the individual height and width are OK.';
    DDERR_TOOBIGWIDTH: Result := 'Width requested by DirectDraw is too large.';
    DDERR_UNSUPPORTED: Result := 'Action not supported.';
    DDERR_UNSUPPORTEDFORMAT: Result := 'FOURCC format requested is unsupported by DirectDraw.';
    DDERR_UNSUPPORTEDMASK: Result := 'Bitmask in the pixel format requested is unsupported by DirectDraw.';
    DDERR_VERTICALBLANKINPROGRESS: Result := 'Vertical blank is in progress.';
    DDERR_WASSTILLDRAWING: Result := 'Informs DirectDraw that the previous Blt which is transfering information to or from this Surface is incomplete.';
    DDERR_WRONGMODE: Result := 'This surface can not be restored because it was created in a different mode.';
    DDERR_XALIGN: Result := 'Rectangle provided was not horizontally aligned on required boundary.';
    DDERR_OVERLAPPINGRECTS: Result := 'Operation could not be carried out because the source and destination rectangles are on the same surface and overlap each other.';
    DDERR_INVALIDSTREAM: Result := 'The specified stream contains invalid data';
    DDERR_UNSUPPORTEDMODE: Result := 'The display is currently in an unsupported mode';
    DDERR_NOMIPMAPHW: Result := 'Operation could not be carried out because there is no mip-map texture mapping hardware present or available.';
    DDERR_INVALIDSURFACETYPE: Result := 'The requested action could not be performed because the surface was of the wrong type.';
    DDERR_NOOPTIMIZEHW: Result := 'Device does not support optimized surfaces, therefore no video memory optimized surfaces';
    DDERR_NOTLOADED: Result := 'Surface is an optimized surface, but has not yet been allocated any memory';
    DDERR_NOFOCUSWINDOW: Result := 'Attempt was made to create or set a device window without first setting the focus window';
    DDERR_DCALREADYCREATED: Result := 'A DC has already been returned for this surface. Only one DC can be retrieved per surface.';
    DDERR_NONONLOCALVIDMEM: Result := 'An attempt was made to allocate non-local video memory from a device that does not support non-local video memory.';
    DDERR_CANTPAGELOCK: Result := 'The attempt to page lock a surface failed.';
    DDERR_CANTPAGEUNLOCK: Result := 'The attempt to page unlock a surface failed.';
    DDERR_NOTPAGELOCKED: Result := 'An attempt was made to page unlock a surface with no outstanding page locks.';
    DDERR_MOREDATA: Result := 'There is more data available than the specified buffer size could hold';
    DDERR_EXPIRED: Result := 'The data has expired and is therefore no longer valid.';
    DDERR_VIDEONOTACTIVE: Result := 'The video port is not active';
    DDERR_DEVICEDOESNTOWNSURFACE: Result := 'Surfaces created by one direct draw device cannot be used directly by another direct draw device.';
    DDERR_NOTINITIALIZED: Result := 'An attempt was made to invoke an interface member of a DirectDraw object created by CoCreateInstance() before it was initialized.';
  else
    Result := 'Unrecognized Error';
  end;
end;

function DSSPEAKER_COMBINED(c, g: Byte): DWORD;
begin
  Result := c or (g shl 16);
end;

function DSSPEAKER_CONFIG(a: DWORD): Byte;
begin
  Result := a;
end;

function DSSPEAKER_GEOMETRY(a: DWORD): Byte;
begin
  Result := a shr 16;
end;

function GET_DIDEVICE_TYPE(dwDevType: DWORD): DWORD;
begin
  Result := LOBYTE(dwDevType);
end;

function GET_DIDEVICE_SUBTYPE(dwDevType: DWORD): DWORD;
begin
  Result := HIBYTE(dwDevType);
end;

function DIEFT_GETTYPE(n: DWORD): DWORD;
begin
  Result := LOBYTE(n);
end;

function DIDFT_MAKEINSTANCE(n: WORD): DWORD;
begin
  Result := n shl 8;
end;

function DIDFT_GETTYPE(n: DWORD): DWORD;
begin
  Result := LOBYTE(n);
end;

function DIDFT_GETINSTANCE(n: DWORD): WORD;
begin
  Result := n shr 8;
end;

function DIDFT_ENUMCOLLECTION(n: WORD): DWORD;
begin
  Result := n shl 8;
end;

function DSErrorString(Value: HResult): String;
begin
  case Value of
    DS_OK: Result := 'The request completed successfully.';
    DSERR_ALLOCATED: Result := 'The request failed because resources, such as a priority level, were already in use by another caller.';
    DSERR_ALREADYINITIALIZED: Result := 'The object is already initialized.';
    DSERR_BADFORMAT: Result := 'The specified wave format is not supported.';
    DSERR_BUFFERLOST: Result := 'The buffer memory has been lost and must be restored.';
    DSERR_CONTROLUNAVAIL: Result := 'The control (volume, pan, and so forth) requested by the caller is not available.';
    DSERR_GENERIC: Result := 'An undetermined error occurred inside the DirectSound subsystem.';
    DSERR_INVALIDCALL: Result := 'This function is not valid for the current state of this object.';
    DSERR_INVALIDPARAM: Result := 'An invalid parameter was passed to the returning function.';
    DSERR_NOAGGREGATION: Result := 'The object does not support aggregation.';
    DSERR_NODRIVER: Result := 'No sound driver is available for use.';
    DSERR_NOINTERFACE: Result := 'The requested COM interface is not available.';
    DSERR_OTHERAPPHASPRIO: Result := 'Another application has a higher priority level, preventing this call from succeeding.';
    DSERR_OUTOFMEMORY: Result := 'The DirectSound subsystem could not allocate sufficient memory to complete the caller¦s request.';
    DSERR_PRIOLEVELNEEDED: Result := 'The caller does not have the priority level required for the function to succeed.';
    DSERR_UNINITIALIZED: Result := 'The IDirectSound::Initialize method has not been called or has not been called successfully before other methods were called.';
    DSERR_UNSUPPORTED: Result := 'The function called is not supported at this time.';
  else
    Result := 'Unrecognized Error';
  end;
end;

function MAKE_DSHRESULT(code: DWORD) : HResult;
begin
  Result := HResult(1 shl 31) or HResult(_FACDS shl 16)
      or HResult(code);
end;

function DIErrorString(Value: HResult): String;
var
  sValue: array[0..255] of char;
begin
  case Value of
    DI_OK: Result := 'The operation completed successfully.';
    S_FALSE: Result := '"The operation had no effect." or "The device buffer overflowed and some input was lost." or "The device exists but is not currently attached." or "The change in device properties had no effect."';
    DI_DOWNLOADSKIPPED: Result := 'The parameters of the effect were successfully updated, but the effect could not be downloaded because the associated device was not acquired in exclusive mode.';
    DI_EFFECTRESTARTED: Result := 'The effect was stopped, the parameters were updated, and the effect was restarted.';
    DI_POLLEDDEVICE: Result := 'The device is a polled device. As a Result, device buffering will not collect any data and event notifications will not be signaled until the IDirectInputDevice2::Poll method is called.';
    DI_TRUNCATED: Result := 'The parameters of the effect were successfully updated, but some of them were beyond the capabilities of the device and were truncated to the nearest supported value.';
    DI_TRUNCATEDANDRESTARTED: Result := 'Equal to DI_EFFECTRESTARTED | DI_TRUNCATED.';
    DIERR_ACQUIRED: Result := 'The operation cannot be performed while the device is acquired.';
    DIERR_ALREADYINITIALIZED: Result := 'This object is already initialized';
    DIERR_BADDRIVERVER: Result := 'The object could not be created due to an incompatible driver version or mismatched or incomplete driver components.';
    DIERR_BETADIRECTINPUTVERSION: Result := 'The application was written for an unsupported prerelease version of DirectInput.';
    DIERR_DEVICEFULL: Result := 'The device is full.';
    DIERR_DEVICENOTREG: Result := 'The device or device instance is not registered with DirectInput. This value is equal to the REGDB_E_CLASSNOTREG standard COM return value.';
    DIERR_EFFECTPLAYING: Result := 'The parameters were updated in memory but were not downloaded to the device because the device does not support updating an effect while it is still playing.';
    DIERR_HASEFFECTS: Result := 'The device cannot be reinitialized because there are still effects attached to it.';
    DIERR_GENERIC: Result := 'An undetermined error occurred inside the DirectInput subsystem. This value is equal to the E_FAIL standard COM return value.';
    DIERR_INCOMPLETEEFFECT: Result := 'The effect could not be downloaded because essential information is missing. For example, no axes have been associated with the effect, or no type-specific information has been supplied.';
    DIERR_INPUTLOST: Result := 'Access to the input device has been lost. It must be reacquired.';
    DIERR_INVALIDPARAM: Result := 'An invalid parameter was passed to the returning function, or the object was not in a state that permitted the function to be called. This value is equal to the E_INVALIDARG standard COM return value.';
    DIERR_MOREDATA: Result := 'Not all the requested information fitted into the buffer.';
    DIERR_NOAGGREGATION: Result := 'This object does not support aggregation.';
    DIERR_NOINTERFACE: Result := 'The specified interface is not supported by the object. This value is equal to the E_NOINTERFACE standard COM return value.';
    DIERR_NOTACQUIRED: Result := 'The operation cannot be performed unless the device is acquired.';
    DIERR_NOTBUFFERED: Result := 'The device is not buffered. Set the DIPROP_BUFFERSIZE property to enable buffering.';
    DIERR_NOTDOWNLOADED: Result := 'The effect is not downloaded.';
    DIERR_NOTEXCLUSIVEACQUIRED: Result := 'The operation cannot be performed unless the device is acquired in DISCL_EXCLUSIVE mode.';
    DIERR_NOTFOUND: Result := 'The requested object does not exist.';
    DIERR_NOTINITIALIZED: Result := 'This object has not been initialized.';
    DIERR_OLDDIRECTINPUTVERSION: Result := 'The application requires a newer version of DirectInput.';
    DIERR_OTHERAPPHASPRIO: Result := '"The device already has an event notification associated with it." or "The specified property cannot be changed." or "Another application has a higher priority level, preventing this call from succeeding. "';
    DIERR_OUTOFMEMORY: Result := 'The DirectInput subsystem could not allocate sufficient memory to complete the call. This value is equal to the E_OUTOFMEMORY standard COM return value.';
    DIERR_UNSUPPORTED: Result := 'The function called is not supported at this time. This value is equal to the E_NOTIMPL standard COM return value.';
    E_PENDING: Result := 'Data is not yet available.';
    HResult($800405CC): Result := 'No more memory for effects of this kind (not documented)';
  else
    Result := 'Unrecognized Error: $' + sValue;
  end;
end;

//-----------------------------------------------------------------------------
// Name: DDLoadBitmap()
// Desc: Create a DirectDrawSurface from a bitmap resource.
//-----------------------------------------------------------------------------
function DDLoadBitmap(pdd: PPDirectDraw7; szBitmap: PChar; dx, dy: Longint): PPDirectDrawSurface7;
var
  hbm:  HBITMAP;
  bm:   TBITMAP;
  ddsd: TDDSurfaceDesc2;
  pdds: PPDirectDrawSurface7;
begin
  //
  //  Try to load the bitmap as a resource, if that fails, try it as a file
  //
  hbm := LoadImage(GetModuleHandle(nil), szBitmap, IMAGE_BITMAP, dx, dy, LR_CREATEDIBSECTION);
  if hbm = 0 then
    begin
      hbm := LoadImage(0, szBitmap, IMAGE_BITMAP, dx, dy, LR_LOADFROMFILE or LR_CREATEDIBSECTION);
    end;
  if hbm = 0 then
    begin
      Result := nil;
      Exit;
    end;
  //
  // Get size of the bitmap
  //
  GetObject(hbm, SizeOf(bm), @bm);
  //
  // Create a DirectDrawSurface for this bitmap
  //
  FillChar(ddsd, SizeOf(ddsd), 0);
  ddsd.dwSize := SizeOf(ddsd);
  ddsd.dwFlags := DDSD_CAPS or DDSD_HEIGHT or DDSD_WIDTH;
  ddsd.ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN;
  ddsd.dwWidth := bm.bmWidth;
  ddsd.dwHeight := bm.bmHeight;
  if pdd^^.CreateSurface(pdd, ddsd, pdds, nil) <> DD_OK then
    begin
      Result := nil;
      Exit;
    end;
  DDCopyBitmap(pdds, hbm, 0, 0, 0, 0);
  DeleteObject(hbm);
  Result := pdds;
end;

//-----------------------------------------------------------------------------
// Name: DDReLoadBitmap()
// Desc: Load a bitmap from a file or resource into a directdraw surface.
//       normaly used to re-load a surface after a restore.
//-----------------------------------------------------------------------------
function DDReLoadBitmap(pdds: PPDirectDrawSurface7; szBitmap: PChar): HRESULT;
var
  hbm: HBITMAP;
  hr:  HRESULT;
begin
  //
  //  Try to load the bitmap as a resource, if that fails, try it as a file
  //
  hbm := LoadImage(GetModuleHandle(nil), szBitmap, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION);
  if hbm = 0 then
    begin
      hbm := LoadImage(0, szBitmap, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_CREATEDIBSECTION);
    end;
  if hbm = 0 then
    begin
      OutputDebugString('handle is null');
      Result := E_FAIL;
      Exit;
    end;
  hr := DDCopyBitmap(pdds, hbm, 0, 0, 0, 0);
  if hr <> DD_OK then
    begin
      OutputDebugString('ddcopybitmap failed');
      Result := hr;
      Exit;
    end;
  DeleteObject(hbm);
  Result := hr;
end;

//-----------------------------------------------------------------------------
// Name: DDCopyBitmap()
// Desc: Draw a bitmap into a DirectDrawSurface
//-----------------------------------------------------------------------------
function DDCopyBitmap(pdds: PPDirectDrawSurface7; hbm: HBITMAP; x, y, dx, dy: Longint): HRESULT;
var
 hdcImage : HDC;
 h_dc:      HDC;
 bm:        TBITMAP;
 ddsd:      TDDSurfaceDesc2;
 hr:        HRESULT;
begin
  if (hbm = 0) or (pdds = nil) then
    begin
      Result := E_FAIL;
      Exit;
    end;
  //
  // Make sure this surface is restored.
  //
  pdds^^.Restore(pdds);
  //
  // Select bitmap into a memoryDC so we can use it.
  //
  hdcImage := CreateCompatibleDC(0);
  if hdcImage = 0 then
    begin
      OutputDebugString('createcompatible dc failed');
    end;
  SelectObject(hdcImage, hbm);
  //
  // Get size of the bitmap
  //
  GetObject(hbm, SizeOf(bm), @bm);
  if dx = 0 then                      // Use the passed size, unless zero
    begin
      dx := bm.bmWidth;
    end;
  if dy = 0 then
    begin
      dy := bm.bmHeight;
    end;
  //
  // Get size of surface.
  //
  ddsd.dwSize := SizeOf(ddsd);
  ddsd.dwFlags := DDSD_HEIGHT or DDSD_WIDTH;
  pdds^^.GetSurfaceDesc(pdds, ddsd);

  hr := pdds^^.GetDC(pdds, h_dc);
  if hr = DD_OK then
    begin
      StretchBlt(h_dc, 0, 0, ddsd.dwWidth, ddsd.dwHeight, hdcImage, x, y, dx, dy, SRCCOPY);
      pdds^^.ReleaseDC(pdds, h_dc);
    end;
  DeleteDC(hdcImage);
  Result := hr;
end;

var
  Old: Pointer;

//-----------------------------------------------------------------------------
// Name: DDLoadPalette()
// Desc: Create a DirectDraw palette object from a bitmap resource
//       if the resource does not exist or NULL is passed create a
//       default 332 palette.
//-----------------------------------------------------------------------------
function DDLoadPalette(pdd: PPDirectDraw7; szBitmap: PChar): PPDirectDrawPalette;
var
  ddpal: PPDirectDrawPalette;
  i:     Longint;
  n:     Longint;
  fh:    Longint;
  h:     HRSRC;
  lpbi:  PBITMAPINFOHEADER;
  ape:   array[0..255] of TPALETTEENTRY;
  prgb:  PRGBQUAD;
  bf:    TBITMAPFILEHEADER;
  bi:    TBITMAPINFOHEADER;
  r:     Byte;
begin
  //
  // Build a 332 palette as the default.
  //
  for i := 0 to 255 do
    begin
      ape[i].peRed :=   ((i shr 5) and $07) * 255 div 7;
      ape[i].peGreen := ((i shr 2) and $07) * 255 div 7;
      ape[i].peBlue :=  ((i shr 0) and $03) * 255 div 3;
      ape[i].peFlags := 0;
    end;
  //
  // Get a pointer to the bitmap resource.
  //
  h := FindResource(0, szBitmap, RT_BITMAP);
  if (szBitmap <> nil) and (h <> 0) then
    begin
      lpbi := PBITMAPINFOHEADER(LockResource(LoadResource(0, h)));
      prgb := PRGBQUAD(lpbi + SizeOf(lpbi^.biSize));

      if lpbi = nil then
        OutputDebugString('lock resource failed');
      if (lpbi = nil) or (lpbi^.biSize < SizeOf(TBITMAPINFOHEADER)) then
        n := 0
      else if lpbi^.biBitCount > 8 then
        n := 0
      else if lpbi^.biClrUsed = 0 then
        n := 1 shl lpbi^.biBitCount
      else
        n := lpbi^.biClrUsed;

      //
      //  A DIB color table has its colors stored BGR not RGB
      //  so flip them around.
      //
      for i := 0 to n-1 do
        begin
          ape[i].peRed := prgb^.rgbRed;
          ape[i].peGreen := prgb^.rgbGreen;
          ape[i].peBlue := prgb^.rgbBlue;
          ape[i].peFlags := 0;
          inc(prgb);
        end;
    end
  else
    begin
      fh := _lopen(szBitmap, OF_READ);
      if (szBitmap <> nil) and (fh <> -1) then
        begin
          _lread(fh, @bf, SizeOf(bf));
          _lread(fh, @bi, SizeOf(bi));
          _lread(fh, @ape[0], SizeOf(ape));
          _lclose(fh);
          if bi.biSize <> SizeOf(TBITMAPINFOHEADER) then
            n := 0
          else if bi.biBitCount > 8 then
            n := 0
          else if bi.biClrUsed = 0 then
            n := 1 shl bi.biBitCount
          else
            n := bi.biClrUsed;
          //
          //  A DIB color table has its colors stored BGR not RGB
          //  so flip them around.
          //
          for i := 0 to n - 1 do
            begin
            r := ape[i].peRed;
            ape[i].peRed := ape[i].peBlue;
            ape[i].peBlue := r;
            end;
        end;
    end;
  pdd^^.CreatePalette(pdd, DDPCAPS_8BIT, @ape[0], ddpal, nil);
  Result := ddpal;
end;

//-----------------------------------------------------------------------------
// Name: DDColorMatch()
// Desc: Convert a RGB color to a pysical color.
//       We do this by leting GDI SetPixel() do the color matching
//       then we lock the memory and see what it got mapped to.
//-----------------------------------------------------------------------------
function DDColorMatch(pdds: PPDirectDrawSurface7; rgb: COLORREF): DWORD;
var
  rgbT: COLORREF;
  h_dc: HDC;
  dw:   DWORD;
  ddsd: TDDSurfaceDesc2;
  hres: HRESULT;
begin
  dw := CLR_INVALID;
  rgbT := 0;
  //
  //  Use GDI SetPixel to color match for us
  //
  if (rgb <> CLR_INVALID) and (pdds^^.GetDC(pdds, h_dc) = DD_OK) then
    begin
      rgbT := GetPixel(h_dc, 0, 0);     // Save current pixel value
      SetPixel(h_dc, 0, 0, rgb);       // Set our value
      pdds^^.ReleaseDC(pdds, h_dc);
    end;
  //
  // Now lock the surface so we can read back the converted color
  //
  ddsd.dwSize := SizeOf(ddsd);
  hres := pdds^^.Lock(pdds, nil, ddsd, 0, 0);
  while hres = DDERR_WASSTILLDRAWING do
    begin
      hres := pdds^^.Lock(pdds, nil, ddsd, 0, 0);
    end;
  if hres = DD_OK then
    begin
      dw := PDWORD(ddsd.lpSurface)^;                 // Get DWORD
      if ddsd.ddpfPixelFormat.dwRGBBitCount < 32 then
        dw := dw and ((1 shl ddsd.ddpfPixelFormat.dwRGBBitCount) - 1);  // Mask it to bpp
      pdds^^.Unlock(pdds, nil);
    end;
  //
  //  Now put the color that was there back.
  //
  if (rgb <> CLR_INVALID) and (pdds^^.GetDC(pdds, h_dc) = DD_OK) then
    begin
      SetPixel(h_dc, 0, 0, rgbT);
      pdds^^.ReleaseDC(pdds, h_dc);
    end;
  Result := dw;
end;

//-----------------------------------------------------------------------------
// Name: DDSetColorKey()
// Desc: Set a color key for a surface, given a RGB.
//       If you pass CLR_INVALID as the color key, the pixel
//       in the upper-left corner will be used.
//-----------------------------------------------------------------------------
function DDSetColorKey(pdds: PPDirectDrawSurface7; rgb: COLORREF): HRESULT;
var
  ddck: TDDColorKey;
begin
  ddck.dwColorSpaceLowValue := DDColorMatch(pdds, rgb);
  ddck.dwColorSpaceHighValue := ddck.dwColorSpaceLowValue;
  Result := pdds^^.SetColorKey(pdds, DDCKEY_SRCBLT, ddck);
end;

function isGUID_NULL(iGUID: TGUID): Boolean;
begin
    Result := (iGUID.D1 = 0) and (iGUID.D2 = 0) and (iGUID.D3 = 0) and
        (iGUID.D4[0] = 0) and (iGUID.D4[1] = 0) and (iGUID.D4[2] = 0) and
        (iGUID.D4[3] = 0) and (iGUID.D4[4] = 0) and (iGUID.D4[5] = 0) and
        (iGUID.D4[6] = 0) and (iGUID.D4[7] = 0);
end;

procedure Init_c_dfDIKeyboard_Objects;  // XRef: Initialization
var x: Cardinal;
begin
  for x := 0 to 255 do
  with _c_dfDIKeyboard_Objects[x] do
  begin
    pGuid := @GUID_Key; dwOfs := x; dwFlags := 0;
    dwType := $80000000 or DIDFT_BUTTON or x shl 8;
  end;
end;

procedure Init_c_dfDIJoystick2_Objects;  // XRef: Initialization
var x,y, OfVal: Cardinal;
begin
  Move(_c_dfDIJoystick_Objects,_c_dfDIJoystick2_Objects,SizeOf(_c_dfDIJoystick_Objects));
  // all those empty "buttons"
  for x := $2C to $8B do
    Move(_c_dfDIJoystick_Objects[$2B],_c_dfDIJoystick2_Objects[x],SizeOf(TDIObjectDataFormat));
  for x := 0 to 2 do
  begin  // 3 more blocks of X axis..Sliders
    Move(_c_dfDIJoystick_Objects,_c_dfDIJoystick2_Objects[$8C+8*x],8*SizeOf(TDIObjectDataFormat));
    for y := 0 to 7 do _c_dfDIJoystick2_Objects[$8C+8*x+y].dwFlags := (x+1) shl 8;
  end;
  OfVal := _c_dfDIJoystick2_Objects[$2B].dwOfs+1;
  for x := $2C to $A3 do
  begin
    _c_dfDIJoystick2_Objects[x].dwOfs := OfVal;
    if x < $8C then Inc(OfVal) else Inc(OfVal,4);
  end;
end;

function DirectSoundCreate( lpGuid: PGUID; var ppDS: PPDirectSound; pUnkOuter: PPUnknown): HResult;
begin
  if @_DirectSoundCreate <> nil then
    Result := _DirectSoundCreate(lpGuid, ppDS, pUnkOuter)
  else
    Result := DSERR_NOINTERFACE;
end;

function DirectSoundEnumerateA(lpDSEnumCallback: TDSEnumCallbackA; lpContext: Pointer): HResult;
begin
  if @_DirectSoundEnumerateA <> nil then
    Result := _DirectSoundEnumerateA(lpDSEnumCallback, lpContext)
  else
    Result := DSERR_NOINTERFACE;
end;

function DirectSoundEnumerate(lpDSEnumCallback: TDSEnumCallback; lpContext: Pointer): HResult;
begin
  if @_DirectSoundEnumerate <> nil then
    Result := _DirectSoundEnumerate(lpDSEnumCallback, lpContext)
  else
    Result := DSERR_NOINTERFACE;
end;

function DirectSoundCaptureCreate(lpGUID: PGUID; var lplpDSC: PPDirectSoundCapture; pUnkOuter: PPUnknown): HResult;
begin
  if @_DirectSoundCaptureCreate <> nil then
    Result := _DirectSoundCaptureCreate(lpGUID, lplpDSC, pUnkOuter)
  else
    Result := DSERR_NOINTERFACE;
end;

function DirectSoundCaptureEnumerateA (lpDSEnumCallback: TDSEnumCallbackA; lpContext: Pointer): HResult;
begin
  if @_DirectSoundCaptureEnumerateA <> nil then
    Result := _DirectSoundCaptureEnumerateA(lpDSEnumCallback, lpContext)
  else
    Result := DSERR_NOINTERFACE;
end;

function DirectSoundCaptureEnumerate(lpDSEnumCallback: TDSEnumCallback; lpContext: Pointer): HResult;
begin
  if @_DirectSoundCaptureEnumerate <> nil then
    Result := _DirectSoundCaptureEnumerate(lpDSEnumCallback, lpContext)
  else
    Result := DSERR_NOINTERFACE;
end;


function DSLoadSoundBuffer(var pDS: PPDirectSound; lpName: LPCTSTR): PPDirectSoundBuffer;
var
    pDSB: PPDirectSoundBuffer;
    dsBD: TDSBUFFERDESC;
    pbWaveData: Pointer;
begin
    ZeroMemory(@dsBD, SizeOf(dsBD));

    pDSB := nil;
    pbWaveData := nil;

    if (DSGetWaveResource(0, lpName, dsBD.lpwfxFormat, pbWaveData, dsBD.dwBufferBytes)) then
    begin
        dsBD.dwSize := SizeOf(dsBD);
        dsBD.dwFlags := DSBCAPS_STATIC or DSBCAPS_CTRLDEFAULT or DSBCAPS_GETCURRENTPOSITION2;

        if pDS^^.CreateSoundBuffer(pDS, dsBD, pDSB, nil) = DS_OK then
        begin
            if not DSFillSoundBuffer(pDSB, pbWaveData, dsBD.dwBufferBytes) then
            begin
                pDSB^^.Release(pDSB);
                pDSB := nil;
            end;
        end
        else
        begin
            pDSB := nil;
        end;
    end;

    Result := pDSB;
end;


function DSReloadSoundBuffer(var pDSB: PPDirectSoundBuffer; lpName: LPCTSTR): Boolean;
var
    pbWaveData: Pointer;
    cbWaveSize: DWORD;
    dummy: PWAVEFORMATEX;
begin

    Result:= FALSE;
    pbWaveData := nil;
    cbWaveSize := 0;

    if DSGetWaveResource(0, lpName, dummy, pbWaveData, cbWaveSize) then
    begin
        if (pDSB^^.Restore(pDSB) = DS_OK) and (DSFillSoundBuffer(pDSB, pbWaveData, cbWaveSize)) then
            Result:= TRUE;
    end;
end;

function DSGetWaveResource(Module:HMODULE; lpName: LPCTSTR; var ppWaveHeader: PWAVEFORMATEX; var ppbWaveData: Pointer; var pcbWaveSize: DWORD): Boolean;
var
    hResInfo:HRSRC;
    hResData:HGLOBAL;
    pvRes:Pointer;

begin
    hResInfo := FindResource(Module, Pchar(lpName), c_szWAV);

    if hResInfo <> 0 then
     hResData := LoadResource(Module, hResInfo)
    else
     begin
       Result := FALSE;
       exit;
     end;

    pvRes := LockResource(hResData);
    if (pvRes <> nil) and
       DSParseWaveResource(pvRes, ppWaveHeader, ppbWaveData, pcbWaveSize)
     then
    else
     begin
        Result := FALSE;
        exit;
     end;

     Result := TRUE
end;


function SndObjCreate(var pDS: PPDirectSound; lpName: LPCTSTR; iConcurrent: Longint): PSNDOBJ;
var
    pSO: PSNDOBJ;
    pWaveHeader: PWAVEFORMATEX;
    pbData: Pointer;
    cbData: DWORD;
    i: Longint;
begin
    if DSGetWaveResource(0, lpName,pWaveHeader, pbData, cbData) then
    begin
        if iConcurrent < 1 then iConcurrent:= 1;

        pSO := PSNDOBJ(LocalAlloc(LPTR, SizeOf(TSNDOBJ) + (iConcurrent-1) * SizeOf(IDirectSoundBuffer)));

        pSO^.iAlloc := iConcurrent;
        pSO^.pbWaveData := pbData;
        pSO^.cbWaveSize := cbData;
        pSO^.Buffers[0] := DSLoadSoundBuffer(pDS, lpName);

        for i := 1 to pSO^.iAlloc - 1 do
        begin
            if FAILED(pDS^^.DuplicateSoundBuffer(pDS, pSO^.Buffers[0], pSO^.Buffers[i])) then
            begin
              pSO^.Buffers[i] := DSLoadSoundBuffer(pDS, lpName);
              if pSO^.Buffers[i] <> nil then
              begin
                 SndObjDestroy(pSO);
                 pSO := nil;
                 break;
              end;
            end;
        end;
    end;

    Result := pSO;
end;

procedure SndObjDestroy(pSO: PSNDOBJ);
var
  i: Longint;
begin
  if (pSO <> nil ) then
  begin
    for i := 0 to pSO^.iAlloc - 1 do
    begin
      if pSO^.Buffers[i] <> nil then
      begin
        pSO^.Buffers[i]^^.Release(pSO^.Buffers[i]);
        pSO^.Buffers[i] := nil;
      end;
    end;
    LocalFree(THandle(pSO));
  end;
end;


function SndObjGetFreeBuffer(pSO: PSNDOBJ): PPDirectSoundBuffer;
var
    pDSB: PPDirectSoundBuffer;
    hres: HRESULT;
    dwStatus: DWORD;
begin

 if pSO = nil then
 begin
   Result := nil;
   exit;
 end;

 pDSB := pSO^.Buffers[pSO^.iCurrent];

 if pDSB <> nil then
 begin
   hres := pDSB^^.GetStatus(pDSB, dwStatus);

   if (FAILED(hres)) then dwStatus := 0;

   if (dwStatus and DSBSTATUS_PLAYING) = DSBSTATUS_PLAYING then
      if pSO^.iAlloc > 1 then
      begin
        inc(pSO^.iCurrent);
        if (pSO^.iCurrent >= pSO^.iAlloc) then
            pSO^.iCurrent := 0;

            pDSB := pSO^.Buffers[pSO^.iCurrent];
            hres := pDSB^^.GetStatus(pDSB, dwStatus);

            if SUCCEEDED(hres) and ((dwStatus and DSBSTATUS_PLAYING) = DSBSTATUS_PLAYING) then
            begin
                pDSB^^.Stop(pDSB);
                pDSB^^.SetCurrentPosition(pDSB, 0);
            end;
      end
      else
         pDSB := nil;

   if (pDSB <> nil) and ((dwStatus and DSBSTATUS_BUFFERLOST) <> 0) then
    begin
        if FAILED(pDSB^^.Restore(pDSB)) or (not DSFillSoundBuffer(pDSB, pSO^.pbWaveData, pSO^.cbWaveSize)) then
           pDSB := nil;
    end;
 end;

 Result := pDSB;
end;

function SndObjPlay(pSO: PSNDOBJ; dwPlayFlags: DWORD): Boolean;
var
   pDSB: PPDirectSoundBuffer;
begin
    if pSO = nil then
    begin
      Result := FALSE;
      exit;
    end;
    if ((dwPlayFlags and DSBPLAY_LOOPING) = 0) or (pSO^.iAlloc = 1) then
    begin
      pDSB := SndObjGetFreeBuffer(pSO);
      if (pDSB <> nil) then
         Result := SUCCEEDED(pDSB^^.Play(pDSB, 0, 0, dwPlayFlags));
    end else
      Result:= FALSE;
end;


function SndObjStop(pSO: PSNDOBJ): Boolean;
var
  i: Longint;
begin
   if pSO = nil then
   begin
     Result := FALSE;
     exit;
   end;
   for i:=0 to pSO^.iAlloc - 1 do
   begin
     pSO^.Buffers[i]^^.Stop(pSO^.Buffers[i]);
     pSO^.Buffers[i]^^.SetCurrentPosition(pSO^.Buffers[i], 0);
   end;
   Result := TRUE;
end;

function DSFillSoundBuffer(var pDSB: PPDirectSoundBuffer; var pbWaveData: Pointer; cbWaveSize: DWORD): Boolean;
var
    pMem1, pMem2:Pointer;
    dwSize1, dwSize2:DWORD ;
begin
    if (pDSB <> nil) and (pbWaveData <> nil) and (cbWaveSize <> 0) then
    begin

        if (SUCCEEDED(pDSB^^.Lock(pDSB, 0, cbWaveSize,
            pMem1, dwSize1, pMem2, dwSize2, 0))) then
        begin
            CopyMemory(pMem1, pbWaveData, dwSize1);

            if ( 0 <> dwSize2 ) then
                CopyMemory(pMem2, Pointer(DWORD(pbWaveData) + dwSize1), dwSize2);

            if pDSB^^.Unlock(pDSB, pMem1, dwSize1, pMem2, dwSize2) <> DS_OK then
              begin
               Result:=FALSE;
               exit;
              end;

            Result:=TRUE;
            exit;
        end;
    end;

    Result := FALSE;
end;

function DSParseWaveResource(pvRes: Pointer; var ppWaveHeader: PWAVEFORMATEX;
  var ppbWaveData: Pointer; var pcbWaveSize: DWORD): Boolean;

const
  FOURCC_WAVE = $45564157;
  FOURCC_DATA = $61746164;
  FOURCC_FMT  = $20746d66;

var
   pdw, pdwEnd: PDWORD;
   dwRiff, dwType, dwLength: DWORD;
   temp: DWORD;
begin
  pdw := PDWORD(pvRes);

  dwRiff :=pdw^;
  inc(pdw);

  dwLength :=pdw^;
  inc(pdw);

  dwType :=pdw^;
  inc(pdw);

  //not a RIFF
  if dwRiff <> FOURCC_RIFF then
  begin
      Result := FALSE;
      exit;
  end;

  // not a WAV
  if dwType <> FOURCC_WAVE then
  begin
      Result := FALSE;
      exit;
  end;

  pdwEnd := PDWORD(PBYTE(Longint(pdw) + Longint(dwLength)-4));

  while Longint(pdw) < Longint(pdwEnd) do
  begin
    dwType :=pdw^;
    inc(pdw);

    dwLength :=pdw^;
    inc(pdw);

    case dwType of
    FOURCC_FMT:
        begin
          if ppWaveHeader = nil then
          begin
              if (dwLength < SizeOf(TWAVEFORMAT)) then
              begin
                  Result := FALSE;
                  exit;
              end;

              ppWaveHeader:=PWAVEFORMATEX(pdw);

              if (ppbWaveData <> nil) and (pcbWaveSize <> 0) then
              begin
                  Result := TRUE;
                  exit;
              end;
          end;
        end;

    FOURCC_DATA:
        begin
          if (ppbWaveData = nil) and (pcbWaveSize = 0) then
          begin
              ppbWaveData := pdw;
              pcbWaveSize := dwLength;

              if ppWaveHeader<>nil then
              begin
                 Result := TRUE;
                 exit;
              end;
          end;
        end;
    end;

    temp:=(dwLength + 1) and (not $1);
    pdw := PDWORD(PBYTE(DWORD(pdw) + temp ));

  end;
end;


var
  DSoundDLL:   hModule;
  OldExitProc: Pointer;

procedure DXLiteExitProc;
begin
  FreeLibrary(DSoundDLL);
  ExitProc := OldExitProc;
end;

begin
  OldExitProc := ExitProc;
  ExitProc := @DXLiteExitProc;
  Init_c_dfDIKeyboard_Objects;
  Init_c_dfDIJoystick2_Objects;

  DSoundDLL := LoadLibrary('DSound.dll');
  @_DirectSoundCreate := GetProcAddress(DSoundDLL,'DirectSoundCreate');

  @_DirectSoundEnumerateA := GetProcAddress(DSoundDLL,'DirectSoundEnumerateA');
  _DirectSoundEnumerate := _DirectSoundEnumerateA;

  @_DirectSoundCaptureCreate := GetProcAddress(DSoundDLL,'DirectSoundCaptureCreate');

  @_DirectSoundCaptureEnumerateA := GetProcAddress(DSoundDLL,'DirectSoundCaptureEnumerateA');
  _DirectSoundCaptureEnumerate := _DirectSoundCaptureEnumerateA;
end.
