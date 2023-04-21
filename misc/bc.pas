{$A+,R-,S-,N-,L-,O-,D-,X+,G+,F+}
{ My new Circle Program... may have to hack it a bit }
{ Copyright Blair Harrison 1997 }

uses crt;

var cir,red :integer;
       col:byte;
    FgColor:integer;
    f:LongInt;

procedure pset(x,y:word;col:byte); assembler;
asm
 mov ah,$c
 xor bh,bh
 mov al,[col]
 mov cx,[x]
 mov dx,[y]
 int $10
end;

procedure pale;

Begin
     Red:=0;

     Repeat;
       repeat
       f:=f+1;
       until f=400;
       f:=0;
       Red:=Red+1;
       col:=col+1;
       if col>254 then col:=1;
       port[$3c8]:=col;
       port[$3c9]:=red;
       port[$3c9]:=0;
       port[$3c9]:=red;
     until red=62;
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
    If d + y > 0 then Begin
      Dec (y);
      Dec (d,2*y+1);
    End;
    If x > d then Begin
      Inc (x);
      Inc (d,2*x+1);
    End;
  End;
End;
procedure circ;
begin
  repeat;
  col:=col+1;
    if col>255 then col:=1;
    cir:=cir+1;
    FgColor:=col;
    Circle(160,100,cir);
  until cir>100;

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
setscreenmode($13);
circ;
repeat;
pale;
until keypressed=true;
setscreenmode($3);
end.
