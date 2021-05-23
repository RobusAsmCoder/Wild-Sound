(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       MEM_ALC.INC for System Unit                           *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Author: Anton Moscal, Vadim Bodrov                     *)
(*                                                              *)
(****************************************************************)

{$ifdef interface}
procedure  getmem (var dst:pointer; amount: dword);
procedure freemem (var dst:pointer; amount: dword);
function  sys_new_ptr     (size:dword):pointer;    %builtin 18;
procedure sys_dispose_ptr (p:pointer );            %builtin 19;
procedure sys_new_obj;                             %builtin 83;
procedure sys_new_obj_0;                           %builtin 84;

function memavail: longint;
function maxavail: longint;
procedure %intr_enter;                             %builtin 113;
procedure %intr_leave;                             %builtin 114;

{$else}

{$ifdef __limit__}
{$define __memasm__}
const mem_limit = 1024*1024;
const mem_rest: dword = mem_limit;
const allocated: dword = 0;
{$endif}

const zero_elem: record len_0:dword; next, pred: pointer; len_1: dword end
    = (len_0: 0; next: @zero_elem; pred: @zero_elem; len_1: 0);

const heap_seg_size: dword = 64*1024;

const _free_ptr: pointer = @zero_elem;

const heap_beg: dword = 0;
      heap_ptr: dword = 0;
      heap_end: dword = 0;
var   free_ptr: dword absolute _free_ptr;


procedure heap_check;
    var ptr: dword;
        len: longint;
        prd: (free, used);
begin
    ptr := heap_beg;
    prd := used;
    if ptr <> 0 then
        while ptr + 4 <> heap_ptr do begin
            if ptr > heap_ptr then
                runerror (995);
            len := memd [ptr + 4];
            if len < 0 then
                len := -len
            else if prd = free then
                runerror (997);
            if memd [ptr + 4] <> memd [ptr + len] then
                runerror (996);
            inc (ptr, len);
        end;

    ptr := memd [free_ptr + 4];
    while ptr <> free_ptr do begin
        if ptr <> dword (@zero_elem) then begin
            if longint (memd [ptr]) < 0 then
                runerror (305);
            if memd [ptr] <> memd [ptr + memd [ptr] - 4] then
                runerror (305);
            if ptr <= heap_beg then
                runerror (305);
            if ptr >= heap_ptr then
                runerror (305);
        end;
        ptr := memd [ptr+4];
    end;
end;

{$ifdef __WIN32__}
procedure GetMem(var dst: pointer; amount: dword);
var
  HeapResult: DWord;
begin
  if amount = 0 then
  begin
    dst := nil;
    exit;
  end;
  dst := Pointer(GlobalAlloc(0, amount));
  if dst = nil then
  begin
    HeapResult := 0;
    if HeapError <> nil then
    asm
      push  Amount
      call  dword ptr [HeapError]
      mov   [HeapResult],eax
    end;
    case HeapResult of
      0: RunError (heap_overflow_error);
      1: begin
           Dst := nil;
           exit;
         end;
      2: begin
           GetMem(Dst, Amount);
           exit;
         end;
    end;
  end;
end;
{$endif}

{$ifndef __WIN32__}
procedure getmem;
var
  ptr: dword;
  len: dword;
  tail: dword;
