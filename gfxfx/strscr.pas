
program strectch_scroll;
{ Stretching and wobbling scroll, by Bas van Gaalen, Holland, PD }
{ REEAAAAALLL slow if you don't have a 486dx2/66 or Pentium }
uses crt;
const
  len:byte=99;
  vidseg:word=$a000;
  diffsin:array[0..63] of byte=(
    0,0,0,1,0,1,1,2,1,2,2,3,2,3,3,4,3,4,4,5,
    4,5,5,4,5,4,4,3,4,3,3,2,3,2,2,1,2,1,1,0,
    1,0,0,0,0,1,2,2,3,3,3,4,4,4,4,3,3,3,2,2,1,0,0,0);
var
  f:text;
  txt:array[0..99] of string[20];
  stab:array[0..255] of shortint;
  bitmap:array[0..40,0..159] of byte;
  virscr:pointer;
  virseg,fofs,fseg:word;

procedure getfont; assembler; asm
  mov ax,1130h; mov bh,3; int 10h; mov fseg,es; mov fofs,bp; end;

procedure setvideo; assembler; asm
  mov ax,13h; int 10h; mov dx,3d4h; mov al,9; out dx,al; inc dx
  in al,dx; and al,0e0h; add al,3; out dx,al; end;

procedure cls(lvseg:word); assembler; asm
  mov es,[lvseg]; xor di,di; xor ax,ax; mov cx,320*200/2; rep stosw; end;

procedure flip(src,dst:word); assembler; asm
  push ds; mov ax,[dst]; mov es,ax; mov ax,[src]; mov ds,ax
  xor si,si; xor di,di; mov cx,320*200/2; rep movsw; pop ds; end;

procedure retrace; assembler; asm
  mov dx,3dah; @vert1: in al,dx; test al,8; jz @vert1
  @vert2: in al,dx; test al,8; jnz @vert2; end;

procedure dosomescrolling;
var x,y,repy,idx1,idx2,offset,add,col,txtidx:word; pos:longint; i:byte;
begin
  fillchar(bitmap,sizeof(bitmap),0);
  offset:=0; idx1:=0; idx2:=40; add:=0; txtidx:=0;
  repeat
    for x:=1 to 20 do for i:=0 to 7 do
      if ((mem[fseg:fofs+ord(txt[txtidx][x])*8+idx1 and 7] shl i) and 128) <> 0 then
        bitmap[40,((x-1)*8)+i]:=32+(x+i+idx1) and $3f else bitmap[40,((x-1)*8)+i]:=0;
    add:=0;
    for y:=0 to 40 do begin
      offset:=diffsin[(y+idx1+idx2) and $3f];
      if offset>0 then begin
        inc(add,offset);
        repy:=0;
        while (repy<=offset) and ((add+repy)<100) do begin
          for x:=0 to 159 do begin
            col:=bitmap[y,x]; col:=col+col*256;
            pos:=(add+repy+stab[(idx2+add+x) and $ff])*320;
            if pos>0 then memw[virseg:pos+x+x]:=col;
          end;
          inc(repy);
        end;
      end;
    end;
    retrace;
    flip(virseg,vidseg);
    cls(virseg);
    inc(idx1); dec(idx2,2);
    if (idx1 mod 8)=0 then begin inc(txtidx); if txtidx>len then txtidx:=0; end;
    move(bitmap[1,0],bitmap[0,0],sizeof(bitmap)-160);
  until keypressed;
end;

var i:byte;
begin
  if paramstr(1)='' then begin
    writeln('Enter textfile on commandline.'); halt; end;
  assign(f,paramstr(1));
  reset(f);
  i:=0;
  while (not eof(f)) and (i<99) do begin
    readln(f,txt[i]);
    inc(i);
  end;
  len:=i;
  for i:=0 to 255 do stab[i]:=round(sin(pi*i/128)*20);
  getfont;
  setvideo;
  getmem(virscr,64000);
  virseg:=seg(virscr^);
  cls(virseg);
  dosomescrolling;
  repeat until keypressed;
  freemem(virscr,64000);
  textmode(lastmode);
end.
