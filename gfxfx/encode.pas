
{$i-,v-}

program encode;
{ Convert (xfered) textfile back to original, by Bas van Gaalen, Holland, PD }
type
  buftype = array[0..1023] of byte;
  str3 = string[3];
  str80 = string[80];

var
  infile : text;
  outfile : file;
  buffer : buftype;
  infilename,outfilename,tmpstr : str80;
  bufpos : word;
  i,v : byte;

{----------}

procedure error(errstr : str80); begin
  writeln(errstr); halt; end;

{----------}

function tobyte(inbyte : str3) : byte;
const hexchars : array[0..15] of char = '0123456789ABCDEF';
var i,tmpbyte : byte;
begin
  i := 0; while hexchars[i] <> upcase(inbyte[2]) do inc(i);
  tmpbyte := i;
  i := 0; while hexchars[i] <> upcase(inbyte[1]) do inc(i);
  tmpbyte := tmpbyte+16*i;
  tobyte := tmpbyte;
end;

{----------}

begin
  write(' Enter input filename: '); readln(infilename);
  assign(infile,infilename);
  reset(infile);
  if ioresult <> 0 then error('Error opening file '+infilename);

  readln(infile,outfilename);
  assign(outfile,outfilename);
  rewrite(outfile,1);
  if ioresult <> 0 then error('Error creating file '+outfilename);

  bufpos := 0;
  repeat
    readln(infile,tmpstr);
    while length(tmpstr) > 0 do begin
      buffer[bufpos] := tobyte(copy(tmpstr,1,2));
      delete(tmpstr,1,2);
      inc(bufpos);
      if bufpos = sizeof(buffer) then begin
        blockwrite(outfile,buffer,bufpos);
        bufpos := 0;
      end;
    end;
  until eof(infile);
  blockwrite(outfile,buffer,bufpos);

  close(infile); close(outfile);
  writeln('ready...');
end.
