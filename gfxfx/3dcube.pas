
{$r-}
program polygoned_cube;
uses
  crt;
const
  vidseg:word=$a000;
  border:boolean=true;
  divd:word=128;
  dist=150;
  point:array[0..7,0..2] of integer=(
    (-30,-30,-30),(-30,-30,30),(30,-30,30),(30,-30,-30),
    (-30, 30,-30),(-30, 30,30),(30, 30,30),(30, 30,-30));
  planes:array[0..5,0..3] of byte=(
    (0,4,5,1),(0,3,7,4),(0,1,2,3),(4,5,6,7),(7,6,2,3),(1,2,6,5));
var
  ctab:array[0..255] of integer;
  stab:array[0..255] of integer;
  polyz:array[0..5] of integer;
  pind:array[0..5] of byte;
  virscr:pointer;
  virseg:word;
  minx,miny,maxx,maxy:integer;

{ -------------------------------------------------------------------------- }

procedure retrace; assembler; asm
  mov dx,3dah; @vert1: in al,dx; test al,8; jz @vert1
  @vert2: in al,dx; test al,8; jnz @vert2; end;

procedure setborder(col:byte); assembler; asm
  xor ch,ch; mov cl,border; jcxz @out; mov dx,3dah; in al,dx
  mov dx,3c0h; mov al,11h+32; out dx,al; mov al,col; out dx,al; @out: end;

procedure flip(src,dst:word); assembler; asm
  push ds; mov ax,[dst]; mov es,ax; mov ax,[src]; mov ds,ax
  xor si,si; xor di,di; mov cx,320*200/2; rep movsw; pop ds; end;

procedure cls(lvseg:word); assembler; asm
  mov es,[lvseg]; xor di,di; xor ax,ax; mov cx,320*200/2; rep stosw; end;

procedure setpal(c,r,g,b:byte); assembler; asm
  mov dx,3c8h; mov al,[c]; out dx,al; inc dx; mov al,[r]
  out dx,al; mov al,[g]; out dx,al; mov al,[b]; out dx,al; end;

function cosinus(i:byte):integer; begin cosinus:=ctab[i]; end;
function sinus(i:byte):integer; begin sinus:=stab[i]; end;

{ -------------------------------------------------------------------------- }

procedure horline(xb,xe,y:integer; c:byte); assembler;
asm
  mov bx,xb
  mov cx,xe
  cmp bx,cx
  jb @skip
  xchg bx,cx
 @skip:
  inc cx
  sub cx,bx
  mov es,virseg
  mov ax,y
  shl ax,6
  mov di,ax
  shl ax,2
  add di,ax
  add di,bx
  mov al,c
  shr cx,1
  jnc @skip2
  stosb
 @skip2:
  mov ah,al
  rep stosw
 @out:
end;

function MaxI(A,B:Integer):Integer;
inline(
$58/                       {pop   ax       }
$5B/                       {pop   bx       }
$3B/$C3/                   {cmp   ax,bx    }
$7F/$01/                   {jg    +1       }
$93);                      {xchg  ax,bx    }
function MinI(A,B:Integer):Integer;
inline(
$58/                       {pop   ax       }
$5B/                       {pop   bx       }
$3B/$C3/                   {cmp   ax,bx    }
$7C/$01/                   {jl    +1       }
$93);                      {xchg  ax,bx    }
function InRangeI(value,min,max:integer):integer;
inline(
$59/                       {pop   cx  max  }
$5B/                       {pop   bx  min  }
$58/                       {pop   ax  val  }
$3B/$C3/                   {cmp   ax,bx    }
$7F/$03/                   {jg    +3       }
$93/                       {xchg  ax,bx    }
$Eb/$05/                   {jmp   +5       }
$3B/$C1/                   {cmp   ax,cx    }
$7C/$01/                   {jl    +1       }
$91);                      {xchg  ax,cx    }


procedure polygon( x1,y1, x2,y2, x3,y3, x4,y4 :integer; c:byte);
var pos:array[0..199,0..1] of integer;
  xdiv1,xdiv2,xdiv3,xdiv4:integer;
  ydiv1,ydiv2,ydiv3,ydiv4:integer;
  dir1,dir2,dir3,dir4:byte;
  ly,gy,y,tmp,step:integer;
