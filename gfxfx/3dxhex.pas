
{$r-} { <--- Need, eh? ;-) }
program polygoned_and_shaded_octagon; { inc. clipping }
{ mode-x version of polygoned objects, by Bas van Gaalen & Sven van Heel }
uses crt,x3dunit;
const
  nofpolys=9; { number of polygons -1 }
  nofpoints=11; { number of points -1 }
  point:array[0..nofpoints,0..2] of integer=(
    (-20,-20, 30),( 20,-20, 30),( 40,-40,  0),( 20,-20,-30),
    (-20,-20,-30),(-40,-40,  0),(-20, 20, 30),( 20, 20, 30),
    ( 40, 40,  0),( 20, 20,-30),(-20, 20,-30),(-40, 40,  0));
  planes:array[0..nofpolys,0..3] of byte=(
    (0,1,7,6),(1,2,8,7),(9,8,2,3),(10,9,3,4),(10,4,5,11),
    (6,11,5,0),(0,1,2,5),(5,2,3,4),(6,7,8,11),(11,8,9,10));
type polytype=array[0..nofpolys] of integer;
var polyz,pind:polytype;

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
const xst=1; yst=1; zst=-1;
var
  xp,yp,z:array[0..nofpoints] of integer;
  x,y,i,j,k:integer;
  n,key,phix,phiy,phiz:byte;
begin
  address := 0;
  phix:=0; phiy:=0; phiz:=0;
  fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);
  fillchar(z,sizeof(z),0);
  repeat
    retrace;
    setborder(60);
    for n:=0 to nofpoints do begin
      i:=(cosinus(phiy)*point[n,0]-sinus(phiy)*point[n,2]) div divd;
      j:=(cosinus(phiz)*point[n,1]-sinus(phiz)*i) div divd;
      k:=(cosinus(phiy)*point[n,2]+sinus(phiy)*point[n,0]) div divd;
      x:=(cosinus(phiz)*i+sinus(phiz)*point[n,1]) div divd;
      y:=(cosinus(phix)*j+sinus(phix)*k) div divd;
      z[n]:=(cosinus(phix)*k-sinus(phix)*j) div divd;
      xp[n]:=160+cosinus(phix)+(-x*dist) div (z[n]-dist);
      yp[n]:=100-sinus(phiy) div 2+(-y*dist) div (z[n]-dist);
    end;
    for n:=0 to nofpolys do begin
      polyz[n]:={(}z[planes[n,0]]+z[planes[n,1]]+z[planes[n,2]]+z[planes[n,3]]{) div 4};
      pind[n]:=n;
    end;
    quicksort(0,nofpolys);
    address:=16000-address;
    setaddress(address);
    cls;
    for n:=5 to nofpolys do
      polygon(xp[planes[pind[n],0]],yp[planes[pind[n],0]],
              xp[planes[pind[n],1]],yp[planes[pind[n],1]],
              xp[planes[pind[n],2]],yp[planes[pind[n],2]],
              xp[planes[pind[n],3]],yp[planes[pind[n],3]],polyz[n]+64);
    inc(phix,xst); inc(phiy,yst); inc(phiz,zst);
    setborder(0);
  until keypressed;
end;

{ -------------------------------------------------------------------------- }

var i:byte;
begin
  setmodex;
  {border:=true;}
  for i:=1 to 255 do setpal(i,i div 16,i div 8,i div 4);
  rotate_cube;
  textmode(lastmode);
end.

{ Mode-x version! Quite final, except for major asm updates.
  Realy smooth and fast (relative to the 13h version)! }
