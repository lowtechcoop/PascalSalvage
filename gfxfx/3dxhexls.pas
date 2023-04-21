
{$r-,n+,e-}
program polygoned_and_shaded_octagon;
{ 3d real object with real light source, NOT! ;-) }
uses
  crt,x3dunit;
const
  nofpolys=9; { number of polygons -1 }
  nofpoints=11; { number of points -1 }
  lscoords:record x,y,z:word; end=(x:0; y:0; z:100); { light source coords }
  point:array[0..nofpoints,0..2] of integer=(
    (-20,-20, 30),( 20,-20, 30),( 40,-40,  0),( 20,-20,-30),
    (-20,-20,-30),(-40,-40,  0),(-20, 20, 30),( 20, 20, 30),
    ( 40, 40,  0),( 20, 20,-30),(-20, 20,-30),(-40, 40,  0));
  planes:array[0..nofpolys,0..3] of byte=(
    (0,1,7,6),(1,2,8,7),(9,8,2,3),(10,9,3,4),(10,4,5,11),
    (6,11,5,0),(0,1,2,5),(5,2,3,4),(6,7,8,11),(11,8,9,10));
type
  polytype=array[0..nofpolys] of integer;
var
  polyz,pind:polytype;

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
const xst=0.08; yst=0.02; zst=-0.03;
var
  xp,yp,zp:array[0..nofpoints] of integer;
  x,y,z,i,j,k,phix,phiy,phiz:real;
  n:byte;
begin
  address:=0;
  phix:=0; phiy:=0; phiz:=0;
  fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);
  fillchar(z,sizeof(z),0);
  repeat
    retrace;
    setborder(50);
    for n:=0 to nofpoints do begin
      i:=cos(phiy)*point[n,0]-sin(phiy)*point[n,2];
      j:=cos(phiz)*point[n,1]-sin(phiz)*i;
      k:=cos(phiy)*point[n,2]+sin(phiy)*point[n,0];
      x:=cos(phiz)*i+sin(phiz)*point[n,1];
      y:=cos(phix)*j+sin(phix)*k;
      z:=cos(phix)*k-sin(phix)*j;
      xp[n]:=160+round((-x*dist)/(z-dist));
      yp[n]:=100+round((-y*dist)/(z-dist));
      zp[n]:=round(z);
    end;
    for n:=0 to nofpolys do begin
      polyz[n]:=(zp[planes[n,0]]+zp[planes[n,1]]+zp[planes[n,2]]+zp[planes[n,3]]) div 4;
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
              xp[planes[pind[n],3]],yp[planes[pind[n],3]],polyz[n]+15);
    phix:=phix+xst; if phix<0 then phix:=phix+(2*pi) else if phix>(2*pi) then phix:=phix-(2*pi);
    phiy:=phiy+yst; if phiy<0 then phiy:=phiy+(2*pi) else if phiy>(2*pi) then phiy:=phiy-(2*pi);
    phiz:=phiz+zst; if phiz<0 then phiz:=phiz+(2*pi) else if phiz>(2*pi) then phiz:=phiz-(2*pi);
    setborder(0);
  until keypressed;
end;

{ -------------------------------------------------------------------------- }

var i:byte;
begin
  setmodex;
  border:=false;
  for i:=1 to 63 do setpal(i,i div 4,i div 2,i);
  rotate_cube;
  textmode(lastmode);
end.
