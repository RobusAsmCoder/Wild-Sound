(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       SORT_FUN.INC for System Unit                           *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$ifdef interface}

procedure %QSort32(base: Pointer; num, width: Integer; function CompFunc (const elem1, elem2: Pointer): Boolean);
overload QSort = %QSort32;
procedure %QSort64(base: Pointer; num, width: Integer; function CompFunc conv arg_based (const elem1, elem2: Pointer): Boolean);
overload QSort = %QSort64;

{$else}

procedure SwapPtr(P1, P2: Pointer; Size: Integer); code;
asm
  push  ecx
  mov   edi, [P1+4]
  mov   esi, [P2+4]
  mov   ecx, [Size+4]
@@1:
  mov   al, [esi]
  mov   ah, [edi]
  mov   [edi], al
  mov   [esi], ah
  inc   esi
  inc   edi
  loop  @@1
  pop   ecx
  ret
end;

procedure %QSort32(base: Pointer; num, width: Integer; function CompFunc (const elem1, elem2: Pointer): Boolean);
var
  first, last: Integer;
  procedure Partition(part_base: Pointer; first, last: Integer);
  var
    Right, Left: Integer;
    V: Pointer;
  begin
    V := part_base + ((first + last) shr 1 * width);
    Right := first;
    Left := last;
    repeat
      while CompFunc(V, part_base + (Right * width)) do
        Right +:= 1;
      while CompFunc(part_base + (Left * width), V) do
        Left -:= 1;
      if (Right <= Left) then
        begin
          SwapPtr(part_base + (Right * width), part_base + (Left * width), width);
          Right +:= 1;
          Left -:= 1
        end;
    until Right > Left;
    if (first < Left) then
      Partition(part_base, first, Left);
    if (Right < last) then
      Partition(part_base, Right, last)
  end;
begin
  if (width * num) <> 0 then
  begin
    first := 0;
    last := num - 1;
    if first < last then Partition(base, first, last)
  end;
end;

procedure %QSort64(base: Pointer; num, width: Integer; function CompFunc conv arg_based (const elem1, elem2: Pointer): Boolean);
var
  first, last: Integer;
  procedure Partition(part_base: Pointer; first, last: Integer);
  var
    Right, Left: Integer;
    V: Pointer;
  begin
    V := part_base + ((first + last) shr 1 * width);
    Right := first;
    Left := last;
    repeat
      while CompFunc(V, part_base + (Right * width)) do
        Right +:= 1;
      while CompFunc(part_base + (Left * width), V) do
        Left -:= 1;
      if (Right <= Left) then
        begin
          SwapPtr(part_base + (Right * width), part_base + (Left * width), width);
          Right +:= 1;
          Left -:= 1
        end;
    until Right > Left;
    if (first < Left) then
      Partition(part_base, first, Left);
    if (Right < last) then
      Partition(part_base, Right, last)
  end;
begin
  if (width * num) <> 0 then
  begin
    first := 0;
    last := num - 1;
    if first < last then Partition(base, first, last)
  end;
end;

{$endif}