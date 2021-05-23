(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       FILES.INP for System Unit                              *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Authors: Anton Moscal, Vadim Bodrov                    *)
(*                                                              *)
(****************************************************************)

{$ifdef interface}
type %file_state =
  (
   %file_readable,      //00h
   %file_writeable,     //01h
   %file_opened,        //02h
   %file_assigned,      //03h
   %file_eof,           //04h
   %file_text,          //05h
   %file_file,          //06h
   %file_fileof,        //07h
   %file_tty,           //08h
   %file_special,       //09h
   %file_settextbuf     //0Ah
  );

type
  %flags = set of %file_state;

const
  %max_buf = 64;

type TFileRec = packed object
  magic   : ^TFileRec;
  name    : string;
  handle  : DWORD;
  rec_len : Longint;
  state   : %flags;
  rd_proc,
  wr_proc : function conv arg_based (f: Longint; buf: Pointer; len: Longint; var act: Longint): Longint;
  procedure check_magic;
  procedure check_opened;
  procedure check_readable;
  procedure check_writeable;
  procedure io_error(code: Integer);
end;
PFileRec = ^TFileRec;
FileRec  = TFileRec;

type TTextRec = packed object(TFileRec)
  buffer  : array [0..%max_buf - 1] of Char;
  index   : Longint;
  len_buf : Longint;
  max_buf : Longint;
  buf_adr : Pointer;
  function  eof: Boolean;
  procedure init;
  procedure fill_buf;
  procedure fill_chr;
  procedure skip_spaces;
  procedure get_n_char(n: Integer);
end;
PTextRec = ^TTextRec;
TextRec  = TTextRec;

function %normal_read conv arg_based (f: LongInt; buf: pointer; len: ULong; var act: ULong): LongInt;
function %normal_write conv arg_based (f: LongInt; buf: pointer; len: ULong; var act: ULong): LongInt;

const
  %input %builtin 73: TTextRec =
  (
   magic: @%input; name: 'input'; handle: 0; rec_len:1;
   state: [%file_assigned, %file_opened, %file_readable, %file_text];
   index: 1; len_buf: 1;
   max_buf: sizeof (%input.buffer); buf_adr: @%input.buffer;
   rd_proc: %normal_read; wr_proc: %normal_write
  );

const
  %output %builtin 74: TTextRec =
  (
   magic: @%output; name: 'output'; handle: 1; rec_len:1;
   state: [%file_assigned, %file_opened, %file_writeable, %file_text, %file_tty];
   index: 1; len_buf: 1;
   max_buf: sizeof (%output.buffer); buf_adr: @%output.buffer;
   rd_proc: %normal_read; wr_proc: %normal_write
 );

var
  Input : Text absolute  %input;
  Output: Text absolute %output;

procedure %reset_file     (var f: TFileRec; blk: DWord);       %builtin 41;
procedure %append_file    (var f: TFileRec; blk: DWord);       %builtin 42;
procedure %rewrite_file   (var f: TFileRec; blk: DWord);       %builtin 43;
procedure %reset_text     (var f: TTextRec            );       %builtin 44;
procedure %append_text    (var f: TTextRec            );       %builtin 45;
procedure %rewrite_text   (var f: TTextRec            );       %builtin 46;
procedure %reset_fileof   (var f: TFileRec; blk: DWord);       %builtin 47;
procedure %append_fileof  (var f: TFileRec; blk: DWord);       %builtin 48;
procedure %rewrite_fileof (var f: TFileRec; blk: DWord);       %builtin 49;
procedure %close          (var f: TFileRec            );       %builtin 50;

function  IOResult: Longint;

procedure %io_test;                                            %builtin 51;
procedure %read_bin    (var f: TFileRec; var dst);             %builtin 52;
procedure %write_bin   (var f: TFileRec; var src);             %builtin 53;
function  %block_read  (var f: TFileRec; var buf; count: DWord; res: boolean): DWord; %builtin 54;
function  %block_write (var f: TFileRec; var buf; count: DWord; res: boolean): DWord; %builtin 55;
function  %filepos     (var f: TFileRec): LongInt;             %builtin 56;
function  %filesize    (var f: TFileRec): LongInt;             %builtin 57;
procedure %seek        (var f: TFileRec; pos: LongInt);        %builtin 58;
procedure %truncate    (var f: TFileRec);                      %builtin 59;
procedure %assign      (var f: TFileRec; const _name: string); %builtin 60;

const
  Spaces       = [' ', ^I, ^J];
  White_Spaces = Spaces + [^M, ^L];
  Digits       = ['0'..'9'];
  Letters      = ['A'..'Z', 'a'..'z'];
  Hex_Digits   = Digits + ['A'..'F', 'a'..'f'];

const
  InOutRes:  Longint = 0;
  IO_Apiret: DWORD   = 0;
  FileMode:  Byte    = 2;

procedure %tty(s: string);

{$else}

const
  file_getsize_err   =  disk_seek_error;
  file_getpos_err    =  disk_seek_error;
  file_truncate_err  =  disk_seek_error;

procedure TFileRec.check_magic;
begin
  if magic <> @self then
  begin
    runerror(file_not_assigned);
  end;
end;

procedure TFileRec.check_opened;
begin
  check_magic;
  if not (%file_opened in state) then
    io_error(file_not_open);
end;

procedure TFileRec.check_readable;
begin
  check_opened;
  if not (%file_readable in state) then
    io_error(file_not_open_for_input);
end;

procedure TFileRec.check_writeable;
begin
  check_opened;
  if not (%file_writeable in state) then
    io_error(file_not_open_for_output);
end;

procedure TFileRec.io_error;
begin
  InOutRes := code;
end;

procedure io_err;
var
  stat: DWord := IOResult;
