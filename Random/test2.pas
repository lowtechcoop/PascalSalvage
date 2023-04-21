program sb;

uses Crt;

var
  a, b, counter, pitch : integer;
  ch : char;

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
   ClrScr;
   InitSound;
   pitch:=$B0;
   Sound(pitch);
   GotoXY(1,1);Write('Pitch: ',Pitch);
   Repeat
   ch:=ReadKey;
   if ch=#0 then
   begin
      ch:=ReadKey;
      if ch='P' then Pitch:=Pitch-1;
      if ch='H' then Pitch:=Pitch+1;
   end;
   Sound(pitch);
   GotoXY(1,1);Write('Pitch: ',Pitch);
   until ch=#27;
   NoSound;
end.