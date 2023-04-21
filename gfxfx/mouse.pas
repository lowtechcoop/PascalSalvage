
unit mouse;
{ Mouseunit for textmode. by Bas van Gaalen, Holland. }
interface

const
  mtypes : array[0..4] of string[6] = ('bus','serial','inport','ps/2','hp');

var
  buttons : word;
  verhi,verlo,mousetype : byte;
  driverinstalled : boolean;

procedure resetmouse;
procedure getmouseversion;
procedure showmouse;
procedure hidemouse;
function getmousex : byte;
function getmousey : byte;
function leftpressed : boolean;
function rightpressed : boolean;
procedure mousewindow(x1,y1,x2,y2 : byte);
function getstratcursor : string;

implementation

uses video;

procedure resetmouse; assembler;
asm
  xor ax,ax
  int 33h
  cmp ax,-1
  jne @skip
  mov driverinstalled,true
  mov buttons,bx
 @skip:
end;

procedure getmouseversion; assembler;
asm
  mov ax,24h
  int 33h
  mov verhi,bh
  mov verlo,bl
  mov mousetype,ch
end;

procedure showmouse; assembler;
asm
  mov ax,1
  int 33h
end;

procedure hidemouse; assembler;
asm
  mov ax,2
  int 33h
end;

function getmousex : byte; assembler;
asm
  mov ax,3
  int 33h
  shr cx,1
  shr cx,1
  shr cx,1
  mov ax,cx
end;

function getmousey : byte; assembler;
asm
  mov ax,3
  int 33h
  shr dx,1
  shr dx,1
  shr dx,1
  mov ax,dx
end;

function leftpressed : boolean; assembler;
asm
  mov ax,3
  int 33h
  and bx,1
  mov ax,bx
end;

function rightpressed : boolean; assembler;
asm
  mov ax,3
  int 33h
  and bx,2
  mov ax,bx
end;

procedure mousewindow(x1,y1,x2,y2 : byte); assembler;
asm
  mov ax,7
  xor ch,ch
  xor dh,dh
  mov cl,x1
  shl cx,1
  shl cx,1
  shl cx,1
  mov dl,x2
  shl dx,1
  shl dx,1
  shl dx,1
  int 33h
  mov ax,8
  xor ch,ch
  xor dh,dh
  mov cl,y1
  shl cx,1
  shl cx,1
  shl cx,1
  mov dl,y2
  shl dx,1
  shl dx,1
  shl dx,1
  int 33h
end;

function getstratcursor : string; assembler;
{ get string at cursor }
asm
  push ds
  les di,@result
  mov ax,3
  int 33h
  shr cx,1
  shr cx,1
  shr dx,1
  shr dx,1
  shr dx,1
  xor ah,ah
  mov al,v_columns
  mul dl
  shl ax,1
  mov si,ax
  add si,cx
  mov ds,v_vidseg

  push di
  xor cx,cx
  inc di

  std
 @l2:
  lodsw
  cmp al,32
  je @space
  jmp @l2

 @space:
  add si,4

  cld
 @l1:
  lodsw
  cmp al,32
  je @skip
  cmp al,46
  je @skip
  stosb
  inc cx
  cmp cx,8
  jne @l1

 @skip:
  pop di
  mov [es:di],cl

  pop ds
end;

end.