begin
  if stat <> 0 then begin
{$ifndef __WIN32__}
    %tty('I/O error: status = ' + whl(Stat) + '  API code = ' + whl(IO_ApiRet) + ^m^j);
{$endif}
    runerror(stat);
  end;
end;

procedure %io_test; if InOutRes <> 0 then io_err;
function  %normal_read;  %normal_read  := SysRead(f, buf, len, act);
function  %normal_write; %normal_write := SysWrite(f, buf, len, act);

procedure %tty;
var
  dummy: LongInt;
  TmpC: array [0..256] of char;
begin
{$ifdef __WIN32__}
  if isConsole then
    %output.wr_proc (%output.handle, @s [1], length (s), dummy)
  else
    MessageBoxEx(0,StrPCopy(TmpC, s), 'Error!', MB_ICONERROR or MB_TASKMODAL, LANG_NEUTRAL);
{$else}
    %normal_write(0, @s [1], length (s), dummy);
{$endif}
end;

procedure %assign;
begin
  with f do begin
    magic   := @f;
    state   := [%file_assigned];
    name    := _name;
    rd_proc := %normal_read;
    wr_proc := %normal_write;
    check_magic;
  end;
end;

procedure %reset(var _f: TFileRec; blk: DWord; access: ULong; const flags: %flags);
var
  fn: array [0..255] of char;
  f: TTextRec absolute _f;
begin
  if InOutRes <> 0 then exit;
  with f do begin
    check_magic;
    if %file_opened in state then %close(f);
    Move(name[1], fn, length(name));
    fn [length(name)] := #0;
    if (%file_text in flags) and not (%file_settextbuf in state) then
      %sys_settextbuf(f, buffer, sizeof(buffer));
    if length(name) = 0 then begin
{$ifdef __WIN32__}
      handle := GetStdHandle(STD_INPUT_HANDLE);
{$else}
      handle := 0;
{$endif}

    end else if %file_special in state then
      IO_ApiRet := 0
    else begin

{$ifdef __OS2__}
      IO_Apiret := SysOpen(@fn[0], access, handle);
{$endif}

{$ifdef __DOS__}
      IO_Apiret := SysOpen(@fn[0], access, handle);
{$endif}

{$ifdef __WIN32__}
      if Length(Name) <> 0 then
        io_apiret := SysOpen(@fn[0], access, handle);
{$endif}
    end;
    if IO_ApiRet <> 0 then
      io_error(IO_Apiret)
    else begin
      state := state + flags + [%file_opened];
      rec_len := blk;
    end
  end
end;

{$ifdef __OS2__}
procedure %reset_file;
begin
  %reset(f, blk, FileMode + OPEN_SHARE_DENYWRITE, [%file_file, %file_readable, %file_writeable]);
end;

procedure %reset_fileof;
begin
  %reset(f, blk, FileMode + OPEN_SHARE_DENYWRITE, [%file_fileof, %file_readable, %file_writeable]);
end;

procedure %reset_text;
begin
 f.init;
 %reset(f, 1, FileMode + OPEN_SHARE_DENYWRITE, [%file_text, %file_readable]);
 if InOutRes = 0 then if not (%file_special in f.state) then f.fill_buf;
end;
{$endif}

{$ifdef __DOS__}
procedure %reset_file;   begin %reset(f, blk, filemode, [%file_file  , %file_readable, %file_writeable]); end;
procedure %reset_fileof; begin %reset(f, blk, filemode, [%file_fileof, %file_readable, %file_writeable]); end;
procedure %reset_text;
begin
  f.init;
  %reset(f, 1, OPEN_RD, [%file_text, %file_readable]);
  if InOutRes = 0 then
    if not (%file_special in f.state) then f.fill_buf;
end;
{$endif}

{$ifdef __WIN32__}
procedure %reset_file;
begin
  %reset(f, blk, filemode, [%file_file, %file_readable, %file_writeable]);
end;

procedure %reset_fileof;
begin
  %reset (f, blk, filemode, [%file_fileof, %file_readable, %file_writeable]);
end;

procedure %reset_text;
begin
  f.init;
  %reset(f, 1, OPEN_RD, [%file_text, %file_readable]);
end;
{$endif}

procedure %rewrite(var _f: TFileRec; blk: DWord; const flags: %flags);
var
  fn: array [0..255] of Char;
  f: TTextRec absolute _f;
begin
  if InOutRes <> 0 then Exit;
  with f do begin
    check_magic;
    if %file_opened in state then %close(f);
    if (%file_text in flags) and not (%file_settextbuf in state) then
      %sys_settextbuf(f, buffer, sizeof(buffer));
    Move(name[1], fn, length(name));
    fn[Length(name)] := #0;
    if Length(name) = 0 then begin
      include (state, %file_tty);
{$ifdef __WIN32__}
    handle := GetStdHandle(STD_OUTPUT_HANDLE);
{$else}
    handle := 1;
{$endif}
  end else
    if %file_special in state then IO_ApiRet := 0
  else begin
{$ifdef __OS2__}
   IO_ApiRet := SysCreate(@fn[0], OPEN_ACCESS_READWRITE + OPEN_SHARE_DENYWRITE, handle);
{$endif}

{$ifdef __DOS__}
   IO_ApiRet := SysCreate(@fn[0], 0, handle);
{$endif}

{$ifdef __WIN32__}
   IO_ApiRet := SysCreate(@fn[0], 1, handle);
{$endif}
    end;
    if IO_ApiRet <> 0 then io_error(IO_ApiRet)
    else begin
      rec_len := blk;
      state := state + flags + [%file_opened];
    end
  end
end;

procedure %rewrite_file;
begin
  %rewrite(f, blk, [%file_file  , %file_writeable, %file_readable]);
