Program MenuExample;

Uses Crt,
     Menunit;

Var
  Bar    : AttrStr;
  I      : Integer;
  Result : Byte;

Begin
 ClrScr;
 For i:=1 to 5 do
  begin
    GotoXY(10,4+i);
    Write('Menu item #',i);
  end;

 Result:=Menu(10,5,22,9,112);
 Writeln;
 If Result <> 0 then
    Writeln('You Choose item #',Result)
 else
    Writeln('You Choose Nothing');

end.