
program ScreenSaver1;
{ Screen-saver kind of plot-routine, by Bas van Gaalen, Holland, PD }
uses
  crt,dos;

const
  F       = 5;
  Dots    = 75;
  SinLen1 = 600;
  SinLen2 = 300;
  SinAmp1 = 49;
  SinAmp2 = 39;
  SinOfs1 = 50;
  SinOfs2 = 50;
  Xstep1  = 2;
  Xstep2  = 3;
  Ystep1  = 3;
  Ystep2  = 2;
  Xspeed1 = 3;
  Xspeed2 = 2;
  Yspeed1 = 2;
  Yspeed2 = 3;

var
  SinTab1 : array[0..SinLen1] of byte;
  SinTab2 : array[0..SinLen2] of byte;

{----------------------------------------------------------------------------}

procedure SetGraphics(Mode : word); assembler; asm
  mov ax,Mode; int 10h end;

{----------------------------------------------------------------------------}

procedure InitColors;

var
  I : byte;

begin
  for I := 0 to 63 do begin
    port[$3C8] := I;
    port[$3C9] := I div 3;
    port[$3C9] := I div 2;
    port[$3C9] := I div 2;
  end;
end;

{----------------------------------------------------------------------------}

procedure CalcSinus;

var
  I : word;

begin
  for I := 0 to SinLen1 do SinTab1[I] := round(sin(I*(4*pi)/SinLen1)*SinAmp1)+SinOfs1;
  for I := 0 to SinLen2 do SinTab2[I] := round(sin(I*(4*pi)/SinLen2)*SinAmp2)+SinOfs2;
end;

{----------------------------------------------------------------------------}

procedure Plotter;

const
  StartCount = 150;

var
  Xst1,Xst2,Yst1,Yst2,I,J,OffSet,OnSet : word;
  K : byte;

begin
  randomize;
  Xst1 := 50; Xst2 := 130; Yst1 := 0; Yst2 := 70;
  repeat
    while (port[$3da] and 8) <> 0 do;
    while (port[$3da] and 8) = 0 do;
    for J := 0 to 9 do
      for I := 0 to Dots do begin
        OffSet := ((SinTab1[(Yst1+I*Ystep1) mod SinLen1]+SinTab2[(Yst2+I*Ystep2) mod SinLen2])*320)+
          (SinTab1[(Xst1+I*Xstep1) mod SinLen1])+(SinTab2[(Xst2+I*Xstep2) mod SinLen2])+60;
        OnSet := ((SinTab1[(Yst1+Yspeed1*F*J+I*Ystep1) mod SinLen1]+SinTab2[(Yst2+Yspeed2*F*J+I*Ystep2) mod SinLen2])*320)+
          (SinTab1[(Xst1+Xspeed1*F*J+I*Xstep1) mod SinLen1])+(SinTab2[(Xst2+Xspeed2*F*J+I*Xstep2) mod SinLen2])+60;
        mem[$a000:OffSet] := 0;
        mem[$a000:OnSet] := 18+5*J;
      end;
    Xst1 := (Xst1+Xspeed1) mod SinLen1;
    Xst2 := (Xst2+Xspeed2) mod SinLen2;
    Yst1 := (Yst1+Yspeed1) mod SinLen1;
    Yst2 := (Yst2+Yspeed2) mod SinLen2;
  until keypressed;
end;

{----------------------------------------------------------------------------}

begin
  SetGraphics($13);
  CalcSinus;
  InitColors;
  Plotter;
  textmode(lastmode);
end.