end;

procedure %rewrite_text;
begin
  %rewrite(f, 1,   [%file_text  , %file_writeable]);
end;

procedure %rewrite_fileof;
begin
  %rewrite(f, blk, [%file_fileof, %file_writeable, %file_readable]);
end;

procedure %append(var f: TFileRec; blk: DWord; const flags: %flags);
begin
{$ifdef __OS2__}
  %reset(f, blk, filemode, flags);
{$else}
  %reset(f, blk, OPEN_RW or SH_DENYWR, flags);
{$endif}
  if IOResult <> 0 then %rewrite(f, blk, flags);
  %seek(f, %filesize (f));
end;

procedure %append_text;
begin
  %append(f, 1, [%file_text, %file_writeable]);
end;

procedure %append_file;
begin
  %append(f, blk, [%file_file , %file_writeable, %file_readable]);
end;

procedure %append_fileof;
begin
  %append(f, blk, [%file_fileof, %file_writeable, %file_readable]);
end;

procedure %close;
begin
  if InOutRes <> 0 then exit;
  with f do begin
    check_opened;
    io_apiret := SysClose(handle);
    if io_apiret <> 0 then
      io_error(io_apiret)
    else begin
      state := [%file_assigned];
      handle := 0;
    end;
  end;
end;

function IOResult;
begin
  IOResult := InOutRes;
  InOutRes := 0;
end;

function filesizeb(var f: TFileRec): LongInt;
begin
  f.check_opened;
  filesizeb := SysFileLength(f.handle);
end;

function fileposb(var f: TFileRec):LongInt;
begin
  f.check_opened;
  fileposb := SysFilePos(f.handle);
end;

function %filepos;
begin
  f.check_opened;
  %filepos := fileposb(f) div f.rec_len;
end;

function %filesize;
begin
  %filesize := filesizeb(f) div f.rec_len;
end;

procedure %seek;
var
  act_pos: ULong;
begin
  if InOutRes <> 0 then exit;
  f.check_opened;
  if InOutRes <> 0 then exit;
  io_apiret := SysSetFilePtr(f.handle, pos * f.rec_len, file_begin, act_pos);
  if io_apiret <> 0 then
  InOutRes := disk_seek_error;
end;

procedure %read_bin;
var
  act: ULong;
begin
  f.check_readable;
  if InOutRes <> 0 then exit;
  io_apiret := f.rd_proc(f.handle, @dst, f.rec_len, act);
  if (io_apiret <> 0) or (act <> f.rec_len) then
  InOutRes := disk_read_error;
end;

procedure %write_bin;
var
  act: ULong;
begin
  f.check_writeable;
  if InOutRes <> 0 then exit;
  io_apiret := f.wr_proc (f.handle, @src, f.rec_len, act);
  if (io_apiret <> 0) or (act <> f.rec_len) then
  InOutRes := disk_write_error;
end;

function %block_read;
var
  act: ULong;
  size: DWord;
begin
  if InOutRes <> 0 then exit;
  f.check_readable;
  if InOutRes <> 0 then exit;
  size := f.rec_len * count;
  io_apiret := f.rd_proc(f.handle, @buf, size, act);
  if not res then
    if io_apiret <> 0 then
      InOutRes := io_apiret
    else if act <> size then
      InOutRes := disk_read_error;
  %block_read := act div f.rec_len;
end;

function %block_write;
var
  act:  ULong;
  size: DWord;
begin
  if InOutRes <> 0 then exit;
  f.check_writeable;
  if InOutRes <> 0 then exit;
  size := f.rec_len * count;
  io_apiret := f.wr_proc(f.handle, @buf, size, act);
  if res then
    %block_write := act div f.rec_len
  else
    if (io_apiret <> 0) or (act <> size) then
    begin
     InOutRes := io_apiret;
     %block_write := act div f.rec_len;
   end
end;

procedure %truncate;
{$ifdef __OS2__}
begin
  if InOutRes <> 0 then exit;
  f.check_writeable;
  if InOutRes <> 0 then exit;
  io_apiret := dossetfilesize(f.handle, fileposb (f));
  if io_apiret <> 0 then
  InOutRes := io_apiret;
end;
{$endif}
{$ifdef __DOS__}
var
  regs: SysIO32.regs;
begin
  if InOutRes <> 0 then exit;
  f.check_writeable;
  if InOutRes <> 0 then exit;
  regs.ecx := 0;
  regs.edx := 0;
  regs.ds := 0;
  regs.ebx := f.handle;
  regs.eax := $4000;
  SysIO32.DosInt($21, regs, 0);
  if (regs.flags and 1) = 0
  then
    io_apiret := 0
  else
  begin
    io_apiret := file_truncate_err;
    InOutRes := io_apiret;
  end;
end;
{$endif}
{$ifdef __WIN32__}
begin
  if InOutRes <> 0 then exit;
  f.check_writeable;
  if InOutRes <> 0 then exit;
  if SetEndOfFile(f.handle)
  then
    io_apiret := 0
  else
  begin
    io_apiret := GetLastError;
    InOutRes := io_apiret;
  end;
end;
{$endif}

