{Example1: Plotting a pixel}
program example1;
uses vesalib,crt;

procedure test_640x480x8bpp;
var x,y:word;
begin
 if not ModeIsAvailable(_640x480x8bpp) then
  begin
   writeln('640x480x8bpp is not available');
   exit
  end;
 SetupMode(_640x480x8bpp);
 for x:=0 to 63 do
  setrgbpalette(x,x,x,x);
 for x:=0 to 63 do
  setrgbpalette(64+x,63-x,63-x,63);
 for x:=0 to 63 do
  setrgbpalette(128+x,x,0,63-x);
 for x:=0 to 63 do
  setrgbpalette(192+x,63-x,0,0);
 for y:=0 to 255 do
  for x:=0 to 255 do
   putpixel(x,y,x*y div (y shr 1+x shr 1+1));
 readkey;
 Textmode(co80)
end;

procedure test_640x480x24bpp;
var x,y:word;
begin
 if not ModeIsAvailable(_640x480x24bpp) then
  begin
   writeln('640x480x24bpp is not available');
   exit
  end;
 SetupMode(_640x480x24bpp);
 for y:=0 to 255 do
  for x:=0 to 255 do
   putpixel24(x,y,x,y,255-x); {BGR?}
 readkey;
 textmode(co80)
end;

begin
 if IsVesaInstalled<>VESA_Ok then
  begin
   writeln('No VESA driver installed');
   halt
  end;
 Test_640x480x8bpp;
 Test_640x480x24bpp
end.