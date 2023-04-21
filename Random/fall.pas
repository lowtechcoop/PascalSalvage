program sb;

uses Crt;

var
  a, b, counter : integer;

procedure RegstDelay;
begin
   for a:=1 to 6 do
   begin
      b:= port[$0388];
   end;
end;

procedure DataDelay;
begin
   for a:=1 to 35 do
   begin
      b:= port[$0388];
   end;
end;

procedure InitSound;
begin
   port[$0388]:=$20;
   RegstDelay;
   port[$0389]:=$01;
   DataDelay;
   port[$0388]:=$40;
   RegstDelay;
   port[$0389]:=$10;
   DataDelay;
   port[$0388]:=$60;
   RegstDelay;
   port[$0389]:=$F0;
   DataDelay;
   port[$0388]:=$80;
   RegstDelay;
   port[$0389]:=$77;
   DataDelay;
   port[$0389]:=$98;
   DataDelay;
   port[$0388]:=$23;
   RegstDelay;
   port[$0389]:=$01;
   DataDelay;
   port[$0388]:=$43;
   RegstDelay;
   port[$0389]:=$00;
   DataDelay;
   port[$0388]:=$63;
   RegstDelay;
   port[$0389]:=$F0;
   DataDelay;
   port[$0388]:=$83;
   RegstDelay;
   port[$0389]:=$77;
   DataDelay;
   port[$0388]:=$B0;
   RegstDelay;
   port[$0389]:=$31;
   DataDelay;
end;

procedure Sound(Hertz : word);
begin
   port[$0388]:=$A0;
   RegstDelay;
   port[$0389]:=Hertz;
   DataDelay;
end;

procedure NoSound;
begin
   port[$0388]:=$B0;
   RegstDelay;
   port[$0389]:=$11;
   DataDelay;
end;

begin
   InitSound;
   for counter:= 255 downto 0 do
   begin
      Sound(counter);
      Delay(2);
   end;
   for counter:= 0 to 3000 do
   begin
      Sound(random(256));
   end;
   NoSound;
end.