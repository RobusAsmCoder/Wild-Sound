(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       STR_FUN.INC for System Unit                            *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995,99 TMT Development Corporation      *)
(*       Authors: Anton Moscal, Vadim Bodrov                    *)
(*                                                              *)
(****************************************************************)

{$ifdef interface}

function  UpCase(c: Char): Char;
function  LoCase(c: Char): Char;
function  Copy(const S: string; Index, Len: Longint): string;
procedure Delete(var S: string; Index, Len: Longint);
procedure Insert(Src: string; var Dst: string; Pos: Longint);
function  Pos(const Sub, S: string): DWord;
procedure SetString(var S: string; Buffer: PChar; Len: DWORD);
procedure SetLength(var S: String; NewLength: Integer);

procedure %sys_str_E ;                                    %builtin  7;
procedure %sys_str_NE;                                    %builtin  8;
procedure %sys_str_L ;                                    %builtin  9;
procedure %sys_str_LE;                                    %builtin 10;
procedure %sys_str_G ;                                    %builtin 11;
procedure %sys_str_GE;                                    %builtin 12;

procedure %sys_s_cpy;                                     %builtin 13;
procedure %sys_s_app;                                     %builtin 14;
procedure %sys_vec_2_str;                                 %builtin 15;
procedure %sys_string_assn;                               %builtin 16;
procedure %sys_string_assn_255;                           %builtin 80;
procedure %sys_vec_assn(dst_high: DWord; var dst;
 src_high: DWord; var src; size: DWord);                  %builtin 75;
procedure %sys_open_load;                                 %builtin 76;
procedure %sys_slice_vec;                                 %builtin 77;
procedure %sys_slice_str;                                 %builtin 78;
procedure %sys_arr_sizeof(dim, esize: DWord);             %builtin 100;
procedure %sys_arr_assn;                                  %builtin 101;
procedure %sys_arr_assn_checked;                          %builtin 102;
procedure %sys_slice_arr_full_1;                          %builtin 103;
procedure %sys_slice_arr_full_1_checked;                  %builtin 104;
procedure %sys_slice_arr_full_2;                          %builtin 105;
procedure %sys_slice_arr_full_2_checked;                  %builtin 106;
procedure %sys_slice_arr_full;                            %builtin 107;
procedure %sys_slice_arr_full_checked;                    %builtin 108;
procedure %sys_arr_load;                                  %builtin 109;
procedure %sys_slice_arr_part_0(ind, dim: DWord);         %builtin 110;
procedure %sys_slice_arr_part_0_checked(ind, dim: DWord); %builtin 111;

{$else}

procedure sys_str_cmp; code;
      asm
        push    ecx esi edi

        lodsb
        mov     ah, Byte ptr [edi]
        inc     edi
        cmp     al,0
        jz      @@2
        cmp     ah,0
        jnz     @@1
@@2:
        cmp     al,ah
        jmp     @@3
@@1:
        cmp     ah, al
        jl      @@4
        movzx   ecx, al
        jmp     @@5
@@4:
        movzx   ecx, ah
@@5:
        repe    cmpsb
        jne     @@3
        cmp     al, ah
@@3:
        pop     edi esi ecx
        ret
end;

procedure %sys_str_L; code;
asm
    call   sys_str_cmp
    setb   al
    ret
end;

procedure %sys_str_LE; code;
asm
    call   sys_str_cmp
    setbe  al
    ret
end;

procedure %sys_str_G; code;
asm
    call   sys_str_cmp
    seta   al
    ret
end;

procedure %sys_str_GE; code;
asm
    call   sys_str_cmp
    setae  al
    ret
end;

procedure %sys_str_E; code;
asm
    push  ecx esi edi
    lodsb
    movzx ecx, Byte ptr [edi]
    inc   edi
    cmp   al, cl
    jne   @@1
    repe  cmpsb
@@1:
    sete  al
    pop   edi esi ecx
    ret
end;

procedure %sys_str_NE; code;
asm
    push  ecx esi edi
    lodsb
    movzx ecx, Byte ptr [edi]
    inc   edi
    cmp   al, cl
    jne   @@1
    repe  cmpsb
