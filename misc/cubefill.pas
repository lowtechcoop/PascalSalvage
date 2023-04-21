Program FireCube;{ 3d rotatey cube fire.. much better than my other fires }
                   { Blair Harrison 1998 }
                   { Basic 3d-engine routines by Vulture / Outlaw Triad }
                     
Uses Crt,gfx3;             

Const VGA = $0a000;   { VGA segment }
      MaxLines = 12;  { Max number of lines to rotate }
      Xoff: Integer = 256;     { Used to calculate vga-pos }
      Yoff: Integer = 256;
      Size = 25;      { Size of box }
      Cube: Array[1..MaxLines,1..2,1..3] of Integer =  { Our object (box) }
        (((-Size ,-Size,-size),(Size,-Size,-Size)),
         ((-Size,-Size,-Size),(-Size,Size,-Size)),
         ((-Size,Size,-Size),(Size,Size,-Size)),
         ((Size,-Size,-Size),(Size,Size,-Size)),
         ((-Size,-Size,Size),(Size,-Size,Size)),
         ((-Size,-Size,Size),(-Size,Size,Size)),
         ((-Size,Size,Size),(Size,Size,Size)),
         ((Size,-Size,Size),(Size,Size,Size)),
         ((-Size,-Size,Size),(-Size,-Size,-Size)),
         ((-Size,Size,Size),(-Size,Size,-Size)),
         ((Size,Size,Size),(Size,Size,-Size)),
         ((Size,-Size,Size),(Size,-Size,-Size)));

Var Sine: Array[0..255] of Integer;    { Contains sine&cosine values }

    Lines: Array[1..MaxLines,1..2,1..2] of Integer;  { Holds x,y coords of lines }

    OldLines: Array[1..MaxLines,1..2,1..2] of Integer; { Old lines of object }

    g,X,Y,Z: Integer;                { Variables for formula }
    a,b:word;
    c:byte;
    Xt,Yt,Zt: Integer;             { Temporary variables for x,y,z }

    XAngle,YAngle,ZAngle: Byte;    { Angles to rotate around }

    DeltaX,DeltaY,DeltaZ: Byte;    { Amound angles are increased each time }

    Zoff: Integer;                 { Distance from viewer }

    XSin,XCos: Integer;            { Sine and cosine of angle to rotate around }
    YSin,YCos: Integer;
    ZSin,ZCos: Integer;

    Mx,My: Integer;                { Middle of the screen }

    ScreenX, ScreenY: Integer;     { Screenpositions of 3d-point }

    Direction: Boolean;            { Direction of object }

    Looping: Integer;              { Variable for moving object }
    newfire:file;
    jennie:string;
NumRead, NumWritten: Word;
Buf: string;

Procedure VideoMode(Mode: Byte); ASSEMBLER;
Asm
  mov  ah,00
  mov  al,Mode
  int  10h
End;

Procedure SetPixel(X,Y:Integer;Color:Byte;Where:Word); ASSEMBLER;
Asm                         { TP automatically pushes and pops ES }
  mov  ax,[Where]           { Move destination in AX }
  mov  es,ax                { es => points to VGA or virtual screen }
  mov  di,Y                 { Move Y into DI }
  mov  ax,Y                 { Move Y into AX }
  shl  di,8                 { DI := DI * 256 }
  shl  ax,6                 { AX := AX * 64 }
  add  di,ax                { DI := Y * 320 }
  mov  ax,X                 { Move X into AX }
  add  di,ax                { DI = X + Y   final location }
  mov  al,Color             { Set color }
  stosb                     { = mov  byte ptr es:[di],al => Place the dot }
End;

Procedure WaitRetrace; ASSEMBLER;  { Waits for Vertical Retrace to reduce flicker }
label l1, l2;
Asm
   mov  dx,3DAh
l1:
   in   al,dx
   and  al,08h
   jnz  l1
l2:
   in   al,dx
   and  al,08h
   jz   l2
End;

Procedure CalcSine;                   { Guess what this does... ;) }
Var I,Out: Integer;
    An: Real;
Begin
  For I := 0 to 255 Do                { 256 values }
  Begin
    An := I*(2*pi / 256);             { 2*pi coz of radians! }
    Out := Round(Sin(An)*256);
    Sine[I] := Out;                   { Save into array }
  End;
End;

Procedure Line(X1,Y1,X2,Y2:Integer;Color:Byte;Where:Word);
  Function sgn(a:real):integer;       { Nested function }
  Begin
    if a>0 then sgn := +1;
    if a<0 then sgn := -1;
    if a=0 then sgn := 0;
  End;
