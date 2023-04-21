
{$g+,n+,e-}

{ Reals   :       -1     -0.1      0.3   -1.139
  Complex :        0      0.8     -0.5    0.238 }

program Julia;
{ Julia Fractal, mode 13h. By Bas van Gaalen, Holland, PD
  Compile it, and run from Dos. Let it calculate for a while, and then
  enjoy the effect...
  Make sure you have enough memory (384000 bytes) left! }
uses
  crt;
const
  max=6; { mem needed: 6*320*200=384000 bytes }
  vidseg:word=$a000;
type
  real=double;
var
  virscr:array[0..max-1] of pointer;
  virseg:array[0..max-1] of word;
  heap:pointer;
  cx,cy,xo,yo,x1,y1:real;
  mx,my,a,b,i,orb:word;
  zoom,n,dir:shortint;

procedure setpal(col,r,g,b : byte); assembler; asm
  mov dx,03c8h; mov al,col; out dx,al; inc dx; mov al,r
  out dx,al; mov al,g; out dx,al; mov al,b; out dx,al; end;

procedure retrace; assembler; asm
  mov dx,03dah; @vert1: in al,dx; test al,8; jnz @vert1
  @vert2: in al,dx; test al,8; jz @vert2; end;

begin
  {write('Real part: '); readln(cx);} cx:=0.3;
  {write('Imaginary part: '); readln(cy);} cy:=-0.5;
  asm mov ax,13h; int 10h; end;
  for i:=1 to 64 do setpal(i,10+i div 3,10+i div 3,15+round(i/1.306122449));
  mark(heap);
  for n:=0 to max-1 do begin
    mx:=319; my:=199;
    for a:=0 to mx do
      for b:=0 to my do begin
        zoom:=n-3;
        xo:=-2-0.5*zoom+a/(mx/(4+zoom)); { x complex plane coordinate }
        yo:=2+0.5*zoom-b/(my/(4+zoom)); { y complex plane coordinate }
        orb:=0; i:=0;
        repeat
          x1:=xo*xo-yo*yo+cx;
          y1:=2*xo*yo+cy;
          xo:=x1;
          yo:=y1;
          inc(i);
        until (i=64) or (x1*x1+y1*y1>4) or (abs(x1)>2) or (abs(y1)>2);
        if i<>64 then orb:=i;
        mem[vidseg:b*320+a]:=orb; { Plot orbit }
      end;
    getmem(virscr[n],320*200);
    virseg[n]:=seg(virscr[n]^);
    move(mem[vidseg:0],mem[virseg[n]:0],320*200);
    {fillchar(mem[vidseg:0],320*200,0);}
  end;

  { play ping pong }
  n:=0; dir:=1;
  repeat
    retrace;
    move(mem[virseg[n]:0],mem[vidseg:0],320*200);
    inc(n,dir); if (n=max-1) or (n=0) then dir:=-dir;
  until keypressed;

  while keypressed do readkey;
  release(heap);
  textmode(lastmode);
end.
