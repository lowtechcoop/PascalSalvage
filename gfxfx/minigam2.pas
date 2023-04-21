
{$g+}
program small_game; { shoot-em-up }
{ Small shoot'm'up game (right button=exit!), by Bas van Gaalen, Holland, PD }
uses crt; { for 'delay' }
const
  vidseg:word=$a000;
  playerbullits=50; pbacc=5; pbmaxtime=2;
  compbullits=50; cbmaxtime=20; cbspd=3;
  compspd=2;
type
  posrec=record x,y:integer; end;
  realposrec=record x,y:real; end;
var
  pbs:array[0..playerbullits] of posrec;
  pbspd:array[0..playerbullits] of byte;
  cbs,cbdir:array[0..compbullits] of realposrec;
  virscr:pointer;
  score:longint;
  fofs,fseg,virseg,px,py,ppx,ppy:word;
  pbtimer,cbtimer,cenergy,penergy,range,cx,cy,pcx,pcy:integer;
  cxd,cyd:shortint;

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

{ video related routines --------------------------------------------------- }

procedure setpal(c,r,g,b:byte); assembler; asm
  mov dx,3c8h; mov al,[c]; out dx,al; inc dx; mov al,[r]
  out dx,al; mov al,[g]; out dx,al; mov al,[b]; out dx,al; end;

procedure getfont; assembler; asm
  mov ax,1130h; mov bh,1; int 10h; mov fseg,es; mov fofs,bp; end;

procedure cls(lvseg:word); assembler; asm
  mov es,[lvseg]; xor di,di; xor ax,ax; mov cx,320*200/2; rep stosw; end;

procedure flip(src,dst:word); assembler; asm
  push ds; mov ds,[src]; xor si,si; mov es,[dst]
  xor di,di; mov cx,320*200/2; rep movsw; pop ds; end;

procedure putpixel(x,y:word; c:byte; lvseg:word); assembler; asm
  mov es,[lvseg]; mov ax,[y]; shl ax,6; mov di,ax; shl ax,2
  add di,ax; add di,[x]; mov al,[c]; mov [es:di],al; end;

{ move routines ------------------------------------------------------------ }

procedure moveplayer;
var i:word;
begin
  ppx:=px; ppy:=py;
  px:=getmousex shr 1; py:=getmousey;
  if px<4 then px:=4 else if px>316 then px:=316;
  if py<4 then py:=4 else if py>196 then py:=196;
  if leftpressed then begin
    dec(pbtimer);
    if pbtimer<0 then begin
      pbtimer:=pbmaxtime;
      i:=0;
      while (i<playerbullits) and (pbs[i].x>0) do inc(i);
      if i<playerbullits then begin
        pbs[i].x:=px;
        pbs[i].y:=py;
        pbspd[i]:=1;
      end;
    end;
  end else pbtimer:=0;
end;

procedure movecomputer;
var i:word; rx,ry,difx,dify,big:integer;
begin
  pcx:=cx; pcy:=cy;
  dec(range);
  if range<0 then begin
    range:=random(100);
    case random(8) of
      0:begin cxd:=-1; cyd:=-1; end;
      1:begin cxd:=0; cyd:=-1; end;
      2:begin cxd:=1; cyd:=-1; end;
      3:begin cxd:=1; cyd:=0; end;
      4:begin cxd:=1; cyd:=1; end;
      5:begin cxd:=0; cyd:=1; end;
      6:begin cxd:=-1; cyd:=1; end;
      7:begin cxd:=-1; cyd:=0; end;
    end;
  end;
  inc(cx,cxd*compspd);
  inc(cy,cyd*compspd);
  if cx<4 then begin cx:=4; range:=0; end
  else if cx>316 then begin cx:=316; range:=0; end;
  if cy<4 then begin cy:=4; range:=0; end
  else if cy>196 then begin cy:=196; range:=0; end;
  dec(cbtimer);
  if cbtimer<0 then begin
    cbtimer:=random(cbmaxtime);
    i:=0;
    while (i<compbullits) and (cbs[i].x>0) do inc(i);
    if i<compbullits then begin
      rx:=random(10)-5; ry:=random(10)-5;
      cbs[i].x:=cx;
      cbs[i].y:=cy;
      if cx>(px+rx) then difx:=cx-(px+rx) else difx:=(px+rx)-cx;
      if cy>(py+ry) then dify:=cy-(py+ry) else dify:=(py+ry)-cy;
      if difx>dify then big:=difx else big:=dify;
      if big<>0 then begin
        cbdir[i].x:=cbspd*(difx/big);
        cbdir[i].y:=cbspd*(dify/big);
        if cx>(px+rx) then cbdir[i].x:=-cbdir[i].x;
        if cy>(py+ry) then cbdir[i].y:=-cbdir[i].y;
      end;
    end;
  end;
