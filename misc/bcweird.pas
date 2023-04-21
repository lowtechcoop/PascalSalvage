{$A+,R-,S-,N-,L-,O-,D-,X+,G+,F+}
{ My new Circle Program... may have to hack it a bit }
{ Copyright Blair Harrison 1997 }

uses crt;

var red :integer;
       cir:word;
       col:byte;
    FgColor:integer;
    f:LongInt;
offs : array[0..22500] of integer; {150x150}
    b, v : pointer;

const r : byte = 40;                  {radius of sphere}
      h : integer = 20;               {distace from plane to focus point}
      d : byte = 80;                  {diameter of magnify glass}

{This is the easiest mouse routines available!}
function initmouse: word;assembler;
{Initialize mouse driver}
asm mov ax, 0h; int 33h; end;

procedure showmousecursor;assembler;
{Instruct BIOS to show mouse cursor}
asm mov ax, 01h; int 33h; end;

procedure hidemousecursor;assembler;
{Instruct BIOS to hide mouse cursor}
asm mov ax, 02h; int 33h; end;

procedure getmousepos (var x, y, button: word);
{Return the current location of the mouse}
var x1, y1, b : word;
begin
     Asm mov ax, 03h; int 33h; mov [b], bx; mov [x1], cx; mov [y1], dx; end;
     x:=x1; y:=y1; button := b;
end;

Procedure setmousewindow (X1, Y1, X2, Y2: Word);assembler;
{Set the mouse window}
asm mov ax, 07h; mov cx,[x1]; mov dx,[x2]; int 33h; inc ax;
    mov cx,[y1]; mov dx,[y2]; int 33h; end;

procedure copyw(source : pointer; dest : pointer; cnt : word);assembler;
asm {copy [cnt] words from [source] to [dest]}
   les di, [dest]    {[dest] moves into [es:di]}
   push ds           {ds must be preserved}
   lds si, [source]  {[source] moves into [ds:di]}
   mov cx, [cnt]     {cx <- [cnt] : number of words to move}
   cld               {clear the direction flag, si will increment}
   rep movsw         {copies cx words from source to destination}
   pop ds            {restore ds to it's original state}
end;

procedure cls(dest : pointer);assembler;
asm
   les di, [dest]
   mov cx, 16000
   xor ax, ax
   db $66; rep stosw
end;

procedure calc_mask; {a bit of maths!}
{this calculates the pixel mask, to optimize the speed}
var x, y, z : integer;
    ux, uy : integer;
    sx, sy : integer;
begin
     for y:=0 to d do
         for x:=0 to d do
         begin
              ux:=x - d div 2;
              uy:=y - d div 2;
              if (ux*ux+uy*uy < r*r) then {point is defined on sphere}
              begin
                   z:=round(sqrt(r*r-ux*ux-uy*uy));
                   sx:=round((h-z)*(ux/z)); {took me 2 hours to work, these}
                   sy:=round((h-z)*(uy/z)); {two formulas out!!!}
                   {point on "s phere"}
                   offs[x+y*d]:=sy*320+sx;
              end else offs[x+y*d]:=0;
         end;
end;

procedure construct(xp, yp : word);
{if you want to optimize the code, do it in this procedure, since it}
{does all the main thingies, please send me a copy then too ;)  }
var seg1, ofs1, seg2, ofs2 : word;
    x, y : word;
    vp, hp : word;
    ux, uy : integer;
begin
     seg1:=seg(b^); ofs1:=ofs(b^);
     seg2:=seg(v^); ofs2:=ofs(v^);
     copyw(b,v,32000);
     for y:=0 to d do
         for x:=0 to d do
         begin
              ux:=x - d div 2;
              uy:=y - d div 2;
              vp:=y+yp+offs[y*d+x] div 320;
              hp:=x+xp+offs[y*d+x] mod 320;
              if (vp<200) and (vp>0) and (xp<320) and (xp>0) and
                 (sqr(r-1)> ux*ux+uy*uy) then
              begin
                 mem[seg2:ofs2+(y+yp)*320+x+xp]:=
                    mem[seg1:(ofs1+vp*320+hp)];
              end;
         end;
     copyw(v,ptr($a000,000),32000);
end;

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

       Red:=Red+1;
       col:=col+1;
       if col>254 then col:=1;
       port[$3c8]:=col;
       port[$3c9]:=red;
       port[$3c9]:=0;
       port[$3c9]:=red;
     until red=62;
       repeat
       f:=f+1;
       until f=12800;
       f:=0;

     Repeat;
       Red:=Red-1;
       col:=col+1;
       if col>254 then col:=1;
       port[$3c8]:=col;
       port[$3c9]:=red;
       port[$3c9]:=0;
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
    pset (x_center-x,y_center+y,FgColor);
    pset (x_center+x,y_center-y,FgColor);
    pset (x_center-x,y_center+y,FgColor);
    pset (x_center+x,y_center-y,FgColor);
    If d +y > 0 then Begin
      Dec (y);
      Dec (d,4*y+1);
    End;
    If x > d then Begin
      Inc (x);
      Inc (d,1*y+1);
    End;
  End;
End;
procedure circ;
begin
  cir:=200;
  repeat;
  col:=col+1;
    if col>255 then col:=1;
    cir:=cir-1;
    FgColor:=col;
    Circle(160,100,cir);
    Circle(160,100,cir+1);
  until cir<1;
 copyw(ptr($a000,000),b,32000);
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

var deg : real;
    x, y, but : word;
begin
getmem(v,64000); getmem(b,64000);
randomize;
setscreenmode($13);
circ;
calc_mask;
initmouse;
setmousewindow(5,5,315-d, 200-d);
repeat
           getmousepos(x, y, but);
           construct(x,y);
           pale;
     until but=1;
{repeat;
pale;
until keypressed=true;
}
freemem(v, 64000);
     freemem(b, 64000);
setscreenmode($3);
end.
