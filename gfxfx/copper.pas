
{$g+}
program copper;
{ So-called 'copper-bars', by Bas van Gaalen, Holland, PD }
uses crt;
const
 pal : array [0..3*28-1] of byte =
   (2,4,4,4,8,8,6,12,12,8,16,16,10,20,20,12,24,24,14,28,28,16,32,32,
    18,36,36,20,40,40,22,44,44,24,48,48,26,52,52,26,52,52,28,56,56,
    28,56,56,30,60,60,30,60,60,30,60,60,33,63,63,33,63,63,33,63,63,
    33,63,63,33,63,63,30,60,60,28,56,56,26,52,52,24,48,48);

procedure copperbars(var colors; lines : word); assembler;
var i : byte;
asm
  cli
  cld
  push ds
  mov ah,0
  mov dh,3

  mov dl,0dah        { vertical retrace }
 @vert1:
  in al,dx
  test al,8
  jnz @vert1
 @vert2:
  in al,dx
  test al,8
  jz @vert2

  mov bh,1
  mov di,[lines]

 @l1:
  mov bl,bh
  inc bh
  lds si,[colors]

 @l2:
  mov dl,0c8h
  mov al,ah
  out dx,al
  inc dx
  outsb
  outsb

  mov dl,0dah        { horizontal retrace }
 @hor1:
  in al,dx
  test al,1
  jnz @hor1
 @hor2:
  in al,dx
  test al,1
  jz @hor2

  mov dl,0c9h
  outsb

  dec  di
  jz   @out
  dec  bl
  jnz  @l2
  jmp  @l1
 @out:

  pop ds
  sti
end;

begin
  repeat copperbars(pal,278); until keypressed;
end.
