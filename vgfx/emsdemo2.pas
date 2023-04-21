{ EMS unit demo program - (C) Copyright 1994 Brian Manning

  What makes this demo different from EMSDEMO.PAS is that I am only
  allocating 1 page of EMS memory for all three balls!  I wanted to
  include this demo as an example of using EMS pages more efficiently.

  In EMSDEMO.PAS I allocated a page for each sprite, since each sprite
  I'm using here never exceeds 891 bytes; why allocate almost 50k of EMS
  for them?  So this demo only allocates the one 16k page in EMS for all
  three ball sprites, happy coding!

}
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


     { Allocate 1 page of EMS memory (16384 bytes) }
     handle:=EMSAlloc(1);

     if (EMSResult>=$80) then
     begin
          { There was an EMS error, so display the description }
          writeln('EMS Alloc Error:  ', EMS_ErrDesc[EMSResult]);
          halt(1);
     end;


     { Map this page so we can use it }
     if not(EMSMap(Handle, 0, 0)) then
     begin
          { There was an EMS error, so display the description }
          writeln('EMS Map Error:  ', EMS_ErrDesc[EMSResult],i);
          EMSFree(handle);
          halt(1);
     end;


     writeln;
     writeln('1 page of EMS memory allocated and ready!');
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

     { Set the offset of the page to 0 (begining) }
     EMSPageOfs(0);
     GetImage (EMSPage(0)^, 10, 7, 15, 13);

     { Set the offset of the page to 196 (end of 1st ball) }
     EMSPageOfs(196);
     GetImage (EMSPage(0)^, 45, 7, 25, 21);

     { Set the offset of the page to 721 (end of 2nd ball) }
     EMSPageOfs(721);
     GetImage (EMSPage(0)^, 96, 7, 33, 27);

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

           { Set the offset of the page to 0 (start of 1st ball) }
           EMSPageOfs(0);
           for m:=1 to 10 do
               PutClip(EMSPage(0)^, x[m], y[m], 15, 13);

           { Set the offset of the page to 196 (start of 2nd ball) }
           EMSPageOfs(196);
           for m:=11 to 21 do
               PutClip(EMSPage(0)^, x[m], y[m], 25, 21);

           { Set the offset of the page to 721 (start of 3rd ball) }
           EMSPageOfs(721);
           for m:=22 to 25 do
               PutClip(EMSPage(0)^, x[m], y[m], 33, 27);

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
