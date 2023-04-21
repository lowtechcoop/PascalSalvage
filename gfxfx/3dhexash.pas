
{$r-}
program polygoned_and_shaded_hexagon; { inclusief clipping test! }
uses
  crt,threedee;
const
  divd=128;
  dist=200;
  point:array[0..11,0..2] of integer=(
    (-20,-20, 30),( 20,-20, 30),( 40,-40,  0),( 20,-20,-30),
    (-20,-20,-30),(-40,-40,  0),(-20, 20, 30),( 20, 20, 30),
    ( 40, 40,  0),( 20, 20,-30),(-20, 20,-30),(-40, 40,  0));
  planes:array[0..9,0..3] of byte=(
    (0,1,7,6),(1,2,8,7),(9,8,2,3),(10,9,3,4),(10,4,5,11),
    (6,11,5,0),(0,1,2,5),(5,2,3,4),(6,7,8,11),(11,8,9,10));
var
  polyz:array[0..9] of integer;
  pind:array[0..9] of byte;

{ -------------------------------------------------------------------------- }

procedure quicksort(lo,hi:integer);

procedure sort(l,r:integer);
var i,j,x,y:integer;
begin
  i:=l; j:=r; x:=polyz[(l+r) div 2];
  repeat
    while polyz[i]<x do inc(i);
    while x<polyz[j] do dec(j);
    if i<=j then begin
      y:=polyz[i]; polyz[i]:=polyz[j]; polyz[j]:=y;
      y:=pind[i]; pind[i]:=pind[j]; pind[j]:=y;
      inc(i); dec(j);
    end;
  until i>j;
  if l<j then sort(l,j);
  if i<r then sort(i,r);
end;

begin
  sort(lo,hi);
end;

{ -------------------------------------------------------------------------- }

procedure rotate_cube;
const xst=1; yst=2; zst=-3;
var xp,yp,z:array[0..11] of integer; x,y,i,j,k:integer; n,Key,phix,phiy,phiz:byte;
begin
  phix:=0; phiy:=0; phiz:=0;
  fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);
  repeat
    {retrace;}
    setborder(10);
    {
    for n:=5 to 9 do
      polygon(xp[planes[pind[n],0]],yp[planes[pind[n],0]],
              xp[planes[pind[n],1]],yp[planes[pind[n],1]],
              xp[planes[pind[n],2]],yp[planes[pind[n],2]],
              xp[planes[pind[n],3]],yp[planes[pind[n],3]],0);
    }
    cls(virseg);
    for n:=0 to 11 do begin
      i:=(cosinus(phiy)*point[n,0]-sinus(phiy)*point[n,2]) div divd;
      j:=(cosinus(phiz)*point[n,1]-sinus(phiz)*i) div divd;
      k:=(cosinus(phiy)*point[n,2]+sinus(phiy)*point[n,0]) div divd;
      x:=(cosinus(phiz)*i+sinus(phiz)*point[n,1]) div divd;
      y:=(cosinus(phix)*j+sinus(phix)*k) div divd;
      z[n]:=(cosinus(phix)*k-sinus(phix)*j) div divd+cosinus(phix) div 3;
      xp[n]:=160+sinus(phix)+(-x*dist) div (z[n]-dist);
      yp[n]:=100+cosinus(phix) div 2+(-y*dist) div (z[n]-dist);
    end;
    for n:=0 to 9 do begin
      polyz[n]:=(z[planes[n,0]]+z[planes[n,1]]+z[planes[n,2]]+z[planes[n,3]]) div 4;
      pind[n]:=n;
    end;
    quicksort(0,9);
    for n:=5 to 9 do
      polygon(xp[planes[pind[n],0]],yp[planes[pind[n],0]],
              xp[planes[pind[n],1]],yp[planes[pind[n],1]],
              xp[planes[pind[n],2]],yp[planes[pind[n],2]],
              xp[planes[pind[n],3]],yp[planes[pind[n],3]],polyz[n]+55);
    inc(phix,xst); inc(phiy,yst); inc(phiz,zst);
    setborder(0);
    flip(virseg,vidseg);
  until keypressed;
end;

{ -------------------------------------------------------------------------- }

var i:word;
begin
  asm mov ax,13h; int 10h; end;
  getmem(virscr,64000);
  virseg:=seg(virscr^);
  cls(virseg);
  for i:=0 to 255 do stab[i]:=round(sin(i*pi/128)*divd);
  {for i:=1 to 150 do setpal(i,10+i div 5,30+i div 5,10+i div 5);}
  for i:=1 to 150 do setpal(i,i div 4,i div 2,i div 4);
  rotate_cube;
  freemem(virscr,64000);
  textmode(lastmode);
end.

{ a non-mode-x version }
