{$A+,B+,D-,E-,F-,G+,I-,L-,N-,O-,P-,Q-,R-,S-,T-,V-,X+,Y-}
{$M 20000,0,0}
program new;

uses dos,crt;

var   regs: Registers;
      pic: integer;      {drawn pictures}

{********************************************************}
procedure SetVideoMode (vMode: byte);

begin
  regs.ax := vMode;      {Bit 7 = 1: RAM nicht l”schen}
  Intr ($10,regs);
end;
{--------------------------------------------------------}
function GetVideoMode: byte;

begin
  regs.ah := $0F;
  intr ($10, regs);
  GetVideoMode := regs.al;
end;
{*********************************************************}
type  ColorValue = record R,G,B: byte; end;
      VGAPaletteType = array[0..255] of ColorValue;

procedure ReadPal (var pal: VGAPaletteType);

begin
  regs.AX := $1017;
  regs.BX := 0;
  regs.CX := 256;
  regs.ES := Seg(pal);
  regs.DX := Ofs(pal);
  repeat until Port[$03DA] And $08 = $08; {Wait for rescan}
  Intr ($10,regs);
end;
{--------------------------------------------------------}
procedure WritePal (var pal: VGAPaletteType);

begin
  regs.AX := $1012;
  regs.BX := 0;
  regs.CX := 256;
  regs.ES := Seg(pal);
  regs.DX := Ofs(pal);
  repeat until Port[$03DA] and $08 = $08; {Wait for rescan}
  Intr($10,regs);
end;
{*********************************************************}
{ Convert HSI (Hue, Saturation, Intensity) -> RGB }
{---------------------------------------------------------}
procedure Hsi2Rgb (H, S, I: Real; var C: ColorValue);

var   T, Rv, Gv, Bv: Real;

begin
  T  := H;
  Rv := 1 + S * Sin(T - 2 * Pi / 3);
  Gv := 1 + S * Sin(T);
  Bv := 1 + S * Sin(T + 2 * Pi / 3);
  T  := 63.999 * I / 2;
  c.R := trunc(Rv * T);
  c.G := trunc(Gv * T);
  c.B := trunc(Bv * T);
end;
{*********************************************************}
{ fast pixel drawing for graphic mode 320x200x256
{---------------------------------------------------------}
procedure PutPixel (x,y: integer; c: byte); assembler;
 asm
  mov ax,y
  mov bx,ax
  shl ax,8
  shl bx,6
  add bx,ax
  add bx,x
  mov ax,0a000h
  mov es,ax
  mov al,c
  mov es:[bx],al
 end;
{--------------------------------------------------------}
function GetPixel (x,y: integer): byte;

begin
 asm
  mov ax,y
  mov bx,ax
  shl ax,8
  shl bx,6
  add bx,ax
  add bx,x
  mov ax,0a000h
  mov es,ax
  mov al,es:[bx]
  mov @result,al
 end;
end;

procedure MakePal;

const maxColor = 110;

var   ni: integer;   pal: VGAPaletteType;

begin
  FillChar (pal, SizeOf (pal), 0);
  for ni := 1 to MaxColor
  do HSI2RGB (4.6-1.5*ni/MaxColor, ni/MaxColor, ni/MaxColor, pal[ni]);
  for ni := MaxColor to 255
  do begin
    pal[ni] := pal[ni-1];
    With pal[ni] do
    begin
      if R < 63 then Inc(R);
      if R < 63 then Inc(R);
      if (ni Mod 2=0) And (G<53) then Inc(G);
      if (ni Mod 2=0) And (B<63) then Inc(B);
    end;
  end;
  WritePal (pal);
end;


procedure DrawPaletteScreen;

var   xi, yi: integer; maxY,maxX: byte;
begin
  maxY := 20  ;
  maxX := 20  ;
  MakePal;
  for yi := 0 to maxY
  do for xi := 0 to maxX do PutPixel (xi,yi,yi);
end;

{********************************************************}

var   lastMode: byte;

begin
  lastMode := GetVideoMode;  {save video mode}
  SetVideoMode ($13);

  DrawPaletteScreen;

{  StartBurning (120, 100);   {fire simulation}



  SetVideoMode (lastMode);   {Restore video mode}
end.