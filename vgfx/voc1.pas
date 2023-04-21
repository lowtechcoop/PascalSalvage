{ Simple demo program the shows the use of the VOC playing routines
  in VGFX.

  What this demo does is load up a voc file and play it until the user
  presses a key.
}

uses dos,crt,vgfx;

begin
     { Set-up the library so we can access the VOC file }
     SetWorkLib('demo.gfx');


     { Initialize SoundBlaster or compatible }
     if (not SB_Init(5, 1, $220)) then
     begin
          { SoundBlaster or compatible was not found, so give an error msg }

          writeln;
          writeln('Sorry, but I cannot find a SoundBlaster or compatible!');
          writeln;
          halt(1);
     end
     else
     begin
          { Load VOC file into memory }
          if (not LoadVoc('song.voc')) then
          begin
               writeln;
               writeln('Not enough free memory or file not found, cannot continue!');
               writeln;
               halt(1);
          end
          else
          begin
               { Tell the VOC routines to loop the sound forever
                 with a 2 second delay between loops }
               LoopVoc(TRUE, 36);
          end;
     end;


     { Play VOC file, assuming the SoundBlaster was initialized; if not
       it will do nothing }
     PlayVoc;

     repeat
           write('SONG.VOC is ');

           { Tell the user what the VOC player is doing }
           if (IsVOCPlaying) then
              write('playing')
           else
               write('paused for 2 seconds');

           writeln(', press any key to exit ...');

     until (keypressed);
     readkey;

     writeln;

     { There is nothing you need to call to close these routines
       it's all done automatically for you! }
end.