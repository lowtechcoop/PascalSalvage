
unit x3dunit;
{ mode-x 3D unit - xhlin-procedure by Sean Palmer }
interface

const
  vidseg:word=$a000;
  divd:word=128;
  dist:word=200;
  border:boolean=false;

var
  ctab,stab:array[0..255] of integer;
  minx,miny,maxx,maxy:integer;
  address:word;

procedure setborder(col:byte);
procedure setpal(c,r,g,b:byte);
procedure retrace;
procedure setmodex;
procedure setaddress(ad:word);
procedure cls;
procedure polygon(x1,y1,x2,y2,x3,y3,x4,y4:integer; c:byte);
function cosinus(i:byte):integer;
function sinus(i:byte):integer;

implementation

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

function maxi(a,b:integer):integer; inline(
  $58/             { pop   ax     }
  $5b/             { pop   bx     }
  $3b/$c3/         { cmp   ax,bx  }
  $7f/$01/         { jg    +1     }
  $93);            { xchg  ax,bx  }

function mini(a,b:integer):integer; inline(
  $58/             { pop   ax     }
  $5b/             { pop   bx     }
  $3b/$c3/         { cmp   ax,bx  }
  $7c/$01/         { jl    +1     }
  $93);            { xchg  ax,bx  }

function inrangei(value,min,max:integer):integer; inline(
  $59/             { pop   cx max }
  $5b/             { pop   bx min }
  $58/             { pop   ax val }
  $3b/$c3/         { cmp   ax,bx  }
  $7f/$03/         { jg    +3     }
  $93/             { xchg  ax,bx  }
  $eb/$05/         { jmp   +5     }
  $3b/$c1/         { cmp   ax,cx  }
  $7c/$01/         { jl    +1     }
  $91);            { xchg  ax,cx  }

procedure polygon( x1,y1, x2,y2, x3,y3, x4,y4 :integer; c:byte);
var pos:array[0..199,0..1] of integer;
  xdiv1,xdiv2,xdiv3,xdiv4:integer;
  ydiv1,ydiv2,ydiv3,ydiv4:integer;
  dir1,dir2,dir3,dir4:byte;
  ly,gy,y,tmp,step:integer;
begin
  { determine highest and lowest point + vertical window checking }
  ly:=maxi(mini(mini(mini(y1,y2),y3),y4),miny);
  gy:=mini(maxi(maxi(maxi(y1,y2),y3),y4),maxy);
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
    if inrangei(y,ly,gy)=y then begin
      tmp:=xdiv1*(y-y1) div ydiv1+x1;
      pos[y,dir1]:=inrangei(tmp,minx,maxx);
    end;
    inc(y,step);
  until y=y2+step
  else if (y>=ly) and (y<=gy) then pos[y,dir1]:=inrangei(x1,minx,maxx);

  y:=y2;
  step:=dir2*2-1;
  if y2<>y3 then repeat
    if inrangei(y,ly,gy)=y then begin
      tmp:=xdiv2*(y-y2) div ydiv2+x2;
      pos[y,dir2]:=inrangei(tmp,minx,maxx);
    end;
    inc(y,step);
  until y=y3+step
  else if (y>=ly) and (y<=gy) then pos[y,dir2]:=inrangei(x2,minx,maxx);

  y:=y3;
  step:=dir3*2-1;
  if y3<>y4 then repeat
    if inrangei(y,ly,gy)=y then begin
      tmp:=xdiv3*(y-y3) div ydiv3+x3;
      pos[y,dir3]:=inrangei(tmp,minx,maxx);
    end;
    inc(y,step);
  until y=y4+step
  else if (y>=ly) and (y<=gy) then pos[y,dir3]:=inrangei(x3,minx,maxx);

  y:=y4;
  step:=dir4*2-1;
  if y4<>y1 then repeat
    if inrangei(y,ly,gy)=y then begin
      tmp:=xdiv4*(y-y4) div ydiv4+x4;
      pos[y,dir4]:=inrangei(tmp,minx,maxx);
    end;
    inc(y,step);
  until y=y1+step
  else if (y>=ly) and (y<=gy) then pos[y,dir4]:=inrangei(x4,minx,maxx);

  for y:=ly to gy do xhlin(pos[y,0],pos[y,1],y,c);
end;

function cosinus(i:byte):integer; begin cosinus:=ctab[i]; end;
function sinus(i:byte):integer; begin sinus:=stab[i]; end;

var i:byte;
begin
  minx:=0; miny:=0; maxx:=319; maxy:=199;
  for i:=0 to 255 do ctab[i]:=round(-cos(i*pi/128)*divd);
  for i:=0 to 255 do stab[i]:=round(sin(i*pi/128)*divd);
end.