begin
  { determine highest and lowest point + vertical window checking }
  ly:=MaxI(MinI(MinI(MinI(y1,y2),y3),y4),miny);
  gy:=MinI(MaxI(MaxI(MaxI(y1,y2),y3),y4),maxy);

  if ly>maxy then exit;
  if gy<miny then exit;

  { check directions (-1=down, 1=up) and calculate constants }
  dir1:=byte(y1<y2); xdiv1:=x2-x1; ydiv1:=y2-y1;
  dir2:=byte(y2<y3); xdiv2:=x3-x2; ydiv2:=y3-y2;
  dir3:=byte(y3<y4); xdiv3:=x4-x3; ydiv3:=y4-y3;
  dir4:=byte(y4<y1); xdiv4:=x1-x4; ydiv4:=y1-y4;

  y:=y1;
  step:=dir1*2-1;
  if y1<>y2 then begin
    repeat
      if InRangeI(y,ly,gy)=y then begin
        tmp:=xdiv1*(y-y1) div ydiv1+x1;
        pos[y,dir1]:=InRangeI(tmp,minx,maxx);
      end;
      inc(y,step);
    until y=y2+step;
  end
  else begin
    if (y>=ly) and (y<=gy) then begin
      pos[y,dir1]:=InRangeI(x1,minx,maxx);
    end;
  end;

  y:=y2;
  step:=dir2*2-1;
  if y2<>y3 then begin
    repeat
      if InRangeI(y,ly,gy)=y then begin
        tmp:=xdiv2*(y-y2) div ydiv2+x2;
        pos[y,dir2]:=InRangeI(tmp,minx,maxx);
      end;
      inc(y,step);
    until y=y3+step;
  end
  else begin
    if (y>=ly) and (y<=gy) then begin
      pos[y,dir2]:=InRangeI(x2,minx,maxx);
    end;
  end;

  y:=y3;
  step:=dir3*2-1;
  if y3<>y4 then begin
    repeat
      if InRangeI(y,ly,gy)=y then begin
        tmp:=xdiv3*(y-y3) div ydiv3+x3;
        pos[y,dir3]:=InRangeI(tmp,minx,maxx);
      end;
      inc(y,step);
    until y=y4+step;
  end
  else begin
    if (y>=ly) and (y<=gy) then begin
      pos[y,dir3]:=InRangeI(x3,minx,maxx);
    end;
  end;

  y:=y4;
  step:=dir4*2-1;
  if y4<>y1 then begin
    repeat
      if InRangeI(y,ly,gy)=y then begin
        tmp:=xdiv4*(y-y4) div ydiv4+x4;
        pos[y,dir4]:=InRangeI(tmp,minx,maxx);
      end;
      inc(y,step);
    until y=y1+step;
  end
  else begin
    if (y>=ly) and (y<=gy) then begin
      pos[y,dir4]:=InRangeI(x4,minx,maxx);
    end;
  end;

  for y:=ly to gy do horline(pos[y,0],pos[y,1],y,c);
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

procedure rotate_cube;
const xst=2; yst=3; zst=-2;
var
  xp,yp,z:array[0..7] of integer;
  x,y,i,j,k:integer;
  n,phix,phiy,phiz:byte;
begin
  phix:=0; phiy:=0; phiz:=0;
  fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);
  repeat
    retrace;
    setborder(5);
    for n:=3 to 5 do
      polygon(xp[planes[pind[n],0]],yp[planes[pind[n],0]],
              xp[planes[pind[n],1]],yp[planes[pind[n],1]],
              xp[planes[pind[n],2]],yp[planes[pind[n],2]],
              xp[planes[pind[n],3]],yp[planes[pind[n],3]],0);
    for n:=0 to 7 do begin
      i:=(cosinus(phiy)*point[n,0]-sinus(phiy)*point[n,2]) div divd;
      j:=(cosinus(phiz)*point[n,1]-sinus(phiz)*i) div divd;
      k:=(cosinus(phiy)*point[n,2]+sinus(phiy)*point[n,0]) div divd;
      x:=(cosinus(phiz)*i+sinus(phiz)*point[n,1]) div divd;
      y:=(cosinus(phix)*j+sinus(phix)*k) div divd;
      z[n]:=(cosinus(phix)*k-sinus(phix)*j) div divd;
      xp[n]:=160+(-x*dist) div (z[n]-dist);
      yp[n]:=100+(-y*dist) div (z[n]-dist);
    end;
    for n:=0 to 5 do begin
      polyz[n]:=(z[planes[n,0]]+z[planes[n,1]]+z[planes[n,2]]+z[planes[n,3]]) div 4;
      pind[n]:=n;
    end;
    quicksort(0,5);
    for n:=3 to 5 do
      polygon(xp[planes[pind[n],0]],yp[planes[pind[n],0]],
              xp[planes[pind[n],1]],yp[planes[pind[n],1]],
              xp[planes[pind[n],2]],yp[planes[pind[n],2]],
              xp[planes[pind[n],3]],yp[planes[pind[n],3]],pind[n]+1);
    inc(phix,xst); inc(phiy,yst); inc(phiz,zst);
    setborder(0);
    flip(virseg,vidseg);
    setborder(0);
  until keypressed;
end;

{ -------------------------------------------------------------------------- }

var i:word;
begin
  minx:=0; miny:=0; maxx:=319; maxy:=199;
  asm mov ax,13h; int 10h; end;
  getmem(virscr,64000);
  virseg:=seg(virscr^);
  cls(virseg);
  for i:=0 to 5 do setpal(i+1,10+i*2,20+i*2,30+i*2);
  for i:=0 to 255 do ctab[i]:=round(-cos(i*pi/128)*divd);
  for i:=0 to 255 do stab[i]:=round(sin(i*pi/128)*divd);
  rotate_cube;
  freemem(virscr,64000);
  textmode(lastmode);
end.

{ First polygon-routine, updated with Marius Ellen's routines,
  only shorter and neater, not realy much faster... }
