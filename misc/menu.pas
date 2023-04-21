program bmenu;
uses crt,dos     ;

var
c: Char;


procedure mainmenu;
begin;
clrscr;
writeln('               Blair''s Menu');
writeln('            Version 0.000alpha');
writeln('');
writeln('       A. Comms');
writeln('       B. Games');
Writeln('       C. Utils');
Writeln('       D. Dos Shell');
Writeln('       E. List');
c:=readkey;
gotomenu(c)
End;

Procedure menua;
begin;
clrscr;
writeln('               Blair's Menu');
writeln('            Version 0.000alpha');
Writeln('                  Menu A');
writeln('');
writeln('       A. Telemate');
Writeln('       B. Blue Wave');
Writeln('       C. Hard Reset Modem');
writeln('       d. Return to main menu');

end;
procedure gotomenu(c:char);
begin;
if (c='A')then
begin;
menua;
end;
end;


begin;
mainmenu;
end.
