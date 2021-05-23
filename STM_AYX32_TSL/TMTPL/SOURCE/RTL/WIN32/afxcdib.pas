(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       CDib Object                                            *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995-98 TMT Development Corporation      *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit AfxCDib;

interface

uses Windows;

type
  CDib = object
  public
    constructor Create(const FileName: String);
    destructor  Free;
    function    Exists: Boolean;
    function    GetDibSizeImage: DWORD;
    function    GetDibWidth: DWORD;
    function    GetDibHeight: DWORD;
    function    GetDibNumColors: DWORD;
    function    GetDibInfoHeaderPtr: PBitMapInfoHeader;
    function    GetDibInfoPtr: PBitMapInfo;
    function    GetDibRGBTablePtr: PRGBQuad;
    function    GetDibBitsPtr: Pointer;
  private
    procedure   LoadBitmapFile(const FileName: String);
    m_pBmFileHeader: PBitMapFileHeader;
    m_pBmInfo:       PBitMapInfo;
    m_pBmInfoHeader: PBitMapInfoHeader;
    m_pRGBTable:     PRGBQuad;
    m_pDibBits:      Pointer;
    m_DibSize:       DWORD;
    m_numColors:     UINT;
end;

implementation

constructor CDib.Create(const FileName: String);
begin
  LoadBitmapFile(FileName);
end;

destructor CDib.Free;
begin
  if m_DibSize <> 0 then
    FreeMem(m_pBmInfo, m_DibSize);
end;

function CDib.Exists: Boolean;
begin
  Result := m_DibSize <> 0;
end;

procedure CDib.LoadBitmapFile(const FileName: String);
var
  bmFileHeader: TBitMapFileHeader;
  f: File;
  fileLength: DWORD;
  pDib: Pointer;
begin
  Assign(f, FileName);
{$i-}
  Reset(f, 1);
  BlockRead(f, bmFileHeader, SizeOf(bmFileHeader));
{$i+}
  if (bmFileHeader.bfType <> $4D42) or (IOResult <> 0) then
  begin
    m_pBmFileHeader := nil;
    m_pBmInfo := nil;
    m_pBmInfoHeader := nil;
    m_pRGBTable := nil;
    m_pDibBits := nil;
    m_numColors := 0;
    m_DibSize := 0;
{$i-}
    Close(f);
{$i+}
  end else
  begin
    fileLength := FileSize(f);
    m_DibSize := fileLength - SizeOf(bmFileHeader);
    GetMem(pDib, m_DibSize);
    BlockRead(f, pDib^, m_DibSize);
    Close(f);
    m_pBmInfo := PBitMapInfo(pDib);
    m_pBmInfoHeader := PBitMapInfoHeader(pDib);
    m_pRGBTable := PRGBQuad(pDib + m_pBmInfoHeader^.biSize);
    m_numColors := GetDibNumColors;
    m_pBmInfoHeader^.biSizeImage := GetDibSizeImage;
    if m_pBmInfoHeader^.biClrUsed = 0 then
      m_pBmInfoHeader^.biClrUsed := m_numColors;
    m_pDibBits := Pointer(pDib + m_pBmInfoHeader^.biSize + (m_numColors * SizeOf(TRGBQuad)));
  end;
end;

function CDib.GetDibSizeImage: DWORD;
begin
  if m_pBmInfoHeader^.biSizeImage = 0 then
    Result := GetDibWidth * GetDibHeight
  else
    Result := m_pBmInfoHeader^.biSizeImage;
end;

function CDib.GetDibWidth: DWORD;
begin
  Result := m_pBmInfoHeader^.biWidth;
end;

function CDib.GetDibHeight: DWORD;
begin
  Result := m_pBmInfoHeader^.biHeight;
end;

function CDib.GetDibNumColors: DWORD;
begin
 if (m_pBmInfoHeader^.biClrUsed = 0) and
  (m_pBmInfoHeader^.biBitCount < 9) then
    Result := 1 shl m_pBmInfoHeader^.biBitCount
  else
    Result := m_pBmInfoHeader^.biClrUsed;
end;

function CDib.GetDibInfoHeaderPtr: PBitMapInfoHeader;
begin
  Result := m_pBmInfoHeader;
end;

function CDib.GetDibInfoPtr: PBitMapInfo;
begin
  Result := m_pBmInfo;
end;

function CDib.GetDibRGBTablePtr: PRGBQuad;
begin
  Result := m_pRGBTable;
end;

function CDib.GetDibBitsPtr: Pointer;
begin
  Result := m_pDibBits;
end;

end.