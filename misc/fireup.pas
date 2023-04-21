program bfire;
{ My new fire routines.. F***ing slow on my 486dx!!!
I made all of this stuff up, except the palette. I stole
that from Gopher's ASM Blaze Macros. thanx!
Thanx to Denthor for the cool VGA trainers!

Blair Harrison 1997.
feel free to use this. Umm.. dunno why ya'd want to it's too slow!
but maybe you have a pentium... :)
If you speed this up, or decide to use it in ya prog, drop me a line at
rivertrog@hotmail.com
please visit my homepage too!
http://www.geocities.com/Area51/Cavern/8119
l8r!

BTW I'm from New Zealand if you're interested :)
}

uses crt;
CONST VGA = $A000;

TYPE Virtual = Array [1..64000] of byte;  { size of the Virtual Screen }
     VirtPtr = ^Virtual;                  { Pointer to the virtual screen }

VAR Virscr : VirtPtr;                     { Virtual screen }
    Vaddr  : word;                        { segment of the virtual screen}
    Scr_Ofs : Array[0..199] of Word;

procedure setofs;
VAR Loop1:integer;

BEGIN
  For Loop1 := 0 to 199 do
    Scr_Ofs[Loop1] := Loop1 * 320;
END;


Procedure SetMCGA;  { This procedure gets you into 320x200x256 mode. }
BEGIN
  asm
     mov        ax,0013h
     int        10h
  end;
END;

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
Procedure SetUpVirtual;
   { This sets up the memory needed for the virtual screen }
BEGIN
  GetMem (VirScr,64000);
  vaddr := seg (virscr^);
END;

Procedure ShutDown;
   { This frees the memory used by the virtual screen }
BEGIN
  FreeMem (VirScr,64000);
END;


Procedure Putpixel (X,Y : Integer; Col : Byte; where:word); assembler;

asm
   mov  ax,where
   mov  es,ax
   mov  bx,[y]
   shl  bx,1
   mov  di,word ptr [Scr_Ofs + bx]
   add  di,[x]
   mov  al,[col]
   mov  es:[di],al
end;


Function Getpixel (X,Y : Integer; where:word):byte; assembler;

asm
   mov  ax,where
   mov  es,ax
   mov  bx,[y]
   shl  bx,1
   mov  di,word ptr [Scr_Ofs + bx]
   add  di,[x]
   mov  al,es:[di]
end;

Procedure Hline (x1,x2,y:word;col:byte;where:word); assembler;
  { This draws a horizontal line from x1 to x2 on line y in color col }
asm
  mov   ax,where
  mov   es,ax
  mov   ax,y
  mov   di,ax
  shl   ax,8
  shl   di,6
  add   di,ax
  add   di,x1

  mov   al,col
  mov   ah,al
  mov   cx,x2
  sub   cx,x1
  shr   cx,1
  jnc   @start
  stosb
@Start :
  rep   stosw
end;

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
Procedure Pal(Col,R,G,B : Byte); assembler;
  { This sets the Red, Green and Blue values of a certain color }
asm
   mov    dx,3c8h
   mov    al,[col]
   out    dx,al
   inc    dx
   mov    al,[r]
   out    dx,al
   mov    al,[g]
   out    dx,al
   mov    al,[b]
   out    dx,al
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

procedure setpal;
var pall:byte;
begin;
pall:=0;

repeat
   pal(pall,pall*8 ,0,0);
   pall:=pall+1                        {my ugly palette routine}
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


procedure drawfire;
var col:byte;
    x:integer;
begin;
    x:=0;
    repeat
    col:=random(255);
    putpixel(x,199,col,vaddr);   {draw the bottom line (not shown)}

     x:=x+1;

    until x>319;
end;

procedure changefire;
var cury,curx,t1:word;
    tr:byte;
begin;
     cury:=199; {y pixel to start at}
     repeat
       curx:=0;  {x pixel to start at}
       repeat


         t1:=getpixel(curx+1,cury,Vaddr)+
         getpixel(curx-1,cury,Vaddr)+    {get the four surrounding pixels}
         getpixel(curx,cury+1,vaddr)+
         getpixel(curx,cury-1,vaddr);

         tr:=t1 div 4;
         if tr>0 then tr:=tr-1;

         putpixel(curx,cury-2,tr,vaddr);
         putpixel(curx-1,cury-1,tr,vaddr);
{        you can get cool effects by adding lines like this... here's some}
{        examples, just rem out the above and unrem the lines below...}
{        try some of your own.. it's easy to get cool effects!
{        putpixel(curx,cury-1,tr,vaddr);{by itself it's weird}
{
{        putpixel(curx,cury-1,tr,vaddr);   {these two give melted flames }
{         putpixel(curx+1,cury-1,tr,vaddr);  {try it}





         curx:=curx+1;
       until curx=319;                  { x pixel to go to}
       cury:=cury-1;

     until cury=(200-100);              { y pixel to go to}



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
 setofs;
 randomize;    {init random number generator}
 setupvirtual; {open the virtual screen}
 setmcga;      {320x200 mode}
 stdpal;       {set the palette - change to setpal for a warped palette!!}
 cls(vaddr,0); {clear the screens to black}
 cls(VGA,0);
repeat
   drawfire;                  {draw random pixels at bottom}
   changefire;                {animate the fire}
   hline(0,320,199,0,vaddr);  {yeah i know it's slack!}
   flip(vaddr,vga);           {flip virtual screen to vga mem}

until keypressed=true;

shutdown; {close the virtual screen}
textmode(lastmode);  {textmode}

end.
