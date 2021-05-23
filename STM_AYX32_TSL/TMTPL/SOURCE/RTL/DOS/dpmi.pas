(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       DPMI Interface Unit                                    *)
(*       Target: MS-DOS only                                    *)
(*                                                              *)
(*       Copyright (c) 1995,98 TMT Development Corporation      *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$r-,q-,i-,t-,x+,v-}

unit DPMI;

interface

type
 TRmRegs = record
  case Integer of
   1:  (edi, esi, ebp, _res, ebx, edx, ecx, eax: Longint;
        flags, es, ds, fs, gs, ip, cs, sp, ss: Word);
   2: (_dmy2: array [0..15] of byte; bl, bh, b1, b2, dl, dh, d1, d2, cl, ch, c1, c2, al, ah: Byte);
   3: (di, i1, si, i2, bp, i3, i4, i5, bx, b3, dx, d3, cx, c3, ax: Word);
  end;

type
 TDescriptor = record
  SegmentLimit: Word;
  BaseAddressL: Word;
  BaseAddressH: Byte;
  FlagsL:       Byte;
  FlagsH:       Byte;
  BaseAddressU: Byte;
end;

//////////////////////////
// ADDITIONAL FUNCTIONS //
//////////////////////////
procedure ClearRmRegs(var Regs: TRmRegs);
procedure FarPutByte(Seg: Word; Offs: DWord; Value: Byte);
procedure FarPutWord(Seg: Word; Offs: DWord; Value: Word);
procedure FarPutDWord(Seg: Word; Offs: DWord; Value: DWord);
function  FarGetByte(Seg: Word; Offs: DWord): Byte;
function  FarGetWord(Seg: Word; Offs: DWord): Word;
function  FarGetDWord(Seg: Word; Offs: DWord): DWord;
function  GetCS: Word;
function  GetDS: Word;

////////////////////////////////
// DPMI INTERRUPT 31H SERVICE //
////////////////////////////////
function AllocateDescriptors(NumberOfDescriptors: Word): Word;
function CreateDataDescriptor(Base, Limit: DWord): Word;
function CreateCodeDescriptor(Base, Limit: DWord): Word;
function FreeDescriptor(Selector: Word): Boolean;
function SegmentToDescriptor(Segment: Word): Word;
function SelectorInc: Word;
function GetSegmentBaseAddress(Selsctor: Word): DWord;
function SetSelectorBaseAddress(Selector: Word; Base: DWord): Boolean;
function SetSelectorLimit(Selector: Word; Limit: DWord): Word;
function GetSelectorAccessRights(Selector: Word): Word;
function SetSelectorAccessRights(Selector,Rights: Word): Boolean;
function CreateCodeAlias(Selector: Word): Word;
function CreateDataAlias(Selector: Word): Word;
function GetDescriptor(Selector: Word; var Descriptor: TDescriptor): Boolean;
function SetDescriptor(Selector: Word; var Descriptor: TDescriptor): Boolean;
function AllocateSpecificDescriptor(Selector: Word): Boolean;
function AllocDOSmemoryBlock(SizeInBytes: DWord): DWord;
function FreeDOSMemoryBlock(Selector: Word): Boolean;
function DOSMemoryAlloc(SizeInBytes: DWord): Word;
function DOSMemoryFree(Segment: Word): Boolean;
function ResizeDOSmemoryBlock(Selector: Word; NewSize: DWord): Boolean;
function GetRealModeIntVec(IntNo: Byte; var RSeg,ROfs: Word): Boolean;
function SetRealModeIntVec(IntNo: Byte; RSeg,ROfs: Word): Boolean;
function GetExceptionHandler(ExpFault: Byte; var Sel: Word; var Offs: DWord): Boolean;
function SetExceptionHandler(ExpFault: Byte; Sel: Word; Offs: DWord): Boolean;
function GetDPMIIntVec(IntNo: Byte; var Sel: Word; var Offs: DWord): Boolean;
function SetDPMIIntVec(IntNo: Byte; Sel: Word; Offs: DWord): Boolean;
function RealModeInt(IntNo: Byte; var Regs: TRmRegs): Boolean;
function CallRealModeFar(var Regs: TRmRegs): Boolean;
function CallRealModeIRet(var Regs: TRmRegs): Boolean;
function AllocRealModeCallBack(HandlerAddr, RegsAddr: Pointer; var HndSeg: Word; var HndOfs: DWord): Boolean;
function FreeRealModeCallBack(HndSeg: Word; HndOfs: DWord): Boolean;
function GetDPMIVer: Word;
function GetFreeMemoryInfo(BufferPtr: Pointer): Boolean;
function MapPhysicalToLinear(PhysAddr, SizeInBytes: DWord): DWord;
function FreePhysicalMap(LinearAddr: DWord): Boolean;
function GetDisableInterruptState: Boolean;
function GetEnableInterruptState: Boolean;
function GetInterruptState: Boolean;

