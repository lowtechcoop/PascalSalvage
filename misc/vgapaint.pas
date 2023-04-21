program VGAPRO;

{$Define Protected Mode}

uses KojakVGA, Crt;

var
   image : array [1..64000] of char absolute $A000:0000;
   pal : array [1..768] of byte absolute $A000:64000;
   ImageInMem : array [1..64000] of char;
   Vgafile : file;
   ch : char;
   Red, Green, Blue, ForeGroundColor, BackGroundColor : byte;
   counter, counter2 : longint;
   x, y, x2, y2, mX,MouseX,MouseY, mY, bX, bY, x3, y3, x4, y4, color, col, Position : integer;
   leftpressed,rightpressed:word;
   BackGround : array [1..6, 1..8] of byte;
   FileName, OldFileName : string [26];
   Finished, FinishedAgain, Done : boolean;
   pal2 : PaletteType absolute $A000:64800;


function loadmouse: word;assembler;
{Initialize mouse driver }
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
     Asm mov ax, 03h; int 33h; mov [b], bx; mov [x1], cx; mov [y1], dx; end;
     x:=x1; y:=y1; button := b;
end;

Procedure setmousewindow (X1, Y1, X2, Y2: Word);assembler;
{Set the mouse window}
asm mov ax, 07h; mov cx,[x1]; mov dx,[x2]; int 33h; inc ax;
    mov cx,[y1]; mov dx,[y2]; int 33h; end;

procedure palette(c,r,g,b:byte); assembler; asm
  mov dx,03c8h; mov al,c; out dx,al; inc dx; mov al,r
  out dx,al; mov al,g; out dx,al; mov al,b; out dx,al end;

procedure Box(x1,y1,x2,y2,c:integer);
var
  x, y, tempvar : integer;
  memcol : array [0..319] of byte;
begin
   if x1>x2 then
   begin
      TempVar:= x1;
      x1:= x2;
      x2:= TempVar;
   end;
   if x1<0 then x1:=0;
   if y1<0 then y1:=0;
   if x2<0 then x2:=0;
   if x2>319 then x2:=319;
   if y2<0 then y2:=0;
   if y2>199 then y2:=199;
   for x:=0 to 319 do memcol[x]:=c;
   for y:=y1 to y2 do
   begin
      move(memcol, mem[$A000:x1+y*320], x2-x1+1);
   end;
end;

procedure Button(x, y : integer);
begin
   Box(x, y, x+8, y+8,7);
   UseColour(15);
   Line(x, y, x+7, y);
   Line(x, y, x, y+8);
   UseColour(8);
   Line(x+8, y, x+8, y+8);
   Line(x+1, y+8, x+8, y+8);
end;

procedure PrintAt(x, y : integer; message : string; c : byte);
var
   count : integer;
