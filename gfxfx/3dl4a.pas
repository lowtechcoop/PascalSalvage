
{$g+,r-,q-,s+,t-,v+,x+}
program polygoned_l4a;
{ Dedicated too... Guess who? }
uses
  crt;
const
  vidseg:word=$a000;
  divd:word=128;
  dist:word=200;
  minx:word=0;
  maxx:word=319;
  border:boolean=false;
  point:array[0..27,0..2] of integer=(
    {l}
    (-50,-25,  0),
    (-20,-25,  0),
    (-20,-15,  0),
    (-40,-15,  0),
    (-40, 25,  0),
    (-50, 25,  0),
    {4}
    (-10,-25,  0),
    (  0,-25,  0),
    (  0, 25,  0),
    (-10, 25,  0),
    ( -8,  5,  0),
    (-20,  5,  0),
    (-20, 25,  0),
    (-30, 25,  0),
    (-30, -5,  0),
    ( -8, -5,  0),
    {a}
    ( 10,-25,  0),
    ( 20,-25,  0),
    ( 18, -5,  0),
    ( 32, -5,  0),
    ( 30,-25,  0),
    ( 40,-25,  0),
    ( 40, 25,  0),
    ( 10, 25,  0),
    ( 18,  5,  0),
    ( 32,  5,  0),
    ( 30, 15,  0),
    ( 20, 15,  0));

  planes:array[0..8,0..3] of byte=(
    {l}
    (0,1,2,3),
    (0,3,4,5),
    {4}
    (6,7,8,9),
    (14,15,10,11),
    (14,11,12,13),
    {a}
    (16,17,27,23),
    (27,26,22,23),
    (20,21,22,26),
    (18,19,25,24));

var
  ctab,stab:array[0..255] of integer;
  polyz:array[0..8] of integer;
  pind:array[0..8] of byte;
  address:word;

{ -------------------------------------------------------------------------- }

function cosinus(i:byte):integer; begin cosinus:=ctab[i]; end;
function sinus(i:byte):integer; begin sinus:=stab[i]; end;

{ -------------------------------------------------------------------------- }

procedure setborder(col:byte); assembler; asm
  xor ch,ch; mov cl,border; jcxz @out; mov dx,3dah; in al,dx
  mov dx,3c0h; mov al,11h+32; out dx,al; mov al,col; out dx,al; @out: end;

procedure setpal(c,r,g,b:byte); assembler; asm
  mov dx,3c8h; mov al,[c]; out dx,al; inc dx; mov al,[r]
  out dx,al; mov al,[g]; out dx,al; mov al,[b]; out dx,al; end;

procedure retrace; assembler; asm
  mov dx,3dah; @vert1: in al,dx; test al,8; jz @vert1
  @vert2: in al,dx; test al,8; jnz @vert2; end;

procedure setmodex; assembler; asm
  mov ax,13h; int 10h; mov dx,3c4h; mov ax,0604h; out dx,ax; mov ax,0f02h
  out dx,ax; mov cx,320*200; mov es,vidseg; xor ax,ax; mov di,ax; rep stosw
  mov dx,3d4h; mov ax,0014h; out dx,ax; mov ax,0e317h; out dx,ax; end;

procedure setaddress(ad:word); assembler; asm
  mov dx,3d4h; mov al,0ch; mov ah,[byte(ad)+1]; out dx,ax
  mov al,0dh; mov ah,[byte(ad)]; out dx,ax; end;

procedure cls; assembler; asm
  mov es,vidseg; mov di,address; mov cx,8000; mov dx,3c4h
  mov ax,0f02h; out dx,ax; xor ax,ax; rep stosw; end;

{ -------------------------------------------------------------------------- }

procedure xhlin(x,x2,y:integer;c:byte); assembler;
asm
  mov ax,vidseg
  mov es,ax
  cld
  mov ax,80
  mul y
  mov di,ax             { base of scan line }
  add di,address
  mov bx,[x]
  mov dx,[x2]
  cmp bx,dx
  jb @skip
  xchg bx,dx
 @skip:
  mov cl,bl
  shr bx,2
  mov ch,dl
  shr dx,2
  and cx,$0303
  sub dx,bx             { width in Bytes }
  add di,bx             { offset into video buffer }
  mov ax,$ff02
  shl ah,cl
  and ah,$0f            { left edge mask }
  mov cl,ch
  mov bh,$f1
  rol bh,cl
  and bh,$0f            { right edge mask }
  mov cx,dx
  or cx,cx
  jnz @left
  and ah,bh             { combine left & right bitmasks }
 @left:
  mov dx,$03c4
  out dx,ax
  inc dx
  mov al,[c]
  stosb
  jcxz @exit
  dec cx
  jcxz @right
  mov al,$0f
  out dx,al             { skipped if cx=0,1 }
  mov al,[c]
  repz stosb            { fill middle Bytes }
 @right:
  mov al,bh
  out dx,al             { skipped if cx=0 }
  mov al,[c]
  stosb
 @exit:
end;

procedure polygon(x1,y1,x2,y2,x3,y3,x4,y4:integer; c:byte);
var
  xpos:array[0..199,0..1] of integer;
  mul1,mul2,mul3,mul4,div1,div2,div3,div4,mny,mxy,y,tmp:integer;
  i:word;
  s1,s2,s3,s4:shortint;
  dir1,dir2,dir3,dir4:byte;
