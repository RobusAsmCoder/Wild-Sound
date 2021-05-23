(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit OpenGL API interface unit                *)
(*       Based on dlu.h, gl.h, glaux.h                          *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Copyright (c) 1996 Silicon Graphics, Inc.              *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

(*
** Copyright 1996 Silicon Graphics, Inc.
** All Rights Reserved.
**
** This is UNPUBLISHED PROPRIETARY SOURCE CODE of Silicon Graphics, Inc.;
** the contents of this file may not be disclosed to third parties, copied or
** duplicated in any form, in whole or in part, without the prior written
** permission of Silicon Graphics, Inc.
**
** RESTRICTED RIGHTS LEGEND:
** Use, duplication or disclosure by the Government is subject to restrictions
** as set forth in subdivision (c)(1)(ii) of the Rights in Technical Data
** and Computer Software clause at DFARS 252.227-7013, and/or in similar or
** successor clauses in the FAR, DOD or NASA FAR Supplement. Unpublished -
** rights reserved under the Copyright Laws of the United States.
*)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit OpenGL;

interface

uses Windows;

const
  glu32dll    = 'glu32.dll';
  opengl32dll = 'opengl32.dll';
  glauxdll    = 'glaux.dll';

(* AttribMask *)
  GL_CURRENT_BIT                      = $00000001;
  GL_POINT_BIT                        = $00000002;
  GL_LINE_BIT                         = $00000004;
  GL_POLYGON_BIT                      = $00000008;
  GL_POLYGON_STIPPLE_BIT              = $00000010;
  GL_PIXEL_MODE_BIT                   = $00000020;
  GL_LIGHTING_BIT                     = $00000040;
  GL_FOG_BIT                          = $00000080;
  GL_DEPTH_BUFFER_BIT                 = $00000100;
  GL_ACCUM_BUFFER_BIT                 = $00000200;
  GL_STENCIL_BUFFER_BIT               = $00000400;
  GL_VIEWPORT_BIT                     = $00000800;
  GL_TRANSFORM_BIT                    = $00001000;
  GL_ENABLE_BIT                       = $00002000;
  GL_COLOR_BUFFER_BIT                 = $00004000;
  GL_HINT_BIT                         = $00008000;
  GL_EVAL_BIT                         = $00010000;
  GL_LIST_BIT                         = $00020000;
  GL_TEXTURE_BIT                      = $00040000;
  GL_SCISSOR_BIT                      = $00080000;
  GL_ALL_ATTRIB_BITS                  = $000fffff;

(* Boolean *)
  GL_FALSE                            = ByteFALSE;
  GL_TRUE                             = ByteTRUE;

(* BeginMode *)
  GL_POINTS                           = $0000;
  GL_LINES                            = $0001;
  GL_LINE_LOOP                        = $0002;
  GL_LINE_STRIP                       = $0003;
  GL_TRIANGLES                        = $0004;
  GL_TRIANGLE_STRIP                   = $0005;
  GL_TRIANGLE_FAN                     = $0006;
  GL_QUADS                            = $0007;
  GL_QUAD_STRIP                       = $0008;
  GL_POLYGON                          = $0009;

(* AccumOp *)
  GL_ACCUM                            = $0100;
  GL_LOAD                             = $0101;
  GL_RETURN                           = $0102;
  GL_MULT                             = $0103;
  GL_ADD                              = $0104;

(* AlphaFunction *)
  GL_NEVER                            = $0200;
  GL_LESS                             = $0201;
  GL_EQUAL                            = $0202;
  GL_LEQUAL                           = $0203;
  GL_GREATER                          = $0204;
  GL_NOTEQUAL                         = $0205;
  GL_GEQUAL                           = $0206;
  GL_ALWAYS                           = $0207;

(* BlendingFactorDest *)
  GL_ZERO                             = 0;
  GL_ONE                              = 1;
  GL_SRC_COLOR                        = $0300;
  GL_ONE_MINUS_SRC_COLOR              = $0301;
  GL_SRC_ALPHA                        = $0302;
  GL_ONE_MINUS_SRC_ALPHA              = $0303;
  GL_DST_ALPHA                        = $0304;
  GL_ONE_MINUS_DST_ALPHA              = $0305;

(* BlendingFactorSrc *)
  GL_DST_COLOR                        = $0306;
  GL_ONE_MINUS_DST_COLOR              = $0307;
  GL_SRC_ALPHA_SATURATE               = $0308;

(* DrawBufferMode *)
  GL_NONE                             = 0;
  GL_FRONT_LEFT                       = $0400;
  GL_FRONT_RIGHT                      = $0401;
  GL_BACK_LEFT                        = $0402;
  GL_BACK_RIGHT                       = $0403;
  GL_FRONT                            = $0404;
  GL_BACK                             = $0405;
  GL_LEFT                             = $0406;
  GL_RIGHT                            = $0407;
  GL_FRONT_AND_BACK                   = $0408;
  GL_AUX0                             = $0409;
  GL_AUX1                             = $040A;
  GL_AUX2                             = $040B;
  GL_AUX3                             = $040C;

(* ErrorCode *)
  GL_NO_ERROR                         = 0;
  GL_INVALID_ENUM                     = $0500;
  GL_INVALID_VALUE                    = $0501;
  GL_INVALID_OPERATION                = $0502;
  GL_STACK_OVERFLOW                   = $0503;
  GL_STACK_UNDERFLOW                  = $0504;
  GL_OUT_OF_MEMORY                    = $0505;

(* FeedBackMode *)
  GL_2D                               = $0600;
  GL_3D                               = $0601;
  GL_3D_COLOR                         = $0602;
  GL_3D_COLOR_TEXTURE                 = $0603;
  GL_4D_COLOR_TEXTURE                 = $0604;

(* FeedBackToken *)
  GL_PASS_THROUGH_TOKEN               = $0700;
  GL_POINT_TOKEN                      = $0701;
  GL_LINE_TOKEN                       = $0702;
  GL_POLYGON_TOKEN                    = $0703;
  GL_BITMAP_TOKEN                     = $0704;
  GL_DRAW_PIXEL_TOKEN                 = $0705;
  GL_COPY_PIXEL_TOKEN                 = $0706;
  GL_LINE_RESET_TOKEN                 = $0707;

(* FogMode *)
  GL_EXP                              = $0800;
  GL_EXP2                             = $0801;

(* FrontFaceDirection *)
  GL_CW                               = $0900;
  GL_CCW                              = $0901;

(* GetMapTarget *)
  GL_COEFF                            = $0A00;
  GL_ORDER                            = $0A01;
  GL_DOMAIN                           = $0A02;

(* GetPixelMap *)
  GL_PIXEL_MAP_I_TO_I                 = $0C70;
  GL_PIXEL_MAP_S_TO_S                 = $0C71;
  GL_PIXEL_MAP_I_TO_R                 = $0C72;
  GL_PIXEL_MAP_I_TO_G                 = $0C73;
  GL_PIXEL_MAP_I_TO_B                 = $0C74;
  GL_PIXEL_MAP_I_TO_A                 = $0C75;
  GL_PIXEL_MAP_R_TO_R                 = $0C76;
  GL_PIXEL_MAP_G_TO_G                 = $0C77;
  GL_PIXEL_MAP_B_TO_B                 = $0C78;
  GL_PIXEL_MAP_A_TO_A                 = $0C79;

(* GetTarget *)
  GL_CURRENT_COLOR                    = $0B00;
  GL_CURRENT_INDEX                    = $0B01;
  GL_CURRENT_NORMAL                   = $0B02;
  GL_CURRENT_TEXTURE_COORDS           = $0B03;
  GL_CURRENT_RASTER_COLOR             = $0B04;
  GL_CURRENT_RASTER_INDEX             = $0B05;
  GL_CURRENT_RASTER_TEXTURE_COORDS    = $0B06;
  GL_CURRENT_RASTER_POSITION          = $0B07;
  GL_CURRENT_RASTER_POSITION_VALID    = $0B08;
  GL_CURRENT_RASTER_DISTANCE          = $0B09;
  GL_POINT_SMOOTH                     = $0B10;
  GL_POINT_SIZE                       = $0B11;
  GL_POINT_SIZE_RANGE                 = $0B12;
  GL_POINT_SIZE_GRANULARITY           = $0B13;
  GL_LINE_SMOOTH                      = $0B20;
  GL_LINE_WIDTH                       = $0B21;
  GL_LINE_WIDTH_RANGE                 = $0B22;
  GL_LINE_WIDTH_GRANULARITY           = $0B23;
  GL_LINE_STIPPLE                     = $0B24;
  GL_LINE_STIPPLE_PATTERN             = $0B25;
  GL_LINE_STIPPLE_REPEAT              = $0B26;
  GL_LIST_MODE                        = $0B30;
  GL_MAX_LIST_NESTING                 = $0B31;
  GL_LIST_BASE                        = $0B32;
  GL_LIST_INDEX                       = $0B33;
  GL_POLYGON_MODE                     = $0B40;
  GL_POLYGON_SMOOTH                   = $0B41;
  GL_POLYGON_STIPPLE                  = $0B42;
  GL_EDGE_FLAG                        = $0B43;
  GL_CULL_FACE                        = $0B44;
  GL_CULL_FACE_MODE                   = $0B45;
  GL_FRONT_FACE                       = $0B46;
  GL_LIGHTING                         = $0B50;
  GL_LIGHT_MODEL_LOCAL_VIEWER         = $0B51;
  GL_LIGHT_MODEL_TWO_SIDE             = $0B52;
  GL_LIGHT_MODEL_AMBIENT              = $0B53;
  GL_SHADE_MODEL                      = $0B54;
  GL_COLOR_MATERIAL_FACE              = $0B55;
  GL_COLOR_MATERIAL_PARAMETER         = $0B56;
  GL_COLOR_MATERIAL                   = $0B57;
  GL_FOG                              = $0B60;
  GL_FOG_INDEX                        = $0B61;
  GL_FOG_DENSITY                      = $0B62;
  GL_FOG_START                        = $0B63;
  GL_FOG_END                          = $0B64;
  GL_FOG_MODE                         = $0B65;
  GL_FOG_COLOR                        = $0B66;
  GL_DEPTH_RANGE                      = $0B70;
  GL_DEPTH_TEST                       = $0B71;
  GL_DEPTH_WRITEMASK                  = $0B72;
  GL_DEPTH_CLEAR_VALUE                = $0B73;
  GL_DEPTH_FUNC                       = $0B74;
  GL_ACCUM_CLEAR_VALUE                = $0B80;
  GL_STENCIL_TEST                     = $0B90;
  GL_STENCIL_CLEAR_VALUE              = $0B91;
  GL_STENCIL_FUNC                     = $0B92;
  GL_STENCIL_VALUE_MASK               = $0B93;
  GL_STENCIL_FAIL                     = $0B94;
  GL_STENCIL_PASS_DEPTH_FAIL          = $0B95;
  GL_STENCIL_PASS_DEPTH_PASS          = $0B96;
  GL_STENCIL_REF                      = $0B97;
  GL_STENCIL_WRITEMASK                = $0B98;
  GL_MATRIX_MODE                      = $0BA0;
  GL_NORMALIZE                        = $0BA1;
  GL_VIEWPORT                         = $0BA2;
  GL_MODELVIEW_STACK_DEPTH            = $0BA3;
  GL_PROJECTION_STACK_DEPTH           = $0BA4;
  GL_TEXTURE_STACK_DEPTH              = $0BA5;
  GL_MODELVIEW_MATRIX                 = $0BA6;
  GL_PROJECTION_MATRIX                = $0BA7;
  GL_TEXTURE_MATRIX                   = $0BA8;
  GL_ATTRIB_STACK_DEPTH               = $0BB0;
  GL_ALPHA_TEST                       = $0BC0;
  GL_ALPHA_TEST_FUNC                  = $0BC1;
  GL_ALPHA_TEST_REF                   = $0BC2;
  GL_DITHER                           = $0BD0;
  GL_BLEND_DST                        = $0BE0;
  GL_BLEND_SRC                        = $0BE1;
  GL_BLEND                            = $0BE2;
  GL_LOGIC_OP_MODE                    = $0BF0;
  GL_LOGIC_OP                         = $0BF1;
  GL_AUX_BUFFERS                      = $0C00;
  GL_DRAW_BUFFER                      = $0C01;
  GL_READ_BUFFER                      = $0C02;
  GL_SCISSOR_BOX                      = $0C10;
  GL_SCISSOR_TEST                     = $0C11;
  GL_INDEX_CLEAR_VALUE                = $0C20;
  GL_INDEX_WRITEMASK                  = $0C21;
  GL_COLOR_CLEAR_VALUE                = $0C22;
  GL_COLOR_WRITEMASK                  = $0C23;
  GL_INDEX_MODE                       = $0C30;
  GL_RGBA_MODE                        = $0C31;
  GL_DOUBLEBUFFER                     = $0C32;
  GL_STEREO                           = $0C33;
  GL_RENDER_MODE                      = $0C40;
  GL_PERSPECTIVE_CORRECTION_HINT      = $0C50;
  GL_POINT_SMOOTH_HINT                = $0C51;
  GL_LINE_SMOOTH_HINT                 = $0C52;
  GL_POLYGON_SMOOTH_HINT              = $0C53;
  GL_FOG_HINT                         = $0C54;
  GL_TEXTURE_GEN_S                    = $0C60;
  GL_TEXTURE_GEN_T                    = $0C61;
  GL_TEXTURE_GEN_R                    = $0C62;
  GL_TEXTURE_GEN_Q                    = $0C63;
  GL_PIXEL_MAP_I_TO_I_SIZE            = $0CB0;
  GL_PIXEL_MAP_S_TO_S_SIZE            = $0CB1;
  GL_PIXEL_MAP_I_TO_R_SIZE            = $0CB2;
  GL_PIXEL_MAP_I_TO_G_SIZE            = $0CB3;
  GL_PIXEL_MAP_I_TO_B_SIZE            = $0CB4;
  GL_PIXEL_MAP_I_TO_A_SIZE            = $0CB5;
  GL_PIXEL_MAP_R_TO_R_SIZE            = $0CB6;
  GL_PIXEL_MAP_G_TO_G_SIZE            = $0CB7;
  GL_PIXEL_MAP_B_TO_B_SIZE            = $0CB8;
  GL_PIXEL_MAP_A_TO_A_SIZE            = $0CB9;
  GL_UNPACK_SWAP_BYTES                = $0CF0;
  GL_UNPACK_LSB_FIRST                 = $0CF1;
  GL_UNPACK_ROW_LENGTH                = $0CF2;
  GL_UNPACK_SKIP_ROWS                 = $0CF3;
  GL_UNPACK_SKIP_PIXELS               = $0CF4;
  GL_UNPACK_ALIGNMENT                 = $0CF5;
  GL_PACK_SWAP_BYTES                  = $0D00;
  GL_PACK_LSB_FIRST                   = $0D01;
  GL_PACK_ROW_LENGTH                  = $0D02;
  GL_PACK_SKIP_ROWS                   = $0D03;
  GL_PACK_SKIP_PIXELS                 = $0D04;
  GL_PACK_ALIGNMENT                   = $0D05;
  GL_MAP_COLOR                        = $0D10;
  GL_MAP_STENCIL                      = $0D11;
  GL_INDEX_SHIFT                      = $0D12;
  GL_INDEX_OFFSET                     = $0D13;
  GL_RED_SCALE                        = $0D14;
  GL_RED_BIAS                         = $0D15;
  GL_ZOOM_X                           = $0D16;
  GL_ZOOM_Y                           = $0D17;
  GL_GREEN_SCALE                      = $0D18;
  GL_GREEN_BIAS                       = $0D19;
  GL_BLUE_SCALE                       = $0D1A;
  GL_BLUE_BIAS                        = $0D1B;
  GL_ALPHA_SCALE                      = $0D1C;
  GL_ALPHA_BIAS                       = $0D1D;
  GL_DEPTH_SCALE                      = $0D1E;
  GL_DEPTH_BIAS                       = $0D1F;
  GL_MAX_EVAL_ORDER                   = $0D30;
  GL_MAX_LIGHTS                       = $0D31;
  GL_MAX_CLIP_PLANES                  = $0D32;
  GL_MAX_TEXTURE_SIZE                 = $0D33;
  GL_MAX_PIXEL_MAP_TABLE              = $0D34;
  GL_MAX_ATTRIB_STACK_DEPTH           = $0D35;
  GL_MAX_MODELVIEW_STACK_DEPTH        = $0D36;
  GL_MAX_NAME_STACK_DEPTH             = $0D37;
  GL_MAX_PROJECTION_STACK_DEPTH       = $0D38;
  GL_MAX_TEXTURE_STACK_DEPTH          = $0D39;
  GL_MAX_VIEWPORT_DIMS                = $0D3A;
  GL_SUBPIXEL_BITS                    = $0D50;
  GL_INDEX_BITS                       = $0D51;
  GL_RED_BITS                         = $0D52;
  GL_GREEN_BITS                       = $0D53;
  GL_BLUE_BITS                        = $0D54;
  GL_ALPHA_BITS                       = $0D55;
  GL_DEPTH_BITS                       = $0D56;
  GL_STENCIL_BITS                     = $0D57;
  GL_ACCUM_RED_BITS                   = $0D58;
  GL_ACCUM_GREEN_BITS                 = $0D59;
  GL_ACCUM_BLUE_BITS                  = $0D5A;
  GL_ACCUM_ALPHA_BITS                 = $0D5B;
  GL_NAME_STACK_DEPTH                 = $0D70;
  GL_AUTO_NORMAL                      = $0D80;
  GL_MAP1_COLOR_4                     = $0D90;
  GL_MAP1_INDEX                       = $0D91;
  GL_MAP1_NORMAL                      = $0D92;
  GL_MAP1_TEXTURE_COORD_1             = $0D93;
  GL_MAP1_TEXTURE_COORD_2             = $0D94;
  GL_MAP1_TEXTURE_COORD_3             = $0D95;
  GL_MAP1_TEXTURE_COORD_4             = $0D96;
  GL_MAP1_VERTEX_3                    = $0D97;
  GL_MAP1_VERTEX_4                    = $0D98;
  GL_MAP2_COLOR_4                     = $0DB0;
  GL_MAP2_INDEX                       = $0DB1;
  GL_MAP2_NORMAL                      = $0DB2;
  GL_MAP2_TEXTURE_COORD_1             = $0DB3;
  GL_MAP2_TEXTURE_COORD_2             = $0DB4;
  GL_MAP2_TEXTURE_COORD_3             = $0DB5;
  GL_MAP2_TEXTURE_COORD_4             = $0DB6;
  GL_MAP2_VERTEX_3                    = $0DB7;
  GL_MAP2_VERTEX_4                    = $0DB8;
  GL_MAP1_GRID_DOMAIN                 = $0DD0;
  GL_MAP1_GRID_SEGMENTS               = $0DD1;
  GL_MAP2_GRID_DOMAIN                 = $0DD2;
  GL_MAP2_GRID_SEGMENTS               = $0DD3;
  GL_TEXTURE_1D                       = $0DE0;
  GL_TEXTURE_2D                       = $0DE1;

(* GetTextureParameter *)
  GL_TEXTURE_WIDTH                    = $1000;
  GL_TEXTURE_HEIGHT                   = $1001;
  GL_TEXTURE_COMPONENTS               = $1003;
  GL_TEXTURE_BORDER_COLOR             = $1004;
  GL_TEXTURE_BORDER                   = $1005;

(* HintMode *)
  GL_DONT_CARE                        = $1100;
  GL_FASTEST                          = $1101;
  GL_NICEST                           = $1102;

(* LightParameter *)
  GL_AMBIENT                          = $1200;
  GL_DIFFUSE                          = $1201;
  GL_SPECULAR                         = $1202;
  GL_POSITION                         = $1203;
  GL_SPOT_DIRECTION                   = $1204;
  GL_SPOT_EXPONENT                    = $1205;
  GL_SPOT_CUTOFF                      = $1206;
  GL_CONSTANT_ATTENUATION             = $1207;
  GL_LINEAR_ATTENUATION               = $1208;
  GL_QUADRATIC_ATTENUATION            = $1209;

(* ListMode *)
  GL_COMPILE                          = $1300;
  GL_COMPILE_AND_EXECUTE              = $1301;

(* ListNameType *)
  GL_BYTE                             = $1400;
  GL_UNSIGNED_BYTE                    = $1401;
  GL_SHORT                            = $1402;
  GL_UNSIGNED_SHORT                   = $1403;
  GL_INT                              = $1404;
  GL_UNSIGNED_INT                     = $1405;
  GL_FLOAT                            = $1406;
  GL_2_BYTES                          = $1407;
  GL_3_BYTES                          = $1408;
  GL_4_BYTES                          = $1409;

(* LogicOp *)
  GL_CLEAR                            = $1500;
  GL_AND                              = $1501;
  GL_AND_REVERSE                      = $1502;
  GL_COPY                             = $1503;
  GL_AND_INVERTED                     = $1504;
  GL_NOOP                             = $1505;
  GL_XOR                              = $1506;
  GL_OR                               = $1507;
  GL_NOR                              = $1508;
  GL_EQUIV                            = $1509;
  GL_INVERT                           = $150A;
  GL_OR_REVERSE                       = $150B;
  GL_COPY_INVERTED                    = $150C;
  GL_OR_INVERTED                      = $150D;
  GL_NAND                             = $150E;
  GL_SET                              = $150F;

(* MaterialParameter *)
  GL_EMISSION                         = $1600;
  GL_SHININESS                        = $1601;
  GL_AMBIENT_AND_DIFFUSE              = $1602;
  GL_COLOR_INDEXES                    = $1603;

(* MatrixMode *)
  GL_MODELVIEW                        = $1700;
  GL_PROJECTION                       = $1701;
  GL_TEXTURE                          = $1702;

(* PixelCopyType *)
  GL_COLOR                            = $1800;
  GL_DEPTH                            = $1801;
  GL_STENCIL                          = $1802;

(* PixelFormat *)
  GL_COLOR_INDEX                      = $1900;
  GL_STENCIL_INDEX                    = $1901;
  GL_DEPTH_COMPONENT                  = $1902;
  GL_RED                              = $1903;
  GL_GREEN                            = $1904;
  GL_BLUE                             = $1905;
  GL_ALPHA                            = $1906;
  GL_RGB                              = $1907;
  GL_RGBA                             = $1908;
  GL_LUMINANCE                        = $1909;
  GL_LUMINANCE_ALPHA                  = $190A;

(* PixelType *)
  GL_BITMAP                           = $1A00;

(* PolygonMode *)
  GL_POINT                            = $1B00;
  GL_LINE                             = $1B01;
  GL_FILL                             = $1B02;

(* RenderingMode *)
  GL_RENDER                           = $1C00;
  GL_FEEDBACK                         = $1C01;
  GL_SELECT                           = $1C02;

(* ShadingModel *)
  GL_FLAT                             = $1D00;
  GL_SMOOTH                           = $1D01;

(* StencilOp *)
  GL_KEEP                             = $1E00;
  GL_REPLACE                          = $1E01;
  GL_INCR                             = $1E02;
  GL_DECR                             = $1E03;

(* StringName *)
  GL_VENDOR                           = $1F00;
  GL_RENDERER                         = $1F01;
  GL_VERSION                          = $1F02;
  GL_EXTENSIONS                       = $1F03;

(* TextureCoordName *)
  GL_S                                = $2000;
  GL_T                                = $2001;
  GL_R                                = $2002;
  GL_Q                                = $2003;

(* TextureEnvMode *)
  GL_MODULATE                         = $2100;
  GL_DECAL                            = $2101;

(* TextureEnvParameter *)
  GL_TEXTURE_ENV_MODE                 = $2200;
  GL_TEXTURE_ENV_COLOR                = $2201;

(* TextureEnvTarget *)
  GL_TEXTURE_ENV                      = $2300;

(* TextureGenMode *)
  GL_EYE_LINEAR                       = $2400;
  GL_OBJECT_LINEAR                    = $2401;
  GL_SPHERE_MAP                       = $2402;

(* TextureGenParameter *)
  GL_TEXTURE_GEN_MODE                 = $2500;
  GL_OBJECT_PLANE                     = $2501;
  GL_EYE_PLANE                        = $2502;

(* TextureMagFilter *)
  GL_NEAREST                          = $2600;
  GL_LINEAR                           = $2601;

(* TextureMinFilter *)
  GL_NEAREST_MIPMAP_NEAREST           = $2700;
  GL_LINEAR_MIPMAP_NEAREST            = $2701;
  GL_NEAREST_MIPMAP_LINEAR            = $2702;
  GL_LINEAR_MIPMAP_LINEAR             = $2703;

(* TextureParameterName *)
  GL_TEXTURE_MAG_FILTER               = $2800;
  GL_TEXTURE_MIN_FILTER               = $2801;
  GL_TEXTURE_WRAP_S                   = $2802;
  GL_TEXTURE_WRAP_T                   = $2803;

(* TextureWrapMode *)
  GL_CLAMP                            = $2900;
  GL_REPEAT                           = $2901;

(* ClipPlaneName *)
  GL_CLIP_PLANE0                      = $3000;
  GL_CLIP_PLANE1                      = $3001;
  GL_CLIP_PLANE2                      = $3002;
  GL_CLIP_PLANE3                      = $3003;
  GL_CLIP_PLANE4                      = $3004;
  GL_CLIP_PLANE5                      = $3005;

(* LightName *)
  GL_LIGHT0                           = $4000;
  GL_LIGHT1                           = $4001;
  GL_LIGHT2                           = $4002;
  GL_LIGHT3                           = $4003;
  GL_LIGHT4                           = $4004;
  GL_LIGHT5                           = $4005;
  GL_LIGHT6                           = $4006;
  GL_LIGHT7                           = $4007;

(* Extensions *)
  GL_EXT_vertex_array                 = 1;
  GL_WIN_swap_hint                    = 1;

(* EXT_vertex_array *)
  GL_VERTEX_ARRAY_EXT               = $8074;
  GL_NORMAL_ARRAY_EXT               = $8075;
  GL_COLOR_ARRAY_EXT                = $8076;
  GL_INDEX_ARRAY_EXT                = $8077;
  GL_TEXTURE_COORD_ARRAY_EXT        = $8078;
  GL_EDGE_FLAG_ARRAY_EXT            = $8079;
  GL_VERTEX_ARRAY_SIZE_EXT          = $807A;
  GL_VERTEX_ARRAY_TYPE_EXT          = $807B;
  GL_VERTEX_ARRAY_STRIDE_EXT        = $807C;
  GL_VERTEX_ARRAY_COUNT_EXT         = $807D;
  GL_NORMAL_ARRAY_TYPE_EXT          = $807E;
  GL_NORMAL_ARRAY_STRIDE_EXT        = $807F;
  GL_NORMAL_ARRAY_COUNT_EXT         = $8080;
  GL_COLOR_ARRAY_SIZE_EXT           = $8081;
  GL_COLOR_ARRAY_TYPE_EXT           = $8082;
  GL_COLOR_ARRAY_STRIDE_EXT         = $8083;
  GL_COLOR_ARRAY_COUNT_EXT          = $8084;
  GL_INDEX_ARRAY_TYPE_EXT           = $8085;
  GL_INDEX_ARRAY_STRIDE_EXT         = $8086;
  GL_INDEX_ARRAY_COUNT_EXT          = $8087;
  GL_TEXTURE_COORD_ARRAY_SIZE_EXT   = $8088;
  GL_TEXTURE_COORD_ARRAY_TYPE_EXT   = $8089;
  GL_TEXTURE_COORD_ARRAY_STRIDE_EXT = $808A;
  GL_TEXTURE_COORD_ARRAY_COUNT_EXT  = $808B;
  GL_EDGE_FLAG_ARRAY_STRIDE_EXT     = $808C;
  GL_EDGE_FLAG_ARRAY_COUNT_EXT      = $808D;
  GL_VERTEX_ARRAY_POINTER_EXT       = $808E;
  GL_NORMAL_ARRAY_POINTER_EXT       = $808F;
  GL_COLOR_ARRAY_POINTER_EXT        = $8090;
  GL_INDEX_ARRAY_POINTER_EXT        = $8091;
  GL_TEXTURE_COORD_ARRAY_POINTER_EXT = $8092;
  GL_EDGE_FLAG_ARRAY_POINTER_EXT    = $8093;

  WGL_FONT_LINES      = 0;
  WGL_FONT_POLYGONS   = 1;

(*****           Generic constants               *****)

(* Version *)
  GLU_VERSION_1_1  =               1;

(* Errors: (return value 0 = no error) *)
  GLU_INVALID_ENUM       = 100900;
  GLU_INVALID_VALUE      = 100901;
  GLU_OUT_OF_MEMORY      = 100902;
  GLU_INCOMPATIBLE_GL_VERSION  =   100903;

(* gets *)
  GLU_VERSION            = 100800;
  GLU_EXTENSIONS         = 100801;

(* For laughs: *)
  GLU_TRUE               = GL_TRUE;
  GLU_FALSE              = GL_FALSE;


(****           Quadric constants               ****)

(* Types of normals: *)
  GLU_SMOOTH             = 100000;
  GLU_FLAT               = 100001;
  GLU_NONE               = 100002;

(* DrawStyle types: *)
  GLU_POINT              = 100010;
  GLU_LINE               = 100011;
  GLU_FILL               = 100012;
  GLU_SILHOUETTE         = 100013;

(* Orientation types: *)
  GLU_OUTSIDE            = 100020;
  GLU_INSIDE             = 100021;

(****           Tesselation constants           ****)

  GLU_TESS_MAX_COORD     =         1.0e150;

(* Property types: *)
  GLU_TESS_WINDING_RULE  =         100110;
  GLU_TESS_BOUNDARY_ONLY =         100111;
  GLU_TESS_TOLERANCE     =         100112;

(* Possible winding rules: *)
  GLU_TESS_WINDING_ODD          =  100130;
  GLU_TESS_WINDING_NONZERO      =  100131;
  GLU_TESS_WINDING_POSITIVE     =  100132;
  GLU_TESS_WINDING_NEGATIVE     =  100133;
  GLU_TESS_WINDING_ABS_GEQ_TWO  =  100134;

(* Callback types: *)
  GLU_TESS_BEGIN     = 100100 ;
  GLU_TESS_VERTEX    = 100101 ;
  GLU_TESS_END       = 100102 ;
  GLU_TESS_ERROR     = 100103 ;
  GLU_TESS_EDGE_FLAG = 100104 ;
  GLU_TESS_COMBINE   = 100105 ;

(* Errors: *)
  GLU_TESS_ERROR1    = 100151;
  GLU_TESS_ERROR2    = 100152;
  GLU_TESS_ERROR3    = 100153;
  GLU_TESS_ERROR4    = 100154;
  GLU_TESS_ERROR5    = 100155;
  GLU_TESS_ERROR6    = 100156;
  GLU_TESS_ERROR7    = 100157;
  GLU_TESS_ERROR8    = 100158;

  GLU_TESS_MISSING_BEGIN_POLYGON  = GLU_TESS_ERROR1;
  GLU_TESS_MISSING_BEGIN_CONTOUR  = GLU_TESS_ERROR2;
  GLU_TESS_MISSING_END_POLYGON    = GLU_TESS_ERROR3;
  GLU_TESS_MISSING_END_CONTOUR    = GLU_TESS_ERROR4;
  GLU_TESS_COORD_TOO_LARGE        = GLU_TESS_ERROR5;
  GLU_TESS_NEED_COMBINE_CALLBACK  = GLU_TESS_ERROR6;

(****           NURBS constants                 ****)

(* Properties: *)
  GLU_AUTO_LOAD_MATRIX          =  100200;
  GLU_CULLING                   =  100201;
  GLU_SAMPLING_TOLERANCE        =  100203;
  GLU_DISPLAY_MODE              =  100204;
  GLU_PARAMETRIC_TOLERANCE      =  100202;
  GLU_SAMPLING_METHOD           =  100205;
  GLU_U_STEP                    =  100206;
  GLU_V_STEP                    =  100207;

(* Sampling methods: *)
  GLU_PATH_LENGTH               =  100215;
  GLU_PARAMETRIC_ERROR          =  100216;
  GLU_DOMAIN_DISTANCE           =  100217;

(* Trimming curve types *)
  GLU_MAP1_TRIM_2       =  100210;
  GLU_MAP1_TRIM_3       =  100211;

(* Display modes: *)
  GLU_OUTLINE_POLYGON    = 100240;
  GLU_OUTLINE_PATCH      = 100241;

(* Errors: *)
  GLU_NURBS_ERROR1       = 100251;
  GLU_NURBS_ERROR2       = 100252;
  GLU_NURBS_ERROR3       = 100253;
  GLU_NURBS_ERROR4       = 100254;
  GLU_NURBS_ERROR5       = 100255;
  GLU_NURBS_ERROR6       = 100256;
  GLU_NURBS_ERROR7       = 100257;
  GLU_NURBS_ERROR8       = 100258;
  GLU_NURBS_ERROR9       = 100259;
  GLU_NURBS_ERROR10      = 100260;
  GLU_NURBS_ERROR11      = 100261;
  GLU_NURBS_ERROR12      = 100262;
  GLU_NURBS_ERROR13      = 100263;
  GLU_NURBS_ERROR14      = 100264;
  GLU_NURBS_ERROR15      = 100265;
  GLU_NURBS_ERROR16      = 100266;
  GLU_NURBS_ERROR17      = 100267;
  GLU_NURBS_ERROR18      = 100268;
  GLU_NURBS_ERROR19      = 100269;
  GLU_NURBS_ERROR20      = 100270;
  GLU_NURBS_ERROR21      = 100271;
  GLU_NURBS_ERROR22      = 100272;
  GLU_NURBS_ERROR23      = 100273;
  GLU_NURBS_ERROR24      = 100274;
  GLU_NURBS_ERROR25      = 100275;
  GLU_NURBS_ERROR26      = 100276;
  GLU_NURBS_ERROR27      = 100277;
  GLU_NURBS_ERROR28      = 100278;
  GLU_NURBS_ERROR29      = 100279;
  GLU_NURBS_ERROR30      = 100280;
  GLU_NURBS_ERROR31      = 100281;
  GLU_NURBS_ERROR32      = 100282;
  GLU_NURBS_ERROR33      = 100283;
  GLU_NURBS_ERROR34      = 100284;
  GLU_NURBS_ERROR35      = 100285;
  GLU_NURBS_ERROR36      = 100286;
  GLU_NURBS_ERROR37      = 100287;


(*
** ToolKit Window Types
** In the future, AUX_RGBA may be a combination of both RGB and ALPHA
*)
  AUX_RGB             = 0;
  AUX_RGBA            = AUX_RGB;
  AUX_INDEX           = 1;
  AUX_SINGLE          = 0;
  AUX_DOUBLE          = 2;
  AUX_DIRECT          = 0;
  AUX_INDIRECT        = 4;

  AUX_ACCUM           = 8;
  AUX_ALPHA           = 16;
  AUX_DEPTH24         = 32;          (* 24-bit depth buffer *)
  AUX_STENCIL         = 64;
  AUX_AUX             = 128;
  AUX_DEPTH16         = 256;         (* 16-bit depth buffer *)
  AUX_FIXED_332_PAL   = 512;
  AUX_DEPTH           = AUX_DEPTH16; (* default is 16-bit depth buffer *)

(*
** ToolKit Event Types
*)
  AUX_EXPOSE      = 1;
  AUX_CONFIG      = 2;
  AUX_DRAW        = 4;
  AUX_KEYEVENT    = 8;
  AUX_MOUSEDOWN   = 16;
  AUX_MOUSEUP     = 32;
  AUX_MOUSELOC    = 64;

(*
** Toolkit Event Data Indices
*)
  AUX_WINDOWX             = 0;
  AUX_WINDOWY             = 1;
  AUX_MOUSEX              = 0;
  AUX_MOUSEY              = 1;
  AUX_MOUSESTATUS         = 3;
  AUX_KEY                 = 0;
  AUX_KEYSTATUS           = 1;

(*
** ToolKit Event Status Messages
*)
  AUX_LEFTBUTTON          = 1;
  AUX_RIGHTBUTTON         = 2;
  AUX_MIDDLEBUTTON        = 4;
  AUX_SHIFT               = 1;
  AUX_CONTROL             = 2;

(*
** ToolKit Key Codes
*)
  AUX_RETURN              = #$0D;
  AUX_ESCAPE              = #$1B;
  AUX_SPACE               = #$20;
  AUX_LEFT                = #$25;
  AUX_UP                  = #$26;
  AUX_RIGHT               = #$27;
  AUX_DOWN                = #$28;
  AUX_A                   = 'A';
  AUX_B                   = 'B';
  AUX_C                   = 'C';
  AUX_D                   = 'D';
  AUX_E                   = 'E';
  AUX_F                   = 'F';
  AUX_G                   = 'G';
  AUX_H                   = 'H';
  AUX_I                   = 'I';
  AUX_J                   = 'J';
  AUX_K                   = 'K';
  AUX_L                   = 'L';
  AUX_M                   = 'M';
  AUX_N                   = 'N';
  AUX_O                   = 'O';
  AUX_P                   = 'P';
  AUX_Q                   = 'Q';
  AUX_R                   = 'R';
  AUX_S                   = 'S';
  AUX_T                   = 'T';
  AUX_U                   = 'U';
  AUX_V                   = 'V';
  AUX_W                   = 'W';
  AUX_X                   = 'X';
  AUX_Y                   = 'Y';
  AUX_Z                   = 'Z';
  AUX_a_                  = 'a';
  AUX_b_                  = 'b';
  AUX_c_                  = 'c';
  AUX_d_                  = 'd';
  AUX_e_                  = 'e';
  AUX_f_                  = 'f';
  AUX_g_                  = 'g';
  AUX_h_                  = 'h';
  AUX_i_                  = 'i';
  AUX_j_                  = 'j';
  AUX_k_                  = 'k';
  AUX_l_                  = 'l';
  AUX_m_                  = 'm';
  AUX_n_                  = 'n';
  AUX_o_                  = 'o';
  AUX_p_                  = 'p';
  AUX_q_                  = 'q';
  AUX_r_                  = 'r';
  AUX_s_                  = 's';
  AUX_t_                  = 't';
  AUX_u_                  = 'u';
  AUX_v_                  = 'v';
  AUX_w_                  = 'w';
  AUX_x_                  = 'x';
  AUX_y_                  = 'y';
  AUX_z_                  = 'z';
  AUX_0                   = '0';
  AUX_1                   = '1';
  AUX_2                   = '2';
  AUX_3                   = '3';
  AUX_4                   = '4';
  AUX_5                   = '5';
  AUX_6                   = '6';
  AUX_7                   = '7';
  AUX_8                   = '8';
  AUX_9                   = '9';

(*
** ToolKit Gets and Sets
*)
  AUX_FD                  = 1;  (* return fd (long) *)
  AUX_COLORMAP            = 3;  (* pass buf of r, g and b (unsigned char) *)
  AUX_GREYSCALEMAP        = 4;
  AUX_FOGMAP              = 5;  (* pass fog and color bits (long) *)
  AUX_ONECOLOR            = 6;  (* pass index, r, g, and b (long) *)

{*
** Color Macros
*}
  AUX_BLACK               = 0;
  AUX_RED                 = 13;
  AUX_GREEN               = 14;
  AUX_YELLOW              = 15;
  AUX_BLUE                = 16;
  AUX_MAGENTA             = 17;
  AUX_CYAN                = 18;
  AUX_WHITE               = 19;

(*
** Viewperf support functions and constants
*)
(* Display Mode Selection Criteria *)
  AUX_USE_ID                  = 1;
  AUX_EXACT_MATCH             = 2;
  AUX_MINIMUM_CRITERIA        = 3;

type
  GLenum = DWORD;
  GLboolean = BYTEBOOL;
  GLbitfield = DWORD;
  GLbyte = Shortint;
  GLshort = SmallInt;
  GLint = Longint;
  GLsizei = Longint;
  GLubyte = Byte;
  GLushort = Word;
  GLuint = DWORD;
  GLfloat = Single;
  GLclampf = Single;
  GLdouble = Double;
  GLclampd = Double;
  HGLRC = THandle;

  PGLBoolean = ^GLBoolean;
  PGLByte = ^GLByte;
  PGLShort = ^GLShort;
  PGLInt = ^GLInt;
  PGLSizei = ^GLSizei;
  PGLubyte = ^GLubyte;
  PGLushort = ^GLushort;
  PGLuint = ^GLuint;
  PGLclampf = ^GLclampf;
  PGLfloat =  ^GLFloat;
  PGLdouble = ^GLDouble;
  PGLclampd = ^GLclampd;

(* EXT_vertex_array *)
  TGLARRAYELEMENTEXTPROC = procedure conv arg_stdcall (i: GLint);
  TGLDRAWARRAYSEXTPROC = procedure conv arg_stdcall (mode: GLenum; first: GLint; count: GLsizei);
  TGLVERTEXPOINTEREXTPROC = procedure conv arg_stdcall (size: GLint; type_: GLenum;
    stride, count: GLsizei; P: Pointer);
  TGLNORMALPOINTEREXTPROC = procedure conv arg_stdcall (type_: GLenum; stride, count: GLsizei;
    P: Pointer);
  TGLCOLORPOINTEREXTPROC = procedure conv arg_stdcall (size: GLint; type_: GLenum;
    stride, count: GLsizei; P: Pointer);
  TGLINDEXPOINTEREXTPROC = procedure conv arg_stdcall (type_: GLenum; stride, count: GLsizei;
    P: Pointer);
  TGLTEXCOORDPOINTEREXTPROC = procedure conv arg_stdcall (size: GLint; type_: GLenum;
    stride, count: GLsizei; P: Pointer);
  TGLEDGEFLAGPOINTEREXTPROC = procedure conv arg_stdcall (stride, count: GLsizei;
    P: PGLboolean);
  TGLGETPOINTERVEXTPROC = procedure conv arg_stdcall (pname: GLenum; var Params);

(* WIN_swap_hint *)

  TGLADDSWAPHINTRECTWINPROC = procedure conv arg_stdcall (x, y: GLint; width, height: GLsizei);

  TGLUquadricObj = record end;
  GLUquadricObj = ^TGLUquadricObj;

  TGLUtesselator = record end;
  GLUtesselator = ^TGLUtesselator;

(****           Callback function prototypes    ****)

(* gluQuadricCallback *)
  TGLUquadricErrorProc = procedure conv arg_stdcall (error: GLenum);

(* gluTessCallback *)
  TGLUtessBeginProc = procedure conv arg_stdcall (a: GLenum);
  TGLUtessEdgeFlagProc = procedure conv arg_stdcall (flag: GLboolean);
  TGLUtessVertexProc = procedure conv arg_stdcall (p: Pointer);
  TGLUtessEndProc = procedure conv arg_stdcall;
  TGLUtessErrorProc = TGLUquadricErrorProc;
  TGLUtessCombineProc = procedure conv arg_stdcall (a: PGLdouble; b: Pointer;
    c: PGLfloat; var d: Pointer);

  TGLUnurbsObj = record end;
  GLUnurbsObj = ^TGLUnurbsObj;

(* gluNurbsCallback *)
  TGLUnurbsErrorProc = TGLUquadricErrorProc;

(*
** RGB Image Structure
*)
  AUX_RGBImageRec= record
          sizeX, sizeY: GLint;
          data: pointer;
  end;
  TAUX_RGBImageRec= AUX_RGBImageRec;
  PTAUX_RGBImageRec= ^TAUX_RGBImageRec;

  LPCSTR  = Pointer;
  LPCWSTR = Pointer;

(*
** ToolKit Event Structure
*)
  AUX_EVENTREC = record
    event: GLint;
    data: array[0..3] of GLint;
  end;
  TAUX_EVENTREC = AUX_EVENTREC;

  TAUXMAINPROC    = procedure conv arg_cdecl;
  TAUXEXPOSEPROC  = procedure conv arg_cdecl(w, h: Longint);
  TAUXRESHAPEPROC = procedure conv arg_cdecl(w, h: GLsizei);
  TAUXIDLEPROC    = procedure conv arg_cdecl;
  TAUXKEYPROC     = procedure conv arg_cdecl;
  TAUXMOUSEPROC   = procedure conv arg_cdecl(var Even: AUX_EVENTREC);

procedure glAccum conv arg_stdcall (op: GLenum; value: GLfloat);
procedure glAlphaFunc conv arg_stdcall (func: GLenum; ref: GLclampf);
procedure glBegin conv arg_stdcall (mode: GLenum);
procedure glBitmap conv arg_stdcall (width, height: GLsizei; xorig, yorig: GLfloat; xmove, ymove: GLfloat; bitmap: Pointer);
procedure glBlendFunc conv arg_stdcall (sfactor, dfactor: GLenum);
procedure glCallList conv arg_stdcall (list: GLuint);
procedure glCallLists conv arg_stdcall (n: GLsizei; cltype: GLenum; lists: Pointer);
procedure glClear conv arg_stdcall (mask: GLbitfield);
procedure glClearAccum conv arg_stdcall (red, green, blue, alpha: GLfloat);
procedure glClearColor conv arg_stdcall (red, green, blue, alpha: GLclampf);
procedure glClearDepth conv arg_stdcall (depth: GLclampd);
procedure glClearIndex conv arg_stdcall (c: GLfloat);
procedure glClearStencil conv arg_stdcall (s: GLint);
procedure glClipPlane conv arg_stdcall (plane: GLenum; equation: PGLDouble);
procedure glColor3b conv arg_stdcall (red, green, blue: GLbyte);
procedure glColor3bv conv arg_stdcall (v: PGLByte);
procedure glColor3d conv arg_stdcall (red, green, blue: GLdouble);
procedure glColor3dv conv arg_stdcall (v: PGLdouble);
procedure glColor3f conv arg_stdcall (red, green, blue: GLfloat);
procedure glColor3fv conv arg_stdcall (v: PGLfloat);
procedure glColor3i conv arg_stdcall (red, green, blue: GLint);
procedure glColor3iv conv arg_stdcall (v: PGLint);
procedure glColor3s conv arg_stdcall (red, green, blue: GLshort);
procedure glColor3sv conv arg_stdcall (v: PGLshort);
procedure glColor3ub conv arg_stdcall (red, green, blue: GLubyte);
procedure glColor3ubv conv arg_stdcall (v: PGLubyte);
procedure glColor3ui conv arg_stdcall (red, green, blue: GLuint);
procedure glColor3uiv conv arg_stdcall (v: PGLuint);
procedure glColor3us conv arg_stdcall (red, green, blue: GLushort);
procedure glColor3usv conv arg_stdcall (v: PGLushort);
procedure glColor4b conv arg_stdcall (red, green, blue, alpha: GLbyte);
procedure glColor4bv conv arg_stdcall (v: PGLbyte);
procedure glColor4d conv arg_stdcall (red, green, blue, alpha: GLdouble);
procedure glColor4dv conv arg_stdcall (v: PGLdouble);
procedure glColor4f conv arg_stdcall (red, green, blue, alpha: GLfloat);
procedure glColor4fv conv arg_stdcall (v: PGLfloat);
procedure glColor4i conv arg_stdcall (red, green, blue, alpha: GLint);
procedure glColor4iv conv arg_stdcall (v: PGLint);
procedure glColor4s conv arg_stdcall (red, green, blue, alpha: GLshort);
procedure glColor4sv conv arg_stdcall (v: PGLshort);
procedure glColor4ub conv arg_stdcall (red, green, blue, alpha: GLubyte);
procedure glColor4ubv conv arg_stdcall (v: PGLubyte);
procedure glColor4ui conv arg_stdcall (red, green, blue, alpha: GLuint);
procedure glColor4uiv conv arg_stdcall (v: PGLuint);
procedure glColor4us conv arg_stdcall (red, green, blue, alpha: GLushort);
procedure glColor4usv conv arg_stdcall (v: PGLushort);
procedure glColorMask conv arg_stdcall (red, green, blue, alpha: GLboolean);
procedure glColorMaterial conv arg_stdcall (face, mode: GLenum);
procedure glCopyPixels conv arg_stdcall (x,y: GLint; width, height: GLsizei; pixeltype: GLenum);
procedure glCullFace conv arg_stdcall (mode: GLenum);
procedure glDeleteLists conv arg_stdcall (list: GLuint; range: GLsizei);
procedure glDepthFunc conv arg_stdcall (func: GLenum);
procedure glDepthMask conv arg_stdcall (flag: GLboolean);
procedure glDepthRange conv arg_stdcall (zNear, zFar: GLclampd);
procedure glDisable conv arg_stdcall (cap: GLenum);
procedure glDrawBuffer conv arg_stdcall (mode: GLenum);
procedure glDrawPixels conv arg_stdcall (width, height: GLsizei; format, pixeltype: GLenum; pixels: Pointer);
procedure glEdgeFlag conv arg_stdcall (flag: GLboolean);
procedure glEdgeFlagv conv arg_stdcall (flag: PGLboolean);
procedure glEnable conv arg_stdcall (cap: GLenum);
procedure glEnd;
procedure glEndList;
procedure glEvalCoord1d conv arg_stdcall (u: GLdouble);
procedure glEvalCoord1dv conv arg_stdcall (u: PGLdouble);
procedure glEvalCoord1f conv arg_stdcall (u: GLfloat);
procedure glEvalCoord1fv conv arg_stdcall (u: PGLfloat);
procedure glEvalCoord2d conv arg_stdcall (u,v: GLdouble);
procedure glEvalCoord2dv conv arg_stdcall (u: PGLdouble);
procedure glEvalCoord2f conv arg_stdcall (u,v: GLfloat);
procedure glEvalCoord2fv conv arg_stdcall (u: PGLfloat);
procedure glEvalMesh1 conv arg_stdcall (mode: GLenum; i1, i2: GLint);
procedure glEvalMesh2 conv arg_stdcall (mode: GLenum; i1, i2, j1, j2: GLint);
procedure glEvalPoint1 conv arg_stdcall (i: GLint);
procedure glEvalPoint2 conv arg_stdcall (i,j: GLint);
procedure glFeedbackBuffer conv arg_stdcall (size: GLsizei; buftype: GLenum; buffer: PGLFloat);
procedure glFinish;
procedure glFlush;
procedure glFogf conv arg_stdcall (pname: GLenum; param: GLfloat);
procedure glFogfv conv arg_stdcall (pname: GLenum; params: PGLfloat);
procedure glFogi conv arg_stdcall (pname: GLenum; param: GLint);
procedure glFogiv conv arg_stdcall (pname: GLenum; params: PGLint);
procedure glFrontFace conv arg_stdcall (mode: GLenum);
procedure glFrustum conv arg_stdcall (left, right, bottom, top, zNear, zFar: GLdouble);
function  glGenLists conv arg_stdcall (range: GLsizei): GLuint;
procedure glGetBooleanv conv arg_stdcall (pname: GLenum; params: PGLboolean);
procedure glGetClipPlane conv arg_stdcall (plane: GLenum; equation: PGLdouble);
procedure glGetDoublev conv arg_stdcall (pname: GLenum; params: PGLdouble);
function  glGetError: GLenum;
procedure glGetFloatv conv arg_stdcall (pname: GLenum; params: PGLfloat);
procedure glGetIntegerv conv arg_stdcall (pname: GLenum; params: PGLint);
procedure glGetLightfv conv arg_stdcall (light: GLenum; pname: GLenum; params: PGLfloat);
procedure glGetLightiv conv arg_stdcall (light: GLenum; pname: GLenum; params: PGLint);
procedure glGetMapdv conv arg_stdcall (target: GLenum; query: GLenum; v: PGLdouble);
procedure glGetMapfv conv arg_stdcall (target: GLenum; query: GLenum; v: PGLfloat);
procedure glGetMapiv conv arg_stdcall (target: GLenum; query: GLenum; v: PGLint);
procedure glGetMaterialfv conv arg_stdcall (face: GLenum; pname: GLenum; params: PGLfloat);
procedure glGetMaterialiv conv arg_stdcall (face: GLenum; pname: GLenum; params: PGLint);
procedure glGetPixelMapfv conv arg_stdcall (map: GLenum; values: PGLfloat);
procedure glGetPixelMapuiv conv arg_stdcall (map: GLenum; values: PGLuint);
procedure glGetPixelMapusv conv arg_stdcall (map: GLenum; values: PGLushort);
procedure glGetPolygonStipple conv arg_stdcall (var mask: GLubyte);
function  glGetString conv arg_stdcall (name: GLenum): PChar;
procedure glGetTexEnvfv conv arg_stdcall (target: GLenum; pname: GLenum; params: PGLfloat);
procedure glGetTexEnviv conv arg_stdcall (target: GLenum; pname: GLenum; params: PGLint);
procedure glGetTexGendv conv arg_stdcall (coord: GLenum; pname: GLenum; params: PGLdouble);
procedure glGetTexGenfv conv arg_stdcall (coord: GLenum; pname: GLenum; params: PGLfloat);
procedure glGetTexGeniv conv arg_stdcall (coord: GLenum; pname: GLenum; params: PGLint);
procedure glGetTexImage conv arg_stdcall (target: GLenum; level: GLint; format: GLenum; _type: GLenum; pixels: pointer);
procedure glGetTexLevelParameterfv conv arg_stdcall (target: GLenum; level: GLint; pname: GLenum; params: PGLfloat);
procedure glGetTexLevelParameteriv conv arg_stdcall (target: GLenum; level: GLint; pname: GLenum; params: PGLint);
procedure glGetTexParameterfv conv arg_stdcall (target, pname: GLenum; params: PGLfloat);
procedure glGetTexParameteriv conv arg_stdcall (target, pname: GLenum; params: PGLint);
procedure glHint conv arg_stdcall (target, mode: GLenum);
procedure glIndexMask conv arg_stdcall (mask: GLuint);
procedure glIndexd conv arg_stdcall (c: GLdouble);
procedure glIndexdv conv arg_stdcall (c: PGLdouble);
procedure glIndexf conv arg_stdcall (c: GLfloat);
procedure glIndexfv conv arg_stdcall (c: PGLfloat);
procedure glIndexi conv arg_stdcall (c: GLint);
procedure glIndexiv conv arg_stdcall (c: PGLint);
procedure glIndexs conv arg_stdcall (c: GLshort);
procedure glIndexsv conv arg_stdcall (c: PGLshort);
procedure glInitNames;
function  glIsEnabled conv arg_stdcall (cap: GLenum): GLBoolean;
function  glIsList conv arg_stdcall (list: GLuint): GLBoolean;
procedure glLightModelf conv arg_stdcall (pname: GLenum; param: GLfloat);
procedure glLightModelfv conv arg_stdcall (pname: GLenum; params: PGLfloat);
procedure glLightModeli conv arg_stdcall (pname: GLenum; param: GLint);
procedure glLightModeliv conv arg_stdcall (pname: GLenum; params: PGLint);
procedure glLightf conv arg_stdcall (light, pname: GLenum; param: GLfloat);
procedure glLightfv conv arg_stdcall (light, pname: GLenum; params: PGLfloat);
procedure glLighti conv arg_stdcall (light, pname: GLenum; param: GLint);
procedure glLightiv conv arg_stdcall (light, pname: GLenum; params: PGLint);
procedure glLineStipple conv arg_stdcall (factor: GLint; pattern: GLushort);
procedure glLineWidth conv arg_stdcall (width: GLfloat);
procedure glListBase conv arg_stdcall (base: GLuint);
procedure glLoadIdentity;
procedure glLoadMatrixd conv arg_stdcall (m: PGLdouble);
procedure glLoadMatrixf conv arg_stdcall (m: PGLfloat);
procedure glLoadName conv arg_stdcall (name: GLuint);
procedure glLogicOp conv arg_stdcall (opcode: GLenum);
procedure glMap1d conv arg_stdcall (target: GLenum; u1,u2: GLdouble; stride, order: GLint;
  Points: PGLdouble);
procedure glMap1f conv arg_stdcall (target: GLenum; u1, u2: GLfloat; stride, order: GLint;
  Points: PGLfloat);
procedure glMap2d conv arg_stdcall (target: GLenum;  u1, u2: GLdouble; ustride, uorder: GLint;
  v1,v2: GLdouble; vstride, vorder: GLint; Points: PGLdouble);
procedure glMap2f conv arg_stdcall (target: GLenum; u1, u2: GLfloat; ustride, uorder: GLint;
  v1,v2: GLfloat; vstride, vorder: GLint; Points: PGLfloat);
procedure glMapGrid1d conv arg_stdcall (un: GLint; u1, u2: GLdouble);
procedure glMapGrid1f conv arg_stdcall (un: GLint; u1, u2: GLfloat);
procedure glMapGrid2d conv arg_stdcall (un: GLint; u1, u2: GLdouble; vn: GLint; v1, v2: GLdouble);
procedure glMapGrid2f conv arg_stdcall (un: GLint; u1, u2: GLfloat; vn: GLint; v1, v2: GLfloat);
procedure glMaterialf conv arg_stdcall (face, pname: GLenum; param: GLfloat);
procedure glMaterialfv conv arg_stdcall (face, pname: GLenum; params: PGLfloat);
procedure glMateriali conv arg_stdcall (face, pname: GLenum; param: GLint);
procedure glMaterialiv conv arg_stdcall (face, pname: GLenum; params: PGLint);
procedure glMatrixMode conv arg_stdcall (mode: GLenum);
procedure glMultMatrixd conv arg_stdcall (m: PGLdouble);
procedure glMultMatrixf conv arg_stdcall (m: PGLfloat);
procedure glNewList conv arg_stdcall (ListIndex: GLuint; mode: GLenum);
procedure glNormal3b conv arg_stdcall (nx, ny, nz: GLbyte);
procedure glNormal3bv conv arg_stdcall (v: PGLbyte);
procedure glNormal3d conv arg_stdcall (nx, ny, nz: GLdouble);
procedure glNormal3dv conv arg_stdcall (v: PGLdouble);
procedure glNormal3f conv arg_stdcall (nx, ny, nz: GLFloat);
procedure glNormal3fv conv arg_stdcall (v: PGLfloat);
procedure glNormal3i conv arg_stdcall (nx, ny, nz: GLint);
procedure glNormal3iv conv arg_stdcall (v: PGLint);
procedure glNormal3s conv arg_stdcall (nx, ny, nz: GLshort);
procedure glNormal3sv conv arg_stdcall (v: PGLshort);
procedure glOrtho conv arg_stdcall (left, right, bottom, top, zNear, zFar: GLdouble);
procedure glPassThrough conv arg_stdcall (token: GLfloat);
procedure glPixelMapfv conv arg_stdcall (map: GLenum; mapsize: GLint; values: PGLfloat);
procedure glPixelMapuiv conv arg_stdcall (map: GLenum; mapsize: GLint; values: PGLuint);
procedure glPixelMapusv conv arg_stdcall (map: GLenum; mapsize: GLint; values: PGLushort);
procedure glPixelStoref conv arg_stdcall (pname: GLenum; param: GLfloat);
procedure glPixelStorei conv arg_stdcall (pname: GLenum; param: GLint);
procedure glPixelTransferf conv arg_stdcall (pname: GLenum; param: GLfloat);
procedure glPixelTransferi conv arg_stdcall (pname: GLenum; param: GLint);
procedure glPixelZoom conv arg_stdcall (xfactor, yfactor: GLfloat);
procedure glPointSize conv arg_stdcall (size: GLfloat);
procedure glPolygonMode conv arg_stdcall (face, mode: GLenum);
procedure glPolygonStipple conv arg_stdcall (mask: PGLubyte);
procedure glPopAttrib;
procedure glPopMatrix;
procedure glPopName;
procedure glPushAttrib conv arg_stdcall (mask: GLbitfield);
procedure glPushMatrix;
procedure glPushName conv arg_stdcall (name: GLuint);
procedure glRasterPos2d conv arg_stdcall (x, y: GLdouble);
procedure glRasterPos2dv conv arg_stdcall (v: PGLdouble);
procedure glRasterPos2f conv arg_stdcall (x, y: GLfloat);
procedure glRasterPos2fv conv arg_stdcall (v: PGLfloat);
procedure glRasterPos2i conv arg_stdcall (x, y: GLint);
procedure glRasterPos2iv conv arg_stdcall (v: PGLint);
procedure glRasterPos2s conv arg_stdcall (x, y: GLshort);
procedure glRasterPos2sv conv arg_stdcall (v: PGLshort);
procedure glRasterPos3d conv arg_stdcall (x, y, z: GLdouble);
procedure glRasterPos3dv conv arg_stdcall (v: PGLdouble);
procedure glRasterPos3f conv arg_stdcall (x, y, z: GLfloat);
procedure glRasterPos3fv conv arg_stdcall (v: PGLfloat);
procedure glRasterPos3i conv arg_stdcall (x, y, z: GLint);
procedure glRasterPos3iv conv arg_stdcall (v: PGLint);
procedure glRasterPos3s conv arg_stdcall (x, y, z: GLshort);
procedure glRasterPos3sv conv arg_stdcall (v: PGLshort);
procedure glRasterPos4d conv arg_stdcall (x, y, z, w: GLdouble);
procedure glRasterPos4dv conv arg_stdcall (v: PGLdouble);
procedure glRasterPos4f conv arg_stdcall (x, y, z, w: GLfloat);
procedure glRasterPos4fv conv arg_stdcall (v: PGLfloat);
procedure glRasterPos4i conv arg_stdcall (x, y, z, w: GLint);
procedure glRasterPos4iv conv arg_stdcall (v: PGLint);
procedure glRasterPos4s conv arg_stdcall (x, y, z, w: GLshort);
procedure glRasterPos4sv conv arg_stdcall (v: PGLshort);
procedure glReadBuffer conv arg_stdcall (mode: GLenum);
procedure glReadPixels conv arg_stdcall (x, y: GLint; width, height: GLsizei;
  format, _type: GLenum; pixels: Pointer);
procedure glRectd conv arg_stdcall (x1, y1, x2, y2: GLdouble);
procedure glRectdv conv arg_stdcall (v1, v2: PGLdouble);
procedure glRectf conv arg_stdcall (x1, y1, x2, y2: GLfloat);
procedure glRectfv conv arg_stdcall (v1, v2: PGLfloat);
procedure glRecti conv arg_stdcall (x1, y1, x2, y2: GLint);
procedure glRectiv conv arg_stdcall (v1, v2: PGLint);
procedure glRects conv arg_stdcall (x1, y1, x2, y2: GLshort);
procedure glRectsv conv arg_stdcall (v1, v2: PGLshort);
function  glRenderMode conv arg_stdcall (mode: GLenum): GLint;
procedure glRotated conv arg_stdcall (angle, x, y, z: GLdouble);
procedure glRotatef conv arg_stdcall (angle, x, y, z: GLfloat);
procedure glScaled conv arg_stdcall (x, y, z: GLdouble);
procedure glScalef conv arg_stdcall (x, y, z: GLfloat);
procedure glScissor conv arg_stdcall (x, y: GLint; width, height: GLsizei);
procedure glSelectBuffer conv arg_stdcall (size: GLsizei; buffer: PGLuint);
procedure glShadeModel conv arg_stdcall (mode: GLenum);
procedure glStencilFunc conv arg_stdcall (func: GLenum; ref: GLint; mask: GLuint);
procedure glStencilMask conv arg_stdcall (mask: GLuint);
procedure glStencilOp conv arg_stdcall (fail, zfail, zpass: GLenum);
procedure glTexCoord1d conv arg_stdcall (s: GLdouble);
procedure glTexCoord1dv conv arg_stdcall (v: PGLdouble);
procedure glTexCoord1f conv arg_stdcall (s: GLfloat);
procedure glTexCoord1fv conv arg_stdcall (v: PGLfloat);
procedure glTexCoord1i conv arg_stdcall (s: GLint);
procedure glTexCoord1iv conv arg_stdcall (v: PGLint);
procedure glTexCoord1s conv arg_stdcall (s: GLshort);
procedure glTexCoord1sv conv arg_stdcall (v: PGLshort);
procedure glTexCoord2d conv arg_stdcall (s, t: GLdouble);
procedure glTexCoord2dv conv arg_stdcall (v: PGLdouble);
procedure glTexCoord2f conv arg_stdcall (s, t: GLfloat);
procedure glTexCoord2fv conv arg_stdcall (v: PGLfloat);
procedure glTexCoord2i conv arg_stdcall (s, t: GLint);
procedure glTexCoord2iv conv arg_stdcall (v: PGLint);
procedure glTexCoord2s conv arg_stdcall (s, t: GLshort);
procedure glTexCoord2sv conv arg_stdcall (v: PGLshort);
procedure glTexCoord3d conv arg_stdcall (s, t, r: GLdouble);
procedure glTexCoord3dv conv arg_stdcall (v: PGLdouble);
procedure glTexCoord3f conv arg_stdcall (s, t, r: GLfloat);
procedure glTexCoord3fv conv arg_stdcall (v: PGLfloat);
procedure glTexCoord3i conv arg_stdcall (s, t, r: GLint);
procedure glTexCoord3iv conv arg_stdcall (v: PGLint);
procedure glTexCoord3s conv arg_stdcall (s, t, r: GLshort);
procedure glTexCoord3sv conv arg_stdcall (v: PGLshort);
procedure glTexCoord4d conv arg_stdcall (s, t, r, q: GLdouble);
procedure glTexCoord4dv conv arg_stdcall (v: PGLdouble);
procedure glTexCoord4f conv arg_stdcall (s, t, r, q: GLfloat);
procedure glTexCoord4fv conv arg_stdcall (v: PGLfloat);
procedure glTexCoord4i conv arg_stdcall (s, t, r, q: GLint);
procedure glTexCoord4iv conv arg_stdcall (v: PGLint);
procedure glTexCoord4s conv arg_stdcall (s, t, r, q: GLshort);
procedure glTexCoord4sv conv arg_stdcall (v: PGLshort);
procedure glTexEnvf conv arg_stdcall (target, pname: GLenum; param: GLfloat);
procedure glTexEnvfv conv arg_stdcall (target, pname: GLenum; params: PGLfloat);
procedure glTexEnvi conv arg_stdcall (target, pname: GLenum; param: GLint);
procedure glTexEnviv conv arg_stdcall (target, pname: GLenum; params: PGLint);
procedure glTexGend conv arg_stdcall (coord, pname: GLenum; param: GLdouble);
procedure glTexGendv conv arg_stdcall (coord, pname: GLenum; params: PGLdouble);
procedure glTexGenf conv arg_stdcall (coord, pname: GLenum; param: GLfloat);
procedure glTexGenfv conv arg_stdcall (coord, pname: GLenum; params: PGLfloat);
procedure glTexGeni conv arg_stdcall (coord, pname: GLenum; param: GLint);
procedure glTexGeniv conv arg_stdcall (coord, pname: GLenum; params: PGLint);
procedure glTexImage1D conv arg_stdcall (target: GLenum; level, components: GLint;
 width: GLsizei; border: GLint; format, _type: GLenum; pixels: Pointer);
procedure glTexImage2D conv arg_stdcall (target: GLenum; level, components: GLint;
 width, height: GLsizei; border: GLint; format, _type: GLenum; pixels: Pointer);
procedure glTexParameterf conv arg_stdcall (target, pname: GLenum; param: GLfloat);
procedure glTexParameterfv conv arg_stdcall (target, pname: GLenum; params: PGLfloat);
procedure glTexParameteri conv arg_stdcall (target, pname: GLenum; param: GLint);
procedure glTexParameteriv conv arg_stdcall (target, pname: GLenum; params: PGLint);
procedure glTranslated conv arg_stdcall (x, y, z: GLdouble);
procedure glTranslatef conv arg_stdcall (x, y, z: GLfloat);
procedure glVertex2d conv arg_stdcall (x, y: GLdouble);
procedure glVertex2dv conv arg_stdcall (v: PGLdouble);
procedure glVertex2f conv arg_stdcall (x, y: GLfloat);
procedure glVertex2fv conv arg_stdcall (v: PGLfloat);
procedure glVertex2i conv arg_stdcall (x, y: GLint);
procedure glVertex2iv conv arg_stdcall (v: PGLint);
procedure glVertex2s conv arg_stdcall (x, y: GLshort);
procedure glVertex2sv conv arg_stdcall (v: PGLshort);
procedure glVertex3d conv arg_stdcall (x, y, z: GLdouble);
procedure glVertex3dv conv arg_stdcall (v: PGLdouble);
procedure glVertex3f conv arg_stdcall (x, y, z: GLfloat);
procedure glVertex3fv conv arg_stdcall (v: PGLfloat);
procedure glVertex3i conv arg_stdcall (x, y, z: GLint);
procedure glVertex3iv conv arg_stdcall (v: PGLint);
procedure glVertex3s conv arg_stdcall (x, y, z: GLshort);
procedure glVertex3sv conv arg_stdcall (v: PGLshort);
procedure glVertex4d conv arg_stdcall (x,y,z,w: GLdouble);
procedure glVertex4dv conv arg_stdcall (v: PGLdouble);
procedure glVertex4f conv arg_stdcall (x, y, z, w: GLfloat);
procedure glVertex4fv conv arg_stdcall (v: PGLfloat);
procedure glVertex4i conv arg_stdcall (x, y, z, w: GLint);
procedure glVertex4iv conv arg_stdcall (v: PGLint);
procedure glVertex4s conv arg_stdcall (x, y, z, w: GLshort);
procedure glVertex4sv conv arg_stdcall (v: PGLshort);
procedure glViewport conv arg_stdcall (x, y: GLint; width, height: GLsizei);
function  gluErrorString conv arg_stdcall (errCode: GLenum): PChar;
function  gluErrorUnicodeStringEXT conv arg_stdcall (errCode: GLenum): PWChar;
function  gluGetString conv arg_stdcall (name: GLenum): PChar;
procedure gluLookAt conv arg_stdcall (eyex, eyey, eyez, centerx, centery, centerz,
  upx, upy, upz: GLdouble);
procedure gluOrtho2D conv arg_stdcall (left, right, bottom, top: GLdouble);
procedure gluPerspective conv arg_stdcall (fovy, aspect, zNear, zFar: GLdouble);
procedure gluPickMatrix conv arg_stdcall (x, y, width, height: GLdouble; viewport: PGLint);
function  gluProject conv arg_stdcall (objx, objy, obyz: GLdouble; modelMatrix: PGLdouble;
  projMatrix: PGLdouble; viewport: PGLint; var winx, winy, winz: GLDouble): Longint;
function  gluUnProject conv arg_stdcall (winx, winy, winz: GLdouble; modelMatrix: PGLdouble;
  projMatrix: PGLdouble; viewport: PGLint; var objx, objy, objz: GLdouble): Longint;
function  gluScaleImage conv arg_stdcall (format: GLenum; widthin, heightin: GLint; typein: GLenum; datain: Pointer;
  widthout, heightout: GLint; typeout: GLenum; dataout: Pointer): Longint;
function  gluBuild1DMipmaps conv arg_stdcall (target: GLenum; components, width: GLint;
  format, atype: GLenum; data: Pointer): Longint;
function  gluBuild2DMipmaps conv arg_stdcall (target: GLenum; components, width, height: GLint;
  format, atype: GLenum; data: Pointer): Longint;
function  gluNewQuadric: GLUquadricObj;
procedure gluDeleteQuadric conv arg_stdcall (state: GLUquadricObj);
procedure gluQuadricNormals conv arg_stdcall (quadObject: GLUquadricObj; normals: GLenum);
procedure gluQuadricTexture conv arg_stdcall (quadObject: GLUquadricObj; textureCoords: GLboolean );stdcall;
procedure gluQuadricOrientation conv arg_stdcall (quadObject: GLUquadricObj; orientation: GLenum);
procedure gluQuadricDrawStyle conv arg_stdcall (quadObject: GLUquadricObj; drawStyle: GLenum);
procedure gluCylinder conv arg_stdcall (quadObject: GLUquadricObj;
  baseRadius, topRadius, height: GLdouble; slices, stacks: GLint);
procedure gluDisk conv arg_stdcall (quadObject: GLUquadricObj;
  innerRadius, outerRadius: GLdouble; slices, loops: GLint);
procedure gluPartialDisk conv arg_stdcall (quadObject: GLUquadricObj;
  innerRadius, outerRadius: GLdouble; slices, loops: GLint; startAngle, sweepAngle: GLdouble);
procedure gluSphere conv arg_stdcall (quadObject: GLUquadricObj; radius: GLdouble; slices, loops: GLint);
procedure gluQuadricCallback conv arg_stdcall (quadObject: GLUquadricObj; which: GLenum; Callback: Pointer);
function  gluNewTess: GLUtesselator;
procedure gluDeleteTess conv arg_stdcall (tess: GLUtesselator );
procedure gluTessBeginPolygon conv arg_stdcall (tess: GLUtesselator );
procedure gluTessBeginContour conv arg_stdcall (tess: GLUtesselator );
procedure gluTessVertex conv arg_stdcall (tess: GLUtesselator; coords: PGLdouble; data: Pointer );
procedure gluTessEndContour conv arg_stdcall (tess: GLUtesselator );
procedure gluTessEndPolygon conv arg_stdcall (tess: GLUtesselator );
procedure gluTessProperty conv arg_stdcall (tess: GLUtesselator; which: GLenum; value: GLdouble);
procedure gluTessNormal conv arg_stdcall (tess: GLUtesselator; x,y,z: GLdouble);
procedure gluTessCallback conv arg_stdcall (tess: GLUtesselator; which: GLenum; callback: pointer);
function  gluNewNurbsRenderer: GLUnurbsObj;
procedure gluDeleteNurbsRenderer conv arg_stdcall (nobj: GLUnurbsObj);
procedure gluBeginSurface conv arg_stdcall (nobj: GLUnurbsObj);
procedure gluBeginCurve conv arg_stdcall (nobj: GLUnurbsObj);
procedure gluEndCurve conv arg_stdcall (nobj: GLUnurbsObj);
procedure gluEndSurface conv arg_stdcall (nobj: GLUnurbsObj);
procedure gluBeginTrim conv arg_stdcall (nobj: GLUnurbsObj);
procedure gluEndTrim conv arg_stdcall (nobj: GLUnurbsObj);
procedure gluPwlCurve conv arg_stdcall (nobj: GLUnurbsObj; count: GLint; points: PGLfloat;
 stride: GLint; _type: GLenum);
procedure gluNurbsCurve conv arg_stdcall (nobj: GLUnurbsObj; nknots: GLint; knot: PGLfloat;
 stride: GLint; ctlpts: PGLfloat; order: GLint; _type: GLenum);
procedure gluNurbsSurface conv arg_stdcall (nobj: GLUnurbsObj; sknot_count: GLint; sknot: PGLfloat;
  tknot_count: GLint; tknot: PGLfloat; s_stride, t_stride: GLint; ctlpts: PGLfloat; sorder, torder: GLint; _type: GLenum);
procedure gluLoadSamplingMatrices conv arg_stdcall (nobj: GLUnurbsObj; modelMatrix: PGLdouble; projMatrix: PGLdouble; viewport: PGLint);
procedure gluNurbsProperty conv arg_stdcall (nobj: GLUnurbsObj; prop: GLenum; value: GLfloat);
procedure gluGetNurbsProperty conv arg_stdcall (nobj: GLUnurbsObj; prop: GLenum; var value: GLfloat);
procedure gluNurbsCallback conv arg_stdcall (nobj: GLUnurbsObj; which: GLenum; callback: pointer);
function  wglGetProcAddress conv arg_stdcall (ProcName: PChar): Pointer;
function  auxDIBImageLoadA(const dibfile: PChar): PTAUX_RGBImageRec; stdcall;
procedure auxWireSphere(value: GLdouble); stdcall;
procedure auxSolidSphere(value: GLdouble); stdcall;
procedure auxWireCube(value: GLdouble); stdcall;
procedure auxSolidCube(value: GLdouble); stdcall;
procedure auxWireBox(value,value1,value2: GLdouble); stdcall;
procedure auxSolidBox(value,value1,value2: GLdouble); stdcall;
procedure auxWireTorus(value,value1: GLdouble); stdcall;
procedure auxSolidTorus(value,value1: GLdouble); stdcall;
procedure auxWireCylinder(value,value1: GLdouble); stdcall;
procedure auxSolidCylinder(value,value1: GLdouble); stdcall;
procedure auxWireIcosahedron(value: GLdouble); stdcall;
procedure auxSolidIcosahedron(value: GLdouble); stdcall;
procedure auxWireOctahedron(value: GLdouble); stdcall;
procedure auxSolidOctahedron(value: GLdouble); stdcall;
procedure auxWireTetrahedron(value: GLdouble); stdcall;
procedure auxSolidTetrahedron(value: GLdouble); stdcall;
procedure auxWireDodecahedron(value: GLdouble); stdcall;
procedure auxSolidDodecahedron(value: GLdouble); stdcall;
procedure auxWireCone(value,value1: GLdouble); stdcall;
procedure auxSolidCone(value,value1: GLdouble); stdcall;
procedure auxWireTeapot(value: GLdouble); stdcall;
procedure auxSolidTeapot(value: GLdouble); stdcall;

{*
** Window Masks
*}
function AUX_WIND_IS_RGB(x: DWORD): Boolean;
function AUX_WIND_IS_INDEX(x: DWORD): Boolean;
function AUX_WIND_IS_SINGLE(x: DWORD): Boolean;
function AUX_WIND_IS_DOUBLE(x: DWORD): Boolean;
function AUX_WIND_IS_INDIRECT(x: DWORD): Boolean;
function AUX_WIND_IS_DIRECT(x: DWORD): Boolean;
function AUX_WIND_HAS_ACCUM(x: DWORD): Boolean;
function AUX_WIND_HAS_ALPHA(x: DWORD): Boolean;
function AUX_WIND_HAS_DEPTH(x: DWORD): Boolean;
function AUX_WIND_HAS_STENCIL(x: DWORD): Boolean;
function AUX_WIND_USES_FIXED_332_PAL(x: DWORD): Boolean;

implementation

procedure glAccum; external opengl32dll;
procedure glAlphaFunc; external opengl32dll;
procedure glBegin; external opengl32dll;
procedure glBitmap; external opengl32dll;
procedure glBlendFunc; external opengl32dll;
procedure glCallList; external opengl32dll;
procedure glCallLists; external opengl32dll;
procedure glClear; external opengl32dll;
procedure glClearAccum; external opengl32dll;
procedure glClearColor; external opengl32dll;
procedure glClearDepth; external opengl32dll;
procedure glClearIndex; external opengl32dll;
procedure glClearStencil; external opengl32dll;
procedure glClipPlane; external opengl32dll;
procedure glColor3b; external opengl32dll;
procedure glColor3bv; external opengl32dll;
procedure glColor3d; external opengl32dll;
procedure glColor3dv; external opengl32dll;
procedure glColor3f; external opengl32dll;
procedure glColor3fv; external opengl32dll;
procedure glColor3i; external opengl32dll;
procedure glColor3iv; external opengl32dll;
procedure glColor3s; external opengl32dll;
procedure glColor3sv; external opengl32dll;
procedure glColor3ub; external opengl32dll;
procedure glColor3ubv; external opengl32dll;
procedure glColor3ui; external opengl32dll;
procedure glColor3uiv; external opengl32dll;
procedure glColor3us; external opengl32dll;
procedure glColor3usv; external opengl32dll;
procedure glColor4b; external opengl32dll;
procedure glColor4bv; external opengl32dll;
procedure glColor4d; external opengl32dll;
procedure glColor4dv; external opengl32dll;
procedure glColor4f; external opengl32dll;
procedure glColor4fv; external opengl32dll;
procedure glColor4i; external opengl32dll;
procedure glColor4iv; external opengl32dll;
procedure glColor4s; external opengl32dll;
procedure glColor4sv; external opengl32dll;
procedure glColor4ub; external opengl32dll;
procedure glColor4ubv; external opengl32dll;
procedure glColor4ui; external opengl32dll;
procedure glColor4uiv; external opengl32dll;
procedure glColor4us; external opengl32dll;
procedure glColor4usv; external opengl32dll;
procedure glColorMask; external opengl32dll;
procedure glColorMaterial; external opengl32dll;
procedure glCopyPixels; external opengl32dll;
procedure glCullFace; external opengl32dll;
procedure glDeleteLists; external opengl32dll;
procedure glDepthFunc; external opengl32dll;
procedure glDepthMask; external opengl32dll;
procedure glDepthRange; external opengl32dll;
procedure glDisable; external opengl32dll;
procedure glDrawBuffer; external opengl32dll;
procedure glDrawPixels; external opengl32dll;
procedure glEdgeFlag; external opengl32dll;
procedure glEdgeFlagv; external opengl32dll;
procedure glEnable; external opengl32dll;
procedure glEnd; external opengl32dll;
procedure glEndList; external opengl32dll;
procedure glEvalCoord1d; external opengl32dll;
procedure glEvalCoord1dv; external opengl32dll;
procedure glEvalCoord1f; external opengl32dll;
procedure glEvalCoord1fv; external opengl32dll;
procedure glEvalCoord2d; external opengl32dll;
procedure glEvalCoord2dv; external opengl32dll;
procedure glEvalCoord2f; external opengl32dll;
procedure glEvalCoord2fv; external opengl32dll;
procedure glEvalMesh1; external opengl32dll;
procedure glEvalMesh2; external opengl32dll;
procedure glEvalPoint1; external opengl32dll;
procedure glEvalPoint2; external opengl32dll;
procedure glFeedbackBuffer; external opengl32dll;
procedure glFinish; external opengl32dll;
procedure glFlush; external opengl32dll;
procedure glFogf; external opengl32dll;
procedure glFogfv; external opengl32dll;
procedure glFogi; external opengl32dll;
procedure glFogiv; external opengl32dll;
procedure glFrontFace; external opengl32dll;
procedure glFrustum; external opengl32dll;
function  glGenLists; external opengl32dll;
procedure glGetBooleanv; external opengl32dll;
procedure glGetClipPlane; external opengl32dll;
procedure glGetDoublev; external opengl32dll;
function  glGetError: GLenum; external opengl32dll;
procedure glGetFloatv; external opengl32dll;
procedure glGetIntegerv; external opengl32dll;
procedure glGetLightfv; external opengl32dll;
procedure glGetLightiv; external opengl32dll;
procedure glGetMapdv; external opengl32dll;
procedure glGetMapfv; external opengl32dll;
procedure glGetMapiv; external opengl32dll;
procedure glGetMaterialfv; external opengl32dll;
procedure glGetMaterialiv; external opengl32dll;
procedure glGetPixelMapfv; external opengl32dll;
procedure glGetPixelMapuiv; external opengl32dll;
procedure glGetPixelMapusv; external opengl32dll;
procedure glGetPolygonStipple; external opengl32dll;
function  glGetString; external opengl32dll;
procedure glGetTexEnvfv; external opengl32dll;
procedure glGetTexEnviv; external opengl32dll;
procedure glGetTexGendv; external opengl32dll;
procedure glGetTexGenfv; external opengl32dll;
procedure glGetTexGeniv; external opengl32dll;
procedure glGetTexImage; external opengl32dll;
procedure glGetTexLevelParameterfv; external opengl32dll;
procedure glGetTexLevelParameteriv; external opengl32dll;
procedure glGetTexParameterfv; external opengl32dll;
procedure glGetTexParameteriv; external opengl32dll;
procedure glHint; external opengl32dll;
procedure glIndexMask; external opengl32dll;
procedure glIndexd; external opengl32dll;
procedure glIndexdv; external opengl32dll;
procedure glIndexf; external opengl32dll;
procedure glIndexfv; external opengl32dll;
procedure glIndexi; external opengl32dll;
procedure glIndexiv; external opengl32dll;
procedure glIndexs; external opengl32dll;
procedure glIndexsv; external opengl32dll;
procedure glInitNames; external opengl32dll;
function  glIsEnabled; external opengl32dll;
function  glIsList; external opengl32dll;
procedure glLightModelf; external opengl32dll;
procedure glLightModelfv; external opengl32dll;
procedure glLightModeli; external opengl32dll;
procedure glLightModeliv; external opengl32dll;
procedure glLightf; external opengl32dll;
procedure glLightfv; external opengl32dll;
procedure glLighti; external opengl32dll;
procedure glLightiv; external opengl32dll;
procedure glLineStipple; external opengl32dll;
procedure glLineWidth; external opengl32dll;
procedure glListBase; external opengl32dll;
procedure glLoadIdentity; external opengl32dll;
procedure glLoadMatrixd; external opengl32dll;
procedure glLoadMatrixf; external opengl32dll;
procedure glLoadName; external opengl32dll;
procedure glLogicOp; external opengl32dll;
procedure glMap1d; external opengl32dll;
procedure glMap1f; external opengl32dll;
procedure glMap2d; external opengl32dll;
procedure glMap2f; external opengl32dll;
procedure glMapGrid1d; external opengl32dll;
procedure glMapGrid1f; external opengl32dll;
procedure glMapGrid2d; external opengl32dll;
procedure glMapGrid2f; external opengl32dll;
procedure glMaterialf; external opengl32dll;
procedure glMaterialfv; external opengl32dll;
procedure glMateriali; external opengl32dll;
procedure glMaterialiv; external opengl32dll;
procedure glMatrixMode; external opengl32dll;
procedure glMultMatrixd; external opengl32dll;
procedure glMultMatrixf; external opengl32dll;
procedure glNewList; external opengl32dll;
procedure glNormal3b; external opengl32dll;
procedure glNormal3bv; external opengl32dll;
procedure glNormal3d; external opengl32dll;
procedure glNormal3dv; external opengl32dll;
procedure glNormal3f; external opengl32dll;
procedure glNormal3fv; external opengl32dll;
procedure glNormal3i; external opengl32dll;
procedure glNormal3iv; external opengl32dll;
procedure glNormal3s; external opengl32dll;
procedure glNormal3sv; external opengl32dll;
procedure glOrtho; external opengl32dll;
procedure glPassThrough; external opengl32dll;
procedure glPixelMapfv; external opengl32dll;
procedure glPixelMapuiv; external opengl32dll;
procedure glPixelMapusv; external opengl32dll;
procedure glPixelStoref; external opengl32dll;
procedure glPixelStorei; external opengl32dll;
procedure glPixelTransferf; external opengl32dll;
procedure glPixelTransferi; external opengl32dll;
procedure glPixelZoom; external opengl32dll;
procedure glPointSize; external opengl32dll;
procedure glPolygonMode; external opengl32dll;
procedure glPolygonStipple; external opengl32dll;
procedure glPopAttrib; external opengl32dll;
procedure glPopMatrix; external opengl32dll;
procedure glPopName; external opengl32dll;
procedure glPushAttrib; external opengl32dll;
procedure glPushMatrix; external opengl32dll;
procedure glPushName; external opengl32dll;
procedure glRasterPos2d; external opengl32dll;
procedure glRasterPos2dv; external opengl32dll;
procedure glRasterPos2f; external opengl32dll;
procedure glRasterPos2fv; external opengl32dll;
procedure glRasterPos2i; external opengl32dll;
procedure glRasterPos2iv; external opengl32dll;
procedure glRasterPos2s; external opengl32dll;
procedure glRasterPos2sv; external opengl32dll;
procedure glRasterPos3d; external opengl32dll;
procedure glRasterPos3dv; external opengl32dll;
procedure glRasterPos3f; external opengl32dll;
procedure glRasterPos3fv; external opengl32dll;
procedure glRasterPos3i; external opengl32dll;
procedure glRasterPos3iv; external opengl32dll;
procedure glRasterPos3s; external opengl32dll;
procedure glRasterPos3sv; external opengl32dll;
procedure glRasterPos4d; external opengl32dll;
procedure glRasterPos4dv; external opengl32dll;
procedure glRasterPos4f; external opengl32dll;
procedure glRasterPos4fv; external opengl32dll;
procedure glRasterPos4i; external opengl32dll;
procedure glRasterPos4iv; external opengl32dll;
procedure glRasterPos4s; external opengl32dll;
procedure glRasterPos4sv; external opengl32dll;
procedure glReadBuffer; external opengl32dll;
procedure glReadPixels; external opengl32dll;
procedure glRectd; external opengl32dll;
procedure glRectdv; external opengl32dll;
procedure glRectf; external opengl32dll;
procedure glRectfv; external opengl32dll;
procedure glRecti; external opengl32dll;
procedure glRectiv; external opengl32dll;
procedure glRects; external opengl32dll;
procedure glRectsv; external opengl32dll;
function  glRenderMode; external opengl32dll;
procedure glRotated; external opengl32dll;
procedure glRotatef; external opengl32dll;
procedure glScaled; external opengl32dll;
procedure glScalef; external opengl32dll;
procedure glScissor; external opengl32dll;
procedure glSelectBuffer; external opengl32dll;
procedure glShadeModel; external opengl32dll;
procedure glStencilFunc; external opengl32dll;
procedure glStencilMask; external opengl32dll;
procedure glStencilOp; external opengl32dll;
procedure glTexCoord1d; external opengl32dll;
procedure glTexCoord1dv; external opengl32dll;
procedure glTexCoord1f; external opengl32dll;
procedure glTexCoord1fv; external opengl32dll;
procedure glTexCoord1i; external opengl32dll;
procedure glTexCoord1iv; external opengl32dll;
procedure glTexCoord1s; external opengl32dll;
procedure glTexCoord1sv; external opengl32dll;
procedure glTexCoord2d; external opengl32dll;
procedure glTexCoord2dv; external opengl32dll;
procedure glTexCoord2f; external opengl32dll;
procedure glTexCoord2fv; external opengl32dll;
procedure glTexCoord2i; external opengl32dll;
procedure glTexCoord2iv; external opengl32dll;
procedure glTexCoord2s; external opengl32dll;
procedure glTexCoord2sv; external opengl32dll;
procedure glTexCoord3d; external opengl32dll;
procedure glTexCoord3dv; external opengl32dll;
procedure glTexCoord3f; external opengl32dll;
procedure glTexCoord3fv; external opengl32dll;
procedure glTexCoord3i; external opengl32dll;
procedure glTexCoord3iv; external opengl32dll;
procedure glTexCoord3s; external opengl32dll;
procedure glTexCoord3sv; external opengl32dll;
procedure glTexCoord4d; external opengl32dll;
procedure glTexCoord4dv; external opengl32dll;
procedure glTexCoord4f; external opengl32dll;
procedure glTexCoord4fv; external opengl32dll;
procedure glTexCoord4i; external opengl32dll;
procedure glTexCoord4iv; external opengl32dll;
procedure glTexCoord4s; external opengl32dll;
procedure glTexCoord4sv; external opengl32dll;
procedure glTexEnvf; external opengl32dll;
procedure glTexEnvfv; external opengl32dll;
procedure glTexEnvi; external opengl32dll;
procedure glTexEnviv; external opengl32dll;
procedure glTexGend; external opengl32dll;
procedure glTexGendv; external opengl32dll;
procedure glTexGenf; external opengl32dll;
procedure glTexGenfv; external opengl32dll;
procedure glTexGeni; external opengl32dll;
procedure glTexGeniv; external opengl32dll;
procedure glTexImage1D; external opengl32dll;
procedure glTexImage2D; external opengl32dll;
procedure glTexParameterf; external opengl32dll;
procedure glTexParameterfv; external opengl32dll;
procedure glTexParameteri; external opengl32dll;
procedure glTexParameteriv; external opengl32dll;
procedure glTranslated; external opengl32dll;
procedure glTranslatef; external opengl32dll;
procedure glVertex2d; external opengl32dll;
procedure glVertex2dv; external opengl32dll;
procedure glVertex2f; external opengl32dll;
procedure glVertex2fv; external opengl32dll;
procedure glVertex2i; external opengl32dll;
procedure glVertex2iv; external opengl32dll;
procedure glVertex2s; external opengl32dll;
procedure glVertex2sv; external opengl32dll;
procedure glVertex3d; external opengl32dll;
procedure glVertex3dv; external opengl32dll;
procedure glVertex3f; external opengl32dll;
procedure glVertex3fv; external opengl32dll;
procedure glVertex3i; external opengl32dll;
procedure glVertex3iv; external opengl32dll;
procedure glVertex3s; external opengl32dll;
procedure glVertex3sv; external opengl32dll;
procedure glVertex4d; external opengl32dll;
procedure glVertex4dv; external opengl32dll;
procedure glVertex4f; external opengl32dll;
procedure glVertex4fv; external opengl32dll;
procedure glVertex4i; external opengl32dll;
procedure glVertex4iv; external opengl32dll;
procedure glVertex4s; external opengl32dll;
procedure glVertex4sv; external opengl32dll;
procedure glViewport; external opengl32dll;
function  wglGetProcAddress; external opengl32dll;
function  gluErrorString; external glu32dll;
function  gluErrorUnicodeStringEXT; external glu32dll;
function  gluGetString; external glu32dll;
procedure gluLookAt; external glu32dll;
procedure gluOrtho2D; external glu32dll;
procedure gluPerspective; external glu32dll;
procedure gluPickMatrix; external glu32dll;
function  gluProject; external glu32dll;
function  gluUnProject; external glu32dll;
function  gluScaleImage; external glu32dll;
function  gluBuild1DMipmaps; external glu32dll;
function  gluBuild2DMipmaps; external glu32dll;
function  gluNewQuadric; external glu32dll;
procedure gluDeleteQuadric; external glu32dll;
procedure gluQuadricNormals; external glu32dll;
procedure gluQuadricTexture; external glu32dll;
procedure gluQuadricOrientation; external glu32dll;
procedure gluQuadricDrawStyle; external glu32dll;
procedure gluCylinder; external glu32dll;
procedure gluDisk; external glu32dll;
procedure gluPartialDisk; external glu32dll;
procedure gluSphere; external glu32dll;
procedure gluQuadricCallback; external glu32dll;
function  gluNewTess; external glu32dll;
procedure gluDeleteTess; external glu32dll;
procedure gluTessBeginPolygon; external glu32dll;
procedure gluTessBeginContour; external glu32dll;
procedure gluTessVertex; external glu32dll;
procedure gluTessEndContour; external glu32dll;
procedure gluTessEndPolygon; external glu32dll;
procedure gluTessProperty; external glu32dll;
procedure gluTessNormal; external glu32dll;
procedure gluTessCallback; external glu32dll;
function  gluNewNurbsRenderer; external glu32dll;
procedure gluDeleteNurbsRenderer; external glu32dll;
procedure gluBeginSurface; external glu32dll;
procedure gluBeginCurve; external glu32dll;
procedure gluEndCurve; external glu32dll;
procedure gluEndSurface; external glu32dll;
procedure gluBeginTrim; external glu32dll;
procedure gluEndTrim; external glu32dll;
procedure gluPwlCurve; external glu32dll;
procedure gluNurbsCurve; external glu32dll;
procedure gluNurbsSurface; external glu32dll;
procedure gluLoadSamplingMatrices; external glu32dll;
procedure gluNurbsProperty; external glu32dll;
procedure gluGetNurbsProperty; external glu32dll;
procedure gluNurbsCallback; external glu32dll;
function  auxDIBImageLoadA; external glauxdll;
procedure auxWireSphere; external glauxdll;
procedure auxSolidSphere; external glauxdll;
procedure auxWireCube; external glauxdll;
procedure auxSolidCube; external glauxdll;
procedure auxWireBox; external glauxdll;
procedure auxSolidBox; external glauxdll;
procedure auxWireTorus; external glauxdll;
procedure auxSolidTorus; external glauxdll;
procedure auxWireCylinder; external glauxdll;
procedure auxSolidCylinder; external glauxdll;
procedure auxWireIcosahedron; external glauxdll;
procedure auxSolidIcosahedron; external glauxdll;
procedure auxWireOctahedron; external glauxdll;
procedure auxSolidOctahedron; external glauxdll;
procedure auxWireTetrahedron; external glauxdll;
procedure auxSolidTetrahedron; external glauxdll;
procedure auxWireDodecahedron; external glauxdll;
procedure auxSolidDodecahedron; external glauxdll;
procedure auxWireCone; external glauxdll;
procedure auxSolidCone; external glauxdll;
procedure auxWireTeapot; external glauxdll;
procedure auxSolidTeapot; external glauxdll;

function AUX_WIND_IS_RGB(x: DWORD): Boolean;
begin
  AUX_WIND_IS_RGB := (x and AUX_INDEX) = 0;
end;

function AUX_WIND_IS_INDEX(x: DWORD): Boolean;
begin
  AUX_WIND_IS_INDEX := (x and AUX_INDEX) <> 0;
end;

function AUX_WIND_IS_SINGLE(x: DWORD): Boolean;
begin
  AUX_WIND_IS_SINGLE := (x and AUX_DOUBLE) = 0;
end;

function AUX_WIND_IS_DOUBLE(x: DWORD): Boolean;
begin
  AUX_WIND_IS_DOUBLE := (x and AUX_DOUBLE) <> 0;
end;

function AUX_WIND_IS_INDIRECT(x: DWORD): Boolean;
begin
  AUX_WIND_IS_INDIRECT := (x and AUX_INDIRECT) <> 0;
end;

function AUX_WIND_IS_DIRECT(x: DWORD): Boolean;
begin
  AUX_WIND_IS_DIRECT := (x and AUX_INDIRECT) = 0;
end;

function AUX_WIND_HAS_ACCUM(x: DWORD): Boolean;
begin
  AUX_WIND_HAS_ACCUM := (x and AUX_ACCUM) <> 0;
end;

function AUX_WIND_HAS_ALPHA(x: DWORD): Boolean;
begin
  AUX_WIND_HAS_ALPHA := (x and AUX_ALPHA) <> 0;
end;

function AUX_WIND_HAS_DEPTH(x: DWORD): Boolean;
begin
  AUX_WIND_HAS_DEPTH := (x and (AUX_DEPTH24 or AUX_DEPTH16)) <> 0;
end;

function AUX_WIND_HAS_STENCIL(x: DWORD): Boolean;
begin
  AUX_WIND_HAS_STENCIL := (x and AUX_STENCIL) <> 0;
end;

function AUX_WIND_USES_FIXED_332_PAL(x: DWORD): Boolean;
begin
  AUX_WIND_USES_FIXED_332_PAL := (x and AUX_FIXED_332_PAL) <> 0;
end;

begin
  declare
  var
    cw: WORD;
  begin
    asm mov ax, 133Fh; mov cw, ax; fldcw cw; end;
  end;
end.