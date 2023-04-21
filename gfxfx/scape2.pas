
program landscape_2d;
{ Perspective Landscape v3.0. By Bas van Gaalen, Holland, PD
  A real piece of art (if it was bugless)! }
const
  vseg=$a000;
  dy=6;
  a_density=6;
  roughness=30;
  maxh=128;
  maxx_scape=320;
  maxy_scape=200;
  maxx=180 div a_density;
  maxy=180 div a_density;
var
  base:array[0..350 div dy] of pointer;
  landscape:pointer;

{ mouse routines ----------------------------------------------------------- }

function mouseinstalled:boolean; assembler; asm
  xor ax,ax; int 33h; cmp ax,-1; je @skip; xor al,al; @skip: end;

function getmousex:word; assembler; asm
  mov ax,3; int 33h; mov ax,cx end;

function getmousey:word; assembler; asm
  mov ax,3; int 33h; mov ax,dx end;

function leftpressed:boolean; assembler; asm
  mov ax,3; int 33h; and bx,1; mov ax,bx end;

function rightpressed:boolean; assembler; asm
  mov ax,3; int 33h; and bx,2; mov ax,bx end;

procedure mousesensetivity(x,y:word); assembler; asm
  mov ax,1ah; mov bx,x; mov cx,y; xor dx,dx; int 33h end;

procedure mousewindow(l,t,r,b:word); assembler; asm
  mov ax,7; mov cx,l; mov dx,r; int 33h; mov ax,8
  mov cx,t; mov dx,b; int 33h end;

{ lowlevel video routines -------------------------------------------------- }

procedure setvideo(m:word); assembler; asm
  mov ax,m; int 10h end;

procedure putpixel(x,y:word; c:byte); assembler; asm
  mov ax,vseg; mov es,ax; mov ax,y; mov dx,320; mul dx
  mov di,ax; add di,x; mov al,c; mov [es:di],al end;

function getpixel(x,y:word):byte; assembler; asm
  mov ax,vseg; mov es,ax; mov ax,y; mov dx,320; mul dx
  mov di,ax; add di,x; mov al,[es:di] end;

procedure setpal(c,r,g,b:byte); assembler; asm
  mov dx,03c8h; mov al,c; out dx,al; inc dx; mov al,r
  out dx,al; mov al,g; out dx,al; mov al,b; out dx,al end;

procedure retrace; assembler; asm
  mov dx,03dah; @l1: in al,dx; test al,8; jnz @l1
  @l2: in al,dx; test al,8; jz @l2 end;

{ lowlevel memory routines ------------------------------------------------- }

function rmemb(var m; i:word):byte; assembler; asm
  les di,m; add di,i; mov al,[es:di]; end;

procedure smemb(var m; i:word; v:byte); assembler; asm
  les di,m; add di,i; mov al,v; mov [es:di],al; end;

function rmemw(var m; i:word):word; assembler; asm
  les di,m; add di,i; add di,i; mov ax,[es:di]; end;

procedure smemw(var m; i:word; v:word); assembler; asm
  les di,m; add di,i; add di,i; mov ax,v; mov [es:di],ax; end;

{ initialize palette colors ------------------------------------------------ }

procedure initcolors;
var i:byte;
begin
  for i:=0 to 63 do begin
    setpal(i+1,21+i div 2,21+i div 2,63-i);
    setpal(i+65,42-i div 3,42+i div 3,i div 3);
  end;
end;

{ landscape generating routines -------------------------------------------- }

procedure adjust(xa,ya,x,y,xb,yb:integer);
var d,c:integer;
begin
  if getpixel(x,y)<>0 then exit;
  d:=abs(xa-xb)+abs(ya-yb);
  c:=(50*(getpixel(xa,ya)+getpixel(xb,yb))+trunc((10*random-5)*d*roughness)) div 100;
  if c<1 then c:=1;
  if c>=maxh then c:=maxh;
  putpixel(x,y,c);
end;

procedure subdivide(l,t,r,b:integer);
var x,y:integer; c:integer;
begin
  if (r-l<2) and (b-t<2) then exit;
  x:=(l+r) div 2; y:=(t+b) div 2;
  adjust(l,t,X,t,r,t);
  adjust(r,t,r,Y,r,b);
  adjust(l,b,X,b,r,b);
  adjust(l,t,l,Y,l,b);
  if getpixel(x,y)=0 then begin
    c:=(getpixel(l,t)+getpixel(r,t)+getpixel(r,b)+getpixel(l,b)) div 4;
    putpixel(x,y,c);
  end;
  subdivide(l,t,x,y);
  subdivide(x,t,r,y);
  subdivide(l,y,x,b);
  subdivide(x,y,r,b);
end;

