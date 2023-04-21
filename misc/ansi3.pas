{ANSI3.PAS}
UNIT Ansi3;

INTERFACE


USES Crt, Dos;

CONST
     RecANSI : BOOLEAN = FALSE;

PROCEDURE AnsiWrite (ch : CHAR);
PROCEDURE AnsiWriteLn (S : STRING);
PROCEDURE My_GotoXY (x,y : byte);
var   My_WhereX,My_WhereY,screen_bottom,ThisSeg : word;

IMPLEMENTATION


VAR
    Escape, Saved_X,
     Saved_Y              : BYTE;
    Control_Code          : STRING;



procedure my_gotoxy (X,Y : byte);
begin
    MY_WHEREX:=X;
    My_WhereY:=Y;

end;

  Procedure TABULATE;
  Var x:Integer;
  begin
    x:=MY_WhereX;
    if x<80 then
      Repeat
        Inc(x);
      Until (x MOD 8)=0;
    if x=80 then x:=1;
    my_GotoXY(x,my_WhereY);
    if x=1 then inc(my_whereY);
  end;

  Procedure BACKSPACE;
  Var x:Integer;
  begin
    if MY_WhereX>1 then
    begin
      Dec(My_WhereX);
      write(' ');
      Dec(My_WhereX);
    end
    else
      if My_WhereY>1 then begin
        My_GotoXY(80,My_WhereY-1);
        Write(' ');
        My_GotoXY(80,My_WhereY-1);
      end;
  end;



procedure write(ch : char);
begin

     case ch of

           ^G: begin
            Sound(2000);
            Delay(75);
            NoSound;
          end;
      ^H: Backspace;
      ^I: Tabulate;
      ^J: begin
            TextBackground(0);
            inc(my_whereY);
          end;
      ^K: my_GotoXY(1,1);
      ^L: begin
            TextBackground(0);
{            ClrScr;     }
            my_gotoXY(1,1);
          end;
      ^M: begin
            TextBackground(0);
            my_whereX:=1;
          end;
     else
     begin
          mem[ThisSeg:(160*(My_WhereY-1))+(2*(my_whereX-1))]:=ord(Ch);
          mem[ThisSeg:(160*(My_WhereY-1))+(2*(my_whereX-1))+1]:=TextAttr;
          inc(my_whereX);
          if my_wherex=81 then
          begin
             my_wherex:=1;
             inc(My_WhereY);
          end; {if my_wherex=81}
     end; {else}
     end; {case}

     if (MY_WhereY>Screen_bottom) then screen_bottom:=My_Wherey;

end;


FUNCTION GetNumber (VAR LINE : STRING) : INTEGER;

   VAR
     i, j, k         : INTEGER;
     temp0, temp1   : STRING;

  BEGIN
       temp0 := LINE;
       VAL (temp0, i, j);
      IF j = 0 THEN temp0 := ''
       ELSE
      BEGIN
         temp1 := COPY (temp0, 1, j - 1);
         DELETE (temp0, 1, j);
         VAL (temp1, i, j);
      END;
    LINE := temp0;
    GetNumber := i;
  END;

 PROCEDURE loseit;
    BEGIN
      escape := 0;
      control_code := '';
      RecANSI := FALSE;
    END;

 PROCEDURE Ansi_Cursor_move;

     VAR
      x, y       : INTEGER;

    BEGIN
     y := GetNumber (control_code);
     IF y = 0 THEN y := 1;
     x := GetNumber (control_code);
     IF x = 0 THEN x := 1;
     IF y > 25 THEN y := 25;
     IF x > 80 THEN x := 80;
     my_gotoxy (x, y);
    loseit;
    END;

PROCEDURE Ansi_Cursor_up;

 VAR
   y, new_y, offset          : INTEGER;

   BEGIN
     Offset := getnumber (control_code);
        IF Offset = 0 THEN offset := 1;
      y := My_WhereY;
      IF (y - Offset) < 1 THEN
             New_y := 1
          ELSE
             New_y := y - offset;
       my_gotoxy (My_WhereX, new_y);
  loseit;
  END;

PROCEDURE Ansi_Cursor_Down;

 VAR
   y, new_y, offset          : INTEGER;

   BEGIN
     Offset := getnumber (control_code);
        IF Offset = 0 THEN offset := 1;
      y := My_WhereY;
      IF (y + Offset) > 25 THEN
             New_y := 25
          ELSE
             New_y := y + offset;
       my_gotoxy (My_WhereX, new_y);
  loseit;
  END;

PROCEDURE Ansi_Cursor_Left;

 VAR
   x, new_x, offset          : INTEGER;

   BEGIN
     Offset := getnumber (control_code);
        IF Offset = 0 THEN offset := 1;
      x := My_WhereX;
      IF (x - Offset) < 1 THEN
             New_x := 1
          ELSE
             New_x := x - offset;
       my_gotoxy (new_x, My_WhereY);
  loseit;
  END;