begin
   UseColour(c);
   for count:= 1 to Length(message) do
   begin
      case message[count] of
         ' ' : x:= x+4;
         'A', 'a' : begin
                       Line(x, y+1, x, y+4);
                       PutPixel(x+1, y, c);
                       PutPixel(x+1, y+2, c);
                       Line(x+2, y+1, x+2, y+4);
                       x:= x+4;
                    end;
         'B', 'b' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y, c);
                       PutPixel(x+1, y+2, c);
                       PutPixel(x+1, y+4, c);
                       Line(x+2, y, x+2, y+1);
                       Line(x+2, y+3, x+2, y+4);
                       x:= x+4;
                    end;
         'C', 'c' : begin
                       Line(x, y+1, x, y+3);
                       Line(x+1, y, x+2, y);
                       Line(x+1, y+4, x+2, y+4);
                       x:= x+4;
                    end;
         'D', 'd' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y, c);
                       PutPixel(x+1, y+4, c);
                       Line(x+2, y+1, x+2, y+3);
                       x:= x+4;
                    end;
         'E', 'e' : begin
                       Line(x, y, x, y+4);
                       Line(x+1, y, x+2, y);
                       PutPixel(x+1, y+2, c);
                       Line(x+1, y+4, x+2, y+4);
                       x:= x+4;
                    end;
         'F', 'f' : begin
                       Line(x, y, x, y+4);
                       Line(x+1, y, x+2, y);
                       PutPixel(x+1, y+2, c);
                       x:= x+4;
                    end;
         'G', 'g' : begin
                       Line(x, y, x, y+2);
                       PutPixel(x+1, y, c);
                       PutPixel(x+1, y+2, c);
                       Line(x+2, y, x+2, y+4);
                       Line(x, y+4, x+1, y+4);
                       x:= x+4;
                    end;
         'H', 'h' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y+2, c);
                       Line(x+2, y, x+2, y+4);
                       x:= x+4;
                    end;
         'I', 'i' : begin
                       Line(x, y, x+2, y);
                       Line(x+1, y+1, x+1, y+3);
                       Line(x, y+4, x+2, y+4);
                       x:= x+4;
                    end;
         'J', 'j' : begin
                       Line(x, y, x+2, y);
                       Line(x+1, y+1, x+1, y+3);
                       Line(x, y+4, x+1, y+4);
                       x:= x+4;
                    end;
         'K', 'k' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y+2, c);
                       Line(x+2, y, x+2, y+1);
                       Line(x+2, y+3, x+2, y+4);
                       x:= x+4;
                    end;
         'L', 'l' : begin
                       Line(x, y, x, y+4);
                       Line(x+1, y+4, x+2, y+4);
                       x:= x+4;
                    end;
         'M', 'm' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y, c);
                       Line(x+2, y+1, x+2, y+4);
                       PutPixel(x+3, y, c);
                       Line(x+4, y+1, x+4, y+4);
                       x:= x+6;
                    end;
         'N', 'n' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y, c);
                       Line(x+2, y+1, x+2, y+4);
                       x:= x+4;
                    end;
         'O', 'o' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y, c);
                       PutPixel(x+1, y+4, c);
                       Line(x+2, y, x+2, y+4);
                       x:= x+4;
                    end;
         'P', 'p' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y, c);
                       PutPixel(x+1, y+2, c);
                       Line(x+2, y, x+2, y+2);
                       x:= x+4;
                    end;
         'Q', 'q' : begin
                       Line(x, y, x, y+2);
                       PutPixel(x+1, y, c);
                       PutPixel(x+1, y+2, c);
                       Line(x+2, y, x+2, y+4);
                       x:= x+4;
                    end;
         'R', 'r' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y, c);
                       Line(x+1, y+2, x+1, y+3);
                       Line(x+2, y, x+2, y+2);
                       PutPixel(x+2, y+4, c);
                       x:= x+4;
                   end;
         'S', 's' : begin
                       Line(x, y, x+2, y);
                       PutPixel(x, y+1, c);
                       Line(x, y+2, x+2, y+2);
                       PutPixel(x+2, y+3, c);
                       Line(x, y+4, x+2, y+4);
                       x:= x+4;
                    end;
         'T', 't' : begin
                       Line(x, y, x+2, y);
                       Line(x+1, y+1, x+1, y+4);
                       x:= x+4;
                    end;
         'U', 'u' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y+4, c);
                       Line(x+2, y, x+2, y+4);
                       x:= x+4;
                    end;
         'V', 'v' : begin
                       Line(x, y, x, y+3);
                       PutPixel(x+1, y+4, c);
                       Line(x+2, y, x+2, y+3);
                       x:= x+4;
                    end;
         'W', 'w' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y+4, c);
                       Line(x+2, y, x+2, y+3);
                       PutPixel(x+3, y+4, c);
                       Line(x+4, y, x+4, y+3);
                       x:= x+6;
                    end;
         'X', 'x' : begin
                       Line(x, y, x, y+1);
                       Line(x+2, y, x+2, y+1);
                       PutPixel(x+1, y+2, c);
                       Line(x, y+3, x, y+4);
                       Line(x+2, y+3, x+2, y+4);
                       x:= x+4;
                    end;
         'Y', 'y' : begin
                       Line(x, y, x, y+2);
                       Line(x+2, y, x+2, y+2);
                       Line(x+1, y+2, x+1, y+4);
                       x:= x+4;
                    end;
         'Z', 'z' : begin
                       Line(x, y, x+2, y);
                       PutPixel(x+2, y+1, c);
                       PutPixel(x+1, y+2, c);
                       PutPixel(x, y+3, c);
                       Line(x, y+4, x+2, y+4);
                       x:= x+4;
                    end;
         #39 : begin
                  Line(x+1, y, x+1, y+1);
                  x:= x+4;
               end;
         '1' : begin
                  PutPixel(x, y+1, c);
                  Line(x+1, y, x+1, y+3);
                  Line(x, y+4, x+2, y+4);
                  x:= x+4;
               end;
         '2' : begin
                   PutPixel(x+1, y, c);
                   PutPixel(x, y+1, c);
                   Line(x+2, y+1, x+2, y+2);
                   PutPixel(x+1, y+3, c);
                   Line(x, y+4, x+2, y+4);
                   x:= x+4;
                end;
         '3' : begin
                  Line(x, y, x+1, y);
                  PutPixel(x+2, y+1, c);
                  PutPixel(x+1, y+2, c);
                  PutPixel(x+2, y+3, c);
                  Line(x, y+4, x+1, y+4);
                  x:= x+4;
               end;
         '4' : begin
                  Line(x, y, x, y+2);
                  PutPixel(x+1, y+2, c);
                  Line(x+2, y, x+2, y+4);
                  x:= x+4;
               end;
         '5' : begin
                  Line(x, y, x+2, y);
                  PutPixel(x, y+1, c);
                  Line(x, y+2, x+1, y+2);
                  PutPixel(x+2, y+3, c);
                  Line(x, y+4, x+1, y+4);
                  x:= x+4;
               end;
         '6' : begin
                  Line(x+1, y, x+2, y);
                  Line(x, y+1, x, y+4);
                  PutPixel(x+1, y+2, c);
                  PutPixel(x+1, y+4, c);
                  Line(x+2, y+2, x+2, y+4);
                  Line(x, y+4, x+1, y+4);
                  x:= x+4;
               end;
         '7' : begin
                  Line(x, y, x+2, y);
                  Line(x+2, y+1, x+2, y+2);
                  Line(x+1, y+3, x+1, y+4);
                  x:= x+4;
               end;
         '8' : begin
                  Line(x, y, x, y+4);
                  Line(x+2, y, x+2, y+4);
                  PutPixel(x+1, y, c);
                  PutPixel(x+1, y+2, c);
                  PutPixel(x+1, y+4, c);
                  x:= x+4;
               end;
         '9' : begin
                  Line(x, y, x, y+2);
                  Line(x+2, y, x+2, y+3);
                  PutPixel(x+1, y, c);
                  PutPixel(x+1, y+2, c);
                  Line(x, y+4, x+1, y+4);
                  x:= x+4;
               end;
         '0' : begin
                  Line(x, y+1, x, y+3);
                  Line(x+2, y+1, x+2, y+3);
                  PutPixel(x+1, y, c);
                  PutPixel(x+1, y+4, c);
                  x:= x+4;
               end;
         '(' : begin
                  Line(x, y+1, x, y+3);
                  PutPixel(x+1, y, c);
                  PutPixel(x+1, y+4, c);
                  x:= x+4;
               end;
         ')' : begin
                  Line(x+2, y+1, x+2, y+3);
                  PutPixel(x+1, y, c);
                  PutPixel(x+1, y+4, c);
                  x:= x+4;
               end;
         '.' : begin
                   PutPixel(x+1, y+4, c);
                   x:=x+4;
               end;
         ':' : begin
                   PutPixel(x+1, y+1, c);
                   PutPixel(x+1, y+3, c);
                   x:=x+4;
               end;
         '\' : begin
                   Line(x, y, x, y+1);
                   Line(x+1, y+2, x+1, y+3);
                   PutPixel(x+2, y+4, c);
                   x:=x+4;
               end;
         '_' : begin
                   Line(x, y+4, x+2, y+4);
                   x:=x+4;
               end;
         else
               begin
                   PutPixel(x, y+1, c);
                   PutPixel(x+2, y+1, c);
                   PutPixel(x+1, y+2, c);
                   PutPixel(x, y+3, c);
                   PutPixel(x+2, y+3, c);
                   x:=x+4;
               end;
      end;
   end;
   x3:=x; y3:=y