{$else}
procedure %read_str conv (arg_reverse + arg_no_drop_1) (const _dst: string; max: Integer; var f: TTextRec); %builtin 61;
function  %read_chr conv (arg_reverse + arg_no_drop_1) (var f: TTextRec): char;      %builtin 62;
function  %read_int conv (arg_reverse + arg_no_drop_1) (var f: TTextRec): LongInt;   %builtin 63;
function  %read_uns conv (arg_reverse + arg_no_drop_1) (var f: TTextRec): DWord;     %builtin 64;
procedure %read_flt conv (arg_reverse + arg_no_drop_1) (var dst:     real; var f:  text); %builtin 65;
procedure %read_sng conv (arg_reverse + arg_no_drop_1) (var dst:   single; var f:  text); %builtin 93;
procedure %read_dbl conv (arg_reverse + arg_no_drop_1) (var dst:   double; var f:  text); %builtin 94;
procedure %read_ext conv (arg_reverse + arg_no_drop_1) (var dst: extended; var f: TTextRec); %builtin 95;
procedure %read_lin                                    (var f: TTextRec);            %builtin 66;
function  %eof      (var f: TFileRec): boolean;          %builtin 67;
function  %text_eof (var f: TTextRec): boolean;          %builtin 68;
function  %eoln     (var f: TTextRec): boolean;          %builtin 69;
procedure %sys_settextbuf (var f: TTextRec; var buf; size: LongInt); %builtin 92;

procedure %read_char_array      conv (arg_reverse + arg_no_drop_1) (const _dst; max: Integer; var f: TTextRec); %builtin 116;
procedure %read_open_char_array conv (arg_reverse + arg_no_drop_1) (const _dst; max: Integer; var f: TTextRec); %builtin 117;

procedure %read_wchar_array      conv (arg_reverse + arg_no_drop_1) (const _dst; max: Integer; var f: TTextRec);
procedure %read_open_wchar_array conv (arg_reverse + arg_no_drop_1) (const _dst; max: Integer; var f: TTextRec);

{$else}

procedure %read_char_array;
var
  dst: Pointer;
begin
  dst := @_dst;
  if InOutRes <> 0 then exit;
  f.check_readable;
  if InOutRes <> 0 then exit;
  f.fill_chr;
  while ((max - 1) <> 0) and not %eoln(f) do
  begin
    Char(dst^) := pchar(f.buf_adr)[f.index];
    inc(dst);
    f.get_n_char(1);
    dec(max);
  end;
  Char(dst^) := #0;
end;

procedure %read_open_char_array;
var
  dst: Pointer;
begin
  dst := @_dst;
  if InOutRes <> 0 then exit;
  f.check_readable;
  if InOutRes <> 0 then exit;
  f.fill_chr;
  while ((max - 1) <> 0) and not %eoln(f) do
  begin
    Char(dst^) := pchar(f.buf_adr)[f.index];
    inc(dst);
    f.get_n_char(1);
    dec(max);
  end;
  Char(dst^) := #0;
end;

procedure %read_wchar_array;
var
  dst: Pointer;
begin
  dst := @_dst;
  if InOutRes <> 0 then exit;
  f.check_readable;
  if InOutRes <> 0 then exit;
  f.fill_chr;
  while ((max - 1) <> 0) and not %eoln(f) do
  begin
    WChar(dst^) := pchar(f.buf_adr)[f.index];
    inc(dst, 2);
    f.get_n_char(1);
    dec(max);
  end;
  WChar(dst^) := #0;
end;

procedure %read_open_wchar_array;
var
  dst: Pointer;
begin
  dst := @_dst;
  if InOutRes <> 0 then exit;
  f.check_readable;
  if InOutRes <> 0 then exit;
  f.fill_chr;
  while ((max - 1) <> 0) and not %eoln(f) do
  begin
    WChar(dst^) := pchar(f.buf_adr)[f.index];
    inc(dst, 2);
    f.get_n_char(1);
    dec(max);
  end;
  WChar(dst^) := #0;
end;

procedure %sys_settextbuf;
begin
  f.check_magic;
  f.buf_adr := @buf;
  f.max_buf := size;
  include (f.state, %file_settextbuf);
  f.check_magic;
end;

function %eof;
begin
  f.check_opened;
  if filesizeb (f) = fileposb (f) then
    include(f.state, %file_eof)
  else
    exclude(f.state, %file_eof);
  %eof := %file_eof in f.state;
end;

function %text_eof;
begin
  f.check_opened;
  if %file_tty in f.state then f.fill_chr;
  %text_eof := (f.index = f.len_buf) and %eof (f);
end;

function %eoln;
begin
  f.check_readable;
  %eoln := f.eof or (pchar (f.buf_adr) [f.index] = ^M);
end;

function TTextRec.eof;
begin
  check_readable;
  if %file_tty in state then fill_chr;
  eof := %file_eof in state;
end;

procedure TTextRec.init;
begin
  index   := 1;
  len_buf := 1;
end;

procedure TTextRec.fill_chr;
begin
  check_readable;
  if index = len_buf then fill_buf;
end;

procedure TTextRec.fill_buf;
begin
  check_readable;
  if index <> 0 then
  begin
    dec(len_buf, index);
    Move(pchar(buf_adr)[0], pchar(buf_adr)[index], len_buf);
    index := 0;
    if (%file_tty in state) or not eof then
    declare
    var
      act: ULong;
      req: Longint;
    begin
      req := max_buf - len_buf - 1;
      if %file_tty in state then req := 1;
      io_apiret := rd_proc(handle, @pchar(buf_adr)[len_buf], req, act);
      if io_apiret <> 0 then
        InOutRes := io_apiret
      else if act = 0 then
      begin
        include(state, %file_eof)
      end else
        inc(len_buf, act);
    end
  end;
  pchar(buf_adr)[len_buf] := #0;
end;

procedure TTextRec.get_n_char;
begin
  check_readable;
  if not %text_eof(self) then
  begin
    inc(index, n);
    if index = len_buf then fill_buf;
  end;
end;

procedure %read_str;
var
  dst: string absolute _dst;
begin
  if InOutRes <> 0 then exit;
  f.check_readable;
  if InOutRes <> 0 then exit;
  f.fill_chr;
  length (dst) := 0;
  while (max <> 0) and not %eoln(f) do
  begin
    inc(length(dst));
    dst[length(dst)] := pchar(f.buf_adr)[f.index];
    f.get_n_char(1);
    dec(max);
  end;
