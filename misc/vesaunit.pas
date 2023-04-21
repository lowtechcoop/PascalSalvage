{Written by TCA of NewOrder; mailto:monsters@monstersoft.com
 If you use this unit in any of your programs, please give credit to
 MonsterSoft.}
unit vesaunit;

interface

const Segc000:word=$c000;
      Seg0000:word=$0000;

type
  Dword=record
   Loword,Hiword:word;
  end;

  TWordArray = array [byte] of Word;

  TVESARec = record
       VBESignature       : array [0..3] of Char;
       minVersion         : Byte;
       majVersion         : Byte;
       OEMStringPtr       : Pchar;
       Capabilities       : LongInt;
       VideoModePtr       : ^TWordArray;
       TotalMemory        : word;

       {VESA 2.0}
       OemSoftwareRev     : word;
       OemVendorNamePtr   : Pchar;
       OemProductNamePtr  : Pchar;
       OemProductRevPtr   : Pchar;
       Paddington: array [35..256] of Byte; {Change the upper bound to 512}
                                            {if you are using VBE2.0}
  end;

  TModeRec = record
       ModeAttributes     : Word;
       WindowAFlags       : Byte;
       WindowBFlags       : Byte;
       Granularity        : Word;
       WindowSize         : Word;
       WindowASeg         : Word;
       WindowBSeg         : Word;
       BankSwitch         : Pointer;
       BytesPerLine       : Word;
       XRes,YRes          : Word;
       CharWidth          : Byte;
       CharHeight         : Byte;
       NumBitplanes       : Byte;
       BitsPerPixel       : Byte;
       NumberOfBanks      : Byte;
       MemoryModel        : Byte;
       BankSize           : Byte;
       NumOfImagePages    : byte;
       Reserved           : byte;
       {Direct Colour fields (required for Direct/6 and YUV/7 memory models}
       RedMaskSize        : byte;
       RedFieldPosition   : Byte;
       GreenMaskSize      : Byte;
       GreenFieldPosition : Byte;
       BlueMaskSize       : Byte;
       BlueFieldPosition  : Byte;
       RsvdMaskSize       : Byte;
       RsvdFieldPosition  : Byte;
       DirectColourMode   : Byte;
       {VESA 2.0 stuff}
       PhysBasePtr        : longint;
       OffScreenMemOffset : pointer;
       OffScreenMemSize   : word;
       paddington: array [49..256] of Byte; {Change the upper bound to 512}
                                            {if you are using VBE2.0}
  end;

var RMRegs:record
            case boolean of
            true:(edi,esi,ebp,reserved,ebx,edx,ecx,eax:longint;
                  flags,es,ds,fs,gs,ip,cs,sp,ss:word);
            true:(di,udi,si,usi,bp,ubp,rese,rved,bx,ubx,dx,udx,cx,ucx,ax,uax:word);
           end;

    VESARec:^TVESARec;
    ModeRec:^TModeRec;

procedure AllocVesaStrucs;
procedure DeAllocVesaStrucs;
function IsVESAInstalled (var VESARec:TVesaRec): word;
function GetModeInfo (mode: Word;var ModeRec:TModeRec): word;

implementation

{$ifdef DPMI}
uses winapi;

var VESASelector,CodeSelector:word;

{Simulate Real Mode Interrupt}
procedure SimRMI(IntNum:byte;var CallStruc); assembler;
asm
        mov     ax,300h
        mov     bh,1
        mov     bl,IntNum
        xor     cx,cx
        les     di,CallStruc
        int     31h
end;

{Call Real Mode Procedure (with Far Return Frame)}
procedure CallRMP(var CallStruc); assembler;
asm
        mov     ax,301h
        mov     bh,1
        xor     cx,cx
        les     di,CallStruc
        int     31h
end;

function GetSegBaseAddr(Selector:word):longint; assembler;
asm
        mov     ax,0006h
        mov     bx,Selector
        int     31h
        mov     ax,dx
        mov     dx,cx
end;

function SegToDescriptor(SegAddr:word):word; assembler;
asm
        mov     ax,0002h
        mov     bx,SegAddr
        int     31h
end;

function ConvertPtr(RMPointer:Pointer):pointer; assembler;
asm
        mov     ax,0002h
        mov     bx,word ptr RMPointer+2
        int     31h
        mov     dx,ax
        mov     ax,word ptr RMPointer
end;

function IsVesaInstalled(var VESARec:TVesaRec):word;
begin
 with RMRegs do
  begin
   ax:=$4f00;
   di:=0;
   es:=GetSegBaseAddr(seg(VESARec)) shr 4;
   ss:=0; {Clear stack so DPMI handles it}
   sp:=0  {"}
  end;
 SimRMI($10,RMRegs);

 {Convert all real mode pointers to protected mode pointers}
 with VesaRec do
  begin
   VideoModePtr:=ConvertPtr(VideoModePtr);
   OemStringPtr:=ConvertPtr(OemStringPtr);
  end;

 IsVesaInstalled:=RMRegs.ax
end;

function GetModeInfo(mode:Word; var ModeRec:TModeRec): word;
var poy:pointer;
begin
 with RMRegs do
  begin
   ax:=$4f01;
   cx:=mode;
   di:=0;
   es:=GetSegBaseAddr(seg(ModeRec)) shr 4;
   sp:=0; {Clear stack so DPMI handles it}
   ss:=0  {"}
  end;
 SimRMI($10,RMRegs);

 GetModeInfo:=RMRegs.ax;
end;

{$else}

function IsVESAInstalled (var VESARec:TVesaRec): word; assembler;
asm
        mov     ax,4F00h
        les     di,VESARec
        int     10h
end;

function GetModeInfo (mode: Word;var ModeRec:TModeRec): word; assembler;
asm
        mov     ax,4F01h
        mov     cx,[mode]
        les     di,ModeRec
        int     10h
end;
{$endif}

procedure AllocVesaStrucs;
begin
{$ifdef DPMI}
 VESASelector:=0;
 CodeSelector:=0;
 ModeRec:=GlobalLock(GlobalDosAlloc(sizeof(Tmoderec)));
 VesaRec:=GlobalLock(GlobalDosAlloc(sizeof(TVESARec)))
{$else}
 new(VesaRec);
 new(ModeRec)
{$endif}
end;

procedure DeAllocVesaStrucs;
begin
{$ifdef DPMI}
 if VESASelector<>0 then FreeSelector(VESASelector);
 if CodeSelector<>0 then FreeSelector(CodeSelector);
 if globalunlock(seg(VesaRec^)) then globaldosfree(seg(VesaRec^));
 if globalunlock(seg(ModeRec^)) then globaldosfree(seg(ModeRec^))
{$else}
 dispose(VesaRec);
 dispose(ModeRec)
{$endif}
end;

var SaveExit: Pointer;

procedure VesaExit; far;
begin
 ExitProc:=SaveExit;
 DeAllocVesaStrucs;
end;

begin
{$ifdef DPMI}
 SegC000:=SegToDescriptor($c000);
 Seg0000:=SegToDescriptor($0000);
{$endif}
 SaveExit:=ExitProc;
 ExitProc:=@VesaExit;
 AllocVesaStrucs;
end.