implementation

procedure SetDescriptorBaseAddress(var Descr: TDescriptor; Base: DWord);
begin
 with Descr do begin
  BaseAddressL:=Word(Base);
  BaseAddressH:=Byte(Base shr 16);
  BaseAddressU:=Byte(Base shr 24);
 end;
end;

procedure SetDescriptorLimit(var Descr: TDescriptor; Limit: DWord);
begin
 with Descr do begin
   if Limit>0 then Dec(Limit);
   if Limit>=$100000 then begin
     Limit:=Limit shr 12;
     FlagsH:=FlagsH or $80;
   end;
   SegmentLimit:=Word(Limit);
   FlagsH:=FlagsH or Byte(Limit shr 16);
 end;
end;

procedure ClearRmRegs(var Regs: TRmRegs); assembler;
      asm
        mov     edi,[Regs]
        mov     ecx,12
        xor     eax,eax
        rep     stosd
        stosw
end;

function FarGetByte(Seg: Word; Offs: DWord): Byte; code;
      asm
        mov     gs,word ptr [Seg]
        mov     edi,dword ptr [Offs]
        mov     al,gs:[edi]
        ret
end;

function FarGetWord(Seg: Word; Offs: DWord): Word; code;
      asm
        mov     gs,word ptr [Seg]
        mov     edi,dword ptr [Offs]
        mov     ax,gs:[edi]
        ret
end;

function FarGetDWord(Seg: Word; Offs: DWord): DWord; code;
      asm
        mov     gs,word ptr [Seg]
        mov     edi,dword ptr [Offs]
        mov     eax,gs:[edi]
        ret
end;

procedure FarPutByte(Seg: Word; Offs: DWord; Value: Byte); code;
      asm
        mov     gs,[Seg]
        mov     edi,[Offs]
        mov     al,[Value]
        mov     gs:[edi],al
        ret
end;

procedure FarPutWord(Seg: Word; Offs: DWord; Value: Word); code;
      asm
        mov     gs,[Seg]
        mov     edi,[Offs]
        mov     ax,[Value]
        mov     gs:[edi],ax
        ret
end;

procedure FarPutDWord(Seg: Word; Offs: DWord; Value: DWord); code;
      asm
        mov     gs,[Seg]
        mov     edi,[Offs]
        mov     eax,[Value]
        mov     gs:[edi],eax
        ret
end;

function  GetCS: Word; code;
      asm
        mov     ax,cs
        ret
end;

function  GetDS: Word; code;
      asm
        mov     ax,ds
        ret
end;

//////////////////////////////////////////////////////////////////
// This  function   is  used   to  allocate  one  or  more
// descriptors from  the  task's  Local  Descriptor  Table
// (LDT).  The descriptor(s) allocated must be initialized
// by the application.
//
// Entry: NumberOfDescriptors - Number of descriptors to allocate
// Exit:  if successful: Base selector (use SelctorInc to asscss to
//                       next selector)
//        if failed    : Zero
//////////////////////////////////////////////////////////////////
function AllocateDescriptors(NumberOfDescriptors: Word): Word; assembler;
      asm
        mov     eax,0000h
        mov     cx,[NumberOfDescriptors]
        int     31h
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This  function   is  used   to  allocate  one  data
// descriptor from  the  task's  Local  Descriptor  Table
// (LDT) with specified Base and Limit
//
// Entry: Base - Specified Base
//        Limit - Specified limit
// Exit:  if successful: Data Selector
//        if failed    : Zero
//////////////////////////////////////////////////////////////////
function CreateDataDescriptor(Base, Limit: DWord): Word;
var
 Selector: Word;
 Descr: TDescriptor;
