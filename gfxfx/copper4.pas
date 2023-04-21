
{$g+}
program copper;
{ Graphics version of copper-stuff (4), by Bas van Gaalen, Holland, PD }
uses crt;
const
 size=1; { 1 or 2 }
 dither=2; { 0 though 5 }
 pal1 : array [0..3*28-1] of byte =
   (4,4,2,8,8,4,12,12,6,16,16,8,20,20,10,24,24,12,28,28,14,32,32,16,
    36,36,18,40,40,20,44,44,22,48,48,24,52,52,26,52,52,26,56,56,28,
    56,56,28,60,60,30,60,60,30,60,60,30,63,63,33,63,63,33,63,63,33,
    63,63,33,63,63,33,60,60,30,56,56,28,52,52,26,48,48,24);
 pal2 : array [0..3*28-1] of byte =
   (4,2,2,8,4,4,12,6,6,16,8,8,20,10,10,24,12,12,28,14,14,32,16,16,
    36,18,18,40,20,20,44,22,22,48,24,24,52,26,26,52,26,26,56,28,28,
    56,28,28,60,30,30,60,30,30,60,30,30,63,33,33,63,33,33,63,33,33,
    63,33,33,63,33,33,60,30,30,56,28,28,52,26,26,48,24,24);
var fofs,fseg:word;

procedure getfont; assembler; asm
  mov ax,1130h; mov bh,6; int 10h; mov fseg,es; mov fofs,bp; end;

procedure setpal(var p;start:byte); assembler; asm
  push ds; lds si,[p]; mov al,start; mov dx,03c8h; out dx,al
  inc dx; mov cx,3*28-1; rep outsb; pop ds; end;

procedure copperbars;
var l,x:word; lo,lc,cc:byte;
begin
  l:=0; lo:=1;
  while l<>190 do begin
    lc:=lo; inc(lo,size); cc:=0;
    while (lc<>0) and (l<>190) do begin
      for x:=0 to 319 do mem[sega000:l*320+x]:=16+cc+random(dither);
      inc(cc); dec(lc); inc(l);
    end;
  end;
end;

procedure writetxt(x,y:word; txt:string);
var i,j,k:byte;
begin
  for i:=1 to length(txt) do for j:=0 to 15 do for k:=0 to 7 do
    if ((mem[fseg:fofs+ord(txt[i])*16+j] shl k) and 128) <> 0 then begin
      mem[$a000:(y+j+1)*320+(i*8)+x+k+1]:=0;
      mem[$a000:(y+j)*320+(i*8)+x+k]:=70-j-k+random(2*dither);
    end;
end;

begin
  asm mov ax,13h; int 10h; end;
  setpal(pal1,16); { try pal2 }
  setpal(pal2,50); { try pal1 }
  getfont;
  copperbars;
  writetxt(10,100,'Nothing special...');
  writetxt(10,116,'Looks very gamish, though. ;-)');
  writetxt(10,132,'So-called ''copper''');
  writetxt(10,148,'seems to be working alright.');
  repeat until keypressed;
  textmode(lastmode);
end.
