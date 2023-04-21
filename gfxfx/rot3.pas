
program _Rotation;
{ Rotating cube, line-routine by Winston van Oosterhout, rest
  by Bas van Gaalen, Holland, PD, try cursor up/down }
uses
  crt;

const
  ScrBase : word = $a000;
  Xc = 0;
  Yc = 0;
  Zc = 150;
  Point : array[0..7,0..2] of integer = (
    (-25,25,25),(25,25,25),(25,-25,25),(-25,-25,25),
    (-25,25,-25),(25,25,-25),(25,-25,-25),(-25,-25,-25));
  Lines : array[0..11,0..1] of byte = (
    (0,1),(1,2),(2,3),(3,0),(0,4),(1,5),(2,6),(3,7),(4,5),(5,6),(6,7),(7,4));

type
  TabType = array[0..255] of integer;

var
  SinTab : TabType;
  Color : byte;

{----------------------------------------------------------------------------}

procedure SetGraphics(Mode : byte); assembler; asm
  mov AH,0; mov AL,Mode; int 10h; end;

{----------------------------------------------------------------------------}

procedure Calcsinus(var SinTab : TabType); var I : byte; begin
  for I := 0 to 255 do SinTab[I] := round(sin(2*I*pi/255)*128); end;

{----------------------------------------------------------------------------}

function Sinus(Idx : byte) : integer; begin
  Sinus := SinTab[Idx]; end;

{----------------------------------------------------------------------------}

function Cosinus(Idx : byte) : integer; begin
  Cosinus := SinTab[(Idx+192) mod 255]; end;

{----------------------------------------------------------------------------}

procedure Line(X1,Y1,X2,Y2 : integer); assembler;

const XInc : integer = 1; OffS : word = $140;
var Incr2 : integer;

asm
  mov ax,Y1; mov cx,Y2; sub cx,ax; je @Hline;
  mov bx,X2; mov dx,X1; sub bx,dx; je @VLine;
  sub ax,Y2; cwd; xor ax,dx; sub ax,dx; mov si,dx; mov cx,ax
  mov ax,X1; sub ax,X2; cwd; xor ax,dx; sub ax,dx; cmp ax,cx
  jl @YLine; jmp @XLine
 @HLine:
  mov es,ScrBase; mov dx,X1; mov cx,X2; cmp dx,cx; jle @HContinue; xchg dx,cx
 @HContinue:
  sub cx,dx; mov di,dx; xchg ah,al; add di,ax; shr ax,1; shr ax,1
  add di,ax; inc cx; mov al,Color; rep stosb; jmp @Exit
 @VLine:
  mov es,ScrBase; cmp cx,0; jg @VContinue; neg cx; mov ax,Y2
 @VContinue:
  inc cx; mov di,dx; xchg ah,al; add di,ax; shr ax,1
  shr ax,1; add di,ax; mov al,Color
 @VRunLoop:
  mov es:[di],al; add di,140h; loop @VRunLoop; jmp @Exit
 @YLine:
  mov es,ax; sub ax,cx; shl ax,1; mov sp,ax; mov XInc,1; mov ax,es
  shl ax,1; mov bx,ax; sub bx,cx; cmp si,-1; je @Y2greaterY1
 @Y1greaterY2:
  mov si,ax; mov ax,X2; cmp dx,-1; mov dx,Y2; je @YNeg; jmp @YContinue
 @Y2greaterY1:
  mov si,ax; mov ax,X1; cmp dx,0; mov dx,Y1; je @YNeg; jmp @YContinue
 @YNeg:
  neg XInc
 @YContinue:
  mov di,ax; xchg dh,dl; add di,dx; shr dx,1; shr dx,1
  add di,dx; mov ah,Color; mov es,ScrBase; inc cx
 @YRunLoop:
  mov es:[di],ah; add di,140h; cmp bx,0; jl @YNoInc; add bx,sp
  add di,XInc; jmp @YCheck
 @YNoInc:
  add bx,si
 @YCheck:
  loop @YRunLoop; jmp @Exit
 @XLine:
  cmp dx,-1; jle @X2greaterX1
  mov bx,X2; mov dx,Y2; cmp si,-1; mov si,140h; je @XNeg; jmp @XContinue
 @X2greaterX1:
  mov bx,X1; mov dx,Y1; cmp si,-1; mov si,140h; jne @XNeg; jmp @XContinue
 @XNeg:
  neg si
 @XContinue:
  mov di,bx; xchg dh,dl; add di,dx; shr dx,1; shr dx,1; add di,dx
  mov sp,cx; sub sp,ax; shl sp,1; mov bx,cx; shl bx,1; mov OffS,si
  mov si,bx; sub bx,ax; mov cx,ax; mov es,ScrBase; mov ah,Color; inc cx
 @XRunLoop:
  mov es:[di],ah; inc di; cmp bx,0; jl @XNoInc; add bx,sp; add di,OffS; jmp @XCheck
 @XNoInc:
  add bx,si
 @XCheck:
  loop @XRunLoop
 @Exit:
