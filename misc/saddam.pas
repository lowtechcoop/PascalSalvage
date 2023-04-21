program getsaddam;
uses crt,robwin;
 var pal:palettetype;
     x,y,posx,posy,increase,exit:integer;

     ch:string;

procedure WriteXY(x, y : integer; s : string);
begin
  if (x in [1..40]) and (y in [1..25]) then
  begin
    GoToXY(x, y);
    Write(s);
  end ;
  end;

procedure checkkey;
begin;
  if keypressed=true then begin;
     ch:=readkey;
    if ch=('x') then begin;
       if increase=0 then posx:=x;
{       posx:=x-1;
       writexy(posx,posy,'X');
       writexy(posx+1,posy,' ');
}
    increase:=1;
     end;
    if ch=chr(27) then exit:=1;
  end;

end;

procedure moveleft;
begin;
increase:=0;
x:=0;
y:=25;
repeat;
  x:=x+1;
  writexy(x,y,'^');
  writexy(x-1,y,' ');
  checkkey;
  if increase=1 then begin
    posy:=posy-1;
    writexy(posx,posy,'x');
    writexy(posx,posy+1,' ');
    if posy=1 then increase:=0;
  end;

  delay(50);
until x=40;
end;

procedure moveright;

begin;
increase:=0;
x:=40;
y:=25;
repeat;
  x:=x-1;
  writexy(x,y,'^');
  writexy(x+1,y,' ');
  checkkey;
  if increase=1 then begin
    posy:=posy-1;
    writexy(posx,posy,'x');
    writexy(posx,posy+1,' ');
    if posy=1 then increase:=0;
  end;

 delay(50);
until x=1;
end;

begin;
initVGAmode;
usepalette(pal);
loadpcx('devteam.pcx',pal);
locatepcx('bomb.pcx',pal,0,0,10,30);
usepalette(pal);
directvideo:=false;
msgbox('Get Malone v0.1alpha','This was made by Blair','(c) Blairsoft 1997');
hidemouse;
repeat
posy:=25;
moveleft;
posy:=25;
moveright;
if keypressed=true then ch:=readkey;
until ch=chr(27);

end.
