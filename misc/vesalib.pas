{Written by TCA of NewOrder; mailto:monsters@monstersoft.com
 http://www.monstersoft.com
 If you use this unit in any of your programs, please give credit to
 MonsterSoft.}
unit vesalib;

interface

const CurWriteBank:word=65535;
      CurReadBank:word=65535;

const SegC000:word      = $c000;
      Seg0000:word      = $0000;
      Seg0040:word      = $0040;
      SegA000:word      = $a000;

      _320x200x8bpp     = $13;
      _640x400x8bpp     = $100;
      _640x480x8bpp     = $101;
      _800x600x8bpp     = $103;
      _1024x768x8bpp    = $105;
      _1280x1024x8bpp   = $107;
      _320x200x15bpp    = $10D; {1:5:5:5}
      _320x200x16bpp    = $10E; {5:6:5}
      _320x200x24bpp    = $10f; {8:8:8}
      _640x480x15bpp    = $110; {1:5:5:5}
      _640x480x16bpp    = $111; {5:6:5}
      _640x480x24bpp    = $112; {8:8:8}
      _800x600x15bpp    = $113; {1:5:5:5}
      _800x600x16bpp    = $114; {5:6:5}
      _800x600x24bpp    = $115; {8:8:8}
      _1024x768x15bpp   = $116; {1:5:5:5}
      _1024x768x16bpp   = $117; {5:6:5}
      _1024x768x24bpp   = $118; {8:8:8}
      _1280x1024x15bpp  = $119; {1:5:5:5}
      _1280x1024x16bpp  = $11A; {5:6:5}
      _1280x1024x24bpp  = $11B; {8:8:8}
      _1600x1200x8bpp   = $11c;
      _1600x1200x15bpp  = $11d; {Unverified}
      _1600x1200x16bpp  = $11e; {5:6:5}

      VESA_ok=$4F;
type
  Dword=record
   Loword,Hiword:word
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
    SwitchBank:procedure;
    ReadWindow:word;
    LineOffsets:array[0..1199] of longint;
    BankVals:array[0..480] of word;
    Xres,Yres,GetMaxX,GetMaxY:word;

function IsVESAInstalled: word;
function GetModeInfo (mode: Word): word;
function ModeIsAvailable(modeNum:word):boolean;
procedure SetWriteBank(NewBank:word);
procedure SetReadBank(NewBank:word);
procedure SetupMode(Mode:word);
procedure putpixel(x,y: word; colour: byte);
function getpixel(x,y: word):byte;
procedure putpixel24(x,y:word; r,g,b:byte);
procedure setrgbpalette(colour,r,g,b:byte);

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

