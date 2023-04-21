program d3d;
uses crt,gfx3;
const
xc=160;
yc=100;

var zfactor:integer;
    tx1,ty1,tx2,ty2:integer;

procedure line3d(x1,y1,z1,x2,y2,z2:double;c:byte);
begin;
tx1:=xc+round(x1*z1/zfactor);
ty1:=yc+round(y1*z1/zfactor);
tx2:=xc+round(x2*z2/zfactor);
ty2:=yc+round(y2*z2/zfactor);
line(tx1,ty1,tx2,ty2,c,vaddr);
end;
procedure box3d(x1,y1,z1,x2,y2,z2:double;c:byte);
var c1,c2,c3,c4,f1,f2,f3,f4:integer;
begin;


procedure lineof3d;
var x,y,z,xx,yy,zz:double;
    r:integer;
begin;

zfactor:=200;
zz:=100;
yy:=0;
xx:=0;
x:=0;
y:=0;
z:=0;

repeat;
x:=x+2;
y:=y+2;
z:=z+1;

line3d(x,y,z,xx,yy,zz,5);
flip(vaddr,vga);
{cls(vaddr,0);
}
until x>100  ;
end;

begin;
randomize;
setupvirtuAL;
setmcga;
cls(vaddr,0);
directvideo:=false;
lineof3d;
repeat;
until keypressed=true;
shutdown;
settext;
end.
