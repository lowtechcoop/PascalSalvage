
{ Copyright (c) 1985,90 by Borland International, Inc. }

unit Display;
{ Sample unit for CIRCULAR.PAS }

interface

procedure WriteXY(x, y : integer; s : string);
Procedure WriteS(x,y:integer; l: integer);
implementation
uses
  Crt;

procedure WriteXY(x, y : integer; s : string);
begin
  if (x in [1..80]) and (y in [1..25]) then
  begin
    GoToXY(x, y);
    Write(s);
  end ;
  end;
procedure WriteS(x, y : integer; l : integer);
begin
  if (x in [1..80]) and (y in [1..25]) then
  begin
    GoToXY(x, y);
    Write(l);

  end
 end;
end.
