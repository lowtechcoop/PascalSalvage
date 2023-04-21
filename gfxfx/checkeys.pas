
program Check;
{ Check (extended) key, by Bas van Gaalen, Holland, PD }
uses crt;
var Ch : char;
begin
  clrscr;
  writeln('Press keys for keycode, <escape> - 27 - for end...');
  writeln;
  repeat
    Ch := readkey;
    if Ch = #0 then begin
      Ch := readkey;
      write('0':5,ord(Ch):5);
    end else write(ord(Ch):10);
    writeln(': ',Ch);
  until Ch = #27;
end.
