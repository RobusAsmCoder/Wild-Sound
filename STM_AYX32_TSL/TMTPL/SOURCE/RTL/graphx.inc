(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       GRAPHX.INC for Graph Unit                              *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

const
  DD_OK                    = 0;
  DDSDM_STANDARDVGAMODE    = 1;
  DD_ROP_SPACE             = (256 div 32);
  DDSCL_EXCLUSIVE          = $00000010;
  DDSCL_FULLSCREEN         = $00000001;
  DDSD_CAPS                = $00000001;
  DDSD_BACKBUFFERCOUNT     = $00000020;
  DDSCAPS_BACKBUFFER       = $00000004;
  DDSCAPS_COMPLEX          = $00000008;
  DDSCAPS_FLIP             = $00000010;
  DDSCAPS_PRIMARYSURFACE   = $00000200;
  DDSCAPS_VIDEOMEMORY      = $00004000;
  DDLOCK_SURFACEMEMORYPTR  = $00000000;
  DDEDM_STANDARDVGAMODES   = $00000002;
  DDPCAPS_8BIT             = $00000004;
  DDWAITVB_BLOCKEND        = $00000004;
  DDFLIP_WAIT              = $00000001;
  FACDD                    = $876;
  MAKE_DDHRESULT           = HResult(1 shl 31) or HResult(FACDD shl 16);
  DDERR_SURFACELOST        = MAKE_DDHRESULT + 450;

  IID_IDirectDraw2: TGUID  =
    (D1:$B3A6F3E0; D2:$2B43; D3:$11CF; D4:($A2,$DE,$00,$AA,$00,$B9,$33,$56));

type
  PDDColorKey = ^TDDColorKey;
  TDDColorKey = packed record
    dwColorSpaceLowValue: DWORD;
    dwColorSpaceHighValue: DWORD;
  end;

type
  PDDScaps = ^TDDScaps;
  TDDScaps = packed record
    dwCaps: DWORD;
  end;

type
  PDDPixelFormat = ^TDDPixelFormat;
  TDDPixelFormat = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwFourCC: DWORD;
    case Longint of
    0: (
        dwRGBBitCount: DWORD;
        dwRBitMask: DWORD;
        dwGBitMask: DWORD;
        dwBBitMask: DWORD;
        dwRGBAlphaBitMask: DWORD;
       );
    1: (
        dwYUVBitCount: DWORD;
        dwYBitMask: DWORD;
        dwUBitMask: DWORD;
        dwVBitMask: DWORD;
        dwYUVAlphaBitMask: DWORD;
       );
    2: (
        wZBufferBitDepth: DWORD;
       );
    3: (
        dwAlphaBitDepth: DWORD;
       );
  end;

type
  PDDSurfaceDesc = ^TDDSurfaceDesc;
  TDDSurfaceDesc = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwHeight: DWORD;
    dwWidth: DWORD;
    case Longint of
      0: (
          lPitch: Longint;
          dwBackBufferCount: DWORD;
          case Longint of
          0: (
              dwMipMapCount: DWORD;
              dwAlphaBitDepth: DWORD;
              dwReserved: DWORD;
              lpSurface: Pointer;
              ddckCKDestOverlay: TDDColorKey;
              ddckCKDestBlt: TDDColorKey;
              ddckCKSrcOverlay: TDDColorKey;
              ddckCKSrcBlt: TDDColorKey;
              ddpfPixelFormat: TDDPixelFormat;
              ddsCaps: TDDSCaps;
             );
          1: (
              dwZBufferBitDepth: DWORD;
             );
          2: (
              dwRefreshRate: DWORD;
             );
         );
      1: (
          dwLinearSize: DWORD
         );
  end;

type
  PPDirectDrawClipper = ^^IDirectDrawClipper;
  IDirectDrawClipper = packed record
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    GetClipList: function conv arg_stdcall (Self: Pointer; lpRect: PRect; lpClipList: PRgnData; var lpdwSize: DWORD): HResult;
    GetHWnd: function conv arg_stdcall (Self: Pointer; var lphWnd: HWND): HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpDD: PPDirectDrawClipper; dwFlags: DWORD): HResult;
    IsClipListChanged: function conv arg_stdcall (Self: Pointer; var lpbChanged: BOOL): HResult;
    SetClipList: function conv arg_stdcall (Self: Pointer; lpClipList: PRgnData; dwFlags: DWORD): HResult;
    SetHWnd: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; hWnd: HWND): HResult;
  end;

