
program plasma;
uses
  crt;
const
  vidseg:word=$a000;
  border:boolean=true;
var
  stab1,stab2:array[0..255] of byte;
  address,x,y:word;
  i1,i2,j1,j2,c:byte;

procedure setmode; assembler; asm
  mov ax,0013h; int 10h; mov dx,03c4h; mov ax,0604h; out dx,ax; mov dx,03d4h
  mov ax,4409h; out dx,ax; mov ax,0014h; out dx,ax; mov ax,0e317h; out dx,ax
  mov es,vidseg; xor di,di; xor ax,ax; mov cx,16000; rep stosw; end;

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

begin
  setmode;
  for x:=0 to 63 do begin
    setpal(x,x div 4,x div 2,x div 2);
    setpal(127-x,x div 4,x div 2,x div 2);
    setpal(127+x,x,x div 4,x div 2);
    setpal(254-x,x,x div 4,x div 2);
  end;
  for x:=0 to 255 do begin
    stab1[x]:=round(sin(2*pi*x/255)*128)+128;
    stab2[x]:=round(cos(2*pi*x/255)*128)+128;
  end;

  i1:=50; j1:=90; address:=0;
  repeat
    retrace;
    setborder(50);
    address:=16000-address;
    setaddress(address);
    inc(i1,-1);
    inc(j1);
    for y:=20 to 50 do begin
      i2:=stab1[(y+i1) mod 255];
      j2:=stab1[j1 mod 255];
      for x:=5 to 74 do begin
        c:=stab1[(x+i2) mod 255]+stab2[(y+j2) mod 255];
        mem[vidseg:address+y*80+x]:=c mod 255;
      end;
    end;
    setborder(0);
  until keypressed;

  textmode(lastmode);
end.