Var i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;
Begin
  u := X2 - X1;
  v := Y2 - Y1;
  d1x := SGN(u);
  d1y := SGN(v);
  d2x := SGN(u);
  d2y := 0;
  m := ABS(u);
  n := ABS(v);
  If not (M>N) then
  Begin
    d2x := 0;
    d2y := SGN(v);
    m := ABS(v);
    n := ABS(u);
  End;
  s := m shr 1;
  For i := 0 to m Do
  Begin
    Setpixel(X1,Y1,random(color),Where);
    s := s + n;
    IF not (s<m) Then
    Begin
      s := s - m;
      X1 := X1 + d1x;
      Y1 := Y1 + d1y;
    End
    Else
    Begin
      X1 := X1 + d2x;
      Y1 := Y1 + d2y;
    End;
  End;
End;

Procedure UpdateVars;      { Used to fly around the screen }
Begin
  If Direction then If Mx < 275 then INC(Mx) else Direction := False
    else If Mx > 45 then DEC(Mx) else Direction := True;
End;

Procedure SetRotation;          { Calculates new angles to rotate around }
Begin
  If DeltaX > 0 then XAngle := (Xangle+DeltaX) Mod 256; { Angles stop at 256 }
  If DeltaY > 0 then YAngle := (Yangle+DeltaY) Mod 256;
  If DeltaZ > 0 then ZAngle := (Zangle+DeltaZ) Mod 256;
End;

Procedure GetSineCos;
Begin
  Xsin := Sine[Xangle];                  { Grab sine from sinetable }
  Xcos := Sine[(Xangle+64) Mod 256];     { Add 64 to get cosine }
  Ysin := Sine[Yangle];
  Ycos := Sine[(Yangle+64) Mod 256];
  Zsin := Sine[Zangle];
  Zcos := Sine[(Zangle+64) Mod 256];
End;

Procedure GetOrgXYZ(Current,Place: Integer);
Begin
  X := Cube[Current,Place,1];      { Grabs our original x,y,z values }
  Y := Cube[Current,Place,2];
  Z := Cube[Current,PLace,3];
End;

Procedure RotatePoint; ASSEMBLER;  { Uses assembler-code for speed }
{ Rotates a point around x,y,z. The degrees rotated around are calculated
  using the SetRotation procedure. The (co)sine values are grabbed using
  the GetSineCos procedure. We also need the original x,y,z values of the
  current 3d-point. These are grabbed using the GetOrgXYZ procedure. }
Asm
{ Rotate around x-axis }
{ YT = Y * COS(xang) - Z * SIN(xang) / 256 }
{ ZT = Y * SIN(xang) + Z * COS(xang) / 256 }
{ Y = YT }
{ Z = ZT }
    pusha
    mov     ax,[Y]
    mov     bx,[XCos]
    imul    bx               { ax = Y * Cos(xang) }
    mov     bp,ax
    mov     ax,[Z]
    mov     bx,[XSin]
    imul    bx               { ax = Z * Sin(xang) }
    sub     bp,ax            { bp = Y * Cos(xang) - Z * Sin(xang) }
    sar     bp,8             { bp = Y * Cos(xang) - Z * Sin(xang) / 256 }
    mov     [Yt],bp

    mov     ax,[Y]
    mov     bx,[XSin]
    imul    bx               { ax = Y * Sin(xang) }
    mov     bp,ax
    mov     ax,[Z]
    mov     bx,[XCos]
    imul    bx               { ax = Z * Cos(xang) }
    add     bp,ax            { bp = Y * SIN(xang) + Z * COS(xang) }
    sar     bp,8             { bp = Y * SIN(xang) + Z * COS(xang) / 256 }
    mov     [Zt],bp

    mov     ax,[Yt]          { Switch values }
    mov     [Y],ax
    mov     ax,[Zt]
    mov     [Z],ax

{ Rotate around y-axis }
{ XT = X * COS(yang) - Z * SIN(yang) / 256 }
{ ZT = X * SIN(yang) + Z * COS(yang) / 256 }
{ X = XT }
{ Z = ZT }

    mov     ax,[X]
    mov     bx,[YCos]
    imul    bx               { ax = X * Cos(yang) }
    mov     bp,ax
    mov     ax,[Z]
    mov     bx,[YSin]
    imul    bx               { ax = Z * Sin(yang) }
    sub     bp,ax            { bp = X * Cos(yang) - Z * Sin(yang) }
    sar     bp,8             { bp = X * Cos(yang) - Z * Sin(yang) / 256 }
    mov     [Xt],bp

    mov     ax,[X]
    mov     bx,[YSin]
    imul    bx               { ax = X * Sin(yang) }
    mov     bp,ax
    mov     ax,[Z]
    mov     bx,[YCos]
    imul    bx               { ax = Z * Cos(yang) }
    add     bp,ax            { bp = X * SIN(yang) + Z * COS(yang) }
    sar     bp,8             { bp = X * SIN(yang) + Z * COS(yang) / 256 }
    mov     [Zt],bp

    mov     ax,[Xt]          { Switch values }
    mov     [X],ax
    mov     ax,[Zt]
    mov     [Z],ax

