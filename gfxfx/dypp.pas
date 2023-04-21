
{$g+}
program different_y_pixel_position;
{ Fast DYPP, including scroll, by Bas van Gaalen, Holland, PD }
uses crt;
const
  border=false;
  amp1=20; amp2=8;
  spd1=2; spd2=4;
  slen1=250; slen2=180; { experiment with these, keep below byte-size (255) }
  lines=23; lineoffset=4;
  txt:string='This thing is called a DYPP: Different-Y-Pixel-Position... '+
    ' Uh huh huh huh m... Hey Beavis, shut up!                           ';
type styp = array[0..255] of integer;
var
  bitmap:array[0..lines*320-1] of byte;
  cpos:array[0..319] of word;
  stab1,stab2:styp;
  fseg,fofs:word;

procedure getfont; assembler;
asm
  mov ax,1130h
  mov bh,6
  int 10h
  mov fseg,es
  mov fofs,bp
end;

procedure setborder(col:byte); assembler;
asm
  mov cx,word ptr border
  jcxz @out
  mov dx,3dah
  in al,dx
  mov dx,3c0h
  mov al,11h+32
  out dx,al
  mov al,col
  out dx,al
 @out:
end;

procedure retrace; assembler;
asm
  mov dx,03dah
 @l1:
  in al,dx
  test al,8
  jnz @l1
 @l2:
  in al,dx
  test al,8
  jz @l2
end;

procedure init;
var i:word; j:byte;
begin
  asm mov ax,13h; int 10h; end;
  for j:=0 to slen1 do stab1[j] := round(sin(2*j*pi/slen1)*amp1)+amp1;
  for j:=0 to slen2 do stab2[j] := round(sin(2*j*pi/slen2)*amp2)+amp2;
  fillchar(bitmap,sizeof(bitmap),0);
end;

procedure drawmap; assembler;
{ for j:=0 to 11 do for i:=0 to 319 do
    mem[sega000:cpos[i]+j*320]:=bitmap[j,i];}
var _cx:word;
asm
  mov es,sega000
  xor cx,cx                  { i (0 -> 319) }
 @l0:
  xor dx,dx                  { j (0 -> 11) }
  mov si,cx
  add si,cx
  mov di,word ptr cpos[si]
  mov si,cx
 @l1:
  mov al,byte ptr bitmap[si]
  mov [es:di],al
  add si,320
  add di,320
  inc dl
  cmp dl,lines
  jne @l1
  inc cx
  cmp cx,319
  jne @l0
end;

procedure scrollbitmap(var map); assembler;
asm
  lds si,map
  les di,map
  inc si
  add si,lineoffset*320
  add di,lineoffset*320
  mov cx,2560
  rep movsw
end;

procedure dypp;
var i:word; j,idx,idx2,scridx,ch,cp:byte;
begin
  idx:=0; idx2:=0; cp:=7; scridx:=1; ch:=byte(txt[scridx]);
  repeat
    retrace;
    setborder(44);
    for i:=0 to 319 do
      cpos[i]:=320*(stab1[(i+idx) mod slen1]+stab2[(i+idx2) mod slen2])+i;
    setborder(40);
    scrollbitmap(bitmap);
    setborder(36);
    for j:=0 to 15 do
      bitmap[(lineoffset+j)*320+319]:=
        ((mem[fseg:fofs+ch*16+j] shr cp) and 1)*(32+cp+j+scridx mod 60);
    dec(cp); cp:=cp mod 8;
    if cp=0 then begin
      scridx:=1+scridx mod length(txt);
      ch:=byte(txt[scridx]);
    end;
    setborder(32);
    drawmap;
    idx:=spd1+idx mod slen1;
    idx2:=spd2+idx2 mod slen2;
    setborder(0);
  until keypressed;
end;

begin
  getfont;
  init;
  dypp;
  textmode(lastmode);
end.