begin
 Selector:=AllocateDescriptors(1);
 if Selector>0 then begin
  if GetDescriptor(Selector, Descr) then begin
   SetDescriptorBaseAddress(Descr,Base);
   SetDescriptorLimit(Descr,Limit);
   if not SetDescriptor(Selector, Descr) then Selector:=0;
  end else Selector:=0;
 end;
 Result:=Selector;
end;

//////////////////////////////////////////////////////////////////
// This  function   is  used   to  allocate  one  code
// descriptor from  the  task's  Local  Descriptor  Table
// (LDT) with specified Base and Limit
//
// Entry: Base - Specified Base
//        Limit - Specified limit
// Exit:  if successful: Code Selector
//        if failed    : Zero
//////////////////////////////////////////////////////////////////
function CreateCodeDescriptor(Base, Limit: DWord): Word;
var
 Selector: Word;
 Descr: TDescriptor;
begin
 Selector:=AllocateDescriptors(1);
 if Selector>0 then begin
  if GetDescriptor(Selector,Descr) then begin
   SetDescriptorBaseAddress(Descr,Base);
   SetDescriptorLimit(Descr,Limit);
   Descr.FlagsL:=(Descr.FlagsL and $FB) or $0A;
   if not SetDescriptor(Selector,Descr) then Selector:=0;
  end else Selector:=0;
 end;
 Result:=Selector;
end;

//////////////////////////////////////////////////////////////////
// This function  is used  to free  descriptors that  were
// allocated  through   the   Allocate   LDT   Descriptors
// function.
//
// Entry: Selector - selector to free
// Exit : if successful: TRUE
//        if failed    : FALSE
//////////////////////////////////////////////////////////////////
function FreeDescriptor(Selector: Word): Boolean; assembler;
      asm
        mov     eax,0001h
        mov     bx,[Selector]
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  is used  to convert  real mode  segments
// into descriptors that are addressable by protected mode
// programs.
//
// Entry: Segment - Real mode segment address
// Exit : if successful: Selector mapped to real mode segment
//        if failed    : Zero
//////////////////////////////////////////////////////////////////
function SegmentToDescriptor(Segment: Word): Word; assembler;
      asm
        mov     eax,0002h
        mov     bx,[Segment]
        int     31h
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// Some functions  such as  allocate LDT  descriptors  and
// allocate  DOS   memory  can   return  more   than   one
// descriptor.   You must  call this function to determine
// the value  that must  be added  to a selector to access
// the next descriptor in the array.
//
// Entry: None
// Exit : if successful: Value to add to get to next selector
//        if failed    : Zero
//////////////////////////////////////////////////////////////////
function SelectorInc: Word; assembler;
      asm
        mov     eax,0003h
        int     31h
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function returns the 32-bit linear base address of
// the specified segment.
//
// Entry: Selector - Defined selector
// Exit : if successful: 32-bit linear base address of segment
//        if failed    : Zero
//////////////////////////////////////////////////////////////////
function GetSegmentBaseAddress(Selsctor: Word): DWord; assembler;
      asm
        mov     eax,0006h
        int     31h
        jnc     @@SS
        xor     eax,eax
        jmp     @@Quit
