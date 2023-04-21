
{$i-,v-}

program uudecode;
{ not-real 'uudecode', use debug to create file, by Bas van Gaalen, Holland, PD }
type
  buftype = array[0..1023] of byte;
  str4 = string[4];
  str80 = string[80];

var
  uufile : file;
  txtfile : text;
  buffer : buftype;
  uufilename,txtfilename,tmpstr : str80;
  mempos,bufpos : word;
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

function hex(value : word) : str4;
var num : str4; i : integer;
begin
  if value < 256 then begin
    num[0] := #2;
    num[1] := chr((lo(value) div 16)+48);
    num[2] := chr((lo(value) mod 16)+48);
  end
  else begin
    num[0] := #4;
    num[1] := chr((hi(value) div 16)+48);
    num[2] := chr((hi(value) mod 16)+48);
    num[3] := chr((lo(value) div 16)+48);
    num[4] := chr((lo(value) mod 16)+48);
  end;
  for i := 1 to length(num) do if (ord(num[i])) > 57 then
    num[i] := chr(ord(num[I])+7);
  hex := num;
end;

{----------}

begin
  write(' enter input filename: '); readln(uufilename);
  assign(uufile,uufilename);
  reset(uufile,1);
  if ioresult <> 0 then error('error opening file '+uufilename);

  write('enter output filename: '); readln(txtfilename);
  assign(txtfile,txtfilename);
  rewrite(txtfile);
  if ioresult <> 0 then error('error creating file '+txtfilename);

  mempos := $0100; tmpstr := ' E '+hex(mempos); i := 0;
  writeln(txtfile,' N '+upstr(uufilename));

  repeat
    blockread(uufile,buffer,sizeof(buffer),rd);
    for bufpos := 0 to rd-1 do begin
      if i mod 21 = 20 then begin
        writeln(txtfile,tmpstr);
        tmpstr := '';
        inc(mempos,i);
        i := 0;
        tmpstr := ' E '+hex(mempos);
      end;
      tmpstr := tmpstr+' '+hex(buffer[bufpos]);
      inc(i);
    end;
  until rd < 1024;
  writeln(txtfile,tmpstr);
  inc(mempos,i);

  writeln(txtfile,' Rcx');
  writeln(txtfile,' '+hex(mempos-$0100));
  writeln(txtfile,' W');
  writeln(txtfile,' Q');

  close(uufile); close(txtfile);

  writeln('ready...');
end.
