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

 for y:=0 to 640 do
  for x:=0 to 480 do
   putpixel(x,y,640-x);
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

 for y:=0 to 640 do
  for x:=0 to 280 do
   putpixel24(x,y,0,0,213); {BGR?}
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