end;

procedure %read_lin;
begin
  if InOutRes <> 0 then exit;
  f.check_readable;
  if InOutRes <> 0 then exit;
  f.fill_chr;
  while not %eoln(f) do
    f.get_n_char(1);
  if not %text_eof(f) and %eoln(f) then
  begin
    f.get_n_char(1);
    if not %text_eof(f) and (pchar(f.buf_adr)[f.index] = ^J) then
    inc(f.index);
  end;
end;

function %read_uns;
label
  err;
var
  c: char;
  new_res, res: DWord;
  dig: DWord;
begin
  Result := 0;
  if InOutRes <> 0 then exit;
  f.check_readable;
  if InOutRes <> 0 then exit;
  f.skip_spaces;
  if %text_eof(f) then exit;
  c := pchar(f.buf_adr)[f.index];
  if (c in digits) then
  begin
    res := 0;
    repeat
      dig := ord(c) - ord('0');
      new_res := res * 10 + dig;
      if new_res < res then goto err;
      res := new_res;
      f.get_n_char(1);
      c := pchar(f.buf_adr)[f.index];
    until not (c in digits);
    if %text_eof(f) or (c in white_spaces) then
    begin
      %read_uns := res;
      exit;
    end;
  end;
err:
  f.index := f.len_buf - 2;
  f.io_error(invalid_numeric_format);
end;

function %read_int;
label
  err, no_sgn;
var
  c: Char;
  new_res,res: LongInt;
  dig: LongInt;
  neg: Boolean;
begin
  Result := 0;
  if InOutRes <> 0 then exit;
  f.check_readable;
  if InOutRes <> 0 then exit;
  f.skip_spaces;
  if %text_eof(f) then exit;
  c := pchar(f.buf_adr)[f.index];
  neg := false;
  if c = '-' then
    neg := true
  else if c <> '+' then
    goto no_sgn;
  f.get_n_char(1);
  c := pchar(f.buf_adr)[f.index];
no_sgn:
  if (c in digits) then
  begin
    res := 0;
    repeat
      dig := ord(c) - ord('0');
      new_res := res * 10 + dig;
      if new_res < res then goto err;
      res := new_res;
      f.get_n_char(1);
      c := pchar(f.buf_adr)[f.index];
    until not (c in digits);
    if %text_eof(f) or (c in white_spaces) then
    begin
      if neg then res := -res;
      %read_int := res;
      exit;
    end;
  end;
err:
  f.index := f.len_buf - 2;
  f.io_error(invalid_numeric_format);
end;

procedure TTextRec.skip_spaces;
begin
  check_readable;
  fill_chr;
  while not %text_eof (self) and (pchar (buf_adr) [index] in white_spaces) do
    get_n_char (1);
end;

procedure %read_flt;
var
  x: extended;
begin
  read(f, x);
  dst := x;
end;

procedure %read_sng;
var
  x: extended;
begin
  read(f, x);
  dst := x;
end;

procedure %read_dbl;
var
  x: extended;
begin
  read(f, x);
  dst := x;
end;

procedure %read_ext;
label
  no_sgn;
var
  c: Char;
  res: Extended := 0.0;
  dig: LongInt;
  neg: Boolean;
  function get_char: char;
  begin
    f.get_n_char(1);
    c := pchar(f.buf_adr)[f.index];
    get_char := c;
  end;
begin
  if InOutRes <> 0 then exit;
  f.check_readable;
  if InOutRes <> 0 then exit;
  f.skip_spaces;
  if %text_eof (f) then
  begin
    dst := 0;
    exit;
  end;
  begin
    c := pchar (f.buf_adr) [f.index];
    neg := false;
    if c = '-' then
    neg := true
  else if c <> '+' then
    goto no_sgn;
  get_char;
no_sgn:
  res := 0.0;
  while c in digits do
  begin
    res := res * 10 + (ord(c) - ord('0'));
    get_char;
  end;
  if c = '.' then declare
    var m: extended;
    begin
      m := 0.1;
      f.get_n_char(1);
      c := pchar(f.buf_adr)[f.index];
      while c in digits do
      begin
        res := res + m * (ord(c) - ord('0'));
        m := m / 10;
        get_char;
      end;
    end;
    if upcase(c) = 'E' then declare
    label
      no_sgn;
    var
      neg: Boolean;
      exp: LongInt;
    begin
      neg := false;
      get_char;
      if c = '-' then
        neg := true
      else if c <> '+' then
        goto no_sgn;
      get_char;
      no_sgn:
      exp := 0;
      while c in digits do begin
        exp := exp * 10 + (ord(c) - ord('0'));
        get_char;
      end;
      if neg then exp := -exp;
      res := res * system.exp(ln(10) * exp);
    end;
  end;
  if neg then res := -res;
  dst := res;
end;

function %read_chr;
begin
  if InOutRes <> 0 then exit;
  f.check_readable;
  if InOutRes <> 0 then exit;
  f.fill_chr;
  if not %text_eof(f) then
  begin
    %read_chr := pchar(f.buf_adr)[f.index];
    f.get_n_char(1);
  end else
    %read_chr := #0;
end;

{$else}

