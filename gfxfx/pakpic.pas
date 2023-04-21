
{$i-}
program packpicture;
{ pack picture to file - use 'displaypackedpic' to unpack - by Bas van Gaalen }
uses dos;
const
  zero : byte = 0;
var
  infile,outfile : file of byte;
  infname,outfname : pathstr;
  fp : longint;
  num : word;
  prevbyte : integer;
  inbyte,tbyte : byte;

begin
  { file i/o }
  if paramstr(1) = '' then begin
    write(' infile: '); readln(infname); end else infname := paramstr(1);
  assign(infile,infname);
  reset(infile);
  if ioresult <> 0 then begin
    writeln('error opening ',infname); halt; end;
  if paramstr(2) = '' then begin
    write('outfile: '); readln(outfname); end else outfname := paramstr(2);
  assign(outfile,outfname);
  rewrite(outfile);
  if ioresult <> 0 then begin
    writeln('error creating ',outfname); halt; end;

  { copy palette }
  seek(infile,$20); { place filepointer after header! }
  for num := 0 to 767 do begin
    read(infile,inbyte);
    write(outfile,inbyte);
  end;

  { read'n'pack }
  seek(infile,$320); { place filepointer after header and palette! }
  fp := filesize(infile)-filepos(infile); prevbyte := -1;
  writeln; write(#13,fp:6);
  while not eof(infile) do begin
    read(infile,inbyte);
    if prevbyte = inbyte then begin
      seek(outfile,filepos(outfile)-1);
      num := 1;
      while (prevbyte = inbyte) and (not eof(infile)) do begin
        read(infile,inbyte);
        inc(num);
      end;
      write(outfile,zero);
      tbyte := lo(prevbyte); write(outfile,tbyte);
      tbyte := lo(num); write(outfile,tbyte);
      tbyte := hi(num); write(outfile,tbyte);
      if not eof(infile) then write(outfile,inbyte);
      dec(fp,num); write(#13,fp:6);
      prevbyte := inbyte;
    end
    else begin
      if prevbyte = 0 then begin
        tbyte := 0; write(outfile,tbyte);
        tbyte := 1; write(outfile,tbyte);
        tbyte := 0; write(outfile,tbyte);
      end;
      write(outfile,inbyte);
      dec(fp);
      prevbyte := inbyte;
    end;
  end;
  close(infile);
  close(outfile);
end.
