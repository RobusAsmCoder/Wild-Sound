(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Debugger Unit                                          *)
(*       Targets: MS-DOS only                                   *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Author: Anton Moscal                                   *)
(*                                                              *)
(****************************************************************)

unit FDebug;

interface

var
  _errf: Text;

procedure print_call_stack(ebp, eip: DWORD; args: SmallInt; skip: SmallInt);

implementation

{$q-,s-}
uses Strings, ErrCodes;
{$system}
var
  start_esp: DWORD;

const
  no_lin = $FFFF;

type
  prc = record
    addr, len: DWORD;
    line_len:  DWORD;
    name:      String
  end;

  lin = record
    f,l:  Word;
    offs: DWORD
  end;

  pprc    = ^prc;
  plin    = ^lin;
  pdword  = ^DWORD;
  pstring = ^String;
{$ifdef __TMT__}

const
  reent_flag: Boolean = false;

function link: PChar; Result := %link;

function find_file(n: DWORD): string;
var
  ptr: PChar;
begin
  ptr := link;
  inc(ptr, PDWord(ptr)^);
  while n <> 0 do begin
    inc (ptr, ord(ptr^) + 1);
    n -:= 1;
  end;
  Result := PString(ptr)^;
end;

function get_dword(var _p): DWORD;
var
  p: PChar absolute _p;
  c: Char;
  h: DWORD;
begin
  Result := 0;
  c := p^;
  inc(p);
  if c < #$C0 then
  begin
    Result := ord(c);
    exit;
  end;
  h := ord(c) - $C0;
  repeat
    c := p^;
    Result := (Result shl 7) + (ord(c) and $7F);
    inc(p);
  until c < #$80;
  Result := (Result shl 6) + h;
end;

function find_proc(a: DWORD; var lin_ent: lin): PPrc;
var
  ptr : PChar;
  i: Longint;
begin
  ptr := link;
  inc (ptr, 8);
  for i := 1 to PDWord(ptr-4)^ do with PPrc(ptr)^ do
  begin
    if (a > addr) and (a - addr < len) then
    begin
      Result := PPrc(ptr);
       lin_ent.f := no_lin;

      if line_len = 0 then
        lin_ent.f := no_lin
      else
      declare
      var
        pl, pl_end: PLin;
        le: Lin;
        doffs: DWORD;
        pred_line: DWORD;
      begin
         pl := plin(@name[length(name) + 1]);
        pl_end := plin(pchar(pl) + line_len);
        le.offs := 0;
        pred_line := 0;

        while pl <> pl_end do
        begin
          doffs := get_dword(pl);
          if (doffs and $3) = 0 then
          begin
            le.f := get_dword(pl);
            le.l := get_dword(pl);
            pred_line := 0;
          end
          else
            if (doffs and $3) = 3 then
            begin
              le.l := get_dword(pl);
              if le.l >= 4 then
                le.l -:= 4
              else
                le.l +:= pred_line + 2;
            end
            else
              le.l +:= (doffs and $3) - 1;
              pred_line := le.l;
              le.offs +:= doffs shr 2;
              if le.offs > a - addr then exit;
              lin_ent := le;
        end;

        lin_ent.f := no_lin // TMP
      end;
      exit;
    end;
    ptr := @name[length(name) + 1] + line_len;
  end;
  Result := nil;
end;
{$endif}

procedure runerr_call_stack_proc(code, ebp, eip: DWORD);
begin
  Write(_errf, 'RunError #' + whl(code) + ' (' +  error_msg(code) + ')'^m^j);
  Writeln(_errf, 'eip='+hex(dword (eip))+' ebp='+hex(dword (ebp))+' some='+hex(dword(@runerr_call_stack_proc)));
  print_call_stack(ebp, eip, 7, 0);
end;

{$r-}
procedure print_call_stack;
 procedure print_frame;
 var
   i: Longint;
   p: pprc;
   l: lin;
 begin
   p := find_proc(eip - 1, l);
   if p <> nil then
   begin
     Write(_errf, p^.name);
     if l.f <> no_lin then
       Write(_errf, ' [' + find_file(l.f) + '(' + whl(l.l) + ') at ' + hex(eip - p^.addr - l.offs))
     else
       Write(_errf, '[at ' + hex(eip - p^.addr));
     Write(_errf, ']'^m^j);
   end else
     Write(_errf, hex(eip) + ' [**unknown**]'^m^j);
 end;

 function next_frame: Boolean;
 var
   i: DWORD;
 begin
   next_frame := false;
   if (DWORD(@i) < ebp) and (ebp + 4 <= start_esp) and (DWORD(memd[ebp]) <> ebp) then
   begin
     eip := DWORD(memd[ebp+4]);
     ebp := DWORD(memd[ebp]);
     next_frame := true;
   end;
 end;

if reent_flag then
  Write(_errf, 'double exception occured. Aborted')
else
begin
  reent_flag := true;
  repeat
     if skip = 0 then Write(_errf, 'Calls stack:'^m^j);
    skip -:= 1;
    if skip < 0 then print_frame;
  until not next_frame;
  close(_errf);
end;

{$optfrm-}
function get_esp: DWORD; var v: DWORD; get_esp := DWORD(@v) + 24;

begin
  assign(_errf, 'debug.log');
  rewrite(_errf);
  start_esp := get_esp + 24;
  System.%runerr_call_stack_proc_addr := @runerr_call_stack_proc;
end.