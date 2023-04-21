
program switch;
{ Switching without clearing test, by Bas van Gaalen, Holland, PD }
uses crt;
var key:char;

procedure _25lines; assembler;
asm
  mov ax,83h
  int 10h
end;

procedure _50lines; assembler;
asm
  mov ax,1202h
  mov bl,30h
  int 10h
  mov ax,1112h
  mov bl,0
  int 10h
end;

begin
  writeln;
  writeln(' 0 - quit');
  writeln(' 1 - 25 lines mode');
  writeln(' 2 - 50 lines mode');
  repeat
    key:=readkey; if key=#0 then key:=readkey;
    case key of
      '1':_25lines;
      '2':_50lines;
    end;
  until key='0';
end.