@@SS:   mov     eax,ecx
        shl     eax,16
        mov     ax,dx
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function changes the 32-bit linear base address of
// the specified selector.
//
// Entry: Selector - Defined selector
//        Base     - 32-bit linear base address for segment
// Exit : if successful: TRUE
//        if failed    : FALSE
//////////////////////////////////////////////////////////////////
function SetSelectorBaseAddress(Selector: Word; Base: DWord): Boolean;
 assembler;
      asm
        mov     eax,0007h
        mov     bx,[Selector]
        mov     dx,word ptr [Base]
        mov     cx,word ptr [Base+2]
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function sets the limit for the specified segment.
//
// Entry: Selector - Defined selector
//        Limit    - 32-bit segment limit
// Exit : if successful: Segment
//        if failed    : Zero
//////////////////////////////////////////////////////////////////
function SetSelectorLimit(Selector: Word; Limit: DWord): Word; assembler;
      asm
        mov     eax,0008h
        mov     bx,[Selector]
        mov     dx,word ptr [Limit]
        mov     cx,word ptr [Limit+2]
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function returns access rights and type fields of a
// descriptor.
//
// Entry: Selector - Defined selector
//        Rights   - 80386 access rights/type word
// Exit : if successful: Access rights
//        if failed:     Zero
//////////////////////////////////////////////////////////////////
function GetSelectorAccessRights(Selector: Word): Word;
var Descr: TDescriptor;
begin
 if GetDescriptor(Selector,Descr) then
  GetSelectorAccessRights:=(Word(Descr.FlagsH) shl 8) or Descr.FlagsL
 else GetSelectorAccessRights:=0;
end;

//////////////////////////////////////////////////////////////////
// This function allows a protected mode program to modify
// the access rights and type fields of a descriptor.
//
// Entry: Selector - Defined selector
//        Rights   - 80386 access rights/type word
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function SetSelectorAccessRights(Selector, Rights: Word): Boolean; assembler;
      asm
        mov     eax,0009h
        mov     bx,[Selector]
        mov     cx,[Rights]
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  will create  a code  descriptor that has
// the same  base and  limit as the specified code segment
// descriptor.
//
// Entry: Selector - Data segment selector
// Exit : if successful: Alias selector
//        if failed:     Zero
//////////////////////////////////////////////////////////////////
function CreateCodeAlias(Selector: Word): Word;
var Descr: TDescriptor;
    CSelector: Word;
begin
 CSelector:=AllocateDescriptors(1);
 if CSelector<>0 then begin
  GetDescriptor(Selector,Descr);
  Descr.FlagsL:=(Descr.FlagsL and $F0) or $0B;
  SetDescriptor(CSelector,Descr);
 end;
 CreateCodeAlias:=CSelector;
end;

//////////////////////////////////////////////////////////////////
// This function  will create  a code  descriptor that has
// the same  base and  limit as the specified code segment
// descriptor.
//
// Entry: Selector - Data segment selector
// Exit : if successful: Alias selector
//        if failed:     Zero
//////////////////////////////////////////////////////////////////
function CreateDataAlias(Selector: Word): Word;
var Descr: TDescriptor;
    DSelector: Word;
begin
 DSelector:=AllocateDescriptors(1);
 if DSelector<>0 then begin
  GetDescriptor(Selector,Descr);
  Descr.FlagsL:=(Descr.FlagsL and $F0) or $03;
  SetDescriptor(DSelector,Descr);
 end;
 CreateDataAlias:=DSelector;
end;

//////////////////////////////////////////////////////////////////
// This function  copies the  descriptor table entry for a
// specified descriptor into an eight byte buffer.
//
// Entry: Selector   - Defined selector
//        Descriptor - Pointer to an 8 byte buffer to receive copy
//                     of descriptor
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function GetDescriptor(Selector: Word; var Descriptor: TDescriptor): Boolean;
 assembler;
      asm
        mov     eax,000Bh
        mov     bx,[Selector]
        mov     edi,[Descriptor]
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  copies an eight byte buffer into the LDT
// entry for a specified descriptor.
//
// Entry: Selector   - Defined selector
//        Descriptor - Pointer to  an 8 byte  buffer that contains
//                     descriptor
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function SetDescriptor(Selector: Word; var Descriptor: TDescriptor): Boolean;
 assembler;
      asm
        mov     eax,000Ch
        mov     bx,[Selector]
        mov     edi,[Descriptor]
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This  function   is  used   to  allocate  one  specific
// LTD descriptor.
//
// Entry: Selector - Selector to allocate
// Exit:  if successful: TRUE
//        if failed    : FALSE
//////////////////////////////////////////////////////////////////
function AllocateSpecificDescriptor(Selector: Word): Boolean; assembler;
      asm
        mov     eax,000Dh
        mov     bx,[Selector]
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  will allocate a block of memory from the
// DOS free  memory pool.   It  returns both the real mode
// segment and one or more descriptors that can be used by
// protected mode applications to access the block.
//
// Entry: SizeInBytes - Number of bytes desired
// Exit : if successful: Paragraph-segment value in its high-order
//                       word and a selector in its low-order word
//        if failed:     Zero
//////////////////////////////////////////////////////////////////
function AllocDOSmemoryBlock(SizeInBytes: DWord): DWord; assembler;
      asm
        mov     eax,0100h
        mov     ebx,[SizeInBytes]
        add     ebx,0Fh
        shr     ebx,4
        int     31h
        jnc     @@SS
        xor     eax,eax
        jmp     @@Quit
