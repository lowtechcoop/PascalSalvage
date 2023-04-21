
program testfastmath;
{ Test of fastmath unit (by Bas van Gaalen) }
uses fastmath,dos;
const max = 10000;
var t : longint; i,h,m,s,hs : word;
begin
  gettime(h,m,s,hs); t := hs+s*100+m*6000;
  for i := 0 to round(2*pi*max) do
    write(#13,cos(i/max):6:3);
  gettime(h,m,s,hs); t := (hs+s*100+m*6000)-t;
  writeln;
  writeln(t);
  writeln;
  readln;
end.
