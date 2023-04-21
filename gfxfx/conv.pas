
program FileConverter;
{ Convert binairy file to textfile, by Bas van Gaalen, Holland, PD }
uses dos;
const BufSize = 1024;
var
  InFile : file;
  OutFile : text;
  Buffer : array[0..BufSize-1] of byte;
  FileName : pathstr;
  I,NofRead : integer;

begin
  writeln;
  FileName := paramstr(1); if FileName = '' then begin
    writeln('Enter filename on commandline...');
    halt(1);
  end;
  assign(InFile,FileName);
  {$I-} reset(InFile,1); {$I+}
  if ioresult <> 0 then begin
    writeln('Error opening file ',FileName);
    halt(1);
  end;

  assign(OutFile,'OUTFILE1.DAT');
  rewrite(OutFile);

  repeat
    blockread(InFile,Buffer,BufSize,NofRead);
    for I := 0 to NofRead-1 do begin
      if I mod 16 = 15 then writeln(OutFile);
      write(OutFile,Buffer[I],',');
    end;
  until NofRead < BufSize;

  close(InFile);
  close(OutFile);
end.