begin
  mny:=y1;                             { determine highest and lowest point }
  if y2<mny then mny:=y2;
  if y3<mny then mny:=y3;
  if y4<mny then mny:=y4;
  mxy:=y1;
  if y2>mxy then mxy:=y2;
  if y3>mxy then mxy:=y3;
  if y4>mxy then mxy:=y4;
  if mny<0 then mny:=0;                { vertical range checking }
  if mxy>199 then mxy:=199;
  if mny>199 then exit;
  if mxy<0 then exit;
  dir1:=byte(y1<y2);
  dir2:=byte(y2<y3);
  dir3:=byte(y3<y4);
  dir4:=byte(y4<y1);
  s1:=dir1*2-1;                        { check directions (-1= down, 1=up) }
  s2:=dir2*2-1;
  s3:=dir3*2-1;
  s4:=dir4*2-1;
  mul1:=x2-x1; div1 := y2-y1;          { calculate constants }
  mul2:=x3-x2; div2 := y3-y2;
  mul3:=x4-x3; div3 := y4-y3;
  mul4:=x1-x4; div4 := y1-y4;
  y:=y1;
  if y1<>y2 then repeat
    if (y>=mny) and (y<=mxy) then begin
      tmp:=mul1*(y-y1) div div1+x1;
      if tmp<minx then xpos[y,dir1]:=minx    { horizontal range checking }
      else if tmp>maxx then xpos[y,dir1]:=maxx
      else xpos[y,dir1]:=tmp;
    end;
    inc(y,s1);
  until y=y2+s1
  else if (y>=mny) and (y<=mxy) then begin
    tmp:=x1;
    if tmp<minx then xpos[y,dir1]:=minx
    else if tmp>maxx then xpos[y,dir1]:=maxx
    else xpos[y,dir1]:=tmp;
  end;
  y:=y2;
  if y2<>y3 then repeat
    if (y>=mny) and (y<=mxy) then begin
      tmp:=mul2*(y-y2) div div2+x2;
      if tmp<minx then xpos[y,dir2]:=minx
      else if tmp>maxx then xpos[y,dir2]:=maxx
      else xpos[y,dir2]:=tmp;
    end;
    inc(y,s2);
  until y=y3+s2
  else if (y>=mny) and (y<=mxy) then begin
    tmp:=x2;
    if tmp<minx then xpos[y,dir2]:=minx
    else if tmp>maxx then xpos[y,dir2]:=maxx
    else xpos[y,dir2]:=tmp;
  end;
  y:=y3;
  if y3<>y4 then repeat
    if (y>=mny) and (y<=mxy) then begin
      tmp:=mul3*(y-y3) div div3+x3;
      if tmp<minx then xpos[y,dir3]:=minx
      else if tmp>maxx then xpos[y,dir3]:=maxx
      else xpos[y,dir3]:=tmp;
    end;
    inc(y,s3);
  until y=y4+s3
  else if (y>=mny) and (y<=mxy) then begin
    tmp:=x3;
    if tmp<minx then xpos[y,dir3]:=minx
    else if tmp>maxx then xpos[y,dir3]:=maxx
    else xpos[y,dir3]:=tmp;
  end;
  y:=y4;
  if y4<>y1 then repeat
    if (y>=mny) and (y<=mxy) then begin
      tmp:=mul4*(y-y4) div div4+x4;
      if tmp<minx then xpos[y,dir4]:=minx
      else if tmp>maxx then xpos[y,dir4]:=maxx
      else xpos[y,dir4]:=tmp;
    end;
    inc(y,s4);
  until y=y1+s4
  else if (y>=mny) and (y<=mxy) then begin
    tmp:=x4;
    if tmp<minx then xpos[y,dir4]:=minx
    else if tmp>maxx then xpos[y,dir4]:=maxx
    else xpos[y,dir4]:=tmp;
  end;
  for y:=mny to mxy do
    xhlin(xpos[y,0],xpos[y,1],y,c);
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

procedure rotate;
const
  xst=-1; yst=-2; zst=2;
var
  xp,yp,z:array[0..27] of integer;
  x,y,i,j,k:integer;
  n,Key,phix,phiy,phiz:byte;
begin
  address := 0;
  phix:=30; phiy:=0; phiz:=0;
  fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);
  fillchar(z,sizeof(z),0);
  repeat
    retrace;
    setborder(1);
    for n:=0 to 27 do begin
      i:=(cosinus(phiy)*point[n,0]-sinus(phiy)*point[n,2]) div divd;
      j:=(cosinus(phiz)*point[n,1]-sinus(phiz)*i) div divd;
      k:=(cosinus(phiy)*point[n,2]+sinus(phiy)*point[n,0]) div divd;
      x:=(cosinus(phiz)*i+sinus(phiz)*point[n,1]) div divd+cosinus(phix) div 2;
      y:=(cosinus(phix)*j+sinus(phix)*k) div divd+sinus(phix) div 3;
      z[n]:=(cosinus(phix)*k-sinus(phix)*j) div divd;
      xp[n]:=160+(-x*dist) div (z[n]-dist);
      yp[n]:=100+(-y*dist) div (z[n]-dist);
    end;
    for n:=0 to 8 do begin
      polyz[n]:=(z[planes[n,0]]+z[planes[n,1]]+z[planes[n,2]]+z[planes[n,3]]) div 4;
      pind[n]:=n;
    end;
    quicksort(0,8);
    address:=16000-address;
    setaddress(address);
    cls;
    for n:=0 to 8 do
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
  setpal(1,25,20,60);
  for i:=0 to 255 do ctab[i]:=round(-cos(i*pi/128)*divd);
  for i:=0 to 255 do stab[i]:=round(sin(i*pi/128)*divd);
  rotate;
  textmode(lastmode);
end.
