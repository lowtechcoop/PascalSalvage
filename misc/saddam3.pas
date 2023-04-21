program getsaddam;
uses crt,robwin;
 var pal:palettetype;
     x,y,gx,gy,posx,posy,increase,exit:integer;
     image:pointer;
     kill:pointer;
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
       increase:=1;
     end;
    if ch=chr(27) then halt;
  end;

end;

procedure moveright;
begin;
increase:=0;
x:=0;
y:=165;
posy:=170;
repeat;
  put(x,y,image);
  checkkey;
  if increase=1 then begin
    posy:=posy-1;
     put(posx,posy,image);
    if posy<random(75) then begin
      increase:=0;
    end;
  end;
  delay(5);
  x:=x+1;
until x>307;
end;

procedure moveleft;

begin;
increase:=0;
x:=307;
y:=165;
posy:=170;
repeat;
  put(x,y,image);
  checkkey;
  if increase=1 then begin
    posy:=posy-1;
    get(posx,posy,posx+12,posy+32,kill);
    put(posx,posy,image);
    delay(25);
    put(posx,posy,kill);

    if posy<random(75) then increase:=0;
  end;
  delay(5);
  x:=x-1;
until x<1;
end;

begin;

initVGAmode;
locatepcx('bomb.pcx',pal,0,0,12,32);
get(0,0,12,32,image);

usepalette(pal);
hidemouse;
loadpcx('devteam.pcx',pal);

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
