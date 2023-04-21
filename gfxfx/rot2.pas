
program _Rotation;
{ Quite buggy source of Rotating Starfield, by Bas van Gaalen, Holland, PD }
uses
  crt,dos;

const
  gseg : word = $a000;
  NofPoints = 100;                                       { Number of 'stars' }
  Speed = 2;                                              { Speed of 'stars' }
  Xc : word = 0;                                           { Center: X, Y, Z }
  Yc : word = 0;
  Zc : word = 250;
  SinTab : array[0..255] of integer = (
    0,3,6,9,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58,60,63,66,68,
    71,74,76,79,81,84,86,88,91,93,95,97,99,101,103,105,106,108,110,111,
    113,114,116,117,118,119,121,122,122,123,124,125,126,126,127,127,127,
    128,128,128,128,128,128,128,127,127,127,126,126,125,124,123,122,122,
    121,119,118,117,116,114,113,111,110,108,106,105,103,101,99,97,95,93,
    91,88,86,84,81,79,76,74,71,68,66,63,60,58,55,52,49,46,43,40,37,34,31,
    28,25,22,19,16,13,9,6,3,0,-3,-6,-9,-13,-16,-19,-22,-25,-28,-31,-34,
    -37,-40,-43,-46,-49,-52,-55,-58,-60,-63,-66,-68,-71,-74,-76,-79,-81,
    -84,-86,-88,-91,-93,-95,-97,-99,-101,-103,-105,-106,-108,-110,-111,
    -113,-114,-116,-117,-118,-119,-121,-122,-122,-123,-124,-125,-126,
    -126,-127,-127,-127,-128,-128,-128,-128,-128,-128,-128,-127,-127,
    -127,-126,-126,-125,-124,-123,-122,-122,-121,-119,-118,-117,-116,
    -114,-113,-111,-110,-108,-106,-105,-103,-101,-99,-97,-95,-93,-91,
    -88,-86,-84,-81,-79,-76,-74,-71,-68,-66,-63,-60,-58,-55,-52,-49,
    -46,-43,-40,-37,-34,-31,-28,-25,-22,-19,-16,-13,-9,-6,-3);

type
  PointRec = record
               X,Y,Z : integer;
             end;
  PointPos = array[0..NofPoints] of PointRec;

var
  Point : PointPos;

{----------------------------------------------------------------------------}

procedure SetGraphics(Mode : word); assembler; asm
  mov ax,Mode; int 10h end;

{----------------------------------------------------------------------------}

function Sinus(Idx : byte) : integer; begin
  Sinus := SinTab[Idx]; end;

{----------------------------------------------------------------------------}

function Cosin(Idx : byte) : integer; begin
  Cosin := SinTab[(Idx+192) mod 255]; end;

{----------------------------------------------------------------------------}

procedure Init;

var
  I : word;

begin
  randomize;
  for I := 0 to NofPoints do begin
    Point[I].X := random(250)-125;
    Point[I].Y := random(250)-125;
    Point[I].Z := random(250)-125;
  end;
  for I := 0 to 63 do begin
    port[$3C8] := I;
    port[$3C9] := 0;
    port[$3C9] := I;
    port[$3C9] := I;
  end;
end;

{----------------------------------------------------------------------------}

procedure DoRotation;

const
  Xstep = 1;                                        { Rotation 'round x-axes }
  Ystep = 1;
  Zstep = 1;

var
  Xp,Yp : array[0..NofPoints] of word;
  X,Y,Z,X1,Y1,Z1 : integer;
  I : word;
  Color,PhiX,PhiY,PhiZ : byte;

begin
  PhiX := 0; PhiY := 0; PhiZ := 0;                            { Begin values }
  asm mov es,gseg end;
  repeat
    while (port[$3da] and 8) <> 8 do;
    while (port[$3da] and 8) = 8 do;
    for I := 0 to NofPoints do begin

      asm
        mov si,i                  { get index }
        shl si,1                  { x2 for word-size }
        mov ax,word ptr yp[si]    { get indexed-value from yp }
        cmp ax,200                { check if value greater than 200 }
        jae @skip                 { if so, then jump out }
        mov bx,word ptr xp[si]    { get indexed-value from xp }
        cmp bx,320                { check if value greater than 320 }
        jae @skip                 { if so, then jump out }
        shl ax,6                  { multiply with 64 }
        mov di,ax                 { keep in di }
        shl ax,2                  { multiply with 4 }
        add di,ax                 { add with di (64+(4*64)=320) }
        add di,bx                 { add horizontal value }
        xor al,al                 { al zero (black color) }
        mov [es:di],al            { move to screen }
       @skip:
      end;

      X1 := (Cosin(PhiY)*Point[I].X-Sinus(PhiY)*Point[I].Z) div 128;
      Y1 := (Cosin(PhiZ)*Point[I].Y-Sinus(PhiZ)*X1) div 128;
      Z1 := (Cosin(PhiY)*Point[I].Z+Sinus(PhiY)*Point[I].X) div 128;
      X  := (Cosin(PhiZ)*X1+Sinus(PhiZ)*Point[I].Y) div 128;
      Y  := (Cosin(PhiX)*y1+Sinus(PhiX)*z1) div 128;
      Z  := (Cosin(PhiX)*Z1-Sinus(PhiX)*Y1) div 128;

      Xp[I] := 160+(Xc*Z-X*Zc) div (Z-Zc);
      Yp[I] := 100+(Yc*Z-Y*Zc) div (Z-Zc);

      asm
        mov si,i
        shl si,1
        mov ax,word ptr yp[si]
        cmp ax,200
        jae @skip
        mov bx,word ptr xp[si]
        cmp bx,320
        jae @skip
        shl ax,6
        mov di,ax
        shl ax,2
        add di,ax
        add di,bx
        mov ax,z                  { get z (depth) value }
        shr ax,3                  { divide by 8 (range/8=32) }
        add ax,30                 { add 30, ax is now in range 0 -> 64 }
        mov [es:di],al
       @skip:
      end;

      inc(Point[I].Z,Speed); if Point[I].Z > 125 then Point[I].Z := -125;
    end;
    inc(PhiX,Xstep);
    inc(PhiY,Ystep);
    inc(PhiZ,Zstep);
  until keypressed;
end;

{----------------------------------------------------------------------------}

begin
  SetGraphics($13);
  Init;
  DoRotation;
  textmode(lastmode);
end.