end;

procedure GetBackGround;
begin
   y4:=1;
   for y3:=mY to mY+7 do
   begin
      x4:= 1;
      for x3:=mX to mX+5 do
      begin
         BackGround[x4, y4]:= GetPixel(x3, y3);
         x4:= x4+1;
      end;
      y4:= y4+1;
   end;
end;

procedure PutBackGround;
begin
   y4:=1;
   for y3:=mY to mY+7 do
   begin
      x4:= 1;
      for x3:=mX to mX+5 do
      begin
         PutPixel(x3, y3, BackGround[x4, y4]);
         x4:= x4+1;
      end;
      y4:= y4+1;
   end;
end;

procedure BigButton(x, y : integer);
begin
   Box(x+1, y+1, x+22, y+20, 7);
   UseColour(15);
   Line(x, y, x+22, y);
   Line(x, y, x, y+21);
   UseColour(8);
   Line(x+23, y, x+23, y+21);
   Line(x+1, y+21, x+23, y+21);
end;

procedure PressedBigButton(x, y : integer);
begin
   Box(x+1, y+1, x+22, y+20, 7);
   UseColour(8);
   Line(x, y, x+22, y);
   Line(x, y, x, y+21);
   UseColour(15);
   Line(x+23, y, x+23, y+21);
   Line(x+1, y+21, x+23, y+21);
end;

procedure ScrollUpButton(x, y : integer);
begin
   Button(x, y);
   PutPixel(x+4, y+3, 8);
   UseColour(8);
   Line(x+3, y+4, x+5, y+4);
   Line(x+2, y+5, x+6, y+5);
end;

procedure ScrollDownButton(x, y : integer);
begin
   Button(x, y);
   UseColour(8);
   Line(x+2, y+3, x+6, y+3);
   Line(x+3, y+4, x+5, y+4);
   PutPixel(x+4, y+5, 8);
end;

procedure ScrollLeftButton(x, y : integer);
begin
   Button(x, y);
   UseColour(8);
   PutPixel(x+3, y+4, 8);
   Line(x+4, y+3, x+4, y+5);
   Line(x+5, y+2, x+5, y+6);
end;

procedure ScrollRightButton(x, y : integer);
begin
   Button(x, y);
   UseColour(8);
   Line(x+3, y+2, x+3, y+6);
   Line(x+4, y+3, x+4, y+5);
   PutPixel(x+5, y+4, 8);
end;

procedure ExitButton(x, y : integer);
begin
   Button(x, y);
   PutPixel(x+2, y+2, 8);
   PutPixel(x+6, y+2, 8);
   PutPixel(x+3, y+3, 8);
   PutPixel(x+5, y+3, 8);
   PutPixel(x+4, y+4, 8);
   PutPixel(x+3, y+5, 8);
   PutPixel(x+5, y+5, 8);
   PutPixel(x+2, y+6, 8);
   PutPixel(x+6, y+6, 8);
end;

procedure OkButton(x, y : integer);
begin
   UseColour(15);
   Line(x, y, x+24, y);
   Line(x, y, x, y+8);
   UseColour(8);
   Line(x+25, y, x+25, y+8);
   Line(x+1, y+8, x+25, y+8);
   Box(x+1, y+1, x+24, y+7, 7);
   PrintAt(x+9, y+2, 'OK', 8);
end;

procedure YesButton(x, y : integer);
begin
   UseColour(15);
   Line(x, y, x+24, y);
   Line(x, y, x, y+8);
   UseColour(8);
   Line(x+25, y, x+25, y+8);
   Line(x+1, y+8, x+25, y+8);
   Box(x+1, y+1, x+24, y+7, 7);
   PrintAt(x+7, y+2, 'YES', 8);
end;

procedure NoButton(x, y : integer);
begin
   UseColour(15);
   Line(x, y, x+24, y);
   Line(x, y, x, y+8);
   UseColour(8);
   Line(x+25, y, x+25, y+8);
   Line(x+1, y+8, x+25, y+8);
   Box(x+1, y+1, x+24, y+7, 7);
   PrintAt(x+9, y+2, 'NO', 8);
end;

procedure InitScrollBars;
begin
   Box(308, 29, 316, y+28, 8);
   Box(308, y+124, 316, 167, 8);
   Box(309, y+30, 315, y+122, 7);
   UseColour(15);
   Line(308, y+29, 308, y+123);
   Line(308, y+29, 315, y+29);
   UseColour(8);
   Line(316, y+29, 316, y+123);
   Line(309, y+123, 316, y+123);
   Box(64, 177, x+64, 185, 8);
   Box(x+231, 177, 298, 185, 8);
   Box(x+65, 178, x+229, 184, 7);
   UseColour(15);
   Line(x+64, 177, x+229, 177);
   Line(x+64, 177, x+64, 185);
   UseColour(8);
   Line(x+230, 177, x+230, 185);
   Line(x+65, 185, x+230, 185);
end;