end;

procedure moveplayerbullits;
var i:word;
begin
  for i:=0 to playerbullits do
    if pbs[i].x>0 then begin
      dec(pbs[i].y,pbspd[i]);
      if (pbs[i].y mod pbacc)=0 then inc(pbspd[i]);
      if pbs[i].y<0 then begin
        pbs[i].x:=0; pbs[i].y:=0; pbspd[i]:=0;
      end;
    end;
end;

procedure movecompbullits;
var i:word;
begin
  for i:=0 to compbullits do
    if cbs[i].x>0 then begin
      cbs[i].x:=cbs[i].x+cbdir[i].x;
      cbs[i].y:=cbs[i].y+cbdir[i].y;
      if (cbs[i].x<4) or (cbs[i].x>316) or
         (cbs[i].y<4) or (cbs[i].y>196) then begin
        cbs[i].x:=0; cbs[i].y:=0;
        cbdir[i].x:=0; cbdir[i].y:=0;
      end;
    end;
end;

{ -------------------------------------------------------------------------- }

procedure writetxt(x,y:word; txt:string; lvseg:word);
var i,j,k:byte;
begin
  for i:=1 to length(txt) do for j:=0 to 7 do for k:=0 to 7 do
    if ((mem[fseg:fofs+ord(txt[i])*8+j] shl k) and 128) <> 0 then
      mem[lvseg:(y+j)*320+(i*8)+x+k]:=15;
end;

{ check collisions --------------------------------------------------------- }

procedure checkall;
var i:word; dx,dy:integer;
begin
  i:=0; { player bullits hit computer }
  while (i<playerbullits) and (pbs[i].x>0) do begin
    dx:=(cx-pbs[i].x)+3;
    dy:=(cy-pbs[i].y)+3;
    if (dx>=0) and (dx<=6) and
       (dy>=0) and (dy<=6) then begin
      inc(score);
      dec(cenergy);
      if cenergy<0 then begin
        writetxt(130,96,'YOU WON',vidseg);
        delay(1000);
        repeat until leftpressed;
        { correct? }
        fillchar(pbs,sizeof(pbs),0);
        fillchar(pbspd,sizeof(pbspd),0);
        fillchar(cbs,sizeof(cbs),0);
        fillchar(cbdir,sizeof(cbdir),0);
        pbtimer:=pbmaxtime; cbtimer:=random(cbmaxtime);
        cx:=4+random(312); cy:=4+random(192);
        range:=0;
        score:=0;
        cenergy:=100;
        penergy:=100;
      end;
    end;
    inc(i);
  end;
  i:=0; { computer bullits hit player }
  while (i<compbullits) and (cbs[i].x>0) do begin
    dx:=(px-round(cbs[i].x))+3;
    dy:=(py-round(cbs[i].y))+3;
    if (dx>=0) and (dx<=6) and
       (dy>=0) and (dy<=6) then begin
      dec(penergy);
      if penergy<0 then begin
        writetxt(120,96,'GAME OVER!',vidseg);
        delay(1000);
        repeat until leftpressed;
        fillchar(pbs,sizeof(pbs),0);
        fillchar(pbspd,sizeof(pbspd),0);
        fillchar(cbs,sizeof(cbs),0);
        fillchar(cbdir,sizeof(cbdir),0);
        pbtimer:=pbmaxtime; cbtimer:=random(cbmaxtime);
        cx:=4+random(312); cy:=4+random(192);
        range:=0;
        score:=0;
        cenergy:=100;
        penergy:=100;
      end;
    end;
    inc(i);
  end;
end;

{ draw all stuff to screen ------------------------------------------------- }

procedure drawall;
var scorestr:string; lcbx,lcby,i:word;
begin
  { player }
  putpixel(px,py,15,virseg);
  putpixel(px-1,py+1,7,virseg);
  putpixel(px+1,py+1,7,virseg);
  putpixel(px-2,py+2,8,virseg);
  putpixel(px+2,py+2,8,virseg);
  { computer }
  putpixel(cx-1,cy-1,8,virseg);
  putpixel(cx,cy-1,3,virseg);
  putpixel(cx+1,cy-1,8,virseg);
  putpixel(cx-1,cy,3,virseg);
  putpixel(cx+1,cy,3,virseg);
  putpixel(cx-1,cy+1,8,virseg);
  putpixel(cx,cy+1,3,virseg);
  putpixel(cx+1,cy+1,8,virseg);
  { player bullits }
  for i:=0 to playerbullits do
    if pbs[i].x>0 then begin
      putpixel(pbs[i].x,pbs[i].y-2,15,virseg);
      putpixel(pbs[i].x,pbs[i].y-1,9,virseg);
      putpixel(pbs[i].x,pbs[i].y,1,virseg);
    end;
  { computer bullits }
  for i:=0 to compbullits do
    if cbs[i].x>0 then begin
      lcbx:=round(cbs[i].x); lcby:=round(cbs[i].y);
      putpixel(lcbx,lcby,15,virseg);
      putpixel(lcbx,lcby+1,4,virseg);
      putpixel(lcbx,lcby-1,4,virseg);
      putpixel(lcbx+1,lcby,4,virseg);
      putpixel(lcbx-1,lcby,4,virseg);
    end;
  { score }
  str(score,scorestr);
  writetxt(10,190,scorestr,virseg);
  { penergy-bar }
  for i:=199 downto (199-penergy) do begin
    putpixel(1,i,8,virseg);
    putpixel(2,i,15,virseg);
    putpixel(3,i,8,virseg);
  end;
  { cenergy-bar }
  for i:=199 downto (199-cenergy) do begin
    putpixel(316,i,3,virseg);
    putpixel(317,i,15,virseg);
    putpixel(318,i,3,virseg);
  end;
  while (port[$3da] and 8) <> 0 do;
  while (port[$3da] and 8) = 0 do;
  flip(virseg,vidseg);
