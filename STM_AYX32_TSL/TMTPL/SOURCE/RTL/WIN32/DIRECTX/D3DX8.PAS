
(******************************************************************************
 *
 *  Copyright (C) 1999 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       d3dx8.h, d3dx8core.h, d3dx8math.h, d3dx8math.inl,
 *              d3dx8effect.h, d3dx8mesh.h, d3dx8shape.h, d3dx8tex.h
 *  Content:    Direct3DX 8.0b headers
 *
 *  TMT Pascal adaptation by Alexey Barkovoy
 *  E-Mail: clootie@reactor.ru
 *
 *  Modified: 24-Sep-2001
 *
 *  Partly based upon :
 *    Direct3DX 7.0 Object Pascal adaptation by
 *      Arne Schäpers, e-Mail: [look at www.delphi-jedi.org/DelphiGraphics/]
 *
 *  Latest version can be downloaded from:
 *     http://delphi-jedi.org
 *     http://www.delphi-jedi.org/DelphiGraphics/
 *     http://clootie.narod.ru/DelphiGraphics/index.html
 *
 *  This File contains only Direct3DX 8.x Definitions.
 *  If you want to use D3DX7 version of D3DX use translation by Arne Schäpers
 *
 ******************************************************************************)
{                                                                              }
{ Obtained through: Joint Endeavour of Delphi Innovators (Project JEDI)        }
{                                                                              }
{ The contents of this file are used with permission, subject to the Mozilla   }
{ Public License Version 1.1 (the "License"); you may not use this file except }
{ in compliance with the License. You may obtain a copy of the License at      }
{ http://www.mozilla.org/MPL/MPL-1.1.html                                      }
{                                                                              }
{ Software distributed under the License is distributed on an "AS IS" basis,   }
{ WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for }
{ the specific language governing rights and limitations under the License.    }
{                                                                              }
{ Alternatively, the contents of this file may be used under the terms of the  }
{ GNU Lesser General Public License (the  "LGPL License"), in which case the   }
{ provisions of the LGPL License are applicable instead of those above.        }
{ If you wish to allow use of your version of this file only under the terms   }
{ of the LGPL License and not to allow others to use your version of this file }
{ under the MPL, indicate your decision by deleting  the provisions above and  }
{ replace  them with the notice and other provisions required by the LGPL      }
{ License.  If you do not delete the provisions above, a recipient may use     }
{ your version of this file under either the MPL or the LGPL License.          }
{                                                                              }
{ For more information about the LGPL: http://www.gnu.org/copyleft/lesser.html }
{                                                                              }
{******************************************************************************}

unit D3DX8;

{$i directx.inc}

interface


uses
  Windows,
  ActiveX,
  Strings,
  D3D8,
  DXFile;

const
  //////////// DLL export definitions ///////////////////////////////////////
  d3dx8dll ={$IFDEF DEBUG} 'D3DX8abD.dll'{$ELSE} 'D3DX8ab.dll'{$ENDIF};


///////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 1999 Microsoft Corporation.  All Rights Reserved.
//
//  File:       d3dx8.h
//  Content:    D3DX utility library
//
///////////////////////////////////////////////////////////////////////////

const
  // #define D3DX_DEFAULT ULONG_MAX
  D3DX_DEFAULT          = $FFFFFFFF;

var
  // #define D3DX_DEFAULT_FLOAT FLT_MAX
  // Forced to define as 'var' cos TMT Pascal compiler treats all
  // consts as Double
  D3DX_DEFAULT_FLOAT: Single = 3.402823466e+38;  // max single value




//////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 1998 Microsoft Corporation.  All Rights Reserved.
//
//  File:       d3dx8math.h
//  Content:    D3DX math types and functions
//
//////////////////////////////////////////////////////////////////////////////

//===========================================================================
//
// General purpose utilities
//
//===========================================================================
const
  D3DX_PI: Single       = 3.141592654;
  D3DX_1BYPI: Single    = 0.318309886;

//#define D3DXToRadian( degree ) ((degree) * (D3DX_PI / 180.0f))
function D3DXToRadian(Degree: Single): Single;
//#define D3DXToDegree( radian ) ((radian) * (180.0f / D3DX_PI))
function D3DXToDegree(Radian: Single): Single;


//===========================================================================
//
// Vectors
//
//===========================================================================

//--------------------------
// 2D Vector
//--------------------------
type
  PD3DXVector2 = ^TD3DXVector2;
  TD3DXVector2 = packed record
    x, y: Single;
  end;

// Some pascal equalents of C++ class functions & operators
const D3DXVector2Zero: TD3DXVector2 = (x:0; y:0);  // (0,0)
function D3DXVector2(_x, _y: Single): TD3DXVector2;
function D3DXVector2Equal(const v1, v2: TD3DXVector2): Boolean;


//--------------------------
// 3D Vector
//--------------------------
type
  PD3DXVector3 = ^TD3DXVector3;
  TD3DXVector3 = TD3DVector;

// Some pascal equalents of C++ class functions & operators
const D3DXVector3Zero: TD3DXVector3 = (x:0; y:0; z:0);  // (0,0,0)
function D3DXVector3(_x, _y, _z: Single): TD3DXVector3;
function D3DXVector3Equal(const v1, v2: TD3DXVector3): Boolean;


//--------------------------
// 4D Vector
//--------------------------
type
  PD3DXVector4 = ^TD3DXVector4;
  TD3DXVector4 = packed record
    x, y, z, w: Single;
  end;

// Some pascal equalents of C++ class functions & operators
const D3DXVector4Zero: TD3DXVector4 = (x:0; y:0; z:0; w:0);  // (0,0,0,0)
function D3DXVector4(_x, _y, _z, _w: Single): TD3DXVector4;
function D3DXVector4Equal(const v1, v2: TD3DXVector4): Boolean;

//===========================================================================
//
// Matrices
//
//===========================================================================
type
  PD3DXMatrix = ^TD3DXMatrix;
  TD3DXMatrix = TD3DMatrix;

// Some pascal equalents of C++ class functions & operators
function D3DXMatrix(
  _m00, _m01, _m02, _m03,
  _m10, _m11, _m12, _m13,
  _m20, _m21, _m22, _m23,
  _m30, _m31, _m32, _m33: Single): TD3DXMatrix;
function D3DXMatrixAdd(out mOut: TD3DXMatrix; const m1, m2: TD3DXMatrix): PD3DXMatrix;
function D3DXMatrixSubtract(out mOut: TD3DXMatrix; const m1, m2: TD3DXMatrix): PD3DXMatrix;
function D3DXMatrixMul(out mOut: TD3DXMatrix; const m: TD3DXMatrix; MulBy: Single): PD3DXMatrix;
function D3DXMatrixEqual(const m1, m2: TD3DXMatrix): Boolean;


//===========================================================================
//
//    Quaternions
//
//===========================================================================
type
  PD3DXQuaternion = ^TD3DXQuaternion;
  TD3DXQuaternion = packed record
    x, y, z, w: Single;
  end;

// Some pascal equalents of C++ class functions & operators
function D3DXQuaternion(_x, _y, _z, _w: Single): TD3DXQuaternion;
function D3DXQuaternionAdd(const q1, q2: TD3DXQuaternion): TD3DXQuaternion;
function D3DXQuaternionSubtract(const q1, q2: TD3DXQuaternion): TD3DXQuaternion;
function D3DXQuaternionEqual(const q1, q2: TD3DXQuaternion): Boolean;
function D3DXQuaternionScale(out qOut: TD3DXQuaternion; const q: TD3DXQuaternion;
  s: Single): PD3DXQuaternion;


//===========================================================================
//
// Planes
//
//===========================================================================
type
  PD3DXPlane = ^TD3DXPlane;
  TD3DXPlane = packed record
    a, b, c, d: Single;
  end;

// Some pascal equalents of C++ class functions & operators
const D3DXPlaneZero: TD3DXPlane = (a:0; b:0; c:0; d:0);  // (0,0,0,0)
function D3DXPlane(_a, _b, _c, _d: Single): TD3DXPlane;
function D3DXPlaneEqual(const p1, p2: TD3DXPlane): Boolean;


//===========================================================================
//
// Colors
//
//===========================================================================
type
  PD3DXColor = ^TD3DXColor;
  TD3DXColor = packed record
    r, g, b, a: Single;
  end;

function D3DXColor(_r, _g, _b, _a: Single): TD3DXColor;
function D3DXColorToDWord(c: TD3DXColor): DWord;
function D3DXColorFromDWord(c: DWord): TD3DXColor;
function D3DXColorEqual(const c1, c2: TD3DXColor): Boolean;


//===========================================================================
//
// D3DX math functions:
//
// NOTE:
//  * All these functions can take the same object as in and out parameters.
//
//  * Out parameters are typically also returned as return values, so that
//    the output of one function may be used as a parameter to another.
//
//===========================================================================

//--------------------------
// 2D Vector
//--------------------------

// inline

function D3DXVec2Length(const v: TD3DXVector2): Single;

function D3DXVec2LengthSq(const v: TD3DXVector2): Single;

function D3DXVec2Dot(const v1, v2: TD3DXVector2): Single;

// Z component of ((x1,y1,0) cross (x2,y2,0))
function D3DXVec2CCW (const v1, v2: TD3DXVector2): Single;

function D3DXVec2Add(const v1, v2: TD3DXVector2): TD3DXVector2;

function D3DXVec2Subtract(const v1, v2: TD3DXVector2): TD3DXVector2;

// Minimize each component.  x = min(x1, x2), y = min(y1, y2)
function D3DXVec2Minimize(out vOut: TD3DXVector2; const v1, v2: TD3DXVector2): PD3DXVector2;

// Maximize each component.  x = max(x1, x2), y = max(y1, y2)
function D3DXVec2Maximize(out vOut: TD3DXVector2; const v1, v2: TD3DXVector2): PD3DXVector2;

function D3DXVec2Scale(out vOut: TD3DXVector2; const v: TD3DXVector2; s: Single): PD3DXVector2;

// Linear interpolation. V1 + s(V2-V1)
function D3DXVec2Lerp(out vOut: TD3DXVector2; const v1, v2: TD3DXVector2; s: Single): PD3DXVector2;

// non-inline
function D3DXVec2Normalize(out vOut: TD3DXVector2; const v: TD3DXVector2): PD3DXVector2; stdcall;

// Hermite interpolation between position V1, tangent T1 (when s == 0)
// and position V2, tangent T2 (when s == 1).
function D3DXVec2Hermite(out vOut: TD3DXVector2;
   const v1, t1, v2, t2: TD3DXVector2; s: Single): PD3DXVector2; stdcall;

// CatmullRom interpolation between V1 (when s == 0) and V2 (when s == 1)
function D3DXVec2CatmullRom(out vOut: TD3DXVector2;
   const v0, v1, v2: TD3DXVector2; s: Single): PD3DXVector2; stdcall;

// Barycentric coordinates.  V1 + f(V2-V1) + g(V3-V1)
function D3DXVec2BaryCentric(out vOut: TD3DXVector2;
   const v1, v2, v3: TD3DXVector2; f, g: Single): PD3DXVector2; stdcall;

// Transform (x, y, 0, 1) by matrix.
function D3DXVec2Transform(out vOut: TD3DXVector4;
  const v: TD3DXVector2; const m: TD3DXMatrix): PD3DXVector4; stdcall;

// Transform (x, y, 0, 1) by matrix, project result back into w=1.
function D3DXVec2TransformCoord(out vOut: TD3DXVector2;
  const v: TD3DXVector2; const m: TD3DXMatrix): PD3DXVector2; stdcall;

// Transform (x, y, 0, 0) by matrix.
function D3DXVec2TransformNormal(out vOut: TD3DXVector2;
  const v: TD3DXVector2; const m: TD3DXMatrix): PD3DXVector2; stdcall;


//--------------------------
// 3D Vector
//--------------------------

// inline

function D3DXVec3Length(const v: TD3DXVector3): Single;

function D3DXVec3LengthSq(const v: TD3DXVector3): Single;

function D3DXVec3Dot(const v1, v2: TD3DXVector3): Single;

function D3DXVec3Cross(out vOut: TD3DXVector3; const v1, v2: TD3DXVector3): PD3DXVector3;

function D3DXVec3Add(out vOut: TD3DXVector3; const v1, v2: TD3DXVector3): PD3DXVector3;

function D3DXVec3Subtract(out vOut: TD3DXVector3; const v1, v2: TD3DXVector3): PD3DXVector3;

// Minimize each component.  x = min(x1, x2), y = min(y1, y2), ...
function D3DXVec3Minimize(out vOut: TD3DXVector3; const v1, v2: TD3DXVector3): PD3DXVector3;

// Maximize each component.  x = max(x1, x2), y = max(y1, y2), ...
function D3DXVec3Maximize(out vOut: TD3DXVector3; const v1, v2: TD3DXVector3): PD3DXVector3;

function D3DXVec3Scale(out vOut: TD3DXVector3; const v: TD3DXVector3; s: Single): PD3DXVector3;

// Linear interpolation. V1 + s(V2-V1)
function D3DXVec3Lerp(out vOut: TD3DXVector3;
  const v1, v2: TD3DXVector3; s: Single): PD3DXVector3;

// non-inline

function D3DXVec3Normalize(out vOut: TD3DXVector3;
   const v: TD3DXVector3): PD3DXVector3; stdcall;

// Hermite interpolation between position V1, tangent T1 (when s == 0)
// and position V2, tangent T2 (when s == 1).
function D3DXVec3Hermite(out vOut: TD3DXVector3;
   const v1, t1, v2, t2: TD3DXVector3; s: Single): PD3DXVector3; stdcall;

// CatmullRom interpolation between V1 (when s == 0) and V2 (when s == 1)
function D3DXVec3CatmullRom(out vOut: TD3DXVector3;
   const v1, v2, v3: TD3DXVector3; s: Single): PD3DXVector3; stdcall;

// Barycentric coordinates.  V1 + f(V2-V1) + g(V3-V1)
function D3DXVec3BaryCentric(out vOut: TD3DXVector3;
   const v1, v2, v3: TD3DXVector3; f, g: Single): PD3DXVector3; stdcall;

// Transform (x, y, z, 1) by matrix.
function D3DXVec3Transform(out vOut: TD3DXVector4;
  const v: TD3DXVector3; const m: TD3DXMatrix): PD3DXVector4; stdcall;

// Transform (x, y, z, 1) by matrix, project result back into w=1.
function D3DXVec3TransformCoord(out vOut: TD3DXVector3;
  const v: TD3DXVector3; const m: TD3DXMatrix): PD3DXVector3; stdcall;

// Transform (x, y, z, 0) by matrix.  If you transforming a normal by a
// non-affine matrix, the matrix you pass to this function should be the
// transpose of the inverse of the matrix you would use to transform a coord.
function D3DXVec3TransformNormal(out vOut: TD3DXVector3;
  const v: TD3DXVector3; const m: TD3DXMatrix): PD3DXVector3; stdcall;

// Project vector from object space into screen space
function D3DXVec3Project(out vOut: TD3DXVector3;
  const v: TD3DXVector3; const pViewport: TD3DViewport8;
  const pProjection, pView, pWorld: TD3DXMatrix): PD3DXVector3; stdcall;

// Project vector from screen space into object space
function D3DXVec3Unproject(out vOut: TD3DXVector3;
  const v: TD3DXVector3; const pViewport: TD3DViewport8;
  const pProjection, pView, pWorld: TD3DXMatrix): PD3DXVector3; stdcall;


//--------------------------
// 4D Vector
//--------------------------

// inline

function D3DXVec4Length(const v: TD3DXVector4): Single;

function D3DXVec4LengthSq(const v: TD3DXVector4): Single;

function D3DXVec4Dot(const v1, v2: TD3DXVector4): Single;

function D3DXVec4Add(out vOut: TD3DXVector4; const v1, v2: TD3DXVector4): PD3DXVector4;

function D3DXVec4Subtract(out vOut: TD3DXVector4; const v1, v2: TD3DXVector4): PD3DXVector4;

// Minimize each component.  x = min(x1, x2), y = min(y1, y2), ...
function D3DXVec4Minimize(out vOut: TD3DXVector4; const v1, v2: TD3DXVector4): PD3DXVector4;

// Maximize each component.  x = max(x1, x2), y = max(y1, y2), ...
function D3DXVec4Maximize(out vOut: TD3DXVector4; const v1, v2: TD3DXVector4): PD3DXVector4;

function D3DXVec4Scale(out vOut: TD3DXVector4; const v: TD3DXVector4; s: Single): PD3DXVector4;

// Linear interpolation. V1 + s(V2-V1)
function D3DXVec4Lerp(out vOut: TD3DXVector4;
  const v1, v2: TD3DXVector4; s: Single): PD3DXVector4;

// non-inline

// Cross-product in 4 dimensions.
function D3DXVec4Cross(out vOut: TD3DXVector4;
  const v1, v2, v3: TD3DXVector4): PD3DXVector4; stdcall;

function D3DXVec4Normalize(out vOut: TD3DXVector4;
  const v: TD3DXVector4): PD3DXVector4; stdcall;

// Hermite interpolation between position V1, tangent T1 (when s == 0)
// and position V2, tangent T2 (when s == 1).
function D3DXVec4Hermite(out vOut: TD3DXVector4;
   const v1, t1, v2, t2: TD3DXVector4; s: Single): PD3DXVector4; stdcall;

// CatmullRom interpolation between V1 (when s == 0) and V2 (when s == 1)
function D3DXVec4CatmullRom(out vOut: TD3DXVector4;
   const v0, v1, v2, v3: TD3DXVector4; s: Single): PD3DXVector4; stdcall;

// Barycentric coordinates.  V1 + f(V2-V1) + g(V3-V1)
function D3DXVec4BaryCentric(out vOut: TD3DXVector4;
   const v1, v2, v3: TD3DXVector4; f, g: Single): PD3DXVector4; stdcall;

// Transform vector by matrix.
function D3DXVec4Transform(out vOut: TD3DXVector4;
  const v: TD3DXVector4; const m: TD3DXMatrix): PD3DXVector4; stdcall;


//--------------------------
// 4D Matrix
//--------------------------

// inline

function D3DXMatrixIdentity(out mOut: TD3DXMatrix): PD3DXMatrix;

function D3DXMatrixIsIdentity(const m: TD3DXMatrix): BOOL;

// non-inline

function D3DXMatrixfDeterminant(const m: TD3DXMatrix): Single; stdcall;

// Matrix multiplication.  The result represents the transformation M2
// followed by the transformation M1.  (Out = M1 * M2)
function D3DXMatrixMultiply(out mOut: TD3DXMatrix; const m1, m2: TD3DXMatrix): PD3DXMatrix; stdcall;

function D3DXMatrixTranspose(out mOut: TD3DXMatrix; const m: TD3DXMatrix): PD3DXMatrix; stdcall;

// Calculate inverse of matrix.  Inversion my fail, in which case NULL will
// be returned.  The determinant of pM is also returned it pfDeterminant
// is non-NULL.
function D3DXMatrixInverse(out mOut: TD3DXMatrix; pfDeterminant: PSingle;
    const m: TD3DXMatrix): PD3DXMatrix; stdcall;

// Build a matrix which scales by (sx, sy, sz)
function D3DXMatrixScaling(out mOut: TD3DXMatrix; sx, sy, sz: Single): PD3DXMatrix; stdcall;

// Build a matrix which translates by (x, y, z)
function D3DXMatrixTranslation(out mOut: TD3DXMatrix; x, y, z: Single): PD3DXMatrix; stdcall;

// Build a matrix which rotates around the X axis
function D3DXMatrixRotationX(out mOut: TD3DXMatrix; angle: Single): PD3DXMatrix; stdcall;

// Build a matrix which rotates around the Y axis
function D3DXMatrixRotationY(out mOut: TD3DXMatrix; angle: Single): PD3DXMatrix; stdcall;

// Build a matrix which rotates around the Z axis
function D3DXMatrixRotationZ(out mOut: TD3DXMatrix; angle: Single): PD3DXMatrix; stdcall;

// Build a matrix which rotates around an arbitrary axis
function D3DXMatrixRotationAxis(out mOut: TD3DXMatrix; const v: TD3DXVector3;
  angle: Single): PD3DXMatrix; stdcall;

// Build a matrix from a quaternion
function D3DXMatrixRotationQuaternion(out mOut: TD3DXMatrix; const Q: TD3DXQuaternion): PD3DXMatrix; stdcall;

// Yaw around the Y axis, a pitch around the X axis,
// and a roll around the Z axis.
function D3DXMatrixRotationYawPitchRoll(out mOut: TD3DXMatrix; yaw, pitch, roll: Single): PD3DXMatrix; stdcall;


// Build transformation matrix.  NULL arguments are treated as identity.
// Mout = Msc-1 * Msr-1 * Ms * Msr * Msc * Mrc-1 * Mr * Mrc * Mt
function D3DXMatrixTransformation(out mOut: TD3DXMatrix;
   pScalingCenter: PD3DXVector3;
   pScalingRotation: PD3DXQuaternion; pScaling, pRotationCenter: PD3DXVector3;
   pRotation: PD3DXQuaternion; pTranslation: PD3DXVector3): PD3DXMatrix; stdcall;

// Build affine transformation matrix.  NULL arguments are treated as identity.
// Mout = Ms * Mrc-1 * Mr * Mrc * Mt
function D3DXMatrixAffineTransformation(out mOut: TD3DXMatrix;
   Scaling: Single; pRotationCenter: PD3DXVector3;
   pRotation: PD3DXQuaternion; pTranslation: PD3DXVector3): PD3DXMatrix; stdcall;

// Build a lookat matrix. (right-handed)
function D3DXMatrixLookAtRH(out mOut: TD3DXMatrix; const Eye, At, Up: TD3DXVector3): PD3DXMatrix; stdcall;

// Build a lookat matrix. (left-handed)
function D3DXMatrixLookAtLH(out mOut: TD3DXMatrix; const Eye, At, Up: TD3DXVector3): PD3DXMatrix; stdcall;

// Build a perspective projection matrix. (right-handed)
function D3DXMatrixPerspectiveRH(out mOut: TD3DXMatrix; w, h, zn, zf: Single): PD3DXMatrix; stdcall;

// Build a perspective projection matrix. (left-handed)
function D3DXMatrixPerspectiveLH(out mOut: TD3DXMatrix; w, h, zn, zf: Single): PD3DXMatrix; stdcall;

// Build a perspective projection matrix. (right-handed)
function D3DXMatrixPerspectiveFovRH(out mOut: TD3DXMatrix; flovy, aspect, zn, zf: Single): PD3DXMatrix; stdcall;

// Build a perspective projection matrix. (left-handed)
function D3DXMatrixPerspectiveFovLH(out mOut: TD3DXMatrix; flovy, aspect, zn, zf: Single): PD3DXMatrix; stdcall;

// Build a perspective projection matrix. (right-handed)
function D3DXMatrixPerspectiveOffCenterRH(out mOut: TD3DXMatrix;
   l, r, b, t, zn, zf: Single): PD3DXMatrix; stdcall;

// Build a perspective projection matrix. (left-handed)
function D3DXMatrixPerspectiveOffCenterLH(out mOut: TD3DXMatrix;
   l, r, b, t, zn, zf: Single): PD3DXMatrix; stdcall;

// Build an ortho projection matrix. (right-handed)
function D3DXMatrixOrthoRH(out mOut: TD3DXMatrix; w, h, zn, zf: Single): PD3DXMatrix; stdcall;

// Build an ortho projection matrix. (left-handed)
function D3DXMatrixOrthoLH(out mOut: TD3DXMatrix; w, h, zn, zf: Single): PD3DXMatrix; stdcall;

// Build an ortho projection matrix. (right-handed)
function D3DXMatrixOrthoOffCenterRH(out mOut: TD3DXMatrix;
  l, r, b, t, zn, zf: Single): PD3DXMatrix; stdcall;

// Build an ortho projection matrix. (left-handed)
function D3DXMatrixOrthoOffCenterLH(out mOut: TD3DXMatrix;
  l, r, b, t, zn, zf: Single): PD3DXMatrix; stdcall;

// Build a matrix which flattens geometry into a plane, as if casting
// a shadow from a light.
function D3DXMatrixShadow(out mOut: TD3DXMatrix;
  const Light: TD3DXVector4; const Plane: TD3DXPlane): PD3DXMatrix; stdcall;

// Build a matrix which reflects the coordinate system about a plane
function D3DXMatrixReflect(out mOut: TD3DXMatrix;
   const Plane: TD3DXPlane): PD3DXMatrix; stdcall;


//--------------------------
// Quaternion
//--------------------------

// inline

function D3DXQuaternionLength(const q: TD3DXQuaternion): Single;

// Length squared, or "norm"
function D3DXQuaternionLengthSq(const q: TD3DXQuaternion): Single;

function D3DXQuaternionDot(const q1, q2: TD3DXQuaternion): Single;

// (0, 0, 0, 1)
function D3DXQuaternionIdentity(out qOut: TD3DXQuaternion): PD3DXQuaternion;

function D3DXQuaternionIsIdentity (const q: TD3DXQuaternion): BOOL;

// (-x, -y, -z, w)
function D3DXQuaternionConjugate(out qOut: TD3DXQuaternion;
  const q: TD3DXQuaternion): PD3DXQuaternion;


// non-inline

// Compute a quaternin's axis and angle of rotation. Expects unit quaternions.
procedure D3DXQuaternionToAxisAngle(const q: TD3DXQuaternion;
  out Axis: TD3DXVector3; out Angle: Single); stdcall;

// Build a quaternion from a rotation matrix.
function D3DXQuaternionRotationMatrix(out qOut: TD3DXQuaternion;
  const m: TD3DXMatrix): PD3DXQuaternion; stdcall;

// Rotation about arbitrary axis.
function D3DXQuaternionRotationAxis(out qOut: TD3DXQuaternion;
  const v: TD3DXVector3; Angle: Single): PD3DXQuaternion; stdcall;

// Yaw around the Y axis, a pitch around the X axis,
// and a roll around the Z axis.
function D3DXQuaternionRotationYawPitchRoll(out qOut: TD3DXQuaternion;
  yaw, pitch, roll: Single): PD3DXQuaternion; stdcall;

// Quaternion multiplication.  The result represents the rotation Q2
// followed by the rotation Q1.  (Out = Q2 * Q1)
function D3DXQuaternionMultiply(out qOut: TD3DXQuaternion;
   const q1, q2: TD3DXQuaternion): PD3DXQuaternion; stdcall;

function D3DXQuaternionNormalize(out qOut: TD3DXQuaternion;
   const q: TD3DXQuaternion): PD3DXQuaternion; stdcall;

// Conjugate and re-norm
function D3DXQuaternionInverse(out qOut: TD3DXQuaternion;
   const q: TD3DXQuaternion): PD3DXQuaternion; stdcall;

// Expects unit quaternions.
// if q = (cos(theta), sin(theta) * v); ln(q) = (0, theta * v)
function D3DXQuaternionLn(out qOut: TD3DXQuaternion;
   const q: TD3DXQuaternion): PD3DXQuaternion; stdcall;

// Expects pure quaternions. (w == 0)  w is ignored in calculation.
// if q = (0, theta * v); exp(q) = (cos(theta), sin(theta) * v)
function D3DXQuaternionExp(out qOut: TD3DXQuaternion;
   const q: TD3DXQuaternion): PD3DXQuaternion; stdcall;

// Spherical linear interpolation between Q1 (s == 0) and Q2 (s == 1).
// Expects unit quaternions.
function D3DXQuaternionSlerp(out qOut: TD3DXQuaternion;
   const q1, q2: TD3DXQuaternion; t: Single): PD3DXQuaternion; stdcall;

// Spherical quadrangle interpolation.
// Slerp(Slerp(Q1, Q4, t), Slerp(Q2, Q3, t), 2t(1-t))
function D3DXQuaternionSquad(out qOut: TD3DXQuaternion;
   const q1, q2, q3, q4: TD3DXQuaternion; t: Single): PD3DXQuaternion; stdcall;

// Slerp(Slerp(Q1, Q2, f+g), Slerp(Q1, Q3, f+g), g/(f+g))
function D3DXQuaternionBaryCentric(out qOut: TD3DXQuaternion;
   const q1, q2, q3: TD3DXQuaternion; f, g: Single): PD3DXQuaternion; stdcall;


//--------------------------
// Plane
//--------------------------

// inline

// ax + by + cz + dw
function D3DXPlaneDot(const p: TD3DXPlane; const v: TD3DXVector4): Single;

// ax + by + cz + d
function D3DXPlaneDotCoord(const p: TD3DXPlane; const v: TD3DXVector3): Single;

// ax + by + cz
function D3DXPlaneDotNormal(const p: TD3DXPlane; const v: TD3DXVector3): Single;


// non-inline

// Normalize plane (so that |a,b,c| == 1)
function D3DXPlaneNormalize(out pOut: TD3DXPlane; const p: TD3DXPlane): PD3DXPlane; stdcall;

// Find the intersection between a plane and a line.  If the line is
// parallel to the plane, NULL is returned.
function D3DXPlaneIntersectLine(out vOut: TD3DXVector3;
   const p: TD3DXPlane; const v1, v2: TD3DXVector3): PD3DXVector3; stdcall;

// Construct a plane from a point and a normal
function D3DXPlaneFromPointNormal(out pOut: TD3DXPlane;
   const vPoint, vNormal: TD3DXVector3): PD3DXPlane; stdcall;

// Construct a plane from 3 points
function D3DXPlaneFromPoints(out pOut: TD3DXPlane;
   const v1, v2, v3: TD3DXVector3): PD3DXPlane; stdcall;

// Transform a plane by a matrix.  The vector (a,b,c) must be normal.
// M must be an affine transform.
function D3DXPlaneTransform(out pOut: TD3DXPlane; const m: TD3DXMatrix): PD3DXPlane; stdcall;


//--------------------------
// Color
//--------------------------

// inline

// (1-r, 1-g, 1-b, a)
function D3DXColorNegative(out cOut: TD3DXColor; const c: TD3DXColor): PD3DXColor;

function D3DXColorAdd(out cOut: TD3DXColor; const c1, c2: TD3DXColor): PD3DXColor;

function D3DXColorSubtract(out cOut: TD3DXColor; const c1, c2: TD3DXColor): PD3DXColor;

function D3DXColorScale(out cOut: TD3DXColor; const c: TD3DXColor; s: Single): PD3DXColor;

// (r1*r2, g1*g2, b1*b2, a1*a2)
function D3DXColorModulate(out cOut: TD3DXColor; const c1, c2: TD3DXColor): PD3DXColor;

// Linear interpolation of r,g,b, and a. C1 + s(C2-C1)
function D3DXColorLerp(out cOut: TD3DXColor; const c1, c2: TD3DXColor; s: Single): PD3DXColor;

// non-inline

// Interpolate r,g,b between desaturated color and color.
// DesaturatedColor + s(Color - DesaturatedColor)
function D3DXColorAdjustSaturation(out cOut: TD3DXColor;
   const pC: TD3DXColor; s: Single): PD3DXColor; stdcall;

// Interpolate r,g,b between 50% grey and color.  Grey + s(Color - Grey)
function D3DXColorAdjustContrast(out cOut: TD3DXColor;
   const pC: TD3DXColor; c: Single): PD3DXColor; stdcall;


//===========================================================================
//
//    Matrix Stack
//
//===========================================================================

type
  ID3DXMatrixStack = interface(IUnknown)
    ['{E3357330-CC5E-11d2-A434-00A0C90629A8}']
    //
    // ID3DXMatrixStack methods
    //

    // Pops the top of the stack, returns the current top
    // *after* popping the top.
    function Pop: HResult; stdcall;

    // Pushes the stack by one, duplicating the current matrix.
    function Push: HResult; stdcall;

    // Loads identity in the current matrix.
    function LoadIdentity: HResult; stdcall;

    // Loads the given matrix into the current matrix
    function LoadMatrix(const M: TD3DXMatrix): HResult; stdcall;

    // Right-Multiplies the given matrix to the current matrix.
    // (transformation is about the current world origin)
    function MultMatrix(const M: TD3DXMatrix): HResult; stdcall;

    // Left-Multiplies the given matrix to the current matrix
    // (transformation is about the local origin of the object)
    function MultMatrixLocal(const M: TD3DXMatrix): HResult; stdcall;

    // Right multiply the current matrix with the computed rotation
    // matrix, counterclockwise about the given axis with the given angle.
    // (rotation is about the current world origin)
    function RotateAxis(const V: TD3DXVector3; Angle: Single): HResult; stdcall;

    // Left multiply the current matrix with the computed rotation
    // matrix, counterclockwise about the given axis with the given angle.
    // (rotation is about the local origin of the object)
    function RotateAxisLocal(const V: TD3DXVector3; Angle: Single): HResult; stdcall;

    // Right multiply the current matrix with the computed rotation
    // matrix. All angles are counterclockwise. (rotation is about the
    // current world origin)

    // The rotation is composed of a yaw around the Y axis, a pitch around
    // the X axis, and a roll around the Z axis.
    function RotateYawPitchRoll(yaw, pitch, roll: Single): HResult; stdcall;

    // Left multiply the current matrix with the computed rotation
    // matrix. All angles are counterclockwise. (rotation is about the
    // local origin of the object)

    // The rotation is composed of a yaw around the Y axis, a pitch around
    // the X axis, and a roll around the Z axis.
    function RotateYawPitchRollLocal(yaw, pitch, roll: Single): HResult; stdcall;

    // Right multiply the current matrix with the computed scale
    // matrix. (transformation is about the current world origin)
    function Scale(x, y, z: Single): HResult; stdcall;

    // Left multiply the current matrix with the computed scale
    // matrix. (transformation is about the local origin of the object)
    function ScaleLocal(x, y, z: Single): HResult; stdcall;

    // Right multiply the current matrix with the computed translation
    // matrix. (transformation is about the current world origin)
    function Translate(x, y, z: Single): HResult; stdcall;

    // Left multiply the current matrix with the computed translation
    // matrix. (transformation is about the local origin of the object)
    function TranslateLocal(x, y, z: Single): HResult; stdcall;

    // Obtain the current matrix at the top of the stack
    function GetTop: PD3DXMatrix; stdcall;
  end;

type
  IID_ID3DXMatrixStack = ID3DXMatrixStack;

function D3DXCreateMatrixStack(Flags: DWord; out Stack: ID3DXMatrixStack): HResult; stdcall;







///////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 1999 Microsoft Corporation.  All Rights Reserved.
//
//  File:       d3dx8core.h
//  Content:    D3DX core types and functions
//
///////////////////////////////////////////////////////////////////////////

type
///////////////////////////////////////////////////////////////////////////
// ID3DXBuffer:
// ------------
// The buffer object is used to return arbitrary lenght data.
///////////////////////////////////////////////////////////////////////////

  PID3DXBuffer = ^ID3DXBuffer;
  ID3DXBuffer = interface(IUnknown)
    ['{932E6A7E-C68E-45dd-A7BF-53D19C86DB1F}']
    // ID3DXBuffer
    function GetBufferPointer: Pointer; stdcall;
    function GetBufferSize: DWord; stdcall;
  end;



///////////////////////////////////////////////////////////////////////////
// ID3DXFont:
// ----------
// Font objects contain the textures and resources needed to render
// a specific font on a specific device.
//
// Begin -
//    Prepartes device for drawing text.  This is optional.. if DrawText
//    is called outside of Begin/End, it will call Begin and End for you.
//
// DrawText -
//    Draws formatted text on a D3D device.  Some parameters are
//    surprisingly similar to those of GDI's DrawText function.  See GDI
//    documentation for a detailed description of these parameters.
//
// End -
//    Restores device state to how it was when Begin was called.
///////////////////////////////////////////////////////////////////////////

  ID3DXFont = interface(IUnknown)
    ['{2D501DF7-D253-4414-865F-A6D54A753138}']
    // ID3DXFont
    function GetDevice(out ppDevice: IDirect3DDevice8): HResult; stdcall;
    function GetLogFont(out pLogFont: TLogFont): HResult; stdcall;

    function _Begin: HResult; stdcall;

    function DrawTextA(pString: PAnsiChar; Count: Integer; const pRect: TRect; Format: DWord; Color: TD3DColor): Integer; stdcall;
    function DrawTextW(pString: PWideChar; Count: Integer; const pRect: TRect; Format: DWord; Color: TD3DColor): Integer; stdcall;

    function _End: HResult; stdcall;
  end;


function D3DXCreateFont(pDevice: IDirect3DDevice8; hFont: HFONT;
  out ppFont: ID3DXFont): HResult; stdcall;

function D3DXCreateFontIndirect(pDevice: IDirect3DDevice8;
  const pLogFont: TLogFont; out ppFont: ID3DXFont): HResult; stdcall;



///////////////////////////////////////////////////////////////////////////
// ID3DXSprite:
// ------------
// This object intends to provide an easy way to drawing sprites using D3D.
//
// Begin -
//    Prepares device for drawing sprites
//
// Draw, DrawAffine, DrawTransform
//    Draws a sprite in screen-space.  Before transformation, the sprite is
//    the size of SrcRect, with its top-left corner at the origin (0,0).
//    The color and alpha channels are modulated by Color.
//
// End -
//     Restores device state to how it was when Begin was called.
///////////////////////////////////////////////////////////////////////////
type

  ID3DXSprite = interface(IUnknown)
    ['{E8691849-87B8-4929-9050-1B0542D5538C}']
    // ID3DXSprite
    function GetDevice(out ppDevice: IDirect3DDevice8): HResult; stdcall;

    function _Begin: HResult; stdcall;

    function Draw(pSrcTexture: IDirect3DTexture8; pSrcRect: PRect;
      pScaling, pRotationCenter: PD3DXVector2; Rotation: Single;
      pTranslation: PD3DXVector2; Color: TD3DColor): HResult; stdcall;

    function DrawTransform(pSrcTexture: IDirect3DTexture8; pSrcRect: PRect;
      const pTransform: TD3DXMatrix; Color: TD3DColor): HResult; stdcall;

    function _End: HResult; stdcall;
  end;


function D3DXCreateSprite(ppDevice: IDirect3DDevice8;
  out ppSprite: ID3DXSprite): HResult; stdcall;



///////////////////////////////////////////////////////////////////////////
// ID3DXRenderToSurface:
// ---------------------
// This object abstracts rendering to surfaces.  These surfaces do not
// necessarily need to be render targets.  If they are not, a compatible
// render target is used, and the result copied into surface at end scene.
///////////////////////////////////////////////////////////////////////////
type

  PD3DXRTSDesc = ^TD3DXRTSDesc;
  _D3DXRTS_DESC = packed record
    Width: LongWord;
    Height: LongWord;
    Format: TD3DFormat;
    DepthStencil: BOOL;
    DepthStencilFormat: TD3DFormat;
  end {_D3DXRTS_DESC};
  D3DXRTS_DESC = _D3DXRTS_DESC;
  TD3DXRTSDesc = _D3DXRTS_DESC;


  ID3DXRenderToSurface = interface(IUnknown)
    ['{69CC587C-E40C-458d-B5D3-B029E18EB60A}']
    // ID3DXRenderToSurface
    function GetDevice(out ppDevice: IDirect3DDevice8): HResult; stdcall;
    function GetDesc(out pDesc: TD3DXRTSDesc): HResult; stdcall;

    function BeginScene(pSurface: IDirect3DSurface8; const pViewport: TD3DViewport8): HResult; stdcall;
    function EndScene: HResult; stdcall;
  end;


function D3DXCreateRenderToSurface(ppDevice: IDirect3DDevice8;
  Width: LongWord;
  Height: LongWord;
  Format: TD3DFormat;
  DepthStencil: BOOL;
  DepthStencilFormat: TD3DFormat;
  out ppRenderToSurface: ID3DXRenderToSurface): HResult; stdcall;



///////////////////////////////////////////////////////////////////////////
// ID3DXRenderToEnvMap:
// --------------------
///////////////////////////////////////////////////////////////////////////
type

  PD3DXRTEDesc = ^TD3DXRTEDesc;
  _D3DXRTE_DESC = record
    Size: LongWord;
    Format: TD3DFormat;
    DepthStencil: Bool;
    DepthStencilFormat: TD3DFormat;
  end {_D3DXRTE_DESC};
  D3DXRTE_DESC = _D3DXRTE_DESC;
  TD3DXRTEDesc = _D3DXRTE_DESC;


  ID3DXRenderToEnvMap = interface(IUnknown)
    ['{9F6779E5-60A9-4d8b-AEE4-32770F405DBA}']
    // ID3DXRenderToEnvMap
    function GetDevice(out ppDevice: IDirect3DDevice8): HResult; stdcall;
    function GetDesc(out pDesc: TD3DXRTEDesc): HResult; stdcall;

    function BeginCube(pCubeTex: IDirect3DCubeTexture8): HResult; stdcall;

    function BeginSphere(pTex: IDirect3DTexture8): HResult; stdcall;

    function BeginHemisphere(pTexZPos, pTexZNeg: IDirect3DTexture8): HResult; stdcall;

    function BeginParabolic(pTexZPos, pTexZNeg: IDirect3DTexture8): HResult; stdcall;

    function Face(Face: TD3DCubemapFaces): HResult; stdcall;
    function _End: HResult; stdcall;
  end;


function D3DXCreateRenderToEnvMap(ppDevice: IDirect3DDevice8;
  Size: LongWord;
  Format: TD3DFormat;
  DepthStencil: BOOL;
  DepthStencilFormat: TD3DFormat;
  out ppRenderToEnvMap: ID3DXRenderToEnvMap): HResult; stdcall;



///////////////////////////////////////////////////////////////////////////
// Shader assemblers:
///////////////////////////////////////////////////////////////////////////

//-------------------------------------------------------------------------
// D3DXASM flags:
// --------------
//
// D3DXASM_DEBUG
//   Generate debug info.
//
// D3DXASM_SKIPVALIDATION
//   Do not validate the generated code against known capabilities and
//   constraints.  This option is only recommended when assembling shaders
//   you KNOW will work.  (ie. have assembled before without this option.)
//-------------------------------------------------------------------------
const
  D3DXASM_DEBUG           = (1 shl 0);
  D3DXASM_SKIPVALIDATION  = (1 shl 1);


//-------------------------------------------------------------------------
// D3DXAssembleShader:
// ------------------------
// Assembles an ascii description of a vertex or pixel shader into
// binary form.
//
// Parameters:
//  pSrcFile
//      Source file name
//  pSrcData
//      Pointer to source code
//  SrcDataLen
//      Size of source code, in bytes
//  Flags
//      D3DXASM_xxx flags
//  ppConstants
//      Returns an ID3DXBuffer object containing constant declarations.
//  ppCompiledShader
//      Returns an ID3DXBuffer object containing the object code.
//  ppCompilationErrors
//      Returns an ID3DXBuffer object containing ascii error messages
//-------------------------------------------------------------------------

function D3DXAssembleShaderFromFileA(
  pSrcFile: PAnsiChar;
  Flags: DWord;
  ppConstants: PID3DXBuffer;
  ppCompiledShader: PID3DXBuffer;
  ppCompilationErrors: PID3DXBuffer): HResult; stdcall;

function D3DXAssembleShaderFromFileW(
  pSrcFile: PWideChar;
  Flags: DWord;
  ppConstants: PID3DXBuffer;
  ppCompiledShader: PID3DXBuffer;
  ppCompilationErrors: PID3DXBuffer): HResult; stdcall;

function D3DXAssembleShaderFromFile(
  pSrcFile: PChar;
  Flags: DWord;
  ppConstants: PID3DXBuffer;
  ppCompiledShader: PID3DXBuffer;
  ppCompilationErrors: PID3DXBuffer): HResult; stdcall;


function D3DXAssembleShader(
  const pSrcData;
  SrcDataLen: LongWord;
  Flags: DWord;
  ppConstants: PID3DXBuffer;
  ppCompiledShader: PID3DXBuffer;
  ppCompilationErrors: PID3DXBuffer): HResult; stdcall;


///////////////////////////////////////////////////////////////////////////
// Misc APIs:
///////////////////////////////////////////////////////////////////////////


//-------------------------------------------------------------------------
// D3DXGetFVFVertexSize:
// ---------------------
// Returns the size (in bytes) of a vertex for a given FVF.
//-------------------------------------------------------------------------

function D3DXGetFVFVertexSize(FVF: DWord): LongWord; stdcall;


//-------------------------------------------------------------------------
// D3DXGetErrorString:
// ------------------
// Returns the error string for given an hresult.  Interprets all D3DX and
// D3D hresults.
//
// Parameters:
//  hr
//      The error code to be deciphered.
//  pBuffer
//      Pointer to the buffer to be filled in.
//  BufferLen
//      Count of characters in buffer.  Any error message longer than this
//      length will be truncated to fit.
//-------------------------------------------------------------------------
// D3DXGetErrorStringCharA - is "internal" function and shouldn't be used directly
function D3DXGetErrorStringCharA(hr: HResult; pBuffer: PAnsiChar; BufferLen: LongWord): HResult; stdcall;
function D3DXGetErrorStringW(hr: HResult; pBuffer: PWideChar; BufferLen: LongWord): HResult; stdcall;
overload D3DXGetErrorStringA = D3DXGetErrorStringCharA;
overload D3DXGetErrorString = D3DXGetErrorStringCharA;

// Object Pascal support functions for D3DXGetErrorString
function D3DXGetErrorStringPascalA(hr: HResult): String;
// TMT compiler doesn't support WideString -> no "D3DXGetErrorStringPascalW"
overload D3DXGetErrorStringA = D3DXGetErrorStringPascalA;
overload D3DXGetErrorString = D3DXGetErrorStringPascalA;



///////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 1999 Microsoft Corporation.  All Rights Reserved.
//
//  File:       d3dx8effect.h
//  Content:    D3DX effect types and functions
//
///////////////////////////////////////////////////////////////////////////

type
  _D3DXPARAMETERTYPE = (
    D3DXPT_DWORD        {= 0},
    D3DXPT_FLOAT        {= 1},
    D3DXPT_VECTOR       {= 2},
    D3DXPT_MATRIX       {= 3},
    D3DXPT_TEXTURE      {= 4},
    D3DXPT_VERTEXSHADER {= 5},
    D3DXPT_PIXELSHADER  {= 6},
    D3DXPT_CONSTANT     {= 7}
  ); {_D3DXPARAMETERTYPE}
  D3DXPARAMETERTYPE = _D3DXPARAMETERTYPE;
  TD3DXParameterType = _D3DXPARAMETERTYPE;

type
  PD3DXEffectDesc = ^TD3DXEffectDesc;
  _D3DXEFFECT_DESC = packed record
    Parameters: LongWord;
    Techniques: LongWord;
    Usage: DWord;
  end;
  D3DXEFFECT_DESC = _D3DXEFFECT_DESC;
  TD3DXEffectDesc = _D3DXEFFECT_DESC;


  PD3DXParameterDesc = ^TD3DXParameterDesc;
  _D3DXPARAMETER_DESC = packed record
    Name: DWord;
    _Type: TD3DXParameterType;
  end;
  D3DXPARAMETER_DESC = _D3DXPARAMETER_DESC;
  TD3DXParameterDesc = _D3DXPARAMETER_DESC;


  PD3DXTechniqueDesc = ^TD3DXTechniqueDesc;
  _D3DXTECHNIQUE_DESC = packed record
    Name: DWord;
    Passes: LongWord;
  end;
  D3DXTECHNIQUE_DESC = _D3DXTECHNIQUE_DESC;
  TD3DXTechniqueDesc = _D3DXTECHNIQUE_DESC;


  PD3DXPassDesc = ^TD3DXPassDesc;
  _D3DXPASS_DESC = packed record
    Name: DWord;
  end;
  D3DXPASS_DESC = _D3DXPASS_DESC;
  TD3DXPassDesc = _D3DXPASS_DESC;



//////////////////////////////////////////////////////////////////////////////
// ID3DXTechnique ////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

  ID3DXTechnique = interface(IUnknown)
    ['{A00F378D-AF79-4917-907E-4D635EE63844}']
    // ID3DXTechnique
    function GetDevice(out ppDevice: IDirect3DDevice8): HResult; stdcall;
    function GetDesc(out pDesc: TD3DXTechniqueDesc): HResult; stdcall;
    function GetPassDesc(Index: LongWord; out pDesc: TD3DXPassDesc): HResult; stdcall;

    function IsParameterUsed(dwName: DWord): BOOL; stdcall;

    function Validate: HResult; stdcall;
    function _Begin(out pPasses: LongWord): HResult; stdcall;
    function Pass(Index: LongWord): HResult; stdcall;
    function _End: HResult; stdcall;
  end;


//////////////////////////////////////////////////////////////////////////////
// ID3DXEffect ///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////


  ID3DXEffect = interface(IUnknown)
    ['{281BBDD4-AEDF-4907-8650-E79CDFD45165}']
    // ID3DXEffect
    function GetDevice(out ppDevice: IDirect3DDevice8): HResult; stdcall;
    function GetDesc(out pDesc: TD3DXEffectDesc): HResult; stdcall;

    function GetParameterDesc(Index: LongWord; out pDesc: TD3DXParameterDesc): HResult; stdcall;
    function GetTechniqueDesc(Index: LongWord; out pDesc: TD3DXTechniqueDesc): HResult; stdcall;

    function SetDword(Name: DWord; dw: DWord): HResult; stdcall;
    function GetDword(Name: DWord; out pdw: DWord): HResult; stdcall;
    function SetFloat(Name: DWord; f: Single): HResult; stdcall;
    function GetFloat(Name: DWord; out pf: Single): HResult; stdcall;
    function SetVector(Name: DWord; const pVector: TD3DXVector4): HResult; stdcall;
    function GetVector(Name: DWord; out pVector: TD3DXVector4): HResult; stdcall;
    function SetMatrix(Name: DWord; const pMatrix: TD3DXMatrix): HResult; stdcall;
    function GetMatrix(Name: DWord; out pMatrix: TD3DXMatrix): HResult; stdcall;
    function SetTexture(Name: DWord; pTexture: IDirect3DBaseTexture8): HResult; stdcall;
    function GetTexture(Name: DWord; out ppTexture: IDirect3DBaseTexture8): HResult; stdcall;
    function SetVertexShader(Name: DWord; Handle: DWord): HResult; stdcall;
    function GetVertexShader(Name: DWord; out Handle: DWord): HResult; stdcall;
    function SetPixelShader(Name: DWord; Handle: DWord): HResult; stdcall;
    function GetPixelShader(Name: DWord; out Handle: DWord): HResult; stdcall;

    function GetTechnique(Index: LongWord; out ppTechnique: ID3DXTechnique): HResult; stdcall;
    function CloneEffect(ppDevice: IDirect3DDevice8; Usage: DWord; out ppEffect: ID3DXEffect): HResult; stdcall;
  end;



//////////////////////////////////////////////////////////////////////////////
// APIs //////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////



//----------------------------------------------------------------------------
// D3DXCompileEffect:
// ------------------
// Compiles an ascii effect description into a binary form usable by
// D3DXCreateEffect.
//
// Parameters:
//  pSrcFile
//      Name of the file containing the ascii effect description
//  pSrcData
//      Pointer to ascii effect description
//  SrcDataSize
//      Size of the effect description in bytes
//  ppCompiledEffect
//      Returns a buffer containing compiled effect.
//  ppCompilationErrors
//      Returns a buffer containing any error messages which occurred during
//      compile.  Or NULL if you do not care about the error messages.
//
//----------------------------------------------------------------------------

function D3DXCompileEffectFromFileA(
  pSrcFile: PAnsiChar;
  ppCompiledEffect: PID3DXBuffer;
  ppCompilationErrors: PID3DXBuffer): HResult; stdcall;

function D3DXCompileEffectFromFileW(
  pSrcFile: PAnsiChar;
  ppCompiledEffect: PID3DXBuffer;
  ppCompilationErrors: PID3DXBuffer): HResult; stdcall;

function D3DXCompileEffectFromFile(
  pSrcFile: PAnsiChar;
  ppCompiledEffect: PID3DXBuffer;
  ppCompilationErrors: PID3DXBuffer): HResult; stdcall;


function D3DXCompileEffect(
  const pSrcData;
  SrcDataSize: LongWord;
  ppCompiledEffect: PID3DXBuffer;
  ppCompilationErrors: PID3DXBuffer): HResult; stdcall;


//----------------------------------------------------------------------------
// D3DXCreateEffect:
// -----------------
// Creates an effect object, given compiled binary effect data
//
// Parameters:
//  pDevice
//      Pointer to the device to be used.
//  pCompiledEffect
//      Pointer to compiled effect data
//  CompiledEffectSize
//      Size of compiled effect data in bytes
//  Usage
//      Allows the specification of D3DUSAGE_SOFTWAREPROCESSING
//  ppEffect
//      Returns the created effect object
//----------------------------------------------------------------------------


function D3DXCreateEffect(
  pDevice: IDirect3DDevice8;
  const pCompiledEffect;
  CompiledEffectSize: LongWord;
  Usage: DWord;
  out ppEffect: ID3DXEffect): HResult; stdcall;







//////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 1998 Microsoft Corporation.  All Rights Reserved.
//
//  File:       d3dx8mesh.h
//  Content:    D3DX mesh types and functions
//
//////////////////////////////////////////////////////////////////////////////

type
  _D3DXMESH = DWord;
  TD3DXMesh = _D3DXMESH;

const
  D3DXMESH_32BIT                  = $001; // If set, then use 32 bit indices, if not set use 16 bit indices. 32BIT meshes currently not supported on ID3DXSkinMesh object
  D3DXMESH_DONOTCLIP              = $002; // Use D3DUSAGE_DONOTCLIP for VB & IB.
  D3DXMESH_POINTS                 = $004; // Use D3DUSAGE_POINTS for VB & IB.
  D3DXMESH_RTPATCHES              = $008; // Use D3DUSAGE_RTPATCHES for VB & IB.
  D3DXMESH_NPATCHES               = $4000;// Use D3DUSAGE_NPATCHES for VB & IB.
  D3DXMESH_VB_SYSTEMMEM           = $010; // Use D3DPOOL_SYSTEMMEM for VB. Overrides D3DXMESH_MANAGEDVERTEXBUFFER
  D3DXMESH_VB_MANAGED             = $020; // Use D3DPOOL_MANAGED for VB.
  D3DXMESH_VB_WRITEONLY           = $040; // Use D3DUSAGE_WRITEONLY for VB.
  D3DXMESH_VB_DYNAMIC             = $080; // Use D3DUSAGE_DYNAMIC for VB.
  D3DXMESH_IB_SYSTEMMEM           = $100; // Use D3DPOOL_SYSTEMMEM for IB. Overrides D3DXMESH_MANAGEDINDEXBUFFER
  D3DXMESH_IB_MANAGED             = $200; // Use D3DPOOL_MANAGED for IB.
  D3DXMESH_IB_WRITEONLY           = $400; // Use D3DUSAGE_WRITEONLY for IB.
  D3DXMESH_IB_DYNAMIC             = $800; // Use D3DUSAGE_DYNAMIC for IB.

  D3DXMESH_VB_SHARE               = $1000; // Valid for Clone* calls only, forces cloned mesh/pmesh to share vertex buffer

  D3DXMESH_USEHWONLY              = $2000; // Valid for ID3DXSkinMesh::ConvertToBlendedMesh

  // Helper options
  D3DXMESH_SYSTEMMEM              = $110; // D3DXMESH_VB_SYSTEMMEM | D3DXMESH_IB_SYSTEMMEM
  D3DXMESH_MANAGED                = $220; // D3DXMESH_VB_MANAGED | D3DXMESH_IB_MANAGED
  D3DXMESH_WRITEONLY              = $440; // D3DXMESH_VB_WRITEONLY | D3DXMESH_IB_WRITEONLY
  D3DXMESH_DYNAMIC                = $880; // D3DXMESH_VB_DYNAMIC | D3DXMESH_IB_DYNAMIC

type
  // option field values for specifying min value in D3DXGeneratePMesh and D3DXSimplifyMesh
  _D3DXMESHSIMP = (
    D3DXMESHSIMP_INVALID_0{= 0x0},
    D3DXMESHSIMP_VERTEX   {= 0x1},
    D3DXMESHSIMP_FACE     {= 0x2}
  );
  TD3DMeshSimp = _D3DXMESHSIMP;

  _MAX_FVF_DECL_SIZE = DWord;
const
  MAX_FVF_DECL_SIZE = 20;

type
  TFVFDeclaration = array [0..MAX_FVF_DECL_SIZE-1] of DWord;

  PD3DXAttributeRange = ^TD3DXAttributeRange;
  _D3DXATTRIBUTERANGE = packed record
    AttribId:    DWord;
    FaceStart:   DWord;
    FaceCount:   DWord;
    VertexStart: DWord;
    VertexCount: DWord;
  end;
  D3DXATTRIBUTERANGE = _D3DXATTRIBUTERANGE;
  TD3DXAttributeRange = _D3DXATTRIBUTERANGE;

  PD3DXMaterial = ^TD3DXMaterial;
  D3DXMATERIAL = packed record
    MatD3D: TD3Dmaterial8;
    pTextureFilename: PAnsiChar;
  end;
  TD3DXMaterial = D3DXMATERIAL;

  PD3DXAttributeWeights = ^TD3DXAttributeWeights;
  _D3DXATTRIBUTEWEIGHTS = packed record
    Position: Single;
    Boundary: Single;
    Normal:   Single;
    Diffuse:  Single;
    Specular: Single;
    Tex: array[0..7] of Single;
  end;
  D3DXATTRIBUTEWEIGHTS = _D3DXATTRIBUTEWEIGHTS;
  TD3DXAttributeWeights = _D3DXATTRIBUTEWEIGHTS;

  ID3DXMesh = interface;

  ID3DXBaseMesh = interface(IUnknown)
    ['{A69BA991-1F7D-11d3-B929-00C04F68DC23}']
    // ID3DXBaseMesh
    function DrawSubset(AttribId: DWord): HResult; stdcall;
    function GetNumFaces: DWord; stdcall;
    function GetNumVertices: DWord; stdcall;
    function GetFVF: DWord; stdcall;
    function GetDeclaration(out Declaration: TFVFDeclaration): HResult; stdcall;
    function GetOptions: DWord; stdcall;
    function GetDevice(out ppDevice: IDirect3DDevice8): HResult; stdcall;
    function CloneMeshFVF(Options, FVF: DWord; ppDevice: IDirect3DDevice8;
      out ppCloneMesh: ID3DXMesh): HResult; stdcall;
    function CloneMesh(Options: DWord; pDeclaration: PDWord;
      ppDevice: IDirect3DDevice8; out ppCloneMesh: ID3DXMesh): HResult; stdcall;
    function GetVertexBuffer(out ppVB: IDirect3DVertexBuffer8): HResult; stdcall;
    function GetIndexBuffer(out ppIB: IDirect3DIndexBuffer8): HResult; stdcall;
    function LockVertexBuffer(Flags: DWord; out ppData: PByte): HResult; stdcall;
    function UnlockVertexBuffer: HResult; stdcall;
    function LockIndexBuffer(Flags: DWord; out ppData: PByte): HResult; stdcall;
    function UnlockIndexBuffer: HResult; stdcall;
    function GetAttributeTable(pAttribTable: PD3DXAttributeRange;
      pAttribTableSize: PDWord): HResult; stdcall;
  end;

  ID3DXMesh = interface(ID3DXBaseMesh)
    ['{9D84AC46-6B90-49a9-A721-085C7A3E3DAE}']
    // ID3DXMesh
    function LockAttributeBuffer(Flags: DWord; out ppData: PByte): HResult; stdcall;
    function UnlockAttributeBuffer: HResult; stdcall;
    function ConvertPointRepsToAdjacency(pPRep: PDWord; pAdjacency: PDWord): HResult; stdcall;
    function ConvertAdjacencyToPointReps(pAdjacency: PDWord; pPRep: PDWord): HResult; stdcall;
    function GenerateAdjacency(fEpsilon: Single; pAdjacency: PDWord): HResult; stdcall;
    function Optimize(Flags: DWord; pAdjacencyIn, pAdjacencyOut: PDWord;
      pFaceRemap: PDWord; ppVertexRemap: PID3DXBuffer;
      out ppOptMesh: ID3DXMesh): HResult; stdcall;
    function OptimizeInplace(Flags: DWord; pAdjacencyIn, pAdjacencyOut: PDWord;
      pFaceRemap: PDWord; ppVertexRemap: PID3DXBuffer): HResult; stdcall;
  end;

  ID3DXPMesh = interface(ID3DXBaseMesh)
    ['{15981AA8-1A05-48e3-BBE7-FF5D49654E3F}']
    // ID3DXPMesh
    function ClonePMeshFVF(Options, FVF: DWord; ppDevice: IDirect3DDevice8;
      out ppCloneMesh: ID3DXMesh): HResult; stdcall;
    function ClonePMesh(Options: DWord; pDeclaration: PDWord;
      ppDevice: IDirect3DDevice8; out ppCloneMesh: ID3DXMesh): HResult; stdcall;
    function SetNumFaces(Faces: DWord): HResult; stdcall;
    function SetNumVertices(Vertices: DWord): HResult; stdcall;
    function GetMaxFaces: DWord; stdcall;
    function GetMinFaces: DWord; stdcall;
    function GetMaxVertices: DWord; stdcall;
    function GetMinVertices: DWord; stdcall;
    function Save(pStream: IStream; pMaterials: PD3DXMaterial;
       NumMaterials: DWord): HResult; stdcall;
    function Optimize(Flags: DWord; pAdjacencyOut: PDWord;
      pFaceRemap: PDWord; ppVertexRemap: PID3DXBuffer;
      out ppOptMesh: ID3DXMesh): HResult; stdcall;
    function GetAdjacency(pAdjacency: PDWord): HResult; stdcall;
  end;

  ID3DXSPMesh = interface(IUnknown)
    ['{BC3BBDE2-1F7D-11d3-B929-00C04F68DC23}']
    // ID3DXSPMesh
    function GetNumFaces: DWord; stdcall;
    function GetNumVertices: DWord; stdcall;
    function GetFVF: DWord; stdcall;
    function GetDeclaration(out Declaration: TFVFDeclaration): HResult; stdcall;
    function GetOptions: DWord; stdcall;

    function GetDevice(out ppDevice: IDirect3DDevice8): HResult; stdcall;
    function CloneMeshFVF(Options, FVF: DWord; ppDevice: IDirect3DDevice8;
      pAdjacencyOut, pVertexRemapOut: PDWord;
      out ppCloneMesh: ID3DXMesh): HResult; stdcall;
    function CloneMesh(Options: DWord; pDeclaration: PDWord;
      ppDevice: IDirect3DDevice8; pAdjacencyOut, pVertexRemapOut: PDWord;
      out ppCloneMesh: ID3DXMesh): HResult; stdcall;

    function ClonePMeshFVF(Options, FVF: DWord; ppDevice: IDirect3DDevice8;
      pVertexRemapOut: PDWord; out ppCloneMesh: ID3DXMesh): HResult; stdcall;
    function ClonePMesh(Options: DWord; pDeclaration: PDWord;
      ppDevice: IDirect3DDevice8; pVertexRemapOut: PDWord;
      out ppCloneMesh: ID3DXMesh): HResult; stdcall;

    function ReduceFaces(Faces: DWord): HResult; stdcall;
    function ReduceVertices(Vertices: DWord): HResult; stdcall;
    function GetMaxFaces: DWord; stdcall;
    function GetMaxVertices: DWord; stdcall;
  end;

const
  UNUSED16      = $ffff;
  UNUSED32      = $ffffffff;

// ID3DXMesh::Optimize options
type
  _D3DXMESHOPT = DWord;
  TD3DXMeshOpt = _D3DXMESHOPT;

const
  D3DXMESHOPT_COMPACT       = $001;
  D3DXMESHOPT_ATTRSORT      = $002;
  D3DXMESHOPT_VERTEXCACHE   = $004;
  D3DXMESHOPT_STRIPREORDER  = $008;
  D3DXMESHOPT_IGNOREVERTS   = $010;  // optimize faces only, don't touch vertices
  D3DXMESHOPT_SHAREVB       = $020;

// Subset of the mesh that has the same attribute and bone combination.
// This subset can be rendered in a single draw call
type
  PDWordArray = ^TDWordArray;
  TDWordArray = array[0..8181] of DWord;

  PD3DXBoneCombination = ^TD3DXBoneCombination;
  _D3DXBONECOMBINATION = packed record
    AttribId: DWord;
    FaceStart: DWord;
    FaceCount: DWord;
    VertexStart: DWord;
    VertexCount: DWord;
    BoneId: PDWordArray; // [ DWORD* ]  in original d3dx8mesh.h
  end;
  D3DXBONECOMBINATION = _D3DXBONECOMBINATION;
  TD3DXBoneCombination = _D3DXBONECOMBINATION;

  ID3DXSkinMesh = interface(IUnknown)
    ['{82A53844-F322-409e-A2E9-992E1104069D}']
    // close to ID3DXMesh
    function GetNumFaces: DWord; stdcall;
    function GetNumVertices: DWord; stdcall;
    function GetFVF: DWord; stdcall;
    function GetDeclaration(out Declaration: TFVFDeclaration): HResult; stdcall;
    function GetOptions: DWord; stdcall;
    function GetDevice(out ppDevice: IDirect3DDevice8): HResult; stdcall;
    function GetVertexBuffer(out ppVB: IDirect3DVertexBuffer8): HResult; stdcall;
    function GetIndexBuffer(out ppIB: IDirect3DIndexBuffer8): HResult; stdcall;
    function LockVertexBuffer(Flags: DWord; out ppData: PByte): HResult; stdcall;
    function UnlockVertexBuffer: HResult; stdcall;
    function LockIndexBuffer(Flags: DWord; out ppData: PByte): HResult; stdcall;
    function UnlockIndexBuffer: HResult; stdcall;
    function LockAttributeBuffer(Flags: DWord; out ppData: PByte): HResult; stdcall;
    function UnlockAttributeBuffer: HResult; stdcall;
    // ID3DXSkinMesh
    function GetNumBones: DWord; stdcall;
    function GetOriginalMesh(out ppMesh: ID3DXMesh): HResult; stdcall;
    function SetBoneInfluence(bone, numInfluences: DWord; vertices: PDWord;
      weights: PSingle): HResult; stdcall;
    function GetNumBoneInfluences(bone: DWord): DWord; stdcall;
    function GetBoneInfluence(bone: DWord; vertices: PDWord;
      weights: PSingle): HResult; stdcall;
    function GetMaxVertexInfluences(out maxVertexInfluences: DWord): HResult; stdcall;
    function GetMaxFaceInfluences(out maxFaceInfluences: DWord): HResult; stdcall;
    function ConvertToBlendedMesh(options: DWord;
      pAdjacencyIn, pAdjacencyOut: PDWord;
      out pNumBoneCombinations: DWord; out ppBoneCombinationTable: ID3DXBuffer;
      out ppMesh: ID3DXMesh): HResult; stdcall;
    function ConvertToIndexedBlendedMesh(options: DWord;
      pAdjacencyIn: PDWord; paletteSize: DWord; pAdjacencyOut: PDWord;
      out pNumBoneCombinations: DWord; out ppBoneCombinationTable: ID3DXBuffer;
      out ppMesh: ID3DXMesh): HResult; stdcall;
    function GenerateSkinnedMesh(options: DWord; minWeight: Single;
      pAdjacencyIn, pAdjacencyOut: PDWord; out ppMesh: ID3DXMesh): HResult; stdcall;
    function UpdateSkinnedMesh(const pBoneTransforms: TD3DXmatrix;
      ppMesh: ID3DXMesh): HResult; stdcall;
  end;

type
  IID_ID3DXBaseMesh     = ID3DXBaseMesh;
  IID_ID3DXMesh         = ID3DXMesh;
  IID_ID3DXPMesh        = ID3DXPMesh;
  IID_ID3DXSPMesh       = ID3DXSPMesh;
  IID_ID3DXSkinMesh     = ID3DXSkinMesh;


function D3DXCreateMesh(NumFaces, NumVertices: DWord; Options: DWord;
  pDeclaration: PDWord; pD3D: IDirect3DDevice8; out ppMesh: ID3DXMesh): HResult; stdcall;

function D3DXCreateMeshFVF(NumFaces, NumVertices: DWord; Options: DWord;
  FVF: DWord; pD3D: IDirect3DDevice8; out ppMesh: ID3DXMesh): HResult; stdcall;

function D3DXCreateSPMesh(pMesh: ID3DXMesh; pAdjacency: PDWord;
  pVertexAttributeWeights: PD3DXAttributeWeights; pVertexWeights: PSingle;
  out ppSMesh: ID3DXSPMesh): HResult; stdcall;

// clean a mesh up for simplification, try to make manifold
function D3DXCleanMesh(pMeshIn: ID3DXMesh; pAdjacency: PDWord;
  out ppMesh: ID3DXMesh): HResult; stdcall;

function D3DXValidMesh(pMeshIn: ID3DXMesh; pAdjacency: PDWord): HResult; stdcall;

function D3DXGeneratePMesh(pMesh: ID3DXMesh; pAdjacency: PDWord;
  pVertexAttributeWeights: PD3DXAttributeWeights; pVertexWeights: PSingle;
  MinValue: DWord; Options: TD3DMeshSimp; out ppPMesh: ID3DXPMesh): HResult; stdcall;

function D3DXSimplifyMesh(pMesh: ID3DXMesh; pAdjacency: PDWord;
  pVertexAttributeWeights: PD3DXAttributeWeights; pVertexWeights: PSingle;
  MinValue: DWord; Options: TD3DMeshSimp; out ppMesh: ID3DXMesh): HResult; stdcall;

function D3DXComputeBoundingSphere(const pPointsFVF; NumVertices: DWord;
  FVF: DWord; out pCenter: TD3DXVector3; out pRadius: Single): HResult; stdcall;

function D3DXComputeBoundingBox(const pPointsFVF; NumVertices: DWord;
  FVF: DWord; out pMin, pMax: TD3DXVector3): HResult; stdcall;

function D3DXComputeNormals(pMesh: ID3DXBaseMesh): HResult; stdcall;

function D3DXCreateBuffer(NumBytes: DWord; out ppBuffer: ID3DXBuffer): HResult; stdcall;

function D3DXLoadMeshFromX(pFilename: PAnsiChar; Options: DWord;
  pD3D: IDirect3DDevice8; ppAdjacency, ppMaterials: PID3DXBuffer;
  pNumMaterials: PDWord; out ppMesh: ID3DXMesh): HResult; stdcall;

function D3DXSaveMeshToX(pFilename: PAnsiChar; ppMesh: ID3DXMesh;
  pAdjacency: PDWord; pMaterials: PD3DXMaterial; NumMaterials: DWord;
  Format: DWord): HResult; stdcall;

function D3DXCreatePMeshFromStream(pStream: IStream; Options: DWord;
  pD3D: IDirect3DDevice8; ppMaterials: PID3DXBuffer;
  pNumMaterials: PDWord; out ppPMesh: ID3DXPMesh): HResult; stdcall;

function D3DXCreateSkinMesh(numFaces, numVertices, numBones, options: DWord;
  pDeclaration: PDWord; pD3D: IDirect3DDevice8;
  out ppSkinMesh: ID3DXSkinMesh): HResult; stdcall;

function D3DXCreateSkinMeshFVF(numFaces, numVertices, numBones, options: DWord;
  fvf: DWord; pD3D: IDirect3DDevice8;
  out ppSkinMesh: ID3DXSkinMesh): HResult; stdcall;

function D3DXCreateSkinMeshFromMesh(pMesh: ID3DXMesh; numBones: DWord;
  out ppSkinMesh: ID3DXSkinMesh): HResult; stdcall;

function D3DXLoadMeshFromXof(pXofObjMesh: IDirectXFileData;
  Options: DWord; pD3D: IDirect3DDevice8;
  ppAdjacency, ppMaterials: PID3DXBuffer;
  pNumMaterials: PDWord; out ppMesh: ID3DXMesh): HResult; stdcall;

function D3DXLoadSkinMeshFromXof(pXofObjMesh: IDirectXFileData;
  Options: DWord; pD3D: IDirect3DDevice8;
  ppAdjacency, ppMaterials: PID3DXBuffer;
  pmMatOut: PDWord; out ppBoneNames, ppBoneTransforms: ID3DXBuffer;
  out ppMesh: ID3DXMesh): HResult; stdcall;

function D3DXTesselateMesh(pMeshIn: ID3DXMesh;
  ppAdjacency: PDWord; NumSegs: Single;
  QuadraticInterpNormals: BOOL; // if false use linear intrep for normals, if true use quadratic
  out ppMeshOut: ID3DXMesh): HResult; stdcall;

function D3DXDeclaratorFromFVF(FVF: DWord; out Declaration: TFVFDeclaration): HResult; stdcall;

function D3DXFVFFromDeclarator(pDeclarator: PDWord; out pFVF: DWord): HResult; stdcall;

function D3DXWeldVertices(pMesh: ID3DXMesh; fEpsilon: Single;
  rgdwAdjacencyIn, rgdwAdjacencyOut, pFaceRemap: PDWord;
  out ppbufVertexRemap: ID3DXBuffer): HResult; stdcall;

function D3DXIntersect(pMesh: ID3DXBaseMesh;
  const pRayPos, pRayDir: TD3DXVector3; out pHit: BOOL; out pFaceIndex: DWord;
  out pU, pV: Single; out pDist: Single): HResult; stdcall;

function D3DXSphereBoundProbe(const pvCenter: TD3DXVector3; fRadius: Single;
  out pvRayPosition, pvRayDirection: TD3DXVector3): BOOL; stdcall;

function D3DXBoxBoundProbe(const vMin, vMax: TD3DXVector3;
  out pvRayPosition, pvRayDirection: TD3DXVector3): BOOL; stdcall;

type
  _D3DXERR = HResult;


const
  D3DXERR_CANNOTMODIFYINDEXBUFFER       = HResult(MAKE_D3DHRESULT_R or 2900);
  D3DXERR_INVALIDMESH                   = HResult(MAKE_D3DHRESULT_R or 2901);
  D3DXERR_CANNOTATTRSORT                = HResult(MAKE_D3DHRESULT_R or 2902);
  D3DXERR_SKINNINGNOTSUPPORTED          = HResult(MAKE_D3DHRESULT_R or 2903);
  D3DXERR_TOOMANYINFLUENCES             = HResult(MAKE_D3DHRESULT_R or 2904);
  D3DXERR_INVALIDDATA                   = HResult(MAKE_D3DHRESULT_R or 2905);
  D3DXERR_LOADEDMESHASNODATA            = HResult(MAKE_D3DHRESULT_R or 2906);








///////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 1999 Microsoft Corporation.  All Rights Reserved.
//
//  File:       d3dx8shapes.h
//  Content:    D3DX simple shapes
//
///////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////
// Functions:
///////////////////////////////////////////////////////////////////////////


//-------------------------------------------------------------------------
// D3DXCreatePolygon:
// ------------------
// Creates a mesh containing an n-sided polygon.  The polygon is centered
// at the origin.
//
// Parameters:
//
//  pDevice     The D3D device with which the mesh is going to be used.
//  Length      Length of each side.
//  Sides       Number of sides the polygon has.  (Must be >= 3)
//  ppMesh      The mesh object which will be created
//  ppAdjacency Returns a buffer containing adjacency info.  Can be NULL.
//-------------------------------------------------------------------------
function D3DXCreatePolygon(ppDevice: IDirect3DDevice8;
  Length: Single;
  Sides: LongWord;
  out ppMesh: ID3DXMesh;
  ppAdjacency: PID3DXBuffer): HResult; stdcall;


//-------------------------------------------------------------------------
// D3DXCreateBox:
// --------------
// Creates a mesh containing an axis-aligned box.  The box is centered at
// the origin.
//
// Parameters:
//
//  pDevice     The D3D device with which the mesh is going to be used.
//  Width       Width of box (along X-axis)
//  Height      Height of box (along Y-axis)
//  Depth       Depth of box (along Z-axis)
//  ppMesh      The mesh object which will be created
//  ppAdjacency Returns a buffer containing adjacency info.  Can be NULL.
//-------------------------------------------------------------------------
function D3DXCreateBox(ppDevice: IDirect3DDevice8;
  Width,
  Height,
  Depth: Single;
  out ppMesh: ID3DXMesh;
  ppAdjacency: PID3DXBuffer): HResult; stdcall;


//-------------------------------------------------------------------------
// D3DXCreateCylinder:
// -------------------
// Creates a mesh containing a cylinder.  The generated cylinder is
// centered at the origin, and its axis is aligned with the Z-axis.
//
// Parameters:
//
//  pDevice     The D3D device with which the mesh is going to be used.
//  Radius1     Radius at -Z end (should be >= 0.0f)
//  Radius2     Radius at +Z end (should be >= 0.0f)
//  Length      Length of cylinder (along Z-axis)
//  Slices      Number of slices about the main axis
//  Stacks      Number of stacks along the main axis
//  ppMesh      The mesh object which will be created
//  ppAdjacency Returns a buffer containing adjacency info.  Can be NULL.
//-------------------------------------------------------------------------
function D3DXCreateCylinder(ppDevice: IDirect3DDevice8;
  Radius1,
  Radius2,
  Length: Single;
  Slices,
  Stacks: LongWord;
  out ppMesh: ID3DXMesh;
  ppAdjacency: PID3DXBuffer): HResult; stdcall;


//-------------------------------------------------------------------------
// D3DXCreateSphere:
// -----------------
// Creates a mesh containing a sphere.  The sphere is centered at the
// origin.
//
// Parameters:
//
//  pDevice     The D3D device with which the mesh is going to be used.
//  Radius      Radius of the sphere (should be >= 0.0f)
//  Slices      Number of slices about the main axis
//  Stacks      Number of stacks along the main axis
//  ppMesh      The mesh object which will be created
//  ppAdjacency Returns a buffer containing adjacency info.  Can be NULL.
//-------------------------------------------------------------------------
function D3DXCreateSphere(ppDevice: IDirect3DDevice8;
  Radius: Single;
  Slices,
  Stacks: LongWord;
  out ppMesh: ID3DXMesh;
  ppAdjacency: PID3DXBuffer): HResult; stdcall;


//-------------------------------------------------------------------------
// D3DXCreateTorus:
// ----------------
// Creates a mesh containing a torus.  The generated torus is centered at
// the origin, and its axis is aligned with the Z-axis.
//
// Parameters:
//
//  pDevice     The D3D device with which the mesh is going to be used.
//  InnerRadius Inner radius of the torus (should be >= 0.0f)
//  OuterRadius Outer radius of the torue (should be >= 0.0f)
//  Sides       Number of sides in a cross-section (must be >= 3)
//  Rings       Number of rings making up the torus (must be >= 3)
//  ppMesh      The mesh object which will be created
//  ppAdjacency Returns a buffer containing adjacency info.  Can be NULL.
//-------------------------------------------------------------------------
function D3DXCreateTorus(ppDevice: IDirect3DDevice8;
  InnerRadius,
  OuterRadius: Single;
  Sides,
  Rings: LongWord;
  out ppMesh: ID3DXMesh;
  ppAdjacency: PID3DXBuffer): HResult; stdcall;


//-------------------------------------------------------------------------
// D3DXCreateTeapot:
// -----------------
// Creates a mesh containing a teapot.
//
// Parameters:
//
//  pDevice     The D3D device with which the mesh is going to be used.
//  ppMesh      The mesh object which will be created
//  ppAdjacency Returns a buffer containing adjacency info.  Can be NULL.
//-------------------------------------------------------------------------
function D3DXCreateTeapot(ppDevice: IDirect3DDevice8;
  out ppMesh: ID3DXMesh;
  ppAdjacency: PID3DXBuffer): HResult; stdcall;


//-------------------------------------------------------------------------
// D3DXCreateText:
// ---------------
// Creates a mesh containing the specified text using the font associated
// with the device context.
//
// Parameters:
//
//  pDevice       The D3D device with which the mesh is going to be used.
//  hDC           Device context, with desired font selected
//  pText         Text to generate
//  Deviation     Maximum chordal deviation from true font outlines
//  Extrusion     Amount to extrude text in -Z direction
//  ppMesh        The mesh object which will be created
//  pGlyphMetrics Address of buffer to receive glyph metric data (or NULL)
//-------------------------------------------------------------------------

function D3DXCreateTextA(ppDevice: IDirect3DDevice8;
  hDC: HDC;
  pText: PAnsiChar;
  Deviation: Single;
  Extrusion: Single;
  out ppMesh: ID3DXMesh;
  pGlyphMetrics: PGlyphMetricsFloat): HResult; stdcall;

function D3DXCreateTextW(ppDevice: IDirect3DDevice8;
  hDC: HDC;
  pText: PWideChar;
  Deviation: Single;
  Extrusion: Single;
  out ppMesh: ID3DXMesh;
  pGlyphMetrics: PGlyphMetricsFloat): HResult; stdcall;

function D3DXCreateText(ppDevice: IDirect3DDevice8;
  hDC: HDC;
  pText: PChar;
  Deviation: Single;
  Extrusion: Single;
  out ppMesh: ID3DXMesh;
  pGlyphMetrics: PGlyphMetricsFloat): HResult; stdcall;







///////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 1999 Microsoft Corporation.  All Rights Reserved.
//
//  File:       d3dx8tex.h
//  Content:    D3DX texturing APIs
//
///////////////////////////////////////////////////////////////////////////

//-------------------------------------------------------------------------
// D3DX_FILTER flags:
// ------------------
//
// A valid filter must contain one of these values:
//
//  D3DX_FILTER_NONE
//      No scaling or filtering will take place.  Pixels outside the bounds
//      of the source image are assumed to be transparent black.
//  D3DX_FILTER_POINT
//      Each destination pixel is computed by sampling the nearest pixel
//      from the source image.
//  D3DX_FILTER_LINEAR
//      Each destination pixel is computed by linearly interpolating between
//      the nearest pixels in the source image.  This filter works best
//      when the scale on each axis is less than 2.
//  D3DX_FILTER_TRIANGLE
//      Every pixel in the source image contributes equally to the
//      destination image.  This is the slowest of all the filters.
//  D3DX_FILTER_BOX
//      Each pixel is computed by averaging a 2x2(x2) box pixels from
//      the source image. Only works when the dimensions of the
//      destination are half those of the source. (as with mip maps)
//
//
// And can be OR'd with any of these optional flags:
//
//  D3DX_FILTER_MIRROR_U
//      Indicates that pixels off the edge of the texture on the U-axis
//      should be mirrored, not wraped.
//  D3DX_FILTER_MIRROR_V
//      Indicates that pixels off the edge of the texture on the V-axis
//      should be mirrored, not wraped.
//  D3DX_FILTER_MIRROR_W
//      Indicates that pixels off the edge of the texture on the W-axis
//      should be mirrored, not wraped.
//  D3DX_FILTER_MIRROR
//      Same as specifying D3DX_FILTER_MIRROR_U, D3DX_FILTER_MIRROR_V,
//      and D3DX_FILTER_MIRROR_V
//  D3DX_FILTER_DITHER
//      Dithers the resulting image.
//
//-------------------------------------------------------------------------

const
  D3DX_FILTER_NONE      = (1 shl 0);
  D3DX_FILTER_POINT     = (2 shl 0);
  D3DX_FILTER_LINEAR    = (3 shl 0);
  D3DX_FILTER_TRIANGLE  = (4 shl 0);
  D3DX_FILTER_BOX       = (5 shl 0);

  D3DX_FILTER_MIRROR_U  = (1 shl 16);
  D3DX_FILTER_MIRROR_V  = (2 shl 16);
  D3DX_FILTER_MIRROR_W  = (4 shl 16);
  D3DX_FILTER_MIRROR    = (7 shl 16);
  D3DX_FILTER_DITHER    = (8 shl 16);


//-------------------------------------------------------------------------
// D3DXIMAGE_INFO:
// ---------------
// This structure is used to return a rough description of what the
// the original contents of an image file looked like.
//
//  Width
//      Width of original image in pixels
//  Height
//      Height of original image in pixels
//  Depth
//      Depth of original image in pixels
//  MipLevels
//      Number of mip levels in original image
//  Format
//      D3D format which most closely describes the data in original image
//
//-------------------------------------------------------------------------

type
  PD3DXImageInfo = ^TD3DXImageInfo;
  _D3DXIMAGE_INFO = packed record
    Width:      LongWord;
    Height:     LongWord;
    Depth:      LongWord;
    MipLevels:  LongWord;
    Format:     TD3DFormat;
  end;
  D3DXIMAGE_INFO = _D3DXIMAGE_INFO;
  TD3DXImageInfo = _D3DXIMAGE_INFO;


///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////


//-------------------------------------------------------------------------
// D3DXLoadSurfaceFromFile/Resource:
// ---------------------------------
// Load surface from a file or resource
//
// Parameters:
//  pDestSurface
//      Destination surface, which will receive the image.
//  pDestPalette
//      Destination palette of 256 colors, or NULL
//  pDestRect
//      Destination rectangle, or NULL for entire surface
//  pSrcFile
//      File name of the source image.
//  pSrcModule
//      Module where resource is located, or NULL for module associated
//      with image the os used to create the current process.
//  pSrcResource
//      Resource name
//  pSrcData
//      Pointer to file in memory.
//  SrcDataSize
//      Size in bytes of file in memory.
//  pSrcRect
//      Source rectangle, or NULL for entire image
//  Filter
//      D3DX_FILTER flags controlling how the image is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_TRIANGLE.
//  ColorKey
//      Color to replace with transparent black, or 0 to disable colorkey.
//      This is always a 32-bit ARGB color, independent of the source image
//      format.  Alpha is significant, and should usually be set to FF for
//      opaque colorkeys.  (ex. Opaque black == 0xff000000)
//  pSrcInfo
//      Pointer to a D3DXIMAGE_INFO structure to be filled in with the
//      description of the data in the source image file, or NULL.
//
//-------------------------------------------------------------------------
function D3DXLoadSurfaceFromFileA(
  pDestSurface: IDirect3DSurface8;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  pSrcFile: PAnsiChar;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo): HResult; stdcall;

function D3DXLoadSurfaceFromFileW(
  pDestSurface: IDirect3DSurface8;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  pSrcFile: PWideChar;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo): HResult; stdcall;

function D3DXLoadSurfaceFromFile(
  pDestSurface: IDirect3DSurface8;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  pSrcFile: PChar;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo): HResult; stdcall;



function D3DXLoadSurfaceFromResourceA(
  pDestSurface: IDirect3DSurface8;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  hSrcModule: HModule;
  pSrcResource: PAnsiChar;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo): HResult; stdcall;

function D3DXLoadSurfaceFromResourceW(
  pDestSurface: IDirect3DSurface8;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  hSrcModule: HModule;
  pSrcResource: PWideChar;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo): HResult; stdcall;

function D3DXLoadSurfaceFromResource(
  pDestSurface: IDirect3DSurface8;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  hSrcModule: HModule;
  pSrcResource: PChar;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo): HResult; stdcall;



function D3DXLoadSurfaceFromFileInMemory(
  pDestSurface: IDirect3DSurface8;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  const pSrcData;
  SrcDataSize: LongWord;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo): HResult; stdcall;



//-------------------------------------------------------------------------
// D3DXLoadSurfaceFromSurface:
// --------------------------
// Load surface from another surface (with color conversion)
//
// Parameters:
//  pDestSurface
//      Destination surface, which will receive the image.
//  pDestPalette
//      Destination palette of 256 colors, or NULL
//  pDestRect
//      Destination rectangle, or NULL for entire surface
//  pSrcSurface
//      Source surface
//  pSrcPalette
//      Source palette of 256 colors, or NULL
//  pSrcRect
//      Source rectangle, or NULL for entire surface
//  Filter
//      D3DX_FILTER flags controlling how the image is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_TRIANGLE.
//  ColorKey
//      Color to replace with transparent black, or 0 to disable colorkey.
//      This is always a 32-bit ARGB color, independent of the source image
//      format.  Alpha is significant, and should usually be set to FF for
//      opaque colorkeys.  (ex. Opaque black == 0xff000000)
//
//-------------------------------------------------------------------------
function D3DXLoadSurfaceFromSurface(
  pDestSurface: IDirect3DSurface8;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  pSrcSurface: IDirect3DSurface8;
  pSrcPalette: PPaletteEntry;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor): HResult; stdcall;



//-------------------------------------------------------------------------
// D3DXLoadSurfaceFromMemory:
// --------------------------
// Load surface from memory.
//
// Parameters:
//  pDestSurface
//      Destination surface, which will receive the image.
//  pDestPalette
//      Destination palette of 256 colors, or NULL
//  pDestRect
//      Destination rectangle, or NULL for entire surface
//  pSrcMemory
//      Pointer to the top-left corner of the source image in memory
//  SrcFormat
//      Pixel format of the source image.
//  SrcPitch
//      Pitch of source image, in bytes.  For DXT formats, this number
//      should represent the width of one row of cells, in bytes.
//  pSrcPalette
//      Source palette of 256 colors, or NULL
//  pSrcRect
//      Source rectangle.
//  Filter
//      D3DX_FILTER flags controlling how the image is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_TRIANGLE.
//  ColorKey
//      Color to replace with transparent black, or 0 to disable colorkey.
//      This is always a 32-bit ARGB color, independent of the source image
//      format.  Alpha is significant, and should usually be set to FF for
//      opaque colorkeys.  (ex. Opaque black == 0xff000000)
//
//-------------------------------------------------------------------------
function D3DXLoadSurfaceFromMemory(
  pDestSurface: IDirect3DSurface8;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  const pSrcMemory;
  SrcFormat: TD3DFormat;
  SrcPitch: LongWord;
  pSrcPalette: PPaletteEntry;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor): HResult; stdcall;



///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////


//-------------------------------------------------------------------------
// D3DXLoadVolumeFromVolume:
// --------------------------
// Load volume from another volume (with color conversion)
//
// Parameters:
//  pDestVolume
//      Destination volume, which will receive the image.
//  pDestPalette
//      Destination palette of 256 colors, or NULL
//  pDestBox
//      Destination box, or NULL for entire volume
//  pSrcVolume
//      Source volume
//  pSrcPalette
//      Source palette of 256 colors, or NULL
//  pSrcBox
//      Source box, or NULL for entire volume
//  Filter
//      D3DX_FILTER flags controlling how the image is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_TRIANGLE.
//  ColorKey
//      Color to replace with transparent black, or 0 to disable colorkey.
//      This is always a 32-bit ARGB color, independent of the source image
//      format.  Alpha is significant, and should usually be set to FF for
//      opaque colorkeys.  (ex. Opaque black == 0xff000000)
//
//-------------------------------------------------------------------------
function D3DXLoadVolumeFromVolume(
  pDestVolume: IDirect3DVolume8;
  pDestPalette: PPaletteEntry;
  pDestBox: TD3DBox;
  pSrcVolume: IDirect3DVolume8;
  pSrcPalette: PPaletteEntry;
  pSrcBox: TD3DBox;
  Filter: DWord;
  ColorKey: TD3DColor): HResult; stdcall;


//-------------------------------------------------------------------------
// D3DXLoadVolumeFromMemory:
// --------------------------
// Load volume from memory.
//
// Parameters:
//  pDestVolume
//      Destination volume, which will receive the image.
//  pDestPalette
//      Destination palette of 256 colors, or NULL
//  pDestBox
//      Destination box, or NULL for entire volume
//  pSrcMemory
//      Pointer to the top-left corner of the source volume in memory
//  SrcFormat
//      Pixel format of the source volume.
//  SrcRowPitch
//      Pitch of source image, in bytes.  For DXT formats, this number
//      should represent the size of one row of cells, in bytes.
//  SrcSlicePitch
//      Pitch of source image, in bytes.  For DXT formats, this number
//      should represent the size of one slice of cells, in bytes.
//  pSrcPalette
//      Source palette of 256 colors, or NULL
//  pSrcBox
//      Source box.
//  Filter
//      D3DX_FILTER flags controlling how the image is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_TRIANGLE.
//  ColorKey
//      Color to replace with transparent black, or 0 to disable colorkey.
//      This is always a 32-bit ARGB color, independent of the source image
//      format.  Alpha is significant, and should usually be set to FF for
//      opaque colorkeys.  (ex. Opaque black == 0xff000000)
//
//-------------------------------------------------------------------------
function D3DXLoadVolumeFromMemory(
  pDestVolume: IDirect3DVolume8;
  pDestPalette: PPaletteEntry;
  pDestBox: TD3DBox;
  const pSrcMemory;
  SrcFormat: TD3DFormat;
  SrcRowPitch: LongWord;
  SrcSlicePitch: LongWord;
  pSrcPalette: PPaletteEntry;
  pSrcBox: TD3DBox;
  Filter: DWord;
  ColorKey: TD3DColor): HResult; stdcall;



///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////



//-------------------------------------------------------------------------
// D3DXCheckTextureRequirements:
// -----------------------------
//
// Checks texture creation parameters.  If parameters are invalid, this
// function returns corrected parameters.
//
// Parameters:
//
//  pDevice
//      The D3D device to be used
//  pWidth
//      Desired width in pixels, or NULL.  Returns corrected width.
//  pHeight
//      Desired height in pixels, or NULL.  Returns corrected height.
//  pNumMipLevels
//      Number of desired mipmap levels, or NULL.  Returns corrected number.
//  Usage
//      Texture usage flags
//  pFormat
//      Desired pixel format, or NULL.  Returns corrected format.
//  Pool
//      Memory pool to be used to create texture
//
//-------------------------------------------------------------------------
function D3DXCheckTextureRequirements(
  pDevice: IDirect3DDevice8;
  pWidth: PLongWord;
  pHeight: PLongWord;
  pNumMipLevels: PLongWord;
  Usage: DWord;
  pFormat: PD3DFormat;
  Pool: TD3DPool): HResult; stdcall;


//-------------------------------------------------------------------------
// D3DXCreateTexture:
// ------------------
// Create an empty texture
//
// Parameters:
//
//  pDevice
//      The D3D device with which the texture is going to be used.
//  Width
//      width in pixels; must be non-zero
//  Height
//      height in pixels; must be non-zero
//  MipLevels
//      number of mip levels desired; if zero or D3DX_DEFAULT, a complete
//      mipmap chain will be created.
//  Usage
//      Texture usage flags
//  Format
//      Pixel format.
//  Pool
//      Memory pool to be used to create texture
//  ppTexture
//      The texture object that will be created
//
//-------------------------------------------------------------------------
function D3DXCreateTexture(
  Device: IDirect3DDevice8;
  Width: LongWord;
  Height: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;



//-------------------------------------------------------------------------
// D3DXCreateTextureFromFile:
// --------------------------
// Create a texture object from a file.
//
// Parameters:
//
//  pDevice
//      The D3D device with which the texture is going to be used.
//  pSrcFile
//      File name.
//  hSrcModule
//      Module handle. if NULL, current module will be used.
//  pSrcResource
//      Resource name in module
//  pvSrcData
//      Pointer to file in memory.
//  SrcDataSize
//      Size in bytes of file in memory.
//  Width
//      Width in pixels; if zero or D3DX_DEFAULT, the width will be taken
//      from the file.
//  Height
//      Height in pixels; if zero of D3DX_DEFAULT, the height will be taken
//      from the file.
//  MipLevels
//      Number of mip levels;  if zero or D3DX_DEFAULT, a complete mipmap
//      chain will be created.
//  Usage
//      Texture usage flags
//  Format
//      Desired pixel format.  If D3DFMT_UNKNOWN, the format will be
//      taken from the file.
//  Pool
//      Memory pool to be used to create texture
//  Filter
//      D3DX_FILTER flags controlling how the image is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_TRIANGLE.
//  MipFilter
//      D3DX_FILTER flags controlling how each miplevel is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_BOX,
//  ColorKey
//      Color to replace with transparent black, or 0 to disable colorkey.
//      This is always a 32-bit ARGB color, independent of the source image
//      format.  Alpha is significant, and should usually be set to FF for
//      opaque colorkeys.  (ex. Opaque black == 0xff000000)
//  pSrcInfo
//      Pointer to a D3DXIMAGE_INFO structure to be filled in with the
//      description of the data in the source image file, or NULL.
//  pPalette
//      256 color palette to be filled in, or NULL
//  ppTexture
//      The texture object that will be created
//
//-------------------------------------------------------------------------
function D3DXCreateTextureFromFileA(
  Device: IDirect3DDevice8;
  pSrcFile: PAnsiChar;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;

function D3DXCreateTextureFromFileW(
  Device: IDirect3DDevice8;
  pSrcFile: PWideChar;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;

function D3DXCreateTextureFromFile(
  Device: IDirect3DDevice8;
  pSrcFile: PChar;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;


function D3DXCreateTextureFromResourceA(
  Device: IDirect3DDevice8;
  hSrcModule: HModule;
  pSrcResource: PAnsiChar;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;

function D3DXCreateTextureFromResourceW(
  Device: IDirect3DDevice8;
  hSrcModule: HModule;
  pSrcResource: PWideChar;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;

function D3DXCreateTextureFromResource(
  Device: IDirect3DDevice8;
  hSrcModule: HModule;
  pSrcResource: PChar;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;



function D3DXCreateTextureFromFileExA(
  Device: IDirect3DDevice8;
  pSrcFile: PAnsiChar;
  Width: LongWord;
  Height: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;

function D3DXCreateTextureFromFileExW(
  Device: IDirect3DDevice8;
  pSrcFile: PWideChar;
  Width: LongWord;
  Height: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;

function D3DXCreateTextureFromFileEx(
  Device: IDirect3DDevice8;
  pSrcFile: PChar;
  Width: LongWord;
  Height: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;



function D3DXCreateTextureFromResourceExA(
  Device: IDirect3DDevice8;
  hSrcModule: HModule;
  pSrcResource: PAnsiChar;
  Width: LongWord;
  Height: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;

function D3DXCreateTextureFromResourceExW(
  Device: IDirect3DDevice8;
  hSrcModule: HModule;
  pSrcResource: PWideChar;
  Width: LongWord;
  Height: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;

function D3DXCreateTextureFromResourceEx(
  Device: IDirect3DDevice8;
  hSrcModule: HModule;
  pSrcResource: PChar;
  Width: LongWord;
  Height: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;


function D3DXCreateTextureFromFileInMemory(
  Device: IDirect3DDevice8;
  const pSrcData;
  SrcDataSize: LongWord;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;

function D3DXCreateTextureFromFileInMemoryEx(
  Device: IDirect3DDevice8;
  const pSrcData;
  SrcDataSize: LongWord;
  Width: LongWord;
  Height: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppTexture: IDirect3DTexture8): HResult; stdcall;



//-------------------------------------------------------------------------
// D3DXFilterTexture:
// ------------------
// Filters mipmaps levels of a texture.
//
// Parameters:
//  pTexture
//      The texture object to be filtered
//  pPalette
//      256 color palette to be used, or NULL for non-palettized formats
//  SrcLevel
//      The level whose image is used to generate the subsequent levels.
//  Filter
//      D3DX_FILTER flags controlling how each miplevel is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_BOX,
//
//-------------------------------------------------------------------------
function D3DXFilterTexture(
  pTexture: IDirect3DTexture8;
  pPalette: PPaletteEntry;
  SrcLevel: LongWord;
  Filter: DWord): HResult; stdcall;




///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////





//-------------------------------------------------------------------------
// D3DXCheckCubeTextureRequirements:
// ---------------------------------
//
// Checks cube texture creation parameters.  If parameters are invalid,
// this function returns corrected parameters.
//
// Parameters:
//
//  pDevice
//      The D3D device to be used
//  pSize
//      Desired width and height in pixels, or NULL.  Returns corrected size.
//  pNumMipLevels
//      Number of desired mipmap levels, or NULL.  Returns corrected number.
//  Usage
//      Texture usage flags
//  pFormat
//      Desired pixel format, or NULL.  Returns corrected format.
//  Pool
//      Memory pool to be used to create texture
//
//-------------------------------------------------------------------------
function D3DXCheckCubeTextureRequirements(
  pDevice: IDirect3DDevice8;
  pSize: PLongWord;
  pNumMipLevels: PLongWord;
  Usage: DWord;
  pFormat: PD3DFormat;
  Pool: TD3DPool): HResult; stdcall;


//-------------------------------------------------------------------------
// D3DXCreateCubeTexture:
// ----------------------
// Create an empty cube texture
//
// Parameters:
//
//  pDevice
//      The D3D device with which the texture is going to be used.
//  Size
//      width and height in pixels; must be non-zero
//  MipLevels
//      number of mip levels desired; if zero or D3DX_DEFAULT, a complete
//      mipmap chain will be created.
//  Usage
//      Texture usage flags
//  Format
//      Pixel format.
//  Pool
//      Memory pool to be used to create texture
//  ppCubeTexture
//      The cube texture object that will be created
//
//-------------------------------------------------------------------------
function D3DXCreateCubeTexture(
  Device: IDirect3DDevice8;
  Size, MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  out ppCubeTexture: IDirect3DCubeTexture8): HResult; stdcall;


//-------------------------------------------------------------------------
// D3DXCreateCubeTextureFromFile:
// --------------------------
// Create a cube texture object from a file.
//
// Parameters:
//
//  pDevice
//      The D3D device with which the texture is going to be used.
//  pSrcFile
//      File name.
//  pvSrcData
//      Pointer to file in memory.
//  SrcDataSize
//      Size in bytes of file in memory.
//  Size
//      Width and height in pixels; if zero or D3DX_DEFAULT, the size
//      will be taken from the file.
//  MipLevels
//      Number of mip levels;  if zero or D3DX_DEFAULT, a complete mipmap
//      chain will be created.
//  Format
//      Desired pixel format.  If D3DFMT_UNKNOWN, the format will be
//      taken from the file.
//  Filter
//      D3DX_FILTER flags controlling how the image is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_TRIANGLE.
//  MipFilter
//      D3DX_FILTER flags controlling how each miplevel is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_BOX,
//  ColorKey
//      Color to replace with transparent black, or 0 to disable colorkey.
//      This is always a 32-bit ARGB color, independent of the source image
//      format.  Alpha is significant, and should usually be set to FF for
//      opaque colorkeys.  (ex. Opaque black == 0xff000000)
//  pSrcInfo
//      Pointer to a D3DXIMAGE_INFO structure to be filled in with the
//      description of the data in the source image file, or NULL.
//  pPalette
//      256 color palette to be filled in, or NULL
//  ppCubeTexture
//      The cube texture object that will be created
//
//-------------------------------------------------------------------------
function D3DXCreateCubeTextureFromFileA(
  Device: IDirect3DDevice8;
  pSrcFile: PAnsiChar;
  out ppCubeTexture: IDirect3DCubeTexture8): HResult; stdcall;

function D3DXCreateCubeTextureFromFileW(
  Device: IDirect3DDevice8;
  pSrcFile: PWideChar;
  out ppCubeTexture: IDirect3DCubeTexture8): HResult; stdcall;

function D3DXCreateCubeTextureFromFile(
  Device: IDirect3DDevice8;
  pSrcFile: PChar;
  out ppCubeTexture: IDirect3DCubeTexture8): HResult; stdcall;


function D3DXCreateCubeTextureFromFileExA(
  Device: IDirect3DDevice8;
  pSrcFile: PAnsiChar;
  Size: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppCubeTexture: IDirect3DCubeTexture8): HResult; stdcall;

function D3DXCreateCubeTextureFromFileExW(
  Device: IDirect3DDevice8;
  pSrcFile: PWideChar;
  Size: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppCubeTexture: IDirect3DCubeTexture8): HResult; stdcall;

function D3DXCreateCubeTextureFromFileEx(
  Device: IDirect3DDevice8;
  pSrcFile: PChar;
  Size: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppCubeTexture: IDirect3DCubeTexture8): HResult; stdcall;



function D3DXCreateCubeTextureFromFileInMemory(
  Device: IDirect3DDevice8;
  const pSrcData;
  SrcDataSize: LongWord;
  out ppCubeTexture: IDirect3DCubeTexture8): HResult; stdcall;

function D3DXCreateCubeTextureFromFileInMemoryEx(
  Device: IDirect3DDevice8;
  const pSrcData;
  SrcDataSize: LongWord;
  Size: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppCubeTexture: IDirect3DCubeTexture8): HResult; stdcall;


//-------------------------------------------------------------------------
// D3DXFilterCubeTexture:
// ----------------------
// Filters mipmaps levels of a cube texture map.
//
// Parameters:
//  pCubeTexture
//      The cube texture object to be filtered
//  pPalette
//      256 color palette to be used, or NULL
//  SrcLevel
//      The level whose image is used to generate the subsequent levels.
//  Filter
//      D3DX_FILTER flags controlling how each miplevel is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_BOX,
//
//-------------------------------------------------------------------------
function D3DXFilterCubeTexture(
  pCubeTexture: IDirect3DCubeTexture8;
  pPalette: PPaletteEntry;
  SrcLevel: LongWord;
  Filter: DWord): HResult; stdcall;


///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////




//-------------------------------------------------------------------------
// D3DXCheckVolumeTextureRequirements:
// -----------------------------------
//
// Checks volume texture creation parameters.  If parameters are invalid,
// this function returns corrected parameters.
//
// Parameters:
//
//  pDevice
//      The D3D device to be used
//  pWidth
//      Desired width in pixels, or NULL.  Returns corrected size.
//  pHeight
//      Desired height in pixels, or NULL.  Returns corrected size.
//  pDepth
//      Desired depth in pixels, or NULL.  Returns corrected size.
//  pNumMipLevels
//      Number of desired mipmap levels, or NULL.  Returns corrected number.
//  pFormat
//      Desired pixel format, or NULL.  Returns corrected format.
//
//-------------------------------------------------------------------------
function D3DXCheckVolumeTextureRequirements(
  pDevice: IDirect3DDevice8;
  pWidth: PLongWord;
  pHeight: PLongWord;
  pDepth: PLongWord;
  pNumMipLevels: PLongWord;
  Usage: DWord;
  pFormat: PD3DFormat;
  Pool: TD3DPool): HResult; stdcall;


//-------------------------------------------------------------------------
// D3DXCreateVolumeTexture:
// ----------------------
// Create an empty volume texture
//
// Parameters:
//
//  pDevice
//      The D3D device with which the texture is going to be used.
//  Width
//      width in pixels; must be non-zero
//  Height
//      height in pixels; must be non-zero
//  Depth
//      depth in pixels; must be non-zero
//  MipLevels
//      number of mip levels desired; if zero or D3DX_DEFAULT, a complete
//      mipmap chain will be created.
//  Format
//      pixel format.
//  ppVolumeTexture
//      The volume texture object that will be created
//
//-------------------------------------------------------------------------
function D3DXCreateVolumeTexture(
  pDevice: IDirect3DDevice8;
  Width: LongWord;
  Height: LongWord;
  Depth: LongWord;
  NumMipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  out ppVolumeTexture: IDirect3DVolumeTexture8): HResult; stdcall;


//-------------------------------------------------------------------------
// D3DXFilterVolumeTexture:
// ------------------------
// Filters mipmaps levels of a volume texture map.
//
// Parameters:
//  pVolumeTexture
//      The volume texture object to be filtered
//  pPalette
//      256 color palette to be used, or NULL
//  SrcLevel
//      The level whose image is used to generate the subsequent levels.
//  Filter
//      D3DX_FILTER flags controlling how each miplevel is filtered.
//      Or D3DX_DEFAULT for D3DX_FILTER_BOX,
//
//-------------------------------------------------------------------------
function D3DXFilterVolumeTexture(
  pVolumeTexture: IDirect3DVolumeTexture8;
  pPalette: PPaletteEntry;
  SrcLevel: LongWord;
  Filter: DWord): HResult; stdcall;



//********************************************************************
// Introduced types for compatibility with "REVISED" D3DX8.pas translation
// by Ampaze (Tim Baumgarten) from www.Delphi-Jedi.org/DelphiGraphics
type
  PD3DXEffect_Desc      = PD3DXEffectDesc;
  PD3DXImage_Info       = PD3DXImageInfo;
  PD3DXParameter_Desc   = PD3DXParameterDesc;
  PD3DXPass_Desc        = PD3DXPassDesc;
  PD3DXRTE_Desc         = PD3DXRTEDesc;
  PD3DXRTS_Desc         = PD3DXRTSDesc;
  PD3DXTechnique_Desc   = PD3DXTechniqueDesc;

  TD3DXEffect_Desc      = TD3DXEffectDesc;
  TD3DXImage_Info       = TD3DXImageInfo;
  TD3DXParameter_Desc   = TD3DXParameterDesc;
  TD3DXPass_Desc        = TD3DXPassDesc;
  TD3DXRTE_Desc         = TD3DXRTEDesc;
  TD3DXRTS_Desc         = TD3DXRTSDesc;
  TD3DXTechnique_Desc   = TD3DXTechniqueDesc;


//***************************************************************************//
//***************************************************************************//
//***************************************************************************//
implementation
//***************************************************************************//
//***************************************************************************//
//***************************************************************************//






//////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 1998 Microsoft Corporation.  All Rights Reserved.
//
//  File:       d3dx8math.h
//  Content:    D3DX math types and functions
//
//////////////////////////////////////////////////////////////////////////////



//===========================================================================
//
// General purpose utilities
//
//===========================================================================


function D3DXToRadian(Degree: Single): Single;
begin
  Result:= Degree * (D3DX_PI / 180.0);
end;

function D3DXToDegree(Radian: Single): Single;
begin
  Result:= Radian * (180.0 / D3DX_PI);
end;


//--------------------------
// 2D Vector
//--------------------------

function D3DXVector2(_x, _y: Single): TD3DXVector2;
begin
  Result.x:= _x; Result.y:= _y;
end;

function D3DXVector2Equal(const v1, v2: TD3DXVector2): Boolean;
begin
  Result:= (v1.x = v2.x) and (v1.y = v2.y);
end;


//--------------------------
// 3D Vector
//--------------------------
function D3DXVector3(_x, _y, _z: Single): TD3DXVector3;
begin
  Result.x:= _x; Result.y:= _y; Result.z:=_z;
end;

function D3DXVector3Equal(const v1, v2: TD3DXVector3): Boolean;
begin
  Result:= (v1.x = v2.x) and (v1.y = v2.y) and (v1.z = v2.z);
end;


//--------------------------
// 4D Vector
//--------------------------

function D3DXVector4(_x, _y, _z, _w: Single): TD3DXVector4;
begin
  with Result do
  begin
    x:= _x; y:= _y; z:= _z; w:= _w;
  end;
end;

function D3DXVector4Equal(const v1, v2: TD3DXVector4): Boolean;
begin
  Result:= (v1.x = v2.x) and (v1.y = v2.y) and
    (v1.z = v2.z) and (v1.w = v2.w);
end;


//--------------------------
// 4D Matrix
//--------------------------
function D3DXMatrix(
  _m00, _m01, _m02, _m03,
  _m10, _m11, _m12, _m13,
  _m20, _m21, _m22, _m23,
  _m30, _m31, _m32, _m33: Single): TD3DXMatrix;
begin
  with Result do
  begin
    m[0,0]:= _m00; m[0,1]:= _m01; m[0,2]:= _m02; m[0,3]:= _m03;
    m[1,0]:= _m10; m[1,1]:= _m11; m[1,2]:= _m12; m[1,3]:= _m13;
    m[2,0]:= _m20; m[2,1]:= _m21; m[2,2]:= _m22; m[2,3]:= _m23;
    m[3,0]:= _m30; m[3,1]:= _m31; m[3,2]:= _m32; m[3,3]:= _m33;
  end;
end;

function D3DXMatrixAdd(out mOut: TD3DXMatrix; const m1,m2: TD3DXMatrix): PD3DXMatrix;
var
  pOut, p1, p2: PSingle; x: Integer;
begin
  pOut:= @mOut._11; p1:= @m1._11; p2:= @m2._11;
  for x:= 0 to 15 do
  begin
    pOut^:= p1^+p2^;
    Inc(pOut); Inc(p1); Inc(p2);
  end;
  Result:= @mOut;
end;

function D3DXMatrixSubtract(out mOut: TD3DXMatrix; const m1,m2: TD3DXMatrix): PD3DXMatrix;
var
  pOut, p1, p2: PSingle; x: Integer;
begin
  pOut:= @mOut._11; p1:= @m1._11; p2:= @m2._11;
  for x:= 0 to 15 do
  begin
    pOut^:= p1^-p2^;
    Inc(pOut); Inc(p1); Inc(p2);
  end;
  Result:= @mOut;
end;

function D3DXMatrixMul(out mOut: TD3DXMatrix; const m: TD3DXMatrix; MulBy: Single): PD3DXMatrix;
var
  pOut, p: PSingle; x: Integer;
begin
  pOut:= @mOut._11; p:= @m._11;
  for x:= 0 to 15 do
  begin
    pOut^:= p^* MulBy;
    Inc(pOut); Inc(p);
  end;
  Result:= @mOut;
end;

function D3DXMatrixEqual(const m1, m2: TD3DXMatrix): Boolean;
begin
  Result:= CompareMem(@m1, @m2, SizeOf(TD3DXMatrix));
end;

//--------------------------
// Quaternion
//--------------------------
function D3DXQuaternion(_x, _y, _z, _w: Single): TD3DXQuaternion;
begin
  with Result do
  begin
    x:= _x; y:= _y; z:= _z; w:= _w;
  end;
end;

function D3DXQuaternionAdd(const q1, q2: TD3DXQuaternion): TD3DXQuaternion;
begin
  with Result do
  begin
    x:= q1.x+q2.x; y:= q1.y+q2.y; z:= q1.z+q2.z; w:= q1.w+q2.w;
  end;
end;

function D3DXQuaternionSubtract(const q1, q2: TD3DXQuaternion): TD3DXQuaternion;
begin
  with Result do
  begin
    x:= q1.x-q2.x; y:= q1.y-q2.y; z:= q1.z-q2.z; w:= q1.w-q2.w;
  end;
end;

function D3DXQuaternionEqual(const q1, q2: TD3DXQuaternion): Boolean;
begin
  Result:= (q1.x = q2.x) and (q1.y = q2.y) and
    (q1.z = q2.z) and (q1.w = q2.w);
end;

function D3DXQuaternionScale(out qOut: TD3DXQuaternion; const q: TD3DXQuaternion;
  s: Single): PD3DXQuaternion;
begin
  with qOut do
  begin
    x:= q.x*s; y:= q.y*s; z:= q.z*s; w:= q.w*s;
  end;
  Result:= @qOut;
end;

//--------------------------
// Plane
//--------------------------

function D3DXPlane(_a, _b, _c, _d: Single): TD3DXPlane;
begin
  with Result do
  begin
    a:= _a; b:= _b; c:= _c; d:= _d;
  end;
end;


function D3DXPlaneEqual(const p1, p2: TD3DXPlane): Boolean;
begin
  Result:= (p1.a = p2.a) and (p1.b = p2.b) and
    (p1.c = p2.c) and (p1.d = p2.d);
end;

//--------------------------
// Color
//--------------------------

function D3DXColor(_r, _g, _b, _a: Single): TD3DXColor;
begin
  with Result do
  begin
    r:= _r; g:= _g; b:= _b; a:= _a;
  end;
end;

function D3DXColorToDWord(c: TD3DXColor): DWord;

  function ColorLimit(const x: Single): DWord;
  begin
    if x > 1.0 then Result:= 255
     else if x < 0 then Result:= 0
      else Result:= Trunc(x * 255.0 + 0.5);
  end;
begin
  Result:= ColorLimit(c.a) shl 24 or ColorLimit(c.r) shl 16
    or ColorLimit(c.g) shl 8 or ColorLimit(c.b);
end;

function D3DXColorFromDWord(c: DWord): TD3DXColor;
begin
  with Result do
  begin
    r:= ((c shr 24) and $0f) / 256;
    g:= ((c shr 16) and $0f) / 256;
    b:= ((c shr 8) and $0f) / 256;
    a:= ((c shr 0) and $0f) / 256;
  end;
end;

function D3DXColorEqual(const c1, c2: TD3DXColor): Boolean;
begin
  Result:= (c1.r = c2.r) and (c1.g = c2.g) and (c1.b = c2.b) and (c1.a = c2.a);
end;

//===========================================================================
//
// D3DX math functions:
//
// NOTE:
//  * All these functions can take the same object as in and out parameters.
//
//  * Out parameters are typically also returned as return values, so that
//    the output of one function may be used as a parameter to another.
//
//===========================================================================

//--------------------------
// 2D Vector
//--------------------------

// "inline"
function D3DXVec2Length(const v: TD3DXVector2): Single;
begin
  with v do Result:= Sqrt(Sqr(x)+Sqr(y));
end;

function D3DXVec2LengthSq(const v: TD3DXVector2): Single;
begin
  with v do Result:= Sqr(x) + Sqr(y);
end;

function D3DXVec2Dot(const v1, v2: TD3DXVector2): Single;
begin
  Result:= v1.x * v2.x + v1.y * v2.y;
end;

// Z component of ((x1,y1,0) cross (x2,y2,0))
function D3DXVec2CCW (const v1, v2: TD3DXVector2): Single;
begin
  Result:= v1.x * v2.y - v1.y * v2.x;
end;

function D3DXVec2Add(const v1, v2: TD3DXVector2): TD3DXVector2;
begin
  Result.x:= v1.x + v2.x; Result.y:= v1.y + v2.y;
end;

function D3DXVec2Subtract(const v1, v2: TD3DXVector2): TD3DXVector2;
begin
  Result.x:= v1.x - v2.x; Result.y:= v1.y - v2.y;
end;

// Minimize each component.  x = min(x1, x2), y = min(y1, y2)
function D3DXVec2Minimize(out vOut: TD3DXVector2; const v1, v2: TD3DXVEctor2): PD3DXVector2;
begin
  if v1.x < v2.x then vOut.x:= v1.x else vOut.y:= v2.x;
  if v1.y < v2.y then vOut.y:= v1.y else vOut.y:= v2.y;
  Result:= @vOut;
end;

// Maximize each component.  x = max(x1, x2), y = max(y1, y2)
function D3DXVec2Maximize(out vOut: TD3DXVector2; const v1, v2: TD3DXVector2): PD3DXVector2;
begin
  if v1.x > v2.x then vOut.x:= v1.x else vOut.y:= v2.x;
  if v1.y > v2.y then vOut.y:= v1.y else vOut.y:= v2.y;
  Result:= @vOut;
end;

function D3DXVec2Scale(out vOut: TD3DXVector2; const v: TD3DXVector2; s: Single): PD3DXVector2;
begin
  vOut.x:= v.x*s; vOut.y:= v.y*s;
  Result:= @vOut;
end;

// Linear interpolation. V1 + s(V2-V1)
function D3DXVec2Lerp(out vOut: TD3DXVector2; const v1, v2: TD3DXVector2; s: Single): PD3DXVector2;
begin
  vOut.x:= v1.x + s * (v2.x-v1.x);
  vOut.y:= v1.y + s * (v2.y-v1.y);
  Result:= @vOut;
end;


//--------------------------
// 3D Vector
//--------------------------
function D3DXVec3Length(const v: TD3DXVector3): Single;
begin
  with v do Result:= Sqrt(Sqr(x)+Sqr(y)+Sqr(z));
end;

function D3DXVec3LengthSq(const v: TD3DXVector3): Single;
begin
  with v do Result:= Sqr(x)+Sqr(y)+Sqr(z);
end;

function D3DXVec3Dot(const v1, v2: TD3DXVector3): Single;
begin
  Result:= v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
end;

function D3DXVec3Cross(out vOut: TD3DXVector3; const v1, v2: TD3DXVector3): PD3DXVector3;
begin
  vOut.x:= v1.y * v2.z - v1.z * v2.y;
  vOut.y:= v1.z * v2.x - v1.x * v2.z;
  vOut.z:= v1.x * v2.y - v1.y * v2.x;
  Result:= @vOut;
end;

function D3DXVec3Add(out vOut: TD3DXVector3; const v1, v2: TD3DXVector3): PD3DXVector3;
begin
  with vOut do
  begin
    x:= v1.x + v2.x;
    y:= v1.y + v2.y;
    z:= v1.z + v2.z;
  end;
  Result:= @vOut;
end;

function D3DXVec3Subtract(out vOut: TD3DXVector3; const v1, v2: TD3DXVector3): PD3DXVector3;
begin
  with vOut do
  begin
    x:= v1.x - v2.x;
    y:= v1.y - v2.y;
    z:= v1.z - v2.z;
  end;
  Result:= @vOut;
end;

// Minimize each component.  x = min(x1, x2), y = min(y1, y2)
function D3DXVec3Minimize(out vOut: TD3DXVector3; const v1, v2: TD3DXVector3): PD3DXVector3;
begin
  if v1.x < v2.x then vOut.x:= v1.x else vOut.x:= v2.x;
  if v1.y < v2.y then vOut.y:= v1.y else vOut.y:= v2.y;
  if v1.z < v2.z then vOut.z:= v1.z else vOut.z:= v2.z;
  Result:= @vOut;
end;

// Maximize each component.  x = max(x1, x2), y = max(y1, y2)
function D3DXVec3Maximize(out vOut: TD3DXVector3; const v1, v2: TD3DXVector3): PD3DXVector3;
begin
  if v1.x > v2.x then vOut.x:= v1.x else vOut.x:= v2.x;
  if v1.y > v2.y then vOut.y:= v1.y else vOut.y:= v2.y;
  if v1.z > v2.z then vOut.z:= v1.z else vOut.z:= v2.z;
  Result:= @vOut;
end;

function D3DXVec3Scale(out vOut: TD3DXVector3; const v: TD3DXVector3; s: Single): PD3DXVector3;
begin
  with vOut do
  begin
    x:= v.x * s; y:= v.y * s; z:= v.z * s;
  end;
  Result:= @vOut;
end;

// Linear interpolation. V1 + s(V2-V1)
function D3DXVec3Lerp(out vOut: TD3DXVector3; const v1, v2: TD3DXVector3; s: Single): PD3DXVector3;
begin
  vOut.x:= v1.x + s * (v2.x-v1.x);
  vOut.y:= v1.y + s * (v2.y-v1.y);
  vOut.z:= v1.z + s * (v2.z-v1.z);
  Result:= @vOut;
end;


//--------------------------
// 4D Vector
//--------------------------

function D3DXVec4Length(const v: TD3DXVector4): Single;
begin
  with v do Result:= Sqrt(Sqr(x)+Sqr(y)+Sqr(z)+Sqr(w));
end;

function D3DXVec4LengthSq(const v: TD3DXVector4): Single;
begin
  with v do Result:= Sqr(x)+Sqr(y)+Sqr(z)+Sqr(w);
end;

function D3DXVec4Dot(const v1, v2: TD3DXVector4): Single;
begin
  Result:= v1.x * v2.x + v1.y * v2.y + v1.z * v2.z + v1.w * v2.w;
end;

function D3DXVec4Add(out vOut: TD3DXVector4; const v1, v2: TD3DXVector4): PD3DXVector4;
begin
  with vOut do
  begin
    x:= v1.x + v2.x; y:= v1.y + v2.y;
    z:= v1.z + v2.z; w:= v1.w + v2.w;
  end;
  Result:= @vOut;
end;

function D3DXVec4Subtract(out vOut: TD3DXVector4; const v1, v2: TD3DXVector4): PD3DXVector4;
begin
  with vOut do
  begin
    x:= v1.x - v2.x; y:= v1.y - v2.y;
    z:= v1.z - v2.z; w:= v1.w - v2.w;
  end;
  Result:= @vOut;
end;


// Minimize each component.  x = min(x1, x2), y = min(y1, y2)
function D3DXVec4Minimize(out vOut: TD3DXVector4; const v1, v2: TD3DXVector4): PD3DXVector4;
begin
  if v1.x < v2.x then vOut.x:= v1.x else vOut.x:= v2.x;
  if v1.y < v2.y then vOut.y:= v1.y else vOut.y:= v2.y;
  if v1.z < v2.z then vOut.z:= v1.z else vOut.z:= v2.z;
  if v1.w < v2.w then vOut.w:= v1.w else vOut.w:= v2.w;
  Result:= @vOut;
end;

// Maximize each component.  x = max(x1, x2), y = max(y1, y2)
function D3DXVec4Maximize(out vOut: TD3DXVector4; const v1, v2: TD3DXVector4): PD3DXVector4;
begin
  if v1.x > v2.x then vOut.x:= v1.x else vOut.x:= v2.x;
  if v1.y > v2.y then vOut.y:= v1.y else vOut.y:= v2.y;
  if v1.z > v2.z then vOut.z:= v1.z else vOut.z:= v2.z;
  if v1.w > v2.w then vOut.w:= v1.w else vOut.w:= v2.w;
  Result:= @vOut;
end;

function D3DXVec4Scale(out vOut: TD3DXVector4; const v: TD3DXVector4; s: Single): PD3DXVector4;
begin
  with vOut do
  begin
    x:= v.x * s; y:= v.y * s; z:= v.z * s; w:= v.w * s;
  end;
  Result:= @vOut;
end;

// Linear interpolation. V1 + s(V2-V1)
function D3DXVec4Lerp(out vOut: TD3DXVector4;
  const v1, v2: TD3DXVector4; s: Single): PD3DXVector4;
begin
  with vOut do
  begin
    x:= v1.x + s * (v2.x - v1.x);
    y:= v1.y + s * (v2.y - v1.y);
    z:= v1.z + s * (v2.z - v1.z);
    w:= v1.w + s * (v2.w - v1.w);
  end;
  Result:= @vOut;
end;

//--------------------------
// 4D Matrix
//--------------------------

// inline
function D3DXMatrixIdentity(out mOut: TD3DXMatrix): PD3DXMatrix;
begin
  FillChar(mOut, SizeOf(mOut), 0);
  mOut._11:= 1; mOut._22:= 1; mOut._33:= 1; mOut._44:= 1;
  Result:= @mOut;
end;

function D3DXMatrixIsIdentity(const m: TD3DXMatrix): BOOL;
begin
  with m do Result:=
    (_11 = 1) and (_22 = 1) and (_33 = 1) and (_44 = 1) and
    (_12 + _13 + _14 + _21 + _23 + _24 + _31 + _32 + _34 + _41 + _42 + _43 = 0);
end;


//--------------------------
// Quaternion
//--------------------------

// inline

function D3DXQuaternionLength(const q: TD3DXQuaternion): Single;
begin
  with q do Result:= Sqrt(Sqr(x)+Sqr(y)+Sqr(z)+Sqr(w));
end;

// Length squared, or "norm"
function D3DXQuaternionLengthSq(const q: TD3DXQuaternion): Single;
begin
  with q do Result:= Sqr(x)+Sqr(y)+Sqr(z)+Sqr(w);
end;

function D3DXQuaternionDot(const q1, q2: TD3DXQuaternion): Single;
begin
  Result:= q1.x * q2.x + q1.y * q2.y + q1.z * q2.z + q1.w * q2.w;
end;

function D3DXQuaternionIdentity(out qOut: TD3DXQuaternion): PD3DXQuaternion;
begin
  with qOut do
  begin
    x:= 0; y:= 0; z:= 0; w:= 1.0;
  end;
  Result:= @qOut;
end;

function D3DXQuaternionIsIdentity(const q: TD3DXQuaternion): BOOL;
begin
  with q do Result:= (x+y+z = 0) and (w = 1.0);
end;

// (-x, -y, -z, w)
function D3DXQuaternionConjugate(out qOut: TD3DXQuaternion;
  const q: TD3DXQuaternion): PD3DXQuaternion;
begin
  with qOut do
  begin
    x:= -q.x; y:= -q.y; z:= -q.z; w:= q.w;
  end;
  Result:= @qOut;
end;


//--------------------------
// Plane
//--------------------------

// ax + by + cz + dw
function D3DXPlaneDot(const p: TD3DXPlane; const v: TD3DXVector4): Single;
begin
  with p,v do Result:= a*x + b*y + c*z + d*w;
end;

// ax + by + cz + d
function D3DXPlaneDotCoord(const p: TD3DXPlane; const v: TD3DXVector3): Single;
begin
  with p,v do Result:= a*x + b*y + c*z + d;
end;

// ax + by + cz
function D3DXPlaneDotNormal(const p: TD3DXPlane; const v: TD3DXVector3): Single;
begin
  with p,v do Result:= a*x + b*y + c*z;
end;


//--------------------------
// Color
//--------------------------

// inline

function D3DXColorNegative(out cOut: TD3DXColor; const c: TD3DXColor): PD3DXColor;
begin
 with cOut do
 begin
   r:= 1.0 - c.r; g:= 1.0 - c.g; b:= 1.0 - c.b;
   a:= c.a;
 end;
 Result:= @cOut;
end;

function D3DXColorAdd(out cOut: TD3DXColor; const c1,c2: TD3DXColor): PD3DXColor;
begin
  with cOut do
  begin
    r:= c1.r+c2.r; g:= c1.g + c2.g; b:= c1.b + c2.b;
    a:= c1.a + c2.a;
  end;
  Result:= @cOut;
end;

function D3DXColorSubtract(out cOut: TD3DXColor; const c1,c2: TD3DXColor): PD3DXColor;
begin
  with cOut do
  begin
    r:= c1.r-c2.r; g:= c1.g - c2.g; b:= c1.b - c2.b;
    a:= c1.a - c2.a;
  end;
  Result:= @cOut;
end;

function D3DXColorScale(out cOut: TD3DXColor; const c: TD3DXColor; s: Single): PD3DXColor;
begin
  with cOut do
  begin
    r:= c.r * s; g:= c.g * s;
    b:= c.b * s; a:= c.a * s;
  end;
  Result:= @cOut;
end;

// (r1*r2, g1*g2, b1*b2, a1*a2)
function D3DXColorModulate(out cOut: TD3DXColor; const c1,c2: TD3DXColor): PD3DXColor;
begin
  with cOut do
  begin
    r:= c1.r * c2.r; g:= c1.g * c2.g;
    b:= c1.b * c2.b; a:= c1.a * c2.a;
  end;
  Result:= @cOut;
end;

// Linear interpolation of r,g,b, and a. C1 + s(C2-C1)
function D3DXColorLerp(out cOut: TD3DXColor; const c1,c2: TD3DXColor; s: Single): PD3DXColor;
begin
  with cOut do
  begin
    r:= c1.r + s * (c2.r - c1.r);
    g:= c1.g + s * (c2.g - c1.g);
    b:= c1.b + s * (c2.b - c1.b);
    a:= c1.a + s * (c2.a - c1.a);
  end;
  Result:= @cOut;
end;


function D3DXVec2Normalize; external d3dx8dll;
function D3DXVec2Hermite; external d3dx8dll;
function D3DXVec2CatmullRom; external d3dx8dll;
function D3DXVec2BaryCentric; external d3dx8dll;
function D3DXVec2Transform; external d3dx8dll;
function D3DXVec2TransformCoord; external d3dx8dll;
function D3DXVec2TransformNormal; external d3dx8dll;

function D3DXVec3Normalize; external d3dx8dll;
function D3DXVec3Hermite; external d3dx8dll;
function D3DXVec3CatmullRom; external d3dx8dll;
function D3DXVec3BaryCentric; external d3dx8dll;
function D3DXVec3Transform; external d3dx8dll;
function D3DXVec3TransformCoord; external d3dx8dll;
function D3DXVec3TransformNormal; external d3dx8dll;
function D3DXVec3Project; external d3dx8dll;
function D3DXVec3Unproject; external d3dx8dll;

function D3DXVec4Cross; external d3dx8dll;
function D3DXVec4Normalize; external d3dx8dll;
function D3DXVec4Hermite; external d3dx8dll;
function D3DXVec4CatmullRom; external d3dx8dll;
function D3DXVec4BaryCentric; external d3dx8dll;
function D3DXVec4Transform; external d3dx8dll;

function D3DXMatrixfDeterminant; external d3dx8dll;
function D3DXMatrixMultiply; external d3dx8dll;
function D3DXMatrixTranspose; external d3dx8dll;
function D3DXMatrixInverse; external d3dx8dll;
function D3DXMatrixScaling; external d3dx8dll;
function D3DXMatrixTranslation; external d3dx8dll;
function D3DXMatrixRotationX; external d3dx8dll;
function D3DXMatrixRotationY; external d3dx8dll;
function D3DXMatrixRotationZ; external d3dx8dll;
function D3DXMatrixRotationAxis; external d3dx8dll;
function D3DXMatrixRotationQuaternion; external d3dx8dll;
function D3DXMatrixRotationYawPitchRoll; external d3dx8dll;
function D3DXMatrixTransformation; external d3dx8dll;
function D3DXMatrixAffineTransformation; external d3dx8dll;
function D3DXMatrixLookAtRH; external d3dx8dll;
function D3DXMatrixLookAtLH; external d3dx8dll;
function D3DXMatrixPerspectiveRH; external d3dx8dll;
function D3DXMatrixPerspectiveLH; external d3dx8dll;
function D3DXMatrixPerspectiveFovRH; external d3dx8dll;
function D3DXMatrixPerspectiveFovLH; external d3dx8dll;
function D3DXMatrixPerspectiveOffCenterRH; external d3dx8dll;
function D3DXMatrixPerspectiveOffCenterLH; external d3dx8dll;
function D3DXMatrixOrthoRH; external d3dx8dll;
function D3DXMatrixOrthoLH; external d3dx8dll;
function D3DXMatrixOrthoOffCenterRH; external d3dx8dll;
function D3DXMatrixOrthoOffCenterLH; external d3dx8dll;
function D3DXMatrixShadow; external d3dx8dll;
function D3DXMatrixReflect; external d3dx8dll;

procedure D3DXQuaternionToAxisAngle; external d3dx8dll;
function D3DXQuaternionRotationMatrix; external d3dx8dll;
function D3DXQuaternionRotationAxis; external d3dx8dll;
function D3DXQuaternionRotationYawPitchRoll; external d3dx8dll;
function D3DXQuaternionMultiply; external d3dx8dll;
function D3DXQuaternionNormalize; external d3dx8dll;
function D3DXQuaternionInverse; external d3dx8dll;
function D3DXQuaternionLn; external d3dx8dll;
function D3DXQuaternionExp; external d3dx8dll;
function D3DXQuaternionSlerp; external d3dx8dll;
function D3DXQuaternionSquad; external d3dx8dll;
function D3DXQuaternionBaryCentric; external d3dx8dll;

function D3DXPlaneNormalize; external d3dx8dll;
function D3DXPlaneIntersectLine; external d3dx8dll;
function D3DXPlaneFromPointNormal; external d3dx8dll;
function D3DXPlaneFromPoints; external d3dx8dll;
function D3DXPlaneTransform; external d3dx8dll;

function D3DXColorAdjustSaturation; external d3dx8dll;
function D3DXColorAdjustContrast; external d3dx8dll;

function D3DXCreateMatrixStack; external d3dx8dll;







///////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 1999 Microsoft Corporation.  All Rights Reserved.
//
//  File:       d3dx8core.h
//  Content:    D3DX core types and functions
//
///////////////////////////////////////////////////////////////////////////


function D3DXCreateFont; external d3dx8dll;
function D3DXCreateFontIndirect; external d3dx8dll;

function D3DXCreateSprite; external d3dx8dll;

function D3DXCreateRenderToSurface; external d3dx8dll;
function D3DXCreateRenderToEnvMap; external d3dx8dll;

function D3DXAssembleShaderFromFileA; external d3dx8dll name 'D3DXAssembleShaderFromFileA';
function D3DXAssembleShaderFromFileW; external d3dx8dll name 'D3DXAssembleShaderFromFileW';
function D3DXAssembleShaderFromFile; external d3dx8dll name 'D3DXAssembleShaderFromFileA';
function D3DXAssembleShader; external d3dx8dll;

function D3DXGetFVFVertexSize; external d3dx8dll;

function D3DXGetErrorStringCharA(hr: HResult; pBuffer: PAnsiChar; BufferLen: LongWord): HResult; external d3dx8dll name 'D3DXGetErrorStringA';
function D3DXGetErrorStringW(hr: HResult; pBuffer: PWideChar; BufferLen: LongWord): HResult; external d3dx8dll name 'D3DXGetErrorStringW';

// Object Pascal support functions for D3DXGetErrorString
function D3DXGetErrorStringPascalA(hr: HResult): String;
var
  Buffer: array [0..254] of Char;
begin
  D3DXGetErrorString(hr, PAnsiChar(@Buffer), 255);
  SetLength(Result, StrLen(PAnsiChar(@Buffer)));
  Move(Buffer, Result[1], Length(Result));
end;






///////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 1999 Microsoft Corporation.  All Rights Reserved.
//
//  File:       d3dx8effect.h
//  Content:    D3DX effect types and functions
//
///////////////////////////////////////////////////////////////////////////


function D3DXCompileEffectFromFileA; external d3dx8dll name 'D3DXCompileEffectFromFileA';
function D3DXCompileEffectFromFileW; external d3dx8dll name 'D3DXCompileEffectFromFileW';
function D3DXCompileEffectFromFile; external d3dx8dll name 'D3DXCompileEffectFromFileA';
function D3DXCompileEffect; external d3dx8dll;
function D3DXCreateEffect; external d3dx8dll;







//////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 1998 Microsoft Corporation.  All Rights Reserved.
//
//  File:       d3dx8mesh.h
//  Content:    D3DX mesh types and functions
//
//////////////////////////////////////////////////////////////////////////////


function D3DXCreateMesh; external d3dx8dll;
function D3DXCreateMeshFVF; external d3dx8dll;
function D3DXCreateSPMesh; external d3dx8dll;
function D3DXCleanMesh; external d3dx8dll;
function D3DXValidMesh; external d3dx8dll;
function D3DXGeneratePMesh; external d3dx8dll;
function D3DXSimplifyMesh; external d3dx8dll;
function D3DXComputeBoundingSphere; external d3dx8dll;
function D3DXComputeBoundingBox; external d3dx8dll;
function D3DXComputeNormals; external d3dx8dll;
function D3DXCreateBuffer; external d3dx8dll;
function D3DXLoadMeshFromX; external d3dx8dll;
function D3DXSaveMeshToX; external d3dx8dll;
function D3DXCreatePMeshFromStream; external d3dx8dll;
function D3DXCreateSkinMesh; external d3dx8dll;
function D3DXCreateSkinMeshFVF; external d3dx8dll;
function D3DXCreateSkinMeshFromMesh; external d3dx8dll;
function D3DXLoadMeshFromXof; external d3dx8dll;
function D3DXLoadSkinMeshFromXof; external d3dx8dll;
function D3DXTesselateMesh; external d3dx8dll;
function D3DXDeclaratorFromFVF; external d3dx8dll;
function D3DXFVFFromDeclarator; external d3dx8dll;
function D3DXWeldVertices; external d3dx8dll;
function D3DXIntersect; external d3dx8dll;
function D3DXSphereBoundProbe; external d3dx8dll;
function D3DXBoxBoundProbe; external d3dx8dll;







///////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 1999 Microsoft Corporation.  All Rights Reserved.
//
//  File:       d3dx8shapes.h
//  Content:    D3DX simple shapes
//
///////////////////////////////////////////////////////////////////////////


function D3DXCreatePolygon; external d3dx8dll;
function D3DXCreateBox; external d3dx8dll;
function D3DXCreateCylinder; external d3dx8dll;
function D3DXCreateSphere; external d3dx8dll;
function D3DXCreateTorus; external d3dx8dll;
function D3DXCreateTeapot; external d3dx8dll;
function D3DXCreateTextA; external d3dx8dll name 'D3DXCreateTextA';
function D3DXCreateTextW; external d3dx8dll name 'D3DXCreateTextW';
function D3DXCreateText; external d3dx8dll name 'D3DXCreateTextA';







///////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 1999 Microsoft Corporation.  All Rights Reserved.
//
//  File:       d3dx8tex.h
//  Content:    D3DX texturing APIs
//
///////////////////////////////////////////////////////////////////////////


function D3DXLoadSurfaceFromFileA; external d3dx8dll name 'D3DXLoadSurfaceFromFileA';
function D3DXLoadSurfaceFromFileW; external d3dx8dll name 'D3DXLoadSurfaceFromFileW';
function D3DXLoadSurfaceFromFile; external d3dx8dll name 'D3DXLoadSurfaceFromFileA';
function D3DXLoadSurfaceFromResourceA; external d3dx8dll name 'D3DXLoadSurfaceFromResourceA';
function D3DXLoadSurfaceFromResourceW; external d3dx8dll name 'D3DXLoadSurfaceFromResourceW';
function D3DXLoadSurfaceFromResource; external d3dx8dll name 'D3DXLoadSurfaceFromResourceA';
function D3DXLoadSurfaceFromFileInMemory; external d3dx8dll;
function D3DXLoadSurfaceFromSurface; external d3dx8dll;
function D3DXLoadSurfaceFromMemory; external d3dx8dll;
function D3DXLoadVolumeFromVolume; external d3dx8dll;
function D3DXLoadVolumeFromMemory; external d3dx8dll;

function D3DXCheckTextureRequirements; external d3dx8dll;
function D3DXCreateTexture; external d3dx8dll;
function D3DXCreateTextureFromFileA; external d3dx8dll name 'D3DXCreateTextureFromFileA';
function D3DXCreateTextureFromFileW; external d3dx8dll name 'D3DXCreateTextureFromFileW';
function D3DXCreateTextureFromFile; external d3dx8dll name 'D3DXCreateTextureFromFileA';
function D3DXCreateTextureFromResourceA; external d3dx8dll name 'D3DXCreateTextureFromResourceA';
function D3DXCreateTextureFromResourceW; external d3dx8dll name 'D3DXCreateTextureFromResourceW';
function D3DXCreateTextureFromResource; external d3dx8dll name 'D3DXCreateTextureFromResourceA';
function D3DXCreateTextureFromFileExA; external d3dx8dll name 'D3DXCreateTextureFromFileExA';
function D3DXCreateTextureFromFileExW; external d3dx8dll name 'D3DXCreateTextureFromFileExW';
function D3DXCreateTextureFromFileEx; external d3dx8dll name 'D3DXCreateTextureFromFileExA';
function D3DXCreateTextureFromResourceExA; external d3dx8dll name 'D3DXCreateTextureFromResourceExA';
function D3DXCreateTextureFromResourceExW; external d3dx8dll name 'D3DXCreateTextureFromResourceExW';
function D3DXCreateTextureFromResourceEx; external d3dx8dll name 'D3DXCreateTextureFromResourceExA';
function D3DXCreateTextureFromFileInMemory; external d3dx8dll;
function D3DXCreateTextureFromFileInMemoryEx; external d3dx8dll;
function D3DXFilterTexture; external d3dx8dll;
function D3DXCheckCubeTextureRequirements; external d3dx8dll;
function D3DXCreateCubeTexture; external d3dx8dll;
function D3DXCreateCubeTextureFromFileA; external d3dx8dll name 'D3DXCreateCubeTextureFromFileA';
function D3DXCreateCubeTextureFromFileW; external d3dx8dll name 'D3DXCreateCubeTextureFromFileW';
function D3DXCreateCubeTextureFromFile; external d3dx8dll name 'D3DXCreateCubeTextureFromFileA';
function D3DXCreateCubeTextureFromFileExA; external d3dx8dll name 'D3DXCreateCubeTextureFromFileExA';
function D3DXCreateCubeTextureFromFileExW; external d3dx8dll name 'D3DXCreateCubeTextureFromFileExW';
function D3DXCreateCubeTextureFromFileEx; external d3dx8dll name 'D3DXCreateCubeTextureFromFileExA';
function D3DXCreateCubeTextureFromFileInMemory; external d3dx8dll;
function D3DXCreateCubeTextureFromFileInMemoryEx; external d3dx8dll;
function D3DXFilterCubeTexture; external d3dx8dll;
function D3DXCheckVolumeTextureRequirements; external d3dx8dll;
function D3DXCreateVolumeTexture; external d3dx8dll;
function D3DXFilterVolumeTexture; external d3dx8dll;

end.

