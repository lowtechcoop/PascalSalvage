program scrvir;

uses crt;

var
   ch,t1,t2:char;
   damn:array[1..80,0..25] of byte;
   colo:array[1..80,0..25] of byte;
   x,y:integer;

procedure gchar;
begin;
for y:=0 to 24 do
    for x:=1 to 80 do
    begin;
    damn[x,y]:=lo(memw[$b800:((80*y)+x)*2]);
    colo[x,y]:=hi(memw[$b800:((80*y)+x)*2]);

    end;
end;
procedure pchar;
begin;


for y:= 24 downto 0 do
    for x:=80 downto 1 do
    begin;
    textattr:=(colo[x,y]);
    write(chr(damn[x,y]));
    end;
end;

begin;
gchar;
clrscr;
pchar;
end.