procedure MousePointer;
begin
   UseColour(0);
   Line(mX, mY, mX, mY+6);
   Line(mX+1, mY+6, mX+3, mY+6);
   PutPixel(mX+2, mY+1, 0);
   PutPixel(mX+2, mY+5, 0);
   Line(mX+3, mY+6, mX+3, mY+7);
   PutPixel(mX+4, mY+3, 0);
   PutPixel(mX+3, mY+2, 0);
   PutPixel(mX+1, mY, 0);
   PutPixel(mX+4, mY+5, 0);
   PutPixel(mX+4, mY+7, 0);
   Line(mX+5, mY+4, mX+5 ,mY+7);
   UseColour(15);
   Line(mX+1, mY+1, mX+1, mY+5);
   Line(mX+2, mY+2, mX+2, mY+4);
   Line(mX+3, mY+3, mX+3, mY+5);
   PutPixel(mX+4, mY+4, 15);
   PutPixel(mX+4, mY+6, 15);
end;

procedure InitColorBar;
var
   OldCol : byte;
begin
   if LeftPressed then
   begin
      PutBackGround;
      OldCol:= Col;
      for x2:= 0 to 23 do
      begin
         Box(x2*10+64, 188, x2*10+73, 196, OldCol);
         OldCol:= OldCol+1;
      end;
      GetBackGround;
      MousePointer;
      Delay(20);
   end
   else
   begin
      OldCol:= Col;
      for x2:= 0 to 23 do
      begin
         Box(x2*10+64, 188, x2*10+73, 196, OldCol);
         OldCol:= OldCol+1;
      end;
   end;
end;

procedure PickColor;
begin
   Box(5, 178, 50, 182, BackGroundColor);
   Box(5, 191, 50, 195, BackGroundColor);
   Box(5, 183, 13, 190, BackGroundColor);
   Box(42, 183, 50, 190, BackGroundColor);
   Box(14, 183, 41, 190, ForeGroundColor);
end;

procedure InitDesktop;
begin
   InitVGAmode;
   MouseWindow(0, 0, 639, 199);
   MouseSenseTivity(60, 60);
   Box(0, 0, 319, 199, 7);
   Box(0, 0, 319, 10, 1);
   PutPixel(10, 1, 0);
   UseColour(0);
   Line(8, 2, 10, 2);
   Line(8, 3, 9, 3);
   UseColour(6);
   Line(5, 4, 6, 4);
   PutPixel(7, 4, 4);
   Line(3, 5, 5, 5);
   PutPixel(6, 5, 4);
   Line(7, 5, 8, 5);
   Line(2, 6, 2, 8);
   UseColour(2);
   Line(3, 6, 4, 6);
   UseColour(6);
   Line(3, 7, 4, 7);
   Box(5, 6, 7, 7, 6);
   PutPixel(8, 6, 6);
   PutPixel(3, 8, 4);
   PutPixel(4, 8, 6);
   PutPixel(5, 8, 9);
   PutPixel(6, 8, 6);
   Line(3, 9, 5, 9);
   UseColour(8);
   Line(55, 20, 307, 20);
   Line(55, 20, 55, 177);
   UseColour(15);
   Line(0, 11, 318, 11);
   Line(0, 11, 0, 199);
   UseColour(8);
   Line(319, 11, 319, 199);
   Line(1, 199, 319, 199);
   ExitButton(309, 1);
   ScrollUpButton(308, 20);
   ScrollDownButton(308, 168);
   Box(308, 29, 316, 167, 8);
   ScrollLeftButton(55, 177);
   ScrollRightButton(299, 177);
   Box(64, 177, 298, 185, 8);
   ScrollLeftButton(55, 188);
   InitColorBar;
   ScrollRightButton(304, 188);
   BigButton(4,20);
   BigButton(28,20);
   BigButton(4,42);
   BigButton(28,42);
   BigButton(4,64);
   BigButton(28,64);
   BigButton(4,86);
   BigButton(28,86);
   BigButton(4,108);
   BigButton(28,108);
   BigButton(4,130);
   BigButton(28,130);
   BigButton(4,152);
   BigButton(28,152);
   UseColour(8);
   Line(4, 177, 50, 177);
   Line(4, 177, 4, 196);
   UseColour(15);
   Line(5, 196, 51, 196);
   Line(51, 177, 51, 196);
   PickColor;
   PrintAt(15, 3, 'VGAPAINT 5.0', 15);
   PrintAt(188, 3, '(C) 1997 BY ROB VAN DER LINDE', 15);
   PrintAt(8,13,'FILE    EDIT    VIEW    IMAGE    PALETTE    FONT', 8);
   InitScrollBars;
   counter:=1;
   for color:=0 to 255 do
   begin
      port[$3C8]:=color;
      pal[counter]:=port[$3C9];
      pal[counter+1]:=port[$3C9];
      pal[counter+2]:=port[$3C9];
      pal[counter]:=port[$3C9];
      pal[counter+1]:=port[$3C9];
      pal[counter+2]:=port[$3C9];
      counter:=counter+3;
   end;
end;

procedure DisPlayImage(currentX, currentY : integer);
var
   TempY : integer;
begin
   currentY:=currentY-21;
   if LeftPressed then
   begin
      PutBackGround;
      Box(308, 29, 316, currentY+49, 8);
      Box(308, currentY+145, 316, 167, 8);
      Box(309, currentY+51, 315, currentY+143, LightGray);
      UseColour(15);
      Line(308, currentY+50, 308, currentY+144);
      Line(308, currentY+50, 315, currentY+50);
      UseColour(8);
      Line(316, currentY+50, 316, currentY+144);
      Line(309, currentY+144, 316, currentY+144);
      Box(63, 177, currentX+63, 185, 8);
      Box(currentX+230, 177, 298, 185, 8);
      Box(currentX+65, 178, currentX+229, 184, 7);
      UseColour(15);
      Line(currentX+64, 177, currentX+229, 177);
      Line(currentX+64, 177, currentX+64, 185);
      UseColour(8);
      Line(currentX+230, 177, currentX+230, 185);
      Line(currentX+65, 185, currentX+230, 185);
      GetBackGround;
      MousePointer;
   end;
   for TempY:= 21 to 176 do
   begin
      move(ImageInMem[(currentX+tempY*320)+1+(currentY*320)], image[(tempY*320)+57], 252);
   end;
