{$r-,q-}
program wormhole;
{ Wormhole (a-la '2nd Reality'), by Bas van Gaalen, Holland, PD }
uses crt;
const vidseg:word=$a000; divd=128; astep=5; xst=4; yst=5;
var
  sintab:array[0..449] of integer;
  stab,ctab:array[0..255] of integer;
  virscr:pointer;
  virseg:word;
  lstep:byte;

procedure setpal(col,r,g,b : byte); assembler; asm
  mov dx,03c8h; mov al,col; out dx,al; inc dx; mov al,r
  out dx,al; mov al,g; out dx,al; mov al,b; out dx,al; end;

procedure drawpolar(xo,yo,r,a:word; c:byte; lvseg:word);
var x,y:word;
begin
  x:=160+xo+(r*sintab[90+a]) div (divd-20);
  y:=100+yo+(r*sintab[a]) div divd;
  if (x<320) and (y<200) then mem[lvseg:320*y+x]:=c;
end;

procedure cls(lvseg:word); assembler; asm
  mov es,[lvseg]; xor di,di; xor ax,ax; mov cx,320*200/2; rep stosw; end;

procedure flip(src,dst:word); assembler; asm
  push ds; mov ax,[dst]; mov es,ax; mov ax,[src]; mov ds,ax
  xor si,si; xor di,di; mov cx,320*200/2; rep movsw; pop ds; end;

var x,y,i,j:word; c:byte;
begin
  asm mov ax,13h; int 10h; end;
  for i:=0 to 255 do begin
    ctab[i]:=round(cos(pi*i/128)*60);
    stab[i]:=round(sin(pi*i/128)*45);
  end;
  for i:=0 to 449 do sintab[i]:=round(sin(2*pi*i/360)*divd);
  getmem(virscr,64000);
  virseg:=seg(virscr^);
  cls(virseg);
  x:=30; y:=90;
  repeat
    {while (port[$3da] and 8) <> 0 do;
    while (port[$3da] and 8) = 0 do;}
    c:=19; lstep:=2; j:=10;
    while j<220 do begin
      i:=0;
      while i<360 do begin
        drawpolar(ctab[(x+(200-j)) mod 255],stab[(y+(200-j)) mod 255],j,i,c,virseg);
        inc(i,astep);
      end;
      inc(j,lstep);
      if (j mod 3)=0 then begin inc(lstep); inc(c); if c>31 then c:=31; end;
    end;
    x:=xst+x mod 255;
    y:=yst+y mod 255;
    flip(virseg,vidseg);
    cls(virseg);
  until keypressed;
  while keypressed do readkey;
  freemem(virscr,64000);
  textmode(lastmode);
end.