end;

{----------------------------------------------------------------------------}

procedure pal(colour,r,g,b : byte); assembler;
{ This sets the Red, Green and Blue values of a certain color }
asm
  mov dx,3c8h
  mov al,[colour]
  out dx,al
  inc dx
  mov al,[r]
  out dx,al
  mov al,[g]
  out dx,al
  mov al,[b]
  out dx,al
end;

procedure Rotate;

const
  Xstep = 1;
  Ystep = 1;
  Zstep = -1;

var
  Xp,Yp : array[0..7] of word;
  X,Y,Z,X1,Y1,Z1 : integer;
  I,Key,PhiX,PhiY,PhiZ : byte;

begin
  PhiX := 0; PhiY := 0; PhiZ := 0;
  for I := 0 to 7 do begin Xp[I] := 0; Yp[I] := 0; end;
  repeat
    while (port[$3da] and 8) <> 8 do;
    while (port[$3da] and 8) = 8 do;

    pal(0,0,0,50);

    Color := 0;
    for I := 0 to 11 do
      Line(Xp[Lines[I,0]],Yp[Lines[I,0]],Xp[Lines[I,1]],Yp[Lines[I,1]]);

    for I := 0 to 7 do begin
      X1 := (Cosinus(PhiY)*Point[I,0]-Sinus(PhiY)*Point[I,2]) div 128;
      Y1 := (Cosinus(PhiZ)*Point[I,1]-Sinus(PhiZ)*X1) div 128;
      Z1 := (Cosinus(PhiY)*Point[I,2]+Sinus(PhiY)*Point[I,0]) div 128;
      X := (Cosinus(PhiZ)*X1+Sinus(PhiZ)*Point[I,1]) div 128;
      Y := (Cosinus(PhiX)*Y1+Sinus(PhiX)*z1) div 128;
      Z := (Cosinus(PhiX)*Z1-Sinus(PhiX)*Y1) div 128;
      Xp[I] := 160+(Xc*Z-X*Zc) div (Z-Zc);
      Yp[I] := 100+(Yc*Z-Y*Zc) div (Z-Zc);
    end;

    Color := 7;
    for I := 0 to 11 do
      Line(Xp[Lines[I,0]],Yp[Lines[I,0]],Xp[Lines[I,1]],Yp[Lines[I,1]]);

    inc(PhiX,Xstep);
    inc(PhiY,Ystep);
    inc(PhiZ,Zstep);

    pal(0,0,0,0);

    if keypressed then begin
      Key := ord(readkey);
      if Key = 0 then begin
        Key := ord(readkey);
        case Key of
          72 : if Point[1,0] < 40 then for I := 0 to 7 do begin
                 Point[I,0] := round(Point[I,0]*1.1);
                 Point[I,1] := round(Point[I,1]*1.1);
                 Point[I,2] := round(Point[I,2]*1.1);
               end; { Up }
          80 : if Point[1,0] > 5 then for I := 0 to 7 do begin
                 Point[I,0] := round(Point[I,0]*0.9);
                 Point[I,1] := round(Point[I,1]*0.9);
                 Point[I,2] := round(Point[I,2]*0.9);
               end; { Down }
        end;
      end;
    end;
  until Key = 27;
end;

{----------------------------------------------------------------------------}

begin
  Calcsinus(SinTab);
  SetGraphics($13);
  Rotate;
  textmode(lastmode);
end.
