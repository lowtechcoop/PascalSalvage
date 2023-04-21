
program game_sprites;
{ Slow game-sprites-example, by Bas van Gaalen, Holland, PD }
uses crt;
const w=16; h=16;
type sprbuf=array[0..w*h-1] of byte;
var bckbuf,sprite:sprbuf; px,py:word;

procedure setpal(col,r,g,b : byte); assembler; asm
  mov dx,03c8h; mov al,col; out dx,al; inc dx; mov al,r
  out dx,al; mov al,g; out dx,al; mov al,b; out dx,al; end;

procedure retrace; assembler; asm
  mov dx,03dah; @l1: in al,dx; test al,8; jnz @l1
  @l2: in al,dx; test al,8; jz @l2; end;

procedure putsprite(x,y:word; spr:sprbuf);
var i,j:byte;
begin
  { re-display old backupbuffer on old location }
  for i:=0 to w-1 do
    for j:=0 to h-1 do
      mem[sega000:(py+j)*320+px+i]:=bckbuf[j*w+i];
  { get new backupbuffer at new location }
  for i:=0 to w-1 do
    for j:=0 to h-1 do
      bckbuf[j*w+i]:=mem[sega000:(y+j)*320+x+i];
  px:=x; py:=y;
  { draw sprite at current location }
  for i:=0 to w-1 do
    for j:=0 to h-1 do
      if spr[j*w+i]<>0 then
        mem[sega000:(y+j)*320+x+i]:=spr[j*w+i];
end;

var i,j:word;
begin
  asm mov ax,13h; int 10h; end;
  for i:=1 to 255 do setpal(i,255-i div 6,255-i div 4,20);
  fillchar(bckbuf,sizeof(bckbuf),0);
  { create background }
  for i:=0 to 319 do
    for j:=0 to 199 do
      mem[sega000:j*320+i]:=round(5+0.4*i+0.4*j)+random(10);
  { create random sprite }
  randomize;
  for i:=0 to h*w-1 do
    sprite[i]:=random(256);
  { clear middle part }
  for i:=5 to 10 do
    for j:=5 to 10 do
      sprite[j*w+i]:=0;
  i:=0;
  { save first old backup screen }
  px:=0; py:=0;
  for i:=0 to w-1 do
    for j:=0 to h-1 do
      bckbuf[j*w+i]:=mem[sega000:j*320+i];
  { move sprite over background }
  repeat
    retrace;
    putsprite(150+round(cos(pi*i/180)*100),
      100+round(sin(pi*i/180)*50),sprite);
    i:=1+i mod 360;
  until keypressed;
  textmode(lastmode);
end.

{ version 1.0, as you can see }
