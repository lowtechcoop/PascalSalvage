{$A+,R-,S-,N-,L-,O-,D-,X+,G+,F+}
{ My new Circle Program...  }
{ Real cool circley thingee... like on TankWars }
{ Copyright Blair Harrison 1997 }

uses crt;

var red :longint;
       cir:longint;
       col:longint;
    FgColor:integer;
    f:Integer;


procedure pset(x,y:word;col:byte);
begin
if x<320 then
   if y<200 then
asm

 mov ah,$c
 xor bh,bh
 mov al,[col]
 mov cx,[x]
 mov dx,[y]
 int $10

end;
end;
procedure pale;

Begin
     Red:=0;

     Repeat;

       col:=col+1;
       if col>254 then col:=2;
       port[$3c8]:=col;
       port[$3c9]:=red;             {change these to get diff colours}
       port[$3c9]:=red;             {make sure it's the same below}
       port[$3c9]:=red;
       repeat
       f:=f+1;
       until f>150;
       f:=1;
       Red:=Red+1;
     until red=64;

     Repeat;
       Red:=Red-1;
       col:=col+1;
       if col>254 then col:=2;
       port[$3c8]:=col;
       port[$3c9]:=red;
       port[$3c9]:=red;
       port[$3c9]:=red;
     until red=1;
end;

Procedure Circle (x_center, y_center, radius : Integer);
{ Draw a circle with center (x_center,y_center) and radius 'radius' }
Var
  x, y, d : Integer;

Begin
  { bressenham circle algorithm using integer-only arithmetic }
  x:=0; y:=radius; d:=2*(1-radius);
  While y>=0 Do Begin
    pset (x_center+x,y_center+y,FgColor);
    pset (x_center+x,y_center-y,FgColor);
    pset (x_center-x,y_center+y,FgColor);
    pset (x_center-x,y_center-y,FgColor);
    If d +y > 0 then Begin
      Dec (y);
      Dec (d,2*y+1);         { Change these to get diff Patterns }
    End;
    If x > d then Begin
      Inc (x);
      Inc (d,2*x+1);         { <---- here too }
    End;
  End;
End;




procedure circ;
begin
  cir:=200;
  repeat;
    if col<1 then col:=254;
    col:=col-1;
    cir:=cir-1;
    FgColor:=col;         { The two circle routines make it slightly off }
    Circle(160,99,cir);   { Centre, But it doesn't have black pixels in the }
    Circle(160,100,cir);  { Middle of it! comment out one and see how ugly }
  until cir<1;            { it looks... took me ages to figure out that... }
end;

function setscreenmode(mode:byte):boolean; assembler;
asm
 mov al,[mode]
 xor ah,ah
 int $10
 mov ah,$f
 int $10
 cmp al,[mode]
 je @itworked
 xor al,al
 jmp @end
@itworked:
 mov al,1
@end:
end;


begin
randomize;
setscreenmode($13);
circ;

repeat;
pale;
until keypressed=true;
setscreenmode($3);
end.
