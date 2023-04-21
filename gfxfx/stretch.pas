
program strectch;
uses crt;
const
{$i explorer.inc}
  vidseg:word=$a000;
  diffsin:array[0..63] of byte=(
    0,0,1,1,2,2,3,3,4,4,5,5,6,6,5,5,4,4,3,3,
    4,4,5,5,4,4,4,3,3,3,2,2,2,1,1,1,2,2,2,3,
    3,3,4,4,3,3,2,2,1,1,0,0,0,1,1,2,3,4,3,2,1,1,0,0

   {0,0,0,1,0,1,1,2,1,2,2,3,2,3,3,4,3,4,4,5,
    4,5,5,4,5,4,4,3,4,3,3,2,3,2,2,1,2,1,1,0,
    1,0,0,0,0,1,2,2,3,3,3,4,4,4,4,3,3,3,2,2,1,0,0,0});
var
  f:text;
  txt:array[0..99] of string[20];
  bitmap:array[0..40,0..159] of byte;
  virscr:pointer;
  virseg:word;

procedure setvideo; assembler; asm
  mov ax,13h; int 10h; mov dx,3d4h; mov al,9; out dx,al; inc dx
  in al,dx; and al,0e0h; add al,3; out dx,al; end;

procedure setpal(col,r,g,b:byte); assembler; asm
  mov dx,03c8h; mov al,col; out dx,al; inc dx; mov al,r
  out dx,al; mov al,g; out dx,al; mov al,b; out dx,al; end;

procedure cls(lvseg:word); assembler; asm
  mov es,[lvseg]; xor di,di; xor ax,ax; mov cx,320*200/2; rep stosw; end;

procedure flip(src,dst:word); assembler; asm
  push ds; mov ax,[dst]; mov es,ax; mov ax,[src]; mov ds,ax
  xor si,si; xor di,di; mov cx,320*200/2; rep movsw; pop ds; end;

procedure retrace; assembler; asm
  mov dx,3dah; @vert1: in al,dx; test al,8; jz @vert1
  @vert2: in al,dx; test al,8; jnz @vert2; end;

procedure setpalette;
var c:word; i:byte;
begin
  c:=0;
  for i:=0 to 255 do begin
    setpal(i,pal[c],pal[c+1],pal[c+2]);
    inc(c,3);
  end;
end;

procedure putpicture;
var
  bcka:array[0..156] of byte;
  x,y,idx1,idx2,offset,add,col:word;
begin
  offset:=0; idx1:=0; idx2:=40; add:=0;
  repeat
    add:=0;
    for y:=0 to 40 do begin
      offset:=diffsin[(y+idx1+idx2) and $3f];
      if offset>0 then begin
        inc(add,offset);
        for x:=0 to 156 do begin
          col:=pic[y*157+x]; col:=col+col*256;
          memw[virseg:(add+diffsin[(idx1+idx2+x) and $3f])*320+x+x]:=col;
        end;
      end;
    end;
    retrace;
    flip(virseg,vidseg);
    cls(virseg);
    inc(idx1); dec(idx2,2);
    {move(pic,bcka,157);
    move(pic[157],pic,40*157);
    move(bcka,pic[40*157],157);}
  until keypressed;
end;

begin
  setvideo;
  setpalette;
  getmem(virscr,64000);
  virseg:=seg(virscr^);
  cls(virseg);
  putpicture;
  repeat until keypressed;
  freemem(virscr,64000);
  textmode(lastmode);
end.
