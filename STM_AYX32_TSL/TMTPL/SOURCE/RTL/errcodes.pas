(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Error Codes Unit                                       *)
(*       Targets: MS-DOS only                                   *)
(*                                                              *)
(*       Copyright (c) 1995,98 TMT Development Corporation      *)
(*       Author: Anton Moscal                                   *)
(*                                                              *)
(****************************************************************)

unit ErrCodes;

interface

const
  INVALID_FUNCTION_NUMBER           =   1;
  FILE_NOT_FOUND                    =   2;
  PATH_NOT_FOUND                    =   3;
  TOO_MANY_OPEN_FILES               =   4;
  FILE_ACCESS_DENIED                =   5;
  INVALID_FILE_HANDLE               =   6;
  INVALID_FILE_ACCESS_CODE          =  12;
  INVALID_DRIVE_NUMBER              =  15;
  CANNOT_REMOVE_CURRENT_DIRECTORY   =  16;
  CANNOT_RENAME_ACROSS_DRIVES       =  17;
  NO_MORE_FILES                     =  18;
  DISK_READ_ERROR                   = 100;
  DISK_WRITE_ERROR                  = 101;
  FILE_NOT_ASSIGNED                 = 102;
  FILE_NOT_OPEN                     = 103;
  FILE_NOT_OPEN_FOR_INPUT           = 104;
  FILE_NOT_OPEN_FOR_OUTPUT          = 105;
  INVALID_NUMERIC_FORMAT            = 106;
  DISK_IS_WRITE_PROTECTED           = 150;
  BAD_DRIVE_REQUEST_STRUCT_LENGTH   = 151;
  DRIVE_NOT_READY                   = 152;
  CRC_ERROR_IN_DATA                 = 154;
  DISK_SEEK_ERROR                   = 156;
  UNKNOWN_MEDIA_TYPE                = 157;
  SECTOR_NOT_FOUND                  = 158;
  PRINTER_OUT_OF_PAPER              = 159;
  DEVICE_WRITE_FAULT                = 160;
  DEVICE_READ_FAULT                 = 161;
  HARDWARE_FAILURE                  = 162;
  DIVISION_BY_ZERO                  = 200;
  RANGE_CHECK_ERROR                 = 201;
  STACK_OVERFLOW_ERROR              = 202;
  HEAP_OVERFLOW_ERROR               = 203;
  INVALID_POINTER_OPERATION         = 204;
  FLOATING_POINT_OVERFLOW           = 205;
  FLOATING_POINT_UNDERFLOW          = 206;
  INVALID_FLOATING_POINT_OPERATION  = 207;
  OVERLAY_MANAGER_NOT_INSTALLED     = 208;
  OVERLAY_FILE_READ_ERROR           = 209;
  OBJECT_NOT_INITIALIZED            = 210;
  CALL_TO_ABSTRACT_METHOD           = 211;
  STREAM_REGISTRATION_ERROR         = 212;
  COLLECTION_INDEX_OUT_OF_RANGE     = 213;
  COLLECTION_OVERFLOW_ERROR         = 214;
  ARITHMETIC_OVERFLOW_ERROR         = 215;
  GENERAL_PROTECTION_FAULT          = 216;
  INVALID_OPERATION_CODE            = 217;
  ASSERTION_FAILED                  = 227;
  FILE_IO_ERROR                     = 300;
  NONMATCHED_ARRAY_BOUNDS           = 301;
  NON_LOCAL_PROCEDURE_POINTER       = 302;
  PROCEDURE_POINTER_OUT_OF_SCOPE    = 303;
  FUNCTION_NOT_IMPLEMENTED          = 304;
  BREAKPOINT_ERROR                  = 305;
  BREAK_BY_CTRL_C                   = 306;
  BREAK_BY_CTRL_BREAK               = 307;
  BREAK_BY_OTHER_PROCESS            = 308;
  NO_FLOATING_POINT_PROCESSOR       = 309;
  INVALID_VARIANT_TYPE_OPERATION    = 310;

