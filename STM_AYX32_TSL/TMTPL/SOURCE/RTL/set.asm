.386
.model flat
locals

.code
    global sys_set_den:proc

sys_set_den:
    pop    @@ret
    mov    @@eax, eax
    mov    @@ebx, ebx
    mov    @@ecx, ecx
    mov    @@edx, edx
    pop    esi; база
    rept   8
      movsd
    endm
    sub    edi, 32
    xor    ebx, ebx
    pop    ecx
    jecxz   @@nextr
@@loopr:
    pop    edx
    movzx  edx, dl
@@looprr:
    cmp    dl, [esp]
    ja     @@nextrr
    mov    eax, edx
    mov    bl, 8
    div    bl
    mov    bl, ah
    mov    ah, mask_i [ebx]
    mov    bl, al
    or     [edi+ebx], ah
    inc    edx
    jmp    @@looprr
@@nextrr:
    pop    eax
    loop   @@loopr
@@nextr:
    pop    ecx
    jecxz   @@nexts
@@loops:
    pop    eax
    movzx  eax, al
    mov    bl, 8
    div    bl
    mov    bl, ah
    mov    ah, mask_i [ebx]
    mov    bl, al
    or     [edi+ebx], ah
    loop   @@loops
@@nexts:
    mov    edx, @@edx
    mov    ecx, @@ecx
    mov    ebx, @@ebx
    mov    eax, @@eax
    jmp    dword ptr @@ret

.data

@@eax  dd  0
@@ebx  dd  0
@@ecx  dd  0
@@edx  dd  0
@@ret  dd  0

.code

    global sys_set_in:proc

sys_set_in:
@@s_l    equ   byte ptr [esp+16]
@@s_l8   equ   byte ptr [esp+17]
@@s_len  equ   byte ptr [esp+18]
    push   ebx ecx edx
    mov    ebx, eax
    xor    ecx, ecx
    mov    cl, @@s_l
    sub    ebx, ecx
    mov    cl, @@s_len
    cmp    ebx, ecx
    ja     @@false
    mov    cl, @@s_l8
    add    ebx, ecx
    mov    cl, 8
    mov    eax, ebx
    xor    ebx, ebx
    div    cl
    mov    cl, ah
    mov    ah, mask_i [ecx]
    mov    cl, al
    test   ah, [esi+ecx]
    setne  al
@@ret:
    pop    edx ecx ebx
    ret    4
@@false:
    xor    eax, eax
    jmp    @@ret

.data

mask_i  db  01h, 02h, 04h, 08h, 10h, 20h, 40h, 80h

.code

    global sys_set_add:proc
    global sys_set_sub:proc
    global sys_set_mul:proc

    ; edi - dst (set of 0..255)
    ; esi - a
    ; [stk] - b

sys_set_add:
@@b      equ  dword ptr [esp+24]

@@a_lwb_32  equ  byte  ptr [esp+20]
@@a_len     equ  byte  ptr [esp+21]
@@ab_dif    equ  byte  ptr [esp+22]
@@b_len     equ  byte  ptr [esp+23]

    push  eax ecx esi edi
    xor   eax, eax
    rept  8
    stosd
    endm
    xor   ecx, ecx
    mov   cl, @@a_lwb_32 ; 32 - a_lwb
    sub   edi, ecx
    mov   cl, @@a_len
    rep   movsb
    mov   cl, @@ab_dif ; a_upb - b_lwb + 1
    sub   edi, ecx
    mov   esi, @@b
    mov   cl, @@b_len
@@loop:
    mov   al, [esi+ecx-1]
    or    [edi+ecx], al
    loop  @@loop
    pop   edi esi ecx eax
    ret   8

sys_set_sub:
@@b  equ  dword ptr [esp+24]

