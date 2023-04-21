program genpass;

uses dos,crt;
var temp:array[1..7] of integer;
    pw:array[1..7] of string;
    x,y,code:integer;
    z,pword:string;
    pwfil:file;
procedure getpass;
begin;
  write('Password you want:');
  Readln(pword);
end;

procedure writepass;

begin;
x:=0;
repeat
x:=x+1;
  z:=copy(pword,x,1) ;
  pw[x]:=z;
until x=10;
x:=0;
repeat
x:=x+1;
   val(pw[x],temp[x],code);
   if code <>0 then write(code);
until x=7;

end;

begin;
clrscr;
getpass;
writepass;
x:=0;
repeat
x:=x+1;
write (pw[x]);
until x=10;
end.

