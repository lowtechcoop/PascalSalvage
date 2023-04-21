program bfire; { My first Fire! }
uses crt;
var x,y:integer;
    col:byte;
    a,b,c,d:word;
    Virscr : VirtPtr;
    Vaddr  : word;

const VGA = $A000;
type Virtual = Array [1..65535] of byte;  { The size of our Virtual Screen }
     VirtPtr = ^Virtual;                  { Pointer to the virtual screen }

Procedure Cls (Where:word;Col : Byte); assembler;
   { This clears the screen to the specified color }
asm
   push    es
   mov     cx, 32000;
   mov     es,[where]
   xor     di,di
   mov     al,[col]
   mov     ah,al
   rep     stosw
   pop     es
End;

procedure flip(source,dest:Word); assembler;
  { This copies the entire screen at "source" to destination }
asm
  push    ds
  mov     ax, [Dest]
  mov     es, ax
  mov     ax, [Source]
  mov     ds, ax
  xor     si, si
  xor     di, di
  mov     cx, 32000
  rep     movsw
  pop     ds
end;

Procedure PutIndexed(Prt:Word;Ind,Val:Byte);
Begin
   Port[prt]:=Ind;
   Port[prt+1]:=Val;
End;

Procedure SetModeQ;
var
   X   : Byte;
Begin
   asm
      mov ax,013h
      int 10h
   end;
   port[$3d4]:=$11; X := port[$3d5] and $7F; port[$3d4]:=$11;
   port[$3d5]:=X;
   port[$3c2]:=$E3;
   PutIndexed($3d4,$00,$5F); PutIndexed($3d4,$01,$3F);
   PutIndexed($3d4,$02,$40); PutIndexed($3d4,$03,$82);
   PutIndexed($3d4,$04,$4A); PutIndexed($3d4,$05,$9A);
   PutIndexed($3d4,$06,$23); PutIndexed($3d4,$07,$B2);
   PutIndexed($3d4,$08,$00); PutIndexed($3d4,$09,$61);
   PutIndexed($3d4,$10,$0A); PutIndexed($3d4,$11,$AC);
   PutIndexed($3d4,$12,$FF); PutIndexed($3d4,$13,$20);
   PutIndexed($3d4,$14,$40); PutIndexed($3d4,$15,$07);
   PutIndexed($3d4,$16,$1A); PutIndexed($3d4,$17,$A3);

   PutIndexed($3c4,$01,$01); PutIndexed($3c4,$04,$0E);

   PutIndexed($3ce,$05,$40); PutIndexed($3ce,$06,$05);

   X:=Port[$3DA]; Port[$3C0]:= $10 or $20; Port[$3C0]:= $41;
   X:=Port[$3DA]; Port[$3C0]:= $13 or $20; Port[$3C0]:= $0;
End;

procedure setpal;
var pall:byte;
begin;
pall:=0;
for x:=1 to 32 do begin;
port[$3c8]:=x;
port[$3c9]:=0;
port[$3c9]:=0 ;
port[$3c9]:=0 ;
end;

for x:=0 to 63 do
 begin;
    port[$3c8]:=x+32;
    port[$3c9]:=0;
    port[$3c9]:=0;
    port[$3c9]:=0;

    port[$3c8]:=x+95;
    port[$3c9]:=0;
    port[$3c9]:=0;         {change these 3 lines for diff colour fire!}
    port[$3c9]:=x;

    port[$3c8]:=x+158;
    port[$3c9]:=0;
    port[$3c9]:=0;
    port[$3c9]:=x ;
 end;
end;

procedure drawfire;
begin;
   x:=0;
    repeat
      col:=random(255);
      mem[vaddr:x-255]:=col;
      x:=x+1;
    until x>256;

   for a :=65280  downto 32000 do  begin;
      b:=(mem[vaddr:a]+mem[vaddr:a+255]+mem[vaddr:a+256]+mem[vaddr:a+257]);
      c:=b shr 2 ;
      mem[vaddr:a] := c ;
   end;
    flip(vaddr,vga);
end;

begin;
randomize;
  GetMem (VirScr,65535);
  vaddr := seg (virscr^);
setmodeQ;
setpal;
cls(vaddr,0);
cls(VGA,0);
repeat
   drawfire;
until keypressed=true;
FreeMem (VirScr,65535);
textmode(lastmode);
end.
