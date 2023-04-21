program unitmaybe;
uses crt,gfx3;
var x,y,z:integer;
    tx1,ty1,tx2,ty2:integer;
const
xc=160;
yc=100;
zfactor=200;

procedure putpix3d(x,y,z:double;col:byte);
var x3d,y3d:integer;
begin;
x3d:=xc+round(x*z /zfactor);
y3d:=yc+round(y*z/zfactor);
putpixel(x3d,y3d,col,vaddr);
end;


procedure lineof3d(x1,y1,z1,x2,y2,z2:double;c:byte);
begin;
tx1:=xc+round(x1*z1/zfactor);
ty1:=yc+round(y1*z1/zfactor);
tx2:=xc+round(x2*z2/zfactor);
ty2:=yc+round(y2*z2/zfactor);
line(tx1,ty1,tx2,ty2,c,vaddr);
end;
procedure box3d(c1x,c1y,c1z,len,wid,dep:double;c:byte);
begin;
lineof3d(c1x,c1y,c1z,c1x+wid,c1y,c1z,c); {hafta draw lines to 8 corners}
lineof3d(c1x,c1y,c1z,c1x,c1y+len,c1z,c);

lineof3d(c1x,c1y+len,c1z,c1x+wid,c1y+len,c1z,c);
lineof3d(c1x+wid,c1y+len,c1z,c1x+wid,c1y,c1z,c);

lineof3d(c1x,c1y,c1z,c1x,c1y,c1z+dep,c);
lineof3d(c1x+wid,c1y,c1z,c1x+wid,c1y,c1z+dep,c);
lineof3d(c1x,c1y+len,c1z,c1x,c1y+len,c1z+dep,c);
lineof3d(c1x+wid,c1y+len,c1z,c1x+wid,c1y+len,c1z+dep,c);

lineof3d(c1x,c1y,c1z+dep,c1x+wid,c1y,c1z+dep,c);
lineof3d(c1x,c1y,c1z+dep,c1x,c1y+len,c1z+dep,c);

lineof3d(c1x,c1y+len,c1z+dep,c1x+wid,c1y+len,c1z+dep,c);
lineof3d(c1x+wid,c1y+len,c1z+dep,c1x+wid,c1y,c1z+dep,c);
end;

procedure runmine;
begin;
x:=-10;
repeat
x:=x-1;
box3d(5,5,x,10,10,x,x);
flip(vaddr,vga);
cls(vaddr,0);

until x=-500;
end;

begin;
randomize;
setupvirtual;
setmcga;
cls(vaddr,0);
runmine;
repeat
until keypressed=true;
settext;
shutdown;
end.