label ex;
var HeapResult: DWord;
begin
    ptr := free_ptr;
    len := (amount + (8 + $f)) and not $f;
    repeat
        if memd [ptr] >= len then declare
            var rest: dword;
        begin
            {$ifdef __memasm__}
                asm
                    mov eax, ptr
                    mov ebx, 4[eax]
                    mov ecx, 8[eax]
                    mov 8[ebx], ecx
                    mov 4[ecx], ebx
                    mov free_ptr, ebx
                    mov ebx, len; mov edi, ebx; neg ebx;
                    mov edx, [eax]; add edx, ebx; mov rest, edx
                    mov [eax], ebx; mov [eax+edi-4], ebx
                    mov esi, [dst]
                    mov [esi], eax; add dword ptr [esi], 4;
                    or edx, edx; je @@1

                    add eax, edi;
                    mov [eax], edx; mov [eax+edx-4], edx
                    mov esi, free_ptr; mov ecx, 8[esi];
                    mov 4[eax], esi
                    mov 8[eax], ecx
                    mov 8[esi], eax
                    mov 4[ecx], eax
                @@1:
                end;
            {$else}
                memd [memd [ptr + 4] + 8] := memd [ptr + 8];
                memd [memd [ptr + 8] + 4] := memd [ptr + 4];
                free_ptr := memd [ptr + 4];
                rest := memd [ptr] - len;
                memd [ptr          ] := -len;
                memd [ptr + len - 4] := -len;
                dst := pointer (ptr + 4);
                if rest <> 0 then declare
                    var prd: dword;
                begin
                    inc (ptr, len);
                    memd [ptr       ] := rest;
                    memd [ptr+rest-4] := rest;
                    prd := memd [free_ptr+8];
                    memd [ptr+4] := free_ptr;
                    memd [ptr+8] :=      prd;
                    memd [free_ptr+8] := ptr;
                    memd [     prd+4] := ptr;
                end;
            {$endif}
            goto ex;
        end;
        ptr := memd [ptr + 4];
    until ptr = free_ptr;

    tail := heap_end - heap_ptr;
    if tail < len then declare
        var act_size: longint;
                 prd: dword;
    begin
        if heap_ptr <> 0 then begin
            memd [heap_ptr    ] := tail;
            memd [heap_end - 4] := tail;
            prd := memd [free_ptr+8];
            memd [heap_ptr+4] := free_ptr;
            memd [heap_ptr+8] :=      prd;
            memd [free_ptr+8] := heap_ptr;
            memd [     prd+4] := heap_ptr;
        end;

        inc(heap_seg_size, len);

        {$ifdef __OS2__}
        declare
            var rc: apiret;
                ptr: pointer;
        begin
            act_size := (heap_seg_size + 4095) and not 4096;
            rc := DosAllocMem (ptr, act_size, PAG_WRITE or PAG_COMMIT);
            if rc <> 0 then begin
             HeapResult := 0;
             if HeapError<>nil then
             asm
              push  act_size
              call  dword ptr [HeapError]
              mov   [HeapResult],eax
             end;
             case HeapResult of
              0: RunError (heap_overflow_error);
              1: begin
                  Dst := nil;
                  exit;
                 end;
              2: begin
                  GetMem (Dst, Amount);
                  exit;
                 end;
             end;
            end;
            heap_beg := dword (ptr);
        end;
        {$endif}

        {$ifdef __DOS__}
            {$ifdef __limit__}
               if mem_rest = 0 then  begin
                HeapResult := 0;
                if HeapError<>nil then
                asm
                  push  act_size
                  call  dword ptr [HeapError]
                  mov   [HeapResult],eax
                end;
                case HeapResult of
                 0: RunError (heap_overflow_error);
                 1: begin
                     Dst := nil;
                     exit;
                    end;
                 2: begin
                     GetMem (Dst, Amount);
                     exit;
                    end;
                end;
               end;
               heap_seg_size := mem_rest;
               mem_rest := 0;
            {$endif}
            heap_beg := dword (SysGetMem (heap_seg_size, act_size));
        {$endif}

        inc (heap_seg_size, heap_seg_size);
        if longint (act_size) - 8 < len then begin
             HeapResult := 0;
             if HeapError<>nil then
             asm
              push  act_size
              call  dword ptr [HeapError]
              mov   [HeapResult],eax
             end;
             case HeapResult of
              0: RunError (heap_overflow_error);
              1: begin
                  Dst := nil;
                  exit;
                 end;
              2: begin
                  GetMem (Dst, Amount);
                  exit;
                 end;
             end;
        end;
        act_size := act_size and not $f;
        heap_ptr := heap_beg + 4;
        heap_end := heap_beg + act_size - 4;
        memd [heap_end] := -1;
        memd [heap_beg] := -1;
    end;

    ptr := heap_ptr;
    inc (heap_ptr, len);
    memd [ptr]        := -len;
    memd [heap_ptr-4] := -len;
    dst := pointer (ptr + 4);