function Error_Msg(Err: DWord): string;

implementation

uses Strings;

type err = Record
  no:  DWord;
  msg: PChar
end;

const err_tab: array [1..59] of err =
 ((no:   1; msg: 'invalid function number'            ),
  (no:   2; msg: 'file not found'                     ),
  (no:   3; msg: 'path not found'                     ),
  (no:   4; msg: 'too many open files'                ),
  (no:   5; msg: 'file access denied'                 ),
  (no:   6; msg: 'invalid file handle'                ),
  (no:  12; msg: 'invalid file access code'           ),
  (no:  15; msg: 'invalid drive number'               ),
  (no:  16; msg: 'cannot remove current directory'    ),
  (no:  17; msg: 'cannot rename across drives'        ),
  (no:  18; msg: 'no more files'                      ),
  (no: 100; msg: 'disk read error'                    ),
  (no: 101; msg: 'disk write error'                   ),
  (no: 102; msg: 'file not assigned'                  ),
  (no: 103; msg: 'file not open'                      ),
  (no: 104; msg: 'file not open for input'            ),
  (no: 105; msg: 'file not open for output'           ),
  (no: 106; msg: 'invalid numeric format'             ),
  (no: 150; msg: 'disk is write-protected'            ),
  (no: 151; msg: 'bad drive request struct length'    ),
  (no: 152; msg: 'drive not ready'                    ),
  (no: 154; msg: 'CRC error in data'                  ),
  (no: 156; msg: 'disk seek error'                    ),
  (no: 157; msg: 'unknown media type'                 ),
  (no: 158; msg: 'sector not found'                   ),
  (no: 159; msg: 'printer out of paper'               ),
  (no: 160; msg: 'device write fault'                 ),
  (no: 161; msg: 'device read fault'                  ),
  (no: 162; msg: 'hardware failure'                   ),
  (no: 200; msg: 'division by zero'                   ),
  (no: 201; msg: 'range check error'                  ),
  (no: 202; msg: 'stack overflow error'               ),
  (no: 203; msg: 'heap overflow error'                ),
  (no: 204; msg: 'invalid pointer operation'          ),
  (no: 205; msg: 'floating point overflow'            ),
  (no: 206; msg: 'floating point underflow'           ),
  (no: 207; msg: 'invalid floating point operation'   ),
  (no: 208; msg: 'overlay manager not installed'      ),
  (no: 209; msg: 'overlay file read error'            ),
  (no: 210; msg: 'object not initialized'             ),
  (no: 211; msg: 'call to abstract method'            ),
  (no: 212; msg: 'stream registration error'          ),
  (no: 213; msg: 'collection index out of range'      ),
  (no: 214; msg: 'collection overflow'                ),
  (no: 215; msg: 'arithmetic overflow'                ),
  (no: 216; msg: 'general protection fault'           ),
  (no: 217; msg: 'invalid operation code'             ),
  (no: 227; msg: 'assertion failed'                   ),
  (no: 300; msg: 'file I/O error'                     ),
  (no: 301; msg: 'arrays bounds in := not matched'    ),
  (no: 302; msg: 'non-local procedure pointer'        ),
  (no: 303; msg: 'procedure pointer out of scope'     ),
  (no: 304; msg: 'function not implemented'           ),
  (no: 305; msg: 'breakpoint error'                   ),
  (no: 306; msg: 'terminated by Ctrl/C'               ),
  (no: 307; msg: 'terminated by Ctrl/Break'           ),
  (no: 308; msg: 'terminated by other process'        ),
  (no: 309; msg: 'no floating point processor'        ),
  (no: 310; msg: 'invalid variant type operation'     ));

function Error_Msg(err: DWord): string;
var
  i: LongInt;
begin
  for i := Low(err_tab) To High(err_tab) do
  with err_tab[i] do
    if no = err then
    begin
      error_msg := StrPas(msg);
      exit;
    end;
  error_msg := '** Unknown error code ***';
end;

end.