procedure generatelandscape;
var image:file; vidram:byte absolute vseg:0; i:word;
begin
  assign(image,'scape.dat');
  {$I-} reset(image,1); {$I+}
  if ioresult<>0 then begin
    randomize;
    putpixel(0,0,random(maxh));
    putpixel(maxx_scape-1,0,random(maxh));
    putpixel(maxx_scape-1,maxy_scape-1,random(maxh));
    putpixel(0,maxy_scape-1,random(maxh));
    subdivide(0,0,maxx_scape,maxy_scape);
    rewrite(image,1);
    blockwrite(image,mem[vseg:0],maxx_scape*maxy_scape);
  end else blockread(image,mem[vseg:0],maxx_scape*maxy_scape);
  close(image);
  move(vidram,landscape^,maxx_scape*maxy_scape);
  fillchar(vidram,maxx_scape*maxy_scape,0);
  for i:=0 to maxx_scape*maxy_scape-1 do
    smemb(landscape^,i,10+(rmemb(landscape^,i) div 2));
end;

{ precalculate basetables -------------------------------------------------- }

procedure precalc;
const dots=maxx*maxy-1; divd=128; dist=280;
type dotrec=record x,z:integer; end; dotpos=array[0..dots] of dotrec;
var dot:dotpos; stab:array[0..439] of integer; st,py,n,i:word; xt,yt,x,z:integer;
begin
  i:=0; z:=-maxx*a_density div 2;
  while z<(maxx*a_density div 2) do begin
    x:=-maxy*a_density div 2;
    while x<(maxy*a_density div 2) do begin
      dot[i].x:=x;
      dot[i].z:=z;
      inc(i); inc(x,a_density);
    end;
    inc(z,a_density);
  end;
  for i:=0 to 439 do stab[i]:=round(sin(2*i*pi/349)*divd);
  py:=0;
  while py<350 do begin
    getmem(base[py div dy],2*maxx*maxy);
    for n:=0 to dots do begin
      x:=(stab[py+90]*dot[n].x-stab[py]*dot[n].z) div divd;
      z:=(stab[py+90]*dot[n].z+stab[py]*dot[n].x) div divd;
      xt:=160+(-x*dist) div (z-dist);
      yt:=100+(-40*dist) div (z-dist);
      if (xt<320) and (yt<200) then st:=320*yt+xt else st:=0;
      smemw(base[py div dy]^,n,st);
    end;
    inc(py,dy);
  end;
end;

{ the actual displaying of the whole thing! -------------------------------- }

procedure displayscape;
var pba,ba,tba,i,j,previ,prevj,n,k,l:word; x:integer;
begin
  pba:=0; ba:=0; i:=0; j:=0;
  repeat
    {retrace;
    setpal(0,0,0,10);}
    previ:=i; i:=getmousex; prevj:=j; j:=getmousey;
    if rightpressed then begin pba:=ba; dec(ba); if ba>=(350 div dy) then ba:=(350 div dy)-1; end
    else if leftpressed then begin pba:=ba; inc(ba); ba:=ba mod (350 div dy); end;
    for n:=0 to maxx*maxy-1 do begin
      tba:=rmemw(base[pba]^,n);
      if tba>0 then
        mem[vseg:rmemw(base[pba]^,n)-320*rmemb(landscape^,n mod maxx+previ+
            (n div maxx+prevj)*maxx_scape)]:=0;
      tba:=rmemw(base[ba]^,n);
      if tba>0 then
        mem[vseg:rmemw(base[ba]^,n)-320*rmemb(landscape^,n mod maxx+i+
            (n div maxx+j)*maxx_scape)]:=
            rmemb(landscape^,(integer(n mod maxx)+i)+
            (integer(n div maxx)+j)*maxx_scape);
    end;
    pba:=ba;
    {setpal(0,0,0,0);}
  until port[$60]=1;
end;

{ main routine --------------------------------------------------------------}

var memory:longint; i:word;
begin
  if not mouseinstalled then begin writeln('need mouse.'); halt; end;
  if maxavail<(maxx_scape*maxy_scape+((360 div dy)*maxx*maxy)) then begin
    writeln('not enough memory.'); halt; end;
  setvideo($13);
  initcolors;
  memory:=maxavail;
  getmem(landscape,maxx_scape*maxy_scape);
  generatelandscape;
  precalc;
  mousewindow(0,0,maxx_scape-maxx,maxy_scape-maxy);
  mousesensetivity(25,25);
  displayscape;
  setvideo(3);
  freemem(landscape,maxx_scape*maxy_scape);
  for i:=0 to (350 div dy)-1 do freemem(base[i],2*maxx*maxy);
  writeln('before : ',memory);
  writeln('after  : ',maxavail);
end.
