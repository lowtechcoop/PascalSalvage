program hotrod2;
uses crt,menus;
begin;
clrscr;
test;
repeat;
findcar;
drag;
writeit;
nextmove;

delay(2000);
clrscr;
until finished = 'true';
clrscr;
winner;
delay(5000);
end.