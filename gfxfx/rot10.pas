{$g+}

program bumping_3d_sphere; { 320x200x256 mode }
{ Bumping-and-rotating sphere in mode 13h, by Bas van Gaalen, Holland, PD }
const
  dots = 99;
  gseg : word = $a000;
  _x = 0; _y = 1; _z = 2;
  spd = 2;
  dist = 100;
  divd = 1024;
  ptab : array[0..255] of byte = (
    123,121,119,117,115,114,112,110,108,106,104,103,101,99,97,96,94,92,91,
    89,87,86,84,82,81,79,78,76,75,73,72,70,69,67,66,64,63,62,60,59,58,56,
    55,54,52,51,50,49,48,46,45,44,43,42,41,39,38,37,36,35,34,33,32,31,30,
    29,28,27,26,26,25,24,23,22,21,21,20,19,18,17,17,16,15,15,14,13,13,12,
    12,11,10,10,9,9,8,8,7,7,6,6,5,5,5,4,4,4,3,3,3,2,2,2,2,1,1,1,1,1,1,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,5,5,6,6,
    7,7,7,8,8,9,9,10,11,11,12,12,13,14,14,15,16,16,17,18,19,19,20,21,22,
    23,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,
    46,47,48,49,51,52,53,54,56,57,58,60,61,62,64,65,67,68,69,71,72,74,75,
    77,78,80,82,83,85,86,88,90,91,93,95,96,98,100,102,103,105,107,109,111,
    113,114,116,118,120,122,124,126);

type
  prec = record x,y,z : integer; end;
  ppos = array[0..dots] of prec;
  styp = array[0..255] of integer;

var
  stab : styp;
  dot : ppos;

{----------------------------------------------------------------------------}

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

{----------------------------------------------------------------------------}

procedure init;
const
  ctab : array[0..99,_x.._z] of integer = (
    (-18,24,2),(14,-19,19),(23,14,-13),(-1,22,-20),(-3,1,30),(-1,5,30),
    (-11,-27,-4),(-1,0,-30),(-12,-11,25),(-18,-13,20),(-3,12,27),
    (-27,6,-13),(-30,-1,1),(-6,-9,-28),(4,-28,11),(2,22,-20),(-5,1,-30),
    (2,1,30),(-7,21,21),(-7,18,-23),(17,-22,-11),(-10,5,28),(0,-1,30),
    (11,-25,-13),(-6,-28,-10),(13,12,-24),(0,0,-30),(-20,21,8),(-3,-30,-4),
    (16,7,-24),(13,-4,-27),(4,-9,-28),(-10,-1,-28),(-19,-22,-8),(7,-6,29),
    (-16,-22,-13),(23,6,-18),(22,-7,-19),(-5,3,-30),(-3,5,-29),(12,0,28),
    (-6,13,-26),(24,-16,-8),(-7,23,18),(-10,28,-5),(21,20,8),(19,-5,23),
    (0,10,-28),(23,13,-14),(4,-6,29),(19,12,20),(8,-17,-23),(17,21,13),
    (-16,3,25),(-2,4,30),(-24,17,3),(-2,-1,-30),(-9,-8,27),(-10,4,-28),
    (10,-19,21),(3,22,-20),(-6,1,29),(-22,-21,3),(0,-1,-30),(30,1,4),
    (-29,7,-1),(-6,23,-18),(-10,-28,3),(-3,10,-28),(16,-23,-10),
    (-8,23,-17),(-6,3,29),(2,-19,24),(-13,14,-23),(13,-26,9),(-17,21,-12),
    (8,2,29),(16,-13,22),(9,9,27),(7,-15,25),(-25,16,-2),(-1,-3,-30),
    (18,0,-24),(12,-3,27),(3,3,-30),(-22,-16,-13),(-5,-5,29),(21,-14,-16),
    (3,21,21),(21,-20,-8),(27,6,12),(-13,-13,-23),(1,11,-28),(25,-14,-9),
    (3,1,-30),(-2,-3,-30),(1,2,30),(8,20,21),(-20,22,6),(11,13,25));

var i : byte;
begin
  for i := 0 to dots do begin
    dot[i].x := ctab[i,_x];
    dot[i].y := ctab[i,_y];
    dot[i].z := ctab[i,_z];
  end;
  for i := 1 to 64 do setpal(i,10+i div 3,10+i div 2,i);
