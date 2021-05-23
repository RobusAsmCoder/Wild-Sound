(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       MATH_FUN.INC for System Unit                           *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Author: Anton Moscal, Vadim Bodrov                     *)
(*                                                              *)
(****************************************************************)

{$ifdef interface}
const randseed: longint = 0;
function pi: extended;
function frac   (a: extended): extended;
function int    (a: extended): extended;
function exp    (a: extended): extended;
function arctan (a: extended): extended;
function sqrt   (a: extended): extended;

function sin    (a: extended): extended;
function cos    (a: extended): extended;
function ln     (a: extended): extended;
function odd    (a: longint): boolean;

function  frandom: extended;                  %builtin 96;
function  irandom  (range: longint): longint; %builtin 97;
procedure randomize;

procedure sys_load_real_6;  %builtin 21; external;
procedure sys_store_real_6; %builtin 22; external;
procedure sys_trunc;        %builtin 23; external;
{$else}

function pi: extended; code;
asm
  fldpi
  ret
end;

const const_delta: single  = 2147483648.0;
      const_scale: word    = word (-32);
      factor     : word    = $8405;

var dZero:   Double := 0.0;
    frac_cw: DWord  := $1F3F;
    bnd1:    Double := 1.13563496780000E+0004;
    bnd2:    Double := -1.13563496780000E+0004;

function odd; result := (a and 1) <> 0;

procedure next_rand; code;
asm
    mov  eax, randseed
    mov  edx, $8088405
    mul  edx
    inc  eax
    mov  randseed, eax
    ret
end;

function irandom; code;
asm
    mov   edi, edx
    call  next_rand
    mul   range
    mov   eax, edx
    mov   edx, edi
    ret
end;

procedure frandom; assembler;
asm
    call  next_rand
    fild  const_scale
    fild  randseed
    fadd  const_delta
    fscale
    fstp  st(1)
    fwait
end;

procedure randomize; randseed := getclock;

function Sqrt; code;
asm
    fld     tbyte ptr [esp+4]
    fcom    [dZero]
    fstsw   ax
    sahf
    jb      @@err
    fsqrt
    fwait
    ret     12
@@err:
    int     4
end;

function Ln; code;
asm
    fld     tbyte ptr [esp + 4]
    mov     al,0Ah
    ftst
    fstsw   ax
    wait
    sahf
    jbe     @@err
    cmp     al,0Bh
    jne     @@1
    fldlg2
    jmp     @@3
@@1:
    cmp     al,09h
    jne     @@2
    fld1
    jmp     @@3
@@2:
    fldln2
@@3:
    fxch    st(1)
    fyl2x
    ret     12
@@err:
    int     4
end;

function Sin; code;
asm
    fld     tbyte ptr [esp+4]
    fsin
    dw      $E0DF
    sahf
    jp      @@error
    ret     12
@@error:
    fstp    st(0)
    fldz
    ret     12
end;

function Cos; code;
asm
    fld     tbyte ptr [esp+4]
    fcos
    dw      $E0DF
    sahf
    jp      @@error
    ret     12
@@error:
    fstp    st(0)
    fldz
    ret     12
end;

function ArcTan; code;
asm
    fld     tbyte ptr [esp+4]
    fld1
    fpatan
    ret     12
end;

function Frac; code;
asm
    fld  tbyte ptr [esp+4]
    sub   esp, 4
    fstcw word ptr [esp]
    fldcw word ptr [frac_cw]
    fld   st(0)
    frndint
    fsubp st(1), st
    fwait
    fldcw word ptr [esp]
    add   esp, 4
    ret   12
end;

function Int; code;
asm
    fld  tbyte ptr [esp+4]
    sub   esp, 4
    fstcw word ptr [esp]
    fldcw word ptr [frac_cw]
    frndint
    fwait
    fldcw word ptr [esp]
    add   esp, 4
    ret   12
end;

function Exp; code;
asm
    fld  tbyte ptr [esp+4]
    fcom  qword ptr [bnd1]
    fstsw ax
    wait
    sahf
    jbe   @@1
    int   4
@@1:
    fcom  qword ptr [bnd2]
    fstsw ax
    wait
    sahf
    ja    @@2
    fldz
    jmp   @@3
@@2:
    fldl2e
    fmulp st (1), st
    fld   st (0)
    frndint
    fxch  st (1)
    fsub  st, st (1)
    f2xm1
    fld1
    faddp st (1), st
    fscale
@@3:
    fstp  st (1)
    wait
    ret   12
end;
{$endif}
