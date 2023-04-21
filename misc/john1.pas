program johnconv;

var
   hours:byte;
   minutes:byte;

procedure convtime(time:integer);
begin
     hours:=time div 100;
     minutes:=time mod 100;

     if hours>12 then hours:=hours - 12;
     writeln('time (',time,') = ',hours,'.',minutes);

end;


begin
convtime(1930);

end.
