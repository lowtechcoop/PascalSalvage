{ VGFX: Manual "Page-Flipping" Demo!

  GUYDEMO.PAS was written to show you the difference between using
  the Update procedure for "page-flipping" animations and programming
  the "page-flips" manually.  As you will see the Update engine is
  running much slower than the manual engine.  This is because Update
  is redrawing the whole screen to keep the background updated.  By
  manually keeping track of the "page-flips" you achieve a lot faster
  animation.  The disadvantage to manually "page-flipping" is that a
  lot more programming is required.  If you are using VGFX and
  writing a game that requires a 486SX-20 or better, than I would
  suggest using Update.  If your game requires a 386SX or better than
  you may want to use manual "page-flipping".  Another disadvantage
  to manual "page-flipping" is that some routines in VGFX do support
  the manual method.  For example, the mouse routines.  Although you
  can use MShow and MPress, MMove will not work.  If you call MMove
  without Update, the mouse will leave "trails" behind.  You will have
  to keep track of that on your own.  This may seem like a bit of a
  drag, but if you have already figured out the code for manually
  updating your game sprites (animations) then you can easily use the
  same method on the mouse cursor.  The are two global variables in
  VGFX, mX and mY.  These two variables are the current mouse coords.
  We would suggest creating two var's: lastX and lastY.  Here is some
  theory on to as how you could do that.  We have not tested but it
  seems straightforward.

  *** THEORY ***
  ==============

  mX = 10
  mY = 10

  lastX = mX
  lastY = mY

  start of the loop

        Undraw the mouse cursor

        MMove is called - this gets the new mouse position
          * New Mouse position was calculated by MMove. mX and mY
            both equal the new mouse position (if it was moved).

        lastX = mX
        lastY = mY

  end of loop                                                           }

program VGFX_Demo;


uses VGFX, crt, dos;


{ Declare our memory needed for sprites }
type
    guyc = array[1..975] of byte;
    tree = array[1..6059] of byte;

{ Misc. demo variables }
var
   tmp      : integer;
   x, y     : integer;
   key      : char;
   man      : array[1..8] of ^guyc;
   backg    : ^guyc;
   btree    : ^tree;


{ Small little 'RPG-game' like demo }
{ - - - - - - }
Procedure Game_SampleDemo;
Var
   WalkL, WalkR,
   StandL, StandR: Boolean;
   Quit          : Boolean;
   fname         : string;
   cnum,
   speed         : byte;
   tmpPage       : byte;