@@1:
    setne  al
    pop   edi esi ecx
    ret
end;

procedure %sys_vec_assn;
begin
  %tty(hex(DWord(@dst)) + ' ' + whl(dst_high) + ' ' + hex(DWord(@src)) + ' ' + whl (src_high) + ' ' + whl(size) + ^m^j);
  if src_high <> dst_high then runerror(nonmatched_array_bounds);
  Move(src, dst, (src_high + 1) * size);
end;

procedure %sys_arr_assn; code;
asm
    push ebx ecx
    mov  ebx, [esp+8]
    add  DWord ptr [esp+8], 8
    mov  eax, [ebx+4]
    mov  ecx, [ebx]
@@loop:
    mov  ebx, [esi+ecx*4]
    inc  ebx
    imul eax, ebx
    loop @@loop

    mov  esi, [esi]
    mov  edi, [edi]
    mov  ecx, eax
    shr  ecx, 1
    jnc  @@2
    movsb
@@2:
    shr  ecx, 1
    jnc  @@3
    movsw
@@3:
    rep  movsd
    pop  ecx ebx
    ret
end;

procedure %sys_arr_assn_checked; code;
asm
    push ebx ecx
    mov  ebx, [esp+8]
    add  DWord ptr [esp+8], 8
    mov  eax, [ebx+4]
    mov  ecx, [ebx]
@@loop:
    mov  ebx, [esi+ecx*4]
    cmp  ebx, [edi+ecx*4]
    jne  @@err
    inc  ebx
    imul eax, ebx
    loop @@loop

    mov  esi, [esi]
    mov  edi, [edi]
    mov  ecx, eax
    shr  ecx, 1
    jnc  @@2
    movsb
@@2:
    shr  ecx, 1
    jnc  @@3
    movsw
@@3:
    rep  movsd
    pop  ecx ebx
    ret
@@err:
    push nonmatched_array_bounds
    call %runerror
end;

procedure %sys_string_assn_255; code;
asm
    push DWord ptr [esp]
    mov  DWord ptr [esp+4], 255
    jmp  %sys_string_assn
end;

procedure %sys_string_assn; code;
asm
    push eax ecx esi edi
    mov  ecx, [esp+20] { upb }
    lodsb
    cmp  cl, al
    jae  @@1
    mov  al, cl
@@1:
    stosb
    mov  cl, al
    shr  ecx, 1
    jnc  @@2
    movsb
@@2:
    shr  ecx, 1
    jnc  @@3
    movsw
@@3:
    rep  movsd
    pop  edi esi ecx eax
    ret 4
end;

procedure %sys_s_cpy; code;
asm
    push  ecx esi edi
    movzx ecx, Byte ptr [esi]
    inc   esi
    mov   [edi], cl
    inc   edi
    shr  ecx, 1
    jnc  @@2
    movsb
@@2:
    shr  ecx, 1
    jnc  @@3
    movsw
@@3:
    rep  movsd
    pop   edi esi ecx
    ret
end;

procedure %sys_s_app; code;
asm
    push  eax ebx ecx esi edi
    lodsb
    movzx ecx, al
    movzx eax, Byte ptr [edi]
    mov   ebx, edi
    lea   edi, [edi+eax+1]
    add   eax, ecx
    cmp   eax, 256
    jl    @@1
    sub   ecx, eax
    mov   eax, 255
    add   ecx, eax
@@1:
    mov   [ebx], al
    shr  ecx, 1
    jnc  @@2
    movsb
@@2:
    shr  ecx, 1
    jnc  @@3
    movsw
@@3:
    rep  movsd
    ;rep   movsb
    pop   edi esi ecx ebx eax
    ret
end;

procedure %sys_vec_2_str; code;
asm
    push eax ecx esi edi
    mov  ecx, DWord ptr [esp+20]
    mov  al, cl
    stosb
    shr  ecx, 1
    jnc  @@2
    movsb
@@2:
    shr  ecx, 1
    jnc  @@3
    movsw
@@3:
    rep  movsd
    ;rep  movsb
    pop  edi esi ecx eax
    ret 4
