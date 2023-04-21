Unit SPX_FNC;

{ SPX Library Version 1.0  Copyright 1993 Scott D. Ramsay }

Interface

function sgn(h:integer):integer;
function strint(s:string):longint;
function intstr(l:longint):string;
function ups(s:string):string;
function st(h:longint):string;
function compare(s1,s2:string):boolean;
function dtcmp(var s1,s2;size:word):boolean;
function cmp(var s1,s2;size:word):boolean;
function lz(i,w:longint):string;
function vl(h:string):longint;
function spaces(h:integer):string;
function repstr(h:integer;ch:char):string;
procedure ifix(var a:integer;min,max:integer);
procedure rfix(var a:real;min,max:real);
function anything(s:string):boolean;
function exist(f:string):boolean;
function errmsg(n:integer):string;
function TPerror(errorcode:integer) : string;
procedure funpad(var s:string);
procedure unpad(var s:string);
procedure munpad(var s:string;b:byte);
function fpad(s:string;h:integer):string;
procedure pad(var s:string;h:integer);
procedure fix(var s:string;h:string);
procedure fixh(var s:string);
function range(x,y,x1,y1,x2,y2:integer) : boolean;
function rrange(x,y,x1,y1,x2,y2:real) : boolean;
function between(x,x1,x2:longint):boolean;

Implementation


function cmp(var s1,s2;size:word):boolean;
begin
  cmp := dtcmp(s1,s2,size);
end;


function sgn(h:integer):integer;
begin
  if h<0
    then sgn := -1
    else
      if h>0
        then sgn := 1
        else sgn := 0;
end;


procedure ifix(var a:integer;min,max:integer);
begin
  if a<min
    then a := min
    else
      if a>max
        then a := max;
end;


procedure rfix(var a:real;min,max:real);
begin
  if a<min
    then a := min
    else
      if a>max
        then a := max;
end;


function range(x,y,x1,y1,x2,y2:integer) : boolean;
begin
  range := ((x>=x1) and (x<=x2) and (y>=y1) and (y<=y2));
end;

function rrange(x,y,x1,y1,x2,y2:real) : boolean;
begin
  rrange := ((x>=x1) and (x<=x2) and (y>=y1) and (y<=y2));
end;


procedure fix(var s:string;h:string);
begin
  if pos('.',s)=0
    then s := s+h;
end;


procedure fixh(var s:string);
var
  d : integer;
begin
  for d := 1 to length(s) do
    if s[d]<#32
      then s[d] := ' ';
  for d := length(s)+1 to 255 do
    s[d] := ' ';
end;


function strint(s:string):longint;
var
  l : longint;
begin
  move(s[1],l,sizeof(l));
  strint := l;
end;


function intstr(l:longint):string;
var
  s : string;
begin
  move(l,s[1],sizeof(l));
  s[0] := #4;
  intstr := s;
end;


function ups(s:string):string;
var
  d : integer;
begin
  for d := 1 to length(s) do
    s[d] := upcase(s[d]);
  ups := s;
end;


function st(h:longint):string;
var
  s : string;
begin
  str(h,s);
  st := s;
end;


function compare(s1,s2:string):boolean;
var
  d : byte;
  e : boolean;
begin
  e := true;
  for d := 1 to length(s1) do
    if upcase(s1[d])<>upcase(s2[d])
      then e := false;
  compare := e;
end;


function dtcmp(var s1,s2;size:word):boolean;
var
  d : word;
  e : boolean;
begin
  e := true;
  d := size;
  while (d>0) and e do
    begin
      dec(d);
      e := (mem[seg(s1):ofs(s1)+d]=mem[seg(s2):ofs(s2)+d]);
    end;
  dtcmp := e;
end;


function lz(i,w:longint):string;
var
  d : longint;
  s : string;
begin
  str(i,s);
  for d := length(s) to w-1 do
    s := concat('0',s);
  lz := s;
end;


