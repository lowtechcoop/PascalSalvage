{ --------------------------------------------------------------------------- }
{ CPUTYPE.PAS   Turbo Pascal TMi0SDGL 2 interface unit.         Version 2.01  }
{                                                                             }
{ Too-Much-in-0ne-So-Don't-Get-Lost(tm) Revision 2 CPU/FPU detection library. }
{ Copyright(c) 1996 by B-coolWare.  Written by Bobby Z.                       }
{ --------------------------------------------------------------------------- }

{$A+,I-,S-,X+}

unit CPUType;

interface

type
        cpuid1Layout = record
                        Extra : Byte;
                        Family: Byte;
                        Model : Byte;
                        Step  : Byte;
                       end;

        customCpuid = record
                        eax,
                        ebx,
                        ecx,
                        edx   : LongInt;
                      end;

const
        cpu         : Byte = $FF;
        fpu         : Byte = $FF;
        extFlags    : Word = 0;
        cpuid0      : array[0..11] of Char = #0#0#0#0#0#0#0#0#0#0#0#0;
        cpuid1      : LongInt = 0;
        cpuFeatures : LongInt = 0;

{ CPU type constants }

        i8088           = 00;
        i8086           = 01;
        i80C88          = 02;
        i80C86          = 03;
        i80188          = 04;
        i80186          = 05;
        necV20          = 06;
        necV30          = 07;
        i80286          = 08;
        i80386sx        = 09;
        i80386dx        = 10;
        i386sl          = 11;
        ibm386slc       = 12;
        am386sx         = 13;
        am386dx         = 14;
        ct38600         = 15;
        ct38600SX       = 16;
        RapidCAD        = 17;
        i486sx          = 18;
        i486dx          = 19;
        ibm486slc       = 20;
        ibm486slc2      = 21;
        ibm486bl3       = 22;
        Cx486           = 23;
        umcU5S          = 24;
        umcU5D          = 25;
        am486           = 26;
        iPentium        = 27;
        iP54C           = 28;
        CxM1            = 29;
        amdK5           = 30;
        Nx586           = 31;
        iPentiumPro     = 32;
        amdK6           = 33;
        iP7             = 34;

{ FPU type constants }

        fpuInternal     = 100;
        fpuNone         = 0;
        i8087           = 1;
        i80287          = 2;
        i80287xl        = 3;
        i80387          = 4;
        rCAD            = 5;
        cx287           = 6;
        cx387           = 7;
        cx487           = 8;
        cxEMC87         = 9;
        iit287          = 10;
        iit387          = 11;
        iit487          = 12;
        ct387           = 13;
        ulsi387         = 14;
        ulsi487         = 15;
        i487sx          = 16;
        Nx587           = 17;

{ misc constants }

        efHasFPUonChip  = $0001;
        efWeitekPresent = $0002;
        efCPUIDSupport  = $0004;
        efDXType        = efCPUIDSupport+efHasFPUOnChip;
        efEmulatedFPU   = $0008;


function cpu_Type : String; { returns CPU name }

function fpu_Type : String; { returns FPU name }

function cpu_Speed : Word;  { returns CPU clock in MHz }

function fcpu_Speed : Real; { returns floating point CPU clock freq }

function getCacheSize : Word; far; { returns L1 cache size in Kb }

procedure CxCPUIDEnable; far;

procedure getCPUID( Level : LongInt; Result : Pointer ); far;

{$IFDEF Ver70}
{$IFNDEF DPMI}
 {$IFNDEF Windows}
function isV86 : Boolean; far; { this routine is useful for real mode only }
 {$ENDIF} { Windows }
{$ENDIF} { DPMI }
{$ELSE} { not Ver70, no protected mode or windows }
function isV86 : Boolean; far;
{$ENDIF}

implementation

{ do not change following constants! }
const
        fpuDenormal   : array [0..9] of Byte = (1,0,0,0,0,0,0,0,0,0);
        fpuOp1        : array [0..9] of Byte = ($F0,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$3F);
        fpu_53bit_prec: word = $02F7;
        speedShift    : word = 0;
        speedTable    : array[i8088..iP7] of LongInt =
                        (
                         $0002AD26, { i8088 }
                         $0002AD26, { i8086 }
                         $0002AD26, { i80C88 }
                         $0002AD26, { i80C86 }
                         $0000BA6F, { i80188 }
                         $0000BA6F, { i80186 }
                         $0000E90B, { necV20 }
                         $0000DFB9, { necV30 }
                         $00006FDC, { i80286 }
                         $00007480, { i80386SX }
                         $00007480, { i80386DX }
                         $00007480, { i386sl }
                         $00007480, { ibm386slc }
                         $00007415, { Am386SX }
                         $00007415, { Am386DX }
                         $00007480, { CT38600 }
                         $00007480, { CT38600SX }
                         $00007415, { RapidCAD }
                         $00007480, { i486SX }
                         $00007480, { i486DX }
                         $00007486, { ibm486slc }
                         $00007486, { ibm486slc2 }
                         $00007486, { ibm486bl3 }
                         $0000668A, { Cx486 }
                         $00003C90, { umcU5S }
                         $00003C90, { umcU5D }
                         $00007480, { Am486 }
                         $00007850, { Pentium }
                         $00007900, { P54C }
                         $00008500, { CxM1 }
                         $000061D0, { amdK5 }
                         $0000792E, { Nx586       !!! needs adjustment }
                         $0000D28C, { iPentiumPro !!! needs adjustment }
                         $00008500, { amdK6       !!! needs adjustment }
                         $00003079  { P7          !!! needs adjustment }
                        );

{ external functions }
function getCPUType : Byte; far; external;

function getFPUType : Byte; far; external;

function getCyrixModel : Word; far; external;
{ hi byte = DIR1, lo byte = DIR0 }
{ DIR stands for Device Identification Register. They are found in Cyrix CPUs
  and their derivatives/compatibles from Texas Instruments, SGS Thompson and
  few other vendors. They are accessed via I/O ports 22h and 23h, address and
  data port respectively. DIR0 register index is 0FEh and DIR1 index is 0FFh.
  To read DIRx first out 22h, regindex, then in al,23h. DIR0 holds device
  model signature, DIR1 holds chip stepping information as well as some other
  flags. All known Cyrix chips have DIRs, even new 586-class ones.
  }

function Speed : Word; far; external;

function getCacheSize; external;

procedure CxCPUIDEnable; external;

procedure getCPUID; external;

{$IFDEF Ver70}
{$IFNDEF DPMI}
 {$IFNDEF Windows}
function isV86; external;
 {$ENDIF}
{$ENDIF}
{$ELSE}
function isV86; external;
{$ENDIF}

{$IFDEF Ver70 }
{$IFNDEF DPMI }
 {$IFNDEF Windows } {Windows is DPMI-compliant too}
  {$L REALCODE.OBJ } { Link in real-mode code }
 {$ELSE}
  {$L DPMICODE.OBP } { Link in protected-mode code }
 {$ENDIF}
{$ELSE}
 {$L DPMICODE.OBP }
{$ENDIF}
{$ELSE} { Version is lower than 7.0, no DPMI support }
 {$L REALCODE.OBJ }
{$ENDIF}

{$L CPUSPEED.OBJ } { Speed routine doesn't care of mode of operation }
{$L CACHETST.OBJ }

function CyrixModel : String;
 var
    isTI : Boolean;
    DIR0,
    DIR1 : Byte;
 begin
  DIR0 := Lo(getCyrixModel);
  DIR1 := Hi(getCyrixModel);
  isTI := (DIR1 and $80) <> 0;
  { new Texas Instruments 486DX-class chips have high bit of DIR1 set to 1,
    while Cyrix reserve this bit and set it to 0 }
  case DIR0 of
   0 : CyrixModel := 'Cyrix Cx486SLC';
   1 : CyrixModel := 'Cyrix Cx486DLC';
   2 : CyrixModel := 'Cyrix Cx486SL2';
   3 : CyrixModel := 'Cyrix Cx486DL2';
   4 : CyrixModel := 'Cyrix Cx486SRx';
   5 : CyrixModel := 'Cyrix Cx486DRx';
   6 : CyrixModel := 'Cyrix Cx486SRx2';
   7 : CyrixModel := 'Cyrix Cx486DRx2';
   8 : CyrixModel := 'Cyrix Cx486SRu';
   9 : CyrixModel := 'Cyrix Cx486DRu';
  $0A: CyrixModel := 'Cyrix Cx486SRu2';
  $0B: CyrixModel := 'Cyrix Cx486DRu2';
  $10: CyrixModel := 'Cyrix Cx486S';
  $11: CyrixModel := 'Cyrix Cx486S2';
  $12: CyrixModel := 'Cyrix Cx486Se';
  $13: CyrixModel := 'Cyrix Cx486S2e';
  $1A: begin
        if IsTI then
         CyrixModel := 'Texas Instruments Ti486DX'
        else
         CyrixModel := 'Cyrix Cx486DX';
        extFlags := extFlags or efHasFPUonChip;
       end;
  $1B: begin
        if DIR1 = $0B then
         CyrixModel := 'SGS-Thomson ST486DX2'
        else
        if IsTI or (DIR1 = $32) then
         CyrixModel := 'Texas Instruments Ti486DX2'
        else
        CyrixModel := 'Cyrix Cx486DX2';
        extFlags := extFlags or efHasFPUonChip;
       end;
  $1F: begin
        if IsTI then
         CyrixModel := 'Texas Instruments Ti486DX4'
        else
        CyrixModel := 'Cyrix Cx486DX4';
        extFlags := extFlags or efHasFPUonChip;
       end;
  $20..$2F:
       begin
        cpu := CxM1;
        CyrixModel := 'Cyrix 5x86 (M1sc)';
        extFlags := extFlags or efHasFPUonChip;
        case DIR0 of
         $28: CyrixModel := 'Cyrix 5x86-S (clock x1 mode)';
         $29: CyrixModel := 'Cyrix 5x86-S (clock x2 mode)';
         $2D: CyrixModel := 'Cyrix 5x86-S (clock x3 mode)';
         $2C: CyrixModel := 'Cyrix 5x86-S (clock x4 mode)';
         $2A: CyrixModel := 'Cyrix 5x86-P (clock x1 mode)';
         $2B: CyrixModel := 'Cyrix 5x86-P (clock x2 mode)';
         $2F: CyrixModel := 'Cyrix 5x86-P (clock x3 mode)';
         $2E: CyrixModel := 'Cyrix 5x86-P (clock x4 mode)';
        end;
       end;
  $30..$3F:
       begin
        cpu := CxM1;
        CyrixModel := 'Cyrix 6x86 (M1)';
        extFlags := extFlags or efHasFPUonChip;
        case DIR0 of
         $30: CyrixModel := 'Cyrix 6x86-S (clock x1 mode)';
         $31: CyrixModel := 'Cyrix 6x86-S (clock x2 mode)';
         $35: CyrixModel := 'Cyrix 6x86-S (clock x3 mode)';
         $34: CyrixModel := 'Cyrix 6x86-S (clock x4 mode)';
         $32: CyrixModel := 'Cyrix 6x86-P (clock x1 mode)';
         $33: CyrixModel := 'Cyrix 6x86-P (clock x2 mode)';
         $37: CyrixModel := 'Cyrix 6x86-P (clock x3 mode)';
         $36: CyrixModel := 'Cyrix 6x86-P (clock x4 mode)';
        end;
       end;
  $81: begin { TI's 486DX4 Data Sheet states that it's DIR0 value is 81h }
        CyrixModel := 'Texas Instruments Ti486DX4';
        extFlags := extFlags or efHasFPUonChip;
       end;
  $EF: CyrixModel := 'Cyrix Cx486S_a';  { this id is software-generated }
  $FD: begin
        CyrixModel := 'Cyrix OverDrive';
        extFlags := extFlags or efHasFPUonChip;
       end;
  $FE: CyrixModel := 'Texas Instruments Ti486SXL (Potomac)';
  else
   CyrixModel := 'Cyrix/TI/SGS 486-class processor';
  end;
 end;

function cpu_Type;
 var
    cpuid1_ : cpuid1Layout;
 begin
  if cpu = $FF then
   getCPUType;
  case cpu of
   i80386sx: if cpu_Speed > 35 then cpu := am386sx;
   i80386dx: if cpu_Speed > 35 then cpu := am386dx;
  end;
  if (extFlags and efCPUIDSupport) <> 0 then
   begin
   cpuid1_.Extra := (cpuid1 and $F000) shr 12;
   cpuid1_.Family:= (cpuid1 and $0F00) shr 8;
   cpuid1_.Model := (cpuid1 and $00F0) shr 4;
   cpuid1_.Step  := (cpuid1 and $000F);
   case cpuid1_.Family of
    4: { 486 }
       begin
        if cpuid0 = 'UMC UMC UMC ' then { UMC U5-x 486s }
         case cpuid1_.Model of
          1: cpu := umcU5D;
          2: cpu := umcU5S;
          3: begin
              cpu := umcU5D;
              cpu_Type := 'UMC U486DX2';
              exit;
             end;
          5: begin
              cpu := umcU5S;
              cpu_Type := 'UMC U486SX2';
              exit;
             end;
         else
          begin
           cpu := umcU5S;
           cpu_Type := 'Undistinguished UMC U486';
           exit;
          end;
         end { case }
        else
        if cpuid0 = 'GenuineIntel' then { Intel i486s }
         begin
          case cpuid1_.Model of
           0 : cpu_Type := 'Intel i486DX';
           1 : cpu_Type := 'Intel i486DX50';
           2 : cpu_Type := 'Intel i486SX';
           3 : if (cpuid1_.Extra and 3) = 1 then
                cpu_Type := 'Intel i486DX OverDrive'
               else
                cpu_Type := 'Intel i486DX2';
           4 : cpu_Type := 'Intel i486SL';
           5 : cpu_Type := 'Intel i486SX2';
           7 : cpu_Type := 'Intel i486DX2WB';
           8 : cpu_Type := 'Intel i486DX4';
           9 : cpu_Type := 'Intel i486DX4WB';
          else
           cpu_Type := 'Intel i486 (undistinguished model)';
          end; { case }
          exit;
         end { begin }
        else
        if cpuid0 = 'AuthenticAMD' then { AMD Enhanced Am486s }
         begin
          cpu := Am486;
          case cpuid1_.Model of
           3 : cpu_Type := 'AMD Enhanced Am486DX2';
           7 : cpu_Type := 'AMD Enhanced Am486DX2+';
           8 : cpu_Type := 'AMD Enhanced Am486DX4';
           9 : cpu_Type := 'AMD Enhanced Am486DX4+';
          $E : cpu_Type := 'AMD X5 (Am5x86)';
          $F : cpu_Type := 'AMD X5+ (Am5x86+)';
          else
           cpu_Type := 'AMD Enhanced Am486DX (undistinguished model)';
          end; { case }
          exit;
         end { begin }
        else
         begin
          cpu_Type := 'Unknown 486-class CPU (Make : '+cpuid0+')';
          exit;
         end;
       end;
    5: { 586 }
       begin
        if cpuid0 = 'CyrixInstead' then
         begin
          cpu_Type := CyrixModel;
          exit;
         end
        else
        if cpuid0 = 'NexGenDriven' then { NexGen is now part of AMD family }
         begin
          cpu := Nx586;
          case cpuid1_.Model of
           0: begin
               cpu_Type := 'NexGen Nx586 or Nx586FPU';
               exit;
              end;
          else
           begin
            cpu_Type := 'NexGen 586-class processor (undistinguished)';
            exit;
           end
          end
         end
        else
        if cpuid0 = 'AuthenticAMD' then
         begin
          cpu := amdK5;
          case cpuid1_.Model of
           0: begin
               cpu_Type := 'AMD SSA/5 (K5)';
               exit;
              end;
           1: begin
               cpu_Type := 'AMD 5k86 (K5)';
               exit;
              end;
           6: cpu := amdK6;
          else
           begin
            cpu_Type := 'AMD 586-class processor (undistinguished)';
            exit;
           end
          end
         end
        else
        if cpuid0 = 'GenuineIntel' then
         begin
          cpu := iPentium;
          case cpuid1_.Model of
           0 : cpu_Type := 'Intel Pentium (A-step)';
           1 : cpu_Type := 'Intel Pentium';
           2 : begin
                cpu_Type := 'Intel iP54C';
                cpu := iP54C;
               end;
           3 : cpu_Type := 'Intel iP24T';
           4 : cpu_Type := 'Intel OverDrive for Pentium 3.3v';
           5 : cpu_Type := 'Intel OverDrive for i486DX4';
           6 : cpu_Type := 'Intel OverDrive for Pentium 5v';
           7 : begin
                cpu_Type := 'Intel iP54C (> 133MHz)';
                cpu := iP54C;
               end;
          else
           if (cpuid1_.Extra and 3) = 1 then
            cpu_Type := 'Intel Pentium OverDrive'
           else
           if (cpuid1_.Extra and 3) = 2 then
            cpu_Type := 'Auxiliary iP54C (SMP)'
           else
            cpu_Type := 'Intel Pentium';
          end; { case }
          exit;
         end; { begin }
       end;
    6: { P6 }
       begin
        cpu := iPentiumPro;
        case cpuid1_.Model of
         0 :
             begin
              cpu_Type := 'Intel PentiumPro (P6) A-Step';
              exit;
             end;
         1 : begin
              cpu_Type := 'Intel Pentium Pro (P6)';
              exit;
             end;
         3 : begin
              if (cpuid1_.Extra and 3) = 1 then
               cpu_Type := 'Intel Pentium Pro OverDrive'
              else
               cpu_Type := 'Intel Pentium Pro (P6)';
              exit;
             end;
         4 : begin
              cpu_Type := 'Intel iP55CT (OverDrive for iP54C socket)';
              exit;
             end;
        end; { case }
       end;
    7: { P7 }
       begin
        cpu := iP7;
       end;
   end; { case }
   end; { if }
  case cpu of
{$IFNDEF DPMI}
 {$IFNDEF WINDOWS}
  { Under Windows or DPMI it is not necessary to check for CPUs below 80286 -
    neither of them work on these CPUs. }
   i8088 :      cpu_Type := 'Intel 8088';
   i8086 :      cpu_Type := 'Intel 8086';
   i80C88:      cpu_Type := 'Intel 80C88';
   i80C86:      cpu_Type := 'Intel 80C86';
   i80188:      cpu_Type := 'Intel 80188';
   i80186:      cpu_Type := 'Intel 80186';
   necV20:      cpu_Type := 'NEC V20';
   necV30:      cpu_Type := 'NEC V30';
 {$ENDIF}
{$ENDIF}
   i80286:      cpu_Type := 'Intel 80286';
   i80386sx:    cpu_Type := 'Intel 80386SX';
   i80386dx:    cpu_Type := 'Intel 80386DX';
   i386sl:      cpu_Type := 'Intel i386SL';
   ibm386slc:   cpu_Type := 'IBM 386SLC';
   am386sx:     cpu_Type := 'AMD Am386SX';
   am386dx:     cpu_Type := 'AMD Am386DX';
   ct38600:     cpu_Type := 'C&T 38600';
   ct38600SX:   cpu_Type := 'C&T 38600SX';
   RapidCAD:    cpu_Type := 'Intel RapidCAD';
   i486sx:      cpu_Type := 'Intel i486SX';
   i486dx:      cpu_Type := 'Intel i486DX or i487SX';
   ibm486slc:   cpu_Type := 'IBM 486SLC';
   ibm486slc2:  cpu_Type := 'IBM 486SLC2';
   ibm486bl3:   cpu_Type := 'IBM 486BL3 (Blue Lightning)';
   Cx486:       cpu_Type := CyrixModel;
   umcU5S:      cpu_Type := 'UMC U5S';
   umcU5D:      cpu_Type := 'UMC U5SD';
   am486:       cpu_Type := 'AMD Am486 (undistinguished model)';
   CxM1:        cpu_Type := CyrixModel;
   amdK5:       cpu_Type := 'AMD K5';
   amdK6:       cpu_Type := 'AMD K6';
   Nx586:       cpu_Type := 'NexGen Nx586';
   iPentiumPro: cpu_Type := 'Intel Pentium Pro (P6)';
   iP7:         cpu_Type := 'Intel P7 (wow!)';
  else
   cpu_Type := 'Unknown CPU';
  end;

 end;

function fpu_Type;
 begin
  if fpu = $FF then
   begin
    cpu_Type;
    getFPUType;
   end;
  if (extFlags and efHasFPUonChip) <> 0 then
   fpu := fpuInternal;
  if (extFlags and efEmulatedFPU) <> 0 then
   begin
    fpu_Type := 'Emulated (386+)';
    exit;
   end;
  case fpu of
   fpuInternal: fpu_Type := 'Internal';
   fpuNone:     fpu_Type := 'None';
   i8087:       fpu_Type := 'Intel 8087';
   i80287:      fpu_Type := 'Intel 80287';
   i80287xl:    fpu_Type := 'Intel 80287XL';
   i80387:      fpu_Type := 'Intel 80387';
   rCAD:        fpu_Type := 'Intel RapidCAD';
   cx287:       fpu_Type := 'Cyrix 82x87';
   cx387:       fpu_Type := 'Cyrix 83x87';
   cx487:       fpu_Type := 'Cyrix 84x87';
   cxEMC87:     fpu_Type := 'Cyrix EMC87';
   iit287:      fpu_Type := 'IIT 2C87';
   iit387:      fpu_Type := 'IIT 3C87';
   iit487:      fpu_Type := 'IIT 4C87';
   ct387:       fpu_Type := 'C&T 38700';
   ulsi387:     fpu_Type := 'ULSI 83x87';
   ulsi487:     fpu_Type := 'ULSI 84x87';
   i487sx:      fpu_Type := 'Intel i487sx (integrated)';
   Nx587:       fpu_Type := 'NexGen Nx587';
  else
   fpu_Type := 'Unknown FPU';
  end;
 end;

function cpu_Speed;
 begin
  if cpu = $FF then
   cpu_Type; { we need to call this routine instead of getCPUType because some
               distinguishing also occurs here and CPU timings are based on
               detected CPU type. }
  cpu_Speed := ((speedTable[cpu]*LongInt(speedShift)) div Speed + 5) div 10;
 end;

function fcpu_Speed;
{ the same as cpu_Speed, but uses Real calculations }
 begin
  if cpu = $FF then
   cpu_Type;
   fcpu_Speed := ((speedTable[cpu]*LongInt(speedShift)) / Speed + 5) / 10;
 end;

end.
