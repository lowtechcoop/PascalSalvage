
program copper;
{ Real-time color-mix-copper (6 for slow systems),
  by Bas van Gaalen, Holland, PD }
uses crt;
const size=300; step=25; bars=3;
var
  pal:array[0..3*size-1] of byte;
  stab:array[0..255] of word;
  bartab:array[0..bars-1] of word;

procedure createtab; var i:byte; begin
  for i:=0 to 255 do stab[i]:=round(sin(2*pi*i/255)*86)+86; end;

procedure movebars;
var n,i:word;
begin
  fillchar(pal,3*size,0);
  for n:=0 to bars-1 do begin
    for i:=0 to 63 do pal[n mod 3+3*stab[bartab[n]]+3*i]:=i;
    for i:=0 to 63 do pal[n mod 3+3*stab[bartab[n]]+3*64+3*i]:=63-i;
    bartab[n]:=1+bartab[n] mod 255;
  end;
end;

procedure copperbars;
var cc,l:word;
begin
  asm cli end;
  while (port[$3da] and 8)<>0 do;
  while (port[$3da] and 8)=0 do;
  cc:=0;
  for l:=0 to size-1 do begin
    port[$3c8]:=0;
    port[$3c9]:=pal[cc];
    port[$3c9]:=pal[cc+1];
    while (port[$3da] and 1)<>0 do;
    while (port[$3da] and 1)=0 do;
    port[$3c9]:=pal[cc+2];
    inc(cc,3);
  end;
  asm sti end;
end;

var i:byte;
begin
  fillchar(pal,sizeof(pal),0);
  for i:=0 to bars-1 do bartab[i]:=step*i;
  createtab;
  repeat
    movebars;
    copperbars;
  until keypressed;
end.