function vl(h:string):longint;
var
  d : longint;
  e : integer;
begin
  val(h,d,e);
  vl := d;
end;


function spaces(h:integer):string;
var
  s : string;
begin
  s := '';
  while h>0 do
    begin
      dec(h);
      s := concat(s,' ');
    end;
  spaces := s;
end;


function repstr(h:integer;ch:char):string;
var
  s : string;
begin
  s := '';
  while h>0 do
    begin
      dec(h);
      s := s+ch;
    end;
  repstr := s;
end;


function anything(s:string):boolean;
var
  d : integer;
  h : boolean;
begin
  if length(s)=0
    then
      begin
        anything := false;
        exit;
      end;
  h := false;
  for d := 1 to length(s) do
    if s[d]>#32
      then h := true;
  anything := h;
end;


function exist(f:string):boolean;
var
  fil : file;
begin
  if f=''
    then
      begin
        exist := false;
        exit;
      end;
  assign(fil,f);
 {$i- }
  reset(fil);
  close(fil);
 {$i+ }
  exist := (ioresult=0);
end;


function errmsg(n:integer):string;
begin
   case n of
      -1 : errmsg := '';
      -2 : errmsg := 'Error reading data file';
      -3 : errmsg := '';
      -4 : errmsg := 'equal current data file name';
     150 : errmsg := 'Disk is write protected';
     152 : errmsg := 'Drive is not ready';
     156 : errmsg := 'Disk seek error';
     158 : errmsg := 'Sector not found';
     159 : errmsg := 'Out of Paper';
     160 : errmsg := 'Error writing to printer';
    1000 : errmsg := 'Record too large';
    1001 : errmsg := 'Record too small';
    1002 : errmsg := 'Key too large';
    1003 : errmsg := 'Record size mismatch';
    1004 : errmsg := 'Key size mismatch';
    1005 : errmsg := 'Memory overflow';
     else errmsg := 'Error result #'+st(n);
   end;
end;


function TPerror(errorcode:integer) : string;
begin
  case errorcode of
      1: TPerror := 'Invalid DOS function code';
      2: TPerror := 'File not found';
      3: TPerror := 'Path not found';
      4: TPerror := 'Too many open files';
      5: TPerror := 'File access denied';
      6: TPerror := 'Invalid file handle';
      8: TPerror := 'Not enough memory';
     12: TPerror := 'Invalid file access code';
     15: TPerror := 'Invalid drive number';
     16: TPerror := 'Cannot remove current directory';
     17: TPerror := 'Cannot rename across drives';
    100: TPerror := 'Disk read error';
    101: TPerror := 'Disk write error';
    102: TPerror := 'File not assigned';
    103: TPerror := 'File not open';
    104: TPerror := 'File not open for input';
    105: TPerror := 'File not open for output';
    106: TPerror := 'Invalid numeric format';
    200: TPerror := 'Division by zero';
    201: TPerror := 'Range check error';
    202: TPerror := 'Stack overflow error';
    203: TPerror := 'Heap overflow error';
    204: TPerror := 'Invalid pointer operation';
    else TPerror := errmsg(errorcode);
  end;
end;


procedure funpad(var s:string);
begin
   while s[1]=' ' do
      delete(s,1,1);
end;


procedure unpad(var s:string);
begin
   while (length(s)>0) and (s[length(s)]<=' ') do
      delete(s,length(s),1);
end;


procedure munpad(var s:string;b:byte);
begin
   s[0] := char(b);
   while (length(s)>0) and (s[length(s)]<=' ') do
      delete(s,length(s),1);
end;


function fpad(s:string;h:integer):string;
begin
   while length(s)<h do
      s := concat(s,' ');
   fpad := s;
end;


procedure pad(var s:string;h:integer);
begin
   while length(s)<h do
      s := concat(s,' ');
end;


function between(x,x1,x2:longint):boolean;
begin
  between := ((x>=x1) and (x<=x2));
end;


end.