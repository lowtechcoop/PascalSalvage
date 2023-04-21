program texss;
uses crt,gfx3;
var x,y:integer;
    w:word;
procedure doscreen;
begin
x:=1;
repeat
   line(x,1,x,199,x xor 25,vga);
   x:=x+2;
until x=319;
Y:=1;
repeat
   line(1,y,319,y,y xor 25,vga);
   y:=y+2;
until y=199;

end;
procedure antialias;
begin
for w:=1 to 64000 do
begin
mem[vga:w]:=(mem[vga:w+1]+mem[vga:w-1]+mem[vga:w+320]+mem[vga:w-320]) div 4

end;
end;
procedure setpal;
begin
x:=0;
repeat
x:=x+1;
pal(x,x div 2,x div 4,x div 2);
until x=255;
x:=0;

end;



begin
directvideo:=false;
setmcga;
setpal;
cls(vga,0);
doscreen;
x:=0;
repeat
antialias;
x:=x+1;
until x=9;
repeat until keypressed;
settext;


end.

