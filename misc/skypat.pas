program makeskycodes; {program to make random number list of possible
                               decoder codes to try}
uses crt;
var codes:array[1..10000] of byte;
                          {value is 0 to begin... if code gen'd, value is 100}

   x,y:integer;
   test:word;
procedure setarray;
begin;
for x:=1 to 10000 do
begin
codes[x]:=0;
end;
end;

procedure guess;
var rnum:integer;
begin
test:=0;
for x:=1 to 10000 do
begin;

rnum:=random(10000);
y:=codes[rnum];
while y=100 do
 begin
  rnum:=random(10000);
  y:=codes[rnum];
 end;
test:=test+1;
writeln(test,' ',x);
codes[rnum]:=100;
end;

end;

function output(code:integer):string;
begin;

end;

begin;
clrscr;
Randomize;
setarray;
guess;
writeln(test);
end.

