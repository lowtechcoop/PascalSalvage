program john4;

var
day:byte;

procedure gday(date:byte);
begin;
day:= date mod 7;
case day of
0:writeln('wednesday');
1:writeln('thursday');
2:writeln('friday');
3:writeln('saturday');
4:writeln('sonday');
5:writeln('monday');
6:writeln('tuesday');
end;

end;

begin
gday(5);
end.
