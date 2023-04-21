{$A+,B-,D+,E+,F-,G-,I+,L+,N+,O-,P-,Q-,R-,S+,T-,V+,X+}
{$M 16384,0,655360}

program Math;
{ 'Solar Simulator', version 0.001beta, by Bas van Gaalen and Sven van Heel }
{ Somewhere around early 1993 or late 1992 }
uses
  crt,graph;

const
  GridX   = 1.0E8;      { m/pixel }
  GridY   = 1.0E8;      { m/pixel }
  G       = 6.67E-11;   { NM^2kg^-2 }
  Msun    = 1.989E30;   { kg }
  {Mearth  = 4.976E24;} { kg }
  {SunSize = 696E6;}    { m }
  {EarthS  = 6.378E6;}  { m }
  {Dist    = 1.49E9;}   { m }

{----------------------------------------------------------------------------}

procedure InitGraphics;

var
  grDriver : integer;
  grMode   : integer;
  ErrCode  : integer;

begin
  grdriver := detect;
  initgraph(grdriver,grmode,'I:\BGI');
  errcode := graphresult;
  if errcode <> grok then writeln('Graphics error:',grapherrormsg(ErrCode));
end;

{----------------------------------------------------------------------------}

procedure Action;

const
  Time    = 60*1; { sec }

var
  I,
  PrevX,
  PrevY,
  SunX,
  SunY     : word;
  EarthX,
  EarthY,
  Dist,
  Angle,
  a,
  V,
  Vx,
  Vy,
  Rsubx,
  Rsuby    : extended;
  PrevStr,
  VStr,
  PrevDist,
  DistStr  : string;

begin
  SunX := 320; SunY := 240;
  EarthX := GridX*200; EarthY := GridY*150;

  putpixel(SunX,SunY,white);
  Vx := 45000; Vy := 0; { m/s }

  settextstyle(smallfont,horizdir,4);
  PrevStr := ''; PrevDist := ''; I := 0;
  setcolor(lightgray);
  outtextxy(0,470,'V:       km/s    Dist:         m');

  repeat
    putpixel(SunX+round(EarthX/GridX),SunY-round(EarthY/GridY),lightcyan);
    PrevX := SunX+round(EarthX/GridX);
    PrevY := SunY-round(EarthY/GridY);

    Dist := sqrt(sqr(EarthX)+sqr(EarthY));
    Angle := arctan(EarthY/EarthX);
    if (EarthX < 0) then Angle := Angle+pi;

    Vx := Vx+cos(Angle)*G*Msun*Time/sqr(Dist);
    Vy := Vy+sin(Angle)*G*Msun*Time/sqr(Dist);

    EarthX := EarthX-Vx*Time;
    EarthY := EarthY-Vy*Time;

    inc(I);
    if I = 100 then begin
      V := sqrt(sqr(Vx)+sqr(Vy));
      str(V/1000:7:2,Vstr);
      str(Dist/1e9:7:2,DistStr);
      setcolor(black);
      outtextxy(10,470,PrevStr);
      outtextxy(125,470,PrevDist+'e9');
      setcolor(lightgray);
      outtextxy(10,470,Vstr);
      outtextxy(125,470,DistStr+'e9');
      PrevStr := VStr;
      PrevDist := DistStr;
      I := 0;
    end;

    putpixel(round(PrevX),round(PrevY),darkgray);
  until keypressed;
end;

{----------------------------------------------------------------------------}

begin
  InitGraphics;
  Action;
  closegraph;
end.
