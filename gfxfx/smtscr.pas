
program smoothtextscroll;
{ hardware smooth text scroll, by Bas van Gaalen, and Sven van Heel,
  Holland, PD }
uses crt;
const vidseg:word=$b800; lines=8; txt:string=' Bas was here...  ';
var fofs,fseg:word; ofs:byte;

procedure getfont; assembler;
asm
  push bp
  mov ax,1130h
  mov bh,1
  int 10h
  mov fseg,es
  mov fofs,bp
  pop bp
end;

procedure vertrace; assembler;
asm
  mov dx,03dah
 @vert1:
  in al,dx
  test al,8
  jnz @vert1
 @vert2:
  in al,dx
  test al,8
  jz @vert2
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

procedure setsmooth(smt:byte); assembler;
asm
  mov dx,03c0h
  mov al,13h+32
  out dx,al
  inc dx
  in al,dx
  and al,11110000b
  mov ah,smt
  or al,ah
  dec dx
  out dx,al
end;

procedure setup(ad:word); assembler;
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

  mov dx,03c0h
  mov al,10h+32
  out dx,al
  inc dx
  in al,dx
  and al,11011111b
  or al,00100000b
  dec dx
  out dx,al
end;

procedure bordercut;
begin
   port[$3d4] := $11;
   port[$3d5] := port [$3d5] and $7f;

   port[$3d4] := 1;     { display end }
   port[$3d5] := 78;
   port[$3d4] := 5;     { end hor retrace }
   port[$3d5] := 1;
   port[$3d4] := $11;
   port[$3d5] := port [$3d5] or $80;
end;

var x,y,i,ch:word; cx,txtidx:byte;
begin
  textmode(co80);
  getfont;
  setup(lines*16);
  setaddress((25-lines)*80);
  bordercut;
  gotoxy(4,1); writeln('Hey, a smooth textscroll...'); { note the pos! }
  x:=0; cx:=0; txtidx:=1; i:=8;
  repeat
    vertrace;
    setsmooth(x); ofs:=ofs mod 4;
    x:=(3+x) mod 9;
    if x=3 then begin
      ch:=byte(txt[txtidx]) shl 3;
      for y:=0 to lines-1 do begin
        move(mem[$b800:(25-lines+y)*160+4],mem[$b800:(25-lines+y)*160+2],158);
        if boolean((mem[fseg:fofs+ch+y] shr i) and 1) then
          memw[vidseg:(25-lines+y)*160+158]:=$1fdb else
          memw[vidseg:(25-lines+y)*160+158]:=$1020;
      end;
      i:=(i-1) mod 8; if i=0 then txtidx:=1+txtidx mod length(txt);
    end;
  until keypressed;
  textmode(lastmode);
end.
