(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit Data Decompression Library Functions     *)
(*       Based on lzexpand.h                                    *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995-98 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit LZExpand;

(*
** lzdos.pas - Public interface to LZEXP?.LIB.
*)

interface

uses Windows;

const

 lz32dll              = 'LZ32.DLL';

(*
** Error Return Codes
*)

 LZERROR_BADINHANDLE  = -1; //The handle identifying the source file is not
                            //valid. The file cannot be read.
 LZERROR_BADOUTHANDLE = -2; //The handle identifying the destination file is
                            //not valid. The file cannot be written.
 LZERROR_READ         = -3; //The source file format is not valid.
 LZERROR_WRITE        = -4; //There is insufficient space for the output file.
 LZERROR_GLOBALLOC    = -5; //The maximum number of open compressed files has
                            //been  exceeded or local memory cannot be allocated.
 LZERROR_GLOBLOCK     = -6; //The LZ file handle cannot be locked down.
 LZERROR_BADVALUE     = -7; //One of the input parameters is not valid.
 LZERROR_UNKNOWNALG   = -8; //The file is compressed with an unrecognized
                            //compression algorithm.

(*
** Prototypes
*)

function GetExpandedNameA conv arg_stdcall (Source, Buffer: PAnsiChar): Longint;
 external lz32dll name 'GetExpandedNameA';

function GetExpandedNameW conv arg_stdcall (Source, Buffer: PWideChar): Longint;
 external lz32dll name 'GetExpandedNameW';

function GetExpandedName conv arg_stdcall (Source, Buffer: PChar): Longint;
 external lz32dll name 'GetExpandedNameA';

procedure LZClose conv arg_stdcall (hFile: Longint);
 external lz32dll name 'LZClose';

function LZCopy conv arg_stdcall (Source, Dest: Longint): Longint;
 external lz32dll name 'LZCopy';

function LZInit conv arg_stdcall (Source: Longint): Longint;
 external lz32dll name 'LZInit';

function LZOpenFileA conv arg_stdcall (Filename: PAnsiChar; var ReOpenBuff: TOFStruct; Style: Word): Longint;
 external lz32dll name 'LZOpenFileA';

function LZOpenFileW conv arg_stdcall (Filename: PWideChar; var ReOpenBuff: TOFStruct; Style: Word): Longint;
 external lz32dll name 'LZOpenFileW';

function LZOpenFile conv arg_stdcall (Filename: PChar; var ReOpenBuff: TOFStruct; Style: Word): Longint;
 external lz32dll name 'LZOpenFileA';

function LZRead conv arg_stdcall (hFile: Longint; Buffer: LPSTR; Count: Longint): Longint;
 external lz32dll name 'LZRead';

function LZSeek conv arg_stdcall (hFile: Longint; Offset: Longint; Origin: Longint): Longint;
 external lz32dll name 'LZSeek';

implementation

end.