program texss;
uses crt,gfx3;
var x,y:integer;
    w:word;

procedure putpix(x,y:integer;col:byte;where:word);
begin
  mem[where:(320*y)+x]:=(col XOR mem[where:(320*y)+x])
end;
Procedure xLine(a,b,c,d:integer;col:byte;where:word);
  { This draws a solid line from a,b to c,d in colour col }
  function sgn(a:real):integer;
  begin
       if a>0 then sgn:=+1;
       if a<0 then sgn:=-1;
       if a=0 then sgn:=0;
  end;
var i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;
begin
     u:= c - a;
     v:= d - b;
     d1x:= SGN(u);
     d1y:= SGN(v);
     d2x:= SGN(u);
     d2y:= 0;
     m:= ABS(u);
     n := ABS(v);
     IF NOT (M>N) then
     BEGIN
          d2x := 0 ;
          d2y := SGN(v);
          m := ABS(v);
          n := ABS(u);
     END;
     s := m shr 1;
     FOR i := 0 TO m DO
     BEGIN
          putpix(a,b,col,where);
          s := s + n;
          IF not (s<m) THEN
          BEGIN
               s := s - m;
               a:= a + d1x;
               b := b + d1y;
          END
          ELSE
          BEGIN
               a := a + d2x;
               b := b + d2y;
          END;
     end;
END;
procedure doscreen;
begin
x:=1;
repeat
   xline(x,1,x,199,x xor 25,vga);
   x:=x+2;
until x=319;
Y:=1;
repeat
   xline(1,y,319,y,y xor 25,vga);
   y:=y+2;
until y=199;

end;
procedure drawthing;
begin
for y:=1 to 199 do
   for x:=1 to 300 do
   begin
{   putpix(y,x,25,vga);}
    xline(y,x,y+10,x+10,25,vga);


   end;
end;

procedure antialias;
begin
for w:=1 to 64000 do
begin
mem[vga:w]:=(mem[vga:w+1]+mem[vga:w-1]+mem[vga:w+320]+mem[vga:w-320]) div 4;

end;
end;
procedure setpal;
begin
x:=0;
repeat
x:=x+1;
pal(x,x div 2,x div 4,x div 2);
until x=255;
x:=0;

end;






begin
directvideo:=false;
setmcga;
setpal;
cls(vga,0);
doscreen;
x:=0;
repeat
antialias;
x:=x+1;
until x=10;
drawthing;

repeat until keypressed;
settext;


end.