end;

function  UpCase(c: Char): Char;
code;
      asm
        movzx   eax, [c]
        cmp     al, 'a'
        jb      @@ret
        cmp     al, 'z'
        ja      @@ret
        sub     al, 'a'-'A'
@@ret:
        ret
end;

function  LoCase(c: Char): Char;
code;
      asm
        movzx   eax, [c]
        cmp     al, 'A'
        jb      @@ret
        cmp     al, 'Z'
        ja      @@ret
        add     al, 'a'-'A'
@@ret:
        ret
end;

procedure %sys_open_load; code;
asm
    pop   ebx
    pop   ecx
    mov   eax, DWord ptr [esi+4]
    inc   eax
    mul   ecx
    mov   ecx, eax
    sub   esp, ecx
    and   esp, $FFFFFFFC
    mov   eax, [esi]
    mov   edi, esp
    mov   [esi], edi
    mov   esi, eax
    jecxz  @@ret
    shr   ecx, 1
    jnc   @@2
    movsb
@@2:
    shr  ecx, 1
    jnc  @@3
    movsw
@@3:
    rep    movsd
    ;rep   movsb
@@ret:
    jmp    ebx
end;

procedure %sys_arr_load; code;

 procedure store (dims, e_size, dim, offs: DWord); code;
 const d = 12;
 asm
     push esi ecx eax
     mov  eax, dim+d
     cmp  eax, dims+d
     jne  @@next
     mov  ecx, e_size+d
     mov  esi, [esi]
     add  esi, offs+d

      shr  ecx, 1
      jnc  @@2
      movsb
  @@2:
      shr  ecx, 1
      jnc  @@3
      movsw
  @@3:
      rep  movsd
     ;rep  movsb
      jmp  @@ret
 @@next:
      mov  ecx, [esi+eax*4+4]
      inc  ecx
      add  eax, dims+d
      mov  eax, [esi+eax*4+4]
      jecxz @@ret
 @@loop:
      push dims+d
      push e_size+d+4
      push dim+d+8
      inc  DWord ptr [esp]
      push offs+d+12
      call store
      add  offs+d, eax
      loop @@loop
 @@ret:
      pop  eax ecx esi
      ret
 end;

asm
     pop  ebx
     mov  ecx, [esp+4]
     mov  eax, [esp]
     jecxz @@next
@@loop:
     mov  edx, [esi+ecx*4]
     inc  edx
     imul eax, edx
     loop @@loop
@@next:
     pop  edx
     pop  ecx
     sub  esp, eax
     and   esp, $FFFFFFFC
     mov  edi, esp
     push ebx
     push ecx
     push edx
     push edi

     push ecx
     push edx
     push 0
     push 0
     call store

     pop  DWord ptr [esi]
     pop  eax
     pop  ecx
     lea  edi, [esi+ecx*4]
     jecxz @@next2
@@loop2:
     mov  [edi+ecx*4], eax
     mov  ebx, [esi+ecx*4]
     inc  ebx
     imul eax, ebx
     loop @@loop2
@@next2:
     ret  0
end;

procedure bound_error (lwb, upb, val: DWord); forward;
procedure %sys_slice_vec; code;
asm
    mov    ebx, [esp+8]
    cmp    ebx, [esi+4]
    ja     @@err
    imul   ebx, [esp+4]
    add    ebx, [esi]
    ret    8
@@err:
    mov    eax, [esp]
    push   0
    push   DWord ptr [esi+4]
    push   ebx
    push   eax
    jmp    bound_error
end;

procedure %sys_slice_arr_full_1; code;
asm
    mov    eax, [esp+4]
    imul   eax, [esi+8]
    add    eax, [esi]
    ret    4
end;

procedure %sys_slice_arr_full_1_checked; code;
asm
    push   edi
    mov    edi, [esp+8]
    cmp    edi, [esi+4]
    ja     @@err
    mov    eax, edi
    imul   eax, [esi+8]
    add    eax, [esi]
    pop    edi
    ret    4
