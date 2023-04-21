program sethitext;
uses crt;
function setscreenmode(mode:byte):boolean; assembler;
asm
 mov al,[mode]
 xor ah,ah
 int $10
end;

function svga(mode:word):boolean;assembler;
asm
   mov ax,4F02h
   mov bx,[mode]
   int $10
end;

begin;
clrscr;
svga(120);
directvideo:=false;
repeat;
write('hello ');

 until keypressed;
setscreenmode(3);
end.