procedure %sys_write_ln                                     (               var f:TTextRec); %builtin 1;
procedure %sys_write_chr conv (arg_reverse + arg_no_drop_1) (w: LongInt;       c:wchar   ; var f:TTextRec); %builtin 2;
procedure %sys_write_pch conv (arg_reverse + arg_no_drop_1) (w: LongInt;       s:pchar  ; var f:TTextRec); %builtin 81;
procedure %sys_write_pwch conv (arg_reverse + arg_no_drop_1) (w: LongInt;       s:pwchar  ; var f:TTextRec); %builtin 120;
procedure %sys_write_char_array conv (arg_reverse + arg_no_drop_1) (w: LongInt; s:pchar; max: longint; var f:TTextRec); %builtin 118;
procedure %sys_write_wchar_array conv (arg_reverse + arg_no_drop_1) (w: LongInt; s:pwchar; max: longint; var f:TTextRec);
procedure %sys_write_str conv (arg_reverse + arg_no_drop_1) (w: LongInt; const s:string ; var f:TTextRec); %builtin 3;
procedure %sys_write_dec conv (arg_reverse + arg_no_drop_1) (w: LongInt;       n:LongInt; var f: text); %builtin 4;
procedure %sys_write_uns conv (arg_reverse + arg_no_drop_1) (w: LongInt;       n:DWord  ; var f: text); %builtin 5;
procedure %sys_write_flt conv (arg_reverse + arg_no_drop_1) (p, w: LongInt; var x:extended; var f: text); %builtin 6;
procedure %sys_write_log conv (arg_reverse + arg_no_drop_1) (w: LongInt;      x:boolean ; var f: text); %builtin 82;

procedure %sys_str_chr conv (arg_reverse + arg_no_drop_2) (w: LongInt;       c:char   ; var d: string); %builtin 85;
procedure %sys_str_pch  conv (arg_reverse + arg_no_drop_2) (w: LongInt;       s:pchar  ; var d: string); %builtin 86;
procedure %sys_str_pwch conv (arg_reverse + arg_no_drop_2) (w: LongInt;       s:pchar  ; var d: string); %builtin 121;
procedure %sys_str_char_array conv (arg_reverse + arg_no_drop_2) (w: LongInt; s:pchar  ; max: longint; var d: string); %builtin 119;
procedure %sys_str_wchar_array conv (arg_reverse + arg_no_drop_2) (w: LongInt; s:pwchar  ; max: longint; var d: string);
procedure %sys_str_str conv (arg_reverse + arg_no_drop_2) (w: LongInt; const s:string ; var d: string); %builtin 87;
procedure %sys_str_dec conv (arg_reverse + arg_no_drop_2) (w: LongInt;       n:LongInt; var d: string); %builtin 88;
procedure %sys_str_uns conv (arg_reverse + arg_no_drop_2) (w: LongInt;       n:DWord  ; var d: string); %builtin 89;
procedure %sys_str_flt conv (arg_reverse + arg_no_drop_2) (p,w: LongInt;var  x:double ; var d: string); %builtin 90;
procedure %sys_str_variant conv (arg_reverse + arg_no_drop_2) (w: LongInt; v: variant; var d: string);
procedure %sys_str_log conv (arg_reverse + arg_no_drop_2) (w: LongInt;       x:boolean; var d: string); %builtin 91;
procedure %sys_str_int64 conv (arg_reverse + arg_no_drop_2) (w: LongInt; var i: Int64; var d: string);

procedure flush(var f: text);
function %seekeoln(var f: text): Boolean;  %builtin 98;
function %seekeof(var f: text): Boolean; %builtin 99;

{$else}
procedure out_file(var f: TTextRec; const b; n: DWord);
var
  l: LongInt; han: longint;
begin
  if InOutRes <> 0 then exit;
  f.check_writeable;
  if InOutRes <> 0 then exit;
  f.wr_proc(f.handle, @b, n, l);
  if l <> n then begin
        han := f.handle;
        asm
           mov eax, l
           mov ebx, n
           mov ecx, han;
           int 3
        end;
  end;
end;

procedure flush;
begin
  (* do nothing *)
end;

function %seekeoln;
begin
  with TTextRec(f) do begin
    while not %eoln (TTextRec(f)) and (pchar(buf_adr)[index] in spaces) do
    get_n_char (1);
    %seekeoln := %eoln(TTextRec(f));
  end;
end;

function %seekeof;
begin
  with TTextRec(f) do begin
    fill_chr;
    while not %text_eof(TTextRec(f)) and (pchar(buf_adr)[index] in white_spaces) do
    get_n_char(1);
    %seekeof := %text_eof(TTextRec(f));
  end;
end;

procedure %sys_write_ln;
begin
  out_file(f, ^M^J, 2);
end;

procedure spc (var f: TTextRec; w, l: LongInt);
var
  i: LongInt;
const
  sp: char = ' ';
begin
  for i := succ (l) to abs (w) do
    out_file(f, sp, 1);
end;

procedure %sys_write_chr;
begin
 if w > 0 then spc(f, w, 1);
 out_file(f, Char(c), 1);
 if w < 0 then spc(f, w, 1);
end;

procedure %sys_write_pch;
var
  sLen: Longint;
begin
  sLen := StrLen(s);
  if w < 0 then spc(f, w, sLen);
  out_file(f, s^, sLen);
  if w > 0 then spc(f, w, sLen);
end;

procedure %sys_write_pwch;
var
  pBuffer: Pointer;
  sLen, i: Longint;
begin
  sLen := StrLen(s);
  if sLen > 1 then
  begin
    GetMem(pBuffer, sLen + 1);
    for i := 0 to sLen do
      Char(Pointer(pBuffer + i)^) := Char(Pointer(s + i * 2)^);
    if w < 0 then spc(f, w, sLen);
    out_file(f, pBuffer^, sLen);
    if w > 0 then spc(f, w, sLen);
    FreeMem(pBuffer, sLen + 1);
  end;
end;

procedure %sys_write_char_array;
var
  l, i: Longint;
