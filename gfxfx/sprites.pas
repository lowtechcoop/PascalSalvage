
program sprites;
{ update of the sprites program, v2.0, by Bas van Gaalen, Holland, PD }
uses
  crt;
const
  vidseg:word=$a000;
  maxsprites=10; { change to whatever you need }
  xsize=17; ysize=17;
type
  sprrec=record x,y,sprseg:word; buf:pointer; end;
var
  sprite:array[1..maxsprites] of sprrec;
  xsprspd,ysprspd:array[1..maxsprites] of shortint;
  heap,virscr,bgscr:pointer;
  virseg,bgseg:word;

procedure setpal(col,r,g,b:byte); assembler; asm
  mov dx,03c8h; mov al,col; out dx,al; inc dx; mov al,r
  out dx,al; mov al,g; out dx,al; mov al,b; out dx,al; end;

procedure flip(src,dst,offs:word); assembler; asm
  push ds; mov ds,[src]; mov si,[offs]; mov es,[dst]
  xor di,di; mov cx,320*200/2; rep movsw; pop ds; end;

procedure cls(dst:word); assembler; asm
  mov es,[dst]; xor di,di; xor ax,ax; mov cx,320*200/2; rep stosw; end;

procedure retrace; assembler; asm
  mov dx,03dah; @vert1: in al,dx; test al,8; jnz @vert1
  @vert2: in al,dx; test al,8; jz @vert2; end;

procedure putsprite(x,y,sprseg,virseg:word); assembler;
asm
  push ds
  mov ds,sprseg; xor si,si { get sprite segment }
  mov es,virseg; xor di,di { get virtial screen segment }
  mov ax,[y]; shl ax,6; mov di,ax; shl ax,2; add di,ax { y*320 }
  add di,[x] { y*320+x }
  mov dx,320-xsize { number of pixels left on line }
  mov bx,ysize
 @l1:
  mov cx,xsize
 @l0:
  lodsb; or al,al; jz @skip { get byte from sprite and check if black }
  mov [es:di],al { draw it }
 @skip:
  inc di; dec cx; jnz @l0
  add di,dx; dec bx; jnz @l1
  pop ds
end;

var offs,hx,hy,np,n,i,j,k,l:word;
begin
  asm mov ax,13h; int 10h; end;
  randomize;
  getmem(virscr,320*200); virseg:=seg(virscr^); cls(virseg);
  getmem(bgscr,320*200); bgseg:=seg(bgscr^); cls(bgseg);
  mark(heap);

  np:=128 div maxsprites;
  for i:=0 to maxsprites-1 do begin
    case i mod 6 of
      0:begin hx:=23; hy:=i*np; n:=0; end;
      1:begin hx:=i*np; hy:=23; n:=0; end;
      2:begin hx:=i*np; hy:=0; n:=23; end;
      3:begin hx:=23; hy:=0; n:=i*np; end;
      4:begin hx:=0; hy:=23; n:=i*np; end;
      5:begin hx:=0; hy:=i*np; n:=23; end;
    end;
    for j:=0 to np-1 do begin
      k:=j shr 1;
      setpal(np*i+j+1,k+hx,k+hy,k+n);
    end;
  end;

  for i:=1 to 128 do setpal(127+i,i div 3,20+i div 5,20+i div 7);

  for i:=0 to 319 do
    for j:=0 to 199 do
      mem[bgseg:j*320+i]:=128+abs(i*i-j*j) and 127;

  hx:=xsize shr 1; hy:=ysize shr 1;
  for k:=1 to maxsprites do begin
    xsprspd[k]:=random(6)-3; if xsprspd[k]=0 then xsprspd[k]:=1;
    ysprspd[k]:=random(6)-3; if ysprspd[k]=0 then ysprspd[k]:=1;
    with sprite[k] do begin
      x:=20+random(280-xsize);
      y:=20+random(160-ysize);
      getmem(buf,xsize*ysize);
      sprseg:=seg(buf^);
      for i:=0 to xsize-1 do for j:=0 to ysize-1 do begin
        l:=(i-hx)*(i-hx)+(j-hy)*(j-hy);
        if (l<hx*hx) and (l>hx*hx div 8)
        then mem[sprseg:j*xsize+i]:=k mod np+np*(k-1)
        else mem[sprseg:j*xsize+i]:=black;
      end;
    end;
  end;

  offs:=0;
  repeat
    flip(bgseg,virseg,offs);
    offs:=(offs+1) mod 320;
    retrace;
    for i:=1 to maxsprites do
      with sprite[i] do begin
        putsprite(x,y,sprseg,virseg);
        inc(x,xsprspd[i]); if (x<10) or (x>(310-xsize)) then xsprspd[i]:=-xsprspd[i];
        inc(y,ysprspd[i]); if (y<10) or (y>(190-ysize)) then ysprspd[i]:=-ysprspd[i];
      end;
    flip(virseg,vidseg,0);
  until keypressed;

  release(heap);
  freemem(virscr,320*200); freemem(bgscr,320*200);
  textmode(lastmode);
end.
