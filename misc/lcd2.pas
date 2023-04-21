program newlcdthing;
{iom pissed while i'm writing this iblah}
{bah! completely rewrote the entire code sober...}
{seems so simple now.....I think i'll convert it to the standard lcd
display thingee soon.. hehe.. then GFX mode display...}
uses crt;
{   1
   __
2 |3 |4
  |__|
5 |  |7
  |__| .8
    6   }
{the string of characters representing the lcd display is 1/0 format}
var number:string;
  temp:char;
  tempzx,x,y,adder:byte;
procedure drawpic;
{what a pain.... it'll take the number string and draw all the components}
begin
{1}
if (copy(number,1,1))='1' then
begin
   gotoxy(adder+2,1);
   write('±');
   gotoxy(adder+3,1);
   write('±');
end;
{2}
if (copy(number,2,1))='1' then
begin
   gotoxy(adder+1,2);
   write('±');
end;
{3}
if (copy(number,3,1))='1' then
begin
gotoxy(adder+2,3);
write('±');
gotoxy(adder+3,3);
write('±');
end;
{4}
if (copy(number,4,1))='1' then
begin
gotoxy(adder+4,2);
write('±');
end;
{5}
if (copy(number,5,1))='1' then
begin
gotoxy(adder+1,4);
write('±');
end;
{6}
if (copy(number,6,1))='1' then
begin
gotoxy(adder+2,5);
write('±');
gotoxy(adder+3,5);
write('±');
end;
{7}
if (copy(number,7,1))='1' then
begin
gotoxy(adder+4,4);
write('±');
end;
{.}
if (copy(number,8,1))='1' then
begin
gotoxy(adder+5,5);
write('Ü');
end;

end;
procedure drawnumlcd(numb,pos,col,dot:byte);
{numb:number, pos: position, col: colour, dot: decimal point?
this proc will draw a number at any position in the lcd display
in any colour, with or without a decimal point next to it....
going to try for a really modular design so i can move to gfx mode quickly}

begin
   case pos of
     1:adder:=1;
     2:adder:=6;
     3:adder:=11;
     4:adder:=16;
     5:adder:=21;
   end;
   case numb of
     1:number:='0001001';
     2:number:='1011110';
     3:number:='1011011';
     4:number:='0111001';
     5:number:='1110011';
     6:number:='1110111';
     7:number:='1001001';
     8:number:='1111111';
     9:number:='1111011';
     0:number:='1101111';
   end;
if dot=1 then number:=number+'1' else number:=number+'0';
textcolor(col);
drawpic;

end;

procedure blank(pos:byte);
begin;
drawnumlcd(8,pos,0,0);
end;

procedure drawlcd;
begin
x:=0;
y:=0;
repeat
y:=y+1;
    repeat
    blank(y);
    x:=x+1;
    drawnumlcd(x,y,x,1);
    delay(500);
    until x=9;
x:=0;
until y=5;
end;



begin
clrscr;
drawlcd;
readkey;
end.