Begin

     { Allocate some memory for our little guy }
     for tmp := 1 to 8 do
         new (man[tmp]);

     new (btree);

     { Set the palette to black }
     BlankPalette;
     SetWorkPage (1);


     { Load-up the animation cells into memory }
     for tmp := 1 to 8 do
     begin
          fname := 'cel000' + INT2STR(tmp) + '.pcx';

          showpcx (fname, 1, 1);
          GetImage (man[tmp]^, 145, 38, 25, 39);
     end;  { end for\do }


     { Load-up the tree as we will use it later }
     showpcx ('bigtree2.pcx', 1, 1);
     GetImage (btree^, 1, 1, 73, 83);


     { Set the palette to black }
     BlankPalette;

     { Clear the video pages }
     SetWorkPage (1);
     clearscreen (0);
     SetWorkPage (2);
     clearscreen (0);

     { Initialize the mouse driver }
     MInit;

     { Make the mouse cursor visible }
     MShow (1);

     { Show message box #1 }
     showpcx ('msg1b.pcx', 1, 1);
     showpcx ('msg1b.pcx', 0, 2);

     FlushKB;

     repeat
           { Update Mouse }
           MMove;

           { Check for mouse clicks }
           MClick(0);

           { Update display }
           Update;
     until ((keypressed) or (btnP<>0));


     { Show message box #2 }
     showpcx ('msg2b.pcx', 1, 1);
     showpcx ('msg2b.pcx', 1, 2);

     FlushKB;

     repeat
           { Update Mouse }
           MMove;

           { Check for mouse clicks }
           MClick(0);

           { Update display }
           Update;
     until ((keypressed) or (btnP<>0));


     { Fade-out the palette }
     FadeOut (1, 1, 0);

     { Set the palette to black }
     BlankPalette;

     { Clear the video pages }
     SetWorkPage (1);
     clearscreen (0);
     SetWorkPage (2);
     clearscreen (0);

     { Load-up the background scene on both video pages }
     showpcx ('demo.pcx', 1, 1);
     showpcx ('demo.pcx', 1, 2);

     { Put the little guy on the screen }
     PutClip (man[1]^, 100, 80, 25, 39);

     { Restore the palette }
     RestorePalette;


     x     := 100;
     y     := 80;
     cnum  := 1;
     speed := 2;
     StandL:= TRUE;
     StandR:= FALSE;
     WalkL := FALSE;
     WalkR := FALSE;
     Quit  := FALSE;

     FlushKB;
     repeat
           if (keypressed) then
           begin
                key := readkey;

                if (upcase(key) = 'Q') then Quit := TRUE;

                { Increase guy's speed }
                if (key = '+') then
                begin
                     inc(speed);
                     if (speed > 50) then
                     begin
                          speed := 50;
                          sound (900);
                          delay (10);
                          nosound;
                     end;  { end if\then }
                end;  { end if\then }

                { Decrease guy's speed }
                if (key = '-') then
                begin
                     dec(speed);
                     if (speed < 1) then
                     begin
                          speed := 1;
                          sound (900);
                          delay (10);
                          nosound;
                     end;  { end if\then }
                end;  { end if\then }


                { Check for extended keystroke (arrow keys) }
                if (key=chr(0)) then
                begin
                     key := readkey;

                     { Right Arrow }
                     if (key = #77) then
                     begin
                          StandL:= FALSE;
                          StandR:= FALSE;
                          WalkL := FALSE;

                          if (WalkR) then
                          begin
                               WalkR := FALSE;
                               StandR:= TRUE;
                          end  { end if\then }
                          else WalkR := TRUE;
                     end;

                     { Left Arrow }
                     if (key = #75) then
                     begin
                          StandL:= FALSE;
                          StandR:= FALSE;
                          WalkR := FALSE;
                          if (WalkL) then
                          begin
                               WalkL := FALSE;
                               StandL := TRUE;
                          end  { end if\then }
                          else WalkL := TRUE;
                     end;
                end;
           end;

           if (StandL) then PutClip (man[1]^, x, y, 25, 39);
           if (StandR) then FlipClip (man[1]^, x, y, 25, 39);

           if (WalkL) then
           begin
                dec(x,speed);
                PutClipD (man[cnum]^, x, y, 25, 39);
                inc(cnum);
                if (cnum > 8) then cnum := 1;
           end;  { end if\then }

           if (WalkR) then
           begin
                inc(x,speed);
                FlipClip (man[cnum]^, x, y, 25, 39);
                inc(cnum);
                if (cnum > 8) then cnum := 1;
           end;  { end if\then }

           PutImage (btree^, 33, 64, 73, 83);

           { Update mouse cursor }
           MMove;

           { Check for mouse button clicks }
           MClick (0);

           if (btnP<>0) then
           begin

                if ((btnX < x) and (btnY<166)) then
                begin
                     StandL:= FALSE;
                     StandR:= FALSE;
                     WalkR := FALSE;
                     if (WalkL) then
                     begin
                          WalkL := FALSE;
                          StandL := TRUE;
                     end  { end if\then }
                     else WalkL := TRUE;
                end;

                if ((btnX > x) and (btnY<166)) then
                begin
                     StandL:= FALSE;
                     StandR:= FALSE;
                     WalkL := FALSE;

                     if (WalkR) then
                     begin
                          WalkR := FALSE;
                          StandR:= TRUE;
                     end  { end if\then }
                     else WalkR := TRUE;
                end;

                if (btnX >= 272) and (btnX <= 309) then
                   if (btnY >= 178) and (btnY <= 187) then Quit:=true;
           end;

           { Update the video screen }
           Update;

     until (Quit);

     { Tidy up the loop- make sure the other page is reset }
     Update;

     tmpPage := GetWorkPage;
     SetWorkPage (4);
     vprint ('Same demo with manual "page-flipping"!', 10, 150, 1, 255);
     Update;
     Update;
     SetWorkPage (tmpPage);
End;  { Procedure }



{ - - - - - - }
Procedure Game_SampleDemo2;
Var
   WalkL, WalkR,
   StandL, StandR   : Boolean;
   Quit             : Boolean;
   fname            : string;
   cnum,
   speed            : byte;
   whichpage        : byte;         { Used for manual page flipping }

Begin
     { Allocate memory for keeping track of the background redraw }
     new (backg);

     { Make sure the mouse cursor is turned off for the second demo. }
     MShow (0);

     if (x < 11) then x := 10;
     if (x > 289) then x := 289;
     cnum  := 1;
     speed := 2;
     StandL:= TRUE;
     StandR:= FALSE;
     WalkL := FALSE;
     WalkR := FALSE;
     Quit  := FALSE;

     FlushKB;
     repeat
           if (keypressed) then
           begin
                key := readkey;

                if (upcase(key) = 'Q') then Quit := TRUE;

                { Increase guy's speed }
                if (key = '+') then
                begin
                     inc(speed);
                     if (speed > 3) then
                     begin
                          speed := 3;
                          sound (900);
                          delay (10);
                          nosound;
                     end;  { end if\then }
                end;  { end if\then }

                { Decrease guy's speed }
                if (key = '-') then
                begin
                     dec(speed);
                     if (speed < 1) then
                     begin
                          speed := 1;
                          sound (900);
                          delay (10);
                          nosound;
                     end;  { end if\then }
                end;  { end if\then }


                { Check for extended keystroke (arrow keys) }
                if (key=chr(0)) then
                begin
                     key := readkey;

                     { Right Arrow }
                     if (key = #77) then
                     begin
                          StandL:= FALSE;
                          StandR:= FALSE;
                          WalkL := FALSE;

                          if (WalkR) then
                          begin
                               WalkR := FALSE;
                               StandR:= TRUE;
                          end  { end if\then }
                          else WalkR := TRUE;
                     end;

                     { Left Arrow }
                     if (key = #75) then
                     begin
                          StandL:= FALSE;
                          StandR:= FALSE;
                          WalkR := FALSE;
                          if (WalkL) then
                          begin
                               WalkL := FALSE;
                               StandL := TRUE;
                          end  { end if\then }
                          else WalkL := TRUE;
                     end;
                end;
           end;

           if (StandL) then PutImage (man[1]^, x, y, 25, 39);
           if (StandR) then FlipImage (man[1]^, x, y, 25, 39);

           if (WalkL) then
           begin
                dec(x,speed);
                if (x <= 10) then
                begin
                     WalkL := FALSE;
                     StandL := TRUE;
                     WalkR := FALSE;
                     StandR := FALSE;
                     x := 11;
                end;  { end if\then }
                PutImage (man[cnum]^, x, y, 25, 39);
                inc(cnum);
                if (cnum > 8) then cnum := 1;
           end;  { end if\then }

           if (WalkR) then
           begin
                inc(x,speed);
                if (x > 290) then
                begin
                     WalkR := FALSE;
                     StandR := TRUE;
                     WalkL := FALSE;
                     StandL := FALSE;
                     x := 289;
                end;  { end if\then }
                FlipImage (man[cnum]^, x, y, 25, 39);
                inc(cnum);
                if (cnum > 8) then cnum := 1;
           end;  { end if\then }

           PutImage (btree^, 33, 64, 73, 83);

           { Update the video screen }
           whichpage := GetWorkPage;
           SetWorkPage (4);
           GetImage (backg^, (x - speed), y, 25, 39);

           if (whichpage = 1) then
           begin
                showpage (1);
                SetWorkPage (2);
                PutImage (backg^, (x - speed), y, 25, 39);
           end
           else
           begin
                showpage (2);
                SetWorkPage (1);
                PutImage (backg^, (x - speed), y, 25, 39);
           end;  { else }

     until (Quit);

     FadeOut (1, 1, 0);

     { Clear the video pages }
     SetWorkPage (1);
     clearscreen (0);
     SetWorkPage (2);
     clearscreen (0);

     { Restore the palette }
     RestorePalette;


     { Free the memory we allocated earlier }
     dispose (backg);
     dispose (btree);

     for tmp := 1 to 8 do
         dispose (man[tmp]);

End;  { Procedure }



{ ************************** }
{      Main Procedure        }
{ ************************** }
Begin
     { Tell VGFX to use DEMO.GFX for all it's file handling }
     SetWorkLib ('demo.gfx');

     { Initialize VGFX }
     VGFX_Init;


     { Set Palette to Black }
     BlankPalette;

     { Do the demo! }
     Game_SampleDemo;
     Game_SampleDemo2;

     { Shut-down VGFX and clean up it's mess }
     VGFX_Done;
End.  { Program }
