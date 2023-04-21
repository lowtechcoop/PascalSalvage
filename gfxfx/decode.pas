
{$i-,v-}

program decode;
{ Convert binairy file to text for mail-xfer, by Bas van Gaalen, Holland, PD }
uses
  dos;

type
  buftype = array[0..1023] of byte;
  str2 = string[2];
  str80 = string[80];

var
  uufile : file;
  txtfile : text;
  buffer : buftype;
  uufilename,txtfilename,tmpstr : str80;
  d : dirstr; n : namestr; e : extstr;
  bufpos : word;
  rd : integer;
  i,v : byte;

{----------}

procedure error(errstr : str80); begin
  writeln(errstr); halt; end;

{----------}

function upstr(srcstr : str80) : str80;
var i : byte;
begin
  for i := 0 to length(srcstr) do
    if srcstr[i] in ['a'..'z'] then dec(srcstr[i],32);
  upstr := srcstr;
end;

{----------}

function hex(value : byte) : str2;
const hexchars : array[0..15] of char = '0123456789abcdef';
begin
  hex := hexchars[value shr 4]+hexchars[value and 15];
end;

{----------}

begin
  write(' Enter input filename: '); readln(uufilename);
  assign(uufile,uufilename);
  reset(uufile,1);
  if ioresult <> 0 then error('Error opening file '+upstr(uufilename));

  write('Enter output filename: '); readln(txtfilename);
  assign(txtfile,txtfilename);
  rewrite(txtfile);
  if ioresult <> 0 then error('Error creating file '+upstr(txtfilename));

  fsplit(uufilename,d,n,e);
  writeln(txtfile,upstr(n+e));
  tmpstr := '';

  repeat
    blockread(uufile,buffer,sizeof(buffer),rd);
    for bufpos := 0 to rd-1 do begin
      if i mod 36 = 35 then begin
        writeln(txtfile,tmpstr);
        tmpstr := '';
        i := 0;
      end;
      tmpstr := tmpstr+hex(buffer[bufpos]);
      inc(i);
    end;
  until rd < 1024;
  writeln(txtfile,tmpstr);
  close(uufile); close(txtfile);
  writeln('ready...');
end.
