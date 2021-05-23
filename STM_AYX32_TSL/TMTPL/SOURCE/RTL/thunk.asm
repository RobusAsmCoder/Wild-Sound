.386
.model flat
.code

global SEL_TO_FLAT:proc
global dosseltoflat:proc

SEL_TO_FLAT:
      mov    eax, 4[esp]
      push   ebx ecx edx
      call   dosseltoflat
      pop    edx ecx ebx
      ret 4

      global FLAT_TO_SEL:proc
      global dosflattosel:proc

FLAT_TO_SEL:
      mov    eax, 4[esp]
      push   ebx ecx edx
      call   dosflattosel
      pop    edx ecx ebx
      ret    4

      global THUNK: proc

THUNK:
        push    ds
        push    es
        push    ebp
        push    ebx
        push    ecx
        push    edx
        push    esi
        push    edi
        mov     ebp,esp
        mov     edx,+1cH[esp+8]
        mov     eax,+20H[esp+8]
        lea     esi,+24H[esp+8]
        mov     ebx,edx
        test    edx,edx
        je      L2
L1:     add     esi,00000004H
        shr     edx,02H
        jne     L1
L2:     cmp     sp,1000H
        jae     L3
        xor     sp,sp
L3:     push    eax
        mov     edi,esp
        push    ebp
        push    esi
        mov     eax,esp
        push    ss
        push    eax
        mov     ebp, esp

L4:     mov     ecx,ebx
        and     ecx,00000003H
        je      L9
        shr     ebx,02H
        sub     esi,00000004H
        mov     eax,[esi]
        cmp     ecx,00000001H
        je      L01
        call    dosflattosel
        push    eax
        jmp     L4
L01:    push    ax
        jmp     L4
L9:     mov     eax, offset L11
        call    dosflattosel
        mov     @@l_ofs, ax
        shr     eax, 16
        mov     @@l_seg, ax

        mov     eax,esp
        call    dosflattosel
        push    eax
        lss     sp,dword ptr [esp]
        jmp     jmp_32_16
.data

jmp_32_16:
        db      0EAH
@@l_ofs dw      0,0
@@l_seg dw      0

.code

L11:
        mov     eax,ss
        mov     ds,eax
        mov     es,eax
        db      0FFH, 1DH    ; call dword ptr [di]
        db      066H, 0EAH
        dd      offset L10
        dw      05Bh

L10:    and     esp,0000FFFFH
        lss     esp,pword ptr [esp]
        shl     eax,10H
        shrd    eax,edx,10H
        pop     ebx
        pop     esp
        pop     edi
        pop     esi
        pop     edx
        pop     ecx
        pop     ebx
        pop     ebp
        pop     es
        pop     ds
        pop     edi
        Add     esp,08H
        jmp     edi
end