end;

{----------------------------------------------------------------------------}

procedure csin(var stab : styp); var i : byte; begin
  for i := 0 to 255 do stab[i] := round(sin(2*i*pi/255)*divd); end;

{----------------------------------------------------------------------------}

function sinus(i : byte) : integer; begin
  sinus := stab[i]; end;

{function sinus(i : word) : integer; assembler; asm
  mov di,i; mov ax,word ptr stab[di]; end;}

{----------------------------------------------------------------------------}

function cosin(i : byte) : integer; begin
  cosin := stab[(i+192) mod 255]; end;

{function cosin(i : word) : integer; assembler; asm
  mov di,i; add di,192; mov ax,word ptr stab[di]; and ax,255 end;}

{----------------------------------------------------------------------------}

function esc : boolean; begin
  esc := port[$60] = 1; end;

{----------------------------------------------------------------------------}

procedure bumprotate;
const
  xst = spd; yst = spd; zst = -spd; xdiv : shortint = 1;
var
  xp : array[0..dots] of word; { 0 -> 319 }
  yp : array[0..dots] of byte; { 0 -> 199 }
  objx,n : word;
  x,y,z,i,j,k : integer;
  pc,phix,phiy,phiz : byte;

begin
  objx := 160; pc := 128; phix := 0; phiy := 0; phiz := 0;
  repeat

    asm
      mov dx,03dah
     @l1:
      in al,dx
      test al,8
      jnz @l1
     @l2:
      in al,dx
      test al,8
      jz @l2
    end; { retrace }

    setpal(0,15,0,0);

    for n := 0 to dots do begin

      asm
        mov es,gseg               { put graphicssegment in es }
        mov si,n                  { get index }
        xor ah,ah                 { clear hi-byte }
        mov al,byte ptr yp[si]    { get indexed-value from yp }
        cmp al,200                { check if value greater than 200 }
        jae @skip                 { if so, then jump out }
        shl si,1                  { x2 for word-size }
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
      end; { check if dot in screen, if so: clear it }

      i := (cosin(phiy)*dot[n].x - sinus(phiy)*dot[n].z) div divd;
      j := (cosin(phiz)*dot[n].y - sinus(phiz)*i) div divd;
      k := (cosin(phiz)*dot[n].z + sinus(phiy)*dot[n].x) div divd;
      x := (cosin(phiz)*i + sinus(phiz)*dot[n].y) div divd;
      y := (cosin(phix)*j + sinus(phix)*k) div divd;
      z := (cosin(phix)*k - sinus(phix)*j) div divd;

      xp[n] := objx+(-x*dist) div (z-dist);
      yp[n] := 50+ptab[pc]+(-y*dist) div (z-dist);

      asm
        mov es,gseg;              { put graphicssegment in es }
        mov si,n                  { get index }
        xor ah,ah                 { clear hi-byte }
        mov al,byte ptr yp[si]    { get indexed-value from yp }
        cmp al,200                { check if value greater than 200 }
        jae @skip                 { if so, then jump out }
        shl si,1                  { x2 for word-size }
        mov bx,word ptr xp[si]    { get indexed-value from xp }
        cmp bx,320                { check if value greater than 320 }
        jae @skip                 { if so, then jump out }
        shl ax,6                  { multiply with 64 }
        mov di,ax                 { keep in di }
        shl ax,2                  { multiply with 4 }
        add di,ax                 { add with di (64+(4*64)=320) }
        add di,bx                 { add horizontal value }
        mov ax,z                  { get z (depth) value }
        shr ax,1                  { divide by 2 (range/2=30) }
        add ax,32                 { add 32, ax is now in range 0 -> 64 }
        mov [es:di],al            { move to screen }
       @skip:
      end; { check if dot in screen, if so: set it }
    end;

    inc(objx,xdiv);
    if (objx < 35) or (objx > 285) then xdiv := -xdiv;

    inc(pc,spd);

    inc(phix,xst);
    inc(phiy,yst);
    inc(phiz,zst);

    setpal(0,0,0,0);

  until esc;
end;

{----------------------------------------------------------------------------}

begin
  asm mov ax,13h; int 10h; end;
  init;
  csin(stab);
  bumprotate;
  asm mov ax,3; int 10h; end;
end.
