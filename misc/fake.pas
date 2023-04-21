program fake3dstars;
uses crt,gfx3;
var stars:array [1..200] of array [1..3] of integer;
var x,y,temp:integer;
const max=200;


procedure genstars;
begin;
    for x:=1 to max do begin;
       stars[x,1]:=random(320);
       stars[x,2]:=random(200);
       stars[x,3]:=random(3)+1;

       inc(stars[x,1],stars[x,3]);
       inc(stars[x,2],stars[x,3]);

       putpixel(stars[x,1],stars[x,2],8,vaddr);
    end;
end;
procedure movestars;
begin;
   for x:=1 to max do begin;

       if stars[x,1]>160 then
       if stars[x,2]>100 then begin   {bottom right sector}
           inc(stars[x,1],stars[x,3]);
           inc(stars[x,2],stars[x,3]);
       end;

       if stars[x,1]<160 then
       if stars[x,2]>100 then begin   {bottom left sector}
           dec(stars[x,1],stars[x,3]);
           inc(stars[x,2],stars[x,3]);
       end;

       if stars[x,1]>160 then
       if stars[x,2]<100 then begin   {top right sector}
           inc(stars[x,1],stars[x,3]);
           dec(stars[x,2],stars[x,3]);
       end;

       if stars[x,1]<160 then
       if stars[x,2]<100 then begin   {top left sector}
           dec(stars[x,1],stars[x,2]+3);
           dec(stars[x,2],stars[x,2]);
       end;
       temp:=temp+1;
       if temp>10000 then begin
       temp:=0;
       genstars;
       end;

       putpixel(stars[x,1],stars[x,2],8,vaddr);
end;
end;
begin;
randomize;
setmcga;
setupvirtual;
genstars;
repeat;
movestars;
waitretrace;
flip(vaddr,vga);
cls(vaddr,0);
until keypressed=true;

shutdown;
end.