begin
  l := 0;
  while (l < max) and (s[l] <> #0) do inc(l);
  if w > 0 then spc(f, w, l);
  out_file(f, s^, l);
  if w < 0 then spc(f, w, l);
end;

procedure %sys_write_wchar_array;
var
  l, i: Longint;
  pBuffer: Pointer;
begin
  l := 0;
  while (l <= max) and (s[l] <> #0) do inc(l);
  if l > 0 then
  begin
    GetMem(pBuffer, l);
    for i := 0 to l - 1 do
      Char(Pointer(pBuffer + i)^) := Char(s[i]);
    if w > 0 then spc(f, w, l);
    out_file(f, pBuffer^, l);
    if w < 0 then spc(f, w, l);
    FreeMem(pBuffer, l);
  end;
end;

procedure %sys_write_str;
begin
  if w > 0 then spc(f, w, length(s));
  out_file(f, s[1], length(s));
  if w < 0 then spc(f, w, length(s));
end;

procedure %sys_write_dec;
begin
  write(f, whl(n):w);
end;

procedure %sys_write_uns;
begin
  write(f, uns(n):w);
end;

procedure %sys_write_flt;
begin
  Write(f, fix(x, w, p));
end;

procedure %sys_write_log;
begin
  if x then
    write(f, 'TRUE':w)
  else
    write(f, 'FALSE':w);
end;

procedure str_add(var dst: string; const src: string; w: LongInt);
begin
  dst := dst + align(src, w);
end;

procedure %sys_str_chr;
begin
  str_add(d, c, w);
end;

procedure %sys_str_pch;
begin
  str_add(d, strpas(s), w);
end;

procedure %sys_str_pwch;
begin
  str_add(d, strpas(s), w);
end;

procedure %sys_str_char_array;
var
  l: Longint;
  r: string;
begin
  l := 0;
  while (l <= max) and (l < 255) and (s[l] <> #0) do begin r [l+1] := s [l]; inc (l); end;
  length(r) := l;
  str_add(d, r, w);
end;

procedure %sys_str_wchar_array;
var
  l: Longint;
  r: string;
begin
  l := 0;
  while (l <= max) and (l < 255) and (s[l] <> #0) do begin r [l+1] := s [l]; inc (l); end;
  length(r) := l;
  str_add(d, r, w);
end;

procedure %sys_str_str;
begin
  str_add(d, s, w);
end;

procedure %sys_str_dec;
begin
  str_add(d, whl (n), w);
end;

procedure %sys_str_uns;
begin
  str_add(d, uns(n), w);
end;

procedure %sys_str_flt;
begin
  str_add(d, fix(x, w, p), w);
end;

procedure %sys_str_variant;
var
  val: OleVariant absolute v;
  s: String;
begin
  case OleVariant(val).vt of
    VT_UI1:   Str(val.bVal, s);
    VT_I2:    Str(val.iVal, s);
    VT_I4:    Str(val.lVal, s);
    VT_I8:    Str(val.llVal, s);
    VT_R4:    Str(val.fltVal, s);
    VT_R8:    Str(val.dblVal, s);
    VT_BOOL:  if val.vbool then s := 'TRUE' else s := 'FALSE';
    VT_ERROR: Str(val.scode, s);
    VT_CY:    Str(val.cyVal, s);
    VT_DATE:  Str(val.date, s);
    VT_BSTR:  s := StrPas(val.bstrVal);
    VT_I1:    Str(val.cVal, s);
    VT_UI2:   Str(val.uiVal, s);
    VT_UI4:   Str(val.ulVal, s);
    VT_INT:   Str(val.intVal, s);
    VT_UINT:  Str(val.uintVal, s);
    VT_BYREF: s := HexStr(DWORD(val.byRef), 8);
  else
    RunError(INVALID_VARIANT_TYPE_OPERATION);
  end;
  str_add(d, s, w);
end;

procedure %sys_str_log;
begin
  if x then
    str_add(d, 'TRUE', w)
  else
    str_add(d, 'FALSE', w);
end;

procedure %sys_str_int64;
var
  s: String := '';
  ngf: Boolean;
begin
  if i < 0 then
  begin
    ngf := TRUE;
    i := - i;
  end else
    ngf := FALSE;
  repeat
    s := '0123456789'[DWORD(i mod 10) + 1] + s;
    i := i div 10;
  until i = 0;
  if ngf then
    s := '-' + s;
  str_add(d, s, w);
end;
{$else}

procedure GetDir conv arg_IO_test(d: byte; var s: string);
procedure ChDir conv arg_IO_test(s: string);
procedure mkdir conv arg_IO_test(s: string);
procedure RmDir conv arg_IO_test(s: string);
function  GetCurDir conv arg_IO_test(s: pchar; d: byte): pchar;
procedure changedir conv arg_IO_test(s: pchar);
procedure MakeDir conv arg_IO_test(s: pchar);
procedure RemoveDir conv arg_IO_test(s: pchar);
procedure rename conv arg_IO_test(var f; const new_name: string);
procedure Erase conv arg_IO_test(var f);

{$else}

{$ifdef __OS2__}
procedure changedir; InOutRes := dossetcurrentdir(s);
procedure MakeDir; InOutRes := doscreatedir(s, nil);
procedure RemoveDir; InOutRes := dosdeletedir(s);

function GetCurDir;
var
  len: ULong;
begin
  if d = 0 then declare
  var
    disk, map: ULong;
  begin
    dosquerycurrentdisk(disk, map);
    d := disk;
  end;
  len := 251;
  s[0] := chr(ord('A') + d - 1);
  s[1] := ':';
  s[2] := '\';
  InOutRes := dosquerycurrentdir(d, s+3, len);
  Result := s;
end;

procedure Erase;
var
  buf: array [0..256] of char;
begin
  with TFileRec(f) do begin
    check_magic;
    InOutRes := dosdelete(strpcopy(buf, name));
  end;
end;

procedure Rename;
var
  buf1: array [0..256] of char;
  buf2: array [0..256] of char;
begin
  with TFileRec(f) do begin
    check_magic;
    strpcopy(buf1, name);
    strpcopy(buf2, new_name);
    InOutRes := dosmove(buf1, buf2);
    name := new_name;
  end;
end;
{$endif}

{$ifdef __DOS__}
procedure ChangeDir; assembler;
    asm
      mov    ah, 3Bh
      mov    edx, [s]
      int    21h
      jnc    @@1
      movzx  eax, ax
      mov    [system.InOutRes], eax
@@1:
end;

procedure MakeDir; assembler;
    asm
      mov    ah, 39h
      mov    edx, [s]
      int    21h
      jnc    @@1
      movzx  eax, ax
      mov    [system.InOutRes], eax
@@1:
end;

procedure RemoveDir; assembler;
    asm
      mov   ah, 3Ah
      mov    edx, [s]
      int    21h
      jnc    @@1
      movzx  eax, ax
      mov    [system.InOutRes], eax
@@1:
end;

function GetCurDir; code;
      asm
        push    edx
        mov     esi, [s+4]
        mov     al, [d+4]
        or      al, al
        jnz     @@1
        mov     ah, 19h
        int     21h
        inc     al
@@1:    mov     dl, al
        add     al, 'A' - 1
        mov     [esi], al
        inc     esi
        mov     word ptr [esi], '\:'
        inc     esi
        inc     esi
        mov     ah, 47h
        int     21h
        jnc     @@2
        movzx   eax, ax
        mov     [system.InOutRes], eax
        @@2:
        mov    eax, [s+4]
        pop    edx
        ret
end;

procedure Erase;
  procedure file_erase (s: pchar); assembler;
    asm
      mov    ah, 41h
      mov    edx, [s]
      int    21h
      jnc    @@1
      movzx  eax, ax
      mov    [system.InOutRes], eax
@@1:
  end;
var
  buf: array [0..256] of char;
begin
  with TFileRec(f) do begin
    check_magic;
    file_erase(strpcopy(buf, name));
  end;
end;

procedure Rename;
var
  buf1: array [0..256] of char;
  buf2: array [0..256] of char;
begin
  with TFileRec(f) do
  begin
    check_magic;
    strpcopy(buf1, name);
    strpcopy(buf2, new_name);
      asm
        mov    ah, 56h
        lea    edx, buf1
        lea    edi, buf2
        int    21h
        jnc    @@1
        movzx  eax, ax
        mov    [system.InOutRes], eax
@@1:
      end;
    name := new_name;
  end;
end;
{$endif}

{$ifdef __WIN32__}
procedure ChangeDir;
begin
  if not SetCurrentDirectory(S) then
    InOutRes := GetLastError
  else
    InOutRes := NO_ERROR;
end;

procedure MakeDir;
var
  SAttr: TSecurityAttributes;
begin
  SAttr.nLength := SizeOf(SAttr);
  SAttr.lpSecurityDescriptor := nil;
  SAttr.bInheritHandle := False;
  if not CreateDirectory(S, @SAttr) then
    InOutRes := GetLastError
  else
    InOutRes := NO_ERROR;
end;

procedure RemoveDir;
begin
  if not RemoveDirectory(S) then
    InOutRes := GetLastError
  else
    InOutRes := NO_ERROR;
end;

function GetCurDir;
begin
  GetCurrentDirectory(MAX_PATH, S);
  Result := S;
end;

procedure Erase;
var
  buf: array [0..MAX_PATH-1] of char;
begin
  with TFileRec(f) do begin
    check_magic;
    DeleteFile(StrPCopy(Buf, Name));
  end;
end;

procedure Rename;
var
  buf1: array [0..MAX_PATH-1] of char;
  buf2: array [0..MAX_PATH-1] of char;
begin
  with TFileRec(f) do
  begin
    check_magic;
    if not MoveFile(StrPCopy(buf1, Name), StrPCopy(buf2, New_Name)) then
      InOutRes := GetLastError
    else
      InOutRes := NO_ERROR;
  end;
end;
{$endif}

{$i-}
procedure do_dir(procedure fun conv arg_IO_test(S: pchar); const S: string);
{$ifdef __WIN32__}
var buf: array [0..MAX_PATH-1] of char;
{$else}
var buf: array [0..255] of char;
{$endif}
begin
  fun(StrPCopy(Buf, S));
end;

procedure ChDir;
{$ifdef __DOS__}
var
  r: SysIO32.regs;
{$endif}
begin
{$ifdef __DOS__}
  FillChar(r, SizeOf(r), 0);
  if (Length(s) >= 2) and (s[2] =':') then
  begin
    r.EDX := (ord(s[1]) and (not 32)) - ord('A');
    r.EAX := $0E00;
    SysIO32.DosInt($21, r, 0);
    r.EAX := $1900;
    SysIO32.DosInt($21, r, 0);
    if (r.EAX and $FF) <> (r.EDX and $FF) then
    begin
      InOutRes := INVALID_DRIVE_NUMBER;
      exit;
    end;
    if Length(s) = 2 then exit;
  end;
{$endif}
  do_dir(ChangeDir, s);
end;

procedure MkDir;
begin
  do_dir(MakeDir, s);
end;

procedure RmDir;
begin
  do_dir(RemoveDir, s);
end;

procedure GetDir;
{$ifdef __WIN32__}
var
  buf: array [0..MAX_PATH-1] of char;
{$else}
var
  buf: array [0..255] of char;
{$endif}
begin
  s := StrPas(GetCurDir(Buf, d));
end;

{$endif}