uses crt;
 var x,y:integer;

procedure WriteXY(x, y : integer; s : string);
begin
  if (x in [1..80]) and (y in [1..25]) then
  begin
    GoToXY(x, y);
    Write(s);
  end ;
  end;
procedure setmode(mode:byte);
begin;
asm
mov al,[mode];
xor ah,ah
int 10h
end;
end;


begin;
{setmode($13);

directvideo:=false;
}
textmode(co40);
textbackground(3);
textcolor(15);
write('*** Commodore 64 *** ');
repeat
until keypressed=true;
setmode($3);
end.