@@SS:   shl     eax,16      // AX = Real Mode Segment (EXIT: HIWord)
        mov     ax,dx       // DX = DPMI Selector     (EXIT: LoWord)
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  frees memory  that was allocated through
// the AllocateDOSMemoryBlock function.
//
// Entry: Selector - Selector of block to free
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////-
function FreeDOSMemoryBlock(Selector: Word): Boolean; assembler;
      asm
        mov     eax,0101h
        mov     dx,[Selector]
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  will allocate a block of memory from the
// DOS free  memory pool.  It  returns real mode only
// segment of alloceted DOS memory block.
//
// Entry: SizeInBytes -  Number of bytes desired
// Exit : if successful: Paragraph-segment value
//        if failed:     Zero
//////////////////////////////////////////////////////////////////
function DOSMemoryAlloc(SizeInBytes: DWord): Word;
var Regs: TRmRegs;
begin
 ClearRmRegs(Regs);
 Regs.AH:=$48;
 Regs.BX:=(SizeInBytes+$0F) shr 4;
 RealModeInt($21,Regs);
 if (Regs.Flags and 1)=1 then Result:=0 else Result:=Regs.AX;
end;

//////////////////////////////////////////////////////////////////
// This function  frees memory  that was allocated through
// the DOSMemoryAlloc function.
//
// Entry: Segment - Real mode segment of block to free
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function DOSMemoryFree(Segment: Word): Boolean;
var Regs: TRmRegs;
begin
 ClearRmRegs(Regs);
 Regs.AH:=$49;
 Regs.ES:=Segment;
 RealModeInt($21,Regs);
 Result:=Boolean(Regs.Flags xor 1);
end;

