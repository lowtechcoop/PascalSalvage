program calculatepi;
{7th form stats pi calculator}
uses crt;
var x,y,z:integer;
    a,b,c,d:real;
    en,count:integer;

function test (pwer:longint):real;
begin
  if odd(pwer) = true then test:=(-1) else test:=(1);
end;

procedure plus;{routine using ONLY addition}
begin;
  b:=800000; {number of terms}
repeat
  a:=a+1;
{     c:=c+(1 / (a*a)); {formula}
until a=b;

  c:=c*6;
  c:=sqrt(c);
end;

procedure pm135;{routine using both plus and minus}
begin;
     b:=28;{number of terms}
a:=0;
repeat
a:=a+1;
{c:=c+1/( test(4*a-1))/2*a-1}
{( (power( (-1) ,4*a-1 )) / ( 2*a-1 ) )}{stupid cause all u need to do is
check if it's odd or even odd will be -1}


{writeln('a=',a);
writeln('c=',c);}
until a=b;
c:=1-c;
c:=c*4;

end;     {not fucking working the biatch}

procedure pm123;{pm 1 2 3}
begin
b:=1000;
repeat
a:=a+1;
{c:=c+1*(test((4*a)-1))/(a*a);}
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
pm123;
writeln(c);
{writeln(exp(3*ln(2)));}
end.
