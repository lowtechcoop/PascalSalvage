
{$r-}
program polygoned_and_shaded_hexagon;
uses
  crt;
const
  border=false;
  vidseg:word=$a000;
  divd=128;
  dist=200;
  point:array[0..11,0..2] of integer=(
    (-20,-20, 30),( 20,-20, 30),( 40,-40,  0),( 20,-20,-30),
    (-20,-20,-30),(-40,-40,  0),(-20, 20, 30),( 20, 20, 30),
    ( 40, 40,  0),( 20, 20,-30),(-20, 20,-30),(-40, 40,  0));
  planes:array[0..7,0..3] of byte=(
    (1,2,8,7),(9,8,2,3),(10,4,5,11),(6,11,5,0),
    (0,1,2,5),(5,2,3,4),(6,7,8,11),(11,8,9,10));
var
  stab:array[0..255] of integer;
  polyz:array[0..7] of integer;
  pind:array[0..7] of byte;
  page,virscr:pointer;
  pageseg,virseg:word;

{ -------------------------------------------------------------------------- }

procedure setborder(col:byte); assembler;
asm
  xor ch,ch
  mov cl,border
  jcxz @out
  mov dx,3dah
  in al,dx
  mov dx,3c0h
  mov al,11h+32
  out dx,al
  mov al,col
  out dx,al
 @out:
end;

{ -------------------------------------------------------------------------- }

procedure retrace; assembler;
asm
  mov dx,3dah
 @vert1:
  in al,dx
  test al,8
  jz @vert1
 @vert2:
  in al,dx
  test al,8
  jnz @vert2
end;

{ -------------------------------------------------------------------------- }

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

{ -------------------------------------------------------------------------- }

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

{ -------------------------------------------------------------------------- }

procedure horline(xb,xe,y:integer; c:byte; where:word); assembler;
asm
  mov bx,[xb]
  cmp bx,0              { if zero don't draw }
  jz @out
  mov cx,[xe]
  jcxz @out
  cmp bx,cx             { see if x-end is smaller than x-begin }
  jb @skip
  xchg bx,cx            { yes: switch coords }
 @skip:
  dec bx                { atatch planes }
  inc cx
  sub cx,bx             { length of line in cx }
  mov es,[where]        { segment to draw in }
  mov ax,[y]            { heigth of line }
  shl ax,6
  mov di,ax
  shl ax,2
  add di,ax             { y*320 in di (offset) }
  add di,bx             { add x-begin }
  mov al,[c]            { get color }
  shr cx,1              { div length by 2 }
  jnc @skip2            { carry set? }
  stosb                 { draw byte }
 @skip2:
  mov ah,al             { copy color in hi-byte }
  rep stosw             { draw (rest of) line }
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
    horline(xpos[y,0],xpos[y,1],y,c,virseg);
end;

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

function sinus(i:byte):integer; begin sinus:=stab[i]; end;
function cosinus(i:byte):integer; begin cosinus:=stab[(i+192) mod 255]; end;

{ -------------------------------------------------------------------------- }

procedure rotate_cube;
const xst=2; yst=3; zst=-4;
var
  xp,yp,z:array[0..11] of integer;
  x,y,i,j,k:integer;
  n,Key,phix,phiy,phiz:byte;
begin
  phix:=0; phiy:=0; phiz:=40;
  fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);
  repeat
    {retrace;}
    setborder(10);
    flip(pageseg,virseg);
    for n:=0 to 11 do begin
      i:=(cosinus(phiy)*point[n,0]-sinus(phiy)*point[n,2]) div divd;
      j:=(cosinus(phiz)*point[n,1]-sinus(phiz)*i) div divd;
      k:=(cosinus(phiy)*point[n,2]+sinus(phiy)*point[n,0]) div divd;
      x:=(cosinus(phiz)*i+sinus(phiz)*point[n,1]) div divd;
      y:=(cosinus(phix)*j+sinus(phix)*k) div divd;
      z[n]:=(cosinus(phix)*k-sinus(phix)*j) div divd+cosinus(phix) div 3;
      xp[n]:=160+sinus(phix) div 2+(-x*dist) div (z[n]-dist);
      yp[n]:=100+(-y*dist) div (z[n]-dist);
    end;
    for n:=0 to 7 do begin
      polyz[n]:=(z[planes[n,0]]+z[planes[n,1]]+z[planes[n,2]]+z[planes[n,3]]) div 4;
      pind[n]:=n;
    end;
    quicksort(0,7);
    for n:=0 to 7 do
      polygon(xp[planes[pind[n],0]],yp[planes[pind[n],0]],
              xp[planes[pind[n],1]],yp[planes[pind[n],1]],
              xp[planes[pind[n],2]],yp[planes[pind[n],2]],
              xp[planes[pind[n],3]],yp[planes[pind[n],3]],polyz[n]+75);
    inc(phix,xst); inc(phiy,yst); inc(phiz,zst);
    setborder(0);
    flip(virseg,vidseg);
  until keypressed;
end;

{ -------------------------------------------------------------------------- }

var i,j:word;
begin
  asm mov ax,13h; int 10h; end;
  getmem(virscr,64000);
  virseg:=seg(virscr^);
  getmem(page,64000);
  pageseg:=seg(page^);
  for i:=0 to 255 do stab[i]:=round(sin(i*pi/128)*divd);
  for i:=1 to 150 do setpal(i,30+i div 6,20+i div 7,10+i div 7);
  for i:=1 to 104 do setpal(150+i,0,20+i div 4,30+i div 5);
  for i:=0 to 319 do for j:=0 to 199 do mem[pageseg:j*320+i]:=151+(i*i+j*j) mod 104;
  rotate_cube;
  freemem(page,64000);
  freemem(virscr,64000);
  textmode(lastmode);
end.

{ 3d-stuff inc. background }