PROCEDURE Ansi_Cursor_Right;

 VAR
   x, new_x, offset          : INTEGER;

   BEGIN
     Offset := getnumber (control_code);
        IF Offset = 0 THEN offset := 1;
      x := My_WhereX;
      IF (x + Offset) > 80 THEN
             New_x := 1
          ELSE
             New_x := x + offset;
       my_gotoxy (New_x, My_WhereY);
  loseit;
  END;

 PROCEDURE Ansi_Clear_Screen;

   BEGIN                         {   0J = cusor to Eos           }
     CLRSCR;                      {  1j start to cursor           }
     my_gotoxy(1,1);
     loseit;                       { 2j entie screen/cursor no-move}
   END;

 PROCEDURE Ansi_Clear_EoLine;
 var
 temP : byte;

   BEGIN
   temP:=my_whereX;
     repeat
           mem[ThisSeg:(160*(My_WhereY-1))+(2*(Temp-1))]:=ord(' ');
           mem[ThisSeg:(160*(My_WhereY-1))+(2*(temp-1))+1]:=TextAttr;
           inc(temp)
      until temp>80;
     loseit;
   END;


 PROCEDURE Reverse_Video;

 VAR
      tempAttr, tblink, tempAttrlo, tempAttrhi : BYTE;

 BEGIN
            LOWVIDEO;
            TempAttrlo := (TextAttr AND $7);
            tempAttrHi := (textAttr AND $70);
            tblink     := (textattr AND $80);
            tempattrlo := tempattrlo * 16;
            tempattrhi := tempattrhi DIV 16;
            TextAttr   := TempAttrhi + TempAttrLo + TBlink;
  END;


 PROCEDURE Ansi_Set_Colors;

 VAR
    temp0, Color_Code   : INTEGER;

    BEGIN
        IF LENGTH (control_code) = 0 THEN control_code := '0';
           WHILE (LENGTH (control_code) > 0) DO
           BEGIN
            Color_code := getNumber (control_code);
                CASE Color_code OF
                   0          :  BEGIN
                                   LOWVIDEO;
                                   TEXTCOLOR (LightGray);
                                   TEXTBACKGROUND (Black);
                                 END;
                   1          : HIGHVIDEO;
                   5          : TextAttr := (TextAttr OR $80);
                   7          : Reverse_Video;
                   30         : textAttr := (TextAttr AND $F8) + black;
                   31         : textattr := (TextAttr AND $f8) + red;
                   32         : textattr := (TextAttr AND $f8) + green;
                   33         : textattr := (TextAttr AND $f8) + brown;
                   34         : textattr := (TextAttr AND $f8) + blue;
                   35         : textattr := (TextAttr AND $f8) + magenta;
                   36         : textattr := (TextAttr AND $f8) + cyan;
                   37         : textattr := (TextAttr AND $f8) + Lightgray;
                   40         : TEXTBACKGROUND (black);
                   41         : TEXTBACKGROUND (red);
                   42         : TEXTBACKGROUND (green);
                   43         : TEXTBACKGROUND (yellow);
                   44         : TEXTBACKGROUND (blue);
                   45         : TEXTBACKGROUND (magenta);
                   46         : TEXTBACKGROUND (cyan);
                   47         : TEXTBACKGROUND (white);
                 END;
             END;
       loseit;
  END;


 PROCEDURE Ansi_Save_Cur_pos;

    BEGIN
      Saved_X := My_WhereX;
      Saved_Y := My_WhereY;
      loseit;
    END;


 PROCEDURE Ansi_Restore_cur_pos;

    BEGIN
      my_gotoxy (Saved_X, Saved_Y);
      loseit;
    END;


 PROCEDURE Ansi_check_code ( ch : CHAR);

   BEGIN
       CASE ch OF
            '0'..'9', ';'     : control_code := control_code + ch;
            'H', 'f'          : Ansi_Cursor_Move;
            'A'              : Ansi_Cursor_up;
            'B'              : Ansi_Cursor_Down;
            'C'              : Ansi_Cursor_Right;
            'D'              : Ansi_Cursor_Left;
            'J'              : Ansi_Clear_Screen;
            'K'              : Ansi_Clear_EoLine;
            'm'              : Ansi_Set_Colors;
            's'              : Ansi_Save_Cur_Pos;
            'u'              : Ansi_Restore_Cur_pos;
            '?'              :;
        ELSE
          loseit;
        END;
   END;


PROCEDURE AnsiWrite (ch : CHAR);

VAR
  temp0      : INTEGER;

BEGIN
       IF escape > 0 THEN
          BEGIN
              CASE Escape OF
                1    : BEGIN
                         IF ch = '[' THEN
                            BEGIN
                              escape := 2;
                              Control_Code := '';
                            END
                         ELSE
                             escape := 0;
                       END;
                2    : Ansi_Check_code (ch);
              ELSE
                BEGIN
                   escape := 0;
                   control_code := '';
                   RecANSI := FALSE;
                END;
              END;
          END
       ELSE
         BEGIN
          CASE Ch OF
             #27       : Escape := 1;
             #9        : BEGIN
                            temp0 := My_WhereX;
                            temp0 := temp0 DIV 8;
                            temp0 := temp0 + 1;
                            temp0 := temp0 * 8;
                            my_gotoxy (temp0, My_WhereY);
                         END;
          ELSE
                 BEGIN
                    IF ( (My_WhereX = 80) AND (My_WhereY = 25) ) THEN
                      BEGIN
                        windmax := (80 + (24 * 256) );
                        WRITE (ch);
                        windmax := (79 + (24 * 256) );
                      END
                    ELSE
                      WRITE (ch);
                    escape := 0;
                 END;
           END;
         END;
  RecANSI := (Escape <> 0);
  END;

PROCEDURE AnsiWriteLn (S : STRING);
VAR I : BYTE;
BEGIN
FOR I := 1 TO LENGTH (S) DO Ansiwrite (S [i]);
END;
begin
     ThisSeg:=Segb800;
END.


