
{$g+}
program horline;
uses crt;
{ Horizontal line routine (for polygons), by Bas van Gaalen, Holland, PD }
procedure hline(x1,x2,y:word; c:byte); assembler;
asm
  mov es,sega000
  mov bx,[x1]
  mov cx,[x2]
  cmp bx,cx
  jle @skip
  xchg bx,cx
 @skip:
  mov ax,[y]
  shl ax,6
  mov di,ax
  shl ax,2
  add di,ax
  add di,bx
  sub cx,bx
  mov al,[c]
  rep stosb
end;

begin
  asm mov ax,13h; int 10h; end;
  randomize;
  repeat
    hline(random(320),random(320),random(200),random(256));
  until keypressed;
  asm mov ax,3; int 10h; end;
end.
