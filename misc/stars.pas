program starfield;
uses crt,gfx3;
var x,p,f,d,e,backg,rs:integer;
    stemp:array [0..500] of array[0..3] of integer;
          { stemp = i,0 = xpos /i,1 = ypos / i,2 = col/i,3 = speed}
    ch:char;
const max=500;
      speed=5;
procedure movestarsright;
begin;
  for x:= 0 to max do begin;
    dec (stemp[x,0],stemp[x,3]);

      if stemp[x,0] < 0 then begin;
         stemp[x,0] := 319;
         stemp[x,1]:=random(199);
         stemp[x,3]:=random(speed)+1;
           case stemp[x,3] of
             1:stemp[x,2]:=26 + random(5);
             2:stemp[x,2]:=23+random(5);
           else
             stemp[x,2]:=18+random(5);
           end;
         end;
 putpixel(stemp[x,0],stemp[x,1],stemp[x,2],vaddr);

end;
end;
procedure movestarsleft;
begin;
  for x:= 0 to max do begin;
    inc (stemp[x,0],stemp[x,3]);

      if stemp[x,0] > 319 then begin;
         stemp[x,0] := 0;
         stemp[x,1]:=random(199);
         stemp[x,3]:=random(speed)+1;
           case stemp[x,3] of
             1:stemp[x,2]:=26 + random(5);
             2:stemp[x,2]:=23+random(5);
           else
             stemp[x,2]:=18+random(5);
           end;
         end;
 putpixel(stemp[x,0],stemp[x,1],stemp[x,2],vaddr);

end;
end;
procedure movestarsdown;
begin;
  for x:= 0 to max do begin;
    inc (stemp[x,1],stemp[x,3]);

      if stemp[x,1] > 199 then begin;
         stemp[x,0] := random(319);
         stemp[x,1]:=0;
         stemp[x,3]:=random(speed)+1;
           case stemp[x,3] of
             1:stemp[x,2]:=26 + random(5);
             2:stemp[x,2]:=23+random(5);
           else
             stemp[x,2]:=18+random(5);
           end;
         end;
 putpixel(stemp[x,0],stemp[x,1],stemp[x,2],vaddr);

end;
end;

procedure movestarsline;
begin;
  for x:= 0 to max do begin;
    dec (stemp[x,1],stemp[x,3]);
    line(stemp[rs,0],stemp[rs,1],stemp[x,0],stemp[x,1],156,vaddr);

      if stemp[x,1] < 1 then begin;
         stemp[x,0] :=random(319);
         stemp[x,1]:=199;
         stemp[x,3]:=random(speed)+1;
           case stemp[x,3] of
             1:stemp[x,2]:=26 + random(5);
             2:stemp[x,2]:=23+random(5);
           else
             stemp[x,2]:=18+random(5);
           end;
         end;
 putpixel(stemp[x,0],stemp[x,1],stemp[x,2],vaddr);

end;
end;


procedure movestarsup;
begin;
  for x:= 0 to max do begin;
    dec (stemp[x,1],stemp[x,3]);

      if stemp[x,1] < 1 then begin;
         stemp[x,0] :=random(319);
         stemp[x,1]:=199;
         stemp[x,3]:=random(speed)+1;
           case stemp[x,3] of
             1:stemp[x,2]:=26 + random(5);
             2:stemp[x,2]:=23+random(5);
           else
             stemp[x,2]:=18+random(5);
           end;
         end;
        { ... do -180 on it , if under 180 * by -1}
                      {thenumber is the dist... ummm}
                      {cos(thenumber)*distort+x}
                      {sin(thenumber)*distort+y}
 putpixel(stemp[x,0],stemp[x,1],stemp[x,2],vaddr);

end;
end;

procedure stars;
begin;
  for x:= 0 to max do begin;
         stemp[x,0] := random(319);
         stemp[x,1]:=random(199);
         stemp[x,3]:=random(speed)+1;
           case stemp[x,3] of
             1:stemp[x,2]:=26 + random(5);
             2:stemp[x,2]:=23+random(5);
           else
             stemp[x,2]:=18+random(5);
           end;
         end;

end;




begin;
clrscr;
writeln('Starfield 1.6');
writeln('BlairSoft 1997');
Writeln('Commands :');
writeln('          a - Change Starfield Direction to UP');
writeln('          z - Change Starfield Direction to DOWN');
writeln('          p - Change Starfield Direction to LEFT');
writeln('          o - Change Starfield Direction to RIGHT');
Writeln('          r - Random Direction Starfield... yech!');
writeln('          l - Weird line thing... hyperspace jump point???');
writeln('      <ESC> - Exit ');

repeat until keypressed=true;

d:=1;
setupvirtual;
rs:=random(max);
setmcga;
cls(vaddr,0);
stars;
directvideo:=false;
repeat
if keypressed=true then ch:=readkey;
if ch='z' then d:=3;
if ch='a' then d:=1;
if ch='o' then d:=4;
if ch='p' then d:=2;
if ch='l' then begin
d:=5;
end;
if ch='r' then begin;
inc (f);
if f=14 then begin
   d:=random(4)+1;
   f:=0;
end;
end;
cls(vaddr,backg);
if d=1 then movestarsup;
if d=2 then movestarsleft;
if d=3 then movestarsdown;
if d=4 then movestarsright;
if d=5 then movestarsline;

waitretrace;
flip(vaddr,vga);
until ch=chr(27);
shutdown;
textmode(lastmode);

end.
