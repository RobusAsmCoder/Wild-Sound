.386
.model flat
locals
.data

.code
    global sys_load_real_6: proc
    global sys_store_real_6: proc

sys_load_real_6:
    push eax
    mov  eax, [esi]
    push 0
    push 0
    mov  dword ptr [esp+2], eax
    mov  ax, word ptr [esi+4]
    mov  word ptr [esp+6], ax
    fld  qword ptr [esp]
    fwait
    add  esp, 8
    pop  eax
    ret

sys_store_real_6:
    push eax
    sub  esp, 8
    fstp qword ptr [esp]
    fwait
    mov  eax, dword ptr [esp+2]
    mov  [edi], eax
    mov  eax, dword ptr [esp+6]
    mov  word ptr [edi+4], ax
    add  esp, 8
    pop  eax
    ret

.const

fpu_cw        dw 1372h ;1332h
fpu_cw_trunc  dw 1F3Fh

.data

save_cw   dw ?

.code
    global sys_trunc:proc

sys_trunc:
    fstcw save_cw
;    fwait
    fldcw fpu_cw_trunc
    fistp dword ptr [edi]
    fwait
    fldcw save_cw
    ret

end
