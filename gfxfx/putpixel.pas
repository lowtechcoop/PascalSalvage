
{ Direct screen writing in SuperVGA mode 640x480x256 on a TsengLabs ET4000 }

program tsenglabs_et4000_640x480x256_mode;
uses crt;
const vseg : word = $a000;
var x,y : word; p : integer; i,page : byte;

procedure putpixel(xp,yp : word; col : byte); assembler;
asm
  mov es,vseg
  mov ax,yp
  mov dx,640
  mul dx
  add ax,xp
  adc dx,0
  mov di,ax
  cmp dl,page
  je @skip
  mov page,dl
  mov al,dl
  mov dx,03cdh { <- bankswitch port, 64k banks }
  out dx,al
 @skip:
  mov al,col
  mov [es:di],al
end;

procedure setpal(col,r,g,b : byte); assembler; asm
  mov dx,03c8h; mov al,col; out dx,al; inc dx; mov al,r
  out dx,al; mov al,g; out dx,al; mov al,b; out dx,al; end;

begin
  asm mov ax,2eh; int 10h; end;
  page := 0;
  for i := 1 to 255 do setpal(i,255-i div 4,255-i div 4,30);
  for x := 0 to 639 do for y := 0 to 479 do putpixel(x,y,x*x+y*y);
  p := 0;
  repeat until keypressed;
  asm mov ax,3; int 10h; end;
end.

{ Safety: }
{ mov dx,3bfh; mov al,3; out dx,al; mov dx,3d8h; mov al,0a0h; out dx,al }
{ 3b8h in monochrome mode }
