{$g+,n+,e-}

{ Reals   :       -1     -0.1      0.3   -1.139
  Complex :        0      0.8     -0.5    0.238 }

program Julia;
{ Julia Fractal, uses hardcoded ET4000 SVGA mode! By Bas van Gaalen, Holland, PD }
uses crt,graph;
type real=double;
var cx,cy,xo,yo,x1,y1:real; mx,my,a,b,i,orb:word;

procedure setpal(col,r,g,b : byte); assembler; asm
  mov dx,03c8h; mov al,col; out dx,al; inc dx; mov al,r
  out dx,al; mov al,g; out dx,al;; mov al,b; out dx,al; end;

procedure setvideo;
var grmd,grdr:integer;
{$f+} function detectvga:integer; begin detectvga:=2; end; {$f-}
begin
  installuserdriver('svga256',@detectvga); grdr := 0;
  initgraph(grdr,grmd,'i:\bgi');
end;

begin
  write('Real part: '); readln(cx);
  write('Imaginary part: '); readln(cy);
  setvideo;
  for i:=1 to 64 do setpal(i,15+round(i/1.306122449),10+i div 3,10+i div 3);
  mx:=639; my:=479;
  for a:=1 to mx  do
    for b:=1 to my do begin
      xo:=-2+a/(mx/4); { X complex plane coordinate }
      yo:=2-b/(my/4); { Y complex plane coordinate }
      orb:=0; i:= 0;
      repeat
        x1:=xo*xo-yo*yo+cx; y1:=2*xo*yo+cy; xo:=x1; yo:=y1; inc(i);
      until (i=64) or (x1*x1+y1*y1>4) or (abs(x1)>2) or (abs(y1)>2);
      if i<>64 then orb:=i;
      putpixel(a,b,orb); { Plot orbit }
    end;
  while not keypressed do;
  while keypressed do readkey;
  textmode(lastmode);
end.
