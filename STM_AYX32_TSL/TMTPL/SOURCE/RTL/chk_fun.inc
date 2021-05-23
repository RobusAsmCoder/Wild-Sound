(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       CHK_FUN.INC for System Unit                            *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995,98 TMT Development Corporation      *)
(*       Author: Anton Moscal                                   *)
(*                                                              *)
(****************************************************************)

{$ifdef interface}
procedure %sys_check_proc_ref;                         %builtin 24;
procedure %sys_scope_err (ret: dword);                 %builtin 25;
procedure %sys_check_bound_uns (val, lwb, upb: dword); %builtin 20;
{$else}
procedure  sys_check_proc_err (ret: dword);
begin
  %tty('error at CS:' + hex (ret) + ': non local procedure pointer'^m^j);
  runerror(non_local_procedure_pointer);
end;

procedure %sys_scope_err;
begin
  %tty('error at CS:' + hex (ret) + ': procedure pointer out of scope'^m^j);
  runerror(procedure_pointer_out_of_scope);
end;

procedure bound_error (lwb, upb, val: dword);
begin
  %tty('Bound error at CS:????????: Bounds: ' + whl (lwb) + '..' + whl (upb) + ' Value: ' + whl (val) + ^m^j);
  runerror(range_check_error);
end;

procedure %sys_check_bound_uns; code;
asm
    push eax
    mov  eax, val[4]
    cmp  eax, lwb[4]
    jb   @@err
    cmp  eax, upb[4]
    ja   @@err
    pop  eax
    ret
@@err:
    pop  eax
    jmp  bound_error
end;

procedure %sys_check_proc_ref; code;
asm
    cmp dword ptr [esi+4], 0
    je @@ret
    call  system.sys_check_proc_err
@@ret:
    ret
end;
{$endif}