ex:
    {$ifdef __limit__}
        inc (allocated, len);
    {$endif}
end;
{$endif}

{$ifdef __WIN32__}
procedure FreeMem(var dst: pointer; amount: dword);
var
  HeapResult: DWORD;
begin
  if (dst = nil) or (amount = 0) then exit;
  if GlobalFree(DWORD(dst)) = 0 then
  begin
    dst := nil;
    exit;
  end;

    HeapResult := 0;
    if HeapError <> nil then
    asm
      push  Amount
      call  dword ptr [HeapError]
      mov   [HeapResult],eax
    end;
    case HeapResult of
      0: RunError (heap_overflow_error);
      1: begin
           Dst := nil;
           exit;
         end;
      2: begin
           FreeMem(Dst, Amount);
           exit;
         end;
    end;
end;
{$endif}

{$ifndef __WIN32__}
procedure freemem;
var
  ptr: dword;
  len: dword;
  nxt: dword;
  prd: dword;
begin
    if dst = nil then exit;
    {$ifdef __memasm__}
    asm
        mov edi, dst
        mov eax, [edi]
        mov  dword ptr [edi], 0
        sub  eax, 4
        mov  ecx, [eax]
        neg  ecx
        mov  [eax], ecx
        mov  [eax+ecx-4], ecx
        mov  ebx, [eax-4]
        or   ebx, ebx
        jle   @@1
        sub  eax, ebx
        add  ecx, ebx
        mov  [eax], ecx
        mov  [eax+ecx-4], ecx

        mov  esi, 4[eax]
        mov  edi, 8[eax]
        mov  8[esi], edi
        mov  4[edi], esi
        cmp  eax, free_ptr
        jne  @@1
        mov  free_ptr, esi
    @@1:

        mov ptr, eax
        mov len, ecx
    end;
    {$else}
         ptr := dword (dst) - 4;
         dst := nil;
         len := -memd [ptr];
         memd [ptr] := len;
         memd [ptr+len-4] := len;
         if longint (memd [ptr-4]) > 0 then begin
             dec (ptr, memd [ptr-4]);
             inc (len, memd [ptr]);
             memd [ptr      ] := len;
             memd [ptr+len-4] := len;
             memd [memd [ptr + 4] + 8] := memd [ptr + 8];
             memd [memd [ptr + 8] + 4] := memd [ptr + 4];
             if free_ptr = ptr then free_ptr := memd [ptr + 4];
         end;
    {$endif}

    nxt := ptr + len;
    if nxt = heap_ptr then
        heap_ptr := ptr
    else begin
        if longint (memd [nxt]) > 0 then declare
        begin
            memd [memd [nxt + 4] + 8] := memd [nxt + 8];
            memd [memd [nxt + 8] + 4] := memd [nxt + 4];
            if free_ptr = nxt then free_ptr := memd [nxt + 4];
            inc (len, memd [nxt]);
            memd [ptr] := len;
            memd [ptr+len-4] := len;
        end;

        prd := memd [free_ptr+8];
        memd [ptr+4] := free_ptr;
        memd [ptr+8] :=      prd;
        memd [free_ptr+8] := ptr;
        memd [     prd+4] := ptr;
    end;
    {$ifdef __limit__}
        dec (allocated, len);
    {$endif}
end;
{$endif}

procedure scan_all_free (procedure account (size: longint));
    var ptr: dword;
        act: longint;
