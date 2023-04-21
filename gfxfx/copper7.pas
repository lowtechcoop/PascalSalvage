
program copper;
{ bar-fade in, copper v7.0, by Bas van Gaalen, Holland, PD }
uses crt;
const size=20;
var pal:array[0..3*size-1] of byte;

procedure incbars;
var i:word;
begin
  if pal[0]<63 then inc(pal[0]);
  for i:=3*size-2 downto 0 do pal[i+1]:=pal[i];
end;

procedure copperbars;
var cc,l,j:word;
begin
  asm cli end;
  while (port[$3da] and 8)<>0 do;
  while (port[$3da] and 8)=0 do;
  cc:=0;
  for l:=0 to size-1 do begin
    port[$3c8]:=1;
    port[$3c9]:=pal[cc];
    port[$3c9]:=pal[cc+1];
    for j:=0 to 15 do begin
      while (port[$3da] and 1)<>0 do;
      while (port[$3da] and 1)=0 do;
    end;
    port[$3c9]:=pal[cc+2];
    inc(cc,3);
  end;
  asm sti end;
end;

var i:byte;
begin
  textmode(co80);
  fillchar(pal,sizeof(pal),0);
  copperbars; { default = black -> otherwise flash of blue will appear }
  textcolor(1);
  writeln;
  writeln('Is this what you mean?'); writeln;
  for i:=1 to 15 do writeln('Test line ',i);
  repeat
    incbars;
    copperbars;
  until keypressed;
  textmode(lastmode);
end.
