
program plasma;
uses
  crt;
const
  vidseg:word=$a000;
  border:boolean=false;
var
  stab:array[0..255] of byte;
  address,x,y:word;
  i1,i2,j1,j2,c:byte;

procedure setborder(col:byte); assembler; asm
  xor ch,ch; mov cl,border; jcxz @out; mov dx,3dah; in al,dx
  mov dx,3c0h; mov al,11h+32; out dx,al; mov al,col; out dx,al; @out: end;

procedure setpal(c,r,g,b:byte); assembler; asm
  mov dx,3c8h; mov al,[c]; out dx,al; inc dx; mov al,[r]
  out dx,al; mov al,[g]; out dx,al; mov al,[b]; out dx,al; end;

procedure retrace; assembler; asm
  mov dx,3dah; @vert1: in al,dx; test al,8; jz @vert1
  @vert2: in al,dx; test al,8; jnz @vert2; end;

procedure setaddress(ad:word); assembler; asm
  mov dx,3d4h; mov al,0ch; mov ah,[byte(ad)+1]; out dx,ax
  mov al,0dh; mov ah,[byte(ad)]; out dx,ax; end;

procedure doplasma; assembler;
asm
  mov es,vidseg
 @run:
  call retrace
  add i1,1
  add j1,1
  mov si,5
  mov ax,si
  shl ax,6
  mov di,ax
  shl ax,4
  add di,ax
  add di,20
 @l0:
  xor bh,bh
  mov bl,i1
  add bx,si
  and bx,$ff
  mov dl,byte ptr stab[bx]
  xor bh,bh
  mov bl,j1
  mov dh,byte ptr stab[bx]
  mov cx,10
 @l1:
  mov bx,dx
  add bx,cx
  xor bh,bh
  mov al,byte ptr stab[bx]
  mov bx,dx
  shr bx,8
  add bx,si
  xor bh,bh
  add al,byte ptr stab[bx]
  mov ah,al
  mov [es:di],ax
  add di,2
  add ax,$1010
  mov [es:di],ax
  add di,318
  mov [es:di],ax
  sub ax,$1010
  add di,2
  mov [es:di],ax
  sub di,318
  inc cx
  cmp cx,80
  jne @l1
  add di,360
  inc si
  cmp si,85
  jne @l0
  in al,$60
  cmp al,$80
  ja @run
end;

begin
  asm mov ax,13h; int 10h; end;

  for x:=0 to 63 do begin
    setpal(x,x div 4,x div 2,x div 2);
    setpal(127-x,x div 4,x div 2,x div 2);
    setpal(127+x,x,x div 4,x div 2);
    setpal(254-x,x,x div 4,x div 2);
  end;
  for x:=0 to 255 do stab[x]:=round(sin(2*pi*x/255)*128)+128;

  i1:=50; j1:=90; address:=0;
  doplasma;

  textmode(lastmode);
end.
