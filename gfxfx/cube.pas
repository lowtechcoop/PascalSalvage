
program polygoned_cube;
{ THE very first polygoned cube }
uses crt;
const
  vidseg:word=$a000;
  dist=150;
  point:array[0..7,0..2] of integer=(
    (-35,-35,-35),(-35,-35,35),(35,-35,35),(35,-35,-35),
    (-35, 35,-35),(-35, 35,35),(35, 35,35),(35, 35,-35));
  planes:array[0..5,0..3] of byte=(
    (0,4,5,1),(0,3,7,4),(0,1,2,3),(4,5,6,7),(7,6,2,3),(1,2,6,5));

type
  tabtype=array[0..255] of integer;
  planearray=array[0..5] of integer;

var
  sintab:tabtype;
  planez:planearray;
  virscr:pointer;
  virseg:word;

{----------------------------------------------------------------------------}

procedure setpal(c,r,g,b:byte); assembler;
asm
  mov dx,3c8h
  mov al,[c]
  out dx,al
  inc dx
  mov al,[r]
  out dx,al
  mov al,[g]
  out dx,al
  mov al,[b]
  out dx,al
end;

procedure cls(lvseg:word); assembler;
asm
  mov es,[lvseg]
  xor di,di
  xor ax,ax
  mov cx,320*200/2
  rep stosw
end;

procedure flip(src,dst:word); assembler;
asm
  push ds
  mov es,[dst]
  mov ds,[src]
  xor si,si
  xor di,di
  mov cx,320*200/2
  rep movsw
  pop ds
end;

{----------------------------------------------------------------------------}

procedure Calcsinus(var SinTab : TabType); var I : byte; begin
  for I := 0 to 255 do SinTab[I] := round(sin(2*I*pi/255)*128); end;

{----------------------------------------------------------------------------}

procedure quicksort(var a:planearray;lo,hi:integer);

procedure sort(l,r:integer);
var i,j,x,y: integer;
begin
  i:=l; j:=r; x:=a[(l+r) div 2];
  repeat
    while a[i]<x do i:=i+1;
    while x<a[j] do j:=j-1;
    if i<=j then
    begin
      y:=a[i]; a[i]:=a[j]; a[j]:=y;
      i:=i+1; j:=j-1;
    end;
  until i>j;
  if l<j then sort(l,j);
  if i<r then sort(i,r);
end;

begin
  sort(lo,hi);
end;

{----------------------------------------------------------------------------}

procedure horline(xb,xe,y:integer; c:byte); assembler;
asm
  mov bx,[xb]
  cmp bx,0
  jz @out
  mov cx,[xe]
  jcxz @out
  cmp bx,cx
  jb @skip
  xchg bx,cx
 @skip:
  dec bx
  inc cx
  sub cx,bx
  mov es,virseg
  mov ax,[y]
  shl ax,6
  mov di,ax
  shl ax,2
  add di,ax
  add di,bx
  mov al,[c]
  shr cx,1
  jnc @skip2
  stosb
 @skip2:
  mov ah,al
  rep stosw
 @out:
end;

procedure polygon(x1,y1,x2,y2,x3,y3,x4,y4:integer; c:byte);
var
  xpos:array[0..199,0..1] of integer;
  mny,mxy,y:integer;
  i:word;
  s1,s2,s3,s4:shortint;
