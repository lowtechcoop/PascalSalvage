
{$g+}

program vectorballs;
{ Try to make vectorballs, by Bas van Gaalen, Holland, PD }
uses crt;
const
  vseg : word = $a000;
  spd = 1;
  dist = 100;
  dots = 9;
  divd = 1024;
  dims : array[0..5,0..1] of byte = ((16,13),(14,11),(12,9),(8,7),(6,5),(3,3));
  bal0 : array[0..12,0..15] of byte =
   ((0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0),
    (0,0,0,2,2,1,1,1,1,1,1,2,2,0,0,0),
    (0,0,2,1,1,1,1,1,1,1,1,1,1,2,0,0),
    (0,2,1,1,1,1,1,1,1,1,1,1,1,1,2,0),
    (0,2,1,1,3,1,1,1,1,1,1,1,1,1,2,0),
    (2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2),
    (2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2),
    (2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2),
    (0,2,1,1,1,1,1,1,1,1,1,1,1,1,2,0),
    (0,2,1,1,1,1,1,1,1,1,1,1,1,1,2,0),
    (0,0,2,1,1,1,1,1,1,1,1,1,1,2,0,0),
    (0,0,0,2,2,1,1,1,1,1,1,2,2,0,0,0),
    (0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0));
  bal1 : array[0..10,0..13] of byte =
   ((0,0,0,0,2,2,2,2,2,2,0,0,0,0),
    (0,0,2,2,1,1,1,1,1,1,2,2,0,0),
    (0,2,1,1,1,1,1,1,1,1,1,1,2,0),
    (0,2,1,3,1,1,1,1,1,1,1,1,2,0),
    (2,1,1,1,1,1,1,1,1,1,1,1,1,2),
    (2,1,1,1,1,1,1,1,1,1,1,1,1,2),
    (2,1,1,1,1,1,1,1,1,1,1,1,1,2),
    (0,2,1,1,1,1,1,1,1,1,1,1,2,0),
    (0,2,1,1,1,1,1,1,1,1,1,1,2,0),
    (0,0,2,2,1,1,1,1,1,1,2,2,0,0),
    (0,0,0,0,2,2,2,2,2,2,0,0,0,0));
  bal2 : array[0..8,0..11] of byte =
   ((0,0,0,0,2,2,2,2,0,0,0,0),
    (0,0,2,2,1,1,1,1,2,2,0,0),
    (0,2,1,1,1,1,1,1,1,1,2,0),
    (2,1,1,3,1,1,1,1,1,1,1,2),
    (2,1,1,1,1,1,1,1,1,1,1,2),
    (2,1,1,1,1,1,1,1,1,1,1,2),
    (0,2,1,1,1,1,1,1,1,1,2,0),
    (0,0,2,2,1,1,1,1,2,2,0,0),
    (0,0,0,0,2,2,2,2,0,0,0,0));
  bal3 : array[0..6,0..7] of byte =
   ((0,0,2,2,2,2,0,0),
    (2,2,1,1,1,1,2,2),
    (2,1,3,1,1,1,1,2),
    (2,1,1,1,1,1,1,2),
    (2,1,1,1,1,1,1,2),
    (2,2,1,1,1,1,2,2),
    (0,0,2,2,2,2,0,0));
  bal4 : array[0..4,0..5] of byte =
   ((0,2,2,2,2,0),
    (2,2,1,1,2,2),
    (2,1,1,1,1,2),
    (2,2,1,1,2,2),
    (0,2,2,2,2,0));
  bal5 : array[0..2,0..2] of byte =
   ((0,2,0),
    (2,1,2),
    (0,2,0));
  pics : array[0..5] of pointer = (addr(bal0),addr(bal1),addr(bal2),
                                   addr(bal3),addr(bal4),addr(bal5));

type
  prec = record x,y,z : integer; end;
  ppos = array[0..dots] of prec;
  styp = array[0..255] of integer;

var
  stab : styp;
  dot : ppos;

{--------}

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

{--------}

procedure csin; var i : byte; begin
  for i := 0 to 255 do stab[i] := round(sin(2*i*pi/255)*divd); end;

{--------}

procedure init;
var i : byte;
begin
  setpal(1,10,10,45);
  setpal(2,0,0,25);
  setpal(3,20,20,60);
  csin;
  for i := 0 to dots do begin
    dot[i].x := 0;
    dot[i].y := 0;
    dot[i].z := -25+i*5;
  end;
end;

{--------}

procedure drawsprite(x,y : integer; w,h : byte; sprite : pointer); assembler;
asm
  push ds
  lds si,[sprite]
  mov es,vseg
  cld
  mov ax,[y]
  shl ax,6
  mov di,ax
  shl ax,2
  add di,ax
  add di,[x]
  mov bh,[h]
  mov cx,320
  sub cl,[w]
  sbb ch,0
 @l:
  mov bl,[w]
 @l2:
  lodsb
  or al,al
  jz @s
  mov [es:di],al
 @s:
  inc di
  dec bl
  jnz @l2
  add di,cx
  dec bh
  jnz @l
  pop ds
end;

{--------}

procedure clear(x,y : integer; w,h : byte); assembler;
asm
  push ds
  mov es,vseg
  cld
  mov ax,[y]
  shl ax,6
  mov di,ax
  shl ax,2
  add di,ax
  add di,[x]
  mov bh,[h]
  mov cx,320
  sub cl,[w]
  sbb ch,0
 @l:
  mov bl,[w]
 @l2:
  xor al,al
  mov [es:di],al
 @s:
  inc di
  dec bl
  jnz @l2
  add di,cx
  dec bh
  jnz @l
  pop ds
end;


{--------}

function sinus(i : byte) : integer; begin
  sinus := stab[i]; end;

function cosin(i : byte) : integer; begin
  cosin := stab[(i+192) mod 255]; end;

{--------}

procedure rotate;
const
  xst = 1; yst = 1; zst = 2;
var
  xp,yp,zp : array[0..dots] of integer;
  x,y,z,i,j,k : integer;
  n,phix,phiy,phiz,bnr : byte;
begin
  fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);
  fillchar(zp,sizeof(zp),0);
  phix := 0; phiy := 0; phiz := 0;
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

    setpal(0,0,0,20);

    for n := 0 to dots do begin
      bnr := 3+zp[n] div 16;
      clear(xp[n],yp[n],16,16);
    end;

    for n := 0 to dots do begin
      i := (cosin(phiy)*dot[n].x - sinus(phiy)*dot[n].z) div divd;
      j := (cosin(phiz)*dot[n].y - sinus(phiz)*i) div divd;
      k := (cosin(phiz)*dot[n].z + sinus(phiy)*dot[n].x) div divd;
      x  := (cosin(phiz)*i + sinus(phiz)*dot[n].y) div divd;
      y  := (cosin(phix)*j + sinus(phix)*k) div divd;
      z  := (cosin(phix)*k - sinus(phix)*j) div divd;

      xp[n] := 160+(-x*dist) div (z-dist);
      yp[n] := 100+(-y*dist) div (z-dist);
      zp[n] := z;
    end;

    for n := 0 to dots do begin
      bnr := 3+zp[n] div 16;
      drawsprite(xp[n],yp[n],dims[bnr,0],dims[bnr,1],pics[bnr]);
    end;

    inc(phix,xst);
    inc(phiy,yst);
    inc(phiz,zst);

    setpal(0,0,0,0);

  until keypressed;
end;

{--------}

begin
  asm mov ax,13h; int 10h; end;
  init;
  rotate;
  while keypressed do readkey;
  textmode(lastmode);
end.

{ A not very affactive approuch to make vectorballs }
