program new3d;

uses crt,robwin;

var x,y,z,curpos:integer;
    fgcolor:byte;


Procedure Circle (x_center, y_center, radius : Integer);
{ Draw a circle with center (x_center,y_center) and radius 'radius' }
Var
  x, y, d : Integer;

Begin
  { bressenham circle algorithm using integer-only arithmetic }
  x:=0; y:=radius; d:=2*(1-radius);
  While y>=0 Do Begin
    putpixel (x_center+x,y_center+y,FgColor);
    putpixel (x_center+x,y_center-y,FgColor);
    putpixel (x_center-x,y_center+y,FgColor);
    putpixel (x_center-x,y_center-y,FgColor);
    If d +y > 0 then Begin
      Dec (y);
      Dec (d,2*y+1);         { Change these to get diff Patterns }
    End;
    If x > d then Begin
      Inc (x);
      Inc (d,2*x+1);         { <---- here too }
    End;
  End;
End;

procedure movecirc;

begin;
   z:=z-15;
   fgcolor:=10;
   circle(x,y,z);
end;

begin;
initvgamode;
x:=160;
y:=100;
z:=100;
line(160,100,240,140);
line(160,100,90,160);

repeat
   movecirc;
until z<1;
repeat
until keypressed=true;

end.


