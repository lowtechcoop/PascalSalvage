program texss;
uses crt,gfx3;
var x,y:integer;
    w:word;
procedure doscreen;
begin
x:=1;
repeat
   line(x,1,x,199,x xor 5,vaddr);
   x:=x+2;
until x=319;
Y:=1;
repeat
   line(1,y,319,y,y xor 14,vaddr);
   y:=y+2;
until y=199;

end;
procedure antialias;
begin
for w:=1 to 64000 do
begin
mem[vaddr:w]:=(mem[vaddr:w+1]+mem[vaddr:w-1]+mem[vaddr:w+20]+mem[vaddr:w-320]) div 4

end;
end;
procedure setpal;
begin
x:=0;
repeat
x:=x+1;
pal(x,x ,0,x+x );
until x=255;
x:=0;

end;



begin
setupvirtual;
directvideo:=false;
setmcga;
setpal;
cls(vga,0);
cls(vaddr,0);
doscreen;
x:=0;
repeat
antialias;
x:=x+1;
flip(vaddr,vga);
until x=29;
repeat until keypressed;
settext;
shutdown;



end.

