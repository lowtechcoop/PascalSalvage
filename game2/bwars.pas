program test;

uses SPX_VGA,SPX_KEY,SPX_GEO,SPX_TXT,SPX_FNC,SPX_IMG,RobMouse;

const
  path  = '';
  gmx   = 100;                   { tile map size }
  gmy   = 50;
  gsx   = 16;                    { tile size }
  gsy   = 16;
  smx   = gmx*gsx;               { tile map size in pixels }
  smy   = gmy*gsy;
  speed : integer = 4;

type
  PMyMorph = ^TMyMorph;
  TMyMorph = object(TMorph)
               function geomap(x,y:integer):integer;virtual;
               procedure placegeo(x,y,geonum:integer);virtual;
               procedure nogogeo(x,y:integer); virtual;
             end;

var
  MyMorph : PMyMorph;
  gpic    : array[0..143] of pointer;
  map     : array[0..gmy-1,0..gmx-1] of byte;
  pal     : RGBlist;
  flip,
  geo_cnt,
  x,y     : integer;

procedure setup;
begin
  openmode(2);
  MouseWindow(144, 96, 1456, 728);
  MyMorph := new(PMyMorph,init(gmx,gmy,19,12,16,16));
  setpageactive(2);
  geo_cnt := loadgmp(path+'bwars.gmp',gpic,map);
  loadcolors(path+'bwars.pal',pal,256);
  fsetcolors(zdc);
  x := 944; y := 728;
  MyMorph^.drawmap(x,y);
  copyRect(16,16,303,183,pages[2]^,pages[1]^);
  fadein(40,pal);
end;


procedure changexy;
begin
  if np[7,2] or np[8,2] or np[9,2]
    then dec(y,speed)
    else
      if np[1,2] or np[2,2] or np[3,2]
        then inc(y,speed);
  if np[7,2] or np[4,2] or np[1,2]
    then dec(x,speed)
    else
      if np[9,2] or np[6,2] or np[3,2]
        then inc(x,speed);
  if ch in ['1'..'9']
    then speed := vl(ch);
  ifix(x,0,smx-1); ifix(y,0,smy-1);
end;

procedure Animate;
begin
  flip := 0;
  repeat
     flip := (flip+1) mod 6;
     x:=MouseX;
     y:=MouseY;
     MyMorph^.drawmap(x,y);
     putletter(25,20,0,st(x)+','+st(y));
     putletter(24,19,1,st(x)+','+st(y));
     pset(160,100,1);
     pset(161,101,0);
     copyRect(16,16,303,183,pages[2]^,pages[1]^);
  until esc;
end;


function TMyMorph.geomap(x,y:integer):integer;
begin
  geomap := map[y,x];
end;


procedure TMyMorph.nogogeo(x,y:integer);
begin
  fput(x,y,gpic[0]^,false);
end;


procedure TMyMorph.placegeo(x,y,geonum:integer);
begin
  if geonum in [1..geo_cnt]
    then
      if geonum=13
        then fput(x,y,gpic[12+flip]^,false)
        else fput(x,y,gpic[geonum-1]^,false);
end;

begin
  setup;
  Animate;
  FadeOut(40,pal);
  dispose(MyMorph,done);
  closemode;
end.