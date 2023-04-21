program bfire; { My first Fire! }
uses dos,crt,gfx3;
var x,y:integer;
    col:byte;
    a,b,c,d:word;

function svga(mode:word):boolean;assembler;
asm
   mov ax,4F02h
   mov bx,[mode]
   int $10
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

function stdpal:boolean;
begin
asm

  mov dx, $03C9     { Routine to set up the palette       }
  mov cl, 32       { CH is already zero                    }
@L1:
  mov al, cl       { Set up the reds. Less red (only 32 or so}
  dec dx           {   palette entries) makes the flames seem }
  out dx, al       {   hotter                                  }
  shl al, 1
  dec ax           { Same effect as dec al, but with one less byte}
  inc dx
  out dx, al
  xor al, al
  out dx, al
  out dx, al
  loop @L1

  mov cl, 63       { CH is already zero  }
@L2:
  mov al, cl       { Set the oranges      }
  add al, 32
  dec dx
  out dx, al
  mov al, 63
  inc dx
  out dx, al
  mov al, cl
  out dx, al
  xor al, al
  out dx, al

  mov al, cl       {; This section sets the yellows }
  add al, 95
  dec dx
  out dx, al
  mov al, 63
  inc dx
  out dx, al
  out dx, al
  mov al, cl
  out dx, al

  mov al, cl       {; This section sets the blues    }
  add al, 158
  dec dx
  out dx, al
  mov al, 64
  sub al, cl
  inc dx
  out dx, al
  out dx, al
  mov al, 63
  out dx, al
  loop @L2
end;
end;


procedure setpal;
var pall:byte;
begin;
pall:=0;
for x:=1 to 32 do begin;
port[$3c8]:=x;
port[$3c9]:=x shl 2;
port[$3c9]:=x shr 1;
port[$3c9]:=x shr 3;
end;

for x:=0 to 63 do
 begin;
    port[$3c8]:=x+32;
    port[$3c9]:=63;
    port[$3c9]:=x;
    port[$3c9]:=63;

    port[$3c8]:=x+95;
    port[$3c9]:=63;
    port[$3c9]:=x;
    port[$3c9]:=63;

    port[$3c8]:=x+158;
    port[$3c9]:=x;
    port[$3c9]:=x;
    port[$3c9]:=x shl 2;

 end;


end;

procedure flip2;
begin;
for c:=64000 downto 1 do begin;
  d:=(mem[vaddr:c]);
  mem[vga:c]:=d shr 2;
end;
end;

procedure drawfire;
begin;
    randomize;
{    repeat
    col:=random(255);
    mem[vaddr:(198*320)+x]:=col + 256 shr 32;

     x:=x+1;
    until x>319;
}
x:=0;
    repeat
    col:=random(255);
    mem[vaddr:64000-x]:=col ;

     x:=x+1;
    until x>319;
x:=0;
    repeat
    col:=random(255);
    mem[vaddr:x]:=col ;

     x:=x+1;
    until x>319;
   for a :=65280 downto 32000 do  begin;
      b:=(mem[vaddr:a+1]+mem[vaddr:a-1]+mem[vaddr:a-320]+mem[vaddr:a+320]) shr 2;
      c:=b ;
      if c>0 then c:=c-1;
      mem[vaddr:a+321] := c ;
      mem[vaddr:a-322] := c ;

   end;
   for a :=0 to 32000 do  begin;
      b:=(mem[vaddr:a-1]+mem[vaddr:a+1]+mem[vaddr:a+320]+mem[vaddr:a-320]) shr 2;
      c:=b ;
      if c>0 then c:=c-1;
      mem[vaddr:a+319] := c ;
      mem[vaddr:a+320] := c ;

   end;

    flip(vaddr,vga);
end;

begin;
randomize;
setupvirtual;

setmcga;
stdpal;
cls(vaddr,0);
cls(VGA,0);
repeat
waitretrace;

drawfire;
until keypressed=true;

shutdown;
settext;

end.
