
program cannonball;
uses crt;
const vidseg:word=$a000; g=-9.81; x0=0; y0=100; v0=50; phi=50; dt=0.01;
var t:real; xt,yt,v:integer;

function rad(alpha:integer):real; begin
  rad:=(alpha/180)*pi; end;

begin
  asm mov ax,13h; int 10h; end;
  t:=0; v:=v0; yt:=1;
  while (not keypressed) and (yt>=0) do begin
    xt:=x0+round(v0*cos(rad(phi))*t);
    yt:=y0+round(v*sin(rad(phi))*t+0.5*g*t*t);
    mem[vidseg:(199-yt)*320+xt]:=15;
    t:=t+dt;
  end;
  while keypressed do readkey;
  while not keypressed do;
  textmode(lastmode);
end.
