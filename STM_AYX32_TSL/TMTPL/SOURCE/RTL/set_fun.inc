(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       SET_FUN.INC for System Unit                            *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995,98 TMT Development Corporation      *)
(*       Author: Anton Moscal                                   *)
(*                                                              *)
(****************************************************************)

{$ifdef interface}

procedure %sys_set_cast (x: DWord); %builtin 26;
procedure  sys_set_den;             %builtin 27; external;
procedure  sys_set_in;              %builtin 28; external;
procedure %sys_set_include;         %builtin 29;
procedure %sys_set_exclude;         %builtin 30;
procedure  sys_set_add;             %builtin 31; external;
procedure  sys_set_sub;             %builtin 32; external;
procedure  sys_set_mul;             %builtin 33; external;
procedure  sys_set_eq;              %builtin 34; external;
procedure  sys_set_eq_0;            %builtin 35; external;
procedure  sys_set_ne;              %builtin 36; external;
procedure  sys_set_ne_0;            %builtin 37; external;
procedure %sys_set_ge;              %builtin 38;

{$l set}

{$else}
procedure %sys_set_cast; code;
asm
    push   eax
    push   ecx
    xor    eax, eax
    xor    ecx, ecx
    mov    cl, [esp+13]
    rep    stosb
    mov    cl, [esp+12]
    add    esi, ecx
    mov    cl, [esp+14]
    rep    movsb
    mov    cl, [esp+15]
    rep    stosb
    pop    ecx
    pop    eax
    ret
end;

const
  mask_i: array [0..7] of Byte =
  (
   $01, $02, $04, $08, $10, $20, $40, $80
  );

  mask_e: array [0..7] of Byte =
  (
   not $01, not $02, not $04, not $08, not $10, not $20, not $40, not $80
  );

procedure %sys_set_include; code;
asm
    push   ecx edx
    mov    cl, 8
    div    cl
    sub    al, [esp+12]
    cmp    al, [esp+13]
    jae    @@1
    xor    ecx, ecx
    mov    cl, ah
    mov    cl, byte ptr mask_i [ecx]
    xor    ah, ah
    or     byte ptr [edi+eax], cl
@@1:
    pop    edx ecx
    ret    4
end;

procedure %sys_set_exclude; code;
asm
    push   ecx edx
    mov    cl, 8
    div    cl
    sub    al, [esp+12]
    cmp    al, [esp+13]
    jae    @@1
    xor    ecx, ecx
    mov    cl, ah
    mov    cl, byte ptr mask_e [ecx]
    xor    ah, ah
    and    byte ptr [edi+eax], cl
@@1:
    pop    edx ecx
    ret    4
end;

procedure %sys_set_ge; code;
asm
    push   ecx
    xor    ecx, ecx
    mov    cl,  [esp+8]
    add    esi, ecx
    xor    eax, eax
    xor    eax, eax
    xor    eax, eax
    mov    cl,  [esp+9]
    repe   scasb
    jne    @@retf
    mov    cl, [esp+10]
    jecxz  @@next
@@loop:
    lodsb
    and    al, [edi]
    cmp    al, [edi]
    jne    @@retf
    inc    edi

    dec    ecx
    jne    @@loop
@@next:
    xor    eax, eax
    mov    cl, [esp+11]
    repe   scasb
    jne    @@retf
    inc    al
    jmp    @@ret
@@retf:
    xor    eax, eax
@@ret:
    pop    ecx
    ret    4
end;
{$endif}