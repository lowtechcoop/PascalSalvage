{$M $4000,0,0 }
program litestep;

uses crt,dos;
var
  F: Text;
  Ch: Char;
begin
  { Get file to read from command line }
  Assign(F, 'c:\win95\blair.dat');
  Reset(F);
  Read(F, Ch);
write(ch);
if ch='L' then
  begin
write('im working');
  swapvectors;
  exec('c:\lite.bat','');
  swapvectors;
  end
else
 begin
 swapvectors;
  exec('c:\rob.bat','');
  swapvectors;

end;



close(f)

end.
