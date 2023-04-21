
{$g+}
program mode_x;
{ First mode-x routines, needs optimizing, by Bas van Gaalen, Holland, PD }
uses crt;
const vidseg:word=$a000;
var x,y:word;

procedure setpal(col,r,g,b:byte); assembler; asm
  mov dx,03c8h; mov al,col; out dx,al; inc dx; mov al,r
  out dx,al; mov al,g; out dx,al; mov al,b; out dx,al; end;

procedure settextmode; assembler; asm
  mov ax,3; int 10h; end;

procedure vga320x200; assembler;
asm
  mov ax,0013h     { mode 13h, 320x200x256x1 }
  int 10h
  mov dx,03c4h
  mov ax,0604h     { unchain stuff: 320x200x256x4 }
  out dx,ax
  mov ax,0f02h     { select all planes }
  out dx,ax

  mov cx,320*200   { clear graphics memory }
  mov es,vidseg
  xor ax,ax
  mov di,ax
  rep stosw
  mov dx,03d4h

  mov dx,03c2h     { set 'overscan' mode here! }
  mov al,10100011b { 11100111b }
  out dx,al

  mov dx,03d4h     { misc mode-x stuff }
  mov ax,4009h
  out dx,ax
  mov ax,0014h
  out dx,ax
  mov ax,0e317h
  out dx,ax
end;

procedure putpixel(x,y:word; col:byte); assembler;
asm
  mov dx,03c4h
  mov al,2
  mov cx,[x]
  and cx,3
  mov ah,1
  shl ah,cl
  out dx,ax
  mov es,vidseg
  mov ax,[y]
  shl ax,4
  mov di,ax
  shl ax,2
  add di,ax
  mov dx,[x]
  shr dx,2
  add di,dx
  mov al,[col]
  mov [es:di],al
end;

procedure setaddress(ad:word); assembler;
asm
  mov dx,3d4h
  mov al,0ch
  mov ah,[byte(ad)+1]
  out dx,ax
  mov al,0dh
  mov ah,[byte(ad)]
  out dx,ax
end;

procedure setlinecomp(ad:word); assembler;
asm
  mov dx,3d4h
  mov al,18h
  mov ah,[byte(ad)]
  out dx,ax
  mov al,7
  out dx,al
  inc dx
  in al,dx
  dec dx
  mov ah,[byte(ad)+1]
  and ah,00000001b
  shl ah,4
  and al,11101111b
  or al,ah
  mov ah,al
  mov al,7
  out dx,ax

  mov al,9
  out dx,al
  inc dx
  in al,dx
  dec dx
  mov ah,[byte(ad)+1]
  and ah,00000010b
  shl ah,5
  and al,10111111b
  or al,ah
  mov ah,al
  mov al,9
  out dx,ax
end;

procedure retrace; assembler;
asm
  mov dx,3dah
 @vert1:
  in al,dx
  test al,8
  jz @vert1
 @vert2:
  in al,dx
  test al,8
  jnz @vert2
end;

begin
  vga320x200;

  for x:=1 to 127 do setpal(127+x,128-x div 2,128-x div 2,10);
  for x:=1 to 128 do setpal(x,128-x div 3,128-x div 2,30);

  for x:=0 to 319 do for y:=0 to 399 do putpixel(x,400+y,128+(x*x+y*y) mod 128);
  for x:=0 to 319 do for y:=0 to 399 do putpixel(x,y,(x*x-y*y) mod 128);

  repeat
    for y:=0 to 99 do begin
      retrace;
      setaddress(400*80+80*(round(cos(pi*y/50)*80)+80));
      setlinecomp(20+4*(round(sin(pi*y/50)*30)+30));
    end;
  until keypressed;

  settextmode;
end.
