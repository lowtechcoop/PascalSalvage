
program _Plotter;

uses
  crt,dos,graph;

{$I SVGA256.INC}

const
  F      = 5;
  Dots   = 75;
  SLen1  = 450;
  SLen2  = 300;
  SAmp1  = 60;
  SAmp2  = 40;
  SOfs1  = 60;
  SOfs2  = 40;
  Xstep1 = 1;
  Xstep2 = 2;
  Ystep1 = 3;
  Ystep2 = 2;
  Xspd1  = 4;
  Xspd2  = 5;
  Yspd1  = 3;
  Yspd2  = 5;

var
  STab1 : array[0..SLen1] of word;
  STab2 : array[0..SLen2] of word;

{----------------------------------------------------------------------------}

procedure Setvideo; var GrMd,GrDr : integer;

{$F+} function DetectVGA : Integer; begin DetectVGA := 2; end; {$F-}

begin
  InstallUserDriver('SVGA256',@DetectVGA); GrDr := Detect;
  InitGraph(GrDr,GrMd,'I:\BGI');
end;

{----------------------------------------------------------------------------}

procedure InitColors; var I : byte;

begin
  for I := 1 to 63 do begin
    port[$3C8] := I;
    port[$3C9] := 5+I div 2;
    port[$3C9] := 15+I div 2;
    port[$3C9] := I;
  end;
end;

{----------------------------------------------------------------------------}

procedure CalcSinus; var I : word;

begin
  for I := 0 to SLen1 do STab1[I] := round(sin(I*(4*pi)/SLen1)*SAmp1)+SOfs1;
  for I := 0 to SLen2 do STab2[I] := round(sin(I*(4*pi)/SLen2)*SAmp2)+SOfs2;
end;

{----------------------------------------------------------------------------}

procedure Plotter;

var
  Xst1,Xst2,Yst1,Yst2,I,J,Xon,Yon,Xoff,Yoff : word;

begin
  randomize;
  Xst1 := 25; Xst2 := 0; Yst1 := 0; Yst2 := 20;
  repeat
    for J := 0 to 7 do
      for I := 0 to Dots do begin
        Yoff := STab1[(Yst1+I*Ystep1) mod SLen1]+STab2[(Yst2+I*Ystep2) mod SLen2];
        Xoff := STab1[(Xst1+I*Xstep1) mod SLen1]+STab2[(Xst2+I*Xstep2) mod SLen2];
        Yon := STab1[(Yst1+Yspd1*F*J+I*Ystep1) mod SLen1]+STab2[(Yst2+Yspd2*F*J+I*Ystep2) mod SLen2];
        Xon := STab1[(Xst1+Xspd1*F*J+I*Xstep1) mod SLen1]+STab2[(Xst2+Xspd2*F*J+I*Xstep2) mod SLen2];
        putpixel(Xoff,Yoff,0);
        putpixel(Xon,Yon,18+5*J);
      end;
    Xst1 := (Xst1+Xspd1) mod SLen1;
    Xst2 := (Xst2+Xspd2) mod SLen2;
    Yst1 := (Yst1+Yspd1) mod SLen1;
    Yst2 := (Yst2+Yspd2) mod SLen2;
  until keypressed;
end;

{----------------------------------------------------------------------------}

begin
  Setvideo;
  CalcSinus;
  InitColors;
  Plotter;
  textmode(lastmode);
end.