//////////////////////////////////////////////////////////////////
// This function  is used to grow or shrink a memory block
// that was  allocated through  the  AllocateDOSmemoryBlock
// function.
//
// Entry: NewSize - New block size in bytes
//        Selector - Selector of block to modify
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function ResizeDOSmemoryBlock(Selector: Word; NewSize: DWord): Boolean; assembler;
      asm
        mov     eax,0102h
        mov     ebx,[NewSize]
        add     ebx,0Fh
        shr     ebx,4
        mov     dx,[Selector]
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  returns the  value of the current task's
// real mode interrupt vector for the specified interrupt.
//
// Entry: IntNo - Interrupt number
// Exit : if successful: TRUE
//           RSeg - Segment of real mode interrupt handler
//           ROfs - Offset of real mode interrupt handler
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function GetRealModeIntVec(IntNo: Byte; var RSeg,ROfs: Word): Boolean; assembler;
  asm
        mov     eax,0200h
        mov     bl,[IntNo]
        int     31h
        mov     edi,[RSeg]
        mov     [edi],cx
        mov     edi,[ROfs]
        mov     [edi],dx
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function sets the value of the current task's real
// mode interrupt vector for the specified interrupt.
//
// Entry: IntNo - Interrupt number
//        RSeg - Segment of real mode interrupt handler
//        ROfs - Offset of real mode interrupt handler
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function SetRealModeIntVec(IntNo: Byte; RSeg,ROfs: Word): Boolean; assembler;
  asm
        mov     eax,0201h
        mov     bl,[IntNo]
        mov     cx,[RSeg]
        mov     dx,[ROfs]
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  returns  the  Pointer to the  current
// protected mode  exception  handler  for  the  specified
// exception number.
//
// Entry: ExpFault - Exception/fault number (00h-1Fh)
// Exit : if successful: TRUE
//        Sel,Offs: Selector,Offset of exception handler
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function GetExceptionHandler(ExpFault: Byte; var Sel: Word; var Offs: DWord): Boolean;
 assembler;
  asm
        mov     eax,0202h
        mov     bl,[ExpFault]
        int     31h
        mov     edi,[Offs]
        mov     [edi],edx
        mov     edi,[Sel]
        mov     [edi],cx
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  allows protected  mode  applications  to
// intercept processor  exceptions that are not handled by
// the DPMI  environment.   Programs may  wish  to  handle
// exceptions such  as not  present segment  faults  which
// would otherwise generate a fatal error.
//
// Entry: ExpFault - Exception/fault number (00h-1Fh)
//        Sel,Offs - Selector, Offset of exception handler
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function SetExceptionHandler(ExpFault: Byte; Sel: Word; Offs: DWord): Boolean;
 assembler;
  asm
        mov     eax,0203h
        mov     bl,[ExpFault]
        mov     edx,[Offs]
        mov     cx,[Sel]
        mov     cx,cs
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  returns  the  ParPointer to the  current
// protected mode  interrupt  handler  for  the  specified
// interrupt number.
//
// Entry: IntNo - Interrupt number
// Exit : if successful: TRUE
//        Sel,Offs - Selector,Offset of interrupt handler
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function GetDPMIIntVec(IntNo: Byte; var Sel: Word; var Offs: DWord): Boolean;
  assembler;
      asm
        mov     eax,0204h
        mov     bl,[IntNo]
        int     31h
        mov     edi,[Offs]
        mov     [edi],edx
        mov     edi,[Sel]
        mov     [edi],cx
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This  function   sets  the  address  of  the  specified
// protected mode interrupt vector.
//
// Entry: IntNo - Interrupt number
//        Addr - Pointer of interrupt handler
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function SetDPMIIntVec(IntNo: Byte; Sel: Word; Offs: DWord): Boolean; assembler;
      asm
        mov     eax,0205h
        mov     bl,[IntNo]
        mov     edx,[Offs]
        mov     cx,[Sel]
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  simulates an interrupt in real mode.  It
// will invoke  the  CS:IP  specified  by  the  real  mode
// interrupt  vector   and  the  handler  must  return  by
// executing an iret.
//
// Entry: IntNo - Interrupt number
//        Regs -  TRealRegs structure
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function RealModeInt(IntNo: Byte; var Regs: TRmRegs): Boolean; assembler;
      asm
        movzx   bx,[IntNo]
        xor     ecx,ecx
        mov     edi,[Regs]
        mov     eax,0300h
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  calls a real mode procedure.  The called
// procedure must execute a far return when it completes.
//
// Entry: Regs -  TRealRegs structure
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function CallRealModeFar(var Regs: TRmRegs): Boolean; assembler;
      asm
        xor     ecx,ecx
        mov     edi,[Regs]
        mov     ax,0301h
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  calls a real mode procedure.  The called
// procedure must execute an iret when it completes.
//
// Entry: Regs -  TRealRegs structure
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function CallRealModeIRet(var Regs: TRmRegs): Boolean; assembler;
      asm
        xor     ecx,ecx
        mov     edi,[Regs]
        mov     eax,0302h
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  is used  to obtain  a  unique  real  mode
// SEG:OFFSET that will transfer control from real mode to
// a protected mode procedure.
//
// Entry: Selector:Offset of procedure to call
//        Selector:Offset of real mode call structure
// Exit : if successful: Segment:Offset of real mode call address
//        if failed:     Zero
//////////////////////////////////////////////////////////////////
function AllocRealModeCallBack(HandlerAddr, RegsAddr: Pointer; var HndSeg: Word;
 var HndOfs: DWord): Boolean; assembler;
      asm
        mov     eax,0303h
        mov     esi,[HandlerAddr]
        mov     edi,[RegsAddr]
        push    ds
        push    cs
        pop     ds
        int     31h
        pop     ds
        xor     eax,eax
        jc      @@Quit
        mov     edi,[HndSeg]
        mov     word ptr [edi],cx
        mov     edi,[HndOfs]
        mov     dword ptr [edi],edx
        inc     eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  frees a real mode call-back address that