function IsVesaInstalled:word;
begin
 with RMRegs do
  begin
   ax:=$4f00;
   di:=0;
   es:=GetSegBaseAddr(seg(VESARec^)) shr 4;
   ss:=0; {Clear stack so DPMI handles it}
   sp:=0  {"}
  end;
 SimRMI($10,RMRegs);

 {Convert all real mode pointers to protected mode pointers}
 with VesaRec^ do
  begin
   VideoModePtr:=ConvertPtr(VideoModePtr);
   OemStringPtr:=ConvertPtr(OemStringPtr);
  end;

 IsVesaInstalled:=RMRegs.ax
end;

function GetModeInfo(mode:Word): word;
var poy:pointer;
begin
 with RMRegs do
  begin
   ax:=$4f01;
   cx:=mode;
   di:=0;
   es:=GetSegBaseAddr(seg(ModeRec^)) shr 4;
   sp:=0; {Clear stack so DPMI handles it}
   ss:=0  {"}
  end;
 SimRMI($10,RMRegs);

 GetModeInfo:=RMRegs.ax;
end;

{$else}

function IsVESAInstalled: word; assembler;
asm
        mov     ax,4F00h
        les     di,VESARec
        int     10h
end;

function GetModeInfo (mode: Word): word; assembler;
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
 VESASelector:=AllocSelector(0);
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
Procedure putpixel(x,y: word; colour: byte); external;
function getpixel(x,y: word):byte; external;
procedure putpixel24(x,y:word; r,g,b:byte); external;
{$l vesa}

function ModeIsAvailable(modeNum:word):boolean;
begin
 if ModeNum=$13 then
  begin
   ModeIsAvailable:=TRUE;
   exit
  end
 else ModeIsAvailable:=FALSE;
 if (modeNum>=$100) and (modeNum<=$11f) then
  begin
   GetModeInfo(ModeNum);
   with ModeRec^ do
    ModeIsAvailable:=(ModeAttributes and 1=1);
  end;
end;

procedure OldSwitchBank; far; assembler;
asm
        mov     ax,4f05h
        int     10h
end;

procedure dummy; far; assembler;
asm end;

procedure initVESAmode(mode:word); assembler;
asm
        mov     ax,4f02h
        mov     bx,mode
        int     10h
end;

procedure SetupMode(Mode:word);
var count,GranInc:word;
begin
 if mode=$13 then
  begin
   asm
        mov     ax,13h
        int     10h       {Set mode13h}
        mov     dx,03c2h
        mov     al,0e3h   {Init Mode-D}
        out     dx,al
   end;
   @SwitchBank:=@Dummy;
   xRes:=320;
   yRes:=200;
   GetMaxX:=Xres-1;
   GetMaxY:=YRes-1;
   LineOffsets[0]:=0;
   for count:=1 to high(LineOffsets) do
    LineOffsets[count]:=LineOffsets[count-1]+320;
   exit
  end;

 GetModeInfo(mode);

 Xres:=ModeRec^.Xres;
 YRes:=ModeRec^.YRes;
 GetMaxX:=Xres-1;
 GetMaxY:=YRes-1;

 LineOffsets[0]:=0;
 for count:=1 to high(LineOffsets) do
  LineOffsets[count]:=LineOffsets[count-1]+ModeRec^.BytesPerLine;
 writeln(moderec^.granularity);
 GranInc:=65536 div (longint(ModeRec^.Granularity)*1024); {Adjust for page size}
 BankVals[0]:=0;
 for count:=1 to high(bankvals) do
  BankVals[count]:=BankVals[count-1]+GranInc;

 {$ifdef DPMI}
  if ModeRec^.BankSwitch=NIL then @SwitchBank:=@OldSwitchBank else
   begin
    SetSelectorBase(VESASelector,longint(dword(ModeRec^.BankSwitch).HiWord)*16);
    SetSelectorLimit(VESASelector,65535);
    if codeselector<>0 then FreeSelector(CodeSelector);
    CodeSelector:=AllocDStoCSAlias(VesaSelector);
    @SwitchBank:=ptr(CodeSelector,Dword(ModeRec^.BankSwitch).LoWord);
   end;
 {$else}
  with ModeRec^ do
  if BankSwitch=NIL then @SwitchBank:=@OldSwitchBank else @SwitchBank:=BankSwitch;
 {$endif}
 If ModeRec^.WindowAFlags and 2=2 then
  ReadWindow:=0
 else if ModeRec^.WindowBFlags and 2=2 then
  ReadWindow:=1; {else there is no readable window!?}
 InitVESAMode(mode);
 setwritebank(0);
 SetReadBank(0);
end;

procedure SetReadBank(NewBank:word); assembler;
asm
        mov     dx,NewBank
        mov     ax,CurReadBank
        cmp     ax,dx                {This *could* be wrong.}
        je      @NoNeed
        mov     CurReadBank,dx           { reset to new page }
        mov     bx,dx
        add     bx,bx
        mov     dx,word ptr BankVals[bx]
        mov     bx,ReadWindow
        call    SwitchBank
@NoNeed:
        mov     ax,ReadWindow
        test    ax,ax
        jnz     @@DiffBank
        mov     ax,CurReadBank
        mov     CurWriteBank,ax
@@DiffBank:
end;

procedure SetWriteBank(NewBank:word); assembler;
asm
        mov     dx,NewBank
        mov     ax,CurWriteBank
        cmp     ax,dx                {This *could* be wrong.}
        je      @NoNeed
        mov     CurWriteBank,dx           { reset to new page }
        mov     bx,dx
        add     bx,bx
        mov     dx,word ptr BankVals[bx]
        xor     bx,bx
        call    SwitchBank
@NoNeed:
        mov     ax,ReadWindow
        test    ax,ax
        jnz     @@DiffBank
        mov     ax,CurWriteBank
        mov     CurReadBank,ax
@@DiffBank:

end;

procedure setrgbpalette(colour,r,g,b:byte); assembler;
asm
        mov     dx,03c8h
        mov     al,colour
        out     dx,al
        inc     dx
        mov     al,r
        out     dx,al
        mov     al,g
        out     dx,al
        mov     al,b
        out     dx,al
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
 SegA000:=SegToDescriptor($A000);
 Seg0040:=SegToDescriptor($0040);
{$endif}
 SaveExit:=ExitProc;
 ExitProc:=@VesaExit;
 AllocVesaStrucs;
end.
