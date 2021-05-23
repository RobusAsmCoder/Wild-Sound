(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       MEM_FUN.INC for System Unit                            *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995,99 TMT Development Corporation      *)
(*       Author: Anton Moscal, Vadim Bodrov                     *)
(*                                                              *)
(****************************************************************)

{$ifdef interface}

function Hi(n: Longint): Byte;
function Lo(n: Longint): Byte;

function HiByte(w: DWord): Byte;
function LoByte(w: DWord): Byte;

function HiWord(n: Longint): Word;
function LoWord(n: Longint): Word;

procedure Move(const Src; var Dst; Cnt: DWord);
function  CompareMem(p1, p2: Pointer; Length: Longint): Boolean;

function  sel_to_flat(p: Pointer): Pointer; external;
function  flat_to_sel(p: Pointer): Pointer; external;
{$l thunk}
procedure %sys_thunk;   %builtin 79; external 'THUNK';
procedure dosflattosel; external 'DOSCALLS' index 425;
procedure dosseltoflat; external 'DOSCALLS' index 426;

{$else}
function Hi; code;
      asm
        mov     al, byte ptr [n+1]
        ret
end;

function Lo; code;
      asm
        mov     al, byte ptr [n]
        ret
end;

function HiWord; code;
      asm
        mov     eax, [n]
        shr     eax, 16
        and     eax, $FFFF
        ret
end;

function LoWord; code;
      asm
        mov     eax, [n]
        and     eax, $FFFF
        ret
end;

function HiByte(w: DWord): Byte; code;
      asm
        mov     eax, [w]
        shr     eax, 8
        and     eax, $FF
        ret
end;

function LoByte(w: DWord): Byte; code;
      asm
        mov     eax, [w]
        and     eax, $FF
        ret
end;

procedure Move; code;
      asm
        push    ecx
        mov     esi, [src+4]
        mov     edi, [dst+4]
        mov     ecx, [cnt+4]
        mov     eax, edi
        sub     eax, esi
        cmp     eax, ecx
        jae     @@1
        add     esi, ecx
        add     edi, ecx
        dec     esi
        dec     edi
        std
        rep     movsb
        cld
        jmp     @@4
@@1:
        cld
        mov     eax, ecx
        shr     ecx, 2
        ALIGN   4
        rep     movsd
        mov     ecx, eax
        and     ecx, 3
        rep     movsb
@@4:
        pop     ecx
        ret
end;

function CompareMem(p1, p2: Pointer; Length: Longint): Boolean; code;
asm
        push    ecx
        push    edx
        mov     esi, [p1 + 8]
        mov     edi, [p2 + 8]
        mov     ecx, [Length + 8]
        mov     edx, ecx
        shr     ecx, 2
        and     edx, 3
        xor     eax, eax
        cld
        repe    cmpsd
        jne     @@2
        mov     ecx, edx
        repe    cmpsb
        jne     @@2
@@1:    inc     eax
@@2:    pop     edx
        pop     ecx
        ret
end;


procedure sys_new_obj; code;
      asm
        pop     ebx                  // ret_addr
        mov     eax, [ebx]           // vmt
        push    dword ptr [eax]      // size
        call    system.sys_new_ptr
        pop     esi                  // vmt_offs
        mov     ecx,[ebx]
        mov     [eax+esi], ecx
        mov     ecx, eax             // save address of object
        call    dword ptr [ebx+4]    // call constructor
        test    al, al
        mov     eax, ecx
        jne     @@1
        push    eax
        mov     eax, [eax]
        push    dword ptr [eax]
        call    system.freemem
        xor     eax, eax
@@1:
        add     ebx, 8
        jmp     ebx
 end;


procedure sys_new_obj_0; code;
      asm
        pop     ebx                  // ret_addr
        mov     eax, dword ptr [ebx]
        push    dword ptr [eax]      // size
        call    system.sys_new_ptr
        mov     ecx, [ebx]
        mov     [eax], ecx
        mov     ecx, eax             // save address of object
        call    dword ptr [ebx+4]    // call constructor
        test    al, al
        mov     eax, ecx
        jne     @@1
        push    eax
        mov     ecx, esp
        push    ecx
        mov     eax, [eax]
        push    dword ptr [eax]
        call    system.freemem
        add     esp, 4
        xor     eax, eax
@@1:
        add     ebx, 8
        jmp     ebx
end;

procedure sys_dispose_ptr; code;
      asm
        lea     eax, [esp+4]
        push    eax
        push    eax
        call    system.freemem
        ret     4
end;

{$endif}