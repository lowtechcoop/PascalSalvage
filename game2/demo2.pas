Program Demo2;

{ SPX library - Sprite demo  Copyright 1993 Scott D. Ramsay  }

Uses SPX_VGA,SPX_KEY,SPX_OBJ,SPX_IMG,SPX_SND,SPX_TXT,SPX_FNC;

const
  path = '';
  max  = 10;
  framerate  : integer = 20;    { NOT in fps! }

type
  putmode = (draw,erase,update);
  Pballs = ^Tballs;
  Tballs = object(Tobjs)
             width,height,              { dimension of sprite }
             kind,                      { sprite number }
             ox,oy,                     { old position }
             x,y,                       { new position }
             dx,dy : integer;           { direction }
             constructor init(nx,ny,k:integer);
             procedure drawitemobject;virtual;
             procedure eraseitemobject;virtual;
             procedure updateitemobject;virtual;
             procedure calcitemobject;virtual;
           end;

var
  balls : array[0..2] of pointer;
  pal   : RGBlist;
  head,
  tail  : plist;

procedure setup;
var
  p : plist;
  d : integer;
begin
  openmode(3);
  randomize;
  setpageactive(3);
  loadpcx(path+'tank.pcx');
  loadvsp(path+'balls.vsp',balls);
  loadcolors(path+'balls.pal',pal,256);
  head := nil; tail := nil;
  for d := 1 to max do
    begin
      new(p);
      p^.item := new(Pballs,init(random(320),random(200),d mod 3));
      p^.item^.powner := p;
      addp(head,tail,p);
    end;
  fsetcolors(zdc);  { all black palette }
  pcopy(3,2);       { copy to work page }
  pcopy(3,1);       { copy to visual }
  fadein(40,pal);
end;


procedure placespeed(mode:putmode);
begin
  case mode of
    draw   : putletter(4,4,255,st(framerate));
    erase  : CopyRect(4,4,50,11,pages[3]^,pages[2]^);
    update : CopyRect(4,4,50,11,pages[2]^,pages[1]^);
  end;
end;


procedure placeballs(var head:plist;mode:putmode);
var
  p : plist;
begin
  p := head;
  while p<>nil do
    begin
      case mode of
        draw   : p^.item^.drawitemobject;
        erase  : pballs(p^.item)^.eraseitemobject;
        update : pballs(p^.item)^.updateitemobject;
      end;
      p := p^.next;
    end;
end;


procedure animate;
var
  p : pointer;
begin
  setpageactive(2);
  setrate(1000);
  repeat
    f_clk[0] := framerate;
    if plus and (framerate<60)
      then inc(framerate)
      else
        if minus and (framerate>0)
          then dec(framerate);
    placeballs(head,erase);
    placespeed(erase);
    if not space
      then calcitems(head);
    placeballs(head,draw);
    placespeed(draw);
    placeballs(head,update);
    placespeed(update);
    repeat until (f_clk[0]=0);
  until esc;
end;

(**) { Tballs methods }

constructor Tballs.init(nx,ny,k:integer);
begin
  Tobjs.init;
  kind := k;
  x := nx; y := ny; 
  ox := x; oy := y;
  repeat
    dx := random(7)-3;
    dy := random(7)-3;
  until (dx<>0) and (dy<>0);
  imagedims(balls[kind]^,width,height);
end;


procedure Tballs.eraseitemobject;
begin
  CopyRect(ox-width shr 1,oy-height shr 1,ox+width shr 1,oy+height shr 1,pages[3]^,pages[2]^);
  CopyRect(x-width shr 1,y-height shr 1,x+width shr 1,y+height shr 1,pages[3]^,pages[2]^);
end;


procedure Tballs.updateitemobject;
begin
  CopyRect(ox-width shr 1,oy-height shr 1,ox+width shr 1,oy+height shr 1,pages[2]^,pages[1]^);
  CopyRect(x-width shr 1,y-height shr 1,x+width shr 1,y+height shr 1,pages[2]^,pages[1]^);
end;


procedure Tballs.drawitemobject;
begin
  ftput_clip(x,y,balls[kind]^,true);
end;


procedure Tballs.calcitemobject;
begin
  ox := x; oy := y;
  inc(x,dx); inc(y,dy);
  if (x<0) or (x>319)
    then dx := -dx;
  if (y<0) or (y>199)
    then dy := -dy;
end;


procedure showit;
begin
   writeln('SPX library - Sprite demo');
   writeln('Copyright 1993 Scott D. Ramsay');
   writeln;
   writeln('Keys:');
   writeln(' ESC          - quit demo');
   writeln(' +/-          - change frame speed');
   writeln(' SPACE        - pause ');
   writeln;
   write('Press any key.');
   clearbuffer;
   repeat until anykey;
end;


begin
  showit;
  setup;
  animate;
  clean_plist(head,tail);
  closemode;
end.