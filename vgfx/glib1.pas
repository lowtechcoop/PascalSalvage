{ GLIB demo program }

uses dos,crt,vgfx;

var text:array[0..286] of byte;
    i:integer;

begin
     { Set-up the library we want to work with }
     if (not SetWorkLib('demo.gfx')) then
     begin
          writeln('Cannot find DEMO.GFX!');
          writeln;
          halt(1);
     end;

     { Find TEST.DOC in DEMO.GFX and read in it's contents! }
     if (LoadLib ('test.doc',text,0,286)=0) then
     begin
          writeln('An error occured while trying to load TEST.DOC!');
          writeln;
          halt(1);
     end;


     clrscr;

     writeln('I found this in DEMO.GFX:');
     writeln('-------------------------');
     writeln;

     { Let's print that message! }
     for i:=0 to 285 do
         write(chr(text[i]));

     writeln;
     readkey;
end.