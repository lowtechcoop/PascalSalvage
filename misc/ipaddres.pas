program convlongtoip;
uses crt;

var x:longint;
    a,b,c,d:integer;
    f,g,h,i:string;
    j:integer;
procedure convert;
begin;
{x:=(a shl 24) + (b shl 16) + (c shl 8) + d;}
x:=a shl 24;
x:=x+ b shl 16;
x:=x+ c shl 8;
x:=x + d;


{x:=a shl 24+b;
x:=x shl 16+c;
x:=x shl 8+d;}


end;



begin;
clrscr;
readln(f);
readln(g);
readln(h);
readln(i);
val(f,a,j);
val(g,b,j);
val(h,c,j);
val(i,d,j);

convert;
writeln('ip address :',a,b,c,d);
writeln('longintip:',x);

end.
