program newlcdthing;
{iom pissed while i'm writing this iblah}
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
  tempzx,x,adder:byte;
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
if dot=1 then number:=number+'1';

end;

procedure d1;
begin
   gotoxy(2,1);
   write('±');
   gotoxy(3,1);
   write('±');
end;
procedure d2;
begin
gotoxy(1,2);
write('±');
end;
procedure d3;
begin
gotoxy(2,3);
write('±');
gotoxy(3,3);
write('±');
end;
procedure d4;
begin
gotoxy(4,2);
write('±');
end;
procedure d5;
begin
gotoxy(1,4);
write('±');
end;
procedure d6;
begin
gotoxy(2,5);
write('±');
gotoxy(3,5);
write('±');
end;
procedure d7;
begin
gotoxy(4,4);
write('±');
end;

procedure numb(num:byte);
begin
case num of
1:begin;d4;d7;end;
2:begin;d1;d3;d4;d5;d6;end;
3:begin;d1;d3;d4;d6;d7;end;
4:begin;d2;d3;d4;d7;end;
5:begin;d1;d2;d3;d6;d7;end;
6:begin;d1;d2;d3;d5;d6;d7;end;
7:begin;d1;d4;d7;end;
8:begin;d1;d2;d3;d4;d5;d6;d7;end;
9:begin;d1;d2;d3;d4;d6;d7;end;
0:begin;d1;d2;d4;d5;d6;d7;end;
end;
end;
procedure blank;
begin;
textcolor(0);
numb(8);
end;

procedure drawlcd;
begin
x:=0;
repeat
blank;
x:=x+1;
textcolor(x);
numb(x);
delay(5000);
until x=9
end;



begin
clrscr;
drawlcd;
readkey;
end.
