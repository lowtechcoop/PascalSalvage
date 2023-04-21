
{$r+}
program polygons;
uses crt;
const vidseg:word=$a000;

procedure horline(xb,xe,y:integer; c:byte); assembler;
asm
  mov bx,[xb]
  cmp bx,0              { if zero don't draw }
  jz @out
  cmp bx,320
  ja @out
  mov cx,[xe]
  jcxz @out
  cmp cx,320
  ja @out
  cmp bx,cx             { see if x-end is smaller than x-begin }
  jb @skip
  xchg bx,cx            { yes: switch coords }
 @skip:
  inc cx
  sub cx,bx             { length of line in cx }
  mov es,vidseg         { segment to draw in }
  mov ax,[y]            { heigth of line }
  shl ax,6
  mov di,ax
  shl ax,2
  add di,ax             { y*320 in di (offset) }
  add di,bx             { add x-begin }
  mov al,[c]            { get color }
  shr cx,1              { div length by 2 }
  jnc @skip2            { carry set? }
  stosb                 { draw byte }
 @skip2:
  mov ah,al             { copy color in hi-byte }
  rep stosw             { draw (rest of) line }
 @out:
end;

procedure polygon(x1,y1,x2,y2,x3,y3,x4,y4:integer; c:byte);
var
  xpos:array[0..199,0..1] of integer;
  mny,mxy,y:integer;
  i:word;
  s1,s2,s3,s4:shortint;
  pos:byte;
begin
  mny:=y1;
  if y2<mny then mny:=y2;
  if y3<mny then mny:=y3;
  if y4<mny then mny:=y4;

  mxy:=y1;
  if y2>mxy then mxy:=y2;
  if y3>mxy then mxy:=y3;
  if y4>mxy then mxy:=y4;

  s1:=byte(y1<y2)*2-1;
  s2:=byte(y2<y3)*2-1;
  s3:=byte(y3<y4)*2-1;
  s4:=byte(y4<y1)*2-1;

  y:=y1; pos:=byte(y1<y2);
  if y1<>y2 then repeat
    xpos[y,pos]:=integer(x2-x1)*(y-y1) div (y2-y1)+x1;
    inc(y,s1);
  until y=y2+s1 else xpos[y,pos]:=x1;
  y:=y2; pos:=byte(y2<y3);
  if y2<>y3 then repeat
    xpos[y,pos]:=integer(x3-x2)*(y-y2) div (y3-y2)+x2;
    inc(y,s2);
  until y=y3+s2 else xpos[y,pos]:=x2;
  y:=y3; pos:=byte(y3<y4);
  if y3<>y4 then repeat
    xpos[y,pos]:=integer(x4-x3)*(y-y3) div (y4-y3)+x3;
    inc(y,s3);
  until y=y4+s3 else xpos[y,pos]:=x3;
  y:=y4; pos:=byte(y4<y1);
  if y4<>y1 then repeat
    xpos[y,pos]:=integer(x1-x4)*(y-y4) div (y1-y4)+x4;
    inc(y,s4);
  until y=y1+s4 else xpos[y,pos]:=x4;
  for y:=mny to mxy do
    horline(xpos[y,0],xpos[y,1],y,c);
end;

var
  time:longint absolute $0:$46c;
  ctr,time1,endtime1:longint;
  x1,x2,i:word; y,c:byte;
begin
  asm mov ax,13h; int 10h; end;
  randomize;
  ctr:=0;
  time1:=time;
  repeat
    polygon(random(300)+10,random(180)+10,random(300)+10,random(180)+10,random(300)+10,random(180)+10,
            random(300)+10,random(180)+10,random(256));
    inc(ctr);
  until keypressed;
  while keypressed do readkey;
  endtime1:=time;
  textmode(lastmode);
  write(ctr,' polygons in ',((endtime1-time1)/18.2):0:2,' sec. -> ');
  writeln('Polygons per second: ',(ctr/((endtime1-time1)/18.2)):0:2,' (ñ185?)');
  while not keypressed do; while keypressed do readkey;
end.