// was allocated  through the allocate real mode call-back
// address service.
//
// Entry: RmCallAddr - Real mode call-back address to free
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function FreeRealModeCallBack(HndSeg: Word; HndOfs: DWord): Boolean; assembler;
      asm
        mov     eax,0304h
        mov     cx,[HndSeg]
        mov     edx,[HndOfs]
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// Returns  the   version  of  DPMI  services  supported.
//
// Entry: None
// Exit : if successful: Version of DPMI service
//        if failed    : Zero
//////////////////////////////////////////////////////////////////
function GetDPMIVer: Word; assembler;
      asm
        mov     eax,0400h
        int     31h
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This  function  is  provided  so  that  protected  mode
// applications  can   determine  how   much   memory   is
// available.   Under DPMI  implementations  that  support
// virtual memory, it is important to consider issues such
// as the amount of available physical memory.
//
// Entry: BufferPtr - Selector:Offset of 30h byte buffer
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function GetFreeMemoryInfo(BufferPtr: Pointer): Boolean; assembler;
      asm
        mov     eax,500h
        mov     edi,[BufferPtr]
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function can be used by device
// drivers to convert a physical address into a linear address.
// The linear  address can  then be  used to  access the device
// memory.
//
// Entry: PhysAddr    - physical address
//        SizeInBytes - size of mapped block in bytes
// Exit : if successful: Pointer to linear address that can be
//        used to access the physical memory
//        if failed:     Nil
//////////////////////////////////////////////////////////////////
function MapPhysicalToLinear(PhysAddr, SizeInBytes: DWord): DWord; assembler;
      asm
        mov     eax,0800h
        mov     cx,word ptr [PhysAddr]
        mov     bx,word ptr [PhysAddr+2]
        mov     di,word ptr [SizeInBytes]
        mov     si,word ptr [SizeInBytes+2]
        int     31h
        jnc     @@SS
        xor     eax,eax
        jmp     @@Quit
@@SS:   mov     eax,ebx
        shl     eax,16
        mov     ax,cx
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function frees physical memory mapping
//
// Entry: LinearAddr - Pointer to linear address to be freed
// Exit : if successful: TRUE
//        if failed:     FALSE
//////////////////////////////////////////////////////////////////
function FreePhysicalMap(LinearAddr: DWord): Boolean; assembler;
      asm
        mov     eax,0801h
        mov     cx,word ptr [LinearAddr]
        mov     bx,word ptr [LinearAddr+2]
        int     31h
        mov     eax,1
        jnc     @@Quit
        xor     eax,eax
@@Quit:
end;

//////////////////////////////////////////////////////////////////
// This function  will disable  the virtual interrupt flag
// and return  the previous state of the virtual interrupt
// flag.
//
// Entry: None
// Exit : Virtual interrupt state
//////////////////////////////////////////////////////////////////
function GetDisableInterruptState: Boolean; assembler;
      asm
        mov     eax,0900h
        int     31h
end;

//////////////////////////////////////////////////////////////////
// This function  will enable  the virtual interrupt flag
// and return  the previous state of the virtual interrupt
// flag.
//
// Entry: None
// Exit : Virtual interrupt state
//////////////////////////////////////////////////////////////////
function GetEnableInterruptState: Boolean; assembler;
      asm
        mov     eax,0901h
        int     31h
end;

//////////////////////////////////////////////////////////////////
// This function will disable return state of the virtual
// interrupt flag.
//
// Entry: None
// Exit : Virtual interrupt state
//////////////////////////////////////////////////////////////////
function GetInterruptState: Boolean; assembler;
      asm
        mov     eax,0902h
        int     31h
end;

end.