{$C}
program pw;
uses crt;
var pass,input:string;
    count:byte;
procedure askpw;
begin;
      write('Password:');

      readln(input);
end;
procedure check;
begin;
      if input=pass then count:=1;
      if count=1 then exit;
      askpw;
      check;
end;

begin;
      clrscr;
      pass:=('hello');

      count:=0;
      writeln('Welcome to the computer.');

      writeln('');
      askpw;
      check;
      writeln('YAY!');
end.
