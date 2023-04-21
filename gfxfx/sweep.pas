
program screensweep;
{ Screen sweep, place some mess first, by Bas van Gaalen, Holland, PD }
uses crt;
const vseg : word = $b800; fillchar = 32;
var i,maxx,maxy : integer;

procedure retrace;
begin
  while (port[$3da] and 8) <> 0 do;
  while (port[$3da] and 8) = 0 do;
end;

procedure plot(x,y : integer); begin
  mem[vseg:y*160+x+x] := fillchar; end;

procedure line(x,y,x2,y2 : integer);
var d,dx,dy,ai,bi,xi,yi : integer;
begin
  if x < x2 then begin xi := 1; dx := x2-x; end
  else begin xi := -1; dx := x-x2; end;
  if y < y2 then begin yi := 1; dy := y2-y; end
  else begin yi := -1; dy := y-y2; end;
  plot(x,y);
  if dx > dy then begin
    ai := (dy-dx)*2; bi := dy*2; d := bi-dx;
    repeat
      if d >= 0 then begin inc(y,yi); inc(d,ai); end else inc(d,bi);
      inc(x,xi); plot(x,y);
    until x = x2;
  end
  else begin
    ai := (dx-dy)*2; bi := dx*2; d := bi-dy;
    repeat
      if d >= 0 then begin inc(x,xi); inc(d,ai); end else inc(d,bi);
      inc(y,yi); plot(x,y);
    until y = y2;
  end;
end;

begin
  if lastmode = 7 then vseg := $b000;
  maxx := lo(windmax); maxy := hi(windmax);
  for i := 0 to maxx do begin retrace; line(maxx div 2,maxy div 2,i,0); end;
  for i := 0 to maxy do begin retrace; line(maxx div 2,maxy div 2,maxx,i); end;
  for i := maxx downto 0 do begin retrace; line(maxx div 2,maxy div 2,i,maxy); end;
  for i := maxy downto 0 do begin retrace; line(maxx div 2,maxy div 2,0,i); end;
end.