@@a_lwb_32  equ  byte  ptr [esp+20]
@@a_len     equ  byte  ptr [esp+21]
@@ab_dif    equ  byte  ptr [esp+22]
@@b_len     equ  byte  ptr [esp+23]

    push  eax ecx esi edi
    xor   eax, eax
    rept  8
    stosd
    endm
    xor   ecx, ecx
    mov   cl, @@a_lwb_32 ; 32 - a_lwb
    sub   edi, ecx
    mov   cl, @@a_len
    rep   movsb
    mov   cl, @@ab_dif ; a_upb - b_lwb + 1
    sub   edi, ecx
    mov   esi, @@b
    mov   cl, @@b_len
@@loop:
    mov   al, [esi+ecx-1]
    not   al
    and   [edi+ecx], al
    loop  @@loop
    pop   edi esi ecx eax
    ret   8

sys_set_mul:
@@b equ   dword ptr [esp+24]

@@a_lwb_32  equ  byte  ptr [esp+20]
@@a_len     equ  byte  ptr [esp+21]
@@ab_dif    equ  byte  ptr [esp+22]
@@b_len     equ  byte  ptr [esp+23]

    push  eax ecx esi edi
    xor   eax, eax
    rept  8
    stosd
    endm
    xor   ecx, ecx
    mov   cl, @@a_lwb_32 ; 32 - a_lwb
    sub   edi, ecx
    mov   cl, @@a_len
    rep   movsb
    mov   cl, @@ab_dif ; a_upb - b_lwb + 1
    sub   edi, ecx
    mov   esi, @@b
    mov   cl, @@b_len
@@loop:
    mov   al, [esi+ecx-1]
    and   [edi+ecx], al
    loop  @@loop
    pop   edi esi ecx eax
    ret   8

    global sys_set_eq  :proc
    global sys_set_ne  :proc
    global sys_set_eq_0:proc
    global sys_set_ne_0:proc
    global sys_set_ge  :proc

sys_set_eq:

@@a_l  equ  byte  ptr [esp+ 8]
@@len  equ  byte  ptr [esp+ 9]
@@a_u  equ  byte  ptr [esp+10]
@@b_u  equ  byte  ptr [esp+11]

    push  ecx
    xor   ecx, ecx
    xor   eax, eax
    mov   cl, @@a_l
    repe  scasb
    jne   @@retf
    mov   cl, @@len
    repe  cmpsb
    jne   @@retf
    mov   cl, @@a_u
    or    ecx, ecx
    jne   @@1
    mov   cl, @@b_u
    mov   edi, esi
@@1:
    repe  scasb
    jne   @@retf
    inc   al
@@retf:
    pop   ecx
    ret   4

sys_set_eq_0:

@@a_len  equ  byte  ptr [esp+ 8]
@@b_len  equ  byte  ptr [esp+ 9]

    push  ecx
    xor   ecx, ecx
    xor   eax, eax
    mov   cl, @@a_len
    repe  scasb
    jne   @@retf
    mov   cl, @@b_len
    mov   edi, esi
    repe  scasb
    jne   @@retf
    inc   al
@@retf:
    pop   ecx
    ret   4

sys_set_ne:

@@a_l  equ  byte  ptr [esp+ 8]
@@len  equ  byte  ptr [esp+ 9]
@@a_u  equ  byte  ptr [esp+10]
@@b_u  equ  byte  ptr [esp+11]

    push  ecx
    xor   ecx, ecx
    xor   eax, eax
    mov   cl, @@a_l
    repe  scasb
    jne   @@retf
    mov   cl, @@len
    repe  cmpsb
    jne   @@retf
    mov   cl, @@a_u
    or    ecx, ecx
    jne   @@3
    mov   cl, @@b_u
    mov   edi, esi
@@3:
    repe  scasb
    jne   @@retf
    inc   al
@@retf:
    xor   al, 1
    pop   ecx
    ret   4

sys_set_ne_0:

@@a_len  equ  byte  ptr [esp+ 8]
@@b_len  equ  byte  ptr [esp+ 9]

    push  ecx
    xor   ecx, ecx
    xor   eax, eax
    mov   cl, @@a_len
    repe  scasb
    jne   @@retf
    mov   cl, @@b_len
    mov   edi, esi
    repe  scasb
    jne   @@retf
    inc   al
@@retf:
    xor   al, 1
    pop   ecx
    ret   4

end
