program blair3d;  { Wow! I wrote a 3d Starfield!!!! in about an hour!! }
uses crt,gfx3;

var x,y,tdx,tdy,rx,col:longint;

    stars:array[1..600] of array[1..3] of longint;

procedure gensta;
begin;
   for x:=1 to 600 do begin;
       stars[x,1]:=random(320*5)+1;
       stars[x,2]:=random(200*5)+1;
       stars[x,3]:=random(300)+100;
       rx:=random(2);
       if rx=1 then stars[x,1]:=stars[x,1]*(-1);
       rx:=random(2);
       if rx=1 then stars[x,2]:=stars[x,2]*(-1);


       tdx:=stars[x,1] div stars[x,3] ;
       tdy:=stars[x,2] div stars[x,3];


       putpixel(160-tdx,100-tdy,8,vga);

       end;
end;
procedure movestars;
begin;

   for x:=1 to 600 do begin;
       if stars[x,3]>0 then dec (stars[x,3],4);
       if stars[x,3]<2 then begin
       stars[x,3]:=random(300)+1;
       rx:=random(2)+1;
       if rx=2 then rx:=-1;
       stars[x,2]:=random(200*5)*rx;
       rx:=random(2)+1;
       if rx=2 then rx:=-1;
       stars[x,1]:=random(320*5)*rx;
       end;

       tdx:=stars[x,1] div stars[x,3] ;
       tdy:=stars[x,2] div stars[x,3];
       if (tdx<160) then
       if tdx>-160 then
       if tdy<100 then
       if tdy>-100 then begin
         if stars[x,3]>50 then col:=45;
         if stars[x,3]>100 then col:=25;
         if stars[x,3]>150 then col:=45;
         if stars[x,3]>200 then col:=255;


       putpixel(160+tdx,100+tdy,col,vaddr);
       end;
end;
end;
procedure pale;
begin;
for x:=0 to 255 do begin;
port[$3c8]:=x;
port[$3c9]:=x;
port[$3c9]:=x;
port[$3c9]:=x;
end;
end;

begin;
randomize;
setupvirtual;
setmcga;
gensta;
pale;
repeat
movestars;
waitretrace;
flip(vaddr,vga);
cls(vaddr,0);
until keypressed=true;
shutdown;
textmode(lastmode);

end.

