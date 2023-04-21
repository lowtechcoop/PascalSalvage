
{$g+}
program different_y_char_position;
{ Slow DYCP, by Bas van Gaalen, Holland, PD }
uses crt;
const vseg : word = $a000; txt : string = 'Howdy folks, this is a DYCP';
var stab : array[0..255] of byte; fseg,fofs : word;

procedure getfont; assembler; asm
  mov ax,1130h; mov bh,1; int 10h; mov fseg,es; mov fofs,bp; end;

procedure csin; var i : byte; begin
  for i := 0 to 255 do stab[i] := round(sin(6*i*pi/255)*25)+150; end;

{procedure writechar(ch : char; x,y : word; col : byte);
var i,j,k : byte;
begin
  for j := 0 to 7 do
    for k := 0 to 7 do
      if ((mem[fseg:fofs+ord(ch)*8+j] shl k) and 128) <> 0 then
        mem[$a000:(y+j)*320+x+k] := col;
end;}

procedure writecharasm(c : char; x,y : word; col : byte); assembler;
asm
  push ds
  mov es,vseg
  mov dx,0         { j }
 @lout:
  mov ax,y         { y+j }
  add ax,dx
  shl ax,6         { *320 }
  mov bx,ax
  shl ax,2
  add bx,ax
  add bx,x         { +x }
  mov cx,0         { k }
 @lin:
  mov ax,0c000h
  mov ds,ax        { fseg }
  mov si,420ah     { fofs }
  xor ah,ah
  mov al,c         { ord(c) }
  shl ax,3         { *8 }
  add si,ax
  add si,dx        { +j }
  xor ah,ah
  mov al,[ds:si]
  shl al,cl        { shl k }
  and al,80h       { and 128 }
  cmp al,0         { <> 0 ? }
  je @skip
  mov di,bx
  add di,cx        { +k }
  mov al,col
  mov [es:di],al   { mem[seg:ofs] := col }
 @skip:
  inc cx
  cmp cx,8
  jne @lin
  inc dx
  cmp dx,8
  jne @lout
  pop ds
end;

procedure clear(x,y : word); assembler;
asm
  mov es,vseg
  mov dx,0
 @lout:
  mov cx,0
 @lin:
  mov ax,y
  add ax,dx
  shl ax,6
  mov di,ax
  shl ax,2
  add di,ax
  add di,x
  add di,cx
  xor ax,ax
  mov [es:di],ax
  add cx,2
  cmp cx,8
  jne @lin
  inc dx
  cmp dx,8
  jne @lout
end;

procedure dodycp;
var sctr,i : byte;
begin
  sctr := 0;
  repeat
    while (port[$3da] and 8) <> 0 do;
    while (port[$3da] and 8) = 0 do;
    for i := 1 to length(txt) do
      clear(40+i*8,stab[(sctr-1+2*i) mod 255]);
    for i := 1 to length(txt) do
      writecharasm(txt[i],40+i*8,stab[(sctr+2*i) mod 255],7);
    inc(sctr);
  until keypressed;
end;

begin
  getfont;
  csin;
  asm mov ax,13h; int 10h; end;
  dodycp;
  textmode(lastmode);
end.
