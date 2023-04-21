unit miss2;
interface
uses dos,crt;
var
ch:char;
screenlength :integer;
color:integer;
blank:integer;
space:integer;
  done:integer;
  counter, { For counting number of lines read }
      numberlines,  { For storing number of lines read }
      select:integer;  { Random number generated within range
    of numberlines }
    lines,d:string;
    invisible:string;
    noloop,next:integer;
    line_num:integer;
    line_nums:integer;
  f:text;
  All:string;
Procedure Colour_text(s:string);
Procedure Colour_file(fil:string);
function test(S:STRING):STRING;



implementation
procedure pause;

begin;

textcolor(3);
writeln('< Pause >');
writeln('');
repeat
until readkey=chr(13);
end;

procedure nowrite;
begin;
d:='';
noloop:=2;
end;

procedure colour(s:string);
  begin;
{  if d=' ' then blank:=blank+1;
  if blank > 4 then writeln('');
  if blank > 4 then blank:=0;
{  if space > 78 then writeln('');
  if space > 78 then space:=1;   }

   if s='~' then noloop:=2;
   if s='1' then textcolor(1);
  if s='2' then textcolor(2);
  if s='3' then textcolor(3);
  if s='4' then textcolor(4);
  if s='5' then textcolor(5);
  if s='6' then textcolor(6);
  if s='7' then textcolor(7);
  if s='8' then textcolor(8);
  if s='9' then textcolor(9);
  if s='0' then textcolor(10);
  if s='@' then textcolor(12);
  if s='#' then textcolor(13);
  if s='$' then textcolor(14);
  if s='%' then textcolor(15);
  if s='^' then textcolor(16);
  if s='&' then textcolor(17);
  if s='*' then textcolor(18);
  if s='(' then textcolor(19);
  if s=')' then textcolor(20);
  if noloop  > 2 then write(d);
  if noloop>2 then space:=space+1;
   if color=1 then begin;
  color:=0;
  if s='!' then textcolor(11);
  end;
  end;

procedure colour_text(s:string);
  begin;
 next:=1;
 select:=1;
 textcolor(15);
  noloop:=2;
    repeat

         d := Copy(s, next, 1);
             if d='~' then writeln('');
             noloop:=noloop + 1;

            if d='`' then noloop:=1;
            if d='`' then color:=1;
              next := next + 1;

               if noloop <> 1 then Colour(d);

    until next > length(s);
  textcolor(15);
  end;

function test(S:STRING):STRING;
  begin;
 next:=1;
 select:=1;
 textcolor(15);
  noloop:=2;
    repeat

         d := Copy(s, next, 1);
             if d='~' then writeln('');
             noloop:=noloop + 1;

            if d='`' then noloop:=1;
            if d='`' then color:=1;
              next := next + 1;

               if noloop <> 1 then Colour(d);

    until next > length(s);
  textcolor(15);
  end;

procedure Colour_file(fil:string);
begin;

  assign(F,fil);
   reset(F);

        while not eof(f) do
repeat
           begin;
       readln(f,invisible);
       numberlines:=numberlines+1;
      end;
        select := select+1 ;
       reset(f);
    while not eof(f) do  { Match the random number with a line }

      begin;
       readln(f,lines);
       counter:=counter+1;
       if counter=select THEN done:=1;
       lines:=lines+'     ~';
if done =1 then begin;
        next:=1;
 textcolor(15);
  noloop:=2;
     repeat
     {     writeln(lines);  }
         d := Copy(lines, next, 1);
     if d='~' then writeln('');
          noloop:=noloop + 1;

            if d='`' then noloop:=1;

              next := next + 1;

               if noloop <> 1 then Colour(d);


      until next > length(lines);
  if counter=screenlength then pause;
  textcolor(15);

  end;
  end;
    counter:=0;
  until select = numberlines;
  Close(f);
end;
end.
{ SAMPLE OF USAGE }

{ program thingy;
uses Chris,crt;

var name:string;

  begin;
  clrscr;
  write('type ` then a number for that colour eg. `4C`1arnage!! := ');
  colour_text('`4C`1arnage!!');
        writeln('');
         writeln('name');

         readln(name);
   colour_text(name);

         delay  (1000);
  end.   }
