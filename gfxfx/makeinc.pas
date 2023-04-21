
{$i-,v-}
program makepicincludefile;
{ Makes include-file from raw-picture format (pal at 0, data at $300),
  by Bas van Gaalen, Holland, PD }
uses dos;
type str10 = string[10];
var
  infile : file;
  outfile : text;
  buffer : array[0..1023] of byte;
  infname,outfname : pathstr;
  tmpstr : string;
  nofread,i : word;

function tostr(src : byte) : str10; var tmp : str10; begin
  str(src,tmp); tostr := tmp; end;

begin
  { file i/o }
  if paramstr(1) = '' then begin
    write(' infile: '); readln(infname); end else infname := paramstr(1);
  assign(infile,infname);
  reset(infile,1);
  if ioresult <> 0 then begin
    writeln('error opening ',infname); halt; end;
  if paramstr(2) = '' then begin
    write('outfile: '); readln(outfname); end else outfname := paramstr(2);
  assign(outfile,outfname);
  rewrite(outfile);
  if ioresult <> 0 then begin
    writeln('error creating ',outfname); halt; end;

  writeln(outfile,'  pal : array[0..767] of byte = (');
  tmpstr := '    ';
  blockread(infile,buffer,768);
  for i := 0 to 767 do begin
    tmpstr := tmpstr+tostr(buffer[i])+',';
    if length(tmpstr) > 70 then begin
      writeln(outfile,tmpstr);
      tmpstr := '    ';
    end;
  end;
  delete(tmpstr,length(tmpstr),1);
  writeln(outfile,tmpstr,');');
  writeln(outfile);

  writeln(outfile,'  pic : array[0..',filesize(infile)-769,'] of byte = (');
  tmpstr := '    ';
  repeat
    blockread(infile,buffer,sizeof(buffer),nofread);
    for i := 0 to nofread-1 do begin
      tmpstr := tmpstr+tostr(buffer[i])+',';
      if length(tmpstr) > 70 then begin
        writeln(outfile,tmpstr);
        tmpstr := '    ';
      end;
    end;
  until nofread < sizeof(buffer);
  delete(tmpstr,length(tmpstr),1);
  writeln(outfile,tmpstr,');');
  close(infile);
  close(outfile);
end.
