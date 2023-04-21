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
     if hours=0 then hours:=12;

     write('time (',time,') = ',hours,'.',minutes);

     case time of
     1..1159:writeln(' am');
     1201..2359:writeln(' pm');
     1200:writeln(' Midday');
     0:writeln(' Midnight');
     end;

end;


begin
convtime(0001);

end.
