Program Demo3;

{ SPX library - Palette demo Copyright 1993 Scott D. Ramsay  }

Uses SPX_VGA,SPX_KEY,SPX_IMG,SPX_SND;

const
  path = '';

var
  pal     : array[0..1] of RGBlist;
  col     : RGBtype;
  next    : byte;
  oldexit : pointer;

procedure stall(seconds:integer);
begin
  s_clk[0] := seconds*18;
  repeat
    if esc
      then halt;
  until s_clk[0]=0;
end;


procedure cleanup;far;
var
  temp : rgblist;
begin
  fgetcolors(temp);
  fadeout(20,temp);
  closemode;
  exitproc := oldexit;
end;


procedure setup;
begin
  setrate(2000);
  openmode(3);
  oldexit := exitproc; exitproc := @cleanup;
  fsetcolors(zdc);   { all black palette }
  setpageactive(3);
  loadpcx(path+'fire.pcx');
  pal[1] := rgb256;
  setpageactive(2);
  loadpcx(path+'tank.pcx');
  pal[0] := rgb256;
  next := 2;
end;


function sequence(b:integer):integer;
var
  temp : RGBlist;
  c    : integer;
begin
  sequence := 0;
  case b of
    0 : begin
          pcopy(next,1);
          fadein(60,pal[next-2]);
          sequence := 2;
        end;
    1 : begin
          col.red := 63; col.green := 63; col.blue := 63;
          temp := pal[next-2];
          colorschange(temp,col);
          fsetcolors(temp);
          sequence := 1;
        end;
    2 : begin
          col.red := 63; col.green := 0; col.blue := 0;
          temp := pal[next-2];
          colorschange(temp,col);
          fsetcolors(temp);
          sequence := 1;
        end;
    3 : begin
          col.red := 0; col.green := 63; col.blue := 0;
          temp := pal[next-2];
          colorschange(temp,col);
          fsetcolors(temp);
          sequence := 1;
        end;
    4 : begin
          col.red := 0; col.green := 0; col.blue := 63;
          temp := pal[next-2];
          colorschange(temp,col);
          fsetcolors(temp);
          sequence := 1;
        end;
    5 : begin
          col.red := 63; col.green := 40; col.blue := 10;
          temp := pal[next-2];
          colorschange(temp,col);
          fsetcolors(temp);
          sequence := 1;
        end;
    6 : begin
          fsetcolors(pal[next-2]);
          sequence := 2;
        end;
    7 : begin
          temp := pal[next-2];
          for c := 0 to 255 do
            begin
              if esc
                then halt;
              ColorCycle(temp,0,256,true);
              fsetcolors(temp);
              f_clk[0] := 10; repeat until f_clk[0]=0;
            end;
        end;
    8 : begin
          temp := pal[next-2];
          fsetcolors(temp);
          stall(2);
          for c := 0 to 500 do
            begin
              if esc
                then halt;
              ColorCycle(temp,192,63,false);
              fsetcolors(temp);
              f_clk[0] := 10; repeat until f_clk[0]=0;
            end;
          sequence := 2;
        end;
    9 : fadeout(30,pal[next-2]);
  end;
end;


procedure Animate;
var
  step : integer;
begin
  step := 0;
  repeat
    stall(sequence(step));
    step := (step+1)mod 10;
    if step=0
      then next := 5-next;
  until esc;
end;


procedure showit;
begin
   writeln('SPX library - Palette demo');
   writeln('Copyright 1993 Scott D. Ramsay');
   writeln;
   writeln('Keys:');
   writeln(' ESC          - quit demo');
   writeln;
   write('Press any key.');
   clearbuffer;
   repeat until anykey;
end;


begin
  showit;
  setup;
  Animate;
end.