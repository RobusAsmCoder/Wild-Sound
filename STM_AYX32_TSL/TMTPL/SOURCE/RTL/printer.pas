(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Printer Interface Unit                                 *)
(*       Targets: MSDOS, OS/2, WIN32                            *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Authors: Anton Moscal, Vadim Bodrov                    *)
(*                                                              *)
(****************************************************************)

unit Printer;

{$i-,opt+,a+,cc+}

interface

var
  LST: Text;

implementation

{$ifdef __DOS__}
var
  Dummy: Char;
  _lst: TFileRec absolute LST;
{$endif}

var
  OldExitProc: Pointer;

procedure PrinterExitProc;
begin
  Close(LST);
  ExitProc:= OldExitProc;
end;

begin
  OldExitProc := @PrinterExitProc;
{$ifdef __DOS__}
  Assign(LST, 'PRN');
  Rewrite(LST);
    asm
      mov   ebx, _lst.handle
      mov   eax, $4400
      int   $21
      xor   edx, edx
      or    dl, $20
      mov   eax, $4401
      int   $21
    end;
{$else}
  Assign(LST, 'PRN');
  Rewrite(LST);
{$endif}
end.