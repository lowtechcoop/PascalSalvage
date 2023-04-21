
{$r-} { <- seems to improve speed A LOT! }
program GraphicScroll;
{ Spiral scroll, by Bas van Gaalen, Holland, PD }
uses
  crt,dos;

const
  Amp    = 22;
  Bits   : array[0..7] of byte = (128,64,32,16,8,4,2,1);
  Color  : array[0..7] of byte = (blue,lightblue,cyan,lightcyan,lightcyan,cyan,lightblue,blue);
  ScrTxt : string = 'HOWDY FOLKS, THIS SEEMS TO WORK...         ';

var
  Font8x8Seg,
  Font8x8Ofs  : word;
  SinTab      : array[0..320] of word;
  ChrTab      : array[0..320] of byte;
  ColTab      : array[0..320] of byte;

{----------------------------------------------------------------------------}

procedure GetFont8x8(var Segment,Offset : word);

var
  Reg : Registers;

begin
  Reg.AX := $1130;
  Reg.BH := 3;
  Intr($10,Reg);
  Segment := Reg.ES;
  Offset := Reg.BP;
end;

{----------------------------------------------------------------------------}

procedure VideoMode(Mode : byte); assembler;

asm
  mov AH,00
  mov AL,Mode
  int 10h
end;

{----------------------------------------------------------------------------}

procedure CalcSin;

var
  I    : word;
  X,
  Step : real;

begin
  Step := 5*pi/320;
  I := 0;
  while I <= 320 do begin
    SinTab[I] := round(sin(I*Step)*Amp)+amp;
    if cos(I*Step) <= 0 then ColTab[I] := cyan else ColTab[I] := lightcyan;
    inc(I);
  end;
end;

{----------------------------------------------------------------------------}

procedure Scroll(Segment,Offset : word);

var
  J,
  Ofs,
  TxtPos    : word;
  CharPos,
  I,K,
  Character : byte;

begin
  TxtPos := 1;
  repeat
    CharPos := 0;
    Character := ord(ScrTxt[TxtPos]);
    I := 0;
    while I < 8 do begin
      for J := 0 to 319 do ChrTab[J] := ChrTab[J+1];
      ChrTab[320] := mem[Font8x8Seg:Font8x8Ofs+(8*Character)+I];

      while (port[$3da] and 8) <> 0 do;
      while (port[$3da] and 8) = 0 do;

      for J := 1 to 312 do
        for K := 0 to 7 do begin
          Ofs := (190-(2*Amp)+SinTab[J])*320+J+K;
          if ChrTab[J] and Bits[K] <> 0 then
            mem[$A000:Ofs] := ColTab[J]
          else {if SinTab[J] <> SinTab[J-1] then} mem[$A000:Ofs] := black;
        end;
      inc(I);
    end;

    inc(TxtPos);
    if TxtPos = length(ScrTxt) then TxtPos := 1;
  until keypressed;
end;

{----------------------------------------------------------------------------}

begin
  Videomode($13);
  CalcSin;
  GetFont8x8(Font8x8Seg,Font8x8Ofs);
  Scroll(Font8x8Seg,Font8x8Ofs);
end.