end;

procedure InitMouse;
begin
   mX:= (MouseX div 2); mY:= MouseY;
   GetBackGround;
   MousePointer;
end;

procedure ShowMouse;
begin
   if (mX=(MouseX div 2)) and (mY=MouseY) then exit;
   y4:=1;
   for y3:=mY to mY+7 do
   begin
      x4:= 1;
      for x3:=mX to mX+5 do
      begin
         PutPixel(x3, y3, BackGround[x4, y4]);
         x4:= x4+1;
      end;
      y4:= y4+1;
   end;
   mX:= (MouseX div 2); mY:= MouseY;
   GetBackGround;
   MousePointer;
end;

procedure MsgBox(name, message : string);
begin
   UseColour(15);
   Line(99, 58, 250, 58);
   Line(99, 58, 99, 131);
   UseColour(8);
   Line(251, 58, 251, 131);
   Line(100, 131, 251, 131);
   UseColour(15);
   Line(100, 70, 249, 70);
   Line(100, 70, 100, 130);
   UseColour(8);
   Line(250, 70, 250, 130);
   Line(101, 130, 250, 130);
   Box(100, 59, 250, 69, 1);
   Box(101, 71, 249, 129, 7);
   PrintAt(104, 62, name, 15);
   PrintAt(110, 80, message, 8);
   ExitButton(240, 60);
end;

