
program bigscroll;
uses crt;
const vidseg:word=$b800; spd=1; ys=3; xs=5; txt:string=' Large enough?   ';
var virscr:pointer; virseg,fofs,fseg:word;

procedure getfont; assembler; asm { gets 8x16 font }
  mov ax,1130h; mov bh,6; int 10h; mov fseg,es; mov fofs,bp; end;

procedure retrace; assembler; asm { waits for vertical retrace }
  mov dx,3dah; @vert1: in al,dx; test al,8; jz @vert1
  @vert2: in al,dx; test al,8; jnz @vert2; end;

procedure cls(lvseg:word); assembler; asm { clear segment }
  mov es,[lvseg]; xor di,di; xor ax,ax; mov cx,2*80*48; rep stosw; end;

procedure flip(src,dst:word); assembler; asm { copy virt scr to visual scr }
  push ds; mov es,[dst]; mov ds,[src]; xor si,si
  xor di,di; mov cx,2*80*48; rep movsw; pop ds; end;

procedure ssl(lvseg:word); assembler; asm { scrolls text screen left }
  push ds; mov es,[lvseg]; mov ds,[lvseg]; xor di,di; mov si,2; mov dx,48
  @l0: mov cx,79; rep movsw; add si,2; add di,2; dec dl; jnz @l0; pop ds; end;

procedure scroll;
var s,x,x2,y,y2,ch,txtidx:byte;
begin
  txtidx:=1;
  repeat
    ch:=byte(txt[txtidx]);
    for x:=7 downto 0 do
      for x2:=1 to xs do begin
        retrace;
        for s:=1 to spd do ssl(virseg);
        for y:=0 to 15 do
          if boolean((mem[fseg:fofs+ch*16+y] shr x) and 1) then
            for y2:=0 to ys-1 do memw[virseg:(y*ys+y2)*160+158]:=2011 else
            for y2:=0 to ys-1 do memw[virseg:(y*ys+y2)*160+158]:=32;
        flip(virseg,vidseg);
      end;
    txtidx:=1+txtidx mod length(txt);
  until keypressed;
end;

begin
  textmode(co80+font8x8); { needs VGA }
  getfont;
  getmem(virscr,2*80*50);
  virseg:=seg(virscr^);
  cls(virseg);
  scroll;
  freemem(virscr,2*80*50);
  textmode(lastmode);
end.
