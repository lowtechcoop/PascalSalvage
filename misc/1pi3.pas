program calculatepi;
{PI calculator -  Blair Harrison 1999}
uses crt;
var x,y,z:integer;
    a,b,c,d,e:real;
    en,count:integer;

function test (pwer:longint):real;
begin
  if odd(pwer) = true then test:=(-1) else test:=(1);
end;

procedure plus;{routine using ONLY addition}
begin;
  b:=20000; {number of terms}
repeat
  a:=a+1;
     c:=c+(1 / (a*a)); {formula}
until a=b;

  c:=c*6;
  c:=sqrt(c);
end;

procedure pm135;{routine using both plus and minus}
begin;

b:=1000;
repeat
a:=a+1;
    en:=(-1);

    repeat
      count:=count+1;
      en:=en*(-1);
    until count=b;

count:=0;
d:=2*a-1;
  c:=c+1 / d;
  c:=c*en

until a=b;
c:=c*12;
c:=sqrt(c);


end;

procedure pm123;{pm 1 2 3}
begin
b:=1000;
repeat
a:=a+1;
    en:=(-1);

    repeat
      count:=count+1;
      en:=en*(-1);
    until count=b;

count:=0;
d:=a*a;
  c:=c+1 / d;
  c:=c*en

until a=b;
c:=c*12;
c:=sqrt(c);

end;
procedure menu;
var ch:char;
    s:string;

begin
writeln(' Pi calculator Menu . Blair Harrison 1999');
writeln('1. 1st algorithm ');
writeln('2. 2nd algorithm ');
writeln('3. 3rd algorithm');
writeln(' all algorithms use 1,000 terms');
writeln(' press a number, or x to exit');
readln(ch);
case ch of
     '1':plus;
     '2':pm135;
     '3':pm123;
     'x':exit;
end;
str(c,s);
writeln('answer:',copy(s,1,17));
end;


begin;
clrscr;
menu;
{This program was written by Blair Harrison, July 1999}

end.
