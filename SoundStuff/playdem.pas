{ -----------------"demo.pas"------------------------------------------ }

uses crt, play;

var voc  : pointer;
    name : string;

begin
 getmem(voc, 65535);

 if paramcount = 1 then
  name := paramstr(1)
 else
  begin
   write('Play voc file (size < 65535!): ');
   readln(name);
  end;

 play_voc(name, voc);
 writeln;

 writeln('Playing, press "P" to pause...');

 repeat
  if keypressed then if (upcase(readkey) = 'P') then
   begin
    dma_pause;

    writeln('Press "C" to continue...');

    repeat
    until upcase(readkey) = 'C';

    writeln('Continuing...');
    dma_continue;
   end;
 until playing_voc;

 writeln('Done...');

 freemem(voc, 65535);
end.
