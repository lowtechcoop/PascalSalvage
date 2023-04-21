program fader; { Fader prog using fire stuff }
uses dos,crt,gfx3;
var x,y,g:integer;
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

procedure flip2;
begin;
for c:=64000 downto 1 do begin;
  d:=(mem[vaddr:c]);
  mem[vga:c]:=d shr 2;
end;
end;

procedure drawfire;
begin;
     g:=g+1;
     x:=0;

   for a :=0 to 60000 do  begin;
      b:=(mem[vaddr:a+640]+mem[vaddr:a+319]+mem[vaddr:a+320]+mem[vaddr:a+321]);
      {play with the above line to get diff fx!}
      c:=b shr 2;
      mem[vaddr:a] := c ;

      end;
flip(vaddr,vga);
end;

begin;
randomize;
setupvirtual;
setmcga;
setpal;
cls(vaddr,0);
cls(VGA,0);
directvideo:=false;
gotoxy(2,20);
textcolor(100);
writeln('Fader Program v1.0 (C) Blairsoft 1998');
flip(vga,vaddr);

   for a :=0 to 60000 do  begin;
      b:=(mem[vaddr:a+640]+mem[vaddr:a+320]+mem[vaddr:a+321]+mem[vaddr:a+319]);
      c:=b shr 2;
      mem[vaddr:a] := c ;

      end;
flip(vaddr,vga);
delay(5000);


repeat
x:=0;
{    repeat
    col:=random(255);
    mem[vaddr:(200*320)+x]:=col shr 1;

     x:=x+1;
    until x>319;
 }
drawfire;
until g=100;

shutdown;
settext;

end.
