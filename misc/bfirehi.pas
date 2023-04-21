program bfire; { My first Fire! }
uses dos,crt,gfx3;
var x,y:integer;
    col:byte;



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

repeat
   pal(pall,pall*8 ,0,0);
   pall:=pall+1
until pall=7;

repeat
   pal(pall,63 ,pall*8,0);
   pall:=pall+1
until pall=15;

repeat
   pal(pall,63 ,63,pall*4);
   pall:=pall+1
until pall=31;
repeat
   pal(pall,63 ,63,pall*4);
   pall:=pall+1
until pall=63;

end;




{procedure PutPixel (x,y: integer; c: byte); assembler;
 asm
  mov ax,y
  mov bx,ax
  shl ax,8
  shl bx,6
  add bx,ax
  add bx,x
  mov ax,0a000h
  mov es,ax
  mov al,c
  mov es:[bx],al
 end;
{--------------------------------------------------------}
{function GetPixel (x,y: integer): byte;

begin
 asm
  mov ax,y
  mov bx,ax
  shl ax,8
  shl bx,6
  add bx,ax
  add bx,x
  mov ax,0a000h
  mov es,ax
  mov al,es:[bx]
  mov @result,al
 end;
end;
{********************************************************}



procedure drawfire;

begin;
      x:=0;
    repeat
    col:=random(255);
    putpixel(x,199,col,vaddr);

     x:=x+1;

    until x>319;
end;

procedure changefire;
var cury,curx,newcol:word;
    t1,t2,t3,t4:byte;
    tr:integer;
begin;
     cury:=199;
     repeat
       curx:=0;
       repeat
         t1:=getpixel(curx+1,cury,Vaddr);
         t2:=getpixel(curx-1,cury,Vaddr);
         t3:=getpixel(curx,cury+1,vaddr);
         t4:=getpixel(curx,cury-1,vaddr);
         tr:=(t1+t2+t3+t4) div 4;
         if tr>0 then tr:=tr-1;
         putpixel(curx,cury-2,tr,vaddr);
         putpixel(curx-1,cury-1,tr,vaddr);

         curx:=curx+1;
       until curx=319;
       cury:=cury-1;

     until cury=(200-100);



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


begin;
randomize;
setupvirtual;
setmcga;
stdpal;
cls(vaddr,0);
cls(VGA,0);
repeat
drawfire;
changefire;
hline(0,320,199,0,vaddr);
flip(vaddr,vga);
until keypressed=true;

shutdown;
settext;

end.
