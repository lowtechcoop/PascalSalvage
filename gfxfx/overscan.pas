
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
  mov al,10100011b
  out dx,al

{
3C2h (W):  Miscellaneous Output Register
bit   0  If set Color Emulation. Base Address=3Dxh else Mono Emulation.
         Base Address=3Bxh.
      1  Enable CPU Access to video memory if set
    2-3  Clock Select
          0: 14MHz(EGA)     25MHz(VGA)
          1: 16MHz(EGA)     28MHz(VGA)
          2: External(EGA)  Reserved(VGA)
      4  (EGA Only) Disable internal video drivers if set
      5  When in Odd/Even modes Select High 64k bank if set
      6  Horizontal Sync Polarity. Negative if set
      7  Vertical Sync Polarity. Negative if set
         Bit 6-7 indicates the number of lines on the display:
              0=200(EGA)  Reserved(VGA)
              1=          400(VGA)
              2=350(EGA)  350(VGA)
              3=          480(VGA).
Note: Set to all zero on a hardware reset.
Note: On the VGA this register can be read from port 3CCh.
}

  mov dx,03d4h     { misc mode-x stuff }
  (*
  mov ax,4009h     { add this one, if you want a higher resolution! }
  out dx,ax
  *)
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

begin
  vga320x200;
  for x:=1 to 127 do setpal(x,128-x div 2,128-x div 2,10);
  for x:=0 to 319 do for y:=0 to 399 do putpixel(x,y,(x*x-y*y) mod 128);
  repeat until keypressed;
  settextmode;
end.
