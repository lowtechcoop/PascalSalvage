program mouse;
uses crt,gfx3;

var x,y,but:word;
    col:byte;
function initmouse: word;assembler;
{Initialize mouse driver}
asm mov ax, 0h; int 33h; end;

procedure showmousecursor;assembler;
{Instruct BIOS to show mouse cursor}
asm mov ax, 01h; int 33h; end;

procedure hidemousecursor;assembler;
{Instruct BIOS to hide mouse cursor}
asm mov ax, 02h; int 33h; end;

procedure getmousepos (var x, y, button: word);
{Return the current location of the mouse}
var x1, y1, b : word;
begin
     Asm mov ax, 03h;
     int 33h;
     mov [b], bx;
     mov [x1], cx;
     mov [y1], dx;
     end;
     x:=x1; y:=y1; button := b;
end;

Procedure setmousewindow (X1, Y1, X2, Y2: Word);assembler;
{Set the mouse window}
asm mov ax, 07h; mov cx,[x1]; mov dx,[x2]; int 33h; inc ax;
    mov cx,[y1]; mov dx,[y2]; int 33h; end;

procedure WriteXY(x, y : integer; s : string);
begin
  if (x in [1..80]) and (y in [1..25]) then
  begin
    GoToXY(x, y);
    Write(s);
  end ;
  end;

procedure WriteS(x, y, l : integer);
begin
  if (x in [1..80]) and (y in [1..25]) then
  begin
    GoToXY(x, y);
    Write(l);

  end
 end;

begin;
setmcga;
initmouse;
showmousecursor;
{setmousewindow(0,0,640,200);
}clrscr;
directvideo:=false;
setupvirtual;
repeat

waitretrace;
getmousepos(x,y,but);
if but=1 then putpixel(x div 2,y ,col,VGA);
col:=col+1;


{writexy(3,3,' ');


writeS(1,1,but);
writeS(1,3,x);
writexy(3,5,' ');
writeS(1,5,y);
}
until keypressed=true;
shutdown;
settext;
end.
