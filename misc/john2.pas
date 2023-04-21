program johnconv;

var
   hours:byte;
   minutes:byte;
   ampm:byte;

procedure convtime(time:integer);
begin
     hours:=time div 100;
     minutes:=time mod 100;

     if hours>12 then hours:=hours - 12;
     write('time (',time,') = ',hours,'.',minutes);
     if time<1200 then writeln('am') else writeln('pm');

end;


begin
convtime(1130);

end.
