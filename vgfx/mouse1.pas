{ VGFX Mouse routine demo }

uses Crt, VGFX;

{ Misc. demo variables }
var
   b1, b2, b3: boolean;


{ Main Program }
Begin
     { Initialize VGFX }
     VGFX_Init;

     { Initialize the mouse driver & routines }
     If (MInit = -1) then
     begin
          { No mouse driver found }
          VGFX_Done;
          writeln;
          writeln;
          writeln ('Sorry this demo requires a mouse!');
          writeln;
          halt(1);
     end;  { if\then }


     { Turn the mouse cursor on }
     MShow (1);
     repeat
           { Print the mouses' coords }
           vprint ('Mouse''s X Coord: ' + Int2Str(mX), 15, 15, 1, 255);
           vprint ('Mouse''s Y Coord: ' + Int2Str(mY), 15, 30, 1, 255);

           { Get the mouse button status }
           MPress(b1, b2, b3);

           if (b1) then
              vprint ('Button 1 is pressed!', 15, 45, 1, 255);

           if (b2) then
              vprint ('Button 2 is pressed!', 15, 55, 1, 255);

           if (b3) then
              vprint ('Button 3 is pressed!', 15, 65, 1, 255);

           if ((not b1) and (not b2) and (not b3)) then
              vprint ('No buttons are pressed!', 15, 45, 1, 255);


           { Update the mouse cursor }
           MMove;
           Update;

     Until (KeyPressed);


     { Shut-down VGFX and clean up it's mess }
     VGFX_Done;
End.  { Program }
