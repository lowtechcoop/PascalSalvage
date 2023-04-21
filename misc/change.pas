program coder; {connverts sentences to numbers, max about 80 characters}
uses dos,crt;
{wohoo the whole thing works!!!! now all i have to do is add
reading from files, dont need it right now tho.. it's easy enff to add}
{6/11/98 - added an XOR. it now XORs the number before converting it to string
this makes it shorter, and makes it harder to guess how it's done}
var ch:string[1]; {dont question this. it just is}
    outfile:text;
    ch2:char;
    num:longint;
    numberstring:string;
    texts2:string;
    texts3:string;
    instring:string;
    blah:integer;
  code,F,g,tempnumb: integer;
  {^ dont like that, cant find any way round it tho...}
 function IntToStr(I: Longint): String;
{ Convert any integer type to a string }
var
  S: string[11];
begin
  Str(I, S);
  IntToStr := S;
end;

procedure converttonumber(inst:string);
begin
ch:=copy(inst,f,1);          {you could make the output a user definable var}
 ch2:=ch[1];
 num:=ord(ch2);
{ num:=num xor 42;}
 numberstring:=numberstring+inttostr(num)+'/';
end;

procedure putback;
{inputs from numberstring, outputs to texts3}
begin
     f:=1;
     repeat
        texts2:='';
          repeat
             texts2:=texts2+numberstring[f];
             f:=f+1;
             ch:=numberstring[f];
          until ch='/';                   {yuck hate this. took me ages!}

        val(texts2,tempnumb,code);
{        texts3:=texts3+chr((42 xor tempnumb));}
        texts3:=texts3+chr((tempnumb));

          f:=f+1;
     until f=length(numberstring)+1;
end;

procedure output(a:string;b:string);
begin;
Assign(outfile, b);
Rewrite(outfile);
Writeln(outfile, a);
Close(outfile);
end;

function txt2num(a:byte;b:string):string;
{a=1 then do num >txt, a=2 do txt>num}
begin
  case a of
   1:begin
     numberstring:=b;
     putback;
     txt2num:=texts3;
     end;
   2:begin
     blah:=length(b);
      repeat
       f:=f+1;
       converttonumber(b);
      until f=blah;
     txt2num:=numberstring;
     end;
end;
end;
begin
  clrscr;
  writeln('Text <--> number string converter 0.2Beta. Dripping Beef Software, 1998');
  Write('Enter a line of text: ');
  Readln(instring);
  writeln(txt2num(2,instring));
  writeln(txt2num(1,numberstring));
{now output numberstring to a file}
{output(numberstring,'txtnum.txt');}
  Writeln('Push any key to exit');
  readln;
end.
