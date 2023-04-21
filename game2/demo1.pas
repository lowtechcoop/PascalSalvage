Program Demo1;

{ SPX library - Parallax demo  Copyright 1993 Scott D. Ramsay  }

Uses SPX_VGA,SPX_EFF,SPX_KEY,SPX_IMG;

const
  path = '';

type
  PMyCycle = ^TmyCycle;
  TMyCycle = object(TCycle)
               procedure cycle_move; virtual;
             end;

var
  MyCycle : PMyCycle;
  nsize   : integer;

procedure setup;
begin
  openmode(2);
  setpageactive(2);
  loadpcx(path+'fire.pcx');
  fsetcolors(rgb256);
  nsize := 30;
  MyCycle := new(PMyCycle,init(50,nsize));
end;


procedure animate;
begin
  repeat
    if minus and (nsize>0)
      then
        begin
          dec(nsize);
          MyCycle^.changewave(50,nsize);
        end
      else
    if plus and (nsize<100)
      then
        begin
          inc(nsize);
          MyCycle^.changewave(50,nsize);
        end;
    if space
      then MyCycle^.docycle(2,1,1)
      else MyCycle^.docycle(2,1,2);
  until esc;
  fadeout(40,rgb256);
end;

(**) { TCycle Methods }

procedure TMyCycle.cycle_move;
begin
  if np[6,2] or np[9,2] or np[3,2]
    then cyclex := (cyclex+1) mod 320
    else
      if np[4,2] or np[7,2] or np[1,2]
        then cyclex := (cyclex+319) mod 320;
  if np[8,2] or np[7,2] or np[9,2]
    then cycley := (cycley+1) mod 200
    else
      if np[1,2] or np[2,2] or np[3,2]
        then cycley := (cycley+199) mod 200;
end;


procedure showit;
begin
   writeln('SPX library - Parallax demo');
   writeln('Copyright 1993 Scott D. Ramsay');
   writeln;
   writeln('Keys:');
   writeln(' ESC          - quit demo');
   writeln(' Arrow keys   - scroll background');
   writeln(' +/-          - change amplitude');
   writeln(' SPACE        - Still background');
   writeln;
   write('Press any key.');
   clearbuffer;
   repeat until anykey;
end;


begin
  showit;
  setup;
  animate;
  dispose(MyCycle,done);
  closemode;
end.