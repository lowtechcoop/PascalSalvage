program bfire; { My first Fire! }
uses dos,crt,gfx3;
var x,y:integer;
    col:byte;
    a,b,c,d:word;

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
procedure setpalg;
var pall:byte;
begin;
pall:=0;
for x:=1 to 32 do begin;
port[$3c8]:=x;
port[$3c9]:=0;
port[$3c9]:=x shl 1;
port[$3c9]:=0;
end;

for x:=0 to 63 do
 begin;
    port[$3c8]:=x+32;
    port[$3c9]:=0;
    port[$3c9]:=63;
    port[$3c9]:=x xor x;

    port[$3c8]:=x+95;
    port[$3c9]:=x;
    port[$3c9]:=63;
    port[$3c9]:=x;

    port[$3c8]:=x+158;
    port[$3c9]:=x;
    port[$3c9]:=x;
    port[$3c9]:=x;

 end;



end;


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
    port[$3c9]:=x xor x;

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
     x:=0;
    repeat
    col:=random(255);
    mem[vaddr:(199*320)+x]:=col shr 1;

     x:=x+1;
    until x>319;

    x:=0   ;
    repeat
    col:=random(255);
    mem[vaddr:x]:=col shr 1;

     x:=x+1;
    until x>319;

{   for a :=16320 to 64000 do  begin;
      b:=(mem[vaddr:a+640]+mem[vaddr:a+319]+mem[vaddr:a+320]+mem[vaddr:a+321]);
      c:=b shr 2;
      mem[vaddr:a-1] := c ;
   end;
}   for a :=0 to 64000 do  begin;
      b:=(mem[vaddr:a]+mem[vaddr:a+319]+mem[vaddr:a+321]+mem[vaddr:a+320]);
      c:=b shr 2;
      mem[vaddr:a] := c ;
      mem[vaddr:a div 2] := c ;
   end;

    flip(vaddr,vga);

end;

begin;
randomize;
setupvirtual;
setmcga;
setpalg;
cls(vaddr,0);
cls(VGA,0);
directvideo:=false;
repeat

drawfire;
until keypressed=true;

shutdown;
settext;

end.
