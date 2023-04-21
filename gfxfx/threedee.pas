
{$r-}
unit threedee;

interface

const
  vidseg:word=$a000;
  divd:word=128;

var
  ctab:array[0..255] of integer;
  stab:array[0..255] of integer;
  virscr:pointer;
  virseg:word;
  minx,miny,maxx,maxy:integer;
  border:boolean;

procedure setborder(col:byte);
procedure retrace;
procedure setpal(c,r,g,b:byte);
procedure cls(lvseg:word);
procedure flip(src,dst:word);
procedure polygon(x1,y1,x2,y2,x3,y3,x4,y4:integer; c:byte);
function sinus(i:byte):integer;
function cosinus(i:byte):integer;

implementation

{ -------------------------------------------------------------------------- }

procedure setborder(col:byte); assembler; asm
  xor ch,ch; mov cl,border; jcxz @out; mov dx,3dah; in al,dx
  mov dx,3c0h; mov al,11h+32; out dx,al; mov al,col; out dx,al; @out: end;

{ -------------------------------------------------------------------------- }

procedure retrace; assembler; asm
  mov dx,3dah; @vert1: in al,dx; test al,8; jz @vert1
  @vert2: in al,dx; test al,8; jnz @vert2; end;

{ -------------------------------------------------------------------------- }

procedure setpal(c,r,g,b:byte); assembler; asm
  mov dx,3c8h; mov al,[c]; out dx,al; inc dx; mov al,[r]
  out dx,al; mov al,[g]; out dx,al; mov al,[b]; out dx,al; end;

{ -------------------------------------------------------------------------- }

procedure cls(lvseg:word); assembler; asm
  mov es,[lvseg]; xor di,di; xor ax,ax; mov cx,320*200/2; rep stosw; end;

procedure flip(src,dst:word); assembler; asm
  push ds; mov ax,[dst]; mov es,ax; mov ax,[src]; mov ds,ax
  xor si,si; xor di,di; mov cx,320*200/2; rep movsw; pop ds; end;

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

function MaxI(A,B:Integer):Integer; inline(
  $58/             { pop   ax     }
  $5B/             { pop   bx     }
  $3B/$C3/         { cmp   ax,bx  }
  $7F/$01/         { jg    +1     }
  $93);            { xchg  ax,bx  }

function MinI(A,B:Integer):Integer; inline(
  $58/             { pop   ax     }
  $5B/             { pop   bx     }
  $3B/$C3/         { cmp   ax,bx  }
  $7C/$01/         { jl    +1     }
  $93);            { xchg  ax,bx  }

function InRangeI(value,min,max:integer):integer; inline(
  $59/             { pop   cx max }
  $5B/             { pop   bx min }
  $58/             { pop   ax val }
  $3B/$C3/         { cmp   ax,bx  }
  $7F/$03/         { jg    +3     }
  $93/             { xchg  ax,bx  }
  $Eb/$05/         { jmp   +5     }
  $3B/$C1/         { cmp   ax,cx  }
  $7C/$01/         { jl    +1     }
  $91);            { xchg  ax,cx  }

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
  if y1<>y2 then repeat
    if InRangeI(y,ly,gy)=y then begin
      tmp:=xdiv1*(y-y1) div ydiv1+x1;
      pos[y,dir1]:=InRangeI(tmp,minx,maxx);
    end;
    inc(y,step);
  until y=y2+step
  else if (y>=ly) and (y<=gy) then pos[y,dir1]:=InRangeI(x1,minx,maxx);

  y:=y2;
  step:=dir2*2-1;
  if y2<>y3 then repeat
    if InRangeI(y,ly,gy)=y then begin
      tmp:=xdiv2*(y-y2) div ydiv2+x2;
      pos[y,dir2]:=InRangeI(tmp,minx,maxx);
    end;
    inc(y,step);
  until y=y3+step
  else if (y>=ly) and (y<=gy) then pos[y,dir2]:=InRangeI(x2,minx,maxx);

  y:=y3;
  step:=dir3*2-1;
  if y3<>y4 then repeat
    if InRangeI(y,ly,gy)=y then begin
      tmp:=xdiv3*(y-y3) div ydiv3+x3;
      pos[y,dir3]:=InRangeI(tmp,minx,maxx);
    end;
    inc(y,step);
  until y=y4+step
  else if (y>=ly) and (y<=gy) then pos[y,dir3]:=InRangeI(x3,minx,maxx);

  y:=y4;
  step:=dir4*2-1;
  if y4<>y1 then repeat
    if InRangeI(y,ly,gy)=y then begin
      tmp:=xdiv4*(y-y4) div ydiv4+x4;
      pos[y,dir4]:=InRangeI(tmp,minx,maxx);
    end;
    inc(y,step);
  until y=y1+step
  else if (y>=ly) and (y<=gy) then pos[y,dir4]:=InRangeI(x4,minx,maxx);

  for y:=ly to gy do horline(pos[y,0],pos[y,1],y,c);
end;

{ -------------------------------------------------------------------------- }

function cosinus(i:byte):integer; begin cosinus:=ctab[i]; end;
function sinus(i:byte):integer; begin sinus:=stab[i]; end;

{ -------------------------------------------------------------------------- }

var i:byte;
begin
  border:=false;
  minx:=0; miny:=0; maxx:=319; maxy:=199;
  for i:=0 to 255 do ctab[i]:=round(-cos(i*pi/128)*divd);
  for i:=0 to 255 do stab[i]:=round(sin(i*pi/128)*divd);
end.
