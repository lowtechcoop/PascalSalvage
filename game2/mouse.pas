Unit Mouse;

Interface

Uses dos;

const
   visible     : boolean = false;
   mousehere   : boolean = false;
   mousewason  : boolean = false;
   mouseoncall : boolean = false;
   skl         : integer = 1;
   mseshp      : array[0..31] of word =
                 ($1fff,$0fff,$07ff,$03ff,$07ff,$03ff,$e7ff,$ffff,
                  $ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,
                  $0000,$4000,$6000,$7000,$6000,$1000,$0000,$0000,
                  $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000);


var
   m1,m2,m3,m4 : integer;

procedure mset(var m1,m2,m3,m4:integer);
function mousereset:integer;
procedure mouseon;
procedure mouseoff;
procedure getmouse(var m2,m3,m4:integer);
procedure setmouse(m3,m4:integer);
procedure getmousepresses(var m2,m3,m4:integer);
procedure getmousereleases(var m2,m3,m4:integer);
procedure getmousemotion(var m3,m4:integer);
procedure setmousecursor(m2,m3:integer; var mask);
procedure setmouseratio(m3,m4:integer);
procedure setmouseoff(x1,y1,x2,y2:integer);
procedure cleanmouse;
procedure chkmouseon;
procedure setdefptr;
procedure normalizemx;

Implementation

var
   legal : boolean;


procedure setdefptr;
begin
   setmousecursor(0,0,mseshp);
end;


procedure mset;
var
   reg : registers;
begin
   if not legal
      then exit;
   with reg do
      begin
         ax := m1;
         bx := m2;
         cx := m3;
         dx := m4;
         intr($33,reg);
         m1 := ax;
         m2 := bx;
         m3 := cx;
         m4 := dx;
      end;
end;


procedure setmousecursor;
var
   reg : registers;
begin
   m1 := 9;
   m4 := ofs(mask);
   reg.es := seg(mask);
   with reg do
      begin
         ax := m1;
         bx := m2;
         cx := m3;
         dx := m4;
         intr($33,reg);
         m1 := ax;
         m2 := bx;
         m3 := cx;
         m4 := dx;
      end;
end;


function mousereset;
var
  x : integer;
begin
   m1 := 0; legal := true;
   mset(m1,m2,m3,m4);
   mousehere := (m1<>0);
   if m1=0
      then mousereset := 0
      else mousereset := m2;
   legal := mousehere;
end;


procedure mouseon;
begin
   mouseoncall := true;
   if not visible and mousehere
      then
         begin
            m1 := 1;
            mset(m1,m2,m3,m4);
            visible := true;
         end;
end;


procedure chkmouseon;
begin
   if mousewason
      then
         begin
            mousewason := false;
            mouseon;
         end;
end;


procedure mouseoff;
begin
  mouseoncall := false;
   if visible and mousehere
      then
         begin
            m1 := 2;
            mset(m1,m2,m3,m4);
            visible := false;
            mousewason := true;
         end;
end;


procedure getmouse;
begin
   m1 := 3;
   mset(m1,m2,m3,m4);
   if not mousehere
      then m2 := 0;
end;


procedure setmouse;
begin
   m1 := 4;
   mset(m1,m2,m3,m4);
end;


procedure getmousepresses;
begin
   m1 := 5;
   mset(m1,m2,m3,m4);
end;


procedure getmousereleases;
begin
   m1 := 6;
   mset(m1,m2,m3,m4);
end;


procedure getmousemotion;
begin
   m1 := 11;
   mset(m1,m2,m3,m4);
end;


procedure cleanmouse;
begin
   if not mousehere
      then exit
      else
        begin
         repeat
            getmouse(m2,m3,m4);
         until m2 and 3=0;
         m2 := 0;
        end;
end;


procedure setmouseratio;
begin
   m1 := 15;
   mset(m1,m2,m3,m4);
end;


procedure setmouseoff(x1,y1,x2,y2:integer);
begin
  asm
    mov   ax,0010h
    mov   cx,x1
    mov   dx,y1
    mov   si,x2
    mov   di,y2
    int 33h
  end;
end;


procedure normalizemx; { for mode $13 }
begin
  getmouse(m2,m3,m4); skl := m3 div 160;
end;


begin
   legal := false;
end.