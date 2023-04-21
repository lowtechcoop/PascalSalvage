
{$g+}
program testblink;
{ Disabling blink (hicolor background), the HARD way,
  by Bas van Gaalen, Holland, PD }
uses crt;
const vseg:word=$b800; off=false; on=true;

procedure blink(state:boolean); assembler;
asm
  mov dx,3dah
  in al,dx
  mov dx,3c0h
  mov al,10h+32
  out dx,al
  inc dx
  in al,dx
  and al,11110111b
  mov ah,state
  shl ah,3
  or al,ah
  dec dx
  out dx,al
end;

procedure scrwrite(s:string; x,y,col:byte);
var offset : word; i : byte;
begin
  offset := y*160+x+x;
  if length(s) > 0 then
    for i := 0 to length(s)-1 do
      memw[vseg:offset+i+i] := col*256+ord(s[i+1]);
end;

procedure waitkey; begin
  repeat until keypressed;
  while keypressed do readkey;
end;

var x,y:byte;
begin
  if lastmode=7 then vseg:=$b000;
  textcolor(white); textbackground(black);
  clrscr;
  for y:=0 to 15 do for x:=0 to 15 do scrwrite(' x ',3*x,y,y*16+x);
  waitkey; blink(off); waitkey; blink(on); waitkey; {textmode(lastmode);}
end.
