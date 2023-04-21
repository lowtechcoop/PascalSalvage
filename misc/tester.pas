program speeder;
uses dos,crt;
var x,y,x1,y1:integer;
    result:integer;
    h,m,s,hu:word;
    rab:integer;
procedure test;
begin;
repeat
gettime(h,m,s,hu);
until hu:=99;

repeat
    y:=26265;
    y1:=32222;
    x1:=y1 div y;
    result:=result+1;
    gettime(h,m,s,hu);
until hu=99;
end;

begin;
clrscr;
test;
write(result);
end.