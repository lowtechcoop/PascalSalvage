{$g+}
program mode_x;
{ First real Hardware scroll try, by Bas van Gaalen, Holland, PD }
uses crt;
const
  vidseg:word=$a000;
  width:word=0;
  heigth:word=0;
  bytesperline:word=0;
type
  str80=string[40];
var
  txtfile:text;
  txt:array[1..100] of str80;
  virscr:pointer;
  fofs,fseg:word;

procedure getfont; assembler; asm
  mov ax,1130h
  mov bh,1
  int 10h
  mov fseg,es
  mov fofs,bp
end;

procedure setpal(col,r,g,b:byte); assembler;
asm
  mov dx,03c8h
  mov al,col
  out dx,al
  inc dx
  mov al,r
  out dx,al
  mov al,g
  out dx,al
  mov al,b
  out dx,al
end;

procedure settextmode; assembler;
asm
  mov ax,3
  int 10h
end;

procedure setmodex; assembler;
asm
  mov ax,0013h
  int 10h
  mov dx,03c4h
  mov ax,0604h
  out dx,ax
  mov ax,0f02h
  out dx,ax
  mov cx,320*200
  mov es,vidseg
  xor ax,ax
  mov di,ax
  rep stosw
  mov dx,03d4h
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
  mov ax,80
  mul [y]
  mov dx,[x]
  shr dx,2
  add ax,dx
  mov di,ax
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

procedure writeline(nr:byte; sy:word);
var i,j,k:byte;
begin
  for i:=1 to 40 do for j:=0 to 7 do for k:=0 to 7 do
    if ((mem[fseg:fofs+ord(txt[nr][i]) shl 3+j] shl k) and 128) <> 0 then
      putpixel(((i-1) shl 3)+k,sy+j,10) else putpixel(((i-1) shl 3)+k,sy+j,0);
end;

var x,y,smty:word; txty:byte;
begin
  setmodex;
  getfont;
  fillchar(txt,sizeof(txt),0);
  assign(txtfile,'hscroll.pas');
  reset(txtfile);
  for y:=1 to 100 do readln(txtfile,txt[y]);
  for x:=1 to 127 do setpal(127+x,128-x div 2,128-x div 2,10);
  for x:=1 to 128 do setpal(x,128-x div 3,128-x div 2,30);

  txty:=1; smty:=200;
  repeat
    retrace;
    if (smty mod 8)=0 then begin
      writeline(txty,smty mod 400);
      txty:=1+txty mod 100;
    end;
    setaddress((smty-200)*80);
    inc(smty); if smty>600 then smty:=200;
  until keypressed;

  settextmode;
end.

{ Did work on other computers, not on my own. ;-(
  I guess the ET-4000 has a major bug!
  Or maybe it just aint downwards compatible... }