procedure Confirmation;
begin
   PutBackGround;
   MsgBox('CONFIRMATION', 'ARE YOU SURE YOU WANT TO EXIT...');
   YesButton(130, 114);
   NoButton(194, 114);
   GetBackGround;
   MousePointer;
   FinishedAgain:= False;
   Repeat
      ShowMouse;
      if (mX>239) and (mX<249) and (mY>59) and (mY<69) and LeftPressed then
         FinishedAgain:= True;
      if (mX>193) and (mX<220) and (mY>113) and (mY<123) and LeftPressed then
         FinishedAgain:= True;
      if (mX>129) and (mX<156) and (mY>113) and (mY<123) and LeftPressed then
      begin
         Finished:= True;
         FinishedAgain:= True;
      end;
      if KeyPressed then
      begin
         ch:= ReadKey;
         if (ch=#13) or (ch='Y') or (ch='y') then
         begin
            Finished:= True;
            FinishedAgain:=True;
         end;
         if (ch=#27) or (ch='N') or (ch='n') then
         begin
            FinishedAgain:=True;
         end;
      end;
   until FinishedAgain;
   PutBackGround;
   DisplayImage(x, y);
   GetBackGround;
   MousePointer;
   delay(200);
end;

procedure About;
begin
   MsgBox('ABOUT...','');
   PrintAt(142, 78, 'VGAPRO VERSION 5.0', 8);
   PrintAt(136, 89, 'COPYRIGHT (C)1997 BY:', 8);
   PrintAt(143, 100, 'ROB VAN DER LINDE', 8);
   OkButton(164,114);
   GetBackGround;
   MousePointer;
   FinishedAgain:= False;
   Repeat
      ShowMouse;
      if (mX>163) and (mX<190) and (mY>113) and (mY<123) and LeftPressed then
         FinishedAgain:= True;
      if (mX>239) and (mX<249) and (mY>59) and (mY<69) and LeftPressed then
         FinishedAgain:= True;
      if KeyPressed then
      begin
         ch:=ReadKey;
         if (ch=#27) or (ch=#13) then FinishedAgain:=True;
      end;
   until FinishedAgain;
   PutBackGround;
   DisplayImage(x, y);
   GetBackGround;
   delay(200);
end;

procedure Error(message : string);
begin
   MsgBox('ERROR', message);
   OkButton(164,114);
   GetBackGround;
   MousePointer;
   FinishedAgain:= False;
   Repeat
      ShowMouse;
      if (mX>163) and (mX<190) and (mY>113) and (mY<123) and LeftPressed then
         FinishedAgain:= True;
      if (mX>239) and (mX<249) and (mY>59) and (mY<69) and LeftPressed then
         FinishedAgain:= True;
      if KeyPressed then
      begin
         ch:=ReadKey;
         if (ch=#27) or (ch=#13) then FinishedAgain:=True;
      end;
   until FinishedAgain;
   PutBackGround;
   DisplayImage(x, y);
   GetBackGround;
   delay(200);
end;

procedure Head(name : string);
begin
   FileName:= name;
   Box(64, 3, 180, 7, 1);
   PrintAt(67, 3, '('+FileName+')', 15);
end;

procedure LoadImage(PictureFile : string);
begin
   Assign(Vgafile, PictureFile);
   {$i-} Reset(Vgafile); {$i+}
   if IoResult<>0 then
   begin
      error('FILE NOT FOUND');
      Head(OldFileName);
      exit;
   end;
   {$i-}
   BlockRead(Vgafile, pal, 6);
   BlockRead(Vgafile, ImageInMem, 500);
   Close(Vgafile);
   {$i+}
   if IoResult<>0 then
   begin
      error('ERROR READING FILE');
      Head(OldFileName);
      exit;
   end;
   Head(PictureFile);
   counter:=1;
   for color:=0 to 255 do
   begin
      red:=pal[counter];
      green:=pal[counter+1];
      blue:=pal[counter+2];
      counter:=counter+3;
      Palette(color, red, green, blue);
   end;
end;

procedure SaveImage(PictureFile : string);
begin
   Assign(Vgafile, PictureFile);
   {$i-}
   ReWrite(Vgafile);
   BlockWrite(Vgafile, pal, 6);
   BlockWrite(Vgafile, ImageInMem, 500);
   Close(Vgafile);
   {$i+}
   if IoResult<>0 then
   begin
      error('ERROR SAVING PICTURE');
      exit;
   end else Head(PictureFile);
end;

procedure LoadPal(PalFile : string);
begin
   Assign(Vgafile, PalFile);
   {$i-} Reset(Vgafile); {$i+}
   if IoResult<>0 then
   begin
      error('FILE NOT FOUND');
      exit;
   end;
   {$i-}
   BlockRead(Vgafile, pal, 6);
   Close(Vgafile);
   {$i+}
   if IoResult<>0 then
   begin
      error('ERROR READING FILE');
      exit;
   end;
   counter:=1;
   for color:=0 to 255 do
   begin
      red:=pal[counter];
      green:=pal[counter+1];
      blue:=pal[counter+2];
      counter:=counter+3;
      Palette(color, red, green, blue);
   end;
end;

procedure SavePal(PalFile : string);
begin
   Assign(Vgafile, Palfile);
   {$i-}
   ReWrite(Vgafile);
   BlockWrite(Vgafile, pal, 6);
   Close(Vgafile);
   {$i+}
   if IoResult<>0 then
   begin
      error('ERROR SAVING PALETTE');
      exit;
   end
end;

procedure FileMenu;

label cancel, cancel2, cancel3, cancel4, skip, skip2, skip3, skip4;

begin
   Done:=False;
   PutBackGround;
   Box(6, 12, 24, 18, 1);
   PrintAt(8, 13, 'FILE', 15);
   Box(4, 21, 60, 77, 7);
   UseColour(15);
   Line(3, 20, 60, 20);
   Line(3, 20, 3, 78);
   UseColour(8);
   Line(61, 20, 61, 78);
   Line(4, 78, 61, 78);
   PrintAt(10, 27, 'NEW', 8);
   PrintAt(10, 35, 'OPEN...', 8);
   PrintAt(10, 43, 'SAVE...', 8);
   PrintAt(10, 51, 'LOAD PAL...', 8);
   PrintAt(10, 59, 'SAVE PAL...', 8);
   PrintAt(10, 67, 'EXIT', 8);
   Delay(100);
   GetBackGround;
   MousePointer;
   Repeat
      ShowMouse;
   until LeftPressed;
   Box(6, 12, 24, 18, 7);
   PrintAt(8, 13, 'FILE', 8);
   BigButton(4,20);
   BigButton(28,20);
   BigButton(4,42);
   BigButton(28,42);
   BigButton(4,64);
   BigButton(28,64);
   UseColour(7);
   Line(3, 20, 3, 78);
   Box(52, 20, 54, 78, 7);
   UseColour(8);
   Line(55, 20, 60, 20);
   Line(55, 20, 55, 78);
   DisPlayImage(x, y);
   PutBackGround;
   Box(6, 12, 24, 18, 7);
   PrintAt(8, 13, 'FILE', 8);
   BigButton(4,20);
   BigButton(28,20);
   BigButton(4,42);
   BigButton(28,42);
   BigButton(4,64);
   BigButton(28,64);
   UseColour(7);
   Line(3, 20, 3, 78);
   Box(52, 20, 54, 78, 7);
   UseColour(8);
   Line(55, 20, 60, 20);
   Line(55, 20, 55, 78);
   GetBackGround;
   if (mX>6) and (mX<58) and (mY>25) and (mY<33) and not Done
       then   { new }
       begin
          for counter:=1 to 64000 do ImageInMem[counter]:= chr(BackGroundColor);
          DisplayImage(x, y);
          FileName:='UNTITLED';
          OldFileName:=FileName;
          Head(FileName);
          Done:=True;
       end;
       if (mX>6) and (mX<58) and (mY>33) and (mY<41) and not Done
           then   { open }
       begin
          PutBackGround;
          MsgBox('OPEN','FILENAME:');
          OkButton(164,114);
          UseColour(8);
          Line(109, 94, 240, 94);
          Line(109, 94, 109, 104);
          UseColour(15);
          Line(241, 94, 241, 104);
          Line(110, 104, 241, 104);
          Box(110, 95, 240, 103, 0);
          OldFileName:= FileName;
          FileName:='';
          FinishedAgain:=False; x2:=112;
          Counter:=1;
          GetBackGround;
          MousePointer;
          Repeat
             PutBackGround;
             PrintAt(x2, 97, '_', 15);
             GetBackGround;
             MousePointer;
             Repeat
                ShowMouse;
                if (mX>239) and (mX<249) and (mY>59) and (mY<69)
                   and LeftPressed then goto cancel;
             if (mX>163) and (mX<190) and (mY>113) and (mY<123) and LeftPressed then
             begin
                Box(x2, 97, x2+2, 101, 0);
                Delay(100);
                goto skip;
             end;
             until KeyPressed;
             Ch:=ReadKey;
             if Ch=Chr(27) then
             begin
                FileName:= OldFileName;
                goto cancel;
             end;
             if Ch=Chr(13) then
             begin
                Box(x2, 97, x2+2, 101, 0);
                FinishedAgain:=True;
             end;
             if Counter=23 then
             begin
                if Ch>Chr(31) then Ch:=Chr(0);
             end;
             if Finished = False then
             begin
                if Ch>Chr(31) then
                begin
                   FileName:=FileName+Ch;
                   PutBackGround;
                   Box(x2, 97, x2+2, 101, 0);
                   PrintAt(x2, 97, ch, 15);
                   x2:=x3;
                   GetBackGround;
                   MousePointer;
                   Counter:=Counter+1
                end;
             end;
          until FinishedAgain;
       skip:
          FinishedAgain:= False;
          for counter:= 1 to length(filename) do
          begin
             if filename[counter]= '.' then FinishedAgain:= True;
          end;
          if not FinishedAgain then
          begin
             filename:=filename+'.VGA';
             PrintAt(112, 97, FileName, 15);
          end;
          PutBackGround;
          DisplayImage(x, y);
          LoadImage(FileName);
          GetBackGround;
       cancel:
          PutBackGround;
          DisplayImage(x, y);
          GetBackGround;
          Delay(100);
          Done:=True;
       end;
       if (mX>6) and (mX<58) and (mY>41) and (mY<49) and not Done
           then   { save }
       begin
          PutBackGround;
          MsgBox('SAVE','FILENAME:');
          OkButton(164,114);
          UseColour(8);
          Line(109, 94, 240, 94);
          Line(109, 94, 109, 104);
          UseColour(15);
          Line(241, 94, 241, 104);
          Line(110, 104, 241, 104);
          Box(110, 95, 240, 103, 0);
          OldFileName:= FileName;
          FileName:='';
          FinishedAgain:=False; x2:=112;
          Counter:=1;
          GetBackGround;
          MousePointer;
          Repeat
             PutBackGround;
             PrintAt(x2, 97, '_', 15);
             GetBackGround;
             MousePointer;
             Repeat
                ShowMouse;
                if (mX>239) and (mX<249) and (mY>59) and (mY<69)
                   and LeftPressed then goto cancel2;
             if (mX>163) and (mX<190) and (mY>113) and (mY<123) and LeftPressed then
             begin
                Box(x2, 97, x2+2, 101, 0);
                Delay(100);
                goto skip2;
             end;
             until KeyPressed;
             Ch:=ReadKey;
             if Ch=Chr(27) then
             begin
                FileName:= OldFileName;
                goto cancel2;
             end;
             if Ch=Chr(13) then
             begin
                Box(x2, 97, x2+2, 101, 0);
                FinishedAgain:=True;
             end;
             if Counter=23 then
             begin
                if Ch>Chr(31) then Ch:=Chr(0);
             end;
             if Finished = False then
             begin
                if Ch>Chr(31) then
                begin
                   FileName:=FileName+Ch;
                   PutBackGround;
                   Box(x2, 97, x2+2, 101, 0);
                   PrintAt(x2, 97, ch, 15);
                   x2:=x3;
                   GetBackGround;
                   MousePointer;
                   Counter:=Counter+1
                end;
             end;
          until FinishedAgain;
       skip2:
          FinishedAgain:= False;
          for counter:= 1 to length(filename) do
          begin
             if filename[counter]= '.' then FinishedAgain:= True;
          end;
          if not FinishedAgain then
          begin
             filename:=filename+'.VGA';
             PrintAt(112, 97, FileName, 15);
          end;
          PutBackGround;
          DisplayImage(x, y);
          SaveImage(FileName);
          GetBackGround;
       cancel2:
          PutBackGround;
          DisplayImage(x, y);
          GetBackGround;
          Delay(100);
          Done:=True;
       end;
       if (mX>6) and (mX<58) and (mY>49) and (mY<57) and not Done
           then   { Load PAL }
       begin
          PutBackGround;
          MsgBox('LOAD PALETTE','FILENAME:');
          OkButton(164,114);
          UseColour(8);
          Line(109, 94, 240, 94);
          Line(109, 94, 109, 104);
          UseColour(15);
          Line(241, 94, 241, 104);
          Line(110, 104, 241, 104);
          Box(110, 95, 240, 103, 0);
          OldFileName:='';
          FinishedAgain:=False; x2:=112;
          Counter:=1;
          GetBackGround;
          MousePointer;
          Repeat
             PutBackGround;
             PrintAt(x2, 97, '_', 15);
             GetBackGround;
             MousePointer;
             Repeat
                ShowMouse;
                if (mX>239) and (mX<249) and (mY>59) and (mY<69)
                   and LeftPressed then goto cancel3;
             if (mX>163) and (mX<190) and (mY>113) and (mY<123) and LeftPressed then
             begin
                Box(x2, 97, x2+2, 101, 0);
                Delay(100);
                goto skip3;
             end;
             until KeyPressed;
             Ch:=ReadKey;
             if Ch=Chr(27) then goto cancel3;
             if Ch=Chr(13) then
             begin
                Box(x2, 97, x2+2, 101, 0);
                FinishedAgain:=True;
             end;
             if Counter=23 then
             begin
                if Ch>Chr(31) then Ch:=Chr(0);
             end;
             if Finished = False then
             begin
                if Ch>Chr(31) then
                begin
                   OldFileName:=OldFileName+Ch;
                   PutBackGround;
                   Box(x2, 97, x2+2, 101, 0);
                   PrintAt(x2, 97, ch, 15);
                   x2:=x3;
                   GetBackGround;
                   MousePointer;
                   Counter:=Counter+1
                end;
             end;
          until FinishedAgain;
       skip3:
          FinishedAgain:= False;
          for counter:= 1 to length(OldFilename) do
          begin
             if OldFilename[counter]= '.' then FinishedAgain:= True;
          end;
          if not FinishedAgain then
          begin
             OldFilename:=OldFilename+'.PAL';
             PrintAt(112, 97, OldFileName, 15);
          end;
          PutBackGround;
          DisplayImage(x, y);
          LoadPal(OldFileName);
          GetBackGround;
       cancel3:
          PutBackGround;
          DisplayImage(x, y);
          GetBackGround;
          Delay(100);
          Done:=True;
       end;
       if (mX>6) and (mX<58) and (mY>57) and (mY<65) and not Done
           then   { Save PAL }
       begin
          PutBackGround;
          MsgBox('SAVE PALETTE','FILENAME:');
          OkButton(164,114);
          UseColour(8);
          Line(109, 94, 240, 94);
          Line(109, 94, 109, 104);
          UseColour(15);
          Line(241, 94, 241, 104);
          Line(110, 104, 241, 104);
          Box(110, 95, 240, 103, 0);
          OldFileName:='';
          FinishedAgain:=False; x2:=112;
          Counter:=1;
          GetBackGround;
          MousePointer;
          Repeat
             PutBackGround;
             PrintAt(x2, 97, '_', 15);
             GetBackGround;
             MousePointer;
             Repeat
                ShowMouse;
                if (mX>239) and (mX<249) and (mY>59) and (mY<69)

                   and LeftPressed then goto cancel4;
             if (mX>163) and (mX<190) and (mY>113) and (mY<123) and LeftPressed then
             begin
                Box(x2, 97, x2+2, 101, 0);
                Delay(100);
                goto skip4;
             end;
             until KeyPressed;
             Ch:=ReadKey;
             if Ch=Chr(27) then goto cancel4;
             if Ch=Chr(13) then
             begin
                Box(x2, 97, x2+2, 101, 0);
                FinishedAgain:=True;
             end;
             if Counter=23 then
             begin
                if Ch>Chr(31) then Ch:=Chr(0);
             end;
             if Finished = False then
             begin
                if Ch>Chr(31) then
                begin
                   OldFileName:=OldFileName+Ch;
                   PutBackGround;
                   Box(x2, 97, x2+2, 101, 0);
                   PrintAt(x2, 97, ch, 15);
                   x2:=x3;
                   GetBackGround;
                   MousePointer;
                   Counter:=Counter+1
                end;
             end;
          until FinishedAgain;
       skip4:
          FinishedAgain:= False;
          for counter:= 1 to length(OldFilename) do
          begin
             if OldFilename[counter]= '.' then FinishedAgain:= True;
          end;
          if not FinishedAgain then
          begin
             OldFilename:=OldFilename+'.PAL';
             PrintAt(112, 97, OldFileName, 15);
          end;
          PutBackGround;
          DisplayImage(x, y);
          SavePal(OldFileName);
          GetBackGround;
       cancel4:
          PutBackGround;
          DisplayImage(x, y);
          GetBackGround;
          Delay(100);
          Done:=True;
       end;
       if (mX>6) and (mX<58) and (mY>65) and (mY<73) and not Done
           then Confirmation;
    MousePointer;
end;

begin
   if not MouseInstalled then
   begin
      writeln('This program requires a Microsoft or compatable mouse.');
      halt;
   end;
   x:= 0; y:= 0; Col:= 0; ForeGroundColor:=15; BackGroundColor:=0;
   InitDesktop;
   for counter:= 1 to 64000 do ImageInMem[counter]:=chr(BackGroundColor);
   DisplayImage(x, y);
   About;
   FileName:=('UNTITLED');
   OldFileName:=FileName;
   if ParamStr(1) <>'' then
   begin
      FileName:=ParamStr(1);
      FinishedAgain:= False;
      for counter:= 1 to length(FileName) do
      begin
         if FileName[counter]= '.' then FinishedAgain:= True;
      end;
      case FinishedAgain of
         True  : LoadImage(ParamStr(1));
         False : LoadImage(ParamStr(1)+ '.VGA');
      end;
   end else Head(FileName);
   DisplayImage(x, y);
   InitMouse;
   Finished:=False;
   While not Finished do
   begin
      ShowMouse;
      if KeyPressed then
      begin
         ch:= ReadKey;
         if ch=#27 then Confirmation;
      end;
      if LeftPressed then
      begin
         if (mX>5) and (mX<25) and (mY>11) and (mY<19) then FileMenu;
         if (mX>55) and (mX<308) and (mY>20) and (mY<177) and (LeftPressed) then
         begin
            PutPixel(mX, mY, BackGround[1, 1]);
            ImageInMem[(mX-55+x)+ (mY-21+y)* 320]:= chr(ForeGroundColor);
            PutPixel(mX, mY, ForeGroundColor);
            BackGround[1, 1]:=GetPixel(mX, mY);
            MousePointer;
         end;
         if (mX>307) and (mX<316) and (mY>19) and (mY<29) then
         begin
            y:= y-1;
            if y<0 then y:=0;
            DisplayImage(x, y);
         end;
         if (mX>307) and (mX<316) and (mY>167) and (mY<177) then
         begin
            y:= y+1;
            if y>44 then y:=44;
            DisplayImage(x, y);
         end;
         if (mX>54) and (mX<63) and (mY>176) and (mY<186) then
         begin
            x:= x-1;
            if x<0 then x:=0;
            DisplayImage(x, y);
         end;
         if (mX>298) and (mX<307) and (mY>176) and (mY<186) then
         begin
            x:= x+1;
            if x>68 then x:=68;
            DisplayImage(x, y);
         end;
         if (mX>54) and (mX<64) and (mY>187) and (mY<197) then
         begin
            Col:= Col-1;
            if Col< 0 then Col:=0;
            InitColorBar;
         end;
         if (mX>303) and (mX<313) and (mY>187) and (mY<197) then
         begin
            Col:= Col+1;
            if Col> 232 then Col:=232;
            InitColorBar;
         end;
         if (mX>63) and (mX<304) and (mY>187) and (mY<197) then
         begin
            PutBackGround;
            ForeGroundColor:=GetPixel(mX, mY);
            PickColor;
            MousePointer;
         end;
         if (mX>308) and (mX<318) and (mY>0) and (mY<10) then
         begin
            Confirmation;
         end;
      end;
      if RightPressed then
      begin
         if (mX>63) and (mX<304) and (mY>187) and (mY<197) then
         begin
            PutBackGround;
            BackGroundColor:=GetPixel(mX, mY);
            PickColor;
            MousePointer;
         end;
         if (mX>55) and (mX<308) and (mY>20) and (mY<177) and (RightPressed) then
         begin
            PutBackGround;
            ImageInMem[(mX-55+x)+ (mY-21+y)* 320]:= chr(BackGroundColor);
            PutPixel(mX, mY, BackGroundColor);
            GetBackGround;
            MousePointer;
         end;
      end;
   end;
   MouseSenseTivity(50, 50);
   TextMode(LastMode);
end.