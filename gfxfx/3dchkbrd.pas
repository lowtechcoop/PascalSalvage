
{$r-}
program polygoned_and_shaded_modex_octagon; { inclusief clipping test! }
{ hline routine by Sean Palmer }
uses
  crt,x3dunit;
const
  point:array[0..35,0..2] of integer=(
  (-50,-50,20),(-30,-50,20),(-10,-50,20),(10,-50,20),(30,-50,20),(50,-50,20),
  (-50,-30,20),(-30,-30,20),(-10,-30,20),(10,-30,20),(30,-30,20),(50,-30,20),
  (-50,-10,20),(-30,-10,20),(-10,-10,20),(10,-10,20),(30,-10,20),(50,-10,20),
  (-50,10,20),(-30,10,20),(-10,10,20),(10,10,20),(30,10,20),(50,10,20),
  (-50,30,20),(-30,30,20),(-10,30,20),(10,30,20),(30,30,20),(50,30,20),
  (-50,50,20),(-30,50,20),(-10,50,20),(10,50,20),(30,50,20),(50,50,20));
  planes:array[0..12,0..3] of byte=(
  (0,1,7,6),(2,3,9,8),(4,5,11,10),(7,8,14,13),(9,10,16,15),
  (12,13,19,18),(14,15,21,20),(16,17,23,22),(19,20,26,25),
  (21,22,28,27),(24,25,31,30),(26,27,33,32),(28,29,35,34));
var polyz:array[0..12] of integer; pind:array[0..12] of byte;

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
const
  xst=-1; yst=-1; zst=2;
var
  xp,yp,z:array[0..35] of integer;
  x,y,i,j,k:integer;
  n,Key,phix,phiy,phiz:byte;
begin
  address := 0;
  phix:=50; phiy:=150; phiz:=20;
  fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);
  fillchar(z,sizeof(z),0);
  repeat
    retrace;
    setborder(1);
    for n:=0 to 35 do begin
      i:=(cosinus(phiy)*point[n,0]-sinus(phiy)*point[n,2]) div divd;
      j:=(cosinus(phiz)*point[n,1]-sinus(phiz)*i) div divd;
      k:=(cosinus(phiy)*point[n,2]+sinus(phiy)*point[n,0]) div divd;
      x:=(cosinus(phiz)*i+sinus(phiz)*point[n,1]) div divd;
      y:=(cosinus(phix)*j+sinus(phix)*k) div divd;
      z[n]:=(cosinus(phix)*k-sinus(phix)*j) div divd;
      xp[n]:=160+(-x*dist) div (z[n]-dist);
      yp[n]:=100+(-y*dist) div (z[n]-dist);
    end;
    for n:=0 to 12 do begin
      polyz[n]:=(z[planes[n,0]]+z[planes[n,1]]+z[planes[n,2]]+z[planes[n,3]]) div 4;
      pind[n]:=n;
    end;
    quicksort(0,12);
    address:=16000-address;
    setaddress(address);
    cls;
    for n:=0 to 12 do
      polygon(xp[planes[pind[n],0]],yp[planes[pind[n],0]],
              xp[planes[pind[n],1]],yp[planes[pind[n],1]],
              xp[planes[pind[n],2]],yp[planes[pind[n],2]],
              xp[planes[pind[n],3]],yp[planes[pind[n],3]],1);
    inc(phix,xst); inc(phiy,yst); inc(phiz,zst);
    setborder(0);
  until keypressed;
end;

{ -------------------------------------------------------------------------- }

var i,j:byte;
begin
  setmodex;
  border:=true;
  setpal(1,20,30,40);
  rotate_cube;
  textmode(lastmode);
end.

{ Runs too slow on a 386, actualy needs a 486 or a major update in asm. ;-) }