{ Rotate around z-axis }
{ XT = X * COS(zang) - Y * SIN(zang) / 256 }
{ YT = X * SIN(zang) + Y * COS(zang) / 256 }
{ X = XT }
{ Y = YT }

    mov     ax,[X]
    mov     bx,[ZCos]
    imul    bx               { ax = X * Cos(zang) }
    mov     bp,ax
    mov     ax,[Y]
    mov     bx,[ZSin]
    imul    bx               { ax = Y * Sin(zang) }
    sub     bp,ax            { bp = X * Cos(zang) - Y * Sin(zang) }
    sar     bp,8             { bp = X * Cos(zang) - Y * Sin(zang) / 256 }
    mov     [Xt],bp

    mov     ax,[X]
    mov     bx,[ZSin]
    imul    bx               { ax = X * Sin(zang) }
    mov     bp,ax
    mov     ax,[Y]
    mov     bx,[ZCos]
    imul    bx               { ax = Y * Cos(zang) }
    add     bp,ax            { bp = X * SIN(zang) + Y * COS(zang) }
    sar     bp,8             { bp = X * SIN(zang) + Y * COS(zang) / 256 }
    mov     [Yt],bp

    mov     ax,[Xt]          { Switch values }
    mov     [X],ax
    mov     ax,[Yt]
    mov     [Y],ax
    popa
End;
Procedure nRotatePoint;  { see above }
{ Rotates a point around x,y,z. The degrees rotated around are calculated
  using the SetRotation procedure. The (co)sine values are grabbed using
  the GetSineCos procedure. We also need the original x,y,z values of the
  current 3d-point. These are grabbed using the GetOrgXYZ procedure. }
begin
{ Rotate around x-axis }
YT:= ((Y * xcos) - (Z * xsin)) div 256;
ZT:= ((Y * xSIN) + (Z * xCOS)) div 256;
Y:= YT;
Z:= ZT;

{ Rotate around y-axis }
 XT:= ((X * yCOS) - (Z * ySIN)) div 256;
 ZT:= ((X * ySIN) + (Z * yCOS)) div 256;
 X:= XT;
 Z:= ZT;


{ Rotate around z-axis }
 XT:=( (X * zCOS) - (Y * zSIN)) div 256;
 YT:=( (X * zSIN) + (Y * zCOS)) div 256;
 X:= XT;
 Y:= YT;
End;

Procedure CalcPos; ASSEMBLER;
{ This procedure calculates the X, Y position of the rotated 3d-point on
  the vga-screen. These values are then stored in an array. }
Asm
    pusha
    mov     ax,[Xoff]           { Xoff*X / Z+Zoff = screen x }
    mov     bx,[X]
    imul    bx
    mov     bx,[Z]
    add     bx,[Zoff]           { Distance }
    idiv    bx
    add     ax,[Mx]             { Center on screen }
    mov     bp,ax
    mov     [ScreenX],ax

    mov     ax,[Yoff]           { Yoff*Y / Z+Zoff = screen y }
    mov     bx,[Y]
    imul    bx
    mov     bx,[Z]
    add     bx,[Zoff]           { Distance }
    idiv    bx
    add     ax,[My]             { Center on screen }
    mov     [ScreenY],ax
    popa
End;

Procedure RotateAllStuff;        { Rotates all points (lines) }
Var Loop1,Loop2: Integer;
Begin
  For Loop1 := 1 to MaxLines Do  { Do all object lines }
  Begin
    For Loop2 := 1 to 2 Do       { Both 3d-points of line }
    Begin
      GetOrgXYZ(Loop1,Loop2);    { Get the original x,y,z values }
      RotatePoint;               { Rotate the point around x,y,z }
      CalcPos;                   { And calc the screenposition }
      Lines[Loop1,Loop2,1] := ScreenX;    { Save screenpositions }
      Lines[Loop1,Loop2,2] := ScreenY;
    End;
  End;
End;

Procedure DeleteAll(Color: Byte);   { Deletes object on the screen }
Var Loop1: Integer;
    X1,Y1,X2,Y2: Integer;