end;

procedure clearall;
var lcbx,lcby,i,j:word;
begin
  { player }
  putpixel(px,py,0,virseg);
  putpixel(px-1,py+1,0,virseg);
  putpixel(px+1,py+1,0,virseg);
  putpixel(px-2,py+2,0,virseg);
  putpixel(px+2,py+2,0,virseg);
  { computer }
  putpixel(cx-1,cy-1,0,virseg);
  putpixel(cx,cy-1,0,virseg);
  putpixel(cx+1,cy-1,0,virseg);
  putpixel(cx-1,cy,0,virseg);
  putpixel(cx+1,cy,0,virseg);
  putpixel(cx-1,cy+1,0,virseg);
  putpixel(cx,cy+1,0,virseg);
  putpixel(cx+1,cy+1,0,virseg);
  { player bullits }
  for i:=0 to playerbullits do
    if pbs[i].x>0 then begin
      putpixel(pbs[i].x,pbs[i].y-2,0,virseg);
      putpixel(pbs[i].x,pbs[i].y-1,0,virseg);
      putpixel(pbs[i].x,pbs[i].y,0,virseg);
    end;
  { computer bullits }
  for i:=0 to compbullits do
    if cbs[i].x>0 then begin
      lcbx:=round(cbs[i].x); lcby:=round(cbs[i].y);
      putpixel(lcbx,lcby,0,virseg);
      putpixel(lcbx,lcby+1,0,virseg);
      putpixel(lcbx,lcby-1,0,virseg);
      putpixel(lcbx+1,lcby,0,virseg);
      putpixel(lcbx-1,lcby,0,virseg);
    end;
  { score }
  for i:=0 to 7 do for j:=0 to 23 do putpixel(10+j,190+i,0,virseg);
  { penergy-bar }
  for i:=199 downto 99 do begin
    putpixel(1,i,0,virseg);
    putpixel(2,i,0,virseg);
    putpixel(3,i,0,virseg);
  end;
  { cenergy-bar }
  for i:=199 downto 99 do begin
    putpixel(316,i,0,virseg);
    putpixel(317,i,0,virseg);
    putpixel(318,i,0,virseg);
  end;
end;

{ main --------------------------------------------------------------------- }

var i,j:word;
begin
  if not mouseinstalled then begin writeln('Needs mouse!'); halt; end;
  mousesensetivity(20,20);
  getfont;
  asm mov ax,13h; int 10h; end;
  getmem(virscr,64000); virseg:=seg(virscr^); cls(virseg);
  for i:=16 to 255 do setpal(i,i div 4,i div 5,i div 6);
  fillchar(pbs,sizeof(pbs),0);
  fillchar(pbspd,sizeof(pbspd),0);
  fillchar(cbs,sizeof(cbs),0);
  fillchar(cbdir,sizeof(cbdir),0);
  range:=0;
  score:=0;
  penergy:=100;
  cenergy:=100;
  px:=0; py:=0; cx:=4+random(312); cy:=4+random(192);
  randomize;
  pbtimer:=pbmaxtime; cbtimer:=random(cbmaxtime);
  repeat
    moveplayer;
    movecomputer;
    moveplayerbullits;
    movecompbullits;
    checkall;
    drawall;
    clearall;
  until rightpressed;
  freemem(virscr,64000);
  asm mov ax,3; int 10h; end;
end.

{
  'features':
  - players autofire is slower than a trigger-happy manual-fire.
  - for computer-player:
    the higher number of bullits and the lower the maxtime, the harder it
    gets for the person-player, and vice-versa, if you know what I mean.
  - You can make it al realy impossible for yourself, it you set:
    compbullits=50, cbmaxtime=5, cbspd=3, for instance.
}
