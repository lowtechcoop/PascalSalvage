program R3D;

uses SPX_VGA,SPX_KEY,SPX_OBJ,SPX_T3D,SPX_SND;

const
  pbeg : plist = nil;
  pend : plist = nil;

type
  Ppoint = ^Tpoint;
  Tpoint = object(Tobjs)
             x,y,z : integer;
             constructor init(nx,ny,nz:integer);
           end;

var
  oldexit   : pointer;
  d,m,r     : integer;

procedure cleanup;far;
begin
  clean_plist(pbeg,pend);
  closemode;
  exitproc := oldexit;
end;

procedure setup;
begin
  setrate(8192);
  openmode(2); randomize;
  oldexit := exitproc; exitproc := @cleanup;
end;

procedure setlevel;
const
  lv1 : array[0..8,0..1] of integer =
        ((-3,-5),(3,-5),(5,-3),(5,3),(3,5),(-3,5),(-5,3),(-5,-3),(-3,-5));
var
  p : plist;
  d,e : integer;
begin
  for d := 0 to 8 do
    begin
      new(p);
      p^.item := new(ppoint,init(lv1[d,0]*10,lv1[d,1]*10,0));
      p^.item^.powner := p;
      addp(pbeg,pend,p);
    end;
end;

procedure drawlist(c:integer);
var
  nx,ny,nz,
  ox,oy,oz : integer;
  p        : plist;
begin
  p := pbeg;
  while p<>nil do
    with ppoint(p^.item)^ do
      begin
        nx := x; ny := y; nz := z;
        rotate256xyz(nx,ny,nz,0,0,r);
        if p<>pbeg
          then
            begin
              line3D(ox,oy,100+m,nx,ny,100+m,c,true);
              line3D(ox,oy,-200+m,nx,ny,-200+m,c,true);
              line3D(nx,ny,100+m,nx,ny,-200+m,c,true);
            end;
        ox := nx; oy := ny; oz := nz;
        p := p^.next;
      end;
end;

procedure getkey;
begin
  if plus
    then r := (r+1)mod 256
    else
     if minus
       then r := (r+255)mod 256;
  if np[4,2] and (xv>-300)
    then dec(xv,5)
    else
      if np[6,2] and (xv<300)
        then inc(xv,5);
  if np[4,1] and (m>-200)
    then dec(m,5)
    else
      if np[6,1] and (m<135)
        then inc(m,5);
  if np[8,2] and (yv>-300)
    then dec(yv,5)
    else
      if np[2,2] and (yv<300)
        then inc(yv,5);
end;

procedure drawall(draw:boolean);
begin
  for d := -200 to 200 do line3d(d*10,20,200,d*10,20,-200,ord(draw),true);
  for d:=-20 to 20 do line3d(20,20,d*10,200,20,d*10,ord(draw),true);
  {drawlist(12*ord(draw));}
end;

procedure Animate;
begin
  setlevel; zv := 300; m := 0; r := 0;
  setrate(1000);
  repeat
    f_clk[0] := 20;
    SetPageActive(2);
    drawall(false);
    getkey;
    drawall(true);
    SetPageActive(1);
    CopyRect(0, 0, 319, 199, Pages[2]^, Pages[1]^);
    repeat until f_clk[0]=0;
  until esc;
end;

constructor tpoint.init(nx,ny,nz:integer);
begin
  inherited init;
  x := nx; y := ny; z := nz;
end;

begin
  setup;
  Animate;
  ClearBuffer;
end.