@@err:
    mov    eax, [esp]
    push   0
    push   DWord ptr [esi+4]
    push   edi
    push   eax
    jmp    bound_error
end;

procedure %sys_slice_arr_full_2; code;
asm
    push   edi
    mov    eax, [esp+ 8]
    imul   eax, [esi+12]
    mov    edi, [esp+12]
    imul   edi, [esi+16]
    add    eax, [esi]
    add    eax, edi
    pop    edi
    ret    8
end;

procedure %sys_slice_arr_full_2_checked; code;
asm
    push   edi
    mov    eax, [esi]
    mov    edi, [esp+8]
    cmp    edi, [esi+4]
    ja     @@err1
    imul   edi, [esi+12]
    add    eax, edi

    mov    edi, [esp+12]
    cmp    edi, [esi+ 8]
    ja     @@err2
    imul   edi, [esi+16]
    add    eax, edi
    pop    edi
    ret    8
@@err1:
    mov    eax, [esp+4]
    push   0
    push   DWord ptr [esi+4]
    jmp    @@err
@@err2:
    mov    eax, [esp+4]
    push   0
    push   DWord ptr [esi+8]
@@err:
    push   edi
    push   eax
    jmp    bound_error
end;

procedure %sys_slice_arr_full; code;
asm
     push ebx ecx
     mov  ecx, [esp+12]
     mov  edi, ecx
     mov  eax, [esi]
     lea  esi, [esi+ecx*4]
@@loop:
     mov  ebx, [esp+ecx*4+12]
     imul ebx, [esi+ecx*4]
     add  eax, ebx
     loop @@loop
     pop  ecx ebx
     pop  esi
     lea  esp, [esp+edi*4+4]
     jmp  esi
end;

procedure %sys_slice_arr_full_checked; code;
asm
     push ebx ecx edx
     mov  ecx, [esp+16]
     mov  edi, ecx
     mov  eax, [esi]
     lea  edx, [esi+ecx*4]
 @@loop:
     mov  ebx, [esp+ecx*4+16]
     cmp  ebx, [esi+ecx*4]
     ja   @@err
     imul ebx, [edx+ecx*4]
     add  eax, ebx
     loop @@loop
     pop  edx ecx ebx
     pop  esi
     lea  esp, [esp+edi*4+4]
     jmp  esi
 @@err:
     mov    eax, [esp+12]
     push   0
     push   DWord ptr [esi+ecx*4]
     push   ebx
     push   eax
     jmp    bound_error
 end;

procedure %sys_slice_arr_part_0; code;
const d = 12;
asm
     push eax ecx edi
     mov  eax, ind+d
     mov  ecx, dim+d
     imul eax, [esi+ecx*4+4]
     add  eax, [esi]
     stosd
     dec  ecx
     push ecx
     add  esi, 8
     rep  movsd
     pop  ecx
     add  esi, 4
     rep  movsd
     pop  edi ecx eax
     ret
end;

procedure %sys_slice_arr_part_0_checked; code;
const d = 12;
asm
     push eax ecx edi
     mov  eax, ind+d
     mov  ecx, dim+d
     cmp  eax, [esi+4]
     ja   @@err
     imul eax, [esi+ecx*4+4]
     add  eax, [esi]
     stosd
     dec  ecx
     push ecx
     add  esi, 8
     rep  movsd
     pop  ecx
     add  esi, 4
     rep  movsd
     pop  edi ecx eax
     ret
@@err:
     mov    ebx, [esp+d]
     push   0
     push   DWord ptr [esi+4]
     push   eax
     push   ebx
     jmp    bound_error
end;

procedure %sys_slice_str; code;
asm
    mov    ebx, [esp+4]
    cmp    ebx, [esi+4]
    jnb    @@err
    add    ebx, [esi]
    ret    4
@@err:
    mov    eax, [esp]
    push   0
    push   DWord ptr [esi+4]
    dec    DWord ptr [esp]
    push   ebx
    push   eax
    jmp    bound_error
end;

procedure %sys_arr_sizeof; code;
asm
    mov    eax, esize;
