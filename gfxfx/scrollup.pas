
{$g+}
program scroll_up;
uses crt;
const
  vidseg:word=$a000;
type
  str40=string[40];
var
  txtfile:text;
  txt:array[1..100] of str40;
  virscr:pointer;
  virseg,fofs,fseg:word;

procedure getfont; assembler; asm
  mov ax,1130h
  mov bh,1
  int 10h
  mov fseg,es
  mov fofs,bp
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

procedure retrace; assembler;
asm
  mov dx,3dah
 @vert1:
  in al,dx
  test al,8
  jnz @vert1
 @vert2:
  in al,dx
  test al,8
  jz @vert2
end;

procedure moveup; assembler;
asm
  push ds
  mov es,virseg
  mov ds,virseg
  xor di,di
  mov si,320
  mov cx,320*200/2
  rep movsw
  pop ds
end;

procedure flip(src,dst:word); assembler;
asm
  push ds
  mov ax,[dst]
  mov es,ax
  mov ax,[src]
  mov ds,ax
  xor si,si
  xor di,di
  mov cx,320*200/2
  rep movsw
  pop ds
end;

var x,y:word;
begin
  getfont;
  getmem(virscr,320*201);
  virseg:=seg(virscr^);
  asm
    mov ax,13h
    int 10h
    mov es,virseg
    xor di,di
    xor ax,ax
    mov cx,320*200/2
    rep stosw
  end;
  assign(txtfile,'scrollup.pas');
  reset(txtfile);
  for y:=1 to 100 do readln(txtfile,txt[y]); { read 100 lines text }
  y:=0;
  repeat
    retrace;
    setaddress(y*80);
    y:=1+y mod 2; if y=2 then moveup;
    for x:=0 to 319 do mem[virseg:320*200+x]:=16+random(16);
    flip(virseg,vidseg);
  until keypressed;
  freemem(virscr,320*201);
  asm mov ax,3; int 10h; end;
end.
