program blair3d;  { Wow! I wrote a 3d Starfield!!!! in about an hour!! }
uses crt,vesalib;

var x,y,tdx,tdy,rx,col:longint;

    stars:array[1..600] of array[1..3] of longint;


procedure slowcls;
begin;
for y:=0 to 47 do begin;
    for x:=0 to 63 do begin;
        putpixel(x,y,0);
    end;
end;
end;


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


procedure gensta;
begin;
   for x:=1 to 600 do begin;
       stars[x,1]:=random(320*5)+1;
       stars[x,2]:=random(200*5)+1;
       stars[x,3]:=random(300)+100;
       rx:=random(2);
       if rx=1 then stars[x,1]:=stars[x,1]*(-1);
       rx:=random(2);
       if rx=1 then stars[x,2]:=stars[x,2]*(-1);


       tdx:=stars[x,1] div stars[x,3] ;
       tdy:=stars[x,2] div stars[x,3];


       putpixel(320-tdx,240-tdy,8);

       end;
end;
procedure movestars;
begin;

   for x:=1 to 600 do begin;
       if stars[x,3]>0 then dec (stars[x,3]);
       if stars[x,3]=0 then stars[x,3]:=random(300)+1;

       tdx:=stars[x,1] div stars[x,3] ;
       tdy:=stars[x,2] div stars[x,3];

       putpixel(320+tdx,240+tdy,8);

       end;

end;
procedure cleanstars;
begin;

   for x:=1 to 600 do begin;
       if stars[x,3]>0 then dec (stars[x,3]);
       if stars[x,3]=0 then stars[x,3]:=random(300)+1;

       tdx:=stars[x,1] div stars[x,3] ;
       tdy:=stars[x,2] div stars[x,3];

       putpixel(320+tdx,240+tdy,0);

       end;

end;


begin;
randomize;

 SetupMode(_640x480x8bpp);
gensta;
repeat
slowcls;
movestars;
until keypressed=true;

textmode(lastmode);

end.

