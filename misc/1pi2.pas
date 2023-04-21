program calculatepi;
{7th form stats pi calculator}
uses crt;
var a,x,y,z:integer;
    b,c,d,e:real;
    en,count:integer;

function test (pwer:longint):real;
begin
  if odd(pwer) = true then test:=(-1) else test:=(1);
end;

procedure plus;{routine using ONLY addition}
begin;
  b:=200000; {number of terms}
repeat
  a:=a+1;
     c:=c+(1 / (a*a)); {formula}
until a=b;

  c:=c*6;
  c:=sqrt(c);
end;

procedure pm135;{routine using both plus and minus}
(* begin;
     b:=28;{number of terms}
a:=0;
repeat
a:=a+1;
{c:=c+1/( test(4*a-1))/2*a-1}
{( (power( (-1) ,4*a-1 )) / ( 2*a-1 ) )}{stupid cause all u need to do is
check if it's odd or even odd will be -1}
d:=test(4*a-1);
e:=1*d;
d:=d/(2*a-1);
c:=c+e/d

{writeln('a=',a);
writeln('c=',c);}
until a=b;
c:=2+c;
c:=c*4;
   *)
begin;

b:=28;
a:=1;
repeat
a:=a+1;
{me try something diff this time :)}
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
{me try something diff this time :)}
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


begin;
{plus;}
clrscr;
pm135;
writeln(c);
{writeln(exp(3*ln(2)));}
end.