type
  PPUnknown = ^^IUnknown;
  IUnknown = packed record
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
  end;

type
  PPDirectDrawPalette = ^^IDirectDrawPalette;
  IDirectDrawPalette = packed record
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
    GetCaps: function conv arg_stdcall (Self: Pointer; var lpdwCaps: DWORD): HResult;
    GetEntries: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; dwBase: DWORD; dwNumEntries: DWORD; lpEntries: Pointer) : HResult;
    Initialize: function conv arg_stdcall (Self: Pointer; lpDD: Pointer; dwFlags: DWORD; lpDDColorTable: Pointer) : HResult;
    SetEntries: function conv arg_stdcall (Self: Pointer; dwFlags: DWORD; dwStartingEntry: DWORD; dwCount: DWORD; lpEntries: pointer) : HResult;
  end;

type
  PDDBltFX = ^TDDBltFX;
  TDDBltFX = packed record
    dwSize                        : DWORD;
    dwDDFX                        : DWORD;
    dwROP                         : DWORD;
    dwDDROP                       : DWORD;
    dwRotationAngle               : DWORD;
    dwZBufferOpCode               : DWORD;
    dwZBufferLow                  : DWORD;
    dwZBufferHigh                 : DWORD;
    dwZBufferBaseDest             : DWORD;
    dwZDestConstBitDepth          : DWORD;
    case Longint of
    0: (
         dwZDestConst             : DWORD
       );
    1: (
      lpDDSZBufferDest            : Pointer;
      dwZSrcConstBitDepth         : DWORD;
      case Longint of
      0: (
           dwZSrcConst            : DWORD;
         );
      1: (
        lpDDSZBufferSrc           : Pointer;
        dwAlphaEdgeBlendBitDepth  : DWORD;
        dwAlphaEdgeBlend          : DWORD;
        dwReserved                : DWORD;
        dwAlphaDestConstBitDepth  : DWORD;
        case Longint of
        0: (
             dwAlphaDestConst     : DWORD;
           );
        1: (
          lpDDSAlphaDest          : Pointer;
          dwAlphaSrcConstBitDepth : DWORD;
          case Longint of
          0: (
               dwAlphaSrcConst    : DWORD;
             );
          1: (
            lpDDSAlphaSrc         : Pointer;
            case Longint of
            0: (
                 dwFillColor      : DWORD;
               );
            1: (
                 dwFillDepth      : DWORD;
               );
            2: (
                 dwFillPixel      : DWORD;
               );
            3: (
                 lpDDSPattern     : Pointer;
                 ddckDestColorkey : TDDColorKey;
                 ddckSrcColorkey  : TDDColorKey;
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
  TDDEnumSurfacesCallback = function conv arg_stdcall (lpDDSurface: Pointer;
      const lpDDSurfaceDesc: TDDSurfaceDesc; lpContext: Pointer): HResult;

  TDDEnumModesCallback = function conv arg_stdcall (const lpDDSurfaceDesc: TDDSurfaceDesc;
      lpContext: Pointer): HResult;

type
  PDDOverlayFX = ^TDDOverlayFX;
  TDDOverlayFX = packed record
    dwSize: DWORD;
    dwAlphaEdgeBlendBitDepth: DWORD;
    dwAlphaEdgeBlend: DWORD;
    dwReserved: DWORD;
    dwAlphaDestConstBitDepth: DWORD;
    case Longint of
    0: (
         dwAlphaDestConst: DWORD;
         dwAlphaSrcConstBitDepth: DWORD;
         dwAlphaSrcConst: DWORD;
         dckDestColorkey: TDDColorKey;
         dckSrcColorkey: TDDColorKey;
         dwDDFX: DWORD;
         dwFlags: DWORD;
       );
    1: (
         lpDDSAlphaDest: Pointer;
         UNIONFILLER1b: DWORD;
         lpDDSAlphaSrc: Pointer;
       );
  end;

type
  PPDirectDrawSurface = ^^IDirectDrawSurface;
  IDirectDrawSurface = packed record
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
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

type
  PDDCaps = ^TDDCaps;
  TDDCAPS = packed record
    dwSize: DWORD;
    dwCaps: DWORD;
    dwCaps2: DWORD;
    dwCKeyCaps: DWORD;
    dwFXCaps: DWORD;
    dwFXAlphaCaps: DWORD;
    dwPalCaps: DWORD;
    dwSVCaps: DWORD;
    dwAlphaBltConstBitDepths: DWORD;
    dwAlphaBltPixelBitDepths: DWORD;
    dwAlphaBltSurfaceBitDepths: DWORD;
    dwAlphaOverlayConstBitDepths: DWORD;
    dwAlphaOverlayPixelBitDepths: DWORD;
    dwAlphaOverlaySurfaceBitDepths: DWORD;
    dwZBufferBitDepths: DWORD;
    dwVidMemTotal: DWORD;
    dwVidMemFree: DWORD;
    dwMaxVisibleOverlays: DWORD;
    dwCurrVisibleOverlays: DWORD;
    dwNumFourCCCodes: DWORD;
    dwAlignBoundarySrc: DWORD;
    dwAlignSizeSrc: DWORD;
    dwAlignBoundaryDest: DWORD;
    dwAlignSizeDest: DWORD;
    dwAlignStrideAlign: DWORD;
    dwRops: Array [ 0..DD_ROP_SPACE-1 ] of DWORD;
    ddsCaps: TDDSCaps;
    dwMinOverlayStretch: DWORD;
    dwMaxOverlayStretch: DWORD;
    dwMinLiveVideoStretch: DWORD;
    dwMaxLiveVideoStretch: DWORD;
    dwMinHwCodecStretch: DWORD;
    dwMaxHwCodecStretch: DWORD;
    dwReserved1: DWORD;
    dwReserved2: DWORD;
    dwReserved3: DWORD;
    dwSVBCaps: DWORD;
    dwSVBCKeyCaps: DWORD;
    dwSVBFXCaps: DWORD;
    dwSVBRops: Array [ 0..DD_ROP_SPACE-1 ] of DWORD;
    dwVSBCaps: DWORD;
    dwVSBCKeyCaps: DWORD;
    dwVSBFXCaps: DWORD;
    dwVSBRops: Array [ 0..DD_ROP_SPACE-1 ] of DWORD;
    dwSSBCaps: DWORD;
    dwSSBCKeyCaps: DWORD;
    dwSSBFXCaps: DWORD;
    dwSSBRops: Array [ 0..DD_ROP_SPACE-1 ] of DWORD;
    dwMaxVideoPorts: DWORD;
    dwCurrVideoPorts: DWORD;
    dwSVBCaps2: DWORD;
    dwNLVBCaps: DWORD;
    dwNLVBCaps2: DWORD;
    dwNLVBCKeyCaps: DWORD;
    dwNLVBFXCaps: DWORD;
    dwNLVBRops: Array [ 0..DD_ROP_SPACE-1 ] of DWORD;
end;

type
  PPDirectDraw = ^^IDirectDraw;
  IDirectDraw = packed record
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
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
    QueryInterface: function conv arg_stdcall (Self: Pointer; const iid: TIID; var obj): HResult;
    AddRef: function conv arg_stdcall (Self: Pointer): Longint;
    Release: function conv arg_stdcall (Self: Pointer): Longint;
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

function DirectDrawCreate conv arg_stdcall (lpGUID: PGUID; var lplpDD: Pointer; pUnkOuter: Pointer): HResult;
  external 'DDRAW.DLL' name 'DirectDrawCreate';
