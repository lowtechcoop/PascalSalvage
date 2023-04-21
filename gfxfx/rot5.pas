
{$N+}

program Rotation;
{ 3d rotating plane, uses slow math somewhere, by Bas van Gaalen, Holland, PD }
{ SVGABGI... }
uses
  dos,crt,graph;

const
  NofPoints = 99;
  Speed = 1;
  Xc : word = 0;
  Yc : word = 0;
  Zc : word = 500;
  SinTab : array[0..255] of integer = (
    0,3,6,9,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58,60,63,66,68,
    71,74,76,79,81,84,86,88,91,93,95,97,99,101,103,105,106,108,110,111,
    113,114,116,117,118,119,121,122,122,123,124,125,126,126,127,127,127,
    128,128,128,128,128,128,128,127,127,127,126,126,125,124,123,122,122,
    121,119,118,117,116,114,113,111,110,108,106,105,103,101,99,97,95,93,
    91,88,86,84,81,79,76,74,71,68,66,63,60,58,55,52,49,46,43,40,37,34,31,
    28,25,22,19,16,13,9,6,3,0,-3,-6,-9,-13,-16,-19,-22,-25,-28,-31,-34,
    -37,-40,-43,-46,-49,-52,-55,-58,-60,-63,-66,-68,-71,-74,-76,-79,-81,
    -84,-86,-88,-91,-93,-95,-97,-99,-101,-103,-105,-106,-108,-110,-111,
    -113,-114,-116,-117,-118,-119,-121,-122,-122,-123,-124,-125,-126,
    -126,-127,-127,-127,-128,-128,-128,-128,-128,-128,-128,-127,-127,
    -127,-126,-126,-125,-124,-123,-122,-122,-121,-119,-118,-117,-116,
    -114,-113,-111,-110,-108,-106,-105,-103,-101,-99,-97,-95,-93,-91,
    -88,-86,-84,-81,-79,-76,-74,-71,-68,-66,-63,-60,-58,-55,-52,-49,
    -46,-43,-40,-37,-34,-31,-28,-25,-22,-19,-16,-13,-9,-6,-3);

type
  PointRec = record
               X,Y,Z : integer;
             end;
  PointPos = array[0..NofPoints] of PointRec;

var
  Point : PointPos;

{----------------------------------------------------------------------------}

procedure SetGraphics;
var GrMd,GrDr : integer;

{$F+} function DetectVGA : Integer; begin DetectVGA := 2; end; {$F-}

begin
  InstallUserDriver('SVGA256',@DetectVGA); GrDr := 0;
  InitGraph(GrDr,GrMd,'i:\bgi');
end;

{----------------------------------------------------------------------------}

procedure Init;

var
  x,z : integer; i : byte;

begin
  {randomize;
  for I := 0 to NofPoints do begin
    Point[I].X := random(300)-150;
    Point[I].Y := random(300)-150;
    Point[I].Z := random(300)-150;
  end;}

  i := 0;
  z := -150;
  while z < 150 do begin
    x := -150;
    while x < 150 do begin
      point[i].x := x;
      point[i].y := 100;
      point[i].z := z;
      inc(i);
      inc(x,30);
    end;
    inc(z,30);
  end;

  for I := 1 to 63 do begin
    port[$3C8] := I;
    port[$3C9] := I;
    port[$3C9] := I;
    port[$3C9] := 0;
  end;
end;

{----------------------------------------------------------------------------}

function Sinus(Idx : byte) : integer; begin
  Sinus := SinTab[Idx]; end;

{----------------------------------------------------------------------------}

function Cosin(Idx : byte) : integer; begin
  Cosin := SinTab[(Idx+192) mod 255]; end;

{----------------------------------------------------------------------------}

procedure Rotate;

const
  Xstep = -1;
  Ystep = 1;
  Zstep = 1;

var
  Xp,Yp : array[0..NofPoints] of word;
  X,Y,Z,X1,Y1,Z1 : integer;
  I : word;
  PhiX,PhiY,PhiZ : byte;

begin
  PhiX := 30; PhiY := 60; PhiZ := 90;
  repeat
    while (port[$3da] and 8) <> 8 do;
    while (port[$3da] and 8) = 8 do;

    {port[$3c8] := 0; port[$3c9] := 0; port[$3c9] := 0; port[$3c9] := 25;}

    for I := 0 to NofPoints do begin

      if (Xp[I] < 640) and (Yp[I] < 480) then
        putpixel(Xp[I],Yp[I],0);

      X1 := (Cosin(PhiY)*Point[I].X-Sinus(PhiY)*Point[I].Z) div 128;
      Y1 := (Cosin(PhiZ)*Point[I].Y-Sinus(PhiZ)*X1) div 128;
      Z1 := (Cosin(PhiY)*Point[I].Z+Sinus(PhiY)*Point[I].X) div 128;
      X  := (Cosin(PhiZ)*X1+Sinus(PhiZ)*Point[I].Y) div 128;
      Y  := (Cosin(PhiX)*Y1+Sinus(PhiX)*Z1) div 128;
      Z  := (Cosin(PhiX)*Z1-Sinus(PhiX)*Y1) div 128;
      Xp[I] := 320+(Xc*Z-X*Zc) div (Z-Zc);
      Yp[I] := 240+(Yc*Z-Y*Zc) div (Z-Zc);

      if (Xp[I] < 640) and (Yp[I] < 480) then
        putpixel(Xp[I],Yp[I],31+round(Z/10));

    end;
    inc(PhiX,Xstep);
    inc(PhiY,Ystep);
    inc(PhiZ,Zstep);

    {port[$3c8] := 0; port[$3c9] := 0; port[$3c9] := 0; port[$3c9] := 0;}

  until keypressed;
end;

{----------------------------------------------------------------------------}

begin
  SetGraphics;
  Init;
  Rotate;
  textmode(lastmode);
end.