Begin
  For Loop1 := 1 to MaxLines Do
  Begin
    X1 := OldLines[Loop1,1,1];      { Set end-points of line }
    Y1 := OldLines[Loop1,1,2];
    X2 := OldLines[Loop1,2,1];
    Y2 := OldLines[Loop1,2,2];
    Line(X1,Y1,X2,Y2,Color,VGA);    { Erase old line... }
  End;
End;

Procedure ShowItAll(Color: Byte);   { Shows object on the screen }
Var Loop1: Integer;
    X1,Y1,X2,Y2: Integer;
Begin
  For Loop1 := 1 to MaxLines Do
  Begin
    X1 := Lines[Loop1,1,1];         { Set end-points of line }
    Y1 := Lines[Loop1,1,2];
    X2 := Lines[Loop1,2,1];
    Y2 := Lines[Loop1,2,2];
    OldLines[Loop1,1,1] := X1;      { Save for deletion }
    OldLines[Loop1,1,2] := Y1;
    OldLines[Loop1,2,1] := X2;
    OldLines[Loop1,2,2] := Y2;
    Line(X1,Y1,X2,Y2,color,VAddr);    { Draw new line }
  End;
End;
procedure setpal;
var pall:byte;
begin;
pall:=0;
for x:=1 to 32 do begin;
port[$3c8]:=x;
port[$3c9]:=x shl 1;
port[$3c9]:=0;
port[$3c9]:=0;
end;

for x:=0 to 63 do
 begin;
    port[$3c8]:=x+32;
    port[$3c9]:=63;
    port[$3c9]:=x;
    port[$3c9]:=x; {x xor x for red}

    port[$3c8]:=x+95;
    port[$3c9]:=63;
    port[$3c9]:=63;
    port[$3c9]:=x;

    port[$3c8]:=x+158;
    port[$3c9]:=x;
    port[$3c9]:=x;
    port[$3c9]:=x;

 end;


end;
procedure drawfire;
begin;
     g:=g+1;

   for a :=1 to 50000 do  begin;
      b:=(mem[vaddr:a+1]+mem[vaddr:a-1]+mem[vaddr:a+320]+mem[vaddr:a+640]);
      {play with the above line to get diff fx!}
      c:=b shr 2;
      mem[vaddr:a] := c ;

      end;

end;

Begin                   { Main program }
  randomize;
  ClrScr;
  setupvirtual;
  cls(vaddr,0);
  cls(VGA,0);
assign(newfire, 'c:\±²Þ‘.xxš'); { Open output file }
Rewrite(newfire, 1);  { Record size = 1 }
buf:=('¯°±²³´µ²š©¥­¯°±²³´µ²š©¥­¯°±²³´µ²š©¥­¯°±²³´µ²š©¥­¯°±²³´µ²š©¥­');

  Write('Press any key to enter 3d-zone...');
  ReadKey;
  CalcSine;
  Mx := 160;
  My := 100;            { Middle of the screen }
  Direction := False;    { Go to the right first }
  Xangle := 0;          { Set initial degrees }
  Yangle := 0;
  Xangle := 0;
  DeltaX := 2;          { Degree factors }
  DeltaY := 1;
  DeltaZ := 1;
  Zoff := 1024;         { Distance from viewer }
  VideoMode($13);
 setpal;
For Looping := 1 to 256 Do
  Begin
    SetRotation;        { Set new rotation angles }
    GetSineCos;         { Grab sine & cosine of those angles }
    RotateAllStuff;     { Rotates all points/lines }
{    WaitRetrace;        { Do vertical retrace }
{    DeleteAll(0);       { Delete old lines }
    ShowItAll(150);      { Show new stuff }
    drawfire;
flip(vaddr,vga);
   Dec(Zoff,3);        { Object moves towards viewer (untill Zoff = 256 }
  End;
  Repeat
    SetRotation;        { Set new rotation angles }
    GetSineCos;         { Grab sine & cosine of those angles }
    UpdateVars;         { Used to fly around screen }
    RotateAllStuff;     { Rotates all points/lines }
{    WaitRetrace;      { Do vertical retrace }
{    DeleteAll(0);       { Delete old lines }
    ShowItAll(150);      { And show new stuff }
    BlockWrite(newfire, Buf, 10000, NumWritten);
    drawfire;
flip(vaddr,vga);
Until KeyPressed;

 ReadKey;
 VideoMode($3);
 shutdown;
Close(newfire);
 Writeln('FireCube v1.2 By The Trog');
 writeln('look out on c:\ for ±²Þ‘.xxš');


End.