@@loop:
    add    esi, 4
    mov    edi, [esi]
    inc    edi
    imul   eax, edi
    dec    dim
    jne    @@loop
    ret
end;

function Copy(const S: string; Index, Len: Longint): string;
code;
      asm
        mov       edi, Result
        push      ebx
        push      ecx
        mov       ebx, [Index+8]
        cmp       ebx, 1
        jae       @@Pass1
        mov       ebx, 1
@@Pass1:
        mov       ecx, ebx
        add       ecx, [Len+8]
        dec       ecx
        mov       esi, [S+8]
        xor       eax, eax
        mov       al, [esi]
        cmp       ebx, eax
        jbe       @@Pass3
        mov       [edi],ah
        jmp       @@Exit
@@Pass3:
        cmp       [Len+8], 0
        ja        @@Pass4
        mov       [edi],ah
        jmp       @@Exit
@@Pass4:
        cmp       ecx, eax
        jbe       @@Pass2
        mov       ecx, eax
@@Pass2:
        sub       ecx, ebx
        inc       ecx
        mov       [edi], cl
        add       esi, ebx
        inc       edi
        mov       eax, ecx
        shr       ecx, 2
        ALIGN     4
        rep       movsd
        mov       ecx, eax
        and       ecx, 3
        rep       movsb
@@Exit:
        pop       ecx
        pop       ebx
        mov       eax, Result
        ret
end;

procedure Delete(var S: string; Index, Len: Longint);
code;
      asm
        mov     esi, dword ptr [S]
        mov     edi, esi
        push    ebx
        push    ecx
        mov     eax, [Index + 8]
        cmp     eax, 0
        je      @@Zero
        mov     ebx, eax
        xor     ecx, ecx
        mov     cl, [esi]
        cmp     ebx, ecx
        jbe     @@Pass1
@@Zero:
        pop     ecx
        pop     ebx
        ret
@@Pass1:
        cmp     ebx, 1
        jae     @@Pass2
        mov     ebx, 1
@@Pass2:
        add     ebx, [Len+8]
        cmp     ebx, ecx
        jbe     @@Pass3
        dec     eax
        mov     [edi], al
        pop     ecx
        pop     ebx
        ret
@@Pass3:
        sub     ecx, ebx
        inc     ecx
        push    edi
        add     edi, eax
        add     esi, ebx
        rep     movsb
        pop     edi
        mov     eax, [Len+8]
        sub     [edi], al
@@Exit: pop     ecx
        pop     ebx
        ret
end;

procedure Insert(Src: string; var Dst: string; Pos: Longint);
begin
  dst := Concat(Copy(Dst, 1, Pos-1), Src, Copy(Dst, Pos, 255));
end;

function Pos(const Sub, S: string): DWord; code;
      asm
        mov     edi, [S]
        mov     esi, [Sub]
        push    ebx
        push    ecx
        push    edx
        movzx   edx, byte ptr [esi]
        xor     edx, 0
        jz      @@Exit
        inc     esi
        movzx   ebx, byte ptr [edi]
        xor     ebx, 0
        jz      @@Exit
        cmp     edx, ebx
        jg      @@Exit
        add     ebx, edi
        sub     ebx, edx
        inc     ebx
        inc     edi
        mov     eax, edx
        dec     eax
        ALIGN   4
@@Loop: push    esi
        mov     ecx, edx
        repe    cmpsb
        pop     esi
        jz      @@Ok
        sub     ecx, eax
        sbb     edi, 0
        cmp     edi, ebx
        jbe     @@Loop
@@Exit:
        xor     eax, eax
        pop     edx
        pop     ecx
        pop     ebx
        ret
@@Ok:   mov     eax, edi
        sub     eax, [S+12]
        sub     eax, edx
        pop     edx
        pop     ecx
        pop     ebx
        ret
end;

procedure SetString(var S: string; Buffer: PChar; Len: DWORD);
begin
  Length(S) := Len;
  if (Buffer <> nil) and (Len < 256) then
    Move(Buffer^, S[1], Len);
end;

procedure SetLength(var S: String; NewLength: Integer);
begin
  Length(S) := NewLength;
end;

{$endif}