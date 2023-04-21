program new3dstarfield;

uses crt,gfx3;

var x,y,z,a,b,c:integer;
    stars:array[1..100,1..6] of integer;
{ x,xtimes,y,ytimes,z,speed}
const
xc=160;
yc=100;
zfactor=200;
procedure putpix3d(x,y,z:double;col:byte);
var x3d,y3d:integer;
begin;
x3d:=xc+round(x*z /zfactor);
y3d:=yc+round(y*z/zfactor);
if (x3d>1) or (x3d<319) then
   if (y3d>1) or (y3d<199) then
   begin
putpixel(x3d,y3d,col,vaddr);
end;

end;

procedure genstars;
begin;
   for x:=1 to 100 do
       begin
          stars[x,1]:=random(320);
          stars[x,2]:=random(2);
          stars[x,3]:=random(200);
          stars[x,4]:=random(2);
          stars[x,5]:=random(200);
          stars[x,4]:=random(5);

       end;
end;

procedure drawstars;
begin
     for x:=1 to 100 do
         begin
         putpix3d(stars[x,1],stars[x,3],stars[x,5],15);

        end;
flip(vaddr,vga);
end;
procedure erase;
begin
     for x:=1 to 100 do
         begin
         putpix3d(stars[x,1],stars[x,3],stars[x,5],0);

        end;
flip(vaddr,vga);
end;

procedure movestars;
begin
     for x:=1 to 100 do
         begin
           if stars[x,2]=1 then  begin
              stars[x,1]:=stars[x,1]*(-1);
           end;
              if stars[x,4]=1 then  begin
              stars[x,3]:=stars[x,1]*(-1);
              end;
stars[x,5]:=stars[x,5]+stars[x,6];
        end;
end;



begin
setupvirtual;
setmcga;
cls(vaddr,0);
cls(vga,0);
genstars;
repeat
movestars;
drawstars;
{erase;}
until keypressed=true;
settext;
shutdown;

end.
