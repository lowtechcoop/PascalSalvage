{ VGFX Demo Program v1.00 - (C) Copyright 1994 Bill Quesnel }

program VGFX_Demo;


uses VGFX, crt, dos;

{$I vgfx.inc}

{ Declare our memory needed for sprites }
type
    celA = array[1..195] of byte;
    celB = array[1..525] of byte;
    celC = array[1..891] of byte;
    guyc = array[1..975] of byte;
    tree = array[1..6059] of byte;

{ Misc. demo variables }
var
   cel1  : ^celA;
   cel2  : ^celB;
   cel3  : ^celC;
   tmp   : integer;
   x, y  : integer;
   key   : char;
   man   : array[1..8] of ^guyc;
   btree : ^tree;



{ Do Ball demo #1 }
{ - - - - - - }
Procedure Ball1;
Var
   x, y : array[1..25] of integer;
   hit  : array[1..25] of byte;
   hitY : array[1..25] of byte;
   m    : byte;
   c    : char;
   FOut,
   Quit,
   FIn  : Boolean;

Begin
     { Set palette to black }
     BlankPalette;

     { Load up our images }
     ShowPcx ('balls.pcx', 1, 1);

     { Get images into memory }
     SetWorkPage(1);
     GetImage (cel1^, 10, 7, 15, 13);
     GetImage (cel2^, 45, 7, 25, 21);
     GetImage (cel3^, 96, 7, 33, 27);

     { Load up our background fractal }
     ShowPcx ('frac.pcx', 1, 1);

     { Initialize the mouse driver }
     MInit;

     { Fade-in the screen }
     FadeIn (1, 1, 0);


     { Make the mouse cursor visible }
     MShow (1);
     FOut := FALSE;

     for tmp := 1 to 25 do
     begin
          x[tmp]   := random(300);
          y[tmp]   := random(175);
          hit[tmp] := random(2);
          hitY[tmp]:= random(2);
     end;  { end for\do }

     FOut := FALSE;
     FIn  := FALSE;
     Quit := FALSE;

     { Set VGFX's visual page to 1 }
     SetWorkPage(1);
     FlushKB;

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


           { Put the images on the screen!  All balls in this block will
             be behind the text }
           PutClip(cel1^, x[1], y[1], 15, 13);
           PutClip(cel1^, x[2], y[2], 15, 13);
           PutClip(cel1^, x[3], y[3], 15, 13);
           PutClip(cel1^, x[4], y[4], 15, 13);
           PutClip(cel1^, x[5], y[5], 15, 13);
           PutClip(cel1^, x[6], y[6], 15, 13);
           PutClip(cel1^, x[7], y[7], 15, 13);
           PutClip(cel1^, x[8], y[8], 15, 13);
           PutClip(cel1^, x[9], y[9], 15, 13);
           PutClip(cel1^, x[10], y[10], 15, 13);
           PutClip(cel2^, x[11], y[11], 25, 21);
           PutClip(cel2^, x[12], y[12], 25, 21);
           PutClip(cel2^, x[13], y[13], 25, 21);
           PutClip(cel2^, x[14], y[14], 25, 21);
           PutClip(cel3^, x[25], y[25], 33, 27);

           { Print our little message to the screen }
           VPrint ('Q to Quit', 10, 153, 15, 255);
           VPrint ('O to fade out', 10, 163, 9, 255);
           VPrint ('I to fade in', 10, 173, 1, 255);
           VPrint ('S to stop fade', 10, 183, 9, 255);

           { Now put somemore images to the screen, All balls in this block
             will be infront of the text }
           PutClip(cel2^, x[15], y[15], 25, 21);
           PutClip(cel2^, x[16], y[16], 25, 21);
           PutClip(cel2^, x[17], y[17], 25, 21);
           PutClip(cel2^, x[18], y[18], 25, 21);
           PutClip(cel2^, x[19], y[19], 25, 21);
           PutClip(cel2^, x[20], y[20], 25, 21);
           PutClip(cel2^, x[21], y[21], 25, 21);
           PutClip(cel3^, x[22], y[22], 33, 27);
           PutClip(cel3^, x[23], y[23], 33, 27);
           PutClip(cel3^, x[24], y[24], 33, 27);

           { Update the mouse cursor, if you don't call this the mouse
             will not be updated correctly! }
           MMove;

           { Now update the screen with all of our new stuff }
           Update;


           { Now check for user activity }
           if (keypressed) then
           begin
                c := upcase(readkey);

                case c of
                     'Q': Quit := TRUE;
                     'S': begin
                               FOut := FALSE;
                               FIn := FALSE;
                          end;
                     'O': begin
                               FIn := FALSE;
                               if (FOut) then FOut := FALSE
                                  else FOut := TRUE;
                          end;
                     'I': begin
                               FOut := FALSE;
                               if (FIn) then FIn := FALSE
                                  else FIn := TRUE;
                          end;
                end; { end case }
           end;

           If (FOut) then FadeOutStep (1, 0, 0);
           If (FIn) then FadeInStep (1, 0, 0);

     until (Quit = TRUE);

     { Fade-out the screen }
     FadeOut (1, 1, 0);

     { Clear both video pages }
     SetWorkPage (1);
     clearscreen (0);
     SetWorkPage (2);
     clearscreen (0);

End;  { Procedure }


{ Do Balls demo #2 }
{ - - - - - - }
Procedure Ball2;
const
     maxstars = 100;

Var
   x, y  : array[1..25] of integer;
   hit,
   hitY  : array[1..25] of byte;
   stars : array[0..200] of array[0..3] of integer;
   c     : char;
   m,
   scolor: byte;
   Quit,
   FOut,
   FIn   : Boolean;
   i,
   speed : integer;

Begin
     { Set palette to black }
     BlankPalette;

     SetWorkPage(1);

     { Load-up our images }
     ShowPcx ('balls.pcx', 1, 1);

     { Get images into memory }
     GetImage (cel1^, 10, 7, 15, 13);
     GetImage (cel2^, 45, 7, 25, 21);
     GetImage (cel3^, 96, 7, 33, 27);

     { Clear the video page }
     SetWorkPage (1);
     clearscreen (0);

     FOut := FALSE;

     for tmp := 1 to 25 do
     begin
          x[tmp] := random(300);
          y[tmp] := random(175);
          hit[tmp] := random(2);
          hitY[tmp] := random(2);
     end;  { end for\do }

     speed := 5;

     { Init stars }
     for i := 0 to maxstars do
     begin
          stars[i,0] := random(319);
          stars[i,1] := random(199);

          { Star Speed }
          stars[i,3] := random(speed) + 1;

          case stars[i,3] of
               1 : stars[i,2] := 26 + random(5);
               2 : stars[i,2] := 23 + random(5);
          else
              stars[i,2] := 18 + random(5);
          end;  { end case }
     end;  { end for\do }

     FOut := FALSE;
     FIn  := FALSE;
     Quit := FALSE;


     { Initialize and show mouse }
     MInit;
     MShow (1);

     { Restore palette to normal }
     RestorePalette;
     FlushKB;

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
                     1 : inc(x[m],5);
                     0 : dec(x[m],5);
                end; { end case }

                Case hitY[m] of
                     1 : inc(y[m],5);
                     0 : dec(y[m],5);
                end; { end case }
           end;  { end for\do }

           for m := 11 to 14 do
           begin
                if (x[m] > 294) then hit[m] := 0;
                if (x[m] < 1)   then hit[m] := 1;
                if (y[m] > 179) then hitY[m]:= 0;
                if (y[m] < 1)   then hitY[m]:= 1;

                Case hit[m] of
                     1 : inc(x[m],5);
                     0 : dec(x[m],5);
                end; { end case }

                Case hitY[m] of
                     1 : inc(y[m],5);
                     0 : dec(y[m],5);
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


           { Update starfield }
           for i:= 0 to maxstars do
           begin
                inc(stars[i,1],stars[i,3]);

                if (stars[i,1] > 199) then
                begin
                     stars[i,0] := random(319);
                     stars[i,1] := 0;
                     stars[i,3] := random(speed) + 1;

                     case stars[i,3] of
                          1 : stars[i,2] := 26 + random(5);
                          2 : stars[i,2] := 23 + random(5);
                     else
                         stars[i,2] := 18 + random(5);
                     end;  { end case }
                end;  { end for\do }

                { Draw the stars }
                putpixel (stars[i,0], stars[i,1], stars[i,2]);

           end;  { End of star field update }


           { Put the images on the screen!  All balls in this block will
             be behind the text }
           PutClip(cel1^, x[1], y[1], 15, 13);
           PutClip(cel1^, x[2], y[2], 15, 13);
           PutClip(cel1^, x[3], y[3], 15, 13);
           PutClip(cel1^, x[4], y[4], 15, 13);
           PutClip(cel1^, x[5], y[5], 15, 13);
           PutClip(cel1^, x[6], y[6], 15, 13);
           PutClip(cel1^, x[7], y[7], 15, 13);
           PutClip(cel1^, x[8], y[8], 15, 13);
           PutClip(cel1^, x[9], y[9], 15, 13);
           PutClip(cel1^, x[10], y[10], 15, 13);
           PutClip(cel2^, x[11], y[11], 25, 21);
           PutClip(cel2^, x[12], y[12], 25, 21);
           PutClip(cel2^, x[13], y[13], 25, 21);
           PutClip(cel2^, x[14], y[14], 25, 21);
           PutClip(cel3^, x[25], y[25], 33, 27);

           { Print our little message to the screen }
           VPrint ('Q to Quit', 10, 153, 15, 255);
           VPrint ('O to fade out', 10, 163, 9, 255);
           VPrint ('I to fade in', 10, 173, 1, 255);
           VPrint ('S to stop fade', 10, 183, 9, 255);

           { Now put somemore images to the screen, All balls in this block
             will be infront of the text }
           PutClip(cel2^, x[15], y[15], 25, 21);
           PutClip(cel2^, x[16], y[16], 25, 21);
           PutClip(cel2^, x[17], y[17], 25, 21);
           PutClip(cel2^, x[18], y[18], 25, 21);
           PutClip(cel2^, x[19], y[19], 25, 21);
           PutClip(cel2^, x[20], y[20], 25, 21);
           PutClip(cel2^, x[21], y[21], 25, 21);
           PutClip(cel3^, x[22], y[22], 33, 27);
           PutClip(cel3^, x[23], y[23], 33, 27);
           PutClip(cel3^, x[24], y[24], 33, 27);

           { Update the mouse cursor }
           MMove;

           { Now update the screen with all of our new stuff }
           Update;

           { Now check for user activity }
           if (keypressed) then
           begin
                c := upcase(readkey);

                case c of
                     'Q': Quit := TRUE;
                     'S': begin
                               FOut := FALSE;
                               FIn := FALSE;
                          end;
                     'O': begin
                               FIn := FALSE;
                               if (FOut) then FOut := FALSE
                                  else FOut := TRUE;
                          end;
                     'I': begin
                               FOut := FALSE;
                               if (FIn) then FIn := FALSE
                                  else FIn := TRUE;
                          end;
                end; { end case }
           end;

           If (FOut) then FadeOutStep (1, 0, 0);
           If (FIn) then FadeInStep (1, 0, 0);

     until (Quit = TRUE);

     { Fade-out the screen }
     FadeOut (1, 1, 0);

     { Clear both video pages }
     SetWorkPage (1);
     clearscreen (0);
     SetWorkPage (2);
     clearscreen (0);
End;  { Procedure }


{ Input device demo }
{ - - - - - - }
Procedure Input_Demo;
var
   Quit         : boolean;
   trail        : boolean;
   jLeft, jUp,
   jRight, jDown: Boolean;
   B1, B2       : Boolean;
   oldX, oldY   : integer;

Begin
     BlankPalette;

     SetWorkPage(1);

     { Load-up our images }
     ShowPcx ('balls.pcx', 1, 1);

     { Get images into memory }
     GetImage (cel2^, 45, 7, 25, 21);

     { Clear video page }
     SetWorkPage (1);
     clearscreen (0);

     { Restore palette }
     RestorePalette;

     Quit := FALSE;
     trail:= FALSE;
     x    := 100;
     y    := 100;

     { Initialize mouse driver }
     MInit;

     { Make the mouse cursor visible }
     MShow (1);

     { Initialize the joystick routines & calibrate the joystick }
     Init_Joy;

     FlushKB;

     repeat
           if (keypressed) then
           begin
                key := upcase(readkey);
                if (key = 'Q') then Quit := TRUE;
           end;  { end if\then }

           if (btnP<>0) then
           begin
                trail:= TRUE;
                oldX := mX - 13;
                oldY := mY - 10;
           end;  { end if\then }

           if (trail) then
           begin
                if (x > oldX) then dec(x,5);
                if (x < oldX) then inc(x,5);
                if (y > oldY) then dec(y,5);
                if (y < oldY) then inc(y,5);

                if (mX = x) AND (mY = y) then trail := FALSE;
           end;  { end if\then }

           GetJoy (jLeft, jRight, jUp, jDown, B1, B2, B2, B2);

           if (jLeft) or (jRight) or (jUp) or (jDown) then trail := FALSE;

           if (jLeft)  then dec(x,3);
           if (jRight) then inc(x,3);
           if (jUp)    then dec(y,3);
           if (jDown)  then inc(y,3);


           { Put ball on screen }
           PutClip (cel2^, x, y, 25, 21);

           { Show our little message }
           VPrint('Use mouse/joystick and click a spot, the',0,10,1,255);
           VPrint('ball will then move to that spot.',0,20,1,255);
           VPrint ('Q = Quit', 10, 190, 1, 255);

           { Update mouse cursor }
           MMove;

           { Check for mouse button presses }
           MClick (0);

           { Update video screen }
           Update;

     until (Quit);

End;  { Procedure }


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

Begin

     { Allocate some memory for our little guy }
     for tmp := 1 to 8 do
         new (man[tmp]);

     new (btree);

     { Set the palette to black }
     BlankPalette;

     SetWorkPage(1);

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
     showpcx ('msg1b.pcx', 0, 3);

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
     showpcx ('msg2b.pcx', 1, 3);

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
                PutClip (man[cnum]^, x, y, 25, 39);
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

     FadeOut (1, 1, 0);

     { Clear the video pages }
     SetWorkPage (1);
     clearscreen (0);
     SetWorkPage (2);
     clearscreen (0);

     { Restore the palette }
     RestorePalette;


     { Free the memory we allocated earlier }
     dispose (btree);

     for tmp := 1 to 8 do
         dispose (man[tmp]);

End;  { Procedure }


{ Font demo }
{ - - - - - - }
Procedure Font_Demo;
var
  Quit          : Boolean;
  underline,
  doublehigh,
  doublewide,
  italics       : Boolean;
  whichfont     : longint;

Begin
     { Clear both video pages }
     SetWorkPage (1);
     clearscreen (0);
     SetWorkPage (2);
     clearscreen (0);

     SetWorkPage(1);

     whichfont := 0;
     underline := FALSE;
     italics   := FALSE;
     doublewide:= FALSE;
     doublehigh:= FALSE;


     { Load-up the first font }
     LoadFont ('fonts.bin', whichfont);


     SetRGB(9,9,40,9);
     Quit := FALSE;
     repeat
           { Print our little message, BTW VPrint uses regular BIOS text
             font, whereas FontPrint uses one of the 30 fonts in VGFX }
           VPrint ('Up\down arrow keys to cycle fonts:', 10, 5, 1, 255);
           VPrint ('Toggles: U-underline,  I-italics', 10, 20, 12, 255);
           VPrint ('         W-doublewide, H-doublehigh', 10, 30, 12, 255);
           VPrint ('Q = Quit', 10, 190, 1, 255);


           { Set the font 'style' (enhancment) }
           FontStyle (underline, italics, doublewide, doublehigh);

           { Print some text using the current font }
           FontPrint ('This is the '+FontNames[whichfont]+' font!',10, 50, 9);
           FontPrint ('1234567890!&*()+-\/[]{}',10, 110, 9);

           { Update the display }
           Update;

           key := UpCase(readkey);

           if (key = 'Q') then Quit := TRUE;

           { Check to see if the user has changed the font style }
           Case (Key) of
                'U': If (underline) then underline := FALSE
                      else underline := TRUE;

                'I': If (italics) then italics := FALSE
                      else italics := TRUE;

                'W': If (doublewide) then doublewide := FALSE
                      else doublewide := TRUE;

                'H': If (doublehigh) then doublehigh := FALSE
                      else doublehigh := TRUE;
           End;  { end case }


           { Check to see if the user is cycling through the fonts }
           if (key = chr(0)) then
           begin
                Case (ReadKey) Of
                     #80 : begin
                                dec(whichfont);
                                if (whichfont < 0) then whichfont := 30;
                                LoadFont ('fonts.bin', whichfont);
                           end;
                     #72 : begin
                                inc(whichfont);
                                if (whichfont > 30) then whichfont := 0;
                                LoadFont ('fonts.bin', whichfont);
                           end;
                end;  { end case }
           end;  { end if\then }

           { Let the user know what font styles are active }
           if (underline) then VPrint ('U', 10, 180, 1, 255);
           if (italics) then VPrint ('I', 20, 180, 1, 255);
           if (doublewide) then VPrint ('W', 30, 180, 1, 255);
           if (doublehigh) then VPrint ('H', 40, 180, 1, 255);

     until (Quit);


     { Fade-out the palette }
     FadeOut (1, 1, 0);

     { Clear the video pages }
     SetWorkPage (1);
     clearscreen (0);
     SetWorkPage (2);
     clearscreen (0);
End;  { Procedure }



{ ************************** }
{      Main Procedure        }
{ ************************** }
Begin
     { Tell VGFX to use DEMO.GFX for all it's file handling }
     if (not SetWorkLib ('demo.gfx')) then
     begin
          writeln;
          writeln('Sorry, but I cannot find DEMO.GFX, this file is required for the demo!');
          writeln;
          halt(1);
     end;

     { Initialize SoundBlaster or compatible }
     if (not SB_Init(5, 1, $220)) then
     begin
          writeln;
          writeln('Sorry, but I cannot find a SoundBlaster or compatible ...');
          writeln;
          writeln('So you''re gonna have to see this demo and not hear it!');
          writeln;
          write('Press any key to continue ...');
          readkey;
     end
     else
     begin
          { Load VOC file into memory }
          if (not LoadVoc('song.voc')) then
          begin
               writeln;
               writeln('Not enough free memory or file not found, sound will be disabled!');
               writeln;
               write('Press any key to continue ...');
               readkey;
          end
          else
          begin
               { Tell the VOC routines to loop the sound forever
                 with a 2 second delay between loops }
               LoopVoc(TRUE, 36);
          end;
     end;


     { Initialize VGFX }
     VGFX_Init;


     { Allocate memory }
     New (cel1);
     New (cel2);
     New (cel3);


     { Play VOC file, assuming the SoundBlaster was initialized; if not
       it will do nothing }
     PlayVoc;


     { Set Palette to Black }
     BlankPalette;

     { Load-up our intro screen }
     showpcx ('intro.pcx', 1, 1);

     { Fade-in the palette }
     FadeIn (1, 1, 0);

     FlushKB;
     readkey;

     { Do the demos! }
     Ball1;
     Ball2;
     Input_Demo;
     Game_SampleDemo;
     Font_Demo;


     { Free the memory we allocated earlier }
     Dispose (cel3);
     Dispose (cel2);
     Dispose (cel1);


     { Shut-down VGFX and clean up it's mess }
     VGFX_Done;
End.  { Program }
