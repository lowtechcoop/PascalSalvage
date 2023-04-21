{$G+,N+,E-}

{ Reals   Complex
   -1        0
   -0.1      0.8
    0.3     -0.5
   -1.139    0.238
}

program Julia;
{ Julia Fractal, uses hardcoded ET4000 SVGA mode! By Bas van Gaalen, Holland, PD }
const vseg : word = $a000;
type real = double;
var cx,cy,xo,yo,x1,y1 : real; mx,my,a,b,i,orb : word;

procedure setpal(col,r,g,b : byte); assembler;
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

procedure putpixel(xp,yp : word; col : byte); assembler;
asm
  mov es,vseg
  mov ax,yp
  mov dx,640
  mul dx
  add ax,xp
  adc dx,0
  mov di,ax
  mov al,dl
  mov dx,03cdh
  out dx,al
  mov al,col
  mov [es:di],al
end;

function keypressed : boolean; assembler;
asm
  mov ah,0bh
  int 21h
  and al,0feh
end;

begin
  write('Real part: '); readln(cx);
  write('Imaginary part: '); readln(cy);
  asm mov ax,2eh; int 10h; end;
  for i := 1 to 64 do setpal(i,10+i div 3,10+i div 3,15+round(i/1.306122449));
  mx := 639; my := 479;
  for a := 1 to mx  do
    for b := 1 to my do begin
      xo := -2+a/(mx/4); { X complex plane coordinate }
      yo :=  2-b/(my/4); { Y complex plane coordinate }
      orb := 0; i := 0;
      repeat
        x1 := xo*xo-yo*yo+cx;
        y1 := 2*xo*yo+cy;
        xo := x1;
        yo := y1;
        inc(i);
      until (i = 64) or (x1*x1+y1*y1 > 4) or (abs(x1) > 2) or (abs(y1) > 2);
      if i <> 64 then orb := i;
      putpixel(a,b,orb); { Plot orbit }
    end;
  while not keypressed do;
  asm mov ax,3; int 10h; end;
end.
