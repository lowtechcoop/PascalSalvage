program rot13;
uses crt;
var
c,co:char;
adder:integer;
instring:string;

Function charconv(convert:char):char;
var y: byte;
begin
y:=ord(convert);

case y of
 65..90: If (y-13) >=65 then charconv:=chr(y-13);
 65..90: If (y-13) < 65 then charconv:=chr(91+ ((y-13)-65));
 97..122: if (y-13) >=97 then charconv:=chr(y-13);
 97..122: if (y-13) < 97 then charconv:=chr(123+((y-13)-97));
else charconv:=chr(y);
end;
end;

procedure rot13conv;
var i:integer;
begin
if instring='quit' then exit;
for I:=1 to length(instring) do
instring[I]:=charconv(instring[I]);

end;


begin
clrscr;
writeln('Rot13 Conversion Utility, Blair Harrison , 20/9/2000');
writeln('Enter some text to convert:');
writeln;
read(instring);
rot13conv;
writeln(' in rot13');
writeln(instring);

end.