begin
  mny:=y1;
  if y2<mny then mny:=y2;
  if y3<mny then mny:=y3;
  if y4<mny then mny:=y4;
  mxy:=y1;
  if y2>mxy then mxy:=y2;
  if y3>mxy then mxy:=y3;
  if y4>mxy then mxy:=y4;
  s1:=byte(y1<y2)*2-1;
  s2:=byte(y2<y3)*2-1;
  s3:=byte(y3<y4)*2-1;
  s4:=byte(y4<y1)*2-1;
  y:=y1;
  if y1<>y2 then repeat
    xpos[y,byte(y1<y2)]:=integer(x2-x1)*(y-y1) div (y2-y1)+x1;
    inc(y,s1);
  until y=y2+s1 else xpos[y,byte(y1<y2)]:=x1;
  y:=y2;
  if y2<>y3 then repeat
    xpos[y,byte(y2<y3)]:=integer(x3-x2)*(y-y2) div (y3-y2)+x2;
    inc(y,s2);
  until y=y3+s2 else xpos[y,byte(y2<y3)]:=x2;
  y:=y3;
  if y3<>y4 then repeat
    xpos[y,byte(y3<y4)]:=integer(x4-x3)*(y-y3) div (y4-y3)+x3;
    inc(y,s3);
  until y=y4+s3 else xpos[y,byte(y3<y4)]:=x3;
  y:=y4;
  if y4<>y1 then repeat
    xpos[y,byte(y4<y1)]:=integer(x1-x4)*(y-y4) div (y1-y4)+x4;
    inc(y,s4);
  until y=y1+s4 else xpos[y,byte(y1<y4)]:=x4;
  for y:=mny to mxy do
    horline(xpos[y,0],xpos[y,1],y,c);
end;

{----------------------------------------------------------------------------}

function sinus(i:byte):integer; begin sinus:=sintab[i]; end;
function cosinus(i:byte):integer; begin cosinus:=sintab[(i+192) mod 255]; end;

{----------------------------------------------------------------------------}

procedure Rotate;
const xst=2; yst=0; zst=-2;

var
  xp,yp,z:array[0..7] of integer;
  x,y,i,j,k:integer;
  n,Key,phix,phiy,phiz:byte;

begin
  phix:=0; phiy:=0; phiz:=0;
  fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);
  repeat
    while (port[$3da] and 8) <> 8 do;
    while (port[$3da] and 8) = 8 do;
    setpal(0,0,0,50);

    for n:=3 to 5 do
      polygon(xp[planes[planez[n] and 7,0]],yp[planes[planez[n] and 7,0]],
              xp[planes[planez[n] and 7,1]],yp[planes[planez[n] and 7,1]],
              xp[planes[planez[n] and 7,2]],yp[planes[planez[n] and 7,2]],
              xp[planes[planez[n] and 7,3]],yp[planes[planez[n] and 7,3]],0);

    for n:=0 to 7 do begin
      i:=(cosinus(phiy)*point[n,0]-sinus(phiy)*point[n,2]) div 128;
      j:=(cosinus(phiz)*point[n,1]-sinus(phiz)*i) div 128;
      k:=(cosinus(phiy)*point[n,2]+sinus(phiy)*point[n,0]) div 128;
      x:=(cosinus(phiz)*i+sinus(phiz)*point[n,1]) div 128;
      y:=(cosinus(phix)*j+sinus(phix)*k) div 128;
      z[n]:=(cosinus(phix)*k-sinus(phix)*j) div 128;
      xp[n]:=160+(-x*dist) div (z[n]-dist);
      yp[n]:=100+(-y*dist) div (z[n]-dist);
    end;

    for n:=0 to 5 do
      planez[n]:=(integer(z[planes[n,0]]+z[planes[n,1]]+
                          z[planes[n,2]]+z[planes[n,3]]) div 4)
                          shl 3+n;

    quicksort(planez,0,5);

    for n:=3 to 5 do
      polygon(xp[planes[planez[n] and 7,0]],yp[planes[planez[n] and 7,0]],
              xp[planes[planez[n] and 7,1]],yp[planes[planez[n] and 7,1]],
              xp[planes[planez[n] and 7,2]],yp[planes[planez[n] and 7,2]],
              xp[planes[planez[n] and 7,3]],yp[planes[planez[n] and 7,3]],(planez[n] and 7)+1);

    inc(phix,xst); inc(phiy,yst); inc(phiz,zst);
    setpal(0,0,0,0);
    flip(virseg,vidseg);
  until keypressed;
end;

{----------------------------------------------------------------------------}

var i:byte;
begin
  Calcsinus(SinTab);
  asm mov ax,13h; int 10h; end;
  getmem(virscr,64000);
  virseg:=seg(virscr^);
  cls(virseg);
  for i:=0 to 5 do setpal(i+1,10+i*2,30+i*2,10+i*2);
  Rotate;
  freemem(virscr,64000);
  textmode(lastmode);
end.