begin
    ptr := free_ptr;
    repeat
        account (memd [ptr]);
        ptr := memd [ptr + 4];
    until ptr = free_ptr;
    account (heap_end - heap_ptr);
    {$ifdef __DOS__}
      {$ifdef __limit__}
        account (mem_rest);
        SysGetMem ($7FFFFFFF, act);
        if mem_rest < act then act := mem_Rest;
        account (act);
        DosRelease;
      {$else}
      declare
        var cnt: Longint;
    begin
        cnt := 0;
        repeat
            SysGetMem ($7FFFFFFF, act);
            account (act);
            cnt +:= 1;
        until act = 0;
        while cnt > 1 do begin
            DosRelease;
            cnt -:= 1;
        end;
    end
    {$endif}
    {$endif}
end;

function memavail;
{$ifdef __WIN32__}
var Gms: TMemoryStatus;
begin
     GlobalMemoryStatus(Gms);
     Result := Gms.dwTotalPageFile;
{$else}
begin
    result := 0;
    scan_all_free (begin result +:= size end);
    result := result - 24;
{$endif}
end;

function maxavail;
{$ifdef __WIN32__}
var Gms: TMemoryStatus;
begin
     GlobalMemoryStatus(Gms);
     Result := Gms.dwAvailPhys;
{$else}
begin
    result := 0;
    scan_all_free (if result < size then result := size);
    result := result - 24;
 {$endif}
end;


function  sys_new_ptr; var p:pointer; begin  getmem (p, size); sys_new_ptr := p; end;

const def_intr_stk_len  = 4096;
const intr_stk: pchar   = nil;
      intr_len: longint = 0;
      intr_cnt: longint = 0;

procedure intr_done;
    type ppchar = ^pchar;
    var p: pchar;
begin
    if intr_cnt <> 0 then
        runerror (0);
    while intr_stk <> nil do begin
        p := intr_stk - intr_len;
        intr_stk := ppchar (intr_stk)^;
        freemem (p, sizeof (pchar) + intr_len)
    end
end;

procedure intr_init (n, len: longint);
    type ppchar = ^pchar;
    var p: pchar;
begin
    intr_done;
    intr_len := len;
    while n <> 0 do begin
        getmem (p, len + sizeof (pchar));
        inc (p, len);
        ppchar (p)^ := intr_stk;
        intr_stk := p;
        dec (n);
    end
end;

procedure intr_error;
begin
    runerror (1);
end;

procedure %intr_enter; code;
asm
    push ecx edx ebx esp ebp esi edi
    mov  ecx, [esp+7*4]
    mov  [esp+7*4], eax
    push gs fs es ds
    mov  bx, cs:%flat_ds
    mov  ds, bx
    mov  es, bx
    cld
    mov  dx, ss
    mov  fs, dx
    mov  esi, esp
    mov  eax, intr_stk;
    cmp  eax, 0
    je   @@1
    mov  edi, [eax]
    mov  intr_stk, edi
    mov  ss, bx
    mov  esp, eax
@@1:
    push edx
    push esi
    // the structure used by debugger:
    push dword ptr fs:[esi+4*12] // eip
    push dword ptr fs:[esi+4*11] // eax
    push dword ptr fs:[esi+4*10] // ecx
    push dword ptr fs:[esi+4*09] // edx
    push dword ptr fs:[esi+4*08] // ebx
    push dword ptr fs:[esi+4*07] // esp
    push dword ptr fs:[esi+4*06] // ebp
    push dword ptr fs:[esi+4*05] // esi
    push dword ptr fs:[esi+4*04] // edi
    push dword ptr fs:[esi+4*03] // gs
    push dword ptr fs:[esi+4*02] // fs
    push dword ptr fs:[esi+4*01] // es
    push dword ptr fs:[esi+4*00] // ds
    jmp  ecx
end;

procedure %intr_leave; code;
asm
    cli
    add esp, 4*13
    pop esi
    pop edx
    mov eax, intr_stk
    mov [esp], eax
    mov intr_stk, esp
    mov ss, dx
    mov esp, esi
    pop ds es fs gs
    popad
    iretd
end;
{$endif}
