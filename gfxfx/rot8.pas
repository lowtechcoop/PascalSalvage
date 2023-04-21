
program Rotation;
{ Improved cube (rot2), using BGI and pageswapping, by Bas van Gaalen, Holland, PD }
uses
  crt,graph;

const
  GraphPath = 'I:\BGI';

  Xc = 0;
  Yc = 0;
  Zc = 150;
  Point : array[0..7,0..2] of integer = (
    (-50,50,50),(50,50,50),(50,-50,50),(-50,-50,50),
    (-50,50,-50),(50,50,-50),(50,-50,-50),(-50,-50,-50));
  Lines : array[0..11,0..1] of byte = (
    (0,1),(1,2),(2,3),(3,0),(0,4),(1,5),(2,6),(3,7),(4,5),(5,6),(6,7),(7,4));

type
  TabType = array[0..255] of integer;

var
  SinTab : TabType;

{----------------------------------------------------------------------------}

procedure Setvideo;

var
  GrDr,GrMd,Err : integer;

begin
  GrMd := 1; GrDr := 0;
  initGraph(GrDr,GrMd,GraphPath);
  Err := graphresult;
  if Err <> 0 then begin
    writeln('Graphics error: ',grapherrormsg(Err));
    halt;
  end;
  setgraphmode(1);
end;

{----------------------------------------------------------------------------}

procedure Calcsinus(var SinTab : TabType); var I : byte; begin
  for I := 0 to 255 do SinTab[I] := round(sin(2*I*pi/255)*128); end;

{----------------------------------------------------------------------------}

function Sinus(Idx : byte) : integer; begin
  Sinus := SinTab[Idx]; end;

{----------------------------------------------------------------------------}

function Cosinus(Idx : byte) : integer; begin
  Cosinus := SinTab[(Idx+192) mod 255]; end;

{----------------------------------------------------------------------------}

procedure Rotate;

const
  Xstep = 1;
  Ystep = 1;
  Zstep = -1;

var
  Xp,Yp : array[0..7] of word;
  Xp2,Yp2 : array[0..7] of word;
  X,Y,Z,X1,Y1,Z1 : integer;
  I,PhiX,PhiY,PhiZ,Page : byte;

begin
  Page := 0; PhiX := 0; PhiY := 0; PhiZ := 0;
  for I := 0 to 7 do begin
    Xp[I] := 0; Yp[I] := 0; Xp2[I] := 0; Yp2[I] := 0; end;
  repeat
    Page := Page xor 1;
    setvisualpage(Page);
    setactivepage(Page xor 1);
    setcolor(black);
    for I := 0 to 11 do
      line(Xp2[Lines[I,0]],Yp2[Lines[I,0]],Xp2[Lines[I,1]],Yp2[Lines[I,1]]);

    move(Xp,Xp2,sizeof(Xp));
    move(Yp,Yp2,sizeof(Xp));

    for I := 0 to 7 do begin
      X1 := (Cosinus(PhiY)*Point[I,0]-Sinus(PhiY)*Point[I,2]) div 128;
      Y1 := (Cosinus(PhiZ)*Point[I,1]-Sinus(PhiZ)*X1) div 128;
      Z1 := (Cosinus(PhiY)*Point[I,2]+Sinus(PhiY)*Point[I,0]) div 128;
      X := (Cosinus(PhiZ)*X1+Sinus(PhiZ)*Point[I,1]) div 128;
      Y := (Cosinus(PhiX)*Y1+Sinus(PhiX)*z1) div 128;
      Z := (Cosinus(PhiX)*Z1-Sinus(PhiX)*Y1) div 128;
      Xp[I] := 320+(Xc*Z-X*Zc) div (Z-Zc);
      Yp[I] := 175+(Yc*Z-Y*Zc) div (Z-Zc);
    end;

    inc(PhiX,Xstep);
    inc(PhiY,Ystep);
    inc(PhiZ,Zstep);

    setvisualpage(Page);
    setactivepage(Page xor 1);

    setcolor(lightgreen);
    for I := 0 to 11 do
      line(Xp[Lines[I,0]],Yp[Lines[I,0]],Xp[Lines[I,1]],Yp[Lines[I,1]]);

    delay(15);

  until keypressed;
end;

{----------------------------------------------------------------------------}

begin
  Setvideo;
  Calcsinus(SinTab);
  Rotate;
  textmode(lastmode);
end.
