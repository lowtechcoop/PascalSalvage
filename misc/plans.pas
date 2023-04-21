program dimensional_loop; {generates array of random ascii characters
                           that will produce the instructions to a time
                           machine or dimensional shifter in another
                           dimension ....}

uses crt,dos;
var instr:text;
    x,y,z,temp:integer;
    thingee:array [1..4080] of char;

procedure genascii;
begin;

      z:=random(39)+175;
      write(chr(z));
      write(instr,chr(z));
end;

begin;
assign(instr,'plans.txt');
rewrite(instr);
randomize;
genascii;
repeat;
genascii;
until keypressed
;
close(instr);
end.



