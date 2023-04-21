{ EMS unit demo program - (C) Copyright 1994 Brian Manning }

{$I-,D-,S+,X+}

program EMS_Demo;

uses dos,crt,vgfx,ems;

{ Declare our variables }
var emsver : word;
    bytes  : longint;
    pages,
    i,
    handle : integer;
    x, y   : array[1..25] of integer;
    hit    : array[1..25] of byte;
    hitY   : array[1..25] of byte;
    m      : byte;


{ Main Procedure! }
begin
     clrscr;
     writeln;

     { Initialize the EMS driver }
     EMSVer := EMS_Init;

     if (EMSResult >= $80) then
     begin
          { There was an EMS error, so display the description }
          writeln('EMS Error:  ', EMS_ErrDesc[EMSResult]);
          halt(1);
     end
     else if (EMSVer <> 0) then
         writeln('EMS version: ', (EMSVer div 10), '.', (EMSVer mod 10))
     else
     begin
          writeln('EMS Demo:  No EMS driver found!');
          halt(1);
     end;


     { Get the amount of free pages of EMS memory }
     pages:=EMSFreePages;

     { Display the EMS memory status on the screen }
     writeln(pages, ' pages available (', (longint(16384)*pages) div 1024,
                    'k of total storage)');


     { Allocate 3 pages of EMS memory (49152 bytes) }
     handle:=EMSAlloc(3);

     if (EMSResult>=$80) then
     begin
          { There was an EMS error, so display the description }
          writeln('EMS Alloc Error:  ', EMS_ErrDesc[EMSResult]);
          halt(1);
     end;


     { Map these pages so we can use them }
     for i:=0 to 2 do
     begin
          if not(EMSMap(Handle, i, i)) then
          begin
               { There was an EMS error, so display the description }
               writeln('EMS Map Error:  ', EMS_ErrDesc[EMSResult],i);
               EMSFree(handle);
               halt(1);
          end;
     end;

     writeln;
     writeln('3 pages of EMS memory allocated and ready!');
     writeln;
     write('Press any key to begin ...');
     readkey;


     { Initialize VGFX }
     VGFX_Init;

     { Tell VGFX to use DEMO.GFX for all it's file handling }
     SetWorkLib('demo.gfx');


     { Set our work page to 4 (so the user cannot see the image loaded) }
     SetWorkPage(4);

     { Load up our images }
     ShowPcx ('balls.pcx', 0, 4);

     { Get images into EMS memory }
     GetImage (EMSPage(0)^, 10, 7, 15, 13);
     GetImage (EMSPage(1)^, 45, 7, 25, 21);
     GetImage (EMSPage(2)^, 96, 7, 33, 27);

     { Clear the screen }
     clearscreen(0);

     { Set our work page to 1 }
     SetWorkPage(1);

     { Show the PCX on page 3 (the background page) }
     ShowPcx('frac.pcx',0,3);

     randomize;
     for i := 1 to 25 do
     begin
          x[i]   := random(300);
          y[i]   := random(175);
          hit[i] := random(2);
          hitY[i]:= random(2);
     end;  { end for\do }

     repeat
           { All of the FOR/DO loops from here on are checking the ball's
             boundaries and moving them accordingly }

           for m := 1 to 5 do
           begin
                if (x[m] > 274) then hit[m] := 0;
                if (x[m] < 1)   then hit[m] := 1;
                if (y[m] > 186) then hitY[m]:= 0;
                if (y[m] < 1)   then hitY[m]:= 1;

                Case hit[m] of
                     1 : inc(x[m],2);
                     0 : dec(x[m],2);
                end; { end case }

                Case hitY[m] of
                     1 : inc(y[m],2);
                     0 : dec(y[m],2);
                end; { end case }
           end;  { end for\do }

           for m := 6 to 10 do
           begin
                if (x[m] > 274) then hit[m] := 0;
                if (x[m] < 1)   then hit[m] := 1;
                if (y[m] > 186) then hitY[m]:= 0;
                if (y[m] < 1)   then hitY[m]:= 1;

                Case hit[m] of
                     1 : inc(x[m],1);
                     0 : dec(x[m],1);
                end; { end case }

                Case hitY[m] of
                     1 : inc(y[m],1);
                     0 : dec(y[m],1);
                end; { end case }
           end;  { end for\do }

           for m := 11 to 14 do
           begin
                if (x[m] > 294) then hit[m] := 0;
                if (x[m] < 1)   then hit[m] := 1;
                if (y[m] > 179) then hitY[m]:= 0;
                if (y[m] < 1)   then hitY[m]:= 1;

                Case hit[m] of
                     1 : inc(x[m],1);
                     0 : dec(x[m],1);
                end; { end case }

                Case hitY[m] of
                     1 : inc(y[m],1);
                     0 : dec(y[m],1);
                end; { end case }
           end;  { end for\do }

           for m := 15 to 18 do
           begin
                if (x[m] > 294) then hit[m] := 0;
                if (x[m] < 1)   then hit[m] := 1;
                if (y[m] > 179) then hitY[m]:= 0;
                if (y[m] < 1)   then hitY[m]:= 1;

                Case hit[m] of
                     1 : inc(x[m],2);
                     0 : dec(x[m],2);
                end; { end case }

                Case hitY[m] of
                     1 : inc(y[m],2);
                     0 : dec(y[m],2);
                end; { end case }
           end;  { end for\do }

           for m := 19 to 21 do
           begin
                if (x[m] > 294) then hit[m] := 0;
                if (x[m] < 1)   then hit[m] := 1;
                if (y[m] > 179) then hitY[m]:= 0;
                if (y[m] < 1)   then hitY[m]:= 1;

                Case hit[m] of
                     1 : inc(x[m],4);
                     0 : dec(x[m],4);
                end; { end case }

                Case hitY[m] of
                     1 : inc(y[m],4);
                     0 : dec(y[m],4);
                end; { end case }
           end;  { end for\do }

           for m := 22 to 25 do
           begin
                if (x[m] > 286) then hit[m] := 0;
                if (x[m] < 1)   then hit[m] := 1;
                if (y[m] > 172) then hitY[m]:= 0;
                if (y[m] < 1)   then hitY[m]:= 1;

                Case hit[m] of
                     1 : inc(x[m],3);
                     0 : dec(x[m],3);
                end; { end case }

                Case hitY[m] of
                     1 : inc(y[m],3);
                     0 : dec(y[m],3);
                end; { end case }
           end;  { end for\do }

           { Put the images on the screen! }
           for m:=1 to 10 do
               PutClip(EMSPage(0)^, x[m], y[m], 15, 13);

           for m:=11 to 21 do
               PutClip(EMSPage(1)^, x[m], y[m], 25, 21);

           for m:=22 to 25 do
               PutClip(EMSPage(2)^, x[m], y[m], 33, 27);

           { Now update the screen with all of our new stuff }
           Update;

     until keypressed;

     readkey;

     { Cleanup our mess and set the video mode back to text! }
     VGFX_Done;

     { Free the EMS memory we allocated earlier }
     EMSFree(handle);

     { Check for EMS error }
     if (EMSResult>=$80) then
     begin
          { There was an EMS error, so display the description }
          writeln('EMS Free Error:  ', EMS_ErrDesc[EMSResult]);
          halt(1);
     end
     else
         writeln('EMS memory freed, demo completed successfully.');

     writeln;
     halt(0);

end.
